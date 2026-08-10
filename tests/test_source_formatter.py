from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from tools.source_formatter import _display_column, format_asm_lines, format_relabel_data


class SourceFormatterTests(unittest.TestCase):
    def test_instruction_comments_align_to_longest_normal_instruction(self):
        lines = [
            "\tswap\td2\t;4842  ",
            "\tadd.b\tScroll_TowerOffsets_DataTable(pc,d0.w),d1\t;D23B0026",
            "\tmove.w\t#$FFFF,PhysicalAttack_DoubleDefenceFlag.l\t;33FCFFFF00006458",
        ]
        result = format_asm_lines(lines)
        comment_columns = {
            _display_column(line.split(";", 1)[0]) for line in result
        }
        self.assertEqual(comment_columns, {80})
        self.assertIn("\tswap\td2", result[0])

    def test_overlong_instruction_is_not_used_as_alignment_target(self):
        lines = [
            "\tmove.b\tShort_Name,d0\t;short",
            "\tmove.b\tChampionPocket_CountedObjectCountsOffset(a6,d1.w),HeldItem_QuantityByteOffset(a5)\t;long",
        ]
        result = format_asm_lines(lines)
        self.assertEqual(_display_column(result[0].split(";", 1)[0]), 80)
        self.assertGreater(_display_column(result[1].split(";", 1)[0]), 80)

    def test_labels_and_long_comments_are_wrapped(self):
        comment = "This is a deliberately long generated comment which should wrap at a word boundary rather than splitting one of its words."
        result = format_asm_lines(["\tExample_Label:  ", "\t; " + comment])
        self.assertEqual(result[0], "Example_Label:")
        self.assertTrue(all(len(line) <= 80 for line in result))
        self.assertEqual(" ".join(line[3:] for line in result[1:]), comment)

    def test_declarations_are_unchanged(self):
        lines = [
            "\tdc.w\t$1234\t; data comment",
            "\tINCBIN \"/data/file\"\t; binary",
        ]
        self.assertEqual(format_asm_lines(lines), lines)

    def test_equ_fields_and_comments_are_aligned(self):
        lines = [
            "  Short:   equ   $01   ",
            "\t; ReSource: short value.  ",
            "\tLonger_Equate_Name: equ $1234 ; existing inline comment.   ",
            "NoComment: equ $02",
        ]
        result = format_asm_lines(lines)

        self.assertEqual(len(result), 3)
        self.assertTrue(all(not line[:1].isspace() for line in result))
        equ_columns = {
            _display_column(line[: line.casefold().index("\tequ") + 1])
            for line in result
        }
        self.assertEqual(len(equ_columns), 1)
        commented = [line for line in result if ";" in line]
        comment_columns = {
            _display_column(line.split(";", 1)[0]) for line in commented
        }
        self.assertEqual(len(comment_columns), 1)
        self.assertIn("; ReSource: short value.", result[0])
        self.assertIn("; existing inline comment.", result[1])
        self.assertFalse(any(line.lstrip().startswith(";") for line in result))

    def test_multiline_equ_comment_is_joined_and_formatting_is_idempotent(self):
        lines = [
            "Value: equ $40",
            "\t; ReSource: First part of the comment",
            "\t; continues on its second line.",
        ]
        once = format_asm_lines(lines)
        twice = format_asm_lines(once)
        self.assertEqual(once, twice)
        self.assertEqual(len(once), 1)
        self.assertIn(
            "; ReSource: First part of the comment continues on its second line.",
            once[0],
        )

    def test_trailing_operand_whitespace_is_not_counted(self):
        result = format_asm_lines(
            [
                "\tmove.w\td0,d1   \t ;short",
                "\tmove.l\tLong_Operand_Name,d1\t;long",
            ]
        )
        self.assertEqual(
            _display_column(result[0].split(";", 1)[0]),
            _display_column(result[1].split(";", 1)[0]),
        )
        self.assertNotIn("d1   ", result[0])

    def test_file_formatting_preserves_final_newline(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "BLOODWYCH439_relabel_data.asm"
            path.write_text("\tmove.w\td0,d1\t; test\n", encoding="utf-8")
            self.assertEqual(format_relabel_data(path), path)
            self.assertTrue(path.read_text(encoding="utf-8").endswith("\n"))


if __name__ == "__main__":
    unittest.main()

from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

import pandas as pd

from tools.source_formatter import (
    _display_column,
    apply_instruction_comments,
    format_asm_lines,
    format_relabel_data,
)


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
            "\t; short value.  ",
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
        self.assertIn("; short value.", result[0])
        self.assertIn("; existing inline comment.", result[1])
        self.assertFalse(any(line.lstrip().startswith(";") for line in result))

    def test_multiline_equ_comment_is_joined_and_formatting_is_idempotent(self):
        lines = [
            "Value: equ $40",
            "\t; First part of the comment",
            "\t; continues on its second line.",
        ]
        once = format_asm_lines(lines)
        twice = format_asm_lines(once)
        self.assertEqual(once, twice)
        self.assertEqual(len(once), 1)
        self.assertIn(
            "; First part of the comment continues on its second line.",
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

    def test_file_formatting_moves_and_groups_static_equates(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            asm = root / "BLOODWYCH439_relabel_data.asm"
            segments = root / "segments.xlsx"
            cleanup = root / "cleanup.xlsx"
            asm.write_text(
                "dsksync:\t\tequ\t$0000007E\n"
                "MonsterLive_RecordCapacity:\t\tequ\t$80\n"
                "\t; Maximum live-record capacity.\n"
                "InterfaceAction_WallClick:\t\tequ\t$23\n"
                "\t; Handles a clicked wall.\n"
                "InterfaceAction_Display:\t\tequ\t$10\n"
                "\t; Displays the dungeon.\n"
                "OldCleanup_Name:\t\tequ\t$7F\n"
                "\t; Stale cleanup-owned definition.\n"
                "\n"
                "****************************************************************************\n"
                "ProgStart:\n"
                "\tmoveq\t#$00,d0\t;7000\n"
                "LocationAlias:\t\tequ\t*-2\n",
                encoding="utf-8",
            )
            pd.DataFrame({"label": ["ProgStart"], "relabel": [""]}).to_excel(
                segments, sheet_name="BLOODWYCH439", index=False
            )
            format_relabel_data(asm, segments, "BLOODWYCH439")

            main_text = asm.read_text(encoding="utf-8")
            include = root / "Bloodwych439_equates.asm"
            include_text = include.read_text(encoding="utf-8")
            self.assertIn('\tINCLUDE\t"Bloodwych439_equates.asm"', main_text)
            self.assertNotIn("MonsterLive_RecordCapacity", main_text)
            self.assertNotIn("OldCleanup_Name", main_text)
            self.assertIn("LocationAlias:", main_text)
            self.assertIn("equ\t*-2", main_text)
            self.assertLess(
                include_text.index("dsksync:"),
                include_text.index("InterfaceAction_Display:"),
            )
            display = include_text.index("InterfaceAction_Display:")
            wall = include_text.index("InterfaceAction_WallClick:")
            monster = include_text.index("MonsterLive_RecordCapacity:")
            self.assertLess(display, wall)
            self.assertLess(wall, monster)
            self.assertIn("\n\n", include_text[wall:monster])
            self.assertIn("OldCleanup_Name:", include_text)

            first_main = main_text
            first_include = include_text
            format_relabel_data(asm, segments, "BLOODWYCH439")
            self.assertEqual(asm.read_text(encoding="utf-8"), first_main)
            self.assertEqual(include.read_text(encoding="utf-8"), first_include)

    def test_sibling_cleanup_comments_are_used(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            asm = root / "BLOODWYCH439_relabel_data.asm"
            segments = root / "segments.xlsx"
            cleanup = root / "cleanup.xlsx"
            asm.write_text(
                "Routine_Start:\n"
                "\tmove.w\td0,d1\t;302D0001\n"
                "Routine_End:\n",
                encoding="utf-8",
            )
            pd.DataFrame({"label": ["Routine_Start"]}).to_excel(
                segments, sheet_name="BLOODWYCH439", index=False
            )
            pd.DataFrame(
                [
                    {
                        "profile": "BLOODWYCH439",
                        "scope_start": "Routine_Start",
                        "scope_end": "Routine_End",
                        "source_match": "move.w d0,d1",
                        "source_comment": "Loaded from cleanup.xlsx.",
                        "expected_matches": 1,
                    }
                ]
            ).to_excel(cleanup, sheet_name="COMMENTS", index=False)

            format_relabel_data(asm, segments, "BLOODWYCH439")
            self.assertIn(";Loaded from cleanup.xlsx.", asm.read_text())

    def test_instruction_comments_replace_hex_only_inside_scope(self):
        frame = pd.DataFrame(
            [
                {
                    "scope_start": "Routine_Start",
                    "scope_end": "Routine_End",
                    "source_match": "move.w HeldItem_ObjectCodeOffset(a5),d0",
                    "source_comment": "Reads the currently held object code.",
                    "expected_matches": 1,
                }
            ]
        )
        lines = [
            "Routine_Start:",
            "\tmove.w\tHeldItem_ObjectCodeOffset(a5),d0\t;302D002E",
            "\tmove.w\td0,d1\t; handwritten comment",
            "Routine_End:",
        ]
        self.assertEqual(
            apply_instruction_comments(lines, frame),
            [
                "Routine_Start:",
                "\tmove.w\tHeldItem_ObjectCodeOffset(a5),d0\t; Reads the currently held object code.",
                "\tmove.w\td0,d1\t; handwritten comment",
                "Routine_End:",
            ],
        )

    def test_instruction_comments_require_expected_match_count(self):
        frame = pd.DataFrame(
            [
                {
                    "scope_start": "Start",
                    "scope_end": "End",
                    "source_match": "move.w d0,d1",
                    "source_comment": "Explain the move.",
                    "expected_matches": 2,
                }
            ]
        )
        lines = [
            "Start:",
            "\tmove.w\td0,d1\t;1234",
            "End:",
        ]
        self.assertEqual(apply_instruction_comments(lines, frame), lines)

    def test_legacy_conversion_notes_allow_human_instruction_comments(self):
        instruction = "move.w #TriggerSound_None,TriggerSound.w"
        frame = pd.DataFrame([{
            "scope_start": "Start", "scope_end": "End",
            "source_match": instruction, "source_comment": "Suppress trigger sound.",
            "expected_matches": 1,
        }])
        for suffix in ("Short Absolute converted to symbol!", "Long Addr replaced with Symbol"):
            with self.subTest(suffix=suffix):
                lines = ["Start:", f"\t{instruction}\t;31FCFFFF6FA8\t;{suffix}", "End:"]
                result = apply_instruction_comments(lines, frame)
                self.assertEqual(result[1], f"\t{instruction}\t; Suppress trigger sound.")
                self.assertEqual(lines[1], f"\t{instruction}\t;31FCFFFF6FA8\t;{suffix}")
                handwritten = ["Start:", lines[1] + "; keep this explanation", "End:"]
                self.assertEqual(apply_instruction_comments(handwritten, frame), handwritten)

    def test_instruction_rules_cannot_replace_data_byte_comments(self):
        for declaration in ("dc.w $FFFF", "ds.w 1", 'INCBIN "/data/example.lookup"'):
            with self.subTest(declaration=declaration):
                frame = pd.DataFrame([{
                    "scope_start": "Start", "scope_end": "End",
                    "source_match": declaration, "source_comment": "Must not replace data.",
                    "expected_matches": 1,
                }])
                lines = ["Start:", f"\t{declaration}\t;FFFF", "End:"]
                self.assertEqual(apply_instruction_comments(lines, frame), lines)

    def test_instruction_comments_resolve_segments_relabels(self):
        frame = pd.DataFrame(
            [
                {
                    "scope_start": "Old_Start",
                    "scope_end": "Old_End",
                    "source_match": "bsr Old_Target",
                    "source_comment": "Uses relabelled segments metadata.",
                    "expected_matches": 1,
                }
            ]
        )
        lines = [
            "New_Start:",
            "\tbsr\t\tNew_Target\t;61000002",
            "New_End:",
        ]
        self.assertEqual(
            apply_instruction_comments(
                lines,
                frame,
                label_relabels={
                    "Old_Start": "New_Start",
                    "Old_End": "New_End",
                    "Old_Target": "New_Target",
                },
            ),
            [
                "New_Start:",
                "\tbsr\t\tNew_Target\t; Uses relabelled segments metadata.",
                "New_End:",
            ],
        )

    def test_file_formatting_loads_scope_relabels_from_segments(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            asm = root / "BLOODWYCH439_relabel_data.asm"
            segments = root / "segments.xlsx"
            cleanup = root / "cleanup.xlsx"
            asm.write_text(
                "New_Start:\n"
                "\tmove.w\td0,d1\t;3001\n"
                "New_End:\n",
                encoding="utf-8",
            )
            pd.DataFrame(
                {
                    "label": ["Old_Start", "Old_End"],
                    "relabel": ["New_Start", "New_End"],
                }
            ).to_excel(segments, sheet_name="BLOODWYCH439", index=False)
            pd.DataFrame(
                [
                    {
                        "profile": "BLOODWYCH439",
                        "scope_start": "Old_Start",
                        "scope_end": "Old_End",
                        "source_match": "move.w d0,d1",
                        "source_comment": "Resolved through segments.xlsx.",
                        "expected_matches": 1,
                    }
                ]
            ).to_excel(cleanup, sheet_name="COMMENTS", index=False)

            format_relabel_data(asm, segments, "BLOODWYCH439")
            self.assertIn(";Resolved through segments.xlsx.", asm.read_text())


if __name__ == "__main__":
    unittest.main()

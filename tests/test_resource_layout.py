from __future__ import annotations

import re
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import pandas as pd

from tools.resource_layout import resource_layouts, resource_name
from tools.tool_common import ToolError
from tools.fix_labels import FixLabelRule, load_fix_label_metadata
from tools.tool_relabel import (
    _reference_pattern,
    _undefined_legacy_labels,
    relabel_segments,
)


class ResourceLayoutTests(unittest.TestCase):
    def test_resource_name_uses_explicit_name_first(self) -> None:
        row = pd.Series(
            {
                "type": "sfx",
                "data block file": "sample1.sound",
                "name": "custom/sample1.sound",
            }
        )
        self.assertEqual(resource_name(row), "custom/sample1.sound")

    def test_resource_name_recreates_worksheet_formula_when_name_is_blank(self) -> None:
        row = pd.Series(
            {
                "type": "sfx",
                "data block file": "sample1.sound",
                "name": "",
            }
        )
        self.assertEqual(resource_name(row), "sfx/sample1.sound")

    def test_resource_name_stays_blank_without_type_or_data_file(self) -> None:
        self.assertEqual(resource_name(pd.Series({"name": ""})), "")

    def test_relabel_reference_pattern_supports_question_mark_labels(self) -> None:
        source = "add.b Monster_Grades?_5FD6(pc,d2.w),d3"
        rewritten = re.sub(
            _reference_pattern("Monster_Grades?_5FD6"),
            "Shield_ArmourBonuses",
            source,
        )
        self.assertEqual(
            rewritten,
            "add.b Shield_ArmourBonuses(pc,d2.w),d3",
        )

    def test_relabel_reference_pattern_preserves_operand_size_suffix(self) -> None:
        source = "lea adrEA00D988.l,a0"
        rewritten = re.sub(
            _reference_pattern("adrEA00D988"),
            "Data_Woundflash",
            source,
        )
        self.assertEqual(rewritten, "lea Data_Woundflash.l,a0")

    def test_relabel_integrity_check_finds_renamed_definition_with_old_reference(
        self,
    ) -> None:
        self.assertEqual(
            _undefined_legacy_labels(
                [
                    "Data_Woundflash:",
                    "\tlea\tadrEA00D988.l,a0\t; old reference",
                ]
            ),
            ["adrEA00D988"],
        )

    def test_append_accepts_internal_source_label(self) -> None:
        frame = pd.DataFrame(
            (
                {
                    "label": "Anchor",
                    "relabel": "First",
                    "data_action": "data_start",
                },
                {
                    "label": "Different",
                    "relabel": "Second",
                    "data_action": "data_append",
                },
            )
        )
        layouts = resource_layouts(frame)

        self.assertEqual(len(layouts), 1)
        self.assertEqual(layouts[0].source_label, "Anchor")
        self.assertEqual(len(layouts[0].rows), 2)

    def test_append_requires_a_source_label(self) -> None:
        frame = pd.DataFrame(
            (
                {
                    "label": "Anchor",
                    "relabel": "First",
                    "data_action": "data_start",
                },
                {
                    "label": "",
                    "relabel": "Second",
                    "data_action": "data_append",
                },
            )
        )

        with self.assertRaisesRegex(ToolError, "requires an original or internal"):
            resource_layouts(frame)

    def test_relabel_uses_explicit_delete_then_rename_passes(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "GAME.asm"
            destination = root / "GAME_relabel.asm"
            source.write_text(
                "OldAnchor:\n"
                "\tdc.w\t$0102\n"
                "OldInternal:\n"
                "\tdc.w\t$0304\n"
                "After:\n"
                "\trts\n",
                encoding="utf-8",
            )
            frame = pd.DataFrame(
                (
                    {
                        "label": "OldAnchor",
                        "relabel": "NewFirst",
                        "offset": 10,
                        "size": 2,
                        "data_action": "data_start",
                    },
                    {
                        "label": "OldAnchor",
                        "relabel": "NewSecond",
                        "offset": 12,
                        "size": 2,
                        "data_action": "data_append",
                    },
                    {
                        "label": "OldInternal",
                        "relabel": "_delete",
                        "data_action": "",
                    },
                )
            )

            def fake_asm_path(_master: str, stage: str) -> Path:
                return source if stage == "source" else destination

            with (
                patch("tools.tool_relabel.asm_path", side_effect=fake_asm_path),
                patch("tools.tool_relabel.load_segments", return_value=frame),
            ):
                output = relabel_segments("GAME", root / "segments.xlsx")

            generated = output.read_text(encoding="utf-8")
            self.assertIn("NewFirst:\n\tdc.w\t$0102", generated)
            self.assertIn(
                "NewSecond:\t\tequ\tNewFirst+$2"
                "\t; temporary data_append alias",
                generated,
            )
            self.assertNotIn("OldInternal:", generated)
            self.assertIn("\tdc.w\t$0304", generated)

    def test_relabel_renames_internal_data_append_label(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "GAME.asm"
            destination = root / "GAME_relabel.asm"
            source.write_text(
                "OldAnchor:\n"
                "\tdc.w\t$0102\n"
                "OldInternal:\n"
                "\tdc.w\t$0304\n",
                encoding="utf-8",
            )
            frame = pd.DataFrame(
                (
                    {
                        "label": "OldAnchor",
                        "relabel": "NewFirst",
                        "data_action": "data_start",
                    },
                    {
                        "label": "OldInternal",
                        "relabel": "NewSecond",
                        "data_action": "data_append",
                    },
                )
            )

            def fake_asm_path(_master: str, stage: str) -> Path:
                return source if stage == "source" else destination

            with (
                patch("tools.tool_relabel.asm_path", side_effect=fake_asm_path),
                patch("tools.tool_relabel.load_segments", return_value=frame),
            ):
                output = relabel_segments("GAME", root / "segments.xlsx")

            generated = output.read_text(encoding="utf-8")
            self.assertIn("NewFirst:\n\tdc.w\t$0102", generated)
            self.assertIn("NewSecond:\n\tdc.w\t$0304", generated)
            self.assertNotIn("OldInternal", generated)

    def test_relabel_separates_fix_label_from_ordinary_anchor_relabel(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "GAME.asm"
            destination = root / "GAME_relabel.asm"
            source.write_text(
                "LookupRoutine:\n"
                "\tmove.w\tOldAnchor(pc,d0.w),d0\t;303B001A\n"
                ";fiX Data reference expected\n"
                "\trts\n"
                "OldAnchor:\n"
                "\trts\n"
                "\tdc.w\t$1111,$2222,$3333,$4444\n"
                ";fiX Label expected\n"
                "\tdc.w\t$0102,$0304\n",
                encoding="utf-8",
            )
            frame = pd.DataFrame(
                (
                    {
                        "label": "OldAnchor",
                        "relabel": "NewBase_Exit",
                        "data_action": "",
                    },
                )
            )
            fix_rule = FixLabelRule(
                profile="GAME",
                anchor_label="OldAnchor",
                insert_label="NewTable",
                source_match="move.w OldAnchor(pc,d0.w),d0",
                source_replace="move.w NewTable-10(pc,d0.w),d0",
                expected_opcode="303B001A",
                expected_matches=1,
                status="verified",
            )

            def fake_asm_path(_master: str, stage: str) -> Path:
                return source if stage == "source" else destination

            with (
                patch("tools.tool_relabel.asm_path", side_effect=fake_asm_path),
                patch("tools.tool_relabel.load_segments", return_value=frame),
                patch(
                    "tools.tool_relabel.load_fix_label_metadata",
                    return_value=(fix_rule,),
                ),
            ):
                output = relabel_segments("GAME", root / "segments.xlsx")

            generated = output.read_text(encoding="utf-8")
            self.assertIn("move.w NewTable-10(pc,d0.w),d0", generated)
            self.assertIn(
                "NewBase_Exit:\n\trts\n\tdc.w\t$1111,$2222,$3333,$4444\nNewTable:\n",
                generated,
            )
            self.assertNotIn(";fiX Label expected", generated)
            self.assertNotIn(";fiX Data reference expected", generated)

    def test_fix_label_loader_uses_minimal_cleanup_columns(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            segments = root / "segments.xlsx"
            cleanup = root / "cleanup.xlsx"
            segments.touch()
            pd.DataFrame(
                (
                    {
                        "profile": "BLOODWYCH439",
                        "anchor_label": "adrCd008BE8",
                        "insert_label": "PlayerColourRampTable",
                        "source_match": "move.w adrCd008BE8(pc,d0.w),d0",
                        "source_replace": "move.w PlayerColourRampTable-2(pc,d0.w),d0",
                        "expected_opcode": "303B001A",
                        "expected_matches": 1,
                        "status": "verified",
                        "source_comment": "Insert the colour-ramp table label.",
                    },
                )
            ).to_excel(cleanup, sheet_name="FIX_LABELS", index=False)

            rules = load_fix_label_metadata(
                segments, "BLOODWYCH439", cleanup
            )

            self.assertEqual(len(rules), 1)
            self.assertEqual(rules[0].anchor_label, "adrCd008BE8")
            self.assertEqual(rules[0].insert_label, "PlayerColourRampTable")
            self.assertEqual(rules[0].expected_matches, 1)

if __name__ == "__main__":
    unittest.main()

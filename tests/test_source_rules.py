from __future__ import annotations

import tempfile
import unittest
from contextlib import redirect_stdout
from dataclasses import replace
from io import StringIO
from pathlib import Path

import pandas as pd

from tools.source_rules import (
    EquateDefinition,
    SourceRule,
    apply_source_rules,
    insert_generated_equates,
    load_source_metadata,
)
from tools.tool_common import ToolError


def equate(
    name: str = "DiskReadTimeoutCount",
    value: int = 0x186A0,
    status: str = "verified",
) -> EquateDefinition:
    return EquateDefinition(
        "BLOODWYCH439",
        name,
        value,
        status,
        "Disk DMA polling timeout.",
    )


def rule(
    *,
    status: str = "verified",
    expected_opcode: str = "223C000186A0",
    expected_matches: int = 1,
) -> SourceRule:
    return SourceRule(
        "BLOODWYCH439",
        "disk-read-timeout",
        "replace_operand",
        "DiskReadTimeoutCount",
        "WaitForDisk",
        "DiskWaitLoop",
        "move.l",
        "#adrL_0186A0,d1",
        expected_opcode,
        "#DiskReadTimeoutCount,d1",
        expected_matches,
        status,
    )


class SourceRuleTests(unittest.TestCase):
    def setUp(self) -> None:
        self.lines = [
            "dsksync:\t\tequ\t$0000007E",
            "",
            "WaitForDisk:",
            "\tmoveq\t#$40,d0\t;7040",
            "\tmove.l\t#adrL_0186A0,d1\t;223C000186A0",
            "DiskWaitLoop:",
            "\tsubq.l\t#$01,d1\t;5381",
            "Elsewhere:",
            "\tmoveq\t#$40,d0\t;7040",
        ]

    def test_scoped_rule_replaces_only_the_confirmed_instruction(self) -> None:
        result = apply_source_rules(self.lines, (equate(),), (rule(),))
        self.assertIn("\tmove.l\t#DiskReadTimeoutCount,d1\t;223C000186A0", result)
        self.assertEqual(result.count("\tmoveq\t#$40,d0\t;7040"), 2)

    def test_opcode_mismatch_fails_closed(self) -> None:
        with self.assertRaisesRegex(ToolError, "opcode mismatch"):
            apply_source_rules(
                self.lines, (equate(),), (rule(expected_opcode="DEADBEEF"),)
            )

    def test_opcode_comparison_accepts_excel_dropped_leading_zero(self) -> None:
        excel_lines = list(self.lines)
        excel_lines[4] = "\tmove.l\t#adrL_0186A0,d1\t;02400003"
        result = apply_source_rules(
            excel_lines, (equate(),), (rule(expected_opcode="2400003"),)
        )
        self.assertIn("\tmove.l\t#DiskReadTimeoutCount,d1\t;02400003", result)

    def test_ambiguous_match_count_fails_closed(self) -> None:
        duplicated = list(self.lines)
        duplicated.insert(5, "\tmove.l\t#adrL_0186A0,d1\t;223C000186A0")
        with self.assertRaisesRegex(ToolError, "found 2"):
            apply_source_rules(duplicated, (equate(),), (rule(),))

    def test_expected_match_count_can_replace_multiple_confirmed_instructions(self) -> None:
        duplicated = list(self.lines)
        duplicated.insert(5, "\tmove.l\t#adrL_0186A0,d1\t;223C000186A0")
        result = apply_source_rules(
            duplicated, (equate(),), (rule(expected_matches=2),)
        )
        self.assertEqual(
            result.count("\tmove.l\t#DiskReadTimeoutCount,d1\t;223C000186A0"),
            2,
        )

    def test_proposed_rule_is_not_applied(self) -> None:
        result = apply_source_rules(
            self.lines, (equate(),), (rule(status="proposed"),)
        )
        self.assertEqual(result, self.lines)

    def test_relabelled_scope_and_operand_names_are_used_as_fallbacks(self) -> None:
        renamed = [
            "NewStart:",
            "\tmove.l\t#NewValue.l,d1\t;223C000186A0",
            "NewEnd:",
        ]
        source_rule = SourceRule(
            "BLOODWYCH439",
            "renamed-labels",
            "replace_operand",
            "DiskReadTimeoutCount",
            "OldStart",
            "OldEnd",
            "move.l",
            "#OldValue.l,d1",
            "223C000186A0",
            "#DiskReadTimeoutCount,d1",
            1,
            "verified",
        )
        result = apply_source_rules(
            renamed,
            (equate(),),
            (source_rule,),
            label_relabels={
                "OldStart": "NewStart",
                "OldEnd": "NewEnd",
                "OldValue": "NewValue",
            },
        )
        self.assertIn("\tmove.l\t#DiskReadTimeoutCount,d1\t;223C000186A0", result)

    def test_recoverable_rule_error_does_not_block_later_rules(self) -> None:
        bad_rule = replace(
            rule(), rule_id="missing-scope", scope_start="Missing"
        )
        output = StringIO()
        with redirect_stdout(output):
            result = apply_source_rules(
                self.lines,
                (equate(),),
                (bad_rule, rule()),
                continue_on_error=True,
            )
        self.assertIn("leaving this rule unchanged and continuing", output.getvalue())
        self.assertIn("1 verified rule(s) failed safely", output.getvalue())
        self.assertIn("\tmove.l\t#DiskReadTimeoutCount,d1\t;223C000186A0", result)

    def test_replacement_operand_retains_relabelled_map_destination(self) -> None:
        source_rule = SourceRule(
            "BLOODWYCH439", "map-height", "replace_operand",
            "Map_FloorHeightsOffset", "adrCd0084DA", "adrCd0084FC",
            "move.b", "$08(a0,d0.w),adrB_00EE73.l", "13F000080000EE73",
            "Map_FloorHeightsOffset(a0,d0.w),adrB_00EE73.l", 1, "verified",
        )
        for destination in ("adrB_00EE73", "Current_FloorHeightByte"):
            with self.subTest(destination=destination):
                lines = [
                    "Select_FloorGeometry:",
                    f"\tmove.b\t$08(a0,d0.w),{destination}.l\t;13F000080000EE73",
                    "MapOffsetToCurrentFloorCoordinates:",
                ]
                result = apply_source_rules(
                    lines, (equate("Map_FloorHeightsOffset", 8),), (source_rule,),
                    label_relabels={
                        "adrCd0084DA": "Select_FloorGeometry",
                        "adrCd0084FC": "MapOffsetToCurrentFloorCoordinates",
                        "adrB_00EE73": destination,
                    },
                )
                self.assertEqual(
                    result[1],
                    f"\tmove.b\tMap_FloorHeightsOffset(a0,d0.w),{destination}.l\t;13F000080000EE73",
                )

    def test_replacement_data_expression_relabels_only_whole_symbols(self) -> None:
        source_rule = SourceRule(
            "BLOODWYCH439", "map-base", "replace_operand", "Map_HeaderSize",
            "Pointer", "End", "dc.l", "$0000EF78", "0000EF78",
            "MapData1+Map_HeaderSize", 1, "verified",
        )
        result = apply_source_rules(
            ["Pointer:", "\tdc.l\t$0000EF78\t;0000EF78", "End:"],
            (equate("Map_HeaderSize", 0x38),), (source_rule,),
            label_relabels={"MapData1": "KeepMap", "Map": "NotAWholeSymbol"},
        )
        self.assertEqual(result[1], "\tdc.l\tKeepMap+Map_HeaderSize\t;0000EF78")

    def test_verified_equates_are_inserted_after_header(self) -> None:
        result = insert_generated_equates(
            self.lines,
            (
                equate(),
                equate("NegativeRecordOffset", -2),
                equate("Character_Zendik", 0x40, "proposed"),
            ),
        )
        generated = "\n".join(result)
        self.assertIn("DiskReadTimeoutCount:\t\tequ\t$000186A0", generated)
        self.assertIn("NegativeRecordOffset:\t\tequ\t-$02", generated)
        self.assertNotIn("Character_Zendik:", generated)
        self.assertLess(
            result.index("DiskReadTimeoutCount:\t\tequ\t$000186A0"),
            result.index("WaitForDisk:"),
        )

    def test_optional_tabs_can_be_absent(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workbook = Path(temporary_directory) / "segments.xlsx"
            pd.DataFrame({"label": ["A"]}).to_excel(
                workbook, sheet_name="BLOODWYCH439", index=False
            )
            equates, rules = load_source_metadata(workbook, "BLOODWYCH439")
        self.assertEqual(equates, ())
        self.assertEqual(rules, ())

    def test_sibling_cleanup_workbook_is_preferred(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workbook = Path(temporary_directory) / "segments.xlsx"
            cleanup = workbook.with_name("cleanup.xlsx")
            pd.DataFrame({"label": ["A"]}).to_excel(
                workbook, sheet_name="BLOODWYCH439", index=False
            )
            pd.DataFrame(
                {
                    "profile": ["BLOODWYCH439"],
                    "equ_name": ["CleanupOnlyConstant"],
                    "equ_value": ["$40"],
                    "scope_start": [""],
                    "scope_end": [""],
                    "source_match": [""],
                    "expected_opcode": [""],
                    "source_replace": [""],
                    "expected_matches": [""],
                    "status": ["verified"],
                    "source_comment": ["Loaded from cleanup workbook."],
                    "notes": [""],
                }
            ).to_excel(cleanup, sheet_name="EQUATES", index=False)
            equates, rules = load_source_metadata(workbook, "BLOODWYCH439")
        self.assertEqual([item.name for item in equates], ["CleanupOnlyConstant"])
        self.assertEqual(rules, ())

    def test_workbook_rows_load_and_validate(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workbook = Path(temporary_directory) / "segments.xlsx"
            with pd.ExcelWriter(workbook) as writer:
                pd.DataFrame({"label": ["A"]}).to_excel(
                    writer, sheet_name="BLOODWYCH439", index=False
                )
                pd.DataFrame(
                    ({
                        "profile": "BLOODWYCH439",
                        "equ_name": "DiskReadTimeoutCount",
                        "equ_value": "$000186A0",
                        "scope_start": "WaitForDisk",
                        "scope_end": "DiskWaitLoop",
                        "source_match": "move.l #adrL_0186A0,d1",
                        "expected_opcode": "223C000186A0",
                        "expected_matches": 1,
                        "source_replace": "move.l #DiskReadTimeoutCount,d1",
                        "status": "verified",
                        "source_comment": "Timeout load.",
                        "notes": "Retained free-form notes.",
                    },)
                ).to_excel(writer, sheet_name="EQUATES", index=False)
            equates, rules = load_source_metadata(workbook, "BLOODWYCH439")
        self.assertEqual(equates[0].value, 0x186A0)
        self.assertEqual(rules[0].equ_name, "DiskReadTimeoutCount")
        self.assertEqual(rules[0].notes, "Retained free-form notes.")

    def test_workbook_accepts_negative_amiga_hex_equ_value(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workbook = Path(temporary_directory) / "segments.xlsx"
            with pd.ExcelWriter(workbook) as writer:
                pd.DataFrame({"label": ["A"]}).to_excel(
                    writer, sheet_name="BLOODWYCH439", index=False
                )
                pd.DataFrame(
                    ({
                        "profile": "BLOODWYCH439",
                        "equ_name": "MonsterLive_RecordCountOffset",
                        "equ_value": "-$02",
                        "scope_start": "",
                        "scope_end": "",
                        "source_match": "",
                        "expected_opcode": "",
                        "expected_matches": "",
                        "source_replace": "",
                        "status": "proposed",
                        "source_comment": "Offset of the record count.",
                        "notes": "Signed displacement.",
                    },)
                ).to_excel(writer, sheet_name="EQUATES", index=False)
            equates, rules = load_source_metadata(workbook, "BLOODWYCH439")
        self.assertEqual(equates[0].value, -2)
        self.assertEqual(equates[0].value_text, "-$02")
        self.assertEqual(rules, ())

    def test_source_replace_must_reference_declared_equ(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workbook = Path(temporary_directory) / "segments.xlsx"
            with pd.ExcelWriter(workbook) as writer:
                pd.DataFrame({"label": ["A"]}).to_excel(
                    writer, sheet_name="BLOODWYCH439", index=False
                )
                pd.DataFrame(
                    [
                        {
                            "profile": "BLOODWYCH439",
                            "equ_name": "RenamedTimeout",
                            "equ_value": "$000186A0",
                            "scope_start": "WaitForDisk",
                            "scope_end": "DiskWaitLoop",
                            "source_match": "move.l #adrL_0186A0,d1",
                            "expected_opcode": "223C000186A0",
                            "expected_matches": 1,
                            "source_replace": "move.l #OldTimeout,d1",
                            "status": "verified",
                            "source_comment": "Timeout load.",
                        }
                    ]
                ).to_excel(writer, sheet_name="EQUATES", index=False)
            with self.assertRaisesRegex(
                ToolError, "source_replace must reference equ_name 'RenamedTimeout'"
            ):
                load_source_metadata(workbook, "BLOODWYCH439")

    def test_source_replace_accepts_equ_in_expression(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workbook = Path(temporary_directory) / "segments.xlsx"
            with pd.ExcelWriter(workbook) as writer:
                pd.DataFrame({"label": ["A"]}).to_excel(
                    writer, sheet_name="BLOODWYCH439", index=False
                )
                pd.DataFrame(
                    [
                        {
                            "profile": "BLOODWYCH439",
                            "equ_name": "RenamedTimeout",
                            "equ_value": "$000186A0",
                            "scope_start": "WaitForDisk",
                            "scope_end": "DiskWaitLoop",
                            "source_match": "move.l #adrL_0186A0,d1",
                            "expected_opcode": "223C000186A0",
                            "expected_matches": 1,
                            "source_replace": "move.l #RenamedTimeout+1,d1",
                            "status": "verified",
                            "source_comment": "Timeout load.",
                        }
                    ]
                ).to_excel(writer, sheet_name="EQUATES", index=False)
            equates, rules = load_source_metadata(workbook, "BLOODWYCH439")
        self.assertEqual(equates[0].name, "RenamedTimeout")
        self.assertEqual(rules[0].replacement_operands, "#RenamedTimeout+1,d1")

    def test_repeated_equ_name_allows_multiple_scoped_uses(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            workbook = Path(temporary_directory) / "segments.xlsx"
            rows = []
            for start, end in (("Start1", "End1"), ("Start2", "End2")):
                rows.append({
                    "profile": "BLOODWYCH439",
                    "equ_name": "Character_Zendik",
                    "equ_value": "$40",
                    "scope_start": start,
                    "scope_end": end,
                    "source_match": "cmpi.b #$40,d0",
                    "expected_opcode": "0C000040",
                    "expected_matches": 1,
                    "source_replace": "cmpi.b #Character_Zendik,d0",
                    "status": "verified",
                    "source_comment": "Zendik check.",
                    "notes": "",
                })
            with pd.ExcelWriter(workbook) as writer:
                pd.DataFrame({"label": ["A"]}).to_excel(
                    writer, sheet_name="BLOODWYCH439", index=False
                )
                pd.DataFrame(rows).to_excel(writer, sheet_name="EQUATES", index=False)
            equates, rules = load_source_metadata(workbook, "BLOODWYCH439")
        self.assertEqual(len(equates), 1)
        self.assertEqual(len(rules), 2)


if __name__ == "__main__":
    unittest.main()

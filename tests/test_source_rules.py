from __future__ import annotations

import tempfile
import unittest
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

    def test_ambiguous_match_count_fails_closed(self) -> None:
        duplicated = list(self.lines)
        duplicated.insert(5, "\tmove.l\t#adrL_0186A0,d1\t;223C000186A0")
        with self.assertRaisesRegex(ToolError, "found 2"):
            apply_source_rules(duplicated, (equate(),), (rule(),))

    def test_proposed_rule_is_not_applied(self) -> None:
        result = apply_source_rules(
            self.lines, (equate(),), (rule(status="proposed"),)
        )
        self.assertEqual(result, self.lines)

    def test_verified_equates_are_inserted_after_header(self) -> None:
        result = insert_generated_equates(
            self.lines, (equate(), equate("Character_Zendik", 0x40, "proposed"))
        )
        generated = "\n".join(result)
        self.assertIn("DiskReadTimeoutCount:\t\tequ\t$000186A0", generated)
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

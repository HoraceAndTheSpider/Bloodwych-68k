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
    SourceInstructionIndex,
    SourceOperandRelabeler,
    SourceRule,
    SourceRuleMetrics,
    _relabel_rule_operands,
    apply_source_rules,
    apply_source_rules_indexed,
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


class SelectiveO2SourceRuleTests(unittest.TestCase):
    @staticmethod
    def make_rule(
        rule_id: str,
        mnemonic: str,
        match_operands: str,
        expected_opcode: str,
        replacement_operands: str,
        *,
        equ_name: str = "ChampionStat_Level",
    ) -> SourceRule:
        return SourceRule(
            "BLOODWYCH439",
            rule_id,
            "replace_operand",
            equ_name,
            "Start",
            "End",
            mnemonic,
            match_operands,
            expected_opcode,
            replacement_operands,
            1,
            "verified",
        )

    def apply_both(
        self,
        lines: list[str],
        equates: tuple[EquateDefinition, ...],
        rules: tuple[SourceRule, ...],
    ) -> list[str]:
        with redirect_stdout(StringIO()):
            legacy = apply_source_rules(lines, equates, rules)
            indexed = apply_source_rules_indexed(
                lines, equates, rules, metrics=SourceRuleMetrics()
            )
        self.assertEqual(indexed, legacy)
        return indexed

    def test_plain_an_zero_equ_rewrite_gets_local_o2_scope(self) -> None:
        lines = ["Start:", "\tmove.b\t(a4),d0\t;1014", "End:"]
        source_rule = self.make_rule(
            "level", "move.b", "(a4),d0", "1014",
            "ChampionStat_Level(a4),d0",
        )

        result = self.apply_both(
            lines, (equate("ChampionStat_Level", 0),), (source_rule,)
        )

        self.assertEqual(
            result,
            [
                "Start:",
                "\tOPT\tO2+",
                "\tmove.b\tChampionStat_Level(a4),d0\t;1014",
                "\tOPT\tO2-",
                "End:",
            ],
        )

    def test_zero_equ_introduced_as_second_operand_is_detected(self) -> None:
        lines = ["Start:", "\tcmp.b\t#$5B,(a0)\t;0C10005B", "End:"]
        source_rule = self.make_rule(
            "heal-wand",
            "cmp.b",
            "#$5B,(a0)",
            "0C10005B",
            "#Object_HealWand,ChampionPocket_LeftHand(a0)",
            equ_name="Object_HealWand",
        )

        result = self.apply_both(
            lines,
            (
                equate("Object_HealWand", 0x5B),
                equate("ChampionPocket_LeftHand", 0),
            ),
            (source_rule,),
        )

        self.assertIn("\tOPT\tO2+", result)
        self.assertIn("\tOPT\tO2-", result)

    def test_plain_an_move_destination_is_proved_from_destination_ea_bits(self) -> None:
        lines = ["Start:", "\tmove.b\td7,(a4)\t;1887", "End:"]
        source_rule = self.make_rule(
            "destination", "move.b", "d7,(a4)", "1887",
            "d7,ActorRecord_XPosition(a4)",
            equ_name="ActorRecord_XPosition",
        )

        result = self.apply_both(
            lines, (equate("ActorRecord_XPosition", 0),), (source_rule,)
        )

        self.assertIn("\tOPT\tO2+", result)

    def test_original_zero_displacement_encoding_is_left_unoptimised(self) -> None:
        lines = ["Start:", "\tmove.b\t$0000(a4),d7\t;1E2C0000", "End:"]
        source_rule = self.make_rule(
            "long-zero", "move.b", "$0000(a4),d7", "1E2C0000",
            "ActorRecord_XPosition(a4),d7",
            equ_name="ActorRecord_XPosition",
        )

        result = self.apply_both(
            lines, (equate("ActorRecord_XPosition", 0),), (source_rule,)
        )

        self.assertNotIn("\tOPT\tO2+", result)

    def test_opcode_must_confirm_plain_an_even_when_source_text_claims_it(self) -> None:
        lines = ["Start:", "\tmove.b\t(a4),d0\t;102C0000", "End:"]
        source_rule = self.make_rule(
            "contradictory-opcode", "move.b", "(a4),d0", "102C0000",
            "ChampionStat_Level(a4),d0",
        )

        result = self.apply_both(
            lines, (equate("ChampionStat_Level", 0),), (source_rule,)
        )

        self.assertNotIn("\tOPT\tO2+", result)

    def test_nonzero_equ_is_left_unoptimised(self) -> None:
        lines = ["Start:", "\tmove.b\t(a4),d0\t;1014", "End:"]
        source_rule = self.make_rule(
            "nonzero", "move.b", "(a4),d0", "1014", "Offset(a4),d0",
            equ_name="Offset",
        )

        result = self.apply_both(lines, (equate("Offset", 1),), (source_rule,))

        self.assertNotIn("\tOPT\tO2+", result)

    def test_adjacent_qualified_instructions_share_one_o2_scope(self) -> None:
        lines = [
            "Start:",
            "\tmove.b\t(a4),d0\t;1014",
            "\tadd.b\t(a4),d1\t;D214",
            "End:",
        ]
        rules = (
            self.make_rule(
                "move", "move.b", "(a4),d0", "1014",
                "ChampionStat_Level(a4),d0",
            ),
            self.make_rule(
                "add", "add.b", "(a4),d1", "D214",
                "ChampionStat_Level(a4),d1",
            ),
        )

        result = self.apply_both(
            lines, (equate("ChampionStat_Level", 0),), rules
        )

        self.assertEqual(result.count("\tOPT\tO2+"), 1)
        self.assertEqual(result.count("\tOPT\tO2-"), 1)


class IndexedSourceRuleTests(unittest.TestCase):
    def assert_engines_equal(
        self,
        lines: list[str],
        rules: tuple[SourceRule, ...],
        *,
        relabels: dict[str, str] | None = None,
        continue_on_error: bool = False,
    ) -> list[str]:
        with redirect_stdout(StringIO()):
            legacy = apply_source_rules(
                lines,
                (),
                rules,
                label_relabels=relabels,
                continue_on_error=continue_on_error,
            )
            indexed = apply_source_rules_indexed(
                lines,
                (),
                rules,
                label_relabels=relabels,
                continue_on_error=continue_on_error,
            )
        self.assertEqual(indexed, legacy)
        return indexed

    @staticmethod
    def make_rule(
        rule_id: str,
        match_operands: str,
        replacement_operands: str,
        *,
        scope_start: str = "Start",
        scope_end: str = "End",
        mnemonic: str = "move.l",
        expected_opcode: str = "0001",
        expected_matches: int = 1,
        status: str = "verified",
    ) -> SourceRule:
        return SourceRule(
            "BLOODWYCH439",
            rule_id,
            "replace_operand",
            "Value",
            scope_start,
            scope_end,
            mnemonic,
            match_operands,
            expected_opcode,
            replacement_operands,
            expected_matches,
            status,
        )

    def test_instruction_index_preserves_reconstruction_data_and_reindexes(self) -> None:
        lines = ["\tMOVE.L  #$01, d0  \t; 0001 original bytes"]
        index = SourceInstructionIndex(lines)
        signature = ("move.l", "#$01,d0")

        self.assertEqual(index.indices_for(signature), [0])
        record = index.record(0)
        self.assertEqual(record.prefix, "\tMOVE.L  ")
        self.assertEqual(record.trailing, "  \t")
        self.assertEqual(record.comment, " 0001 original bytes")
        self.assertEqual(record.normalised_opcode, "0001")

        index.reindex_line(0, "\tMOVE.L  #Value, d0  \t; 0001 original bytes")
        self.assertEqual(index.indices_for(signature), [])
        self.assertEqual(index.indices_for(("move.l", "#value,d0")), [0])

    def test_indexed_operand_relabelling_matches_ordered_legacy_semantics(self) -> None:
        cases = (
            (
                {"a": "B", "b": "C"},
                "A+A.w",
            ),
            (
                {"b": "C", "a": "B"},
                "A+B",
            ),
            (
                {"foo": "First", ".foo": "Second"},
                ".FOO+foo.bar",
            ),
            (
                {"foo.bar": "Whole", "foo": "Part", "bar": "Tail"},
                "foo.bar+foo+bar",
            ),
            (
                {"adrValue?": "Question", "adrValue": "Plain"},
                "adrValue?.l+adrValue.w",
            ),
        )
        for relabels, value in cases:
            with self.subTest(relabels=relabels, value=value):
                self.assertEqual(
                    SourceOperandRelabeler(relabels).replace(value),
                    _relabel_rule_operands(value, relabels),
                )

    def test_expected_matches_scope_and_text_preservation_match_legacy(self) -> None:
        lines = [
            "Outside:",
            "\tmove.l\t#$01,d0\t;0001",
            "Start:",
            "\tMOVE.L  #$01, d0  \t; 0001 first",
            "\tmove.l\t#$01,d0\t;0001 second",
            "End:",
            "\tmove.l\t#$01,d0\t;0001",
        ]
        source_rule = self.make_rule(
            "two-in-scope", "#$01,d0", "#Value,d0", expected_matches=2
        )

        result = self.assert_engines_equal(lines, (source_rule,))

        self.assertEqual(result[1], lines[1])
        self.assertEqual(result[3], "\tMOVE.L  #Value,d0  \t; 0001 first")
        self.assertEqual(result[4], "\tmove.l\t#Value,d0\t;0001 second")
        self.assertEqual(result[6], lines[6])

    def test_overlapping_scopes_and_different_instructions_match_legacy(self) -> None:
        lines = ["Start:"] + ["\tnop"] * 500 + [
            "\tmove.l\t#$01,d0\t;0001",
            "Middle:",
            "\tadd.l\t#$02,d0\t;0002",
        ] + ["\tnop"] * 500 + ["End:"]
        rules = (
            self.make_rule("move", "#$01,d0", "#First,d0"),
            self.make_rule(
                "add",
                "#$02,d0",
                "#Second,d0",
                scope_start="Middle",
                mnemonic="add.l",
                expected_opcode="0002",
            ),
        )

        self.assert_engines_equal(lines, rules)

    def test_later_rule_matches_text_created_by_earlier_rule(self) -> None:
        lines = ["Start:", "\tmove.l\t#$01,d0\t;0001", "End:"]
        rules = (
            self.make_rule("first", "#$01,d0", "#Intermediate,d0"),
            self.make_rule("second", "#Intermediate,d0", "#Final,d0"),
        )

        result = self.assert_engines_equal(lines, rules)

        self.assertEqual(result[1], "\tmove.l\t#Final,d0\t;0001")

    def test_relabelled_scopes_match_and_replacement_operands_match_legacy(self) -> None:
        lines = [
            "NewStart:",
            "\tmove.l\t#NewInput.l,d0\t;0001",
            "NewEnd:",
        ]
        source_rule = self.make_rule(
            "relabels",
            "#OldInput.l,d0",
            "#OldOutput.l,d0",
            scope_start="OldStart",
            scope_end="OldEnd",
        )
        relabels = {
            "OldStart": "NewStart",
            "OldEnd": "NewEnd",
            "OldInput": "NewInput",
            "OldOutput": "NewOutput",
        }

        result = self.assert_engines_equal(
            lines, (source_rule,), relabels=relabels
        )

        self.assertEqual(result[1], "\tmove.l\t#NewOutput.l,d0\t;0001")

    def test_failures_raise_identically_without_mutating_input(self) -> None:
        lines = ["Start:", "\tmove.l\t#$01,d0\t;0001", "End:"]
        cases = (
            self.make_rule("opcode", "#$01,d0", "#Value,d0", expected_opcode="FFFF"),
            self.make_rule("count", "#$02,d0", "#Value,d0"),
            self.make_rule(
                "reversed",
                "#$01,d0",
                "#Value,d0",
                scope_start="End",
                scope_end="Start",
            ),
        )
        for source_rule in cases:
            with self.subTest(rule=source_rule.rule_id):
                original = list(lines)
                errors = []
                for engine in (apply_source_rules, apply_source_rules_indexed):
                    with self.assertRaises(ToolError) as raised, redirect_stdout(
                        StringIO()
                    ):
                        engine(lines, (), (source_rule,))
                    errors.append(str(raised.exception))
                self.assertEqual(errors[0], errors[1])
                self.assertEqual(lines, original)

    def test_continue_on_error_keeps_index_unchanged_for_later_rule(self) -> None:
        lines = ["Start:", "\tmove.l\t#$01,d0\t;0001", "End:"]
        bad = self.make_rule(
            "bad-opcode", "#$01,d0", "#Broken,d0", expected_opcode="FFFF"
        )
        good = self.make_rule("good", "#$01,d0", "#Value,d0")
        metrics = SourceRuleMetrics()

        with redirect_stdout(StringIO()):
            indexed = apply_source_rules_indexed(
                lines,
                (),
                (bad, good),
                continue_on_error=True,
                metrics=metrics,
            )
            legacy = apply_source_rules(
                lines, (), (bad, good), continue_on_error=True
            )

        self.assertEqual(indexed, legacy)
        self.assertEqual(indexed[1], "\tmove.l\t#Value,d0\t;0001")
        self.assertEqual(metrics.verified_rules, 2)
        self.assertEqual(metrics.indexed_candidates, 2)
        self.assertEqual(metrics.rewritten_lines, 1)
        self.assertEqual(metrics.failed_rules, 1)

    def test_proposed_and_disabled_rules_remain_inactive(self) -> None:
        lines = ["Start:", "\tmove.l\t#$01,d0\t;0001", "End:"]
        rules = (
            self.make_rule("proposed", "#$01,d0", "#Proposed,d0", status="proposed"),
            self.make_rule("disabled", "#$01,d0", "#Disabled,d0", status="disabled"),
        )
        metrics = SourceRuleMetrics()

        with redirect_stdout(StringIO()):
            result = apply_source_rules_indexed(lines, (), rules, metrics=metrics)

        self.assertEqual(result, lines)
        self.assertEqual(metrics.verified_rules, 0)
        self.assertEqual(metrics.rewritten_lines, 0)


if __name__ == "__main__":
    unittest.main()

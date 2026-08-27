from __future__ import annotations

import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import pandas as pd

from tools.asm_recovery import (
    ASM_RECOVERY_SHEET,
    AsmRecoveryInstruction,
    apply_asm_recoveries,
    load_asm_recovery_metadata,
)
from tools.tool_common import ToolError
from tools.tool_relabel import build_asmfix


def recovery(
    sequence: int,
    source_match: str,
    source_replace: str,
    expected_opcode: str,
    *,
    recovery_id: str = "draw_square",
    status: str = "verified",
) -> AsmRecoveryInstruction:
    return AsmRecoveryInstruction(
        profile="BLOODWYCH439",
        recovery_id=recovery_id,
        scope_start="Table",
        scope_end="DrawBar",
        sequence=sequence,
        source_match=source_match,
        source_replace=source_replace,
        expected_opcode=expected_opcode,
        status=status,
    )


class AsmRecoveryTests(unittest.TestCase):
    def setUp(self) -> None:
        self.lines = [
            "Table:",
            "\tdc.w\t$0000\t;0000",
            ";fiX Label expected",
            "\tdc.w\t$4843\t;4843",
            "\tdc.w\t$4844\t;4844",
            "DrawBar:",
            "\trts\t;4E75",
        ]
        self.rules = (
            recovery(1, "dc.w $4843", "swap d3", "4843"),
            recovery(2, "dc.w $4844", "swap d4", "4844"),
        )

    def test_group_is_recovered_with_searchable_comments(self) -> None:
        result, applied = apply_asm_recoveries(self.lines, self.rules)

        self.assertEqual(applied, {"draw_square"})
        self.assertIn("\tswap\td3\t;ASM_RECOVERY: draw_square | 4843", result)
        self.assertIn("\tswap\td4\t;ASM_RECOVERY: draw_square | 4844", result)
        self.assertIn(";fiX Label expected", result)

    def test_incomplete_group_fails_without_mutating_input(self) -> None:
        missing = list(self.lines)
        missing[4] = "\tdc.w\t$9999\t;9999"

        with self.assertRaisesRegex(ToolError, "complete source sequence"):
            apply_asm_recoveries(missing, self.rules)
        self.assertEqual(missing[3], "\tdc.w\t$4843\t;4843")

    def test_opcode_comment_mismatch_fails_closed(self) -> None:
        wrong_comment = list(self.lines)
        wrong_comment[3] = "\tdc.w\t$4843\t;FFFF"

        with self.assertRaisesRegex(ToolError, "opcode check failed"):
            apply_asm_recoveries(wrong_comment, self.rules)

    def test_proposed_group_is_not_applied(self) -> None:
        proposed = tuple(
            AsmRecoveryInstruction(**{**item.__dict__, "status": "proposed"})
            for item in self.rules
        )
        result, applied = apply_asm_recoveries(self.lines, proposed)
        self.assertEqual(result, self.lines)
        self.assertFalse(applied)

    def test_relabelled_scope_names_can_locate_canonical_relabel_source(self) -> None:
        relabelled = list(self.lines)
        relabelled[0] = "LookupTable:"
        relabelled[5] = "DrawFilledBar:"

        result, applied = apply_asm_recoveries(
            relabelled,
            self.rules,
            label_relabels={"Table": "LookupTable", "DrawBar": "DrawFilledBar"},
        )

        self.assertEqual(applied, {"draw_square"})
        self.assertIn("\tswap\td3\t;ASM_RECOVERY: draw_square | 4843", result)

    def test_asmfix_build_recovers_original_as_first_pass(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "GAME.asm"
            recovered_source = root / "GAME_asmfix.asm"
            source.write_text("\n".join(self.lines) + "\n", encoding="utf-8")

            def fake_asm_path(_master: str, stage: str = "source") -> Path:
                return {
                    "source": source,
                    "asmfix": recovered_source,
                }[stage]

            with (
                patch("tools.tool_relabel.asm_path", side_effect=fake_asm_path),
                patch(
                    "tools.tool_relabel.load_asm_recovery_metadata",
                    return_value=self.rules,
                ),
            ):
                output = build_asmfix("GAME", root / "segments.xlsx")

            self.assertEqual(output, recovered_source)
            self.assertNotIn("ASM_RECOVERY", source.read_text(encoding="utf-8"))
            self.assertEqual(
                recovered_source.read_text(encoding="utf-8").count(";ASM_RECOVERY:"),
                2,
            )

    def test_loader_validates_numeric_source_bytes_and_group_sequence(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            segments = root / "segments.xlsx"
            cleanup = root / "cleanup.xlsx"
            segments.touch()
            pd.DataFrame(
                (
                    {
                        "profile": "BLOODWYCH439",
                        "recovery_id": "message_default",
                        "scope_start": "Ask_CC96",
                        "scope_end": "adrCd00D042",
                        "sequence": 1,
                        "source_match": "dc.w $7400",
                        "source_replace": "moveq #$00,d2",
                        "expected_opcode": "7400",
                        "status": "verified",
                        "source_comment": "Restores the default message entry.",
                        "notes": "",
                    },
                )
            ).to_excel(cleanup, sheet_name=ASM_RECOVERY_SHEET, index=False)

            rules = load_asm_recovery_metadata(
                segments, "BLOODWYCH439", cleanup
            )

        self.assertEqual(len(rules), 1)
        self.assertEqual(rules[0].source_replace, "moveq #$00,d2")

    def test_loader_rejects_opcode_that_differs_from_dc_bytes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            segments = root / "segments.xlsx"
            cleanup = root / "cleanup.xlsx"
            segments.touch()
            pd.DataFrame(
                (
                    {
                        "profile": "BLOODWYCH439",
                        "recovery_id": "bad",
                        "scope_start": "Start",
                        "scope_end": "End",
                        "sequence": 1,
                        "source_match": "dc.w $7400",
                        "source_replace": "moveq #$00,d2",
                        "expected_opcode": "FFFF",
                        "status": "verified",
                        "source_comment": "",
                        "notes": "",
                    },
                )
            ).to_excel(cleanup, sheet_name=ASM_RECOVERY_SHEET, index=False)

            with self.assertRaisesRegex(ToolError, "source bytes do not match"):
                load_asm_recovery_metadata(segments, "BLOODWYCH439", cleanup)


if __name__ == "__main__":
    unittest.main()

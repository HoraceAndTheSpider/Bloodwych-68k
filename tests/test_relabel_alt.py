from __future__ import annotations

from contextlib import ExitStack
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch

import pandas as pd

from tools.source_rules import EquateDefinition, SourceRule
from tools.tool_relabel import relabel_segments
from tools.tool_relabel_alt import (
    _cleanup_frames,
    _default_alt_destination,
    relabel_segments_alt,
)


EMPTY_CLEANUP_FRAMES = {
    "equates": pd.DataFrame(),
    "fix_labels": pd.DataFrame(),
    "source_notes": pd.DataFrame(),
}


class RelabelAltTests(unittest.TestCase):
    def _metadata_patches(
        self,
        stack: ExitStack,
        module: str,
        frame: pd.DataFrame,
        *,
        equates: tuple[EquateDefinition, ...] = (),
        rules: tuple[SourceRule, ...] = (),
    ) -> None:
        stack.enter_context(patch(f"{module}.load_segments", return_value=frame))
        stack.enter_context(
            patch(f"{module}.load_source_metadata", return_value=(equates, rules))
        )
        stack.enter_context(patch(f"{module}.load_fix_label_metadata", return_value=()))
        stack.enter_context(
            patch(f"{module}.load_source_note_metadata", return_value=())
        )
        if module == "tools.tool_relabel_alt":
            stack.enter_context(
                patch(
                    "tools.tool_relabel_alt._cleanup_frames",
                    return_value=EMPTY_CLEANUP_FRAMES,
                )
            )

    def test_default_destination_uses_configured_relabel_name(self) -> None:
        configured = Path("asm/Custom_relabel.asm")
        with patch("tools.tool_relabel_alt.asm_path", return_value=configured):
            self.assertEqual(_default_alt_destination("GAME"), configured)

    def test_cleanup_metadata_uses_one_excel_workbook_open(self) -> None:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            segments = root / "segments.xlsx"
            cleanup = root / "cleanup.xlsx"
            segments.touch()
            with pd.ExcelWriter(cleanup) as writer:
                pd.DataFrame({"profile": ["BLOODWYCH439"]}).to_excel(
                    writer, sheet_name="EQUATES", index=False
                )
                pd.DataFrame({"profile": ["BLOODWYCH439"]}).to_excel(
                    writer, sheet_name="FIX_LABELS", index=False
                )
                pd.DataFrame({"profile": ["BLOODWYCH439"]}).to_excel(
                    writer, sheet_name="SOURCE_NOTES", index=False
                )
            excel_file = pd.ExcelFile

            with patch(
                "tools.tool_relabel_alt.pd.ExcelFile", side_effect=excel_file
            ) as workbook_open:
                frames = _cleanup_frames(segments, cleanup)

            workbook_open.assert_called_once_with(cleanup)
            self.assertEqual(
                set(frames), {"equates", "fix_labels", "source_notes"}
            )
            self.assertTrue(all(not frame.empty for frame in frames.values()))

    def test_legacy_and_alt_outputs_are_byte_identical_for_combined_fixture(self) -> None:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "GAME_asmfix.asm"
            legacy_destination = root / "GAME_relabel.asm"
            alt_destination = root / "GAME_relabel_alt.asm"
            source.write_text(
                "StartOld:\n"
                "\tmove.w\t#$40,d0\t; 3040\n"
                "\tlea\tOffsetOld.l,a0\n"
                "\tbra\tQuestion?\n"
                "DeleteOld:\n"
                "\tdc.w\t$0000\n"
                "OffsetOld:\n"
                "\tdc.w\t$0001\n"
                "Base:\n"
                "\tdc.w\t$0002\n"
                "Question?:\n"
                "\trts\n"
                "EndOld:\n"
                "\trts\n",
                encoding="utf-8",
            )
            frame = pd.DataFrame(
                [
                    {
                        "label": "StartOld",
                        "relabel": "StartNew",
                        "source_comment": "Begins the comparison fixture.",
                    },
                    {"label": "EndOld", "relabel": "EndNew"},
                    {"label": "DeleteOld", "relabel": "_delete"},
                    {
                        "label": "OffsetOld",
                        "relabel": "_offset_Base_0x0004",
                    },
                    {"label": "Question?", "relabel": "QuestionTarget"},
                ]
            )
            equate = EquateDefinition(
                profile="BLOODWYCH439",
                name="FixtureValue",
                value=0x40,
                status="verified",
            )
            rule = SourceRule(
                profile="BLOODWYCH439",
                rule_id="FixtureValue@row2",
                action="replace_operand",
                equ_name="FixtureValue",
                scope_start="StartOld",
                scope_end="EndOld",
                mnemonic="move.w",
                match_operands="#$40,d0",
                expected_opcode="3040",
                replacement_operands="#FixtureValue,d0",
                expected_matches=1,
                status="verified",
            )

            with ExitStack() as stack:
                self._metadata_patches(
                    stack,
                    "tools.tool_relabel",
                    frame,
                    equates=(equate,),
                    rules=(rule,),
                )
                relabel_segments(
                    "BLOODWYCH439",
                    root / "segments.xlsx",
                    source=source,
                    destination=legacy_destination,
                )

            with ExitStack() as stack:
                self._metadata_patches(
                    stack,
                    "tools.tool_relabel_alt",
                    frame,
                    equates=(equate,),
                    rules=(rule,),
                )
                relabel_segments_alt(
                    "BLOODWYCH439",
                    root / "segments.xlsx",
                    source=source,
                    destination=alt_destination,
                )

            self.assertEqual(
                legacy_destination.read_bytes(), alt_destination.read_bytes()
            )
            generated = alt_destination.read_text(encoding="utf-8")
            self.assertIn("\tlea\tBase+$0004.l,a0", generated)
            self.assertIn("\tbra\tQuestionTarget", generated)
            self.assertIn("\tmove.w\t#FixtureValue,d0", generated)
            self.assertIn("\t; Begins the comparison fixture.", generated)

    def test_delete_with_same_line_comment_fails_closed(self) -> None:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.asm"
            destination = root / "result.asm"
            source.write_text("KeepMe: ; handwritten\n\trts\n", encoding="utf-8")
            frame = pd.DataFrame([{"label": "KeepMe", "relabel": "_delete"}])

            with ExitStack() as stack:
                self._metadata_patches(stack, "tools.tool_relabel_alt", frame)
                relabel_segments_alt(
                    "BLOODWYCH439",
                    root / "segments.xlsx",
                    source=source,
                    destination=destination,
                )

            self.assertIn("KeepMe: ; handwritten", destination.read_text())

    def test_unsafe_offset_does_not_rewrite_references(self) -> None:
        with TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.asm"
            destination = root / "result.asm"
            source.write_text(
                "Old: ; cannot delete\n\tlea\tOld.l,a0\nBase:\n\trts\n",
                encoding="utf-8",
            )
            frame = pd.DataFrame(
                [{"label": "Old", "relabel": "_offset_Base_0x0002"}]
            )

            with ExitStack() as stack:
                self._metadata_patches(stack, "tools.tool_relabel_alt", frame)
                relabel_segments_alt(
                    "BLOODWYCH439",
                    root / "segments.xlsx",
                    source=source,
                    destination=destination,
                )

            generated = destination.read_text(encoding="utf-8")
            self.assertIn("Old: ; cannot delete", generated)
            self.assertIn("\tlea\tOld.l,a0", generated)


if __name__ == "__main__":
    unittest.main()

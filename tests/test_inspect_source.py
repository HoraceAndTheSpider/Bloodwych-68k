from __future__ import annotations

import io
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

import pandas as pd

from tools.tool_inspect import _parse_dc_bytes, inspect_source


class InspectSourceTests(unittest.TestCase):
    def test_devpac_doubled_quote_delimiters_emit_one_character(self) -> None:
        self.assertEqual(
            _parse_dc_bytes("\tdc.b\t'N''EGG'\t;4E27454747"),
            b"N'EGG",
        )
        self.assertEqual(
            _parse_dc_bytes('\tdc.b\t"I""M DUE"\t;49224D20445545'),
            b'I"M DUE',
        )

    def test_failed_block_is_not_replaced(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            clean_dir = root / "data"
            clean_dir.mkdir()
            relabel_source = root / "GAME_relabel.asm"
            relabel_source.write_text(
                "GoodBlock:\n"
                "\tdc.b\t$01,$02,$03,$04\n"
                "BadBlock:\n"
                "\tdc.b\t$05,$06,$07,$08\n"
                "NextLabel:\n"
                "\trts\n",
                encoding="utf-8",
            )
            (clean_dir / "good.bin").write_bytes(bytes((1, 2, 3, 4)))
            (clean_dir / "bad.bin").write_bytes(bytes((5, 6, 7, 9)))
            segments = pd.DataFrame(
                (
                    {
                        "label": "GoodBlock",
                        "relabel": "GoodBlock",
                        "name": "good.bin",
                        "size": 4,
                    },
                    {
                        "label": "BadBlock",
                        "relabel": "BadBlock",
                        "name": "bad.bin",
                        "size": 4,
                    },
                )
            )

            def fake_asm_path(_master: str, stage: str) -> Path:
                if stage == "relabel":
                    return relabel_source
                return root / "GAME.asm"

            output_log = io.StringIO()
            with (
                patch(
                    "tools.tool_inspect.get_profile",
                    return_value=SimpleNamespace(clean_dir=clean_dir),
                ),
                patch("tools.tool_inspect.project_asm_path", side_effect=fake_asm_path),
                patch("tools.tool_inspect.load_segments", return_value=segments),
                patch(
                    "tools.tool_inspect.relative_to_root",
                    side_effect=lambda path: path.name,
                ),
                redirect_stdout(output_log),
            ):
                output_path = inspect_source("GAME", root / "segments.xlsx")

            generated = output_path.read_text(encoding="utf-8")
            self.assertIn('GoodBlock:\n\tINCBIN "/good.bin"', generated)
            self.assertIn("BadBlock:\n\tdc.b\t$05,$06,$07,$08", generated)
            self.assertNotIn('INCBIN "bad.bin"', generated)
            self.assertIn("FAIL - source block retained", output_log.getvalue())
            self.assertIn(
                "1 valid/replaced, 1 failed/retained, 0 skipped",
                output_log.getvalue(),
            )

    def test_grouped_layout_replaces_internal_labels_with_multiple_incbins(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            clean_dir = root / "data"
            clean_dir.mkdir()
            relabel_source = root / "GAME_relabel.asm"
            relabel_source.write_text(
                "Before:\n"
                "\trts\n"
                "Beholder_Body:\n"
                "\tdc.b\t$01,$02\n"
                "Old_Internal_1:\n"
                "\tdc.w\t$0304\n"
                "Old_Internal_2:\n"
                "\tdc.b\t$05,$06,$07\n"
                "After:\n"
                "\trts\n",
                encoding="utf-8",
            )
            files = {
                "body.gfx": bytes((1, 2)),
                "upper.gfx": bytes((3, 4)),
                "near.gfx": bytes((5,)),
                "far.gfx": bytes((6, 7)),
            }
            for name, data in files.items():
                (clean_dir / name).write_bytes(data)
            segments = pd.DataFrame(
                (
                    {
                        "label": "Old_Whole_Beholder",
                        "relabel": "Beholder_Body",
                        "name": "body.gfx",
                        "offset": 100,
                        "size": 2,
                        "data_action": "data_start",
                    },
                    {
                        "label": "Old_Whole_Beholder",
                        "relabel": "Beholder_UpperEyes",
                        "name": "upper.gfx",
                        "offset": 102,
                        "size": 2,
                        "data_action": "data_append",
                    },
                    {
                        "label": "Old_Whole_Beholder",
                        "relabel": "Beholder_CentralEye_Near",
                        "name": "near.gfx",
                        "offset": 104,
                        "size": 1,
                        "data_action": "data_append",
                    },
                    {
                        "label": "Old_Whole_Beholder",
                        "relabel": "Beholder_CentralEye_Far",
                        "name": "far.gfx",
                        "offset": 105,
                        "size": 2,
                        "data_action": "data_append",
                    },
                )
            )

            def fake_asm_path(_master: str, stage: str) -> Path:
                if stage == "relabel":
                    return relabel_source
                return root / "GAME.asm"

            with (
                patch(
                    "tools.tool_inspect.get_profile",
                    return_value=SimpleNamespace(clean_dir=clean_dir),
                ),
                patch("tools.tool_inspect.project_asm_path", side_effect=fake_asm_path),
                patch("tools.tool_inspect.load_segments", return_value=segments),
                patch(
                    "tools.tool_inspect.relative_to_root",
                    side_effect=lambda path: path.name,
                ),
            ):
                output_path = inspect_source("GAME", root / "segments.xlsx")

            generated = output_path.read_text(encoding="utf-8")
            self.assertIn(
                "Beholder_Body:\n"
                '\tINCBIN "/body.gfx"\n'
                "Beholder_UpperEyes:\n"
                '\tINCBIN "/upper.gfx"\n'
                "Beholder_CentralEye_Near:\n"
                "\tdc.b\t$05\n"
                "Beholder_CentralEye_Far:\n"
                '\tINCBIN "/far.gfx"',
                generated,
            )
            self.assertNotIn("Old_Internal_1:", generated)
            self.assertNotIn("Old_Internal_2:", generated)
            self.assertIn("After:\n\trts", generated)

    def test_symbolic_dc_expression_uses_resource_comment_bytes(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            clean_dir = root / "data"
            clean_dir.mkdir()
            relabel_source = root / "GAME_relabel.asm"
            relabel_source.write_text(
                "Lookup:\n"
                "\tdc.w\tEnd-Start\t;00A8\n"
                "After:\n"
                "\trts\n",
                encoding="utf-8",
            )
            (clean_dir / "lookup.offsets").write_bytes(bytes.fromhex("00A8"))
            segments = pd.DataFrame(
                (
                    {
                        "label": "Lookup",
                        "relabel": "Lookup",
                        "name": "lookup.offsets",
                        "size": 2,
                    },
                )
            )

            def fake_asm_path(_master: str, stage: str) -> Path:
                if stage == "relabel":
                    return relabel_source
                return root / "GAME.asm"

            with (
                patch(
                    "tools.tool_inspect.get_profile",
                    return_value=SimpleNamespace(clean_dir=clean_dir),
                ),
                patch("tools.tool_inspect.project_asm_path", side_effect=fake_asm_path),
                patch("tools.tool_inspect.load_segments", return_value=segments),
                patch(
                    "tools.tool_inspect.relative_to_root",
                    side_effect=lambda path: path.name,
                ),
            ):
                output_path = inspect_source("GAME", root / "segments.xlsx")

            self.assertIn(
                'Lookup:\n\tINCBIN "/lookup.offsets"',
                output_path.read_text(encoding="utf-8"),
            )

    def test_noncontiguous_group_is_retained(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            clean_dir = root / "data"
            clean_dir.mkdir()
            relabel_source = root / "GAME_relabel.asm"
            relabel_source.write_text(
                "Combined:\n\tdc.b\t$01,$02\nAfter:\n\trts\n",
                encoding="utf-8",
            )
            (clean_dir / "one.bin").write_bytes(b"\x01")
            (clean_dir / "two.bin").write_bytes(b"\x02")
            segments = pd.DataFrame(
                (
                    {
                        "label": "Original",
                        "relabel": "Combined",
                        "name": "one.bin",
                        "offset": 10,
                        "size": 1,
                        "data_action": "data_start",
                    },
                    {
                        "label": "Original",
                        "relabel": "Second",
                        "name": "two.bin",
                        "offset": 12,
                        "size": 1,
                        "data_action": "data_append",
                    },
                )
            )

            def fake_asm_path(_master: str, stage: str) -> Path:
                if stage == "relabel":
                    return relabel_source
                return root / "GAME.asm"

            with (
                patch(
                    "tools.tool_inspect.get_profile",
                    return_value=SimpleNamespace(clean_dir=clean_dir),
                ),
                patch("tools.tool_inspect.project_asm_path", side_effect=fake_asm_path),
                patch("tools.tool_inspect.load_segments", return_value=segments),
            ):
                output_path = inspect_source("GAME", root / "segments.xlsx")

            generated = output_path.read_text(encoding="utf-8")
            self.assertIn("Combined:\n\tdc.b\t$01,$02", generated)
            self.assertNotIn("INCBIN", generated)

    def test_group_is_retained_when_removed_internal_label_is_still_referenced(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            clean_dir = root / "data"
            clean_dir.mkdir()
            relabel_source = root / "GAME_relabel.asm"
            relabel_source.write_text(
                "Lookup:\n"
                "\tdc.w\tOld_Internal-Combined\t;0001\n"
                "Combined:\n"
                "\tdc.b\t$01\n"
                "Old_Internal:\n"
                "\tdc.b\t$02\n"
                "After:\n"
                "\trts\n",
                encoding="utf-8",
            )
            (clean_dir / "one.bin").write_bytes(b"\x01")
            (clean_dir / "two.bin").write_bytes(b"\x02")
            segments = pd.DataFrame(
                (
                    {
                        "label": "Original",
                        "relabel": "Combined",
                        "name": "one.bin",
                        "offset": 10,
                        "size": 1,
                        "data_action": "data_start",
                    },
                    {
                        "label": "Original",
                        "relabel": "Second",
                        "name": "two.bin",
                        "offset": 11,
                        "size": 1,
                        "data_action": "data_append",
                    },
                )
            )

            def fake_asm_path(_master: str, stage: str) -> Path:
                if stage == "relabel":
                    return relabel_source
                return root / "GAME.asm"

            with (
                patch(
                    "tools.tool_inspect.get_profile",
                    return_value=SimpleNamespace(clean_dir=clean_dir),
                ),
                patch("tools.tool_inspect.project_asm_path", side_effect=fake_asm_path),
                patch("tools.tool_inspect.load_segments", return_value=segments),
            ):
                output_path = inspect_source("GAME", root / "segments.xlsx")

            generated = output_path.read_text(encoding="utf-8")
            self.assertIn("Combined:\n\tdc.b\t$01", generated)
            self.assertIn("Old_Internal:\n\tdc.b\t$02", generated)
            self.assertNotIn("INCBIN", generated)


if __name__ == "__main__":
    unittest.main()

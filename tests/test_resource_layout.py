from __future__ import annotations

import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import pandas as pd

from tools.resource_layout import resource_layouts
from tools.tool_common import ToolError
from tools.tool_relabel import relabel_segments


class ResourceLayoutTests(unittest.TestCase):
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
                        "data_action": "data_start",
                    },
                    {
                        "label": "OldAnchor",
                        "relabel": "NewSecond",
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
            self.assertNotIn("NewSecond:", generated)
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


if __name__ == "__main__":
    unittest.main()

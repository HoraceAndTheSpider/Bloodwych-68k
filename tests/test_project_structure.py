from __future__ import annotations

import unittest
from unittest.mock import patch

import main

from tools.tool_common import (
    ASM_DIR,
    DATA_DIR,
    DEFAULT_SEGMENTS_FILE,
    PROFILES,
    ToolError,
    asm_path,
    get_profile,
    load_segments,
    parse_int,
)


class ProjectStructureTests(unittest.TestCase):
    def test_gui_commands_follow_the_source_generation_workflow(self) -> None:
        self.assertEqual(
            main.GUI_COMMANDS,
            ("extract", "relabel", "inspect", "patch", "graphics", "maps"),
        )
        self.assertEqual(main.GUI_LABELS["inspect"], "Inspect / Data")
        self.assertEqual(main.GUI_LABELS["graphics"], "Data Viewer")
        self.assertEqual(main.GUI_LABELS["maps"], "Map Viewer / Editor")

    def test_bare_main_launch_uses_gui_command(self) -> None:
        commands = []

        def record_command(args, _parser):
            commands.append(args.command)
            return 0

        with (
            patch("sys.argv", ["main.py"]),
            patch("main.launch_gui", side_effect=["profiles", None]) as launch_gui,
            patch("main.run", side_effect=record_command) as run,
        ):
            self.assertEqual(main.main(), 0)
        self.assertEqual(launch_gui.call_count, 2)
        run.assert_called_once()
        self.assertEqual(commands, ["profiles"])

    def test_front_page_tools_return_to_launcher(self) -> None:
        commands = []

        def record_command(args, _parser):
            commands.append(args.command)
            return 0

        with (
            patch("sys.argv", ["main.py"]),
            patch(
                "main.launch_gui",
                side_effect=["extract", "relabel", "inspect", "patch", None],
            ) as launch_gui,
            patch("main.run", side_effect=record_command),
        ):
            self.assertEqual(main.main(), 0)
        self.assertEqual(launch_gui.call_count, 5)
        self.assertEqual(commands, ["extract", "relabel", "inspect", "patch"])

    def test_graphics_viewer_returns_to_launcher(self) -> None:
        with (
            patch("sys.argv", ["main.py"]),
            patch(
                "main.launch_gui", side_effect=["graphics", "profiles", None]
            ) as launch_gui,
            patch("tools.graphics_viewer.launch_graphics_viewer") as viewer,
            patch("main.run", return_value=0),
        ):
            self.assertEqual(main.main(), 0)
        self.assertEqual(launch_gui.call_count, 3)
        viewer.assert_called_once_with()

    def test_map_editor_returns_to_launcher(self) -> None:
        with (
            patch("sys.argv", ["main.py"]),
            patch(
                "main.launch_gui", side_effect=["maps", "profiles", None]
            ) as launch_gui,
            patch("tools.map_editor.app.launch_map_editor") as viewer,
            patch("main.run", return_value=0),
        ):
            self.assertEqual(main.main(), 0)
        self.assertEqual(launch_gui.call_count, 3)
        viewer.assert_called_once_with()

    def test_graphics_cli_can_start_with_modified_overlay(self) -> None:
        parser = main.build_parser()
        args = parser.parse_args(["graphics", "--modified"])
        with patch("tools.graphics_viewer.launch_graphics_viewer") as viewer:
            self.assertEqual(main.run(args, parser), 0)
        viewer.assert_called_once_with(
            get_profile("BLOODWYCH439").clean_dir,
            prefer_modified=True,
        )

    def test_map_editor_cli_can_overlay_a_savegame(self) -> None:
        parser = main.build_parser()
        args = parser.parse_args(["maps", "--savegame", "whdload/bloodsave0"])
        with patch("tools.map_editor.app.launch_map_editor") as viewer:
            self.assertEqual(main.run(args, parser), 0)
        viewer.assert_called_once_with(
            get_profile("BLOODWYCH439").clean_dir,
            savegame_path=main.Path("whdload/bloodsave0"),
        )

    def test_configured_binary_names(self) -> None:
        self.assertEqual(
            [profile.filename for profile in PROFILES],
            [
                "BLOODWYCH439",
                "BLOODWYCH102",
                "BLOODWYCH1927",
                "BEXT43",
                "AtariST_DEMO_CODE",
            ],
        )

    def test_profile_alias_and_canonical_data_path(self) -> None:
        profile = get_profile("BLOODWYCH439")
        self.assertEqual(profile.filename, "BLOODWYCH439")
        self.assertEqual(profile.clean_dir, DATA_DIR / "BLOODWYCH439-clean")

    def test_439_asm_file_conventions(self) -> None:
        self.assertEqual(asm_path("BLOODWYCH439"), ASM_DIR / "Bloodwych439.asm")
        self.assertEqual(
            asm_path("BLOODWYCH439", "relabel"),
            ASM_DIR / "BLOODWYCH439_relabel.asm",
        )
        self.assertEqual(
            asm_path("BLOODWYCH439", "data"),
            ASM_DIR / "BLOODWYCH439_relabel_data.asm",
        )

    def test_parse_int(self) -> None:
        self.assertEqual(parse_int("$4C37E"), 0x4C37E)
        self.assertEqual(parse_int("0x4C37E"), 0x4C37E)
        self.assertEqual(parse_int(312190), 312190)
        self.assertIsNone(parse_int(""))

    def test_segments_workbook_uses_439_sheet(self) -> None:
        frame = load_segments(DEFAULT_SEGMENTS_FILE, "Bloodwych439")
        self.assertGreater(len(frame), 2600)
        self.assertTrue({"label", "relabel", "name", "offset", "size"} <= set(frame.columns))

    def test_unmapped_profile_is_explicit(self) -> None:
        with self.assertRaisesRegex(ToolError, "No segments.xlsx sheet"):
            load_segments(DEFAULT_SEGMENTS_FILE, "BLOODWYCH102")


if __name__ == "__main__":
    unittest.main()

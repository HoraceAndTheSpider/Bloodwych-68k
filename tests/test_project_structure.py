from __future__ import annotations

import unittest
from contextlib import redirect_stderr
from io import StringIO
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import ANY, patch

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
            (
                "extract",
                "asmfix",
                "relabel",
                "inspect",
                "format",
                "patch",
                "graphics",
                "maps",
                "interface",
                "files",
            ),
        )
        self.assertEqual(
            main.DATA_GUI_COMMANDS,
            ("extract", "asmfix", "relabel", "inspect", "format", "patch"),
        )
        self.assertEqual(
            main.VIEWER_GUI_COMMANDS, ("graphics", "maps", "interface", "files")
        )
        self.assertEqual(main.GUI_LABELS["inspect"], "Inspect / Data")
        self.assertEqual(main.GUI_LABELS["graphics"], "Data Viewer")
        self.assertEqual(main.GUI_LABELS["maps"], "Map Viewer / Editor")
        self.assertEqual(main.GUI_LABELS["interface"], "Interface Viewer / Editor")

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
                side_effect=[
                    "extract",
                    "asmfix",
                    "relabel",
                    "inspect",
                    "format",
                    "patch",
                    None,
                ],
            ) as launch_gui,
            patch("main.run", side_effect=record_command),
            patch("tools.session_panel.launch_session_browser") as browser,
        ):
            self.assertEqual(main.main(), 0)
        self.assertEqual(launch_gui.call_count, 7)
        browser.assert_called_once()
        self.assertEqual(
            commands,
            ["extract", "asmfix", "relabel", "inspect", "format"],
        )

    def test_launcher_reuses_one_session_across_viewers(self):
        sessions = []
        name = "data/characters.heads"
        def edit(_root, *, session):
            sessions.append(session)
            session.write(name, bytes([0]) + session.read(name)[1:])
        def view(_root, *, session):
            sessions.append(session)
            self.assertEqual(session.read(name)[0], 0)
        with (
            patch("sys.argv", ["main.py"]),
            patch("main.launch_gui", side_effect=["maps", "graphics", None]),
            patch("tools.map_editor.app.launch_map_editor", side_effect=edit),
            patch("tools.graphics_viewer.launch_graphics_viewer", side_effect=view),
        ):
            self.assertEqual(main.main(), 0)
        self.assertIs(sessions[0], sessions[1])

    def test_front_page_profile_follows_loaded_binary_and_save(self):
        from tools.tool_common import BINARIES_DIR, WHDLOAD_DIR

        def load_binary(session):
            session.import_binary(BINARIES_DIR / "BookOfSkulls_P_Beta5")

        def load_save(session):
            session.select_save(WHDLOAD_DIR / "bloodsave0")

        with (
            patch("sys.argv", ["main.py"]),
            patch("main.launch_gui", side_effect=["files", "files", None]) as launch_gui,
            patch("tools.session_panel.launch_session_browser") as browser,
        ):
            actions = iter((load_binary, load_save))
            browser.side_effect = lambda session: next(actions)(session)
            self.assertEqual(main.main(), 0)
        self.assertEqual(launch_gui.call_args_list[1].kwargs["profile_name"], "BLOODWYCH439 | BookOfSkulls_P_Beta5")
        self.assertEqual(launch_gui.call_args_list[2].kwargs["profile_name"], "BLOODWYCH439 | BookOfSkulls_P_Beta5 | SAVE: bloodsave0")

    def test_front_page_tool_error_is_reported_and_returns_to_launcher(self) -> None:
        error_output = StringIO()
        with (
            patch("sys.argv", ["main.py"]),
            patch("main.launch_gui", side_effect=["relabel", "profiles", None])
            as launch_gui,
            patch("main.run", side_effect=[ToolError("bad equate"), 0]) as run,
            redirect_stderr(error_output),
        ):
            self.assertEqual(main.main(), 0)
        self.assertEqual(launch_gui.call_count, 3)
        self.assertEqual(run.call_count, 2)
        self.assertIn("Error: bad equate", error_output.getvalue())

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
        viewer.assert_called_once_with(get_profile("BLOODWYCH439").clean_dir, session=ANY)

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
        viewer.assert_called_once_with(get_profile("BLOODWYCH439").clean_dir, session=ANY)

    def test_interface_editor_returns_to_launcher(self) -> None:
        with (
            patch("sys.argv", ["main.py"]),
            patch(
                "main.launch_gui", side_effect=["interface", "profiles", None]
            ) as launch_gui,
            patch("tools.interface_viewer.launch_interface_viewer") as viewer,
            patch("main.run", return_value=0),
        ):
            self.assertEqual(main.main(), 0)
        self.assertEqual(launch_gui.call_count, 3)
        viewer.assert_called_once_with(get_profile("BLOODWYCH439").clean_dir, session=ANY)

    def test_front_page_viewer_uses_selected_profile(self) -> None:
        with (
            patch(
                "sys.argv", ["main.py", "--master", "BookOfSkulls_P_Beta5"]
            ),
            patch("main.launch_gui", side_effect=["maps", None]) as launch_gui,
            patch("tools.map_editor.app.launch_map_editor") as viewer,
        ):
            self.assertEqual(main.main(), 0)
        launch_gui.assert_any_call(profile_name="BookOfSkulls_P_Beta5")
        viewer.assert_called_once_with(
            get_profile("BookOfSkulls_P_Beta5").clean_dir, session=ANY
        )

    def test_graphics_cli_can_start_with_modified_overlay(self) -> None:
        parser = main.build_parser()
        args = parser.parse_args(["graphics", "--modified"])
        with patch("tools.graphics_viewer.launch_graphics_viewer") as viewer:
            self.assertEqual(main.run(args, parser), 0)
        viewer.assert_called_once_with(
            get_profile("BLOODWYCH439").clean_dir,
            session=ANY,
            prefer_modified=True,
        )

    def test_map_editor_cli_can_overlay_a_savegame(self) -> None:
        parser = main.build_parser()
        args = parser.parse_args(["maps", "--savegame", "whdload/bloodsave0"])
        with patch("tools.map_editor.app.launch_map_editor") as viewer:
            self.assertEqual(main.run(args, parser), 0)
        viewer.assert_called_once_with(
            get_profile("BLOODWYCH439").clean_dir,
            session=ANY,
            savegame_path=main.Path("whdload/bloodsave0"),
        )

    def test_global_savegame_is_available_to_all_viewers(self) -> None:
        parser = main.build_parser()
        args = parser.parse_args(["--savegame", "whdload/bloodsave0", "graphics"])
        with patch("tools.graphics_viewer.launch_graphics_viewer") as viewer:
            self.assertEqual(main.run(args, parser), 0)
        viewer.assert_called_once_with(
            get_profile("BLOODWYCH439").clean_dir,
            session=ANY,
            prefer_modified=False,
            savegame_path=main.Path("whdload/bloodsave0"),
        )

    def test_interface_cli_can_start_with_modified_overlay(self) -> None:
        parser = main.build_parser()
        args = parser.parse_args(["interface", "--modified"])
        with patch("tools.interface_viewer.launch_interface_viewer") as viewer:
            self.assertEqual(main.run(args, parser), 0)
        viewer.assert_called_once_with(
            get_profile("BLOODWYCH439").clean_dir,
            session=ANY,
            prefer_modified=True,
        )

    def test_asmfix_cli_builds_isolated_source(self) -> None:
        parser = main.build_parser()
        args = parser.parse_args(["asmfix"])
        with patch("main.build_asmfix") as build:
            self.assertEqual(main.run(args, parser), 0)
        build.assert_called_once_with(
            "BLOODWYCH439", str(DEFAULT_SEGMENTS_FILE), None
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

    def test_book_of_skulls_uses_439_layout_with_isolated_data_paths(self) -> None:
        profile = get_profile("BookOfSkulls_P_Beta5")
        self.assertEqual(profile.segment_sheet, "BLOODWYCH439")
        self.assertEqual(
            profile.clean_dir, DATA_DIR / "BookOfSkulls_P_Beta5-clean"
        )
        self.assertEqual(
            profile.modified_dir, DATA_DIR / "BookOfSkulls_P_Beta5-modified"
        )
        frame = load_segments(DEFAULT_SEGMENTS_FILE, profile.filename)
        self.assertGreater(len(frame), 2600)

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
        self.assertEqual(
            asm_path("BLOODWYCH439", "asmfix"),
            ASM_DIR / "Bloodwych439_asmfix.asm",
        )

    def test_parse_int(self) -> None:
        self.assertEqual(parse_int("$4C37E"), 0x4C37E)
        self.assertEqual(parse_int("0x4C37E"), 0x4C37E)
        self.assertEqual(parse_int("-$02"), -2)
        self.assertEqual(parse_int("-0x02"), -2)
        self.assertEqual(parse_int("+ $02"), 2)
        self.assertEqual(parse_int(312190), 312190)
        self.assertIsNone(parse_int(""))

    def test_segments_workbook_uses_439_sheet(self) -> None:
        frame = load_segments(DEFAULT_SEGMENTS_FILE, "Bloodwych439")
        self.assertGreater(len(frame), 2600)
        self.assertTrue({"label", "relabel", "name", "offset", "size"} <= set(frame.columns))

    def test_segment_loader_ignores_an_exact_repeated_header_row(self) -> None:
        with TemporaryDirectory() as directory:
            segments = Path(directory) / "segments.csv"
            segments.write_text(
                "label,relabel,name,offset,size,data_action\n"
                "Start,First,data/first.bin,$10,$02,data_start\n"
                "label,relabel,name,offset,size,data_action\n"
                "Next,Second,data/second.bin,$12,$02,data_append\n"
            )
            frame = load_segments(segments, "BLOODWYCH439")

        self.assertEqual(list(frame.index), [0, 2])
        self.assertEqual(list(frame["label"]), ["Start", "Next"])

    def test_unmapped_profile_is_explicit(self) -> None:
        with self.assertRaisesRegex(ToolError, "No segments.xlsx sheet"):
            load_segments(DEFAULT_SEGMENTS_FILE, "BLOODWYCH102")


if __name__ == "__main__":
    unittest.main()

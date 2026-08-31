"""Exercise the original tab-switch crash and shared controls without a display."""
from __future__ import annotations
import os
import tempfile
from pathlib import Path
import unittest
from unittest.mock import patch

from tools.edit_session import EditSession
from tools.graphics_viewer import launch_graphics_viewer
from tools.session_panel import SessionPanel


class SessionUITests(unittest.TestCase):
    def test_front_menu_reload_is_disabled(self):
        session = EditSession()
        panel = SessionPanel(session)
        with patch.object(session, "reload") as reload_section:
            panel.perform("RELOAD")
            panel.perform("RELOAD")
            reload_section.assert_not_called()
        self.assertIn("front menu", panel.help_text("RELOAD"))

    def test_reload_explains_scope_and_keeps_other_sections(self):
        session = EditSession()
        stats, heads = "data/champions.stats", "data/characters.heads"
        session.write(stats, b"\xff" + session.read(stats)[1:])
        session.write(heads, b"\xff" + session.read(heads)[1:])
        panel = SessionPanel(session, lambda: (stats,), section_label="Champion stats (all 16 champions)")
        panel.perform("RELOAD")
        self.assertIn("Champion stats (all 16 champions)", panel.message)
        self.assertIn("Other sections keep their edits", panel.help_text("RELOAD"))
        self.assertEqual(session.read(stats)[0], 255)
        panel.perform("RELOAD")
        self.assertEqual(session.read(stats), session.baseline(stats))
        self.assertEqual(session.read(heads)[0], 255)

    def test_export_confirms_and_does_not_patch(self):
        session = EditSession()
        panel = SessionPanel(session)
        with patch.object(session, "export", return_value=()) as export, patch.object(session, "patch") as patch_output:
            panel.perform("EXPORT")
            export.assert_not_called()
            self.assertTrue(panel.open)
            self.assertIn(str(session.modified_root), panel.message)
            panel.perform("EXPORT")
            export.assert_called_once_with()
            patch_output.assert_not_called()
        self.assertIn("front-menu Extract", panel.help_text("EXPORT"))

    def test_loading_selected_binary_updates_input_and_export_folder(self):
        from tools.tool_common import DATA_DIR
        session = EditSession()
        export_folder = session.modified_root
        panel = SessionPanel(session)
        panel.selected = next(i for i, (path, _, _) in enumerate(panel.catalog) if path.name == "BookOfSkulls_P_Beta5")
        selected_path = panel.catalog[panel.selected][0]
        panel.perform("USE SELECTED")
        self.assertEqual(session.binary_name, "BLOODWYCH439")
        self.assertEqual(session.modified_root, export_folder)
        panel.perform("USE SELECTED")
        self.assertEqual(session.binary_source, selected_path.resolve())
        self.assertEqual(session.binary_name, selected_path.name)
        self.assertEqual(panel.path_text, str(selected_path))
        self.assertEqual(session.modified_root, DATA_DIR / "BookOfSkulls_P_Beta5-modified")
        self.assertIn(str(session.modified_root), panel.message)
        # Selecting the reference again switches its export destination back.
        panel.selected = next(i for i, (path, _, _) in enumerate(panel.catalog) if path.name == "BLOODWYCH439")
        panel.perform("USE SELECTED")
        panel.perform("USE SELECTED")
        self.assertEqual(session.modified_root, export_folder)

    def test_unmapped_binaries_are_red_and_cannot_be_loaded(self):
        session = EditSession()
        panel = SessionPanel(session)
        for name in ("BLOODWYCH102", "BLOODWYCH1927", "BEXT43", "AtariST_DEMO_CODE"):
            with self.subTest(name=name):
                panel.selected = next(i for i, (path, _, _) in enumerate(panel.catalog) if path.name == name)
                red, green, blue = panel.row_colour(panel.selected)
                self.assertGreater(red, green)
                self.assertGreater(red, blue)
                self.assertIn("UNMAPPED", panel.catalog[panel.selected][1])
                with patch.object(session, "import_binary") as load:
                    panel.perform("USE SELECTED")
                    panel.perform("USE SELECTED")
                    load.assert_not_called()
                self.assertIn("unmapped", panel.message)

    def test_save_toggle_changes_memory_only_and_remembers_save(self):
        save = Path(__file__).resolve().parents[1] / "whdload/bloodsave0"
        original = save.read_bytes()
        session = EditSession(savegame_path=save)
        panel = SessionPanel(session)
        session.write("data/champions.pockets", b"\x50" + session.read("data/champions.pockets")[1:])
        with patch.object(session, "patch") as patch_output, patch.object(session, "export") as export:
            panel.perform("SAVE DATA")
            self.assertEqual(session.save_path, save)
            self.assertIn("discard in-memory edits", panel.message)
            panel.perform("SAVE DATA")
            self.assertIsNone(session.save_path)
            self.assertEqual(panel.action_label("SAVE DATA"), "SAVE DATA: OFF")
            # A newly opened section can switch the same save back on.
            panel = SessionPanel(session)
            panel.perform("SAVE DATA")
            self.assertIsNone(session.save_path)
            panel.perform("SAVE DATA")
            self.assertEqual(session.save_path, save)
            self.assertEqual(session.save_data, original)
            patch_output.assert_not_called()
            export.assert_not_called()
        self.assertEqual(save.read_bytes(), original)

    def test_non_champion_artwork_can_switch_to_champion_data(self):
        with patch.dict(os.environ, {"SDL_VIDEODRIVER": "dummy", "SDL_AUDIODRIVER": "dummy"}):
            import pygame
            click = lambda pos: pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=pos)
            frames = [
                [click((160, 440))],  # Artwork $55, well beyond champions $00-$0F.
                [click((500, 65))],   # Champion data tab.
                [],                  # Render the selected champion.
                [pygame.event.Event(pygame.QUIT)],
            ]
            with patch("pygame.event.get", side_effect=frames) as events:
                launch_graphics_viewer(session=EditSession("BookOfSkulls_P_Beta5"))
            self.assertEqual(events.call_count, 4)

    def test_all_book_viewer_pages_render_with_the_shared_panel(self):
        from tools.map_editor.app import launch_map_editor
        from tools.interface_viewer import launch_interface_viewer
        draw = SessionPanel.draw

        def draw_open(panel, pygame, screen):
            panel.open = True
            draw(panel, pygame, screen)

        with patch.dict(os.environ, {"SDL_VIDEODRIVER": "dummy", "SDL_AUDIODRIVER": "dummy"}), tempfile.TemporaryDirectory() as temporary:
            import pygame
            session = EditSession("BookOfSkulls_P_Beta5")
            cases = [(launch_graphics_viewer, {"initial_category": category})
                     for category in ("character", "champion", "object", "dungeon")]
            cases += [(launch_map_editor, {"initial_tab": 3}), (launch_interface_viewer, {})]
            for launch, kwargs in cases:
                with self.subTest(viewer=launch.__name__, kwargs=kwargs), patch("pygame.event.get", return_value=[]), patch.object(SessionPanel, "draw", draw_open):
                    launch(session=session, screenshot_path=Path(temporary) / "page.png", **kwargs)

    def test_oversized_resource_disables_patch_action(self):
        session = EditSession()
        name = "monsters/beholder.colours"
        session.write(name, session.read(name) * 2)
        panel = SessionPanel(session, lambda: (name,))
        with patch.object(session, "patch") as patch_output:
            panel.perform("PATCH")
            patch_output.assert_not_called()
        self.assertIn("Source rebuild", panel.message)
        panel.perform("RELOAD")
        self.assertIn("confirm", panel.message)
        panel.perform("RELOAD")
        self.assertEqual(session.patch_blockers(), ())

    def test_save_patch_requires_confirmation_in_common_panel(self):
        session = EditSession(savegame_path=Path(__file__).resolve().parents[1] / "whdload/bloodsave0")
        session.write("data/champions.pockets", b"\x50" + session.read("data/champions.pockets")[1:])
        panel = SessionPanel(session, lambda: tuple(session.specs))
        with patch.object(session, "patch", return_value=Path("modified/save-copy")) as patch_output:
            panel.perform("PATCH")
            patch_output.assert_not_called()
            panel.perform("PATCH")
            patch_output.assert_called_once_with(confirm_save=True)


if __name__ == "__main__":
    unittest.main()

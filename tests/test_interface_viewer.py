"""Pixel and event-loop regressions for the source-led Interface preview."""

import os
from pathlib import Path
import unittest
from unittest.mock import patch

from tools.interface_data import (
    INTERFACE_ACTION_LOAD_SAVE,
    INTERFACE_ACTION_MOVE_FORWARDS,
    INTERFACE_ACTION_PAUSE,
    INTERFACE_ACTION_ROTATE_RIGHT,
    INTERFACE_ACTION_SLEEP_PARTY,
    INTERFACE_MODES,
    InterfaceProject,
)
from tools import interface_viewer as viewer


DATA_ROOT = Path(__file__).resolve().parents[1] / "data/BLOODWYCH439-clean"


class InterfaceViewerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.project = InterfaceProject(DATA_ROOT)

    def setUp(self):
        self.environment = patch.dict(os.environ, {
            "SDL_VIDEODRIVER": "dummy", "SDL_AUDIODRIVER": "dummy",
        })
        self.environment.start()
        self.addCleanup(self.environment.stop)
        try:
            import pygame
        except ImportError:
            self.skipTest("Pygame is not installed")
        self.pg = pygame
        pygame.init()
        self.addCleanup(pygame.quit)

    def click(self, x, y, *, button=1):
        """Create a real scaled click from player-local coordinates."""
        return self.pg.event.Event(
            self.pg.MOUSEBUTTONDOWN, button=button,
            pos=(viewer.PREVIEW_ORIGIN[0] + x * viewer.PREVIEW_SCALE,
                 viewer.PREVIEW_ORIGIN[1] + (y + viewer.PANEL_FRAME_Y) * viewer.PREVIEW_SCALE),
        )

    def action_click(self, action):
        box = next(box for box in self.project.hitboxes["command"] if box.action == action)
        return self.click((box.x_min + box.x_max) // 2, (box.y_min + box.y_max) // 2)

    def key(self, key):
        return self.pg.event.Event(self.pg.KEYDOWN, key=key)

    def render(self, mode, player, state=None, **kwargs):
        panel, _ = viewer.render_interface_panel(
            self.pg, self.project, mode, player=player, alternate_ramp=False,
            ramp_step=0, display_state=state, **kwargs,
        )
        return viewer.frame_interface_panel(self.pg, panel, display_state=state)

    def test_both_borders_have_seven_symmetric_grey_rows(self):
        expected = (68, 102, 136, 170, 136, 102, 68)
        for player in (0, 1):
            frame = self.render(INTERFACE_MODES[0], player)
            for origin in (0, 113):
                for row, grey in enumerate(expected):
                    with self.subTest(player=player, y=origin + row):
                        self.assertTrue(all(
                            frame.get_at((x, origin + row))[:3] == (grey,) * 3
                            for x in range(320)
                        ))

    def test_pause_recolours_all_black_pixels_between_borders_in_every_page(self):
        for mode in INTERFACE_MODES:
            for player in (0, 1):
                with self.subTest(mode=mode.key, player=player):
                    normal = self.render(mode, player)
                    paused = self.render(mode, player, "pause")
                    for y in range(7, 113):
                        for x in range(320):
                            if normal.get_at((x, y))[:3] == (0, 0, 0):
                                self.assertEqual(paused.get_at((x, y))[:3], (68, 0, 0))
                    for y in (*range(7), *range(113, 120)):
                        self.assertEqual(paused.get_at((0, y)), normal.get_at((0, y)))

    def test_load_save_prompt_owns_the_text_line_and_click_target(self):
        mode = INTERFACE_MODES[0]
        plain = self.render(mode, 0, "load_save")
        with_notice = self.render(mode, 0, "load_save", timed_notice="THE DOOR IS LOCKED")
        self.assertEqual(plain.get_buffer().raw, with_notice.get_buffer().raw)
        target = self.pg.Rect(viewer.LOAD_SAVE_EXIT_RECT)
        self.assertTrue(any(
            plain.get_at((x, y + viewer.PANEL_FRAME_Y))[:3] != (0, 0, 0)
            for x in range(target.left, target.right)
            for y in range(target.top, target.bottom)
        ))
        preview = self.pg.Rect(viewer.PREVIEW_ORIGIN, viewer.PREVIEW_SIZE)
        for point in (target.topleft, (target.right - 1, target.bottom - 1)):
            self.assertEqual(viewer.display_state_input(
                self.pg, "load_save", self.click(*point), preview,
            ), (True, None))
        for point in ((target.left - 1, target.top), (target.right, target.top),
                      (target.left, target.top - 1), (target.left, target.bottom)):
            self.assertEqual(viewer.display_state_input(
                self.pg, "load_save", self.click(*point), preview,
            ), (True, "load_save"))

    def run_frames(self, frames):
        """Exercise real event dispatch and drawing, observing resulting state."""
        from tools.edit_session import EditSession
        from tools.joypad_panel import JoypadControls
        from tools.session_panel import SessionPanel

        rendered = []
        draw = viewer.render_interface_panel

        def observe(pygame, project, mode, **kwargs):
            rendered.append((kwargs["display_state"], mode.key, kwargs["right_mode_key"],
                             project.preview_x, project.preview_y, project.preview_facing))
            return draw(pygame, project, mode, **kwargs)

        with patch("pygame.event.get", side_effect=frames), \
                patch("pygame.joystick.get_count", return_value=0), \
                patch.object(viewer, "render_interface_panel", side_effect=observe), \
                patch.object(SessionPanel, "handle", return_value=False) as host_events, \
                patch.object(JoypadControls, "show") as joypad_settings:
            viewer.launch_interface_viewer(initial_mode="comms", session=EditSession())
        joypad_settings.assert_not_called()
        return rendered, [call.args[1] for call in host_events.call_args_list]

    def test_pause_consumes_keys_and_the_resuming_click_before_normal_dispatch(self):
        pause = self.action_click(INTERFACE_ACTION_PAUSE)
        stats = self.click(272, 40)
        quit_event = self.pg.event.Event(self.pg.QUIT)
        rendered, passed = self.run_frames([
            [pause],
            [self.key(self.pg.K_h), self.key(self.pg.K_F8), self.key(self.pg.K_ESCAPE)],
            [stats],
            [quit_event],
        ])
        self.assertEqual([state[0] for state in rendered], [None, "pause", "pause", None])
        self.assertTrue(all(state[1:3] == ("comms", "main") for state in rendered))
        self.assertEqual(passed, [pause, quit_event])

    def test_pause_click_anywhere_including_host_controls_is_consumed(self):
        pause = self.action_click(INTERFACE_ACTION_PAUSE)
        # Actual joypad-settings button: its click must unpause, not open it.
        settings = self.pg.event.Event(self.pg.MOUSEBUTTONDOWN, button=1, pos=(1000, 20))
        quit_event = self.pg.event.Event(self.pg.QUIT)
        rendered, passed = self.run_frames([[pause], [settings], [quit_event]])
        self.assertEqual([state[0] for state in rendered], [None, "pause", None])
        self.assertEqual(passed, [pause, quit_event])

    def test_load_save_blocks_ui_until_f10_or_exit_text(self):
        enter = self.action_click(INTERFACE_ACTION_LOAD_SAVE)
        quit_event = self.pg.event.Event(self.pg.QUIT)
        target = self.pg.Rect(viewer.LOAD_SAVE_EXIT_RECT)
        rendered, passed = self.run_frames([
            [enter, self.click(272, 40)],  # Entry and blocked action in one SDL batch.
            [self.click(240, 64), self.click(160, 45),
             self.pg.event.Event(self.pg.MOUSEBUTTONDOWN, button=1, pos=(360, 65)),
             self.key(self.pg.K_ESCAPE), self.key(self.pg.K_F8), self.key(self.pg.K_F1)],
            [self.key(self.pg.K_F10)],
            [enter],
            [self.click(*target.center)],
            [quit_event],
        ])
        self.assertEqual([state[0] for state in rendered],
                         [None, "load_save", "load_save", None, "load_save", None])
        self.assertTrue(all(state[1:] == ("comms", "main", 2, 5, 0) for state in rendered))
        self.assertEqual(passed, [enter, enter, quit_event])

    def test_sleep_dungeon_click_wakes_without_dispatching_world_action(self):
        sleep = self.action_click(INTERFACE_ACTION_SLEEP_PARTY)
        quit_event = self.pg.event.Event(self.pg.QUIT)
        with patch.object(InterfaceProject, "toggle_preview_door") as toggle:
            rendered, passed = self.run_frames([[sleep], [self.click(160, 45)], [quit_event]])
        self.assertEqual([state[0] for state in rendered], [None, "sleep", None])
        self.assertEqual(rendered[-1][1:], ("main", "main", 2, 5, 0))
        self.assertEqual(passed, [sleep, quit_event])
        toggle.assert_not_called()

    def test_modal_hitbox_overlays_do_not_advertise_inactive_actions(self):
        for state in ("pause", "load_save"):
            for mode in INTERFACE_MODES:
                self.assertEqual(viewer._visible_hitbox_overlays(
                    self.project, mode, comms_menu_page=0, right_mode_key=mode.key,
                    spellbook_spread=0, selected_spell=None, display_state=state,
                ), ())

    def test_display_click_23_operates_switch_while_24_remains_a_door_action(self):
        project = InterfaceProject(DATA_ROOT)
        before = project.preview_map.to_bytes()
        with patch.object(viewer, "InterfaceProject", return_value=project), \
                patch.object(project, "click_preview_wall_feature", wraps=project.click_preview_wall_feature) as switch, \
                patch.object(project, "toggle_preview_door", wraps=project.toggle_preview_door) as door:
            self.run_frames([
                [self.click(232, 65)],  # Turn left: stand (2,5), face the switch westwards.
                [self.click(114, 50)],  # $24: outside the smaller $23 rectangle.
                [self.click(160, 50)],  # $23: operate reference 1, remove target wall.
                [self.click(160, 50)],  # $23 again: restore it.
                [self.pg.event.Event(self.pg.QUIT)],
            ])
        self.assertEqual(switch.call_count, 2)
        self.assertEqual(door.call_count, 1)
        self.assertEqual(project.preview_facing, 3)
        self.assertEqual(project.preview_map.to_bytes(), before)


class InterfaceBackgroundTests(unittest.TestCase):
    def test_movement_and_turns_match_the_map_viewers_floor_and_wall_parity(self):
        from tools.dungeon_view import load_dungeon_background, render_dungeon_scene
        from tools.map_editor.first_person import dungeon_pattern_parity, map_view_placements

        project = InterfaceProject(DATA_ROOT)
        # The scene includes real wall occlusion; verify both background bands
        # at each parity, not merely that the overall frame changes on moving.
        backgrounds = [load_dungeon_background(DATA_ROOT / "gfx", pattern_parity=p) for p in (0, 1)]
        self.assertNotEqual(backgrounds[0], backgrounds[1])
        self.assertEqual(backgrounds[0], [row[::-1] for row in backgrounds[1]])
        for action in (None, INTERFACE_ACTION_MOVE_FORWARDS, INTERFACE_ACTION_ROTATE_RIGHT):
            if action is not None:
                self.assertTrue(project.move_preview_party(action))
            x, y, facing = project.preview_x, project.preview_y, project.preview_facing
            parity = dungeon_pattern_parity(x, y, facing)
            expected, _ = render_dungeon_scene(
                backgrounds[parity], project.dungeon_assets,
                map_view_placements(project.preview_map, 0, x, y, facing),
                pattern_parity=parity,
            )
            with self.subTest(action=action, parity=parity):
                self.assertEqual(project.dungeon_preview, expected)


if __name__ == "__main__":
    unittest.main()

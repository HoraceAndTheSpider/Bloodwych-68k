from __future__ import annotations

from dataclasses import replace
import json
import os
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import Mock, patch

from tools.joypad import (
    ACTIONS, MOVEMENT_ACTIONS, ActionState, Binding, BindingCapture, DeviceIdentity,
    InputState, Layout, LayoutStore,
)


def example_layout(device):
    return Layout(device, {
        "MOVE-FORWARD": Binding("hat", 0, 1, 1),
        "MOVE-BACK": Binding("hat", 0, -1, 1),
        "MOVE-LEFT": Binding("hat", 0, -1, 0),
        "MOVE-RIGHT": Binding("hat", 0, 1, 0),
        "TURN-LEFT": Binding("button", 4),
        "TURN-RIGHT": Binding("button", 5),
        "POINTER-UP": Binding("axis", 3, -1),
        "POINTER-DOWN": Binding("axis", 3, 1),
        "POINTER-LEFT": Binding("axis", 2, -1),
        "POINTER-RIGHT": Binding("axis", 2, 1),
        "FIRE": Binding("button", 0),
    })


class LayoutTests(unittest.TestCase):
    def setUp(self):
        self.device = DeviceIdentity("test-guid", "Test controller", 6, 12, 1)
        self.layout = example_layout(self.device)

    def test_layout_round_trip_and_device_matching(self):
        with TemporaryDirectory() as directory:
            store = LayoutStore(directory)
            self.assertIsNone(store.load(self.device)[0])
            store.save(self.layout)
            self.assertEqual(store.load(self.device), (self.layout, None))
            self.assertIsNotNone(store.load(replace(self.device, name="Alternate display name"))[0])
            for changed in (replace(self.device, guid="other"), replace(self.device, axes=7),
                            replace(self.device, platform="other-platform")):
                self.assertIsNone(store.load(changed)[0])
            self.assertEqual(list(Path(directory).glob("*.tmp")), [])

    def test_bad_layout_fails_closed(self):
        with TemporaryDirectory() as directory:
            store = LayoutStore(directory)
            store.save(self.layout)
            path = store.path(self.device)
            data = json.loads(path.read_text())
            for content in ("{", "[]", "null", '{"version": 99}',
                            json.dumps({**data, "bindings": {"FIRE": {"kind": "button", "index": 0}}})):
                path.write_text(content)
                layout, error = store.load(self.device)
                self.assertIsNone(layout)
                self.assertIn("Cannot use", error)

    def test_duplicate_unavailable_and_incomplete_bindings_cannot_replace_saved_layout(self):
        with TemporaryDirectory() as directory:
            store = LayoutStore(directory)
            store.save(self.layout)
            original = store.path(self.device).read_bytes()
            for binding in (Binding("button", 4), Binding("axis", 99), Binding("axis", 1, rest=float("nan")), Binding("button", 2, -1)):
                bad = Layout(self.device, {**self.layout.bindings, "FIRE": binding})
                with self.assertRaises(ValueError):
                    store.save(bad)
                self.assertEqual(store.path(self.device).read_bytes(), original)
            with self.assertRaises(ValueError):
                store.save(Layout(self.device))

    def test_pointer_bindings_are_optional(self):
        Layout(self.device, {a: self.layout.bindings[a] for a in MOVEMENT_ACTIONS}).validate()

    def test_failed_atomic_save_keeps_previous_layout(self):
        with TemporaryDirectory() as directory:
            store = LayoutStore(directory)
            store.save(self.layout)
            original = store.path(self.device).read_bytes()
            with patch.object(Path, "replace", side_effect=OSError("disk full")):
                with self.assertRaises(OSError):
                    store.save(self.layout)
            self.assertEqual(store.path(self.device).read_bytes(), original)
            self.assertEqual(list(Path(directory).glob("*.tmp")), [])

    def test_hat_movement_is_independent_of_unmapped_stick(self):
        state = InputState(axes={0: -1.0, 1: 1.0}, hats={0: (0, 0)})
        actions = ActionState()
        self.assertEqual(actions.update(self.layout.bindings, state, 0), ([], []))
        state.hats[0] = (-1, 1)
        self.assertEqual(actions.update(self.layout.bindings, state, 10)[0], ["MOVE-FORWARD", "MOVE-LEFT"])

    def test_axis_hysteresis_repeat_and_release(self):
        bindings = {"MOVE-FORWARD": Binding("axis", 5, -1)}
        state = InputState(axes={5: -0.2})
        actions = ActionState()
        self.assertEqual(actions.update(bindings, state, 0), ([], []))
        state.axes[5] = -0.8
        self.assertEqual(actions.update(bindings, state, 10)[0], ["MOVE-FORWARD"])
        for tick, value in ((20, -0.9), (80, -0.51), (100, -0.49), (329, -0.6)):
            state.axes[5] = value
            self.assertEqual(actions.update(bindings, state, tick)[0], [])
        self.assertEqual(actions.update(bindings, state, 330)[0], ["MOVE-FORWARD"])
        self.assertEqual(actions.update(bindings, state, 449)[0], [])
        self.assertEqual(actions.update(bindings, state, 450)[0], ["MOVE-FORWARD"])
        state.axes[5] = 0
        self.assertEqual(actions.update(bindings, state, 460)[1], ["MOVE-FORWARD"])

    def test_fire_does_not_repeat_and_modal_exit_requires_release(self):
        state = InputState(buttons={0: True})
        actions = ActionState()
        self.assertEqual(actions.update(self.layout.bindings, state, 0)[0], ["FIRE"])
        self.assertEqual(actions.update(self.layout.bindings, state, 1000)[0], [])
        actions.suspend(self.layout.bindings, state)
        self.assertEqual(actions.update(self.layout.bindings, state, 2000)[0], [])
        state.buttons[0] = False
        actions.update(self.layout.bindings, state, 2100)
        state.buttons[0] = True
        self.assertEqual(actions.update(self.layout.bindings, state, 2200)[0], ["FIRE"])

    def test_trigger_rest_and_proportional_pointer_speed(self):
        binding = Binding("axis", 4, 1, rest=-1)
        binding.validate(self.device)
        self.assertEqual(binding.strength(InputState(axes={4: -1})), 0)
        self.assertEqual(binding.strength(InputState(axes={4: 0})), 0.5)
        self.assertEqual(binding.strength(InputState(axes={4: 1})), 1)
        actions = ActionState()
        self.assertEqual(actions.pointer_velocity(self.layout.bindings, InputState(axes={2: 0.2})), (0, 0))
        self.assertEqual(actions.pointer_velocity(self.layout.bindings, InputState(axes={2: 1})), (1, 0))
        x, y = actions.pointer_velocity(self.layout.bindings, InputState(axes={2: 1, 3: 1}))
        self.assertAlmostEqual(x*x + y*y, 1)


class MacDetectionTests(unittest.TestCase):
    def runtime(self, version=(2, 32, 6), count=0):
        from types import SimpleNamespace
        return SimpleNamespace(joystick=SimpleNamespace(init=Mock(), quit=Mock(), get_count=Mock(return_value=count)),
                               get_sdl_version=Mock(return_value=version))

    def test_empty_mac_list_uses_supported_hid_fallback(self):
        from tools.joypad_panel import initialise_joysticks
        pygame = self.runtime()
        with patch("sys.platform", "darwin"), patch.dict(os.environ, {}, clear=True):
            self.assertIn("HID fallback", initialise_joysticks(pygame))
            self.assertEqual(os.environ["SDL_JOYSTICK_MFI"], "0")
        pygame.joystick.quit.assert_called_once()
        self.assertEqual(pygame.joystick.init.call_count, 2)

    def test_old_sdl_explains_runtime_requirement_without_ineffective_restart(self):
        from tools.joypad_panel import initialise_joysticks
        pygame = self.runtime((2, 28, 4))
        with patch("sys.platform", "darwin"), patch.dict(os.environ, {}, clear=True):
            self.assertIn("newer SDL required", initialise_joysticks(pygame))
            self.assertNotIn("SDL_JOYSTICK_MFI", os.environ)
        pygame.joystick.quit.assert_not_called()

    def test_existing_devices_and_explicit_driver_choices_are_preserved(self):
        from tools.joypad_panel import initialise_joysticks
        for count, environment in ((1, {}), (0, {"SDL_JOYSTICK_MFI": "1"}), (0, {"SDL_JOYSTICK_MFI": "0"})):
            pygame = self.runtime(count=count)
            with self.subTest(count=count, environment=environment), patch("sys.platform", "darwin"), patch.dict(os.environ, environment, clear=True):
                initialise_joysticks(pygame)
                self.assertEqual(dict(os.environ), environment)
            pygame.joystick.quit.assert_not_called()

    def test_other_platforms_and_headless_tests_keep_their_backend(self):
        from tools.joypad_panel import initialise_joysticks
        for platform, environment in (("linux", {}), ("win32", {}), ("darwin", {"SDL_VIDEODRIVER": "dummy"})):
            pygame = self.runtime()
            with patch("sys.platform", platform), patch.dict(os.environ, environment, clear=True):
                self.assertEqual(initialise_joysticks(pygame), "")
            pygame.joystick.quit.assert_not_called()


class FakeJoystick:
    def __init__(self, instance=37, guid="test-guid"):
        self.instance = instance
        self.guid = guid
        self.axes = [0.0] * 6
        self.axes[4] = -1.0
        self.buttons = [False] * 12
        self.hats = [(0, 0)]
        self.closed = False

    def get_instance_id(self): return self.instance
    def get_guid(self): return self.guid
    def get_name(self): return "Test controller"
    def get_numaxes(self): return len(self.axes)
    def get_numbuttons(self): return len(self.buttons)
    def get_numhats(self): return len(self.hats)
    def get_axis(self, i): return self.axes[i]
    def get_button(self, i): return self.buttons[i]
    def get_hat(self, i): return self.hats[i]
    def quit(self): self.closed = True


class JoypadUITests(unittest.TestCase):
    def setUp(self):
        self.environment = patch.dict(os.environ, {"SDL_VIDEODRIVER": "dummy", "SDL_AUDIODRIVER": "dummy"})
        self.environment.start()
        import pygame
        self.pg = pygame
        pygame.init()
        self.screen = pygame.display.set_mode((1200, 760))
        self.temp = TemporaryDirectory()
        self.store = LayoutStore(self.temp.name)
        self.joystick = FakeJoystick()
        self.identity = DeviceIdentity.from_joystick(self.joystick)
        self.count = patch("pygame.joystick.get_count", return_value=1)
        self.factory = patch("pygame.joystick.Joystick", return_value=self.joystick)
        self.count.start()
        self.factory.start()

    def tearDown(self):
        self.factory.stop()
        self.count.stop()
        self.pg.quit()
        self.temp.cleanup()
        self.environment.stop()

    def controls(self, saved=True):
        from tools.joypad_panel import JoypadControls
        if saved:
            self.store.save(example_layout(self.identity))
        return JoypadControls(self.pg, store=self.store)

    def event(self, kind, **values):
        return self.pg.event.Event(kind, instance_id=37, **values)

    def feed(self, controls, *events, now=0):
        with patch("pygame.time.get_ticks", return_value=now):
            return list(controls.events(events, self.screen))

    def test_missing_layout_auto_opens_but_saved_layout_does_not(self):
        controls = self.controls(saved=False)
        self.assertTrue(controls.open)
        self.assertEqual(controls.selected, 37)
        controls.close()
        self.feed(controls)
        self.assertFalse(controls.open)  # Cancel is honoured for this connection.
        self.assertFalse(self.controls().open)

    def test_periodic_rescan_recovers_a_missed_device_added_event(self):
        with patch("pygame.joystick.get_count", return_value=0):
            controls = self.controls(saved=False)
        controls.last_scan = 0
        self.feed(controls, now=1001)
        self.assertTrue(controls.open)
        self.assertEqual(controls.selected, 37)

    def test_rescan_preserves_draft_and_reports_runtime(self):
        controls = self.controls()
        controls.show()
        controls.draft["TURN-LEFT"] = Binding("button", 8)
        controls._perform("RESCAN")
        self.assertEqual(controls.draft["TURN-LEFT"], Binding("button", 8))
        self.assertIn("SDL reports 1", controls.message)
        self.assertIn("Pygame", controls.message)

    def test_open_failure_is_not_reported_as_an_absent_device(self):
        controls = self.controls()
        with patch("pygame.joystick.Joystick", side_effect=self.pg.error("access unavailable")):
            controls.rescan()
        controls.show()
        self.assertIn("access unavailable", controls.message)
        self.assertIn("SDL device 0", controls.message)

    def test_page_captures_button_hat_axis_and_blocks_editor_events(self):
        controls = self.controls(saved=False)
        controls.draw(self.screen)
        for action, event, expected in (
            ("MOVE-FORWARD", self.event(self.pg.JOYHATMOTION, hat=0, value=(0, 1)), Binding("hat", 0, 1, 1)),
            ("TURN-LEFT", self.event(self.pg.JOYBUTTONDOWN, button=7), Binding("button", 7)),
            ("POINTER-RIGHT", self.event(self.pg.JOYAXISMOTION, axis=2, value=0.9), Binding("axis", 2, 1)),
        ):
            click = self.pg.event.Event(self.pg.MOUSEBUTTONDOWN, pos=controls.rects[action].center, button=1)
            self.assertEqual(self.feed(controls, click, event), [])
            self.assertEqual(controls.draft[action], expected)
        self.assertIsNone(self.store.load(self.identity)[0])

    def test_capture_ignores_drift_diagonals_and_held_input_until_release(self):
        capture = BindingCapture(InputState(buttons={4: True}, axes={2: 1}), {2: 0})
        self.assertIsNone(capture.feed(self.pg, self.event(self.pg.JOYBUTTONDOWN, button=4)))
        self.assertIsNone(capture.feed(self.pg, self.event(self.pg.JOYAXISMOTION, axis=2, value=0.8)))
        self.assertIsNone(capture.feed(self.pg, self.event(self.pg.JOYAXISMOTION, axis=2, value=0.0)))
        self.assertIsNone(capture.feed(self.pg, self.event(self.pg.JOYAXISMOTION, axis=2, value=0.1)))
        self.assertIsNone(capture.feed(self.pg, self.event(self.pg.JOYHATMOTION, hat=0, value=(1, 1))))
        self.assertEqual(capture.feed(self.pg, self.event(self.pg.JOYAXISMOTION, axis=2, value=-1)), Binding("axis", 2, -1))
        self.assertIsNone(capture.feed(self.pg, self.event(self.pg.JOYBUTTONUP, button=4)))
        self.assertEqual(capture.feed(self.pg, self.event(self.pg.JOYBUTTONDOWN, button=4)), Binding("button", 4))

    def test_define_all_advances_and_rejects_duplicate_assignment(self):
        controls = self.controls(saved=False)
        controls._perform("DEFINE ALL")
        self.feed(controls, self.event(self.pg.JOYBUTTONDOWN, button=0))
        self.assertEqual(controls.row, 1)
        self.feed(controls, self.event(self.pg.JOYBUTTONDOWN, button=0))
        self.assertNotIn("MOVE-BACK", controls.draft)
        self.feed(controls, self.event(self.pg.JOYBUTTONUP, button=0), self.event(self.pg.JOYBUTTONDOWN, button=0))
        self.assertIn("Already used", controls.message)
        self.assertNotIn("MOVE-BACK", controls.draft)

    def test_save_cancel_and_incomplete_definition(self):
        controls = self.controls(saved=False)
        controls._perform("SAVE")
        self.assertTrue(controls.open)
        self.assertIn("six", controls.message)
        controls.draft = example_layout(self.identity).bindings
        controls._perform("SAVE")
        self.assertFalse(controls.open)
        self.assertEqual(self.store.load(self.identity)[0].bindings, controls.draft)
        controls.show()
        controls.draft.pop("MOVE-FORWARD")
        controls._perform("CANCEL")
        controls.show()
        self.assertIn("MOVE-FORWARD", controls.draft)

    def test_instance_routing_ignores_other_device_and_uses_saved_dpad(self):
        controls = self.controls()
        other = self.pg.event.Event(self.pg.JOYHATMOTION, instance_id=0, hat=0, value=(0, 1))
        events = self.feed(controls, other, self.event(self.pg.JOYAXISMOTION, axis=0, value=-1),
                           self.event(self.pg.JOYHATMOTION, hat=0, value=(0, 1)))
        actions = [(e.joypad_action, e.instance_id) for e in events if hasattr(e, "joypad_action")]
        self.assertEqual(actions, [("MOVE-FORWARD", 37)])

    def test_fast_fire_tap_yields_one_mouse_down_and_up_at_pointer(self):
        controls = self.controls()
        controls.pointer = (111.0, 222.0)
        events = self.feed(controls, self.event(self.pg.JOYBUTTONDOWN, button=0), self.event(self.pg.JOYBUTTONUP, button=0))
        clicks = [(e.type, e.pos) for e in events if hasattr(e, "joypad_pointer")]
        self.assertEqual(clicks, [(self.pg.MOUSEBUTTONDOWN, (111, 222)), (self.pg.MOUSEBUTTONUP, (111, 222))])
        self.assertFalse(controls.fire_down)

    def test_fire_can_open_the_shared_joypad_button(self):
        controls = self.controls()
        controls.draw(self.screen)
        controls.pointer = tuple(map(float, controls.button.center))
        events = self.feed(controls, self.event(self.pg.JOYBUTTONDOWN, button=0))
        self.assertTrue(controls.open)
        self.assertFalse(any(e.type == self.pg.MOUSEBUTTONDOWN for e in events))

    def test_fire_selects_front_menu_command_through_normal_mouse_handling(self):
        import main
        from tools.joypad_panel import JoypadControls
        self.store.save(example_layout(self.identity))
        frames = [[self.event(self.pg.JOYBUTTONDOWN, button=0)]]
        with patch("tools.joypad_panel.JoypadControls", side_effect=lambda pg: JoypadControls(pg, store=self.store)), patch(
            "pygame.mouse.get_pos", return_value=(400, 150)
        ), patch("pygame.event.get", side_effect=frames):
            self.assertEqual(main.launch_gui(), "maps")

    def test_pointer_moves_proportionally_and_clamps_to_window(self):
        controls = self.controls()
        controls.last_tick = 0
        controls.pointer = (10.0, 10.0)
        events = self.feed(controls, self.event(self.pg.JOYAXISMOTION, axis=2, value=1), now=40)
        self.assertEqual(controls.pointer_position(), (30, 10))
        self.assertTrue(any(e.type == self.pg.MOUSEMOTION for e in events))
        controls.pointer = (1198.0, 759.0)
        self.feed(controls, now=80)
        self.assertEqual(controls.pointer_position(), (1199, 759))

    def test_unplug_releases_fire_and_reconnect_loads_by_identity(self):
        controls = self.controls()
        self.feed(controls, self.event(self.pg.JOYBUTTONDOWN, button=0))
        events = self.feed(controls, self.event(self.pg.JOYDEVICEREMOVED))
        self.assertTrue(any(e.type == self.pg.MOUSEBUTTONUP for e in events))
        self.assertEqual(controls.devices, {})
        self.joystick.instance = 99
        self.feed(controls, self.pg.event.Event(self.pg.JOYDEVICEADDED, device_index=2))
        self.assertIn(99, controls.devices)
        self.assertFalse(controls.open)

    def test_unknown_hotplug_opens_page_even_when_no_pad_at_launch(self):
        with patch("pygame.joystick.get_count", return_value=0):
            controls = self.controls(saved=False)
        self.assertFalse(controls.open)
        self.feed(controls, self.pg.event.Event(self.pg.JOYDEVICEADDED, device_index=0))
        self.assertTrue(controls.open)

    def test_modal_and_focus_changes_release_fire_without_retrigger(self):
        controls = self.controls()
        self.feed(controls, self.event(self.pg.JOYBUTTONDOWN, button=0))
        events = self.feed(controls, self.pg.event.Event(self.pg.KEYDOWN, key=self.pg.K_F8))
        self.assertTrue(controls.open)
        self.assertTrue(any(e.type == self.pg.MOUSEBUTTONUP for e in events))
        controls.close()
        self.assertFalse(any(e.type == self.pg.MOUSEBUTTONDOWN for e in self.feed(controls)))
        self.feed(controls, self.event(self.pg.JOYBUTTONUP, button=0), self.event(self.pg.JOYBUTTONDOWN, button=0))
        events = self.feed(controls, self.pg.event.Event(self.pg.WINDOWFOCUSLOST))
        self.assertTrue(any(e.type == self.pg.MOUSEBUTTONUP for e in events))
        self.assertFalse(controls.fire_down)

    def test_saved_definition_requires_fire_release_before_editor_click(self):
        controls = self.controls()
        controls.show()
        self.feed(controls, self.event(self.pg.JOYBUTTONDOWN, button=0))
        controls._perform("SAVE")
        self.assertFalse(any(e.type == self.pg.MOUSEBUTTONDOWN for e in self.feed(controls)))

    def test_keyboard_and_joypad_navigate_every_map_mode_without_editing_resources(self):
        from tools.edit_session import EditSession
        from tools.map_editor import app
        from tools.joypad_panel import JoypadControls
        session = EditSession()
        self.store.save(example_layout(self.identity))
        original_move = app.move_in_view_direction
        for tab in range(5):
            with self.subTest(tab=tab):
                frames = [
                    [self.pg.event.Event(self.pg.KEYDOWN, key=self.pg.K_s, mod=0),
                     self.event(self.pg.JOYHATMOTION, hat=0, value=(1, 0)),
                     self.pg.event.Event(self.pg.KEYDOWN, key=self.pg.K_q, mod=0),
                     self.pg.event.Event(self.pg.KEYDOWN, key=self.pg.K_w, mod=0)],
                    [self.event(self.pg.JOYHATMOTION, hat=0, value=(0, 0))],
                    [self.pg.event.Event(self.pg.QUIT)],
                ]
                with patch("pygame.event.get", side_effect=frames), patch(
                    "tools.joypad_panel.JoypadControls", side_effect=lambda pg: JoypadControls(pg, store=self.store)
                ), patch.object(app, "move_in_view_direction", wraps=original_move) as move:
                    app.launch_map_editor(session=session, initial_tab=tab)
                self.assertEqual(move.call_count, 3)
                self.assertEqual(move.call_args_list[0].kwargs, {"lateral": 0, "forward": -1})
                self.assertEqual(move.call_args_list[1].kwargs, {"lateral": 1, "forward": 0})
                self.assertEqual(move.call_args_list[2].args[2], 3)  # Q turns west in every tab.
                self.assertEqual(move.call_args_list[2].kwargs, {"lateral": 0, "forward": 1})
                self.assertFalse(session.has_changes)

    def test_page_renders_at_front_menu_and_viewer_sizes(self):
        controls = self.controls(saved=False)
        for size in ((620, 450), (1200, 760)):
            screen = self.pg.Surface(size)
            controls.draw(screen)
            for rectangle in controls.rects.values():
                self.assertTrue(screen.get_rect().contains(rectangle))


if __name__ == "__main__":
    unittest.main()

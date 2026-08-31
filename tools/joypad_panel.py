"""Shared joypad definition page and Pygame event adapter."""
from __future__ import annotations

from dataclasses import dataclass, field
import os
import sys

from tools.joypad import (
    ACTIONS, ACTION_LABELS, MOVEMENT_ACTIONS, ActionState, BindingCapture,
    DeviceIdentity, InputState, Layout, LayoutStore,
)


def initialise_joysticks(pygame):
    """Use SDL's supported HID fallback for an empty macOS controller list.

    SDL 2.28 can skip an IOKit gamepad because GCController claims support,
    even when GCController never enumerates it. The MFI hint is not honoured
    by that older backend. SDL 2.32.6 is the verified fallback baseline.
    Never reset a live controller or override an explicit user driver choice.
    """
    pygame.joystick.init()
    if (sys.platform != "darwin" or pygame.joystick.get_count()
            or os.environ.get("SDL_VIDEODRIVER") == "dummy"):
        return ""
    if pygame.get_sdl_version() < (2, 32, 6):
        return "For the Mac HID fallback, launch with .venv/bin/python main.py (newer SDL required)."
    if "SDL_JOYSTICK_MFI" in os.environ:
        return ""
    pygame.joystick.quit()
    os.environ["SDL_JOYSTICK_MFI"] = "0"
    pygame.joystick.init()
    return "Using macOS HID fallback."


@dataclass
class ConnectedPad:
    joystick: object
    identity: DeviceIdentity
    state: InputState
    layout: Layout | None
    error: str | None
    actions: ActionState = field(default_factory=ActionState)
    rests: dict = field(default_factory=dict)
    prompted: bool = False


class JoypadControls:
    """One adapter per Pygame window; layouts survive window/device lifetimes.

    ``events`` yields normal mouse events and named movement events carrying
    ``joypad_action`` and ``instance_id``. It never posts into another app's
    event queue or changes the saved game. Call ``draw`` before display.flip.
    """
    def __init__(self, pygame, *, store=None):
        self.pygame = pygame
        self.store = store or LayoutStore()
        self.action_event = pygame.event.custom_type()
        self.devices = {}
        self.open = False
        self.selected = None
        self.draft = {}
        self.row = 0
        self.capture = None
        self.sequence = False
        self.message = "Connect a joypad to define its controls."
        self.rects = {}
        self.button = None
        self.fire_down = False
        self.focused = True
        self.last_tick = pygame.time.get_ticks()
        self.pointer = tuple(map(float, pygame.mouse.get_pos()))
        self.pending_release = False
        self.detection_errors = []
        self.backend_note = initialise_joysticks(pygame)
        self.last_scan = self.last_tick
        self.rescan()
        self._prompt_missing()

    def detection_status(self):
        runtime = f"Pygame {self.pygame.version.ver} / SDL {'.'.join(map(str, self.pygame.get_sdl_version()))}"
        detail = "; ".join(self.detection_errors) or self.backend_note
        return f"SDL reports {len(self.devices)} usable joypad(s). {runtime}. {detail}".strip()

    def rescan(self):
        """Reconcile SDL's list without resetting layouts or an in-progress draft."""
        self.pygame.event.pump()
        self.detection_errors = []
        seen = set()
        for index in range(self.pygame.joystick.get_count()):
            instance = self._add(index)
            if instance is not None:
                seen.add(instance)
        for instance in set(self.devices) - seen:
            self.devices.pop(instance).joystick.quit()
        self.last_scan = self.pygame.time.get_ticks()
        if self.open and self.selected not in self.devices:
            self.show()

    def _add(self, index):
        pygame = self.pygame
        try:
            joystick = pygame.joystick.Joystick(index)
            instance = joystick.get_instance_id()
            if instance in self.devices:
                return instance
            identity = DeviceIdentity.from_joystick(joystick)
            state = InputState.from_joystick(joystick)
            layout, error = self.store.load(identity)
            pad = ConnectedPad(joystick, identity, state, layout, error)
            # Centred sticks rest near zero; unipolar triggers may rest at -1/+1.
            pad.rests = {i: 0.0 if abs(value) < 0.25 else value for i, value in state.axes.items()}
            if layout:
                for binding in layout.bindings.values():
                    if binding.kind == "axis":
                        pad.rests[binding.index] = binding.rest
                pad.actions.suspend(layout.bindings, state)
            self.devices[instance] = pad
            return instance
        except pygame.error as error:
            self.detection_errors.append(f"Cannot open SDL device {index}: {error}")
            self.message = self.detection_status()
            return None

    def _suspend(self):
        if self.fire_down:
            self.pending_release = True
        self.fire_down = False
        for pad in self.devices.values():
            pad.actions.suspend(pad.layout.bindings if pad.layout else {}, pad.state)

    def _prompt_missing(self):
        if self.open:
            return
        for instance, pad in self.devices.items():
            if pad.layout is None and not pad.prompted:
                self.show(instance)
                break

    def show(self, instance=None):
        self._suspend()
        self.open = True
        self.selected = instance if instance in self.devices else next(iter(self.devices), None)
        pad = self.devices.get(self.selected)
        self.draft = dict(pad.layout.bindings) if pad and pad.layout else {}
        self.capture = None
        self.sequence = False
        self.row = 0
        if pad:
            pad.prompted = True
        self.message = (pad.error or "Saved layout loaded. Select a control to redefine it.") if pad else self.detection_status()

    def close(self):
        self.open = False
        self.capture = None
        self._suspend()

    def _begin(self):
        pad = self.devices.get(self.selected)
        if pad:
            self.capture = BindingCapture(pad.state, pad.rests)
            self.message = "Release held controls, then press or move: " + ACTION_LABELS[ACTIONS[self.row]]

    def _perform(self, action):
        pad = self.devices.get(self.selected)
        if action == "CANCEL":
            self.close()
        elif action == "RESCAN":
            self.rescan()
            self.message = self.detection_status()
        elif action in ("PREVIOUS", "NEXT") and self.devices:
            devices = list(self.devices)
            index = devices.index(self.selected) if self.selected in devices else 0
            self.show(devices[(index + (-1 if action == "PREVIOUS" else 1)) % len(devices)])
        elif action == "DEFINE ALL" and pad:
            self.row = 0
            self.sequence = True
            self._begin()
        elif action == "CLEAR" and pad:
            self.draft.pop(ACTIONS[self.row], None)
            self.capture = None
            self.sequence = False
            self.message = "Control cleared. Select a row to define it."
        elif action == "SKIP" and pad:
            self.row = (self.row + 1) % len(ACTIONS)
            self._begin()
        elif action == "SAVE" and pad:
            layout = Layout(pad.identity, dict(self.draft))
            try:
                self.store.save(layout)
            except (OSError, ValueError) as error:
                self.message = str(error)
                return
            for other in self.devices.values():
                if other.identity.key == pad.identity.key:
                    other.layout = Layout(other.identity, dict(self.draft))
                    other.error = None
            self.close()

    def _handle_page(self, event):
        pygame = self.pygame
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                if self.capture:
                    self.capture = None
                    self.sequence = False
                    self.message = "Definition cancelled. Saved layout is unchanged until SAVE."
                else:
                    self.close()
            elif event.key in (pygame.K_UP, pygame.K_DOWN):
                self.row = (self.row + (-1 if event.key == pygame.K_UP else 1)) % len(ACTIONS)
                self.capture = None
            elif event.key == pygame.K_RETURN:
                self._begin()
            elif event.key in (pygame.K_DELETE, pygame.K_BACKSPACE):
                self._perform("CLEAR")
        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            for action, rectangle in self.rects.items():
                if rectangle.collidepoint(event.pos):
                    if action in ACTIONS:
                        self.row = ACTIONS.index(action)
                        self.sequence = False
                        self._begin()
                    else:
                        self._perform(action)
                    break
        elif self.capture and getattr(event, "instance_id", None) == self.selected:
            binding = self.capture.feed(pygame, event)
            if binding:
                action = ACTIONS[self.row]
                conflict = next((other for other, value in self.draft.items()
                                 if other != action and value.control == binding.control), None)
                if conflict:
                    self.message = f"Already used for {ACTION_LABELS[conflict]}. Clear that row first, or choose another input."
                    return
                self.draft[action] = binding
                self.capture = None
                self.message = f"{ACTION_LABELS[action]}: {binding.label()}. SAVE keeps this layout."
                if self.sequence and self.row + 1 < len(ACTIONS):
                    self.row += 1
                    self._begin()
                else:
                    self.sequence = False

    def _outputs(self, now):
        pygame = self.pygame
        result = []
        if self.open or not self.focused:
            self._suspend()
            return result
        for instance, pad in self.devices.items():
            if pad.layout is None:
                continue
            pressed, _ = pad.actions.update(pad.layout.bindings, pad.state, now)
            result.extend(pygame.event.Event(self.action_event, joypad_action=action, instance_id=instance)
                          for action in pressed if action in MOVEMENT_ACTIONS)
        fire = any("FIRE" in pad.actions.active for pad in self.devices.values())
        if fire != self.fire_down:
            self.fire_down = fire
            if fire and self.button and self.button.collidepoint(self.pointer_position()):
                self.show()
                return []
            result.append(pygame.event.Event(pygame.MOUSEBUTTONDOWN if fire else pygame.MOUSEBUTTONUP,
                                            button=1, pos=self.pointer_position(), joypad_pointer=True))
        return result

    def pointer_position(self):
        return tuple(round(value) for value in self.pointer)

    def left_pressed(self):
        return self.fire_down or self.pygame.mouse.get_pressed(3)[0]

    def events(self, events, screen):
        """Transform one frame lazily, preserving down/up and modal event order."""
        pygame = self.pygame
        now = pygame.time.get_ticks()
        elapsed = max(0, min(0.05, (now - self.last_tick) / 1000))
        self.last_tick = now
        if now - self.last_scan >= 1000:
            self.rescan()
        self._prompt_missing()
        for event in events:
            if event.type == pygame.QUIT:
                yield event
                continue
            if event.type == pygame.JOYDEVICEADDED:
                self._add(event.device_index)
                if self.open and self.selected is None:
                    self.show()
                self._prompt_missing()
                continue
            if event.type == pygame.JOYDEVICEREMOVED:
                pad = self.devices.pop(event.instance_id, None)
                if pad:
                    pad.joystick.quit()
                if self.open and self.selected == event.instance_id:
                    self.show()
                yield from self._outputs(now)
                continue
            if event.type == pygame.WINDOWFOCUSLOST:
                self.focused = False
                self._suspend()
            elif event.type == pygame.WINDOWFOCUSGAINED:
                self.focused = True
                # SDL may omit release events while unfocused; resample before gating.
                for pad in self.devices.values():
                    pad.state = InputState.from_joystick(pad.joystick)
                self._suspend()
            if event.type == pygame.MOUSEMOTION:
                self.pointer = tuple(map(float, event.pos))
            elif event.type in (pygame.MOUSEBUTTONDOWN, pygame.MOUSEBUTTONUP):
                self.pointer = tuple(map(float, event.pos))
            pad = self.devices.get(getattr(event, "instance_id", None))
            if pad:
                pad.state.update(pygame, event)
            if event.type == pygame.KEYDOWN and event.key == pygame.K_F8:
                if self.open:
                    self.close()
                else:
                    self.show()
                continue
            if not self.open and event.type == pygame.MOUSEBUTTONDOWN and event.button == 1 and self.button and self.button.collidepoint(event.pos):
                self.show()
                continue
            if self.open:
                self._handle_page(event)
                continue
            yield event
            yield from self._outputs(now)
        yield from self._outputs(now)
        if self.pending_release:
            self.pending_release = False
            yield pygame.event.Event(pygame.MOUSEBUTTONUP, button=1, pos=self.pointer_position(), joypad_pointer=True)
        if not self.open and self.focused:
            vx = vy = 0.0
            for pad in self.devices.values():
                if pad.layout:
                    dx, dy = pad.actions.pointer_velocity(pad.layout.bindings, pad.state)
                    vx += dx
                    vy += dy
            if vx or vy:
                old = self.pointer_position()
                self.pointer = (max(0.0, min(screen.get_width() - 1, self.pointer[0] + max(-1, min(1, vx)) * 500 * elapsed)),
                                max(0.0, min(screen.get_height() - 1, self.pointer[1] + max(-1, min(1, vy)) * 500 * elapsed)))
                pos = self.pointer_position()
                if pos != old:
                    pygame.mouse.set_pos(pos)
                yield pygame.event.Event(pygame.MOUSEMOTION, pos=pos, rel=(pos[0]-old[0], pos[1]-old[1]),
                                         buttons=(self.left_pressed(), False, False), joypad_pointer=True)

    def draw(self, screen, *, button_rect=None):
        pygame = self.pygame
        from tools.session_panel import SessionPanel
        width, height = screen.get_size()
        self.button = pygame.Rect(button_rect or (width - 292, 12, 96, 28))
        small = pygame.font.SysFont(None, 18)
        pygame.draw.rect(screen, (52, 88, 122), self.button, border_radius=4)
        label = "Define Joypad Buttons" if self.button.width > 180 else "JOYPAD (F8)"
        text = small.render(label, True, (245, 245, 250))
        screen.blit(text, text.get_rect(center=self.button.center))
        if not self.open:
            return
        shade = pygame.Surface((width, height), pygame.SRCALPHA)
        shade.fill((0, 0, 0, 190))
        screen.blit(shade, (0, 0))
        box = pygame.Rect(0, 0, min(940, width - 24), min(600, height - 24))
        box.center = screen.get_rect().center
        pygame.draw.rect(screen, (32, 37, 47), box, border_radius=8)
        font = pygame.font.SysFont(None, 22)
        title = pygame.font.SysFont(None, 28)
        x, y, inner = box.x + 14, box.y + 12, box.width - 28
        screen.blit(title.render("Define joypad buttons", True, (234, 220, 134)), (x, y))
        self.rects = {}

        def button(action, rectangle, label=None, enabled=True):
            self.rects[action] = rectangle
            pygame.draw.rect(screen, (53, 83, 113) if enabled else (49, 52, 60), rectangle, border_radius=4)
            text = small.render(label or action, True, (235, 240, 246) if enabled else (130, 135, 145))
            screen.blit(text, text.get_rect(center=rectangle.center))

        pad = self.devices.get(self.selected)
        device_label = pad.identity.name if pad else "No joypads reported by SDL"
        if pad:
            device_label = f"{list(self.devices).index(self.selected) + 1}/{len(self.devices)}: {device_label}"
        screen.blit(font.render(SessionPanel._fit_path(font, device_label, inner - 172), True, (220, 230, 240)), (x, y + 32))
        button("RESCAN", pygame.Rect(box.right - 174, y + 29, 76, 25))
        button("PREVIOUS", pygame.Rect(box.right - 90, y + 29, 32, 25), "<")
        button("NEXT", pygame.Rect(box.right - 50, y + 29, 32, 25), ">")
        screen.blit(small.render("Select a row, then press a button / D-pad / stick. Release controls first.", True, (170, 185, 205)), (x, y + 61))
        row_height = (box.height - 182) // 6
        column_width = (inner - 12) // 2
        for index, action in enumerate(ACTIONS):
            column, row = (0, index) if index < 6 else (1, index - 6)
            rectangle = pygame.Rect(x + column * (column_width + 12), y + 83 + row * row_height, column_width, row_height - 4)
            self.rects[action] = rectangle
            selected = self.row == index
            pygame.draw.rect(screen, (67, 95, 125) if selected else (42, 49, 62), rectangle, border_radius=4)
            binding = self.draft.get(action)
            label = ACTION_LABELS[action] + (" *" if action in MOVEMENT_ACTIONS else "")
            value = "Waiting for input..." if selected and self.capture else binding.label() if binding else "Not assigned"
            screen.blit(small.render(label, True, (232, 236, 242)), (rectangle.x + 8, rectangle.y + 3))
            screen.blit(small.render(value, True, (234, 220, 134) if selected else (164, 182, 199)), (rectangle.x + 8, rectangle.y + rectangle.height - 17))
        footer_y = box.bottom - 91
        for index, line in enumerate(SessionPanel._wrapped(small, self.message, inner)[:2]):
            screen.blit(small.render(line, True, (241, 195, 120)), (x, footer_y + index * 17))
        button_width = (inner - 24) // 5
        for index, action in enumerate(("DEFINE ALL", "CLEAR", "SKIP", "SAVE", "CANCEL")):
            button(action, pygame.Rect(x + index * (button_width + 6), box.bottom - 51, button_width, 27), enabled=bool(pad) or action == "CANCEL")
        screen.blit(small.render("* Six movement controls required. Pointer / fire optional. ESC cancels; F8 reopens.", True, (156, 173, 191)), (x, box.bottom - 20))

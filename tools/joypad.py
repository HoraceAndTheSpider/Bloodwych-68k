"""Device-specific joypad layouts and input state, independent of any viewer.

No SDL axis or button number has an assumed game meaning. Consumers receive
named actions with a device instance ID, also suitable for a future play test.
"""
from __future__ import annotations

from dataclasses import asdict, dataclass, field
import hashlib
import json
import math
from pathlib import Path
import sys
import tempfile


MOVEMENT_ACTIONS = (
    "MOVE-FORWARD", "MOVE-BACK", "MOVE-LEFT", "MOVE-RIGHT", "TURN-LEFT", "TURN-RIGHT",
)
POINTER_ACTIONS = ("POINTER-UP", "POINTER-DOWN", "POINTER-LEFT", "POINTER-RIGHT", "FIRE")
ACTIONS = MOVEMENT_ACTIONS + POINTER_ACTIONS
ACTION_LABELS = dict(zip(ACTIONS, (
    "Move forward", "Move backward", "Strafe left", "Strafe right", "Turn left", "Turn right",
    "Pointer up", "Pointer down", "Pointer left", "Pointer right", "Fire / left click",
)))
LAYOUT_DIR = Path(__file__).resolve().parents[1] / "config" / "joypads"


def movement_action_for_event(pygame, event):
    """Return the shared movement action represented by one Pygame event."""
    action = getattr(event, "joypad_action", None)
    if action in MOVEMENT_ACTIONS:
        return action
    if event.type != pygame.KEYDOWN:
        return None
    if getattr(event, "mod", 0) & (
        pygame.KMOD_CTRL | pygame.KMOD_ALT | pygame.KMOD_META
    ):
        return None
    return {
        pygame.K_w: "MOVE-FORWARD",
        pygame.K_s: "MOVE-BACK",
        pygame.K_a: "MOVE-LEFT",
        pygame.K_d: "MOVE-RIGHT",
        pygame.K_q: "TURN-LEFT",
        pygame.K_e: "TURN-RIGHT",
    }.get(event.key)


@dataclass(frozen=True)
class DeviceIdentity:
    guid: str
    name: str
    axes: int
    buttons: int
    hats: int
    platform: str = sys.platform

    @classmethod
    def from_joystick(cls, joystick):
        return cls(joystick.get_guid(), joystick.get_name(), joystick.get_numaxes(),
                   joystick.get_numbuttons(), joystick.get_numhats())

    @property
    def key(self):
        # Names are diagnostic; SDL GUID, platform and capabilities identify a layout.
        identity = asdict(self)
        identity.pop("name")
        return hashlib.sha256(json.dumps(identity, sort_keys=True).encode()).hexdigest()[:24]


@dataclass(frozen=True)
class Binding:
    kind: str
    index: int
    direction: int = 1
    component: int = 0
    rest: float = 0.0

    def validate(self, device):
        count = {"axis": device.axes, "button": device.buttons, "hat": device.hats}.get(self.kind, 0)
        if type(self.index) is not int or not 0 <= self.index < count:
            raise ValueError("Binding references an unavailable control")
        if self.direction not in (-1, 1) or self.component not in (0, 1):
            raise ValueError("Invalid control direction")
        if not isinstance(self.rest, (int, float)) or not math.isfinite(self.rest) or not -1 <= self.rest <= 1:
            raise ValueError("Invalid resting axis value")
        if self.kind == "axis" and 1 - self.rest * self.direction < 0.25:
            raise ValueError("Axis has no usable travel in this direction")
        if self.kind != "hat" and self.component != 0:
            raise ValueError("Only a hat has a component")
        if self.kind != "axis" and self.rest != 0:
            raise ValueError("Only an axis has a resting value")
        if self.kind == "button" and self.direction != 1:
            raise ValueError("Invalid button direction")

    @property
    def control(self):
        return self.kind, self.index, self.component, self.direction

    def strength(self, state):
        if self.kind == "button":
            return float(state.buttons.get(self.index, False))
        if self.kind == "hat":
            return float(state.hats.get(self.index, (0, 0))[self.component] == self.direction)
        value = state.axes.get(self.index, self.rest)
        return max(0.0, min(1.0, (value - self.rest) * self.direction / (1 - self.rest * self.direction)))

    def label(self):
        if self.kind == "button":
            return f"Button {self.index + 1}"
        if self.kind == "hat":
            direction = ("left" if self.direction < 0 else "right") if self.component == 0 else ("down" if self.direction < 0 else "up")
            return f"D-pad {self.index + 1} {direction}"
        return f"Axis {self.index + 1} {'negative' if self.direction < 0 else 'positive'}"


@dataclass
class Layout:
    device: DeviceIdentity
    bindings: dict[str, Binding] = field(default_factory=dict)

    def validate(self):
        if any(action not in self.bindings for action in MOVEMENT_ACTIONS):
            raise ValueError("Define all six movement controls before saving")
        controls = set()
        for action, binding in self.bindings.items():
            if action not in ACTIONS:
                raise ValueError("Unknown joypad action")
            binding.validate(self.device)
            if binding.control in controls:
                raise ValueError("One control cannot perform two actions")
            controls.add(binding.control)


class LayoutStore:
    def __init__(self, directory=LAYOUT_DIR):
        self.directory = Path(directory)

    def path(self, device):
        return self.directory / f"{device.key}.json"

    def load(self, device):
        try:
            data = json.loads(self.path(device).read_text())
            if data["version"] != 1 or DeviceIdentity(**data["device"]).key != device.key:
                raise ValueError("Layout belongs to a different device or version")
            layout = Layout(device, {action: Binding(**value) for action, value in data["bindings"].items()})
            layout.validate()
            return layout, None
        except FileNotFoundError:
            return None, "No saved layout for this device."
        except (OSError, ValueError, TypeError, KeyError, AttributeError) as error:
            return None, f"Cannot use saved layout: {error}"

    def save(self, layout):
        layout.validate()
        data = {"version": 1, "device": asdict(layout.device),
                "bindings": {action: asdict(binding) for action, binding in layout.bindings.items()}}
        self.directory.mkdir(parents=True, exist_ok=True)
        temporary = None
        try:
            with tempfile.NamedTemporaryFile(mode="w", dir=self.directory, suffix=".tmp", delete=False) as stream:
                temporary = Path(stream.name)
                json.dump(data, stream, indent=2)
                stream.write("\n")
            temporary.replace(self.path(layout.device))
        finally:
            if temporary is not None:
                temporary.unlink(missing_ok=True)


@dataclass
class InputState:
    axes: dict = field(default_factory=dict)
    buttons: dict = field(default_factory=dict)
    hats: dict = field(default_factory=dict)

    @classmethod
    def from_joystick(cls, joystick):
        return cls({i: joystick.get_axis(i) for i in range(joystick.get_numaxes())},
                   {i: bool(joystick.get_button(i)) for i in range(joystick.get_numbuttons())},
                   {i: joystick.get_hat(i) for i in range(joystick.get_numhats())})

    def update(self, pygame, event):
        if event.type == pygame.JOYAXISMOTION:
            self.axes[event.axis] = event.value
        elif event.type == pygame.JOYHATMOTION:
            self.hats[event.hat] = event.value
        elif event.type in (pygame.JOYBUTTONDOWN, pygame.JOYBUTTONUP):
            self.buttons[event.button] = event.type == pygame.JOYBUTTONDOWN


class ActionState:
    """Edges, hysteresis, held repeats and release gating after modal/focus changes."""
    def __init__(self):
        self.active = set()
        self.blocked = set()
        self.repeat_at = {}

    def suspend(self, bindings, state):
        self.active.clear()
        self.repeat_at.clear()
        self.blocked = {action for action, binding in bindings.items() if binding.strength(state) > 0.25}

    def update(self, bindings, state, now):
        pressed, released = [], []
        for action, binding in bindings.items():
            strength = binding.strength(state)
            if action in self.blocked:
                if strength <= 0.25:
                    self.blocked.remove(action)
                continue
            if action in self.active and strength <= 0.25:
                self.active.remove(action)
                self.repeat_at.pop(action, None)
                released.append(action)
            elif action not in self.active and strength >= 0.55:
                self.active.add(action)
                self.repeat_at[action] = now + 320
                pressed.append(action)
            elif action in self.active and action in MOVEMENT_ACTIONS and now >= self.repeat_at[action]:
                self.repeat_at[action] = now + 120
                pressed.append(action)
        return pressed, released

    def pointer_velocity(self, bindings, state):
        def value(action):
            if action in self.blocked or action not in bindings:
                return 0.0
            return max(0.0, (bindings[action].strength(state) - 0.25) / 0.75)
        x = value("POINTER-RIGHT") - value("POINTER-LEFT")
        y = value("POINTER-DOWN") - value("POINTER-UP")
        length = max(1.0, math.hypot(x, y))
        return x / length, y / length


class BindingCapture:
    """Wait for existing input to release before accepting a fresh movement."""
    def __init__(self, state, rests):
        self.rests = dict(rests)
        self.blocked = set()
        for i, value in state.axes.items():
            if abs(value - self.rests.get(i, 0)) > 0.25:
                self.blocked.add(("axis", i))
        self.blocked.update(("button", i) for i, value in state.buttons.items() if value)
        self.blocked.update(("hat", i) for i, value in state.hats.items() if value != (0, 0))

    def feed(self, pygame, event):
        binding = None
        if event.type in (pygame.JOYBUTTONDOWN, pygame.JOYBUTTONUP):
            key = ("button", event.button)
            neutral = event.type == pygame.JOYBUTTONUP
            if not neutral:
                binding = Binding("button", event.button)
        elif event.type == pygame.JOYHATMOTION:
            key = ("hat", event.hat)
            neutral = event.value == (0, 0)
            # A diagonal is ambiguous when defining one direction; ask for a cardinal.
            if sum(value != 0 for value in event.value) == 1:
                component = 0 if event.value[0] else 1
                binding = Binding("hat", event.hat, event.value[component], component)
        elif event.type == pygame.JOYAXISMOTION:
            key = ("axis", event.axis)
            rest = self.rests.get(event.axis, 0.0)
            delta = event.value - rest
            neutral = abs(delta) <= 0.25
            if abs(delta) >= 0.55:
                direction = 1 if delta > 0 else -1
                binding = Binding("axis", event.axis, direction, rest=rest)
        else:
            return None
        if key in self.blocked:
            if neutral:
                self.blocked.remove(key)
            return None
        return binding

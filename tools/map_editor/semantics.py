"""Type-aware map-cell controls derived from the AMOS ``_DESC`` routines."""

from __future__ import annotations

from dataclasses import dataclass

from tools.map_editor.model import MapCell
from tools.map_editor.render import DIRECTION_NAMES, MAP_TYPE_NAMES


@dataclass(frozen=True)
class CellControl:
    action: str
    label: str


WOOD_STATES = ("NONE", "WALL", "OPEN", "CLOSED")
SIGN_KINDS = ("GENERATED", "SERPENT", "DRAGON", "MOON", "CHAOS")
SOCKET_KINDS = ("SERPENT", "CHAOS", "DRAGON", "MOON", "GREY", "BLUISH", "BROWN", "TAN")
LOCK_KINDS = ("UNLOCKED", "MAGE", "BRONZE", "IRON", "SERPENT", "CHAOS", "DRAGON", "MOON", "CHROMATIC", "VOID")
SWITCH_ACTIONS = {
    0x00: "NO EFFECT",
    0x02: "REMOVE",
    0x04: "TOGGLE WALL",
    0x06: "OPEN METAL DOOR",
    0x08: "ROTATE WALL",
    0x0A: "TOGGLE PILLAR",
    0x0C: "PLACE PILLAR",
    0x0E: "ROTATE WOODEN WALL",
}
TRIGGER_ACTIONS = {
    0x00: "NO EVENT", 0x02: "SPINNER 1", 0x04: "SPINNER 2",
    0x06: "OPEN METAL DOOR", 0x08: "VIVIFY (EXTERNAL)",
    0x0A: "VIVIFY (INTERNAL)", 0x0C: "WOOD DOOR TRAP (RIGHT)",
    0x0E: "WOOD DOOR TRAP (LEFT)", 0x10: "TRADER DOOR",
    0x12: "TOWER ENTRANCE (2 PLAYER)", 0x14: "TOWER ENTRANCE (MAIN)",
    0x16: "REMOVE", 0x18: "CLOSE METAL DOOR", 0x1A: "TOGGLE PILLAR",
    0x1C: "CREATE PAD", 0x1E: "CREATE WALL", 0x20: "MULTIPAD REMOVE",
    0x22: "MOVE PILLAR", 0x24: "CREATE PILLAR", 0x26: "KEEP ENTRANCE (2 PLAYER)",
    0x28: "KEEP ENTRANCE (MAIN)", 0x2A: "FLASH TELEPORT", 0x2C: "ROTATE WALL",
    0x2E: "TOGGLE WALL", 0x30: "SPINNER 3", 0x32: "CLICK TELEPORT",
    0x34: "CHANGE MAP DATA (+2/8)", 0x36: "ROTATE WOOD WALL",
    0x38: "CHANGE MAP DATA (+1/4)", 0x3A: "GAME COMPLETION",
    0x3C: "SPECIAL: REMOVE PILLAR", 0x3E: "BEXT: SUMMON PAD",
    0x40: "BEXT: SPECIAL UNKNOWN",
}
TRIGGER_XY_ACTIONS = frozenset({
    0x06, 0x16, 0x18, 0x1A, 0x1C, 0x1E, 0x20, 0x24, 0x26,
    0x2A, 0x2C, 0x2E, 0x32, 0x34, 0x36, 0x38, 0x3C,
})
TRIGGER_FLOOR_ACTIONS = frozenset({0x2A, 0x32})


def _replace_first(cell: MapCell, value: int) -> MapCell:
    return MapCell(value & 0xFF, cell.second)


def _replace_c(cell: MapCell, value: int) -> MapCell:
    return cell.replace_nibble("c", value)


def _replace_b(cell: MapCell, value: int) -> MapCell:
    return cell.replace_nibble("b", value)


def default_cell(map_type: int) -> MapCell:
    """Return a valid, visible default for an AMOS map type."""

    defaults = (
        MapCell(0x00, 0x00),
        MapCell(0x00, 0x01),  # plain stone wall; C<8 means no feature face
        MapCell(0x55, 0x02),  # four wooden walls
        MapCell(0x01, 0x03),  # pillar
        MapCell(0x00, 0x04),  # north/up stairs
        MapCell(0x00, 0x05),  # open regular metal door
        MapCell(0x02, 0x06),  # green trigger pad
        MapCell(0x00, 0x07),  # magic space
    )
    return defaults[map_type & 7]


def controls_for_cell(cell: MapCell) -> tuple[CellControl, ...]:
    """Describe editor controls in human terms instead of raw A/B/C/D nibbles."""

    controls = [
        CellControl("TYPE-", f"TYPE -"),
        CellControl("TYPE+", f"TYPE +"),
    ]
    map_type = cell.map_type
    if map_type == 0:
        controls.append(CellControl("SPACE", "CLEAR SPACE"))
    elif map_type == 1:
        face = "PLAIN" if cell.c < 8 else DIRECTION_NAMES[cell.c & 3]
        feature = ("SHELF", "SIGN", "SWITCH", "SOCKET")[cell.b & 3]
        controls.extend((
            CellControl("FACE-", f"FACE -  {face}"),
            CellControl("FACE+", f"FACE +  {face}"),
            CellControl("FEATURE-", f"FEATURE -  {feature}"),
            CellControl("FEATURE+", f"FEATURE +  {feature}"),
        ))
        if cell.b & 3 == 0:
            state = "ON" if cell.d & 8 else "OFF"
            controls.append(CellControl("CONCEAL", f"CONCEAL {state}"))
        elif cell.b & 3 == 1:
            known = {0x01: 0, 0x05: 1, 0x09: 2, 0x0D: 3, 0x11: 4}
            label = SIGN_KINDS[known[cell.first]] if cell.first in known else f"SCROLL {max(0, cell.first // 4 - 4):02d}"
            controls.extend((CellControl("VARIANT-", f"SIGN -  {label}"), CellControl("VARIANT+", f"SIGN +  {label}")))
        elif cell.b & 3 == 2:
            state = "LIT" if cell.b in (2, 10) else "DIM"
            controls.extend((CellControl("REFERENCE-", f"REF -  {cell.first // 8}"), CellControl("REFERENCE+", f"REF +  {cell.first // 8}"), CellControl("STATE", state)))
        else:
            family = SOCKET_KINDS[min(cell.first // 8, 7)] if cell.first < 0x40 else "INVALID"
            state = "FULL" if cell.b in (3, 11) else "EMPTY"
            controls.extend((CellControl("VARIANT-", f"GEM -  {family}"), CellControl("VARIANT+", f"GEM +  {family}"), CellControl("STATE", state)))
    elif map_type == 2:
        for side, shift in zip("NESW", (0, 2, 4, 6)):
            state = WOOD_STATES[(cell.first >> shift) & 3]
            controls.append(CellControl(f"WOOD-{side}", f"{side}: {state}"))
        controls.append(CellControl("LOCK", "LOCKED" if cell.c & 1 else "NO LOCK"))
    elif map_type == 3:
        kind = "BED" if cell.first == 0 else "PILLAR"
        controls.extend((CellControl("MISC-", f"KIND -  {kind}"), CellControl("MISC+", f"KIND +  {kind}")))
    elif map_type == 4:
        elevation = "UP" if cell.b & 1 == 0 else "DOWN"
        direction = DIRECTION_NAMES[(cell.b // 2) & 3]
        controls.extend((CellControl("ELEVATION", elevation), CellControl("DIRECTION-", f"DIR -  {direction}"), CellControl("DIRECTION+", f"DIR +  {direction}")))
    elif map_type == 5:
        lock = _door_lock_name(cell)
        controls.extend((
            CellControl("DOOR-KIND", "PORTCULLIS" if cell.b & 2 else "REGULAR"),
            CellControl("DOOR-AXIS", "EAST / WEST" if cell.b & 4 else "NORTH / SOUTH"),
            CellControl("STATE", "CLOSED" if cell.b & 1 else "OPEN"),
            CellControl("LOCK-", f"LOCK -  {lock}"),
            CellControl("LOCK+", f"LOCK +  {lock}"),
        ))
    elif map_type == 6:
        base = ("FIZZLE", "FLOOR HOLE", "GREEN PAD", "INVISIBLE PAD")[cell.b & 3]
        controls.extend((CellControl("FLOOR-", f"FLOOR -  {base}"), CellControl("FLOOR+", f"FLOOR +  {base}"), CellControl("CEILING", "CEILING HOLE" if cell.b & 4 else "NO CEILING HOLE")))
        if cell.b & 3 in (2, 3):
            controls.extend((CellControl("REFERENCE-", f"REF -  {cell.first // 8}"), CellControl("REFERENCE+", f"REF +  {cell.first // 8}")))
    else:
        kind = ("SPACE", "FIREPATH", "MINDROCK", "FORMWALL")[cell.b & 3]
        controls.extend((CellControl("MAGIC-", f"KIND -  {kind}"), CellControl("MAGIC+", f"KIND +  {kind}"), CellControl("POWER-", f"POWER -  {cell.first // 4}"), CellControl("POWER+", f"POWER +  {cell.first // 4}")))
    controls.extend((CellControl("COPY", "COPY"), CellControl("PASTE", "PASTE"), CellControl("CLEAR", "CLEAR")))
    return tuple(controls)


def apply_cell_action(cell: MapCell, action: str) -> MapCell:
    """Apply one cell-local semantic operation."""

    if action in ("TYPE-", "TYPE+"):
        delta = -1 if action.endswith("-") else 1
        return default_cell((cell.map_type + delta) & 7)
    if action == "SPACE" or action == "CLEAR":
        return MapCell(0, 0)
    if action.startswith("FACE"):
        faces = (0, 8, 9, 10, 11)
        current = 0 if cell.c < 8 else 1 + (cell.c & 3)
        delta = -1 if action.endswith("-") else 1
        return _replace_c(cell, faces[(current + delta) % len(faces)])
    if action.startswith("FEATURE"):
        delta = -1 if action.endswith("-") else 1
        feature = ((cell.b & 3) + delta) & 3
        first = (cell.first & 0xF8) | feature
        if feature == 2 and first < 8:
            first = 0x0A
        elif feature == 3 and first < 3:
            first = 3
        return _replace_first(cell, first)
    if action == "CONCEAL":
        return cell.replace_nibble("d", cell.d ^ 8)
    if action.startswith("VARIANT"):
        delta = -1 if action.endswith("-") else 1
        if cell.b & 3 == 1:
            variants = (0x01, 0x05, 0x09, 0x0D, 0x11)
            try:
                index = variants.index(cell.first)
            except ValueError:
                index = 0
            return _replace_first(cell, variants[(index + delta) % len(variants)])
        family = min(cell.first // 8, 7)
        state = cell.b & 4
        return _replace_first(cell, (((family + delta) & 7) * 8) | 3 | state)
    if action.startswith("REFERENCE"):
        delta = -1 if action.endswith("-") else 1
        reference = max(0, min(31, cell.first // 8 + delta))
        return _replace_first(cell, reference * 8 | (cell.b & 7))
    if action == "STATE":
        if cell.map_type == 1:
            return _replace_b(cell, cell.b ^ 4)
        return _replace_b(cell, cell.b ^ 1)
    if action.startswith("WOOD-"):
        side = "NESW".index(action[-1])
        shift = side * 2
        state = ((cell.first >> shift) + 1) & 3
        return _replace_first(cell, (cell.first & ~(3 << shift)) | (state << shift))
    if action == "LOCK" and cell.map_type == 2:
        return _replace_c(cell, cell.c ^ 1)
    if action.startswith("MISC"):
        return _replace_first(cell, 0 if cell.first else 1)
    if action == "ELEVATION":
        return _replace_b(cell, cell.b ^ 1)
    if action.startswith("DIRECTION"):
        delta = -1 if action.endswith("-") else 1
        direction = ((cell.b // 2) + delta) & 3
        return _replace_b(cell, direction * 2 | (cell.b & 1))
    if action == "DOOR-KIND":
        return _replace_b(cell, cell.b ^ 2)
    if action == "DOOR-AXIS":
        return _replace_b(cell, cell.b ^ 4)
    if action.startswith("LOCK") and cell.map_type == 5:
        delta = -1 if action.endswith("-") else 1
        index = (_door_lock_index(cell) + delta) % len(LOCK_KINDS)
        b = cell.b & 7
        if index == 0:
            return MapCell(b, (cell.second & 0x0F))
        if index == len(LOCK_KINDS) - 1:
            return MapCell(b | 8, (cell.second & 0x0F))
        return MapCell(((index - 1) << 4) | b, ((cell.c & 0xC) | 1) << 4 | cell.d)
    if action.startswith("FLOOR"):
        delta = -1 if action.endswith("-") else 1
        return _replace_b(cell, (cell.b & 4) | ((cell.b + delta) & 3))
    if action == "CEILING":
        return _replace_b(cell, cell.b ^ 4)
    if action.startswith("MAGIC"):
        delta = -1 if action.endswith("-") else 1
        return _replace_first(cell, (cell.first & 0xFC) | ((cell.b + delta) & 3))
    if action.startswith("POWER"):
        delta = -1 if action.endswith("-") else 1
        power = max(0, min(63, cell.first // 4 + delta))
        return _replace_first(cell, power * 4 | (cell.b & 3))
    return cell


def _door_lock_index(cell: MapCell) -> int:
    if cell.b & 8:
        return len(LOCK_KINDS) - 1
    if cell.c & 3 == 0 and cell.a == 0:
        return 0
    return min(cell.a + 1, len(LOCK_KINDS) - 2)


def _door_lock_name(cell: MapCell) -> str:
    return LOCK_KINDS[_door_lock_index(cell)]

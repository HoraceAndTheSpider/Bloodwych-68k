"""Source-derived dungeon feature rendering for the Bloodwych data viewer.

The game uses nineteen visible map cells, twenty-eight wall-face slots, and
compact lookup tables to choose source pictures, mirroring, and placement.
This module keeps those rules separate from Pygame so they can be tested and,
once the remaining tables are extracted, loaded from version data unchanged.
"""

from __future__ import annotations

import struct
from dataclasses import dataclass
from pathlib import Path
from typing import Mapping, Sequence

from tools.graphics_preview import (
    DrawOperation,
    IndexedSprite,
    TRANSPARENT_INDEX,
    blit,
    load_floor_ceiling_background,
    mirror_pixels,
    remap_template_colours,
)
from tools.st_planar_assets import decode_planar


# adrEA00B946 and adrEA00B992.  The first table removes faces hidden behind
# the selected opaque cell; the second contributes that cell's candidate
# wall-face bits.  Their current source labels are proposals for segments.xlsx.
VIEW_CELL_OCCLUSION_MASKS = (
    0xFFFFFFFF, 0xFFFFFFFD, 0xFFFFFFFE, 0xFFFFFFE8, 0xFFFFFFAC,
    0xFFFFFEEC, 0xFFFFFBFF, 0xFFFFFFFF, 0xFFFFDFFF, 0xFFFFEFFF,
    0xFFFE8FFF, 0xFFFACFFF, 0xFFEECFFF, 0xFFBFFFFF, 0xFFFF7FF7,
    0xFEFD7FD7, 0xFCF57F57, 0xF8D57D57, 0x08D57D57,
)

VIEW_CELL_VISIBLE_FACE_MASKS = (
    0x00000003, 0x0000000E, 0x00000011, 0x00000074, 0x000001C0,
    0x00000700, 0x00000C00, 0x00003000, 0x0000E000, 0x00011000,
    0x00074000, 0x001C0000, 0x00700000, 0x00C00000, 0x01008008,
    0x03020020, 0x06080080, 0x0C200200, 0x08800800,
)

# adrEA00B9DE: one centred drawing/visibility slot per view cell.
VIEW_CELL_CENTRED_SLOTS = (
    0, 2, None, 6, 8, 10, None, 12, 14, None,
    18, 20, 22, None, 24, 25, 26, 27, None,
)

# adrEA00B9F2: four candidate face slots for each view cell.  The four table
# columns are converted to N/E/S/W by wall_face_direction(), matching
# adrCd0095D4 rather than assuming a fixed column order.
VIEW_CELL_WALL_FACE_SLOTS: tuple[tuple[int | None, ...], ...] = (
    (None, None, 0, 1),
    (None, 1, 2, 3),
    (0, None, None, 4),
    (2, 4, 6, 5),
    (6, None, 8, 7),
    (8, None, 10, 9),
    (10, None, None, 11),
    (None, None, 12, 13),
    (None, 13, 14, 15),
    (12, None, None, 16),
    (14, 16, 18, 17),
    (18, None, 20, 19),
    (20, None, 22, 21),
    (22, None, None, 23),
    (None, 15, 3, 24),
    (24, 17, 5, 25),
    (25, 19, 7, 26),
    (26, 21, 9, 27),
    (27, 23, 11, None),
)

# GFX_Main_Wall_SpriteTable: source picture for each wall-face position.
MAIN_WALL_SPRITE_TABLE = (
    12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 24, 25, 26, 27,
)

# GFX_Wall_Signs_SpriteTable_TBC.  Bit 7 requests horizontal mirroring.
WALL_COMPONENT_SPRITE_TABLE = (
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
    0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
    0x88, 0x89, 0x8A, 0x8B, 12, 13, 14, 15,
)

# GFX_Misc_Pillar_SpriteTable.  It also selects pit and pad pictures.
CENTRED_COMPONENT_SPRITE_TABLE = (
    0, 1, 2, 3, 4, 5, 6,
    0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86,
    7, 8, 9, 10, 11,
)

# The second Wooden_Wall graphic set is the open-door frame.
WOODEN_DOORWAY_GFX_BASE = 0x2498

DIRECTION_NAMES = ("North", "East", "South", "West")
WOOD_STATE_NAMES = ("none", "wall", "open door", "closed door")

SIGN_VARIANT_NAMES = (
    "Generated colour",
    "Serpent sign",
    "Dragon sign",
    "Moon sign",
    "Chaos sign",
    "Wall scroll",
)
SOCKET_VARIANT_NAMES = (
    "Serpent crystal (green)",
    "Chaos crystal (yellow)",
    "Dragon crystal (red)",
    "Moon crystal (blue)",
    "Grey crystal (unused)",
    "Bluish teleport gem",
    "Brown crystal (unused)",
    "Tan teleport gem",
)
DOOR_LOCK_VARIANT_NAMES = (
    "Dark grey key",
    "Brown key",
    "Light grey key",
    "Green key",
    "Yellow key",
    "Red key",
    "Blue key",
    "White key",
)

# adrCd0094DC: the ordinary type-6 trigger-pad colour mask.
TRIGGER_PAD_COLOURS = (1, 5, 4, 6)

# adrL_0094D4: the two masks selected while a Firepath flashes.
FIREPATH_COLOUR_FRAMES = (
    (9, 12, 11, 13),
    (9, 10, 11, 13),
)

# Mindrock/Formwall are represented by ordinary stone walls in the renderer.
# These are deliberately direct editor-preview substitutions, not the game's
# four-colour template-mask routine.  All unlisted wall shades remain intact.
FORMWALL_PALETTE_SUBSTITUTIONS = {2: 5, 3: 6}
MINDROCK_PALETTE_SUBSTITUTIONS = {1: 7, 14: 8}


@dataclass(frozen=True)
class DungeonFeatureDefinition:
    key: str
    name: str
    map_type: int | None
    files: tuple[str, ...]
    note: str
    rotates: bool = False
    variants: int = 1


@dataclass(frozen=True)
class DungeonSpaceTypeDefinition:
    map_type: int
    name: str
    feature_keys: tuple[str, ...]


@dataclass(frozen=True)
class DungeonPlacement:
    feature_key: str
    direction: int = 2
    variant: int = 0
    active: bool = True
    wood_states: tuple[int, int, int, int] = (0, 0, 3, 0)
    nudge_x: int = 0
    nudge_y: int = 0
    ceiling_hole: bool = False
    # Source-derived colour/overlay selectors may depend on the absolute map
    # coordinate rather than the map object's semantic variant.  -1 requests
    # the all-black mask used by switch reference zero and void locks.  These
    # follow the original preview fields to preserve the public positional
    # construction used by the Data Viewer.
    colour_variant: int | None = None
    overlay_variant: int | None = None


DUNGEON_FEATURES = (
    DungeonFeatureDefinition("space", "Space", 0, (), "Empty floor and ceiling."),
    DungeonFeatureDefinition("stone", "Stone wall", 1, ("Main_Walls.gfx", "Main_Walls.offsets", "Main_Walls.positions"), "Opaque stone wall rendered from the game's face/occlusion tables."),
    DungeonFeatureDefinition("shelf", "Wall shelf", 1, ("Main_Shelf.gfx", "Main_Shelf.offsets", "Main_Shelf.positions"), "Stone wall with a shelf on one N/E/S/W face.", True),
    DungeonFeatureDefinition("sign", "Wall sign", 1, ("Main_Sign.gfx", "Main_Sign.offsets", "Main_Sign.positions", "Main_SignOverlay.gfx", "Main_SignOverlay.offsets", "Main_SignOverlay.positions", "Main_Sign.colours"), "Generated sign, one of the four tower emblems, or a wall-scroll face.", True, len(SIGN_VARIANT_NAMES)),
    DungeonFeatureDefinition("switch", "Wall switch", 1, ("Main_Switches.gfx", "Main_Switches.offsets", "Main_Switches.positions", "Switches.colours"), "Switch colour is selected from its action/location data; state toggles lit and dim/used.", True, 8),
    DungeonFeatureDefinition("socket", "Gem socket", 1, ("Main_Slots.gfx", "Main_Slots.offsets", "Main_Slots.positions", "Main_Slots.colours"), "Eight crystal/gem colour schemes; state inserts or removes the gem.", True, len(SOCKET_VARIANT_NAMES)),
    DungeonFeatureDefinition("wood", "Wood / doors", 2, ("Wooden_Wall.gfx", "Wooden_Wall.offsets", "Wooden_Wall.positions", "Wooden_Doors.gfx", "Wooden_Doors.offsets", "Wooden_Doors.positions"), "Each N/E/S/W side independently cycles through none, wall, open door, and closed door."),
    DungeonFeatureDefinition("bed", "Bed", 3, ("Misc_Bed.gfx", "Misc_Bed.offsets", "Misc_Bed.positions"), "Beds are only drawn at the game's supported near distances."),
    DungeonFeatureDefinition("pillar", "Pillar", 3, ("Misc_Pillar.gfx", "Misc_Pillar.offsets", "Misc_Pillar.positions"), "Centred full-height dungeon feature."),
    DungeonFeatureDefinition("stairs_up", "Stairs up", 4, ("Stairs_Up.gfx", "Stairs_Up.offsets", "Stairs_Up.positions"), "Map direction affects movement; the visible picture is selected by view cell.", True),
    DungeonFeatureDefinition("stairs_down", "Stairs down", 4, ("Stairs_Down.gfx", "Stairs_Down.offsets", "Stairs_Down.positions"), "Map direction affects movement; the visible picture is selected by view cell.", True),
    DungeonFeatureDefinition("door_open", "Open doorway", 5, ("Door_Open.gfx", "Door.offsets", "Door.Positions"), "Open large-door frame."),
    DungeonFeatureDefinition("door_metal", "Metal door", 5, ("Door_Open.gfx", "Door_Metal.gfx", "Door.offsets", "Door.Positions"), "Metal-door style; state toggles open/closed and variant selects the key colour.", False, len(DOOR_LOCK_VARIANT_NAMES)),
    DungeonFeatureDefinition("door_portcullis", "Portcullis", 5, ("Door_Open.gfx", "Door_PortCullis.gfx", "Door.offsets", "Door.Positions"), "Portcullis style; state toggles open/closed and variant selects the key colour.", False, len(DOOR_LOCK_VARIANT_NAMES)),
    DungeonFeatureDefinition("pit", "Floor pit", 6, ("Pad_Pit_Low.gfx", "Pad_Pit.offsets", "Pad_Pit_Low.positions"), "Floor hole selected by the centred component table."),
    DungeonFeatureDefinition("ceiling_pit", "Ceiling hole", 6, ("Pad_Trigger.gfx", "Pad_Trigger.offsets", "Pad_Trigger.positions"), "Ceiling-hole overlay; it may coexist with a floor pit or trigger pad."),
    DungeonFeatureDefinition("pad", "Trigger pad", 6, ("Pad_Pit_High.gfx", "Pad_Pit.offsets", "Pad_Pit_Low.positions"), "Trigger-pad template recoloured with the game's type-6 colour mask; a ceiling hole may coexist with it."),
    DungeonFeatureDefinition("firepath", "Firepath", 7, ("Pad_Pit_High.gfx", "Pad_Pit.offsets", "Pad_Pit_Low.positions"), "Trigger-pad artwork recoloured red/yellow using the game's two flashing Firepath masks.", False, len(FIREPATH_COLOUR_FRAMES)),
    DungeonFeatureDefinition("mindrock", "Mindrock", 7, ("Main_Walls.gfx", "Main_Walls.offsets", "Main_Walls.positions"), "Editor preview replaces the darkest grey with dark blue and white with light blue."),
    DungeonFeatureDefinition("formwall", "Formwall", 7, ("Main_Walls.gfx", "Main_Walls.offsets", "Main_Walls.positions"), "Editor preview replaces only the two middle greys with the game's two greens."),
)

DUNGEON_SPACE_TYPES = (
    DungeonSpaceTypeDefinition(0, "Nothing / space", ("space",)),
    DungeonSpaceTypeDefinition(1, "Stone wall", ("stone", "shelf", "sign", "switch", "socket")),
    DungeonSpaceTypeDefinition(2, "Wood walls / doors", ("wood",)),
    DungeonSpaceTypeDefinition(3, "Miscellaneous", ("pillar", "bed")),
    DungeonSpaceTypeDefinition(4, "Stairs", ("stairs_up", "stairs_down")),
    DungeonSpaceTypeDefinition(5, "Large doors", ("door_metal", "door_portcullis")),
    DungeonSpaceTypeDefinition(6, "Pits / pads", ("pit", "ceiling_pit", "pad")),
    DungeonSpaceTypeDefinition(7, "Magic", ("firepath", "mindrock", "formwall")),
)


def dungeon_variant_name(feature: DungeonFeatureDefinition, variant: int) -> str:
    """Return a plain-English description of a feature variant."""
    index = variant % max(1, feature.variants)
    if feature.key == "sign":
        return SIGN_VARIANT_NAMES[index]
    if feature.key == "socket":
        return SOCKET_VARIANT_NAMES[index]
    if feature.key in {"door_metal", "door_portcullis"}:
        return DOOR_LOCK_VARIANT_NAMES[index]
    if feature.key == "switch":
        return f"switch colour set {index}"
    if feature.key == "firepath":
        return f"flash frame {index + 1}"
    return f"variant {index}"


def dungeon_state_name(
    feature: DungeonFeatureDefinition,
    active: bool,
    *,
    ceiling_hole: bool = False,
) -> str:
    """Return a plain-English description of the feature's toggle state."""
    if feature.key == "socket":
        return "gem inserted" if active else "socket empty"
    if feature.key == "switch":
        return "lit/on" if active else "dim/used"
    if feature.key in {"door_metal", "door_portcullis"}:
        return "closed" if active else "open"
    if feature.key == "shelf":
        return "visible" if active else "concealed"
    if feature.key in {"pit", "pad"}:
        return "with ceiling hole" if ceiling_hole else "without ceiling hole"
    return "active" if active else "inactive"


def dungeon_features_for_map_type(map_type: int) -> tuple[DungeonFeatureDefinition, ...]:
    space_type = next(
        (item for item in DUNGEON_SPACE_TYPES if item.map_type == map_type),
        None,
    )
    if space_type is None:
        return ()
    definitions = {feature.key: feature for feature in DUNGEON_FEATURES}
    return tuple(definitions[key] for key in space_type.feature_keys)


def visible_wall_slots(
    view_cell: int,
    wall_visibility_mask: int | None = None,
) -> tuple[int, ...]:
    """Return exactly the wall-face bits retained for one isolated stone cell."""
    if not 0 <= view_cell < 19:
        return ()
    if wall_visibility_mask is None:
        wall_visibility_mask = VIEW_CELL_OCCLUSION_MASKS[view_cell]
    mask = VIEW_CELL_VISIBLE_FACE_MASKS[view_cell] & wall_visibility_mask
    return tuple(slot for slot in range(28) if mask & (1 << slot))


def wall_slots_in_draw_order(
    view_cell: int,
    wall_visibility_mask: int | None = None,
) -> tuple[int, ...]:
    """Return retained faces in the game's four-entry source-table order.

    This is deliberately not numeric slot order.  In particular, the player
    cell's record is rear, right, left, front; filtering it through the
    visibility mask therefore retains the rear face before either side.
    """
    if not 0 <= view_cell < 19:
        return ()
    visible = set(visible_wall_slots(view_cell, wall_visibility_mask))
    return tuple(
        slot
        for slot in VIEW_CELL_WALL_FACE_SLOTS[view_cell]
        if slot is not None and slot in visible
    )


def wall_face_direction(view_cell: int, column: int, player_facing: int = 0) -> int:
    """Return the relative N/E/S/W side represented by a face-table column.

    The left, right, and centre groups use different column orders because the
    source reuses mirrored perspective records.  ``adrCd0095D4`` tests the
    requested map direction against those groups; it is not itself a direct
    column-to-direction conversion.
    """
    if not 0 <= view_cell < 19 or not 0 <= column < 4:
        raise ValueError("view cell and wall-face column are out of range")
    if view_cell < 7:
        direction = (0, 3, 2, 1)[column]  # N, W, S, E
    elif view_cell < 14:
        direction = (0, 1, 2, 3)[column]  # N, E, S, W
    else:
        direction = (0, 1, 3, 2)[column]  # N, E, W, S
    return (direction + player_facing) & 3


def wall_slots_for_direction(
    view_cell: int,
    direction: int,
    wall_visibility_mask: int | None = None,
) -> tuple[int, ...]:
    visible = set(visible_wall_slots(view_cell, wall_visibility_mask))
    return tuple(
        slot
        for column, slot in enumerate(VIEW_CELL_WALL_FACE_SLOTS[view_cell])
        if slot is not None
        and slot in visible
        and wall_face_direction(view_cell, column) == (direction & 3)
    )


class PackedPictureGroup:
    """One `.gfx` source with independent source-offset and screen-position tables."""

    def __init__(self, gfx_path: object, offsets_path: object, positions_path: object):
        self.gfx_path = gfx_path
        self.gfx = gfx_path.read_bytes()
        offset_data = offsets_path.read_bytes()
        position_data = positions_path.read_bytes()
        if len(offset_data) % 2 or len(position_data) % 4:
            raise ValueError("dungeon offset/position table alignment is invalid")
        self.offsets = [value[0] for value in struct.iter_unpack(">H", offset_data)]
        self.positions = list(struct.iter_unpack(">4B", position_data))

    def operation(
        self,
        source_index: int,
        position_index: int,
        *,
        mirrored: bool = False,
        gfx_base: int = 0,
        replacements: Sequence[int] | None = None,
        palette_substitutions: Mapping[int, int] | None = None,
    ) -> DrawOperation:
        if not 0 <= source_index < len(self.offsets):
            raise IndexError(f"source picture {source_index} is not in {self.gfx_path.name}")
        if not 0 <= position_index < len(self.positions):
            raise IndexError(f"screen position {position_index} is not in {self.gfx_path.name}")
        x_half, y, width_minus_one, height_minus_one = self.positions[position_index]
        width_words = width_minus_one + 1
        height = height_minus_one + 1
        byte_size = width_words * height * 8
        offset = gfx_base + self.offsets[source_index]
        raw = self.gfx[offset : offset + byte_size]
        if len(raw) != byte_size:
            raise ValueError(
                f"{self.gfx_path.name} picture {source_index} needs {byte_size} bytes at ${offset:04X}"
            )
        pixels = decode_planar(raw, width_words, height)
        if replacements is not None:
            pixels = remap_template_colours(pixels, replacements)
        if palette_substitutions is not None:
            if any(
                not 0 <= source <= 15 or not 0 <= target <= 15
                for source, target in palette_substitutions.items()
            ):
                raise ValueError("palette substitutions must use indices 0..15")
            pixels = [
                [palette_substitutions.get(colour, colour) for colour in row]
                for row in pixels
            ]
        sprite = IndexedSprite(
            f"{self.gfx_path.name}_{source_index:02d}",
            self.gfx_path.name,
            offset,
            pixels,
        )
        return DrawOperation(sprite, x_half * 2, y, mirrored)


class DungeonAssets:
    def __init__(self, gfx_dir: object):
        self.gfx_dir = gfx_dir

    def group(
        self,
        gfx_name: str,
        offsets_name: str,
        positions_name: str,
    ) -> PackedPictureGroup:
        return PackedPictureGroup(
            self.gfx_dir / gfx_name,
            self.gfx_dir / offsets_name,
            self.gfx_dir / positions_name,
        )

    def palettes(self, filename: str) -> list[tuple[int, int, int, int]]:
        data = (self.gfx_dir / filename).read_bytes()
        if len(data) % 4:
            raise ValueError(f"{filename} must contain four-byte colour masks")
        return [tuple(data[index : index + 4]) for index in range(0, len(data), 4)]


def _mapped_wall_operation(
    group: PackedPictureGroup,
    slot: int,
    *,
    main_wall: bool = False,
    pattern_parity: int = 1,
    gfx_base: int = 0,
    replacements: Sequence[int] | None = None,
    palette_substitutions: Mapping[int, int] | None = None,
) -> DrawOperation:
    mapped = (
        MAIN_WALL_SPRITE_TABLE[slot]
        if main_wall and pattern_parity & 1
        else (slot if main_wall else WALL_COMPONENT_SPRITE_TABLE[slot])
    )
    # The odd parity path selects the second source-picture set and reverses
    # each row through BitReverse_LookupBuffer while writing right-to-left.
    # The even path uses the identity picture index and ordinary row writer.
    mirrored = bool(pattern_parity & 1) if main_wall else bool(mapped & 0x80)
    return group.operation(
        mapped & 0x7F,
        slot,
        mirrored=mirrored,
        gfx_base=gfx_base,
        replacements=replacements,
        palette_substitutions=palette_substitutions,
    )


def _mapped_wall_operations(
    group: PackedPictureGroup,
    slot: int,
    *,
    gfx_base: int = 0,
    replacements: Sequence[int] | None = None,
) -> tuple[DrawOperation, ...]:
    """Apply Draw_Wall_Sprite's single/flip/two-half dispatch."""
    mapped = WALL_COMPONENT_SPRITE_TABLE[slot]
    first = _mapped_wall_operation(
        group,
        slot,
        gfx_base=gfx_base,
        replacements=replacements,
    )
    if mapped & 0x80 or (mapped & 0x7F) < 12:
        return (first,)
    mirrored_x = 128 - first.x - first.sprite.width
    return (
        first,
        DrawOperation(first.sprite, mirrored_x, first.y, True),
    )


def _centred_operation(
    group: PackedPictureGroup,
    view_cell: int,
    *,
    replacements: Sequence[int] | None = None,
) -> DrawOperation | None:
    if not 0 <= view_cell < len(VIEW_CELL_CENTRED_SLOTS) or view_cell >= len(group.positions):
        return None
    if view_cell == 18:
        # Type-6 floor/ceiling graphics have a dedicated player-cell entry.
        # The normal centred-slot table contains a sentinel here because it is
        # bypassed by the original routine; the component table maps the cell
        # directly to source picture 11.
        mapped = 11
    else:
        if VIEW_CELL_CENTRED_SLOTS[view_cell] is None:
            return None
        mapped = CENTRED_COMPONENT_SPRITE_TABLE[view_cell]
    return group.operation(
        mapped & 0x7F,
        view_cell,
        mirrored=bool(mapped & 0x80),
        replacements=replacements,
    )


def _door_source_index(view_cell: int) -> int | None:
    # Far side and centre positions use pictures 1..5; the near centre set
    # continues at 7..11.  Zero-sized entries are deliberately suppressed.
    table = (None, 1, None, 3, 4, 5, None, None, 1, None, 3, 4, 5, None, 7, 8, 9, 10, 11)
    return table[view_cell] if 0 <= view_cell < len(table) else None


def render_dungeon_feature(
    background: Sequence[Sequence[int]],
    assets: DungeonAssets,
    feature: DungeonFeatureDefinition,
    *,
    view_cell: int,
    direction: int = 2,
    variant: int = 0,
    colour_variant: int | None = None,
    overlay_variant: int | None = None,
    active: bool = True,
    wood_states: Sequence[int] = (0, 0, 3, 0),
    wall_visibility_mask: int | None = None,
    nudge_x: int = 0,
    nudge_y: int = 0,
    ceiling_hole: bool = False,
    pattern_parity: int = 1,
) -> tuple[list[list[int]], dict[str, object]]:
    """Render one map feature into the shared 128×76 game viewport."""
    canvas = [list(row) for row in background]
    operations: list[DrawOperation] = []
    visible_slots = wall_slots_in_draw_order(view_cell, wall_visibility_mask)

    def wall_group(stem: str) -> PackedPictureGroup:
        return assets.group(f"{stem}.gfx", f"{stem}.offsets", f"{stem}.positions")

    def add_stone_wall(
        replacements: Sequence[int] | None = None,
        palette_substitutions: Mapping[int, int] | None = None,
    ) -> None:
        group = wall_group("Main_Walls")
        operations.extend(
            _mapped_wall_operation(
                group,
                slot,
                main_wall=True,
                pattern_parity=pattern_parity,
                replacements=replacements,
                palette_substitutions=palette_substitutions,
            )
            for slot in visible_slots
        )

    def add_ceiling_hole() -> None:
        group = assets.group(
            "Pad_Trigger.gfx",
            "Pad_Trigger.offsets",
            "Pad_Trigger.positions",
        )
        operation = _centred_operation(group, view_cell)
        if operation is not None:
            operations.append(operation)

    def add_trigger_pad(replacements: Sequence[int]) -> None:
        group = assets.group(
            "Pad_Pit_High.gfx",
            "Pad_Pit.offsets",
            "Pad_Pit_Low.positions",
        )
        operation = _centred_operation(
            group,
            view_cell,
            replacements=replacements,
        )
        if operation is not None:
            operations.append(operation)

    if feature.key == "stone":
        add_stone_wall()
    elif feature.key in {"shelf", "sign", "switch", "socket"}:
        add_stone_wall()
        slots = wall_slots_for_direction(
            view_cell, direction, wall_visibility_mask
        )
        if slots and (active or feature.key in {"sign", "switch", "socket"}):
            if feature.key == "shelf":
                group = wall_group("Main_Shelf")
                for slot in slots:
                    operations.extend(_mapped_wall_operations(group, slot))
            else:
                stems = {"sign": "Main_Sign", "switch": "Main_Switches", "socket": "Main_Slots"}
                colour_files = {"sign": "Main_Sign.colours", "switch": "Switches.colours", "socket": "Main_Slots.colours"}
                palettes = assets.palettes(colour_files[feature.key])
                if feature.key == "sign" and variant in range(1, 5):
                    palette_index = variant - 1
                else:
                    # Generated signs, wall scrolls, and non-zero switches use
                    # (map X + map Y) & 7.  The standalone viewer falls back to
                    # its manually selected variant.
                    palette_index = (
                        colour_variant
                        if colour_variant is not None
                        else (variant if feature.key != "sign" else 0)
                    )
                replacements = (
                    [0, 0, 0, 0]
                    if palette_index < 0
                    else list(palettes[palette_index % len(palettes)])
                )
                if feature.key == "socket" and not active:
                    # Draw_Main_Object_Overlay clears the low replacement byte
                    # for an empty socket while retaining the socket graphic.
                    replacements[-1] = 0
                elif feature.key == "switch" and not active:
                    # Draw_Main_Switch_Overlay's used/dim branch preserves the
                    # old final and third replacement bytes in this order.
                    replacements = [0, replacements[3], 0, replacements[2]]
                group = wall_group(stems[feature.key])
                for slot in slots:
                    operations.extend(
                        _mapped_wall_operations(
                            group, slot, replacements=replacements
                        )
                    )
                if feature.key == "sign" and variant in range(1, 5):
                    overlay = wall_group("Main_SignOverlay")
                    overlay_base = (variant - 1) * 0x610
                    for slot in slots:
                        operations.extend(
                            _mapped_wall_operations(
                                overlay, slot, gfx_base=overlay_base
                            )
                        )
                elif feature.key == "sign" and variant == 0:
                    # Generated sign artwork is selected by
                    # (2 * map X - map Y) & 3, independently of its palette.
                    overlay = wall_group("Main_SignOverlay")
                    overlay_base = ((overlay_variant or 0) & 3) * 0x610
                    for slot in slots:
                        operations.extend(
                            _mapped_wall_operations(
                                overlay, slot, gfx_base=overlay_base
                            )
                        )
    elif feature.key == "wood":
        wall = wall_group("Wooden_Wall")
        door = wall_group("Wooden_Doors")
        states = tuple(wood_states)[:4]
        visible = set(visible_slots)
        for column, slot in enumerate(VIEW_CELL_WALL_FACE_SLOTS[view_cell]):
            if slot is None or slot not in visible:
                continue
            state = states[wall_face_direction(view_cell, column)]
            if state == 1:
                operations.extend(_mapped_wall_operations(wall, slot))
            elif state in {2, 3}:
                operations.extend(
                    _mapped_wall_operations(
                        wall, slot, gfx_base=WOODEN_DOORWAY_GFX_BASE
                    )
                )
                if state == 3:
                    operations.extend(_mapped_wall_operations(door, slot))
    elif feature.key in {"pillar", "bed", "pit", "ceiling_pit", "pad"}:
        if feature.key in {"pit", "pad"} and ceiling_hole:
            # The type-6 source handles the independent ceiling bit before
            # choosing and drawing the floor pit or trigger pad.
            add_ceiling_hole()
        if feature.key == "pillar":
            group = wall_group("Misc_Pillar")
            operation = _centred_operation(group, view_cell)
        elif feature.key == "bed":
            group = wall_group("Misc_Bed")
            operation = (
                group.operation(view_cell, view_cell)
                if 0 <= view_cell < 18 and group.positions[view_cell][3] != 0
                else None
            )
        elif feature.key == "pit":
            group = assets.group(
                "Pad_Pit_Low.gfx",
                "Pad_Pit.offsets",
                "Pad_Pit_Low.positions",
            )
            operation = _centred_operation(group, view_cell)
        elif feature.key == "pad":
            operation = None
            add_trigger_pad(TRIGGER_PAD_COLOURS)
        else:
            operation = None
            add_ceiling_hole()
        if operation is not None:
            operations.append(operation)
    elif feature.key in {"stairs_up", "stairs_down"}:
        stem = "Stairs_Up" if feature.key == "stairs_up" else "Stairs_Down"
        group = wall_group(stem)
        if view_cell == 18:
            # Draw_Main_Door_Or_Stairs uses the final source picture and the
            # dedicated current-cell position, then mirrors the other half.
            first = group.operation(16, 28)
            operations.extend((
                first,
                DrawOperation(
                    first.sprite,
                    128 - first.x - first.sprite.width,
                    first.y,
                    True,
                ),
            ))
        else:
            slot = VIEW_CELL_CENTRED_SLOTS[view_cell] if 0 <= view_cell < 19 else None
            if slot is not None:
                operations.extend(_mapped_wall_operations(group, slot))
    elif feature.key in {"door_open", "door_metal", "door_portcullis"}:
        source_index = _door_source_index(view_cell)
        if source_index is not None:
            # A player can only occupy a large-door cell after opening it.  The
            # two inside-view pictures (11/12) consequently exist only in the
            # shared open-door block; the closed metal/portcullis blocks end at
            # picture 11's offset.
            gfx_name = (
                "Door_Open.gfx"
                if view_cell == 18 or feature.key == "door_open" or not active
                else {
                    "door_metal": "Door_Metal.gfx",
                    "door_portcullis": "Door_PortCullis.gfx",
                }[feature.key]
            )
            group = assets.group(gfx_name, "Door.offsets", "Door.Positions")
            replacements = None
            if feature.key != "door_open":
                lock_colours = (1, 9, 4, 6, 13, 12, 7, 14)
                lock_colour = (
                    0
                    if colour_variant == -1
                    else lock_colours[
                        (colour_variant if colour_variant is not None else variant) % 8
                    ]
                )
                replacements = (0, 4, lock_colour, 12)
            position_index = view_cell
            if view_cell == 18 and direction & 1:
                # The source XORs the door axis with player facing and selects
                # the alternative inside-door source/position pair when the
                # structure runs sideways across the current cell.
                source_index = 12
                position_index = 19
            first = group.operation(
                source_index,
                position_index,
                mirrored=7 <= view_cell <= 12,
                replacements=replacements,
            )
            operations.append(first)
            if view_cell >= 14:
                operations.append(
                    DrawOperation(
                        first.sprite,
                        128 - first.x - first.sprite.width,
                        first.y,
                        True,
                    )
                )
    elif feature.key == "firepath":
        add_trigger_pad(FIREPATH_COLOUR_FRAMES[variant % len(FIREPATH_COLOUR_FRAMES)])
    elif feature.key == "mindrock":
        add_stone_wall(palette_substitutions=MINDROCK_PALETTE_SUBSTITUTIONS)
    elif feature.key == "formwall":
        add_stone_wall(palette_substitutions=FORMWALL_PALETTE_SUBSTITUTIONS)
    # Space deliberately adds no static picture.

    records = []
    for operation in operations:
        pixels = mirror_pixels(operation.sprite.pixels) if operation.mirrored else operation.sprite.pixels
        x = operation.x + nudge_x
        y = operation.y + nudge_y
        blit(canvas, pixels, x, y, transparent_index=TRANSPARENT_INDEX)
        records.append(
            {
                "source": operation.sprite.source_file,
                "source_index": int(operation.sprite.name.rsplit("_", 1)[-1]),
                "x": x,
                "y": y,
                "width": operation.sprite.width,
                "height": operation.sprite.height,
                "mirrored": operation.mirrored,
            }
        )
    return canvas, {
        "feature": feature.key,
        "map_type": feature.map_type,
        "view_cell": view_cell,
        "direction": direction & 3,
        "direction_name": DIRECTION_NAMES[direction & 3],
        "variant": variant,
        "colour_variant": colour_variant,
        "overlay_variant": overlay_variant,
        "active": active,
        "wood_states": list(tuple(wood_states)[:4]),
        "ceiling_hole": ceiling_hole,
        "pattern_parity": pattern_parity & 1,
        "visible_wall_slots": list(visible_slots),
        "operations": records,
    }


def scene_wall_visibility_mask(
    placements: Mapping[int, DungeonPlacement],
) -> int:
    """Recreate the source renderer's shared face mask for a small scene.

    The renderer first combines candidate faces for the nineteen in-bounds
    view cells, then applies the occlusion mask of every opaque type-1 stone
    location.  Other map types are composited but do not currently remove
    faces; type-2 line-of-sight depends on its directional wall bits and will
    be added when that routine is fully named.
    """
    candidates = 0
    for mask in VIEW_CELL_VISIBLE_FACE_MASKS:
        candidates |= mask
    occlusion = 0xFFFFFFFF
    definitions = {feature.key: feature for feature in DUNGEON_FEATURES}
    for view_cell, placement in placements.items():
        feature = definitions.get(placement.feature_key)
        if feature is not None and feature.map_type == 1 and 0 <= view_cell < 19:
            occlusion &= VIEW_CELL_OCCLUSION_MASKS[view_cell]
    return candidates & occlusion


def render_dungeon_scene(
    background: Sequence[Sequence[int]],
    assets: DungeonAssets,
    placements: Mapping[int, DungeonPlacement],
    *,
    pattern_parity: int = 1,
) -> tuple[list[list[int]], dict[str, object]]:
    """Render independently configured map cells in source traversal order."""
    canvas = [list(row) for row in background]
    definitions = {feature.key: feature for feature in DUNGEON_FEATURES}
    wall_visibility_mask = scene_wall_visibility_mask(placements)
    rendered: list[dict[str, object]] = []
    for view_cell in sorted(placements):
        placement = placements[view_cell]
        feature = definitions.get(placement.feature_key)
        if feature is None or not 0 <= view_cell < 19:
            continue
        canvas, metadata = render_dungeon_feature(
            canvas,
            assets,
            feature,
            view_cell=view_cell,
            direction=placement.direction,
            variant=placement.variant,
            colour_variant=placement.colour_variant,
            overlay_variant=placement.overlay_variant,
            active=placement.active,
            wood_states=placement.wood_states,
            wall_visibility_mask=wall_visibility_mask,
            nudge_x=placement.nudge_x,
            nudge_y=placement.nudge_y,
            ceiling_hole=placement.ceiling_hole,
            pattern_parity=pattern_parity,
        )
        rendered.append(metadata)
    return canvas, {
        "wall_visibility_mask": wall_visibility_mask,
        "pattern_parity": pattern_parity & 1,
        "placements": rendered,
    }


def load_dungeon_background(
    gfx_dir: object,
    *,
    pattern_parity: int = 1,
) -> list[list[int]]:
    background = load_floor_ceiling_background(gfx_dir)
    if pattern_parity & 1:
        return background
    return [list(reversed(row)) for row in background]

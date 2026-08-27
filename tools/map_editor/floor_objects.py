"""Source-derived map-marker and dungeon-view placement for floor objects."""

from __future__ import annotations

from dataclasses import dataclass

from tools.dungeon_view import wall_slots_for_direction
from tools.object_data import ObjectAssets
from tools.map_editor.model import ObjectStack, TowerMap


# The object-location record encodes the four floor corners, not compass-edge
# positions. Shelf meanings use the same values but follow their own facing
# table (see the Object Location Data Structure Wiki page).
OBJECT_MARKER_OFFSETS = {
    0: (4, 4),
    4: (12, 4),
    8: (4, 12),
    12: (12, 12),
}
FLOOR_POSITION_NAMES = {
    0: "NORTH-WEST",
    4: "NORTH-EAST",
    8: "SOUTH-WEST",
    12: "SOUTH-EAST",
}
WALL_DIRECTION_NAMES = ("NORTH", "EAST", "SOUTH", "WEST")
# Each shelf face has exactly two usable encoded positions.  The first is the
# lower shelf level and the second the upper level; their encoded values vary
# with the shelf's absolute map direction.
SHELF_POSITIONS_BY_FACING = {
    0: (0, 4),   # north: NW bottom, NE top
    1: (4, 12),  # east: NE bottom, SE top
    2: (8, 12),  # south: SW bottom, SE top
    3: (8, 0),   # west: SW bottom, NW top
}
# ``ObjectAssets.floor_preview`` starts its source crop at row $2A, with the
# same extra two-pixel adjustment used by the original object renderer. Its
# full viewport placement is therefore ViewY - $0C, not ViewY - $08.
OBJECT_VIEWPORT_Y_ADJUSTMENT = -12


@dataclass(frozen=True)
class ObjectFloorProjection:
    """One object sprite at the source renderer's viewport coordinates."""

    stack: ObjectStack
    code: int
    view_cell: int
    projection: int
    x: int
    y: int
    shelf: bool


def signed_byte(value: int) -> int:
    """Interpret one source table byte as the 68000's signed X coordinate."""

    return value - 0x100 if value >= 0x80 else value


def object_stack_location(
    tower_map: TowerMap,
    stack: ObjectStack,
) -> tuple[int, int, int] | None:
    """Resolve an object stack's packed map index to floor/X/Y coordinates."""

    return tower_map.floor_from_map_index(stack.map_index)


def object_marker_offset(position: int) -> tuple[int, int] | None:
    """Return the source-authored subposition as a small map-marker centre."""

    return OBJECT_MARKER_OFFSETS.get(position)


def object_stack_indices_at_cell(
    tower_map: TowerMap,
    stacks: tuple[ObjectStack, ...] | list[ObjectStack],
    floor: int,
    x: int,
    y: int,
) -> tuple[int, ...]:
    """Return source-order stack indices occupying one map cell."""

    return tuple(
        index
        for index, stack in enumerate(stacks)
        if object_stack_location(tower_map, stack) == (floor, x, y)
    )


def cycle_object_stack_index(
    indices: tuple[int, ...], current: int | None
) -> int | None:
    """Select the next co-located stack in source rotation order."""

    if not indices:
        return None
    if current not in indices:
        return indices[0]
    return indices[(indices.index(current) + 1) % len(indices)]


def object_stack_positions(tower_map: TowerMap, stack: ObjectStack) -> tuple[int, ...]:
    """Return the valid source-authored positions for a floor or shelf stack."""

    location = object_stack_location(tower_map, stack)
    if location is None:
        return tuple(OBJECT_MARKER_OFFSETS)
    floor, x, y = location
    cell = tower_map.cell(floor, x, y)
    if cell.map_type == 1 and cell.c >= 8 and cell.b & 3 == 0:
        return SHELF_POSITIONS_BY_FACING[cell.c & 3]
    return tuple(OBJECT_MARKER_OFFSETS)


def object_position_name(tower_map: TowerMap, stack: ObjectStack) -> str:
    """Describe an object mini-position as a floor corner or shelf level."""

    location = object_stack_location(tower_map, stack)
    if location is not None:
        floor, x, y = location
        cell = tower_map.cell(floor, x, y)
        if cell.map_type == 1 and cell.c >= 8 and cell.b & 3 == 0:
            facing = cell.c & 3
            level = shelf_level(stack.position, facing)
            if level is not None:
                return (
                    f"{WALL_DIRECTION_NAMES[facing]} WALL · "
                    f"{'BOTTOM' if level == 0 else 'TOP'} SHELF"
                )
            return f"{WALL_DIRECTION_NAMES[facing]} WALL · INVALID SHELF POSITION"
    return FLOOR_POSITION_NAMES.get(stack.position, f"INVALID {stack.position}")


def shelf_level(position: int, shelf_facing: int) -> int | None:
    """Return the lower/upper shelf level encoded by an object position.

    Unlike a floor cell's four corners, a shelf has only two locations.  The
    same four nibble values are reused, with their meaning selected by the
    shelf face stored in the map cell.
    """

    try:
        return SHELF_POSITIONS_BY_FACING[shelf_facing & 3].index(position)
    except ValueError:
        return None


def shelf_face_is_visible(
    view_cell: int,
    relative_direction: int,
    *,
    wall_visibility_mask: int | None = None,
) -> bool:
    """Match the original shelf renderer's selected wall-face gate.

    ``adrCd00B1E0`` is entered only from the renderer's chosen wall-face
    path.  ``wall_slots_for_direction`` is the source-derived equivalent of
    that path, including occlusion; without a returned slot, neither shelf
    nor its stored objects may be visible.
    """

    return bool(
        wall_slots_for_direction(
            view_cell,
            relative_direction,
            wall_visibility_mask,
        )
    )


def named_key_colour_index(assets: ObjectAssets, stack: ObjectStack) -> int | None:
    """Return a named key's floor-palette ink, if this stack contains one."""

    for code, _quantity in stack.items:
        if 0x50 <= code <= 0x56:
            definition = assets.definition(code)
            return assets.floor_palettes[definition.floor_colour_set][2]
    return None


def project_floor_object(
    assets: ObjectAssets,
    stack: ObjectStack,
    code: int,
    *,
    view_cell: int,
    facing: int,
    shelf: bool,
    shelf_facing: int | None = None,
) -> ObjectFloorProjection | None:
    """Translate one object through ``Draw_ObjectOnFloor``'s tables.

    The game first rotates the stack's stored 0/4/8/12 mini-space into the
    player's frame, then selects one of five distance projections.  Shelf
    stacks take the source routine's alternate X and Y path.
    """

    if not (0 <= view_cell < 19) or stack.position not in OBJECT_MARKER_OFFSETS:
        return None
    if shelf and (shelf_facing is None or shelf_level(stack.position, shelf_facing) is None):
        return None
    subposition = assets.floor_subposition_rotation[
        (facing & 3) * 4 + stack.position // 4
    ]
    depth_base = assets.floor_view_cell_depth_base[view_cell]
    if depth_base == 0xFF:
        return None
    projection_index = depth_base + assets.floor_subposition_depth_bias[subposition]
    if not 0 <= projection_index < len(assets.floor_projection_groups):
        return None
    projection = assets.floor_projection_groups[projection_index]
    if not 0 <= projection < 5:
        return None

    definition = assets.definition(code)
    if definition.floor_shape == 0xFF:
        return None
    y = (
        assets.floor_view_y[projection]
        + OBJECT_VIEWPORT_Y_ADJUSTMENT
        + assets.floor_y_adjustments[
            definition.floor_shape * 5 + projection
        ]
    )
    if shelf:
        special_index = projection * 2 + subposition - 4
        # The source indexes backward from SpecialYAdjustments for the first
        # few combinations, deliberately reading the adjacent ViewY bytes.
        shelf_y_table = assets.floor_view_y + assets.floor_special_y_adjustments
        special_index += len(assets.floor_view_y)
        if not 0 <= special_index < len(shelf_y_table):
            return None
        x_value = assets.floor_special_x_positions[view_cell]
        y -= shelf_y_table[special_index]
    else:
        x_value = assets.floor_x_positions[view_cell * 4 + subposition]
    if x_value == 0x80:
        return None
    return ObjectFloorProjection(
        stack=stack,
        code=code,
        view_cell=view_cell,
        projection=projection,
        x=signed_byte(x_value),
        y=y,
        shelf=shelf,
    )

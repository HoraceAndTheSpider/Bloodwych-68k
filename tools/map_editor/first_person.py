"""Translate map cells around the cursor into source dungeon-renderer placements."""

from __future__ import annotations

from tools.dungeon_view import DungeonPlacement
from tools.map_editor.model import MapCell, TowerMap
from tools.monster_view import VIEW_CELL_COORDINATES


FACING_NAMES = ("NORTH", "EAST", "SOUTH", "WEST")
FORWARD_VECTORS = ((0, -1), (1, 0), (0, 1), (-1, 0))
RIGHT_VECTORS = ((1, 0), (0, 1), (-1, 0), (0, -1))


def dungeon_pattern_parity(x: int, y: int, facing: int) -> int:
    """Return the source renderer's alternating floor/main-wall state."""

    return (x + y + (facing & 3)) & 1


def relative_map_coordinate(
    player_x: int,
    player_y: int,
    facing: int,
    lateral: int,
    forward: int,
) -> tuple[int, int]:
    """Transform viewer-right/forward coordinates into map X/Y."""

    forward_x, forward_y = FORWARD_VECTORS[facing & 3]
    right_x, right_y = RIGHT_VECTORS[facing & 3]
    return (
        player_x + right_x * lateral + forward_x * forward,
        player_y + right_y * lateral + forward_y * forward,
    )


def move_in_view_direction(
    x: int,
    y: int,
    facing: int,
    *,
    lateral: int = 0,
    forward: int = 0,
) -> tuple[int, int]:
    """Apply WASD-style forward/strafe movement in the current view frame."""

    return relative_map_coordinate(x, y, facing, lateral, forward)


def map_cell_placement(
    cell: MapCell,
    facing: int,
    *,
    map_x: int | None = None,
    map_y: int | None = None,
) -> DungeonPlacement | None:
    """Decode one two-byte map cell into a dungeon renderer placement."""

    map_type = cell.map_type
    if map_type == 0:
        return None
    if map_type == 1:
        if cell.c < 8:
            return DungeonPlacement("stone")
        direction = ((cell.c & 3) - facing) & 3
        feature = ("shelf", "sign", "switch", "socket")[cell.b & 3]
        if feature == "shelf":
            return DungeonPlacement(feature, direction=direction, active=not bool(cell.d & 8))
        if feature == "sign":
            variants = {0x01: 0, 0x05: 1, 0x09: 2, 0x0D: 3, 0x11: 4}
            variant = variants.get(cell.first, 5)
            generated = variant in (0, 5) and map_x is not None and map_y is not None
            return DungeonPlacement(
                feature,
                direction=direction,
                variant=variant,
                colour_variant=((map_x + map_y) & 7) if generated else None,
                overlay_variant=((2 * map_x - map_y) & 3) if variant == 0 and generated else None,
            )
        if feature == "switch":
            reference = cell.first // 8
            coordinate_colour = (
                (map_x + map_y) & 7
                if reference and map_x is not None and map_y is not None
                else None
            )
            return DungeonPlacement(
                feature,
                direction=direction,
                variant=reference & 7,
                colour_variant=(-1 if reference == 0 else coordinate_colour),
                active=cell.b in (2, 10),
            )
        return DungeonPlacement(
            feature,
            direction=direction,
            variant=min(cell.first // 8, 7),
            active=cell.b in (3, 11),
        )
    if map_type == 2:
        absolute_states = tuple((cell.first >> (index * 2)) & 3 for index in range(4))
        relative_states = tuple(
            absolute_states[(direction + facing) & 3] for direction in range(4)
        )
        return DungeonPlacement("wood", wood_states=relative_states)
    if map_type == 3:
        if cell.first == 0:
            return DungeonPlacement("bed")
        if cell.first == 1:
            return DungeonPlacement("pillar")
        return None
    if map_type == 4:
        feature = "stairs_up" if cell.b & 1 == 0 else "stairs_down"
        return DungeonPlacement(feature, direction=((cell.b // 2) - facing) & 3)
    if map_type == 5:
        feature = "door_portcullis" if cell.b & 2 else "door_metal"
        return DungeonPlacement(
            feature,
            # Door axis is N/S (0) or E/W (1).  Odd relative directions select
            # the source's alternative current-cell side-on picture.
            direction=((1 if cell.b & 4 else 0) - facing) & 3,
            variant=min(cell.a, 7),
            colour_variant=(-1 if cell.b & 8 else min(cell.a, 7)),
            active=bool(cell.b & 1),
        )
    if map_type == 6:
        floor_kind = cell.b & 3
        ceiling_hole = bool(cell.b & 4)
        if floor_kind == 1:
            return DungeonPlacement("pit", ceiling_hole=ceiling_hole)
        if floor_kind == 2:
            return DungeonPlacement("pad", ceiling_hole=ceiling_hole)
        if ceiling_hole:
            return DungeonPlacement("ceiling_pit")
        return None
    magic_kind = cell.b & 3
    if magic_kind == 1:
        return DungeonPlacement("firepath", variant=(cell.first // 4) & 1)
    if magic_kind == 2:
        return DungeonPlacement("mindrock")
    if magic_kind == 3:
        return DungeonPlacement("formwall")
    return None


def map_view_placements(
    tower_map: TowerMap,
    floor: int,
    player_x: int,
    player_y: int,
    facing: int,
) -> dict[int, DungeonPlacement]:
    """Build the eighteen cells ahead plus the map cursor's current cell.

    Coordinates outside the floor are deliberately solid stone, matching the
    game's convention that map edges are sealed by opaque walls.  View cell 18
    supplies inside-cell wooden walls, stairs, doors, pads, and holes.
    """

    width, height = tower_map.widths[floor], tower_map.heights[floor]
    placements: dict[int, DungeonPlacement] = {}
    for view_cell, (lateral, relative_y) in enumerate(VIEW_CELL_COORDINATES):
        x, y = relative_map_coordinate(
            player_x,
            player_y,
            facing,
            lateral,
            -relative_y,
        )
        if not (0 <= x < width and 0 <= y < height):
            placements[view_cell] = DungeonPlacement("stone")
            continue
        placement = map_cell_placement(
            tower_map.cell(floor, x, y),
            facing,
            map_x=x,
            map_y=y,
        )
        if placement is not None:
            placements[view_cell] = placement
    return placements

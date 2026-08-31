"""Translate map cells around the cursor into source dungeon-renderer placements."""

from __future__ import annotations

from tools.dungeon_view import DungeonPlacement
from tools.map_editor.model import MapCell, MonsterRecord, TowerMap
from tools.monster_view import VIEW_CELL_COORDINATES, view_cell_at, visible_subpositions


FACING_NAMES = ("NORTH", "EAST", "SOUTH", "WEST")
FORWARD_VECTORS = ((0, -1), (1, 0), (0, 1), (-1, 0))
RIGHT_VECTORS = ((1, 0), (0, 1), (-1, 0), (0, -1))


def dungeon_pattern_parity(x: int, y: int, facing: int) -> int:
    """Return the source renderer's alternating floor/main-wall state."""

    # adrCd0090D4 adds X, Y and facing, masks bit 0, and stores -$000C(a3).
    # adrCd00B7F4 and adrCd00B074 read that same word for floor and walls.
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


def occupant_view_position(
    occupant: MonsterRecord,
    *,
    player_x: int,
    player_y: int,
    player_facing: int,
    formation_index: int | None,
) -> tuple[int, int] | None:
    """Return the source view cell and mini-space for one map occupant.

    Bits 4-5 of a raw champion or monster render-state byte select a stable
    floor mini-space. The source subtracts two and the viewer direction before
    passing that value to ``Prepare_Monster_ScreenPosition``. Large forms and
    spells occupy the centre mini-space.
    """

    if not occupant.has_position:
        return None
    dx, dy = occupant.x - player_x, occupant.y - player_y
    right_x, right_y = RIGHT_VECTORS[player_facing & 3]
    forward_x, forward_y = FORWARD_VECTORS[player_facing & 3]
    lateral = dx * right_x + dy * right_y
    forward = dx * forward_x + dy * forward_y
    view_cell = view_cell_at(lateral, forward)
    if view_cell is None:
        return None
    if occupant.form in (0x15, 0x16, 0x40) or occupant.form >= 0x67 or occupant.is_spell:
        subposition = 4
    elif formation_index is not None and occupant.formation_slot is not None:
        # Draw_DungeonCellOccupants rotates a team's table lookup by two,
        # then by viewer facing, then against the team's own rotation. Invert
        # that lookup to attach the authored member slot to a stable world
        # position instead of a fixed screen corner.
        subposition = (
            formation_index - 2 - (player_facing & 0x03) + occupant.formation_facing
        ) & 0x03
    else:
        subposition = ((occupant.facing >> 4) - 2 - player_facing) & 0x03
    if subposition not in visible_subpositions(
        view_cell,
        (4,) if subposition == 4 else (0, 1, 2, 3),
    ):
        return None
    return view_cell, subposition


def occupant_relative_facing(occupant: MonsterRecord, player_facing: int) -> int:
    """Return the source character/monster artwork-facing table index.

    At ``adrCd00A6F6`` the renderer starts with the viewer direction, adds two
    for the North/South cases, then adds the render-state byte's low direction
    bits. This shared conversion is deliberately kept as table-index arithmetic
    rather than relabelled as a compass subtraction.
    """

    viewer_direction = player_facing & 0x03
    source_adjustment = 2 if not (viewer_direction & 1) else 0
    return (viewer_direction + source_adjustment + (occupant.facing & 0x03)) & 0x03


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
        cell = tower_map.cell(floor, x, y)
        # A party cannot normally occupy a type-1 main-wall cell.  The source
        # has dedicated player-cell paths for wood, doors, stairs and pads,
        # but not for a shelf/sign/switch/socket on a wall's inner face.  The
        # permissive editor therefore seals this invalid cursor state as plain
        # stone rather than inventing an inside-facing wall-feature overlay.
        if view_cell == 18 and cell.map_type == 1:
            placements[view_cell] = DungeonPlacement("stone")
            continue
        placement = map_cell_placement(
            cell,
            facing,
            map_x=x,
            map_y=y,
        )
        if placement is not None:
            placements[view_cell] = placement
    return placements

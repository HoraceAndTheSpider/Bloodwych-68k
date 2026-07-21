"""Source-verified dungeon view and monster-position geometry.

The Bloodwych renderer does not calculate monster screen positions from a
perspective formula. It uses compact lookup tables for nineteen dungeon view
cells and five positions within each cell. This module gives those tables
names and exposes them through a small, testable API for the graphics viewer.

The table values currently mirror Bloodwych 4.39. Their source labels and
proposed extracted filenames are documented beside each constant so these can
later be loaded from the version manifest without changing viewer behaviour.
"""

from __future__ import annotations

from dataclasses import dataclass


# adrEA00B8AE, first of four player-facing blocks. Each pair is the dungeon
# X/Y delta from the player for view-cell indices 0..18.
VIEW_CELL_COORDINATES: tuple[tuple[int, int], ...] = (
    (-2, -4),
    (-1, -4),
    (-2, -3),
    (-1, -3),
    (-1, -2),
    (-1, -1),
    (-1, 0),
    (2, -4),
    (1, -4),
    (2, -3),
    (1, -3),
    (1, -2),
    (1, -1),
    (1, 0),
    (0, -4),
    (0, -3),
    (0, -2),
    (0, -1),
    (0, 0),
)

# adrB_009936 / proposed monsters/Monster_SubPosition_DepthAdjustments.positions
# Positions 0/1 are nearer to the player; positions 2/3 are the rear pair;
# position 4 is the centred position used by full-cell monsters and spells.
SUBPOSITION_DEPTH_ADJUSTMENTS = (0, 0, 1, 1, 0)

# adrB_00993B / proposed monsters/Monster_ViewCell_DepthSlots.positions
# $FF means the view cell has no monster renderer depth.
VIEW_CELL_DEPTH_SLOTS: tuple[int | None, ...] = (
    6,
    6,
    None,
    4,
    2,
    0,
    None,
    6,
    6,
    None,
    4,
    2,
    0,
    None,
    6,
    4,
    2,
    0,
    None,
)

# adrB_00994E / proposed monsters/Monster_Depth_GfxSlots.positions
DEPTH_TO_GFX_SLOT = (0, 1, 2, 3, 4, 4, 5, 5)

# adrB_009956 / proposed monsters/Monster_GfxSlot_YPositions.positions
GFX_SLOT_Y_POSITIONS = (39, 37, 36, 36, 24, 26)

# adrEA018A84 / proposed
# monsters/Monster_ViewCell_SubPosition_XPositions.positions
# Rows are view cells 0..17 and columns are subpositions 0..4. -1 is the
# renderer's $FF sentinel: that mini-space is not visible from this cell.
VIEW_CELL_SUBPOSITION_X: tuple[tuple[int, int, int, int, int], ...] = (
    (1, -1, -1, -1, -4),
    (32, 18, 21, 28, 24),
    (-1, -1, -1, -1, -1),
    (27, 4, 12, 23, 12),
    (11, -1, -6, 16, 0),
    (-8, -1, -1, 0, -15),
    (-1, -1, -1, -1, -1),
    (-1, 117, 120, -1, 122),
    (100, 87, 90, 97, 93),
    (-1, -1, -1, -1, -1),
    (114, 90, 94, 107, 100),
    (-1, 105, 104, 126, 118),
    (-1, 118, 112, -1, 126),
    (-1, -1, -1, -1, -1),
    (67, 52, 56, 64, 60),
    (69, 48, 53, 65, 58),
    (74, 43, 47, 72, 59),
    (77, 34, 40, 73, 56),
)


FORMATION_SUBPOSITIONS = (0, 1, 2, 3)
CENTRED_SUBPOSITIONS = (4,)
SUBPOSITION_NAMES = (
    "near right",
    "near left",
    "rear left",
    "rear right",
    "centre",
)


@dataclass(frozen=True)
class MonsterScreenPosition:
    """Resolved input and output of ``Prepare_Monster_ScreenPosition``."""

    view_cell: int
    subposition: int
    dungeon_x: int
    forward_distance: int
    depth_slot: int
    gfx_slot: int
    screen_x: int
    screen_y: int

    @property
    def subposition_name(self) -> str:
        return SUBPOSITION_NAMES[self.subposition]


def view_cell_at(dungeon_x: int, forward_distance: int) -> int | None:
    """Return the source view-cell index for a player-relative dungeon cell."""
    coordinate = (dungeon_x, -forward_distance)
    try:
        return VIEW_CELL_COORDINATES.index(coordinate)
    except ValueError:
        return None


def visible_subpositions(
    view_cell: int, allowed: tuple[int, ...] = FORMATION_SUBPOSITIONS
) -> tuple[int, ...]:
    """Return mini-spaces whose source X-position is not the $FF sentinel."""
    if not 0 <= view_cell < len(VIEW_CELL_SUBPOSITION_X):
        return ()
    if VIEW_CELL_DEPTH_SLOTS[view_cell] is None:
        return ()
    row = VIEW_CELL_SUBPOSITION_X[view_cell]
    return tuple(position for position in allowed if row[position] != -1)


def resolve_monster_screen_position(
    view_cell: int, subposition: int
) -> MonsterScreenPosition | None:
    """Reproduce the lookup part of ``Prepare_Monster_ScreenPosition``.

    ``None`` corresponds to the original routine returning ``d1 = -1``.
    Screen X is deliberately signed: negative values are valid clipped
    placements at the left edge of the 128-pixel game window.
    """
    if not 0 <= subposition < len(SUBPOSITION_DEPTH_ADJUSTMENTS):
        raise ValueError("subposition must be from 0 to 4")
    if not 0 <= view_cell < len(VIEW_CELL_SUBPOSITION_X):
        return None
    base_depth = VIEW_CELL_DEPTH_SLOTS[view_cell]
    screen_x = VIEW_CELL_SUBPOSITION_X[view_cell][subposition]
    if base_depth is None or screen_x == -1:
        return None
    depth_slot = base_depth + SUBPOSITION_DEPTH_ADJUSTMENTS[subposition]
    gfx_slot = DEPTH_TO_GFX_SLOT[depth_slot]
    dungeon_x, dungeon_y = VIEW_CELL_COORDINATES[view_cell]
    return MonsterScreenPosition(
        view_cell=view_cell,
        subposition=subposition,
        dungeon_x=dungeon_x,
        forward_distance=-dungeon_y,
        depth_slot=depth_slot,
        gfx_slot=gfx_slot,
        screen_x=screen_x,
        screen_y=GFX_SLOT_Y_POSITIONS[gfx_slot],
    )

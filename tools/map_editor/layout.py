"""Floor-layout and elevation checks for the Bloodwych map editor."""

from __future__ import annotations

from dataclasses import dataclass

from tools.map_editor.first_person import FORWARD_VECTORS
from tools.map_editor.model import MapCell, TowerMap


@dataclass(frozen=True)
class ElevationIssue:
    floor: int
    x: int
    y: int
    reason: str


@dataclass(frozen=True)
class StairLink:
    floor: int
    x: int
    y: int
    target_floor: int
    target_x: int
    target_y: int


def is_layout_elevation_cell(cell: MapCell) -> bool:
    """Match the AMOS Layout view's stairs/pit/ceiling-hole filter."""

    return cell.d == 4 or (
        cell.d == 6 and (cell.b % 4 == 1 or bool(cell.b & 4))
    )


def has_floor_opening(cell: MapCell) -> bool:
    return cell.d == 6 and (cell.b & 7) in (1, 5)


def has_ceiling_opening(cell: MapCell) -> bool:
    return cell.d == 6 and (cell.b & 7) >= 4


def cell_at_world(
    tower: TowerMap, floor: int, world_x: int, world_y: int
) -> tuple[int, int, MapCell] | None:
    """Resolve a layout-space coordinate through one floor's X/Y offset."""

    if not 0 <= floor < len(tower.widths) or not tower.floor_exists(floor):
        return None
    x = world_x - tower.x_offsets[floor]
    y = world_y - tower.y_offsets[floor]
    if not (0 <= x < tower.widths[floor] and 0 <= y < tower.heights[floor]):
        return None
    return x, y, tower.cell(floor, x, y)


def _matching_stair(
    tower: TowerMap, floor: int, x: int, y: int, cell: MapCell
) -> tuple[int, int, int] | None:
    stair_up = cell.b % 2 == 0
    target_floor = floor + (1 if stair_up else -1)
    source_direction = (cell.b // 2) & 3
    travel_direction = (source_direction + 2) & 3
    dx, dy = FORWARD_VECTORS[travel_direction]
    target = cell_at_world(
        tower,
        target_floor,
        tower.x_offsets[floor] + x + dx * 2,
        tower.y_offsets[floor] + y + dy * 2,
    )
    if target is None:
        return None
    target_x, target_y, target_cell = target
    if (
        target_cell.d != 4
        or (target_cell.b % 2 == 0) == stair_up
        or ((target_cell.b // 2) & 3) != travel_direction
    ):
        return None
    return target_floor, target_x, target_y


def stair_alignment_links(tower: TowerMap) -> tuple[StairLink, ...]:
    """Return each correctly paired stair relationship exactly once."""

    links: set[tuple[tuple[int, int, int], tuple[int, int, int]]] = set()
    for floor in range(len(tower.widths)):
        if not tower.floor_exists(floor):
            continue
        for y in range(tower.heights[floor]):
            for x in range(tower.widths[floor]):
                cell = tower.cell(floor, x, y)
                if cell.d != 4:
                    continue
                target = _matching_stair(tower, floor, x, y, cell)
                if target is not None:
                    links.add(tuple(sorted(((floor, x, y), target))))
    return tuple(
        StairLink(*source, *target) for source, target in sorted(links)
    )


def elevation_alignment_issues(tower: TowerMap) -> tuple[ElevationIssue, ...]:
    """Find stairs and vertical openings without their expected counterpart.

    The movement routine changes a stair's floor by one and applies the stair
    direction twice through the movement-offset table.  A matching stair is
    therefore two world cells forward, faces back toward the source stair,
    and has the opposite up/down sense.  Pits and ceiling holes share one
    world X/Y coordinate on adjacent floors.
    """

    issues = []
    for floor in range(len(tower.widths)):
        if not tower.floor_exists(floor):
            continue
        for y in range(tower.heights[floor]):
            for x in range(tower.widths[floor]):
                cell = tower.cell(floor, x, y)
                world_x = tower.x_offsets[floor] + x
                world_y = tower.y_offsets[floor] + y

                if cell.d == 4:
                    if _matching_stair(tower, floor, x, y, cell) is None:
                        issues.append(
                            ElevationIssue(
                                floor,
                                x,
                                y,
                                "STAIRS NEED OPPOSITE STAIRS TWO CELLS FORWARD",
                            )
                        )

                if has_floor_opening(cell):
                    target = cell_at_world(tower, floor - 1, world_x, world_y)
                    if target is None or not has_ceiling_opening(target[2]):
                        issues.append(
                            ElevationIssue(
                                floor,
                                x,
                                y,
                                "PIT NEEDS A CEILING HOLE DIRECTLY BELOW",
                            )
                        )
                if has_ceiling_opening(cell):
                    target = cell_at_world(tower, floor + 1, world_x, world_y)
                    if target is None or not has_floor_opening(target[2]):
                        issues.append(
                            ElevationIssue(
                                floor,
                                x,
                                y,
                                "CEILING HOLE NEEDS A PIT DIRECTLY ABOVE",
                            )
                        )
    return tuple(issues)

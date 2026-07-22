"""Procedural AMOS-style map icons for the modern map editor."""

from __future__ import annotations

from tools.map_editor.model import MapCell
from tools.st_planar_assets import GAME_PALETTE_RGB8


MAP_TYPE_NAMES = (
    "SPACE",
    "STONE WALL",
    "WOOD WALLS / DOORS",
    "MISCELLANEOUS",
    "STAIRS",
    "METAL DOOR",
    "PAD / PIT / HOLE",
    "MAGIC LOCATION",
)
DIRECTION_NAMES = ("NORTH", "EAST", "SOUTH", "WEST")


def describe_cell(cell: MapCell) -> str:
    """Return a compact plain-English description of one map cell."""

    if cell.map_type == 0:
        return "EMPTY SPACE" if cell.first == 0 else "RESERVED / OCCUPIED SPACE"
    if cell.map_type == 1:
        feature = ("SHELF", "SIGN / WALL TEXT", "SWITCH", "GEM SOCKET")[
            cell.b % 4
        ]
        direction = DIRECTION_NAMES[cell.c & 3] if cell.c >= 8 else "NO FACE"
        return f"STONE WALL: {feature}, {direction}"
    if cell.map_type == 2:
        states = ("NONE", "WALL", "OPEN DOOR", "CLOSED DOOR")
        packed = cell.first
        sides = tuple(states[(packed >> shift) & 3] for shift in (0, 2, 4, 6))
        return "WOOD: " + ", ".join(
            f"{direction[0]}={state}"
            for direction, state in zip(DIRECTION_NAMES, sides)
        )
    if cell.map_type == 3:
        return "BED" if cell.first == 0 else ("PILLAR" if cell.first == 1 else "MISC")
    if cell.map_type == 4:
        elevation = "UP" if cell.b % 2 == 0 else "DOWN"
        direction = DIRECTION_NAMES[(cell.b // 2) & 3]
        return f"STAIRS {elevation}, {direction}"
    if cell.map_type == 5:
        state = "CLOSED" if cell.b & 1 else "OPEN"
        kind = "PORTCULLIS" if cell.b & 2 else "METAL DOOR"
        axis = "EAST/WEST" if cell.b & 4 else "NORTH/SOUTH"
        return f"{kind}: {state}, {axis}"
    if cell.map_type == 6:
        names = (
            "FIZZLE",
            "FLOOR PIT",
            "TRIGGER PAD",
            "INVISIBLE PAD",
            "CEILING HOLE",
            "PIT + CEILING HOLE",
            "PAD + CEILING HOLE",
            "CEILING HOLE",
        )
        return names[cell.b & 7]
    names = ("MAGIC", "FIREPATH", "MINDROCK", "FORMWALL")
    return names[cell.b & 3]


def cell_glyph(cell: MapCell) -> tuple[str, int] | None:
    """Return the original GameFont glyph and palette index for a map cell."""

    if cell.map_type == 3 and cell.first == 0:
        return "B", 0
    if cell.map_type == 6 and cell.b & 3 == 0:
        return "F", 8
    if cell.map_type == 3 and cell.first not in (0, 1):
        return str(cell.d)[-1], 0
    return None


def draw_map_cell(surface, rectangle, cell: MapCell) -> None:
    """Draw a cell using the AMOS editor's 16x8 logical pixel geometry."""

    import pygame

    palette = GAME_PALETTE_RGB8
    left, top = rectangle.left, rectangle.top

    # The AMOS map grid advances by 16x8 logical pixels, but _DRAWICON is
    # given the inset drawable bounds INX/INY=(cell + 1,+1) and
    # OUTX/OUTY=(cell + 15,+7).  Logical Y pixels are twice as tall in the
    # modern square-pixel preview.  Keeping these exact bounds matters most
    # for wall furniture and type-6 pads/holes.
    ix, iy, ox, oy = 1, 1, 15, 7

    def rect(colour: int, x: int, y: int, width: int, height: int) -> None:
        pygame.draw.rect(
            surface,
            palette[colour],
            (left + x, top + y * 2, width, height * 2),
        )

    def line(colour: int, x1: int, y1: int, x2: int, y2: int, width: int = 1) -> None:
        pygame.draw.line(
            surface,
            palette[colour],
            (left + x1, top + y1 * 2),
            (left + x2, top + y2 * 2),
            width,
        )

    def logical_box(colour: int, x1: int, y1: int, x2: int, y2: int) -> None:
        """Draw an AMOS hires Box using 1x2 logical pixels."""

        rect(colour, x1, y1, x2 - x1 + 1, 1)
        rect(colour, x1, y2, x2 - x1 + 1, 1)
        rect(colour, x1, y1, 1, y2 - y1 + 1)
        rect(colour, x2, y1, 1, y2 - y1 + 1)

    rect(0, 0, 0, 16, 8)
    map_type = cell.map_type
    if map_type == 0:
        if cell.first:
            rect(1, ix, iy, ox - ix + 1, oy - iy + 1)
        return

    if map_type == 1:
        rect(4, ix, iy, ox - ix + 1, oy - iy + 1)
        if cell.c < 8:
            return
        feature = cell.b % 4
        colour = 9 if feature == 0 else 14
        if feature == 1:
            sign_colours = {
                0x01: 14,
                0x05: 6,
                0x09: 12,
                0x0D: 7,
                0x11: 13,
            }
            colour = sign_colours.get(cell.first, 2)
        if feature == 3:
            colour = (6, 13, 12, 7, 3, 8, 9, 10)[min(cell.first // 8, 7)] if cell.first < 0x40 else 15
        direction = cell.c & 3
        if feature < 2:
            if direction == 0:
                rect(colour, ix + 2, iy, ox - ix - 3, 4)
                if feature == 0 and cell.d & 8:
                    rect(8, ix + 3, iy, ox - ix - 5, 3)
            elif direction == 1:
                rect(colour, ox - 6, iy + 1, 7, oy - iy - 1)
                if feature == 0 and cell.d & 8:
                    rect(8, ox - 5, iy + 2, 6, oy - iy - 3)
            elif direction == 2:
                rect(colour, ix + 2, oy - 3, ox - ix - 3, 4)
                if feature == 0 and cell.d & 8:
                    rect(8, ix + 3, oy - 2, ox - ix - 5, 3)
            else:
                rect(colour, ix, iy + 1, 7, oy - iy - 1)
                if feature == 0 and cell.d & 8:
                    rect(8, ix, iy + 2, 6, oy - iy - 3)
        else:
            if feature == 2:
                if cell.first < 8:
                    colour = inner = 0
                elif cell.b in (2, 10):
                    colour = inner = 14
                elif cell.b in (6, 14):
                    colour = inner = 2
                else:
                    inner = 15
            else:
                inner = colour if cell.b in (3, 11) else 0
            if direction == 0:
                rect(colour, ix + 6, iy, 2, 3)
                rect(colour, ix + 4, iy, 6, 2)
                rect(inner, ix + 6, iy, 2, 1)
            elif direction == 1:
                rect(colour, ox - 5, iy + 3, 6, 1)
                rect(colour, ox - 3, iy + 2, 4, 3)
                rect(inner, ox - 1, iy + 3, 2, 1)
            elif direction == 2:
                rect(colour, ix + 6, oy - 2, 2, 3)
                rect(colour, ix + 4, oy - 1, 6, 2)
                rect(inner, ix + 6, oy, 2, 1)
            else:
                rect(colour, ix, iy + 3, 6, 1)
                rect(colour, ix, iy + 2, 4, 3)
                rect(inner, ix, iy + 3, 2, 1)
        return

    if map_type == 2:
        locked_colour = 12 if cell.c & 1 else 9
        for side, shift in enumerate((0, 2, 4, 6)):
            state = (cell.first >> shift) & 3
            if not state:
                continue
            colour = 9 if state == 1 else locked_colour
            if side == 0:
                rect(colour, ix, iy, ox - ix + 1, 1)
                if state == 2:
                    rect(0, ix + 4, iy, ox - ix - 7, 1)
                elif state == 3:
                    rect(11, ix + 4, iy, ox - ix - 7, 1)
            elif side == 1:
                rect(colour, ox - 1, iy, 2, oy - iy + 1)
                if state == 2:
                    rect(0, ox - 1, iy + 2, 2, oy - iy - 3)
                elif state == 3:
                    rect(11, ox - 1, iy + 2, 2, oy - iy - 3)
            elif side == 2:
                rect(colour, ix, oy, ox - ix + 1, 1)
                if state == 2:
                    rect(0, ix + 4, oy, ox - ix - 7, 1)
                elif state == 3:
                    rect(11, ix + 4, oy, ox - ix - 7, 1)
            else:
                rect(colour, ix, iy, 2, oy - iy + 1)
                if state == 2:
                    rect(0, ix, iy + 2, 2, oy - iy - 3)
                elif state == 3:
                    rect(11, ix, iy + 2, 2, oy - iy - 3)
        return

    if map_type == 3:
        if cell.first == 1:
            rect(4, ix + 4, iy + 2, ox - ix - 7, oy - iy - 3)
        else:
            rect(5, ix, iy, ox - ix + 1, oy - iy + 1)
        return

    if map_type == 4:
        colour = 3 if cell.b % 2 == 0 else 2
        direction = (cell.b // 2) & 3
        if cell.a or cell.b >= 8:
            rect(13, ix, iy, ox - ix + 1, oy - iy + 1)
            return
        if direction == 0:
            for y in (iy, iy + 2, iy + 4):
                rect(colour, ix, y, ox - ix + 1, 1)
            rect(1, ix, iy, 2, oy - iy + 1)
            rect(1, ox, iy, 1, oy - iy + 1)
            rect(1, ix, oy, ox - ix + 1, 1)
            rect(1, ix, iy, 4, 2)
            rect(1, ox - 2, iy, 3, 2)
        elif direction == 2:
            for y in (iy + 2, iy + 4, iy + 6):
                rect(colour, ix, y, ox - ix + 1, 1)
            rect(1, ix, iy, 2, oy - iy + 1)
            rect(1, ox, iy, 1, oy - iy + 1)
            rect(1, ix, iy, ox - ix + 1, 1)
            rect(1, ix, oy - 1, 4, 2)
            rect(1, ox - 2, oy - 1, 3, 2)
        elif direction == 1:
            for x in (ix + 5, ix + 9, ix + 13):
                rect(colour, x, iy, 2, oy - iy + 1)
            rect(1, ix, iy, ox - ix + 1, 1)
            rect(1, ix, oy, ox - ix + 1, 1)
            rect(1, ix, iy, 3, oy - iy + 1)
            rect(1, ox - 3, iy, 4, 2)
            rect(1, ox - 1, oy - 1, 2, 2)
        else:
            for x in (ix, ix + 4, ix + 8):
                rect(colour, x, iy, 2, oy - iy + 1)
            rect(1, ix, iy, ox - ix + 1, 1)
            rect(1, ix, oy, ox - ix + 1, 1)
            rect(1, ox - 2, iy, 3, oy - iy + 1)
            rect(1, ix, iy, 4, 2)
            rect(1, ix, oy - 1, 4, 2)
        return

    if map_type == 5:
        colour = 2 if cell.b & 2 else 4
        void_lock = bool(cell.b & 8)
        locked = bool(cell.c & 3) or void_lock
        lock = 0 if void_lock else (3, 9, 1, 6, 13, 12, 7, 14)[min(cell.a, 7)]
        if cell.b & 4:
            rect(colour, ix + 4, iy, ox - ix - 8, oy - iy + 1)
            if locked:
                rect(lock, ix + 6, iy, ox - ix - 12, oy - iy + 1)
            if (cell.b & 1) == 0:
                rect(0, ix + 4, iy + 2, ox - ix - 8, oy - iy - 3)
        else:
            rect(colour, ix, iy + 2, ox - ix + 1, oy - iy - 3)
            if locked:
                rect(lock, ix, iy + 3, ox - ix + 1, oy - iy - 5)
            if (cell.b & 1) == 0:
                rect(0, ix + 4, iy + 2, ox - ix - 7, oy - iy - 3)
        return

    if map_type == 6:
        kind = cell.b & 7
        if kind in (1, 5):
            rect(2, ix + 2, iy + 1, ox - ix - 3, oy - iy - 1)
        elif kind in (2, 6):
            rect(6, ix + 2, iy + 1, ox - ix - 3, oy - iy - 1)
        elif kind == 3:
            rect(1, ix + 2, iy + 1, ox - ix - 3, oy - iy - 1)
        if kind >= 4:
            logical_box(1, ix + 2, iy + 1, ox - 2, oy - 1)
            logical_box(1, ix + 3, iy + 1, ox - 3, oy - 1)
        return

    outer, inner = ((7, 0), (12, 0), (8, 7), (3, 8))[cell.b & 3]
    rect(outer, ix, iy, ox - ix + 1, oy - iy + 1)
    logical_box(inner, ix, iy, ox, oy)
    logical_box(inner, ix + 1, iy, ox - 1, oy)

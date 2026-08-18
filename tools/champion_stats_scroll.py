"""Native champion-statistics scroll shared by the interface and data viewers."""

from __future__ import annotations

from typing import Mapping, Sequence

from tools.gamefont_converter import glyph_pixels


CHAMPION_STATS_SCROLL_SIZE = (96, 87)
SCROLL_CAP_HEIGHT = 15
SCROLL_SIDE_HEIGHT = 57
SCROLL_SIDE_WIDTH = 16
SCROLL_MIDDLE_RECT = (16, 15, 64, 57)
SCROLL_BOTTOM_Y = 72
SCROLL_TRANSPARENT_INDEX = 15

# Click_ShowStats ($6616) divides the food byte by $C7, scales it to D2=$30,
# then calls BW_draw_bar with D4=$002F00F9 and D5=$0004004A.  D4/D5 contain
# DBRA terminal counts, hence a 48x5 bar from screen X=$F9, Y=$4A.
CHAMPION_FOOD_MAXIMUM = 0xC7
CHAMPION_FOOD_BAR_RECT = (0xF9 - 0xE0, 0x4A - 0x09, 0x30, 0x05)
# ChampionStatsScroll_TextTemplate's $FC commands use rows $03-$07, while
# ChampionStatsScroll_FoodTextTemplate uses rows $08 and $09.  Each printer
# row is eight native pixels high, so there is no extra blank scanline between
# the five statistics lines or between FOOD and its end-cap glyphs.
CHAMPION_STATS_TEXT_Y = (16, 24, 32, 40, 48)
CHAMPION_FOOD_TEXT_Y = 56
CHAMPION_FOOD_END_CAP_Y = 64


def champion_food_bar_width(food_value: int) -> int:
    """Return Click_ShowStats' source-sized food-bar fill width in pixels."""
    _, _, maximum_width, _ = CHAMPION_FOOD_BAR_RECT
    return min(maximum_width, (max(0, food_value) * maximum_width) // CHAMPION_FOOD_MAXIMUM)


def _indexed_surface(
    pygame: object,
    pixels: Sequence[Sequence[int]],
    palette: Sequence[tuple[int, int, int]],
    *,
    transparent_index: int | None = None,
) -> object:
    width = len(pixels[0]) if pixels else 0
    height = len(pixels)
    if transparent_index is None:
        data = bytes(
            channel
            for row in pixels
            for index in row
            for channel in palette[index]
        )
        return pygame.image.fromstring(data, (width, height), "RGB")
    data = bytes(
        channel
        for row in pixels
        for index in row
        for channel in (*palette[index], 0 if index == transparent_index else 255)
    )
    return pygame.image.fromstring(data, (width, height), "RGBA")


def _draw_codes(
    surface: object,
    font_data: bytes,
    codes: Sequence[int],
    x: int,
    y: int,
    colour: tuple[int, int, int],
) -> None:
    for code in codes:
        for row, values in enumerate(glyph_pixels(font_data, code & 0x7F)):
            for column, value in enumerate(values):
                if value:
                    surface.set_at((x + column, y + row), colour)
        x += 8


def _draw_text(
    surface: object,
    font_data: bytes,
    text: str,
    x: int,
    y: int,
    colour: tuple[int, int, int],
) -> None:
    _draw_codes(surface, font_data, tuple(ord(character) for character in text.upper()), x, y, colour)


def _draw_stat_segments(
    surface: object,
    font_data: bytes,
    palette: Sequence[tuple[int, int, int]],
    y: int,
    segments: Sequence[tuple[str | Sequence[int], int]],
) -> None:
    x = 16
    for value, palette_index in segments:
        codes = (
            tuple(ord(character) for character in value)
            if isinstance(value, str)
            else tuple(value)
        )
        _draw_codes(surface, font_data, codes, x, y, palette[palette_index])
        x += len(codes) * 8


def render_champion_stats_scroll(
    pygame: object,
    record: object,
    scroll_edges: Mapping[str, object],
    font_data: bytes,
    palette: Sequence[tuple[int, int, int]],
) -> object:
    """Render Draw_ChampionStats and Click_ShowStats into a 96x87 surface."""
    surface = pygame.Surface(CHAMPION_STATS_SCROLL_SIZE)
    surface.fill(palette[0])
    surface.fill(palette[3], SCROLL_MIDDLE_RECT)
    for name, position, rows in (
        ("top", (0, 0), None),
        ("bottom", (0, SCROLL_BOTTOM_Y), None),
        ("left", (0, SCROLL_CAP_HEIGHT), SCROLL_SIDE_HEIGHT),
        ("right", (80, SCROLL_CAP_HEIGHT), SCROLL_SIDE_HEIGHT),
    ):
        pixels = scroll_edges[name].pixels
        if rows is not None:
            pixels = pixels[:rows]
        surface.blit(
            _indexed_surface(
                pygame, pixels, palette, transparent_index=SCROLL_TRANSPARENT_INDEX
            ),
            position,
        )

    _draw_stat_segments(
        surface, font_data, palette, CHAMPION_STATS_TEXT_Y[0],
        (("LEVEL", 13), ((0x00, 0x01), 1), (f"{record.byte(0x00):02d}", 14)),
    )
    _draw_stat_segments(
        surface, font_data, palette, CHAMPION_STATS_TEXT_Y[1],
        (("ST", 7), (f"{record.byte(0x01):02d}", 13), ("-", 1), ("AG", 7), (f"{record.byte(0x02):02d}", 13)),
    )
    _draw_stat_segments(
        surface, font_data, palette, CHAMPION_STATS_TEXT_Y[2],
        (("IN", 7), (f"{record.byte(0x03):02d}", 13), ("-", 1), ("CH", 7), (f"{record.byte(0x04):02d}", 13)),
    )
    _draw_stat_segments(
        surface, font_data, palette, CHAMPION_STATS_TEXT_Y[3],
        (("HP", 0), (f"{record.byte(0x05):3d}", 14), ("/", 1), (f"{record.byte(0x06):2d}", 6)),
    )
    _draw_stat_segments(
        surface, font_data, palette, CHAMPION_STATS_TEXT_Y[4],
        (("VI ", 0), (f"{record.byte(0x07):2d}", 14), ("/", 1), (f"{record.byte(0x08):2d}", 6)),
    )
    _draw_text(surface, font_data, "FOOD", 32, CHAMPION_FOOD_TEXT_Y, palette[13])
    _draw_codes(surface, font_data, (0x02,), 16, CHAMPION_FOOD_END_CAP_Y, palette[4])
    _draw_codes(surface, font_data, (0x03,), 72, CHAMPION_FOOD_END_CAP_Y, palette[4])
    food_x, food_y, _, food_height = CHAMPION_FOOD_BAR_RECT
    food_width = champion_food_bar_width(record.byte(0x10))
    if food_width:
        pygame.draw.rect(surface, palette[9], (food_x, food_y, food_width, food_height))
    return surface

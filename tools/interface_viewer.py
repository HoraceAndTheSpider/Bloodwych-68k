#!/usr/bin/env python3
"""Interactive, source-led viewer/editor for the SPS 439 dungeon interface."""

from __future__ import annotations

import argparse
from pathlib import Path
import sys
from typing import Sequence

if not __package__:
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from tools.champion_data import CLASS_COLOUR_MASKS
from tools.gamefont_converter import glyph_pixels
from tools.graphics_preview import remap_template_colours
from tools.interface_data import (
    DIALOGUE_TEXT_PALETTE_INDEX,
    DUNGEON_VIEW_RECT,
    GFX_POCKETS_CHAIN_COMMAND_OFFSET,
    GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET,
    GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET,
    INTERFACE_MODES,
    INTERFACE_WIDTH,
    LARGE_AVATAR_INNER_FRAME,
    LARGE_AVATAR_PANEL_FILL,
    LARGE_AVATAR_PANEL_FRAMES,
    LARGE_AVATAR_RECT,
    PLAYER_COMPACT_STATS_COLOUR_INDICES,
    PLAYER_UI_PRIMARY_COLOUR_INDICES,
    PLAYER_UI_SECONDARY_COLOUR_INDICES,
    PLAYER_PANEL_HEIGHT,
    STATS_BAR_RECTS,
    STATS_BAR_Y_STEP,
    STATS_FRAME_FILL,
    STATS_FRAME_HORIZONTAL_LINES,
    STATS_FRAME_VERTICAL_LINES,
    InterfaceDataError,
    InterfaceHitbox,
    InterfaceMode,
    InterfaceProject,
    amiga_colour_to_rgb,
    replace_colour_nibble,
    remap_ui_template_colour,
)
from tools.st_planar_assets import GAME_PALETTE_RGB8


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DATA_ROOT = PROJECT_ROOT / "data/BLOODWYCH439-clean"
WINDOW_SIZE = (1280, 760)
PREVIEW_SCALE = 3
PREVIEW_ORIGIN = (20, 120)
PREVIEW_FRAME_HEIGHT = 120
PANEL_FRAME_Y = 8
PREVIEW_SIZE = (INTERFACE_WIDTH * PREVIEW_SCALE, PREVIEW_FRAME_HEIGHT * PREVIEW_SCALE)


class InterfaceViewerError(RuntimeError):
    pass


def _palette(dialogue_colour: tuple[int, int, int]) -> list[tuple[int, int, int]]:
    palette = list(GAME_PALETTE_RGB8)
    palette[DIALOGUE_TEXT_PALETTE_INDEX] = dialogue_colour
    return palette


def _player_ui_colours(
    player: int,
) -> tuple[tuple[int, int, int], tuple[int, int, int], tuple[int, int, int]]:
    return tuple(
        GAME_PALETTE_RGB8[indices[player]]
        for indices in (
            PLAYER_UI_PRIMARY_COLOUR_INDICES,
            PLAYER_UI_SECONDARY_COLOUR_INDICES,
            PLAYER_COMPACT_STATS_COLOUR_INDICES,
        )
    )


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


def _draw_gamefont(
    pygame: object,
    surface: object,
    font_data: bytes,
    text: str,
    x: int,
    y: int,
    colour: tuple[int, int, int],
) -> None:
    for character in text.upper():
        for row, values in enumerate(glyph_pixels(font_data, ord(character) & 0x7F)):
            for column, value in enumerate(values):
                if value:
                    surface.set_at((x + column, y + row), colour)
        x += 8


def _pockets_crop(project: InterfaceProject, offset: int, width: int, height: int):
    row_bytes = 160
    y, in_row = divmod(offset, row_bytes)
    x = in_row // 8 * 16
    return project.pockets.crop(
        f"GFX_Pockets+${offset:04X}", x, y, width, height
    )


def _draw_indexed(
    pygame: object,
    surface: object,
    pixels: Sequence[Sequence[int]],
    x: int,
    y: int,
    palette: Sequence[tuple[int, int, int]],
    *,
    transparent_index: int | None = None,
) -> None:
    surface.blit(
        _indexed_surface(
            pygame, pixels, palette, transparent_index=transparent_index
        ),
        (x, y),
    )


def _draw_bevel(
    pygame: object,
    panel: object,
    rect: tuple[int, int, int, int],
) -> None:
    x, y, width, height = rect
    pygame.draw.rect(panel, GAME_PALETTE_RGB8[2], rect)
    pygame.draw.line(panel, GAME_PALETTE_RGB8[14], (x, y), (x + width - 1, y))
    pygame.draw.line(panel, GAME_PALETTE_RGB8[14], (x, y), (x, y + height - 1))
    pygame.draw.line(
        panel,
        GAME_PALETTE_RGB8[1],
        (x, y + height - 1),
        (x + width - 1, y + height - 1),
    )
    pygame.draw.line(
        panel,
        GAME_PALETTE_RGB8[1],
        (x + width - 1, y),
        (x + width - 1, y + height - 1),
    )


def _draw_avatar_panel(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
) -> None:
    # adrCd00CCBE composes this in three independent stages.  adrCd00C0BA
    # draws the filled outer bevel first, Draw_ChampionLargeAvatar draws only
    # the 32x30 portrait, and adrCd00CCD8 adds the optional inner outline.
    fill_x, fill_y, fill_width, fill_height, fill_colour = LARGE_AVATAR_PANEL_FILL
    pygame.draw.rect(
        panel,
        palette[fill_colour],
        (fill_x, fill_y, fill_width, fill_height),
    )
    for x, y, width, height, colour in LARGE_AVATAR_PANEL_FRAMES:
        pygame.draw.rect(panel, palette[colour], (x, y, width, height), 1)

    champion = project.preview_character_ids[0]
    avatar_x, avatar_y, _, _ = LARGE_AVATAR_RECT
    _draw_indexed(
        pygame,
        panel,
        project.champions.large_avatar_pixels(champion),
        avatar_x,
        avatar_y,
        palette,
    )
    frame_x, frame_y, frame_width, frame_height, frame_colour = (
        LARGE_AVATAR_INNER_FRAME
    )
    pygame.draw.rect(
        panel,
        palette[frame_colour],
        (frame_x, frame_y, frame_width, frame_height),
        1,
    )


def _draw_fixed_dungeon_and_controls(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    player: int,
) -> None:
    panel.fill((0, 0, 0))
    dungeon_x, dungeon_y, _, _ = DUNGEON_VIEW_RECT
    _draw_indexed(
        pygame,
        panel,
        project.dungeon_preview,
        dungeon_x,
        dungeon_y,
        palette,
    )

    # The right bank is fixed while the left panel toggles. These source crops
    # reproduce the exact SPS 439 placements at $0544, $067C and $0E04.
    pygame.draw.rect(panel, GAME_PALETTE_RGB8[1], (224, 9, 96, 3))
    pygame.draw.rect(panel, GAME_PALETTE_RGB8[2], (226, 13, 94, 4))
    pygame.draw.rect(panel, primary_colour, (226, 17, 94, 9))
    name = project.champions.record(project.preview_character_ids[0]).given_name[:7]
    _draw_gamefont(pygame, panel, project.game_font, name, 238, 18, GAME_PALETTE_RGB8[13])
    pygame.draw.rect(panel, GAME_PALETTE_RGB8[2], (226, 27, 94, 3))

    status = _pockets_crop(project, 0x67C0, 64, 22)
    _draw_indexed(pygame, panel, status.pixels, 224, 33, palette)
    for icon, x in ((0x63, 288), (0x62, 304)):
        _draw_indexed(
            pygame,
            panel,
            project.pockets.icon(icon).pixels,
            x,
            33,
            palette,
            transparent_index=0,
        )

    controls_offset = 0x6800 if player == 0 else 0x67E0
    controls = _pockets_crop(project, controls_offset, 64, 31)
    _draw_indexed(pygame, panel, controls.pixels, 224, 56, palette)
    for icon, colour_mask, x, y in (
        (0x4B, CLASS_COLOUR_MASKS[0], 288, 56),
        (0x4D, CLASS_COLOUR_MASKS[1], 304, 56),
        (0x4E, CLASS_COLOUR_MASKS[3], 288, 72),
        (0x4C, CLASS_COLOUR_MASKS[2], 304, 72),
    ):
        _draw_indexed(
            pygame,
            panel,
            remap_template_colours(project.pockets.icon(icon).pixels, colour_mask),
            x,
            y,
            palette,
            transparent_index=0,
        )
    chain = _pockets_crop(project, GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET, 96, 7)
    _draw_indexed(pygame, panel, chain.pixels, 224, 89, palette)


def _draw_compact_stats_left(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    stats_colour: tuple[int, int, int],
    player: int,
) -> None:
    _draw_avatar_panel(pygame, panel, project, palette)

    # Draw_CompactStatsFrame ($7FF8) constructs this panel procedurally.
    # Constants below are the rendered extents. The source stores DBRA terminal
    # counts in the packed high words, so each count renders count + 1 pixels.
    for x, y, width, colour in STATS_FRAME_HORIZONTAL_LINES:
        pygame.draw.line(
            panel,
            palette[colour],
            (x, y),
            (x + width - 1, y),
        )
    for x, y, height, colour in STATS_FRAME_VERTICAL_LINES:
        pygame.draw.line(
            panel,
            palette[colour],
            (x, y),
            (x, y + height - 1),
        )
    fill_x, fill_y, fill_width, fill_height, fill_colour = STATS_FRAME_FILL
    pygame.draw.rect(
        panel,
        palette[fill_colour],
        (fill_x, fill_y, fill_width, fill_height),
    )
    title = _pockets_crop(project, 0x7580, 48, 6)
    _draw_indexed(pygame, panel, title.pixels, 48, 16, palette, transparent_index=0)
    for index, (x, y, width, height) in enumerate(STATS_BAR_RECTS):
        pygame.draw.rect(
            panel,
            stats_colour,
            (x, y + index * STATS_BAR_Y_STEP, width, height),
        )

    chain = _pockets_crop(project, GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET, 96, 7)
    _draw_indexed(pygame, panel, chain.pixels, 0, 89, palette)

    # Representative source states: one living champion, one dead champion,
    # and one vacant party slot. The runtime selects these from PlayerX_Data;
    # the viewer keeps the three states visible while that live record is not
    # yet an extracted editor resource.
    team_ids = project.preview_character_ids[1:]
    for state, champion, x in zip(
        ("alive", "dead", "missing"), team_ids, (0, 32, 64)
    ):
        if state == "missing":
            shield = project.champions.missing_shield()
            pixels = remap_ui_template_colour(
                shield.pixels, PLAYER_UI_SECONDARY_COLOUR_INDICES[player]
            )
        elif state == "alive":
            pixels = project.champions.shield_avatar(
                champion,
                ink15_colour=project.champions.party_shield_ink_colour(champion),
            ).pixels
        else:
            pixels = project.champions.shield_avatar(
                champion, state="dead"
            ).pixels
        _draw_indexed(
            pygame,
            panel,
            pixels,
            x,
            55,
            palette,
            transparent_index=0,
        )
def _draw_main(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    secondary_colour: tuple[int, int, int],
    stats_colour: tuple[int, int, int],
    player: int,
) -> None:
    _draw_fixed_dungeon_and_controls(
        pygame, panel, project, palette, primary_colour, player
    )
    _draw_compact_stats_left(pygame, panel, project, palette, stats_colour, player)


def _draw_inventory(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    secondary_colour: tuple[int, int, int],
    stats_colour: tuple[int, int, int],
    player: int,
) -> None:
    _draw_main(
        pygame, panel, project, palette,
        primary_colour, secondary_colour, stats_colour, player,
    )
    pygame.draw.rect(panel, (0, 0, 0), (224, 7, 96, 58))
    _draw_bevel(pygame, panel, (224, 7, 96, 58))
    _draw_gamefont(
        pygame, panel, project.game_font, "INVENTORY", 232, 12, primary_colour
    )
    for index in range(12):
        x = 224 + index % 6 * 16
        y = 32 + index // 6 * 16
        pixels = project.inventory_slot_pixels(
            0,
            index,
            ui_colour_index=PLAYER_UI_SECONDARY_COLOUR_INDICES[player],
        )
        _draw_indexed(
            pygame,
            panel,
            pixels,
            x,
            y,
            palette,
            transparent_index=0,
        )
    pygame.draw.rect(panel, primary_colour, (224, 31, 96, 33), 1)


def _draw_stats(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    secondary_colour: tuple[int, int, int],
    stats_colour: tuple[int, int, int],
    player: int,
) -> None:
    _draw_main(
        pygame, panel, project, palette,
        primary_colour, secondary_colour, stats_colour, player,
    )
    pygame.draw.rect(panel, (0, 0, 0), (224, 7, 96, 89))
    top = project.scroll_edges["top"]
    bottom = project.scroll_edges["bottom"]
    left = project.scroll_edges["left"]
    right = project.scroll_edges["right"]
    _draw_indexed(pygame, panel, top.pixels, 224, 9, palette)
    _draw_indexed(pygame, panel, left.pixels, 224, 24, palette)
    _draw_indexed(pygame, panel, right.pixels, 304, 24, palette)
    _draw_indexed(pygame, panel, bottom.pixels, 224, 82, palette)
    for row, text in enumerate(("HP  42/42", "VI  35/35", "SP  18/18", "FOOD")):
        _draw_gamefont(
            pygame,
            panel,
            project.game_font,
            text,
            232,
            28 + row * 12,
            primary_colour if row == 3 else (221, 221, 221),
        )
    pygame.draw.rect(panel, (130, 70, 25), (240, 68, 48, 4))


def _draw_spellbook(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    secondary_colour: tuple[int, int, int],
    stats_colour: tuple[int, int, int],
    player: int,
) -> None:
    _draw_main(
        pygame, panel, project, palette,
        primary_colour, secondary_colour, stats_colour, player,
    )
    pygame.draw.rect(panel, (0, 0, 0), (224, 7, 96, 89))
    book = _pockets_crop(project, 0x4100, 96, 62)
    _draw_indexed(pygame, panel, book.pixels, 224, 9, palette)
    _draw_gamefont(
        pygame, panel, project.game_font, "SPELLS", 244, 15, primary_colour
    )
    for row, text in enumerate(("A B C D", "E F G H", "I J K L", "SP 18/18")):
        _draw_gamefont(
            pygame,
            panel,
            project.game_font,
            text,
            231,
            31 + row * 10,
            (221, 221, 221),
        )
    pygame.draw.rect(panel, primary_colour, (228, 27, 42, 10), 1)


def _draw_comms(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    secondary_colour: tuple[int, int, int],
    stats_colour: tuple[int, int, int],
    player: int,
) -> None:
    _draw_fixed_dungeon_and_controls(
        pygame, panel, project, palette, primary_colour, player
    )
    pygame.draw.rect(panel, (0, 0, 0), (0, 7, 96, 89))
    _draw_avatar_panel(pygame, panel, project, palette)
    pygame.draw.line(panel, GAME_PALETTE_RGB8[2], (50, 8), (50, 55))
    pygame.draw.line(panel, GAME_PALETTE_RGB8[10], (53, 10), (53, 53))
    pygame.draw.line(panel, GAME_PALETTE_RGB8[2], (93, 8), (93, 55))
    command_icons = (
        (56, 8),
        (72, 8),
        (56, 24),
        (72, 24),
        (56, 40),
        (72, 40),
    )
    for index, (x, y) in enumerate(command_icons):
        _draw_indexed(
            pygame,
            panel,
            remap_ui_template_colour(
                project.pockets.icon(0x71 + index).pixels,
                PLAYER_UI_SECONDARY_COLOUR_INDICES[player],
            ),
            x,
            y,
            palette,
            transparent_index=0,
        )
    command_colour = GAME_PALETTE_RGB8[13]
    for row, text in enumerate(("COMMUNICATE", "COMMAND VIEW", "WAIT CORRECT", "DISMISS CALL")):
        y = 58 + row * 7
        pygame.draw.rect(panel, GAME_PALETTE_RGB8[1], (0, y, 94, 6))
        _draw_gamefont(pygame, panel, project.game_font, text, 1, y, command_colour)
    chain = _pockets_crop(project, GFX_POCKETS_CHAIN_COMMAND_OFFSET, 96, 7)
    _draw_indexed(pygame, panel, chain.pixels, 0, 89, palette)


MODE_DRAWERS = {
    "main": _draw_main,
    "inventory": _draw_inventory,
    "stats": _draw_stats,
    "spellbook": _draw_spellbook,
    "comms": _draw_comms,
}


def render_interface_panel(
    pygame: object,
    project: InterfaceProject,
    mode: InterfaceMode,
    *,
    player: int,
    alternate_ramp: bool,
    ramp_step: int,
) -> tuple[object, tuple[int, int, int]]:
    colour_word = project.colour_word(player, alternate_ramp, ramp_step)
    dialogue_colour = amiga_colour_to_rgb(colour_word)
    primary_colour, secondary_colour, stats_colour = _player_ui_colours(player)
    palette = _palette(dialogue_colour)
    panel = pygame.Surface((INTERFACE_WIDTH, PLAYER_PANEL_HEIGHT))
    MODE_DRAWERS[mode.key](
        pygame,
        panel,
        project,
        palette,
        primary_colour,
        secondary_colour,
        stats_colour,
        player,
    )
    dialogue_sample = (
        "I THINK SO, MY FRIEND"
        if alternate_ramp
        else ("THERE IS NOBODY HERE" if player == 0 else "COME INTO MY MERRY BAND")
    )
    _draw_gamefont(
        pygame,
        panel,
        project.game_font,
        dialogue_sample,
        1,
        0,
        dialogue_colour,
    )
    return panel, dialogue_colour


def frame_interface_panel(pygame: object, panel: object) -> object:
    """Place the 320x96 player-local buffer inside the observed 320x120 frame."""
    framed = pygame.Surface((INTERFACE_WIDTH, PREVIEW_FRAME_HEIGHT))
    framed.fill((0, 0, 0))
    framed.blit(panel, (0, PANEL_FRAME_Y))
    top = (
        GAME_PALETTE_RGB8[1],
        GAME_PALETTE_RGB8[2],
        GAME_PALETTE_RGB8[14],
        GAME_PALETTE_RGB8[3],
        GAME_PALETTE_RGB8[1],
        GAME_PALETTE_RGB8[0],
        GAME_PALETTE_RGB8[0],
    )
    bottom = tuple(reversed(top[:6]))
    for y, colour in enumerate(top):
        pygame.draw.line(framed, colour, (0, y), (INTERFACE_WIDTH - 1, y))
    for index, colour in enumerate(bottom):
        y = 114 + index
        pygame.draw.line(framed, colour, (0, y), (INTERFACE_WIDTH - 1, y))
    return framed


def launch_interface_viewer(
    data_root: Path | None = None,
    *,
    prefer_modified: bool = False,
    screenshot_path: Path | None = None,
    initial_mode: str = "main",
    initial_player: int = 0,
) -> None:
    try:
        import pygame
    except ImportError as error:
        raise InterfaceViewerError(
            "Pygame is required for the interface viewer/editor."
        ) from error

    try:
        project = InterfaceProject(
            data_root or DEFAULT_DATA_ROOT, prefer_modified=prefer_modified
        )
    except InterfaceDataError as error:
        raise InterfaceViewerError(str(error)) from error

    pygame.init()
    try:
        screen = pygame.display.set_mode(WINDOW_SIZE)
        pygame.display.set_caption("Bloodwych ReSource - Interface Viewer / Editor")
        title_font = pygame.font.SysFont(None, 30)
        font = pygame.font.SysFont(None, 21)
        small_font = pygame.font.SysFont(None, 17)
        tiny_font = pygame.font.SysFont(None, 14)
        clock = pygame.time.Clock()

        if initial_player not in (0, 1):
            raise InterfaceViewerError("initial player must be 0 or 1")
        try:
            selected_mode = next(
                index for index, mode in enumerate(INTERFACE_MODES) if mode.key == initial_mode
            )
        except StopIteration as error:
            raise InterfaceViewerError(f"unknown interface mode '{initial_mode}'") from error
        main_mode_index = next(
            index for index, mode in enumerate(INTERFACE_MODES) if mode.key == "main"
        )
        command_mode_index = next(
            index for index, mode in enumerate(INTERFACE_MODES) if mode.key == "comms"
        )
        player = initial_player
        show_hitboxes = False
        alternate_ramp = False
        ramp_step = 0
        selected_hitbox: InterfaceHitbox | None = None
        status = "Read-only layout; dialogue-text ramps can be saved to modified data."

        player_rects = (pygame.Rect(20, 55, 150, 34), pygame.Rect(180, 55, 150, 34))
        hitbox_toggle = pygame.Rect(1010, 55, 230, 34)
        mode_rects = tuple(
            pygame.Rect(350 + index * 128, 55, 118, 34)
            for index in range(len(INTERFACE_MODES))
        )
        preview_rect = pygame.Rect(PREVIEW_ORIGIN, PREVIEW_SIZE)
        overlay_toggle = pygame.Rect(20, 500, 190, 32)
        variant_rect = pygame.Rect(220, 500, 190, 32)
        step_down = pygame.Rect(420, 500, 34, 32)
        step_up = pygame.Rect(548, 500, 34, 32)
        save_rect = pygame.Rect(600, 500, 230, 32)
        reset_rect = pygame.Rect(840, 500, 140, 32)
        channel_buttons = {
            (channel, delta): pygame.Rect(
                45 + channel * 190 + (0 if delta < 0 else 132), 576, 42, 32
            )
            for channel in range(3)
            for delta in (-1, 1)
        }

        running = True
        first_frame = True
        while running:
            mouse = pygame.mouse.get_pos()
            mode = INTERFACE_MODES[selected_mode]
            panel, dialogue_colour = render_interface_panel(
                pygame,
                project,
                mode,
                player=player,
                alternate_ramp=alternate_ramp,
                ramp_step=ramp_step,
            )
            framed_panel = frame_interface_panel(pygame, panel)
            chrome_colour, secondary_ui_colour, stats_colour = _player_ui_colours(player)
            scaled_panel = pygame.transform.scale(framed_panel, PREVIEW_SIZE)

            screen.fill((24, 26, 31))
            screen.blit(
                title_font.render(
                    "Interface Viewer / Editor", True, (242, 243, 247)
                ),
                (20, 16),
            )
            screen.blit(scaled_panel, preview_rect)
            pygame.draw.rect(screen, (92, 96, 107), preview_rect, 2)

            for index, rect in enumerate(player_rects):
                active = player == index
                colour = chrome_colour if active else (49, 53, 62)
                pygame.draw.rect(screen, colour, rect, border_radius=4)
                label_colour = (
                    (10, 10, 12)
                    if active and sum(chrome_colour) > 220
                    else (245, 245, 248)
                )
                label = font.render(f"Player {index + 1}", True, label_colour)
                screen.blit(label, label.get_rect(center=rect.center))

            for index, rect in enumerate(mode_rects):
                active = selected_mode == index
                pygame.draw.rect(
                    screen,
                    (61, 105, 166) if active else (49, 53, 62),
                    rect,
                    border_radius=4,
                )
                label = small_font.render(
                    INTERFACE_MODES[index].label, True, (245, 245, 248)
                )
                screen.blit(label, label.get_rect(center=rect.center))

            pygame.draw.rect(
                screen,
                (126, 82, 42) if show_hitboxes else (49, 53, 62),
                hitbox_toggle,
                border_radius=4,
            )
            toggle_label = font.render(
                f"Hitboxes: {'ON' if show_hitboxes else 'OFF'} (click / H)",
                True,
                (245, 245, 248),
            )
            screen.blit(toggle_label, toggle_label.get_rect(center=hitbox_toggle.center))

            hovered_hitbox = None
            if preview_rect.collidepoint(mouse):
                native_x = (mouse[0] - preview_rect.x) // PREVIEW_SCALE
                native_y = (
                    (mouse[1] - preview_rect.y) // PREVIEW_SCALE - PANEL_FRAME_Y
                )
                hovered_hitbox = next(
                    (
                        hitbox
                        for hitbox in project.mode_hitboxes(mode)
                        if hitbox.contains(native_x, native_y)
                    ),
                    None,
                )
            if show_hitboxes:
                overlay = pygame.Surface(PREVIEW_SIZE, pygame.SRCALPHA)
                for hitbox in project.mode_hitboxes(mode):
                    rect = pygame.Rect(
                        hitbox.x_min * PREVIEW_SCALE,
                        (hitbox.y_min + PANEL_FRAME_Y) * PREVIEW_SCALE,
                        hitbox.width * PREVIEW_SCALE,
                        hitbox.height * PREVIEW_SCALE,
                    )
                    active = hitbox in (hovered_hitbox, selected_hitbox)
                    colour = (255, 214, 74, 70 if not active else 125)
                    pygame.draw.rect(overlay, colour, rect)
                    pygame.draw.rect(overlay, (255, 224, 92, 230), rect, 1)
                    number = tiny_font.render(f"{hitbox.action:02X}", True, (0, 0, 0))
                    overlay.blit(number, (rect.x + 2, rect.y + 1))
                screen.blit(overlay, preview_rect)

            info_rect = pygame.Rect(1000, 120, 260, 560)
            pygame.draw.rect(screen, (15, 17, 21), info_rect)
            pygame.draw.rect(screen, (74, 79, 91), info_rect, 2)
            y = 138
            info_lines = [
                (f"Mode: {mode.label}", (241, 241, 244)),
                (f"Fidelity: {mode.status}", (202, 174, 88)),
                (f"Player local Y: ${player * 0x60:04X}", (185, 188, 197)),
                (f"Screen bytes: ${player * 0x0F00:04X}", (185, 188, 197)),
                (f"Primary UI: ${PLAYER_UI_PRIMARY_COLOUR_INDICES[player]:X}", chrome_colour),
                (f"Secondary UI: ${PLAYER_UI_SECONDARY_COLOUR_INDICES[player]:X}", secondary_ui_colour),
                (f"Stats bars: 3 / ${PLAYER_COMPACT_STATS_COLOUR_INDICES[player]:X}", stats_colour),
                (f"Text colour 15: ${project.colour_word(player, alternate_ramp, ramp_step):04X}", dialogue_colour),
                (f"Speech: {'monster/alternate' if alternate_ramp else 'player'} / fade {ramp_step + 1}", (185, 188, 197)),
                ("", (0, 0, 0)),
                ("Source routines", (241, 241, 244)),
            ]
            for label in mode.source_labels:
                info_lines.append((f"  {label}", (170, 174, 184)))
            current_hitbox = hovered_hitbox or selected_hitbox
            if current_hitbox is not None:
                info_lines.extend(
                    (
                        ("", (0, 0, 0)),
                        (f"Action ${current_hitbox.action:02X}", (255, 216, 92)),
                        (current_hitbox.action_name, (235, 235, 239)),
                        (
                            f"X {current_hitbox.x_min}-{current_hitbox.x_max}",
                            (170, 174, 184),
                        ),
                        (
                            f"Y {current_hitbox.y_min}-{current_hitbox.y_max}",
                            (170, 174, 184),
                        ),
                        (current_hitbox.source_label, (170, 174, 184)),
                    )
                )
            for text, colour in info_lines:
                for line in (text[i : i + 32] for i in range(0, len(text), 32)) or ("",):
                    screen.blit(small_font.render(line, True, colour), (1016, y))
                    y += 18

            controls = (
                (overlay_toggle, f"Modified data: {'ON' if project.use_modified else 'OFF'}"),
                (variant_rect, f"Speech: {'MONSTER' if alternate_ramp else 'PLAYER'}"),
                (step_down, "-"),
                (step_up, "+"),
                (save_rect, "Save text-colour ramps"),
                (reset_rect, "Reload"),
            )
            for rect, text in controls:
                pygame.draw.rect(
                    screen,
                    (58, 102, 72) if rect == save_rect else (52, 61, 75),
                    rect,
                    border_radius=4,
                )
                label = small_font.render(text, True, (244, 244, 247))
                screen.blit(label, label.get_rect(center=rect.center))
            step_label = font.render(f"Step {ramp_step + 1}", True, (235, 235, 239))
            screen.blit(step_label, step_label.get_rect(center=(501, 516)))

            word = project.colour_word(player, alternate_ramp, ramp_step)
            channel_names = ("RED", "GREEN", "BLUE")
            channel_values = ((word >> 8) & 0xF, (word >> 4) & 0xF, word & 0xF)
            for channel, (name, value) in enumerate(zip(channel_names, channel_values)):
                x = 20 + channel * 190
                screen.blit(font.render(f"{name}: ${value:X}", True, (230, 232, 237)), (x, 548))
                for delta, symbol in ((-1, "-"), (1, "+")):
                    rect = channel_buttons[(channel, delta)]
                    pygame.draw.rect(screen, (52, 61, 75), rect, border_radius=4)
                    label = font.render(symbol, True, (245, 245, 248))
                    screen.blit(label, label.get_rect(center=rect.center))
            pygame.draw.rect(
                screen, dialogue_colour, (600, 563, 230, 46), border_radius=4
            )
            pygame.draw.rect(screen, (230, 232, 237), (600, 563, 230, 46), 1, border_radius=4)

            screen.blit(small_font.render(status, True, (191, 195, 204)), (20, 635))
            tail = project.pockets.trailing_data
            tail_text = (
                f"Pockets.gfx tail: {len(tail)} bytes at memory $54402-$54421 "
                f"(binary $5407E-$5409D); currently excluded from the 320x200 image."
            )
            screen.blit(tiny_font.render(tail_text, True, (202, 174, 88)), (20, 665))
            screen.blit(
                tiny_font.render(
                    "Click a highlighted rectangle to inspect its shared action-table entry.",
                    True,
                    (157, 161, 171),
                ),
                (20, 687),
            )

            pygame.display.flip()
            if screenshot_path is not None and first_frame:
                screenshot_path.parent.mkdir(parents=True, exist_ok=True)
                pygame.image.save(screen, str(screenshot_path))
                return
            first_frame = False

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN and event.key == pygame.K_h:
                    show_hitboxes = not show_hitboxes
                    selected_hitbox = None
                elif event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                    running = False
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                    if player_rects[0].collidepoint(event.pos):
                        player = 0
                    elif player_rects[1].collidepoint(event.pos):
                        player = 1
                    elif hitbox_toggle.collidepoint(event.pos):
                        show_hitboxes = not show_hitboxes
                        selected_hitbox = None
                    elif overlay_toggle.collidepoint(event.pos):
                        try:
                            project.reload(not project.use_modified)
                            status = "Reloaded the clean/modified file overlay."
                        except InterfaceDataError as error:
                            status = str(error)
                    elif variant_rect.collidepoint(event.pos):
                        alternate_ramp = not alternate_ramp
                    elif step_down.collidepoint(event.pos):
                        ramp_step = (ramp_step - 1) % 6
                    elif step_up.collidepoint(event.pos):
                        ramp_step = (ramp_step + 1) % 6
                    elif save_rect.collidepoint(event.pos):
                        destination = project.save_colour_ramps()
                        project.use_modified = True
                        status = f"Saved {destination.relative_to(PROJECT_ROOT)}"
                    elif reset_rect.collidepoint(event.pos):
                        try:
                            project.reload(project.use_modified)
                            status = "Reloaded interface resources from disk."
                        except InterfaceDataError as error:
                            status = str(error)
                    elif preview_rect.collidepoint(event.pos):
                        native_x = (event.pos[0] - preview_rect.x) // PREVIEW_SCALE
                        native_y = (
                            (event.pos[1] - preview_rect.y) // PREVIEW_SCALE
                            - PANEL_FRAME_Y
                        )
                        if mode.key == "main" and pygame.Rect(51, 10, 44, 42).collidepoint(
                            native_x, native_y
                        ):
                            selected_mode = command_mode_index
                            selected_hitbox = None
                            status = "Compact stats panel toggled to party commands."
                        elif mode.key == "comms" and pygame.Rect(
                            56, 40, 32, 16
                        ).collidepoint(native_x, native_y):
                            selected_mode = main_mode_index
                            selected_hitbox = None
                            status = "Triangle control toggled back to compact stats."
                        else:
                            selected_hitbox = next(
                                (
                                    hitbox
                                    for hitbox in project.mode_hitboxes(mode)
                                    if hitbox.contains(native_x, native_y)
                                ),
                                None,
                            )
                    else:
                        for index, rect in enumerate(mode_rects):
                            if rect.collidepoint(event.pos):
                                selected_mode = index
                                selected_hitbox = None
                                break
                        for (channel, delta), rect in channel_buttons.items():
                            if rect.collidepoint(event.pos):
                                current = project.colour_word(
                                    player, alternate_ramp, ramp_step
                                )
                                value = (
                                    (current >> ((2 - channel) * 4)) & 0xF
                                ) + delta
                                project.set_colour_word(
                                    player,
                                    alternate_ramp,
                                    ramp_step,
                                    replace_colour_nibble(current, channel, value),
                                )
                                status = "Dialogue colour changed in memory; save to create the modified resource."
                                break
            clock.tick(60)
    finally:
        pygame.quit()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("data_root", nargs="?", type=Path, default=DEFAULT_DATA_ROOT)
    parser.add_argument("--modified", action="store_true")
    parser.add_argument("--screenshot", type=Path)
    parser.add_argument("--mode", choices=tuple(mode.key for mode in INTERFACE_MODES), default="main")
    parser.add_argument("--player", type=int, choices=(1, 2), default=1)
    args = parser.parse_args()
    launch_interface_viewer(
        args.data_root,
        prefer_modified=args.modified,
        screenshot_path=args.screenshot,
        initial_mode=args.mode,
        initial_player=args.player - 1,
    )


if __name__ == "__main__":
    main()

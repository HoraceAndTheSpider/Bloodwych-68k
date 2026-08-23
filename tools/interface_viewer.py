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
from tools.champion_inventory import (
    INVENTORY_INGAME_CONTENT_RECT,
    render_empty_ingame_champion_inventory,
)
from tools.champion_stats_scroll import render_champion_stats_scroll
from tools.gamefont_converter import glyph_pixels
from tools.graphics_preview import mirror_pixels, remap_template_colours
from tools.pygame_window import is_fullscreen, set_display_mode, set_scaled_fullscreen, set_windowed
from tools.spellbook import (
    can_decrease_cast_power,
    can_increase_cast_power,
    format_spell_points,
    spell_cast_bar_width,
    spell_cast_score,
    spellbook_magic_class_index,
    spellbook_selection,
)
from tools.interface_data import (
    DIALOGUE_TEXT_PALETTE_INDEX,
    COMMUNICATION_BACKGROUND_COLOUR_INDEX,
    COMMUNICATION_DEEP_MENU_PAGES,
    communication_button_at,
    communication_button_handler,
    communication_menu_buttons,
    DUNGEON_VIEW_RECT,
    GFX_POCKETS_CHAIN_COMMAND_OFFSET,
    GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET,
    GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET,
    INTERFACE_ACTION_INVENTORY,
    INTERFACE_ACTION_INVENTORY_EXIT,
    INTERFACE_ACTION_INVENTORY_HELD_SLOT,
    INTERFACE_ACTION_INVENTORY_PARTY_MEMBER_FIRST,
    INTERFACE_ACTION_INVENTORY_PARTY_MEMBER_LAST,
    INTERFACE_ACTION_INVENTORY_SLOT_FIRST,
    INTERFACE_ACTION_INVENTORY_SLOT_LAST,
    INTERFACE_ACTION_LOAD_SAVE,
    INTERFACE_ACTION_PARTY_MEMBER_FIRST,
    INTERFACE_ACTION_PARTY_MEMBER_LAST,
    INTERFACE_ACTION_PARTY_COMMAND_MODE,
    INTERFACE_ACTION_PAUSE,
    INTERFACE_ACTION_LAUNCH_SPELL,
    INTERFACE_ACTION_VIEW_SPELL,
    INTERFACE_ACTION_SPELLBOOK_CLOSE,
    INTERFACE_ACTION_SPELLBOOK_COST_DOWN,
    INTERFACE_ACTION_SPELLBOOK_COST_UP,
    INTERFACE_ACTION_SPELLBOOK_PAGE_BACKWARD,
    INTERFACE_ACTION_SPELLBOOK_PAGE_FORWARD,
    INTERFACE_ACTION_SPELLBOOK_RUNE_FIRST,
    INTERFACE_ACTION_SPELLBOOK_RUNE_LAST,
    INTERFACE_ACTION_SLEEP_PARTY,
    INTERFACE_ACTION_SHOW_TEAM_AVATARS,
    INTERFACE_ACTION_SPELL_BOOK,
    INTERFACE_ACTION_STATS,
    INTERFACE_ACTION_STATS_SCROLL_RETURN,
    INTERFACE_MODES,
    INTERFACE_WIDTH,
    CHAMPION_NAME_PANEL_BACKGROUND,
    CHAMPION_NAME_PANEL_LOWER_BEVEL_LINES,
    CHAMPION_NAME_PANEL_NAME_BAR,
    CHAMPION_NAME_PANEL_TEXT_POSITION,
    CHAMPION_NAME_PANEL_UPPER_BEVEL_LINES,
    FULL_LENGTH_AVATAR_PREVIEW_Y_OFFSET,
    LARGE_AVATAR_INNER_FRAME,
    LARGE_AVATAR_PANEL_FILL,
    LARGE_AVATAR_PANEL_FRAMES,
    LARGE_AVATAR_RECT,
    PLAYER_COMPACT_STATS_COLOUR_INDICES,
    PLAYER_UI_PRIMARY_COLOUR_INDICES,
    PLAYER_UI_SECONDARY_COLOUR_INDICES,
    PARTY_COMMAND_ICON_DECORATION_LINES,
    PARTY_EMPTY_PROFESSION_ICON,
    PARTY_PENDING_PROFESSION_COLOUR_MASK,
    PARTY_PROFESSION_ICON_BASE,
    PARTY_PROFESSION_ICON_POSITIONS,
    PARTY_SELECTED_PROFESSION_FRAMES,
    PLAYER_PANEL_HEIGHT,
    STATS_BAR_RECTS,
    STATS_BAR_Y_STEP,
    STATS_BARS_BACKGROUND,
    STATS_FRAME_FILL,
    STATS_FRAME_HORIZONTAL_LINES,
    STATS_FRAME_VERTICAL_LINES,
    RIGHT_STATUS_ICON_BEVEL_LINES,
    active_party_champion_draw_parameters,
    body_design_with_worn_armour,
    click_party_member_preview,
    promote_preview_avatar_state,
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

# adrB_00C934, selected by Draw_SpellBookRunePage/C906 after its C6900 magic
# class calculation: Serpent green, Chaos yellow, Dragon red, Moon blue.
SPELLBOOK_MAGIC_CLASS_PALETTE_INDICES = (0x06, 0x0D, 0x0C, 0x07)


def spellbook_entry_spell_index(spread: int, entry: int) -> int:
    """Map a visible left/right spell-book entry to its absolute index."""
    if not 0 <= spread < 4:
        raise ValueError("spell-book spread must be 0..3")
    if not 0 <= entry < 8:
        raise ValueError("spell-book entry must be 0..7")
    row, side = divmod(entry, 2)
    return (spread * 2 + side) * 4 + row
DEFAULT_DATA_ROOT = PROJECT_ROOT / "data/BLOODWYCH439-clean"
WINDOW_SIZE = (1280, 760)
PREVIEW_SCALE = 3
PREVIEW_ORIGIN = (20, 120)
PREVIEW_FRAME_HEIGHT = 120
PANEL_FRAME_Y = 8
PREVIEW_SIZE = (INTERFACE_WIDTH * PREVIEW_SCALE, PREVIEW_FRAME_HEIGHT * PREVIEW_SCALE)
PAUSE_COLOUR_WORD = 0x0400
SLEEP_CLEAR_RECT = (96, 12, 128, 76)
SLEEP_FRAME_OUTER = (96, 12, 128, 76, 4)
# The sleep frame has three nested side/bottom edges but its top is compressed
# to two scanlines. Treating every nested edge as a pygame rectangle inflated
# the top to five scanlines.
SLEEP_FRAME_MIDDLE = (97, 13, 126, 74, 2)
SLEEP_FRAME_INNER = (98, 14, 124, 72, 4)


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
    *,
    uppercase: bool = True,
) -> None:
    for character in text.upper() if uppercase else text:
        for row, values in enumerate(glyph_pixels(font_data, ord(character) & 0x7F)):
            for column, value in enumerate(values):
                if value:
                    surface.set_at((x + column, y + row), colour)
        x += 8


def _draw_hitbox_id(
    pygame: object,
    surface: object,
    font_data: bytes,
    action: int,
    x: int,
    y: int,
) -> None:
    """Stamp a readable hitbox ID without blitting a font surface."""
    text = f"{action:02X}"
    _draw_gamefont(pygame, surface, font_data, text, x + 1, y + 1, (12, 14, 18))
    _draw_gamefont(pygame, surface, font_data, text, x, y, (255, 255, 255))


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

    champion = project.active_preview_champion
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


def _draw_active_party_champion(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    champion: int,
    slot: int,
) -> None:
    """Draw the selected champion with Draw_Character's slot parameters."""
    anchor_x, anchor_y, distance = active_party_champion_draw_parameters(slot)
    worn_body_armour = project.champion_pockets[champion][2]
    body_design = body_design_with_worn_armour(
        project.character_assets.body_design(champion), worn_body_armour
    )
    for component in project.character_assets.draw_operations(
        champion,
        distance=distance,
        facing=0,
        render_flags=0,
        body_design_override=body_design,
    ):
        pixels = remap_template_colours(
            component.operation.sprite.pixels, component.replacements
        )
        if component.operation.mirrored:
            pixels = mirror_pixels(pixels)
        _draw_indexed(
            pygame,
            panel,
            pixels,
            anchor_x + component.operation.x,
            anchor_y + FULL_LENGTH_AVATAR_PREVIEW_Y_OFFSET + component.operation.y,
            palette,
            transparent_index=15,
        )


def _draw_selected_main_champion(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
) -> None:
    # Refresh_PartyShieldSlotIfDirty takes this path when selected-slot bit 0
    # is set: two 16x37 Pockets.gfx decorative strips replace the portrait
    # panel and Draw_ActivePartyChampionInShield anchors the full character at
    # ($11,$1C), distance zero.
    panel.fill((0, 0, 0), (0, 10, 48, 44))
    decoration = _pockets_crop(project, 0x6500, 16, 37)
    _draw_indexed(
        pygame, panel, decoration.pixels, 0, 14, palette, transparent_index=15
    )
    _draw_indexed(
        pygame, panel, decoration.pixels, 40, 14, palette, transparent_index=15
    )
    _draw_active_party_champion(
        pygame, panel, project, palette, project.active_preview_champion, 0
    )


def _draw_champion_name_panel_top(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    champion: int,
) -> None:
    """Draw the upper `Draw_ChampionNamePanelFrame` portion for one champion."""
    background_x, background_y, background_width, _, background_colour = (
        CHAMPION_NAME_PANEL_BACKGROUND
    )
    # The lower fade finishes at Y=28.  Keeping this limited to the top frame
    # lets Click_OpenInventory retain its inventory cells at Y=29 onwards.
    pygame.draw.rect(
        panel,
        palette[background_colour],
        (background_x, background_y, background_width, 20),
    )
    for x, y, width, colour in CHAMPION_NAME_PANEL_UPPER_BEVEL_LINES:
        pygame.draw.line(panel, palette[colour], (x, y), (x + width - 1, y))
    name_x, name_y, name_width, name_height = CHAMPION_NAME_PANEL_NAME_BAR
    pygame.draw.rect(
        panel, primary_colour, (name_x, name_y, name_width, name_height)
    )
    for x, y, width, colour in CHAMPION_NAME_PANEL_LOWER_BEVEL_LINES:
        pygame.draw.line(panel, palette[colour], (x, y), (x + width - 1, y))
    name = project.champions.record(champion).given_name[:7]
    name_text_x, name_text_y = CHAMPION_NAME_PANEL_TEXT_POSITION
    _draw_gamefont(
        pygame,
        panel,
        project.game_font,
        name,
        name_text_x,
        name_text_y,
        GAME_PALETTE_RGB8[13],
    )


def _draw_fixed_dungeon_and_controls(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    player: int,
    selected_spell: int | None = None,
    cast_power: int = 0,
    show_cast_status: bool = False,
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

    # Draw_ChampionNamePanelFrame first clears the full right-side panel.  Its
    # reusable top section is also retained by Click_OpenInventory.
    background_x, background_y, background_width, background_height, background_colour = (
        CHAMPION_NAME_PANEL_BACKGROUND
    )
    pygame.draw.rect(
        panel,
        palette[background_colour],
        (background_x, background_y, background_width, background_height),
    )
    _draw_champion_name_panel_top(
        pygame,
        panel,
        project,
        palette,
        primary_colour,
        project.active_preview_champion,
    )

    status = _pockets_crop(project, 0x67C0, 64, 22)
    _draw_indexed(pygame, panel, status.pixels, 224, 33, palette)
    for x, y, width, colour in RIGHT_STATUS_ICON_BEVEL_LINES:
        pygame.draw.line(panel, palette[colour], (x, y), (x + width - 1, y))
    control_icons = ((0x63, 288), (0x62, 304))
    if selected_spell is not None:
        # Action $02 (Click_MultiFunctionButton) is the 14×14 target at
        # X=$121..$12E/Y=$22..$2F.  While a spell is loaded its normal door
        # icon at X=$120 is replaced by the selected class's coloured star.
        control_icons = ((0x64 + spellbook_selection(selected_spell).magic_class, 288), (0x62, 304))
    for icon, x in control_icons:
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
    for slot, (champion, (x, y)) in enumerate(
        zip(project.preview_party_members, PARTY_PROFESSION_ICON_POSITIONS)
    ):
        if champion is None:
            pixels = project.pockets.icon(PARTY_EMPTY_PROFESSION_ICON).pixels
        elif project.preview_champion_is_dead(champion):
            # Dead members remain in the profession-order array as valid swap
            # destinations, but the control itself has no profession icon.
            continue
        else:
            colour_mask = (
                PARTY_PENDING_PROFESSION_COLOUR_MASK
                if slot == project.pending_preview_party_slot
                else CLASS_COLOUR_MASKS[project.champions.magic_class_index(champion)]
            )
            pixels = remap_template_colours(
                project.pockets.icon(PARTY_PROFESSION_ICON_BASE + (champion & 3)).pixels,
                colour_mask,
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
    active_slot = project.preview_party_members.index(project.active_preview_champion)
    frame_x, frame_y, frame_width, frame_height = PARTY_SELECTED_PROFESSION_FRAMES[
        active_slot
    ]
    pygame.draw.rect(
        panel,
        primary_colour,
        (frame_x, frame_y, frame_width, frame_height),
        1,
    )
    chain = _pockets_crop(project, GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET, 96, 7)
    _draw_indexed(pygame, panel, chain.pixels, 224, 89, palette)
    if selected_spell is not None and show_cast_status:
        # LowerText's $EA4C stream starts with ``CAST % `` in colour $0D,
        # then writes GameFont glyphs $02/$03 around the bar. The local
        # cast_power mirrors champion byte $14 while the spell is prepared.
        _draw_gamefont(
            pygame, panel, project.game_font, "CAST % ", 96, 90, palette[0x0D]
        )
        _draw_gamefont(
            pygame, panel, project.game_font, "\x02", 152, 90, palette[0x04],
            uppercase=False,
        )
        champion = project.champions.record(project.active_preview_champion)
        score = spell_cast_score(
            selected_spell,
            champion_index=project.active_preview_champion,
            level=champion.byte(0x00),
            cooldown=champion.byte(0x15),
            pocket_items=project.champion_pockets[project.active_preview_champion],
            cast_adjustment=cast_power,
        )
        # C6736 passes x=$9F, y=$5A and five scanlines ($0004) to
        # BW_draw_bar. C8144 scales its maximum width to $34 (52 pixels),
        # deliberately running beneath the two adjacent GameFont arrows.
        bar_width = spell_cast_bar_width(score)
        if bar_width:
            pygame.draw.rect(panel, palette[0x0C], (159, 90, bar_width, 5))
        _draw_gamefont(
            pygame, panel, project.game_font, "\x03", 208, 90, palette[0x04],
            uppercase=False,
        )


def _draw_compact_stats_left(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    stats_colour: tuple[int, int, int],
    player: int,
) -> None:
    party_members = project.preview_avatar_members
    expanded_slots = project.expanded_preview_party_slots
    if 0 in expanded_slots and not project.preview_avatar_slot_is_dead(0):
        _draw_selected_main_champion(pygame, panel, project, palette)
    else:
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
    background_x, background_y, background_width, background_height, background_colour = (
        STATS_BARS_BACKGROUND
    )
    pygame.draw.rect(
        panel,
        palette[background_colour],
        (background_x, background_y, background_width, background_height),
    )
    for index, (x, y, width, height) in enumerate(STATS_BAR_RECTS):
        pygame.draw.rect(
            panel,
            stats_colour,
            (x, y + index * STATS_BAR_Y_STEP, width, height),
        )

    chain = _pockets_crop(project, GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET, 96, 7)
    _draw_indexed(pygame, panel, chain.pixels, 0, 89, palette)

    # Draw_PartyShieldSlot uses the composed shield avatar by default.  Its
    # selected-living path replaces only the clicked slot with the 32x41
    # surround at $5070 and a real Draw_Character rendering.
    for slot, champion in enumerate(party_members[1:], start=1):
        x = (slot - 1) * 32
        if champion is None:
            shield = project.champions.missing_shield()
            pixels = remap_ui_template_colour(
                shield.pixels, PLAYER_UI_SECONDARY_COLOUR_INDICES[player]
            )
            _draw_indexed(
                pygame, panel, pixels, x, 55, palette, transparent_index=0
            )
            continue
        if slot in expanded_slots and not project.preview_avatar_slot_is_dead(slot):
            selected_frame = _pockets_crop(project, 0x5070, 32, 41)
            _draw_indexed(
                pygame,
                panel,
                selected_frame.pixels,
                x,
                55,
                palette,
                transparent_index=15,
            )
            _draw_active_party_champion(
                pygame, panel, project, palette, champion, slot
            )
            continue
        pixels = project.champions.shield_avatar(
            champion,
            state="dead" if project.preview_avatar_slot_is_dead(slot) else "alive",
            ink15_colour=(
                0
                if project.preview_avatar_slot_is_dead(slot)
                else project.champions.party_shield_ink_colour(champion)
            ),
        ).pixels
        _draw_indexed(
            pygame, panel, pixels, x, 55, palette, transparent_index=0
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
    selected_spell: int | None = None,
    cast_power: int = 0,
    show_cast_status: bool = False,
) -> None:
    _draw_fixed_dungeon_and_controls(
        pygame, panel, project, palette, primary_colour, player, selected_spell,
        cast_power, show_cast_status,
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
    inventory_party_slot: int = 0,
) -> None:
    party_members = project.preview_party_members
    inspected_champion = party_members[inventory_party_slot]
    if inspected_champion is None:
        # A vacant $18(a5) slot is not a meaningful inventory record.  Keep
        # the existing page visible rather than silently treating champion 0
        # as the selection.
        inspected_champion = project.active_preview_champion
    # The name frame is the normal movement-panel frame, not the title-and-two
    # chain layout of Draw_InventoryPanel used by the selection/Data Viewer.
    _draw_champion_name_panel_top(
        pygame,
        panel,
        project,
        palette,
        primary_colour,
        inspected_champion,
    )
    inventory = render_empty_ingame_champion_inventory(
        pygame,
        pockets=project.pockets,
        font_data=project.game_font,
        record=project.champions.record(inspected_champion),
        champion=inspected_champion,
        pocket_record=project.champion_pockets[inspected_champion],
        party_members=party_members,
        selected_party_slot=inventory_party_slot,
        secondary_colour_index=PLAYER_UI_SECONDARY_COLOUR_INDICES[player],
        palette=palette,
        is_dead=project.preview_champion_is_dead,
        slot_pixels=lambda slot, object_code: (
            project.object_pocket_pixels(object_code)
            if object_code
            else project.empty_inventory_slot_pixels(
                inspected_champion,
                slot,
                ui_colour_index=PLAYER_UI_SECONDARY_COLOUR_INDICES[player],
            )
        ),
    )
    content_x, content_y, _, _ = INVENTORY_INGAME_CONTENT_RECT
    panel.blit(
        inventory,
        (224 + content_x, 7 + content_y),
        area=INVENTORY_INGAME_CONTENT_RECT,
    )


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
    pygame.draw.rect(panel, (0, 0, 0), (224, 7, 96, 89))
    panel.blit(
        render_champion_stats_scroll(
            pygame,
            project.champions.record(project.active_preview_champion),
            project.scroll_edges,
            project.game_font,
            palette,
        ),
        (224, 9),
    )


def _draw_spellbook(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    secondary_colour: tuple[int, int, int],
    stats_colour: tuple[int, int, int],
    player: int,
    *,
    spread: int,
    page_turn_frame: int | None = None,
    selected_spell: int | None = None,
    cast_power: int = 0,
) -> None:
    pygame.draw.rect(panel, (0, 0, 0), (224, 7, 96, 89))
    book = _pockets_crop(project, 0x4100, 96, 62)
    _draw_indexed(pygame, panel, book.pixels, 224, 9, palette)
    champion = project.champions.record(project.active_preview_champion)
    runes = (
        "maryhadalittlela"
        "aneeitwerraguddu"
        "tnerewanzednowte"
        "cozzitwerawuddun"
        "whyamistillhavin"
        "totypethiscrapwh"
        "ithoughtidfinish"
        "acoupleoflinesqx"
    )
    # C322 first redraws the book and then calls C86A for its current left
    # page. During phases 0--2 it puts page+3 on the right; at phase 3 it puts
    # page+1 there and follows it with C380's four rightmost-column rune
    # stamps from SpellBookRunes+$03 of page+3. This is the source's
    # deliberate visual shortcut, rather than a proportional text wipe.
    left_page = (spread % 4) * 2
    right_page = (left_page + 1) % 8
    rightmost_rune_page: int | None = None
    if page_turn_frame is not None:
        if page_turn_frame == 3:
            rightmost_rune_page = (left_page + 3) % 8
        else:
            right_page = (left_page + 3) % 8

    def rune_colour_index(spell_index: int) -> int:
        if spell_index == selected_spell:
            return 0x0E
        if not champion.has_spellbook_spell(spell_index):
            return 0x01
        return (
            SPELLBOOK_MAGIC_CLASS_PALETTE_INDICES[
                spellbook_magic_class_index(spell_index)
            ]
        )

    def rune_colour(spell_index: int) -> tuple[int, int, int]:
        return palette[rune_colour_index(spell_index)]

    for row in range(4):
        left_start = left_page * 16 + row * 4
        right_start = right_page * 16 + row * 4
        left_colour = rune_colour(left_page * 4 + row)
        right_colour = rune_colour(right_page * 4 + row)
        # Draw_SpellBookRunePage's a0 arithmetic is deliberately asymmetric:
        # the fourth left rune is one scanline higher, while the first right
        # rune is one scanline higher.  Each subsequent entry advances eight
        # scanlines ($0140 screen bytes), not ten.
        for character, x, y in zip(
            runes[left_start : left_start + 4],
            (232, 240, 248, 256),
            (26 + row * 8, 26 + row * 8, 26 + row * 8, 25 + row * 8),
        ):
            _draw_gamefont(
                pygame,
                panel,
                project.game_font,
                character,
                x,
                y,
                left_colour,
                uppercase=False,
            )
        for character, x, y in zip(
            runes[right_start : right_start + 4],
            (280, 288, 296, 304),
            (25 + row * 8, 26 + row * 8, 26 + row * 8, 26 + row * 8),
        ):
            _draw_gamefont(
                pygame,
                panel,
                project.game_font,
                character,
                x,
                y,
                right_colour,
                uppercase=False,
            )
    if rightmost_rune_page is not None:
        # D8C0 returns with a0 one byte later. Its caller's $013F increment
        # therefore totals $0140: the same X position, eight scanlines down.
        for row, y in enumerate((26, 34, 42, 50)):
            # D8C0 writes all four bitplanes, including zero pixels. Restore
            # the bare page beneath the previous glyph before our foreground-
            # only GameFont helper paints its replacement.
            bare_cell = [
                book_row[80:88]
                for book_row in book.pixels[y - 9 : y - 9 + 5]
            ]
            _draw_indexed(pygame, panel, bare_cell, 304, y, palette)
            _draw_gamefont(
                pygame,
                panel,
                project.game_font,
                runes[rightmost_rune_page * 16 + row * 4 + 3],
                304,
                y,
                rune_colour(rightmost_rune_page * 4 + row),
                uppercase=False,
            )
    if page_turn_frame is not None:
        # Four 32×56 page-turn overlays begin at GFX_Pockets+$4130. C3DE first
        # doubles the phase for the screen address, then shifts that result by
        # three for the source address: the screen advances 16 pixels while
        # the source advances 16 bytes (32 pixels) per frame. The resulting
        # 16-pixel screen overlap makes the page curl continuous. C3A6 builds
        # Buffer_Colour_Mask from page+2's four spell classes, which supplies
        # old/new rune colours for the two directions. Palette index $0F
        # remains transparent.
        turn_frame = _pockets_crop(
            project, 0x4130 + page_turn_frame * 16, 32, 56
        )
        turn_colour_page = (left_page + 2) % 8
        turn_pixels = remap_template_colours(
            turn_frame.pixels,
            tuple(
                rune_colour_index(turn_colour_page * 4 + row)
                for row in range(4)
            ),
        )
        _draw_indexed(
            pygame,
            panel,
            turn_pixels,
            240 + page_turn_frame * 16,
            9,
            palette,
            transparent_index=0x0F,
        )
    # The lower row starts at $0B5C (X=$E0/Y=$48). The four central 16-pixel
    # components are Pockets.gfx $68-$6B; grey star $4F occupies each end
    # until a selected spell supplies its coloured replacement.
    selection = (
        spellbook_selection(selected_spell, cast_power)
        if selected_spell is not None
        else None
    )
    end_star = 0x4F if selection is None else 0x64 + selection.magic_class
    pictures = (end_star, 0x68, 0x69, 0x6A, 0x6B, end_star)
    if selection is not None:
        pictures = (end_star, None, None, None, None, end_star)
    for index, picture in enumerate(pictures):
        if picture is None:
            continue
        _draw_indexed(
            pygame,
            panel,
            project.pockets.icon(picture).pixels,
            224 + index * 16,
            72,
            palette,
        )
    _draw_gamefont(
        pygame, panel, project.game_font, "SP.PTS ", 224, 90, GAME_PALETTE_RGB8[0x0B]
    )
    _draw_gamefont(
        pygame, panel, project.game_font,
        format_spell_points(champion.spell_points_current, champion.spell_points_maximum),
        280, 90, GAME_PALETTE_RGB8[0x06],
    )
    if selection is not None:
        # C66BE stamps the two class stars; C2D4/CFBC prints SpellNames and
        # C2D4/CFBC's $0BAE screen pointer resolves to X=240/Y=74 for the
        # selected name. EA36's FC (30, 10) COST anchor enters the text
        # renderer's $0050 base, resolving to X=240/Y=82. The source hitboxes
        # are independent and remain at their original positions.
        _draw_gamefont(
            pygame, panel, project.game_font, selection.name, 240, 74, palette[0x0B]
        )
        _draw_gamefont(
            pygame, panel, project.game_font, "COST", 240, 82, palette[0x0D],
        )
        _draw_gamefont(
            pygame, panel, project.game_font, "\x04", 272, 82, palette[0x0C],
            uppercase=False,
        )
        _draw_gamefont(
            pygame, panel, project.game_font, f"{selection.cost:02d}", 280, 82,
            palette[0x0D],
        )
        _draw_gamefont(
            pygame, panel, project.game_font, "\x05", 296, 82, palette[0x0C],
            uppercase=False,
        )


def _draw_comms(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
    primary_colour: tuple[int, int, int],
    secondary_colour: tuple[int, int, int],
    stats_colour: tuple[int, int, int],
    player: int,
    *,
    menu_page: int,
    hovered_button: object | None,
    selected_spell: int | None = None,
    cast_power: int = 0,
    show_cast_status: bool = False,
) -> None:
    _draw_fixed_dungeon_and_controls(
        pygame, panel, project, palette, primary_colour, player, selected_spell,
        cast_power, show_cast_status,
    )
    pygame.draw.rect(panel, (0, 0, 0), (0, 7, 96, 89))
    _draw_avatar_panel(pygame, panel, project, palette)
    for x, y, dbra_count, colour_index in PARTY_COMMAND_ICON_DECORATION_LINES:
        pygame.draw.line(
            panel,
            GAME_PALETTE_RGB8[colour_index],
            (x, y),
            (x, y + dbra_count),
        )
    command_icons = [
        (56, 8),
        (72, 8),
        (56, 24),
        (72, 24),
    ]
    if menu_page in COMMUNICATION_DEEP_MENU_PAGES:
        command_icons.extend(((56, 40), (72, 40)))
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
    for button in communication_menu_buttons(menu_page):
        pygame.draw.rect(
            panel,
            primary_colour
            if button == hovered_button
            else GAME_PALETTE_RGB8[COMMUNICATION_BACKGROUND_COLOUR_INDEX],
            (button.x_min, button.y_min, button.width, button.height),
        )
        _draw_gamefont(
            pygame,
            panel,
            project.game_font,
            button.display_text,
            button.text_x,
            button.y_min + 1,
            command_colour,
        )
    chain = _pockets_crop(project, GFX_POCKETS_CHAIN_COMMAND_OFFSET, 96, 7)
    _draw_indexed(pygame, panel, chain.pixels, 0, 89, palette)


def _draw_load_save_prompt(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
) -> None:
    """Model Click_LoadSaveGame's WriteText function-key prompt."""
    prompt = "F1 - LOAD, F2 - SAVE, F10 - EXIT"
    _draw_gamefont(pygame, panel, project.game_font, prompt, 1, 0, palette[15])


def _draw_sleep_display(
    pygame: object,
    panel: object,
    project: InterfaceProject,
    palette: Sequence[tuple[int, int, int]],
) -> None:
    """Model adrCd002734 followed by Click_SleepParty's text stream."""
    pygame.draw.rect(panel, palette[0], SLEEP_CLEAR_RECT)
    x, y, width, height, colour = SLEEP_FRAME_OUTER
    pygame.draw.rect(panel, palette[colour], (x, y, width, height), 1)
    x, y, width, height, colour = SLEEP_FRAME_MIDDLE
    pygame.draw.rect(panel, palette[colour], (x, y, width, height), 1)
    x, y, width, height, colour = SLEEP_FRAME_INNER
    pygame.draw.line(panel, palette[colour], (x, y), (x, y + height - 1))
    pygame.draw.line(
        panel,
        palette[colour],
        (x + width - 1, y),
        (x + width - 1, y + height - 1),
    )
    pygame.draw.line(
        panel,
        palette[colour],
        (x, y + height - 1),
        (x + width - 1, y + height - 1),
    )
    _draw_gamefont(pygame, panel, project.game_font, "THOU ART", 128, 32, palette[10])
    _draw_gamefont(pygame, panel, project.game_font, "ASLEEP", 136, 48, palette[10])


def _replace_colour(
    pygame: object,
    surface: object,
    source: tuple[int, int, int],
    replacement: tuple[int, int, int],
) -> None:
    """Apply a hardware-colour change to pixels already drawn into a preview."""
    pixels = pygame.PixelArray(surface)
    try:
        pixels.replace(surface.map_rgb(source), surface.map_rgb(replacement))
    finally:
        del pixels


RIGHT_MODE_DRAWERS = {
    "inventory": _draw_inventory,
    "stats": _draw_stats,
    "spellbook": _draw_spellbook,
}


def _active_mode_hitboxes(
    project: InterfaceProject,
    mode: InterfaceMode,
    *,
    comms_menu_page: int,
    right_mode_key: str = "main",
    spellbook_spread: int = 0,
    selected_spell: int | None = None,
) -> tuple[InterfaceHitbox, ...]:
    """Apply the communication and right-panel visibility rules to hitboxes."""
    if right_mode_key == "spellbook":
        # Click_ViewSpell receives every rune rectangle.  C2AC clears $13
        # when its learned-bit test fails, which restores the unselected row.
        spellbook_hitboxes = tuple(
            hitbox
            for hitbox in project.hitboxes["spellbook"]
            if selected_spell is not None
            or hitbox.action not in (
                INTERFACE_ACTION_SPELLBOOK_COST_UP,
                INTERFACE_ACTION_SPELLBOOK_COST_DOWN,
            )
        )
        # Spell-book mode occupies only the right panel; retain left-panel
        # interaction independently, just as the fixed dungeon/control bank
        # remains visible when the left UI switches to communications.
        left_hitboxes = tuple(
            hitbox for hitbox in project.mode_hitboxes(mode) if hitbox.x_max < 96
        )
        return left_hitboxes + spellbook_hitboxes
    hitboxes = tuple(
        hitbox
        for hitbox in project.mode_hitboxes(mode)
        if (
            (hitbox.action != INTERFACE_ACTION_PARTY_COMMAND_MODE
             or comms_menu_page in COMMUNICATION_DEEP_MENU_PAGES)
            and (right_mode_key == "main" or not 0x00 <= hitbox.action <= 0x0F)
        )
    )
    if right_mode_key == "stats":
        return hitboxes + project.hitboxes["stats_scroll"]
    if right_mode_key == "inventory":
        inventory_hitboxes = tuple(
            hitbox
            for hitbox in project.hitboxes["inventory"]
            if not (
                INTERFACE_ACTION_INVENTORY_PARTY_MEMBER_FIRST
                <= hitbox.action
                <= INTERFACE_ACTION_INVENTORY_PARTY_MEMBER_LAST
                and (
                    hitbox.party_slot is None
                    or (champion := project.preview_party_members[hitbox.party_slot]) is None
                    or project.preview_champion_is_dead(champion)
                )
            )
        )
        return hitboxes + inventory_hitboxes
    return hitboxes


def render_interface_panel(
    pygame: object,
    project: InterfaceProject,
    mode: InterfaceMode,
    *,
    player: int,
    alternate_ramp: bool,
    ramp_step: int,
    display_state: str | None = None,
    comms_menu_page: int = 0,
    comms_hovered_button: object | None = None,
    right_mode_key: str | None = None,
    inventory_party_slot: int = 0,
    spellbook_spread: int = 0,
    spellbook_turn_frame: int | None = None,
    selected_spell: int | None = None,
    cast_power: int = 0,
) -> tuple[object, tuple[int, int, int]]:
    colour_word = project.colour_word(player, alternate_ramp, ramp_step)
    dialogue_colour = amiga_colour_to_rgb(colour_word)
    primary_colour, secondary_colour, stats_colour = _player_ui_colours(player)
    palette = _palette(dialogue_colour)
    if display_state == "pause":
        pause_colour = amiga_colour_to_rgb(PAUSE_COLOUR_WORD)
        palette[0] = pause_colour
        palette[15] = pause_colour
        dialogue_colour = pause_colour
    panel = pygame.Surface((INTERFACE_WIDTH, PLAYER_PANEL_HEIGHT))
    left_mode_key = "comms" if mode.key == "comms" else "main"
    resolved_right_mode_key = right_mode_key or (
        mode.key if mode.key in RIGHT_MODE_DRAWERS else "main"
    )
    if left_mode_key == "comms":
        _draw_comms(
            pygame,
            panel,
            project,
            palette,
            primary_colour,
            secondary_colour,
            stats_colour,
            player,
            menu_page=comms_menu_page,
            hovered_button=comms_hovered_button,
            selected_spell=selected_spell,
            cast_power=cast_power,
            show_cast_status=resolved_right_mode_key == "spellbook",
        )
    else:
        _draw_main(
            pygame,
            panel,
            project,
            palette,
            primary_colour,
            secondary_colour,
            stats_colour,
            player,
            selected_spell,
            cast_power,
            resolved_right_mode_key == "spellbook",
        )
    if resolved_right_mode_key == "inventory":
        _draw_inventory(
            pygame,
            panel,
            project,
            palette,
            primary_colour,
            secondary_colour,
            stats_colour,
            player,
            inventory_party_slot,
        )
    elif resolved_right_mode_key == "spellbook":
        _draw_spellbook(
            pygame,
            panel,
            project,
            palette,
            primary_colour,
            secondary_colour,
            stats_colour,
            player,
            spread=spellbook_spread,
            page_turn_frame=spellbook_turn_frame,
            selected_spell=selected_spell,
            cast_power=cast_power,
        )
    elif resolved_right_mode_key in RIGHT_MODE_DRAWERS:
        RIGHT_MODE_DRAWERS[resolved_right_mode_key](
            pygame,
            panel,
            project,
            palette,
            primary_colour,
            secondary_colour,
            stats_colour,
            player,
        )
    if display_state == "load_save":
        _draw_load_save_prompt(pygame, panel, project, palette)
    elif display_state == "sleep":
        _draw_sleep_display(pygame, panel, project, palette)
    dialogue_sample = (
        "I THINK SO, MY FRIEND"
        if alternate_ramp
        else ("THERE IS NOBODY HERE" if player == 0 else "COME INTO MY MERRY BAND")
    )
    if display_state is None:
        _draw_gamefont(
            pygame,
            panel,
            project.game_font,
            dialogue_sample,
            1,
            0,
            dialogue_colour,
        )
    if display_state == "pause":
        _replace_colour(pygame, panel, (0, 0, 0), palette[0])
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
    savegame_path: Path | None = None,
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
            data_root or DEFAULT_DATA_ROOT,
            prefer_modified=prefer_modified,
            savegame_path=savegame_path,
        )
    except InterfaceDataError as error:
        raise InterfaceViewerError(str(error)) from error

    pygame.init()
    try:
        screen = set_display_mode(pygame, WINDOW_SIZE)
        pygame.display.set_caption("Bloodwych ReSource - Interface Viewer / Editor")
        fullscreen = is_fullscreen()
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
        if initial_mode in RIGHT_MODE_DRAWERS:
            selected_mode = main_mode_index
            right_mode_key = initial_mode
        else:
            right_mode_key = "main"
        player = initial_player
        show_hitboxes = False
        alternate_ramp = False
        ramp_step = 0
        selected_hitbox: InterfaceHitbox | None = None
        display_state: str | None = None
        comms_menu_page = 0
        inventory_party_slot = 0
        spellbook_spread = 0
        selected_spell: int | None = None
        cast_power = 0
        # Direction, animation start tick and the spread to reveal once the
        # page-curl overlay has finished.
        spellbook_turn: tuple[int, int, int] | None = None
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
        display_mode_rect = pygame.Rect(WINDOW_SIZE[0] - 60, 12, 50, 28)
        back_rect = pygame.Rect(20, 712, 100, 32)
        first_frame = True
        while running:
            mouse = pygame.mouse.get_pos()
            mode = INTERFACE_MODES[selected_mode]
            spellbook_turn_frame = None
            if spellbook_turn is not None:
                direction, started_at, target_spread = spellbook_turn
                elapsed = pygame.time.get_ticks() - started_at
                frame = elapsed // 180
                if frame >= 4:
                    # The positive-direction path defers PlayerX_Data+$2A
                    # until its phase counter expires. The negative path has
                    # already installed this same target at click time.
                    spellbook_spread = target_spread
                    spellbook_turn = None
                else:
                    # The original page-back action stores a negative phase.
                    # C3DE XORs that phase with $0003 before deriving both the
                    # GFX_Pockets source ($4130 + phase * 16) and destination
                    # (X=240 + phase * 16): back therefore travels phase 0→3
                    # (left to right), while forward is phase 3→0.
                    spellbook_turn_frame = frame if direction < 0 else 3 - frame
            comms_hovered_button = None
            if mode.key == "comms" and preview_rect.collidepoint(mouse):
                native_x = (mouse[0] - preview_rect.x) // PREVIEW_SCALE
                native_y = (
                    (mouse[1] - preview_rect.y) // PREVIEW_SCALE - PANEL_FRAME_Y
                )
                comms_hovered_button = communication_button_at(
                    native_x, native_y, menu_page=comms_menu_page
                )
            panel, dialogue_colour = render_interface_panel(
                pygame,
                project,
                mode,
                player=player,
                alternate_ramp=alternate_ramp,
                ramp_step=ramp_step,
                display_state=display_state,
                comms_menu_page=comms_menu_page,
                comms_hovered_button=comms_hovered_button,
                right_mode_key=right_mode_key,
                inventory_party_slot=inventory_party_slot,
                spellbook_spread=spellbook_spread,
                spellbook_turn_frame=spellbook_turn_frame,
                selected_spell=selected_spell,
                cast_power=cast_power,
            )
            framed_panel = frame_interface_panel(pygame, panel)
            chrome_colour, secondary_ui_colour, stats_colour = _player_ui_colours(player)
            scaled_panel = pygame.transform.scale(framed_panel, PREVIEW_SIZE)

            screen.fill((24, 26, 31))
            pygame.draw.rect(screen, (49, 52, 61), display_mode_rect, border_radius=4)
            mode_label = tiny_font.render("WIN" if fullscreen else "FULL", True, (245, 245, 245))
            screen.blit(mode_label, mode_label.get_rect(center=display_mode_rect.center))
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
                mode_key = INTERFACE_MODES[index].key
                active = (
                    right_mode_key == mode_key
                    if mode_key in RIGHT_MODE_DRAWERS
                    else selected_mode == index and right_mode_key == "main"
                )
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
            hovered_communication = None
            if preview_rect.collidepoint(mouse):
                native_x = (mouse[0] - preview_rect.x) // PREVIEW_SCALE
                native_y = (
                    (mouse[1] - preview_rect.y) // PREVIEW_SCALE - PANEL_FRAME_Y
                )
                hovered_hitbox = next(
                    (
                        hitbox
                        for hitbox in _active_mode_hitboxes(
                            project,
                            mode,
                            comms_menu_page=comms_menu_page,
                            right_mode_key=right_mode_key,
                            spellbook_spread=spellbook_spread,
                            selected_spell=selected_spell,
                        )
                        if hitbox.contains(native_x, native_y)
                    ),
                    None,
                )
                if mode.key == "comms":
                    hovered_communication = communication_button_at(
                        native_x, native_y, menu_page=comms_menu_page
                    )
            if show_hitboxes:
                for hitbox in _active_mode_hitboxes(
                    project,
                    mode,
                    comms_menu_page=comms_menu_page,
                    right_mode_key=right_mode_key,
                    spellbook_spread=spellbook_spread,
                    selected_spell=selected_spell,
                ):
                    rect = pygame.Rect(
                        hitbox.x_min * PREVIEW_SCALE,
                        (hitbox.y_min + PANEL_FRAME_Y) * PREVIEW_SCALE,
                        hitbox.width * PREVIEW_SCALE,
                        hitbox.height * PREVIEW_SCALE,
                    )
                    rect.move_ip(preview_rect.x, preview_rect.y)
                    active = hitbox in (hovered_hitbox, selected_hitbox)
                    # Draw directly onto the scaled preview.  In particular,
                    # do not blit an otherwise transparent full-preview
                    # surface here: some display backends replace the
                    # inventory pixels beneath that surface.
                    pygame.draw.rect(
                        screen,
                        (255, 224, 92),
                        rect,
                        2 if active else 1,
                    )
                    _draw_hitbox_id(
                        pygame,
                        screen,
                        project.game_font,
                        hitbox.action,
                        rect.x + 2,
                        rect.y + 1,
                    )
                if mode.key == "comms":
                    overlay = pygame.Surface(PREVIEW_SIZE, pygame.SRCALPHA)
                    overlay.fill((0, 0, 0, 0))
                    for button in communication_menu_buttons(comms_menu_page):
                        rect = pygame.Rect(
                            button.x_min * PREVIEW_SCALE,
                            (button.y_min + PANEL_FRAME_Y) * PREVIEW_SCALE,
                            button.width * PREVIEW_SCALE,
                            button.height * PREVIEW_SCALE,
                        )
                        active = button == hovered_communication
                        pygame.draw.rect(
                            overlay, (86, 198, 255, 70 if not active else 125), rect
                        )
                        pygame.draw.rect(overlay, (126, 218, 255, 230), rect, 1)
                        label = tiny_font.render(f"{button.word_index:02X}", True, (255, 255, 255))
                        overlay.blit(label, (rect.x + 2, rect.y + 1))
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
                        (current_hitbox.handler_name, (235, 235, 239)),
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
            pygame.draw.rect(screen, (49, 52, 61), back_rect, border_radius=4)
            back_label = tiny_font.render("BACK", True, (245, 245, 245))
            screen.blit(back_label, back_label.get_rect(center=back_rect.center))

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
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1 and display_mode_rect.collidepoint(event.pos):
                    fullscreen = not fullscreen
                    screen = set_scaled_fullscreen(pygame, WINDOW_SIZE) if fullscreen else set_windowed(pygame, WINDOW_SIZE)
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                    if back_rect.collidepoint(event.pos):
                        running = False
                    elif player_rects[0].collidepoint(event.pos):
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
                            display_state = None
                            comms_menu_page = 0
                            status = "Compact stats panel toggled to party commands."
                        elif mode.key == "comms" and (
                            command := communication_button_at(
                                native_x, native_y, menu_page=comms_menu_page
                            )
                        ) is not None:
                            selected_hitbox = None
                            if comms_menu_page == 0 and command.state == 1:
                                # The preview has no decoded live map-character record.
                                # Enter its explicit conversation-preview state without
                                # asserting that an actual target occupies the front cell.
                                # In the game, PartyCommand_Communicate reaches this
                                # branch only after Interface_CheckSelectedCellInteraction
                                # finds a valid character or monster.
                                comms_menu_page = 4
                                status = (
                                    f"{communication_button_handler(command, character_in_front=True)} preview: "
                                    "greeting branch; Recruit communication page opened."
                                )
                            elif comms_menu_page in COMMUNICATION_DEEP_MENU_PAGES:
                                status = (
                                    f"Comms action ${command.state:02X} ({command.label}) selected."
                                )
                            else:
                                status = (
                                    f"{communication_button_handler(command, character_in_front=False)}: "
                                    "command selection requested."
                                )
                        else:
                            selected_hitbox = next(
                                (
                                    hitbox
                                for hitbox in _active_mode_hitboxes(
                                    project,
                                    mode,
                                    comms_menu_page=comms_menu_page,
                                    right_mode_key=right_mode_key,
                                    spellbook_spread=spellbook_spread,
                                    selected_spell=selected_spell,
                                )
                                    if hitbox.contains(native_x, native_y)
                                ),
                                None,
                            )
                            if selected_hitbox is not None:
                                action = selected_hitbox.action
                                handler = selected_hitbox.handler_name
                                if selected_hitbox.group == "inventory":
                                    if (
                                        INTERFACE_ACTION_INVENTORY_PARTY_MEMBER_FIRST
                                        <= action
                                        <= INTERFACE_ACTION_INVENTORY_PARTY_MEMBER_LAST
                                    ):
                                        assert selected_hitbox.party_slot is not None
                                        inventory_party_slot = selected_hitbox.party_slot
                                        inspected = project.preview_party_members[inventory_party_slot]
                                        selected_hitbox = None
                                        if (
                                            inspected is None
                                            or project.preview_champion_is_dead(inspected)
                                        ):
                                            # The active-hitbox filter prevents this in
                                            # normal use; retain the guard for any
                                            # programmatic hitbox activation.
                                            status = "Vacant or dead inventory party target ignored."
                                        else:
                                            status = (
                                                f"Inventory party slot {inventory_party_slot + 1} selected; "
                                                "that champion's empty pocket layout is now displayed."
                                            )
                                    elif action == INTERFACE_ACTION_INVENTORY_EXIT:
                                        right_mode_key = "main"
                                        selected_hitbox = None
                                        status = (
                                            "Inventory dismissed; normal name and walking controls restored."
                                        )
                                    elif action == INTERFACE_ACTION_INVENTORY_HELD_SLOT:
                                        selected_hitbox = None
                                        status = (
                                            "Held-item pocket selected; object pickup/drop handling is not yet overlaid."
                                        )
                                    elif (
                                        INTERFACE_ACTION_INVENTORY_SLOT_FIRST
                                        <= action
                                        <= INTERFACE_ACTION_INVENTORY_SLOT_LAST
                                    ):
                                        selected_hitbox = None
                                        slot = action - INTERFACE_ACTION_INVENTORY_SLOT_FIRST
                                        status = (
                                            f"Inventory slot {slot + 1} selected; object pickup/drop handling is not yet overlaid."
                                        )
                                elif selected_hitbox.group == "spellbook":
                                    if action == INTERFACE_ACTION_LAUNCH_SPELL:
                                        if selected_spell is None:
                                            status = "No spell is loaded to cast."
                                        else:
                                            status = (
                                                f"{spellbook_selection(selected_spell, cast_power).name} "
                                                "cast requested."
                                            )
                                    elif action == INTERFACE_ACTION_VIEW_SPELL:
                                        if selected_spell is None:
                                            status = "No spell is loaded to view."
                                        else:
                                            status = (
                                                f"Viewing {spellbook_selection(selected_spell, cast_power).name}; "
                                                "description panel remains to be added."
                                            )
                                    elif action == INTERFACE_ACTION_SPELLBOOK_COST_UP:
                                        if selected_spell is not None and can_increase_cast_power(
                                            selected_spell, cast_power
                                        ):
                                            cast_power += 1
                                            status = f"Cast power increased to {cast_power}."
                                        else:
                                            status = "Cast power cannot raise the spell cost above 99."
                                    elif action == INTERFACE_ACTION_SPELLBOOK_COST_DOWN:
                                        if selected_spell is not None and can_decrease_cast_power(
                                            selected_spell, cast_power
                                        ):
                                            cast_power -= 1
                                            status = f"Cast power decreased to {cast_power}."
                                        else:
                                            status = "Cast power cannot lower the spell cost below 1."
                                    elif action == INTERFACE_ACTION_SPELLBOOK_CLOSE:
                                        right_mode_key = "main"
                                        selected_hitbox = None
                                        status = "Spell book closed; normal name and walking controls restored."
                                    elif action == INTERFACE_ACTION_SPELLBOOK_PAGE_BACKWARD:
                                        if spellbook_turn is None:
                                            target_spread = (spellbook_spread - 1) % 4
                                            # C6D8 handles this direction by
                                            # decrementing PlayerX_Data+$2A
                                            # before it seeds $E with $8003.
                                            # C322 therefore renders the new
                                            # left-page index during the curl.
                                            spellbook_spread = target_spread
                                            spellbook_turn = (
                                                -1,
                                                pygame.time.get_ticks(),
                                                target_spread,
                                            )
                                            status = (
                                                f"{handler}: turning to spell-book spread "
                                                f"{target_spread + 1}."
                                            )
                                    elif action == INTERFACE_ACTION_SPELLBOOK_PAGE_FORWARD:
                                        if spellbook_turn is None:
                                            target_spread = (spellbook_spread + 1) % 4
                                            spellbook_turn = (
                                                1,
                                                pygame.time.get_ticks(),
                                                target_spread,
                                            )
                                            status = (
                                                f"{handler}: turning to spell-book spread "
                                                f"{target_spread + 1}."
                                            )
                                    elif (
                                        INTERFACE_ACTION_SPELLBOOK_RUNE_FIRST
                                        <= action
                                        <= INTERFACE_ACTION_SPELLBOOK_RUNE_LAST
                                    ):
                                        entry = action - INTERFACE_ACTION_SPELLBOOK_RUNE_FIRST
                                        spell = spellbook_entry_spell_index(
                                            spellbook_spread, entry
                                        )
                                        champion = project.champions.record(
                                            project.active_preview_champion
                                        )
                                        if champion.has_spellbook_spell(spell):
                                            selected_spell = spell
                                            cast_power = 0
                                            selection = spellbook_selection(spell, cast_power)
                                            status = (
                                                f"{selection.name} selected; "
                                                f"cost {selection.cost:02d} spell points."
                                            )
                                        else:
                                            # Click_ViewSpell calls C2AC for every
                                            # rune hitbox. Its failed btst path
                                            # writes $FF to champion byte $13,
                                            # removing the loaded spell.
                                            selected_spell = None
                                            cast_power = 0
                                            status = "Unavailable spell selected; spell slot cleared."
                                elif action == INTERFACE_ACTION_STATS_SCROLL_RETURN:
                                    right_mode_key = "main"
                                    selected_hitbox = None
                                    status = (
                                        "Statistics scroll dismissed; normal name and movement panel restored."
                                    )
                                elif selected_hitbox.group == "avatars":
                                    slot = selected_hitbox.party_slot
                                    if slot is None:
                                        project.expanded_preview_party_slots.clear()
                                        status = (
                                            f"{handler}: compact statistics display restored."
                                        )
                                    else:
                                        if slot in project.expanded_preview_party_slots:
                                            project.expanded_preview_party_slots.remove(slot)
                                            status = (
                                                f"{handler}: compact avatar restored for party slot {slot + 1}."
                                            )
                                        else:
                                            project.expanded_preview_party_slots.add(slot)
                                            status = (
                                                f"{handler}: full-length avatar enabled for party slot {slot + 1}."
                                            )
                                elif action == INTERFACE_ACTION_STATS:
                                    right_mode_key = "stats"
                                    display_state = None
                                    status = f"{handler}: statistics display opened."
                                elif action == INTERFACE_ACTION_INVENTORY:
                                    right_mode_key = "inventory"
                                    display_state = None
                                    inventory_party_slot = 0
                                    status = f"{handler}: inventory display opened."
                                elif (
                                    INTERFACE_ACTION_PARTY_MEMBER_FIRST
                                    <= action
                                    <= INTERFACE_ACTION_PARTY_MEMBER_LAST
                                ):
                                    previous_party_members = project.preview_party_members
                                    previous_pending_slot = project.pending_preview_party_slot
                                    previous_leader = project.active_preview_champion
                                    clicked_slot = (
                                        action - INTERFACE_ACTION_PARTY_MEMBER_FIRST
                                    )
                                    clicked_champion = previous_party_members[clicked_slot]
                                    (
                                        project.preview_party_members,
                                        project.pending_preview_party_slot,
                                        project.active_preview_champion,
                                    ) = click_party_member_preview(
                                        project.preview_party_members,
                                        project.pending_preview_party_slot,
                                        project.active_preview_champion,
                                        action,
                                        blocked_leader_ids=project.preview_dead_champion_ids,
                                    )
                                    if project.preview_party_members == previous_party_members and (
                                        project.pending_preview_party_slot
                                        == previous_pending_slot
                                    ):
                                        if project.preview_champion_is_dead(clicked_champion):
                                            status = (
                                                f"{handler}: dead party member cannot become lead; "
                                                "select a living member first to swap into this position."
                                            )
                                        else:
                                            status = (
                                                f"{handler}: vacant party slot; "
                                                "the source routine leaves the current selection unchanged."
                                            )
                                    elif project.pending_preview_party_slot is not None:
                                        status = (
                                            f"{handler}: party slot {project.pending_preview_party_slot + 1} "
                                            "selected; click it again to make that champion current."
                                        )
                                    elif previous_pending_slot == (
                                        clicked_slot
                                    ):
                                        project.preview_avatar_state_bytes = (
                                            promote_preview_avatar_state(
                                                project.preview_avatar_state_bytes,
                                                previous_leader,
                                                project.active_preview_champion,
                                            )
                                        )
                                        status = (
                                            f"{handler}: champion made current; "
                                            "the profession frame and left avatar slots were refreshed."
                                        )
                                    else:
                                        status = (
                                            f"{handler}: party positions swapped; "
                                            "selection cancelled as in the source routine."
                                        )
                                elif action == INTERFACE_ACTION_SPELL_BOOK:
                                    right_mode_key = "spellbook"
                                    display_state = None
                                    spellbook_spread = 0
                                    spellbook_turn = None
                                    status = f"{handler}: spell-book display opened."
                                elif action == INTERFACE_ACTION_PAUSE:
                                    display_state = None if display_state == "pause" else "pause"
                                    status = f"{handler}: pause simulated; the viewer remains responsive."
                                elif action == INTERFACE_ACTION_LOAD_SAVE:
                                    display_state = "load_save"
                                    status = f"{handler}: load/save function-key text displayed."
                                elif action == INTERFACE_ACTION_SLEEP_PARTY:
                                    # Click_SleepParty resets $0042(a5) and $0040(a5)
                                    # to $FFFF before it redraws the party-command
                                    # interface and normal champion-name panel.
                                    selected_mode = main_mode_index
                                    right_mode_key = "main"
                                    comms_menu_page = 0
                                    display_state = "sleep"
                                    project.expanded_preview_party_slots.clear()
                                    status = (
                                        f"{handler}: compact stats and the normal name/control "
                                        "panel restored; dungeon cleared for THOU ART ASLEEP."
                                    )
                                elif action == INTERFACE_ACTION_PARTY_COMMAND_MODE:
                                    comms_menu_page = 5 if comms_menu_page == 4 else 4
                                    status = (
                                        f"{handler}: switched to "
                                        f"{'Trading' if comms_menu_page == 5 else 'Recruit'} page."
                                    )
                                elif action == INTERFACE_ACTION_SHOW_TEAM_AVATARS:
                                    selected_mode = main_mode_index
                                    right_mode_key = "main"
                                    display_state = None
                                    comms_menu_page = 0
                                    status = f"{handler}: compact stats display restored."
                                else:
                                    status = f"{handler}: action selected."
                    else:
                        for index, rect in enumerate(mode_rects):
                            if rect.collidepoint(event.pos):
                                selected_key = INTERFACE_MODES[index].key
                                if selected_key in RIGHT_MODE_DRAWERS:
                                    right_mode_key = selected_key
                                    if selected_key == "inventory":
                                        inventory_party_slot = 0
                                else:
                                    selected_mode = index
                                    right_mode_key = "main"
                                selected_hitbox = None
                                display_state = None
                                if selected_key != "comms":
                                    comms_menu_page = 0
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
    parser.add_argument(
        "--savegame",
        type=Path,
        help="overlay a WHDLoad save over extracted resources",
    )
    parser.add_argument("--screenshot", type=Path)
    parser.add_argument("--mode", choices=tuple(mode.key for mode in INTERFACE_MODES), default="main")
    parser.add_argument("--player", type=int, choices=(1, 2), default=1)
    args = parser.parse_args()
    launch_interface_viewer(
        args.data_root,
        prefer_modified=args.modified,
        savegame_path=args.savegame,
        screenshot_path=args.screenshot,
        initial_mode=args.mode,
        initial_player=args.player - 1,
    )


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Pygame viewer/editor for extracted Bloodwych tower maps."""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Sequence

from tools.data_overlay import DataOverlayPath
from tools.dungeon_view import (
    DungeonAssets,
    load_dungeon_background,
    render_dungeon_scene,
)
from tools.gamefont_converter import glyph_pixels, read_font
from tools.map_editor.first_person import (
    FACING_NAMES,
    FORWARD_VECTORS,
    dungeon_pattern_parity,
    map_view_placements,
    move_in_view_direction,
    occupant_relative_facing,
    occupant_view_position,
    relative_map_coordinate,
)
from tools.map_editor.floor_objects import (
    cycle_object_stack_index,
    named_key_colour_indices,
    object_marker_offset,
    object_position_name,
    object_stack_indices_at_cell,
    object_stack_location,
    object_stack_positions,
    project_floor_object,
    relocate_object_stack,
)
from tools.map_editor.actor_editor import (
    MONSTER_TYPE_NAMES,
    champion_edit_allowed,
    cycle_monster_index,
    indexed_action_value,
    monster_form_name,
    monster_indices_at_cell,
    monster_teams,
)
from tools.map_editor.model import (
    ChampionMapRecord,
    MapCell,
    MapProject,
    MonsterRecord,
    ObjectStack,
    TOWERS,
    resolve_contiguous_reference,
)
from tools.map_editor.layout import (
    elevation_alignment_issues,
    is_layout_elevation_cell,
    stair_alignment_links,
)
from tools.map_editor.render import MAP_TYPE_NAMES, cell_glyph, describe_cell, draw_map_cell
from tools.map_editor.semantics import (
    SWITCH_ACTIONS,
    TRIGGER_ACTIONS,
    TRIGGER_DESTINATION_ACTIONS,
    TRIGGER_FLOOR_ACTIONS,
    TRIGGER_XY_ACTIONS,
    CellEditorRow,
    adjust_trigger_parameter,
    apply_cell_action,
    editor_rows_for_cell,
    trigger_parameter_label,
)
from tools.pygame_window import is_fullscreen, set_display_mode, set_scaled_fullscreen, set_windowed
from tools.tool_common import DATA_DIR
from tools.st_planar_assets import GAME_PALETTE_RGB8
from tools.graphics_preview import (
    AirbourneSpellAssets,
    CharacterAssets,
    blit,
    render_airbourne_spell,
    render_character_preview,
)
from tools.graphics_viewer import (
    MONSTERS,
    load_renderer_assets,
    render_champion_spellbook_preview,
    render_large_champion_avatar_panel,
    render_monster_preview,
)
from tools.champion_data import ChampionAssets, ChampionRecord
from tools.champion_inventory import render_empty_champion_inventory
from tools.champion_stats_scroll import render_champion_stats_scroll
from tools.interface_data import body_design_with_worn_armour
from tools.spellbook import SPELL_NAMES
from tools.monster_view import VIEW_CELL_COORDINATES, resolve_monster_screen_position
from tools.object_data import ObjectAssets


WINDOW_SIZE = (1220, 760)
MAP_ORIGIN = (270, 110)
MAP_SIZE = 512
CELL_SIZE = 16
MAP_GRID_CELLS = MAP_SIZE // CELL_SIZE
ZOOM_LEVELS = (1, 2, 3, 4)
CURSOR_COLOURS = (
    (255, 255, 255),
    (255, 80, 70),
    (255, 220, 70),
    (80, 235, 110),
    (70, 220, 245),
    (100, 130, 255),
    (235, 90, 240),
)
CONTROL_REPEAT_DELAY_MS = 450
CONTROL_REPEAT_INTERVAL_MS = 110
EDITOR_TABS = ("VIEWER", "MAPS", "OBJECTS", "CHARACTERS / MONSTERS", "LAYOUT")
EDITOR_TAB_ENABLED = (True, True, True, True, True)
OVERLAY_NAMES = (
    "SWITCHES",
    "TRIGGERS",
    "CHAMPIONS",
    "MONSTERS",
    "SPELLS",
    "PLAYERS",
    "QS TEAMS",
    "OBJECTS",
    "LINKS",
)
OVERLAY_ENABLED = (True, True, True, True, True, True, True, True, True)
# Keep the map uncluttered until the user explicitly asks for a class of
# information. The controls remain available even though their editors are
# not yet enabled.
OVERLAY_DEFAULTS = (False,) * len(OVERLAY_NAMES)
FIRST_PERSON_SCALE = 3
FIRST_PERSON_RECT = (810, 432, 128 * FIRST_PERSON_SCALE, 76 * FIRST_PERSON_SCALE)
LARGE_MONSTER_GRADE_TABLES = {
    0x64: "summon.colours",
    0x65: "summon.colours",
    0x66: "beholder.colours",
    0x67: "behemoth.colours",
    0x68: "crab.colours",
    0x69: "dragon.colours",
    0x6A: "dragon.colours",
}
# Five representative grid-depth previews. Source gfx slot 3 is the rear
# mini-position at the same two-grid-space range as slot 2, so the compact
# design strip uses one representative there and retains both distant slots.
MONSTER_DESIGN_PREVIEW_DISTANCES = (0, 1, 2, 4, 5)


class MapEditorError(RuntimeError):
    """Raised when the map editor cannot load its required data."""


def monster_renderer_key(renderer: str | None) -> str:
    """Return the loaded-asset key for a monster definition renderer."""

    return {
        "dragon_large": "dragon",
        "dragon_small": "dragon",
    }.get(renderer, renderer or "")


def champion_occupant_record(champion: ChampionMapRecord) -> MonsterRecord:
    """Convert one map champion without losing either half of byte $18."""

    return MonsterRecord(
        index=champion.index,
        category=0,
        floor=champion.floor,
        x=champion.x,
        y=champion.y,
        level=0,
        form=champion.index,
        team=0xFF,
        source="champion",
        facing=champion.facing,
        formation_slot=champion.formation_slot,
    )


def reveal_interval_delta(
    item_start: int,
    item_end: int,
    viewport_start: int,
    viewport_end: int,
) -> int:
    """Return the smallest translation that fully reveals an interval."""

    if item_start < viewport_start:
        return viewport_start - item_start
    if item_end > viewport_end:
        return viewport_end - item_end
    return 0


def nearest_rectangle_edges(
    source: tuple[int, int, int, int],
    target: tuple[int, int, int, int],
) -> tuple[tuple[int, int], tuple[int, int]]:
    """Join the midpoint of each rectangle's most relevant opposing sides."""

    source_left, source_top, source_width, source_height = source
    target_left, target_top, target_width, target_height = target
    source_right = source_left + source_width - 1
    source_bottom = source_top + source_height - 1
    target_right = target_left + target_width - 1
    target_bottom = target_top + target_height - 1

    source_centre = (source_left + source_width // 2, source_top + source_height // 2)
    target_centre = (target_left + target_width // 2, target_top + target_height // 2)
    delta_x = target_centre[0] - source_centre[0]
    delta_y = target_centre[1] - source_centre[1]
    if abs(delta_x) >= abs(delta_y):
        source_x = source_right if delta_x >= 0 else source_left
        target_x = target_left if delta_x >= 0 else target_right
        return (source_x, source_centre[1]), (target_x, target_centre[1])
    source_y = source_bottom if delta_y >= 0 else source_top
    target_y = target_top if delta_y >= 0 else target_bottom
    return (source_centre[0], source_y), (target_centre[0], target_y)


def indexed_to_surface(pygame: object, pixels: Sequence[Sequence[int]]) -> object:
    """Convert an indexed Bloodwych image to a Pygame RGB surface."""

    width = len(pixels[0]) if pixels else 0
    height = len(pixels)
    rgb = bytes(
        channel
        for row in pixels
        for index in row
        for channel in GAME_PALETTE_RGB8[index]
    )
    return pygame.image.fromstring(rgb, (width, height), "RGB")


def crop_indexed_pixels(
    pixels: Sequence[Sequence[int]], transparent_index: int = 0
) -> tuple[tuple[int, ...], ...]:
    """Remove the empty dungeon canvas around a rendered actor preview."""

    occupied = [
        (x, y)
        for y, row in enumerate(pixels)
        for x, value in enumerate(row)
        if value != transparent_index
    ]
    if not occupied:
        return ((transparent_index,),)
    left = min(x for x, _ in occupied)
    right = max(x for x, _ in occupied)
    top = min(y for _, y in occupied)
    bottom = max(y for _, y in occupied)
    return tuple(
        tuple(row[left : right + 1]) for row in pixels[top : bottom + 1]
    )


def adjustment_repeat_due(
    now: int,
    pressed_at: int,
    repeated_at: int,
    *,
    delay: int = CONTROL_REPEAT_DELAY_MS,
    interval: int = CONTROL_REPEAT_INTERVAL_MS,
) -> bool:
    """Return whether a held adjustment control should repeat now."""

    return now - pressed_at >= delay and now - repeated_at >= interval


def integer_preview_scale(
    source_size: tuple[int, int],
    target_size: tuple[int, int],
    *,
    maximum: int = 3,
) -> int:
    """Choose one uniform integer scale for source-pixel actor artwork."""

    source_width, source_height = source_size
    target_width, target_height = target_size
    if source_width <= 0 or source_height <= 0:
        raise ValueError("preview source dimensions must be positive")
    return max(
        1,
        min(maximum, target_width // source_width, target_height // source_height),
    )


def champion_preview_body_design(
    character_assets: CharacterAssets,
    champion: int,
    pocket_record: bytes,
) -> int:
    """Apply the shared source-derived worn-armour body override."""

    if len(pocket_record) < 3:
        raise ValueError("champion pocket record does not contain body armour")
    return body_design_with_worn_armour(
        character_assets.body_design(champion), pocket_record[2]
    )


class GameFontRenderer:
    def __init__(self, pygame, path: Path) -> None:
        self.pygame = pygame
        self.data = read_font(path)

    def draw(
        self,
        surface,
        text: str,
        position: tuple[int, int],
        colour: tuple[int, int, int],
        *,
        scale: int = 2,
    ) -> None:
        x, y = position
        for character in text.upper():
            for gy, row in enumerate(glyph_pixels(self.data, ord(character) & 0x7F)):
                for gx, value in enumerate(row):
                    if value:
                        self.pygame.draw.rect(
                            surface,
                            colour,
                            (x + gx * scale, y + gy * scale, scale, scale),
                        )
            x += 8 * scale

    def draw_map_glyph(
        self,
        surface,
        character: str,
        colour: tuple[int, int, int],
        *,
        x: int = 3,
        y: int = 4,
        scale: int = 1,
    ) -> None:
        """Draw one glyph using the map editor's tall 1x2 pixel geometry."""

        for gy, row in enumerate(glyph_pixels(self.data, ord(character) & 0x7F)):
            for gx, value in enumerate(row):
                if value:
                    self.pygame.draw.rect(
                        surface,
                        colour,
                        (x + gx * scale, y + gy * scale * 2, scale, scale * 2),
                    )


def default_floor(project: MapProject, tower: int) -> int:
    tower_map = project.maps[tower]
    available_floors = [
        floor for floor in range(len(tower_map.widths)) if tower_map.floor_exists(floor)
    ]
    if not available_floors:
        return 0
    return max(
        available_floors,
        key=lambda floor: tower_map.widths[floor] * tower_map.heights[floor],
    )


def joystick_navigation_action(
    event: object,
    *,
    hat_motion_type: int,
    button_down_type: int,
    axis_motion_type: int | None = None,
) -> str | None:
    """Translate the first joystick's D-pad/buttons into viewer actions.

    D-pad directions mirror W/A/S/D (forward/back/lateral movement).  The
    first two joystick buttons are intentionally a provisional Q/E mapping.
    """

    if getattr(event, "type", None) == hat_motion_type:
        x, y = getattr(event, "value", (0, 0))
        if y > 0:
            return "MOVE-FORWARD"
        if y < 0:
            return "MOVE-BACK"
        if x < 0:
            return "MOVE-LEFT"
        if x > 0:
            return "MOVE-RIGHT"
    elif getattr(event, "type", None) == button_down_type:
        if getattr(event, "button", None) == 0:
            return "TURN-LEFT"
        if getattr(event, "button", None) == 1:
            return "TURN-RIGHT"
    elif axis_motion_type is not None and getattr(event, "type", None) == axis_motion_type:
        axis = getattr(event, "axis", None)
        value = getattr(event, "value", 0.0)
        if abs(value) < 0.5:
            return None
        if axis == 0:
            return "MOVE-LEFT" if value < 0 else "MOVE-RIGHT"
        if axis == 1:
            return "MOVE-FORWARD" if value < 0 else "MOVE-BACK"
    return None


def launch_map_editor(
    data_root: Path | None = None,
    *,
    savegame_path: Path | None = None,
    screenshot_path: Path | None = None,
    initial_tab: int = 0,
    initial_actor_mode: str = "CHAMPIONS",
) -> None:
    try:
        import pygame
    except ImportError as error:
        raise MapEditorError("Pygame is required for the map editor") from error

    data_root = Path(data_root or (DATA_DIR / "BLOODWYCH439-clean"))
    try:
        project = (
            MapProject.from_savegame(data_root, Path(savegame_path))
            if savegame_path is not None
            else MapProject.from_extracted(data_root)
        )
    except (OSError, ValueError) as error:
        raise MapEditorError(str(error)) from error

    def load_visual_assets(use_modified: bool):
        """Load an explicit clean/modified graphics set for all actor art."""

        current_gfx_dir = DataOverlayPath(
            project.clean_root / "gfx",
            project.modified_root / "gfx",
            use_modified,
        )
        current_data_dir = DataOverlayPath(
            project.clean_root / "data",
            project.modified_root / "data",
            use_modified,
        )
        current_monsters_dir = DataOverlayPath(
            project.clean_root / "monsters",
            project.modified_root / "monsters",
            use_modified,
        )
        current_data_root = DataOverlayPath(
            project.clean_root,
            project.modified_root,
            use_modified,
        )
        try:
            backgrounds = tuple(
                load_dungeon_background(current_gfx_dir, pattern_parity=parity)
                for parity in range(2)
            )
            assets = DungeonAssets(current_gfx_dir)
        except (OSError, ValueError) as error:
            raise MapEditorError(f"could not load dungeon preview assets: {error}") from error
        try:
            characters = CharacterAssets(current_data_dir, current_gfx_dir)
        except (OSError, ValueError, RuntimeError):
            characters = None
        try:
            spells = AirbourneSpellAssets(current_gfx_dir)
        except (OSError, ValueError, RuntimeError):
            spells = None
        try:
            objects = ObjectAssets(current_data_root)
        except (OSError, ValueError, RuntimeError):
            objects = None
        try:
            champions = ChampionAssets(current_data_root)
        except (OSError, ValueError, RuntimeError):
            champions = None
        monsters, _ = load_renderer_assets(current_monsters_dir)
        return (
            current_gfx_dir,
            current_data_dir,
            current_monsters_dir,
            backgrounds,
            assets,
            characters,
            spells,
            objects,
            champions,
            monsters,
        )

    use_modified_art = data_root.name.endswith("-modified")
    (
        gfx_dir,
        data_dir,
        monsters_dir,
        dungeon_backgrounds,
        dungeon_assets,
        character_assets,
        spell_assets,
        object_assets,
        champion_assets,
        monster_assets,
    ) = load_visual_assets(use_modified_art)

    def sync_character_design_preview() -> None:
        """Keep unsaved shared design edits visible across art reloads."""

        if character_assets is None:
            return
        def selected_bytes(name: str) -> bytes:
            if name in project.resource_data:
                return bytes(project.resource_data[name])
            return (data_dir / Path(name).name).read_bytes()

        character_assets.head_selections = list(selected_bytes("data/characters.heads"))
        character_assets.body_selections = list(selected_bytes("data/characters.bodies"))
        character_assets.colours = selected_bytes("data/characters.colours")

    sync_character_design_preview()

    pygame.init()
    pygame.joystick.init()
    joystick = None
    if pygame.joystick.get_count() > 0:
        joystick = pygame.joystick.Joystick(0)
        joystick.init()
    pygame.key.set_repeat(250, 45)
    try:
        screen = set_display_mode(pygame, WINDOW_SIZE)
        fullscreen = is_fullscreen()
        pygame.display.set_caption("Bloodwych ReSource - Map Editor")
        title_font = pygame.font.SysFont(None, 30)
        small_font = pygame.font.SysFont(None, 17)
        game_font = GameFontRenderer(
            pygame, project.clean_root / "gfx" / "GameFont"
        )
        clock = pygame.time.Clock()

        selected_tab = initial_tab if 0 <= initial_tab < len(EDITOR_TABS) and EDITOR_TAB_ENABLED[initial_tab] else 0
        selected_tower = 0
        selected_floor = default_floor(project, selected_tower)
        selected_x = selected_y = 0
        copied_cell: MapCell | None = None
        selected_editor_row: int | None = None
        selected_object_stack = 0
        selected_object_item = 0
        object_auto_select = True
        actor_mode = initial_actor_mode if initial_actor_mode in ("CHAMPIONS", "MONSTERS") else "CHAMPIONS"
        selected_champion = 0
        champion_page = 0
        champion_stats_page = 0
        champion_spell_page = 0
        selected_spell_entry = 0
        selected_pocket_slot = 0
        selected_monster = 0
        monster_map_click_mode = "SELECT"
        monster_design_mode = False
        selected_colour_group = 0
        selected_colour_slot = 0
        layout_preview_above = True
        layout_preview_below = True
        layout_link_lines = False
        layout_clear_armed: tuple[int, int] | None = None
        overlays = {
            name: enabled
            for name, enabled in zip(OVERLAY_NAMES, OVERLAY_DEFAULTS)
        }
        status_message = "READY"
        facing = 0
        preview_revision = 0
        preview_cache_key: tuple[int, ...] | None = None
        preview_surface = None
        preview_error: str | None = None
        zoom = 1
        pan_x = pan_y = 0
        dragging_map = False
        held_adjustment: tuple[int, str, object] | None = None
        held_adjustment_started = 0
        held_adjustment_repeated = 0
        drag_origin = (0, 0)
        pan_origin = (0, 0)
        cell_cache: dict[tuple[int, int], object] = {}
        object_icon_cache: dict[int, object] = {}
        switch_records = [list(project.switches(index)) for index in range(len(TOWERS))]
        trigger_records = [list(project.triggers(index)) for index in range(len(TOWERS))]
        object_stack_records = [
            list(project.object_stacks(index)) for index in range(len(TOWERS))
        ]

        tab_width, tab_gap = 160, 7
        tab_rects = tuple(
            pygame.Rect(20 + index * (tab_width + tab_gap), 52, tab_width, 34)
            for index in range(len(EDITOR_TABS))
        )
        art_rect = pygame.Rect(856, 52, 135, 34)
        source_rect = pygame.Rect(999, 52, 191, 34)
        display_mode_rect = pygame.Rect(WINDOW_SIZE[0] - 60, 12, 50, 28)
        tower_rects = tuple(
            pygame.Rect(20, 112 + index * 42, 220, 36)
            for index in range(len(TOWERS))
        )
        floor_rects = tuple(
            pygame.Rect(20 + (index % 4) * 54, 385 + (index // 4) * 40, 50, 34)
            for index in range(8)
        )
        overlay_gap = 4
        main_overlay_names = tuple(name for name in OVERLAY_NAMES if name != "LINKS")
        overlay_width = (MAP_SIZE - overlay_gap * (len(main_overlay_names) - 1)) // len(main_overlay_names)
        main_overlay_rects = tuple(
            pygame.Rect(MAP_ORIGIN[0] + index * (overlay_width + overlay_gap), 630, overlay_width, 28)
            for index in range(len(main_overlay_names))
        )
        # Links is a secondary display aid for switches and triggers, so it
        # sits directly below them and spans their combined width.
        links_rect = pygame.Rect(MAP_ORIGIN[0], 662, overlay_width * 2 + overlay_gap, 20)
        overlay_rects = main_overlay_rects + (links_rect,)
        save_rect = pygame.Rect(1010, 278, 180, 30)
        save_button_label = (
            "SAVE EDITED SAVE COPY"
            if project.save_data is not None
            else "SAVE TO -MODIFIED"
        )
        back_rect = pygame.Rect(20, 712, 100, 32)
        map_operation_rects = (
            ("COPY", "COPY", pygame.Rect(1010, 108, 42, 24)),
            ("CUT", "CUT", pygame.Rect(1056, 108, 42, 24)),
            ("PASTE", "PASTE", pygame.Rect(1102, 108, 42, 24)),
            ("CLEAR", "DEL", pygame.Rect(1148, 108, 42, 24)),
        )
        object_operation_rects = (
            ("ADD-STACK", "ADD STACK", pygame.Rect(1010, 108, 88, 24)),
            ("DELETE-STACK", "DELETE STACK", pygame.Rect(1102, 108, 88, 24)),
            ("ADD-ITEM", "ADD ITEM", pygame.Rect(1010, 136, 88, 24)),
            ("DELETE-ITEM", "DELETE ITEM", pygame.Rect(1102, 136, 88, 24)),
            ("MOVE-HERE", "PLACE HERE", pygame.Rect(1010, 164, 88, 24)),
            ("FIND", "FIND STACK", pygame.Rect(1102, 164, 88, 24)),
            ("AUTO-SELECT", "AUTO SELECT", pygame.Rect(1010, 192, 180, 24)),
        )
        actor_mode_rects = (
            ("CHAMPIONS", pygame.Rect(1010, 108, 86, 24)),
            ("MONSTERS", pygame.Rect(1102, 108, 88, 24)),
        )
        champion_find_rect = pygame.Rect(1010, 138, 180, 24)
        layout_clear_rect = pygame.Rect(1010, 108, 88, 24)
        layout_links_rect = pygame.Rect(1102, 108, 88, 24)
        monster_operation_rects = (
            ("REMOVE-TEAM", "MAKE SOLO", pygame.Rect(1010, 138, 88, 24)),
            ("MOVE-HERE", "PLACE HERE", pygame.Rect(1102, 138, 88, 24)),
            ("DESIGN", "DESIGN", pygame.Rect(1010, 166, 88, 24)),
            ("FIND", "FIND", pygame.Rect(1102, 166, 88, 24)),
            ("MAP-MODE", "MAP: SELECT", pygame.Rect(1010, 194, 180, 24)),
        )
        map_rect = pygame.Rect(*MAP_ORIGIN, MAP_SIZE, MAP_SIZE)
        map_border_rect = map_rect.inflate(2, 2)
        zoom_rects = (
            ("ZOOM-", pygame.Rect(20, 470, 68, 32)),
            ("ZOOM+", pygame.Rect(94, 470, 68, 32)),
            ("FIT", pygame.Rect(168, 470, 72, 32)),
        )
        pan_rects = (
            ("PAN-UP", pygame.Rect(94, 512, 68, 30)),
            ("PAN-LEFT", pygame.Rect(20, 546, 68, 30)),
            ("PAN-RIGHT", pygame.Rect(168, 546, 72, 30)),
            ("PAN-DOWN", pygame.Rect(94, 580, 68, 30)),
        )

        def current_map():
            return project.maps[selected_tower]

        def clamp_selection() -> None:
            nonlocal selected_x, selected_y
            tower_map = current_map()
            width, height = (
                tower_map.widths[selected_floor],
                tower_map.heights[selected_floor],
            )
            selected_x = max(0, min(selected_x, max(0, width - 1)))
            selected_y = max(0, min(selected_y, max(0, height - 1)))

        def current_cell() -> MapCell | None:
            if not current_map().floor_exists(selected_floor):
                return None
            return current_map().cell(
                selected_floor, selected_x, selected_y
            )

        def resolved_record_reference(
            records: Sequence[Sequence[object]], reference: int
        ) -> tuple[int, int] | None:
            return resolve_contiguous_reference(
                selected_tower,
                reference,
                (len(tower_records) for tower_records in records),
            )

        def current_object_stack() -> ObjectStack | None:
            stacks = object_stack_records[selected_tower]
            if not stacks:
                return None
            return stacks[min(selected_object_stack, len(stacks) - 1)]

        def object_resource_editable() -> bool:
            return project.resource_is_editable(
                f"maps/{TOWERS[selected_tower].stem}.obj"
            )

        def jump_to_location(floor: int, x: int, y: int) -> None:
            nonlocal selected_floor, selected_x, selected_y, pan_x, pan_y
            selected_floor, selected_x, selected_y = floor, x, y
            pan_x = pan_y = 0
            clamp_selection()
            clamp_pan()
            ensure_selection_visible()

        def jump_to_object_stack() -> bool:
            stack = current_object_stack()
            if stack is None:
                return False
            location = object_stack_location(current_map(), stack)
            if location is None:
                return False
            jump_to_location(*location)
            return True

        def selected_champion_location() -> tuple[int, int, int, str] | None:
            location = next(
                (
                    (item.floor, item.x, item.y, "CHAMPION")
                    for item in project.viewer_champions(
                        selected_tower,
                        quickstart_teams=overlays["QS TEAMS"],
                    )
                    if item.index == selected_champion
                ),
                None,
            )
            if location is not None:
                return location
            return next(
                (
                    (party.floor, party.x, party.y, f"PLAYER {party.index + 1}")
                    for party in project.player_parties(selected_tower)
                    if selected_champion in party.champions
                ),
                None,
            )

        def find_selected_champion() -> None:
            nonlocal status_message
            location = selected_champion_location()
            if location is None:
                status_message = "THE SELECTED CHAMPION HAS NO LOCATION IN THIS TOWER"
                return
            floor, x, y, source = location
            jump_to_location(floor, x, y)
            status_message = f"FOUND {source} ON FLOOR {floor} X ${x:02X} Y ${y:02X}"

        def find_selected_monster() -> None:
            nonlocal status_message
            record = selected_monster_record(resolved=True)
            if record is None or not record.has_position:
                status_message = "THE SELECTED MONSTER HAS NO RESOLVED LOCATION"
                return
            jump_to_location(record.floor, record.x, record.y)
            status_message = (
                f"FOUND MONSTER ON FLOOR {record.floor} X ${record.x:02X} Y ${record.y:02X}"
            )

        def write_object_stacks(stacks: Sequence[ObjectStack]) -> bool:
            nonlocal status_message, preview_revision
            try:
                written = project.set_object_stacks(selected_tower, stacks)
            except (IndexError, ValueError) as error:
                status_message = str(error).upper()
                return False
            object_stack_records[selected_tower] = list(written)
            preview_revision += 1
            status_message = "UNSAVED OBJECT STACK CHANGE"
            return True

        def apply_object_action(action: str) -> None:
            nonlocal selected_object_stack, selected_object_item, status_message
            nonlocal object_auto_select
            if action == "AUTO-SELECT":
                object_auto_select = not object_auto_select
                status_message = (
                    "OBJECT MAP AUTO-SELECTION ON"
                    if object_auto_select
                    else "OBJECT MAP AUTO-SELECTION OFF — CURSOR MOVES ONLY"
                )
                return
            stacks = list(object_stack_records[selected_tower])
            if action == "ADD-STACK":
                if object_assets is None:
                    status_message = "OBJECT DEFINITIONS ARE UNAVAILABLE"
                    return
                codes = tuple(
                    definition.code
                    for definition in object_assets.definitions
                    if definition.code != 0
                )
                if not codes:
                    status_message = "NO EXTRACTED OBJECT DEFINITIONS"
                    return
                cell = current_cell()
                if cell is not None and cell.map_type == 1 and (
                    cell.c < 8 or cell.b & 3 != 0
                ):
                    status_message = "OBJECTS ON STONE WALLS REQUIRE A FACING SHELF"
                    return
                map_index = current_map().map_index(
                    selected_floor, selected_x, selected_y
                )
                stack = ObjectStack(0, map_index, ((codes[0], 1),))
                positions = object_stack_positions(current_map(), stack)
                stack = ObjectStack(positions[0], map_index, stack.items)
                if write_object_stacks(stacks + [stack]):
                    selected_object_stack = len(stacks)
                    selected_object_item = 0
                return
            if not stacks:
                status_message = "NO OBJECT STACKS IN THIS TOWER"
                return
            selected_object_stack = min(selected_object_stack, len(stacks) - 1)
            stack = stacks[selected_object_stack]
            selected_object_item = min(selected_object_item, len(stack.items) - 1)
            if action in ("STACK-", "STACK+"):
                delta = -1 if action.endswith("-") else 1
                selected_object_stack = (selected_object_stack + delta) % len(stacks)
                selected_object_item = 0
                jump_to_object_stack()
                status_message = f"OBJECT STACK {selected_object_stack + 1}"
                return
            if action == "FIND":
                if jump_to_object_stack():
                    status_message = f"FOUND OBJECT STACK {selected_object_stack + 1}"
                else:
                    status_message = "THE SELECTED OBJECT STACK HAS NO VALID LOCATION"
                return
            if action == "MOVE-HERE":
                cell = current_cell()
                if cell is not None and cell.map_type == 1 and (
                    cell.c < 8 or cell.b & 3 != 0
                ):
                    status_message = "OBJECTS ON STONE WALLS REQUIRE A FACING SHELF"
                    return
                moved = relocate_object_stack(
                    current_map(),
                    stack,
                    selected_floor,
                    selected_x,
                    selected_y,
                )
                stacks[selected_object_stack] = moved
                if write_object_stacks(stacks):
                    status_message = (
                        f"PLACED OBJECT STACK ON FLOOR {selected_floor} "
                        f"X ${selected_x:02X} Y ${selected_y:02X}"
                    )
                return
            if action == "DELETE-STACK":
                del stacks[selected_object_stack]
                if write_object_stacks(stacks):
                    selected_object_stack = min(
                        selected_object_stack, max(0, len(stacks) - 1)
                    )
                    selected_object_item = 0
                    jump_to_object_stack()
                return
            if action in ("POSITION-", "POSITION+"):
                positions = object_stack_positions(current_map(), stack)
                try:
                    index = positions.index(stack.position)
                except ValueError:
                    index = 0
                delta = -1 if action.endswith("-") else 1
                stacks[selected_object_stack] = ObjectStack(
                    positions[(index + delta) % len(positions)],
                    stack.map_index,
                    stack.items,
                )
            elif action in ("ITEM-", "ITEM+"):
                delta = -1 if action.endswith("-") else 1
                selected_object_item = (
                    selected_object_item + delta
                ) % len(stack.items)
                return
            elif action in ("SEQUENCE-", "SEQUENCE+"):
                destination = selected_object_item + (
                    -1 if action.endswith("-") else 1
                )
                if not 0 <= destination < len(stack.items):
                    return
                items = list(stack.items)
                items[selected_object_item], items[destination] = (
                    items[destination],
                    items[selected_object_item],
                )
                selected_object_item = destination
                stacks[selected_object_stack] = ObjectStack(
                    stack.position, stack.map_index, tuple(items)
                )
            elif action == "ADD-ITEM":
                if object_assets is None:
                    status_message = "OBJECT DEFINITIONS ARE UNAVAILABLE"
                    return
                codes = tuple(
                    definition.code
                    for definition in object_assets.definitions
                    if definition.code != 0
                )
                if not codes:
                    status_message = "NO EXTRACTED OBJECT DEFINITIONS"
                    return
                stacks[selected_object_stack] = ObjectStack(
                    stack.position,
                    stack.map_index,
                    stack.items + ((codes[0], 1),),
                )
                selected_object_item = len(stack.items)
            elif action == "DELETE-ITEM":
                if len(stack.items) == 1:
                    status_message = "A STACK MUST CONTAIN AT LEAST ONE ITEM"
                    return
                items = list(stack.items)
                del items[selected_object_item]
                stacks[selected_object_stack] = ObjectStack(
                    stack.position,
                    stack.map_index,
                    tuple(items),
                )
                selected_object_item = min(
                    selected_object_item, len(items) - 1
                )
            elif action in ("OBJECT-", "OBJECT+"):
                if object_assets is None:
                    status_message = "OBJECT DEFINITIONS ARE UNAVAILABLE"
                    return
                codes = tuple(
                    definition.code
                    for definition in object_assets.definitions
                    if definition.code != 0
                )
                code, quantity = stack.items[selected_object_item]
                try:
                    index = codes.index(code)
                except ValueError:
                    index = 0
                delta = -1 if action.endswith("-") else 1
                items = list(stack.items)
                items[selected_object_item] = (
                    codes[(index + delta) % len(codes)],
                    quantity,
                )
                stacks[selected_object_stack] = ObjectStack(
                    stack.position, stack.map_index, tuple(items)
                )
            elif action in ("QUANTITY-", "QUANTITY+"):
                code, quantity = stack.items[selected_object_item]
                delta = -1 if action.endswith("-") else 1
                quantity = ((quantity - 1 + delta) % 0xFF) + 1
                items = list(stack.items)
                items[selected_object_item] = (code, quantity)
                stacks[selected_object_stack] = ObjectStack(
                    stack.position, stack.map_index, tuple(items)
                )
            else:
                return
            write_object_stacks(stacks)

        def actor_records() -> tuple[MonsterRecord, ...]:
            return project.occupants(selected_tower)

        def resolved_actor_records() -> tuple[MonsterRecord, ...]:
            return project.render_occupants(selected_tower)

        def selected_monster_record(*, resolved: bool = False) -> MonsterRecord | None:
            records = resolved_actor_records() if resolved else actor_records()
            if not records:
                return None
            return records[min(selected_monster, len(records) - 1)]

        def apply_actor_action(action: str) -> None:
            nonlocal selected_champion, selected_monster, champion_page
            nonlocal champion_spell_page, selected_pocket_slot, status_message
            nonlocal selected_spell_entry
            nonlocal champion_stats_page
            nonlocal monster_design_mode, selected_colour_group, selected_colour_slot
            nonlocal monster_map_click_mode
            if actor_mode == "CHAMPIONS":
                editable = champion_edit_allowed(
                    has_save=project.save_data is not None,
                    selected_tower=selected_tower,
                    active_tower=project.current_tower,
                )
                if action in ("CHAMPION-", "CHAMPION+"):
                    selected_champion = (selected_champion + (-1 if action.endswith("-") else 1)) & 0x0F
                    return
                if action in ("PAGE-", "PAGE+"):
                    champion_page = (champion_page + (-1 if action.endswith("-") else 1)) % 3
                    return
                if action in ("SPELL-PAGE-", "SPELL-PAGE+"):
                    champion_spell_page = (champion_spell_page + (-1 if action.endswith("-") else 1)) % 8
                    return
                if action in ("STAT-PAGE-", "STAT-PAGE+"):
                    champion_stats_page = (champion_stats_page + (-1 if action.endswith("-") else 1)) % 3
                    return
                if action in ("POCKET-", "POCKET+"):
                    selected_pocket_slot = (selected_pocket_slot + (-1 if action.endswith("-") else 1)) % 12
                    return
                if action == "FIND":
                    find_selected_champion()
                    return
                if not editable:
                    status_message = "CHAMPIONS ARE EDITABLE ONLY ON MOD0 OR THE ACTIVE SAVE TOWER"
                    return
                record = project.champion_record_bytes(selected_champion)
                if action.startswith("STAT-"):
                    offset = int(action.split("-")[1], 16)
                    delta = -1 if action.endswith("-") else 1
                    project.set_champion_byte(
                        selected_tower, selected_champion, offset, (record[offset] + delta) % 100
                    )
                elif action.startswith("SPELL-") and action not in ("SPELL-PAGE-", "SPELL-PAGE+"):
                    spell = indexed_action_value(action, "SPELL-")
                    selected_spell_entry = spell & 3
                    byte_offset = 0x0C + spell // 8
                    bit = 7 - (spell & 7)
                    project.set_champion_byte(
                        selected_tower,
                        selected_champion,
                        byte_offset,
                        record[byte_offset] ^ (1 << bit),
                    )
                elif action in ("PRACTICE-", "PRACTICE+"):
                    spell = champion_spell_page * 4 + selected_spell_entry
                    practice = project.spell_practice(selected_champion, spell)
                    if practice is None:
                        status_message = "SPELL PRACTICE EXISTS ONLY IN A LOADED SAVE"
                        return
                    delta = -1 if action.endswith("-") else 1
                    project.set_spell_practice(
                        selected_tower,
                        selected_champion,
                        spell,
                        (practice + delta) & 0xFF,
                    )
                elif action in ("OBJECT-", "OBJECT+") and object_assets is not None:
                    pocket = project.champion_pocket_bytes(selected_champion)
                    codes = tuple(definition.code for definition in object_assets.definitions)
                    current = pocket[selected_pocket_slot]
                    try:
                        position = codes.index(current)
                    except ValueError:
                        position = 0
                    delta = -1 if action.endswith("-") else 1
                    new_code = codes[(position + delta) % len(codes)]
                    project.set_champion_pocket_byte(
                        selected_tower,
                        selected_champion,
                        selected_pocket_slot,
                        new_code,
                    )
                    if 1 <= new_code <= 4 and pocket[0x0B + new_code] == 0:
                        project.set_champion_pocket_byte(
                            selected_tower,
                            selected_champion,
                            0x0B + new_code,
                            1,
                        )
                elif action in ("COUNT-", "COUNT+"):
                    pocket = project.champion_pocket_bytes(selected_champion)
                    code = pocket[selected_pocket_slot]
                    if not 1 <= code <= 4:
                        status_message = "THE SELECTED OBJECT HAS NO QUANTITY BYTE"
                        return
                    offset = 0x0B + code
                    delta = -1 if action.endswith("-") else 1
                    project.set_champion_pocket_byte(
                        selected_tower,
                        selected_champion,
                        offset,
                        (pocket[offset] + delta) & 0xFF,
                    )
                status_message = "UNSAVED CHAMPION CHANGE"
                return

            records = actor_records()
            if not records:
                return
            selected_monster = min(selected_monster, len(records) - 1)
            record = records[selected_monster]
            if action in ("MONSTER-", "MONSTER+"):
                selected_monster = (selected_monster + (-1 if action.endswith("-") else 1)) % len(records)
                monster_design_mode = False
                return
            if action == "FIND":
                find_selected_monster()
                return
            if action == "DESIGN":
                monster_design_mode = not monster_design_mode
                return
            if action == "MAP-MODE":
                monster_map_click_mode = (
                    "JOIN" if monster_map_click_mode == "SELECT" else "SELECT"
                )
                status_message = (
                    "MAP CLICK SELECTS MONSTERS"
                    if monster_map_click_mode == "SELECT"
                    else "MAP CLICK JOINS THE SELECTED MONSTER TO A PARTY"
                )
                return
            if monster_design_mode:
                if record.form <= 0x55:
                    if character_assets is None:
                        status_message = "CHARACTER DESIGN ASSETS ARE UNAVAILABLE"
                        return
                    if project.save_data is not None:
                        status_message = "SHARED CHARACTER DESIGNS ARE NOT STORED IN A SAVE"
                        return
                    head, body, palettes = project.character_design(record.form)
                    if action in ("HEAD-", "HEAD+"):
                        limit = len(character_assets.head_data) // 0x378
                        project.set_character_design(record.form, head=(head + (-1 if action.endswith("-") else 1)) % limit)
                    elif action in ("BODY-", "BODY+"):
                        limit = len(character_assets.body_definitions)
                        project.set_character_design(record.form, body=(body + (-1 if action.endswith("-") else 1)) % limit)
                    elif action in ("PALETTE-", "PALETTE+"):
                        selected_colour_group = (selected_colour_group + (-1 if action.endswith("-") else 1)) % 5
                        return
                    elif action.startswith("INK"):
                        colour_slot = indexed_action_value(action, "INK")
                        ink = palettes[selected_colour_group][colour_slot]
                        project.set_character_design(
                            record.form,
                            colour_group=selected_colour_group,
                            colour_slot=colour_slot,
                            ink=(ink + (-1 if action.endswith("-") else 1)) % 16,
                        )
                    else:
                        return
                    # Keep the source renderer's unsaved preview in lockstep.
                    head, body, palettes = project.character_design(record.form)
                    character_assets.head_selections[record.form] = head
                    character_assets.body_selections[record.form] = body
                    colours = bytearray(character_assets.colours)
                    start = record.form * 20
                    colours[start : start + 20] = bytes(value for palette in palettes for value in palette)
                    character_assets.colours = bytes(colours)
                    status_message = "UNSAVED SHARED CHARACTER DESIGN CHANGE"
                    return
                grade_table = LARGE_MONSTER_GRADE_TABLES.get(record.form)
                if action in ("GRADE-", "GRADE+") and grade_table is not None:
                    if record.source == "live":
                        status_message = "ACTIVE-TOWER LIVE MONSTER GRADES ARE VIEW ONLY"
                        return
                    filename = grade_table
                    grade_count = len((monsters_dir / filename).read_bytes())
                    step = max(
                        0,
                        min(
                            grade_count - 1,
                            (record.level & 0x7F) - record.colour_grade_base,
                        ),
                    )
                    step = (step + (-1 if action.endswith("-") else 1)) % grade_count
                    project.set_packed_monster(
                        selected_tower,
                        selected_monster,
                        level=(record.level & 0x80)
                        | (record.colour_grade_base + step),
                    )
                    status_message = "UNSAVED LARGE-MONSTER COLOUR GRADE CHANGE"
                return
            if record.source == "live":
                status_message = "ACTIVE-TOWER LIVE MONSTERS ARE VIEW ONLY"
                return
            try:
                if action in ("FORM-", "FORM+"):
                    forms = tuple(range(0x56)) + tuple(range(0x64, 0x6C))
                    try:
                        position = forms.index(record.form)
                    except ValueError:
                        position = 0
                    delta = -1 if action.endswith("-") else 1
                    project.set_packed_monster(selected_tower, selected_monster, form=forms[(position + delta) % len(forms)])
                elif action in ("LEVEL-", "LEVEL+"):
                    delta = -1 if action.endswith("-") else 1
                    project.set_packed_monster(selected_tower, selected_monster, level=(record.level + delta) & 0x7F)
                elif action in ("TYPE-", "TYPE+"):
                    delta = -1 if action.endswith("-") else 1
                    project.set_packed_monster(selected_tower, selected_monster, category=(record.category + delta) % 5)
                elif action == "JOIN-TEAM":
                    before_codes = {member.team for member in records}
                    joined = project.join_monster_to_previous_team(
                        selected_tower, selected_monster
                    )
                    new_codes = [
                        member.team
                        for member in joined
                        if member.team != 0xFF and member.team not in before_codes
                    ]
                    selected_code = new_codes[-1]
                    selected_monster = next(
                        member.index
                        for member in joined
                        if member.team == selected_code
                    )
                    updated = joined[selected_monster]
                    status_message = f"JOINED TEAM GROUP {updated.team >> 2:02d} SLOT {(updated.team & 3) + 1}"
                    return
                elif action == "REMOVE-TEAM":
                    project.remove_monster_from_team(selected_tower, selected_monster)
                    status_message = "MONSTER IS NOW SOLO"
                    return
                elif action == "MOVE-HERE":
                    project.set_packed_monster(
                        selected_tower, selected_monster,
                        floor=selected_floor, x=selected_x, y=selected_y, team=0xFF,
                    )
                    status_message = f"MOVED MONSTER TO FLOOR {selected_floor} X ${selected_x:02X} Y ${selected_y:02X}"
                    return
                else:
                    return
            except (IndexError, ValueError) as error:
                status_message = str(error).upper()
                return
            status_message = "UNSAVED PACKED MONSTER CHANGE"

        def replace_cell(cell: MapCell) -> None:
            nonlocal status_message, preview_revision
            try:
                project.set_cell(
                    selected_tower, selected_floor, selected_x, selected_y, cell
                )
            except (IndexError, ValueError) as error:
                status_message = str(error).upper()
                return
            preview_revision += 1
            status_message = "UNSAVED MAP CHANGE"

        def apply_action(action: str) -> None:
            nonlocal copied_cell, status_message
            cell = current_cell()
            if cell is None:
                return
            try:
                if action.startswith("SWITCH-") and cell.map_type == 1:
                    reference = cell.first // 8
                    resolved = resolved_record_reference(switch_records, reference)
                    if resolved is None:
                        raise IndexError("switch reference is outside the contiguous tower tables")
                    record_tower, record_reference = resolved
                    record = switch_records[record_tower][record_reference]
                    action_values = tuple(SWITCH_ACTIONS)
                    if action in ("SWITCH-ACTION-", "SWITCH-ACTION+"):
                        try:
                            index = action_values.index(record.action)
                        except ValueError:
                            index = 0
                        delta = -1 if action.endswith("-") else 1
                        record = project.set_switch(record_tower, record_reference, action=action_values[(index + delta) % len(action_values)])
                    elif action == "SWITCH-X-":
                        record = project.set_switch(record_tower, record_reference, x=max(0, record.x - 1))
                    elif action == "SWITCH-X+":
                        record = project.set_switch(record_tower, record_reference, x=min(31, record.x + 1))
                    elif action == "SWITCH-Y-":
                        record = project.set_switch(record_tower, record_reference, y=max(0, record.y - 1))
                    elif action == "SWITCH-Y+":
                        record = project.set_switch(record_tower, record_reference, y=min(31, record.y + 1))
                    switch_records[record_tower][record_reference] = record
                    status_message = "UNSAVED SHARED SWITCH CHANGE"
                    return
                if action.startswith("TRIGGER-") and cell.map_type == 6:
                    reference = cell.first // 8
                    resolved = resolved_record_reference(trigger_records, reference)
                    if resolved is None:
                        raise IndexError("trigger reference is outside the contiguous tower tables")
                    record_tower, record_reference = resolved
                    record = trigger_records[record_tower][record_reference]
                    action_values = tuple(TRIGGER_ACTIONS)
                    if action in ("TRIGGER-ACTION-", "TRIGGER-ACTION+"):
                        try:
                            index = action_values.index(record.action)
                        except ValueError:
                            index = 0
                        delta = -1 if action.endswith("-") else 1
                        record = project.set_trigger(record_tower, record_reference, action=action_values[(index + delta) % len(action_values)])
                    elif action == "TRIGGER-FLOOR-":
                        record = project.set_trigger(
                            record_tower,
                            record_reference,
                            floor=adjust_trigger_parameter(record.action, record.floor, -1),
                        )
                    elif action == "TRIGGER-FLOOR+":
                        record = project.set_trigger(
                            record_tower,
                            record_reference,
                            floor=adjust_trigger_parameter(record.action, record.floor, 1),
                        )
                    elif action == "TRIGGER-X-":
                        record = project.set_trigger(record_tower, record_reference, x=max(0, record.x - 1))
                    elif action == "TRIGGER-X+":
                        record = project.set_trigger(record_tower, record_reference, x=min(31, record.x + 1))
                    elif action == "TRIGGER-Y-":
                        record = project.set_trigger(record_tower, record_reference, y=max(0, record.y - 1))
                    elif action == "TRIGGER-Y+":
                        record = project.set_trigger(record_tower, record_reference, y=min(31, record.y + 1))
                    trigger_records[record_tower][record_reference] = record
                    status_message = "UNSAVED SHARED TRIGGER CHANGE"
                    return
            except (IndexError, ValueError) as error:
                status_message = str(error).upper()
                return
            if action == "COPY":
                copied_cell = cell
                status_message = f"COPIED ${cell.first:02X} ${cell.second:02X}"
            elif action == "CUT":
                copied_cell = cell
                replace_cell(MapCell(0, 0))
                if current_cell() == MapCell(0, 0):
                    status_message = f"CUT ${cell.first:02X} ${cell.second:02X}"
            elif action == "PASTE" and copied_cell is not None:
                replace_cell(copied_cell)
            else:
                replacement = apply_cell_action(cell, action)
                if replacement != cell:
                    replace_cell(replacement)

        def apply_layout_action(action: str) -> None:
            nonlocal status_message, selected_floor, selected_x, selected_y
            nonlocal layout_preview_above, layout_preview_below, layout_link_lines
            nonlocal layout_clear_armed, preview_revision
            tower_map = current_map()
            try:
                if action != "LAYOUT-CLEAR":
                    layout_clear_armed = None
                if action == "LAYOUT-CLEAR":
                    floor_key = (selected_tower, selected_floor)
                    if layout_clear_armed != floor_key:
                        layout_clear_armed = floor_key
                        status_message = "CLICK CLEAR FLOOR AGAIN TO CONFIRM"
                        return
                    project.clear_floor(selected_tower, selected_floor)
                    layout_clear_armed = None
                    status_message = "UNSAVED FLOOR-CELL CLEAR"
                elif action == "LAYOUT-LINKS":
                    layout_link_lines = not layout_link_lines
                    status_message = f"STAIR LINK LINES {'ON' if layout_link_lines else 'OFF'}"
                elif action in ("LAYOUT-ABOVE-", "LAYOUT-ABOVE+"):
                    layout_preview_above = not layout_preview_above
                    status_message = f"ABOVE FLOOR PREVIEW {'ON' if layout_preview_above else 'OFF'}"
                elif action in ("LAYOUT-BELOW-", "LAYOUT-BELOW+"):
                    layout_preview_below = not layout_preview_below
                    status_message = f"BELOW FLOOR PREVIEW {'ON' if layout_preview_below else 'OFF'}"
                elif action in ("LAYOUT-TOP-", "LAYOUT-TOP+"):
                    delta = -1 if action.endswith("-") else 1
                    top_floor = max(0, min(7, tower_map.top_floor + delta))
                    project.set_top_floor(selected_tower, top_floor)
                    selected_floor = min(selected_floor, top_floor)
                    clamp_selection()
                    status_message = "UNSAVED HIGHEST-FLOOR CHANGE"
                elif action.startswith("LAYOUT-WIDTH") or action.startswith("LAYOUT-HEIGHT"):
                    delta = -1 if action.endswith("-") else 1
                    width = tower_map.widths[selected_floor]
                    height = tower_map.heights[selected_floor]
                    if action.startswith("LAYOUT-WIDTH"):
                        width = max(0, min(31, width + delta))
                    else:
                        height = max(0, min(31, height + delta))
                    project.set_floor_dimensions(
                        selected_tower, selected_floor, width, height
                    )
                    object_stack_records[selected_tower] = list(
                        project.object_stacks(selected_tower)
                    )
                    selected_x = min(selected_x, max(0, width - 1))
                    selected_y = min(selected_y, max(0, height - 1))
                    clamp_pan()
                    status_message = "UNSAVED FLOOR-SIZE CHANGE"
                elif action.startswith("LAYOUT-X") or action.startswith("LAYOUT-Y"):
                    delta = -1 if action.endswith("-") else 1
                    x_offset = tower_map.x_offsets[selected_floor]
                    y_offset = tower_map.y_offsets[selected_floor]
                    if action.startswith("LAYOUT-X"):
                        x_offset = max(
                            0,
                            min(31 - tower_map.widths[selected_floor], x_offset + delta),
                        )
                    else:
                        y_offset = max(
                            0,
                            min(31 - tower_map.heights[selected_floor], y_offset + delta),
                        )
                    project.set_floor_alignment(
                        selected_tower, selected_floor, x_offset, y_offset
                    )
                    clamp_pan()
                    status_message = "UNSAVED FLOOR-ALIGNMENT CHANGE"
                else:
                    return
            except (IndexError, ValueError) as error:
                status_message = str(error).upper()
                return
            preview_revision += 1

        def apply_editor_adjustment(tab: int, action: str) -> None:
            if tab == 2:
                apply_object_action(action)
            elif tab == 3:
                apply_actor_action(action)
            elif tab == 4:
                apply_layout_action(action)
            else:
                apply_action(action)

        def begin_held_adjustment(tab: int, action: str, rectangle) -> None:
            nonlocal held_adjustment, held_adjustment_started
            nonlocal held_adjustment_repeated
            now = pygame.time.get_ticks()
            held_adjustment = (tab, action, rectangle)
            held_adjustment_started = now
            held_adjustment_repeated = now
            apply_editor_adjustment(tab, action)
            if action.startswith(("LAYOUT-ABOVE", "LAYOUT-BELOW")):
                held_adjustment = None

        def save_changes() -> None:
            nonlocal status_message
            try:
                written = project.save()
            except OSError as error:
                status_message = f"SAVE FAILED: {error}"
                return
            if written:
                status_message = "SAVED: " + written[0].relative_to(
                    project.modified_root.parent
                ).as_posix().upper()
            else:
                status_message = "NO CHANGES TO SAVE"

        def cell_size() -> int:
            return CELL_SIZE * zoom

        def clamp_pan() -> None:
            nonlocal pan_x, pan_y
            tower_map = current_map()
            content_width = max(
                MAP_GRID_CELLS,
                tower_map.x_offsets[selected_floor] + tower_map.widths[selected_floor],
            ) * cell_size()
            content_height = max(
                MAP_GRID_CELLS,
                tower_map.y_offsets[selected_floor] + tower_map.heights[selected_floor],
            ) * cell_size()
            minimum_x = min(0, MAP_SIZE - content_width)
            minimum_y = min(0, MAP_SIZE - content_height)
            pan_x = max(minimum_x, min(0, pan_x))
            pan_y = max(minimum_y, min(0, pan_y))

        def can_pan() -> bool:
            tower_map = current_map()
            return (
                (tower_map.x_offsets[selected_floor] + tower_map.widths[selected_floor]) * cell_size() > MAP_SIZE
                or (tower_map.y_offsets[selected_floor] + tower_map.heights[selected_floor]) * cell_size() > MAP_SIZE
            )

        def set_zoom(new_zoom: int, focus: tuple[int, int] | None = None) -> None:
            nonlocal zoom, pan_x, pan_y
            new_zoom = min(ZOOM_LEVELS, key=lambda level: abs(level - new_zoom))
            if new_zoom == zoom:
                return
            focus = focus or map_rect.center
            old_size = cell_size()
            world_x = (focus[0] - MAP_ORIGIN[0] - pan_x) / old_size
            world_y = (focus[1] - MAP_ORIGIN[1] - pan_y) / old_size
            zoom = new_zoom
            pan_x = round(focus[0] - MAP_ORIGIN[0] - world_x * cell_size())
            pan_y = round(focus[1] - MAP_ORIGIN[1] - world_y * cell_size())
            clamp_pan()

        def pan_by(dx: int, dy: int) -> None:
            nonlocal pan_x, pan_y
            pan_x += dx
            pan_y += dy
            clamp_pan()

        def reset_view() -> None:
            nonlocal zoom, pan_x, pan_y
            zoom = 1
            pan_x = pan_y = 0

        def cell_screen_rect(x: int, y: int):
            tower_map = current_map()
            return pygame.Rect(
                MAP_ORIGIN[0] + pan_x + (tower_map.x_offsets[selected_floor] + x) * cell_size(),
                MAP_ORIGIN[1] + pan_y + (tower_map.y_offsets[selected_floor] + y) * cell_size(),
                cell_size(),
                cell_size(),
            )

        def ensure_selection_visible() -> None:
            nonlocal pan_x, pan_y
            rectangle = cell_screen_rect(selected_x, selected_y)
            pan_x += reveal_interval_delta(
                rectangle.left, rectangle.right, map_rect.left, map_rect.right
            )
            pan_y += reveal_interval_delta(
                rectangle.top, rectangle.bottom, map_rect.top, map_rect.bottom
            )
            clamp_pan()

        def move_cursor_relative(*, lateral: int = 0, forward: int = 0) -> None:
            nonlocal selected_x, selected_y
            selected_x, selected_y = move_in_view_direction(
                selected_x,
                selected_y,
                facing,
                lateral=lateral,
                forward=forward,
            )
            clamp_selection()
            ensure_selection_visible()

        def current_first_person_surface():
            nonlocal preview_cache_key, preview_surface, preview_error
            key = (
                selected_tower,
                selected_floor,
                selected_x,
                selected_y,
                facing,
                preview_revision,
                int(use_modified_art),
                *(int(overlays[name]) for name in OVERLAY_NAMES),
            )
            if key == preview_cache_key:
                return preview_surface
            try:
                placements = map_view_placements(
                    current_map(),
                    selected_floor,
                    selected_x,
                    selected_y,
                    facing,
                )
                pattern_parity = dungeon_pattern_parity(
                    selected_x,
                    selected_y,
                    facing,
                )
                # The real movement code never leaves a party inside a type-1
                # main wall.  When the editor cursor is there, its sealed
                # player-cell fallback must also suppress the object pass so
                # distant shelf objects cannot leak through.
                viewer_cell = current_cell()
                viewer_in_main_wall = (
                    viewer_cell is not None and viewer_cell.map_type == 1
                )
                # Map markers retain AMOS's lead-only $FF convention, while
                # the dungeon renderer expands the lead's second through
                # fourth packed/live team members at that shared location.
                actor_records = [
                    occupant
                    for occupant in project.render_occupants(selected_tower)
                    if (
                        overlays["SPELLS"]
                        if occupant.is_spell
                        else overlays["MONSTERS"]
                    )
                ]
                displayed_champions = project.viewer_champions(
                    selected_tower,
                    quickstart_teams=overlays["QS TEAMS"],
                ) if overlays["CHAMPIONS"] else ()
                quickstart_members = {
                    champion
                    for party in project.player_parties(selected_tower)
                    if party.source == "quickstart"
                    for champion in party.champions
                }
                # In a raw Quickstart view the parties below supply the
                # team-slot mini-spaces. Keep their original-location
                # counterparts off the 3D compositor to avoid drawing them
                # twice at the party lead position.
                character_records = (
                    tuple(
                        champion
                        for champion in displayed_champions
                        if champion.index not in quickstart_members
                    )
                    if quickstart_members and overlays["QS TEAMS"]
                    else displayed_champions
                )
                actor_records.extend(
                    champion_occupant_record(champion)
                    for champion in character_records
                )
                actor_records.extend(
                    MonsterRecord(
                        index=champion,
                        category=0,
                        floor=party.floor,
                        x=party.x,
                        y=party.y,
                        level=0,
                        form=champion,
                        team=0xFF,
                        source=party.source,
                        # Draw_PlayerOccupant applies the active player's one
                        # shared direction to every member of that party.
                        facing=party.facing,
                        # The original party renderer chooses the four
                        # mini-spaces from the member's team slot. Reusing
                        # the explicit slot keeps the composition stable as
                        # the editor cursor/view direction changes.
                        formation_slot=slot,
                    )
                    for party in project.player_parties(selected_tower)
                    if (
                        overlays["QS TEAMS"]
                        if party.source == "quickstart"
                        else overlays["PLAYERS"]
                    )
                    for slot, champion in enumerate(party.champions)
                )
                actor_draws = []
                for occupant in actor_records:
                    if occupant.floor != selected_floor or not occupant.has_position:
                        continue
                    view_position = occupant_view_position(
                        occupant,
                        player_x=selected_x,
                        player_y=selected_y,
                        player_facing=facing,
                        formation_index=occupant.formation_slot,
                    )
                    if view_position is None:
                        continue
                    screen_position = resolve_monster_screen_position(*view_position)
                    if screen_position is not None:
                        actor_draws.append((screen_position, occupant))

                monster_definitions = {definition.code: definition for definition in MONSTERS}
                actors_by_view_cell: dict[int, list[tuple[object, MonsterRecord]]] = {}
                for screen_position, occupant in actor_draws:
                    actors_by_view_cell.setdefault(screen_position.view_cell, []).append(
                        (screen_position, occupant)
                    )

                object_draws_by_view_cell: dict[int, list[object]] = {}
                if (
                    overlays["OBJECTS"]
                    and object_assets is not None
                    and not viewer_in_main_wall
                ):
                    visible_map_cells = {
                        relative_map_coordinate(
                            selected_x,
                            selected_y,
                            facing,
                            lateral,
                            -relative_y,
                        ): view_cell
                        for view_cell, (lateral, relative_y) in enumerate(
                            VIEW_CELL_COORDINATES
                        )
                    }
                    for stack in object_stack_records[selected_tower]:
                        location = object_stack_location(current_map(), stack)
                        if location is None:
                            continue
                        floor, object_x, object_y = location
                        view_cell = visible_map_cells.get((object_x, object_y))
                        if floor != selected_floor or view_cell is None:
                            continue
                        map_cell = current_map().cell(floor, object_x, object_y)
                        shelf = map_cell.map_type == 1 and map_cell.b & 3 == 0
                        shelf_facing = map_cell.c & 3 if shelf else None
                        for code, _quantity in stack.items:
                            projection = project_floor_object(
                                object_assets,
                                stack,
                                code,
                                view_cell=view_cell,
                                facing=facing,
                                shelf=shelf,
                                shelf_facing=shelf_facing,
                            )
                            if projection is not None:
                                object_draws_by_view_cell.setdefault(view_cell, []).append(
                                    projection
                                )

                def draw_cell_occupants(canvas, view_cell: int):
                    """Draw actors at the point their dungeon cell is painted.

                    ``Draw_DungeonCellOccupants`` uses render-state bits 4-5
                    for mini-space and the low bits for the character/monster
                    artwork-facing table. Packed records are unpacked with
                    that state byte clear.
                    """

                    for screen_position, occupant in sorted(
                        actors_by_view_cell.get(view_cell, ()),
                        key=lambda item: item[0].depth_slot,
                        reverse=True,
                    ):
                        relative_facing = occupant_relative_facing(occupant, facing)
                        if occupant.form <= 0x55 and character_assets is not None:
                            canvas, _ = render_character_preview(
                                canvas,
                                character_assets,
                                occupant.form,
                                distance=screen_position.gfx_slot,
                                facing=relative_facing,
                                anchor_x=screen_position.screen_x,
                                anchor_y=screen_position.screen_y,
                            )
                        elif occupant.form in monster_definitions:
                            definition = monster_definitions[occupant.form]
                            # The existing renderer validates grade indices.  A
                            # live/packed level can exceed the current extracted
                            # grade table, in which case the final available grade
                            # is the source-equivalent bounded display fallback.
                            grade_count = 1
                            renderer = monster_assets.get(
                                monster_renderer_key(definition.renderer)
                            )
                            if renderer is not None:
                                if hasattr(renderer, "grade_lookup"):
                                    grade_count = len(renderer.grade_lookup)
                                elif definition.renderer != "entropy":
                                    colour_file = {
                                        "summon": "summon.colours",
                                        "behemoth": "behemoth.colours",
                                        "crab": "crab.colours",
                                        "dragon_large": "dragon.colours",
                                        "dragon_small": "dragon.colours",
                                    }.get(definition.renderer)
                                    if colour_file is not None:
                                        grade_count = max(1, len((monsters_dir / colour_file).read_bytes()))
                            canvas, _ = render_monster_preview(
                                canvas,
                                definition,
                                monster_assets,
                                distance=screen_position.gfx_slot,
                                facing=relative_facing,
                                grade_step=min(occupant.colour_grade_step, grade_count - 1),
                                animation_frame=0,
                                anchor_x=screen_position.screen_x,
                                anchor_y=screen_position.screen_y,
                                illusion=occupant.is_illusion,
                            )
                        elif 0x80 <= occupant.form <= 0x8F and spell_assets is not None:
                            canvas, _ = render_airbourne_spell(
                                canvas,
                                spell_assets,
                                occupant.form,
                                distance=screen_position.gfx_slot,
                                anchor_x=screen_position.screen_x,
                                anchor_y=screen_position.screen_y,
                            )
                    return canvas

                def draw_object_kind(canvas, view_cell: int, *, shelf: bool):
                    """Draw one source placement class at its scene phase.

                    ``adrCd00960A`` reaches ``Draw_ObjectOnFloor`` before
                    the map-cell feature dispatch. Shelf placements use the
                    separate shelf tables, so they are drawn after their
                    selected shelf face but before later, nearer view cells.
                    """

                    for projection in object_draws_by_view_cell.get(view_cell, ()):
                        if projection.shelf != shelf:
                            continue
                        sprite = object_assets.floor_sprite(
                            projection.code, projection.projection
                        )
                        if sprite is not None:
                            blit(canvas, sprite.pixels, projection.x, projection.y)
                    return canvas

                def draw_floor_objects(canvas, view_cell: int):
                    return draw_object_kind(canvas, view_cell, shelf=False)

                def draw_shelf_objects(canvas, view_cell: int):
                    return draw_object_kind(canvas, view_cell, shelf=True)

                pixels, _scene_metadata = render_dungeon_scene(
                    dungeon_backgrounds[pattern_parity],
                    dungeon_assets,
                    placements,
                    pattern_parity=pattern_parity,
                    draw_floor_objects=draw_floor_objects,
                    draw_shelf_objects=draw_shelf_objects,
                    draw_occupants=draw_cell_occupants,
                )
                native = indexed_to_surface(pygame, pixels)
                preview_surface = pygame.transform.scale(
                    native,
                    (FIRST_PERSON_RECT[2], FIRST_PERSON_RECT[3]),
                )
                preview_error = None
            except (OSError, ValueError, RuntimeError, IndexError) as error:
                preview_surface = None
                preview_error = str(error)
            preview_cache_key = key
            return preview_surface

        def rendered_cell(cell: MapCell):
            key = (cell.first, cell.second)
            image = cell_cache.get(key)
            if image is None:
                image = pygame.Surface((CELL_SIZE, CELL_SIZE))
                draw_map_cell(image, image.get_rect(), cell)
                glyph = cell_glyph(cell)
                if glyph is not None:
                    from tools.st_planar_assets import GAME_PALETTE_RGB8

                    game_font.draw_map_glyph(image, glyph[0], GAME_PALETTE_RGB8[glyph[1]])
                cell_cache[key] = image
            if zoom == 1:
                return image
            return pygame.transform.scale(image, (cell_size(), cell_size()))

        def draw_layout_floor(
            floor: int,
            *,
            colour: tuple[int, int, int],
            alpha: int,
            pixel_shift: tuple[int, int] = (0, 0),
            issue_cells: set[tuple[int, int, int]],
        ) -> None:
            """Draw one floor's geometry and elevation-only AMOS symbols."""

            tower_map = current_map()
            if not tower_map.floor_exists(floor):
                return
            layer = pygame.Surface((MAP_SIZE, MAP_SIZE), pygame.SRCALPHA)
            size = cell_size()
            shift_x, shift_y = pixel_shift
            left = pan_x + tower_map.x_offsets[floor] * size + shift_x
            top = pan_y + tower_map.y_offsets[floor] * size + shift_y
            width = tower_map.widths[floor]
            height = tower_map.heights[floor]
            grid_colour = (*colour, alpha)
            for x in range(width + 1):
                pygame.draw.line(
                    layer,
                    grid_colour,
                    (left + x * size, top),
                    (left + x * size, top + height * size),
                    max(1, zoom),
                )
            for y in range(height + 1):
                pygame.draw.line(
                    layer,
                    grid_colour,
                    (left, top + y * size),
                    (left + width * size, top + y * size),
                    max(1, zoom),
                )
            pygame.draw.rect(
                layer,
                (*colour, min(255, alpha + 70)),
                (left, top, width * size, height * size),
                max(1, zoom * 2),
            )
            for y in range(height):
                for x in range(width):
                    cell = tower_map.cell(floor, x, y)
                    if not is_layout_elevation_cell(cell):
                        continue
                    icon = rendered_cell(cell).copy()
                    icon.set_colorkey((0, 0, 0))
                    icon.set_alpha(alpha if floor != selected_floor else 255)
                    target = pygame.Rect(
                        left + x * size,
                        top + y * size,
                        size,
                        size,
                    )
                    layer.blit(icon, target)
                    if (floor, x, y) in issue_cells:
                        pygame.draw.rect(
                            layer,
                            (245, 62, 55, 255),
                            target.inflate(-max(2, zoom * 2), -max(2, zoom * 2)),
                            max(2, zoom * 2),
                        )
            screen.blit(layer, MAP_ORIGIN)

        def draw_layout_stair_links() -> None:
            """Join verified stairs on the selected and visible adjacent floor."""

            tower_map = current_map()
            size = cell_size()

            def endpoint(floor: int, x: int, y: int) -> tuple[int, int] | None:
                if floor == selected_floor:
                    shift_x = shift_y = 0
                elif floor == selected_floor - 1 and layout_preview_below:
                    shift_x = shift_y = -2 * zoom
                elif floor == selected_floor + 1 and layout_preview_above:
                    shift_x = shift_y = 2 * zoom
                else:
                    return None
                return (
                    pan_x
                    + (tower_map.x_offsets[floor] + x) * size
                    + shift_x
                    + size // 2,
                    pan_y
                    + (tower_map.y_offsets[floor] + y) * size
                    + shift_y
                    + size // 2,
                )

            layer = pygame.Surface((MAP_SIZE, MAP_SIZE), pygame.SRCALPHA)
            for link in stair_alignment_links(tower_map):
                start = endpoint(link.floor, link.x, link.y)
                end = endpoint(
                    link.target_floor,
                    link.target_x,
                    link.target_y,
                )
                if start is None or end is None:
                    continue
                pygame.draw.line(
                    layer,
                    (80, 225, 165, 210),
                    start,
                    end,
                    max(2, zoom * 2),
                )
                pygame.draw.circle(
                    layer, (180, 255, 220, 235), start, max(2, zoom * 2)
                )
                pygame.draw.circle(
                    layer, (180, 255, 220, 235), end, max(2, zoom * 2)
                )
            screen.blit(layer, MAP_ORIGIN)

        def draw_button(rectangle, label: str, *, active=False, enabled=True) -> None:
            hovered = rectangle.collidepoint(pygame.mouse.get_pos())
            colour = (
                (55, 108, 173)
                if active
                else (
                    (65, 70, 82)
                    if enabled and hovered
                    else ((49, 52, 61) if enabled else (40, 42, 48))
                )
            )
            pygame.draw.rect(screen, colour, rectangle, border_radius=4)
            text_colour = (245, 245, 245) if enabled else (110, 112, 118)
            label_font = small_font
            label_size = 17
            while (
                label_font.size(label)[0] > rectangle.width - 8
                and label_size > 10
            ):
                label_size -= 1
                label_font = pygame.font.SysFont(None, label_size)
            label_surface = label_font.render(label, True, text_colour)
            screen.blit(label_surface, label_surface.get_rect(center=rectangle.center))

        def draw_info(text: str, y: int, colour=(205, 208, 215), *, x: int = 810) -> None:
            screen.blit(small_font.render(text, True, colour), (x, y))

        def draw_fitted_preview(surface, rectangle) -> object:
            """Fit a native preview without stretching or covering its edges."""

            source_width, source_height = surface.get_size()
            scale = min(
                rectangle.width / source_width,
                rectangle.height / source_height,
            )
            size = (
                max(1, round(source_width * scale)),
                max(1, round(source_height * scale)),
            )
            target = pygame.Rect(0, 0, *size)
            target.center = rectangle.center
            screen.blit(pygame.transform.scale(surface, size), target)
            pygame.draw.rect(screen, (76, 101, 132), target, 1)
            return target

        def draw_actor_preview(surface, rectangle) -> object:
            """Draw source pixels at an integer scale without stretching them."""

            source_width, source_height = surface.get_size()
            scale = integer_preview_scale(
                (source_width, source_height), rectangle.size
            )
            target = pygame.Rect(
                0, 0, source_width * scale, source_height * scale
            )
            target.center = rectangle.center
            screen.blit(pygame.transform.scale(surface, target.size), target)
            pygame.draw.rect(screen, (76, 101, 132), target, 1)
            return target

        def draw_editor_row(
            row: CellEditorRow,
            rectangle,
            minus_rectangle,
            plus_rectangle,
            *,
            selected: bool,
            enabled: bool,
        ) -> None:
            hovered = rectangle.collidepoint(pygame.mouse.get_pos())
            background = (
                (48, 75, 108)
                if selected
                else ((43, 48, 59) if hovered else (32, 35, 42))
            )
            pygame.draw.rect(screen, background, rectangle, border_radius=3)
            pygame.draw.rect(
                screen,
                (76, 101, 132) if selected else (55, 59, 69),
                rectangle,
                1,
                border_radius=3,
            )
            label_colour = (145, 173, 205) if enabled else (95, 103, 116)
            value_colour = (235, 237, 241) if enabled else (120, 123, 132)
            draw_info(row.label, rectangle.top + 7, label_colour, x=rectangle.left + 8)
            value_font = small_font
            value_size = 17
            value_left = rectangle.left + 138
            max_width = minus_rectangle.left - value_left - 8
            while value_font.size(row.value)[0] > max_width and value_size > 11:
                value_size -= 1
                value_font = pygame.font.SysFont(None, value_size)
            value_surface = value_font.render(row.value, True, value_colour)
            screen.blit(
                value_surface,
                (value_left, rectangle.centery - value_surface.get_height() // 2),
            )
            draw_button(minus_rectangle, "-", enabled=enabled)
            draw_button(plus_rectangle, "+", enabled=enabled)

        def object_icon_surface(code: int):
            surface = object_icon_cache.get(code)
            if surface is None and object_assets is not None:
                sprite = object_assets.pocket_sprite(code)
                native = indexed_to_surface(pygame, sprite.pixels)
                surface = pygame.transform.scale(native, (32, 32))
                object_icon_cache[code] = surface
            return surface

        def draw_object_card(
            rectangle,
            code: int,
            quantity: int,
            *,
            active: bool,
        ) -> None:
            background = (48, 75, 108) if active else (32, 35, 42)
            border = (90, 145, 205) if active else (55, 59, 69)
            pygame.draw.rect(screen, background, rectangle, border_radius=4)
            pygame.draw.rect(screen, border, rectangle, 1, border_radius=4)
            icon = object_icon_surface(code)
            if icon is not None:
                icon_rect = icon.get_rect(
                    midtop=(rectangle.centerx, rectangle.top + 5)
                )
                screen.blit(icon, icon_rect)
            if object_assets is None:
                return
            definition = object_assets.definition(code)
            if icon is not None and definition.displays_quantity:
                quantity_text = f"{min(quantity, 99):02d}"
                quantity_scale = 2
                quantity_width = len(quantity_text) * 8 * quantity_scale
                game_font.draw(
                    screen,
                    quantity_text,
                    (
                        icon_rect.centerx - quantity_width // 2,
                        icon_rect.top
                        + (definition.quantity_cell_y or 0) * 2,
                    ),
                    GAME_PALETTE_RGB8[6],
                    scale=quantity_scale,
                )
            tiny_font = pygame.font.SysFont(None, 12)
            words = definition.name.split()
            lines: list[str] = []
            current = ""
            for word in words:
                candidate = f"{current} {word}".strip()
                if current and tiny_font.size(candidate)[0] > rectangle.width - 6:
                    lines.append(current)
                    current = word
                else:
                    current = candidate
            if current:
                lines.append(current)
            for line_index, line in enumerate(lines[:2]):
                label = tiny_font.render(line, True, (230, 232, 236))
                screen.blit(
                    label,
                    label.get_rect(
                        centerx=rectangle.centerx,
                        top=rectangle.top + 40 + line_index * 11,
                    ),
                )
            detail = tiny_font.render(
                f"${code:02X}  x{quantity}", True, (150, 180, 215)
            )
            screen.blit(
                detail,
                detail.get_rect(centerx=rectangle.centerx, bottom=rectangle.bottom - 4),
            )

        def draw_overlay_markers() -> None:
            tower_map = current_map()

            def marker(
                x: int,
                y: int,
                text: str,
                background_index: int,
                foreground_index: int,
                *,
                selected: bool = False,
            ) -> None:
                if not (0 <= x < tower_map.widths[selected_floor] and 0 <= y < tower_map.heights[selected_floor]):
                    return
                rectangle = cell_screen_rect(x, y)
                # AMOS fills its inclusive low-resolution rectangle from
                # (cell + 1, cell + 1) through (cell + 15, cell + 7): 15x7
                # logical pixels.  Map Y pixels are doubled in this view.
                marker_rect = pygame.Rect(
                    rectangle.left + zoom,
                    rectangle.top + zoom * 2,
                    zoom * 15,
                    zoom * 14,
                )
                background = (
                    CURSOR_COLOURS[(pygame.time.get_ticks() // 120) % len(CURSOR_COLOURS)]
                    if selected
                    else GAME_PALETTE_RGB8[background_index]
                )
                pygame.draw.rect(screen, background, marker_rect)
                # AMOS uses the original five-row GameFont in the inset map
                # area.  Retaining its 1x2 geometry keeps letters legible at
                # all map zoom levels without obscuring the cell's icon.
                glyph_scale = max(1, zoom)
                game_font.draw_map_glyph(
                    screen,
                    text,
                    GAME_PALETTE_RGB8[foreground_index],
                    x=marker_rect.left + max(1, zoom * 2),
                    # Letter overlays are one native pixel lower than the
                    # filled marker inset.  This matches the AMOS map's
                    # baseline without moving the marker itself.
                    y=marker_rect.top + zoom * 2,
                    scale=glyph_scale,
                )

            def marker_number(
                x: int, y: int, value: int, *, colour_index: int = 2
            ) -> None:
                """AMOS map overlays use transparent, two-digit reference BOBs."""

                if not (0 <= x < tower_map.widths[selected_floor] and 0 <= y < tower_map.heights[selected_floor]):
                    return
                rectangle = cell_screen_rect(x, y)
                glyph_scale = max(1, zoom)
                label = f"{value:02d}"
                for digit, character in enumerate(label):
                    game_font.draw_map_glyph(
                        screen,
                        character,
                        # The transparent reference BOB has a different
                        # origin from the filled letter markers: it begins
                        # one pixel left and two pixels lower. Source labels
                        # are dark grey; target labels match their outline.
                        GAME_PALETTE_RGB8[colour_index],
                        x=rectangle.left + digit * 7 * glyph_scale,
                        y=rectangle.top + zoom * 3,
                        scale=glyph_scale,
                    )

            def target_marker(
                source_x: int,
                source_y: int,
                target_x: int,
                target_y: int,
                reference: int,
                colour_index: int,
            ) -> None:
                """Draw a referenced target and, on request, its link."""

                source_rect = cell_screen_rect(source_x, source_y)
                target_rect = cell_screen_rect(target_x, target_y)
                if overlays["LINKS"]:
                    start, end = nearest_rectangle_edges(
                        tuple(source_rect), tuple(target_rect)
                    )
                    pygame.draw.line(
                        screen,
                        GAME_PALETTE_RGB8[colour_index],
                        start,
                        end,
                        max(2, zoom + 1),
                    )
                pygame.draw.rect(
                    screen,
                    GAME_PALETTE_RGB8[colour_index],
                    target_rect,
                    max(2, zoom),
                )
                marker_number(target_x, target_y, reference, colour_index=colour_index)

            if overlays["SWITCHES"] or overlays["TRIGGERS"]:
                for y in range(tower_map.heights[selected_floor]):
                    for x in range(tower_map.widths[selected_floor]):
                        cell = tower_map.cell(selected_floor, x, y)
                        if overlays["SWITCHES"] and cell.map_type == 1 and cell.b % 4 == 2 and cell.first >= 8:
                            reference = cell.first // 8
                            marker_number(x, y, reference)
                            resolved = resolved_record_reference(switch_records, reference)
                            if resolved is not None:
                                record_tower, record_reference = resolved
                                target = switch_records[record_tower][record_reference]
                            else:
                                target = None
                            if target is not None and target.action:
                                if 0 <= target.x < tower_map.widths[selected_floor] and 0 <= target.y < tower_map.heights[selected_floor]:
                                    target_marker(
                                        x, y, target.x, target.y, reference, 12
                                    )
                        if overlays["TRIGGERS"] and cell.map_type == 6 and cell.b % 8 in (2, 3, 6, 7):
                            reference = cell.first // 8
                            # Reference zero is the source's null/no-event
                            # trigger and is intentionally not marked.
                            if reference == 0:
                                continue
                            marker_number(x, y, reference)
                            resolved = resolved_record_reference(trigger_records, reference)
                            if resolved is not None:
                                record_tower, record_reference = resolved
                                target = trigger_records[record_tower][record_reference]
                                target_floor_matches = (
                                    target.floor == selected_floor
                                    if target.action in TRIGGER_FLOOR_ACTIONS
                                    else True
                                )
                                if target.action in TRIGGER_XY_ACTIONS and target_floor_matches:
                                    if 0 <= target.x < tower_map.widths[selected_floor] and 0 <= target.y < tower_map.heights[selected_floor]:
                                        target_marker(
                                            x, y, target.x, target.y, reference, 6
                                        )

            if overlays["CHAMPIONS"] or (selected_tab == 3 and actor_mode == "CHAMPIONS"):
                for champion in project.viewer_champions(
                    selected_tower,
                    quickstart_teams=overlays["QS TEAMS"],
                ):
                    if champion.floor == selected_floor:
                        marker(champion.x, champion.y, "C", 13, 0)

            marker_occupants = project.occupants(selected_tower)
            if selected_tab == 3 and actor_mode == "MONSTERS":
                # Team members share a marker position. Draw the selection
                # last so its flash cannot be covered by a later red member.
                marker_occupants = tuple(
                    sorted(
                        project.render_occupants(selected_tower),
                        key=lambda occupant: occupant.index == selected_monster,
                    )
                )
            for occupant in marker_occupants:
                if occupant.floor != selected_floor or not occupant.has_position:
                    continue
                if occupant.is_spell:
                    if overlays["SPELLS"]:
                        marker(occupant.x, occupant.y, "S", 7, 14)
                elif overlays["MONSTERS"] or (selected_tab == 3 and actor_mode == "MONSTERS"):
                    # AMOS uses bright red through form $64, then its darker
                    # red ink for the large-monster forms above it.
                    marker(
                        occupant.x,
                        occupant.y,
                        "M",
                        10 if occupant.form > 0x64 else 12,
                        0,
                        selected=(
                            selected_tab == 3
                            and actor_mode == "MONSTERS"
                            and occupant.index == selected_monster
                        ),
                    )

            if (overlays["OBJECTS"] or selected_tab == 2) and object_assets is not None:
                for stack_index, stack in enumerate(object_stack_records[selected_tower]):
                    location = object_stack_location(tower_map, stack)
                    if location is None:
                        continue
                    floor, object_x, object_y = location
                    if floor != selected_floor:
                        continue
                    offset = object_marker_offset(stack.position)
                    if offset is None:
                        continue
                    rectangle = cell_screen_rect(object_x, object_y)
                    centre = (
                        rectangle.left + offset[0] * zoom,
                        rectangle.top + offset[1] * zoom,
                    )
                    arm = max(1, zoom)
                    pygame.draw.line(
                        screen,
                        GAME_PALETTE_RGB8[14],
                        (centre[0] - arm, centre[1] - arm),
                        (centre[0] + arm, centre[1] + arm),
                        arm,
                    )
                    if selected_tab == 2 and stack_index == selected_object_stack:
                        flash_colour = CURSOR_COLOURS[
                            (pygame.time.get_ticks() // 120) % len(CURSOR_COLOURS)
                        ]
                        highlight_size = max(8, zoom * 8)
                        pygame.draw.rect(
                            screen,
                            flash_colour,
                            pygame.Rect(
                                centre[0] - highlight_size // 2,
                                centre[1] - highlight_size // 2,
                                highlight_size,
                                highlight_size,
                            ),
                            max(2, zoom),
                        )
                        pygame.draw.rect(
                            screen,
                            flash_colour,
                            rectangle.inflate(-2 * zoom, -2 * zoom),
                            max(2, zoom),
                        )
                    pygame.draw.line(
                        screen,
                        GAME_PALETTE_RGB8[14],
                        (centre[0] - arm, centre[1] + arm),
                        (centre[0] + arm, centre[1] - arm),
                        arm,
                    )
                    key_colours = tuple(
                        dict.fromkeys(
                            colour
                            for location_stack in object_stack_records[selected_tower]
                            if location_stack.map_index == stack.map_index
                            for colour in named_key_colour_indices(
                                object_assets, location_stack
                            )
                        )
                    )
                    if key_colours:
                        key_colour = key_colours[
                            (pygame.time.get_ticks() // 650) % len(key_colours)
                        ]
                        dot_size = max(4, zoom * 4)
                        pygame.draw.rect(
                            screen,
                            GAME_PALETTE_RGB8[key_colour],
                            pygame.Rect(
                                rectangle.centerx - dot_size // 2,
                                rectangle.centery - dot_size // 2,
                                dot_size,
                                dot_size,
                            ),
                        )

            if overlays["PLAYERS"] or overlays["QS TEAMS"]:
                for party in project.player_parties(selected_tower):
                    if party.source == "quickstart" and not overlays["QS TEAMS"]:
                        continue
                    if party.source == "save" and not overlays["PLAYERS"]:
                        continue
                    if party.floor == selected_floor:
                        marker(
                            party.x,
                            party.y,
                            "P" if party.source == "save" else "Q",
                            8 if party.index == 0 else 10,
                            14,
                        )

        editor_rows: tuple[CellEditorRow, ...] = ()
        control_rects: tuple[tuple[int, str, str, object, object, object, bool], ...] = ()
        object_item_rects: tuple[tuple[int, object], ...] = ()
        monster_preview_member_rects: tuple[tuple[int, object], ...] = ()
        running = True
        while running:
            mouse = pygame.mouse.get_pos()
            monster_preview_member_rects = ()
            screen.fill((24, 26, 31))
            screen.blit(
                title_font.render("Bloodwych Map Viewer / Editor", True, (240, 240, 245)),
                (20, 16),
            )
            draw_button(display_mode_rect, "WIN" if fullscreen else "FULL", active=not fullscreen)

            for index, (label, rectangle) in enumerate(zip(EDITOR_TABS, tab_rects)):
                draw_button(
                    rectangle,
                    label,
                    active=index == selected_tab,
                    enabled=EDITOR_TAB_ENABLED[index],
                )
            draw_button(
                art_rect,
                "ART: MODIFIED" if use_modified_art else "ART: CLEAN",
                active=use_modified_art,
                enabled=project.modified_root.is_dir(),
            )
            draw_button(source_rect, project.source_description, active=project.save_name is not None)

            for index, (tower, rectangle) in enumerate(zip(TOWERS, tower_rects)):
                draw_button(rectangle, tower.name, active=index == selected_tower)
            draw_info("FLOORS", 365, (170, 190, 220), x=20)
            for floor, rectangle in enumerate(floor_rects):
                draw_button(
                    rectangle,
                    str(floor),
                    active=floor == selected_floor,
                    enabled=(
                        current_map().floor_exists(floor)
                        or (selected_tab == 4 and floor <= current_map().top_floor)
                    ),
                )
            for action, rectangle in zoom_rects:
                label = {"ZOOM-": "ZOOM -", "ZOOM+": "ZOOM +", "FIT": "FIT"}[action]
                draw_button(rectangle, label, active=(action == "FIT" and zoom == 1))
            for action, rectangle in pan_rects:
                label = {"PAN-UP": "UP", "PAN-LEFT": "LEFT", "PAN-RIGHT": "RIGHT", "PAN-DOWN": "DOWN"}[action]
                draw_button(rectangle, label, enabled=can_pan())
            draw_info(f"ZOOM {zoom}X", 616, (150, 190, 225), x=20)

            pygame.draw.rect(screen, (5, 5, 7), map_rect)
            tower_map = current_map()
            if selected_tab == 4:
                issues = elevation_alignment_issues(tower_map)
                issue_cells = {(issue.floor, issue.x, issue.y) for issue in issues}
                if layout_preview_below and selected_floor > 0:
                    draw_layout_floor(
                        selected_floor - 1,
                        colour=(105, 118, 138),
                        alpha=90,
                        pixel_shift=(-2 * zoom, -2 * zoom),
                        issue_cells=issue_cells,
                    )
                if layout_preview_above and selected_floor < tower_map.top_floor:
                    draw_layout_floor(
                        selected_floor + 1,
                        colour=(135, 152, 178),
                        alpha=90,
                        pixel_shift=(2 * zoom, 2 * zoom),
                        issue_cells=issue_cells,
                    )
                draw_layout_floor(
                    selected_floor,
                    colour=(75, 142, 180),
                    alpha=175,
                    issue_cells=issue_cells,
                )
                if layout_link_lines:
                    draw_layout_stair_links()
            elif tower_map.floor_exists(selected_floor):
                old_clip = screen.get_clip()
                screen.set_clip(map_rect)
                for y in range(tower_map.heights[selected_floor]):
                    for x in range(tower_map.widths[selected_floor]):
                        rectangle = cell_screen_rect(x, y)
                        if rectangle.colliderect(map_rect):
                            screen.blit(rendered_cell(tower_map.cell(selected_floor, x, y)), rectangle)
                            # AMOS hires map pixels are 1x2 in this square-pixel
                            # preview: vertical grid strokes are one pixel wide,
                            # while horizontal strokes occupy one logical
                            # (two physical) rows.
                            pygame.draw.rect(
                                screen,
                                (38, 55, 63),
                                (rectangle.left, rectangle.top, max(1, zoom), rectangle.height),
                            )
                            pygame.draw.rect(
                                screen,
                                (38, 55, 63),
                                (rectangle.left, rectangle.top, rectangle.width, max(2, zoom * 2)),
                            )
                draw_overlay_markers()
                cursor_colour = CURSOR_COLOURS[(pygame.time.get_ticks() // 120) % len(CURSOR_COLOURS)]
                pygame.draw.rect(
                    screen,
                    cursor_colour,
                    cell_screen_rect(selected_x, selected_y),
                    max(2, zoom),
                )
                cursor_rect = cell_screen_rect(selected_x, selected_y)
                direction_x, direction_y = FORWARD_VECTORS[facing]
                arrow_length = max(4, cursor_rect.width // 3)
                arrow_start = cursor_rect.center
                arrow_end = (
                    arrow_start[0] + direction_x * arrow_length,
                    arrow_start[1] + direction_y * arrow_length,
                )
                pygame.draw.line(
                    screen,
                    cursor_colour,
                    arrow_start,
                    arrow_end,
                    max(2, zoom),
                )
                pygame.draw.circle(screen, cursor_colour, arrow_end, max(2, zoom))
                screen.set_clip(old_clip)
            pygame.draw.rect(screen, (86, 91, 104), map_border_rect, 1)

            if selected_tab == 4:
                draw_info("BLUE: CURRENT FLOOR", 632, (115, 190, 225), x=MAP_ORIGIN[0])
                draw_info("TRANSLUCENT: ADJACENT FLOOR", 650, (145, 155, 175), x=MAP_ORIGIN[0])
                draw_info("RED: ELEVATION LINK NEEDS REVIEW", 668, (245, 90, 80), x=MAP_ORIGIN[0])
                if layout_link_lines:
                    draw_info("GREEN: VERIFIED STAIR PAIR", 686, (80, 225, 165), x=MAP_ORIGIN[0])
            else:
                for name, enabled, rectangle in zip(
                    main_overlay_names + ("LINKS",), OVERLAY_ENABLED, overlay_rects
                ):
                    draw_button(
                        rectangle,
                        name,
                        active=overlays[name],
                        enabled=enabled and (name != "QS TEAMS" or project.save_data is None),
                    )

            cell = current_cell()
            screen.blit(title_font.render(TOWERS[selected_tower].name, True, (255, 220, 80)), (810, 108))
            if selected_tab == 1:
                for action, label, rectangle in map_operation_rects:
                    draw_button(
                        rectangle,
                        label,
                        enabled=(action != "PASTE" or copied_cell is not None),
                    )
            elif selected_tab == 2:
                for action, label, rectangle in object_operation_rects:
                    enabled = action in ("FIND", "AUTO-SELECT") or object_resource_editable()
                    if action in (
                        "DELETE-STACK",
                        "ADD-ITEM",
                        "DELETE-ITEM",
                        "MOVE-HERE",
                        "FIND",
                    ):
                        enabled = enabled and current_object_stack() is not None
                    if action == "DELETE-ITEM" and current_object_stack() is not None:
                        enabled = enabled and len(current_object_stack().items) > 1
                    draw_button(
                        rectangle,
                        (
                            f"AUTO SELECT: {'ON' if object_auto_select else 'OFF'}"
                            if action == "AUTO-SELECT"
                            else label
                        ),
                        active=action == "AUTO-SELECT" and object_auto_select,
                        enabled=enabled,
                    )
            elif selected_tab == 4:
                draw_button(
                    layout_clear_rect,
                    (
                        "CONFIRM CLEAR"
                        if layout_clear_armed == (selected_tower, selected_floor)
                        else "CLEAR FLOOR"
                    ),
                    active=layout_clear_armed == (selected_tower, selected_floor),
                    enabled=selected_tower not in project.save_map_fallbacks,
                )
                draw_button(
                    layout_links_rect,
                    f"LINKS: {'ON' if layout_link_lines else 'OFF'}",
                    active=layout_link_lines,
                )
            draw_info(f"FLOOR {selected_floor}", 140, (150, 200, 255))
            draw_info(f"SIZE {tower_map.widths[selected_floor]:02d} x {tower_map.heights[selected_floor]:02d}", 160, (180, 185, 195))
            draw_info(f"ALIGN {tower_map.x_offsets[selected_floor]:02d}, {tower_map.y_offsets[selected_floor]:02d}", 180, (180, 185, 195))
            draw_info(f"FREE ${tower_map.free_map_bytes:03X}", 200, (180, 185, 195))
            if cell is not None and selected_tab != 4:
                draw_info(f"X ${selected_x:02X}   Y ${selected_y:02X}", 228, (245, 245, 245))
                draw_info(f"RAW ${cell.first:02X} ${cell.second:02X}   A{cell.a:X} B{cell.b:X} C{cell.c:X} D{cell.d:X}", 248, (165, 170, 180))
                draw_info(MAP_TYPE_NAMES[cell.map_type], 274, (150, 200, 255))
                description = describe_cell(cell)
                draw_info(description, 294)
                if selected_tab == 0 and cell.map_type == 1 and cell.b & 3 == 2 and cell.first >= 8:
                    reference = cell.first // 8
                    resolved = resolved_record_reference(switch_records, reference)
                    if resolved is not None:
                        record_tower, record_reference = resolved
                        record = switch_records[record_tower][record_reference]
                        action = SWITCH_ACTIONS.get(record.action, f"UNKNOWN ${record.action:02X}")
                        draw_info(f"SWITCH {reference}: {action} -> X ${record.x:02X}, Y ${record.y:02X}", 312, (235, 200, 105))
                        if project.save_data is not None:
                            draw_info("SHARED TABLE IS OUTSIDE THE SAVE (READ ONLY)", 330, (165, 170, 180))
                elif selected_tab == 0 and cell.map_type == 6 and cell.b & 3 in (2, 3):
                    reference = cell.first // 8
                    resolved = resolved_record_reference(trigger_records, reference)
                    if resolved is not None:
                        record_tower, record_reference = resolved
                        record = trigger_records[record_tower][record_reference]
                        action = TRIGGER_ACTIONS.get(record.action, f"UNKNOWN ${record.action:02X}")
                        draw_info(f"TRIGGER {reference}: {action}", 312, (110, 230, 145))
                        if record.action in TRIGGER_XY_ACTIONS:
                            prefix = f"TARGET FLOOR {record.floor}, " if record.action in TRIGGER_FLOOR_ACTIONS else "TARGET "
                            draw_info(f"{prefix}X ${record.x:02X}, Y ${record.y:02X}", 330, (110, 230, 145))
                        elif project.save_data is not None:
                            draw_info("SHARED TABLE IS OUTSIDE THE SAVE (READ ONLY)", 330, (165, 170, 180))

            if selected_tab == 1:
                base_rows = list(editor_rows_for_cell(cell)) if cell is not None else []
                shared_rows: list[CellEditorRow] = []
                shared_heading = ""
                if cell is not None:
                    if cell.map_type == 1 and cell.b & 3 == 2 and cell.first >= 8:
                        reference = cell.first // 8
                        resolved = resolved_record_reference(switch_records, reference)
                        if resolved is not None:
                            record_tower, record_reference = resolved
                            record = switch_records[record_tower][record_reference]
                            shared_heading = f"SHARED SWITCH {reference}"
                            if record_tower != selected_tower:
                                shared_heading += (
                                    f"  >  {TOWERS[record_tower].name} {record_reference}"
                                )
                            shared_rows.extend((
                                CellEditorRow(
                                    "ACTION",
                                    SWITCH_ACTIONS.get(record.action, f"UNKNOWN ${record.action:02X}"),
                                    "SWITCH-ACTION-",
                                    "SWITCH-ACTION+",
                                ),
                                CellEditorRow("TARGET X", f"${record.x:02X}", "SWITCH-X-", "SWITCH-X+"),
                                CellEditorRow("TARGET Y", f"${record.y:02X}", "SWITCH-Y-", "SWITCH-Y+"),
                            ))
                    elif cell.map_type == 6 and cell.b & 3 in (2, 3) and cell.first // 8:
                        reference = cell.first // 8
                        resolved = resolved_record_reference(trigger_records, reference)
                        if resolved is not None:
                            record_tower, record_reference = resolved
                            record = trigger_records[record_tower][record_reference]
                            shared_heading = f"SHARED TRIGGER {reference}"
                            if record_tower != selected_tower:
                                shared_heading += (
                                    f"  >  {TOWERS[record_tower].name} {record_reference}"
                                )
                            shared_rows.append(
                                CellEditorRow(
                                    "ACTION",
                                    TRIGGER_ACTIONS.get(record.action, f"UNKNOWN ${record.action:02X}"),
                                    "TRIGGER-ACTION-",
                                    "TRIGGER-ACTION+",
                                )
                            )
                            if record.action in TRIGGER_FLOOR_ACTIONS | TRIGGER_DESTINATION_ACTIONS:
                                label = (
                                    "DESTINATION"
                                    if record.action in TRIGGER_DESTINATION_ACTIONS
                                    else "TARGET FLOOR"
                                )
                                shared_rows.append(
                                    CellEditorRow(
                                        label,
                                        trigger_parameter_label(record.action, record.floor),
                                        "TRIGGER-FLOOR-",
                                        "TRIGGER-FLOOR+",
                                    )
                                )
                            if record.action in TRIGGER_XY_ACTIONS:
                                shared_rows.extend((
                                    CellEditorRow("TARGET X", f"${record.x:02X}", "TRIGGER-X-", "TRIGGER-X+"),
                                    CellEditorRow("TARGET Y", f"${record.y:02X}", "TRIGGER-Y-", "TRIGGER-Y+"),
                                ))
                editor_rows = tuple(base_rows + shared_rows)
                if selected_editor_row is not None and editor_rows:
                    selected_editor_row = min(selected_editor_row, len(editor_rows) - 1)
                draw_info("CELL PROPERTIES", 322, (150, 200, 255))
                draw_info("CLICK ROW; LEFT / RIGHT TO CHANGE", 322, (135, 142, 154), x=956)
                row_layout = []
                for index, row in enumerate(editor_rows):
                    shared_index = index - len(base_rows)
                    row_top = 342 + index * 30
                    if shared_index >= 0:
                        row_top += 34
                    rectangle = pygame.Rect(810, row_top, 380, 27)
                    minus_rectangle = pygame.Rect(1130, row_top + 2, 26, 23)
                    plus_rectangle = pygame.Rect(1160, row_top + 2, 26, 23)
                    enabled = shared_index < 0 or project.save_data is None
                    row_layout.append(
                        (
                            index,
                            row.decrement_action,
                            row.increment_action,
                            rectangle,
                            minus_rectangle,
                            plus_rectangle,
                            enabled,
                        )
                    )
                control_rects = tuple(row_layout)
                if shared_rows:
                    shared_y = 342 + len(base_rows) * 30 + 7
                    draw_info(shared_heading, shared_y, (235, 200, 105))
                    warning = (
                        "READ ONLY IN SAVE VIEW"
                        if project.save_data is not None
                        else "EDITING CHANGES EVERY CELL USING THIS FUNCTION"
                    )
                    draw_info(warning, shared_y + 16, (165, 170, 180))
                for index, _, _, rectangle, minus_rectangle, plus_rectangle, enabled in control_rects:
                    draw_editor_row(
                        editor_rows[index],
                        rectangle,
                        minus_rectangle,
                        plus_rectangle,
                        selected=index == selected_editor_row,
                        enabled=enabled,
                    )
                draw_button(save_rect, save_button_label, active=project.has_changes)
            elif selected_tab == 4:
                editor_rows = (
                    CellEditorRow(
                        "HIGHEST FLOOR",
                        f"{tower_map.top_floor}  ({tower_map.top_floor + 1} FLOORS)",
                        "LAYOUT-TOP-",
                        "LAYOUT-TOP+",
                    ),
                    CellEditorRow(
                        "WIDTH",
                        str(tower_map.widths[selected_floor]),
                        "LAYOUT-WIDTH-",
                        "LAYOUT-WIDTH+",
                    ),
                    CellEditorRow(
                        "HEIGHT",
                        str(tower_map.heights[selected_floor]),
                        "LAYOUT-HEIGHT-",
                        "LAYOUT-HEIGHT+",
                    ),
                    CellEditorRow(
                        "X OFFSET",
                        str(tower_map.x_offsets[selected_floor]),
                        "LAYOUT-X-",
                        "LAYOUT-X+",
                    ),
                    CellEditorRow(
                        "Y OFFSET",
                        str(tower_map.y_offsets[selected_floor]),
                        "LAYOUT-Y-",
                        "LAYOUT-Y+",
                    ),
                    CellEditorRow(
                        "VIEW ABOVE",
                        "ON" if layout_preview_above else "OFF",
                        "LAYOUT-ABOVE-",
                        "LAYOUT-ABOVE+",
                    ),
                    CellEditorRow(
                        "VIEW BELOW",
                        "ON" if layout_preview_below else "OFF",
                        "LAYOUT-BELOW-",
                        "LAYOUT-BELOW+",
                    ),
                )
                draw_info("FLOOR LAYOUT", 322, (150, 200, 255))
                draw_info("WORLD-ALIGNED FLOOR GEOMETRY", 322, (135, 142, 154), x=950)
                layout_editable = selected_tower not in project.save_map_fallbacks
                row_layout = []
                for index, row in enumerate(editor_rows):
                    row_top = 342 + index * 30
                    rectangle = pygame.Rect(810, row_top, 380, 27)
                    minus_rectangle = pygame.Rect(1130, row_top + 2, 26, 23)
                    plus_rectangle = pygame.Rect(1160, row_top + 2, 26, 23)
                    enabled = layout_editable or index >= 5
                    row_layout.append(
                        (
                            index,
                            row.decrement_action,
                            row.increment_action,
                            rectangle,
                            minus_rectangle,
                            plus_rectangle,
                            enabled,
                        )
                    )
                control_rects = tuple(row_layout)
                for index, _, _, rectangle, minus_rectangle, plus_rectangle, enabled in control_rects:
                    draw_editor_row(
                        editor_rows[index],
                        rectangle,
                        minus_rectangle,
                        plus_rectangle,
                        selected=index == selected_editor_row,
                        enabled=enabled,
                    )
                current_issues = [
                    issue
                    for issue in elevation_alignment_issues(tower_map)
                    if issue.floor == selected_floor
                ]
                draw_info(
                    f"USED ${tower_map.used_map_bytes:03X} / ${0x1000 - 0x38:03X}   FREE ${tower_map.free_map_bytes:03X}",
                    560,
                    (160, 190, 215),
                )
                issue_colour = (245, 90, 80) if current_issues else (135, 205, 150)
                draw_info(
                    f"ELEVATION CHECK: {len(current_issues)} ISSUE{'S' if len(current_issues) != 1 else ''} ON THIS FLOOR",
                    582,
                    issue_colour,
                )
                if current_issues:
                    issue = current_issues[0]
                    draw_info(
                        f"FIRST: X {issue.x}, Y {issue.y}",
                        604,
                        (235, 150, 120),
                    )
                    draw_info(issue.reason, 622, (235, 150, 120))
                draw_info(
                    "CLEAR FLOOR ZEROS MAP CELLS; OBJECT STACKS REMAIN.",
                    650,
                    (145, 150, 160),
                )
                draw_info(
                    "GREEN LINES JOIN VERIFIED STAIR PAIRS.",
                    668,
                    (145, 150, 160),
                )
                draw_info(
                    "RED MARKS ARE GUIDANCE AND DO NOT BLOCK SAVING.",
                    686,
                    (145, 150, 160),
                )
                draw_button(save_rect, save_button_label, active=project.has_changes)
            elif selected_tab == 0:
                draw_info("LIVE DUNGEON VIEW FROM THE MAP CURSOR", 350, (150, 200, 255))
                draw_info(
                    f"FACING {FACING_NAMES[facing]}   Q/E: TURN   W/A/S/D: MOVE",
                    374,
                    (195, 198, 208),
                )
                preview_rect = pygame.Rect(FIRST_PERSON_RECT)
                pygame.draw.rect(screen, (4, 4, 6), preview_rect)
                live_preview = current_first_person_surface()
                if live_preview is not None:
                    screen.blit(live_preview, preview_rect)
                elif preview_error:
                    for line_index, line in enumerate(
                        (preview_error[index : index + 45] for index in range(0, len(preview_error), 45))
                    ):
                        draw_info(line.upper(), preview_rect.top + 12 + line_index * 18, (245, 135, 120))
                pygame.draw.rect(screen, (86, 110, 142), preview_rect.inflate(2, 2), 1)
                draw_info(
                    "SCENERY + VERIFIED CHARACTER, MONSTER AND SPELL GFX.",
                    preview_rect.bottom + 12,
                    (145, 150, 160),
                )
            elif selected_tab == 2:
                stacks = object_stack_records[selected_tower]
                object_item_rects = ()
                draw_info("OBJECT STACK", 322, (150, 200, 255))
                definition_count = (
                    len(object_assets.definitions) if object_assets is not None else 0
                )
                draw_info(
                    f"{definition_count} SOURCE-EXTRACTED OBJECT DEFINITIONS",
                    322,
                    (135, 142, 154),
                    x=925,
                )
                if not stacks:
                    editor_rows = ()
                    control_rects = ()
                    draw_info("NO OBJECT STACKS IN THIS TOWER", 350, (235, 200, 105))
                    draw_info("USE +STK TO ADD ONE AT THE MAP CURSOR", 372, (165, 170, 180))
                elif object_assets is None:
                    editor_rows = ()
                    control_rects = ()
                    draw_info("OBJECT DEFINITION EXTRACTS ARE UNAVAILABLE", 350, (245, 135, 120))
                else:
                    selected_object_stack = min(selected_object_stack, len(stacks) - 1)
                    stack = stacks[selected_object_stack]
                    selected_object_item = min(
                        selected_object_item, len(stack.items) - 1
                    )
                    location = object_stack_location(tower_map, stack)
                    if location is None:
                        location_text = f"INVALID MAP OFFSET ${stack.map_index:03X}"
                        stacks_here = 0
                    else:
                        object_floor, object_x, object_y = location
                        stacks_here = len(
                            object_stack_indices_at_cell(
                                tower_map,
                                stacks,
                                object_floor,
                                object_x,
                                object_y,
                            )
                        )
                        location_text = (
                            f"FLOOR {object_floor} · X ${object_x:02X} Y ${object_y:02X}"
                            f" · {stacks_here} STACK{'S' if stacks_here != 1 else ''} HERE"
                        )
                    draw_info(location_text, 342, (205, 208, 215))
                    visible_count = min(5, len(stack.items))
                    first_item = max(
                        0,
                        min(
                            selected_object_item - 2,
                            len(stack.items) - visible_count,
                        ),
                    )
                    item_rectangles = []
                    for visible_index in range(visible_count):
                        item_index = first_item + visible_index
                        code, quantity = stack.items[item_index]
                        rectangle = pygame.Rect(
                            810 + visible_index * 76,
                            362,
                            72,
                            88,
                        )
                        draw_object_card(
                            rectangle,
                            code,
                            quantity,
                            active=item_index == selected_object_item,
                        )
                        item_rectangles.append((item_index, rectangle))
                    object_item_rects = tuple(item_rectangles)
                    if len(stack.items) > visible_count:
                        draw_info(
                            f"SHOWING {first_item + 1}-{first_item + visible_count} OF {len(stack.items)}",
                            452,
                            (135, 142, 154),
                        )
                    code, quantity = stack.items[selected_object_item]
                    definition = object_assets.definition(code)
                    editor_rows = (
                        CellEditorRow(
                            "STACK",
                            f"{selected_object_stack + 1} / {len(stacks)}",
                            "STACK-",
                            "STACK+",
                        ),
                        CellEditorRow(
                            "POSITION",
                            object_position_name(tower_map, stack),
                            "POSITION-",
                            "POSITION+",
                        ),
                        CellEditorRow(
                            "ITEM",
                            f"{selected_object_item + 1} / {len(stack.items)}",
                            "ITEM-",
                            "ITEM+",
                        ),
                        CellEditorRow(
                            "SEQUENCE",
                            f"{selected_object_item + 1} / {len(stack.items)}",
                            "SEQUENCE-",
                            "SEQUENCE+",
                        ),
                        CellEditorRow(
                            "OBJECT",
                            f"${code:02X} {definition.name}",
                            "OBJECT-",
                            "OBJECT+",
                        ),
                        CellEditorRow(
                            "QUANTITY",
                            str(quantity),
                            "QUANTITY-",
                            "QUANTITY+",
                        ),
                    )
                    if selected_editor_row is not None:
                        selected_editor_row = min(
                            selected_editor_row, len(editor_rows) - 1
                        )
                    row_layout = []
                    for index, row in enumerate(editor_rows):
                        row_top = 466 + index * 30
                        rectangle = pygame.Rect(810, row_top, 380, 27)
                        minus_rectangle = pygame.Rect(1130, row_top + 2, 26, 23)
                        plus_rectangle = pygame.Rect(1160, row_top + 2, 26, 23)
                        row_layout.append(
                            (
                                index,
                                row.decrement_action,
                                row.increment_action,
                                rectangle,
                                minus_rectangle,
                                plus_rectangle,
                                object_resource_editable(),
                            )
                        )
                    control_rects = tuple(row_layout)
                    for (
                        index,
                        _,
                        _,
                        rectangle,
                        minus_rectangle,
                        plus_rectangle,
                        enabled,
                    ) in control_rects:
                        draw_editor_row(
                            editor_rows[index],
                            rectangle,
                            minus_rectangle,
                            plus_rectangle,
                            selected=index == selected_editor_row,
                            enabled=enabled,
                        )
                draw_button(save_rect, save_button_label, active=project.has_changes)
            elif selected_tab == 3:
                for mode, rectangle in actor_mode_rects:
                    draw_button(rectangle, mode, active=actor_mode == mode)
                draw_info("CHARACTERS / MONSTERS", 322, (150, 200, 255))
                row_layout = []
                preview_rect = pygame.Rect(810, 360, 380, 178)
                pygame.draw.rect(screen, (4, 4, 6), preview_rect)
                if actor_mode == "CHAMPIONS":
                    record = ChampionRecord(selected_champion, project.champion_record_bytes(selected_champion))
                    pocket_record = project.champion_pocket_bytes(selected_champion)
                    editable = champion_edit_allowed(
                        has_save=project.save_data is not None,
                        selected_tower=selected_tower,
                        active_tower=project.current_tower,
                    )
                    page_names = ("STATS", "SPELLS", "POCKETS")
                    draw_info(
                        f"{record.full_name} · {page_names[champion_page]}",
                        337,
                        (235, 200, 105),
                    )
                    champion_location = selected_champion_location()
                    if champion_location is not None:
                        floor, location_x, location_y, source = champion_location
                        draw_info(
                            f"{source} · F{floor} X${location_x:02X} Y${location_y:02X}",
                            350,
                            (165, 170, 180),
                            x=1008,
                        )
                    try:
                        if champion_assets is None:
                            raise ValueError("champion assets unavailable")
                        if champion_page == 0:
                            preview = render_champion_stats_scroll(
                                pygame, record, champion_assets.scroll_edges,
                                champion_assets.game_font, GAME_PALETTE_RGB8,
                            )
                        elif champion_page == 1:
                            preview = render_champion_spellbook_preview(
                                pygame, record, champion_assets, champion_spell_page // 2
                            )
                        else:
                            preview = render_empty_champion_inventory(
                                pygame,
                                pockets=champion_assets.pockets,
                                font_data=champion_assets.game_font,
                                record=record,
                                champion=selected_champion,
                                pocket_record=pocket_record,
                                party_members=(selected_champion, None, None, None),
                                selected_party_slot=0,
                                secondary_colour_index=8,
                                palette=GAME_PALETTE_RGB8,
                                slot_pixels=(
                                    lambda _slot, code: (
                                        object_assets.pocket_sprite(code).pixels
                                        if object_assets is not None and code else None
                                    )
                                ),
                            )
                        champion_data_rect = pygame.Rect(810, 360, 192, 178)
                        pygame.draw.rect(screen, (4, 4, 6), champion_data_rect)
                        draw_actor_preview(preview, champion_data_rect)
                    except (AttributeError, IndexError, ValueError, RuntimeError):
                        if champion_assets is not None:
                            portrait = render_large_champion_avatar_panel(pygame, champion_assets, selected_champion)
                            draw_actor_preview(portrait, pygame.Rect(810, 360, 192, 178))
                    if character_assets is not None:
                        try:
                            champion_canvas = [[0] * 128 for _ in range(128)]
                            armour_override = character_assets.worn_armour_override(
                                pocket_record[2]
                            )
                            champion_pixels, _ = render_character_preview(
                                champion_canvas,
                                character_assets,
                                selected_champion,
                                distance=0,
                                facing=0,
                                worn_armour_override=armour_override,
                                anchor_x=64,
                                anchor_y=65,
                            )
                            full_character_rect = pygame.Rect(1010, 360, 180, 178)
                            pygame.draw.rect(screen, (4, 4, 6), full_character_rect)
                            draw_actor_preview(
                                indexed_to_surface(
                                    pygame, crop_indexed_pixels(champion_pixels)
                                ),
                                full_character_rect,
                            )
                        except (IndexError, ValueError, RuntimeError):
                            pass
                    editor_list = [
                        CellEditorRow("CHAMPION", f"{selected_champion + 1:02d} / 16", "CHAMPION-", "CHAMPION+"),
                        CellEditorRow("VIEW", page_names[champion_page], "PAGE-", "PAGE+"),
                    ]
                    if champion_page == 0:
                        stat_pages = (
                            (("LEVEL", 0), ("STRENGTH", 1), ("AGILITY", 2), ("INTELLIGENCE", 3)),
                            (("CHARISMA", 4), ("HP CURRENT", 5), ("HP MAXIMUM", 6), ("VITALITY CURRENT", 7)),
                            (("VITALITY MAXIMUM", 8), ("SPELL POINTS", 9), ("SPELL POINTS MAX", 10), ("ARMOUR", 11)),
                        )
                        editor_list.append(CellEditorRow("STAT PAGE", f"{champion_stats_page + 1} / 3", "STAT-PAGE-", "STAT-PAGE+"))
                        for label, offset in stat_pages[champion_stats_page]:
                            editor_list.append(CellEditorRow(label, str(record.byte(offset)), f"STAT-{offset:02X}-", f"STAT-{offset:02X}+"))
                    elif champion_page == 1:
                        editor_list.append(CellEditorRow("SPELL PAGE", f"{champion_spell_page + 1} / 8", "SPELL-PAGE-", "SPELL-PAGE+"))
                        for entry in range(4):
                            spell = champion_spell_page * 4 + entry
                            marker = "> " if entry == selected_spell_entry else ""
                            editor_list.append(CellEditorRow(f"{marker}{SPELL_NAMES[spell]}", "LEARNED" if record.has_spellbook_spell(spell) else "UNKNOWN", f"SPELL-{spell}-", f"SPELL-{spell}+"))
                        practice_spell = champion_spell_page * 4 + selected_spell_entry
                        practice = project.spell_practice(selected_champion, practice_spell)
                        editor_list.append(
                            CellEditorRow(
                                f"PRACTICE {SPELL_NAMES[practice_spell]}",
                                "SAVE ONLY" if practice is None else str(practice),
                                "PRACTICE-",
                                "PRACTICE+",
                            )
                        )
                    else:
                        code = pocket_record[selected_pocket_slot]
                        name = object_assets.definition(code).name if object_assets is not None else f"${code:02X}"
                        editor_list.extend((
                            CellEditorRow("POCKET", f"{selected_pocket_slot + 1} / 12", "POCKET-", "POCKET+"),
                            CellEditorRow("OBJECT", f"${code:02X} {name}", "OBJECT-", "OBJECT+"),
                        ))
                        if 1 <= code <= 4:
                            count_offset = 0x0B + code
                            editor_list.append(
                                CellEditorRow("QUANTITY", str(pocket_record[count_offset]), "COUNT-", "COUNT+")
                            )
                    editor_rows = tuple(editor_list)
                    source_note = "EDITABLE" if editable else "VIEW ONLY — SELECT MOD0 / ACTIVE SAVE TOWER"
                    draw_info(source_note, 692, (135, 205, 150) if editable else (235, 150, 120))
                else:
                    records = actor_records()
                    editable = False
                    if not records:
                        editor_rows = ()
                        draw_info("NO MONSTERS IN THIS TOWER", 350, (235, 200, 105))
                    else:
                        selected_monster = min(selected_monster, len(records) - 1)
                        record = records[selected_monster]
                        resolved = selected_monster_record(resolved=True) or record
                        teams = {team.group: team for team in monster_teams(project.monsters(selected_tower))}
                        team = None
                        team_text = "SOLO"
                        if record.team != 0xFF:
                            team = teams.get(record.team >> 2)
                            count = sum(member is not None for member in team.members) if team else 1
                            team_text = f"GROUP {record.team >> 2:02d} · SLOT {(record.team & 3) + 1} · {count} MEMBERS"
                        draw_info(
                            f"{record.source.upper()} · FLOOR {resolved.floor} · X ${resolved.x:02X} Y ${resolved.y:02X}",
                            337,
                            (235, 200, 105),
                        )
                        try:
                            members = (
                                (record.index,)
                                if monster_design_mode
                                else
                                tuple(member for member in team.members if member is not None)
                                if team is not None
                                else (record.index,)
                            )
                            records_by_index = {member.index: member for member in records}
                            preview_entries = (
                                tuple(
                                    (record.index, distance)
                                    for distance in MONSTER_DESIGN_PREVIEW_DISTANCES
                                )
                                if monster_design_mode
                                else tuple((member, 0) for member in members)
                            )
                            slot_width = preview_rect.width // len(preview_entries)
                            preview_member_rectangles = []
                            for slot, (member_index, distance) in enumerate(preview_entries):
                                member = records_by_index[member_index]
                                canvas = [[0] * 128 for _ in range(128)]
                                if member.form <= 0x55 and character_assets is not None:
                                    pixels, _ = render_character_preview(
                                        canvas, character_assets, member.form,
                                        distance=distance,
                                        facing=0, anchor_x=64, anchor_y=65,
                                    )
                                else:
                                    definition = next(item for item in MONSTERS if item.code == member.form)
                                    pixels, _ = render_monster_preview(
                                        canvas, definition, monster_assets,
                                        distance=distance,
                                        facing=0,
                                        grade_step=member.colour_grade_step,
                                        animation_frame=0, anchor_x=64, anchor_y=65,
                                        illusion=member.is_illusion,
                                    )
                                member_surface = indexed_to_surface(
                                    pygame, crop_indexed_pixels(pixels)
                                )
                                if member_index != record.index:
                                    member_surface.set_alpha(128)
                                member_rect = pygame.Rect(
                                    preview_rect.left + slot * slot_width,
                                    preview_rect.top,
                                    slot_width,
                                    preview_rect.height,
                                )
                                old_preview_clip = screen.get_clip()
                                screen.set_clip(member_rect)
                                target = draw_actor_preview(member_surface, member_rect)
                                screen.set_clip(old_preview_clip)
                                preview_member_rectangles.append((member_index, target))
                                if monster_design_mode:
                                    draw_info(
                                        f"VIEW {slot + 1}",
                                        366,
                                        (235, 200, 105),
                                        x=member_rect.left + 7,
                                    )
                                if member_index == record.index and len(members) > 1:
                                    flash_colour = CURSOR_COLOURS[
                                        (pygame.time.get_ticks() // 120) % len(CURSOR_COLOURS)
                                    ]
                                    pygame.draw.rect(screen, flash_colour, target.inflate(4, 4), 2)
                            monster_preview_member_rects = tuple(
                                preview_member_rectangles
                            )
                        except (KeyError, StopIteration, ValueError, RuntimeError):
                            draw_info("GRAPHICAL PREVIEW UNAVAILABLE", 410, (235, 150, 120), x=820)
                        editable = record.source == "packed"
                        if monster_design_mode and record.form <= 0x55:
                            head, body, palettes = project.character_design(record.form)
                            palette_names = ("HEAD", "LEGS", "TORSO", "ARMS", "DISTANT")
                            design_editable = project.save_data is None and character_assets is not None
                            editor_rows = (
                                CellEditorRow("MONSTER", f"{selected_monster + 1} / {len(records)}", "MONSTER-", "MONSTER+"),
                                CellEditorRow("HEAD DESIGN", f"${head:02X}", "HEAD-", "HEAD+"),
                                CellEditorRow("BODY DESIGN", f"${body:02X}", "BODY-", "BODY+"),
                                CellEditorRow("PALETTE", palette_names[selected_colour_group], "PALETTE-", "PALETTE+"),
                                *(CellEditorRow(
                                    f"INK {slot + 1}",
                                    f"${palettes[selected_colour_group][slot]:X}",
                                    f"INK{slot}-",
                                    f"INK{slot}+",
                                ) for slot in range(4)),
                            )
                            editable = design_editable
                        elif monster_design_mode:
                            grade_table = LARGE_MONSTER_GRADE_TABLES.get(record.form)
                            design_rows = [
                                CellEditorRow("MONSTER", f"{selected_monster + 1} / {len(records)}", "MONSTER-", "MONSTER+"),
                            ]
                            if grade_table is not None:
                                filename = grade_table
                                grade_count = len((monsters_dir / filename).read_bytes())
                                grade_step = max(
                                    0,
                                    min(grade_count - 1, record.colour_grade_step),
                                )
                                design_rows.append(
                                    CellEditorRow(
                                        "COLOUR GRADE",
                                        f"{grade_step + 1} / {grade_count} · LEVEL {record.level & 0x7F}",
                                        "GRADE-",
                                        "GRADE+",
                                    )
                                )
                            editor_rows = tuple(design_rows)
                            editable = record.source == "packed"
                        else:
                            editor_rows = (
                                CellEditorRow("MONSTER", f"{selected_monster + 1} / {len(records)}", "MONSTER-", "MONSTER+"),
                                CellEditorRow("FORM", monster_form_name(record.form), "FORM-", "FORM+"),
                                CellEditorRow("LEVEL", str(record.level & 0x7F), "LEVEL-", "LEVEL+"),
                                CellEditorRow("TYPE", MONSTER_TYPE_NAMES.get(record.category, f"TYPE ${record.category:02X}"), "TYPE-", "TYPE+"),
                                CellEditorRow("TEAM", team_text, "REMOVE-TEAM", "JOIN-TEAM"),
                            )
                        draw_info(
                            "PACKED DATA — EDITABLE" if editable else "LIVE DATA — VIEW ONLY",
                            692,
                            (135, 205, 150) if editable else (235, 150, 120),
                        )
                        if record.form >= 0x64:
                            draw_info(
                                "GRADE MINIMUM: SOURCE/EQU CONTROLLED",
                                710,
                                (150, 155, 168),
                            )
                for index, row in enumerate(editor_rows):
                    row_top = 542 + index * 18
                    rectangle = pygame.Rect(810, row_top, 380, 17)
                    minus_rectangle = pygame.Rect(1142, row_top + 1, 21, 15)
                    plus_rectangle = pygame.Rect(1167, row_top + 1, 21, 15)
                    navigation_actions = {
                        "CHAMPION-", "PAGE-", "STAT-PAGE-", "SPELL-PAGE-",
                        "POCKET-", "MONSTER-", "PALETTE-",
                    }
                    enabled = editable or row.decrement_action in navigation_actions
                    if row.decrement_action == "PRACTICE-":
                        enabled = (
                            project.save_data is not None
                            and selected_tower == project.current_tower
                        )
                    row_layout.append((index, row.decrement_action, row.increment_action, rectangle, minus_rectangle, plus_rectangle, enabled))
                control_rects = tuple(row_layout)
                for index, _, _, rectangle, minus_rectangle, plus_rectangle, enabled in control_rects:
                    draw_editor_row(editor_rows[index], rectangle, minus_rectangle, plus_rectangle, selected=index == selected_editor_row, enabled=enabled)
                if actor_mode == "MONSTERS":
                    current_monster = selected_monster_record()
                    for action, label, rectangle in monster_operation_rects:
                        design_action = action == "DESIGN"
                        find_action = action == "FIND"
                        map_mode_action = action == "MAP-MODE"
                        design_available = current_monster is not None
                        is_team_member = (
                            current_monster is not None
                            and current_monster.team != 0xFF
                        )
                        draw_button(
                            rectangle,
                            (
                                f"MAP: {monster_map_click_mode}"
                                if map_mode_action
                                else label
                            ),
                            active=(
                                monster_design_mode
                                if design_action
                                else monster_map_click_mode == "JOIN"
                                if map_mode_action
                                else is_team_member
                                if action == "JOIN-TEAM"
                                else not is_team_member
                                if action == "REMOVE-TEAM"
                                else False
                            ),
                            enabled=(
                                design_available
                                if design_action
                                else current_monster is not None
                                if map_mode_action
                                else current_monster is not None
                                if find_action
                                else (
                                    not monster_design_mode
                                    and current_monster is not None
                                    and current_monster.source == "packed"
                                )
                            ),
                        )
                else:
                    draw_button(
                        champion_find_rect,
                        "FIND CHAMPION",
                        enabled=selected_champion_location() is not None,
                    )
                draw_button(save_rect, save_button_label, active=project.has_changes)
            draw_button(back_rect, "BACK")
            screen.blit(
                small_font.render(status_message, True, (230, 184, 105)),
                (270, 720),
            )
            screen.blit(
                small_font.render(
                    (
                        "CLICK OBJECT MARKER: SELECT / CYCLE STACK   CLICK ITEM: SELECT   ARROWS: CELL / PROPERTY"
                        if selected_tab == 2
                        else (
                            "CLICK MONSTER MARKER: SELECT / CYCLE TEAM   LEFT / RIGHT: CHANGE SELECTED PROPERTY"
                            if selected_tab == 3
                            else (
                                "SELECT A PROPERTY; LEFT / RIGHT TO CHANGE   RED: UNALIGNED STAIRS OR HOLES"
                                if selected_tab == 4
                                else "ARROWS: CELL / SELECTED PROPERTY   C/X/V: COPY/CUT/PASTE   BACKSPACE: CLEAR"
                            )
                        )
                    ),
                    True,
                    (145, 150, 160),
                ),
                (270, 740),
            )

            pygame.display.flip()
            if screenshot_path is not None:
                screenshot_path.parent.mkdir(parents=True, exist_ok=True)
                pygame.image.save(screen, str(screenshot_path))
                running = False

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif (
                    selected_tab == 0
                    and joystick is not None
                    and event.type
                    in (
                        pygame.JOYHATMOTION,
                        pygame.JOYBUTTONDOWN,
                        pygame.JOYAXISMOTION,
                    )
                ):
                    joystick_action = joystick_navigation_action(
                        event,
                        hat_motion_type=pygame.JOYHATMOTION,
                        button_down_type=pygame.JOYBUTTONDOWN,
                        axis_motion_type=pygame.JOYAXISMOTION,
                    )
                    if joystick_action == "TURN-LEFT":
                        facing = (facing - 1) & 3
                    elif joystick_action == "TURN-RIGHT":
                        facing = (facing + 1) & 3
                    elif joystick_action == "MOVE-FORWARD":
                        move_cursor_relative(forward=1)
                    elif joystick_action == "MOVE-BACK":
                        move_cursor_relative(forward=-1)
                    elif joystick_action == "MOVE-LEFT":
                        move_cursor_relative(lateral=-1)
                    elif joystick_action == "MOVE-RIGHT":
                        move_cursor_relative(lateral=1)
                    if joystick_action is not None:
                        clamp_selection()
                elif event.type == pygame.KEYDOWN:
                    editing_property = (
                        selected_tab in (1, 2, 3, 4)
                        and selected_editor_row is not None
                        and bool(editor_rows)
                    )
                    if event.key == pygame.K_ESCAPE and editing_property:
                        selected_editor_row = None
                    elif event.key == pygame.K_ESCAPE:
                        running = False
                    elif editing_property and event.key in (pygame.K_UP, pygame.K_DOWN):
                        delta = -1 if event.key == pygame.K_UP else 1
                        selected_editor_row = (selected_editor_row + delta) % len(editor_rows)
                    elif editing_property and event.key in (pygame.K_LEFT, pygame.K_RIGHT):
                        for (
                            index,
                            decrement_action,
                            increment_action,
                            _,
                            _,
                            _,
                            enabled,
                        ) in control_rects:
                            if index == selected_editor_row and enabled:
                                action = (
                                    decrement_action
                                    if event.key == pygame.K_LEFT
                                    else increment_action
                                )
                                apply_editor_adjustment(selected_tab, action)
                                break
                    elif editing_property and event.key in (pygame.K_RETURN, pygame.K_SPACE):
                        selected_editor_row = None
                    elif event.key == pygame.K_LEFT and event.mod & pygame.KMOD_SHIFT:
                        pan_by(cell_size(), 0)
                    elif event.key == pygame.K_RIGHT and event.mod & pygame.KMOD_SHIFT:
                        pan_by(-cell_size(), 0)
                    elif event.key == pygame.K_UP and event.mod & pygame.KMOD_SHIFT:
                        pan_by(0, cell_size())
                    elif event.key == pygame.K_DOWN and event.mod & pygame.KMOD_SHIFT:
                        pan_by(0, -cell_size())
                    elif event.key == pygame.K_LEFT:
                        selected_x -= 1
                    elif event.key == pygame.K_RIGHT:
                        selected_x += 1
                    elif event.key == pygame.K_UP:
                        selected_y -= 1
                    elif event.key == pygame.K_DOWN:
                        selected_y += 1
                    elif event.key == pygame.K_c and selected_tab == 1:
                        apply_action("COPY")
                    elif event.key == pygame.K_x and selected_tab == 1:
                        apply_action("CUT")
                    elif event.key == pygame.K_v and selected_tab == 1:
                        apply_action("PASTE")
                    elif event.key == pygame.K_BACKSPACE and selected_tab == 1:
                        apply_action("CLEAR")
                    elif event.key == pygame.K_s and (event.mod & pygame.KMOD_CTRL):
                        save_changes()
                    elif selected_tab == 0 and event.key == pygame.K_q:
                        facing = (facing - 1) & 3
                    elif selected_tab == 0 and event.key == pygame.K_e:
                        facing = (facing + 1) & 3
                    elif selected_tab == 0 and event.key == pygame.K_w:
                        move_cursor_relative(forward=1)
                    elif selected_tab == 0 and event.key == pygame.K_s:
                        move_cursor_relative(forward=-1)
                    elif selected_tab == 0 and event.key == pygame.K_a:
                        move_cursor_relative(lateral=-1)
                    elif selected_tab == 0 and event.key == pygame.K_d:
                        move_cursor_relative(lateral=1)
                    elif event.key in (pygame.K_EQUALS, pygame.K_PLUS):
                        set_zoom(zoom + 1)
                    elif event.key == pygame.K_MINUS:
                        set_zoom(zoom - 1)
                    clamp_selection()
                    if event.key in (
                        pygame.K_LEFT,
                        pygame.K_RIGHT,
                        pygame.K_UP,
                        pygame.K_DOWN,
                    ) and not event.mod & pygame.KMOD_SHIFT:
                        ensure_selection_visible()
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1 and display_mode_rect.collidepoint(event.pos):
                    fullscreen = not fullscreen
                    screen = (
                        set_scaled_fullscreen(pygame, WINDOW_SIZE)
                        if fullscreen
                        else set_windowed(pygame, WINDOW_SIZE)
                    )
                elif event.type == pygame.MOUSEWHEEL and map_rect.collidepoint(mouse):
                    set_zoom(zoom + (1 if event.y > 0 else -1), mouse)
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                    if back_rect.collidepoint(event.pos):
                        running = False
                        continue
                    if art_rect.collidepoint(event.pos) and project.modified_root.is_dir():
                        use_modified_art = not use_modified_art
                        try:
                            (
                                gfx_dir,
                                data_dir,
                                monsters_dir,
                                dungeon_backgrounds,
                                dungeon_assets,
                                character_assets,
                                spell_assets,
                                object_assets,
                                champion_assets,
                                monster_assets,
                            ) = load_visual_assets(use_modified_art)
                            sync_character_design_preview()
                            object_icon_cache.clear()
                            preview_revision += 1
                            preview_cache_key = None
                            status_message = (
                                "USING MODIFIED ART" if use_modified_art else "USING CLEAN ART"
                            )
                        except MapEditorError as error:
                            use_modified_art = not use_modified_art
                            status_message = str(error).upper()
                        continue
                    for index, rectangle in enumerate(tab_rects):
                        if rectangle.collidepoint(event.pos) and EDITOR_TAB_ENABLED[index]:
                            selected_tab = index
                            selected_editor_row = None
                            layout_clear_armed = None
                            if selected_tab == 2:
                                overlays["OBJECTS"] = True
                                jump_to_object_stack()
                            elif selected_tab == 3:
                                overlays["CHAMPIONS"] = True
                                overlays["MONSTERS"] = True
                            break
                    for index, rectangle in enumerate(tower_rects):
                        if rectangle.collidepoint(event.pos):
                            selected_tower = index
                            selected_floor = default_floor(project, selected_tower)
                            selected_x = selected_y = 0
                            selected_object_stack = 0
                            selected_object_item = 0
                            selected_monster = 0
                            selected_editor_row = None
                            layout_clear_armed = None
                            pan_x = pan_y = 0
                            clamp_pan()
                            if selected_tab == 2:
                                jump_to_object_stack()
                            break
                    for floor, rectangle in enumerate(floor_rects):
                        if rectangle.collidepoint(event.pos) and (
                            current_map().floor_exists(floor)
                            or (selected_tab == 4 and floor <= current_map().top_floor)
                        ):
                            selected_floor = floor
                            selected_x = selected_y = 0
                            selected_editor_row = None
                            layout_clear_armed = None
                            pan_x = pan_y = 0
                            clamp_pan()
                            break
                    for action, rectangle in zoom_rects:
                        if rectangle.collidepoint(event.pos):
                            if action == "ZOOM-":
                                set_zoom(zoom - 1)
                            elif action == "ZOOM+":
                                set_zoom(zoom + 1)
                            else:
                                reset_view()
                            break
                    for action, rectangle in pan_rects:
                        if rectangle.collidepoint(event.pos) and can_pan():
                            step = cell_size() * 2
                            if action == "PAN-UP":
                                pan_by(0, step)
                            elif action == "PAN-DOWN":
                                pan_by(0, -step)
                            elif action == "PAN-LEFT":
                                pan_by(step, 0)
                            else:
                                pan_by(-step, 0)
                            break
                    for name, enabled, rectangle in zip(
                        main_overlay_names + ("LINKS",), OVERLAY_ENABLED, overlay_rects
                    ):
                        if selected_tab != 4 and rectangle.collidepoint(event.pos):
                            if enabled and (name != "QS TEAMS" or project.save_data is None):
                                overlays[name] = not overlays[name]
                            break
                    if map_rect.collidepoint(event.pos) and current_map().floor_exists(selected_floor):
                        selected_x = (
                            event.pos[0] - MAP_ORIGIN[0] - pan_x
                        ) // cell_size() - current_map().x_offsets[selected_floor]
                        selected_y = (
                            event.pos[1] - MAP_ORIGIN[1] - pan_y
                        ) // cell_size() - current_map().y_offsets[selected_floor]
                        clamp_selection()
                        selected_editor_row = None
                        if selected_tab == 2 and object_auto_select:
                            candidates = object_stack_indices_at_cell(
                                current_map(),
                                object_stack_records[selected_tower],
                                selected_floor,
                                selected_x,
                                selected_y,
                            )
                            if candidates:
                                next_stack = cycle_object_stack_index(
                                    candidates, selected_object_stack
                                )
                                assert next_stack is not None
                                selected_object_stack = next_stack
                                selected_object_item = 0
                                status_message = (
                                    f"OBJECT STACK {selected_object_stack + 1}"
                                )
                        elif selected_tab == 3 and actor_mode == "MONSTERS":
                            candidates = monster_indices_at_cell(
                                resolved_actor_records(),
                                selected_floor,
                                selected_x,
                                selected_y,
                            )
                            if monster_map_click_mode == "JOIN":
                                target = next(
                                    (candidate for candidate in candidates if candidate != selected_monster),
                                    None,
                                )
                                if target is None:
                                    status_message = "NO OTHER MONSTER PARTY AT THIS LOCATION"
                                else:
                                    try:
                                        before_codes = {
                                            member.team for member in actor_records()
                                        }
                                        joined = project.join_monster_to_team(
                                            selected_tower, selected_monster, target
                                        )
                                    except (IndexError, ValueError) as error:
                                        status_message = str(error).upper()
                                    else:
                                        new_codes = [
                                            member.team
                                            for member in joined
                                            if member.team != 0xFF
                                            and member.team not in before_codes
                                        ]
                                        selected_code = new_codes[-1]
                                        selected_monster = next(
                                            member.index
                                            for member in joined
                                            if member.team == selected_code
                                        )
                                        joined_member = joined[selected_monster]
                                        status_message = (
                                            f"JOINED PARTY {joined_member.team >> 2:02d} "
                                            f"SLOT {(joined_member.team & 3) + 1}"
                                        )
                            else:
                                next_monster = cycle_monster_index(candidates, selected_monster)
                                if next_monster is not None:
                                    selected_monster = next_monster
                                    status_message = f"MONSTER {selected_monster + 1}"
                    if selected_tab == 1:
                        for action, _, rectangle in map_operation_rects:
                            if rectangle.collidepoint(event.pos):
                                if action != "PASTE" or copied_cell is not None:
                                    apply_action(action)
                                break
                        for (
                            index,
                            decrement_action,
                            increment_action,
                            rectangle,
                            minus_rectangle,
                            plus_rectangle,
                            enabled,
                        ) in control_rects:
                            if minus_rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if enabled:
                                    begin_held_adjustment(
                                        selected_tab,
                                        decrement_action,
                                        minus_rectangle,
                                    )
                                break
                            if plus_rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if enabled:
                                    begin_held_adjustment(
                                        selected_tab,
                                        increment_action,
                                        plus_rectangle,
                                    )
                                break
                            if rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                break
                        if save_rect.collidepoint(event.pos):
                            save_changes()
                    elif selected_tab == 3:
                        for mode, rectangle in actor_mode_rects:
                            if rectangle.collidepoint(event.pos):
                                actor_mode = mode
                                selected_editor_row = None
                                break
                        if actor_mode == "MONSTERS":
                            for member_index, rectangle in monster_preview_member_rects:
                                if (
                                    member_index != selected_monster
                                    and rectangle.collidepoint(event.pos)
                                ):
                                    selected_monster = member_index
                                    selected_editor_row = None
                                    status_message = f"MONSTER {selected_monster + 1}"
                                    break
                            for action, _, rectangle in monster_operation_rects:
                                if rectangle.collidepoint(event.pos):
                                    apply_actor_action(action)
                                    break
                        elif champion_find_rect.collidepoint(event.pos):
                            apply_actor_action("FIND")
                        for (
                            index,
                            decrement_action,
                            increment_action,
                            rectangle,
                            minus_rectangle,
                            plus_rectangle,
                            enabled,
                        ) in control_rects:
                            if minus_rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if enabled:
                                    begin_held_adjustment(
                                        selected_tab,
                                        decrement_action,
                                        minus_rectangle,
                                    )
                                break
                            if plus_rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if enabled:
                                    begin_held_adjustment(
                                        selected_tab,
                                        increment_action,
                                        plus_rectangle,
                                    )
                                break
                            if rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if (
                                    actor_mode == "CHAMPIONS"
                                    and champion_page == 1
                                    and 3 <= index <= 6
                                ):
                                    selected_spell_entry = index - 3
                                break
                        if save_rect.collidepoint(event.pos):
                            save_changes()
                    elif selected_tab == 2:
                        for action, _, rectangle in object_operation_rects:
                            if rectangle.collidepoint(event.pos):
                                apply_object_action(action)
                                break
                        for item_index, rectangle in object_item_rects:
                            if rectangle.collidepoint(event.pos):
                                selected_object_item = item_index
                                selected_editor_row = None
                                break
                        for (
                            index,
                            decrement_action,
                            increment_action,
                            rectangle,
                            minus_rectangle,
                            plus_rectangle,
                            enabled,
                        ) in control_rects:
                            if minus_rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if enabled:
                                    begin_held_adjustment(
                                        selected_tab,
                                        decrement_action,
                                        minus_rectangle,
                                    )
                                break
                            if plus_rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if enabled:
                                    begin_held_adjustment(
                                        selected_tab,
                                        increment_action,
                                        plus_rectangle,
                                    )
                                break
                            if rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                break
                        if save_rect.collidepoint(event.pos):
                            save_changes()
                    elif selected_tab == 4:
                        if (
                            layout_clear_rect.collidepoint(event.pos)
                            and selected_tower not in project.save_map_fallbacks
                        ):
                            apply_layout_action("LAYOUT-CLEAR")
                        elif layout_links_rect.collidepoint(event.pos):
                            apply_layout_action("LAYOUT-LINKS")
                        for (
                            index,
                            decrement_action,
                            increment_action,
                            rectangle,
                            minus_rectangle,
                            plus_rectangle,
                            enabled,
                        ) in control_rects:
                            if minus_rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if enabled:
                                    begin_held_adjustment(
                                        selected_tab,
                                        decrement_action,
                                        minus_rectangle,
                                    )
                                break
                            if plus_rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                if enabled:
                                    begin_held_adjustment(
                                        selected_tab,
                                        increment_action,
                                        plus_rectangle,
                                    )
                                break
                            if rectangle.collidepoint(event.pos):
                                selected_editor_row = index
                                break
                        if save_rect.collidepoint(event.pos):
                            save_changes()
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button in (2, 3):
                    if map_rect.collidepoint(event.pos):
                        dragging_map = True
                        drag_origin = event.pos
                        pan_origin = (pan_x, pan_y)
                elif event.type == pygame.MOUSEBUTTONUP:
                    if event.button == 1:
                        held_adjustment = None
                    elif event.button in (2, 3):
                        dragging_map = False
                elif event.type == pygame.MOUSEMOTION and dragging_map:
                    pan_x = pan_origin[0] + event.pos[0] - drag_origin[0]
                    pan_y = pan_origin[1] + event.pos[1] - drag_origin[1]
                    clamp_pan()
            if held_adjustment is not None:
                held_tab, held_action, held_rectangle = held_adjustment
                now = pygame.time.get_ticks()
                if (
                    selected_tab != held_tab
                    or not pygame.mouse.get_pressed(3)[0]
                ):
                    held_adjustment = None
                elif (
                    held_rectangle.collidepoint(pygame.mouse.get_pos())
                    and adjustment_repeat_due(
                        now,
                        held_adjustment_started,
                        held_adjustment_repeated,
                    )
                ):
                    apply_editor_adjustment(held_tab, held_action)
                    held_adjustment_repeated = now
            clock.tick(60)
    finally:
        pygame.quit()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-root", type=Path)
    parser.add_argument(
        "--savegame",
        type=Path,
        help="overlay a WHDLoad save; edited output is copied into -modified/whdload",
    )
    parser.add_argument("--screenshot", type=Path)
    parser.add_argument("--tab", type=int, default=0, choices=range(len(EDITOR_TABS)))
    parser.add_argument("--actor-mode", choices=("champions", "monsters"), default="champions")
    args = parser.parse_args()
    launch_map_editor(
        args.data_root,
        savegame_path=args.savegame,
        screenshot_path=args.screenshot,
        initial_tab=args.tab,
        initial_actor_mode=args.actor_mode.upper(),
    )


if __name__ == "__main__":
    main()

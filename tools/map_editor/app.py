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
)
from tools.map_editor.model import MapCell, MapProject, TOWERS
from tools.map_editor.render import MAP_TYPE_NAMES, cell_glyph, describe_cell, draw_map_cell
from tools.map_editor.semantics import (
    SWITCH_ACTIONS,
    TRIGGER_ACTIONS,
    TRIGGER_FLOOR_ACTIONS,
    TRIGGER_XY_ACTIONS,
    CellControl,
    apply_cell_action,
    controls_for_cell,
)
from tools.tool_common import DATA_DIR
from tools.st_planar_assets import GAME_PALETTE_RGB8


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
EDITOR_TABS = ("VIEWER", "MAPS", "OBJECTS", "CHARACTERS / MONSTERS", "LAYOUT")
EDITOR_TAB_ENABLED = (True, True, False, False, False)
OVERLAY_NAMES = ("SWITCHES", "TRIGGERS", "MONSTERS", "OBJECTS")
OVERLAY_ENABLED = (True, True, False, False)
FIRST_PERSON_SCALE = 3
FIRST_PERSON_RECT = (810, 432, 128 * FIRST_PERSON_SCALE, 76 * FIRST_PERSON_SCALE)


class MapEditorError(RuntimeError):
    """Raised when the map editor cannot load its required data."""


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
        y: int = 2,
    ) -> None:
        """Draw one glyph using the map editor's tall 1x2 pixel geometry."""

        for gy, row in enumerate(glyph_pixels(self.data, ord(character) & 0x7F)):
            for gx, value in enumerate(row):
                if value:
                    self.pygame.draw.rect(surface, colour, (x + gx, y + gy * 2, 1, 2))


def default_floor(project: MapProject, tower: int) -> int:
    areas = [
        width * height
        for width, height in zip(project.maps[tower].widths, project.maps[tower].heights)
    ]
    return max(range(len(areas)), key=areas.__getitem__)


def launch_map_editor(
    data_root: Path | None = None,
    *,
    savegame_path: Path | None = None,
    screenshot_path: Path | None = None,
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

    gfx_dir = DataOverlayPath(
        project.clean_root / "gfx",
        project.modified_root / "gfx",
        True,
    )
    try:
        dungeon_backgrounds = tuple(
            load_dungeon_background(gfx_dir, pattern_parity=parity)
            for parity in range(2)
        )
        dungeon_assets = DungeonAssets(gfx_dir)
    except (OSError, ValueError) as error:
        raise MapEditorError(f"could not load dungeon preview assets: {error}") from error

    pygame.init()
    pygame.key.set_repeat(250, 45)
    try:
        screen = pygame.display.set_mode(WINDOW_SIZE)
        pygame.display.set_caption("Bloodwych ReSource - Map Editor")
        title_font = pygame.font.SysFont(None, 30)
        small_font = pygame.font.SysFont(None, 17)
        game_font = GameFontRenderer(
            pygame, project.clean_root / "gfx" / "GameFont"
        )
        clock = pygame.time.Clock()

        selected_tab = 0
        selected_tower = 0
        selected_floor = default_floor(project, selected_tower)
        selected_x = selected_y = 0
        copied_cell: MapCell | None = None
        overlays = {
            name: enabled
            for name, enabled in zip(OVERLAY_NAMES, OVERLAY_ENABLED)
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
        drag_origin = (0, 0)
        pan_origin = (0, 0)
        cell_cache: dict[tuple[int, int], object] = {}
        switch_records = [list(project.switches(index)) for index in range(len(TOWERS))]
        trigger_records = [list(project.triggers(index)) for index in range(len(TOWERS))]

        tab_width, tab_gap = 170, 8
        tab_rects = tuple(
            pygame.Rect(20 + index * (tab_width + tab_gap), 52, tab_width, 34)
            for index in range(len(EDITOR_TABS))
        )
        source_rect = pygame.Rect(935, 52, 255, 34)
        tower_rects = tuple(
            pygame.Rect(20, 112 + index * 42, 220, 36)
            for index in range(len(TOWERS))
        )
        floor_rects = tuple(
            pygame.Rect(20 + (index % 4) * 54, 385 + (index // 4) * 40, 50, 34)
            for index in range(8)
        )
        overlay_rects = tuple(
            pygame.Rect(270 + index * 126, 632, 118, 32)
            for index in range(len(OVERLAY_NAMES))
        )
        save_rect = pygame.Rect(810, 682, 180, 38)
        back_rect = pygame.Rect(20, 712, 100, 32)
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

        def replace_cell(cell: MapCell) -> None:
            nonlocal status_message, preview_revision
            project.set_cell(
                selected_tower, selected_floor, selected_x, selected_y, cell
            )
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
                    record = switch_records[selected_tower][reference]
                    action_values = tuple(SWITCH_ACTIONS)
                    if action in ("SWITCH-ACTION-", "SWITCH-ACTION+"):
                        try:
                            index = action_values.index(record.action)
                        except ValueError:
                            index = 0
                        delta = -1 if action.endswith("-") else 1
                        record = project.set_switch(selected_tower, reference, action=action_values[(index + delta) % len(action_values)])
                    elif action == "SWITCH-X-":
                        record = project.set_switch(selected_tower, reference, x=max(0, record.x - 1))
                    elif action == "SWITCH-X+":
                        record = project.set_switch(selected_tower, reference, x=min(31, record.x + 1))
                    elif action == "SWITCH-Y-":
                        record = project.set_switch(selected_tower, reference, y=max(0, record.y - 1))
                    elif action == "SWITCH-Y+":
                        record = project.set_switch(selected_tower, reference, y=min(31, record.y + 1))
                    switch_records[selected_tower][reference] = record
                    status_message = "UNSAVED SHARED SWITCH CHANGE"
                    return
                if action.startswith("TRIGGER-") and cell.map_type == 6:
                    reference = cell.first // 8
                    record = trigger_records[selected_tower][reference]
                    action_values = tuple(TRIGGER_ACTIONS)
                    if action in ("TRIGGER-ACTION-", "TRIGGER-ACTION+"):
                        try:
                            index = action_values.index(record.action)
                        except ValueError:
                            index = 0
                        delta = -1 if action.endswith("-") else 1
                        record = project.set_trigger(selected_tower, reference, action=action_values[(index + delta) % len(action_values)])
                    elif action == "TRIGGER-FLOOR-":
                        record = project.set_trigger(selected_tower, reference, floor=max(0, record.floor - 1))
                    elif action == "TRIGGER-FLOOR+":
                        record = project.set_trigger(selected_tower, reference, floor=min(7, record.floor + 1))
                    elif action == "TRIGGER-X-":
                        record = project.set_trigger(selected_tower, reference, x=max(0, record.x - 1))
                    elif action == "TRIGGER-X+":
                        record = project.set_trigger(selected_tower, reference, x=min(31, record.x + 1))
                    elif action == "TRIGGER-Y-":
                        record = project.set_trigger(selected_tower, reference, y=max(0, record.y - 1))
                    elif action == "TRIGGER-Y+":
                        record = project.set_trigger(selected_tower, reference, y=min(31, record.y + 1))
                    trigger_records[selected_tower][reference] = record
                    status_message = "UNSAVED SHARED TRIGGER CHANGE"
                    return
            except (IndexError, ValueError) as error:
                status_message = str(error).upper()
                return
            if action == "COPY":
                copied_cell = cell
                status_message = f"COPIED ${cell.first:02X} ${cell.second:02X}"
            elif action == "PASTE" and copied_cell is not None:
                replace_cell(copied_cell)
            else:
                replacement = apply_cell_action(cell, action)
                if replacement != cell:
                    replace_cell(replacement)

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
                pixels, _ = render_dungeon_scene(
                    dungeon_backgrounds[pattern_parity],
                    dungeon_assets,
                    placements,
                    pattern_parity=pattern_parity,
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
            label_surface = small_font.render(label, True, text_colour)
            screen.blit(label_surface, label_surface.get_rect(center=rectangle.center))

        def draw_info(text: str, y: int, colour=(205, 208, 215), *, x: int = 810) -> None:
            screen.blit(small_font.render(text, True, colour), (x, y))

        def draw_overlay_markers() -> None:
            tower_map = current_map()
            marker_font = pygame.font.SysFont(None, max(12, min(22, cell_size() // 2)))

            def marker(x: int, y: int, text: str, colour, quadrant: int) -> None:
                if not (0 <= x < tower_map.widths[selected_floor] and 0 <= y < tower_map.heights[selected_floor]):
                    return
                rectangle = cell_screen_rect(x, y)
                half = rectangle.width // 2
                positions = (
                    (rectangle.left + 2, rectangle.top + 1),
                    (rectangle.left + half, rectangle.top + 1),
                    (rectangle.left + 2, rectangle.top + half),
                    (rectangle.left + half, rectangle.top + half),
                )
                label = marker_font.render(text, True, colour)
                screen.blit(label, positions[quadrant])

            if overlays["SWITCHES"] or overlays["TRIGGERS"]:
                switches = switch_records[selected_tower]
                triggers = trigger_records[selected_tower]
                for y in range(tower_map.heights[selected_floor]):
                    for x in range(tower_map.widths[selected_floor]):
                        cell = tower_map.cell(selected_floor, x, y)
                        if overlays["SWITCHES"] and cell.map_type == 1 and cell.b % 4 == 2 and cell.first >= 8:
                            reference = cell.first // 8
                            marker(x, y, f"S{reference:X}", (255, 230, 90), 0)
                            if reference < len(switches) and switches[reference].action:
                                target = switches[reference]
                                if 0 <= target.x < tower_map.widths[selected_floor] and 0 <= target.y < tower_map.heights[selected_floor]:
                                    pygame.draw.rect(screen, (220, 180, 70), cell_screen_rect(target.x, target.y), 1)
                        if overlays["TRIGGERS"] and cell.map_type == 6 and cell.b % 8 in (2, 3, 6, 7):
                            reference = cell.first // 8
                            # Reference zero is the source's null/no-event
                            # trigger and is intentionally not marked.
                            if reference == 0:
                                continue
                            marker(x, y, f"T{reference:X}", (100, 255, 130), 1)
                            if reference < len(triggers):
                                target = triggers[reference]
                                target_floor_matches = (
                                    target.floor == selected_floor
                                    if target.action in TRIGGER_FLOOR_ACTIONS
                                    else True
                                )
                                if target.action in TRIGGER_XY_ACTIONS and target_floor_matches:
                                    if 0 <= target.x < tower_map.widths[selected_floor] and 0 <= target.y < tower_map.heights[selected_floor]:
                                        target_rect = cell_screen_rect(target.x, target.y)
                                        pygame.draw.line(
                                            screen,
                                            (55, 145, 85),
                                            cell_screen_rect(x, y).center,
                                            target_rect.center,
                                            max(1, zoom),
                                        )
                                        pygame.draw.rect(screen, (70, 210, 100), target_rect, max(1, zoom))
                                        marker(target.x, target.y, f"T{reference:X}", (100, 255, 130), 3)

        control_rects: tuple[tuple[str, str, object], ...] = ()
        running = True
        while running:
            mouse = pygame.mouse.get_pos()
            screen.fill((24, 26, 31))
            screen.blit(
                title_font.render("Bloodwych Map Viewer / Editor", True, (240, 240, 245)),
                (20, 16),
            )

            for index, (label, rectangle) in enumerate(zip(EDITOR_TABS, tab_rects)):
                draw_button(
                    rectangle,
                    label,
                    active=index == selected_tab,
                    enabled=EDITOR_TAB_ENABLED[index],
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
                    enabled=current_map().floor_exists(floor),
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
            if tower_map.floor_exists(selected_floor):
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

            for name, enabled, rectangle in zip(
                OVERLAY_NAMES, OVERLAY_ENABLED, overlay_rects
            ):
                draw_button(
                    rectangle,
                    name,
                    active=overlays[name],
                    enabled=enabled,
                )

            cell = current_cell()
            screen.blit(title_font.render(TOWERS[selected_tower].name, True, (255, 220, 80)), (810, 108))
            draw_info(f"FLOOR {selected_floor}", 140, (150, 200, 255))
            draw_info(f"SIZE {tower_map.widths[selected_floor]:02d} x {tower_map.heights[selected_floor]:02d}", 160, (180, 185, 195))
            draw_info(f"ALIGN {tower_map.x_offsets[selected_floor]:02d}, {tower_map.y_offsets[selected_floor]:02d}", 180, (180, 185, 195))
            draw_info(f"FREE ${tower_map.free_map_bytes:03X}", 200, (180, 185, 195))
            if cell is not None:
                draw_info(f"X ${selected_x:02X}   Y ${selected_y:02X}", 228, (245, 245, 245))
                draw_info(f"RAW ${cell.first:02X} ${cell.second:02X}   A{cell.a:X} B{cell.b:X} C{cell.c:X} D{cell.d:X}", 248, (165, 170, 180))
                draw_info(MAP_TYPE_NAMES[cell.map_type], 274, (150, 200, 255))
                description = describe_cell(cell)
                draw_info(description, 294)
                if cell.map_type == 1 and cell.b & 3 == 2 and cell.first >= 8:
                    reference = cell.first // 8
                    records = switch_records[selected_tower]
                    if reference < len(records):
                        record = records[reference]
                        action = SWITCH_ACTIONS.get(record.action, f"UNKNOWN ${record.action:02X}")
                        draw_info(f"SWITCH {reference}: {action} -> X ${record.x:02X}, Y ${record.y:02X}", 312, (235, 200, 105))
                        if project.save_data is not None:
                            draw_info("SHARED TABLE IS OUTSIDE THE SAVE (READ ONLY)", 330, (165, 170, 180))
                elif cell.map_type == 6 and cell.b & 3 in (2, 3):
                    reference = cell.first // 8
                    records = trigger_records[selected_tower]
                    if reference < len(records):
                        record = records[reference]
                        action = TRIGGER_ACTIONS.get(record.action, f"UNKNOWN ${record.action:02X}")
                        draw_info(f"TRIGGER {reference}: {action}", 312, (110, 230, 145))
                        if record.action in TRIGGER_XY_ACTIONS:
                            prefix = f"TARGET FLOOR {record.floor}, " if record.action in TRIGGER_FLOOR_ACTIONS else "TARGET "
                            draw_info(f"{prefix}X ${record.x:02X}, Y ${record.y:02X}", 330, (110, 230, 145))
                        elif project.save_data is not None:
                            draw_info("SHARED TABLE IS OUTSIDE THE SAVE (READ ONLY)", 330, (165, 170, 180))

            if selected_tab == 1:
                semantic_controls = list(controls_for_cell(cell)) if cell is not None else []
                common_controls = semantic_controls[-3:] if semantic_controls else []
                semantic_controls = semantic_controls[:-3] if semantic_controls else []
                if cell is not None and project.save_data is None:
                    if cell.map_type == 1 and cell.b & 3 == 2 and cell.first >= 8:
                        reference = cell.first // 8
                        if reference < len(switch_records[selected_tower]):
                            record = switch_records[selected_tower][reference]
                            semantic_controls.extend((
                                CellControl("SWITCH-ACTION-", "ACTION -"),
                                CellControl("SWITCH-ACTION+", "ACTION +"),
                                CellControl("SWITCH-X-", f"TARGET X -  ${record.x:02X}"),
                                CellControl("SWITCH-X+", f"TARGET X +  ${record.x:02X}"),
                                CellControl("SWITCH-Y-", f"TARGET Y -  ${record.y:02X}"),
                                CellControl("SWITCH-Y+", f"TARGET Y +  ${record.y:02X}"),
                            ))
                    elif cell.map_type == 6 and cell.b & 3 in (2, 3) and cell.first // 8:
                        reference = cell.first // 8
                        if reference < len(trigger_records[selected_tower]):
                            record = trigger_records[selected_tower][reference]
                            semantic_controls.extend((
                                CellControl("TRIGGER-ACTION-", "ACTION -"),
                                CellControl("TRIGGER-ACTION+", "ACTION +"),
                            ))
                            if record.action in TRIGGER_FLOOR_ACTIONS:
                                semantic_controls.extend((
                                    CellControl("TRIGGER-FLOOR-", f"FLOOR -  {record.floor}"),
                                    CellControl("TRIGGER-FLOOR+", f"FLOOR +  {record.floor}"),
                                ))
                            if record.action in TRIGGER_XY_ACTIONS:
                                semantic_controls.extend((
                                    CellControl("TRIGGER-X-", f"TARGET X -  ${record.x:02X}"),
                                    CellControl("TRIGGER-X+", f"TARGET X +  ${record.x:02X}"),
                                    CellControl("TRIGGER-Y-", f"TARGET Y -  ${record.y:02X}"),
                                    CellControl("TRIGGER-Y+", f"TARGET Y +  ${record.y:02X}"),
                                ))
                semantic_controls.extend(common_controls)
                control_rects = tuple(
                    (
                        control.action,
                        control.label,
                        pygame.Rect(810 + (index % 2) * 194, 348 + (index // 2) * 35, 188, 31),
                    )
                    for index, control in enumerate(semantic_controls)
                )
                for action, label, rectangle in control_rects:
                    draw_button(
                        rectangle,
                        label,
                        enabled=(action != "PASTE" or copied_cell is not None),
                    )
                draw_button(save_rect, "SAVE TO -MODIFIED", active=project.has_changes)
            else:
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
                    "SCENERY: EXTRACTED GAME GFX. OBJECTS/MONSTERS: LATER.",
                    preview_rect.bottom + 12,
                    (145, 150, 160),
                )
            draw_button(back_rect, "BACK")
            screen.blit(
                small_font.render(status_message, True, (230, 184, 105)),
                (270, 687),
            )
            screen.blit(
                small_font.render(
                    "ARROWS: CELL   C/V: COPY/PASTE   BACKSPACE: CLEAR   CTRL+S: SAVE",
                    True,
                    (145, 150, 160),
                ),
                (270, 713),
            )

            pygame.display.flip()
            if screenshot_path is not None:
                screenshot_path.parent.mkdir(parents=True, exist_ok=True)
                pygame.image.save(screen, str(screenshot_path))
                running = False

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        running = False
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
                    elif event.key == pygame.K_c:
                        apply_action("COPY")
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
                elif event.type == pygame.MOUSEWHEEL and map_rect.collidepoint(mouse):
                    set_zoom(zoom + (1 if event.y > 0 else -1), mouse)
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                    if back_rect.collidepoint(event.pos):
                        running = False
                        continue
                    for index, rectangle in enumerate(tab_rects):
                        if rectangle.collidepoint(event.pos) and EDITOR_TAB_ENABLED[index]:
                            selected_tab = index
                            break
                    for index, rectangle in enumerate(tower_rects):
                        if rectangle.collidepoint(event.pos):
                            selected_tower = index
                            selected_floor = default_floor(project, selected_tower)
                            selected_x = selected_y = 0
                            pan_x = pan_y = 0
                            clamp_pan()
                            break
                    for floor, rectangle in enumerate(floor_rects):
                        if rectangle.collidepoint(event.pos) and current_map().floor_exists(floor):
                            selected_floor = floor
                            selected_x = selected_y = 0
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
                        OVERLAY_NAMES, OVERLAY_ENABLED, overlay_rects
                    ):
                        if rectangle.collidepoint(event.pos):
                            if enabled:
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
                    if selected_tab == 1:
                        for action, _, rectangle in control_rects:
                            if rectangle.collidepoint(event.pos):
                                apply_action(action)
                                break
                        if save_rect.collidepoint(event.pos):
                            save_changes()
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button in (2, 3):
                    if map_rect.collidepoint(event.pos):
                        dragging_map = True
                        drag_origin = event.pos
                        pan_origin = (pan_x, pan_y)
                elif event.type == pygame.MOUSEBUTTONUP and event.button in (2, 3):
                    dragging_map = False
                elif event.type == pygame.MOUSEMOTION and dragging_map:
                    pan_x = pan_origin[0] + event.pos[0] - drag_origin[0]
                    pan_y = pan_origin[1] + event.pos[1] - drag_origin[1]
                    clamp_pan()
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
    args = parser.parse_args()
    launch_map_editor(
        args.data_root,
        savegame_path=args.savegame,
        screenshot_path=args.screenshot,
    )


if __name__ == "__main__":
    main()

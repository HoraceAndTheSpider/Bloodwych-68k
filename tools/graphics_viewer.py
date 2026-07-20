#!/usr/bin/env python3
"""Pygame preview UI for extracted Bloodwych graphics.

The first slice supports the Bloodwych 4.39 monster range ($64 upwards) and
renders Beholders from their extracted component metadata.  Other monster
types are visible in the selector and report the metadata still required
before their assembly renderers can be reproduced.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence

from tools.graphics_preview import (
    BeholderAssets,
    VIEW_HEIGHT,
    VIEW_WIDTH,
    load_floor_ceiling_background,
    render_beholder,
)
from tools.monster_view import (
    CENTRED_SUBPOSITIONS,
    FORMATION_SUBPOSITIONS,
    VIEW_CELL_COORDINATES,
    resolve_monster_screen_position,
    visible_subpositions,
)
from tools.st_planar_assets import GAME_PALETTE_RGB8


DATA_DIR = Path(__file__).resolve().parents[1] / "data"


class GraphicsViewerError(RuntimeError):
    """Raised when the viewer cannot load its optional runtime or data."""


WINDOW_SIZE = (1220, 760)
PREVIEW_SCALE = 5
FACING_NAMES = ("Front", "Side", "Back", "Mirrored side")
CATEGORY_NAMES = ("Monsters", "Humanoids", "Avatars", "Icons")
# The unmirrored Beholder side eye points screen-left; facing 3 mirrors it.
FACING_ARROW_DIRECTIONS = ((0, 1), (-1, 0), (0, -1), (1, 0))


@dataclass(frozen=True)
class MonsterDefinition:
    code: int
    name: str
    gfx_files: tuple[str, ...]
    companion_files: tuple[str, ...]
    renderer: str | None = None
    note: str = ""
    version: str = "BLOODWYCH439"

    @property
    def display_name(self) -> str:
        return f"${self.code:02X}  {self.name}"

    @property
    def subpositions(self) -> tuple[int, ...]:
        # Draw_Character and monster codes below $67 preserve the four-person
        # formation. Draw_Behemoth onwards force d1=4, the centred position.
        return FORMATION_SUBPOSITIONS if self.code < 0x67 else CENTRED_SUBPOSITIONS


@dataclass(frozen=True)
class MonsterFileStatus:
    existing_gfx: tuple[str, ...]
    missing_gfx: tuple[str, ...]
    existing_companions: tuple[str, ...]
    missing_companions: tuple[str, ...]

    @property
    def ready(self) -> bool:
        return not self.missing_gfx and not self.missing_companions


BEHOLDER_COMPANIONS = (
    "Beholder_Body.offsets",
    "Beholder_Body.heights",
    "Beholder_UpperEyes.offsets",
    "Beholder_UpperEyes.heights",
    "Beholder_CentralEye_Near.offsets",
    "Beholder_CentralEye_Near_Front.heights",
    "Beholder_CentralEye_Near_Side.heights",
    "Beholder_CentralEye_Near_Y.positions",
    "Beholder_CentralEye_Near_Side_Y.positions",
    "Beholder_CentralEye_Near_Side_Mirrored_X.positions",
    "Beholder_CentralEye_Far.offsets",
    "Beholder_CentralEye_Far_Y.positions",
    "Beholder_CentralEye_Far_Side_Mirrored_X.positions",
    "Beholder_Composite_X.positions",
    "Beholder_Composite_Y.positions",
    "Beholder_Near_MirroredHalf_X.positions",
    "beholder.colours",
    "monsters.palette",
)


MONSTERS = (
    MonsterDefinition(
        0x64,
        "Summon",
        ("Summon.gfx",),
        ("Summon.offsets", "Summon.heights", "Summon.positions"),
        note="$64 and $65 share the Summon graphics renderer.",
    ),
    MonsterDefinition(
        0x65,
        "Summon variant",
        ("Summon.gfx",),
        ("Summon.offsets", "Summon.heights", "Summon.positions"),
        note="Uses the same graphics as $64; game state selects its variant.",
    ),
    MonsterDefinition(
        0x66,
        "Beholder",
        (
            "Beholder_Body.gfx",
            "Beholder_UpperEyes.gfx",
            "Beholder_CentralEye_Near.gfx",
            "Beholder_CentralEye_Far.gfx",
        ),
        BEHOLDER_COMPANIONS,
        renderer="beholder",
        note="Complete component, position, animation, and grade metadata.",
    ),
    MonsterDefinition(
        0x67,
        "Behemoth",
        ("Behemoth.gfx",),
        ("Behemoth.offsets", "Behemoth.heights", "Behemoth.positions"),
    ),
    MonsterDefinition(
        0x68,
        "Crab",
        ("Crab.gfx", "CrabClaw.gfx"),
        ("Crab.offsets", "Crab.heights", "Crab.positions"),
    ),
    MonsterDefinition(
        0x69,
        "Large dragon",
        ("Dragon.gfx",),
        ("Dragon.offsets", "Dragon.heights", "Dragon.positions"),
        note="$69 and $6A share the extracted Dragon graphics block.",
    ),
    MonsterDefinition(
        0x6A,
        "Small dragon",
        ("Dragon.gfx",),
        ("Dragon.offsets", "Dragon.heights", "Dragon.positions"),
        note="$69 and $6A share the extracted Dragon graphics block.",
    ),
    MonsterDefinition(
        0x6B,
        "Entropy",
        ("Entropy.gfx",),
        ("Entropy.offsets", "Entropy.heights", "Entropy.positions"),
    ),
    MonsterDefinition(
        0x6C,
        "Extended Entropy",
        ("Entropy.gfx",),
        ("Entropy.offsets", "Entropy.heights", "Entropy.positions"),
        note="Expected in BEXT; not dispatched by the Bloodwych 4.39 monster table.",
        version="BEXT43",
    ),
)


def inspect_monster_files(definition: MonsterDefinition, monsters_dir: Path) -> MonsterFileStatus:
    def split(files: Sequence[str]) -> tuple[tuple[str, ...], tuple[str, ...]]:
        existing = tuple(name for name in files if (monsters_dir / name).is_file())
        missing = tuple(name for name in files if name not in existing)
        return existing, missing

    existing_gfx, missing_gfx = split(definition.gfx_files)
    existing_companions, missing_companions = split(definition.companion_files)
    return MonsterFileStatus(
        existing_gfx,
        missing_gfx,
        existing_companions,
        missing_companions,
    )


def indexed_to_surface(pygame: object, pixels: Sequence[Sequence[int]]) -> object:
    width = len(pixels[0]) if pixels else 0
    height = len(pixels)
    rgb = bytes(
        channel
        for row in pixels
        for index in row
        for channel in GAME_PALETTE_RGB8[index]
    )
    return pygame.image.fromstring(rgb, (width, height), "RGB")


def wrap_text(font: object, text: str, width: int) -> list[str]:
    lines: list[str] = []
    for paragraph in text.splitlines() or ("",):
        words = paragraph.split()
        current = ""
        for word in words:
            candidate = f"{current} {word}".strip()
            if current and font.size(candidate)[0] > width:
                lines.append(current)
                current = word
            else:
                current = candidate
        lines.append(current)
    return lines


def launch_graphics_viewer(
    data_root: Path | None = None, *, screenshot_path: Path | None = None
) -> None:
    """Open the first SuperApp graphics viewer and return when it closes."""
    try:
        import pygame
    except ImportError as error:
        raise GraphicsViewerError(
            "Pygame is required for the graphics viewer. Install requirements.txt."
        ) from error

    data_root = data_root or DATA_DIR / "BLOODWYCH439-clean"
    gfx_dir = data_root / "gfx"
    monsters_dir = data_root / "monsters"
    if not gfx_dir.is_dir() or not monsters_dir.is_dir():
        raise GraphicsViewerError(f"Graphics viewer data is missing below {data_root}")

    background = load_floor_ceiling_background(gfx_dir)
    beholder_assets: BeholderAssets | None = None
    beholder_error: str | None = None
    try:
        beholder_assets = BeholderAssets(monsters_dir)
    except (OSError, ValueError, RuntimeError) as error:
        beholder_error = str(error)

    pygame.init()
    pygame.key.set_repeat(250, 45)
    try:
        screen = pygame.display.set_mode(WINDOW_SIZE)
        pygame.display.set_caption("Bloodwych ReSource - Graphics Viewer")
        title_font = pygame.font.SysFont(None, 30)
        font = pygame.font.SysFont(None, 22)
        small_font = pygame.font.SysFont(None, 18)
        clock = pygame.time.Clock()

        selected_index = 2
        selected_view_cell = 16
        selected_subposition = 0
        facing = 0
        grade_step = 0
        animation_frame = 0
        nudge_x = 0
        nudge_y = 0

        category_rects = [
            pygame.Rect(20 + index * 152, 52, 142, 34)
            for index in range(len(CATEGORY_NAMES))
        ]
        monster_rects = [
            pygame.Rect(20, 112 + index * 49, 220, 40)
            for index in range(len(MONSTERS))
        ]
        control_specs = (
            ("facing_down", "Facing -", (270, 540, 108, 34)),
            ("facing_up", "Facing +", (384, 540, 108, 34)),
            ("grade_down", "Grade -", (510, 540, 96, 34)),
            ("grade_up", "Grade +", (612, 540, 96, 34)),
            ("frame", "Animate", (726, 540, 100, 34)),
            ("left", "X -", (270, 628, 70, 34)),
            ("right", "X +", (346, 628, 70, 34)),
            ("up", "Y -", (422, 628, 70, 34)),
            ("down", "Y +", (498, 628, 70, 34)),
            ("reset", "Reset offset", (574, 628, 112, 34)),
            ("back", "Back", (20, 700, 100, 36)),
        )
        controls = {
            name: (pygame.Rect(rectangle), label)
            for name, label, rectangle in control_specs
        }

        def adjust(action: str) -> bool:
            nonlocal facing, grade_step, animation_frame, nudge_x, nudge_y
            if action == "facing_down":
                facing = (facing - 1) % 4
            elif action == "facing_up":
                facing = (facing + 1) % 4
            elif action == "grade_down":
                grade_step = max(0, grade_step - 1)
            elif action == "grade_up":
                grade_step = min(7, grade_step + 1)
            elif action == "left":
                nudge_x -= 1
            elif action == "right":
                nudge_x += 1
            elif action == "up":
                nudge_y -= 1
            elif action == "down":
                nudge_y += 1
            elif action == "reset":
                nudge_x = nudge_y = 0
            elif action == "frame":
                animation_frame ^= 1
            elif action == "back":
                return False
            return True

        def choose_valid_subposition(definition: MonsterDefinition) -> None:
            nonlocal selected_view_cell, selected_subposition, nudge_x, nudge_y
            available = visible_subpositions(selected_view_cell, definition.subpositions)
            if selected_subposition in available:
                return
            preferred_cells = (16, 17, 15, 14) + tuple(range(18))
            for cell in preferred_cells:
                available = visible_subpositions(cell, definition.subpositions)
                if available:
                    selected_view_cell = cell
                    selected_subposition = available[0]
                    break
            nudge_x = nudge_y = 0

        running = True
        while running:
            definition = MONSTERS[selected_index]
            choose_valid_subposition(definition)
            screen_position = resolve_monster_screen_position(
                selected_view_cell, selected_subposition
            )
            if screen_position is None:
                raise GraphicsViewerError("No valid monster view position is available")
            status = inspect_monster_files(definition, monsters_dir)
            preview_pixels = [row[:] for row in background]
            preview_metadata: dict[str, object] | None = None
            if definition.renderer == "beholder" and status.ready and beholder_assets:
                preview_pixels, preview_metadata = render_beholder(
                    background,
                    beholder_assets,
                    screen_position.gfx_slot,
                    facing,
                    grade_step=grade_step,
                    animation_frame=animation_frame,
                    anchor_x=screen_position.screen_x + nudge_x,
                    anchor_y=screen_position.screen_y + nudge_y,
                )

            mouse = pygame.mouse.get_pos()
            screen.fill((24, 26, 31))
            screen.blit(
                title_font.render("Bloodwych Graphics Viewer", True, (240, 240, 245)),
                (20, 16),
            )

            for index, (name, rectangle) in enumerate(zip(CATEGORY_NAMES, category_rects)):
                active = index == 0
                colour = (54, 105, 170) if active else (52, 55, 63)
                pygame.draw.rect(screen, colour, rectangle, border_radius=4)
                suffix = "" if active else " (planned)"
                text_colour = (245, 245, 245) if active else (150, 150, 155)
                label = small_font.render(name + suffix, True, text_colour)
                screen.blit(label, label.get_rect(center=rectangle.center))

            for index, (definition_item, rectangle) in enumerate(zip(MONSTERS, monster_rects)):
                selected = index == selected_index
                hovered = rectangle.collidepoint(mouse)
                colour = (
                    (61, 110, 174)
                    if selected
                    else ((58, 61, 70) if hovered else (43, 46, 54))
                )
                pygame.draw.rect(screen, colour, rectangle, border_radius=4)
                label = font.render(definition_item.display_name, True, (244, 244, 248))
                screen.blit(label, (rectangle.x + 10, rectangle.y + 10))

            preview_rect = pygame.Rect(
                270,
                112,
                VIEW_WIDTH * PREVIEW_SCALE,
                VIEW_HEIGHT * PREVIEW_SCALE,
            )
            pygame.draw.rect(screen, (8, 8, 10), preview_rect.inflate(6, 6))
            native_surface = indexed_to_surface(pygame, preview_pixels)
            scaled_surface = pygame.transform.scale(native_surface, preview_rect.size)
            screen.blit(scaled_surface, preview_rect)

            if definition.renderer != "beholder" or not status.ready or not beholder_assets:
                overlay = pygame.Surface(preview_rect.size, pygame.SRCALPHA)
                overlay.fill((0, 0, 0, 125))
                screen.blit(overlay, preview_rect)
                message = "Renderer pending: required companion data is listed on the right."
                if definition.renderer == "beholder" and beholder_error:
                    message = f"Beholder renderer error: {beholder_error}"
                y = preview_rect.centery - 22
                for line in wrap_text(font, message, preview_rect.width - 60):
                    text_surface = font.render(line, True, (255, 220, 145))
                    screen.blit(
                        text_surface,
                        text_surface.get_rect(center=(preview_rect.centerx, y)),
                    )
                    y += 24

            lane_name = (
                "centre lane"
                if screen_position.dungeon_x == 0
                else f"lane {screen_position.dungeon_x:+d}"
            )
            status_text = (
                f"{screen_position.forward_distance} ahead, {lane_name}  |  "
                f"{screen_position.subposition_name}  |  image {screen_position.gfx_slot}  |  "
                f"anchor ({screen_position.screen_x + nudge_x}, "
                f"{screen_position.screen_y + nudge_y})"
            )
            screen.blit(font.render(status_text, True, (225, 225, 230)), (270, 503))

            for action, (rectangle, label_text) in controls.items():
                hovered = rectangle.collidepoint(mouse)
                colour = (69, 112, 169) if hovered else (52, 76, 108)
                pygame.draw.rect(screen, colour, rectangle, border_radius=4)
                label = font.render(label_text, True, (250, 250, 250))
                screen.blit(label, label.get_rect(center=rectangle.center))

            help_text = (
                f"Facing: {FACING_NAMES[facing]}  |  grade: base +{grade_step}.  "
                "Click a mini-space; arrow keys apply a one-pixel preview offset."
            )
            screen.blit(small_font.render(help_text, True, (178, 181, 189)), (270, 590))

            details_x = 935
            screen.blit(
                font.render("Source-verified view position", True, (240, 240, 245)),
                (details_x, 112),
            )

            grid_left = 946
            grid_top = 142
            cell_size = 43
            slot_margin = 3
            slot_gap = 2
            slot_size = (cell_size - slot_margin * 2 - slot_gap) // 2
            slot_quadrants = {
                2: (0, 0),  # rear left
                3: (1, 0),  # rear right
                1: (0, 1),  # near left
                0: (1, 1),  # near right
            }
            slot_hit_rects: list[tuple[object, int, int]] = []

            for column, lane in enumerate(("-2", "-1", "0", "+1", "+2")):
                label = small_font.render(lane, True, (142, 147, 157))
                label_x = grid_left + column * cell_size + (cell_size - 2) // 2
                screen.blit(label, label.get_rect(center=(label_x, grid_top - 7)))
            for forward_distance in range(4, 0, -1):
                label_y = grid_top + (4 - forward_distance) * cell_size + 12
                screen.blit(
                    small_font.render(str(forward_distance), True, (142, 147, 157)),
                    (grid_left - 11, label_y),
                )

            def draw_facing_arrow(rectangle: object) -> None:
                direction_x, direction_y = FACING_ARROW_DIRECTIONS[facing]
                centre = pygame.Vector2(rectangle.center)
                direction = pygame.Vector2(direction_x, direction_y)
                start = centre - direction * 4
                end = centre + direction * 6
                pygame.draw.line(screen, (255, 238, 120), start, end, 2)
                perpendicular = pygame.Vector2(-direction_y, direction_x)
                points = (
                    end,
                    end - direction * 4 + perpendicular * 3,
                    end - direction * 4 - perpendicular * 3,
                )
                pygame.draw.polygon(screen, (255, 238, 120), points)

            for view_cell, (dungeon_x, dungeon_y) in enumerate(VIEW_CELL_COORDINATES[:18]):
                forward_distance = -dungeon_y
                if not 1 <= forward_distance <= 4:
                    continue
                cell_rect = pygame.Rect(
                    grid_left + (dungeon_x + 2) * cell_size,
                    grid_top + (4 - forward_distance) * cell_size,
                    cell_size - 2,
                    cell_size - 2,
                )
                available = visible_subpositions(view_cell, definition.subpositions)
                cell_colour = (41, 47, 57) if available else (29, 32, 38)
                pygame.draw.rect(screen, cell_colour, cell_rect)
                pygame.draw.rect(screen, (73, 81, 95), cell_rect, 1)

                if definition.subpositions == CENTRED_SUBPOSITIONS:
                    centre_rect = pygame.Rect(0, 0, 17, 17)
                    centre_rect.center = cell_rect.center
                    if 4 in available:
                        selected = selected_view_cell == view_cell
                        colour = (222, 116, 55) if selected else (65, 113, 167)
                        pygame.draw.ellipse(screen, colour, centre_rect)
                        slot_hit_rects.append((centre_rect, view_cell, 4))
                        if selected:
                            draw_facing_arrow(centre_rect)
                    continue

                for subposition, (column, row) in slot_quadrants.items():
                    slot_rect = pygame.Rect(
                        cell_rect.x + slot_margin + column * (slot_size + slot_gap),
                        cell_rect.y + slot_margin + row * (slot_size + slot_gap),
                        slot_size,
                        slot_size,
                    )
                    if subposition in available:
                        selected = (
                            selected_view_cell == view_cell
                            and selected_subposition == subposition
                        )
                        colour = (222, 116, 55) if selected else (65, 113, 167)
                        if slot_rect.collidepoint(mouse) and not selected:
                            colour = (80, 137, 199)
                        pygame.draw.rect(screen, colour, slot_rect, border_radius=2)
                        slot_hit_rects.append((slot_rect, view_cell, subposition))
                        if selected:
                            draw_facing_arrow(slot_rect)
                    else:
                        pygame.draw.rect(screen, (24, 27, 32), slot_rect, 1)

            player_rect = pygame.Rect(
                grid_left + 2 * cell_size + 10,
                grid_top + 4 * cell_size + 4,
                20,
                20,
            )
            pygame.draw.rect(screen, (202, 98, 48), player_rect, border_radius=4)
            pygame.draw.line(
                screen,
                (255, 230, 100),
                (player_rect.centerx, player_rect.y + 4),
                (player_rect.centerx, player_rect.y - 5),
                2,
            )
            pygame.draw.polygon(
                screen,
                (255, 230, 100),
                (
                    (player_rect.centerx, player_rect.y - 8),
                    (player_rect.centerx - 4, player_rect.y - 2),
                    (player_rect.centerx + 4, player_rect.y - 2),
                ),
            )
            screen.blit(
                small_font.render(
                    "Blue = visible  |  orange arrow = monster facing",
                    True,
                    (178, 181, 189),
                ),
                (details_x, 345),
            )

            screen.blit(
                title_font.render(definition.display_name, True, (240, 240, 245)),
                (details_x, 374),
            )
            details_y = 408

            def detail_block(
                title: str,
                values: Sequence[str],
                colour: tuple[int, int, int],
            ) -> None:
                nonlocal details_y
                if details_y > WINDOW_SIZE[1] - 24:
                    return
                screen.blit(font.render(title, True, colour), (details_x, details_y))
                details_y += 22
                if not values:
                    values = ("None",)
                for value in values:
                    for line in wrap_text(small_font, value, 255):
                        if details_y > WINDOW_SIZE[1] - 20:
                            return
                        screen.blit(
                            small_font.render(line, True, (204, 206, 212)),
                            (details_x + 8, details_y),
                        )
                        details_y += 18
                details_y += 7

            graphics_present = status.existing_gfx
            if len(graphics_present) > 2:
                graphics_present = (f"{len(graphics_present)} files",)
            detail_block("Graphics present", graphics_present, (126, 218, 151))
            detail_block("Graphics missing", status.missing_gfx, (244, 148, 135))
            companion_summary = status.existing_companions
            if len(companion_summary) > 6:
                companion_summary = (f"{len(companion_summary)} files (complete)",)
            detail_block("Companions present", companion_summary, (126, 218, 151))
            detail_block("Companions missing", status.missing_companions, (244, 184, 115))
            if definition.note:
                detail_block("Notes", (definition.note,), (155, 188, 239))
            if definition.version != "BLOODWYCH439":
                detail_block("Version", (definition.version,), (155, 188, 239))
            if preview_metadata:
                palette = preview_metadata["replacement_palette_indices"]
                detail_block("Selected palette", (str(palette),), (155, 188, 239))

            pygame.display.flip()
            if screenshot_path is not None:
                screenshot_path.parent.mkdir(parents=True, exist_ok=True)
                pygame.image.save(screen, str(screenshot_path))
                running = False
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    keyboard_actions = {
                        pygame.K_LEFT: "left",
                        pygame.K_RIGHT: "right",
                        pygame.K_UP: "up",
                        pygame.K_DOWN: "down",
                        pygame.K_ESCAPE: "back",
                    }
                    if event.key in keyboard_actions:
                        running = adjust(keyboard_actions[event.key])
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
                    for index, rectangle in enumerate(monster_rects):
                        if rectangle.collidepoint(event.pos):
                            selected_index = index
                            break
                    for rectangle, view_cell, subposition in slot_hit_rects:
                        if rectangle.collidepoint(event.pos):
                            selected_view_cell = view_cell
                            selected_subposition = subposition
                            nudge_x = nudge_y = 0
                            break
                    for action, (rectangle, _) in controls.items():
                        if rectangle.collidepoint(event.pos):
                            running = adjust(action)
                            break
            clock.tick(60)
    finally:
        pygame.quit()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-root", type=Path)
    parser.add_argument(
        "--screenshot",
        type=Path,
        help="save the initial viewer frame and exit (useful for visual testing)",
    )
    args = parser.parse_args()
    launch_graphics_viewer(args.data_root, screenshot_path=args.screenshot)


if __name__ == "__main__":
    main()

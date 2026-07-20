#!/usr/bin/env python3
"""Build editable avatar sheets and Beholder previews from extracted game data.

This is deliberately a data-driven preview tool.  It reads the same graphics,
lookup, height, position, colour, and wall-layout files that the 68k renderer
uses.  The generated PNGs are derivatives; the extracted planar files remain
the authoritative project data.
"""

from __future__ import annotations

import argparse
import json
import struct
from dataclasses import dataclass
from pathlib import Path
from typing import Sequence

if __package__:
    from tools.st_planar_assets import (
        decode_planar,
        encode_planar,
        read_tables,
        write_indexed_png,
    )
else:  # Permit the repository's established ``python tools/name.py`` usage.
    from st_planar_assets import decode_planar, encode_planar, read_tables, write_indexed_png


DATA_DIR = Path(__file__).resolve().parents[1] / "data"


VIEW_WIDTH = 128
VIEW_HEIGHT = 76
TRANSPARENT_INDEX = 15
GUIDE_BORDER_INDEX = 12
TEMPLATE_COLOUR_INDICES = (0, 4, 8, 12)


@dataclass(frozen=True)
class IndexedSprite:
    name: str
    source_file: str
    byte_offset: int
    pixels: list[list[int]]
    source_byte_offset: int | None = None

    @property
    def width(self) -> int:
        return len(self.pixels[0]) if self.pixels else 0

    @property
    def height(self) -> int:
        return len(self.pixels)

    @property
    def byte_size(self) -> int:
        return self.width // 16 * self.height * 8


@dataclass(frozen=True)
class DrawOperation:
    sprite: IndexedSprite
    x: int
    y: int
    mirrored: bool = False


def read_u16be(path: Path) -> list[int]:
    data = path.read_bytes()
    if len(data) % 2:
        raise ValueError(f"{path.name} is not word-aligned")
    return list(struct.unpack(f">{len(data) // 2}H", data))


def read_s8(path: Path) -> list[int]:
    return [value - 256 if value >= 128 else value for value in path.read_bytes()]


def decode_fixed_sprites(
    path: Path,
    *,
    width_words: int,
    height: int,
    count: int,
    name_prefix: str,
) -> list[IndexedSprite]:
    data = path.read_bytes()
    sprite_size = width_words * height * 8
    expected_size = sprite_size * count
    if len(data) != expected_size:
        raise ValueError(f"{path.name}: expected {expected_size} bytes, got {len(data)}")
    sprites = []
    for index in range(count):
        offset = index * sprite_size
        raw = data[offset : offset + sprite_size]
        pixels = decode_planar(raw, width_words, height)
        if encode_planar(pixels) != raw:
            raise RuntimeError(f"{path.name} sprite {index}: codec round trip failed")
        sprites.append(IndexedSprite(f"{name_prefix}_{index:02d}", path.name, offset, pixels))
    return sprites


def remap_template_colours(
    pixels: Sequence[Sequence[int]], replacements: Sequence[int]
) -> list[list[int]]:
    """Apply the game's four-colour template substitution.

    The 68k colour-mask routine replaces only pixels whose two low colour bits
    are clear: palette indices 0, 4, 8, and 12.  Other palette indices are
    deliberately retained, including index 15 transparency.
    """
    if len(replacements) != 4 or any(not 0 <= value <= 15 for value in replacements):
        raise ValueError("replacements must contain four palette indices")
    mapping = dict(zip(TEMPLATE_COLOUR_INDICES, replacements))
    return [[mapping.get(colour, colour) for colour in row] for row in pixels]


def mirror_pixels(pixels: Sequence[Sequence[int]]) -> list[list[int]]:
    return [list(reversed(row)) for row in pixels]


def blit(
    canvas: list[list[int]],
    pixels: Sequence[Sequence[int]],
    x: int,
    y: int,
    *,
    transparent_index: int | None = TRANSPARENT_INDEX,
) -> None:
    height = len(canvas)
    width = len(canvas[0]) if canvas else 0
    for source_y, row in enumerate(pixels):
        target_y = y + source_y
        if not 0 <= target_y < height:
            continue
        for source_x, colour in enumerate(row):
            target_x = x + source_x
            if 0 <= target_x < width and (
                transparent_index is None or colour != transparent_index
            ):
                canvas[target_y][target_x] = colour


def make_sheet(
    sprites: Sequence[IndexedSprite],
    *,
    columns: int = 4,
    gap: int = 1,
    background: int = TRANSPARENT_INDEX,
    transparent_index: int | None = TRANSPARENT_INDEX,
) -> list[list[int]]:
    if not sprites:
        raise ValueError("at least one sprite is required")
    tile_width = max(sprite.width for sprite in sprites)
    tile_height = max(sprite.height for sprite in sprites)
    rows = (len(sprites) + columns - 1) // columns
    width = columns * tile_width + (columns - 1) * gap
    height = rows * tile_height + (rows - 1) * gap
    canvas = [[background] * width for _ in range(height)]
    for index, sprite in enumerate(sprites):
        x = (index % columns) * (tile_width + gap)
        y = (index // columns) * (tile_height + gap)
        blit(canvas, sprite.pixels, x, y, transparent_index=transparent_index)
    return canvas


def make_guide_template(sprite: IndexedSprite) -> list[list[int]]:
    """Put an exact editable sprite inside a one-pixel red guide border."""
    width, height = sprite.width + 2, sprite.height + 2
    canvas = [[TRANSPARENT_INDEX] * width for _ in range(height)]
    for x in range(width):
        canvas[0][x] = canvas[-1][x] = GUIDE_BORDER_INDEX
    for y in range(height):
        canvas[y][0] = canvas[y][-1] = GUIDE_BORDER_INDEX
    for y, row in enumerate(sprite.pixels, start=1):
        canvas[y][1 : 1 + sprite.width] = row
    return canvas


class BeholderAssets:
    """Decoded Beholder strips and renderer-owned metadata tables."""

    def __init__(self, monsters_dir: Path):
        self.monsters_dir = monsters_dir
        self.body = self._load_group(
            "Beholder_Body", 0x000, read_s8(monsters_dir / "Beholder_Body.heights")
        )
        self.upper = self._load_group(
            "Beholder_UpperEyes", 0x2A0, read_s8(monsters_dir / "Beholder_UpperEyes.heights")
        )

        near_front_heights = read_s8(
            monsters_dir / "Beholder_CentralEye_Near_Front.heights"
        )
        near_side_heights = read_s8(
            monsters_dir / "Beholder_CentralEye_Near_Side.heights"
        )
        near_heights = [height for height in near_front_heights for _ in range(2)]
        near_heights += [height for height in near_side_heights for _ in range(2)]
        self.near = self._load_group("Beholder_CentralEye_Near", 0x340, near_heights)
        self.far = self._load_group("Beholder_CentralEye_Far", 0x6A0, [2] * 4)

        self.composite_x = read_s8(monsters_dir / "Beholder_Composite_X.positions")
        self.composite_y = read_s8(monsters_dir / "Beholder_Composite_Y.positions")
        self.near_y = read_s8(monsters_dir / "Beholder_CentralEye_Near_Y.positions")
        self.near_side_y = read_s8(
            monsters_dir / "Beholder_CentralEye_Near_Side_Y.positions"
        )
        self.near_side_mirrored_x = read_s8(
            monsters_dir / "Beholder_CentralEye_Near_Side_Mirrored_X.positions"
        )
        self.far_y = read_s8(monsters_dir / "Beholder_CentralEye_Far_Y.positions")
        self.far_side_mirrored_x = read_s8(
            monsters_dir / "Beholder_CentralEye_Far_Side_Mirrored_X.positions"
        )
        self.near_mirrored_half_x = read_s8(
            monsters_dir / "Beholder_Near_MirroredHalf_X.positions"
        )

        self.grade_lookup = list((monsters_dir / "beholder.colours").read_bytes())
        palette_bytes = list((monsters_dir / "monsters.palette").read_bytes())
        if len(palette_bytes) % 4:
            raise ValueError("monsters.palette must contain four-byte palettes")
        self.monster_palettes = [
            palette_bytes[index : index + 4] for index in range(0, len(palette_bytes), 4)
        ]
        self._validate_metadata()

    def _load_group(
        self, stem: str, combined_base: int, heights_minus_one: Sequence[int]
    ) -> list[IndexedSprite]:
        gfx_path = self.monsters_dir / f"{stem}.gfx"
        data = gfx_path.read_bytes()
        offsets = read_u16be(self.monsters_dir / f"{stem}.offsets")
        if len(offsets) != len(heights_minus_one):
            raise ValueError(
                f"{stem}: {len(offsets)} offsets but {len(heights_minus_one)} heights"
            )
        sprites = []
        for index, (source_offset, height_minus_one) in enumerate(
            zip(offsets, heights_minus_one)
        ):
            local_offset = source_offset - combined_base
            height = height_minus_one + 1
            byte_size = height * 8
            expected_end = (
                offsets[index + 1] - combined_base
                if index + 1 < len(offsets)
                else len(data)
            )
            if local_offset < 0 or local_offset + byte_size != expected_end:
                raise ValueError(
                    f"{stem} sprite {index}: geometry ends at {local_offset + byte_size:#x}, "
                    f"next boundary is {expected_end:#x}"
                )
            raw = data[local_offset:expected_end]
            pixels = decode_planar(raw, 1, height)
            if encode_planar(pixels) != raw:
                raise RuntimeError(f"{stem} sprite {index}: codec round trip failed")
            sprites.append(
                IndexedSprite(
                    f"{stem}_{index:02d}",
                    gfx_path.name,
                    local_offset,
                    pixels,
                    source_byte_offset=source_offset,
                )
            )
        return sprites

    def _validate_metadata(self) -> None:
        expected_lengths = {
            "composite_x": 6,
            "composite_y": 6,
            "near_y": 4,
            "near_side_y": 4,
            "near_side_mirrored_x": 4,
            "far_y": 2,
            "far_side_mirrored_x": 2,
            "near_mirrored_half_x": 2,
            "grade_lookup": 8,
        }
        for name, expected in expected_lengths.items():
            actual = len(getattr(self, name))
            if actual != expected:
                raise ValueError(f"Beholder {name}: expected {expected} entries, got {actual}")
        if any(index >= len(self.monster_palettes) for index in self.grade_lookup):
            raise ValueError("Beholder colour lookup references a missing monster palette")

    def replacement_palette(self, grade_step: int) -> list[int]:
        if not 0 <= grade_step < len(self.grade_lookup):
            raise ValueError("Beholder grade step must be from 0 to 7")
        return self.monster_palettes[self.grade_lookup[grade_step]]

    def all_sprites(self) -> list[IndexedSprite]:
        return self.body + self.upper + self.near + self.far

    def draw_operations(
        self,
        distance: int,
        facing: int,
        *,
        animation_frame: int = 0,
        upper_eye_lift: int = 0,
    ) -> list[DrawOperation]:
        """Reproduce Draw_Beholder's component selection and relative placement.

        `facing` follows the game routine: 0 front, 1 side, 2 back, and 3 the
        mirrored side.  Distances are the renderer's six levels, 0 through 5.
        """
        if not 0 <= distance <= 5 or not 0 <= facing <= 3:
            raise ValueError("distance must be 0..5 and facing must be 0..3")
        if animation_frame not in (0, 1) or upper_eye_lift not in (0, 1):
            raise ValueError("animation frame and upper-eye lift must be 0 or 1")

        x = self.composite_x[distance]
        y = self.composite_y[distance]
        operations: list[DrawOperation] = []

        def add_component(sprite: IndexedSprite, component_x: int, component_y: int) -> None:
            operations.append(DrawOperation(sprite, component_x, component_y))
            if distance < 2:
                operations.append(
                    DrawOperation(
                        sprite,
                        component_x + self.near_mirrored_half_x[distance],
                        component_y,
                        True,
                    )
                )

        add_component(self.body[distance], x, y)

        if distance < 4:
            upper = self.upper[distance]
            upper_y = y - (upper.height - 1) - upper_eye_lift
            add_component(upper, x, upper_y)

        if facing == 2:
            return operations

        if distance < 4:
            eye_y = y + self.near_y[distance]
            if facing == 0:
                sprite = self.near[distance * 2 + animation_frame]
                add_component(sprite, x, eye_y)
            else:
                sprite = self.near[8 + distance * 2 + animation_frame]
                eye_y += self.near_side_y[distance]
                mirrored = facing == 3
                eye_x = x + (self.near_side_mirrored_x[distance] if mirrored else 0)
                operations.append(DrawOperation(sprite, eye_x, eye_y, mirrored))
        else:
            far_distance = distance - 4
            eye_y = y + self.far_y[far_distance]
            side = facing != 0
            sprite = self.far[far_distance + (2 if side else 0)]
            mirrored = facing == 3
            eye_x = x + (self.far_side_mirrored_x[far_distance] if mirrored else 0)
            operations.append(DrawOperation(sprite, eye_x, eye_y, mirrored))

        return operations


def operation_bounds(operations: Sequence[DrawOperation]) -> tuple[int, int, int, int]:
    occupied: list[tuple[int, int]] = []
    for operation in operations:
        pixels = (
            mirror_pixels(operation.sprite.pixels)
            if operation.mirrored
            else operation.sprite.pixels
        )
        for y, row in enumerate(pixels):
            for x, colour in enumerate(row):
                if colour != TRANSPARENT_INDEX:
                    occupied.append((operation.x + x, operation.y + y))
    if not occupied:
        return (0, 0, 0, 0)
    return (
        min(point[0] for point in occupied),
        min(point[1] for point in occupied),
        max(point[0] for point in occupied) + 1,
        max(point[1] for point in occupied) + 1,
    )


def render_beholder(
    background: Sequence[Sequence[int]],
    assets: BeholderAssets,
    distance: int,
    facing: int,
    *,
    grade_step: int = 0,
    animation_frame: int = 0,
    centre_x: int = VIEW_WIDTH // 2,
    centre_y: int = VIEW_HEIGHT // 2,
    anchor_x: int | None = None,
    anchor_y: int | None = None,
) -> tuple[list[list[int]], dict[str, object]]:
    operations = assets.draw_operations(distance, facing, animation_frame=animation_frame)
    left, top, right, bottom = operation_bounds(operations)
    if (anchor_x is None) != (anchor_y is None):
        raise ValueError("anchor_x and anchor_y must be supplied together")
    if anchor_x is None:
        shift_x = centre_x - (left + right - 1) // 2
        shift_y = centre_y - (top + bottom - 1) // 2
        positioning_mode = "centred-preview"
    else:
        # d4/d5 returned by Prepare_Monster_ScreenPosition are the base added
        # to the component positions inside Draw_Beholder.
        shift_x = anchor_x
        shift_y = anchor_y
        positioning_mode = "game-anchor"
    replacements = assets.replacement_palette(grade_step)
    canvas = [list(row) for row in background]

    records = []
    for operation in operations:
        pixels = remap_template_colours(operation.sprite.pixels, replacements)
        if operation.mirrored:
            pixels = mirror_pixels(pixels)
        target_x, target_y = operation.x + shift_x, operation.y + shift_y
        blit(canvas, pixels, target_x, target_y)
        records.append(
            {
                "sprite": operation.sprite.name,
                "x": target_x,
                "y": target_y,
                "mirrored": operation.mirrored,
            }
        )

    return canvas, {
        "distance": distance,
        "facing": facing,
        "animation_frame": animation_frame,
        "grade_step": grade_step,
        "replacement_palette_indices": replacements,
        "requested_centre": [centre_x, centre_y],
        "requested_game_anchor": (
            [anchor_x, anchor_y] if anchor_x is not None else None
        ),
        "positioning_mode": positioning_mode,
        "unshifted_opaque_bounds": [left, top, right, bottom],
        "anchor_shift": [shift_x, shift_y],
        "operations": records,
    }


def load_floor_ceiling_background(gfx_dir: Path) -> list[list[int]]:
    """Reproduce the game's 23-row ceiling, gap, and 34-row floor layout."""
    data = (gfx_dir / "FloorCeiling.gfx").read_bytes()
    pixels = decode_planar(data, 8, 57)
    canvas = [[0] * VIEW_WIDTH for _ in range(VIEW_HEIGHT)]
    for y, row in enumerate(pixels[:23]):
        canvas[y] = row
    for y, row in enumerate(pixels[23:], start=42):
        canvas[y] = row
    return canvas


def load_wall_background(gfx_dir: Path) -> list[list[int]]:
    gfx, offsets, positions = read_tables(
        gfx_dir / "Main_Walls.gfx",
        gfx_dir / "Main_Walls.offsets",
        gfx_dir / "Main_Walls.positions",
    )
    canvas = [[0] * VIEW_WIDTH for _ in range(VIEW_HEIGHT)]
    for index, (offset, (x_half, y, width_minus_one, height_minus_one)) in enumerate(
        zip(offsets, positions)
    ):
        width_words = width_minus_one + 1
        height = height_minus_one + 1
        end = offsets[index + 1] if index + 1 < len(offsets) else len(gfx)
        pixels = decode_planar(gfx[offset:end], width_words, height)
        blit(canvas, pixels, x_half * 2, y)
    return canvas


def export_sprite_set(
    sprites: Sequence[IndexedSprite],
    output_dir: Path,
    *,
    scale: int,
    transparent_index: int | None = TRANSPARENT_INDEX,
) -> list[dict[str, object]]:
    sprites_dir = output_dir / "sprites"
    templates_dir = output_dir / "templates"
    sprites_dir.mkdir(parents=True, exist_ok=True)
    templates_dir.mkdir(parents=True, exist_ok=True)
    records = []
    for sprite in sprites:
        filename = f"{sprite.name}.png"
        write_indexed_png(
            sprites_dir / filename,
            sprite.pixels,
            scale=scale,
            transparent_index=transparent_index,
        )
        write_indexed_png(
            templates_dir / filename,
            make_guide_template(sprite),
            scale=scale,
            transparent_index=transparent_index,
        )
        records.append(
            {
                "name": sprite.name,
                "source_file": sprite.source_file,
                "byte_offset_in_file": sprite.byte_offset,
                "byte_offset_in_original_combined_block": sprite.source_byte_offset,
                "byte_size": sprite.byte_size,
                "width_pixels": sprite.width,
                "height_pixels": sprite.height,
                "sprite_png": f"sprites/{filename}",
                "guide_template_png": f"templates/{filename}",
                "template_editable_rect": [1, 1, sprite.width, sprite.height],
            }
        )
    return records


def write_json(path: Path, value: object) -> None:
    path.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")


def build_previews(data_root: Path, output_dir: Path, *, scale: int, grade_step: int) -> None:
    gfx_dir = data_root / "gfx"
    monsters_dir = data_root / "monsters"
    output_dir.mkdir(parents=True, exist_ok=True)

    avatars_dir = output_dir / "avatars"
    avatars_dir.mkdir(parents=True, exist_ok=True)
    large = decode_fixed_sprites(
        gfx_dir / "Avatars_Large.gfx",
        width_words=2,
        height=30,
        count=16,
        name_prefix="avatar_large",
    )
    shield = decode_fixed_sprites(
        gfx_dir / "Shield_Avatars.gfx",
        width_words=2,
        height=16,
        count=16,
        name_prefix="avatar_shield",
    )
    large_records = export_sprite_set(
        large, avatars_dir / "large", scale=scale, transparent_index=None
    )
    shield_records = export_sprite_set(
        shield, avatars_dir / "shield", scale=scale, transparent_index=None
    )
    write_indexed_png(
        avatars_dir / "large_sheet.png",
        make_sheet(large, background=0, transparent_index=None),
        scale=scale,
    )
    write_indexed_png(
        avatars_dir / "shield_sheet.png",
        make_sheet(shield, background=0, transparent_index=None),
        scale=scale,
    )
    write_json(
        avatars_dir / "assets.json",
        {
            "format": "bloodwych-fixed-planar-avatar-preview-v1",
            "large": {
                "source": "Avatars_Large.gfx",
                "count": 16,
                "dimensions": [32, 30],
                "bytes_per_sprite": 480,
                "assets": large_records,
            },
            "shield": {
                "source": "Shield_Avatars.gfx",
                "count": 16,
                "dimensions": [32, 16],
                "bytes_per_sprite": 256,
                "assets": shield_records,
            },
        },
    )

    background = load_floor_ceiling_background(gfx_dir)
    write_indexed_png(output_dir / "floor_ceiling_window.png", background, scale=scale)

    beholder_dir = output_dir / "beholder"
    beholder_dir.mkdir(parents=True, exist_ok=True)
    beholder = BeholderAssets(monsters_dir)
    sprite_records = export_sprite_set(
        beholder.all_sprites(), beholder_dir / "components", scale=scale
    )
    facings = ("front", "side", "back", "side_mirrored")
    previews: list[dict[str, object]] = []
    preview_sprites: list[IndexedSprite] = []
    for distance in range(6):
        for facing, facing_name in enumerate(facings):
            pixels, metadata = render_beholder(
                background,
                beholder,
                distance,
                facing,
                grade_step=grade_step,
            )
            filename = f"distance_{distance}_{facing_name}.png"
            write_indexed_png(beholder_dir / filename, pixels, scale=scale)
            metadata["file"] = filename
            previews.append(metadata)
            preview_sprites.append(
                IndexedSprite(
                    f"distance_{distance}_{facing_name}", filename, 0, pixels
                )
            )
    write_indexed_png(
        beholder_dir / "contact_sheet.png",
        make_sheet(preview_sprites, columns=4, gap=2, background=0),
        scale=scale,
    )
    write_json(
        beholder_dir / "assets.json",
        {
            "format": "bloodwych-beholder-composite-preview-v1",
            "game_window_dimensions": [VIEW_WIDTH, VIEW_HEIGHT],
            "transparent_index": TRANSPARENT_INDEX,
            "template_replaced_indices": list(TEMPLATE_COLOUR_INDICES),
            "grade_lookup": beholder.grade_lookup,
            "monster_palettes": beholder.monster_palettes,
            "selected_grade_step": grade_step,
            "components": sprite_records,
            "previews": previews,
        },
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "output_dir",
        type=Path,
        help="directory for generated PNG previews, templates, and JSON metadata",
    )
    parser.add_argument(
        "--data-root",
        type=Path,
        default=DATA_DIR / "BLOODWYCH439-clean",
        help="extracted version data root (default: Bloodwych 4.39 clean data)",
    )
    parser.add_argument("--scale", type=int, default=4, help="nearest-neighbour PNG scale")
    parser.add_argument(
        "--grade-step",
        type=int,
        default=0,
        help="Beholder colour grade step from 0 to 7",
    )
    args = parser.parse_args()
    if args.scale < 1:
        parser.error("scale must be at least 1")
    if not 0 <= args.grade_step <= 7:
        parser.error("grade step must be from 0 to 7")
    build_previews(args.data_root, args.output_dir, scale=args.scale, grade_step=args.grade_step)


if __name__ == "__main__":
    main()

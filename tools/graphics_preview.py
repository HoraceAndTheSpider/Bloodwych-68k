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

# Draw_Monster_CompositeBitmap writes into the whole 320-pixel screen and adds
# Player_Data+$0008 to d5 ($27 for the upper player).  The preview canvas begins
# at the dungeon window itself, whose upper-screen origin is $32, so composite
# pieces need this conversion.  Draw_Monster_16PixelStrip already uses a
# window-relative destination pointer and must not receive the adjustment.
COMPOSITE_BITMAP_VIEWPORT_Y_ADJUSTMENT = 0x27 - 0x32
# Draw_Monster_16PixelStrip starts from the per-view destination pointer held
# at -$0008(a3).  That pointer is one scanline below the 128x76 canvas origin.
PIXEL_STRIP_VIEWPORT_Y_ADJUSTMENT = 1


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


@dataclass(frozen=True)
class CharacterDrawOperation:
    """One independently recoloured strip in a composed character."""

    operation: DrawOperation
    part: str
    replacements: tuple[int, int, int, int]


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
        }
        for name, expected in expected_lengths.items():
            actual = len(getattr(self, name))
            if actual != expected:
                raise ValueError(f"Beholder {name}: expected {expected} entries, got {actual}")
        if not self.grade_lookup:
            raise ValueError("Beholder colour lookup must contain at least one grade")
        if any(index >= len(self.monster_palettes) for index in self.grade_lookup):
            raise ValueError("Beholder colour lookup references a missing monster palette")

    def replacement_palette(self, grade_step: int) -> list[int]:
        if not 0 <= grade_step < len(self.grade_lookup):
            raise ValueError(
                f"Beholder grade step must be from 0 to {len(self.grade_lookup) - 1}"
            )
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
        y = self.composite_y[distance] + PIXEL_STRIP_VIEWPORT_Y_ADJUSTMENT
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


def signed_byte(value: int) -> int:
    return value - 256 if value >= 128 else value


def read_palette_groups(monsters_dir: Path) -> list[list[int]]:
    data = (monsters_dir / "monsters.palette").read_bytes()
    if len(data) % 4:
        raise ValueError("monsters.palette must contain four-byte palettes")
    return [list(data[index : index + 4]) for index in range(0, len(data), 4)]


def graded_palette(
    monsters_dir: Path, colours_file: str, grade_step: int
) -> list[int]:
    lookup = list((monsters_dir / colours_file).read_bytes())
    if not lookup:
        raise ValueError(f"{colours_file} must contain at least one grade entry")
    if not 0 <= grade_step < len(lookup):
        raise ValueError(
            f"monster grade step must be from 0 to {len(lookup) - 1}"
        )
    palettes = read_palette_groups(monsters_dir)
    palette_index = lookup[grade_step]
    if palette_index >= len(palettes):
        raise ValueError(f"{colours_file} references missing palette {palette_index}")
    return palettes[palette_index]


def decode_sprite(
    data: bytes,
    *,
    offset: int,
    width_words: int,
    height: int,
    name: str,
    source_file: str,
) -> IndexedSprite:
    byte_size = width_words * height * 8
    raw = data[offset : offset + byte_size]
    if len(raw) != byte_size:
        raise ValueError(
            f"{name}: expected {byte_size} bytes at {offset:#x}, got {len(raw)}"
        )
    pixels = decode_planar(raw, width_words, height)
    if encode_planar(pixels) != raw:
        raise RuntimeError(f"{name}: codec round trip failed")
    return IndexedSprite(name, source_file, offset, pixels)


def facing_variant(facing: int) -> tuple[int, bool]:
    if not 0 <= facing <= 3:
        raise ValueError("facing must be 0..3")
    value = (0, 1, 2, 0x81)[facing]
    return value & 0x7F, bool(value & 0x80)


CHARACTER_DISTANT_DIMENSIONS = {
    0: {4: (22, 0xB0, 0x000), 5: (17, 0x88, 0x210)},
    1: {4: (21, 0xA8, 0x000), 5: (16, 0x80, 0x1F8)},
}


# Draw_Spell divides the six source view distances into four pictures.  Codes
# $80-$85 use AirbourneFireball.gfx; $86-$8F use the final $2B8-byte picture
# set inside AirbourneSpells.gfx.  The preceding $4E0 bytes in that second file
# belong to the separate stationary-spell renderer.
AIRBOURNE_SPELL_DISTANCE_GROUPS = (0, 0, 1, 1, 2, 3)
AIRBOURNE_FIREBALL_GEOMETRY = (
    (0x000, -7, -8, 2, 26),
    (0x1A0, -4, 0, 1, 16),
    (0x220, 1, 16, 1, 11),
    (0x278, 2, 13, 1, 8),
)
AIRBOURNE_GENERIC_GEOMETRY = (
    (0x000, -7, -8, 2, 27),
    (0x1B0, -2, 1, 1, 15),
    (0x228, 1, 14, 1, 11),
    (0x280, 1, 14, 1, 7),
)
AIRBOURNE_GENERIC_SOURCE_OFFSET = 0x4E0
AIRBOURNE_SPELL_PALETTES = (
    (9, 13, 11, 12),
    (2, 6, 8, 7),
    (2, 13, 6, 5),
    (0, 0, 0, 0),
    (9, 12, 11, 13),
    (9, 13, 11, 12),
    (11, 14, 13, 11),
    (9, 12, 11, 13),
    (9, 10, 10, 11),
    (1, 2, 5, 6),
    (12, 11, 13, 14),
    (7, 8, 6, 13),
    (1, 5, 6, 13),
    (7, 2, 8, 4),
    (10, 11, 13, 13),
    (11, 13, 13, 14),
)


class AirbourneSpellAssets:
    """SPS 439 flying-spell pictures and the source-owned colour masks."""

    def __init__(self, gfx_dir: Path):
        self.fireball = (gfx_dir / "AirbourneFireball.gfx").read_bytes()
        self.generic = (gfx_dir / "AirbourneSpells.gfx").read_bytes()
        if len(self.fireball) != 0x2B8:
            raise ValueError("AirbourneFireball.gfx must be $2B8 bytes")
        if len(self.generic) < AIRBOURNE_GENERIC_SOURCE_OFFSET + 0x2B8:
            raise ValueError("AirbourneSpells.gfx does not contain its flying-spell pictures")

    def draw_operation(self, code: int, distance: int) -> DrawOperation:
        if not 0x80 <= code <= 0x8F:
            raise ValueError("SPS 439 flying-spell code must be $80-$8F")
        if not 0 <= distance < len(AIRBOURNE_SPELL_DISTANCE_GROUPS):
            raise ValueError("flying-spell distance must be 0..5")
        group = AIRBOURNE_SPELL_DISTANCE_GROUPS[distance]
        if code < 0x86:
            data = self.fireball
            source_file = "AirbourneFireball.gfx"
            source_base = 0
            geometry = AIRBOURNE_FIREBALL_GEOMETRY[group]
        else:
            data = self.generic
            source_file = "AirbourneSpells.gfx"
            source_base = AIRBOURNE_GENERIC_SOURCE_OFFSET
            geometry = AIRBOURNE_GENERIC_GEOMETRY[group]
        offset, x, y, width_words, height = geometry
        sprite = decode_sprite(
            data,
            offset=source_base + offset,
            width_words=width_words,
            height=height,
            name=f"AirbourneSpell_{code:02X}_{group}",
            source_file=source_file,
        )
        return DrawOperation(
            sprite,
            x,
            y + COMPOSITE_BITMAP_VIEWPORT_Y_ADJUSTMENT,
        )

    @staticmethod
    def replacement_palette(code: int) -> tuple[int, int, int, int]:
        if not 0x80 <= code <= 0x8F:
            raise ValueError("SPS 439 flying-spell code must be $80-$8F")
        return AIRBOURNE_SPELL_PALETTES[code - 0x80]


def render_airbourne_spell(
    background: Sequence[Sequence[int]],
    assets: AirbourneSpellAssets,
    code: int,
    *,
    distance: int,
    anchor_x: int,
    anchor_y: int,
) -> tuple[list[list[int]], dict[str, object]]:
    """Render one SPS 439 airborne spell at its game view position."""
    operation = assets.draw_operation(code, distance)
    replacements = assets.replacement_palette(code)
    pixels = remap_template_colours(operation.sprite.pixels, replacements)
    x = anchor_x + operation.x
    y = anchor_y + operation.y
    canvas = [list(row) for row in background]
    blit(canvas, pixels, x, y)
    return canvas, {
        "spell_code": code,
        "distance": distance,
        "replacement_palette_indices": list(replacements),
        "requested_game_anchor": [anchor_x, anchor_y],
        "positioning_mode": "game-anchor",
        "operations": ({"sprite": operation.sprite.name, "x": x, "y": y},),
    }


class CharacterAssets:
    """Compose character types $00-$55 from extracted heads and body strips.

    The renderer follows all six source image distances, four facings, the two
    body-layout families, and both independently animated arm variants.
    """

    PARTS = ("legs", "torso", "head", "left_arm", "right_arm")
    COLOUR_GROUPS = (1, 2, 0, 3, 3)

    def __init__(self, data_dir: Path, gfx_dir: Path):
        self.data_dir = data_dir
        self.gfx_dir = gfx_dir
        self.body_selections = list((data_dir / "characters.bodies").read_bytes())
        self.head_selections = list((data_dir / "characters.heads").read_bytes())
        self.colours = (data_dir / "characters.colours").read_bytes()
        body_definitions = (
            data_dir / "characters-body-definitions.layout"
        ).read_bytes()
        self.part_variants = (
            data_dir / "characters-part-variants.lookup"
        ).read_bytes()
        self.arm_animation_positions = (
            data_dir / "characters-arm-animation.positions"
        ).read_bytes()
        render_table_offsets = (
            data_dir / "characters-render-table-offsets.lookup"
        ).read_bytes()
        self.render_layouts = {
            0: (data_dir / "characters-standard-render.layout").read_bytes(),
            1: (data_dir / "characters-alternate-render.layout").read_bytes(),
        }
        self.distant_positions = {
            layout: {
                distance: (
                    data_dir
                    / f"characters-{name}-distant-{distance}.positions"
                ).read_bytes()
                for distance in (4, 5)
            }
            for layout, name in ((0, "standard"), (1, "alternate"))
        }
        self.body_data = (gfx_dir / "BodyParts.gfx").read_bytes()
        self.head_data = (gfx_dir / "HeadParts.gfx").read_bytes()
        if len(self.body_selections) != 0x56 or len(self.head_selections) != 0x56:
            raise ValueError("character head/body selections must contain $56 entries")
        if len(self.colours) != 0x56 * 20:
            raise ValueError("characters.colours must contain five palettes per character")
        if len(self.body_data) < 0x8640 or len(self.body_data) % 8:
            raise ValueError("BodyParts.gfx is shorter than SPS 439 or not strip-aligned")
        if len(self.head_data) < 0x3E70 or len(self.head_data) % 0x378:
            raise ValueError("HeadParts.gfx does not contain complete head definitions")
        body_definition_count, remainder = divmod(len(body_definitions), 10)
        if remainder or not 14 <= body_definition_count <= 16:
            raise ValueError("character body definitions must contain 14 to 16 records")
        words = struct.unpack(f">{len(body_definitions) // 2}H", body_definitions)
        self.body_definitions = tuple(
            tuple(words[index : index + 5]) for index in range(0, len(words), 5)
        )
        if len(self.part_variants) != 20:
            raise ValueError("character part variants must contain twenty entries")
        if len(self.arm_animation_positions) != 72:
            raise ValueError("character arm animation positions must contain $48 bytes")
        if len(render_table_offsets) != 20:
            raise ValueError("character render table offsets must contain ten words")
        table_offsets = struct.unpack(">10H", render_table_offsets)
        self.height_table_offsets = table_offsets[0::2]
        self.source_table_offsets = table_offsets[1::2]
        if any(len(layout) != 0x130 for layout in self.render_layouts.values()):
            raise ValueError("character render layouts must each contain $130 bytes")
        if any(
            len(positions) != 8
            for layouts in self.distant_positions.values()
            for positions in layouts.values()
        ):
            raise ValueError("character distant position tables must contain eight bytes")
        if max(self.body_selections) >= len(self.body_definitions):
            raise ValueError("characters.bodies references an unknown body design")
        if max(self.head_selections) >= len(self.head_data) // 0x378:
            raise ValueError("characters.heads references an unknown head design")

    def body_design(self, character: int) -> int:
        self._validate_character(character)
        return self.body_selections[character]

    def head_design(self, character: int) -> int:
        self._validate_character(character)
        return self.head_selections[character]

    def body_layout(self, character: int) -> int:
        return int(bool(self.body_definitions[self.body_design(character)][0]))

    def palettes(self, character: int) -> tuple[tuple[int, int, int, int], ...]:
        self._validate_character(character)
        start = character * 20
        return tuple(
            tuple(self.colours[start + group * 4 : start + group * 4 + 4])
            for group in range(5)
        )

    def draw_operations(
        self,
        character: int,
        *,
        distance: int = 0,
        facing: int = 0,
        render_flags: int = 0,
    ) -> list[CharacterDrawOperation]:
        body_index = self.body_design(character)
        head_index = self.head_design(character)
        layout_selector, legs_offset, torso_offset, arms_offset, distant_offset = (
            self.body_definitions[body_index]
        )
        alternate = int(bool(layout_selector))
        palettes = self.palettes(character)
        if distance in (4, 5):
            if not 0 <= facing <= 3:
                raise ValueError("character facing must be 0..3")
            height, stride, group_offset = CHARACTER_DISTANT_DIMENSIONS[alternate][
                distance
            ]
            positions_data = self.distant_positions[alternate][distance]
            positions = tuple(
                (
                    signed_byte(positions_data[index]),
                    signed_byte(positions_data[index + 1]),
                )
                for index in range(0, 8, 2)
            )
            source_variant = (0, 1, 2, 1)[facing]
            x, y = positions[facing]
            sprite = decode_sprite(
                self.body_data,
                offset=distant_offset + group_offset + source_variant * stride,
                width_words=1,
                height=height,
                name=f"Character_{character:02X}_distant_{distance}_{facing}",
                source_file="BodyParts.gfx",
            )
            return [
                CharacterDrawOperation(
                    DrawOperation(
                        sprite,
                        x,
                        y + PIXEL_STRIP_VIEWPORT_Y_ADJUSTMENT,
                        mirrored=facing == 3,
                    ),
                    "distant",
                    palettes[4],
                )
            ]
        if not 0 <= distance <= 3 or not 0 <= facing <= 3:
            raise ValueError("character component view must use distance 0..3 and facing 0..3")

        layout = self.render_layouts[alternate]
        position_offset = (distance * 4 + facing) * 10
        positions = tuple(
            (
                signed_byte(layout[position_offset + component * 2]),
                signed_byte(layout[position_offset + component * 2 + 1]),
            )
            for component in range(5)
        )
        source_bases = (
            legs_offset,
            torso_offset,
            head_index * 0x378,
            arms_offset,
            arms_offset,
        )
        source_data = (
            self.body_data,
            self.body_data,
            self.head_data,
            self.body_data,
            self.body_data,
        )
        source_files = (
            "BodyParts.gfx",
            "BodyParts.gfx",
            "HeadParts.gfx",
            "BodyParts.gfx",
            "BodyParts.gfx",
        )
        operations: list[CharacterDrawOperation] = []
        for index, part in enumerate(self.PARTS):
            raw_variant = self.part_variants[index * 4 + facing]
            if raw_variant == 0xFF:
                continue
            mirrored = bool(raw_variant & 0x80)
            variant = raw_variant & 0x7F
            animated = index >= 3 and bool(render_flags & (1 << (index - 3)))
            if animated:
                variant = 2
            table_index = distance * 3 + variant
            height = (
                layout[self.height_table_offsets[index] + table_index]
                + 1
            )
            source_lookup = (
                self.source_table_offsets[index] + table_index * 2
            )
            source_offset = source_bases[index] + int.from_bytes(
                layout[source_lookup : source_lookup + 2], "big"
            )
            sprite = decode_sprite(
                source_data[index],
                offset=source_offset,
                width_words=1,
                height=height,
                name=f"Character_{character:02X}_{part}",
                source_file=source_files[index],
            )
            x, y = positions[index]
            if animated:
                animation_base = alternate * 36
                y -= signed_byte(
                    self.arm_animation_positions[animation_base + distance]
                )
                x += signed_byte(
                    self.arm_animation_positions[
                        animation_base
                        + 4
                        + distance * 8
                        + (index - 3) * 4
                        + facing
                    ]
                )
                if facing & 1:
                    mirrored = not mirrored
            operations.append(
                CharacterDrawOperation(
                    DrawOperation(
                        sprite,
                        x,
                        y + PIXEL_STRIP_VIEWPORT_Y_ADJUSTMENT,
                        mirrored=mirrored,
                    ),
                    part,
                    palettes[self.COLOUR_GROUPS[index]],
                )
            )
        return operations

    @staticmethod
    def _validate_character(character: int) -> None:
        if not 0 <= character <= 0x55:
            raise ValueError("character type must be $00..$55")


def render_character_preview(
    background: Sequence[Sequence[int]],
    assets: CharacterAssets,
    character: int,
    *,
    distance: int = 0,
    facing: int = 0,
    render_flags: int = 0,
    anchor_x: int,
    anchor_y: int,
) -> tuple[list[list[int]], dict[str, object]]:
    """Render one source-exact character view into the game window."""
    canvas = [list(row) for row in background]
    records: list[dict[str, object]] = []
    for component in assets.draw_operations(
        character, distance=distance, facing=facing, render_flags=render_flags
    ):
        operation = component.operation
        pixels = remap_template_colours(operation.sprite.pixels, component.replacements)
        if operation.mirrored:
            pixels = mirror_pixels(pixels)
        x = anchor_x + operation.x
        y = anchor_y + operation.y
        blit(canvas, pixels, x, y)
        records.append(
            {
                "part": component.part,
                "sprite": operation.sprite.name,
                "x": x,
                "y": y,
                "mirrored": operation.mirrored,
                "replacement_palette_indices": list(component.replacements),
            }
        )
    return canvas, {
        "character": character,
        "body_design": assets.body_design(character),
        "body_layout": "alternate" if assets.body_layout(character) else "standard",
        "head_design": assets.head_design(character),
        "palettes": [list(palette) for palette in assets.palettes(character)],
        "requested_game_anchor": [anchor_x, anchor_y],
        "positioning_mode": "game-anchor",
        "view": "component" if distance <= 3 else f"distant-{distance}",
        "distance": distance,
        "facing": facing,
        "render_flags": render_flags,
        "operations": records,
    }


DISTANCE_GROUPS = (0, 0, 1, 1, 2, 3)


class SummonAssets:
    """Summon body and arm strips decoded from the shared packed tables."""

    def __init__(self, monsters_dir: Path):
        self.monsters_dir = monsters_dir
        self.data = (monsters_dir / "Summon.gfx").read_bytes()
        self.body_offsets = read_u16be(monsters_dir / "Summon.offsets")
        self.arm_offsets = read_u16be(monsters_dir / "Summon_Arms.offsets")
        self.body_layout = list((monsters_dir / "Summon_Body.layout").read_bytes())
        self.arm_variants = list(
            (monsters_dir / "Summon_ArmVariants.lookup").read_bytes()
        )
        self.arm_heights = list((monsters_dir / "Summon_Arms.heights").read_bytes())
        self.primary_positions = (monsters_dir / "Summon_PrimaryArm.positions").read_bytes()
        self.secondary_positions = (
            monsters_dir / "Summon_SecondaryArm.positions"
        ).read_bytes()
        if (
            len(self.body_offsets) != 18
            or len(self.arm_offsets) != 12
            or len(self.body_layout) != 12
            or len(self.arm_variants) != 4
            or len(self.arm_heights) != 12
            or len(self.primary_positions) != 32
            or len(self.secondary_positions) != 96
        ):
            raise ValueError("Summon companion tables have unexpected lengths")

    def replacement_palette(self, grade_step: int, *, illusion: bool = False) -> list[int]:
        if illusion:
            palette = list((self.monsters_dir / "illusion.palette").read_bytes())
            if len(palette) != 4:
                raise ValueError("illusion.palette must contain four palette indices")
            return palette
        return graded_palette(self.monsters_dir, "summon.colours", grade_step)

    def draw_operations(
        self, distance: int, facing: int, *, render_flags: int = 0
    ) -> list[DrawOperation]:
        if not 0 <= distance <= 5:
            raise ValueError("Summon distance must be 0..5")
        variant, body_mirrored = facing_variant(facing)
        body_index = distance * 3 + variant
        body_height = self.body_layout[6 + distance] + 1
        body_y = (
            -signed_byte(self.body_layout[distance])
            + PIXEL_STRIP_VIEWPORT_Y_ADJUSTMENT
        )
        operations = [
            DrawOperation(
                decode_sprite(
                    self.data,
                    offset=self.body_offsets[body_index],
                    width_words=1,
                    height=body_height,
                    name=f"Summon_Body_{body_index:02d}",
                    source_file="Summon.gfx",
                ),
                0,
                body_y,
                body_mirrored,
            )
        ]
        if distance == 0 and facing % 2 == 0:
            operations.append(
                DrawOperation(operations[0].sprite, 3, body_y, not body_mirrored)
            )

        if distance >= 4:
            return operations
        # Draw_Summon advances d4 by three after drawing the body and before
        # either arm-position table is applied.  The adjustment is retained at
        # every distance, even when the nearest body is not drawn twice.
        arm_anchor_x = 3
        position_entry = (distance * 4 + facing) * 2
        normal_variant = self.arm_variants[facing] & 0x7F
        reverse_sides = bool(self.arm_variants[facing] & 0x80)
        combined_positions = self.primary_positions + self.secondary_positions
        for limb in range(2):
            arm_variant = 2 if render_flags & (1 << limb) else normal_variant
            arm_index = distance * 3 + arm_variant
            sprite = decode_sprite(
                self.data,
                offset=self.arm_offsets[arm_index],
                width_words=1,
                height=self.arm_heights[arm_index] + 1,
                name=f"Summon_Arm_{arm_index:02d}",
                source_file="Summon.gfx",
            )
            mirrored = bool(limb)
            if reverse_sides:
                mirrored = not mirrored
            if limb == 0:
                positions = combined_positions
            else:
                positions = self.secondary_positions
            positions_offset = position_entry + (64 if arm_variant == 2 else 0)
            x_raw, y_raw = positions[positions_offset : positions_offset + 2]
            if x_raw == 0xFF and y_raw == 0xFF:
                continue
            operations.append(
                DrawOperation(
                    sprite,
                    arm_anchor_x - signed_byte(x_raw),
                    body_y - signed_byte(y_raw),
                    mirrored,
                )
            )
        return operations


class LargeMonsterAssets:
    """Shared data-driven Behemoth and Entropy composite renderer."""

    def __init__(self, monsters_dir: Path, stem: str):
        if stem not in {"Behemoth", "Entropy"}:
            raise ValueError("large monster stem must be Behemoth or Entropy")
        self.monsters_dir = monsters_dir
        self.stem = stem
        self.data = (monsters_dir / f"{stem}.gfx").read_bytes()
        self.layout = list((monsters_dir / f"{stem}.layout").read_bytes())
        all_offsets = read_u16be(monsters_dir / f"{stem}.offsets")
        self.body_offsets = all_offsets[:12]
        self.limb_offsets = (
            read_u16be(monsters_dir / "Behemoth_Claws.offsets")
            if stem == "Behemoth"
            else all_offsets[12:]
        )
        flags = (monsters_dir / f"{stem}_LimbMirroring.flags").read_bytes()
        if len(self.layout) != 62 or len(self.body_offsets) != 12 or len(self.limb_offsets) != 4:
            raise ValueError(f"{stem} companion tables have unexpected lengths")
        if len(flags) != 2:
            raise ValueError(f"{stem}_LimbMirroring.flags must contain one word")
        self.reverse_limb_mirroring = bool(int.from_bytes(flags, "big"))

    def replacement_palette(self, grade_step: int) -> list[int]:
        if self.stem == "Entropy":
            return [0, 4, 8, 12]
        return graded_palette(self.monsters_dir, "behemoth.colours", grade_step)

    def draw_operations(
        self, distance: int, facing: int, *, render_flags: int = 0
    ) -> list[DrawOperation]:
        if not 0 <= distance <= 5:
            raise ValueError(f"{self.stem} distance must be 0..5")
        group = DISTANCE_GROUPS[distance]
        variant, body_mirrored = facing_variant(facing)
        body_index = group * 3 + variant
        body_x = signed_byte(self.layout[0x16 + group])
        source_y = -signed_byte(self.layout[group])
        strip_y = source_y + PIXEL_STRIP_VIEWPORT_Y_ADJUSTMENT
        body_y = source_y + COMPOSITE_BITMAP_VIEWPORT_Y_ADJUSTMENT
        if facing & 1:
            side_index = group * 2 + (facing >> 1)
            body_x += signed_byte(self.layout[0x1A + side_index])
        body = decode_sprite(
            self.data,
            offset=self.body_offsets[body_index],
            width_words=self.layout[0x0A + body_index] + 1,
            height=self.layout[0x06 + group] + 1,
            name=f"{self.stem}_Body_{body_index:02d}",
            source_file=f"{self.stem}.gfx",
        )
        operations = [DrawOperation(body, body_x, body_y, body_mirrored)]
        if facing % 2 == 0:
            operations.append(
                DrawOperation(
                    body,
                    body_x + signed_byte(self.layout[0x22 + group]),
                    body_y,
                    True,
                )
            )

        if group >= 2:
            return operations
        limb_count = 1 if facing & 1 else 2
        for limb in range(limb_count):
            animated = bool(render_flags & (1 << limb))
            limb_index = group * 2 + int(animated)
            mirrored = bool(limb)
            if animated and self.reverse_limb_mirroring:
                mirrored = not mirrored
            if facing < 2:
                mirrored = not mirrored
            position_index = limb_index * 4 + (2 if facing & 1 else 0) + int(mirrored)
            sprite = decode_sprite(
                self.data,
                offset=self.limb_offsets[limb_index],
                width_words=1,
                height=self.layout[0x2A + limb_index] + 1,
                name=f"{self.stem}_Limb_{limb_index:02d}",
                source_file=f"{self.stem}.gfx",
            )
            operations.append(
                DrawOperation(
                    sprite,
                    body_x + signed_byte(self.layout[0x2E + position_index]),
                    strip_y + signed_byte(self.layout[0x26 + limb_index]),
                    mirrored,
                )
            )
        return operations


class DragonAssets:
    """Large and small Dragon bodies and claws from their packed layout tables."""

    def __init__(self, monsters_dir: Path):
        self.monsters_dir = monsters_dir
        self.data = (monsters_dir / "Dragon.gfx").read_bytes()
        self.offsets = read_u16be(monsters_dir / "Dragon.offsets")
        self.body = list((monsters_dir / "Dragon_Body.layout").read_bytes())
        self.claws = list((monsters_dir / "Dragon_Claws.layout").read_bytes())
        self.composite_xy = list(
            (monsters_dir / "Dragon_Composite_XY.positions").read_bytes()
        )
        self.side_x = list((monsters_dir / "Dragon_Side_X.positions").read_bytes())
        self.mirrored_half_x = list(
            (monsters_dir / "Dragon_MirroredHalf_X.positions").read_bytes()
        )
        if (
            len(self.offsets) != 27
            or len(self.body) != 34
            or len(self.claws) != 60
            or len(self.composite_xy) != 16
            or len(self.side_x) != 10
            or len(self.mirrored_half_x) != 6
        ):
            raise ValueError("Dragon companion tables have unexpected lengths")

    def replacement_palette(self, grade_step: int) -> list[int]:
        return graded_palette(self.monsters_dir, "dragon.colours", grade_step)

    def draw_operations(
        self,
        distance: int,
        facing: int,
        *,
        small: bool,
        render_flags: int = 0,
    ) -> list[DrawOperation]:
        if not 0 <= distance <= 5:
            raise ValueError("Dragon distance must be 0..5")
        group = DISTANCE_GROUPS[distance]
        # Draw_LittleDragon uses its own position table at the current distance,
        # then increments d1 before selecting the shared Dragon body/claw data.
        # Thus a closest small Dragon uses the same image size as a large Dragon
        # in the next stored distance group.
        graphics_group = group + int(small)
        base = 0 if small else 8
        body_x = signed_byte(self.composite_xy[base + group])
        body_y = (
            signed_byte(self.composite_xy[base + 4 + group])
            + COMPOSITE_BITMAP_VIEWPORT_Y_ADJUSTMENT
        )
        if facing & 1:
            body_x += signed_byte(
                self.side_x[graphics_group * 2 + (facing >> 1)]
            )
        variant, body_mirrored = facing_variant(facing)
        body_index = graphics_group * 3 + variant
        body = decode_sprite(
            self.data,
            offset=self.offsets[body_index],
            width_words=self.body[body_index] + 1,
            height=self.body[19 + body_index] + 1,
            name=f"Dragon_Body_{body_index:02d}",
            source_file="Dragon.gfx",
        )
        operations = [DrawOperation(body, body_x, body_y, body_mirrored)]
        if facing % 2 == 0:
            operations.append(
                DrawOperation(
                    body,
                    body_x + signed_byte(self.mirrored_half_x[graphics_group]),
                    body_y,
                    True,
                )
            )

        if facing == 2 or graphics_group >= 3:
            return operations
        limb_count = 1 if facing & 1 else 2
        for limb in range(limb_count):
            claw_index = graphics_group * 4 + (2 if facing else 0)
            if render_flags & (1 << limb):
                claw_index += 1
            mirrored = bool(limb)
            if facing == 1:
                mirrored = not mirrored
            sprite = decode_sprite(
                self.data,
                offset=self.offsets[15 + claw_index],
                width_words=self.claws[claw_index] + 1,
                height=self.claws[12 + claw_index] + 1,
                name=f"Dragon_Claw_{claw_index:02d}",
                source_file="Dragon.gfx",
            )
            x_index = 36 + claw_index * 2 + int(mirrored)
            operations.append(
                DrawOperation(
                    sprite,
                    body_x + signed_byte(self.claws[x_index]),
                    body_y + signed_byte(self.claws[24 + claw_index]),
                    mirrored,
                )
            )
        return operations


class CrabAssets:
    """Crab body, face, side and claw strips from the split graphics block."""

    def __init__(self, monsters_dir: Path):
        self.monsters_dir = monsters_dir
        self.crab_size = (monsters_dir / "Crab.gfx").stat().st_size
        self.data = (monsters_dir / "Crab.gfx").read_bytes() + (
            monsters_dir / "CrabClaw.gfx"
        ).read_bytes()
        self.offsets = read_u16be(monsters_dir / "Crab.offsets")
        self.body = list((monsters_dir / "Crab_Body.layout").read_bytes())
        self.front = list((monsters_dir / "Crab_Front.layout").read_bytes())
        self.side_near = list((monsters_dir / "Crab_SideNear.layout").read_bytes())
        self.side_far = list((monsters_dir / "Crab_SideFar.layout").read_bytes())
        self.face = list((monsters_dir / "Crab_FaceAndSideClaw.layout").read_bytes())
        self.back = list((monsters_dir / "Crab_BackClaw.layout").read_bytes())
        self.behemoth_data = (monsters_dir / "Behemoth.gfx").read_bytes()
        self.behemoth_claws = read_u16be(monsters_dir / "Behemoth_Claws.offsets")
        if (
            len(self.offsets) != 17
            or len(self.body) != 20
            or len(self.front) != 18
            or len(self.side_near) != 16
            or len(self.side_far) != 8
            or len(self.face) != 6
            or len(self.back) != 8
            or len(self.behemoth_claws) != 4
        ):
            raise ValueError("Crab companion tables have unexpected lengths")

    def replacement_palette(self, grade_step: int) -> list[int]:
        return graded_palette(self.monsters_dir, "crab.colours", grade_step)

    def strip(self, offset_index: int, height_minus_one: int, name: str) -> IndexedSprite:
        return decode_sprite(
            self.data,
            offset=self.offsets[offset_index],
            width_words=1,
            height=height_minus_one + 1,
            name=name,
            source_file="Crab.gfx+CrabClaw.gfx",
        )

    def draw_operations(
        self, distance: int, facing: int, *, render_flags: int = 0
    ) -> list[DrawOperation]:
        if not 0 <= distance <= 5:
            raise ValueError("Crab distance must be 0..5")
        group = DISTANCE_GROUPS[distance]
        source_y = signed_byte(self.body[8 + group])
        strip_y = source_y + PIXEL_STRIP_VIEWPORT_Y_ADJUSTMENT
        body_y = source_y + COMPOSITE_BITMAP_VIEWPORT_Y_ADJUSTMENT
        body = decode_sprite(
            self.data,
            offset=self.offsets[group],
            width_words=self.body[12 + group] + 1,
            height=self.body[16 + group] + 1,
            name=f"Crab_Body_{group:02d}",
            source_file="Crab.gfx+CrabClaw.gfx",
        )
        operations = [
            DrawOperation(body, signed_byte(self.body[group * 2]), body_y),
            DrawOperation(body, signed_byte(self.body[group * 2 + 1]), body_y, True),
        ]

        if group < 2:
            if facing == 0:
                operations.append(
                    DrawOperation(
                        self.strip(4 + group, self.face[group], f"Crab_Face_{group}"),
                        0,
                        strip_y + signed_byte(self.face[2 + group]),
                    )
                )
            elif facing & 1 and group == 0:
                right_side = facing == 3
                mirrored = not right_side
                operations.append(
                    DrawOperation(
                        decode_sprite(
                            self.data,
                            offset=self.crab_size,
                            width_words=1,
                            height=8,
                            name="Crab_SideClaw",
                            source_file="CrabClaw.gfx",
                        ),
                        signed_byte(self.face[4 + int(right_side)]),
                        strip_y - 3,
                        mirrored,
                    )
                )
            elif facing == 2 and render_flags:
                sprite = self.strip(7 + group, self.back[6 + group], f"Crab_BackClaw_{group}")
                for limb in range(2):
                    if render_flags & (1 << limb):
                        operations.append(
                            DrawOperation(
                                sprite,
                                signed_byte(self.back[group * 2 + limb]),
                                strip_y + signed_byte(self.back[4 + group]),
                                not bool(limb),
                            )
                        )

        if facing == 2:
            return operations
        if facing == 0:
            if group < 2:
                for limb in range(2):
                    animated = bool(render_flags & (1 << limb))
                    claw_index = group * 2 + int(animated)
                    x_position_index = group * 2 + limb
                    y_position_index = group * 2 + int(animated)
                    sprite = decode_sprite(
                        self.behemoth_data,
                        offset=self.behemoth_claws[claw_index],
                        width_words=1,
                        height=self.front[16 + group] + 1,
                        name=f"Crab_BehemothClaw_{claw_index}",
                        source_file="Behemoth.gfx",
                    )
                    operations.append(
                        DrawOperation(
                            sprite,
                            signed_byte(self.front[12 + x_position_index]),
                            strip_y + signed_byte(self.front[8 + y_position_index]),
                            bool(limb),
                        )
                    )
            else:
                local = group - 2
                sprite = self.strip(9 + local, self.front[6 + local], f"Crab_Front_{local}")
                y = strip_y + signed_byte(self.front[local])
                operations.extend(
                    (
                        DrawOperation(sprite, signed_byte(self.front[2 + local * 2]), y),
                        DrawOperation(sprite, signed_byte(self.front[3 + local * 2]), y, True),
                    )
                )
            return operations

        right_side = facing == 3
        mirrored = not right_side
        if group < 2:
            animation_bit = 0 if right_side else 1
            animated = bool(render_flags & (1 << animation_bit))
            sprite_index = group * 2 + int(animated)
            x_index = 4 + group * 4 + int(right_side) * 2 + int(animated)
            operations.append(
                DrawOperation(
                    self.strip(
                        11 + sprite_index,
                        self.side_near[sprite_index],
                        f"Crab_SideNear_{sprite_index}",
                    ),
                    signed_byte(self.side_near[x_index]),
                    strip_y + signed_byte(self.side_near[12 + sprite_index]),
                    mirrored,
                )
            )
        else:
            local = group - 2
            operations.append(
                DrawOperation(
                    self.strip(15 + local, self.side_far[local], f"Crab_SideFar_{local}"),
                    signed_byte(self.side_far[2 + local * 2 + int(right_side)]),
                    strip_y + signed_byte(self.side_far[6 + local]),
                    mirrored,
                )
            )
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


def render_monster_operations(
    background: Sequence[Sequence[int]],
    operations: Sequence[DrawOperation],
    replacements: Sequence[int],
    *,
    monster: str,
    distance: int,
    facing: int,
    grade_step: int,
    render_flags: int,
    anchor_x: int,
    anchor_y: int,
) -> tuple[list[list[int]], dict[str, object]]:
    canvas = [list(row) for row in background]
    records = []
    for operation in operations:
        pixels = remap_template_colours(operation.sprite.pixels, replacements)
        if operation.mirrored:
            pixels = mirror_pixels(pixels)
        x = anchor_x + operation.x
        y = anchor_y + operation.y
        blit(canvas, pixels, x, y)
        records.append(
            {
                "sprite": operation.sprite.name,
                "x": x,
                "y": y,
                "mirrored": operation.mirrored,
            }
        )
    return canvas, {
        "monster": monster,
        "distance": distance,
        "facing": facing,
        "grade_step": grade_step,
        "render_flags": render_flags,
        "replacement_palette_indices": list(replacements),
        "requested_game_anchor": [anchor_x, anchor_y],
        "positioning_mode": "game-anchor",
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
        help="extracted SPS 439 data root (default: Bloodwych SPS 439 clean data)",
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

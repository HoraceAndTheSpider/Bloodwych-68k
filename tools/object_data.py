#!/usr/bin/env python3
"""Decode Bloodwych SPS 439 object definitions and display graphics."""

from __future__ import annotations

import struct
from dataclasses import dataclass
from pathlib import Path

from tools.champion_data import PocketsAssets
from tools.gamefont_converter import read_font
from tools.graphics_preview import (
    IndexedSprite,
    blit,
    decode_planar,
    load_floor_ceiling_background,
    remap_template_colours,
)


OBJECT_COUNT = 0x6E
OBJECT_DEFINITION_SIZE = 4
OBJECT_FLOOR_SHAPE_COUNT = 0x1B
OBJECT_FLOOR_VIEWS_PER_SHAPE = 5
OBJECT_WIDE_SHAPE_FIRST = 0x12
OBJECT_WIDE_GFX_OFFSET = 0x0CB8
OBJECT_FLOOR_WIDTH_WORDS = (2, 2, 2, 1, 1)

# Object-on-floor projection data used by adrCd0096BE.  The viewer reads the
# extracted forms when available; these SPS 439 values keep it usable until
# the newly identified source tables have been added to segments.xlsx and
# extracted.  X indexes select one valid left-hand placement for each of the
# five projected views.  The object-only preview removes the ceiling and uses
# the furthest source floor anchor ($38) as row zero, preserving the source
# spacing while keeping every projected graphic visible on the floor crop.
OBJECT_FLOOR_LEFT_X_INDEXES = (72, 70, 68, 64, 60)
OBJECT_FLOOR_LEFT_X_FALLBACK = (0x16, 0x1C, 0x22, 0x29, 0x2F)
OBJECT_FLOOR_VIEW_Y_FALLBACK = (0x4F, 0x47, 0x41, 0x3D, 0x38)
OBJECT_FLOOR_PREVIEW_Y_ORIGIN = 0x38
OBJECT_FLOOR_PREVIEW_Y_ADJUSTMENT = 2
OBJECT_FLOOR_BACKGROUND_TOP = 42
OBJECT_FLOOR_Y_ADJUSTMENTS_FALLBACK = bytes.fromhex(
    "00 00 00 00 01 03 02 02 01 01 04 03 03 02 01 01 00 01 01 01 "
    "03 02 03 02 01 03 02 02 01 01 00 00 00 00 00 03 02 02 01 01 "
    "05 03 03 02 01 00 00 00 00 01 01 00 01 01 01 00 00 00 00 01 "
    "03 03 03 02 00 03 02 02 01 01 01 01 01 01 01 03 02 02 02 01 "
    "01 01 01 01 01 02 02 01 01 01 03 01 02 00 01 03 01 02 00 01 "
    "01 00 01 00 01 04 02 02 01 01 05 03 03 02 01 05 03 03 02 01 "
    "04 02 02 01 01 00 00 00 00 00 02 02 02 00 01 00"
)

@dataclass(frozen=True)
class ObjectGroup:
    """One ordered object family whose range follows from preceding sizes."""

    key: str
    label: str
    count: int
    first: int

    @property
    def last(self) -> int:
        return self.first + self.count - 1

    @property
    def end_exclusive(self) -> int:
        return self.first + self.count


def _build_object_groups(
    definitions: tuple[tuple[str, str, int], ...],
) -> tuple[ObjectGroup, ...]:
    groups: list[ObjectGroup] = []
    first = 0
    for key, label, count in definitions:
        groups.append(ObjectGroup(key, label, count, first))
        first += count
    if first != OBJECT_COUNT:
        raise ValueError(
            f"object group definitions cover ${first:02X} entries, expected ${OBJECT_COUNT:02X}"
        )
    return tuple(groups)


# This ordered, count-based definition is deliberately the viewer's single
# source of truth.  Increasing a group's count moves every subsequent range,
# which mirrors how future source-rebuild EQUs will need to behave.
OBJECT_GROUPS = _build_object_groups(
    (
        ("empty", "Empty slot", 1),
        ("coinage", "Coinage", 1),
        ("common_keys", "Common keys", 1),
        ("arrows", "Arrows", 2),
        ("food", "Food and drink", 0x12),
        ("potions", "Potions", 4),
        ("armour", "Body armour", 9),
        ("small_shields", "Small shields", 3),
        ("large_shields", "Large shields", 4),
        ("gloves", "Gloves", 5),
        ("blades", "Blades", 2),
        ("swords", "Swords", 6),
        ("axes", "Axes", 5),
        ("staffs", "Staffs", 3),
        ("remains", "Champion remains (RIP)", 0x10),
        ("keys", "Named keys", 7),
        ("wands", "Wands", 5),
        ("bows", "Bows", 3),
        ("permit", "Permit", 1),
        ("crystals", "Crystals", 4),
        ("gems", "Gems", 4),
        ("rings", "Rings", 5),
        ("book_of_skulls", "Book of Skulls", 1),
    )
)
OBJECT_GROUP_BY_KEY = {group.key: group for group in OBJECT_GROUPS}

# These behavioural boundaries are derived from the ordered group model rather
# than repeated literals.  If food gains an extra entry during a source rebuild,
# potions and every later group move together.
COUNTED_OBJECT_END = OBJECT_GROUP_BY_KEY["food"].first
COUNTED_OBJECT_BELOW_FIRST = OBJECT_GROUP_BY_KEY["arrows"].first
EDIBLE_OBJECT_START = OBJECT_GROUP_BY_KEY["food"].first
EDIBLE_OBJECT_END = OBJECT_GROUP_BY_KEY["food"].end_exclusive
PORTIONED_FOOD_END = OBJECT_GROUP_BY_KEY["potions"].first - 3
WHOLE_FOOD_START = PORTIONED_FOOD_END
WHOLE_FOOD_END = OBJECT_GROUP_BY_KEY["potions"].first
POTION_START = WHOLE_FOOD_END
POTION_END = OBJECT_GROUP_BY_KEY["armour"].first
PORTIONED_FOOD_GROUP_SIZE = 3
SOLID_FOOD_VALUE = 0x20
DRINK_FOOD_VALUE = 0x14
WHOLE_FOOD_VALUE_STEP = 0x42
FOOD_LEVEL_MAXIMUM = 0xC7

POTION_EFFECTS = {
    0x17: "Restores hit points to maximum",
    0x18: "Restores half of each HP, vitality and spell-point deficit; clears spell cooldown",
    0x19: "Restores vitality to maximum",
    0x1A: "Restores spell points to maximum; clears spell cooldown",
}


def _read_words(path: Path) -> tuple[int, ...]:
    raw = path.read_bytes()
    if len(raw) % 2:
        raise ValueError(f"{path.name}: expected word-aligned data")
    return struct.unpack(f">{len(raw) // 2}H", raw)


def _read_length_prefixed_words(path: Path) -> tuple[str, ...]:
    raw = path.read_bytes()
    words: list[str] = []
    cursor = 0
    while cursor < len(raw):
        length = raw[cursor]
        cursor += 1
        if cursor + length > len(raw):
            raise ValueError(f"{path.name}: truncated word at byte {cursor - 1}")
        words.append(raw[cursor : cursor + length].decode("latin-1"))
        cursor += length
    return tuple(words)


@dataclass(frozen=True)
class ObjectDefinition:
    code: int
    pocket_icon: int
    pocket_colour: int
    first_name_index: int
    second_name_index: int
    floor_shape: int
    floor_colour_set: int
    words: tuple[str, ...]

    @property
    def name(self) -> str:
        indexes = (self.first_name_index, self.second_name_index)
        return " ".join(
            self.words[index]
            for index in indexes
            if index != 0xFF and index < len(self.words)
        )

    @property
    def group(self) -> str:
        return next(
            group.label
            for group in OBJECT_GROUPS
            if group.first <= self.code <= group.last
        )

    @property
    def group_definition(self) -> ObjectGroup:
        return next(
            group
            for group in OBJECT_GROUPS
            if group.first <= self.code <= group.last
        )

    def resolved_word(self, index: int) -> str:
        """Resolve an object-text index while preserving the $FF sentinel."""

        if index == 0xFF:
            return "NONE"
        if index >= len(self.words):
            return "INVALID"
        return self.words[index]

    @property
    def displays_quantity(self) -> bool:
        return 0 < self.code < COUNTED_OBJECT_END

    @property
    def quantity_position(self) -> str | None:
        """Return the source-defined pocket count placement for this object.

        NumberedObject uses the first text position for coinage/common keys,
        then adds $118 to the screen pointer for the two arrow objects.
        """

        if not self.displays_quantity:
            return None
        if self.code < COUNTED_OBJECT_BELOW_FIRST:
            return "above"
        return "below"

    @property
    def quantity_cell_y(self) -> int | None:
        """Return the exact source Y coordinate within the 16x16 pocket cell.

        NumberedObject adds $50 for coinage/common keys and another $118 for
        arrows.  BW_xy_to_offset maps coordinates as ``(320*y + x) / 8``, so
        those destinations are respectively (0, 2) and (0, 9).
        """

        position = self.quantity_position
        if position is None:
            return None
        return 2 if position == "above" else 9

    @property
    def edible(self) -> bool:
        return EDIBLE_OBJECT_START <= self.code < EDIBLE_OBJECT_END

    @property
    def use_kind(self) -> str | None:
        if EDIBLE_OBJECT_START <= self.code < PORTIONED_FOOD_END:
            return "portioned_food"
        if WHOLE_FOOD_START <= self.code < WHOLE_FOOD_END:
            return "whole_food"
        if POTION_START <= self.code < POTION_END:
            return "potion"
        return None

    @property
    def object_after_use(self) -> int | None:
        """Return the held object code after one complete use action."""

        if self.use_kind == "portioned_food":
            group_offset = self.code - EDIBLE_OBJECT_START
            if group_offset % PORTIONED_FOOD_GROUP_SIZE == 0:
                return 0
            return self.code - 1
        if self.use_kind in {"whole_food", "potion"}:
            return 0
        return None

    @property
    def food_value_gain(self) -> int | None:
        if self.use_kind == "portioned_food":
            if self.code < OBJECT_GROUP_BY_KEY["food"].first + 9:
                return SOLID_FOOD_VALUE
            return DRINK_FOOD_VALUE
        if self.use_kind == "whole_food":
            return (self.code - WHOLE_FOOD_START + 1) * WHOLE_FOOD_VALUE_STEP
        return None

    @property
    def use_effect(self) -> str | None:
        if self.use_kind == "portioned_food":
            assert self.food_value_gain is not None
            return f"Three-stage food: adds ${self.food_value_gain:02X} food"
        if self.use_kind == "whole_food":
            assert self.food_value_gain is not None
            return f"Whole food: adds ${self.food_value_gain:02X} food"
        return POTION_EFFECTS.get(self.code)


class ObjectAssets:
    """Expose the definition, pocket and floor representations of every object."""

    REQUIRED_FILES = (
        "data/objectdefinitions.block",
        "data/objecttext.block",
        "data/objectflooricons.block",
        "data/objectfloor.colours",
        "data/objectfloor.palette",
        "gfx/Pockets.gfx",
        "gfx/ObjectsOnFloor.gfx",
        "gfx/ObjectsOnFloor.offsets",
        "gfx/ObjectsOnFloor.heights",
        "gfx/FloorCeiling.gfx",
        "gfx/GameFont",
    )

    def __init__(self, data_root: Path):
        self.data_root = data_root
        data_dir = data_root / "data"
        gfx_dir = data_root / "gfx"
        self.pockets = PocketsAssets(gfx_dir / "Pockets.gfx")
        self.words = _read_length_prefixed_words(data_dir / "objecttext.block")

        raw_definitions = (data_dir / "objectdefinitions.block").read_bytes()
        expected = OBJECT_COUNT * OBJECT_DEFINITION_SIZE
        if len(raw_definitions) != expected:
            raise ValueError(
                f"object definitions: expected {expected} bytes, got {len(raw_definitions)}"
            )

        floor_shapes = (data_dir / "objectflooricons.block").read_bytes()
        floor_colours = (data_dir / "objectfloor.colours").read_bytes()
        if len(floor_shapes) != OBJECT_COUNT or len(floor_colours) != OBJECT_COUNT:
            raise ValueError("floor object tables must contain $6E entries")

        self.definitions = tuple(
            ObjectDefinition(
                code=code,
                pocket_icon=raw_definitions[code * 4],
                pocket_colour=raw_definitions[code * 4 + 1],
                first_name_index=raw_definitions[code * 4 + 2],
                second_name_index=raw_definitions[code * 4 + 3],
                floor_shape=floor_shapes[code],
                floor_colour_set=floor_colours[code],
                words=self.words,
            )
            for code in range(OBJECT_COUNT)
        )

        palette_data = (data_dir / "objectfloor.palette").read_bytes()
        if len(palette_data) % 4:
            raise ValueError("floor object palette table must contain four-byte masks")
        self.floor_palettes = tuple(
            tuple(palette_data[index : index + 4])
            for index in range(0, len(palette_data), 4)
        )
        self.floor_offsets = _read_words(gfx_dir / "ObjectsOnFloor.offsets")
        self.floor_heights = (gfx_dir / "ObjectsOnFloor.heights").read_bytes()
        expected_views = OBJECT_FLOOR_SHAPE_COUNT * OBJECT_FLOOR_VIEWS_PER_SHAPE
        if len(self.floor_offsets) != expected_views:
            raise ValueError(
                f"ObjectsOnFloor.offsets: expected {expected_views} words"
            )
        if len(self.floor_heights) < expected_views:
            raise ValueError(
                f"ObjectsOnFloor.heights: expected at least {expected_views} bytes"
            )
        self.floor_gfx = (gfx_dir / "ObjectsOnFloor.gfx").read_bytes()
        self.floor_background = load_floor_ceiling_background(gfx_dir)
        self.game_font = read_font(gfx_dir / "GameFont")

        gfx_data_dir = data_root / "gfx-data"
        # The workbook owns one contiguous block, adrB_009682..0096BE.
        # Interior tables are views of that block, not separately editable files.
        projection_path = gfx_data_dir / "ObjectsOnFloor_Projection.layout"
        projection = projection_path.read_bytes() if projection_path.exists() else None
        if projection is not None and len(projection) != 60:
            raise ValueError(f"{projection_path.name}: expected 60 bytes, got {len(projection)}")

        def projection_table(filename: str, start: int, end: int, fallback: bytes = b"") -> bytes:
            if projection is not None:
                return projection[start:end]
            # Compatibility with extractions made before the grouped resource.
            return self._optional_source_table(gfx_data_dir / filename, fallback, end - start)

        self.floor_view_y = projection_table(
            "ObjectsOnFloor_ViewY.positions", 47, 52,
            bytes(OBJECT_FLOOR_VIEW_Y_FALLBACK),
        )
        floor_x_positions = self._optional_source_table(
            gfx_data_dir / "ObjectsOnFloor_XPositions.positions",
            b"",
            76,
            required=False,
        )
        self.floor_x_positions = floor_x_positions
        if floor_x_positions:
            self.floor_left_x = tuple(
                floor_x_positions[index] for index in OBJECT_FLOOR_LEFT_X_INDEXES
            )
        else:
            self.floor_left_x = OBJECT_FLOOR_LEFT_X_FALLBACK
        self.floor_y_adjustments = self._optional_source_table(
            gfx_data_dir / "ObjectsOnFloor_YAdjustments.positions",
            OBJECT_FLOOR_Y_ADJUSTMENTS_FALLBACK,
            OBJECT_FLOOR_SHAPE_COUNT * OBJECT_FLOOR_VIEWS_PER_SHAPE,
        )
        self.floor_subposition_rotation = projection_table(
            "ObjectsOnFloor_SubpositionRotation.lookup", 0, 16,
        )
        self.floor_subposition_depth_bias = projection_table(
            "ObjectsOnFloor_SubpositionDepthBias.lookup", 16, 20,
        )
        self.floor_view_cell_depth_base = projection_table(
            "ObjectsOnFloor_ViewCellDepthBase.lookup", 20, 39,
        )
        self.floor_projection_groups = projection_table(
            "ObjectsOnFloor_ProjectionGroups.lookup", 39, 47,
        )
        self.floor_special_x_positions = self._optional_source_table(
            gfx_data_dir / "ObjectsOnFloor_SpecialXPositions.positions",
            b"",
            20,
        )
        self.floor_special_y_adjustments = projection_table(
            "ObjectsOnFloor_SpecialYAdjustments.positions", 52, 60,
        )

    @staticmethod
    def _optional_source_table(
        path: Path,
        fallback: bytes,
        minimum_size: int,
        *,
        required: bool = True,
    ) -> bytes:
        raw = path.read_bytes() if path.exists() else fallback
        if len(raw) < minimum_size:
            if not required and not raw:
                return b""
            raise ValueError(
                f"{path.name}: expected at least {minimum_size} bytes, got {len(raw)}"
            )
        return raw

    def definition(self, code: int) -> ObjectDefinition:
        if not 0 <= code < OBJECT_COUNT:
            raise ValueError("object code must be $00-$6D")
        return self.definitions[code]

    def pocket_sprite(self, code: int) -> IndexedSprite:
        definition = self.definition(code)
        source = self.pockets.icon(definition.pocket_icon)
        colour = definition.pocket_colour & 0x0F
        pixels = [
            [colour if pixel == 0x0F else pixel for pixel in row]
            for row in source.pixels
        ]
        return IndexedSprite(
            f"object_{code:02X}_pocket",
            source.source_file,
            source.byte_offset,
            pixels,
        )

    def floor_sprite(self, code: int, view: int = 0) -> IndexedSprite | None:
        definition = self.definition(code)
        shape = definition.floor_shape
        if shape == 0xFF:
            return None
        if not 0 <= shape < OBJECT_FLOOR_SHAPE_COUNT:
            raise ValueError(f"object ${code:02X}: invalid floor shape ${shape:02X}")
        if not 0 <= view < OBJECT_FLOOR_VIEWS_PER_SHAPE:
            raise ValueError("floor object view must be 0..4")

        table_index = shape * OBJECT_FLOOR_VIEWS_PER_SHAPE + view
        offset = self.floor_offsets[table_index]
        if shape >= OBJECT_WIDE_SHAPE_FIRST:
            offset += OBJECT_WIDE_GFX_OFFSET
        width_words = (
            OBJECT_FLOOR_WIDTH_WORDS[view]
            if shape >= OBJECT_WIDE_SHAPE_FIRST
            else 1
        )
        height = self.floor_heights[table_index] + 1
        byte_size = width_words * height * 8
        raw = self.floor_gfx[offset : offset + byte_size]
        if len(raw) != byte_size:
            raise ValueError(f"object ${code:02X}: truncated floor graphic")
        pixels = decode_planar(raw, width_words, height)
        colour_set = definition.floor_colour_set
        if colour_set >= len(self.floor_palettes):
            raise ValueError(
                f"object ${code:02X}: invalid floor colour set ${colour_set:02X}"
            )
        pixels = remap_template_colours(pixels, self.floor_palettes[colour_set])
        return IndexedSprite(
            f"object_{code:02X}_floor_view_{view}",
            "ObjectsOnFloor.gfx",
            offset,
            pixels,
        )

    def floor_preview(
        self, code: int
    ) -> tuple[list[list[int]], tuple[tuple[int, int, int], ...]]:
        """Draw all five source projections in one correct left-hand lane.

        The returned records are ``(view, x, y)`` from nearest view 0 to
        furthest view 4.  Rendering is performed furthest-first so nearer
        objects correctly cover more distant ones where their pixels overlap.
        """

        definition = self.definition(code)
        floor_background = [
            list(row) for row in self.floor_background[OBJECT_FLOOR_BACKGROUND_TOP:]
        ]
        if definition.floor_shape == 0xFF:
            return floor_background, ()
        placements = tuple(
            (
                view,
                self.floor_left_x[view],
                self.floor_view_y[view]
                - OBJECT_FLOOR_PREVIEW_Y_ORIGIN
                + OBJECT_FLOOR_PREVIEW_Y_ADJUSTMENT
                + self.floor_y_adjustments[
                    definition.floor_shape * OBJECT_FLOOR_VIEWS_PER_SHAPE + view
                ],
            )
            for view in range(OBJECT_FLOOR_VIEWS_PER_SHAPE)
        )
        canvas = floor_background
        for view, x, y in reversed(placements):
            sprite = self.floor_sprite(code, view)
            if sprite is not None:
                blit(canvas, sprite.pixels, x, y)
        return canvas, placements

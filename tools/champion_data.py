#!/usr/bin/env python3
"""Decode SPS 439 champion records and their three graphical representations."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from tools.gamefont_converter import read_font
from tools.graphics_preview import (
    IndexedSprite,
    blit,
    decode_planar,
    decode_fixed_sprites,
    remap_template_colours,
)


CHAMPION_RECORD_SIZE = 0x20
CHAMPION_COUNT = 0x10
POCKET_RECORD_SIZE = 0x10
POCKET_SHEET_WIDTH = 320
POCKET_SHEET_HEIGHT = 200
POCKET_SHEET_WIDTH_WORDS = POCKET_SHEET_WIDTH // 16
POCKET_ICON_SIZE = 16

# These are the native planar dimensions of the four extracted scroll edge
# resources.  The top and bottom are horizontal strips; the side resources are
# vertical strips used to assemble the complete scroll frame.
SCROLL_EDGE_SPECS = {
    # Drawn by adrCd00CC3A/adrCd00CE28 with d5=$0005000E:
    # DBRA counts make this 6 words (96 pixels) by 15 rows.
    "top": (6, 15),
    "bottom": (6, 15),
    "left": (1, 58),
    # The current extracted file also contains two cursor sprites after the
    # 58-pixel edge.  They are not part of the scroll and are intentionally
    # left for a future cursor resource split.
    "right": (1, 58),
}

# WordsText entries $00-$0F and $64-$73 respectively.  They are kept together
# here until those two ranges are extracted as their own resources.
CHAMPION_GIVEN_NAMES = (
    "BLODWYN",
    "MURLOCK",
    "ELEANOR",
    "ROSANNE",
    "ASTROTH",
    "ZOTHEN",
    "BALDRICK",
    "ELFRIC",
    "SIR EDWARD",
    "MEGRIM",
    "SETHRA",
    "MR.FLAY",
    "ULRICH",
    "ZASTAPH",
    "HENGIST",
    "THAI CHANG",
)
CHAMPION_SECOND_NAMES = (
    "STONEMAIDEN",
    "DARKHEART",
    "OF AVALON",
    "SWIFTHAND",
    "SLAEMWORT",
    "RUNECASTER",
    "THE DUNG",
    "FALAENDOR",
    "LION",
    "OF MOONWYCH",
    "BHOAGHAIL",
    "SEPULCRAST",
    "STERNAXE",
    "MANTRIC",
    "MELDANASH",
    "OF YINN",
)

CLASS_COLOUR_MASKS = (
    (0, 6, 5, 14),
    (0, 13, 11, 14),
    (0, 11, 12, 13),
    (0, 8, 7, 14),
)
DEAD_CLASS_COLOUR_MASK = (0, 2, 1, 3)
WORN_SPELL_SHIELD_INK_COLOURS = (6, 13, 6, 8, 6, 6, 13, 8)
PROFESSION_NAMES = ("WARRIOR", "WIZARD", "ADVENTURER", "CUTPURSE")
MAGIC_CLASS_NAMES = ("SERPENT", "CHAOS", "DRAGON", "MOON")


@dataclass(frozen=True)
class PocketCustomSprite:
    name: str
    x: int
    y: int
    width: int
    height: int

    @property
    def byte_offset(self) -> int:
        return self.y * POCKET_SHEET_WIDTH_WORDS * 8 + (self.x // 16) * 8


POCKET_CUSTOM_SPRITES = {
    "inventory_spellbook_open": PocketCustomSprite(
        "inventory_spellbook_open", 0, 104, 98, 64
    ),
    "inventory_status_panel": PocketCustomSprite(
        "inventory_status_panel", 0, 176, 48, 24
    ),
    "inventory_controls_serpent": PocketCustomSprite(
        "inventory_controls_serpent", 48, 176, 80, 24
    ),
    "inventory_controls_moon": PocketCustomSprite(
        "inventory_controls_moon", 128, 176, 80, 24
    ),
    "inventory_chain": PocketCustomSprite("inventory_chain", 0, 96, 128, 16),
    "inventory_chain_with_avatars": PocketCustomSprite(
        "inventory_chain_with_avatars", 96, 96, 128, 16
    ),
    "inventory_empty_pockets": PocketCustomSprite(
        "inventory_empty_pockets", 0, 0, 16, 16
    ),
    "inventory_empty_shield": PocketCustomSprite(
        "inventory_empty_shield", 224, 144, 32, 48
    ),
}


@dataclass(frozen=True)
class ChampionRecord:
    index: int
    raw: bytes

    @property
    def given_name(self) -> str:
        return CHAMPION_GIVEN_NAMES[self.index]

    @property
    def second_name(self) -> str:
        return CHAMPION_SECOND_NAMES[self.index]

    @property
    def full_name(self) -> str:
        return f"{self.given_name} {self.second_name}"

    def byte(self, offset: int) -> int:
        return self.raw[offset]

    def spellbook_page_flags(self, page: int) -> int:
        """Return the four availability bits for spell-book page ``0..7``.

        Champion bytes $0C-$0F hold two pages each: an even page is the high
        nibble and the following odd page is the low nibble. Within a nibble,
        the top bit is the first four-rune spell on that page.
        """
        if not 0 <= page < 8:
            raise ValueError("spell-book page must be 0..7")
        flags = self.raw[0x0C + page // 2]
        return flags >> 4 if page % 2 == 0 else flags & 0x0F

    def has_spellbook_spell(self, spell_index: int) -> bool:
        """Return whether one of the 32 spell-book entries is available."""
        if not 0 <= spell_index < 32:
            raise ValueError("spell index must be 0..31")
        page, entry = divmod(spell_index, 4)
        return bool(self.spellbook_page_flags(page) & (1 << (3 - entry)))

    @property
    def learned_spells(self) -> tuple[int, ...]:
        return tuple(spell for spell in range(32) if self.has_spellbook_spell(spell))

    @property
    def spell_points_current(self) -> int:
        """Current spell points ($09 in the 32-byte champion record)."""
        return self.raw[0x09]

    @property
    def spell_points_maximum(self) -> int:
        """Maximum spell points ($0A in the 32-byte champion record)."""
        return self.raw[0x0A]

    @property
    def direction(self) -> int:
        return self.raw[0x18] & 0x03

    @property
    def floor_position(self) -> int:
        return (self.raw[0x18] >> 4) & 0x03


def load_champion_records(path: Path) -> tuple[ChampionRecord, ...]:
    data = path.read_bytes()
    expected = CHAMPION_COUNT * CHAMPION_RECORD_SIZE
    if len(data) != expected:
        raise ValueError(f"{path.name}: expected {expected} bytes, got {len(data)}")
    return tuple(
        ChampionRecord(
            index,
            data[
                index * CHAMPION_RECORD_SIZE : (index + 1) * CHAMPION_RECORD_SIZE
            ],
        )
        for index in range(CHAMPION_COUNT)
    )


def load_pocket_records(path: Path) -> tuple[bytes, ...]:
    data = path.read_bytes()
    expected = CHAMPION_COUNT * POCKET_RECORD_SIZE
    if len(data) != expected:
        raise ValueError(f"{path.name}: expected {expected} bytes, got {len(data)}")
    return tuple(
        data[
            index * POCKET_RECORD_SIZE : (index + 1) * POCKET_RECORD_SIZE
        ]
        for index in range(CHAMPION_COUNT)
    )


class PocketsAssets:
    """Expose the regular 16x16 Pockets grid and known custom raw sprites."""

    def __init__(self, path: Path):
        self.path = path
        self.data = path.read_bytes()
        image_size = POCKET_SHEET_WIDTH_WORDS * POCKET_SHEET_HEIGHT * 8
        if len(self.data) < image_size:
            raise ValueError(f"{path.name}: expected at least {image_size} bytes")
        self.image_data = self.data[:image_size]
        self.trailing_data = self.data[image_size:]
        self.sheet_pixels = decode_planar(
            self.image_data, POCKET_SHEET_WIDTH_WORDS, POCKET_SHEET_HEIGHT
        )
        self.icons_per_row = POCKET_SHEET_WIDTH // POCKET_ICON_SIZE
        self.icon_rows = POCKET_SHEET_HEIGHT // POCKET_ICON_SIZE
        self.icon_count = self.icons_per_row * self.icon_rows

    def crop(self, name: str, x: int, y: int, width: int, height: int) -> IndexedSprite:
        if (
            x < 0
            or y < 0
            or width <= 0
            or height <= 0
            or x + width > POCKET_SHEET_WIDTH
            or y + height > POCKET_SHEET_HEIGHT
        ):
            raise ValueError(f"{name}: crop exceeds Pockets.gfx sheet bounds")
        return IndexedSprite(
            name,
            self.path.name,
            y * POCKET_SHEET_WIDTH_WORDS * 8 + (x // 16) * 8,
            [row[x : x + width] for row in self.sheet_pixels[y : y + height]],
        )

    def icon(self, index: int) -> IndexedSprite:
        if not 0 <= index < self.icon_count:
            raise ValueError(
                f"Pockets icon must be 0..{self.icon_count - 1}, got {index}"
            )
        x = (index % self.icons_per_row) * POCKET_ICON_SIZE
        y = (index // self.icons_per_row) * POCKET_ICON_SIZE
        return self.crop(
            f"pockets_icon_{index:02X}",
            x,
            y,
            POCKET_ICON_SIZE,
            POCKET_ICON_SIZE,
        )

    def custom(self, name: str) -> IndexedSprite:
        if name not in POCKET_CUSTOM_SPRITES:
            raise ValueError(f"Unknown Pockets custom sprite '{name}'")
        descriptor = POCKET_CUSTOM_SPRITES[name]
        return self.crop(
            descriptor.name,
            descriptor.x,
            descriptor.y,
            descriptor.width,
            descriptor.height,
        )


class ScrollEdgeAssets:
    """Decode the four native scroll-frame strips used by the stats screen."""

    def __init__(self, gfx: Path):
        self.gfx = gfx
        self.edges: dict[str, IndexedSprite] = {}
        for name, (width_words, height) in SCROLL_EDGE_SPECS.items():
            path = gfx / f"Scroll_Edge_{name.title()}.gfx"
            sprite_size = width_words * height * 8
            raw = path.read_bytes()
            if len(raw) < sprite_size:
                raise ValueError(
                    f"{path.name}: expected at least {sprite_size} bytes, got {len(raw)}"
                )
            pixels = decode_planar(raw[:sprite_size], width_words, height)
            self.edges[name] = IndexedSprite(
                f"scroll_edge_{name}", path.name, 0, pixels
            )

    def __getitem__(self, name: str) -> IndexedSprite:
        return self.edges[name]


class ChampionAssets:
    """Read the champion block, avatars and game font from one overlay root."""

    REQUIRED_FILES = (
        "data/champions.stats",
        "gfx/Avatars_Large.gfx",
        "gfx/Shield_Avatars.gfx",
        "gfx/ShieldClasses.gfx",
        "gfx/ShieldTop.gfx",
        "gfx/ShieldBottom.gfx",
        "gfx/Shield_Clicked.gfx",
        "gfx/GameFont",
        "gfx/Pockets.gfx",
        "gfx/Scroll_Edge_Top.gfx",
        "gfx/Scroll_Edge_Bottom.gfx",
        "gfx/Scroll_Edge_Left.gfx",
        "gfx/Scroll_Edge_Right.gfx",
        "data/champions.pockets",
    )

    def __init__(self, data_root: Path):
        self.data_root = data_root
        self.records = load_champion_records(data_root / "data/champions.stats")
        self.pocket_records = load_pocket_records(data_root / "data/champions.pockets")
        gfx = data_root / "gfx"
        self.pockets = PocketsAssets(gfx / "Pockets.gfx")
        self.scroll_edges = ScrollEdgeAssets(gfx)
        self.large_avatars = decode_fixed_sprites(
            gfx / "Avatars_Large.gfx",
            width_words=2,
            height=30,
            count=16,
            name_prefix="champion_large",
        )
        self.small_avatars = decode_fixed_sprites(
            gfx / "Shield_Avatars.gfx",
            width_words=2,
            height=16,
            count=16,
            name_prefix="champion_small",
        )
        self.shield_classes = decode_fixed_sprites(
            gfx / "ShieldClasses.gfx",
            width_words=2,
            height=11,
            count=4,
            name_prefix="shield_class",
        )
        self.shield_top = decode_fixed_sprites(
            gfx / "ShieldTop.gfx",
            width_words=2,
            height=5,
            count=1,
            name_prefix="shield_top",
        )[0]
        self.shield_bottom = decode_fixed_sprites(
            gfx / "ShieldBottom.gfx",
            width_words=2,
            height=9,
            count=1,
            name_prefix="shield_bottom",
        )[0]
        self.shield_clicked = decode_fixed_sprites(
            gfx / "Shield_Clicked.gfx",
            width_words=2,
            height=41,
            count=1,
            name_prefix="shield_clicked",
        )[0]
        self.game_font = read_font(gfx / "GameFont")

    def record(self, champion: int) -> ChampionRecord:
        if not 0 <= champion < CHAMPION_COUNT:
            raise ValueError("champion must be $00-$0F")
        return self.records[champion]

    def pocket_record(self, champion: int) -> bytes:
        if not 0 <= champion < CHAMPION_COUNT:
            raise ValueError("champion must be $00-$0F")
        return self.pocket_records[champion]

    @staticmethod
    def profession_index(champion: int) -> int:
        """Return Warrior/Wizard/Adventurer/Cutpurse as used by the shield."""
        if not 0 <= champion < CHAMPION_COUNT:
            raise ValueError("champion must be $00-$0F")
        return champion & 3

    @staticmethod
    def magic_class_index(champion: int) -> int:
        """Reproduce the magic-alignment selector at ``adrCd006900``."""
        if not 0 <= champion < CHAMPION_COUNT:
            raise ValueError("champion must be $00-$0F")
        return (champion + champion // 4) & 3

    def party_shield_ink_colour(
        self, champion: int, *, worn_spell: int = 0
    ) -> int:
        """Reproduce the living party-shield ink selection at $CCFE/$7FE0."""
        self.record(champion)
        if not 0 <= worn_spell <= 0xFF:
            raise ValueError("worn_spell must be a byte value")
        if not worn_spell:
            return 4
        colour = WORN_SPELL_SHIELD_INK_COLOURS[worn_spell & 7]
        return 7 if colour == 8 else colour

    def shield_avatar(
        self,
        champion: int,
        *,
        state: str = "alive",
        ink15_colour: int | None = None,
    ) -> IndexedSprite:
        if state not in ("alive", "dead"):
            raise ValueError("state must be 'alive' or 'dead'")
        if ink15_colour is None:
            ink15_colour = 0 if state == "dead" else 4
        if not 0 <= ink15_colour <= 15:
            raise ValueError("ink15_colour must be a palette index from 0 to 15")
        profession_index = self.profession_index(champion)
        magic_class_index = self.magic_class_index(champion)
        mask = (
            DEAD_CLASS_COLOUR_MASK
            if state == "dead"
            else CLASS_COLOUR_MASKS[magic_class_index]
        )
        class_pixels = remap_template_colours(
            self.shield_classes[profession_index].pixels, mask
        )
        source_pieces = (
            self.shield_top.pixels,
            self.small_avatars[champion].pixels,
            class_pixels,
            self.shield_bottom.pixels,
        )
        # Draw_ShieldAvatar applies the four-colour mask only to the class
        # symbol. The common planar renderer then replaces ink $F in every
        # component with D3; in the avatar graphic those pixels form the
        # shield background/surround rather than the champion's face.
        pieces = tuple(
            [
                [ink15_colour if colour == 15 else colour for colour in row]
                for row in piece
            ]
            for piece in source_pieces
        )
        canvas = [[0] * 32 for _ in range(sum(len(piece) for piece in pieces))]
        y = 0
        for piece in pieces:
            blit(canvas, piece, 0, y, transparent_index=None)
            y += len(piece)
        return IndexedSprite(
            f"champion_shield_{champion:02X}",
            "ShieldTop/Shield_Avatars/ShieldClasses/ShieldBottom.gfx",
            0,
            canvas,
        )

    def large_avatar_pixels(
        self, champion: int, *, colour_mask: tuple[int, int, int] | None = None
    ) -> list[list[int]]:
        """Return a large portrait, optionally applying an Extended Levels mask.

        The standard interface displays the source colours unchanged.  The
        optional three-entry mask is retained for the Extended Levels avatar
        editor and substitutes only template indices $4/$8/$C. Palette index
        $0 remains the portrait's original black outline/background colour.
        """
        if not 0 <= champion < CHAMPION_COUNT:
            raise ValueError("champion must be $00-$0F")
        pixels = self.large_avatars[champion].pixels
        if colour_mask is None:
            return [list(row) for row in pixels]
        if len(colour_mask) != 3:
            raise ValueError(
                "avatar colour mask must contain replacements for $4/$8/$C"
            )
        return remap_template_colours(pixels, (0, *colour_mask))

    def missing_shield(self) -> IndexedSprite:
        """Return the horse emblem used for an empty party shield slot."""
        return self.shield_clicked

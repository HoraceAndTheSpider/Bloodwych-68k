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

    @property
    def learned_spells(self) -> tuple[int, ...]:
        spells: list[int] = []
        for page, flags in enumerate(self.raw[0x0C:0x10]):
            for spell in range(8):
                if flags & (1 << (7 - spell)):
                    spells.append(page * 8 + spell)
        return tuple(spells)

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
        self.sheet_pixels = decode_planar(
            self.data[:image_size], POCKET_SHEET_WIDTH_WORDS, POCKET_SHEET_HEIGHT
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

    def shield_avatar(self, champion: int) -> IndexedSprite:
        profession_index = self.profession_index(champion)
        magic_class_index = self.magic_class_index(champion)
        mask = CLASS_COLOUR_MASKS[magic_class_index]
        pieces = (
            (self.shield_top, False),
            (self.small_avatars[champion], False),
            (self.shield_classes[profession_index], True),
            (self.shield_bottom, False),
        )
        # Index $F is transparent in these UI components.  The shields are
        # drawn over the game's black panel, so skipped pixels resolve to $0.
        canvas = [[0] * 32 for _ in range(sum(piece.height for piece, _ in pieces))]
        y = 0
        for piece, recolour in pieces:
            pixels = (
                remap_template_colours(piece.pixels, mask)
                if recolour
                else piece.pixels
            )
            blit(canvas, pixels, 0, y)
            y += piece.height
        return IndexedSprite(
            f"champion_shield_{champion:02X}",
            "ShieldTop/Shield_Avatars/ShieldClasses/ShieldBottom.gfx",
            0,
            canvas,
        )

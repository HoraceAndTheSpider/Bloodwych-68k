import unittest
from pathlib import Path

from tools.champion_data import (
    CHAMPION_GIVEN_NAMES,
    CHAMPION_SECOND_NAMES,
    POCKET_CUSTOM_SPRITES,
    ChampionAssets,
    PocketsAssets,
    SCROLL_EDGE_SPECS,
    ScrollEdgeAssets,
    load_champion_records,
)


DATA_ROOT = Path("data/BLOODWYCH439-clean")


class ChampionDataTests(unittest.TestCase):
    def test_sps439_champion_records_decode_documented_fields(self) -> None:
        records = load_champion_records(DATA_ROOT / "data/champions.stats")
        blodwyn = records[0]

        self.assertEqual(len(records), 16)
        self.assertEqual(blodwyn.full_name, "BLODWYN STONEMAIDEN")
        self.assertEqual(
            blodwyn.raw[:12],
            bytes((1, 35, 17, 13, 13, 35, 35, 31, 31, 6, 9, 5)),
        )
        self.assertEqual(blodwyn.learned_spells, (0,))
        self.assertEqual(blodwyn.byte(0x10), 0xC7)
        self.assertEqual(blodwyn.byte(0x11), 0xFF)
        self.assertEqual(
            (blodwyn.byte(0x16), blodwyn.byte(0x17)), (7, 9)
        )
        self.assertEqual(blodwyn.floor_position, 0)
        self.assertEqual(blodwyn.direction, 2)

    def test_champion_names_cover_all_sixteen_records(self) -> None:
        self.assertEqual(
            len(CHAMPION_GIVEN_NAMES), len(CHAMPION_SECOND_NAMES)
        )
        self.assertEqual(len(CHAMPION_GIVEN_NAMES), 16)
        self.assertEqual(CHAMPION_GIVEN_NAMES[-1], "THAI CHANG")
        self.assertEqual(CHAMPION_SECOND_NAMES[-1], "OF YINN")

    def test_champion_assets_build_source_composite_shields(self) -> None:
        assets = ChampionAssets(DATA_ROOT)
        shield = assets.shield_avatar(0)

        self.assertEqual(shield.width, 32)
        self.assertEqual(shield.height, 41)
        self.assertEqual(assets.profession_index(0), 0)
        self.assertEqual(assets.profession_index(4), 0)
        self.assertEqual(assets.magic_class_index(0), 0)
        self.assertEqual(assets.magic_class_index(4), 1)
        self.assertEqual(assets.large_avatars[0].width, 32)
        self.assertEqual(assets.large_avatars[0].height, 30)
        self.assertNotIn(15, (pixel for row in shield.pixels for pixel in row))

    def test_profession_and_magic_alignment_use_separate_source_rules(self) -> None:
        assets = ChampionAssets(DATA_ROOT)
        professions = tuple(assets.profession_index(index) for index in range(16))
        alignments = tuple(assets.magic_class_index(index) for index in range(16))

        self.assertEqual(professions, (0, 1, 2, 3) * 4)
        self.assertEqual(
            alignments,
            (0, 1, 2, 3, 1, 2, 3, 0, 2, 3, 0, 1, 3, 0, 1, 2),
        )

    def test_pockets_icons_are_coordinate_crops_from_one_sheet(self) -> None:
        pockets = PocketsAssets(DATA_ROOT / "gfx/Pockets.gfx")
        icon_0 = pockets.icon(0)
        icon_1 = pockets.icon(1)
        icon_20 = pockets.icon(20)
        book = pockets.custom("inventory_spellbook_open")

        self.assertEqual(icon_0.byte_offset, 0)
        self.assertEqual(icon_1.byte_offset, 8)
        self.assertEqual(icon_20.byte_offset, 160 * 16)
        self.assertEqual(icon_0.width, 16)
        self.assertEqual(icon_0.height, 16)
        self.assertEqual(book.width, 98)
        self.assertEqual(book.height, 64)
        self.assertEqual(POCKET_CUSTOM_SPRITES["inventory_spellbook_open"].x, 0)
        self.assertEqual(POCKET_CUSTOM_SPRITES["inventory_spellbook_open"].y, 104)

    def test_scroll_edges_decode_at_native_dimensions(self) -> None:
        edges = ScrollEdgeAssets(DATA_ROOT / "gfx")
        self.assertEqual(
            {name: (sprite.width // 16, sprite.height) for name, sprite in edges.edges.items()},
            SCROLL_EDGE_SPECS,
        )

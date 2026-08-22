import unittest
from pathlib import Path

from tools.champion_data import (
    CHAMPION_GIVEN_NAMES,
    CHAMPION_SECOND_NAMES,
    DEAD_CLASS_COLOUR_MASK,
    POCKET_CUSTOM_SPRITES,
    ChampionAssets,
    PocketsAssets,
    SCROLL_EDGE_SPECS,
    ScrollEdgeAssets,
    WORN_SPELL_SHIELD_INK_COLOURS,
    load_champion_records,
)
from tools.graphics_preview import remap_template_colours


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
        self.assertEqual(
            tuple(blodwyn.spellbook_page_flags(page) for page in range(8)),
            (0x8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0),
        )
        self.assertTrue(blodwyn.has_spellbook_spell(0))
        self.assertFalse(blodwyn.has_spellbook_spell(1))
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
        self.assertEqual(assets.large_avatar_pixels(0), assets.large_avatars[0].pixels)
        recoloured_large = assets.large_avatar_pixels(0, colour_mask=(6, 5, 14))
        self.assertNotEqual(recoloured_large, assets.large_avatars[0].pixels)
        for y, row in enumerate(assets.large_avatars[0].pixels):
            for x, colour in enumerate(row):
                if colour == 0:
                    self.assertEqual(recoloured_large[y][x], 0)
        self.assertNotIn(15, (pixel for row in shield.pixels for pixel in row))
        dead = assets.shield_avatar(0, state="dead")
        self.assertNotEqual(dead.pixels, shield.pixels)
        self.assertNotEqual(dead.pixels[21:32], shield.pixels[21:32])
        expected_avatar = [
            [4 if colour == 15 else colour for colour in row]
            for row in assets.small_avatars[0].pixels
        ]
        self.assertEqual(shield.pixels[5:21], expected_avatar)
        expected_dead_avatar = [
            [0 if colour == 15 else colour for colour in row]
            for row in assets.small_avatars[0].pixels
        ]
        self.assertEqual(dead.pixels[5:21], expected_dead_avatar)
        expected_dead_class = [
            [0 if colour == 15 else colour for colour in row]
            for row in remap_template_colours(
                assets.shield_classes[0].pixels, DEAD_CLASS_COLOUR_MASK
            )
        ]
        self.assertEqual(dead.pixels[21:32], expected_dead_class)
        self.assertEqual(
            WORN_SPELL_SHIELD_INK_COLOURS, (6, 13, 6, 8, 6, 6, 13, 8)
        )
        self.assertEqual(assets.party_shield_ink_colour(0), 4)
        self.assertEqual(assets.party_shield_ink_colour(0, worn_spell=0xFF), 7)
        self.assertEqual(assets.missing_shield().width, 32)
        self.assertEqual(assets.missing_shield().height, 41)

    def test_profession_and_magic_alignment_use_separate_source_rules(self) -> None:
        assets = ChampionAssets(DATA_ROOT)
        professions = tuple(assets.profession_index(index) for index in range(16))
        alignments = tuple(assets.magic_class_index(index) for index in range(16))

        self.assertEqual(professions, (0, 1, 2, 3) * 4)
        self.assertEqual(
            alignments,
            (0, 1, 2, 3, 1, 2, 3, 0, 2, 3, 0, 1, 3, 0, 1, 2),
        )

    def test_all_shield_portraits_keep_their_source_colours_in_every_state(self) -> None:
        assets = ChampionAssets(DATA_ROOT)
        for champion in range(16):
            expected_alive = [
                [4 if colour == 15 else colour for colour in row]
                for row in assets.small_avatars[champion].pixels
            ]
            expected_dead = [
                [0 if colour == 15 else colour for colour in row]
                for row in assets.small_avatars[champion].pixels
            ]
            with self.subTest(champion=champion, state="alive"):
                self.assertEqual(
                    assets.shield_avatar(champion).pixels[5:21], expected_alive
                )
            with self.subTest(champion=champion, state="dead"):
                self.assertEqual(
                    assets.shield_avatar(champion, state="dead").pixels[5:21],
                    expected_dead,
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
        self.assertEqual(len(pockets.image_data), 32000)
        self.assertEqual(len(pockets.trailing_data), 32)
        self.assertEqual(
            pockets.trailing_data,
            bytes.fromhex(
                "000100040008000c000e0007000b000f"
                "000100010001000100800054002a0000"
            ),
        )

    def test_scroll_edges_decode_at_native_dimensions(self) -> None:
        edges = ScrollEdgeAssets(DATA_ROOT / "gfx")
        self.assertEqual(
            {name: (sprite.width // 16, sprite.height) for name, sprite in edges.edges.items()},
            SCROLL_EDGE_SPECS,
        )

from pathlib import Path
import unittest

from tools.object_data import OBJECT_GROUPS, OBJECT_GROUP_BY_KEY, ObjectAssets


ROOT = Path(__file__).resolve().parents[1]
DATA_ROOT = ROOT / "data/BLOODWYCH439-clean"


class ObjectDataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.assets = ObjectAssets(DATA_ROOT)

    def test_overlapping_source_tables_form_110_complete_records(self) -> None:
        self.assertEqual(len(self.assets.definitions), 0x6E)
        self.assertEqual(self.assets.definition(0x00).name, "EMPTY SLOT")
        self.assertEqual(self.assets.definition(0x01).name, "COINAGE")
        self.assertEqual(self.assets.definition(0x6D).name, "BOOK OF SKULLS")

    def test_source_confirmed_quantity_and_food_boundaries(self) -> None:
        self.assertTrue(self.assets.definition(0x01).displays_quantity)
        self.assertTrue(self.assets.definition(0x04).displays_quantity)
        self.assertFalse(self.assets.definition(0x05).displays_quantity)
        self.assertTrue(self.assets.definition(0x05).edible)
        self.assertTrue(self.assets.definition(0x16).edible)
        self.assertFalse(self.assets.definition(0x17).edible)

    def test_ordered_group_sizes_derive_every_object_boundary(self) -> None:
        self.assertEqual(OBJECT_GROUPS[0].first, 0)
        self.assertEqual(OBJECT_GROUPS[-1].last, 0x6D)
        self.assertEqual(OBJECT_GROUP_BY_KEY["food"].first, 0x05)
        self.assertEqual(OBJECT_GROUP_BY_KEY["potions"].first, 0x17)
        self.assertEqual(OBJECT_GROUP_BY_KEY["small_shields"].first, 0x24)
        self.assertEqual(OBJECT_GROUP_BY_KEY["large_shields"].first, 0x27)
        self.assertEqual(OBJECT_GROUP_BY_KEY["remains"].first, 0x40)
        self.assertEqual(OBJECT_GROUP_BY_KEY["book_of_skulls"].first, 0x6D)
        self.assertEqual(sum(group.count for group in OBJECT_GROUPS), 0x6E)

    def test_pocket_and_floor_appearances_are_decoded(self) -> None:
        coin = self.assets.definition(0x01)
        self.assertEqual((coin.pocket_icon, coin.floor_shape), (0x01, 0x02))
        self.assertEqual(
            (self.assets.pocket_sprite(0x01).width, self.assets.pocket_sprite(0x01).height),
            (16, 16),
        )
        floor = self.assets.floor_sprite(0x01)
        self.assertIsNotNone(floor)
        assert floor is not None
        self.assertEqual((floor.width, floor.height), (16, 4))

    def test_wide_floor_shapes_use_the_second_graphics_region(self) -> None:
        armour = self.assets.floor_sprite(0x1B)
        self.assertIsNotNone(armour)
        assert armour is not None
        self.assertEqual(armour.width, 32)
        self.assertGreaterEqual(armour.byte_offset, 0x0CB8)

    def test_every_object_and_projected_floor_view_decodes(self) -> None:
        for code in range(0x6E):
            self.assets.pocket_sprite(code)
            if self.assets.definition(code).floor_shape != 0xFF:
                for view in range(5):
                    self.assets.floor_sprite(code, view)

    def test_floor_preview_places_all_five_source_views_in_left_lane(self) -> None:
        preview, placements = self.assets.floor_preview(0x01)
        self.assertEqual((len(preview[0]), len(preview)), (128, 34))
        self.assertEqual(tuple(view for view, _, _ in placements), (0, 1, 2, 3, 4))
        self.assertEqual(tuple(x for _, x, _ in placements), (22, 28, 34, 41, 47))
        self.assertEqual(tuple(y for _, _, y in placements), (29, 20, 14, 9, 3))

    def test_definition_words_include_the_none_sentinel(self) -> None:
        coin = self.assets.definition(0x01)
        self.assertEqual(coin.resolved_word(coin.first_name_index), "COINAGE")
        self.assertEqual(coin.resolved_word(coin.second_name_index), "NONE")

    def test_gamefont_is_available_for_counted_object_quantities(self) -> None:
        self.assertEqual(len(self.assets.game_font), 0x280)


if __name__ == "__main__":
    unittest.main()

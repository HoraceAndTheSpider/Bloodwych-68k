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
        self.assertEqual(self.assets.definition(0x01).quantity_position, "above")
        self.assertEqual(self.assets.definition(0x02).quantity_position, "above")
        self.assertEqual(self.assets.definition(0x03).quantity_position, "below")
        self.assertEqual(self.assets.definition(0x04).quantity_position, "below")
        self.assertIsNone(self.assets.definition(0x05).quantity_position)
        self.assertEqual(self.assets.definition(0x01).quantity_cell_y, 2)
        self.assertEqual(self.assets.definition(0x02).quantity_cell_y, 2)
        self.assertEqual(self.assets.definition(0x03).quantity_cell_y, 9)
        self.assertEqual(self.assets.definition(0x04).quantity_cell_y, 9)
        self.assertIsNone(self.assets.definition(0x05).quantity_cell_y)
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

    def test_portioned_food_descends_within_each_three_object_family(self) -> None:
        expected = {
            0x05: 0x00,
            0x06: 0x05,
            0x07: 0x06,
            0x08: 0x00,
            0x09: 0x08,
            0x0A: 0x09,
            0x0B: 0x00,
            0x0C: 0x0B,
            0x0D: 0x0C,
            0x0E: 0x00,
            0x0F: 0x0E,
            0x10: 0x0F,
            0x11: 0x00,
            0x12: 0x11,
            0x13: 0x12,
        }
        for code, after_use in expected.items():
            definition = self.assets.definition(code)
            self.assertEqual(definition.use_kind, "portioned_food")
            self.assertEqual(definition.object_after_use, after_use)
            self.assertEqual(
                definition.food_value_gain,
                0x20 if code < 0x0E else 0x14,
            )

    def test_whole_food_and_potions_are_removed_after_one_use(self) -> None:
        self.assertEqual(
            tuple(self.assets.definition(code).food_value_gain for code in range(0x14, 0x17)),
            (0x42, 0x84, 0xC6),
        )
        for code in range(0x14, 0x1B):
            self.assertEqual(self.assets.definition(code).object_after_use, 0)
        self.assertIn("hit points", self.assets.definition(0x17).use_effect)
        self.assertIn("half", self.assets.definition(0x18).use_effect)
        self.assertIn("vitality", self.assets.definition(0x19).use_effect)
        self.assertIn("spell points", self.assets.definition(0x1A).use_effect)

    def test_gamefont_is_available_for_counted_object_quantities(self) -> None:
        self.assertEqual(len(self.assets.game_font), 0x280)


if __name__ == "__main__":
    unittest.main()

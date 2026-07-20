import unittest

from tools.monster_view import (
    VIEW_CELL_COORDINATES,
    resolve_monster_screen_position,
    view_cell_at,
    visible_subpositions,
)


class MonsterViewGeometryTests(unittest.TestCase):
    def test_view_cone_uses_the_games_nineteen_cells(self) -> None:
        self.assertEqual(len(VIEW_CELL_COORDINATES), 19)
        self.assertEqual(view_cell_at(0, 4), 14)
        self.assertEqual(view_cell_at(0, 1), 17)
        self.assertEqual(view_cell_at(-2, 4), 0)
        self.assertEqual(view_cell_at(2, 4), 7)
        self.assertEqual(view_cell_at(2, 2), None)

    def test_lateral_mini_space_visibility_matches_source_tables(self) -> None:
        self.assertEqual(visible_subpositions(5), (0, 3))
        self.assertEqual(visible_subpositions(12), (1, 2))
        self.assertEqual(visible_subpositions(4), (0, 2, 3))
        self.assertEqual(visible_subpositions(11), (1, 2, 3))
        self.assertEqual(visible_subpositions(0), (0,))
        self.assertEqual(visible_subpositions(7), (1, 2))

    def test_near_and_rear_positions_select_different_gfx_slots(self) -> None:
        near = resolve_monster_screen_position(17, 0)
        rear = resolve_monster_screen_position(17, 2)
        self.assertIsNotNone(near)
        self.assertIsNotNone(rear)
        assert near is not None and rear is not None
        self.assertEqual((near.gfx_slot, near.screen_x, near.screen_y), (0, 77, 39))
        self.assertEqual((rear.gfx_slot, rear.screen_x, rear.screen_y), (1, 40, 37))
        self.assertEqual(near.subposition_name, "near right")
        self.assertEqual(rear.subposition_name, "rear left")

    def test_ff_x_position_is_not_selectable(self) -> None:
        self.assertIsNone(resolve_monster_screen_position(5, 1))
        self.assertIsNone(resolve_monster_screen_position(2, 0))
        self.assertIsNone(resolve_monster_screen_position(18, 4))


if __name__ == "__main__":
    unittest.main()

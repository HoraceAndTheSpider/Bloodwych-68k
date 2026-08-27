from pathlib import Path
import unittest

from tools.map_editor.floor_objects import (
    cycle_object_stack_index,
    named_key_colour_index,
    object_marker_offset,
    object_position_name,
    object_stack_indices_at_cell,
    object_stack_location,
    object_stack_positions,
    project_floor_object,
    shelf_face_is_visible,
    shelf_level,
)
from tools.map_editor.model import MapProject, ObjectStack
from tools.object_data import ObjectAssets
from tools.tool_common import DATA_DIR


CLEAN_ROOT = DATA_DIR / "BLOODWYCH439-clean"


class FloorObjectTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.project = MapProject.from_extracted(CLEAN_ROOT)
        cls.assets = ObjectAssets(CLEAN_ROOT)

    def test_map_markers_follow_the_four_authored_object_subpositions(self) -> None:
        self.assertEqual(object_marker_offset(0), (4, 4))
        self.assertEqual(object_marker_offset(4), (12, 4))
        self.assertEqual(object_marker_offset(8), (4, 12))
        self.assertEqual(object_marker_offset(12), (12, 12))
        self.assertIsNone(object_marker_offset(1))

    def test_object_stack_byte_offset_resolves_to_its_map_floor_and_cell(self) -> None:
        stack = self.project.object_stacks(0)[11]
        self.assertEqual(
            object_stack_location(self.project.maps[0], stack),
            (3, 0, 5),
        )
        # First Keep object: record C8 0E identifies map-data offset $80E.
        self.assertEqual(
            self.project.maps[0].floor_from_map_index(0x80E),
            (3, 12, 11),
        )

    def test_stack_position_uses_corner_and_shelf_names(self) -> None:
        tower_map = self.project.maps[0]
        shelf_stack = self.project.object_stacks(0)[0]
        floor_stack = self.project.object_stacks(0)[11]
        self.assertEqual(object_position_name(tower_map, shelf_stack), "SOUTH WALL · TOP SHELF")
        self.assertEqual(object_stack_positions(tower_map, shelf_stack), (8, 12))
        self.assertEqual(object_position_name(tower_map, floor_stack), "SOUTH-WEST")
        self.assertEqual(object_stack_positions(tower_map, floor_stack), (0, 4, 8, 12))

    def test_stack_lookup_retains_source_rotation_order(self) -> None:
        tower_map = self.project.maps[0]
        stacks = self.project.object_stacks(0)
        stack = stacks[11]
        location = object_stack_location(tower_map, stack)
        assert location is not None
        indexes = object_stack_indices_at_cell(tower_map, stacks, *location)
        self.assertIn(11, indexes)
        self.assertEqual(tuple(sorted(indexes)), indexes)
        self.assertEqual(cycle_object_stack_index((4, 9, 12), None), 4)
        self.assertEqual(cycle_object_stack_index((4, 9, 12), 4), 9)
        self.assertEqual(cycle_object_stack_index((4, 9, 12), 12), 4)
        self.assertIsNone(cycle_object_stack_index((), 4))

    def test_floor_object_uses_the_source_projection_and_position_tables(self) -> None:
        stack = self.project.object_stacks(0)[11]
        projection = project_floor_object(
            self.assets,
            stack,
            stack.items[0][0],
            view_cell=3,
            facing=0,
            shelf=False,
        )
        self.assertIsNotNone(projection)
        assert projection is not None
        self.assertEqual((projection.projection, projection.x, projection.y), (4, 1, 45))

    def test_shelf_uses_the_source_special_x_and_y_tables(self) -> None:
        stack = ObjectStack(0, 0, ((0x50, 1),))
        projection = project_floor_object(
            self.assets,
            stack,
            0x50,
            view_cell=3,
            facing=0,
            shelf=True,
            shelf_facing=0,
        )
        self.assertIsNotNone(projection)
        assert projection is not None
        self.assertTrue(projection.shelf)
        self.assertEqual(projection.x, 12)

    def test_shelf_position_codes_select_two_levels_by_shelf_orientation(self) -> None:
        self.assertEqual(shelf_level(0, 0), 0)   # North shelf: bottom
        self.assertEqual(shelf_level(4, 0), 1)   # North shelf: top
        self.assertEqual(shelf_level(4, 1), 0)   # East shelf: bottom
        self.assertEqual(shelf_level(12, 1), 1)  # East shelf: top
        self.assertEqual(shelf_level(8, 2), 0)   # South shelf: bottom
        self.assertEqual(shelf_level(12, 2), 1)  # South shelf: top
        self.assertEqual(shelf_level(8, 3), 0)   # West shelf: bottom
        self.assertEqual(shelf_level(0, 3), 1)   # West shelf: top
        self.assertIsNone(shelf_level(0, 2))

    def test_shelf_projection_rejects_a_position_invalid_for_its_orientation(self) -> None:
        projection = project_floor_object(
            self.assets,
            ObjectStack(0, 0, ((0x50, 1),)),
            0x50,
            view_cell=3,
            facing=0,
            shelf=True,
            shelf_facing=2,
        )
        self.assertIsNone(projection)

    def test_shelf_object_uses_the_same_source_wall_face_gate_as_the_shelf(self) -> None:
        # View cell 17 has a single visible front face, direction 2. The
        # facing side is drawable; a side-facing shelf is not.
        self.assertTrue(shelf_face_is_visible(17, 2))
        self.assertFalse(shelf_face_is_visible(17, 0))

    def test_all_extracted_shelf_stacks_use_a_valid_facing_level_pair(self) -> None:
        shelf_stacks = 0
        for tower_index, tower_map in enumerate(self.project.maps):
            for stack in self.project.object_stacks(tower_index):
                location = object_stack_location(tower_map, stack)
                if location is None:
                    continue
                floor, x, y = location
                cell = tower_map.cell(floor, x, y)
                if cell.map_type == 1 and cell.b & 3 == 0:
                    shelf_stacks += 1
                    self.assertIsNotNone(shelf_level(stack.position, cell.c & 3))
        self.assertGreater(shelf_stacks, 0)

    def test_current_map_cell_has_the_two_forward_reachable_positions(self) -> None:
        positions = {
            position: project_floor_object(
                self.assets,
                ObjectStack(position, 0, ((0x50, 1),)),
                0x50,
                view_cell=18,
                facing=0,
                shelf=False,
            )
            for position in (0, 4, 8, 12)
        }
        self.assertIsNotNone(positions[0])
        self.assertIsNotNone(positions[4])
        self.assertIsNone(positions[8])
        self.assertIsNone(positions[12])
        self.assertEqual(
            {position: projection.x for position, projection in positions.items() if projection is not None},
            {0: 22, 4: 76},
        )

    def test_named_keys_use_their_extracted_floor_palette_ink(self) -> None:
        bronze_key = ObjectStack(0, 0, ((0x50, 1),))
        common_key = ObjectStack(0, 0, ((0x02, 1),))
        self.assertEqual(named_key_colour_index(self.assets, bronze_key), 10)
        self.assertIsNone(named_key_colour_index(self.assets, common_key))


if __name__ == "__main__":
    unittest.main()

import unittest
from pathlib import Path

from tools.dungeon_view import (
    DUNGEON_FEATURES,
    DUNGEON_SPACE_TYPES,
    DungeonAssets,
    DungeonPlacement,
    dungeon_features_for_map_type,
    dungeon_state_name,
    dungeon_variant_name,
    render_dungeon_feature,
    render_dungeon_scene,
    scene_wall_visibility_mask,
    visible_wall_slots,
    wall_face_direction,
    wall_slots_in_draw_order,
    wall_slots_for_direction,
)
from tools.graphics_viewer import DUNGEON_DIRECTION_ARROW_DIRECTIONS
from tools.graphics_preview import VIEW_HEIGHT, VIEW_WIDTH, load_floor_ceiling_background


DATA_ROOT = (
    Path(__file__).resolve().parents[1] / "data" / "BLOODWYCH439-clean" / "gfx"
)


class DungeonViewGeometryTests(unittest.TestCase):
    def test_overlay_arrow_points_out_from_the_named_wall_side(self) -> None:
        self.assertEqual(
            DUNGEON_DIRECTION_ARROW_DIRECTIONS,
            ((0, 1), (-1, 0), (0, -1), (1, 0)),
        )

    def test_isolated_stone_cell_keeps_source_verified_faces(self) -> None:
        self.assertEqual(visible_wall_slots(0), (0, 1))
        self.assertEqual(visible_wall_slots(5), (9, 10))
        self.assertEqual(visible_wall_slots(17), (27,))

    def test_nearest_centre_face_rotation_matches_map_directions(self) -> None:
        directions_by_column = tuple(wall_face_direction(17, column) for column in range(4))
        self.assertEqual(directions_by_column, (0, 1, 3, 2))
        self.assertEqual(wall_slots_for_direction(17, 2), (27,))
        self.assertEqual(wall_slots_for_direction(17, 0), ())

    def test_space_types_expose_only_their_legal_options(self) -> None:
        self.assertEqual(
            tuple(item.map_type for item in DUNGEON_SPACE_TYPES),
            tuple(range(8)),
        )
        self.assertEqual(
            tuple(item.key for item in dungeon_features_for_map_type(3)),
            ("pillar", "bed"),
        )
        self.assertEqual(
            tuple(item.key for item in dungeon_features_for_map_type(1)),
            ("stone", "shelf", "sign", "switch", "socket"),
        )

    def test_wall_faces_retain_the_source_draw_order(self) -> None:
        self.assertEqual(visible_wall_slots(18), (11, 23, 27))
        self.assertEqual(wall_slots_in_draw_order(18), (27, 23, 11))

    def test_near_stone_wall_occludes_far_centre_cell(self) -> None:
        placements = {
            15: DungeonPlacement("stone"),
            17: DungeonPlacement("stone"),
        }
        mask = scene_wall_visibility_mask(placements)
        self.assertEqual(wall_slots_in_draw_order(15, mask), ())
        self.assertEqual(wall_slots_in_draw_order(17, mask), (27,))


@unittest.skipUnless(DATA_ROOT.is_dir(), "SPS 439 extracted graphics are unavailable")
class DungeonAssetTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.assets = DungeonAssets(DATA_ROOT)
        cls.background = load_floor_ceiling_background(DATA_ROOT)

    def test_every_initial_feature_renders_or_intentionally_stays_static(self) -> None:
        for feature in DUNGEON_FEATURES:
            with self.subTest(feature=feature.key):
                pixels, metadata = render_dungeon_feature(
                    self.background,
                    self.assets,
                    feature,
                    view_cell=17,
                    direction=2,
                    variant=2,
                    wood_states=(1, 2, 3, 1),
                )
                self.assertEqual(len(pixels), VIEW_HEIGHT)
                self.assertTrue(all(len(row) == VIEW_WIDTH for row in pixels))
                self.assertEqual(metadata["feature"], feature.key)
                if feature.key not in {"space", "magic"}:
                    self.assertGreater(len(metadata["operations"]), 0)

    def test_nearest_wall_components_are_built_from_two_mirrored_halves(self) -> None:
        feature = next(item for item in DUNGEON_FEATURES if item.key == "shelf")
        _, metadata = render_dungeon_feature(
            self.background,
            self.assets,
            feature,
            view_cell=17,
            direction=2,
        )
        overlays = [
            operation
            for operation in metadata["operations"]
            if operation["source"] == "Main_Shelf.gfx"
        ]
        self.assertEqual(len(overlays), 2)
        self.assertEqual([operation["mirrored"] for operation in overlays], [False, True])

    def test_closed_wood_door_adds_frame_and_door_halves(self) -> None:
        feature = next(item for item in DUNGEON_FEATURES if item.key == "wood")
        _, metadata = render_dungeon_feature(
            self.background,
            self.assets,
            feature,
            view_cell=17,
            wood_states=(0, 0, 3, 0),
        )
        sources = [operation["source"] for operation in metadata["operations"]]
        self.assertEqual(sources.count("Wooden_Wall.gfx"), 2)
        self.assertEqual(sources.count("Wooden_Doors.gfx"), 2)

    def test_stone_cell_draws_every_source_visible_side_rear_first(self) -> None:
        feature = next(item for item in DUNGEON_FEATURES if item.key == "stone")
        _, metadata = render_dungeon_feature(
            self.background,
            self.assets,
            feature,
            view_cell=18,
            direction=2,
        )
        self.assertEqual(metadata["visible_wall_slots"], [27, 23, 11])
        walls = [
            operation
            for operation in metadata["operations"]
            if operation["source"] == "Main_Walls.gfx"
        ]
        self.assertEqual(len(walls), 3)
        self.assertTrue(all(operation["mirrored"] for operation in walls))

    def test_scene_retains_independent_cell_configuration(self) -> None:
        placements = {
            3: DungeonPlacement("pillar", direction=1, variant=0),
            17: DungeonPlacement("wood", wood_states=(1, 2, 3, 0)),
        }
        pixels, metadata = render_dungeon_scene(
            self.background,
            self.assets,
            placements,
        )
        self.assertEqual(len(pixels), VIEW_HEIGHT)
        rendered = metadata["placements"]
        self.assertEqual(
            [(item["view_cell"], item["feature"]) for item in rendered],
            [(3, "pillar"), (17, "wood")],
        )

    def test_trigger_pad_and_ceiling_hole_use_the_correct_resources(self) -> None:
        pad = next(item for item in DUNGEON_FEATURES if item.key == "pad")
        ceiling = next(
            item for item in DUNGEON_FEATURES if item.key == "ceiling_pit"
        )
        _, pad_metadata = render_dungeon_feature(
            self.background,
            self.assets,
            pad,
            view_cell=17,
        )
        _, ceiling_metadata = render_dungeon_feature(
            self.background,
            self.assets,
            ceiling,
            view_cell=17,
        )
        self.assertEqual(
            [item["source"] for item in pad_metadata["operations"]],
            ["Pad_Pit_High.gfx"],
        )
        self.assertEqual(
            [item["source"] for item in ceiling_metadata["operations"]],
            ["Pad_Trigger.gfx"],
        )

    def test_floor_feature_can_coexist_with_a_ceiling_hole(self) -> None:
        pad = next(item for item in DUNGEON_FEATURES if item.key == "pad")
        _, metadata = render_dungeon_feature(
            self.background,
            self.assets,
            pad,
            view_cell=17,
            ceiling_hole=True,
        )
        self.assertEqual(
            [item["source"] for item in metadata["operations"]],
            ["Pad_Trigger.gfx", "Pad_Pit_High.gfx"],
        )

    def test_socket_and_switch_states_change_the_rendered_colours(self) -> None:
        for key in ("socket", "switch"):
            with self.subTest(feature=key):
                feature = next(item for item in DUNGEON_FEATURES if item.key == key)
                active_pixels, _ = render_dungeon_feature(
                    self.background,
                    self.assets,
                    feature,
                    view_cell=17,
                    direction=2,
                    active=True,
                )
                inactive_pixels, _ = render_dungeon_feature(
                    self.background,
                    self.assets,
                    feature,
                    view_cell=17,
                    direction=2,
                    active=False,
                )
                self.assertNotEqual(active_pixels, inactive_pixels)

    def test_large_door_state_selects_closed_or_open_artwork(self) -> None:
        door = next(item for item in DUNGEON_FEATURES if item.key == "door_metal")
        _, closed = render_dungeon_feature(
            self.background,
            self.assets,
            door,
            view_cell=17,
            active=True,
            variant=5,
        )
        _, opened = render_dungeon_feature(
            self.background,
            self.assets,
            door,
            view_cell=17,
            active=False,
            variant=5,
        )
        self.assertEqual(
            {item["source"] for item in closed["operations"]},
            {"Door_Metal.gfx"},
        )
        self.assertEqual(
            {item["source"] for item in opened["operations"]},
            {"Door_Open.gfx"},
        )

    def test_magic_locations_reuse_source_rendering_primitives(self) -> None:
        expected_sources = {
            "firepath": "Pad_Pit_High.gfx",
            "mindrock": "Main_Walls.gfx",
            "formwall": "Main_Walls.gfx",
        }
        for key, source in expected_sources.items():
            with self.subTest(feature=key):
                feature = next(item for item in DUNGEON_FEATURES if item.key == key)
                _, metadata = render_dungeon_feature(
                    self.background,
                    self.assets,
                    feature,
                    view_cell=17,
                )
                self.assertEqual(
                    {item["source"] for item in metadata["operations"]},
                    {source},
                )

    def test_editor_magic_walls_replace_only_the_requested_shades(self) -> None:
        stone = next(item for item in DUNGEON_FEATURES if item.key == "stone")
        stone_pixels, _ = render_dungeon_feature(
            self.background,
            self.assets,
            stone,
            view_cell=17,
        )
        expected_changes = {
            "formwall": {(2, 5), (3, 6)},
            "mindrock": {(1, 7), (14, 8)},
        }
        for key, expected in expected_changes.items():
            with self.subTest(feature=key):
                feature = next(item for item in DUNGEON_FEATURES if item.key == key)
                pixels, _ = render_dungeon_feature(
                    self.background,
                    self.assets,
                    feature,
                    view_cell=17,
                )
                changes = {
                    (before, after)
                    for before_row, after_row in zip(stone_pixels, pixels)
                    for before, after in zip(before_row, after_row)
                    if before != after
                }
                self.assertEqual(changes, expected)

    def test_plain_english_variant_and_state_names(self) -> None:
        socket = next(item for item in DUNGEON_FEATURES if item.key == "socket")
        sign = next(item for item in DUNGEON_FEATURES if item.key == "sign")
        door = next(item for item in DUNGEON_FEATURES if item.key == "door_metal")
        pad = next(item for item in DUNGEON_FEATURES if item.key == "pad")
        self.assertEqual(dungeon_variant_name(socket, 0), "Serpent crystal (green)")
        self.assertEqual(dungeon_variant_name(sign, 2), "Dragon sign")
        self.assertEqual(dungeon_variant_name(door, 5), "Red key")
        self.assertEqual(dungeon_state_name(socket, False), "socket empty")
        self.assertEqual(
            dungeon_state_name(pad, True, ceiling_hole=True),
            "with ceiling hole",
        )


if __name__ == "__main__":
    unittest.main()

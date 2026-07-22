from __future__ import annotations

import unittest
from pathlib import Path
from tempfile import TemporaryDirectory

from tools.map_editor.app import (
    OVERLAY_ENABLED,
    OVERLAY_NAMES,
    default_floor,
    reveal_interval_delta,
)
from tools.map_editor.first_person import (
    dungeon_pattern_parity,
    map_cell_placement,
    map_view_placements,
    move_in_view_direction,
    relative_map_coordinate,
)
from tools.map_editor.model import (
    MAP_HEADER_SIZE,
    MAP_RESOURCE_SIZE,
    MapCell,
    MapProject,
    TowerMap,
)
from tools.map_editor.render import cell_glyph, describe_cell, draw_map_cell
from tools.map_editor.semantics import apply_cell_action, controls_for_cell, default_cell
from tools.tool_common import DATA_DIR, PROJECT_ROOT


CLEAN_ROOT = DATA_DIR / "BLOODWYCH439-clean"


class MapEditorTests(unittest.TestCase):
    def test_unverified_object_and_monster_overlays_remain_disabled(self) -> None:
        enabled = dict(zip(OVERLAY_NAMES, OVERLAY_ENABLED))
        self.assertFalse(enabled["OBJECTS"])
        self.assertFalse(enabled["MONSTERS"])
        self.assertTrue(enabled["SWITCHES"])
        self.assertTrue(enabled["TRIGGERS"])

    def test_sps439_tower_header_and_cell_round_trip(self) -> None:
        source = (CLEAN_ROOT / "maps" / "mod0.map").read_bytes()
        tower = TowerMap(source, name="THE KEEP")
        self.assertEqual(len(tower.to_bytes()), MAP_RESOURCE_SIZE)
        self.assertEqual(tower.widths, (12, 21, 15, 31, 19, 4, 0, 0))
        self.assertEqual(tower.heights, (1, 21, 15, 31, 19, 5, 0, 0))
        self.assertEqual(tower.top_floor, 5)
        self.assertEqual(tower.free_map_bytes, 0)
        self.assertEqual(tower.to_bytes(), source)

        original = tower.cell(4, 0, 0)
        offset = tower.cell_offset(4, 0, 0)
        replacement = MapCell(original.first ^ 0x10, original.second)
        tower.set_cell(4, 0, 0, replacement)
        changed = tower.to_bytes()
        self.assertEqual(changed[:offset], source[:offset])
        self.assertEqual(changed[offset : offset + 2], bytes((replacement.first, replacement.second)))
        self.assertEqual(changed[offset + 2 :], source[offset + 2 :])

    def test_cell_nibbles_and_map_type_are_independent(self) -> None:
        cell = MapCell(0xAB, 0xCD)
        self.assertEqual((cell.a, cell.b, cell.c, cell.d), (0xA, 0xB, 0xC, 0xD))
        self.assertEqual(cell.map_type, 5)
        self.assertEqual(cell.replace_nibble("a", 2), MapCell(0x2B, 0xCD))
        self.assertEqual(cell.replace_type(1), MapCell(0xAB, 0xC9))

    def test_map_index_resolves_across_floor_offsets(self) -> None:
        tower = TowerMap((CLEAN_ROOT / "maps" / "mod0.map").read_bytes())
        floor = 4
        map_index = tower.data_offsets[floor] // 2 + 3 * tower.widths[floor] + 2
        self.assertEqual(tower.floor_from_map_index(map_index), (floor, 2, 3))

    def test_extracted_save_writes_only_to_modified_folder(self) -> None:
        with TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            clean = root / "BLOODWYCH439-clean"
            for stem in ("mod0", "serp", "moon", "drag", "chaos", "zendik"):
                destination = clean / "maps" / f"{stem}.map"
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_bytes((CLEAN_ROOT / "maps" / f"{stem}.map").read_bytes())
            project = MapProject.from_extracted(clean)
            clean_before = (clean / "maps" / "mod0.map").read_bytes()
            floor = default_floor(project, 0)
            original = project.maps[0].cell(floor, 0, 0)
            project.set_cell(0, floor, 0, 0, original.replace_type(original.map_type + 1))
            written = project.save()
            self.assertEqual(len(written), 1)
            self.assertEqual(written[0], root / "BLOODWYCH439-modified" / "maps" / "mod0.map")
            self.assertEqual((clean / "maps" / "mod0.map").read_bytes(), clean_before)
            self.assertNotEqual(written[0].read_bytes(), clean_before)

    def test_whdload_save_is_copied_and_modified_at_the_map_slice(self) -> None:
        with TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            clean = root / "BLOODWYCH439-clean"
            source_save = PROJECT_ROOT / "whdload" / "bloodsave0"
            save_copy = root / "bloodsave0"
            original_save = source_save.read_bytes()
            save_copy.write_bytes(original_save)
            project = MapProject.from_savegame(clean, save_copy)
            floor = default_floor(project, 0)
            original = project.maps[0].cell(floor, 0, 0)
            project.set_cell(0, floor, 0, 0, original.replace_nibble("a", original.a + 1))
            written = project.save()
            self.assertEqual(written, (root / "BLOODWYCH439-modified" / "whdload" / "bloodsave0",))
            modified_save = written[0].read_bytes()
            self.assertEqual(len(modified_save), len(original_save))
            self.assertEqual(save_copy.read_bytes(), original_save)
            differences = [
                index
                for index, (before, after) in enumerate(zip(original_save, modified_save))
                if before != after
            ]
            self.assertEqual(len(differences), 1)

    def test_real_overlay_records_are_decoded(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)
        self.assertEqual(len(project.switches(0)), 16)
        self.assertEqual(len(project.triggers(0)), 32)
        self.assertEqual(len(project.monsters(0)), 72)
        self.assertGreater(len(project.object_stacks(0)), 100)
        self.assertIn("WOOD", describe_cell(MapCell(0x33, 0x02)))

    def test_shared_switch_edit_writes_a_named_modified_resource(self) -> None:
        with TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            clean = root / "BLOODWYCH439-clean"
            for stem in ("mod0", "serp", "moon", "drag", "chaos", "zendik"):
                destination = clean / "maps" / f"{stem}.map"
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_bytes((CLEAN_ROOT / "maps" / f"{stem}.map").read_bytes())
            switch_source = CLEAN_ROOT / "maps" / "mod0.switches"
            switch_destination = clean / "maps" / "mod0.switches"
            switch_destination.write_bytes(switch_source.read_bytes())
            project = MapProject.from_extracted(clean)
            original = project.switches(0)[1]
            changed = project.set_switch(0, 1, x=(original.x + 1) & 0xFF)
            self.assertNotEqual(changed.x, original.x)
            written = project.save()
            self.assertEqual(written, (root / "BLOODWYCH439-modified" / "maps" / "mod0.switches",))
            self.assertEqual(switch_source.read_bytes(), switch_destination.read_bytes())
            self.assertEqual(written[0].read_bytes()[6], changed.x)

    def test_save_overlay_rejects_edits_to_tables_not_contained_in_save(self) -> None:
        project = MapProject.from_savegame(CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave0")
        with self.assertRaisesRegex(ValueError, "cannot be edited"):
            project.set_switch(0, 1, x=3)

    def test_header_size_matches_amos_layout(self) -> None:
        self.assertEqual(MAP_HEADER_SIZE, 0x38)

    def test_original_map_font_glyphs_are_reserved_for_map_meaning(self) -> None:
        self.assertEqual(cell_glyph(MapCell(0x00, 0x03)), ("B", 0))
        self.assertEqual(cell_glyph(MapCell(0x00, 0x06)), ("F", 8))
        self.assertEqual(cell_glyph(MapCell(0x01, 0x03)), None)

    def test_semantic_type_change_uses_valid_visible_defaults(self) -> None:
        for map_type in range(8):
            cell = default_cell(map_type)
            self.assertEqual(cell.map_type, map_type)
        self.assertEqual(apply_cell_action(MapCell(0, 0), "TYPE+"), default_cell(1))

    def test_semantic_wood_controls_cycle_each_side_independently(self) -> None:
        cell = MapCell(0x00, 0x02)
        north = apply_cell_action(cell, "WOOD-N")
        east = apply_cell_action(north, "WOOD-E")
        self.assertEqual(north.first, 0x01)
        self.assertEqual(east.first, 0x05)
        labels = tuple(control.label for control in controls_for_cell(east))
        self.assertIn("N: WALL", labels)
        self.assertIn("E: WALL", labels)

    def test_semantic_pad_separates_floor_and_ceiling_hole(self) -> None:
        pad = MapCell(0x0A, 0x06)
        ceiling_pad = apply_cell_action(pad, "CEILING")
        self.assertEqual(ceiling_pad.b & 3, 2)
        self.assertTrue(ceiling_pad.b & 4)
        self.assertEqual(ceiling_pad.first // 8, pad.first // 8)

    def test_semantic_stairs_preserve_height_while_rotating(self) -> None:
        north_down = MapCell(1, 0x04)
        east_down = apply_cell_action(north_down, "DIRECTION+")
        east_up = apply_cell_action(east_down, "ELEVATION")
        self.assertEqual(east_down.b, 3)
        self.assertEqual(east_up.b, 2)

    def test_cursor_follow_uses_smallest_viewport_translation(self) -> None:
        self.assertEqual(reveal_interval_delta(20, 36, 0, 64), 0)
        self.assertEqual(reveal_interval_delta(-16, 0, 0, 64), 16)
        self.assertEqual(reveal_interval_delta(64, 80, 0, 64), -16)

    def test_first_person_coordinates_rotate_with_player_facing(self) -> None:
        self.assertEqual(relative_map_coordinate(10, 10, 0, 1, 2), (11, 8))
        self.assertEqual(relative_map_coordinate(10, 10, 1, 1, 2), (12, 11))
        self.assertEqual(move_in_view_direction(10, 10, 2, forward=1), (10, 11))
        self.assertEqual(move_in_view_direction(10, 10, 3, lateral=-1), (10, 11))

    def test_dungeon_pattern_alternates_on_each_step_and_quarter_turn(self) -> None:
        initial = dungeon_pattern_parity(10, 10, 0)
        self.assertNotEqual(dungeon_pattern_parity(11, 10, 0), initial)
        self.assertNotEqual(dungeon_pattern_parity(10, 11, 0), initial)
        self.assertNotEqual(dungeon_pattern_parity(10, 10, 1), initial)
        self.assertEqual(dungeon_pattern_parity(10, 10, 2), initial)

    def test_map_cell_to_dungeon_placement_preserves_directional_wood(self) -> None:
        north_wall = MapCell(0x01, 0x02)
        north_view = map_cell_placement(north_wall, 0)
        east_view = map_cell_placement(north_wall, 1)
        self.assertIsNotNone(north_view)
        self.assertIsNotNone(east_view)
        assert north_view is not None and east_view is not None
        self.assertEqual(north_view.wood_states, (1, 0, 0, 0))
        self.assertEqual(east_view.wood_states, (0, 0, 0, 1))

    def test_location_derived_switch_and_generated_sign_colours_match_source(self) -> None:
        null_switch = map_cell_placement(MapCell(0x02, 0x81), 0, map_x=4, map_y=5)
        switch = map_cell_placement(MapCell(0x0A, 0x81), 0, map_x=4, map_y=5)
        sign = map_cell_placement(MapCell(0x01, 0x81), 0, map_x=4, map_y=5)
        assert null_switch is not None and switch is not None and sign is not None
        self.assertEqual(null_switch.colour_variant, -1)
        self.assertEqual(switch.colour_variant, 1)
        self.assertEqual(sign.colour_variant, 1)
        self.assertEqual(sign.overlay_variant, 3)

    def test_void_and_ordinary_door_lock_masks_are_distinguished(self) -> None:
        ordinary = map_cell_placement(MapCell(0x06, 0x05), 0)
        void = map_cell_placement(MapCell(0x0F, 0x05), 0)
        assert ordinary is not None and void is not None
        self.assertEqual(ordinary.colour_variant, 0)
        self.assertEqual(void.colour_variant, -1)

    def test_amos_map_icons_use_the_inset_15_by_7_drawable_area(self) -> None:
        try:
            import pygame
        except ImportError:
            self.skipTest("pygame is not installed")
        pygame.init()
        try:
            from tools.st_planar_assets import GAME_PALETTE_RGB8

            shelf_surface = pygame.Surface((16, 16))
            draw_map_cell(shelf_surface, shelf_surface.get_rect(), MapCell(0x00, 0x81))
            self.assertEqual(shelf_surface.get_at((3, 2))[:3], GAME_PALETTE_RGB8[9])
            self.assertEqual(shelf_surface.get_at((2, 2))[:3], GAME_PALETTE_RGB8[4])
            self.assertEqual(shelf_surface.get_at((3, 10))[:3], GAME_PALETTE_RGB8[4])

            pad_surface = pygame.Surface((16, 16))
            draw_map_cell(pad_surface, pad_surface.get_rect(), MapCell(0x02, 0x06))
            green = GAME_PALETTE_RGB8[6]
            green_pixels = sum(
                pad_surface.get_at((x, y))[:3] == green
                for y in range(16)
                for x in range(16)
            )
            self.assertEqual(green_pixels, 11 * 10)
        finally:
            pygame.quit()

    def test_outside_map_view_cells_are_sealed_with_stone(self) -> None:
        tower = TowerMap((CLEAN_ROOT / "maps" / "mod0.map").read_bytes())
        placements = map_view_placements(tower, 3, 0, 0, 0)
        forward_cells = tuple(index for index in range(18) if index not in (6, 13))
        self.assertTrue(all(placements[index].feature_key == "stone" for index in forward_cells))

    def test_current_map_cell_is_included_for_inside_graphics(self) -> None:
        tower = TowerMap((CLEAN_ROOT / "maps" / "mod0.map").read_bytes())
        tower.set_cell(3, 10, 10, MapCell(0x01, 0x02))
        placements = map_view_placements(tower, 3, 10, 10, 0)
        self.assertIn(18, placements)
        self.assertEqual(placements[18].feature_key, "wood")
        self.assertEqual(placements[18].wood_states, (1, 0, 0, 0))


if __name__ == "__main__":
    unittest.main()

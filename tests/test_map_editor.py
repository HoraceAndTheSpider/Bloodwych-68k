from __future__ import annotations

import unittest
from pathlib import Path
from tempfile import TemporaryDirectory

from tools.map_editor.app import (
    OVERLAY_DEFAULTS,
    EDITOR_TAB_ENABLED,
    OVERLAY_ENABLED,
    OVERLAY_NAMES,
    adjustment_repeat_due,
    champion_preview_body_design,
    champion_occupant_record,
    crop_indexed_pixels,
    default_floor,
    integer_preview_scale,
    monster_renderer_key,
    nearest_rectangle_edges,
    MONSTER_DESIGN_PREVIEW_DISTANCES,
    reveal_interval_delta,
)
from tools.map_editor.actor_editor import (
    champion_edit_allowed,
    cycle_monster_index,
    indexed_action_value,
    monster_form_name,
    monster_indices_at_cell,
    monster_teams,
)
from tools.map_editor.first_person import (
    dungeon_pattern_parity,
    map_cell_placement,
    map_view_placements,
    move_in_view_direction,
    occupant_relative_facing,
    relative_map_coordinate,
    occupant_view_position,
)
from tools.map_editor.floor_objects import (
    object_stack_location,
    relocate_object_stack,
)
from tools.map_editor.model import (
    MAP_HEADER_SIZE,
    MAP_RESOURCE_SIZE,
    MapCell,
    MapProject,
    MonsterRecord,
    ObjectStack,
    TowerMap,
    resolve_contiguous_reference,
)
from tools.map_editor.layout import (
    elevation_alignment_issues,
    is_layout_elevation_cell,
    stair_alignment_links,
)
from tools.map_editor.render import (
    cell_glyph,
    describe_cell,
    draw_map_cell,
    layout_icon_surface,
)
from tools.map_editor.semantics import (
    adjust_trigger_parameter,
    apply_cell_action,
    controls_for_cell,
    default_cell,
    editor_rows_for_cell,
    trigger_parameter_label,
)
from tools.tool_common import DATA_DIR, PROJECT_ROOT


CLEAN_ROOT = DATA_DIR / "BLOODWYCH439-clean"


class MapEditorTests(unittest.TestCase):
    def test_parties_use_their_shared_player_facing(self) -> None:
        quickstart = MapProject.from_extracted(CLEAN_ROOT)
        saved = MapProject.from_savegame(
            CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave0"
        )

        self.assertEqual(
            tuple(party.facing for party in quickstart.player_parties(0)), (0, 0)
        )
        self.assertEqual(
            tuple(party.facing for party in saved.player_parties(0)), (1, 0)
        )

    def test_actor_overlays_and_object_editor_are_enabled(self) -> None:
        enabled = dict(zip(OVERLAY_NAMES, OVERLAY_ENABLED))
        self.assertTrue(enabled["OBJECTS"])
        self.assertTrue(enabled["CHAMPIONS"])
        self.assertTrue(enabled["MONSTERS"])
        self.assertTrue(enabled["SPELLS"])
        self.assertTrue(enabled["PLAYERS"])
        self.assertTrue(enabled["QS TEAMS"])
        self.assertTrue(enabled["SWITCHES"])
        self.assertTrue(enabled["TRIGGERS"])
        self.assertTrue(enabled["LINKS"])
        self.assertTrue(all(not default for default in OVERLAY_DEFAULTS))
        self.assertTrue(EDITOR_TAB_ENABLED[2])
        self.assertTrue(EDITOR_TAB_ENABLED[3])
        self.assertTrue(EDITOR_TAB_ENABLED[4])

    def test_character_edit_boundary_matches_game_and_active_save_tower(self) -> None:
        self.assertTrue(champion_edit_allowed(has_save=False, selected_tower=0, active_tower=None))
        self.assertFalse(champion_edit_allowed(has_save=False, selected_tower=1, active_tower=None))
        self.assertTrue(champion_edit_allowed(has_save=True, selected_tower=3, active_tower=3))
        self.assertFalse(champion_edit_allowed(has_save=True, selected_tower=0, active_tower=3))

    def test_indexed_actor_actions_exclude_the_trailing_direction(self) -> None:
        self.assertEqual(indexed_action_value("SPELL-1+", "SPELL-"), 1)
        self.assertEqual(indexed_action_value("SPELL-31-", "SPELL-"), 31)
        with self.assertRaises(ValueError):
            indexed_action_value("SPELL-PAGE+", "SPELL-")

    def test_actor_preview_crop_removes_only_the_empty_canvas(self) -> None:
        pixels = ((0, 0, 0, 0), (0, 2, 3, 0), (0, 4, 0, 0))
        self.assertEqual(crop_indexed_pixels(pixels), ((2, 3), (4, 0)))

    def test_actor_preview_uses_one_bounded_integer_scale(self) -> None:
        self.assertEqual(integer_preview_scale((25, 47), (210, 148)), 3)
        self.assertEqual(integer_preview_scale((80, 80), (210, 148)), 1)

    def test_monster_designer_shows_five_representative_depths_together(self) -> None:
        self.assertEqual(MONSTER_DESIGN_PREVIEW_DISTANCES, (0, 1, 2, 4, 5))
        self.assertNotIn(3, MONSTER_DESIGN_PREVIEW_DISTANCES)

    def test_held_adjustments_wait_then_repeat_at_a_readable_rate(self) -> None:
        self.assertFalse(adjustment_repeat_due(449, 0, 0))
        self.assertTrue(adjustment_repeat_due(450, 0, 0))
        self.assertFalse(adjustment_repeat_due(559, 0, 450))
        self.assertTrue(adjustment_repeat_due(560, 0, 450))

    def test_champion_preview_applies_worn_body_armour(self) -> None:
        assets = type("Assets", (), {"body_design": lambda _self, _champion: 2})()
        pockets = bytes((0, 0, 0x1B))
        self.assertEqual(champion_preview_body_design(assets, 0, pockets), 5)

    def test_monster_map_selection_cycles_resolved_team_members(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)
        records = project.render_occupants(0)
        lead = records[11]
        candidates = monster_indices_at_cell(records, lead.floor, lead.x, lead.y)
        self.assertEqual(candidates[:2], (11, 12))
        self.assertEqual(cycle_monster_index(candidates, 11), 12)
        self.assertEqual(cycle_monster_index(candidates, 12), 11)

    def test_monster_team_editor_populates_the_deeper_four_slot_list(self) -> None:
        with TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            clean = root / "BLOODWYCH439-clean"
            for source in CLEAN_ROOT.rglob("*"):
                if source.is_file() and (
                    source.name.endswith((".map", ".monsters", ".monstercount"))
                    or source.name in ("champions.stats", "champions.pockets")
                ):
                    destination = clean / source.relative_to(CLEAN_ROOT)
                    destination.parent.mkdir(parents=True, exist_ok=True)
                    destination.write_bytes(source.read_bytes())
            project = MapProject.from_extracted(clean)
            records = project.monsters(0)
            solo_index = next(
                index for index in range(1, len(records))
                if records[index - 1].team == records[index].team == 0xFF
                and records[index - 1].has_position
            )
            project.join_monster_to_previous_team(0, solo_index)
            joined = project.monsters(0)
            group = joined[solo_index - 1].team >> 2
            team = next(team for team in monster_teams(joined) if team.group == group)
            self.assertEqual(team.members[:2], (solo_index - 1, solo_index))
            self.assertEqual(joined[solo_index].x, 0x7F)
            self.assertFalse(joined[solo_index].has_position)

            remaining = [
                member.index
                for member in joined
                if member.team == 0xFF and member.has_position and member.form < 0x67
            ]
            selected, target = remaining[0], remaining[-1]
            previous_groups = {team.group for team in monster_teams(joined)}
            retargeted = project.join_monster_to_team(0, selected, target)
            new_team = next(
                team
                for team in monster_teams(retargeted)
                if team.group not in previous_groups
            )
            new_members = [member for member in new_team.members if member is not None]
            self.assertEqual(len(new_members), 2)
            self.assertEqual(new_members[1], new_members[0] + 1)

            large = next(
                member.index
                for member in retargeted
                if member.team == 0xFF and member.has_position
            )
            project.set_packed_monster(0, large, form=0x67)
            with self.assertRaisesRegex(ValueError, "large monster"):
                project.join_monster_to_team(0, large, new_members[0])

    def test_source_form_labels_do_not_invent_humanoid_names(self) -> None:
        self.assertEqual(monster_form_name(0x69), "LARGE DRAGON")
        self.assertEqual(monster_form_name(0x20), "CHARACTER FORM $20")

    def test_champion_and_shared_character_design_edits_use_extracted_resources(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)
        before = project.champion_record_bytes(0)
        project.set_champion_byte(0, 0, 1, (before[1] + 1) % 100)
        self.assertEqual(project.champion_record_bytes(0)[1], (before[1] + 1) % 100)
        with self.assertRaisesRegex(ValueError, "mod0"):
            project.set_champion_byte(1, 0, 1, 1)

        head, body, palettes = project.character_design(0)
        project.set_character_design(0, head=(head + 1) % 18)
        project.set_character_design(0, colour_group=2, colour_slot=1, ink=7)
        changed_head, changed_body, changed_palettes = project.character_design(0)
        self.assertEqual(changed_head, (head + 1) % 18)
        self.assertEqual(changed_body, body)
        self.assertEqual(changed_palettes[2][1], 7)
        self.assertNotEqual(palettes, changed_palettes)

    def test_save_champion_editing_tracks_the_active_tower(self) -> None:
        project = MapProject.from_savegame(
            CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave6"
        )
        self.assertEqual(project.current_tower, 3)
        before = project.champion_record_bytes(0)[1]
        project.set_champion_byte(3, 0, 1, (before + 1) & 0xFF)
        self.assertTrue(project.has_changes)
        self.assertEqual(project.champion_record_bytes(0)[1], (before + 1) & 0xFF)
        with self.assertRaisesRegex(ValueError, "active save tower"):
            project.set_champion_byte(0, 0, 1, 0)

    def test_active_live_monsters_are_read_only_but_other_save_towers_are_packed(self) -> None:
        project = MapProject.from_savegame(
            CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave0"
        )
        with self.assertRaisesRegex(ValueError, "live monster"):
            project.set_packed_monster(0, 0, level=1)
        before = project.monsters(1)[0]
        changed = project.set_packed_monster(1, 0, level=(before.level + 1) & 0x7F)
        self.assertEqual(changed.level, (before.level + 1) & 0x7F)
        self.assertTrue(project.has_changes)

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

    def test_original_special_geometry_resolves_to_a_floor(self) -> None:
        expected = {
            "mod0": 1,
            "serp": 3,
            "moon": 3,
            "drag": 7,
            "chaos": 5,
            "zendik": 4,
        }
        for stem, floor in expected.items():
            tower = TowerMap((CLEAN_ROOT / "maps" / f"{stem}.map").read_bytes())
            self.assertEqual(tower.special_floor_index, floor)

    def test_floor_resize_repacks_later_floors_and_preserves_coordinates(self) -> None:
        data = bytearray(MAP_RESOURCE_SIZE)
        tower = TowerMap(data)
        tower.set_floor_dimensions(0, 2, 2)
        tower.set_floor_dimensions(1, 2, 2)
        tower.set_cell(0, 1, 1, MapCell(0x11, 0x01))
        tower.set_cell(1, 1, 1, MapCell(0x22, 0x02))

        tower.set_floor_dimensions(0, 3, 2)

        self.assertEqual(tower.data_offsets[:3], (0, 12, 20))
        self.assertEqual(tower.cell(0, 1, 1), MapCell(0x11, 0x01))
        self.assertEqual(tower.cell(0, 2, 1), MapCell(0, 0))
        self.assertEqual(tower.cell(1, 1, 1), MapCell(0x22, 0x02))
        self.assertEqual(tower.special_floor_index, 0)

    def test_clear_floor_keeps_geometry_and_other_floors(self) -> None:
        tower = TowerMap(bytearray(MAP_RESOURCE_SIZE))
        tower.set_floor_dimensions(0, 2, 2)
        tower.set_floor_dimensions(1, 2, 2)
        tower.set_floor_alignment(0, 3, 4)
        tower.set_cell(0, 1, 1, MapCell(0x11, 0x01))
        tower.set_cell(1, 1, 1, MapCell(0x22, 0x02))
        geometry = (
            tower.widths,
            tower.heights,
            tower.data_offsets,
            tower.x_offsets,
            tower.y_offsets,
        )

        tower.clear_floor(0)

        self.assertEqual(
            [tower.cell(0, x, y) for y in range(2) for x in range(2)],
            [MapCell(0, 0)] * 4,
        )
        self.assertEqual(tower.cell(1, 1, 1), MapCell(0x22, 0x02))
        self.assertEqual(
            (
                tower.widths,
                tower.heights,
                tower.data_offsets,
                tower.x_offsets,
                tower.y_offsets,
            ),
            geometry,
        )

    def test_project_floor_resize_moves_object_indices_with_later_floors(self) -> None:
        with TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            clean = root / "BLOODWYCH439-clean"
            maps = []
            for index, stem in enumerate(("mod0", "serp", "moon", "drag", "chaos", "zendik")):
                tower = TowerMap(bytearray(MAP_RESOURCE_SIZE))
                tower.set_floor_dimensions(0, 2, 2)
                tower.set_floor_dimensions(1, 2, 2)
                maps.append(tower)
                map_path = clean / "maps" / f"{stem}.map"
                map_path.parent.mkdir(parents=True, exist_ok=True)
                map_path.write_bytes(tower.to_bytes())
                object_data = bytearray(0x402)
                if index == 0:
                    map_index = tower.map_index(1, 1, 1)
                    object_data[:7] = (
                        (5).to_bytes(2, "big")
                        + map_index.to_bytes(2, "big")
                        + bytes((0, 1, 1))
                    )
                (clean / "maps" / f"{stem}.obj").write_bytes(object_data)

            project = MapProject.from_extracted(clean)
            self.assertEqual(
                object_stack_location(project.maps[0], project.object_stacks(0)[0]),
                (1, 1, 1),
            )
            project.set_floor_dimensions(0, 0, 3, 2)
            moved = project.object_stacks(0)[0]
            self.assertEqual(object_stack_location(project.maps[0], moved), (1, 1, 1))
            self.assertEqual(moved.map_index, 18)

    def test_floor_resize_rejects_cell_data_beyond_fixed_map_capacity(self) -> None:
        tower = TowerMap(bytearray(MAP_RESOURCE_SIZE))
        for floor in range(6):
            tower.set_floor_dimensions(floor, 18, 18)
        with self.assertRaisesRegex(ValueError, "fixed resource"):
            tower.set_floor_dimensions(6, 18, 18)

    def test_layout_filter_and_elevation_alignment_follow_game_movement(self) -> None:
        tower = TowerMap(bytearray(MAP_RESOURCE_SIZE))
        tower.set_floor_dimensions(0, 6, 6)
        tower.set_floor_dimensions(1, 6, 6)
        # Up/North stairs are entered while moving South and arrive two cells
        # South on matching Down/South stairs on the floor above.
        tower.set_cell(0, 2, 1, MapCell(0x00, 0x04))
        tower.set_cell(1, 2, 3, MapCell(0x05, 0x04))
        tower.set_cell(1, 4, 2, MapCell(0x01, 0x06))
        tower.set_cell(0, 4, 2, MapCell(0x04, 0x06))

        self.assertTrue(is_layout_elevation_cell(tower.cell(0, 2, 1)))
        self.assertTrue(is_layout_elevation_cell(tower.cell(1, 4, 2)))
        self.assertEqual(elevation_alignment_issues(tower), ())
        links = stair_alignment_links(tower)
        self.assertEqual(len(links), 1)
        self.assertEqual(
            (
                links[0].floor,
                links[0].x,
                links[0].y,
                links[0].target_floor,
                links[0].target_x,
                links[0].target_y,
            ),
            (0, 2, 1, 1, 2, 3),
        )

        tower.set_floor_alignment(1, 1, 0)
        issues = elevation_alignment_issues(tower)
        self.assertEqual(
            {(issue.floor, issue.x, issue.y) for issue in issues},
            {(0, 2, 1), (1, 2, 3), (0, 4, 2), (1, 4, 2)},
        )
        self.assertEqual(stair_alignment_links(tower), ())

    def test_floor_with_cells_outside_the_resource_is_unavailable(self) -> None:
        data = bytearray(MAP_RESOURCE_SIZE)
        data[0] = data[8] = 1
        data[16:18] = (MAP_RESOURCE_SIZE).to_bytes(2, "big")
        tower = TowerMap(data)

        self.assertFalse(tower.floor_exists(0))

    def test_cell_nibbles_and_map_type_are_independent(self) -> None:
        cell = MapCell(0xAB, 0xCD)
        self.assertEqual((cell.a, cell.b, cell.c, cell.d), (0xA, 0xB, 0xC, 0xD))
        self.assertEqual(cell.map_type, 5)
        self.assertEqual(cell.replace_nibble("a", 2), MapCell(0x2B, 0xCD))
        self.assertEqual(cell.replace_type(1), MapCell(0xAB, 0xC9))

    def test_map_index_resolves_across_floor_offsets(self) -> None:
        tower = TowerMap((CLEAN_ROOT / "maps" / "mod0.map").read_bytes())
        floor = 4
        map_index = tower.data_offsets[floor] + 2 * (3 * tower.widths[floor] + 2)
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

    def test_save_object_resource_edit_is_written_into_the_save_copy(self) -> None:
        with TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            source_save = PROJECT_ROOT / "whdload" / "bloodsave0"
            save_copy = root / "bloodsave0"
            original_save = source_save.read_bytes()
            save_copy.write_bytes(original_save)
            project = MapProject.from_savegame(root / "BLOODWYCH439-clean", save_copy)

            self.assertTrue(project.resource_is_editable("maps/mod0.obj"))
            self.assertFalse(project.resource_is_editable("maps/mod0.switches"))
            stacks = list(project.object_stacks(0))
            first = stacks[0]
            code, quantity = first.items[0]
            replacement = 1 if quantity == 0xFF else quantity + 1
            stacks[0] = ObjectStack(
                first.position,
                first.map_index,
                ((code, replacement),) + first.items[1:],
            )
            project.set_object_stacks(0, stacks)

            written = project.save()
            self.assertEqual(
                written,
                (root / "BLOODWYCH439-modified" / "whdload" / "bloodsave0",),
            )
            self.assertEqual(save_copy.read_bytes(), original_save)
            self.assertNotEqual(written[0].read_bytes(), original_save)

    def test_save_spell_practice_round_trips_as_runtime_data(self) -> None:
        project = MapProject.from_savegame(
            CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave0"
        )
        before = project.spell_practice(0, 1)
        self.assertIsNotNone(before)
        project.set_spell_practice(0, 0, 1, (before + 1) & 0xFF)
        self.assertEqual(project.spell_practice(0, 1), (before + 1) & 0xFF)
        self.assertTrue(project.has_changes)
        with self.assertRaisesRegex(ValueError, "active save tower"):
            project.set_spell_practice(1, 0, 1, 0)

    def test_invalid_saved_chaos_map_falls_back_to_the_clean_map(self) -> None:
        project = MapProject.from_savegame(CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave6")

        self.assertEqual(project.maps[4].to_bytes(), (CLEAN_ROOT / "maps" / "chaos.map").read_bytes())
        self.assertEqual(project.save_map_fallbacks, frozenset((4,)))
        self.assertIn("CLEAN CHAOS TOWER", project.source_description)
        with self.assertRaisesRegex(ValueError, "cannot be edited"):
            project.set_cell(4, 0, 0, 0, MapCell(0, 0))

    def test_real_overlay_records_are_decoded(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)
        self.assertEqual(len(project.switches(0)), 16)
        self.assertEqual(len(project.triggers(0)), 32)
        self.assertEqual(len(project.monsters(0)), 73)
        self.assertGreater(len(project.object_stacks(0)), 100)
        self.assertIn("WOOD", describe_cell(MapCell(0x33, 0x02)))

    def test_overflowing_switch_reference_borrows_from_the_next_tower(self) -> None:
        lengths = (16, 16, 16, 16, 16, 16)
        self.assertEqual(resolve_contiguous_reference(0, 15, lengths), (0, 15))
        self.assertEqual(resolve_contiguous_reference(0, 16, lengths), (1, 0))
        self.assertEqual(resolve_contiguous_reference(4, 31, lengths), (5, 15))
        self.assertIsNone(resolve_contiguous_reference(5, 16, lengths))

    def test_save_uses_live_actors_only_for_the_current_tower(self) -> None:
        project = MapProject.from_savegame(CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave0")

        self.assertEqual(project.current_tower, 0)
        self.assertEqual(len(project.live_monsters()), 73)
        self.assertEqual(len(project.occupants(0)), 73)
        self.assertTrue(all(record.source == "live" for record in project.occupants(0)))
        self.assertTrue(all(record.source == "packed" for record in project.occupants(1)))
        first = project.occupants(0)[0]
        self.assertEqual((first.x, first.y, first.floor, first.form), (0x0B, 0x0F, 3, 0x15))
        self.assertEqual(
            tuple((record.index, record.x, record.y, record.floor) for record in project.players(0)),
            ((0, 1, 29, 3), (1, 7, 19, 3)),
        )
        self.assertEqual(
            tuple(
                (party.index, party.champions, party.facing)
                for party in project.player_parties(0)
            ),
            ((0, (13,), 1), (1, (14,), 0)),
        )
        self.assertEqual(len(project.champions(0)), 14)
        self.assertTrue(all(record.floor == 3 for record in project.champions(0)))
        self.assertEqual(project.champions(1), ())
        self.assertEqual(project.champion_direction(0), 2)

    def test_team_followers_share_the_lead_location_for_the_3d_renderer(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)

        packed = project.occupants(0)
        rendered = project.render_occupants(0)
        # Packed team $00/$01: the second member retains the $FF map-marker
        # sentinel but Draw_DungeonCellOccupants renders it with member $00.
        self.assertFalse(packed[12].has_position)
        self.assertTrue(rendered[12].has_position)
        self.assertEqual(
            (rendered[12].x, rendered[12].y, rendered[12].floor),
            (packed[11].x, packed[11].y, packed[11].floor),
        )
        self.assertEqual((rendered[11].formation_slot, rendered[12].formation_slot), (0, 1))

        saved = MapProject.from_savegame(CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave0")
        live = saved.occupants(0)
        live_rendered = saved.render_occupants(0)
        self.assertFalse(live[12].has_position)
        self.assertTrue(live_rendered[12].has_position)
        self.assertEqual(
            (live_rendered[12].x, live_rendered[12].y, live_rendered[12].floor),
            (live[11].x, live[11].y, live[11].floor),
        )

    def test_one_player_save_omits_the_second_player_marker(self) -> None:
        project = MapProject.from_savegame(CLEAN_ROOT, PROJECT_ROOT / "whdload" / "bloodsave6")

        self.assertEqual(project.current_tower, 3)
        self.assertEqual(len(project.live_monsters()), 31)
        self.assertEqual(tuple(record.index for record in project.players(3)), (0,))
        self.assertEqual(project.player_parties(3)[0].champions, (2, 8, 1, 11))

    def test_no_save_overlay_exposes_both_quickstart_teams_as_q_markers(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)

        self.assertEqual(
            tuple(
                (party.index, party.x, party.y, party.floor, party.champions)
                for party in project.player_parties(0)
            ),
            (
                (0, 12, 23, 3, (0, 14, 5, 3)),
                (1, 14, 23, 3, (4, 6, 13, 15)),
            ),
        )
        self.assertEqual(project.player_parties(1), ())

    def test_raw_champion_view_switches_between_quickstart_and_original_positions(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)

        originals = project.viewer_champions(0, quickstart_teams=False)
        quickstart = project.viewer_champions(0, quickstart_teams=True)
        self.assertEqual(len(originals), 16)
        self.assertEqual(len(quickstart), 16)
        original_by_id = {record.index: record for record in originals}
        quickstart_by_id = {record.index: record for record in quickstart}
        self.assertEqual(
            tuple((quickstart_by_id[index].x, quickstart_by_id[index].y) for index in (0, 14, 5, 3)),
            ((12, 23),) * 4,
        )
        self.assertEqual(
            tuple((quickstart_by_id[index].x, quickstart_by_id[index].y) for index in (4, 6, 13, 15)),
            ((14, 23),) * 4,
        )
        self.assertEqual(
            (original_by_id[0].x, original_by_id[0].y),
            (7, 9),
        )
        self.assertEqual(
            tuple(
                (original_by_id[index].facing, original_by_id[index].formation_slot)
                for index in range(3)
            ),
            # Champion byte $18 is $02, $01, $00: low bits are direction;
            # bits 4-5 place all three in the same authored floor mini-space.
            ((2, 0), (1, 0), (0, 0)),
        )
        blodwyn = champion_occupant_record(original_by_id[0])
        self.assertEqual((blodwyn.facing, blodwyn.formation_slot), (2, 0))
        self.assertEqual(
            occupant_view_position(
                blodwyn,
                player_x=blodwyn.x,
                player_y=blodwyn.y + 1,
                player_facing=0,
                formation_index=blodwyn.formation_slot,
            ),
            (17, 2),
        )
        self.assertEqual(project.viewer_champions(1), ())
        self.assertEqual(project.champion_direction(0), 2)

    def test_large_monster_grade_uses_renderer_base_and_illusion_uses_level_flag(self) -> None:
        crab = MonsterRecord(0, 0, 3, 0, 0, 2, 0x68, 0)
        summon = MonsterRecord(1, 0, 3, 0, 0, 2, 0x65, 0)
        illusion = MonsterRecord(2, 0, 3, 0, 0, 0x82, 0x64, 0)

        self.assertEqual(crab.colour_grade_step, 0)
        self.assertEqual(summon.colour_grade_step, 0)
        self.assertFalse(summon.is_illusion)
        self.assertTrue(illusion.is_illusion)

    def test_end_game_dragon_uses_the_final_available_colour_grade(self) -> None:
        """The shared DragonAssets key must not force large dragons to grade 0."""

        project = MapProject.from_extracted(CLEAN_ROOT)
        dragon = project.monsters(5)[64]

        self.assertEqual((dragon.form, dragon.level, dragon.colour_grade_step), (0x69, 20, 11))
        self.assertEqual(monster_renderer_key("dragon_large"), "dragon")
        self.assertEqual(monster_renderer_key("dragon_small"), "dragon")

    def test_first_person_occupant_position_uses_source_view_cells(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)
        occupant = project.monsters(0)[0]
        self.assertEqual(
            occupant_view_position(
                occupant,
                player_x=occupant.x,
                player_y=occupant.y + 1,
                player_facing=0,
                formation_index=0,
            ),
            # Form $15 is one of the source's forced-centre forms.
            (17, 4),
        )

    def test_live_actor_state_controls_mini_space_and_relative_facing(self) -> None:
        actor = MonsterRecord(0, 0, 3, 6, 6, 0, 0x12, 0xFF, source="live", facing=0x23)
        self.assertEqual(
            occupant_view_position(
                actor,
                player_x=6,
                player_y=7,
                player_facing=0,
                formation_index=0,
            ),
            (17, 0),
        )
        self.assertEqual(occupant_relative_facing(actor, 0), 1)
        self.assertEqual(occupant_relative_facing(actor, 1), 0)

    def test_champion_direction_is_not_interpreted_as_monster_runtime_state(self) -> None:
        champion = MonsterRecord(
            0, 0, 3, 6, 6, 0, 0, 0xFF,
            source="champion",
            facing=3,
        )
        self.assertEqual(occupant_relative_facing(champion, 0), 1)
        self.assertEqual(occupant_relative_facing(champion, 1), 0)

    def test_champion_directions_use_the_source_character_artwork_indices(self) -> None:
        """adrCd00A6F6 converts direction bits to character table indices."""

        self.assertEqual(
            [
                occupant_relative_facing(
                    MonsterRecord(0, 0, 3, 0, 0, 0, 0, 0xFF, source="champion", facing=facing),
                    0,
                )
                for facing in range(4)
            ],
            [2, 3, 0, 1],
        )

    def test_quickstart_team_heading_uses_the_north_facing_preview_art(self) -> None:
        member = MonsterRecord(
            0, 0, 3, 0, 0, 0, 0, 0xFF, source="quickstart", facing=0
        )
        self.assertEqual(occupant_relative_facing(member, 0), 2)
        self.assertEqual(occupant_relative_facing(member, 1), 1)

    def test_link_segment_meets_the_nearest_cell_edges(self) -> None:
        self.assertEqual(
            nearest_rectangle_edges((10, 10, 16, 16), (42, 18, 16, 16)),
            ((25, 18), (42, 26)),
        )
        self.assertEqual(
            nearest_rectangle_edges((10, 10, 16, 16), (42, 42, 16, 16)),
            ((25, 18), (42, 50)),
        )

    def test_team_formation_slots_rotate_with_the_viewer_not_render_order(self) -> None:
        member = MonsterRecord(
            0, 0, 3, 6, 6, 0, 0x12, 0x00,
            formation_slot=2,
            formation_facing=0,
        )
        self.assertEqual(
            occupant_view_position(
                member,
                player_x=6,
                player_y=7,
                player_facing=0,
                formation_index=member.formation_slot,
            ),
            (17, 0),
        )
        self.assertEqual(
            occupant_view_position(
                member,
                player_x=5,
                player_y=6,
                player_facing=1,
                formation_index=member.formation_slot,
            ),
            (17, 3),
        )

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

    def test_object_stack_edit_round_trips_through_modified_resource(self) -> None:
        with TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            clean = root / "BLOODWYCH439-clean"
            for stem in ("mod0", "serp", "moon", "drag", "chaos", "zendik"):
                destination = clean / "maps" / f"{stem}.map"
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_bytes((CLEAN_ROOT / "maps" / f"{stem}.map").read_bytes())
            source = CLEAN_ROOT / "maps" / "mod0.obj"
            destination = clean / "maps" / "mod0.obj"
            destination.write_bytes(source.read_bytes())
            project = MapProject.from_extracted(clean)
            stacks = list(project.object_stacks(0))
            first = stacks[0]
            stacks[0] = ObjectStack(
                first.position,
                first.map_index,
                ((0x17, 2),) + first.items[1:],
            )
            project.set_object_stacks(0, stacks)
            written = project.save()
            self.assertEqual(
                written,
                (root / "BLOODWYCH439-modified" / "maps" / "mod0.obj",),
            )
            self.assertEqual(project.object_stacks(0)[0].items[0], (0x17, 2))
            self.assertEqual(source.read_bytes(), destination.read_bytes())

    def test_object_stack_can_be_relocated_to_the_cursor_cell(self) -> None:
        project = MapProject.from_extracted(CLEAN_ROOT)
        tower = project.maps[0]
        stack = project.object_stacks(0)[0]
        moved = relocate_object_stack(tower, stack, 3, 0, 0)

        self.assertEqual(object_stack_location(tower, moved), (3, 0, 0))
        self.assertEqual(moved.items, stack.items)

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

    def test_map_font_default_baseline_matches_bed_and_fizzle_icons(self) -> None:
        """Cell-letter glyphs start two native pixels below the cell top."""

        from tools.map_editor.app import GameFontRenderer

        self.assertEqual(GameFontRenderer.draw_map_glyph.__kwdefaults__["y"], 4)

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
        self.assertEqual(apply_cell_action(north, "WOOD-N-").first, 0)

    def test_editor_rows_separate_values_from_small_adjustment_actions(self) -> None:
        rows = editor_rows_for_cell(MapCell(0x0A, 0x81))
        self.assertEqual(
            tuple((row.label, row.value) for row in rows),
            (
                ("TYPE", "1: STONE WALL"),
                ("FACE", "NORTH"),
                ("FEATURE", "SWITCH"),
                ("REFERENCE", "1"),
                ("STATE", "LIT"),
            ),
        )
        self.assertEqual(rows[3].decrement_action, "REFERENCE-")
        self.assertEqual(rows[3].increment_action, "REFERENCE+")

    def test_trigger_parameters_follow_amos_destination_cycles(self) -> None:
        self.assertEqual(adjust_trigger_parameter(0x12, 0x0B, 1), 0x02)
        self.assertEqual(adjust_trigger_parameter(0x14, 0x04, -1), 0x14)
        self.assertEqual(adjust_trigger_parameter(0x2A, 7, 1), 0)
        self.assertEqual(trigger_parameter_label(0x12, 0x03), "SERPENT TOWER 2")
        self.assertEqual(trigger_parameter_label(0x14, 0x10), "CHAOS TOWER")

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

    def test_layout_elevation_icons_survive_two_stage_alpha_compositing(self) -> None:
        try:
            import pygame
        except ImportError:
            self.skipTest("pygame is not installed")

        cells = [MapCell(direction, 4) for direction in range(8)]
        cells += [MapCell(kind, 6) for kind in (1, 4, 5)]
        background = (5, 5, 7)
        for cell in cells:
            for zoom in (1, 2):
                for alpha in (90, 180, 255):
                    with self.subTest(cell=cell, zoom=zoom, alpha=alpha):
                        source = pygame.Surface((16, 16))
                        draw_map_cell(source, source.get_rect(), cell)
                        source = pygame.transform.scale(source, (16 * zoom, 16 * zoom))
                        before = pygame.image.tostring(source, "RGB")
                        icon = layout_icon_surface(source, alpha=alpha)
                        layer = pygame.Surface(source.get_size(), pygame.SRCALPHA)
                        layer.blit(icon, (0, 0))
                        screen = pygame.Surface(source.get_size())
                        screen.fill(background)
                        screen.blit(layer, (0, 0))

                        for y in range(source.get_height()):
                            for x in range(source.get_width()):
                                rgb = source.get_at((x, y))[:3]
                                if rgb == (0, 0, 0):
                                    self.assertEqual(layer.get_at((x, y)).a, 0)
                                    self.assertEqual(screen.get_at((x, y))[:3], background)
                                else:
                                    # RGB must remain unattenuated on the intermediate
                                    # layer. Only its final composition applies alpha.
                                    self.assertEqual(tuple(layer.get_at((x, y))), (*rgb, alpha))
                                    for actual, value, bg in zip(screen.get_at((x, y)), rgb, background):
                                        expected = round((value * alpha + bg * (255 - alpha)) / 255)
                                        self.assertAlmostEqual(actual, expected, delta=1)
                        self.assertEqual(pygame.image.tostring(source, "RGB"), before)
                        self.assertIsNone(source.get_colorkey())
                        self.assertIsNone(source.get_alpha())

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

    def test_current_main_wall_is_sealed_without_an_inner_feature_overlay(self) -> None:
        tower = TowerMap((CLEAN_ROOT / "maps" / "mod0.map").read_bytes())
        # Type-1 shelf and switch cells are valid map data but invalid player
        # locations. The editor preview deliberately treats both as stone.
        tower.set_cell(3, 10, 10, MapCell(0x00, 0x81))
        self.assertEqual(
            map_view_placements(tower, 3, 10, 10, 0)[18].feature_key,
            "stone",
        )
        tower.set_cell(3, 10, 10, MapCell(0x02, 0x81))
        self.assertEqual(
            map_view_placements(tower, 3, 10, 10, 0)[18].feature_key,
            "stone",
        )


if __name__ == "__main__":
    unittest.main()

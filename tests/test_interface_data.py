from pathlib import Path
import unittest

from tools.interface_data import (
    ACTION_ROUTINES,
    ACTION_NAMES,
    ARROW_ACTION_TO_HIGHLIGHT_INDEX,
    ARROW_HIGHLIGHT_SPECS,
    COMMUNICATION_BUTTONS,
    COMMUNICATION_BACKGROUND_COLOUR_INDEX,
    COMMUNICATION_DEEP_MENU_PAGES,
    COMMUNICATION_MENU_PAGE_BUTTONS,
    CHAMPION_NAME_PANEL_BACKGROUND,
    CHAMPION_NAME_PANEL_LOWER_BEVEL_LINES,
    CHAMPION_NAME_PANEL_NAME_BAR,
    CHAMPION_NAME_PANEL_TEXT_POSITION,
    CHAMPION_NAME_PANEL_UPPER_BEVEL_LINES,
    PARTY_EMPTY_PROFESSION_ICON,
    PARTY_AVATAR_PRESENTATION_HITBOXES,
    PARTY_AVATAR_ACTIVE_FLAG,
    PARTY_AVATAR_DEAD_FLAG,
    PARTY_PRESENTATION_LOWER_SLOT_MASK,
    PARTY_PENDING_PROFESSION_COLOUR_MASK,
    PARTY_PROFESSION_ICON_BASE,
    PARTY_PROFESSION_ICON_POSITIONS,
    PARTY_SELECTED_PROFESSION_FRAMES,
    STATS_SCROLL_RETURN_HITBOX,
    SPELLBOOK_RUNE_HITBOXES,
    RIGHT_STATUS_ICON_BEVEL_LINES,
    COMPACT_STATS_BAR_COUNT,
    PARTY_SHIELD_STATUS_BAR_BASE_Y,
    PARTY_SHIELD_STATUS_BAR_COLOUR_INDICES,
    PARTY_SHIELD_STATUS_BAR_FULL_TERMINAL_HEIGHT,
    PARTY_SHIELD_STATUS_BAR_WIDTH,
    COPPER_FRAME_WRAP_Y,
    COPPER_PLAYER_RASTER_SPLIT_Y,
    DIALOGUE_TEXT_PALETTE_INDEX,
    DUNGEON_VIEW_RECT,
    GFX_POCKETS_CHAIN_COMMAND_OFFSET,
    GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET,
    GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET,
    GFX_POCKETS_SELECTED_PARTY_SHIELD_OFFSET,
    INTERFACE_ACTION_LOAD_SAVE,
    INTERFACE_ACTION_INVENTORY_EXIT,
    INTERFACE_ACTION_INVENTORY_HELD_SLOT,
    INTERFACE_ACTION_INVENTORY_SLOT_FIRST,
    INTERFACE_ACTION_INVENTORY_SLOT_LAST,
    INTERFACE_ACTION_PARTY_MEMBER_FIRST,
    INTERFACE_ACTION_PARTY_MEMBER_LAST,
    INTERFACE_ACTION_PARTY_COMMAND_MODE,
    INTERFACE_ACTION_MOVE_FORWARDS,
    INTERFACE_ACTION_MOVE_BACKWARDS,
    INTERFACE_ACTION_MOVE_LEFT,
    INTERFACE_ACTION_ROTATE_LEFT,
    INTERFACE_ACTION_ROTATE_RIGHT,
    INTERFACE_ACTION_MULTI_FUNCTION,
    INTERFACE_ACTION_WALL_FEATURE_CONTEXT,
    INTERFACE_ACTION_WALL_FEATURE_CLICK,
    INTERFACE_PREVIEW_FLOOR,
    INTERFACE_PREVIEW_MOVEMENT_POLICY,
    INTERFACE_ACTION_PAUSE,
    INTERFACE_ACTION_SLEEP_PARTY,
    INTERFACE_ACTION_SHOW_TEAM_AVATARS,
    INTERFACE_MODES,
    LARGE_AVATAR_INNER_FRAME,
    LARGE_AVATAR_PANEL_FILL,
    LARGE_AVATAR_PANEL_FRAMES,
    LARGE_AVATAR_RECT,
    PLAYER_POINTER_Y_OFFSETS,
    PLAYER_COMPACT_STATS_COLOUR_INDICES,
    PLAYER_DATA_UI_PRIMARY_COLOUR_OFFSET,
    PLAYER_DATA_UI_SECONDARY_COLOUR_OFFSET,
    PLAYER1_INTERFACE_HOVER_COLOUR_OFFSET,
    PLAYER2_CHAMPION_COUNT_HOVER_COLOUR_OFFSET,
    PLAYER_SCREEN_BYTE_OFFSETS,
    PLAYER_UI_PRIMARY_COLOUR_INDICES,
    PLAYER_UI_SECONDARY_COLOUR_INDICES,
    PARTY_COMMAND_ICON_DECORATION_LINES,
    POCKETS_TRAILING_BINARY_OFFSET,
    POCKETS_TRAILING_MEMORY_ADDRESS,
    STATS_BAR_RECTS,
    STATS_BARS_BACKGROUND,
    STATS_FRAME_FILL,
    STATS_FRAME_HORIZONTAL_LINES,
    STATS_FRAME_VERTICAL_LINES,
    SOURCE_REFS,
    FULL_LENGTH_AVATAR_PREVIEW_Y_OFFSET,
    InterfaceProject,
    interface_preview_cell_allows_entry,
    active_party_champion_draw_parameters,
    amiga_colour_to_rgb,
    body_design_with_worn_armour,
    click_party_member_preview,
    colour_ramp_index,
    replace_colour_nibble,
    remap_ui_template_colour,
    screen_byte_offset_to_xy,
    communication_button_at,
    communication_button_handler,
    communication_menu_buttons,
    party_member_slot_for_action,
    promote_preview_avatar_member,
    promote_preview_avatar_state,
)


ROOT = Path(__file__).resolve().parents[1]
DATA_ROOT = ROOT / "data/BLOODWYCH439-clean"


class InterfaceDataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.project = InterfaceProject(DATA_ROOT)

    def test_two_players_are_stacked_in_96_line_screen_halves(self) -> None:
        self.assertEqual(PLAYER_POINTER_Y_OFFSETS, (0, 0x60))
        self.assertEqual(PLAYER_SCREEN_BYTE_OFFSETS, (0, 0x0F00))
        self.assertEqual(screen_byte_offset_to_xy(0x0F00), (0, 96))
        self.assertEqual(screen_byte_offset_to_xy(0x051C), (224, 32))

    def test_navigation_highlights_use_the_original_six_overlay_records(self) -> None:
        self.assertEqual(
            ARROW_HIGHLIGHT_SPECS,
            (
                (0x050, 2, 9, 224, 60),
                (0x268, 1, 11, 256, 72),
                (0x1D8, 2, 9, 224, 74),
                (0x180, 1, 11, 224, 72),
                (0x000, 1, 10, 224, 60),
                (0x0E0, 2, 10, 240, 60),
            ),
        )
        self.assertEqual(ARROW_ACTION_TO_HIGHLIGHT_INDEX[INTERFACE_ACTION_MOVE_FORWARDS], 0)
        self.assertEqual(ARROW_ACTION_TO_HIGHLIGHT_INDEX[INTERFACE_ACTION_MOVE_BACKWARDS], 2)
        self.assertEqual(ARROW_ACTION_TO_HIGHLIGHT_INDEX[INTERFACE_ACTION_MOVE_LEFT], 3)
        self.assertEqual(ARROW_ACTION_TO_HIGHLIGHT_INDEX[INTERFACE_ACTION_ROTATE_LEFT], 4)
        self.assertEqual(ARROW_ACTION_TO_HIGHLIGHT_INDEX[INTERFACE_ACTION_ROTATE_RIGHT], 5)
        self.assertEqual(len(self.project.arrow_highlights), 6)
        self.assertTrue(
            all(15 in {colour for row in pixels for colour in row}
                for _, _, pixels in self.project.arrow_highlights)
        )

    def test_interface_preview_uses_the_supplied_five_by_nine_serpent_floor(self) -> None:
        project = InterfaceProject(DATA_ROOT)
        self.assertEqual(
            (project.preview_map.widths[INTERFACE_PREVIEW_FLOOR], project.preview_map.heights[INTERFACE_PREVIEW_FLOOR]),
            (5, 9),
        )
        self.assertEqual(
            (project.preview_map.cell(INTERFACE_PREVIEW_FLOOR, 2, 2).first,
             project.preview_map.cell(INTERFACE_PREVIEW_FLOOR, 2, 2).second),
            (0x03, 0x05),
        )
        self.assertEqual(
            (project.preview_map.cell(INTERFACE_PREVIEW_FLOOR, 0, 3).first,
             project.preview_map.cell(INTERFACE_PREVIEW_FLOOR, 0, 3).second),
            (0x5C, 0x02),
        )
        self.assertEqual((project.preview_x, project.preview_y, project.preview_facing), (2, 5, 0))
        original = project.dungeon_preview
        self.assertTrue(project.move_preview_party(INTERFACE_ACTION_MOVE_FORWARDS))
        self.assertEqual((project.preview_x, project.preview_y), (2, 4))
        self.assertNotEqual(project.dungeon_preview, original)
        self.assertFalse(project.move_preview_party(INTERFACE_ACTION_MOVE_LEFT))
        self.assertEqual((project.preview_x, project.preview_y), (2, 4))
        self.assertTrue(project.move_preview_party(INTERFACE_ACTION_ROTATE_RIGHT))
        self.assertEqual(project.preview_facing, 1)

    def test_interface_preview_uses_the_explicit_manual_movement_policy(self) -> None:
        from tools.map_editor.model import MapCell

        self.assertEqual(INTERFACE_PREVIEW_MOVEMENT_POLICY, "manual")
        # Entering (0, 3) from the east crosses its east edge.  $50 $02 is
        # wood with no wall/closed-door state on that edge.
        self.assertTrue(interface_preview_cell_allows_entry(MapCell(0x50, 0x02), 3))
        self.assertFalse(interface_preview_cell_allows_entry(MapCell(0x10, 0x02), 0))
        self.assertFalse(interface_preview_cell_allows_entry(MapCell(0x00, 0x01), 0))
        self.assertFalse(interface_preview_cell_allows_entry(MapCell(0x00, 0x03), 0))
        self.assertTrue(interface_preview_cell_allows_entry(MapCell(0x00, 0x05), 0))
        self.assertFalse(interface_preview_cell_allows_entry(MapCell(0x01, 0x05), 0))
        self.assertTrue(interface_preview_cell_allows_entry(MapCell(0x02, 0x07), 0))
        self.assertFalse(interface_preview_cell_allows_entry(MapCell(0x03, 0x07), 0))

    def test_multifunction_hitbox_toggles_ui_test_doors_from_the_source_paths(self) -> None:
        project = InterfaceProject(DATA_ROOT)
        # $0305 is the unkeyed closed portcullis directly north of this spot.
        project.preview_x, project.preview_y, project.preview_facing = (2, 3, 0)
        self.assertEqual(project.toggle_preview_door(), "opened")
        self.assertEqual(project.preview_map.cell(0, 2, 2).first, 0x02)
        self.assertTrue(project.move_preview_party(INTERFACE_ACTION_MOVE_FORWARDS))

        # $5C02's east side is a closed wooden door.  Its two-bit state moves
        # from 3 (closed) to 2 (open) when entered from the east.
        project.preview_x, project.preview_y, project.preview_facing = (1, 3, 3)
        self.assertEqual(project.toggle_preview_door(), "opened")
        self.assertEqual(project.preview_map.cell(0, 0, 3).first, 0x58)

        # $0905 carries B bit 3 (void lock), which C650 rejects before toggle.
        project.preview_x, project.preview_y, project.preview_facing = (2, 7, 0)
        self.assertEqual(project.toggle_preview_door(), "locked")
        self.assertEqual(project.preview_map.cell(0, 2, 6).first, 0x09)

    def test_multi_function_door_operation_requires_its_door_icon(self) -> None:
        from tools.interface_viewer import _active_mode_hitboxes, multi_function_displays_door_icon

        self.assertTrue(multi_function_displays_door_icon(None))
        # A selected spell replaces the door icon, including after a cast
        # request while the spell remains active in the preview.
        self.assertFalse(multi_function_displays_door_icon(0))
        main_mode = next(mode for mode in INTERFACE_MODES if mode.key == "main")
        door_hitbox = next(
            hitbox
            for hitbox in _active_mode_hitboxes(
                self.project, main_mode, comms_menu_page=0
            )
            if hitbox.action == INTERFACE_ACTION_MULTI_FUNCTION
        )
        self.assertEqual(
            (door_hitbox.x_min, door_hitbox.x_max, door_hitbox.y_min, door_hitbox.y_max),
            (289, 302, 34, 47),
        )

    def test_preview_switch_is_reference_one_on_the_east_face(self) -> None:
        from tools.map_editor.first_person import map_cell_placement
        from tools.map_editor.model import SwitchRecord

        project = InterfaceProject(DATA_ROOT)
        cell = project.preview_map.cell(0, 1, 5)
        self.assertEqual((cell.first, cell.second), (0x0A, 0x91))
        self.assertEqual(project.preview_switches[1], SwitchRecord(1, 0x04, 1, 4))
        placement = map_cell_placement(cell, 0, map_x=1, map_y=5)
        self.assertEqual(placement.feature_key, "switch")
        self.assertEqual(placement.direction, 1)  # East relative to north.
        self.assertTrue(placement.active)
        self.assertEqual(placement.colour_variant, 6)  # (X + Y) & 7.

    def test_preview_switch_toggles_target_wall_and_its_own_graphic_repeatedly(self) -> None:
        from tools.map_editor.model import MapCell

        project = InterfaceProject(DATA_ROOT)
        project.move_preview_party(INTERFACE_ACTION_ROTATE_LEFT)
        before_map = project.preview_map.to_bytes()
        before_pixels = project.dungeon_preview
        result = project.click_preview_wall_feature()
        self.assertIn("wall removed", result)
        self.assertEqual(project.preview_map.cell(0, 1, 5), MapCell(0x0E, 0x91))
        self.assertEqual(project.preview_map.cell(0, 1, 4), MapCell(0, 0))
        self.assertTrue(interface_preview_cell_allows_entry(project.preview_map.cell(0, 1, 4), 3))
        self.assertNotEqual(project.dungeon_preview, before_pixels)
        changed = {i for i, (a, b) in enumerate(zip(before_map, project.preview_map.to_bytes())) if a != b}
        self.assertEqual(changed, {
            project.preview_map.cell_offset(0, 1, 5),
            project.preview_map.cell_offset(0, 1, 4) + 1,
        })
        self.assertIn("wall restored", project.click_preview_wall_feature())
        self.assertEqual(project.preview_map.to_bytes(), before_map)
        self.assertEqual(project.dungeon_preview, before_pixels)
        self.assertIn("wall removed", project.click_preview_wall_feature())

    def test_preview_switch_rejects_wrong_faces_and_missing_references(self) -> None:
        from tools.map_editor.model import MapCell, SwitchRecord

        project = InterfaceProject(DATA_ROOT)
        project.move_preview_party(INTERFACE_ACTION_ROTATE_LEFT)
        for cell in (MapCell(0x0A, 0x81), MapCell(0x0A, 0xA1), MapCell(0x0A, 0xB1),
                     MapCell(0x02, 0x91), MapCell(0x12, 0x91)):
            with self.subTest(cell=cell):
                project.preview_map.set_cell(0, 1, 5, cell)
                before = project.preview_map.to_bytes()
                project.click_preview_wall_feature()
                self.assertEqual(project.preview_map.to_bytes(), before)

        project.preview_map.set_cell(0, 1, 5, MapCell(0x0A, 0x91))
        for record in (SwitchRecord(1, 0xFF, 1, 4), SwitchRecord(1, 0x04, 5, 4)):
            with self.subTest(record=record):
                project.preview_switches = (project.preview_switches[0], record)
                before = project.preview_map.to_bytes()
                project.click_preview_wall_feature()
                self.assertEqual(project.preview_map.to_bytes(), before)

    def test_switch_toggle_wall_applies_the_word_mask_and_target_bit_seven_guard(self) -> None:
        from tools.map_editor.model import MapCell

        project = InterfaceProject(DATA_ROOT)
        project.move_preview_party(INTERFACE_ACTION_ROTATE_LEFT)
        # adrJA005CFC's AND.W #$00F9 clears the first byte, not just type
        # bits in the second byte. Other second-byte flags must survive.
        project.preview_map.set_cell(0, 1, 4, MapCell(0xAB, 0x79))
        project.click_preview_wall_feature()
        self.assertEqual(project.preview_map.cell(0, 1, 4), MapCell(0, 0x78))

        protected = MapCell(0xAB, 0x91)
        project.preview_map.set_cell(0, 1, 4, protected)
        switch_before = project.preview_map.cell(0, 1, 5)
        self.assertIn("unchanged", project.click_preview_wall_feature())
        self.assertEqual(project.preview_map.cell(0, 1, 4), protected)
        self.assertEqual(project.preview_map.cell(0, 1, 5).first, switch_before.first ^ 4)

    def test_wall_feature_click_falls_through_to_doors_only_for_non_stone_cells(self) -> None:
        project = InterfaceProject(DATA_ROOT)
        project.preview_x, project.preview_y, project.preview_facing = (2, 3, 0)
        self.assertEqual(project.click_preview_wall_feature(), "door: opened")
        self.assertEqual(project.click_preview_wall_feature(), "door: closed")
        project.preview_x, project.preview_y = (2, 7)
        self.assertEqual(project.click_preview_wall_feature(), "door: locked")

    def test_display_context_24_is_the_direct_door_hitbox(self) -> None:
        from tools.interface_viewer import (
            _active_mode_hitboxes,
            _display_context_hitbox_at,
            _visible_hitbox_overlays,
        )

        main_mode = next(mode for mode in INTERFACE_MODES if mode.key == "main")
        door_hitbox = next(
            hitbox
            for hitbox in _active_mode_hitboxes(
                self.project, main_mode, comms_menu_page=0
            )
            if hitbox.action == INTERFACE_ACTION_WALL_FEATURE_CONTEXT
        )
        self.assertEqual(
            (door_hitbox.x_min, door_hitbox.x_max, door_hitbox.y_min, door_hitbox.y_max),
            (114, 205, 28, 72),
        )
        self.assertEqual(
            ACTION_ROUTINES[INTERFACE_ACTION_WALL_FEATURE_CONTEXT], "adrJA0064D0"
        )
        self.assertEqual(
            ACTION_ROUTINES[INTERFACE_ACTION_WALL_FEATURE_CLICK], "Handle_WallFeatureClick"
        )
        # Click_Display ($10) owns the entire viewport, then invokes the
        # display table as a second-stage hit test.  The generic hitbox must
        # not mask the contextual door rectangle.
        outer = next(
            hitbox
            for hitbox in _active_mode_hitboxes(
                self.project, main_mode, comms_menu_page=0
            )
            if hitbox.contains(114, 50)
        )
        self.assertEqual(outer.action, 0x10)
        self.assertEqual(
            _display_context_hitbox_at(self.project, 114, 50), door_hitbox
        )
        self.assertEqual(
            _display_context_hitbox_at(self.project, 160, 50).action,
            INTERFACE_ACTION_WALL_FEATURE_CLICK,
        )
        self.assertIsNone(_display_context_hitbox_at(self.project, 96, 12))
        self.assertIn(
            0x10,
            {
                hitbox.action
                for hitbox in _visible_hitbox_overlays(
                    self.project,
                    main_mode,
                    comms_menu_page=0,
                    right_mode_key="main",
                    spellbook_spread=0,
                    selected_spell=None,
                )
            },
        )

    def test_dungeon_display_hitboxes_remain_active_in_spellbook_and_stats(self) -> None:
        from tools.interface_viewer import _active_mode_hitboxes

        expected = {0x10, 0x22, 0x23, 0x24}
        for mode_key, right_mode_key in (("spellbook", "spellbook"), ("stats", "stats")):
            mode = next(mode for mode in INTERFACE_MODES if mode.key == mode_key)
            actions = {
                hitbox.action
                for hitbox in _active_mode_hitboxes(
                    self.project,
                    mode,
                    comms_menu_page=0,
                    right_mode_key=right_mode_key,
                )
            }
            self.assertTrue(expected <= actions)

    def test_navigation_highlight_survives_spellbook_redraw(self) -> None:
        import pygame

        from tools.interface_viewer import render_interface_panel

        pygame.init()
        try:
            mode = next(mode for mode in INTERFACE_MODES if mode.key == "main")
            normal, _ = render_interface_panel(
                pygame,
                self.project,
                mode,
                player=0,
                alternate_ramp=False,
                ramp_step=0,
                right_mode_key="spellbook",
            )
            highlighted, _ = render_interface_panel(
                pygame,
                self.project,
                mode,
                player=0,
                alternate_ramp=False,
                ramp_step=0,
                right_mode_key="spellbook",
                arrow_highlight_action=INTERFACE_ACTION_MOVE_FORWARDS,
            )
            self.assertNotEqual(normal.get_buffer().raw, highlighted.get_buffer().raw)
        finally:
            pygame.quit()

    def test_locked_door_notice_uses_the_source_text_origin(self) -> None:
        import pygame
        from unittest.mock import patch

        from tools.interface_viewer import (
            COMMUNICATION_TEXT_POSITION,
            COMMUNICATION_TEXT_SCREEN_OFFSET,
            DOOR_LOCKED_NOTICE,
            DOOR_LOCKED_NOTICE_POSITION,
            TIMED_TEXT_HOLD_VBLANKS,
            TIMED_TEXT_STEP_VBLANKS,
            TIMED_TEXT_VBLANKS_PER_SECOND,
            render_interface_panel,
            timed_text_fade_step,
        )

        pygame.init()
        try:
            mode = next(mode for mode in INTERFACE_MODES if mode.key == "main")
            normal, _ = render_interface_panel(
                pygame, self.project, mode, player=0, alternate_ramp=False, ramp_step=0
            )
            noticed, _ = render_interface_panel(
                pygame,
                self.project,
                mode,
                player=0,
                alternate_ramp=False,
                ramp_step=0,
                timed_notice=DOOR_LOCKED_NOTICE,
            )
            self.assertEqual(COMMUNICATION_TEXT_SCREEN_OFFSET, 0x0050)
            self.assertEqual(COMMUNICATION_TEXT_POSITION, (0, 2))
            self.assertEqual(DOOR_LOCKED_NOTICE_POSITION, COMMUNICATION_TEXT_POSITION)
            self.assertEqual(timed_text_fade_step(0), 0)
            self.assertEqual(
                timed_text_fade_step(
                    TIMED_TEXT_HOLD_VBLANKS * 1_000 // TIMED_TEXT_VBLANKS_PER_SECOND
                ),
                0,
            )
            self.assertEqual(
                timed_text_fade_step(
                    (TIMED_TEXT_HOLD_VBLANKS + TIMED_TEXT_STEP_VBLANKS)
                    * 1_000
                    // TIMED_TEXT_VBLANKS_PER_SECOND
                ),
                1,
            )
            self.assertEqual(timed_text_fade_step(0, start_step=5), 5)
            self.assertNotEqual(normal.get_buffer().raw, noticed.get_buffer().raw)

            text_calls = []

            def record_gamefont(_pygame, _surface, _font, text, x, y, _colour, **_kwargs):
                text_calls.append((text, x, y))

            with patch("tools.interface_viewer._draw_gamefont", record_gamefont):
                render_interface_panel(
                    pygame,
                    self.project,
                    mode,
                    player=0,
                    alternate_ramp=False,
                    ramp_step=0,
                    timed_notice=DOOR_LOCKED_NOTICE,
                )
            self.assertIn(
                (DOOR_LOCKED_NOTICE, *COMMUNICATION_TEXT_POSITION), text_calls
            )
            self.assertNotIn(("THERE IS NOBODY HERE", *COMMUNICATION_TEXT_POSITION), text_calls)
        finally:
            pygame.quit()

    def test_pocket_chain_strips_match_source_interface_paths(self) -> None:
        self.assertEqual(GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET, 0x3C00)
        self.assertEqual(GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET, 0x3C30)
        self.assertEqual(GFX_POCKETS_CHAIN_COMMAND_OFFSET, 0x3C60)
        self.assertEqual(GFX_POCKETS_SELECTED_PARTY_SHIELD_OFFSET, 0x5070)

    def test_three_interface_hitbox_tables_decode_with_action_ids(self) -> None:
        self.assertEqual(
            {group: len(records) for group, records in self.project.hitboxes.items()},
            {
                "main": 17,
                "command": 6,
                "display": 3,
                "avatars": 5,
                "inventory": 18,
                "stats_scroll": 1,
                "spellbook": 15,
            },
        )
        spellbook = self.project.hitboxes["main"][0]
        self.assertEqual(
            (spellbook.action, spellbook.x_min, spellbook.x_max, spellbook.y_min, spellbook.y_max),
            (0, 0xE2, 0x106, 0x21, 0x36),
        )
        self.assertEqual(spellbook.action_name, "Open spell book")
        self.assertTrue(spellbook.contains(0xE2, 0x21))
        self.assertTrue(spellbook.contains(0x106, 0x36))
        inventory = self.project.hitboxes["inventory"]
        self.assertEqual(
            (inventory[4].action, inventory[4].x_min, inventory[4].y_min),
            (INTERFACE_ACTION_INVENTORY_SLOT_FIRST, 0xE0, 0x20),
        )
        self.assertEqual(inventory[15].action, INTERFACE_ACTION_INVENTORY_SLOT_LAST)
        self.assertEqual(inventory[16].action, INTERFACE_ACTION_INVENTORY_HELD_SLOT)
        self.assertEqual(inventory[17].action, INTERFACE_ACTION_INVENTORY_EXIT)

    def test_action_namespace_matches_37_entry_dispatch_table(self) -> None:
        self.assertEqual(len(ACTION_NAMES), 37)
        self.assertEqual(ACTION_NAMES[0x1C], "Pause game")
        self.assertEqual(ACTION_NAMES[0x20], "Toggle party-command row")
        self.assertEqual(ACTION_NAMES[0x24], "Resolve wall-feature context")
        self.assertEqual(ACTION_ROUTINES[INTERFACE_ACTION_PAUSE], "Click_PauseGame")
        self.assertEqual(ACTION_ROUTINES[INTERFACE_ACTION_LOAD_SAVE], "Click_LoadSaveGame")
        self.assertEqual(ACTION_ROUTINES[INTERFACE_ACTION_SLEEP_PARTY], "Click_SleepParty")
        self.assertEqual(
            ACTION_ROUTINES[INTERFACE_ACTION_SHOW_TEAM_AVATARS],
            "Click_ShowTeamAvatars",
        )
        self.assertEqual(
            ACTION_ROUTINES[INTERFACE_ACTION_PARTY_COMMAND_MODE],
            "Click_TogglePartyCommandRow",
        )
        self.assertEqual(
            [ACTION_ROUTINES[action] for action in range(0x06, 0x0A)],
            ["Click_PartyMember"] * 4,
        )
        self.assertEqual(
            ACTION_NAMES[0x06:0x0A],
            (
                "Profession icon: front-left",
                "Profession icon: front-right",
                "Profession icon: back-right",
                "Profession icon: back-left",
            ),
        )

    def test_party_member_actions_keep_the_source_slot_and_click_behaviour(self) -> None:
        members = (1, 2, 3, 4)
        self.assertEqual(
            [party_member_slot_for_action(action) for action in range(0x06, 0x0A)],
            [0, 1, 2, 3],
        )
        selected, pending, active = click_party_member_preview(
            members, None, 1, INTERFACE_ACTION_PARTY_MEMBER_LAST
        )
        self.assertEqual((selected, pending, active), (members, 3, 1))
        selected, pending, active = click_party_member_preview(
            selected, pending, active, INTERFACE_ACTION_PARTY_MEMBER_LAST
        )
        self.assertEqual((selected, pending, active), (members, None, 4))
        selected, pending, active = click_party_member_preview(
            members, 0, 1, INTERFACE_ACTION_PARTY_MEMBER_LAST
        )
        self.assertEqual((selected, pending, active), ((4, 2, 3, 1), None, 1))

    def test_party_portraits_start_compact_until_their_left_hitbox_is_clicked(self) -> None:
        self.assertEqual(self.project.expanded_preview_party_slots, set())
        self.assertFalse(self.project.leader_avatar_is_expanded)
        self.assertTrue(self.project.lower_party_avatars_are_compact)
        self.project.expanded_preview_party_slots.add(1)
        self.assertFalse(self.project.leader_avatar_is_expanded)
        self.assertFalse(self.project.lower_party_avatars_are_compact)
        self.project.expanded_preview_party_slots.add(0)
        self.assertTrue(self.project.leader_avatar_is_expanded)
        self.project.expanded_preview_party_slots.remove(0)
        self.assertFalse(self.project.leader_avatar_is_expanded)
        self.project.restore_compact_party_avatars()
        self.assertEqual(self.project.expanded_preview_party_slots, set())
        self.assertTrue(self.project.lower_party_avatars_are_compact)
        self.assertEqual(PARTY_PRESENTATION_LOWER_SLOT_MASK, 0x0E)

    def test_selected_party_character_geometry_and_worn_armour_match_source(self) -> None:
        self.assertEqual(
            [active_party_champion_draw_parameters(slot) for slot in range(4)],
            [(17, 28, 0), (8, 72, 1), (40, 72, 1), (72, 72, 1)],
        )
        self.assertEqual(FULL_LENGTH_AVATAR_PREVIEW_Y_OFFSET, -1)
        self.assertEqual(body_design_with_worn_armour(0, 0x1B), 0)
        self.assertEqual(body_design_with_worn_armour(2, 0x1B), 5)
        self.assertEqual(body_design_with_worn_armour(3, 0x1E), 7)
        self.assertEqual(body_design_with_worn_armour(5, 0x23), 11)
        self.assertEqual(body_design_with_worn_armour(5, 0x00), 5)

    def test_right_status_and_party_profession_controls_follow_source_geometry(self) -> None:
        self.assertEqual(
            RIGHT_STATUS_ICON_BEVEL_LINES,
            (
                (288, 32, 32, 1),
                (288, 49, 32, 1),
                (288, 51, 32, 1),
                (288, 52, 32, 2),
                (288, 53, 32, 3),
                (288, 54, 32, 4),
                (288, 55, 32, 1),
            ),
        )
        self.assertEqual(
            PARTY_PROFESSION_ICON_POSITIONS,
            ((288, 56), (304, 56), (304, 72), (288, 72)),
        )
        self.assertEqual(
            PARTY_SELECTED_PROFESSION_FRAMES,
            ((289, 57, 16, 14), (305, 57, 16, 14), (305, 72, 16, 14), (289, 72, 16, 14)),
        )
        self.assertEqual(PARTY_PROFESSION_ICON_BASE, 0x4B)
        self.assertEqual(PARTY_EMPTY_PROFESSION_ICON, 0x3B)
        self.assertEqual(PARTY_PENDING_PROFESSION_COLOUR_MASK, (0, 4, 3, 14))

    def test_empty_party_slot_cannot_begin_but_can_complete_a_move(self) -> None:
        members = (1, 2, 3, None)
        self.assertEqual(
            click_party_member_preview(members, None, 1, INTERFACE_ACTION_PARTY_MEMBER_LAST),
            (members, None, 1),
        )
        self.assertEqual(
            click_party_member_preview(members, 0, 1, INTERFACE_ACTION_PARTY_MEMBER_LAST),
            ((None, 2, 3, 1), None, 1),
        )

    def test_dead_member_cannot_be_lead_but_remains_a_swap_destination(self) -> None:
        members = (1, 2, 3, None)
        self.assertEqual(
            click_party_member_preview(
                members,
                None,
                1,
                INTERFACE_ACTION_PARTY_MEMBER_FIRST + 2,
                blocked_leader_ids=(3,),
            ),
            (members, None, 1),
        )
        selected, pending, active = click_party_member_preview(
            members,
            None,
            1,
            INTERFACE_ACTION_PARTY_MEMBER_FIRST,
            blocked_leader_ids=(3,),
        )
        self.assertEqual((selected, pending, active), (members, 0, 1))
        self.assertEqual(
            click_party_member_preview(
                selected,
                pending,
                active,
                INTERFACE_ACTION_PARTY_MEMBER_FIRST + 2,
                blocked_leader_ids=(3,),
            ),
            ((3, 2, 1, None), None, 1),
        )

    def test_confirmed_leader_selection_refreshes_left_avatar_slots(self) -> None:
        self.assertEqual(
            promote_preview_avatar_member((1, 2, 3, None), 1, 2),
            (2, 1, 3, None),
        )

    def test_avatar_state_bytes_retain_death_when_leaders_or_positions_change(self) -> None:
        states = (1 | PARTY_AVATAR_ACTIVE_FLAG, 2, 3 | PARTY_AVATAR_DEAD_FLAG, None)
        refreshed = promote_preview_avatar_state(states, 1, 2)
        self.assertEqual(refreshed, (2 | PARTY_AVATAR_ACTIVE_FLAG, 1, 3 | PARTY_AVATAR_DEAD_FLAG, None))
        self.assertEqual(refreshed[2] & PARTY_AVATAR_DEAD_FLAG, PARTY_AVATAR_DEAD_FLAG)

    def test_interface_modes_select_the_expected_hitbox_groups(self) -> None:
        modes = {mode.key: mode for mode in INTERFACE_MODES}
        self.assertEqual(modes["main"].hitbox_groups, ("main", "display", "avatars"))
        self.assertEqual(modes["comms"].hitbox_groups, ("main", "command"))
        self.assertEqual(len(self.project.mode_hitboxes(modes["main"])), 25)
        self.assertEqual(
            [item.action for item in self.project.mode_hitboxes(modes["inventory"])],
            [],
        )
        self.assertEqual(
            [item.action for item in self.project.mode_hitboxes(modes["stats"])],
            [],
        )
        self.assertEqual(
            [item.action for item in self.project.mode_hitboxes(modes["spellbook"])],
            [0x19, 0x18, 0x17, *range(0x200, 0x208)],
        )
        self.assertEqual(
            SPELLBOOK_RUNE_HITBOXES,
            (
                (0x200, 232, 263, 24, 31, "Select spell-book rune entry 1"),
                (0x201, 280, 311, 24, 31, "Select spell-book rune entry 2"),
                (0x202, 232, 263, 32, 39, "Select spell-book rune entry 3"),
                (0x203, 280, 311, 32, 39, "Select spell-book rune entry 4"),
                (0x204, 232, 263, 40, 47, "Select spell-book rune entry 5"),
                (0x205, 280, 311, 40, 47, "Select spell-book rune entry 6"),
                (0x206, 232, 263, 48, 55, "Select spell-book rune entry 7"),
                (0x207, 280, 311, 48, 55, "Select spell-book rune entry 8"),
            ),
        )
        self.assertEqual(
            STATS_SCROLL_RETURN_HITBOX,
            (0xFF, 224, 319, 9, 95, "Return from statistics scroll (source hitbox unidentified)"),
        )
        self.assertEqual(
            [item.action for item in self.project.mode_hitboxes(modes["comms"])],
            [*range(0x00, 0x10), 0x1C, 0x1D, 0x1E, 0x1F, 0x20],
        )
        self.assertEqual(
            self.project.hitboxes["command"][4].handler_name,
            "Click_TogglePartyCommandRow",
        )
        self.assertEqual(
            PARTY_AVATAR_PRESENTATION_HITBOXES,
            (
                (0x1A, 0, 47, 10, 53, 0, "Toggle full-length large avatar"),
                (0x1A, 0, 31, 55, 95, 1, "Toggle full-length front-right avatar"),
                (0x1A, 32, 63, 55, 95, 2, "Toggle full-length back-right avatar"),
                (0x1A, 64, 95, 55, 95, 3, "Toggle full-length back-left avatar"),
                (0x1A, 48, 95, 10, 53, None, "Restore compact statistics display"),
            ),
        )
        self.assertEqual(
            [
                (hitbox.action, hitbox.party_slot, hitbox.action_name)
                for hitbox in self.project.hitboxes["avatars"]
            ],
            [
                (0x1A, 0, "Toggle full-length large avatar"),
                (0x1A, 1, "Toggle full-length front-right avatar"),
                (0x1A, 2, "Toggle full-length back-right avatar"),
                (0x1A, 3, "Toggle full-length back-left avatar"),
                (0x1A, None, "Restore compact statistics display"),
            ],
        )
        self.assertEqual(
            [
                (item.action, item.x_min, item.x_max, item.y_min, item.y_max)
                for item in self.project.hitboxes["main"][6:10]
            ],
            [
                (0x06, 288, 303, 58, 69),
                (0x07, 304, 319, 58, 69),
                (0x08, 304, 319, 73, 84),
                (0x09, 288, 303, 73, 84),
            ],
        )

    def test_observed_main_layout_uses_the_native_dungeon_rectangle(self) -> None:
        self.assertEqual(DUNGEON_VIEW_RECT, (96, 12, 128, 76))
        self.assertEqual(len(self.project.dungeon_preview), 76)
        self.assertTrue(all(len(row) == 128 for row in self.project.dungeon_preview))

    def test_champion_name_panel_geometry_uses_the_packed_source_dimensions(self) -> None:
        self.assertEqual(CHAMPION_NAME_PANEL_BACKGROUND, (225, 9, 95, 87, 0))
        self.assertEqual(
            CHAMPION_NAME_PANEL_UPPER_BEVEL_LINES,
            (
                (226, 10, 94, 1),
                (226, 11, 94, 2),
                (226, 12, 94, 3),
                (226, 13, 94, 4),
                (226, 14, 94, 1),
            ),
        )
        self.assertEqual(CHAMPION_NAME_PANEL_NAME_BAR, (226, 16, 94, 8))
        self.assertEqual(CHAMPION_NAME_PANEL_TEXT_POSITION, (224, 18))
        self.assertEqual(
            CHAMPION_NAME_PANEL_LOWER_BEVEL_LINES,
            (
                (226, 25, 94, 1),
                (226, 26, 94, 2),
                (226, 27, 94, 3),
                (226, 28, 94, 4),
            ),
        )

    def test_communication_controls_are_separate_seven_pixel_bars(self) -> None:
        self.assertEqual(
            [(button.word_index, button.label) for button in COMMUNICATION_BUTTONS],
            [
                (0x10, "COMMUNICATE"),
                (0x11, "COMMEND"),
                (0x12, "VIEW"),
                (0x13, "WAIT"),
                (0x14, "CORRECT"),
                (0x15, "DISMISS"),
                (0x16, "CALL"),
            ],
        )
        self.assertTrue(all(button.height == 7 for button in COMMUNICATION_BUTTONS))
        self.assertEqual(COMMUNICATION_BUTTONS[0].x_min, 1)
        self.assertEqual(COMMUNICATION_BACKGROUND_COLOUR_INDEX, 0x02)
        self.assertEqual(COMMUNICATION_BUTTONS[0].x_max, DUNGEON_VIEW_RECT[0] - 3)
        self.assertEqual(
            DUNGEON_VIEW_RECT[0] - COMMUNICATION_BUTTONS[0].x_max - 1,
            2,
        )
        self.assertEqual(
            sorted({(button.y_min, button.y_max) for button in COMMUNICATION_BUTTONS}),
            [(57, 63), (65, 71), (73, 79), (81, 87)],
        )
        self.assertEqual(
            COMMUNICATION_BUTTONS[-1].y_max,
            DUNGEON_VIEW_RECT[1] + DUNGEON_VIEW_RECT[3] - 1,
        )
        self.assertEqual(COMMUNICATION_BUTTONS[1].x_max + 2, COMMUNICATION_BUTTONS[2].x_min)
        self.assertEqual(COMMUNICATION_BUTTONS[3].x_max + 2, COMMUNICATION_BUTTONS[4].x_min)
        self.assertEqual(
            [button.text_x for button in COMMUNICATION_BUTTONS],
            [0, 0, 62, 0, 38, 0, 62],
        )
        self.assertEqual(communication_button_at(1, 57).label, "COMMUNICATE")
        self.assertEqual(communication_button_at(93, 85).label, "CALL")
        self.assertIsNone(communication_button_at(34, 72))
        self.assertEqual(
            communication_button_handler(COMMUNICATION_BUTTONS[0], character_in_front=True),
            "Comms_StartWithTarget (Greeting)",
        )
        self.assertEqual(
            communication_button_handler(COMMUNICATION_BUTTONS[0], character_in_front=False),
            "Interface_ReportCommunicationTargetUnavailable",
        )

    def test_command_icon_decoration_uses_the_four_source_vertical_lines(self) -> None:
        self.assertEqual(
            PARTY_COMMAND_ICON_DECORATION_LINES,
            (
                (0x32, 0x0A, 0x2B, 0x02),
                (0x5D, 0x0A, 0x2B, 0x02),
                (0x5B, 0x0C, 0x27, 0x02),
                (0x34, 0x0C, 0x27, 0x02),
            ),
        )

    def test_conversation_pages_follow_the_source_descriptor_streams(self) -> None:
        self.assertEqual(COMMUNICATION_DEEP_MENU_PAGES, (4, 5))
        self.assertIs(communication_menu_buttons(0), COMMUNICATION_BUTTONS)
        self.assertEqual(
            [(button.state, button.word_index, button.label) for button in COMMUNICATION_MENU_PAGE_BUTTONS[4]],
            [
                (0, 0x3C, "RECRUIT"),
                (1, 0x3E, "IDENTIFY"),
                (2, 0x3F, "INQUIRY"),
                (3, 0x40, "WHEREABOUTS"),
            ],
        )
        self.assertEqual(
            [(button.state, button.word_index, button.label) for button in COMMUNICATION_MENU_PAGE_BUTTONS[5]],
            [
                (4, 0x42, "TRADING"),
                (5, 0x43, "SMALL TALK"),
                (6, 0x45, "YES"),
                (7, 0x46, "NO"),
                (8, 0x47, "BRIBE"),
                (9, 0x48, "THREAT"),
            ],
        )
        self.assertEqual(communication_button_at(1, 57, menu_page=4).label, "RECRUIT")
        self.assertEqual(communication_button_at(93, 85, menu_page=5).label, "THREAT")
        self.assertIsNone(communication_button_at(44, 73, menu_page=5))
        self.assertEqual(COMMUNICATION_MENU_PAGE_BUTTONS[5][1].display_text, "SMALLTALK")
        self.assertEqual(COMMUNICATION_MENU_PAGE_BUTTONS[5][3].display_text, "    NO")
        self.assertEqual(COMMUNICATION_MENU_PAGE_BUTTONS[5][3].text_x, 46)
        self.assertEqual(COMMUNICATION_MENU_PAGE_BUTTONS[5][5].text_x, 46)

    def test_spellbook_magic_class_order_matches_c906_and_c6900(self) -> None:
        from tools.interface_viewer import (
            SPELLBOOK_MAGIC_CLASS_PALETTE_INDICES,
            spellbook_magic_class_index,
        )

        self.assertEqual(SPELLBOOK_MAGIC_CLASS_PALETTE_INDICES, (6, 13, 12, 7))
        self.assertEqual(
            tuple(
                [spellbook_magic_class_index(page * 4 + spell) for spell in range(4)]
                for page in range(8)
            ),
            (
                [0, 1, 2, 3],
                [1, 2, 3, 0],
                [2, 3, 0, 1],
                [3, 0, 1, 2],
                [3, 0, 1, 2],
                [2, 3, 0, 1],
                [1, 2, 3, 0],
                [0, 1, 2, 3],
            ),
        )

    def test_spellbook_rune_controls_keep_unavailable_entries_clickable_for_deselect(self) -> None:
        from tools.interface_viewer import _active_mode_hitboxes, spellbook_entry_spell_index

        spellbook_mode = next(mode for mode in INTERFACE_MODES if mode.key == "spellbook")
        hitboxes = _active_mode_hitboxes(
            self.project,
            spellbook_mode,
            comms_menu_page=0,
            right_mode_key="spellbook",
        )
        available_actions = {
            hitbox.action
            for hitbox in hitboxes
            if 0x200 <= hitbox.action <= 0x207
        }
        self.assertEqual(available_actions, {0x200 + entry for entry in range(8)})

    def test_toggle_hitbox_is_exposed_only_during_an_active_conversation(self) -> None:
        from tools.interface_viewer import _active_mode_hitboxes

        comms_mode = next(mode for mode in INTERFACE_MODES if mode.key == "comms")
        initial_actions = {
            hitbox.action
            for hitbox in _active_mode_hitboxes(
                self.project, comms_mode, comms_menu_page=0
            )
        }
        active_actions = {
            hitbox.action
            for hitbox in _active_mode_hitboxes(
                self.project, comms_mode, comms_menu_page=4
            )
        }
        self.assertNotIn(INTERFACE_ACTION_PARTY_COMMAND_MODE, initial_actions)
        self.assertIn(INTERFACE_ACTION_PARTY_COMMAND_MODE, active_actions)
        special_right_actions = {
            hitbox.action
            for hitbox in _active_mode_hitboxes(
                self.project,
                comms_mode,
                comms_menu_page=0,
                right_mode_key="stats",
            )
        }
        self.assertTrue(all(action not in special_right_actions for action in range(0x10)))
        scroll_return_actions = {
            hitbox.action
            for hitbox in _active_mode_hitboxes(
                self.project,
                comms_mode,
                comms_menu_page=0,
                right_mode_key="stats",
            )
        }
        self.assertIn(0xFF, scroll_return_actions)

    def test_selected_party_shield_changes_only_the_surround(self) -> None:
        champion = 0
        ordinary = self.project.champions.shield_avatar(
            champion,
            ink15_colour=self.project.champions.party_shield_ink_colour(champion),
        ).pixels
        selected = self.project.selected_party_shield_pixels(champion)

        self.assertNotEqual(selected, ordinary)
        self.assertEqual(
            [row[8:24] for row in selected[5:21]],
            [row[8:24] for row in ordinary[5:21]],
        )

    def test_empty_equipment_slots_use_semantic_pockets_icons(self) -> None:
        self.assertEqual(
            self.project.inventory_slot_pixels(0, 1),
            self.project.pockets.icon(0x6D).pixels,
        )
        self.assertEqual(
            self.project.inventory_slot_pixels(0, 2),
            self.project.pockets.icon(0x6E).pixels,
        )
        self.assertEqual(
            self.project.inventory_slot_pixels(0, 3),
            self.project.pockets.icon(0x6F).pixels,
        )
        self.assertEqual(
            self.project.empty_inventory_slot_pixels(0, 11),
            self.project.pockets.icon(0x00).pixels,
        )

    def test_empty_equipment_template_ink_uses_secondary_ui_colour(self) -> None:
        source = self.project.pockets.icon(0x6C).pixels
        remapped = self.project.empty_inventory_slot_pixels(
            0, 0, ui_colour_index=0x08
        )
        self.assertEqual(remapped, remap_ui_template_colour(source, 0x08))
        self.assertFalse(any(pixel == 0x0F for row in remapped for pixel in row))

    def test_dialogue_text_colour_ramps_preserve_source_words(self) -> None:
        self.assertEqual(len(self.project.colour_words), 24)
        self.assertEqual(self.project.colour_word(0, False, 0), 0x00C0)
        self.assertEqual(self.project.colour_word(0, True, 0), 0x0C00)
        self.assertEqual(self.project.colour_word(1, False, 0), 0x0E80)
        self.assertEqual(self.project.colour_word(1, True, 0), 0x0C00)
        self.assertEqual(colour_ramp_index(1, True, 5), 23)
        self.assertEqual(amiga_colour_to_rgb(0x0E80), (238, 136, 0))
        self.assertEqual(replace_colour_nibble(0x0E80, 2, 0xF), 0x0E8F)

    def test_dialogue_ui_roles_and_stats_bars_are_separate_palette_choices(self) -> None:
        self.assertEqual(DIALOGUE_TEXT_PALETTE_INDEX, 0x0F)
        self.assertEqual(PLAYER_DATA_UI_PRIMARY_COLOUR_OFFSET, 0x10)
        self.assertEqual(PLAYER_DATA_UI_SECONDARY_COLOUR_OFFSET, 0x12)
        self.assertEqual(PLAYER1_INTERFACE_HOVER_COLOUR_OFFSET, 0x06)
        self.assertEqual(PLAYER2_CHAMPION_COUNT_HOVER_COLOUR_OFFSET, 0x09)
        self.assertEqual(
            0x0A + PLAYER1_INTERFACE_HOVER_COLOUR_OFFSET,
            PLAYER_DATA_UI_PRIMARY_COLOUR_OFFSET,
        )
        self.assertEqual(
            0x07 + PLAYER2_CHAMPION_COUNT_HOVER_COLOUR_OFFSET,
            PLAYER_DATA_UI_PRIMARY_COLOUR_OFFSET,
        )
        self.assertEqual(PLAYER_UI_PRIMARY_COLOUR_INDICES, (0x07, 0x09))
        self.assertEqual(PLAYER_UI_SECONDARY_COLOUR_INDICES, (0x08, 0x0C))
        self.assertEqual(COMPACT_STATS_BAR_COUNT, 3)
        self.assertEqual(PLAYER_COMPACT_STATS_COLOUR_INDICES, (0x07, 0x0C))
        self.assertEqual(COPPER_PLAYER_RASTER_SPLIT_Y, 0x98)
        self.assertEqual(COPPER_FRAME_WRAP_Y, 0xFF)

    def test_compact_stats_frame_matches_source_primitive_arguments(self) -> None:
        self.assertEqual(len(STATS_FRAME_HORIZONTAL_LINES), 10)
        self.assertEqual(STATS_FRAME_HORIZONTAL_LINES[0], (0x36, 0x0A, 0x25, 0x01))
        self.assertEqual(STATS_FRAME_HORIZONTAL_LINES[-1], (0x36, 0x35, 0x25, 0x01))
        self.assertEqual(STATS_FRAME_VERTICAL_LINES, ((0x34, 0x10, 0x20, 0x01), (0x5C, 0x10, 0x20, 0x01)))
        self.assertEqual(STATS_FRAME_FILL, (0x35, 0x10, 0x27, 0x20, 0x02))
        self.assertEqual(STATS_BARS_BACKGROUND, (0x36, 0x17, 0x25, 0x17, 0x03))
        self.assertEqual(STATS_BAR_RECTS, ((0x37, 0x19, 0x23, 0x05),) * 3)

    def test_compact_stats_fill_colour_matches_original_call_site(self) -> None:
        # The stats-background moveq at memory address $80E8 is file offset
        # $7D64 in the primary SPS 439 executable.
        original = (ROOT / "binaries/BLOODWYCH439").read_bytes()
        self.assertEqual(original[0x7D64 : 0x7D6A], bytes.fromhex("76036100597C"))
        self.assertEqual(STATS_BARS_BACKGROUND[-1], original[0x7D65])

    def test_full_length_avatar_replaces_compact_stats_with_party_hp_bars(self) -> None:
        states = list(self.project.preview_avatar_state_bytes)
        states[2] = self.project.preview_avatar_members[2]
        self.project.preview_avatar_state_bytes = tuple(states)
        bars = self.project.party_shield_status_bars()
        self.assertEqual(len(bars), 3)
        for x, y, width, height, colour in bars:
            self.assertEqual(width, PARTY_SHIELD_STATUS_BAR_WIDTH)
            self.assertLessEqual(height, PARTY_SHIELD_STATUS_BAR_FULL_TERMINAL_HEIGHT + 1)
            self.assertEqual(y + height - 1, PARTY_SHIELD_STATUS_BAR_BASE_Y)
            self.assertIn(colour, PARTY_SHIELD_STATUS_BAR_COLOUR_INDICES)
        self.assertEqual([bar[0] for bar in bars], [0x37, 0x40, 0x49])

    def test_large_avatar_panel_matches_composite_source_routines(self) -> None:
        self.assertEqual(LARGE_AVATAR_PANEL_FILL, (0x00, 0x0A, 0x30, 0x2C, 0x01))
        self.assertEqual(
            LARGE_AVATAR_PANEL_FRAMES,
            (
                (0x01, 0x0B, 0x2E, 0x2A, 0x02),
                (0x02, 0x0C, 0x2C, 0x28, 0x03),
                (0x03, 0x0D, 0x2A, 0x26, 0x04),
            ),
        )
        self.assertEqual(LARGE_AVATAR_RECT, (0x08, 0x11, 0x20, 0x1E))
        self.assertEqual(LARGE_AVATAR_INNER_FRAME, (0x06, 0x0F, 0x24, 0x22, 0x01))

    def test_pockets_tail_has_exact_live_test_addresses(self) -> None:
        self.assertEqual(POCKETS_TRAILING_MEMORY_ADDRESS, 0x54402)
        self.assertEqual(POCKETS_TRAILING_BINARY_OFFSET, 0x5407E)
        self.assertEqual(len(self.project.pockets.trailing_data), 32)

    def test_every_source_reference_has_a_human_label(self) -> None:
        self.assertTrue(SOURCE_REFS)
        self.assertEqual(len({ref.original_label for ref in SOURCE_REFS}), len(SOURCE_REFS))
        original_source = (ROOT / "asm/BLOODWYCH439.asm").read_text(encoding="utf-8")
        for reference in SOURCE_REFS:
            self.assertTrue(reference.original_label.startswith("adr"))
            self.assertFalse(reference.human_label.startswith("adr"))
            self.assertTrue(reference.purpose.endswith("."))
            self.assertIn(f"{reference.original_label}:", original_source)


if __name__ == "__main__":
    unittest.main()

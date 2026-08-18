from pathlib import Path
import unittest

from tools.interface_data import (
    ACTION_ROUTINES,
    ACTION_NAMES,
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
    PARTY_PENDING_PROFESSION_COLOUR_MASK,
    PARTY_PROFESSION_ICON_BASE,
    PARTY_PROFESSION_ICON_POSITIONS,
    PARTY_SELECTED_PROFESSION_FRAMES,
    STATS_SCROLL_RETURN_HITBOX,
    RIGHT_STATUS_ICON_BEVEL_LINES,
    COMPACT_STATS_BAR_COUNT,
    COPPER_FRAME_WRAP_Y,
    COPPER_PLAYER_RASTER_SPLIT_Y,
    DIALOGUE_TEXT_PALETTE_INDEX,
    DUNGEON_VIEW_RECT,
    GFX_POCKETS_CHAIN_COMMAND_OFFSET,
    GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET,
    GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET,
    GFX_POCKETS_SELECTED_PARTY_SHIELD_OFFSET,
    INTERFACE_ACTION_LOAD_SAVE,
    INTERFACE_ACTION_PARTY_MEMBER_FIRST,
    INTERFACE_ACTION_PARTY_MEMBER_LAST,
    INTERFACE_ACTION_PARTY_COMMAND_MODE,
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
                "avatars": 4,
                "inventory": 4,
                "stats_scroll": 1,
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
        self.assertEqual(len(self.project.mode_hitboxes(modes["main"])), 24)
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
            [],
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
            self.project.pockets.icon(0x77).pixels,
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

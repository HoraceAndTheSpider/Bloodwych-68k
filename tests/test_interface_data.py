from pathlib import Path
import unittest

from tools.interface_data import (
    ACTION_NAMES,
    COMPACT_STATS_BAR_COUNT,
    COPPER_FRAME_WRAP_Y,
    COPPER_PLAYER_RASTER_SPLIT_Y,
    DIALOGUE_TEXT_PALETTE_INDEX,
    DUNGEON_VIEW_RECT,
    GFX_POCKETS_CHAIN_COMMAND_OFFSET,
    GFX_POCKETS_CHAIN_CONTINUOUS_OFFSET,
    GFX_POCKETS_CHAIN_WITH_AVATARS_OFFSET,
    GFX_POCKETS_SELECTED_PARTY_SHIELD_OFFSET,
    INTERFACE_MODES,
    PLAYER_POINTER_Y_OFFSETS,
    PLAYER_COMPACT_STATS_COLOUR_INDICES,
    PLAYER_DATA_UI_PRIMARY_COLOUR_OFFSET,
    PLAYER_DATA_UI_SECONDARY_COLOUR_OFFSET,
    PLAYER_SCREEN_BYTE_OFFSETS,
    PLAYER_UI_PRIMARY_COLOUR_INDICES,
    PLAYER_UI_SECONDARY_COLOUR_INDICES,
    POCKETS_TRAILING_BINARY_OFFSET,
    POCKETS_TRAILING_MEMORY_ADDRESS,
    SOURCE_REFS,
    InterfaceProject,
    amiga_colour_to_rgb,
    colour_ramp_index,
    replace_colour_nibble,
    remap_ui_template_colour,
    screen_byte_offset_to_xy,
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
            {"main": 17, "command": 6, "display": 3},
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

    def test_interface_modes_select_the_expected_hitbox_groups(self) -> None:
        modes = {mode.key: mode for mode in INTERFACE_MODES}
        self.assertEqual(modes["main"].hitbox_groups, ("main", "display"))
        self.assertEqual(modes["comms"].hitbox_groups, ("command",))
        self.assertEqual(len(self.project.mode_hitboxes(modes["main"])), 20)
        self.assertEqual(
            [item.action for item in self.project.mode_hitboxes(modes["inventory"])],
            [0, 1, 2, 3],
        )
        self.assertEqual(
            [item.action for item in self.project.mode_hitboxes(modes["comms"])],
            list(range(0x1C, 0x22)),
        )

    def test_observed_main_layout_uses_the_native_dungeon_rectangle(self) -> None:
        self.assertEqual(DUNGEON_VIEW_RECT, (96, 10, 128, 76))
        self.assertEqual(len(self.project.dungeon_preview), 76)
        self.assertTrue(all(len(row) == 128 for row in self.project.dungeon_preview))

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
        self.assertEqual(PLAYER_UI_PRIMARY_COLOUR_INDICES, (0x07, 0x09))
        self.assertEqual(PLAYER_UI_SECONDARY_COLOUR_INDICES, (0x08, 0x0C))
        self.assertEqual(COMPACT_STATS_BAR_COUNT, 3)
        self.assertEqual(PLAYER_COMPACT_STATS_COLOUR_INDICES, (0x07, 0x0C))
        self.assertEqual(COPPER_PLAYER_RASTER_SPLIT_Y, 0x98)
        self.assertEqual(COPPER_FRAME_WRAP_Y, 0xFF)

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

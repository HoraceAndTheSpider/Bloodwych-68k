import unittest

from tools.spellbook import (
    SPELL_COST_VALUES,
    SPELL_NAMES,
    can_decrease_cast_power,
    can_increase_cast_power,
    format_spell_points,
    spell_cast_bar_width,
    spell_cast_score,
    spellbook_cost,
    spellbook_magic_class_index,
    spellbook_selection,
)


class SpellBookTests(unittest.TestCase):
    def test_source_tables_cover_all_32_fixed_spell_records(self) -> None:
        self.assertEqual(len(SPELL_NAMES), 32)
        self.assertEqual(len(SPELL_COST_VALUES), 32)
        self.assertEqual(SPELL_NAMES[12], "CONFUSE")
        self.assertEqual(SPELL_NAMES[31], "MINDROCK")

    def test_display_cost_matches_c688c_base_formula(self) -> None:
        self.assertEqual(spellbook_cost(0), 4)
        self.assertEqual(spellbook_cost(12), 6)
        self.assertEqual(spellbook_cost(31), 10)
        self.assertEqual(spellbook_cost(12, 2), 12)
        self.assertEqual(spellbook_cost(12, -3), 3)

    def test_selection_is_display_ready_and_uses_source_class_order(self) -> None:
        selection = spellbook_selection(12)
        self.assertEqual((selection.name, selection.magic_class, selection.cost), ("CONFUSE", 3, 6))
        self.assertEqual(spellbook_magic_class_index(0), 0)
        self.assertEqual(spellbook_magic_class_index(3), 3)

    def test_spell_points_are_always_two_digits(self) -> None:
        self.assertEqual(format_spell_points(3, 6), "03/06")
        self.assertEqual(format_spell_points(15, 15), "15/15")

    def test_cast_power_stops_before_the_source_99_point_limit(self) -> None:
        self.assertTrue(can_increase_cast_power(0, 11))
        self.assertFalse(can_increase_cast_power(0, 12))
        self.assertFalse(can_increase_cast_power(24, 11))

    def test_cast_power_can_reduce_a_spell_to_one_point_but_no_lower(self) -> None:
        # Magelock has base cost 6. C688C accepts byte $14=-5 (cost 1), then
        # increments it back if another decrement would calculate cost 0.
        self.assertEqual(spellbook_cost(5, -5), 1)
        self.assertTrue(can_decrease_cast_power(5, -4))
        self.assertFalse(can_decrease_cast_power(5, -5))

    def test_starting_spells_have_source_derived_nonzero_cast_bars(self) -> None:
        murlock_terror = spell_cast_score(
            1, champion_index=1, level=1, cooldown=0, pocket_items=bytes(16)
        )
        blodwyn_armour = spell_cast_score(
            0, champion_index=0, level=1, cooldown=0, pocket_items=bytes(16)
        )
        self.assertEqual((murlock_terror, spell_cast_bar_width(murlock_terror)), (-8, 43))
        self.assertEqual((blodwyn_armour, spell_cast_bar_width(blodwyn_armour)), (-11, 26))

    def test_cast_power_directly_increases_the_cast_score(self) -> None:
        base = spell_cast_score(
            1, champion_index=1, level=1, cooldown=0, pocket_items=bytes(16)
        )
        boosted = spell_cast_score(
            1, champion_index=1, level=1, cooldown=0, pocket_items=bytes(16),
            cast_adjustment=3,
        )
        self.assertEqual((base, boosted), (-8, -5))
        self.assertGreater(spell_cast_bar_width(boosted), spell_cast_bar_width(base))

    def test_source_practice_curves_differ_by_spell_match(self) -> None:
        # C67D8 starts matching spells at 5 successes/shift 0, while C67E0
        # starts non-matching spells at 10 successes/shift 1.
        matching = spell_cast_score(
            1, champion_index=1, level=0, cooldown=0, pocket_items=bytes(16),
            spell_practice=9,
        )
        nonmatching = spell_cast_score(
            1, champion_index=0, level=0, cooldown=0, pocket_items=bytes(16),
            spell_practice=9,
        )
        self.assertEqual(matching, -3)  # +5 class, +5, then (9 - 5) / 2, minus 15.
        self.assertEqual(nonmatching, -11)  # 9 / 2, minus 15.

    def test_spell_practice_accepts_the_source_byte_maximum(self) -> None:
        score = spell_cast_score(
            1, champion_index=1, level=0, cooldown=0, pocket_items=bytes(16),
            spell_practice=0xFF,
        )
        self.assertEqual(score, 18)

    def test_matching_wand_uses_the_matching_practice_curve(self) -> None:
        # Terror is Chaos; Blodwyn is Serpent. Object $58 is the Chaos wand.
        score = spell_cast_score(
            1, champion_index=0, level=0, cooldown=0,
            pocket_items=bytes((0x58, 0)) + bytes(14), spell_practice=9,
        )
        self.assertEqual(score, -5)  # +3 wand, +5, then (9 - 5) / 2, minus 15.

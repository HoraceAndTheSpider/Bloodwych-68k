import unittest

from tools.spellbook import (
    SPELL_COST_VALUES,
    SPELL_NAMES,
    format_spell_points,
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

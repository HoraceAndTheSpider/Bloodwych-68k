import unittest

from tools.champion_inventory import (
    CHAMPION_INVENTORY_SIZE,
    INVENTORY_ARMOUR_BAR_RECT,
    INVENTORY_HELD_SLOT_POSITION,
    INVENTORY_NAME_BAR_RECT,
    INVENTORY_PARTY_ORIGIN,
    INVENTORY_SELECTED_SLOT_FRAME,
    INVENTORY_SLOT_ORIGIN,
    champion_armour_level,
    champion_armour_modifier_text,
)


class _Record:
    def __init__(self, values: dict[int, int]):
        self.values = values

    def byte(self, offset: int) -> int:
        return self.values.get(offset, 0)


class ChampionInventoryTests(unittest.TestCase):
    def test_source_coordinates_cover_the_inventory_panel(self) -> None:
        self.assertEqual(CHAMPION_INVENTORY_SIZE, (96, 89))
        self.assertEqual(INVENTORY_NAME_BAR_RECT, (2, 17, 94, 8))
        self.assertEqual(INVENTORY_SLOT_ORIGIN, (0, 25))
        self.assertEqual(INVENTORY_ARMOUR_BAR_RECT, (1, 57, 95, 8))
        self.assertEqual(INVENTORY_PARTY_ORIGIN, (0, 65))
        self.assertEqual(INVENTORY_HELD_SLOT_POSITION, (64, 65))
        self.assertEqual(INVENTORY_SELECTED_SLOT_FRAME, (1, 66, 16, 15))

    def test_armour_level_matches_the_source_equipment_order(self) -> None:
        record = _Record({0x0B: 4, 0x11: 0x18, 0x12: 0x2D})
        pockets = bytes((0, 0, 0x1D, 0x26)) + bytes(12)
        # base 4 -> body $1D gives 7 -> hand $2D adds 2 -> shield $26 adds 4.
        self.assertEqual(champion_armour_level(record, pockets), 13)
        self.assertEqual(champion_armour_modifier_text(record, pockets), "-03")

    def test_spell_armour_applies_only_when_the_low_bits_are_clear(self) -> None:
        protected = _Record({0x0B: 2, 0x11: 0x28})
        enchanted = _Record({0x0B: 2, 0x11: 0x29})
        empty_pockets = bytes(16)
        self.assertEqual(champion_armour_level(protected, empty_pockets), 5)
        self.assertEqual(champion_armour_level(enchanted, empty_pockets), 2)


if __name__ == "__main__":
    unittest.main()

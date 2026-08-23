import unittest

from tools.champion_inventory import (
    CHAMPION_INVENTORY_SIZE,
    INVENTORY_ARMOUR_BAR_RECT,
    INVENTORY_ARMOUR_TEXT_Y,
    INVENTORY_EMPTY_POCKET_PICTURE,
    INVENTORY_EXIT_PICTURE,
    INVENTORY_EXIT_SLOT_POSITION,
    INVENTORY_HELD_SLOT_POSITION,
    INVENTORY_INGAME_CONTENT_RECT,
    INVENTORY_NAME_BAR_RECT,
    INVENTORY_PARTY_ORIGIN,
    INVENTORY_SELECTION_TITLE_Y,
    INVENTORY_SELECTED_SLOT_FRAME,
    INVENTORY_SLOT_ORIGIN,
    INVENTORY_QUANTITY_X_OFFSET,
    champion_armour_level,
    champion_armour_modifier_text,
    inventory_object_quantity,
    visible_inventory_object_code,
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
        self.assertEqual(INVENTORY_SELECTION_TITLE_Y, 19)
        self.assertEqual(INVENTORY_SLOT_ORIGIN, (0, 25))
        self.assertEqual(INVENTORY_ARMOUR_BAR_RECT, (1, 57, 95, 8))
        self.assertEqual(INVENTORY_ARMOUR_TEXT_Y, 59)
        self.assertEqual(INVENTORY_PARTY_ORIGIN, (0, 65))
        self.assertEqual(INVENTORY_HELD_SLOT_POSITION, (64, 65))
        self.assertEqual(INVENTORY_EXIT_SLOT_POSITION, (80, 65))
        self.assertEqual(INVENTORY_SELECTED_SLOT_FRAME, (1, 66, 16, 15))
        self.assertEqual(INVENTORY_INGAME_CONTENT_RECT, (0, 22, 96, 60))
        self.assertEqual(INVENTORY_EMPTY_POCKET_PICTURE, 0x00)
        self.assertEqual(INVENTORY_EXIT_PICTURE, 0x74)
        self.assertEqual(INVENTORY_QUANTITY_X_OFFSET, 0)

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

    def test_counted_objects_read_their_shared_quantity_bytes(self) -> None:
        # Forced duplicate coin and arrow slots must all read their one shared
        # counter, exactly as adrCd00CA38/adrCd00CAA6 do in the game.
        pockets = bytes((0x01, 0x01, 0x03, 0x04, 0x2B)) + bytes(7) + bytes(
            (7, 19, 42, 99)
        )
        self.assertEqual(inventory_object_quantity(pockets, 0x01), 7)
        self.assertEqual(inventory_object_quantity(pockets, 0x02), 19)
        self.assertEqual(inventory_object_quantity(pockets, 0x03), 42)
        self.assertEqual(inventory_object_quantity(pockets, 0x04), 99)
        self.assertIsNone(inventory_object_quantity(pockets, 0x05))
        self.assertEqual(
            tuple(visible_inventory_object_code(pockets, slot) for slot in range(5)),
            (0x01, 0x01, 0x03, 0x04, 0x2B),
        )

    def test_zero_shared_quantity_is_rendered_as_an_empty_slot(self) -> None:
        pockets = bytes((0x01,)) + bytes(11) + bytes((0, 1, 1, 1))
        self.assertEqual(visible_inventory_object_code(pockets, 0), 0)


if __name__ == "__main__":
    unittest.main()

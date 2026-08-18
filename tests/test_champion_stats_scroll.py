import unittest

from tools.champion_stats_scroll import (
    CHAMPION_FOOD_BAR_RECT,
    CHAMPION_FOOD_END_CAP_Y,
    CHAMPION_FOOD_TEXT_Y,
    CHAMPION_STATS_TEXT_Y,
    champion_food_bar_width,
)


class ChampionStatsScrollTests(unittest.TestCase):
    def test_food_bar_uses_click_show_stats_source_geometry(self) -> None:
        self.assertEqual(CHAMPION_FOOD_BAR_RECT, (25, 65, 48, 5))
        self.assertEqual(champion_food_bar_width(0), 0)
        self.assertEqual(champion_food_bar_width(0xC7), 48)
        self.assertEqual(champion_food_bar_width(0xFF), 48)

    def test_text_stream_rows_use_the_native_eight_pixel_cadence(self) -> None:
        self.assertEqual(CHAMPION_STATS_TEXT_Y, (16, 24, 32, 40, 48))
        self.assertEqual((CHAMPION_FOOD_TEXT_Y, CHAMPION_FOOD_END_CAP_Y), (56, 64))


if __name__ == "__main__":
    unittest.main()

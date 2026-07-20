from __future__ import annotations

import unittest

from tools.gamefont_converter import EXPECTED_SIZE, glyph_pixels, read_font
from tools.st_planar_assets import decode_planar, encode_planar, read_tables
from tools.tool_common import DATA_DIR


GFX_DIR = DATA_DIR / "BLOODWYCH439-clean" / "gfx"


class GraphicsCodecTests(unittest.TestCase):
    def test_gamefont_layout_and_known_a_glyph(self) -> None:
        data = read_font(GFX_DIR / "GameFont")
        self.assertEqual(len(data), EXPECTED_SIZE)
        self.assertEqual(
            data[ord("A") * 5 : (ord("A") + 1) * 5],
            bytes.fromhex("0c123f2133"),
        )
        self.assertEqual(len(glyph_pixels(data, ord("A"))), 5)

    def test_main_walls_tables_partition_and_round_trip(self) -> None:
        gfx, offsets, positions = read_tables(
            GFX_DIR / "Main_Walls.gfx",
            GFX_DIR / "Main_Walls.offsets",
            GFX_DIR / "Main_Walls.positions",
        )
        self.assertEqual(len(offsets), 28)
        self.assertEqual(len(positions), 28)

        for index, (offset, (_, _, width_minus_1, height_minus_1)) in enumerate(
            zip(offsets, positions)
        ):
            width_words = width_minus_1 + 1
            height = height_minus_1 + 1
            end = offsets[index + 1] if index + 1 < len(offsets) else len(gfx)
            raw = gfx[offset:end]
            self.assertEqual(len(raw), width_words * height * 8)
            self.assertEqual(encode_planar(decode_planar(raw, width_words, height)), raw)


if __name__ == "__main__":
    unittest.main()

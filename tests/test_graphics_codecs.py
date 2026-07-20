from __future__ import annotations

import unittest

from tools.gamefont_converter import EXPECTED_SIZE, glyph_pixels, read_font
from tools.graphics_preview import (
    BeholderAssets,
    decode_fixed_sprites,
    load_floor_ceiling_background,
    remap_template_colours,
    render_beholder,
)
from tools.st_planar_assets import decode_planar, encode_planar, read_tables
from tools.graphics_viewer import MONSTERS, inspect_monster_files
from tools.tool_common import DATA_DIR


GFX_DIR = DATA_DIR / "BLOODWYCH439-clean" / "gfx"
MONSTERS_DIR = DATA_DIR / "BLOODWYCH439-clean" / "monsters"


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

    def test_large_and_shield_avatars_partition_and_round_trip(self) -> None:
        large = decode_fixed_sprites(
            GFX_DIR / "Avatars_Large.gfx",
            width_words=2,
            height=30,
            count=16,
            name_prefix="large",
        )
        shield = decode_fixed_sprites(
            GFX_DIR / "Shield_Avatars.gfx",
            width_words=2,
            height=16,
            count=16,
            name_prefix="shield",
        )
        self.assertEqual([(sprite.width, sprite.height) for sprite in large], [(32, 30)] * 16)
        self.assertEqual([(sprite.width, sprite.height) for sprite in shield], [(32, 16)] * 16)
        self.assertEqual(
            b"".join(encode_planar(sprite.pixels) for sprite in large),
            (GFX_DIR / "Avatars_Large.gfx").read_bytes(),
        )
        self.assertEqual(
            b"".join(encode_planar(sprite.pixels) for sprite in shield),
            (GFX_DIR / "Shield_Avatars.gfx").read_bytes(),
        )

    def test_new_beholder_split_preserves_old_block_and_partitions(self) -> None:
        old_block = b"".join(
            (MONSTERS_DIR / f"Beholder_{index:02d}.gfx").read_bytes()
            for index in range(1, 11)
        )
        new_block = b"".join(
            (MONSTERS_DIR / filename).read_bytes()
            for filename in (
                "Beholder_Body.gfx",
                "Beholder_UpperEyes.gfx",
                "Beholder_CentralEye_Near.gfx",
                "Beholder_CentralEye_Far.gfx",
            )
        )
        self.assertEqual(new_block, old_block)

        assets = BeholderAssets(MONSTERS_DIR)
        self.assertEqual(
            [len(assets.body), len(assets.upper), len(assets.near), len(assets.far)],
            [6, 4, 16, 4],
        )
        for sprite in assets.all_sprites():
            source = (MONSTERS_DIR / sprite.source_file).read_bytes()
            self.assertEqual(
                encode_planar(sprite.pixels),
                source[sprite.byte_offset : sprite.byte_offset + sprite.byte_size],
            )

    def test_beholder_colour_substitution_matches_template_indices(self) -> None:
        pixels = [[0, 1, 4, 5, 8, 9, 12, 13, 15]]
        self.assertEqual(
            remap_template_colours(pixels, [2, 3, 6, 7]),
            [[2, 1, 3, 5, 6, 9, 7, 13, 15]],
        )

    def test_beholder_previews_are_native_game_window_size(self) -> None:
        background = load_floor_ceiling_background(GFX_DIR)
        self.assertEqual((len(background[0]), len(background)), (128, 76))
        assets = BeholderAssets(MONSTERS_DIR)
        for distance in range(6):
            for facing in range(4):
                pixels, metadata = render_beholder(background, assets, distance, facing)
                self.assertEqual((len(pixels[0]), len(pixels)), (128, 76))
                self.assertEqual(metadata["distance"], distance)
                self.assertEqual(metadata["facing"], facing)

    def test_floor_ceiling_native_layout_matches_draw_routine(self) -> None:
        source = decode_planar((GFX_DIR / "FloorCeiling.gfx").read_bytes(), 8, 57)
        background = load_floor_ceiling_background(GFX_DIR)
        self.assertEqual(background[:23], source[:23])
        self.assertEqual(background[23:42], [[0] * 128 for _ in range(19)])
        self.assertEqual(background[42:], source[23:])

    def test_beholder_accepts_the_games_screen_anchor(self) -> None:
        background = load_floor_ceiling_background(GFX_DIR)
        assets = BeholderAssets(MONSTERS_DIR)
        _pixels, metadata = render_beholder(
            background,
            assets,
            2,
            0,
            anchor_x=74,
            anchor_y=36,
        )
        self.assertEqual(metadata["positioning_mode"], "game-anchor")
        self.assertEqual(metadata["requested_game_anchor"], [74, 36])
        self.assertEqual(metadata["anchor_shift"], [74, 36])

    def test_monster_file_status_reports_pending_renderers(self) -> None:
        beholder = next(monster for monster in MONSTERS if monster.code == 0x66)
        summon = next(monster for monster in MONSTERS if monster.code == 0x64)
        self.assertTrue(inspect_monster_files(beholder, MONSTERS_DIR).ready)
        summon_status = inspect_monster_files(summon, MONSTERS_DIR)
        self.assertEqual(summon_status.existing_gfx, ("Summon.gfx",))
        self.assertIn("Summon.offsets", summon_status.missing_companions)


if __name__ == "__main__":
    unittest.main()

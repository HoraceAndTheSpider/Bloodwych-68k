"""Shared large-monster design data and source-scale preview regression tests."""

from pathlib import Path
from tempfile import TemporaryDirectory
import unittest

from tools.edit_session import EditSession
from tools.graphics_viewer import MONSTERS, load_renderer_assets, render_monster_preview
from tools.map_editor.app import (
    MONSTER_DESIGN_PREVIEW_DISTANCES, crop_indexed_pixels, monster_design_preview_layout,
)
from tools.map_editor.model import MapProject


ROOT = Path(__file__).resolve().parents[1]
CLEAN = ROOT / "data/BLOODWYCH439-clean"


class MonsterDesignTests(unittest.TestCase):
    def test_all_source_monsters_fit_with_one_scale_and_no_overlap(self):
        assets, _ = load_renderer_assets(CLEAN / "monsters")
        for monster in MONSTERS:
            with self.subTest(monster=monster.name):
                sizes = []
                for distance in MONSTER_DESIGN_PREVIEW_DISTANCES:
                    pixels, _ = render_monster_preview(
                        [[0] * 256 for _ in range(256)], monster, assets,
                        distance=distance, facing=0, grade_step=0, animation_frame=0,
                        anchor_x=128, anchor_y=128,
                    )
                    pixels = crop_indexed_pixels(pixels)
                    sizes.append((len(pixels[0]), len(pixels)))
                scale, boxes = monster_design_preview_layout(sizes, (380, 208))
                self.assertIn(scale, (2, 3))
                self.assertEqual(len(boxes), 5)
                for i, ((w, h), (x, y, bw, bh)) in enumerate(zip(sizes, boxes)):
                    self.assertGreaterEqual(x, 0)
                    self.assertGreaterEqual(y, 0)
                    self.assertLessEqual(x + bw, 380)
                    self.assertLessEqual(y + bh, 208)
                    self.assertLessEqual(w * scale + 8, bw)
                    self.assertLessEqual(h * scale + 18, bh)
                    for ox, oy, ow, oh in boxes[i + 1:]:
                        self.assertTrue(x + bw <= ox or ox + ow <= x
                                        or y + bh <= oy or oy + oh <= y)
                # The source's equal-sized near views remain equal; farther
                # views cannot become larger through per-slot auto-fitting.
                self.assertGreaterEqual(sizes[0][1] * scale, sizes[2][1] * scale)

    def test_layout_rejects_clipping_even_at_native_size(self):
        with self.assertRaises(ValueError):
            monster_design_preview_layout([(400, 100)], (380, 208))

    def test_grade_selector_and_ink_edit_preserve_unrelated_bytes(self):
        project = MapProject.from_extracted(CLEAN)
        lookup, palettes = project.monster_grade_design(0x69)
        selected = (lookup[0] + 1) % len(palettes)
        original_palette_bytes = project.resource_bytes("monsters/monsters.palette")
        original_monsters = project.resource_bytes("maps/mod0.monsters")
        project.set_monster_grade_palette(0x69, 0, selected)
        changed, _ = project.monster_grade_design(0x6A)
        self.assertEqual(changed, bytes([selected]) + lookup[1:])
        self.assertEqual(project.resource_bytes("monsters/monsters.palette"), original_palette_bytes)
        ink = (palettes[selected][2] + 1) % 16
        project.set_monster_palette_ink(0x69, selected, 2, ink)
        expected = bytearray(original_palette_bytes)
        expected[selected * 4 + 2] = ink
        self.assertEqual(project.resource_bytes("monsters/monsters.palette"), bytes(expected))
        self.assertEqual(project.monster_grade_design(0x67)[1][selected][2], ink)
        self.assertEqual(project.resource_bytes("maps/mod0.monsters"), original_monsters)
        self.assertEqual(project.dirty_resources, {"monsters/dragon.colours", "monsters/monsters.palette"})

    def test_expanded_counts_are_derived_from_resources(self):
        project = MapProject.from_extracted(CLEAN)
        project.resource_data["monsters/beholder.colours"] = bytearray(range(16))
        project.resource_data["monsters/monsters.palette"] = bytearray([0, 1, 2, 3] * 20)
        project.set_monster_grade_palette(0x66, 15, 19)
        project.set_monster_palette_ink(0x66, 19, 3, 14)
        lookup, palettes = project.monster_grade_design(0x66)
        self.assertEqual((len(lookup), len(palettes)), (16, 20))
        self.assertEqual(lookup[15], 19)
        self.assertEqual(palettes[19], (0, 1, 2, 14))

    def test_invalid_edits_and_save_edits_fail_without_mutation(self):
        project = MapProject.from_extracted(CLEAN)
        for form, grade, palette in ((0x6B, 0, 0), (0x66, -1, 0), (0x66, 0, 256)):
            with self.assertRaises(ValueError):
                project.set_monster_grade_palette(form, grade, palette)
        with self.assertRaises(ValueError):
            project.set_monster_palette_ink(0x66, 0, 4, 1)
        with self.assertRaises(ValueError):
            project.set_monster_palette_ink(0x66, 0, 1, 16)
        self.assertFalse(project.dirty_resources)
        project.save_data = bytearray(10)
        with self.assertRaisesRegex(ValueError, "portable save"):
            project.set_monster_grade_palette(0x66, 0, 0)
        with self.assertRaisesRegex(ValueError, "portable save"):
            project.set_monster_palette_ink(0x66, 0, 1, 1)
        self.assertFalse(project.dirty_resources)

    def test_session_reload_refreshes_cached_and_dynamic_palettes_without_export(self):
        with TemporaryDirectory() as directory:
            session = EditSession(modified_root=Path(directory) / "modified")
            project = MapProject.from_session(session)
            project.set_monster_grade_palette(0x66, 0, 12)
            project.set_monster_grade_palette(0x67, 0, 12)
            project.set_monster_palette_ink(0x66, 12, 1, 14)
            project.sync_session()
            assets, _ = load_renderer_assets(session.root / "monsters")
            expected = list(project.monster_grade_design(0x66)[1][12])
            self.assertEqual(assets["beholder"].replacement_palette(0), expected)
            self.assertEqual(assets["behemoth"].replacement_palette(0), expected)
            self.assertFalse((Path(directory) / "modified").exists())


if __name__ == "__main__":
    unittest.main()

from __future__ import annotations

from pathlib import Path
import unittest

from tools.savegame_overlay import savegame_overlay_root


PROJECT_ROOT = Path(__file__).resolve().parents[1]
CLEAN_ROOT = PROJECT_ROOT / "data" / "BLOODWYCH439-clean"
SAVE_PATH = PROJECT_ROOT / "whdload" / "bloodsave0"


class SavegameOverlayTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.root = savegame_overlay_root(CLEAN_ROOT, SAVE_PATH)

    def test_saved_champion_stats_replace_the_extracted_resource(self) -> None:
        saved = (self.root / "data/champions.stats").read_bytes()
        extracted = (CLEAN_ROOT / "data/champions.stats").read_bytes()

        self.assertEqual(saved, SAVE_PATH.read_bytes()[: len(saved)])
        self.assertNotEqual(saved, extracted)

    def test_resources_outside_the_save_slice_fall_back_to_clean_data(self) -> None:
        resource = "data/objectdefinitions.block"
        self.assertEqual(
            (self.root / resource).read_bytes(),
            (CLEAN_ROOT / resource).read_bytes(),
        )


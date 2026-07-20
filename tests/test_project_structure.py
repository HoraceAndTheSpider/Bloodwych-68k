from __future__ import annotations

import unittest

from tools.tool_common import (
    ASM_DIR,
    DATA_DIR,
    DEFAULT_SEGMENTS_FILE,
    PROFILES,
    ToolError,
    asm_path,
    get_profile,
    load_segments,
    parse_int,
)


class ProjectStructureTests(unittest.TestCase):
    def test_configured_binary_names(self) -> None:
        self.assertEqual(
            [profile.filename for profile in PROFILES],
            [
                "BLOODWYCH439",
                "BLOODWYCH102",
                "BLOODWYCH1927",
                "BEXT43",
                "AtariST_DEMO_CODE",
            ],
        )

    def test_profile_alias_and_canonical_data_path(self) -> None:
        profile = get_profile("BLOODWYCH439")
        self.assertEqual(profile.filename, "BLOODWYCH439")
        self.assertEqual(profile.clean_dir, DATA_DIR / "BLOODWYCH439-clean")

    def test_439_asm_file_conventions(self) -> None:
        self.assertEqual(asm_path("BLOODWYCH439"), ASM_DIR / "Bloodwych439.asm")
        self.assertEqual(
            asm_path("BLOODWYCH439", "relabel"),
            ASM_DIR / "BLOODWYCH439_relabel.asm",
        )
        self.assertEqual(
            asm_path("BLOODWYCH439", "data"),
            ASM_DIR / "BLOODWYCH439_relabel_data.asm",
        )

    def test_parse_int(self) -> None:
        self.assertEqual(parse_int("$4C37E"), 0x4C37E)
        self.assertEqual(parse_int("0x4C37E"), 0x4C37E)
        self.assertEqual(parse_int(312190), 312190)
        self.assertIsNone(parse_int(""))

    def test_segments_workbook_uses_439_sheet(self) -> None:
        frame = load_segments(DEFAULT_SEGMENTS_FILE, "Bloodwych439")
        self.assertGreater(len(frame), 2600)
        self.assertTrue({"label", "relabel", "name", "offset", "size"} <= set(frame.columns))

    def test_unmapped_profile_is_explicit(self) -> None:
        with self.assertRaisesRegex(ToolError, "No segments.xlsx sheet"):
            load_segments(DEFAULT_SEGMENTS_FILE, "BLOODWYCH102")


if __name__ == "__main__":
    unittest.main()

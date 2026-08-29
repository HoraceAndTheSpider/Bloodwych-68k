from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import pandas as pd

from tools.source_notes import (
    SourceNote,
    apply_source_notes,
    load_source_note_metadata,
)
from tools.tool_common import ToolError


def source_note(**overrides: object) -> SourceNote:
    values: dict[str, object] = {
        "profile": "BLOODWYCH439",
        "scope_start": "CopyProtection",
        "scope_end": "ProtectionState",
        "source_match": ";fiX Label expected",
        "source_comment": "COPY_PROTECTION_INTERNAL ($D140): Retain as raw words.",
        "expected_matches": 1,
        "status": "verified",
        "notes": "",
    }
    values.update(overrides)
    return SourceNote(**values)


class SourceNoteTests(unittest.TestCase):
    def setUp(self) -> None:
        self.lines = [
            "CopyProtection:",
            "\tbra\tProtectionEntry",
            ";fiX Label expected",
            "\tdc.w\t$0000\t;0000",
            "ProtectionState:",
            "\tdc.w\t$0000\t;0000",
        ]

    def test_note_is_inserted_after_marker_without_changing_data(self) -> None:
        result = apply_source_notes(self.lines, (source_note(),))

        self.assertEqual(result[2], ";fiX Label expected")
        self.assertEqual(
            result[3],
            "; SOURCE_NOTE: COPY_PROTECTION_INTERNAL ($D140): Retain as raw words.",
        )
        self.assertEqual(result[4], "\tdc.w\t$0000\t;0000")

    def test_existing_generated_note_is_replaced_on_rerun(self) -> None:
        first = apply_source_notes(self.lines, (source_note(),))
        replacement = source_note(
            source_comment="COPY_PROTECTION_INTERNAL ($D140): Updated note."
        )

        result = apply_source_notes(first, (replacement,))

        self.assertEqual(
            result.count(
                "; SOURCE_NOTE: COPY_PROTECTION_INTERNAL ($D140): Updated note."
            ),
            1,
        )
        self.assertFalse(any("Retain as raw words" in line for line in result))

    def test_wrong_match_count_fails_without_mutating_input(self) -> None:
        original = list(self.lines)
        with self.assertRaisesRegex(ToolError, "expected 2 match"):
            apply_source_notes(
                self.lines,
                (source_note(expected_matches=2),),
            )
        self.assertEqual(self.lines, original)

    def test_loader_reads_cleanup_sheet(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            segments = root / "segments.xlsx"
            cleanup = root / "cleanup.xlsx"
            segments.touch()
            pd.DataFrame(
                (
                    {
                        "profile": "BLOODWYCH439",
                        "scope_start": "CopyProtection",
                        "scope_end": "ProtectionState",
                        "source_match": ";fiX Label expected",
                        "source_comment": "COPY_PROTECTION_INTERNAL ($D140): Retain.",
                        "expected_matches": 1,
                        "status": "verified",
                        "notes": "Static protection analysis.",
                    },
                )
            ).to_excel(cleanup, sheet_name="SOURCE_NOTES", index=False)

            notes = load_source_note_metadata(
                segments, "BLOODWYCH439", cleanup
            )

            self.assertEqual(len(notes), 1)
            self.assertEqual(notes[0].scope_start, "CopyProtection")
            self.assertEqual(notes[0].expected_matches, 1)


if __name__ == "__main__":
    unittest.main()

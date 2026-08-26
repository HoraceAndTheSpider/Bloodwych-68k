from __future__ import annotations

import pandas as pd
import unittest

from tools.source_comments import apply_source_comments


class SourceCommentTests(unittest.TestCase):
    def test_address_comment_prefers_binary_position_and_is_idempotent(self):
        frame = pd.DataFrame(
            [
                {
                    "label": "adrCd0034FE",
                    "relabel": "NewName",
                    "BW439 Position": "$3000",
                    "source_comment": "",
                }
            ]
        )
        lines = ["NewName:", "\trts"]

        once = apply_source_comments(lines, frame)
        twice = apply_source_comments(once, frame)

        self.assertEqual(once, twice)
        self.assertEqual(
            once,
            [
                "NewName:\t\t; Memory Address ($3384) and binary offset [$3000]",
                "\trts",
            ],
        )

    def test_address_comment_uses_original_hex_suffix_when_position_is_missing(self):
        frame = pd.DataFrame(
            [{"label": "adrCd0034FE", "relabel": "NewName"}]
        )

        self.assertEqual(
            apply_source_comments(["NewName:", "\trts"], frame),
            [
                "NewName:\t\t; Memory Address ($34FE) and binary offset [$317A]",
                "\trts",
            ],
        )

    def test_address_comment_does_not_claim_unknown_locations(self):
        frame = pd.DataFrame([{"label": "NamedRoutine", "relabel": "NewName"}])

        self.assertEqual(
            apply_source_comments(["NewName:   ", "\trts"], frame),
            ["NewName:   ", "\trts"],
        )

    def test_source_comments_are_idempotent_and_preserve_handwritten_comments(self):
        frame = pd.DataFrame(
            [
                {
                    "label": "adrB_001000",
                    "relabel": "Monster_Table",
                    "source_comment": "Maps view slots.\n$FF means hidden.",
                }
            ]
        )
        lines = [
            "Monster_Table:",
            "\t; handwritten note",
            "\tdc.b\t$00",
        ]

        once = apply_source_comments(lines, frame)
        twice = apply_source_comments(once, frame)

        self.assertEqual(once, twice)
        self.assertEqual(
            once,
            [
                "Monster_Table:\t\t; Memory Address ($1000) and binary offset [$0C7C]",
                "\t; Maps view slots.",
                "\t; $FF means hidden.",
                "\t; handwritten note",
                "\tdc.b\t$00",
            ],
        )

    def test_blank_comment_removes_only_previous_generated_comment(self):
        frame = pd.DataFrame(
            [{"label": "Table", "relabel": "Table", "source_comment": ""}]
        )
        lines = [
            "Table:",
            "\t; ReSource: stale text",
            "\t; handwritten note",
            "\tdc.b\t$00",
        ]

        self.assertEqual(
            apply_source_comments(lines, frame),
            [
                "Table:",
                "\t; handwritten note",
                "\tdc.b\t$00",
            ],
        )

    def test_missing_data_append_label_is_ignored_until_inspect_emits_it(self):
        frame = pd.DataFrame(
            [
                {
                    "label": "Combined_Data",
                    "relabel": "Second_Part",
                    "source_comment": "Second generated part.",
                }
            ]
        )

        self.assertEqual(
            apply_source_comments(["Combined_Data:", "\tdc.b\t$00"], frame),
            ["Combined_Data:", "\tdc.b\t$00"],
        )

    def test_conflicting_comments_for_one_label_are_skipped(self):
        frame = pd.DataFrame(
            [
                {"label": "A", "relabel": "Shared", "source_comment": "First"},
                {"label": "B", "relabel": "Shared", "source_comment": "Second"},
            ]
        )

        self.assertEqual(
            apply_source_comments(["Shared:", "\tdc.b\t$00"], frame),
            ["Shared:", "\tdc.b\t$00"],
        )

    def test_blank_duplicate_defers_to_resource_layout_comment(self):
        frame = pd.DataFrame(
            [
                {
                    "label": "Combined",
                    "relabel": "GeneratedPart",
                    "source_comment": "Packed render layout.",
                },
                {
                    "label": "OldInternal",
                    "relabel": "GeneratedPart",
                    "source_comment": "",
                },
            ]
        )

        self.assertEqual(
            apply_source_comments(["GeneratedPart:", "\tdc.b\t$00"], frame),
            [
                "GeneratedPart:",
                "\t; Packed render layout.",
                "\tdc.b\t$00",
            ],
        )

    def test_nonblank_duplicate_replaces_initial_blank_comment(self):
        frame = pd.DataFrame(
            [
                {
                    "label": "OldInternal",
                    "relabel": "GeneratedPart",
                    "source_comment": "",
                },
                {
                    "label": "Combined",
                    "relabel": "GeneratedPart",
                    "source_comment": "Packed render layout.",
                },
            ]
        )

        self.assertEqual(
            apply_source_comments(["GeneratedPart:", "\tdc.b\t$00"], frame),
            [
                "GeneratedPart:",
                "\t; Packed render layout.",
                "\tdc.b\t$00",
            ],
        )

    def test_resource_layout_comment_wins_over_alias_comment(self):
        frame = pd.DataFrame(
            [
                {
                    "label": "Combined",
                    "relabel": "GeneratedPart",
                    "data_action": "data_append",
                    "source_comment": "Generated resource description.",
                },
                {
                    "label": "OldInternal",
                    "relabel": "GeneratedPart",
                    "source_comment": "Older alias description.",
                },
            ]
        )

        self.assertEqual(
            apply_source_comments(["GeneratedPart:", "\tdc.b\t$00"], frame),
            [
                "GeneratedPart:",
                "\t; Generated resource description.",
                "\tdc.b\t$00",
            ],
        )


if __name__ == "__main__":
    unittest.main()

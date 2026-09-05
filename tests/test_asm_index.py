from __future__ import annotations

import unittest

from tools.asm_index import AsmDocument


class AsmDocumentTests(unittest.TestCase):
    def test_definition_lookup_and_tombstone_deletion(self) -> None:
        document = AsmDocument(["Start:", "\trts"], tracked_symbols={"Start"})

        self.assertEqual(document.definition_indices("Start"), (0,))
        document.delete_line(0)

        self.assertEqual(document.definition_indices("Start"), ())
        self.assertEqual(document.materialize(), ["\trts"])

    def test_replaces_all_exact_case_references(self) -> None:
        document = AsmDocument(
            ["SomeLabel:", "\tlea\tSomeLabel,a0", "\tbra\tsomelabel"],
            tracked_symbols={"SomeLabel"},
        )

        self.assertEqual(document.replace_symbol("SomeLabel", "Renamed"), 2)
        self.assertEqual(
            document.materialize(),
            ["Renamed:", "\tlea\tRenamed,a0", "\tbra\tsomelabel"],
        )

    def test_question_mark_and_size_suffixes_preserve_legacy_boundaries(self) -> None:
        document = AsmDocument(
            [
                "adrSomething?:",
                "\tmove.l\tadrSomething?.l,a0",
                "\tmove.w\tadrSomething?.w,d0",
                "\tmove.b\tadrSomething?.b,d0",
            ],
            tracked_symbols={"adrSomething?"},
        )

        document.replace_symbol("adrSomething?", "SomeLabel")

        self.assertEqual(
            document.materialize(),
            [
                "SomeLabel:",
                "\tmove.l\tSomeLabel.l,a0",
                "\tmove.w\tSomeLabel.w,d0",
                "\tmove.b\tSomeLabel.b,d0",
            ],
        )

    def test_local_label_is_indexed_and_replaced(self) -> None:
        document = AsmDocument(
            ["Routine:", "\tbra.s\t.done", ".done:", "\trts"],
            tracked_symbols={".done"},
        )

        self.assertEqual(document.definition_indices(".done"), (2,))
        document.replace_symbol(".done", ".exit")

        self.assertEqual(
            document.materialize(),
            ["Routine:", "\tbra.s\t.exit", ".exit:", "\trts"],
        )

    def test_ordered_replacement_reindexes_symbols_introduced_by_prior_row(self) -> None:
        document = AsmDocument(
            ["A:", "\tbra\tA"],
            tracked_symbols={"A", "B"},
        )

        document.replace_symbol("A", "B")
        self.assertEqual(document.definition_indices("B"), (0,))
        document.replace_symbol("B", "C")

        self.assertEqual(document.materialize(), ["C:", "\tbra\tC"])

    def test_materialize_preserves_surviving_line_order(self) -> None:
        document = AsmDocument(["one", "two", "three"])
        document.delete_line(1)

        self.assertEqual(document.materialize(), ["one", "three"])


if __name__ == "__main__":
    unittest.main()

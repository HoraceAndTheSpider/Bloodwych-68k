"""Lightweight indexed text representation for Relabel ALT."""

from __future__ import annotations

from collections import defaultdict
from collections.abc import Iterable
import re


IDENTIFIER_CHARACTERS = r"A-Za-z0-9_$?"
LABEL_DEFINITION = re.compile(r"^\s*([^\s:;]+)\s*:")
REFERENCE_TOKEN = re.compile(
    r"(?<![A-Za-z0-9_$?])"
    r"(\.?[A-Za-z_?$][A-Za-z0-9_$?]*)"
    r"(?![A-Za-z0-9_$?])"
)


def reference_pattern(label: str) -> re.Pattern[str]:
    """Compile the legacy Relabel token-boundary rule for one symbol."""

    return re.compile(
        rf"(?<![{IDENTIFIER_CHARACTERS}])"
        rf"{re.escape(label)}"
        rf"(?![{IDENTIFIER_CHARACTERS}])"
    )


def casefold_definition_index(lines: Iterable[str]) -> dict[str, tuple[int, ...]]:
    """Return case-insensitive definition positions for stable source text."""

    definitions: dict[str, list[int]] = defaultdict(list)
    for index, line in enumerate(lines):
        if match := LABEL_DEFINITION.match(line):
            definitions[match.group(1).casefold()].append(index)
    return {label: tuple(indices) for label, indices in definitions.items()}


class AsmDocument:
    """Indexed mutable ASM text with stable slots until materialisation."""

    def __init__(
        self,
        lines: Iterable[str],
        *,
        tracked_symbols: Iterable[str] = (),
    ) -> None:
        self.lines: list[str | None] = list(lines)
        self.tracked_symbols = frozenset(tracked_symbols)
        self.definitions: dict[str, set[int]] = defaultdict(set)
        self.references: dict[str, set[int]] = defaultdict(set)
        self._line_definition: dict[int, str] = {}
        self._line_references: dict[int, set[str]] = {}
        self._patterns: dict[str, re.Pattern[str]] = {}
        self.rebuild()

    def rebuild(self) -> None:
        self.definitions.clear()
        self.references.clear()
        self._line_definition.clear()
        self._line_references.clear()
        for index in range(len(self.lines)):
            self._index_line(index)

    def _unindex_line(self, index: int) -> None:
        definition = self._line_definition.pop(index, None)
        if definition is not None:
            self.definitions[definition].discard(index)
            if not self.definitions[definition]:
                self.definitions.pop(definition, None)

        for symbol in self._line_references.pop(index, set()):
            self.references[symbol].discard(index)
            if not self.references[symbol]:
                self.references.pop(symbol, None)

    def _index_line(self, index: int) -> None:
        line = self.lines[index]
        if line is None:
            return

        if definition := LABEL_DEFINITION.match(line):
            name = definition.group(1)
            self._line_definition[index] = name
            self.definitions[name].add(index)

        hits = {
            match.group(1)
            for match in REFERENCE_TOKEN.finditer(line)
            if match.group(1) in self.tracked_symbols
        }
        if hits:
            self._line_references[index] = hits
            for symbol in hits:
                self.references[symbol].add(index)

    def set_line(self, index: int, line: str | None) -> None:
        self._unindex_line(index)
        self.lines[index] = line
        self._index_line(index)

    def delete_line(self, index: int) -> None:
        self.set_line(index, None)

    def definition_indices(self, label: str) -> tuple[int, ...]:
        return tuple(sorted(self.definitions.get(label, ())))

    def get_line(self, index: int) -> str:
        line = self.lines[index]
        if line is None:
            raise IndexError(f"ASM line slot {index} has been deleted")
        return line

    def replace_symbol(self, label: str, replacement: str) -> int:
        """Replace a symbol on indexed candidate lines and re-index changes."""

        pattern = self._patterns.setdefault(label, reference_pattern(label))
        candidates = tuple(sorted(self.references.get(label, ())))
        changed = 0
        for index in candidates:
            line = self.lines[index]
            if line is None:
                continue
            rewritten, count = pattern.subn(replacement, line)
            if count:
                self.set_line(index, rewritten)
                changed += count
        return changed

    def materialize(self) -> list[str]:
        return [line for line in self.lines if line is not None]

"""Generate concise, spreadsheet-owned comments immediately after ASM labels."""

from __future__ import annotations

from collections.abc import Callable, Sequence
import re

import pandas as pd

from .resource_layout import DATA_APPEND, DATA_START, cell_text, data_action
from .tool_common import parse_int


SOURCE_COMMENT_COLUMN = "source_comment"
LEGACY_GENERATED_COMMENT = re.compile(r"^\s*;\s*ReSource:\s*", re.IGNORECASE)
GENERATED_ADDRESS = re.compile(
    r"\s*;\s*Memory Address \(\$[0-9A-F]+\) and binary offset "
    r"\[\$[0-9A-F]+\]\s*$",
    re.IGNORECASE,
)
MEMORY_OFFSET_DELTA = 0x384


def _position_value(row: pd.Series) -> int | None:
    """Return the spreadsheet's binary position, if one is available."""
    # ``load_segments`` normalises column names, while direct callers/tests may
    # provide the worksheet's display spelling.
    value = row.get("bw439 position")
    if value is None:
        value = row.get("BW439 Position")
    return parse_int(value)


def _address_comment(row: pd.Series) -> tuple[str, int] | None:
    """Return an address annotation and its evidence priority.

    An explicit BW439 binary position is authoritative. Otherwise the final
    six hexadecimal characters of an original ``adr...`` label are the 439
    memory address used by the disassembly; the binary position follows from
    the known ``$384`` load offset.
    """
    position = _position_value(row)
    if position is not None:
        memory = position + MEMORY_OFFSET_DELTA
        priority = 2
    else:
        label = cell_text(row, "label")
        match = re.search(r"([0-9A-Fa-f]{6})$", label)
        if not label.casefold().startswith("adr") or not match:
            return None
        memory = int(match.group(1), 16)
        position = memory - MEMORY_OFFSET_DELTA
        priority = 1
    return (
        f"Memory Address (${memory:04X}) and binary offset [${position:04X}]",
        priority,
    )


def _target_label(row: pd.Series) -> str:
    """Return the final source label to which a spreadsheet comment belongs."""
    relabel = cell_text(row, "relabel")
    if relabel.casefold().startswith(("_delete", "_offset_")):
        return ""
    if relabel:
        return relabel
    label = cell_text(row, "label")
    return "" if label.casefold() == "ignore" else label


LabelLookup = Callable[[str], Sequence[int]]


def apply_source_comments(
    lines: list[str],
    frame: pd.DataFrame,
    *,
    label_lookup: LabelLookup | None = None,
) -> list[str]:
    """Replace generated comments after labels, leaving handwritten comments alone.

    Generated comments are replaced on reruns. Rows whose final label is not
    present in this source
    variant are ignored; this allows ``data_append`` labels to appear only in
    the generated ``*_data.asm`` file.
    """
    comments: dict[str, tuple[str, ...]] = {}
    comment_priorities: dict[str, int] = {}
    conflicting_comment_labels: set[str] = set()
    addresses: dict[str, str] = {}
    address_priorities: dict[str, int] = {}
    for _, row in frame.iterrows():
        label = _target_label(row)
        if not label:
            continue
        address = _address_comment(row)
        if address is not None:
            address_text, priority = address
            key = label.casefold()
            if (
                key not in addresses
                or priority > address_priorities[key]
            ):
                addresses[key] = address_text
                address_priorities[key] = priority
        if SOURCE_COMMENT_COLUMN in frame.columns:
            text = cell_text(row, SOURCE_COMMENT_COLUMN)
            comment_lines = tuple(
                part.strip() for part in text.splitlines() if part.strip()
            )
            key = label.casefold()
            if key in conflicting_comment_labels:
                continue
            priority = 1 if data_action(row) in {DATA_START, DATA_APPEND} else 0
            if key not in comments:
                comments[key] = comment_lines
                comment_priorities[key] = priority
            elif comments[key] == comment_lines:
                comment_priorities[key] = max(comment_priorities[key], priority)
            elif not comment_lines:
                continue
            elif not comments[key]:
                comments[key] = comment_lines
                comment_priorities[key] = priority
            elif priority > comment_priorities[key]:
                comments[key] = comment_lines
                comment_priorities[key] = priority
            elif priority < comment_priorities[key]:
                continue
            else:
                # Comments are presentation metadata.  Do not abort a relabel
                # after all source transformations have succeeded just because
                # two rows nominate different descriptions for one output
                # label.  Suppress the ambiguous generated comment instead of
                # choosing one based on worksheet order.
                conflicting_comment_labels.add(key)
                comments.pop(key)
                comment_priorities.pop(key)
                print(
                    "WARNING: Conflicting source comments for label "
                    f"'{label}'; generated comment skipped. Resolve the "
                    "duplicate relabel rows in the segments workbook."
                )

    result = list(lines)
    for label_key, address_text in addresses.items():
        pattern = re.compile(
            rf"^(\s*{re.escape(label_key)}\s*:)(.*)$", re.IGNORECASE
        )
        matches = (
            list(label_lookup(label_key))
            if label_lookup is not None
            else [index for index, line in enumerate(result) if pattern.match(line)]
        )
        if len(matches) != 1:
            continue
        index = matches[0]
        match = pattern.match(result[index])
        assert match is not None
        suffix = GENERATED_ADDRESS.sub("", match.group(2))
        # Address comments belong on the definition row. Keep any handwritten
        # same-line comment intact, but normal generated definitions use the
        # requested two-tab spacing exactly.
        if suffix.strip():
            result[index] = f"{match.group(1).rstrip()}\t\t{suffix.strip()}\t\t; {address_text}"
        else:
            result[index] = f"{match.group(1).rstrip()}\t\t; {address_text}"

    if SOURCE_COMMENT_COLUMN in frame.columns:
        edits: list[tuple[int, int, tuple[str, ...]]] = []
        for label_key, comment_lines in comments.items():
            pattern = re.compile(
                rf"^\s*{re.escape(label_key)}\s*:", re.IGNORECASE
            )
            matches = (
                list(label_lookup(label_key))
                if label_lookup is not None
                else [
                    index for index, line in enumerate(result) if pattern.match(line)
                ]
            )
            if len(matches) != 1:
                continue
            start = matches[0] + 1
            end = start
            while end < len(result):
                candidate = result[end]
                if LEGACY_GENERATED_COMMENT.match(candidate):
                    end += 1
                    continue
                comment = candidate.lstrip(" \t")
                if comment.startswith(";") and comment[1:].strip() in comment_lines:
                    end += 1
                    continue
                break
            edits.append((start, end, comment_lines))

        for start, end, comment_lines in sorted(edits, reverse=True):
            generated = [f"\t; {line}" for line in comment_lines]
            result[start:end] = generated
    return result

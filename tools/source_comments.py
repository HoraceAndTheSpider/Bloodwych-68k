"""Generate concise, spreadsheet-owned comments immediately after ASM labels."""

from __future__ import annotations

import re

import pandas as pd

from .resource_layout import cell_text


SOURCE_COMMENT_COLUMN = "source_comment"
GENERATED_COMMENT = re.compile(r"^\s*;\s*ReSource:\s*", re.IGNORECASE)


def _target_label(row: pd.Series) -> str:
    """Return the final source label to which a spreadsheet comment belongs."""
    relabel = cell_text(row, "relabel")
    if relabel.casefold().startswith(("_delete", "_offset_")):
        return ""
    if relabel:
        return relabel
    label = cell_text(row, "label")
    return "" if label.casefold() == "ignore" else label


def apply_source_comments(lines: list[str], frame: pd.DataFrame) -> list[str]:
    """Replace generated comments after labels, leaving handwritten comments alone.

    Every generated line is prefixed ``ReSource:`` so rerunning Relabel or
    Inspect is idempotent. Rows whose final label is not present in this source
    variant are ignored; this allows ``data_append`` labels to appear only in
    the generated ``*_data.asm`` file.
    """
    if SOURCE_COMMENT_COLUMN not in frame.columns:
        return lines

    comments: dict[str, tuple[str, ...]] = {}
    for _, row in frame.iterrows():
        label = _target_label(row)
        if not label:
            continue
        text = cell_text(row, SOURCE_COMMENT_COLUMN)
        comment_lines = tuple(
            part.strip() for part in text.splitlines() if part.strip()
        )
        key = label.casefold()
        if key in comments and comments[key] != comment_lines:
            raise ValueError(f"Conflicting source comments for label '{label}'")
        comments[key] = comment_lines

    result = list(lines)
    edits: list[tuple[int, int, tuple[str, ...]]] = []
    for label_key, comment_lines in comments.items():
        pattern = re.compile(rf"^\s*{re.escape(label_key)}\s*:", re.IGNORECASE)
        matches = [index for index, line in enumerate(result) if pattern.match(line)]
        if len(matches) != 1:
            continue
        start = matches[0] + 1
        end = start
        while end < len(result) and GENERATED_COMMENT.match(result[end]):
            end += 1
        edits.append((start, end, comment_lines))

    for start, end, comment_lines in sorted(edits, reverse=True):
        generated = [f"\t; ReSource: {line}" for line in comment_lines]
        result[start:end] = generated
    return result

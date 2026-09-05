"""Insert spreadsheet-owned standalone notes at scoped ASM source markers."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import re

import pandas as pd

from .resource_layout import cell_text
from .tool_common import ToolError, get_profile, parse_int, resolve_cleanup_path


SOURCE_NOTES_SHEET = "SOURCE_NOTES"
SOURCE_NOTE_PREFIX = "; SOURCE_NOTE:"
VERIFIED = "verified"
PROPOSED = "proposed"
DISABLED = "disabled"
VALID_STATUSES = {VERIFIED, PROPOSED, DISABLED}
LABEL_DEFINITION = re.compile(r"^\s*([A-Za-z_.$?][\w.$?]*)\s*:")


@dataclass(frozen=True)
class SourceNote:
    profile: str
    scope_start: str
    scope_end: str
    source_match: str
    source_comment: str
    expected_matches: int
    status: str
    notes: str = ""


def _normalise_columns(frame: pd.DataFrame) -> pd.DataFrame:
    result = frame.copy()
    result.columns = [str(column).strip().casefold() for column in result.columns]
    return result


def _optional_workbook_sheet(path: Path) -> pd.DataFrame:
    if not path.is_file() or path.suffix.casefold() == ".csv":
        return pd.DataFrame()
    with pd.ExcelFile(path) as book:
        selected = next(
            (
                name
                for name in book.sheet_names
                if name.casefold() == SOURCE_NOTES_SHEET.casefold()
            ),
            None,
        )
        if selected is None:
            return pd.DataFrame()
        return _normalise_columns(pd.read_excel(book, sheet_name=selected))


def _row_number(index: object) -> int:
    try:
        return int(index) + 2
    except (TypeError, ValueError):
        return 0


def load_source_note_metadata(
    sheet: str | Path,
    master: str,
    cleanup: str | Path | None = None,
    *,
    frame: pd.DataFrame | None = None,
) -> tuple[SourceNote, ...]:
    """Load scoped standalone source notes from the cleanup workbook."""
    if frame is None:
        frame = _optional_workbook_sheet(resolve_cleanup_path(sheet, cleanup))
    else:
        frame = _normalise_columns(frame)
    if frame.empty:
        return ()
    required = (
        "profile",
        "scope_start",
        "scope_end",
        "source_match",
        "source_comment",
        "expected_matches",
        "status",
        "notes",
    )
    missing = [column for column in required if column not in frame.columns]
    if missing:
        raise ToolError(
            f"Worksheet '{SOURCE_NOTES_SHEET}' is missing column(s): "
            + ", ".join(missing)
        )

    profile_key = get_profile(master).filename.casefold()
    rows: list[SourceNote] = []
    for index, row in frame.iterrows():
        profile = cell_text(row, "profile")
        if not profile or profile.casefold() != profile_key:
            continue
        excel_row = _row_number(index)
        status = cell_text(row, "status").casefold()
        if status not in VALID_STATUSES:
            raise ToolError(
                f"{SOURCE_NOTES_SHEET} row {excel_row} has invalid status '{status}'"
            )
        expected_matches = parse_int(row.get("expected_matches"))
        if expected_matches is None:
            expected_matches = 1
        if expected_matches < 1:
            raise ToolError(
                f"{SOURCE_NOTES_SHEET} row {excel_row} requires expected_matches >= 1"
            )
        note = SourceNote(
            profile=profile,
            scope_start=cell_text(row, "scope_start"),
            scope_end=cell_text(row, "scope_end"),
            source_match=cell_text(row, "source_match"),
            source_comment=cell_text(row, "source_comment"),
            expected_matches=expected_matches,
            status=status,
            notes=cell_text(row, "notes"),
        )
        if status == VERIFIED and not all(
            (
                note.scope_start,
                note.scope_end,
                note.source_match,
                note.source_comment,
            )
        ):
            raise ToolError(
                f"{SOURCE_NOTES_SHEET} row {excel_row} is verified but incomplete"
            )
        rows.append(note)
    return tuple(rows)


def _normalise_source(value: str) -> str:
    return re.sub(r"\s+", "", value).casefold()


def _label_indices(lines: list[str], label: str) -> list[int]:
    return [
        index
        for index, line in enumerate(lines)
        if (match := LABEL_DEFINITION.match(line))
        and match.group(1).casefold() == label.casefold()
    ]


def apply_source_notes(
    lines: list[str],
    notes: tuple[SourceNote, ...],
    *,
    continue_on_error: bool = False,
) -> list[str]:
    """Insert verified standalone notes after exact matches in labelled scopes."""
    result = list(lines)
    for row_number, note in enumerate(notes, start=2):
        if note.status != VERIFIED:
            continue
        try:
            start_matches = _label_indices(result, note.scope_start)
            end_matches = _label_indices(result, note.scope_end)
            if len(start_matches) != 1 or len(end_matches) != 1:
                raise ToolError(
                    f"SOURCE_NOTES row {row_number} expected one scope from "
                    f"'{note.scope_start}' to '{note.scope_end}', found "
                    f"{len(start_matches)} start and {len(end_matches)} end labels"
                )
            start, end = start_matches[0], end_matches[0]
            if start >= end:
                raise ToolError(
                    f"SOURCE_NOTES row {row_number} has reversed or empty scope"
                )
            expected = _normalise_source(note.source_match)
            matches = [
                index
                for index in range(start + 1, end)
                if _normalise_source(result[index]) == expected
            ]
            if len(matches) != note.expected_matches:
                raise ToolError(
                    f"SOURCE_NOTES row {row_number} expected "
                    f"{note.expected_matches} match(es) between "
                    f"'{note.scope_start}' and '{note.scope_end}', found {len(matches)}"
                )
        except ToolError as error:
            if not continue_on_error:
                raise
            print(f"Error applying {error}; leaving this note unchanged and continuing")
            continue

        generated = [
            f"{SOURCE_NOTE_PREFIX} {part.strip()}"
            for part in note.source_comment.splitlines()
            if part.strip()
        ]
        for index in reversed(matches):
            insert_at = index + 1
            replace_end = insert_at
            while (
                replace_end < len(result)
                and result[replace_end].strip().casefold().startswith(
                    SOURCE_NOTE_PREFIX.casefold()
                )
            ):
                replace_end += 1
            result[insert_at:replace_end] = generated
        print(
            f"Applied source note after {note.expected_matches} marker(s) "
            f"between '{note.scope_start}' and '{note.scope_end}'"
        )
    return result

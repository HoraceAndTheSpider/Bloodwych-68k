"""Spreadsheet-owned insertion labels for unlabelled source boundaries."""

from __future__ import annotations

from dataclasses import dataclass
import re
from pathlib import Path

import pandas as pd

from .resource_layout import cell_text
from .tool_common import ToolError, get_profile, parse_int, resolve_cleanup_path


FIX_LABELS_SHEET = "FIX_LABELS"
VERIFIED = "verified"
PROPOSED = "proposed"
DISABLED = "disabled"
VALID_STATUSES = {VERIFIED, PROPOSED, DISABLED}
LABEL_DEFINITION = re.compile(r"^\s*([A-Za-z_.$?][\w.$?]*)\s*:")
LABEL_MARKER = ";fix label expected"
REFERENCE_MARKER = ";fix data reference expected"


@dataclass(frozen=True)
class FixLabelRule:
    profile: str
    anchor_label: str
    insert_label: str
    source_match: str
    source_replace: str
    expected_opcode: str
    expected_matches: int
    status: str
    source_comment: str = ""


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
                if name.casefold() == FIX_LABELS_SHEET.casefold()
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


def load_fix_label_metadata(
    sheet: str | Path,
    master: str,
    cleanup: str | Path | None = None,
    *,
    frame: pd.DataFrame | None = None,
) -> tuple[FixLabelRule, ...]:
    """Load verified fix-label rules from the optional cleanup tab."""
    if frame is None:
        frame = _optional_workbook_sheet(resolve_cleanup_path(sheet, cleanup))
    else:
        frame = _normalise_columns(frame)
    if frame.empty:
        return ()
    required = (
        "profile",
        "anchor_label",
        "insert_label",
        "source_match",
        "source_replace",
        "expected_opcode",
        "expected_matches",
        "status",
        "source_comment",
    )
    missing = [column for column in required if column not in frame.columns]
    if missing:
        raise ToolError(
            f"Worksheet '{FIX_LABELS_SHEET}' is missing column(s): {', '.join(missing)}"
        )

    profile_key = get_profile(master).filename.casefold()
    rules: list[FixLabelRule] = []
    for index, row in frame.iterrows():
        profile = cell_text(row, "profile")
        if not profile or profile.casefold() != profile_key:
            continue
        excel_row = _row_number(index)
        status = cell_text(row, "status").casefold()
        if status not in VALID_STATUSES:
            raise ToolError(
                f"{FIX_LABELS_SHEET} row {excel_row} has invalid status '{status}'"
            )
        expected_matches = row.get("expected_matches")
        try:
            expected_matches = int(expected_matches)
        except (TypeError, ValueError):
            expected_matches = 1
        if expected_matches < 1:
            raise ToolError(
                f"{FIX_LABELS_SHEET} row {excel_row} requires expected_matches >= 1"
            )
        rule = FixLabelRule(
            profile=profile,
            anchor_label=cell_text(row, "anchor_label"),
            insert_label=cell_text(row, "insert_label"),
            source_match=cell_text(row, "source_match"),
            source_replace=cell_text(row, "source_replace"),
            expected_opcode=cell_text(row, "expected_opcode"),
            expected_matches=expected_matches,
            status=status,
            source_comment=cell_text(row, "source_comment"),
        )
        if status == VERIFIED:
            if not all(
                (
                    rule.anchor_label,
                    rule.insert_label,
                    rule.source_match,
                    rule.source_replace,
                )
            ):
                raise ToolError(
                    f"{FIX_LABELS_SHEET} row {excel_row} is verified but incomplete"
                )
        rules.append(rule)
    return tuple(rules)


def _normalise_instruction(value: str) -> str:
    return re.sub(r"\s+", "", value.split(";", 1)[0]).casefold()


def apply_fix_label_rules(
    lines: list[str], rules: tuple[FixLabelRule, ...]
) -> tuple[list[str], set[str]]:
    """Insert verified labels and rewrite their independently marked references."""
    result = list(lines)
    inserted: set[str] = set()
    for rule in rules:
        if rule.status != VERIFIED:
            continue

        anchor_matches = [
            index
            for index, line in enumerate(result)
            if (match := LABEL_DEFINITION.match(line))
            and match.group(1).casefold() == rule.anchor_label.casefold()
        ]
        if len(anchor_matches) != 1:
            raise ToolError(
                f"Fix-label '{rule.insert_label}' expected one anchor "
                f"'{rule.anchor_label}', found {len(anchor_matches)}"
            )
        anchor_index = anchor_matches[0]
        next_label = next(
            (
                index
                for index in range(anchor_index + 1, len(result))
                if LABEL_DEFINITION.match(result[index])
            ),
            len(result),
        )
        label_markers = [
            index
            for index in range(anchor_index + 1, next_label)
            if result[index].strip().casefold() == LABEL_MARKER
        ]
        if len(label_markers) != 1:
            raise ToolError(
                f"Fix-label '{rule.insert_label}' expected one label marker after "
                f"'{rule.anchor_label}', found {len(label_markers)}"
            )

        candidates: list[tuple[int, int]] = []
        for marker_index, line in enumerate(result):
            if line.strip().casefold() != REFERENCE_MARKER:
                continue
            instruction_index = marker_index - 1
            while instruction_index >= 0 and not result[instruction_index].strip():
                instruction_index -= 1
            if instruction_index < 0:
                continue
            if _normalise_instruction(result[instruction_index]) == _normalise_instruction(
                rule.source_match
            ):
                candidates.append((marker_index, instruction_index))

        if len(candidates) != rule.expected_matches:
            raise ToolError(
                f"Fix-label '{rule.insert_label}' expected {rule.expected_matches} "
                f"reference match(es), found {len(candidates)}"
            )

        for marker_index, instruction_index in candidates:
            actual = result[instruction_index]
            if rule.expected_opcode:
                comment = actual.split(";", 1)[1] if ";" in actual else ""
                expected_opcode = rule.expected_opcode.casefold().replace(" ", "")
                actual_opcode = comment.casefold().replace(" ", "")
                if expected_opcode not in actual_opcode:
                    raise ToolError(
                        f"Fix-label '{rule.insert_label}' opcode check failed at "
                        f"ASM line {instruction_index + 1}"
                    )
            code_part, separator, comment = actual.partition(";")
            indentation = actual[: len(actual) - len(actual.lstrip())]
            comment_gap = code_part[len(code_part.rstrip()) :]
            result[instruction_index] = (
                indentation
                + rule.source_replace.lstrip()
                + (comment_gap + separator + comment if separator else "")
            )
            result[marker_index] = ""

        result[label_markers[0]] = f"{rule.insert_label}:"
        inserted.add(rule.insert_label.casefold())
        print(
            f"Inserted fix-label '{rule.insert_label}' after '{rule.anchor_label}' "
            f"and applied {len(candidates)} marked reference(s)"
        )
    return result, inserted

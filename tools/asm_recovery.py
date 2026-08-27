"""Curated recovery of verified 68000 instructions emitted as ``dc.*`` data."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import re

import pandas as pd

from .resource_layout import cell_text
from .tool_common import ToolError, get_profile, resolve_cleanup_path


ASM_RECOVERY_SHEET = "ASM_RECOVERY"
RECOVERY_COMMENT = "ASM_RECOVERY"
VERIFIED = "verified"
PROPOSED = "proposed"
DISABLED = "disabled"
VALID_STATUSES = {VERIFIED, PROPOSED, DISABLED}
LABEL_DEFINITION = re.compile(r"^\s*([A-Za-z_.$?][\w.$?]*)\s*:")


@dataclass(frozen=True)
class AsmRecoveryInstruction:
    profile: str
    recovery_id: str
    scope_start: str
    scope_end: str
    sequence: int
    source_match: str
    source_replace: str
    expected_opcode: str
    status: str
    source_comment: str = ""
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
                if name.casefold() == ASM_RECOVERY_SHEET.casefold()
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


def _opcode_text(value: str) -> str:
    return re.sub(r"[^0-9A-Fa-f]", "", value).upper()


def _source_bytes(source: str) -> bytes:
    """Encode the deliberately small ``dc.b/w/l`` subset used by recoveries."""
    code = source.split(";", 1)[0].strip()
    match = re.fullmatch(r"dc\.(b|w|l)\s+(.+)", code, re.IGNORECASE)
    if not match:
        raise ToolError(
            f"ASM recovery source_match must be one numeric dc.b/w/l declaration: {source}"
        )
    width = {"b": 1, "w": 2, "l": 4}[match.group(1).casefold()]
    output = bytearray()
    for operand in match.group(2).split(","):
        value = operand.strip()
        try:
            if value.startswith("$"):
                number = int(value[1:], 16)
            elif value.casefold().startswith("0x"):
                number = int(value, 16)
            else:
                number = int(value)
            output.extend(number.to_bytes(width, "big", signed=number < 0))
        except (OverflowError, ValueError) as error:
            raise ToolError(
                f"ASM recovery source_match contains unsupported operand '{value}'"
            ) from error
    return bytes(output)


def load_asm_recovery_metadata(
    sheet: str | Path,
    master: str,
    cleanup: str | Path | None = None,
) -> tuple[AsmRecoveryInstruction, ...]:
    """Load and validate curated recovery rows for one binary profile."""
    frame = _optional_workbook_sheet(resolve_cleanup_path(sheet, cleanup))
    if frame.empty:
        return ()
    required = (
        "profile",
        "recovery_id",
        "scope_start",
        "scope_end",
        "sequence",
        "source_match",
        "source_replace",
        "expected_opcode",
        "status",
        "source_comment",
        "notes",
    )
    missing = [column for column in required if column not in frame.columns]
    if missing:
        raise ToolError(
            f"Worksheet '{ASM_RECOVERY_SHEET}' is missing column(s): "
            + ", ".join(missing)
        )

    profile_key = get_profile(master).filename.casefold()
    rows: list[AsmRecoveryInstruction] = []
    for index, row in frame.iterrows():
        profile = cell_text(row, "profile")
        if not profile or profile.casefold() != profile_key:
            continue
        excel_row = _row_number(index)
        status = cell_text(row, "status").casefold()
        if status not in VALID_STATUSES:
            raise ToolError(
                f"{ASM_RECOVERY_SHEET} row {excel_row} has invalid status '{status}'"
            )
        try:
            sequence = int(row.get("sequence"))
        except (TypeError, ValueError) as error:
            raise ToolError(
                f"{ASM_RECOVERY_SHEET} row {excel_row} requires an integer sequence"
            ) from error
        instruction = AsmRecoveryInstruction(
            profile=profile,
            recovery_id=cell_text(row, "recovery_id"),
            scope_start=cell_text(row, "scope_start"),
            scope_end=cell_text(row, "scope_end"),
            sequence=sequence,
            source_match=cell_text(row, "source_match"),
            source_replace=cell_text(row, "source_replace"),
            expected_opcode=_opcode_text(cell_text(row, "expected_opcode")),
            status=status,
            source_comment=cell_text(row, "source_comment"),
            notes=cell_text(row, "notes"),
        )
        if status == VERIFIED and not all(
            (
                instruction.recovery_id,
                instruction.scope_start,
                instruction.scope_end,
                instruction.source_match,
                instruction.source_replace,
                instruction.expected_opcode,
            )
        ):
            raise ToolError(
                f"{ASM_RECOVERY_SHEET} row {excel_row} is verified but incomplete"
            )
        if instruction.expected_opcode and (
            len(instruction.expected_opcode) % 2
            or _source_bytes(instruction.source_match).hex().upper()
            != instruction.expected_opcode
        ):
            raise ToolError(
                f"{ASM_RECOVERY_SHEET} row {excel_row} source bytes do not match "
                f"expected_opcode {instruction.expected_opcode}"
            )
        rows.append(instruction)

    groups: dict[str, list[AsmRecoveryInstruction]] = {}
    for row in rows:
        groups.setdefault(row.recovery_id.casefold(), []).append(row)
    for group in groups.values():
        ordered = sorted(group, key=lambda item: item.sequence)
        expected_sequence = list(range(1, len(ordered) + 1))
        if [item.sequence for item in ordered] != expected_sequence:
            raise ToolError(
                f"ASM recovery '{ordered[0].recovery_id}' requires consecutive "
                "sequence values starting at 1"
            )
        identity = {
            (item.scope_start.casefold(), item.scope_end.casefold(), item.status)
            for item in ordered
        }
        if len(identity) != 1:
            raise ToolError(
                f"ASM recovery '{ordered[0].recovery_id}' has inconsistent "
                "scope or status values"
            )
    return tuple(rows)


def _normalise_source(value: str) -> str:
    return re.sub(r"\s+", "", value.split(";", 1)[0]).casefold()


def _format_instruction(value: str) -> str:
    parts = value.strip().split(None, 1)
    return "\t".join(parts)


def _label_indices(lines: list[str], label: str) -> list[int]:
    return [
        index
        for index, line in enumerate(lines)
        if (match := LABEL_DEFINITION.match(line))
        and match.group(1).casefold() == label.casefold()
    ]


def apply_asm_recoveries(
    lines: list[str],
    rules: tuple[AsmRecoveryInstruction, ...],
    *,
    label_relabels: dict[str, str] | None = None,
) -> tuple[list[str], set[str]]:
    """Apply every verified recovery group atomically and fail closed."""
    result = list(lines)
    groups: dict[str, list[AsmRecoveryInstruction]] = {}
    names: dict[str, str] = {}
    for rule in rules:
        key = rule.recovery_id.casefold()
        groups.setdefault(key, []).append(rule)
        names.setdefault(key, rule.recovery_id)

    applied: set[str] = set()
    relabels = {
        label.casefold(): replacement
        for label, replacement in (label_relabels or {}).items()
    }
    for key, unsorted_group in groups.items():
        group = sorted(unsorted_group, key=lambda item: item.sequence)
        if group[0].status != VERIFIED:
            continue
        start_label = group[0].scope_start
        end_label = group[0].scope_end
        start_matches = _label_indices(result, start_label)
        end_matches = _label_indices(result, end_label)
        if not start_matches and start_label.casefold() in relabels:
            start_label = relabels[start_label.casefold()]
            start_matches = _label_indices(result, start_label)
        if not end_matches and end_label.casefold() in relabels:
            end_label = relabels[end_label.casefold()]
            end_matches = _label_indices(result, end_label)
        if len(start_matches) != 1 or len(end_matches) != 1:
            raise ToolError(
                f"ASM recovery '{names[key]}' expected one scope from "
                f"'{start_label}' to '{end_label}', found "
                f"{len(start_matches)} start and {len(end_matches)} end labels"
            )
        start, end = start_matches[0], end_matches[0]
        if start >= end:
            raise ToolError(
                f"ASM recovery '{names[key]}' has reversed or empty scope"
            )

        significant = [
            index
            for index in range(start + 1, end)
            if result[index].split(";", 1)[0].strip()
        ]
        expected = [_normalise_source(item.source_match) for item in group]
        candidates: list[list[int]] = []
        for offset in range(0, len(significant) - len(group) + 1):
            indices = significant[offset : offset + len(group)]
            if [_normalise_source(result[index]) for index in indices] == expected:
                candidates.append(indices)
        if len(candidates) != 1:
            raise ToolError(
                f"ASM recovery '{names[key]}' expected one complete source sequence "
                f"inside its scope, found {len(candidates)}"
            )

        indices = candidates[0]
        replacements: list[tuple[int, str]] = []
        for index, instruction in zip(indices, group):
            actual = result[index]
            comment = actual.partition(";")[2]
            if instruction.expected_opcode.casefold() not in re.sub(
                r"\s+", "", comment
            ).casefold():
                raise ToolError(
                    f"ASM recovery '{names[key]}' opcode check failed at "
                    f"ASM line {index + 1}"
                )
            indentation = actual[: len(actual) - len(actual.lstrip())]
            replacements.append(
                (
                    index,
                    f"{indentation}{_format_instruction(instruction.source_replace)}"
                    f"\t;{RECOVERY_COMMENT}: {names[key]} | "
                    f"{instruction.expected_opcode}",
                )
            )
        for index, replacement in replacements:
            result[index] = replacement
        applied.add(key)
        print(
            f"Recovered {len(group)} instruction(s) for ASM recovery "
            f"'{names[key]}'"
        )
    return result, applied

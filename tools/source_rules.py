"""Spreadsheet-owned EQU definitions and scoped source operand rewrites."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import re

import pandas as pd

from .resource_layout import cell_text
from .tool_common import ToolError, get_profile, parse_int, resolve_project_path


EQUATES_SHEET = "EQUATES"
VERIFIED = "verified"
PROPOSED = "proposed"
DISABLED = "disabled"
VALID_STATUSES = {VERIFIED, PROPOSED, DISABLED}
SYMBOL = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
LABEL_DEFINITION = re.compile(r"^\s*([A-Za-z_?.$][\w?.$]*):", re.IGNORECASE)


@dataclass(frozen=True)
class EquateDefinition:
    profile: str
    name: str
    value: int
    status: str
    source_comment: str = ""
    notes: str = ""

    @property
    def value_text(self) -> str:
        if self.value <= 0xFF:
            digits = 2
        elif self.value <= 0xFFFF:
            digits = 4
        else:
            digits = 8
        return f"${self.value:0{digits}X}"


@dataclass(frozen=True)
class SourceRule:
    profile: str
    rule_id: str
    action: str
    equ_name: str
    scope_start: str
    scope_end: str
    mnemonic: str
    match_operands: str
    expected_opcode: str
    replacement_operands: str
    expected_matches: int
    status: str
    source_comment: str = ""
    notes: str = ""


def _normalise_columns(frame: pd.DataFrame) -> pd.DataFrame:
    result = frame.copy()
    result.columns = [str(column).strip().casefold() for column in result.columns]
    return result


def _optional_workbook_sheet(path: Path, sheet_name: str) -> pd.DataFrame:
    if not path.is_file() or path.suffix.casefold() == ".csv":
        return pd.DataFrame()
    with pd.ExcelFile(path) as book:
        selected = next(
            (name for name in book.sheet_names if name.casefold() == sheet_name.casefold()),
            None,
        )
        if selected is None:
            return pd.DataFrame()
        return _normalise_columns(pd.read_excel(book, sheet_name=selected))


def _require_columns(frame: pd.DataFrame, sheet_name: str, columns: tuple[str, ...]) -> None:
    missing = [column for column in columns if column not in frame.columns]
    if missing:
        raise ToolError(
            f"Worksheet '{sheet_name}' is missing column(s): {', '.join(missing)}"
        )


def _row_number(index: object) -> int:
    try:
        return int(index) + 2
    except (TypeError, ValueError):
        return 0


def load_source_metadata(
    sheet: str | Path, master: str
) -> tuple[tuple[EquateDefinition, ...], tuple[SourceRule, ...]]:
    """Load the optional combined EQU definition/source-rule worksheet."""

    path = resolve_project_path(sheet)
    frame = _optional_workbook_sheet(path, EQUATES_SHEET)
    if frame.empty:
        return (), ()

    _require_columns(
        frame,
        EQUATES_SHEET,
        (
            "profile",
            "equ_name",
            "equ_value",
            "scope_start",
            "scope_end",
            "source_match",
            "expected_opcode",
            "source_replace",
            "status",
            "source_comment",
        ),
    )
    profile = get_profile(master).filename
    profile_key = profile.casefold()
    equates_by_name: dict[str, EquateDefinition] = {}
    rules: list[SourceRule] = []

    for index, row in frame.iterrows():
        row_profile = cell_text(row, "profile")
        if not row_profile or row_profile.casefold() != profile_key:
            continue
        excel_row = _row_number(index)
        name = cell_text(row, "equ_name")
        value = parse_int(row.get("equ_value"))
        status = cell_text(row, "status").casefold()
        if not name or not SYMBOL.fullmatch(name):
            raise ToolError(f"EQUATES row {excel_row} has an invalid equ_name")
        if value is None or value < 0:
            raise ToolError(f"EQUATES row {excel_row} has an invalid equ_value")
        if status not in VALID_STATUSES:
            raise ToolError(f"EQUATES row {excel_row} has an invalid status '{status}'")

        definition = EquateDefinition(
            profile=row_profile,
            name=name,
            value=value,
            status=status,
            source_comment=cell_text(row, "source_comment"),
            notes=cell_text(row, "notes"),
        )
        key = name.casefold()
        previous = equates_by_name.get(key)
        if previous and previous.value != value:
            raise ToolError(
                f"Conflicting EQU values for '{name}': "
                f"{previous.value_text} and {definition.value_text}"
            )
        if previous is None or (
            previous.status != VERIFIED and definition.status == VERIFIED
        ):
            equates_by_name[key] = definition

        scope_start = cell_text(row, "scope_start")
        scope_end = cell_text(row, "scope_end")
        source_match = cell_text(row, "source_match")
        source_replace = cell_text(row, "source_replace")
        rule_fields = (scope_start, scope_end, source_match, source_replace)
        if not any(rule_fields):
            continue
        if status != VERIFIED:
            # Proposed and disabled rows may deliberately be incomplete.
            continue
        if not all(rule_fields):
            raise ToolError(
                f"EQUATES row {excel_row} requires scope_start, scope_end, "
                "source_match, and source_replace"
            )
        match_parts = source_match.split(None, 1)
        replacement_parts = source_replace.split(None, 1)
        if len(match_parts) != 2 or len(replacement_parts) != 2:
            raise ToolError(
                f"EQUATES row {excel_row} requires complete source instructions"
            )
        if match_parts[0].casefold() != replacement_parts[0].casefold():
            raise ToolError(
                f"EQUATES row {excel_row} cannot change the instruction mnemonic"
            )
        rules.append(
            SourceRule(
                profile=row_profile,
                rule_id=f"{name}@row{excel_row}",
                action="replace_operand",
                equ_name=name,
                scope_start=scope_start,
                scope_end=scope_end,
                mnemonic=match_parts[0],
                match_operands=match_parts[1],
                expected_opcode=cell_text(row, "expected_opcode"),
                replacement_operands=replacement_parts[1],
                expected_matches=1,
                status=status,
                source_comment=cell_text(row, "source_comment"),
                notes=cell_text(row, "notes"),
            )
        )

    equates = tuple(equates_by_name.values())
    for rule in rules:
        if (
            rule.status == VERIFIED
            and equates_by_name[rule.equ_name.casefold()].status != VERIFIED
        ):
            raise ToolError(
                f"Verified source rule '{rule.rule_id}' requires verified EQU "
                f"'{rule.equ_name}'"
            )
    return equates, tuple(rules)


def _label_index(lines: list[str], label: str, rule_id: str) -> int:
    matches = [
        index
        for index, line in enumerate(lines)
        if (match := LABEL_DEFINITION.match(line))
        and match.group(1).casefold() == label.casefold()
    ]
    if len(matches) != 1:
        raise ToolError(
            f"Source rule '{rule_id}' expected one label '{label}', found {len(matches)}"
        )
    return matches[0]


def _normalise_operands(value: str) -> str:
    return re.sub(r"\s+", "", value).casefold()


def _normalise_opcode(value: str) -> str:
    return re.sub(r"[^0-9a-f]", "", value.casefold())


def apply_source_rules(
    lines: list[str],
    equates: tuple[EquateDefinition, ...],
    rules: tuple[SourceRule, ...],
) -> list[str]:
    """Apply verified operand rewrites inside fail-closed labelled scopes."""

    result = list(lines)
    applied = 0
    proposed = sum(rule.status == PROPOSED for rule in rules)
    for rule in rules:
        if rule.status != VERIFIED:
            continue
        start = _label_index(result, rule.scope_start, rule.rule_id)
        end = _label_index(result, rule.scope_end, rule.rule_id)
        if end <= start:
            raise ToolError(
                f"Source rule '{rule.rule_id}' has scope_end before scope_start"
            )
        candidates: list[int] = []
        parsed: dict[int, tuple[str, str, str]] = {}
        for index in range(start + 1, end):
            source, separator, comment = result[index].partition(";")
            match = re.match(r"^(\s*\S+\s+)(.*?)(\s*)$", source)
            if not match:
                continue
            prefix, operands, trailing = match.groups()
            mnemonic = prefix.strip()
            if mnemonic.casefold() != rule.mnemonic.casefold():
                continue
            if _normalise_operands(operands) != _normalise_operands(rule.match_operands):
                continue
            candidates.append(index)
            parsed[index] = (prefix, trailing, comment if separator else "")
        if len(candidates) != rule.expected_matches:
            raise ToolError(
                f"Source rule '{rule.rule_id}' expected {rule.expected_matches} match(es) "
                f"between '{rule.scope_start}' and '{rule.scope_end}', found {len(candidates)}"
            )
        expected_opcode = _normalise_opcode(rule.expected_opcode)
        for index in candidates:
            if expected_opcode:
                _, _, comment = parsed[index]
                opcode_match = re.match(r"\s*([0-9A-Fa-f]+)", comment)
                actual_opcode = _normalise_opcode(
                    opcode_match.group(1) if opcode_match else ""
                )
                if actual_opcode != expected_opcode:
                    raise ToolError(
                        f"Source rule '{rule.rule_id}' opcode mismatch at ASM line "
                        f"{index + 1}: expected {rule.expected_opcode}, found "
                        f"{actual_opcode.upper() or 'none'}"
                    )
            prefix, trailing, comment = parsed[index]
            suffix = f";{comment}" if comment else ""
            result[index] = (
                f"{prefix}{rule.replacement_operands}{trailing}{suffix}"
            )
            applied += 1
        print(
            f"Applied source rule '{rule.rule_id}' "
            f"({len(candidates)} instruction(s))"
        )
    if equates or rules:
        print(
            f"Source rules: {applied} instruction(s) applied, "
            f"{proposed} proposed rule(s) ignored"
        )
    return result


def insert_generated_equates(
    lines: list[str], equates: tuple[EquateDefinition, ...]
) -> list[str]:
    """Insert verified spreadsheet EQU definitions after the source EQU header."""

    verified = [equate for equate in equates if equate.status == VERIFIED]
    if not verified:
        return lines

    existing_labels = {
        match.group(1).casefold()
        for line in lines
        if (match := LABEL_DEFINITION.match(line))
    }
    for equate in verified:
        if equate.name.casefold() in existing_labels:
            raise ToolError(f"Generated EQU '{equate.name}' conflicts with a source label")

    insertion = 0
    equ_line = re.compile(
        r"^\s*[A-Za-z_?.$][\w?.$]*:\s+equ\s+", re.IGNORECASE
    )
    seen_equ = False
    for index, line in enumerate(lines):
        if not line.strip():
            if seen_equ:
                insertion = index + 1
            continue
        if equ_line.match(line):
            seen_equ = True
            insertion = index + 1
            continue
        if seen_equ:
            break

    generated = ["; ReSource: generated EQU definitions from segments.xlsx/EQUATES"]
    for equate in verified:
        generated.append(f"{equate.name}:\t\tequ\t{equate.value_text}")
        if equate.source_comment:
            generated.append(f"\t; ReSource: {equate.source_comment}")
    generated.append("; ReSource: end generated EQU definitions")
    return lines[:insertion] + generated + [""] + lines[insertion:]

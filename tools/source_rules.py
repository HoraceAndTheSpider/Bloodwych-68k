"""Spreadsheet-owned EQU definitions and scoped source operand rewrites."""

from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass
from pathlib import Path
import re

import pandas as pd

from .resource_layout import cell_text
from .tool_common import ToolError, get_profile, parse_int, resolve_cleanup_path


EQUATES_SHEET = "EQUATES"
VERIFIED = "verified"
PROPOSED = "proposed"
DISABLED = "disabled"
VALID_STATUSES = {VERIFIED, PROPOSED, DISABLED}
SYMBOL = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
LABEL_DEFINITION = re.compile(r"^\s*([A-Za-z_?.$][\w?.$]*):", re.IGNORECASE)


def _contains_symbol(expression: str, symbol: str) -> bool:
    """Return whether an operand expression contains ``symbol`` as a token."""

    pattern = rf"(?<![A-Za-z0-9_$]){re.escape(symbol)}(?![A-Za-z0-9_$])"
    return re.search(pattern, expression, re.IGNORECASE) is not None


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
        magnitude = abs(self.value)
        if magnitude <= 0xFF:
            digits = 2
        elif magnitude <= 0xFFFF:
            digits = 4
        else:
            digits = 8
        sign = "-" if self.value < 0 else ""
        return f"{sign}${magnitude:0{digits}X}"


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
    sheet: str | Path,
    master: str,
    cleanup: str | Path | None = None,
) -> tuple[tuple[EquateDefinition, ...], tuple[SourceRule, ...]]:
    """Load EQU definitions and scoped rules from the cleanup workbook."""

    path = resolve_cleanup_path(sheet, cleanup)
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
            "expected_matches",
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
        if value is None:
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
        replacement_operands = replacement_parts[1]
        if not _contains_symbol(replacement_operands, name):
            raise ToolError(
                f"EQUATES row {excel_row} source_replace must reference "
                f"equ_name '{name}'"
            )
        expected_matches = parse_int(row.get("expected_matches"))
        if expected_matches is None:
            expected_matches = 1
        if expected_matches < 1:
            raise ToolError(
                f"EQUATES row {excel_row} requires expected_matches >= 1"
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
                replacement_operands=replacement_operands,
                expected_matches=expected_matches,
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


def _label_matches(lines: list[str], label: str) -> list[int]:
    return [
        index
        for index, line in enumerate(lines)
        if (match := LABEL_DEFINITION.match(line))
        and match.group(1).casefold() == label.casefold()
    ]


def _label_index(
    lines: list[str],
    label: str,
    rule_id: str,
    label_relabels: Mapping[str, str],
) -> int:
    matches = _label_matches(lines, label)
    fallback = label_relabels.get(label.casefold())
    if not matches and fallback and fallback.casefold() != label.casefold():
        matches = _label_matches(lines, fallback)
        if len(matches) == 1:
            print(
                f"Source rule '{rule_id}' resolved relabelled scope "
                f"'{label}' as '{fallback}'"
            )
    if len(matches) != 1:
        fallback_text = f" (or relabel '{fallback}')" if fallback else ""
        raise ToolError(
            f"Source rule '{rule_id}' expected one label '{label}'{fallback_text}, "
            f"found {len(matches)}"
        )
    return matches[0]


def _normalise_operands(value: str) -> str:
    return re.sub(r"\s+", "", value).casefold()


def _normalise_opcode(value: str) -> str:
    return re.sub(r"[^0-9a-f]", "", value.casefold())


def _opcode_matches(expected: str, actual: str) -> bool:
    """Compare an expected opcode while tolerating Excel-dropped zeroes."""

    if len(expected) > len(actual):
        return False
    return expected.zfill(len(actual)) == actual


def _relabel_rule_operands(value: str, label_relabels: Mapping[str, str]) -> str:
    """Mirror ordinary relabelling inside an EQU rule's source operand."""

    result = value
    identifier_character = r"A-Za-z0-9_$?"
    for label, relabel in label_relabels.items():
        pattern = (
            rf"(?<![{identifier_character}])"
            rf"{re.escape(label)}"
            rf"(?![{identifier_character}])"
        )
        result = re.sub(pattern, relabel, result, flags=re.IGNORECASE)
    return result


def _apply_source_rule(
    lines: list[str],
    rule: SourceRule,
    label_relabels: Mapping[str, str],
) -> tuple[list[str], int]:
    """Apply one rule atomically and return its updated source and match count."""

    result = list(lines)
    start = _label_index(result, rule.scope_start, rule.rule_id, label_relabels)
    end = _label_index(result, rule.scope_end, rule.rule_id, label_relabels)
    if end <= start:
        raise ToolError(
            f"Source rule '{rule.rule_id}' has scope_end before scope_start"
        )
    candidates: list[int] = []
    parsed: dict[int, tuple[str, str, str]] = {}
    match_operands = _relabel_rule_operands(rule.match_operands, label_relabels)
    for index in range(start + 1, end):
        source, separator, comment = result[index].partition(";")
        match = re.match(r"^(\s*\S+\s+)(.*?)(\s*)$", source)
        if not match:
            continue
        prefix, operands, trailing = match.groups()
        mnemonic = prefix.strip()
        if mnemonic.casefold() != rule.mnemonic.casefold():
            continue
        if _normalise_operands(operands) != _normalise_operands(match_operands):
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
            if not _opcode_matches(expected_opcode, actual_opcode):
                raise ToolError(
                    f"Source rule '{rule.rule_id}' opcode mismatch at ASM line "
                    f"{index + 1}: expected {rule.expected_opcode}, found "
                    f"{actual_opcode.upper() or 'none'}"
                )
        prefix, trailing, comment = parsed[index]
        suffix = f";{comment}" if comment else ""
        result[index] = f"{prefix}{rule.replacement_operands}{trailing}{suffix}"
    return result, len(candidates)


def apply_source_rules(
    lines: list[str],
    equates: tuple[EquateDefinition, ...],
    rules: tuple[SourceRule, ...],
    *,
    label_relabels: Mapping[str, str] | None = None,
    continue_on_error: bool = False,
) -> list[str]:
    """Apply verified operand rewrites inside fail-closed labelled scopes."""

    result = list(lines)
    relabels = {
        label.casefold(): relabel
        for label, relabel in (label_relabels or {}).items()
    }
    applied = 0
    failed = 0
    proposed = sum(rule.status == PROPOSED for rule in rules)
    for rule in rules:
        if rule.status != VERIFIED:
            continue
        try:
            updated, match_count = _apply_source_rule(result, rule, relabels)
        except ToolError as error:
            if not continue_on_error:
                raise
            failed += 1
            print(
                f"Error applying {error}; leaving this rule unchanged and continuing"
            )
            continue
        result = updated
        applied += match_count
        print(
            f"Applied source rule '{rule.rule_id}' "
            f"({match_count} instruction(s))"
        )
    if equates or rules:
        print(
            f"Source rules: {applied} instruction(s) applied, "
            f"{failed} verified rule(s) failed safely, "
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

    generated = []
    for equate in verified:
        generated.append(f"{equate.name}:\t\tequ\t{equate.value_text}")
        if equate.source_comment:
            generated.append(f"\t; {equate.source_comment}")
    return lines[:insertion] + generated + [""] + lines[insertion:]

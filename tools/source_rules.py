"""Spreadsheet-owned EQU definitions and scoped source operand rewrites."""

from __future__ import annotations

from bisect import bisect_left, bisect_right, insort
from collections.abc import Callable, Mapping, Sequence
from dataclasses import dataclass
from pathlib import Path
import re
from time import perf_counter

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


InstructionSignature = tuple[str, str]


@dataclass(frozen=True)
class IndexedInstruction:
    """Parsed instruction data needed for indexed matching and reconstruction."""

    line_index: int
    prefix: str
    trailing: str
    comment: str
    mnemonic: str
    normalised_operands: str
    normalised_opcode: str


@dataclass
class SourceRuleMetrics:
    """ALT-only measurements for one indexed source-rule phase."""

    index_build_seconds: float = 0.0
    operand_relabel_build_seconds: float = 0.0
    rule_processing_seconds: float = 0.0
    verified_rules: int = 0
    indexed_candidates: int = 0
    rewritten_lines: int = 0
    selective_o2_lines: int = 0
    failed_rules: int = 0


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
    *,
    frame: pd.DataFrame | None = None,
) -> tuple[tuple[EquateDefinition, ...], tuple[SourceRule, ...]]:
    """Load EQU definitions and scoped rules from the cleanup workbook."""

    if frame is None:
        path = resolve_cleanup_path(sheet, cleanup)
        frame = _optional_workbook_sheet(path, EQUATES_SHEET)
    else:
        frame = _normalise_columns(frame)
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


LabelLookup = Callable[[str], Sequence[int]]


def _label_matches(
    lines: list[str], label: str, label_lookup: LabelLookup | None = None
) -> list[int]:
    if label_lookup is not None:
        return list(label_lookup(label))
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
    label_lookup: LabelLookup | None = None,
) -> int:
    matches = _label_matches(lines, label, label_lookup)
    fallback = label_relabels.get(label.casefold())
    if not matches and fallback and fallback.casefold() != label.casefold():
        matches = _label_matches(lines, fallback, label_lookup)
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


def _split_operands(value: str) -> tuple[str, ...]:
    """Split instruction operands without splitting indexed address expressions."""

    operands: list[str] = []
    start = 0
    depth = 0
    for index, character in enumerate(value):
        if character == "(":
            depth += 1
        elif character == ")":
            depth = max(0, depth - 1)
        elif character == "," and depth == 0:
            operands.append(value[start:index].strip())
            start = index + 1
    operands.append(value[start:].strip())
    return tuple(operands)


def _opcode_uses_plain_address_register(
    mnemonic: str,
    operand_index: int,
    operand_count: int,
    register: int,
    actual_opcode: str,
) -> bool:
    """Prove that one operand used the extension-free 68000 ``(An)`` EA."""

    if len(actual_opcode) < 4:
        return False
    try:
        opcode_word = int(actual_opcode[:4], 16)
    except ValueError:
        return False

    instruction = mnemonic.casefold().split(".", 1)[0]
    if instruction == "move":
        if operand_count != 2 or (opcode_word >> 12) not in (1, 2, 3):
            return False
        if operand_index == 1:
            mode = (opcode_word >> 6) & 0x7
            encoded_register = (opcode_word >> 9) & 0x7
            return mode == 2 and encoded_register == register
        if operand_index != 0:
            return False
    elif operand_index >= operand_count:
        return False

    mode = (opcode_word >> 3) & 0x7
    encoded_register = opcode_word & 0x7
    return mode == 2 and encoded_register == register


def _requires_selective_o2(
    rule: SourceRule,
    match_operands: str,
    replacement_operands: str,
    actual_opcode: str,
    zero_equate_names: set[str],
) -> bool:
    """Return whether this rewrite safely needs local Devpac O2 optimisation."""

    if not zero_equate_names:
        return False
    original = _split_operands(match_operands)
    replacement = _split_operands(replacement_operands)
    if len(original) != len(replacement):
        return False

    zero_displacements: list[tuple[int, int]] = []
    equate_displacement = re.compile(
        r"^([A-Za-z_][A-Za-z0-9_]*)\s*\(\s*a([0-7])\s*\)$",
        re.IGNORECASE,
    )
    for operand_index, operand in enumerate(replacement):
        match = equate_displacement.fullmatch(operand)
        if match and match.group(1).casefold() in zero_equate_names:
            zero_displacements.append((operand_index, int(match.group(2))))

    if not zero_displacements:
        return False
    if rule.mnemonic.casefold().split(".", 1)[0] != "move" and len(
        zero_displacements
    ) != 1:
        return False

    for operand_index, register in zero_displacements:
        plain_register = re.fullmatch(
            rf"\(\s*a{register}\s*\)", original[operand_index], re.IGNORECASE
        )
        if not plain_register or not _opcode_uses_plain_address_register(
            rule.mnemonic,
            operand_index,
            len(replacement),
            register,
            actual_opcode,
        ):
            return False
    return True


def _insert_selective_o2_directives(
    lines: list[str], line_indices: set[int]
) -> list[str]:
    """Wrap contiguous proven short-form rewrites in local Devpac O2 scopes."""

    if not line_indices:
        return lines
    result: list[str] = []
    o2_enabled = False
    for line_index, line in enumerate(lines):
        needs_o2 = line_index in line_indices
        if needs_o2 and not o2_enabled:
            result.append("\tOPT\tO2+")
            o2_enabled = True
        elif not needs_o2 and o2_enabled:
            result.append("\tOPT\tO2-")
            o2_enabled = False
        result.append(line)
    if o2_enabled:
        result.append("\tOPT\tO2-")
    return result


def _indexed_instruction(line_index: int, line: str) -> IndexedInstruction | None:
    """Parse one line using the legacy source-rule instruction grammar."""

    source, separator, comment = line.partition(";")
    match = re.match(r"^(\s*\S+\s+)(.*?)(\s*)$", source)
    if not match:
        return None
    prefix, operands, trailing = match.groups()
    preserved_comment = comment if separator else ""
    opcode_match = re.match(r"\s*([0-9A-Fa-f]+)", preserved_comment)
    return IndexedInstruction(
        line_index=line_index,
        prefix=prefix,
        trailing=trailing,
        comment=preserved_comment,
        mnemonic=prefix.strip().casefold(),
        normalised_operands=_normalise_operands(operands),
        normalised_opcode=_normalise_opcode(
            opcode_match.group(1) if opcode_match else ""
        ),
    )


class SourceInstructionIndex:
    """Dynamic signature index for the stable-line source-rule phase."""

    def __init__(self, lines: list[str]) -> None:
        self.records: dict[int, IndexedInstruction] = {}
        self.by_signature: dict[InstructionSignature, list[int]] = {}
        for line_index, line in enumerate(lines):
            self._add_record(_indexed_instruction(line_index, line))

    @staticmethod
    def signature(record: IndexedInstruction) -> InstructionSignature:
        return record.mnemonic, record.normalised_operands

    def _add_record(self, record: IndexedInstruction | None) -> None:
        if record is None:
            return
        self.records[record.line_index] = record
        signature = self.signature(record)
        indices = self.by_signature.setdefault(signature, [])
        insort(indices, record.line_index)

    def indices_for(self, signature: InstructionSignature) -> list[int]:
        return self.by_signature.get(signature, [])

    def record(self, line_index: int) -> IndexedInstruction:
        return self.records[line_index]

    def reindex_line(self, line_index: int, line: str) -> None:
        previous = self.records.pop(line_index, None)
        if previous is not None:
            signature = self.signature(previous)
            indices = self.by_signature[signature]
            position = bisect_left(indices, line_index)
            if position < len(indices) and indices[position] == line_index:
                indices.pop(position)
            if not indices:
                self.by_signature.pop(signature)
        self._add_record(_indexed_instruction(line_index, line))


class SourceOperandRelabeler:
    """Apply the exact legacy sequence using regexes compiled once for ALT."""

    def __init__(self, label_relabels: Mapping[str, str]) -> None:
        identifier_character = r"A-Za-z0-9_$?"
        self._replacements = tuple(
            (
                re.compile(
                    rf"(?<![{identifier_character}])"
                    rf"{re.escape(label)}"
                    rf"(?![{identifier_character}])",
                    re.IGNORECASE,
                ),
                replacement,
            )
            for label, replacement in label_relabels.items()
        )

    def replace(self, value: str) -> str:
        """Mirror the legacy sequential substitutions for one operand string."""

        result = value
        for pattern, replacement in self._replacements:
            result = pattern.sub(replacement, result)
        return result


def _relabel_rule_operands(value: str, label_relabels: Mapping[str, str]) -> str:
    """Mirror ordinary relabelling inside an EQU rule's operand expression."""

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
    zero_equate_names: set[str],
    label_lookup: LabelLookup | None = None,
) -> tuple[list[str], list[int], set[int]]:
    """Apply one rule atomically and return its updated source and match count."""

    result = list(lines)
    start = _label_index(
        result, rule.scope_start, rule.rule_id, label_relabels, label_lookup
    )
    end = _label_index(
        result, rule.scope_end, rule.rule_id, label_relabels, label_lookup
    )
    if end <= start:
        raise ToolError(
            f"Source rule '{rule.rule_id}' has scope_end before scope_start"
        )
    candidates: list[int] = []
    parsed: dict[int, tuple[str, str, str]] = {}
    match_operands = _relabel_rule_operands(rule.match_operands, label_relabels)
    replacement_operands = _relabel_rule_operands(
        rule.replacement_operands, label_relabels
    )
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
    selective_o2_indices: set[int] = set()
    for index in candidates:
        actual_opcode = ""
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
        else:
            _, _, comment = parsed[index]
            opcode_match = re.match(r"\s*([0-9A-Fa-f]+)", comment)
            actual_opcode = _normalise_opcode(
                opcode_match.group(1) if opcode_match else ""
            )
        if _requires_selective_o2(
            rule,
            match_operands,
            replacement_operands,
            actual_opcode,
            zero_equate_names,
        ):
            selective_o2_indices.add(index)
        prefix, trailing, comment = parsed[index]
        suffix = f";{comment}" if comment else ""
        result[index] = f"{prefix}{replacement_operands}{trailing}{suffix}"
    return result, candidates, selective_o2_indices


def apply_source_rules(
    lines: list[str],
    equates: tuple[EquateDefinition, ...],
    rules: tuple[SourceRule, ...],
    *,
    label_relabels: Mapping[str, str] | None = None,
    continue_on_error: bool = False,
    label_lookup: LabelLookup | None = None,
) -> list[str]:
    """Apply verified operand rewrites inside fail-closed labelled scopes."""

    result = list(lines)
    relabels = {
        label.casefold(): relabel
        for label, relabel in (label_relabels or {}).items()
    }
    applied = 0
    failed = 0
    selective_o2_indices: set[int] = set()
    zero_equate_names = {
        equate.name.casefold()
        for equate in equates
        if equate.status == VERIFIED and equate.value == 0
    }
    proposed = sum(rule.status == PROPOSED for rule in rules)
    for rule in rules:
        if rule.status != VERIFIED:
            continue
        try:
            updated, rewritten_indices, rule_o2_indices = _apply_source_rule(
                result,
                rule,
                relabels,
                zero_equate_names,
                label_lookup,
            )
        except ToolError as error:
            if not continue_on_error:
                raise
            failed += 1
            print(
                f"Error applying {error}; leaving this rule unchanged and continuing"
            )
            continue
        result = updated
        selective_o2_indices.difference_update(rewritten_indices)
        selective_o2_indices.update(rule_o2_indices)
        match_count = len(rewritten_indices)
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
    if selective_o2_indices:
        print(
            f"Selective O2: {len(selective_o2_indices)} proven zero-displacement "
            "instruction(s)"
        )
    return _insert_selective_o2_directives(result, selective_o2_indices)


def _apply_source_rule_indexed(
    lines: list[str],
    instruction_index: SourceInstructionIndex,
    operand_relabeler: SourceOperandRelabeler,
    rule: SourceRule,
    label_relabels: Mapping[str, str],
    zero_equate_names: set[str],
    metrics: SourceRuleMetrics,
    label_lookup: LabelLookup | None = None,
) -> tuple[list[int], set[int]]:
    """Validate one rule atomically, then update only its matching lines."""

    start = _label_index(
        lines, rule.scope_start, rule.rule_id, label_relabels, label_lookup
    )
    end = _label_index(
        lines, rule.scope_end, rule.rule_id, label_relabels, label_lookup
    )
    if end <= start:
        raise ToolError(
            f"Source rule '{rule.rule_id}' has scope_end before scope_start"
        )

    match_operands = operand_relabeler.replace(rule.match_operands)
    replacement_operands = operand_relabeler.replace(rule.replacement_operands)
    signature = (
        rule.mnemonic.casefold(),
        _normalise_operands(match_operands),
    )
    matching_indices = instruction_index.indices_for(signature)
    left = bisect_right(matching_indices, start)
    right = bisect_left(matching_indices, end)
    candidates = matching_indices[left:right]
    metrics.indexed_candidates += len(candidates)

    if len(candidates) != rule.expected_matches:
        raise ToolError(
            f"Source rule '{rule.rule_id}' expected {rule.expected_matches} match(es) "
            f"between '{rule.scope_start}' and '{rule.scope_end}', found {len(candidates)}"
        )

    expected_opcode = _normalise_opcode(rule.expected_opcode)
    for line_index in candidates:
        record = instruction_index.record(line_index)
        if expected_opcode and not _opcode_matches(
            expected_opcode, record.normalised_opcode
        ):
            raise ToolError(
                f"Source rule '{rule.rule_id}' opcode mismatch at ASM line "
                f"{line_index + 1}: expected {rule.expected_opcode}, found "
                f"{record.normalised_opcode.upper() or 'none'}"
            )

    updates: list[tuple[int, str]] = []
    selective_o2_indices: set[int] = set()
    for line_index in candidates:
        record = instruction_index.record(line_index)
        if _requires_selective_o2(
            rule,
            match_operands,
            replacement_operands,
            record.normalised_opcode,
            zero_equate_names,
        ):
            selective_o2_indices.add(line_index)
        suffix = f";{record.comment}" if record.comment else ""
        updates.append(
            (
                line_index,
                f"{record.prefix}{replacement_operands}{record.trailing}{suffix}",
            )
        )

    for line_index, updated in updates:
        lines[line_index] = updated
        instruction_index.reindex_line(line_index, updated)
    return list(candidates), selective_o2_indices


def apply_source_rules_indexed(
    lines: list[str],
    equates: tuple[EquateDefinition, ...],
    rules: tuple[SourceRule, ...],
    *,
    label_relabels: Mapping[str, str] | None = None,
    continue_on_error: bool = False,
    label_lookup: LabelLookup | None = None,
    metrics: SourceRuleMetrics | None = None,
) -> list[str]:
    """Apply source rules sequentially through a dynamic instruction index."""

    result = list(lines)
    measurements = metrics if metrics is not None else SourceRuleMetrics()
    index_started = perf_counter()
    instruction_index = SourceInstructionIndex(result)
    measurements.index_build_seconds = perf_counter() - index_started
    relabels = {
        label.casefold(): relabel
        for label, relabel in (label_relabels or {}).items()
    }
    operand_relabel_started = perf_counter()
    operand_relabeler = SourceOperandRelabeler(relabels)
    measurements.operand_relabel_build_seconds = (
        perf_counter() - operand_relabel_started
    )
    applied = 0
    selective_o2_indices: set[int] = set()
    zero_equate_names = {
        equate.name.casefold()
        for equate in equates
        if equate.status == VERIFIED and equate.value == 0
    }
    proposed = sum(rule.status == PROPOSED for rule in rules)
    processing_started = perf_counter()
    try:
        for rule in rules:
            if rule.status != VERIFIED:
                continue
            measurements.verified_rules += 1
            try:
                rewritten_indices, rule_o2_indices = _apply_source_rule_indexed(
                    result,
                    instruction_index,
                    operand_relabeler,
                    rule,
                    relabels,
                    zero_equate_names,
                    measurements,
                    label_lookup,
                )
            except ToolError as error:
                measurements.failed_rules += 1
                if not continue_on_error:
                    raise
                print(
                    f"Error applying {error}; leaving this rule unchanged and continuing"
                )
                continue
            selective_o2_indices.difference_update(rewritten_indices)
            selective_o2_indices.update(rule_o2_indices)
            match_count = len(rewritten_indices)
            applied += match_count
            measurements.rewritten_lines += match_count
            print(
                f"Applied source rule '{rule.rule_id}' "
                f"({match_count} instruction(s))"
            )
    finally:
        measurements.rule_processing_seconds = perf_counter() - processing_started

    if equates or rules:
        print(
            f"Source rules: {applied} instruction(s) applied, "
            f"{measurements.failed_rules} verified rule(s) failed safely, "
            f"{proposed} proposed rule(s) ignored"
        )
    measurements.selective_o2_lines = len(selective_o2_indices)
    if selective_o2_indices:
        print(
            f"Selective O2: {len(selective_o2_indices)} proven zero-displacement "
            "instruction(s)"
        )
    return _insert_selective_o2_directives(result, selective_o2_indices)


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

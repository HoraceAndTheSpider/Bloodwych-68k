"""Final whitespace-only formatting for generated relabelled ASM sources."""

from __future__ import annotations

import re
import textwrap
from pathlib import Path
from typing import Mapping

import pandas as pd

from .tool_common import (
    ToolError,
    get_profile,
    load_segments,
    parse_int,
    resolve_cleanup_path,
)
from .resource_layout import cell_text

# The ASM is conventionally viewed with four-character tab stops. Keeping
# this explicit matters because a tab count that aligns at eight columns does
# not align in the editor used for the generated source.
TAB_WIDTH = 4
COMMENT_WIDTH = 80
INSTRUCTION_COMMENT_COLUMN = 80
LABEL_LINE = re.compile(r"^\s*([A-Za-z_.$][A-Za-z0-9_.$]*):\s*$")
OPCODE_LINE = re.compile(r"^\t+([^\s;]+)(?:\s+(.*?))?\s*$")
DECLARATION_OPCODE = re.compile(r"^(?:dc\.[bwlqdsx]|ds\.[bwlqdsx]|incbin)$", re.IGNORECASE)
EQU_LINE = re.compile(
    r"^\s*(?P<label>[A-Za-z_.$][A-Za-z0-9_.$]*:?)\s+"
    r"(?P<opcode>equ|equate)\s+(?P<value>.+?)\s*$",
    re.IGNORECASE,
)
LABEL_DEFINITION = re.compile(r"^\s*([A-Za-z_.$?][\w.$?]*)\s*:")
COMMENTS_SHEET = "COMMENTS"
COMMENT_COLUMNS = (
    "profile",
    "scope_start",
    "scope_end",
    "source_match",
    "source_comment",
    "expected_matches",
)

# Legacy disassemblies append these machine notes to the opcode bytes. They
# are not handwritten explanations; accept only these exact suffixes so real
# source comments remain protected.
GENERATED_INSTRUCTION_COMMENT = re.compile(
    r"[0-9A-Fa-f]+(?:\s*;\s*(?:Short Absolute converted to symbol!|"
    r"Long Addr replaced with Symbol))*\s*"
)
INCLUDE_LINE = re.compile(
    r"^\s*include\s+(?:[\"'](?P<quoted>[^\"']+)[\"']|(?P<bare>\S+))\s*$",
    re.IGNORECASE,
)


def _next_tab_stop(column: int) -> int:
    return ((column // TAB_WIDTH) + 1) * TAB_WIDTH


def _display_column(text: str) -> int:
    column = 0
    for character in text:
        if character == "\t":
            column = _next_tab_stop(column)
        else:
            column += 1
    return column


def _pad_to_column(text: str, target: int) -> str:
    """Append tabs until ``text`` reaches the requested display column."""
    while _display_column(text) < target:
        text += "\t"
    return text


def _comment_text(line: str) -> str | None:
    stripped = line.lstrip(" \t")
    if not stripped.startswith(";"):
        return None
    return stripped[1:].strip()


def _split_equ(line: str) -> tuple[str, str, str, str] | None:
    """Return label, opcode, value, and inline comment from an EQU line."""
    code, separator, comment = line.partition(";")
    match = EQU_LINE.match(code.rstrip())
    if not match:
        return None
    return (
        match.group("label").strip(),
        match.group("opcode").strip(),
        match.group("value").strip(),
        comment.strip() if separator else "",
    )


def _format_equ_lines(lines: list[str]) -> list[str]:
    """Align EQU fields and merge their following indented comments inline."""
    entries: dict[int, tuple[str, str, str, str]] = {}
    consumed_comments: set[int] = set()

    for index, line in enumerate(lines):
        entry = _split_equ(line)
        if entry is None:
            continue
        label, opcode, value, inline_comment = entry
        comment_parts = [inline_comment] if inline_comment else []
        if not inline_comment:
            following = index + 1
            while following < len(lines):
                candidate = lines[following]
                comment = _comment_text(candidate)
                if not candidate[:1].isspace() or comment is None:
                    break
                comment_parts.append(comment)
                consumed_comments.add(following)
                following += 1
        entries[index] = (label, opcode, value, " ".join(comment_parts).strip())

    if not entries:
        return lines

    equ_column = _next_tab_stop(
        max(_display_column(label) for label, _opcode, _value, _comment in entries.values())
    )
    code_fields: dict[int, str] = {}
    for index, (label, opcode, value, _comment) in entries.items():
        code = _pad_to_column(label, equ_column) + opcode + "\t" + value
        code_fields[index] = code
    comment_column = max(
        _next_tab_stop(_display_column(code)) for code in code_fields.values()
    )

    result: list[str] = []
    for index, line in enumerate(lines):
        if index in consumed_comments:
            continue
        entry = entries.get(index)
        if entry is None:
            result.append(line)
            continue
        _label, _opcode, _value, comment = entry
        code = code_fields[index]
        if comment:
            code = _pad_to_column(code, comment_column) + "; " + comment
        result.append(code.rstrip())
    return result


def _equate_group(name: str) -> str:
    """Return the semantic family used to space cleanup-owned EQU definitions."""

    if not name[:1].isupper() or name.isupper():
        return "__source__"
    return name.partition("_")[0].casefold()


def _leading_equate_block(lines: list[str]) -> tuple[int, int] | None:
    """Locate the static EQU header, excluding location-dependent aliases later on."""

    start: int | None = None
    for index, line in enumerate(lines):
        if _split_equ(line) is not None:
            if start is None:
                start = index
            continue
        if not line.strip() or _comment_text(line) is not None:
            continue
        if start is None:
            return None
        return start, index
    return (start, len(lines)) if start is not None else None


def _include_line_matches(line: str, include_name: str) -> bool:
    match = INCLUDE_LINE.match(line)
    if match is None:
        return False
    operand = match.group("quoted") or match.group("bare")
    return Path(operand).name.casefold() == include_name.casefold()


def _format_equates_include(
    block: list[str],
) -> list[str]:
    """Group and format the EQU definitions already present in the source."""

    formatted = _format_equ_lines(block)
    entries: list[tuple[str, str]] = []
    unexpected: list[str] = []
    for line in formatted:
        parsed = _split_equ(line)
        if parsed is not None:
            entries.append((parsed[0].removesuffix(":"), line))
        elif line.strip():
            unexpected.append(line)
    if unexpected:
        raise ToolError(
            "Cannot create the EQU include because the static header contains "
            "standalone content that cannot be moved safely"
        )

    groups: dict[str, list[tuple[str, str]]] = {}
    for name, line in entries:
        groups.setdefault(_equate_group(name), []).append((name, line))

    result = [
        "; Generated from the static EQU header by the final formatting pass.",
        "; Regenerate this file from the final relabel-data source; do not edit it.",
        "",
    ]
    group_names = sorted(
        groups,
        key=lambda group: (group != "__source__", group),
    )
    for group_index, group in enumerate(group_names):
        if group_index:
            result.append("")
        group_entries = groups[group]
        if group != "__source__":
            group_entries = sorted(group_entries, key=lambda item: item[0].casefold())
        result.extend(line for _name, line in group_entries)
    return result


def _externalise_equate_header(
    lines: list[str],
    include_name: str,
    existing_include_lines: list[str] | None = None,
) -> tuple[list[str], list[str] | None]:
    """Replace the static EQU header with an INCLUDE and return its file lines."""

    include_indices = [
        index
        for index, line in enumerate(lines)
        if _include_line_matches(line, include_name)
    ]
    block = _leading_equate_block(lines)
    if block is None:
        if len(include_indices) > 1:
            raise ToolError(f"Found more than one INCLUDE for '{include_name}'")
        if len(include_indices) == 1:
            existing_block = (
                _leading_equate_block(existing_include_lines)
                if existing_include_lines is not None
                else None
            )
            if existing_block is None or existing_include_lines is None:
                raise ToolError(
                    f"Cannot refresh EQU include because '{include_name}' is missing "
                    "or has no static EQU header"
                )
            start, end = existing_block
            return lines, _format_equates_include(existing_include_lines[start:end])
        return lines, None
    if include_indices:
        raise ToolError(
            f"Generated source contains both an EQU header and INCLUDE '{include_name}'"
        )

    start, end = block
    include_lines = _format_equates_include(lines[start:end])
    replacement = [f'\tINCLUDE\t"{include_name}"', ""]
    while end < len(lines) and not lines[end].strip():
        end += 1
    return lines[:start] + replacement + lines[end:], include_lines


def _wrap_comment(line: str) -> list[str]:
    """Wrap a standalone indented comment without breaking words."""
    text = line.lstrip(" \t")
    if not text.startswith(";"):
        return [line]
    text = text[1:].lstrip()
    prefix = "\t; "
    width = COMMENT_WIDTH - len(prefix)
    wrapped = textwrap.wrap(
        text,
        width=width,
        break_long_words=False,
        break_on_hyphens=False,
    ) or [""]
    return [prefix + part for part in wrapped]


def _split_instruction(line: str) -> tuple[str, str, str] | None:
    """Return opcode, operands, and comment for a normal instruction line."""
    if not line.startswith("\t") or line.lstrip().startswith(";"):
        return None
    code, separator, comment = line.partition(";")
    match = OPCODE_LINE.match(code.rstrip())
    if not match:
        return None
    opcode = match.group(1)
    operands = (match.group(2) or "").strip()
    first_operand = operands.split(None, 1)[0].casefold() if operands else ""
    if (
        DECLARATION_OPCODE.fullmatch(opcode)
        or opcode.casefold() in {"equ", "equate"}
        or first_operand in {"equ", "equate"}
    ):
        return None
    return opcode, operands, (comment.strip() if separator else "")


def _split_source_comment(line: str) -> tuple[str, str]:
    """Split an ASM line at its first comment delimiter."""
    code, separator, comment = line.partition(";")
    return code, comment if separator else ""


def _normalise_source_match(value: str) -> str:
    """Compare instruction text without making spreadsheet whitespace significant."""
    return re.sub(r"\s+", "", value).casefold()


def _label_indices(lines: list[str]) -> dict[str, list[int]]:
    indices: dict[str, list[int]] = {}
    for index, line in enumerate(lines):
        match = LABEL_DEFINITION.match(line)
        if match:
            indices.setdefault(match.group(1).casefold(), []).append(index)
    return indices


def _segment_label_relabels(
    sheet: str | Path,
    master: str,
) -> dict[str, str]:
    """Return unambiguous original-to-relabel mappings from segments metadata."""

    frame = load_segments(sheet, master)
    if "label" not in frame.columns or "relabel" not in frame.columns:
        return {}

    candidates: dict[str, dict[str, str]] = {}
    for _index, row in frame.iterrows():
        label = cell_text(row, "label")
        relabel = cell_text(row, "relabel")
        if (
            not label
            or not relabel
            or label.casefold() == relabel.casefold()
            or relabel.casefold().startswith(("_delete", "_offset_"))
        ):
            continue
        candidates.setdefault(label.casefold(), {})[relabel.casefold()] = relabel

    return {
        label: next(iter(relabels.values()))
        for label, relabels in candidates.items()
        if len(relabels) == 1
    }


def _scope_matches(
    labels: Mapping[str, list[int]],
    label: str,
    label_relabels: Mapping[str, str],
) -> tuple[list[int], str | None]:
    """Find a scope label directly, then through its segments relabel."""

    matches = labels.get(label.casefold(), [])
    fallback = label_relabels.get(label.casefold())
    if not matches and fallback and fallback.casefold() != label.casefold():
        matches = labels.get(fallback.casefold(), [])
    return matches, fallback


def _relabel_source_match(
    value: str,
    label_relabels: Mapping[str, str],
) -> str:
    """Mirror segments relabelling inside an instruction comment match."""

    if not label_relabels:
        return value
    identifier_character = r"A-Za-z0-9_$?"
    alternatives = "|".join(
        re.escape(label) for label in sorted(label_relabels, key=len, reverse=True)
    )
    pattern = re.compile(
        rf"(?<![{identifier_character}])(?:{alternatives})(?![{identifier_character}])",
        re.IGNORECASE,
    )
    return pattern.sub(
        lambda match: label_relabels[match.group(0).casefold()],
        value,
    )


def _comment_rows(
    sheet: str | Path,
    master: str,
    cleanup: str | Path | None = None,
) -> pd.DataFrame:
    """Load the profile's COMMENTS rows, or an empty frame if the tab is absent."""
    path = resolve_cleanup_path(sheet, cleanup)
    if path.suffix.casefold() == ".csv":
        return pd.DataFrame(columns=COMMENT_COLUMNS)
    with pd.ExcelFile(path) as book:
        sheet_name = next(
            (
                name
                for name in book.sheet_names
                if name.casefold() == COMMENTS_SHEET.casefold()
            ),
            None,
        )
        if sheet_name is None:
            return pd.DataFrame(columns=COMMENT_COLUMNS)
        frame = pd.read_excel(book, sheet_name=sheet_name)
    frame.columns = [str(column).strip().casefold() for column in frame.columns]
    missing = [column for column in COMMENT_COLUMNS if column not in frame.columns]
    if missing:
        raise ToolError(
            f"COMMENTS sheet is missing column(s): {', '.join(missing)}"
        )
    profile = get_profile(master).filename.casefold()
    return frame[
        frame["profile"].fillna("").astype(str).str.strip().str.casefold() == profile
    ].copy()


def apply_instruction_comments(
    lines: list[str],
    frame: pd.DataFrame,
    *,
    label_relabels: Mapping[str, str] | None = None,
) -> list[str]:
    """Replace generated HEX instruction comments from the COMMENTS sheet.

    Matching is performed against the final instruction text, after relabelling
    and EQU substitutions. Scope boundaries follow source rules: the labels
    themselves are excluded and the end label is not part of the scope. A rule
    only edits instruction comments containing opcode bytes and optional known
    legacy conversion notes. Data declarations and handwritten comments remain
    untouched.

    For compatibility with cleanup metadata anchored to original source labels,
    scope labels and label operands are retried through the unambiguous
    original-to-relabel mapping loaded from segments.xlsx.
    """
    if frame.empty:
        return list(lines)

    labels = _label_indices(lines)
    relabels = {
        label.casefold(): relabel
        for label, relabel in (label_relabels or {}).items()
    }
    result = list(lines)
    for row_index, row in frame.iterrows():
        source_match = cell_text(row, "source_match")
        source_comment = cell_text(row, "source_comment")
        if not source_match or not source_comment:
            continue

        expected = parse_int(row.get("expected_matches"))
        if expected is None:
            expected = 1
        if expected < 1:
            raise ToolError(
                f"COMMENTS row {row_index + 2} has invalid expected_matches '{expected}'"
            )

        scope_start = cell_text(row, "scope_start")
        scope_end = cell_text(row, "scope_end")
        if scope_start:
            starts, fallback = _scope_matches(labels, scope_start, relabels)
            if len(starts) != 1:
                fallback_text = f" (or relabel '{fallback}')" if fallback else ""
                print(
                    f"Error applying instruction comment at COMMENTS row {row_index + 2}: "
                    f"expected one label '{scope_start}'{fallback_text}, "
                    f"found {len(starts)}; "
                    "leaving this rule unchanged and continuing"
                )
                continue
            start = starts[0]
        else:
            start = -1
        if scope_end:
            ends, fallback = _scope_matches(labels, scope_end, relabels)
            if len(ends) != 1:
                fallback_text = f" (or relabel '{fallback}')" if fallback else ""
                print(
                    f"Error applying instruction comment at COMMENTS row {row_index + 2}: "
                    f"expected one label '{scope_end}'{fallback_text}, "
                    f"found {len(ends)}; "
                    "leaving this rule unchanged and continuing"
                )
                continue
            end = ends[0]
        else:
            end = len(result)
        if end <= start:
            print(
                f"Error applying instruction comment at COMMENTS row {row_index + 2}: "
                "scope_end is before scope_start; leaving this rule unchanged "
                "and continuing"
            )
            continue

        def matching_lines(match_text: str) -> list[int]:
            wanted = _normalise_source_match(match_text)
            candidates: list[int] = []
            for index in range(start + 1, end):
                code, _comment = _split_source_comment(result[index])
                if _normalise_source_match(code.strip()) == wanted:
                    candidates.append(index)
            return candidates

        candidates = matching_lines(source_match)
        if not candidates:
            relabelled_match = _relabel_source_match(source_match, relabels)
            if relabelled_match != source_match:
                candidates = matching_lines(relabelled_match)
        if len(candidates) != expected:
            print(
                f"Error applying instruction comment at COMMENTS row {row_index + 2}: "
                f"expected {expected} match(es) between '{scope_start}' and "
                f"'{scope_end}', found {len(candidates)}; leaving this rule "
                "unchanged and continuing"
            )
            continue

        for index in candidates:
            if _split_instruction(result[index]) is None:
                continue
            code, _comment = _split_source_comment(result[index])
            existing = _comment.strip()
            if existing and not GENERATED_INSTRUCTION_COMMENT.fullmatch(existing):
                continue
            result[index] = code.rstrip() + f"\t; {source_comment}"
    return result


def format_asm_lines(lines: list[str]) -> list[str]:
    """Format relabel-data ASM lines while changing whitespace/comments only."""
    lines = _format_equ_lines(lines)
    parsed: list[tuple[str, str, str] | None] = [_split_instruction(line) for line in lines]

    result: list[str] = []
    for line, item in zip(lines, parsed):
        label_match = LABEL_LINE.match(line)
        if label_match:
            result.append(label_match.group(1) + ":")
            continue
        if line.lstrip().startswith(";") and line.startswith("\t"):
            result.extend(_wrap_comment(line))
            continue
        if item is None:
            result.append(line)
            continue

        opcode, operands, comment = item
        separator_count = 2 if len(opcode) <= 3 else 1
        code = "\t" + opcode + ("\t" * separator_count) + operands
        if comment:
            column = _display_column(code)
            while _next_tab_stop(column) < INSTRUCTION_COMMENT_COLUMN:
                code += "\t"
                column = _display_column(code)
            code += "\t;" + comment
        result.append(code)
    return result


def format_relabel_data(
    asm_path: Path,
    sheet: str | Path | None = None,
    master: str | None = None,
    cleanup: str | Path | None = None,
) -> Path:
    """Apply COMMENTS, externalise static EQUs, and format relabel-data ASM."""
    if not asm_path.is_file():
        raise FileNotFoundError(f"Relabel-data ASM not found: {asm_path}")
    original = asm_path.read_text(encoding="utf-8")
    had_final_newline = original.endswith("\n")
    lines = original.splitlines()
    include_path: Path | None = None
    include_lines: list[str] | None = None
    if sheet is not None and master is not None:
        lines = apply_instruction_comments(
            lines,
            _comment_rows(sheet, master, cleanup),
            label_relabels=_segment_label_relabels(sheet, master),
        )
        profile = get_profile(master)
        source_stem = (
            Path(profile.source_asm).stem
            if profile.source_asm is not None
            else profile.family.title()
        )
        include_path = asm_path.with_name(f"{source_stem}_equates.asm")
        existing_include_lines = (
            include_path.read_text(encoding="utf-8").splitlines()
            if include_path.is_file()
            else None
        )
        lines, include_lines = _externalise_equate_header(
            lines,
            include_path.name,
            existing_include_lines=existing_include_lines,
        )
    formatted = "\n".join(format_asm_lines(lines))
    if had_final_newline:
        formatted += "\n"
    if include_path is not None and include_lines is not None:
        include_path.write_text(
            "\n".join(format_asm_lines(include_lines)).rstrip() + "\n",
            encoding="utf-8",
        )
    asm_path.write_text(formatted, encoding="utf-8")
    return asm_path

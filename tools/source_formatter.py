"""Final whitespace-only formatting for generated relabelled ASM sources."""

from __future__ import annotations

import re
import textwrap
from pathlib import Path


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


def format_relabel_data(asm_path: Path) -> Path:
    """Format one existing ``*_relabel_data.asm`` file in place."""
    if not asm_path.is_file():
        raise FileNotFoundError(f"Relabel-data ASM not found: {asm_path}")
    original = asm_path.read_text(encoding="utf-8")
    had_final_newline = original.endswith("\n")
    lines = original.splitlines()
    formatted = "\n".join(format_asm_lines(lines))
    if had_final_newline:
        formatted += "\n"
    asm_path.write_text(formatted, encoding="utf-8")
    return asm_path

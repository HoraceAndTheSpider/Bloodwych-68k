#!/usr/bin/env python3
"""Validate extracted data against ASM and emit verified INCBIN layouts."""

from __future__ import annotations

import re
from dataclasses import dataclass
from numbers import Integral
from pathlib import Path

import pandas as pd

from .resource_layout import (
    DATA_APPEND,
    EXTRACT_ONLY,
    ResourceLayout,
    cell_text,
    data_action,
    layout_row_indices,
    resource_layouts,
)
from .source_comments import apply_source_comments
from .tool_common import (
    ToolError,
    asm_path as project_asm_path,
    get_profile,
    load_segments,
    parse_int,
    relative_to_root,
    require_columns,
)


LABEL_DEFINITION = re.compile(r"^\s*([A-Za-z_.$?][\w.$?]*)\s*:(.*)$")
DC_DIRECTIVE = re.compile(r"^\s*dc\.(b|w|l)\s+(.+)$", re.IGNORECASE)


@dataclass(frozen=True)
class ReplacementPart:
    excel_row: int
    source_label: str
    output_label: str
    name: str
    path: Path
    offset: int | None
    size: int
    data: bytes


@dataclass(frozen=True)
class Replacement:
    start: int
    end: int
    label: str
    parts: tuple[ReplacementPart, ...]


def _split_operands(text: str) -> list[str]:
    """Split dc.* operands without treating commas inside quotes as separators."""
    parts: list[str] = []
    current: list[str] = []
    quote = ""
    for character in text:
        if quote:
            current.append(character)
            if character == quote:
                quote = ""
            continue
        if character in ("'", '"'):
            quote = character
            current.append(character)
        elif character == ",":
            parts.append("".join(current).strip())
            current = []
        else:
            current.append(character)
    parts.append("".join(current).strip())
    return parts


def _split_comment(text: str) -> tuple[str, str]:
    """Split an ASM source/comment pair while respecting quoted strings."""
    quote = ""
    for index, character in enumerate(text):
        if quote:
            if character == quote:
                quote = ""
            continue
        if character in ("'", '"'):
            quote = character
        elif character == ";":
            return text[:index], text[index + 1 :]
    return text, ""


def _numeric_value(operand: str) -> int | None:
    text = operand.strip()
    sign = 1
    if text.startswith(("+", "-")):
        if text[0] == "-":
            sign = -1
        text = text[1:].strip()
    try:
        if text.startswith("$"):
            return sign * int(text[1:], 16)
        if text.startswith("%"):
            return sign * int(text[1:], 2)
        if text.casefold().startswith("0x"):
            return sign * int(text, 16)
        return sign * int(text, 10)
    except ValueError:
        return None


def _encode_value(value: int, width: int) -> bytes:
    mask = (1 << (width * 8)) - 1
    return (value & mask).to_bytes(width, "big")


def _parse_dc_bytes(source: str) -> bytes | None:
    """Parse one dc.b/w/l line, using ReSource's hex comment as fallback.

    Expressions such as ``dc.w End-Start ;00A8`` cannot be evaluated without
    assembling the source. ReSource already records their encoded bytes in the
    trailing comment, so that exact-width comment is used when an operand is
    symbolic.
    """
    statement, comment = _split_comment(source)
    match = DC_DIRECTIVE.match(statement)
    if not match:
        return None

    width = {"b": 1, "w": 2, "l": 4}[match.group(1).casefold()]
    operands = _split_operands(match.group(2))
    encoded = bytearray()
    unresolved = False
    fallback_width = 0

    for operand in operands:
        if not operand:
            unresolved = True
            fallback_width += width
            continue
        if (
            len(operand) >= 2
            and operand[0] in ("'", '"')
            and operand[-1] == operand[0]
        ):
            delimiter = operand[0]
            # Devpac escapes the active string delimiter by doubling it, so
            # ``'N''EGG'`` emits the five bytes for ``N'EGG`` rather than two
            # apostrophes. The same rule applies to double-quoted strings.
            literal = operand[1:-1].replace(delimiter * 2, delimiter).encode(
                "latin-1"
            )
            encoded.extend(literal)
            fallback_width += len(literal)
            continue
        value = _numeric_value(operand)
        if value is None:
            unresolved = True
        else:
            encoded.extend(_encode_value(value, width))
        fallback_width += width

    if not unresolved:
        return bytes(encoded)

    comment_match = re.match(r"\s*([0-9A-Fa-f]+)(?:\s|$)", comment)
    if not comment_match:
        return None
    comment_hex = comment_match.group(1)
    if len(comment_hex) != fallback_width * 2:
        return None
    return bytes.fromhex(comment_hex)


def _find_label(lines: list[str], candidates: list[str]) -> tuple[int, str] | None:
    for candidate in candidates:
        if not candidate:
            continue
        pattern = re.compile(rf"^\s*{re.escape(candidate)}\s*:", re.IGNORECASE)
        matches = [index for index, line in enumerate(lines) if pattern.match(line)]
        if len(matches) == 1:
            return matches[0], candidate
        if len(matches) > 1:
            raise ToolError(
                f"Cannot safely inspect '{candidate}': {len(matches)} definitions found"
            )
    return None


def _scan_source_bytes(
    lines: list[str], start: int, expected_size: int
) -> tuple[bytes, int, str | None]:
    """Consume exactly ``expected_size`` dc.* bytes across internal labels."""
    data = bytearray()
    index = start

    while index < len(lines) and len(data) < expected_size:
        line = lines[index]
        content = line
        label_match = LABEL_DEFINITION.match(line)
        if label_match:
            content = label_match.group(2)

        stripped = content.strip()
        if not stripped or stripped.startswith(";"):
            index += 1
            continue

        block = _parse_dc_bytes(content)
        if block is None:
            return (
                bytes(data),
                index,
                f"non-data or unresolved source at ASM line {index + 1}: {stripped}",
            )
        if len(data) + len(block) > expected_size:
            return (
                bytes(data),
                index,
                f"dc.* data crosses declared end at ASM line {index + 1}",
            )
        data.extend(block)
        index += 1

    if len(data) != expected_size:
        return bytes(data), index, f"source ended after {len(data)} of {expected_size} bytes"
    return bytes(data), index, None


def _row_number(index: object) -> int:
    return int(index) + 2 if isinstance(index, Integral) else 0


def _part_from_row(
    index: object,
    row: pd.Series,
    clean_dir: Path,
    label_col: str,
    *,
    grouped: bool,
) -> ReplacementPart:
    excel_row = _row_number(index)
    name = cell_text(row, "name")
    source_label = cell_text(row, "label")
    size = parse_int(row.get("size"))

    if grouped:
        output_label = cell_text(row, "relabel")
        offset = parse_int(row.get("offset"))
        if not source_label or not output_label or offset is None or offset < 0:
            raise ToolError(
                f"Grouped spreadsheet row {excel_row} requires label, relabel, and offset"
            )
    else:
        output_label = cell_text(row, label_col)
        offset = parse_int(row.get("offset"))
    if not name or not output_label or size is None or size <= 0:
        raise ToolError(
            f"Spreadsheet row {excel_row} requires name, output label, and a positive size"
        )

    path = clean_dir / Path(name)
    if not path.is_file():
        raise ToolError(f"Missing extracted file for spreadsheet row {excel_row}: {path}")
    actual_size = path.stat().st_size
    if actual_size != size:
        raise ToolError(
            f"Extracted '{name}' is {actual_size} bytes; spreadsheet row "
            f"{excel_row} declares {size}"
        )
    return ReplacementPart(
        excel_row=excel_row,
        source_label=source_label,
        output_label=output_label,
        name=name,
        path=path,
        offset=offset,
        size=size,
        data=path.read_bytes(),
    )


def _layout_parts(
    layout: ResourceLayout, clean_dir: Path, label_col: str
) -> tuple[ReplacementPart, ...]:
    parts = tuple(
        _part_from_row(index, row, clean_dir, label_col, grouped=True)
        for index, row in layout.rows
    )
    if len({part.output_label.casefold() for part in parts}) != len(parts):
        raise ToolError(
            f"Grouped resource at spreadsheet row {parts[0].excel_row} requires "
            "a unique relabel for every emitted INCBIN"
        )
    for previous, current in zip(parts, parts[1:]):
        expected = previous.offset + previous.size  # type: ignore[operator]
        if current.offset != expected:
            raise ToolError(
                f"Grouped resource is not contiguous: spreadsheet row "
                f"{current.excel_row} starts at {current.offset:#x}, expected {expected:#x}"
            )
    return parts


def _rows_match_filters(
    rows: tuple[tuple[object, pd.Series], ...],
    name_filter: str | None,
    label_filter: str | None,
) -> bool:
    if name_filter and not any(
        cell_text(row, "name").casefold() == name_filter.casefold()
        for _, row in rows
    ):
        return False
    if label_filter and not any(
        label_filter.casefold()
        in (cell_text(row, "label").casefold(), cell_text(row, "relabel").casefold())
        for _, row in rows
    ):
        return False
    return True


def _matches_filters(
    parts: tuple[ReplacementPart, ...],
    name_filter: str | None,
    label_filter: str | None,
) -> bool:
    if name_filter and not any(
        part.name.casefold() == name_filter.casefold() for part in parts
    ):
        return False
    if label_filter and not any(
        label_filter.casefold()
        in (part.source_label.casefold(), part.output_label.casefold())
        for part in parts
    ):
        return False
    return True


def _mismatch_message(expected: bytes, actual: bytes) -> str:
    limit = min(len(expected), len(actual))
    mismatch = next((index for index in range(limit) if expected[index] != actual[index]), None)
    if mismatch is None:
        mismatch = limit
    start = max(0, mismatch - 8)
    end = min(max(len(expected), len(actual)), mismatch + 8)
    return (
        f"first mismatch at +${mismatch:X}; "
        f"file={expected[start:end].hex()} source={actual[start:end].hex()}"
    )


def _replacement_lines(replacement: Replacement) -> list[str]:
    generated = [f"{replacement.label}:"]
    for part_index, part in enumerate(replacement.parts):
        if part_index:
            generated.append(f"{part.output_label}:")
        if part.size % 2:
            # Devpac pads every odd-length INCBIN with a zero byte. Emit the
            # extracted bytes directly so splitting a source block at an odd
            # boundary remains byte-exact. Rerunning Inspect refreshes these
            # lines from the corresponding external data file.
            for start in range(0, len(part.data), 16):
                values = ",".join(
                    f"${value:02X}" for value in part.data[start : start + 16]
                )
                generated.append(f"\tdc.b\t{values}")
        else:
            relative_path = str(relative_to_root(part.path)).replace("\\", "/")
            generated.append(f'\tINCBIN "/{relative_path.lstrip("/")}"')
    return generated


def _removed_labels(lines: list[str], replacement: Replacement) -> tuple[str, ...]:
    """Return internal source labels that an INCBIN replacement would remove."""
    emitted = {
        replacement.label.casefold(),
        *(part.output_label.casefold() for part in replacement.parts),
    }
    labels: list[str] = []
    for line in lines[replacement.start + 1 : replacement.end]:
        match = LABEL_DEFINITION.match(line)
        if match and match.group(1).casefold() not in emitted:
            labels.append(match.group(1))
    return tuple(labels)


def _external_label_references(
    lines: list[str],
    label: str,
    removed_spans: list[tuple[int, int]],
) -> list[int]:
    """Find code references that will remain after accepted replacements."""
    pattern = re.compile(
        rf"(?<![\w.$?]){re.escape(label)}(?![\w.$?])",
        re.IGNORECASE,
    )
    references: list[int] = []
    for index, line in enumerate(lines):
        if any(start <= index < end for start, end in removed_spans):
            continue
        source, _ = _split_comment(line)
        if pattern.search(source):
            references.append(index)
    return references


def inspect_source(
    master,
    sheet,
    name_filter=None,
    label_filter=None,
    debug=False,
) -> Path:
    """Validate spreadsheet resources and write a verified ``*_data.asm``.

    Ordinary rows replace one exact-size dc.* region with one INCBIN. A
    ``data_start`` row plus its immediately following ``data_append`` rows form
    one atomic layout: their files are concatenated for validation, while each
    receives its own label and generated data directive. Even-sized resources
    use INCBIN; odd-sized resources use exact dc.b data because Devpac otherwise
    appends a padding byte. ``extract_only`` rows remain available to extraction
    but never replace or patch source data.
    """
    profile = get_profile(master)
    clean_dir = profile.clean_dir

    relabel_file = project_asm_path(master, "relabel")
    if relabel_file.is_file():
        asm_path, label_col = relabel_file, "relabel"
        print(f"Using relabel ASM {asm_path}")
    else:
        asm_path, label_col = project_asm_path(master, "source"), "label"
    if not asm_path.is_file():
        raise ToolError(f"ASM source not found: {asm_path}")

    lines = asm_path.read_text(encoding="utf-8", errors="ignore").splitlines()
    working_lines = list(lines)
    frame = load_segments(sheet, master)
    require_columns(frame, ("label", "relabel", "name", "size", label_col))
    layouts = resource_layouts(frame)
    grouped_indices = layout_row_indices(layouts)
    layouts_by_start = {layout.start_index: layout for layout in layouts}

    replacements: list[Replacement] = []
    valid_count = 0
    failed_count = 0
    skipped_count = 0

    for index, row in frame.iterrows():
        action = data_action(row)
        if action == EXTRACT_ONLY:
            if debug and cell_text(row, "name"):
                print(f"Skip {cell_text(row, 'name')} (extract_only)")
            continue
        if index in grouped_indices and action == DATA_APPEND:
            continue

        grouped = index in layouts_by_start
        selected_rows = (
            layouts_by_start[index].rows if grouped else ((index, row),)
        )
        if not _rows_match_filters(selected_rows, name_filter, label_filter):
            continue
        try:
            if grouped:
                parts = _layout_parts(layouts_by_start[index], clean_dir, label_col)
            else:
                name = cell_text(row, "name")
                label = cell_text(row, label_col)
                if not name or not label:
                    continue
                if label.casefold().startswith(("_delete", "_offset_")):
                    continue
                parts = (
                    _part_from_row(index, row, clean_dir, label_col, grouped=False),
                )
        except ToolError as error:
            print(f"FAIL - {error}")
            failed_count += 1
            continue

        if not _matches_filters(parts, name_filter, label_filter):
            continue

        description = " + ".join(part.name for part in parts)
        print(
            f"Check {description}@{parts[0].output_label} "
            f"row{parts[0].excel_row}"
        )
        candidates = [cell_text(row, label_col), parts[0].source_label]
        found = _find_label(lines, list(dict.fromkeys(candidates)))
        if found is None:
            print(f"  no label match for '{parts[0].source_label}'; skipping")
            skipped_count += 1
            continue
        start, found_label = found
        expected = b"".join(part.data for part in parts)
        actual, end, scan_error = _scan_source_bytes(lines, start, len(expected))
        if scan_error or actual != expected:
            print("  FAIL - source block retained")
            failed_count += 1
            if scan_error:
                print(f"    {scan_error}")
            if debug and actual != expected:
                print(f"    {_mismatch_message(expected, actual)}")
            continue

        print("  VALID")
        valid_count += 1
        emitted_label = parts[0].output_label if label_col == "relabel" else found_label
        replacements.append(
            Replacement(
                start=start,
                end=end,
                label=emitted_label,
                parts=parts,
            )
        )

    conflicted: set[int] = set()
    ordered = sorted(enumerate(replacements), key=lambda item: item[1].start)
    for position, (left_index, left) in enumerate(ordered):
        for right_index, right in ordered[position + 1 :]:
            if right.start >= left.end:
                break
            conflicted.update((left_index, right_index))
            print(
                f"FAIL - overlapping source replacements at ASM lines "
                f"{left.start + 1} and {right.start + 1}; both retained"
            )

    rejected = set(conflicted)
    while True:
        accepted_indices = set(range(len(replacements))) - rejected
        removed_spans = [
            (replacement.start, replacement.end)
            for index, replacement in enumerate(replacements)
            if index in accepted_indices
        ]
        newly_unsafe: set[int] = set()
        for index in accepted_indices:
            replacement = replacements[index]
            for label in _removed_labels(lines, replacement):
                references = _external_label_references(lines, label, removed_spans)
                if references:
                    locations = ", ".join(str(line + 1) for line in references[:4])
                    suffix = "..." if len(references) > 4 else ""
                    print(
                        f"FAIL - replacing ASM line {replacement.start + 1} would "
                        f"remove referenced label '{label}' (line(s) {locations}{suffix}); "
                        "source block retained"
                    )
                    newly_unsafe.add(index)
                    break
        newly_unsafe -= rejected
        if not newly_unsafe:
            break
        rejected.update(newly_unsafe)

    if rejected:
        failed_count += len(rejected)
        valid_count -= len(rejected)
    accepted = [
        replacement
        for index, replacement in enumerate(replacements)
        if index not in rejected
    ]
    for replacement in sorted(accepted, key=lambda item: item.start, reverse=True):
        working_lines[replacement.start : replacement.end] = _replacement_lines(replacement)

    working_lines = apply_source_comments(working_lines, frame)

    new_name = asm_path.with_name(f"{asm_path.stem}_data{asm_path.suffix}")
    new_name.write_text("\n".join(working_lines) + "\n", encoding="utf-8")
    print(f"Modified ASM written to {new_name}")
    print(
        "Inspection summary: "
        f"{valid_count} valid/replaced, "
        f"{failed_count} failed/retained, "
        f"{skipped_count} skipped"
    )
    return new_name

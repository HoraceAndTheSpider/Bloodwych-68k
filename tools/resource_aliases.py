"""Temporary EQU aliases for grouped resources before INCBIN generation."""

from __future__ import annotations

from dataclasses import dataclass
from numbers import Integral
import re

from .resource_layout import ResourceLayout, cell_text
from .tool_common import ToolError, parse_int


TEMPORARY_ALIAS_MARKER = "ReSource: temporary data_append alias"
TEMPORARY_ALIAS_BEGIN = "; ReSource: temporary data_append aliases"
TEMPORARY_ALIAS_END = f"; ReSource: end temporary data_append aliases"
LABEL_DEFINITION = re.compile(r"^\s*([A-Za-z_.$?][\w.$?]*)\s*:")
END_DIRECTIVE = re.compile(r"^\s*end(?:\s|$)", re.IGNORECASE)


@dataclass(frozen=True)
class ResourceAlias:
    name: str
    base: str
    relative_offset: int

    @property
    def source_line(self) -> str:
        return (
            f"{self.name}:\t\tequ\t{self.base}+${self.relative_offset:X}"
            f"\t; {TEMPORARY_ALIAS_MARKER}"
        )


def resource_aliases(
    layouts: tuple[ResourceLayout, ...],
) -> tuple[ResourceAlias, ...]:
    """Derive aliases for appended resources without original source labels."""

    aliases: list[ResourceAlias] = []
    seen: set[str] = set()
    for layout in layouts:
        _, first = layout.rows[0]
        base = cell_text(first, "relabel")
        start_offset = parse_int(first.get("offset"))
        for index, row in layout.rows[1:]:
            # A distinct source label already exists and is renamed normally.
            if cell_text(row, "label").casefold() != layout.source_label.casefold():
                continue
            excel_row = int(index) + 2 if isinstance(index, Integral) else index
            name = cell_text(row, "relabel")
            offset = parse_int(row.get("offset"))
            if not base or start_offset is None or not name or offset is None:
                raise ToolError(
                    f"data_append at spreadsheet row {excel_row} requires relabel "
                    "and offset values for temporary alias generation"
                )
            relative = offset - start_offset
            if relative <= 0:
                raise ToolError(
                    f"data_append at spreadsheet row {excel_row} must follow its "
                    "data_start offset"
                )
            key = name.casefold()
            if key in seen:
                raise ToolError(f"Duplicate temporary data_append alias '{name}'")
            seen.add(key)
            aliases.append(ResourceAlias(name, base, relative))
    return tuple(aliases)


def insert_temporary_aliases(
    lines: list[str], layouts: tuple[ResourceLayout, ...]
) -> list[str]:
    """Insert derived aliases before the final assembler ``end`` directive."""

    aliases = resource_aliases(layouts)
    if not aliases:
        return lines

    existing = {
        match.group(1).casefold()
        for line in lines
        if (match := LABEL_DEFINITION.match(line))
    }
    conflicts = [alias.name for alias in aliases if alias.name.casefold() in existing]
    if conflicts:
        raise ToolError(
            "Temporary data_append alias conflicts with source label(s): "
            + ", ".join(conflicts)
        )

    insertion = next(
        (index for index, line in enumerate(lines) if END_DIRECTIVE.match(line)),
        len(lines),
    )
    generated = [
        TEMPORARY_ALIAS_BEGIN,
        *(alias.source_line for alias in aliases),
        TEMPORARY_ALIAS_END,
        "",
    ]
    print(f"Generated {len(aliases)} temporary data_append alias(es)")
    return lines[:insertion] + generated + lines[insertion:]


def remove_temporary_aliases(
    lines: list[str], emitted_labels: set[str]
) -> list[str]:
    """Remove aliases replaced by real labels, retaining aliases for failures."""

    keys = {label.casefold() for label in emitted_labels}
    if not keys:
        return lines

    result: list[str] = []
    for line in lines:
        source, separator, comment = line.partition(";")
        match = LABEL_DEFINITION.match(source)
        if (
            match
            and separator
            and TEMPORARY_ALIAS_MARKER.casefold() in comment.casefold()
            and match.group(1).casefold() in keys
        ):
            continue
        result.append(line)

    any_aliases = any(
        TEMPORARY_ALIAS_MARKER.casefold() in line.casefold()
        and line.strip() not in (TEMPORARY_ALIAS_BEGIN, TEMPORARY_ALIAS_END)
        for line in result
    )
    if not any_aliases:
        result = [
            line
            for line in result
            if line.strip() not in (TEMPORARY_ALIAS_BEGIN, TEMPORARY_ALIAS_END)
        ]
    return result

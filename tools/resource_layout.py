"""Spreadsheet-driven layouts for splitting one ASM data region into files."""

from __future__ import annotations

from dataclasses import dataclass
from numbers import Integral
from typing import Hashable

import pandas as pd

from .tool_common import ToolError


DATA_ACTION_COLUMN = "data_action"
DATA_START = "data_start"
DATA_APPEND = "data_append"
EXTRACT_ONLY = "extract_only"
KNOWN_DATA_ACTIONS = frozenset((DATA_START, DATA_APPEND, EXTRACT_ONLY))


def cell_text(row: pd.Series, column: str) -> str:
    """Return a trimmed spreadsheet cell, treating empty/NaN as blank."""
    value = row.get(column)
    if value is None or pd.isna(value):
        return ""
    text = str(value).strip()
    return "" if text.casefold() == "nan" else text


def data_action(row: pd.Series) -> str:
    """Return a normalised resource-layout action from a spreadsheet row."""
    action = cell_text(row, DATA_ACTION_COLUMN).casefold()
    return action.replace("-", "_").replace(" ", "_")


@dataclass(frozen=True)
class ResourceLayout:
    """A contiguous set of files replacing one source data region."""

    rows: tuple[tuple[Hashable, pd.Series], ...]

    @property
    def start_index(self) -> Hashable:
        return self.rows[0][0]

    @property
    def source_label(self) -> str:
        return cell_text(self.rows[0][1], "label")


def resource_layouts(frame: pd.DataFrame) -> tuple[ResourceLayout, ...]:
    """Validate and return all ``data_start``/``data_append`` row groups.

    A layout starts with ``data_start``. Any immediately following
    ``data_append`` rows belong to that layout. Their label may either repeat
    the original group anchor (the legacy convention) or identify an internal
    source label at which that appended resource begins. Spreadsheet order
    defines emitted file order.
    """
    if DATA_ACTION_COLUMN not in frame.columns:
        return ()

    groups: list[ResourceLayout] = []
    active: list[tuple[Hashable, pd.Series]] | None = None
    active_label = ""

    for index, row in frame.iterrows():
        action = data_action(row)
        excel_row = int(index) + 2 if isinstance(index, Integral) else str(index)
        if action and action not in KNOWN_DATA_ACTIONS:
            known = ", ".join(sorted(KNOWN_DATA_ACTIONS))
            raise ToolError(
                f"Unknown data_action '{action}' at spreadsheet row {excel_row}; "
                f"expected one of: {known}"
            )

        if action == DATA_START:
            if active:
                groups.append(ResourceLayout(tuple(active)))
            active_label = cell_text(row, "label")
            if not active_label:
                raise ToolError(
                    f"data_start at spreadsheet row {excel_row} requires an original label"
                )
            active = [(index, row)]
            continue

        if action == DATA_APPEND:
            if active is None:
                raise ToolError(
                    f"data_append at spreadsheet row {excel_row} must immediately "
                    "follow a data_start or data_append row"
                )
            append_label = cell_text(row, "label")
            if not append_label:
                raise ToolError(
                    f"data_append at spreadsheet row {excel_row} requires an "
                    "original or internal source label"
                )
            active.append((index, row))
            continue

        if active:
            groups.append(ResourceLayout(tuple(active)))
            active = None
            active_label = ""

    if active:
        groups.append(ResourceLayout(tuple(active)))
    return tuple(groups)


def layout_row_indices(layouts: tuple[ResourceLayout, ...]) -> frozenset[Hashable]:
    return frozenset(index for layout in layouts for index, _ in layout.rows)

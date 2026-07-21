"""Extract named binary segments into a canonical clean-data workspace."""

from __future__ import annotations

from pathlib import Path

import pandas as pd

from .resource_layout import resource_layouts
from .tool_common import (
    ToolError,
    binary_path,
    get_profile,
    load_segments,
    parse_int,
    require_columns,
)


def extract_segments(
    master: str,
    sheet: str | Path,
    name_filter: str | None = None,
    debug: bool = False,
) -> list[Path]:
    profile = get_profile(master)
    source = binary_path(master)
    if not source.is_file():
        raise ToolError(f"Binary not found: {source}")

    output_dir = profile.clean_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    frame = load_segments(sheet, master)
    require_columns(frame, ("offset", "size", "name"))
    resource_layouts(frame)
    extracted: list[Path] = []

    with source.open("rb") as binary:
        source_size = source.stat().st_size
        for _, row in frame.iterrows():
            if pd.isna(row["name"]):
                continue
            name = str(row["name"]).strip()
            if not name or name.casefold() == "nan":
                continue
            if name_filter and name.casefold() != name_filter.casefold():
                continue

            offset = parse_int(row["offset"])
            size = parse_int(row["size"])
            if offset is None or size is None or offset < 0 or size < 0:
                if debug:
                    print(f"Skipping '{name}': invalid offset/size")
                continue
            if offset + size > source_size:
                raise ToolError(
                    f"Segment '{name}' ({offset:#x}+{size:#x}) exceeds "
                    f"{source.name} ({source_size:#x} bytes)"
                )

            destination = output_dir / Path(name)
            destination.parent.mkdir(parents=True, exist_ok=True)
            binary.seek(offset)
            data = binary.read(size)
            if len(data) != size:
                raise ToolError(f"Short read while extracting '{name}'")
            destination.write_bytes(data)
            extracted.append(destination)
            print(f"Extracted '{name}' -> {destination}")

    if name_filter and not extracted:
        raise ToolError(f"No segment named '{name_filter}' was extracted")
    return extracted

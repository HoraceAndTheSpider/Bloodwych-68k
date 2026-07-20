"""Create a patched binary from same-sized files in a modified-data workspace."""

from __future__ import annotations

import shutil
from pathlib import Path

import pandas as pd

from .tool_common import (
    BINARIES_DIR,
    ToolError,
    binary_path,
    get_profile,
    load_segments,
    parse_int,
    require_columns,
)


def patch_segments(
    master: str,
    sheet: str | Path,
    name_filter: str | None = None,
    debug: bool = False,
) -> Path:
    profile = get_profile(master)
    original = binary_path(master)
    if not original.is_file():
        raise ToolError(f"Binary not found: {original}")

    modified_dir = profile.modified_dir
    patched = BINARIES_DIR / f"{profile.filename}-modified"
    shutil.copy2(original, patched)
    print(f"Patching into {patched}")

    frame = load_segments(sheet, master)
    require_columns(frame, ("offset", "size", "name"))
    patched_count = 0
    with patched.open("r+b") as binary:
        binary_size = patched.stat().st_size
        for _, row in frame.iterrows():
            if pd.isna(row["name"]):
                continue
            name = str(row["name"]).strip()
            if not name or name.casefold() == "nan":
                continue
            if name_filter and name.casefold() != name_filter.casefold():
                continue

            offset, size = parse_int(row["offset"]), parse_int(row["size"])
            if offset is None or size is None or offset < 0 or size < 0:
                if debug:
                    print(f"Skipping '{name}': invalid offset/size")
                continue
            segment = modified_dir / Path(name)
            if not segment.is_file():
                if debug:
                    print(f"Skipping '{name}': no modified file at {segment}")
                continue
            actual_size = segment.stat().st_size
            if actual_size != size:
                raise ToolError(
                    f"Modified '{name}' is {actual_size} bytes; fixed patch requires {size}"
                )
            if offset + size > binary_size:
                raise ToolError(f"Segment '{name}' would exceed {patched.name}")
            binary.seek(offset)
            binary.write(segment.read_bytes())
            patched_count += 1
            print(f"Patched '{name}'")

    if name_filter and patched_count == 0:
        raise ToolError(f"No modified segment named '{name_filter}' was patched")
    print(f"Patched {patched_count} segment(s)")
    return patched

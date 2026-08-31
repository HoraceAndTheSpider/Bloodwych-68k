"""Extract mapped binary resources without overwriting clean originals."""
from __future__ import annotations
from pathlib import Path

from .edit_session import resource_specs
from .tool_common import ToolError, binary_path, get_profile


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
    specs = resource_specs(master, Path(sheet))
    binary = source.read_bytes()
    pending = []
    for name, spec in specs.items():
        if name_filter and name.casefold() != name_filter.casefold():
            continue
        if spec.offset + spec.size > len(binary):
            raise ToolError(f"Segment '{name}' exceeds {source.name}")
        destination = profile.clean_dir / name
        if profile.clean_dir.resolve() not in destination.resolve().parents:
            raise ToolError(f"Extraction path escapes the clean tree: {name}")
        data = binary[spec.offset:spec.offset + spec.size]
        if destination.exists() and destination.read_bytes() != data:
            raise ToolError(f"Clean resource differs from this input: {destination}. Import into a separate project; clean data cannot be overwritten.")
        pending.append((destination, data))
    if name_filter and not pending:
        raise ToolError(f"No segment named '{name_filter}' was extracted")
    # All bounds, paths and existing data are checked before creating outputs.
    for destination, data in pending:
        if not destination.exists():
            destination.parent.mkdir(parents=True, exist_ok=True)
            with destination.open("xb") as handle:
                handle.write(data)
        print(f"Extracted '{destination.relative_to(profile.clean_dir)}' -> {destination}")
    return [destination for destination, _ in pending]

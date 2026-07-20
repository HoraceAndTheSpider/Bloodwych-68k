"""Apply labels from segments.xlsx to a reverse-engineered 68k source file."""

from __future__ import annotations

import re
import shutil
from pathlib import Path

import pandas as pd

from .tool_common import ToolError, asm_path, load_segments, require_columns


def relabel_segments(master: str, sheet: str | Path) -> Path:
    frame = load_segments(sheet, master)
    require_columns(frame, ("label", "relabel"))

    original = asm_path(master, "source")
    if not original.is_file():
        raise ToolError(f"ASM source not found: {original}")
    destination = asm_path(master, "relabel")
    shutil.copy2(original, destination)
    print(f"Created relabel copy '{destination}'")

    lines = destination.read_text(encoding="utf-8", errors="ignore").splitlines()
    for _, row in frame.iterrows():
        if pd.isna(row["label"]) or pd.isna(row["relabel"]):
            continue
        label = str(row["label"]).strip()
        new_label = str(row["relabel"]).strip()
        if not label or label.casefold() == "nan":
            continue
        if not new_label or new_label.casefold() == "nan" or new_label == label:
            continue

        definition_pattern = rf"^\s*{re.escape(label)}\s*:"
        if new_label.casefold().startswith("_delete"):
            matches = [i for i, line in enumerate(lines) if re.match(definition_pattern, line)]
            if len(matches) == 1 and ";" not in lines[matches[0]]:
                print(f"Deleting '{label}' at line {matches[0] + 1}")
                lines.pop(matches[0])
            else:
                print(f"Cannot safely delete '{label}': {len(matches)} definition(s)")
            continue

        if new_label.casefold().startswith("_offset_"):
            parts = new_label.split("_")
            if len(parts) < 4 or not parts[-1].casefold().startswith("0x"):
                print(f"Invalid offset format '{new_label}', skipping")
                continue
            replacement = f"{'_'.join(parts[2:-1]).rstrip('_')}+${parts[-1][2:]}"
            matches = [i for i, line in enumerate(lines) if re.match(definition_pattern, line)]
            if len(matches) == 1 and ";" not in lines[matches[0]]:
                lines.pop(matches[0])
            else:
                print(f"Cannot safely delete definition '{label}'; skipping offset replacement")
                continue
            reference_pattern = rf"\b{re.escape(label)}\b"
            lines = [re.sub(reference_pattern, replacement, line) for line in lines]
            print(f"Replaced '{label}' references with '{replacement}'")
            continue

        if not any(re.match(definition_pattern, line) for line in lines):
            print(f"Label '{label}' not found, skipping")
            continue
        reference_pattern = rf"\b{re.escape(label)}\b"
        lines = [re.sub(reference_pattern, new_label, line) for line in lines]
        print(f"Relabeled '{label}' to '{new_label}'")

    destination.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Saved relabeled ASM to '{destination}'")
    return destination

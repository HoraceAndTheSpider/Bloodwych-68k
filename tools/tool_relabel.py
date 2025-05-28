#!/usr/bin/env python3
import os
import sys
import argparse
import pandas as pd
import re
import shutil
from openpyxl import load_workbook

from .tool_common import parse_int

# 4. Relabel segments in ASM source
def relabel_segments(master, sheet):
    df = pd.read_excel(sheet) if sheet.lower().endswith(('.xls', '.xlsx')) else pd.read_csv(sheet)
    df.columns = [c.strip().lower() for c in df.columns]
    for req in ('label', 'relabel'):
        if req not in df.columns:
            print(f"Error: '{req}' column required")
            sys.exit(1)

    asm_folder = 'asm'
    orig_path = os.path.join(asm_folder, f"{master}.asm")
    if not os.path.isfile(orig_path):
        print(f"Error: ASM '{orig_path}' not found")
        sys.exit(1)
    base, ext = os.path.splitext(master)
    new_path = os.path.join(asm_folder, f"{base}_relabel{ext}.asm")
    shutil.copy2(orig_path, new_path)
    print(f"Created relabel copy '{new_path}'")

    lines = open(new_path, 'r', encoding='utf-8', errors='ignore').read().splitlines()
    for _, row in df.iterrows():
        label = str(row['label']).strip()
        new_label = str(row['relabel']).strip()
        if not label or label.lower() == 'nan':
            continue
        if not new_label or new_label.lower() == 'nan' or new_label == label:
            continue

        # _delete
        if new_label.lower().startswith('_delete'):
            matches = [i for i, ln in enumerate(lines)
                       if re.match(rf'^\s*{re.escape(label)}\s*:', ln)]
            if len(matches) == 1:
                idx = matches[0]
                if ';' not in lines[idx]:
                    print(f"Deleting '{label}' at line {idx+1}")
                    lines.pop(idx)
                else:
                    print(f"Cannot delete '{label}': comment on line {idx+1}")
            else:
                print(f"Cannot delete '{label}': {len(matches)} occurrences")
            continue

        # _offset
        if new_label.lower().startswith('_offset_'):
            parts = new_label.split('_')
            if len(parts) < 4 or not parts[-1].lower().startswith('0x'):
                print(f"Invalid offset format '{new_label}', skipping")
                continue
            name_part = '_'.join(parts[2:-1]).rstrip('_')
            hex_val   = parts[-1][2:]
            offset_lbl= f"{name_part}+${hex_val}"

            # delete definition
            matches = [i for i, ln in enumerate(lines)
                       if re.match(rf'^\s*{re.escape(label)}\s*:', ln)]
            if len(matches) == 1:
                idx = matches[0]
                if ';' not in lines[idx]:
                    print(f"Deleting '{label}' at line {idx+1}")
                    lines.pop(idx)
                else:
                    print(f"Cannot delete '{label}': comment on line {idx+1}")
            else:
                print(f"Cannot delete '{label}': {len(matches)} occurrences")

            # patch references
            pattern = rf'\b{re.escape(label)}\b'
            for i, ln in enumerate(lines):
                if re.search(pattern, ln) and not ln.strip().startswith(label + ':'):
                    new_ln = re.sub(pattern, offset_lbl, ln)
                    lines[i] = new_ln
                    print(f"Replaced '{label}' -> '{offset_lbl}' in line {i+1}")
            continue

        # general relabel
        if not any(re.match(rf'^\s*{re.escape(label)}\s*:', ln) for ln in lines):
            print(f"Label '{label}' not found, skipping")
            continue
        pattern = rf'\b{re.escape(label)}\b'
        for i, ln in enumerate(lines):
            if re.search(pattern, ln):
                lines[i] = re.sub(pattern, new_label, ln)
        print(f"Relabeled '{label}' to '{new_label}'")

    with open(new_path, 'w', encoding='utf-8', errors='ignore') as f:
        f.write("\n".join(lines) + "\n")
    print(f"Saved relabeled ASM to '{new_path}'")

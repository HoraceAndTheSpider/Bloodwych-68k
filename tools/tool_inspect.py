#!/usr/bin/env python3
import os
import sys
import argparse
import pandas as pd
import re
from openpyxl import load_workbook

from .tool_common import parse_int

# 3. Inspect segments (read-only)
def inspect_source(master, sheet, name_filter=None, debug=False):
    base = os.path.splitext(master)[0]
    clean_dir = os.path.join('data', f"{base}-clean")

    wb = load_workbook(sheet, data_only=True)
    sheet_name = next((s for s in wb.sheetnames if s.lower() == master.lower()), None)
    if not sheet_name:
        print(f"No sheet {master}")
        sys.exit(1)

    asm_folder = 'asm'
    relabel_f = os.path.join(asm_folder, f"{master}_relabel.asm")
    if os.path.isfile(relabel_f):
        asm_path, label_col = relabel_f, 'relabel'
        print(f"Using relabel ASM {asm_path}")
    else:
        asm_path, label_col = os.path.join(asm_folder, f"{master}.asm"), 'label'
    if not os.path.isfile(asm_path):
        print(f"No ASM {asm_path}")
        sys.exit(1)

    # Read original ASM lines and prepare a working copy
    lines = open(asm_path, 'r', errors='ignore').read().splitlines()
    working_lines = list(lines)
    # Collect modifications as (start_idx, end_idx, segment_path)
    mods = []

    df = pd.read_excel(sheet, sheet_name=sheet_name)
    df.columns = [c.strip().lower() for c in df.columns]
    for req in ('name', 'size', label_col):
        if req not in df.columns:
            print(f"Missing {req}")
            sys.exit(1)

    for idx, r in df.iterrows():
        row = idx + 2
        nm = str(r['name']).strip()
        lb = str(r[label_col]).strip()
        if not nm or nm.lower() == 'nan' or not lb or lb.lower() == 'nan':
            continue
        if name_filter and nm.lower() != name_filter.lower():
            continue

        sz = parse_int(r['size'])
        print(f"Check {nm}@{lb} row{row}")
        seg_path = os.path.join(clean_dir, nm)
        if sz is None or not os.path.isfile(seg_path) or os.path.getsize(seg_path) != sz:
            print("  missing")
            continue

        # Locate label block: try relabel first, then fall back to original label
        relb = lb  # lb was set from r[label_col]
        start = None

        # 1) If relabel column is non-empty, try that first
        if relb:
            start = next((i for i, line in enumerate(lines)
                          if line.lower().startswith(relb.lower() + ':')), None)

        # 2) If we’re in ‘relabel’ mode and didn’t match, try the original label
        if start is None and label_col == 'relabel':
            orig_lbl = str(r.get('label', '')).strip()
            if orig_lbl:
                start = next((i for i, line in enumerate(lines)
                              if line.lower().startswith(orig_lbl.lower() + ':')), None)
                if start is not None:
                    print(f"  falling back to original label '{orig_lbl}'")

        # 3) If still not found, skip this row
        if start is None:
            print(f"  no label match for '{nm}'; skipping")
            continue

        # 4) Find end of the data block (next bare “something:” or end-of-file)
        end = next((i for i in range(start + 1, len(lines))
                    if lines[i].strip().endswith(':')), len(lines))

        # Existing data checks (head/tail validation)
        data = open(seg_path, 'rb').read()
        chk = min(16, sz)
        head = data[:chk]
        tail = data[-chk:]
        dh = bytearray(); dt = bytearray()
        # Build head from directives
        for ln in lines[start+1:end]:
            if not ln.strip() or ln.strip().startswith(';') or ln.strip().endswith(':'):
                if ln.strip().endswith(':'): break
                continue
            m = re.match(r"\s*dc\.(b|w|l)\s*(.+)", ln, re.I)
            if not m: break
            k, its = m.group(1).lower(), m.group(2)
            for part in its.split(','):
                raw = part.split(';')[0].strip()
                if (raw.startswith("'") and raw.endswith("'")) or (raw.startswith('"') and raw.endswith('"')):
                    for c in raw[1:-1]: dh.append(ord(c))
                    continue
                if raw.startswith('$'): raw = '0x' + raw[1:]
                try: v = int(raw, 16)
                except ValueError: continue
                if k == 'b': dh.append(v & 0xFF)
                elif k == 'w': dh.extend([(v >> 8) & 0xFF, v & 0xFF])
                else: dh.extend([(v >> 24) & 0xFF, (v >> 16) & 0xFF, (v >> 8) & 0xFF, v & 0xFF])
            if len(dh) >= chk: break
        # Build tail from reversed directives
        for ln in reversed(lines[start+1:end]):
            if not ln.strip() or ln.strip().startswith(';') or ln.strip().endswith(':'):
                if ln.strip().endswith(':'): break
                continue
            m = re.match(r"\s*dc\.(b|w|l)\s*(.+)", ln, re.I)
            if not m: break
            k, its = m.group(1).lower(), m.group(2)
            parts = [p.split(';')[0].strip() for p in its.split(',')]
            for raw in reversed(parts):
                if (raw.startswith("'") and raw.endswith("'")) or (raw.startswith('"') and raw.endswith('"')):
                    blk = [ord(c) for c in raw[1:-1]]
                    dt[0:0] = blk
                    continue
                if raw.startswith('$'): raw = '0x' + raw[1:]
                try: v = int(raw, 16)
                except ValueError: continue
                if k == 'b': blk = [v & 0xFF]
                elif k == 'w': blk = [(v >> 8) & 0xFF, v & 0xFF]
                else: blk = [(v >> 24) & 0xFF, (v >> 16) & 0xFF, (v >> 8) & 0xFF, v & 0xFF]
                dt[0:0] = blk
            if len(dt) >= chk: break

        # Validation result
        if head == bytes(dh[:chk]) and tail == bytes(dt[-chk:]):
            print("  VALID")
        else:
            print("  FAIL")
            if debug:
                print(f"    head:{head.hex()}")
                print(f"    dh:{bytes(dh[:chk]).hex()}")
                print(f"    tail:{tail.hex()}")
                print(f"    dt:{bytes(dt[-chk:]).hex()}")

        # Schedule replacement of the declared data block in working_lines
        mods.append((start, end, seg_path))

    # Apply all modifications in reverse order to avoid index shifts
    for start, end, seg_path in sorted(mods, key=lambda x: x[0], reverse=True):
        # Remove original dc.* lines
        del working_lines[start+1:end]
        # Insert INCBIN directive
##      working_lines.insert(start+1, f"\tINCBIN \"{seg_path}\"")
        working_lines.insert(start+1, f"\tINCBIN \"/{seg_path}\"\n")

    # Write the modified ASM to a new file with _data suffix
    base_name, ext = os.path.splitext(os.path.basename(asm_path))
    new_name = os.path.join(os.path.dirname(asm_path), f"{base_name}_data{ext}")
    with open(new_name, 'w') as fout:
        fout.write("\n".join(working_lines))
    print(f"Modified ASM written to {new_name}")

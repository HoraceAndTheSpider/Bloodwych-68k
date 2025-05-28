#!/usr/bin/env python3
import os
import sys
import shutil
import argparse
import pandas as pd

def parse_int(value):
    """
    Parse an integer from decimal or hex string (e.g., '0x1A').
    Returns None if value is NaN or cannot be parsed.
    """
    try:
        if pd.isna(value):
            return None
        if isinstance(value, str):
            value = value.strip()
            if not value:
                return None
            if value.lower().startswith('0x'):
                return int(value, 16)
        return int(value)
    except Exception:
        return None


def main():
    parser = argparse.ArgumentParser(
        description="Patch segments back into a copy of the master binary based on a spreadsheet of offsets, sizes, and names."
    )
    parser.add_argument(
        "--master", "-m",
        default="BLOODWYCH439",
        help="Name of the master binary file (without path), defaults to BLOODWYCH439."
    )
    parser.add_argument(
        "--sheet", "-s",
        default="segments.xlsx",
        help="Path to the spreadsheet (CSV or Excel) containing columns: offset, size, name (defaults to segments.xlsx)."
    )
    args = parser.parse_args()

    binaries_dir = 'binaries'
    if not os.path.isdir(binaries_dir):
        print(f"Error: '{binaries_dir}' folder not found.")
        sys.exit(1)

    master_file = args.master
    orig_master = os.path.join(binaries_dir, master_file)
    if not os.path.isfile(orig_master):
        print(f"Error: master binary '{master_file}' not found in '{binaries_dir}'.")
        sys.exit(1)

    base_name, ext = os.path.splitext(os.path.basename(orig_master))
    modified_dir = f"modified-{base_name}"
    if not os.path.isdir(modified_dir):
        print(f"Error: modified directory '{modified_dir}' not found.")
        sys.exit(1)

    # Prepare patched master path inside binaries directory
    patched_master = os.path.join(binaries_dir, f"{base_name}-modified{ext}")
    try:
        shutil.copy2(orig_master, patched_master)
        print(f"Copied '{orig_master}' to '{patched_master}' for patching.")
    except Exception as e:
        print(f"Error copying master file: {e}")
        sys.exit(1)

    sheet_path = args.sheet
    ext_sheet = os.path.splitext(sheet_path)[1].lower()
    if ext_sheet in [".xls", ".xlsx"]:
        xls = pd.ExcelFile(sheet_path)
        cleaned = [s.strip().lower() for s in xls.sheet_names]
        if base_name.lower() in cleaned:
            idx = cleaned.index(base_name.lower())
            sheet_to_use = xls.sheet_names[idx]
        else:
            print(f"Error: No worksheet named '{base_name}' found in {sheet_path}.")
            print(f"Available sheets: {', '.join(xls.sheet_names)}")
            sys.exit(1)
        df = xls.parse(sheet_to_use)
    elif ext_sheet in [".csv", ".txt"]:
        df = pd.read_csv(sheet_path)
    else:
        parser.error(f"Unsupported spreadsheet format: {ext_sheet}")

    # Normalize column names
    df.columns = [col.strip().lower() for col in df.columns]
    for col in ("offset", "size", "name"):
        if col not in df.columns:
            parser.error(f"Missing required column in spreadsheet: '{col}'")

    # Patch segments in the copied binary
    with open(patched_master, "r+b") as master_f:
        for idx, row in df.iterrows():
            offset = parse_int(row.get("offset"))
            size = parse_int(row.get("size"))
            name = row.get("name")

            name_str = name.strip() if isinstance(name, str) and name.strip() else None
            skip_label = name_str or f"row {idx}"

            if offset is None or size is None or not name_str:
                print(f"Skipping '{skip_label}': invalid offset/size/name")
                continue

            mod_path = os.path.join(modified_dir, name_str)
            if not os.path.isfile(mod_path):
                print(f"Skipping '{name_str}': file not found in '{modified_dir}'")
                continue

            actual_size = os.path.getsize(mod_path)
            if actual_size != size:
                print(f"Skipping '{name_str}': size mismatch (expected {size}, got {actual_size})")
                continue

            with open(mod_path, "rb") as mod_f:
                data = mod_f.read()

            master_f.seek(offset)
            master_f.write(data)
            print(f"Patched '{name_str}' at offset {offset} (size {size} bytes)")

    print(f"Finished patching segments into '{patched_master}'")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
import os
import sys
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
        description="Extract segments from a master binary file based on a spreadsheet of offsets, sizes, and names."
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
    master_path = os.path.join(binaries_dir, master_file)
    if not os.path.isfile(master_path):
        print(f"Error: master binary '{master_file}' not found in '{binaries_dir}'.")
        sys.exit(1)

    base_name, _ = os.path.splitext(os.path.basename(master_file))
    output_dir = f"extracted-{base_name}"
    os.makedirs(output_dir, exist_ok=True)

    sheet_path = args.sheet
    ext = os.path.splitext(sheet_path)[1].lower()
    if ext in [".xls", ".xlsx"]:
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
    elif ext in [".csv", ".txt"]:
        df = pd.read_csv(sheet_path)
    else:
        parser.error(f"Unsupported spreadsheet format: {ext}")

    df.columns = [col.strip().lower() for col in df.columns]
    for col in ('offset', 'size', 'name'):
        if col not in df.columns:
            parser.error(f"Missing required column '{col}' in spreadsheet")

    with open(master_path, 'rb') as mf:
        for idx, row in df.iterrows():
            offset = parse_int(row.get('offset'))
            size = parse_int(row.get('size'))
            name = row.get('name')
            name_str = name.strip() if isinstance(name, str) and name.strip() else None
            label = name_str or f"row {idx}"
            if offset is None or size is None or not name_str:
                print(f"Skipping '{label}': missing or invalid offset/size/name")
                continue
            mf.seek(offset)
            data = mf.read(size)
            out_path = os.path.join(output_dir, name_str)
            dir_path = os.path.dirname(out_path)
            if dir_path:
                os.makedirs(dir_path, exist_ok=True)
            with open(out_path, 'wb') as out_f:
                out_f.write(data)
            print(f"Extracted '{name_str}' (offset={offset}, size={size})")

    print(f"Finished extracting into '{output_dir}'")

if __name__ == '__main__':
    main()

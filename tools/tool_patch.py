#!/usr/bin/env python3
import os
import sys
import argparse
import pandas as pd
import re
import shutil
from openpyxl import load_workbook

from .tool_common import parse_int

# 2. Patch segments
def patch_segments(master,sheet,name_filter=None,debug=False):
    data_dir='data'
    os.makedirs(data_dir,exist_ok=True)
    binaries='binaries'
    orig=os.path.join(binaries,master)
    if not os.path.isfile(orig):
        print(f"Error: master '{master}' not in {binaries}/"); sys.exit(1)
    base,ext=os.path.splitext(master)
    mod_dir=os.path.join(data_dir,f"{base}-modified")
    patched=os.path.join(binaries,f"{base}-modified{ext}")
    shutil.copy2(orig,patched)
    print(f"Patching into {patched}")
    df=pd.read_excel(sheet) if sheet.lower().endswith(('.xls','.xlsx')) else pd.read_csv(sheet)
    df.columns=[c.strip().lower() for c in df.columns]
    for col in ('offset','size','name'):
        if col not in df.columns:
            print(f"Missing column '{col}'"); sys.exit(1)
    with open(patched,'r+b') as mf:
        for _,r in df.iterrows():
            nm=str(r['name']).strip()
            if not nm or pd.isna(r['name']): continue
            if name_filter and nm.lower()!=name_filter.lower(): continue
            off=parse_int(r['offset']); sz=parse_int(r['size'])
            if off is None or sz is None:
                if debug: print(f"Skip {nm}"); continue
            seg=os.path.join(mod_dir,nm)
            if not os.path.isfile(seg) or os.path.getsize(seg)!=sz:
                if debug: print(f"Skip {nm}"); continue
            try:
                with open(seg, 'rb') as f:
                    data = f.read()
            except FileNotFoundError:
                if debug:
                    print(f"Skipping '{nm}': file not found at {seg}")
                continue
            mf.seek(off); mf.write(data)
            print(f"Patched {nm}")

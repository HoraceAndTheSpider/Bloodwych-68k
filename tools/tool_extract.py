#!/usr/bin/env python3
import os
import sys
import argparse
import pandas as pd
import re
import shutil
from openpyxl import load_workbook

from .tool_common import parse_int

# 1. Extract segments
def extract_segments(master,sheet,name_filter=None,debug=False):
    data_dir='data'
    os.makedirs(data_dir,exist_ok=True)
    binaries='binaries'
    master_path=os.path.join(binaries,master)
    if not os.path.isfile(master_path):
        print(f"Error: master '{master}' not in {binaries}/")
        sys.exit(1)
    base,_=os.path.splitext(master)
    out_dir=os.path.join(data_dir,f"{base}-clean")
    os.makedirs(out_dir,exist_ok=True)
    df=pd.read_excel(sheet) if sheet.lower().endswith(('.xls','.xlsx')) else pd.read_csv(sheet)
    df.columns=[c.strip().lower() for c in df.columns]
    for col in ('offset','size','name'):
        if col not in df.columns:
            print(f"Missing column '{col}'"); sys.exit(1)
    with open(master_path,'rb') as mf:
        for _, r in df.iterrows():
            nm = str(r['name']).strip()
            if not nm or pd.isna(r['name']):
                continue
            if name_filter and nm.lower() != name_filter.lower():
                continue
            # parse offset and size
            off = parse_int(r['offset'])
            sz  = parse_int(r['size'])
            # skip invalid offsets/sizes
            if off is None or sz is None:
                if debug:
                    print(f"Skipping '{nm}': invalid offset/size (off={r['offset']} sz={r['size']})")
                continue
            # perform extraction
            mf.seek(off)
            data = mf.read(sz)
            out = os.path.join(out_dir, nm)
            os.makedirs(os.path.dirname(out), exist_ok=True)
            with open(out, 'wb') as f:
                f.write(data)
            print(f"Extracted '{nm}'")
            
            nm=str(r['name']).strip()
            if not nm or pd.isna(r['name']): continue
            if name_filter and nm.lower()!=name_filter.lower(): continue
            off=parse_int(r['offset']); sz=parse_int(r['size'])
            if off is None or sz is None:
                if debug: print(f"Skip {nm}"); continue
            mf.seek(off); data=mf.read(sz)
            out=os.path.join(out_dir,nm)
            os.makedirs(os.path.dirname(out),exist_ok=True)
            open(out,'wb').write(data)

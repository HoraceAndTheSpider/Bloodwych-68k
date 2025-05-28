# tools/common.py
import pandas as pd

def parse_int(v):
    try:
        if pd.isna(v):
            return None
        if isinstance(v, str):
            s = v.strip()
            if not s:
                return None
            if s.lower().startswith('0x') or s.startswith('$'):
                return int(s.replace('$','0x'), 16)
            return int(s)
        return int(v)
    except:
        return None

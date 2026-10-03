# usage: python m6_writers.py FFA9F4  -> every store to that abs16 RAM byte with the preceding instruction
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import sys; sys.path.insert(0, (_REPO_S + "/ida/out/inferred-tables"))
from m6_lib import *
X = sys.argv[1].lower()
hs = sorted(heads); idx = {e: i for i, e in enumerate(hs)}
for ea in hs:
    sz, k, f, d, o = heads[ea]
    dl = d.lower()
    if k == 'code' and ('@0xffff' + X[-4:]) in dl and dl.find(', @0x') >= 0 and dl.index(', @0x') < dl.index('@0xffff' + X[-4:]) + 1:
        p = hs[idx[ea] - 1]
        print('%s %06X %-22s %s | prev %s' % ('P' if proven_head(ea) else '-', ea, hx(ea, sz), d, heads[p][3]))

# usage: python m6_show.py START END  -> heads with P/N flag and bytes;  python m6_show.py refs LO HI -> code refs into [LO,HI)
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import sys; sys.path.insert(0, (_REPO_S + "/ida/out/inferred-tables"))
from m6_lib import *
if sys.argv[1] == "refs":
    lo, hi = int(sys.argv[2], 16), int(sys.argv[3], 16)
    for ea, da, how, pv in sorted(refs, key=lambda r: (r[1], r[0])):
        if lo <= da < hi: print("%s %06X <- %06X %-4s %s   [%s]" % ("P" if pv else "-", da, ea, how, heads[ea][3], hx(ea, heads[ea][0])))
else:
    a, b = int(sys.argv[1], 16), int(sys.argv[2], 16)
    for ea in sorted(e for e in heads if a <= e < b):
        sz, k, f, d, o = heads[ea]
        fl = "P" if all(PM[i] for i in range(ea, ea+sz)) else ("N" if all(NM[i] for i in range(ea, ea+sz)) else ("p" if any(PM[i] for i in range(ea, ea+sz)) else ("n" if any(NM[i] for i in range(ea,ea+sz)) else "R")))
        print("%s %06X %-5s %-30s %s" % (fl, ea, k, hx(ea, min(sz, 12)), d))

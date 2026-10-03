from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: who references an address range (BE32 anywhere, abs24 jsr/jmp, relative branches from IDA code heads). Offline.
import sys, re
sys.path.insert(0, str(_REPO) + r"/ida/out/main-unnamed/offline")
from l5_lib import *
BR = re.compile(r"\(0x([0-9a-f]+)\)")
for arg in sys.argv[1:]:
    lo, hi = [int(x, 16) for x in arg.split("-")] if "-" in arg else (int(arg, 16), int(arg, 16) + 1)
    out = []
    for s in range(0, HI - 3):
        v = (img[s] << 24) | (img[s+1] << 16) | (img[s+2] << 8) | img[s+3]
        if lo <= v < hi and not (lo <= s < hi):
            h = headof[s]; hk = heads[h][1] if h is not None else "-"
            out.append("be32 %06X->%06X site %s head %s%s" % (s, v, cls(s), hk, (":%06X %s" % (h, bu[h][1])) if hk == "code" else ""))
    for h, (sz, k, t) in heads.items():
        if k != "code": continue
        mn, op = bu[h][1], bu[h][2]
        m = BR.search(op) or re.search(r"@0x([0-9a-f]+):24", op)
        if m and (mn.startswith("b") or mn in ("jsr", "jmp", "bsr")):
            tv = int(m.group(1), 16)
            if lo <= tv < hi and not (lo <= h < hi): out.append("insn %06X %s %s (%s)" % (h, mn, op, cls(h)))
    print("== %06X-%06X: %d" % (lo, hi, len(out)))
    for o in out[:30]: print("   " + o)

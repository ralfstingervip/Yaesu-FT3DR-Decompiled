from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: hex + mask + IDA heads around an address. Offline, read-only.
import sys
sys.path.insert(0, str(_REPO) + r"/ida/out/main-unnamed/offline")
from l5_lib import *
for arg in sys.argv[1:]:
    c, w = (arg.split(":") + ["48"])[:2]
    c = int(c, 16); w = int(w, 16) if w.startswith("0x") else int(w)
    lo = max(0, (c - w) & ~0xF); hi = min(HI, c + w)
    print("---- %06X" % c)
    for i in range(lo, hi, 16):
        print("%06X %s  %s" % (i, img[i:i+16].hex(" "), "".join("P" if pm[j] else ("N" if nm[j] else ("R" if runid[j] is not None else ".")) for j in range(i, min(i+16, HI)))))
    h = lo
    hs = sorted(x for x in heads if lo <= x < hi)
    print("  heads: " + " ".join("%X/%d/%s%s" % (x, heads[x][0], heads[x][1][:4], (":" + bu[x][1]) if heads[x][1] == "code" else "") for x in hs))

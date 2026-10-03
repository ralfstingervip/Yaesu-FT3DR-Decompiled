from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: detailed per-run view (hex + oracle linear decode + evidence). Offline, read-only.
import sys, json
sys.path.insert(0, str(_REPO) + r"/ida/out/main-unnamed/offline")
from l5_lib import *
ev = json.load(open(O + r"\work\evidence.json"))
lo = int(sys.argv[1]); hi = int(sys.argv[2]) if len(sys.argv) > 2 else 10**9
out = []
for a, b in runs:
    if not (lo <= b - a < hi): continue
    ph = headof[a - 1]; nh = headof[b] if b < HI else None
    def hd(h):
        if h is None: return "-"
        sz, k, t = heads[h]
        return "%06X/%d/%s/%s%s" % (h, sz, k, cls(h), (":" + bu[h][1]) if k == "code" else "")
    out.append("=== %06X-%06X len %d  prev %s  next %s" % (a, b, b - a, hd(ph), hd(nh)))
    for i in range(a, b, 32):
        seg = img[i:min(b, i + 32)]
        out.append("  %06X %s  %s" % (i, seg.hex(" "), "".join(chr(c) if 32 <= c < 127 else "." for c in seg)))
    L = lin(a if a % 2 == 0 else a, b)
    out.append("  lin: " + " | ".join("%X %s %s" % (x[0], x[2], x[3]) for x in L)[:900])
    E = ev["%06X" % a]
    if E: out.append("  ev: " + " ".join("%s %06X<%06X %s" % (e[0], e[1], e[2], e[3]) for e in E)[:600])
open(O + r"\work\detail_%d_%d.txt" % (lo, hi if hi < 10**9 else 0), "w", encoding="utf-8").write("\n".join(out) + "\n")

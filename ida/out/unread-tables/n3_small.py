# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N3: per-piece reference search for the 43 B of non-curve pieces. Offline, read-only.
# For each piece [s,e): raw BE32 values in [s-0x80, e) at any offset; for s < 0x8000 also raw BE16 values in that window.
import sys, bisect; sys.path.insert(0, str(_REPO / "ida/out/unread-tables"))
from n3_lib import *
H = {}
for l in list(open(R + "/ida/out/unread-tables/work/n3_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t"); H[int(p[0], 16)] = (int(p[1]), p[2], p[4])
ks = sorted(H)
def head(i):
    k = ks[bisect.bisect_right(ks, i) - 1]; return k, H[k]
for s, e in PIECES:
    if 0x03624B <= s < 0x0377C2: continue
    print("=== %06X-%06X (%d)  %s" % (s, e - 1, e - s, hx(s, e - s)))
    for i in range(0, 0x7B754 - 3):
        v = be32(i)
        if s - 0x80 <= v < e:
            k, (sz, kind, dis) = head(i)
            cov = k <= i and i + 4 <= k + sz
            print("  be32 @%06X=%06X  %s head %06X %s %s  [%s]" % (i, v, "IN" if cov else "split", k, kind, dis, hx(k, min(sz, 10))))
    if s < 0x8000:
        for i in range(0, 0x7B754 - 1):
            v = be16(i)
            if s - 0x20 <= v < e:
                k, (sz, kind, dis) = head(i)
                if kind == "code" and k < i and i + 2 <= k + sz:
                    print("  be16 @%06X=%04X  head %06X %s  [%s]" % (i, v, k, dis, hx(k, sz)))

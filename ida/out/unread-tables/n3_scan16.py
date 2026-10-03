# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N3: raw scan for 16-bit immediates 0x6219-0x77C1 in word-immediate forms (79 0r / 79 1r..79 6r, 7a 8r..7a fr),
# any offset in content, classified by the IDA head (FINAL6 seed copy N3_TABLES) that covers them. Offline, read-only.
import sys, bisect; sys.path.insert(0, str(_REPO / "ida/out/unread-tables"))
from n3_lib import *
H = {}
for l in list(open(R + "/ida/out/unread-tables/work/n3_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t"); H[int(p[0], 16)] = (int(p[1]), p[2], p[4])
ks = sorted(H)
n = 0
for i in range(2, 0x7B754 - 1):
    v = be16(i)
    if not (0x6219 <= v < 0x77C2): continue
    a, b = img[i-2], img[i-1]
    if (a == 0x79 and (b >> 4) <= 6) or (a == 0x7A and (b >> 4) >= 8):
        k = ks[bisect.bisect_right(ks, i) - 1]; sz, kind, dis = H[k]
        cov = kind == "code" and k == i - 2
        n += 1; print("%06X\t%s\thead %06X %s %s\t%s" % (i - 2, "ALIGNED" if cov else "split/data", k, kind, dis, hx(i - 2, 4)))
print("hits:", n)

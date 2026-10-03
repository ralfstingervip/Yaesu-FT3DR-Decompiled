# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N3: whole-image raw scan for any encoding of an address in the unread ranges. Offline, read-only.
import sys; sys.path.insert(0, str(_REPO / "ida/out/unread-tables"))
from n3_lib import *
LO, HI = 0x036219, 0x0377C2
out = []
# 1) every byte offset where a BE32 value lies in [LO-0x100, HI) (any alignment)
for i in range(0, len(img) - 3):
    v = be32(i)
    if LO - 0x100 <= v < HI:
        out.append(("be32", i, v, hx(max(0, i - 4), 12)))
# 2) BE24 (abs24 jsr/jmp operands: 5a/5e xx xx xx) and 24-bit after 00
for i in range(0, len(img) - 2):
    v = (img[i] << 16) | (img[i+1] << 8) | img[i+2]
    if LO <= v < HI and (i == 0 or img[i-1] in (0x5a, 0x5e)):
        out.append(("abs24", i, v, hx(max(0, i - 2), 8)))
for r in out: print("%s\t%06X\t%06X\t%s" % (r[0], r[1], r[2], r[3]))
print("total", len(out))

# classify each hit by the IDA head (FINAL6 seed copy N3_TABLES, n3_dump.py) that covers it
import bisect
H = {}
for l in list(open(R + "/ida/out/unread-tables/work/n3_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t"); H[int(p[0], 16)] = (int(p[1]), p[2], p[4])
ks = sorted(H)
print("---- classified")
for r in out:
    i = r[1]; k = ks[bisect.bisect_right(ks, i) - 1]; sz, kind, dis = H[k]
    cov = k <= i and i + (4 if r[0] == "be32" else 3) <= k + sz
    pv = all(PM7[k:k+sz]) if kind == "code" else False
    print("%s\t%06X\t%06X\thead %06X+%d %s %s\tproven=%s\t%s" % (r[0], i, r[2], k, sz, kind, "covers" if cov else "SPLIT", pv, dis))

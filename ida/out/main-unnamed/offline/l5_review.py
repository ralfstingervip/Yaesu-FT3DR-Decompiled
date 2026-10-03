from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: compact one-line-per-run review listing. Offline, read-only.
import sys, json
sys.path.insert(0, str(_REPO) + r"/ida/out/main-unnamed/offline")
from l5_lib import *
ev = json.load(open(O + r"\work\evidence.json"))
out = []
for a, b in runs:
    n = b - a; seg = img[a:b]
    # predecessor head (IDA) and whether it is proven
    ph = headof[a - 1] if a else None
    pmn = bu[ph][1] if ph is not None and heads[ph][1] == "code" else heads[ph][1] if ph is not None else "-"
    pre = "%s%s" % (cls(a - 1), pmn)
    nxt = cls(b) if b < HI else "-"
    L = lin(a, b)
    over = L[-1][0] + L[-1][1] - b
    bad = sum(1 for x in L if x[2] == ".word")
    # oracle instruction from proven flow covering a? (prefix gap): oracle head at h<a, proven, spanning a
    span = ""
    for h in range(max(0, a - 10), a):
        if pm[h] and h % 2 == 0 and h + bu[h][0] > a and (h == 0 or True):
            span = "%06X+%d:%s" % (h, bu[h][0], bu[h][1])
    E = ev["%06X" % a]
    etags = collections.Counter(e[3] for e in E)
    prt = sum(1 for x in seg if 0x20 <= x < 0x7F)
    kinds = collections.Counter(i[2] for i in items[a] if a <= i[0] < b)
    out.append("%06X %4d pre=%-8s nx=%s lin=%d/%d/%+d/%s span=%s prt=%d 00=%d FF=%d ida=%s ev=%s | %s" % (
        a, n, pre[:8], nxt, len(L), bad, over, L[-1][2], span, prt, seg.count(0), seg.count(255),
        ",".join("%s%d" % kv for kv in kinds.items()), ",".join("%s*%d" % kv for kv in etags.items()), seg[:28].hex()))
open(O + r"\work\review.txt", "w", encoding="utf-8").write("\n".join(out) + "\n")

# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N3: operand census over every IDA head of the FINAL6 seed copy N3_TABLES and FINAL6 head list.
# Lists (1) any operand value/addr in [0x034000, 0x0377C2) and (2) any 16-bit immediate in [0x6219, 0x77C2).
import sys; sys.path.insert(0, str(_REPO / "ida/out/unread-tables"))
from n3_lib import *
rows = []
for l in list(open(R + "/ida/out/unread-tables/work/n3_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    ea, sz, kind, dis = int(p[0], 16), int(p[1]), p[2], p[4]
    if kind != "code": continue
    for s in p[5:8]:
        if not s: continue
        t, v, a, r, d = s.split(":"); t = int(t); v = int(v, 16); a = int(a, 16)
        x = a if t in (2, 3, 4, 6, 7) else v
        pv = all(PM7[ea:ea+sz])
        inside = 0x036000 <= ea < 0x0377C2
        if 0x034000 <= x < 0x0377C2 and t != 7 and not inside:
            rows.append(("addr", ea, x, pv, dis))
        if t == 5 and 0x6219 <= v < 0x77C2 and not inside:
            rows.append(("imm16", ea, v, pv, dis))
for r in rows:
    if r[0] == "imm16" or r[2] >= 0x035F00:
        print("%s\t%06X\t%06X\tproven=%s\t%s" % r)
print("n addr in 0x034000-0x0377C1:", sum(1 for r in rows if r[0] == "addr"))

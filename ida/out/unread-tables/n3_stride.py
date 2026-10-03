# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N3: every mulxu/mulu head in the FINAL6 seed copy N3_TABLES whose multiplier is loaded with 13, 50, 86 or 98 within 4 heads,
# with the next 4 heads (to see the base). Offline, read-only.
import sys, re; sys.path.insert(0, str(_REPO / "ida/out/unread-tables"))
from n3_lib import *
L = [l.rstrip("\n").split("\t") for l in list(open(R + "/ida/out/unread-tables/work/n3_heads.tsv", encoding="utf-8"))[1:]]
L = [p for p in L if p[2] == "code"]
want = {0x0D, 0x32, 0x56, 0x62, 0x0C}
for j, p in enumerate(L):
    if not re.match(r"mul", p[4]): continue
    ctx = L[max(0, j-4):j]
    hit = [c for c in ctx if re.search(r"#(0x)?([0-9A-F]+)\b", c[4]) and int(re.search(r"#((?:0x)?[0-9A-F]+)\b", c[4]).group(1), 0) in want]
    if hit:
        print("---", p[0], p[4], "proven" if all(PM7[int(p[0],16):int(p[0],16)+int(p[1])]) else "")
        for c in L[max(0, j-4):j+5]: print("   ", c[0], c[4])

# Task 2: reader evidence for L5's proven-data candidates. For each candidate, list every real code head whose
# operand names an address in [a-64, b) as data (mov.l #imm, @(d:32,ERn), @aa:24/32, and 16-bit forms below 0x8000).
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, re, json
sys.path.insert(0, (_REPO_S + "/ida/out/dead-code-tier/offline"))
from m5_lib import *
CH = {ea for ea, v in heads.items() if v[1] == "code"}
runs, i = [], 0
PH = set()
i = 0
while i < HI:
    if PM[i]:
        j = i
        while j < HI and PM[j]: j += 1
        k = i
        while k < j: PH.add(k); k += bu[k][0]
        i = j
    else: i += 1
REAL = CH | PH
refs = {}
for s in REAL:
    ln, mn, op = bu[s]
    if mn in ("jsr", "jmp") or (mn.startswith("b") and "(" in op): continue
    for m in RX_HEX.finditer(op):
        v = int(m.group(1), 16); tail = op[m.end():m.end() + 3]
        if tail.startswith(":8"): continue
        if tail.startswith(":16") and v >= 0x8000: continue
        if v < HI: refs.setdefault(v, []).append(s)
rows = [l.rstrip("\n").split("\t") for l in open(R + r"\ida\out\main-unnamed\proven-data-candidates.tsv", encoding="utf-8")][1:]
out = []
for r in rows:
    a, b = int(r[0], 16), int(r[1], 16)
    hits = []
    for v in range(a - 64, b):
        for s in refs.get(v, []):
            hits.append(("%06X" % s, cls(s), "%06X" % v, bu[s][1] + " " + bu[s][2], img[s:s + bu[s][0]].hex(" ")))
    prev = None
    for s in range(a - 8, a):
        if s in REAL and s + bu[s][0] == a: prev = "%06X %s %s %s" % (s, cls(s), bu[s][1], bu[s][2])
    out.append({"start": r[0], "end": r[1], "len": int(r[2]), "l5conf": r[3], "bytes": img[a:b].hex(" "), "readers": hits, "pred": prev})
json.dump(out, open(O + r"\work\readers.json", "w", encoding="utf-8"), indent=1)
for o in out:
    print("==", o["start"], o["end"], o["len"], o["l5conf"], o["bytes"][:60], "| pred:", o["pred"])
    for h in o["readers"]: print("   ", h)

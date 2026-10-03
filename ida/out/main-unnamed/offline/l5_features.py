import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: per-run features for the MAIN unnamed residue. Offline, read-only.
import os, struct, collections, json
R = str(_REPO)
O = R + r"\ida\out\main-unnamed"
HI = 0x7B754
sys.exit('The firmware image is not in this repository.')
nm = bytearray(open(R + r"\ida\out\main-final4\final4_named_mask.bin", "rb").read()[:HI])
pm = open(R + r"\ida\out\main-final4\final4_proven_mask.bin", "rb").read()[:HI]
D95 = [(0x07810C,0x07815B),(0x0781A4,0x0781A9),(0x0781C4,0x078221),(0x07823C,0x07825F),(0x078268,0x078279),(0x07827C,0x078333),(0x07833C,0x07837B),(0x078384,0x0783D9),(0x0783EE,0x07842D),(0x078440,0x078441),(0x078448,0x078459),(0x078462,0x078507),(0x078514,0x078545)]
for a, b in D95:
    for i in range(a, b + 1): nm[i] = 1
res = bytearray(1 - x for x in nm)
runs = [(int(l.split()[0], 16), int(l.split()[1], 16)) for l in open(O + r"\work\runs_raw.tsv")]
assert sum(b - a for a, b in runs) == sum(res) == 7365
runid = [None] * HI
for a, b in runs:
    for i in range(a, b): runid[i] = a
# oracle
bu = {}
for l in open(R + r"\ida\out\h8s-decode\work\bu_all.tsv", encoding="utf-8"):
    p = l.rstrip("\n").split("\t")
    bu[int(p[0], 16)] = (int(p[1]), p[2], p[3] if len(p) > 3 else "")
# IDA items -> per-byte kind (inside runs only)
kind = {}
for l in list(open(O + r"\work\ida_items.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    ea, sz, k = int(p[1], 16), int(p[2]), p[3]
    for i in range(ea, ea + max(sz, 1)):
        if i < HI and runid[i] is not None: kind[i] = k
# IDA heads image-wide: code-ref targets
crefs = collections.defaultdict(list)   # target -> [(from, from_kind)]
headkind = {}
for l in list(open(O + r"\work\ida_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    ea = int(p[0], 16); headkind[ea] = p[2]
    if len(p) > 3 and p[3]:
        for t in p[3].split(","):
            d = t.startswith("d"); tv = int(t[1:] if d else t, 16)
            if tv < HI and runid[tv] is not None and not (runid[ea] if ea < HI else None) == runid[tv]:
                crefs[tv].append((ea, ("d" if d else "c"), "P" if pm[ea] else ("N" if nm[ea] else "R")))
# whole-image BE32 and abs24 jsr/jmp scans for addresses inside runs
be32 = collections.defaultdict(list)
for i in range(0, HI - 3):
    v = struct.unpack_from(">I", img, i)[0]
    if v < HI and runid[v] is not None and runid[i] != runid[v]:
        be32[v].append(i)
abs24 = collections.defaultdict(list)
for i in range(0, HI - 3):
    if img[i] in (0x5E, 0x5A) and img[i+1] == 0:
        t = (img[i+1] << 16) | (img[i+2] << 8) | img[i+3]
        if t < HI and runid[t] is not None and runid[i] != runid[t]:
            abs24[t].append(i)
def site(i): return "%06X%s" % (i, "P" if pm[i] else ("N" if nm[i] else "R"))
def lin(a, b):
    i, n, bad, term = a, 0, 0, ""
    while i < b:
        ln, mn, op = bu[i]
        if mn == ".word": bad += 1
        n += 1; term = mn
        i += ln
    return n, bad, i - b, term
rows = []
for a, b in runs:
    seg = img[a:b]; n = b - a
    kc = collections.Counter(kind.get(i, "unk") for i in range(a, b))
    pr = sum(1 for x in seg if 0x20 <= x < 0x7F)
    ins, bad, over, term = lin(a, b) if a % 2 == 0 else lin(a, b)
    rows.append(dict(start="%06X" % a, end="%06X" % b, len=n, n00=seg.count(0), nFF=seg.count(255), prt=pr, distinct=len(set(seg)),
        ida=";".join("%s:%d" % kv for kv in kc.most_common()),
        prev="%s%s" % ("P" if pm[a-1] else "N", headkind.get(a-2, headkind.get(a-1, "?"))) if a else "-",
        next="%s" % ("P" if b < HI and pm[b] else "N"),
        lin="%d/%d/%+d/%s" % (ins, bad, over, term),
        cref_in=" ".join("%06X<%06X%s%s" % (t, f, k, c) for t in range(a, b) for f, k, c in crefs.get(t, [])),
        be32_in=" ".join("%06X<%s" % (t, site(s)) for t in range(a, b) for s in be32.get(t, [])),
        abs24_in=" ".join("%06X<%s" % (t, site(s)) for t in range(a, b) for s in abs24.get(t, [])),
        hex=seg[:48].hex()))
keys = list(rows[0].keys())
with open(O + r"\work\features.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("\t".join(keys) + "\n")
    for r in rows: f.write("\t".join(str(r[k]) for k in keys) + "\n")
print(len(rows))

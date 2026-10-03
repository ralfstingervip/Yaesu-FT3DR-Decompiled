import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5 shared loader. Offline, read-only.
import struct, collections
R = str(_REPO)
O = R + r"\ida\out\main-unnamed"
HI = 0x7B754
sys.exit('The firmware image is not in this repository.')
NM4 = open(R + r"\ida\out\main-final4\final4_named_mask.bin", "rb").read()[:HI]
pm = open(R + r"\ida\out\main-final4\final4_proven_mask.bin", "rb").read()[:HI]
D95 = [(0x07810C,0x07815B),(0x0781A4,0x0781A9),(0x0781C4,0x078221),(0x07823C,0x07825F),(0x078268,0x078279),(0x07827C,0x078333),(0x07833C,0x07837B),(0x078384,0x0783D9),(0x0783EE,0x07842D),(0x078440,0x078441),(0x078448,0x078459),(0x078462,0x078507),(0x078514,0x078545)]
nm = bytearray(NM4)
for a, b in D95:
    for i in range(a, b + 1): nm[i] = 1
runs = [(int(l.split()[0], 16), int(l.split()[1], 16)) for l in open(O + r"\work\runs_raw.tsv")]
runid = [None] * HI
for a, b in runs:
    for i in range(a, b): runid[i] = a
bu = {}
for l in open(R + r"\ida\out\h8s-decode\work\bu_all.tsv", encoding="utf-8"):
    p = l.rstrip("\n").split("\t")
    bu[int(p[0], 16)] = (int(p[1]), p[2], p[3] if len(p) > 3 else "")
heads = {}       # ea -> (size, kind, targets)
for l in list(open(O + r"\work\ida_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    heads[int(p[0], 16)] = (int(p[1]), p[2], p[3] if len(p) > 3 else "")
headof = [None] * HI
for ea, (sz, k, t) in heads.items():
    for i in range(ea, min(ea + max(sz, 1), HI)): headof[i] = ea
items = collections.defaultdict(list)
for l in list(open(O + r"\work\ida_items.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    items[int(p[0], 16)].append((int(p[1], 16), int(p[2]), p[3], p[4], p[5], p[6]))
xrefs = collections.defaultdict(list)
for l in list(open(O + r"\work\ida_xrefs.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    xrefs[int(p[0], 16)].append((int(p[1], 16), int(p[2], 16), int(p[3]), p[4], p[5], p[6]))
TERM = {"rts", "rte", "bra", "jmp", "rts/l", "rtsl"}
def cls(i):
    return "P" if pm[i] else ("N" if nm[i] else "R")
def lin(a, b):
    i, out = a, []
    while i < b:
        ln, mn, op = bu[i]; out.append((i, ln, mn, op)); i += ln
    return out
def be32_sites(lo, hi):
    """every offset s with BE32(s) in [lo,hi), outside [lo,hi)"""
    out = []
    pat_hi = 0
    for s in range(0, HI - 3):
        v = (img[s] << 24) | (img[s+1] << 16) | (img[s+2] << 8) | img[s+3]
        if lo <= v < hi and not (lo <= s < hi): out.append((s, v))
    return out

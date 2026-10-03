# Lane M6 shared loader. Offline, read-only.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import os
R = _REPO_S
O = R + r"\ida\out\inferred-tables"
HI = 0x7B754
sys.exit("The firmware image is not in this repository.")
PM = open(R + r"\ida\out\l-wave-recon\final6_proven_mask.bin", "rb").read()
NM = open(R + r"\ida\out\l-wave-recon\final6_named_mask.bin", "rb").read()
heads = {}   # ea -> (size, kind, func, dis, ops[list of (type,value,addr,reg,dtype)])
for l in list(open(O + r"\work\m6_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    ops = []
    for s in p[5:8]:
        if s:
            t, v, a, r, d = s.split(":"); ops.append((int(t), int(v, 16), int(a, 16), int(r), int(d)))
    heads[int(p[0], 16)] = (int(p[1]), p[2], p[3], p[4], ops)
def proven_head(ea):
    sz, k, f, d, o = heads[ea]
    return k == "code" and all(PM[i] for i in range(ea, ea + sz))
def be16(a): return (img[a] << 8) | img[a+1]
def be32(a): return (img[a] << 24) | (img[a+1] << 16) | (img[a+2] << 8) | img[a+3]
def hx(a, n): return " ".join("%02x" % b for b in img[a:a+n])
refs = []    # (ea, dataaddr, how, proven)
for ea, (sz, k, f, d, ops) in heads.items():
    if k != "code": continue
    pv = proven_head(ea)
    for (t, v, a, r, dt) in ops:
        if t in (2, 4) and a: refs.append((ea, a, "o%d" % t, pv))
        elif t == 5 and v < HI: refs.append((ea, v, "imm", pv))
pieces = []
for l in open(O + r"\work\pieces_in.tsv", encoding="utf-8"):
    p = l.rstrip("\n").split("\t"); pieces.append((int(p[0], 16), int(p[1], 16), int(p[2]), p[3]))

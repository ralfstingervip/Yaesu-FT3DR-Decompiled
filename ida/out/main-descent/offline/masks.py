from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# H9: rebuild H1's ledger addend masks byte-for-byte (same inputs and rules as recount/offline/recount.py). Read-only.
import sys, json
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from common import *

def items(tag):
    m = bytearray(HI)
    for ln in open(R + "h8s-decode/work/items_%s.tsv" % tag, encoding="utf-8").read().splitlines()[1:]:
        ea, sz, k = ln.split("\t")[:3]
        if k == "code":
            ea = int(ea, 16)
            for x in range(ea, min(HI, ea + int(sz))): m[x] = 1
    return m
mb = items("before"); ma = items("after")

FN = {}
for f in ["main-low", "main-high-a", "main-high-b"]:
    L = open(R + "fnindex/%s.tsv" % f, encoding="utf-8").read().splitlines(); h = L[0].split("\t")
    for ln in L[1:]:
        c = dict(zip(h, ln.split("\t")))
        if c["validated"] == "yes": FN[int(c["start"], 16)] = int(c["end"], 16)
FNC = []
for ln in open(R + "recount/fnindex-corrections.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("span_start"): continue
    c = ln.split("\t"); FNC.append((int(c[0], 16), int(c[1], 16), c[6]))
A = bytearray(HI)
for s, e in FN.items():
    for x in range(s, min(e, HI)):
        if mb[x]: A[x] = 1
for s, e, t in FNC:
    for x in range(s, e): A[x] = 0

B0 = bytearray(HI)
for s, e, t in RUNS:
    if t != "other":
        for x in range(s, e): B0[x] = 1

# H1 odd-head bytes removed from recovered-code runs (117 untyped -> leave numerator; 120 ASCII -> retyped string)
_, _, rch1, _ = __import__("pickle").load(open(SCR + "../reach.pkl", "rb"))
PRH1 = bytearray(HI)
for a, (n, t, k) in rch1.items():
    for x in range(a, min(HI, a + n)): PRH1[x] = 1
ODD_BIN = bytearray(HI); ODD_ASC = bytearray(HI)
for l in open(R + "recount/odd-heads.tsv", encoding="utf-8"):
    if l.startswith("#") or l.startswith("ea\t"): continue
    r_ = l.rstrip("\n").split("\t"); a = int(r_[0], 16); n = int(r_[1]); reg = r_[4]; cl = r_[8]
    if reg != "run:recovered code": continue
    if cl.startswith("data: ASCII"):
        for x in range(a, a + n): ODD_ASC[x] = 1
    elif cl.startswith("data"):
        for x in range(a, a + n): ODD_BIN[x] = 1
    elif cl.startswith("bogus: partly"):
        for x in range(a, a + n):
            if not PRH1[x]: ODD_BIN[x] = 1
B = bytearray(B0)
for x in range(HI):
    if ODD_BIN[x]: B[x] = 0
RC0 = bytearray(HI)
for s, e, t in RUNS:
    if t == "recovered code":
        for x in range(s, e): RC0[x] = 1
RC = bytearray(RC0)
for x in range(HI):
    if ODD_BIN[x] or ODD_ASC[x]: RC[x] = 0

# D: proved-corrected extents
F1ROWS = []
L = [l for l in open(R + "recount/proved-corrected.tsv", encoding="utf-8").read().splitlines() if not l.startswith("#")]
H = L[0].split("\t")
for ln in L[1:]:
    c = dict(zip(H, ln.split("\t"))); F1ROWS.append(c)
D = bytearray(HI); DROW = {}
for c in F1ROWS:
    s = int(c["start"], 16); e = int(c["end"], 16)
    for x in range(s, e): D[x] = 1; DROW[x] = c["orig_start"]

E = bytearray(HI)
for ln in open(R + "main-raw-other/split.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("run_start"): continue
    c = ln.split("\t")
    if c[3] == "other" and c[4] in ("code",) or c[4].startswith("parameter table") and c[3] == "other":
        for x in range(int(c[0], 16), int(c[1], 16)): E[x] = 1
# G1 (cov.py rules, as replicated by H1)
plan = json.load(open(R + "h8s-decode/work/absorb_plan.json", encoding="utf-8"))
tier = bytearray(HI)
for a, n, t, o in plan["insns"]:
    for x in range(a, a + n): tier[x] = 1 if t == "A" else 2
for s, e in [(0x07630A, 0x0767B6), (0x02F2E0, 0x02F35E), (0x02F36C, 0x02F386), (0x030E00, 0x030E62), (0x030E6A, 0x030E96),
             (0x038074, 0x03808C), (0x0380A2, 0x0380E8), (0x0380EA, 0x038102), (0x05AF70, 0x05AF7C), (0x077A1C, 0x077A2C)]:
    for x in range(s, e):
        if ma[x] and not mb[x]: tier[x] = 1
D_orig = bytearray(HI)
for ln in open(R + "main-indirect/proved.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t")
    for x in range(int(c[0], 16), int(c[1], 16)): D_orig[x] = 1
cred0 = bytearray(HI)
for x in range(HI):
    if A[x] or D_orig[x] or B0[x] or E[x]: cred0[x] = 1
# note: H1's F uses the uncorrected A (validated fnindex x items_before); FNC spans are all is_code in mb, so re-add them
for s, e, t in FNC:
    for x in range(s, e):
        if mb[x]: cred0[x] = 1
F = bytearray(HI); G1A = bytearray(HI)
for x in range(HI):
    if ma[x] and not mb[x] and tier[x]:
        if not cred0[x]: F[x] = 1
        if tier[x] == 1 and not D_orig[x]: G1A[x] = 1
# H1 retyped-and-credited bytes (H addend): fnindex spans with a type, F1 text
HH = bytearray(HI)
for s, e, t in FNC:
    if t in ("string", "parameter table"):
        for x in range(s, e):
            if not (B[x] or F[x] or D_orig[x] or E[x]): HH[x] = 1
for c in F1ROWS:
    if c["h1_action"] == "text-trimmed":
        s = int(c["orig_start"], 16)
        for x in range(s, s + int(c["text_bytes"])): HH[x] = 1

def S(m): return sum(m)
if __name__ == "__main__":
    print("A", S(A), "B", S(B), "D", S(D), "E", S(E), "F", S(F), "G1A", S(G1A), "RC", S(RC), "RC0", S(RC0), "H", S(HH))
    print("proven", S(A) + S(RC) + S(D) + S(G1A))
    print("named MAIN", S(A) + S(B) - 28 + S(D) + S(E) + S(F) + S(HH))
    U = bytearray(HI)
    for x in range(HI):
        if A[x] or B[x] or D[x] or E[x] or F[x] or HH[x]: U[x] = 1
    print("named union", S(U))
    P = bytearray(HI)
    for x in range(HI):
        if A[x] or RC[x] or D[x] or G1A[x]: P[x] = 1
    print("proven union", S(P))

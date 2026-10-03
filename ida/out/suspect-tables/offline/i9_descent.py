# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_HERE = _Path(__file__).resolve().parent
_REPO = _Path(__file__).resolve().parents[4]
# I9: (1) per-table exclusion test for the three suspect tables, (2) gated record-field edges for the two key records
# at 0x0296E8 / 0x029712 consumed by the key dispatcher 0x028CBC. Uses H9's descent.py unchanged (imported, not run as main).
# Read-only on every input; prints results and writes one pickle to the I9 scratchpad.
import sys, pickle, re
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
import descent as D9
from common import IMG, HI, CW, be32
SCR = (str(_HERE / "local-temp") + "/")
M = pickle.load(open(SCR + "i9_masks.pkl", "rb"))
INW = lambda x: CW[0] <= x < CW[1]
def bm(r):
    m = bytearray(HI)
    for a, (n, t, k) in r.items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m
def spans(f, lo=0, hi=HI):
    out = []; x = lo
    while x < hi:
        if f(x):
            s = x
            while x < hi and f(x): x += 1
            out.append((s, x))
        else: x += 1
    return out
base = D9.run("full"); RB = bm(base["reached"])
assert bytes(RB) == M["RM"], "baseline differs from H9 RM"
print("baseline full reach bytes", sum(RB), "(equals H9 RM mask)")
out = {}
for T in (0x02941C, 0x0357CC, 0x07308C):
    saved = D9.TAB[T]; D9.TAB[T] = {}
    r = D9.run("full"); D9.TAB[T] = saved
    RX = bm(r["reached"])
    lost = [x for x in range(HI) if RB[x] and not RX[x]]
    print("table %06X: entries %d, bytes reached only through it: %d" % (T, len(saved), len(lost)))
    for s, e in spans(lambda x: RB[x] and not RX[x]):
        print("   %06X-%06X %4d  P=%d N=%d" % (s, e, e - s, sum(M["PROV"][s:e]), sum(M["NAMED"][s:e])))
    out[T] = lost
# record-field edges: 0x0296DE mov.l #0x296e8,er1 ; bra 0x28cbc   and 0x029708 mov.l #0x29712,er1 ; bra 0x28cbc
R0 = base["reached"]
for g in (0x0296DE, 0x0296E4, 0x029708, 0x02970E, 0x028CBC, 0x028D0C, 0x034C24, 0x000454, 0x00045A, 0x00042C, 0x0028DA, 0x0028E0, 0x0178F0, 0x0178F6, 0x015224):
    print("gate %06X reached=%s : %s" % (g, g in R0, R0.get(g, (0, "-"))[1]))
FIELDS = (0x00, 0x04, 0x08, 0x0C, 0x14, 0x18)    # offsets 0x028CBC loads (0x028D0C/24/40/4A/86/90)
extra = []
for rec in (0x0296E8, 0x029712):
    for off in FIELDS:
        v = be32(rec + off)
        print("record %06X +%02X = %08X" % (rec, off, v))
        if v and v < HI and v % 2 == 0: extra.append((v, "record %06X+%02X via 0x028CBC" % (rec, off)))
# RAM hook 0xFF811A: 0x034C24 jsr @0x450 -> 0x000454 mov.l #0x706,er5 -> 0x00045A bsr 0x42c -> 0x00042C mov.l er5,@0x811a:16;
# consumer 0x0028DA mov.l @0x811a:16,er6 ; 0x0028E0 jmp @er6 (vector 88 stub 0x0028D0). H9's window rule missed it (store in callee).
extra.append((0x000706, "ram-cell FF811A via helper 0x00042C (store) from 0x000454 mov.l #0x706,er5"))
# er1 callback: 0x0178F0 mov.l #0x1a084,er1 ; 0x0178F6 jsr @0x15206 ; 0x015224 jsr @er1 (er1 unchanged on that path)
extra.append((0x01A084, "er1 callback via 0x015206 (jsr @er1 at 0x015224) from 0x0178F0 mov.l #0x1a084,er1"))
r2 = D9.run("full", extra_seeds=extra); RN = bm(r2["reached"])
new = [x for x in range(HI) if RN[x] and not RB[x]]
print("record edges: newly reached bytes", len(new))
for s, e in spans(lambda x: RN[x] and not RB[x]):
    print("   %06X-%06X %4d  inPROV=%d inNAMED=%d  %s" % (s, e, e - s, sum(M["PROV"][s:e]), sum(M["NAMED"][s:e]), IMG[s:min(e, s + 12)].hex()))
st = D9.run("strict"); stx = D9.run("strict", extra_seeds=extra)
print("strict: gates reached", all(g in st["reached"] for g in (0x0296DE, 0x029708, 0x028D0C, 0x034C24, 0x000454, 0x00042C, 0x0028DA, 0x0178F0, 0x015224)))
SN = bm(stx["reached"]); SB = bm(st["reached"])
print("strict newly reached", sum(1 for x in range(HI) if SN[x] and not SB[x]))
dP = sum(1 for x in new if not M["PROV"][x]); dN = sum(1 for x in new if not M["NAMED"][x])
print("proven delta", dP, "named delta", dN)
# per-seed attribution of new bytes
attr = {}
for v, lab in extra:
    rr = D9.run("full", extra_seeds=[(v, lab)]); RR = bm(rr["reached"])
    attr[v] = [x for x in range(HI) if RR[x] and not RB[x]]
    print("seed %06X alone: +%d reached" % (v, len(attr[v])))
pickle.dump(dict(new=new, extra=extra, lost=out, attr=attr, RN=bytes(RN), SN=bytes(SN), SB=bytes(SB)), open(SCR + "i9_descent.pkl", "wb"))
# overlap check on the extended descent (no reached instruction may start inside another)
cov = {}
ov = 0
for a, (n, t, k) in sorted(r2["reached"].items()):
    for x in range(a + 1, a + n):
        if x in r2["reached"]: ov += 1; print("OVERLAP", hex(a), hex(x))
print("overlapping instruction starts in extended descent:", ov)
print("bad decodes new vs base:", sorted(set(r2["bad"]) - set(base["bad"]))[:20])

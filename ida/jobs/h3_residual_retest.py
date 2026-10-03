# -*- coding: utf-8 -*-
r"""Lane H3 (plain Python): re-test F1's 194 residual functions against the H3
pointer arrays and the post-reanalysis state of DB H3_PTRS (g2h3_residual_state.tsv).
Writes ida\out\ptr-arrays\residual-retest.tsv. The PROVEN rows were each checked by
hand against the disassembly in query_cand.txt; their code ranges are listed here."""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import collections, os
W = str(_REPO)
O = os.path.join(W, "ida", "out")
d = sys.exit("The firmware image is not in this repository.")
be = lambda a: int.from_bytes(d[a:a + 4], "big")

# residual start -> list of (code_lo, code_hi, how it ends) proven by an H3 array entry
PROVEN = {
    0x009188: [(0x00919E, 0x009246, "rts @009244")],
    0x00DB48: [(0x00DB58, 0x00DB5E, "rts @00DB5C")],
    0x01026C: [(0x01026E, 0x010276, "rts @010274")],
    0x0174E8: [(0x0174EA, 0x01750A, "rts @017508")],
    0x01EEC8: [(0x01EED0, 0x01EEF6, "5 case stubs, each bra 01EEF6")],
    0x0237A8: [(0x0237AA, 0x023812, "rts @023810")],
    0x034530: [(0x034532, 0x034534, "rts @034532")],
    0x035090: [(0x035092, 0x0350C0, "rts @0350BE")],
    0x053684: [(0x053686, 0x05369A, "jmp @er6 @053698")],
    0x05B3AC: [(0x05B3AE, 0x05B3C8, "rts @05B3C6")],
    0x05C434: [(0x05C436, 0x05C44C, "bra 05C45C (shared exit)")],
    0x063F48: [(0x063F4A, 0x063F84, "rts @063F4A; bra 064230 @063F72; bra 064230 @063F80")],
    0x073170: [(0x073172, 0x0731C0, "rts @0731BE")],
}
PREFIX = {  # what the bytes before the true entry are
    0x009188: "array 0x00917E slots (data)", 0x00DB48: "ASCII '-------\0'",
    0x01EEC8: "unreached 8-B case stub 01EEC8 (+18-B shared tail 01EEF6 kept unproven); "
              "NOTE G1 absorbed.tsv already credits 01EEBA-01EF08, so these 38 B are not new to the headline",
}

xr = collections.defaultdict(list)
for l in open(os.path.join(O, "ptr-arrays", "xrefs.tsv"), encoding="utf-8").readlines()[1:]:
    p = l.rstrip("\n").split("\t")
    xr[int(p[1], 16)].append(p)
st = {}
for l in open(os.path.join(O, "ptr-arrays", "g2h3_residual_state.tsv"), encoding="utf-8").readlines()[1:]:
    p = l.rstrip("\n").split("\t")
    st[int(p[0], 16)] = p
proved = []
for l in open(os.path.join(O, "main-indirect", "proved.tsv"), encoding="utf-8").readlines()[1:]:
    p = l.split("\t")
    proved.append((int(p[0], 16), int(p[1], 16)))

def overlap_proved(lo, hi):
    return sum(max(0, min(hi, e) - max(lo, s)) for s, e in proved)

rows = []
tot = collections.Counter()
nb = collections.Counter()
newb = 0
for l in open(os.path.join(O, "main-indirect", "residual.tsv"), encoding="utf-8").readlines()[1:]:
    p = l.rstrip("\n").split("\t")
    s, e, n = int(p[0], 16), int(p[1], 16), int(p[2])
    f1 = p[5]
    ex = xr.get(s, [])
    ins = sorted(t for t in xr if s < t < e)
    S = st.get(s)
    ida_state = "func@start" if S and S[3] == "1" and S[4] == p[0] else ("merged:" + S[4] if S and S[3] == "1" else "no-func")
    code = ""
    pb = 0
    if s in PROVEN:
        status = "PROVEN-PTR"
        parts = []
        for lo, hi, how in PROVEN[s]:
            ents = [x for t in sorted(xr) if lo <= t < hi for x in xr[t]]
            cite = ";".join("%s[%s]@%s=%08X" % (x[2], x[3], x[0], be(int(x[0], 16))) for x in ents[:4])
            ov = overlap_proved(lo, hi)
            pb += (hi - lo) - ov
            parts.append("%06X-%06X (%d B, %s) via %s" % (lo, hi, hi - lo, how, cite))
        code = " | ".join(parts)
        pre = PREFIX.get(s, "%d-B prefix %s = tail of preceding instruction (F1 start mid-instruction)" % (
            PROVEN[s][0][0] - s, d[s:PROVEN[s][0][0]].hex()))
        note = "true entry inside F1 extent; " + pre
    elif ex:
        status = "REACHED-OVERSPLIT"
        x = ex[0]
        code = "exact target of %s[%s] slot %s = %08X" % (x[2], x[3], x[0], be(int(x[0], 16)))
        note = "reached but no return in extent (F1: %s); flows into following code" % p[4]
    elif "closed service window" in f1:
        status = "CLOSED"; note = "inside 0x078106-0x07B753, not analysed"
    elif f1.startswith("1-2 insn stub"):
        status = "JUNK-STUB"; note = f1[:80]
    elif f1.startswith("self-contained standalone"):
        status = "UNPROVEN-STANDALONE"; note = "no pointer in 149 tables or H3 arrays (A/B/C); G2: no direct caller"
    else:
        status = "OVERSPLIT"; note = f1[:90]
    tot[status] += 1
    nb[status] += n
    newb += pb
    rows.append((p[0], p[1], n, p[4], status, pb, ida_state, code, note))

with open(os.path.join(O, "ptr-arrays", "residual-retest.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("start\tend\tbytes\tf1_return\th3_status\tnew_proven_bytes\tida_after_g2h3\tevidence\tnote\n")
    for r in rows:
        h.write("%s\t%s\t%d\t%s\t%s\t%d\t%s\t%s\t%s\n" % r)
print(dict(tot)); print(dict(nb)); print("new proven bytes (no overlap with proved.tsv):", newb)

"""N6: recompute headline conventions A-E from the published masks only (read-only).
Inputs: decrypted images, ida\\out\\m-wave-recon\\final7_*_mask.bin, ida\\out\\sub-final3\\raw\\mask_final3_after_*.bin,
ida\\out\\sub-residue-final\\runs.tsv / proposed-typing.tsv. Writes only ida\\out\\convention-d\\."""
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, os, sys
R = _REPO_S
OUT = os.path.join(R, r"ida\out\convention-d")
def rd(p): return open(os.path.join(R, p), "rb").read()
def sha(b): return hashlib.sha256(b).hexdigest()
log = []
def say(s): log.append(s); print(s)
FAIL = []
def chk(name, got, want):
    ok = got == want
    if not ok: FAIL.append(name)
    say("%s %s: got %r want %r" % ("PASS" if ok else "FAIL", name, got, want))
    return ok

sys.exit("The firmware image is not in this repository."); sys.exit("The firmware image is not in this repository.")
chk("MAIN sha256", sha(MAINB), "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce")
chk("SUB sha256", sha(SUBB), "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230")

# ---- MAIN FINAL7 masks
N7 = rd(r"ida\out\m-wave-recon\final7_named_mask.bin"); P7 = rd(r"ida\out\m-wave-recon\final7_proven_mask.bin")
chk("final7 named sha256", sha(N7), "0bcf995b1087e72397fc67e8f2e8487ddae0010ba312dfd58ae000f7fdf7fdd2")
chk("final7 proven sha256", sha(P7), "5585a9c6d810d96401a6dbd14eadabc575893e8c890dd39263e1df00040d58db")
HI = 0x07B754
chk("MAIN content = 0x07B754", HI, 505684)
chk("MAIN 0x07B754..0x100000 all FF", set(MAINB[HI:]), {0xFF})
chk("named mask values 0/1", set(N7) <= {0, 1}, True)
chk("proven mask values 0/1", set(P7) <= {0, 1}, True)
chk("named outside content", sum(N7[HI:]), 0)
chk("proven outside content", sum(P7[HI:]), 0)
chk("proven subset named", all(n or not p for n, p in zip(N7, P7)), True)
MN, MP = sum(N7), sum(P7)
chk("MAIN named", MN, 505165); chk("MAIN proven", MP, 365358)
def runs(pred, n, base=0):
    out = []; s = None
    for i in range(n):
        if pred(i):
            if s is None: s = i
        elif s is not None: out.append((base + s, base + i)); s = None
    if s is not None: out.append((base + s, base + n))
    return out
un = runs(lambda i: not N7[i], HI)
chk("MAIN unnamed bytes", sum(e - s for s, e in un), 519)
chk("stale copy 0x069A7F-0x069AAA unnamed (43 B)", all(not N7[i] for i in range(0x069A7F, 0x069AAA)), True)
chk("stale copy first 37 B == 0x069964", MAINB[0x069A7F:0x069A7F + 37] == MAINB[0x069964:0x069964 + 37], True)

# ---- SUB K7 masks (window FFED0000-FFF50000, file 0x2D0000-0x350000)
WLO, W = 0xFFED0000, 0x80000
def m(n): return rd(r"ida\out\sub-final3\raw\mask_final3_after_%s.bin" % n)
HW, AW, RW, HL, RE = m("headline_w2"), m("allwf"), m("reach_w2"), m("headline"), m("reach")
for nm, x in (("headline_w2", HW), ("allwf", AW), ("reach_w2", RW), ("headline", HL), ("reach", RE)):
    chk("SUB %s length" % nm, len(x), W); chk("SUB %s values 0/1" % nm, set(x) <= {0, 1}, True)
    say("INFO sha256 mask_final3_after_%s.bin %s" % (nm, sha(x)))
SC, SA, SR = sum(HW), sum(AW), sum(RW)
chk("SUB window code headline_w2", SC, 464263)
chk("SUB allwf", SA, 467999)
chk("SUB reach_w2", SR, 457462)
chk("SUB headline (no w2)", sum(HL), 464165); chk("SUB reach (no w2)", sum(RE), 454692)
chk("headline_w2 subset allwf", all(a or not h for h, a in zip(HW, AW)), True)
chk("reach_w2 subset headline_w2", all(h or not r for h, r in zip(HW, RW)), True)
TY = W - SA                       # typed = window - allwf
RES = SA - SC                     # residue = allwf - headline_w2
chk("SUB typed", TY, 56289)
chk("SUB residue", RES, 3736)
chk("SUB gap = typed + residue", W - SC, TY + RES)
chk("SUB code + typed + residue = window", SC + TY + RES, 524288)
# three-way partition: every window byte is in exactly one of code / typed / residue
part = [(1 if HW[i] else 0) + (1 if not AW[i] else 0) + (1 if (AW[i] and not HW[i]) else 0) for i in range(W)]
chk("partition: each window byte in exactly one class", set(part), {1})
rr = runs(lambda i: AW[i] and not HW[i], W, WLO)
chk("residue run count", len(rr), 59)

# residue == doc 127 runs.tsv, all DEAD, and == proposed-typing.tsv
def tsv(p):
    L = open(os.path.join(R, p), encoding="utf-8").read().splitlines()
    h = L[0].split("\t"); return [dict(zip(h, l.split("\t"))) for l in L[1:] if l.strip()]
RT = tsv(r"ida\out\sub-residue-final\runs.tsv"); PT = tsv(r"ida\out\sub-residue-final\proposed-typing.tsv")
PTOT = [r for r in PT if r["start"] == "TOTAL"]; PT = [r for r in PT if r["start"] != "TOTAL"]
chk("proposed-typing TOTAL row bytes", [r["bytes"] for r in PTOT], ["3736"])
rt = [(int(r["start"], 16), int(r["end"], 16)) for r in RT]
pt = [(int(r["start"], 16), int(r["end"], 16)) for r in PT]
chk("mask residue runs == runs.tsv", rr, rt)
chk("mask residue runs == proposed-typing.tsv", rr, pt)
chk("runs.tsv all klass DEAD", {r["klass"] for r in RT}, {"DEAD"})
chk("proposed-typing all class DEAD", {r["class"] for r in PT}, {"DEAD"})
chk("runs.tsv bytes column sum", sum(int(r["bytes"]) for r in RT), 3736)
sub = {}
for r in PT:
    k = r["subclass"].split()[0]; sub[k] = sub.get(k, 0) + int(r["bytes"])
chk("subclass dead-function", sub.get("dead-function"), 3393)
chk("subclass dead-function+split-byte", sub.get("dead-function+split-byte"), 300)
chk("subclass fragment", sub.get("fragment"), 43)
bad = 0
for r in RT:  # first_bytes vs image at file_off
    fo = int(r["file_off"], 16); fb = bytes.fromhex(r["first_bytes"])
    if fo != int(r["start"], 16) - 0xFFC00000 or SUBB[fo:fo + len(fb)] != fb: bad += 1
chk("runs.tsv first_bytes match SUB image at file_off (59 rows)", bad, 0)

# strict reach: reach_w2 minus the 120 B through stale lane-4 roots
STALE = [(0xFFF2570F, 0xFFF25771), (0xFFF38800, 0xFFF3880B), (0xFFF38871, 0xFFF3887C)]
chk("stale-root ranges inside reach_w2", all(RW[a - WLO] for s, e in STALE for a in range(s, e)), True)
STL = sum(e - s for s, e in STALE); chk("stale-root bytes", STL, 120)
SS = SR - STL; chk("SUB strict reach", SS, 457342)

# ---- conventions (denominator unchanged: MAIN content + SUB window)
DEN = HI + W; chk("denominator", DEN, 1029972)
conv = [
    ("A", "MAIN named + SUB window code (headline_w2)", MN, SC, 969428, "94.12"),
    ("B", "MAIN named + SUB code + DEAD residue (allwf)", MN, SC + RES, 973164, "94.48"),
    ("C", "MAIN named + SUB code + typed", MN, SC + TY, 1025717, "99.59"),
    ("D", "MAIN named + SUB code + typed + DEAD residue", MN, SC + TY + RES, 1029453, "99.95"),
    ("E", "MAIN proven + SUB strict reach", MP, SS, 822700, "79.88"),
]
rows = []
for k, d, a, b, want, pw in conv:
    t = a + b
    chk("convention %s total" % k, t, want); chk("convention %s pct" % k, "%.2f" % (100.0 * t / DEN), pw)
    rows.append((k, d, a, b, t, DEN, "%.4f%%" % (100.0 * t / DEN), "%.4f%%" % (100.0 * b / W)))

# ---- byte anchors cited in doc 133
ANCH = [
    ("SUB", 0xFFC00017, "fb e2 70 8a ed ff fd 68 ec"),   # mov.l #FFED8A70,r14 ; mvtc r14,intb
    ("SUB", 0xFFEDAE05, "71 00 ec a1 01 a0 8a a9"),       # first residue run
    ("SUB", 0xFFF13DDA, "72 00 e0 fe f9 05 8e 00 f9 05 8d 00 3c 84 00 3e 02 00 3e 01 00"),
    ("SUB", 0xFFF2A7F9, "a0 09 2e 7e a9 8c 72 41 0c 10"),
    ("SUB", 0xFFF2570F, None), ("SUB", 0xFFF38800, None),
    ("MAIN", 0x07B740, "00 02 0a 00 00 00 07 05 01 02 40 00 00 07 05 82 02 40 00 00 ff ff ff ff"),
    ("MAIN", 0x069A7F, None), ("MAIN", 0x069964, None),
]
bc = []
for img, addr, want in ANCH:
    fo = addr - 0xFFC00000 if img == "SUB" else addr
    src = SUBB if img == "SUB" else MAINB
    n = len(bytes.fromhex(want)) if want else 8
    got = src[fo:fo + n].hex(" ")
    ok = (want is None) or got == want
    if not ok: FAIL.append("anchor %s %X" % (img, addr))
    bc.append((img, "%08X" % addr, "%06X" % fo, got, want or "(recorded)", "PASS" if ok else "FAIL"))

with open(os.path.join(OUT, "ledger.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("convention\tdefinition\tMAIN_term\tSUB_term\theadline\tdenominator\theadline_pct\tSUB_pct_of_524288\n")
    for r in rows: f.write("\t".join(map(str, r)) + "\n")
    f.write("\nterm\tbytes\tsource\n")
    for t in (("MAIN content 0x000000-0x07B754", HI, "m_recon.py CONTENT; 0x07B754-0x100000 all FF"),
              ("MAIN named (FINAL7)", MN, "final7_named_mask.bin"),
              ("MAIN proven (FINAL7)", MP, "final7_proven_mask.bin"),
              ("MAIN unnamed", HI - MN, "content - named; incl. 43 B stale copy 0x069A7F-0x069AAA"),
              ("SUB window FFED0000-FFF50000", W, "file 0x2D0000-0x350000"),
              ("SUB window code (headline_w2)", SC, "mask_final3_after_headline_w2.bin"),
              ("SUB typed (window - allwf)", TY, "complement of mask_final3_after_allwf.bin"),
              ("SUB DEAD residue (allwf - headline_w2)", RES, "59 runs == sub-residue-final runs.tsv"),
              ("SUB code + typed + residue", SC + TY + RES, "== window, partition exact"),
              ("SUB reach_w2", SR, "mask_final3_after_reach_w2.bin"),
              ("SUB stale-root bytes", STL, "FFF2570F-FFF25771, FFF38800-FFF3880B, FFF38871-FFF3887C"),
              ("SUB strict reach", SS, "reach_w2 - stale-root bytes"),
              ("denominator", DEN, "505,684 + 524,288 (unchanged)"),
              ("named delta from N6", 0, "no byte newly named")):
        f.write("%s\t%d\t%s\n" % t)
with open(os.path.join(OUT, "main-unnamed-runs.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_excl\tbytes\n")
    for s, e in un: f.write("%06X\t%06X\t%d\n" % (s, e, e - s))
with open(os.path.join(OUT, "sub-residue-runs.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_excl\tfile_off\tbytes\n")
    for s, e in rr: f.write("%08X\t%08X\t%06X\t%d\n" % (s, e, s - 0xFFC00000, e - s))
with open(os.path.join(OUT, "bytecheck.tsv"), "w", encoding="utf-8", newline="\n") as f:
    f.write("image\taddress\tfile_off\tbytes_in_image\texpected\tresult\n")
    for r in bc: f.write("\t".join(r) + "\n")
say("RESULT %d checks failed: %s" % (len(FAIL), FAIL))
open(os.path.join(OUT, "n6_log.txt"), "w", encoding="utf-8", newline="\n").write("\n".join(log) + "\n")
sys.exit(1 if FAIL else 0)

r"""Lane N7 -- SUB strict reach: inbound-edge search for the 120 B credited to reach_w2
only through stale lane-4 'xref' roots FFF2570F and FFF38800 (doc 127 / I17 ambiguous.tsv).

Read-only. No DB opened by this script, no image or mask modified, nothing written to a radio.
Primary evidence is the image bytes themselves (DB-independent, i.e. does NOT use any lane-4 xref
root). M15's codeheads.tsv is loaded only to say whether a branch *source* offset is a real
instruction head, and switches.tsv only to cross-check IDA's computed switch cases.

Inputs : decrypted\FT3D_SUB_ver102_ALL.bin
         ida\out\sub-residue-final\raw\{codeheads,switches,xrefs}.tsv  (M15 DB exports, corroboration only)
Outputs: ida\out\sub-reach\roots.tsv, proposed-reach.tsv, raw\reach_log.txt
"""
# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import os, struct, hashlib, collections

R = str(_REPO)
OUT = os.path.join(R, "ida/out/sub-reach")
RAW = os.path.join(OUT, "raw")
os.makedirs(RAW, exist_ok=True)
BASE = 0xFFC00000
img = open(os.path.join(R, _no_image()), "rb").read()
SUB_SHA = hashlib.sha256(img).hexdigest()
MAIN_SHA = hashlib.sha256(open(os.path.join(R, _no_image()), "rb").read()).hexdigest()
LOG = open(os.path.join(RAW, "reach_log.txt"), "w", encoding="utf-8", newline="\n")
def log(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.write(s + "\n")
log("MAIN sha256", MAIN_SHA)
log("SUB  sha256", SUB_SHA)
assert MAIN_SHA == "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"
assert SUB_SHA == "b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230"

# ---- the 120 B (half-open ranges) and their two parent dead functions
R1  = (0xFFF2570F, 0xFFF25771)              # 98 B, inside dead_FFF256BD
R2a = (0xFFF38800, 0xFFF3880B)              # 11 B, inside dead_FFF387C9
R2b = (0xFFF38871, 0xFFF3887C)              # 11 B, inside dead_FFF387C9
RANGES = [("R1", R1), ("R2a", R2a), ("R2b", R2b)]
F1 = (0xFFF256BD, 0xFFF25771)               # whole dead_FFF256BD (180 B)
F2 = (0xFFF387C9, 0xFFF3887C)               # whole dead_FFF387C9 (179 B)
FUNCS = [("dead_FFF256BD", F1), ("dead_FFF387C9", F2)]
# the lane-4 'xref' roots that seeded these 120 B (functions.tsv / ambiguous.tsv)
ROOTS = [0xFFF2570F, 0xFFF38800]
# every address that is an *entry* lane-4 jumped to inside the reach_w2 (ambiguous.tsv edges)
ENTRIES = [0xFFF2570F, 0xFFF38800, 0xFFF3880B, 0xFFF38874]

T120 = set()
for _, (a, b) in RANGES:
    T120 |= set(range(a, b))
assert len(T120) == 120, len(T120)
Fset = {nm: set(range(a, b)) for nm, (a, b) in FUNCS}
def infunc(ea):
    for nm, s in Fset.items():
        if ea in s:
            return nm
    return None

# ---- M15 validated relative-branch decoder (identical to m15_analyze.branch; 0 mismatches vs IDA)
def s8(v):  return v - 256 if v >= 128 else v
def s16(v): return v - 65536 if v >= 32768 else v
def s24(v): return v - (1 << 24) if v >= (1 << 23) else v
def branch(ea):
    o = ea - BASE
    if o < 0 or o + 4 > len(img) + 3:
        return None
    b0 = img[o]
    if 0x08 <= b0 <= 0x1F:
        d = b0 & 7; d = d if d >= 3 else d + 8
        k = "bra.s" if b0 < 0x10 else ("beq.s" if b0 < 0x18 else "bne.s")
        return k, ea + d
    if 0x20 <= b0 <= 0x2E and o + 1 < len(img):
        return ("bra.b" if b0 == 0x2E else "bcnd.b"), (ea + s8(img[o + 1])) & 0xFFFFFFFF
    if b0 in (0x38, 0x39, 0x3A, 0x3B) and o + 2 < len(img):
        return {0x38: "bra.w", 0x39: "bsr.w", 0x3A: "beq.w", 0x3B: "bne.w"}[b0], (ea + s16(img[o + 1] | img[o + 2] << 8)) & 0xFFFFFFFF
    if b0 in (0x04, 0x05) and o + 3 < len(img):
        return ("bra.a" if b0 == 4 else "bsr.a"), (ea + s24(img[o + 1] | img[o + 2] << 8 | img[o + 3] << 16)) & 0xFFFFFFFF
    return None

# ---- DB code-head map (corroboration: is a branch source a real instruction head?)
CH = {}
for L in open(os.path.join(R, "ida/out/sub-residue-final/raw/codeheads.tsv"), encoding="utf-8").read().splitlines()[1:]:
    p = L.split("\t")
    CH[int(p[0], 16)] = (int(p[1]), p[3], p[5])   # ea -> (size, mnem, disasm)
log("DB code heads loaded", len(CH))

TARGETSETS = [("120B", T120), ("dead_FFF256BD", Fset["dead_FFF256BD"]), ("dead_FFF387C9", Fset["dead_FFF387C9"])]

# =====================================================================================
# SCAN A -- PC-relative branches/calls at EVERY byte offset, target inside a target set.
#   Covers bra.s/beq.s/bne.s, bra.b/bcnd.b, bra.w/bsr.w/beq.w/bne.w, bra.a/bsr.a.
# =====================================================================================
hitsA = []   # (setname, kind, src_ea, tgt, src_infunc, src_is_dbhead, internal?)
OPC = (0x04, 0x05) + tuple(range(0x08, 0x2F)) + (0x38, 0x39, 0x3A, 0x3B)
for o in range(len(img) - 1):
    if img[o] not in OPC:
        continue
    ea = BASE + o
    b = branch(ea)
    if not b:
        continue
    k, t = b
    for setname, S in TARGETSETS:
        if t in S:
            src_fn = infunc(ea)
            tgt_fn = infunc(t)
            internal = (src_fn is not None and src_fn == tgt_fn)
            hitsA.append((setname, k, ea, t, src_fn, ea in CH, internal, CH.get(ea, (0, "", ""))[2]))
log("SCAN A relative-branch hits (any target set):", len(hitsA))

# =====================================================================================
# SCAN B -- absolute address references at EVERY byte offset.
#   4-byte LE value == a target address. Covers: LE32 pointer tables (any alignment),
#   MOV.L #imm32 absolute, relocatable INTB/EXTB vector slots, RX switch 'bra.l'/'jsr Rn'
#   absolute jump tables, and jsr/jmp Rn whose register is loaded from a memory pointer
#   (all such pointers are an absolute 4-byte value somewhere in the image).
#   (RX imm24 sign-extends 0xFFxxxx->0xFFFFxxxx, which can never equal 0xFFF2xxxx/0xFFF3xxxx,
#    so a 24-bit immediate cannot address these ranges; the 32-bit scan is the complete test.)
# =====================================================================================
TARGET_ADDRS = sorted(T120 | Fset["dead_FFF256BD"] | Fset["dead_FFF387C9"] | set(ENTRIES) | set(ROOTS))
TA = set(TARGET_ADDRS)
hitsB = []   # (value, off_ea, in_which_set, 4 context bytes)
for o in range(len(img) - 3):
    # cheap prefilter: high byte of a 0xFFF2xxxx/0xFFF3xxxx address is 0xFF, 3rd byte 0xF2/0xF3
    if img[o + 3] != 0xFF or img[o + 2] not in (0xF2, 0xF3):
        continue
    v = img[o] | img[o + 1] << 8 | img[o + 2] << 16 | img[o + 3] << 24
    if v in TA:
        which = ("120B" if v in T120 else "") + ("|F1" if v in Fset["dead_FFF256BD"] else "") + ("|F2" if v in Fset["dead_FFF387C9"] else "")
        hitsB.append((v, BASE + o, which.strip("|"), img[o:o + 4].hex()))
log("SCAN B absolute 4-byte LE hits on any target address:", len(hitsB))
for v, ea, which, ctx in hitsB:
    src_fn = infunc(ea)
    log("   abs %08X referenced by LE32 at %08X (%s) bytes=%s src_in=%s" % (v, ea, which, ctx, src_fn))

# =====================================================================================
# SCAN C -- INTB (256) + EXTB (32) relocatable vector slots explicitly.
# =====================================================================================
INTB, EXTB = 0xFFED8A70, 0xFFFFFF80
assert img[0x17:0x1D].hex() == "fbe2708aedff"   # mov.l #FFED8A70,r14 ; mvtc r14,intb
assert img[0x0E:0x14].hex() == "fbe280ffffff"   # mov.l #FFFFFF80,r14 ; mvtc r14,extb
vec = [("INTB", i, struct.unpack_from("<I", img, INTB - BASE + 4 * i)[0]) for i in range(256)]
vec += [("EXTB", i, struct.unpack_from("<I", img, EXTB - BASE + 4 * i)[0]) for i in range(32)]
vhit = [(tb, i, v) for tb, i, v in vec if v in TA]
log("SCAN C vector slots 288 ; into any target:", len(vhit), vhit)

# =====================================================================================
# SCAN D -- IDA computed switch cases (M15 switches.tsv all_targets) into the 120 B / funcs.
# =====================================================================================
swhit = []
for L in open(os.path.join(R, "ida/out/sub-residue-final/raw/switches.tsv"), encoding="utf-8").read().splitlines()[1:]:
    p = L.split("\t")
    for t in (p[3] if len(p) > 3 else "").replace(",", " ").split():
        try:
            tv = int(t, 16)
        except ValueError:
            continue
        if tv in TA:
            swhit.append((p[0], tv))
log("SCAN D IDA switch cases into any target:", len(swhit), swhit)

# =====================================================================================
# SCAN E -- IDA xrefs that M15 exported (keyed by the residue runs; corroboration only).
# =====================================================================================
xhit = []
for L in open(os.path.join(R, "ida/out/sub-residue-final/raw/xrefs.tsv"), encoding="utf-8").read().splitlines()[1:]:
    p = L.split("\t")
    if int(p[1], 16) in TA:
        xhit.append(tuple(p))
log("SCAN E M15 IDA xref rows into any target:", len(xhit), xhit)

# ---- classify SCAN A hits
log("\n--- SCAN A detail ---")
externalA = []
for setname, k, src, tgt, src_fn, isdb, internal, dis in hitsA:
    tag = "INTERNAL(stale: same dead function)" if internal else "EXTERNAL->candidate live edge"
    note = "DB instruction head" if isdb else "NOT a DB instruction head (byte coincidence)"
    log("   [%s] %-6s %08X -> %08X  src_fn=%s  %s  %s  %s" % (setname, k, src, tgt, src_fn, note, tag, (dis[:40] if isdb else "")))
    if not internal and isdb:
        externalA.append((setname, k, src, tgt))
log("SCAN A EXTERNAL edges that ARE real DB instructions:", len(externalA), externalA)

# =====================================================================================
# VERDICT
# =====================================================================================
# A live inbound edge to the 120 B (or to either parent dead function from outside it) exists iff
# any of: SCAN A external+DB-head, SCAN B, SCAN C, SCAN D, SCAN E produced a hit that is not an
# internal (same-function) branch.
live_120 = []
for setname, k, src, tgt in externalA:
    if setname == "120B":
        live_120.append(("branch", k, src, tgt))
# B/C/D/E hits (all would be external by nature) targeting 120B:
for v, ea, which, ctx in hitsB:
    if v in T120:
        live_120.append(("abs-LE32", "", ea, v))
for tb, i, v in vhit:
    if v in T120:
        live_120.append(("vector", "%s[%d]" % (tb, i), 0, v))
for site, tv in swhit:
    if tv in T120:
        live_120.append(("switch", site, 0, tv))
# also: is either parent function reached from outside it? (transitive path to the 120 B)
live_parent = []
for setname, k, src, tgt in externalA:
    if setname in ("dead_FFF256BD", "dead_FFF387C9"):
        live_parent.append((setname, "branch", k, src, tgt))
for v, ea, which, ctx in hitsB:
    if infunc(v) and v not in T120:
        live_parent.append((infunc(v), "abs-LE32", "", ea, v))
for tb, i, v in vhit:
    if infunc(v):
        live_parent.append((infunc(v), "vector", "%s[%d]" % (tb, i), 0, v))

log("\n==================== VERDICT ====================")
log("Direct live inbound edge to the 120 B:", "FOUND" if live_120 else "NONE", live_120)
log("Live inbound edge to either parent dead function (transitive route to the 120 B):",
    "FOUND" if live_parent else "NONE", live_parent)
strict_confirmed = not live_120 and not live_parent
log("457,342 strict reach:", "CONFIRMED (120 B Not found for a live edge)" if strict_confirmed else "CHALLENGED")

# ---- roots.tsv : the stale lane-4 xref roots and what actually reaches each entry
with open(os.path.join(OUT, "roots.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("root_addr\tfile_off\tparent_dead_func\tfunc_extent\treach_w2_range\tbytes\t"
            "lane4_type\tonly_inbound_edges\tall_inbound_from_outside_func\tverdict\n")
    recs = [
        (0xFFF2570F, "dead_FFF256BD", F1, "FFF2570F-FFF25771", 98, "xref",
         "jump FFF25700->FFF2570F (inside dead_FFF256BD); jumps FFF256D1/FFF256F2/FFF2570D->FFF2576B"),
        (0xFFF38800, "dead_FFF387C9", F2, "FFF38800-FFF3880B + FFF38871-FFF3887C", 22, "xref",
         "jumps FFF387F8->FFF38800, FFF387DB->FFF3880B, FFF387EB/FFF387FE->FFF38874 (all inside dead_FFF387C9)"),
    ]
    for root, fn, (fs, fe), rng, nb, typ, edges in recs:
        ext_cnt = sum(1 for s in externalA if infunc(s[3]) == fn) + \
                  sum(1 for v, ea, which, ctx in hitsB if infunc(v) == fn) + \
                  sum(1 for tb, i, v in vhit if infunc(v) == fn) + \
                  sum(1 for site, tv in swhit if infunc(tv) == fn)
        h.write("%08X\t%06X\t%s\t%08X-%08X\t%s\t%d\t%s\t%s\t%d\t%s\n" % (
            root, root - BASE, fn, fs, fe, rng, nb, typ, edges, ext_cnt,
            "stale: parent function has 0 inbound edges from outside; reach only via internal jump" if ext_cnt == 0 else "LIVE EDGE FOUND"))
log("wrote roots.tsv")

# ---- proposed-reach.tsv : the 120 B, their scan result, and the proposal
with open(os.path.join(OUT, "proposed-reach.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("range\tstart\tend\tfile_off\tbytes\tparent_dead_func\tfirst_bytes\t"
            "scanA_branch\tscanB_abs\tscanC_vector\tscanD_switch\tscanE_xref\tlive_edge\tproposed\n")
    for nm, (a, b) in RANGES:
        fn = infunc(a)
        nA = sum(1 for s in hitsA if s[0] == "120B" and a <= s[3] < b and not s[6] and s[5])
        nAi = sum(1 for s in hitsA if s[0] == "120B" and a <= s[3] < b and s[6])
        nB = sum(1 for v, ea, w, c in hitsB if a <= v < b)
        nC = sum(1 for tb, i, v in vhit if a <= v < b)
        nD = sum(1 for site, tv in swhit if a <= tv < b)
        nE = sum(1 for p in xhit if a <= int(p[1], 16) < b)
        live = (nA + nB + nC + nD + nE) > 0
        h.write("%s\t%08X\t%08X\t%06X\t%d\t%s\t%s\tinternal=%d external=%d\t%d\t%d\t%d\t%d\t%s\t%s\n" % (
            nm, a, b, a - BASE, b - a, fn, img[a - BASE:a - BASE + 8].hex(),
            nAi, nA, nB, nC, nD, nE,
            "NONE" if not live else "FOUND",
            "stay credited-unreached; NOT proven-reached (no live edge; reached only as stale lane-4 xref root)" if not live else "credit as reached (live edge cited)"))
    h.write("TOTAL\t\t\t\t120\t\t\t\t\t\t\t\t%s\t%s\n" % (
        "NONE" if strict_confirmed else "FOUND",
        "strict SUB reach = 457,342 (457,462 - 120); named headline unchanged" if strict_confirmed else "revise"))
log("wrote proposed-reach.tsv")

# ---- re-verify hashes at finish
assert hashlib.sha256(img).hexdigest() == SUB_SHA
log("\nSUB sha256 re-checked at finish:", SUB_SHA, "(unchanged)")
LOG.close()

r"""Lane H8 -- build gap-runs.tsv, new-functions.tsv, typed-data.tsv and counts.txt from the raw IDA dumps.

Plain Python, reads decrypted\FT3D_SUB_ver102_ALL.bin read-only.
    python "ida/out/sub-gap/raw/h8_build.py"
"""
# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import bisect, collections, os, struct

ROOT = str(_REPO)
RAW = os.path.join(ROOT, "ida/out/sub-gap/raw")
OUT = os.path.join(ROOT, "ida/out/sub-gap")
B = 0xFFC00000
W0, W1, TOP = 0xFFED0000, 0xFFF50000, 0xFFF509DE
img = open(os.path.join(ROOT, _no_image()), "rb").read()


def rd(p):
    with open(p, encoding="utf-8") as h:
        return [l.rstrip("\n").split("\t") for l in h]


def by(a, n):
    return img[a - B:a - B + n].hex()


# ---------------- validated set / purposes ----------------
F = [(int(r[0], 16), int(r[1], 16), r[2], r[4]) for r in rd(os.path.join(ROOT, "ida/out/sub-window/functions.tsv"))[1:]]
VF = sorted((s, e) for s, e, c, p in F if c in ("xref", "body"))
VS = [s for s, e in VF]


def vfunc(ea):
    i = bisect.bisect_right(VS, ea) - 1
    return VF[i][0] if i >= 0 and VF[i][0] <= ea < VF[i][1] else None


PUR = {}
for s, e, c, p in F:
    if p:
        PUR[s] = p
for r in rd(os.path.join(ROOT, "ida/out/fnindex/sub-xref.tsv"))[1:]:
    if len(r) > 4 and r[4]:
        PUR[int(r[0], 16)] = r[4]
for i in range(1, 6):
    for r in rd(os.path.join(ROOT, "ida/out/wave2/sub-purpose-%d.tsv" % i))[1:]:
        if len(r) > 5 and r[5]:
            PUR[int(r[0], 16)] = r[5]


def pshort(ea):
    p = PUR.get(ea, "")
    p = p.replace("@%08X | " % ea, "").replace("@%08X " % ea, "")
    return (p[:70] + "..") if len(p) > 72 else p


# ---------------- gap set ----------------
G = rd(os.path.join(RAW, "gap_raw.tsv"))[1:]
gapset = {}
for r in G:
    for a in range(int(r[0], 16), int(r[1], 16)):
        gapset[a] = int(r[0], 16)
PAST = {a: W1 for a in range(W1, TOP)}

# ---------------- reach ----------------
R = {int(r[0], 16): r for r in rd(os.path.join(RAW, "reach.tsv"))[1:]}
cls = {}      # byte -> (class, detail)
for ea, r in R.items():
    if "INVALID" in r[4]:
        continue
    n = int(r[1])
    if r[6] == "tail":
        c = "code-conflict"
    elif r[4] == "T1-vector":
        c = "code-vector"
    elif r[4] == "T2-ptr":
        c = "code-pointer"
    else:
        c = "code-flow"
    for a in range(ea, ea + n):
        if (a in gapset or a in PAST) and a not in cls:
            cls[a] = (c, ea)
# hand decode across the FFEE0000 segment boundary (IDA cannot decode an insn spanning segments)
# FFEDFFFD fb e2 d4 cd 01 00  MOV.L #0x0001CDD4,R14 ; FFEE0003 f8 e6 01  MOV.L #1,[R14]
assert by(0xFFEDFFFD, 9) == "fbe2d4cd0100f8e601"
for a in range(0xFFEDFFFD, 0xFFEE0006):
    cls[a] = ("code-flow", 0xFFEDFFFD)

# ---------------- typed data ----------------
TD = []   # (start, end, type, evidence, counted_in)


def td(s, e, t, ev, where="gap"):
    TD.append((s, e, t, ev, where))
    for a in range(s, e):
        if a in gapset or a in PAST:
            cls[a] = ("data", s)


# .data initialiser images, CC-RX _INITSCT DTBL at FFED8A34..FFED8A58 (3 x {src,end,dst})
dt = [struct.unpack_from("<III", img, 0xFFED8A34 - B + 12 * i) for i in range(3)]
assert dt == [(0xFFED9764, 0xFFEDAB4C, 0x68514), (0xFFED8FFC, 0xFFED9762, 0x12570), (0xFFED8E70, 0xFFED8FFB, 0x1217E)], dt
for s, e, d in sorted(dt):
    td(s, e, "dinit-image", "DTBL entry {src %08X,end %08X,dst %08X}; DTBL bounds loaded at FFF45DE0 'fb42 348aedff' / FFF45DE6 'fb52 588aedff'; first bytes %s" % (s, e, d, by(s, 8)))
td(0xFFED8FFB, 0xFFED8FFC, "align-pad", "1 B between DTBL src ranges, byte %s" % by(0xFFED8FFB, 1))
td(0xFFED9762, 0xFFED9764, "align-pad", "2 B between DTBL src ranges, bytes %s" % by(0xFFED9762, 2))
# switch tables (resolved by h8_switch.py)
SWT = []
for r in rd(os.path.join(RAW, "switches.tsv"))[1:]:
    site, tbl, esz, n = int(r[0], 16), int(r[1], 16), int(r[2]), int(r[3])
    SWT.append((tbl, tbl + esz * n, site, esz, n, int(r[4]), r[5]))
for s, e, site, esz, n, idan, note in sorted(SWT):
    ingap = sum(1 for a in range(s, e) if a in gapset or a in PAST)
    where = "past" if s >= W1 else "gap" if ingap == e - s else ("past" if s >= W1 else ("published-data" if ingap == 0 else "split"))
    if where == "split":
        # first bytes in gap, rest inside the published string-pool region
        td(s, min(e, W1 if s >= W1 else 0xFFF48000), "switch-table", "bra.l site %08X, %d x %d-byte rel entries, bound %s, IDA entries %d; bytes %s" % (site, n, esz, note, idan, by(s, 8)), "gap(part)")
        TD.append((0xFFF48000, e, "switch-table", "continuation of table %08X inside published string-pool region (already counted there)" % s, "published-data"))
    else:
        if where in ("gap", "past"):
            td(s, e, "switch-table", "bra.l site %08X, %d x %d-byte rel entries, bound %s, IDA entries %d; bytes %s" % (site, n, esz, note, idan, by(s, 8)), where)
        else:
            TD.append((s, e, "switch-table", "bra.l site %08X, %d x %d-byte rel entries, bound %s; inside published string-pool region (subtype only, already counted)" % (site, n, esz, note), "published-data"))
# past-window data
assert by(0xFFF508F5, 3) == "ffffff"
td(0xFFF508F5, 0xFFF508F8, "pad-FF", "ff ff ff after last insn of sub_FFF4FABD tail", "past")
zz = list(img[0xFFF508F8 - B:0xFFF50938 - B])
assert sorted(zz) == list(range(64)) and zz[:10] == [0, 1, 8, 16, 9, 2, 3, 10, 17, 24]
td(0xFFF508F8, 0xFFF50938, "jpeg-zigzag-u8[64]", "permutation of 0..63 = JPEG de-zigzag order, bytes %s..; imm refs at FFF4B967, FFF4C533, FFF4F500" % by(0xFFF508F8, 12), "past")
ic = struct.unpack_from("<7I", img, 0xFFF50938 - B)
assert ic == (0x2D41, 0x2C63, 0x29CF, 0x25A1, 0x1924, 0x1151, 0x08D4), ic
td(0xFFF50938, 0xFFF50954, "idct-const-u32[7]", "11585,11363,10703,9633,6436,4433,2260 = round(2^14*cos(pi/4)*cos(k*pi/16)) for k=0,1,2,3,5,6,7 (IDCT cosines); bytes %s" % by(0xFFF50938, 8), "past")
assert by(0xFFF50954, 12) == "01" * 12
td(0xFFF50954, 0xFFF50960, "const-u8[12]", "12 x 0x01, imm refs FFF4FAD1/FFF4FADA/FFF4FAE3/FFF4FAFD point at +0/+3/+6/+9", "past")

# ---------------- remaining residual bytes ----------------
GI = {int(r[0], 16): r for r in G}
for a in list(gapset) + list(PAST):
    if a not in cls:
        cls[a] = ("unref", None)

# classify residual runs: IDA-code (function-shaped) vs other
def runs_of(keys, lo, hi):
    out = []; a = lo
    while a < hi:
        if a not in keys:
            a += 1; continue
        c = keys[a][0]; b = a
        while b < hi and b in keys and keys[b][0] == c:
            b += 1
        out.append((a, b, c)); a = b
    return out


rows = []
for r in G + [[("%08X" % W1), ("%08X" % TOP)] + [""] * 14]:
    lo, hi = int(r[0], 16), int(r[1], 16)
    region = "past" if lo >= W1 else "window"
    for a, b, c in runs_of(cls, lo, hi):
        det = ""
        if c == "unref":
            bs = img[a - B:b - B]
            if all(x == 0 for x in bs):
                c = "pad-00"
            elif all(x == 0xFF for x in bs):
                c = "pad-FF"
            elif bs[:2] == b"\x71\x00" or bs[:1] in (b"\x7e", b"\x6e"):
                c = "code-unref-fn"
                det = "frame prologue %s, no LE32/imm24/bsr/bra/switch reference found" % by(a, 3)
            else:
                nxt = vfunc(b)
                c = "code-unref-frag"
                det = ("head sliver falling into validated %08X" % nxt) if nxt == b else "fragment"
        else:
            src = cls[a][1]
            if c in ("code-flow", "code-pointer", "code-vector", "code-conflict"):
                rr = R.get(src)
                det = ("entry %08X via %s from %s" % (src, rr[3], rr[2])) if rr else "hand-decoded across segment boundary FFEE0000"
            elif c == "data":
                det = next((t for s, e, t, ev, w in TD if s <= a < e), "")
        rows.append((a, b, b - a, region, lo, c, det, by(a, min(8, b - a))))

with open(os.path.join(OUT, "gap-runs.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("start\tend\tlen\tregion\tparent_run\tclass\tdetail\tfirst_bytes\n")
    for a, b, n, reg, lo, c, det, bb in rows:
        h.write("%08X\t%08X\t%d\t%s\t%08X\t%s\t%s\t%s\n" % (a, b, n, reg, lo, c, det, bb))

# ---------------- functions (units) ----------------
UI = {(r[0], r[1], r[2]): r for r in rd(os.path.join(RAW, "unit_info.tsv"))[1:]}
UN = rd(os.path.join(RAW, "units.tsv"))
fn = []
for kind, owner, how, heads in UN:
    hs = [int(x, 16) for x in heads.split(",") if x]
    nb_w = nb_p = 0
    for ea in hs:
        for a in range(ea, ea + int(R[ea][1])):
            if cls.get(a, ("",))[0] in ("code-flow", "code-pointer", "code-vector") and cls[a][1] == ea:
                if a >= W1:
                    nb_p += 1
                else:
                    nb_w += 1
    info = UI.get((kind, owner, how))
    o = int(owner, 16)
    first = hs[0]
    rr = R[first]
    callees = [int(x, 16) for x in info[6].split(",") if x] if info else []
    ram = info[9] if info else ""
    wimm = [x for x in (info[7].split(",") if info else []) if x and W0 - 0x300000 <= int(x, 16) < TOP]
    cal = "; ".join("%08X%s" % (c, (" [" + pshort(c)[:40] + "]") if pshort(c) else "") for c in callees[:3])
    if kind == "EXT":
        pur = "continuation of sub_%08X (entered by %s from %s): %s" % (o, rr[3], rr[2], pshort(o) or "no prior purpose")
    elif how == "vector":
        b2 = by(o, 2)
        pur = "interrupt entry %s: %s" % (("from EXTB/INTB " + rr[3]) if rr[3] != "flow" else ("fall-through from adjacent stub " + rr[2]), {"7f95": "RTE do-nothing stub", "7f96": "WAIT trap stub"}.get(b2, "handler " + b2))
    else:
        site = rr[2]
        stub = by(o, 5)
        if stub.startswith("661139"):
            pat = "screen-state hook: r1=1, bsr.w handler, set per-screen sub-state RAM 0x8C4C"
        elif stub.startswith("7100") and info and int(info[3]) == 1:
            pat = "frame-alloc entry sliver (add #-n,sp) falling into the validated body"
        elif stub.startswith("02"):
            pat = "null callback (bare RTS)"
        elif stub.startswith("7f95") or stub.startswith("7f96"):
            pat = "RTE/WAIT stub"
        else:
            pat = "routine (%s insns in gap, last %s)" % (info[3] if info else "?", info[5] if info else "?")
        via = ("pointer %s (%s)" % (site, rr[3])) if how == "pointer" else ("call from %s" % site)
        pur = "%s; via %s%s%s%s" % (pat, via, ("; calls " + cal) if cal else "", ("; RAM " + ram) if ram else "", ("; refs " + ",".join(wimm[:3])) if wimm else "")
    fn.append((first, o, kind, how, len(hs), nb_w, nb_p, pur))

with open(os.path.join(OUT, "new-functions.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("first_head\towner_or_entry\tkind\treached_by\theads\tbytes_window\tbytes_past\tpurpose\n")
    for r in sorted(fn):
        h.write("%08X\t%08X\t%s\t%s\t%d\t%d\t%d\t%s\n" % r)

with open(os.path.join(OUT, "typed-data.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("start\tend\tlen\ttype\tcounted_in\tevidence\n")
    for s, e, t, ev, w in sorted(TD):
        h.write("%08X\t%08X\t%d\t%s\t%s\t%s\n" % (s, e, e - s, t, w, ev))

# ---------------- counts ----------------
cw = collections.Counter(); cp = collections.Counter()
for a, b, n, reg, lo, c, det, bb in rows:
    (cp if reg == "past" else cw)[c] += n
fw = collections.Counter(); fp = collections.Counter()
for first, o, kind, how, nh, nw, npst, pur in fn:
    fw[(kind, how)] += nw; fp[(kind, how)] += npst
with open(os.path.join(OUT, "counts.txt"), "w", encoding="utf-8", newline="\n") as h:
    h.write("gap bytes (window) %d in %d runs\n" % (sum(cw.values()), len(G)))
    for k, v in sorted(cw.items(), key=lambda kv: -kv[1]):
        h.write("  window %-16s %6d\n" % (k, v))
    h.write("past-window FFF50000-FFF509DE %d\n" % sum(cp.values()))
    for k, v in sorted(cp.items(), key=lambda kv: -kv[1]):
        h.write("  past   %-16s %6d\n" % (k, v))
    h.write("unit bytes (window): %s\n" % dict(fw))
    h.write("unit bytes (past): %s\n" % dict(fp))
    h.write("units: %s\n" % collections.Counter((f[2], f[3]) for f in fn))
print(open(os.path.join(OUT, "counts.txt"), encoding="utf-8").read())

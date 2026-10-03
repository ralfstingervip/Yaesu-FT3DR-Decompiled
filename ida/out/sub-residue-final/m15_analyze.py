r"""Lane M15 -- SUB window residue re-proof (Task 1) and window recount (Task 2).  Read-only.

Inputs : decrypted\FT3D_SUB_ver102_ALL.bin ; ida\out\sub-final3\raw\mask_final3_after_*.bin (published K7 masks);
         raw\*.tsv exported from the private DB M15_SUB_RESIDUE (copy of K7_SUB_FINAL3) by ida\jobs\m15_residue.py.
Outputs: runs.tsv, edges-scan.tsv, counts.tsv, typed-by-type.tsv, raw\analyze_log.txt
"""
# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import os, re, struct, hashlib, bisect, collections

R = str(_REPO)
OUT = os.path.join(R, "ida/out/sub-residue-final")
RAW = os.path.join(OUT, "raw")
BASE = 0xFFC00000
WLO, WHI = 0xFFED0000, 0xFFF50000
img = open(os.path.join(R, _no_image()), "rb").read()
assert hashlib.sha256(img).hexdigest().startswith("b93570b3c2f69ccb")
LOG = open(os.path.join(RAW, "analyze_log.txt"), "w", encoding="utf-8", newline="\n")


def log(*a):
    s = " ".join(str(x) for x in a)
    print(s); LOG.write(s + "\n")


def rd(p):
    L = open(p, encoding="utf-8").read().splitlines()
    hd = L[0].split("\t")
    return [dict(zip(hd, l.split("\t"))) for l in L[1:]]


def mask(n):
    m = open(os.path.join(R, "ida/out/sub-final3/raw/mask_final3_after_%s.bin" % n), "rb").read()
    assert len(m) == WHI - WLO
    return m


H, HW, A, RE, RW = (mask(n) for n in ("headline", "headline_w2", "allwf", "reach", "reach_w2"))
inm = lambda m, ea: WLO <= ea < WHI and m[ea - WLO] == 1
res = set(WLO + i for i in range(WHI - WLO) if A[i] and not HW[i])
runs = []
for x in sorted(res):
    if runs and runs[-1][1] == x:
        runs[-1][1] = x + 1
    else:
        runs.append([x, x + 1])
runof = {}
for s, e in runs:
    for x in range(s, e):
        runof[x] = s
log("residue bytes", len(res), "runs", len(runs))

# ---------- DB exports
CH = {}
for r in rd(os.path.join(RAW, "codeheads.tsv")):
    CH[int(r["ea"], 16)] = (int(r["size"]), int(r["feature"], 16), r["mnem"], r["bytes"], r["disasm"])
chk = sorted(CH)
bad = [ea for ea, v in CH.items() if bytes.fromhex(v[3]) != img[ea - BASE:ea - BASE + v[0]]]
log("code heads", len(CH), "byte mismatches vs image", len(bad))


def cls(ea):
    """reach class of a byte."""
    if not (WLO <= ea < WHI):
        return "outside-window"
    if RW[ea - WLO]:
        return "reached"
    if HW[ea - WLO]:
        return "credited-unreached"
    if A[ea - WLO]:
        return "residue"
    return "typed-data"


RH = collections.defaultdict(list)
for r in rd(os.path.join(RAW, "runs-heads.tsv")):
    RH[int(r["run_start"], 16)].append(r)
FU = {int(r["run_start"], 16): r for r in rd(os.path.join(RAW, "funcs.tsv"))}

# ---------- independent relative-branch decode
def s8(v): return v - 256 if v >= 128 else v
def s16(v): return v - 65536 if v >= 32768 else v
def s24(v): return v - (1 << 24) if v >= (1 << 23) else v


def branch(ea):
    """decode a relative branch at ea from the image bytes; returns (kind, target) or None."""
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


# (1) every DB code head: branch target in residue from outside its run
edges = []  # (target_run, kind, site, target, site_class, note)
nbr = 0
for ea in chk:
    b = branch(ea)
    if not b:
        continue
    nbr += 1
    k, t = b
    if t in runof and runof.get(ea) != runof[t]:
        edges.append((runof[t], k, ea, t, cls(ea), "code-head branch"))
log("DB code heads decoding as relative branches", nbr, "; into residue from outside the run", len(edges))
# IDA cross-check: disasm of a branch head must name the same target
mism = 0
for ea in chk:
    b = branch(ea)
    v = CH[ea]
    if b and v[2].startswith("b") and not v[2].startswith(("bset", "bclr", "bnot", "btst", "bmc", "bm", "brk")):
        m = re.search(r"(?:loc|sub|dead|nullsub|j_sub)_([0-9A-F]{8})", v[4])
        if m and int(m.group(1), 16) != b[1]:
            mism += 1
log("branch heads whose IDA target != byte-decoded target", mism)

# (2) every byte offset: long-form branch candidates (.a 24-bit, .w 16-bit) into residue
raw_long = collections.Counter(); raw_long_head = 0; raw_long_rows = []
for o in range(len(img) - 3):
    b0 = img[o]
    if b0 not in (0x04, 0x05, 0x38, 0x39, 0x3A, 0x3B):
        continue
    ea = BASE + o
    k, t = branch(ea)
    if t in runof and runof.get(ea) != runof[t]:
        raw_long[k] += 1
        head = ea in CH
        raw_long_head += head
        raw_long_rows.append((ea, k, t, head))
log("every-offset long-branch byte patterns into residue:", dict(raw_long), "at a DB code head:", raw_long_head)

# (3) every byte offset: 3-byte LE value equal to a residue address (covers LE32 pointers at any alignment and
#     the RX sign-extended imm24 MOV.L/other #imm forms, and imm32)
ptr_hits = []
rs = set(res)
for o in range(len(img) - 2):
    if img[o + 2] < 0xED or img[o + 2] > 0xF4:
        continue
    v = 0xFF000000 | img[o] | img[o + 1] << 8 | img[o + 2] << 16
    if v in rs:
        ptr_hits.append((BASE + o, v))
log("every-offset 3-byte LE hits on a residue byte", len(ptr_hits))
# classify hits
DI = {}
for r in rd(os.path.join(RAW, "dataitems.tsv")):
    DI[int(r["ea"], 16)] = (int(r["size"]), r["kind"])
dik = sorted(DI)


def owner_head(ea):
    i = bisect.bisect_right(chk, ea) - 1
    if i >= 0 and chk[i] <= ea < chk[i] + CH[chk[i]][0]:
        return chk[i]
    return None


def owner_data(ea):
    i = bisect.bisect_right(dik, ea) - 1
    if i >= 0 and dik[i] <= ea < dik[i] + DI[dik[i]][0]:
        return dik[i]
    return None


OPS = rd(os.path.join(RAW, "operands.tsv"))
opsites = collections.defaultdict(set)
for r in OPS:
    opsites[int(r["site"], 16)].add(int(r["value"], 16))
ptr_rows = []
for site, v in ptr_hits:
    h = owner_head(site)
    if h is not None:
        imm_operand = v in opsites.get(h, set())
        b0 = img[h - BASE]
        what = "in code head %08X (%s)%s" % (h, CH[h][4], " = IDA operand value" if imm_operand else " ; not an operand value (bytes straddle opcode/other fields)")
        kind = "code-operand" if imm_operand else "code-bytes"
    else:
        d = owner_data(site)
        if d is not None:
            kind = "data:" + DI[d][1]
            what = "in window data item %08X size %d (%s), 4th byte %02X, align %d" % (d, DI[d][0], DI[d][1], img[site - BASE + 3] if site - BASE + 3 < len(img) else 0, site % 4)
        else:
            kind = "image-outside-window"
            what = "outside window (no DB head exported), 4th byte %02X, align %d" % (img[site - BASE + 3] if site - BASE + 3 < len(img) else 0, site % 4)
    ptr_rows.append((site, v, runof[v], kind, what))
log("3-byte hit kinds", collections.Counter(r[3] for r in ptr_rows))

# (4) vectors
intb_ld = img[0x17:0x1D].hex(); extb_ld = img[0x0E:0x14].hex()
log("INTB load FFC00017", intb_ld, "mvtc FFC0001D", img[0x1D:0x20].hex(), "; EXTB load FFC0000E", extb_ld, "mvtc FFC00014", img[0x14:0x17].hex())
INTB, EXTB = 0xFFED8A70, 0xFFFFFF80
assert intb_ld == "fbe2708aedff" and extb_ld == "fbe280ffffff"
vec = [("INTB", i, struct.unpack_from("<I", img, INTB - BASE + 4 * i)[0]) for i in range(256)]
vec += [("EXTB", i, struct.unpack_from("<I", img, EXTB - BASE + 4 * i)[0]) for i in range(32)]
vhit = [(t, i, v) for t, i, v in vec if v in rs]
log("vector slots 288, distinct targets", len(set(v for _, _, v in vec)), "; slots into residue", len(vhit))
# every other way INTB/EXTB could be set: FD 68 xC/xD (mvtc Rs), FD 73/77/7B/7F 0C/0D (mvtc #imm)
alt = []
for o in range(len(img) - 3):
    if img[o] == 0xFD and ((img[o + 1] == 0x68 and (img[o + 2] & 0xF) in (0xC, 0xD)) or
                           (img[o + 1] in (0x73, 0x77, 0x7B, 0x7F) and img[o + 2] in (0x0C, 0x0D))):
        alt.append(BASE + o)
alt_heads = [a for a in alt if a in CH]
log("mvtc-to-INTB/EXTB byte patterns anywhere", len(alt), "; at DB code heads", ["%08X %s" % (a, CH[a][4]) for a in alt_heads])

# (5) switches: IDA's 40 + H8's 643 edges
sw_hit = [r for r in rd(os.path.join(RAW, "switches.tsv")) if r["targets_in_residue"]]
h8sw = [l.split() for l in open(os.path.join(R, "ida/out/sub-gap/raw/switch_edges.tsv"), encoding="utf-8")]
h8hit = [x for x in h8sw if int(x[1], 16) in rs]
log("IDA switch heads", len(rd(os.path.join(RAW, "switches.tsv"))), "targets in residue", len(sw_hit), "; H8 switch edges", len(h8sw), "into residue", len(h8hit))
# bra.l Rn heads without IDA switch info
swsites = set(int(r["site"], 16) for r in rd(os.path.join(RAW, "switches.tsv")))
IND = rd(os.path.join(RAW, "indirect.tsv"))
kinds = collections.Counter()
const_t = []
for r in IND:
    d = r["disasm"].split()
    op = d[0].lower(); reg = d[-1].lower()
    kinds[op] += 1
    # find nearest earlier write to reg
    src = "not-found-in-8"
    for p in r["prev8"].split(" <- "):
        q = p.split(None, 1)
        if len(q) < 2:
            continue
        txt = q[1].lower()
        mm = re.match(r"(\S+)\s+(.*)", txt)
        if not mm:
            continue
        ops = [x.strip() for x in mm.group(2).split(",")]
        if ops and ops[-1] == reg and not mm.group(1).startswith(("cmp", "tst", "push", "bsr", "jsr", "b")):
            if mm.group(1).startswith("mov") and ops[0].startswith("#"):
                src = "const " + ops[0]
                m2 = re.match(r"#(-?)([0-9a-f]+)(h?)", ops[0].split()[0].replace("off_", "").replace("sub_", "").replace("unk_", ""))
                if m2:
                    v = int(m2.group(2), 16 if (m2.group(3) or len(m2.group(2)) > 2) else 10)
                    const_t.append((int(r["site"], 16), (-v if m2.group(1) else v) & 0xFFFFFFFF))
            elif "[" in ops[0]:
                src = "memory"
            else:
                src = "reg/arith:" + mm.group(1)
            break
    kinds[op + "|" + src.split()[0]] += 1
log("indirect heads", len(IND), dict(kinds))
log("indirect const sites", [(r["site"], r["disasm"], r["prev8"][:120]) for r in IND if "#" in r["prev8"] and r["disasm"].lower().startswith("jsr")][:0])
log("indirect constant targets", ["%08X->%08X" % c for c in const_t], "in residue:", [c for c in const_t if c[1] in rs])
bral_noswitch = [r["site"] for r in IND if r["disasm"].lower().startswith("bra.l") and int(r["site"], 16) not in swsites]
log("bra.l heads without IDA switch info", bral_noswitch)
# RAM-cell callback census (H10) and w2 pointer entries
ramcb = rd(os.path.join(R, "ida/out/sub-final/raw/h10fix/ram_cb.tsv"))
log("H10 RAM-callback code addresses", len(ramcb), "in residue", sum(1 for r in ramcb if int(r["code_addr"], 16) in rs))
XR = rd(os.path.join(RAW, "xrefs.tsv"))
log("IDA xrefs into residue from outside the run", len(XR))
ext_ops = [r for r in OPS if runof.get(int(r["site"], 16)) != int(r["run_start"], 16)]
log("IDA operands valued inside a residue run, from outside that run", len(ext_ops), [(r["site"], r["value"]) for r in ext_ops])

# ---------- per-run proof
USB = [("USB0", 0xA0000, 0xA0400), ("USBA", 0xD0000, 0xD1000), ("FCU/flash", 0x7E0000, 0x800000), ("SYSTEM-MSTP", 0x80010, 0x80020)]
rows = []
fb_imm_all = []
for s, e in runs:
    hs = RH[s]
    prev = [h for h in hs if h["pos"] == "prev"][0]
    inn = [h for h in hs if h["pos"] == "in"]
    nxt = [h for h in hs if h["pos"] == "next"][0]
    allcode = all(h["is_code"] == "1" for h in inn)
    first_ok = int(inn[0]["ea"], 16) == s
    tiles = all(int(inn[i]["ea"], 16) + int(inn[i]["size"]) == int(inn[i + 1]["ea"], 16) for i in range(len(inn) - 1))
    last = inn[-1]; last_end = int(last["ea"], 16) + int(last["size"])
    inside = last_end == e
    last_stop = bool(int(last["feature"], 16) & 1)
    pe = int(prev["ea"], 16); pend = pe + int(prev["size"])
    prev_code = prev["is_code"] == "1"
    prev_stop = bool(int(prev["feature"], 16) & 1)
    pmn = prev["disasm"].split()[0] if prev["disasm"] else ""
    flow_in = prev_code and pend == s and not prev_stop
    nea = int(nxt["ea"], 16)
    # internal stops
    nstop = sum(1 for h in inn if int(h["feature"], 16) & 1)
    # bytes check
    byt = img[s - BASE:e - BASE]
    # immediates in run (FB mov.l #imm forms decoded from bytes, at code heads)
    pimm = []
    for h in inn:
        ea = int(h["ea"], 16); hb = bytes.fromhex(h["bytes"])
        for mm in re.finditer(r"#([0-9A-F]+)h", h["disasm"]):
            v = int(mm.group(1), 16)
            if 0x80000 <= v < 0x100000 or 0x7E0000 <= v < 0x800000:
                pimm.append("%08X:%X" % (ea, v))
        if len(hb) >= 3 and hb[0] == 0xFB and (hb[1] & 3) == 2:
            li = (hb[1] >> 2) & 3
            n = {0: 4, 1: 1, 2: 2, 3: 3}[li]
            raw = int.from_bytes(hb[2:2 + n], "little")
            if n < 4 and raw >> (8 * n - 1):
                raw -= 1 << (8 * n)
            fb_imm_all.append((ea, raw & 0xFFFFFFFF))
    usb = [nm for nm, lo, hi in USB for (_, v) in fb_imm_all if lo <= v < hi and s <= _ < e]
    # inbound edges for this run
    ein = [x for x in edges if x[0] == s]
    pin = [x for x in ptr_rows if x[2] == s and x[3] in ("code-operand",) and runof.get(owner_head(x[0])) != s]
    vin = [x for x in vhit if runof[x[2]] == s]
    xin = [x for x in XR if int(x["run_start"], 16) == s]
    swin = [x for x in h8hit if runof[int(x[1], 16)] == s]
    live_in = [x for x in ein if x[4] == "reached"]
    if not (allcode and first_ok and tiles):
        klass = "UNCERTAIN"
    elif flow_in and cls(pe) == "reached":
        klass = "REACHED"
    elif live_in or vin or swin or xin or pin:
        klass = "REACHED" if (live_in or vin or swin) else "UNCERTAIN"
    else:
        klass = "DEAD"
    size = e - s
    sub = "fragment" if (s in (0xFFEE177F, 0xFFF3758F, 0xFFF375A4, 0xFFF47E60, 0xFFEF202A, 0xFFF13DDA, 0xFFF3B8CB)) else "dead-function"
    if s == 0xFFF2A6D1:
        sub = "dead-function+split-byte FFF2A7FC"
    term = ("ends at %s %s (stop)" % (last["ea"], last["disasm"].split()[0])) if (inside and last_stop) else \
           ("falls through at run end into %08X [%s] %s" % (nea, cls(nea), nxt["disasm"][:40])) if inside else \
           ("LAST INSN CROSSES RUN END (%08X > %08X)" % (last_end, e))
    flowtxt = ("flow-in from %08X %s [%s]" % (pe, prev["disasm"][:30], cls(pe))) if flow_in else \
              ("no flow-in: prev %08X %s (%s)" % (pe, (prev["disasm"].split() or ["?"])[0], "stop" if prev_stop else ("data" if not prev_code else "ends %08X" % pend)))
    rows.append(dict(start="%08X" % s, end="%08X" % e, bytes=size, file_off="%06X" % (s - BASE), first_bytes=byt[:8].hex(),
                     subclass=sub, insns=len(inn), stops_inside=nstop, decode=("clean: %d heads tile the run" % len(inn)) if (allcode and first_ok and tiles and inside) else "CHECK",
                     terminator=term, entry_flow=flowtxt,
                     inbound=("branch:%d live:%d ptr-operand:%d vector:%d switch:%d idaxref:%d" % (len(ein), len(live_in), len(pin), len(vin), len(swin), len(xin))),
                     owner_now="%s %s" % (FU[s]["name"], FU[s]["func_start"]), periph_imm=",".join(pimm), usb_regs=",".join(usb) or "none",
                     klass=klass))
    for x in ein:
        log("  branch into run %08X: %s at %08X -> %08X site class %s" % (s, x[1], x[2], x[3], x[4]))
    if flow_in:
        log("  flow into run %08X from %08X %s class %s" % (s, pe, prev["disasm"], cls(pe)))

cnt = collections.Counter(r["klass"] for r in rows)
log("classes", dict(cnt), "bytes", {k: sum(r["bytes"] for r in rows if r["klass"] == k) for k in cnt})
log("subclass bytes", {k: sum(r["bytes"] for r in rows if r["subclass"] == k) for k in set(r["subclass"] for r in rows)})
hd = list(rows[0].keys())
with open(os.path.join(OUT, "runs.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("\t".join(hd) + "\n")
    for r in rows:
        h.write("\t".join(str(r[k]) for k in hd) + "\n")
with open(os.path.join(OUT, "edges-scan.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("scan\tsite\tvalue_or_target\trun_start\tkind\tdetail\n")
    for site, v, rs_, kind, what in ptr_rows:
        h.write("3byte-LE\t%08X\t%08X\t%08X\t%s\t%s\n" % (site, v, rs_, kind, what))
    for ea, k, t, head in raw_long_rows:
        h.write("long-branch-bytes\t%08X\t%08X\t%08X\t%s\t%s\n" % (ea, t, runof[t], k, "at DB code head" if head else "not an instruction head (byte coincidence)"))
    for x in edges:
        h.write("code-head-branch\t%08X\t%08X\t%08X\t%s\tsite class %s\n" % (x[2], x[3], x[0], x[1], x[4]))

# ---------- Task 2: window recount
W = WHI - WLO
nH, nHW, nA, nR, nRW = sum(H), sum(HW), sum(A), sum(RE), sum(RW)
typed = set(WLO + i for i in range(W) if not A[i])
codeb = set()
for ea in chk:
    for k in range(CH[ea][0]):
        if WLO <= ea + k < WHI:
            codeb.add(ea + k)
datab = set()
for ea, (sz, k) in DI.items():
    for j in range(sz):
        if k == "unexplored":
            continue
        if WLO <= ea + j < WHI:
            datab.add(ea + j)
log("window", W, "DB code bytes", len(codeb), "DB data bytes", len(datab), "unexplored", W - len(codeb | datab), "code&data", len(codeb & datab))
log("typed (window - allwf)", len(typed), "; typed & DBcode", len(typed & codeb), "; allwf - DBcode", sum(1 for i in range(W) if A[i] and (WLO + i) not in codeb))
# typed by IDA item kind
bykind = collections.Counter()
for x in typed:
    if x in codeb:
        bykind["code twin inside typed pool (FFF4B077-FFF4B084)"] += 1; continue
    d = owner_data(x)
    bykind[DI[d][1] if d is not None else "none"] += 1
# typed by semantic class: I17 window rows > H8 typed-data gap rows > published region
sem = {}
PUB = [(0xFFED0000, 0xFFED3F6C, "RGB565 bitmap descriptor table (doc 16/21)"), (0xFFED3F6C, 0xFFED5800, "UI layout tables (doc 21)"),
       (0xFFED5800, 0xFFED8A70, "zero-heavy low tables (doc 21)"), (0xFFED8A70, 0xFFED8E70, "INTB relocatable vector table 256x4 (doc 02)"),
       (0xFFF48000, 0xFFF4C000, "string pool + switch tables (doc 21/46)")]
for lo, hi, nm in PUB:
    for x in range(lo, hi):
        sem[x] = nm
for r in rd(os.path.join(R, "ida/out/sub-gap/typed-data.tsv")):
    if r["counted_in"].startswith("gap"):
        for x in range(int(r["start"], 16), int(r["end"], 16)):
            sem[x] = "H8 gap: " + r["type"]
for r in rd(os.path.join(R, "ida/out/sub-final2/data-types.tsv")):
    if r["scope"] == "window":
        for x in range(int(r["start"], 16), int(r["end"], 16)):
            sem[x] = "I17: " + re.sub(r"\s*\(.*", "", r["class"])
bysem = collections.Counter(sem.get(x, "UNCLASSED") for x in typed)
with open(os.path.join(OUT, "typed-by-type.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("axis\tclass\tbytes\n")
    for k, v in sorted(bykind.items(), key=lambda kv: -kv[1]):
        h.write("ida_item_kind\t%s\t%d\n" % (k, v))
    for k, v in sorted(bysem.items(), key=lambda kv: -kv[1]):
        h.write("semantic\t%s\t%d\n" % (k, v))
log("typed by IDA kind", dict(bykind))
log("typed semantic classes", len(bysem), "sum", sum(bysem.values()))
nres = len(res)
gap = W - nHW
dead_b = sum(r["bytes"] for r in rows if r["klass"] == "DEAD")
C = [
    ("window", "FFED0000-FFF50000", W, "64 KB-aligned bracket (doc 02): code band FFEDAB4C.. + INTB + string pool; above FFF50000 erased except the 2,526 B JPEG tail FFF50000-FFF509DE"),
    ("window code, headline (H8/H10 + 49 w2 entries)", "mask_final3_after_headline_w2.bin", nHW, "%.4f%%" % (100.0 * nHW / W)),
    ("  of which reach-only proven", "mask_final3_after_reach_w2.bin", nRW, "%.4f%%" % (100.0 * nRW / W)),
    ("  of which credited-unreached", "headline_w2 - reach_w2", nHW - nRW, ""),
    ("headline without w2", "mask_final3_after_headline.bin", nH, ""),
    ("gap = window - window code", "", gap, ""),
    ("  typed data (window - allwf)", "complement of mask_final3_after_allwf.bin", len(typed), "incl. 13 B code twin FFF4B077-FFF4B084 kept typed"),
    ("  residue (allwf - headline_w2)", "runs.tsv", nres, ""),
    ("    DEAD dead functions", "", sum(r["bytes"] for r in rows if r["subclass"] == "dead-function"), ""),
    ("    DEAD dead function FFF2A6D1 incl. split byte FFF2A7FC", "", sum(r["bytes"] for r in rows if r["subclass"].startswith("dead-function+")), "299 + 1"),
    ("    DEAD fragments", "", sum(r["bytes"] for r in rows if r["subclass"] == "fragment"), ""),
    ("  anything else (unexplored / non-typed non-code)", "", gap - len(typed) - nres, ""),
    ("code+typed (headline)", "headline_w2 | typed", nHW + len(typed), "%.4f%%" % (100.0 * (nHW + len(typed)) / W)),
    ("all-well-formed (DB code outside typed)", "mask_final3_after_allwf.bin", nA, "%.4f%%" % (100.0 * nA / W)),
]
with open(os.path.join(OUT, "counts.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("figure\tsource\tbytes\tnote\n")
    for c in C:
        h.write("%s\t%s\t%d\t%s\n" % c)
for c in C:
    log("%-60s %8d  %s" % (c[0], c[2], c[3]))
pass

# ---------- grouped typed classes
GROUP = [("graphics descriptors/records", ("RGB565", "icon/indicator", "1-bpp", "glyph-table", "bitmap-descriptor")),
         ("strings and string slots (incl. string-pool residual with its 37 switch tables)", ("string pool", "string slots", "C strings", "char*", "NUL padding")),
         ("CC-RX .data initializer images", ("dinit-image", "RAM-default image", "RAM-pointer records", "local-array initializer")),
         ("UI layout / zero-heavy low tables (typed by region only)", ("UI layout tables", "zero-heavy")),
         ("INTB relocatable vector table", ("INTB",)),
         ("other const tables (storage driver, menu, runtime, sine/cosine, records, linker list)", ("storage-driver", "setup-menu", "CC-RX runtime", "constant table", "sine", "cosine", "index/value", "record table", "linker", "const bytes")),
         ("switch tables in the H8 gap", ("switch-table",)),
         ("alignment pad", ("align",))]
grp = collections.Counter()
for k, v in bysem.items():
    for g, keys in GROUP:
        if any(x in k for x in keys):
            grp[g] += v; break
    else:
        grp["UNGROUPED " + k] += v
with open(os.path.join(OUT, "typed-by-type.tsv"), "a", encoding="utf-8", newline="\n") as h:
    for k, v in sorted(grp.items(), key=lambda kv: -kv[1]):
        h.write("group\t%s\t%d\n" % (k, v))
log("typed groups", dict(grp), "sum", sum(grp.values()))

# ---------- Task 3: headline under each convention (proposal only)
MAIN_NAMED, MAIN_CONTENT, MAIN_PROVEN = 501656, 505684, 364786
DEN = MAIN_CONTENT + W
opts = [
    ("A now: MAIN named + SUB window code (headline_w2)", nHW),
    ("B SUB window code + DEAD residue typed as code", nHW + dead_b),
    ("C SUB code + typed data (named analogue, residue left out)", nHW + len(typed)),
    ("D SUB code + typed + DEAD residue (I12 convention: dead DB code counts as named)", nHW + len(typed) + dead_b),
]
with open(os.path.join(OUT, "counts.tsv"), "a", encoding="utf-8", newline="\n") as h:
    h.write("\nheadline_option\tSUB_bytes\tSUB_pct_of_524288\tMAIN_named+SUB\tpct_of_%d\n" % DEN)
    for nm, sb in opts:
        h.write("%s\t%d\t%.4f%%\t%d\t%.4f%%\n" % (nm, sb, 100.0 * sb / W, MAIN_NAMED + sb, 100.0 * (MAIN_NAMED + sb) / DEN))
        log("%-85s SUB %d (%.4f%%)  headline %d / %d = %.4f%%" % (nm, sb, 100.0 * sb / W, MAIN_NAMED + sb, DEN, 100.0 * (MAIN_NAMED + sb) / DEN))
    h.write("E strict reach both sides: MAIN proven + SUB reach_w2\t%d\t%.4f%%\t%d\t%.4f%%\n" % (nRW, 100.0 * nRW / W, MAIN_PROVEN + nRW, 100.0 * (MAIN_PROVEN + nRW) / DEN))
    log("E strict reach: SUB %d, MAIN proven + SUB = %d = %.4f%%" % (nRW, MAIN_PROVEN + nRW, 100.0 * (MAIN_PROVEN + nRW) / DEN))
# K7 dead functions (sub-final3\dead.tsv, 125 heads) decomposed by mask
dd = collections.Counter(); seen = set(); rdead = collections.Counter()
for d in rd(os.path.join(R, "ida/out/sub-final3/dead.tsv")):
    for cb in d["chunk_bounds"].split(";"):
        a, b_ = [int(x, 16) for x in cb.split("-")]
        for x in range(a, b_):
            if x in seen:
                continue
            seen.add(x); k = cls(x); dd[k] += 1
            if k == "reached":
                rdead[d["start"]] += 1
log("K7 dead functions by mask", dict(dd), "sum", sum(dd.values()), "; reach_w2 bytes inside dead functions", dict(rdead))
strict = nRW - dd["reached"]
with open(os.path.join(OUT, "counts.tsv"), "a", encoding="utf-8", newline="\n") as h:
    h.write("\nK7 125 dead functions (sub-final3 dead.tsv), bytes by mask\t\t%d\t%s\n" % (sum(dd.values()), ", ".join("%s %d" % kv for kv in sorted(dd.items()))))
    h.write("reach_w2 bytes inside dead functions (stale lane-4 xref roots FFF2570F, FFF38800; I17 ambiguous.tsv)\t\t%d\t%s\n" % (dd["reached"], ", ".join("%s %d" % kv for kv in sorted(rdead.items()))))
    h.write("strict reach (reach_w2 minus those)\t\t%d\t%.4f%%\n" % (strict, 100.0 * strict / W))
    h.write("E2 strict both sides: MAIN proven + SUB strict reach\t%d\t%.4f%%\t%d\t%.4f%%\n" % (strict, 100.0 * strict / W, MAIN_PROVEN + strict, 100.0 * (MAIN_PROVEN + strict) / DEN))
log("strict reach", strict, "MAIN proven + strict", MAIN_PROVEN + strict, "%.4f%%" % (100.0 * (MAIN_PROVEN + strict) / DEN))
with open(os.path.join(OUT, "proposed-typing.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("start\tend\tbytes\tfile_off\tclass\tsubclass\tdb_state_now\tproposed\tevidence\n")
    for r in rows:
        h.write("%s\t%s\t%d\t%s\t%s\t%s\tDB code (%s), outside headline_w2, inside allwf\tcredit as typed code in a SUB named mask (I12 convention); no DB edit; headline_w2 unchanged\t%s; %s; %s\n" % (
            r["start"], r["end"], r["bytes"], r["file_off"], r["klass"], r["subclass"], r["owner_now"], r["decode"], r["terminator"], r["inbound"]))
    h.write("TOTAL\t\t%d\t\t\t\t\tSUB named would be %d + %d + %d = %d / %d\t\n" % (dead_b, nHW, len(typed), dead_b, nHW + len(typed) + dead_b, W))
pass
LOG.close()

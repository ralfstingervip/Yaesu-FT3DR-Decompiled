r"""Lane I2 -- verbatim port of ida\jobs\h10_phase.py (Lane H10) with outputs redirected to
ida\out\sub-final\raw\h10fix\, plus an export of the FIX head set and byte masks that
i2_apply_sub_final.py consumes.  Run once on the UNREPAIRED seed copy (read-only on the DB):

    python ida/run_job.py --script ida\jobs\i2_h10fix.py --db SUB_FINAL --copy-from ida\db\jobs\H10_SUB\H10_SUB.i64
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

ROOT = str(_REPO)
RAW = os.path.join(ROOT, r"ida\out\sub-final\raw\h10fix")
GAP = os.path.join(ROOT, r"ida\out\sub-gap")
STATUS = os.path.join(RAW, "h10_phase_status.txt")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
WIN_LO, WIN_HI = 0xFFED0000, 0xFFF50000
TOP = 0xFFF509DE
INTB = 0xFFED8A70
CF_STOP = 0x1
BSN = chr(10)
BST = chr(9)
DATA = [(0xFFED0000, 0xFFED8E70), (0xFFF48000, 0xFFF4C000)]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_ua, ida_idp, idautils, idc
    ida_auto.auto_wait()
    os.makedirs(RAW, exist_ok=True)
    img = sys.exit("The firmware image is not in this repository.")

    def b(ea, n):
        o = ea - BASE
        return img[o:o + n]

    # ---------------- inputs
    rows = []
    with open(os.path.join(ROOT, r"ida\out\sub-window\functions.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            if p[2] in ("xref", "body"):
                rows.append((int(p[0], 16), int(p[1], 16)))
    rej2 = set()
    for i in range(1, 6):
        with open(os.path.join(ROOT, r"ida\out\wave2\sub-purpose-%d.tsv" % i), encoding="utf-8") as h:
            next(h)
            for ln in h:
                p = ln.rstrip("\n").split("\t")
                if len(p) > 3 and p[3] == "rejected":
                    rej2.add(int(p[0], 16))
    valid = set(); vbytes = set(); owner = {}; rejbytes = {}; rejheads = set()
    for s, e in rows:
        ea = s
        while ea < e:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                sz = max(ida_bytes.get_item_size(ea), 1)
                valid.add(ea); owner[ea] = s
                if s in rej2:
                    rejheads.add(ea)
                for k in range(sz):
                    if ea + k < e and WIN_LO <= ea + k < WIN_HI:
                        if ea + k not in vbytes:
                            vbytes.add(ea + k)
                            if s in rej2:
                                rejbytes[ea + k] = s
                ea += sz
            else:
                ea += 1
    log("valid heads %d vbytes %d rej2 fns %d rej2 bytes %d" % (len(valid), len(vbytes), len(rej2), len(rejbytes)))

    SW = {}; SWB = set()
    with open(os.path.join(GAP, r"raw\switch_edges.tsv"), encoding="utf-8") as h:
        for ln_ in h:
            a_, t_, e_ = ln_.split()
            SW.setdefault(int(a_, 16), []).append(int(t_, 16))
            SWB.add(int(e_, 16)); SWB.add(int(e_, 16) + 1)

    reach8 = {}
    t2roots = []
    with open(os.path.join(GAP, r"raw\reach.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            ea = int(p[0], 16)
            reach8[ea] = (int(p[1]), int(p[2], 16), p[3], p[4])
            if p[4].startswith("T2") and p[3].startswith("ptr"):
                t2roots.append((ea, int(p[2], 16), p[3]))
    conf = []
    with open(os.path.join(GAP, r"raw\conflicts.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            conf.append((int(p[0], 16), int(p[1], 16), p[2]))
    gapruns = []
    with open(os.path.join(GAP, "gap-runs.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            gapruns.append((int(p[0], 16), int(p[1], 16), p[3], p[5], p[6]))
    h8set = set(vbytes)
    for s, e, reg, cls, det in gapruns:
        if reg == "window" and cls in ("code-flow", "code-pointer", "code-vector"):
            h8set.update(range(s, e))
    log("H8 credited set (vbytes U code-flow/pointer/vector runs) = %d" % len(h8set))

    # ---------------- decode helpers
    def dec(ea):
        insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
        return (insn, ln) if ln > 0 else (None, 0)

    def fmt(ea):
        insn, ln = dec(ea)
        if not insn:
            return 1, "%02x" % ida_bytes.get_byte(ea), "<invalid>"
        ops = []
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type == ida_ua.o_reg:
                ops.append(ida_idp.get_reg_name(op.reg, 4))
            elif op.type == ida_ua.o_imm:
                ops.append("#%X" % (op.value & 0xFFFFFFFF))
            elif op.type in (ida_ua.o_near, ida_ua.o_far):
                ops.append("%08X" % op.addr)
            elif op.type == ida_ua.o_mem:
                ops.append("[%X]" % op.addr)
            elif op.type == ida_ua.o_phrase:
                ops.append("[%s]" % ida_idp.get_reg_name(op.reg, 4))
            elif op.type == ida_ua.o_displ:
                ops.append("%X[%s]" % (op.value & 0xFFFFFFFF, ida_idp.get_reg_name(op.reg, 4)))
            else:
                ops.append("t%d" % op.type)
        return ln, b(ea, ln).hex(), insn.get_canon_mnem() + " " + ", ".join(ops)

    def succ(ea, use_xrefs=True):
        insn, ln = dec(ea)
        if not insn:
            return None, 0, ""
        out = []
        mn = insn.get_canon_mnem()
        if not (insn.get_canon_feature() & CF_STOP):
            out.append((ea + ln, "flow"))
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type in (ida_ua.o_near, ida_ua.o_far):
                out.append((op.addr, "call" if mn.startswith("bsr") or mn.startswith("jsr") else "jump"))
        if use_xrefs:
            for t in idautils.CodeRefsFrom(ea, 0):
                out.append((t, "xref"))
        for t in SW.get(ea, ()):
            out.append((t, "switch"))
        return out, ln, mn

    # ---------------- 1. repair spans
    fake = set(); truehead = {}   # ea -> size
    rep = open(os.path.join(RAW, "repairs.tsv"), "w", encoding="utf-8", newline="\n")
    rep.write("target\tsrc\tkind\tanchor\tcover_head\tresync\ttrue_decode\tfake_heads\n")
    # Manual adjudication (see docs/deep/48-sub-phase-orphans.md): edges whose source is itself an
    # out-of-phase IDA item; the sub_FFEEC0D3 case block is decoded as one linear run of
    # bsr/bra pairs from its first case FFEEC133 to FFEEC18A.
    SPUR = {(0xFFEDB0B7, 0xFFEDB0AE), (0xFFEDB0B7, 0xFFEDB0AF), (0xFFF40C9F, 0xFFEEC171),
            (0xFFEF1B70, 0xFFEF1B67), (0xFFEEC160, 0xFFEEC157)}
    BLK_LO, BLK_HI = 0xFFEEC133, 0xFFEEC18A
    anchors = []
    for T, src, kind in conf:
        anchors.append((T, src, kind, src if kind == "flow" else T))
    for s_, e_, reg_, cls_, det_ in gapruns:
        if cls_ == "code-conflict":
            # detail: "entry X via flow from Y"
            w = det_.split()
            anchors.append((int(w[1], 16), int(w[-1], 16), "gap-conflict", int(w[-1], 16)))
    # FFEF1B5B `0a` (bra.s FFEF1B65) is the tail of the true `b0 0a` at FFEF1B5A
    anchors.append((0xFFEF1B5B, 0xFFEF1B5A, "manual", 0xFFEF1B5A))
    SPUR.add((0xFFEF1B65, 0xFFEF1B5B))
    spans = []
    spurious = set()
    blk = []
    cur = BLK_LO
    while cur < BLK_HI:
        ln, bb, txt = fmt(cur); blk.append((cur, ln, bb, txt)); cur += ln
    for T, src, kind, A in anchors:
        H = ida_bytes.get_item_head(T)
        if (T, src) in SPUR:
            spurious.add((T, src, kind)); spans.append((T, src, kind, A, H, H, H, [])); continue
        if BLK_LO <= T < BLK_HI:
            spans.append((T, src, kind, BLK_LO, H, BLK_LO, BLK_HI, blk)); continue
        cur = A; heads = []
        for _ in range(40):
            ln, bb, txt = fmt(cur)
            heads.append((cur, ln, bb, txt))
            cur += ln
            if cur > T and cur in valid:
                break
            insn, l2 = dec(cur - ln)
            if insn is not None and (insn.get_canon_feature() & CF_STOP) and cur > T:
                break
        lo = min(H, A)
        spans.append((T, src, kind, A, H, lo, cur, heads))
    for T, src, kind, A, H, lo, hi, heads in spans:
        sp = (T, src, kind) in spurious
        fh = []
        if not sp:
            tb = set()
            for ea, ln, bb, txt in heads:
                truehead[ea] = ln; tb.add(ea)
            ea = lo
            while ea < hi:
                if ea in valid and ea not in tb:
                    fh.append(ea)
                ea += 1
            fake.update(fh)
        rep.write("%08X\t%08X\t%s\t%s\t%08X\t%08X\t%s\t%s\n" % (
            T, src, kind, ("SPURIOUS(src out of phase)" if sp else "%08X" % A), H, hi,
            " | ".join("%08X %s %s" % (ea, bb, txt) for ea, ln, bb, txt in heads) if not sp else "",
            ",".join("%08X" % x for x in fh)))
    rep.close()
    # fake heads that are also true heads (coincident boundaries) are not fake
    fake -= set(truehead)
    log("repair: true heads %d, fake heads %d, spurious edges %d" % (len(truehead), len(fake), len(spurious)))

    # ---------------- 2. closure (BASE and FIX)
    def closure(roots_valid, extra_true, skip_xref_from, credited_fixed):
        reached = {}; work = []; confl = []

        def push(t, src, kind, tier):
            if t in roots_valid or t in reached or t in extra_true:
                return
            if t in credited_fixed:
                confl.append((t, src, kind, tier)); return
            if not (WIN_LO <= t < TOP):
                return
            work.append((t, src, kind, tier))

        def drain():
            while work:
                t, src, kind, tier = work.pop()
                if t in roots_valid or t in reached or t in extra_true:
                    continue
                out, ln, mn = succ(t)
                if out is None:
                    reached[t] = (0, src, kind, tier + "-INVALID"); continue
                reached[t] = (ln, src, kind, tier)
                for t2, k in out:
                    push(t2, t, k, tier)
        for ea in sorted(roots_valid | set(extra_true)):
            out, ln, mn = succ(ea, use_xrefs=(ea not in skip_xref_from))
            if out is None:
                continue
            for t, k in out:
                push(t, ea, k, "T1-flow")
        for i in range(256):
            t = struct.unpack_from("<I", img, INTB - BASE + 4 * i)[0]
            push(t, INTB + 4 * i, "intb%d" % i, "T1-vector")
        for i in range(32):
            a = 0xFFFFFF80 + 4 * i
            push(struct.unpack_from("<I", img, a - BASE)[0], a, "extb%d" % i, "T1-vector")
        drain()
        for ea, site, k in t2roots:
            push(ea, site, k, "T2-ptr")
        drain()
        return reached, confl

    def credited(validbytes, reached):
        s = set(validbytes)
        for ea, (ln, src, kind, tier) in reached.items():
            if tier.endswith("INVALID"):
                continue
            for k in range(ln):
                if WIN_LO <= ea + k < WIN_HI:
                    s.add(ea + k)
        return s

    rB, cB = closure(valid, {}, set(), vbytes)
    setB = credited(vbytes, rB)
    log("BASE: reached heads %d, conflicts %d, credited %d" % (len(rB), len(cB), len(setB)))

    valid_fix = (valid - fake) - rejheads
    vbytes_fix = set(x for x in vbytes if x not in rejbytes)
    # bytes of fake heads stay credited only if a true head covers them (handled via truehead sizes)
    tb_bytes = set()
    for ea, ln in truehead.items():
        for k in range(ln):
            if WIN_LO <= ea + k < WIN_HI:
                tb_bytes.add(ea + k)
    fake_bytes = set()
    for ea in fake:
        for k in range(max(ida_bytes.get_item_size(ea), 1)):
            fake_bytes.add(ea + k)
    # a validated byte belonging only to fake heads (not covered by a true head) leaves vbytes_fix
    vbytes_fix -= (fake_bytes - tb_bytes)
    rF, cF = closure(valid_fix, truehead, fake, vbytes_fix | tb_bytes)
    setF = credited(vbytes_fix | tb_bytes, rF)
    log("FIX: reached heads %d, conflicts %d, credited %d" % (len(rF), len(cF), len(setF)))

    with open(os.path.join(RAW, "closure_cmp.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("H8 credited set (vbytes U H8 code-flow/pointer/vector gap runs)\t%d\n" % len(h8set))
        h.write("BASE closure credited (same rules, recomputed)\t%d\n" % len(setB))
        h.write("BASE - H8\t%d\nH8 - BASE\t%d\n" % (len(setB - h8set), len(h8set - setB)))
        h.write("FIX credited\t%d\n" % len(setF))
        h.write("FIX - BASE (new bytes)\t%d\n" % len(setF - setB))
        h.write("BASE - FIX (lost bytes)\t%d\n" % len(setB - setF))
        h.write("rej2 bytes\t%d ; of which re-reached in FIX\t%d\n" % (len(rejbytes), sum(1 for x in rejbytes if x in setF)))
        h.write("fake heads\t%d ; fake-only bytes\t%d\n" % (len(fake), len(fake_bytes - tb_bytes)))
        h.write("true heads\t%d ; true bytes\t%d ; true bytes not in BASE\t%d\n" % (len(truehead), len(tb_bytes), len(tb_bytes - setB)))
        h.write("FIX conflicts\t%d\n" % len(cF))
        ids = set(x for x in setB - h8set)
        h.write("BASE-H8 sample\t%s\n" % ",".join("%08X" % x for x in sorted(ids)[:40]))
        ids = set(x for x in h8set - setB)
        h.write("H8-BASE sample\t%s\n" % ",".join("%08X" % x for x in sorted(ids)[:40]))

    def dump_heads(path, rset, other_set, rmap):
        with open(path, "w", encoding="utf-8", newline="\n") as h:
            h.write("ea\tsize\tsrc\tkind\ttier\tnew_bytes\tbytes\tinsn\n")
            for ea in sorted(rmap):
                ln, src, kind, tier = rmap[ea]
                nb = sum(1 for k in range(ln) if (ea + k) in rset and (ea + k) not in other_set)
                if nb:
                    l2, bb, txt = fmt(ea)
                    h.write("%08X\t%d\t%08X\t%s\t%s\t%d\t%s\t%s\n" % (ea, ln, src, kind, tier, nb, bb, txt))
    trmap = {ea: (ln, 0, "repair", "R") for ea, ln in truehead.items()}
    dump_heads(os.path.join(RAW, "fix_new.tsv"), setF, setB, dict(list(rF.items()) + list(trmap.items())))
    vmap = {}
    for ea in valid:
        vmap[ea] = (max(ida_bytes.get_item_size(ea), 1), owner[ea], "validated", "V")
    dump_heads(os.path.join(RAW, "fix_lost.tsv"), setB, setF, dict(list(vmap.items()) + list(rB.items())))
    with open(os.path.join(RAW, "fix_conflicts.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("target\tsrc\tkind\ttier\tcover_head\n")
        for t, src, kind, tier in sorted(set(cF)):
            h.write("%08X\t%08X\t%s\t%s\t%08X\n" % (t, src, kind, tier, ida_bytes.get_item_head(t)))
    with open(os.path.join(RAW, "rej2.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("fn\tbytes_in_window\trereached_in_FIX\tfirst_bytes\n")
        agg = {}
        for x, s in rejbytes.items():
            a = agg.setdefault(s, [0, 0]); a[0] += 1; a[1] += (x in setF)
        for s in sorted(agg):
            h.write("%08X\t%d\t%d\t%s\n" % (s, agg[s][0], agg[s][1], b(s, 8).hex()))

    # ---------------- 3. orphans
    with open(os.path.join(RAW, "orphan_probe.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tlen\tbytes_in_FIX\treached_by\tn_insn\tstop\tdecode_end\tcallees\tram_imm\twin_imm\tfirst16\n")
        for s, e, reg, cls, det in gapruns:
            if cls not in ("code-unref-fn", "code-unref-frag", "code-conflict"):
                continue
            inF = sum(1 for x in range(s, e) if x in setF)
            how = ""
            if s in rF:
                ln, src, kind, tier = rF[s]; how = "%s from %08X (%s)" % (kind, src, tier)
            elif s in truehead:
                how = "repair decode"
            cur = s; n = 0; stop = ""; callees = []; ram = []; win = []
            while cur < s + 0x1000:
                insn, ln = dec(cur)
                if not insn:
                    stop = "invalid"; break
                n += 1
                mn = insn.get_canon_mnem()
                for op in insn.ops:
                    if op.type == 0:
                        break
                    if op.type in (ida_ua.o_near, ida_ua.o_far) and (mn.startswith("bsr") or mn.startswith("jsr")):
                        callees.append("%08X" % op.addr)
                    if op.type == ida_ua.o_imm:
                        v = op.value & 0xFFFFFFFF
                        if v < 0x80000 and v > 0xFF:
                            ram.append("%X" % v)
                        elif 0xFFC00000 <= v:
                            win.append("%08X" % v)
                cur += ln
                if insn.get_canon_feature() & CF_STOP:
                    stop = mn; break
            h.write("%08X\t%08X\t%d\t%d\t%s\t%d\t%s\t%08X\t%s\t%s\t%s\t%s\n" % (
                s, e, e - s, inF, how, n, stop, cur, ",".join(callees), ",".join(sorted(set(ram))),
                ",".join(sorted(set(win))), b(s, 16).hex()))

    # ---------------- 4. indirect transfers and RAM code-pointer stores in credited code
    heads_cred = sorted(set([ea for ea in valid_fix]) | set(truehead) | set(ea for ea, v in rF.items() if not v[3].endswith("INVALID")))
    hset = set(heads_cred)
    ind = open(os.path.join(RAW, "indirect.tsv"), "w", encoding="utf-8", newline="\n")
    ind.write("site\tbytes\tinsn\treg\tbacktrack\n")
    cb = open(os.path.join(RAW, "ram_cb.tsv"), "w", encoding="utf-8", newline="\n")
    cb.write("site\tbytes\tinsn\tcode_addr\tstore_site\tstore_insn\n")
    prevs = {}
    last = None
    for ea in heads_cred:
        if last is not None:
            prevs[ea] = last
        last = ea
    nind = ncb = 0
    for ea in heads_cred:
        bb = b(ea, 2)
        if len(bb) == 2 and bb[0] == 0x7F and (bb[1] >> 4) in (0, 1, 4, 5):
            r = bb[1] & 15
            kind = {0: "jmp", 1: "jsr", 4: "bra.l", 5: "bsr.l"}[bb[1] >> 4]
            bt = []; cur = ea
            for _ in range(10):
                cur = prevs.get(cur)
                if cur is None:
                    break
                ln, b2, txt = fmt(cur)
                bt.append("%08X %s" % (cur, txt))
                if (" r%d" % r) in txt.split(",")[-1] or txt.endswith("r%d" % r):
                    if txt.split(",")[-1].strip() == "r%d" % r:
                        break
            ind.write("%08X\t%s\t%s r%d\tr%d\t%s\n" % (ea, bb.hex(), kind, r, r, " <- ".join(bt)))
            nind += 1
        insn, ln = dec(ea)
        if not insn:
            continue
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type == ida_ua.o_imm:
                v = op.value & 0xFFFFFFFF
                if WIN_LO - 0x300000 <= v < TOP and v >= 0xFFC00000:
                    # where does it go
                    mn = insn.get_canon_mnem()
                    dst = insn.ops[1] if insn.ops[1].type != 0 else None
                    st = ""
                    if dst is not None and dst.type in (ida_ua.o_displ, ida_ua.o_phrase, ida_ua.o_mem):
                        st = "%08X\t%s" % (ea, fmt(ea)[2])
                    elif dst is not None and dst.type == ida_ua.o_reg:
                        rr = ida_idp.get_reg_name(dst.reg, 4)
                        cur = ea
                        for _ in range(6):
                            nx = cur + max(dec(cur)[1], 1)
                            if nx not in hset:
                                break
                            cur = nx
                            l3, b3, t3 = fmt(cur)
                            if t3.startswith("mov ") and t3.split(" ", 1)[1].split(",")[0].strip() == rr and "[" in t3.split(",", 1)[1]:
                                st = "%08X\t%s" % (cur, t3); break
                            if t3.split(",")[-1].strip() == rr or t3.startswith("bsr") or t3.startswith("jsr") or t3.startswith("rts"):
                                if t3.startswith("bsr") or t3.startswith("jsr"):
                                    st = "%08X\tARG to %s" % (cur, t3)
                                break
                    if st:
                        cb.write("%08X\t%s\t%s\t%08X\t%s\n" % (ea, b(ea, ln).hex(), fmt(ea)[2], v, st))
                        ncb += 1
    ind.close(); cb.close()
    log("indirect sites %d ; code-address stores/args %d" % (nind, ncb))

    # ---------------- 5. reachability-only cross-check (informative)
    # roots: starts of lane-4 'xref' functions, vectors, every LE32/imm pointer to a validated
    # head (H8 ptr_sites rule), H8 tier-2 roots.  Edges as in FIX.  Measures how much of the
    # FIX-credited set is reachable without the lane-4 'body' structural rule.
    xstarts = set()
    clsmap = {}
    with open(os.path.join(ROOT, r"ida\out\sub-window\functions.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip(BSN).split(BST)
            clsmap[int(p[0], 16)] = (int(p[1], 16), p[2])
            if p[2] == "xref":
                xstarts.add(int(p[0], 16))
    psites = set(); prows = []
    with open(os.path.join(GAP, r"raw\ptr_sites.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip(BSN).split(BST)
            prows.append((int(p[0], 16), int(p[1], 16), p[2])); psites.add(int(p[0], 16))
    proots = set()
    for site, v, sk in prows:
        # true data extents (string pool ends at FFF4B059, H8 finding 1); code above it is code
        if any(lo <= site < hi for lo, hi in ((0xFFED0000, 0xFFED8E70), (0xFFF48000, 0xFFF4B059))) and sk.startswith("insn"):
            sk = "data-item"
        ok = (sk == "insn-imm") or (sk in ("data-item", "unk") and (site % 4 == 0 or (site - 4) in psites or (site + 4) in psites))
        if ok and v in valid_fix and not any(lo <= v < hi for lo, hi in DATA):
            proots.add(v)
    roots0 = (xstarts & valid_fix) | proots | set(ea for ea, _, _ in t2roots)
    seen = set(); work = list(roots0)
    for i in range(256):
        work.append(struct.unpack_from("<I", img, INTB - BASE + 4 * i)[0])
    for i in range(32):
        work.append(struct.unpack_from("<I", img, 0xFFFFFF80 + 4 * i - BASE)[0])
    allheads = valid_fix | set(truehead) | set(ea for ea, v in rF.items() if not v[3].endswith("INVALID"))
    while work:
        t = work.pop()
        if t in seen or not (WIN_LO <= t < TOP) or t not in allheads:
            continue
        seen.add(t)
        out, ln, mn = succ(t, use_xrefs=(t not in fake))
        if out is None:
            continue
        for t2, k in out:
            if t2 not in seen:
                work.append(t2)
    set0 = set()
    for ea in seen:
        ln = truehead.get(ea) or (rF[ea][0] if ea in rF else max(ida_bytes.get_item_size(ea), 1))
        for k in range(ln):
            if WIN_LO <= ea + k < WIN_HI:
                set0.add(ea + k)
    set0 &= setF
    unre = {}
    for s0, (e0, c0) in clsmap.items():
        if c0 not in ("xref", "body"):
            continue
        n = sum(1 for x in range(s0, min(e0, WIN_HI)) if x in setF and x not in set0)
        if n:
            unre[s0] = (n, c0, e0)
    with open(os.path.join(RAW, "reach_only.txt"), "w", encoding="utf-8", newline=BSN) as h:
        h.write("roots: xref starts %d, pointer roots %d, H8 T2 roots %d\n" % (len(xstarts & valid_fix), len(proots), len(t2roots)))
        h.write("FIX credited %d ; reachable-only %d ; not reached %d\n" % (len(setF), len(set0), len(setF - set0)))
        byc = {}
        for s0, (n, c0, e0) in unre.items():
            byc[c0] = byc.get(c0, 0) + n
        h.write("unreached bytes by lane-4 class: %s\n" % byc)
        h.write("start\tend\tclass\tunreached_bytes\n")
        for s0 in sorted(unre, key=lambda x: -unre[x][0]):
            n, c0, e0 = unre[s0]
            h.write("%08X\t%08X\t%s\t%d\n" % (s0, e0, c0, n))
    log("reach-only: %d of %d" % (len(set0), len(setF)))

    # ---------------- I2 export: FIX heads + masks
    def wmask(path, s):
        m = bytearray(WIN_HI - WIN_LO)
        for x in s:
            if WIN_LO <= x < WIN_HI:
                m[x - WIN_LO] = 1
        with open(path, "wb") as hb:
            hb.write(bytes(m))
    wmask(os.path.join(RAW, "mask_base.bin"), setB)
    wmask(os.path.join(RAW, "mask_fix.bin"), setF)
    wmask(os.path.join(RAW, "mask_reach_only.bin"), set0)
    wmask(os.path.join(RAW, "mask_h8.bin"), h8set)
    allh = {}
    for ea in valid_fix:
        allh[ea] = (max(ida_bytes.get_item_size(ea), 1), "V", owner.get(ea, 0), "validated", "V")
    for ea, ln in truehead.items():
        allh[ea] = (ln, "R", 0, "repair", "R")
    for ea, (ln, src, kind, tier) in rF.items():
        if not tier.endswith("INVALID"):
            allh[ea] = (ln, "C", src, kind, tier)
    with open(os.path.join(RAW, "fix_heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tclass\tsrc\tkind\ttier\tbytes\n")
        for ea in sorted(allh):
            ln, c, src, kind, tier = allh[ea]
            h.write("%08X\t%d\t%s\t%08X\t%s\t%s\t%s\n" % (ea, ln, c, src, kind, tier, b(ea, ln).hex()))
    with open(os.path.join(RAW, "fake_heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tbytes\n")
        for ea in sorted(fake):
            sz = max(ida_bytes.get_item_size(ea), 1)
            h.write("%08X\t%d\t%s\n" % (ea, sz, b(ea, sz).hex()))
    with open(os.path.join(RAW, "rej_heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\n")
        for ea in sorted(rejheads):
            h.write("%08X\t%d\n" % (ea, max(ida_bytes.get_item_size(ea), 1)))
    log("I2 export: fix heads %d fake %d rejheads %d set0 %d" % (len(allh), len(fake), len(rejheads), len(set0)))
    log("done")


try:
    main()
except Exception:
    os.makedirs(RAW, exist_ok=True)
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

r"""Lane H8 -- reachability closure over the SUB window gap (read-only on the DB).

Roots: every instruction head inside a validated functions.tsv range (xref/body),
INTB (256) and EXTB (32) vector targets, and (tier 2) LE32 pointer targets read
from the image file. Successors are computed by decoding (fall-through unless
CF_STOP, o_near targets of branches/calls) plus IDA's existing code xrefs (which
carry resolved switch-table edges). Anything reached that is not already a
validated instruction byte is recorded with the edge that first reached it.

    python ida/run_job.py --script ida\jobs\h8_closure.py --db H8_SUBGAP --reopen
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

ROOT = str(_REPO)
RAW = os.path.join(ROOT, r"ida\out\sub-gap\raw")
STATUS = os.path.join(RAW, "h8_closure_status.txt")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
WIN_LO, WIN_HI = 0xFFED0000, 0xFFF50000
TOP = 0xFFF509DE           # lane-9 content top (exclusive)
INTB = 0xFFED8A70
CF_STOP = 0x1
DATA = [(0xFFED0000, 0xFFED8E70), (0xFFF48000, 0xFFF4C000)]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_ua, ida_nalt, idautils, idc
    ida_auto.auto_wait()
    img = sys.exit("The firmware image is not in this repository.")

    rows = []
    with open(os.path.join(ROOT, r"ida\out\sub-window\functions.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            if p[2] in ("xref", "body"):
                rows.append((int(p[0], 16), int(p[1], 16)))

    valid = set()          # validated instruction head addresses
    vbytes = set()
    for s, e in rows:
        ea = s
        while ea < e:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                sz = max(ida_bytes.get_item_size(ea), 1)
                valid.add(ea)
                for k in range(sz):
                    if ea + k < e:
                        vbytes.add(ea + k)
                ea += sz
            else:
                ea += 1
    log("validated heads %d bytes %d" % (len(valid), len(vbytes)))

    SW = {}; SWB = set()
    swp = os.path.join(RAW, "switch_edges.tsv")
    if os.path.isfile(swp):
        with open(swp, encoding="utf-8") as h:
            for ln_ in h:
                a_, t_, e_ = ln_.split()
                SW.setdefault(int(a_, 16), []).append(int(t_, 16))
                SWB.add(int(e_, 16)); SWB.add(int(e_, 16) + 1)
    log("switch edges loaded %d sites" % len(SW))

    def succ(ea):
        out = []
        insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            return None, 0, ""
        mn = insn.get_canon_mnem()
        if not (insn.get_canon_feature() & CF_STOP):
            out.append((ea + ln, "flow"))
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type in (ida_ua.o_near, ida_ua.o_far):
                out.append((op.addr, "call" if mn.startswith("bsr") or mn.startswith("jsr") else "jump"))
        for t in idautils.CodeRefsFrom(ea, 0):
            out.append((t, "xref"))
        for t in SW.get(ea, ()):
            out.append((t, "switch"))
        return out, ln, mn

    reached = {}           # ea -> (size, src, kind, tier, mnem)
    work = []
    conflicts = []

    def push(t, src, kind, tier):
        if t in valid or t in reached:
            return
        if t in vbytes:
            conflicts.append((t, src, kind, tier))
            return
        if not (WIN_LO <= t < TOP):
            return
        work.append((t, src, kind, tier))

    # tier 1: from validated code
    for ea in sorted(valid):
        out, ln, mn = succ(ea)
        if out is None:
            continue
        for t, k in out:
            if t not in vbytes or t not in valid:
                if t not in valid:
                    push(t, ea, k, "T1-flow")
    # vectors
    for i in range(256):
        t = struct.unpack_from("<I", img, INTB - BASE + 4 * i)[0]
        push(t, INTB + 4 * i, "intb%d" % i, "T1-vector")
    for i in range(32):
        a = 0xFFFFFF80 + 4 * i
        t = struct.unpack_from("<I", img, a - BASE)[0]
        push(t, a, "extb%d" % i, "T1-vector")
    log("tier1 roots %d" % len(work))

    def drain():
        n = 0
        while work:
            t, src, kind, tier = work.pop()
            if t in valid or t in reached:
                continue
            out, ln, mn = succ(t)
            if out is None:
                reached[t] = (0, src, kind, tier + "-INVALID", "")
                continue
            reached[t] = (ln, src, kind, tier, mn)
            n += 1
            for t2, k in out:
                push(t2, t, k, tier)
        return n
    n1 = drain()
    log("tier1 reached heads %d" % n1)

    # tier 2: LE32 pointer scan of the whole image file
    ptr_sites = []
    lo_v, hi_v = WIN_LO, TOP
    for off in range(0, len(img) - 3):
        v = img[off] | (img[off + 1] << 8) | (img[off + 2] << 16) | (img[off + 3] << 24)
        if lo_v <= v < hi_v:
            ptr_sites.append((BASE + off, v))
    log("LE32 sites into window..top %d" % len(ptr_sites))
    with open(os.path.join(RAW, "ptr_sites.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("site\ttarget\tsite_kind\tsite_head\ttarget_state\n")
        for site, v in ptr_sites:
            fl = ida_bytes.get_flags(site)
            hd = ida_bytes.get_item_head(site)
            if ida_bytes.is_code(ida_bytes.get_flags(hd)):
                sk = "insn-imm" if hd in valid or hd in reached else "insn-other"
            elif ida_bytes.is_data(ida_bytes.get_flags(hd)):
                sk = "data-item"
            else:
                sk = "unk"
            ts = "valid-head" if v in valid else ("vbyte" if v in vbytes else ("reached" if v in reached else "gap"))
            h.write("%08X\t%08X\t%s\t%08X\t%s\n" % (site, v, sk, hd, ts))

    siteset = set(x for x, _ in ptr_sites)
    rejroots = []

    def plaus(ea):
        cur = ea; n = 0
        while cur < ea + 0x2000:
            insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, cur)
            if ln <= 0:
                return False
            n += 1
            if insn.get_canon_feature() & CF_STOP:
                return n >= 2 or insn.get_canon_mnem() in ('rts', 'rte')
            cur += ln
        return False

    # tier 2 roots: targets in gap whose site is a data item / unk byte (not inside an instruction),
    # or an immediate operand of a validated/reached instruction equal to the target.
    for site, v in ptr_sites:
        if v in valid or v in vbytes or v in reached:
            continue
        hd = ida_bytes.get_item_head(site)
        fl = ida_bytes.get_flags(hd)
        ok = None
        in_pd = any(lo <= site < hi for lo, hi in DATA)
        if ida_bytes.is_code(fl) and not in_pd:
            if hd in valid or hd in reached:
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, hd) > 0:
                    for op in insn.ops:
                        if op.type == 0:
                            break
                        if op.type == ida_ua.o_imm and (op.value & 0xFFFFFFFF) == v:
                            ok = "imm"
        else:
            if site % 4 == 0 or (site - 4) in siteset or (site + 4) in siteset:
                ok = "data"
        if any(lo <= v < hi for lo, hi in DATA) or 0xFFED8E70 <= v < 0xFFEDAB4C or v in SWB:
            ok = None
        if ok and not plaus(v):
            rejroots.append((v, site, ok))
            ok = None
        if ok:
            push(v, site, "ptr-" + ok, "T2-ptr")
    n2 = drain()
    log("tier2 reached heads %d ; implausible roots dropped %d" % (n2, len(rejroots)))
    with open(os.path.join(RAW, "t2_rejroots.tsv"), "w", encoding="utf-8", newline="\n") as h:
        for v, site, ok in rejroots:
            h.write("%08X\t%08X\t%s\n" % (v, site, ok))

    with open(os.path.join(RAW, "reach.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tsrc\tkind\ttier\tmnem\tida_state\n")
        for ea in sorted(reached):
            ln, src, kind, tier, mn = reached[ea]
            fl = ida_bytes.get_flags(ea)
            st = "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else ("tail" if ida_bytes.is_tail(fl) else "unk"))
            h.write("%08X\t%d\t%08X\t%s\t%s\t%s\t%s\n" % (ea, ln, src, kind, tier, mn, st))
    with open(os.path.join(RAW, "conflicts.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("target\tsrc\tkind\ttier\n")
        for t, src, kind, tier in conflicts:
            h.write("%08X\t%08X\t%s\t%s\n" % (t, src, kind, tier))
    log("conflicts %d" % len(conflicts))
    log("done")


try:
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

r"""Lane L6 -- SUB screen-handler string harvest (read-only).
DB L6_HOME_KEYS_SUB (copy of K7_SUB_FINAL3). No byte is patched, nothing is created except what IDA already
has. For each SUB screen handler listed in ida\out\home-keytable\work\sub_req.txt (page, screen, handler[/h2]),
walk the call closure (direct calls only, depth <= 3) and record every immediate operand or data xref that
lands on a printable ASCII run (>= 3 chars) inside the SUB image.
Output: ida\out\home-keytable\work\sub_strings.tsv ; traceback to sub_strings.err
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, idc, idautils, ida_idp

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "home-keytable", "work")
LO, HI = 0xFFC00000, 0xFFFFFFFF


def ascii_at(ea):
    if not (LO <= ea < HI):
        return None
    s = []
    for i in range(48):
        b = ida_bytes.get_byte(ea + i)
        if 0x20 <= b < 0x7F:
            s.append(chr(b))
        else:
            break
    if len(s) >= 3 and sum(c.isalpha() for c in s) >= 2:
        return "".join(s)
    return None


def calls_from(fn):
    out = set()
    for ea in idautils.FuncItems(fn.start_ea):
        insn = ida_ua.insn_t()
        if not ida_ua.decode_insn(insn, ea):
            continue
        mn = (idc.print_insn_mnem(ea) or "").lower()
        if ida_idp.is_call_insn(insn) or mn.startswith(("bsr", "jsr")):
            for r in idautils.CodeRefsFrom(ea, False):
                out.add(r)
        # phase/pointer tables: mov.l #tbl,rN followed by an indexed load and jsr rN
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type == ida_ua.o_imm and LO <= (op.value & 0xFFFFFFFF) < HI:
                t = op.value & 0xFFFFFFFF
                for i in range(16):
                    d = ida_bytes.get_dword(t + 4 * i)
                    f = ida_funcs.get_func(d)
                    if not f or f.start_ea != d:
                        break
                    out.add(d)
    return out


def strs_in(fn):
    rows = []
    for ea in idautils.FuncItems(fn.start_ea):
        insn = ida_ua.insn_t()
        if not ida_ua.decode_insn(insn, ea):
            continue
        cands = set()
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type == ida_ua.o_imm:
                cands.add(op.value & 0xFFFFFFFF)
            elif op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far):
                cands.add(op.addr & 0xFFFFFFFF)
        for d in idautils.DataRefsFrom(ea):
            cands.add(d & 0xFFFFFFFF)
        for c in cands:
            t = ascii_at(c)
            if t:
                rows.append((ea, c, t))
    return rows


def main():
    ida_auto.auto_wait()
    out = ["page\tscreen\thandler\tdepth\tfunc\tinsn\tstr_addr\tfile_off\ttext"]
    with open(os.path.join(W, "sub_req.txt"), encoding="utf-8") as f:
        req = [l.rstrip("\n").split("\t") for l in f if l.strip()]
    for page, scr, hs in req:
        for h in hs.split("/"):
            root = int(h, 16)
            fn = ida_funcs.get_func(root)
            if not fn:
                out.append("%s\t%s\t%08X\t-\tNOFUNC\t\t\t\t" % (page, scr, root))
                continue
            seen = {fn.start_ea: 0}
            frontier = [fn.start_ea]
            for depth in range(1, 4):
                nxt = []
                for s in frontier:
                    f2 = ida_funcs.get_func(s)
                    if not f2:
                        continue
                    for c in calls_from(f2):
                        f3 = ida_funcs.get_func(c)
                        if f3 and f3.start_ea not in seen:
                            seen[f3.start_ea] = depth
                            nxt.append(f3.start_ea)
                frontier = nxt
            for s, d in sorted(seen.items(), key=lambda x: (x[1], x[0])):
                f2 = ida_funcs.get_func(s)
                for ea, c, t in strs_in(f2):
                    out.append("%s\t%s\t%08X\t%d\t%08X\t%08X\t%08X\t%06X\t%s" % (page, scr, root, d, s, ea, c, c - LO, t.replace("\t", " ")))
    out.append("# req=%d rows=%d" % (len(req), len(out) - 1))
    with open(os.path.join(W, "sub_strings.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(out) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "sub_strings.err"), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)

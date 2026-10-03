r"""Lane M10 -- deep SUB screen-handler string harvest (read-only).
DB M10_KEYS_SUB (copy of K7_SUB_FINAL3). No byte patched. For each root function, walk the call
closure (direct bsr/jsr + indirect pointer-table dispatch mov.l #tbl;...;jsr rN) to depth<=6 and
record every immediate/data ref that lands on a printable ASCII run (>=3 chars). Also report which
"probe" functions are reachable from each root (DG-ID screens etc).
Output: ida\out\touch-key-leftovers\work\sub_labels.tsv ; traceback to sub_labels.err
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, idc, idautils, ida_idp

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "touch-key-leftovers", "work")
LO, HI = 0xFFC00000, 0xFFFFFFFF

# page, screen, handler  -- F701/F703 and neighbours of modes 8/10/1/3
ROOTS = [
    ("F701", "0x2E", 0xFFEEF315),
    ("F703", "0x44", 0xFFF420F6),
]
PROBES = {
    0xFFF0381A: "DG-ID TX/RX setup",
    0xFFF03AD8: "PRESET / DG-ID:",
    0xFFF0A262: "DG-ID (A262)",
}


def ascii_at(ea):
    if not (LO <= ea < HI):
        return None
    s = []
    for i in range(64):
        b = ida_bytes.get_byte(ea + i)
        if 0x20 <= b < 0x7F:
            s.append(chr(b))
        else:
            break
    if len(s) >= 3 and sum(c.isalpha() for c in s) >= 2:
        return "".join(s)
    return None


def calls_from(start):
    out = set()
    for ea in idautils.FuncItems(start):
        insn = ida_ua.insn_t()
        if not ida_ua.decode_insn(insn, ea):
            continue
        mn = (idc.print_insn_mnem(ea) or "").lower()
        if ida_idp.is_call_insn(insn) or mn.startswith(("bsr", "jsr", "bra", "jmp")):
            for r in idautils.CodeRefsFrom(ea, False):
                f = ida_funcs.get_func(r)
                if f:
                    out.add(f.start_ea)
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type == ida_ua.o_imm and LO <= (op.value & 0xFFFFFFFF) < HI:
                t = op.value & 0xFFFFFFFF
                for i in range(24):
                    d = ida_bytes.get_dword(t + 4 * i)
                    f = ida_funcs.get_func(d)
                    if not f or f.start_ea != d:
                        break
                    out.add(d)
    return out


def strs_in(start):
    rows = []
    for ea in idautils.FuncItems(start):
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


def closure(root, maxd=6):
    seen = {root: 0}
    frontier = [root]
    for depth in range(1, maxd + 1):
        nxt = []
        for s in frontier:
            if not ida_funcs.get_func(s):
                continue
            for c in calls_from(s):
                if c not in seen:
                    seen[c] = depth
                    nxt.append(c)
        frontier = nxt
    return seen


def main():
    ida_auto.auto_wait()
    out = ["page\tscreen\thandler\tdepth\tfunc\tinsn\tstr_addr\tfile_off\ttext"]
    rep = []
    for page, scr, root in ROOTS:
        fn = ida_funcs.get_func(root)
        if not fn:
            out.append("%s\t%s\t%08X\t-\tNOFUNC\t\t\t\t" % (page, scr, root))
            continue
        seen = closure(fn.start_ea)
        for s, d in sorted(seen.items(), key=lambda x: (x[1], x[0])):
            for ea, c, t in strs_in(s):
                out.append("%s\t%s\t%08X\t%d\t%08X\t%08X\t%08X\t%06X\t%s"
                            % (page, scr, root, d, s, ea, c, c - LO, t.replace("\t", " ")))
        hits = [(p, n, seen[p]) for p, n in PROBES.items() if p in seen]
        rep.append("# %s scr %s handler %08X: funcs=%d ; probes=%s"
                   % (page, scr, root, len(seen),
                      ", ".join("%s@d%d(%08X)" % (n, d, p) for p, n, d in hits) or "none"))
    out = [out[0]] + rep + out[1:]
    with open(os.path.join(W, "sub_labels.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(out) + "\n")
    with open(os.path.join(W, "sub_labels.rep"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(rep) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "sub_labels.err"), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)

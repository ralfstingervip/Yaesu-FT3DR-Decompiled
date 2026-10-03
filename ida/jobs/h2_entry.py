# -*- coding: utf-8 -*-
r"""Lane H2 -- move F1 function starts to their table-proven entry.

For an F1 proved row whose own start has no incoming reference, F1's evidence is a dispatch-table
entry that points INSIDE the row ("inside->X" in proved.tsv). If X is a code head inside the row's
function, carries a table xref, X - row <= MAXD bytes, no item in [row, X) is referenced, and the
item before row does not fall through into row, then: del_func(row), undefine [row, X), add_func(X).
Larger deltas are only listed. Appends to ida\out\h8sx-seed\changes.tsv (phase=entry).
Env H2_APPLY=0 for a dry run, H2_MAXD (default 8)."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_idp, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8sx-seed")
PROVED = os.path.join(ROOT, "ida", "out", "main-indirect", "proved.tsv")
F1 = os.path.join(OUT, "f1_true_starts.tsv")
APPLY = os.environ.get("H2_APPLY", "1") == "1"
MAXD = int(os.environ.get("H2_MAXD", "8"))
# rows with delta > MAXD whose [row,target) bytes were read and are data (ASCII label / mask or numeric table)
ALLOW = set(int(x, 16) for x in os.environ.get("H2_ALLOW", "").split(",") if x)
CH = []
LOG = []


def refs_in(ea):
    return list(idautils.CodeRefsTo(ea, 0)) + list(idautils.DataRefsTo(ea))


def falls_into(ea):
    p = ida_bytes.prev_head(ea, 0)
    if p == idc.BADADDR or p + ida_bytes.get_item_size(p) != ea:
        return False
    if not ida_bytes.is_code(ida_bytes.get_flags(p)):
        return False
    insn = ida_ua.insn_t()
    if ida_ua.decode_insn(insn, p) <= 0:
        return False
    return not (insn.get_canon_feature() & ida_idp.CF_STOP)


def main():
    ida_auto.auto_wait()
    fix = {}
    with open(F1, encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.split("\t")
            fix[int(p[0], 16)] = int(p[1], 16)
    rows = []
    with open(PROVED, encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.split("\t")
            s = int(p[0], 16)
            if s in fix:
                continue
            m = re.search(r"inside->([0-9A-F]{6})", ln)
            if m:
                rows.append((s, int(m.group(1), 16)))
    moved = listed = skipped = 0
    for s, x in rows:
        f = ida_funcs.get_func(s)
        if not (f and f.start_ea == s):
            continue
        if refs_in(s):
            continue
        why = []
        d = x - s
        if not (0 < d):
            why.append("target not after start")
        g = ida_funcs.get_func(x)
        if not (g and g.start_ea == s):
            why.append("target not in row function")
        if not ida_bytes.is_head(ida_bytes.get_flags(x)) or not ida_bytes.is_code(ida_bytes.get_flags(x)):
            why.append("target not a code head")
        if not any(True for _ in idautils.DataRefsTo(x)):
            why.append("target has no table xref")
        ea = s
        while ea < x and ea != idc.BADADDR:
            if refs_in(ea):
                why.append("item %06X in [row,target) is referenced" % ea)
                break
            ea = ida_bytes.next_head(ea, x + 1)
        if falls_into(s):
            why.append("previous instruction falls into row")
        b = (ida_bytes.get_bytes(s, d) or b"").hex() if 0 < d <= 0x60 else "-"
        if why:
            skipped += 1
            CH.append("entry\tskip\t%06X\trow func %06X-%06X\ttarget %06X\t%s; bytes %s" % (s, f.start_ea, f.end_ea, x, "; ".join(why), b))
            continue
        if d > MAXD and s not in ALLOW:
            listed += 1
            CH.append("entry\tlist_only\t%06X\trow func %06X-%06X\ttarget %06X (+%d)\tdelta > %d, not applied; bytes [row,target) %s" % (s, f.start_ea, f.end_ea, x, d, MAXD, b))
            continue
        if APPLY:
            end = f.end_ea
            ida_funcs.del_func(s)
            ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, d)
            ok = ida_funcs.add_func(x)
            g = ida_funcs.get_func(x)
            CH.append("entry\tmove_func_start\t%06X\tfunc %06X-%06X\tfunc %s ok=%s\tF1 row reached only via table entry -> %06X (+%d); [row,target) unreferenced, undefined; bytes %s" % (
                s, s, end, ("%06X-%06X" % (g.start_ea, g.end_ea)) if g else "-", ok, x, d, b))
        moved += 1
    ida_auto.auto_wait()
    LOG.append("rows with inside-> target: %d; moved %d; list_only %d; skipped %d; apply=%s" % (len(rows), moved, listed, skipped, APPLY))
    if os.environ.get("H2_GENERIC") == "1":
        generic()


def ptrlike(v):
    return (v >> 24) == 0 and (v < 0x07B754 or 0xFEE000 <= v <= 0xFFFFFF)


def generic():
    """Any function whose start S has no reference, where the first referenced code head X in
    (S, S+8] is inside the same function and is a table-slot target, and S sits inside a pointer-like
    BE32 constant (S-2 or S) or [S,X) is printable ASCII."""
    slots = set()
    with open(os.path.join(OUT, "table-xrefs-h8sx.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            slots.add(int(ln.split(chr(9))[0], 16))
    cand = moved = 0
    for S in list(idautils.Functions(0, 0x078106)):
        f = ida_funcs.get_func(S)
        if not f or f.start_ea != S or refs_in(S):
            continue
        X = None
        ea = ida_bytes.next_head(S, S + 9)
        bad = False
        while ea != idc.BADADDR and ea <= S + 8:
            if refs_in(ea):
                if any(r in slots for r in idautils.DataRefsTo(ea)) and ida_bytes.is_code(ida_bytes.get_flags(ea)):
                    X = ea
                else:
                    bad = True
                break
            ea = ida_bytes.next_head(ea, S + 9)
        if X is None or bad:
            continue
        g = ida_funcs.get_func(X)
        if not (g and g.start_ea == S) or falls_into(S):
            continue
        cand += 1
        d = X - S
        b = ida_bytes.get_bytes(S - 2, d + 2) or b""
        v0 = int.from_bytes(ida_bytes.get_bytes(S - 2, 4) or bytes([255]) * 4, "big")
        v1 = int.from_bytes(ida_bytes.get_bytes(S, 4) or bytes([255]) * 4, "big")
        asc = all(0x20 <= c < 0x7F or c == 0xFF for c in b[2:])
        why = "low half of BE32 constant %08X at %06X" % (v0, S - 2) if ptrlike(v0) else (
            "BE32 constant %08X at row" % v1 if ptrlike(v1) else ("ASCII" if asc else None))
        if not why:
            CH.append("entry	generic_skip	%06X	func %06X-%06X	target %06X (+%d)	no data pattern; bytes %s" % (S, S, f.end_ea, X, d, b.hex()))
            continue
        if APPLY:
            end = f.end_ea
            ida_funcs.del_func(S)
            ida_bytes.del_items(S, ida_bytes.DELIT_SIMPLE, d)
            ok = ida_funcs.add_func(X)
            g = ida_funcs.get_func(X)
            CH.append("entry	generic_move_func_start	%06X	func %06X-%06X	func %s ok=%s	unreferenced start; table-slot target %06X (+%d); %s; bytes from S-2 %s" % (
                S, S, end, ("%06X-%06X" % (g.start_ea, g.end_ea)) if g else "-", ok, X, d, why, b.hex()))
        else:
            CH.append("entry	generic_candidate	%06X	func %06X-%06X	target %06X (+%d)	%s; bytes from S-2 %s" % (S, S, f.end_ea, X, d, why, b.hex()))
        moved += 1
    ida_auto.auto_wait()
    LOG.append("generic: candidates %d, pattern-confirmed %d, apply=%s" % (cand, moved, APPLY))


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
with open(os.path.join(OUT, "work", "entry_log.txt"), "w", encoding="utf-8", newline="\n") as h:
    h.write("\n".join(LOG) + "\n")
if APPLY:
    with open(os.path.join(OUT, "changes.tsv"), "a", encoding="utf-8", newline="\n") as h:
        for c in CH:
            h.write(c + "\n")
else:
    with open(os.path.join(OUT, "work", "entry_dry.tsv"), "w", encoding="utf-8", newline="\n") as h:
        for c in CH:
            h.write(c + "\n")
idc.qexit(0)

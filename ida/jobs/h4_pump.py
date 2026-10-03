r"""Lane H4 -- SCI-C byte pump analysis on H4_PUMP (seeded from G1_H8S, h8sxa).

Read-only. No image modified, nothing written to a radio. Static only.

Outputs under ida\out\sci-c-pump\work\:
  funcinfo.txt   per probe-address: containing func bounds, xrefs to func start
                 and to the exact addr, short disasm window.
  calltree.txt   recursive upward call tree (code xrefs) for key roots, to depth 6.
  disasm.txt     full annotated disasm of named ranges (pump, 4 routines, P3DR,
                 SCI-C ISR, module helpers).
  modfuncs.tsv   every function whose start is in 0x075F36..0x078105, with bounds,
                 cref-to count, and the list of caller addresses.
  xrefs.tsv      every code xref whose target is in 0x075F36..0x078105 (module),
                 tagged src-region / dst-region, plus edges that cross the closed
                 window boundary 0x078106..0x07B753 (address only).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, ida_xref, idautils, idc

ROOT = str(_REPO)
WORK = os.path.join(ROOT, "ida", "out", "sci-c-pump", "work")

WIN0, WIN1 = 0x078106, 0x07B753      # CLOSED window
MOD0, MOD1 = 0x075F36, 0x078105      # H8SX USB/SCI module (open)

PROBES = [0x077018, 0x07701E, 0x077022, 0x07711E, 0x0771E2, 0x07720E,
          0x07801C, 0x0773E8, 0x0779C4, 0x076B4E, 0x056450, 0x05615C,
          0x0561A8, 0x055FFE, 0x077008, 0x077000]

DISASM_RANGES = [
    ("pump_core 077000-077240", 0x077000, 0x077240),
    ("rt_07801C 078000-0780D8", 0x078000, 0x0780D8),
    ("rt_0773E8 0773E8-077460", 0x0773E8, 0x077460),
    ("rt_0779C4 0779C4-077A36", 0x0779C4, 0x077A36),
    ("rt_076B4E 076B4E-076C0A", 0x076B4E, 0x076C0A),
    ("P3DR_056440 056440-0564C0", 0x056440, 0x0564C0),
    ("SCIc_ISR 05615C-0561C8", 0x05615C, 0x0561C8),
    ("setup_055FFE 055FFE-056046", 0x055FFE, 0x056046),
]


def region(ea):
    if WIN0 <= ea <= WIN1:
        return "WINDOW"
    if MOD0 <= ea <= MOD1:
        return "MODULE"
    return "outside"


def txt(ea):
    return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "").replace("\t", " ")


def bytes_at(ea, n):
    return " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(n))


def xrefs_to(ea):
    out = []
    for x in idautils.XrefsTo(ea, 0):
        kind = "data"
        if x.iscode:
            if x.type in (ida_xref.fl_CF, ida_xref.fl_CN):
                kind = "call"
            elif x.type in (ida_xref.fl_JF, ida_xref.fl_JN):
                kind = "jump"
            else:
                kind = "code%d" % x.type
        out.append((x.frm, kind))
    return out


def func_bounds(ea):
    f = ida_funcs.get_func(ea)
    return (f.start_ea, f.end_ea) if f else (None, None)


def do_funcinfo(fh):
    for ea in PROBES:
        s, e = func_bounds(ea)
        fh.write("== %06X  region=%s  func=%s\n" % (
            ea, region(ea), ("%06X-%06X" % (s, e)) if s is not None else "NONE"))
        # xrefs to exact address
        xa = xrefs_to(ea)
        fh.write("   xrefs->addr: %s\n" % (
            ", ".join("%06X:%s[%s]" % (f, k, region(f)) for f, k in xa) or "none"))
        # xrefs to func start (if different)
        if s is not None and s != ea:
            xs = xrefs_to(s)
            fh.write("   xrefs->funcstart %06X: %s\n" % (
                s, ", ".join("%06X:%s[%s]" % (f, k, region(f)) for f, k in xs) or "none"))
        # short disasm
        h = ida_bytes.get_item_head(ea)
        for _ in range(8):
            fh.write("     %06X %-10s %s\n" % (h, bytes_at(h, min(ida_bytes.get_item_size(h), 8)), txt(h)))
            h = ida_bytes.next_head(h, idc.BADADDR)
        fh.write("\n")


def walk_up(fh, root, depth, maxdepth, seen, prefix):
    s, e = func_bounds(root)
    key = s if s is not None else root
    tag = "%06X" % root
    if s is not None and s != root:
        tag = "%06X(in %06X-%06X)" % (root, s, e)
    marker = " [SEEN]" if key in seen else ""
    fh.write("%s%s [%s]%s\n" % (prefix, tag, region(root), marker))
    if key in seen or depth >= maxdepth:
        return
    seen.add(key)
    # callers = code xrefs to the function start
    callers = []
    if s is not None:
        for f, k in xrefs_to(s):
            if k in ("call", "jump") or k.startswith("code"):
                callers.append((f, k))
    else:
        for f, k in xrefs_to(root):
            if k in ("call", "jump") or k.startswith("code"):
                callers.append((f, k))
    if not callers:
        fh.write("%s   (no code xref -- ROOT/indirect/fallthrough)\n" % prefix)
    for f, k in sorted(set(callers)):
        walk_up(fh, f, depth + 1, maxdepth, seen, prefix + "   ")


def do_calltree(fh):
    roots = [0x07711E, 0x07701E, 0x077018, 0x07801C, 0x0773E8, 0x0779C4,
             0x076B4E, 0x056450, 0x05DD00, 0x0103C0]
    for r in roots:
        fh.write("\n===== upward call tree from %06X =====\n" % r)
        walk_up(fh, r, 0, 6, set(), "")


def do_disasm(fh):
    for name, a, b in DISASM_RANGES:
        fh.write("\n===== %s =====\n" % name)
        ea = a
        while ea < b:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                n = ida_bytes.get_item_size(ea)
                fh.write("%06X  %-24s %s\n" % (ea, bytes_at(ea, min(n, 10)), txt(ea)))
                ea = ida_bytes.next_head(ea, idc.BADADDR)
            else:
                fh.write("%06X  %-24s %s\n" % (ea, bytes_at(ea, 1), "db " + txt(ea)))
                ea += 1


def do_modfuncs(fh, xfh):
    fh.write("start\tend\tsize\tncref\tcallers\n")
    for s in idautils.Functions(MOD0, MOD1 + 1):
        if not (MOD0 <= s <= MOD1):
            continue
        f = ida_funcs.get_func(s)
        callers = [("%06X:%s" % (fr, k)) for fr, k in xrefs_to(s)]
        fh.write("%06X\t%06X\t%d\t%d\t%s\n" % (
            s, f.end_ea, f.end_ea - s, len(callers), ",".join(callers)))
    # all code xrefs whose target lands in the module, plus window-crossing edges
    xfh.write("src\tsrc_region\tdst\tdst_region\tkind\n")
    for ea in idautils.Heads(0x000000, 0x07B754):
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            continue
        for x in idautils.XrefsFrom(ea, 0):
            if not x.iscode:
                continue
            if x.type not in (ida_xref.fl_CF, ida_xref.fl_CN, ida_xref.fl_JF, ida_xref.fl_JN):
                continue
            dst = x.to
            sr, dr = region(ea), region(dst)
            cross = (sr == "WINDOW") != (dr == "WINDOW")
            inmod = (MOD0 <= dst <= MOD1)
            if inmod or cross:
                k = "call" if x.type in (ida_xref.fl_CF, ida_xref.fl_CN) else "jump"
                xfh.write("%06X\t%s\t%06X\t%s\t%s\n" % (ea, sr, dst, dr, k))


def main():
    ida_auto.auto_wait()
    with open(os.path.join(WORK, "funcinfo.txt"), "w", encoding="utf-8", newline="\n") as fh:
        do_funcinfo(fh)
    with open(os.path.join(WORK, "calltree.txt"), "w", encoding="utf-8", newline="\n") as fh:
        do_calltree(fh)
    with open(os.path.join(WORK, "disasm.txt"), "w", encoding="utf-8", newline="\n") as fh:
        do_disasm(fh)
    with open(os.path.join(WORK, "modfuncs.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        with open(os.path.join(WORK, "xrefs.tsv"), "w", encoding="utf-8", newline="\n") as xfh:
            do_modfuncs(fh, xfh)


try:
    main()
except Exception:
    with open(os.path.join(WORK, "h4_err.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane L97 read-only dump of TX frequency-range check sub_34E42 (MAIN, h8sxa).

Writes ida\out\tx-freq-range\ida-disasm.txt. No database writes. Skips the
closed window 0x078106-0x07B753. Optional extra commands: env L97_REQ, one
per line (dis/func/xref/callers/grep), same shape as k11_dump.py.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, idc, ida_bytes, ida_funcs, ida_xref, idautils

OUT = os.environ.get(
    "L97_OUT",
    str(_REPO / "ida/out/tx-freq-range/ida-disasm.txt"),
)
REQ = os.environ.get("L97_REQ", "")
WIN = (0x078106, 0x07B754)

FUNCS = [
    0x034DC2, 0x034DC8, 0x034E42, 0x034E82, 0x034E8A,
    0x0325FA, 0x03F47E, 0x03F48E, 0x03F4A2, 0x03F5B2, 0x03F5EE,
    0x03F924, 0x03F94C,
]
RANGES = [
    (0x034DC0, 0x034F00, "shift-and-check"),
    (0x0325FA, 0x032650, "sub_325FA"),
    (0x03F470, 0x03F4F0, "window-fill"),
    (0x03F5E8, 0x03F610, "range-cmp"),
    (0x03F910, 0x03F980, "bcd-add-sub"),
    (0x0224E0, 0x022570, "caller-2244C"),
    (0x022670, 0x022710, "caller-22676"),
]
XREFS = [
    0x034E42, 0x034DC2, 0x034E82, 0xFFFFAAAE, 0xFFAAAE,
    0xFF92CE, 0xFF92D6, 0xFFFF92CE, 0xFFFF92D6,
    0x00F0AE, 0x00F0BE, 0x00F672, 0x00F0A2,
]
CALLERS = [0x034E42, 0x034DC2, 0x034E82, 0x034DC8, 0x034E8A, 0x03F4A2, 0x0325FA]


def inwin(ea):
    return WIN[0] <= ea < WIN[1]


def line(ea):
    d = idc.generate_disasm_line(ea, 0) or ""
    sz = idc.get_item_size(ea)
    raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
    return "%06X  %-36s  %s" % (ea, " ".join("%02x" % b for b in raw), d)


def disrange(lo, hi):
    out = []
    ea = lo
    guard = 0
    while ea < hi and ea != idc.BADADDR and guard < 4000:
        guard += 1
        if inwin(ea):
            out.append("%06X  <closed window skipped>" % ea)
            ea = WIN[1]
            continue
        out.append(line(ea))
        n = idc.next_head(ea, hi)
        if n <= ea or n == idc.BADADDR:
            break
        ea = n
    return out


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return "-"
    return "%s@%06X" % (ida_funcs.get_func_name(f.start_ea), f.start_ea)


def xrefs(addr):
    res = []
    cands = {addr & 0xFFFFFFFF, 0xFFFF0000 | (addr & 0xFFFF), 0xFF0000 | (addr & 0xFFFF)}
    for a in sorted(cands):
        for x in idautils.XrefsTo(a, 0):
            if inwin(x.frm):
                continue
            res.append((x.frm, a, x.type))
    return res


def emit_req(out, raw):
    p = raw.split()
    cmd = p[0]
    if cmd == "dis":
        lo, hi = int(p[1], 16), int(p[2], 16)
        out.append("### dis %06X-%06X %s" % (lo, hi, " ".join(p[3:])))
        out += disrange(lo, hi)
    elif cmd == "func":
        ea = int(p[1], 16)
        f = ida_funcs.get_func(ea)
        if f:
            out.append("### func %s %06X-%06X" % (fname(ea), f.start_ea, f.end_ea))
            out += disrange(f.start_ea, f.end_ea)
        else:
            out.append("### func %06X: no function" % ea)
    elif cmd == "xref":
        a = int(p[1], 16)
        out.append("### xref %X" % a)
        for frm, tgt, t in xrefs(a):
            out.append("%06X  ->%08X t%d  %-28s %s" % (
                frm, tgt, t, fname(frm), idc.generate_disasm_line(frm, 0) or ""))
    elif cmd == "callers":
        ea = int(p[1], 16)
        f = ida_funcs.get_func(ea)
        s = f.start_ea if f else ea
        out.append("### callers %06X" % s)
        for x in idautils.XrefsTo(s, 0):
            if inwin(x.frm):
                continue
            out.append("%06X  t%d  %-28s %s" % (
                x.frm, x.type, fname(x.frm), idc.generate_disasm_line(x.frm, 0) or ""))
    elif cmd == "grep":
        rx = re.compile(" ".join(p[1:]), re.I)
        out.append("### grep %s" % rx.pattern)
        ea = 0
        while ea < 0x80000 and ea != idc.BADADDR:
            if inwin(ea):
                ea = WIN[1]
                continue
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                d = idc.generate_disasm_line(ea, 0) or ""
                if rx.search(d):
                    out.append("%06X  %-28s %s" % (ea, fname(ea), d))
            n = idc.next_head(ea, 0x80000)
            if n <= ea:
                break
            ea = n


def after_call(frm, n=8):
    out = []
    ea = frm
    for _ in range(n):
        if ea == idc.BADADDR or inwin(ea):
            break
        out.append(line(ea))
        ea = idc.next_head(ea, ea + 16)
        if ea <= frm:
            break
    return out


def main():
    ida_auto.auto_wait()
    out = []
    out.append("### funcs")
    for ea in FUNCS:
        f = ida_funcs.get_func(ea)
        if not f:
            out.append("NOFUNC %06X" % ea)
            continue
        out.append("FUNC %s %06X-%06X size=%d" % (
            ida_funcs.get_func_name(f.start_ea), f.start_ea, f.end_ea, f.end_ea - f.start_ea))
        out += disrange(f.start_ea, f.end_ea)
        out.append("")
    out.append("### ranges")
    for lo, hi, lab in RANGES:
        out.append("--- %s %06X-%06X" % (lab, lo, hi))
        out += disrange(lo, hi)
        out.append("")
    out.append("### xrefs")
    for a in XREFS:
        out.append("--- xref %X" % a)
        xs = xrefs(a)
        if not xs:
            out.append("(none)")
        for frm, tgt, t in xs:
            out.append("%06X  ->%08X t%d  %-28s %s" % (
                frm, tgt, t, fname(frm), idc.generate_disasm_line(frm, 0) or ""))
        out.append("")
    out.append("### callers-and-next")
    seen = set()
    for ea in CALLERS:
        f = ida_funcs.get_func(ea)
        s = f.start_ea if f else ea
        out.append("--- callers %06X" % s)
        for x in idautils.XrefsTo(s, 0):
            if inwin(x.frm) or x.frm in seen:
                continue
            if x.type not in (ida_xref.fl_CN, ida_xref.fl_CF, 17, 19):
                # still list non-call xrefs once
                out.append("X %06X t%d %s %s" % (
                    x.frm, x.type, fname(x.frm), idc.generate_disasm_line(x.frm, 0) or ""))
                continue
            seen.add(x.frm)
            out.append("CALL %06X t%d %s" % (x.frm, x.type, fname(x.frm)))
            out += after_call(x.frm, 10)
            out.append("")
    if REQ and os.path.isfile(REQ):
        out.append("### extra req")
        for raw in open(REQ, encoding="utf-8"):
            raw = raw.strip()
            if not raw or raw.startswith("#"):
                continue
            emit_req(out, raw)
            out.append("")
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(out) + "\n")


try:
    main()
except Exception:
    tb = traceback.format_exc()
    try:
        os.makedirs(os.path.dirname(OUT), exist_ok=True)
        with open(OUT + ".tb.txt", "w", encoding="utf-8", newline="\n") as h:
            h.write(tb)
    except Exception:
        pass
finally:
    idc.qexit(0)

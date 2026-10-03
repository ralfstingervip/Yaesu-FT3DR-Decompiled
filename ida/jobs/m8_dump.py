# -*- coding: utf-8 -*-
r"""Lane M8 read-only dumper (MAIN h8sxa or SUB rx). Copy of l8_dump.py, generalised.
Request file in env M8_REQ, output to env M8_OUT. Commands (hex addresses):
  dis LO HI [label]   disassemble [LO,HI) with raw bytes
  func EA [label]     whole function containing EA
  xref ADDR           code+data xrefs (MAIN also tries FFFF0000|lo16, FF0000|lo16, FFFFFF00|lo8)
  callers EA          xrefs to the function start of EA
  dw LO N             BE/LE dwords per processor
  grep REGEX          regex over disasm text of every code head in the image range
No database changes. MAIN window 0x078106-0x07B753 skipped."""
from __future__ import annotations
import os, re, traceback
import ida_auto, idc, ida_bytes, ida_funcs, idautils, ida_ida

REQ = os.environ.get("M8_REQ", "")
OUT = os.environ.get("M8_OUT", "")
IS_SUB = ida_ida.inf_get_procname().lower().startswith("rx")
WIN = (0x078106, 0x07B754) if not IS_SUB else (1, 0)
LO_IMG, HI_IMG = (0xFFC00000, 0xFFFFFFFF) if IS_SUB else (0, 0x80000)


def inwin(ea):
    return WIN[0] <= ea < WIN[1]


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return "-"
    return "%s@%06X" % (ida_funcs.get_func_name(f.start_ea), f.start_ea)


def line(ea):
    d = idc.generate_disasm_line(ea, 0) or ""
    sz = idc.get_item_size(ea)
    raw = ida_bytes.get_bytes(ea, min(sz, 10)) or b""
    return "%06X  %-30s  %s" % (ea, " ".join("%02x" % b for b in raw), d)


def disrange(lo, hi):
    out = []
    ea = lo
    while ea < hi and ea != idc.BADADDR:
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


def xrefs(addr):
    cands = {addr}
    if not IS_SUB:
        cands |= {0xFFFF0000 | (addr & 0xFFFF), 0xFF0000 | (addr & 0xFFFF)}
        if (addr & 0xFFFF00) == 0xFFFF00:
            cands.add(0xFFFFFF00 | (addr & 0xFF))
    res = []
    for a in sorted(cands):
        for x in idautils.XrefsTo(a, 0):
            res.append((x.frm, a, x.type))
    return res


def main():
    ida_auto.auto_wait()
    out = []
    for raw in open(REQ, encoding="utf-8"):
        raw = raw.strip()
        if not raw or raw.startswith("#"):
            continue
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
                out.append("### func %s %06X-%06X %s" % (fname(ea), f.start_ea, f.end_ea, " ".join(p[2:])))
                out += disrange(f.start_ea, f.end_ea)
            else:
                out.append("### func %06X: no function" % ea)
        elif cmd == "xref":
            a = int(p[1], 16)
            out.append("### xref %X" % a)
            for frm, tgt, t in xrefs(a):
                out.append("%06X  ->%08X t%d  %-24s %s" % (frm, tgt, t, fname(frm), idc.generate_disasm_line(frm, 0) or ""))
        elif cmd == "dw":
            lo, n = int(p[1], 16), int(p[2], 0)
            out.append("### dw %06X x%d" % (lo, n))
            for i in range(n):
                v = ida_bytes.get_dword(lo + 4 * i)
                out.append("%06X [%02X] %08X  %s" % (lo + 4 * i, i, v, fname(v)))
        elif cmd == "callers":
            ea = int(p[1], 16)
            f = ida_funcs.get_func(ea)
            s = f.start_ea if f else ea
            out.append("### callers %06X" % s)
            for x in idautils.XrefsTo(s, 0):
                out.append("%06X  t%d  %-24s %s" % (x.frm, x.type, fname(x.frm), idc.generate_disasm_line(x.frm, 0) or ""))
        elif cmd == "grep":
            rx = re.compile(" ".join(p[1:]), re.I)
            out.append("### grep %s" % rx.pattern)
            ea = LO_IMG
            while ea < HI_IMG and ea != idc.BADADDR:
                if inwin(ea):
                    ea = WIN[1]
                    continue
                if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                    d = idc.generate_disasm_line(ea, 0) or ""
                    if rx.search(d):
                        out.append("%06X  %-24s %s" % (ea, fname(ea), d))
                n = idc.next_head(ea, HI_IMG)
                if n <= ea or n == idc.BADADDR:
                    break
                ea = n
        out.append("")
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(out))


try:
    main()
except Exception:
    with open(OUT + ".tb.txt", "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane K11 generic read-only dumper (MAIN, h8sxa). Reads a request file
(env K11_REQ) with one command per line and writes text to env K11_OUT.
Commands:
  dis LO HI [label]     disassemble [LO,HI) with raw bytes
  func EA [label]       disassemble the whole function containing EA
  xref ADDR             code+data xrefs to ADDR (tries ADDR, 0xFFFF0000|lo16, 0xFF0000|lo16)
  grep REGEX            regex over every head's disasm text in 0..0x80000 (skips window)
  callers EA            code xrefs to function start of EA, with caller function names
No database changes except none; read-only queries. Window 0x078106-0x07B753 skipped."""
from __future__ import annotations
import os, re, traceback
import ida_auto, idc, ida_bytes, ida_funcs, ida_xref, idautils

REQ = os.environ.get("K11_REQ", "")
OUT = os.environ.get("K11_OUT", "")
WIN = (0x078106, 0x07B754)


def inwin(ea):
    return WIN[0] <= ea < WIN[1]


def line(ea):
    d = idc.generate_disasm_line(ea, 0) or ""
    sz = idc.get_item_size(ea)
    raw = ida_bytes.get_bytes(ea, min(sz, 10)) or b""
    fn = ida_funcs.get_func(ea)
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


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return "-"
    return "%s@%06X" % (ida_funcs.get_func_name(f.start_ea), f.start_ea)


def xrefs(addr):
    res = []
    cands = {addr, 0xFFFF0000 | (addr & 0xFFFF), 0xFF0000 | (addr & 0xFFFF), 0xFFFFFF00 | (addr & 0xFF)}
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
            ea = 0
            while ea < 0x80000 and ea != idc.BADADDR:
                if inwin(ea):
                    ea = WIN[1]
                    continue
                if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                    d = idc.generate_disasm_line(ea, 0) or ""
                    if rx.search(d):
                        out.append("%06X  %-24s %s" % (ea, fname(ea), d))
                n = idc.next_head(ea, 0x80000)
                if n <= ea:
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

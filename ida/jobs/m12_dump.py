# -*- coding: utf-8 -*-
r"""Lane M12 read-only dumper (copy of l10_dump.py plus funcs) (MAIN h8sxa or SUB rx). Request file env M12_REQ,
output env M12_OUT. No database edits.
Commands:
  dis LO HI [label]       disassemble [LO,HI) with raw bytes
  func EA [label]         whole function containing EA
  xref ADDR               code+data xrefs to ADDR (MAIN: also 0xFFFF0000|lo16 forms)
  callers EA              code xrefs to the function start of EA
  refrange LO HI          every code head whose operand addr/value (24-bit normalised on MAIN)
                          falls in [LO,HI]; scans 0..0x80000 (MAIN) or whole image (SUB)
  grep REGEX              regex over disasm text of every code head
  imm VALUE               code heads with an operand value == VALUE (exact, any width)
MAIN window 0x078106-0x07B753 skipped."""
from __future__ import annotations
import os, re, traceback
import ida_auto, idc, ida_bytes, ida_funcs, idautils, ida_ua, ida_ida

REQ = os.environ.get("M12_REQ", "")
OUT = os.environ.get("M12_OUT", "")
IS_SUB = ida_ida.inf_get_min_ea() >= 0xFF000000
LO_IMG = 0xFFC00000 if IS_SUB else 0
HI_IMG = 0x100000000 if IS_SUB else 0x80000
WIN = (0x078106, 0x07B754) if not IS_SUB else (1, 0)


def inwin(ea):
    return WIN[0] <= ea < WIN[1]


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return "-"
    return "%s@%X" % (ida_funcs.get_func_name(f.start_ea), f.start_ea)


def line(ea):
    d = idc.generate_disasm_line(ea, 0) or ""
    sz = idc.get_item_size(ea)
    raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
    return "%06X  %-36s  %s" % (ea, " ".join("%02x" % b for b in raw), d)


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


def heads():
    ea = LO_IMG
    while ea < HI_IMG and ea != idc.BADADDR:
        if inwin(ea):
            ea = WIN[1]
            continue
        if ida_bytes.is_code(ida_bytes.get_flags(ea)):
            yield ea
        n = idc.next_head(ea, HI_IMG)
        if n <= ea or n == idc.BADADDR:
            break
        ea = n


def opvals(ea):
    insn = ida_ua.insn_t()
    if not ida_ua.decode_insn(insn, ea):
        return []
    vals = []
    for op in insn.ops:
        if op.type == 0:
            break
        for v in (op.addr, op.value):
            v &= 0xFFFFFFFF
            if not IS_SUB:
                if v & 0xFFFF0000 == 0xFFFF0000 or v & 0xFFFF8000 == 0xFFFF8000:
                    v = 0xFF0000 | (v & 0xFFFF)
                v &= 0xFFFFFF
            vals.append(v)
    return vals


def xrefs(addr):
    res = []
    cands = {addr}
    if not IS_SUB:
        cands |= {0xFFFF0000 | (addr & 0xFFFF), 0xFF0000 | (addr & 0xFFFF)}
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
            out.append("### dis %X-%X %s" % (lo, hi, " ".join(p[3:])))
            out += disrange(lo, hi)
        elif cmd == "func":
            ea = int(p[1], 16)
            f = ida_funcs.get_func(ea)
            if f:
                out.append("### func %s %X-%X %s" % (fname(ea), f.start_ea, f.end_ea, " ".join(p[2:])))
                out += disrange(f.start_ea, f.end_ea)
            else:
                out.append("### func %X: no function" % ea)
        elif cmd == "xref":
            a = int(p[1], 16)
            out.append("### xref %X" % a)
            for frm, tgt, t in xrefs(a):
                out.append("%06X  ->%08X t%d  %-24s %s" % (frm, tgt, t, fname(frm), idc.generate_disasm_line(frm, 0) or ""))
        elif cmd == "callers":
            ea = int(p[1], 16)
            f = ida_funcs.get_func(ea)
            s = f.start_ea if f else ea
            out.append("### callers %X" % s)
            for x in idautils.XrefsTo(s, 0):
                out.append("%06X  t%d  %-24s %s" % (x.frm, x.type, fname(x.frm), idc.generate_disasm_line(x.frm, 0) or ""))
        elif cmd == "refrange":
            lo, hi = int(p[1], 16), int(p[2], 16)
            out.append("### refrange %X-%X" % (lo, hi))
            for ea in heads():
                hit = [v for v in opvals(ea) if lo <= v <= hi]
                if hit:
                    out.append("%s  | %-24s ref=%X" % (line(ea), fname(ea), hit[0]))
        elif cmd == "imm":
            v0 = int(p[1], 16)
            out.append("### imm %X" % v0)
            for ea in heads():
                if v0 in opvals(ea):
                    out.append("%s  | %s" % (line(ea), fname(ea)))
        elif cmd == "funcs":
            lo, hi = int(p[1], 16), int(p[2], 16)
            out.append("### funcs %X-%X" % (lo, hi))
            for fea in idautils.Functions(lo, hi):
                f = ida_funcs.get_func(fea)
                out.append("%08X %08X %s" % (f.start_ea, f.end_ea, ida_funcs.get_func_name(fea)))
        elif cmd == "grep":
            rx = re.compile(" ".join(p[1:]), re.I)
            out.append("### grep %s" % rx.pattern)
            for ea in heads():
                d = idc.generate_disasm_line(ea, 0) or ""
                if rx.search(d):
                    out.append("%06X  %-24s %s" % (ea, fname(ea), d))
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

# -*- coding: utf-8 -*-
r"""Lane L96 read-only dumper (MAIN, h8sxa). Request file env L96_REQ,
output env L96_OUT. Commands: dis, func, xref, callers, grep (same as k11).
Always appends an operand scan of code heads 0..0x80000 for FF800E..FF8011.
Skips the closed window 0x078106-0x07B753. No database writes."""
from __future__ import annotations
import os, re, traceback
import ida_auto, idc, ida_bytes, ida_funcs, ida_ua, idautils

REQ = os.environ.get("L96_REQ", "")
OUT = os.environ.get("L96_OUT", "")
WIN = (0x078106, 0x07B754)
LO16 = {0x800E, 0x800F, 0x8010, 0x8011}
FULL = set()
for a in LO16:
    FULL.add(a)
    FULL.add(0xFF0000 | a)
    FULL.add(0xFFFF0000 | a)


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
    cands = {addr, 0xFFFF0000 | (addr & 0xFFFF), 0xFF0000 | (addr & 0xFFFF)}
    for a in sorted(cands):
        for x in idautils.XrefsTo(a, 0):
            res.append((x.frm, a, x.type))
    return res


def op_hit(op):
    if op.type in (ida_ua.o_void, ida_ua.o_reg, ida_ua.o_phrase):
        return False
    for v in (op.addr & 0xFFFFFFFF, op.value & 0xFFFFFFFF):
        if v in FULL:
            return True
    return False


def scan():
    out = []
    rx = re.compile(r"(?<![0-9A-Fa-f])(?:FFFF)?80(?:0[EeFf]|1[01])(?![0-9A-Fa-f])", re.I)
    ea = 0
    n_code = 0
    while ea < 0x80000 and ea != idc.BADADDR:
        if inwin(ea):
            ea = WIN[1]
            continue
        if ida_bytes.is_code(ida_bytes.get_flags(ea)):
            n_code += 1
            d = idc.generate_disasm_line(ea, 0) or ""
            insn = ida_ua.insn_t()
            n = ida_ua.decode_insn(insn, ea)
            hit = False
            why = ""
            if n > 0:
                for i in range(8):
                    op = insn.ops[i]
                    if op.type == ida_ua.o_void:
                        break
                    if op_hit(op):
                        hit = True
                        why = "op%d t%d a=%X v=%X" % (i, op.type, op.addr & 0xFFFFFFFF, op.value & 0xFFFFFFFF)
                        break
            if not hit and rx.search(d):
                hit = True
                why = "text"
            if hit:
                out.append("%s  %s" % (line(ea), why))
        nxa = idc.next_head(ea, 0x80000)
        if nxa <= ea:
            break
        ea = nxa
    out.insert(0, "### scan heads code=%d window %06X-%06X skipped" % (n_code, WIN[0], WIN[1]))
    return out


def main():
    ida_auto.auto_wait()
    out = []
    if REQ and os.path.isfile(REQ):
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
                    if inwin(frm):
                        continue
                    out.append("%06X  ->%08X t%d  %-24s %s" % (frm, tgt, t, fname(frm), idc.generate_disasm_line(frm, 0) or ""))
            elif cmd == "callers":
                ea = int(p[1], 16)
                f = ida_funcs.get_func(ea)
                s = f.start_ea if f else ea
                out.append("### callers %06X" % s)
                for x in idautils.XrefsTo(s, 0):
                    if inwin(x.frm):
                        continue
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
    out += scan()
    out.append("")
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(out))


try:
    main()
except Exception:
    err = (OUT or "l96") + ".tb.txt"
    with open(err, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

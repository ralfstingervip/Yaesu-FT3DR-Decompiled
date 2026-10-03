# -*- coding: utf-8 -*-
r"""Lane L9. Read-only generic dumper (MAIN, h8sxa, base 0). DSP opcode 1C 03,
T4 carrier length, B0B9=0x1E chain. Commands from env L9_CMDS; output env L9_OUT.
  func  <ea>            dump whole function containing ea (+ code xrefs to its start)
  range <lo> <hi>       dump a linear range
  xref  <ea>            every xref (code+data) to ea; RAM: tries 0xFFFFxxxx too
  bytes <lo> <n>        raw hex
Nothing is modified except IDA's DB state (no patching)."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, idc, ida_bytes, ida_funcs, ida_xref, idautils

CMDS = os.environ.get("L9_CMDS", "")
OUT = os.environ.get("L9_OUT", "")


def disrange(lo, hi):
    out = []
    ea = lo
    while ea < hi and ea != idc.BADADDR:
        d = idc.generate_disasm_line(ea, 0) or ""
        sz = max(1, idc.get_item_size(ea))
        raw = ida_bytes.get_bytes(ea, min(sz, 10)) or b""
        out.append("%06X  %-30s  %s" % (ea, " ".join("%02x" % b for b in raw), d))
        n = idc.next_head(ea, hi)
        if n <= ea:
            break
        ea = n
    return out


def fname(ea):
    f = ida_funcs.get_func(ea)
    return ("%s@%06X" % (ida_funcs.get_func_name(f.start_ea), f.start_ea)) if f else "-"


def xrefs(ea):
    res = []
    for x in idautils.XrefsTo(ea, 0):
        res.append("  %06X  t=%d  %s  | %s" % (x.frm, x.type, fname(x.frm), idc.generate_disasm_line(x.frm, 0) or ""))
    return res


def main():
    ida_auto.auto_wait()
    lines = open(CMDS, encoding="utf-8").read().splitlines()
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        for ln in lines:
            p = ln.split()
            if not p or p[0].startswith("#"):
                continue
            c = p[0]
            if c == "func":
                ea = int(p[1], 16)
                f = ida_funcs.get_func(ea)
                lo, hi = (f.start_ea, f.end_ea) if f else (ea, ea + 0x80)
                h.write("### func %06X-%06X %s\n" % (lo, hi, fname(lo)))
                h.write("xrefs to start:\n" + "\n".join(xrefs(lo)) + "\n")
                h.write("\n".join(disrange(lo, hi)) + "\n\n")
            elif c == "range":
                lo, hi = int(p[1], 16), int(p[2], 16)
                h.write("### range %06X-%06X\n" % (lo, hi))
                h.write("\n".join(disrange(lo, hi)) + "\n\n")
            elif c == "xref":
                ea = int(p[1], 16)
                h.write("### xref %X\n" % ea)
                cands = {ea}
                if 0xB000 <= ea <= 0xFFFF:
                    cands.add(0xFFFF0000 | ea)
                    cands.add(0xFF000000 | ea)
                if 0xFF0000 <= ea <= 0xFFFFFF:
                    cands.add(0xFF000000 | ea)
                for e in sorted(cands):
                    r = xrefs(e)
                    if r:
                        h.write("[%X]\n" % e + "\n".join(r) + "\n")
                h.write("\n")
            elif c == "bytes":
                lo, n = int(p[1], 16), int(p[2], 16)
                b = ida_bytes.get_bytes(lo, n) or b""
                h.write("### bytes %06X +%X\n" % (lo, n))
                for i in range(0, len(b), 16):
                    h.write("%06X  %s\n" % (lo + i, " ".join("%02x" % x for x in b[i:i+16])))
                h.write("\n")


try:
    main()
except Exception:
    with open((OUT or str(_REPO / "ida/out/dsp-1c03/l9_tb.txt")) + ".tb", "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

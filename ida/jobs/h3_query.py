# -*- coding: utf-8 -*-
r"""Lane H3 query (read-only): for each 'addr[:end]' in env H3_ADDRS dump the
containing function, xrefs to addr, and disassembly addr..end (or function end).
Output ida\out\ptr-arrays\query_<H3_TAG>.txt"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, idautils, idc
ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "ptr-arrays")
TAG = os.environ.get("H3_TAG", "q")


def main():
    ida_auto.auto_wait()
    L = []
    for item in os.environ.get("H3_ADDRS", "").split(","):
        if not item:
            continue
        a, _, e = item.partition(":")
        a = int(a, 16)
        f = ida_funcs.get_func(a)
        end = int(e, 16) if e else (f.end_ea if f else a + 0x40)
        L.append("=== %06X  func=%s  crefs=%s  drefs=%s" % (
            a, "%06X-%06X" % (f.start_ea, f.end_ea) if f else "-",
            ",".join("%06X" % x for x in idautils.CodeRefsTo(a, 0)),
            ",".join("%06X" % x for x in idautils.DataRefsTo(a))))
        ea = a
        n = 0
        while ea < end and n < 400:
            fl = ida_bytes.get_flags(ea)
            sz = ida_bytes.get_item_size(ea) if ida_bytes.is_head(fl) else 1
            if sz <= 0:
                sz = 1
            L.append("  %06X  %-20s %s" % (ea, ida_bytes.get_bytes(ea, min(sz, 10)).hex(),
                                          idc.generate_disasm_line(ea, 0) if ida_bytes.is_head(fl) else "(tail/unk)"))
            ea += sz
            n += 1
    with open(os.path.join(OUT, "query_%s.txt" % TAG), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(L) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(OUT, "query_%s_tb.txt" % TAG), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane L3 - read-only xref/disassembly dump for the fnindex-only runs 0x030000-0x04FFFF.

Owner-side static analysis. No byte is patched and no DB item is changed. For every run in
ida\out\main-final4\fnindex-only-runs.tsv with 0x030000 <= start < 0x050000 it writes, per code head:
ea, size, bytes, disassembly, containing function, and every XrefsTo (code and data) of every byte
address in the run whose source lies outside the run. Also dumps 0x40 bytes of context before each run.

  python ida\run_job.py --script ida\jobs\l3_fnidx_xrefs.py --db L3_FNIDX_MID --copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64
  python ida\run_job.py --script ida\jobs\l3_fnidx_xrefs.py --db L3_FNIDX_MID --reopen
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_xref, ida_ua, ida_name, idautils, idc, ida_lines

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "fnindex-mid", "work")
os.makedirs(OUT, exist_ok=True)


def runs():
    rows = []
    with open(os.path.join(ROOT, "ida", "out", "main-final4", "fnindex-only-runs.tsv"), encoding="utf-8") as h:
        for ln in h:
            if ln.startswith("#") or ln.startswith("start"): continue
            c = ln.rstrip("\n").split("\t")
            s, e = int(c[0], 16), int(c[1], 16)
            if 0x30000 <= s < 0x50000: rows.append((s, e))
    return rows


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f: return "-"
    return "%s@%06X-%06X" % (ida_name.get_ea_name(f.start_ea) or "?", f.start_ea, f.end_ea)


def disasm(ea):
    return ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")


def main():
    ida_auto.auto_wait()
    R = runs()
    with open(os.path.join(OUT, "l3_ida_heads.tsv"), "w", encoding="utf-8") as hh, \
         open(os.path.join(OUT, "l3_ida_xrefs.tsv"), "w", encoding="utf-8") as hx:
        hh.write("run\tea\tsize\tbytes\tisCode\tfunc\tdisasm\n")
        hx.write("run\tto\tfrom\ttype\tiscode_from\tfrom_func\tfrom_disasm\n")
        for s, e in R:
            ea = s
            while ea < e:
                fl = ida_bytes.get_flags(ea)
                n = ida_bytes.get_item_size(ea) if ida_bytes.is_head(fl) else 1
                n = max(1, n)
                hh.write("%06X\t%06X\t%d\t%s\t%d\t%s\t%s\n" % (s, ea, n, ida_bytes.get_bytes(ea, n).hex(),
                         int(ida_bytes.is_code(fl)), fname(ea), disasm(ea).replace("\t", " ")))
                ea += n
            for to in range(s, e):
                for x in idautils.XrefsTo(to, 0):
                    if s <= x.frm < e: continue
                    hx.write("%06X\t%06X\t%06X\t%s\t%d\t%s\t%s\n" % (s, to, x.frm, idautils.XrefTypeName(x.type),
                             int(ida_bytes.is_code(ida_bytes.get_flags(x.frm))), fname(x.frm), disasm(x.frm).replace("\t", " ")))
        # context before each run
    with open(os.path.join(OUT, "l3_ida_context.txt"), "w", encoding="utf-8") as hc:
        for s, e in R:
            hc.write("== run %06X-%06X\n" % (s, e))
            ea = idc.prev_head(s, 0)
            for _ in range(6): ea = idc.prev_head(ea, 0)
            while ea < s + 0x10 and ea != idc.BADADDR:
                fl = ida_bytes.get_flags(ea); n = max(1, ida_bytes.get_item_size(ea))
                hc.write("  %06X %-20s %s\n" % (ea, ida_bytes.get_bytes(ea, n).hex()[:20], disasm(ea)))
                ea = idc.next_head(ea, idc.BADADDR)
    with open(os.path.join(OUT, "l3_ida_done.txt"), "w", encoding="utf-8") as h:
        h.write("ok %d runs\n" % len(R))


try:
    main()
except Exception:
    with open(os.path.join(OUT, "l3_ida_traceback.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

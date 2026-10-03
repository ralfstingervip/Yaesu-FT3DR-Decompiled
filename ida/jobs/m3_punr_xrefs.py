# -*- coding: utf-8 -*-
r"""Lane M3 - read-only xref/head dump for the 22 proven-unreached runs 0x030000-0x057FFF and their companion blocks.

Owner-side static analysis. No byte is patched and no DB item is changed (no set/make/del calls).
For every range it writes each IDA head (ea, size, bytes, isCode, containing func, disasm) and every XrefsTo of every
byte whose source lies outside that range.

  python ida\run_job.py --script ida\jobs\m3_punr_xrefs.py --db M3_PUNR_MID --copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64
  python ida\run_job.py --script ida\jobs\m3_punr_xrefs.py --db M3_PUNR_MID --reopen
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_name, idautils, idc, ida_lines

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "punr-mid", "work")
COMP = [(0x033494, 0x03349A), (0x03D1C6, 0x03D1C8), (0x045D18, 0x045D1E), (0x04B7F4, 0x04B812), (0x04BACE, 0x04BAF4),
        (0x04C02A, 0x04C050), (0x050C68, 0x050C9C), (0x04F82A, 0x04F836), (0x03EF64, 0x03EF68), (0x03EFA4, 0x03EFA8),
        (0x03EFE4, 0x03EFE8), (0x04F538, 0x04F53A)]


def runs():
    rows = []
    with open(os.path.join(ROOT, "ida", "out", "l-wave-recon", "proven-unreached-runs.tsv"), encoding="utf-8") as h:
        for ln in h:
            if ln.startswith("#") or ln.startswith("start"): continue
            c = ln.rstrip("\n").split("\t")
            s, e = int(c[0], 16), int(c[1], 16)
            if 0x30000 <= s < 0x58000: rows.append((s, e, "run"))
    return rows + [(s, e, "companion") for s, e in COMP]


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f: return "-"
    return "%s@%06X-%06X" % (ida_name.get_ea_name(f.start_ea) or "?", f.start_ea, f.end_ea)


def disasm(ea):
    return ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")


def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    R = runs()
    with open(os.path.join(OUT, "m3_ida_heads.tsv"), "w", encoding="utf-8", newline="\n") as hh, \
         open(os.path.join(OUT, "m3_ida_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as hx:
        hh.write("range\tkind\tea\tsize\tbytes\tisCode\tfunc\tdisasm\n")
        hx.write("range\tkind\tto\tfrom\ttype\tiscode_from\tfrom_func\tfrom_disasm\n")
        for s, e, k in R:
            ea = s
            while ea < e:
                fl = ida_bytes.get_flags(ea)
                n = ida_bytes.get_item_size(ea) if ida_bytes.is_head(fl) else 1
                n = max(1, n)
                hh.write("%06X\t%s\t%06X\t%d\t%s\t%d\t%s\t%s\n" % (s, k, ea, n, ida_bytes.get_bytes(ea, n).hex(),
                         int(ida_bytes.is_code(fl)), fname(ea), disasm(ea).replace("\t", " ")))
                ea += n
            for to in range(s, e):
                for x in idautils.XrefsTo(to, 0):
                    if s <= x.frm < e: continue
                    hx.write("%06X\t%s\t%06X\t%06X\t%s\t%d\t%s\t%s\n" % (s, k, to, x.frm, idautils.XrefTypeName(x.type),
                             int(ida_bytes.is_code(ida_bytes.get_flags(x.frm))), fname(x.frm), disasm(x.frm).replace("\t", " ")))
    with open(os.path.join(OUT, "m3_ida_done.txt"), "w", encoding="utf-8") as h:
        h.write("ok %d ranges\n" % len(R))


try:
    main()
except Exception:
    with open(os.path.join(OUT, "m3_ida_traceback.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

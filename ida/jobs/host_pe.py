r"""HOST-USB: generic x86 PE analysis + Hex-Rays decompilation dump.

Env:
  YAESU_JOB        database name (set by run_job.py), used for the output dir
  HOST_OUT         output directory (default ida/out/host-usb/<JOB>)
  HOST_DECOMPILE   "all" | "named" | "none"   (default "all")
  HOST_MAXFUNC     skip decompiling functions larger than this (default 60000)

Writes functions.tsv, strings.tsv, imports.tsv, exports.tsv, data_xrefs.tsv
and decomp.c into HOST_OUT. Never touches shared databases.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import sys
import traceback

import ida_auto
import ida_bytes
import ida_entry
import ida_funcs
import ida_ida
import ida_name
import ida_nalt
import ida_segment
import ida_typeinf
import idautils
import idc

JOB = os.environ.get("YAESU_JOB", "HOST")
OUT = os.environ.get("HOST_OUT") or os.path.join(str(_REPO / "ida/out/host-usb"), JOB)
MODE = os.environ.get("HOST_DECOMPILE", "all").lower()
MAXFUNC = int(os.environ.get("HOST_MAXFUNC", "60000"))


def w(path, text):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", errors="replace", newline="\n") as fh:
        fh.write(text)


def demangle(name):
    d = ida_name.demangle_name(name, idc.get_inf_attr(idc.INF_SHORT_DEMNAMES))
    return d if d else ""


def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()

    lines = ["job\t%s" % JOB,
             "input\t%s" % ida_nalt.get_root_filename(),
             "proc\t%s" % ida_ida.inf_get_procname(),
             "min\t%#x" % ida_ida.inf_get_min_ea(),
             "max\t%#x" % ida_ida.inf_get_max_ea()]
    for s in idautils.Segments():
        seg = ida_segment.getseg(s)
        lines.append("seg\t%s\t%#x\t%#x" % (ida_segment.get_segm_name(seg), seg.start_ea, seg.end_ea))
    w("status.txt", "\n".join(lines) + "\n")

    # ---- functions -------------------------------------------------------
    funcs = []
    rows = ["ea\tend\tsize\tname\tdemangled"]
    for ea in idautils.Functions():
        f = ida_funcs.get_func(ea)
        if not f:
            continue
        n = ida_funcs.get_func_name(ea) or ""
        funcs.append((ea, f.end_ea, n))
        rows.append("%X\t%X\t%d\t%s\t%s" % (ea, f.end_ea, f.end_ea - ea, n, demangle(n)))
    w("functions.tsv", "\n".join(rows) + "\n")

    # ---- exports ---------------------------------------------------------
    rows = ["index\tordinal\tea\tname\tdemangled"]
    for i in range(ida_entry.get_entry_qty()):
        ordv = ida_entry.get_entry_ordinal(i)
        ea = ida_entry.get_entry(ordv)
        n = ida_entry.get_entry_name(ordv) or ""
        rows.append("%d\t%d\t%X\t%s\t%s" % (i, ordv, ea, n, demangle(n)))
    w("exports.tsv", "\n".join(rows) + "\n")

    # ---- imports ---------------------------------------------------------
    rows = ["module\tea\tname\tordinal"]

    def imp_cb(ea, name, ordv):
        rows.append("%s\t%X\t%s\t%s" % (imp_cb.mod, ea, name or "", ordv if ordv else ""))
        return True

    for i in range(ida_nalt.get_import_module_qty()):
        imp_cb.mod = ida_nalt.get_import_module_name(i) or "?"
        ida_nalt.enum_import_names(i, imp_cb)
    w("imports.tsv", "\n".join(rows) + "\n")

    # ---- strings + who references them -----------------------------------
    import ida_strlist
    ida_strlist.build_strlist()
    srows = ["ea\tlen\ttype\ttext"]
    xrows = ["str_ea\tfrom_ea\tfrom_func\ttext"]
    qty = ida_strlist.get_strlist_qty()
    for i in range(qty):
        si = ida_strlist.string_info_t()
        if not ida_strlist.get_strlist_item(si, i):
            continue
        txt = ida_bytes.get_strlit_contents(si.ea, si.length, si.type)
        txt = (txt or b"").decode("utf-8", "replace").replace("\t", "\\t").replace("\n", "\\n").replace("\r", "\\r")
        srows.append("%X\t%d\t%d\t%s" % (si.ea, si.length, si.type, txt))
        for fr in idautils.DataRefsTo(si.ea):
            fn = ida_funcs.get_func_name(fr) or ""
            xrows.append("%X\t%X\t%s\t%s" % (si.ea, fr, fn, txt))
        for fr in idautils.CodeRefsTo(si.ea, 0):
            fn = ida_funcs.get_func_name(fr) or ""
            xrows.append("%X\t%X\t%s\t%s" % (si.ea, fr, fn, txt))
    w("strings.tsv", "\n".join(srows) + "\n")
    w("data_xrefs.tsv", "\n".join(xrows) + "\n")

    # ---- decompile -------------------------------------------------------
    if MODE == "none":
        idc.qexit(0)

    import ida_hexrays
    ok = ida_hexrays.init_hexrays_plugin()
    log = ["hexrays_init %s" % ok]
    if not ok:
        w("decomp.log", "\n".join(log) + "\n")
        idc.qexit(0)

    chunks = []
    nok = nfail = nskip = 0
    for ea, end, name in funcs:
        if MODE == "named" and (name.startswith("sub_") or name.startswith("nullsub")):
            nskip += 1
            continue
        if end - ea > MAXFUNC:
            nskip += 1
            log.append("skip_big %X %s %d" % (ea, name, end - ea))
            continue
        try:
            cf = ida_hexrays.decompile(ea)
        except Exception as exc:
            cf = None
            log.append("exc %X %s %s" % (ea, name, exc))
        if cf is None:
            nfail += 1
            log.append("fail %X %s" % (ea, name))
            continue
        nok += 1
        chunks.append("/* ==== %X  %s  (%s)  size=%d ==== */\n%s\n" %
                      (ea, name, demangle(name), end - ea, str(cf)))
    log.insert(0, "decompiled %d fail %d skip %d" % (nok, nfail, nskip))
    w("decomp.c", "\n".join(chunks))
    w("decomp.log", "\n".join(log) + "\n")


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

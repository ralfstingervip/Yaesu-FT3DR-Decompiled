r"""WIRELESS agent: generic force-disassemble + range dump driver.

Reads a control file of ranges (one per line: `START END LABEL`) from
WL_RANGES (default ida\out\wireless\ranges.txt), forces code creation across
each range, runs auto analysis, then writes a disassembly listing per label
into ida\out\wireless\lst\<LABEL>.lst.

Also writes a function table and, when WL_REFS names a file of hex addresses,
an xref report for each.

Launch only through run_job.py with --db WL_SUB or WL_MAIN.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_lines
import ida_name
import ida_segment
import ida_ua
import ida_xref
import idautils
import idc

OUT = str(_REPO / "ida/out/wireless")
LST = os.path.join(OUT, "lst")
JOB = os.environ.get("YAESU_JOB", "WL")
LOG = os.path.join(OUT, "%s_dump_log.txt" % JOB)


def log(text):
    with open(LOG, "a", encoding="utf-8", newline="\n") as h:
        h.write(str(text) + "\n")


def force_range(start, end):
    """Undefine data and create instructions/functions across [start, end)."""
    made_insn = 0
    made_func = 0
    ea = start
    while ea < end:
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags):
            item = ida_bytes.get_item_end(ea)
            ea = item if item > ea else ea + 1
            continue
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
        length = ida_ua.create_insn(ea)
        if length <= 0:
            ea += 1
            continue
        made_insn += 1
        ea += length
    ida_auto.auto_wait()
    # promote code with no owning function
    ea = start
    while ea < end:
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags) and ida_funcs.get_func(ea) is None:
            if ida_funcs.add_func(ea):
                made_func += 1
                ida_auto.auto_wait()
        nxt = ida_bytes.get_item_end(ea)
        ea = nxt if nxt > ea else ea + 1
    ida_auto.auto_wait()
    return made_insn, made_func


def dump_range(start, end, label):
    path = os.path.join(LST, "%s_%s.lst" % (JOB, label))
    n = 0
    with open(path, "w", encoding="utf-8", newline="\n") as h:
        ea = start
        while ea < end:
            fn = ida_funcs.get_func(ea)
            if fn is not None and fn.start_ea == ea:
                h.write("\n; ======== %s  %08X\n" % (
                    ida_funcs.get_func_name(ea) or "?", ea))
            nm = ida_name.get_name(ea)
            if nm and (fn is None or fn.start_ea != ea):
                h.write("%s:\n" % nm)
            line = ida_lines.generate_disasm_line(ea, 0)
            text = ida_lines.tag_remove(line) if line else "?"
            size = ida_bytes.get_item_size(ea)
            raw = ida_bytes.get_bytes(ea, min(size, 12)) or b""
            h.write("%08X  %-26s %s\n" % (ea, raw.hex(), text))
            n += 1
            ea += size if size > 0 else 1
    return path, n


def xref_report(addrs):
    path = os.path.join(OUT, "%s_xrefs.tsv" % JOB)
    with open(path, "w", encoding="utf-8", newline="\n") as h:
        h.write("target\tfrom\tkind\tfunction\tdisasm\n")
        for ea in addrs:
            wrote = False
            for xr in idautils.XrefsTo(ea, 0):
                fn = ida_funcs.get_func(xr.frm)
                line = ida_lines.generate_disasm_line(xr.frm, 0)
                h.write("%08X\t%08X\t%d\t%s\t%s\n" % (
                    ea, xr.frm, xr.type,
                    ida_funcs.get_func_name(xr.frm) if fn else "-",
                    ida_lines.tag_remove(line) if line else "?"))
                wrote = True
            if not wrote:
                h.write("%08X\t-\t-\t-\tno_xref\n" % ea)
    return path


def main():
    os.makedirs(LST, exist_ok=True)
    open(LOG, "w", encoding="utf-8").close()
    ida_auto.auto_wait()
    log("job %s proc %s min %#x max %#x" % (
        JOB, ida_ida.inf_get_procname(),
        ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
    log("functions at start %d" % len(list(idautils.Functions())))

    ctrl = os.environ.get("WL_RANGES", os.path.join(OUT, "ranges.txt"))
    ranges = []
    if os.path.isfile(ctrl):
        with open(ctrl, "r", encoding="utf-8") as h:
            for line in h:
                line = line.split("#", 1)[0].strip()
                if not line:
                    continue
                parts = line.split()
                if len(parts) >= 3:
                    ranges.append((int(parts[0], 16), int(parts[1], 16), parts[2]))
    log("ranges %d from %s" % (len(ranges), ctrl))

    force = os.environ.get("WL_FORCE", "1") == "1"
    for start, end, label in ranges:
        if force:
            i, f = force_range(start, end)
            log("force %s %08X-%08X insn %d func %d" % (label, start, end, i, f))
        path, n = dump_range(start, end, label)
        log("dump %s %d items -> %s" % (label, n, path))

    refs = os.environ.get("WL_REFS", "")
    if refs and os.path.isfile(refs):
        addrs = []
        with open(refs, "r", encoding="utf-8") as h:
            for line in h:
                line = line.split("#", 1)[0].strip()
                if line:
                    addrs.append(int(line, 16))
        log("xref targets %d -> %s" % (len(addrs), xref_report(addrs)))

    fpath = os.path.join(OUT, "%s_functions.tsv" % JOB)
    with open(fpath, "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tname\tsize\n")
        for ea in idautils.Functions():
            fn = ida_funcs.get_func(ea)
            h.write("%08X\t%08X\t%s\t%d\n" % (
                ea, fn.end_ea, ida_funcs.get_func_name(ea), fn.end_ea - ea))
    log("functions at end %d -> %s" % (len(list(idautils.Functions())), fpath))


try:
    main()
except Exception:
    log("TRACEBACK\n" + traceback.format_exc())
idc.qexit(0)

"""MAIN-IO pass 3: wide I/O operand scan (0xFF6000-0xFFFFFF), xref report for a
watch list, and disassembly dumps for dump_list.txt.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_idp
import ida_ua
import ida_xref
import idautils
import idc

OUT = str(_REPO / "ida/out/main-io")
LOG = os.path.join(OUT, "pass3_status.txt")
END = 0x7C000


def log(t):
    with open(LOG, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def wide_scan():
    """Every operand naming 0xFFE000-0xFFFFFF, plus 0xFF6000-0xFF6FFF."""
    rows = []
    counts = collections.Counter()
    byreg = collections.defaultdict(set)
    for fstart in idautils.Functions():
        func = ida_funcs.get_func(fstart)
        if func is None:
            continue
        fname = idc.get_func_name(fstart) or ""
        ea = func.start_ea
        while ea < func.end_ea:
            insn = ida_ua.insn_t()
            n = ida_ua.decode_insn(insn, ea)
            if n <= 0:
                ea += 2
                continue
            line = None
            for op in insn.ops:
                if op.type == ida_ua.o_void:
                    break
                if op.type in (ida_ua.o_mem, ida_ua.o_displ):
                    val = op.addr
                elif op.type == ida_ua.o_imm:
                    val = op.value
                else:
                    continue
                v = val & 0xFFFFFF
                if 0xFFE000 <= v <= 0xFFFFFF or 0xFF6000 <= v <= 0xFF6FFF:
                    if line is None:
                        line = idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or ""
                    rows.append((v, ea, fname, line))
                    counts[v] += 1
                    byreg[v].add(fname)
            ea += n
    with open(os.path.join(OUT, "ioreg_wide.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("reg\tea\tfunc\tdisasm\n")
        for v, ea, fname, line in sorted(rows):
            h.write("%06X\t%06X\t%s\t%s\n" % (v, ea, fname, line.replace("\t", " ")))
    with open(os.path.join(OUT, "ioreg_wide_hist.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("reg\tcount\tfuncs\n")
        for v in sorted(counts):
            h.write("%06X\t%d\t%s\n" % (v, counts[v], ",".join(sorted(byreg[v])[:20])))
    log("wide rows %d distinct %d" % (len(rows), len(counts)))


def xref_report():
    path = os.path.join(OUT, "watch.txt")
    if not os.path.isfile(path):
        log("no watch.txt")
        return
    with open(path, "r", encoding="utf-8") as h:
        watch = []
        for line in h:
            line = line.strip()
            if line and not line.startswith("#"):
                parts = line.split(None, 1)
                watch.append((int(parts[0], 16),
                              parts[1] if len(parts) > 1 else ""))
    with open(os.path.join(OUT, "xrefs_watch.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("target\tlabel\tfrom_ea\tfrom_func\ttype\tdisasm\n")
        for ea, label in watch:
            found = 0
            for xr in idautils.XrefsTo(ea, 0):
                f = ida_funcs.get_func(xr.frm)
                h.write("%06X\t%s\t%06X\t%s\t%d\t%s\n"
                        % (ea, label, xr.frm,
                           idc.get_func_name(f.start_ea) if f else "",
                           xr.type,
                           (idc.generate_disasm_line(xr.frm, idc.GENDSM_FORCE_CODE)
                            or "").replace("\t", " ")))
                found += 1
            if not found:
                h.write("%06X\t%s\t-\t-\t0\tNO_XREF\n" % (ea, label))
    log("xref report for %d targets" % len(watch))


def dumps():
    path = os.path.join(OUT, "dump_list3.txt")
    if not os.path.isfile(path):
        log("no dump_list3.txt")
        return
    with open(path, "r", encoding="utf-8") as h:
        jobs = []
        for line in h:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            p = line.split()
            jobs.append((int(p[0], 16), int(p[1], 16), p[2] if len(p) > 2 else "r"))
    with open(os.path.join(OUT, "disasm3.txt"), "w", encoding="utf-8",
              newline="\n") as h:
        for start, end, label in jobs:
            h.write("\n########## %s  %06X-%06X ##########\n" % (label, start, end))
            ea = start
            while ea < end:
                flags = ida_bytes.get_flags(ea)
                if not ida_bytes.is_code(flags):
                    if ida_bytes.is_unknown(flags):
                        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 2)
                    ida_ua.create_insn(ea)
                insn = ida_ua.insn_t()
                n = ida_ua.decode_insn(insn, ea)
                line = idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or ""
                raw = ida_bytes.get_bytes(ea, max(n, 2)) or b""
                mark = ""
                f = ida_funcs.get_func(ea)
                if f is not None and f.start_ea == ea:
                    mark = "  <<< %s" % (idc.get_func_name(ea) or "")
                else:
                    nm = idc.get_name(ea)
                    if nm:
                        mark = "  :%s" % nm
                h.write("%06X  %-18s %s%s\n"
                        % (ea, " ".join("%02X" % b for b in raw), line, mark))
                ea += n if n > 0 else 2
    log("disasm3 written for %d ranges" % len(jobs))


def main():
    os.makedirs(OUT, exist_ok=True)
    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write("proc %s\n" % (ida_idp.get_idp_name() or ""))
    try:
        ida_auto.auto_wait()
        if os.environ.get("MAINIO_WIDE", "1") == "1":
            wide_scan()
        xref_report()
        dumps()
        log("pass3_done")
        idc.qexit(0)
    except Exception:
        log("pass3_failed")
        log(traceback.format_exc())
        idc.qexit(1)


main()

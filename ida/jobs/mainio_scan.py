"""MAIN-IO pass 1: force coverage from pre-extracted call targets, then scan
every instruction operand that touches the H8S on-chip register page.

Launch only through run_job.py with --db MAIN_IO.
Outputs UTF-8 TSV under ida/out/main-io.
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
import ida_ida
import ida_idp
import ida_segment
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/main-io")
LOG = os.path.join(OUT, "pass1_status.txt")
END = 0x7C000


def log(text):
    with open(LOG, "a", encoding="utf-8", newline="\n") as h:
        h.write(text + "\n")


def seed(path, label):
    """Create instructions + functions at every address in a target list."""
    if not os.path.isfile(path):
        log("missing %s" % path)
        return 0
    made = 0
    addrs = []
    with open(path, "r", encoding="utf-8") as h:
        for line in h:
            line = line.strip()
            if line:
                addrs.append(int(line, 16))
    for ea in addrs:
        if ea >= END:
            continue
        f = ida_funcs.get_func(ea)
        if f is not None and f.start_ea == ea:
            continue
        if f is None:
            # not inside any function: undefine whatever is there and make code
            flags = ida_bytes.get_flags(ea)
            if not ida_bytes.is_code(flags):
                ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 2)
            if ida_ua.create_insn(ea) == 0:
                continue
        if ida_funcs.add_func(ea):
            made += 1
    log("%s seeded %d of %d" % (label, made, len(addrs)))
    return made


def sweep():
    """Second wave: after auto-analysis, turn remaining code-but-no-func into
    functions, and try to make code out of even-aligned gaps that decode."""
    ida_auto.auto_wait()
    extra = 0
    ea = 0x400
    while ea < END:
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags):
            if ida_funcs.get_func(ea) is None:
                if ida_funcs.add_func(ea):
                    extra += 1
            nxt = ida_bytes.next_head(ea, END)
            ea = nxt if nxt > ea else ea + 2
            continue
        ea += 2
    log("sweep orphan code -> funcs %d" % extra)
    ida_auto.auto_wait()


def operand_scan():
    """Every operand that names an address in the H8S I/O / RAM top range."""
    rows = []
    counts = collections.Counter()
    io_counts = collections.Counter()
    for fstart in idautils.Functions():
        func = ida_funcs.get_func(fstart)
        if func is None:
            continue
        fname = idc.get_func_name(fstart) or ""
        ea = func.start_ea
        while ea < func.end_ea:
            insn = ida_ua.insn_t()
            length = ida_ua.decode_insn(insn, ea)
            if length <= 0:
                ea += 2
                continue
            line = idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or ""
            for op in insn.ops:
                if op.type == ida_ua.o_void:
                    break
                val = None
                if op.type == ida_ua.o_mem:
                    val = op.addr
                elif op.type in (ida_ua.o_displ,):
                    val = op.addr
                elif op.type == ida_ua.o_imm:
                    val = op.value
                if val is None:
                    continue
                v24 = val & 0xFFFFFF
                if 0xFF0000 <= v24 <= 0xFFFFFF:
                    kind = {ida_ua.o_mem: "mem", ida_ua.o_displ: "displ",
                            ida_ua.o_imm: "imm"}[op.type]
                    rows.append((ea, fname, v24, kind, line))
                    counts[v24] += 1
                    if v24 >= 0xFFF000:
                        io_counts[v24] += 1
            ea += length
    with open(os.path.join(OUT, "io_operands.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("ea\tfunc\ttarget\tkind\tdisasm\n")
        for ea, fname, v24, kind, line in rows:
            h.write("%06X\t%s\t%06X\t%s\t%s\n"
                    % (ea, fname, v24, kind, line.replace("\t", " ")))
    with open(os.path.join(OUT, "io_hist.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("target\tcount\n")
        for addr in sorted(counts):
            h.write("%06X\t%d\n" % (addr, counts[addr]))
    log("operand rows %d distinct %d" % (len(rows), len(counts)))
    return len(rows)


def func_table():
    n = 0
    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("ea\tend\tsize\tname\n")
        for start in idautils.Functions():
            f = ida_funcs.get_func(start)
            if f is None:
                continue
            h.write("%06X\t%06X\t%d\t%s\n"
                    % (start, f.end_ea, f.end_ea - start,
                       (idc.get_func_name(start) or "")))
            n += 1
    log("functions %d" % n)
    return n


def coverage():
    code = 0
    for ea in range(0x400, END):
        if ida_bytes.is_code(ida_bytes.get_flags(ea)):
            code += 1
    log("code bytes %d of %d (%.1f%%)" % (code, END - 0x400,
                                          100.0 * code / (END - 0x400)))


def main():
    os.makedirs(OUT, exist_ok=True)
    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write("job %s proc %s\n" % (os.environ.get("YAESU_JOB", "?"),
                                      ida_idp.get_idp_name() or ""))
    try:
        ida_auto.auto_wait()
        seg = ida_segment.get_first_seg()
        log("seg %08X-%08X" % (seg.start_ea, seg.end_ea))
        log("min %08X max %08X" % (ida_ida.inf_get_min_ea(),
                                   ida_ida.inf_get_max_ea()))
        seed(os.path.join(OUT, "call_targets.txt"), "jsr")
        ida_auto.auto_wait()
        seed(os.path.join(OUT, "jmp_targets.txt"), "jmp")
        ida_auto.auto_wait()
        sweep()
        func_table()
        operand_scan()
        coverage()
        log("pass1_done")
        idc.qexit(0)
    except Exception:
        log("pass1_failed")
        log(traceback.format_exc())
        idc.qexit(1)


main()

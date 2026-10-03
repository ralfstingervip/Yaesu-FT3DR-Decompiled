"""MAIN-IO pass 2: extra seeding, then targeted disassembly dumps.

Reads ida/out/main-io/seed2.txt and dump_list.txt.
dump_list.txt lines: HEXSTART HEXEND LABEL
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
import idautils
import idc

OUT = str(_REPO / "ida/out/main-io")
LOG = os.path.join(OUT, "pass2_status.txt")
END = 0x7C000


def log(t):
    with open(LOG, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def seed(path, label):
    if not os.path.isfile(path):
        log("missing %s" % path)
        return 0
    made = tried = 0
    with open(path, "r", encoding="utf-8") as h:
        addrs = [int(x.strip(), 16) for x in h if x.strip()]
    for ea in addrs:
        if ea >= END:
            continue
        tried += 1
        f = ida_funcs.get_func(ea)
        if f is not None:
            continue
        flags = ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(flags):
            if ida_bytes.is_data(flags) or ida_bytes.is_unknown(flags):
                ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 2)
            if ida_ua.create_insn(ea) == 0:
                continue
        if ida_funcs.add_func(ea):
            made += 1
    log("%s seeded %d of %d" % (label, made, tried))
    return made


def dumps():
    path = os.path.join(OUT, "dump_list.txt")
    if not os.path.isfile(path):
        log("no dump_list.txt")
        return
    with open(path, "r", encoding="utf-8") as h:
        jobs = []
        for line in h:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split()
            jobs.append((int(parts[0], 16), int(parts[1], 16),
                         parts[2] if len(parts) > 2 else "r"))
    dpath = os.path.join(OUT, "disasm.txt")
    with open(dpath, "w", encoding="utf-8", newline="\n") as h:
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
                fn = idc.get_func_name(ea) or ""
                mark = ""
                f = ida_funcs.get_func(ea)
                if f is not None and f.start_ea == ea:
                    mark = "  <<< %s" % fn
                names = idc.get_name(ea)
                if names and (f is None or f.start_ea != ea):
                    mark += "  :%s" % names
                h.write("%06X  %-18s %s%s\n"
                        % (ea, " ".join("%02X" % b for b in raw), line, mark))
                ea += n if n > 0 else 2
    log("disasm written for %d ranges" % len(jobs))


def operand_scan():
    rows = []
    counts = collections.Counter()
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
            line = None
            for op in insn.ops:
                if op.type == ida_ua.o_void:
                    break
                if op.type == ida_ua.o_mem:
                    val = op.addr
                elif op.type == ida_ua.o_displ:
                    val = op.addr
                elif op.type == ida_ua.o_imm:
                    val = op.value
                else:
                    continue
                v24 = val & 0xFFFFFF
                if 0xFFFE00 <= v24 <= 0xFFFFFF:
                    if line is None:
                        line = idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or ""
                    rows.append((ea, fname, v24, line))
                    counts[v24] += 1
            ea += length
    with open(os.path.join(OUT, "ioreg_access.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("ea\tfunc\treg\tdisasm\n")
        for ea, fname, v24, line in sorted(rows, key=lambda r: (r[2], r[0])):
            h.write("%06X\t%s\t%06X\t%s\n" % (ea, fname, v24, line.replace("\t", " ")))
    with open(os.path.join(OUT, "ioreg_hist.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("reg\tcount\tfuncs\n")
        byreg = collections.defaultdict(set)
        for ea, fname, v24, line in rows:
            byreg[v24].add(fname)
        for a in sorted(counts):
            h.write("%06X\t%d\t%s\n" % (a, counts[a], ",".join(sorted(byreg[a])[:14])))
    log("ioreg rows %d distinct %d" % (len(rows), len(counts)))


def func_table():
    n = 0
    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8",
              newline="\n") as h:
        h.write("ea\tend\tsize\tname\n")
        for start in idautils.Functions():
            f = ida_funcs.get_func(start)
            if f is None:
                continue
            h.write("%06X\t%06X\t%d\t%s\n" % (start, f.end_ea, f.end_ea - start,
                                              idc.get_func_name(start) or ""))
            n += 1
    log("functions %d" % n)


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
        h.write("proc %s\n" % (ida_idp.get_idp_name() or ""))
    try:
        ida_auto.auto_wait()
        if os.environ.get("MAINIO_SEED", "1") == "1":
            seed(os.path.join(OUT, "seed2.txt"), "seed2")
            ida_auto.auto_wait()
            func_table()
            coverage()
            operand_scan()
        dumps()
        log("pass2_done")
        idc.qexit(0)
    except Exception:
        log("pass2_failed")
        log(traceback.format_exc())
        idc.qexit(1)


main()

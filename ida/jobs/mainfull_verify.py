r"""MAIN-FULL stage 7: validate the forced sweep, undo the data it mis-coded,
then emit the final honest tables.

The stage-4/5/6 linear sweeps force-decode undefined runs.  That recovers real
code but it also turns some byte tables into instructions (the table at
0x0000C420 is a confirmed example).  This pass scores every function and
undefines the ones with a data signature, then reports:
  - functions with at least one code cross-reference   ("reachable")
  - functions only reached by the linear sweep          ("swept")
so the coverage figure can be read with the right confidence.

Also writes vector_map.tsv: for each occupied vector slot, the absolute
register addresses touched by the handler and its direct callees.
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
import ida_segment
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-full")
LST = os.path.join(OUT, "lst")
os.makedirs(LST, exist_ok=True)
LOG_PATH = os.path.join(OUT, "stage7_log.txt")
_LOG = []


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")


def esc(text):
    return (text or "").replace("\t", " ").replace("\n", " ").replace("\r", " ")


RET = ("rts", "rte", "rtsl")
CALL = ("jsr", "bsr")
BRANCH = ("bra", "beq", "bne", "bcs", "bcc", "bhi", "bls", "bmi", "bpl", "bvs",
          "bvc", "bge", "blt", "bgt", "ble", "bt", "bf", "jmp")
ODD = ("stc", "ldc", "eepmov", "trapa", "andc", "orc", "xorc", "tas", "mac",
       "clrmac", "ldmac", "stmac", "sleep")
EXTRA_RANGES = [
    ("usb_setup_tbl", 0x558E0, 0x55A40),
    ("usb_bulk", 0x55620, 0x557F8),
    ("usb_b_descr", 0x77D00, 0x77F40),
]


def scan(func):
    stats = collections.Counter()
    regs = set()
    callees = set()
    insn = ida_ua.insn_t()
    ea = func.start_ea
    while ea < func.end_ea:
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags) and ida_ua.decode_insn(insn, ea) > 0:
            mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
            stats["insn"] += 1
            if mnem in RET:
                stats["ret"] += 1
            elif mnem in CALL:
                stats["call"] += 1
            elif mnem in BRANCH:
                stats["branch"] += 1
            if mnem.split(".")[0] in ODD:
                stats["odd"] += 1
            if not mnem:
                stats["bad"] += 1
            for op in insn.ops:
                if op.type == 0:
                    break
                if op.type == ida_ua.o_mem:
                    ea24 = op.addr & 0xFFFFFF
                    if ea24 >= 0xFFEE00:
                        regs.add(ea24)
                if mnem in CALL and op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                    callees.add(op.addr)
        ea = max(ea + 1, ida_bytes.get_item_end(ea))
    return stats, regs, callees


def main():
    ida_auto.auto_wait()
    seg = ida_segment.get_first_seg()
    base = seg.start_ea
    blob = ida_bytes.get_bytes(base, ida_ida.inf_get_max_ea() - base)
    end = len(blob)
    while end > 0 and blob[end - 1] == 0xFF:
        end -= 1
    content_end = base + end

    # ---- score, then drop functions with a data signature -----------------
    rows = []
    for start in list(idautils.Functions()):
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        stats, _, _ = scan(func)
        nrefs = len(list(idautils.XrefsTo(start, 0)))
        size = func.end_ea - func.start_ea
        rows.append((start, func.end_ea, size, nrefs, stats))
    log("scored %d functions" % len(rows))

    dropped = dropped_bytes = 0
    for start, stop, size, nrefs, stats in rows:
        insn = stats["insn"] or 1
        structural = stats["ret"] + stats["call"] + stats["branch"]
        odd_ratio = stats["odd"] / float(insn)
        looks_data = (
            nrefs == 0
            and size >= 24
            and (structural == 0 or (odd_ratio > 0.30 and stats["call"] == 0))
        )
        if looks_data:
            ida_funcs.del_func(start)
            ida_bytes.del_items(start, ida_bytes.DELIT_EXPAND, stop - start)
            dropped += 1
            dropped_bytes += size
    ida_auto.auto_wait()
    log("dropped %d functions (%d bytes) as mis-swept data" % (dropped, dropped_bytes))

    # ---- final function table with confidence -----------------------------
    reach = swept = 0
    reach_bytes = swept_bytes = 0
    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea\tend\tsize\tname\tnrefs\tconfidence\tinsn\tret\tcall\tbranch\todd\n")
        for start in idautils.Functions():
            func = ida_funcs.get_func(start)
            if func is None:
                continue
            stats, _, _ = scan(func)
            nrefs = len(list(idautils.XrefsTo(start, 0)))
            size = func.end_ea - func.start_ea
            conf = "reachable" if nrefs else "swept"
            if nrefs:
                reach += 1
                reach_bytes += size
            else:
                swept += 1
                swept_bytes += size
            handle.write("%08X\t%08X\t%d\t%s\t%d\t%s\t%d\t%d\t%d\t%d\t%d\n"
                         % (start, func.end_ea, size, idc.get_func_name(start) or "",
                            nrefs, conf, stats["insn"], stats["ret"], stats["call"],
                            stats["branch"], stats["odd"]))
    log("functions reachable %d (%d bytes) swept-only %d (%d bytes) total %d (%d bytes)"
        % (reach, reach_bytes, swept, swept_bytes, reach + swept, reach_bytes + swept_bytes))

    # ---- byte accounting --------------------------------------------------
    counts = collections.Counter()
    classes = []
    cur_class = None
    cur_start = base
    ea = base
    while ea < content_end:
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags) or ida_bytes.is_tail(flags):
            head = ida_bytes.get_item_head(ea)
            kind = "code" if ida_bytes.is_code(ida_bytes.get_flags(head)) else "data"
        elif ida_bytes.is_unknown(flags):
            kind = "unk"
        else:
            kind = "data"
        counts[kind] += 1
        if kind != cur_class:
            if cur_class is not None:
                classes.append((cur_class, cur_start, ea - cur_start))
            cur_class = kind
            cur_start = ea
        ea += 1
    classes.append((cur_class, cur_start, content_end - cur_start))
    span = content_end - base
    log("FINAL bytes code %d (%.1f%%) data %d (%.1f%%) unknown %d (%.1f%%) of %d"
        % (counts["code"], 100.0 * counts["code"] / span, counts["data"],
           100.0 * counts["data"] / span, counts["unk"], 100.0 * counts["unk"] / span, span))
    with open(os.path.join(OUT, "items.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("class\tstart\tend\tlength\n")
        for kind, start, length in classes:
            handle.write("%s\t%08X\t%08X\t%d\n" % (kind, start, start + length, length))

    # ---- vector -> register map ------------------------------------------
    with open(os.path.join(OUT, "vector_map.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("index\tslot_ea\thandler\tkind\tdepth1_funcs\tregisters\n")
        values = [ida_bytes.get_dword(base + i * 4) for i in range(256)]
        tally = collections.Counter(values)
        filler = tally.most_common(1)[0][0]
        for index, value in enumerate(values):
            kind = "filler" if value == filler and tally[value] > 8 else "handler"
            func = ida_funcs.get_func(value)
            regs = set()
            callees = set()
            if func is not None:
                stats, regs, callees = scan(func)
                for callee in list(callees):
                    sub = ida_funcs.get_func(callee)
                    if sub is not None and sub.end_ea - sub.start_ea < 4096:
                        _, sub_regs, _ = scan(sub)
                        regs |= sub_regs
            handle.write("%d\t%08X\t%08X\t%s\t%s\t%s\n"
                         % (index, base + index * 4, value, kind,
                            ",".join("%08X" % c for c in sorted(callees)[:12]),
                            ",".join("%06X" % r for r in sorted(regs))))
    log("vector_map written")

    # ---- final absolute operand tables ----------------------------------
    rows = []
    roll = collections.defaultdict(lambda: [0, collections.Counter(), set()])
    insn = ida_ua.insn_t()
    for start in idautils.Functions():
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        fname = idc.get_func_name(start) or ""
        ea = func.start_ea
        while ea < func.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_ua.decode_insn(insn, ea) > 0:
                mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
                for idx, op in enumerate(insn.ops):
                    if op.type == 0:
                        break
                    if op.type != ida_ua.o_mem:
                        continue
                    ea24 = op.addr & 0xFFFFFF
                    if ea24 < 0xFE0000:
                        continue
                    rows.append((ea24, op.addr, ea, mnem, idx, fname,
                                 esc(idc.generate_disasm_line(ea, 0))))
                    slot = roll[ea24]
                    slot[0] += 1
                    slot[1][mnem] += 1
                    if len(slot[2]) < 60:
                        slot[2].add(fname or ("%08X" % ea))
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
    log("FINAL absolute operands >= 0xFE0000: %d sites %d addresses" % (len(rows), len(roll)))
    with open(os.path.join(OUT, "ioregs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea24\tida_addr\tsite\tmnem\topno\tfunction\tline\n")
        for r in sorted(rows):
            handle.write("%06X\t%08X\t%08X\t%s\t%d\t%s\t%s\n" % r)
    with open(os.path.join(OUT, "absrefs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea24\thits\tmnemonics\tn_functions\tsample_functions\n")
        for ea24 in sorted(roll):
            hits, mnems, funcs = roll[ea24]
            handle.write("%06X\t%d\t%s\t%d\t%s\n"
                         % (ea24, hits, ",".join("%s:%d" % kv for kv in mnems.most_common(8)),
                            len(funcs), ",".join(sorted(funcs)[:8])))
    with open(os.path.join(OUT, "xrefs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("to_ea\tto_name\tfrom_ea\tfrom_func\ttype\n")
        n = 0
        for start in idautils.Functions():
            name = idc.get_func_name(start) or ""
            for xr in idautils.XrefsTo(start, 0):
                owner = ida_funcs.get_func(xr.frm)
                handle.write("%08X\t%s\t%08X\t%s\t%d\n"
                             % (start, name, xr.frm,
                                idc.get_func_name(owner.start_ea) if owner else "", xr.type))
                n += 1
    log("xrefs %d" % n)

    for name, lo, hi in EXTRA_RANGES:
        with open(os.path.join(LST, name + ".lst"), "w", encoding="utf-8", newline="\n") as handle:
            ea = lo
            while ea < hi:
                size = max(1, ida_bytes.get_item_end(ea) - ea)
                raw = ida_bytes.get_bytes(ea, min(size, 10)) or b""
                func = ida_funcs.get_func(ea)
                mark = "  ; ==== %s ====" % (idc.get_func_name(ea) or "") \
                    if func is not None and func.start_ea == ea else ""
                handle.write("%08X  %-20s  %s%s\n"
                             % (ea, raw.hex(), esc(idc.generate_disasm_line(ea, 0)), mark))
                ea += size
        log("listing %s" % name)


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")
idc.qexit(0)

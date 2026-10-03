r"""MAIN-FULL stage 8: drop the sweep's noise, then final numbers.

The linear sweep leaves data tables shredded into 2-4 byte pseudo-instructions
(0x0000C058-0x0000C66C is the clearest case: the byte table that contains the
accidental ASCII '!sdr').  Real H8S functions have a return or a call; a 4-byte
"function" holding one branch and nothing else does not.  This pass removes
those and the shredded runs, so the reported code coverage means something.
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
LOG_PATH = os.path.join(OUT, "stage8_log.txt")
_LOG = []


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")


RET = ("rts", "rte", "rtsl")
CALL = ("jsr", "bsr")


def func_stats(func):
    insn = ida_ua.insn_t()
    n = ret = call = 0
    ea = func.start_ea
    while ea < func.end_ea:
        if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_ua.decode_insn(insn, ea) > 0:
            mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
            n += 1
            if mnem in RET:
                ret += 1
            elif mnem in CALL:
                call += 1
        ea = max(ea + 1, ida_bytes.get_item_end(ea))
    return n, ret, call


def main():
    ida_auto.auto_wait()
    seg = ida_segment.get_first_seg()
    base = seg.start_ea
    blob = ida_bytes.get_bytes(base, ida_ida.inf_get_max_ea() - base)
    end = len(blob)
    while end > 0 and blob[end - 1] == 0xFF:
        end -= 1
    content_end = base + end

    # pass 1: tiny no-xref fragments
    dropped = 0
    for start in list(idautils.Functions()):
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        size = func.end_ea - func.start_ea
        if size > 12:
            continue
        if list(idautils.XrefsTo(start, 0)):
            continue
        n, ret, call = func_stats(func)
        if ret == 0 and call == 0:
            ida_funcs.del_func(start)
            ida_bytes.del_items(start, ida_bytes.DELIT_EXPAND, size)
            dropped += 1
    ida_auto.auto_wait()
    log("pass1 dropped %d tiny fragments" % dropped)

    # pass 2: shredded code runs (short runs surrounded by undefined bytes)
    shred = shred_bytes = 0
    ea = base + 0x400
    while ea < content_end:
        flags = ida_bytes.get_flags(ea)
        if not (ida_bytes.is_code(flags) or ida_bytes.is_tail(flags)):
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
            continue
        head = ida_bytes.get_item_head(ea)
        if not ida_bytes.is_code(ida_bytes.get_flags(head)):
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
            continue
        start = ea
        n_insn = ret = call = 0
        insn = ida_ua.insn_t()
        while ea < content_end:
            f = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(f):
                if ida_ua.decode_insn(insn, ea) > 0:
                    mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
                    n_insn += 1
                    if mnem in RET:
                        ret += 1
                    elif mnem in CALL:
                        call += 1
                ea = max(ea + 1, ida_bytes.get_item_end(ea))
            elif ida_bytes.is_tail(f):
                ea += 1
            else:
                break
        length = ea - start
        if length <= 12 and ret == 0 and call == 0:
            refs = False
            for probe in range(start, ea, 2):
                if list(idautils.XrefsTo(probe, 0)):
                    refs = True
                    break
            if not refs:
                func = ida_funcs.get_func(start)
                if func is not None:
                    ida_funcs.del_func(func.start_ea)
                ida_bytes.del_items(start, ida_bytes.DELIT_EXPAND, length)
                shred += 1
                shred_bytes += length
    ida_auto.auto_wait()
    log("pass2 dropped %d shredded runs (%d bytes)" % (shred, shred_bytes))

    # final numbers
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

    reach = swept = 0
    reach_bytes = swept_bytes = 0
    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea\tend\tsize\tname\tnrefs\tconfidence\tinsn\tret\tcall\n")
        for start in idautils.Functions():
            func = ida_funcs.get_func(start)
            if func is None:
                continue
            n, ret, call = func_stats(func)
            nrefs = len(list(idautils.XrefsTo(start, 0)))
            size = func.end_ea - func.start_ea
            if nrefs:
                reach += 1
                reach_bytes += size
            else:
                swept += 1
                swept_bytes += size
            handle.write("%08X\t%08X\t%d\t%s\t%d\t%s\t%d\t%d\t%d\n"
                         % (start, func.end_ea, size, idc.get_func_name(start) or "",
                            nrefs, "reachable" if nrefs else "swept", n, ret, call))
    log("FINAL functions %d (reachable %d / %d bytes; swept-only %d / %d bytes) total bytes %d (%.1f%%)"
        % (reach + swept, reach, reach_bytes, swept, swept_bytes,
           reach_bytes + swept_bytes, 100.0 * (reach_bytes + swept_bytes) / span))


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")
idc.qexit(0)

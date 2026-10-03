r"""MAIN-FULL stage 4: forced linear sweep of code-like undefined runs, then
listing dumps for the blocks that carry the answer.

The sweep is deliberately separated from stage 2 so the honest numbers stay
separable: functions found here are reached by linear decoding, not by a call
from recovered code.  swept_runs.tsv records exactly which runs were forced.
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
LOG_PATH = os.path.join(OUT, "stage4_log.txt")
_LOG = []


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")


CALLS = ("jsr", "bsr", "jmp", "bra")
RANGES = [
    ("init", 0x2092, 0x2AA0),
    ("crt_hwinit", 0x20FA, 0x2482),
    ("usb_core", 0x54B00, 0x55A00),
    ("usb_aux1", 0x76700, 0x769F0),
    ("usb_aux2", 0x78100, 0x78520),
    ("blk_fffc00", 0x482D0, 0x48440),
    ("blk_fffc40", 0x6B770, 0x6B9F0),
    ("blk_fffe90", 0x45180, 0x45600),
    ("isr_44a70", 0x44A70, 0x44B60),
    ("isr_561c2", 0x561C2, 0x56260),
    ("sci2_78222", 0x78200, 0x78280),
]


def main():
    ida_auto.auto_wait()
    seg = ida_segment.get_first_seg()
    base = seg.start_ea
    top = ida_ida.inf_get_max_ea()
    blob = ida_bytes.get_bytes(base, top - base)
    end = len(blob)
    while end > 0 and blob[end - 1] == 0xFF:
        end -= 1
    content_end = base + end
    insn = ida_ua.insn_t()
    log("functions_before_sweep %d" % len(list(idautils.Functions())))

    # ---- collect undefined runs ------------------------------------------
    runs = []
    ea = base + 0x400
    while ea < content_end:
        flags = ida_bytes.get_flags(ea)
        if not ida_bytes.is_unknown(flags):
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
            continue
        start = ea
        while ea < content_end and ida_bytes.is_unknown(ida_bytes.get_flags(ea)):
            ea += 1
        runs.append((start, ea))
    log("undefined runs %d" % len(runs))

    # ---- score and force-sweep -------------------------------------------
    swept_rows = []
    forced = 0
    for start, stop in runs:
        length = stop - start
        if length < 32:
            continue
        probe_start = start if start % 2 == 0 else start + 1
        n = 0
        cur = probe_start
        while n < 32 and cur < stop:
            size = ida_ua.decode_insn(insn, cur)
            if size <= 0 or insn.itype == 0:
                break
            cur += size
            n += 1
        # structural score over the raw bytes: RTS and in-range JSR density
        off = start - base
        raw = blob[off:off + length]
        rts = raw.count(b"\x54\x70")
        jsr = 0
        for i in range(0, max(0, len(raw) - 3)):
            if raw[i] == 0x5E:
                target = (raw[i + 1] << 16) | (raw[i + 2] << 8) | raw[i + 3]
                if 0x400 <= target < end and target % 2 == 0:
                    jsr += 1
        codelike = n >= 12 and (rts >= 1 or jsr >= 2)
        swept_rows.append((start, stop, length, n, rts, jsr, codelike))
        if not codelike:
            continue
        # linear force-code across the run
        cur = probe_start
        while cur < stop:
            if not ida_bytes.is_unknown(ida_bytes.get_flags(cur)):
                cur = max(cur + 1, ida_bytes.get_item_end(cur))
                continue
            size = ida_ua.create_insn(cur)
            if size <= 0:
                cur += 2
                continue
            cur += size
        forced += 1
    log("forced_runs %d" % forced)
    ida_auto.auto_wait()

    with open(os.path.join(OUT, "swept_runs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("start\tend\tlength\tprobe_insns\tn_rts\tn_jsr\tforced\n")
        for start, stop, length, n, rts, jsr, codelike in swept_rows:
            handle.write("%08X\t%08X\t%d\t%d\t%d\t%d\t%s\n"
                         % (start, stop, length, n, rts, jsr, "yes" if codelike else "no"))

    # ---- make functions out of the new code ------------------------------
    def follow():
        added = 0
        for start in list(idautils.Functions()):
            func = ida_funcs.get_func(start)
            if func is None:
                continue
            ea = func.start_ea
            while ea < func.end_ea:
                if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                    mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
                    if mnem in CALLS and ida_ua.decode_insn(insn, ea) > 0:
                        for op in insn.ops:
                            if op.type == 0:
                                break
                            if op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                                t = op.addr
                                if base + 0x400 <= t < content_end and ida_funcs.get_func(t) is None:
                                    ida_ua.create_insn(t)
                                    if ida_funcs.add_func(t):
                                        added += 1
                ea = max(ea + 1, ida_bytes.get_item_end(ea))
        if added:
            ida_auto.auto_wait()
        return added

    # any code byte not in a function and preceded by a non-code byte becomes one
    def orphans():
        added = 0
        ea = base + 0x400
        prev_code = False
        while ea < content_end:
            flags = ida_bytes.get_flags(ea)
            is_code = ida_bytes.is_code(flags)
            if is_code and not prev_code and ida_funcs.get_func(ea) is None:
                if ida_funcs.add_func(ea):
                    added += 1
            prev_code = is_code or ida_bytes.is_tail(flags)
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
        if added:
            ida_auto.auto_wait()
        return added

    for rnd in range(1, 8):
        a = follow()
        b = orphans()
        log("sweep round %d follow %d orphans %d functions %d"
            % (rnd, a, b, len(list(idautils.Functions()))))
        if a == 0 and b == 0:
            break

    # ---- listings --------------------------------------------------------
    for name, lo, hi in RANGES:
        path = os.path.join(LST, name + ".lst")
        with open(path, "w", encoding="utf-8", newline="\n") as handle:
            ea = lo
            while ea < hi:
                size = max(1, ida_bytes.get_item_end(ea) - ea)
                raw = ida_bytes.get_bytes(ea, min(size, 10)) or b""
                fn = idc.get_func_name(ea) or ""
                mark = ""
                func = ida_funcs.get_func(ea)
                if func is not None and func.start_ea == ea:
                    mark = "  ; ==== %s ====" % fn
                handle.write("%08X  %-20s  %s%s\n"
                             % (ea, raw.hex(), (idc.generate_disasm_line(ea, 0) or "").replace("\t", " "), mark))
                ea += size
        log("listing %s %08X-%08X" % (name, lo, hi))

    # ---- final coverage --------------------------------------------------
    counts = collections.Counter()
    for ea in range(base, content_end):
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags) or ida_bytes.is_tail(flags):
            head = ida_bytes.get_item_head(ea)
            counts["code" if ida_bytes.is_code(ida_bytes.get_flags(head)) else "data"] += 1
        elif ida_bytes.is_unknown(flags):
            counts["unk"] += 1
        else:
            counts["data"] += 1
    span = content_end - base
    log("final bytes code %d (%.1f%%) data %d (%.1f%%) unknown %d (%.1f%%) of %d"
        % (counts["code"], 100.0 * counts["code"] / span, counts["data"],
           100.0 * counts["data"] / span, counts["unk"], 100.0 * counts["unk"] / span, span))
    log("functions_final %d" % len(list(idautils.Functions())))


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")
idc.qexit(0)

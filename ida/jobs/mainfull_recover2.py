r"""MAIN-FULL stage 2: iterate code recovery to a fixpoint.

Rounds:
  A  every call/branch target reachable from already-defined code becomes a
     function (IDA follows flow after each round, so this converges)
  B  relaxed gap sweep: any undefined run that decodes to a terminated chain of
     >= 2 instructions and starts right after a terminator / padding
  C  raw harvest of JSR @aa:24 and JMP @aa:24 absolute targets over the whole
     content region, for code that nothing in the recovered set reaches
Repeat A/B until no growth, then C, then A/B again.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import struct
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
os.makedirs(OUT, exist_ok=True)
LOG_PATH = os.path.join(OUT, "stage2_log.txt")
_LOG = []


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")


CALLS = ("jsr", "bsr", "jmp", "bra")
TERMS = ("rts", "rte", "jmp", "bra", "rtsl")
PAD = (0x00, 0xFF)


def decode_chain(ea, limit, max_insn=96):
    insn = ida_ua.insn_t()
    cur = ea
    count = 0
    while count < max_insn and cur < limit:
        length = ida_ua.decode_insn(insn, cur)
        if length <= 0 or insn.itype == 0:
            return count, cur, False
        mnem = (ida_ua.print_insn_mnem(cur) or "").lower()
        nxt = cur + length
        # do not run over an already-defined item
        for probe in range(cur, nxt):
            if not ida_bytes.is_unknown(ida_bytes.get_flags(probe)):
                return count, cur, False
        cur = nxt
        count += 1
        if mnem in TERMS:
            return count, cur, True
    return count, cur, False


def code_targets():
    out = set()
    for start in idautils.Functions():
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        ea = func.start_ea
        while ea < func.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
                if mnem in CALLS:
                    insn = ida_ua.insn_t()
                    if ida_ua.decode_insn(insn, ea) > 0:
                        for op in insn.ops:
                            if op.type == 0:
                                break
                            if op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                                out.add(op.addr)
            ea = ida_bytes.get_item_end(ea)
    return out


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
    log("content_end %#x" % content_end)
    log("functions_start %d" % len(list(idautils.Functions())))

    def round_a():
        added = 0
        for target in sorted(code_targets()):
            if not (base + 0x400 <= target < content_end):
                continue
            if ida_funcs.get_func(target) is not None:
                continue
            ida_ua.create_insn(target)
            if ida_funcs.add_func(target):
                added += 1
        if added:
            ida_auto.auto_wait()
        return added

    def round_b():
        added = 0
        off = 0x400
        while off < (content_end - base) - 4:
            ea = base + off
            flags = ida_bytes.get_flags(ea)
            if not ida_bytes.is_unknown(flags):
                off = max(off + 2, ida_bytes.get_item_end(ea) - base)
                continue
            prev = blob[off - 2:off]
            good_prev = (
                prev in (b"\x54\x70", b"\x56\x70")
                or (len(prev) == 2 and prev[0] == prev[1] and prev[0] in PAD)
            )
            n, end_ea, term = decode_chain(ea, content_end, 96)
            ok = term and (n >= 6 or (n >= 2 and good_prev))
            if ok:
                ida_ua.create_insn(ea)
                if ida_funcs.add_func(ea):
                    added += 1
                    off = max(off + 2, end_ea - base)
                    continue
            off += 2
        if added:
            ida_auto.auto_wait()
        return added

    for rnd in range(1, 13):
        a = round_a()
        b = round_b()
        total = len(list(idautils.Functions()))
        log("round %d  from_calls %d  from_gaps %d  functions %d" % (rnd, a, b, total))
        if a == 0 and b == 0:
            break

    # ---- round C: raw JSR/JMP absolute target harvest ---------------------
    raw = {}
    for off in range(0x400, end - 3, 2):
        op = blob[off]
        if op not in (0x5E, 0x5A):
            continue
        target = struct.unpack_from(">I", blob, off)[0] & 0xFFFFFF
        if 0x400 <= target < end and target % 2 == 0:
            raw.setdefault(base + target, []).append(base + off)
    log("raw_call_targets %d" % len(raw))
    added = weak = 0
    for target, sites in sorted(raw.items()):
        if ida_funcs.get_func(target) is not None:
            continue
        # accept when the target decodes a terminated chain, or several distinct
        # call sites agree, or the caller site is itself inside recovered code
        strong = len(sites) >= 2 or any(
            ida_bytes.is_code(ida_bytes.get_flags(s)) for s in sites
        )
        n, _, term = decode_chain(target, content_end, 96)
        if strong or (term and n >= 3):
            ida_ua.create_insn(target)
            if ida_funcs.add_func(target):
                added += 1
                if not strong:
                    weak += 1
    if added:
        ida_auto.auto_wait()
    log("round C added %d (weak %d) functions %d" % (added, weak, len(list(idautils.Functions()))))

    for rnd in range(1, 9):
        a = round_a()
        b = round_b()
        total = len(list(idautils.Functions()))
        log("post round %d  from_calls %d  from_gaps %d  functions %d" % (rnd, a, b, total))
        if a == 0 and b == 0:
            break

    # ---- report ----------------------------------------------------------
    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea\tend\tsize\tname\tnrefs\n")
        total = 0
        count = 0
        for start in idautils.Functions():
            func = ida_funcs.get_func(start)
            if func is None:
                continue
            size = func.end_ea - func.start_ea
            total += size
            count += 1
            handle.write(
                "%08X\t%08X\t%d\t%s\t%d\n"
                % (start, func.end_ea, size, idc.get_func_name(start) or "",
                   len(list(idautils.XrefsTo(start, 0))))
            )
    log("functions %d function_bytes %d" % (count, total))

    code = data = unk = 0
    for ea in range(base, content_end):
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags):
            code += 1
        elif ida_bytes.is_unknown(flags):
            unk += 1
        else:
            data += 1
    span = content_end - base
    log("bytes_code %d (%.1f%%) bytes_data %d (%.1f%%) bytes_unknown %d (%.1f%%) of %d"
        % (code, 100.0 * code / span, data, 100.0 * data / span, unk, 100.0 * unk / span, span))


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")
idc.qexit(0)

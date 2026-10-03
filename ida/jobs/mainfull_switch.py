r"""MAIN-FULL stage 6: indexed-jump (switch) table detection at any alignment,
final sweep, final tables.

Pattern, from the recovered code:
    shll.l #2, erN
    78 N0 6B 2d <aa:32>     mov @(aa:32, erN), erd
    59 d0                   jmp @erd
`aa` is the table base and is NOT necessarily 4-aligned (0x00055002 is not).
Stage 5 only scanned 4-aligned runs, so those tables were missed.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
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
LST = os.path.join(OUT, "lst")
os.makedirs(LST, exist_ok=True)
LOG_PATH = os.path.join(OUT, "stage6_log.txt")
_LOG = []


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")


def esc(text):
    return (text or "").replace("\t", " ").replace("\n", " ").replace("\r", " ")


CALLS = ("jsr", "bsr", "jmp", "bra")
RANGES = [
    ("usb_ctrl", 0x54FEC, 0x55A00),
    ("usb_b_init", 0x78100, 0x78560),
    ("usb_b_idx", 0x762F0, 0x767C0),
    ("usb_b_core", 0x767C0, 0x76A00),
    ("usb_tail", 0x78514, 0x78700),
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
    log("functions_start %d" % len(list(idautils.Functions())))

    def chain(ea, limit=32):
        cur = ea
        n = 0
        while n < limit and cur < content_end:
            size = ida_ua.decode_insn(insn, cur)
            if size <= 0 or insn.itype == 0:
                break
            cur += size
            n += 1
        return n

    # ---- switch tables ---------------------------------------------------
    bases = {}
    for off in range(0x400, end - 8):
        if blob[off] != 0x78 or blob[off + 2] not in (0x6A, 0x6B):
            continue
        if (blob[off + 3] & 0xF0) not in (0x20, 0xA0):
            continue
        aa = struct.unpack_from(">I", blob, off + 4)[0]
        if 0x400 <= aa < end:
            bases.setdefault(aa, []).append(off)
    log("switch table candidates %d" % len(bases))

    forced = 0
    rows = []
    for aa, sites in sorted(bases.items()):
        entries = []
        cur = aa
        while cur + 4 <= end:
            value = struct.unpack_from(">I", blob, cur)[0]
            if not (0x400 <= value < end and value % 2 == 0):
                break
            if chain(base + value, 4) < 2:
                break
            entries.append(base + value)
            cur += 4
            if len(entries) >= 256:
                break
        if len(entries) < 2:
            continue
        rows.append((base + aa, len(entries), [hex(s) for s in sites[:3]], entries))
        for target in entries:
            if ida_bytes.is_unknown(ida_bytes.get_flags(target)):
                if ida_ua.create_insn(target) > 0:
                    forced += 1
    ida_auto.auto_wait()
    log("switch tables %d, forced code at %d targets" % (len(rows), forced))
    with open(os.path.join(OUT, "switch_tables.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("table_ea\tentries\tref_sites\ttargets\n")
        for tea, n, sites, entries in rows:
            handle.write("%08X\t%d\t%s\t%s\n"
                         % (tea, n, ",".join(sites), ",".join("%08X" % e for e in entries[:48])))

    # ---- final linear sweep ---------------------------------------------
    def sweep():
        runs = []
        ea = base + 0x400
        while ea < content_end:
            if not ida_bytes.is_unknown(ida_bytes.get_flags(ea)):
                ea = max(ea + 1, ida_bytes.get_item_end(ea))
                continue
            start = ea
            while ea < content_end and ida_bytes.is_unknown(ida_bytes.get_flags(ea)):
                ea += 1
            runs.append((start, ea))
        n_forced = 0
        for start, stop in runs:
            length = stop - start
            if length < 16:
                continue
            probe = start if start % 2 == 0 else start + 1
            if chain(probe, 32) < 8:
                continue
            raw = blob[start - base:start - base + length]
            if raw.count(b"\x54\x70") < 1:
                jsr = 0
                for i in range(max(0, len(raw) - 3)):
                    if raw[i] == 0x5E:
                        t = (raw[i + 1] << 16) | (raw[i + 2] << 8) | raw[i + 3]
                        if 0x400 <= t < end and t % 2 == 0:
                            jsr += 1
                if jsr < 1:
                    continue
            cur = probe
            while cur < stop:
                if not ida_bytes.is_unknown(ida_bytes.get_flags(cur)):
                    cur = max(cur + 1, ida_bytes.get_item_end(cur))
                    continue
                size = ida_ua.create_insn(cur)
                cur += size if size > 0 else 2
            n_forced += 1
        if n_forced:
            ida_auto.auto_wait()
        return n_forced

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

    def orphans():
        added = 0
        ea = base + 0x400
        prev_in = False
        while ea < content_end:
            flags = ida_bytes.get_flags(ea)
            is_code = ida_bytes.is_code(flags)
            if is_code and not prev_in and ida_funcs.get_func(ea) is None:
                if ida_funcs.add_func(ea):
                    added += 1
            prev_in = is_code or ida_bytes.is_tail(flags)
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
        if added:
            ida_auto.auto_wait()
        return added

    for rnd in range(1, 8):
        s = sweep()
        a = follow()
        b = orphans()
        log("round %d sweep %d follow %d orphans %d functions %d"
            % (rnd, s, a, b, len(list(idautils.Functions()))))
        if s == 0 and a == 0 and b == 0:
            break

    # ---- final tables ----------------------------------------------------
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

    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea\tend\tsize\tname\tnrefs\n")
        fbytes = fcount = 0
        for start in idautils.Functions():
            func = ida_funcs.get_func(start)
            if func is None:
                continue
            fbytes += func.end_ea - func.start_ea
            fcount += 1
            handle.write("%08X\t%08X\t%d\t%s\t%d\n"
                         % (start, func.end_ea, func.end_ea - func.start_ea,
                            idc.get_func_name(start) or "",
                            len(list(idautils.XrefsTo(start, 0)))))
    log("FINAL functions %d function_bytes %d (%.1f%%)" % (fcount, fbytes, 100.0 * fbytes / span))

    rows = []
    roll = collections.defaultdict(lambda: [0, collections.Counter(), set()])
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

    # data xrefs into interesting data ranges
    with open(os.path.join(OUT, "data_refs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("target\tfrom_ea\tfrom_func\ttype\tline\n")
        for lo, hi in ((0xC400, 0xC600), (0x7B260, 0x7B760), (0x7B4A0, 0x7B700)):
            for target in range(lo, hi):
                for xr in idautils.XrefsTo(target, 0):
                    owner = ida_funcs.get_func(xr.frm)
                    handle.write("%08X\t%08X\t%s\t%d\t%s\n"
                                 % (target, xr.frm,
                                    idc.get_func_name(owner.start_ea) if owner else "",
                                    xr.type, esc(idc.generate_disasm_line(xr.frm, 0))))

    for name, lo, hi in RANGES:
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

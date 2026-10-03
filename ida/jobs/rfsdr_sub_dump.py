"""RF-SDR pass 1 on the SUB (RX64M) image.

Force-decodes the peripheral-touching code windows, dumps annotated listings,
decodes the 256-entry relocatable vector table at INTB, and records every
`mov.l #imm, rN` that loads a peripheral address plus the displacement uses
that follow it.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import sys

sys.path.insert(0, str(_REPO / "ida/jobs"))

import ida_auto
import ida_bytes
import ida_funcs
import ida_name
import ida_ua
import idautils
import idc

import rfsdr_lib as L

BASE = 0xFFC00000
CODE_LO = BASE + 0x2D8000
CODE_HI = BASE + 0x350000
INTB = 0xFFED8A70

# Map = BASE + file offset.  Windows chosen from the exhaustive immediate scan.
WINDOWS = [
    ("adc_init", 0x2E1080, 0x2E1780),
    ("adc_use", 0x315000, 0x3152C0),
    ("adc_read", 0x315600, 0x315A80),
    ("dmac3", 0x332DA0, 0x333000),
    ("exdmac", 0x2F1C80, 0x2F2040),
    ("mstp_a", 0x336C80, 0x336D40),
    ("selirq", 0x332B80, 0x332C60),
    ("sci_init", 0x2DB280, 0x2DB520),
    ("tpu_a", 0x2DE260, 0x2DE360),
    ("tpu_b", 0x336B00, 0x336C60),
    ("sys_bsc", 0x337400, 0x3375C0),
    ("icu_grp", 0x2DBC80, 0x2DBD60),
    ("port_init", 0x336EE0, 0x337340),
    ("sdhi_a", 0x333000, 0x3336C0),
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()

    log = L.open_out("sub_pass1_log.txt")
    log.write("segments\n")
    for start, blob in L.seg_bytes():
        log.write("  %08X len %08X\n" % (start, len(blob)))

    # ---- 1. vector table -------------------------------------------------
    rows = []
    counts = {}
    for i in range(256):
        ea = INTB + i * 4
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 4)
        ida_bytes.create_dword(ea, 4, True)
        v = ida_bytes.get_dword(ea)
        counts[v] = counts.get(v, 0) + 1
        rows.append((i, ea, v))
    dummy = max(counts.items(), key=lambda kv: kv[1])
    log.write("vector dummy handler %08X used %d times\n" % dummy)
    with L.open_out("sub_vectors.tsv") as h:
        h.write("slot\tslot_ea\thandler\tin_code\tunique\tfunc\n")
        for i, ea, v in rows:
            inside = CODE_LO <= v < CODE_HI
            uniq = counts[v] == 1
            if inside:
                ida_ua.create_insn(v)
                ida_auto.auto_make_code(v)
            fn = ida_funcs.get_func(v)
            h.write(
                "%d\t%08X\t%08X\t%s\t%s\t%s\n"
                % (
                    i,
                    ea,
                    v,
                    "yes" if inside else "no",
                    "yes" if uniq else "no",
                    (idc.get_func_name(fn.start_ea) if fn else ""),
                )
            )
    ida_auto.auto_wait()

    # ---- 2. force code over the whole code region ------------------------
    # Keep already-recovered functions; fill the gaps.
    gaps = []
    ea = CODE_LO
    while ea < CODE_HI:
        fn = ida_funcs.get_func(ea)
        if fn is not None:
            ea = fn.end_ea
            continue
        nxt = ida_funcs.get_next_func(ea)
        end = min(nxt.start_ea, CODE_HI) if nxt is not None else CODE_HI
        if end > ea:
            gaps.append((ea, end))
        ea = end if end > ea else ea + 1
    log.write("gaps %d bytes %d\n" % (len(gaps), sum(b - a for a, b in gaps)))

    # ---- 3. dump the interesting windows --------------------------------
    for name, lo, hi in WINDOWS:
        s, e = BASE + lo, BASE + hi
        made = L.force_code(s, e)
        ida_auto.auto_wait()
        with L.open_asm("sub_%s.asm" % name) as h:
            h.write("; window %s file %06X-%06X map %08X-%08X forced %d\n"
                    % (name, lo, hi, s, e, made))
            L.dump_range(h, s, e, name)
        log.write("window %s forced %d insns\n" % (name, made))

    # ---- 4. exhaustive peripheral-immediate table with following uses ----
    parts = L.seg_bytes()
    hits = []
    for seg_start, blob in parts:
        if seg_start + len(blob) <= CODE_LO or seg_start >= CODE_HI:
            continue
        lo = max(CODE_LO, seg_start) - seg_start
        hi = min(CODE_HI, seg_start + len(blob)) - seg_start
        for off in range(lo, hi - 6):
            if blob[off] != 0xFB:
                continue
            b = blob[off + 1]
            li = b & 0x0F
            if li == 0x0E:
                v = blob[off + 2] | (blob[off + 3] << 8) | (blob[off + 4] << 16)
            elif li == 0x02:
                v = (
                    blob[off + 2]
                    | (blob[off + 3] << 8)
                    | (blob[off + 4] << 16)
                    | (blob[off + 5] << 24)
                )
            else:
                continue
            if 0x00080000 <= v <= 0x000FFFFF:
                hits.append((seg_start + off, (b >> 4) & 0xF, v))

    with L.open_out("sub_periph_sites.tsv") as h:
        h.write("insn_ea\treg\tperiph\tfunc\tcontext\n")
        for ea, reg, v in hits:
            L.force_code(ea, ea + 6)
            fn = ida_funcs.get_func(ea)
            ctx = []
            cur = ea
            for _ in range(10):
                size = ida_bytes.get_item_size(cur)
                if size <= 0:
                    break
                ctx.append(idc.generate_disasm_line(cur, 0) or "?")
                cur += size
                if cur >= CODE_HI:
                    break
            h.write(
                "%08X\tr%d\t%08X\t%s\t%s\n"
                % (
                    ea,
                    reg,
                    v,
                    (idc.get_func_name(fn.start_ea) if fn else ""),
                    " | ".join(ctx),
                )
            )
    log.write("periph sites %d\n" % len(hits))
    log.close()
    _ = ida_name, idautils, os


main()

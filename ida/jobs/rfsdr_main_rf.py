"""RF-SDR pass 2 on MAIN: dump the A/D and bit-banged-serial code with xrefs.

Runs against the RF_SDR_MAIN database (already force-coded by pass 1).
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import sys

sys.path.insert(0, str(_REPO / "ida/jobs"))

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

import rfsdr_lib as L

WINDOWS = [
    ("ad_read", 0x32C0, 0x3560),
    ("bitbang_b", 0x37A00, 0x37C40),
    ("bitbang_c", 0x3E800, 0x3EC60),
    ("io_init", 0x20C0, 0x2820),
    ("port_init", 0x30E0, 0x3200),
    ("sci_isr", 0x55F00, 0x56200),
]

SEEDS = [
    0x32C0, 0x3466, 0x3490, 0x34E0, 0x37A56, 0x37B2A, 0x37BA4,
    0x3E864, 0x3E90A, 0x30E0, 0x20FA, 0x2F400, 0x30F00, 0x3EA28,
    0x56056, 0x5DCFE, 0x45186, 0x73540,
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    for name, lo, hi in WINDOWS:
        L.force_code(lo, hi)
    ida_auto.auto_wait()
    for name, lo, hi in WINDOWS:
        with L.open_asm("main_%s.asm" % name) as h:
            L.dump_range(h, lo, hi, name)

    # callers of each seed, two levels
    with L.open_out("main_rf_xrefs.txt") as h:
        for seed in SEEDS:
            fn = ida_funcs.get_func(seed)
            start = fn.start_ea if fn else seed
            h.write("=== %06X (func %06X %s)\n" % (seed, start, idc.get_func_name(start) or ""))
            lvl1 = set()
            for xr in idautils.XrefsTo(start, 0):
                owner = ida_funcs.get_func(xr.frm)
                oname = idc.get_func_name(owner.start_ea) if owner else ""
                h.write("    from %06X  %s\n" % (xr.frm, oname))
                if owner:
                    lvl1.add(owner.start_ea)
            for c in sorted(lvl1):
                for xr in idautils.XrefsTo(c, 0):
                    owner = ida_funcs.get_func(xr.frm)
                    h.write("      ^^ %06X in %s -> %s\n"
                            % (xr.frm,
                               idc.get_func_name(owner.start_ea) if owner else "",
                               idc.get_func_name(c) or ""))

    # every function whose body performs >=4 bit ops on one absolute I/O byte:
    # the signature of a bit-banged serial bus.
    cand = collections.defaultdict(collections.Counter)
    for start in idautils.Functions():
        fn = ida_funcs.get_func(start)
        if fn is None:
            continue
        ea = fn.start_ea
        while ea < fn.end_ea:
            size = ida_bytes.get_item_size(ea)
            if size <= 0:
                break
            mnem = (idc.print_insn_mnem(ea) or "").lower()
            if mnem in ("bset", "bclr", "bst", "bnot", "btst", "bld", "bist"):
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea) > 0:
                    for op in insn.ops:
                        if op.type == ida_ua.o_void:
                            break
                        a = op.addr & 0xFFFFFF
                        if 0xFFFE80 <= a <= 0xFFFFFF:
                            cand[start][a] += 1
            ea += size
    with L.open_out("main_bitbang.tsv") as h:
        h.write("func\treg\tbitops\n")
        for start, counter in sorted(cand.items()):
            for reg, n in counter.most_common():
                if n >= 4:
                    h.write("%06X\t%06X\t%d\n" % (start, reg, n))


main()

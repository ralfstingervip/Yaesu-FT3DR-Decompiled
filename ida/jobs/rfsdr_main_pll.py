"""RF-SDR pass 3 on MAIN, on a CLEAN database (no global force-code).

Targets the synthesiser path: the 16-bit bit-banged PLL writer at 0x37BA0 /
0x37BA4, its word tables, the frequency arithmetic that feeds it, the A/D
S-meter reader at 0x32C0, and the timer that paces them.  Clean xrefs only.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

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
    ("pll_writer", 0x37A00, 0x37F80),
    ("ad_smeter", 0x32C0, 0x35A0),
    ("ctrl_dac_tbl", 0x3560, 0x3600),
    ("eeprom", 0x3E800, 0x3ED00),
    ("timer_init", 0x2000, 0x2900),
]

SEEDS = [0x32C0, 0x3466, 0x3490, 0x34E0, 0x37BA0, 0x37BA4, 0x37AC4, 0x37B46,
         0x37AEA, 0x37B66, 0x37A30, 0x37A3A, 0x37A4C, 0x37A56, 0x37BE8,
         0x37C1E, 0x37C30, 0x3E864, 0x3E90A]


def dump_words(h, start, end, label):
    h.write("; ---- %s %06X-%06X (big-endian words) ----\n" % (label, start, end))
    ea = start
    while ea + 2 <= end:
        raw = ida_bytes.get_bytes(ea, 16) or b""
        words = " ".join("%04X" % int.from_bytes(raw[i:i + 2], "big")
                         for i in range(0, min(len(raw), 16), 2))
        h.write("%06X  %s\n" % (ea, words))
        ea += 16


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    for name, lo, hi in WINDOWS:
        L.force_code(lo, hi)
    ida_auto.auto_wait()
    for name, lo, hi in WINDOWS:
        with L.open_asm("main2_%s.asm" % name) as h:
            L.dump_range(h, lo, hi, name)

    with L.open_out("main_pll_tables.txt") as h:
        for lo, hi, label in [
            (0x37D80, 0x37F80, "pll word tables"),
            (0x3556, 0x35A0, "ctrl-dac address nibbles"),
        ]:
            dump_words(h, lo, hi, label)

    with L.open_out("main_pll_xrefs.txt") as h:
        for seed in SEEDS:
            fn = ida_funcs.get_func(seed)
            start = fn.start_ea if fn else seed
            size = (fn.end_ea - fn.start_ea) if fn else 0
            h.write("=== %06X func=%06X size=%d %s\n"
                    % (seed, start, size, idc.get_func_name(start) or ""))
            for xr in idautils.XrefsTo(seed, 0):
                owner = ida_funcs.get_func(xr.frm)
                h.write("    from %06X in %s\n"
                        % (xr.frm, idc.get_func_name(owner.start_ea) if owner else "?"))
            if start != seed:
                for xr in idautils.XrefsTo(start, 0):
                    owner = ida_funcs.get_func(xr.frm)
                    h.write("    from %06X in %s (func head)\n"
                            % (xr.frm, idc.get_func_name(owner.start_ea) if owner else "?"))

    # H8S timer registers: dump every instruction in the ORIGINAL functions that
    # touches 0xFFFFD0-0xFFFFFF (TPU/8-bit timer area on this family) so the
    # tick period can be read off.
    with L.open_out("main_timer_refs.tsv") as h:
        h.write("reg\tinsn_ea\tfunc\tdisasm\n")
        for start in idautils.Functions():
            fn = ida_funcs.get_func(start)
            if fn is None:
                continue
            ea = fn.start_ea
            while ea < fn.end_ea:
                size = ida_bytes.get_item_size(ea)
                if size <= 0:
                    break
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea) > 0:
                    for op in insn.ops:
                        if op.type == ida_ua.o_void:
                            break
                        a = op.addr & 0xFFFFFF
                        if 0xFFFFB0 <= a <= 0xFFFFFF or 0xFFFE80 <= a <= 0xFFFEFF:
                            h.write("%06X\t%06X\t%s\t%s\n"
                                    % (a, ea, idc.get_func_name(start) or "",
                                       (idc.generate_disasm_line(ea, 0) or "").replace("\t", " ")))
                ea += size


main()

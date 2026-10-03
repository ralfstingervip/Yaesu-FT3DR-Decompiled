r"""PROTOCOLS job 3: SUB (RX64M) protocol layer.

db PROTO_SUB (seeded from ida\db\radio\SUB.i64).  Run with --reopen.

The earlier survey recovered 455 functions, 421 of them in
0xFFEE0000-0xFFF50000, so most of the code window was never decoded.  This job
force-codes both code windows, rebuilds functions, and then builds the same
full operand cross-reference the MAIN job builds, so questions like "does this
image ever load a CRC polynomial" or "does it touch the RX CRC peripheral" get
an answer over real coverage rather than over 11% of the image.

Output: ida\out\protocols\sub_*.tsv / asm\sub_*.asm
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

import proto_lib as L

CODE_WINDOWS = [
    (0xFFC00000, 0xFFC40000, "rom_low"),
    (0xFFEE0000, 0xFFF50000, "dense"),
]

# RX64M peripherals that matter to a protocol / modem question
PERIPH = [
    (0x00088280, 0x000882A0, "CRC_calculator"),
    (0x00089000, 0x00089100, "S12AD0_12bit_ADC"),
    (0x00089200, 0x00089300, "S12AD1_12bit_ADC"),
    (0x0008A000, 0x0008A200, "SCI0_12_async_serial"),
    (0x000D0100, 0x000D0200, "RSPI"),
    (0x00082000, 0x00082800, "DMAC_DTC"),
    (0x00088000, 0x00088100, "CMT_timers"),
    (0x000A0000, 0x000A0400, "USB0"),
    (0x0008C000, 0x0008C200, "IO_ports"),
    (0x00088100, 0x00088200, "TPU"),
    (0x000C0000, 0x000C0300, "MTU3"),
    (0x0009A500, 0x0009A600, "SSI_serial_sound"),
    (0x0008B000, 0x0008B100, "SCIFA"),
]

TARGETS = [
    (0xFFF508F8, 0xFFF50938, "JPEG_zigzag_64"),
    (0xFFC3E489, 0xFFC3E660, "aprs_setup_labels"),
    (0xFFC3E0B5, 0xFFC3E130, "tone_dcs_dtmf_pager_labels"),
]

CRC_POLYS = [0x1021, 0x8408, 0x8005, 0xA001, 0x04C11DB7, 0xEDB88320,
             0x82F63B78, 0x1EDC6F41, 0xC75, 0xAE3, 0x259, 0x11D, 0x43]


@L.guard
def main() -> None:
    ida_auto.auto_wait()

    made = 0
    for lo, hi, _ in CODE_WINDOWS:
        made += L.force_code(lo, hi)
    ida_auto.auto_wait()

    calls = {}
    for lo, hi, _ in CODE_WINDOWS:
        ea = lo
        while ea < hi:
            f = ida_bytes.get_flags(ea)
            size = ida_bytes.get_item_size(ea)
            if size <= 0:
                size = 1
            if ida_bytes.is_code(f) and ida_bytes.is_head(f):
                mnem = idc.print_insn_mnem(ea).lower()
                if mnem in ("bsr", "jsr"):
                    for n in range(2):
                        ot = idc.get_operand_type(ea, n)
                        t = idc.get_operand_value(ea, n)
                        if ot in (idc.o_near, idc.o_far, idc.o_mem) and 0xFFC00000 <= t <= 0xFFFFFFFF:
                            calls.setdefault(t, []).append(ea)
            ea += size
    newfn = 0
    for t in sorted(calls):
        fn = ida_funcs.get_func(t)
        if fn is None or fn.start_ea != t:
            if ida_funcs.add_func(t):
                newfn += 1
    ida_auto.auto_wait()

    ops = []
    ninsn = 0
    for lo, hi, _ in CODE_WINDOWS:
        ea = lo
        while ea < hi:
            f = ida_bytes.get_flags(ea)
            size = ida_bytes.get_item_size(ea)
            if size <= 0:
                size = 1
            if ida_bytes.is_code(f) and ida_bytes.is_head(f):
                ninsn += 1
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea):
                    mnem = idc.print_insn_mnem(ea)
                    for n in range(6):
                        op = insn.ops[n]
                        if op.type == ida_ua.o_void:
                            break
                        val = None
                        if op.type == ida_ua.o_imm:
                            val = op.value
                        elif op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far,
                                         ida_ua.o_displ):
                            val = op.addr
                        if val is None:
                            continue
                        ops.append((ea, mnem, n, op.type, val & 0xFFFFFFFF))
            ea += size

    with L.open_out("sub_operands.tsv") as h:
        h.write("ea\tfunc\tmnem\topnum\toptype\tvalue\tdisasm\n")
        for e, mnem, n, ot, val in ops:
            h.write("%08X\t%s\t%s\t%d\t%d\t%08X\t%s\n" % (
                e, idc.get_func_name(e) or "", mnem, n, ot, val,
                idc.generate_disasm_line(e, 0) or ""))

    with L.open_out("sub_periph_refs.tsv") as h:
        h.write("block\tlo\thi\tref_ea\tref_func\tvalue\tdisasm\n")
        for lo, hi, name in PERIPH:
            for e, mnem, n, ot, val in ops:
                if lo <= val < hi:
                    h.write("%s\t%08X\t%08X\t%08X\t%s\t%08X\t%s\n" % (
                        name, lo, hi, e, idc.get_func_name(e) or "", val,
                        idc.generate_disasm_line(e, 0) or ""))

    with L.open_out("sub_crc_poly_refs.tsv") as h:
        h.write("poly\tref_ea\tref_func\tmnem\tdisasm\n")
        polyset = set(CRC_POLYS)
        for e, mnem, n, ot, val in ops:
            if val in polyset and ot == ida_ua.o_imm:
                h.write("%08X\t%08X\t%s\t%s\t%s\n" % (
                    val, e, idc.get_func_name(e) or "", mnem,
                    idc.generate_disasm_line(e, 0) or ""))

    with L.open_out("sub_target_refs.tsv") as h:
        h.write("target\tref_ea\tref_func\tvalue\tdisasm\n")
        for lo, hi, name in TARGETS:
            for e, mnem, n, ot, val in ops:
                if lo <= val < hi:
                    h.write("%s\t%08X\t%s\t%08X\t%s\n" % (
                        name, e, idc.get_func_name(e) or "", val,
                        idc.generate_disasm_line(e, 0) or ""))

    with L.open_out("sub_pass.txt") as h:
        h.write("forced_insns %d\nnew_funcs %d\ncall_targets %d\n"
                "instructions_seen %d\noperands %d\nfunctions_now %d\n"
                % (made, newfn, len(calls), ninsn, len(ops),
                   sum(1 for _ in idautils.Functions())))


main()

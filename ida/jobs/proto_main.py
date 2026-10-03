r"""PROTOCOLS job 2: MAIN (H8S) protocol layer.

db PROTO_MAIN (already seeded from ida\db\radio\MAIN.i64).  Run with --reopen.

  1. force-code the whole content range 0x2000..0x80000 and let auto-analysis
     settle, then make functions at every bsr/jsr/jmp target
  2. build a complete operand cross-reference: for every instruction, every
     operand that is an immediate or an absolute address inside the image is
     recorded.  This is what makes "who reads the CTCSS table" answerable
     without relying on IDA's incomplete xref graph.
  3. report all references into the protocol-relevant windows
  4. dump annotated disassembly for the DSP driver and the Fusion windows

Output: ida\out\protocols\main_*.tsv / asm\main_*.asm
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

CONTENT_LO = 0x00002000
CONTENT_HI = 0x00080000

# named windows we want a reference report for
TARGETS = [
    (0x00005072, 0x00005142, "DCS_104_code_table_BCD_be16"),
    (0x00035158, 0x000351BC, "CTCSS_50_tone_table_be16"),
    (0x0005DF52, 0x0005DFD0, "perm126_table"),
    (0x0005D27C, 0x0005D320, "fusion_mode_strings"),
    (0x0005AE1C, 0x0005AF80, "dsp_link_strings"),
    (0x0000C8BE, 0x0000C8F0, "dtmf_strings"),
    (0x000503DF, 0x00050420, "aprs_msgtype_table"),
    (0x00043780, 0x00044600, "aprs_symbol_tables"),
    (0x00008264, 0x00008320, "wiresx_strings"),
    (0x0002C780, 0x0002C7B0, "dgid_strings"),
    (0x0006DD40, 0x0006DD70, "dgid_strings2"),
    (0x00035110, 0x00035158, "band_edge_bcd"),
]

# windows to force-decode and dump verbatim
DUMPS = [
    (0x0005A000, 0x0005B400, "dsp_driver"),
    (0x0005C700, 0x0005D280, "fusion_mode_fn"),
    (0x00068100, 0x00068400, "perm126_user"),
    (0x00034A00, 0x00035160, "ctcss_user"),
    (0x0000D100, 0x0000D300, "tone_dcs_ui"),
    (0x00025F00, 0x000260E0, "dcs_user2"),
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    made = L.force_code(CONTENT_LO, CONTENT_HI)
    ida_auto.auto_wait()

    # make functions at every call target so frames/names exist
    newfn = 0
    calls = {}
    for ea in range(CONTENT_LO, CONTENT_HI):
        f = ida_bytes.get_flags(ea)
        if not (ida_bytes.is_code(f) and ida_bytes.is_head(f)):
            continue
        mnem = idc.print_insn_mnem(ea).lower()
        if mnem in ("bsr", "jsr"):
            for n in range(2):
                t = idc.get_operand_value(ea, n)
                ot = idc.get_operand_type(ea, n)
                if ot in (idc.o_near, idc.o_far, idc.o_mem) and CONTENT_LO <= t < CONTENT_HI:
                    calls.setdefault(t, []).append(ea)
    for t in sorted(calls):
        if ida_funcs.get_func(t) is None or ida_funcs.get_func(t).start_ea != t:
            if ida_funcs.add_func(t):
                newfn += 1
    ida_auto.auto_wait()

    # ---- full operand cross reference
    ops = []          # (ea, mnem, opnum, optype, value)
    ninsn = 0
    ea = CONTENT_LO
    while ea < CONTENT_HI:
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
                    elif op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far):
                        val = op.addr
                    elif op.type == ida_ua.o_displ:
                        val = op.addr
                    if val is None:
                        continue
                    ops.append((ea, mnem, n, op.type, val & 0xFFFFFFFF))
        ea += size

    with L.open_out("main_operands.tsv") as h:
        h.write("ea\tfunc\tmnem\topnum\toptype\tvalue\tdisasm\n")
        for e, mnem, n, ot, val in ops:
            h.write("%08X\t%s\t%s\t%d\t%d\t%08X\t%s\n" % (
                e, idc.get_func_name(e) or "", mnem, n, ot, val,
                idc.generate_disasm_line(e, 0) or ""))

    with L.open_out("main_target_refs.tsv") as h:
        h.write("target\ttarget_lo\ttarget_hi\tref_ea\tref_func\tvalue\tdisasm\n")
        for lo, hi, name in TARGETS:
            for e, mnem, n, ot, val in ops:
                if lo <= val < hi:
                    h.write("%s\t%08X\t%08X\t%08X\t%s\t%08X\t%s\n" % (
                        name, lo, hi, e, idc.get_func_name(e) or "", val,
                        idc.generate_disasm_line(e, 0) or ""))
            # also IDA's own xrefs to every address in the window
            for a in range(lo, hi):
                for frm, kind, fname in L.xrefs_to(a):
                    h.write("%s\t%08X\t%08X\t%08X\t%s\t%08X\tXREF_%s %s\n" % (
                        name, lo, hi, frm, fname, a, kind,
                        idc.generate_disasm_line(frm, 0) or ""))

    for lo, hi, name in DUMPS:
        L.force_code(lo, hi)
    ida_auto.auto_wait()
    with L.open_asm("main_windows.asm") as h:
        for lo, hi, name in DUMPS:
            L.dump_range(h, lo, hi, name)
            h.write("\n")

    with L.open_out("main_pass.txt") as h:
        h.write("forced_insns %d\nnew_funcs %d\ncall_targets %d\n"
                "instructions_seen %d\noperands %d\nfunctions_now %d\n"
                % (made, newfn, len(calls), ninsn, len(ops),
                   sum(1 for _ in idautils.Functions())))


main()

"""STORAGE pass 6: who raises message 0xAB ("FIRM ERROR"), what the card-read
paths parse, and whether anything loadable comes off the card.
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
import ida_xref
import idautils
import idc

import stor_lib as L

BASE = 0xFFC00000
CODE_LO = BASE + 0x2D8000
CODE_HI = BASE + 0x350000

TARGET_IMMS = {0xAB: "FIRM ERROR id", 0xA7: "NO SD CARD id",
               0xA8: "SD CARD FULL id", 0xA0: "W PROTECT id",
               0xA1: "MCH ERROR id", 0xA5: "MS ERROR id"}

DUMP_FUNCS = [
    0xFFF0B1DB,          # popup message processor
    0xFFF25B0B, 0xFFF25AF0, 0xFFF25DDF,   # LMREPAIR
    0xFFF3BA24, 0xFFF3FE06,               # I:\LMREPAIR feature
    0xFFF1427F, 0xFFF14576,               # 'r' readers group B
    0xFFF12E8B, 0xFFF12F9B, 0xFFF130F3,   # 'r' readers group A
    0xFFF35454,
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()

    with L.open_out("imm_sites.tsv") as h:
        h.write("imm\tlabel\tea\tfile_off\tfunction\tdisasm\n")
        ea = CODE_LO
        while ea < CODE_HI:
            size = ida_bytes.get_item_size(ea) or 1
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                for i in range(4):
                    try:
                        t = idc.get_operand_type(ea, i)
                    except Exception:
                        break
                    if t == 5:  # o_imm
                        v = idc.get_operand_value(ea, i)
                        if v in TARGET_IMMS:
                            h.write("%02X\t%s\t%08X\t%06X\t%s\t%s\n"
                                    % (v, TARGET_IMMS[v], ea, ea - BASE,
                                       idc.get_func_name(ea) or "",
                                       idc.generate_disasm_line(ea, 0) or ""))
            ea += size

    with L.open_asm("firm.asm") as h:
        for fa in DUMP_FUNCS:
            f = ida_funcs.get_func(fa)
            if f is None:
                h.write("; ==== %08X no func ====\n" % fa)
                continue
            callers = ["%08X(%s)" % (c, idc.get_func_name(c) or "")
                       for c in idautils.CodeRefsTo(f.start_ea, 0)]
            h.write("\n; ######## %s %08X-%08X (file %06X) callers: %s\n"
                    % (idc.get_func_name(fa) or "", f.start_ea, f.end_ea,
                       f.start_ea - BASE, ", ".join(callers[:14])))
            L.dump_range(h, f.start_ea, f.end_ea)

    with L.open_out("pass6_log.txt") as h:
        h.write("done\n")


main()

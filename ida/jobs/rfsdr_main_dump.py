"""RF-SDR pass 1 on the MAIN (H8S advanced) image.

Records every instruction that touches the on-chip I/O register page
(0xFFFE80-0xFFFFFF, reached by @aa:8 / @aa:16 absolute addressing), grouped by
register, then dumps the vector table and the listings for the busiest
register-touching functions.  Also records bit-manipulation ops separately,
because a bit-banged serial bus to a synthesiser shows up as BSET/BCLR runs on
one port.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import sys

sys.path.insert(0, str(_REPO / "ida/jobs"))

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

import rfsdr_lib as L

CODE_LO = 0x0000
CODE_HI = 0x80000
IO_LO = 0xFFFE80
IO_HI = 0x1000000


def io_addr(value: int):
    v = value & 0xFFFFFF
    if IO_LO <= v < IO_HI:
        return v
    return None


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    log = L.open_out("main_pass1_log.txt")

    # ---- vector table -----------------------------------------------------
    with L.open_out("main_vectors.tsv") as h:
        h.write("slot\tslot_ea\thandler\tin_code\tfunc\n")
        counts = collections.Counter()
        vals = []
        for i in range(256):
            ea = i * 4
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 4)
            ida_bytes.create_dword(ea, 4, True)
            v = ida_bytes.get_dword(ea)
            counts[v] += 1
            vals.append((i, ea, v))
        for i, ea, v in vals:
            inside = CODE_LO < v < CODE_HI
            if inside:
                ida_ua.create_insn(v)
                ida_auto.auto_make_code(v)
            fn = ida_funcs.get_func(v)
            h.write(
                "%d\t%08X\t%08X\t%s\t%s\n"
                % (i, ea, v, "yes" if inside else "no",
                   idc.get_func_name(fn.start_ea) if fn else "")
            )
        log.write("vector most common %s\n" % (counts.most_common(3),))
    ida_auto.auto_wait()

    # ---- force code over the whole content region -------------------------
    before = len(list(idautils.Functions()))
    made = L.force_code(CODE_LO + 0x400, CODE_HI)
    ida_auto.auto_wait()
    after = len(list(idautils.Functions()))
    log.write("force_code made %d insns, functions %d -> %d\n" % (made, before, after))

    # ---- walk every instruction, record I/O references --------------------
    per_reg = collections.Counter()
    bitops = collections.Counter()
    rows = []
    ea = CODE_LO + 0x400
    total = 0
    while ea < CODE_HI:
        flags = ida_bytes.get_flags(ea)
        size = ida_bytes.get_item_size(ea)
        if size <= 0:
            size = 1
        if not (ida_bytes.is_code(flags) and ida_bytes.is_head(flags)):
            ea += size
            continue
        insn = ida_ua.insn_t()
        n = ida_ua.decode_insn(insn, ea)
        if n <= 0:
            ea += size
            continue
        total += 1
        found = []
        for op in insn.ops:
            if op.type == ida_ua.o_void:
                break
            if op.type in (ida_ua.o_mem, ida_ua.o_displ, ida_ua.o_far, ida_ua.o_near):
                a = io_addr(op.addr)
                if a is not None:
                    found.append(a)
        if found:
            line = idc.generate_disasm_line(ea, 0) or ""
            mnem = (idc.print_insn_mnem(ea) or "").lower()
            fn = ida_funcs.get_func(ea)
            for a in found:
                per_reg[a] += 1
                if mnem.startswith("b"):
                    bitops[a] += 1
                rows.append(
                    (a, ea, mnem, idc.get_func_name(fn.start_ea) if fn else "", line)
                )
        ea += size
    log.write("instructions walked %d, io refs %d, distinct regs %d\n"
              % (total, len(rows), len(per_reg)))

    with L.open_out("main_ioregs.tsv") as h:
        h.write("reg\trefs\tbitops\n")
        for a, c in sorted(per_reg.items()):
            h.write("%06X\t%d\t%d\n" % (a, c, bitops[a]))
    with L.open_out("main_iorefs.tsv") as h:
        h.write("reg\tinsn_ea\tmnem\tfunc\tdisasm\n")
        for a, insn_ea, mnem, fn, line in rows:
            h.write("%06X\t%06X\t%s\t%s\t%s\n" % (a, insn_ea, mnem, fn, line.replace("\t", " ")))

    # ---- functions ranked by I/O density ---------------------------------
    by_func = collections.Counter()
    func_regs = collections.defaultdict(set)
    for a, insn_ea, _m, fn, _l in rows:
        owner = ida_funcs.get_func(insn_ea)
        key = owner.start_ea if owner else (insn_ea & ~0xFF)
        by_func[key] += 1
        func_regs[key].add(a)
    with L.open_out("main_iofuncs.tsv") as h:
        h.write("func\trefs\tdistinct_regs\tregs\n")
        for key, c in by_func.most_common(400):
            h.write("%06X\t%d\t%d\t%s\n"
                    % (key, c, len(func_regs[key]),
                       ",".join("%06X" % r for r in sorted(func_regs[key]))))

    with L.open_out("main_funcs.tsv") as h:
        h.write("ea\tend\tsize\tname\n")
        for start in idautils.Functions():
            fn = ida_funcs.get_func(start)
            if fn is None:
                continue
            h.write("%06X\t%06X\t%d\t%s\n"
                    % (start, fn.end_ea, fn.end_ea - start, idc.get_func_name(start) or ""))
    log.close()
    _ = os


main()

r"""Lane K6 -- SUB SD/MMC storage driver: vtable, peripheral evidence, geometry records.

Read-only on the database except for IDA's own analysis state.  Writes:
  ida\out\sub-sdmmc\raw\periph_all.tsv   every peripheral-window access (whole DB,
                                         functions + orphan code), const-propagated
  ida\out\sub-sdmmc\raw\disasm_sd.txt    full disassembly of the SD/FAT block range
                                         plus extra functions, with callers
  ida\out\sub-sdmmc\raw\refs.txt         o_imm/o_mem/data refs into the driver tables
  ida\out\sub-sdmmc\raw\funcs_range.tsv  function list of the range
  ida\out\sub-sdmmc\raw\status.txt
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-sdmmc\raw")
os.makedirs(OUT, exist_ok=True)
STATUS = os.path.join(OUT, "status.txt")
BASE = 0xFFC00000
PLO, PHI = 0x00080000, 0x00100000

RANGE_LO = int(os.environ.get("K6_LO", "0xFFF2E000"), 16)
RANGE_HI = int(os.environ.get("K6_HI", "0xFFF37900"), 16)
EXTRA = [int(x, 16) for x in os.environ.get("K6_EXTRA", "").split(",") if x.strip()]
DO_PERIPH = os.environ.get("K6_PERIPH", "1") == "1"
DISASM_NAME = os.environ.get("K6_DISNAME", "disasm_sd.txt")

TABLES = [
    ("sd_vtable", 0xFFED7EB0, 0xFFED7F18),
    ("mask_tbl", 0xFFED7F18, 0xFFED7F60),
    ("geom_rec", 0xFFED7F60, 0xFFED819C),
    ("tbl_819c", 0xFFED819C, 0xFFED81F8),
    ("cmd_tbl", 0xFFECE1E4, 0xFFECE264),
    ("acmd_tbl", 0xFFECE264, 0xFFECE2CC),
    ("str_7e90", 0xFFED7E90, 0xFFED7EB0),
]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def main():
    import ida_auto, ida_bytes, ida_funcs, ida_segment, ida_ua, ida_lines, ida_name
    import idautils, idc
    ida_auto.auto_wait()
    o_reg, o_mem, o_phrase, o_displ, o_imm, o_far, o_near = 1, 2, 3, 4, 5, 6, 7

    funcs = list(idautils.Functions())
    log("functions %d" % len(funcs))

    # ---------------- table refs (all code heads) -----------------
    trefs = []

    def check_tables(ea, insn, fname):
        for n in range(6):
            op = insn.ops[n]
            if op.type == 0:
                break
            vals = []
            if op.type == o_imm:
                vals.append(op.value & 0xFFFFFFFF)
            if op.type in (o_mem, o_near, o_far):
                vals.append(op.addr & 0xFFFFFFFF)
            for v in vals:
                for nm, lo, hi in TABLES:
                    if lo <= v < hi:
                        trefs.append((nm, v, ea, fname, esc(idc.generate_disasm_line(ea, 0))))

    rows = []

    def scan_range(start, end, fname):
        regs = {}
        ea = start
        while ea != idc.BADADDR and ea < end:
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                ea = idc.next_head(ea, end)
                regs = {}
                continue
            insn = ida_ua.insn_t()
            if not ida_ua.decode_insn(insn, ea):
                ea = idc.next_head(ea, end)
                continue
            check_tables(ea, insn, fname)
            mnem = idc.print_insn_mnem(ea) or ""
            if DO_PERIPH:
                for n in range(6):
                    op = insn.ops[n]
                    if op.type == 0:
                        break
                    if op.type == o_imm:
                        v = op.value & 0xFFFFFFFF
                        if PLO <= v < PHI:
                            rows.append((ea, fname, "imm", v))
                    elif op.type in (o_mem, o_far, o_near):
                        v = op.addr & 0xFFFFFFFF
                        if PLO <= v < PHI:
                            rows.append((ea, fname, "mem", v))
                    elif op.type in (o_phrase, o_displ):
                        r = op.reg
                        disp = (op.value & 0xFFFFFFFF) if op.type == o_displ else 0
                        if r in regs:
                            v = (regs[r] + disp) & 0xFFFFFFFF
                            if PLO <= v < PHI:
                                rows.append((ea, fname, "reg+disp", v))
            if mnem.startswith("mov") and insn.ops[0].type == o_imm and insn.ops[1].type == o_reg:
                regs[insn.ops[1].reg] = insn.ops[0].value & 0xFFFFFFFF
            elif mnem == "add" and insn.ops[0].type == o_imm and insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                r = insn.ops[1].reg
                if r in regs:
                    regs[r] = (regs[r] + (insn.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
            else:
                for n in range(6):
                    op = insn.ops[n]
                    if op.type == 0:
                        break
                    if op.type == o_reg and n == (1 if insn.ops[1].type != 0 else 0):
                        regs.pop(op.reg, None)
                if insn.ops[2].type == o_reg:
                    regs.pop(insn.ops[2].reg, None)
                if mnem in ("bsr", "jsr", "bra", "jmp") or mnem.startswith(("rts", "rte")):
                    regs = {}
            ea = idc.next_head(ea, end)

    for s in funcs:
        f = ida_funcs.get_func(s)
        if f is None:
            continue
        scan_range(f.start_ea, f.end_ea, idc.get_func_name(s) or "")
    orphan = 0
    seg = ida_segment.get_first_seg()
    while seg is not None:
        ea = seg.start_ea
        while ea != idc.BADADDR and ea < seg.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_funcs.get_func(ea) is None:
                nxt = ea
                end = ea
                while nxt != idc.BADADDR and nxt < seg.end_ea and \
                        ida_bytes.is_code(ida_bytes.get_flags(nxt)) and ida_funcs.get_func(nxt) is None:
                    end = nxt + max(1, idc.get_item_size(nxt))
                    nxt = idc.next_head(nxt, seg.end_ea)
                scan_range(ea, end, "orphan_%08X" % ea)
                orphan += 1
                ea = nxt
            else:
                ea = idc.next_head(ea, seg.end_ea)
        seg = ida_segment.get_next_seg(seg.start_ea)
    log("orphan runs %d periph rows %d table refs %d" % (orphan, len(rows), len(trefs)))

    if DO_PERIPH:
        with open(os.path.join(OUT, "periph_all.tsv"), "w", encoding="utf-8", newline="\n") as h:
            h.write("periph_addr\tform\tinsn_ea\tfile_off\tfunction\tbytes\tdisasm\n")
            for ea, fname, form, v in sorted(rows, key=lambda r: (r[3], r[0])):
                b = ida_bytes.get_bytes(ea, max(1, idc.get_item_size(ea))) or b""
                h.write("%08X\t%s\t%08X\t%06X\t%s\t%s\t%s\n" % (
                    v, form, ea, ea - BASE, fname, b.hex(), esc(idc.generate_disasm_line(ea, 0))))

    with open(os.path.join(OUT, "refs.txt"), "w", encoding="utf-8", newline="\n") as h:
        for nm, lo, hi in TABLES:
            h.write("== %s %08X-%08X\n" % (nm, lo, hi))
            for t in trefs:
                if t[0] == nm:
                    h.write("  %08X <- %08X %s : %s\n" % (t[1], t[2], t[3], t[4]))
            for a in range(lo, hi, 4):
                for x in idautils.XrefsTo(a, 0):
                    h.write("  dataxref %08X <- %08X (type %d) %s\n" % (a, x.frm, x.type, idc.get_func_name(x.frm) or ""))

    # ---------------- function list + disassembly -----------------
    targets = [s for s in funcs if RANGE_LO <= s < RANGE_HI] + EXTRA
    with open(os.path.join(OUT, "funcs_range.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\tname\tncallers\n")
        for s in targets:
            f = ida_funcs.get_func(s)
            if not f:
                continue
            nc = len(list(idautils.CodeRefsTo(f.start_ea, 0)))
            h.write("%08X\t%08X\t%d\t%s\t%d\n" % (f.start_ea, f.end_ea, f.end_ea - f.start_ea,
                                                    idc.get_func_name(s), nc))
    with open(os.path.join(OUT, DISASM_NAME), "w", encoding="utf-8", newline="\n") as h:
        for s in targets:
            f = ida_funcs.get_func(s)
            if not f:
                h.write("!! no func at %08X\n" % s)
                continue
            h.write("\n==== FUNC %08X %s (end %08X)\n" % (f.start_ea, idc.get_func_name(s), f.end_ea))
            for x in idautils.XrefsTo(f.start_ea, 0):
                h.write("  caller %08X %s t%d\n" % (x.frm, idc.get_func_name(x.frm) or "", x.type))
            for ea in idautils.FuncItems(f.start_ea):
                sz = max(ida_bytes.get_item_size(ea), 1)
                b = ida_bytes.get_bytes(ea, min(sz, 10)) or b""
                lab = ida_name.get_name(ea) if ea != f.start_ea and ida_name.get_name(ea) else ""
                h.write("%08X  %-20s %-14s %s\n" % (ea, b.hex(), lab,
                        ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")))
    log("done")


with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
    _h.write("start\n")
try:
    main()
except Exception:
    log("EXC\n" + traceback.format_exc())
finally:
    import idc as _idc
    _idc.qexit(0)

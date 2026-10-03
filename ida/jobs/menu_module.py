r"""MENU job 3: dump the setup-menu module and the gate writes.

Regions of interest established by jobs 1 and 2:
  sub_FFF09171  menu_draw_page(x,y)      list renderer, 6 rows
  sub_FFF095E3  menu_item_count(cat)     count with the OPTION +1 / SIGNALING -1 gates
  sub_FFF0964A  menu_draw_row(x,y,c,i)   the walker, mul #14h
  sub_FFEE25C6  settings default writer (0x8C4D / 0x8E46 struct bases)
  0xFFED75FC    per-category handler table, FFEF2032 is the shared stub
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_segment
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/menu")
os.makedirs(OUT, exist_ok=True)
LOG = []


def log(m):
    LOG.append(str(m))


def w(name, text):
    with open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def slab(start, end):
    lines = []
    q = start
    while q < end:
        sz = ida_bytes.get_item_size(q) or 1
        fn = ida_funcs.get_func(q)
        if fn and fn.start_ea == q:
            lines.append("")
            lines.append("; ---- %s  %08X-%08X" % (ida_funcs.get_func_name(q), fn.start_ea, fn.end_ea))
        raw = " ".join("%02X" % ida_bytes.get_byte(q + i) for i in range(min(8, sz)))
        lines.append("%08X  %-24s %s" % (q, raw, idc.generate_disasm_line(q, 0) or "?"))
        q += sz
    return "\n".join(lines)


def dump_func(ea, tag=""):
    fn = ida_funcs.get_func(ea)
    if fn is None:
        return "### no function at %08X %s\n" % (ea, tag)
    out = ["###### %s  %08X-%08X  %s" % (ida_funcs.get_func_name(fn.start_ea),
                                         fn.start_ea, fn.end_ea, tag)]
    out.append(slab(fn.start_ea, fn.end_ea))
    out.append("")
    return "\n".join(out)


def main():
    ida_auto.auto_wait()

    # 1. the whole setup-menu module
    w("menu_module_disasm.txt", slab(0xFFF08000, 0xFFF0B400))

    # 2. specific functions
    parts = []
    for ea, tag in ((0xFFEE25C6, "settings default writer"),
                    (0xFFF004C2, "other caller of the walker"),
                    (0xFFEF2032, "shared stub / null handler"),
                    (0xFFEFA7E7, "string draw used by the localised handlers"),
                    (0xFFEF1B23, "string draw used by the generic walker"),
                    (0xFFF09171, "menu_draw_page"),
                    (0xFFF095E3, "menu_item_count")):
        parts.append(dump_func(ea, tag))
    w("menu_support_funcs.txt", "\n".join(parts))

    # 3. every instruction whose effective address lands on the gate bytes,
    #    including base+displacement forms. Walk code, decode, and for each
    #    operand of type o_displ resolve base-register immediates seen recently.
    gates = {0x8C4D: "settings struct base A",
             0x8E46: "settings struct base B",
             0x8F72: "language flag",
             0x8C6D: "current category",
             0x8C6E: "scroll top",
             0x8C6F: "cursor row"}
    rows = ["kind\tvalue\tsite\tfunc\tdisasm"]
    for seg_i in range(ida_segment.get_segm_qty()):
        seg = ida_segment.getnseg(seg_i)
        if seg.start_ea < 0xFFEC0000:
            continue
        ea = seg.start_ea
        # track the last immediate loaded into each register, so base+disp
        # accesses against 0x8C4D / 0x8E46 can be resolved to an absolute byte
        reg_imm = {}
        while ea < seg.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea):
                    mnem = insn.get_canon_mnem()
                    fn = ida_funcs.get_func(ea)
                    fname = ida_funcs.get_func_name(fn.start_ea) if fn else "-"
                    # mov.l #imm, rN  -> remember it
                    if mnem.lower().startswith("mov") and insn.ops[0].type == 5 and insn.ops[1].type == 1:
                        reg_imm[insn.ops[1].reg] = insn.ops[0].value
                        if insn.ops[0].value in gates:
                            rows.append("base\t%08X\t%08X\t%s\t%s" % (
                                insn.ops[0].value, ea, fname,
                                idc.generate_disasm_line(ea, 0) or "?"))
                    else:
                        for op in insn.ops:
                            if op.type == 0:
                                break
                            if op.type == 4:  # o_displ
                                base = reg_imm.get(op.reg)
                                if base is not None and 0x8C00 <= base <= 0x9100:
                                    abs_ea = base + op.addr
                                    rows.append("field\t%08X\t%08X\t%s\t%s" % (
                                        abs_ea, ea, fname,
                                        idc.generate_disasm_line(ea, 0) or "?"))
                        if mnem.lower().startswith(("bsr", "jsr", "bra", "jmp", "rts")):
                            reg_imm.clear()
                sz = ida_bytes.get_item_size(ea) or 1
                ea += sz
            else:
                reg_imm.clear()
                sz = ida_bytes.get_item_size(ea) or 1
                ea += sz
    w("settings_fields.tsv", "\n".join(rows) + "\n")
    log("settings_fields rows %d" % (len(rows) - 1))

    # 4. xrefs to the shared stub, to size the "unimplemented" population
    stub_refs = len(list(idautils.XrefsTo(0xFFEF2032, 0)))
    log("xrefs to stub FFEF2032: %d" % stub_refs)

    idc.save_database("")


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
w("job3_log.txt", "\n".join(LOG) + "\n")
idc.qexit(0)

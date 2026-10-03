r"""MENU job 2: the menu dispatch chain, the settings store, and hidden-mode gates.

Runs against the MENU database that menu_walk.py already recovered (1463 funcs).
Extends the sweep down into 0xFFED0000 (code continues below the DENSE segment)
and dumps:
  * callers of the item-count function sub_FFF095E3 and the row walker sub_FFF0964A
  * every function that touches the gate bytes at RAM 0x8C4D / 0x8E46 / 0x8F72
  * the per-category dispatch targets
  * a full immediate/operand census so peripheral use can be cross-checked
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_segment
import ida_ua
import ida_xref
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


def sweep(start, end):
    made = 0
    ea = start
    while ea < end:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) or (ida_bytes.is_data(fl) and ida_bytes.is_head(fl)):
            n = ida_bytes.get_item_size(ea)
            ea += n if n > 0 else 1
            continue
        n = ida_ua.create_insn(ea)
        if n > 0:
            made += 1
            ea += n
        else:
            ea += 1
    return made


def add_call_targets(start, end):
    made = 0
    ea = start
    while ea < end:
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            ea += 1
            continue
        for xr in idautils.XrefsFrom(ea, 0):
            if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF) and ida_funcs.get_func(xr.to) is None:
                if ida_funcs.add_func(xr.to):
                    made += 1
        n = ida_bytes.get_item_size(ea)
        ea += n if n > 0 else 1
    return made


def dump_func(ea, tag=""):
    fn = ida_funcs.get_func(ea)
    lines = []
    if fn is None:
        lines.append("### no function at %08X %s" % (ea, tag))
        q = ea
        end = ea + 0x80
    else:
        lines.append("###### %s  %08X-%08X  %s" %
                     (ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea, tag))
        q = fn.start_ea
        end = fn.end_ea
    while q < end:
        sz = ida_bytes.get_item_size(q) or 1
        raw = " ".join("%02X" % ida_bytes.get_byte(q + i) for i in range(min(8, sz)))
        lines.append("  %08X  %-24s %s" % (q, raw, idc.generate_disasm_line(q, 0) or "?"))
        q += sz
    lines.append("")
    return "\n".join(lines)


def callers_of(ea):
    res = []
    for xr in idautils.XrefsTo(ea, 0):
        fn = ida_funcs.get_func(xr.frm)
        res.append((xr.frm, xr.type,
                    ida_funcs.get_func_name(fn.start_ea) if fn else "-",
                    fn.start_ea if fn else 0,
                    idc.generate_disasm_line(xr.frm, 0) or "?"))
    return res


def main():
    ida_auto.auto_wait()
    log("functions at start %d" % len(list(idautils.Functions())))
    for a, b in ((0xFFED0000, 0xFFEE0000), (0xFFEC0000, 0xFFED0000)):
        log("sweep %08X-%08X made %d" % (a, b, sweep(a, b)))
        ida_auto.auto_wait()
    for a, b in ((0xFFEC0000, 0xFFF50000),):
        log("call targets %08X-%08X: %d" % (a, b, add_call_targets(a, b)))
        ida_auto.auto_wait()
    log("functions after %d" % len(list(idautils.Functions())))

    # ---- 1. callers of the count function and the walker
    parts = []
    for ea, tag in ((0xFFF095E3, "menu_item_count(cat) - adds/removes an item"),
                    (0xFFF0964A, "menu_draw_row(x,y,cat,item) - the walker")):
        parts.append("=== callers of %08X  %s ===" % (ea, tag))
        cs = callers_of(ea)
        if not cs:
            parts.append("  (none)")
        for frm, t, fname, fstart, dis in cs:
            parts.append("  %08X  %-22s %s" % (frm, fname, dis))
        parts.append("")
    w("walker_callers.txt", "\n".join(parts) + "\n")

    # full bodies of the callers
    parts = []
    seen = set()
    for ea in (0xFFF095E3, 0xFFF0964A):
        for frm, t, fname, fstart, dis in callers_of(ea):
            if fstart and fstart not in seen:
                seen.add(fstart)
                parts.append(dump_func(fstart, "caller of %08X" % ea))
    w("walker_caller_funcs.txt", "\n".join(parts) + "\n")

    # ---- 2. the gate bytes: who reads/writes them
    # gates found in sub_FFF095E3: base 0x8E46 +7 bit7 (OPTION +1), base 0x8C4D +6 (SIGNALING -1)
    # and 0x8F72 in sub_FFF0964A (language)
    gate_bases = [0x8C4D, 0x8E46, 0x8F72, 0x8C53, 0x8E4D]
    rows = ["const\tsite\tfunc\tdisasm"]
    # find every instruction whose operand value equals one of the gate bases
    gset = set(gate_bases)
    for seg_i in range(ida_segment.get_segm_qty()):
        seg = ida_segment.getnseg(seg_i)
        if seg.start_ea < 0xFFEC0000:
            continue
        ea = seg.start_ea
        while ea < seg.end_ea:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea):
                    for op in insn.ops:
                        if op.type == 0:
                            break
                        v = op.value if op.type == 5 else op.addr
                        if v in gset:
                            fn = ida_funcs.get_func(ea)
                            rows.append("%08X\t%08X\t%s\t%s" % (
                                v, ea,
                                ida_funcs.get_func_name(fn.start_ea) if fn else "-",
                                idc.generate_disasm_line(ea, 0) or "?"))
                            break
            sz = ida_bytes.get_item_size(ea) or 1
            ea += sz
    w("gate_refs.tsv", "\n".join(rows) + "\n")

    # ---- 3. the per-category dispatch targets from sub_FFF0964A
    targets = [0xFFF097AF, 0xFFF098CC, 0xFFF09944, 0xFFF09A75, 0xFFF09B88,
               0xFFF09C73, 0xFFF09E12, 0xFFF0A108, 0xFFF0A22A, 0xFFF0A262,
               0xFFF0A309, 0xFFF0A4DE, 0xFFF0A711, 0xFFF0A7B9, 0xFFF0A84B]
    parts = []
    for t in targets:
        parts.append(dump_func(t, "category draw handler"))
    w("category_handlers.txt", "\n".join(parts) + "\n")

    # ---- 4. full immediate census, every code byte in the recovered regions
    rows = ["value\tsite\tfunc\tmnem\tdisasm"]
    for seg_i in range(ida_segment.get_segm_qty()):
        seg = ida_segment.getnseg(seg_i)
        ea = seg.start_ea
        while ea < seg.end_ea:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea):
                    for op in insn.ops:
                        if op.type == 0:
                            break
                        v = op.value if op.type == 5 else op.addr
                        if 0x00080000 <= v <= 0x0010FFFF or 0x00700000 <= v <= 0x007FFFFF:
                            fn = ida_funcs.get_func(ea)
                            rows.append("%08X\t%08X\t%s\t%s\t%s" % (
                                v, ea,
                                ida_funcs.get_func_name(fn.start_ea) if fn else "-",
                                insn.get_canon_mnem(),
                                idc.generate_disasm_line(ea, 0) or "?"))
            sz = ida_bytes.get_item_size(ea) or 1
            ea += sz
    w("periph_census.tsv", "\n".join(rows) + "\n")
    log("periph_census rows %d" % (len(rows) - 1))

    funcs = sorted(idautils.Functions())
    rows = ["ea\tend\tsize\tname"]
    for f in funcs:
        fn = ida_funcs.get_func(f)
        rows.append("%08X\t%08X\t%d\t%s" % (fn.start_ea, fn.end_ea,
                                            fn.end_ea - fn.start_ea,
                                            ida_funcs.get_func_name(f)))
    w("functions_menu.tsv", "\n".join(rows) + "\n")
    log("total functions %d" % len(funcs))
    idc.save_database("")


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
w("job2_log.txt", "\n".join(LOG) + "\n")
idc.qexit(0)

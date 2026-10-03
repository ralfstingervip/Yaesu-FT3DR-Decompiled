r"""MENU job 1: force-recover the 0xFFEE0000-0xFFF50000 code and disassemble the
setup-menu walker.

Seeds from ida\db\radio\SUB.i64 (455 functions). The regions that hold every
reference to the menu descriptor table (0xFFED74E8) and the menu label arrays
(0xFFC3DD55 / 0xFFC3DF4D) were never disassembled by the earlier pass:
functions.tsv has zero functions in 0xFFF00000-0xFFF10000.

Writes to ida/out/menu.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import sys
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_nalt
import ida_segment
import ida_ua
import ida_xref
import idautils
import idc

OUT = str(_REPO / "ida/out/menu")
os.makedirs(OUT, exist_ok=True)
JOB = os.environ.get("YAESU_JOB", "MENU")


def w(path, text):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


LOG = []


def log(msg):
    LOG.append(str(msg))


# Sites that hold the menu constants (the mov.l #imm32 starts 2 bytes before
# the immediate, RX encodes FB E2 <imm32> as mov.l #imm32, r14).
SEEDS = [
    (0xFFF095EB, "mov.l #FFED74E8 (menu descriptor base, 1-based)"),
    (0xFFF09695, "mov.l #FFED74E8 (menu descriptor base, 1-based)"),
    (0xFFEFE38A, "mov.l #FFC3DF35"),
    (0xFFF08A11, "mov.l #FFC3DF35"),
    (0xFFF08CA0, "mov.l #FFC3DF35"),
    (0xFFF0A88F, "mov.l #FFED75FC"),
    (0xFFF0897E, "prior pass: judged switch jump table -> FFED75A8"),
    (0xFFF08B1F, "prior pass: judged switch jump table -> FFED75B8"),
]

SWEEP = [
    (0xFFEE0000, 0xFFF50000),
]


def sweep(start, end):
    """Linear sweep: create an instruction at every undefined byte."""
    made = 0
    ea = start
    while ea < end:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            n = ida_bytes.get_item_size(ea)
            ea += n if n > 0 else 1
            continue
        if ida_bytes.is_data(fl) and ida_bytes.is_head(fl):
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
    """Create functions at every bsr/jsr target inside the range."""
    made = 0
    ea = start
    while ea < end:
        fl = ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(fl):
            ea += 1
            continue
        for xr in idautils.XrefsFrom(ea, 0):
            if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                if ida_funcs.get_func(xr.to) is None:
                    if ida_funcs.add_func(xr.to):
                        made += 1
        n = ida_bytes.get_item_size(ea)
        ea += n if n > 0 else 1
    return made


def dis(ea, back=0x60, fwd=0xC0):
    """Text disassembly window. Walks forward from a known-good instruction
    start so alignment is right; the backward part is best-effort."""
    lines = []
    cur = ea - back
    # find an alignment that reaches ea exactly
    for k in range(back + 1):
        p = ea - back + k
        q = p
        ok = True
        while q < ea:
            n = ida_bytes.get_item_size(q) if ida_bytes.is_code(ida_bytes.get_flags(q)) else 0
            if n <= 0:
                ok = False
                break
            q += n
        if ok and q == ea:
            cur = p
            break
    else:
        cur = ea
    q = cur
    while q < ea + fwd:
        fl = ida_bytes.get_flags(q)
        txt = idc.generate_disasm_line(q, 0) or "?"
        raw = " ".join("%02X" % ida_bytes.get_byte(q + i)
                       for i in range(min(8, max(1, ida_bytes.get_item_size(q) or 1))))
        mark = "==>" if q == ea else "   "
        lines.append("%s %08X  %-24s %s" % (mark, q, raw, txt))
        n = ida_bytes.get_item_size(q)
        q += n if n > 0 else 1
    return "\n".join(lines)


def main():
    ida_auto.auto_wait()
    log("procname %s" % ida_ida.inf_get_procname())
    log("min %#x max %#x" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
    log("segments:")
    for s in range(ida_segment.get_segm_qty()):
        seg = ida_segment.getnseg(s)
        log("  %-12s %08X-%08X" % (ida_segment.get_segm_name(seg), seg.start_ea, seg.end_ea))
    log("functions before %d" % len(list(idautils.Functions())))

    # 1. make the seed instructions exist, exactly at the known starts
    for ea, why in SEEDS:
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 16)
        n = ida_ua.create_insn(ea)
        log("seed %08X create_insn=%d  %s" % (ea, n, why))
    ida_auto.auto_wait()

    # 2. linear sweep
    for a, b in SWEEP:
        m = sweep(a, b)
        log("sweep %08X-%08X made %d insns" % (a, b, m))
        ida_auto.auto_wait()
    for a, b in SWEEP:
        m = add_call_targets(a, b)
        log("call-target funcs %08X-%08X: %d" % (a, b, m))
        ida_auto.auto_wait()
    # second sweep: the first pass can leave gaps behind data islands
    for a, b in SWEEP:
        m = sweep(a, b)
        log("sweep2 %08X-%08X made %d insns" % (a, b, m))
        ida_auto.auto_wait()
    for ea, why in SEEDS:
        if ida_funcs.get_func(ea) is None:
            log("no func at seed %08X" % ea)

    funcs = sorted(idautils.Functions())
    log("functions after %d" % len(funcs))

    rows = ["ea\tend\tsize\tname"]
    for f in funcs:
        fn = ida_funcs.get_func(f)
        rows.append("%08X\t%08X\t%d\t%s" % (fn.start_ea, fn.end_ea,
                                            fn.end_ea - fn.start_ea,
                                            ida_funcs.get_func_name(f)))
    w("functions_menu.tsv", "\n".join(rows) + "\n")

    # 3. disassembly windows at the seeds
    parts = []
    for ea, why in SEEDS:
        fn = ida_funcs.get_func(ea)
        head = "### %08X  %s" % (ea, why)
        if fn:
            head += "\n### in %s  %08X-%08X" % (ida_funcs.get_func_name(fn.start_ea),
                                                fn.start_ea, fn.end_ea)
        parts.append(head + "\n" + dis(ea) + "\n")
    w("walker_disasm.txt", "\n".join(parts))

    # 4. whole functions containing the seeds
    parts = []
    seen = set()
    for ea, why in SEEDS:
        fn = ida_funcs.get_func(ea)
        if fn is None or fn.start_ea in seen:
            continue
        seen.add(fn.start_ea)
        parts.append("###### %s  %08X-%08X  (seed %08X: %s)" %
                     (ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea, ea, why))
        q = fn.start_ea
        while q < fn.end_ea:
            raw = " ".join("%02X" % ida_bytes.get_byte(q + i)
                           for i in range(min(8, max(1, ida_bytes.get_item_size(q) or 1))))
            parts.append("  %08X  %-24s %s" % (q, raw, idc.generate_disasm_line(q, 0) or "?"))
            n = ida_bytes.get_item_size(q)
            q += n if n > 0 else 1
        parts.append("")
    w("walker_funcs.txt", "\n".join(parts) + "\n")

    # 5. xrefs to the interesting data addresses
    targets = [0xFFED74E8, 0xFFED74F0, 0xFFC3DD55, 0xFFC3DF4D, 0xFFC3DF35,
               0xFFED75A8, 0xFFED75B8, 0xFFED75FC, 0xFFC3E709, 0xFFC3E759,
               0xFFC3E5C9, 0xFFC3E76D]
    rows = ["target\tfrom\ttype\tfunc\tdisasm"]
    for t in targets:
        got = False
        for frm in idautils.XrefsTo(t, 0):
            got = True
            fn = ida_funcs.get_func(frm.frm)
            rows.append("%08X\t%08X\t%d\t%s\t%s" % (
                t, frm.frm, frm.type,
                ida_funcs.get_func_name(fn.start_ea) if fn else "-",
                idc.generate_disasm_line(frm.frm, 0) or "?"))
        if not got:
            rows.append("%08X\t-\t-\t-\tno xref" % t)
    w("menu_xrefs.tsv", "\n".join(rows) + "\n")

    idc.save_database("")


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
w("job1_log.txt", "\n".join(LOG) + "\n")
idc.qexit(0)

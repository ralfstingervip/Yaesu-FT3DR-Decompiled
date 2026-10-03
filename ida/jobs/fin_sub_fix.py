r"""Lane F4 fixup: emit a clean annotated listing for the TRUE Routine-A function
sub_FFF40B7D (the lane-4 start FFF40C3E was mid-instruction), and dump the few
remaining helpers (FFEF4142, FFEF42A7 for A; FFEF95BD for B). Reopen-only."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/sub-big2")
FLASH_LO = 0xFFC00000
PERIPH_LO, PERIPH_HI = 0x00080000, 0x00100000


def cls(a):
    if a >= FLASH_LO: return "flash"
    if PERIPH_LO <= a < PERIPH_HI: return "periph"
    return "ram"


def esc(t): return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def op_detail(insn, ida_ua):
    out = []
    for i in range(8):
        op = insn.ops[i]; t = op.type
        if t == ida_ua.o_void: break
        if t == ida_ua.o_reg: out.append("R%d" % op.reg)
        elif t == ida_ua.o_imm: out.append("#0x%X" % (op.value & 0xFFFFFFFF))
        elif t == ida_ua.o_displ: out.append("displ(R%d,+0x%X)" % (op.reg, op.value & 0xFFFFFFFF))
        elif t == ida_ua.o_phrase: out.append("phrase(R%d)" % op.reg)
        elif t == ida_ua.o_mem: out.append("mem=0x%X" % (op.addr & 0xFFFFFFFF))
        elif t == ida_ua.o_near: out.append("near=0x%X" % (op.addr & 0xFFFFFFFF))
        else: out.append("t%d(a=0x%X,v=0x%X)" % (t, op.addr & 0xFFFFFFFF, op.value & 0xFFFFFFFF))
    return " | ".join(out)


def dump(h, start, end, modules, title):
    ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils = modules
    h.write("===== %08X..%08X  %s =====\n" % (start, end, title))
    callers = []
    xr = ida_xref.xrefblk_t(); ok = xr.first_to(start, ida_xref.XREF_ALL)
    while ok:
        if xr.iscode and xr.type in (ida_xref.fl_CF, ida_xref.fl_CN, ida_xref.fl_JF, ida_xref.fl_JN):
            callers.append(xr.frm)
        ok = xr.next_to()
    h.write("  callers(%d): %s\n" % (len(callers), ", ".join("%08X" % c for c in callers[:24])))
    ext_callees = set(); back = []
    a = start; insn = ida_ua.insn_t()
    while a != idc.BADADDR and a < end:
        size = idc.get_item_size(a)
        raw = (ida_bytes.get_bytes(a, min(size, 10)) or b"").hex()
        line = esc(idc.generate_disasm_line(a, 0))
        ann = []
        if ida_ua.decode_insn(insn, a) > 0:
            od = op_detail(insn, ida_ua)
            if od: ann.append("ops:[%s]" % od)
        for r in idautils.CodeRefsFrom(a, 0):
            if start <= r < end:
                if r <= a: ann.append("[BACK-EDGE %08X]" % r); back.append((a, r))
            else:
                ext_callees.add(r); ann.append("->call %08X %s" % (r, idc.get_func_name(r) or ""))
        for r in idautils.DataRefsFrom(a):
            extra = ("=" + (ida_bytes.get_bytes(r, 8) or b"").hex()) if cls(r) == "flash" else ""
            ann.append("->data %08X(%s)%s" % (r, cls(r), extra))
        h.write("  %08X  %-18s %-38s %s\n" % (a, raw, line, "  ".join(ann)))
        nxt = idc.next_head(a, end); a = nxt if nxt > a else a + 1
    h.write("  external callees(%d): %s\n" % (len(ext_callees), ", ".join("%08X" % c for c in sorted(ext_callees))))
    h.write("  back-edges(%d): %s\n\n" % (len(back), ", ".join("%08X->%08X" % (x, y) for x, y in back)))


def main():
    import ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils, ida_auto
    ida_auto.auto_wait()
    M = (ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils)
    with open(os.path.join(OUT, "fff40c3e.lst"), "w", encoding="utf-8", newline="\n") as h:
        h.write("# Lane F4 Routine A: TRUE function sub_FFF40B7D (0xFFF40B7D-0xFFF410EB)\n")
        h.write("# NOTE: lane-4 registered start 0xFFF40C3E is mid-instruction (tail of\n")
        h.write("#       C5FE6E6E @ FFF40C3C = mov.b 6Eh[r15],6Eh[r14]); the real entry is\n")
        h.write("#       FFF40B7D. IDA over-split it into sub_FFF40B7D + sub_FFF40C3E.\n\n")
        dump(h, 0xFFF40B7D, 0xFFF410ED, M, "sub_FFF40B7D  frame->shadow reconcile + mark dirty")
    with open(os.path.join(OUT, "helpers_extra.txt"), "w", encoding="utf-8", newline="\n") as h:
        for (s, label) in ((0xFFEF4142, "Routine-A helper FFEF4142"),
                           (0xFFEF95BD, "Routine-B helper FFEF95BD")):
            f = ida_funcs.get_func(s)
            if f: dump(h, f.start_ea, min(f.end_ea, f.start_ea + 0x400), M, label + " (capped)")
            else: h.write("===== %08X %s: no func =====\n\n" % (s, label))
        # FFEF42A7 is a mid-function block-copy entry; dump a window
        dump(h, 0xFFEF42A7, 0xFFEF4320, M, "Routine-A helper loc_FFEF42A7 block-copy (window)")
    with open(os.path.join(OUT, "fix_status.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("fix ok\n")


if True:
    os.makedirs(OUT, exist_ok=True)
    try: main()
    except Exception:
        with open(os.path.join(OUT, "fix_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)

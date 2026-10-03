r"""Lane F7 - hand-disassembly support for the next tier of large SUB-window
functions (NOT the three biggest, which other lanes own):

    sub_FFF4B084  (0xFFF4B084-0xFFF4C226, 4514 B)  refs "nmXNr", calls 13
    sub_FFEF2724  (0xFFEF2724-0xFFEF34B1, 3469 B)  [low] leaf/util, widely called
    sub_FFF1F752  (0xFFF1F752-0xFFF20186, 2612 B)  calls 24, 20 callers
    sub_FFF162CD  (0xFFF162CD-0xFFF16CAD, 2528 B)  calls 23, wrapper/dispatch
    sub_FFF1898D  (0xFFF1898D-0xFFF192BE, 2353 B)  calls 9,  wrapper/dispatch

Reopen-only against a private copy of SUB_WINDOW. For each target: annotated
linear disassembly with raw bytes, a light RX register-pointer tracker that
resolves  mov.l #imm,Rn ; [Rn]/disp[Rn]  effective addresses (flash/periph/ram),
callers, callees, data refs, switch info, and loop back-edges. Then a capped
dump of every direct callee. Honors the RX trap: o_displ keeps its byte
displacement in op.value, not op.addr; peripheral/RAM pointers use mov.l #imm:24.

    python "ida/run_job.py" --script ida\jobs\fin_sub_t2.py \
        --db FIN_SUB_T2 --copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64
    python "ida/run_job.py" --script ida\jobs\fin_sub_t2.py \
        --db FIN_SUB_T2 --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

OUT = str(_REPO / "ida/out/sub-tier2")

TARGETS = [
    (0xFFF4B084, 0xFFF4C226, "fff4b084"),
    (0xFFEF2724, 0xFFEF34B1, "ffef2724"),
    (0xFFF1F752, 0xFFF20186, "fff1f752"),
    (0xFFF162CD, 0xFFF16CAD, "fff162cd"),
    (0xFFF1898D, 0xFFF192BE, "fff1898d"),
]
TARGET_RANGES = [(s, e) for (s, e, _n) in TARGETS]

FLASH_LO = 0xFFC00000
PERIPH_LO, PERIPH_HI = 0x00080000, 0x00100000
RAM_LO = 0x00000000           # RX64M on-chip RAM base
RAM_HI = 0x00080000
# caller-saved per CC-RX (lane 8): R1-R5, R14, R15 clobbered by a call; R6-R13 kept
CALL_CLOBBER = (1, 2, 3, 4, 5, 14, 15)


def classify_addr(a):
    a &= 0xFFFFFFFF
    if a >= FLASH_LO:
        return "flash"
    if PERIPH_LO <= a < PERIPH_HI:
        return "periph"
    if 0x00008000 <= a < RAM_HI:
        return "ram"
    if a < 0x00008000:
        return "lowram/const"
    return "?"


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def op_detail(insn, ida_ua):
    out = []
    for i in range(8):
        op = insn.ops[i]
        t = op.type
        if t == ida_ua.o_void:
            break
        if t == ida_ua.o_reg:
            out.append("R%d" % op.reg)
        elif t == ida_ua.o_imm:
            out.append("#0x%X" % (op.value & 0xFFFFFFFF))
        elif t == ida_ua.o_displ:
            out.append("displ(R%d,+0x%X)" % (op.reg, op.value & 0xFFFFFFFF))
        elif t == ida_ua.o_phrase:
            out.append("phrase(R%d)" % op.reg)
        elif t == ida_ua.o_mem:
            out.append("mem=0x%X" % (op.addr & 0xFFFFFFFF))
        elif t == ida_ua.o_near:
            out.append("near=0x%X" % (op.addr & 0xFFFFFFFF))
        elif t == ida_ua.o_far:
            out.append("far=0x%X" % (op.addr & 0xFFFFFFFF))
        else:
            out.append("t%d(a=0x%X,v=0x%X)" % (t, op.addr & 0xFFFFFFFF, op.value & 0xFFFFFFFF))
    return " | ".join(out)


def track(insn, ida_ua, idc, regval):
    """Light RX register-pointer tracker. Returns (ea_annotations, hits).
    hits = set of (eff_addr, class). Updates regval in place."""
    ann = []
    hits = set()
    mnem = (idc.print_insn_mnem(insn.ea) or "").lower()
    ops = insn.ops

    # 1) resolve memory operands from tracked base regs (do this BEFORE updating)
    for i in range(8):
        op = ops[i]
        if op.type == ida_ua.o_void:
            break
        if op.type in (ida_ua.o_displ, ida_ua.o_phrase):
            base = op.reg
            if base in regval:
                disp = (op.value & 0xFFFFFFFF) if op.type == ida_ua.o_displ else 0
                ea = (regval[base] + disp) & 0xFFFFFFFF
                cls = classify_addr(ea)
                ann.append("~EA[R%d+0x%X]=%08X(%s)" % (base, disp, ea, cls))
                hits.add((ea, cls))

    # 2) update tracker
    if mnem.startswith("bsr") or mnem.startswith("jsr"):
        for r in CALL_CLOBBER:
            regval.pop(r, None)
        return ann, hits

    # pointer load:  mov[.l] #imm, Rn
    if (mnem in ("mov.l", "mov")
            and ops[0].type == ida_ua.o_imm
            and ops[1].type == ida_ua.o_reg
            and ops[2].type == ida_ua.o_void):
        regval[ops[1].reg] = ops[0].value & 0xFFFFFFFF
        return ann, hits

    # otherwise conservatively invalidate written registers
    last = None
    for i in range(8):
        op = ops[i]
        if op.type == ida_ua.o_void:
            break
        last = op
        if op.type == ida_ua.o_phrase:   # possible auto inc/dec
            regval.pop(op.reg, None)
    if last is not None and last.type == ida_ua.o_reg:
        regval.pop(last.reg, None)
    return ann, hits


def func_callers(start, ida_xref):
    callers = []
    xr = ida_xref.xrefblk_t()
    ok = xr.first_to(start, ida_xref.XREF_ALL)
    while ok:
        if xr.iscode and xr.type in (ida_xref.fl_CF, ida_xref.fl_CN, ida_xref.fl_JF, ida_xref.fl_JN):
            callers.append((xr.frm, xr.type))
        ok = xr.next_to()
    return callers


def in_targets(a):
    for s, e in TARGET_RANGES:
        if s <= a < e:
            return True
    return False


def dump_function(h, start, modules, cap=None, label="", full=False):
    ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils = modules
    f = ida_funcs.get_func(start)
    h.write("===== %08X  %s  %s =====\n" % (start, idc.get_func_name(start) or "", label))
    if f is None:
        h.write("  (no function registered here)\n\n")
        return set(), set(), set()
    h.write("  start=%08X end=%08X size=%d (0x%X)\n" % (
        f.start_ea, f.end_ea, f.end_ea - f.start_ea, f.end_ea - f.start_ea))

    callers = func_callers(start, ida_xref)
    h.write("  callers(%d): %s\n" % (len(callers),
            ", ".join("%08X" % c for c, _ in callers)))

    end = f.end_ea
    if cap is not None:
        end = min(end, f.start_ea + cap)

    callees = set()
    data_refs = set()
    ea_hits = set()
    back_edges = []
    regval = {}

    a = f.start_ea
    insn = ida_ua.insn_t()
    while a != idc.BADADDR and a < end:
        size = idc.get_item_size(a)
        raw = (ida_bytes.get_bytes(a, min(size, 12)) or b"").hex()
        line = esc(idc.generate_disasm_line(a, 0))
        ann = []

        ln = ida_ua.decode_insn(insn, a)
        if ln > 0:
            od = op_detail(insn, ida_ua)
            if od:
                ann.append("[%s]" % od)
            ea_ann, hits = track(insn, ida_ua, idc, regval)
            ann.extend(ea_ann)
            for hh in hits:
                ea_hits.add(hh)
            # flag immediates that look like addresses
            for i in range(8):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                if op.type == ida_ua.o_imm:
                    v = op.value & 0xFFFFFFFF
                    cls = classify_addr(v)
                    if cls in ("flash", "periph", "ram"):
                        ann.append("imm->%s" % cls)
        else:
            regval.clear()

        # code refs (call/jump)
        for r in idautils.CodeRefsFrom(a, 0):
            if not in_targets(r) or (f.start_ea <= r < f.end_ea):
                pass
            callees.add(r)
            nm = idc.get_func_name(r) or ""
            ann.append("->code %08X %s" % (r, nm))
            if f.start_ea <= r < f.end_ea and r <= a:
                back_edges.append((a, r))
                ann.append("[BACK-EDGE]")
        # data refs IDA already knows
        for r in idautils.DataRefsFrom(a):
            data_refs.add(r)
            cls = classify_addr(r)
            extra = ""
            if cls == "flash":
                b = ida_bytes.get_bytes(r, 8) or b""
                extra = "=" + b.hex()
            ann.append("->data %08X(%s)%s" % (r, cls, extra))

        # switch info
        try:
            swi = idc.get_switch_info is not None
        except Exception:
            swi = False

        h.write("  %08X  %-24s %-44s %s\n" % (a, raw, line, "  ".join(ann)))
        nxt = idc.next_head(a, end)
        a = nxt if nxt > a else a + 1

    h.write("  -- back-edges/loops (%d): %s\n" % (
        len(back_edges), ", ".join("%08X->%08X" % (x, y) for x, y in back_edges)))
    # separate callees into in-func (local) and external
    ext_callees = sorted(c for c in callees if not (f.start_ea <= c < f.end_ea))
    h.write("  -- external call/jump targets (%d): %s\n" % (
        len(ext_callees), ", ".join("%08X" % c for c in ext_callees)))
    h.write("\n")
    return callees, data_refs, ea_hits


def summarize(h, name, callees, data_refs, ea_hits, idc, ida_funcs):
    ext = sorted(c for c in callees if not in_targets(c))
    h.write("### %s external callees (%d)\n" % (name, len(ext)))
    for c in ext:
        fn = ida_funcs.get_func(c)
        tag = "" if fn else " (not-a-func)"
        h.write("  %08X  %s%s\n" % (c, idc.get_func_name(c) or "", tag))
    def bycls(src, cls):
        return sorted(set(a for (a, c) in src if c == cls))
    # merge ea_hits and data_refs
    allhits = set(ea_hits) | set((d, classify_addr(d)) for d in data_refs)
    for cls in ("ram", "periph", "flash", "lowram/const"):
        xs = bycls(allhits, cls)
        h.write("### %s %s refs (%d): %s\n" % (name, cls, len(xs),
                ", ".join("%08X" % x for x in xs)))
    h.write("\n")


def dump_hex(h, base, n, ida_bytes):
    h.write("----- hex @%08X (%d bytes) -----\n" % (base, n))
    for off in range(0, n, 16):
        b = ida_bytes.get_bytes(base + off, 16) or b""
        hexs = " ".join("%02X" % x for x in b)
        asci = "".join(chr(x) if 32 <= x < 127 else "." for x in b)
        h.write("  %08X  %-47s  |%s|\n" % (base + off, hexs, asci))
    h.write("\n")


def main():
    import ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils, ida_auto
    ida_auto.auto_wait()
    modules = (ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils)

    all_ext = set()
    flash_refs = set()
    for (start, end, nm) in TARGETS:
        with open(os.path.join(OUT, nm + ".lst"), "w", encoding="utf-8", newline="\n") as h:
            h.write("# Lane F7 target: sub_%08X  [%08X, %08X)\n\n" % (start, start, end))
            c, d, ea = dump_function(h, start, modules, label="TARGET", full=True)
            summarize(h, "%08X" % start, c, d, ea, idc, ida_funcs)
            for x in c:
                if not in_targets(x):
                    all_ext.add(x)
            for (a, cls) in ea:
                if cls == "flash":
                    flash_refs.add(a)
            for dd in d:
                if classify_addr(dd) == "flash":
                    flash_refs.add(dd)

    # dump each external callee (registered function), capped, one level
    with open(os.path.join(OUT, "callees.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("# Direct external callees of the five targets (capped 0x400)\n\n")
        for c in sorted(all_ext):
            if ida_funcs.get_func(c):
                dump_function(h, c, modules, cap=0x400, label="callee")
            else:
                h.write("===== %08X  (not a registered function) =====\n\n" % c)

    # flash tables / string sites referenced
    with open(os.path.join(OUT, "tables.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("# Flash data referenced by the targets (16 bytes before, 0x60 window)\n\n")
        for a in sorted(flash_refs):
            dump_hex(h, (a - 16) & 0xFFFFFFF0, 0x80, ida_bytes)
        # the "nmXNr" string reported for FFF4B084 - search the body region
        h.write("# scan FFF4B084..FFF4C226 for printable >=4 runs\n")
        base = 0xFFF4B084
        blob = ida_bytes.get_bytes(base, 0xFFF4C226 - base) or b""
        run = b""
        rs = base
        for i, bb in enumerate(blob):
            if 32 <= bb < 127:
                if not run:
                    rs = base + i
                run += bytes([bb])
            else:
                if len(run) >= 4:
                    h.write("  %08X  %r\n" % (rs, run.decode("latin1")))
                run = b""
        if len(run) >= 4:
            h.write("  %08X  %r\n" % (rs, run.decode("latin1")))
        h.write("\n")

    with open(os.path.join(OUT, "job_status.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("fin_sub_t2 ok; targets=%d ext_callees=%d flash_refs=%d\n" % (
            len(TARGETS), len(all_ext), len(flash_refs)))


if True:
    os.makedirs(OUT, exist_ok=True)
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "fin_sub_t2_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc
    _idc.qexit(0)

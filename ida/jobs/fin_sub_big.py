r"""Lane F4 — hand-disassembly support for the two next-largest un-decompiled SUB
routines:
    A = sub_FFF40C3E (0xFFF40C3E-0xFFF410ED, body-validated, no direct xref)
    B = sub_FFEF6C42 (0xFFEF6C42-0xFFEF9558, single largest SUB-window function)

Reopen-only against a private copy of SUB_WINDOW. Produces annotated listings,
a callee census with disassembly, a referenced-table dump, and a control-flow /
loop map, so the routines can be hand-reconstructed into C.

    python "ida/run_job.py" --script ida\jobs\fin_sub_big.py \
        --db FIN_SUB_BIG --copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64
    python "ida/run_job.py" --script ida\jobs\fin_sub_big.py \
        --db FIN_SUB_BIG --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

OUT = str(_REPO / "ida/out/sub-big2")

TARGETS = [0xFFF40C3E, 0xFFEF6C42]
FLASH_TABLES = [0xFFC3E94E, 0xFFC3E8D4, 0xFFC3DF4D]  # table + label-table end + label-table start
FLASH_LO = 0xFFC00000
PERIPH_LO, PERIPH_HI = 0x00080000, 0x00100000


def classify_addr(a):
    if a >= FLASH_LO:
        return "flash"
    if PERIPH_LO <= a < PERIPH_HI:
        return "periph"
    if a < PERIPH_LO:
        return "ram"
    return "?"


def op_detail(insn, ida_ua):
    """Decode operands, honoring the RX trap: o_displ keeps its byte-scaled
    displacement in op.value, NOT op.addr."""
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
            out.append("displ(R%d,+0x%X)[addr=0x%X]" % (op.reg, op.value & 0xFFFFFFFF, op.addr & 0xFFFFFFFF))
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


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def dump_function(h, start, modules, cap=None, label=""):
    ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils = modules
    f = ida_funcs.get_func(start)
    hdr_end = f.end_ea if f else start
    h.write("===== %08X  %s  %s =====\n" % (start, idc.get_func_name(start) or "", label))
    if f is None:
        h.write("  (no function registered at this address)\n")
    else:
        h.write("  start=%08X end=%08X size=%d (0x%X)\n" % (
            f.start_ea, f.end_ea, f.end_ea - f.start_ea, f.end_ea - f.start_ea))

    # callers (xrefs to start, code call/jump)
    callers = []
    xr = ida_xref.xrefblk_t()
    ok = xr.first_to(start, ida_xref.XREF_ALL)
    while ok:
        if xr.iscode and xr.type in (ida_xref.fl_CF, ida_xref.fl_CN, ida_xref.fl_JF, ida_xref.fl_JN):
            callers.append((xr.frm, xr.type))
        ok = xr.next_to()
    h.write("  callers(%d): %s\n" % (len(callers),
            ", ".join("%08X" % c for c, _ in callers[:24])))

    if f is None:
        h.write("\n")
        return set(), set(), set()

    end = f.end_ea
    if cap is not None:
        end = min(end, f.start_ea + cap)

    callees = set()
    data_refs = set()
    back_edges = []     # (from, to) with to<=from inside fn  -> loop back-edge
    fwd_branches = []
    all_branch_targets = set()

    a = f.start_ea
    insn = ida_ua.insn_t()
    while a != idc.BADADDR and a < end:
        size = idc.get_item_size(a)
        raw = (ida_bytes.get_bytes(a, min(size, 10)) or b"").hex()
        mnem = idc.print_insn_mnem(a) or ""
        line = esc(idc.generate_disasm_line(a, 0))

        ann = []
        ln = ida_ua.decode_insn(insn, a)
        if ln > 0:
            od = op_detail(insn, ida_ua)
            if od:
                ann.append("ops:[%s]" % od)

        # code refs (call/jump, no flow)
        for r in idautils.CodeRefsFrom(a, 0):
            callees.add(r)
            ann.append("->code %08X %s" % (r, idc.get_func_name(r) or ""))
            # branch/loop analysis (within function)
            if f.start_ea <= r < f.end_ea:
                all_branch_targets.add(r)
                if r <= a:
                    back_edges.append((a, r))
                    ann.append("[BACK-EDGE/loop]")
                else:
                    fwd_branches.append((a, r))
        # data refs
        for r in idautils.DataRefsFrom(a):
            data_refs.add(r)
            cls = classify_addr(r)
            extra = ""
            if cls == "flash":
                b = ida_bytes.get_bytes(r, 8) or b""
                extra = "=" + b.hex()
            ann.append("->data %08X(%s)%s" % (r, cls, extra))

        h.write("  %08X  %-20s %-40s %s\n" % (a, raw, line, "  ".join(ann)))
        a = idc.next_head(a, end)

    h.write("  -- loop back-edges (%d): %s\n" % (
        len(back_edges), ", ".join("%08X->%08X" % (x, y) for x, y in back_edges)))
    h.write("\n")
    return callees, data_refs, set(t for t, _ in [])  # callees,data only used


def summarize_refs(h, name, callees, data_refs, idc):
    h.write("### %s callee functions (%d)\n" % (name, len(callees)))
    for c in sorted(callees):
        h.write("  %08X  %s\n" % (c, idc.get_func_name(c) or ""))
    ram = sorted(d for d in data_refs if classify_addr(d) == "ram")
    periph = sorted(d for d in data_refs if classify_addr(d) == "periph")
    flash = sorted(d for d in data_refs if classify_addr(d) == "flash")
    h.write("### %s RAM data refs (%d): %s\n" % (name, len(ram), ", ".join("%08X" % x for x in ram)))
    h.write("### %s PERIPH data refs (%d): %s\n" % (name, len(periph), ", ".join("%08X" % x for x in periph)))
    h.write("### %s FLASH data refs (%d): %s\n" % (name, len(flash), ", ".join("%08X" % x for x in flash)))
    h.write("\n")


def dump_flash_table(h, base, n, ida_bytes):
    h.write("===== flash table @%08X (%d bytes) =====\n" % (base, n))
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

    all_callees = {}
    # Target A
    with open(os.path.join(OUT, "fff40c3e.lst"), "w", encoding="utf-8", newline="\n") as h:
        h.write("# Lane F4 Routine A: sub_FFF40C3E\n\n")
        c, d, _ = dump_function(h, 0xFFF40C3E, modules, label="ROUTINE A")
        summarize_refs(h, "FFF40C3E", c, d, idc)
        all_callees[0xFFF40C3E] = c

    # Target B
    with open(os.path.join(OUT, "ffef6c42.lst"), "w", encoding="utf-8", newline="\n") as h:
        h.write("# Lane F4 Routine B: sub_FFEF6C42\n\n")
        c, d, _ = dump_function(h, 0xFFEF6C42, modules, label="ROUTINE B")
        summarize_refs(h, "FFEF6C42", c, d, idc)
        all_callees[0xFFEF6C42] = c

    # Callees of both (only those registered as functions; cap each)
    want = set()
    for cs in all_callees.values():
        for c in cs:
            if ida_funcs.get_func(c) and not (0xFFF40C3E <= c < 0xFFF410ED) and not (0xFFEF6C42 <= c < 0xFFEF9558):
                want.add(c)
    with open(os.path.join(OUT, "callees.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("# Direct callees of routines A and B (capped 0x600)\n\n")
        for c in sorted(want):
            dump_function(h, c, modules, cap=0x600, label="callee")

    # Flash tables + label-table context
    with open(os.path.join(OUT, "tables.txt"), "w", encoding="utf-8", newline="\n") as h:
        dump_flash_table(h, 0xFFC3E8C0, 0x200, ida_bytes)   # straddles label-end 0xFFC3E8D4 + table 0xFFC3E94E
        dump_flash_table(h, 0xFFC3E94E, 0x180, ida_bytes)   # the table FFF40C3E reads
        dump_flash_table(h, 0xFFC3DF35, 0x40, ida_bytes)    # title-length table (context, doc 23)

    with open(os.path.join(OUT, "job_status.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("fin_sub_big ok; targets=%s callees=%d\n" % (
            ",".join("%08X" % t for t in TARGETS), len(want)))


if True:
    os.makedirs(OUT, exist_ok=True)
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "fin_sub_big_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc
    _idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane G2 SUB cross-check (G2_SUB, seeded from ida\db\radio\SUB.i64, 455 funcs).
Enumerate, per opcode family, which low-byte opcodes reach a distinct handler vs
the default (unused). RX64M, little-endian, base 0xFFC00000. The receive
dispatcher reads opcode hi at 0x8E46, lo at 0x8E47, and switch-dispatches.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_nalt, idc, idautils

ROOT = str(_REPO)
OUTDIR = os.path.join(ROOT, "ida", "out", "main-banks")
TB = os.path.join(OUTDIR, "g2_sub_tb.txt")

# family -> (handler ea, opcode high byte)
FAM = [
    (0xFFEDF1D8, None, "top-level family dispatcher (hi byte, 0xF0..0xFF)"),
    (0xFFEDF269, 0xF0, "F0 sub-dispatcher"),
    (0xFFEDF2E0, 0xF1, "F1 handler"),
    (0xFFEDF36A, 0xF2, "F2 handler"),
    (0xFFEDF3A7, 0xF3, "F3/F4 shared handler"),
    (0xFFEDF447, 0xF5, "F5 handler"),
    (0xFFEDF4B8, 0xF6, "F6 handler"),
    (0xFFEDF53E, 0xF7, "F7 handler"),
    (0xFFEDF56F, 0xF8, "F8 handler"),
    (0xFFEDF61B, 0xFD, "FD handler"),
    (0xFFEDF645, 0xFE, "FE/FF shared handler"),
]


def ensure_func(ea):
    if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
        idc.create_insn(ea)
        ida_auto.auto_wait()
    if ida_funcs.get_func(ea) is None:
        ida_funcs.add_func(ea)
        ida_auto.auto_wait()
    return ida_funcs.get_func(ea)


def find_switch(f):
    """Return (switch_ea, switch_info_t) for the first switch in f, else (None,None)."""
    ea = f.start_ea
    guard = 0
    while ea < f.end_ea and guard < 1000:
        guard += 1
        si = ida_nalt.switch_info_t()
        if ida_nalt.get_switch_info(si, ea):
            return ea, si
        nxt = ida_bytes.next_head(ea, f.end_ea)
        ea = nxt if nxt > ea else ea + 2
    return None, None


def read_jtable(si):
    jea = si.jumps
    n = si.get_jtable_size()
    esz = si.get_jtable_element_size()
    base = si.elbase if (si.flags & ida_nalt.SWI_ELBASE) else 0
    sub = bool(si.flags2 & 1) if hasattr(si, "flags2") else False
    out = []
    for i in range(n):
        if esz == 4:
            v = ida_bytes.get_dword(jea + 4 * i)
        elif esz == 2:
            v = ida_bytes.get_word(jea + 2 * i)
        else:
            v = ida_bytes.get_byte(jea + i)
        if si.flags & ida_nalt.SWI_SIGNED and esz < 4:
            bits = esz * 8
            if v & (1 << (bits - 1)):
                v -= (1 << bits)
        if si.flags & ida_nalt.SWI_SUBTRACT:
            t = (base - v) & 0xFFFFFFFF
        else:
            t = (base + v) & 0xFFFFFFFF
        out.append(t)
    return out


def main():
    ida_auto.auto_wait()
    dfh = open(os.path.join(OUTDIR, "sub_dispatch.txt"), "w", encoding="utf-8", newline="\n")
    tfh = open(os.path.join(OUTDIR, "sub_handlers.tsv"), "w", encoding="utf-8", newline="\n")
    tfh.write("family\thandler\tswitch_ea\tncases\tlowcase\thandled_opcodes\tunused_cases\tdefault_addr\n")
    for ea, hi, note in FAM:
        f = ensure_func(ea)
        if not f:
            dfh.write("\n==== %08X %s [NO FUNC]\n" % (ea, note))
            continue
        sea, si = find_switch(f)
        dfh.write("\n==== %08X-%08X %s ====\n" % (f.start_ea, f.end_ea, note))
        if si is None:
            dfh.write("  (no switch found)\n")
            tfh.write("%s\t%08X\t-\t-\t-\t-\t-\t-\n" % (("%02X" % hi) if hi else "TOP", ea))
            continue
        tgts = read_jtable(si)
        defj = si.defjump
        low = si.lowcase
        ncases = si.get_jtable_size()
        handled = []
        unused = []
        for i, t in enumerate(tgts):
            caseval = low + i
            if t == defj:
                unused.append(caseval)
            else:
                handled.append(caseval)
        dfh.write("  switch @%08X ncases=%d lowcase=%d defjump=%08X jtable=%08X elsz=%d\n" % (
            sea, ncases, low, defj, si.jumps, si.get_jtable_element_size()))
        for i, t in enumerate(tgts):
            mark = " (default/unused)" if t == defj else ""
            dfh.write("    case %2d (0x%02X): %08X%s\n" % (low + i, low + i, t, mark))
        if hi is not None:
            handled_ops = ",".join("%02X%02X" % (hi, c) for c in handled)
            unused_ops = ",".join("%02X%02X" % (hi, c) for c in unused)
        else:
            # top-level: case value is (opcode_hi - 0xF0)
            handled_ops = ",".join("%02Xxx" % (0xF0 + c) for c in handled)
            unused_ops = ",".join("%02Xxx" % (0xF0 + c) for c in unused)
        tfh.write("%s\t%08X\t%08X\t%d\t%d\t%s\t%s\t%08X\n" % (
            ("%02X" % hi) if hi is not None else "TOP",
            ea, sea, ncases, low, handled_ops, unused_ops, defj))
    dfh.close()
    tfh.close()
    with open(os.path.join(OUTDIR, "g2_sub_log.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("done; functions=%d\n" % len(list(idautils.Functions())))


try:
    main()
except Exception:
    with open(TB, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

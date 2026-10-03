r"""DSP-AMBE job 3: SUB (RX64M) side of the DSP question.

Seeded from ida\db\radio\SUB.i64 with --copy-from into DSP_HUNT_SUB.

  1. force-decodes and dumps the version-screen formatter window and the
     "---DSP WRITE MODE----" window
  2. finds every reference to the DSP-related strings
  3. linear-sweeps the whole 4 MB image for RX peripheral operands in the
     SCI / RSPI / SSI windows so the bus census does not depend on function
     recovery
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_lines
import ida_name
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "dsp", "sub")

WINDOWS = [
    (0xFFF00C00, 0xFFF01200, "ver_screen"),
    (0xFFF0DC00, 0xFFF0E200, "dsp_write_mode"),
]
DUMP = list(WINDOWS)

STRINGS = {
    0xFFF487EC: "Main Ver.  :  .",
    0xFFF48800: "Sub  Ver.  :  .",
    0xFFF48814: "DSP  Ver.  :  .",
    0xFFF4ACF8: "---DSP WRITE MODE----",
    0xFFF4AD0E: "Push DISP Key!",
    0xFFF4AD1D: "Loading...",
    0xFFF4AD28: "Complete",
    0xFFF4AB44: "FIRM ERROR",
    0xFFF4AB4F: "Searching",
    0xFFF4AB59: "No Device",
}

# RX64M peripheral windows relevant to a chip-to-chip voice link.
WINS = [
    (0x00088000, 0x00088100, "CMT"),
    (0x00089000, 0x00089100, "S12AD"),
    (0x0008A000, 0x0008A200, "SCI0_12"),   # SCI0..SCI12, 0x20 stride
    (0x0008B300, 0x0008B400, "SCI12"),
    (0x0008C000, 0x0008C200, "PORT"),
    (0x000D0100, 0x000D0200, "RSPI"),
    (0x0008A500, 0x0008A600, "RIIC"),
    (0x0008C100, 0x0008C180, "SSI"),
    (0x000A0000, 0x000A0400, "USB0"),
    (0x00082000, 0x00082800, "DMAC_DTC"),
    (0x00087000, 0x00087400, "ICU"),
    (0x00080000, 0x00080400, "SYSTEM"),
    (0x000D0000, 0x000D0100, "SSI_RSPI_area"),
    (0x0008B000, 0x0008B100, "misc8B0"),
]


def winof(v):
    for lo, hi, nm in WINS:
        if lo <= v < hi:
            return nm
    if 0x00080000 <= v < 0x00100000:
        return "periph_other"
    return None


def w(path, rows):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")


def esc(t):
    return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")


def force_code(lo, hi):
    ea, made = lo, 0
    while ea < hi:
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            if idc.create_insn(ea) > 0:
                made += 1
                ea += max(1, idc.get_item_size(ea))
                continue
            ea += 1
            continue
        ea += max(1, idc.get_item_size(ea))
    ida_auto.auto_wait()
    ea = lo
    while ea < hi:
        if ida_bytes.is_code(ida_bytes.get_flags(ea)) and not ida_funcs.get_func(ea):
            ida_funcs.add_func(ea)
        ea += max(1, idc.get_item_size(ea))
    ida_auto.auto_wait()
    return made


def dump_range(lo, hi):
    rows = []
    ea = lo
    while ea < hi:
        sz = max(1, idc.get_item_size(ea))
        raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
        txt = ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS)
        txt = ida_lines.tag_remove(txt) if txt else "?"
        fn = ida_funcs.get_func(ea)
        xr = ["%#x" % x.frm for x in idautils.XrefsTo(ea, 0)]
        rows.append("%#010x\t%s\t%s\t%s\t%s\t%s"
                    % (ea, raw.hex(), esc(txt), ida_name.get_name(ea) or "",
                       ida_funcs.get_func_name(fn.start_ea) if fn else "", ",".join(xr[:6])))
        ea += sz
    return rows


def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    log = ["procname %s" % ida_ida.inf_get_procname(),
           "min %#x max %#x" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()),
           "funcs_before %d" % len(list(idautils.Functions()))]
    for lo, hi, tag in WINDOWS:
        log.append("force %s made=%d" % (tag, force_code(lo, hi)))
    log.append("funcs_after %d" % len(list(idautils.Functions())))
    for lo, hi, tag in DUMP:
        w("disasm_%s.tsv" % tag, dump_range(lo, hi))

    rows = ["# target\tname\tfrom\tfrom_func\ttype"]
    for ea, nm in sorted(STRINGS.items()):
        got = False
        for x in idautils.XrefsTo(ea, 0):
            fn = ida_funcs.get_func(x.frm)
            rows.append("%#010x\t%s\t%#010x\t%s\t%d"
                        % (ea, esc(nm), x.frm,
                           ida_funcs.get_func_name(fn.start_ea) if fn else "", x.type))
            got = True
        if not got:
            rows.append("%#010x\t%s\t-\t-\t-" % (ea, esc(nm)))
    w("string_xrefs.tsv", rows)

    # ---- linear sweep of the whole image for peripheral operands
    rows = ["# ea\tfunc\tval\twindow\tinsn"]
    hist = {}
    lo_ea, hi_ea = ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()
    ea = lo_ea
    step = 0
    while ea < hi_ea:
        insn = ida_ua.insn_t()
        ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            ea += 1
            continue
        for op in insn.ops:
            if op.type == 0:
                break
            v = None
            if op.type in (ida_ua.o_mem, ida_ua.o_far, ida_ua.o_near, ida_ua.o_displ):
                v = op.addr
            elif op.type == ida_ua.o_imm:
                v = op.value
            if v is None:
                continue
            v &= 0xFFFFFFFF
            wn = winof(v)
            if wn:
                hist[v] = hist.get(v, 0) + 1
                if wn != "periph_other":
                    txt = ida_lines.tag_remove(
                        ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or "")
                    fn = ida_funcs.get_func(ea)
                    rows.append("%#010x\t%s\t%#010x\t%s\t%s"
                                % (ea, ida_funcs.get_func_name(fn.start_ea) if fn else "",
                                   v, wn, esc(txt)))
        ea += ln
        step += 1
    w("sweep_periph.tsv", rows)
    w("sweep_hist.tsv", ["# val\twindow\tcount"]
      + ["%#010x\t%s\t%d" % (k, winof(k), v) for k, v in sorted(hist.items())])
    log.append("sweep_insns %d hist %d rows %d" % (step, len(hist), len(rows) - 1))
    w("log.txt", log)


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

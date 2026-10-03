r"""DSP-AMBE job 2: MAIN deep pass over the DV/DSP module.

Reopens DSP_HUNT_MAIN.  Force-decodes the modules that touch the DSP packet
buffers, dumps their disassembly, and then does a LINEAR SWEEP of the whole
0..0x80000 content region looking for absolute operands in the on-chip
register page, so the SCI census does not depend on function recovery.
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
OUT = os.path.join(ROOT, "ida", "out", "dsp", "main")

WINDOWS = [
    (0x00044800, 0x00049200, "sci_handlers"),
    (0x00054000, 0x00060000, "dv_module"),
    (0x0006B800, 0x0006D400, "dv_aux"),
    (0x00078100, 0x00078500, "sci_setup"),
]
DUMP = [
    (0x00056000, 0x00057000, "dsp_rx"),
    (0x00058E00, 0x00059100, "dsp_tx"),
    (0x0006C300, 0x0006C500, "dsp_misc"),
    (0x00078100, 0x00078400, "sci_setup"),
    (0x00045380, 0x00045600, "sci_isr"),
    (0x00056100, 0x00056400, "sci2_isr"),
]

# SCI blocks discovered from the interrupt handlers.  base -> label
SCI_BASES = {
    0xFFFF88: "SCI_A",   # vectors 148/149/150
    0xFFFF60: "SCI_B",   # vectors 152/153/154
    0xFFFE90: "SCI_C",   # vectors 160/161/162
    0xFFFF78: "SCI_cand78",
    0xFFFF80: "SCI_cand80",
    0xFFFE98: "SCI_cand98",
    0xFFFF68: "SCI_cand68",
    0xFFFF70: "SCI_cand70",
}
SCI_OFF = ["SMR", "BRR", "SCR", "TDR", "SSR", "RDR", "SCMR", "+7"]
REGNAME = {}
for base, lab in SCI_BASES.items():
    for i, nm in enumerate(SCI_OFF):
        REGNAME[base + i] = "%s_%s" % (lab, nm)


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
        rows.append(
            "%#08x\t%s\t%s\t%s\t%s\t%s"
            % (ea, raw.hex(), esc(txt), ida_name.get_name(ea) or "",
               ida_funcs.get_func_name(fn.start_ea) if fn else "", ",".join(xr[:6]))
        )
        ea += sz
    return rows


def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    log = ["funcs_before %d" % len(list(idautils.Functions()))]
    for lo, hi, tag in WINDOWS:
        log.append("force %s %#x..%#x made=%d" % (tag, lo, hi, force_code(lo, hi)))
    log.append("funcs_after %d" % len(list(idautils.Functions())))

    for lo, hi, tag in DUMP:
        w("disasm_%s.tsv" % tag, dump_range(lo, hi))

    # ---- linear sweep of the whole content region for register operands
    rows = ["# ea\tfunc\treg\tname\tinsn"]
    hist = {}
    sci_rows = ["# ea\tfunc\treg\tname\tinsn"]
    ea = 0x2000
    end = 0x80000
    while ea < end:
        insn = ida_ua.insn_t()
        ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            ea += 2
            continue
        vals = []
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type in (ida_ua.o_mem, ida_ua.o_far, ida_ua.o_near, ida_ua.o_displ):
                vals.append(op.addr)
            elif op.type == ida_ua.o_imm:
                vals.append(op.value)
        for v in vals:
            v &= 0xFFFFFF
            if 0xFF0000 <= v <= 0xFFFFFF:
                hist[v] = hist.get(v, 0) + 1
                if v in REGNAME:
                    txt = ida_lines.tag_remove(
                        ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or "")
                    fn = ida_funcs.get_func(ea)
                    sci_rows.append(
                        "%#08x\t%s\t%#08x\t%s\t%s"
                        % (ea, ida_funcs.get_func_name(fn.start_ea) if fn else "",
                           v, REGNAME[v], esc(txt)))
        ea += ln
    w("sweep_hist.tsv", ["# reg\tname\tcount"]
      + ["%#08x\t%s\t%d" % (k, REGNAME.get(k, ""), v) for k, v in sorted(hist.items())])
    w("sweep_sci.tsv", sci_rows)
    log.append("sweep_hist_entries %d sci_rows %d" % (len(hist), len(sci_rows) - 1))
    w("log2.txt", log)


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback2.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

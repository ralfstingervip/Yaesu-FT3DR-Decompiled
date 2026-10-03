r"""DSP-AMBE job 1: MAIN (H8S) vocoder/DSP link.

Seeded from ida\db\radio\MAIN.i64 with --copy-from into DSP_HUNT_MAIN.

Does four things:
  1. force-analyses the DSP driver window and dumps annotated disassembly
  2. walks every code xref into that window (callers of the driver)
  3. scans the whole image for H8S on-chip-register operands (@aa:16 with the
     sign-extended 0xFFFFxx form, and @aa:8) and buckets them by peripheral
  4. dumps the 256-entry big-endian vector table at 0 with handler names

Output: ida/out/dsp/main/*.  Never touches the shared databases.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import struct
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_lines
import ida_name
import ida_ua
import ida_xref
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "dsp", "main")

# windows to force-decode and dump
WINDOWS = [
    (0x0005A000, 0x0005B400, "dsp_driver"),
]

# every string pointer in the DSP trace table plus the trace strings
DSP_STRINGS = {
    0x0005AE1C: "CPU>DSP: ",
    0x0005AE28: "DSP>CPU: ",
    0x0005AE5A: "DSP POWER:ON & RESET!",
    0x0005AE72: "TIME OUT:3sec!",
    0x0005AE82: "DSP?",
    0x0005AE88: "DSP>CPU: ACK",
    0x0005AE96: "DSP>CPU: NAK",
    0x0005AEA4: "CPU>DSP: ACK",
    0x0005AEB2: "CPU>DSP: NAK",
    0x0005AEC0: "CPU>DSP: RX DISABLE",
    0x0005AED6: "CPU>DSP: RX ENABLE",
    0x0005AEEA: "CPU>DSP: MUTE ON",
    0x0005AEFC: "CPU>DSP: MUTE OFF",
    0x0005AF10: "CPU>DSP: STOP ENCODE",
    0x0005AF26: "CPU>DSP:VER?",
    0x0005AF34: "DSP>CPU: DATA TEXT SET",
    0x0005AF4C: "DSP>CPU: TERM TX",
    0x0005AF5E: "DSP>CPU: TERM RX",
}

# H8S/237x on-chip register page.  Names are from the hardware manual for the
# blocks we care about; anything unnamed is still reported with its address.
H8S_REGS = {
    0xFFFF78: "SCI0_SMR", 0xFFFF79: "SCI0_BRR", 0xFFFF7A: "SCI0_SCR",
    0xFFFF7B: "SCI0_TDR", 0xFFFF7C: "SCI0_SSR", 0xFFFF7D: "SCI0_RDR",
    0xFFFF7E: "SCI0_SCMR",
    0xFFFF80: "SCI1_SMR", 0xFFFF81: "SCI1_BRR", 0xFFFF82: "SCI1_SCR",
    0xFFFF83: "SCI1_TDR", 0xFFFF84: "SCI1_SSR", 0xFFFF85: "SCI1_RDR",
    0xFFFF86: "SCI1_SCMR",
    0xFFFF88: "SCI2_SMR", 0xFFFF89: "SCI2_BRR", 0xFFFF8A: "SCI2_SCR",
    0xFFFF8B: "SCI2_TDR", 0xFFFF8C: "SCI2_SSR", 0xFFFF8D: "SCI2_RDR",
    0xFFFF8E: "SCI2_SCMR",
    0xFFFDB0: "SCI3_SMR", 0xFFFDB1: "SCI3_BRR", 0xFFFDB2: "SCI3_SCR",
    0xFFFDB3: "SCI3_TDR", 0xFFFDB4: "SCI3_SSR", 0xFFFDB5: "SCI3_RDR",
    0xFFFDB6: "SCI3_SCMR",
    0xFFFDB8: "SCI4_SMR", 0xFFFDB9: "SCI4_BRR", 0xFFFDBA: "SCI4_SCR",
    0xFFFDBB: "SCI4_TDR", 0xFFFDBC: "SCI4_SSR", 0xFFFDBD: "SCI4_RDR",
    0xFFFDBE: "SCI4_SCMR",
    0xFFFF38: "MSTPCRH", 0xFFFF39: "MSTPCRL",
    0xFFFF3A: "SBYCR", 0xFFFF3B: "SYSCR", 0xFFFF3C: "SCKCR", 0xFFFF3D: "MDCR",
    0xFFFF2C: "IPRA", 0xFFFF2E: "IPRB", 0xFFFF30: "IPRC", 0xFFFF32: "IPRD",
    0xFFFF34: "IPRE", 0xFFFF36: "IPRF", 0xFFFF40: "IPRG", 0xFFFF42: "IPRH",
    0xFFFF44: "IPRI", 0xFFFF46: "IPRJ", 0xFFFF48: "IPRK",
    0xFFFF2A: "ISR", 0xFFFF29: "IER", 0xFFFF28: "ISCRH", 0xFFFF2B: "ISCRL",
    0xFFFFB0: "P1DDR", 0xFFFFB1: "P2DDR", 0xFFFFB2: "P3DDR",
    0xFFFFB4: "P5DDR", 0xFFFFB5: "P6DDR", 0xFFFFB7: "P8DDR",
    0xFFFFB8: "P9DDR", 0xFFFFB9: "PADDR", 0xFFFFBA: "PBDDR",
    0xFFFFC0: "P1DR", 0xFFFFC1: "P2DR", 0xFFFFC2: "P3DR",
    0xFFFFC4: "P5DR", 0xFFFFC5: "P6DR", 0xFFFFC7: "P8DR",
    0xFFFFC8: "P9DR", 0xFFFFC9: "PADR", 0xFFFFCA: "PBDR",
    0xFFFFB0 + 0: "P1DDR",
}


def w(path, rows):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")


def esc(t):
    return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")


def force_code(lo, hi):
    ea = lo
    made = 0
    while ea < hi:
        f = ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(f):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            if idc.create_insn(ea) > 0:
                made += 1
                ea += max(1, idc.get_item_size(ea))
                continue
            ea += 1
            continue
        ea += max(1, idc.get_item_size(ea))
    ida_auto.auto_wait()
    return made


def dump_range(lo, hi, tag):
    rows = ["# %s %#x..%#x" % (tag, lo, hi)]
    ea = lo
    while ea < hi:
        sz = max(1, idc.get_item_size(ea))
        raw = ida_bytes.get_bytes(ea, min(sz, 16)) or b""
        txt = ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS)
        txt = ida_lines.tag_remove(txt) if txt else "?"
        nm = ida_name.get_name(ea)
        fn = ida_funcs.get_func(ea)
        fname = ida_funcs.get_func_name(fn.start_ea) if fn else ""
        xr = []
        for x in idautils.XrefsTo(ea, 0):
            xr.append("%#x:%d" % (x.frm, x.type))
        rows.append(
            "%#08x\t%s\t%s\t%s\t%s\t%s"
            % (ea, raw.hex(), esc(txt), nm or "", fname, ",".join(xr[:8]))
        )
        ea += sz
    return rows


def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    log = []
    log.append("procname %s" % ida_ida.inf_get_procname())
    log.append("min %#x max %#x" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
    log.append("funcs_before %d" % len(list(idautils.Functions())))

    # ---- 1. force the driver window into code and dump it
    for lo, hi, tag in WINDOWS:
        n = force_code(lo, hi)
        log.append("force_code %s made=%d" % (tag, n))
        # let IDA build functions there
        ea = lo
        while ea < hi:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) and not ida_funcs.get_func(ea):
                ida_funcs.add_func(ea)
            ea += max(1, idc.get_item_size(ea))
        ida_auto.auto_wait()
        w("disasm_%s.tsv" % tag, dump_range(lo, hi, tag))
    log.append("funcs_after %d" % len(list(idautils.Functions())))

    # ---- 2. xrefs to the DSP strings and to the driver functions
    rows = ["# target\tname\tfrom\tfrom_func\ttype"]
    for ea, name in sorted(DSP_STRINGS.items()):
        got = False
        for x in idautils.XrefsTo(ea, 0):
            fn = ida_funcs.get_func(x.frm)
            rows.append(
                "%#08x\t%s\t%#08x\t%s\t%d"
                % (ea, esc(name), x.frm, ida_funcs.get_func_name(fn.start_ea) if fn else "", x.type)
            )
            got = True
        if not got:
            rows.append("%#08x\t%s\t-\t-\t-" % (ea, esc(name)))
    w("string_xrefs.tsv", rows)

    # every function whose body lies in the driver window, and its callers
    rows = ["# func\tstart\tend\tcaller\tcaller_func"]
    for lo, hi, _tag in WINDOWS:
        for f in idautils.Functions(lo, hi):
            fn = ida_funcs.get_func(f)
            callers = set()
            for x in idautils.XrefsTo(f, 0):
                cf = ida_funcs.get_func(x.frm)
                callers.add((x.frm, ida_funcs.get_func_name(cf.start_ea) if cf else ""))
            if not callers:
                rows.append("%s\t%#08x\t%#08x\t-\t-" % (ida_funcs.get_func_name(f), fn.start_ea, fn.end_ea))
            for frm, cn in sorted(callers):
                rows.append(
                    "%s\t%#08x\t%#08x\t%#08x\t%s"
                    % (ida_funcs.get_func_name(f), fn.start_ea, fn.end_ea, frm, cn)
                )
    w("driver_funcs.tsv", rows)

    # ---- 3. whole-image on-chip register operand scan
    rows = ["# ea\tfunc\treg_ea\treg_name\tinsn"]
    seen = {}
    for f in idautils.Functions():
        fn = ida_funcs.get_func(f)
        if not fn:
            continue
        ea = fn.start_ea
        while ea < fn.end_ea:
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, ea)
            if ln > 0:
                for op in insn.ops:
                    if op.type == 0:
                        break
                    v = None
                    if op.type in (ida_ua.o_mem, ida_ua.o_far, ida_ua.o_near):
                        v = op.addr
                    elif op.type == ida_ua.o_imm:
                        v = op.value
                    elif op.type == ida_ua.o_displ:
                        v = op.addr
                    if v is None:
                        continue
                    v &= 0xFFFFFF
                    if 0xFFF800 <= v <= 0xFFFFFF:
                        txt = ida_lines.tag_remove(
                            ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or ""
                        )
                        rows.append(
                            "%#08x\t%s\t%#08x\t%s\t%s"
                            % (ea, ida_funcs.get_func_name(f), v, H8S_REGS.get(v, ""), esc(txt))
                        )
                        seen[v] = seen.get(v, 0) + 1
                ea += max(1, ln)
            else:
                ea += 1
    w("onchip_operands.tsv", rows)
    w(
        "onchip_hist.tsv",
        ["# reg_ea\tname\tcount"]
        + ["%#08x\t%s\t%d" % (k, H8S_REGS.get(k, ""), v) for k, v in sorted(seen.items())],
    )

    # ---- 4. vector table
    rows = ["# slot\tvec_ea\ttarget\tname\tfunc"]
    for i in range(256):
        va = i * 4
        raw = ida_bytes.get_bytes(va, 4)
        if not raw:
            break
        tgt = struct.unpack(">I", raw)[0]
        fn = ida_funcs.get_func(tgt)
        rows.append(
            "%d\t%#08x\t%#08x\t%s\t%s"
            % (i, va, tgt, ida_name.get_name(tgt) or "", ida_funcs.get_func_name(fn.start_ea) if fn else "")
        )
    w("vectors.tsv", rows)

    w("log.txt", log)


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

"""SUB-LOWER job 2a: load the SUB RX64M image and establish a baseline.

Rebase to 0xFFC00000 (same pattern as ida\\survey.py _rebase/_split_sub), but
segment it for this job: LOWER = my region 0xFFC00000-0xFFE80000, UPPER = the
rest (SUB-VEC's region, mapped only so calls and pointers out of LOWER resolve).

Both segments are added with ADDSEG_NOAA so IDA does not carpet-analyse 4 MB of
display resources. Code is seeded only from the 32 fixed vectors at EXTB.

Writes baseline_functions.tsv and baseline.txt under
ida/out/sub-lower.
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
import ida_idp
import ida_name
import ida_segment
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "load_error.txt")
BASE = 0xFFC00000
SIZE = 0x400000
LO = 0xFFC00000
HI = 0xFFE80000
LOG = []


def log(t: str) -> None:
    LOG.append(t)


def rebase(base: int) -> None:
    seg = ida_segment.get_first_seg()
    if seg is None:
        raise RuntimeError("no segment to rebase")
    delta = base - seg.start_ea
    log("rebase delta %#x from %#x" % (delta, seg.start_ea))
    if delta:
        rc = ida_segment.rebase_program(delta, ida_segment.MSF_NOFIX)
        if rc != ida_segment.MOVE_SEGM_OK:
            raise RuntimeError("rebase_program -> %s" % rc)


def resegment() -> None:
    seg = ida_segment.get_first_seg()
    if seg is None:
        raise RuntimeError("no segment to split")
    end = seg.end_ea
    log("loaded segment %#x-%#x size %#x" % (seg.start_ea, end, end - seg.start_ea))
    ida_segment.del_segm(seg.start_ea, ida_segment.SEGMOD_KEEP)
    for start, stop, name in ((LO, HI, "LOWER"), (HI, BASE + SIZE, "UPPER")):
        ok = ida_segment.add_segm(0, start, stop, name, "CODE", ida_segment.ADDSEG_NOAA)
        log("segment %s %#x-%#x ok=%s" % (name, start, stop, ok))


def seed_fixed_vectors() -> int:
    """32 fixed vectors at EXTB 0xFFFFFF80. Returns the reset target."""
    table = BASE + SIZE - 0x80
    reset = 0
    rows = []
    for i in range(32):
        ea = table + i * 4
        ida_bytes.del_items(ea, 0, 4)
        ida_bytes.create_dword(ea, 4, True)
        v = ida_bytes.get_dword(ea)
        inside = BASE <= v < BASE + SIZE
        rows.append((i, ea, v, inside))
        if inside:
            if i == 31:
                reset = v
                ida_name.set_name(v, "reset_handler", ida_name.SN_FORCE)
            ida_ua.create_insn(v)
            ida_auto.auto_make_code(v)
    log("fixed vectors: %d in image" % sum(1 for r in rows if r[3]))
    log("reset %#x" % reset)
    return reset


def dump(reset: int) -> None:
    n_all = 0
    n_low = 0
    b_low = 0
    b_all = 0
    with open(os.path.join(OUT, "baseline_functions.tsv"), "w",
              encoding="utf-8", newline="\n") as fh:
        fh.write("ea\tend\tsize\tregion\tname\n")
        for s in idautils.Functions():
            f = ida_funcs.get_func(s)
            if f is None:
                continue
            size = f.end_ea - f.start_ea
            reg = "LOWER" if LO <= s < HI else "UPPER"
            n_all += 1
            b_all += size
            if reg == "LOWER":
                n_low += 1
                b_low += size
            fh.write("%08X\t%08X\t%d\t%s\t%s\n"
                     % (s, f.end_ea, size, reg, idc.get_func_name(s) or ""))

    # how many bytes in LOWER are currently marked code / data / unexplored
    code = data = unk = 0
    ea = LO
    while ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            code += 1
        elif ida_bytes.is_data(fl):
            data += 1
        else:
            unk += 1
        ea += 1

    with open(os.path.join(OUT, "baseline.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("processor %s\n" % (ida_idp.get_idp_name() or ""))
        fh.write("min %#x max %#x\n" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
        fh.write("reset %#x\n" % reset)
        fh.write("reset_disasm %s\n" % (idc.generate_disasm_line(reset, 0) or ""))
        fh.write("functions_total %d bytes %d\n" % (n_all, b_all))
        fh.write("functions_LOWER %d bytes %d\n" % (n_low, b_low))
        fh.write("LOWER span %#x-%#x bytes %d\n" % (LO, HI, HI - LO))
        fh.write("LOWER byte_code %d byte_data %d byte_unknown %d\n" % (code, data, unk))
        fh.write("\nlog\n")
        for line in LOG:
            fh.write("  %s\n" % line)


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.enable_auto(False)
    rebase(BASE)
    resegment()
    reset = seed_fixed_vectors()
    ida_auto.enable_auto(True)
    ida_auto.auto_wait()
    if reset:
        ida_ua.create_insn(reset)
        ida_auto.auto_make_code(reset)
        ida_auto.auto_wait()
    dump(reset)
    idc.qexit(0)


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(ERR, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(traceback.format_exc())
        fh.write("\n".join(LOG))
    idc.qexit(1)

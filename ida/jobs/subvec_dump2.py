r"""SUB-VEC pass E: dump the remaining functions that name unidentified blocks,
and measure coverage honestly (union of function ranges, code-byte counts,
call-validated function count).

    python ida/run_job.py --script ida\jobs\subvec_dump2.py --db SUB_VEC --reopen
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

OUT = str(_REPO / "ida/out/sub-vec")
BASE = 0xFFC00000
TOP = 0x100000000
MINE_LO = 0xFFE80000
CODE_LO = 0xFFED0000
CODE_HI = 0xFFF50000
STATUS = os.path.join(OUT, "passE_status.txt")

# addresses inside the functions we want; pass E resolves them to function starts
WANT = [
    0xFFF37443,   # SYSCR0 + BSC chip-select setup
    0xFFF374D8, 0xFFF3753A, 0xFFF37558,
    0xFFEF1F74,   # EXDMAC0 source/dest/count programming
    0xFFF375D0,   # audio output sink called by vector 210
    0xFFF15155,   # R12DA DADR0 write
    0xFFF15055,
    0xFFF33086, 0xFFF331D8, 0xFFF33204,   # SDHI driver
    0xFFF40309, 0xFFE961FA,
    0xFFEDC976,
]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def main():
    import ida_bytes
    import ida_funcs
    import idautils
    import idc

    seen = set()
    with open(os.path.join(OUT, "blocks_disasm.txt"), "w", encoding="utf-8", newline="\n") as h:
        for a in WANT:
            f = ida_funcs.get_func(a)
            s = f.start_ea if f else a
            if s in seen:
                continue
            seen.add(s)
            if f is None:
                h.write("\n;=== %08X no function\n" % a)
                continue
            h.write("\n;=== %08X-%08X file %06X size %d %s\n" % (
                f.start_ea, f.end_ea, f.start_ea - BASE, f.end_ea - f.start_ea,
                idc.get_func_name(s) or ""))
            ea = f.start_ea
            while ea < f.end_ea and ea != idc.BADADDR:
                raw = ida_bytes.get_bytes(ea, min(max(1, idc.get_item_size(ea)), 12)) or b""
                h.write("%08X  %-26s %s\n" % (ea, raw.hex(), esc(idc.generate_disasm_line(ea, 0) or "")))
                ea = idc.next_head(ea, f.end_ea)
    log("wrote blocks_disasm.txt (%d functions)" % len(seen))

    # ---- honest coverage ----
    ivals = []
    called = 0
    total = 0
    for s in idautils.Functions():
        f = ida_funcs.get_func(s)
        if not f:
            continue
        total += 1
        ivals.append((f.start_ea, f.end_ea))
        for xr in idautils.XrefsTo(s, 0):
            if xr.type in (16, 17):        # fl_CF, fl_CN
                called += 1
                break
    ivals.sort()
    union = 0
    cs = ce = None
    for a, b in ivals:
        if cs is None:
            cs, ce = a, b
        elif a <= ce:
            ce = max(ce, b)
        else:
            union += ce - cs
            cs, ce = a, b
    if cs is not None:
        union += ce - cs

    code = data = undef = 0
    ea = CODE_LO
    while ea < CODE_HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            code += 1
        elif ida_bytes.is_data(fl):
            data += 1
        else:
            undef += 1
        ea += 1

    with open(os.path.join(OUT, "coverage.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n-- pass E honest measures --\n")
        h.write("functions total %d, of which reached by a call/jump xref %d\n" % (total, called))
        h.write("union of function ranges (no double counting) %d bytes\n" % union)
        h.write("code-bearing window FFED0000-FFF50000 = %d bytes: code %d (%.1f%%) data %d undefined %d\n" % (
            CODE_HI - CODE_LO, code, 100.0 * code / (CODE_HI - CODE_LO), data, undef))
    log("union %d code %d called %d/%d" % (union, code, called, total))
    log("passE done")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "passE_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION written")
    import idc as _idc
    _idc.qexit(0)

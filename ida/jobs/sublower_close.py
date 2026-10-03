r"""SUB-LOWER job 2e: undo the force experiment, fix the reset stub, hand off.

The force experiment in job 2d left instruction runs at 33 rejected candidates
inside RGB565 pixel data. Undo them so the final coverage number reflects what
the evidence supports, then make the one real thing in the region -- the 60-byte
reset stub -- a proper function.

Also dump the three routines that touch MSTPCRA-D and PRCR in full. That is
SUB-USB's decisive test; this is the hand-off, not a verdict.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "close_error.txt")
LO = 0xFFC00000
HI = 0xFFE80000
NOTE = []


def esc(t: str) -> str:
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def dis(ea: int) -> str:
    return esc(idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE))


def undo() -> None:
    n = 0
    for s in list(idautils.Functions()):
        if LO <= s < HI and s != LO:
            ida_funcs.del_func(s)
            n += 1
    # wipe every item in LOWER except the reset stub, then re-mark as unexplored
    ida_bytes.del_items(LO + 0x40, ida_bytes.DELIT_SIMPLE, HI - LO - 0x40)
    ida_auto.auto_wait()
    NOTE.append("UNDO: deleted %d forced functions and cleared items above "
                "%08X" % (n, LO + 0x40))


def reset_stub() -> None:
    ida_bytes.del_items(LO, 0, 0x40)
    ea = LO
    while ea < LO + 0x3C:
        if ida_ua.create_insn(ea) <= 0:
            NOTE.append("RESET: create_insn failed at %08X" % ea)
            break
        ea += max(1, ida_bytes.get_item_size(ea))
    ida_funcs.add_func(LO, LO + 0x3C)
    ida_auto.auto_wait()
    f = ida_funcs.get_func(LO)
    NOTE.append("RESET: function at %08X size %s"
                % (LO, (f.end_ea - f.start_ea) if f else "none"))


def dump_mstp() -> None:
    path = os.path.join(OUT, "mstp_prcr.txt")
    with open(path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("Routines in the SUB image that touch MSTPCRA-D (00080010-"
                 "0008001F) and PRCR (000803FE).\n"
                 "r14/r1 is loaded with 00080010, so 4[r14] = MSTPCRB, "
                 "8[r14] = MSTPCRC, 0Ch[r14] = MSTPCRD, 3EEh[r14] = PRCR.\n"
                 "Handed to SUB-USB: the USB0 module-stop bit lives in MSTPCRB.\n")
        for start, end, tag in ((0xFFEE1393, 0xFFEE1400, "FFEE1393"),
                                (0xFFF15055, 0xFFF150A0, "FFF15055"),
                                (0xFFF36CCA, 0xFFF36E20, "FFF36CCA"),
                                (0xFFF37400, 0xFFF37460, "FFF37424 PRCR")):
            fh.write("\n=== %s ===\n" % tag)
            ea = start
            insn = ida_ua.insn_t()
            while ea < end:
                ln = ida_ua.decode_insn(insn, ea)
                if ln <= 0:
                    fh.write("%08X  %-16s (no decode)\n"
                             % (ea, (ida_bytes.get_bytes(ea, 1) or b"").hex()))
                    ea += 1
                    continue
                fh.write("%08X  %-16s %s\n"
                         % (ea, (ida_bytes.get_bytes(ea, ln) or b"").hex(), dis(ea)))
                ea += ln
    NOTE.append("MSTP: wrote %s" % path)


def coverage() -> None:
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
    nf = [s for s in idautils.Functions() if LO <= s < HI]
    bf = sum(ida_funcs.get_func(s).end_ea - s for s in nf)
    NOTE.append("CLEAN: LOWER code %d data %d unexplored %d of %d bytes"
                % (code, data, unk, HI - LO))
    NOTE.append("CLEAN: LOWER functions %d covering %d bytes: %s"
                % (len(nf), bf, ["%08X" % s for s in nf]))
    NOTE.append("CLEAN: whole-image functions %d"
                % sum(1 for _ in idautils.Functions()))


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    undo()
    reset_stub()
    dump_mstp()
    coverage()
    with open(os.path.join(OUT, "close_notes.txt"), "w", encoding="utf-8",
              newline="\n") as fh:
        for line in NOTE:
            fh.write(line + "\n")
    idc.qexit(0)


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(ERR, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(traceback.format_exc())
        fh.write("\n\n" + "\n".join(NOTE))
    idc.qexit(1)

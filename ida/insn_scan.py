"""Read an existing survey database and list USB-range immediates.

Launch only through run_survey-style subprocess. YAESU_JOB is MAIN or SUB.
Does not create a database and does not rename functions.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[1]  # repository root

import os

import ida_auto
import ida_bytes
import ida_funcs
import ida_idp
import ida_ua
import idautils
import idc

OUT_ROOT = str(_REPO / "ida/out/survey")


def main() -> None:
    name = os.environ.get("YAESU_JOB", "").strip()
    folder = os.path.join(OUT_ROOT, name)
    os.makedirs(folder, exist_ok=True)
    path = os.path.join(folder, "insn_scan.txt")
    lines = []
    lines.append("processor %s" % (ida_idp.get_idp_name() or ""))
    entry_name = "reset_handler"
    entry = idc.get_name_ea_simple(entry_name)
    lines.append("reset %s" % ("" if entry == idc.BADADDR else "%08X" % entry))
    if entry != idc.BADADDR:
        ea = entry
        for _ in range(24):
            line = idc.generate_disasm_line(ea, 0) or ""
            lines.append("  %08X  %s" % (ea, line))
            nxt = idc.next_head(ea, ea + 32)
            if nxt == idc.BADADDR or nxt <= ea:
                break
            ea = nxt
    # Immediates that land in the RX64M USB0 window, plus a wide peripheral probe.
    hits = []
    windows = ((0x000A0000, 0x000A0400, "USB0"),)
    if name == "SUB":
        windows = (
            (0x000A0000, 0x000A0400, "USB0"),
            (0x000D0000, 0x000D8000, "D0000"),
        )
    for start in idautils.Functions():
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        ea = func.start_ea
        while ea < func.end_ea:
            insn = ida_ua.insn_t()
            size = ida_ua.decode_insn(insn, ea)
            if size <= 0:
                ea += 1
                continue
            for op in insn.ops:
                if op.type != ida_ua.o_imm:
                    continue
                value = op.value & 0xFFFFFFFF
                for lo, hi, label in windows:
                    if lo <= value < hi:
                        text = idc.generate_disasm_line(ea, 0) or ""
                        hits.append((ea, label, value, text))
            ea += size
            if len(hits) >= 80:
                break
        if len(hits) >= 80:
            break
    lines.append("immediate hits %d" % len(hits))
    for ea, label, value, text in hits:
        lines.append("  %08X  %s %08X  %s" % (ea, label, value, text))
    with open(path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(lines) + "\n")
    idc.qexit(0)


if __name__ == "__main__":
    main()

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, idc
LOGDIR = str(_REPO / "ida/log/jobs/W2_MAIN_RAW2")
OUT = os.path.join(LOGDIR, "w2_8_decodetest.txt")
lines = []
def main():
    ida_auto.auto_wait()
    insn = ida_ua.insn_t()
    for ea in (0x2092, 0x000400, 0x004876, 0x00874C, 0x0095FC, 0x010008,
               0x005046, 0x01A1A4, 0x02927C):
        raw = ida_bytes.get_bytes(ea, 12) or b""
        fl = ida_bytes.get_flags(ea)
        sz = ida_ua.decode_insn(insn, ea)
        mnem = ida_ua.print_insn_mnem(ea) or ""
        disp = idc.generate_disasm_line(ea, 0) or ""
        lines.append("%06X code=%s data=%s unkn=%s | bytes=%s | sz=%d itype=%d mnem=%s | %s"
                     % (ea, ida_bytes.is_code(fl), ida_bytes.is_data(fl),
                        ida_bytes.is_unknown(fl), raw.hex(), sz, insn.itype, mnem, disp))
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(lines) + "\n")
try:
    main()
except Exception:
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("TRACE\n" + traceback.format_exc())
idc.qexit(0)

r"""SUB-USB job 4: targeted disassembly dumps for the USB verdict."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-usb")
ERR = os.path.join(OUT, "job4.err.txt")

RANGES = [
    (0xFFEDB340, 0xFFEDB3F0, "ICU group-interrupt enable (GENBL0/GENBL1) setup"),
    (0xFFEDBCDD, 0xFFEDBD60, "GROUPBL0 handler (vector 110)"),
    (0xFFF32C99, 0xFFF32CE0, "GROUPBL1 handler (vector 111)"),
    (0xFFEE1393, 0xFFEE1400, "runtime MSTPCRA + MPC helper at FFEE1393"),
    (0xFFF15050, 0xFFF150B0, "runtime MSTPCRA helper at FFF15055"),
    (0xFFF37320, 0xFFF37440, "MPC pin-function setup (PFS writes)"),
    (0xFFF36FF0, 0xFFF37080, "PORT init continued"),
]

def run():
    import ida_auto, ida_bytes, ida_ua, idc
    ida_auto.auto_wait()
    lines = []
    for start, end, title in RANGES:
        lines.append("")
        lines.append("=========== %s  %08X..%08X ===========" % (title, start, end))
        ea = start
        while ea < end:
            if not ida_bytes.is_code(ida_bytes.get_full_flags(ea)):
                ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 8)
                ida_ua.create_insn(ea)
            n = ida_ua.decode_insn(ida_ua.insn_t(), ea)
            if n <= 0:
                lines.append("  %08X  .byte %02X" % (ea, ida_bytes.get_byte(ea))); ea += 1; continue
            raw = " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(n))
            lines.append("  %08X  %-22s %s" % (ea, raw,
                (idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or "")))
            ea += n
    with open(os.path.join(OUT, "job4_dump.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(lines) + "\n")

try:
    run()
except Exception:
    with open(ERR, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
import idc
idc.qexit(0)

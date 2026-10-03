r"""SUB-USB: probe how the IDA RX module encodes operands, and dump the startup
peripheral-init code in full."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-usb")
os.makedirs(OUT, exist_ok=True)
ERR = os.path.join(OUT, "job2.err.txt")

def run():
    import ida_auto, ida_bytes, ida_ua, idc, ida_funcs
    ida_auto.auto_wait()
    lines = []

    def opdump(ea):
        ins = ida_ua.insn_t()
        n = ida_ua.decode_insn(ins, ea)
        lines.append("  %08X len=%d  %s" % (ea, n, idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE)))
        for k, op in enumerate(ins.ops):
            if op.type == ida_ua.o_void:
                break
            lines.append("     op%d type=%d reg=%d phrase=%d addr=%#x value=%#x dtype=%d specval=%#x specflag1=%d specflag2=%d specflag3=%d specflag4=%d"
                % (k, op.type, op.reg, op.phrase, op.addr & 0xFFFFFFFF, op.value & 0xFFFFFFFF,
                   op.dtype, op.specval & 0xFFFFFFFF, op.specflag1, op.specflag2, op.specflag3, op.specflag4))
        return n

    lines.append("== operand probe: PRCR write at FFEE1398 ==")
    opdump(0xFFEE1398)
    lines.append("== operand probe: FFF36CD1 ==")
    opdump(0xFFF36CD1)
    lines.append("== operand probe: FFF36D1E ==")
    opdump(0xFFF36D1E)

    def dump(start, end, title):
        lines.append("")
        lines.append("=========== %s  %08X..%08X ===========" % (title, start, end))
        ea = start
        while ea < end:
            if not ida_bytes.is_code(ida_bytes.get_full_flags(ea)):
                ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 8)
                ida_ua.create_insn(ea)
            n = ida_ua.decode_insn(ida_ua.insn_t(), ea)
            if n <= 0:
                lines.append("  %08X  .byte %02X   (no decode)" % (ea, ida_bytes.get_byte(ea)))
                ea += 1
                continue
            raw = " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(n))
            txt = idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or ""
            lines.append("  %08X  %-24s %s" % (ea, raw, txt))
            ea += n

    dump(0xFFC00000, 0xFFC00040, "reset handler")
    dump(0xFFF36C4B, 0xFFF36FF0, "startup callee #2 (from reset BSR.A at FFC0002E)")
    dump(0xFFEE1380, 0xFFEE1420, "module-stop helper near FFEE1393")

    with open(os.path.join(OUT, "job2_probe.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(lines) + "\n")

try:
    run()
except Exception:
    with open(ERR, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
import idc
idc.qexit(0)

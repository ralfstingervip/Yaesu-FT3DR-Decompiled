r"""Lane I6 - list every MAIN code head that addresses a target RAM byte (abs16/abs24/abs32
o_mem, or mov.l #imm base load) inside 0..0x078106 and 0x07B754..0x80000 (closed window skipped).
Read-only on a private DB copy (I6_MAIN). Output ida\out\orphan-screens\readers_raw.tsv (UTF-8).
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
BASE = str(_REPO / "ida/out/orphan-screens")
OUT = os.path.join(BASE, "readers_raw.tsv")
ERR = os.path.join(BASE, "i6_readers_error.txt")
LO_T, HI_T = 0xFF8920, 0xFF8EB0   # whole R1/R2/R3 + a little of the band area


def main():
    import ida_auto, ida_ua, ida_funcs, ida_bytes, idc, idautils
    ida_auto.auto_wait()
    out = ["ea\tfunc\ttarget\tkind\tbytes\tdisasm"]
    n = 0
    for seg in idautils.Segments():
        for h in idautils.Heads(seg, idc.get_segm_end(seg)):
            if h >= 0x80000 or (0x078106 <= h <= 0x07B753):
                continue
            if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                continue
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, h)
            if ln <= 0:
                continue
            n += 1
            for i in range(8):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                kind = None
                if op.type == ida_ua.o_mem:
                    v = op.addr & 0xFFFFFF; kind = "mem"
                elif op.type == ida_ua.o_imm:
                    v = op.value & 0xFFFFFFFF
                    if v > 0xFFFFFF:
                        continue
                    kind = "imm"
                elif op.type == ida_ua.o_displ:
                    v = op.addr & 0xFFFFFF; kind = "displ"
                else:
                    continue
                if LO_T <= v < HI_T:
                    f = ida_funcs.get_func(h)
                    dis = (idc.generate_disasm_line(h, 0) or "").split(";")[0].strip()
                    out.append("%06X\t%s\t%06X\t%s\t%s\t%s" % (h, ("%06X" % f.start_ea) if f else "-", v, kind,
                               ida_bytes.get_bytes(h, ln).hex(" "), dis))
    out.append("# heads scanned: %d" % n)
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")


try:
    main()
except Exception:
    with open(ERR, "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
import idc
idc.qexit(0)

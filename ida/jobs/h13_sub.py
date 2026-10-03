r"""Lane H13 - SUB scan (read-only, private DB H13_SUB).

Every SUB code head that compares a register with immediate 0x16 or 0x1A
(RX cmp #imm forms) and, within the previous 8 heads, references the IPC frame
latch 0x8C4D/0x8C4E or the receive buffer 0x8E46/0x8E47 (the item-code byte).
Also lists every code head with an operand equal to 0x8C6D / 0x8E66.
Output ida\out\hidden-settings\sub_scan.txt (UTF-8).
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
BASE = str(_REPO / "ida/out/hidden-settings")
OUT = os.path.join(BASE, "sub_scan.txt")
ERR = os.path.join(BASE, "h13_sub_error.txt")

def main():
    import ida_auto, ida_ua, ida_bytes, ida_funcs, idc, idautils
    ida_auto.auto_wait()
    out = []
    w = out.append
    FR = {0x8C4D, 0x8C4E, 0x8E46, 0x8E47}
    def vals(insn):
        r = []
        for i in range(8):
            op = insn.ops[i]
            if op.type == ida_ua.o_void:
                break
            if op.type == ida_ua.o_imm:
                r.append(("imm", op.value & 0xFFFFFFFF))
            elif op.type == ida_ua.o_displ:
                r.append(("dsp", op.value & 0xFFFFFFFF))
            elif op.type in (ida_ua.o_mem, ida_ua.o_near):
                r.append(("mem", op.addr & 0xFFFFFFFF))
        return r
    def line(ea):
        insn = ida_ua.insn_t()
        n = ida_ua.decode_insn(insn, ea)
        if n <= 0:
            return "%08X ??" % ea
        return "%08X  %-20s %s" % (ea, ida_bytes.get_bytes(ea, n).hex(" "), (idc.generate_disasm_line(ea, 0) or "").split(";")[0].strip())
    hits = {0x16: [], 0x1A: []}
    direct = []
    n_heads = 0
    for seg in idautils.Segments():
        for h in idautils.Heads(seg, idc.get_segm_end(seg)):
            if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                continue
            n_heads += 1
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, h) <= 0:
                continue
            vs = vals(insn)
            if any(v in (0x8C6D, 0x8E66) for _k, v in vs):
                direct.append(h)
            mn = insn.get_canon_mnem().lower()
            if mn.startswith("cmp") or mn.startswith("sub") or mn.startswith("add"):
                for k, v in vs:
                    if k == "imm" and v in (0x16, 0x1A, 0xFFFFFFEA, 0xFFFFFFE6):
                        q = h
                        ok = False
                        for _i in range(8):
                            q = idc.prev_head(q)
                            if q == idc.BADADDR:
                                break
                            pi = ida_ua.insn_t()
                            if ida_ua.decode_insn(pi, q) <= 0:
                                break
                            if any(vv in FR for _kk, vv in vals(pi)):
                                ok = True
                                break
                        if ok:
                            key = 0x16 if v in (0x16, 0xFFFFFFEA) else 0x1A
                            hits[key].append(h)
    w("code heads scanned: %d" % n_heads)
    for key in (0x16, 0x1A):
        w("##### compares with #0x%X near frame code byte: %d" % (key, len(hits[key])))
        for h in hits[key]:
            f = ida_funcs.get_func(h)
            w("  %s   [fn %s]" % (line(h), ("%08X" % f.start_ea) if f else "-"))
    w("##### direct operand 0x8C6D/0x8E66: %d" % len(direct))
    for h in direct:
        f = ida_funcs.get_func(h)
        w("  %s   [fn %s]" % (line(h), ("%08X" % f.start_ea) if f else "-"))
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")

try:
    main()
except Exception:
    with open(ERR, "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
import idc
idc.qexit(0)

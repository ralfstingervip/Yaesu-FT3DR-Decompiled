# -*- coding: utf-8 -*-
r"""Lane H3: dump MAIN DB state (functions, per-byte item class, immediate
operands in content range, existing xrefs-to for function starts).
Read-only on the DB contents. Output: ida\out\ptr-arrays\state\<tag>_*.
Env H3_TAG names the snapshot."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "ptr-arrays", "state")
os.makedirs(OUT, exist_ok=True)
TAG = os.environ.get("H3_TAG", "seed")
LO, HI = 0x0, 0x7B754


def main():
    ida_auto.auto_wait()
    # functions
    with open(os.path.join(OUT, TAG + "_funcs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tncref\tndref\n")
        for f in idautils.Functions(LO, HI):
            fn = ida_funcs.get_func(f)
            nc = sum(1 for _ in idautils.CodeRefsTo(f, 0))
            nd = sum(1 for _ in idautils.DataRefsTo(f))
            h.write("%06X\t%06X\t%d\t%d\n" % (f, fn.end_ea, nc, nd))
    # byte class map: 0 unk,1 code head,2 code tail,3 data head,4 data tail
    arr = bytearray(HI - LO)
    for ea in range(LO, HI):
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            arr[ea - LO] = 1 if ida_bytes.is_head(fl) else 2
        elif ida_bytes.is_data(fl):
            arr[ea - LO] = 3 if ida_bytes.is_head(fl) else 4
        elif ida_bytes.is_tail(fl):
            arr[ea - LO] = 4
    with open(os.path.join(OUT, TAG + "_bytemap.bin"), "wb") as h:
        h.write(bytes(arr))
    # immediates / addresses in content range used by instructions
    with open(os.path.join(OUT, TAG + "_imm.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("insn\tsize\topn\ttype\tvalue\tdisasm\n")
        ea = LO
        for ea in idautils.Heads(LO, HI):
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                continue
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, ea) <= 0:
                continue
            for i in range(6):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                for v in (op.value, op.addr):
                    v &= 0xFFFFFFFF
                    if 0x400 <= v < HI:
                        h.write("%06X\t%d\t%d\t%d\t%06X\t%s\n" % (ea, insn.size, i, op.type, v,
                                idc.generate_disasm_line(ea, 0)))
                        break


try:
    main()
except Exception:
    with open(os.path.join(OUT, TAG + "_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

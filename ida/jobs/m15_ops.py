r"""Lane M15 -- dump every operand of every code head inside the SUB residue runs (read-only).

    python ida/run_job.py --script ida\jobs\m15_ops.py --db M15_SUB_RESIDUE --reopen
Output: ida\out\sub-residue-final\raw\residue-operands.tsv, raw\ops_status.txt
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-residue-final\raw")
STATUS = os.path.join(OUT, "ops_status.txt")
WLO, WHI = 0xFFED0000, 0xFFF50000


def main():
    import ida_auto, ida_bytes, ida_ua, idc, ida_lines
    ida_auto.auto_wait()
    M = os.path.join(ROOT, r"ida\out\sub-final3\raw\mask_final3_after_%s.bin")
    HW = open(M % "headline_w2", "rb").read(); A = open(M % "allwf", "rb").read()
    res = [WLO + i for i in range(WHI - WLO) if A[i] and not HW[i]]
    rs = set(res)
    n = 0
    with open(os.path.join(OUT, "residue-operands.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tinsn_bytes\topn\toptype\tvalue\taddr\treg\tdtype\tdisasm\n")
        for ea in res:
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                continue
            insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
            d = (idc.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or "").replace("\t", " ")
            for k, op in enumerate(insn.ops):
                if op.type == 0:
                    break
                h.write("%08X\t%s\t%d\t%d\t%08X\t%08X\t%d\t%d\t%s\n" % (ea, (ida_bytes.get_bytes(ea, ln) or b"").hex(), k, op.type,
                        op.value & 0xFFFFFFFF, op.addr & 0xFFFFFFFF, op.reg, op.dtype, d))
                n += 1
    with open(STATUS, "a", encoding="utf-8") as s:
        s.write("operands %d\ndone\n" % n)


try:
    open(STATUS, "w").close()
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

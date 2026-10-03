r"""SUB-LOWER job 2f: corrected reference scan.

Job 2b reported "0 operands resolving into LOWER" across 478 functions. That was
my bug: IDA stores a 32-bit immediate in a 64-bit uval_t, sign-extended, so
0xFFC00100 arrives as 0xFFFFFFFFFFC00100 and failed the range test. Mask to 32
bits and redo.

Also settle, per candidate address, whether the byte offset where a raw scan
found an "FB x2/xE + LOWER address" pattern is a real instruction head.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "refs_error.txt")
LO = 0xFFC00000
HI = 0xFFE80000
M = 0xFFFFFFFF
NOTE = []

O_NEAR = ida_ua.o_near
O_MEM = ida_ua.o_mem
O_IMM = ida_ua.o_imm
O_DISPL = ida_ua.o_displ

TBL_LO, TBL_HI = 0xFFC3DF4D, 0xFFC3E8D4


def esc(t: str) -> str:
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def dis(ea: int) -> str:
    return esc(idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE))


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()

    heads = set()
    rows = []
    kinds = collections.Counter()
    n_insn = 0
    for start in idautils.Functions():
        for ea in idautils.FuncItems(start):
            heads.add(ea)
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, ea) <= 0:
                continue
            n_insn += 1
            mnem = insn.get_canon_mnem()
            for i in range(8):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                if op.type == O_IMM:
                    v, k = op.value & M, "imm"
                elif op.type in (O_MEM, O_NEAR):
                    v, k = op.addr & M, ("branch" if op.type == O_NEAR else "mem")
                elif op.type == O_DISPL:
                    v, k = op.addr & M, "displ"
                else:
                    continue
                if LO <= v < HI:
                    kinds[(k, mnem)] += 1
                    rows.append((ea, start, mnem, k, v, dis(ea)))

    with open(os.path.join(OUT, "real_refs_into_lower.tsv"), "w",
              encoding="utf-8", newline="\n") as fh:
        fh.write("insn_ea\tfunc_ea\tmnem\top_kind\ttarget\tinsn\n")
        for r in sorted(rows):
            fh.write("%08X\t%08X\t%s\t%s\t%08X\t%s\n" % r)

    NOTE.append("REFS: %d instruction heads in %d functions"
                % (n_insn, sum(1 for _ in idautils.Functions())))
    NOTE.append("REFS: operands resolving into LOWER: %d (distinct targets %d)"
                % (len(rows), len({r[4] for r in rows})))
    for (k, m), c in kinds.most_common(20):
        NOTE.append("REFS:   %-7s %-8s %5d" % (k, m, c))
    br = sum(c for (k, _m), c in kinds.items() if k == "branch")
    NOTE.append("REFS: control transfers into LOWER (o_near): %d" % br)

    tg = collections.Counter(r[4] for r in rows)
    NOTE.append("REFS: targets, most referenced first")
    for t, c in tg.most_common(40):
        b = ida_bytes.get_bytes(t, 24) or b""
        NOTE.append("REFS:   %08X x%-4d %s"
                    % (t, c, "".join(chr(x) if 32 <= x < 127 else "." for x in b)))

    lab = [r for r in rows if TBL_LO <= r[4] < TBL_HI]
    NOTE.append("REFS: operands inside the setup-label table %08X-%08X: %d"
                % (TBL_LO, TBL_HI, len(lab)))
    for r in lab:
        NOTE.append("REFS:   %08X in func %08X -> %08X  %s"
                    % (r[0], r[1], r[4], r[5]))

    # per-64K-page: how many real operands land there
    pg = collections.Counter((r[4] - LO) >> 16 for r in rows)
    NOTE.append("REFS: LOWER 64 KB pages referenced by a real operand:")
    for p in sorted(pg):
        NOTE.append("REFS:   %08X  %d" % (LO + (p << 16), pg[p]))
    NOTE.append("REFS: LOWER 64 KB pages with NO real operand reference: %d of 40"
                % (40 - len(pg)))

    # are the raw-scan candidate offsets real instruction heads?
    src = os.path.join(OUT, "ptr_loads_into_lower.tsv")
    cand = []
    if os.path.isfile(src):
        with open(src, encoding="utf-8") as fh:
            next(fh)
            for line in fh:
                p = line.rstrip("\n").split("\t")
                cand.append((int(p[0], 16), int(p[4], 16), int(p[3])))
    real = [c for c in cand if c[0] in heads]
    notreal = [c for c in cand if c[0] not in heads]
    covered = [c for c in notreal if ida_funcs.get_func(c[0]) is not None]
    NOTE.append("CAND: %d raw pointer-load byte patterns; %d are real instruction "
                "heads, %d are not (%d of those fall inside a recovered function, "
                "i.e. mid-instruction coincidences)"
                % (len(cand), len(real), len(notreal), len(covered)))
    with open(os.path.join(OUT, "ptr_loads_verified.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("insn_ea\ttarget\timm_bits\tis_instruction_head\t"
                 "inside_recovered_func\tdisasm\n")
        for ea, tgt, bits in sorted(cand, key=lambda c: c[1]):
            fh.write("%08X\t%08X\t%d\t%s\t%s\t%s\n"
                     % (ea, tgt, bits, "yes" if ea in heads else "no",
                        "yes" if ida_funcs.get_func(ea) else "no", dis(ea)))
    NOTE.append("CAND: verified real pointer loads, by target")
    for ea, tgt, bits in sorted(real, key=lambda c: c[1]):
        NOTE.append("CAND:   %08X -> %08X imm%d  %s" % (ea, tgt, bits, dis(ea)))

    with open(os.path.join(OUT, "refs_notes.txt"), "w", encoding="utf-8",
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

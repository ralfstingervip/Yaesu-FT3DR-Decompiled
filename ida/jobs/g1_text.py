r"""Lane G1 -- read-only: IDA h8sxa text for a list of addresses, as if each held
an instruction (GENDSM_FORCE_CODE), without creating any item.
Input  ida\out\h8s-decode\work\text_in.txt (hex addresses)
Output ida\out\h8s-decode\work\text_out.tsv (ea, decode size, text)
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_lines, ida_ua, idc

ROOT = str(_REPO)
WORK = os.path.join(ROOT, "ida", "out", "h8s-decode", "work")


def main(fh):
    ida_auto.auto_wait()
    insn = ida_ua.insn_t()
    fh.write("ea\tsize\ttext\n")
    for tok in open(os.path.join(WORK, "text_in.txt"), encoding="utf-8").read().split():
        ea = int(tok, 16)
        n = ida_ua.decode_insn(insn, ea)
        t = ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_FORCE_CODE) or "")
        fh.write("%06X\t%d\t%s\n" % (ea, n, t.replace("\t", " ")))


try:
    with open(os.path.join(WORK, "text_out.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        main(fh)
except Exception:
    with open(os.path.join(WORK, "text_err.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

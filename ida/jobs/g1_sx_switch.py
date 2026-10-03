r"""Lane G1 -- switch the PRIVATE G1_H8S database from h8s300a to IDA's own
H8SX advanced variant (h8sxa) and record what the decoder now does.

Creates nothing: only the processor variant changes. Writes, for 0..0x7B753,
ida_decsize_sx.bin (decode_insn size per address) and sx_text.tsv (size + text
for every address where the h8s300a decode was 0 and h8sxa decodes now).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_idp, ida_ua, ida_ida, ida_lines, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8s-decode", "work")
LOG = os.path.join(OUT, "g1_sx_switch.log")
LO, HI = 0, 0x07B754


def main(fh):
    ida_auto.auto_wait()
    fh.write("before procname=%s\n" % ida_ida.inf_get_procname())
    ok = ida_idp.set_processor_type("h8sxa", ida_idp.SETPROC_USER)
    fh.write("set_processor_type(h8sxa) -> %r ; now procname=%s\n" % (ok, ida_ida.inf_get_procname()))
    # The variant switch queues a re-analysis of existing items. Drop every queue
    # so the h8s300a baseline items stay exactly as they were; only g1_absorb.py
    # adds code, and only from the binutils-verified plan.
    fh.write("auto_is_ok before unmark: %r\n" % ida_auto.auto_is_ok())
    for nm in dir(ida_auto):
        if nm.startswith("AU_") and nm != "AU_NONE":
            ida_auto.auto_unmark(0, 0xFFFFFFFF, getattr(ida_auto, nm))
    fh.write("auto_is_ok after unmark: %r\n" % ida_auto.auto_is_ok())
    before = open(os.path.join(OUT, "ida_decsize_before.bin"), "rb").read()
    sizes = bytearray(HI - LO)
    insn = ida_ua.insn_t()
    with open(os.path.join(OUT, "sx_text.tsv"), "w", encoding="utf-8", newline="\n") as tf:
        tf.write("ea\tsize\titype\ttext\n")
        for ea in range(LO, HI):
            n = ida_ua.decode_insn(insn, ea)
            n = n if 0 < n < 256 else 0
            sizes[ea - LO] = n
            if n and (before[ea - LO] == 0 or before[ea - LO] != n):
                # text via a temporary print of the decoded insn (no item created)
                txt = ida_ua.print_insn_mnem(ea) or ""
                ops = []
                for i in range(3):
                    o = ida_ua.print_operand(ea, i)
                    if o:
                        ops.append(ida_lines.tag_remove(o))
                tf.write("%06X\t%d\t%d\t%s %s\n" % (ea, n, insn.itype, txt, ", ".join(ops)))
    with open(os.path.join(OUT, "ida_decsize_sx.bin"), "wb") as bf:
        bf.write(bytes(sizes))
    fh.write("done\n")


try:
    with open(LOG, "w", encoding="utf-8") as fh:
        main(fh)
except Exception:
    with open(LOG, "a", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

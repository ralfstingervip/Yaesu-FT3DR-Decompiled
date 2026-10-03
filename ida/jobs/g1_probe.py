r"""Lane G1 -- probe the h8s300a module: itype table and IDP_Hooks plumbing.
Read-only: decodes only, creates nothing."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_idp, ida_ua, ida_bytes, idc, ida_ida

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8s-decode", "work")
os.makedirs(OUT, exist_ok=True)
LOG = os.path.join(OUT, "g1_probe.txt")


def main(fh):
    ida_auto.auto_wait()
    fh.write("procname=%s\n" % ida_ida.inf_get_procname())
    names = ida_idp.ph_get_instruc()
    fh.write("n_instruc=%d\n" % len(names))
    for i, (nm, feat) in enumerate(names):
        fh.write("%d\t%s\t0x%X\n" % (i, nm, feat))
    ph=ida_idp.get_ph()
    fh.write("psnames=%r plnames=%r\n" % (getattr(ph, "psnames", None), getattr(ph, "plnames", None)))
    fh.write("hooks methods: %s\n" % [m for m in dir(ida_idp.IDP_Hooks) if m.startswith("ev_")])
    fh.write("outctx methods: %s\n" % [m for m in dir(ida_ua.outctx_t) if not m.startswith("_")])
    insn = ida_ua.insn_t()
    for ea in (0x0562C8, 0x0481C, 0x0481E, 0x076BFA, 0x075FC4, 0x2092):
        n = ida_ua.decode_insn(insn, ea)
        fh.write("%06X size=%d itype=%d auxpref=0x%X segpref=%d insnpref=%d ops=%s\n" % (
            ea, n, insn.itype, insn.auxpref, insn.segpref, insn.insnpref,
            [(o.type, o.dtype, o.reg, hex(o.addr), hex(o.value), o.phrase, o.specflag1, o.specflag2) for o in [insn.ops[0],insn.ops[1],insn.ops[2]]]))
        fh.write("   line: %s\n" % idc.generate_disasm_line(ea, 0))
    # sample decode of known instructions for itype / auxpref conventions
    for ea in (0x2092, 0x04824, 0x04826, 0x0481A):
        n = ida_ua.decode_insn(insn, ea)
        fh.write("%06X size=%d itype=%d auxpref=0x%X ops=%s | %s\n" % (
            ea, n, insn.itype, insn.auxpref,
            [(o.type, o.dtype, o.reg, hex(o.addr), hex(o.value), o.phrase, o.specflag1) for o in [insn.ops[0],insn.ops[1],insn.ops[2]]],
            idc.generate_disasm_line(ea, 0)))


try:
    with open(LOG, "w", encoding="utf-8") as fh:
        main(fh)
except Exception:
    with open(LOG, "a", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

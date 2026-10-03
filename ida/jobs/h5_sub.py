# -*- coding: utf-8 -*-
"""Lane H5 (IPC reachability) - SUB side probe. Private DB H5_SUB only.

Dumps the IPC frame processor / classifier chain, the F1 jump table bytes,
and every instruction anywhere in the SUB image whose operand equals one of
the pending-buffer / mirror addresses or one of the opcodes of interest.
Read-only with respect to the firmware image; creates instructions only in
the private database.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_xref, idc, idautils

ROOT = str(_REPO)
OUTD = os.path.join(ROOT, "ida", "out", "ipc-reach")
BASE = 0xFFC00000
END = 0xFFFFFFFF

RANGES = [
    (0xFFEDF016, 0xFFEDF1D8, "frame processor sub_FFEDF016"),
    (0xFFEDF1D8, 0xFFEDF269, "top-level family classifier sub_FFEDF1D8"),
    (0xFFEDF269, 0xFFEDF2E0, "F0 classifier sub_FFEDF269"),
    (0xFFEDF2E0, 0xFFEDF36A, "F1 classifier sub_FFEDF2E0"),
    (0xFFEDF36A, 0xFFEDF3A7, "F2 classifier"),
    (0xFFEDF3A7, 0xFFEDF447, "F3/F4 classifier"),
    (0xFFEDF645, 0xFFEDF680, "FE/FF classifier"),
    (0xFFEDC1F6, 0xFFEDC2A0, "dequeue sub_FFEDC1F6"),
]

ADDRS = [0x8E46, 0x8E47, 0x8E48, 0x8E49, 0x84C8, 0x84C9]
OPS = [0xF102, 0xF003, 0xF00A, 0xF109, 0xF10A, 0xF10D, 0xF10F, 0xF113, 0xF115,
       0xF400, 0xF401, 0xF402, 0xF404, 0xF501, 0xF503, 0xF703, 0xF801, 0xFF01,
       0xFFFE, 0xF3D6, 0xF3D5, 0xFE00, 0xFC00]


def dis_range(h, s, e):
    a = s
    while a < e:
        if not ida_bytes.is_code(ida_bytes.get_flags(a)):
            ida_ua.create_insn(a)
        insn = ida_ua.insn_t()
        n = ida_ua.decode_insn(insn, a)
        if n <= 0:
            h.write("  %08X  %s  ??\n" % (a, ida_bytes.get_bytes(a, 1).hex()))
            a += 1
            continue
        b = ida_bytes.get_bytes(a, n).hex(" ")
        h.write("  %08X  %-24s %s\n" % (a, b, idc.generate_disasm_line(a, 0) or "?"))
        a += n


def opvals(insn):
    vals = []
    for op in insn.ops:
        if op.type == 0:
            break
        vals.append((op.type, op.value & 0xFFFFFFFF, op.addr & 0xFFFFFFFF))
    return vals


def scan_values(h, targets, label):
    data = ida_bytes.get_bytes(BASE, 0x400000)
    pats = {}
    for t in targets:
        lo = t & 0xFFFF
        pats[lo.to_bytes(2, "little")] = t
        pats[lo.to_bytes(2, "big")] = t
    seen = set()
    h.write("\n==== value scan: %s ====\n" % label)
    for pat, t in pats.items():
        i = data.find(pat)
        while i >= 0:
            for back in range(1, 7):
                ea = BASE + i - back
                if ea in seen:
                    continue
                insn = ida_ua.insn_t()
                n = ida_ua.decode_insn(insn, ea)
                if n <= 0 or ea + n < BASE + i + 2:
                    continue
                hit = None
                for ty, v, ad in opvals(insn):
                    for x in (v, ad):
                        for tt in targets:
                            if x in (tt, tt & 0xFFFF, int.from_bytes((tt & 0xFFFF).to_bytes(2, "big"), "little")):
                                hit = tt
                if hit is None:
                    continue
                seen.add(ea)
                fl = ida_bytes.get_flags(ea)
                f = ida_funcs.get_func(ea)
                state = "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else "unk")
                h.write("%08X\t%04X\t%s\t%s\t%s\t%s\n" % (
                    ea, hit, state, ("%08X" % f.start_ea) if f else "-",
                    ida_bytes.get_bytes(ea, n).hex(" "),
                    insn.get_canon_mnem() + " " + ",".join("t%d:v%X:a%X" % o for o in opvals(insn))))
            i = data.find(pat, i + 1)


def main():
    ida_auto.auto_wait()
    os.makedirs(OUTD, exist_ok=True)
    with open(os.path.join(OUTD, "sub_probe.txt"), "w", encoding="utf-8", newline="\n") as h:
        for s, e, name in RANGES:
            h.write("\n==== %08X-%08X %s ====\n" % (s, e, name))
            dis_range(h, s, e)
        h.write("\n==== F1 jump table bytes FFF47FED (22 x 1) ====\n")
        h.write(ida_bytes.get_bytes(0xFFF47FED, 22).hex(" ") + "\n")
        h.write("\n==== top jump table bytes FFF47FD1 (16 x 1) ====\n")
        h.write(ida_bytes.get_bytes(0xFFF47FD1, 16).hex(" ") + "\n")
        for tgt in (0xFFEDF1D8, 0xFFEDF016, 0xFFEDF2E0):
            h.write("\n==== code xrefs to %08X ====\n" % tgt)
            for x in idautils.XrefsTo(tgt, 0):
                f = ida_funcs.get_func(x.frm)
                h.write("  from %08X type %d func %s\n" % (x.frm, x.type, ("%08X" % f.start_ea) if f else "-"))
        h.write("\n#ea\ttarget\tstate\tfunc\tbytes\tdecode\n")
        scan_values(h, ADDRS, "pending buffer 0x8E46.. and mirror 0x84C8/9")
        scan_values(h, OPS, "opcode immediates")
    ida_auto.auto_wait()


try:
    main()
except Exception:
    with open(os.path.join(OUTD, "h5_sub_tb.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

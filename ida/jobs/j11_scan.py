r"""Lane J11 -- find immediate/xref readers of remaining tables; peripheral check in consumers."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUTDIR = os.path.join(ROOT, r"ida\out\sub-icon-glyph\raw")
OUT = os.path.join(OUTDIR, "scan.txt")

# tables to find references to (any immediate in range)
RANGES = [
    ("glyph1_desc", 0xFFED477C, 0xFFED49E0),
    ("descptr_55d4", 0xFFED55D4, 0xFFED55E0),
    ("icon_rec", 0xFFED55E0, 0xFFED71A8),
    ("store_7f18", 0xFFED7F18, 0xFFED819C),
    ("font1_blk", 0xFFED4644, 0xFFED477C),
    ("glyph_tbl8", 0xFFED49E0, 0xFFED4B48),
]

# consumer functions to scan for peripheral immediates
CONSUMERS = [0xFFEF34B1, 0xFFEE59A4, 0xFFEF2184, 0xFFEE5269, 0xFFF34897,
             0xFFF362EF, 0xFFEF2505, 0xFFF3466C, 0xFFF35347, 0xFFF35683, 0xFFF369F2]

# peripheral windows (file-relative RX I/O 0x80000-0xFFFFF, plus USB0/USBA/FCU)
def periph_hit(v):
    if 0x00080000 <= v <= 0x000FFFFF: return "IO"
    if 0x000A0000 <= v <= 0x000A0400: return "USB0"
    if 0x000D0000 <= v <= 0x000D0200: return "USBA"
    if 0x007E0000 <= v <= 0x00800000: return "FCU"
    return None


def main():
    import ida_auto, ida_bytes, idc, idautils, ida_funcs, ida_ua
    ida_auto.auto_wait()
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        # 1. references into table ranges: scan all instruction operands with o_imm
        h.write("#### table references (o_imm into range)\n")
        hits = {name: [] for name, a, b in RANGES}
        for fea in idautils.Functions():
            for ea in idautils.FuncItems(fea):
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea) <= 0:
                    continue
                for op in insn.ops:
                    if op.type == 0:  # o_void
                        break
                    val = None
                    if op.type == ida_ua.o_imm:
                        val = op.value & 0xFFFFFFFF
                    if val is None:
                        continue
                    for name, a, b in RANGES:
                        if a <= val < b:
                            hits[name].append((ea, fea, val))
        for name, a, b in RANGES:
            h.write("-- %s (%08X-%08X): %d hits\n" % (name, a, b, len(hits[name])))
            for ea, fea, val in hits[name][:30]:
                h.write("   %08X in %s -> %08X\n" % (ea, idc.get_func_name(fea) or "", val))

        # 2. peripheral immediates inside consumer functions
        h.write("\n#### peripheral immediates in consumer functions\n")
        for fa in CONSUMERS:
            f = ida_funcs.get_func(fa)
            if not f:
                h.write("  no func %08X\n" % fa); continue
            found = []
            for ea in idautils.FuncItems(fa):
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea) <= 0:
                    continue
                for op in insn.ops:
                    if op.type == 0:
                        break
                    if op.type == ida_ua.o_imm:
                        tag = periph_hit(op.value & 0xFFFFFFFF)
                        if tag:
                            found.append((ea, tag, op.value & 0xFFFFFFFF))
            h.write("  %08X %-18s : %s\n" % (fa, idc.get_func_name(fa) or "",
                     ("none" if not found else ", ".join("%s@%08X=%X" % (t, e, v) for e, t, v in found))))
        h.write("\ndone\n")


try:
    main()
except Exception:
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

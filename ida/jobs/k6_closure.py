r"""Lane K6 -- forward call closure of the SD/MMC driver, plus reverse callers of its entry points.

Writes ida\out\sub-sdmmc\raw\closure.tsv (function, depth, via) and callers.tsv.
Indirect edges through the vtable FFED7EB0 (26 slots) are added explicitly, since IDA
records them only as data refs.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-sdmmc\raw")
STATUS = os.path.join(OUT, "closure_status.txt")

ROOTS = [0xFFF32C56, 0xFFF33AE7, 0xFFF32CA7, 0xFFF32C99, 0xFFF32DFB, 0xFFF35844,
         0xFFF368FF, 0xFFF369F2, 0xFFF36999]
VT, NSLOT = 0xFFED7EB0, 26


def main():
    import ida_auto, ida_funcs, ida_bytes, idautils, idc, ida_ua
    ida_auto.auto_wait()
    slots = [ida_bytes.get_dword(VT + 4 * i) for i in range(NSLOT)]
    seen = {}
    work = [(r, 0, "root") for r in ROOTS] + [(s, 1, "vtable+%02X" % (4 * i)) for i, s in enumerate(slots)]
    while work:
        ea, dep, via = work.pop(0)
        f = ida_funcs.get_func(ea)
        if not f:
            seen.setdefault(ea, (dep, via + " (nofunc)"))
            continue
        if f.start_ea in seen:
            continue
        seen[f.start_ea] = (dep, via)
        for it in idautils.FuncItems(f.start_ea):
            for x in idautils.CodeRefsFrom(it, 0):
                g = ida_funcs.get_func(x)
                if g and g.start_ea != f.start_ea and g.start_ea not in seen:
                    work.append((g.start_ea, dep + 1, "%08X" % it))
            # immediate function pointers (e.g. mov.l #sub_xxx, r3)
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, it):
                for n in range(6):
                    op = insn.ops[n]
                    if op.type == 0:
                        break
                    if op.type == 5:
                        v = op.value & 0xFFFFFFFF
                        g = ida_funcs.get_func(v)
                        if g and g.start_ea == v and v not in seen:
                            work.append((v, dep + 1, "imm@%08X" % it))
    with open(os.path.join(OUT, "closure.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("func\tend\tdepth\tvia\tname\n")
        for ea in sorted(seen):
            f = ida_funcs.get_func(ea)
            h.write("%08X\t%08X\t%d\t%s\t%s\n" % (ea, f.end_ea if f else ea, seen[ea][0], seen[ea][1],
                                                  idc.get_func_name(ea) or ""))
    # reverse: who calls the driver-facing entry points (FAT / app side)
    with open(os.path.join(OUT, "callers.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("callee\tcaller_ea\tcaller_func\n")
        for c in [0xFFF33AE7, 0xFFF12A75, 0xFFF35844, 0xFFF369F2, 0xFFF36999, 0xFFF368FF,
                  0xFFF32ABB, 0xFFF32BA2, 0xFFF33C41, 0xFFF353CE, 0xFFF35454, 0xFFF3539A,
                  0xFFF35347, 0xFFF3466C, 0xFFF354F0, 0xFFF354FE, 0xFFF3556B, 0xFFF355D8,
                  0xFFF35805, 0xFFF3591F, 0xFFF35948]:
            for x in idautils.XrefsTo(c, 0):
                h.write("%08X\t%08X\t%s\n" % (c, x.frm, idc.get_func_name(x.frm) or ""))
    with open(STATUS, "w", encoding="utf-8") as h:
        h.write("closure %d\n" % len(seen))


try:
    main()
except Exception:
    with open(STATUS, "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    import idc as _i
    _i.qexit(0)

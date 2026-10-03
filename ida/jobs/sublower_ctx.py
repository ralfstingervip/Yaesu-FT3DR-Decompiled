r"""SUB-LOWER job 2g: context for the pixel-region operand references.

Job 2f found 89 real operands into LOWER. Most go to the const/string clusters,
but ~28 name addresses inside the RGB565 pixel region (FFD0FF00, FFDA0000..
FFDA0800, FFDB0300, FFDC0000/0100/FF00/FF01, FFDAFE00, FFD8FF01, FFD9FF01).
Dump the enclosing code so it is clear whether those are dereferenced as
pointers or consumed as numeric constants.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "ctx_error.txt")
SITES = (0xFFC00900, 0xFFD0FF00, 0xFFDA0000, 0xFFDA0800, 0xFFDB0300,
         0xFFDC0000, 0xFFDCFF00, 0xFFDCFF01, 0xFFDAFE00, 0xFFD8FF01)
NOTE = []


def esc(t: str) -> str:
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def dis(ea: int) -> str:
    return esc(idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE))


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    src = os.path.join(OUT, "real_refs_into_lower.tsv")
    rows = []
    with open(src, encoding="utf-8") as fh:
        next(fh)
        for line in fh:
            p = line.rstrip("\n").split("\t")
            rows.append((int(p[0], 16), int(p[1], 16), p[2], p[3], int(p[4], 16)))

    want = [r for r in rows if r[4] >= 0xFFC40000 or r[4] == 0xFFC00900]
    NOTE.append("CTX: %d references to dump" % len(want))
    with open(os.path.join(OUT, "pixel_ref_context.txt"), "w", encoding="utf-8",
              newline="\n") as fh:
        seen = set()
        for ins_ea, func_ea, mnem, kind, tgt in sorted(want):
            key = (func_ea, ins_ea // 0x40)
            if key in seen:
                continue
            seen.add(key)
            fh.write("\n=== ref %08X -> %08X  (%s %s) in function %08X ===\n"
                     % (ins_ea, tgt, mnem, kind, func_ea))
            lo = max(func_ea, ins_ea - 0x28)
            f = ida_funcs.get_func(func_ea)
            hi = min(f.end_ea if f else ins_ea + 0x40, ins_ea + 0x40)
            ea = lo
            insn = ida_ua.insn_t()
            while ea < hi:
                ln = ida_ua.decode_insn(insn, ea)
                if ln <= 0:
                    fh.write("%08X  %-16s (no decode)\n"
                             % (ea, (ida_bytes.get_bytes(ea, 1) or b"").hex()))
                    ea += 1
                    continue
                fh.write("%08X  %-16s %-40s%s\n"
                         % (ea, (ida_bytes.get_bytes(ea, ln) or b"").hex(),
                            dis(ea), "   <<<" if ea == ins_ea else ""))
                ea += ln
        fh.write("\n\n=== bytes at each referenced pixel-region address ===\n")
        for t in SITES:
            b = ida_bytes.get_bytes(t, 32) or b""
            fh.write("%08X  %s\n" % (t, b.hex(" ")))
    NOTE.append("CTX: wrote pixel_ref_context.txt")
    with open(os.path.join(OUT, "ctx_notes.txt"), "w", encoding="utf-8",
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

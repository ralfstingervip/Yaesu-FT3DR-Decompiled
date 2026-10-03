r"""Lane F4 context pass: the lane-4 start FFF40C3E is mid-instruction (tail of
C5FE6E6E @ FFF40C3C). Find the real function start/end that encloses FFF40C10,
its callers, and give a clean linear disassembly of the enclosing region.
Reopen-only."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

OUT = str(_REPO / "ida/out/sub-big2")


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def main():
    import ida_funcs, ida_bytes, idc, ida_xref, ida_ua, idautils, ida_auto
    ida_auto.auto_wait()
    with open(os.path.join(OUT, "ctx_a.txt"), "w", encoding="utf-8", newline="\n") as h:
        # get_func across a grid
        h.write("== get_func grid ==\n")
        for ea in (0xFFF40A00, 0xFFF40B00, 0xFFF40BE0, 0xFFF40BFF, 0xFFF40C00,
                   0xFFF40C10, 0xFFF40C3C, 0xFFF40C3E, 0xFFF41000, 0xFFF410EB,
                   0xFFF410ED, 0xFFF410F0, 0xFFF41100):
            f = ida_funcs.get_func(ea)
            if f:
                h.write("  %08X -> func %08X..%08X %s\n" % (ea, f.start_ea, f.end_ea, idc.get_func_name(f.start_ea) or ""))
            else:
                h.write("  %08X -> (no func)\n" % ea)

        # xrefs to candidate entry points
        h.write("\n== xrefs to candidate entries ==\n")
        for ea in (0xFFF40BFF, 0xFFF40C08, 0xFFF40C10, 0xFFF40C3E, 0xFFF40B00,
                   0xFFF40B80, 0xFFF40BC0):
            refs = []
            xr = ida_xref.xrefblk_t()
            ok = xr.first_to(ea, ida_xref.XREF_ALL)
            while ok:
                refs.append((xr.frm, xr.iscode, xr.type))
                ok = xr.next_to()
            h.write("  -> %08X: %s\n" % (ea, ", ".join("%08X(c%d,t%d)" % (f, c, t) for f, c, t in refs)))

        # linear disassembly across the whole region, honoring code heads
        h.write("\n== linear FFF40A80..FFF41120 ==\n")
        a = 0xFFF40A80
        end = 0xFFF41120
        insn = ida_ua.insn_t()
        while a < end and a != idc.BADADDR:
            fl = ida_bytes.get_flags(a)
            size = idc.get_item_size(a)
            raw = (ida_bytes.get_bytes(a, min(size, 10)) or b"").hex()
            mnem = idc.print_insn_mnem(a) or ""
            line = esc(idc.generate_disasm_line(a, 0))
            tag = "C" if ida_bytes.is_code(fl) else ("D" if ida_bytes.is_data(fl) else "U")
            # mark function starts
            f = ida_funcs.get_func(a)
            fs = "  <FUNC_START %s>" % (idc.get_func_name(a) or "") if (f and f.start_ea == a) else ""
            h.write("  %08X [%s] %-18s %s%s\n" % (a, tag, raw, line, fs))
            nxt = idc.next_head(a, end)
            if nxt <= a:
                a += 1
            else:
                a = nxt

    with open(os.path.join(OUT, "ctx_status.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ctx ok\n")


if True:
    os.makedirs(OUT, exist_ok=True)
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "ctx_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc
    _idc.qexit(0)

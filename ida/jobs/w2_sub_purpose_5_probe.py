from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/wave2")
P = os.path.join(OUT, "w2_subp5_probe.txt")

def main():
    import ida_bytes, ida_funcs, idc, ida_ua
    targets = [0xFFF2FBFD, 0xFFF30662, 0xFFF2FBED, 0xFFF3098F, 0xFFF30A37, 0xFFF2FE94]
    with open(P, "w", encoding="utf-8", newline="\n") as h:
        for t in targets:
            f = ida_funcs.get_func(t)
            h.write("\n===== %08X =====\n" % t)
            if f is None:
                h.write("  no func\n"); continue
            h.write("  start %08X end %08X size %d\n" % (f.start_ea, f.end_ea, f.end_ea - f.start_ea))
            # dump last 8 heads
            heads = []
            ea = f.start_ea
            while ea != idc.BADADDR and ea < f.end_ea:
                heads.append(ea)
                ea = idc.next_head(ea, f.end_ea)
            h.write("  n_heads=%d\n" % len(heads))
            for ea in heads[:4] + heads[-8:]:
                fl = ida_bytes.get_flags(ea)
                iscode = ida_bytes.is_code(fl)
                mn = idc.print_insn_mnem(ea) or ""
                line = idc.generate_disasm_line(ea, 0) or ""
                h.write("   %08X code=%s mnem=%r | %s\n" % (ea, iscode, mn, line))

if True:
    import ida_auto
    try:
        ida_auto.auto_wait(); main()
    except Exception:
        with open(os.path.join(OUT, "w2_subp5_probe_tb.txt"), "w", encoding="utf-8") as h:
            h.write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-layout")
RANGES = [(0xFFEFA82D, 0xFFEFAA60), (0xFFF03CA0, 0xFFF03D80)]
def esc(t): return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")
def main():
    import ida_bytes, idc, ida_ua, ida_auto
    ida_auto.auto_wait()
    with open(os.path.join(OUT, "linear.txt"), "w", encoding="utf-8", newline="\n") as h:
        for lo, hi in RANGES:
            h.write("==== linear %08X-%08X ====\n" % (lo, hi))
            a = lo
            while a < hi:
                sz = idc.get_item_size(a)
                if sz <= 0:
                    sz = ida_ua.create_insn(a) or 1
                raw = (ida_bytes.get_bytes(a, min(sz, 8)) or b"").hex()
                h.write("  %08X  %-16s %s\n" % (a, raw, esc(idc.generate_disasm_line(a, 0))))
                a += max(sz, 1)
            h.write("\n")
if True:
    os.makedirs(OUT, exist_ok=True)
    try: main()
    except Exception:
        with open(os.path.join(OUT, "lin_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)

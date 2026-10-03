from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc

OUT = str(_REPO / "ida/out/fnindex")
TARGETS = [0x1079E, 0x15206, 0x1522E, 0x15260, 0x28F4, 0x2853E, 0x28562, 0x325A]

def dis_func(a, h):
    f = ida_funcs.get_func(a)
    if f is None:
        h.write("; no func at %08X\n\n" % a); return
    h.write("; ==== sub_%X  %08X-%08X (%d bytes) ====\n" % (a, f.start_ea, f.end_ea, f.end_ea-f.start_ea))
    ea = f.start_ea
    while ea < f.end_ea:
        raw = ida_bytes.get_bytes(ea, min(6, ida_bytes.get_item_end(ea)-ea)) or b""
        h.write("%08X  %-12s  %s\n" % (ea, raw.hex(), idc.generate_disasm_line(ea, 0) or ""))
        ea = max(ea+1, ida_bytes.get_item_end(ea))
    h.write("\n")

def main():
    ida_auto.auto_wait()
    with open(os.path.join(OUT, "hivalue_disasm.txt"), "w", encoding="utf-8", newline="\n") as h:
        for t in TARGETS:
            dis_func(t, h)
    # image-wide callers of the EEPROM driver
    with open(os.path.join(OUT, "eeprom_callers.txt"), "w", encoding="utf-8", newline="\n") as h:
        for drv in (0x334CA, 0x33532):
            h.write("; callers of sub_%X:\n" % drv)
            for xr in idautils.XrefsTo(drv, 0):
                fn = ida_funcs.get_func(xr.frm)
                h.write("  from %08X  in %s\n" % (xr.frm, idc.get_func_name(fn.start_ea) if fn else "?"))
            h.write("\n")

try:
    main()
except Exception:
    with open(os.path.join(OUT, "dump_err.txt"), "w") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

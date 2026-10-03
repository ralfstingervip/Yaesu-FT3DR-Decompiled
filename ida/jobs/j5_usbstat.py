r"""Lane J5: USB vendor status byte 0 (FF8184) + state machine 0x039080. Read-only.

MAIN, H8SX, base 0, big-endian. Never decodes inside the closed window 0x078106-0x07B753.
No edits, no auto analysis. Dumps fixed ranges, function bounds, and an xref census for
the status RAM cells and the audio/TX state-machine inputs.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, ida_name, idautils, idc, ida_segment

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "usb-status0", "work")
WLO, WHI = 0x078106, 0x07B754

RANGES = [
    ("sm_core", 0x039080, 0x0394D0),
    ("sm_pre",  0x038F80, 0x039080),
    ("sm_post", 0x0394D0, 0x039560),
    ("ep3_6",   0x0551F0, 0x055260),
    ("ep3_710", 0x055320, 0x055380),
    ("ep3_sub", 0x0557A2, 0x055814),
    ("init_c",  0x054C50, 0x054C70),
]
# RAM cells / ports whose every xref we want
XREF = [0xFF8184, 0xFF8183, 0xFF8185, 0xFF8186, 0xFF8187, 0xFF8180,
        0xFFA9E3, 0xFFA9E5, 0xFFA9AD, 0xFFA9AC, 0xFF89C5, 0xFFFF59,
        0xFF89C1, 0xFF89C6]

def esc(t): return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")

def line(ea):
    return esc(ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or "?"))

def dump(name, lo, hi):
    rows = []
    ea = lo
    while ea < hi:
        if WLO <= ea < WHI:
            rows.append("-- closed window skipped --"); ea = WHI; continue
        fl = ida_bytes.get_flags(ea)
        sz = max(1, idc.get_item_size(ea))
        if not ida_bytes.is_code(fl): sz = min(sz, 16)
        raw = ida_bytes.get_bytes(ea, min(sz, 16)) or b""
        fn = ida_funcs.get_func(ea)
        head = ""
        if fn and fn.start_ea == ea:
            head = "\n;---- func %#x..%#x  %s\n" % (fn.start_ea, fn.end_ea, ida_name.get_name(fn.start_ea) or "")
        xr = ["%x" % x.frm for x in idautils.XrefsTo(ea, 0) if x.type != 21]
        c = "C" if ida_bytes.is_code(fl) else "d"
        rows.append("%s%06x %s %-26s %-46s %s" % (head, ea, c, raw.hex(" "), line(ea), ("<- " + ",".join(xr[:14])) if xr else ""))
        ea += sz
    with open(os.path.join(OUT, name + ".txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")

def main():
    os.makedirs(OUT, exist_ok=True)
    log = []
    for name, lo, hi in RANGES:
        dump(name, lo, hi); log.append("dump %s %x-%x" % (name, lo, hi))
    # function bounds + callers around the state machine
    rows = []
    for f in idautils.Functions(0x038F00, 0x039700):
        fn = ida_funcs.get_func(f)
        callers = sorted(set(idautils.CodeRefsTo(f, 0)))
        rows.append("%06x\t%06x\t%d\t%s\t%s" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea,
                    ida_name.get_name(fn.start_ea) or "", ",".join("%x" % c for c in callers[:24])))
    with open(os.path.join(OUT, "funcs.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")
    # xref census
    rows = []
    for ea in XREF:
        n = 0
        for x in idautils.XrefsTo(ea, 0):
            fn = ida_funcs.get_func(x.frm)
            rows.append("%06x\t%06x\t%s\t%d\t%s" % (ea, x.frm, ("%x" % fn.start_ea) if fn else "-", x.type, line(x.frm)))
            n += 1
        if n == 0: rows.append("%06x\t-\t-\t-\t(no xref)" % ea)
    with open(os.path.join(OUT, "xrefs.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")
    with open(os.path.join(OUT, "log.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(log) + "\n")

try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

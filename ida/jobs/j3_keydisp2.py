r"""Lane J3 second pass -- confirm event->index lookup tables, the none-handler,
and screen/caller context for the 0x028CBC key-dispatch family. Read-only, DB J3_KEYDISP.
Outputs ida\out\key-dispatch\work\: disasm2.txt, context.tsv, luts.txt
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, idc, idautils, ida_lines, ida_name

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "key-dispatch", "work")
XT = {0: "Data_Unknown", 1: "dr_O", 2: "dr_W", 3: "dr_R", 4: "dr_T", 5: "dr_I",
      16: "fl_CF", 17: "fl_CN", 18: "fl_JF", 19: "fl_JN", 21: "fl_F"}

RANGES = [
    (0x03FF9C, 0x03FFC0, "none_handler_3FFA0"),
    (0x026500, 0x026584, "event_dispatcher_head"),
]

# event->index lookup tables fed to sub_26F08 (10-byte records: lo32, hi32, val16). Parse offline-style.
LUTS = [0x028452, 0x02839A, 0x02843C, 0x02706C, 0x02704C, 0x027096, 0x0271E6, 0x027274, 0x0270CA]

# functions to get xrefs/names for (callers of the 8 record entries, and shared helpers)
CTX = [0x029C38, 0x02B502, 0x0289BC, 0x02A8C6, 0x02A95A, 0x02A99E, 0x029406,
       0x075F36, 0x076080, 0x02A0F6, 0x018894, 0x018AA6, 0x03FFA0,
       0x015ED0, 0x015E30]


def kind(ea):
    fl = ida_bytes.get_flags(ea)
    return "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else ("tail" if ida_bytes.is_tail(fl) else "unk"))


def line(ea):
    return ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")


def main():
    ida_auto.auto_wait()
    out = []
    for s, e, lab in RANGES:
        ea = s
        while ea < e:
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                ida_ua.create_insn(ea)
            ea += max(1, ida_bytes.get_item_size(ea))
    ida_auto.auto_wait()
    for s, e, lab in RANGES:
        out.append("\n==== %s %06X..%06X ====" % (lab, s, e))
        ea = s
        while ea < e:
            sz = max(1, ida_bytes.get_item_size(ea))
            raw = " ".join("%02x" % b for b in ida_bytes.get_bytes(ea, min(sz, 10)))
            out.append("%06X %-5s %-22s | %s" % (ea, kind(ea), raw, line(ea)))
            ea += sz
    with open(os.path.join(W, "disasm2.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(out) + "\n")

    # parse lookup tables: first word = count, then count * 10-byte records
    lt = ["# event->0xFFBBC2 index LUTs. hdr=count, each rec: lo32 hi32 val16"]
    for base in LUTS:
        cnt = ida_bytes.get_word(base)
        lt.append("\nLUT @%06X count=%d" % (base, cnt))
        p = base + 2
        for i in range(min(cnt, 40)):
            lo = ida_bytes.get_dword(p)
            hi = ida_bytes.get_dword(p + 4)
            val = ida_bytes.get_word(p + 8)
            lt.append("  rec%-2d lo=%08X hi=%08X idx=%d" % (i, lo, hi, val))
            p += 10
    with open(os.path.join(W, "luts.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lt) + "\n")

    rows = ["addr\tname\txrefs_to(frm:type:func)"]
    for a in CTX:
        xr = []
        for x in idautils.XrefsTo(a, 0):
            fn = ida_funcs.get_func(x.frm)
            xr.append("%06X:%s:%s" % (x.frm, XT.get(x.type, str(x.type)),
                      ida_funcs.get_func_name(fn.start_ea) if fn else "-"))
        rows.append("%06X\t%s\t%s" % (a, ida_name.get_name(a) or "-", ",".join(xr) or "-"))
    with open(os.path.join(W, "context.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(rows) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "j3_error2.txt"), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)

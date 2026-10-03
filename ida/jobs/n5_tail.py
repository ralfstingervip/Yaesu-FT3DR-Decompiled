r"""N5 lane: edge analysis of the 52 B tail 0x0771AE-0x0771E1 (MAIN, H8SX, BE, base 0).
Owner-side static read of the seed DB. Nothing written to a radio.

Writes ida/out/tail-52/n5_ida.txt
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc, ida_idaapi

OUT = str(_REPO / "ida/out/tail-52/n5_ida.txt")
LO, HI = 0x0771AE, 0x0771E1  # inclusive

def dis(ea):
    return idc.generate_disasm_line(ea, 0) or ""

def itembytes(ea):
    sz = ida_bytes.get_item_size(ea)
    b = ida_bytes.get_bytes(ea, sz) or b""
    return sz, " ".join("%02x" % x for x in b)

lines = []
try:
    ida_auto.auto_wait()

    # 1. Function(s) covering the entry and the tail
    for probe in (0x07711E, 0x0771AE, 0x0771E2):
        f = ida_funcs.get_func(probe)
        if f:
            lines.append("; probe %06X in func %s [%06X-%06X]" %
                         (probe, ida_funcs.get_func_name(f.start_ea), f.start_ea, f.end_ea))
        else:
            lines.append("; probe %06X: NO function" % probe)
    lines.append("")

    # 2. Linear decode of the whole region with per-head bytes
    lines.append("; ==== linear decode 0x077100 .. 0x0771F0 ====")
    ea = 0x077100
    while ea < 0x0771F2 and ea != ida_idaapi.BADADDR:
        sz, hx = itembytes(ea)
        head = "H" if ea == ida_bytes.get_item_head(ea) else "-"
        isc = "C" if ida_bytes.is_code(ida_bytes.get_full_flags(ea)) else "d"
        mark = " <== TAIL" if LO <= ea <= HI else ""
        lines.append("%06X %s%s %-14s %s%s" % (ea, head, isc, hx, dis(ea), mark))
        nxt = ida_bytes.next_head(ea, 0x077300)
        ea = nxt if nxt != ida_idaapi.BADADDR and nxt > ea else ea + 1
    lines.append("")

    # 3. Are the three conservative-scan candidate sources real instruction heads?
    lines.append("; ==== candidate rel8 source offsets (from byte-sweep) ====")
    for c in (0x077142, 0x077158, 0x077161):
        ih = ida_bytes.get_item_head(c)
        isc = ida_bytes.is_code(ida_bytes.get_full_flags(c))
        sz, hx = itembytes(ih)
        lines.append("%06X: item_head=%06X code=%s  owning_insn[%06X sz=%d]=%s | %s" %
                     (c, ih, bool(isc), ih, sz, hx, dis(ih)))
        lines.append("           is this offset a head? %s" % (ida_bytes.get_item_head(c) == c))
    lines.append("")

    # 4. All xrefs TO every address in the tail range
    lines.append("; ==== XrefsTo for every address in 0x%06X..0x%06X ====" % (LO, HI))
    anyxref = False
    for ea in range(LO, HI+1):
        for xr in idautils.XrefsTo(ea, 0):
            anyxref = True
            frm = xr.frm
            ff = ida_funcs.get_func(frm)
            fn = ida_funcs.get_func_name(ff.start_ea) if ff else "?"
            lines.append("  TO %06X  from %06X (%s) type=%d  %s" %
                         (ea, frm, fn, xr.type, dis(frm)))
    if not anyxref:
        lines.append("  (no xrefs of any kind into the range)")
    lines.append("")

    # 5. CodeRefsTo / DataRefsTo summary for the entry of the block specifically
    lines.append("; ==== refs to block entry 0x0771AE ====")
    cr = list(idautils.CodeRefsTo(0x0771AE, 1))
    dr = list(idautils.DataRefsTo(0x0771AE))
    lines.append("  CodeRefsTo(flow=1): %s" % [ "%06X"%x for x in cr])
    lines.append("  DataRefsTo:         %s" % [ "%06X"%x for x in dr])

except Exception:
    lines.append("EXC:" "\n" + traceback.format_exc())
    with open(str(_REPO / "ida/out/tail-52/n5_traceback.txt"),"w",encoding="utf-8") as f:
        f.write(traceback.format_exc())

with open(OUT, "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")
idc.qexit(0)

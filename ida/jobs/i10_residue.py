import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
# I10 residue lane: confirm past-window (Target C) function boundaries + callers,
# below-window region typing, and peripheral touches across the full past-window body.
# Read-only query against I10_SUB (seeded from H10_SUB). Owner-side static analysis.
import traceback
OUT = str(_REPO / "ida/out/sub-residue")
LOG = str(_REPO / "ida/log/jobs/I10_SUB")
import os

def main():
    import idaapi, idautils, idc, ida_funcs, ida_bytes, ida_auto, ida_segment
    ida_auto.auto_wait()
    os.makedirs(OUT, exist_ok=True)
    lines = []
    def P(s): lines.append(str(s))

    # --- Target C: functions with start >= 0xFFF50000 (past window edge) ---
    P("== functions with start >= 0xFFF50000 ==")
    pastfns = []
    for ea in idautils.Functions(0xFFF4F000, 0xFFF50A00):
        f = ida_funcs.get_func(ea)
        if f:
            pastfns.append((f.start_ea, f.end_ea))
    for s,e in pastfns:
        P("fn %08X - %08X  (len %d)  name=%s" % (s, e, e-s, idc.get_func_name(s)))

    # The function that owns FFF50000
    f = ida_funcs.get_func(0xFFF50000)
    if f:
        P("\nowner of FFF50000: %08X - %08X name=%s" % (f.start_ea, f.end_ea, idc.get_func_name(f.start_ea)))
        P("callers of %08X:" % f.start_ea)
        for xr in idautils.XrefsTo(f.start_ea):
            P("  from %08X type=%d fn=%s" % (xr.frm, xr.type, idc.get_func_name(xr.frm)))
    else:
        P("FFF50000 not inside a function")

    # Peripheral immediate scan across FFF4FABD .. FFF50900 (full JPEG owner body + past tail)
    P("\n== peripheral immediates (0x80000-0xFFFFF) in FFF4FABD-FFF50900 ==")
    ea = 0xFFF4FABD
    end = 0xFFF50900
    nper = 0
    while ea < end:
        for i in range(idc.get_item_size(ea) or 1):
            pass
        for opn in range(2):
            t = idc.get_operand_type(ea, opn)
            if t == idc.o_imm:
                v = idc.get_operand_value(ea, opn) & 0xFFFFFFFF
                if 0x00080000 <= v <= 0x000FFFFF:
                    P("  %08X imm %08X : %s" % (ea, v, idc.generate_disasm_line(ea,0)))
                    nper += 1
        ea = idc.next_head(ea, end) if idc.next_head(ea, end) != idc.BADADDR else end
    P("peripheral immediate count: %d" % nper)

    # --- Below-window region 0xFFECE51C-0xFFED0000: is it data? ---
    P("\n== below-window FFECE51C-FFED0000 item classes ==")
    code_bytes = 0; data_bytes = 0; unk_bytes = 0
    ea = 0xFFECE51C
    while ea < 0xFFED0000:
        fl = ida_bytes.get_flags(ea)
        sz = idc.get_item_size(ea) or 1
        if ida_bytes.is_code(fl): code_bytes += sz
        elif ida_bytes.is_data(fl): data_bytes += sz
        else: unk_bytes += sz
        ea += sz
    P("code=%d data=%d undef=%d" % (code_bytes, data_bytes, unk_bytes))

    with open(os.path.join(OUT, "ida_targetC.txt"), "w", encoding="utf-8") as fo:
        fo.write("\n".join(lines))
    print("I10 residue query done")

try:
    main()
except Exception:
    os.makedirs(LOG, exist_ok=True)
    with open(os.path.join(LOG, "i10_residue_tb.txt"), "w", encoding="utf-8") as fo:
        fo.write(traceback.format_exc())
    print("TRACEBACK written")
finally:
    import idc
    idc.qexit(0)

r"""Lane J3 -- read-only IDA h8sxa dump of the 0x028CBC key-dispatch family.
Private DB J3_KEYDISP, seeded --copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64.
Nothing in the DB is modified except local auto-analysis of the ranges we force-decode.

Outputs (ida\out\key-dispatch\work\): disasm.txt, anchors.tsv, j3_error.txt on failure.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_ida, idc, idautils, ida_lines, ida_name

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "key-dispatch", "work")
os.makedirs(W, exist_ok=True)
XT = {0: "Data_Unknown", 1: "dr_O", 2: "dr_W", 3: "dr_R", 4: "dr_T", 5: "dr_I",
      16: "fl_CF", 17: "fl_CN", 18: "fl_JF", 19: "fl_JN", 21: "fl_F"}

# ranges to disassemble: (start, end_exclusive, label)
RANGES = [
    (0x028CBC, 0x028DB8, "dispatcher"),
    (0x026EE0, 0x027010, "writer_func_0xFFBBC2"),
    (0x026580, 0x026720, "writer_ladder_context"),
    (0x006600, 0x006640, "ptr_00FFBBC2_region"),
    # records (32-byte each) + their passers
    (0x028B5C, 0x028C40, "records_A"),
    (0x028C40, 0x028CBC, "records_B"),
    (0x0296D0, 0x029770, "records_96xx"),
    # handler targets (Rule B field pointers)
    (0x029732, 0x029770, "h_029732"),
    (0x05E33E, 0x05E3C0, "h_05E33E_05E37C"),
    (0x02A91A, 0x02A95E, "h_02A91A_02A924"),
    (0x02A9EA, 0x02AA30, "h_02A9EA_02A9F4"),
    (0x028A00, 0x028AE0, "h_028A00"),
    (0x029C38, 0x029CD0, "h_029Cxx"),
    (0x02B51E, 0x02B5C0, "h_02B5xx"),
    (0x0156BC, 0x0156F0, "h_0156BC"),
    (0x01A58C, 0x01A5D0, "h_01A58C"),
    (0x01BEF2, 0x01BF40, "h_01BEF2"),
    (0x012250, 0x0122E0, "screen_table_012268"),
]

# anchor addresses for xref/func reporting
ANCHORS = [
    0x028CBC, 0x0FFBBC2 & 0xFFFFFF,  # placeholder
    0x026F3E, 0x026F4A, 0x026F6C,
    0x028B6C, 0x028BB4, 0x028BF0, 0x028C2A, 0x028C62, 0x028C8A, 0x0296E8, 0x029712,
    0x028B62, 0x028BAA, 0x028BE6, 0x028C20, 0x028C5A, 0x028C82, 0x0296DE, 0x029708,
    0x029C56, 0x02A92E, 0x02A9FE, 0x01A58C,
    0x02A924, 0x02A9F4, 0x028C4A, 0x028CAA,
    0x012268,
]


def kind(ea):
    fl = ida_bytes.get_flags(ea)
    if ida_bytes.is_code(fl):
        return "code"
    if ida_bytes.is_data(fl):
        return "data"
    if ida_bytes.is_tail(fl):
        return "tail"
    return "unk"


def line(ea):
    return ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")


def main():
    ida_auto.auto_wait()
    # force decode each range so we get instruction lines even where the seed left gaps
    for s, e, _ in RANGES:
        ea = s
        while ea < e:
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                ida_ua.create_insn(ea)
            ea += max(1, ida_bytes.get_item_size(ea))
    ida_auto.auto_wait()

    out = []
    insn = ida_ua.insn_t()
    for s, e, lab in RANGES:
        out.append("\n==== %s  %06X..%06X ====" % (lab, s, e))
        ea = s
        while ea < e:
            fl = ida_bytes.get_flags(ea)
            sz = ida_bytes.get_item_size(ea)
            if sz < 1:
                sz = 1
            raw = " ".join("%02x" % b for b in ida_bytes.get_bytes(ea, min(sz, 12)))
            nm = ida_name.get_name(ea) or ""
            out.append("%06X %-5s %-28s | %s %s" % (ea, kind(ea), raw, ("<%s>" % nm) if nm else "", line(ea)))
            ea += sz
    with open(os.path.join(W, "disasm.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(out) + "\n")

    rows = ["addr\tname\tfunc\tfunc_name\tkind\txrefs_to"]
    for a in ANCHORS:
        fn = ida_funcs.get_func(a)
        xr = ",".join("%06X:%s" % (x.frm, XT.get(x.type, str(x.type))) for x in idautils.XrefsTo(a, 0))
        rows.append("%06X\t%s\t%s\t%s\t%s\t%s" % (
            a, ida_name.get_name(a) or "-",
            "%06X" % fn.start_ea if fn else "-",
            (ida_funcs.get_func_name(fn.start_ea) if fn else "-"),
            kind(a), xr or "-"))
    with open(os.path.join(W, "anchors.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(rows) + "\n")

    # function list containing key addrs + report caller tree for dispatcher callers
    callers = ["site\tfunc\tfunc_name"]
    for a in [0x028B62, 0x028BAA, 0x028BE6, 0x028C20, 0x028C5A, 0x028C82, 0x0296DE, 0x029708, 0x026F3E, 0x026F4A]:
        for x in idautils.XrefsTo(a, 0):
            fn = ida_funcs.get_func(x.frm)
            callers.append("%06X<-%06X\t%s\t%s" % (a, x.frm,
                           "%06X" % fn.start_ea if fn else "-",
                           ida_funcs.get_func_name(fn.start_ea) if fn else "-"))
    with open(os.path.join(W, "callers.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(callers) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "j3_error.txt"), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)

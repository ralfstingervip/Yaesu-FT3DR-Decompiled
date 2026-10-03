r"""Lane 8 - SUB: confirm dispatcher call chain + jump-table entry counts +
memcpy helper signature. Output: ida\out\abi-ipc\SUB_xref.txt
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_idaapi, idautils, idc

OUT = str(_REPO / "ida/out/abi-ipc")

def dis(ea): return idc.generate_disasm_line(ea, 0) or ""

def xrefs(ea, lines):
    lines.append("; xrefs TO %08X (%s)" % (ea, idc.get_name(ea) or ""))
    n=0
    for xr in idautils.XrefsTo(ea, 0):
        f = ida_funcs.get_func(xr.frm)
        fn = idc.get_func_name(xr.frm) if f else "?"
        lines.append("   %08X  %-24s %s" % (xr.frm, fn, dis(xr.frm)))
        n+=1
    lines.append("   (%d)" % n)

def dumpn(ea, n, lines):
    c = ea
    for _ in range(n):
        lines.append("  %08X  %s" % (c, dis(c)))
        nh = ida_bytes.next_head(c, ea+0x400)
        c = nh if nh != ida_idaapi.BADADDR and nh>c else c+1

def main():
    ida_auto.auto_wait()
    L = ["SUB dispatcher call chain + tables"]
    for ea in (0xFFEDF1D8, 0xFFEDC1F6, 0xFFEDF269, 0xFFEF0385):
        xrefs(ea, L); L.append("")
    # raw jump-table bytes: jpt at FFEDF1F6 region and FFEDF290
    for jpt, cnt, name in ((0xFFEDF1F6, 16, "jpt_FFEDF1F6"), (0xFFEDF290, 12, "jpt_FFEDF290")):
        L.append("; %s raw bytes (%d entries expected)" % (name, cnt))
        # RX switch uses a byte index table (mov.b [r,r15]) -> table of bytes
        L.append("   bytes: " + " ".join("%02X" % ida_bytes.get_byte(jpt+i) for i in range(cnt)))
        L.append("")
    # memcpy helper
    L.append("; ==== sub_FFEFB268 (memcpy candidate) ====")
    f = ida_funcs.get_func(0xFFEFB268)
    if f:
        c=f.start_ea
        while c<f.end_ea and c!=ida_idaapi.BADADDR:
            L.append("  %08X  %s" % (c, dis(c))); c=ida_bytes.next_head(c,f.end_ea)
    L.append("")
    # family handlers first lines (F1..F8, FD, FE)
    L.append("; family handler entry lines")
    for h in (0xFFEDF2E0,0xFFEDF36A,0xFFEDF3A7,0xFFEDF447,0xFFEDF4B8,0xFFEDF53E,0xFFEDF56F,0xFFEDF61B,0xFFEDF645):
        L.append("; ---- %08X %s ----" % (h, idc.get_name(h) or ""))
        dumpn(h, 6, L)
    with open(os.path.join(OUT, "SUB_xref.txt"),"w",encoding="utf-8",newline="\n") as fh:
        fh.write("\n".join(L)+"\n")

try:
    main(); idc.qexit(0)
except Exception:
    with open(os.path.join(OUT,"SUB_xref_TRACEBACK.txt"),"w",encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
    idc.qexit(1)

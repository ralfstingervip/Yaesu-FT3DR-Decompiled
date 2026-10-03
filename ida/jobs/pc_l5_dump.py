# PC_L5: dump functions / windows / xrefs listed in ida/out/pc/_l5_targets.txt
# line: ADDR [F|W=n|X]   F=function listing (default), W=n insn window, X=xrefs to data/code addr
import os, sys
import ida_auto, ida_bytes, ida_funcs, idautils, idc, ida_xref
OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "ida", "out", "pc")
ida_auto.auto_wait()
tg = os.path.join(OUT, "_l5_targets.txt")
res = []
def line(ea):
    sz = ida_bytes.get_item_size(ea) or 1
    raw = " ".join("%02X" % b for b in (ida_bytes.get_bytes(ea, min(sz, 10)) or b""))
    return "  %06X  %-24s %s" % (ea, raw, idc.generate_disasm_line(ea, 0) or ""), sz
def xrefs(ea):
    o = []
    for x in idautils.XrefsTo(ea, 0):
        f = ida_funcs.get_func(x.frm)
        o.append("    xref from %06X (%s) type=%d" % (x.frm, idc.get_func_name(x.frm) if f else "-", x.type))
    return o
for ln in open(tg, encoding="utf-8"):
    ln = ln.strip()
    if not ln or ln.startswith("#"): continue
    p = ln.split()
    ea = int(p[0], 16); mode = p[1] if len(p) > 1 else "F"
    res.append("=" * 70)
    if mode == "X":
        res.append("XREFS %06X" % ea); res += xrefs(ea); continue
    f = ida_funcs.get_func(ea)
    if mode == "F" and f:
        if f.start_ea != ea and not ida_funcs.get_func(ea).start_ea == ea:
            pass
        res.append("FUNC %s %06X-%06X" % (idc.get_func_name(f.start_ea), f.start_ea, f.end_ea))
        res += xrefs(f.start_ea)
        cur = f.start_ea
        while cur < f.end_ea:
            s, sz = line(cur); res.append(s); cur += sz
    else:
        n = int(mode[2:]) if mode.startswith("W=") else 80
        res.append("WINDOW %06X n=%d (func=%s)" % (ea, n, idc.get_func_name(ea)))
        res += xrefs(ea)
        cur = ea
        for _ in range(n):
            s, sz = line(cur); res.append(s); cur += sz
open(os.path.join(OUT, "_l5_dump.txt"), "w", encoding="utf-8").write("\n".join(res) + "\n")
idc.qexit(0)

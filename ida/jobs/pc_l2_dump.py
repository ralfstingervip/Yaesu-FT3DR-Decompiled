# Lane-2 (PC .dat files) dumper. Private DB only.
# env: PC_L2_RANGES="start-end,start-end" (hex), PC_L2_OUT=path, PC_L2_XREF="addr,addr" (hex)
import os
import idaapi, idc, idautils, ida_bytes, ida_funcs, ida_auto

ida_auto.auto_wait()
out = open(os.environ["PC_L2_OUT"], "w", encoding="utf-8")

def dis_range(a, b):
    # make code where undefined, then list
    ea = a
    while ea < b:
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            idc.create_insn(ea)
        n = idc.next_head(ea, b + 16)
        if n == idc.BADADDR or n <= ea:
            ea += 2
        else:
            ea = n
    ida_auto.auto_wait()
    ea = a
    while ea < b and ea != idc.BADADDR:
        f = ida_funcs.get_func(ea)
        if f and f.start_ea == ea:
            out.write("\n; ---- func %X\n" % ea)
        fl = ida_bytes.get_flags(ea)
        sz = max(1, idc.get_item_size(ea))
        if ida_bytes.is_code(fl):
            refs = [hex(x) for x in idautils.CodeRefsTo(ea, 0)]
            cm = ("   ; <- " + ",".join(refs[:6])) if refs and not ida_bytes.is_flow(fl) else ""
            out.write("%06X  %-16s %s%s\n" % (ea, ida_bytes.get_bytes(ea, sz).hex(), idc.GetDisasm(ea), cm))
        else:
            out.write("%06X  %-16s db\n" % (ea, ida_bytes.get_bytes(ea, sz).hex()))
        ea += sz

for r in [x for x in os.environ.get("PC_L2_RANGES", "").split(",") if x]:
    a, b = [int(v, 16) for v in r.split("-")]
    out.write("\n;==== range %X-%X\n" % (a, b))
    dis_range(a, b)

for x in [v for v in os.environ.get("PC_L2_XREF", "").split(",") if v]:
    a = int(x, 16)
    out.write("\n;==== xrefs to %X\n" % a)
    for r in idautils.XrefsTo(a, 0):
        f = ida_funcs.get_func(r.frm)
        out.write("%X  func=%s  %s\n" % (r.frm, hex(f.start_ea) if f else "-", idc.GetDisasm(r.frm)))
out.close()
idc.qexit(0)

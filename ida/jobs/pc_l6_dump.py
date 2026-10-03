import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
# Lane 6: dump disassembly of ranges/functions listed in ida/out/pc/L6_list.txt
# lines: "func 0xADDR" (whole function, create if needed) | "range 0xA 0xB" | "xref 0xADDR" (list code/data xrefs to addr)
import os, idaapi, idc, idautils, ida_funcs, ida_bytes, ida_auto
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) if '__file__' in globals() else str(_REPO)
ROOT = str(_REPO)
lst = os.path.join(ROOT, "ida", "out", "pc", os.environ.get("L6_LIST", "L6_list.txt"))
out = os.path.join(ROOT, "ida", "out", "pc", os.environ.get("L6_OUT", "L6_dump.txt"))
ida_auto.auto_wait()
def line(ea):
    s = idc.generate_disasm_line(ea, 0) or ""
    b = ida_bytes.get_bytes(ea, idc.get_item_size(ea)) or b""
    xr = [hex(x.frm) for x in idautils.XrefsTo(ea) if x.type not in (idaapi.fl_F,)]
    return "%06X  %-16s %s%s" % (ea, b.hex(), s, ("   ; xref " + ",".join(xr[:8])) if xr else "")
def dump_range(f, a, b):
    ea = a
    while ea < b:
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            idc.create_insn(ea)
        f.write(line(ea) + "\n")
        n = idc.get_item_size(ea)
        ea += n if n > 0 else 1
with open(out, "w", encoding="utf-8") as f:
    for raw in open(lst, encoding="utf-8"):
        p = raw.split()
        if not p or p[0].startswith("#"): continue
        if p[0] == "func":
            ea = int(p[1], 16)
            if not ida_funcs.get_func(ea):
                idc.create_insn(ea); ida_funcs.add_func(ea); ida_auto.auto_wait()
            fn = ida_funcs.get_func(ea)
            if not fn:
                f.write("== no func at %X\n" % ea); dump_range(f, ea, ea + 0x80); continue
            callers = sorted(set(hex(x) for x in idautils.CodeRefsTo(fn.start_ea, 0)))
            f.write("\n== func %X-%X callers %s\n" % (fn.start_ea, fn.end_ea, ",".join(callers)))
            dump_range(f, fn.start_ea, fn.end_ea)
        elif p[0] == "range":
            f.write("\n== range %s-%s\n" % (p[1], p[2])); dump_range(f, int(p[1], 16), int(p[2], 16))
        elif p[0] == "xref":
            ea = int(p[1], 16)
            f.write("\n== xrefs to %X: %s\n" % (ea, ",".join(hex(x.frm) + ("(%s)" % (ida_funcs.get_func_name(x.frm) or "")) for x in idautils.XrefsTo(ea))))
idc.qexit(0)

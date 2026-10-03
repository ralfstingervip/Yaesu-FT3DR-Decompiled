r"""Lane L6 -- dump a few SUB handler bodies (read-only). Output ida\out\home-keytable\work\sub_probe.txt"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_ua, ida_funcs, idc, idautils, ida_bytes
W = str(_REPO / "ida/out/home-keytable/work")
def main():
    ida_auto.auto_wait()
    o = []
    for root in (0xFFF0EBB5, 0xFFF1039A):
        f = ida_funcs.get_func(root)
        o.append("== %08X func %s" % (root, ("%X-%X" % (f.start_ea, f.end_ea)) if f else None))
        ea = root
        for i in range(60):
            o.append("%08X %-8s %s | cref=%s" % (ea, idc.print_insn_mnem(ea), idc.GetDisasm(ea), ["%X" % c for c in idautils.CodeRefsFrom(ea, False)]))
            ea = idc.next_head(ea, ea + 16)
    open(os.path.join(W, "sub_probe.txt"), "w", encoding="utf-8").write("\n".join(o) + "\n")
try:
    main()
except Exception:
    open(os.path.join(W, "sub_probe.err"), "w", encoding="utf-8").write(traceback.format_exc())
idc.qexit(0)

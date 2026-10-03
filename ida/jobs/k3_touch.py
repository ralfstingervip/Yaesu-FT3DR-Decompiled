r"""Lane K3 -- touch zones -> actions -> screens (MAIN). Read-only cross-check pass on DB K3_TOUCHSCR
(seeded from J1_MAIN_FINAL3). Only create_insn over cited code ranges if IDA has them undefined; no byte
is patched. Outputs ida\out\touch-screens\work\: ida_disasm.txt, ida_xrefs.tsv, ida_check.tsv
Requests come from ida\out\touch-screens\work\ida_req.txt (one hex address or range per line).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, idc, idautils, ida_lines, ida_name

ROOT = str(_REPO)
W = os.path.join(ROOT, "ida", "out", "touch-screens", "work")
XT = {0: "Data_Unknown", 1: "dr_O", 2: "dr_W", 3: "dr_R", 4: "dr_T", 5: "dr_I",
      16: "fl_CF", 17: "fl_CN", 18: "fl_JF", 19: "fl_JN", 21: "fl_F"}
CW = (0x078106, 0x07B754)


def line(ea):
    return ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")


def kind(ea):
    fl = ida_bytes.get_flags(ea)
    return "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else ("tail" if ida_bytes.is_tail(fl) else "unk"))


def main():
    ida_auto.auto_wait()
    reqs = []
    with open(os.path.join(W, "ida_req.txt"), encoding="utf-8") as f:
        for ln in f:
            ln = ln.split("#")[0].strip()
            if not ln:
                continue
            p = ln.split()
            reqs.append((p[0], [int(x, 16) for x in p[1:]]))
    dis, xr, chk = [], ["target\tname\tfunc\txref_from\ttype\tfrom_func"], ["addr\tida_kind\tida_size\tida_text\tbytes"]
    for kindreq, args in reqs:
        if kindreq == "range":
            s, e = args
            if s < CW[1] and e > CW[0]:
                continue
            ea = s
            dis.append("\n==== %06X..%06X ====" % (s, e))
            while ea < e:
                if not ida_bytes.is_code(ida_bytes.get_flags(ea)) and not ida_bytes.is_tail(ida_bytes.get_flags(ea)):
                    ida_ua.create_insn(ea)
                sz = max(1, ida_bytes.get_item_size(ea))
                raw = " ".join("%02x" % b for b in ida_bytes.get_bytes(ea, min(sz, 10)))
                dis.append("%06X %-5s %-30s | %s" % (ea, kind(ea), raw, line(ea)))
                ea += sz
        elif kindreq == "xref":
            for a in args:
                fn = ida_funcs.get_func(a)
                for x in idautils.XrefsTo(a, 0):
                    ff = ida_funcs.get_func(x.frm)
                    xr.append("%06X\t%s\t%s\t%06X\t%s\t%s" % (a, ida_name.get_name(a) or "-",
                              ("%06X" % fn.start_ea) if fn else "-", x.frm, XT.get(x.type, str(x.type)),
                              ("%06X" % ff.start_ea) if ff else "-"))
        elif kindreq == "insn":
            for a in args:
                sz = ida_bytes.get_item_size(a)
                chk.append("%06X\t%s\t%d\t%s\t%s" % (a, kind(a), sz, line(a),
                           " ".join("%02x" % b for b in ida_bytes.get_bytes(a, min(max(sz, 2), 10)))))
    ida_auto.auto_wait()
    with open(os.path.join(W, "ida_disasm.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(dis) + "\n")
    with open(os.path.join(W, "ida_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(xr) + "\n")
    with open(os.path.join(W, "ida_check.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(chk) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "k3_error.txt"), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)

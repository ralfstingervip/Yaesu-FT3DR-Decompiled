r"""Lane L12: caller trees (read-only). env L12_REQ json: {"out":path,"roots":[ea..],"depth":n}
For each root: BFS over code call xrefs and data refs to the function start, printing
each edge once: depth, callee func, caller site, caller func, ref type. Also prints, per
function seen, the string literals it references (operand immediates that point at
NUL-terminated printable text in the image)."""
from __future__ import annotations
import json, os, traceback
import ida_auto, ida_bytes, ida_funcs, idc, idautils, ida_name, ida_ua

def fstart(ea):
    f = ida_funcs.get_func(ea)
    return f.start_ea if f else None

def nm(ea):
    return ida_name.get_name(ea) or ("%08X" % ea)

def cstr(ea):
    if not (0xFFC00000 <= ea <= 0xFFFFFFF0):
        return None
    b = ida_bytes.get_bytes(ea, 48) or b""
    s = b.split(b"\0")[0]
    if len(s) >= 3 and all(32 <= c < 127 for c in s):
        return s.decode("ascii")
    return None

def strings_in(fs):
    f = ida_funcs.get_func(fs)
    out = []
    if not f:
        return out
    for h in idautils.FuncItems(fs):
        insn = ida_ua.insn_t()
        if not ida_ua.decode_insn(insn, h):
            continue
        for op in insn.ops:
            if op.type == 0:
                break
            for v in (op.value, op.addr):
                s = cstr(v & 0xFFFFFFFF)
                if s:
                    out.append("%08X@%08X:%r" % (v & 0xFFFFFFFF, h, s))
    return out

def main():
    req = json.load(open(os.environ["L12_REQ"], encoding="utf-8"))
    ida_auto.auto_wait()
    o = []
    seen_f = set()
    for root in req["roots"]:
        o.append("\n#### root %08X %s" % (root, nm(root)))
        frontier = [root]
        done = {root}
        for d in range(1, req.get("depth", 6) + 1):
            nxt = []
            for callee in frontier:
                for x in idautils.XrefsTo(callee, 0):
                    cf = fstart(x.frm)
                    kind = "code" if x.iscode else "data"
                    o.append("%d\t%s\t<-\t%08X\t%s\t%s" % (d, nm(callee), x.frm, nm(cf) if cf else "nofunc", kind))
                    tgt = cf if cf is not None else None
                    if not x.iscode:
                        # data ref (pointer table): report and also look at refs to that slot
                        for y in idautils.XrefsTo(x.frm, 0):
                            yf = fstart(y.frm)
                            o.append("%d\t  slot %08X\t<-\t%08X\t%s\tdata-of-data" % (d, x.frm, y.frm, nm(yf) if yf else "nofunc"))
                    if tgt is not None and tgt not in done:
                        done.add(tgt)
                        nxt.append(tgt)
            frontier = nxt
            if not frontier:
                break
        seen_f |= done
    o.append("\n#### strings per function")
    for fs in sorted(seen_f):
        ss = strings_in(fs)
        if ss:
            o.append("%s\t%s" % (nm(fs), " | ".join(ss[:40])))
    with open(req["out"], "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(o) + "\n")

try:
    main()
except Exception:
    with open(os.environ.get("L12_REQ", "l12") + ".err.txt", "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

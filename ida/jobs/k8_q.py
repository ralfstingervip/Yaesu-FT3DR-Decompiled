# -*- coding: utf-8 -*-
r"""Lane K8 generic read-only query job (APRS / AX.25 on MAIN).

Reads a JSON request list from env K8_REQ, writes text to env K8_OUT.
Ops: func, dis, xto, callers, callees, funcs_in, opscan.
Read-only: never changes the database except IDA's own auto_wait.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, json, traceback
import ida_auto, idc, ida_bytes, ida_funcs, ida_xref, idautils, ida_ua

REQ = os.environ.get("K8_REQ", "")
OUT = os.environ.get("K8_OUT", "")


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return "-"
    return "%s+%X" % (ida_funcs.get_func_name(f.start_ea), ea - f.start_ea)


def line(ea):
    d = idc.generate_disasm_line(ea, 0) or ""
    sz = idc.get_item_size(ea)
    raw = ida_bytes.get_bytes(ea, min(sz, 10)) or b""
    return "%06X  %-30s  %s" % (ea, " ".join("%02x" % b for b in raw), d)


def disrange(lo, hi):
    out = []
    ea = lo
    while ea < hi and ea != idc.BADADDR:
        out.append(line(ea))
        n = idc.next_head(ea, hi)
        if n <= ea:
            break
        ea = n
    return out


def func(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return ["no func at %06X; raw dis" % ea] + disrange(ea, ea + 0x100)
    out = ["; func %s %06X-%06X" % (ida_funcs.get_func_name(f.start_ea), f.start_ea, f.end_ea)]
    for (s, e) in idautils.Chunks(f.start_ea):
        out.append("; chunk %06X-%06X" % (s, e))
        out += disrange(s, e)
    return out


def xto(ea):
    out = []
    for x in idautils.XrefsTo(ea, 0):
        out.append("  %06X %-24s t=%d  %s" % (x.frm, fname(x.frm), x.type, idc.generate_disasm_line(x.frm, 0) or ""))
    return out


def callers(ea, depth):
    out = []
    seen = set()
    frontier = [(ea, 0)]
    while frontier:
        e, d = frontier.pop(0)
        f = ida_funcs.get_func(e)
        start = f.start_ea if f else e
        if start in seen or d > depth:
            continue
        seen.add(start)
        for x in idautils.XrefsTo(start, 0):
            if not idc.is_code(idc.get_full_flags(x.frm)):
                out.append("%s%06X <- data %06X" % ("  " * d, start, x.frm))
                continue
            out.append("%s%06X <- %06X %s" % ("  " * d, start, x.frm, fname(x.frm)))
            g = ida_funcs.get_func(x.frm)
            if g:
                frontier.append((g.start_ea, d + 1))
    return out


def callees(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return ["no func"]
    out = []
    for (s, e) in idautils.Chunks(f.start_ea):
        for h in idautils.Heads(s, e):
            for x in idautils.XrefsFrom(h, 0):
                if x.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                    out.append("  %06X -> %06X %s" % (h, x.to, fname(x.to)))
    return out


def funcs_in(lo, hi):
    out = []
    for s in idautils.Functions(lo, hi):
        f = ida_funcs.get_func(s)
        nc = len(list(idautils.CodeRefsTo(s, 0)))
        out.append("%06X %06X %5d callers=%d %s" % (s, f.end_ea, f.end_ea - s, nc, ida_funcs.get_func_name(s)))
    return out


def opscan(lo, hi, vals):
    """List instructions in [lo,hi) whose disasm text contains any token."""
    out = []
    for s in idautils.Functions(lo, hi):
        f = ida_funcs.get_func(s)
        for (a, b) in idautils.Chunks(s):
            for h in idautils.Heads(a, b):
                d = (idc.generate_disasm_line(h, 0) or "").lower()
                for v in vals:
                    if v.lower() in d:
                        out.append("%06X %-24s %s" % (h, fname(h), d))
                        break
    return out


def main():
    ida_auto.auto_wait()
    reqs = json.load(open(REQ, encoding="utf-8"))
    res = []
    for r in reqs:
        op = r["op"]
        res.append("##### %s" % json.dumps(r))
        try:
            if op == "func":
                res += func(int(r["ea"], 16))
            elif op == "dis":
                res += disrange(int(r["lo"], 16), int(r["hi"], 16))
            elif op == "xto":
                res += xto(int(r["ea"], 16))
            elif op == "callers":
                res += callers(int(r["ea"], 16), int(r.get("depth", 3)))
            elif op == "callees":
                res += callees(int(r["ea"], 16))
            elif op == "funcs_in":
                res += funcs_in(int(r["lo"], 16), int(r["hi"], 16))
            elif op == "opscan":
                res += opscan(int(r["lo"], 16), int(r["hi"], 16), r["vals"])
        except Exception:
            res.append(traceback.format_exc())
        res.append("")
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(res))


try:
    main()
except Exception:
    with open((OUT or str(_REPO / "ida/out/aprs-ax25/k8_tb.txt")) + ".tb", "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

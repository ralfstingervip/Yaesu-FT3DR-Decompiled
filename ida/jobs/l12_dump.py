r"""Lane L12 generic read-only dumper (SUB->MAIN frame producers); copy of k2_dump.py plus "callctx".
Driven by a JSON request file named in env L12_REQ:
  {"out": "<path>", "funcs": [ea,...], "ranges": [[s,e,"label"],...],
   "xrefs": [ea,...], "decode": true|false}
- funcs: dump every instruction of the function containing ea (all chunks) + xrefs to its start.
- ranges: linear dump; when "decode" is true, undefined bytes in the range get create_insn
  (private DB only; image bytes are never patched).
- xrefs: list every xref to ea with the referencing function name.
Writes UTF-8 text to "out". Errors go to out + ".err.txt".
"""
from __future__ import annotations
import json, os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, idc, idautils, ida_lines, ida_name

XT = {0: "Data_Unknown", 1: "dr_O", 2: "dr_W", 3: "dr_R", 4: "dr_T", 5: "dr_I",
      16: "fl_CF", 17: "fl_CN", 18: "fl_JF", 19: "fl_JN", 21: "fl_F"}


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


def fname(ea):
    fn = ida_funcs.get_func(ea)
    return ida_funcs.get_func_name(fn.start_ea) if fn else "-"


def xr(ea):
    out = []
    for x in idautils.XrefsTo(ea, 0):
        out.append("%06X:%s:%s" % (x.frm, XT.get(x.type, str(x.type)), fname(x.frm)))
    return out


def dump_line(ea):
    sz = max(1, ida_bytes.get_item_size(ea))
    raw = " ".join("%02x" % b for b in (ida_bytes.get_bytes(ea, min(sz, 10)) or b""))
    lab = ida_name.get_name(ea) or ""
    refs = ""
    if lab:
        refs = "   <- " + ",".join(xr(ea)[:12])
    return sz, "%06X %-4s %-30s | %-40s %s%s" % (ea, kind(ea), raw, line(ea), ("[" + lab + "]") if lab else "", refs)


def main():
    req = json.load(open(os.environ["L12_REQ"], encoding="utf-8"))
    out_path = req["out"]
    ida_auto.auto_wait()
    o = []
    if req.get("decode"):
        for s, e, lab in req.get("ranges", []):
            ea = s
            while ea < e:
                if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                    ida_ua.create_insn(ea)
                ea += max(1, ida_bytes.get_item_size(ea))
        ida_auto.auto_wait()
    for fea in req.get("funcs", []):
        fn = ida_funcs.get_func(fea)
        if not fn:
            o.append("\n==== no func at %06X (kind %s) ====" % (fea, kind(fea)))
            continue
        o.append("\n==== func %s %06X..%06X  xrefs_to: %s ====" % (
            ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea, ",".join(xr(fn.start_ea))))
        it = ida_funcs.func_tail_iterator_t(fn)
        ok = it.main()
        chunks = []
        while ok:
            c = it.chunk()
            chunks.append((c.start_ea, c.end_ea))
            ok = it.next()
        for s, e in sorted(chunks):
            o.append("-- chunk %06X..%06X" % (s, e))
            ea = s
            while ea < e:
                sz, t = dump_line(ea)
                o.append(t)
                ea += sz
    for s, e, lab in req.get("ranges", []):
        o.append("\n==== range %s %06X..%06X ====" % (lab, s, e))
        ea = s
        while ea < e:
            sz, t = dump_line(ea)
            o.append(t + ("   {%s}" % fname(ea)))
            ea += sz
    for a in req.get("callctx", []):
        o.append("\n==== callers of %06X %s ====" % (a, ida_name.get_name(a) or "-"))
        for x in idautils.XrefsTo(a, 0):
            if x.type not in (16, 17, 18, 19):
                o.append("  nonflow ref %06X type %s func %s" % (x.frm, XT.get(x.type, str(x.type)), fname(x.frm)))
                continue
            o.append("-- site %06X in %s" % (x.frm, fname(x.frm)))
            ea = x.frm
            prev = []
            p_ = ea
            for _ in range(req.get("back", 14)):
                p_ = idc.prev_head(p_, 0)
                if p_ == idc.BADADDR:
                    break
                prev.append(p_)
            for pe in reversed(prev):
                o.append("   " + dump_line(pe)[1])
            o.append(" > " + dump_line(ea)[1])
            n_ = ea
            for _ in range(2):
                n_ = idc.next_head(n_, idc.BADADDR)
                o.append("   " + dump_line(n_)[1])
    for a in req.get("xrefs", []):
        o.append("XREF %06X %s kind=%s func=%s: %s" % (a, ida_name.get_name(a) or "-", kind(a), fname(a), ",".join(xr(a)) or "-"))
    with open(out_path, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(o) + "\n")


try:
    main()
except Exception:
    with open(os.environ.get("L12_REQ", "k2") + ".err.txt", "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)

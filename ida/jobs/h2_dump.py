# -*- coding: utf-8 -*-
r"""Lane H2 -- read-only state dump of a MAIN database (MAIN_H8SX / H2_REF).

Env:
  H2_TAG   output prefix (default: the db name)
  H2_Q     optional comma list of hex addresses to disassemble around
Writes ida\out\h8sx-seed\work\<TAG>_*.  Creates/deletes nothing in the DB.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, hashlib, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ida, ida_segment, ida_ua, ida_idp, ida_name
import ida_lines, ida_entry, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8sx-seed", "work")
os.makedirs(OUT, exist_ok=True)
TAG = os.environ.get("H2_TAG") or os.environ.get("YAESU_JOB", "x")
LO, HI = 0x000000, 0x07B754
WLO, WHI = 0x078106, 0x07B754
PROVED = os.path.join(ROOT, "ida", "out", "main-indirect", "proved.tsv")
# F1 corrections (G1 doc 36): mid-MOV.L / ASCII-led starts -> true entries (filled by h2 after query)
F1FIX = {}
try:
    with open(os.path.join(ROOT, "ida", "out", "h8sx-seed", "f1_true_starts.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            if len(p) >= 2:
                F1FIX[int(p[0], 16)] = int(p[1], 16)
except Exception:
    pass


def P(name):
    return os.path.join(OUT, "%s_%s" % (TAG, name))


def text(ea):
    return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "")


def has_in(ea):
    for _ in idautils.CodeRefsTo(ea, 0):
        return True
    for _ in idautils.DataRefsTo(ea):
        return True
    return False


def main():
    ida_auto.auto_wait()
    m = []
    m.append("procname\t%s" % ida_ida.inf_get_procname())
    m.append("min_ea\t%X" % ida_ida.inf_get_min_ea())
    m.append("max_ea\t%X" % ida_ida.inf_get_max_ea())
    m.append("start_ea\t%X" % ida_ida.inf_get_start_ea())
    m.append("be\t%d" % int(ida_ida.inf_is_be()))
    m.append("dword@0\t%08X" % ida_bytes.get_dword(0))
    for i in range(ida_segment.get_segm_qty()):
        s = ida_segment.getnseg(i)
        m.append("segment\t%s\t%X\t%X\tbitness=%d\tclass=%s\tperm=%d" % (
            ida_segment.get_segm_name(s), s.start_ea, s.end_ea, s.bitness,
            ida_segment.get_segm_class(s), s.perm))
    ents = []
    for i in range(ida_entry.get_entry_qty()):
        o = ida_entry.get_entry_ordinal(i)
        ents.append("%X:%s" % (ida_entry.get_entry(o), ida_entry.get_entry_name(o)))
    m.append("entries\t%s" % ",".join(ents))

    # items over content
    code_b = data_b = 0
    code_h = 0
    odd = []
    wl = []
    ea = LO if ida_bytes.is_head(ida_bytes.get_flags(LO)) else ida_bytes.next_head(LO, HI)
    while ea != idc.BADADDR and ea < HI:
        fl = ida_bytes.get_flags(ea)
        sz = ida_bytes.get_item_size(ea)
        if ida_bytes.is_code(fl):
            code_b += sz
            code_h += 1
            if ea & 1:
                f = ida_funcs.get_func(ea)
                odd.append((ea, sz, "%06X" % f.start_ea if f else "-", text(ea)))
            k = "code"
        elif ida_bytes.is_data(fl):
            data_b += sz
            k = "data"
        else:
            k = "unk"
        if WLO <= ea < WHI:
            wl.append("%06X\t%d\t%s" % (ea, sz, k))
        ea = ida_bytes.next_head(ea, HI)
    m.append("content_code_bytes\t%d" % code_b)
    m.append("content_code_heads\t%d" % code_h)
    m.append("content_data_bytes\t%d" % data_b)
    m.append("odd_code_heads\t%d" % len(odd))
    m.append("odd_code_bytes\t%d" % sum(o[1] for o in odd))
    m.append("odd_code_heads_in_func\t%d" % sum(1 for o in odd if o[2] != "-"))
    wtxt = "\n".join(wl)
    m.append("window_heads\t%d" % len(wl))
    m.append("window_code_bytes\t%d" % sum(int(x.split("\t")[1]) for x in wl if x.endswith("code")))
    m.append("window_sha1\t%s" % hashlib.sha1(wtxt.encode("ascii")).hexdigest())
    with open(P("window_items.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tkind\n" + wtxt + "\n")
    with open(P("odd_heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tfunc\ttext\n")
        for o in odd:
            h.write("%06X\t%d\t%s\t%s\n" % o)

    # functions
    nf = 0
    nf_all = 0
    fb = 0
    with open(P("funcs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tname\tchunks\tbytes\n")
        for fs in idautils.Functions():
            nf_all += 1
            f = ida_funcs.get_func(fs)
            nch = 0
            b = 0
            for cs, ce in idautils.Chunks(fs):
                nch += 1
                b += ce - cs
            if LO <= fs < HI:
                nf += 1
                fb += b
            h.write("%06X\t%06X\t%s\t%d\t%d\n" % (f.start_ea, f.end_ea, ida_funcs.get_func_name(fs), nch, b))
    m.append("functions_all\t%d" % nf_all)
    m.append("functions_content\t%d" % nf)
    m.append("function_chunk_bytes\t%d" % fb)
    m.append("functions_odd_start\t%d" % sum(1 for fs in idautils.Functions() if fs & 1))

    # names / comments
    nuser = 0
    with open(P("names.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tname\tuser\n")
        for ea, nm in idautils.Names():
            u = ida_bytes.has_user_name(ida_bytes.get_flags(ea))
            nuser += 1 if u else 0
            h.write("%06X\t%s\t%d\n" % (ea, nm, int(u)))
    m.append("user_names\t%d" % nuser)
    nc = 0
    with open(P("comments.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tkind\ttext\n")
        for seg in idautils.Segments():
            s = ida_segment.getseg(seg)
            ea = s.start_ea
            while ea != idc.BADADDR and ea < s.end_ea:
                for rpt in (0, 1):
                    c = ida_bytes.get_cmt(ea, rpt)
                    if c:
                        nc += 1
                        h.write("%06X\t%s\t%s\n" % (ea, "rpt" if rpt else "cmt", c.replace("\n", "\\n").replace("\t", " ")))
                ea = ida_bytes.next_head(ea, s.end_ea)
        for fs in idautils.Functions():
            f = ida_funcs.get_func(fs)
            for rpt in (0, 1):
                c = ida_funcs.get_func_cmt(f, rpt)
                if c:
                    nc += 1
                    h.write("%06X\t%s\t%s\n" % (fs, "fn_rpt" if rpt else "fn_cmt", c.replace("\n", "\\n").replace("\t", " ")))
    m.append("comments\t%d" % nc)

    # proved-function survival (raw 444 and F1-corrected)
    raw = []
    with open(PROVED, encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.split("\t")
            if p and p[0] and not p[0].startswith("#"):
                raw.append(int(p[0], 16))
    for lbl, lst in (("raw", raw), ("f1corr", [F1FIX.get(s, s) for s in raw])):
        isf = [s for s in lst if ida_funcs.get_func(s) and ida_funcs.get_func(s).start_ea == s]
        xr = [s for s in lst if has_in(s)]
        both = [s for s in isf if has_in(s)]
        incode = [s for s in lst if ida_bytes.is_code(ida_bytes.get_flags(s))]
        m.append("proved_%s\tn=%d func_at_start=%d incoming_xref=%d both=%d is_code=%d" % (
            lbl, len(lst), len(isf), len(xr), len(both), len(incode)))
        if lbl == "f1corr":
            with open(P("proved_status.tsv"), "w", encoding="utf-8", newline="\n") as h:
                h.write("start\tfunc_at_start\tincoming\tis_code\n")
                for s in lst:
                    f = ida_funcs.get_func(s)
                    h.write("%06X\t%d\t%d\t%d\n" % (s, int(bool(f and f.start_ea == s)), int(has_in(s)),
                                                 int(ida_bytes.is_code(ida_bytes.get_flags(s)))))

    with open(P("meta.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(m) + "\n")

    q = os.environ.get("H2_Q", "")
    if q:
        with open(P("query.txt"), "w", encoding="utf-8", newline="\n") as h:
            for a in q.split(","):
                a = int(a, 16)
                f = ida_funcs.get_func(a)
                h.write("=== %06X func=%s\n" % (a, ("%06X-%06X %s" % (f.start_ea, f.end_ea, ida_funcs.get_func_name(f.start_ea))) if f else "-"))
                ea = a
                for _ in range(14):
                    ea = ida_bytes.prev_head(ea, 0)
                for _ in range(30):
                    if ea == idc.BADADDR:
                        break
                    fl = ida_bytes.get_flags(ea)
                    sz = ida_bytes.get_item_size(ea)
                    bts = ida_bytes.get_bytes(ea, min(sz, 10)) or b""
                    xr = ",".join("%X" % x for x in list(idautils.CodeRefsTo(ea, 0))[:4] + list(idautils.DataRefsTo(ea))[:4])
                    fn = ida_funcs.get_func(ea)
                    h.write("%s%06X %-20s %-50s fn=%s in=%s\n" % (">" if ea == a else " ", ea, bts.hex(" "), text(ea)[:50],
                                                                  "%X" % fn.start_ea if fn else "-", xr))
                    ea = ida_bytes.next_head(ea, HI)


try:
    main()
    with open(P("log.txt"), "w", encoding="utf-8") as fh:
        fh.write("ok\n")
except Exception:
    with open(P("log.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

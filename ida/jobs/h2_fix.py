# -*- coding: utf-8 -*-
r"""Lane H2 -- turn MAIN_H8SX (copy of G1_H8S) into a clean H8SX seed.

1. confirm/force processor h8sxa
2. verify G1's absorption (246 MOV.L sites, module 0x075F36-0x078105, 164 new / 44 removed)
3. F1 function-start corrections + the two 38 B ASCII strings + bogus "NEW" func at 0x06AB5C
4. delete odd-aligned code heads (H8 instructions are word-aligned) and odd-start functions
Every change -> ida\out\h8sx-seed\changes.tsv (phase=fix). Env H2_ODD=0 skips step 4.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ida, ida_idp, ida_ua, ida_lines, ida_nalt, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8sx-seed")
WORK = os.path.join(OUT, "work")
DEC = os.path.join(ROOT, "ida", "out", "h8s-decode")
LO, HI = 0, 0x07B754
WLO, WHI = 0x078106, 0x07B754
PHASE = os.environ.get("H2_PHASE", "fix")
CH = []
LOG = []


def ch(kind, ea, before, after, why):
    CH.append("%s\t%s\t%06X\t%s\t%s\t%s" % (PHASE, kind, ea, before, after, why))


def fdesc(ea):
    f = ida_funcs.get_func(ea)
    return "%06X-%06X" % (f.start_ea, f.end_ea) if f else "-"


def txt(ea):
    return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "")


def verify(tag):
    out = []
    # 246 MOV.L sites + all A/B sites
    nmov = okmov = 0
    nab = okab = 0
    bad = []
    with open(os.path.join(DEC, "sites.tsv"), encoding="utf-8") as h:
        hdr = None
        for ln in h:
            if ln.startswith("#"):
                continue
            p = ln.rstrip("\n").split("\t")
            if hdr is None:
                hdr = p
                continue
            r = dict(zip(hdr, p))
            if r["status"] not in ("A", "B"):
                continue
            ea = int(r["addr"], 16)
            ln_ = int(r["length"])
            good = ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_bytes.is_head(ida_bytes.get_flags(ea)) \
                and ida_bytes.get_item_size(ea) == ln_
            nab += 1
            okab += good
            if r["form"].startswith("mov.l @(n:32"):
                nmov += 1
                okmov += good
            if not good:
                bad.append("%06X" % ea)
    out.append("%s sites_AB %d/%d code at planned length; movl_d32 %d/%d; bad=%s" % (tag, okab, nab, okmov, nmov, ",".join(bad[:30])))
    # module
    nonc = 0
    ea = 0x075F36
    while ea < 0x078106:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            ea += ida_bytes.get_item_size(ea) if ida_bytes.is_head(fl) else 1
        else:
            nonc += 1
            ea += 1
    out.append("%s module_075F36_078105 non-code bytes %d of 8656" % (tag, nonc))
    # absorbed new / removed
    nnew = oknew = nrem = okrem = 0
    miss = []
    back = []
    with open(os.path.join(DEC, "absorbed.tsv"), encoding="utf-8") as h:
        hdr = None
        for ln in h:
            if ln.startswith("#"):
                continue
            p = ln.rstrip("\n").split("\t")
            if hdr is None:
                hdr = p
                continue
            r = dict(zip(hdr, p))
            s = int(r["start"], 16)
            f = ida_funcs.get_func(s)
            isf = bool(f and f.start_ea == s)
            if r["kind"] == "new":
                nnew += 1
                oknew += isf
                if not isf:
                    miss.append("%06X" % s)
            elif r["kind"] == "removed":
                nrem += 1
                okrem += (not isf)
                if isf:
                    back.append("%06X" % s)
    out.append("%s new_funcs present %d/%d missing=%s" % (tag, oknew, nnew, ",".join(miss)))
    out.append("%s removed_funcs absent %d/%d back=%s" % (tag, okrem, nrem, ",".join(back)))
    return out


def make_text(ea, n, why):
    before = "%s %s" % ("code" if ida_bytes.is_code(ida_bytes.get_flags(ea)) else "data/unk", fdesc(ea))
    ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, n)
    ok = ida_bytes.create_strlit(ea, n, ida_nalt.STRTYPE_C)
    if not ok:
        ok = ida_bytes.create_byte(ea, n)
    ch("make_string", ea, before, "strlit %d B ok=%s" % (n, ok), why)


def f1_fixes():
    # 034644 -> 034538
    f = ida_funcs.get_func(0x034644)
    if f and f.start_ea == 0x034644:
        ida_funcs.del_func(0x034644)
        ch("del_func", 0x034644, "func", "-", "F1 row starts +2 into MOV.L 034642")
    if not ida_funcs.get_func(0x034538):
        ok = ida_funcs.add_func(0x034538)
        ch("add_func", 0x034538, "no func (code)", "func %s ok=%s" % (fdesc(0x034538), ok),
           "true entry of F1 row 034644; jsr from 002CA8, 0038BA")
    # 038104 / 04F3A4: verify only
    for row, start in ((0x038104, 0x0380EA), (0x04F3A4, 0x04F390), (0x04DE6E, 0x04DE94), (0x04DF72, 0x04DF98)):
        f = ida_funcs.get_func(start)
        ok = bool(f and f.start_ea == start)
        if not ok:
            ok = ida_funcs.add_func(start)
            ch("add_func", start, "missing", "func %s ok=%s" % (fdesc(start), ok), "true entry of F1 row %06X" % row)
        else:
            ch("verify", start, "func %s" % fdesc(start), "unchanged", "true entry of F1 row %06X (G1 already fixed)" % row)
        g = ida_funcs.get_func(row)
        if g and g.start_ea == row:
            ida_funcs.del_func(row)
            ch("del_func", row, "func", "-", "F1 row start not an instruction start")
    # 06AC14 -> 06AB68 ; bogus func on "NEW       \xff\0" at 06AB5C
    f = ida_funcs.get_func(0x06AB5C)
    if f and f.start_ea == 0x06AB5C:
        before = fdesc(0x06AB5C) + " chunks=%d" % sum(1 for _ in idautils.Chunks(0x06AB5C))
        ida_funcs.del_func(0x06AB5C)
        ch("del_func", 0x06AB5C, before, "-", "starts on ASCII 'NEW       ' (4e 45 57 20..), eepmov source (mov.l #0x6AB5C,er5 at 06AB46, r4=10)")
    if ida_bytes.is_code(ida_bytes.get_flags(0x06AB5C)):
        make_text(0x06AB5C, 10, "10-byte label copied by eepmov.w at 06AB52")
        ida_bytes.del_items(0x06AB66, ida_bytes.DELIT_SIMPLE, 2)
        ida_bytes.create_word(0x06AB66, 2)
        ch("make_data", 0x06AB66, "code", "word ff00", "terminator after 'NEW' label")
    f = ida_funcs.get_func(0x06AB68)
    before = fdesc(0x06AB68)
    if not (f and f.start_ea == 0x06AB68 and f.end_ea == 0x06AC3A):
        if f and f.start_ea == 0x06AB68:
            ida_funcs.del_func(0x06AB68)
        ok = ida_funcs.add_func(0x06AB68, 0x06AC3A)
        ch("redefine_func", 0x06AB68, before, "%s ok=%s" % (fdesc(0x06AB68), ok),
           "true entry of F1 row 06AC14; body = 8-way jmp table 06AC3A cases 06AB88-06AC0A + tail 06AC0C-06AC38 rts")
    # ASCII-led
    for ea in (0x04DE6E, 0x04DF72):
        if not ida_bytes.is_strlit(ida_bytes.get_flags(ida_bytes.get_item_head(ea))):
            make_text(ea, 38, "F1 ASCII-led row; 38 B text before true entry")


def odd_cleanup():
    oddf = [fs for fs in idautils.Functions(LO, HI) if fs & 1]
    for fs in oddf:
        d = fdesc(fs)
        ida_funcs.del_func(fs)
        ch("del_func", fs, d, "-", "odd-aligned function start (H8 insns are word-aligned)")
    heads = []
    ea = LO if ida_bytes.is_head(ida_bytes.get_flags(LO)) else ida_bytes.next_head(LO, HI)
    while ea != idc.BADADDR and ea < HI:
        fl = ida_bytes.get_flags(ea)
        if (ea & 1) and ida_bytes.is_code(fl) and not (WLO <= ea < WHI):
            heads.append(ea)
        ea = ida_bytes.next_head(ea, HI)
    # group into runs for the change log
    runs = []
    for ea in heads:
        sz = ida_bytes.get_item_size(ea)
        nin = sum(1 for x in idautils.CodeRefsTo(ea, 0) if not (x & 1))
        f = ida_funcs.get_func(ea)
        if runs and ea - runs[-1][1] <= 2:
            runs[-1][1] = ea + sz
            runs[-1][2] += 1
            runs[-1][3] += sz
            runs[-1][4] += nin
            runs[-1][5] = runs[-1][5] or bool(f)
        else:
            runs.append([ea, ea + sz, 1, sz, nin, bool(f)])
    for ea in heads:
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE)
    for r in runs:
        ch("del_odd_code", r[0], "code %06X-%06X heads=%d bytes=%d even_crefs_in=%d in_func=%d" % (r[0], r[1], r[2], r[3], r[4], int(r[5])),
           "unknown", "odd-aligned instruction heads")
    LOG.append("odd heads deleted %d (%d B) in %d runs; odd funcs deleted %d" % (
        len(heads), sum(r[3] for r in runs), len(runs), len(oddf)))


def main():
    ida_auto.auto_wait()
    LOG.append("procname before %s" % ida_ida.inf_get_procname())
    if ida_ida.inf_get_procname() != "h8sxa":
        ida_idp.set_processor_type("h8sxa", ida_idp.SETPROC_USER)
        for nm in dir(ida_auto):
            if nm.startswith("AU_") and nm != "AU_NONE":
                ida_auto.auto_unmark(0, 0xFFFFFFFF, getattr(ida_auto, nm))
        ch("set_proc", 0, "h8s300a", "h8sxa", "seed decodes H8SX natively")
    LOG.append("procname now %s" % ida_ida.inf_get_procname())
    LOG.extend(verify("pre"))
    f1_fixes()
    if os.environ.get("H2_ODD", "1") == "1":
        odd_cleanup()
    LOG.extend(verify("post"))
    with open(os.path.join(OUT, "changes.tsv"), "a", encoding="utf-8", newline="\n") as h:
        for c in CH:
            h.write(c + "\n")


try:
    main()
    with open(os.path.join(WORK, "%s_log.txt" % PHASE), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\nok\n")
except Exception:
    with open(os.path.join(WORK, "%s_log.txt" % PHASE), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n" + traceback.format_exc())
idc.qexit(0)

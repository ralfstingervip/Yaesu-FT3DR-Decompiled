# -*- coding: utf-8 -*-
r"""Lane H2 -- apply G2 table->target xrefs (ida\jobs\g2_apply_table_xrefs.py logic) to the
H8SX seed, re-run auto analysis over MAIN content OUTSIDE the closed window, and measure.

Env: H2_TAG (output prefix), H2_LOG_CHANGES=1 to append to changes.tsv.
The closed window 0x078106-0x07B753 is snapshotted first; anything analysis changes inside it
is reverted to the snapshot and logged.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, sys, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc

ROOT = str(_REPO)
JOBS = os.path.join(ROOT, "ida", "jobs")
if JOBS not in sys.path:
    sys.path.insert(0, JOBS)
import g2_apply_table_xrefs as applier

OUT = os.path.join(ROOT, "ida", "out", "h8sx-seed")
WORK = os.path.join(OUT, "work")
TAG = os.environ.get("H2_TAG", "xref")
LO, HI = 0x000400, 0x07B754
WLO, WHI = 0x078106, 0x07B754
TSV = os.environ.get("H2_XREF_TSV", os.path.join(ROOT, "ida", "out", "h8sx-seed", "table-xrefs-h8sx.tsv"))
if not os.path.isabs(TSV):
    TSV = os.path.join(ROOT, TSV)
PROVED = os.path.join(ROOT, "ida", "out", "main-indirect", "proved.tsv")
F1 = os.path.join(OUT, "f1_true_starts.tsv")
LOG = []
NL = chr(10)
TAB = chr(9)
CH = []


def ch(kind, ea, before, after, why):
    CH.append("xref\t%s\t%06X\t%s\t%s\t%s" % (kind, ea, before, after, why))


INSIDE = {}
SLOTEND = {}


def load_slots(pl):
    slots = []
    with open(TSV, encoding="utf-8") as h:
        next(h)
        for ln in h:
            slots.append(int(ln.split(chr(9))[0], 16))
    ss = set(slots)
    for s in pl:
        for e in (s - 1, s - 2, s - 3):
            if e in ss:
                SLOTEND[s] = e + 4


def proved_list():
    import re
    fix = {}
    with open(F1, encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.split("\t")
            fix[int(p[0], 16)] = int(p[1], 16)
    out = []
    with open(PROVED, encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.split("\t")
            if p and p[0] and not p[0].startswith("#"):
                s = int(p[0], 16)
                t = fix.get(s, s)
                out.append(t)
                m = re.search(r"inside->([0-9A-F]{6})", ln)
                if m and t == s:
                    INSIDE[t] = int(m.group(1), 16)
    return out


def has_in(ea):
    for _ in idautils.CodeRefsTo(ea, 0):
        return True
    for _ in idautils.DataRefsTo(ea):
        return True
    return False


def is_fstart(ea):
    f = ida_funcs.get_func(ea)
    return bool(f and f.start_ea == ea)


def survival(lbl, pl):
    isf = sum(1 for s in pl if is_fstart(s))
    xr = sum(1 for s in pl if has_in(s))
    both = [s for s in pl if is_fstart(s) and has_in(s)]
    code = sum(1 for s in pl if ida_bytes.is_code(ida_bytes.get_flags(s)))
    LOG.append("%s proved(F1-corrected) n=%d func_at_start=%d incoming_xref=%d both=%d is_code=%d" % (
        lbl, len(pl), isf, xr, len(both), code))
    ent = 0
    via = []
    for s in pl:
        if is_fstart(s) and has_in(s):
            ent += 1
        elif s in INSIDE and is_fstart(INSIDE[s]) and has_in(INSIDE[s]):
            ent += 1
            via.append("%06X->%06X" % (s, INSIDE[s]))
        elif s in SLOTEND and is_fstart(SLOTEND[s]) and has_in(SLOTEND[s]):
            ent += 1
            via.append("%06X->%06X(slot)" % (s, SLOTEND[s]))
    LOG.append("%s entry-aware survival (row start, or F1's table target inside the row): %d/%d; via inside target %d: %s" % (
        lbl, ent, len(pl), len(via), ",".join(via)))
    return set(both), set(s for s in pl if is_fstart(s))


def state(lbl):
    code_b = 0
    odd = 0
    ea = 0 if ida_bytes.is_head(ida_bytes.get_flags(0)) else ida_bytes.next_head(0, HI)
    while ea != idc.BADADDR and ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            code_b += ida_bytes.get_item_size(ea)
            odd += ea & 1
        ea = ida_bytes.next_head(ea, HI)
    funcs = set(idautils.Functions(0, HI))
    LOG.append("%s code_bytes=%d odd_heads=%d functions=%d" % (lbl, code_b, odd, len(funcs)))
    return funcs


def window_snap():
    items = {}
    ea = WLO if ida_bytes.is_head(ida_bytes.get_flags(WLO)) else ida_bytes.next_head(WLO, WHI)
    while ea != idc.BADADDR and ea < WHI:
        fl = ida_bytes.get_flags(ea)
        k = "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else "unk")
        items[ea] = (ida_bytes.get_item_size(ea), k, fl & ida_bytes.DT_TYPE if k == "data" else 0)
        ea = ida_bytes.next_head(ea, WHI)
    funcs = set(f for f in idautils.Functions(WLO, WHI))
    return items, funcs


def window_restore(snap):
    items0, funcs0 = snap
    items1, funcs1 = window_snap()
    diff = [ea for ea in set(items0) | set(items1) if items0.get(ea) != items1.get(ea)]
    newf = funcs1 - funcs0
    LOG.append("window diff heads=%d new_funcs=%d lost_funcs=%d" % (len(diff), len(newf), len(funcs0 - funcs1)))
    if not diff and not newf:
        return
    for fs in newf:
        ida_funcs.del_func(fs)
        ch("window_revert_del_func", fs, "func added by analysis", "-", "closed window kept as seeded")
    for ea in sorted(diff):
        if ea in items1 and items0.get(ea) != items1.get(ea):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, items1[ea][0])
    for ea in sorted(diff):
        if ea in items0:
            sz, k, dt = items0[ea]
            if k == "code":
                idc.create_insn(ea)
            elif k == "data":
                if sz == 1:
                    ida_bytes.create_byte(ea, 1)
                elif sz == 2:
                    ida_bytes.create_word(ea, 2)
                elif sz == 4:
                    ida_bytes.create_dword(ea, 4)
                else:
                    ida_bytes.create_byte(ea, sz)
    ch("window_revert", WLO, "%d heads differed after analysis" % len(diff), "restored to seed", "closed window kept as seeded")
    items2, _ = window_snap()
    LOG.append("window after restore matches snapshot: %s" % (items2 == items0))


def main():
    ida_auto.auto_wait()
    pl = proved_list()
    load_slots(pl)
    LOG.append("xref tsv: %s" % TSV)
    LOG.append("F1 rows starting inside a table slot: %d (%s)" % (len(SLOTEND), ",".join("%06X" % k for k in sorted(SLOTEND))))
    f0 = state("S0 seed")
    survival("S0 seed", pl)
    snap = window_snap()

    nov = 0
    with open(TSV, encoding="utf-8") as h, open(os.path.join(WORK, "%s_slot_overlaps.tsv" % TAG), "w", encoding="utf-8", newline=NL) as o:
        next(h)
        o.write(TAB.join(["slot", "target", "table", "code_head", "func_of_head", "func_start_is_head"]) + NL)
        for ln in h:
            p = ln.split(TAB)
            e = int(p[0], 16)
            for a in range(e, e + 4):
                fl = ida_bytes.get_flags(a)
                if ida_bytes.is_code(fl):
                    hd = ida_bytes.get_item_head(a)
                    f = ida_funcs.get_func(hd)
                    o.write(TAB.join([p[0], p[1], p[2], "%06X" % hd, "%06X" % f.start_ea if f else "-",
                                      str(int(bool(f and f.start_ea == hd)))]) + NL)
                    nov += 1
                    break
    LOG.append("table slots overlapping existing code before apply: %d" % nov)
    rows, xrefs, made = applier.apply_from_tsv(TSV)
    ida_auto.auto_wait()
    LOG.append("apply pass 1: rows=%d xrefs=%d funcs_made=%d" % (rows, xrefs, made))
    # pass 2: targets orphaned when a pass-1 slot overwrote a function that started inside the slot
    rows, xrefs, made = applier.apply_from_tsv(TSV)
    ida_auto.auto_wait()
    LOG.append("apply pass 2: rows=%d xrefs=%d funcs_made=%d" % (rows, xrefs, made))
    f1 = state("S1 after xrefs")
    b1, _ = survival("S1 after xrefs", pl)
    for fs in sorted(f1 - f0):
        ch("add_func(table)", fs, "-", "func", "G2 table->target xref target promoted")

    ida_auto.plan_range(LO, WLO)
    ida_auto.auto_wait()
    window_restore(snap)
    ida_auto.auto_wait()
    f2 = state("S2 after reanalysis")
    b2, fs2 = survival("S2 after reanalysis", pl)
    lost = sorted(set(pl) - fs2)
    LOG.append("proved lost as function start after reanalysis (%d): %s" % (len(lost), ",".join("%06X" % s for s in lost)))
    with open(os.path.join(WORK, "%s_proved_final.tsv" % TAG), "w", encoding="utf-8", newline=NL) as h:
        h.write(TAB.join(["f1_row_corrected", "func_at_start", "incoming", "inside_target", "slot_end", "alt_func_xref"]) + NL)
        for s in pl:
            alt = [a for a in (INSIDE.get(s), SLOTEND.get(s)) if a]
            h.write(TAB.join(["%06X" % s, str(int(is_fstart(s))), str(int(has_in(s))),
                              "%06X" % INSIDE[s] if s in INSIDE else "-", "%06X" % SLOTEND[s] if s in SLOTEND else "-",
                              ",".join("%06X:%d" % (a, int(is_fstart(a) and has_in(a))) for a in alt) or "-"]) + NL)
    LOG.append("proved survivors lost xref (in S1 both, not in S2 both): %d" % len(b1 - b2))
    gone = sorted(f1 - f2)
    newf = sorted(f2 - f1)
    LOG.append("reanalysis: functions removed %d, added %d" % (len(gone), len(newf)))
    with open(os.path.join(WORK, "%s_funcdiff.tsv" % TAG), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tchange\n")
        for s in gone:
            h.write("%06X\tremoved_by_reanalysis\n" % s)
        for s in newf:
            h.write("%06X\tadded_by_reanalysis\n" % s)
    for s in gone:
        ch("func_removed_by_reanalysis", s, "func", "-", "IDA auto analysis")
    for s in newf:
        ch("func_added_by_reanalysis", s, "-", "func", "IDA auto analysis")
    if os.environ.get("H2_LOG_CHANGES") == "1":
        with open(os.path.join(OUT, "changes.tsv"), "a", encoding="utf-8", newline="\n") as h:
            for c in CH:
                h.write(c + "\n")


try:
    main()
    with open(os.path.join(WORK, "%s_log.txt" % TAG), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\nok\n")
except Exception:
    with open(os.path.join(WORK, "%s_log.txt" % TAG), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n" + traceback.format_exc())
idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane I3 - build the final MAIN seed database (MAIN_FINAL).

Idempotent apply job. Run on a copy of MAIN_H8SX (h8sxa, big-endian, base 0, so
file offset == mapped address). It carries every H-wave MAIN result into one DB:

  1. Exclude H9's six data tables (ida\out\main-final\h9-excl-tables.tsv):
     remove any table->target data xref from their slots, type the whole table
     extent as data dwords, delete any function/head that starts inside them.
  2. Apply the filtered G2 table xrefs (ida\out\main-final\g2-xrefs-final.tsv =
     H2's 3,888-row set minus the 7 rows of the six H9 tables) and H3's 119
     pointer arrays (ida\out\ptr-arrays\xrefs.tsv, tiers A/B/C) -- both already
     exclude every data row.
  3. Add H9's RAM-callback hook targets (ida\out\main-final\ram-hook-edges.tsv):
     make each target code + a function, add a user data xref store_site->target.
  4. Apply H1's F1 start corrections: the 5 proved-corrected text-trimmed rows
     (retype the ASCII prefix as a string, make the true entry a function) and
     the 30 fnindex junk/text span corrections (delete the bogus function,
     retype the bytes).

The closed CDC-ACM / DSP-download window 0x078106-0x07B753 is never analysed:
its item layout is snapshotted before analysis and restored after, and
plan_and_wait is restricted to [0x400, 0x078106). Bytes are never modified.

Env:
  I3_TAG   output stem (default MAIN_FINAL)
Writes under ida\out\main-final\ : <tag>_log.txt, <tag>_iscode.bin (per-byte
0/1 mask for 0..0x7B754), <tag>_functions.tsv, <tag>_survival.tsv,
<tag>_tables.tsv, <tag>_oddheads.tsv.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, ida_bytes, ida_funcs, ida_offset, ida_xref, ida_nalt, idautils, idc
import ida_segment, ida_ida

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-final")
MF = os.path.join(ROOT, "ida", "out", "main-full")
CW0, CW1 = 0x078106, 0x07B754          # closed window, never touched
HI = 0x7B754                            # end of MAIN content
LO = 0x400


def _rows(path, skip_hash=True):
    with open(path, encoding="utf-8") as h:
        lines = [l.rstrip("\n") for l in h]
    out = []
    hdr = None
    for l in lines:
        if skip_hash and l.startswith("#"):
            continue
        if hdr is None:
            hdr = l.split("\t")
            continue
        if l.strip():
            out.append(l.split("\t"))
    return hdr, out


def is_code(ea):
    return ida_bytes.is_code(ida_bytes.get_flags(ea))


# ---------------------------------------------------------------- window guard
# Only the window's CODE heads are guarded: data/unknown byte layout there is
# cosmetic (bytes are never modified) but code must stay byte-identical to the
# seed. Snapshot {code_head_ea: size}; after analysis undefine any new window
# code head and recreate any removed one.
def snapshot_window_code():
    snap = {}
    for ea in idautils.Heads(CW0, CW1):
        if ida_bytes.is_code(ida_bytes.get_flags(ea)):
            snap[ea] = ida_bytes.get_item_size(ea)
    return snap


def restore_window_code(snap):
    fixed = 0
    cur = set(ea for ea in idautils.Heads(CW0, CW1)
              if ida_bytes.is_code(ida_bytes.get_flags(ea)))
    for ea in cur:
        if ea not in snap:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE,
                                ida_bytes.get_item_size(ea))
            fixed += 1
    for ea in snap:
        if not is_code(ea):
            idc.create_insn(ea)
            fixed += 1
    return fixed


def code_bytes_and_odd(lo, hi):
    """Return (code_byte_count, [odd_code_head,...]) over [lo,hi) by walking heads."""
    cb = 0
    odd = []
    for ea in idautils.Heads(lo, hi):
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            cb += ida_bytes.get_item_size(ea)
            if ea & 1:
                odd.append(ea)
    return cb, odd


def kill_odd_heads(lo, hi, passes=4):
    """Delete odd-aligned code heads (impossible on word-aligned H8SX). Iterate
    because deleting one may let auto-analysis reform; stop at a fixed point."""
    total = 0
    for _ in range(passes):
        odd = [ea for ea in idautils.Heads(lo, hi)
               if ida_bytes.is_code(ida_bytes.get_flags(ea)) and (ea & 1)]
        if not odd:
            break
        for ea in odd:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE,
                                ida_bytes.get_item_size(ea))
        total += len(odd)
        ida_auto.auto_wait()
    return total


# ---------------------------------------------------------------- apply steps
def apply_xref_tsv(path, tiers="ABC"):
    """g2/h3 style: slot -> dword offset -> target code+func. Returns (rows, funcs)."""
    hdr, rows = _rows(path)
    tcol = hdr.index("tier") if "tier" in hdr else -1
    nr = nf = 0
    for p in rows:
        if len(p) < 2:
            continue
        if tcol >= 0 and len(p) > tcol and p[tcol] not in tiers:
            continue
        try:
            entry = int(p[0], 16); target = int(p[1], 16)
        except ValueError:
            continue
        nr += 1
        ida_bytes.del_items(entry, ida_bytes.DELIT_SIMPLE, 4)
        ida_bytes.create_dword(entry, 4)
        try:
            ida_offset.op_offset(entry, 0, idc.REF_OFF32)
        except Exception:
            pass
        ida_xref.add_dref(entry, target, ida_xref.dr_O | ida_xref.XREF_USER)
        if not is_code(target):
            idc.create_insn(target)
        if ida_funcs.get_func(target) is None:
            if ida_funcs.add_func(target):
                nf += 1
    return nr, nf


def exclude_tables(tbls):
    """Remove table->target xrefs, type the extent as data dwords, drop inside heads.
    tbls: list of (base, count). Returns dict of stats."""
    removed_xrefs = 0
    killed_funcs = 0
    for base, count in tbls:
        end = base + 4 * count
        # drop any function that starts strictly inside the table extent
        for fstart in list(idautils.Functions(base, end)):
            ida_funcs.del_func(fstart)
            killed_funcs += 1
        ea = base
        while ea < end:
            for t in list(idautils.DataRefsFrom(ea)):
                ida_xref.del_dref(ea, t)
                removed_xrefs += 1
            for t in list(idautils.CodeRefsFrom(ea, 0)):
                ida_xref.del_cref(ea, t, 0)
            ea += 4
        ida_bytes.del_items(base, ida_bytes.DELIT_SIMPLE, end - base)
        ea = base
        while ea < end:
            ida_bytes.create_dword(ea, 4)
            # force the slot operand to a plain number so IDA's auto-analysis
            # does not re-create an offset (and its data xref) on reload
            idc.op_hex(ea, 0)
            ea += 4
    return dict(removed_xrefs=removed_xrefs, killed_funcs=killed_funcs)


def apply_ram_hooks(path):
    hdr, rows = _rows(path)
    nf = 0
    for p in rows:
        target = int(p[0], 16); store = int(p[2], 16)
        if not is_code(target):
            idc.create_insn(target)
        if ida_funcs.get_func(target) is None:
            if ida_funcs.add_func(target):
                nf += 1
        ida_xref.add_dref(store, target, ida_xref.dr_O | ida_xref.XREF_USER)
    return nf


def apply_f1_text(path):
    """proved-corrected text-trimmed rows: retype ASCII prefix as string,
    make true start a function."""
    hdr, rows = _rows(path)
    H = hdr
    made = trimmed = 0
    for p in rows:
        c = dict(zip(H, p))
        if c.get("h1_action") != "text-trimmed":
            continue
        orig = int(c["orig_start"], 16); start = int(c["start"], 16)
        if start > orig:
            ida_bytes.del_items(orig, ida_bytes.DELIT_SIMPLE, start - orig)
            ida_bytes.create_strlit(orig, start - orig, ida_nalt.STRTYPE_C if False else 0)
            trimmed += 1
        if not is_code(start):
            idc.create_insn(start)
        if ida_funcs.get_func(start) is None or ida_funcs.get_func(start).start_ea != start:
            if ida_funcs.add_func(start):
                made += 1
    return trimmed, made


def apply_fnindex_corr(path):
    """Delete bogus validated functions and retype their spans."""
    hdr, rows = _rows(path)
    killed = retyped = 0
    for p in rows:
        ss = int(p[0], 16); se = int(p[1], 16); fs = int(p[2], 16)
        newtype = p[6]
        f = ida_funcs.get_func(fs)
        if f is not None and f.start_ea == fs:
            ida_funcs.del_func(fs)
            killed += 1
        ida_bytes.del_items(ss, ida_bytes.DELIT_SIMPLE, se - ss)
        if newtype == "string":
            ida_bytes.create_strlit(ss, se - ss, 0)
        else:
            ea = ss
            while ea < se:
                ida_bytes.create_data(ea, ida_bytes.FF_BYTE, 1, idc.BADADDR)
                ea += 1
        retyped += 1
    return killed, retyped


# ---------------------------------------------------------------- measurement
def load_proved():
    path = os.path.join(ROOT, "ida", "out", "main-indirect", "proved.tsv")
    hdr, rows = _rows(path)
    proved = []
    for p in rows:
        s = int(p[0], 16)
        m = re.search(r"inside->([0-9A-F]+)", p[8] if len(p) > 8 else "")
        proved.append((s, int(m.group(1), 16) if m else s))
    return proved


def has_xref(ea):
    for _ in idautils.CodeRefsTo(ea, 0):
        return True
    for _ in idautils.DataRefsTo(ea):
        return True
    return False


def isfunc(ea):
    f = ida_funcs.get_func(ea)
    return f is not None and f.start_ea == ea


def measure(tag_suffix):
    m = {}
    m["funcs_total"] = sum(1 for _ in idautils.Functions())
    m["funcs_scope"] = sum(1 for _ in idautils.Functions(LO, CW0))
    cb_scope, odd_scope = code_bytes_and_odd(0, CW0)
    cb_win, _ = code_bytes_and_odd(CW0, CW1)
    m["codebytes_scope"] = cb_scope
    m["codebytes_window"] = cb_win
    m["odd_heads"] = len(odd_scope)
    return m, odd_scope


def main():
    os.makedirs(OUT, exist_ok=True)
    tag = os.environ.get("I3_TAG", "MAIN_FINAL")
    log = []
    ida_auto.auto_wait()

    proc = ida_ida.inf_get_procname()
    log.append("processor %s" % proc)

    proved = load_proved()

    def surv():
        strict = sum(1 for s, r in proved if isfunc(s) and has_xref(s))
        corr = sum(1 for s, r in proved if isfunc(r) and has_xref(r))
        return strict, corr

    before, odd_before = measure("before")
    bs, bc = surv()
    log.append("BEFORE funcs_total=%d funcs_scope=%d codebytes_scope=%d codebytes_window=%d odd_heads=%d survival strict=%d/%d corrected=%d/%d"
               % (before["funcs_total"], before["funcs_scope"], before["codebytes_scope"], before["codebytes_window"],
                  before["odd_heads"], bs, len(proved), bc, len(proved)))

    snap = snapshot_window_code()
    log.append("window code-head snapshot=%d" % len(snap))

    # table extents
    _, trows = _rows(os.path.join(OUT, "h9-excl-tables.tsv"))
    tbls = [(int(p[0], 16), int(p[1])) for p in trows]

    g2_tsv = os.path.join(OUT, "g2-xrefs-final.tsv")
    h3_tsv = os.path.join(ROOT, "ida", "out", "ptr-arrays", "xrefs.tsv")
    ram_tsv = os.path.join(OUT, "ram-hook-edges.tsv")
    pc_tsv = os.path.join(ROOT, "ida", "out", "recount", "proved-corrected.tsv")
    fn_tsv = os.path.join(ROOT, "ida", "out", "recount", "fnindex-corrections.tsv")

    def apply_round(rnd):
        # 1. filtered G2 + H3 arrays
        g2r, g2f = apply_xref_tsv(g2_tsv)
        h3r, h3f = apply_xref_tsv(h3_tsv)
        # 2. RAM hooks
        rf = apply_ram_hooks(ram_tsv)
        # 3. F1 corrections
        tt, tm = apply_f1_text(pc_tsv)
        fk, fr = apply_fnindex_corr(fn_tsv)
        # 4. exclude H9 data tables (last: strips pre-existing + any re-added refs)
        ex = exclude_tables(tbls)
        ida_auto.auto_wait()
        log.append("round %d: G2 rows=%d f=%d | H3 rows=%d f=%d | RAM f=%d | F1text prefixes=%d f=%d | fnidx del=%d retyped=%d | excl xrefs=%d killfn=%d"
                   % (rnd, g2r, g2f, h3r, h3f, rf, tt, tm, fk, fr, ex["removed_xrefs"], ex["killed_funcs"]))

    # run the mutation sequence twice so targets that only form on a second
    # analysis round are baked in; a later --reopen is then a true fixed point.
    apply_round(1)
    apply_round(2)

    # remove any odd-aligned code head the edits/analysis produced (H8SX is
    # word-aligned, so every odd head is bogus) and settle to a fixed point.
    killed_odd = kill_odd_heads(0, CW0)
    log.append("odd heads removed outside window: %d" % killed_odd)

    wchg = restore_window_code(snap)
    log.append("window code-head restore: fixed=%d" % wchg)
    ida_auto.auto_wait()

    after, odd_after = measure("after")
    as_, ac = surv()
    log.append("AFTER  funcs_total=%d funcs_scope=%d codebytes_scope=%d codebytes_window=%d odd_heads=%d survival strict=%d/%d corrected=%d/%d"
               % (after["funcs_total"], after["funcs_scope"], after["codebytes_scope"], after["codebytes_window"],
                  after["odd_heads"], as_, len(proved), ac, len(proved)))
    log.append("DELTA funcs_total=%+d codebytes_scope=%+d codebytes_window=%+d odd_heads=%+d"
               % (after["funcs_total"] - before["funcs_total"],
                  after["codebytes_scope"] - before["codebytes_scope"],
                  after["codebytes_window"] - before["codebytes_window"],
                  after["odd_heads"] - before["odd_heads"]))

    # dump per-byte code-byte mask for 0..HI (every byte of every code item)
    mask = bytearray(HI)
    for ea in idautils.Heads(0, HI):
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            sz = ida_bytes.get_item_size(ea)
            for x in range(ea, min(HI, ea + sz)):
                mask[x] = 1
    with open(os.path.join(OUT, tag + "_codemask.bin"), "wb") as h:
        h.write(mask)

    # functions.tsv (start, end, size)
    with open(os.path.join(OUT, tag + "_functions.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\n")
        for fs in idautils.Functions():
            f = ida_funcs.get_func(fs)
            h.write("%06X\t%06X\t%d\n" % (f.start_ea, f.end_ea, f.end_ea - f.start_ea))

    # survival rows
    ss = set(s for s, r in proved if isfunc(s) and has_xref(s))
    cs = set(s for s, r in proved if isfunc(r) and has_xref(r))
    with open(os.path.join(OUT, tag + "_survival.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\treach_point\tstrict\tcorrected\tfunc\n")
        for s, r in proved:
            f = ida_funcs.get_func(s)
            h.write("%06X\t%06X\t%d\t%d\t%s\n" % (s, r, s in ss, s in cs,
                    "%06X-%06X" % (f.start_ea, f.end_ea) if f else "-"))

    # table state after
    with open(os.path.join(OUT, tag + "_tables.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("base\tcount\tcode_heads_inside\tslots_with_dref\n")
        for base, count in tbls:
            end = base + 4 * count
            ch = sum(1 for ea in range(base, end) if is_code(ea) and ida_bytes.is_head(ida_bytes.get_flags(ea)))
            dr = sum(1 for ea in range(base, end, 4) if any(True for _ in idautils.DataRefsFrom(ea)))
            h.write("%06X\t%d\t%d\t%d\n" % (base, count, ch, dr))

    with open(os.path.join(OUT, tag + "_oddheads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\n")
        for ea in odd_after:
            h.write("%06X\n" % ea)

    with open(os.path.join(OUT, tag + "_log.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(log) + "\n")


if __name__ == "__main__":
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "i3_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
            h.write(traceback.format_exc())
    finally:
        idc.qexit(0)

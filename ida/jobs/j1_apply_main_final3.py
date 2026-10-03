# -*- coding: utf-8 -*-
r"""Lane J1 - build MAIN_FINAL3 from MAIN_FINAL2 (idempotent, reusable).

Owner-side static analysis. No image byte is modified (no patch_* call); only the DB item
layout, functions and cross-references change. The closed window 0x078106-0x07B753 is never
analysed: its code heads are snapshotted and restored, and the job asserts it is unchanged.

MAIN_FINAL3 = MAIN_FINAL2 (368,432 proven) + I15's record-field callback rule (+54 B proven):
  records 0x028C2A / 0x028C8A, field +0x14 -> handler, field +0x1C -> handler, dispatched by 0x028CBC.
  Targets: 0x02A924 (10 B, already code), 0x02A9F4 (10 B, already code),
           0x028C4A (16 B, new code), 0x028CAA (18 B, new code).
The I12 -120 B demotion (unreachable USB-ISR blocks 0x054D22-4B, 0x054F3A-87) is a PROVEN-MASK
overlay only (final3_proven_mask.bin); those bytes stay disassembled DB code, exactly as the
FINAL2 convention keeps the proven mask a separate overlay from the DB code mask. See doc 69.

Run (first time, then --reopen):
  python ida\run_job.py --script ida\jobs\j1_apply_main_final3.py --db J1_MAIN_FINAL3 --copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64
  python ida\run_job.py --script ida\jobs\j1_apply_main_final3.py --db J1_MAIN_FINAL3 --reopen
Env J1_TAG = pass label for the log (default 'pass').
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, hashlib, traceback
import ida_auto, ida_bytes, ida_funcs, ida_offset, ida_xref, ida_ua, idautils, idc, ida_ida

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-final3")
CW0, CW1 = 0x078106, 0x07B754
HI = 0x7B754
TAG = os.environ.get("J1_TAG", "pass")
LOG = []

# ---- I15 record-field callback rule (the +54 B) ----------------------------------
TARGETS = [(0x02A924, 10), (0x02A9F4, 10), (0x028C4A, 16), (0x028CAA, 18)]
REC_OFFS = [(0x028C3E, 0x02A924), (0x028C46, 0x028C4A), (0x028C9E, 0x02A9F4), (0x028CA6, 0x028CAA)]  # offset-cell -> value
CREFS = [(0x028D8C, 0x02A924), (0x028D8C, 0x02A9F4), (0x028DA8, 0x028C4A), (0x028DA8, 0x028CAA)]      # jsr @er6 site -> target
FUNCS = [0x02A924, 0x02A9F4, 0x028C4A, 0x028CAA]
# I12 demoted blocks: proven-mask overlay only (NOT changed in the DB), asserted still DB code.
I12_BLOCKS = [(0x054D22, 0x054D4C), (0x054F3A, 0x054F88)]
PROVEN_MASK = os.path.join(OUT, "final3_proven_mask.bin")


def say(s): LOG.append(s)
def flags(ea): return ida_bytes.get_flags(ea)
def is_code_head(ea, n=None):
    f = flags(ea)
    return ida_bytes.is_code(f) and ida_bytes.is_head(f) and (n is None or ida_bytes.get_item_size(ea) == n)
def has_cref(frm, to): return any(x == to for x in idautils.CodeRefsFrom(frm, 0))
def has_dref(frm, to): return any(x == to for x in idautils.DataRefsFrom(frm))
def oracle_len(ea):
    insn = ida_ua.insn_t()
    return ida_ua.decode_insn(insn, ea)


# ------------------------------------------------------------------ window guard + fingerprint
def window_heads():
    return {ea: ida_bytes.get_item_size(ea) for ea in idautils.Heads(CW0, CW1) if ida_bytes.is_code(flags(ea))}

def restore_window(snap):
    fixed = 0; cur = window_heads()
    for ea in cur:
        if ea not in snap:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, cur[ea]); fixed += 1
    for ea in snap:
        if not is_code_head(ea, snap[ea]):
            idc.create_insn(ea); fixed += 1
    return fixed

def fingerprint():
    heads = []; cb = 0; odd = []
    for ea in idautils.Heads(0, HI):
        f = flags(ea)
        if ida_bytes.is_code(f):
            sz = ida_bytes.get_item_size(ea); heads.append((ea, sz))
            if ea < CW0 or ea >= CW1: cb += sz
            if ea & 1 and not (CW0 <= ea < CW1): odd.append(ea)
    funcs = [(f, ida_funcs.get_func(f).end_ea) for f in idautils.Functions()]
    nx = 0
    for ea, sz in heads:
        nx += sum(1 for _ in idautils.XrefsFrom(ea, 0))
    win = [(a, s) for a, s in heads if CW0 <= a < CW1]
    h = hashlib.sha256(repr((heads, funcs)).encode()).hexdigest()[:16]
    wh = hashlib.sha256(repr(win).encode()).hexdigest()[:16]
    return dict(funcs=len(funcs), heads=len(heads), codebytes_scope=cb, win_heads=len(win),
                odd=len(odd), xrefs_from_code=nx, hash=h, win_hash=wh), odd

def fp_str(m):
    return " ".join("%s=%s" % (k, m[k]) for k in ("funcs", "heads", "codebytes_scope", "win_heads", "odd", "xrefs_from_code", "hash", "win_hash"))


# ------------------------------------------------------------------ edits
def expected_heads(ea, nbytes):
    """oracle tiling of [ea, ea+nbytes): list of (head, len). decode_insn reads raw bytes regardless of DB typing."""
    end = ea + nbytes; x = ea; out = []
    while x < end:
        n = oracle_len(x)
        if n <= 0:
            say("  WARN cannot decode %06X" % x); return out
        out.append((x, n)); x += n
    return out

def make_run(ea, nbytes):
    """create consecutive instructions tiling [ea, ea+nbytes); a no-op when the run is already
    correctly tiled, so existing code and its function are never disturbed (idempotent + stable)."""
    heads = expected_heads(ea, nbytes)
    if heads and all(is_code_head(h, n) for h, n in heads):
        return 0                                   # already correct: leave it (keeps FINAL2 functions intact)
    ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, nbytes)
    c = 0
    for h, n in heads:
        if not is_code_head(h, n):
            idc.create_insn(h); c += 1
    return c

def type_offsets(st):
    ch = 0
    for cell, val in REC_OFFS:
        if not (ida_bytes.is_dword(flags(cell)) and ida_bytes.is_head(flags(cell))):
            ida_bytes.del_items(cell, ida_bytes.DELIT_SIMPLE, 4); ida_bytes.create_dword(cell, 4); ch += 1
        if ida_bytes.get_dword(cell) == val and not ida_bytes.is_off0(flags(cell)):
            ida_offset.op_offset(cell, 0, idc.REF_OFF32); ch += 1
    st["offsets_typed"] = ch

def make_insns(st):
    st["insns_created"] = sum(make_run(a, n) for a, n in TARGETS)

def make_funcs(st):
    nf = 0
    for e in FUNCS:
        if is_code_head(e) and ida_funcs.get_func(e) is None:
            if ida_funcs.add_func(e): nf += 1
            else: say("  WARN add_func %06X failed" % e)
    st["funcs_added"] = nf

def add_edges(st):
    nd = nc = 0
    for cell, val in REC_OFFS:
        if not has_dref(cell, val):
            ida_xref.add_dref(cell, val, ida_xref.dr_O | ida_xref.XREF_USER); nd += 1
    for s, t in CREFS:
        if not has_cref(s, t):
            ida_xref.add_cref(s, t, ida_xref.fl_CN | ida_xref.XREF_USER); nc += 1
    st["drefs_added"] = nd; st["crefs_added"] = nc

def kill_odd(lo, hi):
    tot = 0
    for _ in range(4):
        odd = [ea for ea in idautils.Heads(lo, hi) if ida_bytes.is_code(flags(ea)) and ea & 1]
        if not odd: break
        for ea in odd:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, ida_bytes.get_item_size(ea))
        tot += len(odd); ida_auto.auto_wait()
    return tot


def round_(r, snap):
    st = {}
    type_offsets(st)
    make_insns(st)
    make_funcs(st)
    add_edges(st)
    ida_auto.auto_wait()
    c2 = sum(make_run(a, n) for a, n in TARGETS)
    type_offsets(st)
    if c2: ida_auto.auto_wait()
    st["insns_recreated"] = c2
    st["odd_killed"] = kill_odd(0, CW0) + kill_odd(CW1, HI)
    st["window_fixed"] = restore_window(snap)
    if st["window_fixed"]: ida_auto.auto_wait()
    say("round %d: %s" % (r, " ".join("%s=%s" % kv for kv in sorted(st.items()))))
    return st


def report():
    # I15 target coverage
    for a, n in TARGETS:
        say("I15 target %06X +%d: code=%d/%d func=%s" % (a, n, sum(1 for y in range(a, a + n) if ida_bytes.is_code(flags(y))), n,
            ("%06X" % ida_funcs.get_func(a).start_ea) if ida_funcs.get_func(a) else "-"))
    for cell, val in REC_OFFS:
        say("record cell %06X: dword=%06X off0=%s dref->%06X=%s" % (cell, ida_bytes.get_dword(cell), ida_bytes.is_off0(flags(cell)), val, has_dref(cell, val)))
    # I12 blocks must remain DB code (demotion is a mask overlay, not a DB change)
    for s, e in I12_BLOCKS:
        say("I12 block %06X-%06X still DB code: %d/%d" % (s, e, sum(1 for y in range(s, e) if ida_bytes.is_code(flags(y))), e - s))
    # code mask + proven-mask coverage
    mask = bytearray(HI)
    for ea in idautils.Heads(0, HI):
        if ida_bytes.is_code(flags(ea)):
            for x in range(ea, min(HI, ea + ida_bytes.get_item_size(ea))): mask[x] = 1
    with open(os.path.join(OUT, "MAIN_FINAL3_codemask.bin"), "wb") as h: h.write(bytes(mask))
    if os.path.exists(PROVEN_MASK):
        pm = open(PROVEN_MASK, "rb").read()
        prov = sum(1 for b in pm[:HI] if b)
        notcode = [x for x in range(HI) if pm[x] and not mask[x]]
        say("proven mask %d set; proven bytes that are NOT DB code: %d %s" % (prov, len(notcode), ["%06X" % x for x in notcode[:20]]))
    with open(os.path.join(OUT, "MAIN_FINAL3_functions_raw.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\n")
        for f in idautils.Functions():
            fn = ida_funcs.get_func(f); h.write("%06X\t%06X\t%d\n" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea))


def main():
    os.makedirs(OUT, exist_ok=True)
    say("=== %s  processor %s" % (TAG, ida_ida.inf_get_procname()))
    before, _ = fingerprint()
    say("BEFORE " + fp_str(before))
    snap = window_heads()
    wpath = os.path.join(OUT, "window_seed.tsv")
    if not os.path.exists(wpath):
        with open(wpath, "w", encoding="utf-8", newline="\n") as h:
            h.write("ea\tsize\n" + "".join("%06X\t%d\n" % kv for kv in sorted(snap.items())))
    seed = {}
    with open(wpath, encoding="utf-8") as h:
        h.readline()
        for ln in h:
            a, s = ln.split("\t"); seed[int(a, 16)] = int(s)
    say("window snapshot %d heads; equals seed file: %s" % (len(snap), snap == seed))
    round_(1, seed)
    round_(2, seed)
    after, odd = fingerprint()
    say("AFTER  " + fp_str(after))
    say("DELTA funcs=%+d heads=%+d codebytes_scope=%+d odd=%+d xrefs_from_code=%+d hash_same=%s win_same=%s" % (
        after["funcs"] - before["funcs"], after["heads"] - before["heads"], after["codebytes_scope"] - before["codebytes_scope"],
        after["odd"] - before["odd"], after["xrefs_from_code"] - before["xrefs_from_code"],
        after["hash"] == before["hash"], after["win_hash"] == before["win_hash"]))
    say("odd heads outside window: %d; window equals seed: %s" % (after["odd"], window_heads() == seed))
    report()


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
    with open(os.path.join(OUT, "j1_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    with open(os.path.join(OUT, "MAIN_FINAL3_log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n")
    idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane I14 - build MAIN_FINAL2 from MAIN_FINAL (idempotent, reusable).

Owner-side static analysis. No image byte is modified (no patch_* call); only the DB item
layout, functions and cross-references change. The closed window 0x078106-0x07B753 is never
analysed: its code heads are snapshotted and restored, and the job asserts it is unchanged.

Run (first time, then --reopen):
  python ida\run_job.py --script ida\jobs\i14_apply_final2.py --db MAIN_FINAL2 --copy-from ida\db\jobs\MAIN_FINAL\MAIN_FINAL.i64
  python ida\run_job.py --script ida\jobs\i14_apply_final2.py --db MAIN_FINAL2 --reopen
Env I14_TAG = pass label for the log (default 'pass').

Inputs (all under ida\out\):
  main-final2\merged-insns.tsv   820 oracle instructions of the merged I6+I8+I9 byte union (i14_merge.py)
  main-final2\seed-edges.tsv     exit-table slots/calls (I6), record fields + callbacks + RAM hook (I9),
                                 0x034CCE + tier-X 0x003272 (I8)
  indirect-cb\sites.tsv          I8's 267 sites -> targets (same logic as i8_apply_cb_xrefs.py, minus present xrefs)
  main-final\proven-not-dbcode.tsv  I3's 16 lead-in sites
Steps per round (two rounds per pass; a later --reopen pass must change nothing):
  1. data typing: exit table 0x019A9E (206 BE16 words), tier-X table 0x003272 (3 dword offsets),
     I9 records 0x0296E8/0x029712 (8 dwords each, offsets on code fields), I8 byte tables
     0x034CBA/0x034CC4 (10 B each, read by 0x034C9A/0x034CAC), popcount table 0x000A8C (256 B);
  2. delete bogus sub_760 (I9) and the +2 functions at the lead-in sites; create every merged
     instruction at its oracle length; fix the 16 lead-in heads;
  3. functions at call/handler entries (exit entries, record targets, 0x000706, 0x034CCE, 0x01A084, lead-in call targets);
  4. crefs/drefs (user) for every seed edge and I8 site edge not already present;
  5. auto_wait (own edits only), odd-head sweep outside the window, window restore.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, hashlib, traceback
import ida_auto, ida_bytes, ida_funcs, ida_offset, ida_xref, ida_ua, idautils, idc, ida_ida

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-final2")
CW0, CW1 = 0x078106, 0x07B754
HI = 0x7B754
TAG = os.environ.get("I14_TAG", "pass")
LOG = []


def say(s):
    LOG.append(s)


def tsv(path):
    with open(path, encoding="utf-8") as h:
        rows = [l.rstrip("\n").split("\t") for l in h if l.strip() and not l.startswith("#")]
    return rows[0], rows[1:]


def flags(ea):
    return ida_bytes.get_flags(ea)


def is_code_head(ea, n=None):
    f = flags(ea)
    return ida_bytes.is_code(f) and ida_bytes.is_head(f) and (n is None or ida_bytes.get_item_size(ea) == n)


def has_cref(frm, to):
    return any(x == to for x in idautils.CodeRefsFrom(frm, 0))


def has_dref(frm, to):
    return any(x == to for x in idautils.DataRefsFrom(frm))


# ------------------------------------------------------------------ inputs
_, INS = tsv(os.path.join(OUT, "merged-insns.tsv"))
INS = [(int(r[0], 16), int(r[1]), r[3]) for r in INS]
_, EDG = tsv(os.path.join(OUT, "seed-edges.tsv"))
EDG = [(int(r[0], 16), int(r[1], 16), r[2], r[3]) for r in EDG]
_, I8S = tsv(os.path.join(ROOT, "ida", "out", "indirect-cb", "sites.tsv"))
I8E = []
for c in I8S:
    if c[3] == "closed_window" or c[6] in ("-", ""):
        continue
    site = int(c[0], 16)
    for t in c[6].split(","):
        t = int(t.strip(), 16)
        if CW0 <= t < CW1 or CW0 <= site < CW1:
            continue
        I8E.append((site, c[1] == "jsr", t))
_, LEAD = tsv(os.path.join(ROOT, "ida", "out", "main-final", "proven-not-dbcode.tsv"))
LEAD = sorted(set(int(r[0], 16) for r in LEAD))
# 04CAD2 is the tail of the oracle instruction at 04CACE; one fix covers both rows
INSLEN = {a: n for a, n, _ in INS}

CALL_ENTRIES = set(t for s, t, k, l in EDG if k == "call") | {0x000706, 0x034CCE}
TABLES_BYTE = [(0x034CBA, 10), (0x034CC4, 10), (0x000A8C, 256)]
EXIT_TAB, EXIT_N = 0x019A9E, 206
TIERX_TAB = 0x003272
RECORDS = (0x0296E8, 0x029712)
BOGUS_FUNCS = [0x000760]


def oracle_len(ea):
    insn = ida_ua.insn_t()
    return ida_ua.decode_insn(insn, ea)


# ------------------------------------------------------------------ window guard + fingerprints
def window_heads():
    return {ea: ida_bytes.get_item_size(ea) for ea in idautils.Heads(CW0, CW1) if ida_bytes.is_code(flags(ea))}


def restore_window(snap):
    fixed = 0
    cur = window_heads()
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
    return dict(funcs=len(funcs), heads=len(heads), codebytes_scope=cb, codebytes_window=sum(s for _, s in win),
                win_heads=len(win), odd=len(odd), xrefs_from_code=nx, hash=h, win_hash=wh), odd


def fp_str(m):
    return " ".join("%s=%s" % (k, m[k]) for k in ("funcs", "heads", "codebytes_scope", "codebytes_window", "win_heads", "odd", "xrefs_from_code", "hash", "win_hash"))


# ------------------------------------------------------------------ steps
def ensure_insn(ea, n):
    if is_code_head(ea, n):
        return 0
    ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, n)
    ok = idc.create_insn(ea)
    if not is_code_head(ea, n):
        say("  WARN create_insn %06X len %d failed (ok=%s, size=%d)" % (ea, n, ok, ida_bytes.get_item_size(ea)))
    return 1


def type_data(st):
    ch = 0
    # exit table: 206 BE16 words; drop any code inside
    end = EXIT_TAB + 2 * EXIT_N
    if any(ida_bytes.is_code(flags(ea)) for ea in idautils.Heads(EXIT_TAB, end)) or \
            not all(ida_bytes.is_word(flags(EXIT_TAB + 2 * i)) for i in range(EXIT_N)):
        for f in list(idautils.Functions(EXIT_TAB, end)):
            ida_funcs.del_func(f)
        ida_bytes.del_items(EXIT_TAB, ida_bytes.DELIT_SIMPLE, end - EXIT_TAB)
        for i in range(EXIT_N):
            ida_bytes.create_word(EXIT_TAB + 2 * i, 2); idc.op_hex(EXIT_TAB + 2 * i, 0)
        ch += 1
    # dword offset tables / records
    dw = [(TIERX_TAB + 4 * i) for i in range(3)] + [r + 4 * i for r in RECORDS for i in range(8)] + [0x03467C]   # I8: H2-excluded slot is a code pointer
    for ea in dw:
        if not ida_bytes.is_dword(flags(ea)) or not ida_bytes.is_head(flags(ea)):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 4); ida_bytes.create_dword(ea, 4); ch += 1
        v = ida_bytes.get_dword(ea)
        if v and v < HI and v % 2 == 0:
            if not ida_bytes.is_off0(flags(ea)):
                ida_offset.op_offset(ea, 0, idc.REF_OFF32); ch += 1
    # byte tables
    for b, n in TABLES_BYTE:
        if not (ida_bytes.is_data(flags(b)) and ida_bytes.is_head(flags(b)) and ida_bytes.get_item_size(b) == n):
            for f in list(idautils.Functions(b, b + n)):
                ida_funcs.del_func(f)
            ida_bytes.del_items(b, ida_bytes.DELIT_SIMPLE, n)
            ida_bytes.create_data(b, ida_bytes.FF_BYTE, n, idc.BADADDR); ch += 1
    st["data_typed"] = st.get("data_typed", 0) + ch


def kill_bogus_funcs(st):
    k = 0
    for f in BOGUS_FUNCS:
        fn = ida_funcs.get_func(f)
        if fn is not None and fn.start_ea == f:
            ida_funcs.del_func(f); k += 1
    # functions that start strictly inside a merged instruction or a lead-in instruction
    starts = set()
    for a, n, _ in INS:
        for x in range(a + 1, a + n):
            starts.add(x)
    for s in LEAD:
        a = s if s != 0x04CAD2 else 0x04CACE
        n = oracle_len(a)
        for x in range(a + 1, a + n):
            starts.add(x)
    for x in sorted(starts):
        fn = ida_funcs.get_func(x)
        if fn is not None and fn.start_ea == x:
            ida_funcs.del_func(x); k += 1
    st["funcs_deleted"] = k


def make_insns(st):
    c = 0
    for a, n, _ in INS:
        c += ensure_insn(a, n)
    st["insns_created"] = c
    # lead-in fixes
    lf = 0; skipped = []
    for s in LEAD:
        a = 0x04CACE if s == 0x04CAD2 else s
        n = oracle_len(a)
        h0 = ida_bytes.get_item_head(a)
        if h0 != a and ida_bytes.is_code(flags(h0)) and h0 + ida_bytes.get_item_size(h0) > a:
            skipped.append("%06X (inside item %06X)" % (a, h0)); continue
        lf += ensure_insn(a, n)
    st["leadin_fixed"] = lf
    if skipped:
        say("  lead-in skipped: " + ", ".join(skipped))


def make_funcs(st):
    nf = 0
    ents = set(CALL_ENTRIES)
    ents |= {0x016A16}            # lead-in site that is a call target (0x0169FE jsr)
    for e in sorted(ents):
        if CW0 <= e < CW1:
            continue
        if not is_code_head(e):
            continue
        fn = ida_funcs.get_func(e)
        if fn is None:
            if ida_funcs.add_func(e):
                nf += 1
            else:
                say("  WARN add_func %06X failed" % e)
    st["funcs_added"] = nf


def add_edges(st):
    nc = nd = 0
    for s, t, k, lane in EDG:
        if k in ("call", "jump"):
            fl = ida_xref.fl_CN if k == "call" else ida_xref.fl_JN
            if not has_cref(s, t):
                ida_xref.add_cref(s, t, fl | ida_xref.XREF_USER); nc += 1
                if st.get("verbose"):
                    say("  cref added %06X -> %06X (%s %s)" % (s, t, k, lane))
        else:   # slot16rel, slot32, imm
            if not has_dref(s, t):
                ida_xref.add_dref(s, t, ida_xref.dr_O | ida_xref.XREF_USER); nd += 1
                if st.get("verbose"):
                    say("  dref added %06X -> %06X (%s %s) now present=%s" % (s, t, k, lane, has_dref(s, t)))
    n8 = 0
    for s, is_call, t in I8E:
        if not has_cref(s, t):
            ida_xref.add_cref(s, t, (ida_xref.fl_CN if is_call else ida_xref.fl_JN) | ida_xref.XREF_USER); n8 += 1
    st["crefs_added"] = nc; st["drefs_added"] = nd; st["i8_crefs_added"] = n8


def kill_odd(lo, hi):
    tot = 0
    for _ in range(4):
        odd = [ea for ea in idautils.Heads(lo, hi) if ida_bytes.is_code(flags(ea)) and ea & 1]
        if not odd:
            break
        for ea in odd:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, ida_bytes.get_item_size(ea))
        tot += len(odd)
        ida_auto.auto_wait()
    return tot


def round_(r, snap):
    st = {"verbose": r > 1 or TAG != "pass1"}
    type_data(st)
    kill_bogus_funcs(st)
    make_insns(st)
    make_funcs(st)
    add_edges(st)
    ida_auto.auto_wait()
    # second instruction pass: analysis may have re-formed an item over a merged instruction
    c2 = sum(ensure_insn(a, n) for a, n, _ in INS)
    type_data(st)
    if c2:
        ida_auto.auto_wait()
    st["insns_recreated"] = c2
    st["odd_killed"] = kill_odd(0, CW0) + kill_odd(CW1, HI)
    st["window_fixed"] = restore_window(snap)
    if st["window_fixed"]:
        ida_auto.auto_wait()
    say("round %d: %s" % (r, " ".join("%s=%s" % kv for kv in sorted(st.items()))))
    return st


def report():
    # merged instruction state
    bad = []
    with open(os.path.join(OUT, "MAIN_FINAL2_insncheck.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("addr\toracle_len\tida_decode_len\tis_code_head\titem_size\tfunc\tlanes\n")
        for a, n, lanes in INS:
            L = oracle_len(a); ok = is_code_head(a, n); fn = ida_funcs.get_func(a)
            if not ok or L != n:
                bad.append(a)
            h.write("%06X\t%d\t%d\t%d\t%d\t%s\t%s\n" % (a, n, L, int(ok), ida_bytes.get_item_size(a),
                                                     ("%06X" % fn.start_ea) if fn else "-", lanes))
    say("merged insns: %d, decode-length mismatches or non-heads: %d %s" % (len(INS), len(bad), ["%06X" % b for b in bad[:20]]))
    say("merged insns outside any function: %d" % sum(1 for a, n, _ in INS if ida_funcs.get_func(a) is None))
    mask = bytearray(HI)
    for ea in idautils.Heads(0, HI):
        if ida_bytes.is_code(flags(ea)):
            for x in range(ea, min(HI, ea + ida_bytes.get_item_size(ea))):
                mask[x] = 1
    with open(os.path.join(OUT, "MAIN_FINAL2_codemask.bin"), "wb") as h:
        h.write(bytes(mask))
    with open(os.path.join(OUT, "MAIN_FINAL2_functions_raw.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\n")
        for f in idautils.Functions():
            fn = ida_funcs.get_func(f)
            h.write("%06X\t%06X\t%d\n" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea))
    # lead-in sites
    for s in LEAD:
        a = 0x04CACE if s == 0x04CAD2 else s
        say("lead-in %06X: code head=%s size=%d decode=%d func=%s" % (a, is_code_head(a), ida_bytes.get_item_size(a), oracle_len(a),
                                                                   ("%06X" % ida_funcs.get_func(a).start_ea) if ida_funcs.get_func(a) else "-"))
    # data extents: code heads inside
    for b, n, nm in [(EXIT_TAB, 2 * EXIT_N, "exit table"), (TIERX_TAB, 12, "tier-X table"), (0x0296E8, 32, "record 0296E8"),
                     (0x029712, 32, "record 029712"), (0x034CBA, 20, "byte tables 034CBA/034CC4"), (0x000A8C, 256, "popcount table")]:
        say("data %s %06X+%d: code heads inside %d, drefs from slots %d" % (nm, b, n,
            sum(1 for ea in idautils.Heads(b, b + n) if ida_bytes.is_code(flags(ea))),
            sum(1 for ea in range(b, b + n) for _ in idautils.DataRefsFrom(ea))))
    say("exit entries with cref from 0x0191A8: %d" % sum(1 for x in idautils.CodeRefsFrom(0x0191A8, 0)))
    for f in BOGUS_FUNCS:
        fn = ida_funcs.get_func(f)
        say("bogus %06X: func start? %s ; 0x000706 func=%s" % (f, fn is not None and fn.start_ea == f,
                                                              ("%06X-%06X" % (ida_funcs.get_func(0x706).start_ea, ida_funcs.get_func(0x706).end_ea)) if ida_funcs.get_func(0x706) else "-"))


def main():
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
    say("DELTA funcs=%+d heads=%+d codebytes_scope=%+d codebytes_window=%+d odd=%+d xrefs_from_code=%+d hash_same=%s win_same=%s" % (
        after["funcs"] - before["funcs"], after["heads"] - before["heads"], after["codebytes_scope"] - before["codebytes_scope"],
        after["codebytes_window"] - before["codebytes_window"], after["odd"] - before["odd"],
        after["xrefs_from_code"] - before["xrefs_from_code"], after["hash"] == before["hash"], after["win_hash"] == before["win_hash"]))
    say("window equals seed: %s" % (window_heads() == seed))
    report()


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
    with open(os.path.join(OUT, "i14_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    with open(os.path.join(OUT, "MAIN_FINAL2_log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n")
    idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane K1 - build MAIN_FINAL4 from J1_MAIN_FINAL3 (idempotent, reusable).

Owner-side static analysis. No image byte is modified (no patch_* call); only the DB item layout,
functions and cross-references change. The closed window 0x078106-0x07B753 is never analysed: its
code heads are snapshotted and restored, and the job asserts it is unchanged.

Inputs are produced by the offline one-descent builder ida\out\main-final4\offline\k1_build_masks.py:
  new-heads.tsv     instruction heads newly reached by the folded descent (K1a + K1b rules)
  typing-plan.tsv   code runs, the Baro/-hPa label, 99 touch-zone tables, helper slot tables, K1a cells
  crefs-plan.tsv    jsr @er6 sites -> newly credited targets
The proven/named masks are offline overlays (final4_*_mask.bin); this job makes the DB agree with them.

Run (first time, then --reopen):
  python ida\run_job.py --script ida\jobs\k1_apply_main_final4.py --db K1_MAIN_FINAL4 --copy-from ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64
  python ida\run_job.py --script ida\jobs\k1_apply_main_final4.py --db K1_MAIN_FINAL4 --reopen
Env K1_TAG = pass label for the log (default 'pass').
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, hashlib, traceback
import ida_auto, ida_bytes, ida_funcs, ida_offset, ida_xref, ida_ua, ida_name, idautils, idc, ida_ida, ida_nalt

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-final4")
CW0, CW1 = 0x078106, 0x07B754
HI = 0x7B754
TAG = os.environ.get("K1_TAG", "pass")
LOG = []
I12_BLOCKS = [(0x054D22, 0x054D4C), (0x054F3A, 0x054F88)]


def say(s): LOG.append(s)
def flags(ea): return ida_bytes.get_flags(ea)
def is_code_head(ea, n=None):
    f = flags(ea)
    return ida_bytes.is_code(f) and ida_bytes.is_head(f) and (n is None or ida_bytes.get_item_size(ea) == n)
def has_cref(frm, to): return any(x == to for x in idautils.CodeRefsFrom(frm, 0))


def tsv(name):
    rows = []
    with open(os.path.join(OUT, name), encoding="utf-8") as h:
        hdr = h.readline().rstrip("\n").split("\t")
        for ln in h:
            ln = ln.rstrip("\n")
            if ln: rows.append(dict(zip(hdr, ln.split("\t"))))
    return rows

HEADS = [(int(r["ea"], 16), int(r["len"])) for r in tsv("new-heads.tsv")]
PLAN = [(r["kind"], int(r["ea"], 16), int(r["len"]), r["arg"]) for r in tsv("typing-plan.tsv")]
CREFS = [(int(r["from"], 16), int(r["to"], 16)) for r in tsv("crefs-plan.tsv")]
RUNS = [(ea, n) for k, ea, n, a in PLAN if k == "code_run"]
ROOTS = sorted({t for f, t in CREFS})
ZONES = [(ea, n, int(a)) for k, ea, n, a in PLAN if k == "zone_table"]
PTABS = {}
for k, ea, n, a in PLAN:
    if k == "ptr_table": PTABS[ea] = max(PTABS.get(ea, 0), n)
    if k == "ptr_cell": PTABS[ea] = max(PTABS.get(ea, 0), n)
LABEL = [(ea, n) for k, ea, n, a in PLAN if k == "label"][0]


# ------------------------------------------------------------------ window guard + fingerprint (as J1)
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

def data_layout():
    """heads/sizes/flags over every region this job types (code runs, label, zone tables, pointer tables)."""
    regs = [(ea, ea + n) for ea, n in RUNS] + [(LABEL[0], LABEL[0] + LABEL[1])] + [(ea, ea + n) for ea, n, c in ZONES] + \
           [(ea, ea + n) for ea, n in PTABS.items()]
    out = []
    for lo, hi in sorted(regs):
        for ea in idautils.Heads(lo, hi):
            out.append((ea, ida_bytes.get_item_size(ea), flags(ea) & 0xFFFFFFFF & ~getattr(ida_bytes, 'FF_REF', 0x1000)))
    return out

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
    dh = hashlib.sha256(repr(data_layout()).encode()).hexdigest()[:16]
    return dict(funcs=len(funcs), heads=len(heads), codebytes_scope=cb, win_heads=len(win),
                odd=len(odd), xrefs_from_code=nx, hash=h, win_hash=wh, typed_hash=dh), odd

def fp_str(m):
    return " ".join("%s=%s" % (k, m[k]) for k in ("funcs", "heads", "codebytes_scope", "win_heads", "odd", "xrefs_from_code", "hash", "win_hash", "typed_hash"))


# ------------------------------------------------------------------ edits
def make_code(st):
    """every new head must be a code head of the descent's length; a no-op when already correct."""
    bad = [(a, n) for a, n in HEADS if not is_code_head(a, n)]
    c = 0
    if bad:
        for lo, n in RUNS:
            run_heads = [(a, m) for a, m in HEADS if lo <= a < lo + n]
            if any(not is_code_head(a, m) for a, m in run_heads):
                ida_bytes.del_items(lo, ida_bytes.DELIT_SIMPLE, n)
                for a, m in run_heads:
                    if not is_code_head(a, m):
                        idc.create_insn(a); c += 1
    st["insns_created"] = c
    st["heads_wrong_after"] = sum(1 for a, n in HEADS if not is_code_head(a, n))

def make_funcs(st):
    nf = 0
    for e in ROOTS:
        if is_code_head(e) and ida_funcs.get_func(e) is None:
            if ida_funcs.add_func(e): nf += 1
            else: say("  WARN add_func %06X failed" % e)
    st["funcs_added"] = nf

def add_edges(st):
    nc = 0
    for s, t in CREFS:
        if not has_cref(s, t):
            ida_xref.add_cref(s, t, ida_xref.fl_CN | ida_xref.XREF_USER); nc += 1
    st["crefs_added"] = nc

def type_label(st):
    ea, n = LABEL           # 00 0E 'Baro     -hPa' FF : u16 header, 13 chars, 0xFF terminator
    want = [(ea, 2), (ea + 2, n - 3), (ea + n - 1, 1)]
    ok = all(ida_bytes.is_head(flags(a)) and ida_bytes.get_item_size(a) == m and not ida_bytes.is_code(flags(a)) for a, m in want) \
        and ida_bytes.is_strlit(flags(ea + 2))
    if not ok:
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, n)
        ida_bytes.create_word(ea, 2)
        ida_bytes.create_strlit(ea + 2, n - 3, ida_nalt.STRTYPE_C)
        ida_bytes.create_byte(ea + n - 1, 1)
        st["label_typed"] = 1
    else:
        st["label_typed"] = 0
    if not ida_name.get_name(ea).startswith("lbl_baro"):
        ida_name.set_name(ea, "lbl_baro_hPa_%06X" % ea, ida_name.SN_NOWARN | ida_name.SN_NOCHECK)

ZSID = None
def zone_struct():
    global ZSID
    sid = idc.get_struc_id("touch_zone_t")
    if sid == idc.BADADDR:
        sid = idc.add_struc(-1, "touch_zone_t", 0)
        idc.add_struc_member(sid, "lo_x16_y16", 0, ida_bytes.FF_DWORD | ida_bytes.FF_DATA, -1, 4)
        idc.add_struc_member(sid, "hi_x16_y16", 4, ida_bytes.FF_DWORD | ida_bytes.FF_DATA, -1, 4)
        idc.add_struc_member(sid, "button_idx", 8, ida_bytes.FF_WORD | ida_bytes.FF_DATA, -1, 2)
    ZSID = sid
    return sid, idc.get_struc_size(sid)

def type_zones(st):
    sid, ssz = zone_struct()
    ch = 0
    for T, L, cnt in ZONES:
        nrec = (L - 2) // 10; tail = L - 2 - 10 * nrec
        want = [(T, 2)] + ([(T + 2, 10 * nrec)] if nrec else []) + ([(T + 2 + 10 * nrec, tail)] if tail else [])
        ok = all(ida_bytes.is_head(flags(a)) and ida_bytes.get_item_size(a) == m and not ida_bytes.is_code(flags(a)) for a, m in want)
        if nrec and ssz == 10: ok = ok and ida_bytes.is_struct(flags(T + 2))
        if ok: continue
        ida_bytes.del_items(T, ida_bytes.DELIT_SIMPLE, L)
        ida_bytes.create_word(T, 2)
        if nrec:
            if ssz == 10 and sid != idc.BADADDR:
                if not ida_bytes.create_struct(T + 2, 10 * nrec, sid):
                    say("  WARN create_struct %06X failed" % (T + 2))
            else:
                ida_bytes.create_byte(T + 2, 10 * nrec)
        if tail: ida_bytes.create_byte(T + 2 + 10 * nrec, tail)
        ch += 1
        nm = ida_name.get_name(T)
        if not nm or nm.startswith(("unk_", "byte_", "word_", "dword_", "off_", "stru_", "asc_")):
            ida_name.set_name(T, "tz_%06X" % T, ida_name.SN_NOWARN | ida_name.SN_NOCHECK)
    st["zone_tables_typed"] = ch
    st["zone_struct"] = "%s/%d" % ("ok" if sid != idc.BADADDR else "none", ssz)

def type_ptrs(st):
    ch = 0
    for T, L in sorted(PTABS.items()):
        for c in range(T, T + L, 4):
            f = flags(c)
            if not (ida_bytes.is_dword(f) and ida_bytes.is_head(f)):
                ida_bytes.del_items(c, ida_bytes.DELIT_SIMPLE, 4); ida_bytes.create_dword(c, 4); ch += 1
            if not ida_bytes.is_off0(flags(c)):
                ida_offset.op_offset(c, 0, idc.REF_OFF32); ch += 1
    st["ptr_cells_typed"] = ch

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
    make_code(st)
    type_label(st)
    type_zones(st)
    type_ptrs(st)
    make_funcs(st)
    add_edges(st)
    ida_auto.auto_wait()
    st2 = {}
    make_code(st2); type_label(st2); type_zones(st2); type_ptrs(st2)
    st["recheck"] = "%d/%d/%d/%d" % (st2["insns_created"], st2["label_typed"], st2["zone_tables_typed"], st2["ptr_cells_typed"])
    if any((st2["insns_created"], st2["label_typed"], st2["zone_tables_typed"], st2["ptr_cells_typed"])): ida_auto.auto_wait()
    st["odd_killed"] = kill_odd(0, CW0) + kill_odd(CW1, HI)
    st["window_fixed"] = restore_window(snap)
    if st["window_fixed"]: ida_auto.auto_wait()
    say("round %d: %s" % (r, " ".join("%s=%s" % kv for kv in sorted(st.items()))))
    return st


def report():
    say("new heads code-correct: %d/%d" % (sum(1 for a, n in HEADS if is_code_head(a, n)), len(HEADS)))
    for a in ROOTS:
        fn = ida_funcs.get_func(a)
        say("root %06X func=%s crefs_in=%d" % (a, ("%06X" % fn.start_ea) if fn else "-", sum(1 for _ in idautils.CodeRefsTo(a, 0))))
    lea, ln = LABEL
    say("label %06X: %s" % (lea, " ".join("%06X:%d:%s" % (h, ida_bytes.get_item_size(h), "str" if ida_bytes.is_strlit(flags(h)) else ("code" if ida_bytes.is_code(flags(h)) else "data")) for h in idautils.Heads(lea, lea + ln))))
    zs = sum(1 for T, L, c in ZONES if ida_bytes.is_struct(flags(T + 2)) or (L - 2) < 10)
    zcode = sum(1 for T, L, c in ZONES for x in range(T, T + L) if ida_bytes.is_code(flags(x)))
    say("zone tables: %d listed, %d with struct array at +2, code bytes inside = %d, bytes = %d" % (len(ZONES), zs, zcode, sum(L for T, L, c in ZONES)))
    pc = sum(1 for T, L in PTABS.items() for c in range(T, T + L, 4) if ida_bytes.is_dword(flags(c)) and ida_bytes.is_off0(flags(c)))
    say("pointer cells dword+offset: %d/%d" % (pc, sum(L // 4 for L in PTABS.values())))
    for s, e in I12_BLOCKS:
        say("I12 block %06X-%06X still DB code: %d/%d" % (s, e, sum(1 for y in range(s, e) if ida_bytes.is_code(flags(y))), e - s))
    mask = bytearray(HI)
    for ea in idautils.Heads(0, HI):
        if ida_bytes.is_code(flags(ea)):
            for x in range(ea, min(HI, ea + ida_bytes.get_item_size(ea))): mask[x] = 1
    with open(os.path.join(OUT, "MAIN_FINAL4_codemask.bin"), "wb") as h: h.write(bytes(mask))
    pm = open(os.path.join(OUT, "final4_proven_mask.bin"), "rb").read()
    notcode = [x for x in range(HI) if pm[x] and not mask[x]]
    say("proven mask %d set; proven bytes that are NOT DB code: %d %s" % (sum(1 for b in pm[:HI] if b), len(notcode), ["%06X" % x for x in notcode[:20]]))
    with open(os.path.join(OUT, "MAIN_FINAL4_functions_raw.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\n")
        for f in idautils.Functions():
            fn = ida_funcs.get_func(f); h.write("%06X\t%06X\t%d\n" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea))


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
    say("DELTA funcs=%+d heads=%+d codebytes_scope=%+d odd=%+d xrefs_from_code=%+d hash_same=%s win_same=%s typed_same=%s" % (
        after["funcs"] - before["funcs"], after["heads"] - before["heads"], after["codebytes_scope"] - before["codebytes_scope"],
        after["odd"] - before["odd"], after["xrefs_from_code"] - before["xrefs_from_code"],
        after["hash"] == before["hash"], after["win_hash"] == before["win_hash"], after["typed_hash"] == before["typed_hash"]))
    say("odd heads outside window: %d; window equals seed: %s" % (after["odd"], window_heads() == seed))
    report()


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
    with open(os.path.join(OUT, "k1_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    with open(os.path.join(OUT, "MAIN_FINAL4_log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n")
    idc.qexit(0)

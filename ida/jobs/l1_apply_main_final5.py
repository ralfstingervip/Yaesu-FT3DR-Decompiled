# -*- coding: utf-8 -*-
r"""Lane L1 - build MAIN_FINAL5 from K1_MAIN_FINAL4 (idempotent, reusable).

Owner-side static analysis of decrypted\FT3D_MAIN_ver102_EXP.bin (MAIN, H8SX h8sxa, base 0,
big-endian). No image byte is modified (no patch_* call); only DB item layout and functions
change, and only inside the service window 0x078106-0x078545.

FINAL5 == FINAL4 plus exactly the two resolved deltas:
  (A) The service window 0x078106-0x078545 is opened to its full 336 code heads (doc 95,
      ida\out\service-window\code-heads.tsv, 336/336 vs oracle bu_all.tsv) so that every one
      of the 1088 proven window bytes is DB code (proven subset of DB code holds). FINAL4 held
      the window "closed" at 99 heads.
  (B) The -278 B demotion of 0x054AE2-0x054BF7 is a PROVEN-MASK overlay only (I12 convention,
      docs 64/69/83): those bytes stay disassembled DB code, so the DB is NOT edited for it and
      NAMED is unchanged. The job only re-checks that the range has no inbound edge.

Run (first time, then --reopen):
  python ida\run_job.py --script ida\jobs\l1_apply_main_final5.py --db L1_MAIN_FINAL5 --copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64
  python ida\run_job.py --script ida\jobs\l1_apply_main_final5.py --db L1_MAIN_FINAL5 --reopen
Env L1_TAG = pass label for the log (default 'pass').
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, hashlib, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_lines, idautils, idc, ida_ida

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-final5")
SW = os.path.join(ROOT, "ida", "out", "service-window")
IMG_PATH = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
HEADS_TSV = os.path.join(SW, "code-heads.tsv")
PROVEN = os.path.join(OUT, "final5_proven_mask.bin")

W0, W1 = 0x078106, 0x078546        # service window code span [W0, W1): 1088 B, 336 heads
HI = 0x7B754                        # content boundary (== mask high bound)
COLLAR = ((0x078000, W0), (W1, 0x078900))
DEMO0, DEMO1 = 0x054AE2, 0x054BF8   # demoted range [lo, hi): 278 B
ROUTINE0, ROUTINE1 = 0x054AC0, 0x054C12   # the enclosing mis-split routine; edges within it are internal
TAG = os.environ.get("L1_TAG", "pass")
LOG = []

# 18 window routine entry points (doc 95); added as functions for a clean seed.
STARTS = (0x078106, 0x07815C, 0x0781C6, 0x0781DE, 0x07821E, 0x078222,
          0x07823C, 0x078256, 0x078260, 0x07827C, 0x078334, 0x07837C,
          0x0783DA, 0x07842E, 0x078442, 0x07845A, 0x0784BE, 0x078508)


def say(s): LOG.append(str(s))
def flags(ea): return ida_bytes.get_flags(ea)
def is_code_head(ea, n=None):
    f = flags(ea)
    return ida_bytes.is_code(f) and ida_bytes.is_head(f) and (n is None or ida_bytes.get_item_size(ea) == n)


def load_heads():
    want = []
    with open(HEADS_TSV, encoding="utf-8") as h:
        next(h)
        for ln in h:
            c = ln.rstrip("\n").split("\t")
            if len(c) >= 2:
                want.append((int(c[0], 16), int(c[1])))
    return want

WANT = load_heads()
WANT_SET = {a for a, n in WANT}


# ------------------------------------------------------------------ fingerprint (K1-compatible shape)
def window_code_heads():
    return {ea: ida_bytes.get_item_size(ea) for ea in idautils.Heads(W0, W1) if ida_bytes.is_code(flags(ea))}

def fingerprint():
    heads = []; cb = 0; odd = []
    for ea in idautils.Heads(0, HI):
        f = flags(ea)
        if ida_bytes.is_code(f):
            sz = ida_bytes.get_item_size(ea); heads.append((ea, sz))
            if ea < W0 or ea >= W1: cb += sz
            if ea & 1 and not (W0 <= ea < W1): odd.append(ea)
    funcs = [(f, ida_funcs.get_func(f).end_ea) for f in idautils.Functions()]
    nx = 0
    for ea, sz in heads:
        nx += sum(1 for _ in idautils.XrefsFrom(ea, 0))
    win = [(a, s) for a, s in heads if W0 <= a < W1]
    h = hashlib.sha256(repr((heads, funcs)).encode()).hexdigest()[:16]
    wh = hashlib.sha256(repr(win).encode()).hexdigest()[:16]
    return dict(funcs=len(funcs), heads=len(heads), codebytes_scope=cb, win_heads=len(win),
                odd=len(odd), xrefs_from_code=nx, hash=h, win_hash=wh), odd

def fp_str(m):
    return " ".join("%s=%s" % (k, m[k]) for k in ("funcs", "heads", "codebytes_scope", "win_heads", "odd", "xrefs_from_code", "hash", "win_hash"))


def collar_snap():
    out = {}
    for lo, hi in COLLAR:
        rows = []
        for ea in idautils.Heads(lo, hi):
            rows.append((ea, ida_bytes.get_item_size(ea), 1 if ida_bytes.is_code(flags(ea)) else 0))
        out[lo] = rows
    return out


# ------------------------------------------------------------------ open the window to 336 heads
def window_ok():
    cur = window_code_heads()
    if set(cur) != WANT_SET:
        return False
    return all(cur.get(a) == n for a, n in WANT)

def open_window(st):
    if window_ok():
        st["window"] = "already 336/336"
        st["win_rebuilt"] = 0
        return
    img = sys.exit("The firmware image is not in this repository.")
    ida_auto.enable_auto(False)
    for ea in [e for e in idautils.Functions(W0, W1) if W0 <= e < W1]:
        ida_funcs.del_func(ea)
    ea = W0
    while ea < W1:
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, min(0x100, W1 - ea))
        ea += 0x100
    made = bad = 0
    for a, n in WANT:
        ln = ida_ua.create_insn(a)
        if ln == n:
            made += 1
        else:
            bad += 1
            if bad <= 20:
                say("  create %06X want %d got %s" % (a, n, ln))
    ida_auto.plan_range(W0, W1)
    ida_auto.auto_wait()
    # remove any extra code head inside the window that is not wanted
    for _ in range(3):
        extra = [ea for ea in idautils.Heads(W0, W1)
                 if ida_bytes.is_code(flags(ea)) and ea not in WANT_SET]
        if not extra:
            break
        for ea in extra:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, ida_bytes.get_item_size(ea))
        ida_auto.plan_range(W0, W1)
        ida_auto.auto_wait()
    ida_auto.enable_auto(True)
    ida_auto.auto_wait()
    st["win_rebuilt"] = 1
    st["created_match"] = made
    st["created_bad"] = bad
    # byte cross-check against the image for every wanted head
    diff = 0
    for a, n in WANT:
        raw = ida_bytes.get_bytes(a, n) or b""
        if not (bytes(raw) == img[a:a + n] and is_code_head(a, n)):
            diff += 1
    st["heads_byte_ok"] = len(WANT) - diff
    st["heads_byte_diff"] = diff


def add_window_funcs(st):
    nf = 0
    for e in STARTS:
        if is_code_head(e) and ida_funcs.get_func(e) is None:
            if ida_funcs.add_func(e):
                nf += 1
    if nf:
        ida_auto.auto_wait()
    st["win_funcs_added"] = nf


def kill_odd(lo, hi):
    tot = 0
    for _ in range(4):
        odd = [ea for ea in idautils.Heads(lo, hi) if ida_bytes.is_code(flags(ea)) and ea & 1]
        if not odd:
            break
        for ea in odd:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, ida_bytes.get_item_size(ea))
        tot += len(odd); ida_auto.auto_wait()
    return tot


# ------------------------------------------------------------------ inbound-edge audit of the demoted range
def audit_demoted():
    say("== demoted range %06X-%06X (%d B) inbound-edge audit ==" % (DEMO0, DEMO1 - 1, DEMO1 - DEMO0))
    # 1. DB cross-references into the range, from outside the enclosing routine
    xr_ext = []
    for ea in range(DEMO0, DEMO1):
        for x in idautils.XrefsTo(ea, 0):
            if not (ROUTINE0 <= x.frm < ROUTINE1):
                dl = ida_lines.tag_remove(idc.generate_disasm_line(x.frm, 0) or "")
                xr_ext.append((x.frm, ea, x.type, dl))
    say("DB XrefsTo into range from outside %06X-%06X: %d" % (ROUTINE0, ROUTINE1, len(xr_ext)))
    for frm, to, t, dl in xr_ext[:20]:
        say("  from %06X -> %06X type %d  %s" % (frm, to, t, dl))
    # internal edges, for context
    xr_int = 0
    for ea in range(DEMO0, DEMO1):
        for x in idautils.XrefsTo(ea, 0):
            if ROUTINE0 <= x.frm < ROUTINE1:
                xr_int += 1
    say("DB XrefsTo into range from inside the routine (internal flow): %d" % xr_int)

    # 2. raw whole-image byte scan 0x000000-HI (decode-independent) for BE32 pointers and abs24 jsr/jmp
    img = sys.exit("The firmware image is not in this repository.")
    be32 = []
    abs24 = []
    n = HI
    for i in range(0, n - 3):
        v = (img[i] << 24) | (img[i + 1] << 16) | (img[i + 2] << 8) | img[i + 3]
        if DEMO0 <= v < DEMO1:
            be32.append((i, v))
        op = img[i]
        if op in (0x5E, 0x5A):  # jsr @aa:24 (5E) / jmp @aa:24 (5A)
            a24 = (img[i + 1] << 16) | (img[i + 2] << 8) | img[i + 3]
            if DEMO0 <= a24 < DEMO1:
                abs24.append((i, op, a24))
    say("raw BE32 pointers into range (whole image 0-%06X): %d %s" % (HI, len(be32), be32[:10]))
    say("raw abs24 jsr(5E)/jmp(5A) into range (naive, whole image): %d %s" % (len(abs24), abs24[:10]))

    # 3. the one known external edge should target 054BF8 (just past the range), not inside it
    j = 0x002214
    say("known edge %06X: %s" % (j, ida_lines.tag_remove(idc.generate_disasm_line(j, 0) or "")))
    say("fall-through parent %06X: %s" % (0x054ADE, ida_lines.tag_remove(idc.generate_disasm_line(0x054ADE, 0) or "")))
    say("demoted-range still DB code: %d/%d bytes" % (
        sum(1 for y in range(DEMO0, DEMO1) if ida_bytes.is_code(flags(y))), DEMO1 - DEMO0))
    return len(xr_ext) + len(be32) + len(abs24)


def report():
    say("window code heads: %d (want %d)" % (len(window_code_heads()), len(WANT)))
    say("window heads match want_set: %s" % (set(window_code_heads()) == WANT_SET))
    # proven mask vs DB code
    pm = open(PROVEN, "rb").read()
    mask = bytearray(HI)
    for ea in idautils.Heads(0, HI):
        if ida_bytes.is_code(flags(ea)):
            for x in range(ea, min(HI, ea + ida_bytes.get_item_size(ea))):
                mask[x] = 1
    with open(os.path.join(OUT, "MAIN_FINAL5_codemask.bin"), "wb") as h:
        h.write(bytes(mask))
    notcode = [x for x in range(HI) if pm[x] and not mask[x]]
    say("final5 proven mask %d set; proven bytes NOT DB code: %d %s" % (
        sum(1 for b in pm[:HI] if b), len(notcode), ["%06X" % x for x in notcode[:20]]))
    # collar
    say("window routine starts as funcs: %d/%d" % (
        sum(1 for e in STARTS if ida_funcs.get_func(e) and ida_funcs.get_func(e).start_ea == e), len(STARTS)))
    with open(os.path.join(OUT, "MAIN_FINAL5_functions_raw.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\n")
        for f in idautils.Functions():
            fn = ida_funcs.get_func(f)
            h.write("%06X\t%06X\t%d\n" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea))


def main():
    say("=== %s  processor %s" % (TAG, ida_ida.inf_get_procname()))
    before, _ = fingerprint()
    say("BEFORE " + fp_str(before))
    cb = collar_snap()
    st = {}
    open_window(st)
    add_window_funcs(st)
    st["odd_killed"] = kill_odd(0, W0) + kill_odd(W1, HI)
    ida_auto.auto_wait()
    # collar drift check
    ca = collar_snap()
    drift = 0
    for lo, hi in COLLAR:
        b = {tuple(r) for r in cb[lo]}; a = {tuple(r) for r in ca[lo]}
        drift += len(a - b) + len(b - a)
    st["collar_drift"] = drift
    say("round: " + " ".join("%s=%s" % kv for kv in sorted(st.items())))
    after, odd = fingerprint()
    say("AFTER  " + fp_str(after))
    say("DELTA funcs=%+d heads=%+d codebytes_scope=%+d odd=%+d xrefs_from_code=%+d hash_same=%s win_same=%s" % (
        after["funcs"] - before["funcs"], after["heads"] - before["heads"],
        after["codebytes_scope"] - before["codebytes_scope"], after["odd"] - before["odd"],
        after["xrefs_from_code"] - before["xrefs_from_code"],
        after["hash"] == before["hash"], after["win_hash"] == before["win_hash"]))
    say("odd heads outside window: %d" % after["odd"])
    edges = audit_demoted()
    say("TOTAL inbound edges into demoted range (DB-ext + raw BE32 + raw abs24): %d" % edges)
    report()


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
    with open(os.path.join(OUT, "l1_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    with open(os.path.join(OUT, "MAIN_FINAL5_log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n")
    idc.qexit(0)

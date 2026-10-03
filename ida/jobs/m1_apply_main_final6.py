# -*- coding: utf-8 -*-
r"""Lane M1 - build MAIN_FINAL6 from L1_MAIN_FINAL5 (idempotent; run once with --copy-from, then --reopen).

Owner-side static analysis of decrypted\FT3D_MAIN_ver102_EXP.bin (H8SX h8sxa, base 0, big-endian).
No image byte is modified (no patch_* call); only DB items and functions change. Nothing touches a radio.

Edits (all fully resolved offline by ida\out\main-final6\offline\m1_plan.py):
  1. plan-typing.tsv  op=data   : delete items in [s,e) and make one byte array
                      op=dword  : delete items, BE32 cells (+offset when the target is in a segment)
                      op=insn   : delete items in [s,e) and create one instruction of exactly e-s bytes
                      op=check_*: no edit, verified after the build
     (DATA-MISTYPED runs of L2/L3/L4, and L5's 522 Confirmed rows incl. the 0x006A0C/0x0077F8 stale-head fix)
  2. plan-delfunc.tsv: delete the functions that start at H9 fnindex seeds inside l-wave-recon\drop_runs.tsv
     (except the re-added entry points 0x066FBE/0x06726A); then make the first leftover head of such a function a
     function again only when the DB holds a call xref (fl_CF/fl_CN) into it from outside the deleted range.
  3. ensure the 8 L-wave entry points are functions.
Auto-analysis is disabled during edits and the AU_CODE/AU_PROC queues are cleared before it is re-enabled, so
no flow-on code or function is created beyond the plan; any head that still differs from the plan is reported.
Env M1_TAG = pass label (build / verify).
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, hashlib, traceback, bisect
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_offset, ida_segment, ida_xref, idautils, idc, ida_ida

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-final6")
IMG_PATH = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
HI = 0x7B754
W0, W1 = 0x078106, 0x078546
TAG = os.environ.get("M1_TAG", "pass")
ENTRY = (0x018250, 0x018ABE, 0x01A094, 0x05E8E0, 0x066FB4, 0x067250, 0x066FBE, 0x06726A)
LOG = []


def say(s): LOG.append(str(s))
def flags(ea): return ida_bytes.get_flags(ea)
def code_head(ea, n=None):
    f = flags(ea)
    return ida_bytes.is_head(f) and ida_bytes.is_code(f) and (n is None or ida_bytes.get_item_size(ea) == n)


def snapshot():
    """per-byte kind over 0..HI ('c','d','u') and the head list"""
    st = bytearray(b"u" * HI); heads = []
    for ea in idautils.Heads(0, HI):
        f = flags(ea); sz = ida_bytes.get_item_size(ea)
        k = b"c" if ida_bytes.is_code(f) else (b"d" if ida_bytes.is_data(f) else b"u")
        heads.append((ea, sz, k.decode()))
        if k != b"u":
            for x in range(ea, min(HI, ea + sz)): st[x] = k[0]
    return st, heads


def fingerprint():
    st, heads = snapshot()
    code = [(a, s) for a, s, k in heads if k == "c"]
    funcs = [(f, ida_funcs.get_func(f).end_ea) for f in idautils.Functions()]
    nx = sum(1 for a, s in code for _ in idautils.XrefsFrom(a, 0))
    odd = [a for a, s in code if a & 1]
    m = dict(funcs=len(funcs), code_heads=len(code), data_heads=sum(1 for h in heads if h[2] == "d"),
             codebytes=st.count(b"c"), databytes=st.count(b"d"), odd=len(odd), xrefs_from_code=nx,
             hash=hashlib.sha256(repr((code, funcs)).encode()).hexdigest()[:16],          # L1-compatible layout hash
             typed_hash=hashlib.sha256(repr((heads, funcs)).encode()).hexdigest()[:16])   # incl. data/unk heads
    return m, st, heads, odd


def fp_str(m):
    return " ".join("%s=%s" % (k, m[k]) for k in ("funcs", "code_heads", "data_heads", "codebytes", "databytes", "odd",
                                                  "xrefs_from_code", "hash", "typed_hash"))


def load_tsv(name):
    rows = []
    with open(os.path.join(OUT, name), encoding="utf-8") as h:
        hdr = h.readline().rstrip("\n").split("\t")
        for ln in h:
            rows.append(dict(zip(hdr, ln.rstrip("\n").split("\t"))))
    return rows


def items_within(s, e):
    """True if every item touching [s,e) lies inside it"""
    hs = ida_bytes.get_item_head(s)
    if hs < s and (ida_bytes.is_code(flags(hs)) or ida_bytes.is_data(flags(hs))): return False
    he = ida_bytes.get_item_end(e - 1)
    return he <= e or not (ida_bytes.is_code(flags(e - 1)) or ida_bytes.is_data(flags(e - 1)))


def all_data(s, e):
    # tail bytes carry FF_TAIL, so test the flags of each byte's item head
    return all(ida_bytes.is_data(flags(ida_bytes.get_item_head(x))) for x in range(s, e)) and items_within(s, e)


def apply_typing(plan, st):
    for p in plan:
        op = p["op"]; s = int(p["start"], 16); e = int(p["end_excl"], 16)
        if op.startswith("check"):
            continue
        if not items_within(s, e):
            st["straddle_refused"].append("%s %06X-%06X" % (op, s, e)); continue
        if op == "data":
            if all_data(s, e) and ida_bytes.get_item_head(s) == s and ida_bytes.get_item_end(s) == e:
                st["skip"] += 1; continue
            ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
            ok = ida_bytes.create_byte(s, e - s)
            st["data"] += 1 if ok else 0
            if not ok: st["fail"].append("data %06X-%06X" % (s, e))
        elif op == "dword":
            if all(ida_bytes.is_dword(flags(c)) and ida_bytes.is_head(flags(c)) for c in range(s, e, 4)):
                st["skip"] += 1; continue
            ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
            for c in range(s, e, 4):
                ok = ida_bytes.create_dword(c, 4)
                v = ida_bytes.get_dword(c)
                if ok and ida_segment.getseg(v) is not None:
                    ida_offset.op_plain_offset(c, 0, 0); st["offsets"] += 1
                if not ok: st["fail"].append("dword %06X" % c)
            st["dword"] += 1
        elif op == "insn":
            n = e - s
            if code_head(s, n):
                st["skip"] += 1; continue
            ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, n)
            got = ida_ua.create_insn(s)
            if got == n: st["insn"] += 1
            else: st["fail"].append("insn %06X want %d got %s" % (s, n, got))


def drop_funcs(rows, st):
    for r in rows:
        a = int(r["func_start"], 16); fe = int(r["func_end"], 16)
        f = ida_funcs.get_func(a)
        if f is not None and f.start_ea == a:
            if ida_funcs.del_func(a): st["del_func"] += 1
            else: st["fail"].append("del_func %06X" % a)
        elif f is not None:
            st["fail"].append("del_func %06X: inside function %06X" % (a, f.start_ea))
        else:
            st["del_func_skip"] += 1
    ida_auto.auto_wait()
    cands = []
    for r in rows:
        if r["leftover_first"] == "-": continue
        cands.append(("drop", int(r["func_start"], 16), int(r["func_end"], 16), int(r["leftover_first"], 16)))
    # seed functions whose start head was retyped as data by an L5 Confirmed row (not in the drop list)
    dropped = {int(r["func_start"], 16) for r in rows}
    with open(os.path.join(OUT, "work", "seed", "funcs.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            a, fe = (int(x, 16) for x in ln.rstrip("\n").split("\t"))
            if a in dropped: continue
            f = ida_funcs.get_func(a)
            if f is not None and f.start_ea == a: continue
            lf = next((x for x in idautils.Heads(a, fe) if code_head(x)), None)
            st["lost_by_retype"] += 1
            if lf is None:
                st["leftover_notes"].append("retype %06X-%06X: no code left (all data now)" % (a, fe)); continue
            cands.append(("retype", a, fe, lf))
    for why, a, fe, lf in cands:
        tag = "%s %06X-%06X -> %06X" % (why, a, fe, lf)
        if not code_head(lf):
            st["leftover_notes"].append("%s: not a code head" % tag); continue
        if ida_funcs.get_func(lf) is not None:
            st["leftover_notes"].append("%s: in function %06X" % (tag, ida_funcs.get_func(lf).start_ea)); continue
        xs = [(x.frm, x.type) for x in idautils.XrefsTo(lf, 0) if not (a <= x.frm < fe)]
        calls = [f for f, t in xs if t in (ida_xref.fl_CF, ida_xref.fl_CN)]
        offs = [f for f, t in xs if t == ida_xref.dr_O]
        prev = ida_bytes.get_item_head(lf - 1)
        flow_in = code_head(prev) and any(x.type == ida_xref.fl_F for x in idautils.XrefsTo(lf, 0))
        allx = ",".join("%06X:%d" % o for o in xs[:8]) or "none"
        if calls or (offs and not flow_in):
            ok = ida_funcs.add_func(lf)
            st["leftover_func"] += 1 if ok else 0
            st["leftover_notes"].append("%s: add_func=%s (%s; xrefs %s)" % (tag, ok, "call" if calls else "offset, no flow-in", allx))
        else:
            st["leftover_notes"].append("%s: left as code outside any function (flow-in %s; xrefs %s)" % (tag, flow_in, allx))


def ensure_entries(st):
    for a in ENTRY:
        f = ida_funcs.get_func(a)
        if f is not None and f.start_ea == a: st["entry_already"] += 1; continue
        if code_head(a) and ida_funcs.add_func(a): st["entry_added"] += 1
        else: st["fail"].append("entry %06X" % a)


def verify(plan, rows_del, st_before_heads):
    img = sys.exit("The firmware image is not in this repository.")
    say("image bytes == DB bytes over 0..HI: %s" % (bytes(ida_bytes.get_bytes(0, HI)) == img[:HI]))
    snap, heads = snapshot()
    hd = {a: (s, k) for a, s, k in heads}
    bad = []
    for p in plan:
        op = p["op"]; s = int(p["start"], 16); e = int(p["end_excl"], 16)
        if op in ("data", "dword", "check_data"):
            if not all(snap[x] == ord("d") for x in range(s, e)): bad.append(p)
        elif op == "insn":
            if not code_head(s, e - s): bad.append(p)
        elif op == "check_code":
            if not all(snap[x] == ord("c") for x in range(s, e)): bad.append(p)
        elif op == "check_typed":
            if not all(snap[x] != ord("u") for x in range(s, e)): bad.append(p)
    say("plan rows verified: %d / %d ok; failing: %s" % (len(plan) - len(bad), len(plan),
        ["%s %s-%s" % (p["op"], p["start"], p["end_excl"]) for p in bad[:20]]))
    # expected code-head set: seed heads - heads removed by edits + planned instruction heads
    planned = {int(p["start"], 16): int(p["end_excl"], 16) - int(p["start"], 16) for p in plan if p["op"] == "insn"}
    edited = [(int(p["start"], 16), int(p["end_excl"], 16)) for p in plan if p["op"] in ("data", "dword", "insn")]
    starts = sorted(s for s, e in edited); ends = {s: e for s, e in edited}
    def in_edit(a):
        i = bisect.bisect_right(starts, a) - 1
        return i >= 0 and a < ends[starts[i]]
    seed_code = {a: s for a, s, k in st_before_heads if k == "c"}
    exp = {a: s for a, s in seed_code.items() if not in_edit(a)}
    exp.update(planned)
    now = {a: s for a, (s, k) in hd.items() if k == "c"}
    extra = sorted(set(now) - set(exp)); lost = sorted(set(exp) - set(now))
    size = sorted(a for a in set(now) & set(exp) if now[a] != exp[a])
    say("code heads vs plan: unexpected %d %s; missing %d %s; size-changed %d %s" % (
        len(extra), ["%06X" % a for a in extra[:20]], len(lost), ["%06X" % a for a in lost[:20]],
        len(size), ["%06X" % a for a in size[:20]]))
    # masks
    p6 = open(os.path.join(ROOT, "ida", "out", "l-wave-recon", "final6_proven_mask.bin"), "rb").read()
    nc = [x for x in range(HI) if p6[x] and snap[x] != ord("c")]
    say("final6 proven %d; proven bytes NOT DB code: %d %s" % (sum(p6[:HI]), len(nc), ["%06X" % x for x in nc[:20]]))
    # stale-head gap
    for a, nxt in ((0x006A0C, (0x006A0E, 0x006A10)), (0x0077F8, (0x0077FA, 0x0077FC))):
        say("stale-head fix %06X: code head size %s; old heads %s still heads: %s; bytes %s" % (
            a, ida_bytes.get_item_size(a) if code_head(a) else None, ["%06X" % n for n in nxt],
            [ida_bytes.is_head(flags(n)) for n in nxt], ida_bytes.get_bytes(a, 6).hex()))
    # functions
    left = [int(r["func_start"], 16) for r in rows_del if ida_funcs.get_func(int(r["func_start"], 16)) is not None
            and ida_funcs.get_func(int(r["func_start"], 16)).start_ea == int(r["func_start"], 16)]
    say("dropped fnindex functions still present: %d %s" % (len(left), ["%06X" % a for a in left]))
    say("entry points as functions: %d/8" % sum(1 for a in ENTRY if ida_funcs.get_func(a) and ida_funcs.get_func(a).start_ea == a))
    # per-byte type mask for the offline builder: 0 unk, 1 code, 2 data
    tm = bytes(1 if b == ord("c") else (2 if b == ord("d") else 0) for b in snap)
    with open(os.path.join(OUT, "MAIN_FINAL6_typemask.bin"), "wb") as h: h.write(tm)
    with open(os.path.join(OUT, "MAIN_FINAL6_codemask.bin"), "wb") as h: h.write(bytes(1 if b == ord("c") else 0 for b in snap))
    with open(os.path.join(OUT, "MAIN_FINAL6_functions_raw.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\n")
        for f in idautils.Functions():
            fn = ida_funcs.get_func(f)
            h.write("%06X\t%06X\t%d\n" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea))
    with open(os.path.join(OUT, "MAIN_FINAL6_heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tkind\n")
        for a, s, k in heads: h.write("%06X\t%d\t%s\n" % (a, s, k))


def main():
    say("=== %s  processor %s" % (TAG, ida_ida.inf_get_procname()))
    ida_auto.auto_wait()
    before, _, heads0, _ = fingerprint()
    say("BEFORE " + fp_str(before))
    seedh = os.path.join(OUT, "work", "seed", "heads.tsv")
    seed_heads = []
    with open(seedh, encoding="utf-8") as h:
        next(h)
        for ln in h:
            a, n, k = ln.rstrip("\n").split("\t"); seed_heads.append((int(a, 16), int(n), k[0]))
    plan = load_tsv("plan-typing.tsv"); rows_del = load_tsv("plan-delfunc.tsv")
    st = dict(skip=0, data=0, dword=0, insn=0, offsets=0, del_func=0, del_func_skip=0, leftover_func=0, lost_by_retype=0,
              entry_already=0, entry_added=0, fail=[], straddle_refused=[], leftover_notes=[])
    ida_auto.enable_auto(False)
    apply_typing(plan, st)
    for t in (ida_auto.AU_CODE, ida_auto.AU_PROC, ida_auto.AU_USED):
        ida_auto.auto_unmark(0, HI, t)
    ida_auto.enable_auto(True)
    ida_auto.auto_wait()
    drop_funcs(rows_del, st)
    ensure_entries(st)
    ida_auto.auto_wait()
    say("round: " + " ".join("%s=%s" % (k, v) for k, v in sorted(st.items()) if not isinstance(v, list)))
    say("fail: %s" % st["fail"]); say("straddle_refused: %s" % st["straddle_refused"])
    for n in st["leftover_notes"]: say("  leftover " + n)
    after, _, _, odd = fingerprint()
    say("AFTER  " + fp_str(after))
    say("DELTA funcs=%+d code_heads=%+d data_heads=%+d codebytes=%+d databytes=%+d odd=%+d xrefs_from_code=%+d hash_same=%s typed_same=%s" % (
        after["funcs"] - before["funcs"], after["code_heads"] - before["code_heads"], after["data_heads"] - before["data_heads"],
        after["codebytes"] - before["codebytes"], after["databytes"] - before["databytes"], after["odd"] - before["odd"],
        after["xrefs_from_code"] - before["xrefs_from_code"], after["hash"] == before["hash"], after["typed_hash"] == before["typed_hash"]))
    say("odd code heads (whole content): %d %s" % (len(odd), ["%06X" % a for a in odd[:20]]))
    verify(plan, rows_del, seed_heads)


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
    with open(os.path.join(OUT, "m1_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    with open(os.path.join(OUT, "MAIN_FINAL6_log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n")
    idc.qexit(0)

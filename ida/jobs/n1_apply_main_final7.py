# -*- coding: utf-8 -*-
r"""Lane N1 - build MAIN_FINAL7 from M1_MAIN_FINAL6 (idempotent; run once with --copy-from, then --reopen).

Owner-side static analysis of decrypted\FT3D_MAIN_ver102_EXP.bin (H8SX h8sxa, base 0, big-endian).
No image byte is modified (no patch_* call); only DB items change. Nothing touches a radio.

FINAL7 DB edits (resolved from the published M-wave tables; see docs 114-119 and ida\out\m-wave-recon\README.md):
  CODE (del_items + linear create_insn):
    - M6 proposed-proven runs  ida\out\inferred-tables\proposed-proven.tsv  (core 148 B + companion 242 B = 390 B)
      -> makes every newly-FINAL7-proven byte DB code (M7 CDC block is ALREADY code in the FINAL6 seed).
    - M5 dead-code rows         ida\out\dead-code-tier\proposed-typing.tsv   (db_action create_insn, 2878 B)
  DATA (del_items + create_byte / create_dword+offset):
    - M6 Confirmed table rows   ida\out\inferred-tables\proposed-typing.tsv  (C-read / C-extent, 575 B)
    - M2 DATA-MISTYPED retype   0x00932A-0x009332 (8 B byte table, doc 114)
    - M3 DATA-MISTYPED retype   0x03D1C6-0x03D1CA (4 B BCD cell, doc 115)
Auto-analysis is disabled during edits and the AU_CODE/AU_PROC/AU_USED queues are cleared before it is re-enabled,
so no flow-on code or function is created beyond the plan. The 4 dropped leaves (0x066FB4/0x066FBE/0x067250/
0x06726A) are dropped from the proven MASK only (offline descent); they stay DB code and keep their functions.
Env N1_TAG = pass label (build / verify).
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, hashlib, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_offset, ida_segment, idautils, idc, ida_ida

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-final7")
IMG_PATH = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
MW = os.path.join(ROOT, "ida", "out", "m-wave-recon")
HI = 0x7B754
TAG = os.environ.get("N1_TAG", "pass")
LOG = []
P7MASK = open(os.path.join(MW, "final7_proven_mask.bin"), "rb").read()


def say(s): LOG.append(str(s))
def flags(ea): return ida_bytes.get_flags(ea)
def is_code(ea): return ida_bytes.is_code(flags(ea))
def is_data(ea): return ida_bytes.is_data(flags(ea))
def code_head(ea): return ida_bytes.is_head(flags(ea)) and ida_bytes.is_code(flags(ea))


def load_rows(path):
    with open(os.path.join(ROOT, path), encoding="utf-8") as h:
        hdr = h.readline().rstrip("\n").split("\t")
        return [dict(zip(hdr, ln.rstrip("\n").split("\t"))) for ln in h if ln.strip() and not ln.startswith("#")]


def items_within(s, e):
    """True if no code/data item straddles the [s,e) boundary from outside."""
    hs = ida_bytes.get_item_head(s)
    if hs < s and (is_code(hs) or is_data(hs)):
        return False
    he = ida_bytes.get_item_end(e - 1)
    return he <= e or not (is_code(e - 1) or is_data(e - 1))


def all_code(s, e):
    # true iff [s,e) is already tiled exactly by code-instruction heads (tail bytes are class FF_TAIL,
    # so a byte-wise is_code test is wrong here; walk item heads instead).
    if not code_head(s):
        return False
    x = s
    while x < e:
        if not code_head(x):
            return False
        x += ida_bytes.get_item_size(x)
    return x == e


def all_data_tiled(s, e):
    return (all(is_data(ida_bytes.get_item_head(x)) for x in range(s, e))
            and ida_bytes.get_item_head(s) == s and ida_bytes.get_item_end(e - 1) == e)


def snapshot():
    st = bytearray(HI); heads = []
    for ea in idautils.Heads(0, HI):
        f = flags(ea); sz = ida_bytes.get_item_size(ea)
        k = 1 if ida_bytes.is_code(f) else (2 if ida_bytes.is_data(f) else 0)
        heads.append((ea, sz, k))
        if k:
            for x in range(ea, min(HI, ea + sz)): st[x] = k
    return st, heads


def fingerprint():
    st, heads = snapshot()
    code = [(a, s) for a, s, k in heads if k == 1]
    funcs = [(f, ida_funcs.get_func(f).end_ea) for f in idautils.Functions()]
    odd = [a for a, s in code if a & 1]
    m = dict(funcs=len(funcs), code_heads=len(code), data_heads=sum(1 for h in heads if h[2] == 2),
             codebytes=st.count(1), databytes=st.count(2), odd=len(odd),
             hash=hashlib.sha256(repr((code, funcs)).encode()).hexdigest()[:16],
             typed_hash=hashlib.sha256(repr((heads, funcs)).encode()).hexdigest()[:16])
    return m, st, heads, odd


def fp_str(m):
    return " ".join("%s=%s" % (k, m[k]) for k in ("funcs", "code_heads", "data_heads", "codebytes",
                                                  "databytes", "odd", "hash", "typed_hash"))


def make_code(s, e, st):
    if not items_within(s, e):
        st["straddle"].append("code %06X-%06X" % (s, e)); return
    if all_code(s, e):
        st["skip_code"] += 1; return
    ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
    i = s
    while i < e:
        n = ida_ua.create_insn(i)
        if n <= 0:
            st["fail"].append("insn %06X" % i); break
        i += n
    if i == e:
        st["code"] += 1
    else:
        st["fail"].append("code run %06X-%06X stopped at %06X" % (s, e, i))


def make_data(s, e, st, as_dword):
    # Refuse only if a PROVEN item straddles the edge (mirrors m6_apply). A non-proven mis-decoded
    # code neighbour that crosses the edge is deleted with the row and becomes unknown (doc 118 sec. 6).
    hs = ida_bytes.get_item_head(s); he = ida_bytes.get_item_end(e - 1)
    if (hs < s and is_code(hs) and P7MASK[hs]) or (he > e and is_code(e - 1) and P7MASK[e - 1]):
        st["straddle"].append("data %06X-%06X (proven item crosses)" % (s, e)); return
    if hs < s and is_code(hs):
        st["neighbour_clobber"].append("%06X" % hs)
    if he > e and is_code(e - 1):
        st["neighbour_clobber"].append("%06X" % ida_bytes.get_item_head(e - 1))
    if as_dword and (e - s) % 4 == 0 and s % 2 == 0:
        if all(ida_bytes.is_dword(flags(c)) and ida_bytes.is_head(flags(c)) for c in range(s, e, 4)):
            st["skip_data"] += 1; return
        ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
        for c in range(s, e, 4):
            if ida_bytes.create_dword(c, 4):
                v = ida_bytes.get_dword(c)
                if ida_segment.getseg(v) is not None:
                    ida_offset.op_plain_offset(c, 0, 0); st["offsets"] += 1
            else:
                st["fail"].append("dword %06X" % c)
        st["dword"] += 1
    else:
        if all_data_tiled(s, e):
            st["skip_data"] += 1; return
        ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
        if ida_bytes.create_byte(s, e - s):
            st["data"] += 1
        else:
            st["fail"].append("byte %06X-%06X" % (s, e))


def build_plan():
    code_runs = []   # (s, e, source)
    data_runs = []   # (s, e, source, as_dword)
    # M6 proposed-proven: core + companion -> code
    for r in load_rows("ida/out/inferred-tables/proposed-proven.tsv"):
        if r.get("set") in ("core", "companion"):
            code_runs.append((int(r["start"], 16), int(r["end_excl"], 16), "M6 proven %s" % r["set"]))
    # M5 dead-code rows -> code (create_insn only)
    for r in load_rows("ida/out/dead-code-tier/proposed-typing.tsv"):
        if r["typing_conf"] == "Confirmed" and r["db_action"].startswith("create_insn"):
            code_runs.append((int(r["start"], 16), int(r["end_excl"], 16), "M5 dead-code"))
    # M6 Confirmed table rows -> data
    for r in load_rows("ida/out/inferred-tables/proposed-typing.tsv"):
        if r["typing_conf"] == "Confirmed" and r["m6_tier"] in ("C-read", "C-extent"):
            dw = r["typing"].startswith("BE32 code pointers")
            data_runs.append((int(r["start"], 16), int(r["end_excl"], 16), "M6 %s" % r["m6_tier"], dw))
    # M2/M3 DATA-MISTYPED retypes -> data
    data_runs.append((0x00932A, 0x009332, "M2 DATA-MISTYPED", False))
    data_runs.append((0x03D1C6, 0x03D1CA, "M3 DATA-MISTYPED BCD", True))
    return code_runs, data_runs


def verify(code_runs, data_runs):
    img = sys.exit("The firmware image is not in this repository.")
    say("image bytes == DB bytes over 0..HI: %s" % (bytes(ida_bytes.get_bytes(0, HI)) == img[:HI]))
    snap, heads = snapshot()
    p7 = open(os.path.join(MW, "final7_proven_mask.bin"), "rb").read()
    n7 = open(os.path.join(MW, "final7_named_mask.bin"), "rb").read()
    nc = [x for x in range(HI) if p7[x] and snap[x] != 1]
    say("FINAL7 proven %d; proven bytes NOT DB code: %d %s" % (sum(p7[:HI]), len(nc), ["%06X" % x for x in nc[:20]]))
    # code runs are code; data runs are data
    bad_c = [(s, e) for s, e, _ in code_runs if not all(snap[x] == 1 for x in range(s, e))]
    bad_d = [(s, e) for s, e, _, _ in data_runs if not all(snap[x] == 2 for x in range(s, e))]
    say("code runs fully code: %d/%d; failing %s" % (len(code_runs) - len(bad_c), len(code_runs),
        ["%06X-%06X" % r for r in bad_c[:20]]))
    say("data runs fully data: %d/%d; failing %s" % (len(data_runs) - len(bad_d), len(data_runs),
        ["%06X-%06X" % r for r in bad_d[:20]]))
    # retypes specifically
    for s, e in ((0x00932A, 0x009332), (0x03D1C6, 0x03D1CA)):
        say("retype %06X-%06X all data: %s (bytes %s)" % (s, e, all(snap[x] == 2 for x in range(s, e)),
            ida_bytes.get_bytes(s, e - s).hex()))
    # named-added coverage: every FINAL7-named byte that is a plan target is typed
    say("DB: FINAL7 named bytes untyped (whole content): %d" % sum(1 for x in range(HI) if n7[x] and snap[x] == 0))
    odd = [a for a, s, k in heads if k == 1 and (a & 1)]
    say("odd code heads (whole content): %d %s" % (len(odd), ["%06X" % a for a in odd[:20]]))
    # per-byte type masks + heads + functions
    tm = bytes(snap)
    with open(os.path.join(OUT, "MAIN_FINAL7_typemask.bin"), "wb") as h: h.write(tm)
    with open(os.path.join(OUT, "MAIN_FINAL7_codemask.bin"), "wb") as h:
        h.write(bytes(1 if b == 1 else 0 for b in snap))
    with open(os.path.join(OUT, "MAIN_FINAL7_heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tkind\n")
        for a, s, k in heads: h.write("%06X\t%d\t%s\n" % (a, s, {1: "code", 2: "data", 0: "unk"}[k]))
    with open(os.path.join(OUT, "MAIN_FINAL7_functions_raw.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\n")
        for f in idautils.Functions():
            fn = ida_funcs.get_func(f)
            h.write("%06X\t%06X\t%d\n" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea))


def main():
    os.makedirs(OUT, exist_ok=True)
    say("=== %s  processor %s" % (TAG, ida_ida.inf_get_procname()))
    ida_auto.auto_wait()
    before, _, _, _ = fingerprint()
    say("BEFORE " + fp_str(before))
    code_runs, data_runs = build_plan()
    say("plan: %d code runs (%d B), %d data runs (%d B)" % (
        len(code_runs), sum(e - s for s, e, _ in code_runs),
        len(data_runs), sum(e - s for s, e, _, _ in data_runs)))
    st = dict(code=0, data=0, dword=0, offsets=0, skip_code=0, skip_data=0, fail=[], straddle=[], neighbour_clobber=[])
    ida_auto.enable_auto(False)
    for s, e, _, dw in data_runs:
        make_data(s, e, st, dw)
    for s, e, _ in code_runs:
        make_code(s, e, st)
    for t in (ida_auto.AU_CODE, ida_auto.AU_PROC, ida_auto.AU_USED):
        ida_auto.auto_unmark(0, HI, t)
    ida_auto.enable_auto(True)
    ida_auto.auto_wait()
    say("round: " + " ".join("%s=%s" % (k, v) for k, v in sorted(st.items()) if not isinstance(v, list)))
    say("fail: %s" % st["fail"])
    say("straddle (proven crossing, refused): %s" % st["straddle"])
    say("neighbour code items clobbered to unk (non-proven, doc 118 sec.6): %d %s" % (
        len(st["neighbour_clobber"]), sorted(set(st["neighbour_clobber"]))))
    after, _, _, odd = fingerprint()
    say("AFTER  " + fp_str(after))
    say("DELTA funcs=%+d code_heads=%+d data_heads=%+d codebytes=%+d databytes=%+d odd=%+d hash_same=%s typed_same=%s" % (
        after["funcs"] - before["funcs"], after["code_heads"] - before["code_heads"],
        after["data_heads"] - before["data_heads"], after["codebytes"] - before["codebytes"],
        after["databytes"] - before["databytes"], after["odd"] - before["odd"],
        after["hash"] == before["hash"], after["typed_hash"] == before["typed_hash"]))
    verify(code_runs, data_runs)


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "n1_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "MAIN_FINAL7_log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n")
    idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane L5 - apply the Confirmed proposed typings to the PRIVATE database L5_MAIN_RESIDUE and prove they are
byte-neutral for code outside the residue.

Owner-side static analysis. No patch_* call: image bytes are never modified; only DB items change.
Input : ida\out\main-unnamed\proposed-typing.tsv, ida\out\main-unnamed\residue_mask.bin, final4_proven_mask.bin
Output: ida\out\main-unnamed\apply-typing.tsv (per row: action / skipped reason), apply-typing-summary.txt
Run   : python ida\run_job.py --script ida\jobs\l5_apply_typing.py --db L5_MAIN_RESIDUE --reopen
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback, hashlib
import ida_auto, ida_bytes, ida_offset, ida_ua, idc, ida_nalt

ROOT = str(_REPO)
O = os.path.join(ROOT, "ida", "out", "main-unnamed")
HI = 0x7B754
LOG = []


def say(s): LOG.append(s)


def snapshot():
    """per-byte state over 0..HI: 'c' code, 'd' data, 'u' unknown; plus head set"""
    st = bytearray(b"u" * HI)
    heads = {}
    ea = 0
    while ea != idc.BADADDR and ea < HI:
        f = ida_bytes.get_flags(ea)
        if ida_bytes.is_head(f):
            sz = ida_bytes.get_item_size(ea)
            k = b"c" if ida_bytes.is_code(f) else (b"d" if ida_bytes.is_data(f) else b"u")
            if k != b"u":
                heads[ea] = (sz, k)
                for i in range(ea, min(HI, ea + sz)): st[i] = k[0]
        ea = ida_bytes.next_head(ea, HI)
    return st, heads


def main():
    ida_auto.auto_wait()
    res = open(os.path.join(O, "residue_mask.bin"), "rb").read()
    pm = open(os.path.join(ROOT, "ida", "out", "main-final4", "final4_proven_mask.bin"), "rb").read()[:HI]
    img = sys.exit("The firmware image is not in this repository.")
    img_ok = ida_bytes.get_bytes(0, HI) == img
    rows = []
    with open(os.path.join(O, "proposed-typing.tsv"), encoding="utf-8") as h:
        hdr = h.readline().rstrip("\n").split("\t")
        for ln in h:
            p = dict(zip(hdr, ln.rstrip("\n").split("\t")))
            rows.append(p)
    before, hb = snapshot()
    out = []
    for p in rows:
        s, e = int(p["start"], 16), int(p["end_excl"], 16)
        act = p["db_action"]
        if p["typing_conf"] != "Confirmed":
            out.append((s, e, act, "skip: typing Inferred")); continue
        if all(before[i] == ord("d") for i in range(s, e)) and not act.startswith(("del_items", "create_insn")):
            out.append((s, e, act, "no change (already typed as data)")); continue
        if act.startswith("none"):
            out.append((s, e, act, "no change (already typed)")); continue
        if act == "del_items + create_insn":
            # remove the stale heads that cover s..s+8 and decode the real 6-byte insn at s
            ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, 8)
            n = ida_ua.create_insn(s)
            nxt = s + n if n else s
            n2 = ida_ua.create_insn(nxt) if n else 0
            out.append((s, e, act, "create_insn len %d; next insn len %d" % (n, n2))); continue
        # data rows: refuse when an existing item straddles the row boundary
        hs = ida_bytes.get_item_head(s)
        he = ida_bytes.get_item_end(e - 1)
        fs = ida_bytes.get_flags(hs)
        if (ida_bytes.is_head(fs) and (ida_bytes.is_code(fs) or ida_bytes.is_data(fs)) and hs < s) or he > e:
            # allow straddle only when the straddling neighbour is entirely residue (it would be retyped anyway)
            out.append((s, e, act, "skip: item straddles row (%06X..%06X)" % (hs, he))); continue
        ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
        if act == "dword + offset":
            i = s
            while i < e:
                if i % 2 == 0 and i + 4 <= e:
                    ida_bytes.create_dword(i, 4); ida_offset.op_plain_offset(i, 0, 0); i += 4
                else:
                    ida_bytes.create_byte(i, 1); i += 1
        elif act == "create_insn (code)":
            i = s
            while i < e:
                n = ida_ua.create_insn(i)
                if not n:
                    ida_bytes.create_byte(i, 1); n = 1
                i += n
        else:
            ida_bytes.create_byte(s, e - s)
        out.append((s, e, act, "applied"))
    ida_auto.auto_wait()
    after, ha = snapshot()
    # neutrality checks
    lost_code_nonres = sum(1 for i in range(HI) if not res[i] and before[i] == ord("c") and after[i] != ord("c"))
    gained_code_nonres = sum(1 for i in range(HI) if not res[i] and before[i] != ord("c") and after[i] == ord("c"))
    changed_nonres = sum(1 for i in range(HI) if not res[i] and before[i] != after[i])
    proven_code_before = sum(1 for i in range(HI) if pm[i] and before[i] == ord("c"))
    proven_code_after = sum(1 for i in range(HI) if pm[i] and after[i] == ord("c"))
    heads_moved_nonres = sorted(ea for ea in set(hb) ^ set(ha) if not res[ea] and not any(res[j] for j in range(ea, ea + 8) if j < HI))
    typed_res_before = sum(1 for i in range(HI) if res[i] and before[i] != ord("u"))
    typed_res_after = sum(1 for i in range(HI) if res[i] and after[i] != ord("u"))
    code_res_before = sum(1 for i in range(HI) if res[i] and before[i] == ord("c"))
    code_res_after = sum(1 for i in range(HI) if res[i] and after[i] == ord("c"))
    data_res_after = sum(1 for i in range(HI) if res[i] and after[i] == ord("d"))
    with open(os.path.join(O, "apply-typing.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("start\tend_excl\tdb_action\tresult\n")
        for s, e, a, r in out: f.write("%06X\t%06X\t%s\t%s\n" % (s, e, a, r))
    applied = sum(e - s for s, e, a, r in out if r == "applied" or r.startswith("create_insn"))
    say("image spot-check ok: %s" % img_ok)
    say("rows %d; applied %d rows / %d B; skipped-straddle %d rows / %d B; inferred-skipped %d rows / %d B; no-change %d rows / %d B" % (
        len(out), sum(1 for x in out if x[3] == "applied" or x[3].startswith("create_insn")), applied,
        sum(1 for x in out if x[3].startswith("skip: item")), sum(x[1] - x[0] for x in out if x[3].startswith("skip: item")),
        sum(1 for x in out if x[3].startswith("skip: typing")), sum(x[1] - x[0] for x in out if x[3].startswith("skip: typing")),
        sum(1 for x in out if x[3].startswith("no change")), sum(x[1] - x[0] for x in out if x[3].startswith("no change"))))
    say("non-residue bytes: code lost %d, code gained %d, any state change %d" % (lost_code_nonres, gained_code_nonres, changed_nonres))
    say("proven-mask bytes that are DB code: before %d after %d (proven mask popcount %d)" % (proven_code_before, proven_code_after, sum(pm)))
    say("non-residue heads added/removed away from residue: %d %s" % (len(heads_moved_nonres), ["%06X" % x for x in heads_moved_nonres[:20]]))
    say("residue bytes typed in DB (code or data): before %d after %d (of %d); code %d -> %d; data after %d" % (
        typed_res_before, typed_res_after, sum(res), code_res_before, code_res_after, data_res_after))
    say("layout hash after: %s" % hashlib.sha256(bytes(after)).hexdigest()[:16])


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    with open(os.path.join(O, "apply-typing-summary.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n")
    idc.qexit(0)

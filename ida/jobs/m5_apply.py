# -*- coding: utf-8 -*-
r"""Lane M5 - apply the Confirmed code typing of ida\out\dead-code-tier\proposed-typing.tsv to the PRIVATE database
M5_DEADCODE and prove it is byte-neutral for proven code and for every byte outside the pieces.

Owner-side static analysis. No patch_* call: image bytes are never modified; only DB items change.
Input : ida\out\dead-code-tier\proposed-typing.tsv, ida\out\l-wave-recon\final6_proven_mask.bin / final6_named_mask.bin
Output: ida\out\dead-code-tier\apply-typing.tsv, apply-typing-summary.txt
Run   : python ida\run_job.py --script ida\jobs\m5_apply.py --db M5_DEADCODE --reopen
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback, hashlib
import ida_auto, ida_bytes, ida_ua, idc

ROOT = str(_REPO)
O = os.path.join(ROOT, "ida", "out", "dead-code-tier")
HI = 0x7B754
LOG = []


def snapshot():
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
    pm = open(os.path.join(ROOT, "ida", "out", "l-wave-recon", "final6_proven_mask.bin"), "rb").read()[:HI]
    img = sys.exit("The firmware image is not in this repository.")
    LOG.append("image bytes in DB match file over 0..0x7B753: %s" % (ida_bytes.get_bytes(0, HI) == img))
    rows = []
    with open(os.path.join(O, "proposed-typing.tsv"), encoding="utf-8") as h:
        hdr = h.readline().rstrip("\n").split("\t")
        for ln in h:
            rows.append(dict(zip(hdr, ln.rstrip("\n").split("\t"))))
    inpiece = bytearray(HI)
    for p in rows:
        for i in range(int(p["start"], 16), int(p["end_excl"], 16)): inpiece[i] = 1
    before, hb = snapshot()
    out = []
    for p in rows:
        s, e = int(p["start"], 16), int(p["end_excl"], 16)
        if p["typing_conf"] != "Confirmed":
            out.append((s, e, "skip: Inferred", "")); continue
        if not p["db_action"].startswith("create_insn"):
            hs = ida_bytes.get_item_head(s)
            out.append((s, e, "no change (%s); item %06X size %d code %s" % (p["db_action"], hs, ida_bytes.get_item_size(hs),
                        ida_bytes.is_code(ida_bytes.get_flags(hs))), "")); continue
        hs = ida_bytes.get_item_head(s)
        he = ida_bytes.get_item_end(e - 1)
        if (hs < s and ida_bytes.is_head(ida_bytes.get_flags(hs)) and (ida_bytes.is_code(ida_bytes.get_flags(hs)) or
                ida_bytes.is_data(ida_bytes.get_flags(hs)))) or he > e:
            out.append((s, e, "skip: item straddles (%06X..%06X)" % (hs, he), "")); continue
        ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
        i, lens = s, []
        while i < e:
            n = ida_ua.create_insn(i)
            if not n:
                lens.append("FAIL@%06X" % i); break
            lens.append(str(n)); i += n
        out.append((s, e, "applied" if i == e else "partial", ",".join(lens)))
    ida_auto.auto_wait()
    after, ha = snapshot()
    lost = sum(1 for i in range(HI) if not inpiece[i] and before[i] == ord("c") and after[i] != ord("c"))
    changed = [i for i in range(HI) if not inpiece[i] and before[i] != after[i]]
    pcb = sum(1 for i in range(HI) if pm[i] and before[i] == ord("c"))
    pca = sum(1 for i in range(HI) if pm[i] and after[i] == ord("c"))
    hmoved = sorted(ea for ea in set(hb) ^ set(ha) if not inpiece[ea])
    pc_before = sum(1 for i in range(HI) if inpiece[i] and before[i] == ord("c"))
    pc_after = sum(1 for i in range(HI) if inpiece[i] and after[i] == ord("c"))
    with open(os.path.join(O, "apply-typing.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("start\tend_excl\tresult\tinsn_lengths\n")
        for s, e, r, l in out: f.write("%06X\t%06X\t%s\t%s\n" % (s, e, r, l))
    LOG.append("rows %d; applied %d (%d B); partial %d; skipped %d" % (
        len(out), sum(1 for x in out if x[2] == "applied"), sum(x[1] - x[0] for x in out if x[2] == "applied"),
        sum(1 for x in out if x[2] == "partial"), sum(1 for x in out if x[2].startswith("skip"))))
    LOG.append("piece bytes that are DB code: before %d after %d (of %d)" % (pc_before, pc_after, sum(inpiece)))
    LOG.append("bytes outside the pieces: code lost %d; any code/data/unknown state change %d %s" % (
        lost, len(changed), ["%06X" % x for x in changed[:20]]))
    LOG.append("proven-mask bytes that are DB code: before %d after %d (mask popcount %d)" % (pcb, pca, sum(pm)))
    LOG.append("heads added/removed outside the pieces: %d %s" % (len(hmoved), ["%06X" % x for x in hmoved[:20]]))
    LOG.append("layout hash before %s after %s" % (hashlib.sha256(bytes(before)).hexdigest()[:16], hashlib.sha256(bytes(after)).hexdigest()[:16]))


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
    with open(os.path.join(O, "work", "m5_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    with open(os.path.join(O, "apply-typing-summary.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(LOG) + "\n")
    idc.qexit(0)

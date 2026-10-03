# -*- coding: utf-8 -*-
r"""Lane M6 - apply the proposed typing to the PRIVATE M6_TABLES database only and measure neutrality.

Owner-side static analysis. Changes only ida\db\jobs\M6_TABLES. No patch_* call (image bytes untouched).
Run:  python ida\run_job.py --script ida\jobs\m6_apply.py --db M6_TABLES --reopen
In : ida\out\inferred-tables\proposed-typing.tsv, ida\out\l-wave-recon\final6_proven_mask.bin
Out: ida\out\inferred-tables\apply-typing.tsv, apply-typing-summary.txt
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback, hashlib
import ida_auto, ida_bytes, ida_ua, idc, ida_offset, ida_nalt

ROOT = str(_REPO)
O = os.path.join(ROOT, "ida", "out", "inferred-tables")
HI = 0x7B754


def snap():
    out = bytearray(HI)
    ea = 0
    while ea < HI:
        f = ida_bytes.get_flags(ea)
        n = max(1, ida_bytes.get_item_size(ea)) if (ida_bytes.is_code(f) or ida_bytes.is_data(f)) else 1
        v = 1 if ida_bytes.is_code(f) else (2 if ida_bytes.is_data(f) else 0)
        for i in range(ea, min(HI, ea + n)): out[i] = v
        ea += n
    return out


def main():
    ida_auto.auto_wait()
    pm = open(os.path.join(ROOT, "ida", "out", "l-wave-recon", "final6_proven_mask.bin"), "rb").read()[:HI]
    img = sys.exit("The firmware image is not in this repository.")
    before = snap()
    rows = [l.rstrip("\n").split("\t") for l in open(os.path.join(O, "proposed-typing.tsv"), encoding="utf-8")][1:]
    log = []
    for r in rows:
        a, b = int(r[0], 16), int(r[1], 16)
        typ, tier = r[3], r[5]
        h = ida_bytes.get_item_head(a)
        e = ida_bytes.get_item_end(b - 1)
        if (h < a and before[h] == 1 and pm[h]) or (e > b and before[b - 1] == 1 and pm[b - 1]):
            log.append((r[0], r[1], tier, "skipped: proven item crosses edge")); continue
        if tier in ("Proven-code", "companion-proven"):
            ida_bytes.del_items(a, ida_bytes.DELIT_SIMPLE, b - a)
            ea, ok = a, True
            while ea < b:
                n = ida_ua.create_insn(ea)
                if n <= 0: ok = False; break
                ea += n
            log.append((r[0], r[1], tier, "code ok" if ok and ea == b else "code stop at %06X" % ea)); continue
        ida_bytes.del_items(a, ida_bytes.DELIT_SIMPLE, b - a)
        if typ.startswith("BE32 code pointers") and (b - a) % 4 == 0 and a % 2 == 0:
            for x in range(a, b, 4):
                ida_bytes.create_dword(x, 4); ida_offset.op_plain_offset(x, 0, 0)
            log.append((r[0], r[1], tier, "dword+offset"))
        else:
            ida_bytes.create_byte(a, b - a)
            log.append((r[0], r[1], tier, "byte[%d]" % (b - a)))
    ida_auto.auto_wait()
    after = snap()
    lost = sum(1 for i in range(HI) if pm[i] and before[i] == 1 and after[i] != 1)
    pc_b = sum(1 for i in range(HI) if pm[i] and before[i] == 1)
    pc_a = sum(1 for i in range(HI) if pm[i] and after[i] == 1)
    dbb = bytes(ida_bytes.get_byte(i) for i in range(HI))
    with open(os.path.join(O, "apply-typing.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("start\tend_excl\ttier\tresult\n")
        for x in log: f.write("\t".join(x) + "\n")
    with open(os.path.join(O, "apply-typing-summary.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write("rows %d, skipped %d\n" % (len(log), sum(1 for x in log if x[3].startswith("skipped"))))
        f.write("final6-proven bytes that are code: before %d after %d lost %d\n" % (pc_b, pc_a, lost))
        f.write("db bytes == image over 0..0x7B753: %s\n" % (dbb == img[:HI]))
        ch = [i for i in range(HI) if before[i] != after[i]]
        f.write("bytes whose code/data/unknown state changed: %d (outside proposed rows: %d)\n" % (
            len(ch), sum(1 for i in ch if not any(int(x[0], 16) <= i < int(x[1], 16) for x in log))))
        outside = [i for i in ch if not any(int(x[0], 16) <= i < int(x[1], 16) for x in log)]
        f.write("outside bytes: %s\n" % " ".join("%06X:%d>%d" % (i, before[i], after[i]) for i in outside))
        f.write("layout hash after: %s\n" % hashlib.sha256(bytes(after)).hexdigest()[:16])


try:
    main()
except Exception:
    with open(os.path.join(O, "m6_apply_traceback.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

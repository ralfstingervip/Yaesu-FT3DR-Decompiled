import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
# M13 -- read-only IDAPython check of a private copy of the L1_MAIN_FINAL5 seed (M13_REVERIFY_MAIN).
# Edits nothing in the DB. Recomputes L1's fingerprint (same formula as ida\jobs\l1_apply_main_final5.py) and dumps
# per-byte DB state (0 = unexplored, 1 = code, 2 = data, 3 = code head... see below) for 0..0x07B754 so the
# final5 / final6 masks can be compared with the seed offline (m13_dbcmp.py).
# Output: ida\out\ledger-reverify-l\db\{fingerprint.txt, dbstate.bin, traceback.txt on error}
import os, hashlib, traceback
import ida_auto, ida_bytes, ida_funcs, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "ledger-reverify-l", "db")
W0, W1, HI = 0x078106, 0x078546, 0x7B754


def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    heads = []; cb = 0; odd = []
    for ea in idautils.Heads(0, HI):
        f = ida_bytes.get_flags(ea)
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
    # per-byte state: bit0 code byte, bit1 data byte, bit2 item head, bit3 function start
    st = bytearray(HI)
    for ea in idautils.Heads(0, HI):
        f = ida_bytes.get_flags(ea); sz = ida_bytes.get_item_size(ea)
        v = 1 if ida_bytes.is_code(f) else (2 if ida_bytes.is_data(f) else 0)
        for x in range(ea, min(HI, ea + sz)): st[x] |= v
        st[ea] |= 4
    for f in idautils.Functions():
        if f < HI: st[f] |= 8
    with open(os.path.join(OUT, "dbstate.bin"), "wb") as fh:
        fh.write(bytes(st))
    with open(os.path.join(OUT, "fingerprint.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("funcs=%d heads=%d codebytes_scope=%d win_heads=%d odd=%d xrefs_from_code=%d hash=%s win_hash=%s\n" %
                 (len(funcs), len(heads), cb, len(win), len(odd), nx, h, wh))
        fh.write("idb=%s\n" % idc.get_idb_path())


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

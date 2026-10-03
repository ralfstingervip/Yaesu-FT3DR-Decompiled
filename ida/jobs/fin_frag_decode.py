r"""Lane F2 — per-fragment authoritative classification of the 505 sub-16B
non-closed 'other' fragments. For each: does it tile cleanly as H8S
instruction(s) (=> code), is it all padding (=> fill), or is it the tail of an
instruction that starts in the previous run (mid-instruction straddle => code),
else leave as data/interstitial. decode_insn based; reopen FIN_MAIN_OTHER.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, csv, traceback
import ida_auto, ida_bytes, ida_ua, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-raw-other")
TYPES = os.path.join(ROOT, "ida", "out", "wave2", "main-raw-types.tsv")
LOG = os.path.join(OUT, "ida_frag.log")
CLOSED_LO, CLOSED_HI = 0x078106, 0x07B100
PAD = (0x00, 0xFF, 0x20)


def clearrange(a, b):
    ea = a
    while ea < b:
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE)
        ea += 1


def main():
    ida_auto.auto_wait()
    try:
        ida_auto.enable_auto(False)
    except Exception:
        pass
    insn = ida_ua.insn_t()
    rows = []
    with open(TYPES, encoding="utf-8") as h:
        r = csv.reader(h, delimiter="\t"); next(r)
        for x in r:
            if x and not x[0].startswith("#"):
                rows.append((int(x[0], 16), int(x[1], 16), int(x[2]), x[3]))

    frags = [(s, e, L) for (s, e, L, t) in rows
             if t == "other" and not (CLOSED_LO <= s <= CLOSED_HI) and L < 16]

    def tiles(s, e):
        """True if [s,e) is exactly covered by valid insns from s."""
        cur = s
        while cur < e:
            sz = ida_ua.decode_insn(insn, cur)
            if sz <= 0 or insn.itype == 0:
                return False, cur
            cur += sz
        return (cur == e), cur

    def straddle(s):
        """is s inside an instruction that starts up to 10 bytes earlier?"""
        for k in range(2, 12, 2):
            a = s - k
            sz = ida_ua.decode_insn(insn, a)
            if sz > 0 and insn.itype != 0 and a + sz > s:
                return a, sz
        return None, 0

    out = []
    for s, e, L in frags:
        clearrange(s - 12, e + 2)
        b = ida_bytes.get_bytes(s, L) or b""
        pad = sum(1 for c in b if c in PAD)
        cl, _ = tiles(s, e)
        st_a, st_sz = straddle(s)
        if pad == L:
            cls = "fill"
            ev = "all padding (00/FF/20)"
        elif cl:
            # decode once more to name first insn
            ida_ua.decode_insn(insn, s)
            cls = "code-clean"
            ev = "tiles as %d-byte H8S insn(s) from run start" % L
        elif st_a is not None:
            cls = "code-straddle"
            ev = "mid-instruction: insn at %06X (+%d) crosses run start" % (st_a, st_sz)
        else:
            cls = "data"
            ev = "no clean tile, not mid-insn, not pad"
        out.append((s, e, L, cls, pad, ev, b.hex()))

    with open(os.path.join(OUT, "fragments.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("start\tend\tbytes\tclass\tpad\tevidence\thex\n")
        for s, e, L, cls, pad, ev, hx in out:
            fh.write("%06X\t%06X\t%d\t%s\t%d\t%s\t%s\n" % (s, e, L, cls, pad, ev, hx))

    import collections
    cc = collections.Counter(); cb = collections.Counter()
    for s, e, L, cls, pad, ev, hx in out:
        cc[cls] += 1; cb[cls] += L
    with open(LOG, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("fragments=%d\n" % len(out))
        for c in cc:
            fh.write("  %-14s %d runs %d B\n" % (c, cc[c], cb[c]))


try:
    main()
except Exception:
    with open(LOG, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("TRACE\n" + traceback.format_exc())
idc.qexit(0)

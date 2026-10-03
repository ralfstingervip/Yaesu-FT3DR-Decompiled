# -*- coding: utf-8 -*-
r"""Lane L1 - build the MAIN_FINAL5 proven/named masks from the published FINAL4 masks.

Owner-side static analysis. Read-only on every input. The only deltas applied are the two
the K wave + follow-up resolved and the task names:

  1. -278 B demotion of 0x054AE2-0x054BF7 (I12 convention: drop from PROVEN only; the bytes
     stay disassembled DB code, so NAMED is unchanged).  Evidence: docs 64/69 (I12 is a
     proven-mask overlay, not a DB edit) and doc 83 addendum + candidate-054AE2.tsv.
  2. +868 B service-window code folded into BOTH masks: the 13 ranges in doc 95 that are the
     code bytes of 0x078106-0x078545 left clear in both FINAL4 masks.

No other demotion. The low region 0x400-0x078106 is not touched.

Output: ida\out\main-final5\{final5_proven_mask.bin, final5_named_mask.bin, ledger.tsv,
final4-to-final5-diff.tsv}. Masks keep the FINAL4 format: 1,048,576 bytes, one 0/1 byte per
address, zero above 0x07B754.
"""
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import os, hashlib

ROOT = str(_REPO)
F4 = os.path.join(ROOT, "ida", "out", "main-final4")
F5 = os.path.join(ROOT, "ida", "out", "main-final5")

DEMOTE = (0x054AE2, 0x054BF8)          # [lo, hi) == 278 B, from candidate-054AE2.tsv
WIN_RANGES = [                          # inclusive [lo, hi]; doc 95 "Code bytes unset in that mask: 868"
    (0x07810C, 0x07815B), (0x0781A4, 0x0781A9), (0x0781C4, 0x078221),
    (0x07823C, 0x07825F), (0x078268, 0x078279), (0x07827C, 0x078333),
    (0x07833C, 0x07837B), (0x078384, 0x0783D9), (0x0783EE, 0x07842D),
    (0x078440, 0x078441), (0x078448, 0x078459), (0x078462, 0x078507),
    (0x078514, 0x078545),
]


def popcount(b):
    return sum(b)


def sha(b):
    return hashlib.sha256(bytes(b)).hexdigest()[:16]


def load(name):
    with open(os.path.join(F4, name), "rb") as h:
        return h.read()


def main():
    p4 = load("final4_proven_mask.bin")
    n4 = load("final4_named_mask.bin")
    assert len(p4) == len(n4) == 1048576, (len(p4), len(n4))
    assert set(p4) <= {0, 1} and set(n4) <= {0, 1}
    base_p, base_n = popcount(p4), popcount(n4)
    assert base_p == 368624, base_p
    assert base_n == 497451, base_n

    # pre-checks the headline arithmetic depends on
    dlo, dhi = DEMOTE
    assert popcount(p4[dlo:dhi]) == dhi - dlo == 278, "demoted range must be fully proven in FINAL4"
    assert popcount(n4[dlo:dhi]) == 278, "demoted range must be fully named in FINAL4"
    win_total = 0
    for lo, hi in WIN_RANGES:
        seg_p = popcount(p4[lo:hi + 1]); seg_n = popcount(n4[lo:hi + 1])
        assert seg_p == 0, ("window range already proven", hex(lo))
        assert seg_n == 0, ("window range already named", hex(lo))
        win_total += hi - lo + 1
    assert win_total == 868, win_total

    p5 = bytearray(p4)
    n5 = bytearray(n4)

    # (1) demotion: proven only
    for x in range(dlo, dhi):
        p5[x] = 0

    # (2) window +868 into both
    for lo, hi in WIN_RANGES:
        for x in range(lo, hi + 1):
            p5[x] = 1
            n5[x] = 1

    pv5, nm5 = popcount(p5), popcount(n5)
    assert pv5 == 368624 - 278 + 868 == 369214, pv5
    assert nm5 == 497451 + 868 == 498319, nm5
    # proven subset of named (the demoted bytes stay named, so still a subset)
    assert all(not (p5[i] and not n5[i]) for i in range(1048576)), "proven must be subset of named"
    # nothing above content boundary
    assert popcount(p5[0x07B754:]) == 0 and popcount(n5[0x07B754:]) == 0

    os.makedirs(F5, exist_ok=True)
    with open(os.path.join(F5, "final5_proven_mask.bin"), "wb") as h:
        h.write(bytes(p5))
    with open(os.path.join(F5, "final5_named_mask.bin"), "wb") as h:
        h.write(bytes(n5))

    # ---- ledger ----
    with open(os.path.join(F5, "ledger.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("term\tdelta\tvalue\tnote\n")
        rows = [
            ("MAIN proven, FINAL4 (final4_proven_mask.bin)", "", 368624, "one folded descent, I12(-120) applied"),
            ("demote 0x054AE2-0x054BF7 (fnindex-seed only, no inbound edge)", "-278", "", "I12 convention: proven-mask overlay, bytes stay DB code"),
            ("+service-window code 0x078106-0x078545 (doc 95, 13 ranges)", "+868", "", "clear in both FINAL4 masks; 336/336 heads vs oracle bu_all.tsv"),
            ("MAIN proven, FINAL5 (final5_proven_mask.bin)", "", 369214, "72.97%% of 505684 content"),
            ("MAIN named/typed, FINAL4 (final4_named_mask.bin)", "", 497451, ""),
            ("demote 0x054AE2-0x054BF7 (named unchanged, I12 convention)", "+0", "", "demoted code stays typed"),
            ("+service-window code 0x078106-0x078545 (doc 95, 13 ranges)", "+868", "", "clear in both FINAL4 masks"),
            ("MAIN named/typed, FINAL5 (final5_named_mask.bin)", "", 498319, "98.54%% of 505684 content"),
        ]
        for a, b, c, d in rows:
            h.write("%s\t%s\t%s\t%s\n" % (a, b, c, d))

    # ---- diff runs (final4 -> final5), contiguous ----
    def runs(delta_mask):
        out = []
        i = 0
        n = len(delta_mask)
        while i < n:
            if delta_mask[i]:
                j = i
                while j < n and delta_mask[j]:
                    j += 1
                out.append((i, j))
                i = j
            else:
                i += 1
        return out

    dp_add = bytearray(1048576)  # proven gained (final5 & ~final4)
    dp_rem = bytearray(1048576)  # proven lost  (final4 & ~final5)
    dn_add = bytearray(1048576)  # named gained
    for i in range(1048576):
        if p5[i] and not p4[i]: dp_add[i] = 1
        if p4[i] and not p5[i]: dp_rem[i] = 1
        if n5[i] and not n4[i]: dn_add[i] = 1

    with open(os.path.join(F5, "final4-to-final5-diff.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("mask\tdirection\tstart\tend_excl\tlen\tsource\n")
        for a, b in runs(dp_rem):
            h.write("proven\tremoved\t%06X\t%06X\t%d\tdemotion 054AE2-054BF7\n" % (a, b, b - a))
        for a, b in runs(dp_add):
            h.write("proven\tadded\t%06X\t%06X\t%d\tservice-window code (doc 95)\n" % (a, b, b - a))
        for a, b in runs(dn_add):
            h.write("named\tadded\t%06X\t%06X\t%d\tservice-window code (doc 95)\n" % (a, b, b - a))

    print("final5_proven_mask.bin popcount %d  sha %s" % (pv5, sha(p5)))
    print("final5_named_mask.bin  popcount %d  sha %s" % (nm5, sha(n5)))
    print("proven delta: -%d demote, +%d window ; net %+d" % (278, 868, pv5 - base_p))
    print("named  delta: +%d window ; net %+d" % (868, nm5 - base_n))
    print("proven removed runs: %d ; proven added runs: %d ; named added runs: %d" % (
        len(runs(dp_rem)), len(runs(dp_add)), len(runs(dn_add))))
    print("OK")


if __name__ == "__main__":
    main()

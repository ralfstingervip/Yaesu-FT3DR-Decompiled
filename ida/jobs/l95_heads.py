# -*- coding: utf-8 -*-
"""Emit the confirmed instruction list, including gap routines. Read-only."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, sys
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
from common import IMG, flow

OUT = str(_REPO / "ida/out/service-window")
W0, W1 = 0x078106, 0x07B754

def hx(a, n):
    return " ".join("%02x" % b for b in IMG[a:a + n])

# instruction starts already proved by the first descent, plus gap entry points
# that linear-align onto that set or onto an rts.
EXTRA = [0x0781C6, 0x0781DE, 0x078256, 0x0784BE]

# load existing insns
have = {}
with open(os.path.join(OUT, "insns.tsv"), encoding="utf-8") as h:
    next(h)
    for ln in h:
        c = ln.rstrip("\n").split("\t")
        have[int(c[0], 16)] = (int(c[1]), c[4])

def follow(start, stop_before):
    out = []
    a = start
    seen = set()
    while a < stop_before and a not in seen:
        seen.add(a)
        n, t, k, tg = flow(a)
        if k == "bad" or n <= 0 or a + n > W1:
            out.append((a, 0, k, t))
            break
        out.append((a, n, k, t))
        if k in ("stop", "stops"):
            if k == "stops":
                b = a + n
                n2, t2, k2, tg2 = flow(b)
                if n2 and k2 != "bad":
                    out.append((b, n2, k2, t2))
            break
        a += n
        if a in have and a != start:
            # joined a previously reached insn; stop before duplicating the walk
            break
    return out

lines = []
new = {}
for s, lim in ((0x0781C6, 0x0781DE), (0x0781DE, 0x078222), (0x078256, 0x078260), (0x0784BE, 0x078508)):
    lines.append("\n; ---- from %06X ----" % s)
    for a, n, k, t in follow(s, lim):
        if n == 0:
            lines.append("%06X BAD %s" % (a, t))
            break
        lines.append("%06X  %-24s  %s" % (a, hx(a, n), t))
        new[a] = (n, t)

# pointer / jsr search for the gap entries
need = [0x0781C6, 0x0781DE, 0x0781FC, 0x07821E, 0x078256, 0x07823C, 0x078334,
        0x0783DA, 0x07842E, 0x078442, 0x0784BE, 0x078508, 0x078260, 0x07845A]
lines.append("\n; ---- image references (BE24 after 5A/5E, or BE32) ----")
for dst in need:
    hits = []
    b3 = dst.to_bytes(3, "big")
    b4 = dst.to_bytes(4, "big")
    i = 0
    while True:
        j = IMG.find(b3, i)
        if j < 0:
            break
        if j > 0 and IMG[j - 1] in (0x5A, 0x5E):
            hits.append("jsr/jmp@%06X" % (j - 1))
        i = j + 1
        if len(hits) > 8:
            break
    i = 0
    while True:
        j = IMG.find(b4, i)
        if j < 0:
            break
        hits.append("be32@%06X" % j)
        i = j + 1
        if len(hits) > 12:
            break
    lines.append("%06X  %s" % (dst, ", ".join(hits) or "NONE"))

# bsr into window from anywhere flow() on even addresses in 0x070000-0x078106
# only where the insn is a bsr/bra and target in window. Sample by checking opcode bytes
# 55 = bra/bsr? We'll just use flow on addresses where IMG[a] in (0x55, 0x5C) inside the module.
lines.append("\n; ---- relative branch opcodes in 070000-078106 targeting the window ----")
nrel = 0
for a in range(0x070000, 0x078106):
    if IMG[a] not in (0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x4C, 0x4D, 0x4E, 0x4F,
                      0x55, 0x58, 0x59, 0x5C):
        continue
    n, t, k, tg = flow(a)
    if k == "bad":
        continue
    for x in tg:
        if W0 <= x < W1:
            lines.append("%06X -> %06X %s" % (a, x, t))
            nrel += 1
            if nrel > 40:
                break
    if nrel > 40:
        break
lines.append("rel_hits %d" % nrel)

text = "\n".join(lines) + "\n"
with open(os.path.join(OUT, "gap-routines.txt"), "w", encoding="utf-8", newline="\n") as h:
    h.write(text)
print(text)

# merged heads
allh = dict(have)
for a, (n, t) in new.items():
    if a in allh and allh[a] != (n, t):
        print("CONFLICT %06X old %s new %s" % (a, allh[a], (n, t)))
    allh[a] = (n, t)
# overlap check
owner = {}
ok = True
for a, (n, t) in sorted(allh.items()):
    for i in range(n):
        if a + i in owner:
            print("OVERLAP %06X and %06X" % (owner[a + i], a))
            ok = False
        owner[a + i] = a
print("heads %d bytes %d overlap_ok %s" % (len(allh), len(owner), ok))
with open(os.path.join(OUT, "code-heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("addr\tlen\thex\ttext\n")
    for a in sorted(allh):
        n, t = allh[a]
        h.write("%06X\t%d\t%s\t%s\n" % (a, n, hx(a, n), t))

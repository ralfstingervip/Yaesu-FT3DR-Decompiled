# -*- coding: utf-8 -*-
"""Read-only facts for the service window. Does not write the image or any mask."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, sys, bisect, hashlib
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
from common import IMG, flow

OUT = str(_REPO / "ida/out/service-window")
W0, W1 = 0x078106, 0x07B754
MASK = str(_REPO / "ida/out/main-final4/final4_proven_mask.bin")
REACH = str(_REPO / "ida/out/main-descent/work/reached_insns.tsv")

def hx(a, n):
    return " ".join("%02x" % b for b in IMG[a:a + n])

def be16(a):
    return (IMG[a] << 8) | IMG[a + 1]

heads = {}
with open(os.path.join(OUT, "code-heads.tsv"), encoding="utf-8") as h:
    next(h)
    for ln in h:
        c = ln.rstrip("\n").split("\t")
        a = int(c[0], 16)
        n = int(c[1])
        heads[a] = (n, c[3])

bad = []
for a, (n, t) in sorted(heads.items()):
    fn, ft, fk, tg = flow(a)
    raw = bytes(int(x, 16) for x in hx(a, n).split())
    if fn != n or ft != t or IMG[a:a + n] != raw:
        bad.append((a, n, t, fn, ft))
print("head_check", len(heads), "mismatch", len(bad))
for row in bad[:10]:
    print("  MIS", "%06X" % row[0], row)

owner = {}
for a, (n, t) in heads.items():
    for i in range(n):
        owner[a + i] = a
assert min(owner) == W0 and max(owner) + 1 == 0x078546
assert len(owner) == 0x078546 - W0

reached = {}
with open(REACH, encoding="utf-8") as h:
    next(h)
    for ln in h:
        c = ln.rstrip("\n").split("\t")
        reached[int(c[0], 16)] = c[2]
hs = sorted(reached)

def walk_to(dest, limit=0x2000):
    i = bisect.bisect_right(hs, dest) - 1
    best = None
    seen_starts = 0
    while i >= 0 and seen_starts < 60 and dest - hs[i] <= limit:
        s = hs[i]
        seen_starts += 1
        a = s
        guard = 0
        trail = []
        while a <= dest and guard < 500:
            guard += 1
            n, t, k, tg = flow(a)
            if n <= 0 or k == "bad":
                break
            trail.append((a, n, t, k))
            if a == dest:
                best = (s, dest - s, trail[-6:])
                return best
            if k == "stops":
                b = a + n
                n2, t2, k2, tg2 = flow(b)
                if n2 and k2 != "bad":
                    trail.append((b, n2, t2, k2))
                    if b == dest:
                        return (s, dest - s, trail[-6:])
                break
            if k == "stop":
                break
            a += n
        i -= 1
    return best

cands = [
    (0x076844, 0x078334), (0x0768A2, 0x078334), (0x076916, 0x078334),
    (0x0769E6, 0x078334), (0x076B46, 0x078334),
    (0x076944, 0x07837C), (0x076AD8, 0x07837C), (0x076B1A, 0x07837C),
    (0x076A08, 0x0783DA), (0x076B6A, 0x0783DA),
    (0x076A88, 0x07823C), (0x076BEA, 0x07823C),
    (0x076A8E, 0x07821E), (0x076BF2, 0x07821E),
    (0x076D84, 0x078442), (0x076DE0, 0x078442), (0x076E3C, 0x078442),
    (0x076E9C, 0x078442), (0x076F54, 0x078442),
    (0x076F30, 0x078508),
]
lines = []
for src, dst in cands:
    n, t, k, tg = flow(src)
    hit = walk_to(src)
    in_h9 = src in reached
    ok = (n and t.startswith("jsr") and dst in tg and hit is not None)
    lines.append("%06X -> %06X flow=%s h9=%d walk=%s" % (
        src, dst, t, int(in_h9),
        ("%06X dist %d" % (hit[0], hit[1])) if hit else "NONE"))
    if hit:
        for a, nn, tt, kk in hit[2]:
            lines.append("    %06X  %s  %s" % (a, hx(a, nn), tt))
    lines.append("    ALIGNED %s" % ok)

# internal branch targets that are function-like and not fallthrough-only
fn_starts = [0x078106, 0x07815C, 0x0781C6, 0x0781DE, 0x07821E, 0x078222,
             0x07823C, 0x078256, 0x078260, 0x07827C, 0x078334, 0x07837C,
             0x0783DA, 0x07842E, 0x078442, 0x07845A, 0x0784BE, 0x078508]
tgt_hits = {s: [] for s in fn_starts}
for a, (n, t) in heads.items():
    nn, tt, k, tg = flow(a)
    for x in tg:
        if x in tgt_hits and x != a + n:
            tgt_hits[x].append(a)
lines.append("\n== internal direct targets ==")
for s in fn_starts:
    lines.append("%06X %s" % (s, ", ".join("%06X" % x for x in tgt_hits[s]) or "none"))

# switch table
lines.append("\n== switch 078546 ==")
plus = sh = 0
for i in range(45):
    w = be16(0x078546 + 2 * i)
    t1 = 0x07630A + w
    t2 = 0x07630A + (w >> 1)
    plus += int(t1 in reached)
    sh += int(t2 in reached)
lines.append("plus_head %d shlr_head %d" % (plus, sh))

# mask
mask = open(MASK, "rb").read()
set_all = sum(1 for b in mask if b)
code_unset = []
win_set = []
for a in range(W0, W1):
    if mask[a]:
        win_set.append(a)
runs = []
a = 0x078106
while a < 0x078546:
    if mask[a] == 0:
        b = a
        while b < 0x078546 and mask[b] == 0:
            b += 1
        runs.append((a, b - 1, b - a))
        a = b
    else:
        a += 1
set_in_code = sum(1 for a in range(0x078106, 0x078546) if mask[a])
set_in_data = sum(1 for a in range(0x078546, W1) if mask[a])
lines.append("\n== mask ==")
lines.append("file %s len %d set %d" % (MASK, len(mask), set_all))
lines.append("window_set %d code_set %d code_unset %d data_set %d" % (
    len(win_set), set_in_code, (0x078546 - 0x078106) - set_in_code, set_in_data))
for a, b, n in runs:
    lines.append("  unset %06X-%06X (%d)" % (a, b, n))

# word stats
words = [be16(a) for a in range(0x078600, 0x07B260, 2)]
lines.append("\n== words 078600-07B25F n %d min %04x max %04x unique %d ==" % (
    len(words), min(words), max(words), len(set(words))))

# pair list
lines.append("pair %06X-%06X bytes %d words %d" % (
    0x07B2A6, 0x07B4B2, 0x07B4B2 - 0x07B2A6, (0x07B4B2 - 0x07B2A6) // 2))
lines.append("pair head %s" % hx(0x07B2A6, 16))
lines.append("pair tail %s" % hx(0x07B4A2, 16))

# handler records
lines.append("\n== handlers at 07B4B4 ==")
a = 0x07B4B4
k = 0
while k < 8:
    rec = IMG[a:a + 10]
    lines.append("  %06X %s" % (a, hx(a, 10)))
    if rec[4] == 0xFF:
        break
    a += 10
    k += 1

# selected images
for name, a, n in (
    ("ee32", 0x07B61E, 50),
    ("dev", 0x07B680, 18),
    ("cfg", 0x07B711, 0x43),
    ("str", 0x07B270, 0x36),
    ("ff6240img", 0x07B4B2, 4),
    ("ff6288img", 0x07B4FA, 32),
    ("ff62c8img", 0x07B53A, 16),
    ("ff62d8img", 0x07B54A, 16),
    ("ff62f8img", 0x07B56A, 4),
    ("ff6330img", 0x07B5A2, 4),
    ("ff6354img", 0x07B5C6, 48),
):
    lines.append("%s %06X %s" % (name, a, hx(a, n)))

# pointers to notable addresses
want = [0x0781C6, 0x0781DE, 0x078256, 0x07842E, 0x0784BE, 0x078106,
        0x07B276, 0x07B286, 0x07B680, 0x07B698, 0x07B711, 0x07B2A6,
        0xFF640E, 0xFF649F, 0xFF6034]
lines.append("\n== be32 sites ==")
for dst in want:
    b4 = dst.to_bytes(4, "big")
    i = 0
    hits = []
    while True:
        j = IMG.find(b4, i)
        if j < 0:
            break
        hits.append(j)
        i = j + 1
        if len(hits) > 8:
            break
    lines.append("%08X %s" % (dst, ", ".join("%06X" % x for x in hits) or "NONE"))

# ACME
acme = IMG[0x07B698:0x07B698 + 0x79]
lines.append("acme_len_prefix %s ascii %s" % (hx(0x07B696, 4), acme.decode("latin1")))

# eepmov sites
lines.append("\n== eepmov ==")
for s in (0x002152, 0x00251E):
    a = s
    for _ in range(6):
        n, t, k, tg = flow(a)
        lines.append("  %06X %s %s" % (a, hx(a, n), t))
        if k in ("stop", "stops") or n <= 0:
            break
        a += n

# gates and named outside insns
named = [0x0021FA, 0x0021FE, 0x002200, 0x002202, 0x002204, 0x002206,
         0x002214, 0x002218, 0x00221C, 0x002224, 0x002228, 0x002234,
         0x054D54, 0x054D58, 0x054EA8, 0x054EB0, 0x054EC0,
         0x05DCFE, 0x05DD02, 0x05DD06, 0x05DD08, 0x05DD12,
         0x05DD8A, 0x05DD98, 0x05DD9E,
         0x07615E, 0x076186, 0x076190, 0x07619A, 0x0761A4, 0x0761AE, 0x0761B8, 0x0761C0,
         0x0761D4, 0x0761DA, 0x0761E2, 0x0761FA, 0x0762EA, 0x0762FE, 0x076306, 0x076308, 0x0767B6,
         0x0768A8, 0x0768B0, 0x0768B6, 0x0768BC, 0x0768C0,
         0x076FC8, 0x076FD2, 0x077008, 0x07701E, 0x077022]
lines.append("\n== named ==")
for a in named:
    n, t, k, tg = flow(a)
    h9 = reached.get(a, "")
    flag = "OK" if h9 == t else "H9DIFF"
    lines.append("%06X %s %s %s [%s]" % (a, hx(a, n), t, flag, h9))

sha = hashlib.sha256(IMG).hexdigest()
lines.append("\nsha %s len %d" % (sha, len(IMG)))
lines.append("span %d last %02x next %02x" % (W1 - W0, IMG[0x07B753], IMG[0x07B754]))

text = "\n".join(lines) + "\n"
with open(os.path.join(OUT, "facts.txt"), "w", encoding="utf-8", newline="\n") as h:
    h.write(text)
print(text)

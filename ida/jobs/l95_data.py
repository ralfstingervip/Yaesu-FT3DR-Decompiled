# -*- coding: utf-8 -*-
"""Read-only follow-up: gaps, copied .data, lookup tables. No image writes."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import collections, os, sys
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
from common import IMG, flow, be32

OUT = str(_REPO / "ida/out/service-window")
W0, W1 = 0x078106, 0x07B754

def hx(a, n):
    return " ".join("%02x" % b for b in IMG[a:a + n])

def be16(a):
    return (IMG[a] << 8) | IMG[a + 1]

def dump_flow(a, nins, limit):
    lines = []
    for _ in range(nins):
        if a >= limit:
            break
        n, t, k, tg = flow(a)
        if k == "bad" or n <= 0:
            lines.append("%06X  BAD %s" % (a, t))
            break
        lines.append("%06X  %-22s  %s" % (a, hx(a, n), t))
        if k in ("stop", "stops"):
            if k == "stops":
                b = a + n
                n2, t2, k2, tg2 = flow(b)
                if n2:
                    lines.append("%06X  %-22s  %s" % (b, hx(b, n2), t2))
            break
        a += n
    return lines

lines = []
P = lines.append

# ---- gaps: try every even start, see if a clean flow reaches the next code ----
gaps = [(0x0781C6, 0x0781FC, 0x0781FC), (0x078256, 0x078260, 0x078260), (0x0784BE, 0x078508, 0x078508)]
P("== gap alignment ==")
for lo, hi, nxt in gaps:
    P("\n-- gap %06X-%06X next %06X --" % (lo, hi - 1, nxt))
    P("hex %s" % hx(lo, hi - lo))
    for s in range(lo, hi, 2):
        a = s
        ok = True
        ins = 0
        while a < hi:
            n, t, k, tg = flow(a)
            if k == "bad" or n <= 0 or a + n > hi:
                ok = False
                break
            ins += 1
            if k in ("stop", "stops"):
                # ended inside the gap
                P("  start %06X ends-inside-at %06X after %d  last %s" % (s, a, ins, t))
                ok = False
                break
            a += n
        if ok and a == hi:
            P("  ALIGN %06X -> %06X in %d insns" % (s, hi, ins))

# ---- who points into the gaps (5E/5A and bsr from reached text already known). Raw jsr into gap.
P("\n== jsr/jmp immediates into gaps or 0781FC ==")
for i in range(0, len(IMG) - 3):
    if IMG[i] in (0x5A, 0x5E):
        dst = int.from_bytes(IMG[i + 1:i + 4], "big")
        if 0x0781C6 <= dst < 0x078260 or 0x0784BE <= dst < 0x078508 or dst in (0x0781FC, 0x07821E, 0x07823C, 0x078334, 0x0783DA, 0x07842E, 0x078442, 0x078508):
            n, t, k, tg = flow(i)
            P("  %06X -> %06X agreed %d headtext %s" % (i, dst, int(k != "bad" and dst in tg), t if k != "bad" else ""))

# ---- caller alignment: does some even address flow onto the jsr site in <= 24 bytes?
P("\n== caller-site alignment (prev insn length lands on site) ==")
sites = [0x076844, 0x0768A2, 0x076916, 0x076944, 0x0769E6, 0x076A08, 0x076A88, 0x076A8E,
         0x076AD8, 0x076B1A, 0x076B46, 0x076B6A, 0x076BEA, 0x076BF2, 0x076D84, 0x076DE0,
         0x076E3C, 0x076E9C, 0x076F30, 0x076F54, 0x078212]
for site in sites:
    hits = []
    for back in range(2, 12):
        n, t, k, tg = flow(site - back)
        if k != "bad" and n == back:
            hits.append((site - back, t))
    P("  %06X prev %s" % (site, "; ".join("%06X %s" % h for h in hits[:4]) or "NONE"))

# ---- .data image key offsets ----
COPY_F, COPY_R, COPY_L = 0x07B2A6, 0xFF6034, 0x4AE

def ram2fl(r):
    return COPY_F + (r - COPY_R)

P("\n== copied-image slots referenced by window code ==")
rams = [0xFF6240, 0xFF6242, 0xFF6246, 0xFF6288, 0xFF62C8, 0xFF62D8, 0xFF62F8,
        0xFF6330, 0xFF6354, 0xFF6358, 0xFF6360, 0xFF63AC, 0xFF63F8, 0xFF640E, 0xFF649F]
for r in rams:
    f = ram2fl(r)
    P("  ram %06X flash %06X  %s" % (r, f, hx(f, 16)))

P("\n== handler table at flash image of FF6242 (10-byte records, stop when +4 == FF) ==")
f = ram2fl(0xFF6242)
for i in range(8):
    rec = f + 10 * i
    if rec + 10 > COPY_F + COPY_L:
        break
    mask = be32(rec)
    b4 = IMG[rec + 4]
    handler = be32(rec + 6)
    P("  [%d] %06X mask %08X b4 %02X handler %08X  raw %s" % (i, rec, mask, b4, handler, hx(rec, 10)))
    if b4 == 0xFF:
        break

P("\n== 50 bytes programmed to FFEE32 (ram FF63AC) ==")
f = ram2fl(0xFF63AC)
P(hx(f, 50))
P("as bytes: " + " ".join("%02x" % IMG[f + i] for i in range(50)))

P("\n== byte tables 0785A0-0785FF ==")
for base in (0x0785A0, 0x0785B0, 0x0785C0, 0x0785D0, 0x0785E0, 0x0785F0):
    P("  %06X  %s" % (base, hx(base, 16)))

P("\n== jump table words already known; first case body 07630A ==")
for ln in dump_flow(0x0762DC, 40, 0x076400):
    P(ln)

# table sizes
refs = []
# parse outside-refs quickly from known list in the file
path = os.path.join(OUT, "outside-refs.tsv")
with open(path, encoding="utf-8") as h:
    next(h)
    for ln in h:
        c = ln.rstrip("\n").split("\t")
        refs.append((int(c[1], 16), int(c[0], 16), c[3]))
# unique targets >= 078546
tgts = sorted({t for t, s, tx in refs if t >= 0x078546})
P("\n== table spans (to next target) ==")
for i, t in enumerate(tgts):
    nxt = tgts[i + 1] if i + 1 < len(tgts) else 0x07B2A6
    # sample words
    if t >= 0x078600 and (nxt - t) >= 4 and (nxt - t) % 2 == 0:
        nwords = min(8, (nxt - t) // 2)
        words = " ".join("%04x" % be16(t + 2 * k) for k in range(nwords))
        last = " ".join("%04x" % be16(nxt - 2 * (k + 1)) for k in range(min(4, nwords)))
        P("  %06X..%06X %4d B  first %s  last %s" % (t, nxt - 1, nxt - t, words, last))
    else:
        P("  %06X..%06X %4d B  %s" % (t, nxt - 1, nxt - t, hx(t, min(16, nxt - t))))

# value histogram for the big region 078600-07B260: unique word count, min max
P("\n== word stats 078600-07B25F ==")
words = [be16(a) for a in range(0x078600, 0x07B260, 2)]
P("n %d min %04x max %04x unique %d" % (len(words), min(words), max(words), len(set(words))))
# how many look like incrementing runs
P("first 24 %s" % " ".join("%04x" % w for w in words[:24]))
P("at 078740 %s" % " ".join("%04x" % be16(0x078740 + 2 * i) for i in range(12)))

# stores of FFBC76/77/79/70 anywhere: 32-bit abs 00 FF BC 7x or 16-bit
P("\n== byte patterns FF BC 7x ==")
pat = bytes([0x00, 0xFF, 0xBC])
idx = 0
count = 0
while True:
    i = IMG.find(pat, idx)
    if i < 0 or count > 60:
        break
    if IMG[i + 3] in range(0x70, 0x80):
        n, t, k, tg = flow(i - 2) if i >= 2 else (0, "", "bad", [])
        # try a few starts
        shown = False
        for back in (2, 4, 6, 8):
            if i - back < 0:
                continue
            n, t, k, tg = flow(i - back)
            if k != "bad" and n > back and (i - back + n) >= i + 4:
                P("  site %06X insn %06X %s" % (i, i - back, t))
                shown = True
                break
        if not shown:
            P("  raw %06X %s" % (i, hx(i - 2, 10)))
        count += 1
    idx = i + 1
P("pattern hits shown %d" % count)

# second reference 002522
P("\n== around 002522 and 002156 ==")
for ln in dump_flow(0x002140, 20, 0x002180):
    P(ln)
P("---")
for ln in dump_flow(0x002500, 16, 0x002560):
    P(ln)

# 077E3A / 077F52 context (short)
P("\n== 077E20 and 077F40 ==")
for ln in dump_flow(0x077E20, 16, 0x077E60):
    P(ln)
P("---")
for ln in dump_flow(0x077F40, 16, 0x077F70):
    P(ln)

# descriptor walk at 07B680
P("\n== descriptor walk 07B680 ==")
a = 0x07B680
end = 0x07B754
# device is 18 bytes then strings may follow
P("device %s" % hx(0x07B680, 18))
# walk config at 07B711
a = 0x07B711
conf_end = a + be16(a + 2)
P("config %06X..%06X" % (a, conf_end))
while a < conf_end and a < end:
    ln = IMG[a]
    if ln < 2 or a + ln > end:
        P("  stop at %06X byte %02x" % (a, IMG[a]))
        break
    P("  %06X len %02X type %02X %s" % (a, ln, IMG[a + 1], hx(a, ln)))
    a += ln

# strings near descriptors
P("\n== 07B690-07B711 hex ==")
P(hx(0x07B690, 0x07B711 - 0x07B690))

# FF-fill check inside window
P("\n== long FF runs ==")
a = W0
while a < W1:
    if IMG[a] == 0xFF:
        s = a
        while a < W1 and IMG[a] == 0xFF:
            a += 1
        if a - s >= 8:
            P("  %06X-%06X (%d)" % (s, a - 1, a - s))
    else:
        a += 1

# what is between 07B1A0 and 07B2A6
P("\n== 07B200-07B2C0 hex rows ==")
for a in range(0x07B200, 0x07B2C0, 16):
    P("%06X  %s" % (a, hx(a, 16)))

text = "\n".join(lines) + "\n"
with open(os.path.join(OUT, "data-notes.txt"), "w", encoding="utf-8", newline="\n") as h:
    h.write(text)
print(text)

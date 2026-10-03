# -*- coding: utf-8 -*-
r"""Lane H3 offline scanner (plain Python, NOT an IDA script).

Image-wide scan of decrypted\FT3D_MAIN_ver102_EXP.bin (H8S/H8SX, big-endian,
base 0, content < 0x7B754) for arrays of BE32 code pointers that lie OUTSIDE the
149 resolved tables in ida\out\main-full\jumptables.tsv.

Inputs (read-only):
  decrypted\FT3D_MAIN_ver102_EXP.bin
  ida\out\main-full\jumptables.tsv                (the 149 known tables)
  ida\out\ptr-arrays\state\seed_bytemap.bin       (h3_dump_state.py, seed DB)
  ida\out\ptr-arrays\state\seed_funcs.tsv
  ida\out\main-indirect\proved.tsv, residual.tsv

Outputs: ida\out\ptr-arrays\arrays.tsv, xrefs.tsv, refsites.tsv

Tiers
  A  base is the d:32 of an H8SX indexed load  78 [1sss]0 6B 2d <base32>
     immediately followed by  jmp @ERd (59 d0) / jsr @ERd (5D d0)
     -> a compiler switch / call-through dispatch. Strongest.
  B  stride-4 run (>=2) referenced by some other instruction whose operand lies in
     [base-0x10, end): indexed load not followed by a jump, mov.l #imm32
     (7A 0d), or mov.l @aa:32 (01 00 6B 2d).
  C  stride-4 run (>=2), no referencing instruction found, but every slot is
     non-code in the seed DB and every target is a function start or the shared
     sentinel 0x3FFA0 (and the run is not one repeated value).
  X  rejected candidate (code bytes misread as a pointer pair, numeric data).
Only A, B and C rows go to xrefs.tsv.
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import bisect, collections, os, re

W = str(_REPO)
IMG = os.path.join(W, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
OUT = os.path.join(W, "ida", "out", "ptr-arrays")
HI = 0x7B754
SENT = 0x0003FFA0
CLOSED = (0x078106, 0x07B754)

d = sys.exit("The firmware image is not in this repository.")
bm = open(os.path.join(OUT, "state", "seed_bytemap.bin"), "rb").read()


def be(a):
    return int.from_bytes(d[a:a + 4], "big")


def load_starts(path):
    s = set()
    with open(path, encoding="utf-8") as h:
        next(h)
        for line in h:
            p = line.split("\t")
            try:
                s.add(int(p[0], 16))
            except ValueError:
                pass
    return s


funcs = load_starts(os.path.join(OUT, "state", "seed_funcs.tsv"))
proved = load_starts(os.path.join(W, "ida", "out", "main-indirect", "proved.tsv"))
resid = load_starts(os.path.join(W, "ida", "out", "main-indirect", "residual.tsv"))
fstarts = funcs | proved | resid | {SENT}

tables = []
with open(os.path.join(W, "ida", "out", "main-full", "jumptables.tsv"), encoding="utf-8") as h:
    next(h)
    for line in h:
        p = line.split("\t")
        b = int(p[0], 16)
        tables.append((b, b + 4 * int(p[1])))
tables.sort()
tbases = {b for b, e in tables}


def intab(a):
    i = bisect.bisect_right(tables, (a, 1 << 40)) - 1
    return i >= 0 and tables[i][0] <= a < tables[i][1]


def valid(t):
    return 0x400 <= t < HI and t % 2 == 0 and (t in fstarts or bm[t] == 1)


def strong(t):
    """Target is a function start / sentinel, or a decoded code head that
    follows a block terminator (rts, rte, bra, jmp, or 0000 padding)."""
    if t in fstarts:
        return True
    if bm[t] != 1:
        return False
    p2 = d[t - 2:t]
    p4 = d[t - 4:t]
    return (p2 in (bytes([0x54, 0x70]), bytes([0x56, 0x70])) or p2[0] == 0x40
            or (p2[0] == 0x59 and (p2[1] & 0x8F) == 0) or p4[:2] == bytes([0x58, 0x00])
            or p4[0] == 0x5A or p2 == bytes([0, 0]))


def in_closed(a):
    return CLOSED[0] <= a < CLOSED[1]


# ---- referencing instructions (raw byte patterns, even addresses) ----
refs = []  # (insn, kind, value, dispatch)
for m in re.finditer(rb"\x78[\x00-\xf0]\x6b[\x20-\x27]", d[:HI]):
    a = m.start()
    if a % 2 or (d[a + 1] & 0x0F):
        continue
    r = d[a + 3] & 7
    nxt = d[a + 8:a + 10]
    disp = "jmp" if nxt == bytes([0x59, r << 4]) else "jsr" if nxt == bytes([0x5D, r << 4]) else ""
    refs.append((a, "ldx_d32" + ("+" + disp if disp else ""), be(a + 4), disp))
for m in re.finditer(rb"\x7a[\x00-\x07]", d[:HI]):
    a = m.start()
    if a % 2 == 0:
        refs.append((a, "movl_imm32", be(a + 2), ""))
for m in re.finditer(rb"\x01\x00\x6b[\x20-\x27]", d[:HI]):
    a = m.start()
    if a % 2 == 0:
        refs.append((a, "movl_abs32", be(a + 4), ""))
refs.sort(key=lambda x: x[2])
rvals = [x[2] for x in refs]


def refs_in(lo, hi):
    i = bisect.bisect_left(rvals, lo)
    out = []
    while i < len(refs) and rvals[i] < hi:
        out.append(refs[i])
        i += 1
    return out


dispatch_bases = sorted({v for a, k, v, ds in refs if ds and v % 2 == 0 and 0x400 <= v < HI})

arrays = {}  # base -> dict


def slot_classes(a, n):
    c = collections.Counter(bm[a:a + 4 * n])
    return c


# Tier A: dispatch sites
stops = tbases | set(dispatch_bases)
for b in dispatch_bases:
    if intab(b) or b in tbases:
        continue
    n = 0
    x = b
    # A dispatch-proven slot may point at code IDA never decoded (a case label),
    # so accept any even in-range target that is valid() or lies within 4 KB of
    # the table; bound an inline table by its first target above the base
    # (the code that follows the table) and by the next known table/dispatch base.
    bound = HI
    y = b
    while y < HI:
        t = be(y)
        if not (0x400 <= t < HI and t % 2 == 0):
            break
        if t > b:
            bound = min(bound, t)
        y += 4
    while (x < HI and x + 4 <= bound and not intab(x) and (x == b or x not in stops)
           and (be(x) == 0 or (0x400 <= be(x) < HI and be(x) % 2 == 0
                                 and (valid(be(x)) or abs(be(x) - b) < 0x1000)))):
        n += 1
        x += 4
    # null (0) slots are 'no handler' in sparse tables (e.g. 0x0704A2, whose
    # loader at 0x07039A tests the loaded pointer with beq); trim trailing nulls
    while n and be(b + 4 * (n - 1)) == 0:
        n -= 1
    # trim trailing entries that are weak AND far (>64 KB) from the array's
    # other targets: overrun into the following numeric data
    while n > 1:
        t = be(b + 4 * (n - 1))
        others = sorted(be(b + 4 * i) for i in range(n - 1) if be(b + 4 * i))
        if not others:
            break
        med = others[len(others) // 2]
        if not strong(t) and abs(t - med) > 0x10000:
            n -= 1
        else:
            break
    sites = [r for r in refs if r[2] == b and r[3]]
    arrays[b] = dict(base=b, n=n, tier="A" if n else "X",
                     refs=sites, note="" if n else "dispatch base, slot 0 not a code pointer")

# stride-4 runs
cand = [a for a in range(0, HI - 3, 2) if valid(be(a))]
cs = set(cand)
covered = set()
for b, info in arrays.items():
    for i in range(info["n"]):
        covered.add(b + 4 * i)
runs = []
seen = set()
for a in cand:
    if a in seen or (a - 4) in cs:
        continue
    n = 0
    x = a
    while x in cs:
        seen.add(x)
        n += 1
        x += 4
    runs.append((a, n))

for a, n in runs:
    if n < 2:
        continue
    slots = [a + 4 * i for i in range(n)]
    if all(intab(s) for s in slots):
        continue
    # trim slots already in the 149 tables or in a tier-A array
    slots = [s for s in slots if not intab(s) and s not in covered]
    # split on gaps
    groups = []
    for s in slots:
        if groups and s == groups[-1][-1] + 4:
            groups[-1].append(s)
        else:
            groups.append([s])
    for g in groups:
        if len(g) < 2 or a == 0:  # a==0: the exception vector table
            continue
        base, cnt = g[0], len(g)
        end = base + 4 * cnt
        rs = [r for r in refs_in(base - 0x10, end)]
        tg = [be(s) for s in g]
        cls = slot_classes(base, cnt)
        codebytes = cls.get(1, 0) + cls.get(2, 0)
        allf = all(t in fstarts for t in tg)
        nstrong = sum(1 for t in tg if strong(t))
        uniq = len(set(tg))
        if in_closed(base):
            tier, note = "X", "slots inside closed window 0x078106-0x07B753 (not analysed)"
        elif rs and codebytes <= 2 and (nstrong * 2 > cnt or (cnt > 2 and nstrong * 2 >= cnt)):
            tier, note = "B", ""
        elif rs and codebytes <= 2:
            tier, note = "X", "referenced, but only %d/%d targets look like code entries (numeric data)" % (nstrong, cnt)
        elif rs:
            tier, note = "X", "referenced but slots overlap decoded code (%d code bytes)" % codebytes
        elif codebytes == 0 and nstrong == cnt and uniq >= 2:
            tier, note = "C", "unreferenced; all targets function starts or block-entry code heads"
        else:
            why = []
            if codebytes:
                why.append("%d slot bytes are decoded code" % codebytes)
            if nstrong < cnt:
                why.append("%d/%d targets weak" % (nstrong, cnt))
            if uniq < 2:
                why.append("single repeated value")
            tier, note = "X", "; ".join(why)
        arrays[base] = dict(base=base, n=cnt, tier=tier, refs=rs, note=note)

# also record the known 0x012268 array for reference (in the 149, not re-emitted)
known = {0x012268: 2446}

os.makedirs(OUT, exist_ok=True)
nx = 0
with open(os.path.join(OUT, "arrays.tsv"), "w", encoding="utf-8", newline="\n") as ha, \
     open(os.path.join(OUT, "xrefs.tsv"), "w", encoding="utf-8", newline="\n") as hx:
    ha.write("base\tend\tcount\tstride\ttier\tslot_bytes(unk/code/data)\tuniq_targets\t"
             "n_sentinel\tclosed_window_targets\tref_insns\ttargets_first16\tnote\n")
    hx.write("from_table_entry\ttarget\tarray\tindex\ttier\n")
    for b in sorted(arrays):
        info = arrays[b]
        n = info["n"]
        tg = [be(b + 4 * i) for i in range(n)]
        cls = slot_classes(b, n)
        sb = "%d/%d/%d" % (cls.get(0, 0), cls.get(1, 0) + cls.get(2, 0), cls.get(3, 0) + cls.get(4, 0))
        cw = sum(1 for t in tg if CLOSED[0] <= t < CLOSED[1])
        rtxt = ",".join("%06X:%s@%06X" % (r[0], r[1], r[2]) for r in info["refs"][:6]) or "-"
        ha.write("%06X\t%06X\t%d\t4\t%s\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n" % (
            b, b + 4 * n, n, info["tier"], sb, len(set(tg)), tg.count(SENT), cw, rtxt,
            ",".join("%06X" % t for t in tg[:16]), info["note"]))
        if info["tier"] in "ABC":
            for i, t in enumerate(tg):
                if t == SENT or t == 0:
                    continue
                hx.write("%06X\t%06X\t%06X\t%d\t%s\n" % (b + 4 * i, t, b, i, info["tier"]))
                nx += 1
    for b, n in known.items():
        ha.write("%06X\t%06X\t%d\t4\tKNOWN149\t-\t-\t-\t0\t-\t-\t"
                 "already one of the 149 tables; xrefs emitted by G2 table-xrefs.tsv\n" % (b, b + 4 * n, n))

with open(os.path.join(OUT, "refsites.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("insn\tkind\toperand\tdispatch\n")
    for r in sorted(refs):
        if r[1].startswith("ldx"):
            h.write("%06X\t%s\t%06X\t%s\n" % (r[0], r[1], r[2], r[3] or "-"))

c = collections.Counter(v["tier"] for v in arrays.values())
s = collections.Counter()
for v in arrays.values():
    s[v["tier"]] += v["n"]
print("arrays by tier", dict(c), "slots", dict(s), "xref rows", nx)

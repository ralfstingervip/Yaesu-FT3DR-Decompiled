from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N2: whole-image reader scan for every FINAL7-unnamed MAIN run.
# Covers: IDA code-head operand values/addrs (any head), BE32 at any offset, BE24 at any offset,
# BE16 at any offset (only meaningful for targets < 0x8000: abs16 sign-extends), rel8 bcc/bra/bsr,
# rel16 bcc (58 c0 dddd) / bsr (5c 00 dddd) at even addresses, @@aa:8 (5b/5f aa) vector slots.
import sys; sys.path.insert(0, str(_REPO) + r"/ida/out/main-final-unnamed")
from n2_lib import *
load_heads()
RUNS = runs()
assert len(RUNS) == 46 and sum(b - a for a, b in RUNS) == 519
out = open(os.path.join(O, "work", "scan.txt"), "w", encoding="utf-8", newline="\n")
# precompute
b32 = [be32(s) for s in range(E - 3)]
b24 = [be24(s) for s in range(E - 2)]
b16 = [be16(s) for s in range(E - 1)]
opref = []
for ea, (sz, k, fn, dis, ops) in heads.items():
    if k != "code": continue
    for t, v, ad in ops:
        for x in {v, ad}:
            if 0 < x < E: opref.append((x, ea, dis))
opref.sort()
import bisect
okeys = [r[0] for r in opref]
for a, b in RUNS:
    out.write("=== %06X-%06X %d  %s\n" % (a, b - 1, b - a, hx(a, min(b - a, 24))))
    # operand refs into [a-0x400, b)
    lo = bisect.bisect_left(okeys, a - 0x400); hi = bisect.bisect_left(okeys, b)
    rs = opref[lo:hi]
    for x, ea, dis in sorted(rs, key=lambda r: -r[0])[:20]:
        out.write("   %s%s op %06X from %06X  %s\n" % ("IN " if x >= a else "   ", "P" if PM[ea] else ("n" if NM[ea] else "-"), x, ea, dis))
    for s in range(E - 3):
        if a - 0x40 <= b32[s] < b:
            out.write("   BE32 @%06X = %06X P=%d N=%d%s\n" % (s, b32[s], PM[s], NM[s], " IN" if b32[s] >= a else ""))
    for s in range(E - 2):
        if a <= b24[s] < b and not (s > 0 and img[s - 1] == 0):
            out.write("   BE24 @%06X = %06X prev=%02x P=%d N=%d\n" % (s, b24[s], img[s - 1], PM[s], NM[s]))
    if a < 0x8000:
        for s in range(E - 1):
            if a <= b16[s] < b:
                out.write("   BE16 @%06X = %04X prev=%02x P=%d\n" % (s, b16[s], img[s - 1], PM[s]))
    for s in range(0, E - 1, 2):
        op = img[s]
        if (op & 0xF0) == 0x40 or op == 0x55:
            d = img[s + 1]; d = d - 256 if d > 127 else d
            t = s + 2 + d
            if a <= t < b: out.write("   rel8 @%06X %s -> %06X P=%d N=%d\n" % (s, hx(s, 2), t, PM[s], NM[s]))
        if (op == 0x58 and (img[s + 1] & 0x0F) == 0) or (op == 0x5C and img[s + 1] == 0):
            d = be16(s + 2); d = d - 65536 if d > 32767 else d
            t = s + 4 + d
            if a <= t < b: out.write("   rel16 @%06X %s -> %06X P=%d N=%d\n" % (s, hx(s, 4), t, PM[s], NM[s]))
    for s in range(0, 0x400, 4):
        if a <= b32[s] < b: out.write("   VEC slot %d @%06X -> %06X\n" % (s // 4, s, b32[s]))
out.close()
print("ok")

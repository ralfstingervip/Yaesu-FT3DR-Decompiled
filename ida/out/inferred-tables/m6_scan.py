# For each L5 Inferred piece: nearest proven/unproven code refs at or below the piece (within 0x400), BE32 cells.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import sys; sys.path.insert(0, (_REPO_S + "/ida/out/inferred-tables"))
from m6_lib import *
import bisect
refs.sort(key=lambda r: r[1])
keys = [r[1] for r in refs]
out = open(O + r"\work\scan.txt", "w", encoding="utf-8")
for a, b, n, c in pieces:
    out.write("=== %06X-%06X %d %s  %s\n" % (a, b - 1, n, c, hx(a, min(n, 24))))
    lo = bisect.bisect_left(keys, a - 0x400); hi = bisect.bisect_left(keys, b + 0x20)
    rs = refs[lo:hi]
    for ea, da, how, pv in sorted(rs, key=lambda r: -r[1])[:14]:
        out.write("   %s ref %06X from %06X %s  %s\n" % ("P" if pv else "-", da, ea, how, heads[ea][3]))
    # BE32 cells anywhere holding a value in [a-0x100, b)
    cells = [s for s in range(0, HI - 3) if a - 0x100 <= be32(s) < b and img[s] == 0]
    for s in cells[:8]:
        out.write("   BE32 cell @%06X = %06X P=%d N=%d\n" % (s, be32(s), PM[s], NM[s]))
out.close()

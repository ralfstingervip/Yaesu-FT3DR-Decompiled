from pathlib import Path
REPO = Path(__file__).resolve().parents[3].as_posix()  # repository root
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG, bu

def dis(lo, hi):
    x = lo
    while x < hi:
        n, t = bu(x)
        raw = IMG[x:x+max(n,1)].hex()
        print("%06X %-20s %s" % (x, raw, t if n else ".byte 0x%02x" % IMG[x]))
        x += n if n else 1

import sys as _s
lo = int(_s.argv[1], 16); hi = int(_s.argv[2], 16)
dis(lo, hi)

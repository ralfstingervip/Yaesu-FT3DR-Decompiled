# who references [a,b): BE32 at any offset, abs24 jsr/jmp, relative branches from any even offset (oracle), mov immediates
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys
sys.path.insert(0, (_REPO_S + "/ida/out/dead-code-tier/offline"))
from m5_lib import *
def who(a, b, skip_inside=True):
    out = []
    for s in range(0, HI - 3):
        v = be32(s)
        if a <= v < b and not (skip_inside and a <= s < b):
            out.append(("be32", s, v))
    for t in range(a, b):
        for opc in (0x5E, 0x5A):
            pat = bytes([opc, (t >> 16) & 255, (t >> 8) & 255, t & 255])
            k = img.find(pat, 0, HI)
            while k != -1:
                out.append(("abs24-%02X" % opc, k, t)); k = img.find(pat, k + 1, HI)
    for s in range(0, HI, 2):
        if skip_inside and a <= s < b: continue
        for k, t in targets(s):
            if a <= t < b and k == "rel": out.append(("rel", s, t))
    return out
if __name__ == "__main__":
    a = int(sys.argv[1], 16); b = int(sys.argv[2], 16)
    for k, s, t in who(a, b):
        h = heads.get(s)
        print("%-9s src %06X cls %s %s -> %06X | %s %s" % (k, s, cls(s), ("IDAhead:%s" % h[1]) if h else ("in:%06X" % headof[s] if headof[s] is not None else "noitem"),
              t, bu[s][1], bu[s][2]))

# print a region: class, IDA head, bytes, oracle decode (linear from start, or per-head)
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys
sys.path.insert(0, (_REPO_S + "/ida/out/dead-code-tier/offline"))
from m5_lib import *
def ctx(a, b, mode="lin"):
    i = a
    while i < b:
        ln, mn, op = bu[i]
        h = heads.get(i)
        tag = ("H:%s/%d" % (h[1], h[0])) if h else ("in:%06X" % headof[i] if headof[i] is not None else "-")
        print("%06X %s %-14s %-20s %s %s%s" % (i, cls(i), tag, img[i:i + ln].hex(" "), mn, op, (" [piece %06X]" % pid[i]) if pid[i] is not None else ""))
        i += ln if mode == "lin" else 2
if __name__ == "__main__":
    a = int(sys.argv[1], 16); b = int(sys.argv[2], 16)
    ctx(a, b, sys.argv[3] if len(sys.argv) > 3 else "lin")

from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# print IDA heads from the N2 dump in a range, with proven/named flags
import sys; sys.path.insert(0, str(_REPO) + r"/ida/out/main-final-unnamed")
from n2_lib import *
load_heads()
ks = sorted(heads)
import bisect
def dis(a, b):
    i = bisect.bisect_left(ks, a)
    while i < len(ks) and ks[i] < b:
        ea = ks[i]; sz, k, fn, d, ops = heads[ea]
        print("%06X %s%s %-5s %-24s %s" % (ea, "P" if PM[ea] else "-", "N" if NM[ea] else "-", k, hx(ea, min(sz, 10)), d[:70]))
        i += 1
if __name__ == "__main__":
    for arg in sys.argv[1:]:
        a, b = arg.split("-"); dis(int(a, 16), int(b, 16)); print("--")

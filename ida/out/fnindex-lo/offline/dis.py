from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, pickle
sys.dont_write_bytecode = True
sys.path.insert(0, (_REPO_S + "/ida/out/main-descent/offline"))
from common import IMG, bu
SCR = r"local-temp"
P = pickle.load(open(SCR + "reach.pkl", "rb"))
RK, RN = P["rK"]["reached"], P["rN"]["reached"]
P4 = open((_REPO_S + "/ida/out/main-final4/final4_proven_mask.bin"), "rb").read()
N4 = open((_REPO_S + "/ida/out/main-final4/final4_named_mask.bin"), "rb").read()
for arg in sys.argv[1:]:
    s, e = (int(x, 16) for x in arg.split("-"))
    a = s
    while a < e:
        n, t = bu(a)
        if not n: print("%06X %-12s  .word" % (a, IMG[a:a+2].hex())); a += 2; continue
        tag = "N" if a in RN else ("K" if a in RK else ("p" if P4[a] else ("n" if N4[a] else "-")))
        print("%06X %s %-14s %s" % (a, tag, IMG[a:a+n].hex(), t)); a += n
    print("-" * 60)

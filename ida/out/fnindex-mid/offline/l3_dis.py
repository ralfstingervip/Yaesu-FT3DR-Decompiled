# Lane L3: linear oracle disassembly with mask classes. Usage: python l3_dis.py START END [START END ...]
# Read-only. Class letters: B = reached without fnindex seeds, F = fnindex-only run, P = proven but unreached, . = unproven
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, pickle
sys.dont_write_bytecode = True
sys.path.insert(0, (_REPO_S + "/ida/out/main-descent/offline"))
from common import IMG, HI, flow
ROOT = (_REPO_S + "/")
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
N4 = open(ROOT + "ida/out/main-final4/final4_named_mask.bin", "rb").read()
D = pickle.load(open(ROOT + "ida/out/fnindex-mid/work/descents.pkl", "rb"))
M0 = bytearray(HI)
for a, (n, t, k) in D["r0_reached"].items():
    for x in range(a, min(HI, a + n)): M0[x] = 1
FO = bytearray(HI)
for ln in open(ROOT + "ida/out/main-final4/fnindex-only-runs.tsv", encoding="utf-8").read().splitlines()[2:]:
    c = ln.split("\t")
    for x in range(int(c[0], 16), int(c[1], 16)): FO[x] = 1
def c(a):
    return "F" if FO[a] else ("B" if M0[a] else ("P" if P4[a] else ("n" if N4[a] else ".")))
args = [int(x, 16) for x in sys.argv[1:]]
for i in range(0, len(args), 2):
    a, e = args[i], args[i + 1]
    print("---- %06X-%06X" % (a, e))
    while a < e:
        n, t, k, tg = flow(a)
        if not n:
            print("  %06X %s %-12s .word" % (a, c(a), IMG[a:a + 2].hex())); a += 2; continue
        print("  %06X %s %-12s %s" % (a, c(a), IMG[a:a + n].hex(), t))
        a += n

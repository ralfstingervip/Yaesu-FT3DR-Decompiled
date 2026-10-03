# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_HERE = _Path(__file__).resolve().parent
_REPO = _Path(__file__).resolve().parents[4]
# I9: rebuild H9's final byte masks (reached, strict, proven_H9, named_H9) from H9's own offline code and pickles.
# Read-only on every input; writes one pickle to the I9 session scratchpad.
import sys, pickle
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
import analyze as A9          # H9 module; module-level code computes everything, writes nothing unless __main__
from common import HI, CW
SCR = (str(_HERE / "local-temp") + "/")
RM, STRICT, PU, NAMED = A9.RM, A9.STRICT, A9.PU, A9.NAMED
PROV = bytearray(HI); NAMD = bytearray(HI); LEAVE = bytearray(HI)
for s, e, ad, c, h in A9.demoted:
    for x in range(s, e):
        if NAMED[x] and (A9.B[x] if ad == "RC" else True):
            other = (A9.A[x] or A9.E[x] or A9.F[x] or A9.HH[x] or (ad == "D" and A9.B[x]))
            if A9.leaves(s, e, ad, c) and not other: LEAVE[x] = 1
for x in range(HI):
    if (PU[x] and not A9.RCU(x) and not A9.DU(x)) or A9.NEWP(x): PROV[x] = 1
    if (NAMED[x] and not LEAVE[x]) or (RM[x] and not NAMED[x]): NAMD[x] = 1
print("proven_H9", sum(PROV), "expect 365570")
print("named_H9", sum(NAMD), "expect 497139")
pickle.dump(dict(RM=bytes(RM), STRICT=bytes(STRICT), PROV=bytes(PROV), NAMED=bytes(NAMD), PU=bytes(PU), NAMED_H1=bytes(NAMED)),
            open(SCR + "i9_masks.pkl", "wb"))

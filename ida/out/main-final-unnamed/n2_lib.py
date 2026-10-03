import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# Lane N2 shared loader. Read-only: image, FINAL7 masks, N2 heads dump.
import os
R = str(_REPO)
O = os.path.join(R, "ida", "out", "main-final-unnamed")
sys.exit('The firmware image is not in this repository.')
NM = open(os.path.join(R, "ida", "out", "m-wave-recon", "final7_named_mask.bin"), "rb").read()
PM = open(os.path.join(R, "ida", "out", "m-wave-recon", "final7_proven_mask.bin"), "rb").read()
E = 0x7B754
def be16(s): return (img[s] << 8) | img[s + 1]
def be24(s): return (img[s] << 16) | (img[s + 1] << 8) | img[s + 2]
def be32(s): return int.from_bytes(img[s:s + 4], "big")
def hx(a, n): return " ".join("%02x" % x for x in img[a:a + n])
def runs():
    out = []; i = 0
    while i < E:
        if not NM[i]:
            j = i
            while j < E and not NM[j]: j += 1
            out.append((i, j)); i = j
        else: i += 1
    return out
heads = {}
def load_heads():
    if heads: return heads
    with open(os.path.join(O, "work", "n2_heads.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            ea = int(p[0], 16)
            ops = []
            for o in p[5:8]:
                if o:
                    t, v, ad, rg, dt = o.split(":")
                    ops.append((int(t), int(v, 16), int(ad, 16)))
            heads[ea] = (int(p[1]), p[2], p[3], p[4], ops)
    return heads

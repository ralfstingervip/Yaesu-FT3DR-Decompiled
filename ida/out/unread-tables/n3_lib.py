# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
# Lane N3 shared loader. Offline, read-only.
R = str(_REPO)
img = open(R + _no_image(), "rb").read()
NM7 = open(R + "/ida/out/m-wave-recon/final7_named_mask.bin", "rb").read()
PM7 = open(R + "/ida/out/m-wave-recon/final7_proven_mask.bin", "rb").read()
def be16(a): return (img[a] << 8) | img[a+1]
def be32(a): return (img[a] << 24) | (img[a+1] << 16) | (img[a+2] << 8) | img[a+3]
def hx(a, n): return " ".join("%02x" % b for b in img[a:a+n])
PIECES = []
for l in list(open(R + "/ida/out/inferred-tables/pieces.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    if p[5] == "Inferred":
        PIECES.append((int(p[0], 16), int(p[1], 16)))

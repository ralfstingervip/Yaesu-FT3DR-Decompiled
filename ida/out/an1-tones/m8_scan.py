"""M8 raw byte scanner (read-only). usage: python m8_scan.py MAIN|SUB hexpattern [hexpattern...]
Prints every offset of each pattern; for MAIN also the mapped address (= offset)."""
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import sys
ROOT = (_REPO_S + "/decrypted")
IMG = {"MAIN": ROOT + r"\FT3D_MAIN_ver102_EXP.bin", "SUB": ROOT + r"\FT3D_SUB_ver102_ALL.bin"}
BASE = {"MAIN": 0, "SUB": 0xFFC00000}
which = sys.argv[1]
sys.exit("The firmware image is not in this repository.")
for pat in sys.argv[2:]:
    p = bytes.fromhex(pat)
    i = data.find(p)
    hits = []
    while i >= 0:
        hits.append(i)
        i = data.find(p, i + 1)
    print("%s %d hits: %s" % (pat, len(hits), " ".join("%06X" % (h + BASE[which]) for h in hits[:80])))

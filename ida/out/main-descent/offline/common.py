import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# H9 common loaders. Read-only on every input. Imports nothing from other lanes' dirs (no __pycache__ written there).
import os, re, bisect, sys
sys.dont_write_bytecode = True
R = str(_REPO) + r"/ida/out/"
sys.exit('The firmware image is not in this repository.')
IMG = open(IMGP, "rb").read()
HI = 0x7B754                      # end of MAIN content (closed window 0x078106-0x07B753 included in range, never analysed)
CW = (0x078106, 0x07B754)         # closed window
SCR = r"local-temp/"
OUT = R + "main-descent/"

def be32(a): return int.from_bytes(IMG[a:a + 4], "big")

# ---- binutils H8SX oracle (G1, h8s-decode/work/bu_all.tsv): one decode per address
BU = {}
for ln in open(R + "h8s-decode/work/bu_all.tsv", encoding="utf-8"):
    a, n, t = ln.rstrip("\n").split("\t", 2); BU[int(a, 16)] = (int(n), t.replace("\t", " "))
def bu(a):
    n, t = BU.get(a, (0, ".word"))
    return (0, t) if (t.startswith(".word") or "Hmmm" in t or "Don't" in t) else (n, t)

TGT = re.compile(r"\((0x[0-9a-f]+)\)\s*$")
def flow(a):
    """(len, text, kind, direct_targets). kind: normal/cond/stop/stops/call/bad.
    Same rules as G1/H1 rd.flow; indirect forms are resolved separately (edges())."""
    n, t = bu(a)
    if n == 0: return 0, t, "bad", []
    parts = t.split(" ", 1); m = parts[0]; op = parts[1] if len(parts) > 1 else ""
    mm = TGT.search(op)
    if m in ("rts", "rte", "rts/l", "rte/l"): return n, t, "stop", []
    if m == "jmp":
        mo = re.match(r"@(0x[0-9a-f]+):", op)
        return n, t, "stop", [int(mo.group(1), 16)] if mo else []
    if m in ("bra", "bra/s"):
        tg = [int(mm.group(1), 16)] if (mm and op.startswith(".")) else []
        return n, t, ("stops" if m == "bra/s" else "stop"), tg
    if m == "brn": return n, t, "normal", []
    if m in ("jsr", "bsr"):
        mo = re.match(r"@(0x[0-9a-f]+):", op)
        tg = []
        if mo: tg = [int(mo.group(1), 16)]
        elif mm and m == "bsr" and op.startswith("."): tg = [int(mm.group(1), 16)]
        return n, t, "call", tg
    if m.startswith("b") and mm and op.startswith("."):
        return n, t, "cond", [int(mm.group(1), 16)]
    return n, t, "normal", []

# ---- W2-8 typed runs
RUNS = []
for ln in open(R + "wave2/main-raw-types.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split("\t"); RUNS.append((int(c[0], 16), int(c[1], 16), c[3]))
RUNS.sort(); RST = [r[0] for r in RUNS]
def runtype(a):
    i = bisect.bisect_right(RST, a) - 1
    if i >= 0 and RUNS[i][0] <= a < RUNS[i][1]: return RUNS[i][2]
    return None

def printable(b): return 32 <= b < 127

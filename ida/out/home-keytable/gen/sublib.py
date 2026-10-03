# Lane L6. Read-only helpers over the SUB image (RX, LE, base 0xFFC00000).
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import bisect, re
R = (_REPO_S + "/")
sys.exit("The firmware image is not in this repository.")
BASE = 0xFFC00000
F = []
for ln in open(R+"ida/out/sub-final3/functions.tsv",encoding="utf-8").read().splitlines()[1:]:
    p = ln.split("\t"); F.append((int(p[0],16), int(p[1],16), p[4]))
F.sort(); FS = [f[0] for f in F]
def func_of(a):
    i = bisect.bisect_right(FS, a)-1
    if i >= 0 and F[i][0] <= a < F[i][1]: return F[i]
    return None
def cstr(a, maxl=48):
    o = a-BASE; e = o
    while e < len(S) and e-o < maxl and 0x20 <= S[e] < 0x7f: e += 1
    return S[o:e].decode("ascii", "replace")
def imm_refs(addr):
    """RX: MOV.L #imm,Rd = FB (rd<<4|li<<2|2) imm. li=00 imm32, li=11 imm24 (sign-ext). Return code addresses."""
    out = []
    b32 = addr.to_bytes(4, "little"); b24 = (addr & 0xFFFFFF).to_bytes(3, "little")
    for pat, li in ((b32, 0), (b24, 3)):
        i = S.find(pat)
        while i >= 0:
            if i >= 2 and S[i-2] == 0xFB and (S[i-1] & 0x0F) == ((li << 2) | 2):
                out.append(BASE + i - 2)
            i = S.find(pat, i+1)
    return out

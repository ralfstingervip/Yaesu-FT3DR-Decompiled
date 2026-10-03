from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, pickle, re
sys.dont_write_bytecode = True
sys.path.insert(0, (_REPO_S + "/ida/out/main-descent/offline"))
from common import IMG, HI, be32, bu, flow
SCR = r"local-temp"
P = pickle.load(open(SCR + "reach.pkl", "rb")); RN=P["rN"]["reached"]; RK=P["rK"]["reached"]
HEX = re.compile(r"0x([0-9a-f]+)")
DEC = {}
for a in range(0, HI, 2):
    n, t = bu(a)
    if n:
        for m in HEX.finditer(t):
            DEC.setdefault(int(m.group(1), 16), []).append(a)
def refs(v):
    b4 = v.to_bytes(4, "big"); b3 = v.to_bytes(3, "big")
    r32 = []; i = IMG.find(b4)
    while i >= 0: r32.append(i); i = IMG.find(b4, i + 1)
    r24 = []; i = IMG.find(b3)
    while i >= 0:
        if i - 1 not in r32: r24.append(i)
        i = IMG.find(b3, i + 1)
    vec = [a for a in range(0, 0x400, 4) if be32(a) & 0xFFFFFF == v]
    return r32, r24, vec, DEC.get(v, [])
heads = [int(x, 16) for x in sys.argv[1].split(",")]
for h in heads:
    r32, r24, vec, dec = refs(h)
    pv = []
    for a in range(h - 10, h, 2):
        n, t, k, tg = flow(a)
        if n and a + n == h: pv.append("%06X:%s:%s%s" % (a, t, k, "(RN)" if a in RN else ""))
    print("%06X be32=%s be24=%s vec=%s dec=%s | prev: %s" % (h, ["%06X" % x for x in r32], ["%06X" % x for x in r24][:6], vec, ["%06X" % x for x in dec], "; ".join(pv)))

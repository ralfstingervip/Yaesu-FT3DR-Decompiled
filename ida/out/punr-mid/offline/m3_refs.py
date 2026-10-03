# Lane M3: whole-image inbound references to exact addresses. Usage: python m3_refs.py ADDR [ADDR ...]
# Scope: oracle decode at every even address 0x000000-0x07B753 (incl. closed window, decode only): direct branch/bsr/
# jsr/jmp targets, every numeric operand (#imm, @aa:16/24/32, @(d:16/32,ERn)), @@aa:8 slots resolved via the BE32 cell,
# mov.w #hi,eN/#lo,rN pairs; raw BE32 (exact and &0xFFFFFF) and raw BE24 at EVERY byte offset of the 1 MB image;
# BE16 values equal to the low 16 bits at every even offset (reported only with a nearby proven dispatch, see m3_rel16.py).
# Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, re
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/punr-mid/offline"))
from m3_common import IMG, HI, flow, bu, be32, cls
NUM = re.compile(r"(?<![.(])(?:#|@\(|@)?(0x[0-9a-f]+)")
MW = re.compile(r"^mov\.w #(0x[0-9a-f]+),([er])(\d)$")
MI = re.compile(r"^(jmp|jsr) @@(\d+) \((0x[0-9a-f]+)\)$")
_DEC = None
def decode_all():
    global _DEC
    if _DEC is None:
        _DEC = {}
        for a in range(0, HI, 2):
            n, t, k, tg = flow(a)
            if n: _DEC[a] = (n, t, k, tg)
    return _DEC
def scan(targets):
    T = set(targets); out = {t: [] for t in targets}
    D = decode_all()
    for a, (n, t, k, tg) in D.items():
        for v in tg:
            if v in T: out[v].append(("flow", a, IMG[a:a + n].hex(), t, cls(a)))
        for m in NUM.finditer(t):
            v = int(m.group(1), 16)
            if v in T and v not in tg: out[v].append(("opnd", a, IMG[a:a + n].hex(), t, cls(a)))
        m = MI.match(t)
        if m:
            v = be32(int(m.group(3), 16)) & 0xFFFFFF
            if v in T: out[v].append(("@@", a, IMG[a:a + n].hex(), t, cls(a)))
        m = MW.match(t)
        if m:
            x = a + n
            for _ in range(4):
                if x not in D: break
                n2, t2 = D[x][0], D[x][1]
                m2 = MW.match(t2)
                if m2 and m2.group(3) == m.group(3) and m2.group(2) != m.group(2):
                    hi_, lo_ = (m, m2) if m.group(2) == "e" else (m2, m)
                    v = (int(hi_.group(1), 16) << 16) | int(lo_.group(1), 16)
                    if v in T: out[v].append(("w16pair", a, "", t + ";" + t2, cls(a)))
                    break
                x += n2
    for o in range(0, len(IMG) - 3):
        v = int.from_bytes(IMG[o:o + 4], "big")
        if v in T: out[v].append(("be32", o, IMG[o:o + 4].hex(), "", cls(o)))
        elif (v & 0xFFFFFF) in T: out[v & 0xFFFFFF].append(("be32m", o, IMG[o:o + 4].hex(), "", cls(o)))
        v3 = int.from_bytes(IMG[o + 1:o + 4], "big")
        if v3 in T and IMG[o] != 0:
            kind = "j24" if IMG[o] in (0x5A, 0x5E) else "be24"
            out[v3].append((kind, o, IMG[o:o + 4].hex(), "", cls(o)))
    return out
def preceding(s):
    res = []
    D = decode_all()
    for a in range(max(0, s - 10), s, 2):
        if a in D and a + D[a][0] == s: res.append((a, IMG[a:s].hex(), D[a][1], D[a][2], cls(a)))
    return res
if __name__ == "__main__":
    tg = [int(x, 16) for x in sys.argv[1:]]
    out = scan(tg)
    for t in tg:
        print("== %06X [%s]" % (t, cls(t)))
        for p in preceding(t): print("   pre   %06X %-14s %-34s %s %s" % p)
        for r in out[t]: print("   %-6s %06X %-14s %-34s %s" % r)

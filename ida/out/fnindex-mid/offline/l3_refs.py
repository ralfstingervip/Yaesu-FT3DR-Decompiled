# Lane L3: whole-image inbound references to address ranges. Usage: python l3_refs.py START END [START END ...]
# Scope: oracle decode of every even address 0x000000-0x07B753 (incl. closed window, decode only) for direct
# branch/call/jump targets and #imm operands; raw BE32 and 5A/5E+BE24 at every byte offset of the 1 MB image;
# mov.w #hi,eN / mov.w #lo,rN pairs; @@aa:8 slots. Read-only.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, re, pickle
sys.dont_write_bytecode = True
sys.path.insert(0, (_REPO_S + "/ida/out/main-descent/offline"))
from common import IMG, HI, flow, bu, be32
ROOT = (_REPO_S + "/")
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
N4 = open(ROOT + "ida/out/main-final4/final4_named_mask.bin", "rb").read()
D = pickle.load(open(ROOT + "ida/out/fnindex-mid/work/descents.pkl", "rb"))
M0 = bytearray(HI)
for a, (n, t, k) in D["r0_reached"].items():
    for x in range(a, min(HI, a + n)): M0[x] = 1
FO = {}
for ln in open(ROOT + "ida/out/main-final4/fnindex-only-runs.tsv", encoding="utf-8").read().splitlines()[2:]:
    c = ln.split("\t")
    for x in range(int(c[0], 16), int(c[1], 16)): FO[x] = c[0]
def cls(a):
    if 0x078106 <= a < 0x07B754: return "window"
    if a >= HI: return "beyond"
    return ("fnonly:" + FO[a]) if a in FO else ("base" if M0[a] else ("proven-unreached" if P4[a] else ("named-unproven" if N4[a] else "unnamed")))
IMM = re.compile(r"(?<![.(])(?:#|@\(|@)?(0x[0-9a-f]+)")  # any operand number: #imm, @aa, @(d,ERn); branch-target echo "(0x..)" excluded
MW = re.compile(r"^mov\.w #(0x[0-9a-f]+),([er])(\d)$")
MI = re.compile(r"^(jmp|jsr) @@(\d+) \((0x[0-9a-f]+)\)$")
def scan(ranges, quiet_internal=True):
    out = {r: [] for r in ranges}
    def hit(v):
        return [r for r in ranges if r[0] <= v < r[1]]
    for a in range(0, HI, 2):
        n, t, k, tg = flow(a)
        if not n: continue
        for v in tg:
            for r in hit(v):
                if quiet_internal and r[0] <= a < r[1]: continue
                out[r].append(("flow", a, t, v, cls(a)))
        for m in IMM.finditer(t):
            v = int(m.group(1), 16)
            for r in hit(v):
                if v in tg: continue
                out[r].append(("opnd", a, t, v, cls(a)))
        m = MI.match(t)
        if m:
            v = be32(int(m.group(3), 16)) & 0xFFFFFF
            for r in hit(v): out[r].append(("@@", a, t, v, cls(a)))
        m = MW.match(t)
        if m:
            x = a + n
            for _ in range(4):
                n2, t2 = bu(x)
                if not n2: break
                m2 = MW.match(t2)
                if m2 and m2.group(3) == m.group(3) and m2.group(2) != m.group(2):
                    hi_, lo_ = (m, m2) if m.group(2) == "e" else (m2, m)
                    v = (int(hi_.group(1), 16) << 16) | int(lo_.group(1), 16)
                    for r in hit(v): out[r].append(("w16pair", a, t + ";" + t2, v, cls(a)))
                    break
                x += n2
    for o in range(0, len(IMG) - 3):
        v = int.from_bytes(IMG[o:o + 4], "big")
        for r in hit(v): out[r].append(("be32", o, IMG[o:o + 4].hex(), v, cls(o)))
        if IMG[o] in (0x5A, 0x5E):
            v = int.from_bytes(IMG[o + 1:o + 4], "big")
            for r in hit(v):
                if o % 2 == 0 and flow(o)[0] == 4 and flow(o)[1].startswith(("jsr @0x", "jmp @0x")): continue  # already a flow row
                out[r].append(("raw24", o, IMG[o:o + 4].hex(), v, cls(o)))
    return out
def preceding(s):
    res = []
    for a in range(max(0, s - 10), s, 2):
        n, t, k, tg = flow(a)
        if n and a + n == s: res.append((a, IMG[a:a + n].hex(), t, k, cls(a)))
    return res
if __name__ == "__main__":
    args = [int(x, 16) for x in sys.argv[1:]]
    rr = [(args[i], args[i + 1]) for i in range(0, len(args), 2)]
    out = scan(rr)
    for r in rr:
        print("== %06X-%06X  [%s]" % (r[0], r[1], cls(r[0])))
        for p in preceding(r[0]): print("   pre   %06X %-12s %-36s %s %s" % p)
        for k, a, t, v, c in out[r]: print("   %-6s %06X %-40s ->%06X %s" % (k, a, t, v, c))

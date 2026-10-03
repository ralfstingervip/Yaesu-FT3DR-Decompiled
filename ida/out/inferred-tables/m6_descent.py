# M6: K1 folded descent (copied from l-wave-recon/recon_descent.py setup, no writes there) + sub_15260 record seeds.
# L2: reproduce K1's folded descent with and without H9 fnindex seeds; read-only on every input.
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import sys, re, pickle
sys.dont_write_bytecode = True
H9 = (_REPO_S + "/ida/out/main-descent/offline")
sys.path.insert(0, H9)
import descent as D9
from common import IMG, HI, CW, be32, flow, bu
ROOT = (_REPO_S + "/")
SCR = None
INW = lambda x: CW[0] <= x < CW[1]
def be16(a): return int.from_bytes(IMG[a:a + 2], "big")

# J1 folded seeds verbatim from k1_build_masks.py
EX6 = [(a, "I6 exit-table 0x19A9E entry") for a in sorted(set(0x148A0 + be16(0x19A9E + 2 * i) for i in range(206)))]
I8X = [(0x034CCE, "I8"), (0x00327E, "I8"), (0x00328A, "I8"), (0x00329C, "I8"), (0x077DB8, "I8"), (0x077FC6, "I8"), (0x078086, "I8")]
I9X = []
for rec in (0x0296E8, 0x029712):
    for off in (0x00, 0x04, 0x08, 0x0C, 0x14, 0x18):
        v = be32(rec + off)
        if v and v < HI and v % 2 == 0: I9X.append((v, "I9 record %06X+%02X" % (rec, off)))
I9X += [(0x000706, "I9 ram-cell FF811A"), (0x01A084, "I9 er1 callback")]
I15X = []
for ln in open(ROOT + "ida/out/descent-ext/new-edges.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("rule"): continue
    c = ln.split("\t")
    if c[2] != "True": continue
    v = int(c[1], 16)
    if v and v < HI and v % 2 == 0: I15X.append((v, "I15 " + c[4]))
COMBINED = EX6 + I8X + I9X + I15X

EXCL2 = set()
for ln in open(ROOT + "ida/out/h8sx-seed/table-xrefs-excluded.tsv", encoding="utf-8").read().splitlines()[1:]:
    if ln.startswith("#") or not ln.strip(): continue
    c = ln.split("\t")
    if not c[5].startswith("target is mid_code in seed"): EXCL2.add(int(c[0], 16))
TAB_NEW = {}
for fn in ["jumptables.tsv", "switch_tables.tsv"]:
    for ln in open(ROOT + "ida/out/main-full/" + fn, encoding="utf-8").read().splitlines()[1:]:
        c = ln.split("\t"); b = int(c[0], 16); n = int(c[1])
        d = TAB_NEW.setdefault(b, {})
        for i in range(n):
            s = b + 4 * i; v = be32(s)
            if s in EXCL2: continue
            if v < HI and v % 2 == 0 and v != 0x3FFA0 and v != 0: d[s] = v
for _b in D9.H9_EXCL_TABLES: TAB_NEW[_b] = {}

HELPER_SIG_A = bytes.fromhex("6b04bbc27924"); HELPER_SIG_B = bytes.fromhex("44141b544b10790c000010740ac6010069665d604004")
HELPERS = {}
for a in range(0x400, HI, 2):
    if IMG[a:a + 6] == HELPER_SIG_A and IMG[a + 8:a + 30] == HELPER_SIG_B and IMG[a + 30:a + 36] == bytes.fromhex("5e03ffa05470"):
        HELPERS[a] = be16(a + 6)
JMPABS = re.compile(r"^(jmp|jsr) @(0x[0-9a-f]+):24$")
def k1b_edges(reached):
    new = {}
    for a, (n, t, k) in reached.items():
        m1 = D9.MOVI.match(t); m2 = D9.LD.match(t)
        if m1 and m1.group(2) == "6": form = "imm"; T = int(m1.group(1), 16)
        elif m2 and m2.group(4) == "6" and m2.group(3) == "4" and m2.group(2) == "32": form = "L1"; T = int(m2.group(1), 16)
        else: continue
        for x, tt in D9.window(reached, a, 4):
            mj = JMPABS.match(tt)
            if mj and int(mj.group(2), 16) in HELPERS:
                h = int(mj.group(2), 16); N = HELPERS[h]
                if h not in reached: break
                tabs = [T] if form == "imm" else []
                if form == "L1":
                    lo = 1 << 30; i = 0
                    while T + 4 * i < lo:
                        v = be32(T + 4 * i)
                        if not (0x400 <= v < HI and v % 2 == 0): break
                        tabs.append(v); lo = min(lo, v); i += 1
                    tabs = sorted(set(tabs))
                for tb in tabs:
                    for j in range(N - 1):
                        v = be32(tb + 4 * j)
                        if 0x400 <= v < HI and v % 2 == 0 and not INW(v):
                            new.setdefault(v, "K1b helper %06X table %06X slot %d via %06X" % (h, tb, j, a))
                break
            if D9.writes(tt, "6"): break
    return new
def run_folded(extra):
    D9.TAB.clear(); D9.TAB.update({b: dict(d) for b, d in TAB_NEW.items()})
    seeds = dict(extra)
    while True:
        r = D9.run("full", extra_seeds=sorted(seeds.items()))
        new = {a: l for a, l in k1b_edges(r["reached"]).items() if a not in seeds and a not in r["seed"]}
        if not new: return r
        seeds.update(new)
def bm(reached):
    m = bytearray(HI)
    for a, (n, t, k) in reached.items():
        for x in range(a, min(HI, a + n)):
            if not INW(x): m[x] = 1
    return m

# ---- M6 additions (read-only; writes only into ida\out\inferred-tables) ----
OUTD = ROOT + "ida/out/inferred-tables/"
P6 = open(ROOT + "ida/out/l-wave-recon/final6_proven_mask.bin", "rb").read()[:HI]
N6 = open(ROOT + "ida/out/l-wave-recon/final6_named_mask.bin", "rb").read()[:HI]
NEW = [(0x018250,"L2"),(0x018ABE,"L2"),(0x01A094,"L2"),(0x05E8E0,"L4"),(0x066FB4,"L4"),(0x067250,"L4")]
D9.FNSEED.clear()
def recfields(rec):
    # cells from rec while each cell is NULL or an even in-image pointer and the cell lies below the lowest target
    out=[]; lo=HI; i=0
    while rec+4*i+4 <= lo:
        v=be32(rec+4*i)
        if v==0: i+=1; continue
        if not (0x400<=v<HI and v%2==0): break
        out.append((v,"sub_15260 record %06X+%X"%(rec,4*i))); lo=min(lo,v) if v>rec else lo; i+=1
    print("record %06X fields %d: %s"%(rec,i," ".join("%06X"%v for v,_ in out)))
    return out
CORE = recfields(0x01686E)
COMP = []
for rec in (0x016AAE,0x01792E,0x017AA6,0x018622,0x05E806):
    COMP += recfields(rec)
rB = run_folded(COMBINED + NEW); MB = bm(rB["reached"])
rC = run_folded(COMBINED + NEW + CORE); MC = bm(rC["reached"])
rA = run_folded(COMBINED + NEW + CORE + COMP); MA = bm(rA["reached"])
print("base descent bytes", sum(MB), "core", sum(MC), "core+comp", sum(MA))
def runs(xs):
    out=[];xs=sorted(xs)
    for x in xs:
        if out and out[-1][1]==x: out[-1][1]=x+1
        else: out.append([x,x+1])
    return out
coreNew=[x for x in range(HI) if MC[x] and not MB[x] and not P6[x]]
compNew=[x for x in range(HI) if MA[x] and not MC[x] and not P6[x]]
print("core new vs P6", len(coreNew), "comp new vs P6", len(compNew))
print("core new not named", sum(1 for x in coreNew if not N6[x]), "comp new not named", sum(1 for x in compNew if not N6[x]))
with open(OUTD+"work/descent_delta.tsv","w",encoding="utf-8",newline="\n") as f:
    f.write("set\tstart\tend_excl\tlen\tnamed_in_final6\n")
    for tag,xs in (("core",coreNew),("companion",compNew)):
        for s,e in runs(xs): f.write("%s\t%06X\t%06X\t%d\t%d\n"%(tag,s,e,e-s,sum(N6[s:e])))
open(OUTD+"work/m6_core_mask.bin","wb").write(bytes(MC))

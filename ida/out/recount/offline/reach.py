# H1: corrected proven-seed descent over the binutils H8SX oracle (G1 work\bu_all.tsv). Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys; sys.path.insert(0,(REPO + "/ida/out/h8s-decode/offline"))
from rd import *
import re,pickle
R=(REPO + "/ida/out/")
MF=R+"main-full/"
BAD_F1={0x034644,0x038104,0x04F3A4,0x06AC14,0x04DE6E,0x04DF72}
TRUE_F1={0x04DE94:0x04DEE2,0x04DF98:0x04E010}
JUNK_FN={0x00C448}
def seeds_corrected():
    s={}
    for f in ["main-low","main-high-a","main-high-b"]:
        L=open(R+"fnindex/%s.tsv"%f,encoding="utf-8").read().splitlines(); h=L[0].split("\t")
        for ln in L[1:]:
            c=dict(zip(h,ln.split("\t")))
            a=int(c["start"],16)
            if c["validated"]=="yes" and a not in JUNK_FN: s[a]=(int(c["end"],16),"fnindex")
    for ln in open(R+"main-indirect/proved.tsv",encoding="utf-8").read().splitlines()[1:]:
        c=ln.split("\t"); a=int(c[0],16)
        if a not in BAD_F1: s[a]=(int(c[1],16),"proved")
    for a,e in TRUE_F1.items(): s[a]=(e,"proved-corr")
    return s
TAB={}
for fn in ["jumptables.tsv","switch_tables.tsv"]:
    for ln in open(MF+fn,encoding="utf-8").read().splitlines()[1:]:
        c=ln.split("\t"); TAB.setdefault(int(c[0],16),set()).update(int(t,16) for t in c[3].split(",") if t)
# full table contents from the image (TSV stores only a prefix): F1 method, BE32 at base+4i for the stated entry count
def full_tab(base,n):
    out=set()
    for i in range(n):
        v=int.from_bytes(IMG[base+4*i:base+4*i+4],"big")
        if v<HI and v%2==0 and v!=0x3FFA0: out.add(v)
    return out
for fn in ["jumptables.tsv","switch_tables.tsv"]:
    for ln in open(MF+fn,encoding="utf-8").read().splitlines()[1:]:
        c=ln.split("\t"); TAB[int(c[0],16)].update(full_tab(int(c[0],16),int(c[1])))
vec=set()
for ln in open(MF+"vectors.tsv",encoding="utf-8").read().splitlines()[1:]:
    c=ln.split("\t"); v=int(c[2],16)
    if v<HI: vec.add(v)
SWCASES={0x07630A+int.from_bytes(IMG[0x078546+2*i:0x078548+2*i],"big") for i in range(45)}
LD=re.compile(r"mov\.l @\((0x[0-9a-f]+):32,er(\d)\),er(\d)")
def run():
    S=seeds_corrected()
    seed=set(S)|vec
    for t in TAB.values(): seed|={x for x in t if x%2==0}
    while True:
        r,bad,_=descend(list(seed))
        new=set()
        if 0x076308 in r: new|=SWCASES-seed
        for a,(n,t,k) in r.items():
            m=LD.match(t)
            if not m: continue
            base=int(m.group(1),16)
            if base in TAB: new|={x for x in TAB[base] if x not in seed}
        if not new: break
        seed|=new
    return S,seed,r,bad
if __name__=="__main__":
    S,seed,r,bad=run()
    pickle.dump((S,seed,r,bad),open("local-temp","wb"))
    print("seeds",len(seed),"reached insns",len(r),"bytes",sum(v[0] for v in r.values()))
    for a in (0x034642,0x034636,0x03460A,0x038102,0x0380EA,0x04F3A2,0x04F390,0x06AC12,0x06AC0C,0x04DE94,0x04DF98,0x00C448):
        print("%06X reached=%s"%(a,a in r))

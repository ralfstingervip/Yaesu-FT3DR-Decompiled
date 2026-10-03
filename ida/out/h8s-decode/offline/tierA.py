from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
from rd import *
import bisect,pickle,re
ids,items,funcs=load()
MF=(_REPO_S + "/ida/out/main-full/")
code={ea:v for ea,v in items.items() if v[1]=="code"}
S=seeds_proven()
iv=sorted((s,e) for s,(e,_) in S.items()); st=[s for s,e in iv]
def inproven(a):
    i=bisect.bisect_right(st,a)-1
    return i>=0 and iv[i][0]<=a<iv[i][1]
TAB={}
for fn in ["jumptables.tsv","switch_tables.tsv"]:
    for ln in open(MF+fn,encoding="utf-8").read().splitlines()[1:]:
        c=ln.split("\t"); TAB.setdefault(int(c[0],16),set()).update(int(t,16) for t in c[3].split(",") if t)
vec=set()
for ln in open(MF+"vectors.tsv",encoding="utf-8").read().splitlines()[1:]:
    c=ln.split("\t"); vec.add(int(c[2],16))
seed=set(S)|{a for a in code if inproven(a) and a%2==0}|{v for v in vec if v<HI}
# Verified H8SX register-relative switch (doc 36 Findings 1): bra r0.w at 0x076308,
# 45 byte offsets at 0x078546 (bound: cmp.b #0x2c,r0h / bhi at 0x0762EA), target = 0x07630A + offset.
SWITCHES=[(0x076308,0x07630A,0x078546,45)]
SWCASES=set()
for site,pc,tab,cnt in SWITCHES:
    for i in range(cnt):
        SWCASES.add(pc+int.from_bytes(IMG[tab+2*i:tab+2*i+2],"big"))
LD=re.compile(r"mov\.l @\((0x[0-9a-f]+):32,er(\d)\),er(\d)")
used_tables={}
while True:
    r,bad,_=descend(list(seed))
    new=set()
    for a,(n,t,k) in r.items():
        if a in [sw[0] for sw in SWITCHES]:
            for x in SWCASES:
                if x not in seed: new.add(x)
        m=LD.match(t)
        if not m: continue
        base=int(m.group(1),16); rd=m.group(3)
        # next 1..2 insns: jmp/jsr @er<rd>
        b=a+n; disp=None
        for _ in range(2):
            if b not in r: break
            t2=r[b][1]
            if t2 in ("jmp @er%s"%rd,"jsr @er%s"%rd): disp=t2; break
            b+=r[b][0]
        if disp and base in TAB:
            used_tables[base]=(a,disp)
            for x in TAB[base]:
                if x%2==0 and x<HI and x not in seed: new.add(x)
    if not new: break
    seed|=new
pickle.dump((r,seed,used_tables),open("tierA.pkl","wb"))
s=[a for a in r if ids[a]==0]
print("tierA reached",len(r),"sites",len(s),"dispatch tables used",len(used_tables))

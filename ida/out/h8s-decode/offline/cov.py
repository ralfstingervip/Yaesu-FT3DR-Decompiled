from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys; sys.path.insert(0,".")
from ctx import *
from rd import seeds_proven
import json,pickle
OUT=(_REPO_S + "/ida/out/h8s-decode/")
ids,ib,fb=load("before"); _,ia,fa=load("after")
plan=json.load(open(OUT+"work/absorb_plan.json",encoding="utf-8"))
P={a:(n,t,o) for a,n,t,o in plan["insns"]}
def mask(items,even_only=False):
    m=bytearray(HI)
    for ea,(sz,k,st,fn,mn) in items.items():
        if k=="code" and (not even_only or ea%2==0):
            for x in range(ea,min(HI,ea+sz)): m[x]=1
    return m
mb=mask(ib); ma=mask(ia)
gained=[x for x in range(HI) if ma[x] and not mb[x]]
lost=[x for x in range(HI) if mb[x] and not ma[x]]
pm=bytearray(HI); tier=bytearray(HI)  # 1=A 2=B
for a,(n,t,o) in P.items():
    for x in range(a,a+n): pm[x]=1; tier[x]=1 if t=="A" else 2
# outside-plan attribution (doc 36): switch cases of 0x076308 and call targets of tier-A planned code
ATTR_A=[(0x07630A,0x0767B6),(0x02F2E0,0x02F35E),(0x02F36C,0x02F386),(0x030E00,0x030E62),(0x030E6A,0x030E96),(0x038074,0x03808C),(0x0380A2,0x0380E8),(0x0380EA,0x038102),(0x05AF70,0x05AF7C),(0x077A1C,0x077A2C)]
UNATTR=[(0x01A432,0x01A436),(0x0703C4,0x0703E6)]
for s,e in ATTR_A:
    for x in range(s,e):
        if ma[x] and not mb[x]: tier[x]=1
g_plan=[x for x in gained if pm[x]]
g_attr=[x for x in gained if not pm[x] and tier[x]==1]
g_un=[x for x in gained if not pm[x] and tier[x]==0]
new=[x for x in gained if tier[x]]
newA=[x for x in new if tier[x]==1]; newB=[x for x in new if tier[x]==2]
# already-code bytes inside planned instructions (wrongly decoded before)
pre=[x for x in range(HI) if pm[x] and mb[x]]
L=[]
w=L.append
w("G1 H8SX decode -- coverage arithmetic (MAIN content 0x000000-0x07B753 = 505,684 B)")
w("Database: ida\db\jobs\G1_H8S (copy of MAIN_FULL, processor switched h8s300a -> h8sxa, plan absorbed).")
w("Byte sets are recomputed from items_before.tsv / items_after.tsv (ida\out\h8s-decode\work).")
w("")
w("1. IDA instruction bytes (is_code) in G1_H8S")
w("   before (MAIN_FULL state)            %7d" % sum(mb))
w("   after                               %7d" % sum(ma))
w("   gained                              %7d" % len(gained))
w("     in the plan (sites + downstream)  %7d" % len(g_plan))
sw=sum(1 for x in g_attr if 0x07630A<=x<0x0767B6)
w("     IDA flow from tier-A plan code    %7d   (case heads of the 45-case switch at 0x076308: %d; jsr/bsr targets: %d)" % (len(g_attr), sw, len(g_attr)-sw))
w("     not caused by the decode          %7d   (0x01A432 4 B lane-1 sub_1A432; 0x0703C4 34 B data-offset side effect) -- NOT credited" % len(g_un))
w("   lost (junk the decode displaced)    %7d   (odd-aligned heads and IDA code over tables now typed by the MOV.L data refs)" % len(lost))
w("   credited new instruction bytes      %7d   = %d plan + %d flow" % (len(new), len(g_plan), len(g_attr)))
w("     tier A (proven flow)              %7d" % len(newA))
w("     tier B (structural)               %7d" % len(newB))
w("     inside closed window 0x078106+    %7d" % sum(1 for x in new if x>=0x078106))
w("   planned bytes that were already is_code (old mis-decodes, e.g. 6-byte tail of a 78 MOV.L) %d -- not new" % len(pre))
w("")
# published companion
w("2. Decodable-instruction companion (RESUME-FULL 380,782; this DB's baseline is 380,738, a 44 B difference in the source DB)")
w("   380,782 + %d new - %d lost = %d" % (len(new), len(lost), 380782+len(new)-len(lost)))
w("")
S=seeds_proven()
prov=bytearray(HI); fni=bytearray(HI)
for s,(e,src) in S.items():
    for x in range(s,min(e,HI)):
        if src=="proved": prov[x]=1
        else: fni[x]=1
newA_in_prov=[x for x in newA if prov[x]]
newA_in_fni=[x for x in newA if fni[x]]
w("3. MAIN proven code (RESUME-FULL 369,071 / 380,782)")
w("   tier-A new bytes                    %7d" % len(newA))
w("     of which inside main-indirect\proved.tsv extents (F1 credited extents, so already in 369,071) %d" % len(newA_in_prov))
w("     of which inside fnindex validated extents (credited only as is_code, so not yet counted)   %d" % len(newA_in_fni))
dA=len(newA)-len(newA_in_prov)
w("   delta to the proven numerator       %7d" % dA)
w("   369,071 + %d = %d  of  %d decodable  = %.2f%%   (%.2f%% of 505,684 content)" % (dA, 369071+dA, 380782+len(new)-len(lost), 100*(369071+dA)/(380782+len(new)-len(lost)), 100*(369071+dA)/505684))
w("   tier-B bytes (%d) are code by structure but not reached from a proven entry; they stay out of the proven numerator." % len(newB))
w("")
# headline credited mask
cred=bytearray(HI)
for s,(e,src) in S.items():
    for x in range(s,min(e,HI)):
        if src=="proved" or mb[x]: cred[x]=1
for s,e,t in runs:
    if t!="other":
        for x in range(s,e): cred[x]=1
SP=(_REPO_S + "/ida/out/main-raw-other/split.tsv")
f2=0
for ln in open(SP,encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("run_start"): continue
    c=ln.split("\t")
    if c[3]=="other" and c[4] in ("code",) or c[4].startswith("parameter table") and c[3]=="other":
        for x in range(int(c[0],16),int(c[1],16)): cred[x]=1; f2+=1
newnc=[x for x in new if not cred[x]]
bytype=collections.Counter()
for x in new:
    if cred[x]:
        t=runtype(x) or ("fn-extent" if (prov[x] or fni[x]) else "?")
        bytype[t]+=1
w("4. Headline numerator 930,393 (validated fn is_code + proved extents + typed runs + F2 983)")
w("   F2 newly-typed bytes re-read from split.tsv: %d (expected 983)" % f2)
w("   new bytes already credited (as another type or as an extent) %d: %s" % (len(new)-len(newnc), dict(bytype)))
w("   new bytes NOT previously credited    %7d" % len(newnc))
nt=collections.Counter(runtype(x) or ("fn-extent" if (prov[x] or fni[x]) else "in-function-not-validated") for x in newnc)
w("     by where they sit: %s" % dict(nt))
ntier=collections.Counter("A" if tier[x]==1 else "B" for x in newnc)
w("     by tier: %s" % dict(ntier))
w("   930,393 + %d = %d / 1,029,972 = %.2f%%" % (len(newnc), 930393+len(newnc), 100*(930393+len(newnc))/1029972))
w("")
# split.tsv fragments cross-check
frag=collections.Counter(); fragb=collections.Counter()
for ln in open(SP,encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("run_start"): continue
    c=ln.split("\t"); s,e=int(c[0],16),int(c[1],16)
    k=c[4]
    n=sum(1 for x in range(s,e) if x in set(new) )
    fragb[k]+=n; frag[k]+=e-s
w("5. Cross-check against main-raw-other\split.tsv (F2) -- new code bytes per F2 class")
newset=set(new)
for k in sorted(frag):
    n=0
    for ln in open(SP,encoding="utf-8").read().splitlines():
        if ln.startswith("#") or ln.startswith("run_start"): continue
        c=ln.split("\t")
        if c[4]==k: n+=sum(1 for x in range(int(c[0],16),int(c[1],16)) if x in newset)
    w("   %-42s F2 bytes %5d   now new code %5d" % (k, frag[k], n))
w("")
cover=bytearray(HI)
for a,(n,t,o) in P.items():
    for x in range(a,a+n): cover[x]=1 if t=="A" else 2
for s,e in ATTR_A:
    for x in range(s,e):
        if ma[x]: cover[x]=1
w("   (bytes of F2 fragments now covered by a decoded H8SX-era instruction span incl. re-decoded tails:)")
for ln in open(SP,encoding="utf-8").read().splitlines():
    pass
agg=collections.Counter()
for ln in open(SP,encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("run_start"): continue
    c=ln.split("	"); agg[c[4]]+=sum(1 for x in range(int(c[0],16),int(c[1],16)) if cover[x])
w("   "+", ".join("%s %d"%(k,v) for k,v in sorted(agg.items()) if v))
w("")
w("6. Cross-check against main-indirect\proved.tsv (F1)")
w("   tier-A new bytes inside proved extents: %d (already in F1's 19,848)" % len(newA_in_prov))
w("   F1 rows whose start is mid-instruction (+2 into a 78 MOV.L): 034644, 038104, 04F3A4, 06AC14 (true instruction starts 2 B earlier)")
w("   F1 rows that start on ASCII text: 04DE6E (0x04DE6E-0x04DE93, 38 B) and 04DF72 (0x04DF72-0x04DF97, 38 B); true entries 0x04DE94 / 0x04DF98")
w("   -> 76 B of F1's 19,848 are text, not code (correction, not applied above)")
open(OUT+"coverage.txt","w",encoding="utf-8",newline="\n").write("\n".join(L)+"\n")
print("\n".join(L))

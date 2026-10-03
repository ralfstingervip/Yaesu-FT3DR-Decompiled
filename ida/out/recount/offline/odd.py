# H1: classify the odd-aligned IDA code heads in MAIN_FULL (items_before) and G1_H8S (items_after). Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys,pickle,bisect,collections
sys.path.insert(0,(REPO + "/ida/out/h8s-decode/offline"))
from ctx import *
from rd import descend, flow
from reach import seeds_corrected
OUT=(REPO + "/ida/out/recount/")
S,seed,r,bad=pickle.load(open("local-temp","rb"))
_,ib,fb=load("before"); _,ia,fa=load("after")
# proven-reach byte mask
PR=bytearray(HI)
for a,(n,t,k) in r.items():
    for x in range(a,min(HI,a+n)): PR[x]=1
# any-even descent (from every even IDA code head, after state) -> structural code
evseeds=[a for a,v in ia.items() if v[1]=="code" and a%2==0]
rE,_,_=descend(evseeds)
EV=bytearray(HI)
for a,(n,t,k) in rE.items():
    for x in range(a,min(HI,a+n)): EV[x]=1
# region tags
def ivs(rows): rows=sorted(rows); return rows,[s for s,e,*_ in rows]
FN=[];PRV=[]
for s,(e,src) in S.items(): (PRV if src.startswith("proved") else FN).append((s,e))
FN,FNs=ivs(FN); PRV,PRVs=ivs(PRV)
MFf=[(s,e) for s,e,n,c in fb]; MFf,MFs=ivs(MFf)
def inside(rows,st,a):
    i=bisect.bisect_right(st,a)-1
    return i>=0 and rows[i][0]<=a<rows[i][1]
def region(a):
    if 0x078106<=a<HI: return "closed-window"
    if inside(FN,FNs,a): return "fnindex-validated-extent"
    if inside(PRV,PRVs,a): return "F1-proved-extent"
    if inside(MFf,MFs,a): return "MAIN_FULL-fn-not-validated"
    t=runtype(a)
    return "run:"+t if t else "unlisted"
def content(a,n):
    b=IMG[a:a+n]
    if all(c==0xFF for c in b): return "fill"
    if all(32<=c<127 or c==0 for c in b) and any(32<=c<127 for c in b): return "ascii"
    return "binary"
def runof(a):
    i=bisect.bisect_right(rst,a)-1
    return runs[i] if i>=0 and runs[i][0]<=a<runs[i][1] else None
def lin_cover(a):
    """even linear oracle decode from the start of the W2-8 run holding a (or from a-1-32 back to a terminator);
    returns bytes covered over [a,a+n) if the chain is clean through a and ends in a terminator / existing code"""
    ru=runof(a)
    st=(ru[0]+1)&~1 if ru else max(0,(a-1)-32)
    x=st; chain=[]
    while x< (ru[1] if ru else a+64):
        n,t,k,tg=flow(x)
        if n==0: return None
        chain.append((x,n,k))
        if k in("stop","stops") and x+n>a: return chain
        if k in("stop","stops") and x+n<=a: chain=[]; x+=n; continue
        x+=n
    return chain if chain and chain[-1][0]+chain[-1][1]>a else None
CM=bytearray(HI); LM=set()
def classify(a,n):
    cov=sum(PR[x] for x in range(a,a+n)); cove=sum(EV[x] for x in range(a,a+n))
    if not cove:
        ch=lin_cover(a)
        if ch:
            m=bytearray(n)
            for x0,n0,k0 in ch:
                for y in range(x0,x0+n0):
                    if a<=y<a+n: m[y-a]=1
            cove=sum(m)
            LM.update(a+i for i,v in enumerate(m) if v)
    reg=region(a); ct=content(a,n)
    typed_data = reg.startswith("run:") and reg[4:] in ("string","pointer table","parameter table","fill","font")
    if cov==n: cl="bogus: overlaps proven even code (mis-decode across a real instruction)"
    elif cov: cl="bogus: partly over proven even code, rest data"
    elif ct=="ascii": cl="data: ASCII text"
    elif ct=="fill": cl="data: 0xFF fill"
    elif typed_data: cl="data: typed table ("+reg[4:]+")"
    elif cove==n: cl="bogus: overlaps structural even code (decodes cleanly, not reached from a proven entry)"
    else: cl="data: untyped binary"
    return cl,reg,ct,cov,cove
rows=[]; agg=collections.Counter(); aggb=collections.Counter(); reg_b=collections.Counter()
odd_b=[(a,v) for a,v in sorted(ib.items()) if v[1]=="code" and a%2]
odd_a={a for a,v in ia.items() if v[1]=="code" and a%2}
for a,v in odd_b:
    n=v[0]; cl,reg,ct,cov,cove=classify(a,n)
    still= a in odd_a
    rows.append((a,n,v[4],v[2],reg,ct,cov,cove,cl,"yes" if still else "no"))
    if cl.startswith("bogus"):
        for x in range(a,a+n):
            if PR[x] or EV[x] or x in LM: CM[x]=1
    agg[cl]+=1; aggb[cl]+=n; reg_b[(reg,"still" if still else "removed")]+=n
# odd heads that exist only in the after state
extra=[(a,ia[a]) for a in sorted(odd_a) if a not in ib]
with open(OUT+"odd-heads.tsv","w",encoding="utf-8",newline="\n") as f:
    f.write("# H1: every odd-aligned IDA code head in MAIN_FULL (ida/out/h8s-decode/work/items_before.tsv). H8/H8S/H8SX instructions are word-aligned, so none can be a real instruction start.\n")
    f.write("# proven_cov = bytes covered by an even instruction reached from corrected proven seeds (binutils H8SX oracle, offline/reach.py); struct_cov = covered by an even decode reached from any even IDA head.\n")
    f.write("ea\tsize\tmnem\tstop\tregion\tcontent\tproven_cov\tstruct_cov\tclass\tstill_in_G1_H8S\n")
    for x in rows: f.write("%06X\t%d\t%s\t%d\t%s\t%s\t%d\t%d\t%s\t%s\n"%x)
# denominator arithmetic
def mask(items,cond):
    m=bytearray(HI)
    for ea,(sz,k,st,fn,mn) in items.items():
        if k=="code" and cond(ea):
            for x in range(ea,min(HI,ea+sz)): m[x]=1
    return m
def corr(items):
    allm=mask(items,lambda e:True); ev=mask(items,lambda e:e%2==0); od=mask(items,lambda e:e%2==1)
    # real code hidden under odd heads = proven/structural even decode bytes on odd-head bytes not already even is_code
    hid=sum(1 for x in range(HI) if od[x] and CM[x] and not ev[x])
    return sum(allm),sum(od),hid
L=[]
for tag,items in (("MAIN_FULL (before)",ib),("G1_H8S (after)",ia)):
    tot,od,hid=corr(items)
    L.append("%s: is_code %d; odd-head bytes %d (%d heads); real even-code bytes hidden under odd heads %d; corrected is_code %d"%(tag,tot,od,sum(1 for a,v in items.items() if v[1]=='code' and a%2),hid,tot-od+hid))
L.append("")
L.append("classes over the 1,501 MAIN_FULL odd heads:")
for k in sorted(agg): L.append("  %-95s heads %5d bytes %5d"%(k,agg[k],aggb[k]))
L.append("")
L.append("bytes by region (MAIN_FULL odd heads), split by whether G1 removed the head:")
for k in sorted(reg_b): L.append("  %-45s %-8s %5d"%(k[0],k[1],reg_b[k]))
L.append("")
L.append("odd heads present only after G1: %d (%d B): %s"%(len(extra),sum(v[0] for a,v in extra)," ".join("%06X"%a for a,v in extra[:20])))
L.append("odd addresses hit as branch/flow targets by the corrected proven descent: %d"%sum(1 for a,why in bad.items() if why=="odd"))
open(OUT+"odd-heads-summary.txt","w",encoding="utf-8",newline="\n").write("\n".join(L)+"\n")
print("\n".join(L))

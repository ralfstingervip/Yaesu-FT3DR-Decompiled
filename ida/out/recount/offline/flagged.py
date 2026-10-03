# H1: detail for the function starts flagged by fnsanity.py. Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys,pickle; sys.path.insert(0,(REPO + "/ida/out/h8s-decode/offline"))
from rd import flow,IMG,HI,descend,load
from reach import seeds_corrected,TAB,vec,SWCASES
S=seeds_corrected()
_,ib,_=load("before")
FL=[int(l.split("\t")[0],16) for l in open(sys.argv[1]) if "\t" in l]
# global reach with flagged seeds removed
seed=(set(S)-set(FL))|vec
for t in TAB.values(): seed|={x for x in t if x%2==0}
r,_,_=descend(list(seed))
PR=bytearray(HI)
for a,(n,t,k) in r.items():
    for x in range(a,a+n): PR[x]=1
code=bytearray(HI)
for ea,(sz,k,st,fn,mn) in ib.items():
    if k=="code":
        for x in range(ea,ea+sz): code[x]=1
tabt={x for t in TAB.values() for x in t}
for s in FL:
    e,src=S[s]
    lead=0
    while s+lead<e and (32<=IMG[s+lead]<127 or IMG[s+lead] in (0,0xff)): lead+=1
    ext=e-s
    print("%06X-%06X %-8s ext=%4d lead_ascii=%3d iscode_in_lead=%3d iscode_ext=%4d reached_by_others=%4d tbl_in=%s | %r"%(
        s,e,src,ext,lead,sum(code[s:s+lead]),sum(code[s:e]),sum(PR[s:e]),
        ",".join("%06X"%x for x in sorted(tabt) if s<=x<e)[:40], IMG[s:s+min(ext,40)]))
print("==== gap rows (bytes before first reached-by-others byte) ====")
for s in FL:
    e,src=S[s]
    p=s
    while p<e and not PR[p]: p+=1
    if p>s:
        print("%06X\t%06X\t%s\tgap=%d\tnext=%06X\t%s\t%r"%(s,e,src,p-s,p,"END" if p==e else "",IMG[s:p][:70]))

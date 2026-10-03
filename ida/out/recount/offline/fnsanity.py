# H1: sanity sweep of every credited MAIN function start (fnindex validated + F1 proved, corrected):
# flags starts whose own flow hits an odd branch target or an undecodable word inside the extent, or whose bytes open with ASCII.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys,re; sys.path.insert(0,(REPO + "/ida/out/h8s-decode/offline"))
from rd import flow,IMG,HI
from reach import seeds_corrected
S=seeds_corrected()
def asc(a,n=int(sys.argv[1]) if len(sys.argv)>1 else 8): return all(32<=c<127 for c in IMG[a:a+n])
out=[]
for s,(e,src) in sorted(S.items()):
    seen=set(); work=[s]; odd=[]; badw=[]
    while work:
        a=work.pop()
        while s<=a<e and a not in seen:
            if a&1: odd.append(a); break
            n,t,k,tg=flow(a)
            if n==0: badw.append(a); break
            seen.add(a)
            for x in tg:
                if x&1: odd.append(x)
                elif s<=x<e: work.append(x)
            if k in("stop","stops"): break
            a+=n
    cov=0
    flags=[]
    if asc(s): flags.append("ascii-start")
    if odd: flags.append("odd-target:"+",".join("%06X"%x for x in odd[:3]))
    if badw: flags.append("undecodable:"+",".join("%06X"%x for x in badw[:3]))
    if flags: out.append((s,e,src,";".join(flags),IMG[s:s+12].hex()))
for r in out: print("%06X\t%06X\t%s\t%s\t%s"%r)
print(len(out),"flagged of",len(S))

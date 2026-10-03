from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys; sys.path.insert(0,".")
from rd import *
import json,pickle,re
ids,ib,fb=load("before"); _,ia,fa=load("after")
B={s:e for s,e,n,c in fb}; A={s:e for s,e,n,c in fa}
plan=json.load(open((_REPO_S + "/ida/out/h8s-decode/work/absorb_plan.json"),encoding="utf-8"))
P={a:(n,t) for a,n,t,o in plan["insns"]}
sites={a:t for a,n,t in plan["sites"]}
S=seeds_proven()
ent,calls,jumps,tabt=pickle.load(open("entries.pkl","rb"))
TERM=re.compile(r"^(rts|rte|rts/l|rte/l|jmp|bra|bra/s)\b")
def plaus(x):
    x&=0xFFFFFF
    if x<0x07B754: return "rom"
    if 0xFEE000<=x<0xFFC000: return "ram"
    if 0xFFEA00<=x<=0xFFFFFF and not (0xFFFF00<=x<0xFFFF20): return "io"
    return "BAD"
rows=[]
for ln in open((_REPO_S + "/ida/out/h8s-decode/work/validate_out.tsv"),encoding="utf-8").read().splitlines()[1:]:
    c=ln.split("\t")
    s=int(c[0],16)
    if c[1]=="-": continue
    e=int(c[1],16); chunks=int(c[2]); ninsn=int(c[3]); cb=int(c[4]); lasts=c[5].split(" | ")
    cref=int(c[6]); calls_from=c[7]; jumps_from=c[8]; dref_to=int(c[9]); drefs=[int(x,16) for x in c[10].split(",") if x]
    term_ok=all(TERM.match(l.split(":",1)[1].strip()) for l in lasts if l!="none")
    lastterm=TERM.match(lasts[-1].split(":",1)[1].strip()) if lasts and lasts[-1]!="none" else None
    pl=collections.Counter(plaus(d) for d in drefs)
    entry=[]
    if calls_from: entry.append("call")
    if jumps_from: entry.append("jump")
    if dref_to: entry.append("dataref")
    if s in S: entry.append("proven:"+S[s][1])
    if s in tabt: entry.append("table")
    kind="new" if s not in B else ("extended" if e>B[s] else ("shrunk" if e<B[s] else "rederived-same"))
    newb=sum(n for a,(n,t) in P.items() if ia.get(a,(0,'','',0,'-'))[3]=="%06X"%s)
    nsite=sum(1 for a in sites if ia.get(a,(0,'','',0,'-'))[3]=="%06X"%s)
    tiers="".join(sorted(set(t for a,(n,t) in P.items() if ia.get(a,(0,'','',0,'-'))[3]=="%06X"%s)))
    rows.append(dict(start=s,end=e,old_end=B.get(s),kind=kind,chunks=chunks,ninsn=ninsn,code_bytes=cb,planned_bytes=newb,sites=nsite,tiers=tiers,
                     term_all=term_ok,term_last=bool(lastterm),lasts=lasts,entry=",".join(entry) or "none",calls_from=calls_from,jumps_from=jumps_from,dref_to=dref_to,
                     plaus=dict(pl)))
pickle.dump(rows,open("valid.pkl","wb"))
c=collections.Counter((r["kind"], r["term_all"], r["entry"]!="none", r["plaus"].get("BAD",0)==0) for r in rows)
for k,v in sorted(c.items()): print(v,k)
for r in rows:
    if not r["term_all"] or r["entry"]=="none" or r["plaus"].get("BAD",0):
        print("%06X-%06X %-9s ch=%d n=%d term=%s entry=%s plaus=%s sites=%d last=%s"%(r["start"],r["end"],r["kind"],r["chunks"],r["ninsn"],r["term_all"],r["entry"],r["plaus"],r["sites"],r["lasts"][-3:]))

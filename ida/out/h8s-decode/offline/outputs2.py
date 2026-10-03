from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys; sys.path.insert(0,".")
from ctx import *
from rd import flow, seeds_proven
import pickle,json,re,bisect
OUT=(_REPO_S + "/ida/out/h8s-decode/")
W=OUT+"work/"
ids,ib,fb=load("before"); _,ia,fa=load("after")
B={s:e for s,e,n,c in fb}; A={s:e for s,e,n,c in fa}
vrows=pickle.load(open("valid.pkl","rb"))
plan=json.load(open(W+"absorb_plan.json",encoding="utf-8"))
P={a:(n,t,o) for a,n,t,o in plan["insns"]}
S=seeds_proven()
IMMBAD={0x82000,0x23102,0x93402,0xA3402}
TERM=re.compile(r"^(rts|rte|rts/l|rte/l|jmp|bra|bra/s)\b")
mid=set()
for a,(n,t,o) in P.items(): mid.update(range(a+1,a+n))
with open(OUT+"absorbed.tsv","w",encoding="utf-8",newline="\n") as fh:
    fh.write("# Functions created, extended or removed in G1_H8S by the H8SX decode, and absorbed code runs left outside functions.\n")
    fh.write("# validation: term = every chunk ends in rts/rte/rts/l/jmp/bra (or falls into the next function); entry = call/jump xref, data/table ref, F1/fnindex proof;\n")
    fh.write("#             operands = data-reference targets classified ROM (<0x07B754) / RAM (0xFEE000-0xFFBFFF) / I/O (0xFFEA00-0xFFFFFF); 'imm' = IDA offset on an immediate constant.\n")
    fh.write("kind\tstart\tend_before\tend_after\tchunks\tinsns\tcode_bytes\tnew_h8sx_bytes\tsites\ttiers\tterm\tentry\toperands\tresult\tnote\n")
    for r in sorted(vrows,key=lambda r:r["start"]):
        s=r["start"]; e=r["end"]
        lasts=r["lasts"]
        if r["term_all"]: term="yes"
        else:
            fall=[]
            for l in lasts:
                la=int(l.split(":",1)[0],16); lt=l.split(":",1)[1].strip()
                if TERM.match(lt): continue
                nx=la+bu(la)[0]
                v=ia.get(nx)
                fall.append("%06X->%s"%(la,("code %06X (owner %s)"%(nx,v[3])) if v and v[1]=="code" else "NOT CODE"))
            term="falls-through: "+", ".join(fall) if all("NOT CODE" not in f for f in fall) else "NO: "+", ".join(fall)
        pl=dict(r["plaus"]); note=[]
        drefs=[]
        bad=pl.pop("BAD",0)
        if bad: note.append("%d imm-offset(s)"%bad)
        opnd=",".join("%s=%d"%(k,v) for k,v in sorted(pl.items())) or "-"
        if bad: opnd+=",imm=%d"%bad
        entry=r["entry"]
        if entry=="none":
            if s in (0x04DE94,0x04DF98): entry="table 0x04AB70 (F1, raw dword, no IDA xref)"; note.append("true entry inside F1 row %s"%("04DE6E" if s==0x04DE94 else "04DF72"))
            elif s in B: entry="none (pre-existing IDA function, not proven)"
        ok = (not term.startswith("NO")) and not entry.startswith("none")
        res = "ok" if ok else ("ok-unreferenced-preexisting" if (not term.startswith("NO") and entry.startswith("none (pre")) else "CHECK")
        if s==0x01A432: note.append("not an H8SX site: lane-1 sub_1A432 (F6 28 B double-count); IDA made it code during re-analysis")
        if s==0x0703C4: note.append("not an H8SX site: IDA side effect from a data offset at 0x0703E6")
        fh.write("%s\t%06X\t%s\t%06X\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%s\t%s\t%s\t%s\n"%(r["kind"],s,("%06X"%r["old_end"]) if r["old_end"] else "-",e,r["chunks"],r["ninsn"],r["code_bytes"],
                 r["planned_bytes"],r["sites"],r["tiers"] or "-",term,entry,opnd,res,"; ".join(note+["last: "+lasts[-1]])))
    for s in sorted(set(B)-set(A)):
        why="start was mid-instruction (+%d into an H8SX insn)"%(next((s-a for a,(n,t,o) in P.items() if a<s<a+n),0)) if s in mid else "start became data (ASCII); true entry restored at %06X"%(0x04DE94 if s==0x04DE6E else 0x04DF98)
        fh.write("removed\t%06X\t%06X\t-\t-\t-\t-\t-\t-\t-\t-\t%s\t-\tcorrect\t%s\n"%(s,B[s],("proven:"+S[s][1]) if s in S else "-",why))
    # absorbed runs outside functions
    newb=sorted(a for a,v in ia.items() if v[1]=="code" and a%2==0 and a not in ib or (a in ib and ib[a][1]!="code" and v[1]=="code"))
    outside=[a for a in sorted(P) if ia.get(a,(0,'','',0,'-'))[3]=="-"]
    runs=[]
    for a in outside:
        n=P[a][0]
        if runs and runs[-1][1]==a: runs[-1][1]=a+n; runs[-1][2].append(a)
        else: runs.append([a,a+n,[a]])
    for s,e,ins in runs:
        last=ins[-1]; lt=bu(last)[1]
        nxt=ia.get(e)
        if TERM.match(lt): term="yes"
        elif nxt and nxt[1]=="code": term="flows into existing code at %06X"%e
        else: term="NO"
        tiers="".join(sorted(set(P[x][1] for x in ins)))
        nsite=sum(1 for x in ins if x in {a for a,n,t in plan["sites"]})
        fh.write("code-run\t%06X\t-\t%06X\t-\t%d\t%d\t%d\t%d\t%s\t%s\t%s\t-\t%s\t%s\n"%(s,e,len(ins),e-s,e-s,nsite,tiers,term,"site origin %06X"%P[ins[0]][2],"ok" if term!="NO" else "CHECK","last: "+lt+"; W2-8 type "+str(runtype(s))))
print("absorbed.tsv written")

from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys; sys.path.insert(0,".")
from clean import *
from rd import flow
import pickle,json
ids,items,funcs=load()
rows=pickle.load(open("sites.pkl","rb"))
code={ea:v[0] for ea,v in items.items() if v[1]=="code"}
codebytes=set()
for ea,sz in code.items():
    if ea%2==0: codebytes.update(range(ea,ea+sz))
code_odd={ea for ea in code if ea%2}
code={ea:sz for ea,sz in code.items() if ea%2==0}
W0=0x078106
sites=[(a,n,t,tier) for a,n,t,tier in rows if tier in("A","B")]
siteset={a:tier for a,n,t,tier in sites}
plan={}   # addr -> (len, tier, origin_site)
conflicts=[]; oddrep=set()
for a,n,t,tier in sites:
    work=[a]; seen=set()
    while work:
        x=work.pop()
        while x not in seen:
            if x in code and x not in siteset: break        # rejoined IDA code at same alignment
            if x>=W0: break                                  # never enter the closed window
            ln,tt,k,tg=flow(x)
            if k=="bad" or x&1: conflicts.append((a,x,"bad")); break
            # overlap with an IDA code item at different alignment (other than the site's own mis-split tail)
            ov=[y for y in range(x,x+ln) if y in codebytes and y not in code] + [y for y in range(x+1,x+ln) if y in code]
            oddov=[y for y in range(x-1,x+ln) if y in code_odd]
            if oddov: oddrep.update(oddov)
            if ov and x not in siteset:
                conflicts.append((a,x,"overlap %06X"%ov[0])); break
            seen.add(x)
            if x not in plan or (plan[x][1]=="B" and tier=="A"): plan[x]=(ln,tier,a)
            if k in("stop","stops"):
                work.extend(y for y in tg if y<HI)
                if k=="stops": 
                    y=x+ln
                    if y not in code: 
                        l2,t2,k2,_=flow(y)
                        if l2: plan.setdefault(y,(l2,tier,a))
                break
            if k=="cond": work.extend(y for y in tg if y<HI)
            x+=ln
from gaps import gap_insns
for a,n,s_ in gap_insns():
    if a not in plan: plan[a]=(n,'B',s_)
pickle.dump((plan,conflicts,oddrep),open("plan.pkl","wb"))
newb=sum(v[0] for x,v in plan.items())
print("planned instructions",len(plan),"bytes",newb)
print("by tier",collections.Counter(v[1] for v in plan.values()), {t:sum(v[0] for v in plan.values() if v[1]==t) for t in "AB"})
print("sites in plan", sum(1 for a in siteset if a in plan))
print("odd-aligned IDA heads to replace",len(oddrep)); print("conflicts",len(conflicts)); 
for c in conflicts[:40]: print("  site %06X at %06X %s | %s"%(c[0],c[1],c[2],bu(c[1])[1]))
# already-code bytes inside planned instructions (mis-split tails)
pre=sum(1 for x,v in plan.items() for y in range(x,x+v[0]) if y in codebytes)
print("planned bytes already is_code (mis-split tails etc):",pre)
json.dump({"insns":[[x,v[0],v[1],v[2]] for x,v in sorted(plan.items())],"sites":[[a,n,tier] for a,n,t,tier in sites],"odd_replace":sorted(oddrep)},
          open((_REPO_S + "/ida/out/h8s-decode/work/absorb_plan.json"),"w",encoding="utf-8"))

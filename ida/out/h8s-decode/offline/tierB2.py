import sys; sys.path.insert(0,".")
from ctx import *
from rd import descend
from forms import norm
import pickle
ids,items,funcs=load()
rA,seedA,ut=pickle.load(open("tierA.pkl","rb"))
code={ea for ea,v in items.items() if v[1]=="code"}
seedB=set(seedA)|{a for a in code if a%2==0 and runtype(a)=="recovered code"}
rB,badB,_=descend(list(seedB))
pickle.dump((rB,seedB),open("tierB2.pkl","wb"))
c=collections.Counter(); ex=collections.defaultdict(list)
for a in sorted(rB):
    if ids[a]==0 and a not in rA:
        k=(norm(rB[a][1]), runtype(a))
        c[k]+=1; ex[k].append(a)
for k,v in sorted(c.items(),key=lambda x:-x[1]): print(v,k," ".join("%06X"%a for a in ex[k][:8]))
print(sum(c.values()))

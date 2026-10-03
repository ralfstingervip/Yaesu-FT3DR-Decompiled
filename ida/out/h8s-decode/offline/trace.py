import sys; sys.path.insert(0,".")
from ctx import *
from rd import flow
import pickle
def descend_p(seeds):
    reached={}; par={}
    work=[(s,None) for s in seeds]
    while work:
        a,p=work.pop(); prev=p
        while 0<=a<HI and a not in reached:
            if a&1: break
            n,t,k,tg=flow(a)
            if k=="bad": break
            reached[a]=(n,t,k); par[a]=prev
            for x in tg:
                if 0<=x<HI and x not in reached: work.append((x,a))
            if k in("stop","stops"): break
            prev=a; a+=n
    return reached,par
if __name__=="__main__":
    rB,seedB=pickle.load(open(sys.argv[1],"rb"))
    r,par=descend_p(sorted(seedB))
    for a in [int(x,16) for x in sys.argv[2:]]:
        p=[a]
        while par.get(p[-1]) is not None and len(p)<5000: p.append(par[p[-1]])
        print("%06X root %06X runtype=%s"%(a,p[-1],runtype(p[-1])))
        for x,y in zip(p,p[1:]):
            if y+r[y][0]!=x: print("    edge %06X -> %06X  %s [%s]"%(y,x,r[y][1],runtype(y)))

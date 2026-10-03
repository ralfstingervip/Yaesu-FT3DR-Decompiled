import sys; sys.path.insert(0,".")
from load import *
import pickle,re,bisect
rows=pickle.load(open("sites.pkl","rb"))
_,ia,fa=load("after")
code=sorted(a for a,v in ia.items() if v[1]=="code" and a%2==0)
def push_set(t):
    m=re.match(r"stm\.l (er\d)-(er\d),@-sp",t)
    if m: return (m.group(1),m.group(2))
    m=re.match(r"mov\.l (er\d),@-er7",t)
    if m: return (m.group(1),m.group(1))
def rts_set(t):
    m=re.match(r"rt[se]/l (er\d)-(er\d)$",t)
    if m: return (m.group(1),m.group(2))
    m=re.match(r"rt[se]/l (er\d)$",t)
    if m: return (m.group(1),m.group(1))
RES={}
for a,n,t,tier in rows:
    if tier not in "ABW" or not t.startswith(("rts/l","rte/l")): continue
    rs=rts_set(t); i=bisect.bisect_left(code,a); found=None; first_push=None
    for j in range(i-1,max(0,i-1500),-1):
        h=code[j]; tt=bu(h)[1]
        ps=push_set(tt)
        if ps==rs: found=h
        if tt=="rts" or tt.startswith(("rte","jmp @0x")) : break
        if tt.startswith(("rts/l","rte/l")) and found is not None: break
    RES[a]=(t,tier,found)
if __name__=="__main__":
    ok=sum(1 for v in RES.values() if v[2] is not None)
    print("rts/l sites",len(RES),"with matching save in the same routine",ok)
    for a,(t,tier,f) in sorted(RES.items()):
        if f is None: print("  no match %06X %s %s"%(a,t,tier))
    pickle.dump(RES,open("rtsl.pkl","wb"))

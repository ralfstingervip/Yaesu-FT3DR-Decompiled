import sys
sys.path.insert(0,".")
from ctx import *
ids,items,funcs=load()
def lin(a,b):
    while a<b:
        n,t=bu(a)
        it=items.get(a)
        tag=("I:"+it[1]+(":"+it[3] if it[3]!="-" else "")) if it else ("  " if True else "")
        rt=runtype(a)
        if n==0:
            print("%06X  %-20s %-14s %s  [%s]"%(a,IMG[a:a+2].hex(),tag,"??",rt)); a+=2; continue
        print("%06X  %-20s %-14s %s%s  [%s]"%(a,IMG[a:a+n].hex(),tag,"*" if ids[a]==0 else " ",t,rt)); a+=n
if __name__=="__main__":
    lin(int(sys.argv[1],16),int(sys.argv[2],16))

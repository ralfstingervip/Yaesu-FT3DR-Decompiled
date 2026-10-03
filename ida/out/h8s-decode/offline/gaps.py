import sys; sys.path.insert(0,".")
from load import *
# H8SX-module bytes still not code after the first absorb pass (doc 36, Findings 3).
GAPS=[(0x076148,0x07615E),(0x076256,0x076258),(0x076B20,0x076C04),(0x076FEE,0x076FF0),(0x0771D6,0x0771E2),
      (0x077320,0x077324),(0x0773E8,0x07745A),(0x0779C4,0x077A1C),(0x07801C,0x078086),(0x078104,0x078106)]
def gap_insns():
    out=[]
    for s,e in GAPS:
        a=s
        while a<e:
            n,t=bu(a)
            assert n, "gap %06X does not decode at %06X"%(s,a)
            out.append((a,n,s)); a+=n
        assert a>=e and a-e<=4, "gap %06X overruns to %06X"%(s,a)
    return out
if __name__=="__main__":
    g=gap_insns(); print(len(g), sum(n for a,n,s in g))

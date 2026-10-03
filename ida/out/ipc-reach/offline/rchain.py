import pickle,sys
visited,tabs=pickle.load(open("rd.pkl","rb"))
from bu import BU
def chain(a,maxn=400):
    if a not in visited: return "NOT-REACHED"
    out=[];n=a;steps=0;last=None
    while n is not None and steps<maxn:
        src,k=visited[n]
        if k!="ft": out.append("%06X<-%s@%06X"%(n,k,src))
        if k=="vec": break
        if k.startswith('tab'): src=int(k.split('@')[1],16)
        n=src;steps+=1
    return " ; ".join(out)
if __name__=="__main__":
    for x in sys.argv[1:]: print(x,chain(int(x,16)))

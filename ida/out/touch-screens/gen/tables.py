import sys; sys.path.insert(0,'.')
from k3lib import *
tabs=sorted(set(int(l.split('\t')[2],16) for l in open('pagemap.txt')))
# include 0x26F9C caller table
def parse(t):
    c=be16(t); recs=[]
    for i in range(c):
        p=t+2+10*i
        x0,y0,x1,y1,v=be16(p),be16(p+2),be16(p+4),be16(p+6),be16(p+8)
        recs.append((x0,y0,x1,y1,v))
    return c,recs
if __name__=='__main__':
    print(len(tabs))
    bad=0; tot=0
    for t in tabs:
        c,r=parse(t); tot+=c
        ok=all(x0<=x1<320 and y0<=y1<240 for x0,y0,x1,y1,v in r)
        if not ok or c==0 or c>40: bad+=1; print("BAD %06X c=%d"%(t,c), r[:3])
    print("zones",tot,"bad",bad)
    # adjacency: tables contiguous?
    for t in tabs:
        c,r=parse(t); print("%06X..%06X c=%2d proven=%d vals=%s"%(t,t+2+10*c,c,proven(t),",".join(("%X"%v) for *_,v in r)))

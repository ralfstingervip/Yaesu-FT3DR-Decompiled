import sys; sys.path.insert(0,".")
from ctx import *
from rd import flow
import re
ABS=re.compile(r"@0x(ff[0-9a-f]{4}|[0-9a-f]{4}):(16|32)|@0x([0-9a-f]{4}):16")
def local_clean(a, known_code, maxn=3000):
    """bounded descent from a (no call-following). Returns (ok, reason, n_insn, n_stop, anchors)."""
    seen=set(); work=[a]; nstop=0; anchors=0; n=0
    while work:
        x=work.pop()
        while x not in seen:
            if x in known_code and x!=a: break   # rejoined vetted code
            if x&1: return False,"odd@%06X"%x,n,nstop,anchors
            if x>=HI: return False,"oob",n,nstop,anchors
            ln,t,k,tg=flow(x)
            if k=="bad": return False,"bad@%06X"%x,n,nstop,anchors
            if re.search(r"er-\d",t): return False,"badrange@%06X"%x,n,nstop,anchors
            seen.add(x); n+=1
            if n>maxn: return False,"toolong",n,nstop,anchors
            if "@0xff" in t or re.search(r"@0x[0-9a-f]{4}:16",t) or k=="call": anchors+=1
            if k in("stop","stops"):
                nstop+=1
                for y in tg:
                    if y&1 or y>=HI: return False,"badtgt",n,nstop,anchors
                    work.append(y)
                break
            if k=="cond":
                for y in tg:
                    if y&1 or y>=HI: return False,"badtgt",n,nstop,anchors
                    work.append(y)
            x+=ln
    return True,"ok",n,nstop,anchors

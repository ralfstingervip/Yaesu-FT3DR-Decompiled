from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
from load import *
import re
R=(_REPO_S + "/ida/out")
def seeds_proven():
    s={}
    for f in ["main-low","main-high-a","main-high-b"]:
        L=open(R+"/fnindex/%s.tsv"%f,encoding="utf-8").read().splitlines()
        h=L[0].split("\t")
        for ln in L[1:]:
            c=dict(zip(h,ln.split("\t")))
            if c["validated"]=="yes": s[int(c["start"],16)]=(int(c["end"],16),"fnindex:"+f)
    L=open(R+"/main-indirect/proved.tsv",encoding="utf-8").read().splitlines()
    for ln in L[1:]:
        c=ln.split("\t"); s[int(c[0],16)]=(int(c[1],16),"proved")
    return s
TGT=re.compile(r"\((0x[0-9a-f]+)\)\s*$")
def flow(a):
    """returns (len, text, kind, targets) kind in normal/cond/stop/call/bad"""
    n,t=bu(a)
    if n==0: return 0,t,"bad",[]
    parts=t.split(" ",1); m=parts[0]; op=parts[1] if len(parts)>1 else ""
    tg=[]
    mm=TGT.search(op)
    if m in("rts","rte","rts/l","rte/l"): return n,t,"stop",[]
    if m=="jmp":
        mo=re.match(r"@(0x[0-9a-f]+):",op)
        return n,t,"stop",[int(mo.group(1),16)] if mo else []
    if m in("bra","bra/s"):
        if mm: tg=[int(mm.group(1),16)]
        return n,t,("stops" if m=="bra/s" else "stop"),tg
    if m=="brn": return n,t,"normal",[]
    if m in("jsr","bsr"):
        mo=re.match(r"@(0x[0-9a-f]+):",op)
        if mo: tg=[int(mo.group(1),16)]
        elif mm and m=="bsr": tg=[int(mm.group(1),16)]
        return n,t,"call",tg
    if (m.startswith("b") and mm and ("." in op)) :
        return n,t,"cond",[int(mm.group(1),16)]
    return n,t,"normal",[]
def descend(seeds,limit=HI):
    reached={}  # addr -> (len,text,kind)
    work=list(seeds); bad={}; calls=set()
    while work:
        a=work.pop()
        while 0<=a<limit and a not in reached:
            if a&1: bad[a]="odd"; break
            n,t,k,tg=flow(a)
            if k=="bad": bad[a]=t; break
            reached[a]=(n,t,k)
            for x in tg:
                if 0<=x<limit and x not in reached: work.append(x)
            if k=="call": calls.update(tg)
            if k=="stop": break
            if k=="stops":
                b=a+n
                if b not in reached:
                    n2,t2,k2,tg2=flow(b)
                    if n2: reached[b]=(n2,t2,k2)
                break
            a+=n
    return reached,bad,calls

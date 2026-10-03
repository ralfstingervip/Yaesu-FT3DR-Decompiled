import re,collections,pickle,sys
from bu import BU,IMG
HI=0x7B754
import pickle as _p
_code=_p.load(open('graph.pkl','rb'))[0]
COV=set()
for _e,(_s,_f) in _code.items():
    COV.update(range(_e,_e+_s))
rx=re.compile(r"\(0x([0-9a-f]+)\)|@0x([0-9a-f]+):24")
NOTBR=("btst","bset","bclr","bnot","bld","bst","bor","band","bxor","bild","bist","bior","biand","bixor","bfld","bfst")
STOP=("rts","rte","jmp","bra","rts/l","rte/l","bra/s")
def ok(a):
    if not (0x400<=a<HI) or a&1: return False
    n,t=BU.get(a,(0,""))
    return n>0 and not t.startswith(".word") and "Hmmm" not in t and "Don't" not in t
def table_from(a):
    out=[];n=0
    while a+4<=HI and n<400:
        v=int.from_bytes(IMG[a:a+4],'big')
        if ok(v) and v>=0x400: out.append((a,v))
        elif v==0x3FFA0 or v==0: 
            if v==0 and n==0: break
        else: break
        a+=4;n+=1
    return out
visited={}   # ea -> (pred_ea, kind)
q=collections.deque()
def push(t,src,k):
    if t not in visited and ok(t):
        visited[t]=(src,k); q.append(t)
for a in range(0,0x400,4):
    v=int.from_bytes(IMG[a:a+4],'big')
    if ok(v): push(v,a,"vec")
tabs_used={}
while q:
    a=q.popleft()
    n,t=BU[a]; parts=t.split(); m=parts[0]
    nxt=a+n
    isbr = m in ("jsr","jmp","bsr") or (m.startswith("b") and m not in NOTBR)
    if isbr:
        g=rx.search(t)
        if g: push(int(g.group(1) or g.group(2),16),a,m)
    if m not in STOP:
        push(nxt,a,"ft")
    # immediates (exclude branch encodings already handled)
    if not isbr:
        b=IMG[a:a+n]
        for i in range(1,n-2):
            for L in (4,3):
                if i+L>n: continue
                v=int.from_bytes(b[i:i+L],'big')
                if 0x400<=v<HI:
                    if v in visited or ok(v):
                        # direct code pointer only if 32/24 bit and looks like a function head (preceded by rts or is known)
                        pass
                    tb=table_from(v)
                    if len(tb)>=1 and v not in COV:
                        tabs_used.setdefault(v,a)
                        for sa,p in tb: push(p,sa,"tab%06X@%06X"%(v,a))
                    elif ok(v) and L==4 and IMG[v-2:v]==b"\x54\x70":
                        push(v,a,"imm")
pickle.dump((visited,tabs_used),open("rd.pkl","wb"))
print("visited",len(visited),"bytes", sum(BU[a][0] for a in visited))

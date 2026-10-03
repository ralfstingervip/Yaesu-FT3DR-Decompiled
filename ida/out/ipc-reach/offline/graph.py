from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import re,collections,pickle,os
from bu import BU,IMG
W=str(_REPO) + r"/ida/out/h8s-decode/work"
code={}  # ea->(size,func)
for ln in open(os.path.join(W,"items_after.tsv"),encoding="utf-8").read().splitlines()[1:]:
    ea,sz,k,st,fn,mn=ln.split("\t")
    if k=="code": code[int(ea,16)]=(int(sz),None if fn=="-" else int(fn,16))
funcs={}
for ln in open(os.path.join(W,"funcs_after.tsv"),encoding="utf-8").read().splitlines()[1:]:
    s,e,n,c=ln.split("\t"); funcs[int(s,16)]=int(e,16)
rx=re.compile(r"\(0x([0-9a-f]+)\)|@0x([0-9a-f]+):24")
edges=collections.defaultdict(list) # target -> [(kind,src_ea,src_func)]
for ea,(sz,fn) in code.items():
    n,t=BU.get(ea,(0,""))
    m=t.split()[0] if t else ""
    if m in ("jsr","jmp","bsr") or m.startswith("b") and rx.search(t) and m not in("btst","bset","bclr","bnot","bld","bst","bor","band","bxor","bild","bist","bior","biand","bixor","bfld","bfst"):
        g=rx.search(t)
        if g:
            tg=int(g.group(1) or g.group(2),16)
            edges[tg].append((m,ea,fn))
# BE32 data pointers anywhere in content (even aligned)
ptr=collections.defaultdict(list)
for a in range(0,0x7B754,2):
    v=int.from_bytes(IMG[a:a+4],'big')
    if 0x400<=v<0x7B754 and v in code:
        ptr[v].append(a)
pickle.dump((code,funcs,dict(edges),dict(ptr)),open("graph.pkl","wb"))
print(len(code),len(funcs),len(edges),len(ptr))

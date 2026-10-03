# H1: build the edit list for the private IDA DB H1_RECOUNT (odd heads -> data or true even insns; junk spans -> data).
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys,json,pickle
sys.path.insert(0,(REPO + "/ida/out/h8s-decode/offline"))
from rd import flow,HI
sys.path.insert(0,".")
import importlib.util
spec=importlib.util.spec_from_file_location("rc","recount.py")
OUT=(REPO + "/ida/out/recount/")
S,seed,r,bad=pickle.load(open("local-temp","rb"))
cover={}
for a,(n,t,k) in r.items():
    for x in range(a,a+n): cover[x]=a
odd=[l.rstrip("\n").split("\t") for l in open(OUT+"odd-heads.tsv",encoding="utf-8") if not l.startswith("#") and not l.startswith("ea\t")]
undef=[]; mk=set()
for c in odd:
    if c[9]!="yes": continue
    a=int(c[0],16); n=int(c[1]); cl=c[8]
    undef.append([a,n])
    if cl.startswith("bogus"):
        for x in range(a,a+n):
            if x in cover: mk.add(cover[x])
        if "structural" in cl:
            b=a-1; nn,t,k,tg=flow(b)
            if nn: mk.add(b)
src=open("recount.py",encoding="utf-8").read()
ns={}
exec(src[src.index("F1C = ["):src.index("# ---------------------------------------------------------------- base sets")],ns)
spans=[[s,e] for s,e,*_ in ns["FNC"]]+[[s,s+tb] for s,e,te,tb,kind,w,nt in ns["F1C"] if kind=="text"]
funcs_del=[s for s,e,*_ in ns["FNC"] if s in (0x00C448,0x00C636,0x004C14,0x011038,0x0232C6,0x037A00,0x04CAB6,0x04D9D4,0x04F054,0x04F96A,0x04FDEE,0x04FDF4,0x04FDF8,0x04FE00,0x051054,0x0510DA,0x0511D2,0x0516C6,0x0526FC,0x052704,0x059C14,0x05E08A,0x06AB5C,0x06BE28)]
json.dump(dict(undef_odd=undef,make_insn=sorted(mk),data_spans=spans,del_funcs=funcs_del,
  check=[0x034642,0x038102,0x04F3A2,0x06AC12,0x04DE94,0x04DF98,0x04E32E,0x04E546,0x05169E,0x00C448,0x06BE28]),open(OUT+"work/apply.json","w",encoding="utf-8"),indent=0)
print(len(undef),"odd heads to undefine;",len(mk),"even insns to create;",len(spans),"data spans;",len(funcs_del),"funcs to delete")

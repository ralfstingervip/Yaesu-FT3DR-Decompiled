from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys; sys.path.insert(0,".")
from ctx import *
from rd import flow, seeds_proven
from forms import norm
from hand import hand
from clean import local_clean
import pickle,json,re,bisect
from gaps import gap_insns
GAPSET={a for a,n,s_ in gap_insns()}
OUT=(_REPO_S + "/ida/out/h8s-decode/")
W=OUT+"work/"
ids,ib,fb=load("before"); _,ia,fa=load("after")
rows=pickle.load(open("sites.pkl","rb"))
plan=json.load(open(W+"absorb_plan.json",encoding="utf-8"))
P={a:(n,t,o) for a,n,t,o in plan["insns"]}
rA,seedA,ut=pickle.load(open("tierA.pkl","rb"))
idatext={}
for ln in open(W+"text_out.tsv",encoding="utf-8").read().splitlines()[1:]:
    a,n,t=ln.split("\t",2); idatext[int(a,16)]=(int(n),re.sub(r"\s+"," ",t.strip()))
W0,M0=0x078106,0x075F36
def region(a): return "window" if a>=W0 else ("h8sx-module" if a>=M0 else "bulk")
code_b={a for a,v in ib.items() if v[1]=="code"}
def before_state(a,n):
    it=ib.get(a)
    tail=[x for x in range(a+1,a+n) if x in code_b]
    s="h8s300a size0"
    if it: s+="; item=%s"%it[1]
    else: s+="; inside item"
    if tail: s+="; IDA code head(s) inside at +%s"%",".join(str(x-a) for x in tail)
    return s
# form templates
fam=collections.defaultdict(list)
for a,n,t,tier in rows:
    fam[norm(t)].append((a,n))
def template(key):
    v=fam[key]; n=v[0][1]
    if any(x[1]!=n for x in v): return "var"
    nib=[]
    for i in range(2*n):
        vals=set((IMG[a+i//2]>>(4*(1-i%2)))&15 for a,_ in v)
        nib.append("%X"%vals.pop() if len(vals)==1 else "x")
    s="".join(nib); return " ".join(s[i:i+2] for i in range(0,len(s),2))
# --- sites.tsv
with open(OUT+"sites.tsv","w",encoding="utf-8",newline="\n") as fh:
    fh.write("# H8SX-only instruction sites in MAIN content 0x000000-0x07B753 that IDA h8s300a cannot decode (decode_insn size 0).\n")
    fh.write("# status: A = reached by flow from proven entry points (fnindex validated + main-indirect proved + vectors + verified dispatch tables);\n")
    fh.write("#         B = code by structure (78 MOV.L dispatch idiom, or inside the H8SX module 0x075F36-0x078105), clean decode to a terminator;\n")
    fh.write("#         W = inside the closed service window 0x078106-0x07B753 (enumerated byte-class only, not absorbed); X = data context, rejected.\n")
    fh.write("# binutils = GNU binutils opcodes/h8300-dis.c (H8SX table) built locally; ida = IDA 9.1 h8sxa in G1_H8S; hand = hand decoder (doc 36 Findings 2) where the family is covered.\n")
    fh.write("addr\tbytes\tlength\tform\ttemplate\tbinutils\tida_h8sxa\thand_check\tstatus\treason\tregion\tw2_8_run_type\tida_before\tfunc_after\n")
    for a,n,t,tier in rows:
        it=idatext.get(a,(0,""))
        h=hand(IMG[a:a+10])
        cz=lambda x: re.sub(r"0x0*([0-9a-f])",r"0x",x.replace(" ","").lower())
        hc="-" if not h else ("agree" if h[0]==n and cz(h[1])==cz(t) else "DIFF:"+h[1])
        if tier=="X":
            ok,why,nn,ns,an=local_clean(a,set(rA))
            reason = ("clean-decode failed: "+why) if not ok else "outside module and not the 78 MOV.L form"
        elif tier=="A": reason="flow from proven entry"
        elif tier=="B" and a in GAPSET: reason="H8SX module routine with no visible reference (structural, linear decode)"
        elif tier=="B": reason="78 dispatch idiom" if (IMG[a]==0x78 and IMG[a+1]&0x8f==0x80) else "H8SX module, clean decode to terminator"
        else: reason="closed window"
        fa_=ia.get(a,(0,'','',0,'-'))[3] if tier in "AB" else "-"
        fh.write("%06X\t%s\t%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n"%(a,IMG[a:a+n].hex(),n,norm(t),template(norm(t)),t,
                 it[1] if it[0]==n else "LEN %d: %s"%(it[0],it[1]),hc,tier,reason,region(a),runtype(a) or "-",before_state(a,n),fa_))
print("sites.tsv written")

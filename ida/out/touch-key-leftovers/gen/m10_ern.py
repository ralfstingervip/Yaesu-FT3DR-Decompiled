# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import sys, re, json, bisect
sys.path.insert(0,'.')
from l6lib import *
sites=json.load(open("setP_ern.json"))
CWlo,CWhi=0x078106,0x07B754
UNOPENED=set()
try:
    for ln in open(str(_REPO / "ida/out/touch-screens/gen/dclos.py")): pass
except: pass
addrs=sorted(int(ln.split('\t',1)[0],16) for ln in open(str(_REPO / "ida/out/h8s-decode/work/bu_all.tsv"),encoding="utf-8"))
def prev_insns(a,k=50):
    i=bisect.bisect_left(addrs,a); return addrs[max(0,i-k):i]
HELPBODY={0x028558,0x02857C,0x0285A0,0x0285C4,0x0285E8,0x02860C,0x028630,0x028654,0x02869C,0x0286C0}
def enum_dword(tbl, lim=64):
    out=[]
    for i in range(lim):
        v=be32(tbl+4*i)
        if 0x400<=v<0x80000 and okcode(v): out.append(v)
        else: break
    return out
def scan_target(f, maxn=400):
    """depth-1 scan of a target handler for forbidden contacts"""
    a=f; win=io=0
    for _ in range(maxn):
        l,t=BU.get(a,(0,'')); 
        if l==0 or t.startswith('.word'): break
        m=t.split(' ',1)[0]
        for mm in re.finditer(r'0x([0-9a-f]+)',t):
            v=int(mm.group(1),16)
            if ':16' in t and 0x8000<=v<0x10000: v|=0xFF0000
            if 0xFFEE00<=v<=0xFFEE53 or 0xFFFF88<=v<=0xFFFF8F: io+=1
            if CWlo<=v<CWhi and re.match(r'(jsr|jmp|bsr|bra|b\w+) ',t): win+=1
        if m in ('rts','rte'): break
        a+=l
    return win,io
rows=[]; allt=set()
for s in sites:
    kind=''; tgts=[]; note=''
    if s in HELPBODY:
        kind='bbc2-index-helper'; note='er6=caller zone-handler table[IDX-1]; targets per-call (zones-resolved)'
    elif s==0x0191A8:
        kind='key-offset-table'; note='er6=0x148A0+BE16[0x19A9E+2*key]'
        for i in range(64):
            o=be16(0x19A9E+2*i); v=0x148A0+o
            if okcode(v): tgts.append(v)
            else: break
    elif s==0x029ADA:
        kind='keytable[key]'; note='er6=kt[A9ED] of item-list kt 0x014818 (slot dispatch)'
        kt=0x014818
        for k in range(17):
            v=be32(kt+4*k)
            if okcode(v): tgts.append(v)
    else:
        src=None
        for a in reversed(prev_insns(s)):
            l,t=BU.get(a,(2,'.word')); 
            if t.split()[0]=='mov.l' and ',er6' in t:
                op=t.split(' ',1)[1]
                m1=re.match(r'#0x([0-9a-f]+),er6$',op)
                m2=re.match(r'@\(0x([0-9a-f]+):(?:32|16),er(\d)\),er6$',op)
                if m1: src=('const',int(m1.group(1),16),a); break
                if m2: src=('tbl',int(m2.group(1),16),a); break
        if not src: kind='unresolved'; note='no er6 load found'
        elif src[0]=='const':
            v=src[1]
            if okcode(v): kind='const-call'; tgts=[v]; note='mov.l #%06X,er6 (direct)'%v
            else: kind='const-table'; tgts=enum_dword(v); note='mov.l #%06X,er6; dword table'%v
        else:
            base=src[1]
            if base<0x400:
                kind='record-field-dispatch'; note='er6=@(+%02X,er1=record); per-record field handler (records.tsv)'%base
            else:
                kind='indexed-table'; tgts=enum_dword(base); note='er6=@(%06X:32,erN); dword table'%base
    allt.update(tgts)
    win=io=0
    for t in tgts:
        w,i=scan_target(t); win+=w; io+=i
    rows.append((s,kind,len(tgts),win,io,note," ".join("%06X"%t for t in tgts)))
open("../work/ern_resolved.tsv","w",encoding="utf-8",newline="\n").write(
    "site\tkind\tn_targets\twindow_depth1\tusb_scic_depth1\tnote\ttargets\n"+
    "\n".join("%06X\t%s\t%d\t%d\t%d\t%s\t%s"%r for r in rows)+"\n")
tw=sum(r[3] for r in rows); ti=sum(r[4] for r in rows)
print("sites=%d unique_targets=%d total window(d1)=%d usb/sci-c(d1)=%d"%(len(rows),len(allt),tw,ti))
for r in rows: print("%06X %-22s n=%-2d win=%d io=%d | %s"%(r[0],r[1],r[2],r[3],r[4],r[5][:52]))

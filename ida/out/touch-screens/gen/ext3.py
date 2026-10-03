import sys, re; sys.path.insert(0,'.')
from k3lib import *
ladder=[]; a=0x2639C; prev=None
while a < 0x2669E:
    n,t = BU[a]
    m = re.match(r"cmp\.w #0x([0-9a-f]+),r4", t)
    if m: prev=int(m.group(1),16)
    mb = re.match(r"(beq|bcs|bcc) .*\((0x[0-9a-f]+)\)", t)
    if mb and prev is not None: ladder.append((prev, mb.group(1), int(mb.group(2),16), a))
    a+=n
pages={}
for code,op,tg,site in ladder:
    if code==0xF200 and op=='bcs': continue
    key = "F200-F22C" if code in (0xF200,0xF22D) else "%04X"%code
    pages.setdefault(tg,[])
    if key not in pages[tg]: pages[tg].append(key)
HT=0x26F08
BOPS={'beq':('==','!='),'bne':('!=','=='),'bcs':('<','>='),'bcc':('>=','<'),'bpl':('>=0','<0'),'bmi':('<0','>=0')}
def var(op):
    m=re.match(r"@(0x[0-9a-f]+):(16|32)",op)
    if m:
        v=int(m.group(1),16); v = v|0xFF0000 if m.group(2)=='16' else v
        return "[%06X]"%v
    m=re.match(r"@\((0x[0-9a-f]+):16,er0\)",op)
    if m: return "rec+%s"%m.group(1)
    return op
def walk(a, conds, stack, er5, st, out, depth=0):
    # st: dict(src=var, cmp=const, kind)
    st=dict(st)
    while True:
        n,t = BU.get(a,(0,'?'))
        if n==0: out.append(("BAD@%06X"%a, conds)); return
        m=t.split(' ',1); mn=m[0]; op=m[1] if len(m)>1 else ''
        mm = re.search(r"\((0x[0-9a-f]+)\)\s*$", op)
        if mn=='mov.l' and op.endswith(',er5') and op.startswith('#'):
            er5=int(op[1:].split(',')[0],16)
        elif mn in ('mov.b','mov.w') and op.startswith('@') and op.split(',')[-1] in ('r4l','r4'):
            st={'src':var(op.rsplit(',',1)[0]),'cmp':'nz'}
            if op.startswith('@0xbbc2'): st['src']='[FFBBC2]'
        elif mn.startswith('cmp'):
            st['cmp']=op.split(',')[0]
        elif mn=='dec.b':
            st['dec']=st.get('dec',0)+1; st['cmp']='#%d'%st['dec']
            st['cmp_is_dec']=1
        elif mn=='btst':
            mo=re.match(r"#0x([0-9a-f]+),(.*)",op); st={'src':var(mo.group(2))+".b%d"%int(mo.group(1),16),'cmp':'bit'}
        if mn=='rts':
            if stack: a=stack[-1]; stack=stack[:-1]; continue
            return
        if mn=='jsr':
            tg=int(re.match(r"@(0x[0-9a-f]+)",op).group(1),16)
            if tg==HT:
                out.append((er5, list(conds))); st={'src':'hit(%05X)'%er5,'cmp':'hit'}; a+=n; continue
            if 0x262E4<=tg<0x27030 and tg!=0x26F48:
                walk(tg, conds, stack+[a+n], er5, st, out, depth+1); return
            conds=conds+["call %06X"%tg]; a+=n; continue
        if mn in ('bra','bra/s'):
            a=int(mm.group(1),16); continue
        if mn in BOPS and mm:
            tg=int(mm.group(1),16)
            def fmt(pos):
                c=st.get('cmp'); s=st.get('src','?'); o=BOPS[mn][0 if pos else 1]
                if c=='hit': return ("HIT %s"%s[4:-1]) if o=='!=' else ("MISS %s"%s[4:-1])
                if c=='bit': return "%s=%s"%(s, '0' if o=='==' else '1')
                if c=='nz': return "%s%s0"%(s,o)
                return "%s%s%s"%(s,o,c.lstrip('#'))
            walk(tg, conds+[fmt(True)], stack, er5, st, out, depth+1)
            conds=conds+[fmt(False)]; a+=n; continue
        a+=n
rows=[]
for tg,keys in sorted(pages.items()):
    out=[]; walk(tg,[],[],None,{},out)
    seen=set()
    for tab,c in out:
        # drop redundant: keep only conditions, dedupe
        k=(tab," & ".join(c))
        if k in seen: continue
        seen.add(k); rows.append((",".join(keys),"%06X"%tg,("%06X"%tab) if isinstance(tab,int) else str(tab)," & ".join(c) or "-"))
def simp(c):
    if c=='-': return c
    parts=c.split(' & ')
    eqv=set()
    for p in parts:
        m=re.match(r"(.+?)==(.+)$",p)
        if m: eqv.add(m.group(1))
    out=[]; ne={}
    for p in parts:
        m=re.match(r"(.+?)!=(.+)$",p)
        if m:
            if m.group(1) in eqv: continue
            if m.group(1) in ne: ne[m.group(1)].append(m.group(2)); continue
            ne[m.group(1)]=[m.group(2)]; out.append(('NE',m.group(1))); continue
        if p not in out: out.append(p)
    res=[]
    for p in out:
        if isinstance(p,tuple):
            v=ne[p[1]]; res.append("%s!=%s"%(p[1],v[0]) if len(v)==1 else "%s not in {%s}"%(p[1],",".join(v)))
        else: res.append(p)
    return " & ".join(res)
final=[]; seen=set()
for r in rows:
    k=(r[0],r[2],simp(r[3]))
    if k in seen: continue
    seen.add(k); final.append((r[0],r[1],r[2],simp(r[3])))
if __name__=='__main__':
    for r in final: print("\t".join(r))

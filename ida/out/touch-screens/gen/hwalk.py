import sys, re; sys.path.insert(0,'.')
from closure import *
BOPS={'beq':('==','!='),'bne':('!=','=='),'bcs':('<','>='),'bcc':('>=','<'),'bhi':('>','<='),'bls':('<=','>'),'bpl':('>=0','<0'),'bmi':('<0','>=0'),'bge':('>=s','<s'),'blt':('<s','>=s'),'bgt':('>s','<=s'),'ble':('<=s','>s')}
def var(op):
    m=re.match(r"@(0x[0-9a-f]+):(16|32)",op)
    if m:
        v=int(m.group(1),16); v = v|0xFF0000 if m.group(2)=='16' else v
        return "[%06X]"%v
    m=re.match(r"@\((0x[0-9a-f]+):16,er0\)",op)
    if m: return "rec+%s"%m.group(1)
    return op
def hwalk(root, maxpaths=400):
    """enumerate paths from a slot-10 handler; return list of (conds, action) where action describes the terminal effect"""
    res=[]; npaths=[0]
    def go(a, conds, regs, depth, stack):
        if npaths[0]>maxpaths: return
        steps=0
        while steps<300:
            steps+=1
            n,t=BU.get(a,(0,''))
            if n==0 or t.startswith('.word') or not okcode(a):
                res.append((conds,"bad@%06X"%a)); npaths[0]+=1; return
            p=t.split(' ',1); m=p[0]; op=p[1] if len(p)>1 else ''
            if m in ('mov.w','mov.b','mov.l') and op.startswith('@') and ',' in op:
                src,dst=op.rsplit(',',1); regs=dict(regs); vv=var(src)
                if vv in ('[FF3D74]',): vv='[PAGE]'
                regs[dst]=vv
                if dst=='r4l' and vv=='[FFBBD2]' and regs.get('r4h')=='[FFBBD1]': regs['r4']='[PAGE]'
                if dst in ('r4l','r4h') and not (dst=='r4l' and vv=='[FFBBD2]'): regs.pop('r4',None) if regs.get('r4')=='[PAGE]' and dst=='r4h' and vv!='[FFBBD1]' else None
                if dst=='r4' and vv=='[FFBBC2]': regs['r4']='[IDX]'
            elif m in ('mov.l','mov.w','mov.b') and op.startswith('#'):
                v,dst=op[1:].split(','); regs=dict(regs); regs[dst]=v
            elif m.startswith('cmp'):
                c,r=op.split(','); regs=dict(regs); regs['__cmp']=(regs.get(r, r), c.lstrip('#'))
            elif m in ('sub.w','add.w') and op.startswith('#'):
                c,r=op.split(','); regs=dict(regs); regs[r]="%s%s%s"%(regs.get(r,r),'-' if m=='sub.w' else '+',c[1:])
            elif m=='btst':
                mo=re.match(r"#0x([0-9a-f]+),(.*)",op)
                if mo: regs=dict(regs); regs['__cmp']=(var(mo.group(2))+".b%d"%int(mo.group(1),16),'bit')
            elif m in ('dec.w','inc.w','dec.b'):
                pass
            if m in ('rts','rte'):
                if stack: a=stack[-1]; stack=stack[:-1]; continue
                res.append((conds,"rts")); npaths[0]+=1; return
            if m in ('jsr','jmp','bsr') or (m in ('bra',) and False):
                ma=re.match(r"@(0x[0-9a-f]+):24",op)
                mb=TGT.search(op)
                tg = int(ma.group(1),16) if ma else (int(mb.group(1),16) if (m=='bsr' and mb) else None)
                if tg is None:
                    res.append((conds,"%s @er6 (er6=%s)"%(m,regs.get('er6','?')))); npaths[0]+=1
                    if m=='jmp': return
                    a+=n; continue
                if tg in HELP:
                    res.append((conds,"idxdisp(limit=%d,table=%s)"%(HELP[tg],regs.get('er6','?')))); npaths[0]+=1
                    if m=='jmp': return
                    a+=n; continue
                if tg==0x28CBC:
                    res.append((conds,"record(%s)"%regs.get('er1','?'))); npaths[0]+=1; return
                if tg==0x3FFA0:
                    res.append((conds,"softkey_clear")); npaths[0]+=1
                    if m=='jmp': return
                    a+=n; continue
                # local small helper inline? only if within 0x80 bytes and bsr
                res.append((conds,"%s %06X"%(m,tg))); npaths[0]+=1
                if m=='jmp': return
                a+=n; continue
            mm=TGT.search(op)
            if m in ('bra','bra/s') and mm:
                tg=int(mm.group(1),16)
                if tg==0x28CBC:
                    res.append((conds,"record(%s)"%regs.get('er1','?'))); npaths[0]+=1; return
                a=tg; continue
            if m in BOPS and mm:
                tg=int(mm.group(1),16)
                cv=regs.get('__cmp',('?','?'))
                def f(pos):
                    o=BOPS[m][0 if pos else 1]
                    if cv[1]=='bit': return "%s=%s"%(cv[0],'0' if o=='==' else '1')
                    return "%s%s%s"%(cv[0],o,cv[1])
                if depth<40:
                    go(tg, conds+[f(True)], regs, depth+1, stack)
                conds=conds+[f(False)]; a+=n; continue
            a+=n
        res.append((conds,"steplimit")); npaths[0]+=1
    go(root,[],{},0,())
    return res

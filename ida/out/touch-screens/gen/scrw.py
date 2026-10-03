import sys, re; sys.path.insert(0,'.')
from closure import *
UNOPENED=set(int(x,16) for x in "0x0E 0x10 0x11 0x17 0x22 0x29 0x2A 0x2D 0x2E 0x30 0x32 0x33 0x34 0x36 0x3E 0x41 0x49 0x4C 0x5C 0x61 0x65 0x67 0x6E 0x77 0x78 0x7B 0x80 0x81 0x97 0xB9 0xD4 0xD5 0x08 0x19 0x21 0x23 0x24 0x25 0x2F 0x31 0x38 0x3A 0x3B 0x3C 0x3D 0x42 0x46 0x47 0x48 0x50 0x53 0x54 0x69 0x74 0x75 0x79 0x7E 0x83 0x86 0x8A 0xAA 0xAD 0xAF 0xB0 0xB6 0xBA 0xD8 0xD9 0xDA".split())
assert len(UNOPENED)==69
PUSH={0x3FF10:'push',0x3FF02:'push90F0',0x3FEFC:'push(3FEFC)',0x3FF1E:'push(3FF1E)',0x148A0:'direct_entry',0x14C72:'push(14C72)',0x3FF3A:'pop',0x14AF4:'enter_group(FF8F2E)',0x14B7E:'enter_subgroup_row',0x14C90:'row_lookup(14C90)'}
# order of insns
ADDRS=sorted(a for a in BU)
import bisect
def prev_insns(a,k=10):
    i=bisect.bisect_left(ADDRS,a); out=[]
    j=i-1
    while j>=0 and len(out)<k:
        b=ADDRS[j]
        if b+BU[b][0]==(out[-1][0] if out else a): out.append((b,BU[b][1])); 
        else:
            # find exact predecessor by length
            pass
        j-=1
        if j< i-40: break
    return out
def lin_prev(a,k=10):
    # walk back assuming contiguous decode: find b with b+len==a
    out=[]; cur=a
    for _ in range(k):
        found=None
        for d in range(2,11,2):
            b=cur-d
            if b in BU and BU[b][0]==d: found=b; break
        if found is None: break
        out.append((found,BU[found][1])); cur=found
    return out
def src_r3l(a, reg='r3l'):
    for b,t in lin_prev(a,8):
        m=re.match(r"mov\.b #0x([0-9a-f]+),%s$"%reg,t)
        if m: return int(m.group(1),16), "%06X"%b
        if re.search(r",%s$"%reg,t) or re.search(r",e?r3$|,er3$",t): return None, "%06X:%s"%(b,t)
        if t.split()[0] in ('rts','bra','jmp','jsr','bsr') : return None, "block-start"
    return None,"?"
def screen_writes(insset):
    out=[]
    for a in sorted(insset):
        t=BU[a][1]
        m=re.match(r"mov\.b (r\d[lh]),@\(0x1:16,er(\d)\)$",t)
        if m:
            v,s=src_r3l(a,m.group(1)); out.append((a,'store@(1,er%s)'%m.group(2),v,s)); continue
        mj=re.match(r"(jsr|jmp) @(0x[0-9a-f]+):24",t)
        mb=re.search(r"^(bsr|bra) .*\((0x[0-9a-f]+)\)$",t)
        tg=int(mj.group(2),16) if mj else (int(mb.group(2),16) if mb else None)
        if tg in PUSH:
            v,s=(None,'-') if PUSH[tg] in ('pop','enter_group(FF8F2E)','enter_subgroup_row','row_lookup(14C90)') else src_r3l(a,'r3l')
            out.append((a,PUSH[tg],v,s))
    return out

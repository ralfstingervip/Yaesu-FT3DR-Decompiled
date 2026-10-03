r"""N8 byte-check. Re-asserts every byte citation in docs\deep\135-jsr0.md
against the SUB image. SUB base 0xFFC00000, file offset = addr - base, little-endian.
Run: python ida\out\jsr0\bytecheck.py  (expects CWD = workspace root)"""
import sys
import hashlib, sys
sys.exit('The firmware image is not in this repository.')
BASE=0xFFC00000
SHA="b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230"
def fo(a): return a-BASE
def b(a,n): return IMG[fo(a):fo(a)+n]
def u32(a): return int.from_bytes(b(a,4),'little')
ok=True
def chk(cond,msg):
    global ok
    print(("PASS " if cond else "FAIL ")+msg); ok = ok and cond
chk(hashlib.sha256(IMG).hexdigest()==SHA,"SUB sha256")
# the two jsr-0 sites
chk(b(0xFFEE2220,4).hex()=="66037f13","FFEE2220 = 66 03 7f 13 (mov.l #0,r3 ; jsr r3)")
chk(b(0xFFEE223B,4).hex()=="66037f13","FFEE223B = 66 03 7f 13 (mov.l #0,r3 ; jsr r3)")
# enclosing-function key bytes
chk(b(0xFFEE2208,6).hex()=="fb22238c0000","FFEE2208 mov.l #8C23h,r2")
chk(b(0xFFEE221C,2).hex()=="e332","FFEE221C mov.l r2,[r3]")
chk(b(0xFFEE221E,2).hex()=="ef32","FFEE221E mov.l r3,r2")
chk(b(0xFFEE2237,2).hex()=="e332","FFEE2237 mov.l r2,[r3]")
# caller bsr sites
chk(b(0xFFEE19C0,4).hex()=="05480800","FFEE19C0 bsr.a sub_FFEE2208")
chk(b(0xFFEE1A21,4).hex()=="05040800","FFEE1A21 bsr.a sub_FFEE2225")
# DTBL triples (src,end,dst) at FFED8A34 - none covers 0x0..0x3
dt=[(u32(0xFFED8A34+12*i),u32(0xFFED8A34+12*i+4),u32(0xFFED8A34+12*i+8)) for i in range(3)]
covers0=any(d<=0<d+(e-s) for s,e,d in dt)
chk(not covers0,"DTBL: no .data copy covers RAM 0x0..0x3")
# BTBL ranges at FFED8A58..FFED8A70 - lowest starts at 0x4
bt=[(u32(0xFFED8A58+8*i),u32(0xFFED8A58+8*i+4)) for i in range(3)]
lowest=min(s for s,e in bt)
chk(lowest==0x00000004,"BTBL lowest clear range starts at 0x4 (0x0..0x3 never zeroed)")
# no store-through-zero-base idiom (66 0N then C3/CB/E3 with base==N)
cnt=0
for i in range(len(IMG)-3):
    if IMG[i]==0x66 and (IMG[i+1]>>4)==0:
        rn=IMG[i+1]&0xF
        if IMG[i+2] in (0xC3,0xCB,0xE3) and (IMG[i+3]>>4)==rn: cnt+=1
chk(cnt==0,"no mov.l #0,rN ; store [rN] idiom anywhere (writers of addr 0 = 0)")
print("\nRESULT:", "ALL PASS" if ok else "FAILURES")
sys.exit(0 if ok else 1)

import sys
import re,sys
sys.exit('The firmware image is not in this repository.')
def refs(t):
    tb=t.to_bytes(4,'big'); r=[]
    for m in re.finditer(re.escape(b'\x5e'+tb[1:]),IMG): r.append(("jsr",m.start()))
    for m in re.finditer(re.escape(b'\x5a'+tb[1:]),IMG): r.append(("jmp",m.start()))
    for m in re.finditer(re.escape(tb),IMG): r.append(("be32",m.start()))
    for a in range(0x400,0x7B754,2):
        if IMG[a] in (0x55,0x40) or (0x41<=IMG[a]<=0x4f):
            d=IMG[a+1]; d=d-256 if d>127 else d
            if a+2+d==t: r.append(("bsr" if IMG[a]==0x55 else "b%02x"%IMG[a],a))
        if IMG[a]==0x5c and IMG[a+1]==0 or (IMG[a]==0x58 and IMG[a+1]&0xf==0):
            d=int.from_bytes(IMG[a+2:a+4],'big',signed=True)
            if a+4+d==t: r.append(("bsr16" if IMG[a]==0x5c else "b16",a))
    return r
if __name__=="__main__":
    for x in sys.argv[1:]:
        print(x,[(k,hex(a)) for k,a in refs(int(x,16))])

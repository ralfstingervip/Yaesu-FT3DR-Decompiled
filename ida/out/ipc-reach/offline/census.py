import re,pickle,collections,bisect
from bu import BU,IMG
from refs import refs
visited,tabs=pickle.load(open("rd.pkl","rb"))
HI=0x7B754
# 1) all opcode stores
stores=[]
for m in re.finditer(rb"\x6b[\xa0-\xaf]\x00\xff\x3d\x74",IMG[:HI]):
    a=m.start(); reg=IMG[a+1]&0xf
    stores.append((a,reg))
def prev_imm(a,reg,maxback=12):
    # look for mov.w #imm,reg (79 0r ii ii) at a-4, a-4-k... linear backward using bu heads
    for back in range(2,maxback*6,2):
        p=a-back
        if IMG[p]==0x79 and IMG[p+1]==reg and BU.get(p,(0,))[0]==4:
            # ensure contiguous decode from p to a
            q=p
            while q<a: q+=BU[q][0]
            if q==a: return int.from_bytes(IMG[p+2:p+4],'big'),p
    return None,None
rows=[]
gen=[]
for a,reg in stores:
    v,p=prev_imm(a,reg,4)
    if reg in (4,12) and v is not None:
        rows.append((a,"%04X"%v,"imm",p))
    else:
        rows.append((a,None,"reg%d"%reg,None))
for r in rows: 
    if r[1] is None: print("UNRES store %06X %s %s"%(r[0],r[2],BU[r[0]][1]))
pickle.dump(rows,open("stores.pkl","wb"))
print(len(rows),"stores", sum(1 for r in rows if r[1]))

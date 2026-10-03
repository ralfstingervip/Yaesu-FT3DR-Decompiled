import pickle
from bu import BU,IMG
from refs import refs
visited,tabs=pickle.load(open("rd.pkl","rb"))
SENDERS=[0x976A,0x9792,0x97DC,0x9834,0x98CA,0x9922,0x997A,0x99DE,0x9A1A,0x9A54,0x9BDA,0x9C16,0x9C52]
# verify each sender's head: does it start a few bytes before the e3 store
out=[];unres=[]
def resolve(site):
    for back in range(2,40,2):
        p=site-back
        if IMG[p]==0x79 and IMG[p+1]==0x0b and BU.get(p,(0,))[0]==4:
            q=p
            while q<site: q+=BU[q][0]
            if q==site:
                # ensure no intervening write to e3/er3 (mov.l ...,er3 / 0f/7a 03)
                return int.from_bytes(IMG[p+2:p+4],'big'),p
        # stop at rts / unconditional branch
        n,t=BU.get(p,(0,""))
        if t.startswith("rts") or t.startswith("bra") or t.startswith("jmp"):
            q=p+n
            if q<=site: break
    return None,None
for s in SENDERS:
    for k,a in refs(s):
        if k not in("jsr","jmp","bsr","bsr16","b16","b40") and not k.startswith("b"): 
            out.append((s,k,a,None,None,False)); continue
        v,p=resolve(a)
        out.append((s,k,a,v,p,a in visited))
pickle.dump(out,open("e3.pkl","wb"))
for s,k,a,v,p,live in out:
    print("%06X\t%s\t%06X\t%s\t%s\t%s"%(s,k,a,"%04X"%v if v is not None else "?", "%06X"%p if p else "-", "live" if live else "NOTREACHED"))

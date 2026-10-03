# H1: who reaches the four F1 "+2" rows? Read-only; uses G1's offline helpers and binutils oracle table.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys; sys.path.insert(0,(REPO + "/ida/out/h8s-decode/offline"))
from rd import *
import re
ROWS=[(0x034642,0x034674),(0x038102,0x038160),(0x04F3A2,0x04F3DE),(0x06AC12,0x06AC3A),(0x04DE6E,0x04DEE2),(0x04DF72,0x04E010)]
TG=re.compile(r"(0x[0-9a-f]+)")
refs={}
for a in range(0,HI,2):
    n,t,k,tg=flow(a)
    for x in tg: refs.setdefault(x,[]).append((a,t))
for s,e in ROWS:
    print("== row",hex(s),hex(e), "bytes", IMG[s:s+8].hex(), "| at+2", IMG[s+2:s+8].hex())
    for x in range(s-0x50,e,2):
        if x in refs: print("   target %06X <- %s"%(x,", ".join("%06X:%s"%(a,t) for a,t in refs[x][:6])))
    # BE32/BE24 occurrences of start and start+2
    for v in (s,s+2,s-0x40):
        pass
for v in (0x034644,0x034642,0x038104,0x038102,0x04F3A4,0x04F3A2,0x06AC14,0x06AC12,0x04DE6E,0x04DE94,0x04DF72,0x04DF98):
    b4=v.to_bytes(4,"big"); b3=v.to_bytes(3,"big")
    o4=[i for i in range(0,HI-3) if IMG[i:i+4]==b4]
    o3=[i for i in range(0,HI-2) if IMG[i:i+3]==b3]
    print("%06X be32@%s be24@%s"%(v,[hex(i) for i in o4][:8],[hex(i) for i in o3][:8]))

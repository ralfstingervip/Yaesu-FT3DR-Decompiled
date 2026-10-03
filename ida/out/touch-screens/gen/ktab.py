import sys; sys.path.insert(0,'.')
from k3lib import *
def slot_of(A):
    ph = 20 if A < 0x125D4 else 12
    return ((A-ph)%68)//4, A-((A-ph)%68)
# screen ids whose 0x125D4 key table contains A
SCRK={}
for s in range(1,0xEF):
    b=0x125D4+be16(0x1208C+2*(s-1)); SCRK.setdefault(b,[]).append(s)
def screens_for(A):
    sl,base=slot_of(A)
    return sl,base,SCRK.get(base,[])

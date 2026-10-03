# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
# Lane L6 offline helpers (read-only). Reuses G1's per-address H8SX oracle (bu_all.tsv) and K1's final4 masks.
import sys, re, bisect
sys.dont_write_bytecode = True
R = (str(_REPO / "ida/out") + "/")
IMG = open(_no_image(),"rb").read()
BU = {}
for ln in open(R+"h8s-decode/work/bu_all.tsv",encoding="utf-8"):
    a,n,t = ln.rstrip("\n").split("\t",2); BU[int(a,16)] = (int(n), t.replace("\t"," ").strip())
PROVEN = open(R+"main-final4/final4_proven_mask.bin","rb").read()
NAMED = open(R+"main-final4/final4_named_mask.bin","rb").read()
def proven(a): return PROVEN[a] if a < len(PROVEN) else 0
def be32(a): return int.from_bytes(IMG[a:a+4],"big")
def be16(a): return int.from_bytes(IMG[a:a+2],"big")
def hx(a,n): return IMG[a:a+n].hex(" ")
def dis(a, e=None, n=None):
    out=[]; c=0
    while (e is None or a<e) and (n is None or c<n):
        l,t = BU.get(a,(2,".word"))
        if l==0: l=2
        out.append("%06X %-24s %s" % (a, IMG[a:a+l].hex(" "), t)); a+=l; c+=1
    return out
TGT = re.compile(r"\((0x[0-9a-f]+)\)\s*$")
CW = (0x078106, 0x07B754)
def okcode(a): return 0x400<=a<0x80000 and not (CW[0]<=a<CW[1]) and BU.get(a,(0,''))[0]>0 and not BU[a][1].startswith('.word')
HELP = {0x2853E:3,0x28562:4,0x28586:5,0x285AA:6,0x285CE:7,0x285F2:8,0x28616:9,0x2863A:0xA,0x2865E:0xB,0x28682:0x13,0x286A6:0x17}
SOFTKEY = 0x3FFA0
PASSER = {0x28B62:0x28B6C,0x28BAA:0x28BB4,0x28BE6:0x28BF0,0x28C20:0x28C2A,0x28C5A:0x28C62,0x28C82:0x28C8A,0x296DE:0x296E8,0x29708:0x29712}
HOME = [0x1109C+0x44*i for i in range(60)]
def home_n(b): return (b-0x1109C)//0x44
def scr_kt(s): return 0x125D4 + be16(0x1208C+2*(s-1))

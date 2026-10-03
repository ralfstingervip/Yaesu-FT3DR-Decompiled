# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
import struct, collections, os
P = _no_image()
d = open(P, "rb").read(); BASE=0xFFC00000; N=len(d)
def off(a): return a-BASE
# widen ptr range to capture bitmaps stored in the RES tail above 0xFFE80000 too
BM_LO, BM_HI = 0xFFC3E000, 0xFFEC0000
def rec_at(a):
    b=d[off(a):off(a)+16]
    if len(b)<16: return None
    w,h=struct.unpack_from("<HH",b,0); ptr=struct.unpack_from("<I",b,4)[0]
    pad,col=struct.unpack_from("<HH",b,8); flag=struct.unpack_from("<I",b,12)[0]
    if 1<=w<=400 and 1<=h<=400 and BM_LO<=ptr<BM_HI: return (w,h,ptr,pad,col,flag)
    return None

# find full extent from an interior anchor
anchor=0xFFECFDCC
s=anchor
while rec_at(s-16): s-=16
e=anchor
while rec_at(e): e+=16
NREC=(e-s)//16
print("full table: %08X..%08X  records=%d (file %06X..%06X)"%(s,e,NREC,off(s),off(e)))
recs=[rec_at(s+i*16) for i in range(NREC)]

byptr=collections.OrderedDict()
for w,h,ptr,pad,col,flag in recs: byptr.setdefault(ptr,(w,h))
ivs=sorted((ptr,ptr+w*h*2) for ptr,(w,h) in byptr.items())
merged=[]
for a,b in ivs:
    if merged and a<=merged[-1][1]: merged[-1]=(merged[-1][0],max(merged[-1][1],b))
    else: merged.append((a,b))
covered=sum(b-a for a,b in merged)
print("records=%d distinct images=%d"%(len(recs),len(byptr)))
print("pixel span %08X..%08X  covered=%d bytes"%(ivs[0][0],merged[-1][1],covered))
print("gaps in span:",sum(1 for i in range(len(merged)-1)),"merged intervals=%d"%len(merged))
# how many images live ABOVE 0xFFE80000 (my region)?
above=[(p,wh) for p,wh in byptr.items() if p>=0xFFE80000]
print("distinct images with pixels above 0xFFE80000:",len(above),"max end=%08X"%max(p+w*h*2 for p,(w,h) in byptr.items()))

# dimension histogram
dims=collections.Counter((w,h) for p,(w,h) in byptr.items())
print("\ndistinct sizes=%d ; top:"%len(dims))
for (w,h),c in dims.most_common(24): print("   %3dx%-3d x%-3d %d B"%(w,h,c,w*h*2))
big=sorted(byptr.items(),key=lambda kv:-kv[1][0]*kv[1][1])[:12]
print("largest:")
for p,(w,h) in big: print("   %08X %3dx%-3d %dB"%(p,w,h,w*h*2))
# color/flag
print("flags:",collections.Counter(r[5] for r in recs))
print("colors:",collections.Counter(r[4] for r in recs).most_common(6))

# check for OTHER tables anywhere (scan whole image, exclude this one)
print("\n=== other descriptor tables (>=6 recs, outside main) ===")
seen=set(range(off(s),off(e)))
found=[]; pos=0
while pos<N-16:
    a=BASE+pos
    if pos in seen: pos+=16; continue
    if rec_at(a):
        c=a; run=0
        while rec_at(c): run+=1; c+=16
        if run>=6:
            found.append((a,run));
            for q in range(off(a),off(c)): seen.add(q)
            pos=off(c); continue
    pos+=2
for a,r in found[:20]: print("   %08X recs=%d"%(a,r))
print("   (count:",len(found),")")

# write full catalogue
outdir=str(_REPO / "ida/out/sub-upper"); os.makedirs(outdir,exist_ok=True)
with open(os.path.join(outdir,"bitmap_catalogue.tsv"),"w",encoding="utf-8",newline="\n") as fh:
    fh.write("rec\tdesc_ea\tw\th\tpixel_ptr\tpixel_file_off\tpad\tcolor_rgb565\tflag\tbytes_wh2\n")
    for i,(w,h,ptr,pad,col,flag) in enumerate(recs):
        fh.write("%d\t%08X\t%d\t%d\t%08X\t%06X\t%04X\t%04X\t%08X\t%d\n"%(i,s+i*16,w,h,ptr,(ptr-BASE)&0xFFFFFF,pad,col,flag,w*h*2))
print("wrote bitmap_catalogue.tsv rows=%d"%len(recs))

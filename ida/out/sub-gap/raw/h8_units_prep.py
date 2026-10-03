# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
# Lane H8: attribute reached heads (reach.tsv) to owner units -> units.tsv. Run with cwd = ida\out\sub-gap\raw, after h8_closure.py, before h8_units.py.
import collections, bisect, sys
B=0xFFC00000
img=open(_no_image(),'rb').read()
F=[l.rstrip('\n').split('\t') for l in open(str(_REPO / "ida/out/sub-window/functions.tsv"))][1:]
F=[(int(r[0],16),int(r[1],16),r[2]) for r in F if r[2] in('xref','body')]
F.sort(); starts=[f[0] for f in F]
def vfunc(ea):
  i=bisect.bisect_right(starts,ea)-1
  if i>=0 and F[i][0]<=ea<F[i][1]: return F[i][0]
  return None
R={int(r[0],16):r for r in (l.rstrip('\n').split('\t') for l in list(open('reach.tsv',encoding='utf-8'))[1:])}
def iscall(src):
  o=src-B; b=img[o]
  return b in (0x05,0x39) or (b==0x7F and (img[o+1]&0xF0)==0x10)
owner={}
def calltgt(src):
  o=src-B; b=img[o]
  if b==0x05:
    d=int.from_bytes(img[o+1:o+4],'little'); d=d-(1<<24) if d&0x800000 else d; return src+d
  if b==0x39: return src+int.from_bytes(img[o+1:o+3],'little',signed=True)
  return None
def own(ea):
  if ea in owner: return owner[ea]
  r=R[ea]; src=int(r[2],16); k=r[3]
  if r[4]=='T1-vector': o=('NEW',ea,'vector')
  elif k.startswith('ptr'): o=('NEW',ea,'pointer')
  elif k in('call','xref') and calltgt(src)==ea: o=('NEW',ea,'call')
  elif src in R and 'INVALID' not in R[src][4]: o=own(src)
  else:
    v=vfunc(src); o=('EXT',v,k) if v else ('?',src,k)
  owner[ea]=o; return o
import sys; sys.setrecursionlimit(100000)
for ea in sorted(R):
  if 'INVALID' in R[ea][4]: continue
  own(ea)
units=collections.defaultdict(list)
for ea,o in owner.items(): units[o].append(ea)
c=collections.Counter(o[0] for o in units)
print(c)
print(collections.Counter((o[0],o[2]) for o in units))
with open('units.tsv','w',encoding='utf-8',newline='\n') as h:
  for o,heads in sorted(units.items(), key=lambda x:min(x[1])):
    hs=[e for e in sorted(heads) if R[e][6]!='tail']
    if not hs: continue
    h.write('%s\t%s\t%s\t%s\n'%(o[0],'%08X'%o[1],o[2],','.join('%08X'%e for e in hs)))

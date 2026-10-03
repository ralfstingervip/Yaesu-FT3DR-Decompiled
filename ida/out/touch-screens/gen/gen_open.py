# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
import sys, re; sys.path.insert(0,'.')
from dclos import *
from scrw import lin_prev
OUT=(str(_REPO / "ida/out/touch-screens") + "/")
Z=[l.rstrip('\n').split('\t') for l in open(OUT+"zones.tsv",encoding='utf-8') if not l.startswith('#')][1:]
roots={}
# slot-10 roots
for b in KT:
    roots.setdefault(be32(b+40),set()).add("slot10 of kt%05X"%b)
# virtual-key slot handlers resolved in zones.tsv
for r in Z:
    for m in re.finditer(r"scr([0-9A-F]{2}) kt([0-9A-F]{5}) slot(\d+)=>([0-9A-F]{6})",r[12]):
        roots.setdefault(int(m.group(4),16),set()).add("vkey slot%s of scr%s"%(m.group(3),m.group(1)))
# record fields
for rec in (0x28B6C,0x28BB4,0x28BF0,0x28C2A,0x28C62,0x28C8A,0x296E8,0x29712):
    for o in (0,4,8,0xC,0x14,0x18,0x1C):
        v=be32(rec+o)
        if v: roots.setdefault(v,set()).add("rec%05X+%02X"%(rec,o))
roots.pop(0x3FFA0,None)
D=4
best,unres=dclosure(set(roots),D)
sw=screen_writes(set(best))
def recclass(a,k):
    m=re.match(r"store@\(1,er(\d)\)",k)
    if not m: return "push-family"
    n=m.group(1)
    if n=='0': return "band-record (er0)"
    for b in range(a-0x30,a,2):
        t=BU.get(b,(0,''))[1]
        if re.search(r"(@0x812a:16|#0xff8ee0|#0xff8fe8|#0xff90f0|#0xff9190|#0xff922c),er%s$"%n,t) or t=="mov.l er0,er%s"%n:
            return "band-record (er%s=%s)"%(n,t)
    if 0x3FF00<=a<0x3FFA0: return "push helper (er%s record arg)"%n
    return "non-record struct/string buffer (er%s)"%n
SRC={}
for a in (0x2CA98,0x2D0F6,0x2D4EA,0x2D97A,0x2DD5C,0x2E10C,0x3387E,0x33BC4): SRC[a]="table 0x3BC6 (values 00/03/04 only; ids 03..07 per H13)"
for a in (0x2D5D4,0x2D658,0x2D690,0x2E1C6,0x2E22C,0x2E264,0x33F58,0x33F9C,0x33FC4,0x24E64,0x3FF6E): SRC[a]="restore previous screen (+0 -> +1)"
for a in (0x237B6,0x239B6,0x23A08,0x23A78,0x23AA4,0x2589A,0x2EB3A,0x3FF94): SRC[a]="constant 0x00 (r4l=0 two insns earlier)"
for a in (0x29880,0x29898): SRC[a]="restore of saved screen pair (word popped from stack)"
for a in (0x3FF18,0x3FF26): SRC[a]="push helper body (id = caller r3l; callers listed separately)"
for a in (0x14B22,0x14B28,0x14B90,0x14B96,0x14C80,0x14C86,0x14B10,0x14B7E,0x15E58): SRC[a]="row code from row tables 0x1515C-0x151EB via sub_14C90 (no id of the 69 in those 144 bytes)"
SRC[0x148B8]="direct-entry sub_148A0 body (id = caller r3l; the 13 callers carry 26 28 2B 39 40 52 6C 72 7F 8C B1)"
SRC[0x29A8C]="row code from row tables, cursor from touch (bounded by sub_2C030)"
SRC[0x6FD66]="[FFADA1] (writer not found; H13 Open 1)"
for a in (0x14BC8,0x14BCC,0x15968,0x1FAE2,0x23AB6,0x24468,0x24E22,0x24E38,0x2579C,0x257AE,0x25844,0x291B4,0x2988A): SRC[a]="pop -> previous screen"
SRC[0x298D2]="group cursor = touch idx-1 (0..11)"; SRC[0x29A86]="sub-group = touch idx-5 (0..2)"
SPECIAL={0x298D2:"touch idx 1..12 (table 0x27E0C) -> [FF8F2E]=idx-1 (0..11) -> sub_14AF4 enter group: group1 -> push 0x0D, else push row code of group cursor (row tables). Hidden group 13 (index 12) cannot be selected by touch.",
         0x29A8C:"touch idx 5..10 -> sub_2C030 bounded cursor (< per-group count) -> row-table byte -> screen id. Row tables 0x1515C-0x151EB hold none of the 69.",
         0x29A86:"touch idx 5..7 -> [FF8F4F]=idx-5 (0..2) -> sub_14B7E enter sub-group row (row tables).",
         0x6FD66:"screen := [FFADA1]; this handler fills every slot of screen 0x86's key table (0x1353C), and 0x86 is itself one of the 69 (never current), so not reachable by touch in practice."}
rows=["site\tkind\tclass\tvalue\tvalue_src\tdepth\tin_69\troot_examples\tnote"]
ids=set()
for a,k,v,s in sw:
    cl=recclass(a,k)
    in69 = ("YES" if v in UNOPENED else "no") if v is not None else "-"
    if cl.startswith("non-record"): in69="n/a"
    if v is not None and not cl.startswith("non-record"): ids.add(v)
    rows.append("	".join(["%06X"%a,k,cl,("0x%02X"%v) if v is not None else "computed",s if v is not None else SRC.get(a,s),str(best[a]),in69,";".join(sorted(roots.get(a,[])))[:120],SPECIAL.get(a,"")]))
open(OUT+"screen-opens-by-touch.tsv","w",encoding="utf-8",newline="\n").write(
"# Lane K3. Screen-change sites reached from touch roots: %d slot-10 handlers (all 191 key tables), virtual-key slot handlers of page-mapped screens, and the 8 records' fields; depth-bounded descent D=%d calls (helper idx-dispatch tables, jump tables and record fields followed). %d instructions reached.\n# kind: store@(1,erN) = screen-byte store; push/direct_entry/pop/enter_* = screen API calls (sub_3FF10, 3FF02, 3FEFC, 3FF1E, 148A0, 14C72, 3FF3A, 14AF4, 14B7E, 14C90). in_69 = constant id is one of the 69 unopened ids (docs 49/58).\n# Constant ids reached (record/push class): %s. Intersection with the 69: %s.\n"%(len(roots),D,len(best)," ".join("%02X"%i for i in sorted(ids)), " ".join("%02X"%i for i in sorted(ids&UNOPENED)) or "none")+"\n".join(rows)+"\n")
print(len(roots), len(best), "ids", sorted("%02X"%i for i in ids), "in69", sorted(ids&UNOPENED), "unres", len(unres))

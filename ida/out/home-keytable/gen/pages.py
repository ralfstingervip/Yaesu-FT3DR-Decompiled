# Lane L6. Page families: B3EA state -> page emitters for the A9F9=9 render table 0x061C5A and the A9F9=8/10
# render table 0x0669E0, by a depth-3 call closure from each state handler to H5's emitter sites
# (ida\out\ipc-reach\main-sites.tsv). Also carries H5's own reach-chain slot (Confirmed site) and the SUB
# screen + SUB strings harvested by ida\jobs\l6_sub_strings.py. Read-only.
import sys, re, collections
sys.path.insert(0, '.')
from l6lib import *

OUT = R + "home-keytable/"
sites = collections.defaultdict(set); chain_slot = collections.defaultdict(set)
for ln in open(R + "ipc-reach/main-sites.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split('\t')
    if len(c) < 5: continue
    sites[int(c[1], 16)].add(c[0])
    for m in re.finditer(r"tab(061C5A|0669E0)@[0-9A-F]+@([0-9A-F]+)", c[4]):
        chain_slot[c[0]].add((m.group(1), (int(m.group(2), 16) - int(m.group(1), 16)) // 4))


def closure_pages(root, maxdepth=3):
    seen = set(); hits = set(); work = [(root, 0)]
    while work:
        a, d = work.pop()
        while okcode(a):
            if a in seen: break
            seen.add(a)
            if a in sites: hits |= sites[a]
            n, t = BU[a]; p = t.split(' ', 1); m = p[0]; op = p[1] if len(p) > 1 else ''
            if m in ('rts', 'rte'): break
            if m in ('jsr', 'jmp'):
                ma = re.match(r"@(0x[0-9a-f]+):24", op)
                if ma and d < maxdepth: work.append((int(ma.group(1), 16), d + 1))
                if m == 'jmp': break
                a += n; continue
            mm = TGT.search(op)
            if m == 'bsr' and mm and d < maxdepth: work.append((int(mm.group(1), 16), d + 1))
            elif m == 'bra' and mm: work.append((int(mm.group(1), 16), d)); break
            elif m.startswith('b') and mm and m not in ('bld', 'bst', 'bset', 'bclr', 'btst', 'bnot', 'bist', 'bor', 'band', 'bxor', 'bild', 'bior', 'biand', 'bixor', 'brn', 'bsr'):
                work.append((int(mm.group(1), 16), d))
            a += n
    return hits


# SUB info
subscr = {}; substr = collections.defaultdict(list)
for ln in open(R + "ipc-reach/opcode-matrix.tsv", encoding="utf-8").read().splitlines()[1:]:
    c = ln.split('\t')
    if len(c) > 8: subscr[c[0]] = (c[5], c[6], c[8])
try:
    for ln in open(OUT + "work/sub_strings.tsv", encoding="utf-8").read().splitlines()[1:]:
        c = ln.split('\t')
        if len(c) < 9 or c[0].startswith('#'): continue
        t = c[8]
        if sum(ch.isalpha() for ch in t) >= 3 and not re.search(r"[%$!<>=;@\\]", t):
            ent = "%s@SUB %s(file %s,d%s)" % (t.strip(), c[6], c[7], c[3])
            if ent not in substr[c[0]]: substr[c[0]].append(ent)
except FileNotFoundError:
    pass

FAM = {'F1': 'main frequency display (home)', 'F5': 'APRS (Inferred: emitted by the [A9F9]=4/5 renders 0x04AAE8/0x04B192 in the APRS code area; K3/K5 records BEACON STATUS TEXT, APRS MSG TEXT; SUB "To:"/"TEXT")',
       'F6': 'digital message / news content browser shared by A9F9=8/9/10 (Inferred: SUB "TO:", "NEW", "VOICE PLAY", ".wav"; states 0x13-0x3F common to both render tables)',
       'F7': 'mode-8/10 group screens (A9F9=8/10 states 7/8; also WIRES-X states 0x35/0x36)',
       'F8': 'WIRES-X (Confirmed by SUB strings "SEARCH & DIRECT", "LOCAL NEWS", "UPLOAD", "ADD TO CATEGORY" in the F8 screen handlers)',
       'FD': 'FD screen (AA33.0 home variant)', 'F3': 'settings item page', 'F0': 'status/UI frame'}

rows = []
st_pages = collections.defaultdict(set)
for T, a9, n in ((0x061C5A, '9', 0x45), (0x0669E0, '8,10', 0x45)):
    for s in range(n):
        h = be32(T + 4 * s)
        pg = sorted(x for x in closure_pages(h) if x[:2] in ('F1', 'F6', 'F7', 'F8'))
        for p in pg:
            st_pages[p].add((a9, s, h, 'H5chain' if ('%06X' % T, s) in chain_slot.get(p, ()) else 'closure3'))
# Home-like render dispatcher 0x0046B2 (rec+1 < 0x0C or 0xD8..0xE7): branch -> render routine; pages by depth-3 closure
STATIC = [
    ("[A9FC]!=0 (0x0046F0)", 0x52002), ("[A9F9]==10 (0x0046FC) / ==8 (0x00470E)", 0x66966), ("[A9F9]==9 (0x004702)", 0x61BE2),
    ("[A9F9]==1 (0x004708)", 0x9246), ("[94C0]==0 & [A9F9]==4 (0x00472A)", 0x4AAE8), ("[94C0]==0 & [A9F9]==5 (0x004730)", 0x4B192),
    ("[94C0]==0 & [A9F9]==3 (0x004736)", 0x5EA36), ("[BBDE]!=0 (0x00473C)", 0x8C38), ("rec+1==1 (0x004746)", 0x8C5C), ("rec+1==2 (0x00474A)", 0x8C3C),
    ("[94C1]==1 (0x004752)", 0x8CBE), ("[94C1]==5 (0x004756)", 0x53C4), ("[94C0]==1 & [BBE0].b1 (0x00475E-0x004772)", 0x8E10),
    ("[8EA9].b7 (0x004792) = screen 0x0A (pushed 0x014BD8 fb 0a / 0x014BDA)", 0x90B4),
    ("[8EA0].b4 or [8EBD].b7 (0x00479A/0x0047A2); [8EBD].b7 = screen 0x0B (0x014BE8 fb 0b)", 0x8F88),
    ("[8EA0].b7==1 (0x0047AC), [8EA6] not >0 with b1", 0x8674), ("[8EA0].b7==1, [8EA6]>0 & b1 (0x0047BC)", 0x8BA4),
    ("[8EA0].b7==0 & [AA33].b0==0 (0x0047CA)", 0x88E4), ("[8EA0].b7==0 & [AA33].b0==1 (0x0047D0)", 0xB568),
    ("rec+1==0x0D (0x0046C6) -> 0x004E36", 0x4E36), ("rec+1 in 0x0E..0xD7 (0x0046CC) -> 0x004D92", 0x4D92)]
srows = []
for cond, h in STATIC:
    for p in sorted(closure_pages(h)):
        srows.append((p, cond, h))
out = ["# Lane L6. Page -> display state. state rows: A9F9=<mode> B3EA=<state> handler, from render tables 0x061C5A (A9F9=9) / 0x0669E0 (A9F9=8,10);",
       "# evidence H5chain = H5 reach chain passes that table slot (Confirmed emitter site); closure3 = depth-3 call closure from the state handler reaches the emitter (Inferred, may over-approximate).",
       "page\tstate\trender_handler\tevidence\tsub_screen\tsub_handler\tfamily\tsub_strings"]
for p in sorted(set(list(st_pages) + [k for k in subscr if k[:2] in ('F1', 'F5', 'F6', 'F7', 'F8', 'FD') or k in ('F004', 'F301', 'F3C3')])):
    ss, sh, purpose = subscr.get(p, ('-', '-', '-'))
    fam = FAM.get(p[:2], '-')
    strs = " ; ".join(substr.get(p, [])[:8]) or '-'
    if p in st_pages:
        for a9, s, h, ev in sorted(st_pages[p], key=lambda x: (x[0], x[1])):
            out.append("\t".join([p, "A9F9=%s B3EA=0x%02X" % (a9, s), "%06X" % h, ev, ss, sh, fam, strs]))
    else:
        out.append("\t".join([p, "-", "-", "-", ss, sh, fam, strs]))
out.append("# --- home-like render dispatcher 0x0046B2: render branch -> pages it emits (depth-3 closure to H5 emitter sites; Inferred where several)")
out.append("page\trender_branch\trender_handler\tevidence\tsub_screen\tsub_handler\tfamily\tsub_strings")
for p, cond, h in sorted(srows):
    ss, sh, purpose = subscr.get(p, ('-', '-', '-'))
    out.append("\t".join([p, cond, "%06X" % h, "closure3", ss, sh, FAM.get(p[:2], '-'), " ; ".join(substr.get(p, [])[:8]) or '-']))
open(OUT + "pages.tsv", "w", encoding="utf-8", newline="\n").write("\n".join(out) + "\n")
print(len(out))

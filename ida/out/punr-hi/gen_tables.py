# M4: emit runs.tsv / proposed-demotions.tsv / proposed-rules.tsv from byte-checked evidence.
from pathlib import Path
REPO = Path(__file__).resolve().parents[3].as_posix()  # repository root
import sys, pickle
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/main-descent/offline"))
from common import IMG, HI, CW, bu, flow
from masks import A, RC, D, G1A

OUT = (REPO + "/ida/out/punr-hi/")
res = pickle.load(open("local-temp", "rb"))
R = res["full"]["reached"]; RB = bytearray(HI)
for a, (n, t, k) in R.items():
    for x in range(a, min(HI, a + n)): RB[x] = 1
PROVEN = open((REPO + "/ida/out/l-wave-recon/final6_proven_mask.bin"), "rb").read()
heads = set(); x = 0
while x < HI:
    if PROVEN[x]:
        s = x
        while x < HI and PROVEN[x]: x += 1
        p = s
        while p < x:
            n, t = bu(p)
            if n == 0: break
            heads.add(p); p += n
    else: x += 1

# whole-image inbound edge test (any kind) -> list of (src,kind)
def inbound_any(targets):
    hits = {t: [] for t in targets}
    tset = set(targets)
    for i in range(0, HI - 4):
        b0 = IMG[i]
        if 0x40 <= b0 <= 0x4f or b0 == 0x55:
            d = IMG[i+1]; tt = i + 2 + (d - 256 if d >= 128 else d)
            if tt in tset: hits[tt].append((i, "rel8", RB[i]))
        if b0 == 0x58:
            d = (IMG[i+2] << 8) | IMG[i+3]; tt = i + 2 + (d - 65536 if d >= 32768 else d)
            if tt in tset: hits[tt].append((i, "rel16", RB[i]))
        if b0 == 0x5c:
            d = (IMG[i+1] << 8) | IMG[i+2]; tt = i + 2 + (d - 65536 if d >= 32768 else d)
            if tt in tset: hits[tt].append((i, "bsr16", RB[i]))
        if b0 in (0x5e, 0x5a):
            tt = (IMG[i+1] << 16) | (IMG[i+2] << 8) | IMG[i+3]
            if tt in tset: hits[tt].append((i, "abs24", RB[i]))
        w = (IMG[i] << 24) | (IMG[i+1] << 16) | (IMG[i+2] << 8) | IMG[i+3]
        if w in tset: hits[w].append((i, "BE32ptr", RB[i]))
    return hits

RUNS = []
for ln in open((REPO + "/ida/out/l-wave-recon/proven-unreached-runs.tsv")).read().splitlines():
    if ln.startswith("#") or ln.startswith("start"): continue
    c = ln.split("\t"); s = int(c[0], 16)
    if s >= 0x058000:
        RUNS.append((s, int(c[1], 16), int(c[2]), int(c[4]), c[5]))

inb = inbound_any([s for s, e, l, w, fb in RUNS])

def addend(s, e):
    tags = []
    if any(A[x] for x in range(s, e)): tags.append("A")
    if any(RC[x] for x in range(s, e)): tags.append("RC")
    if any(D[x] for x in range(s, e)): tags.append("D")
    if any(G1A[x] for x in range(s, e)): tags.append("G1A")
    return "+".join(tags) or "NONE"

# manual classification (established in analysis; each cites why)
CLS = {
 0x078106:("WINDOW-ONLY","gated USB personality; boot jsr@78106 on (FFFF4C&7F)==7D (doc95)"),
 0x07815C:("WINDOW-ONLY","polled service; jsr@7815c only when FFB0C4>=5 (DSP-WRITE gate, doc95)"),
 0x0781AA:("WINDOW-ONLY","service body, intra-window branch targets (doc95)"),
 0x078222:("WINDOW-ONLY","SCI-C async init; jsr@78222 from DSP-WRITE gate 05DD9E (doc95)"),
 0x078260:("WINDOW-ONLY","burst to FFEE32; jsr@78260 from 07845E (doc95)"),
 0x07827A:("WINDOW-ONLY","ISR demux tail; intra-window (doc95)"),
 0x078334:("WINDOW-ONLY","ring fill; reached via jsr @er5 ring dispatch (doc95)"),
 0x07837C:("WINDOW-ONLY","ring drain; jsr@7837c from 0768BC (doc95)"),
 0x0783DA:("WINDOW-ONLY","ring move; reached via jsr @er5 (doc95)"),
 0x07842E:("WINDOW-ONLY","big-endian u16 helper (doc95)"),
 0x078442:("WINDOW-ONLY","little-endian u16 helper (doc95)"),
 0x07845A:("WINDOW-ONLY","IER/ISR arm; jsr@7845a from 078150/078212 (doc95)"),
 0x078508:("WINDOW-ONLY","queue init; jsr@78508 from 076F30 (doc95)"),
 0x05C8DC:("DEAD","WIRES-X reply-string switch arms; all bra->05C9B6, skipped by 05C8D8 bra; no inbound"),
 0x05CF34:("SPLIT-TAIL","proven boundary mid mov.l of dead B0B9 jmp@er6 dispatcher at 05CF22 (05CF20 bra skips it; no inbound)"),
 0x0605C6:("DEAD","case arm after 0605C4 bra->0605F4; no inbound"),
 0x062808:("DEAD","WIRES-X switch arms jsr@66FB4/jsr@67250; after 062806 bra->6281E; no inbound; fn has no indirect jmp"),
 0x0628FE:("DEAD","arm jsr@66FAA after 0628FC bra->062902; no inbound"),
 0x064EDE:("DEAD","lone bra.w arm after 064EDA bra; no inbound"),
 0x064EFE:("DEAD","arm jsr@64BD0 after 064EFA bra; no inbound"),
 0x06691E:("DEAD","arm jsr@1FA22;rts after 06691C bra; no inbound"),
 0x06723A:("DEAD","WIRES-X switch arm jsr@66FB4 after 067236 bra; no inbound; fn has no indirect jmp"),
 0x06AB1C:("DEAD","WIRES-X switch arms jsr@66FB4/67250/6726A/66FAA/66FBE after 06AB18 bra->06AB5A; no inbound; fn has no indirect jmp"),
 0x06ADF6:("DEAD","WIRES-X switch arms (twin of 06AB1C) after 06ADF2 bra->06AE14; no inbound; fn has no indirect jmp"),
 0x06BC56:("DEAD","reply-digit builder block after 06BC54 bra->06BCBE; no inbound"),
 0x06BE52:("DEAD","alt-length copy 0x4A from FEE000 after 06BE50 bra->06BE6E; no inbound"),
 0x06CCE8:("DEAD","jsr@3FFA0 reached only from unreached 06CCC0 bne (06CCE6 bra skips it); no live inbound"),
 0x070DAA:("DEAD","dead selector chain after 070DA8 bra->070DBA; no inbound"),
 0x070DD6:("DEAD","3 arms (ptrs 72DD8/72E6E/72F04) reached only from dead 070DAA selector; no inbound"),
}

rows = []
for s, e, l, inw, fb in RUNS:
    cls, note = CLS[s]
    ib = inb[s]
    ib_s = ";".join("%06X(%s,r%d)" % (x, k, r) for x, k, r in ib) or "none"
    reached = sum(RB[s:e])
    rows.append((s, e, l, inw, addend(s, e), cls, reached, ib_s, note, fb))

with open(OUT + "runs.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# M4 lane: 29 proven-but-unreached runs with start>=0x058000, classified. Owner-side read-only.\n")
    f.write("# inbound = any-form inbound edge whole-image (rel8/rel16/bsr16/abs24/BE32ptr), with (addr,kind,reached?) of the SOURCE.\n")
    f.write("# addend = which H9 analyze.py proven mask sets the bytes (A=validated fnindex x is_code; RC=recovered-code run; D=F1 row; G1A=binutils tier-A).\n")
    f.write("start\tend_excl\tlen\tin_window\taddend\tclass\treached_bytes\tinbound_edges\tnote\tfirst_bytes\n")
    for s, e, l, inw, ad, cls, rb, ibs, note, fb in rows:
        f.write("%06X\t%06X\t%d\t%d\t%s\t%s\t%d\t%s\t%s\t%s\n" % (s, e, l, inw, ad, cls, rb, ibs, note, fb))

# proposed demotions: the DEAD + SPLIT-TAIL below-window runs (all addend A, fnindex-only)
with open(OUT + "proposed-demotions.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# M4 PROPOSAL ONLY (masks/seeds NOT edited). Dead fnindex-validated switch-arms inside live functions, start>=0x058000, below the service window.\n")
    f.write("# Evidence: no inbound edge of any form whole-image (BE32/abs24/raw-3byte/rel8/rel16/bsr16), enclosing fn reached but these bytes not, containing fn has no indirect jmp.\n")
    f.write("start\tend_excl\tlen\taddend\tclass\tnote\n")
    tot = 0
    for s, e, l, inw, ad, cls, rb, ibs, note, fb in rows:
        if inw == 0 and cls in ("DEAD", "SPLIT-TAIL"):
            f.write("%06X\t%06X\t%d\t%s\t%s\t%s\n" % (s, e, l, ad, cls, note)); tot += l
    f.write("# total proposed demotion: %d bytes\n" % tot)

with open(OUT + "proposed-rules.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# M4 descent-rule proposals (proposals only).\n")
    f.write("rule\taction\tscope\trationale\n")
    f.write("R1-window-exclusion\tKEEP (no reach rule)\t0x078106-0x07B753 code\tThe 13 in-window runs (220 B) are the final4-proven subset of the 1088-B gated USB personality; doc95's 868 B are the complement L1 added in final5. All 1088 B are real code reached only via boot jsr@78106 on strap (FFFF4C&7F)==7D, the FF813A USB-ISR gate, and the FFB0C4>=5 DSP-WRITE gate. analyze.py zeroes RM over CW by construction, so they can never be 'reached'. Keep proven; do NOT add a descent edge (would wrongly mark the gated personality as unconditionally live).\n")
    f.write("R2-dead-switch-arms\tDEMOTE (no reach rule exists)\t16 below-window runs (530 B)\tCompiler-emitted switch/case arms and alternate-length variants inside live functions, each sitting after an unconditional bra that skips them, with NO inbound edge of any form and NO indirect jmp in the containing function. No descent rule can legitimately reach them; propose demotion from the proven mask instead.\n")
    f.write("R3-flag-leaf-overcredit\tFLAG (no edit)\t066FB4/066FBE/067250/06726A (+ off:421800 066FAA)\tThese leaf subs are reached in the with-seeds descent ONLY as fnindex function-start seeds (each preceded by rts; their sole real callers are the R2 dead arms). L4 doc101 called 066FB4/067250 REACHED 'through off_74472'; off_74472 (0x074472) points only into 0x073Axx-0x07445A, NOT these leaves or their callers. The recon restored 066FBE(10B)+06726A(26B) citing 'proven callers 06AB2A/36,06AE04/10' which R2 shows are dead. Mechanism correction; reconsider whether these leaves are live.\n")
print("wrote runs.tsv, proposed-demotions.tsv, proposed-rules.tsv")
for r in rows: print("%06X %-11s inw=%d %s %s"%(r[0],r[5],r[3],r[4],r[7]))

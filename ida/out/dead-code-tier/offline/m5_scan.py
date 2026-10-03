# Lane M5 - dead-code tier audit, offline whole-image scan. Read-only on every input.
# Inputs : image, final6 proven/named masks (l-wave-recon), binutils oracle (h8s-decode\work\bu_all.tsv),
#          M5_DEADCODE head dump (work\m5_heads.tsv, m5_idadec.tsv), L5 runs.tsv / proposed-typing.tsv
# Outputs: work\scan.json (per piece), work\scan_report.txt
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import json, sys, collections
sys.path.insert(0, (_REPO_S + "/ida/out/dead-code-tier/offline"))
from m5_lib import *

rep = []
def say(*a): rep.append(" ".join(str(x) for x in a))

# ---------- 0. data mask D: IDA non-code items + L5 residue rows typed as data/labels/cells ----------
D = bytearray(HI)
for ea, (sz, k, f, t) in heads.items():
    if k != "code":
        for i in range(ea, min(HI, ea + sz)): D[i] = 1
l5rows = 0
for l in list(open(R + r"\ida\out\main-unnamed\proposed-typing.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    a, b, typ, act = int(p[0], 16), int(p[1], 16), p[4], p[6]
    if not typ.startswith("code") and not act.startswith(("none", "create_insn", "del_items")):
        l5rows += 1
        for i in range(a, b): D[i] = 1
for a, b, _ in pieces:
    for i in range(a, b): D[i] = 0
say("data mask D bytes", sum(D), "(L5 non-code rows", l5rows, ")")

# ---------- 1. real heads ----------
CH = {ea: v[0] for ea, v in heads.items() if v[1] == "code"}
mis = [ea for ea, sz in CH.items() if bu[ea][0] != sz]
say("IDA code heads", len(CH), "oracle length disagreements", len(mis))
runs, i = [], 0
while i < HI:
    if PM[i]:
        j = i
        while j < HI and PM[j]: j += 1
        runs.append((i, j)); i = j
    else: i += 1
PH, mistile = set(), []
for a, b in runs:
    i = a
    while i < b:
        PH.add(i); i += bu[i][0]
    if i != b: mistile.append((a, b, i))
say("proven runs", len(runs), "proven heads (oracle tiling)", len(PH), "mis-tiles", len(mistile))
say("proven heads that are not IDA code heads", ["%06X %s" % (h, heads.get(h)) for h in sorted(h for h in PH if h not in CH)])
# piece heads (oracle linear decode)
PCH = {}
for a, b, _ in pieces:
    for i, ln, mn, op in lin(a, b): PCH[i] = a
REAL = set(PH) | set(h for h in CH if not D[h]) | set(PCH)

# ---------- 2. forward closure from proven code ----------
def ptr_imms(i):
    """code-pointer immediates: mov.l #imm (any width) whose value is an IDA code head or in a piece"""
    ln, mn, op = bu[i]
    out = []
    if mn == "mov.l" and op.startswith("#0x"):
        v = int(op[1:].split(",")[0], 16)
        if 0x100 <= v < HI and v % 2 == 0 and not D[v] and (v in CH or v in PCH or
                (headof[v] is None and bu[v][1] not in BAD)): out.append(v)
    return out

LIVE = {}
work = collections.deque()
for h in PH:
    LIVE[h] = ("P", "proven"); work.append(h)
CODECOV = bytearray(HI)
for h in REAL:
    if not D[h]:
        for j in range(h, min(HI, h + bu[h][0])): CODECOV[j] = 1
cells = []
for s in range(0, HI - 3, 2):
    if not CODECOV[s]:
        v = be32(s)
        if 0x100 <= v < HI and not D[v] and v % 2 == 0 and (v in CH or v in PCH or
                (headof[v] is None and bu[v][1] not in BAD)):     # also undecoded (no IDA item) code-shaped targets
            cells.append((s, v))
say("BE32 cells (even offset, not inside a real code insn) whose value is a code head or in a piece:", len(cells),
    "of which into pieces:", [("%06X" % s, "%06X" % v) for s, v in cells if pid[v] is not None])
for s, v in cells:
    if v not in LIVE:
        LIVE[v] = ("cell%06X" % s, "datacell"); work.append(v)
intodata = []
while work:
    i = work.popleft()
    if i >= HI or i < 0: continue
    ln, mn, op = bu[i]
    if mn in BAD or ln <= 0: continue
    succ = [(t, k) for k, t in targets(i)]
    succ += [(t, "imm") for t in ptr_imms(i)]
    if mn == "bra/s": succ.append((i + ln, "delayslot"))
    elif not is_term(i): succ.append((i + ln, "fall"))
    for t, k in succ:
        if not (0 <= t < HI) or t % 2: continue
        if D[t] and t not in PH:
            intodata.append(("%06X" % i, k, "%06X" % t)); continue
        if t not in LIVE:
            LIVE[t] = ("%06X" % i, k); work.append(t)
say("closure size (insn starts)", len(LIVE), "edges into data mask (not followed)", len(intodata))
live_cover = bytearray(HI)
for h in LIVE:
    for j in range(h, min(HI, h + max(bu[h][0], 1))): live_cover[j] = 1

def live_chain(h, n=12):
    out = []
    while h is not None and n:
        src, k = LIVE.get(h, (None, None))
        out.append("%06X<%s" % (h, k)); n -= 1
        if src in (None, "P") or src.startswith("cell"):
            out.append(str(src)); break
        h = int(src, 16)
    return " ".join(out)

# ---------- 3. inbound indexes ----------
CF_IN = collections.defaultdict(list)
for s in range(0, HI, 2):
    for k, t in targets(s):
        if 0 <= t < HI and pid[t] is not None: CF_IN[t].append((s, k))
BE_IN = collections.defaultdict(list)
for s in range(0, HI - 3):
    v = be32(s)
    if v < HI and pid[v] is not None: BE_IN[v].append(s)
IMM_IN = collections.defaultdict(list)
for s in REAL | set(LIVE):
    if s >= HI: continue
    ln, mn, op = bu[s]
    if mn in ("jsr", "jmp") or (mn.startswith("b") and "(" in op): continue
    for m in RX_HEX.finditer(op):
        v = int(m.group(1), 16)
        e = m.end()
        tail = op[e:e + 3]
        if tail.startswith(":8"): continue                                   # @aa:8 -> 0xFFFFFFxx
        if tail.startswith(":16") and v >= 0x8000: continue                  # abs16 / d:16 sign-extend to 0xFFFF8xxx+
        if v < HI and pid[v] is not None: IMM_IN[v].append((s, op[max(0, m.start() - 2):e + 4]))

def srcclass(s):
    if s in PH: return "P-head"
    if s in PCH: return "piece%06X-head" % PCH[s]
    if s in CH and not D[s]: return "code-head-%s" % cls(s)
    if s % 2: return "odd"
    if D[s]: return "in-data"
    h = headof[s]
    if h is not None and heads[h][1] == "code": return "mid-insn(%06X)" % h
    return "nonhead-%s" % cls(s)

def secondary(s):
    """is a non-head source offset s ever entered by a real head? returns list of real edges into s"""
    ins = []
    for k, t in [(k, t) for t2 in [s] for (x, k) in []]: pass
    for x in range(0, 0): pass
    return [(src, k) for (src, k) in CF_ALL.get(s, []) if src in REAL] + (["LIVE"] if s in LIVE else [])

CF_ALL = collections.defaultdict(list)   # filled lazily for coincidental sources only
need = set()

# ---------- 4. per piece ----------
idadec = collections.defaultdict(list)
for l in list(open(O + r"\work\m5_idadec.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    idadec[int(p[0], 16)].append((int(p[1], 16), int(p[2]), p[3]))

out = {}
for a, b, sub in pieces:
    r = {"start": a, "end": b, "len": b - a, "sub": sub}
    L = lin(a, b)
    r["insns"] = len(L)
    r["bad"] = [("%06X" % i, mn) for i, ln, mn, op in L if mn in BAD]
    r["end_exact"] = bool(L) and L[-1][0] + L[-1][1] == b
    last = L[-1]
    r["last"] = "%06X %s %s" % (last[0], last[2], last[3])
    r["last_term"] = is_term(last[0]) or (len(L) >= 2 and L[-2][2] == "bra/s")
    r["delay_slot_at_end"] = last[2] == "bra/s"
    r["next_head"] = (b in REAL) and not D[b]
    r["next_cls"] = cls(b)
    r["next_insn"] = "%06X %s %s" % (b, bu[b][1], bu[b][2])
    bounds = set(i for i, *_ in L)
    badt = []
    for i, ln, mn, op in L:
        for k, t in targets(i):
            if a <= t < b:
                if t not in bounds: badt.append(("%06X" % i, k, "%06X" % t, "mid-insn in piece"))
            elif t not in REAL or D[t]:
                badt.append(("%06X" % i, k, "%06X" % t, "outside: not a real code head (cls %s, D %d)" % (cls(t), D[t])))
    r["bad_targets"] = badt
    ida = idadec[a]
    r["ida_agree"] = [(x[0], x[1]) for x in ida] == [(i, ln) for i, ln, mn, op in L]
    r["ida_first"] = ida[0][2] if ida else ""
    r["ida_last"] = ida[-1][2] if ida else ""
    inb = []
    for t in range(a, b):
        for s, k in CF_IN.get(t, ()):
            if a <= s < b: continue
            inb.append(("cf", "%06X" % s, k, "%06X" % t, srcclass(s), s in LIVE, "%s %s" % (bu[s][1], bu[s][2])))
    for v in range(a, b):
        for s in BE_IN.get(v, ()):
            if a <= s < b: continue
            h = headof[s]
            if h is not None and heads[h][1] == "code" and not D[h] and h <= s < h + heads[h][0]:
                txt = bu[h][2]
                real = ("0x%x" % v) in txt
                src = "%s operand of %s %06X %s %s" % ("REAL" if real else "straddle", cls(h), h, bu[h][1], txt)
                lv = h in LIVE
            elif D[s]:
                src = "data cell %s @%06X (item %s %s, +%d)" % (cls(s), s, ("%06X" % h) if h is not None else "-",
                      heads[h][1] if h is not None else "-", (s - h) if h is not None else 0)
                lv = None
            elif pid[s] is not None:
                src = "inside piece %06X" % pid[s]; lv = False
            else:
                src = "no item cls %s" % cls(s); lv = False
            inb.append(("be32", "%06X" % s, "", "%06X" % v, src, lv, img[s:s + 4].hex(" ")))
    for t in range(a, b):
        pat = bytes([(t >> 16) & 0xFF, (t >> 8) & 0xFF, t & 0xFF])
        for opc in (0x5E, 0x5A):
            k = img.find(bytes([opc]) + pat, 0, HI)
            while k != -1:
                inb.append(("abs24", "%06X" % k, "%02X" % opc, "%06X" % t, srcclass(k), k in LIVE, img[k:k + 4].hex(" ")))
                k = img.find(bytes([opc]) + pat, k + 1, HI)
    for v in range(a, b):
        for s, frag in IMM_IN.get(v, ()):
            if a <= s < b: continue
            inb.append(("imm", "%06X" % s, bu[s][1], "%06X" % v, srcclass(s), s in LIVE, "%s %s" % (bu[s][1], bu[s][2])))
    ft = []
    for s in range(max(0, a - 10), a):
        if bu[s][0] > 0 and s + bu[s][0] == a and bu[s][1] not in BAD:
            ds = (s - 2 >= 0 and bu[s - 2][1] == "bra/s" and s - 2 + bu[s - 2][0] == s)
            ft.append(("%06X" % s, bu[s][1], bu[s][2], srcclass(s), s in LIVE, bool(is_term(s)), ds))
    r["fallthrough_cands"] = ft
    h = headof[a - 1] if a else None
    r["prev_item"] = ("%06X %s sz%d cls%s D%d | %s %s" % (h, heads[h][1], heads[h][0], cls(h), D[h], bu[h][1], bu[h][2])) if h is not None else "none"
    r["inbound"] = inb
    r["live_bytes"] = sum(live_cover[a:b])
    r["live_heads"] = [("%06X" % x, live_chain(x)) for x in sorted(LIVE) if a <= x < b][:4]
    out["%06X" % a] = r

# secondary check for coincidental cf/abs24 sources: is the even non-head source ever entered by a real edge?
ALLT = collections.defaultdict(list)
for s in REAL:
    for k, t in targets(s):
        ALLT[t].append(("%06X" % s, k))
    if not is_term(s) and bu[s][1] != "bra/s": ALLT[s + bu[s][0]].append(("%06X" % s, "fall"))
for k, r in out.items():
    sec = []
    for x in r["inbound"]:
        if x[0] in ("cf", "abs24") and not (x[4].startswith(("P-head", "piece", "code-head"))):
            s = int(x[1], 16)
            if s % 2 == 0:
                ent = ALLT.get(s, [])
                if ent or s in LIVE: sec.append((x[1], ent[:3], s in LIVE))
    r["coincidental_entered"] = sec

json.dump(out, open(O + r"\work\scan.json", "w", encoding="utf-8"), indent=0)
json.dump({"intodata": intodata}, open(O + r"\work\closure_intodata.json", "w", encoding="utf-8"))
open(O + r"\work\scan_report.txt", "w", encoding="utf-8").write("\n".join(rep) + "\n")
print("\n".join(rep))

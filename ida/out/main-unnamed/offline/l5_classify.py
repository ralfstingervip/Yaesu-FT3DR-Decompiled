from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: classify every MAIN unnamed-residue byte. Offline, read-only.
# Inputs: l5_lib (image, final4 masks + doc-95 868 B, IDA dump of L5_MAIN_RESIDUE), evidence.json, overrides.tsv
# Output: work\auto_rows.json, work\auto_listing.txt, work\left.json  (l5_emit.py writes the published tables)
import sys, json, re
sys.path.insert(0, str(_REPO) + r"/ida/out/main-unnamed/offline")
from l5_lib import *
ev = json.load(open(O + r"\work\evidence.json"))
TERMS = ("rts", "rte", "bra", "jmp", "rts/l", "rte/l", "bra/s")
BITOPS = ("bset", "bclr", "btst", "bnot", "bld", "bst", "bor", "band", "bxor", "biand", "bior", "bixor", "bild", "bist")
BR = re.compile(r"\(0x([0-9a-f]+)\)")
# whole-image branch/call scan from every IDA code head (any class)
brt = collections.defaultdict(list)
for h, (sz, k, t) in heads.items():
    if k != "code" or h >= HI: continue
    mn, op = bu[h][1], bu[h][2]
    tv = None
    if (mn.startswith("b") and mn not in BITOPS) or mn == "bsr":
        m = BR.search(op)
        if m: tv = int(m.group(1), 16)
    elif mn in ("jsr", "jmp"):
        m = re.search(r"@0x([0-9a-f]+):24", op)
        if m: tv = int(m.group(1), 16)
    if tv is not None and tv < HI and runid[tv] is not None and runid[h] != runid[tv]:
        brt[tv].append((h, cls(h)))


def fall_in(a):
    p = headof[a - 1] if a else None
    if p is None: return None
    sz, k, t = heads[p]
    if k != "code" or p + sz != a: return None
    if bu[p][1] in TERMS: return None
    return (p, cls(p), bu[p][1])


def edges(a, b, heads_in):
    """inbound evidence to instruction heads / run start, from outside the run"""
    S = set(heads_in) | {a}
    E = []
    for kind, t, s, tag in [e for e in ev["%06X" % runid[a]] if a <= e[1] < b]:
        if kind == "ida21": continue
        if kind.startswith("ida"):
            ty = int(kind[3:])
            if tag[:1] == "P" or (tag[:1] == "N" and ty < 16): E.append((kind, t, s, tag))
            continue
        if t not in S: continue
        if tag == "Ntab:raw":
            def ptrlike(x):
                if x < 0 or x + 4 > HI: return False
                v = struct.unpack_from(">I", img, x)[0]
                return v < HI and img[x] == 0 and img[x + 1] <= 7
            if not (s % 2 == 0 and (ptrlike(s - 4) or ptrlike(s + 4))): continue
            tag = "Ntab:ptrcell"
        if tag.startswith(("Pimm", "Nimm", "Ntab")) or (kind == "abs24" and tag.endswith("call")):
            E.append((kind, t, s, tag))
    for t in range(a, b):
        for s, c in brt.get(t, []):
            if c == "P": E.append(("branch", t, s, c + "code"))
    return E


def prt(seg): return sum(1 for x in seg if 0x20 <= x < 0x7F)


def textish(seg):
    p = prt(seg); z = sum(1 for x in seg if x in (0, 0xFF, 0x0D, 0x0A))
    alnum = sum(1 for x in seg if chr(x).isalnum())
    return p >= 3 and (p + z) >= 0.9 * len(seg) and p >= 0.6 * len(seg) and alnum >= 2 and len(set(seg)) >= 3


def lowdiv(seg):
    return len(seg) >= 8 and len(set(seg)) <= max(3, len(seg) // 6)


def rec6(seg): return len(seg) >= 6 and seg[2] == 0 and seg[3] == 0xFF


def ptr_entries(a, b):
    good = tot = 0
    i = a - (a % 2)
    for j in range(i, b - 3, 2):
        v = struct.unpack_from(">I", img, j)[0]
        tot += 1
        if v < HI and v % 2 == 0 and v in heads: good += 1
    return good, tot


OV = collections.defaultdict(list)
for l in open(O + r"\offline\overrides.tsv", encoding="utf-8"):
    if l.startswith("#") or not l.strip(): continue
    p = l.rstrip("\n").split("\t")
    OV[runid[int(p[0], 16)]].append(p)
rows = []
left = []


def add(a, b, c, sub, conf, evid, typing="", tconf=""):
    rows.append(dict(start=a, end=b, cls=c, sub=sub, conf=conf, ev=evid, typing=typing, tconf=tconf))


def fmt(E, n=4):
    return ";".join("%s %06X<%06X %s" % e for e in E[:n]) + (" (+%d more)" % (len(E) - n) if len(E) > n else "")


def classify(a, b):
    seg = img[a:b]; n = b - a
    L = lin(a, b); bad = sum(1 for x in L if x[2] == ".word"); over = L[-1][0] + L[-1][1] - b
    hin = [x[0] for x in L]
    E = edges(a, b, hin)
    hx = seg[:24].hex(" ")
    if a >= 0x078106:
        add(a, b, "closed-window interior", "window data", "Confirmed", "inside 0x078106-0x07B753; bytes %s" % hx); return True
    hp = headof[a - 1] if a else None
    if n >= 2 and a >= 4 and nm[a - 1] and nm[a - 2] and (hp is None or heads[hp][1] != "code"):
        tail = None
        if img[a - 2] == 0 and img[a - 1] == 0xFF and nm[a - 4] and nm[a - 3]:
            tail = ("record struct", "tail of 6-B record %06X {u16 %02X%02X; ptr 00FF%02X%02X}" % (a - 4, img[a - 4], img[a - 3], img[a], img[a + 1]),
                    "record %06X bytes %s: named head 4 B, residue = low half of RAM pointer 00FF%02X%02X" % (a - 4, img[a - 4:a + 2].hex(" "), img[a], img[a + 1]))
        elif a % 2 == 0 and img[a - 2] == 0 and img[a - 1] <= 0x07:
            v = struct.unpack_from(">I", img, a - 2)[0]
            if 0 < v < HI and v % 2 == 0 and v in heads and heads[v][1] == "code":
                tail = ("pointer table", "tail of BE32 pointer %06X -> %06X" % (a - 2, v),
                        "cell %06X bytes %s = %06X (IDA head %s); named head 2 B, residue = low half" % (a - 2, img[a - 2:a + 2].hex(" "), v, heads[v][1]))
        if tail:
            add(a, a + 2, tail[0], tail[1], "Confirmed", tail[2], "complete the item", "Confirmed")
            if b > a + 2 and not classify(a + 2, b): left.append((a + 2, b))
            return True
    fi = fall_in(a)
    if (fi and fi[1] == "P") and bad == 0:
        add(a, b, "reached-code gap", "fall-through from proven %06X (%s)" % (fi[0], fi[2]), "Confirmed",
            "proven %06X %s ends at %06X (no terminator); oracle at %06X = %s %s (len %d); bytes %s" % (fi[0], fi[2], a, a, L[0][2], L[0][3], L[0][1], hx),
            "code: create insn at %06X" % a, "Confirmed"); return True
    hs = set(headof[i] for i in range(a, b))
    if None not in hs and all(any(nm[j] for j in range(h, h + heads[h][0]) if not (a <= j < b)) for h in hs):
        ks = sorted(set(heads[h][1] for h in hs))
        k = ks[0] if len(ks) == 1 else "/".join(ks)
        h0 = min(hs)
        c = {"off": "pointer table", "word": "value table", "dword": "value table", "byte": "value table",
             "str": "string/label", "code": "mid-instruction/garbage"}.get(k, "Unknown")
        sub = "mask hole inside IDA %s item %06X/%d" % (k, h0, heads[h0][0])
        add(a, b, c, sub, "Confirmed", "%s; item bytes %s; run bytes %s" % (sub, img[h0:h0 + heads[h0][0]].hex(" ")[:47], hx),
            "already typed in DB (mask correction)", "Confirmed"); return True
    TXT = set(range(0x20, 0x7F)) | {0x00, 0xFF, 0x0D, 0x0A, 0x09, 0x06} | set(range(0xA1, 0xE0))
    def ptxt(lo, hi): return sum(1 for x in img[max(0, lo):min(HI, hi)] if 0x20 <= x < 0x7F)
    def letters(lo, hi): return sum(1 for x in img[max(0, lo):min(HI, hi)] if 0x41 <= x <= 0x5A or 0x61 <= x <= 0x7A)
    def side(lo, hi): return ptxt(lo, hi) >= 5 and letters(lo, hi) >= 2 and not any(pm[i] for i in range(max(0, lo), min(HI, hi)))
    if all(x in TXT for x in seg) and n <= 16 and (side(a - 8, a) or side(b, b + 8)) and (nm[a - 1] or nm[b])             and seg != b"Tp" and not (rec6(img[a - 4:a + 2]) or rec6(seg)):
        hdr = n <= 3 and seg[0] in (0, 0xFF) and ptxt(b, b + 6) >= 4
        add(a, b, "string/label", "length header / terminator of adjacent label" if hdr else "piece of adjacent text label", "Confirmed",
            "bytes %s %r; context %r|%r" % (hx, seg.decode("latin1"), img[a - 8:a].decode("latin1"), img[b:b + 8].decode("latin1")),
            "string (extend label)", "Confirmed"); return True
    if E and not (bad == 0 and over == 0 and all(e[0] == "branch" for e in E)):
        dref = [e for e in E if not e[0] == "branch"]
        if rec6(seg) and n <= 8 and not textish(seg):
            add(a, b, "record struct", ("settings record {u16 val=%02X%02X; ptr 00FF%02X%02X}" % (seg[0], seg[1], seg[4], seg[5])) if n >= 6 else "record (truncated)", "Confirmed",
                "bytes %s; ref %s" % (hx, fmt(dref)), "struct 6 B", "Confirmed"); return True
        if textish(seg) or (all(x in TXT for x in seg) and side(b, b + 8)) or (n <= 3 and seg[0] == 0 and side(b, b + 8)):
            add(a, b, "string/label", "referenced label %r" % seg[:20].decode("latin1"), "Confirmed", "bytes %s; next %r; ref %s" % (hx, img[b:b + 8].decode("latin1"), fmt(dref)), "string", "Confirmed"); return True
        add(a, b, "value table", "referenced data", "Confirmed", "bytes %s; ref %s" % (hx, fmt(dref)), "data", "Confirmed"); return True
    if all(x in (0, 0xFF) for x in seg):
        add(a, b, "padding/fill", "all 0x00/0xFF", "Confirmed", "bytes %s; 0 inbound refs" % hx); return True
    if textish(seg) and n >= 4:
        add(a, b, "string/label", "unreferenced text %r" % seg[:20].decode("latin1"), "Confirmed", "bytes %s; 0 inbound refs" % hx, "string", "Confirmed"); return True
    g, t = ptr_entries(a, b)
    if n >= 8 and t and g >= 2 and g * 2 >= t:
        add(a, b, "pointer table", "%d/%d BE32 cells point at IDA heads" % (g, t), "Confirmed", "bytes %s; 0 inbound refs" % hx, "BE32 offsets", "Inferred"); return True
    if lowdiv(seg):
        add(a, b, "value table", "low-diversity byte table (%d distinct)" % len(set(seg)), "Inferred", "bytes %s; 0 inbound refs" % hx, "data", "Inferred"); return True
    if bad == 0 and over == 0 and n >= 2 and not E and not textish(seg) and not lowdiv(seg):
        ends = L[-1][2] in TERMS
        p = headof[a - 1] if a else None
        pterm = p is not None and heads[p][1] == "code" and p + heads[p][0] == a and bu[p][1] in TERMS and nm[p]
        skip = ""
        if pterm and bu[p][1] == "bra":
            m = BR.search(bu[p][2])
            if m and int(m.group(1), 16) >= b: skip = "; skipped by bra at %06X -> %s" % (p, m.group(1))
        flows = (b < HI and nm[b] and headof[b] is not None and heads[headof[b]][1] == "code")
        if ends or (flows and pterm):
            add(a, b, "dead code", "clean decode, %d insns, %s%s" % (len(L), ("ends %s" % L[-1][2]) if ends else ("unreachable fragment after %s, flows into code at %06X" % (bu[p][1], b)), skip), "Confirmed",
                "oracle %s; bytes %s; inbound from proven code / pointer cells: 0%s" % (" | ".join("%X %s %s" % (x[0], x[2], x[3]) for x in L[:3]), hx,
                    ("; branches from unproven code: " + ",".join("%06X" % s_ for t_ in range(a, b) for s_, c_ in brt.get(t_, []) if c_ == "N")) if any(c_ == "N" for t_ in range(a, b) for s_, c_ in brt.get(t_, [])) else "; from unproven code: 0"),
                "code (unreferenced)", "Inferred"); return True
    return False


_rs = set(a for a, b in runs)
assert all(k in _rs for k in OV), ["%06X" % k for k in OV if k not in _rs]
for a, b in runs:
    if a in OV:
        tot = 0
        for p in OV[a]:
            s, e = int(p[0], 16), int(p[1], 16); tot += e - s
            add(s, e, p[2], p[3], p[4], p[5], p[6] if len(p) > 6 else "", p[7] if len(p) > 7 else "")
        assert tot == b - a and int(OV[a][0][0], 16) == a and int(OV[a][-1][1], 16) == b, hex(a)
        continue
    if not classify(a, b): left.append((a, b))
json.dump(left, open(O + r"\work\left.json", "w"))
c = collections.Counter(); cb = collections.Counter()
for r in rows: c[r["cls"]] += 1; cb[r["cls"]] += r["end"] - r["start"]
for k in sorted(c): print("%-26s %4d runs %5d B" % (k, c[k], cb[k]))
print("left", len(left), sum(b - a for a, b in left))
json.dump(rows, open(O + r"\work\auto_rows.json", "w"))
with open(O + r"\work\auto_listing.txt", "w", encoding="utf-8") as f:
    for r in sorted(rows, key=lambda r: (r["cls"], r["start"])):
        f.write("%-24s %06X %4d %-60s %s\n" % (r["cls"][:24], r["start"], r["end"] - r["start"], r["sub"][:60], r["ev"][:200]))

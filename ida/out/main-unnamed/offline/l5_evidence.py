from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: inbound-reference evidence for every residue run. Offline, read-only.
import sys, json
sys.path.insert(0, str(_REPO) + r"/ida/out/main-unnamed/offline")
from l5_lib import *
be = collections.defaultdict(list)
for s in range(0, HI - 3):
    v = (img[s] << 24) | (img[s+1] << 16) | (img[s+2] << 8) | img[s+3]
    if v < HI and runid[v] is not None and runid[s] != runid[v]: be[v].append(s)
ab = collections.defaultdict(list)
for s in range(0, HI - 3):
    if img[s] in (0x5E, 0x5A) and img[s+1] == 0:
        t = (img[s+2] << 8) | img[s+3]
        if runid[t] is not None and runid[s] != runid[t]: ab[t].append(s)
ev = {}
for a, b in runs:
    E = []
    for t in range(a, b):
        for s in be.get(t, []):
            h = headof[s]
            tag = "x"
            if h is not None:
                sz, k, tg = heads[h]
                inside = h <= s and s + 4 <= h + sz
                if k == "code" and pm[h] and inside: tag = "Pimm:%s" % bu[h][1]
                elif k == "code" and nm[h] and inside: tag = "Nimm:%s" % bu[h][1]
                elif k != "code" and nm[s] and inside: tag = "Ntab:%s" % k
                elif runid[s] is not None and inside: tag = "Rtab:%s" % k
                elif k == "code" and inside: tag = "Rimm:%s" % bu[h][1]
            if tag == "x" and runid[s] is not None: tag = "Rraw"
            if tag == "x" and nm[s] and (h is None or heads[h][1] not in ("code",)): tag = "Ntab:raw"
            E.append(("be32", t, s, tag))
        for s in ab.get(t, []):
            h = headof[s]
            tag = ("P" if pm[s] else cls(s)) + ("call" if h == s and heads[h][1] == "code" else "raw")
            E.append(("abs24", t, s, tag))
    for t, f, ty, fk, ff, fd in xrefs.get(a, []):
        if runid[f] == a: continue
        E.append(("ida%d" % ty, t, f, cls(f) + fk))
    ev["%06X" % a] = E
json.dump(ev, open(O + r"\work\evidence.json", "w"), indent=0)
print(sum(len(v) for v in ev.values()))

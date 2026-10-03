from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# Lane L5: write the published tables from work\auto_rows.json. Offline, read-only.
#   runs.tsv            every residue byte, as classified pieces (tile the 730 raw runs exactly)
#   class-summary.tsv   bytes / pieces per class, split by confidence and by typing tier
#   proposed-typing.tsv pieces that can be typed, with the DB action and its confidence
import sys, json, hashlib
sys.path.insert(0, str(_REPO) + r"/ida/out/main-unnamed/offline")
from l5_lib import *
rows = sorted(json.load(open(O + r"\work\auto_rows.json")), key=lambda r: r["start"])
# tiling check
cov = bytearray(HI)
for r in rows:
    for i in range(r["start"], r["end"]):
        assert cov[i] == 0, hex(i); cov[i] = 1
res = bytes(1 - x for x in nm)
assert bytes(cov) == res, "pieces do not tile the residue"
assert sum(cov) == 7365
raw = {a: b for a, b in runs}
def tier(r):
    t, tc, c = r["typing"], r["tconf"], r["cls"]
    if c == "padding/fill": return "T3 fill (typable as fill)"
    if not t: return "T4 un-nameable"
    if tc == "Confirmed": return "T1 Confirmed typing"
    return "T2 Inferred typing"
def action(r):
    c, t = r["cls"], r["typing"]
    if "already typed in DB" in t: return "none (DB item exists; mask correction only)"
    if c == "reached-code gap" and r["tconf"] == "Confirmed": return "del_items + create_insn"
    if c in ("dead code", "reached-code gap") or t.startswith("code"): return "create_insn (code)"
    if c == "pointer table": return "dword + offset"
    if c == "string/label": return "byte array (label)"
    if c in ("record struct", "value table", "closed-window interior"): return "byte array (data)"
    return ""
with open(O + r"\runs.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_excl\tlen\traw_run\tclass\tsubclass\tclass_conf\ttyping\ttyping_conf\ttier\tbytes_hex(first 32)\tevidence\n")
    for r in rows:
        a, b = r["start"], r["end"]
        f.write("%06X\t%06X\t%d\t%06X\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (a, b, b - a, runid[a], r["cls"], r["sub"].replace("\t", " "), r["conf"],
                r["typing"], r["tconf"], tier(r), img[a:min(b, a + 32)].hex(" "), r["ev"].replace("\t", " ")))
C = collections.OrderedDict()
CLS = ["padding/fill", "string/label", "pointer table", "value table", "record struct", "dead code", "mid-instruction/garbage",
       "closed-window interior", "reached-code gap", "Unknown"]
for c in CLS: C[c] = collections.Counter()
for r in rows:
    n = r["end"] - r["start"]; k = C[r["cls"]]
    k["pieces"] += 1; k["bytes"] += n; k["conf_" + r["conf"]] += n; k[tier(r)[:2]] += n
with open(O + r"\class-summary.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("class\tpieces\tbytes\tclass_Confirmed\tclass_Inferred\tT1_typing_Confirmed\tT2_typing_Inferred\tT3_fill\tT4_unnameable\n")
    tot = collections.Counter()
    for c, k in C.items():
        f.write("%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n" % (c, k["pieces"], k["bytes"], k["conf_Confirmed"], k["conf_Inferred"], k["T1"], k["T2"], k["T3"], k["T4"]))
        tot.update(k)
    f.write("TOTAL\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n" % (tot["pieces"], tot["bytes"], tot["conf_Confirmed"], tot["conf_Inferred"], tot["T1"], tot["T2"], tot["T3"], tot["T4"]))
assert tot["bytes"] == 7365 and tot["T1"] + tot["T2"] + tot["T3"] + tot["T4"] == 7365
with open(O + r"\proposed-typing.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_excl\tlen\tclass\ttyping\ttyping_conf\tdb_action\tsubclass\n")
    for r in rows:
        if not r["typing"]: continue
        a, b = r["start"], r["end"]
        f.write("%06X\t%06X\t%d\t%s\t%s\t%s\t%s\t%s\n" % (a, b, b - a, r["cls"], r["typing"], r["tconf"], action(r), r["sub"]))
print(dict(tot))
for c, k in C.items(): print("%-26s %4d %5d  T1 %5d T2 %5d T3 %4d T4 %4d" % (c, k["pieces"], k["bytes"], k["T1"], k["T2"], k["T3"], k["T4"]))
print("residue mask sha256", hashlib.sha256(res).hexdigest()[:16])

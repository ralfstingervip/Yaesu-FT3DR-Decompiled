# compact per-piece review listing -> work\review.txt
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import json, collections
d = json.load(open((_REPO_S + "/ida/out/dead-code-tier/work/scan.json")))
o = open((_REPO_S + "/ida/out/dead-code-tier/work/review.txt"), "w", encoding="utf-8")
for k, r in d.items():
    o.write("=== %s +%d | %s\n" % (k, r["len"], r["sub"][:90]))
    o.write("  last %s | term %s | next %s %s%s | prev %s | ida %s\n" % (r["last"], r["last_term"], r["next_insn"], r["next_cls"],
            "H" if r["next_head"] else "", r["prev_item"], r["ida_agree"]))
    if r["bad"] or r["bad_targets"]: o.write("  BAD %s %s\n" % (r["bad"], r["bad_targets"]))
    co = collections.Counter()
    for x in r["inbound"]:
        c = x[4]
        if x[0] in ("cf", "abs24", "imm") and not c.startswith(("P-head", "piece", "code-head")):
            co["%s:%s" % (x[0], c.split("(")[0])] += 1; continue
        if x[0] == "be32" and c.startswith(("straddle", "no item", "inside piece")):
            co["be32:%s" % c.split(" ")[0]] += 1; continue
        o.write("  IN %s\n" % (x,))
    for f in r["fallthrough_cands"]:
        if f[3].startswith(("P-head", "piece", "code-head")) or f[6]: o.write("  FT %s\n" % (f,))
    if co: o.write("  coincidental: %s\n" % dict(co))
    if r["live_heads"]: o.write("  LIVE %s\n" % r["live_heads"])
    if r["coincidental_entered"]: o.write("  COINC-ENTERED %s\n" % r["coincidental_entered"])
o.close()

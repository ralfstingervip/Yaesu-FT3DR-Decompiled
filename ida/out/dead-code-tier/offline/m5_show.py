# print scan detail for given pieces
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import json, sys
d = json.load(open((_REPO_S + "/ida/out/dead-code-tier/work/scan.json")))
keys = sys.argv[1:] or list(d)
for k in keys:
    r = d[k]
    print("=== %s len %d | %s" % (k, r["len"], r["sub"]))
    print("  last:", r["last"], "| term", r["last_term"], "| next", r["next_insn"], r["next_cls"], r["next_head"])
    print("  prev:", r["prev_item"], "| ida_agree", r["ida_agree"])
    if r["bad"] or r["bad_targets"]: print("  BAD", r["bad"], r["bad_targets"])
    for x in r["inbound"]: print("  IN", x)
    for f in r["fallthrough_cands"]: print("  FT", f)
    if r["live_heads"]: print("  LIVE", r["live_heads"])
    if r["coincidental_entered"]: print("  COINC", r["coincidental_entered"])

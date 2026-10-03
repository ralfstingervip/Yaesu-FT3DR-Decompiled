from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import json
d = json.load(open((_REPO_S + "/ida/out/dead-code-tier/work/scan.json")))
def flags(r):
    f = []
    if r["bad"]: f.append("BAD")
    if not r["end_exact"]: f.append("NOEND")
    if not r["last_term"]: f.append("flows->%s%s" % (r["next_cls"], "H" if r["next_head"] else "!"))
    if r["delay_slot_at_end"]: f.append("DSLOT")
    if r["bad_targets"]: f.append("BT%d" % len(r["bad_targets"]))
    if not r["ida_agree"]: f.append("IDADIS")
    if r["live_bytes"]: f.append("LIVE%d" % r["live_bytes"])
    real = [x for x in r["inbound"] if x[0] in ("cf", "abs24", "imm") and x[4].startswith(("P-head", "piece", "code-head"))]
    be = [x for x in r["inbound"] if x[0] == "be32" and (x[4].startswith(("REAL", "data cell")))]
    ft = [x for x in r["fallthrough_cands"] if x[3].startswith(("P-head", "piece", "code-head")) and not x[5]]
    ds = [x for x in r["fallthrough_cands"] if x[6]]
    for nm, lst in (("CF", real), ("BE", be)):
        if lst: f.append("%s%d[%s]" % (nm, len(lst), ",".join(x[4][:14] + ("L" if x[5] else "") for x in lst)[:80]))
    for nm, lst in (("FT", ft), ("DS", ds)):
        if lst: f.append("%s%d[%s]" % (nm, len(lst), ",".join(x[0] + x[3][:14] + ("L" if x[4] else "") for x in lst)[:80]))
    if r["coincidental_entered"]: f.append("COINC-ENTERED%d" % len(r["coincidental_entered"]))
    return f
if __name__ == "__main__":
    for k, r in d.items():
        f = flags(r)
        if f: print(k, r["len"], " ".join(f))
    print(sum(1 for r in d.values() if not flags(r)), "pieces clean,", sum(r["len"] for r in d.values() if not flags(r)), "B")

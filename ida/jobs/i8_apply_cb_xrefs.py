import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
# Lane I8: apply site->target code xrefs for the 267 jmp/jsr @ERn indirect-callback
# sites in MAIN reached code, then re-analyse and report reachability recovery.
# Owner-side static analysis only. No image byte is modified; nothing is written to a radio.
# DB: I8_MAIN (seed --copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64 first run; --reopen after).
# Reads sites.tsv from ida\out\indirect-cb\ (produced offline, byte-verified from the image).
import traceback
ROOT = str(_REPO)
OUTD = ROOT + r"\ida\out\indirect-cb"
LOG  = OUTD + r"\apply_log.txt"

def main():
    import idaapi, ida_auto, ida_xref, ida_bytes, ida_funcs, idc
    lines = []
    def say(s):
        lines.append(s)

    # load sites.tsv: site \t kind \t reg \t form \t source \t confidence \t targets ...
    edges = []   # (site, is_call, target)
    sites_seen = set()
    path = OUTD + r"\sites.tsv"
    with open(path, "r", encoding="utf-8") as f:
        hdr = f.readline()
        for ln in f:
            c = ln.rstrip("\n").split("\t")
            if len(c) < 7:
                continue
            site = int(c[0], 16)
            is_call = (c[1] == "jsr")
            if c[3] == "closed_window":
                continue
            if c[6] in ("-", ""):
                continue
            sites_seen.add(site)
            for t in c[6].split(","):
                t = t.strip()
                if t:
                    edges.append((site, is_call, int(t, 16)))
    say("sites with >=1 concrete target: %d" % len(sites_seen))
    say("site->target edges to apply: %d" % len(edges))

    # apply code xrefs (does not modify image bytes; only the DB cross-reference graph)
    added = 0
    for site, is_call, tgt in edges:
        fl = ida_xref.fl_CN if is_call else ida_xref.fl_JN   # near call / near jump
        ida_xref.add_cref(site, tgt, fl | 0)
        added += 1
    say("code xrefs added: %d" % added)
    ida_auto.auto_wait()

    # reachability: a target that now has an incoming xref and sits at (or inside) a
    # residual-194 function, or in previously-unreached well-formed code.
    # Load residual list.
    residual = []
    with open(ROOT + r"\ida\out\main-indirect\residual.tsv", "r", encoding="utf-8") as f:
        f.readline()
        for ln in f:
            c = ln.split("\t")
            if len(c) >= 2:
                try:
                    residual.append((int(c[0], 16), int(c[1], 16)))
                except Exception:
                    pass
    tgtset = set(t for _, _, t in edges)
    res_hit = [(s, e) for s, e in residual if any(s <= t < e for t in tgtset)]
    say("F1 residual-194 functions containing a now-xref'd target: %d" % len(res_hit))
    for s, e in res_hit:
        say("  residual %06X-%06X" % (s, e))

    # how many distinct targets now have a code xref but were not a function head before
    new_heads = 0
    for t in sorted(tgtset):
        f = ida_funcs.get_func(t)
        if f is None or f.start_ea != t:
            new_heads += 1
    say("targets that are not an existing function head: %d" % new_heads)

    # confirm: no image bytes changed (spot sha not needed; we never call patch_*)
    say("image bytes modified: none (only DB cross-references added)")

    with open(LOG, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    idc.qexit(0)

try:
    main()
except Exception:
    with open(ROOT + r"\ida\out\indirect-cb\apply_traceback.txt", "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
    try:
        import idc
        idc.qexit(1)
    except Exception:
        pass

r"""Lane K7 -- build SUB_FINAL3 from SUB_FINAL2: apply J10's frozen plan (doc 78,
ida\out\sub-merge\disposition.tsv) byte-neutrally.  Idempotent: every step tests the DB first, so a
second run on a finished DB changes 0 items, 0 functions, 0 names and 0 comments.  One run = one pass.

    python ida/run_job.py --script ida\jobs\k7_apply_sub_final3.py --db K7_SUB_FINAL3 --copy-from ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64 --env K7_PASS=1
    python ida/run_job.py --script ida\jobs\k7_apply_sub_final3.py --db K7_SUB_FINAL3 --reopen --env K7_PASS=2

Steps
  0 verify every J10 edge of every merge row against this DB (flow: predecessor head is code, not
    CF_STOP, ends exactly at the continuation; jump: fl_JF/fl_JN xref; call: fl_CF/fl_CN xref)
  1 the 31 'merge-into' rows: delete the continuation function and give each of its chunks to the
    J10 root (extend the root's adjacent chunk when the head before it is the root's chunk end,
    else append as a tail).  Same mechanics as i17_apply_final2.py.  Repeatable comment
    'K7: was sub_XXXXXXXX (J10 merge-into sub_YYYYYYYY, <edge kinds>)' at every old start.
    Verify get_func(old_start).start_ea == root for all 31.
  2 the 125 'dead' rows: rename sub_X -> dead_X (only a default sub_ name is replaced), add a
    repeatable function comment 'K7/J10: DEAD ...', and re-check that no edge from outside the
    function's chunks enters any head of it (flow from a non-stop predecessor, any code or data xref,
    vector slot).  No code byte is undefined, deleted or retyped.
  3 plan_range + auto_wait over FFECE4E4..FFF50A00 (as I17), then measure the pass against the
    pre-pass snapshot: items, functions/chunks, names, comments, and a layout hash.
Outputs ida\out\sub-final3\: merges.tsv, dead.tsv, alias-final3.tsv (pass 1 writes them; later
  passes rewrite them identically), raw\apply_pass<N>.txt, raw\apply_pass<N>_changes.tsv,
  raw\apply_pass<N>_delta.tsv
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, hashlib, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final3")
RAW = os.path.join(OUT, "raw")
PLAN = os.path.join(ROOT, r"ida\out\sub-merge\disposition.tsv")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
INTB = 0xFFED8A70
PASS = os.environ.get("K7_PASS", "x")
STATUS = os.path.join(RAW, "apply_pass%s.txt" % PASS)
CHG = os.path.join(RAW, "apply_pass%s_changes.tsv" % PASS)
LO, HI = 0xFFECE4E4, 0xFFF50A00
CF_STOP = 0x1
MCMT = "K7: was sub_%08X (J10 merge-into sub_%08X, %s)"
DCMT = ("K7/J10: DEAD - no flow, branch, switch, call, data, pointer, imm or vector edge enters this "
        "function from outside its chunks (doc 78 / doc 89). Code bytes kept, not reached. Was sub_%08X.")


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def rd(path):
    with open(path, encoding="utf-8") as h:
        lines = h.read().splitlines()
    hd = lines[0].split("\t")
    return [dict(zip(hd, l.split("\t"))) for l in lines[1:]]


def parse_edges(s):
    out = []
    for e in s.split(";"):
        if not e:
            continue
        k, rest = e.split(":", 1)
        a, b = rest.split("->")
        out.append((k, int(a, 16), int(b, 16)))
    return out


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_name, ida_xref, idautils, idc
    ida_auto.auto_wait()
    img = sys.exit("The firmware image is not in this repository.")
    chg = open(CHG, "w", encoding="utf-8", newline="\n")
    chg.write("step\taction\tea\tdetail\n")
    cnt = {}

    def note(step, action, ea, detail=""):
        cnt[(step, action)] = cnt.get((step, action), 0) + 1
        chg.write("%s\t%s\t%08X\t%s\n" % (step, action, ea, detail))

    def snapshot():
        heads = {}
        ea = LO
        while ea < HI:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl) or ida_bytes.is_data(fl):
                sz = max(ida_bytes.get_item_size(ea), 1)
                heads[ea] = (sz, "c" if ida_bytes.is_code(fl) else "d%X" % (fl & 0xF0000000))
                ea += sz
            else:
                ea += 1
        fns = {}
        names = {}
        fcm = {}
        for s in idautils.Functions():
            fns[s] = tuple(idautils.Chunks(s))
            names[s] = ida_name.get_name(s)
            fcm[s] = idc.get_func_cmt(s, 1) or ""
        cms = {}
        for s in plan_starts:
            cms[s] = idc.get_cmt(s, 1) or ""
        hsh = hashlib.sha256()
        for e in sorted(heads):
            hsh.update(b"%08X%d%s" % (e, heads[e][0], heads[e][1].encode()))
        for s in sorted(fns):
            hsh.update(("%08X%s%s%s" % (s, fns[s], names[s], fcm[s])).encode())
        for s in sorted(cms):
            hsh.update(("%08X%s" % (s, cms[s])).encode())
        return heads, fns, names, fcm, cms, hsh.hexdigest()[:16]

    def is_stop(ea):
        insn = ida_ua.insn_t()
        return ida_ua.decode_insn(insn, ea) > 0 and bool(insn.get_canon_feature() & CF_STOP)

    plan = rd(PLAN)
    plan_starts = [int(r["start"], 16) for r in plan]
    merges = [r for r in plan if r["disposition"] == "merge-into"]
    deads = [r for r in plan if r["disposition"] == "dead"]
    others = [r for r in plan if r["disposition"] not in ("merge-into", "dead")]
    if len(merges) != 31 or len(deads) != 125 or others:
        raise RuntimeError("plan is not J10's 31/125/0: %d %d %d" % (len(merges), len(deads), len(others)))
    pre_heads, pre_fns, pre_names, pre_fcm, pre_cms, pre_hash = snapshot()
    log("pre: functions %d ; layout hash %s" % (len(pre_fns), pre_hash))

    # ------------------------------------------------------------ 0. verify J10 edges in this DB
    srcs = {}; root = {}; kinds = {}; everify = {}
    for r in merges:
        s = int(r["start"], 16)
        root[s] = int(r["root"], 16)
        ed = parse_edges(r["edges"]) + parse_edges(r["calls"])
        kinds[s] = r["edge_kinds"] if r["edge_kinds"] != "-" else "call-from-dead-caller"
        srcs[s] = [a for k, a, b in ed]
        res = []
        for k, a, b in ed:
            if k == "flow":
                ok = (ida_bytes.prev_head(b, 0) == a and ida_bytes.is_code(ida_bytes.get_flags(a))
                      and a + ida_bytes.get_item_size(a) == b and not is_stop(a))
            else:
                want = (18, 19) if k == "jump" else (16, 17)
                ok = any(x.frm == a and x.type in want for x in idautils.XrefsTo(b, 0))
            res.append("%s:%08X->%08X=%s" % (k, a, b, "ok" if ok else "FAIL"))
            if not ok:
                note("0", "edge_FAIL", s, res[-1])
        everify[s] = ";".join(res)
    log("edge verification: %d edges, %d FAIL" % (sum(len(v.split(";")) for v in everify.values()), cnt.get(("0", "edge_FAIL"), 0)))

    # ------------------------------------------------------------ 1. merges
    def merge(s, o):
        chunks = sorted(tuple(c) for c in idautils.Chunks(s))
        ok = ida_funcs.del_func(s)
        note("1", "del_func", s, "%s -> owner %08X chunks %s" % (ok, o, ";".join("%08X-%08X" % c for c in chunks)))
        for a, b in chunks:
            g = ida_funcs.get_func(a)
            if g is not None:
                note("1", "shared_tail_kept", a, "%08X-%08X still owned by %08X" % (a, b, g.start_ea))
                continue
            p = ida_bytes.prev_head(a, 0)
            ch = ida_funcs.get_fchunk(p) if p != idc.BADADDR else None
            pf = ida_funcs.get_func(p) if p != idc.BADADDR else None
            if ch and pf and pf.start_ea == o and ch.end_ea == a:
                ok = ida_funcs.set_func_end(p, b)
                note("1", "extend" if ok else "extend_FAIL", a, "%08X-%08X chunk %08X of %08X" % (a, b, ch.start_ea, o))
            else:
                ok = ida_funcs.append_func_tail(ida_funcs.get_func(o), a, b)
                note("1", "tail" if ok else "tail_FAIL", a, "%08X-%08X -> %08X" % (a, b, o))

    old_chunks = {}
    for s in root:
        f = ida_funcs.get_func(s)
        if f is not None and f.start_ea == s:
            old_chunks[s] = sorted(tuple(c) for c in idautils.Chunks(s))
    for it in range(200):
        pend = [s for s in root if (lambda f: f is not None and f.start_ea == s)(ida_funcs.get_func(s))]
        if not pend:
            break
        pset = set(pend); prog = 0
        for s in pend:
            o = root[s]
            owners = set()
            for x in srcs[s]:
                g = ida_funcs.get_func(x)
                owners.add(g.start_ea if g else None)
            owners.discard(s)
            if owners == {o}:
                merge(s, o); prog += 1
        if prog:
            continue
        for s in pend:
            o = root[s]
            owners = set()
            for x in srcs[s]:
                g = ida_funcs.get_func(x)
                owners.add(g.start_ea if g else None)
            owners.discard(s)
            if all(w == o or (w in pset and root.get(w) == o) for w in owners):
                note("1", "merge_cycle", s, "sources in %s" % ",".join("%08X" % w for w in sorted(owners)))
                merge(s, o); prog += 1
                break
            note("1", "merge_blocked", s, "sources in %s" % ",".join(("%08X" % w) if w else "none" for w in owners))
        if not prog:
            break
    ida_auto.auto_wait()

    # ------------------------------------------------------------ 2. dead heads: name + comment
    vec = set(struct.unpack_from("<I", img, INTB - BASE + 4 * i)[0] for i in range(256))
    vec |= set(struct.unpack_from("<I", img, 0xFFFFFF80 - BASE + 4 * i)[0] for i in range(32))
    dead_rows = []
    for r in deads:
        s = int(r["start"], 16)
        f = ida_funcs.get_func(s)
        if f is None or f.start_ea != s:
            note("2", "dead_not_function_MISSING", s)
            dead_rows.append((s, None)); continue
        cur = ida_name.get_name(s)
        want = "dead_%08X" % s
        if cur == "sub_%08X" % s:
            ida_name.set_name(s, want, ida_name.SN_NOWARN | ida_name.SN_NOCHECK)
            note("2", "rename", s, "%s -> %s" % (cur, ida_name.get_name(s)))
        elif cur != want:
            note("2", "rename_skipped_user_name", s, cur)
        c = DCMT % s
        old = idc.get_func_cmt(s, 1) or ""
        if c not in old:
            idc.set_func_cmt(s, (old + "\n" + c) if old else c, 1)
            note("2", "func_comment", s)
        # re-check inbound edges into any head of the (post-merge) function
        chunks = sorted(tuple(x) for x in idautils.Chunks(s))
        inK = lambda ea: any(a <= ea < b for a, b in chunks)
        inbound = []
        for a, b in chunks:
            p = ida_bytes.prev_head(a, 0)
            if p != idc.BADADDR and not inK(p) and ida_bytes.is_code(ida_bytes.get_flags(p)) \
                    and p + ida_bytes.get_item_size(p) == a and not is_stop(p):
                inbound.append("flow:%08X->%08X" % (p, a))
            for hd in idautils.Heads(a, b):
                for xr in idautils.XrefsTo(hd, 0):
                    if xr.type == 21 or inK(xr.frm):
                        continue
                    inbound.append("x%d:%08X->%08X" % (xr.type, xr.frm, hd))
                if hd in vec:
                    inbound.append("vector:%08X" % hd)
        dead_rows.append((s, dict(chunks=chunks, inbound=inbound, name=ida_name.get_name(s),
                                  prev=r["reach_prev"], size_j10=int(r["size"]))))
        if inbound:
            note("2", "dead_inbound_FOUND", s, ";".join(inbound))

    # ------------------------------------------------------------ tables (rewritten each pass)
    bad = 0
    prev_mt = os.path.join(OUT, "merges.tsv")
    if os.path.isfile(prev_mt):          # a rerun keeps the pre-merge chunk bounds recorded by pass 1
        for r_ in rd(prev_mt):
            s_ = int(r_["old_start"], 16)
            if s_ not in old_chunks and r_.get("old_chunks", "").startswith("F"):
                old_chunks[s_] = [tuple(int(v, 16) for v in c_.split("-")) for c_ in r_["old_chunks"].split(";")]
    with open(prev_mt, "w", encoding="utf-8", newline="\n") as h:
        h.write("old_name\told_start\told_end\tbytes_j10\tbytes_all_chunks\treach_prev\troot\troot_name_now\tedge_kinds\tedges_verified\towner_now\tok\told_chunks\n")
        for r in merges:
            s = int(r["start"], 16)
            c = MCMT % (s, root[s], kinds[s])
            oldc = idc.get_cmt(s, 1) or ""
            if c not in oldc:
                idc.set_cmt(s, (oldc + "\n" + c) if oldc else c, 1)
                note("1", "comment", s, c)
            g = ida_funcs.get_func(s)
            got = g.start_ea if g else None
            ok = got == root[s]
            if not ok:
                bad += 1
                note("1", "owner_MISMATCH", s, "want %08X got %s" % (root[s], ("%08X" % got) if got else "none"))
            h.write("sub_%08X\t%08X\t%s\t%s\t%d\t%s\t%08X\t%s\t%s\t%s\t%s\t%s\t%s\n" % (
                s, s, r["end"], r["size"], sum(b_ - a_ for a_, b_ in old_chunks.get(s, [])), r["reach_prev"], root[s], ida_name.get_name(root[s]), kinds[s], everify[s],
                ("%08X" % got) if got else "", "yes" if ok else "NO",
                ";".join("%08X-%08X" % c_ for c_ in old_chunks.get(s, [])) or "(already merged)"))
    log("merge rows %d ; owner mismatches %d" % (len(merges), bad))
    members = {}
    for s in root:
        members.setdefault(root[s], []).append(s)
    nin = 0; tot = 0
    with open(os.path.join(OUT, "dead.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tbytes_total\tchunks\tchunk_bounds\tname_now\told_name\treach_prev\tj10_head_bytes\tmerged_members\tinbound_edges_now\n")
        for s, d in dead_rows:
            if d is None:
                h.write("%08X\t\t\t\t\t\tsub_%08X\t\t\t\tMISSING\n" % (s, s)); continue
            sz = sum(b - a for a, b in d["chunks"]); tot += sz
            nin += 1 if d["inbound"] else 0
            f = ida_funcs.get_func(s)
            h.write("%08X\t%08X\t%d\t%d\t%s\t%s\tsub_%08X\t%s\t%d\t%s\t%s\n" % (
                s, f.end_ea, sz, len(d["chunks"]), ";".join("%08X-%08X" % c for c in d["chunks"]), d["name"], s,
                d["prev"], d["size_j10"], ",".join("%08X" % m for m in sorted(members.get(s, []))),
                ";".join(d["inbound"]) or "0"))
    log("dead rows %d ; bytes in dead functions (post-merge, all chunks) %d ; with inbound edges %d" % (len(dead_rows), tot, nin))
    with open(os.path.join(OUT, "alias-final3.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("old_name\told_start\tnew_owner\tnew_owner_name\tdecision\treason\n")
        for r in plan:
            s = int(r["start"], 16)
            if r["disposition"] == "merge-into":
                g = ida_funcs.get_func(s)
                got = g.start_ea if g else None
                h.write("sub_%08X\t%08X\t%s\t%s\tmerged\tJ10 %s continuation into dead chain head; owner stays unreached\n" % (
                    s, s, ("%08X" % got) if got else "", ida_name.get_name(got) if got else "", kinds[s]))
            else:
                h.write("sub_%08X\t%08X\t%08X\t%s\trenamed dead\tJ10 dead chain head: 0 inbound edges, 0 of 288 vectors, 0 pointer/imm hits\n" % (
                    s, s, s, ida_name.get_name(s)))

    # ------------------------------------------------------------ 3. auto-analysis, measure
    ida_auto.plan_range(LO, HI)
    ida_auto.auto_wait()
    post_heads, post_fns, post_names, post_fcm, post_cms, post_hash = snapshot()
    hadd = [e for e in post_heads if e not in pre_heads or pre_heads[e] != post_heads[e]]
    hdel = [e for e in pre_heads if e not in post_heads]
    fadd = [s for s in post_fns if s not in pre_fns]
    fdel = [s for s in pre_fns if s not in post_fns]
    fchg = [s for s in post_fns if s in pre_fns and post_fns[s] != pre_fns[s]]
    nchg = [s for s in post_names if s in pre_names and post_names[s] != pre_names[s]]
    fcchg = [s for s in post_fcm if s in pre_fcm and post_fcm[s] != pre_fcm[s]]
    cchg = [s for s in post_cms if post_cms[s] != pre_cms.get(s, "")]
    with open(CHG.replace("_changes", "_delta"), "w", encoding="utf-8", newline="\n") as h:
        h.write("kind\tea\tbefore\tafter\n")
        for e in sorted(hadd):
            h.write("item+\t%08X\t%s\t%s\n" % (e, pre_heads.get(e, ""), post_heads[e]))
        for e in sorted(hdel):
            h.write("item-\t%08X\t%s\t\n" % (e, pre_heads[e]))
        for s in sorted(fadd):
            h.write("func+\t%08X\t\t%s\n" % (s, post_fns[s]))
        for s in sorted(fdel):
            h.write("func-\t%08X\t%s\t\n" % (s, pre_fns[s]))
        for s in sorted(fchg):
            h.write("func~\t%08X\t%s\t%s\n" % (s, pre_fns[s], post_fns[s]))
        for s in sorted(nchg):
            h.write("name~\t%08X\t%s\t%s\n" % (s, pre_names[s], post_names[s]))
        for s in sorted(fcchg):
            h.write("fcmt~\t%08X\t%d\t%d\n" % (s, len(pre_fcm[s]), len(post_fcm[s])))
        for s in sorted(cchg):
            h.write("cmt~\t%08X\t%d\t%d\n" % (s, len(pre_cms.get(s, "")), len(post_cms[s])))
    code_pre = sum(v[0] for v in pre_heads.values() if v[1] == "c")
    code_post = sum(v[0] for v in post_heads.values() if v[1] == "c")
    data_pre = sum(v[0] for v in pre_heads.values() if v[1] != "c")
    data_post = sum(v[0] for v in post_heads.values() if v[1] != "c")
    unk = 0
    ea = 0xFFED0000
    while ea < 0xFFF50000:
        if ida_bytes.is_unknown(ida_bytes.get_flags(ea)):
            unk += 1
        ea += 1
    for (step, action), n in sorted(cnt.items()):
        log("step %s %-26s %d" % (step, action, n))
    log("PASS %s: items changed/added %d removed %d ; functions +%d -%d ~%d ; names ~%d ; func comments ~%d ; "
        "addr comments ~%d ; functions now %d ; code bytes in %08X-%08X %d -> %d ; data bytes %d -> %d ; "
        "window unexplored bytes %d ; layout hash %s -> %s"
        % (PASS, len(hadd), len(hdel), len(fadd), len(fdel), len(fchg), len(nchg), len(fcchg), len(cchg),
           len(post_fns), LO, HI, code_pre, code_post, data_pre, data_post, unk, pre_hash, post_hash))
    log("done")
    chg.close()


try:
    os.makedirs(RAW, exist_ok=True)
    open(STATUS, "w").close()
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

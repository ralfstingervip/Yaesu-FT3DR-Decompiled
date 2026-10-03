r"""Lane I17 -- build SUB_FINAL2 from SUB_FINAL: merge the lane-4 split continuations into their
true owners and type the never-explored published data.  Idempotent: every step tests the DB
first, so a second run on a finished DB changes 0 functions and 0 items.  One run = one pass.

    python ida/run_job.py --script ida\jobs\i17_apply_final2.py --db SUB_FINAL2 --reopen --env I17_PASS=1

Inputs (frozen on disk; nothing is read from another lane's DB)
  ida\out\sub-final2\merge-plan.tsv     i17_plan.py on the unmerged copy of SUB_FINAL
  ida\out\sub-final2\data-items.tsv     i17_dataplan.py (offline, from the image)
  ida\out\sub-final2\data-structs.tsv   struct declarations used by data-items.tsv
Steps
  1 merges: for each 'merge' row whose old start is still a function start, delete that function
    and give every one of its chunks to the function that now owns the plan's entry-edge sources
    (extend the owner's adjacent chunk when the head before the chunk is the owner's chunk end,
    else append it as a tail).  Repeatable comment 'I17: was sub_XXXXXXXX (lane-4 start)' at
    every old start.  Then verify get_func(old_start) == plan owner for every row.
  2 struct types (local types i17_*), then every data item of data-items.tsv (refuses to touch
    code; replaces only data/unknown bytes)
  3 auto-analysis over FFECE4E4..FFF50A00, then measure the pass
Outputs ida\out\sub-final2\: alias.tsv, raw\apply_pass<N>.txt, raw\apply_pass<N>_changes.tsv,
  raw\apply_pass<N>_delta.tsv
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final2")
RAW = os.path.join(OUT, "raw")
PASS = os.environ.get("I17_PASS", "x")
STATUS = os.path.join(RAW, "apply_pass%s.txt" % PASS)
CHG = os.path.join(RAW, "apply_pass%s_changes.tsv" % PASS)
LO, HI = 0xFFECE4E4, 0xFFF50A00
CF_STOP = 0x1
CMT = "I17: was sub_%08X (lane-4 start)"


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def rd(path):
    with open(path, encoding="utf-8") as h:
        lines = h.read().splitlines()
    hd = lines[0].split("\t")
    return [dict(zip(hd, l.split("\t"))) for l in lines[1:]]


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_nalt, ida_offset, ida_name, ida_typeinf, idautils, idc
    ida_auto.auto_wait()
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
        for s in idautils.Functions():
            fns[s] = tuple(idautils.Chunks(s))
        cm = {}
        return heads, fns

    pre_heads, pre_fns = snapshot()

    def is_stop(ea):
        insn = ida_ua.insn_t()
        return ida_ua.decode_insn(insn, ea) > 0 and bool(insn.get_canon_feature() & CF_STOP)

    # ---------------------------------------------------------------- 1. merges
    plan = rd(os.path.join(OUT, "merge-plan.tsv"))
    merges = [r for r in plan if r["decision"] == "merge"]
    srcs = {}
    for r in merges:
        s = int(r["old_start"], 16)
        srcs[s] = [int(e.split(":")[1].split("->")[0], 16) for e in r["edges"].split(";") if e]

    def cmt(s):
        c = CMT % s
        old = idc.get_cmt(s, 1) or ""
        if c not in old:
            idc.set_cmt(s, (old + "\n" + c) if old else c, 1)
            note("1", "comment", s, c)

    root = dict((int(r["old_start"], 16), int(r["new_owner"], 16)) for r in merges)

    def merge(s, o):
        chunks = sorted(tuple(c) for c in idautils.Chunks(s))
        ok = ida_funcs.del_func(s)
        note("1", "del_func", s, "%s -> owner %08X chunks %s" % (ok, o, ";".join("%08X-%08X" % c for c in chunks)))
        for a, b in chunks:
            g = ida_funcs.get_func(a)
            if g is not None:
                # a tail shared with another parent survives the deletion; it stays with that parent
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

    # Merge a continuation once every entry-edge source is already inside its root (so chains
    # collapse into contiguous extensions); then force the rest, which are cycles of
    # continuations that only enter one another besides the root, straight into the root.
    for it in range(200):
        pend = [s for s in root if (lambda f: f is not None and f.start_ea == s)(ida_funcs.get_func(s))]
        if not pend:
            break
        pset = set(pend)
        prog = 0
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
            else:
                note("1", "merge_blocked", s, "sources in %s" % ",".join(("%08X" % w) if w else "none" for w in owners))
        if not prog:
            break
    ida_auto.auto_wait()
    bad = 0
    with open(os.path.join(OUT, "alias.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("old_name\told_start\tnew_owner\tnew_owner_name\tdecision\treason\n")
        for r in plan:
            s = int(r["old_start"], 16)
            if r["decision"] == "merge":
                cmt(s)
                g = ida_funcs.get_func(s)
                got = g.start_ea if g else None
                want = int(r["new_owner"], 16)
                if got != want:
                    bad += 1
                    note("1", "owner_MISMATCH", s, "want %08X got %s" % (want, ("%08X" % got) if got else "none"))
                h.write("sub_%08X\t%08X\t%s\t%s\tmerged\t%s\n" % (s, s, ("%08X" % got) if got else "", ida_name.get_name(got) if got else "", r["reason"]))
            else:
                h.write("sub_%08X\t%08X\t%08X\tsub_%08X\tkept (%s)\t%s\n" % (s, s, s, s, r["decision"], r["reason"]))
    log("merge rows %d ; owner mismatches %d" % (len(merges), bad))

    # ---------------------------------------------------------------- 2. data typing
    tids = {}
    for r in rd(os.path.join(OUT, "data-structs.tsv")):
        tid = idc.get_struc_id(r["name"])
        if tid == idc.BADADDR:
            n = ida_typeinf.idc_parse_types(r["decl"], 0)
            tid = idc.get_struc_id(r["name"])
            note("2", "struct_type", 0, "%s errors %d" % (r["name"], n))
        if tid == idc.BADADDR or idc.get_struc_size(tid) != int(r["size"]):
            raise RuntimeError("struct %s not created (size %s)" % (r["name"], idc.get_struc_size(tid)))
        tids[r["name"]] = tid

    def same(ea, size, kind, arg):
        fl = ida_bytes.get_flags(ea)
        if not ida_bytes.is_data(fl) or ida_bytes.get_item_size(ea) != size or ida_bytes.get_item_head(ea) != ea:
            return False
        if kind == "struct":
            oi = ida_nalt.opinfo_t()
            return ida_bytes.is_struct(fl) and ida_bytes.get_opinfo(oi, ea, 0, fl) is not None and oi.tid == tids[arg]
        if kind == "strlit":
            return ida_bytes.is_strlit(fl)
        if kind == "byte":
            return ida_bytes.is_byte(fl)
        if kind == "word":
            return ida_bytes.is_word(fl)
        if kind == "double":
            return ida_bytes.is_double(fl)
        if kind == "dword":
            return ida_bytes.is_dword(fl)
        if kind == "dword_off":
            return ida_bytes.is_dword(fl) and ida_bytes.is_off0(fl)
        return False

    nfail = 0
    for r in rd(os.path.join(OUT, "data-items.tsv")):
        ea, size, kind, arg, nm = int(r["ea"], 16), int(r["size"]), r["kind"], r["arg"], r["name"]
        if not same(ea, size, kind, arg):
            for x in range(ea, ea + size):
                if ida_bytes.is_code(ida_bytes.get_flags(x)):
                    raise RuntimeError("refusing to overwrite code at %08X for data %08X" % (x, ea))
            hd = ida_bytes.get_item_head(ea)
            if hd != ea and ida_bytes.is_data(ida_bytes.get_flags(hd)):
                note("2", "undef_overlap", hd, "%d" % ida_bytes.get_item_size(hd))
                ida_bytes.del_items(hd, ida_bytes.DELIT_SIMPLE, ida_bytes.get_item_size(hd))
            before = []
            x = ea
            while x < ea + size:
                fl = ida_bytes.get_flags(x)
                if ida_bytes.is_data(fl) and ida_bytes.get_item_head(x) == x:
                    before.append("%08X:%d" % (x, ida_bytes.get_item_size(x)))
                    x += ida_bytes.get_item_size(x)
                else:
                    x += 1
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, size)
            if kind == "struct":
                ok = ida_bytes.create_struct(ea, size, tids[arg])
            elif kind == "strlit":
                ok = ida_bytes.create_strlit(ea, size, ida_nalt.STRTYPE_C)
            elif kind == "byte":
                ok = ida_bytes.create_byte(ea, size)
            elif kind == "word":
                ok = ida_bytes.create_word(ea, size)
            elif kind == "double":
                ok = ida_bytes.create_double(ea, size)
            elif kind in ("dword", "dword_off"):
                ok = ida_bytes.create_dword(ea, size)
                if ok and kind == "dword_off":
                    ida_offset.op_plain_offset(ea, 0, 0)
            else:
                raise RuntimeError("unknown kind %s" % kind)
            if not ok or not same(ea, size, kind, arg):
                nfail += 1
                note("2", "create_FAIL", ea, "%s %s %d" % (kind, arg, size))
            else:
                note("2", "create_" + kind, ea, "%d %s%s" % (size, arg, (" replaced " + ",".join(before)) if before else ""))
        if nm:
            cur = ida_name.get_name(ea)
            if cur != nm and (not cur or cur.startswith(("unk_", "byte_", "dword_", "off_", "word_", "asc_", "stru_", "dbl_", "flt_"))):
                ida_name.set_name(ea, nm, ida_name.SN_NOWARN | ida_name.SN_NOCHECK)
                note("2", "name", ea, nm)
    log("data items failed %d" % nfail)

    # ---------------------------------------------------------------- 3. auto-analysis, measure
    ida_auto.plan_range(LO, HI)
    ida_auto.auto_wait()
    post_heads, post_fns = snapshot()
    hadd = [e for e in post_heads if e not in pre_heads or pre_heads[e] != post_heads[e]]
    hdel = [e for e in pre_heads if e not in post_heads]
    fadd = [s for s in post_fns if s not in pre_fns]
    fdel = [s for s in pre_fns if s not in post_fns]
    fchg = [s for s in post_fns if s in pre_fns and post_fns[s] != pre_fns[s]]
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
    code_pre = sum(v[0] for v in pre_heads.values() if v[1] == "c")
    code_post = sum(v[0] for v in post_heads.values() if v[1] == "c")
    unk = 0
    ea = 0xFFED0000
    while ea < 0xFFF50000:
        if ida_bytes.is_unknown(ida_bytes.get_flags(ea)):
            unk += 1
        ea += 1
    for (step, action), n in sorted(cnt.items()):
        log("step %s %-18s %d" % (step, action, n))
    log("PASS %s: items changed/added %d removed %d ; functions +%d -%d ~%d ; functions now %d ; code bytes in %08X-%08X %d -> %d ; window unexplored bytes %d"
        % (PASS, len(hadd), len(hdel), len(fadd), len(fdel), len(fchg), len(post_fns), LO, HI, code_pre, code_post, unk))
    log("done")
    chg.close()


try:
    os.makedirs(RAW, exist_ok=True)
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

r"""Lane G1 -- absorb the H8SX-only instructions into the PRIVATE G1_H8S database.

Precondition: g1_sx_switch.py already switched G1_H8S from h8s300a to IDA's own
H8SX advanced variant (h8sxa), so ida_ua decodes the H8SX forms natively.

Input  ida\out\h8s-decode\work\absorb_plan.json  (built offline from the
       binutils-verified site list): every accepted site and every downstream
       instruction (addr, len, tier, origin site), plus the odd-aligned IDA
       code heads (impossible on H8) that overlap a planned instruction.
Steps  1 delete the odd-aligned overlaps, 2 create each planned instruction and
       check its length against the plan, 3 auto_wait, 4 re-derive bounds of
       every function whose end/chunk end touches a planned instruction,
       5 restore any function end the re-derive shortened, 6 undo one IDA side
       effect and add the two true entry points, then dump the per-insn result.
Nothing outside the plan is deleted. The closed service window 0x078106+ is
not in the plan and is not touched.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, json, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_ida, ida_lines, ida_idp, idautils, idc

ROOT = str(_REPO)
WORK = os.path.join(ROOT, "ida", "out", "h8s-decode", "work")
LOG = os.path.join(WORK, "g1_absorb.log")
LO, HI = 0, 0x07B754
W0 = 0x078106
# IDA-created code from a data offset into ASCII text (W2-8 run type `string`)
SIDE_EFFECT_JUNK = (0x0458D8,)
# real entries (F1 jumptable 0x04AB70 targets) inside F1 rows 04DE6E / 04DF72
TRUE_ENTRIES = (0x04DE94, 0x04DF98)


def txt(ea):
    return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "")


def main(log):
    ida_auto.auto_wait()
    proc = ida_ida.inf_get_procname()
    log.write("procname=%s\n" % proc)
    if proc != "h8sxa":
        raise RuntimeError("expected h8sxa, got %s" % proc)
    plan = json.load(open(os.path.join(WORK, "absorb_plan.json"), encoding="utf-8"))
    insns = plan["insns"]
    sites = {a: (n, t) for a, n, t in plan["sites"]}
    planned = {a: (n, t, o) for a, n, t, o in insns}
    assert all(a < W0 for a in planned), "plan enters the closed window"

    # 1. odd-aligned code heads overlapping planned instructions
    nodd = 0
    for ea in plan["odd_replace"]:
        if ida_bytes.is_head(ida_bytes.get_flags(ea)):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            nodd += 1
    log.write("odd-aligned heads deleted: %d\n" % nodd)

    # 2. create planned instructions
    res = {}
    deleted_heads = []
    for a, (n, tier, origin) in sorted(planned.items()):
        fl = ida_bytes.get_flags(a)
        if ida_bytes.is_code(fl) and ida_bytes.is_head(fl) and ida_bytes.get_item_size(a) == n:
            res[a] = "already"
            continue
        # clear every item that overlaps [a, a+n)
        h = ida_bytes.get_item_head(a)
        if h != a and h != idc.BADADDR:
            deleted_heads.append((h, ida_bytes.get_item_size(h), "code" if ida_bytes.is_code(ida_bytes.get_flags(h)) else "data/unk"))
            ida_bytes.del_items(h, ida_bytes.DELIT_SIMPLE, 1)
        x = a
        while x < a + n:
            fx = ida_bytes.get_flags(x)
            if ida_bytes.is_head(fx):
                deleted_heads.append((x, ida_bytes.get_item_size(x), "code" if ida_bytes.is_code(fx) else "data/unk"))
                ida_bytes.del_items(x, ida_bytes.DELIT_SIMPLE, 1)
            x += 1
        got = ida_ua.create_insn(a)
        res[a] = "created" if got == n else ("SIZE_MISMATCH %d" % got if got else "FAILED")
    ida_auto.auto_wait()
    with open(os.path.join(WORK, "absorb_deleted.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("ea\tsize\tkind\n")
        for h, s, k in deleted_heads:
            fh.write("%06X\t%d\t%s\n" % (h, s, k))
    # re-check after auto analysis
    for a, (n, tier, origin) in planned.items():
        fl = ida_bytes.get_flags(a)
        if not (ida_bytes.is_code(fl) and ida_bytes.is_head(fl) and ida_bytes.get_item_size(a) == n):
            res[a] = (res.get(a, "") + " LOST").strip()

    # 4. re-derive bounds of functions that touch planned code
    touched = []
    for fs in list(idautils.Functions(LO, HI)):
        f = ida_funcs.get_func(fs)
        if f is None:
            continue
        hit = any(ce in planned for (cs, ce) in idautils.Chunks(fs))
        if not hit:
            # a planned site inside the function body also counts
            for a in sites:
                if f.start_ea <= a < f.end_ea:
                    hit = True
                    break
        if hit:
            touched.append((f.start_ea, f.end_ea))
    fres = []
    for (s, e) in touched:
        ida_funcs.del_func(s)
        ok = ida_funcs.add_func(s)
        f = ida_funcs.get_func(s)
        if not ok or f is None:
            ida_funcs.add_func(s, e)
            f = ida_funcs.get_func(s)
            fres.append((s, e, f.end_ea if f else 0, "restored"))
        else:
            fres.append((s, e, f.end_ea, "rederived"))
    ida_auto.auto_wait()

    # 5. never let a re-derive shrink a function: put the old end back
    #    (fall back to the derived bounds when another function now owns the tail)
    restored = []
    for i, (s, e, ne, k) in enumerate(fres):
        if k == "rederived" and ne < e:
            ida_funcs.del_func(s)
            r = ida_funcs.add_func(s, e)
            if not r:
                ida_funcs.add_func(s)
            f = ida_funcs.get_func(s)
            restored.append((s, e, ne, f.end_ea if f else 0, r))
    # 6. undo IDA side effects that the decode did not cause, and restore the
    #    two F1 entry points whose IDA heads sat on ASCII text (see doc 36)
    created = []
    for junk in SIDE_EFFECT_JUNK:
        f = ida_funcs.get_func(junk)
        if f and f.start_ea == junk:
            end = f.end_ea
            ida_funcs.del_func(junk)
            ida_bytes.del_items(junk, ida_bytes.DELIT_SIMPLE, end - junk)
            log.write("removed side-effect function/code %06X-%06X\n" % (junk, end))
    for ent in TRUE_ENTRIES:
        if not ida_funcs.get_func(ent):
            ok = ida_funcs.add_func(ent)
            f = ida_funcs.get_func(ent)
            created.append((ent, ent, ok, f.start_ea if f else 0, f.end_ea if f else 0))
    ida_auto.auto_wait()
    for s, e, ne, now, r in restored:
        log.write("restore %06X old_end=%06X derived_end=%06X now_end=%06X add_func(old)=%r\n" % (s, e, ne, now, r))

    with open(os.path.join(WORK, "absorb_result.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("ea\tlen\ttier\torigin\tis_site\tresult\tfunc\ttext\n")
        for a, (n, tier, origin) in sorted(planned.items()):
            f = ida_funcs.get_func(a)
            fh.write("%06X\t%d\t%s\t%06X\t%d\t%s\t%s\t%s\n" % (a, n, tier, origin, 1 if a in sites else 0, res.get(a, "?"),
                                                            ("%06X" % f.start_ea) if f else "-", txt(a)))
    with open(os.path.join(WORK, "absorb_funcs.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("kind\tsite_or_start\told_end_or_head\tok\tnew_start\tnew_end\n")
        for s, e, ne, k in fres:
            fh.write("rederive\t%06X\t%06X\t%s\t%06X\t%06X\n" % (s, e, k, s, ne))
        for a, h, ok, s, e in created:
            fh.write("create\t%06X\t%06X\t%s\t%06X\t%06X\n" % (a, h, ok, s, e))
    from collections import Counter
    log.write("results %s\n" % dict(Counter(v.split()[0] if v else "?" for v in res.values())))
    log.write("touched functions %d, created attempts %d\n" % (len(fres), len(created)))


try:
    with open(LOG, "w", encoding="utf-8") as log:
        main(log)
except Exception:
    with open(LOG, "a", encoding="utf-8") as log:
        log.write(traceback.format_exc())
idc.qexit(0)

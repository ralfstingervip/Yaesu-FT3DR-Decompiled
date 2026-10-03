# -*- coding: utf-8 -*-
r"""Lane H3 reusable job: apply MAIN pointer-array -> code xrefs to any MAIN
database copy (H8S/H8SX advanced, big-endian, base 0), optionally together with
G2's 149-table xrefs, then (survival mode) re-analyse and measure how many of
F1's 444 indirect-only proved functions survive as functions with an incoming
xref.

TSV format (header required, extra columns ignored):
  from_table_entry <TAB> target [<TAB> array <TAB> index <TAB> tier]
Rows whose 'tier' column is present and not in H3_TIERS (default "ABC") are
skipped. G2's table-xrefs.tsv has no tier column and is applied in full.

Environment
  H3_XREF_TSV   ';'-separated TSV list, relative to the workspace root.
                default: ida\out\main-banks\table-xrefs.tsv;ida\out\ptr-arrays\xrefs.tsv
  H3_TIERS      tiers to apply from tiered TSVs (default ABC)
  H3_MODE       'apply' (default): apply + auto_wait only
                'survival': count before, apply, plan_and_wait(0x400,0x7B754),
                            count after, write survival + residual state
  H3_TAG        output name stem (default = YAESU_JOB)

Run:
  python ida\run_job.py --script ida\jobs\h3_apply_ptr_xrefs.py --db <YOURDB> \
      --copy-from ida\db\jobs\FIN_MAIN_IND\FIN_MAIN_IND.i64 --env H3_MODE=survival

Each slot becomes a dword with a 32-bit offset operand plus an explicit user
data xref slot->target; the target is made code and a function if it is not one.
Idempotent. Never touches bytes.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, ida_bytes, ida_funcs, ida_offset, ida_xref, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "ptr-arrays")
LO, HI = 0x400, 0x7B754
DEFAULT = r"ida\out\main-banks\table-xrefs.tsv;ida\out\ptr-arrays\xrefs.tsv"


def _abs(p):
    return p if os.path.isabs(p) else os.path.join(ROOT, p)


def apply_from_tsv(path, tiers="ABC"):
    """Returns (rows_applied, funcs_made, skipped)."""
    rows = funcs = skipped = 0
    with open(path, encoding="utf-8") as h:
        hdr = h.readline().rstrip("\n").split("\t")
        tcol = hdr.index("tier") if "tier" in hdr else -1
        for line in h:
            p = line.rstrip("\n").split("\t")
            if len(p) < 2 or not p[0] or p[0].startswith("#"):
                continue
            if tcol >= 0 and len(p) > tcol and p[tcol] not in tiers:
                skipped += 1
                continue
            try:
                entry = int(p[0], 16)
                target = int(p[1], 16)
            except ValueError:
                continue
            rows += 1
            ida_bytes.del_items(entry, ida_bytes.DELIT_SIMPLE, 4)
            ida_bytes.create_dword(entry, 4)
            try:
                ida_offset.op_offset(entry, 0, idc.REF_OFF32)
            except Exception:
                pass
            ida_xref.add_dref(entry, target, ida_xref.dr_O | ida_xref.XREF_USER)
            if not ida_bytes.is_code(ida_bytes.get_flags(target)):
                idc.create_insn(target)
            if ida_funcs.get_func(target) is None:
                if ida_funcs.add_func(target):
                    funcs += 1
    return rows, funcs, skipped


def _rows(path):
    with open(path, encoding="utf-8") as h:
        next(h)
        return [l.rstrip("\n").split("\t") for l in h if l.strip()]


def _has_xref(ea):
    for _ in idautils.CodeRefsTo(ea, 0):
        return True
    for _ in idautils.DataRefsTo(ea):
        return True
    return False


def _isfunc(ea):
    f = ida_funcs.get_func(ea)
    return f is not None and f.start_ea == ea


def _survival_counts(proved):
    strict = [s for s, r in proved if _isfunc(s) and _has_xref(s)]
    corr = [s for s, r in proved if _isfunc(r) and _has_xref(r)]
    return strict, corr


def main():
    ida_auto.auto_wait()
    mode = os.environ.get("H3_MODE", "apply")
    tiers = os.environ.get("H3_TIERS", "ABC")
    tag = os.environ.get("H3_TAG", os.environ.get("YAESU_JOB", "h3"))
    tsvs = [_abs(p) for p in os.environ.get("H3_XREF_TSV", DEFAULT).split(";") if p]
    os.makedirs(OUT, exist_ok=True)
    log = []

    proved = []
    if mode == "survival":
        for p in _rows(os.path.join(ROOT, "ida", "out", "main-indirect", "proved.tsv")):
            s = int(p[0], 16)
            m = re.search(r"inside->([0-9A-F]+)", p[8] if len(p) > 8 else "")
            proved.append((s, int(m.group(1), 16) if m else s))
        b_strict, b_corr = _survival_counts(proved)
        log.append("BEFORE strict %d/%d corrected %d/%d" % (len(b_strict), len(proved), len(b_corr), len(proved)))

    for t in tsvs:
        r, f, sk = apply_from_tsv(t, tiers)
        log.append("applied %s rows=%d funcs_made=%d skipped=%d" % (t, r, f, sk))
    ida_auto.auto_wait()

    if mode == "survival":
        ida_auto.plan_and_wait(LO, HI)
        ida_auto.auto_wait()
        a_strict, a_corr = _survival_counts(proved)
        fn_at = sum(1 for s, r in proved if _isfunc(s))
        log.append("AFTER still-function-at-start %d/%d" % (fn_at, len(proved)))
        log.append("AFTER strict (function at proved start AND incoming xref) %d/%d" % (len(a_strict), len(proved)))
        log.append("AFTER corrected (function at cited reach point AND incoming xref) %d/%d" % (len(a_corr), len(proved)))
        ss = set(a_strict)
        cs = set(a_corr)
        with open(os.path.join(OUT, tag + "_survival_rows.tsv"), "w", encoding="utf-8", newline="\n") as h:
            h.write("start\treach_point\tstrict\tcorrected\tfunc_containing_start\n")
            for s, r in proved:
                f = ida_funcs.get_func(s)
                h.write("%06X\t%06X\t%d\t%d\t%s\n" % (s, r, s in ss, s in cs,
                        "%06X-%06X" % (f.start_ea, f.end_ea) if f else "-"))
        # state of every residual function after re-analysis
        with open(os.path.join(OUT, tag + "_residual_state.tsv"), "w", encoding="utf-8", newline="\n") as h:
            h.write("start\tend\tis_code\tfunc\tfunc_start\tfunc_end\tncref\tndref\tdref_from\n")
            for p in _rows(os.path.join(ROOT, "ida", "out", "main-indirect", "residual.tsv")):
                s = int(p[0], 16)
                f = ida_funcs.get_func(s)
                cr = [x for x in idautils.CodeRefsTo(s, 0)]
                dr = [x for x in idautils.DataRefsTo(s)]
                h.write("%06X\t%s\t%d\t%d\t%s\t%s\t%d\t%d\t%s\n" % (
                    s, p[1], ida_bytes.is_code(ida_bytes.get_flags(s)), f is not None,
                    "%06X" % f.start_ea if f else "-", "%06X" % f.end_ea if f else "-",
                    len(cr), len(dr), ",".join("%06X" % x for x in dr[:6])))
        nf = sum(1 for _ in idautils.Functions(LO, HI))
        log.append("functions in 0x400-0x7B754 after: %d" % nf)

    with open(os.path.join(OUT, tag + "_apply_log.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(log) + "\n")


if __name__ == "__main__":
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "h3_apply_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
            h.write(traceback.format_exc())
    finally:
        idc.qexit(0)

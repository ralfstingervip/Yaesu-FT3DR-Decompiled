r"""Lane K5 - list the containing function and its callers for given code sites (read-only).

Env: K5_SITES = comma-separated hex EAs; K5_SOUT = output file name under ida\out\dsp-payload-labels.
    python "ida/run_job.py" --script ida\jobs\k5_readers.py --db K5_MAIN --reopen --env K5_SITES=... --env K5_SOUT=...
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

OUTDIR = str(_REPO / "ida/out/dsp-payload-labels")


def main():
    import ida_auto, ida_funcs, idautils
    ida_auto.auto_wait()
    sites = [int(x, 16) for x in os.environ.get("K5_SITES", "").split(",") if x]
    out = []
    for s in sites:
        f = ida_funcs.get_func(s)
        if not f:
            out.append("%06X no fn" % s)
            continue
        callers = sorted(set(x.frm for x in idautils.XrefsTo(f.start_ea)))
        cf = []
        for c in callers:
            g = ida_funcs.get_func(c)
            cf.append(g.start_ea if g else c)
        out.append("%06X fn %06X-%06X callers %s callerfns %s" % (
            s, f.start_ea, f.end_ea,
            " ".join("%06X" % c for c in callers[:12]),
            " ".join("%06X" % c for c in cf[:12])))
    with open(os.path.join(OUTDIR, os.environ.get("K5_SOUT", "k5_sites.txt")), "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(OUTDIR, "k5_readers_error.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
import idc
idc.qexit(0)

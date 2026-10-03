"""Trivial probe: confirm a headless IDA job can run, and report version."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, ida_auto, ida_ida, idc, ida_loader

out = os.path.join(str(_REPO / "ida/out/probe"))
os.makedirs(out, exist_ok=True)
ida_auto.auto_wait()
job = os.environ.get("YAESU_JOB", "?")
with open(os.path.join(out, job + ".txt"), "w", encoding="utf-8", newline="\n") as f:
    f.write("job %s\n" % job)
    f.write("ida_version %s\n" % idc.get_inf_attr(idc.INF_VERSION))
    f.write("procname %s\n" % ida_ida.inf_get_procname())
    f.write("min %#x max %#x\n" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
    try:
        import ida_hexrays
        f.write("hexrays_init %s\n" % ida_hexrays.init_hexrays_plugin())
    except Exception as exc:
        f.write("hexrays_error %s\n" % exc)
idc.qexit(0)

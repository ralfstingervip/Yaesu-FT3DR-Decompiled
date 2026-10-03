"""SUB-USB job 0: open the seeded SUB database, report layout and coverage."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-usb")
os.makedirs(OUT, exist_ok=True)
LOG = os.path.join(OUT, "job0_open.txt")
try:
    import ida_auto, ida_ida, ida_segment, ida_funcs, idautils, idc, ida_bytes
    ida_auto.auto_wait()
    lines = []
    lines.append("procname %s" % ida_ida.inf_get_procname())
    lines.append("min %#x max %#x" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
    seg = ida_segment.get_first_seg()
    while seg:
        lines.append("seg %-8s %#010x-%#010x class=%s" % (
            ida_segment.get_segm_name(seg), seg.start_ea, seg.end_ea,
            ida_segment.get_segm_class(seg)))
        seg = ida_segment.get_next_seg(seg.start_ea)
    funcs = list(idautils.Functions())
    lines.append("functions %d" % len(funcs))
    # histogram by 256 KB bucket
    hist = {}
    for f in funcs:
        hist[f >> 18] = hist.get(f >> 18, 0) + 1
    for k in sorted(hist):
        lines.append("bucket %#010x count %d" % (k << 18, hist[k]))
    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(lines) + "\n")
except Exception:
    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
import idc
idc.qexit(0)

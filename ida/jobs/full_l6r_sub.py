r"""Lane 6 respawn: read-only. Screen-handler table 0xFFED4050 entries 0x1C..0x22,
the _INITSCT DTBL (0xFFED8A34..0xFFED8A58, {src,end,dst}) entry covering
0x69310, and the first 4 dwords of the ROM source image for 0x69310."""

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import idc

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, "ida", "out", "extension")
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", os.environ.get("YAESU_JOB", "EXT_MENU"))
os.makedirs(LOGDIR, exist_ok=True)
LOG = []


def d(ea):
    return ida_bytes.get_dword(ea)


def fname(ea):
    f = ida_funcs.get_func(ea)
    return ida_funcs.get_func_name(f.start_ea) if f else "-"


def main():
    ida_auto.auto_wait()
    rows = ["#screen_table FFED4050"]
    for i in range(0x1C, 0x23):
        ea = 0xFFED4050 + 4 * i
        v = d(ea)
        rows.append("scr\t%02X\t%08X\t%08X\t%s" % (i, ea, v, fname(v)))
    rows.append("#dtbl FFED8A34..FFED8A58 {src,end,dst}")
    for ea in range(0xFFED8A34, 0xFFED8A58, 12):
        s, e, t = d(ea), d(ea + 4), d(ea + 8)
        hit = t <= 0x69310 < t + (e - s)
        rows.append("dtbl\t%08X\tsrc=%08X\tend=%08X\tdst=%08X\tcovers_69310=%s" % (ea, s, e, t, hit))
        if hit:
            src = s + (0x69310 - t)
            rows.append("src_for_69310\t%08X" % src)
            for k in range(4):
                v = d(src + 4 * k)
                rows.append("ptr\t%d\t%08X\t%08X" % (k, src + 4 * k, v))
    with open(os.path.join(OUT, "menus-l6r-sub.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(rows) + "\n")


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "full_l6r_sub.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

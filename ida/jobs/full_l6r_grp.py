r"""Lane 6 respawn: read-only dump of the SUB setup group table 0xFFED74E8
(8-byte entries, 1-based index) and the 0xFFC3DF35 title-length bytes."""

import os
import traceback

import ida_auto
import ida_bytes
import idc

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, "ida", "out", "extension")
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", os.environ.get("YAESU_JOB", "EXT_MENU"))
os.makedirs(LOGDIR, exist_ok=True)
LOG = []


def main():
    ida_auto.auto_wait()
    base = 0xFFED74E8
    rows = ["idx\tentry_ea\traw8\tcount\tptr"]
    for g in range(0, 25):
        ea = base + g * 8
        raw = ida_bytes.get_bytes(ea, 8)
        cnt = raw[0]
        ptr = int.from_bytes(raw[4:8], "little")
        rows.append("%d\t%08X\t%s\t%d\t%08X" % (g, ea, " ".join("%02X" % b for b in raw), cnt, ptr))
    t = ida_bytes.get_bytes(0xFFC3DF35, 24)
    rows.append("#title_len FFC3DF35\t" + " ".join("%02X" % b for b in t))
    with open(os.path.join(OUT, "menus-l6r-groups.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(rows) + "\n")


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "full_l6r_grp.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

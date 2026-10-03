r"""Lane 6 respawn: read-only. MAIN F301 jump table 0x9712 (13 x u32), each
target's first instruction, and the 0x9746 per-row-code scroll bytes (32)."""

import os
import traceback

import ida_auto
import ida_bytes
import idc

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, "ida", "out", "extension")
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", os.environ.get("YAESU_JOB", "EXT_MENU_MAIN"))
os.makedirs(LOGDIR, exist_ok=True)
LOG = []


def main():
    ida_auto.auto_wait()
    rows = ["#jt 9712"]
    for i in range(14):
        ea = 0x9712 + 4 * i
        raw = ida_bytes.get_bytes(ea, 4)
        v = int.from_bytes(raw, "big")
        rows.append("jt\t%d\t%06X\t%s\t%06X\t%s" % (i, ea, raw.hex(), v, idc.generate_disasm_line(v, 1) or "?"))
    rows.append("#9746\t" + ida_bytes.get_bytes(0x9746, 36).hex())
    with open(os.path.join(OUT, "menus-l6r-main.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(rows) + "\n")


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "full_l6r_main.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

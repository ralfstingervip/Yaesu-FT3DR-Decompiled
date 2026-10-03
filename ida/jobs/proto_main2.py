r"""PROTOCOLS job 4: MAIN annotated disassembly of the protocol windows.

db PROTO_MAIN, --reopen.  Assumes proto_main.py already force-coded the image.
Dumps the windows that carry the answer, plus a per-function dump of every
function that references a protocol table or string.

Output: ida\out\protocols\asm\main_*.asm
"""

from __future__ import annotations

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import ida_auto
import ida_funcs
import idautils
import idc

import proto_lib as L

WINDOWS = [
    (0x0005A000, 0x0005B400, "dsp_link_driver"),
    (0x0005C700, 0x0005D340, "fusion_mode_fn_sub_5C7DE"),
    (0x00068240, 0x00068400, "perm126_reader"),
    (0x00034740, 0x00034C40, "ctcss_band_fn"),
    (0x0000D120, 0x0000D300, "tone_dcs_ui_sub_D13E"),
    (0x00025EA0, 0x000260E0, "dcs_reader_sub_25EAE"),
    (0x0000C800, 0x0000C900, "dtmf_sub_C814"),
    (0x000502C0, 0x00050440, "aprs_msgtype_sub_502D2"),
    (0x00006240, 0x000062A0, "aprs_symbol_reader"),
    (0x0005C500, 0x0005C700, "pre_fusion_mode"),
]

# every function that touches one of these gets dumped whole
INTEREST = [0x0005AE1C, 0x0005D2F2, 0x00035158, 0x00005072, 0x0005DF52,
            0x0000C8CA, 0x000503F0, 0x00008264]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    with L.open_asm("main_windows.asm") as h:
        for lo, hi, name in WINDOWS:
            L.dump_range(h, lo, hi, name)
            h.write("\n\n")

    # functions that reference the interest set, dumped whole
    fns = set()
    for a in INTEREST:
        for frm, kind, fname in L.xrefs_to(a):
            fn = ida_funcs.get_func(frm)
            if fn is not None:
                fns.add((fn.start_ea, fn.end_ea))
    with L.open_asm("main_interest_funcs.asm") as h:
        for s, e in sorted(fns):
            L.dump_range(h, s, e, "func %s" % (idc.get_func_name(s) or "%08X" % s))
            h.write("\n")

    with L.open_out("main_dump_done.txt") as h:
        h.write("windows %d\ninterest_funcs %d\n" % (len(WINDOWS), len(fns)))


main()

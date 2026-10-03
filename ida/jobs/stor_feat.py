"""STORAGE pass 5: dump the specific function bodies that decide feature
ownership, the message dispatcher, the GPS-log writer and the camera screen.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import sys

sys.path.insert(0, str(_REPO / "ida/jobs"))

import ida_auto
import ida_bytes
import ida_funcs
import ida_xref
import idautils
import idc

import stor_lib as L

BASE = 0xFFC00000

FUNCS = [
    0xFFF0B665,  # display-message dispatcher (FIRM ERROR etc.)
    0xFFF3B8DE,  # path_get_dir_bare
    0xFFF12A8F,  # path_get_dir_drive
    0xFFF3C765, 0xFFF3C911, 0xFFF3CAD0, 0xFFF3CE12, 0xFFF3CFD8,
    0xFFF3D0D9, 0xFFF3D209, 0xFFF3D2FD, 0xFFF3D3C7, 0xFFF3D48F,
    0xFFF3D680, 0xFFF3D887, 0xFFF3DE6A, 0xFFF3DF66, 0xFFF3E398,
    0xFFF3E4A7, 0xFFF3E98C, 0xFFF3EB8C, 0xFFF3EE00, 0xFFF3EECA,
    0xFFF3BB0C, 0xFFF3BA24,
    0xFFF13DDA,  # wav filename builder
    0xFFF14194,  # wav header writer
    0xFFF140C7,  # Backup.bin
    0xFFF12C25, 0xFFF12D95, 0xFFF12E8B, 0xFFF12F9B, 0xFFF130F3,
    0xFFF131AA, 0xFFF138AB, 0xFFF13A00, 0xFFF1427F, 0xFFF14576,
    0xFFF149AB, 0xFFF14BFA, 0xFFF14E1F,
    0xFFF35454,  # sector write primitive
    0xFFF3365E, 0xFFF336DC,  # response / CSD
    0xFFF33760, 0xFFF337D7, 0xFFF33961,
    0xFFF08201,  # camera settings
    0xFFF35D0B, 0xFFF35A08,
]

RANGES = [
    ("mkfs_top", 0x335400, 0x336300),
    ("msgdisp", 0x30B200, 0x30B800),
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    with L.open_asm("features.asm") as h:
        for fa in FUNCS:
            f = ida_funcs.get_func(fa)
            if f is None:
                h.write("; ==== %08X  NO FUNCTION ====\n" % fa)
                continue
            callers = ["%08X(%s)" % (c, idc.get_func_name(c) or "")
                       for c in idautils.CodeRefsTo(f.start_ea, 0)]
            h.write("\n; ######## %s  %08X-%08X (file %06X) callers: %s\n"
                    % (idc.get_func_name(fa) or "", f.start_ea, f.end_ea,
                       f.start_ea - BASE, ", ".join(callers[:14])))
            L.dump_range(h, f.start_ea, f.end_ea)
    with L.open_asm("ranges2.asm") as h:
        for label, lo, hi in RANGES:
            L.dump_range(h, BASE + lo, BASE + hi, label)
    with L.open_out("pass5_log.txt") as h:
        h.write("done\n")


main()

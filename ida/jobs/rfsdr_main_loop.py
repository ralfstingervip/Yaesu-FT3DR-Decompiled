"""RF-SDR pass 5 on MAIN: the main loop, the retune entry, and the scan engine.

Dumps the routines the call graph identified as the pacing layer of the receive
chain: sub_2AA0 (dispatcher), sub_30E0 (analog/control task), sub_34538 and
sub_378A2 / sub_377C2 (retune), sub_2F1DA (scan), plus the tune arithmetic.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import sys

sys.path.insert(0, str(_REPO / "ida/jobs"))

import ida_auto
import ida_bytes
import idc

import rfsdr_lib as L

WINDOWS = [
    ("mainloop", 0x2AA0, 0x2E60),
    ("analog_task", 0x30A2, 0x3300),
    ("retune", 0x34538, 0x34800),
    ("tune_entry2", 0x377C2, 0x37A30),
    ("scan_engine", 0x2F1DA, 0x2F420),
    ("ctrl12", 0x312E0, 0x31400),
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    for _n, lo, hi in WINDOWS:
        L.force_code(lo, hi)
    ida_auto.auto_wait()
    for name, lo, hi in WINDOWS:
        with L.open_asm("main4_%s.asm" % name) as h:
            L.dump_range(h, lo, hi, name)
    _ = ida_bytes, idc


main()

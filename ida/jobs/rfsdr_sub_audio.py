"""RF-SDR pass 2 on SUB: the 16 kHz audio sample path.

Dumps the S12AD0 scan-end ISR (INTB slot 134 -> 0xFFF15A18) in full, the MTU6
TGIA ISR (slot 210 -> 0xFFF1527B), and the buffer bookkeeping around the
control block at 0x00020278, so the destination of the only real sample stream
in the radio can be stated.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import sys

sys.path.insert(0, str(_REPO / "ida/jobs"))

import ida_auto
import idc

import rfsdr_lib as L

BASE = 0xFFC00000
WINDOWS = [
    ("audio_isr", 0x315A18, 0x315E80),
    ("audio_isr2", 0x315280, 0x315600),
    ("dac_play", 0x3159DF, 0x315A18),
    ("s12ad1_tail", 0x2E15B0, 0x2E1780),
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    for _n, lo, hi in WINDOWS:
        L.force_code(BASE + lo, BASE + hi)
    ida_auto.auto_wait()
    for name, lo, hi in WINDOWS:
        with L.open_asm("sub2_%s.asm" % name) as h:
            L.dump_range(h, BASE + lo, BASE + hi, name)
    _ = idc


main()

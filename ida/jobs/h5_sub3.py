# -*- coding: utf-8 -*-
"""Lane H5 - SUB pass 3 (private DB H5_SUB, --reopen).
Forward windows after every 32-bit `mov.l #imm, rX` whose imm is one of the
classifier state bytes, plus forward dumps of listed addresses.
Env H5_VALS = comma list of hex values, H5_DUMPS = comma list of hex addr:len.
Output: ida\out\ipc-reach\sub_probe3.txt
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idc

ROOT = str(_REPO)
OUTD = os.path.join(ROOT, "ida", "out", "ipc-reach")
BASE = 0xFFC00000


def mk(a):
    if not ida_bytes.is_code(ida_bytes.get_flags(a)):
        ida_bytes.del_items(a, 0, 8)
        ida_ua.create_insn(a)


def win(h, a, n):
    for _ in range(n):
        mk(a)
        insn = ida_ua.insn_t()
        L = ida_ua.decode_insn(insn, a)
        if L <= 0:
            h.write("    %08X ??\n" % a)
            return
        h.write("    %08X  %-22s %s\n" % (a, ida_bytes.get_bytes(a, L).hex(" "),
                                           (idc.generate_disasm_line(a, 0) or "?").split(";")[0]))
        a += L


def main():
    ida_auto.auto_wait()
    vals = [int(x, 16) for x in os.environ.get("H5_VALS", "").split(",") if x]
    dumps = [tuple(int(y, 16) for y in x.split(":")) for x in os.environ.get("H5_DUMPS", "").split(",") if x]
    nwin = int(os.environ.get("H5_WIN", "8"))
    tag = os.environ.get("H5_TAG", "3")
    data = ida_bytes.get_bytes(BASE, 0x400000)
    with open(os.path.join(OUTD, "sub_probe%s.txt" % tag), "w", encoding="utf-8", newline="\n") as h:
        for a, n in dumps:
            h.write("\n==== dump %08X +%X ====\n" % (a, n))
            win(h, a, n)
        for v in vals:
            h.write("\n==== mov.l #%X hits ====\n" % v)
            pat = re.compile(re.escape(b"\x00") + b"([\x02-\xf2])" + re.escape(v.to_bytes(4, "little")), re.S)
            body = v.to_bytes(4, "little")
            i = data.find(body)
            while i >= 0:
                if i >= 2 and data[i - 2] == 0xFB and (data[i - 1] & 0x0F) == 0x02:
                    a = BASE + i - 2
                    f = ida_funcs.get_func(a)
                    h.write("  hit %08X func %s\n" % (a, ("%08X" % f.start_ea) if f else "-"))
                    win(h, a, nwin)
                i = data.find(body, i + 1)


try:
    main()
except Exception:
    with open(os.path.join(OUTD, "h5_sub3_tb.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

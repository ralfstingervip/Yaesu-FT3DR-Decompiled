# -*- coding: utf-8 -*-
r"""Lane J9 pass 2. Dump the transmit-key chain tops and the flag setters that
pick a session type. Read-only. MAIN image, H8S, base 0."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, idc, ida_bytes, ida_funcs, ida_xref

ROOT = str(_REPO)
OUTD = os.path.join(ROOT, "ida", "out", "dsp-tx-src")
TB = os.path.join(OUTD, "j9_tb2.txt")


def disrange(lo, hi):
    out = []
    ea = lo
    while ea < hi and ea != idc.BADADDR:
        d = idc.generate_disasm_line(ea, 0) or ""
        sz = idc.get_item_size(ea)
        raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
        out.append("%06X  %-22s  %s" % (ea, " ".join("%02x" % b for b in raw), d))
        n = idc.next_head(ea, hi)
        if n <= ea:
            break
        ea = n
    return out


def func_bounds(ea):
    f = ida_funcs.get_func(ea)
    if f:
        return f.start_ea, f.end_ea
    return ea, ea + 0x80


# Writers of a RAM bit/byte: find all instructions that reference the abs16 addr
def writers(addr16):
    # addr16 like 0xB0AA -> search for abs16 operand 0xFFFFxxxx references
    res = []
    for ea, name in [(0, "")]:
        pass
    # use xref: get drefs to the full 32-bit mapped address
    full = 0xFFFF0000 | addr16
    d = ida_xref.get_first_dref_to(full)
    while d != idc.BADADDR:
        res.append(d)
        d = ida_xref.get_next_dref_to(full, d)
    return res


def main():
    ida_auto.auto_wait()
    with open(os.path.join(OUTD, "txkey-chain.txt"), "w", encoding="utf-8", newline="\n") as h:
        for lab, lo, hi in [
            ("sub_34538 (main-loop TX entry)", 0x34538, 0x34650),
            ("sub_34966 head (transmit-key handler)", 0x34966, 0x349C2),
            ("sub_34A52 (-> sub_35872)", 0x34A52, 0x34A80),
            ("sub_34A7C/34B30 helpers", 0x34A7C, 0x34B60),
            ("sub_73E58 (host-link TX entry)", 0x73E58, 0x73F00),
            ("sub_35C14/35F6A twin dispatcher", 0x35C14, 0x35D00),
            ("sub_35EDC..35F6A tail", 0x35EDC, 0x35F70),
            ("op11 tail 0590EA-059160", 0x590EA, 0x59160),
            ("sub_59DE8 mode-sum", 0x59DE8, 0x59E10),
            ("sub_593C8 (op12 r2l helper)", 0x593C8, 0x59410),
        ]:
            h.write("### %s\n" % lab)
            h.write("\n".join(disrange(lo, hi)))
            h.write("\n\n")

    # Flag setters
    with open(os.path.join(OUTD, "flag-setters.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("flag\tsite_ea\tsite_func\tdisasm\n")
        for flag, addr in [
            ("AAD4", 0xAAD4), ("B0CC", 0xB0CC), ("FF89BB", 0x89BB),
            ("B0CE", 0xB0CE), ("B0C9", 0xB0C9), ("B0AA", 0xB0AA),
            ("B0AC", 0xB0AC), ("B0AE", 0xB0AE), ("B0AB", 0xB0AB),
            ("BBF9", 0xBBF9), ("B3D8", 0xB3D8), ("B3D9", 0xB3D9),
        ]:
            for w in writers(addr):
                fn = ida_funcs.get_func_name(ida_funcs.get_func(w).start_ea) if ida_funcs.get_func(w) else ""
                d = idc.generate_disasm_line(w, 0) or ""
                h.write("%s\t%06X\t%s\t%s\n" % (flag, w, fn, d))


try:
    main()
except Exception:
    with open(TB, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

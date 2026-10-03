# -*- coding: utf-8 -*-
r"""Lane H5 - SUB pass 2 (private DB H5_SUB, --reopen).

1. Dump the routines around the classifier result (screen id 0xFF path).
2. For every `mov.l #8E46h, rX` in the image, decode the following window and
   record each byte read from the pending frame (offset 0 = opcode hi, 1 = lo)
   and the compare that follows it. Output: ida\out\ipc-reach\sub_opbyte_cmps.tsv
Creates instructions only in the private DB.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idc

ROOT = str(_REPO)
OUTD = os.path.join(ROOT, "ida", "out", "ipc-reach")
BASE = 0xFFC00000
ALL = os.environ.get("H5_ALL") == "1"

DUMPS = [
    (0xFFEDF677, 0x80, "screen-change sub_FFEDF677"),
    (0xFFEDF6E3, 0x80, "sub_FFEDF6E3"),
    (0xFFEDDF1A, 0x40, "sub_FFEDDF1A"),
    (0xFFEDDF28, 0x40, "sub_FFEDDF28"),
    (0xFFEEFB66, 0xA0, "sub_FFEEFB66"),
    (0xFFEF003F, 0x80, "sub_FFEF003F"),
    (0xFFEF002C, 0x20, "sub_FFEF002C"),
    (0xFFEDE387, 0x120, "screen 0x3E handler FFEDE387"),
    (0xFFEF2032, 0x20, "default screen handler FFEF2032"),
    (0xFFEE35DB, 0x20, "table[0xFF] target FFEE35DB"),
]


def mk(a):
    if not ida_bytes.is_code(ida_bytes.get_flags(a)):
        ida_bytes.del_items(a, 0, 8)
        ida_ua.create_insn(a)


def dis(h, a, n):
    e = a + n
    while a < e:
        mk(a)
        insn = ida_ua.insn_t()
        L = ida_ua.decode_insn(insn, a)
        if L <= 0:
            h.write("  %08X  ??\n" % a)
            a += 1
            continue
        h.write("  %08X  %-22s %s\n" % (a, ida_bytes.get_bytes(a, L).hex(" "),
                                         idc.generate_disasm_line(a, 0) or "?"))
        a += L


def imm_of(a, L):
    b = ida_bytes.get_bytes(a, L)
    # RX CMP #UIMM4: 61 ir ; CMP #UIMM8: 75 5r ii ; CMP #SIMM8: 74 0r ii ; CMP #imm16 74 ...
    if b[0] == 0x61:
        return b[1] >> 4
    if b[0] == 0x75 and (b[1] & 0xF0) == 0x50:
        return b[2]
    if b[0] == 0x74 and (b[1] & 0xF0) == 0x00:
        return b[2] if b[2] < 0x80 else b[2] - 0x100
    return None


def scan(h):
    data = ida_bytes.get_bytes(BASE, 0x400000)
    pat = re.compile(rb"\xfb[\x02-\xf2]\x46\x8e\x00\x00", re.S)
    h.write("ea_load\treg\tread_ea\toffset\tread_insn\tnext_ea\tnext_insn\tcmp_imm\tfunc\n")
    for m in pat.finditer(data):
        if (data[m.start() + 1] & 0x0F) != 0x02:
            continue
        a = BASE + m.start()
        rx = data[m.start() + 1] >> 4
        cur = a
        mk(cur)
        L = ida_ua.decode_insn(ida_ua.insn_t(), cur)
        if L != 6:
            continue
        cur += L
        for _ in range(8 if ALL else 4):
            mk(cur)
            insn = ida_ua.insn_t()
            L = ida_ua.decode_insn(insn, cur)
            if L <= 0:
                break
            t = idc.generate_disasm_line(cur, 0) or ""
            mm = re.search(r"(?:(\w+)\[r%d\]|\[r%d\])" % (rx, rx), t) if ALL else re.search(r"movu\.b\s+(?:(\w+)\[r%d\]|\[r%d\]),\s*(r\d+)" % (rx, rx), t)
            if mm:
                off = mm.group(1) or "0"
                off = int(off.rstrip("h"), 16) if off != "0" else 0
                nx = cur + L
                mk(nx)
                i2 = ida_ua.insn_t()
                L2 = ida_ua.decode_insn(i2, nx)
                t2 = idc.generate_disasm_line(nx, 0) or ""
                imm = imm_of(nx, L2) if L2 > 0 and "cmp" in t2 else None
                f = ida_funcs.get_func(a)
                h.write("%08X\tr%d\t%08X\t%d\t%s\t%08X\t%s\t%s\t%s\n" % (
                    a, rx, cur, off, t.split(";")[0].strip(), nx, t2.split(";")[0].strip(),
                    "" if imm is None else ("%X" % (imm & 0xFF)), ("%08X" % f.start_ea) if f else "-"))
                break
            cur += L


def main():
    ida_auto.auto_wait()
    os.makedirs(OUTD, exist_ok=True)
    if not ALL:
        with open(os.path.join(OUTD, "sub_probe2.txt"), "w", encoding="utf-8", newline="\n") as h:
            for a, n, name in DUMPS:
                h.write("\n==== %08X %s ====\n" % (a, name))
                dis(h, a, n)
    name = "sub_pending_uses.tsv" if ALL else "sub_opbyte_cmps.tsv"
    with open(os.path.join(OUTD, name), "w", encoding="utf-8", newline="\n") as h:
        scan(h)


try:
    main()
except Exception:
    with open(os.path.join(OUTD, "h5_sub2_tb.txt"), "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

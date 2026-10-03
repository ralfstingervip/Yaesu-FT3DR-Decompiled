r"""Lane F2 — resolve MAIN raw 'other' residue: byte-exact split of the four
>=16 B mixed code/data blocks. Reopen a private copy of MAIN_RAW
(FIN_MAIN_OTHER). Read-only w.r.t. shared DBs; writes only to my out dir.

For each of the four blocks we linear-decode from a clean instruction anchor
(the end of the preceding validated function, from functions.tsv) through the
block to the start of the following function, in RESYNC mode (on a decode
failure, drop one byte and retry). Every emitted item records ea, size, raw
bytes and the IDA disassembly text, so each code/data boundary can be read off
exactly. No Hex-Rays (H8S). Base 0 => file offset == address.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_lines, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-raw-other")
os.makedirs(OUT, exist_ok=True)
LOG = os.path.join(OUT, "ida_run.log")

# (name, block_start, block_end, anchor(=preceding fn end), win_end(=next fn start))
WINDOWS = [
    ("block1_001825", 0x001825, 0x001A40, 0x00181A, 0x001A40),
    ("block2_003A84", 0x003A84, 0x003B1D, 0x0037B6, 0x003B30),
    ("block3_0562C8", 0x0562C8, 0x0563E7, 0x056298, 0x05641E),
    ("block4_076B50", 0x076B50, 0x076BED, 0x0768C8, 0x076C04),
]
# Extra explicit alignment probes: decode a clean stream from a hand-found start.
ALIGN_PROBES = [
    ("block4_from_076B4E", 0x076B4E, 0x076C04),
    ("block3_from_056298", 0x056298, 0x05641E),
    ("block1_from_00181A", 0x00181A, 0x001A40),
]


def disasm_text(ea):
    try:
        return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0)) or ""
    except Exception:
        return "?"


def hexb(ea, n):
    b = ida_bytes.get_bytes(ea, n) or b""
    return b.hex()


def resync_decode(fh, start, end, label):
    fh.write("\n===== %s  [%06X, %06X)  len=%d =====\n" % (label, start, end, end - start))
    # clear the window in our private DB so create_insn is authoritative
    ida_bytes.del_items(start, ida_bytes.DELIT_SIMPLE, end - start)
    cur = start
    insns = 0
    datab = 0
    while cur < end:
        sz = ida_ua.create_insn(cur)
        if sz and sz > 0:
            txt = disasm_text(cur)
            fh.write("%06X  +%-2d  %-16s  C  %s\n" % (cur, sz, hexb(cur, sz), txt))
            insns += 1
            cur += sz
        else:
            fh.write("%06X  +1   %-16s  .  (byte 0x%02X)\n"
                     % (cur, hexb(cur, 1), ida_bytes.get_byte(cur)))
            datab += 1
            cur += 1
    fh.write("--- %s: %d insns, %d undecodable bytes ---\n" % (label, insns, datab))


def main():
    ida_auto.auto_wait()
    try:
        ida_auto.enable_auto(False)
    except Exception:
        pass
    with open(os.path.join(OUT, "decode.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("Lane F2 resync disassembly of MAIN raw 'other' blocks\n")
        fh.write("H8S advanced (h8s300a), big-endian, base 0; ea == file offset\n")
        for name, bs, be, anc, we in WINDOWS:
            fh.write("\n######## %s block=[%06X,%06X) anchor=%06X win_end=%06X ########\n"
                     % (name, bs, be, anc, we))
            resync_decode(fh, anc, we, name)
        for name, s, e in ALIGN_PROBES:
            resync_decode(fh, s, e, name)
    with open(LOG, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("OK: wrote decode.txt\n")


try:
    main()
except Exception:
    with open(LOG, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("TRACE\n" + traceback.format_exc())
idc.qexit(0)

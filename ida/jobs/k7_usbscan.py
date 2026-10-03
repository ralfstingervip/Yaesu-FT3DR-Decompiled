r"""Lane K7 -- whole-image regression scan of K7_SUB_FINAL3 for USB0 / USBA / FCU references.  Read-only.

    python ida/run_job.py --script ida\jobs\k7_usbscan.py --db K7_SUB_FINAL3 --reopen

Scope A  every code head in every segment of the DB: every o_imm value, o_displ op.value (RX keeps the
         byte-scaled displacement there), o_mem addr and o_near/o_far addr.
Scope B  every byte offset of the 4,194,304-byte image decoded as RX MOV.L #imm,Rd (FB, (rd<<4)|(li<<2)|2,
         li 00=imm32 01=simm8 10=simm16 11=simm24, sign-extended), regardless of DB state.
Scope C  every 4-byte-aligned LE32 value of the image (pointer-shaped data), classified by DB item.
Regions  USB0 000A0000-000A0400, USBA 000D0000-000D1000 (covers the RX64M USBA block at D0400),
         FCU/FACI + flash P/E window 007E0000-00800000, and USB0 MSTP bit context is not scanned here.
Output   ida\out\sub-final3\usb-scan.tsv, raw\usbscan_status.txt
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final3")
RAW = os.path.join(OUT, "raw")
STATUS = os.path.join(RAW, "usbscan_status.txt")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
REG = {"USB0": (0xA0000, 0xA0400), "USBA": (0xD0000, 0xD1000), "FCU_flash": (0x7E0000, 0x800000)}


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def region(v):
    for k, (lo, hi) in REG.items():
        if lo <= v < hi:
            return k
    return None


def main():
    import ida_auto, ida_bytes, ida_ua, idautils, idc
    ida_auto.auto_wait()
    img = sys.exit("The firmware image is not in this repository.")
    rows = []
    # A
    nh = nop = 0
    for seg in idautils.Segments():
        for hd in idautils.Heads(seg, idc.get_segm_end(seg)):
            if not ida_bytes.is_code(ida_bytes.get_flags(hd)):
                continue
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, hd) <= 0:
                continue
            nh += 1
            for op in insn.ops:
                if op.type == 0:
                    break
                nop += 1
                if op.type == ida_ua.o_imm:
                    v = op.value
                elif op.type == ida_ua.o_displ:
                    v = op.value
                elif op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far):
                    v = op.addr
                else:
                    continue
                r = region(v & 0xFFFFFFFF)
                if r:
                    rows.append(("A-operand", hd, r, v & 0xFFFFFFFF, idc.generate_disasm_line(hd, 0)))
    log("A: code heads %d, operands %d, hits %d" % (nh, nop, sum(1 for x in rows if x[0] == "A-operand")))
    # B
    nb = 0; bcode = 0
    for o in range(len(img) - 2):
        if img[o] != 0xFB or (img[o + 1] & 3) != 2:
            continue
        li = (img[o + 1] >> 2) & 3
        n = (4, 1, 2, 3)[li]
        if o + 2 + n > len(img):
            continue
        v = int.from_bytes(img[o + 2:o + 2 + n], "little")
        if li:
            bits = 8 * n
            if v & (1 << (bits - 1)):
                v |= (0xFFFFFFFF << bits) & 0xFFFFFFFF
        nb += 1
        ea = BASE + o
        isc = ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_bytes.get_item_head(ea) == ea
        bcode += 1 if isc else 0
        r = region(v)
        if r:
            rows.append(("B-movl-bytes", ea, r, v, "code-head" if isc else "not-a-code-head"))
    log("B: FB MOV.L #imm byte patterns %d (at a DB code head %d), hits %d (at a code head %d)" % (
        nb, bcode, sum(1 for x in rows if x[0] == "B-movl-bytes"),
        sum(1 for x in rows if x[0] == "B-movl-bytes" and x[4] == "code-head")))
    # C
    nc = 0
    for o in range(0, len(img), 4):
        v = struct.unpack_from("<I", img, o)[0]
        r = region(v)
        if not r:
            continue
        ea = BASE + o
        hd = ida_bytes.get_item_head(ea)
        fl = ida_bytes.get_flags(hd)
        seg = idc.get_segm_name(ea) or "no-segment"
        if ida_bytes.is_code(fl):
            k = "code@%+d %08X: %s" % (ea - hd, hd, idc.generate_disasm_line(hd, 0))
        elif ida_bytes.is_data(fl):
            k = "data@%+d(%s)" % (ea - hd, seg)
        else:
            k = "unexplored(%s)" % seg
        nc += 1
        rows.append(("C-le32-aligned", ea, r, v, k))
    log("C: aligned LE32 values in the regions %d (in code %d, data %d, unexplored %d)" % (
        nc, sum(1 for x in rows if x[0] == "C-le32-aligned" and x[4].startswith("code")),
        sum(1 for x in rows if x[0] == "C-le32-aligned" and x[4].startswith("data")),
        sum(1 for x in rows if x[0] == "C-le32-aligned" and x[4].startswith("unexplored"))))
    for k in REG:
        log("  region %s: A %d, B %d (B at code head %d), C %d" % (
            k, sum(1 for x in rows if x[0] == "A-operand" and x[2] == k),
            sum(1 for x in rows if x[0] == "B-movl-bytes" and x[2] == k),
            sum(1 for x in rows if x[0] == "B-movl-bytes" and x[2] == k and x[4] == "code-head"),
            sum(1 for x in rows if x[0] == "C-le32-aligned" and x[2] == k)))
    with open(os.path.join(OUT, "usb-scan.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("scope\tea\tfile_off\tregion\tvalue\tdetail\tbytes8\n")
        for sc, ea, r, v, d in rows:
            h.write("%s\t%08X\t%06X\t%s\t%08X\t%s\t%s\n" % (sc, ea, ea - BASE, r, v, d, img[ea - BASE:ea - BASE + 8].hex()))
    log("done")


try:
    os.makedirs(RAW, exist_ok=True)
    open(STATUS, "w").close()
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

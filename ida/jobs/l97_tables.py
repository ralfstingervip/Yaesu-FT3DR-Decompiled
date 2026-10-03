# -*- coding: utf-8 -*-
r"""Lane L97 byte dump of the rewrite tables and sub_32650. Read-only."""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import hashlib, os, struct

ROOT = str(_REPO)
IMG = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
SUB = os.path.join(ROOT, "decrypted", "FT3D_SUB_ver102_ALL.bin")
MASK = os.path.join(ROOT, "ida", "out", "main-final4", "final4_proven_mask.bin")
OUT = os.path.join(ROOT, "ida", "out", "tx-freq-range", "tables.txt")
EXPECT = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"


def hx(b):
    return " ".join("%02x" % x for x in b)


def bcd_mhz(blob):
    s = "".join("%02x" % x for x in blob)
    if any(c > "9" for c in s):
        return "non-bcd " + s
    hz = int(s, 10) * 10
    return "%d.%05d MHz" % (hz // 1000000, (hz % 1000000) // 10)


def find_all(img, pat, limit=40):
    out, start = [], 0
    while len(out) < limit:
        i = img.find(pat, start)
        if i < 0:
            break
        out.append(i)
        start = i + 1
    return out


def parse_map(img, addr, lines, label):
    stride, count = struct.unpack_from(">HH", img, addr)
    lines.append("%s @%06X stride=%d (0x%04x) count=%d" % (label, addr, stride, stride, count))
    lines.append("  header %s" % hx(img[addr:addr + 4]))
    if stride < 10 or stride > 32 or count > 16:
        lines.append("  header not a short row table; raw 64: %s" % hx(img[addr:addr + 64]))
        return
    base = addr + 4
    for i in range(count):
        row = img[base + i * stride: base + (i + 1) * stride]
        lo, hi = row[0:4], row[4:8]
        pay = row[8:10] if len(row) >= 10 else b""
        lines.append("  row %d @%06X %s  %s .. %s  pay %s" % (
            i, base + i * stride, hx(row), bcd_mhz(lo), bcd_mhz(hi), hx(pay)))
    end = base + count * stride
    lines.append("  end %06X next8 %s" % (end, hx(img[end:end + 8])))


def words(img, addr, n, lines, label):
    lines.append("%s @%06X" % (label, addr))
    for i in range(n):
        w = img[addr + 2 * i: addr + 2 * i + 2]
        lines.append("  [%d] @%06X %s  as BCD high -> %s" % (
            i, addr + 2 * i, hx(w), bcd_mhz(w + b"\x00\x00")))


def mask_runs(mask, lo, hi, lines, label):
    if hi > len(mask):
        lines.append("MASK %s outside" % label)
        return
    absent = [i for i in range(lo, hi) if mask[i] == 0]
    if not absent:
        lines.append("MASK %s %06X-%06X all %d SET" % (label, lo, hi, hi - lo))
        return
    runs, s, p = [], absent[0], absent[0]
    for i in absent[1:]:
        if i == p + 1:
            p = i
        else:
            runs.append((s, p + 1))
            s = p = i
    runs.append((s, p + 1))
    lines.append("MASK %s %06X-%06X absent %d of %d: %s" % (
        label, lo, hi, len(absent), hi - lo,
        ", ".join("%06X-%06X" % (a, b) for a, b in runs)))


def main():
    img = sys.exit("The firmware image is not in this repository.")
    h = hashlib.sha256(img).hexdigest()
    lines = ["size %d sha256 %s match %s" % (len(img), h, h == EXPECT), ""]
    lines.append("### sub_32650 raw 032640-032680")
    lines.append(hx(img[0x32640:0x32680]))
    lines.append("32650-3266E %s" % hx(img[0x32650:0x3266E]))
    lines.append("")
    lines.append("### maps")
    parse_map(img, 0x20C48, lines, "20C48")
    parse_map(img, 0x20C6A, lines, "20C6A")
    lines.append("")
    lines.append("### replacement words (12 each)")
    words(img, 0x1E21A, 8, lines, "1E21A")
    words(img, 0x1E22C, 8, lines, "1E22C")
    lines.append("1E200-1E250 %s" % hx(img[0x1E200:0x1E250]))
    lines.append("")
    lines.append("### ff92ce / ff92d6 / 8010 / bit4")
    for pat, name in (
        (bytes.fromhex("ff92ce"), "ff92ce"),
        (bytes.fromhex("ff92d6"), "ff92d6"),
        (bytes.fromhex("008010"), "abs 8010 in 34E42..3F4EA"),
        (bytes.fromhex("0001e220"), "imm 1E220"),
    ):
        hits = find_all(img, pat, 30)
        lines.append("%s count=%d" % (name, len(hits)))
        for i in hits:
            if name.startswith("abs") and not (0x34E42 <= i <= 0x3F4EA):
                continue
            lines.append("  %06X %s" % (i, hx(img[max(0, i - 4):i + len(pat) + 2])))
    # bit 4 of disp16 +0x86: opcode 70/72/73 4c within 4 bytes after 00 86
    n4 = 0
    start = 0
    while n4 < 40:
        i = img.find(bytes.fromhex("0086"), start)
        if i < 0 or i > 0x80000:
            break
        start = i + 1
        win = img[i:i + 6]
        if b"\x4c" in win[2:6]:
            n4 += 1
            lines.append("  bit4-near %06X %s" % (i - 2, hx(img[i - 2:i + 6])))
    lines.append("")
    lines.append("### immediates")
    for pat, name in (
        (bytes.fromhex("00020c48"), "imm 20C48"),
        (bytes.fromhex("00020c6a"), "imm 20C6A"),
        (bytes.fromhex("0001e21a"), "imm 1E21A"),
        (bytes.fromhex("0001e22c"), "imm 1E22C"),
        (bytes.fromhex("5e032650"), "jsr sub_32650"),
        (bytes.fromhex("5e03f5b2"), "jsr sub_3F5B2"),
        (bytes.fromhex("5e03f4a2"), "jsr sub_3F4A2"),
    ):
        hits = find_all(img, pat)
        lines.append("%s count=%d" % (name, len(hits)))
        for i in hits:
            lines.append("  %06X %s" % (i, hx(img[max(0, i - 2):i + len(pat) + 4])))
    lines.append("")
    lines.append("### bit4 reader context 010660-0106C0")
    lines.append(hx(img[0x10660:0x106C0]))
    lines.append("")
    mask = open(MASK, "rb").read()
    lines.append("MASK file %s len=%d set=%d" % (MASK, len(mask), sum(1 for x in mask if x)))
    for lo, hi, lab in (
        (0x32650, 0x3266E, "sub_32650"),
        (0x10660, 0x10690, "bit4-window"),
        (0x20C48, 0x20CAA, "maps"),
        (0x1E21A, 0x1E240, "repl-words"),
        (0x34E32, 0x34E42, "jt-34E32"),
        (0x34EDE, 0x34EEE, "jt-34EDE"),
        (0x3F5B2, 0x3F5EE, "sub_3F5B2"),
        (0x3F47E, 0x3F4A2, "copy-helpers"),
        (0x2DC8, 0x2DCC, "fill-call"),
        (0x226F0, 0x226FC, "refuse-226F0"),
        (0x224EE, 0x2250A, "call-224EE"),
    ):
        mask_runs(mask, lo, hi, lines, lab)
    sub = sys.exit("The firmware image is not in this repository.")
    lines.append("")
    lines.append("SUB sha256 %s size %d" % (hashlib.sha256(sub).hexdigest(), len(sub)))
    # string block already known; re-dump the four names only
    off = 0xFFF49073 - 0xFFC00000
    blob = sub[off:off + 24]
    lines.append("SUB %06X %s" % (off, hx(blob)))
    lines.append("SUB text %s" % (blob.replace(b"\x00", b"|").decode("ascii", "replace")))
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8", newline="\n") as hnd:
        hnd.write("\n".join(lines) + "\n")


if __name__ == "__main__":
    main()

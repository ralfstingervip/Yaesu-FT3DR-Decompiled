# -*- coding: utf-8 -*-
r"""Byte cross-check for lane L97. Reads the MAIN image and proven masks.
Does not modify the image. Writes ida\out\tx-freq-range\scan.txt.
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import hashlib, os, struct

ROOT = str(_REPO)
IMG_PATH = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
SUB_PATH = os.path.join(ROOT, "decrypted", "FT3D_SUB_ver102_ALL.bin")
OUT = os.path.join(ROOT, "ida", "out", "tx-freq-range", "scan.txt")
EXPECT = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"

# instruction heads from items_sx0 (size, mnem) plus bu_all text joined later
HEADS = {}


def hx(b):
    return " ".join("%02x" % x for x in b)


def bcd_mhz(blob):
    """8 BCD digits, value = Hz/10, so MHz = digits/100000."""
    s = "".join("%02x" % x for x in blob)
    if any(c > "9" for c in s):
        return "non-bcd " + s
    n = int(s, 10)
    # n * 10 Hz
    hz = n * 10
    return "%d.%05d MHz" % (hz // 1000000, (hz % 1000000) // 10)


def dump(img, a, n, label, lines):
    b = img[a:a + n]
    lines.append("%06X  %s  %s" % (a, hx(b), label))
    return b


def find_all(img, pat, limit=80):
    out = []
    start = 0
    while len(out) < limit:
        i = img.find(pat, start)
        if i < 0:
            break
        out.append(i)
        start = i + 1
    return out


def walk_mask(mask, ranges, lines, name):
    lines.append("MASK %s len=%d set=%d" % (name, len(mask), sum(1 for x in mask if x)))
    for lo, hi, lab in ranges:
        if hi > len(mask):
            lines.append("  %s %06X-%06X outside mask" % (lab, lo, hi))
            continue
        absent = [i for i in range(lo, hi) if mask[i] == 0]
        if not absent:
            lines.append("  %s %06X-%06X all %d bytes SET" % (lab, lo, hi, hi - lo))
            continue
        # collapse
        runs = []
        s = absent[0]
        p = absent[0]
        for i in absent[1:]:
            if i == p + 1:
                p = i
            else:
                runs.append((s, p + 1))
                s = p = i
        runs.append((s, p + 1))
        lines.append("  %s %06X-%06X absent %d of %d: %s" % (
            lab, lo, hi, len(absent), hi - lo,
            ", ".join("%06X-%06X" % (a, b) for a, b in runs)))


def main():
    img = sys.exit("The firmware image is not in this repository.")
    h = hashlib.sha256(img).hexdigest()
    lines = []
    lines.append("size %d sha256 %s match %s" % (len(img), h, h == EXPECT))
    lines.append("")
    lines.append("### raw ranges")
    for a, n, lab in [
        (0x034DC0, 0x140, "dc0-f00"),
        (0x0325FA, 0x56, "325FA"),
        (0x03F470, 0x80, "3F470"),
        (0x03F5E8, 0x28, "3F5EE"),
        (0x03F910, 0x70, "3F910"),
        (0x022490, 0xE0, "22490"),
        (0x022670, 0xA0, "22670"),
        (0x00F672, 0x20, "F672"),
        (0x00F0A2, 0x24 * 8, "F0A2"),
        (0x034E32, 0x10, "table-34E32"),
        (0x034EDE, 0x10, "table-34EDE"),
    ]:
        dump(img, a, n, lab, lines)
    lines.append("")
    lines.append("### F672 windows")
    b = img[0xF672:0xF672 + 16]
    lines.append(hx(b))
    lines.append("w0 %s .. %s" % (bcd_mhz(b[0:4]), bcd_mhz(b[4:8])))
    lines.append("w1 %s .. %s" % (bcd_mhz(b[8:12]), bcd_mhz(b[12:16])))
    lines.append("")
    lines.append("### F0A2 per dest (0x24)")
    for d in range(8):
        rec = img[0xF0A2 + d * 0x24:0xF0A2 + (d + 1) * 0x24]
        lines.append("dest %d @%06X %s" % (d, 0xF0A2 + d * 0x24, hx(rec)))
        # pairs at +4,+C,+14,+1C if header is 4; also raw every 8 from 0
        for off, name in ((0x00, "+00"), (0x04, "+04"), (0x0C, "+0C"), (0x14, "+14"), (0x1C, "+1C")):
            if off + 8 <= len(rec):
                lo, hi = rec[off:off + 4], rec[off + 4:off + 8]
                lines.append("  %s %s .. %s   raw %s" % (name, bcd_mhz(lo), bcd_mhz(hi), hx(rec[off:off + 8])))
    lines.append("")
    lines.append("### jump tables as dwords BE")
    for a in (0x034E32, 0x034EDE):
        b = img[a:a + 16]
        vals = [struct.unpack_from(">I", b, i)[0] for i in range(0, 16, 4)]
        lines.append("%06X %s -> %s" % (a, hx(b), " ".join("%06X" % v for v in vals)))
    lines.append("")
    lines.append("### jsr/bsr sites")
    for pat, name in [
        (bytes.fromhex("5e034dc2"), "jsr sub_34DC2"),
        (bytes.fromhex("5e034e42"), "jsr sub_34E42"),
        (bytes.fromhex("5e034e82"), "jsr sub_34E82"),
        (bytes.fromhex("5e03f4a2"), "jsr sub_3F4A2"),
        (bytes.fromhex("5e03f5ee"), "jsr sub_3F5EE"),
        (bytes.fromhex("557c"), "bsr +0x7C (candidate 34E42 from 34DC4)"),
    ]:
        hits = find_all(img, pat, 200)
        lines.append("%s count=%d" % (name, len(hits)))
        for i in hits:
            ctx = img[i:i + 16]
            lines.append("  %06X %s" % (i, hx(ctx)))
    lines.append("")
    lines.append("### offset 0x46 and 0x86 er0 accesses (6e ?? 00 46/86)")
    for off, tag in ((0x46, "46"), (0x86, "86")):
        pat = bytes([0x00, off])
        # look back one/two bytes for 6e
        n = 0
        start = 0
        while n < 80:
            i = img.find(pat, start)
            if i < 0 or i > 0x80000:
                break
            start = i + 1
            if i >= 2 and img[i - 2] == 0x6E:
                n += 1
                lines.append("  %s %06X %s" % (tag, i - 2, hx(img[i - 2:i + 6])))
    lines.append("")
    # proven masks
    lines.append("### masks")
    outdir = os.path.join(ROOT, "ida", "out")
    masks = []
    for dirpath, _, files in os.walk(outdir):
        for fn in files:
            if fn.endswith("proven_mask.bin"):
                p = os.path.join(dirpath, fn)
                masks.append((os.path.getmtime(p), p, os.path.getsize(p)))
    masks.sort()
    for mt, p, sz in masks:
        lines.append("file %s size %d" % (p, sz))
    # latest by mtime
    if masks:
        p = masks[-1][1]
        mask = open(p, "rb").read()
        ranges = [
            (0x034E42, 0x034E82, "sub_34E42"),
            (0x034DC2, 0x034DC8, "sub_34DC2"),
            (0x034DC8, 0x034E32, "sub_34DC8-body"),
            (0x034E32, 0x034E42, "table-34E32"),
            (0x034E82, 0x034E8A, "sub_34E82"),
            (0x034E8A, 0x034EDE, "sub_34E8A"),
            (0x034EDE, 0x034EEE, "table-34EDE"),
            (0x022504, 0x02250A, "call-22504"),
            (0x02254E, 0x02255A, "refuse-2254E"),
            (0x03F4A2, 0x03F4EA, "sub_3F4A2"),
            (0x03F5EE, 0x03F600, "sub_3F5EE"),
            (0x0325FA, 0x032650, "sub_325FA"),
            (0x03F924, 0x03F974, "bcd"),
        ]
        walk_mask(mask, ranges, lines, p)
    # SUB rpt drawer bytes
    lines.append("")
    lines.append("### SUB FFF04B70")
    sub = sys.exit("The firmware image is not in this repository.")
    off = 0xFFF04B70 - 0xFFC00000
    lines.append("sub size %d off %X" % (len(sub), off))
    lines.append(hx(sub[off:off + 0xC0]))
    # strings
    for a in (0xFFF49073, 0xFFF4907B, 0xFFF49080, 0xFFF49085):
        o = a - 0xFFC00000
        chunk = sub[o:o + 16]
        s = chunk.split(b"\x00", 1)[0]
        lines.append("%08X %s %s" % (a, hx(chunk[:12]), s.decode("ascii", "replace")))
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(lines) + "\n")
    print("wrote", OUT)


if __name__ == "__main__":
    main()

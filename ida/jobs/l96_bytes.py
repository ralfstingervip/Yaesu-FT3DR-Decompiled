# -*- coding: utf-8 -*-
"""Offline byte checks for lane L96. Reads the MAIN image only. No IDA."""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import hashlib
import os

ROOT = str(_REPO)
IMG = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
OUT = os.path.join(ROOT, "ida", "out", "market-values", "scan-raw.txt")
MASK = os.path.join(ROOT, "ida", "out", "main-final4", "final4_proven_mask.bin")
WIN = (0x078106, 0x07B754)

data = sys.exit("The firmware image is not in this repository.")
assert len(data) == 1048576
sha = hashlib.sha256(data).hexdigest()
mask = open(MASK, "rb").read()

lines = []
w = lines.append
w("size %d" % len(data))
w("sha256 %s" % sha)
w("expected 8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce")
w("sha_ok %s" % (sha == "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"))
w("mask_len %d set %d" % (len(mask), sum(1 for b in mask if b)))


def hexb(lo, n):
    return " ".join("%02x" % data[lo + i] for i in range(n))


def dump(lo, hi, title):
    w("")
    w("## %s %06X-%06X" % (title, lo, hi))
    ea = lo
    while ea < hi:
        n = min(16, hi - ea)
        w("%06X  %s" % (ea, hexb(ea, n)))
        ea += n


dump(0xDE00, 0xDF60, "DDFE-DEFA head")
dump(0xDC80, 0xDD20, "boot")
dump(0x101E0, 0x10280, "key table")
dump(0x23410, 0x23450, "gate constant")
dump(0x23650, 0x23700, "editor")
dump(0x39520, 0x39570, "eeprom helpers")
dump(0x3AC40, 0x3AC70, "eep read store")
dump(0x3B170, 0x3B1A0, "eep addr send")
dump(0x734BE, 0x734C4, "build const")
dump(0x7357A, 0x73590, "id return")
dump(0x737C0, 0x73820, "clone check")
dump(0x73A00, 0x73A56, "dispatch")
dump(0x73AFE, 0x73B20, "cmd0 stores")
dump(0x73B6C, 0x73BB4, "header builder")
dump(0x740D0, 0x74110, "reg writer")
dump(0x74472, 0x744F2, "cmd table")
dump(0xF00C, 0xF014, "F010")
dump(0x100E4, 0x10110, "port read")

# pattern hunt
w("")
w("## patterns in 0..0x80000")
needles = []
for reg in range(16):
    for aa in (0x0E, 0x0F, 0x10, 0x11):
        needles.append((bytes([0x6A, 0x80 | reg, 0x80, aa]), "mov.b rs,@80%02X" % aa))
        needles.append((bytes([0x6A, 0x00 | reg, 0x80, aa]), "mov.b @80%02X,rd" % aa))
        needles.append((bytes([0x6A, 0xA0 | reg, 0x00, 0xFF, 0x80, aa]), "mov.b rs,@FF80%02X:32" % aa))
        needles.append((bytes([0x6B, 0x80 | reg, 0x80, aa]), "mov.w rs,@80%02X" % aa))
        needles.append((bytes([0x6B, 0x00 | reg, 0x80, aa]), "mov.w @80%02X,rd" % aa))
        needles.append((bytes([0x01, 0x00, 0x6B, 0x80 | reg, 0x80, aa]), "mov.l ers,@80%02X" % aa))
        needles.append((bytes([0x01, 0x00, 0x6B, 0x00 | reg, 0x80, aa]), "mov.l @80%02X,erd" % aa))
for aa in (0x0E, 0x0F, 0x10, 0x11):
    needles.append((bytes([0x6A, 0x18, 0x80, aa]), "bitop @80%02X" % aa))
    needles.append((bytes([0x6A, 0x10, 0x80, aa]), "btst @80%02X" % aa))
    needles.append((bytes([0x6A, 0x38, 0x80, aa]), "bitop38 @80%02X" % aa))
    needles.append((bytes([0x00, 0xFF, 0x80, aa]), "imm ..FF80%02X" % aa))
    for rn in range(8):
        needles.append((bytes([0x7A, rn, 0x00, 0xFF, 0x80, aa]), "mov.l #FF80%02X,er%d" % (aa, rn)))

# also word/long that cover the bytes from a lower address
for reg in range(16):
    for aa in (0x0C, 0x0D, 0x0E, 0x0F, 0x10):
        needles.append((bytes([0x6B, 0x80 | reg, 0x80, aa]), "mov.w rs,@80%02X overlap" % aa))
        needles.append((bytes([0x01, 0x00, 0x6B, 0x80 | reg, 0x80, aa]), "mov.l ers,@80%02X overlap" % aa))

seen = set()
for sig, name in needles:
    start = 0
    hi = 0x80000
    while True:
        i = data.find(sig, start, hi)
        if i < 0:
            break
        key = (i, name)
        if key not in seen:
            seen.add(key)
            win = "WIN" if WIN[0] <= i < WIN[1] else "ok"
            w("%06X  %-28s %s  %s" % (i, name, win, hexb(i, min(8, 0x80000 - i))))
        start = i + 1

w("")
w("## jsr/jmp abs24 to helpers")
for tgt, name in (
    (0x00DDFE, "DDFE"),
    (0x00DDE4, "DDE4"),
    (0x039534, "39534"),
    (0x039544, "39544"),
    (0x039554, "39554"),
    (0x03AB80, "3AB80"),
    (0x03AD20, "3AD20"),
    (0x0740E2, "740E2"),
    (0x0740D8, "740D8"),
    (0x073B6C, "73B6C"),
    (0x073AFE, "73AFE"),
    (0x07357A, "7357A"),
    (0x075160, "75160"),
    (0x075554, "75554"),
):
    sig = bytes([0x5E, (tgt >> 16) & 0xFF, (tgt >> 8) & 0xFF, tgt & 0xFF])
    jmp = bytes([0x5A, (tgt >> 16) & 0xFF, (tgt >> 8) & 0xFF, tgt & 0xFF])
    for kind, s in (("jsr", sig), ("jmp", jmp)):
        start = 0
        while True:
            i = data.find(s, start, 0x80000)
            if i < 0:
                break
            win = "WIN" if WIN[0] <= i < WIN[1] else "ok"
            w("%06X  %s %s  %s" % (i, kind, name, win))
            start = i + 1

w("")
w("pattern_rows %d" % len(seen))
os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, "w", encoding="utf-8", newline="\n") as h:
    h.write("\n".join(lines) + "\n")
print("wrote", OUT, "sha_ok", sha[:16])

# -*- coding: utf-8 -*-
r"""Write citations.tsv from image bytes for lane L97. Read-only."""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os

ROOT = str(_REPO)
IMG = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
SUB = os.path.join(ROOT, "decrypted", "FT3D_SUB_ver102_ALL.bin")
OUT = os.path.join(ROOT, "ida", "out", "tx-freq-range", "citations.tsv")

# (addr, length, label, claim) — length 0 means SUB file offset
ROWS = [
    (0x034E42, 0x40, "sub_34E42", "allow if FFAAAE in FF92CE or FF92D6 inclusive; r4l 0/1; er0+0x86 bit 4"),
    (0x03F5EE, 0x12, "sub_3F5EE", "C clear iff lo <= value <= hi"),
    (0x034DC2, 6, "sub_34DC2", "bsr builder; bsr sub_34E42; rts returns the check Z"),
    (0x034E82, 8, "sub_34E82", "bsr sub_34E8A; jsr sub_34E42; rts"),
    (0x034DC8, 0x28, "sub_34DC8-head", "copy er0+0x1A to FFAAAE; bit0 of +0x46 skips shift; index +0x15"),
    (0x034E32, 0x10, "jt-34E32", "pointers 034E26 034DF2 034E06 034E1A"),
    (0x034DF2, 0x14, "shift-sub", "BCD subtract er0+0x1E via sub_3F94C"),
    (0x034E06, 0x14, "shift-add", "BCD add er0+0x1E via sub_3F924"),
    (0x034E1A, 0x0C, "shift-replace", "FFAAAE = @(0x1E,er0)"),
    (0x034E26, 0x0C, "call-325FA", "er5=#FFAAAE; jsr sub_325FA; rts"),
    (0x03F924, 8, "bcd-add-head", "clear C then addx/daa"),
    (0x03F94C, 0x28, "sub_3F94C", "packed-BCD subtract, subx/das"),
    (0x025E98, 6, "bclr-46.0", "one writer clears er0+0x46 bit 0"),
    (0x0325FA, 8, "sub_325FA-head", "load er0+4; bsr sub_32650; beq rts"),
    (0x03264E, 2, "sub_325FA-rts", "live return, no store to the frequency"),
    (0x032646, 4, "skipped-store", "mov.l er4,@er1 not reached from the live beq"),
    (0x032650, 0x1E, "sub_32650", "mov #1,r4h clears Z; bne taken; return r4l 0"),
    (0x03F5B2, 0x3C, "sub_3F5B2", "stride/count row walker; hit r4l 0 and payload at +8"),
    (0x020C48, 4, "map-20C48-hdr", "stride 10, count 3"),
    (0x020C4C, 10, "map-20C48-r0", "824.00000-848.99500 pay 0000"),
    (0x020C56, 10, "map-20C48-r1", "869.00000-893.99500 pay 0001"),
    (0x020C60, 10, "map-20C48-r2", "940.10000-965.09500 pay 0002"),
    (0x020C6A, 4, "map-20C6A-hdr", "stride 10, count 6"),
    (0x020C6E, 10, "map-20C6A-r0", "253.00000-275.99500 pay 0000"),
    (0x020C78, 10, "map-20C6A-r1", "380.00000-382.99500 pay 0001"),
    (0x020C82, 10, "map-20C6A-r2", "412.00000-415.99500 pay 0002"),
    (0x020C8C, 10, "map-20C6A-r3", "810.00000-845.99500 pay 0003"),
    (0x020C96, 10, "map-20C6A-r4", "860.00000-900.99500 pay 0004"),
    (0x020CA0, 10, "map-20C6A-r5", "915.00000-960.99500 pay 0005"),
    (0x01E21A, 6, "words-1E21A", "823.00000 868.00000 940.10000 MHz high words"),
    (0x01E22C, 12, "words-1E22C", "252.00000 379.00000 411.00000 809.00000 859.00000 914.00000"),
    (0x034E8A, 0x22, "sub_34E8A-head", "FFB392 -> FFAAAE; index FFB39C via 034EDE"),
    (0x034EAC, 0x12, "staged-sub", "BCD subtract FFB396"),
    (0x034EBE, 0x12, "staged-add", "BCD add FFB396"),
    (0x034ED0, 0x0C, "staged-replace", "FFAAAE = @FFB396"),
    (0x034EDC, 2, "staged-keep-rts", "index 0 rts; FFAAAE stays FFB392"),
    (0x034EDE, 0x10, "jt-34EDE", "pointers 034EDC 034EAC 034EBE 034ED0"),
    (0x0224E0, 2, "load-FF812A", "mov.l @FF812A, er0"),
    (0x032FA2, 0x38, "sub_32FA2", "returns er0=[FF812A]"),
    (0x033136, 0x0A, "sub_33136-head", "FFAA37 bit1 clear beqs to rts; er0 unchanged"),
    (0x03317E, 2, "sub_33136-rts", "bit-clear return"),
    (0x03F4A2, 0x48, "sub_3F4A2", "FF800F==6 or FF8011==0 copies F0A2; else F672"),
    (0x002DC8, 6, "fill-call", "sole jsr sub_3F4A2 then rts"),
    (0x002D7C, 4, "sub_2D7C-entry", "callers 002B3E and 073B26; falls through to the fill"),
    (0x002B3E, 4, "call-2D7C-a", "jsr sub_2D7C"),
    (0x073B26, 4, "call-2D7C-b", "jsr sub_2D7C"),
    (0x03F48E, 0x14, "sub_3F48E", "copy two longs, er6 post-increments"),
    (0x03F47E, 0x10, "sub_3F47E", "FF800F * 0x24 added to er6, falls into the copy"),
    (0x00F672, 16, "F672", "fixed windows 140-174 and 420-470 MHz"),
    (0x03478E, 6, "other-reader-A", "mov.l #FF92CE elsewhere; not this check"),
    (0x035D9C, 6, "other-reader-B", "mov.l #FF92CE elsewhere; not this check"),
    (0x0224E6, 0x26, "tx-request-calls", "FF8992==0x0A alternate and the 022504 jsr/bne"),
    (0x02250A, 4, "tx-allow-continue", "bsr sub_2257A; setup continues"),
    (0x022522, 6, "tx-allow-tone", "FFAAE0=0xFF"),
    (0x022540, 6, "tx-allow-state", "FF94C0=1"),
    (0x02254E, 0x14, "tx-block", "FF94C0=2; FFAAE0=0x1D; cmp #1; rts with Z clear"),
    (0x022696, 6, "sub_22676-call", "jsr sub_34DC2; bne 0226F0"),
    (0x0226F0, 0x0C, "sub_22676-block", "FF94C0=2; FFAAE0=0x1D"),
    (0x01C96C, 6, "call-01C96C", "jsr sub_34DC2; bne"),
    (0x01C9AE, 6, "call-01C9AE", "jsr sub_34DC2; rts"),
    (0x02F6B2, 8, "call-02F6B2", "jsr sub_34DC2; next jsr does not test Z"),
    (0x030234, 6, "call-030234", "jsr sub_34DC2; bne"),
    (0x03023A, 8, "allow-03023A", "bset #0 @FFAAD1 on allow"),
    (0x0311A0, 8, "call-0311A0", "jsr sub_34DC2; next jsr does not test Z"),
    (0x031CC6, 6, "call-031CC6", "jsr sub_34DC2; bne"),
    (0x037BE8, 6, "call-037BE8", "jsr sub_34DC2; bne"),
    (0x037BFC, 0x16, "block-037BFC", "cmp.l #0x05000000; below that loads the constant into er4"),
    (0x068202, 6, "call-068202", "jsr sub_34DC2; bne"),
    (0x06CE38, 6, "call-06CE38", "jsr sub_34DC2; bne"),
    (0x06D0DE, 6, "call-06D0DE", "jsr sub_34DC2; bne"),
    (0x06D0E4, 8, "allow-06D0DE", "FFB3E4=1"),
    (0x025B98, 6, "call-025B98", "jsr sub_34E82; bne"),
    (0x025FD0, 8, "call-025FD0", "jsr sub_34E82; bne disp16"),
    (0x010674, 8, "bit4-reader", "btst #4 of er5+0x86; beq away when clear"),
    (0x010684, 10, "bit4-fall", "FFBB93=1 when er5+0x90==2 and FFBB93==0"),
]


def hx(b):
    return " ".join("%02x" % x for x in b)


def main():
    img = sys.exit("The firmware image is not in this repository.")
    sub = sys.exit("The firmware image is not in this repository.")
    # F0A2 copied pairs, dest 0..7, +0x0C and +0x1C
    extra = []
    for d in range(8):
        base = 0xF0A2 + d * 0x24
        for off, tag in ((0x0C, "+0C"), (0x1C, "+1C")):
            extra.append((base + off, 8, "F0A2-d%d%s" % (d, tag),
                          "copied pair for dest %d" % d))
    lines = ["addr\thex\tlabel\tclaim"]
    for addr, n, label, claim in ROWS + extra:
        blob = img[addr:addr + n]
        if len(blob) != n:
            raise SystemExit("short read %X" % addr)
        lines.append("%06x\t%s\t%s\t%s" % (addr, hx(blob), label, claim))
    off = 0xFFF49073 - 0xFFC00000
    blob = sub[off:off + 25]
    lines.append("%06x\t%s\tSUB-shift-names\tSIMPLEX -RPT +RPT DUPLEX bytes, file offset" % (
        off, hx(blob)))
    # sanity: fixed window and the two other readers
    assert img[0xF672:0xF682] == bytes.fromhex("14000000174000004200000047000000")
    assert img[0x3478E:0x34794] == bytes.fromhex("7a0600ff92ce")
    assert img[0x35D9C:0x35DA2] == bytes.fromhex("7a0600ff92ce")
    assert img[0x32650:0x32657] == bytes.fromhex("6a0c800ff40146")
    assert img[0x22504:0x2250A] == bytes.fromhex("5e034dc24644")
    assert img[0x2254E:0x2255A] == bytes.fromhex("fc026a8c94c0fc1d6a8caae0")
    assert blob == bytes.fromhex("53494d504c4558002d525054002b525054004455504c455800")
    win = os.path.join(ROOT, "ida", "out", "tx-freq-range", "windows.tsv")
    for line in open(win, encoding="utf-8"):
        if line.startswith("source"):
            continue
        parts = line.rstrip("\n").split("\t")
        addr = int(parts[3], 16)
        lo = bytes.fromhex(parts[4])
        hi = bytes.fromhex(parts[5])
        assert img[addr:addr + 4] == lo, parts
        assert img[addr + 4:addr + 8] == hi, parts
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8", newline="\n") as hnd:
        hnd.write("\n".join(lines) + "\n")
    print("rows %d" % (len(lines) - 1))


if __name__ == "__main__":
    main()

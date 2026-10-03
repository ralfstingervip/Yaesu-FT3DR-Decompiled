# -*- coding: utf-8 -*-
"""Write the service-window listing and citations.tsv from the image. Read-only."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, sys
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
from common import IMG, flow

OUT = str(_REPO / "ida/out/service-window")
HEADS = os.path.join(OUT, "code-heads.tsv")

FUNCS = [
    (0x078106, "usb_init", "clear 0xFEE010-0xFEE20F, snapshot IER, jsr usb_arm, set FFEE2D bit 2"),
    (0x07815C, "usb_service", "polled ring check; jsr 0x0768A8 or arm TRG; jsr pump 0x076FC8"),
    (0x0781C6, "usb_clear", "clear 0xFEE010-0xFEE20F and return; no direct reference"),
    (0x0781DE, "usb_init_twin", "IER snapshot via er1, jsr usb_arm, set FFEE2D bit 2; no direct reference"),
    (0x07821E, "sci_sleep", "sleep; rts"),
    (0x078222, "sci_async", "SCI SMR 0x08, BRR 0x0C, SCR 0 then 0x70"),
    (0x07823C, "sci_async_twin", "byte-identical SCI init"),
    (0x078256, "sci_smr_brr", "SMR 0x08 and BRR 0x0C only; no direct reference"),
    (0x078260, "ee32_burst", "write r0 bytes from FF63AC to FFEE32"),
    (0x07827C, "usb_isr", "pack IFR & IER, walk 10-byte handler table, jsr @er2"),
    (0x078334, "ring_fill", "copy into a ring, then store struct+0x0D to FFEE2C"),
    (0x07837C, "ring_drain", "copy out of a ring, store struct+0x0C to FFEE2C, return count"),
    (0x0783DA, "ring_move", "copy between two rings unless the FF6330 byte is nonzero"),
    (0x07842E, "load_be16", "r0 = mem[0]<<8 | mem[1]; no direct reference"),
    (0x078442, "load_le16", "r0 = mem[1]<<8 | mem[0]"),
    (0x07845A, "usb_arm", "burst 0x32 bytes to FFEE32, IER0=0xCD, clear ISR0/1, ISR2=4"),
    (0x0784BE, "queue_init_isr", "handler mask 0x80000000: queue init, FFEE00=0x7F, FFEE28=0x73"),
    (0x078508, "queue_init", "set FF6288 ring pointers equal and FF6240=1"),
]


def hx(a, n):
    return " ".join("%02x" % b for b in IMG[a:a + n])


def label_of(a):
    name = FUNCS[0][1]
    for s, n, _c in FUNCS:
        if s <= a:
            name = n
        else:
            break
    return name


rows = []

def add(addr, n, label, claim):
    rows.append((addr, hx(addr, n), label, claim.replace("\t", " ")))

heads = []
with open(HEADS, encoding="utf-8") as h:
    next(h)
    for ln in h:
        c = ln.rstrip("\n").split("\t")
        a, n, t = int(c[0], 16), int(c[1]), c[3]
        heads.append((a, n, t))
        fn, ft, fk, tg = flow(a)
        if fn != n or ft != t or hx(a, n) != c[2]:
            raise SystemExit("head drift %06X" % a)
        add(a, n, label_of(a), ft)

OUTSIDE = [
    0x002152, 0x002156, 0x00215C, 0x002162, 0x002166, 0x002168,
    0x0021FA, 0x0021FE, 0x002200, 0x002202, 0x002204, 0x002206,
    0x002214, 0x002218, 0x00221C, 0x002222, 0x002224, 0x002228, 0x002234,
    0x00251E, 0x002522, 0x002528, 0x00252E,
    0x054D54, 0x054D58, 0x054EA8, 0x054EB0, 0x054EC0,
    0x05DCFE, 0x05DD02, 0x05DD06, 0x05DD08, 0x05DD12,
    0x05DD8A, 0x05DD98, 0x05DD9E,
    0x07615E, 0x07616A, 0x076186, 0x076190, 0x07619A, 0x0761A4, 0x0761AE, 0x0761B8,
    0x0761C0, 0x0761CE, 0x0761D4, 0x0761DA, 0x0761E2, 0x0761FA, 0x076208,
    0x0762E4, 0x0762EA, 0x0762FE, 0x076306, 0x076308, 0x0767B6,
    0x0768A8, 0x0768AE, 0x0768B0, 0x0768B6, 0x0768BC, 0x0768C0,
    0x076FC8, 0x076FD2, 0x077008, 0x07700E, 0x07701E, 0x077020, 0x077022,
    0x077E3A, 0x077F52, 0x077F5A,
]
for a in OUTSIDE:
    n, t, k, tg = flow(a)
    if n <= 0:
        raise SystemExit("bad outside %06X" % a)
    add(a, n, "outside", t)

# data runs quoted from the image
DATA = [
    (0x078546, 90, "switch_disp", "45 BE words; byte displacement from 0x07630A"),
    (0x0785A0, 16, "nibble_a", "16-byte map selected when FFBC70 high nibble is 0xA"),
    (0x0785B0, 16, "nibble_b", "16-byte map for high nibble 0xB"),
    (0x0785C0, 16, "nibble_c", "16-byte map for high nibble 0xC"),
    (0x0785D0, 16, "nibble_d", "16-byte map for high nibble 0xD"),
    (0x0785E0, 16, "nibble_e", "16-byte map for high nibble 0xE"),
    (0x0785F0, 16, "nibble_f", "16-byte map for high nibble 0xF"),
    (0x078600, 16, "codes_600", "first 8 BE words of the 0x078600 table"),
    (0x07B120, 16, "codes_b120", "first 8 BE words of the 0x07B120 table"),
    (0x07B250, 16, "codes_tail", "last words of 0x078600-0x07B25F, then FFFF"),
    (0x07B260, 16, "zeros", "16 zero bytes; address loaded by 0x077E3A"),
    (0x07B270, 2, "str_pad", "two zero bytes loaded by 0x077F52 and 0x077F5A"),
    (0x07B272, 4, "usb_lang", "bLength 4, type 3, wLANGID 0x0409"),
    (0x07B276, 16, "usb_str_mfg", "bLength 0x10, type 3, UTF-16LE Renesas"),
    (0x07B286, 26, "usb_str_ser", "bLength 0x1A, type 3, UTF-16LE 000000000000"),
    (0x07B2A0, 6, "before_data", "zeros, then FF, immediately before the copied image"),
    (0x07B2A6, 16, "pair_head", "first key/value words of the copied pair list"),
    (0x07B4A2, 16, "pair_tail", "last pairs; final key 0x2576"),
    (0x07B4B2, 2, "ff6240", "initializer of FF6240"),
    (0x07B4B4, 10, "handler0", "mask 0x80000000 byte 0 handler 0x0784BE"),
    (0x07B4BE, 10, "handler1", "mask 0x05000000 byte 1 handler 0x0769AA"),
    (0x07B4C8, 10, "handler2", "mask 0x08000000 byte 0 handler 0x0768C8"),
    (0x07B4D2, 10, "handler3", "mask 0x02000000 byte 1 handler 0x0769AA"),
    (0x07B4DC, 10, "handler4", "mask 0x40000000 byte 5 handler 0x0767BE"),
    (0x07B4E6, 10, "handler5", "mask 0x10000000 byte 4 handler 0x0768A8"),
    (0x07B4F0, 10, "handler_end", "byte at +4 is 0xFF, end of the handler list"),
    (0x07B4FA, 16, "ff6288", "image of FF6288 +0 and +4"),
    (0x07B53A, 16, "ff62c8", "image of FF62C8, ring at 0xFEE110 limit 0xFEE20F"),
    (0x07B54A, 16, "ff62d8", "image of FF62D8, ring at 0xFEE010 limit 0xFEE10F"),
    (0x07B56A, 4, "ff62f8", "image of FF62F8 before the IER snapshot"),
    (0x07B5A2, 4, "ff6330", "image of FF6330, pointer 0xFFEE24"),
    (0x07B5F0, 4, "ptr_dev", "copied pointer to device descriptor at FF640E"),
    (0x07B5F4, 2, "ptr_len", "0x0043 beside the descriptor pointers"),
    (0x07B5F6, 4, "ptr_cfg", "copied pointer to config descriptor at FF649F"),
    (0x07B5FA, 6, "ptr_lang", "LE length 4 and pointer 0x07B272"),
    (0x07B600, 6, "ptr_mfg", "LE length 0x10 and pointer 0x07B276"),
    (0x07B60C, 6, "ptr_ser", "LE length 0x1A and pointer 0x07B286"),
    (0x07B61E, 20, "ee32_image", "first 20 of 50 bytes burst to FFEE32"),
    (0x07B632, 30, "ee32_pad", "remaining 30 bytes of that 50-byte image, all 0x00"),
    (0x07B680, 18, "usb_device", "device descriptor, RAM FF640E"),
    (0x07B692, 5, "after_device", "five bytes between the device descriptor and the ACME length"),
    (0x07B697, 2, "acme_len", "BE16 0x0079; count includes these two bytes, ASCII follows"),
    (0x07B699, 32, "acme_head", "start of the ACME text; 119 ASCII bytes through 0x07B70F"),
    (0x07B710, 1, "acme_tail", "single 0x18 between the ACME text and the config descriptor"),
    (0x07B711, 9, "usb_config", "config, wTotalLength 0x0043, 2 interfaces"),
    (0x07B71A, 9, "usb_if0", "interface 0, class 02 subclass 02 protocol 01"),
    (0x07B723, 5, "usb_header", "CS_INTERFACE header, bcdCDC 0x0110"),
    (0x07B728, 4, "usb_acm", "CS_INTERFACE ACM, bmCapabilities 0x06"),
    (0x07B72C, 5, "usb_union", "CS_INTERFACE union, master 0 subordinate 1"),
    (0x07B731, 5, "usb_call", "CS_INTERFACE call management"),
    (0x07B736, 7, "usb_ep3", "endpoint 0x83 interrupt IN, 8 bytes, interval 16"),
    (0x07B73D, 9, "usb_if1", "interface 1, class 0A, 2 endpoints"),
    (0x07B746, 7, "usb_ep1", "endpoint 0x01 bulk OUT, 64 bytes"),
    (0x07B74D, 7, "usb_ep2", "endpoint 0x82 bulk IN, 64 bytes"),
    (0x07B753, 1, "last", "last image byte"),
    (0x07B754, 1, "past", "byte after the image"),
]
for a, n, lab, claim in DATA:
    add(a, n, lab, claim)

# identical SCI bodies
b1 = IMG[0x078222:0x07823C]
b2 = IMG[0x07823C:0x078256]
if b1 != b2:
    raise SystemExit("sci twins differ")
acme = IMG[0x07B699:0x07B710]
if len(acme) != 119 or any(b < 0x20 or b > 0x7e for b in acme):
    raise SystemExit("acme span")
if int.from_bytes(IMG[0x07B697:0x07B699], "big") != 121:
    raise SystemExit("acme len")
if IMG[0x07B632:0x07B650] != b"\x00" * 30:
    raise SystemExit("ee32 pad")

path = os.path.join(OUT, "citations.tsv")
with open(path, "w", encoding="utf-8", newline="\n") as h:
    h.write("addr\thex\tlabel\tclaim\n")
    for a, hexb, lab, claim in rows:
        h.write("%06X\t%s\t%s\t%s\n" % (a, hexb, lab, claim))

# full listing
lines = []
lines.append("; service window 078106-07B753 inclusive")
lines.append("; image decrypted/FT3D_MAIN_ver102_EXP.bin")
lines.append("; sha256 8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce")
lines.append("; span 13902 bytes; code 078106-078545 (1088 bytes, 336 insns)")
lines.append("; oracle ida/out/h8s-decode/work/bu_all.tsv ; IDA cross-check ida-listing.txt")
lines.append("")
fi = 0
for a, n, t in heads:
    if fi < len(FUNCS) and a == FUNCS[fi][0]:
        lines.append("")
        lines.append("; ---- %06X %s : %s ----" % FUNCS[fi])
        fi += 1
    lines.append("%06X  %-24s  %s" % (a, hx(a, n), t))
lines.append("")
lines.append("; ---- data 078546-07B753 ----")
marks = {
    0x078546: "switch displacements",
    0x0785A0: "nibble maps",
    0x078600: "word tables",
    0x07B260: "zeros",
    0x07B270: "USB strings",
    0x07B2A6: "copied image FF6034",
    0x07B4B4: "handler table",
    0x07B680: "device descriptor",
    0x07B698: "ACME length",
    0x07B711: "config descriptor",
}
for a in range(0x078546, 0x07B754, 16):
    n = min(16, 0x07B754 - a)
    if a in marks:
        lines.append("; %s" % marks[a])
    lines.append("%06X  %s" % (a, hx(a, n)))

with open(os.path.join(OUT, "disasm.asm"), "w", encoding="utf-8", newline="\n") as h:
    h.write("\n".join(lines) + "\n")
print("rows", len(rows), "disasm", len(lines))

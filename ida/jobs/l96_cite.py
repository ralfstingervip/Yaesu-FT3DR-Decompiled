import sys
# Read-only citation check for lane L96. Does not modify the firmware image or any mask.
import hashlib
import os
import struct

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
IMG = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
MASK = os.path.join(ROOT, "ida", "out", "main-final4", "final4_proven_mask.bin")
OUT = os.path.join(ROOT, "ida", "out", "market-values")
EXPECT = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"
WIN = (0x078106, 0x07B753)

# addr, length, label, claim, kind (code|data)
CITES = [
    (0x00DE08, 6, "sub_DDFE", "immediate 2 and store of FF800F", "code"),
    (0x00DE0E, 6, "sub_DDFE", "immediate 1 and store of FF8010", "code"),
    (0x00DE14, 10, "sub_DDFE", "sample count 10, call sub_DDE4, store FF8011", "code"),
    (0x00DDE4, 26, "sub_DDE4", "sample bit 2 of port 0xFFFF4E until two reads agree", "code"),
    (0x00DEFA, 6, "sub_DEFA", "r1l==2 skips the word check; otherwise the count is 0x80", "code"),
    (0x00DF00, 50, "sub_DEFA", "clear check words, load EEPROM 0x40, compare with ROM 0xF010", "code"),
    (0x00DF2C, 30, "sub_DEFA", "failed check calls sub_DDFE; stable changed strap stored at 0xDF46", "code"),
    (0x00DC84, 40, "boot", "TAIS path loads the block; strap mismatch jumps to 0xDBD8", "code"),
    (0x00DCD4, 18, "boot", "non-TAIS path loads the block, runs sub_DEFA, saves the block", "code"),
    (0x00DCE6, 4, "boot", "jsr sub_39576 saves the 0x100-byte image at EEPROM 0x40", "code"),
    (0x039576, 16, "sub_39576", "sub_39586 then sub_3AD20", "code"),
    (0x00DD0E, 20, "boot markers", "TAIS ESTU MARU CHAN and the 0000 seed dword", "data"),
    (0x00F010, 2, "ROM 0xF010", "check word 0x9669", "data"),
    (0x00DE20, 62, "sub_DE20", "copies ROM into FF8016/FF8096/FF80C6; does not touch FF800E-11", "code"),
    (0x039554, 18, "sub_39554", "r6=8, EEPROM 0x20, RAM 0xFF800E", "code"),
    (0x039534, 16, "sub_39534", "load helper: sub_39554 then sub_3AB80", "code"),
    (0x039544, 16, "sub_39544", "save helper: sub_39554 then sub_3AD20", "code"),
    (0x039586, 18, "sub_39586", "r6=0x100, EEPROM 0x40, RAM 0xFF8016", "code"),
    (0x039522, 16, "sub_39522", "r6=4, EEPROM 0x10, RAM 0xFF8006 marker dword", "code"),
    (0x03AB80, 8, "sub_3AB80", "EEPROM read entry calls the address sender", "code"),
    (0x03AC52, 12, "sub_3AB80", "store byte at er1, add 1, count on r6", "code"),
    (0x03AD5C, 2, "sub_3AD20", "write path reads @er1+", "code"),
    (0x03B180, 20, "sub_3B14C", "device 0xA0 then EEPROM address r0h, r0l", "code"),
    (0x03F36E, 12, "sub_3F36E", "counted copy used by sub_DE20", "code"),
    (0x0100E4, 36, "sub_100E4", "port 0xFFFF4C masked with 0x7F becomes er2 unless the mask is 0x7F", "code"),
    (0x01017C, 8, "sub_10168", "er2 of 0x000FFFFF skips the table", "code"),
    (0x010186, 8, "sub_10168", "matcher base 0x10216 and count 11", "code"),
    (0x01018E, 48, "sub_10168", "FF89C2.0 and FF813A gate the index-7 dispatch", "code"),
    (0x010216, 44, "port table", "eleven power-on port longs; index 7 is 0x73", "data"),
    (0x010242, 44, "handler table", "eleven handlers; index 7 is sub_1026E", "data"),
    (0x01026E, 4, "sub_1026E", "bsr sub_10276 and bra to the rts", "code"),
    (0x010276, 48, "sub_10276", "gate, copy FF800F/FF8010, screen byte 0xE8", "code"),
    (0x010232, 4, "port table index 7", "port long 0x00000073", "data"),
    (0x01025E, 4, "handler index 7", "pointer to sub_1026E", "data"),
    (0x023410, 50, "sub_23410", "opening-message compare; reject returns 1", "code"),
    (0x023442, 6, "ROM gate", "bytes compared with FF8958/FF895C", "data"),
    (0x02365C, 42, "sub_2365C", "FF8011 selects destination table 0..7 or 2..3", "code"),
    (0x023686, 12, "editor tables", "min/max 0..7 and 2..3, pointer FFAD95", "data"),
    (0x023692, 6, "sub_23692", "reject path", "code"),
    (0x023698, 32, "sub_23698", "FF8011==0 rejects; otherwise toggles FFAD96 bit 0", "code"),
    (0x0236B8, 58, "sub_236B8", "commit FF800F/FF8010, save block, jump 0xDBD8", "code"),
    (0x00DBC4, 20, "sub_DBC4", "sets FF8004=3 and enters boot at 0xDC12", "code"),
    (0x00DBD8, 36, "sub_DBD8", "clears FF8004, copies MARU from 0xDD16, jsr sub_39512", "code"),
    (0x00DC12, 32, "boot", "sets FF8003=2 before the marker checks", "code"),
    (0x00209E, 6, "reset", "cold entry clears FF8004", "code"),
    (0x002B36, 4, "boot tail", "calls sub_7351E after the block load", "code"),
    (0x07351E, 36, "sub_7351E", "FF8004==3 falls through to sub_73AFE", "code"),
    (0x0734BE, 4, "sub_734BE", "returns constant 2", "code"),
    (0x07357A, 20, "sub_7357A", "returns 00:FF800F:FF8010:FF8011", "code"),
    (0x0737C8, 52, "sub_737C8", "clone ID compare; mismatch returns without a market store", "code"),
    (0x0738A2, 6, "AH72M", "five compare bytes plus the following 00", "data"),
    (0x0735A6, 8, "clone receive", "ID check before the EEPROM stream", "code"),
    (0x0735D4, 6, "clone receive", "first EEPROM address 0x140", "code"),
    (0x073610, 6, "clone receive", "second EEPROM address 0x10100", "code"),
    (0x073A20, 30, "sub_739FA", "argument word FF96FA; dispatch through table 0x74472", "code"),
    (0x073A54, 48, "sub_73A54", "index = byte minus 0x30; other than 0 requires FF8004>=2", "code"),
    (0x074472, 4, "cmd slot 0", "pointer to sub_73AFE", "data"),
    (0x07447A, 4, "cmd slot 2", "pointer to sub_73B6C", "data"),
    (0x0744EA, 4, "cmd slot 0x1E", "pointer to sub_740D8", "data"),
    (0x0740D8, 4, "sub_740D8", "bsr sub_740E2", "code"),
    (0x0740E2, 42, "sub_740E2", "stores FF800F/FF8010 and saves the block", "code"),
    (0x073AFE, 28, "sub_73AFE", "RAM stores FF8010=1 and FF8011=1; sets FF8004=2", "code"),
    (0x073B6C, 60, "sub_73B6C", "reloads the block, copies it out, then RAM-forces 1,1", "code"),
    (0x074AD4, 28, "BACKUP apply", "converters then marker save and jump 0xDC4E", "code"),
    (0x0750AC, 22, "BACKUP apply 2", "second converter call then jump 0xDC4E", "code"),
    (0x07516A, 42, "sub_75160", "reads FF800F and branches; no store to the three bytes", "code"),
    (0x075518, 4, "sub_754BC", "bsr sub_75554", "code"),
    (0x075546, 4, "sub_754BC", "bsr sub_75554", "code"),
    (0x075554, 42, "sub_75554", "reads FF800F and branches on 1, 2, 3, 4, 5, 7", "code"),
    (0x075592, 6, "sub_75554", "writes 6 to record field +4", "code"),
    (0x03F62E, 40, "sub_3F62E", "cycles the pointed byte inside the table min..max", "code"),
    (0x01462C, 4, "screen table", "pointer to sub_2365C", "data"),
    (0x02A692, 4, "screen table", "pointer to sub_236B8", "data"),
    (0x00DE0A, 4, "store FF800F", "sub_DDFE mov.b r4l,@FF800F", "code"),
    (0x00DE10, 4, "store FF8010", "sub_DDFE mov.b r4l,@FF8010", "code"),
    (0x00DE1A, 4, "store FF8011", "sub_DDFE mov.b r5l,@FF8011", "code"),
    (0x00DF46, 4, "store FF8011", "sub_DEFA mov.b r5l,@FF8011", "code"),
    (0x0236E2, 4, "store FF800F", "commit mov.b r4l,@FF800F", "code"),
    (0x0236E6, 4, "store FF8010", "commit mov.b r3l,@FF8010", "code"),
    (0x073B12, 4, "store FF8010", "sub_73AFE mov.b r4l,@FF8010", "code"),
    (0x073B16, 4, "store FF8011", "sub_73AFE mov.b r4l,@FF8011", "code"),
    (0x073B82, 6, "read FF800E", "mov.l @FF800E,er4 copies the four bytes out", "code"),
    (0x073BA0, 4, "store FF8010", "sub_73B6C mov.b r4l,@FF8010", "code"),
    (0x073BA4, 4, "store FF8011", "sub_73B6C mov.b r4l,@FF8011", "code"),
    (0x0740F6, 4, "store FF800F", "sub_740E2 mov.b r1h,@FF800F", "code"),
    (0x0740FA, 4, "store FF8010", "sub_740E2 mov.b r3l,@FF8010", "code"),
    (0x00DDE6, 4, "sub_DDE4", "bld #2,@0x4E", "code"),
    (0x03955E, 6, "sub_39554", "mov.l #0xFF800E,er1", "code"),
    (0x039558, 6, "sub_39554", "mov.l #0x20,er0", "code"),
    (0x00DC8C, 4, "boot", "jsr sub_39534", "code"),
    (0x00DCD6, 4, "boot", "jsr sub_39534", "code"),
    (0x00DCE2, 4, "boot", "jsr sub_39544", "code"),
    (0x0236EA, 4, "commit", "jsr sub_39544", "code"),
    (0x0740FE, 4, "sub_740E2", "jsr sub_39544", "code"),
]

WRITERS = [
    (0x00DE0A, 4, "FF800F", "r4l after immediate 2", "RAM, then saved by the 0xDCE2 caller", "sub_DDFE"),
    (0x00DE10, 4, "FF8010", "r4l after immediate 1", "RAM, then saved by the 0xDCE2 caller", "sub_DDFE"),
    (0x00DE1A, 4, "FF8011", "r5l from sub_DDE4, unconditional", "RAM, then saved by the 0xDCE2 caller", "sub_DDFE"),
    (0x00DF46, 4, "FF8011", "r5l when the two samples agreed and the value differs", "RAM, then saved by 0xDCE2", "sub_DEFA"),
    (0x0236E2, 4, "FF800F", "r4l = FFAD95", "saved by jsr sub_39544 at 0x236EA", "sub_236B8"),
    (0x0236E6, 4, "FF8010", "r3l, forced 0 when FF8011!=0 and destination is 6 or 7", "saved by jsr sub_39544 at 0x236EA", "sub_236B8"),
    (0x073B12, 4, "FF8010", "r4l after immediate 1", "RAM only", "sub_73AFE"),
    (0x073B16, 4, "FF8011", "r4l after immediate 1", "RAM only", "sub_73AFE"),
    (0x073BA0, 4, "FF8010", "r4l after immediate 1, after a block reload", "RAM only", "sub_73B6C"),
    (0x073BA4, 4, "FF8011", "r4l after immediate 1, after a block reload", "RAM only", "sub_73B6C"),
    (0x0740F6, 4, "FF800F", "r1h, the high byte of the word at FF96FA", "saved by jsr sub_39544 at 0x740FE", "sub_740E2"),
    (0x0740FA, 4, "FF8010", "r3l, 0 when r1h is 6 or 7, else r1l", "saved by jsr sub_39544 at 0x740FE", "sub_740E2"),
    (0x03AC52, 2, "FF800E-FF8015", "each EEPROM byte, er1 starting at FF800E", "load of EEPROM 0x20 for 8 bytes", "sub_3AB80 via sub_39534"),
    (0x03955E, 6, "pointer", "mov.l #0xFF800E, er1 with er0=0x20 and r6=8", "arms load and save", "sub_39554"),
    (0x00DC8C, 4, "block", "jsr sub_39534 on the TAIS path", "loads EEPROM 0x21-0x23", "boot"),
    (0x00DCD6, 4, "block", "jsr sub_39534 on the non-TAIS path", "loads EEPROM 0x21-0x23", "boot"),
    (0x073B6C, 4, "block", "jsr sub_39534", "reloads EEPROM 0x21-0x23, then RAM-forces 10 and 11", "sub_73B6C"),
    (0x00DCE2, 4, "block", "jsr sub_39544", "saves EEPROM 0x20-0x27", "boot"),
    (0x0236EA, 4, "block", "jsr sub_39544", "saves EEPROM 0x20-0x27", "sub_236B8"),
    (0x0740FE, 4, "block", "jsr sub_39544", "saves EEPROM 0x20-0x27", "sub_740E2"),
]


def hx(b):
    return " ".join("{:02x}".format(x) for x in b)


def main():
    img = sys.exit("The firmware image is not in this repository.")
    assert len(img) == 1048576
    dig = hashlib.sha256(img).hexdigest()
    if dig != EXPECT:
        raise SystemExit("sha mismatch " + dig)
    mask = open(MASK, "rb").read()
    if len(mask) != len(img):
        raise SystemExit("mask len %d" % len(mask))
    os.makedirs(OUT, exist_ok=True)

    cit_lines = ["addr\thex\tlabel\tclaim"]
    code_clear = []
    data_clear = 0
    data_total = 0
    for addr, n, label, claim, kind in CITES:
        blob = img[addr:addr + n]
        cit_lines.append("0x%06x\t%s\t%s\t%s" % (addr, hx(blob), label, claim))
        clear = [addr + i for i in range(n) if mask[addr + i] == 0]
        if kind == "data":
            data_total += n
            data_clear += len(clear)
        elif clear:
            code_clear.append((addr, len(clear), n))

    w_lines = ["addr\thex\tdest\tsource\tsaved\tlabel"]
    for addr, n, dest, source, saved, label in WRITERS:
        blob = img[addr:addr + n]
        w_lines.append("0x%06x\t%s\t%s\t%s\t%s\t%s" % (addr, hx(blob), dest, source, saved, label))

    # direct store encodings and the block pointer, inside and outside the window
    pats = []
    for i in range(0, 0x80000 - 6):
        b = img[i:i + 6]
        hit = False
        if b[0] == 0x6A and (b[1] & 0xF0) == 0x80 and b[2] == 0x80 and b[3] in (0x0E, 0x0F, 0x10, 0x11):
            hit = True
            n = 4
        elif b[0] == 0x7A and b[1] == 0x01 and b[2:6] == b"\x00\xff\x80\x0e":
            hit = True
            n = 6
        if hit:
            win = WIN[0] <= i <= WIN[1]
            pats.append((i, n, win))
    # jsr/jmp abs24 to the block helpers
    js = []
    for i in range(0, 0x80000 - 3):
        if img[i] in (0x5E, 0x5A):
            t = (img[i + 1] << 16) | (img[i + 2] << 8) | img[i + 3]
            if t in (0x39534, 0x39544, 0x39554, 0xDDFE):
                js.append((i, img[i], t))

    # mov.l #imm, erN for the small EEPROM addresses used by the block and marker helpers
    imm = []
    want = {0x10, 0x20, 0x21, 0x22, 0x23, 0x40}
    for i in range(0, 0x80000 - 5):
        if img[i] == 0x7A and img[i + 1] <= 7:
            v = struct.unpack_from(">I", img, i + 2)[0]
            if v in want:
                imm.append((i, img[i + 1], v))

    with open(os.path.join(OUT, "citations.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(cit_lines) + "\n")
    with open(os.path.join(OUT, "writers.tsv"), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(w_lines) + "\n")

    rep = []
    rep.append("sha256 %s" % dig)
    rep.append("cites %d writers %d" % (len(CITES), len(WRITERS)))
    rep.append("code ranges with mask-clear bytes: %d" % len(code_clear))
    for row in code_clear:
        rep.append("  code clear 0x%06x %d of %d" % row)
    rep.append("data bytes cited %d mask-clear %d" % (data_total, data_clear))
    rep.append("store/pointer hits %d window hits %d" % (len(pats), sum(1 for p in pats if p[2])))
    for p in pats:
        rep.append("  0x%06x len %d win %s %s" % (p[0], p[1], p[2], hx(img[p[0]:p[0] + p[1]])))
    rep.append("jsr/jmp helpers %d" % len(js))
    for a, op, t in js:
        rep.append("  0x%06x op %02x -> 0x%06x" % (a, op, t))
    rep.append("mov.l small eeprom imm %d" % len(imm))
    for a, n, v in imm:
        rep.append("  0x%06x er%d #0x%x" % (a, n, v))
    text = "\n".join(rep) + "\n"
    with open(os.path.join(OUT, "mask-check.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    print(text)


if __name__ == "__main__":
    main()

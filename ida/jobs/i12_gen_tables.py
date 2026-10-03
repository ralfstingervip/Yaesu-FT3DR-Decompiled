r"""Lane I12: byte-verify every load-bearing cite and write the machine tables.

Plain Python (not an IDA job). Reads decrypted\*.bin only; writes ida\out\usb-vendor\*.tsv.
  python "ida/jobs/i12_gen_tables.py"
Exits non-zero if any cited byte run differs from the image.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import hashlib, os, sys

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "usb-vendor")
MAIN = sys.exit("The firmware image is not in this repository.")
SUB = sys.exit("The firmware image is not in this repository.")
WLO, WHI = 0x078106, 0x07B754

def H(s): return bytes.fromhex(s.replace(" ", ""))

# (image, addr, expected hex, what)
CITES = [
 ("MAIN", 0x055810, "08 01 00 02 00 00 00 08", "8-byte first-request device descriptor stub (bLength patched to 8)"),
 ("MAIN", 0x055818, "12 01 00 02 00 00 00 08 aa 26 01 00 00 00 00 00 00 01", "device descriptor 26AA:0001"),
 ("MAIN", 0x05582A, "09 02 20 00 01 01 00 c0 32 09 04 00 00 02 ff 01 ff 00 07 05 01 02 40 00 00 07 05 83 03 08 00 64", "config copy A (only its first 9 bytes are ever sent)"),
 ("MAIN", 0x05584A, "00 05 58 5e 00 05 58 7e 00 05 58 9e 00 05 58 be 00 05 58 de", "config variant pointer table (index forced to 0)"),
 ("MAIN", 0x05585E, "09 02 20 00 01 01 00 c0 32 09 04 00 00 02 ff 01 ff 00 07 05 01 02 40 00 00 07 05 83 03 08 00 14", "config variant 0 = the 32 bytes actually served (EP 0x83 bInterval 0x14)"),
 ("MAIN", 0x05589D, "64", "variant 1 bInterval (never served)"),
 ("MAIN", 0x0558BD, "96", "variant 2 bInterval (never served)"),
 ("MAIN", 0x0558DD, "c8", "variant 3 bInterval (never served)"),
 ("MAIN", 0x0558FD, "fa", "variant 4 bInterval (never served)"),
 ("MAIN", 0x0558FE, "80 06 00 01 00 00 08 00 00 80 06 00 01 00 00 08 08 00 80 06 00 01 00 00 00 08 00 80 06 00 01 00 00 00 08 00 80 06 00 01 01 00 00 08 00 80 06 00 00 01 00 00 08 00 80 06 06 00 01 00 00 08 00 80", "8 byte-rotations of GET_DESCRIPTOR(device,8): SETUP resync templates"),
 ("MAIN", 0x05593E, "80 06 00 01 00 00 12 00 80 06 00 02 00 00 09 00 80 06 00 02 00 00 20 00 c1 d4 00 00 00 00 01 00 41 d1 ff ff ff ff 00 00 41 d2 ff ff ff ff 00 00 41 d3 ff ff ff ff 00 00", "7 unreferenced reference SETUP templates (wLength of D1/D2/D3 = 0, D4 = 1)"),
 ("MAIN", 0x054C12, "00 00 10 00 00 14 20 80 00 01 24 28 80 00 02 34 38 10 00 03", "endpoint-information table, 4 live 5-byte entries (EP0 ctl 8, EP1 bulk OUT 64, EP2 bulk IN 64, EP3 int IN 8)"),
 ("MAIN", 0x054BF8, "f4 32 7a 05 00 05 4c 12 6c 5c 6a 8c ee 32 1a 04 46 f6", "sub_54BF8: 0x32 bytes -> 0xFFEE32 (EPIR)"),
 ("MAIN", 0x054C60, "79 04 ff ff 01 00 6b 84 81 84", "init FF8184 dword = 0x0100FFFF (e4=0x0100)"),
 ("MAIN", 0x054C94, "fc 8d 6a 8c ee 04 fc 03 6a 8c ee 05 fc 18 6a 8c ee 06 6a 18 ee 2d 70 20", "IER0=0x8D IER1=0x03 IER2=0x18, enable module (bset #2 EE2D)"),
 ("MAIN", 0x054D20, "40 2a fc 08 6a 8c ee 2f", "vec238: bra over dead EE2F pulse block 0x054D22"),
 ("MAIN", 0x054D54, "6a 0c 81 3a 58 60 01 4c", "vec234: selector 0xFF813A !=0 -> window edge 0x054EB0"),
 ("MAIN", 0x054D86, "fc 73 6a 8c ee 28 6a 18 81 80 70 60", "IFR0 b7 (bus reset): FIFO clear 0x73, flag 8180.6; FF8183 untouched"),
 ("MAIN", 0x054DAC, "f5 08 01 00 6b 04 81 56 6a 0d ee 0e 68 cd", "IFR0 b3: 8 SETUP bytes from 0xFFEE0E into ring"),
 ("MAIN", 0x054DD2, "fc 04 6a 8c ee 2c", "TRG=0x04 after SETUP read"),
 ("MAIN", 0x054DF2, "6a 04 ee 24 47 12 7a 05 00 ff 3c 6a 6a 0c ee 0d", "IFR0 b2: EPSZ0o bytes from 0xFFEE0D into 0xFF3C6A"),
 ("MAIN", 0x054E30, "6a 0c 81 83 ac 04 46 12 fc 8d 6a 8c ee 04 fc 00 6a 8c b0 94 fc 01 6a 8c ee 2c", "IFR0 b1: in state 4 send zero-length status packet"),
 ("MAIN", 0x054E84, "6c 54 6a 84 ee 0c", "IFR0 b0: EP0 IN bytes from [0xFFB09E] to 0xFFEE0C"),
 ("MAIN", 0x054EB0, "5e 07 82 7c", "edge into closed window (CDC service routine 0x07827C)"),
 ("MAIN", 0x054EE0, "77 3c 6a 18 81 80 67 00", "vec235 IFR1 b0: copy IFR1 b3 (VBUS level) to 8180.0"),
 ("MAIN", 0x054EF0, "6a 8c 81 83", "vec235: FF8183 = 0 on every VBUS change"),
 ("MAIN", 0x054F36, "6d 74 56 70 73 2c 47 4a", "rte, then the unreachable EP3 block at 0x054F3A"),
 ("MAIN", 0x054FEC, "6a 0b 81 83 7a 63 00 00 00 ff 10 73 78 b0 6b 26 00 05 50 02 59 60", "poll dispatcher on FF8183"),
 ("MAIN", 0x055002, "00 05 50 34 00 05 50 42 00 05 51 96 00 05 51 aa 00 05 51 c2 00 05 50 42 00 05 51 da 00 05 53 06 00 05 55 20 00 05 55 52 00 05 53 06 00 05 56 c8", "12-slot control state table"),
 ("MAIN", 0x05507C, "79 2a 80 06 47 56 79 2a c1 d4 47 50 79 2a 41 d3 47 4a 79 2a 41 d1 47 44 79 2a 41 d2 47 3e", "known-request pre-filter (skips template search)"),
 ("MAIN", 0x0550D8, "79 2a 80 06 58 60 ff 52 aa 01 47 44 aa 02 47 0a aa 03 58 60 ff 44 58 00 ff 40", "state 1/5 accepts 0x8006 only; type 3 (string) dropped"),
 ("MAIN", 0x0550FE, "6a 0d 89 cf fd 00 10 4d", "config index read from FF89CF then overwritten with 0"),
 ("MAIN", 0x05510C, "78 d0 6b 25 00 05 58 4a", "config pointer = table[0]"),
 ("MAIN", 0x055116, "6a 18 81 81 70 00 fb 05 fe 09 7a 05 00 05 58 2a", "first config request: 9 bytes, next state 5"),
 ("MAIN", 0x055128, "fb 05 6a 0c 81 83 ac 01 47 0a fe 12 7a 05 00 05 58 18 40 08 fe 08 7a 05 00 05 58 10", "device descriptor: 8 bytes in state 1, 18 bytes in state 5"),
 ("MAIN", 0x0550FA, "fb 06 fe 20", "full config: 0x20 bytes, next state 6"),
 ("MAIN", 0x055144, "6a 8e b0 94 01 00 6b 85 b0 9e 6a 8b 81 82", "sub_55144: length, source pointer, next-state latch"),
 ("MAIN", 0x0552D8, "79 2a c1 d4 46 26 fb 07 fe 01", "state 6 accepts C1 D4 only: 1 byte, next state 7"),
 ("MAIN", 0x0552F6, "6a 8c b0 95 7a 05 00 ff b0 95 5e 05 51 44", "D4 data stage = quality code at 0xFFB095"),
 ("MAIN", 0x055404, "79 2a 41 d3 58 70 00 da 79 2a 41 d1 58 60 01 08", "state 7/10 accepts 41 D3 and 41 D1 only"),
 ("MAIN", 0x055414, "6a 0c 94 c0 ac 00 58 60 00 94 6a 10 89 c1 73 30 47 0a 6a 10 89 ab 73 00 58 70 00 82 6a 2c 00 ff 2e c9 46 7a", "D1 gates: TX state, KEY LOCK + lock type, picture busy"),
 ("MAIN", 0x05543E, "7a 06 00 ff 3d 6c 6c 6c 6c 64 6c 6d f5 00 0d 5c", "D1 size = wIndexL<<16 | wValue"),
 ("MAIN", 0x05546E, "6b 84 b0 9c", "packet count to FFB09C (no reader)"),
 ("MAIN", 0x055488, "6a 18 a9 e3 70 40 fc 4f 6a 8c aa e0 fc 01 6a 8c 81 84 fc 08 6a 8c 81 83", "D1 accept: A9E3.4, tone/event 0x4F, FF8184=1, state 8"),
 ("MAIN", 0x0554A4, "7a 04 00 ff 58 06 01 00 6b 84 bc 48", "forward pointer = 0xFF5806"),
 ("MAIN", 0x0554B2, "fc 01 6a 8c ba 72 fc 0b 6a 8c 81 82", "D1 refuse: discard flag, next state 11"),
 ("MAIN", 0x0554E6, "6a 2c 00 ff 3d 6c 6a 8c b0 96 fc 07 6a 8c 81 82", "D3: wValueL -> FFB096, next state 7"),
 ("MAIN", 0x055520, "6a 0c aa e8 46 f8 fc 09", "state 8: hold D1 status stage until FFAAE8 == 0"),
 ("MAIN", 0x055552, "6a 0c ee 00 73 6c 58 60 00 f6", "state 9: IFR0 b6 (EP1 full) -> bulk read"),
 ("MAIN", 0x0555F4, "79 2a 41 d2 46 56", "state 9 accepts 41 D2 only"),
 ("MAIN", 0x055612, "5e 05 59 f4 fc 00 6a ac 00 ff 2e c9 fc ff 6a 8c 81 85 fc 0a 6a 8c 81 82", "D2: flush last block, clear busy, force EP3 report, next state 10"),
 ("MAIN", 0x055652, "6a 04 ee 25", "EP1 byte count"),
 ("MAIN", 0x055684, "6a 0c ee 10 68 dc", "EP1 byte copy into 0xFF5806+index"),
 ("MAIN", 0x0556C0, "fc 20 6a 8c ee 2c", "TRG=0x20 (EP1 read done)"),
 ("MAIN", 0x055768, "79 2a 41 d2 46 32 fc ff 6a 8c 81 85 fc 0a", "state 11: D2 after refused D1 -> state 10, no forward"),
 ("MAIN", 0x0557A2, "fc 01 6a 8c 81 84", "sub_557A2 forces FF8184=1"),
 ("MAIN", 0x0557D0, "6a 0c ee 27 73 5c 46 36 6a 0c 81 84 6a 8c ee 18", "EP3 report byte0 = FF8184 (skipped while EE27 b5 set)"),
 ("MAIN", 0x0557E4, "6a 04 89 ce 6a 84 ee 18", "EP3 report byte1 = FF89CE (SIZE)"),
 ("MAIN", 0x0557EC, "6a 0c 89 cd 47 0c ac 01 47 04 fc 50 40 06 fc 30 40 02 fc 18 6a 8c ee 18", "EP3 report byte2 = 0x18/0x30/0x50 from FF89CD (QUALITY)"),
 ("MAIN", 0x055804, "6b 84 81 86 fc 40 6a 8c ee 2c", "remember sent bytes 1-2; TRG=0x40 (EP3 packet enable)"),
 ("MAIN", 0x055B6E, "6a 8c bc 4f", "orphan 0x055B58: only non-zero writer of FFBC4F"),
 ("MAIN", 0x055B98, "78 b0 6b 26 00 05 5b f2 5d 60", "jsr via table 0x055BF2 (5 slots, state FFBC50)"),
 ("MAIN", 0x055BC0, "78 b0 6b 26 00 05 5c 06 5d 60", "jsr via table 0x055C06 (3 slots, state FFBC54)"),
 ("MAIN", 0x055BE8, "78 b0 6b 26 00 05 5c 12 59 60", "jmp via table 0x055C12 (3 slots, state FFBC57)"),
 ("MAIN", 0x055BF2, "00 05 5c 1e 00 05 5c 7e 00 05 5c ea 00 05 5d 6c 00 05 5d 8a 00 05 5d 8c 00 05 5d e8 00 05 5d fa 00 05 5f 84 00 05 5f 96 00 05 5f f0", "the three sub-dispatch tables, 5+3+3 slots"),
 ("MAIN", 0x055BAA, "6a 8c bc 51", "only writer of FFBC51 (writes 0)"),
 ("MAIN", 0x055DD4, "7a 04 00 ff 58 06 01 00 6b 84 bc 48", "read-back destination pointer = 0xFF5806"),
 ("MAIN", 0x055DEE, "5e 00 b5 ce", "FE00 read-back request issued here (not at 0x055FDE)"),
 ("MAIN", 0x00B5DE, "79 04 fe 00", "FE00 SCI-D command word"),
 ("MAIN", 0x055EAE, "68 ec", "second writer of the 0xFF5806 window (through FFBC48)"),
 ("MAIN", 0x055EE8, "5e 06 ee 36", "1 KB read-back flush call"),
 ("MAIN", 0x06EE36, "54 70", "... which is a bare rts"),
 ("MAIN", 0x055FDE, "5e 00 b6 10", "0x055FDE is an FFFF block send (SM-C), not a read-back"),
 ("MAIN", 0x055F76, "fc 1d 6a 8c aa e0", "read-back error -> event 0x1D (internal only)"),
 ("MAIN", 0x00FB9E, "5e 00 fd c8", "key scan polls the D3 edge machine"),
 ("MAIN", 0x00FDC8, "6a 0a b0 96 6a 0b b0 97", "D3 edge machine reads FFB096/FFB097"),
 ("MAIN", 0x00FDFE, "fc 14 6a 8c a9 ed fc 02 6a 8c b0 97", "D3 0->non-zero edge posts key code 0x14"),
 ("MAIN", 0x06F5D0, "6a 10 8e a0 73 60", "key 0x14 handler entry (main key table col 11)"),
 ("MAIN", 0x06F640, "7a 04 2e 6a 70 67", "'.jpg' appended to last picture name"),
 ("MAIN", 0x0020F6, "f9 01 40 02 f9 00", "boot entry flag r1l: 0x20F6 -> 1, 0x20FA -> 0"),
 ("MAIN", 0x0021F8, "fc 00 6a 8c 81 3a fe c8 2c 4c ec 7f ac 7d 47 16", "selector=0, 200 polls of port 0xFFFF4C for 0x7D"),
 ("MAIN", 0x002210, "a9 00 46 04 5e 05 4b f8 5e 05 4c 44", "normal personality: EPIR load (cold entry only) + vendor init"),
 ("MAIN", 0x002222, "fc 01 6a 8c 81 3a 5e 05 5f fe", "strap personality: selector=1"),
 ("MAIN", 0x002234, "5e 07 81 06", "edge into closed window (CDC init 0x078106)"),
 ("MAIN", 0x002BE2, "6a 0c 81 3a 46 04 5e 05 4f ec", "main loop: control machine only when selector==0"),
 ("MAIN", 0x002C06, "6a 0c 81 3a 46 1c", "main loop: image sub-dispatch block only when selector==0"),
 ("MAIN", 0x002C20, "5e 05 5b 7a", "jsr sub_55B7A"),
 ("MAIN", 0x0393DC, "6a 8b 81 84", "FF8184 = r3l (0 or 1) in sub_391C0"),
 ("MAIN", 0x03935A, "6a 10 89 c5 73 10 47 04 fb 01 40 76 6a 0c a9 e3 ec 2c 47 04 fb 00 40 6a fb 01", "byte0 logic: SP SEL bit -> 1; A9E3&0x2C -> 0"),
 ("MAIN", 0x039462, "6a 8c 81 84", "FF8184 = 1 in sub_39454"),
 ("MAIN", 0x00594C, "6a 03 89 ce 6a 0b 89 cd 6b 83 b0 5a fb 00 6a 10 89 c5 77 10 67 0b 6a 8b b0 5c 79 0b f3 d0", "F3D0 USB CAMERA sender: [89CE, 89CD, 89C5.1]"),
 ("MAIN", 0x022562, "6a 10 89 c1 73 30 47 0c 6a 0c 89 ab ac 03", "TX inhibit: KEY LOCK on and lock type >= 3 (PTT ...)"),
 ("MAIN", 0x0383AC, "7a 05 00 03 83 9c", "tone/event sequencer list pointer"),
 ("MAIN", 0x03839C, "4f 1e 35 5d ff", "event list containing D1's 0x4F"),
 ("MAIN", 0x00A654, "6a 0c 89 c6 ec 7f f4 00 10 54 7a 64 00 00 ff ff 78 c0 6b 25 00 00 64 4c", "RAM DISPLAY (F3D1) base = table 0x00644C[FF89C6 & 0x7F]"),
 ("MAIN", 0x00A694, "79 04 f3 d1", "F3D1 frame code"),
 ("MAIN", 0x006528, "00 ff 81 80 00 ff b0 94 00 ff 3c 6a 00 ff ee 00", "RAM DISPLAY slots 55-58: FF8180, FFB094, FF3C6A, FFEE00 (USB state)"),
 ("MAIN", 0x055460, "47 50", "D1 refused when size == 0"),
 ("MAIN", 0x055A2C, "7a 04 00 00 4e 20", "busy-wait 0x4E20 after each 1 KB wrap"),
 ("MAIN", 0x00B614, "6a 0c bb e4 46 fa", "sub_B610 blocks until SCI-D TX idle"),
 ("MAIN", 0x06F5E6, "6a 0c ba 32 58 70 00 b0 6a 2c 00 ff 2e c9 58 60 00 a6", "key 0x14 handler gates FFBA32 / FF2EC9"),
 ("MAIN", 0x00FD5E, "2a 4e ea 10", "sibling debouncer on port 0xFFFF4E b4"),
 ("MAIN", 0x054ECC, "58 70 00 b8", "IFR1 b0 false -> 0x054F88 (skips 0x054F3A)"),
 ("MAIN", 0x05E9F2, "6a 04 81 3a", "12th reader of FF813A"),
 ("MAIN", 0x055EAE, "68 ec 0b 06", "read-back store loop through FFBC48"),
 ("SUB", 0xFFC3E709, "55 53 42 20 43 41 4d 45 52 41 00", "'USB CAMERA' setup label"),
 ("SUB", 0xFFF4A496, "33 32 30 2a 32 34 30 00 31 36 30 2a 31 32 30 00", "SIZE values 320*240 / 160*120"),
 ("SUB", 0xFFF48FD9, "4b 45 59 00 00 00 00 00 00 44 49 41 4c 00 00 00 00 00 4b 45 59 26 44 49 41 4c 00 50 54 54 00 00 00 00 00 00 4b 45 59 26 50 54 54 00 00 44 49 41 4c 26 50 54 54 00 41 4c 4c 00", "LOCK type list KEY/DIAL/KEY&DIAL/PTT/KEY&PTT/DIAL&PTT/ALL (9-byte stride)"),
]

def rd(img, addr, n):
    if img == "MAIN": return MAIN[addr:addr + n], addr
    off = addr - 0xFFC00000
    return SUB[off:off + n], off

def main():
    os.makedirs(OUT, exist_ok=True)
    bad = 0
    rows = ["image\taddr\tfile_offset\tlen\tbytes\tstatus\twhat"]
    for img, a, hx, what in CITES:
        exp = H(hx)
        got, off = rd(img, a, len(exp))
        ok = got == exp
        if not ok: bad += 1
        rows.append("%s\t%06X\t%06X\t%d\t%s\t%s\t%s" % (img, a, off, len(exp), got.hex(" "), "OK" if ok else "MISMATCH exp " + exp.hex(" "), what))
    with open(os.path.join(OUT, "byte-verify.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("# sha256 MAIN %s SUB %s\n" % (hashlib.sha256(MAIN).hexdigest()[:16], hashlib.sha256(SUB).hexdigest()[:16]))
        h.write("\n".join(rows) + "\n")
    # descriptor field table, generated from the served bytes
    dev = MAIN[0x055818:0x05582A]
    cfg = MAIN[0x05585E:0x05587E]
    f = ["descriptor\taddr\toffset\tfield\tvalue\tmeaning"]
    devf = [("bLength",1,""),("bDescriptorType",1,"DEVICE"),("bcdUSB",2,"USB 2.00 (full-speed device)"),("bDeviceClass",1,"0 = per interface"),
            ("bDeviceSubClass",1,""),("bDeviceProtocol",1,""),("bMaxPacketSize0",1,"EP0 8 bytes"),("idVendor",2,"0x26AA"),("idProduct",2,"0x0001"),
            ("bcdDevice",2,"0.00"),("iManufacturer",1,"no string"),("iProduct",1,"no string"),("iSerialNumber",1,"no string"),("bNumConfigurations",1,"1")]
    o = 0
    for n, sz, m in devf:
        v = int.from_bytes(dev[o:o+sz], "little")
        f.append("device\t%06X\t%d\t%s\t0x%0*X\t%s" % (0x055818+o, o, n, sz*2, v, m)); o += sz
    cfgf = [("config","bLength",1,""),("config","bDescriptorType",1,"CONFIGURATION"),("config","wTotalLength",2,"32 bytes"),("config","bNumInterfaces",1,""),
            ("config","bConfigurationValue",1,""),("config","iConfiguration",1,"no string"),("config","bmAttributes",1,"self-powered, no remote wakeup"),("config","bMaxPower",1,"100 mA"),
            ("interface","bLength",1,""),("interface","bDescriptorType",1,"INTERFACE"),("interface","bInterfaceNumber",1,""),("interface","bAlternateSetting",1,""),
            ("interface","bNumEndpoints",1,"2"),("interface","bInterfaceClass",1,"vendor specific"),("interface","bInterfaceSubClass",1,""),("interface","bInterfaceProtocol",1,"vendor specific"),("interface","iInterface",1,"no string"),
            ("endpoint1","bLength",1,""),("endpoint1","bDescriptorType",1,"ENDPOINT"),("endpoint1","bEndpointAddress",1,"EP1 OUT"),("endpoint1","bmAttributes",1,"bulk"),("endpoint1","wMaxPacketSize",2,"64"),("endpoint1","bInterval",1,"ignored for bulk"),
            ("endpoint2","bLength",1,""),("endpoint2","bDescriptorType",1,"ENDPOINT"),("endpoint2","bEndpointAddress",1,"EP3 IN"),("endpoint2","bmAttributes",1,"interrupt"),("endpoint2","wMaxPacketSize",2,"8"),("endpoint2","bInterval",1,"20 ms (full speed)")]
    o = 0
    for d, n, sz, m in cfgf:
        v = int.from_bytes(cfg[o:o+sz], "little")
        f.append("%s\t%06X\t%d\t%s\t0x%0*X\t%s" % (d, 0x05585E+o, o, n, sz*2, v, m)); o += sz
    f.append("string\t-\t-\t(any index)\t-\tnot served: GET_DESCRIPTOR type 3 is dequeued and dropped (0x0550E8); no string or LANGID table in the image")
    with open(os.path.join(OUT, "descriptors.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(f) + "\n")
    print("cites", len(CITES), "mismatch", bad)
    return bad

if __name__ == "__main__":
    sys.exit(1 if main() else 0)

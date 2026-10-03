# -*- coding: utf-8 -*-
# Lane N9 byte-verifier (read-only). Asserts every byte citation in doc 136
# against the MAIN image, and re-derives the period/clock facts.
import sys
import hashlib
IMG = "decrypted/FT3D_MAIN_ver102_EXP.bin"
sys.exit('The firmware image is not in this repository.')
b = open(IMG, "rb").read()
EXP = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"
got = hashlib.sha256(b).hexdigest()
assert got == EXP, f"MAIN sha256 mismatch {got}"
ok = 0; fail = []
def chk(off, hexs, note):
    global ok
    want = bytes.fromhex(hexs.replace(" ", ""))
    have = b[off:off+len(want)]
    if have == want: ok += 1
    else: fail.append(f"{note} @0x{off:06X}: want {want.hex()} got {have.hex()}")
def be32(off): return int.from_bytes(b[off:off+4], "big")
# --- vector table (256 BE32 @ 0) ---
chk(0x110, "00 00 28 f4", "vec68 IRQ4")
chk(0x114, "00 00 29 22", "vec69 IRQ5")
chk(0x160, "00 00 28 d0", "vec88 TPU0 TGIA")
chk(0x174, "00 00 29 50", "vec93 TPU1 TGIA(DDS TX)")
chk(0x184, "00 00 28 e2", "vec97 TPU2 TGIA")
# --- IRQ4 capture ISR 0x28F4 ---
chk(0x28F4, "01 10 6d f4", "IRQ4 prologue")
chk(0x28F8, "6b 0d ff c6", "IRQ4 read TPU0 TCNT @FFFFC6")
chk(0x2900, "6b 84 ff c6", "IRQ4 reset TCNT")
chk(0x2904, "6b 04 ff 36 72 4c 6b 84 ff 36", "IRQ4 clear flag36.4")
chk(0x290E, "25 c5 73 45", "IRQ4 TPU0 TSR @FFFFC5 btst#4")
chk(0x291A, "01 00 6b 04 81 1a 59 40", "IRQ4 dispatch @FF811A")
# --- IRQ5 capture ISR 0x2922 ---
chk(0x2926, "6b 0d ff e6", "IRQ5 read TPU2 TCNT @FFFFE6")
chk(0x2932, "6b 04 ff 36 72 5c 6b 84 ff 36", "IRQ5 clear flag36.5")
chk(0x293C, "25 e5 73 45", "IRQ5 TPU2 TSR @FFFFE5 btst#4")
chk(0x2948, "01 00 6b 04 81 1e 59 40", "IRQ5 dispatch @FF811E")
# --- TGIA handlers ---
chk(0x28D4, "7f c5 72 00 2c 40", "v88 clr TGFA@FFFFC5, read port@FFFF40")
chk(0x28DA, "01 00 6b 06 81 1a 59 60", "v88 dispatch @FF811A")
chk(0x28E6, "7f e5 72 00 2c 40", "v97 clr TGFA@FFFFE5, read port@FFFF40")
chk(0x28EC, "01 00 6b 06 81 1e 59 60", "v97 dispatch @FF811E")
# --- CTCSS/tone period handlers band A: windows & reloads ---
chk(0x171C, "6a 0c 8f 87", "hA read state 8F87")
chk(0x172A, "79 2d 39 8c", "hA window lo cmp 0x398C")
chk(0x1730, "79 2d 3d 84", "hA window hi cmp 0x3D84")
chk(0x1736, "6b 04 8f 7c", "hA match-ctr 8F7C")
chk(0x176A, "79 0c 00 96 79 04 01 2c", "hA reload 150/300 -> 8F7C/8F7E")
chk(0x1742, "fc 01 6a 8c 8f 88", "hA set result 8F88=1")
chk(0x1784, "6a 0c 8f 87", "hB read state 8F87")
chk(0x179A, "79 2d 18 82", "hB window lo cmp 0x1882")
chk(0x17A0, "79 2d 1f 90", "hB window hi cmp 0x1F90")
chk(0x17B2, "fc 02 6a 8c 8f 88", "hB set result 8F88=2")
chk(0x17C0, "79 0c 00 7a 79 04 00 c8", "hB reload 122/200 -> 8F7C")
chk(0x181A, "6a 0c 8f 87", "hC read state 8F87")
chk(0x1830, "6b 05 8f 8c 1d 5d", "hC prog window lo 8F8C")
chk(0x1838, "6b 05 8f 8a 1d 5d", "hC prog window hi 8F8A")
# --- window-table loader 0x17DA ---
chk(0x17DA, "7a 64 00 00 00 ff 10 74 10 74", "17DA idx&0xFF, x16")
chk(0x17E4, "01 00 6f 45 18 80", "17DA load @(0x1880,er4)")
chk(0x17F8, "6a 10 89 be 73 40", "17DA btst#4 @FFFF89BE (halve)")
# --- band B twin RAM block (+0x100) ---
chk(0x1F54, "6a 0c 90 8f", "hB-B read state 908F")
chk(0x1F84, "6a 8c 90 90", "hB-B result 9090")
chk(0x1F76, "6b 04 90 84", "hB-B match-ctr 9084")
chk(0x1F5E, "6b 04 90 86", "hB-B attempt-ctr 9086")
# --- pointer installs (band A selector sub_2FAEC) ---
chk(0x2FB0A, "7a 04 00 00 17 84 01 00 6b 84 81 1a", "install 0x1784->FF811A")
chk(0x2FB26, "7a 04 00 00 18 1a 01 00 6b 84 81 1a", "install 0x181A->FF811A")
chk(0x2FB4E, "7a 04 00 00 17 1c 01 00 6b 84 81 1a", "install 0x171C->FF811A")
# --- band B selector sub_31594 ---
chk(0x315B2, "7a 04 00 00 1f 54 01 00 6b 84 81 1e", "install 0x1F54->FF811E")
chk(0x315CE, "7a 04 00 00 1f ea 01 00 6b 84 81 1e", "install 0x1FEA->FF811E")
chk(0x315F6, "7a 04 00 00 1e ec 01 00 6b 84 81 1e", "install 0x1EEC->FF811E")
# --- idle/default dispatch targets ---
chk(0xDC12, "7a 04 00 00 04 aa 01 00 6b 84 81 1a", "idle FF811A=0x4AA")
chk(0xDC1E, "7a 04 00 00 0e 5e 01 00 6b 84 81 1e", "idle FF811E=0xE5E")
chk(0x4AA, "06 7f", "0x4AA = andc#0x7F,ccr (rte-ish stub)")
# --- TPU0 prescaler ---
chk(0x22C4, "fc 20 3c c0", "init TCR0=0x20 (phi/1)")
chk(0x2F5A2, "3c c0", "rx_start store TCR0")
chk(0x2F5A0, "fc 01 3c c0", "rx_start TCR0=0x01 (phi/4)")
chk(0x2F5A8, "fc 00 3c c0", "rx_start-alt TCR0=0x00 (phi/1)")
chk(0x2F566, "6b 04 8f 96 6b 84 ff c8", "stop: TGRA0<-8F96")
# --- DCS RX Golay decoders ---
chk(0x1108, "00 00 11 14", "ptrtbl[0]=0x1114")
chk(0x110C, "00 00 12 ac", "ptrtbl[1]=0x12AC")
chk(0x1110, "00 00 14 24", "ptrtbl[2]=0x1424")
chk(0x1114, "06 7f", "DCS dec 0x1114 entry")
chk(0x111A, "7a 05 00 ff 8f dc", "DCS shift-reg base FF8FDC")
chk(0x11D8, "7a 05 00 00 00 18", "DCS 24-position frame walk (0x18)")
chk(0x11C8, "6a 10 8f 86 73 00", "DCS lock flag 8F86 btst#0")
chk(0x1214, "6a 18 8f 86 70 00", "DCS set lock 8F86.0")
chk(0x11EC, "6e 44 12 8c", "DCS validity tbl @0x128C")
chk(0x128C, "01 01 01 00 01 01 00 00", "DCS validtbl head")
# --- DCS RX config sub_10C0 + records 0x158C ---
chk(0x10C8, "7a 15 00 00 15 8c", "cfg base 0x158C")
chk(0x10D6, "01 00 6f 43 11 08", "cfg ptr from tbl 0x1108")
chk(0x10F0, "6b 84 8f 96", "cfg -> 8F96")
chk(0x158C, "00 0e 06 05 ba 91 01 2d", "cfg rec0")
# --- DCS RX sample period constant (doc120) ---
chk(0x440, "79 04 74 40 6b 84 8f 96", "DCS 0x7440 -> 8F96 (sub_42C)")
chk(0xE4E, "79 04 74 40", "DCS 0x7440 band B (sub_E3A)")
# --- squelch consumers read result 8F88 ---
chk(0x3037C, "6a 0c 8f 88", "consumer 30310 reads 8F88")
chk(0x30464, "6a 0c 8f 88", "consumer 30410 reads 8F88")
chk(0x3052A, "6a 0c 8f 88", "consumer 304DC reads 8F88")
# --- derivations ---
phi = 16e6
def approx(a,c,nm):
    assert abs(a-c)/c < 0.01, f"{nm}: {a} vs {c}"
approx(phi/0x7440, 537.6, "DCS sample 537.6Hz @phi/1")
approx((phi/4)/0x7440, 134.4, "DCS bit 134.4bps @phi/4")
print(f"PASS {ok} byte citations, 0 fail" if not fail else "FAIL")
for f in fail: print("  ", f)
assert not fail

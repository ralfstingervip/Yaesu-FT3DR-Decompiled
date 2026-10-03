#!/usr/bin/env python3
"""M7 lane byte verifier. Read-only. Checks every load-bearing CDC citation
against decrypted/FT3D_MAIN_ver102_EXP.bin. MAIN is H8SX big-endian, base 0,
file offset = mapped address. Prints PASS/FAIL per cite; exits nonzero on any
mismatch. Keep in ida/out/cdc-personality/."""
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, sys, os

ROOT = _REPO_S
IMG = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")
sys.exit("The firmware image is not in this repository.")
sha = hashlib.sha256(b).hexdigest()
print("image len", len(b), "sha", sha[:16])
assert sha.startswith("8e3ecd05409b2c31"), "wrong image"

# (addr, expected hex bytes, label)
CITES = [
    # --- handler record table @0x07B4B4 (RAM FF6242), stride 10 ---
    (0x07B4B4, "80 00 00 00 00 00 00 07 84 be", "rec b7 reset -> 0784BE"),
    (0x07B4BE, "05 00 00 00 01 00 00 07 69 aa", "rec b0|b2 (05) code1 -> 0769AA"),
    (0x07B4C8, "08 00 00 00 00 00 00 07 68 c8", "rec b3 SETUP code0 -> 0768C8"),
    (0x07B4D2, "02 00 00 00 01 00 00 07 69 aa", "rec b1 code1 -> 0769AA"),
    (0x07B4DC, "40 00 00 00 05 00 00 07 67 be", "rec b6 code5 -> 0767BE"),
    (0x07B4E6, "10 00 00 00 04 00 00 07 68 a8", "rec b4 code4 -> 0768A8"),
    (0x07B4F0, "00 00 00 00 ff 00 00 00 00 00", "rec end (ff)"),
    # --- ISR demux walk: jsr @er2 with er0=pending, r1l=+4 byte ---
    (0x078308, "5d 20", "isr demux jsr @er2"),
    (0x078310, "01 cc 50 a1", "isr demux mulxu.b #0xa (stride 10)"),
    # --- SETUP handler 0768C8 ---
    (0x0768CC, "01 7d 40 f7 ee 00", "0768C8: EE00=0xF7 (ack b3)"),
    (0x0768F8, "7a 00 00 fe e0 00", "0768C8: setup buf base FEE000"),
    (0x07691A, "5e 07 6c 0a", "0768C8: jsr sub_76C0A (request parser)"),
    # --- control request dispatcher sub_76C0A ---
    (0x076C12, "7a 04 00 fe e0 00", "76C0A: er4=FEE000 (SETUP pkt)"),
    (0x076C18, "68 48", "76C0A: r0l=@FEE000 (bmRequestType)"),
    (0x076C1A, "a8 80", "76C0A: cmp #0x80 (GET std dev)"),
    (0x076C22, "47 40", "76C0A: beq 0x00 (SET std dev)"),
    (0x076C24, "a8 20", "76C0A: cmp #0x20 (class range lo)"),
    (0x076C28, "a8 23", "76C0A: cmp #0x23 (class range hi, H2D)"),
    (0x076C2C, "a8 a0", "76C0A: cmp #0xA0 (class range lo, D2H)"),
    (0x076C30, "a8 a3", "76C0A: cmp #0xA3 (class range hi, D2H)"),
    (0x076C34, "5e 07 6e f8", "76C0A: jsr sub_76EF8 (class handler)"),
    (0x076C42, "a8 40", "76C0A: cmp #0x40 (vendor range)"),
    (0x076C4A, "a8 c0", "76C0A: cmp #0xC0 (vendor range)"),
    (0x076C56, "5e 07 6f c4", "76C0A: jsr sub_76FC4 (vendor->stall)"),
    (0x076D44, "6a 28 00 fe e0 01", "76C0A: 0x80 path r0l=@FEE001 bRequest"),
    (0x076D4A, "a8 06", "76C0A: cmp #6 (GET_DESCRIPTOR)"),
    (0x076ECC, "6b f3 00 ff 63 14", "76C0A: FF6314=3 (stall marker)"),
    (0x076EE4, "01 5d c1 01 00 10", "76C0A: EP0.state(FF6314)=1 (IN data)"),
    (0x076EEC, "01 5d c1 02 00 10", "76C0A: EP0.state(FF6314)=2 (status)"),
    # --- class request handler sub_76EF8 (CDC bRequest compares) ---
    (0x076EFE, "6a 28 00 fe e0 01", "76EF8: r0l=@FEE001 (bRequest)"),
    (0x076F04, "a8 20", "76EF8: cmp #0x20 SET_LINE_CODING"),
    (0x076F0A, "a8 21", "76EF8: cmp #0x21 GET_LINE_CODING"),
    (0x076F0E, "a8 22", "76EF8: cmp #0x22 SET_CONTROL_LINE_STATE"),
    (0x076F12, "a8 23", "76EF8: cmp #0x23 SEND_BREAK"),
    (0x076F1E, "fb 01", "76EF8: r3l=1 (unknown req -> stall)"),
    (0x076F24, "6a 28 00 fe e0 02", "76EF8: SET_CTRL_LINE r0l=@FEE002 wValueL"),
    (0x076F2A, "a8 03", "76EF8: cmp #3 (DTR|RTS both set)"),
    (0x076F30, "5e 07 85 08", "76EF8: jsr sub_78508 (open: queue init)"),
    (0x076FC4, "0f 10 54 70", "76FC4: vendor stub r0=1; rts (stall)"),
    # --- descriptor pointer records (copied RAM) ---
    (0x07B5EE, "12 00 00 ff 64 0e", "device desc record FF637C: byteLen 0x12 ptr FF640E"),
    (0x07B5F4, "00 43 00 ff 64 9f", "config desc record FF6382: wordLen 0x43 ptr FF649F"),
    (0x07B658, "08 00 00 ff 63 de", "line-coding record FF63E6: len8 buf FF63DE"),
    # --- CDC device + config descriptor (BRIEF correction 1) ---
    (0x07B680, "12 01 10 01 02 00 00 08 aa 26 20 00", "CDC device desc: class2 VID26AA PID0020"),
    (0x07B711, "09 02 43 00 02 01 00 c0 10", "CDC config: 2 intf wTotalLen 0x43"),
    (0x07B71A, "09 04 00 00 01 02 02 01 00", "intf0 CDC-comm class 02/02/01"),
    (0x07B736, "07 05 83 03 08 00 10", "EP 0x83 interrupt IN 8"),
    (0x07B73D, "09 04 01 00 02 0a 00 00 00", "intf1 CDC-data class 0A"),
    (0x07B746, "07 05 01 02 40 00 00", "EP 0x01 bulk OUT 64"),
    (0x07B74D, "07 05 82 02 40 00 00", "EP 0x82 bulk IN 64"),
    # --- entry conditions ---
    (0x002200, "2c 4c ec 7f ac 7d 47 16", "strap: (P@FFFF4C & 0x7F)==0x7D"),
    (0x002224, "6a 8c 81 3a", "strap match: FF813A=1 (r4l=1)"),
    (0x002234, "5e 07 81 06", "jsr 0x078106 (CDC init)"),
    (0x054D54, "6a 0c 81 3a", "USB ISR: load FF813A"),
    (0x054D58, "58 60 01 4c", "USB ISR: bne 0x054EA8 (CDC branch)"),
    (0x054EB0, "5e 07 82 7c", "USB ISR: jsr 0x07827C (CDC demux)"),
    (0x05DD06, "ac 05", "DSP-WRITE gate: cmp #5 (state>=5)"),
    (0x05DD12, "5e 07 81 5c", "DSP-WRITE: jsr 0x07815C (CDC service)"),
    # --- data pump TX (SCI-C) + RX bridge ---
    (0x077018, "01 01 69 31", "pump: read caller ring ptr @(4,er3)"),
    (0x07701E, "29 8c", "pump: read SCI-C SSR @FFFF8C"),
    (0x077022, "30 8b", "pump: write byte to SCI-C TDR @FFFF8B"),
    (0x077008, "79 2a 00 40", "pump: clamp len to 0x40 (64)"),
    (0x07709E, "6a 18 ee 04 70 60", "pump: bset #6 @EE04 (re-arm USB OUT)"),
    (0x07711E, "01 00 6d f2", "RX bridge entry"),
    (0x077134, "28 8d", "RX bridge: read SCI-C RDR @FFFF8D"),
    (0x05615C, "", "SCI-C ISR start (marker only)"),
    (0x056160, "6a 0c 81 3a", "SCI-C ISR: load FF813A"),
    (0x0561B0, "5e 07 71 1e", "SCI-C ISR: jsr 0x07711E (bridge RX, FF813A!=0)"),
]

fails = 0
for addr, hexs, label in CITES:
    if hexs == "":
        print("MARK %06X  %s" % (addr, label))
        continue
    want = bytes(int(x, 16) for x in hexs.split())
    got = b[addr:addr + len(want)]
    ok = got == want
    if not ok:
        fails += 1
    print("%s %06X  %-52s want %s got %s" % (
        "PASS" if ok else "FAIL", addr, label, hexs, got.hex(" ")))

# line-coding storage record FF63E6 -> flash 0x07B658
print("\nFF63E6 record (flash 0x07B658):", b[0x07B658:0x07B660].hex(" "))
print("FF6388 string rec (flash 0x07B5FA):", b[0x07B5FA:0x07B60C].hex(" "))
print("EPIR table (flash 0x07B61E):", b[0x07B61E:0x07B632].hex(" "))
print("\n%d cites, %d mismatch" % (len([c for c in CITES if c[1]]), fails))
sys.exit(1 if fails else 0)

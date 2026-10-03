# -*- coding: utf-8 -*-
"""Lane K8: offline Python cross-check of the FT3D MAIN AX.25 FCS routines.

Independent Python port of the two firmware routines (see fcs.c for the
address-by-address C). Reads the firmware image read-only to confirm the
polynomial and residue immediates are where the reconstruction says, then tests
against the CRC catalogue vector and a hand-built APRS UI frame.
"""
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import os, sys

IMG = (_REPO_S + "/decrypted/FT3D_MAIN_ver102_EXP.bin")


def step(r2h, r2l, bit):
    c2 = r2l & 1
    r2l = (bit << 7) | (r2l >> 1)
    c3 = r2h & 1
    r2h = (c2 << 7) | (r2h >> 1)
    if c3:
        r2h ^= 0x08
        r2l ^= 0x84
    return r2h, r2l


def fw_rx_check(frame):
    """sub_4986A: augmented CRC over frame (incl. FCS) + two zero bytes."""
    buf = bytes(frame) + b"\0\0"
    r2h, r2l = buf[0] ^ 0xFF, buf[1] ^ 0xFF
    for b in buf[2:]:
        for _ in range(8):
            r2h, r2l = step(r2h, r2l, b & 1)
            b >>= 1
    return (r2h << 8) | r2l          # firmware accepts iff == 0xB8F0


def fw_fcs_bytes(data):
    """The two FCS bytes sub_49494 emits: not.b r2h then not.b r2l after the
    augmented pass over data + two zeros (states 2/3 at 0x04954A/0x049556)."""
    buf = bytes(data) + b"\0\0"
    r2h, r2l = buf[0] ^ 0xFF, buf[1] ^ 0xFF
    for b in buf[2:]:
        for _ in range(8):
            r2h, r2l = step(r2h, r2l, b & 1)
            b >>= 1
    return bytes([r2h ^ 0xFF, r2l ^ 0xFF])


def ref_x25(data):
    c = 0xFFFF
    for b in data:
        c ^= b
        for _ in range(8):
            c = (c >> 1) ^ 0x8408 if c & 1 else c >> 1
    return c ^ 0xFFFF


def call(cs, ssid, last):
    cs = cs.ljust(6)
    return bytes(ord(ch) << 1 for ch in cs) + bytes([0x60 | (ssid << 1) | last])


def main():
    ok = True
    sys.exit("The firmware image is not in this repository.")
    imm = {0x049892: b"\x79\x0a\x08\x84", 0x0494A8: b"\x79\x0a\x08\x84",
           0x049904: b"\x79\x22\xb8\xf0", 0x0494B0: b"\x17\x12"}
    for a, want in imm.items():
        got = img[a:a + len(want)]
        print("image @%06X: %s %s" % (a, got.hex(" "), "ok" if got == want else "MISMATCH"))
        ok &= got == want
    v = b"123456789"
    print("catalogue CRC-16/X.25('123456789') ref=0x%04X (expect 0x906E)" % ref_x25(v))
    fb = fw_fcs_bytes(v)
    print("firmware-form FCS bytes on air: %s (expect 6e 90)" % fb.hex(" "))
    ok &= ref_x25(v) == 0x906E and fb == b"\x6e\x90"
    r = fw_rx_check(v + fb)
    print("firmware RX residue r2=0x%04X (accept iff 0xB8F0)" % r)
    ok &= r == 0xB8F0
    fr = call("APY03D", 0, 0) + call("N0CALL", 7, 0) + call("WIDE1", 1, 1) + b"\x03\xf0" + b"!4903.50N/07201.75W-PHG5132 test"
    fb = fw_fcs_bytes(fr)
    ref = ref_x25(fr)
    print("UI frame %d B: ref FCS 0x%04X, firmware FCS bytes %s -> %s" % (len(fr), ref, fb.hex(" "),
          "PASS" if fb == bytes([ref & 0xFF, ref >> 8]) else "FAIL"))
    ok &= fb == bytes([ref & 0xFF, ref >> 8])
    ok &= fw_rx_check(fr + fb) == 0xB8F0
    bad = bytearray(fr + fb); bad[10] ^= 1
    print("corrupted frame residue 0x%04X (must differ from 0xB8F0)" % fw_rx_check(bad))
    ok &= fw_rx_check(bad) != 0xB8F0
    print("PYTHON RESULT:", "ALL PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

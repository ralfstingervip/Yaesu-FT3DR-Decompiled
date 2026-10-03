#!/usr/bin/env python3
# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
# N5 lane: whole-image edge scan into 0x0771AE..0x0771E1 (MAIN, H8SX, big-endian, base 0).
# Owner-side static analysis of a file on disk. Nothing written to a radio.
import sys, hashlib

IMG = _no_image()
RANGE_LO = 0x0771AE
RANGE_HI = 0x0771E1  # inclusive
EXPECT_SHA = "8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce"

with open(IMG, "rb") as f:
    d = f.read()
sha = hashlib.sha256(d).hexdigest()
assert sha == EXPECT_SHA, f"MAIN sha mismatch {sha}"
print(f"MAIN sha256 {sha} OK, {len(d)} bytes")

def inrange(a):
    return RANGE_LO <= a <= RANGE_HI

def s8(b):  return b-256 if b>=128 else b
def s16(h): return h-65536 if h>=32768 else h

N = len(d)
hits = []

# ---------- 1. Relative branches (rel8 / rel16) ----------
# rel8: opcodes 0x40..0x4F (BRA/BRN/Bcc) and 0x55 (BSR), form "op dd"; next = addr+2
# rel16: 0x58 x0 dddd (BRA/Bcc d16) and 0x5C 00 dddd (BSR d16); next = addr+4
# We scan every byte offset (code boundaries unknown for a conservative sweep).
for a in range(0, N-1):
    op = d[a]
    # rel8 conditional/uncond branch
    if 0x40 <= op <= 0x4F:
        tgt = (a+2 + s8(d[a+1])) & 0xFFFFFF
        if inrange(tgt):
            hits.append(("rel8-Bcc", a, tgt, f"{op:02x} {d[a+1]:02x}"))
    if op == 0x55:  # BSR d:8
        tgt = (a+2 + s8(d[a+1])) & 0xFFFFFF
        if inrange(tgt):
            hits.append(("rel8-BSR", a, tgt, f"{op:02x} {d[a+1]:02x}"))
for a in range(0, N-3):
    op = d[a]
    if op == 0x58 and (d[a+1] & 0x0F) == 0x00:  # BRA/Bcc d:16, cond in high nibble of d[a+1]
        disp = s16((d[a+2]<<8)|d[a+3])
        tgt = (a+4 + disp) & 0xFFFFFF
        if inrange(tgt):
            hits.append(("rel16-Bcc", a, tgt, f"58 {d[a+1]:02x} {d[a+2]:02x} {d[a+3]:02x}"))
    if op == 0x5C and d[a+1] == 0x00:  # BSR d:16
        disp = s16((d[a+2]<<8)|d[a+3])
        tgt = (a+4 + disp) & 0xFFFFFF
        if inrange(tgt):
            hits.append(("rel16-BSR", a, tgt, f"5c 00 {d[a+2]:02x} {d[a+3]:02x}"))

# ---------- 2. Absolute jmp/jsr @aa:24 ----------
# JMP @aa:24 = 5A aa aa aa ; JSR @aa:24 = 5E aa aa aa
for a in range(0, N-3):
    op = d[a]
    if op in (0x5A, 0x5E):
        tgt = (d[a+1]<<16)|(d[a+2]<<8)|d[a+3]
        if inrange(tgt):
            mnem = "JMP@aa24" if op==0x5A else "JSR@aa24"
            hits.append((mnem, a, tgt, f"{op:02x} {d[a+1]:02x} {d[a+2]:02x} {d[a+3]:02x}"))

# ---------- 3. BE32 value anywhere equal to an even address in range ----------
# Covers pointer tables, mov.l #imm loads, and @@aa:8 vector slots.
for a in range(0, N-3):
    v = (d[a]<<24)|(d[a+1]<<16)|(d[a+2]<<8)|d[a+3]
    if inrange(v) and (v & 1)==0:
        hits.append(("BE32val", a, v, f"{d[a]:02x} {d[a+1]:02x} {d[a+2]:02x} {d[a+3]:02x}"))
    # also sign-extended abs16 form FFFF8xxx would never land here (range is 0x0771xx), skip

# ---------- 4. @@aa:8 memory-indirect jmp/jsr ----------
# JMP @@aa:8 = 5B aa ; JSR @@aa:8 = 5F aa. Vector at address 0x0000aa holds a BE32 pointer.
for a in range(0, N-1):
    op = d[a]
    if op in (0x5B, 0x5F):
        aa = d[a+1]
        vec = aa  # advanced mode: zero-extended to 0x0000aa
        if vec+4 <= N:
            ptr = (d[vec]<<24)|(d[vec+1]<<16)|(d[vec+2]<<8)|d[vec+3]
            if inrange(ptr):
                mnem = "JMP@@aa8" if op==0x5B else "JSR@@aa8"
                hits.append((mnem, a, ptr, f"{op:02x} {aa:02x} -> vec[{vec:04x}]={ptr:06x}"))

print(f"\n=== EDGE HITS INTO 0x{RANGE_LO:06X}..0x{RANGE_HI:06X} ===")
if not hits:
    print("NONE")
for kind, a, tgt, by in sorted(hits, key=lambda x:(x[0],x[1])):
    print(f"{kind:12s} @ {a:06x}  -> {tgt:06x}   [{by}]")
print(f"\ntotal hits: {len(hits)}")

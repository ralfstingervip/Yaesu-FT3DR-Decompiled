r"""Lane N4 -- the 300 B near-duplicate EP0 handlers 0x076ADE-0x076C09.

Owner-side, strictly read-only static analysis on N4_EP0 (seeded --copy-from
M1_MAIN_FINAL6). No image byte modified, nothing written/flashed/transmitted to
any radio, no shared DB opened. MAIN is H8SX, big-endian, base 0, so file offset
== mapped address for every cite.

What it does:
  1. Force-decode the range and a wide neighbourhood so every relative branch is
     materialised, then dump heads (addr,len,bytes,mnemonic) for the range.
  2. Collect every code xref (cref) IDA records to each head in the range, and
     separate internal (src in range) from external (src outside range).
  3. Whole-image byte scan for every inbound edge class into [LO,HI):
     BE32, BE24, abs24 jsr(0x5E)/jmp(0x5A), rel8 Bcc(0x40-0x4F)/BSR(0x55),
     rel16 Bcc(0x58 cc)/BSR(0x5C 00). Each hit: src offset, class, target.
  4. Dump outbound call targets from the range.

Outputs under ida\out\ep0-duplicates\work\:
  disasm.txt   annotated disasm of the range + 0x30 B either side
  heads.tsv    addr, len, bytes, mnemonic for every head in the range
  xrefs.tsv    target, src, type, internal/external for every cref into range
  edges.tsv    whole-image byte-scan inbound-edge candidates into the range
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_lines, ida_ua, idautils, idc

ROOT = str(_REPO)
WORK = os.path.join(ROOT, "ida", "out", "ep0-duplicates", "work")
TB = os.path.join(WORK, "traceback.txt")

LO, HI = 0x076ADE, 0x076C09          # range, HI exclusive per lane (0x076C08 rts ends at 0x076C0A)
RANGE_END = 0x076C0A                 # last head of the range ends here
DECODE_A, DECODE_B = 0x076600, 0x077240   # wide neighbourhood to decode for relative edges


def txt(ea):
    return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "").replace("\t", " ")


def bytes_at(ea, n):
    return " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(n))


def force_code(a, b):
    ida_bytes.del_items(a, ida_bytes.DELIT_SIMPLE, b - a)
    ea = a
    while ea < b:
        ln = ida_ua.create_insn(ea)
        ea += ln if ln > 0 else 1
    ida_auto.auto_wait()


def main():
    os.makedirs(WORK, exist_ok=True)
    force_code(DECODE_A, DECODE_B)

    # 1 + 2 : heads and xrefs within the range
    heads = []
    ea = LO
    while ea < RANGE_END:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            n = ida_bytes.get_item_size(ea) or 1
        else:
            n = 1
        heads.append((ea, n, bytes_at(ea, min(n, 12)), txt(ea)))
        ea += n

    with open(os.path.join(WORK, "heads.tsv"), "w", encoding="utf-8") as fh:
        fh.write("addr\tlen\tbytes\tmnemonic\n")
        for a, n, bs, mn in heads:
            fh.write("%06X\t%d\t%s\t%s\n" % (a, n, bs, mn))

    with open(os.path.join(WORK, "disasm.txt"), "w", encoding="utf-8") as fh:
        fh.write("; N4 range 0x%06X-0x%06X  (+/- 0x30 context)\n" % (LO, RANGE_END))
        a = LO - 0x30
        while a < RANGE_END + 0x30:
            fl = ida_bytes.get_flags(a)
            n = (ida_bytes.get_item_size(a) or 1) if ida_bytes.is_code(fl) else 1
            mark = ">>" if LO <= a < RANGE_END else "  "
            fh.write("%s %06X  %-26s %s\n" % (mark, a, bytes_at(a, min(n, 12)), txt(a)))
            a += n

    # xrefs (code) into every byte of the range
    xr = []
    for a, n, _, _ in heads:
        for src in idautils.CodeRefsTo(a, 1):      # flow + explicit
            internal = LO <= src < RANGE_END
            xr.append((a, src, "flow/code", internal))
        # explicit (non-flow) crefs via xref iterator for completeness
    with open(os.path.join(WORK, "xrefs.tsv"), "w", encoding="utf-8") as fh:
        fh.write("target\tsrc\ttype\tscope\n")
        for t, s, ty, intern in sorted(set(xr)):
            fh.write("%06X\t%06X\t%s\t%s\n" % (t, s, ty, "internal" if intern else "EXTERNAL"))

    # 3 : whole-image byte scan for inbound edges into [LO,HI)
    img = ida_bytes.get_bytes(0x0, 0x100000)       # MAIN content space
    edges = []

    def in_range(t):
        return LO <= t < HI

    def s8(v):
        return v - 0x100 if v >= 0x80 else v

    def s16(v):
        return v - 0x10000 if v >= 0x8000 else v

    L = len(img)
    for off in range(0, L - 1):
        b0 = img[off]
        # rel8 Bcc 0x40-0x4F, BSR 0x55
        if 0x40 <= b0 <= 0x4F or b0 == 0x55:
            t = off + 2 + s8(img[off + 1])
            if in_range(t):
                edges.append((off, "rel8", t, "%02X %02X" % (b0, img[off + 1])))
        if off + 3 < L:
            # rel16 Bcc 0x58 cc, BSR 0x5C 00
            if b0 == 0x58 and (img[off + 1] & 0x0F) == 0:
                t = off + 4 + s16((img[off + 2] << 8) | img[off + 3])
                if in_range(t):
                    edges.append((off, "rel16", t, "58 %02X %02X %02X" % (img[off+1], img[off+2], img[off+3])))
            if b0 == 0x5C and img[off + 1] == 0x00:
                t = off + 4 + s16((img[off + 2] << 8) | img[off + 3])
                if in_range(t):
                    edges.append((off, "bsr16", t, "5C 00 %02X %02X" % (img[off+2], img[off+3])))
            # abs24 jsr 0x5E / jmp 0x5A : opcode + 24-bit target
            if b0 in (0x5E, 0x5A):
                t = (img[off + 1] << 16) | (img[off + 2] << 8) | img[off + 3]
                if in_range(t):
                    edges.append((off, "abs24_%s" % ("jsr" if b0 == 0x5E else "jmp"), t,
                                  "%02X %02X %02X %02X" % (b0, img[off+1], img[off+2], img[off+3])))
    # BE32 / BE24 pointer values anywhere
    for off in range(0, L - 3):
        v32 = (img[off] << 24) | (img[off+1] << 16) | (img[off+2] << 8) | img[off+3]
        if in_range(v32):
            edges.append((off, "BE32", v32, "%08X" % v32))
    for off in range(0, L - 2):
        v24 = (img[off] << 16) | (img[off+1] << 8) | img[off+2]
        if in_range(v24):
            edges.append((off, "BE24", v24, "%06X" % v24))

    with open(os.path.join(WORK, "edges.tsv"), "w", encoding="utf-8") as fh:
        fh.write("src_off\tclass\ttarget\tbytes\tsrc_in_range\n")
        for off, cls, t, bs in sorted(edges):
            fh.write("%06X\t%s\t%06X\t%s\t%s\n" % (off, cls, t, bs, "Y" if LO <= off < HI else "N"))

    # 4 : outbound call targets from the range
    with open(os.path.join(WORK, "callees.tsv"), "w", encoding="utf-8") as fh:
        fh.write("src\ttarget\n")
        for a, n, _, mn in heads:
            for dst in idautils.CodeRefsFrom(a, 0):   # non-flow (calls/jumps)
                fh.write("%06X\t%06X\n" % (a, dst))

    with open(os.path.join(WORK, "SUMMARY.txt"), "w", encoding="utf-8") as fh:
        ext = [x for x in xr if not x[3]]
        fh.write("heads in range: %d\n" % len(heads))
        fh.write("code xrefs into range (total): %d, external: %d\n" % (len(set(xr)), len(set(ext))))
        for t, s, ty, intern in sorted(set(ext)):
            fh.write("  EXTERNAL cref -> %06X from %06X (%s)\n" % (t, s, ty))
        fh.write("byte-scan inbound edges with source OUTSIDE range: %d\n"
                 % len([e for e in edges if not (LO <= e[0] < HI)]))
        for off, cls, t, bs in sorted(e for e in edges if not (LO <= e[0] < HI)):
            fh.write("  %s src=%06X -> %06X [%s]\n" % (cls, off, t, bs))


try:
    main()
except Exception:
    with open(TB, "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

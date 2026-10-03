r"""Lane M7 -- CDC-ACM device personality. Read-only static analysis on M7_CDC
(seeded --copy-from L1_MAIN_FINAL5). No image modified, nothing written to a radio.

Force-decodes and dumps the CDC handler block and USB module body that the
service-window ISR demux (0x07827C) and the gated service loop reach:

  0x0767BE..0x076FC7   handlers (b6/b4/b3/b0-1-2) + USB module body
  0x076FC8..0x07711E   SCI-C TX pump (doc 42)
  0x07711E..0x077240   SCI-C RX bridge handler
  0x07827C             ISR demux (already decoded in seed window; re-dump to verify)

Outputs under ida\out\cdc-personality\work\:
  disasm.txt    annotated disasm of every range above (bytes + mnemonic)
  xrefs.txt     xrefs to each probe address, and callees from each handler
  heads.tsv     every code head we produced: addr, len, bytes, mnemonic
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, ida_ua, ida_xref, idautils, idc

ROOT = str(_REPO)
WORK = os.path.join(ROOT, "ida", "out", "cdc-personality", "work")

RANGES = [
    ("handlers_and_module 0767BE-0770F0", 0x0767BE, 0x0770F0),
    ("rx_bridge 07711E-077240", 0x07711E, 0x077240),
    ("isr_demux 07827C-078334", 0x07827C, 0x078334),
    ("b7_handler_0784BE 0784BE-078508", 0x0784BE, 0x078508),
]

PROBES = [0x0767BE, 0x0768A8, 0x0768C8, 0x0769AA, 0x076B4E, 0x076C0A,
          0x076FC8, 0x07711E, 0x07827C, 0x0784BE,
          0x076844, 0x0768A2, 0x076916, 0x076944, 0x0769E6, 0x076A08,
          0x076A88, 0x076A8E, 0x076AD8, 0x076D84, 0x076DE0, 0x076E3C,
          0x076E9C, 0x076F30, 0x076F54, 0x076B1A, 0x076B46, 0x076B6A,
          0x076BEA, 0x076BF2, 0x076ADE, 0x076B20, 0x076FC8]


def txt(ea):
    return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0) or "").replace("\t", " ")


def bytes_at(ea, n):
    return " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(n))


def force_code(a, b):
    """Linear force-decode a..b following instruction lengths. Undefine first."""
    ida_bytes.del_items(a, ida_bytes.DELIT_SIMPLE, b - a)
    ea = a
    while ea < b:
        ln = ida_ua.create_insn(ea)
        if ln <= 0:
            # leave as data, step one byte
            ea += 1
            continue
        ea += ln
    ida_auto.auto_wait()


def dump_range(fh, hfh, name, a, b):
    fh.write("\n===== %s =====\n" % name)
    ea = a
    while ea < b:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            n = ida_bytes.get_item_size(ea)
            n = n if n > 0 else 1
            bs = bytes_at(ea, min(n, 12))
            mn = txt(ea)
            fh.write("%06X  %-30s %s\n" % (ea, bs, mn))
            hfh.write("%06X\t%d\t%s\t%s\n" % (ea, n, bytes_at(ea, min(n, 12)), mn))
            ea = idc.next_head(ea, b)
            if ea == idc.BADADDR:
                break
        else:
            fh.write("%06X  %-30s db\n" % (ea, bytes_at(ea, 1)))
            ea += 1


def xrefs_to(ea):
    out = []
    for x in idautils.XrefsTo(ea, 0):
        kind = "data"
        if x.iscode:
            if x.type in (ida_xref.fl_CF, ida_xref.fl_CN):
                kind = "call"
            elif x.type in (ida_xref.fl_JF, ida_xref.fl_JN):
                kind = "jump"
            else:
                kind = "code%d" % x.type
        out.append((x.frm, kind))
    return out


def callees_from(a, b):
    out = []
    ea = a
    while ea < b and ea != idc.BADADDR:
        if ida_bytes.is_code(ida_bytes.get_flags(ea)):
            for x in idautils.XrefsFrom(ea, 0):
                if x.iscode and x.type in (ida_xref.fl_CF, ida_xref.fl_CN):
                    out.append((ea, x.to))
        ea = idc.next_head(ea, b)
    return out


def main():
    ida_auto.auto_wait()
    for _, a, b in RANGES:
        force_code(a, b)
    with open(os.path.join(WORK, "disasm.txt"), "w", encoding="utf-8", newline="\n") as fh, \
         open(os.path.join(WORK, "heads.tsv"), "w", encoding="utf-8", newline="\n") as hfh:
        hfh.write("addr\tlen\tbytes\tmnem\n")
        for name, a, b in RANGES:
            dump_range(fh, hfh, name, a, b)
    with open(os.path.join(WORK, "xrefs.txt"), "w", encoding="utf-8", newline="\n") as fh:
        for ea in PROBES:
            xa = xrefs_to(ea)
            fh.write("%06X xrefs: %s\n" % (
                ea, ", ".join("%06X:%s" % (f, k) for f, k in xa) or "none"))
        fh.write("\n== callees from handler block 0767BE-0770F0 ==\n")
        for frm, to in callees_from(0x0767BE, 0x0770F0):
            fh.write("%06X -> %06X\n" % (frm, to))


try:
    main()
except Exception:
    with open(os.path.join(WORK, "m7_err.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane L7 - WIRES-X node-command table decode (MAIN, h8sxa, big-endian, base 0).
Read-only. Decodes off_74472 (48 BE pointers) indexed by FF97FC, the parallel
byte table at 0x74532, the dispatcher that reads FF97FC, and every writer/reader
of FF97FC. Writes a text dump (env L7_OUT) and table.tsv/writers.tsv next to it.
Window 0x078106-0x07B753 skipped. Ends with idc.qexit(0)."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
import ida_auto, idc, ida_bytes, ida_funcs, idautils

OUT = os.environ.get("L7_OUT", str(_REPO / "ida/out/pdn-node-table/l7_dump.txt"))
OUTDIR = os.path.dirname(OUT)
WIN = (0x078106, 0x07B754)
TABLE = 0x74472          # 48 x 4-byte BE pointers
BYTETAB = 0x74532        # 48 x 1 byte
NSLOT = 0x30


def inwin(ea):
    return WIN[0] <= ea < WIN[1]


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return "-"
    return "%s@%06X" % (ida_funcs.get_func_name(f.start_ea), f.start_ea)


def line(ea):
    d = idc.generate_disasm_line(ea, 0) or ""
    sz = idc.get_item_size(ea) or 1
    raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
    return "%06X  %-30s  %s" % (ea, " ".join("%02x" % b for b in raw), d)


def disrange(lo, hi, cap=400):
    out = []
    ea = lo
    n = 0
    while ea < hi and ea != idc.BADADDR and n < cap:
        if inwin(ea):
            out.append("%06X  <closed window skipped>" % ea)
            return out
        out.append(line(ea))
        nx = idc.next_head(ea, hi)
        if nx <= ea or nx == idc.BADADDR:
            break
        ea = nx
        n += 1
    return out


def dis_handler(start):
    """Disassemble a handler until an rts/rte/jmp terminator or 60 heads."""
    out = []
    ea = start
    for _ in range(80):
        if inwin(ea):
            out.append("%06X  <closed window skipped>" % ea)
            break
        out.append(line(ea))
        mn = (idc.print_insn_mnem(ea) or "").lower()
        if mn in ("rts", "rte"):
            break
        if mn in ("jmp", "bra") and _ > 0:
            break
        nx = idc.next_head(ea, 0x80000)
        if nx <= ea or nx == idc.BADADDR:
            break
        ea = nx
    return out


def xrefs(addr):
    res = []
    cands = {addr, 0xFFFF0000 | (addr & 0xFFFF), 0xFF0000 | (addr & 0xFFFF)}
    for a in sorted(cands):
        for x in idautils.XrefsTo(a, 0):
            res.append((x.frm, a, x.type))
    return res


def main():
    ida_auto.auto_wait()
    os.makedirs(OUTDIR, exist_ok=True)
    out = []
    rows = []  # table.tsv rows

    # --- Section A: the pointer table + byte table ---
    out.append("### off_74472 pointer table (48 x BE32) + byte table 0x74532")
    for i in range(NSLOT):
        pa = TABLE + i * 4
        tgt = int.from_bytes(ida_bytes.get_bytes(pa, 4), "big")
        pbytes = " ".join("%02x" % b for b in ida_bytes.get_bytes(pa, 4))
        tbyte = ida_bytes.get_byte(BYTETAB + i)
        cmd = 0x30 + i
        ch = chr(cmd) if 0x20 <= cmd < 0x7f else "."
        out.append("slot 0x%02X  cmd 0x%02X '%s'  ptr[%06X]=%s -> %06X  bytetab=0x%02X  %s"
                   % (i, cmd, ch, pa, pbytes, tgt, tbyte, fname(tgt)))
        rows.append((i, cmd, ch, pbytes, tgt, tbyte))
    out.append("")

    # --- Section B: each handler disassembly ---
    seen = set()
    for i in range(NSLOT):
        tgt = int.from_bytes(ida_bytes.get_bytes(TABLE + i * 4, 4), "big")
        out.append("### handler slot 0x%02X (cmd '%s') -> %06X" % (i, chr(0x30 + i), tgt))
        out += dis_handler(tgt)
        out.append("")

    # --- Section C: find the dispatcher. xref the table base and FF97FC ---
    out.append("### xrefs to table base 0x74472")
    for frm, tgt, t in xrefs(TABLE):
        out.append("%06X  ->%08X t%d  %-26s %s" % (frm, tgt, t, fname(frm), idc.generate_disasm_line(frm, 0) or ""))
    out.append("")
    out.append("### xrefs to byte table 0x74532")
    for frm, tgt, t in xrefs(BYTETAB):
        out.append("%06X  ->%08X t%d  %-26s %s" % (frm, tgt, t, fname(frm), idc.generate_disasm_line(frm, 0) or ""))
    out.append("")

    out.append("### xrefs to FF97FC (index byte)")
    for frm, tgt, t in xrefs(0xFF97FC):
        out.append("%06X  ->%08X t%d  %-26s %s" % (frm, tgt, t, fname(frm), idc.generate_disasm_line(frm, 0) or ""))
    out.append("")

    # --- Section D: grep every code head for 97FC / 74472 / 74532 operand text ---
    writers = []
    out.append("### grep operands referencing 97FC / 7447 / 7453")
    rx = re.compile(r"97FC|7_?4472|7_?4532|74472|74532", re.I)
    ea = 0
    while ea < 0x80000 and ea != idc.BADADDR:
        if inwin(ea):
            ea = WIN[1]
            continue
        if ida_bytes.is_code(ida_bytes.get_flags(ea)):
            d = idc.generate_disasm_line(ea, 0) or ""
            if "97FC" in d.upper() or "74472" in d.upper() or "74532" in d.upper():
                out.append("%06X  %-26s %s" % (ea, fname(ea), d))
                mn = (idc.print_insn_mnem(ea) or "").lower()
                if "97FC" in d.upper():
                    writers.append((ea, fname(ea), d, mn))
        nx = idc.next_head(ea, 0x80000)
        if nx <= ea:
            break
        ea = nx
    out.append("")

    # --- Section E: disassemble the functions that touch FF97FC (dispatcher + writers) ---
    funcs = set()
    for ea, fn, d, mn in writers:
        f = ida_funcs.get_func(ea)
        if f:
            funcs.add(f.start_ea)
    for frm, tgt, t in xrefs(TABLE):
        f = ida_funcs.get_func(frm)
        if f:
            funcs.add(f.start_ea)
    for fs in sorted(funcs):
        f = ida_funcs.get_func(fs)
        out.append("### FULL func %s  %06X-%06X" % (fname(fs), f.start_ea, f.end_ea))
        out += disrange(f.start_ea, f.end_ea, cap=600)
        out.append("")

    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(out))

    # table.tsv (auto part; handler role filled by hand later)
    with open(os.path.join(OUTDIR, "table_auto.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("slot\tcmd_hex\tcmd_char\tptr_bytes\ttarget\tbytetab\thandler\n")
        for i, cmd, ch, pb, tgt, tb in rows:
            h.write("0x%02X\t0x%02X\t%s\t%s\t0x%06X\t0x%02X\t%s\n" % (i, cmd, ch, pb, tgt, tb, fname(tgt)))

    with open(os.path.join(OUTDIR, "writers_auto.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("addr\tfunc\tmnem\tdisasm\n")
        for ea, fn, d, mn in writers:
            h.write("0x%06X\t%s\t%s\t%s\n" % (ea, fn, mn, d))


try:
    main()
except Exception:
    with open(OUT + ".tb.txt", "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

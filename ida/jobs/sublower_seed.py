"""SUB-LOWER job 1: harvest CC-RX prologue/epilogue signatures.

Runs against a COPY of ida\\db\\radio\\SUB.i64 (455 recovered functions) so the
lower-region scan has real byte patterns to look for instead of guesses.

Writes ida/out/sub-lower/prologues.tsv, epilogues.tsv,
sig_summary.txt and reset_disasm.txt.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "seed_error.txt")


def esc(t: str) -> str:
    return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()

    pro_rows = []
    epi_rows = []
    op1 = collections.Counter()
    op2 = collections.Counter()
    pro_mnem = collections.Counter()
    epi_mnem = collections.Counter()
    pro_bytes4 = collections.Counter()
    pro_bytes3 = collections.Counter()
    pro_bytes2 = collections.Counter()
    epi_tail = collections.Counter()
    sizes = []

    for start in idautils.Functions():
        f = ida_funcs.get_func(start)
        if f is None:
            continue
        size = f.end_ea - f.start_ea
        sizes.append(size)
        head = ida_bytes.get_bytes(start, min(8, size)) or b""
        if head:
            op1[head[0]] += 1
            if len(head) > 1:
                op2[head[:2].hex()] += 1
            pro_bytes2[head[:2].hex()] += 1
            pro_bytes3[head[:3].hex()] += 1
            pro_bytes4[head[:4].hex()] += 1
        # first two instructions
        d1 = idc.generate_disasm_line(start, idc.GENDSM_FORCE_CODE) or ""
        insn = ida_ua.insn_t()
        l1 = ida_ua.decode_insn(insn, start)
        m1 = insn.get_canon_mnem() if l1 > 0 else ""
        pro_mnem[m1] += 1
        nxt = start + l1 if l1 > 0 else start
        d2 = idc.generate_disasm_line(nxt, idc.GENDSM_FORCE_CODE) or ""
        pro_rows.append((start, size, head.hex(), esc(d1), esc(d2)))

        # last instruction of the function body
        last_ea = idc.prev_head(f.end_ea, f.start_ea)
        if last_ea != idc.BADADDR and last_ea >= f.start_ea:
            ln = ida_ua.insn_t()
            lb = ida_ua.decode_insn(ln, last_ea)
            lm = ln.get_canon_mnem() if lb > 0 else ""
            epi_mnem[lm] += 1
            eb = ida_bytes.get_bytes(last_ea, max(1, lb)) or b""
            epi_tail[eb.hex()] += 1
            epi_rows.append((start, last_ea, eb.hex(), lm,
                             esc(idc.generate_disasm_line(last_ea, idc.GENDSM_FORCE_CODE) or "")))

    with open(os.path.join(OUT, "prologues.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("func_ea\tsize\thead8_hex\tinsn1\tinsn2\n")
        for r in pro_rows:
            fh.write("%08X\t%d\t%s\t%s\t%s\n" % r)

    with open(os.path.join(OUT, "epilogues.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("func_ea\tlast_ea\tbytes_hex\tmnem\tinsn\n")
        for r in epi_rows:
            fh.write("%08X\t%08X\t%s\t%s\t%s\n" % r)

    with open(os.path.join(OUT, "sig_summary.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("functions %d\n" % len(pro_rows))
        if sizes:
            sizes.sort()
            fh.write("size min %d median %d max %d total %d\n"
                     % (sizes[0], sizes[len(sizes) // 2], sizes[-1], sum(sizes)))
        fh.write("\n-- first opcode byte --\n")
        for b, c in op1.most_common(40):
            fh.write("  %02X  %4d  %5.1f%%\n" % (b, c, 100.0 * c / max(1, len(pro_rows))))
        fh.write("\n-- first 2 bytes --\n")
        for b, c in pro_bytes2.most_common(40):
            fh.write("  %s  %4d\n" % (b, c))
        fh.write("\n-- first 3 bytes --\n")
        for b, c in pro_bytes3.most_common(40):
            fh.write("  %s  %4d\n" % (b, c))
        fh.write("\n-- first 4 bytes --\n")
        for b, c in pro_bytes4.most_common(40):
            fh.write("  %s  %4d\n" % (b, c))
        fh.write("\n-- prologue mnemonic --\n")
        for m, c in pro_mnem.most_common(40):
            fh.write("  %-10s %4d\n" % (m, c))
        fh.write("\n-- last-instruction mnemonic --\n")
        for m, c in epi_mnem.most_common(40):
            fh.write("  %-10s %4d\n" % (m, c))
        fh.write("\n-- last-instruction bytes --\n")
        for b, c in epi_tail.most_common(40):
            fh.write("  %-12s %4d\n" % (b, c))

    # Full disassembly of the reset handler and of a few known functions, for reference.
    with open(os.path.join(OUT, "reset_disasm.txt"), "w", encoding="utf-8", newline="\n") as fh:
        ea = 0xFFC00000
        fh.write("== reset_handler 0xFFC00000 ==\n")
        while ea < 0xFFC00080:
            ln = idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or "?"
            sz = max(1, ida_bytes.get_item_size(ea))
            bs = ida_bytes.get_bytes(ea, sz) or b""
            fh.write("%08X  %-24s %s\n" % (ea, bs.hex(), esc(ln)))
            ea += sz
        # sample the smallest and largest functions
        fh.write("\n== sample functions ==\n")
        picks = sorted(pro_rows, key=lambda r: -r[1])[:3] + sorted(pro_rows, key=lambda r: r[1])[:5]
        for start, size, _h, _a, _b in picks:
            fh.write("\n-- %08X size %d --\n" % (start, size))
            f = ida_funcs.get_func(start)
            ea = start
            n = 0
            while f and ea < f.end_ea and n < 40:
                ln = idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or "?"
                sz = max(1, ida_bytes.get_item_size(ea))
                bs = ida_bytes.get_bytes(ea, sz) or b""
                fh.write("%08X  %-24s %s\n" % (ea, bs.hex(), esc(ln)))
                ea += sz
                n += 1

    idc.qexit(0)


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(ERR, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(traceback.format_exc())
    idc.qexit(1)

r"""MAIN-FULL stage 3: absolute-address operand map, region map, xref census.

Writes, under ida/out/main-full/ :
  ioregs.tsv       every absolute-addressed operand at or above 0x00FF0000
  absrefs.tsv      per-address rollup of those accesses
  items.tsv        run-length map of item classes over the content region
  code_runs.tsv    undefined runs in the content region, with a decode probe
  xrefs.tsv        cross-references to every function
  strings.tsv      ASCII strings >= 4 chars in the content region
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
import ida_ida
import ida_segment
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-full")
os.makedirs(OUT, exist_ok=True)
LOG_PATH = os.path.join(OUT, "stage3_log.txt")
_LOG = []


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")


def esc(text):
    return (text or "").replace("\t", " ").replace("\n", " ").replace("\r", " ")


def main():
    ida_auto.auto_wait()
    seg = ida_segment.get_first_seg()
    base = seg.start_ea
    top = ida_ida.inf_get_max_ea()
    blob = ida_bytes.get_bytes(base, top - base)
    end = len(blob)
    while end > 0 and blob[end - 1] == 0xFF:
        end -= 1
    content_end = base + end
    log("content_end %#x" % content_end)

    # ---- byte class accounting, correctly handling FF_TAIL ----------------
    classes = []           # (class, start, length)
    counts = collections.Counter()
    cur_class = None
    cur_start = base
    ea = base
    while ea < content_end:
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags) or ida_bytes.is_tail(flags):
            head = ida_bytes.get_item_head(ea)
            kind = "code" if ida_bytes.is_code(ida_bytes.get_flags(head)) else "data"
        elif ida_bytes.is_unknown(flags):
            kind = "unk"
        else:
            kind = "data"
        counts[kind] += 1
        if kind != cur_class:
            if cur_class is not None:
                classes.append((cur_class, cur_start, ea - cur_start))
            cur_class = kind
            cur_start = ea
        ea += 1
    if cur_class is not None:
        classes.append((cur_class, cur_start, content_end - cur_start))
    span = content_end - base
    log("bytes code %d (%.1f%%) data %d (%.1f%%) unknown %d (%.1f%%) of %d"
        % (counts["code"], 100.0 * counts["code"] / span,
           counts["data"], 100.0 * counts["data"] / span,
           counts["unk"], 100.0 * counts["unk"] / span, span))

    with open(os.path.join(OUT, "items.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("class\tstart\tend\tlength\n")
        for kind, start, length in classes:
            handle.write("%s\t%08X\t%08X\t%d\n" % (kind, start, start + length, length))
    log("item runs %d" % len(classes))

    # ---- undefined runs, with a decode probe -----------------------------
    insn = ida_ua.insn_t()
    with open(os.path.join(OUT, "code_runs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("start\tend\tlength\tprobe_insns\tprobe_ok\tfirst_bytes\tfirst_line\n")
        for kind, start, length in classes:
            if kind != "unk" or length < 8:
                continue
            n = 0
            cur = start
            while n < 24 and cur < start + length:
                size = ida_ua.decode_insn(insn, cur)
                if size <= 0 or insn.itype == 0:
                    break
                cur += size
                n += 1
            raw = ida_bytes.get_bytes(start, min(12, length)) or b""
            handle.write(
                "%08X\t%08X\t%d\t%d\t%s\t%s\t%s\n"
                % (start, start + length, length, n, "yes" if n >= 6 else "no",
                   raw.hex(), esc(idc.generate_disasm_line(start, 0)))
            )

    # ---- absolute operand census ----------------------------------------
    rows = []
    roll = collections.defaultdict(lambda: [0, collections.Counter(), set()])
    for start in idautils.Functions():
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        fname = idc.get_func_name(start) or ""
        ea = func.start_ea
        while ea < func.end_ea:
            flags = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(flags):
                if ida_ua.decode_insn(insn, ea) > 0:
                    mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
                    for idx, op in enumerate(insn.ops):
                        if op.type == 0:
                            break
                        if op.type != ida_ua.o_mem:
                            continue
                        raw_addr = op.addr
                        ea24 = raw_addr & 0xFFFFFF
                        if ea24 < 0xFF0000:
                            continue
                        line = esc(idc.generate_disasm_line(ea, 0))
                        rows.append((ea24, raw_addr, ea, mnem, idx, fname, line))
                        slot = roll[ea24]
                        slot[0] += 1
                        slot[1][mnem] += 1
                        if len(slot[2]) < 40:
                            slot[2].add(fname or ("%08X" % ea))
            ea = ida_bytes.get_item_end(ea)
    log("absolute operands >= 0xFF0000: %d sites, %d distinct addresses" % (len(rows), len(roll)))

    with open(os.path.join(OUT, "ioregs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea24\tida_addr\tsite\tmnem\topno\tfunction\tline\n")
        for ea24, raw_addr, site, mnem, idx, fname, line in sorted(rows):
            handle.write("%06X\t%08X\t%08X\t%s\t%d\t%s\t%s\n"
                         % (ea24, raw_addr, site, mnem, idx, fname, line))

    with open(os.path.join(OUT, "absrefs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea24\thits\tmnemonics\tn_functions\tsample_functions\n")
        for ea24 in sorted(roll):
            hits, mnems, funcs = roll[ea24]
            handle.write("%06X\t%d\t%s\t%d\t%s\n"
                         % (ea24, hits,
                            ",".join("%s:%d" % kv for kv in mnems.most_common(6)),
                            len(funcs), ",".join(sorted(funcs)[:6])))

    # page rollup
    pages = collections.Counter()
    for ea24 in roll:
        pages[ea24 >> 8] += roll[ea24][0]
    log("--- absolute pages ---")
    for page in sorted(pages):
        log("  %06X00  addrs=%d hits=%d"
            % (page, sum(1 for a in roll if (a >> 8) == page), pages[page]))

    # ---- xrefs -----------------------------------------------------------
    with open(os.path.join(OUT, "xrefs.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("to_ea\tto_name\tfrom_ea\tfrom_func\ttype\n")
        n = 0
        for start in idautils.Functions():
            name = idc.get_func_name(start) or ""
            for xr in idautils.XrefsTo(start, 0):
                owner = ida_funcs.get_func(xr.frm)
                handle.write("%08X\t%s\t%08X\t%s\t%d\n"
                             % (start, name, xr.frm,
                                idc.get_func_name(owner.start_ea) if owner else "", xr.type))
                n += 1
    log("xrefs %d" % n)

    # ---- strings ---------------------------------------------------------
    with open(os.path.join(OUT, "strings.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea\tlen\tnrefs\trefs\ttext\n")
        run = None
        count = 0
        for off in range(0, end + 1):
            byte = blob[off] if off < end else 0
            printable = 32 <= byte < 127
            if printable:
                if run is None:
                    run = off
            elif run is not None:
                if off - run >= 4:
                    ea = base + run
                    refs = ["%08X" % xr.frm for xr in idautils.XrefsTo(ea, 0)][:6]
                    handle.write("%08X\t%d\t%d\t%s\t%s\n"
                                 % (ea, off - run, len(refs), ",".join(refs),
                                    esc(blob[run:off].decode("ascii"))))
                    count += 1
                run = None
        log("strings %d" % count)


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")
idc.qexit(0)

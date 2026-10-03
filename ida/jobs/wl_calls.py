r"""WIRELESS agent: broad force-disassembly then caller/argument report.

WL_FORCE_RANGES  file of `START END LABEL` lines: force code across each.
WL_TARGETS       file of hex function addresses: report every caller plus the
                 immediate constants loaded in the 10 instructions before the
                 call (RX/H8S pass arguments in registers, so the preceding
                 `mov #imm, rN` lines are the arguments).

Writes ida\out\wireless\<JOB>_calls.tsv and <JOB>_callsites.txt.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_lines
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/wireless")
JOB = os.environ.get("YAESU_JOB", "WL")
LOG = os.path.join(OUT, "%s_calls_log.txt" % JOB)


def log(text):
    with open(LOG, "a", encoding="utf-8", newline="\n") as h:
        h.write(str(text) + "\n")


def force_range(start, end):
    made = 0
    ea = start
    while ea < end:
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags):
            nxt = ida_bytes.get_item_end(ea)
            ea = nxt if nxt > ea else ea + 1
            continue
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
        length = ida_ua.create_insn(ea)
        if length <= 0:
            ea += 1
            continue
        made += 1
        ea += length
    ida_auto.auto_wait()
    return made


def prev_lines(ea, count):
    out = []
    cur = ea
    for _ in range(count):
        prev = idc.prev_head(cur)
        if prev == idc.BADADDR or prev < ea - 80:
            break
        line = ida_lines.generate_disasm_line(prev, 0)
        out.append("%08X  %s" % (prev, ida_lines.tag_remove(line) if line else "?"))
        cur = prev
    out.reverse()
    return out


def main():
    open(LOG, "w", encoding="utf-8").close()
    ida_auto.auto_wait()
    log("job %s functions_start %d" % (JOB, len(list(idautils.Functions()))))

    ctrl = os.environ.get("WL_FORCE_RANGES", "")
    if ctrl and os.path.isfile(ctrl):
        with open(ctrl, "r", encoding="utf-8") as h:
            for line in h:
                line = line.split("#", 1)[0].strip()
                if not line:
                    continue
                p = line.split()
                if len(p) >= 2:
                    s, e = int(p[0], 16), int(p[1], 16)
                    n = force_range(s, e)
                    log("force %08X-%08X insn %d" % (s, e, n))
    ida_auto.auto_wait()
    log("functions_after_force %d" % len(list(idautils.Functions())))

    targets = []
    tf = os.environ.get("WL_TARGETS", "")
    if tf and os.path.isfile(tf):
        with open(tf, "r", encoding="utf-8") as h:
            for line in h:
                line = line.split("#", 1)[0].strip()
                if line:
                    targets.append(int(line, 16))

    tsv = os.path.join(OUT, "%s_calls.tsv" % JOB)
    txt = os.path.join(OUT, "%s_callsites.txt" % JOB)
    with open(tsv, "w", encoding="utf-8", newline="\n") as ht, \
            open(txt, "w", encoding="utf-8", newline="\n") as hx:
        ht.write("target\tcaller_ea\tcaller_func\tdisasm\n")
        for t in targets:
            hx.write("\n##### target %08X  %s\n" % (
                t, ida_funcs.get_func_name(t) or "-"))
            seen = 0
            for xr in idautils.XrefsTo(t, 0):
                fn = ida_funcs.get_func(xr.frm)
                line = ida_lines.generate_disasm_line(xr.frm, 0)
                ht.write("%08X\t%08X\t%s\t%s\n" % (
                    t, xr.frm,
                    ida_funcs.get_func_name(xr.frm) if fn else "-",
                    ida_lines.tag_remove(line) if line else "?"))
                hx.write("--- from %08X in %s\n" % (
                    xr.frm, ida_funcs.get_func_name(xr.frm) if fn else "-"))
                for pl in prev_lines(xr.frm, 12):
                    hx.write("    %s\n" % pl)
                seen += 1
            hx.write("    (callers: %d)\n" % seen)
    log("wrote %s and %s" % (tsv, txt))
    log("functions_end %d" % len(list(idautils.Functions())))


try:
    main()
except Exception:
    log("TRACEBACK\n" + traceback.format_exc())
idc.qexit(0)

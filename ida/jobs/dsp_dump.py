r"""DSP-AMBE reusable range dumper.

    --env DSP_RANGES=name:lo-hi,name2:lo-hi   (hex, no 0x needed)
    --env DSP_OUT=main|sub                    (subdir under ida\out\dsp)
    --env DSP_FORCE=1                         (force-decode first)
    --env DSP_XREF=ea,ea,...                  (list xrefs to these addresses)

Reopens an existing private database.  Writes ida\out\dsp\<sub>\d_<name>.tsv
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_lines
import ida_name
import idautils
import idc

ROOT = str(_REPO)


def esc(t):
    return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")


def force_code(lo, hi):
    ea, made = lo, 0
    while ea < hi:
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            if idc.create_insn(ea) > 0:
                made += 1
                ea += max(1, idc.get_item_size(ea))
                continue
            ea += 1
            continue
        ea += max(1, idc.get_item_size(ea))
    ida_auto.auto_wait()
    ea = lo
    while ea < hi:
        if ida_bytes.is_code(ida_bytes.get_flags(ea)) and not ida_funcs.get_func(ea):
            ida_funcs.add_func(ea)
        ea += max(1, idc.get_item_size(ea))
    ida_auto.auto_wait()
    return made


def main():
    out = os.path.join(ROOT, "ida", "out", "dsp", os.environ.get("DSP_OUT", "main"))
    os.makedirs(out, exist_ok=True)
    ida_auto.auto_wait()
    spec = os.environ.get("DSP_RANGES", "")
    force = os.environ.get("DSP_FORCE", "") == "1"
    log = []
    for part in [p for p in spec.split(",") if p.strip()]:
        name, _, rng = part.partition(":")
        a, _, b = rng.partition("-")
        lo, hi = int(a, 16), int(b, 16)
        if force:
            log.append("force %s made=%d" % (name, force_code(lo, hi)))
        rows = []
        ea = lo
        while ea < hi:
            sz = max(1, idc.get_item_size(ea))
            raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
            txt = ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS)
            txt = ida_lines.tag_remove(txt) if txt else "?"
            fn = ida_funcs.get_func(ea)
            xr = ["%#x" % x.frm for x in idautils.XrefsTo(ea, 0)]
            rows.append("%#010x\t%s\t%s\t%s\t%s\t%s"
                        % (ea, raw.hex(), esc(txt), ida_name.get_name(ea) or "",
                           ida_funcs.get_func_name(fn.start_ea) if fn else "",
                           ",".join(xr[:6])))
            ea += sz
        with open(os.path.join(out, "d_%s.tsv" % name), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
        log.append("dumped %s %#x..%#x rows=%d" % (name, lo, hi, len(rows)))

    xs = os.environ.get("DSP_XREF", "")
    if xs.strip():
        rows = ["# target\tfrom\tfrom_func\ttype\tinsn"]
        for t in [t for t in xs.split(",") if t.strip()]:
            ea = int(t, 16)
            hit = False
            for x in idautils.XrefsTo(ea, 0):
                fn = ida_funcs.get_func(x.frm)
                txt = ida_lines.tag_remove(
                    ida_lines.generate_disasm_line(x.frm, ida_lines.GENDSM_REMOVE_TAGS) or "")
                rows.append("%#010x\t%#010x\t%s\t%d\t%s"
                            % (ea, x.frm, ida_funcs.get_func_name(fn.start_ea) if fn else "",
                               x.type, esc(txt)))
                hit = True
            if not hit:
                rows.append("%#010x\t-\t-\t-\t-" % ea)
        with open(os.path.join(out, "d_xrefs.tsv"), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
        log.append("xrefs rows=%d" % (len(rows) - 1))

    with open(os.path.join(out, "d_log.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(log) + "\n")


try:
    main()
except Exception:
    out = os.path.join(ROOT, "ida", "out", "dsp", os.environ.get("DSP_OUT", "main"))
    os.makedirs(out, exist_ok=True)
    with open(os.path.join(out, "d_traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

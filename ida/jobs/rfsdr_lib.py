"""Shared helpers for the RF-SDR job scripts (agent RF-SDR).

Imported by ida/jobs/rfsdr_*.py. Writes only under ida\\out\\rf-sdr\\.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_segment
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/rf-sdr")
ASM = os.path.join(OUT, "asm")


def ensure_dirs() -> None:
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(ASM, exist_ok=True)


def open_out(name: str):
    ensure_dirs()
    return open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n")


def open_asm(name: str):
    ensure_dirs()
    return open(os.path.join(ASM, name), "w", encoding="utf-8", newline="\n")


def force_code(start: int, end: int) -> int:
    """Linear-sweep force instruction creation over [start, end)."""
    made = 0
    ea = start
    while ea < end:
        flags = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(flags) and ida_bytes.is_head(flags):
            size = ida_bytes.get_item_size(ea)
            ea += size if size > 0 else 1
            continue
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 8)
        size = ida_ua.create_insn(ea)
        if size <= 0:
            ea += 1
            continue
        made += 1
        ea += size
    return made


def dump_range(handle, start: int, end: int, label: str = "") -> None:
    if label:
        handle.write("; ==== %s  %08X-%08X ====\n" % (label, start, end))
    ea = start
    while ea < end:
        flags = ida_bytes.get_flags(ea)
        size = ida_bytes.get_item_size(ea)
        if size <= 0:
            size = 1
        raw = ida_bytes.get_bytes(ea, min(size, 12)) or b""
        name = idc.get_name(ea, 0) or ""
        fn = ida_funcs.get_func(ea)
        marker = ""
        if fn is not None and fn.start_ea == ea:
            marker = "  ; <<< FUNC %s" % (idc.get_func_name(ea) or "")
        line = idc.generate_disasm_line(ea, 0) or ""
        cmt = idc.get_cmt(ea, 0) or ""
        handle.write(
            "%08X  %-24s %-8s %s%s%s\n"
            % (ea, raw.hex(), name, line, ("   ; " + cmt) if cmt else "", marker)
        )
        ea += size


def seg_bytes():
    """[(start_ea, bytes)] for every segment."""
    out = []
    seg = ida_segment.get_first_seg()
    while seg is not None:
        size = seg.end_ea - seg.start_ea
        blob = ida_bytes.get_bytes(seg.start_ea, size)
        if blob and len(blob) == size:
            out.append((seg.start_ea, bytes(blob)))
        seg = ida_segment.get_next_seg(seg.start_ea)
    return out


def guard(fn):
    def wrapper():
        ensure_dirs()
        try:
            fn()
        except Exception:
            with open(os.path.join(OUT, "traceback.txt"), "a", encoding="utf-8") as h:
                h.write(traceback.format_exc())
                h.write("\n")
        idc.qexit(0)

    return wrapper


_ = idautils, ida_auto

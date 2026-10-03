"""Shared helpers for the STORAGE job scripts (agent STORAGE).

Imported by ida/jobs/stor_*.py. Writes only under ida\\out\\storage\\.
Databases are STOR_* under ida\\db\\jobs\\.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_nalt
import ida_name
import ida_segment
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/storage")
ASM = os.path.join(OUT, "asm")

BASE = 0xFFC00000


def ensure_dirs() -> None:
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(ASM, exist_ok=True)


def open_out(name: str, mode: str = "w"):
    ensure_dirs()
    return open(os.path.join(OUT, name), mode, encoding="utf-8", newline="\n")


def open_asm(name: str, mode: str = "w"):
    ensure_dirs()
    return open(os.path.join(ASM, name), mode, encoding="utf-8", newline="\n")


def force_code(start: int, end: int) -> int:
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


def make_funcs(start: int, end: int) -> int:
    """Turn every RTS-terminated run in [start,end) into a function."""
    n = 0
    for ea in range(start, end):
        f = ida_funcs.get_func(ea)
        if f is not None:
            continue
        flags = ida_bytes.get_flags(ea)
        if not (ida_bytes.is_code(flags) and ida_bytes.is_head(flags)):
            continue
        if ida_funcs.add_func(ea):
            n += 1
    ida_auto.auto_wait()
    return n


def dump_range(handle, start: int, end: int, label: str = "") -> None:
    if label:
        handle.write("; ==== %s  %08X-%08X  (file %06X-%06X) ====\n"
                     % (label, start, end, start - BASE, end - BASE))
    ea = start
    while ea < end:
        size = ida_bytes.get_item_size(ea)
        if size <= 0:
            size = 1
        raw = ida_bytes.get_bytes(ea, min(size, 12)) or b""
        name = idc.get_name(ea, 0) or ""
        fn = ida_funcs.get_func(ea)
        marker = ""
        if fn is not None and fn.start_ea == ea:
            marker = "   ; <<<< FUNC %s" % (idc.get_func_name(ea) or "")
        line = idc.generate_disasm_line(ea, 0) or ""
        handle.write("%08X  %-22s %-10s %s%s\n" % (ea, raw.hex(), name, line, marker))
        ea += size


def cstr(ea: int, limit: int = 128) -> str:
    out = []
    for i in range(limit):
        b = ida_bytes.get_byte(ea + i)
        if b == 0:
            break
        out.append(chr(b) if 32 <= b < 127 else "\\x%02x" % b)
    return "".join(out)


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


_ = idautils, ida_name, ida_nalt, ida_segment

"""Record USB0 operands and USB string references in one radio database.

Launch only through run_usb_scan.py. YAESU_JOB is MAIN or SUB.
Does not create a database, rename anything, or delete anything.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[1]  # repository root

import os

import ida_bytes
import ida_funcs
import ida_segment
import ida_ua
import idautils
import idc

OUT_ROOT = str(_REPO / "ida/out/survey")
USB0_LO = 0x000A0000
USB0_HI = 0x000A03FF
TABLE_OFF = 0x3DF4D
POOL_LO = 0x348000
POOL_HI = 0x350000


def _hex(value: int) -> str:
    return "%08X" % (value & 0xFFFFFFFF)


def _clean(text: str) -> str:
    return (
        text.replace("\\", "\\\\")
        .replace("\t", " ")
        .replace("\r", " ")
        .replace("\n", " ")
    )


def _image_base() -> int:
    seg = ida_segment.get_first_seg()
    if seg is None:
        raise RuntimeError("no segment")
    return seg.start_ea


def _read(ea: int, size: int) -> bytes:
    data = ida_bytes.get_bytes(ea, size)
    if not data or len(data) != size:
        return b""
    return bytes(data)


def _segments(base: int):
    parts = []
    seg = ida_segment.get_first_seg()
    while seg is not None:
        size = seg.end_ea - seg.start_ea
        blob = _read(seg.start_ea, size)
        if blob:
            parts.append((seg.start_ea - base, blob))
        seg = ida_segment.get_next_seg(seg.start_ea)
    return parts


def _find_in(parts, needle: bytes, start_off: int, end_off: int):
    found = []
    for part_off, blob in parts:
        part_end = part_off + len(blob)
        lo = max(start_off, part_off)
        hi = min(end_off, part_end)
        if hi <= lo:
            continue
        local = blob[lo - part_off : hi - part_off]
        cursor = 0
        while True:
            index = local.find(needle, cursor)
            if index < 0:
                break
            found.append(lo + index)
            cursor = index + 1
    return found


def _word_usb(parts):
    """Delimited 'USB' in the message pool near file 0x34A800."""
    hits = []
    for off in _find_in(parts, b"USB", POOL_LO, POOL_HI):
        prev = 0
        nxt = 0
        for part_off, blob in parts:
            if part_off <= off - 1 < part_off + len(blob):
                prev = blob[off - 1 - part_off]
            if part_off <= off + 3 < part_off + len(blob):
                nxt = blob[off + 3 - part_off]
        if (65 <= prev <= 90) or (97 <= prev <= 122):
            continue
        if (65 <= nxt <= 90) or (97 <= nxt <= 122):
            continue
        hits.append(off)
    return hits


def _targets(base: int):
    """Map of image address -> (kind, label). USB0 is not in this map."""
    named = {
        b"USB CAMERA": "string",
        b"COM PORT SETTING": "string",
        b"VID_045B": "string",
        b"PID_0025": "string",
    }
    parts = _segments(base)
    end_off = 0
    for part_off, blob in parts:
        end_off = max(end_off, part_off + len(blob))
    found = {}
    for needle, kind in named.items():
        for off in _find_in(parts, needle, 0, end_off):
            found[base + off] = (kind, needle.decode("ascii"))
    for off in _word_usb(parts):
        found[base + off] = ("string", "USB")
    table_ea = base + TABLE_OFF
    anchor = _read(table_ea, 16)
    if anchor.startswith(b"TARGET LOCATION"):
        found[table_ea] = ("table", "setup-table")
    return found


def _in_usb0(value: int) -> bool:
    return USB0_LO <= (value & 0xFFFFFFFF) <= USB0_HI


def _operand_values(insn):
    values = []
    for op in insn.ops:
        if op.type == ida_ua.o_void:
            break
        if op.type == ida_ua.o_imm:
            values.append(("operand", op.value & 0xFFFFFFFF))
        elif op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far, ida_ua.o_displ):
            values.append(("mem", op.addr & 0xFFFFFFFF))
            extra = op.value & 0xFFFFFFFF
            if extra and extra != (op.addr & 0xFFFFFFFF):
                values.append(("operand", extra))
    return values


def _load_tsv_eas(path: str):
    eas = []
    with open(path, encoding="utf-8") as handle:
        next(handle)
        for line in handle:
            line = line.strip()
            if not line:
                continue
            eas.append(int(line.split("\t", 1)[0], 16))
    return eas


def main() -> None:
    name = os.environ.get("YAESU_JOB", "").strip()
    folder = os.path.join(OUT_ROOT, name)
    os.makedirs(folder, exist_ok=True)
    rows = []
    seen = set()
    base = _image_base()
    named = _targets(base)

    def add(func_ea: int, insn_ea: int, kind: str, value: int, disasm: str) -> None:
        key = (func_ea, insn_ea, kind, value & 0xFFFFFFFF)
        if key in seen:
            return
        seen.add(key)
        rows.append(
            (
                _hex(func_ea),
                _hex(insn_ea),
                kind,
                _hex(value),
                _clean(disasm),
            )
        )

    visited = []
    for start in idautils.Functions():
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        visited.append(func.start_ea)
        ea = func.start_ea
        while ea < func.end_ea:
            insn = ida_ua.insn_t()
            size = ida_ua.decode_insn(insn, ea)
            if size <= 0:
                ea += 1
                continue
            disasm = idc.generate_disasm_line(ea, 0) or ""
            for kind, value in _operand_values(insn):
                if _in_usb0(value):
                    add(func.start_ea, ea, kind, value, disasm)
                named_hit = named.get(value)
                if named_hit is not None:
                    label_kind, label = named_hit
                    add(func.start_ea, ea, label_kind, value, "%s | %s" % (label, disasm))
            for ref in idautils.DataRefsFrom(ea):
                ref &= 0xFFFFFFFF
                if _in_usb0(ref):
                    add(func.start_ea, ea, "mem", ref, disasm)
                named_hit = named.get(ref)
                if named_hit is not None:
                    label_kind, label = named_hit
                    add(func.start_ea, ea, label_kind, ref, "%s | %s" % (label, disasm))
            ea += size
        # Literal pools and other non-code dwords. Processor endian via get_dword.
        cursor = func.start_ea & ~3
        if cursor < func.start_ea:
            cursor += 4
        while cursor + 4 <= func.end_ea:
            flags = ida_bytes.get_flags(cursor)
            value = ida_bytes.get_dword(cursor) & 0xFFFFFFFF
            if not ida_bytes.is_code(flags):
                if _in_usb0(value):
                    raw = _read(cursor, 8)
                    add(
                        func.start_ea,
                        cursor,
                        "literal",
                        value,
                        "dword %s" % raw.hex(),
                    )
                named_hit = named.get(value)
                if named_hit is not None:
                    label_kind, label = named_hit
                    add(func.start_ea, cursor, label_kind, value, "dword %s" % label)
            else:
                # A pointer constant mis-decoded as code is still the named address.
                named_hit = named.get(value)
                if named_hit is not None:
                    label_kind, label = named_hit
                    text = idc.generate_disasm_line(cursor, 0) or "code-dword"
                    add(func.start_ea, cursor, label_kind, value, "%s | %s" % (label, text))
            cursor += 4

    tsv_path = os.path.join(folder, "functions.tsv")
    tsv_eas = _load_tsv_eas(tsv_path)
    equal = "yes" if set(visited) == set(tsv_eas) and len(visited) == len(tsv_eas) else "no"
    coverage = "functions_visited=%d functions_tsv_rows=%d equal=%s\n" % (
        len(visited),
        len(tsv_eas),
        equal,
    )
    with open(os.path.join(folder, "usb_coverage.txt"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write(coverage)
    out_path = os.path.join(folder, "usb_operands.tsv")
    with open(out_path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("func_ea\tinsn_ea\tkind\tvalue\tdisasm\n")
        for func_ea, insn_ea, kind, value, disasm in rows:
            handle.write("%s\t%s\t%s\t%s\t%s\n" % (func_ea, insn_ea, kind, value, disasm))
    idc.qexit(0)


if __name__ == "__main__":
    main()

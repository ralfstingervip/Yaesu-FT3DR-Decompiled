r"""MAIN-FULL stage 1: exhaustive code recovery of the FT3DR H8S MAIN image.

Run through run_job.py only.  Seeded from ida\db\radio\MAIN.i64 with
--copy-from, so the 1298 functions of the earlier survey are already present.

Stages
  0  report processor / segment / entry state
  1  decode all 256 vector slots, create a function at every distinct target
  2  collect every big-endian dword in the image that points into the code
     region; promote the ones that look like function starts
  3  raw prologue-pattern sweep (STM.L / PUSH.L / PUSH.W forms emitted by the
     Renesas H8S C compiler, derived from the 1298 known starts)
  4  linear sweep of every remaining gap in the code region
  5  write the tables

Output: ida/out/main-full/
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import struct
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_name
import ida_segment
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-full")
os.makedirs(OUT, exist_ok=True)

LOG_PATH = os.path.join(OUT, "stage1_log.txt")
_LOG = []


def log(text: str) -> None:
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")


def flush_log() -> None:
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(_LOG) + "\n")


# --- prologue patterns ------------------------------------------------------
# H8S/2600 advanced-mode encodings the Renesas C compiler uses to open a frame.
#   01 10 6D Fn   STM.L (ERn-ERn+1), @-SP
#   01 20 6D Fn   STM.L (ERn-ERn+2), @-SP
#   01 30 6D Fn   STM.L (ERn-ERn+3), @-SP
#   01 00 6D Fn   MOV.L ERn, @-SP        (PUSH.L ERn)
#   6D Fn         MOV.W Rn, @-SP         (PUSH.W Rn)
def prologue_kind(blob: bytes, off: int) -> str:
    if off + 4 <= len(blob):
        a, b, c, d = blob[off], blob[off + 1], blob[off + 2], blob[off + 3]
        if a == 0x01 and b in (0x10, 0x20, 0x30) and c == 0x6D and 0xF0 <= d <= 0xF7:
            return "stm%d" % ((b >> 4) + 1)
        if a == 0x01 and b == 0x00 and c == 0x6D and 0xF0 <= d <= 0xF7:
            return "pushl"
    if off + 2 <= len(blob):
        a, b = blob[off], blob[off + 1]
        if a == 0x6D and 0xF0 <= b <= 0xF7:
            return "pushw"
    return ""


# Bytes that plausibly end the previous function, so a prologue right after is
# very likely a real entry point.
TERMINATORS = (
    b"\x54\x70",  # RTS
    b"\x56\x70",  # RTE
    b"\x54\x60",  # RTS/L-ish guard (unused encodings are harmless here)
)


def decode_chain(ea: int, limit_ea: int, max_insn: int = 64):
    """Try a linear decode from ea.  Returns (n_insn, end_ea, terminated)."""
    insn = ida_ua.insn_t()
    cur = ea
    count = 0
    while count < max_insn and cur < limit_ea:
        length = ida_ua.decode_insn(insn, cur)
        if length <= 0 or insn.itype == 0:
            return count, cur, False
        mnem = (ida_ua.print_insn_mnem(cur) or "").lower()
        cur += length
        count += 1
        if mnem in ("rts", "rte", "rtsl", "sleep"):
            return count, cur, True
        if mnem in ("jmp", "bra"):
            return count, cur, True
    return count, cur, False


def main() -> None:
    ida_auto.auto_wait()
    proc = ida_ida.inf_get_procname()
    log("proc %s" % proc)
    log("min %#x max %#x" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
    seg = ida_segment.get_first_seg()
    segs = []
    while seg is not None:
        segs.append((seg.start_ea, seg.end_ea, ida_segment.get_segm_name(seg)))
        seg = ida_segment.get_next_seg(seg.start_ea)
    for s, e, n in segs:
        log("segment %s %#x-%#x" % (n, s, e))

    base = segs[0][0]
    top = segs[-1][1]
    blob = ida_bytes.get_bytes(base, top - base)
    if blob is None:
        raise RuntimeError("cannot read image bytes")
    log("image bytes %d" % len(blob))

    # confirm the content end
    end = len(blob)
    while end > 0 and blob[end - 1] == 0xFF:
        end -= 1
    content_end = end
    log("content_end %#x (0x%X bytes of 0xFF fill above it)" % (content_end, len(blob) - content_end))

    before = len(list(idautils.Functions()))
    log("functions_before %d" % before)

    # ---- stage 1: vectors -------------------------------------------------
    vec_rows = []
    targets = {}
    for index in range(256):
        ea = base + index * 4
        ida_bytes.del_items(ea, 0, 4)
        ida_bytes.create_dword(ea, 4, True)
        value = ida_bytes.get_dword(ea)
        vec_rows.append((index, ea, value))
        if base <= value < base + content_end:
            targets.setdefault(value, []).append(index)
    log("vector distinct targets %d" % len(targets))
    for value in sorted(targets):
        if ida_funcs.get_func(value) is None:
            ida_ua.create_insn(value)
            ida_funcs.add_func(value)
    ida_auto.auto_wait()
    log("functions_after_vectors %d" % len(list(idautils.Functions())))

    # ---- stage 2: big-endian pointer sweep --------------------------------
    ptr_hits = {}
    limit = content_end - 3
    for off in range(0, limit, 2):
        value = struct.unpack_from(">I", blob, off)[0]
        if 0x400 <= value < content_end and (value & 1) == 0:
            ptr_hits.setdefault(value, []).append(off)
    log("pointer candidates %d distinct" % len(ptr_hits))

    promoted = 0
    for value, sites in ptr_hits.items():
        off = value - base
        if ida_funcs.get_func(value) is not None:
            continue
        kind = prologue_kind(blob, off)
        strong = bool(kind)
        if not strong:
            # a pointer repeated in an aligned run of pointers is also good
            n, _, term = decode_chain(value, base + content_end, 24)
            strong = term and n >= 4
        if strong:
            ida_ua.create_insn(value)
            if ida_funcs.add_func(value):
                promoted += 1
    ida_auto.auto_wait()
    log("promoted_from_pointers %d" % promoted)
    log("functions_after_pointers %d" % len(list(idautils.Functions())))

    # ---- stage 3: raw prologue sweep --------------------------------------
    pro = 0
    for off in range(0, content_end - 4, 2):
        ea = base + off
        kind = prologue_kind(blob, off)
        if not kind:
            continue
        if ida_funcs.get_func(ea) is not None:
            continue
        flags = ida_bytes.get_flags(ea)
        if not ida_bytes.is_unknown(flags) and not ida_bytes.is_code(flags):
            continue
        if kind == "pushw":
            # too short to be distinctive on its own: require a terminator just
            # before it, or an existing xref
            prev = blob[off - 2:off]
            if prev not in TERMINATORS and not list(idautils.XrefsTo(ea, 0)):
                continue
        n, _, term = decode_chain(ea, base + content_end, 48)
        if n < 3:
            continue
        ida_ua.create_insn(ea)
        if ida_funcs.add_func(ea):
            pro += 1
    ida_auto.auto_wait()
    log("promoted_from_prologues %d" % pro)
    log("functions_after_prologues %d" % len(list(idautils.Functions())))

    # ---- stage 4: gap linear sweep ----------------------------------------
    # walk the code region; for each run of undefined bytes, try to decode.
    swept = 0
    off = 0x400
    while off < content_end - 4:
        ea = base + off
        flags = ida_bytes.get_flags(ea)
        if not ida_bytes.is_unknown(flags):
            item_end = ida_bytes.get_item_end(ea)
            off = max(off + 2, item_end - base)
            continue
        n, end_ea, term = decode_chain(ea, base + content_end, 96)
        if term and n >= 6:
            ida_ua.create_insn(ea)
            if ida_funcs.add_func(ea):
                swept += 1
                off = max(off + 2, (end_ea - base))
                continue
        off += 2
    ida_auto.auto_wait()
    log("promoted_from_gapsweep %d" % swept)
    after = len(list(idautils.Functions()))
    log("functions_after %d" % after)

    # ---- stage 5: tables --------------------------------------------------
    with open(os.path.join(OUT, "vectors.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("index\tslot_ea\tvalue\tkind\ttarget_func\ttarget_name\tfirst_insn\n")
        filler = None
        counts = {}
        for _, _, value in vec_rows:
            counts[value] = counts.get(value, 0) + 1
        if counts:
            filler = max(counts, key=lambda k: counts[k])
        for index, ea, value in vec_rows:
            if value == filler and counts[value] > 8:
                kind = "filler"
            elif base <= value < base + content_end:
                kind = "handler"
            else:
                kind = "outside"
            func = ida_funcs.get_func(value)
            fstart = "%08X" % func.start_ea if func else ""
            fname = idc.get_func_name(value) if func else ""
            line = idc.generate_disasm_line(value, 0) or ""
            handle.write(
                "%d\t%08X\t%08X\t%s\t%s\t%s\t%s\n"
                % (index, ea, value, kind, fstart, fname, line.replace("\t", " "))
            )

    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write("ea\tend\tsize\tname\tnrefs\n")
        total = 0
        for start in idautils.Functions():
            func = ida_funcs.get_func(start)
            if func is None:
                continue
            size = func.end_ea - func.start_ea
            total += size
            nrefs = len(list(idautils.XrefsTo(start, 0)))
            handle.write(
                "%08X\t%08X\t%d\t%s\t%d\n"
                % (start, func.end_ea, size, idc.get_func_name(start) or "", nrefs)
            )
    log("function_bytes %d of content %d (%.1f%%)" % (total, content_end, 100.0 * total / content_end))

    # byte coverage by flag class over the whole image
    code = data = unk = 0
    for off in range(0, content_end):
        flags = ida_bytes.get_flags(base + off)
        if ida_bytes.is_code(flags):
            code += 1
        elif ida_bytes.is_unknown(flags):
            unk += 1
        else:
            data += 1
    log("bytes_code %d bytes_data %d bytes_unknown %d (content %d)" % (code, data, unk, content_end))


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    flush_log()
else:
    flush_log()
idc.qexit(0)

"""IDA 9.1 survey of an FT3DR image or USB library.

Launch only through run_survey.py. The job name arrives in YAESU_JOB.
PowerShell never sees the idat argument list.

Writes UTF-8 tables under ida/out/survey/<job>.
Does not print key material. Exit via idc.qexit.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[1]  # repository root

import collections
import os
import struct
import traceback

import ida_auto
import ida_bytes
import ida_entry
import ida_funcs
import ida_ida
import ida_idp
import ida_name
import ida_nalt
import ida_segment
import ida_ua
import ida_xref
import idautils
import idc

ROOT = str(_REPO)
OUT_ROOT = os.path.join(ROOT, "ida", "out", "survey")

# RX64M USB0 block from the hardware manual (SYSCFG at 000A0000h).
USB0_NAMES = {
    0x000A0000: "USB0_SYSCFG",
    0x000A0004: "USB0_SYSSTS0",
    0x000A0008: "USB0_DVSTCTR0",
    0x000A0014: "USB0_CFIFO",
    0x000A0018: "USB0_D0FIFO",
    0x000A001C: "USB0_D1FIFO",
    0x000A0020: "USB0_CFIFOSEL",
    0x000A0022: "USB0_CFIFOCTR",
    0x000A0028: "USB0_D0FIFOSEL",
    0x000A002A: "USB0_D0FIFOCTR",
    0x000A002C: "USB0_D1FIFOSEL",
    0x000A002E: "USB0_D1FIFOCTR",
    0x000A0030: "USB0_INTENB0",
    0x000A0032: "USB0_INTENB1",
}

FOCUS_KEYS = (
    "usb",
    "sdr",
    "debug",
    "factory",
    "hidden",
    "camera",
    "bluetooth",
    "baud",
    "hudi",
    "cdc",
    "dfu",
    "com port",
    "serial",
    "i/q",
    "diag",
    "service",
    "ram display",
    "test mode",
    "h8s",
    "rx64",
)


def _esc(text: str) -> str:
    return (
        text.replace("\\", "\\\\")
        .replace("\t", " ")
        .replace("\r", " ")
        .replace("\n", " ")
    )


class Job:
    def __init__(self, name: str) -> None:
        self.name = name
        self.dir = os.path.join(OUT_ROOT, name)
        os.makedirs(self.dir, exist_ok=True)
        self.status_path = os.path.join(self.dir, "status.txt")
        with open(self.status_path, "w", encoding="utf-8", newline="\n") as handle:
            handle.write("")

    def log(self, text: str) -> None:
        with open(self.status_path, "a", encoding="utf-8", newline="\n") as handle:
            handle.write(text + "\n")


def _xref_kind(value: int) -> str:
    names = (
        "fl_CF",
        "fl_CN",
        "fl_JF",
        "fl_JN",
        "fl_F",
        "dr_O",
        "dr_W",
        "dr_R",
        "dr_T",
        "dr_I",
    )
    for name in names:
        if hasattr(ida_xref, name) and getattr(ida_xref, name) == value:
            return name
    return "t%x" % value


def _ascii_strings(blob: bytes, base: int, min_len: int = 5):
    start = None
    for index, byte in enumerate(blob):
        if 32 <= byte < 127:
            if start is None:
                start = index
        elif start is not None:
            if index - start >= min_len:
                yield base + start, blob[start:index].decode("ascii")
            start = None
    if start is not None and len(blob) - start >= min_len:
        yield base + start, blob[start:].decode("ascii")


def _segment_parts(job: Job):
    parts = []
    cursor = ida_segment.get_first_seg()
    if cursor is None:
        raise RuntimeError("no segment")
    while cursor is not None:
        size = cursor.end_ea - cursor.start_ea
        data = ida_bytes.get_bytes(cursor.start_ea, size)
        if data and len(data) == size:
            parts.append((cursor.start_ea, bytes(data)))
        else:
            job.log("unreadable segment %#x size %#x" % (cursor.start_ea, size))
        cursor = ida_segment.get_next_seg(cursor.start_ea)
    total = sum(len(blob) for _, blob in parts)
    job.log("segments %d bytes %#x" % (len(parts), total))
    return parts


def _rebase(job: Job, base: int) -> None:
    seg = ida_segment.get_first_seg()
    if seg is None:
        raise RuntimeError("no segment to rebase")
    delta = base - seg.start_ea
    job.log("rebase delta %#x from %#x" % (delta, seg.start_ea))
    if delta == 0:
        return
    rc = ida_segment.rebase_program(delta, ida_segment.MSF_NOFIX)
    if rc != ida_segment.MOVE_SEGM_OK:
        raise RuntimeError("rebase_program returned %s" % rc)


def _split_sub(job: Job, base: int, size: int) -> None:
    """Keep the code-like head executable. The rest is a resource image."""
    seg = ida_segment.get_first_seg()
    if seg is None:
        raise RuntimeError("no segment to split")
    end = seg.end_ea
    if end - seg.start_ea != size:
        job.log("segment size %#x file size %#x" % (end - seg.start_ea, size))
    ida_segment.del_segm(seg.start_ea, ida_segment.SEGMOD_KEEP)
    cuts = (
        (0x00000, 0x40000, "ROM", "CODE"),
        (0x40000, 0x2E0000, "RES", "DATA"),
        (0x2E0000, 0x350000, "DENSE", "DATA"),
        (0x350000, size - 0x80, "PAD", "DATA"),
        (size - 0x80, size, "VECT", "DATA"),
    )
    for start_off, end_off, name, klass in cuts:
        if end_off <= start_off:
            continue
        ok = ida_segment.add_segm(
            0,
            base + start_off,
            base + end_off,
            name,
            klass,
            ida_segment.ADDSEG_NOAA,
        )
        job.log("segment %s %s %#x-%#x ok=%s" % (name, klass, base + start_off, base + end_off, ok))
    _ = end


def _define_vectors(job: Job, table_ea: int, count: int, lo: int, hi: int, names: dict):
    rows = []
    made = 0
    for index in range(count):
        ea = table_ea + index * 4
        ida_bytes.del_items(ea, 0, 4)
        ida_bytes.create_dword(ea, 4, True)
        value = ida_bytes.get_dword(ea)
        inside = lo <= value < hi
        label = names.get(index, "")
        if inside:
            if label:
                ida_name.set_name(value, label, ida_name.SN_FORCE)
            ida_ua.create_insn(value)
            ida_auto.auto_make_code(value)
            if label:
                ida_entry.add_entry(value, value, label, True)
            made += 1
        rows.append((index, ea, value, inside, label))
    job.log("vectors %d inside %d" % (count, made))
    path = os.path.join(job.dir, "vectors.tsv")
    with open(path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("index\tea\tvalue\tin_image\tname\n")
        for index, ea, value, inside, label in rows:
            handle.write(
                "%d\t%08X\t%08X\t%s\t%s\n" % (index, ea, value, "yes" if inside else "no", label)
            )
    return rows


def _prepare_raw(job: Job) -> int:
    ida_auto.enable_auto(False)
    if job.name == "MAIN":
        _rebase(job, 0)
        parts = _segment_parts(job)
        image_end = parts[-1][0] + len(parts[-1][1])
        # H8S/2370 group: 32-bit big-endian vectors, NMI at index 7.
        _define_vectors(
            job,
            0,
            256,
            0,
            image_end,
            {0: "reset_handler", 7: "nmi_handler"},
        )
        return 0x2092
    if job.name == "SUB":
        base_guess = 0xFFC00000
        _rebase(job, base_guess)
        seg = ida_segment.get_first_seg()
        size = seg.end_ea - seg.start_ea
        _split_sub(job, base_guess, size)
        reset = ida_bytes.get_dword(base_guess + size - 4)
        job.log("reset dword at end %#x" % reset)
        _define_vectors(
            job,
            base_guess + size - 0x80,
            32,
            base_guess,
            base_guess + size,
            {31: "reset_handler"},
        )
        return base_guess
    raise RuntimeError("unknown raw job %s" % job.name)


def _disasm_ok(ea: int, proc: str) -> tuple[bool, str]:
    line = idc.generate_disasm_line(ea, 0) or ""
    low = line.lower()
    if proc.startswith("h8"):
        ok = "mov" in low and ("er7" in low or "sp" in low)
    elif proc.startswith("rx"):
        ok = bool(line) and not low.startswith(("dc", "db ", ".byte", "align"))
    else:
        ok = bool(line)
    return ok, line


def _write_functions(job: Job) -> int:
    path = os.path.join(job.dir, "functions.tsv")
    xref_path = os.path.join(job.dir, "xrefs.tsv")
    count = 0
    xref_count = 0
    with open(path, "w", encoding="utf-8", newline="\n") as funcs, open(
        xref_path, "w", encoding="utf-8", newline="\n"
    ) as xrefs:
        funcs.write("ea\tend\tsize\tname\n")
        xrefs.write("to_ea\tto_name\tfrom_ea\tfrom_func\tkind\n")
        for start in idautils.Functions():
            func = ida_funcs.get_func(start)
            if func is None:
                continue
            name = idc.get_func_name(start) or ""
            size = func.end_ea - func.start_ea
            funcs.write("%08X\t%08X\t%d\t%s\n" % (start, func.end_ea, size, _esc(name)))
            count += 1
            for xr in idautils.XrefsTo(start, 0):
                owner = ida_funcs.get_func(xr.frm)
                owner_name = idc.get_func_name(owner.start_ea) if owner else ""
                xrefs.write(
                    "%08X\t%s\t%08X\t%s\t%s\n"
                    % (start, _esc(name), xr.frm, _esc(owner_name), _xref_kind(xr.type))
                )
                xref_count += 1
    job.log("functions %d xrefs %d" % (count, xref_count))
    return count


def _focus(job: Job, parts, proc: str) -> None:
    path = os.path.join(job.dir, "focus.tsv")
    hits = 0
    with open(path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("kind\tea\tdetail\n")
        for base, blob in parts:
            for ea, text in _ascii_strings(blob, base, 5):
                low = text.lower()
                if not any(key in low for key in FOCUS_KEYS):
                    continue
                if len(text) > 180:
                    text = text[:180]
                handle.write("string\t%08X\t%s\n" % (ea, _esc(text)))
                hits += 1
                seen = 0
                for xr in idautils.XrefsTo(ea, 0):
                    owner = ida_funcs.get_func(xr.frm)
                    owner_name = idc.get_func_name(owner.start_ea) if owner else ""
                    handle.write(
                        "string_xref\t%08X\tfrom %08X %s %s\n"
                        % (ea, xr.frm, _xref_kind(xr.type), _esc(owner_name))
                    )
                    seen += 1
                    if seen >= 12:
                        break
                if hits >= 500:
                    break
            if hits >= 500:
                handle.write("note\t0\tstring list truncated at 500\n")
                break
        if proc.startswith("rx"):
            counts = collections.Counter()
            for _, blob in parts:
                limit = len(blob) - 3
                for offset in range(limit):
                    value = struct.unpack_from("<I", blob, offset)[0]
                    if 0x00080000 <= value <= 0x0010FFFF:
                        counts[value] += 1
            ranked = [item for item in counts.most_common(80) if item[1] >= 3]
            handle.write("note\t0\tperipheral dword hits (count>=3, plus USB0 count>=2)\n")
            seen_addr = {addr for addr, _count in ranked}
            for addr in range(0x000A0000, 0x000A0400, 2):
                if counts[addr] >= 2 and addr not in seen_addr:
                    ranked.append((addr, counts[addr]))
            for addr, count in ranked:
                label = USB0_NAMES.get(addr, "")
                handle.write("periph\t%08X\tcount %d %s\n" % (addr, count, label))
        elif proc.startswith("h8"):
            counts = collections.Counter()
            for _, blob in parts:
                limit = len(blob) - 3
                for offset in range(limit):
                    value = struct.unpack_from(">I", blob, offset)[0]
                    if 0x00FF0000 <= value <= 0x00FFFFFF:
                        counts[value] += 1
            handle.write("note\t0\tH8S I/O-range big-endian hits (count>=8)\n")
            for addr, count in counts.most_common(60):
                if count < 8:
                    break
                handle.write("periph\t%08X\tcount %d\n" % (addr, count))
    job.log("focus rows written, string hits %d" % hits)


def _summary(job: Job, entry: int, func_count: int) -> None:
    proc = ida_idp.get_idp_name() or ""
    ok, line = _disasm_ok(entry, proc)
    path = os.path.join(job.dir, "summary.txt")
    seg_lines = []
    seg = ida_segment.get_first_seg()
    while seg is not None:
        seg_lines.append(
            "%s %08X-%08X class bitness %s"
            % (
                idc.get_segm_name(seg.start_ea),
                seg.start_ea,
                seg.end_ea,
                seg.bitness,
            )
        )
        seg = ida_segment.get_next_seg(seg.start_ea)
    with open(path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("job %s\n" % job.name)
        handle.write("processor %s\n" % proc)
        handle.write("input %s\n" % (ida_nalt.get_input_file_path() or ""))
        handle.write("entry %08X\n" % entry)
        handle.write("entry_disasm %s\n" % line)
        handle.write("disasm_ok %s\n" % ("yes" if ok else "no"))
        handle.write("functions %d\n" % func_count)
        handle.write("segments\n")
        for row in seg_lines:
            handle.write("  %s\n" % row)
    job.log("disasm_ok %s entry %s" % ("yes" if ok else "no", line))


def _dump_loaded(job: Job, entry: int) -> None:
    ida_auto.enable_auto(True)
    job.log("auto_wait_begin")
    ida_auto.auto_wait()
    job.log("auto_wait_end")
    if entry:
        ida_ua.create_insn(entry)
        ida_auto.auto_make_code(entry)
        ida_auto.auto_wait()
    func_count = _write_functions(job)
    parts = _segment_parts(job)
    proc = ida_idp.get_idp_name() or ""
    _focus(job, parts, proc)
    _summary(job, entry, func_count)


def main() -> None:
    name = os.environ.get("YAESU_JOB", "").strip()
    job = Job(name or "UNKNOWN")
    try:
        if name not in ("MAIN", "SUB", "RCOMMS", "RFP"):
            raise RuntimeError("YAESU_JOB must be MAIN, SUB, RCOMMS, or RFP")
        job.log("processor %s" % (ida_idp.get_idp_name() or ""))
        entry = 0
        if name in ("MAIN", "SUB"):
            entry = _prepare_raw(job)
            job.log("entry candidate %#x" % entry)
        else:
            # PE library. The loader already chose the processor.
            entry = ida_ida.inf_get_start_ea()
        _dump_loaded(job, entry)
        job.log("survey_done")
        idc.qexit(0)
    except Exception:
        job.log("survey_failed")
        job.log(traceback.format_exc())
        idc.qexit(1)


if __name__ == "__main__":
    main()

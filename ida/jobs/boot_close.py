r"""BOOT-IPC closeout pass. Side-aware (YAESU_JOB = BOOT_IPC_MAIN | BOOT_IPC_SUB).

Dumps the functions, xrefs and linear ranges needed to close:
  (A) DSP loader state machine sub_5DCFE / queue engine (states 5-7)
  (B) key decoder sub_100E4 behind port 0xFFFF4C, and port 0xFFFF52 users
  (C) MAIN<->SUB inter-processor command path (0xFF96F8 mailbox egress,
      0xFC00 bulk settings-block builder, SUB RX callback + settings apply)

Override any list with env BOOT_FUNCS / BOOT_XREFS / BOOT_RANGES (semicolon
separated ranges lo-hi). Output: ida\out\boot-ipc\<JOB>_close.txt
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_idaapi, idautils, idc

OUT = str(_REPO / "ida/out/boot-ipc")
JOB = os.environ.get("YAESU_JOB", "job")
SUF = os.environ.get("BOOT_OUT", "close")

# ---- default target lists per side -----------------------------------------
MAIN_FUNCS = [
    # (A) DSP loader + queue engine
    0x5DCFE, 0x5DCDA, 0x5E9E2, 0x103C0, 0x3FF10,
    0x78222, 0x7823C, 0x7815C, 0x78106, 0x7711E, 0x7701E,
    0x768A8, 0x76F44, 0x78160, 0x781BA, 0x7850E, 0x55FFE,
    0x56492, 0x564B2, 0x564FA, 0x56520, 0x56056,
    # (B) key decode + USB personality gate
    0x100E4, 0x101B2, 0x54C44, 0x54BF8,
    # (C) inter-processor mailbox + bulk builder
    0x2461C, 0x24724, 0x73908, 0x73AB4, 0x73B62, 0x74310, 0x74364, 0x71196,
]
MAIN_XREFS = [
    0x5DCFE, 0x103C0, 0x24724, 0x2461C, 0x73AB4, 0x74310, 0x74364,
    0x78106, 0x7711E, 0x7701E, 0x7815C, 0x71196, 0x54D50, 0x73908,
]
MAIN_RANGES = [(0x76800, 0x78560)]

SUB_FUNCS = [
    0xFFEDB081, 0xFFEDB131,          # SCI0 tx/rx callbacks (from 0x12D20 table)
    0xFFEF4142,                       # settings apply (shadow 0x8C4D <- 0x8E46)
    0xFFEDAB4C,                       # serial init
]
SUB_XREFS = [0xFFEDB131, 0xFFEDB081, 0xFFEF4142, 0x00008E46, 0x00008C4D]
SUB_RANGES = []


def dis(ea):
    return idc.generate_disasm_line(ea, 0) or ""


def parse_eas(name):
    v = os.environ.get(name, "").strip()
    if not v:
        return None
    out = []
    for tok in v.replace(" ", "").split(","):
        if tok:
            out.append(int(tok, 16))
    return out


def parse_ranges(name):
    v = os.environ.get(name, "").strip()
    if not v:
        return None
    out = []
    for part in v.split(";"):
        part = part.strip()
        if "-" in part:
            lo, hi = part.split("-", 1)
            out.append((int(lo, 16), int(hi, 16)))
    return out


def dump_func(ea, lines):
    f = ida_funcs.get_func(ea)
    if f is None:
        ida_ua.create_insn(ea)
        ida_auto.auto_wait()
        f = ida_funcs.get_func(ea)
    if f is None:
        lines.append("; no function at %08X; linear 80" % ea)
        cur = ea
        for _ in range(80):
            lines.append("%08X  %s" % (cur, dis(cur)))
            nh = ida_bytes.next_head(cur, cur + 0x2000)
            cur = nh if nh != ida_idaapi.BADADDR and nh > cur else cur + 1
        return
    name = ida_funcs.get_func_name(f.start_ea)
    lines.append("; ==== %s  %08X-%08X ====" % (name, f.start_ea, f.end_ea))
    cur = f.start_ea
    while cur < f.end_ea and cur != ida_idaapi.BADADDR:
        lines.append("%08X  %s" % (cur, dis(cur)))
        cur = ida_bytes.next_head(cur, f.end_ea)


def dump_xrefs(ea, lines):
    lines.append("; ==== xrefs TO %08X ====" % ea)
    n = 0
    for xr in idautils.XrefsTo(ea, 0):
        frm = xr.frm
        f = ida_funcs.get_func(frm)
        fn = ida_funcs.get_func_name(f.start_ea) if f else "?"
        lines.append("  %08X  %-26s  %s" % (frm, fn, dis(frm)))
        n += 1
    lines.append("; (%d xrefs)" % n)


def dump_range(lo, hi, lines):
    lines.append("; ==== linear %08X-%08X ====" % (lo, hi))
    cur = lo
    while cur < hi:
        if not ida_bytes.is_code(ida_bytes.get_flags(cur)):
            ida_ua.create_insn(cur)
        lines.append("%08X  %s" % (cur, dis(cur)))
        nh = ida_bytes.next_head(cur, hi)
        cur = nh if nh != ida_idaapi.BADADDR and nh > cur else cur + 1


def main():
    ida_auto.auto_wait()
    is_sub = "SUB" in JOB.upper()
    funcs = parse_eas("BOOT_FUNCS")
    xrefs = parse_eas("BOOT_XREFS")
    ranges = parse_ranges("BOOT_RANGES")
    if funcs is None:
        funcs = SUB_FUNCS if is_sub else MAIN_FUNCS
    if xrefs is None:
        xrefs = SUB_XREFS if is_sub else MAIN_XREFS
    if ranges is None:
        ranges = SUB_RANGES if is_sub else MAIN_RANGES

    lines = ["job %s suffix %s (side=%s)" % (JOB, SUF, "SUB" if is_sub else "MAIN")]
    for ea in funcs:
        dump_func(ea, lines)
        lines.append("")
    for ea in xrefs:
        dump_xrefs(ea, lines)
        lines.append("")
    for lo, hi in ranges:
        dump_range(lo, hi, lines)
        lines.append("")

    with open(os.path.join(OUT, "%s_%s.txt" % (JOB, SUF)), "w",
              encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(lines) + "\n")


try:
    main()
    idc.qexit(0)
except Exception:
    with open(os.path.join(OUT, "%s_%s_TRACEBACK.txt" % (JOB, SUF)), "w",
              encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
    idc.qexit(1)

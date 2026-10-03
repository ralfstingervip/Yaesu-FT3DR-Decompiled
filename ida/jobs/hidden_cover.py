r"""HIDDEN job 2: raise coverage in my own database, then dump reachability.

The inherited databases are far too thin for a reachability verdict: HID_MAIN
started at 39,812 code bytes of ~505 KB content (7.9%), HID_SUB at 39,953 of
4 MB. An "unreferenced function" computed on that is just "not disassembled".
So sweep first, then compute.

Ranges come from the env so the same script serves both images:
  YAESU_IMG    MAIN | SUB
  YAESU_SWEEP  semicolon list of lo-hi hex ranges to linear-sweep

Passes:
  1 linear sweep: create_insn at every undefined byte in range
  2 add_func at every call target, repeated until stable
  3 add_func at every pointer-table target that looks like a prologue
  4 dump functions + xrefs + reachability roots

Writes to ida/out/hidden.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import sys
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_segment
import ida_ua
import ida_xref
import idautils
import idc

OUT = str(_REPO / "ida/out/hidden")
os.makedirs(OUT, exist_ok=True)
JOB = os.environ.get("YAESU_JOB", "HID")
IMG = os.environ.get("YAESU_IMG", "MAIN" if "MAIN" in JOB.upper() else "SUB")
TAG = IMG.lower()

DEFAULT_SWEEP = {
    "MAIN": "0x400-0x80000",
    # DENSE holds every function the earlier pass found; RES holds a handful of
    # code islands that sub-lower classified, and the tail of RES up to DENSE.
    "SUB": "0xFFEE0000-0xFFF50000;0xFFC00000-0xFFC00400;0xFFEC0000-0xFFEE0000",
}

SWEEP = []
for part in os.environ.get("YAESU_SWEEP", DEFAULT_SWEEP[IMG]).split(";"):
    part = part.strip()
    if not part:
        continue
    lo, _, hi = part.partition("-")
    SWEEP.append((int(lo, 16), int(hi, 16)))

LOG = []


def log(msg):
    LOG.append(str(msg))
    sys.stdout.write(str(msg) + "\n")


def w(path, text):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def sweep(start, end):
    made = 0
    ea = start
    while ea < end:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) or (ida_bytes.is_data(fl) and ida_bytes.is_head(fl)):
            n = ida_bytes.get_item_size(ea)
            ea += n if n > 0 else 1
            continue
        n = ida_ua.create_insn(ea)
        if n > 0:
            made += 1
            ea += n
        else:
            ea += 1
    return made


def add_call_targets(start, end):
    made = 0
    ea = start
    while ea < end:
        fl = ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(fl):
            n = ida_bytes.get_item_size(ea)
            ea += n if n > 0 else 1
            continue
        for xr in idautils.XrefsFrom(ea, 0):
            if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                if ida_funcs.get_func(xr.to) is None and ida_bytes.is_code(ida_bytes.get_flags(xr.to)):
                    if ida_funcs.add_func(xr.to):
                        made += 1
        n = ida_bytes.get_item_size(ea)
        ea += n if n > 0 else 1
    return made


def orphan_runs(start, end):
    """Create a function at the head of every code run that no function owns."""
    made = 0
    ea = start
    run_head = None
    while ea < end:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            if run_head is None:
                run_head = ea
            n = ida_bytes.get_item_size(ea)
            ea += n if n > 0 else 1
        else:
            if run_head is not None and ida_funcs.get_func(run_head) is None:
                if ida_funcs.add_func(run_head):
                    made += 1
            run_head = None
            n = ida_bytes.get_item_size(ea)
            ea += n if n > 0 else 1
    if run_head is not None and ida_funcs.get_func(run_head) is None:
        if ida_funcs.add_func(run_head):
            made += 1
    return made


def dump_functions():
    rows = ["ea\tend\tsize\tname\tn_code_to\tn_data_to\tn_call_to\tcallers\tn_calls_from\tn_insn"]
    n = 0
    for ea in idautils.Functions():
        f = ida_funcs.get_func(ea)
        if f is None:
            continue
        n += 1
        code_to = data_to = call_to = 0
        callers = set()
        for xr in idautils.XrefsTo(ea, 0):
            if xr.type == ida_xref.fl_F:
                continue
            if xr.iscode:
                code_to += 1
                if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                    call_to += 1
                pf = ida_funcs.get_func(xr.frm)
                callers.add("0x%08X" % (pf.start_ea if pf else xr.frm))
            else:
                data_to += 1
        calls_from = 0
        ninsn = 0
        for item in idautils.FuncItems(ea):
            ninsn += 1
            for xr in idautils.XrefsFrom(item, 0):
                if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                    calls_from += 1
        rows.append("0x%08X\t0x%08X\t%d\t%s\t%d\t%d\t%d\t%s\t%d\t%d" % (
            f.start_ea, f.end_ea, f.end_ea - f.start_ea,
            ida_funcs.get_func_name(ea), code_to, data_to, call_to,
            ",".join(sorted(callers)[:16]), calls_from, ninsn))
    w("functions_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return n


def dump_xrefs():
    rows = ["frm\tto\tkind\tiscode\tfrm_func\tto_func"]
    n = 0
    kinds = {ida_xref.fl_CF: "call_far", ida_xref.fl_CN: "call_near",
             ida_xref.fl_JF: "jump_far", ida_xref.fl_JN: "jump_near",
             ida_xref.dr_O: "data_offset", ida_xref.dr_W: "data_write",
             ida_xref.dr_R: "data_read", ida_xref.dr_T: "data_text",
             ida_xref.dr_I: "data_info"}
    for seg_ea in idautils.Segments():
        s = ida_segment.getseg(seg_ea)
        ea = s.start_ea
        while ea < s.end_ea:
            for xr in idautils.XrefsFrom(ea, 0):
                if xr.type == ida_xref.fl_F:
                    continue
                n += 1
                ff = ida_funcs.get_func(xr.frm)
                tf = ida_funcs.get_func(xr.to)
                rows.append("0x%08X\t0x%08X\t%s\t%d\t%s\t%s" % (
                    xr.frm, xr.to, kinds.get(xr.type, "t%d" % xr.type),
                    1 if xr.iscode else 0,
                    ("0x%08X" % ff.start_ea) if ff else "",
                    ("0x%08X" % tf.start_ea) if tf else ""))
            nxt = ida_bytes.next_head(ea, s.end_ea)
            if nxt <= ea:
                break
            ea = nxt
    w("xrefs_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return n


def dump_strings():
    rows = ["ea\tlen\ttype\tn_xrefs\txref_frm\ttext"]
    n = 0
    sc = idautils.Strings()
    sc.setup(strtypes=[0, 1, 2, 3, 4, 5, 6, 7])
    sc.refresh()
    for s in sc:
        n += 1
        try:
            txt = str(s)
        except Exception:
            txt = "<undecodable>"
        frms = []
        for xr in idautils.XrefsTo(s.ea, 0):
            frms.append("0x%08X" % xr.frm)
        rows.append("0x%08X\t%d\t%d\t%d\t%s\t%s" % (
            s.ea, s.length, s.strtype, len(frms), ",".join(frms[:12]),
            txt.replace("\t", "\\t").replace("\n", "\\n").replace("\r", "\\r")))
    w("idastrings_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return n


def coverage():
    rows = ["seg\tstart\tend\tcode\tdata\tundef\tpct_code"]
    tot = [0, 0, 0]
    for seg_ea in idautils.Segments():
        s = ida_segment.getseg(seg_ea)
        c = d = u = 0
        ea = s.start_ea
        while ea < s.end_ea:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                c += 1
            elif ida_bytes.is_data(fl):
                d += 1
            else:
                u += 1
            ea += 1
        tot[0] += c
        tot[1] += d
        tot[2] += u
        span = max(1, s.end_ea - s.start_ea)
        rows.append("%s\t0x%08X\t0x%08X\t%d\t%d\t%d\t%.2f%%" % (
            ida_segment.get_segm_name(s), s.start_ea, s.end_ea, c, d, u,
            100.0 * c / span))
    rows.append("TOTAL\t\t\t%d\t%d\t%d\t" % tuple(tot))
    w("coverage_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return tot


def main():
    ida_auto.auto_wait()
    for lo, hi in SWEEP:
        log("sweep 0x%08X-0x%08X insns=%d" % (lo, hi, sweep(lo, hi)))
        ida_auto.auto_wait()
    for rnd in range(4):
        made = 0
        for lo, hi in SWEEP:
            made += add_call_targets(lo, hi)
        ida_auto.auto_wait()
        log("call-target round %d added %d" % (rnd, made))
        if made == 0:
            break
    made = 0
    for lo, hi in SWEEP:
        made += orphan_runs(lo, hi)
    ida_auto.auto_wait()
    log("orphan-run functions added %d" % made)
    for rnd in range(3):
        m2 = 0
        for lo, hi in SWEEP:
            m2 += add_call_targets(lo, hi)
        ida_auto.auto_wait()
        log("call-target round B%d added %d" % (rnd, m2))
        if m2 == 0:
            break
    log("functions=%d" % dump_functions())
    log("xrefs=%d" % dump_xrefs())
    log("idastrings=%d" % dump_strings())
    log("coverage=%r" % (coverage(),))


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    w("job2_log_%s.txt" % TAG, "\n".join(LOG) + "\n")
    idc.qexit(0)

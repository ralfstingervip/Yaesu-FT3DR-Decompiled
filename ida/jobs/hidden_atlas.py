r"""HIDDEN job 1: baseline atlas dump for the string / reachability audit.

Runs against a database seeded with --copy-from ida\db\radio\MAIN.i64 or
ida\db\radio\SUB.i64. Does not sweep or force-recover; that is job 2. This pass
records exactly what the inherited database knows so the reachability numbers
have a stated baseline:

  functions.tsv   every function, size, code-xref-to count, data-xref-to count
  xrefs.tsv       every xref in the database
  idastrings.tsv  IDA's own string list
  segments.tsv    segment map
  names.tsv       every named address

Env: YAESU_IMG = MAIN | SUB (defaults from YAESU_JOB).
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
import ida_nalt
import ida_name
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

LOG = []


def log(msg):
    LOG.append(str(msg))


def w(path, text):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


XREF_KIND = {
    ida_xref.fl_CF: "call_far",
    ida_xref.fl_CN: "call_near",
    ida_xref.fl_JF: "jump_far",
    ida_xref.fl_JN: "jump_near",
    ida_xref.fl_F: "flow",
    ida_xref.dr_O: "data_offset",
    ida_xref.dr_W: "data_write",
    ida_xref.dr_R: "data_read",
    ida_xref.dr_T: "data_text",
    ida_xref.dr_I: "data_informational",
}


def kind(t):
    return XREF_KIND.get(t, "t%d" % t)


def dump_segments():
    rows = ["name\tstart\tend\tsize\tclass\tperm"]
    for ea in idautils.Segments():
        s = ida_segment.getseg(ea)
        rows.append("%s\t0x%08X\t0x%08X\t0x%X\t%s\t%d" % (
            ida_segment.get_segm_name(s), s.start_ea, s.end_ea,
            s.end_ea - s.start_ea, ida_segment.get_segm_class(s) or "", s.perm))
    w("segments_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return len(rows) - 1


def dump_functions():
    rows = ["ea\tend\tsize\tname\tflags\tn_code_to\tn_data_to\tn_call_to\tcallers\tn_calls_from"]
    n = 0
    for ea in idautils.Functions():
        f = ida_funcs.get_func(ea)
        if f is None:
            continue
        n += 1
        code_to = 0
        data_to = 0
        call_to = 0
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
        for item in idautils.FuncItems(ea):
            for xr in idautils.XrefsFrom(item, 0):
                if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                    calls_from += 1
        rows.append("0x%08X\t0x%08X\t%d\t%s\t0x%X\t%d\t%d\t%d\t%s\t%d" % (
            f.start_ea, f.end_ea, f.end_ea - f.start_ea,
            ida_funcs.get_func_name(ea), f.flags, code_to, data_to, call_to,
            ",".join(sorted(callers)[:12]), calls_from))
    w("functions_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return n


def dump_xrefs():
    rows = ["frm\tto\tkind\tiscode\tfrm_func\tto_func"]
    n = 0
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
                    xr.frm, xr.to, kind(xr.type), 1 if xr.iscode else 0,
                    ("0x%08X" % ff.start_ea) if ff else "",
                    ("0x%08X" % tf.start_ea) if tf else ""))
            nxt = ida_bytes.next_head(ea, s.end_ea)
            if nxt <= ea:
                break
            ea = nxt
    w("xrefs_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return n


def dump_idastrings():
    rows = ["ea\tlen\ttype\ttext\tn_xrefs"]
    n = 0
    try:
        sc = idautils.Strings()
        sc.setup(strtypes=[0, 1, 2, 3, 4, 5, 6, 7])
        sc.refresh()
        for s in sc:
            n += 1
            try:
                txt = str(s)
            except Exception:
                txt = "<undecodable>"
            nx = sum(1 for _ in idautils.XrefsTo(s.ea, 0))
            rows.append("0x%08X\t%d\t%d\t%s\t%d" % (
                s.ea, s.length, s.strtype,
                txt.replace("\t", "\\t").replace("\n", "\\n"), nx))
    except Exception as exc:
        log("idastrings failed: %r" % (exc,))
    w("idastrings_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return n


def dump_names():
    rows = ["ea\tname\tis_func\tis_code"]
    n = 0
    for ea, nm in idautils.Names():
        n += 1
        fl = ida_bytes.get_flags(ea)
        rows.append("0x%08X\t%s\t%d\t%d" % (
            ea, nm, 1 if ida_funcs.get_func(ea) else 0,
            1 if ida_bytes.is_code(fl) else 0))
    w("names_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return n


def coverage():
    """Byte-level code/data/undefined census per segment."""
    rows = ["seg\tstart\tend\tcode\tdata\tundef\tunexplored"]
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
        rows.append("%s\t0x%08X\t0x%08X\t%d\t%d\t%d\t%.2f%%" % (
            ida_segment.get_segm_name(s), s.start_ea, s.end_ea, c, d, u,
            100.0 * u / max(1, s.end_ea - s.start_ea)))
    rows.append("TOTAL\t\t\t%d\t%d\t%d\t" % tuple(tot))
    w("coverage_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return tot


def main():
    ida_auto.auto_wait()
    log("job=%s img=%s" % (JOB, IMG))
    log("min_ea=0x%08X max_ea=0x%08X" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
    log("segments=%d" % dump_segments())
    log("functions=%d" % dump_functions())
    log("xrefs=%d" % dump_xrefs())
    log("idastrings=%d" % dump_idastrings())
    log("names=%d" % dump_names())
    log("coverage code/data/undef=%r" % (coverage(),))


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    w("job1_log_%s.txt" % TAG, "\n".join(LOG) + "\n")
    idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane J9. UPWARD caller trace for DSP TX/session entry points, plus field
decode of opcode 11/12/32 builders. Read-only. MAIN image, H8S, base 0.
Seeded from MAIN_FINAL2. No image modified, no device touched."""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_funcs, ida_xref, idc, idautils, ida_bytes, ida_name

ROOT = str(_REPO)
OUTD = os.path.join(ROOT, "ida", "out", "dsp-tx-src")
TB = os.path.join(OUTD, "j9_tb.txt")


def fname(ea):
    f = ida_funcs.get_func(ea)
    if not f:
        return "", idc.BADADDR
    nm = ida_funcs.get_func_name(f.start_ea) or ""
    return nm, f.start_ea


def crefs_to(ea):
    out = []
    xr = ida_xref.xrefblk_t()
    ok = xr.first_to(ea, ida_xref.XREF_ALL)
    while ok:
        if xr.iscode:
            out.append((xr.frm, xr.type))
        ok = xr.next_to()
    return out


def disasm_range(lo, hi):
    lines = []
    ea = lo
    while ea < hi and ea != idc.BADADDR:
        d = idc.generate_disasm_line(ea, 0) or ""
        sz = idc.get_item_size(ea)
        raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
        hexs = " ".join("%02x" % b for b in raw)
        lines.append("%06X  %-24s  %s" % (ea, hexs, d))
        n = idc.next_head(ea, hi)
        if n <= ea:
            break
        ea = n
    return lines


# ---- Thread 1: upward caller trace -------------------------------------
# Session / request entry points (leaves) we trace UPWARD from.
ENTRY = {
    0x05A1BE: "dsp_request TX (B0BE=2/0B/10)",
    0x05A28A: "dsp_request data-FR (B0BE=0x0A)",
    0x05A2F8: "dsp_request 1C03 (B0BE=0x15)",
    0x06CF30: "set B0BE=0x16 host-link data (after 05A1BE)",
    0x06D052: "set B0BE=0x17 auto data reply (after 05A28A)",
    0x0349E8: "start short-TX BB94 (FF89BB!=0)",
    0x019954: "set B0C9.b7 header resend",
    0x019962: "set B0C9.b7 header resend (alt)",
    0x05B208: "set B0AF/B0AE ID-list push",
}

# Mid routines already named by I13 (TX start dispatcher region) -- also traced.
MID = {
    0x035872: "TX-start dispatcher",
    0x03596A: "-> 05A1BE call site",
    0x035EEE: "-> 05A1BE call site 2",
    0x0359A8: "-> 05A28A (AAD4.b0)",
    0x035F28: "-> 05A28A call site 2",
    0x0359C8: "-> 05A2F8 (B0CC.b0)",
    0x035F48: "-> 05A2F8 call site 2",
    0x05F73A: "-> 05A28A call site 3",
    0x062DB2: "-> 06D052 message engine",
    0x01115C: "-> 06CF30 site",
    0x01159C: "-> 06CF30 site 2",
}


def trace_up():
    out = []
    seen_funcs = set()
    # Build a worklist of (ea, label, depth, chain). Recurse up to depth 4.
    work = []
    for ea, lab in ENTRY.items():
        work.append((ea, lab, 0, []))
    results = []
    MAXDEPTH = 5
    while work:
        ea, lab, depth, chain = work.pop()
        nm, fstart = fname(ea)
        key = (fstart, depth)
        # record callers of the containing function start
        callers = crefs_to(fstart) if fstart != idc.BADADDR else []
        # also direct crefs to ea itself (in case not a func start)
        direct = crefs_to(ea)
        results.append({
            "target": ea, "label": lab, "func": nm, "fstart": fstart,
            "depth": depth, "chain": list(chain),
            "callers": callers, "direct": direct,
        })
        if depth >= MAXDEPTH or fstart == idc.BADADDR:
            continue
        if fstart in seen_funcs:
            continue
        seen_funcs.add(fstart)
        for (frm, typ) in callers:
            cnm, cstart = fname(frm)
            work.append((frm, "caller of %s" % (nm or ("%06X" % fstart)),
                         depth + 1, chain + [("%06X" % ea)]))
    return results


# ---- Thread 2: opcode builder disassembly ------------------------------
BUILDERS = {
    "op11_05905E": (0x05905E, 0x0590F0),
    "op12_059234": (0x059234, 0x0592E0),  # 059234/8/C/059240 share tail
    "op32_05EB4E": (0x05EB4E, 0x05EBD2),
    "op31_05EAEE": (0x05EAEE, 0x05EB4E),
    "frame_finish_058FA2": (0x058FA2, 0x058FE0),
    # init-step handlers that invoke 11/12/32
    "init_step0_05AFCA": (0x05AFCA, 0x05AFF8),
    "init_step2_05AFF8": (0x05AFF8, 0x05B01E),
    "req_12_05B210": (0x05B210, 0x05B254),
    "req_12_05B254": (0x05B254, 0x05B28C),
    "req_32_05B2D8": (0x05B2D8, 0x05B310),
    # setter of B0CE.b3 (32 resend request)
    "setB0CE_b3_01782E": (0x017820, 0x017860),
}


def dump_builders():
    out = []
    for nm, (lo, hi) in BUILDERS.items():
        out.append("### %s  (%06X-%06X)" % (nm, lo, hi))
        out.extend(disasm_range(lo, hi))
        out.append("")
    return out


def main():
    ida_auto.auto_wait()
    # Thread 1
    res = trace_up()
    with open(os.path.join(OUTD, "caller-trace.txt"), "w",
              encoding="utf-8", newline="\n") as h:
        for r in res:
            h.write("TARGET %06X  depth=%d  [%s]\n" % (
                r["target"], r["depth"], r["label"]))
            h.write("  func=%s start=%06X chain=%s\n" % (
                r["func"], (r["fstart"] if r["fstart"] != idc.BADADDR else 0),
                "->".join(r["chain"])))
            h.write("  direct_crefs=%s\n" % ", ".join(
                "%06X(t%d)" % (f, t) for f, t in r["direct"]))
            h.write("  callers_of_func=%s\n" % ", ".join(
                "%06X(t%d)" % (f, t) for f, t in r["callers"]))
            h.write("\n")

    # TSV: edge list (caller_ea -> target func), with caller func name
    with open(os.path.join(OUTD, "caller-edges.tsv"), "w",
              encoding="utf-8", newline="\n") as h:
        h.write("target_ea\ttarget_label\ttarget_func\tcaller_ea\tcaller_func\tcaller_func_start\txtype\n")
        emitted = set()
        for r in res:
            for (frm, typ) in r["callers"]:
                cnm, cstart = fname(frm)
                row = (r["fstart"], frm)
                if row in emitted:
                    continue
                emitted.add(row)
                h.write("%06X\t%s\t%s\t%06X\t%s\t%06X\t%d\n" % (
                    r["fstart"] if r["fstart"] != idc.BADADDR else 0,
                    r["label"], r["func"], frm, cnm,
                    cstart if cstart != idc.BADADDR else 0, typ))

    # Thread 2
    with open(os.path.join(OUTD, "opcode-builders.txt"), "w",
              encoding="utf-8", newline="\n") as h:
        h.write("\n".join(dump_builders()))

    # Also dump the TX-start dispatcher and its callers' context
    with open(os.path.join(OUTD, "txstart-context.txt"), "w",
              encoding="utf-8", newline="\n") as h:
        for lo, hi, lab in [
            (0x035872, 0x035A60, "TX-start dispatcher 035872"),
            (0x035EE0, 0x035F70, "TX region 035EE0"),
            (0x06CF20, 0x06CF80, "06CF30 B0BE=0x16 setter"),
            (0x06D040, 0x06D0A0, "06D052 B0BE=0x17 setter"),
            (0x0349C0, 0x034A20, "0349E8 BB94 short TX start"),
            (0x019940, 0x019980, "019954/019962 B0C9.b7"),
            (0x05A1BE, 0x05A2F8, "05A1BE/28A dsp_request bodies"),
        ]:
            h.write("### %s\n" % lab)
            h.write("\n".join(disasm_range(lo, hi)))
            h.write("\n\n")


try:
    main()
except Exception:
    with open(TB, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

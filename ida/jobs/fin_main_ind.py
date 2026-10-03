# -*- coding: utf-8 -*-
r"""Lane F1 (FIN_MAIN_IND): verify the 638 kept-but-unproven MAIN functions.
Seeded from MAIN_FULL. For every rejected function start it:
  - confirms is_code / is_func at the start,
  - decodes the whole extent [start,end) and checks the decode is clean,
  - records the first 4 instructions (prologue evidence) and any rts/rte,
  - lists call targets (bsr/jsr) and distinct absolute 0xFFxxxx operands.
Pure read; writes a TSV. H8S advanced, big-endian, base 0.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

import ida_auto, ida_bytes, ida_funcs, ida_ua, idc, idautils
import ida_xref

ROOT = str(_REPO)
IN_TSV = os.path.join(ROOT, "ida", "out", "main-indirect", "_rejects_in.tsv")
OUTDIR = os.path.join(ROOT, "ida", "out", "main-indirect")
os.makedirs(OUTDIR, exist_ok=True)
OUT_TSV = os.path.join(OUTDIR, "verify.tsv")
LOG = os.path.join(OUTDIR, "verify_log.txt")
TB = os.path.join(OUTDIR, "verify_traceback.txt")


def mnem(ea):
    return (idc.print_insn_mnem(ea) or "").lower()


def op_str(ea, n):
    return idc.print_operand(ea, n) or ""


def load_table_spans():
    spans = []
    p = os.path.join(ROOT, "ida", "out", "main-full", "jumptables.tsv")
    try:
        with open(p, encoding="utf-8") as h:
            next(h)
            for line in h:
                x = line.rstrip("\n").split("\t")
                if len(x) >= 2 and x[0] and not x[0].startswith("#"):
                    b = int(x[0], 16); n = int(x[1])
                    spans.append((b, b + 4 * n))
    except Exception:
        pass
    return spans


def in_spans(a, spans):
    for lo, hi in spans:
        if lo <= a < hi:
            return lo
    return None


def main():
    ida_auto.auto_wait()
    table_spans = load_table_spans()
    rejects = []
    with open(IN_TSV, encoding="utf-8") as h:
        next(h)
        for line in h:
            p = line.rstrip("\n").split("\t")
            if len(p) >= 2 and p[0] and not p[0].startswith("#"):
                rejects.append((int(p[0], 16), int(p[1], 16)))

    rows = []
    for start, end in rejects:
        fl = ida_bytes.get_flags(start)
        iscode = 1 if ida_bytes.is_code(fl) else 0
        f = ida_funcs.get_func(start)
        isfunc = 1 if (f and f.start_ea == start) else 0
        f_end = f.end_ea if f else end

        # decode the extent
        ea = start
        ninsn = 0
        ndata = 0
        clean = 1
        first4 = []
        nret = 0
        nind = 0
        tblrefs = []
        last_mnem = ""
        last_ea = start
        callees = []
        absrefs = []
        guard = 0
        limit = max(end, f_end)
        while ea < limit and guard < 4000:
            guard += 1
            flg = ida_bytes.get_flags(ea)
            if not ida_bytes.is_code(flg):
                ndata += 1
                nxt = ida_bytes.next_head(ea, limit)
                ea = nxt if nxt > ea else ea + 1
                continue
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, ea)
            if ln <= 0:
                clean = 0
                break
            m = mnem(ea)
            if ninsn < 4:
                o0 = op_str(ea, 0); o1 = op_str(ea, 1)
                first4.append((m + " " + o0 + ("," + o1 if o1 else "")).strip())
            ninsn += 1
            if m in ("rts", "rte"):
                nret += 1
            # indirect dispatch: jsr/jmp @erN (register-indirect)
            if m in ("jsr", "jmp"):
                o0 = op_str(ea, 0)
                if "@er" in o0 or "@sp" in o0 or ("@" in o0 and "er" in o0.lower()):
                    if ":" not in o0.replace("@er", ""):  # @erN, not @addr:24
                        nind += 1
            if m in ("jsr", "bsr"):
                for xr in idautils.CodeRefsFrom(ea, 0):
                    callees.append(xr)
            # memory / displacement operands: 0xFFxxxx (I/O+RAM) and jump-table refs
            for k in range(3):
                op = insn.ops[k]
                if op.type in (ida_ua.o_mem, ida_ua.o_displ):
                    a = op.addr
                    if a >= 0xFF0000:
                        absrefs.append(a)
                    elif 0x400 <= a < 0x07B754:
                        b = in_spans(a, table_spans)
                        if b is not None:
                            tblrefs.append(b)
            last_mnem = m
            last_ea = ea
            ea += ln

        # last instruction control class
        lm = last_mnem
        ends_ctrl = lm in ("rts", "rte", "jmp", "bra", "rte", "rtel")
        prologue = 0
        pkind = ""
        for s in first4[:3]:
            sl = s.lower()
            if sl.startswith("push") or sl.startswith("stm"):
                prologue = 1; pkind = "regsave"; break
            if sl.startswith("mov") and ("@-er7" in sl or "@-sp" in sl):
                prologue = 1; pkind = "push(mov@-sp)"; break
            if (sl.startswith("sub") or sl.startswith("add")) and ("sp" in sl or "er7" in sl):
                prologue = 1; pkind = "frame"; break
        # distinct
        callees = sorted(set(c for c in callees if c))
        absd = []
        for a in absrefs:
            if a not in absd:
                absd.append(a)

        tbld = []
        for b in tblrefs:
            if b not in tbld:
                tbld.append(b)
        rows.append(dict(
            start=start, end=end, isfunc=isfunc, iscode=iscode, ninsn=ninsn,
            ndata=ndata, clean=clean, prologue=prologue, pkind=pkind, nret=nret,
            nind=nind, tblrefs=tbld,
            last_mnem=lm, ends_ctrl=1 if ends_ctrl else 0,
            ncall=len(callees), callees=callees, nabs=len(absd), absrefs=absd,
            first4=" | ".join(first4)))

    with open(OUT_TSV, "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tisfunc\tiscode\tninsn\tndata\tclean\tprologue\tpkind\t"
                "nret\tnind\ttblrefs\tlast_mnem\tends_ctrl\tncall\tcallees\tnabs\tabsrefs\tfirst4\n")
        for r in rows:
            h.write("%06X\t%06X\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%d\t%s\t%s\t%d\t%d\t%s\t%d\t%s\t%s\n" % (
                r["start"], r["end"], r["isfunc"], r["iscode"], r["ninsn"],
                r["ndata"], r["clean"], r["prologue"], r["pkind"], r["nret"],
                r["nind"], ",".join("%06X" % b for b in r["tblrefs"][:4]),
                r["last_mnem"], r["ends_ctrl"], r["ncall"],
                ",".join("%06X" % c for c in r["callees"][:8]),
                r["nabs"], ",".join("%06X" % a for a in r["absrefs"][:10]),
                r["first4"].replace("\t", " ")))

    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write("rejects processed: %d\n" % len(rows))
        h.write("isfunc=1: %d\n" % sum(r["isfunc"] for r in rows))
        h.write("iscode=1: %d\n" % sum(r["iscode"] for r in rows))
        h.write("clean decode: %d\n" % sum(r["clean"] for r in rows))
        h.write("has rts/rte: %d\n" % sum(1 for r in rows if r["nret"] > 0))
        h.write("has prologue: %d\n" % sum(r["prologue"] for r in rows))
        h.write("ends ctrl-xfer: %d\n" % sum(r["ends_ctrl"] for r in rows))
        h.write("has embedded data (ndata>0): %d\n" % sum(1 for r in rows if r["ndata"] > 0))
        h.write("ret OR tail-ctrl: %d\n" % sum(1 for r in rows if r["nret"] > 0 or r["ends_ctrl"]))
        h.write("has indirect jsr/jmp @reg (nind>0): %d\n" % sum(1 for r in rows if r["nind"] > 0))
        h.write("references a jump-table (tblrefs): %d\n" % sum(1 for r in rows if r["tblrefs"]))


try:
    main()
except Exception:
    with open(TB, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

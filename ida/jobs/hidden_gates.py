r"""HIDDEN job 4: full listings of the gated routines, caller chains, and a
coherence-filtered orphan census.

Two jobs so far produced 792 MAIN / 318 SUB "orphans", but most are data that the
linear sweep decoded as instructions: the top SUB orphan starts 00 38 00 39 00 3A
which is a 16-bit table, and MAIN rank 3 starts with 20 20 20 20. So this pass
scores every candidate:

  ends_ret     last instruction is a return
  frac_insn    bytes IDA decoded as instructions, not .byte
  n_mnem       distinct mnemonics
  ascii_frac   bytes that are printable ASCII (high => it is text)
  zero_frac    bytes that are 0x00 (high => it is a table)
  verdict      code | suspect_data

Inputs:
  _funcdump_<img>.txt   "0xADDR<TAB>label"  full function listings, with callers
Outputs:
  funcdump_<img>.txt    listings
  orphans_<img>.tsv     rewritten with the coherence columns
  callchain_<img>.txt   callers of callers for each requested address
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

# regions that really hold code, for the orphan census. Everything else is
# graphics / kanji / font data that the sweep touched.
CODE_REGIONS = {
    "MAIN": [(0x00000400, 0x00080000)],
    "SUB": [(0xFFEE0000, 0xFFF50000)],
}[IMG]

RET_MNEM = {"MAIN": ("rts", "rte", "rtsd"), "SUB": ("rts", "rtsd", "rte", "rtfi")}[IMG]

LOG = []


def log(msg):
    LOG.append(str(msg))
    sys.stdout.write(str(msg) + "\n")


def w(path, text):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def rd(path):
    p = os.path.join(OUT, path)
    if not os.path.isfile(p):
        return []
    with open(p, "r", encoding="utf-8") as f:
        return [ln.rstrip("\n") for ln in f]


def in_code_region(ea):
    return any(lo <= ea < hi for lo, hi in CODE_REGIONS)


# ---------------------------------------------------------------- coherence

def score(ea, end):
    n = end - ea
    if n <= 0:
        return None
    blob = ida_bytes.get_bytes(ea, n) or b""
    ascii_n = sum(1 for b in blob if 0x20 <= b < 0x7F)
    zero_n = blob.count(0)
    insn_bytes = 0
    mnems = set()
    last = None
    cur = ea
    guard = 0
    while cur < end and guard < 20000:
        fl = ida_bytes.get_flags(cur)
        sz = ida_bytes.get_item_size(cur)
        if sz <= 0:
            sz = 1
        if ida_bytes.is_code(fl):
            insn_bytes += sz
            m = idc.print_insn_mnem(cur)
            if m:
                mnems.add(m)
                last = m
        cur += sz
        guard += 1
    return dict(
        n=n,
        ends_ret=1 if (last in RET_MNEM) else 0,
        frac_insn=insn_bytes / float(n),
        n_mnem=len(mnems),
        ascii_frac=ascii_n / float(n),
        zero_frac=zero_n / float(n),
        last=last or "",
    )


def verdict(s):
    if s is None:
        return "empty"
    if s["ascii_frac"] > 0.70:
        return "suspect_text"
    if s["zero_frac"] > 0.45:
        return "suspect_table"
    if s["frac_insn"] < 0.90:
        return "suspect_data"
    if s["n_mnem"] < 4:
        return "suspect_table"
    if not s["ends_ret"]:
        return "code_no_return"
    return "code"


# ---------------------------------------------------------------- listings

def full_listing(ea, label):
    out = []
    f = ida_funcs.get_func(ea)
    out.append("=" * 78)
    if f is None:
        out.append("ADDR 0x%08X  %s   (no function here)" % (ea, label))
        out.append("=" * 78)
        cur = ea
        for _ in range(60):
            sz = ida_bytes.get_item_size(cur) or 1
            raw = " ".join("%02X" % b for b in (ida_bytes.get_bytes(cur, min(sz, 8)) or b""))
            out.append("  %08X  %-24s %s" % (cur, raw, idc.generate_disasm_line(cur, 0) or ""))
            cur += sz
        out.append("")
        return out
    out.append("FUNC %s  0x%08X-0x%08X  %d bytes   %s" % (
        ida_funcs.get_func_name(f.start_ea), f.start_ea, f.end_ea,
        f.end_ea - f.start_ea, label))
    callers = []
    for x in idautils.XrefsTo(f.start_ea, 0):
        if x.type == ida_xref.fl_F:
            continue
        cf = ida_funcs.get_func(x.frm)
        callers.append("0x%08X%s%s" % (
            x.frm, "(%s)" % ida_funcs.get_func_name(cf.start_ea) if cf else "",
            "" if x.iscode else "[data]"))
    out.append("  callers/refs: %s" % (", ".join(callers) if callers else "NONE"))
    s = score(f.start_ea, f.end_ea)
    out.append("  coherence: %s  frac_insn=%.2f n_mnem=%d ascii=%.2f zero=%.2f last=%s"
               % (verdict(s), s["frac_insn"], s["n_mnem"], s["ascii_frac"],
                  s["zero_frac"], s["last"]))
    out.append("=" * 78)
    cur = f.start_ea
    guard = 0
    while cur < f.end_ea and guard < 4000:
        sz = ida_bytes.get_item_size(cur) or 1
        raw = " ".join("%02X" % b for b in (ida_bytes.get_bytes(cur, min(sz, 8)) or b""))
        cmt = idc.get_cmt(cur, 0) or ""
        out.append("  %08X  %-22s %-46s %s" % (
            cur, raw, idc.generate_disasm_line(cur, 0) or "", cmt))
        cur += sz
        guard += 1
    out.append("")
    return out


def do_funcdump():
    reqs = []
    for ln in rd("_funcdump_%s.txt" % TAG):
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        p = ln.split("\t")
        try:
            reqs.append((int(p[0], 16), p[1] if len(p) > 1 else ""))
        except ValueError:
            continue
    out = []
    for ea, label in reqs:
        out.extend(full_listing(ea, label))
    w("funcdump_%s.txt" % TAG, "\n".join(out) + "\n")
    return len(reqs)


def do_callchain():
    """Walk callers up to 4 levels for each requested address."""
    reqs = []
    for ln in rd("_funcdump_%s.txt" % TAG):
        p = ln.strip().split("\t")
        try:
            reqs.append((int(p[0], 16), p[1] if len(p) > 1 else ""))
        except (ValueError, IndexError):
            continue
    out = []
    for ea, label in reqs:
        f = ida_funcs.get_func(ea)
        if f is None:
            continue
        out.append("#" * 70)
        out.append("CALLCHAIN for %s 0x%08X  %s" % (
            ida_funcs.get_func_name(f.start_ea), f.start_ea, label))
        level = {f.start_ea}
        seen = {f.start_ea}
        for depth in range(1, 5):
            nxt = set()
            for cur in level:
                for x in idautils.XrefsTo(cur, 0):
                    if x.type == ida_xref.fl_F:
                        continue
                    cf = ida_funcs.get_func(x.frm)
                    tgt = cf.start_ea if cf else None
                    tag = "%s%s" % ("code" if x.iscode else "DATA",
                                    "" if cf else " (loose 0x%08X)" % x.frm)
                    out.append("  L%d  %s <- 0x%08X %s %s" % (
                        depth, ida_funcs.get_func_name(cur), x.frm, tag,
                        ida_funcs.get_func_name(tgt) if tgt else ""))
                    if tgt and tgt not in seen:
                        seen.add(tgt)
                        nxt.add(tgt)
            if not nxt:
                out.append("  L%d  no further callers" % depth)
                break
            level = nxt
        out.append("")
    w("callchain_%s.txt" % TAG, "\n".join(out) + "\n")
    return len(reqs)


# ---------------------------------------------------------------- orphans

def do_orphans():
    funcs = {}
    for ea in idautils.Functions():
        f = ida_funcs.get_func(ea)
        if f:
            funcs[f.start_ea] = f
    # data-pointer targets, coverage independent
    ptr = set()
    for seg_ea in idautils.Segments():
        s = ida_segment.getseg(seg_ea)
        ea = s.start_ea
        while ea < s.end_ea - 3:
            v = ida_bytes.get_dword(ea)
            if IMG == "MAIN":
                v &= 0x00FFFFFF
            if v in funcs:
                ptr.add(v)
            ea += 1
    rows = ["ea\tsize\tname\tregion\tn_code_to\tn_data_to\tis_ptr_target\t"
            "frac_insn\tn_mnem\tascii_frac\tzero_frac\tends_ret\tlast\tverdict\tfirst16"]
    cand = []
    for ea in sorted(funcs):
        f = funcs[ea]
        ncode = nd = 0
        for x in idautils.XrefsTo(ea, 0):
            if x.type == ida_xref.fl_F:
                continue
            if x.iscode:
                ncode += 1
            else:
                nd += 1
        if ncode or nd or ea in ptr:
            continue
        s = score(f.start_ea, f.end_ea)
        v = verdict(s)
        b = ida_bytes.get_bytes(ea, 16) or b""
        cand.append((f.end_ea - f.start_ea, ea, s, v, b, ncode, nd))
    cand.sort(reverse=True, key=lambda r: r[0])
    ncode_true = 0
    for size, ea, s, v, b, nc, nd in cand:
        if v == "code":
            ncode_true += 1
        rows.append("0x%08X\t%d\t%s\t%s\t%d\t%d\t%d\t%.3f\t%d\t%.3f\t%.3f\t%d\t%s\t%s\t%s" % (
            ea, size, ida_funcs.get_func_name(ea),
            "code" if in_code_region(ea) else "data_region", nc, nd,
            1 if ea in ptr else 0, s["frac_insn"], s["n_mnem"], s["ascii_frac"],
            s["zero_frac"], s["ends_ret"], s["last"], v,
            " ".join("%02X" % x for x in b)))
    w("orphans_%s.tsv" % TAG, "\n".join(rows) + "\n")
    log("orphan candidates %d, verdict=code %d, in code region %d" % (
        len(cand), ncode_true, sum(1 for c in cand if in_code_region(c[1]))))
    return len(cand)


def main():
    ida_auto.auto_wait()
    log("job4 img=%s" % IMG)
    log("funcdump %d" % do_funcdump())
    log("callchain %d" % do_callchain())
    log("orphans %d" % do_orphans())


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    w("job4_log_%s.txt" % TAG, "\n".join(LOG) + "\n")
    idc.qexit(0)

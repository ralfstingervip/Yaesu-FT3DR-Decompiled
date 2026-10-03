r"""HIDDEN job 5: the service-mode dispatcher, its seven screens, and every site
that touches the mode byte.

sub_FFF0D6D9 at 0xFFF0D6D9 switches on *(uint8*)(0x00008C4D + 1) and calls a
different full-screen routine for each of seven values, one of which draws
"---DSP WRITE MODE----". The question this pass answers is what writes that byte.

Pass A: every instruction anywhere in the database whose text mentions the
        settings base 8C4D or the mode byte 8C4E, with the following 4
        instructions so a "mov.l #8C4Dh, rN ; mov.b #k, 1[rN]" store is visible.
Pass B: full listings for the addresses in _funcdump_<img>.txt.

Writes to ida/out/hidden.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import re
import sys
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_segment
import idautils
import idc

OUT = str(_REPO / "ida/out/hidden")
os.makedirs(OUT, exist_ok=True)
JOB = os.environ.get("YAESU_JOB", "HID")
IMG = os.environ.get("YAESU_IMG", "MAIN" if "MAIN" in JOB.upper() else "SUB")
TAG = IMG.lower()

# hex tokens to hunt for in the operand text
NEEDLES = [t.strip() for t in os.environ.get(
    "YAESU_NEEDLES", "8C4Dh,8C4Eh,8C53h,8E4Dh,8F72h").split(",") if t.strip()]

LOG = []


def log(m):
    LOG.append(str(m))
    sys.stdout.write(str(m) + "\n")


def w(p, t):
    with open(os.path.join(OUT, p), "w", encoding="utf-8", newline="\n") as f:
        f.write(t)


def rd(p):
    fp = os.path.join(OUT, p)
    if not os.path.isfile(fp):
        return []
    with open(fp, encoding="utf-8") as f:
        return [ln.rstrip("\n") for ln in f]


def line(ea):
    return idc.generate_disasm_line(ea, 0) or ""


def pass_a():
    rows = ["ea\tfunc\tmnem\tinsn\tnext1\tnext2\tnext3\tnext4\tneedle"]
    hits = 0
    for seg_ea in idautils.Segments():
        s = ida_segment.getseg(seg_ea)
        ea = s.start_ea
        while ea < s.end_ea:
            fl = ida_bytes.get_flags(ea)
            sz = ida_bytes.get_item_size(ea) or 1
            if ida_bytes.is_code(fl):
                txt = line(ea)
                found = None
                for nd in NEEDLES:
                    if nd in txt:
                        found = nd
                        break
                if found:
                    hits += 1
                    nxt = []
                    cur = ea + sz
                    for _ in range(4):
                        nxt.append(line(cur).replace("\t", " "))
                        cur += ida_bytes.get_item_size(cur) or 1
                    f = ida_funcs.get_func(ea)
                    rows.append("0x%08X\t%s\t%s\t%s\t%s\t%s" % (
                        ea, ida_funcs.get_func_name(f.start_ea) if f else "",
                        idc.print_insn_mnem(ea) or "", txt.replace("\t", " "),
                        "\t".join(nxt), found))
            ea += sz
    w("modebyte_%s.tsv" % TAG, "\n".join(rows) + "\n")
    log("pass A needle hits %d" % hits)
    return hits


def full_listing(ea, label):
    out = ["=" * 78]
    f = ida_funcs.get_func(ea)
    if f is None:
        out.append("ADDR 0x%08X  %s  (not a function start)" % (ea, label))
        out.append("=" * 78)
        cur = ea
        for _ in range(90):
            sz = ida_bytes.get_item_size(cur) or 1
            out.append("  %08X  %-22s %s" % (
                cur, " ".join("%02X" % b for b in (ida_bytes.get_bytes(cur, min(sz, 8)) or b"")),
                line(cur)))
            cur += sz
        out.append("")
        return out
    out.append("FUNC %s  0x%08X-0x%08X  %d bytes  %s" % (
        ida_funcs.get_func_name(f.start_ea), f.start_ea, f.end_ea,
        f.end_ea - f.start_ea, label))
    refs = []
    for x in idautils.XrefsTo(f.start_ea, 0):
        if x.type == 21:
            continue
        cf = ida_funcs.get_func(x.frm)
        refs.append("0x%08X%s%s" % (x.frm,
                                    "(%s)" % ida_funcs.get_func_name(cf.start_ea) if cf else "",
                                    "" if x.iscode else "[data]"))
    out.append("  callers/refs: %s" % (", ".join(refs) if refs else "NONE"))
    # strings this function references
    strs = []
    for item in idautils.FuncItems(f.start_ea):
        t = line(item)
        m = re.search(r';\s*"(.*)"', t)
        if m:
            strs.append(m.group(1)[:60])
    if strs:
        out.append("  strings: %s" % " | ".join(strs[:24]))
    out.append("=" * 78)
    cur = f.start_ea
    guard = 0
    while cur < f.end_ea and guard < 3000:
        sz = ida_bytes.get_item_size(cur) or 1
        out.append("  %08X  %-22s %s" % (
            cur, " ".join("%02X" % b for b in (ida_bytes.get_bytes(cur, min(sz, 8)) or b"")),
            line(cur)))
        cur += sz
        guard += 1
    out.append("")
    return out


def pass_b():
    out = []
    n = 0
    for ln in rd("_svcdump_%s.txt" % TAG):
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        p = ln.split("\t")
        try:
            ea = int(p[0], 16)
        except ValueError:
            continue
        out.extend(full_listing(ea, p[1] if len(p) > 1 else ""))
        n += 1
    w("svcdump_%s.txt" % TAG, "\n".join(out) + "\n")
    log("pass B listings %d" % n)
    return n


def main():
    ida_auto.auto_wait()
    log("job5 img=%s needles=%r" % (IMG, NEEDLES))
    pass_a()
    pass_b()


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    w("job5_log_%s.txt" % TAG, "\n".join(LOG) + "\n")
    idc.qexit(0)

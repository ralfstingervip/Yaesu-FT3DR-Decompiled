r"""Lane F8 - channel-record field semantics + 0xFF89C4 flag bits (MAIN, H8S).

Read-only. Copies from MAIN_FULL seed. Produces, under ida\out\chanrec\:
  f8-senders.txt  - every unique function that calls the frame senders
                    (sub_976A 0x976A, sub_9D82 0x9D82, sub_9CB2 0x9CB2);
                    each small body carries its F3xx code + the er0 offset it reads.
  f8-scan.txt     - one-pass scan over code heads 0..0x80000 for:
                      * readers/writers of @(NN:16,er0) for the unknown offsets
                      * every access to 0xFF89C4 (with mnemonic + bit)
                      * accesses to the slot addresses FF9102/FF8EA6/FF90F0/FF817E/FF812A/FFAC76
  f8-ctx.txt      - callers of the unpack sub_3FB0C, plus the display-refresh and
                    repack helpers, to characterise the A/B record slots.
"""

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, "ida", "out", "chanrec")
os.makedirs(OUT, exist_ok=True)
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", os.environ.get("YAESU_JOB", "FIN_MAIN_REC"))
os.makedirs(LOGDIR, exist_ok=True)
LOG = []


def log(m):
    LOG.append(str(m))


def w(name, text):
    with open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def disln(ea):
    return idc.generate_disasm_line(ea, 1) or "?"


def fname(ea):
    fn = ida_funcs.get_func(ea)
    return ida_funcs.get_func_name(fn.start_ea) if fn else "-"


def fstart(ea):
    fn = ida_funcs.get_func(ea)
    return fn.start_ea if fn else idc.BADADDR


def slab(start, end):
    lines = []
    q = start
    while q < end and q != idc.BADADDR:
        if not ida_bytes.is_code(ida_bytes.get_flags(q)):
            ida_ua.create_insn(q)
        sz = ida_bytes.get_item_size(q) or 1
        raw = " ".join("%02X" % ida_bytes.get_byte(q + i) for i in range(min(8, sz)))
        lines.append("%06X  %-23s %s" % (q, raw, disln(q)))
        q += sz
    return "\n".join(lines)


def fdump(ea, tag="", maxlen=0x160):
    fn = ida_funcs.get_func(ea)
    if fn is None:
        return "### NO FUNC %06X %s\n%s\n" % (ea, tag, slab(ea, ea + 0x50))
    cs = ["%06X" % xr.frm for xr in idautils.XrefsTo(fn.start_ea, 0)]
    end = min(fn.end_ea, fn.start_ea + maxlen)
    return "### %s %06X-%06X %s\n; callers: %s\n%s\n" % (
        ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea, tag,
        ",".join(cs[:48]) or "(none)", slab(fn.start_ea, end))


def main():
    ida_auto.auto_wait()

    # ---- A. frame-sender callers -------------------------------------------
    out = []
    for tgt in (0x976A, 0x9D82, 0x9CB2):
        out.append("\n========== callers of %06X (%s) ==========" % (tgt, fname(tgt)))
        sites = sorted(set(xr.frm for xr in idautils.XrefsTo(tgt, 0)))
        out.append("; %d call sites" % len(sites))
        seen = set()
        for frm in sites:
            fs = fstart(frm)
            key = fs if fs != idc.BADADDR else frm
            if key in seen:
                continue
            seen.add(key)
            out.append(fdump(frm, "(site %06X)" % frm, 0x150))
    w("f8-senders.txt", "\n".join(out) + "\n")

    # ---- B. one-pass scan --------------------------------------------------
    off_targets = (0x12, 0x13, 0x16, 0x36, 0x38, 0x39)
    er0_hits = {n: [] for n in off_targets}
    c4_hits = []
    addr_names = {
        "FF9102": [], "FF8EA6": [], "FF90F0": [], "FF817E": [],
        "FF812A": [], "FFAC76": [],
    }
    for ea in idautils.Heads(0x0, 0x80000):
        fl = ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(fl):
            continue
        line = disln(ea)
        up = line.upper()
        for n in off_targets:
            if ("0X%X:16,ER0)" % n) in up:
                er0_hits[n].append((ea, fname(ea), line))
        if "89C4" in up:
            mnem = idc.print_insn_mnem(ea)
            bit = ""
            if mnem in ("btst", "bld", "bst", "bset", "bclr", "bnot", "band", "bor", "bxor", "bias"):
                bit = idc.get_operand_value(ea, 0)
            c4_hits.append((ea, fname(ea), mnem, bit, line))
        for nm, lst in addr_names.items():
            if nm in up:
                lst.append((ea, fname(ea), line))

    parts = []
    parts.append("===== readers/writers of @(NN:16,er0) for unknown offsets =====")
    for n in off_targets:
        parts.append("\n-- offset 0x%02X (reader) = er6+0x%02X (unpack) -- %d hits" % (n, n - 0x12, len(er0_hits[n])))
        for ea, fn, line in er0_hits[n]:
            parts.append("%06X  %-10s %s" % (ea, fn, line))
    parts.append("\n\n===== every access to 0xFF89C4 =====")
    parts.append("addr    func        mnem   bit  line")
    for ea, fn, mnem, bit, line in c4_hits:
        parts.append("%06X  %-11s %-6s %-4s %s" % (ea, fn, mnem, bit, line))
    parts.append("\n\n===== slot/flag address accesses =====")
    for nm, lst in addr_names.items():
        parts.append("\n-- 0x%s -- %d hits" % (nm, len(lst)))
        for ea, fn, line in lst[:60]:
            parts.append("%06X  %-11s %s" % (ea, fn, line))
    w("f8-scan.txt", "\n".join(parts) + "\n")

    # ---- C. context: unpack callers + display/repack helpers ---------------
    out = []
    out.append("===== unpack sub_3FB0C callers & slot helpers =====")
    for ea in sorted(set(xr.frm for xr in idautils.XrefsTo(0x3FB0C, 0))):
        out.append(fdump(ea, "(calls 3FB0C at %06X)" % ea, 0x140))
    for ea, tag in [(0x1CBE6, "display-refresh (A/B record redraw)"),
                    (0x21FC6, "817E.0-set branch target"),
                    (0x1CC62, "repack helper 1"),
                    (0x22042, "repack helper 2")]:
        out.append(fdump(ea, tag, 0x120))
    w("f8-ctx.txt", "\n".join(out) + "\n")

    log("done: senders=%d c4=%d" % (
        sum(1 for _ in []) , len(c4_hits)))


try:
    main()
except Exception:
    log(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "f8_chanrec.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

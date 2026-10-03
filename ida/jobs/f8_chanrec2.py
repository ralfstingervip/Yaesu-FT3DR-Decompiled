r"""Lane F8 pass 2 - bit-level semantics. Read-only, copy-seeded MAIN.

  f8-bits.txt : for every read of @(0x12:16,er0) and @(0x39:16,er0), the read
                line plus the following 3 heads (to expose the bld/btst #n that
                selects a bit).
  f8-misc.txt : sub_52CC (0x36 sender), sub_3EFEE family (0x16/F34A),
                callers of the word-senders sub_9792/sub_98CA that touch 0x36,
                readers of the STEP index @(0x14,er0) and MODE @(0x19,er0),
                sub_EAD2 band table context, and the F320/F321 helper area.
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


def nexts(ea, n):
    out = []
    q = ea
    for _ in range(n):
        q = idc.next_head(q, 0x80000)
        if q == idc.BADADDR:
            break
        out.append("        %06X  %s" % (q, disln(q)))
    return out


def slab(start, end):
    lines = []
    q = start
    while q < end and q != idc.BADADDR:
        if not ida_bytes.is_code(ida_bytes.get_flags(q)):
            ida_ua.create_insn(q)
        sz = ida_bytes.get_item_size(q) or 1
        raw = " ".join("%02X" % ida_bytes.get_byte(q + i) for i in range(min(7, sz)))
        lines.append("%06X  %-21s %s" % (q, raw, disln(q)))
        q += sz
    return "\n".join(lines)


def fdump(ea, tag="", maxlen=0x120):
    fn = ida_funcs.get_func(ea)
    if fn is None:
        return "### NO FUNC %06X %s\n%s\n" % (ea, tag, slab(ea, ea + 0x60))
    end = min(fn.end_ea, fn.start_ea + maxlen)
    return "### %s %06X-%06X %s\n%s\n" % (
        ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea, tag,
        slab(fn.start_ea, end))


def main():
    ida_auto.auto_wait()

    # ---- bit-level: reads of 0x12 and 0x39 with following context ----------
    parts = []
    for off in (0x12, 0x39):
        parts.append("\n===== reads of @(0x%02X:16,er0) + next 3 heads =====" % off)
        tok = "0X%X:16,ER0)" % off
        for ea in idautils.Heads(0x0, 0x80000):
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                continue
            line = disln(ea)
            if tok in line.upper() and ("mov.b   @(" in line):  # a read into reg
                parts.append("%06X  %-10s %s" % (ea, fname(ea), line))
                parts.extend(nexts(ea, 3))
    w("f8-bits.txt", "\n".join(parts) + "\n")

    # ---- misc targeted dumps ----------------------------------------------
    out = []
    out.append("===== sub_52CC (reads 0x36) + neighbourhood 52BC..5300 =====")
    out.append(slab(0x52BC, 0x5300))
    out.append("\n===== sub_3EFEE family (0x16 -> F34A) =====")
    for ea in (0x3EEEE, 0x3EF2E, 0x3EF6E, 0x3EFAE, 0x3EFEE):
        out.append(fdump(ea, "(0x16 reader)", 0x40))
    out.append("\n===== word senders sub_9792 / sub_98CA =====")
    out.append(fdump(0x9792, "word sender (hi:lo)", 0x40))
    out.append(fdump(0x98CA, "word+byte sender", 0x60))
    out.append("\n===== callers of 0x9792 / 0x98CA that read 0x36 =====")
    for tgt in (0x9792, 0x98CA):
        for frm in sorted(set(x.frm for x in idautils.XrefsTo(tgt, 0))):
            fn = ida_funcs.get_func(frm)
            base = fn.start_ea if fn else frm
            body = slab(base, min(base + 0x80, frm + 8))
            if "0x36:16,er0)" in body:
                out.append("### caller %06X of %06X\n%s\n" % (frm, tgt, body))
    out.append("\n===== STEP index use: funcs reading @(0x14,er0) =====")
    seen = set()
    for ea in idautils.Heads(0x0, 0x80000):
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            continue
        if "0x14:16,er0)" in disln(ea):
            fn = ida_funcs.get_func(ea)
            key = fn.start_ea if fn else ea
            if key in seen:
                continue
            seen.add(key)
            out.append("%06X  %-10s %s" % (ea, fname(ea), disln(ea)))
            out.extend(nexts(ea, 4))
    out.append("\n===== MODE use: funcs reading @(0x19,er0) (first 25) =====")
    seen = set()
    cnt = 0
    for ea in idautils.Heads(0x0, 0x80000):
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            continue
        if "0x19:16,er0)" in disln(ea):
            fn = ida_funcs.get_func(ea)
            key = fn.start_ea if fn else ea
            if key in seen:
                continue
            seen.add(key)
            cnt += 1
            if cnt > 25:
                break
            out.append("%06X  %-10s %s" % (ea, fname(ea), disln(ea)))
    out.append("\n===== sub_EAD2 band table: ctx of [800F] usage =====")
    out.append(fdump(0xEA4C, "a caller of sub_EAD2", 0x80))
    w("f8-misc.txt", "\n".join(out) + "\n")

    log("pass2 done")


try:
    main()
except Exception:
    log(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "f8_chanrec2.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

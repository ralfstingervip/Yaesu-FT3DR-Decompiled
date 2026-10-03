r"""Lane 6 (extension menus) SUB job 1.

Dumps the menu count/page functions, the RAM DISPLAY pages and helpers, the
RAM pointer-table users (0x69310/0x6931C/0x69320/0x69330), _INITSCT, the IPC
opcode dispatcher, and classifies the r4 (descriptor) argument at every raw
BSR to the three blit entry points.
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
OUT = os.path.join(ROOT, "ida", "out", "extension")
os.makedirs(OUT, exist_ok=True)
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", os.environ.get("YAESU_JOB", "EXT_MENU_MAIN"))
os.makedirs(LOGDIR, exist_ok=True)
LOG = []
B = 0xFFC00000


def log(m):
    LOG.append(str(m))


def w(name, text):
    with open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def ensure_code(ea):
    if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
        ida_ua.create_insn(ea)


def slab(start, end):
    lines = []
    q = start
    while q < end:
        ensure_code(q)
        sz = ida_bytes.get_item_size(q) or 1
        raw = " ".join("%02X" % ida_bytes.get_byte(q + i) for i in range(min(8, sz)))
        lines.append("%08X  %-24s %s" % (q, raw, idc.generate_disasm_line(q, 1) or "?"))
        q += sz
    return "\n".join(lines)


def dump(ea, tag, maxlen=0x600):
    ensure_code(ea)
    fn = ida_funcs.get_func(ea)
    if fn is None or fn.start_ea != ea:
        ida_funcs.add_func(ea)
        ida_auto.auto_wait()
        fn = ida_funcs.get_func(ea)
    if fn is None:
        return "###### NO FUNC %08X %s\n%s\n" % (ea, tag, slab(ea, ea + 0x100))
    end = min(fn.end_ea, fn.start_ea + maxlen)
    cs = []
    for xr in idautils.XrefsTo(fn.start_ea, 0):
        f2 = ida_funcs.get_func(xr.frm)
        cs.append("%08X(%s)" % (xr.frm, ida_funcs.get_func_name(f2.start_ea) if f2 else "-"))
    return "###### %s %08X-%08X %s\n; callers: %s\n%s\n" % (
        ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea, tag,
        ", ".join(cs) if cs else "(none)", slab(fn.start_ea, end))



def fdump(ea, tag, maxlen=0x800):
    fn = ida_funcs.get_func(ea)
    if fn is None:
        return "###### NO FUNC containing %08X %s\n%s\n" % (ea, tag, slab(ea - 0x40, ea + 0x100))
    end = min(fn.end_ea, fn.start_ea + maxlen)
    cs = []
    for xr in idautils.XrefsTo(fn.start_ea, 0):
        f2 = ida_funcs.get_func(xr.frm)
        cs.append("%06X(%s)" % (xr.frm, ida_funcs.get_func_name(f2.start_ea) if f2 else "-"))
    return "###### %s %06X-%06X %s\n; callers: %s\n%s\n" % (
        ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea, tag,
        ", ".join(cs[:80]) if cs else "(none)", slab(fn.start_ea, end))




def ctx_before(site, n=8):
    lines = []
    q = site
    for _ in range(n):
        q = idc.prev_head(q, site - 0x60)
        if q == idc.BADADDR:
            break
        lines.append(q)
    lines.reverse()
    return "\n".join("%06X  %s" % (a, (idc.generate_disasm_line(a, 1) or "").split(";")[0]) for a in lines + [site])



import re
RX = re.compile(r"@\((0x[0-9A-Fa-f]+|\d+):16,er0\)")
def main():
    ida_auto.auto_wait()
    rows = ["ea\tfunc\tctxoff\trecfield\tinsn\tnext1\tnext2\tnext3"]
    fmap = {0x12: "rec+00", 0x14: "rec+01.b0-3", 0x15: "rec+01.b4-5", 0x19: "rec+01.b6-7",
            0x16: "rec+05.b0-3", 0x13: "rec+05.b6-7", 0x36: "rec+05.b4-5/rec+1E.b0-1,b6-7",
            0x34: "rec+1D.b0-4", 0x35: "rec+1D.b5-7", 0x37: "rec+1E.b0-3", 0x38: "rec+1F.b0-2", 0x39: "rec+1F.b3-7"}
    for seg_ea in idautils.Segments():
        for h in idautils.Heads(seg_ea, idc.get_segm_end(seg_ea)):
            if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                continue
            tt = (idc.generate_disasm_line(h, 1) or "").split(";")[0].strip()
            m = RX.search(tt)
            if not m:
                continue
            off = int(m.group(1), 0)
            if off not in fmap:
                continue
            n = []
            q = h
            for _ in range(3):
                q = idc.next_head(q, h + 0x40)
                n.append((idc.generate_disasm_line(q, 1) or "").split(";")[0].strip() if q != idc.BADADDR else "")
            fn = ida_funcs.get_func(h)
            rows.append("%06X\t%s\t0x%02X\t%s\t%s\t%s" % (h, ida_funcs.get_func_name(fn.start_ea) if fn else "-", off, fmap[off], tt, "\t".join(n)))
    w("menus-main7-ctx.tsv", "\n".join(rows) + "\n")


try:
    main()
except Exception:
    log(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "full_l6_main7.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

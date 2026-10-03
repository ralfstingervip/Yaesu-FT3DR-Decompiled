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


def main():
    ida_auto.auto_wait()
    out = []
    for a, b in [(0xE600, 0xE6C0), (0x14A20, 0x14A80), (0x163F0, 0x16480), (0x14EA0, 0x150B0),
                 (0x2C030, 0x2C0A0), (0x298C8, 0x2992A)]:
        out.append("#### slab %06X-%06X\n%s" % (a, b, slab(a, b)))
    out.append("#### table 1515C: " + ida_bytes.get_bytes(0x1515C, 0x40).hex())
    data = ida_bytes.get_bytes(0, 0x100000)
    for tgt in (0x3AB80, 0x3AD20, 0x16456, 0x1645E, 0x2992A, 0x14EE4):
        pat = bytes([0x5E, (tgt >> 16) & 0xFF, (tgt >> 8) & 0xFF, tgt & 0xFF])
        i = data.find(pat)
        n = 0
        while i != -1 and n < 60:
            out.append("#### jsr %06X from %06X\n%s" % (tgt, i, ctx_before(i, 7)))
            i = data.find(pat, i + 1)
            n += 1
        # also as data pointer (jump tables)
        pat2 = tgt.to_bytes(4, "big")
        i = data.find(pat2)
        L = []
        while i != -1:
            L.append("%06X" % i)
            i = data.find(pat2, i + 1)
        out.append("#### ptr %06X at: %s" % (tgt, " ".join(L)))
    w("menus-main3.txt", "\n".join(out) + "\n")


try:
    main()
except Exception:
    log(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "full_l6_main3.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

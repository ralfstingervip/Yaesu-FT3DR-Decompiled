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



import re
PAT = re.compile(r"(?:0x|#0x)?(?:FFFF|00FF|FF)?(8F2E|8F4[E-F]|8F5[0-9A-B]|89C4|BB98|BB99|89C2|8ABE|BBE0|8BCA|813E|3D7A|3D7B)\b", re.I)


def main():
    ida_auto.auto_wait()
    rows = ["ea\tfunc\tkey\tdisasm"]
    funcs = {}
    for seg_ea in idautils.Segments():
        for h in idautils.Heads(seg_ea, idc.get_segm_end(seg_ea)):
            if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                continue
            t = idc.generate_disasm_line(h, 1) or ""
            tt = t.split(";")[0]
            m = PAT.search(tt.upper().replace("0X", "0x"))
            if not m:
                continue
            fn = ida_funcs.get_func(h)
            fname = ida_funcs.get_func_name(fn.start_ea) if fn else "-"
            rows.append("%06X\t%s\t%s\t%s" % (h, fname, m.group(1), tt.strip()))
            if fn:
                funcs.setdefault(fn.start_ea, set()).add(m.group(1))
    w("menus-main2-refs.tsv", "\n".join(rows) + "\n")
    # raw callers of F3xx builders
    out = []
    data = ida_bytes.get_bytes(0, 0x100000)
    for tgt in (0xA684, 0x95B6, 0x9562, 0x7C20):
        pat = bytes([0x5E, (tgt >> 16) & 0xFF, (tgt >> 8) & 0xFF, tgt & 0xFF])
        sites = []
        i = data.find(pat)
        while i != -1:
            sites.append(i)
            i = data.find(pat, i + 1)
        out.append("jsr %06X: %s" % (tgt, " ".join("%06X" % s for s in sites)))
    w("menus-main2-jsr.txt", "\n".join(out) + "\n")
    # dump functions touching OPTION cursor 8F5B, the category 8F2E, gate 89C4
    dumped = []
    for fea, keys in sorted(funcs.items()):
        if keys & {"8F5B", "89C4", "BB98", "BB99"}:
            dumped.append(fdump(fea, ",".join(sorted(keys)), 0x600))
    w("menus-main2-funcs.txt", "\n".join(dumped))


try:
    main()
except Exception:
    log(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "full_l6_main2.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

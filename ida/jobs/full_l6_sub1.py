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
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", os.environ.get("YAESU_JOB", "EXT_MENU"))
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


def raw_calls(targets):
    lo, hi = B + 0x2C0000, B + 0x400000
    res = {t: [] for t in targets}
    ea = lo
    buf = ida_bytes.get_bytes(lo, hi - lo)
    for o in range(len(buf) - 4):
        op = buf[o]
        if op == 0x05:
            d = int.from_bytes(buf[o + 1:o + 4], "little", signed=True)
        elif op == 0x39:
            d = int.from_bytes(buf[o + 1:o + 3], "little", signed=True)
        else:
            continue
        t = (lo + o + d) & 0xFFFFFFFF
        if t in res:
            res[t].append(lo + o)
    return res


def classify_r4(site):
    """walk back up to 14 heads for the last write to r4."""
    ensure_code(site)
    if not ida_bytes.is_code(ida_bytes.get_flags(site)):
        return "notcode", ""
    q = site
    for _ in range(14):
        q = idc.prev_head(q, site - 0x80)
        if q == idc.BADADDR:
            break
        t = idc.generate_disasm_line(q, 1) or ""
        tt = t.split(";")[0].strip()
        if tt.startswith(("bsr", "jsr", "rts", "bra", "jmp")):
            return "boundary", "%08X %s" % (q, tt)
        if tt.endswith(", r4") or tt.endswith(",r4"):
            m = idc.print_insn_mnem(q)
            if "#" in tt:
                v = idc.get_operand_value(q, 0)
                v &= 0xFFFFFFFF
                if 0xFFECE55C <= v < 0xFFED3F6C:
                    return "flash_desc", "%08X %s" % (q, tt)
                if v >= 0xFFC00000:
                    return "flash_other", "%08X %s" % (q, tt)
                if v < 0x80000:
                    return "RAM_IMM", "%08X %s" % (q, tt)
                return "imm_other", "%08X %s" % (q, tt)
            return "computed", "%08X %s" % (q, tt)
    return "unresolved", ""


def main():
    ida_auto.auto_wait()
    out = []
    for ea, tag in [
        (0xFFF095E3, "menu_item_count"),
        (0xFFF09171, "menu_draw_page"),
        (0xFFF0964A, "menu_draw_row"),
        (0xFFF0A7B9, "draw_option_row (JP)"),
        (0xFFF0A86D, "ram_display_screen"),
        (0xFFF0A8A6, "RD page0"),
        (0xFFF0A8B8, "RD page1"),
        (0xFFF0A958, "RD page2"),
        (0xFFF0A985, "after page2"),
        (0xFFF0A9B9, "RD page3"),
        (0xFFF0AA3F, "RD helper AA3F"),
        (0xFFF0AB1A, "RD helper AB1A"),
        (0xFFF0AB40, "RD helper AB40"),
        (0xFFEF68D5, "blit wrapper"),
        (0xFFEF032D, "EF032D"),
        (0xFFEF036F, "EF036F"),
        (0xFFEFA75E, "EFA75E"),
        (0xFFEFA7E7, "EFA7E7 draw_string?"),
        (0xFFEF9E8F, "EF9E8F"),
        (0xFFEEF9BB, "EEF9BB display predicate"),
        (0xFFF45DBC, "_INITSCT"),
        (0xFFEDF1D8, "IPC opcode dispatch"),
        (0xFFEDF269, "IPC F0 dispatch"),
        (0xFFF004C2, "setup item screen dispatcher"),
    ]:
        try:
            out.append(dump(ea, tag, 0x900))
        except Exception:
            out.append("ERR %08X\n%s" % (ea, traceback.format_exc()))
    w("menus-sub1-funcs.txt", "\n".join(out))

    sl = []
    for a, b in [(0xFFF0A86D, 0xFFF0AC40), (0xFFF0AD80, 0xFFF0B0D0), (0xFFF0E600, 0xFFF0E6E0),
                 (0xFFED75A8, 0xFFED7610)]:
        sl.append("#### slab %08X-%08X\n%s" % (a, b, slab(a, b)))
    for a in (0xFFF0AE1A, 0xFFF0AF19, 0xFFF0B066, 0xFFF0E64B, 0xFFF0E68B):
        fn = ida_funcs.get_func(a)
        sl.append("#### %08X in %s" % (a, ida_funcs.get_func_name(fn.start_ea) if fn else "-"))
    w("menus-sub1-slabs.txt", "\n".join(sl))

    tg = {0xFFEF68D5: "blitw", 0xFFEF0648: "blit", 0xFFEF04F7: "b04F7"}
    rc = raw_calls(list(tg))
    rows = ["target\tsite\tfunc\tclass\tr4_insn"]
    hist = {}
    for t, sites in rc.items():
        for s in sites:
            c, ins = classify_r4(s)
            fn = ida_funcs.get_func(s)
            rows.append("%s\t%08X\t%s\t%s\t%s" % (tg[t], s,
                        ida_funcs.get_func_name(fn.start_ea) if fn else "-", c, ins))
            hist[(tg[t], c)] = hist.get((tg[t], c), 0) + 1
    w("menus-blit-sites.tsv", "\n".join(rows) + "\n")
    log("hist " + repr(sorted(hist.items())))


try:
    main()
except Exception:
    log(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "full_l6_sub1.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

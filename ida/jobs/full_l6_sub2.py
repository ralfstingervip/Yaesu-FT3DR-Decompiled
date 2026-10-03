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
        (0xFFEDF0B0, "screen dispatcher around FFEDF0DC"),
        (0xFFEDF2E0, "IPC F1"), (0xFFEDF36A, "IPC F2"), (0xFFEDF3A7, "IPC F3/F4"),
        (0xFFEDF447, "IPC F5"), (0xFFEDF4B8, "IPC F6"), (0xFFEDF53E, "IPC F7"),
        (0xFFEDF56F, "IPC F8"), (0xFFEDF61B, "IPC F9"), (0xFFEDF645, "IPC FA"),
        (0xFFF092FC, "setup cat getter"), (0xFFF09396, "setup item getter"),
        (0xFFF0878C, "setup list screen"), (0xFFF0896A, "screen 0x1E"),
        (0xFFF08994, "75A8[0]"), (0xFFF089A6, "75A8[1]"), (0xFFF089D3, "75A8[2]"), (0xFFF08AC9, "75A8[3]"),
        (0xFFF08A00, "75F4"), (0xFFF08A85, "75F8"),
        (0xFFEFE223, "screen 0x1F"), (0xFFEFD6E9, "screen 0x20"),
        (0xFFF0AC89, "screen 0x1D"),
        (0xFFEF4142, "settings applier"),
    ]:
        try:
            out.append(dump(ea, tag, 0x1400))
        except Exception:
            out.append("ERR %08X\n%s" % (ea, traceback.format_exc()))
    for a in (0xFFEDF0DC, 0xFFEDF141, 0xFFEDF160, 0xFFEFE38A, 0xFFF08A11, 0xFFF08CA0, 0xFFF0897E, 0xFFF08B1F):
        fn = ida_funcs.get_func(a)
        if fn is None:
            out.append("#### ctx %08X (no func)\n%s" % (a, slab(a - 0x60, a + 0x60)))
        else:
            out.append("#### ctx %08X in %s\n%s" % (a, ida_funcs.get_func_name(fn.start_ea), slab(max(fn.start_ea, a - 0x80), min(fn.end_ea, a + 0x80))))
    w("menus-sub2-funcs.txt", "\n".join(out))

    rc = raw_calls([0xFFEF0648])
    rows = ["site\tfunc\tclass\tr3_insn"]
    hist = {}
    for s in rc[0xFFEF0648]:
        ensure_code(s)
        q = s
        cls, ins = "unresolved", ""
        for _ in range(14):
            q = idc.prev_head(q, s - 0x80)
            if q == idc.BADADDR:
                break
            tt = (idc.generate_disasm_line(q, 1) or "").split(";")[0].strip()
            if tt.startswith(("bsr", "jsr", "rts", "bra", "jmp")):
                cls, ins = "boundary", "%08X %s" % (q, tt)
                break
            if tt.endswith(", r3"):
                ins = "%08X %s" % (q, tt)
                if "#" in tt and not tt.startswith("add"):
                    v = idc.get_operand_value(q, 0) & 0xFFFFFFFF
                    cls = "flash_desc" if 0xFFECE55C <= v < 0xFFED3F6C else ("flash" if v >= 0xFFC00000 else "imm_small_or_ram")
                else:
                    cls = "computed"
                break
        fn = ida_funcs.get_func(s)
        rows.append("%08X\t%s\t%s\t%s" % (s, ida_funcs.get_func_name(fn.start_ea) if fn else "-", cls, ins))
        hist[cls] = hist.get(cls, 0) + 1
    w("menus-blit-direct.tsv", "\n".join(rows) + "\n")
    log("direct blit hist " + repr(hist))


try:
    main()
except Exception:
    log(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "full_l6_sub2.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)

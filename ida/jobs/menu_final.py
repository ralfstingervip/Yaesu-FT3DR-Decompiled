r"""MENU job 5: dump the decisive functions and their call chains.

  FFEF4142  touches gate byte 0x8E4D (struct copy)
  FFF08264  camera setting screen (SIZE / QUALITY / SP SEL : CAMERA / INT SP)
  FFF0DE5C  "---DSP WRITE MODE----" / "Push DISP Key!"
  FFEE81C8  "PASSWORD INPUT" / "PASSWORD ENTRY"
  FFF05898  "MODEL CODE : APY03D"
  FFF00EF0  "Main Ver. / Sub Ver. / DSP Ver."
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import idautils
import idc

OUT = str(_REPO / "ida/out/menu")
os.makedirs(OUT, exist_ok=True)
LOG = []


def log(m):
    LOG.append(str(m))


def w(name, text):
    with open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def slab(start, end):
    lines = []
    q = start
    while q < end:
        sz = ida_bytes.get_item_size(q) or 1
        raw = " ".join("%02X" % ida_bytes.get_byte(q + i) for i in range(min(8, sz)))
        lines.append("%08X  %-24s %s" % (q, raw, idc.generate_disasm_line(q, 1) or "?"))
        q += sz
    return "\n".join(lines)


def dump(ea, tag, pad=0x100):
    fn = ida_funcs.get_func(ea)
    if fn is None:
        return "###### NO FUNC at %08X  %s\n%s\n" % (ea, tag, slab(ea - 0x40, ea + pad))
    head = "###### %s  %08X-%08X  %s" % (ida_funcs.get_func_name(fn.start_ea),
                                         fn.start_ea, fn.end_ea, tag)
    cs = []
    for xr in idautils.XrefsTo(fn.start_ea, 0):
        f2 = ida_funcs.get_func(xr.frm)
        cs.append("%08X %s" % (xr.frm, ida_funcs.get_func_name(f2.start_ea) if f2 else "-"))
    head += "\n; callers: " + (", ".join(cs) if cs else "(none found)")
    return head + "\n" + slab(fn.start_ea, fn.end_ea) + "\n"


def main():
    ida_auto.auto_wait()
    parts = []
    for ea, tag in (
        (0xFFEF4142, "touches gate byte 0x8E4D - settings struct copy"),
        (0xFFF08264, "camera setting screen: SIZE / QUALITY / SP SEL"),
        (0xFFF0DE5C, "---DSP WRITE MODE---- / Push DISP Key!"),
        (0xFFEE81C8, "PASSWORD INPUT / PASSWORD ENTRY"),
        (0xFFF05898, "MODEL CODE : APY03D"),
        (0xFFF00EF0, "Main Ver / Sub Ver / DSP Ver screen"),
        (0xFFEE25C6, "settings default writer"),
        (0xFFF0A86D, "RAM DISPLAY dispatcher"),
        (0xFFF0A8B8, "RAM DISPLAY page 1 - RAM monitor"),
    ):
        parts.append(dump(ea, tag))
    w("decisive_funcs.txt", "\n".join(parts))

    # call chain upward from the camera screen and the DSP write mode
    def chain(start, depth=4):
        out = []
        frontier = {start}
        seen = set()
        for lvl in range(depth):
            nxt = set()
            for f in sorted(frontier):
                fn = ida_funcs.get_func(f)
                if fn is None or fn.start_ea in seen:
                    continue
                seen.add(fn.start_ea)
                for xr in idautils.XrefsTo(fn.start_ea, 0):
                    g = ida_funcs.get_func(xr.frm)
                    nm = ida_funcs.get_func_name(g.start_ea) if g else "-"
                    out.append("  lvl%d  %s <- %08X %s" % (
                        lvl, ida_funcs.get_func_name(fn.start_ea), xr.frm, nm))
                    if g:
                        nxt.add(g.start_ea)
            frontier = nxt
            if not frontier:
                break
        return out

    parts = []
    for ea, tag in ((0xFFF08264, "camera screen"),
                    (0xFFF0DE5C, "DSP WRITE MODE"),
                    (0xFFEE81C8, "PASSWORD"),
                    (0xFFF0A86D, "RAM DISPLAY")):
        fn = ida_funcs.get_func(ea)
        parts.append("=== upward call chain from %s (%08X) ===" % (tag, ea))
        parts.extend(chain(fn.start_ea if fn else ea))
        parts.append("")
    w("call_chains.txt", "\n".join(parts) + "\n")
    idc.save_database("")


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
w("job5_log.txt", "\n".join(LOG) + "\n")
idc.qexit(0)

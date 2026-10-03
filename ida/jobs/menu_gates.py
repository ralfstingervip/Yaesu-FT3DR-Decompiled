r"""MENU job 4: resolve the gate writes, the USB CAMERA handler and DSP WRITE MODE.

Operand displacements are recovered from the generated disassembly text because
the IDA RX module does not expose them in op.addr.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import re
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_segment
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/menu")
os.makedirs(OUT, exist_ok=True)
LOG = []

DISPL = re.compile(r"([0-9A-Fa-f]+)h?\[r(\d+)\]")
IMMLD = re.compile(r"^mov\.l\s+#([0-9A-Fa-f]+)h?,\s*r(\d+)$", re.I)


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
        fn = ida_funcs.get_func(q)
        if fn and fn.start_ea == q:
            lines.append("")
            lines.append("; ---- %s  %08X-%08X" % (ida_funcs.get_func_name(q),
                                                   fn.start_ea, fn.end_ea))
        raw = " ".join("%02X" % ida_bytes.get_byte(q + i) for i in range(min(8, sz)))
        lines.append("%08X  %-24s %s" % (q, raw, idc.generate_disasm_line(q, 0) or "?"))
        q += sz
    return "\n".join(lines)


def dump_func(ea, tag=""):
    fn = ida_funcs.get_func(ea)
    if fn is None:
        return "### no function at %08X %s\n%s\n" % (ea, tag, slab(ea, ea + 0xC0))
    return ("###### %s  %08X-%08X  %s\n%s\n" %
            (ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea, tag,
             slab(fn.start_ea, fn.end_ea)))


def main():
    ida_auto.auto_wait()

    # ---- 1. resolve every base+displacement access against the settings bases
    WANT = {}
    for a in (0x8C4C, 0x8C4D, 0x8E46, 0x8F72):
        WANT[a] = True
    rows = ["abs\tbase\tdisp\tsite\tfunc\tdisasm"]
    interesting = {0x8E4D: "RAM DISPLAY / hidden-mode gate (bit 7)",
                   0x8C4C: "RAM DISPLAY page index",
                   0x8C6D: "current setup category",
                   0x8C6E: "setup scroll top",
                   0x8C6F: "setup cursor row",
                   0x8F72: "language flag"}
    hits = {k: [] for k in interesting}
    for seg_i in range(ida_segment.get_segm_qty()):
        seg = ida_segment.getnseg(seg_i)
        if seg.start_ea < 0xFFEC0000:
            continue
        ea = seg.start_ea
        reg_imm = {}
        while ea < seg.end_ea:
            fl = ida_bytes.get_flags(ea)
            sz = ida_bytes.get_item_size(ea) or 1
            if not ida_bytes.is_code(fl):
                reg_imm = {}
                ea += sz
                continue
            txt = (idc.generate_disasm_line(ea, 1) or "").strip()
            low = txt.lower()
            m = IMMLD.match(re.sub(r"\s*;.*$", "", low))
            if m:
                try:
                    val = int(m.group(1), 16)
                except ValueError:
                    val = -1
                reg_imm[int(m.group(2))] = val
                if val in WANT:
                    rows.append("%08X\t%08X\t0\t%08X\t%s\t%s" % (
                        val, val, ea, _fn(ea), txt))
            else:
                for dsp, reg in DISPL.findall(txt):
                    base = reg_imm.get(int(reg))
                    if base is None or not (0x8C00 <= base <= 0x9200):
                        continue
                    try:
                        d = int(dsp, 16)
                    except ValueError:
                        continue
                    abs_ea = base + d
                    rows.append("%08X\t%08X\t%X\t%08X\t%s\t%s" % (
                        abs_ea, base, d, ea, _fn(ea), txt))
                    if abs_ea in interesting:
                        hits[abs_ea].append((ea, _fn(ea), txt))
                # also catch [rN] with no displacement -> base itself
                if re.search(r"\[r(\d+)\]", txt) and not DISPL.search(txt):
                    for reg in re.findall(r"\[r(\d+)\]", txt):
                        base = reg_imm.get(int(reg))
                        if base is not None and base in interesting:
                            hits[base].append((ea, _fn(ea), txt))
                if low.startswith(("bsr", "jsr", "bra", "jmp", "rts", "rtsd")):
                    reg_imm = {}
            ea += sz
    w("settings_fields2.tsv", "\n".join(rows) + "\n")
    log("settings_fields2 rows %d" % (len(rows) - 1))

    parts = []
    for k, why in sorted(interesting.items()):
        parts.append("=== %08X  %s  (%d refs) ===" % (k, why, len(hits[k])))
        for ea, fname, txt in hits[k]:
            parts.append("  %08X  %-24s %s" % (ea, fname, txt))
        parts.append("")
    w("gate_writes.txt", "\n".join(parts) + "\n")

    # ---- 2. xrefs to the message strings that name the hidden modes
    strs = {0xFFF4ACF8: "---DSP WRITE MODE----",
            0xFFF4AD0E: "Push DISP Key!",
            0xFFF4AD1D: "Loading...",
            0xFFF4A4C1: "CAMERA",
            0xFFF4A4C8: "INT SP",
            0xFFF4A496: "320*240",
            0xFFF4A4AF: "QUALITY:",
            0xFFF4A4B8: "SP SEL :",
            0xFFF4AA16: "USB <katakana camera>",
            0xFFF4AA3F: "RAM <kanji display>",
            0xFFF48588: "PASSWORD INPUT",
            0xFFF48597: "PASSWORD ENTRY",
            0xFFF4995F: "MODEL CODE : APY03D",
            0xFFF48814: "DSP  Ver.",
            0xFFF4A059: "DSP H",
            0xFFF4AB3F: "FIRM ERROR"}
    rows = ["target\tname\tfrom\tfunc\tdisasm"]
    for a, nm in sorted(strs.items()):
        got = False
        for xr in idautils.XrefsTo(a, 0):
            got = True
            rows.append("%08X\t%s\t%08X\t%s\t%s" % (
                a, nm, xr.frm, _fn(xr.frm),
                (idc.generate_disasm_line(xr.frm, 1) or "").strip()))
        if not got:
            rows.append("%08X\t%s\t-\t-\tno xref" % (a, nm))
    w("string_xrefs.tsv", "\n".join(rows) + "\n")

    # ---- 3. code slabs around the hidden-mode strings' users
    parts = []
    seen = set()
    for a in (0xFFF4ACF8, 0xFFF4AD0E, 0xFFF4A4C1, 0xFFF4A4B8, 0xFFF4AA16,
              0xFFF48588, 0xFFF4A059):
        for xr in idautils.XrefsTo(a, 0):
            fn = ida_funcs.get_func(xr.frm)
            key = fn.start_ea if fn else xr.frm
            if key in seen:
                continue
            seen.add(key)
            parts.append(dump_func(key, "uses %08X" % a))
    w("hidden_mode_funcs.txt", "\n".join(parts) + "\n")

    # ---- 4. the RAM DISPLAY page handlers and the OPTION handler chain
    parts = []
    for ea, tag in ((0xFFF0A86D, "RAM DISPLAY screen dispatcher (gate bit7 @8E4D)"),
                    (0xFFF0A8A6, "RAM DISPLAY page 0"),
                    (0xFFF0A8B8, "RAM DISPLAY page 1 (RAM monitor, table at 0x69310)"),
                    (0xFFF0A958, "RAM DISPLAY page 2"),
                    (0xFFF0A9B9, "RAM DISPLAY page 3"),
                    (0xFFF0A7B9, "OPTION localised row draw")):
        parts.append(dump_func(ea, tag))
    w("ramdisplay_funcs.txt", "\n".join(parts) + "\n")

    idc.save_database("")


def _fn(ea):
    fn = ida_funcs.get_func(ea)
    return ida_funcs.get_func_name(fn.start_ea) if fn else "-"


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
w("job4_log.txt", "\n".join(LOG) + "\n")
idc.qexit(0)

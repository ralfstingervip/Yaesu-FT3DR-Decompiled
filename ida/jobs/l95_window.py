# -*- coding: utf-8 -*-
"""Disassemble service window 0x078106-0x07B753 in the private DB only.

Reads code-heads.tsv. Deletes and recreates items only inside the window.
auto_wait, UTF-8, qexit(0). plan_range is limited to the window.
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/service-window")
IMG_PATH = str(_REPO / "decrypted/FT3D_MAIN_ver102_EXP.bin")
HEADS = os.path.join(OUT, "code-heads.tsv")
W0, W1 = 0x078106, 0x07B754
COLLAR = ((0x078000, 0x078106), (0x07B754, 0x07B900))
CALLS = (0x076844, 0x0768A2, 0x076916, 0x076944, 0x0769E6, 0x076A08,
         0x076A88, 0x076A8E, 0x076AD8, 0x076B1A, 0x076B46, 0x076B6A,
         0x076BEA, 0x076BF2, 0x076D84, 0x076DE0, 0x076E3C, 0x076E9C,
         0x076F30, 0x076F54, 0x0768BC)
STARTS = (0x078106, 0x07815C, 0x0781C6, 0x0781DE, 0x07821E, 0x078222,
          0x07823C, 0x078256, 0x078260, 0x07827C, 0x078334, 0x07837C,
          0x0783DA, 0x07842E, 0x078442, 0x07845A, 0x0784BE, 0x078508)


def _run():
    import idc, ida_auto, ida_bytes, ida_ua, ida_funcs, idautils, ida_lines
    os.makedirs(OUT, exist_ok=True)
    log = []

    def P(s=""):
        log.append(str(s))

    ida_auto.auto_wait()
    img = sys.exit("The firmware image is not in this repository.")
    got = ida_bytes.get_bytes(W0, W1 - W0)
    P("image_match %s ida_len %s" % (bytes(got) == img[W0:W1] if got else False,
                                    len(got) if got else 0))
    P("min_ea %X max_ea %X" % (idc.get_inf_attr(idc.INF_MIN_EA),
                               idc.get_inf_attr(idc.INF_MAX_EA)))

    def snap(lo, hi):
        rows = []
        ea = idc.next_head(lo - 1, hi)
        while ea != idc.BADADDR and ea < hi:
            if ea >= lo:
                rows.append((ea, idc.get_item_size(ea),
                             1 if ida_bytes.is_code(ida_bytes.get_flags(ea)) else 0))
            ea = idc.next_head(ea, hi)
        return rows

    before = snap(W0, W1)
    collar_before = {lo: snap(lo, hi) for lo, hi in COLLAR}
    P("heads_before %d code_before %d" % (len(before), sum(r[2] for r in before)))

    def xref_block(title):
        P("== %s ==" % title)
        for a in STARTS:
            P("xref %06X" % a)
            n = 0
            for x in idautils.XrefsTo(a, 0):
                dl = ida_lines.tag_remove(idc.generate_disasm_line(x.frm, 0) or "")
                P("  %06X t%d %s" % (x.frm, x.type, dl))
                n += 1
                if n > 12:
                    break
        P("== callers %s ==" % title)
        for a in CALLS:
            f = ida_bytes.get_flags(a)
            dl = ida_lines.tag_remove(idc.generate_disasm_line(a, 0) or "")
            P("  %06X code %d sz %d %s" % (
                a, 1 if ida_bytes.is_code(f) else 0, idc.get_item_size(a), dl))

    xref_block("before")

    want = []
    with open(HEADS, encoding="utf-8") as h:
        next(h)
        for ln in h:
            c = ln.rstrip("\n").split("\t")
            want.append((int(c[0], 16), int(c[1]), c[3]))
    want_set = {a for a, n, t in want}

    ida_auto.enable_auto(False)
    funcs = [ea for ea in idautils.Functions(W0, W1) if W0 <= ea < W1]
    for ea in funcs:
        ida_funcs.del_func(ea)
    P("funcs_deleted %d" % len(funcs))
    ea = W0
    while ea < W1:
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, min(0x100, W1 - ea))
        ea += 0x100

    made = 0
    bad = 0
    for a, n, t in want:
        ln = ida_ua.create_insn(a)
        if ln != n:
            bad += 1
            if bad <= 30:
                P("create %06X want %d got %s %s" % (a, n, ln, t))
        else:
            made += 1
    P("created_match %d mismatch %d" % (made, bad))

    ida_auto.plan_range(W0, W1)
    ida_auto.auto_wait()
    mid = snap(W0, W1)
    extra = [r for r in mid if r[2] and r[0] not in want_set and W0 <= r[0] < W1]
    P("after_plan heads %d code %d extra_code %d" % (
        len(mid), sum(r[2] for r in mid), len(extra)))
    for ea, sz, _c in extra:
        if W0 <= ea < W1:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, sz)
    if extra:
        ida_auto.plan_range(W0, W1)
        ida_auto.auto_wait()
        mid2 = snap(W0, W1)
        extra2 = [r for r in mid2 if r[2] and r[0] not in want_set and W0 <= r[0] < W1]
        P("after_repair extra_code %d" % len(extra2))
        for r in extra2[:20]:
            P("  still %06X sz %d" % (r[0], r[1]))
    else:
        P("after_repair extra_code 0")

    ida_auto.auto_wait()
    final = snap(W0, W1)
    code_final = [r for r in final if r[2]]
    P("heads_final %d code_final %d" % (len(final), len(code_final)))

    # length / mnemonic cross-check; bytes stay the proof
    differ = 0
    listing = []
    by_ea = {a: (n, t) for a, n, t in want}
    for a, n, t in want:
        sz = idc.get_item_size(a)
        flags = ida_bytes.get_flags(a)
        dl = ida_lines.tag_remove(idc.generate_disasm_line(a, 0) or "")
        raw = ida_bytes.get_bytes(a, n) or b""
        okb = bytes(raw) == img[a:a + n]
        m1 = t.split()[0].lower().replace("/", ".")
        m2 = (dl.split()[0].lower().replace("/", ".") if dl else "")
        ok = okb and sz == n and ida_bytes.is_code(flags) and m1 == m2
        if not ok:
            differ += 1
            if differ <= 40:
                P("diff %06X sz %s code %s mnem %s|%s bytes %s" % (
                    a, sz, ida_bytes.is_code(flags), m1, m2, okb))
        listing.append("%06X  %s  %s" % (
            a, " ".join("%02x" % b for b in img[a:a + n]), dl))
    P("ida_match %d differ %d of %d" % (len(want) - differ, differ, len(want)))

    collar_after = {lo: snap(lo, hi) for lo, hi in COLLAR}
    drift = 0
    for lo, hi in COLLAR:
        b = {(r[0], r[1], r[2]) for r in collar_before[lo]}
        a = {(r[0], r[1], r[2]) for r in collar_after[lo]}
        for row in sorted(a - b)[:15]:
            P("collar_added %06X sz %d code %d" % row)
            drift += 1
        for row in sorted(b - a)[:15]:
            P("collar_lost %06X sz %d code %d" % row)
            drift += 1
    P("collar_drift %d" % drift)

    xref_block("after")

    with open(os.path.join(OUT, "ida-listing.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(listing) + "\n")
    with open(os.path.join(OUT, "ida-window.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(log) + "\n")
    print("\n".join(log))


try:
    _run()
except Exception:
    err = traceback.format_exc()
    with open(os.path.join(OUT, "ida-window.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(err)
    print(err)
finally:
    import idc
    idc.qexit(0)

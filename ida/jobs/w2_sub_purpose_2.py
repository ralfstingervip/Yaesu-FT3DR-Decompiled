r"""Wave-2 lane W2-4 / SLICE 2: one-line purpose for each validated, unreached,
un-purposed SUB function in the code window.

Builds the shared list L identically to sibling lanes:
  L = rows of ida\out\sub-window\functions.tsv that are validated (body|xref),
      whose start ea is NOT in ida\out\fnindex\sub-xref.tsv, and whose purpose
      is empty. Sorted by ea ascending. slice_size = ceil(len(L)/5).
Slice 2 (1-based) = L[slice_size : 2*slice_size].

For every function in slice 2 derive a one-line purpose from: callees' lane-3
purposes / known names, peripheral+RAM addresses touched, flash-data regions
referenced (font/charset/descriptor/string-pool), strings/constants, callers,
and loop shape. Non-functions (no prologue/return, or data) are rejected.

Writes ida\out\wave2\sub-purpose-2.tsv (ea end size validated how purpose evidence).

    python ida\run_job.py --script ida\jobs\w2_sub_purpose_2.py --db W2_SUBP_2 \
        --copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64
    (then iterate with --reopen)
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import csv
import math
import traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "wave2")
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", "W2_SUBP_2")
FUNCS_TSV = os.path.join(ROOT, "ida", "out", "sub-window", "functions.tsv")
XREF_TSV = os.path.join(ROOT, "ida", "out", "fnindex", "sub-xref.tsv")
TSV = os.path.join(OUT, "sub-purpose-2.tsv")
STATUS = os.path.join(LOGDIR, "status.txt")
TB = os.path.join(LOGDIR, "traceback.txt")

BASE = 0xFFC00000
WLO = 0xFFED0000
WHI = 0xFFF50000
PLO = 0x00080000
PHI = 0x00100000

# --- peripheral block table (from lane-3 subvec_periph map) ---
BLOCKS = [
    (0x00080000, 0x00080400, "SYSTEM"),
    (0x00081000, 0x00082000, "BSC"),
    (0x00082000, 0x00082200, "DMAC"),
    (0x00082200, 0x00082400, "DMAC_common"),
    (0x00082400, 0x00082800, "DTC"),
    (0x00082800, 0x00082A00, "EXDMAC_ctl"),
    (0x00082A00, 0x00082B00, "EXDMAC"),
    (0x00083000, 0x00084000, "BSC_CS"),
    (0x00087000, 0x00087100, "ICU_IR"),
    (0x00087100, 0x00087200, "ICU_DTCER"),
    (0x00087200, 0x00087300, "ICU_IER"),
    (0x00087300, 0x00087400, "ICU_IPR"),
    (0x00087400, 0x00087800, "ICU_misc"),
    (0x00087800, 0x00088000, "ICU_other"),
    (0x00088000, 0x00088020, "CMT"),
    (0x00088040, 0x00088050, "R12DA"),
    (0x00088100, 0x00088170, "TPU"),
    (0x00088200, 0x00088280, "TMR"),
    (0x00089000, 0x00089200, "S12AD0"),
    (0x0008A000, 0x0008A020, "SCI0"),
    (0x0008A040, 0x0008A060, "SCI2"),
    (0x0008A060, 0x0008A080, "SCI3"),
    (0x0008AC00, 0x0008B000, "SDHI"),
    (0x0008B000, 0x0008B100, "CAC"),
    (0x0008C000, 0x0008C100, "PORT"),
    (0x0008C100, 0x0008C200, "MPC"),
    (0x0008C400, 0x0008C500, "RTC"),
    (0x000A0000, 0x000A0400, "USB0"),
    (0x000C1200, 0x000C2000, "MTU3"),
    (0x000D0100, 0x000D0180, "RSPI"),
]

# --- flash data regions (immediate pointers into these = data-typing evidence) ---
DATA_REGIONS = [
    (0xFFEB74D8, 0xFFECE55C, "font/charset-data"),
    (0xFFECE55C, 0xFFED0000, "font/charset-data"),
    (0xFFED4644, 0xFFED46C0, "1bpp-font-master"),
    (0xFFED0000, 0xFFED3F6C, "bitmap-descriptor-tbl"),
    (0xFFED3F6C, 0xFFED5800, "UI-layout-tbl"),
    (0xFFED5800, 0xFFED8A70, "zero-heavy-tbl"),
    (0xFFF48000, 0xFFF4C000, "string-pool"),
]

# --- named RAM anchors ---
RAM_ANCHORS = [
    (0x00008E46, 0x00008E48, "IPC-pending-buf"),
    (0x00008C4D, 0x00008C60, "cam-cfg"),
    (0x00012D20, 0x00012D30, "SCI0-cb-tbl"),
    (0x00012D44, 0x00012D48, "IPC-ring-ctl"),
    (0x0001D3C8, 0x0001D3CC, "framebuf-ptr"),
    (0x000084C8, 0x000084CA, "IPC-opcode-mirror"),
]

# --- well-identified functions from docs 20/21/25/27 (callee vocabulary) ---
KNOWN = {
    0xFFEFB268: "memcpy",
    0xFFEF2184: "glyph-resolver",
    0xFFEE5269: "glyph-width",
    0xFFEF190D: "kanji-blit",
    0xFFEF1B23: "ascii-blit",
    0xFFEFA7E7: "str-renderer",
    0xFFEF0648: "rgb565-blit",
    0xFFEF68D5: "blit-chain",
    0xFFEF1F90: "lcd-blit-cfg",
    0xFFEF1DDA: "lcd-blit-start",
    0xFFEF1E28: "exdmac-isr",
    0xFFEDF1D8: "ipc-dispatch",
    0xFFEDF269: "ipc-F0-dispatch",
    0xFFEDC1F6: "ipc-dequeue",
    0xFFEF0385: "ipc-slot-copy",
    0xFFF36CA2: "ipc-pump",
    0xFFEDAB4C: "sci0-open",
    0xFFF08201: "cam-settings-scr",
    0xFFF0964A: "menu-row",
    0xFFEE1DE8: "fetch-label",
    0xFFF45DBC: "_INITSCT",
    0xFFEFA82D: "str-render-loop",
    # drawing-pipeline helpers, named from disasm this lane (see .md Findings):
    0xFFEF1C48: "ui-elem-draw",       # 5-field draw descriptor -> [0x1D3C8]
    0xFFEEF9BB: "surface-open",       # alloc 320x240x16 VRAM window, set active
    0xFFEF036F: "surface-commit",     # commit surface 0x1D3B8, bump 0x8C4C
    0xFFEEFA9E: "surface-commit-impl",
    0xFFEF002C: "draw-state-reset",   # zero [0x1D3B0]
    0xFFEF0408: "fill-rect",          # clear/fill 320-wide surface rect
    0xFFEF153B: "fill-rect-impl",
    0xFFEF0581: "ui-draw-dispatch",
    0xFFEF9D7D: "draw-setup",         # store x/y/w/h, tail into shared draw
    0xFFEFAB3E: "draw-format",        # draw+format, reads cam-cfg
    0xFFEF208D: "field-update",       # memcmp+copy, flag redraw if changed
    0xFFEEFEA4: "mark-dirty",
}


# hand-verified purposes for specific in-slice functions (disasm read this lane)
IN_SLICE_NAMES = {
    0xFFEFB2E2: "bit-position/CLZ helper: returns index of highest set bit of "
                "arg (u32), -1 if 0 (successive halfword/byte/nibble/pair/bit "
                "test + shift-accumulate)",
    0xFFEFB645: "u16 -> packed BCD: divu by 1000/100/10, pack digit nibbles "
                "(shll 0xC/8/4 | or) into a 4-nibble value (number formatter)",
    0xFFEFB430: "byte -> 2 ASCII digits at dest ptr: nibble|0x30 (&0x3F on low "
                "nibble); r3==1 blank-field mode writes '--'/'  ' for '-'/' ' "
                "(numeric display field formatter)",
}


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def block_of(addr):
    for lo, hi, name in BLOCKS:
        if lo <= addr < hi:
            return name
    return None


def data_region_of(addr):
    for lo, hi, name in DATA_REGIONS:
        if lo <= addr < hi:
            return name
    return None


def ram_anchor_of(addr):
    for lo, hi, name in RAM_ANCHORS:
        if lo <= addr < hi:
            return name
    return None


def build_L():
    xref_starts = set()
    with open(XREF_TSV, encoding="utf-8") as f:
        r = csv.reader(f, delimiter="\t")
        next(r)
        for row in r:
            if row and row[0].strip():
                xref_starts.add(row[0].strip().upper())
    L = []
    with open(FUNCS_TSV, encoding="utf-8") as f:
        r = csv.reader(f, delimiter="\t")
        next(r)
        for row in r:
            if len(row) < 6:
                row = row + [""] * (6 - len(row))
            start = row[0].strip().upper()
            validated = row[2].strip()
            purpose = row[4].strip()
            if validated in ("body", "xref") and (start not in xref_starts) and purpose == "":
                L.append(row)
    L.sort(key=lambda x: int(x[0], 16))
    return L, xref_starts


def lane3_semantic(purpose):
    """Pull a short semantic fragment ('touches ...' / 'refs ...') from a lane-3
    purpose string, else None."""
    if not purpose:
        return None
    for key in ("touches ", "refs "):
        i = purpose.find(key)
        if i >= 0:
            frag = purpose[i:]
            # cut at next ' | '
            j = frag.find(" | ")
            if j >= 0:
                frag = frag[:j]
            return frag.strip()[:40]
    return None


def main():
    import ida_bytes
    import ida_funcs
    import ida_ua
    import ida_xref
    import ida_idp
    import idautils
    import idc

    o_reg, o_mem, o_phrase, o_displ, o_imm = 1, 2, 3, 4, 5
    o_near, o_far = 7, 6
    CF_STOP = getattr(ida_idp, "CF_STOP", 0x00001)

    L, xref_starts = build_L()
    n = len(L)
    slice_size = math.ceil(n / 5)
    slice2 = L[slice_size:2 * slice_size]
    log("len(L)=%d slice_size=%d slice2=%d" % (n, slice_size, len(slice2)))
    if slice2:
        log("slice2 first=%s last=%s" % (slice2[0][0], slice2[-1][0]))

    # load lane-3 purposes for callee vocabulary
    lane3 = {}
    with open(XREF_TSV, encoding="utf-8") as f:
        r = csv.reader(f, delimiter="\t")
        next(r)
        for row in r:
            if row and row[0].strip():
                try:
                    lane3[int(row[0], 16)] = row[4] if len(row) > 4 else ""
                except ValueError:
                    pass

    all_starts = set(idautils.Functions())

    def read_str(addr):
        raw = ida_bytes.get_bytes(addr, 48)
        if not raw:
            return None
        s = bytearray()
        for c in raw:
            if c == 0:
                break
            if 0x20 <= c < 0x7F:
                s.append(c)
            else:
                return None
        if len(s) >= 4:
            return s.decode("ascii")
        return None

    def callers_of(ea):
        callers = []
        xr = ida_xref.xrefblk_t()
        ok = xr.first_to(ea, ida_xref.XREF_ALL)
        while ok:
            if xr.iscode and xr.type in (ida_xref.fl_CF, ida_xref.fl_CN,
                                          ida_xref.fl_JF, ida_xref.fl_JN):
                callers.append(xr.frm)
            ok = xr.next_to()
        return callers

    def scan(f):
        regs = {}
        periph = {}
        dataregs = {}
        ramrefs = set()
        strings = []
        callees = []
        icode = 0
        ibytes = 0
        loops = 0
        has_ret = False
        has_prologue = False
        has_tail = False
        last_flowstop = False
        any_flowstop = False
        term = ""
        lcd = False
        first = True
        ea = f.start_ea
        while ea != idc.BADADDR and ea < f.end_ea:
            fl = ida_bytes.get_flags(ea)
            if not ida_bytes.is_code(fl):
                ea = idc.next_head(ea, f.end_ea)
                regs = {}
                continue
            sz = idc.get_item_size(ea)
            icode += 1
            ibytes += sz
            insn = ida_ua.insn_t()
            if not ida_ua.decode_insn(insn, ea):
                ea = idc.next_head(ea, f.end_ea)
                continue
            mnem = (idc.print_insn_mnem(ea) or "").lower()
            feat = insn.get_canon_feature()
            last_flowstop = bool(feat & CF_STOP)
            if last_flowstop:
                any_flowstop = True
            if first:
                # RX prologue idioms: pushm/push, stack-frame allocation via
                # `sub #imm, sp` (sp = R0), or `add #-imm, sp[, sp]`.
                sp = 0
                if mnem in ("pushm", "push"):
                    has_prologue = True
                elif mnem == "sub" and insn.ops[0].type == o_imm and \
                        insn.ops[1].type == o_reg and insn.ops[1].reg == sp:
                    has_prologue = True
                elif mnem == "add" and insn.ops[0].type == o_imm and \
                        (insn.ops[0].value & 0x80000000):
                    for k in (1, 2):
                        if insn.ops[k].type == o_reg and insn.ops[k].reg == sp:
                            has_prologue = True
                first = False
            if mnem in ("rts", "rtsd", "rte"):
                has_ret = True
            if last_flowstop:
                term = mnem
            if mnem in ("bra", "jmp"):
                tgt = insn.ops[0].addr if insn.ops[0].type in (o_near, o_far) else None
                if tgt is not None and not (f.start_ea <= tgt < f.end_ea):
                    has_tail = True
            # loop shape: backward in-function branch
            if mnem.startswith("b") and insn.ops[0].type == o_near:
                tgt = insn.ops[0].addr
                if f.start_ea <= tgt <= ea:
                    loops += 1
            # operands
            for k in range(6):
                op = insn.ops[k]
                if op.type == 0:
                    break
                if op.type == o_imm:
                    v = op.value & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                    elif v < PLO:
                        a = ram_anchor_of(v)
                        if a:
                            ramrefs.add(a)
                    elif 0x06000000 <= v < 0x07000000:
                        lcd = True
                    elif 0xFFC00000 <= v <= 0xFFFFFFFF:
                        dr = data_region_of(v)
                        if dr:
                            dataregs.setdefault(dr, 0)
                            dataregs[dr] += 1
                        else:
                            s = read_str(v)
                            if s:
                                strings.append(s)
                elif op.type in (o_mem, o_far, o_near):
                    v = op.addr & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                    elif 0x06000000 <= v < 0x07000000:
                        lcd = True
                elif op.type in (o_phrase, o_displ):
                    r = op.reg
                    disp = op.value & 0xFFFFFFFF
                    if r in regs:
                        v = (regs[r] + disp) & 0xFFFFFFFF
                        if PLO <= v < PHI:
                            b = block_of(v)
                            if b:
                                periph.setdefault(b, set()).add(v)
                        elif v < PLO:
                            a = ram_anchor_of(v)
                            if a:
                                ramrefs.add(a)
                        elif 0x06000000 <= v < 0x07000000:
                            lcd = True
            # callees
            if mnem in ("bsr", "jsr"):
                tgt = None
                op0 = insn.ops[0]
                if op0.type in (o_near, o_far, o_mem):
                    tgt = op0.addr
                if tgt is not None and tgt in all_starts:
                    if tgt not in callees:
                        callees.append(tgt)
            # register tracking (mov.l #imm, rN)
            if mnem.startswith("mov") and insn.ops[0].type == o_imm and \
                    insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                regs[insn.ops[1].reg] = insn.ops[0].value & 0xFFFFFFFF
            elif mnem == "add" and insn.ops[0].type == o_imm and \
                    insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                rr = insn.ops[1].reg
                if rr in regs:
                    regs[rr] = (regs[rr] + (insn.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
            else:
                for k in range(6):
                    op = insn.ops[k]
                    if op.type == 0:
                        break
                    if op.type == o_reg and k == (1 if insn.ops[1].type != 0 else 0):
                        regs.pop(op.reg, None)
                if insn.ops[2].type == o_reg:
                    regs.pop(insn.ops[2].reg, None)
                if mnem in ("bsr", "jsr", "bra", "jmp") or mnem.startswith(("rts", "rte")):
                    regs = {}
            ea = idc.next_head(ea, f.end_ea)
        return dict(periph=periph, dataregs=dataregs, ramrefs=ramrefs,
                    strings=strings, callees=callees, icode=icode, ibytes=ibytes,
                    loops=loops, has_ret=has_ret, has_prologue=has_prologue,
                    has_tail=has_tail, last_flowstop=last_flowstop,
                    any_flowstop=any_flowstop, term=term, lcd=lcd)

    def callee_tag(cea):
        if cea in KNOWN:
            return KNOWN[cea]
        frag = lane3_semantic(lane3.get(cea, ""))
        return frag

    def compose(ea, s):
        parts = ["@%08X" % ea]
        ev = []
        # peripherals
        if s["periph"]:
            names = sorted(s["periph"], key=lambda k: -len(s["periph"][k]))
            desc = []
            for b in names[:4]:
                regs = sorted(s["periph"][b])
                desc.append("%s x%d" % (b, len(regs)))
            parts.append("touches " + ", ".join(desc))
            ev.append("periph:" + ",".join(
                "%08X" % r for b in names[:3] for r in sorted(s["periph"][b]))[:110])
        # LCD
        if s["lcd"]:
            parts.append("writes LCD-CS1(0x06000000)")
            ev.append("lcd:0x06000000")
        # data regions
        if s["dataregs"]:
            drs = sorted(s["dataregs"], key=lambda k: -s["dataregs"][k])
            parts.append("reads " + ", ".join(drs[:3]))
            ev.append("data:" + ",".join(drs[:3]))
        # ram anchors
        if s["ramrefs"]:
            parts.append("uses " + ", ".join(sorted(s["ramrefs"])[:3]))
            ev.append("ram:" + ",".join(sorted(s["ramrefs"])[:3]))
        # strings
        us = []
        seen = set()
        for st in s["strings"]:
            if st not in seen:
                seen.add(st)
                us.append(st)
        if us:
            parts.append("refs " + "; ".join('"%s"' % x for x in us[:3]))
            ev.append("str:" + "|".join(us[:3])[:110])
        # callees (with tags) + role derivation from known-callee vocabulary
        tags = []
        if s["callees"]:
            cs = s["callees"]
            tagged = []
            for c in cs[:5]:
                t = callee_tag(c)
                if t:
                    tags.append(t)
                tagged.append("%08X[%s]" % (c, t) if t else "%08X" % c)
            parts.append("calls %d (%s%s)" % (
                len(cs), ",".join(tagged), ".." if len(cs) > 5 else ""))
        # callers
        callers = callers_of(ea)
        if callers:
            uc = sorted(set(callers))
            parts.append("callers %d (%s%s)" % (
                len(uc), ",".join("%08X" % c for c in uc[:3]),
                ".." if len(uc) > 3 else ""))
            ev.append("callers:" + ",".join("%08X" % c for c in uc[:6]))
        # loop shape
        if s["loops"]:
            parts.append("loop x%d" % s["loops"])
        # role from known-callee tags (upgrades the generic wrapper label)
        DRAW = {"ascii-blit", "kanji-blit", "rgb565-blit", "str-renderer",
                "glyph-resolver", "glyph-width", "blit-chain",
                "lcd-blit-cfg", "lcd-blit-start", "str-render-loop",
                "ui-elem-draw", "surface-open", "surface-commit",
                "surface-commit-impl", "draw-state-reset", "fill-rect",
                "fill-rect-impl", "ui-draw-dispatch", "draw-setup",
                "draw-format"}
        IPCT = {"ipc-dispatch", "ipc-F0-dispatch", "ipc-dequeue",
                "ipc-slot-copy", "ipc-pump"}
        MENU = {"fetch-label", "menu-row", "cam-settings-scr"}
        CFG = {"field-update", "mark-dirty"}
        role = None
        ts = set(tags)
        if ts & DRAW:
            role = "text/graphics-draw wrapper"
        elif "memcpy" in ts:
            role = "buffer-copy wrapper"
        elif ts & IPCT:
            role = "IPC wrapper"
        elif ts & MENU:
            role = "menu/label wrapper"
        elif ts & CFG:
            role = "cfg-field apply/compare wrapper"
        # tail classification
        hard = bool(s["periph"] or s["dataregs"] or s["ramrefs"] or us or s["lcd"])
        if role:
            parts.append("[med] " + role)
        elif not hard:
            if s["callees"]:
                parts.append("[med] wrapper/dispatch")
            else:
                parts.append("[low] leaf/util")
        return " | ".join(parts), "; ".join(ev)

    rows = []
    n_purpose = 0
    n_reject = 0
    n_clean = 0
    n_frag = 0
    ibytes_purposed = 0
    cat_counts = {}

    for row in slice2:
        ea = int(row[0], 16)
        tsv_end = int(row[1], 16)
        f = ida_funcs.get_func(ea)
        if f is None or f.start_ea != ea:
            # no proper function head here -> data / over-split
            rows.append((ea, tsv_end, tsv_end - ea, "rejected", "no-func",
                         "@%08X | no function head in DB (data or mid-instruction)" % ea,
                         "no func_t at start"))
            n_reject += 1
            continue
        s = scan(f)
        size = f.end_ea - f.start_ea
        # A row is a genuine reject ONLY if it holds no decodable code (pure
        # data / a mid-instruction split producing nothing). Everything that
        # decodes to real RX instructions is purposed; boundary imperfections
        # from lane-4 over-splitting are recorded as a fragment note, not a
        # reject, because the code is real and its purpose is derivable.
        if s["icode"] == 0:
            rows.append((ea, f.end_ea, size, "rejected", "no-code",
                         "@%08X | not a function: no decodable code (data)" % ea,
                         "icode=0"))
            n_reject += 1
            continue
        owns_ret = s["has_ret"] or s["has_tail"] or s["any_flowstop"]
        clean = s["has_prologue"] and owns_ret
        if ea in IN_SLICE_NAMES:
            # hand-verified purpose overrides the auto-derived one
            _, ev = compose(ea, s)
            purpose = "@%08X | %s" % (ea, IN_SLICE_NAMES[ea])
        else:
            purpose, ev = compose(ea, s)
        if not clean:
            if s["has_prologue"] and not owns_ret:
                purpose += " | frag: falls through (no own return; over-split)"
            elif owns_ret and not s["has_prologue"]:
                purpose += " | frag: no own prologue (over-split head/mid)"
            else:
                purpose += " | frag: over-split (prologue+return in adjacent slice)"
        # 'how' = which evidence classes fed the purpose
        hows = []
        if s["periph"]:
            hows.append("periph")
        if s["lcd"]:
            hows.append("lcd")
        if s["dataregs"]:
            hows.append("data")
        if s["ramrefs"]:
            hows.append("ram")
        if s["strings"]:
            hows.append("str")
        if s["callees"]:
            hows.append("callees")
        if not hows:
            hows.append("leaf")
        how = "manual" if ea in IN_SLICE_NAMES else "+".join(hows)
        cat_counts[how] = cat_counts.get(how, 0) + 1
        term_ev = "term:%s;icode=%d;clean=%s" % (
            s["term"] or "fallthrough", s["icode"], clean)
        ev = (ev + "; " + term_ev) if ev else term_ev
        rows.append((ea, f.end_ea, size, "yes", how, purpose, ev))
        n_purpose += 1
        if clean:
            n_clean += 1
        else:
            n_frag += 1
        ibytes_purposed += s["ibytes"]

    os.makedirs(OUT, exist_ok=True)
    with open(TSV, "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tend\tsize\tvalidated\thow\tpurpose\tevidence\n")
        for ea, end, size, val, how, purpose, ev in rows:
            h.write("%08X\t%08X\t%d\t%s\t%s\t%s\t%s\n" % (
                ea, end, size, val, esc(how), esc(purpose), esc(ev)))
    log("wrote %s rows=%d purpose=%d (clean=%d frag=%d) reject=%d ibytes_purposed=%d" % (
        TSV, len(rows), n_purpose, n_clean, n_frag, n_reject, ibytes_purposed))
    log("how-categories: " + "; ".join(
        "%s=%d" % (k, v) for k, v in sorted(cat_counts.items(), key=lambda x: -x[1])))
    log("done")


if True:
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(LOGDIR, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(TB, "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)

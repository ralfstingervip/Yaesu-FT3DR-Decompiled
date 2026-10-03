r"""Wave-2 lane W2-6, SLICE 4: one-line purpose for each validated, not-yet-
purposed SUB function in slice 4 of the shared list L.

L = rows of ida\out\sub-window\functions.tsv that are validated (body|xref),
whose start ea is NOT in ida\out\fnindex\sub-xref.tsv, and whose purpose is
empty; sorted by ea; sliced into 5. Slice 4 = L[3*ceil(len/5):4*ceil(len/5)].

Derives purpose from: peripheral/RAM addresses touched (intra-fn const-prop over
mov.l #imm,rN / add #imm,rN, incl. RX o_displ disp in op.value), callees mapped
to lane-3 vocabulary, strings/constants, callers, and loop shape. Rejects bodies
that are not real functions (no return terminator / no code).

    Set-Location "."
    python ida\run_job.py --script ida\jobs\w2_sub_purpose_4.py --db W2_SUBP_4 \
        --copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64
    (then iterate with --reopen)
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import csv
import math
import os
import traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\wave2")
FUNCS_TSV = os.path.join(ROOT, r"ida\out\sub-window\functions.tsv")
XREF_TSV = os.path.join(ROOT, r"ida\out\fnindex\sub-xref.tsv")
TSV = os.path.join(OUT, "sub-purpose-4.tsv")
STATUS = os.path.join(OUT, "w2_subp4_status.txt")
COUNTS = os.path.join(OUT, "w2_subp4_counts.txt")

BASE = 0xFFC00000
WLO = 0xFFED0000
WHI = 0xFFF50000
PLO = 0x00080000       # peripheral I/O region low
PHI = 0x00100000       # peripheral I/O region high
RAMHI = 0x00080000     # on-chip RAM below peripherals
FLASH_LO = 0xFFC00000

SLICE_INDEX = 4
N_SLICES = 5

# widest-first peripheral block table (from full_l3_xref.py / subvec_periph.py).
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

# Known RAM landmarks (from docs 25/20/27/16 + this lane's disasm review).
RAM_TAGS = [
    (0x000084C8, 0x000084CA, "IPC opcode mirror"),
    (0x00008E46, 0x00008E48, "IPC pending buf"),
    (0x00008C4C, 0x00008C4D, "screen sub-state"),
    (0x00008C4D, 0x00008C53, "UI item/cfg struct"),
    (0x00012D20, 0x00012D2C, "SCI0 cb table"),
    (0x00012D44, 0x00012D48, "IPC RX ring cb"),
    (0x0001D3B8, 0x0001D3CC, "display ctx/fb ptr"),
    (0x00065E30, 0x00065E3C, "current-obj/card state"),
]

# Known callee names (from docs 25/20/27/16) -> short tag.
KNOWN = {
    0xFFEFB268: "memcpy",
    0xFFEF0385: "slot->pendbuf copy",
    0xFFEF2184: "glyph resolver(1bpp)",
    0xFFEE5269: "glyph width lookup",
    0xFFEF190D: "kanji glyph blit",
    0xFFEF1B23: "ascii glyph blit",
    0xFFEFA7E7: "string renderer",
    0xFFEF0648: "RGB565 sprite blit",
    0xFFEF68D5: "blit chain",
    0xFFEF1F90: "lcd_blit_config",
    0xFFEF1DDA: "lcd_blit_start",
    0xFFEDF1D8: "IPC opcode dispatch",
    0xFFEDF269: "IPC F0 sub-dispatch",
    0xFFEDC1F6: "IPC ring dequeue",
    0xFFEDF016: "IPC frame proc",
    0xFFF36CA2: "IPC main pump",
    0xFFF0964A: "menu row helper",
    0xFFF08201: "cam settings screen",
    0xFFEE1DE8: "fetch menu label",
    0xFFF45DBC: "_INITSCT startup",
    0xFFEDAB4C: "SCI0 open/reginit",
    0xFFF32CB5: "sdhi buffer op",
    0xFFF1EE20: "obj accessor(@65E30)",
    0xFFEF1C48: "fb draw helper",
    0xFFEF0648: "RGB565 sprite blit",
    0xFFEF0581: "fb blit primitive",
    0xFFEF036F: "draw commit",
}

# RX branch mnemonics we treat as intra-function control flow (exclude bit ops).
BR_MNEMS = {
    "bra", "beq", "bz", "bne", "bnz", "bgeu", "bc", "bltu", "bnc",
    "bgtu", "bleu", "bpz", "bn", "bge", "blt", "bgt", "ble", "bo", "bno",
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


def ram_tag(addr):
    for lo, hi, name in RAM_TAGS:
        if lo <= addr < hi:
            return name
    return None


def build_slice():
    """Recompute shared list L and return slice-4 rows and (len_L, slice_size)."""
    xref_starts = set()
    with open(XREF_TSV, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            xref_starts.add(row["start"].strip().upper())
    L = []
    with open(FUNCS_TSV, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            val = row["validated"].strip()
            start = row["start"].strip().upper()
            purp = row["purpose"].strip()
            if val in ("body", "xref") and start not in xref_starts and purp == "":
                L.append(row)
    L.sort(key=lambda x: int(x["start"], 16))
    slice_size = math.ceil(len(L) / N_SLICES)
    i = SLICE_INDEX
    sl = L[(i - 1) * slice_size:i * slice_size]
    return L, sl, slice_size


def load_xref_purposes():
    """ea(int) -> short semantic hint pulled from lane-3 sub-xref purpose."""
    d = {}
    with open(XREF_TSV, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            ea = int(row["start"], 16)
            p = row["purpose"] or ""
            hint = None
            for seg in p.split("|"):
                seg = seg.strip()
                if seg.startswith("touches "):
                    hint = seg[8:].strip()
                    break
            if hint is None:
                for seg in p.split("|"):
                    seg = seg.strip()
                    if seg.startswith("refs "):
                        hint = seg
                        break
            if hint is None:
                if "[low]" in p:
                    hint = "leaf/util"
                elif "[med]" in p:
                    hint = "wrapper"
            if hint:
                d[ea] = hint[:28]
    return d


def main():
    import ida_bytes
    import ida_funcs
    import ida_ua
    import ida_xref
    import idautils
    import idc

    o_reg, o_mem, o_phrase, o_displ, o_imm = 1, 2, 3, 4, 5
    o_near, o_far = 7, 6

    L, sl, slice_size = build_slice()
    xref_hint = load_xref_purposes()
    fstart = set(idautils.Functions())
    log("len(L)=%d slice_size=%d slice4=%d first=%s last=%s" % (
        len(L), slice_size, len(sl),
        sl[0]["start"] if sl else "-", sl[-1]["start"] if sl else "-"))
    log("DB functions=%d" % len(fstart))

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
        cs = []
        xr = ida_xref.xrefblk_t()
        ok = xr.first_to(ea, ida_xref.XREF_ALL)
        while ok:
            if xr.iscode and xr.type in (ida_xref.fl_CF, ida_xref.fl_CN,
                                         ida_xref.fl_JF, ida_xref.fl_JN):
                cs.append(xr.frm)
            ok = xr.next_to()
        return cs

    def flash_ptr_table(v):
        """True if the flash immediate v points at a dword that is itself a
        code address inside the SUB window (i.e. a function-pointer table)."""
        if not (FLASH_LO <= v < 0x100000000):
            return False
        d = ida_bytes.get_dword(v)
        return WLO <= d < WHI and d in fstart

    def scan(f):
        regs = {}
        periph = {}          # block -> set(addrs)
        ram = set()          # RAM addrs
        strings = []
        callees = set()
        flashtabs = set()    # flash fn-ptr table bases
        icode = 0
        ibytes = 0
        has_ret = False
        has_loop = False
        has_indirect = False
        prologue = False
        ndata = 0
        ea = f.start_ea
        first = True
        while ea != idc.BADADDR and ea < f.end_ea:
            fl = ida_bytes.get_flags(ea)
            if not ida_bytes.is_code(fl):
                ndata += idc.get_item_size(ea)
                ea = idc.next_head(ea, f.end_ea)
                regs = {}
                first = False
                continue
            sz = idc.get_item_size(ea)
            icode += 1
            ibytes += sz
            insn = ida_ua.insn_t()
            if not ida_ua.decode_insn(insn, ea):
                ea = idc.next_head(ea, f.end_ea)
                continue
            mnem = (idc.print_insn_mnem(ea) or "").lower()
            if first:
                # RX prologue idioms: pushm, add #-imm,sp,sp, mov.l #imm,rN, push
                if mnem in ("pushm", "push") or \
                   (mnem == "add" and insn.ops[0].type == o_imm and
                    (insn.ops[0].value & 0x80000000)) or \
                   mnem.startswith("mov") or mnem in ("sub", "and", "cmp", "mvfc"):
                    prologue = True
                first = False
            if mnem in ("rts", "rtsd", "rte"):
                has_ret = True
            # operand harvest
            for n in range(6):
                op = insn.ops[n]
                if op.type == 0:
                    break
                if op.type == o_imm:
                    v = op.value & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                    elif 0x1000 <= v < RAMHI:
                        ram.add(v)
                    elif v >= FLASH_LO:
                        s = read_str(v)
                        if s:
                            strings.append(s)
                        elif flash_ptr_table(v):
                            flashtabs.add(v)
                elif op.type in (o_mem, o_far, o_near):
                    v = op.addr & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                    elif 0x1000 <= v < RAMHI:
                        ram.add(v)
                elif op.type in (o_phrase, o_displ):
                    r = op.reg
                    disp = op.value & 0xFFFFFFFF
                    if r in regs:
                        v = (regs[r] + disp) & 0xFFFFFFFF
                        if PLO <= v < PHI:
                            b = block_of(v)
                            if b:
                                periph.setdefault(b, set()).add(v)
                        elif 0x1000 <= v < RAMHI:
                            ram.add(v)
            # callee (direct + indirect)
            if mnem in ("bsr", "jsr"):
                tgt = None
                op0 = insn.ops[0]
                if op0.type in (o_near, o_far):
                    tgt = op0.addr
                elif op0.type == o_mem:
                    tgt = op0.addr
                elif op0.type == o_reg:
                    has_indirect = True
                if tgt and tgt in fstart:
                    callees.add(tgt)
            if mnem == "jmp" and insn.ops[0].type == o_reg:
                has_indirect = True
            # backward branch => loop
            if mnem in BR_MNEMS:
                op0 = insn.ops[0]
                if op0.type in (o_near, o_far):
                    t = op0.addr
                    if f.start_ea <= t < ea and t not in fstart:
                        has_loop = True
            # register const-prop
            if mnem.startswith("mov") and insn.ops[0].type == o_imm and \
               insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                regs[insn.ops[1].reg] = insn.ops[0].value & 0xFFFFFFFF
            elif mnem == "add" and insn.ops[0].type == o_imm and \
                    insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                r = insn.ops[1].reg
                if r in regs:
                    regs[r] = (regs[r] + (insn.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
            else:
                if insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                    regs.pop(insn.ops[1].reg, None)
                elif insn.ops[0].type == o_reg and insn.ops[1].type == 0:
                    regs.pop(insn.ops[0].reg, None)
                if insn.ops[2].type == o_reg:
                    regs.pop(insn.ops[2].reg, None)
                if mnem in ("bsr", "jsr", "bra", "jmp") or mnem.startswith(("rts", "rte")):
                    regs = {}
            ea = idc.next_head(ea, f.end_ea)
        return dict(periph=periph, ram=ram, strings=strings, callees=callees,
                    flashtabs=flashtabs, has_indirect=has_indirect,
                    icode=icode, ibytes=ibytes, has_ret=has_ret,
                    has_loop=has_loop, prologue=prologue, ndata=ndata)

    def reg_name_sci(v):
        base = v & ~0x1F
        off = v - base
        m = {0: "SMR", 1: "BRR", 2: "SCR", 3: "TDR", 4: "SSR", 5: "RDR", 6: "SCMR"}
        return m.get(off, "+%x" % off)

    def periph_desc(periph):
        names = sorted(periph, key=lambda k: -len(periph[k]))
        out = []
        for b in names[:4]:
            regs = sorted(periph[b])
            if b in ("SCI0", "SCI2", "SCI3") and len(regs) <= 6:
                out.append("%s(%s)" % (b, "/".join(reg_name_sci(r) for r in regs)))
            else:
                out.append("%s x%d" % (b, len(regs)))
        return out

    def callee_desc(callees):
        named = []
        other = 0
        for c in sorted(callees):
            if c in KNOWN:
                named.append(KNOWN[c])
            elif c in xref_hint:
                named.append("%s" % xref_hint[c])
            else:
                other += 1
        return named, other

    def build_purpose(ea, s):
        parts = ["@%08X" % ea]
        ev = []
        pdescs = periph_desc(s["periph"]) if s["periph"] else []
        rams = sorted(s["ram"])
        tabs = sorted(s["flashtabs"])
        indirect = s["has_indirect"]
        # unique strings
        us = []
        seen = set()
        for x in s["strings"]:
            if x not in seen:
                seen.add(x)
                us.append(x)
        named, nother = callee_desc(s["callees"])
        how = []

        if pdescs:
            how.append("periph")
            parts.append("I/O: " + ", ".join(pdescs))
            ev.append("periph:" + ",".join("%08X" % r for b in list(s["periph"])[:4]
                                           for r in sorted(s["periph"][b]))[:100])
        # indirect dispatch through a flash function-pointer table
        if indirect and tabs:
            how.append("dispatch")
            parts.append("indirect dispatch via fn-ptr table @%08X" % tabs[0])
            ev.append("fnptr:" + ",".join("%08X" % t for t in tabs[:3]))
        elif indirect:
            how.append("dispatch")
            parts.append("indirect call/dispatch (reg target)")
        if rams:
            tagged = [r for r in rams if ram_tag(r)]
            show = (tagged + [r for r in rams if r not in tagged])[:3]
            parts.append("RAM " + ", ".join(
                ("%X(%s)" % (r, ram_tag(r))) if ram_tag(r) else ("%X" % r)
                for r in show))
            ev.append("ram:" + ",".join("%X" % r for r in rams[:5]))
            if not (pdescs or (indirect and tabs)):
                how.append("ram")
        if us:
            how.append("string")
            parts.append("refs " + "; ".join('"%s"' % x for x in us[:3]))
            ev.append("str:" + "|".join(us[:3])[:100])
        if named:
            uniq = []
            seenc = set()
            for x in named:
                if x not in seenc:
                    seenc.add(x)
                    uniq.append(x)
            parts.append("calls[%s%s]" % (
                ", ".join(uniq[:4]), (" +%d" % nother) if nother else ""))
            if "callgraph" not in how:
                how.append("callgraph")
        elif nother:
            parts.append("calls %d fn" % nother)
            how.append("callgraph")
        if s["has_loop"]:
            parts.append("loop")
        if not pdescs and not rams and not us and not s["callees"] and not indirect:
            how.append("leaf")
            parts.append("leaf/util (no periph/RAM/str/callee refs; likely "
                         "arg-only compute or reg-relative accessor)")

        # coarse role guess from evidence
        role = None
        blk = set(s["periph"].keys())
        ck = s["callees"]
        if blk & {"SCI0", "SCI2", "SCI3"}:
            role = "serial/IPC I/O"
        elif blk & {"SDHI", "DMAC", "DMAC_common"}:
            role = "SD/DMA block I/O"
        elif blk & {"EXDMAC", "EXDMAC_ctl", "BSC_CS"}:
            role = "LCD/ext-bus blit"
        elif blk & {"S12AD0", "R12DA"}:
            role = "ADC/DAC audio path"
        elif blk & {"TPU", "TMR", "CMT", "MTU3"}:
            role = "timer/PWM"
        elif blk & {"RSPI"}:
            role = "SPI I/O"
        elif blk & {"RTC"}:
            role = "RTC"
        elif blk & {"PORT", "MPC"}:
            role = "GPIO/pin"
        elif blk & {"ICU_IR", "ICU_IER", "ICU_IPR", "ICU_DTCER", "ICU_misc", "ICU_other"}:
            role = "interrupt-ctl"
        elif indirect and tabs:
            role = "state/table dispatch"
        elif any(k in KNOWN and ("glyph" in KNOWN[k] or "blit" in KNOWN[k] or
                                 "renderer" in KNOWN[k] or "screen" in KNOWN[k] or
                                 "draw" in KNOWN[k] or "menu" in KNOWN[k])
                 for k in ck):
            role = "UI draw/screen"
        elif any(k in KNOWN and "IPC" in KNOWN[k] for k in ck):
            role = "IPC handler"
        elif 0xFFEFB268 in ck:
            role = "buffer/struct copy"
        if role:
            parts.insert(1, role + ":")
        return " ".join(parts), "; ".join(ev), "+".join(how) or "none"

    rows = []
    n_purpose = 0
    n_reject = 0
    ibytes_total = 0
    role_counts = {}

    for r in sl:
        ea = int(r["start"], 16)
        validated = r["validated"].strip()
        f = ida_funcs.get_func(ea)
        if f is None or f.start_ea != ea:
            rows.append((ea, ea, 0, "rejected", "none",
                         "@%08X no function at start" % ea, "not a function (no func obj)"))
            n_reject += 1
            continue
        s = scan(f)
        size = f.end_ea - f.start_ea
        # reject: no code, or no return terminator and no callee/branch (data-like)
        if s["icode"] == 0:
            rows.append((ea, f.end_ea, size, "rejected", "none",
                         "@%08X no instructions decoded" % ea, "data / no code"))
            n_reject += 1
            continue
        if not s["has_ret"] and not s["callees"] and not s["has_loop"] \
                and not s["has_indirect"] and s["icode"] < 3:
            rows.append((ea, f.end_ea, size, "rejected", "none",
                         "@%08X %d insn, no return/callee" % (ea, s["icode"]),
                         "no prologue/return; likely over-split tail or data"))
            n_reject += 1
            continue
        purpose, ev, how = build_purpose(ea, s)
        ibytes_total += s["ibytes"]
        n_purpose += 1
        # role bucket for md
        rk = purpose.split(" ")[1] if len(purpose.split(" ")) > 1 else "misc"
        role_counts[rk] = role_counts.get(rk, 0) + 1
        rows.append((ea, f.end_ea, s["ibytes"], validated, how, purpose, ev))

    os.makedirs(OUT, exist_ok=True)
    with open(TSV, "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tend\tsize\tvalidated\thow\tpurpose\tevidence\n")
        for row in sorted(rows):
            ea, end, size, validated, how, purpose, ev = row
            h.write("%08X\t%08X\t%d\t%s\t%s\t%s\t%s\n" % (
                ea, end, size, validated, esc(how), esc(purpose), esc(ev)))
    log("wrote %s rows=%d" % (TSV, len(rows)))

    with open(COUNTS, "w", encoding="utf-8", newline="\n") as h:
        h.write("len(L)=%d slice_size=%d\n" % (len(L), slice_size))
        h.write("slice4 count=%d first=%s last=%s\n" % (
            len(sl), sl[0]["start"] if sl else "-", sl[-1]["start"] if sl else "-"))
        h.write("purposed=%d rejected=%d\n" % (n_purpose, n_reject))
        h.write("instruction bytes (purposed, item size)=%d\n" % ibytes_total)
        h.write("role buckets:\n")
        for k, v in sorted(role_counts.items(), key=lambda x: -x[1]):
            h.write("  %-24s %d\n" % (k, v))
    log("wrote counts purposed=%d rejected=%d ibytes=%d" % (
        n_purpose, n_reject, ibytes_total))
    log("done")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "w2_subp4_traceback.txt"), "w",
                  encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)

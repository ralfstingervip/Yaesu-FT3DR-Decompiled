r"""Lane W2-7 (slice 5 of 5): purpose one-liners for the un-purposed, validated,
non-xref SUB functions in the code window.

Rebuilds the shared list L identically to sibling lanes:
  L = rows of ida\out\sub-window\functions.tsv that are validated
      (col 'validated' in {xref,body}), whose start ea is NOT present in
      ida\out\fnindex\sub-xref.tsv, and whose purpose (col 5) is empty.
  Sort L by ea asc. slice_size = ceil(len(L)/5). Slice 5 = L[4*slice_size:]
  (last, takes the remainder).

For every function in slice 5 it derives a one-line purpose from: constant-prop
peripheral touches, referenced strings, callee purposes (from lane 3 sub-xref.tsv
+ lane 4 functions.tsv + a hardcoded doc map), callers, RAM/flash data refs and
loop shape. Rejects bodies that are not real functions (no return, decodes as
data). Writes ida\out\wave2\sub-purpose-5.tsv.

    python ida\run_job.py --script ida\jobs\w2_sub_purpose_5.py \
        --db W2_SUBP_5 --copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64
    (iterate with --reopen)
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import math
import os
import traceback

ROOT = str(_REPO)
FUNCS_TSV = os.path.join(ROOT, "ida", "out", "sub-window", "functions.tsv")
XREF_TSV = os.path.join(ROOT, "ida", "out", "fnindex", "sub-xref.tsv")
OUT = os.path.join(ROOT, "ida", "out", "wave2")   # only sub-purpose-5.tsv goes here
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", "W2_SUBP_5")  # bookkeeping
TSV = os.path.join(OUT, "sub-purpose-5.tsv")
STATUS = os.path.join(LOGDIR, "w2_subp5_status.txt")
COUNTS = os.path.join(LOGDIR, "w2_subp5_counts.txt")

BASE = 0xFFC00000
WLO = 0xFFED0000
WHI = 0xFFF50000
PLO = 0x00080000       # peripheral region low
PHI = 0x00100000       # peripheral region high
RAMLO = 0x00008000     # RAM globals live >=0x8000; below is offsets/constants
RAMHI = 0x00080000     # RAM below peripheral region
FLO = 0xFFC00000       # flash / mapped image low
FHI = 0xFFFFF000       # exclude 0xFFFFFxxx (negative small immediates, EXTB)

# DSP-loader / CDC-ACM service window is on MAIN, not SUB; nothing in the SUB
# code window falls in it, but keep the guard cheap: no SUB slice addr is in it.

# ---- peripheral block table (from lane 3 / subvec_periph) ----
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

# ---- hardcoded doc-derived callee names (SUB) ----
KNOWN = {
    0xFFEFB268: "memcpy(dst,src,n)",
    0xFFEF0385: "ipc-slot->0x8E46 copy",
    0xFFEF2184: "glyph-resolver",
    0xFFEE5269: "glyph-width",
    0xFFEF190D: "dbcs/kanji glyph-blit",
    0xFFEF1B23: "ascii glyph-blit",
    0xFFEFA7E7: "string-render",
    0xFFEF0648: "rgb565-blit",
    0xFFEF68D5: "blit-chain",
    0xFFEF1F90: "lcd-blit-config(EXDMAC->CS1)",
    0xFFEF1DDA: "lcd-blit-start",
    0xFFEF1E28: "exdmac-end-isr",
    0xFFEDF1D8: "ipc-opcode-dispatch",
    0xFFEDF269: "ipc-F0-subdispatch",
    0xFFEDF016: "ipc-frame-processor",
    0xFFEDC1F6: "ipc-ring-dequeue",
    0xFFF36CA2: "ipc-pump",
    0xFFEDB131: "sci0-rx-assemble",
    0xFFEDAB4C: "sci0-open/reginit",
    0xFFEDB7E7: "sci0-rxi0-isr",
    0xFFEDB857: "sci0-txi0-isr",
    0xFFEDBCDD: "grpbl0-dispatch",
    0xFFF0964A: "menu-row",
    0xFFF08201: "cam-settings-screen",
    0xFFF08826: "cam-commit-rows",
    0xFFEE1DE8: "menu-label-fetch(1-based)",
    0xFFEE2438: "glyph-metric-reader",
    0xFFEF4142: "ipc-field-apply",
    0xFFF45DBC: "_INITSCT(startup)",
    0xFFEE0D4D: "gps-$PMTK103",
    0xFFEE103B: "gps-$PMTK001",
    0xFFEB74D8: "num-scale-table",
}

o_reg, o_far, o_near, o_mem, o_phrase, o_displ, o_imm = 1, 6, 7, 2, 3, 4, 5

# immediates in the RAM range that are really bit-masks, not addresses
RAM_MASKS = {0x8000, 0x9000, 0xA000, 0xB000, 0xC000, 0xD000, 0xE000, 0xF000,
             0xFF00, 0xFF80, 0xFFC0, 0xFFE0, 0xFFF0, 0xFFF7, 0xFFF8, 0xFFF9,
             0xFFFA, 0xFFFB, 0xFFFC, 0xFFFD, 0xFFFE, 0xFFFF, 0xFEFF, 0xF0FF}


def flash_region(a):
    """Name the flash data region an address falls in (docs 10/16/lane4)."""
    if 0xFFC00000 <= a < 0xFFC3EB80:
        return "font/bitmap pixel store"
    if 0xFFC3EB80 <= a < 0xFFEB74D8:
        return "RGB565 bitmap atlas/data"
    if 0xFFEB74D8 <= a < 0xFFECE55C:
        return "text/font-index span"
    if 0xFFED0000 <= a < 0xFFED3F6C:
        return "bitmap-descriptor table"
    if 0xFFED3F6C <= a < 0xFFED5800:
        return "UI layout table"
    if 0xFFED5800 <= a < 0xFFED8A70:
        return "sparse config table"
    if 0xFFED8A70 <= a < 0xFFED8E70:
        return "INTB vector table"
    if 0xFFF48000 <= a < 0xFFF4C000:
        return "string pool"
    return "flash table"

BRANCH_C = {"beq", "bne", "bc", "bnc", "bgtu", "bleu", "bpz", "bn",
            "bge", "blt", "bgt", "ble", "bo", "bno", "bra", "bra.a",
            "bra.b", "bra.w", "bra.l"}
RET = ("rts", "rtsd", "rte", "rtfi", "rtsdi")


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


def sci_reg(v):
    for b, base in (("SCI0", 0x0008A000), ("SCI2", 0x0008A040), ("SCI3", 0x0008A060)):
        if base <= v < base + 0x20:
            m = {0: "SMR", 1: "BRR", 2: "SCR", 3: "TDR", 4: "SSR", 5: "RDR", 0xC: "SEMR"}
            return "%s.%s" % (b, m.get(v - base, "+%X" % (v - base)))
    return None


DMAC_R = {0x00: "DMSAR", 0x04: "DMDAR", 0x08: "DMCRA", 0x0C: "DMCRB",
          0x10: "DMTMD", 0x13: "DMINT", 0x14: "DMAMD", 0x18: "DMOFR",
          0x1C: "DMCNT", 0x1D: "DMREQ", 0x1E: "DMSTS", 0x1F: "DMSTS"}
SDHI_R = {0x00: "SDCMD", 0x08: "SDARG", 0x0C: "SDARG1", 0x10: "SDSTOP",
          0x14: "SDBLKCNT", 0x18: "SDRSP10", 0x20: "SDRSP32", 0x28: "SDRSP54",
          0x38: "SDSTS1", 0x3C: "SDSTS2", 0x40: "SDIMSK1", 0x44: "SDIMSK2",
          0x48: "SDCLKCR", 0x4C: "SDSIZE", 0x50: "SDOPT", 0x58: "SDERSTS1",
          0x5C: "SDERSTS2", 0x60: "SDBUFR", 0xE0: "SDDMAEN", 0xE4: "SDRST",
          0xE8: "SDVER", 0xF8: "SDSWAP"}
SYS_R = {0x00: "MDMONR", 0x06: "SYSCR0", 0x08: "SYSCR1", 0x0C: "SBYCR",
         0x10: "MSTPCRA", 0x14: "MSTPCRB", 0x18: "MSTPCRC", 0x1C: "MSTPCRD",
         0x20: "SCKCR", 0x24: "SCKCR2", 0x26: "SCKCR3", 0x3FE: "PRCR"}


def periph_reg(b, v):
    """Return a register name for the confident blocks, else None."""
    if b == "DMAC":
        off = v - 0x00082000
        ch = off // 0x40
        r = off % 0x40
        return "DMAC%d.%s" % (ch, DMAC_R.get(r, "+%X" % r))
    if b == "DMAC_common":
        return "DMAC.DMAST" if v == 0x00082200 else "DMAC_cmn+%X" % (v - 0x00082200)
    if b == "SDHI":
        return "SDHI.%s" % SDHI_R.get(v - 0x0008AC00, "+%X" % (v - 0x0008AC00))
    if b == "SYSTEM":
        return "SYS.%s" % SYS_R.get(v - 0x00080000, "+%X" % (v - 0x00080000))
    if b == "ICU_IER":
        return "IER[%02X]" % (v - 0x00087200)
    if b == "ICU_IPR":
        return "IPR[%02X]" % (v - 0x00087300)
    if b in ("SCI0", "SCI2", "SCI3"):
        return sci_reg(v)
    return None


def build_L():
    xref_starts = set()
    xref_purpose = {}
    with open(XREF_TSV, encoding="utf-8") as f:
        next(f)
        for line in f:
            p = line.rstrip("\n").split("\t")
            if len(p) < 5:
                continue
            ea = int(p[0], 16)
            xref_starts.add(ea)
            xref_purpose[ea] = p[4]
    L = []
    body_purpose = {}
    with open(FUNCS_TSV, encoding="utf-8") as f:
        next(f)
        for line in f:
            p = line.rstrip("\n").split("\t")
            if len(p) < 5:
                continue
            start = int(p[0], 16)
            end = int(p[1], 16)
            validated = p[2].strip()
            purpose = p[4].strip()
            if purpose:
                body_purpose[start] = purpose
            if validated in ("xref", "body") and start not in xref_starts and purpose == "":
                L.append((start, end))
    L.sort(key=lambda x: x[0])
    return L, xref_starts, xref_purpose, body_purpose


def short_xref_purpose(p):
    """Turn a lane-3 sub-xref purpose string into a short callee label."""
    if not p:
        return None
    parts = [seg.strip() for seg in p.split("|")]
    touches = None
    refs = None
    tag = None
    for seg in parts:
        if seg.startswith("touches "):
            touches = seg[len("touches "):]
        elif seg.startswith("refs "):
            refs = seg
        elif seg.startswith("[med]") or seg.startswith("[low]"):
            tag = seg.split("]", 1)[1].strip()
    if touches:
        return touches.split(",")[0].strip()
    if refs:
        return refs[:32]
    return tag


def main():
    import ida_bytes
    import ida_funcs
    import ida_ua
    import ida_xref
    import idautils
    import idc

    L, xref_starts, xref_purpose, body_purpose = build_L()
    slice_size = math.ceil(len(L) / 5)
    myslice = L[4 * slice_size:]
    log("len(L)=%d slice_size=%d slice5=%d first=%08X last=%08X" % (
        len(L), slice_size, len(myslice),
        myslice[0][0], myslice[-1][0]))

    fstart = set(idautils.Functions())

    def callee_label(ea):
        if ea in KNOWN:
            return KNOWN[ea]
        if ea in body_purpose:
            return body_purpose[ea]
        if ea in xref_purpose:
            s = short_xref_purpose(xref_purpose[ea])
            if s:
                return s
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

    def flow_pred(ea):
        """fall-through predecessor (fl_F) -> the routine this frag continues."""
        xr = ida_xref.xrefblk_t()
        ok = xr.first_to(ea, ida_xref.XREF_ALL)
        while ok:
            if xr.iscode and xr.type == ida_xref.fl_F:
                pf = ida_funcs.get_func(xr.frm)
                return pf.start_ea if pf else xr.frm
            ok = xr.next_to()
        return None

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

    def scan(f):
        regs = {}
        periph = {}          # block -> set of resolved addrs
        strings = []
        callees = []          # ordered unique
        callee_seen = set()
        ram = set()
        flashdata = set()
        icode = 0
        ibytes = 0
        ninsn = 0
        back = 0             # backward branches (loop shape)
        has_ret = False
        term = None
        last_ea = None
        first_mnem = None
        first_is_prologue = False
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
            ninsn += 1
            last_ea = ea
            mnem = (idc.print_insn_mnem(ea) or "").lower()
            if first_mnem is None:
                first_mnem = mnem
                # recognized CC-RX prologue: pushm; sub #imm,sp; add #-imm,sp,sp;
                # mov.l #imm,rN (dark-code entry). NOT 'add #imm,sp,rN' (arg setup).
                if mnem == "pushm":
                    first_is_prologue = True
                elif mnem == "sub" and insn.ops[1].type == o_reg and insn.ops[1].reg == 0:
                    first_is_prologue = True
                elif mnem == "add" and insn.ops[0].type == o_imm and \
                        (insn.ops[0].value & 0x80000000) and \
                        insn.ops[1].type == o_reg and insn.ops[1].reg == 0 and \
                        (insn.ops[2].type == 0 or (insn.ops[2].type == o_reg and insn.ops[2].reg == 0)):
                    first_is_prologue = True
                elif mnem.startswith("mov") and insn.ops[0].type == o_imm and \
                        insn.ops[1].type == o_reg:
                    first_is_prologue = True
            if mnem.startswith(RET):
                has_ret = True
                term = mnem
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
                    elif FLO <= v < FHI:
                        s = read_str(v)
                        if s:
                            strings.append(s)
                        elif v not in fstart and ida_bytes.is_loaded(v):
                            flashdata.add(v)
                    elif RAMLO <= v < RAMHI and v not in RAM_MASKS:
                        ram.add(v)
                elif op.type in (o_mem, o_far, o_near):
                    v = op.addr & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                elif op.type in (o_phrase, o_displ):
                    r = op.reg
                    disp = op.value & 0xFFFFFFFF
                    if r in regs:
                        v = (regs[r] + disp) & 0xFFFFFFFF
                        if PLO <= v < PHI:
                            b = block_of(v)
                            if b:
                                periph.setdefault(b, set()).add(v)
            # branch target -> loop shape
            if mnem in BRANCH_C:
                tgt = None
                op0 = insn.ops[0]
                if op0.type in (o_near, o_far):
                    tgt = op0.addr
                if tgt is not None and f.start_ea <= tgt <= ea and tgt < ea:
                    back += 1
            # callees
            if mnem in ("bsr", "jsr", "jmp") or mnem.startswith("bsr"):
                op0 = insn.ops[0]
                tgt = op0.addr if op0.type in (o_near, o_far, o_mem) else None
                if tgt and tgt in fstart and tgt != f.start_ea:
                    if tgt not in callee_seen:
                        callee_seen.add(tgt)
                        callees.append(tgt)
            # reg tracking
            if mnem.startswith("mov") and insn.ops[0].type == o_imm and \
                    insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                regs[insn.ops[1].reg] = insn.ops[0].value & 0xFFFFFFFF
            elif mnem == "add" and insn.ops[0].type == o_imm and \
                    insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                r = insn.ops[1].reg
                if r in regs:
                    regs[r] = (regs[r] + (insn.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
            else:
                if insn.ops[1].type == o_reg:
                    regs.pop(insn.ops[1].reg, None)
                elif insn.ops[0].type == o_reg:
                    regs.pop(insn.ops[0].reg, None)
                if insn.ops[2].type == o_reg:
                    regs.pop(insn.ops[2].reg, None)
                if mnem in ("bsr", "jsr", "bra", "jmp") or mnem.startswith(("rts", "rte")):
                    regs = {}
            ea = idc.next_head(ea, f.end_ea)
        # terminator: also count tail branch at end
        if not has_ret and last_ea is not None:
            lm = (idc.print_insn_mnem(last_ea) or "").lower()
            if lm in ("bra", "jmp", "bra.a", "bra.w", "bra.b", "bra.l"):
                term = lm + "(tail)"
        return dict(periph=periph, strings=strings, callees=callees, ram=ram,
                    flashdata=flashdata, icode=icode, ibytes=ibytes,
                    ninsn=ninsn, back=back, has_ret=has_ret, term=term,
                    first_mnem=first_mnem, first_is_prologue=first_is_prologue)


    GENERIC = ("wrapper/dispatch", "leaf/util", "unserviced interrupt stub")

    def compose(ea, end, sc, callers, kind):
        parts = ["@%08X" % ea]
        if kind == "frag":
            parts.append("[frag: over-split code, no own return]")
        ev = []
        how = []
        periph = sc["periph"]
        # peripherals (strongest semantic signal)
        if periph:
            how.append("periph")
            names = sorted(periph, key=lambda k: -len(periph[k]))
            desc = []
            for b in names[:4]:
                regs = sorted(periph[b])
                rn = [periph_reg(b, r) for r in regs]
                if all(rn) and len(regs) <= 6:
                    # dedupe register names, keep block prefix once
                    uniq = []
                    for x in rn:
                        if x not in uniq:
                            uniq.append(x)
                    desc.append("/".join(uniq)[:56])
                else:
                    desc.append("%s x%d" % (b, len(regs)))
            parts.append("touches " + ", ".join(desc))
            allr = [r for b in names[:4] for r in sorted(periph[b])]
            ev.append("periph:" + ",".join("%X" % r for r in allr[:8]))
        # strings (strong semantic signal)
        us = []
        seen = set()
        for s in sc["strings"]:
            if s not in seen:
                seen.add(s)
                us.append(s)
        if us:
            how.append("strings")
            parts.append("refs " + "; ".join('"%s"' % s for s in us[:3]))
            ev.append("str:" + "|".join(us[:4])[:140])
        # callees: split named (semantic) vs generic/unknown
        named = []
        generic = []
        for c in sc["callees"]:
            lab = callee_label(c)
            if lab and lab not in GENERIC and not lab.startswith("["):
                named.append("%s@%06X" % (lab, c & 0xFFFFFF))
            else:
                generic.append(c)
        callphrase = []
        if named:
            how.append("callees")
            callphrase.append(", ".join(named[:4]) + ("..." if len(named) > 4 else ""))
        if generic:
            if not named:
                how.append("callgraph")
            callphrase.append("%d helper(s) (%s%s)" % (
                len(generic), ",".join("%06X" % (c & 0xFFFFFF) for c in generic[:3]),
                ".." if len(generic) > 3 else ""))
        if callphrase:
            parts.append("calls " + "; ".join(callphrase))
        allc = sc["callees"]
        if allc:
            ev.append("callees:" + ",".join("%X" % c for c in allc[:8]))
        # RAM struct / flash tables (secondary evidence)
        if sc["ram"]:
            r = sorted(sc["ram"])
            ev.append("ram:" + ",".join("%X" % x for x in r[:6]))
        if sc["flashdata"]:
            fd = sorted(sc["flashdata"])
            ev.append("flashtbl:" + ",".join("%X" % x for x in fd[:6]))
        # loop shape
        shape = "loops(%d)" % sc["back"] if sc["back"] else "straight-line"
        # callers
        if callers:
            ev.append("callers:" + ",".join("%X" % c for c in callers[:6]))
        # fallback characterisation when no periph/string/named-callee
        if not periph and not us and not named and not generic:
            how.append("leaf")
            if sc["flashdata"] and not sc["ram"]:
                fd = sorted(sc["flashdata"])
                regs = []
                for x in fd:
                    r = flash_region(x)
                    if r not in regs:
                        regs.append(r)
                parts.append("leaf: reads %s (%s)" % (
                    "/".join(regs[:2]),
                    ",".join("%06X" % (x & 0xFFFFFF) for x in fd[:2])))
            elif sc["ram"]:
                parts.append("leaf: RAM accessor @%06X" % (sorted(sc["ram"])[0] & 0xFFFFFF))
            else:
                parts.append("leaf/util (%d insn)" % sc["ninsn"])
        elif not periph and not us and not named and generic:
            # only generic helpers -> mark it clearly as a wrapper
            parts.append("(wrapper/glue)")
        parts.append(shape)
        purpose = " | ".join(parts)
        return purpose, "; ".join(ev), (",".join(how) or "structural")

    rows = []
    n_func = 0        # clean functions (validated=yes)
    n_frag = 0        # code fragments (validated=frag)
    n_reject = 0      # data / degenerate (validated=no)
    ibytes_purposed = 0     # yes + frag
    ibytes_func = 0
    for start, end in myslice:
        f = ida_funcs.get_func(start)
        if f is None or f.start_ea != start:
            rows.append((start, end, end - start, "no", "reject",
                         "@%08X rejected: no function head at start" % start, ""))
            n_reject += 1
            continue
        sc = scan(f)
        span = f.end_ea - start
        code_frac = (sc["ibytes"] / span) if span else 0.0
        # data / degenerate: no code, or mostly non-code
        if sc["icode"] == 0 or code_frac < 0.5:
            rows.append((start, f.end_ea, sc["ibytes"], "no", "reject",
                         "@%08X rejected: not code (code_frac=%.2f, insn=%d)" % (
                             start, code_frac, sc["ninsn"]), ""))
            n_reject += 1
            continue
        # clean function: contains a return, or ends in a tail branch
        clean = sc["has_ret"] or (sc["term"] and "tail" in sc["term"])
        kind = "yes" if clean else "frag"
        callers = callers_of(start)
        purpose, ev, how = compose(start, f.end_ea, sc, callers, kind)
        if kind == "frag":
            pred = flow_pred(start)
            if pred is not None:
                ev = (ev + "; " if ev else "") + "cont-of:%X" % pred
        rows.append((start, f.end_ea, sc["ibytes"], kind, how, purpose, ev))
        ibytes_purposed += sc["ibytes"]
        if kind == "yes":
            n_func += 1
            ibytes_func += sc["ibytes"]
        else:
            n_frag += 1

    os.makedirs(OUT, exist_ok=True)
    with open(TSV, "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tend\tsize\tvalidated\thow\tpurpose\tevidence\n")
        for start, end, size, val, how, purpose, ev in rows:
            h.write("%08X\t%08X\t%d\t%s\t%s\t%s\t%s\n" % (
                start, end, size, val, esc(how), esc(purpose), esc(ev)))
    log("wrote %s rows=%d" % (TSV, len(rows)))

    n_purpose = n_func + n_frag
    with open(COUNTS, "w", encoding="utf-8", newline="\n") as h:
        h.write("len(L)=%d\n" % len(L))
        h.write("slice_size=%d\n" % slice_size)
        h.write("slice5 count=%d first=%08X last=%08X\n" % (
            len(myslice), myslice[0][0], myslice[-1][0]))
        h.write("purposed=%d (clean-func=%d + code-frag=%d)\n" % (n_purpose, n_func, n_frag))
        h.write("rejected(data/degenerate)=%d\n" % n_reject)
        h.write("instruction bytes of purposed (sum item size)=%d\n" % ibytes_purposed)
        h.write("instruction bytes of clean-func only=%d\n" % ibytes_func)
    log("done func=%d frag=%d reject=%d ibytes=%d" % (
        n_func, n_frag, n_reject, ibytes_purposed))


if True:
    import ida_auto
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(LOGDIR, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        ida_auto.auto_wait()
        main()
    except Exception:
        with open(os.path.join(LOGDIR, "w2_subp5_traceback.txt"), "w",
                  encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)

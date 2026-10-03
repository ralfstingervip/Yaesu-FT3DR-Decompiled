r"""SUB-VEC pass B: peripheral-register map for the FT3DR SUB (RX64M) image.

Walks every defined instruction in the database, does a light intra-function
constant propagation over `mov.l #imm, rN` / `add #imm, rN`, and resolves every
peripheral access in 0x00080000-0x000FFFFF whether it is a bare immediate, a
[rN] dereference or a disp[rN] dereference.  Then decodes the ICU IR/IER/IPR
accesses back into interrupt vector numbers, and reports the module-stop
register writes.

    python ida/run_job.py --script ida\jobs\subvec_periph.py \
        --db SUB_VEC --reopen
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

OUT = str(_REPO / "ida/out/sub-vec")
BASE = 0xFFC00000
TOP = 0x100000000
PLO = 0x00080000
PHI = 0x00100000
STATUS = os.path.join(OUT, "passB_status.txt")

# RX64M peripheral block bases, widest-first match.  Source: brief seeds plus
# the identifications this pass confirms.  Marked in the output so a reader can
# tell block naming (external) from the address (confirmed).
BLOCKS = [
    (0x00080000, 0x00080400, "SYSTEM"),
    (0x00080400, 0x00080800, "SYSTEM/PRC"),
    (0x00081000, 0x00082000, "BSC"),
    (0x00082000, 0x00082200, "DMAC0-7"),
    (0x00082200, 0x00082400, "DMAC_common"),
    (0x00082400, 0x00082800, "DTC"),
    (0x00082800, 0x00082A00, "0x82800_blk"),
    (0x00082A00, 0x00082B00, "EXDMAC"),
    (0x00083000, 0x00084000, "MPU/other"),
    (0x00087000, 0x00087100, "ICU_IR"),
    (0x00087100, 0x00087200, "ICU_DTCER"),
    (0x00087200, 0x00087300, "ICU_IER"),
    (0x00087300, 0x00087400, "ICU_IPR"),
    (0x00087400, 0x00087500, "ICU_misc"),
    (0x00087500, 0x00087600, "ICU_IRQCR"),
    (0x00087600, 0x00087700, "ICU_GRPBE/GRPBL"),
    (0x00087700, 0x00087800, "ICU_GEN/GCR"),
    (0x00087800, 0x00087900, "ICU_GRPAL"),
    (0x00087900, 0x00088000, "ICU_other"),
    (0x00088000, 0x00088020, "CMT0-3"),
    (0x00088020, 0x00088030, "WDT"),
    (0x00088030, 0x00088040, "IWDT"),
    (0x00088040, 0x00088100, "DA/other"),
    (0x00088100, 0x00088110, "TPU_TSTR"),
    (0x00088110, 0x00088120, "TPU0"),
    (0x00088120, 0x00088130, "TPU1"),
    (0x00088130, 0x00088140, "TPU2"),
    (0x00088140, 0x00088150, "TPU3"),
    (0x00088150, 0x00088160, "TPU4"),
    (0x00088160, 0x00088170, "TPU5"),
    (0x00088170, 0x00088200, "TPU/PPG"),
    (0x00088200, 0x00088280, "TMR0-3"),
    (0x00088280, 0x00088300, "CRC"),
    (0x00088300, 0x00088340, "RIIC0"),
    (0x00088340, 0x00088380, "RIIC1"),
    (0x00088380, 0x000883C0, "RIIC2"),
    (0x000883C0, 0x00088500, "RIIC3/other"),
    (0x00088500, 0x00088600, "MMCIF"),
    (0x00088600, 0x00089000, "0x88600_blk"),
    (0x00089000, 0x00089100, "S12AD0"),
    (0x00089100, 0x00089200, "S12AD0_ext"),
    (0x00089200, 0x00089400, "S12AD1"),
    (0x00089400, 0x0008A000, "ADC/other"),
    (0x0008A000, 0x0008A020, "SCI0"),
    (0x0008A020, 0x0008A040, "SCI1"),
    (0x0008A040, 0x0008A060, "SCI2"),
    (0x0008A060, 0x0008A080, "SCI3"),
    (0x0008A080, 0x0008A0A0, "SCI4"),
    (0x0008A0A0, 0x0008A0C0, "SCI5"),
    (0x0008A0C0, 0x0008A0E0, "SCI6"),
    (0x0008A0E0, 0x0008A100, "SCI7"),
    (0x0008A100, 0x0008AC00, "SCI/other"),
    (0x0008AC00, 0x0008B000, "SDHI"),
    (0x0008B000, 0x0008B100, "CAC"),
    (0x0008B100, 0x0008B300, "ELC/other"),
    (0x0008B300, 0x0008B320, "SCI12"),
    (0x0008B320, 0x0008C000, "0x8B320_blk"),
    (0x0008C000, 0x0008C100, "PORT"),
    (0x0008C100, 0x0008C200, "MPC"),
    (0x0008C200, 0x0008C400, "PORT/other"),
    (0x0008C400, 0x0008C500, "RTC"),
    (0x0008C500, 0x00090000, "0x8C500_blk"),
    (0x00090000, 0x00094000, "CAN/other"),
    (0x00094200, 0x00094280, "CMTW0"),
    (0x00094280, 0x00094300, "CMTW1"),
    (0x000A0000, 0x000A0400, "USB0"),
    (0x000A0400, 0x000A0500, "USB_other"),
    (0x000A0500, 0x000A0600, "PDC"),
    (0x000A0600, 0x000C0000, "0xA0600_blk"),
    (0x000C0000, 0x000C0400, "ETHERC0"),
    (0x000C0400, 0x000C1200, "EDMAC/other"),
    (0x000C1200, 0x000C1400, "MTU3"),
    (0x000D0000, 0x000D0100, "USBA"),
    (0x000D0100, 0x000D0140, "RSPI0"),
    (0x000D0140, 0x000D0180, "RSPI1"),
    (0x000D0180, 0x000E0000, "0xD0180_blk"),
]

SCI_REG = {0: "SMR", 1: "BRR", 2: "SCR", 3: "TDR", 4: "SSR", 5: "RDR",
           6: "SCMR", 7: "SEMR", 8: "SNFR", 9: "SIMR1", 0xA: "SIMR2",
           0xB: "SIMR3", 0xC: "SISR", 0xD: "SPMR", 0xE: "TDRHL", 0x10: "RDRHL",
           0x12: "MDDR"}
TPU_REG = {0: "TCR", 1: "TMDR", 2: "TIORH", 3: "TIORL", 4: "TIER", 5: "TSR",
           6: "TCNT", 8: "TGRA", 0xA: "TGRB", 0xC: "TGRC", 0xE: "TGRD"}


def log(text):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as handle:
        handle.write(text + "\n")


def esc(text):
    return (text or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def block_of(addr):
    for lo, hi, name in BLOCKS:
        if lo <= addr < hi:
            return name
    return "unmapped_periph"


def reg_of(addr):
    b = block_of(addr)
    if b.startswith("SCI") and b[3:].isdigit():
        lo = [x for x in BLOCKS if x[2] == b][0][0]
        return SCI_REG.get(addr - lo, "+%#x" % (addr - lo))
    if b.startswith("TPU") and b[3:].isdigit():
        lo = [x for x in BLOCKS if x[2] == b][0][0]
        return TPU_REG.get(addr - lo, "+%#x" % (addr - lo))
    if b == "ICU_IR":
        return "IR[%d]" % (addr - 0x00087000)
    if b == "ICU_IER":
        return "IER[%d]" % (addr - 0x00087200)
    if b == "ICU_IPR":
        return "IPR[%d]" % (addr - 0x00087300)
    if b == "ICU_DTCER":
        return "DTCER[%d]" % (addr - 0x00087100)
    if addr == 0x00080010:
        return "MSTPCRA"
    if addr == 0x00080014:
        return "MSTPCRB"
    if addr == 0x00080018:
        return "MSTPCRC"
    if addr == 0x0008001C:
        return "MSTPCRD"
    if addr == 0x000803FE:
        return "PRCR"
    if b == "USB0":
        off = addr - 0x000A0000
        names = {0x00: "SYSCFG", 0x04: "SYSSTS0", 0x08: "DVSTCTR0",
                 0x14: "CFIFO", 0x18: "D0FIFO", 0x1C: "D1FIFO",
                 0x20: "CFIFOSEL", 0x22: "CFIFOCTR", 0x28: "D0FIFOSEL",
                 0x2A: "D0FIFOCTR", 0x2C: "D1FIFOSEL", 0x2E: "D1FIFOCTR",
                 0x30: "INTENB0", 0x32: "INTENB1", 0x36: "BRDYENB",
                 0x38: "NRDYENB", 0x3A: "BEMPENB", 0x3C: "SOFCFG",
                 0x40: "INTSTS0", 0x42: "INTSTS1", 0x46: "BRDYSTS",
                 0x48: "NRDYSTS", 0x4A: "BEMPSTS", 0x4C: "FRMNUM",
                 0x50: "USBREQ", 0x52: "USBVAL", 0x54: "USBINDX",
                 0x56: "USBLENG", 0x58: "DCPCFG", 0x5A: "DCPMAXP",
                 0x5C: "DCPCTR", 0x64: "PIPESEL", 0x68: "PIPECFG",
                 0x6C: "PIPEMAXP", 0x6E: "PIPEPERI"}
        return names.get(off, "+%#x" % off)
    return ""


def main():
    import ida_bytes
    import ida_funcs
    import ida_segment
    import ida_ua
    import idautils
    import idc

    o_reg, o_phrase, o_displ, o_imm, o_mem, o_near, o_far = 1, 3, 4, 5, 2, 7, 6

    funcs = list(idautils.Functions())
    log("functions %d" % len(funcs))

    rows = []          # (ea, func, mnem, opn, form, addr, text, full)
    icu = []
    unresolved = 0

    def scan_range(start, end, fname):
        nonlocal unresolved
        regs = {}
        ea = start
        while ea != idc.BADADDR and ea < end:
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                ea = idc.next_head(ea, end)
                regs = {}
                continue
            insn = ida_ua.insn_t()
            if not ida_ua.decode_insn(insn, ea):
                ea = idc.next_head(ea, end)
                continue
            mnem = idc.print_insn_mnem(ea) or ""
            full = esc(idc.generate_disasm_line(ea, 0) or "")
            # any operand referencing the peripheral window
            for n in range(6):
                op = insn.ops[n]
                if op.type == 0:
                    break
                txt = esc(idc.print_operand(ea, n) or "")
                if op.type == o_imm:
                    v = op.value & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        rows.append((ea, fname, mnem, n, "imm", v, txt, full))
                elif op.type in (o_mem, o_far, o_near):
                    v = op.addr & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        rows.append((ea, fname, mnem, n, "mem", v, txt, full))
                elif op.type in (o_phrase, o_displ):
                    r = op.reg
                    disp = op.value & 0xFFFFFFFF
                    if r in regs:
                        v = (regs[r] + disp) & 0xFFFFFFFF
                        if PLO <= v < PHI:
                            rows.append((ea, fname, mnem, n, "reg+disp", v, txt, full))
                    elif "[sp]" not in txt and "[r0]" not in txt:
                        unresolved += 1
            # update the tracked registers
            if mnem.startswith("mov") and insn.ops[0].type == o_imm and insn.ops[1].type == o_reg:
                regs[insn.ops[1].reg] = insn.ops[0].value & 0xFFFFFFFF
            elif mnem == "add" and insn.ops[0].type == o_imm and insn.ops[1].type == o_reg and insn.ops[2].type == 0:
                r = insn.ops[1].reg
                if r in regs:
                    regs[r] = (regs[r] + (insn.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
            else:
                # invalidate every register this instruction writes
                for n in range(6):
                    op = insn.ops[n]
                    if op.type == 0:
                        break
                    if op.type == o_reg and n == (1 if insn.ops[1].type != 0 else 0):
                        regs.pop(op.reg, None)
                if insn.ops[2].type == o_reg:
                    regs.pop(insn.ops[2].reg, None)
                if mnem in ("bsr", "jsr", "bra", "jmp") or mnem.startswith(("rts", "rte")):
                    regs = {}
            ea = idc.next_head(ea, end)

    for start in funcs:
        f = ida_funcs.get_func(start)
        if f is None:
            continue
        scan_range(f.start_ea, f.end_ea, idc.get_func_name(start) or "")

    # code outside any function
    seg = ida_segment.get_first_seg()
    orphan = 0
    while seg is not None:
        ea = seg.start_ea
        while ea != idc.BADADDR and ea < seg.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_funcs.get_func(ea) is None:
                nxt = ea
                end = ea
                while nxt != idc.BADADDR and nxt < seg.end_ea and \
                        ida_bytes.is_code(ida_bytes.get_flags(nxt)) and ida_funcs.get_func(nxt) is None:
                    end = nxt + max(1, idc.get_item_size(nxt))
                    nxt = idc.next_head(nxt, seg.end_ea)
                scan_range(ea, end, "orphan_%08X" % ea)
                orphan += 1
                ea = nxt
            else:
                ea = idc.next_head(ea, seg.end_ea)
        seg = ida_segment.get_next_seg(seg.start_ea)
    log("orphan code runs %d" % orphan)
    log("periph access rows %d unresolved_indirect %d" % (len(rows), unresolved))

    with open(os.path.join(OUT, "periph_map.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("periph_addr\tblock\treg\tform\tinsn_ea\tinsn_file_off\tfunction\tmnem\topnd\toperand_text\tdisasm\n")
        for ea, fname, mnem, n, form, addr, txt, full in sorted(rows, key=lambda r: (r[5], r[0])):
            h.write("%08X\t%s\t%s\t%s\t%08X\t%06X\t%s\t%s\t%d\t%s\t%s\n" % (
                addr, block_of(addr), reg_of(addr), form, ea, ea - BASE,
                fname, mnem, n, txt, full))
    log("wrote periph_map.tsv")

    # distinct-address rollup
    seen = {}
    for ea, fname, mnem, n, form, addr, txt, full in rows:
        seen.setdefault(addr, []).append((ea, fname, form, full))
    with open(os.path.join(OUT, "periph_addrs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("periph_addr\tblock\treg\thits\tfunctions\tfirst_insn_ea\tfirst_disasm\n")
        for addr in sorted(seen):
            hits = seen[addr]
            fns = sorted({x[1] for x in hits})
            h.write("%08X\t%s\t%s\t%d\t%s\t%08X\t%s\n" % (
                addr, block_of(addr), reg_of(addr), len(hits),
                ",".join(fns[:8]) + ("..." if len(fns) > 8 else ""),
                hits[0][0], hits[0][3]))
    log("wrote periph_addrs.tsv distinct %d" % len(seen))

    # block rollup
    with open(os.path.join(OUT, "periph_blocks.tsv"), "w", encoding="utf-8", newline="\n") as h:
        agg = {}
        for addr in seen:
            b = block_of(addr)
            agg.setdefault(b, [0, 0])
            agg[b][0] += 1
            agg[b][1] += len(seen[addr])
        h.write("block\tdistinct_addrs\ttotal_accesses\tlow\thigh\n")
        for b in sorted(agg, key=lambda k: -agg[k][1]):
            addrs = [a for a in seen if block_of(a) == b]
            h.write("%s\t%d\t%d\t%08X\t%08X\n" % (b, agg[b][0], agg[b][1], min(addrs), max(addrs)))
    log("wrote periph_blocks.tsv")

    # ICU decode -> vector numbers
    with open(os.path.join(OUT, "icu_vectors.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("periph_addr\treg\timplied_vectors\tinsn_ea\tfunction\tdisasm\n")
        for ea, fname, mnem, n, form, addr, txt, full in sorted(rows, key=lambda r: r[5]):
            if not (0x00087000 <= addr < 0x00087400):
                continue
            if 0x00087200 <= addr < 0x00087300:
                j = addr - 0x00087200
                imp = "vec %d..%d" % (j * 8, j * 8 + 7)
                # if the disasm carries a bit number, name the exact vector
                if mnem in ("bset", "bclr", "btst") and insn_bit(txt, full) is not None:
                    imp = "vec %d" % (j * 8 + insn_bit(txt, full))
            elif 0x00087000 <= addr < 0x00087100:
                imp = "vec %d" % (addr - 0x00087000)
            elif 0x00087100 <= addr < 0x00087200:
                imp = "DTCER vec %d" % (addr - 0x00087100)
            else:
                imp = "IPR idx %d" % (addr - 0x00087300)
            h.write("%08X\t%s\t%s\t%08X\t%s\t%s\n" % (addr, reg_of(addr), imp, ea, fname, full))
    log("wrote icu_vectors.tsv")

    # module stop / PRCR
    with open(os.path.join(OUT, "modulestop.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("periph_addr\treg\tinsn_ea\tinsn_file_off\tfunction\tdisasm\n")
        for ea, fname, mnem, n, form, addr, txt, full in sorted(rows, key=lambda r: r[0]):
            if 0x00080010 <= addr <= 0x0008001F or addr == 0x000803FE or 0x00080000 <= addr < 0x00080020:
                h.write("%08X\t%s\t%08X\t%06X\t%s\t%s\n" % (addr, reg_of(addr), ea, ea - BASE, fname, full))
    log("wrote modulestop.tsv")

    # explicit USB verdict file
    with open(os.path.join(OUT, "usb_window.txt"), "w", encoding="utf-8", newline="\n") as h:
        usb = [r for r in rows if 0x000A0000 <= r[5] < 0x000A0400]
        usba = [r for r in rows if 0x000D0000 <= r[5] < 0x000D0100]
        pdc = [r for r in rows if 0x000A0500 <= r[5] < 0x000A0600]
        h.write("scope: every defined instruction in database SUB_VEC\n")
        h.write("functions scanned %d\n" % len(funcs))
        h.write("USB0 0x000A0000-0x000A03FF accesses: %d\n" % len(usb))
        for ea, fname, mnem, n, form, addr, txt, full in usb:
            h.write("  %08X %s %s %s %s\n" % (addr, "%08X" % ea, form, fname, full))
        h.write("USBA 0x000D0000-0x000D00FF accesses: %d\n" % len(usba))
        for ea, fname, mnem, n, form, addr, txt, full in usba:
            h.write("  %08X %s %s %s %s\n" % (addr, "%08X" % ea, form, fname, full))
        h.write("PDC 0x000A0500-0x000A05FF accesses: %d\n" % len(pdc))
        for ea, fname, mnem, n, form, addr, txt, full in pdc:
            h.write("  %08X %s %s %s %s\n" % (addr, "%08X" % ea, form, fname, full))
    log("wrote usb_window.txt")
    log("passB done")


def insn_bit(txt, full):
    import re
    m = re.search(r"#(\d+|0x[0-9A-Fa-f]+|[0-9A-Fa-f]+h)", full)
    if not m:
        return None
    s = m.group(1)
    try:
        if s.lower().endswith("h"):
            v = int(s[:-1], 16)
        elif s.lower().startswith("0x"):
            v = int(s, 16)
        else:
            v = int(s)
    except ValueError:
        return None
    return v if 0 <= v <= 7 else None


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "passB_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION written")
    import idc as _idc
    _idc.qexit(0)

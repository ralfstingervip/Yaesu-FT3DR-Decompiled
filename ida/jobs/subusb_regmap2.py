r"""SUB-USB job 3: corrected whole-image RX peripheral register access map.

Fixes over job 1:
  * For the IDA RX module an o_displ operand carries the (already byte-scaled)
    displacement in op.value, NOT op.addr.  Verified at FFEE1398:
    'mov.w #0A502h, 3EEh[r14]' -> op1.type=4 op1.reg=14 op1.value=0x3EE.
  * Registers are invalidated when an instruction changes them (CF_CHGn), so a
    base no longer leaks into unrelated frame-pointer accesses.
  * Propagates mov reg->reg copies and add #imm,reg so an address built
    incrementally is still resolved.
  * Walks to the end of the enclosing basic block / function instead of a fixed
    instruction budget.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

OUT = str(_REPO / "ida/out/sub-usb")
os.makedirs(OUT, exist_ok=True)
ERR = os.path.join(OUT, "job3.err.txt")
BASE = 0xFFC00000
IOLO, IOHI = 0x00080000, 0x00100000


def run():
    import ida_auto, ida_bytes, ida_ua, ida_idp, idc, idautils
    ida_auto.auto_wait()
    size = 0x400000
    blob = ida_bytes.get_bytes(BASE, size)
    if blob is None or len(blob) != size:
        raise RuntimeError("get_bytes %s" % (None if blob is None else len(blob)))

    sites = []
    for i in range(size - 6):
        if blob[i] != 0xFB:
            continue
        m = blob[i + 1]
        rd, lo = m >> 4, m & 0x0F
        if lo == 0x02:
            v = struct.unpack_from("<I", blob, i + 2)[0]; ln = 6
        elif lo == 0x0E:
            v = blob[i+2] | (blob[i+3] << 8) | (blob[i+4] << 16); ln = 5
        elif lo == 0x0A:
            v = struct.unpack_from("<H", blob, i + 2)[0]; ln = 4
        else:
            continue
        if IOLO <= v < IOHI:
            sites.append((BASE + i, rd, v, ln))

    CF_CHG = [ida_idp.CF_CHG1, ida_idp.CF_CHG2, ida_idp.CF_CHG3,
              ida_idp.CF_CHG4, ida_idp.CF_CHG5, ida_idp.CF_CHG6]
    STOPPREF = ("rts", "rte", "rtfi", "rtsd", "bra", "jmp", "brk", "wait", "int")

    acc = []          # (reg_ea, insn_ea, site_ea, mnem, imm, text)
    walked = 0
    for site_ea, rd, imm, ln in sites:
        regs = {rd: imm}
        ea = site_ea + ln
        for _ in range(600):
            ins = ida_ua.insn_t()
            got = ida_ua.decode_insn(ins, ea)
            if got <= 0:
                if ida_ua.create_insn(ea) == 0:
                    break
                got = ida_ua.decode_insn(ins, ea)
                if got <= 0:
                    break
            mnem = (idc.print_insn_mnem(ea) or "").lower()
            text = (idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or "").split(";")[0].strip()
            immval = None
            for op in ins.ops:
                if op.type == ida_ua.o_void:
                    break
                if op.type == ida_ua.o_imm:
                    immval = op.value & 0xFFFFFFFF
                    break
            # resolve memory operands first (they read the pre-instruction value)
            for op in ins.ops:
                if op.type == ida_ua.o_void:
                    break
                if op.type in (ida_ua.o_displ, ida_ua.o_phrase):
                    br = op.reg
                    if br in regs:
                        dsp = (op.value & 0xFFFFFFFF) if op.type == ida_ua.o_displ else 0
                        acc.append((regs[br] + dsp, ea, site_ea, mnem, immval, text))
            feat = ins.get_canon_feature()
            # propagate simple forms before invalidating
            newval = None
            dstreg = None
            if mnem.startswith("mov") and ins.ops[0].type == ida_ua.o_reg \
               and ins.ops[1].type == ida_ua.o_reg and ins.ops[0].reg in regs:
                newval, dstreg = regs[ins.ops[0].reg], ins.ops[1].reg
            elif mnem == "add" and ins.ops[0].type == ida_ua.o_imm \
                 and ins.ops[1].type == ida_ua.o_reg and ins.ops[1].reg in regs:
                newval = (regs[ins.ops[1].reg] + (ins.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
                dstreg = ins.ops[1].reg
            # invalidate every changed register operand
            for k, op in enumerate(ins.ops):
                if op.type == ida_ua.o_void:
                    break
                if k < 6 and (feat & CF_CHG[k]) and op.type == ida_ua.o_reg:
                    regs.pop(op.reg, None)
            if mnem.startswith("bsr") or mnem.startswith("jsr"):
                regs = {k: v for k, v in regs.items() if False}  # call clobbers all
            if newval is not None and dstreg is not None:
                regs[dstreg] = newval
            # a fresh FB-form constant load re-establishes a base
            if ida_bytes.get_byte(ea) == 0xFB:
                b1 = ida_bytes.get_byte(ea + 1)
                nrd, nlo = b1 >> 4, b1 & 0x0F
                if nlo == 0x02:
                    regs[nrd] = ida_bytes.get_dword(ea + 2)
                elif nlo == 0x0A:
                    regs[nrd] = ida_bytes.get_word(ea + 2)
                elif nlo == 0x0E:
                    regs[nrd] = (ida_bytes.get_byte(ea+2) | (ida_bytes.get_byte(ea+3) << 8)
                                 | (ida_bytes.get_byte(ea+4) << 16))
            if not regs:
                break
            if mnem.startswith(STOPPREF):
                break
            ea += got
        walked += 1

    with open(os.path.join(OUT, "reg_access2.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("reg_ea\tinsn_ea\tsite_ea\tmnem\timm\tdisasm\n")
        for rea, ea, site_ea, mnem, immval, text in sorted(acc):
            h.write("%08X\t%08X\t%08X\t%s\t%s\t%s\n" % (
                rea, ea, site_ea, mnem, ("%X" % immval) if immval is not None else "", text))

    # focused reports
    def report(path, lo, hi, title):
        rows = [r for r in acc if lo <= r[0] <= hi]
        with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as h:
            h.write("# %s  window %08X-%08X  hits %d\n" % (title, lo, hi, len(rows)))
            h.write("reg_ea\tinsn_ea\tmnem\timm\tdisasm\n")
            for rea, ea, site_ea, mnem, immval, text in sorted(rows, key=lambda r: (r[0], r[1])):
                h.write("%08X\t%08X\t%s\t%s\t%s\n" % (
                    rea, ea, mnem, ("%X" % immval) if immval is not None else "", text))
        return len(rows)

    n_sys = report("sys_access.tsv", 0x00080000, 0x000804FF, "SYSTEM block (MSTPCR/clock/PRCR)")
    n_mpc = report("mpc_access.tsv", 0x0008C0E0, 0x0008C1FF, "MPC pin function + PWPR")
    n_pmr = report("port_access.tsv", 0x0008C000, 0x0008C0DF, "PORT PDR/PODR/PIDR/PMR/ODR/PCR")
    n_icu = report("icu_access.tsv", 0x00087000, 0x00087FFF, "ICU")
    n_usb = report("usb_window_access.tsv", 0x000A0000, 0x000A03FF, "USB0 register window")
    n_gap = report("gap_access.tsv", 0x00090000, 0x000BFFFF, "0x90000-0xBFFFF incl. USB0/USBA")

    with open(os.path.join(OUT, "job3_regmap.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("scope_bytes %d\nfb_sites %d\nwalked %d\nresolved %d\n" % (size, len(sites), walked, len(acc)))
        h.write("distinct_reg_ea %d\n" % len(set(r[0] for r in acc)))
        h.write("SYSTEM %d\nMPC %d\nPORT %d\nICU %d\nUSB0_window %d\n0x90000-0xBFFFF %d\n"
                % (n_sys, n_mpc, n_pmr, n_icu, n_usb, n_gap))
        h.write("\n-- distinct resolved addresses --\n")
        import collections
        c = collections.Counter(r[0] for r in acc)
        for k in sorted(c):
            h.write("%08X\t%d\n" % (k, c[k]))


try:
    run()
except Exception:
    with open(ERR, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
import idc
idc.qexit(0)

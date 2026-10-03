r"""SUB-USB: exhaustive RX peripheral-register access map over the whole 4 MB image.

Method
------
1. Raw scan the whole image for the RX "MOV.L #imm, Rd" FB-form
   (FB (rd<<4)|02 imm32 / |0E imm24 / |0A imm16) whose immediate lands in the
   RX64M peripheral I/O region 0x00080000-0x000FFFFF. This is opcode aware and
   independent of function recovery, so it covers all 4 194 304 bytes.
2. At each hit force an instruction, verify IDA decoded the same immediate, then
   walk FORWARD decoding instructions and propagating that register's constant
   value through the basic block. Every memory operand of the form [Rn],
   dsp:8[Rn], dsp:16[Rn] whose base register is a tracked constant yields a
   resolved effective address. Immediate sources are recorded as the value
   written.
3. Emit every resolved (register address, access, value) triple.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

OUT = str(_REPO / "ida/out/sub-usb")
os.makedirs(OUT, exist_ok=True)
ERR = os.path.join(OUT, "job1_regmap.err.txt")

BASE = 0xFFC00000
IOLO, IOHI = 0x00080000, 0x00100000

def run():
    import ida_auto, ida_bytes, ida_ua, ida_idp, idc, idautils, ida_funcs, ida_segment
    ida_auto.auto_wait()

    size = 0x400000
    blob = ida_bytes.get_bytes(BASE, size)
    if blob is None or len(blob) != size:
        raise RuntimeError("get_bytes failed len=%s" % (None if blob is None else len(blob)))

    # ---- step 1: raw FB-form scan ------------------------------------------
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

    # ---- step 2: force code and walk forward -------------------------------
    STOP = {"rts", "rte", "rtfi", "rtsd", "bra", "bra.a", "bra.b", "bra.w",
            "bra.l", "jmp", "brk", "wait"}
    accesses = []   # (site_ea, insn_ea, mnem, ea, kind, value_or_None, text)
    decoded_ok = 0
    verify_fail = []

    for site_ea, rd, imm, ln in sites:
        ida_bytes.del_items(site_ea, ida_bytes.DELIT_SIMPLE, ln)
        if ida_ua.create_insn(site_ea) == 0:
            verify_fail.append((site_ea, imm, "create_insn"))
            continue
        ins = ida_ua.insn_t()
        if ida_ua.decode_insn(ins, site_ea) != ln:
            verify_fail.append((site_ea, imm, "len"))
            continue
        mn = idc.print_insn_mnem(site_ea).lower()
        if not mn.startswith("mov"):
            verify_fail.append((site_ea, imm, "mnem=%s" % mn))
            continue
        decoded_ok += 1
        regs = {rd: imm}
        ea = site_ea + ln
        for _ in range(80):
            ln2 = ida_ua.create_insn(ea)
            ins2 = ida_ua.insn_t()
            got = ida_ua.decode_insn(ins2, ea)
            if got <= 0:
                break
            mnem = (idc.print_insn_mnem(ea) or "").lower()
            text = idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or ""
            text = text.split(";")[0].strip()
            # immediate value in any operand
            immval = None
            for op in ins2.ops:
                if op.type == ida_ua.o_void:
                    break
                if op.type == ida_ua.o_imm:
                    immval = op.value
                    break
            # resolved memory operands
            for op in ins2.ops:
                if op.type == ida_ua.o_void:
                    break
                if op.type in (ida_ua.o_displ, ida_ua.o_phrase):
                    br = op.reg
                    if br in regs:
                        dsp = op.addr if op.type == ida_ua.o_displ else 0
                        accesses.append((site_ea, ea, mnem, regs[br] + dsp,
                                         "displ" if op.type == ida_ua.o_displ else "phrase",
                                         immval, text))
            # kill / update tracked registers written by this insn
            # crude: a destination register operand that is o_reg and not the
            # first source. Track only exact re-loads of the same FB form.
            if mnem.startswith("mov") and len(text) > 0:
                for op in ins2.ops:
                    if op.type == ida_ua.o_reg and op.n == ins2.ops[1].n:
                        pass
            # stop at flow break
            if mnem in STOP or mnem.startswith("bra") or mnem.startswith("rts"):
                break
            # a new FB-form load into a tracked reg replaces it
            if ida_bytes.get_byte(ea) == 0xFB:
                b1 = ida_bytes.get_byte(ea + 1)
                nrd, nlo = b1 >> 4, b1 & 0x0F
                if nlo in (0x02, 0x0A, 0x0E):
                    if nlo == 0x02:
                        nv = ida_bytes.get_dword(ea + 2)
                    elif nlo == 0x0A:
                        nv = ida_bytes.get_word(ea + 2)
                    else:
                        nv = ida_bytes.get_byte(ea+2) | (ida_bytes.get_byte(ea+3) << 8) | (ida_bytes.get_byte(ea+4) << 16)
                    regs[nrd] = nv
            ea += got
        ida_auto.auto_wait()

    # ---- step 3: emit ------------------------------------------------------
    with open(os.path.join(OUT, "fb_sites.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("site_ea\tfile_off\treg\timm\tform_len\n")
        for site_ea, rd, imm, ln in sites:
            h.write("%08X\t%06X\tR%d\t%08X\t%d\n" % (site_ea, site_ea - BASE, rd, imm, ln))

    with open(os.path.join(OUT, "reg_access.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("reg_ea\tinsn_ea\tsite_ea\tmnem\tkind\timm\tdisasm\n")
        for site_ea, ea, mnem, rea, kind, immval, text in sorted(accesses, key=lambda r: r[3]):
            h.write("%08X\t%08X\t%08X\t%s\t%s\t%s\t%s\n" % (
                rea, ea, site_ea, mnem, kind,
                ("%X" % immval) if immval is not None else "", text))

    with open(os.path.join(OUT, "job1_regmap.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("scope_bytes %d\n" % size)
        h.write("fb_sites %d\n" % len(sites))
        h.write("decoded_ok %d\n" % decoded_ok)
        h.write("verify_fail %d\n" % len(verify_fail))
        h.write("resolved_accesses %d\n" % len(accesses))
        h.write("functions_after %d\n" % len(list(idautils.Functions())))
        h.write("\n-- verify_fail (first 200) --\n")
        for site_ea, imm, why in verify_fail[:200]:
            h.write("%08X %08X %s\n" % (site_ea, imm, why))


try:
    run()
except Exception:
    with open(ERR, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
import idc
idc.qexit(0)

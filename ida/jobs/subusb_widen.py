r"""SUB-USB job 5: close the two remaining addressing holes for the USB window.

(a) RX dsp:16 is unsigned and byte-scaled by the operand size, so with .L the
    reach from a base is 0xFFFF*4 = 0x3FFFC.  A base as low as 0x00060004 could
    therefore still land inside 0x000A0000-0x000A03FF.  Re-run the forward
    constant walk with the base filter widened to 0x00040000-0x00100000 and
    report every resolved effective address in 0x00090000-0x000BFFFF.

(b) A base can also be loaded from a flash literal (mov.l literal, Rn).  Find
    every 4-byte aligned word in the image whose value is in the USB window and
    report whether anything in the database references it.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback
OUT = str(_REPO / "ida/out/sub-usb")
ERR = os.path.join(OUT, "job5.err.txt")
BASE = 0xFFC00000
LO, HI = 0x00040000, 0x00100000
WLO, WHI = 0x00090000, 0x000BFFFF

def run():
    import ida_auto, ida_bytes, ida_ua, ida_idp, idc, idautils, ida_xref
    ida_auto.auto_wait()
    size = 0x400000
    blob = ida_bytes.get_bytes(BASE, size)
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
        else:
            continue
        if LO <= v < HI:
            sites.append((BASE + i, rd, v, ln))

    CF_CHG = [ida_idp.CF_CHG1, ida_idp.CF_CHG2, ida_idp.CF_CHG3,
              ida_idp.CF_CHG4, ida_idp.CF_CHG5, ida_idp.CF_CHG6]
    STOPPREF = ("rts", "rte", "rtfi", "rtsd", "bra", "jmp", "brk", "wait", "int")
    hits = []
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
            for op in ins.ops:
                if op.type == ida_ua.o_void:
                    break
                if op.type in (ida_ua.o_displ, ida_ua.o_phrase):
                    if op.reg in regs:
                        dsp = (op.value & 0xFFFFFFFF) if op.type == ida_ua.o_displ else 0
                        tgt = regs[op.reg] + dsp
                        if WLO <= tgt <= WHI:
                            hits.append((tgt, ea, site_ea, imm,
                                (idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or "").strip()))
            feat = ins.get_canon_feature()
            nv = dr = None
            if mnem.startswith("mov") and ins.ops[0].type == ida_ua.o_reg \
               and ins.ops[1].type == ida_ua.o_reg and ins.ops[0].reg in regs:
                nv, dr = regs[ins.ops[0].reg], ins.ops[1].reg
            elif mnem == "add" and ins.ops[0].type == ida_ua.o_imm \
                 and ins.ops[1].type == ida_ua.o_reg and ins.ops[1].reg in regs:
                nv = (regs[ins.ops[1].reg] + (ins.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
                dr = ins.ops[1].reg
            for k, op in enumerate(ins.ops):
                if op.type == ida_ua.o_void:
                    break
                if k < 6 and (feat & CF_CHG[k]) and op.type == ida_ua.o_reg:
                    regs.pop(op.reg, None)
            if mnem.startswith("bsr") or mnem.startswith("jsr"):
                regs = {}
            if nv is not None:
                regs[dr] = nv
            if ida_bytes.get_byte(ea) == 0xFB:
                b1 = ida_bytes.get_byte(ea + 1)
                nrd, nlo = b1 >> 4, b1 & 0x0F
                if nlo == 0x02:
                    regs[nrd] = ida_bytes.get_dword(ea + 2)
                elif nlo == 0x0E:
                    regs[nrd] = (ida_bytes.get_byte(ea+2) | (ida_bytes.get_byte(ea+3) << 8)
                                 | (ida_bytes.get_byte(ea+4) << 16))
            if not regs or mnem.startswith(STOPPREF):
                break
            ea += got

    # (b) aligned literals with a value in the USB window, and their xrefs
    lits = []
    for off in range(0, size, 4):
        v = struct.unpack_from("<I", blob, off)[0]
        if 0x000A0000 <= v <= 0x000A03FF:
            ea = BASE + off
            xr = [x for x in idautils.DataRefsTo(ea)] + [x for x in idautils.CodeRefsTo(ea, 1)]
            lits.append((ea, v, xr))

    with open(os.path.join(OUT, "job5_widen.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("(a) widened base scan: bases in %08X-%08X, sites %d\n" % (LO, HI, len(sites)))
        h.write("    resolved effective addresses inside %08X-%08X: %d\n" % (WLO, WHI, len(hits)))
        for tgt, ea, site_ea, imm, txt in sorted(hits):
            h.write("    %08X  insn %08X  base %08X  %s\n" % (tgt, ea, imm, txt))
        h.write("\n(b) 4-byte aligned literals with value in 000A0000-000A03FF: %d\n" % len(lits))
        for ea, v, xr in lits:
            h.write("    literal at %08X = %08X  xrefs=%s\n" % (ea, v,
                     ",".join("%08X" % x for x in xr) if xr else "none"))

try:
    run()
except Exception:
    with open(ERR, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
import idc
idc.qexit(0)

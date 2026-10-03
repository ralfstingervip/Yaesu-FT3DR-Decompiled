r"""SUB-LOWER job 2h: corrected peripheral scan.

Two corrections after SUB-USB's hand-off:

1. In IDA's RX module an o_displ operand keeps its displacement in op.value,
   not op.addr. Job 2c used op.addr, so all 454 "base+dsp" effective addresses
   collapsed to base+0. Redo with op.value and re-test USB0.
2. Job 2c's raw scan of the LOWER region only looked for the imm:32 form of
   MOV.L #imm, Rd (FB, (rd<<4)|0x02). RX also encodes the same constant as
   imm:24 ((rd<<4)|0x0E) and imm:16 ((rd<<4)|0x0A), both sign-extended, and a
   peripheral address like 0x00080010 fits in 24 bits so it normally uses the
   imm:24 form. Redo the LOWER scan over all three.

Rewrites periph_refs.tsv and periph_lower_raw.tsv.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import struct
import traceback

import ida_auto
import ida_bytes
import ida_idp
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "periph2_error.txt")
LO = 0xFFC00000
HI = 0xFFE80000
PLO = 0x00080000
PHI = 0x00100000
USB0_LO = 0x000A0000
USB0_HI = 0x000A0400
M = 0xFFFFFFFF
NOTE = []

O_IMM = ida_ua.o_imm
O_MEM = ida_ua.o_mem
O_REG = ida_ua.o_reg
O_DISPL = ida_ua.o_displ
O_PHRASE = ida_ua.o_phrase


def esc(t: str) -> str:
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def dis(ea: int) -> str:
    return esc(idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE))


def scan_code() -> None:
    CHG = (ida_idp.CF_CHG1, ida_idp.CF_CHG2, ida_idp.CF_CHG3,
           ida_idp.CF_CHG4, ida_idp.CF_CHG5, ida_idp.CF_CHG6)
    rows = []
    usb = []
    for start in idautils.Functions():
        const = {}
        insn = ida_ua.insn_t()
        for ea in idautils.FuncItems(start):
            if ida_ua.decode_insn(insn, ea) <= 0:
                const.clear()
                continue
            mnem = insn.get_canon_mnem()
            feat = insn.get_canon_feature()
            for i in range(4):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                eff = None
                form = ""
                if op.type == O_IMM and PLO <= (op.value & M) < PHI:
                    eff, form = op.value & M, "imm"
                elif op.type == O_MEM and PLO <= (op.addr & M) < PHI:
                    eff, form = op.addr & M, "abs"
                elif op.type == O_DISPL:
                    base = const.get(op.reg)
                    # RX: the displacement lives in op.value, not op.addr
                    dsp = op.value & M
                    if base is not None and PLO <= ((base + dsp) & M) < PHI:
                        eff, form = (base + dsp) & M, "base+dsp"
                elif op.type == O_PHRASE:
                    base = const.get(op.reg)
                    if base is not None and PLO <= base < PHI:
                        eff, form = base, "reg_indirect"
                if eff is not None:
                    row = (ea, start, mnem, form, eff, dis(ea))
                    rows.append(row)
                    if USB0_LO <= eff < USB0_HI:
                        usb.append(row)
            if mnem == "mov" and insn.ops[0].type == O_IMM \
                    and insn.ops[1].type == O_REG:
                const[insn.ops[1].reg] = insn.ops[0].value & M
            elif mnem == "add" and insn.ops[0].type == O_IMM \
                    and insn.ops[1].type == O_REG \
                    and insn.ops[1].reg in const:
                const[insn.ops[1].reg] = (const[insn.ops[1].reg]
                                          + (insn.ops[0].value & M)) & M
            else:
                for i in range(6):
                    if feat & CHG[i]:
                        op = insn.ops[i]
                        if op.type == O_REG:
                            const.pop(op.reg, None)
    with open(os.path.join(OUT, "periph_refs.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("insn_ea\tfunc_ea\tmnem\tform\teff_addr\tinsn\n")
        for r in sorted(rows):
            fh.write("%08X\t%08X\t%s\t%s\t%08X\t%s\n" % r)
    NOTE.append("P2: corrected hits in recovered code %d, by form %s"
                % (len(rows), dict(collections.Counter(r[3] for r in rows))))
    blk = collections.Counter(r[4] & 0xFFFFF800 for r in rows)
    for b, c in sorted(blk.items()):
        NOTE.append("P2:   %08X-%08X  %d" % (b, b + 0x7FF, c))
    NOTE.append("P2: distinct peripheral addresses %d"
                % len({r[4] for r in rows}))
    NOTE.append("P2: USB0 %08X-%08X hits: %d" % (USB0_LO, USB0_HI, len(usb)))
    for r in usb[:40]:
        NOTE.append("P2: USB0 %08X %s -> %08X  %s" % (r[0], r[3], r[4], r[5]))
    # near-miss: anything within 0x000A0000-0x000A1000 or the surrounding gap
    near = [r for r in rows if 0x0009E000 <= r[4] < 0x000A2000]
    NOTE.append("P2: window 0009E000-000A2000 (USB0 plus 8 KB either side): %d"
                % len(near))
    for r in near[:20]:
        NOTE.append("P2:   %08X -> %08X  %s" % (r[0], r[4], r[5]))
    # verify the known trap case
    for probe in (0xFFEE1398,):
        insn = ida_ua.insn_t()
        if ida_ua.decode_insn(insn, probe) > 0:
            op = insn.ops[1]
            NOTE.append("P2: trap check %08X  %s  op1.type=%d op1.value=%#x "
                        "op1.addr=%#x op1.reg=%d"
                        % (probe, dis(probe), op.type, op.value & M,
                           op.addr & M, op.reg))


def scan_lower_raw() -> None:
    data = ida_bytes.get_bytes(LO, HI - LO) or b""
    hits = []
    for off in range(0, len(data) - 5):
        if data[off] != 0xFB:
            continue
        b = data[off + 1]
        li = b & 0x0F
        if li == 0x02:
            v = struct.unpack_from("<I", data, off + 2)[0]
            sz = 32
        elif li == 0x0E:
            v = data[off + 2] | (data[off + 3] << 8) | (data[off + 4] << 16)
            if v & 0x800000:
                v -= 0x1000000
            v &= M
            sz = 24
        elif li == 0x0A:
            v = data[off + 2] | (data[off + 3] << 8)
            if v & 0x8000:
                v -= 0x10000
            v &= M
            sz = 16
        else:
            continue
        if PLO <= v < PHI:
            hits.append((LO + off, b >> 4, v, sz))
    dw = collections.Counter()
    for off in range(0, len(data) - 3, 4):
        v = struct.unpack_from("<I", data, off)[0]
        if PLO <= v < PHI:
            dw[v] += 1
    with open(os.path.join(OUT, "periph_lower_raw.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("kind\tea_or_value\treg\timm_bits\tvalue_or_count\n")
        for ea, rd, v, sz in hits:
            fh.write("movl_imm\t%08X\tr%d\t%d\t%08X\n" % (ea, rd, sz, v))
        for v, c in sorted(dw.items()):
            fh.write("aligned_dword\t%08X\t\t\t%d\n" % (v, c))
    NOTE.append("P2: LOWER 'MOV.L #periph, Rd' byte patterns, all immediate "
                "sizes: %d  (by size %s)"
                % (len(hits), dict(collections.Counter(h[3] for h in hits))))
    inusb = [h for h in hits if USB0_LO <= h[2] < USB0_HI]
    NOTE.append("P2: LOWER patterns whose immediate is inside USB0: %d" % len(inusb))
    for ea, rd, v, sz in inusb[:30]:
        NOTE.append("P2:   %08X mov.l #%08X, r%d (imm%d)" % (ea, v, rd, sz))
    # are any of those byte offsets real instruction heads? nothing in LOWER is
    # code, so this is the corroborating test
    heads = set()
    for s in idautils.Functions():
        for ea in idautils.FuncItems(s):
            heads.add(ea)
    real = [h for h in hits if h[0] in heads]
    NOTE.append("P2: of those LOWER patterns, real instruction heads: %d" % len(real))
    NOTE.append("P2: LOWER aligned dwords in the peripheral window: %d "
                "(distinct %d); inside USB0: %d"
                % (sum(dw.values()), len(dw),
                   sum(c for v, c in dw.items() if USB0_LO <= v < USB0_HI)))


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    scan_code()
    scan_lower_raw()
    with open(os.path.join(OUT, "periph2_notes.txt"), "w", encoding="utf-8",
              newline="\n") as fh:
        for line in NOTE:
            fh.write(line + "\n")
    idc.qexit(0)


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(ERR, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(traceback.format_exc())
        fh.write("\n\n" + "\n".join(NOTE))
    idc.qexit(1)

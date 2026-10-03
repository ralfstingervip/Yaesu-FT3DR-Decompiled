r"""SUB-LOWER job 2d: close-out pass.

1. Disassemble the setup-menu record-table walker at FFF095EB / FFF09695. The
   previous session searched for a reader of 0xFFED74F0 and found none; the
   table's real base is 0xFFED74E8, eight bytes lower, and two instructions
   load it.
2. Force ida_funcs.add_func at every tier-1 LOWER candidate (clean 1 KB decode)
   so the "how many IDA accepted" number is measured rather than assumed.
3. Peripheral register-level detail: which RX64M registers the recovered code
   actually touches, with MSTPCRA/B/C/D and PRCR called out.
4. Final LOWER coverage numbers.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_segment
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "final_error.txt")
LO = 0xFFC00000
HI = 0xFFE80000
NOTE = []

REGS = {
    0x00080010: "MSTPCRA", 0x00080014: "MSTPCRB", 0x00080018: "MSTPCRC",
    0x0008001C: "MSTPCRD", 0x000803FE: "PRCR", 0x00080020: "SCKCR",
    0x00080026: "SCKCR3", 0x00080028: "PLLCR", 0x0008002A: "PLLCR2",
    0x00080040: "BCKCR", 0x0008000C: "SBYCR", 0x00080000: "MDMONR",
    0x0008C000: "PORT0_PDR", 0x00087000: "ICU_IR", 0x00087200: "ICU_IER",
    0x00087300: "ICU_IPR", 0x00087010: "ICU_IR16",
}


def esc(t: str) -> str:
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def dis(ea: int) -> str:
    return esc(idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE))


def walk(fh, lo: int, hi: int, title: str) -> None:
    fh.write("\n=== %s  %08X-%08X ===\n" % (title, lo, hi))
    insn = ida_ua.insn_t()
    ea = lo
    while ea < hi:
        ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            fh.write("%08X  %-16s (no decode)\n"
                     % (ea, (ida_bytes.get_bytes(ea, 1) or b"").hex()))
            ea += 1
            continue
        fh.write("%08X  %-16s %s\n"
                 % (ea, (ida_bytes.get_bytes(ea, ln) or b"").hex(), dis(ea)))
        ea += ln


def walker() -> None:
    path = os.path.join(OUT, "menu_walker.txt")
    with open(path, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("Setup-menu record table: base 0xFFED74E8, records of "
                 "{u32 count, u32 label_ptr}.\n"
                 "Two instructions materialise that base: FFF095EB and FFF09695.\n")
        walk(fh, 0xFFF09560, 0xFFF09700, "record-table walker context")
        fh.write("\n=== record table at FFED74E8, 32 records ===\n")
        for i in range(32):
            ea = 0xFFED74E8 + i * 8
            cnt = ida_bytes.get_dword(ea)
            ptr = ida_bytes.get_dword(ea + 4)
            s = ""
            if LO <= ptr < HI:
                b = ida_bytes.get_bytes(ptr, 20) or b""
                s = "".join(chr(c) if 32 <= c < 127 else "." for c in b)
            fh.write("  [%2d] %08X  count %-4d ptr %08X  %s\n"
                     % (i, ea, cnt, ptr, s))
        # every label of the USB CAMERA group
        fh.write("\n=== groups expanded ===\n")
        for i in range(24):
            ea = 0xFFED74E8 + i * 8
            cnt = ida_bytes.get_dword(ea)
            ptr = ida_bytes.get_dword(ea + 4)
            if not (LO <= ptr < HI) or not (0 < cnt < 64):
                continue
            names = []
            for k in range(cnt):
                b = ida_bytes.get_bytes(ptr + k * 20, 20) or b""
                names.append(b.split(b"\x00")[0].decode("latin-1"))
            fh.write("  group %2d  %08X  n=%-3d %s\n"
                     % (i, ptr, cnt, " | ".join(names)))
    NOTE.append("WALKER: wrote %s" % path)


def force_tier1() -> None:
    src = os.path.join(OUT, "lower_candidates.tsv")
    rows = []
    if os.path.isfile(src):
        with open(src, encoding="utf-8") as fh:
            next(fh)
            for line in fh:
                p = line.rstrip("\n").split("\t")
                rows.append((int(p[0], 16), p[1], int(p[2])))
    before = sum(1 for s in idautils.Functions() if LO <= s < HI)
    accepted = rejected = 0
    detail = []
    for ea, pat, tier in rows:
        ida_bytes.del_items(ea, 0, 8)
        if ida_ua.create_insn(ea) <= 0:
            rejected += 1
            detail.append((ea, pat, tier, "create_insn refused"))
            continue
        if ida_funcs.add_func(ea):
            f = ida_funcs.get_func(ea)
            size = (f.end_ea - f.start_ea) if f else 0
            accepted += 1
            detail.append((ea, pat, tier, "add_func ok, size %d" % size))
        else:
            rejected += 1
            detail.append((ea, pat, tier, "add_func refused"))
    ida_auto.auto_wait()
    after = sum(1 for s in idautils.Functions() if LO <= s < HI)
    NOTE.append("FORCE tier1: candidates %d, IDA accepted %d, refused %d, "
                "LOWER functions %d -> %d" % (len(rows), accepted, rejected,
                                              before, after))
    with open(os.path.join(OUT, "force_tier1.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("ea\tpattern\ttier\tresult\tdisasm_first\tdisasm_second\n")
        for ea, pat, tier, res in detail:
            insn = ida_ua.insn_t()
            n = ida_ua.decode_insn(insn, ea)
            nxt = ea + n if n > 0 else ea
            fh.write("%08X\t%s\t%d\t%s\t%s\t%s\n"
                     % (ea, pat, tier, res, dis(ea), dis(nxt)))
    # what do the accepted ones look like, and are they plausible?
    for ea, pat, tier, res in detail:
        if res.startswith("add_func ok"):
            NOTE.append("FORCE tier1: %08X %s -> %s | %s"
                        % (ea, pat, res, dis(ea)))


def periph_detail() -> None:
    src = os.path.join(OUT, "periph_refs.tsv")
    if not os.path.isfile(src):
        NOTE.append("PERIPH2: no periph_refs.tsv")
        return
    rows = []
    with open(src, encoding="utf-8") as fh:
        next(fh)
        for line in fh:
            p = line.rstrip("\n").split("\t")
            rows.append((int(p[0], 16), int(p[1], 16), p[2], p[3],
                         int(p[4], 16), p[5]))
    by_addr = collections.Counter(r[4] for r in rows)
    NOTE.append("PERIPH2: %d references, %d distinct peripheral addresses"
                % (len(rows), len(by_addr)))
    NOTE.append("PERIPH2: top 30 addresses")
    for a, c in by_addr.most_common(30):
        NOTE.append("PERIPH2:   %08X  %4d  %s" % (a, c, REGS.get(a, "")))
    NOTE.append("PERIPH2: named control registers")
    for a, name in sorted(REGS.items()):
        hits = [r for r in rows if r[4] == a]
        if hits:
            NOTE.append("PERIPH2:   %08X %-10s %d hits" % (a, name, len(hits)))
            for r in hits[:6]:
                NOTE.append("PERIPH2:     %08X in %08X  %s" % (r[0], r[1], r[5]))
    # module-stop window: MSTPCRA..D are 4 dwords at 0x00080010..0x0008001F
    ms = [r for r in rows if 0x00080010 <= r[4] <= 0x0008001F]
    NOTE.append("PERIPH2: MSTPCRA-D window 00080010-0008001F: %d hits" % len(ms))
    for r in ms:
        NOTE.append("PERIPH2:   %08X in %08X -> %08X  %s"
                    % (r[0], r[1], r[4], r[5]))
    pr = [r for r in rows if r[4] == 0x000803FE]
    NOTE.append("PERIPH2: PRCR 000803FE: %d hits" % len(pr))
    for r in pr:
        NOTE.append("PERIPH2:   %08X in %08X  %s" % (r[0], r[1], r[5]))
    sci = collections.Counter(r[4] & 0xFFFFFFE0 for r in rows
                              if 0x0008A000 <= r[4] < 0x0008B000)
    NOTE.append("PERIPH2: SCI channel bases touched (0x20 stride)")
    for a, c in sorted(sci.items()):
        NOTE.append("PERIPH2:   %08X  ch%d  %d hits"
                    % (a, (a - 0x0008A000) // 0x20, c))


def coverage() -> None:
    code = data = unk = 0
    ea = LO
    while ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            code += 1
        elif ida_bytes.is_data(fl):
            data += 1
        else:
            unk += 1
        ea += 1
    nf = sum(1 for s in idautils.Functions() if LO <= s < HI)
    bf = sum(ida_funcs.get_func(s).end_ea - s
             for s in idautils.Functions() if LO <= s < HI)
    total = sum(1 for s in idautils.Functions())
    NOTE.append("FINAL: LOWER bytes code %d data %d unknown %d of %d"
                % (code, data, unk, HI - LO))
    NOTE.append("FINAL: LOWER functions %d covering %d bytes; whole-image "
                "functions %d" % (nf, bf, total))
    seg = ida_segment.get_first_seg()
    while seg is not None:
        NOTE.append("FINAL: segment %s %08X-%08X"
                    % (idc.get_segm_name(seg.start_ea), seg.start_ea, seg.end_ea))
        seg = ida_segment.get_next_seg(seg.start_ea)


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    walker()
    periph_detail()
    force_tier1()
    coverage()
    with open(os.path.join(OUT, "final_notes.txt"), "w", encoding="utf-8",
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

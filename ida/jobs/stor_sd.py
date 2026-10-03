"""STORAGE pass 1 on the SUB (RX64M) image: SDHI driver, FAT layer, path code.

Windows were chosen from an exhaustive raw-binary RX immediate scan of the
4 MB image, so coverage is driven by evidence rather than by the earlier
455-function state.  Mapped address = 0xFFC00000 + file offset.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import sys

sys.path.insert(0, str(_REPO / "ida/jobs"))

import ida_auto
import ida_bytes
import ida_funcs
import ida_name
import ida_ua
import ida_xref
import idautils
import idc

import stor_lib as L

BASE = 0xFFC00000

# (label, file_lo, file_hi)
WINDOWS = [
    ("sdhi_drv",   0x332900, 0x333C80),   # every SDHI register immediate lives here
    ("fat_type",   0x323900, 0x324100),   # EXFAT/FAT32/FAT12/FAT16 + RRaA/rrAa
    ("fat_cen",    0x322500, 0x322C80),   # the two "        CEN" references
    ("fat_colon",  0x32C200, 0x32C380),   # ':' drive-letter split
    ("fat_colon2", 0x32D780, 0x32D900),
    ("fat_lfn",    0x3208C0, 0x320A40),   # '+,;=[]' 8.3-illegal set
    ("fat_bad",    0x31F100, 0x31F980),   # '1' refs near the bad-char table
    ("lmrepair",   0x325B00, 0x325F80),   # ':\LMREPAIR'
    ("voice_io",   0x312B80, 0x314F80),   # fopen modes + 0%d/%d/.wav + Backup.bin
    ("pathbuild",  0x33B880, 0x340100),   # I:\ + \ path assembly, RECBACKUP
    ("lowsrc",     0x2E1300, 0x2E1A80),   # CC-RX lowsrc open/read/write/close
    ("printf",     0x345F00, 0x346400),   # hjltzL printf
    ("fmt_area",   0x337600, 0x337B00),   # VOICE PLAY / .wav
    ("blk_338a",   0x338A80, 0x339300),
]

# Data tables / strings whose users we want to name and cross-reference.
TABLES = [
    ("pathtab_drive", 0xFFED7E90, 7),     # -> "I:\FT3D" .. "I:\VOICE"
    ("pathtab_bare", 0xFFED8318, 7),      # -> "FT3D" .. "VOICE"
    ("badchar_tab", 0xFFEDA724, 4),
    ("fsinfo_tab", 0xFFEDA790, 4),
]

STRINGS = [
    0xFFF4AD58, 0xFFF4AD60, 0xFFF4AD6F, 0xFFF4AD7E, 0xFFF4AD90, 0xFFF4AD9A,
    0xFFF4ADA3, 0xFFF4ADBC, 0xFFF4ADC1, 0xFFF4ADDC, 0xFFF4ADF0, 0xFFF4ADF8,
    0xFFF4AE05, 0xFFF4AE14, 0xFFF4AE1A, 0xFFF4AE20, 0xFFF4AE26, 0xFFF4AE2C,
    0xFFF4AE31, 0xFFF4AE38, 0xFFF4AE50, 0xFFF4AE55, 0xFFF4AE5C, 0xFFF4AFF3,
    0xFFF4AFF7, 0xFFF4B005, 0xFFF4B00A, 0xFFF4B01C, 0xFFF484D1, 0xFFF484DC,
    0xFFF484E8, 0xFFC3E8E1,
]

SDHI = {
    0x00: "SDCMD", 0x08: "SDARG", 0x0C: "SDARG1", 0x10: "SDSTOP",
    0x14: "SDBLKCNT", 0x18: "SDRSP10", 0x1C: "SDRSP1", 0x20: "SDRSP32",
    0x24: "SDRSP3", 0x28: "SDRSP54", 0x2C: "SDRSP5", 0x30: "SDRSP76",
    0x34: "SDRSP7", 0x38: "SDSTS1", 0x3C: "SDSTS2", 0x40: "SDIMSK1",
    0x44: "SDIMSK2", 0x48: "SDCLKCR", 0x4C: "SDSIZE", 0x50: "SDOPT",
    0x58: "SDERSTS1", 0x5C: "SDERSTS2", 0x60: "SDBUFR", 0x68: "SDIOMD",
    0x6C: "SDIOSTS", 0x70: "SDIOIMSK", 0x1B0: "SDDMAEN", 0x1C0: "SDRST",
    0x1C4: "SDVER", 0x1E0: "SDSWAP",
}
SDHI_BASE = 0x0008AC00


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    log = L.open_out("pass1_log.txt")

    # ---- 1. force-decode every window --------------------------------
    for label, lo, hi in WINDOWS:
        made = L.force_code(BASE + lo, BASE + hi)
        log.write("force_code %-11s %08X-%08X made=%d\n" % (label, BASE + lo, BASE + hi, made))
    ida_auto.auto_wait()
    for label, lo, hi in WINDOWS:
        n = L.make_funcs(BASE + lo, BASE + hi)
        log.write("make_funcs %-11s added=%d\n" % (label, n))
    ida_auto.auto_wait()

    # ---- 2. annotate SDHI register accesses, then dump listings -------
    sd_hits = []
    for label, lo, hi in WINDOWS:
        ea = BASE + lo
        end = BASE + hi
        while ea < end:
            size = ida_bytes.get_item_size(ea) or 1
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                for i in range(3):
                    t = idc.get_operand_type(ea, i)
                    if t in (idc.o_imm, idc.o_mem, idc.o_displ, idc.o_phrase):
                        v = idc.get_operand_value(ea, i)
                        if v is None:
                            continue
                        if SDHI_BASE <= v <= SDHI_BASE + 0x1FF:
                            reg = SDHI.get(v - SDHI_BASE, "+%X" % (v - SDHI_BASE))
                            fn = idc.get_func_name(ea) or ""
                            idc.set_cmt(ea, "SDHI.%s" % reg, 0)
                            sd_hits.append((ea, v, reg, fn,
                                            idc.generate_disasm_line(ea, 0) or ""))
            ea += size
    with L.open_out("sdhi_accesses.tsv") as h:
        h.write("ea\tfile_off\tperiph_addr\treg\tfunction\tdisasm\n")
        for ea, v, reg, fn, dis in sd_hits:
            h.write("%08X\t%06X\t%08X\t%s\t%s\t%s\n" % (ea, ea - BASE, v, reg, fn, dis))
    log.write("sdhi accesses annotated: %d\n" % len(sd_hits))

    for label, lo, hi in WINDOWS:
        with L.open_asm("%s.asm" % label) as h:
            L.dump_range(h, BASE + lo, BASE + hi, label)

    # ---- 3. pointer tables ------------------------------------------
    with L.open_out("tables.tsv") as h:
        h.write("table\tslot\tslot_ea\tvalue\tstring\n")
        for name, ea0, count in TABLES:
            for i in range(count):
                ea = ea0 + i * 4
                ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 4)
                ida_bytes.create_dword(ea, 4, True)
                v = ida_bytes.get_dword(ea)
                h.write("%s\t%d\t%08X\t%08X\t%s\n" % (name, i, ea, v, L.cstr(v)))
            ida_name.set_name(ea0, name, ida_name.SN_NOCHECK | ida_name.SN_FORCE)

    # ---- 4. xrefs to the strings of interest --------------------------
    with L.open_out("string_xrefs.tsv") as h:
        h.write("string_ea\tstring\txref_ea\txref_type\tfunction\tdisasm\n")
        for sea in STRINGS:
            s = L.cstr(sea)
            found = False
            for xr in idautils.XrefsTo(sea, 0):
                found = True
                h.write("%08X\t%s\t%08X\t%d\t%s\t%s\n"
                        % (sea, s, xr.frm, xr.type, idc.get_func_name(xr.frm) or "",
                           idc.generate_disasm_line(xr.frm, 0) or ""))
            if not found:
                h.write("%08X\t%s\t\t\t\t(no ida xref)\n" % (sea, s))

    # ---- 5. function inventory for the windows -----------------------
    with L.open_out("functions.tsv") as h:
        h.write("start\tfile_off\tend\tsize\tname\tncalls_in\tncalls_out\n")
        for fva in idautils.Functions():
            f = ida_funcs.get_func(fva)
            if f is None:
                continue
            ins = len(list(idautils.CodeRefsTo(fva, 0)))
            outs = 0
            for ea in idautils.FuncItems(fva):
                for xr in idautils.XrefsFrom(ea, 0):
                    if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                        outs += 1
            h.write("%08X\t%06X\t%08X\t%d\t%s\t%d\t%d\n"
                    % (f.start_ea, f.start_ea - BASE, f.end_ea,
                       f.end_ea - f.start_ea, idc.get_func_name(fva) or "", ins, outs))

    log.write("done\n")
    log.close()


main()

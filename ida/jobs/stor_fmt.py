"""STORAGE pass 2: FORMAT (mkfs), SD command layer, ISR/DMA, module stop,
and the ownership of every path string.

Runs with --reopen against STOR_SUB.
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
INTB = 0xFFED8A70

WINDOWS = [
    ("mkfs",       0x335400, 0x336300),   # FAT12/16/32 templates + boot sector writer
    ("mstp",       0x336C00, 0x336E00),   # MSTPCRD bit 19
    ("sd_low",     0x332000, 0x332980),   # ISR slot 44 = FFF32CA7, DMRSR3 at FFF32E32
    ("sd_more",    0x333C80, 0x334400),
    ("pathtab_u",  0x3129C0, 0x312B80),   # pathtab_drive user
    ("fat_more",   0x32E200, 0x32EE00),   # sub_FFF2E309, sub_FFF2ED1A helpers
    ("memcmp",     0x345400, 0x345700),   # sub_FFF4557D
    ("blob_user",  0x340B00, 0x340D80),
    ("fat_open",   0x322C80, 0x323900),
    ("fat_a",      0x31F980, 0x3208C0),
    ("fat_b",      0x320A40, 0x322500),
    ("fat_c",      0x324100, 0x325B00),
    ("fat_d",      0x325F80, 0x32C200),
    ("fat_e",      0x32C380, 0x32D780),
    ("fat_f",      0x32D900, 0x32E200),
    ("feat_a",     0x340100, 0x340B00),
    ("feat_b",     0x312000, 0x3129C0),
]

# Paths / strings whose owning function we want.
PATH_SITES = {
    0xFFF4AD58: "I:\\FT3D", 0xFFF4AD60: "I:\\FT3D\\BACKUP",
    0xFFF4AD6F: "I:\\FT3D\\GPSLOG", 0xFFF4AD7E: "I:\\FT3D_MEMORY-CH",
    0xFFF4AD90: "I:\\QSOLOG", 0xFFF4AD9A: "I:\\PHOTO", 0xFFF4ADA3: "I:\\VOICE",
    0xFFF4AFB4: "FT3D", 0xFFF4AFB9: "FT3D\\BACKUP", 0xFFF4AFC5: "FT3D\\GPSLOG",
    0xFFF4AFD1: "FT3D_MEMORY-CH", 0xFFF4AFE0: "QSOLOG", 0xFFF4AFE7: "PHOTO",
    0xFFF4AFED: "VOICE", 0xFFF4AFF3: "I:\\", 0xFFF4AFF7: "I:\\LMREPAIR",
    0xFFF4B00A: "I:\\RECBACKUP", 0xFFF4AE38: ":\\LMREPAIR",
    0xFFF4ADBC: ".wav", 0xFFF4AE67: ".wav", 0xFFF4B005: ".wav",
    0xFFF4ADC1: "\\Backup.bin", 0xFFF4B003: "\\",
    0xFFF4ADAC: "mode w", 0xFFF4ADAE: "mode a", 0xFFF4ADB0: "mode r+",
    0xFFF4ADB3: "mode r", 0xFFF4ADD0: "mode r", 0xFFF4ADD3: "mode w",
    0xFFF4ADD5: "mode r+", 0xFFF4ADD8: "mode a", 0xFFF4AE43: "mode r",
    0xFFF4AE45: "mode w", 0xFFF4B017: "mode r+",
    0xFFF4ADB5: "fmt 0%d", 0xFFF4ADB9: "fmt %d",
    0xFFED7E90: "pathtab_drive", 0xFFED8318: "pathtab_bare",
    0xFFC3E8A3: "bs_tmpl_fat16", 0xFFC3E8E1: "bs_tmpl_fat32",
    0xFFC3E93B: "fat32_init_ents", 0xFFC3E947: "fat16_init_ents",
    0xFFC3E94B: "fat12_init_ents",
    0xFFF4AE14: "EXFAT", 0xFFF4AE1A: "FAT32", 0xFFF4AE20: "FAT12",
    0xFFF4AE26: "FAT16", 0xFFF4AE2C: "RRaA", 0xFFF4AE31: "rrAa",
    0xFFF4ADDC: "badchr_any", 0xFFF4ADF0: "badchr_83",
    0xFFF4ADF8: "CEN_tmpl_1", 0xFFF4AE05: "CEN_tmpl_2",
}

SD_FUNCS = [
    0xFFF329FA, 0xFFF32A29, 0xFFF3306E, 0xFFF330C8, 0xFFF3312D, 0xFFF331E9,
    0xFFF331F3, 0xFFF33200, 0xFFF3320D, 0xFFF3321C, 0xFFF3326B, 0xFFF33293,
    0xFFF332D1, 0xFFF33421, 0xFFF3350F, 0xFFF3355A, 0xFFF33739, 0xFFF337D7,
    0xFFF338D7, 0xFFF33961, 0xFFF33AA7,
]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    log = L.open_out("pass2_log.txt")

    for label, lo, hi in WINDOWS:
        made = L.force_code(BASE + lo, BASE + hi)
        log.write("force_code %-11s %08X-%08X made=%d\n" % (label, BASE + lo, BASE + hi, made))
    ida_auto.auto_wait()
    for label, lo, hi in WINDOWS:
        n = L.make_funcs(BASE + lo, BASE + hi)
        log.write("make_funcs %-11s added=%d\n" % (label, n))
    ida_auto.auto_wait()

    for label, lo, hi in WINDOWS:
        with L.open_asm("%s.asm" % label) as h:
            L.dump_range(h, BASE + lo, BASE + hi, label)

    # ---- INTB slot 44 and neighbours ---------------------------------
    with L.open_out("intb_sd.tsv") as h:
        h.write("slot\tslot_ea\thandler\tfunc\tfunc_start\n")
        for i in range(256):
            ea = INTB + i * 4
            v = ida_bytes.get_dword(ea)
            fn = ida_funcs.get_func(v)
            h.write("%d\t%08X\t%08X\t%s\t%s\n"
                    % (i, ea, v, idc.get_func_name(v) or "",
                       "%08X" % fn.start_ea if fn else ""))

    # ---- who owns each path string -----------------------------------
    with L.open_out("path_owners.tsv") as h:
        h.write("target\tlabel\tsite_ea\tsite_file_off\towner_func\tfunc_start\tfunc_size\tcallers\n")
        for tgt, label in sorted(PATH_SITES.items()):
            sites = list(idautils.XrefsTo(tgt, 0))
            if not sites:
                h.write("%08X\t%s\t\t\t(no xref)\t\t\t\n" % (tgt, label))
            for xr in sites:
                f = ida_funcs.get_func(xr.frm)
                callers = []
                if f is not None:
                    for c in idautils.CodeRefsTo(f.start_ea, 0):
                        callers.append("%08X" % c)
                h.write("%08X\t%s\t%08X\t%06X\t%s\t%s\t%s\t%s\n"
                        % (tgt, label, xr.frm, xr.frm - BASE,
                           idc.get_func_name(xr.frm) or "",
                           "%08X" % f.start_ea if f else "",
                           f.end_ea - f.start_ea if f else "",
                           ",".join(callers[:12])))

    # ---- callers of each SD HAL function -----------------------------
    with L.open_out("sd_callers.tsv") as h:
        h.write("sd_func\tcaller_ea\tcaller_func\tcontext\n")
        for fa in SD_FUNCS:
            refs = list(idautils.CodeRefsTo(fa, 0))
            if not refs:
                h.write("%08X\t\t(no caller found)\t\n" % fa)
            for r in refs:
                ctx = []
                ea = r
                for _ in range(10):
                    ea = idc.prev_head(ea)
                    if ea == idc.BADADDR:
                        break
                    ctx.append(idc.generate_disasm_line(ea, 0) or "")
                h.write("%08X\t%08X\t%s\t%s\n"
                        % (fa, r, idc.get_func_name(r) or "", " | ".join(reversed(ctx))))

    log.write("done\n")
    log.close()


main()

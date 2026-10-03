"""STORAGE pass 4: force-decode the whole SUB code region so cross-references
are complete, then answer the ownership questions that need full xref coverage.
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
import ida_ua
import ida_xref
import idautils
import idc

import stor_lib as L

BASE = 0xFFC00000
CODE_LO = BASE + 0x2D8000
CODE_HI = BASE + 0x350000

# functions/sites whose callers we want once coverage is complete
WANT = {
    0xFFF0BA72: "popup W PROTECT",
    0xFFF0BAB1: "popup MCH ERROR",
    0xFFF0BAF0: "popup BANK FULL",
    0xFFF0BB6E: "popup NO BANK",
    0xFFF0BBAD: "popup MS ERROR",
    0xFFF0BBEC: "popup NO MEMORY",
    0xFFF0BC2B: "popup NO SD CARD",
    0xFFF0BC6A: "popup SD CARD FULL",
    0xFFF0BD27: "popup FIRM ERROR",
    0xFFF0C46F: "popup confirm dispatch",
    0xFFF35D0B: "mkfs_write_bootsector",
    0xFFF35A08: "mkfs_init_fat",
    0xFFF23DBA: "fat_id_fstype",
    0xFFF23ED6: "fat_id_fstype2",
    0xFFF23E4C: "fat_check_fsinfo",
    0xFFF3321C: "sdhi_card_detect",
    0xFFF33293: "sdhi_set_buswidth",
    0xFFF337D7: "sd_xfer_read",
    0xFFF33961: "sd_xfer_write",
    0xFFF3365E: "sd_get_resp_a",
    0xFFF336DC: "sd_get_resp_b",
    0xFFF12A8F: "path_get_dir_drive",
    0xFFF3B8DE: "path_get_dir_bare",
    0xFFF140C7: "open_Backup_bin",
    0xFFF13DDA: "make_wav_name",
    0xFFF14194: "write_wav_header",
    0xFFF3E98C: "recbackup_wav",
    0xFFF3EB8C: "recbackup_dir",
    0xFFF25B0B: "lmrepair",
    0xFFF08201: "camera_settings",
}


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    log = L.open_out("pass4_log.txt")

    # linear sweep over the whole code region
    made = L.force_code(CODE_LO, CODE_HI)
    log.write("force_code %08X-%08X made=%d\n" % (CODE_LO, CODE_HI, made))
    ida_auto.auto_wait()
    added = L.make_funcs(CODE_LO, CODE_HI)
    log.write("make_funcs added=%d\n" % added)
    ida_auto.auto_wait()

    nf = len(list(idautils.Functions()))
    log.write("total functions now %d\n" % nf)

    with L.open_out("functions_full.tsv") as h:
        h.write("start\tfile_off\tsize\tname\tncallers\n")
        for fva in idautils.Functions():
            f = ida_funcs.get_func(fva)
            if f is None:
                continue
            h.write("%08X\t%06X\t%d\t%s\t%d\n"
                    % (f.start_ea, f.start_ea - BASE, f.end_ea - f.start_ea,
                       idc.get_func_name(fva) or "",
                       len(list(idautils.CodeRefsTo(fva, 0)))))

    with L.open_out("callers_full.tsv") as h:
        h.write("callee\tlabel\tcaller_ea\tcaller_func\tdisasm\n")
        for fa, label in sorted(WANT.items()):
            refs = list(idautils.CodeRefsTo(fa, 0))
            if not refs:
                h.write("%08X\t%s\t\t(none)\t\n" % (fa, label))
            for r in refs:
                h.write("%08X\t%s\t%08X\t%s\t%s\n"
                        % (fa, label, r, idc.get_func_name(r) or "",
                           idc.generate_disasm_line(r, 0) or ""))

    with L.open_out("callgraph_full.tsv") as h:
        h.write("caller\tcall_site\tcallee\n")
        for fva in idautils.Functions():
            for ea in idautils.FuncItems(fva):
                for xr in idautils.XrefsFrom(ea, 0):
                    if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                        h.write("%08X\t%08X\t%08X\n" % (fva, ea, xr.to))

    # every string reference in the code region, so path/format discovery is complete
    with L.open_out("all_strrefs.tsv") as h:
        h.write("site_ea\tsite_func\ttarget\tstring\n")
        for seg_start, blob in []:
            pass
        ea = CODE_LO
        while ea < CODE_HI:
            size = ida_bytes.get_item_size(ea) or 1
            if ida_bytes.is_code(ida_bytes.get_flags(ea)):
                for i in range(3):
                    if idc.get_operand_type(ea, i) == idc.o_imm:
                        v = idc.get_operand_value(ea, i)
                        if v is None or not (BASE <= v <= 0xFFFFFFFF):
                            continue
                        s = L.cstr(v, 64)
                        if len(s) >= 3 and all(
                                32 <= ord(c) < 127 for c in s if len(c) == 1):
                            h.write("%08X\t%s\t%08X\t%s\n"
                                    % (ea, idc.get_func_name(ea) or "", v, s))
            ea += size

    log.write("done\n")
    log.close()


main()

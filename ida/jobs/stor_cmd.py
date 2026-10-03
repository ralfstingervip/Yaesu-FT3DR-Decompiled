"""STORAGE pass 3: the SD command set, the mount/format top level, the
FIRM ERROR producer, the camera settings screen, and a storage call graph.
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

WINDOWS = [
    ("sd_proto",  0x334400, 0x335400),   # between the HAL and mkfs: protocol layer
    ("mount",     0x336300, 0x336C00),
    ("ui_popup",  0x30B800, 0x30C900),   # FIRM ERROR / NO SD CARD display wrappers
    ("camera",    0x307E00, 0x308900),   # sub_FFF08201 camera settings
    ("feat_c",    0x310000, 0x312000),
    ("feat_d",    0x340D80, 0x342000),
    ("gps_a",     0x30C900, 0x310000),
]

# functions whose callers we want, with a label
WANT_CALLERS = {
    0xFFF33538: "sd_send_cmd(cmd,?,arg,?)",
    0xFFF33421: "sdhi_issue_cmd",
    0xFFF3355A: "sdhi_get_response",
    0xFFF331F3: "sdhi_set_SDSIZE",
    0xFFF33200: "sdhi_set_SDBLKCNT",
    0xFFF33293: "sdhi_set_buswidth",
    0xFFF3321C: "sdhi_card_detect",
    0xFFF35D0B: "mkfs_write_bootsector",
    0xFFF35A08: "mkfs_init_fat",
    0xFFF23DBA: "fat_id_fstype",
    0xFFF23ED6: "fat_id_fstype2",
    0xFFF23E4C: "fat_check_fsinfo",
    0xFFF12A8F: "path_get_dir_drive",
    0xFFF3B8DE: "path_get_dir_bare",
}

# the UI popup wrappers: find the function that contains each site, then callers
POPUP_SITES = {
    0xFFF0BA94: "W PROTECT", 0xFFF0BAD3: "MCH ERROR", 0xFFF0BB12: "BANK FULL",
    0xFFF0BC4D: "NO SD CARD", 0xFFF0BC8C: "SD CARD FULL", 0xFFF0BD49: "FIRM ERROR",
    0xFFF0BC0E: "NO MEMORY", 0xFFF0BB8F: "NO BANK", 0xFFF0BBCF: "MS ERROR",
    0xFFF0C594: "FORMAT?", 0xFFF0C65A: "OVERWRITE?", 0xFFF0C69C: "WRITE?",
    0xFFF0C6DE: "READ?",
}


def callers_of(fa):
    return ["%08X" % c for c in idautils.CodeRefsTo(fa, 0)]


@L.guard
def main() -> None:
    ida_auto.auto_wait()
    log = L.open_out("pass3_log.txt")

    for label, lo, hi in WINDOWS:
        made = L.force_code(BASE + lo, BASE + hi)
        log.write("force_code %-10s %08X-%08X made=%d\n" % (label, BASE + lo, BASE + hi, made))
    ida_auto.auto_wait()
    for label, lo, hi in WINDOWS:
        n = L.make_funcs(BASE + lo, BASE + hi)
        log.write("make_funcs %-10s added=%d\n" % (label, n))
    ida_auto.auto_wait()

    for label, lo, hi in WINDOWS:
        with L.open_asm("%s.asm" % label) as h:
            L.dump_range(h, BASE + lo, BASE + hi, label)

    # ---- callers with the immediates they set up -----------------------
    with L.open_out("call_ctx.tsv") as h:
        h.write("callee\tlabel\tcaller_ea\tcaller_func\tpreceding_12_insns\n")
        for fa, label in sorted(WANT_CALLERS.items()):
            refs = callers_of(fa)
            if not refs:
                h.write("%08X\t%s\t\t(no caller)\t\n" % (fa, label))
            for r in idautils.CodeRefsTo(fa, 0):
                ctx = []
                ea = r
                for _ in range(12):
                    ea = idc.prev_head(ea)
                    if ea == idc.BADADDR:
                        break
                    ctx.append(idc.generate_disasm_line(ea, 0) or "")
                h.write("%08X\t%s\t%08X\t%s\t%s\n"
                        % (fa, label, r, idc.get_func_name(r) or "",
                           " | ".join(reversed(ctx))))

    # ---- popup owners and their callers -------------------------------
    with L.open_out("popup_owners.tsv") as h:
        h.write("site\tmsg\towner\tcallers\tcaller_funcs\n")
        for site, msg in sorted(POPUP_SITES.items()):
            f = ida_funcs.get_func(site)
            if f is None:
                h.write("%08X\t%s\t(no func)\t\t\n" % (site, msg))
                continue
            cs = callers_of(f.start_ea)
            cf = sorted({idc.get_func_name(int(c, 16)) or "" for c in cs})
            h.write("%08X\t%s\t%08X\t%s\t%s\n"
                    % (site, msg, f.start_ea, ",".join(cs[:24]), ",".join(cf[:24])))

    # ---- storage-subsystem call graph ---------------------------------
    with L.open_out("callgraph.tsv") as h:
        h.write("caller\tcaller_ea\tcallee\n")
        for fva in idautils.Functions():
            if not (0xFFED8000 <= fva < 0xFFF50000):
                continue
            for ea in idautils.FuncItems(fva):
                for xr in idautils.XrefsFrom(ea, 0):
                    if xr.type in (ida_xref.fl_CN, ida_xref.fl_CF):
                        h.write("%08X\t%08X\t%08X\n" % (fva, ea, xr.to))

    log.write("done\n")
    log.close()


main()

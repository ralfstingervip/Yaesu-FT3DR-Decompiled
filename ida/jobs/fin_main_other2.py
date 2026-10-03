r"""Lane F2 v2 — authoritative linear decode of the mixed blocks using
decode_insn (lowest-level H8S decoder), robust range clearing, and explicit
handling of the opaque 8-byte indexed-load `78 ?0 6B 2? dddddddd` form that the
h8s300a module does not decode. Reopen FIN_MAIN_OTHER. Writes only to my out dir.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_idp, ida_lines, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-raw-other")
os.makedirs(OUT, exist_ok=True)
LOG = os.path.join(OUT, "ida_run2.log")

# linear-decode windows from a clean instruction anchor to the next fn start
WINDOWS = [
    ("block1", 0x001825, 0x001A40, 0x00181A, 0x001A40),
    ("block3", 0x0562C8, 0x0563E7, 0x056298, 0x05641E),
    ("block4", 0x076B50, 0x076BED, 0x076B4E, 0x076C04),
]
# individual byte-site probes: does decode_insn accept them?
PROBES = [0x0562C8, 0x0562B2, 0x0563A8, 0x0563DA,   # 78 b0 sites (block3)
          0x076B6E, 0x076B4E]                          # 1f10 site + clean start


def clear(a, b):
    ea = a
    while ea < b:
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE)
        ea = max(ea + 1, ida_bytes.get_item_end(ea)) if False else ea + 1


def hexb(ea, n):
    return (ida_bytes.get_bytes(ea, n) or b"").hex()


def text_of(ea):
    # create a single insn at ea for authoritative text, then read it back
    if ida_ua.create_insn(ea):
        t = ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0)) or ""
        return t
    return "?"


def main():
    ida_auto.auto_wait()
    try:
        ida_auto.enable_auto(False)
    except Exception:
        pass
    ph = ida_idp.get_ph() if hasattr(ida_idp, "get_ph") else ida_idp.ph
    insn = ida_ua.insn_t()

    with open(os.path.join(OUT, "decode2.txt"), "w", encoding="utf-8", newline="\n") as fh:
        # per-byte probes
        fh.write("== decode_insn probes (after clearing) ==\n")
        for ea in PROBES:
            clear(ea, ea + 8)
            sz = ida_ua.decode_insn(insn, ea)
            fh.write("%06X  bytes=%s  decode_insn.size=%d itype=%d\n"
                     % (ea, hexb(ea, 8), sz, insn.itype))
        fh.write("\n")

        for name, bs, be, anc, we in WINDOWS:
            fh.write("\n######## %s block=[%06X,%06X) decode from %06X to %06X ########\n"
                     % (name, bs, be, anc, we))
            clear(anc, we)
            cur = anc
            ninsn = nopaque = ndata = 0
            while cur < we:
                sz = ida_ua.decode_insn(insn, cur)
                if sz > 0 and insn.itype != 0:
                    inblk = "*" if bs <= cur < be else " "
                    fh.write("%s%06X +%-2d %-18s %s\n"
                             % (inblk, cur, sz, hexb(cur, sz), text_of(cur)))
                    ninsn += 1
                    cur += sz
                    continue
                b = ida_bytes.get_bytes(cur, 8) or b""
                # opaque indexed load: 78 ?0 6B 2? dddddddd  (8 bytes)
                if len(b) == 8 and b[0] == 0x78 and b[2] == 0x6B and (b[3] >> 4) == 0x2:
                    disp = int.from_bytes(b[4:8], "big")
                    inblk = "*" if bs <= cur < be else " "
                    fh.write("%s%06X +8  %-18s OPAQUE mov.w @(0x%06X,er%d),r%d  "
                             "[78-b0 indexed load; h8s300a cannot decode]\n"
                             % (inblk, cur, b[0:8].hex(), disp, (b[1] >> 4) & 7, b[3] & 0xF))
                    nopaque += 1
                    cur += 8
                    continue
                inblk = "*" if bs <= cur < be else " "
                fh.write("%s%06X +1  %-18s DATA byte 0x%02X\n"
                         % (inblk, cur, hexb(cur, 1), ida_bytes.get_byte(cur)))
                ndata += 1
                cur += 1
            fh.write("--- %s: %d insns, %d opaque-loads, %d data bytes ---\n"
                     % (name, ninsn, nopaque, ndata))
    with open(LOG, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("OK decode2.txt\n")


try:
    main()
except Exception:
    with open(LOG, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("TRACE\n" + traceback.format_exc())
idc.qexit(0)

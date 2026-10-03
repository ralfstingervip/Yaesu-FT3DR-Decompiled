r"""Lane F2 v3 — nail block-4 boundaries with a smart resync: on a decode
failure try skip in {1,2,3,4}, accept the smallest skip that yields >=4
consecutive clean instructions. Also enumerate all intra-window branch targets
(each must be a valid instruction start) and probe suspect island starts.
Reopen FIN_MAIN_OTHER; writes only my out dir.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_idp, ida_lines, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "main-raw-other")
LOG = os.path.join(OUT, "ida_run3.log")

WIN = (0x076B4E, 0x076C04)   # block4 routine anchor .. next fn
BLK = (0x076B50, 0x076BED)   # block4 proper
BRANCH_FIRST = {0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F}


def clearrange(a, b):
    ea = a
    while ea < b:
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE)
        ea += 1


def hexb(ea, n):
    return (ida_bytes.get_bytes(ea, n) or b"").hex()


def text_of(ea):
    if ida_ua.create_insn(ea):
        return ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, 0)) or "?"
    return "?"


def clean_ahead(ea, limit, want=4):
    """count consecutive decodable insns from ea (no DB mutation)."""
    insn = ida_ua.insn_t()
    n = 0
    cur = ea
    while cur < limit and n < want:
        sz = ida_ua.decode_insn(insn, cur)
        if sz > 0 and insn.itype != 0:
            n += 1
            cur += sz
        else:
            break
    return n


def main():
    ida_auto.auto_wait()
    try:
        ida_auto.enable_auto(False)
    except Exception:
        pass
    insn = ida_ua.insn_t()
    a, b = WIN
    clearrange(a, b)

    items = []          # (ea, size, kind, text)  kind: C / ISLAND
    branch_targets = set()
    cur = a
    while cur < b:
        sz = ida_ua.decode_insn(insn, cur)
        if sz > 0 and insn.itype != 0:
            txt = text_of(cur)
            items.append((cur, sz, "C", txt))
            # record short-branch target
            fb = ida_bytes.get_byte(cur)
            if sz == 2 and fb in BRANCH_FIRST:
                disp = ida_bytes.get_byte(cur + 1)
                if disp >= 0x80:
                    disp -= 0x100
                branch_targets.add(cur + 2 + disp)
            # 16-bit branch 58 x0 dddd
            if sz == 4 and fb == 0x58:
                d = int.from_bytes(ida_bytes.get_bytes(cur + 2, 2), "big")
                if d >= 0x8000:
                    d -= 0x10000
                branch_targets.add(cur + 4 + d)
            cur += sz
            continue
        # failure: smart resync
        best = None
        for skip in (2, 1, 3, 4):
            if clean_ahead(cur + skip, b, 4) >= 3:
                best = skip
                break
        if best is None:
            best = 2
        items.append((cur, best, "ISLAND", "undecodable %dB %s" % (best, hexb(cur, best))))
        cur += best

    with open(os.path.join(OUT, "block4.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("block4 smart-resync decode [%06X,%06X)  (* = inside block %06X-%06X)\n"
                 % (a, b, BLK[0], BLK[1]))
        ci = ii = 0
        cb = ib = 0
        for ea, sz, kind, txt in items:
            star = "*" if BLK[0] <= ea < BLK[1] else " "
            tgt = "  <== branch target" if ea in branch_targets else ""
            fh.write("%s%06X +%-2d %-18s %-6s %s%s\n"
                     % (star, ea, sz, hexb(ea, sz), kind, txt, tgt))
            if kind == "C":
                ci += 1; cb += sz
            else:
                ii += 1; ib += sz
        fh.write("\n--- %d insns (%d B), %d undecodable islands (%d B) ---\n"
                 % (ci, cb, ii, ib))
        fh.write("branch targets in window: %s\n"
                 % " ".join("%06X" % t for t in sorted(branch_targets)))
        # which islands are branch targets?
        isl = [(ea, sz) for ea, sz, k, _ in items if k == "ISLAND"]
        fh.write("islands: %s\n" % " ".join("%06X(+%d)" % (ea, sz) for ea, sz in isl))
        fh.write("islands that are branch targets: %s\n"
                 % " ".join("%06X" % ea for ea, sz in isl if ea in branch_targets))

    with open(LOG, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("OK block4.txt\n")


try:
    main()
except Exception:
    with open(LOG, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("TRACE\n" + traceback.format_exc())
idc.qexit(0)

r"""Lane G1 -- baseline dump of the G1_H8S private database (seeded from MAIN_FULL).

Writes, for MAIN content 0x000000-0x07B753:
  ida_decsize.bin   one byte per address: ida_ua.decode_insn size (0 = undecodable)
  items.tsv         every head: ea, size, kind(code/data/unk), stop(1 if CF_STOP), func_start, mnem
  funcs.tsv         every function: start, end, name, n_chunks
Read-only on the database (nothing is created or deleted).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_idp, idautils, idc, ida_nalt

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "h8s-decode", "work")
os.makedirs(OUT, exist_ok=True)
LOG = os.path.join(OUT, "g1_dump.log")
LO, HI = 0x000000, 0x07B754
TAG = os.environ.get("G1_TAG", "before")


def main():
    ida_auto.auto_wait()
    sizes = bytearray(HI - LO)
    insn = ida_ua.insn_t()
    for ea in range(LO, HI):
        n = ida_ua.decode_insn(insn, ea)
        sizes[ea - LO] = n if 0 < n < 256 else 0
    with open(os.path.join(OUT, "ida_decsize_%s.bin" % TAG), "wb") as fh:
        fh.write(bytes(sizes))

    with open(os.path.join(OUT, "items_%s.tsv" % TAG), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("ea\tsize\tkind\tstop\tfunc\tmnem\n")
        ea = LO
        if not ida_bytes.is_head(ida_bytes.get_flags(ea)):
            ea = ida_bytes.next_head(ea, HI)
        while ea != idc.BADADDR and ea < HI:
            fl = ida_bytes.get_flags(ea)
            sz = ida_bytes.get_item_size(ea)
            if ida_bytes.is_code(fl):
                kind = "code"
                stop = 0
                mn = ""
                if ida_ua.decode_insn(insn, ea) > 0:
                    feat = insn.get_canon_feature()
                    stop = 1 if (feat & ida_idp.CF_STOP) else 0
                    mn = insn.get_canon_mnem() or ""
                f = ida_funcs.get_func(ea)
                fs = "%06X" % f.start_ea if f else "-"
            elif ida_bytes.is_data(fl):
                kind, stop, mn, fs = "data", 0, "", "-"
            else:
                kind, stop, mn, fs = "unk", 0, "", "-"
            fh.write("%06X\t%d\t%s\t%d\t%s\t%s\n" % (ea, sz, kind, stop, fs, mn))
            ea = ida_bytes.next_head(ea, HI)

    with open(os.path.join(OUT, "funcs_%s.tsv" % TAG), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("start\tend\tname\tchunks\n")
        for fs in idautils.Functions(LO, HI):
            f = ida_funcs.get_func(fs)
            nch = sum(1 for _ in idautils.Chunks(fs))
            fh.write("%06X\t%06X\t%s\t%d\n" % (f.start_ea, f.end_ea, ida_funcs.get_func_name(fs), nch))


try:
    main()
    with open(LOG, "a", encoding="utf-8") as fh:
        fh.write("ok %s\n" % TAG)
except Exception:
    with open(LOG, "a", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
idc.qexit(0)

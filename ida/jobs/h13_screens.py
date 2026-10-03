r"""Lane H13 - screen-byte writer scan (read-only analysis of private DB H13_MAIN).

Lists every MAIN code head (0..0x78106 and 0x7B754..0x80000; the closed window
is skipped) whose disassembly stores to @(1:16,ERn) (screen byte) or stores a
word/long to @(0:16,ERn)/@ERn-style (prev+screen pair), every call of the push
sub_3FF10 and pop sub_3FF3A with 6 heads of context, and absolute aliases of
record +0/+1. Output: ida\out\hidden-settings\screens_raw.txt (UTF-8).
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback
BASE = str(_REPO / "ida/out/hidden-settings")
OUT = os.path.join(BASE, "screens_raw.txt")
ERR = os.path.join(BASE, "h13_screens_error.txt")

def main():
    import ida_auto, ida_ua, ida_bytes, ida_funcs, idc, idautils
    ida_auto.auto_wait()
    out = []
    w = out.append
    def line(ea):
        insn = ida_ua.insn_t()
        n = ida_ua.decode_insn(insn, ea)
        if n <= 0:
            return "%06X  ??" % ea, 1
        raw = ida_bytes.get_bytes(ea, n).hex(" ")
        dis = (idc.generate_disasm_line(ea, 0) or "").split(";")[0].strip()
        return "%06X  %-24s %s" % (ea, raw, dis), n
    def ctx(ea, nb):
        hs = []
        q = ea
        for _ in range(nb):
            q = idc.prev_head(q)
            if q == idc.BADADDR or ea - q > 40:
                break
            hs.append(q)
        for h in reversed(hs):
            w("      " + line(h)[0])
        w("   => " + line(ea)[0])
    st1 = re.compile(r",\s*@\(1:16,er\d\)")
    st0 = re.compile(r"^mov\.[wl]\s+\S+,\s*@\(0:16,er\d\)|^mov\.[wl]\s+\S+,\s*@er\d$")
    w("##### stores to @(1:16,ERn) and word/long stores to @(0,ERn)")
    for lo, hi in ((0, 0x78106), (0x7B754, 0x80000)):
        for h in idautils.Heads(lo, hi):
            if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                continue
            dis = (idc.generate_disasm_line(h, 0) or "").split(";")[0].strip()
            if st1.search(dis) or st0.search(dis):
                f = ida_funcs.get_func(h)
                w("--- %06X [fn %s] %s" % (h, ("%06X" % f.start_ea) if f else "-", "B1" if st1.search(dis) else "W0"))
                ctx(h, 6)
    for tgt in (0x3FF10, 0x3FF3A, 0x3FF2C, 0x3FEFC):
        w("##### calls to %06X" % tgt)
        for x in idautils.XrefsTo(tgt):
            f = ida_funcs.get_func(x.frm)
            w("--- %06X [fn %s] type %d" % (x.frm, ("%06X" % f.start_ea) if f else "-", x.type))
            ctx(x.frm, 6)
    for tgt in (0x3FF2C, 0x3FEFC):
        w("##### func %06X" % tgt)
        ea = tgt
        for _ in range(12):
            s, n = line(ea); w("      " + s); ea += n
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")

try:
    main()
except Exception:
    with open(ERR, "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
import idc
idc.qexit(0)

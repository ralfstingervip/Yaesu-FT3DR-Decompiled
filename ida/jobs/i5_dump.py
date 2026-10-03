r"""Lane I5 range dumper (MAIN, H8SX seed). Reopen-only, read-only analysis.

  --env I5_RANGES=name:lo-hi,...   hex ranges to dump (disassembly + raw bytes)
  --env I5_FORCE=1                 create instructions on undefined bytes in those ranges first
                                   (never inside the closed window 0x078106-0x07B753)
  --env I5_XREF=ea,ea,...          xrefs (code+data) to these addresses -> work\xrefs_<tag>.txt
  --env I5_TAG=name                tag for the xref file
  --env I5_FUNCS=lo-hi             function bounds + callers in a range
Writes ida\out\dsp-session\work\<name>.txt
"""
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "dsp-session", "work")
WLO, WHI = 0x078106, 0x07B754

def esc(t): return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")

def force_code(lo, hi):
    ea, made = lo, 0
    while ea < hi:
        if WLO <= ea < WHI:
            ea = WHI; continue
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            if idc.create_insn(ea) > 0:
                made += 1; ea += max(1, idc.get_item_size(ea)); continue
            ea += 1; continue
        ea += max(1, idc.get_item_size(ea))
    ida_auto.auto_wait()
    return made

def dump(name, lo, hi):
    rows = []
    ea = lo
    while ea < hi:
        if WLO <= ea < WHI:
            rows.append("-- closed window %#x..%#x skipped --" % (WLO, WHI)); ea = WHI; continue
        fl = ida_bytes.get_flags(ea)
        sz = max(1, idc.get_item_size(ea))
        if not ida_bytes.is_code(fl): sz = min(sz, 16)
        raw = ida_bytes.get_bytes(ea, min(sz, 16)) or b""
        txt = ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or "?")
        fn = ida_funcs.get_func(ea)
        head = ""
        if fn and fn.start_ea == ea:
            head = "\n;---- func %#x..%#x\n" % (fn.start_ea, fn.end_ea)
        xr = ["%x" % x.frm for x in idautils.XrefsTo(ea, 0) if x.type != 21]
        rows.append("%s%06x  %-24s %-44s %s" % (head, ea, raw.hex(" "), esc(txt), ("<- " + ",".join(xr[:8])) if xr else ""))
        ea += sz
    with open(os.path.join(OUT, name + ".txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")

def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    log = []
    force = os.environ.get("I5_FORCE", "") == "1"
    for part in [p for p in os.environ.get("I5_RANGES", "").split(",") if p.strip()]:
        name, _, rng = part.partition(":")
        a, _, b = rng.partition("-")
        lo, hi = int(a, 16), int(b, 16)
        if force: log.append("force %s made=%d" % (name, force_code(lo, hi)))
        dump(name, lo, hi); log.append("dump %s %x-%x" % (name, lo, hi))
    xs = [t for t in os.environ.get("I5_XREF", "").split(",") if t.strip()]
    if xs:
        rows = []
        for t in xs:
            ea = int(t, 16)
            for x in idautils.XrefsTo(ea, 0):
                fn = ida_funcs.get_func(x.frm)
                txt = ida_lines.tag_remove(ida_lines.generate_disasm_line(x.frm, ida_lines.GENDSM_REMOVE_TAGS) or "")
                rows.append("%06x\t%06x\t%s\t%d\t%s" % (ea, x.frm, ("%x" % fn.start_ea) if fn else "-", x.type, esc(txt)))
        tag = os.environ.get("I5_TAG", "x")
        with open(os.path.join(OUT, "xrefs_%s.txt" % tag), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
    fr = os.environ.get("I5_FUNCS", "")
    if fr:
        a, _, b = fr.partition("-"); lo, hi = int(a, 16), int(b, 16)
        rows = []
        for f in idautils.Functions(lo, hi):
            fn = ida_funcs.get_func(f)
            callers = sorted(set(idautils.CodeRefsTo(f, 0)))
            rows.append("%06x\t%06x\t%d\t%s" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea, ",".join("%x" % c for c in callers[:12])))
        with open(os.path.join(OUT, "funcs_%x.txt" % lo), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
    rx = os.environ.get("I5_TXT", "")
    if rx:
        import re
        pat = re.compile(rx, re.I)
        rows = []
        ea = 0
        while ea < 0x80000:
            if WLO <= ea < WHI:
                ea = WHI; continue
            fl = ida_bytes.get_flags(ea)
            sz = max(1, idc.get_item_size(ea))
            if ida_bytes.is_code(fl):
                txt = esc(ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or ""))
                if pat.search(txt):
                    fn = ida_funcs.get_func(ea)
                    raw = (ida_bytes.get_bytes(ea, sz) or b"").hex(" ")
                    rows.append("%06x\t%s\t%s\t%s" % (ea, ("%x" % fn.start_ea) if fn else "-", raw, txt))
            ea += sz
        with open(os.path.join(OUT, "txt_%s.tsv" % os.environ.get("I5_TAG", "x")), "w", encoding="utf-8", newline="\n") as h:
            h.write("insn\tfunc\tbytes\tdisasm\n" + "\n".join(rows) + "\n")
    acc = [t for t in os.environ.get("I5_ACC", "").split(",") if t.strip()]
    if acc:
        access_scan(acc, os.environ.get("I5_TAG", "x"))
    with open(os.path.join(OUT, "log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(log) + "\n")

IMG = os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin")

def access_scan(acc, tag):
    """For each RAM/IO address: every code head whose bytes hold it as aa:16 or aa:32 and whose
    IDA disassembly names it. Read-only."""
    data = sys.exit("The firmware image is not in this repository.")
    rows = []
    for t in acc:
        a = int(t, 16)
        pats = [(a & 0xFFFF).to_bytes(2, "big"), a.to_bytes(4, "big")]
        seen = set()
        for pat in pats:
            i = data.find(pat)
            while i >= 0:
                if not (WLO <= i < WHI):
                    head = idc.get_item_head(i)
                    fl = ida_bytes.get_flags(head)
                    if ida_bytes.is_code(fl) and head not in seen:
                        txt = esc(ida_lines.tag_remove(ida_lines.generate_disasm_line(head, ida_lines.GENDSM_REMOVE_TAGS) or ""))
                        if ("%X" % a) in txt.upper():
                            seen.add(head)
                            fn = ida_funcs.get_func(head)
                            raw = (ida_bytes.get_bytes(head, idc.get_item_size(head)) or b"").hex(" ")
                            rows.append("%06x\t%06x\t%s\t%s\t%s" % (a, head, ("%x" % fn.start_ea) if fn else "-", raw, txt))
                i = data.find(pat, i + 1)
    with open(os.path.join(OUT, "acc_%s.tsv" % tag), "w", encoding="utf-8", newline="\n") as h:
        h.write("addr\tinsn\tfunc\tbytes\tdisasm\n" + "\n".join(sorted(rows)) + "\n")

try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

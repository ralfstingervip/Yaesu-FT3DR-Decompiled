import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
# Lane 6: grep all instruction text in MAIN/SUB DB for patterns (one regex per line in L6_pat.txt)
import os, re, idaapi, idc, idautils, ida_funcs, ida_auto, ida_bytes, ida_segment
ROOT = str(_REPO)
pat = os.path.join(ROOT, "ida", "out", "pc", os.environ.get("L6_PAT", "L6_pat.txt"))
out = os.path.join(ROOT, "ida", "out", "pc", os.environ.get("L6_OUT", "L6_grep.txt"))
ida_auto.auto_wait()
pats = [re.compile(l.strip(), re.I) for l in open(pat, encoding="utf-8") if l.strip() and not l.startswith("#")]
with open(out, "w", encoding="utf-8") as f:
    for s in idautils.Segments():
        for ea in idautils.Heads(s, idc.get_segm_end(s)):
            if not ida_bytes.is_code(ida_bytes.get_flags(ea)): continue
            t = idc.generate_disasm_line(ea, 0) or ""
            for p in pats:
                if p.search(t):
                    fn = ida_funcs.get_func(ea)
                    f.write("%X\t%s\t%s\t%s\n" % (ea, ("%X" % fn.start_ea) if fn else "-", p.pattern, t)); break
idc.qexit(0)

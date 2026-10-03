r"""Lane 10 (SUB_LAYOUT, reopen): SUB screen-layout tables + font index.

(1) Segment the layout span 0xFFEB74D8-0xFFECE55C into content regions (pad = >=16
    bytes of 0x00/0xFF), classify each (numeric-scale / ascending index / CJK-charset
    / 6-byte records / pointer table) from the bytes.
(2) Immediate-load readers: every function instruction whose o_imm value lands inside
    the layout span or the bitmap descriptor table [0xFFECE55C,0xFFED3F6C); bucket by
    which segment/table it hits and name the containing functions.
(3) Font index: find sites that compute base + code*16 -- a descriptor-range base
    immediate paired with a shift-left-4 (shll #4) or mul #16 in the same function.
Outputs under ida\out\sub-layout\.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, collections, traceback

OUT = str(_REPO / "ida/out/sub-layout")
BASE   = 0xFFC00000
START  = 0xFFEB74D8
END    = 0xFFECE55C          # == descriptor table base
TBL, TEND = 0xFFECE55C, 0xFFED3F6C   # bitmap descriptor table (16-byte records)
STATUS = os.path.join(OUT, "layout_status.txt")

def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h: h.write(t + "\n")
def esc(t): return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")

def main():
    import ida_bytes, ida_funcs, ida_ua, idautils, idc, ida_auto
    ida_auto.auto_wait()
    O_IMM = ida_ua.o_imm
    M = 0xFFFFFFFF

    # ---- read the whole span from the DB ----
    span = ida_bytes.get_bytes(START, END - START)
    if span is None or len(span) != END - START:
        log("FATAL: could not read span (%r)" % (None if span is None else len(span)))
        return
    def b(a): return span[a - START]
    def u16(a): return struct.unpack_from("<H", span, a - START)[0]
    def u32(a): return struct.unpack_from("<I", span, a - START)[0]

    # ---- (1) segment + classify ----
    def is_pad_run(a):
        v = b(a)
        if v not in (0x00, 0xFF): return 0
        n = 0
        while a + n < END and b(a + n) == v: n += 1
        return n
    segs = []; a = START; cs = None
    while a < END:
        r = is_pad_run(a)
        if r >= 16:
            if cs is not None: segs.append((cs, a)); cs = None
            a += r
        else:
            if cs is None: cs = a
            a += 1
    if cs is not None: segs.append((cs, END))

    def classify(cs, ce):
        n = ce - cs
        vals = [u16(cs + i) for i in range(0, n - 1, 2)]
        core = [v for v in vals if v != 0xFFFF]
        if not core: return "PAD/EMPTY"
        cjk = sum(1 for v in core if 0x3000 <= v < 0xA000)
        pua = sum(1 for v in core if 0xE000 <= v < 0xF900)
        ff  = sum(1 for v in core if 0xFF00 <= v < 0xFFF0)
        sym = sum(1 for v in core if 0x2000 <= v < 0x3000)
        asc = all(core[i] < core[i + 1] for i in range(len(core) - 1))
        if cjk > len(core) * 0.6: return "CHARSET_CJK(n=%d,%04X..%04X)" % (len(core), core[0], core[-1])
        if pua > len(core) * 0.6: return "CHARSET_PUA(n=%d,%04X..%04X)" % (len(core), core[0], core[-1])
        if (ff + sym) > len(core) * 0.5: return "CHARSET_SYM(n=%d,%04X..%04X)" % (len(core), core[0], core[-1])
        if asc and len(core) > 8: return "IDX_ASC(n=%d,%d..%d)" % (len(core), core[0], core[-1])
        return "RECORDS(n=%d,first=%04X %04X %04X)" % (len(core), vals[0],
               vals[1] if len(vals) > 1 else 0, vals[2] if len(vals) > 2 else 0)

    seg_class = []
    for (cs, ce) in segs:
        seg_class.append((cs, ce, classify(cs, ce)))
    with open(os.path.join(OUT, "segments.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tlen\tclass\n")
        for cs, ce, c in seg_class:
            h.write("%08X\t%08X\t%d\t%s\n" % (cs, ce, ce - cs, c))
    log("segments: %d, content bytes %d" % (len(segs), sum(ce - cs for cs, ce in segs)))

    def seg_of(addr):
        for cs, ce, c in seg_class:
            if cs <= addr < ce: return (cs, ce, c)
        return None

    # ---- (2) immediate-load readers of span + descriptor table ----
    reader_hits = []   # (imm, ea, func_start)
    nfunc = ninsn = 0
    for start in idautils.Functions():
        nfunc += 1
        for ea in idautils.FuncItems(start):
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, ea) <= 0: continue
            ninsn += 1
            for i in range(6):
                op = insn.ops[i]
                if op.type == 0: break
                if op.type == O_IMM:
                    v = op.value & M
                    if START <= v < TEND:
                        reader_hits.append((v, ea, start))
    log("imm scan: %d funcs, %d insns, %d hits in span/desc" % (nfunc, ninsn, len(reader_hits)))

    # bucket hits by segment (span) vs descriptor table
    by_seg = collections.defaultdict(list)   # seg-key -> list of (imm,ea,func)
    desc_hits = []
    for v, ea, fn in reader_hits:
        if v >= END:
            desc_hits.append((v, ea, fn))
        else:
            s = seg_of(v)
            key = ("%08X" % s[0], s[2]) if s else ("PAD", "pad/gap")
            by_seg[key].append((v, ea, fn))

    with open(os.path.join(OUT, "readers.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("seg_start\tseg_class\timm\tinsn_ea\tfunc\tdisasm\n")
        for (segk, cls), lst in sorted(by_seg.items()):
            for v, ea, fn in lst:
                h.write("%s\t%s\t%08X\t%08X\t%08X\t%s\n" %
                        (segk, cls, v, ea, fn, esc(idc.generate_disasm_line(ea, 0))))
    with open(os.path.join(OUT, "readers_summary.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("Immediate-load readers of layout span %08X-%08X and descriptor table\n\n" % (START, END))
        for (segk, cls), lst in sorted(by_seg.items()):
            funcs = sorted(set(fn for _, _, fn in lst))
            h.write("SEG %s  %s\n    %d loads, %d distinct funcs: %s\n" %
                    (segk, cls, len(lst), len(funcs), " ".join("%08X" % f for f in funcs[:20])))
        h.write("\nDESCRIPTOR TABLE [%08X,%08X): %d loads, %d distinct funcs\n" %
                (TBL, TEND, len(desc_hits), len(set(fn for _, _, fn in desc_hits))))

    # ---- (3) font index: base + code*16 ----
    # collect per-function: descriptor-range imm loads (base candidates) and shll#4 / mul#16 sites
    font_sites = []   # (func, base_imm, base_ea, scale_ea, scale_disasm)
    for start in idautils.Functions():
        base_loads = []   # (ea, imm)
        scale_ops  = []   # (ea, kind, disasm)
        for ea in idautils.FuncItems(start):
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, ea) <= 0: continue
            mnem = insn.get_canon_mnem().lower()
            for i in range(6):
                op = insn.ops[i]
                if op.type == 0: break
                if op.type == O_IMM:
                    v = op.value & M
                    if TBL <= v < TEND:
                        base_loads.append((ea, v))
            # scale by 16 detection
            if mnem.startswith("shll") or mnem in ("shl", "sll"):
                # shll #imm, Rd  -> op0 imm
                if insn.ops[0].type == O_IMM and (insn.ops[0].value & M) == 4:
                    scale_ops.append((ea, "shll#4", esc(idc.generate_disasm_line(ea, 0))))
            elif mnem.startswith("mul") or mnem.startswith("emul"):
                for i in range(6):
                    op = insn.ops[i]
                    if op.type == O_IMM and (op.value & M) == 16:
                        scale_ops.append((ea, "mul#16", esc(idc.generate_disasm_line(ea, 0))))
        if base_loads and scale_ops:
            for bea, bimm in base_loads:
                # nearest scale op by address
                nearest = min(scale_ops, key=lambda s: abs(s[0] - bea))
                font_sites.append((start, bimm, bea, nearest[0], nearest[1], nearest[2]))
    with open(os.path.join(OUT, "font_index.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("Font-index candidate sites (descriptor-range base immediate in a function\n")
        h.write("that also contains shll #4 / mul #16 -> base + code*16):\n\n")
        h.write("func      base_imm  rec#   base_ea   scale_ea  kind\n")
        for fn, bimm, bea, sea, kind, dis in sorted(set(font_sites)):
            h.write("%08X  %08X  %5d  %08X  %08X  %s   | %s\n" %
                    (fn, bimm, (bimm - TBL) // 16, bea, sea, kind, dis))
        h.write("\ndistinct functions with a font-index pattern: %d\n" %
                len(set(f for f, *_ in font_sites)))
        h.write("distinct base immediates: %s\n" %
                " ".join("%08X" % v for v in sorted(set(b for _, b, *_ in font_sites))))
    log("font sites: %d rows, %d funcs" % (len(font_sites), len(set(f for f, *_ in font_sites))))

    # ---- also dump the descriptor rows that font bases point at, for the doc ----
    def desc_row(rec):
        a = TBL + rec * 16
        raw = ida_bytes.get_bytes(a, 16)
        if not raw or len(raw) != 16: return None
        w, h_, = struct.unpack_from("<HH", raw, 0)
        src, = struct.unpack_from("<I", raw, 4)
        key, tint, mode = struct.unpack_from("<HHH", raw, 8) + (0,) if False else struct.unpack_from("<HHH", raw, 8)
        return (a, w, h_, src, key, tint, mode)
    with open(os.path.join(OUT, "font_descriptors.txt"), "w", encoding="utf-8", newline="\n") as h:
        bases = sorted(set(b for _, b, *_ in font_sites))
        h.write("Descriptor rows at each font base (and the next few records):\n\n")
        for base in bases:
            rec0 = (base - TBL) // 16
            h.write("=== base %08X (rec %d) ===\n" % (base, rec0))
            for k in range(6):
                d = desc_row(rec0 + k)
                if d: h.write("  rec %4d @%08X  w=%3d h=%3d src=%08X key=%04X tint=%04X mode=%d\n" % (rec0 + k, *d))
            h.write("\n")
    log("done")

if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h: _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "layout_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc; _idc.qexit(0)

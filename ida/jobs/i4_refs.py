r"""Lane I4: dump every operand reference to RAM (>= 0xFE0000) and every
call/jump target from all decoded code heads in MAIN 0x000000-0x080000.
Reopen-only. Never decodes anything; skips the closed window 0x78106-0x7B753
(rows inside it are not emitted).

Writes ida\out\dsp-rx\work\refs.tsv:
  ea  func  mnem  opn  optype  addr  disasm
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, ida_ua, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "dsp-rx", "work")
WLO, WHI = 0x078106, 0x07B754

def esc(t): return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")

def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    rows = []
    n = 0
    ea = 0
    end = 0x80000
    while ea < end:
        if WLO <= ea < WHI:
            ea = WHI; continue
        fl = ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(fl):
            ea = ida_bytes.next_head(ea, end)
            if ea == idc.BADADDR: break
            continue
        insn = ida_ua.insn_t()
        if ida_ua.decode_insn(insn, ea) <= 0:
            ea += 1; continue
        n += 1
        mn = insn.get_canon_mnem()
        txt = None
        for i in range(8):
            op = insn.ops[i]
            if op.type == ida_ua.o_void: break
            vals = []
            if op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far):
                vals.append(op.addr)
            elif op.type == ida_ua.o_displ:
                vals.append(op.addr)
            elif op.type == ida_ua.o_imm:
                vals.append(op.value)
            for v in vals:
                v &= 0xFFFFFFFF
                a = v & 0xFFFFFF
                keep = a >= 0xFE0000 or op.type in (ida_ua.o_near, ida_ua.o_far)
                if not keep: continue
                if txt is None:
                    txt = esc(ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or ""))
                fn = ida_funcs.get_func(ea)
                rows.append("%06x\t%s\t%s\t%d\t%d\t%06x\t%s" % (ea, ("%06x" % fn.start_ea) if fn else "-", mn, i, op.type, a, txt))
        ea += max(1, insn.size)
    with open(os.path.join(OUT, "refs.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tfunc\tmnem\topn\toptype\taddr\tdisasm\n")
        h.write("\n".join(rows) + "\n")
    with open(os.path.join(OUT, "refs_log.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("insns=%d rows=%d\n" % (n, len(rows)))

try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "refs_traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)

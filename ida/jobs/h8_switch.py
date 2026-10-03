r"""Lane H8 -- resolve RX relative switch tables (`mov.l #tbl,Rb` ; `mov.{b,w} [Ri,Rb],Rd` ; `bra.l Rd`).

Every `7F 4x` (bra.l Rx) head in 0xFFED0000..0xFFF509DE that IDA decodes as code is examined.
Bound: the nearest preceding `cmp #imm,Ri` (61 / 75 5x / 76 5x forms, decoded by IDA) on the index
register, entries = imm+1. Target = bra_site + sign_extend(entry). Compared with IDA's own switch info.

    python ida/run_job.py --script ida\jobs\h8_switch.py --db H8_SUBGAP --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback

RAW = str(_REPO / "ida/out/sub-gap/raw")
STATUS = os.path.join(RAW, "h8_switch_status.txt")
LO, HI = 0xFFED0000, 0xFFF509DE


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_ua, ida_nalt, idc
    ida_auto.auto_wait()
    gb = ida_bytes.get_byte

    def prev_insns(ea, n):
        out = []; cur = ea
        for _ in range(n):
            p = idc.prev_head(cur, LO)
            if p == idc.BADADDR or cur - p > 8:
                break
            out.append(p); cur = p
        return out

    rows = []; edges = []
    ea = LO
    while ea < HI - 1:
        if gb(ea) == 0x7F and (gb(ea + 1) & 0xF0) == 0x40 and ida_bytes.is_code(ida_bytes.get_flags(ea)):
            rd = gb(ea + 1) & 0xF
            si = ida_nalt.get_switch_info(ea) if hasattr(ida_nalt, "get_switch_info") else None
            ida_n = si.get_jtable_size() if si else 0
            tbl = None; esz = None; ri = None; rb = None; bound = None; note = []
            pv = prev_insns(ea, 14)
            for p in pv:
                b0, b1, b2 = gb(p), gb(p + 1), gb(p + 2)
                if tbl is None and esz is None and b0 == 0xFE and (b2 & 0xF) == rd and (b1 >> 4) in (4, 5, 0xC, 0xD):
                    esz = {4: 1, 5: 2, 0xC: 1, 0xD: 2}[b1 >> 4]
                    signed = (b1 >> 4) in (4, 5)
                    ri = b1 & 0xF; rb = b2 >> 4
                    continue
                if esz and tbl is None and b0 == 0xFB and (b1 >> 4) == rb and (b1 & 0xF) in (0x2, 0xE):
                    if (b1 & 0xF) == 0x2:
                        tbl = struct.unpack("<I", ida_bytes.get_bytes(p + 2, 4))[0]
                    else:
                        v = int.from_bytes(ida_bytes.get_bytes(p + 2, 3), "little")
                        tbl = (v | 0xFF000000) if v & 0x800000 else v
                    continue
                if esz and bound is None:
                    insn = ida_ua.insn_t()
                    if ida_ua.decode_insn(insn, p) > 0 and insn.get_canon_mnem() == "cmp":
                        o0, o1 = insn.ops[0], insn.ops[1]
                        if o0.type == ida_ua.o_imm and o1.type == ida_ua.o_reg and o1.reg == ri:
                            bound = (o0.value & 0xFFFFFFFF)
                            note.append("cmp@%08X" % p)
            if tbl is not None and bound is not None and bound < 512:
                n = bound + 1
                tg = []
                for i in range(n):
                    raw = ida_bytes.get_bytes(tbl + i * esz, esz)
                    if esz == 1:
                        d = struct.unpack("<b" if signed else "<B", raw)[0]
                    else:
                        d = struct.unpack("<h" if signed else "<H", raw)[0]
                    t = (ea + d) & 0xFFFFFFFF
                    tg.append(t); edges.append((ea, t, tbl + i * esz))
                rows.append((ea, tbl, esz, n, ida_n, ";".join(note), ",".join("%08X" % t for t in tg)))
            else:
                rows.append((ea, tbl or 0, esz or 0, 0, ida_n, "UNRESOLVED " + ";".join(note), ""))
            ea += 2
        else:
            ea += 1
    with open(os.path.join(RAW, "switches.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("bra_site\ttable\tentry_size\tentries\tida_entries\tnote\ttargets\n")
        for r in rows:
            h.write("%08X\t%08X\t%d\t%d\t%d\t%s\t%s\n" % r)
    with open(os.path.join(RAW, "switch_edges.tsv"), "w", encoding="utf-8", newline="\n") as h:
        for s, t, e in edges:
            h.write("%08X\t%08X\t%08X\n" % (s, t, e))
    log("bra.l sites %d resolved %d edges %d" % (len(rows), sum(1 for r in rows if r[3]), len(edges)))


try:
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

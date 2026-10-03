r"""Lane H10 -- dump both decodes at every H8 phase-conflict target (read-only on the DB).

    python ida/run_job.py --script ida\jobs\h10_conflicts.py --db H10_SUB --copy-from ida\db\jobs\H8_SUBGAP\H8_SUBGAP.i64
    python ida/run_job.py --script ida\jobs\h10_conflicts.py --db H10_SUB --reopen

For each unique target T in ida\out\sub-gap\raw\conflicts.tsv:
  * IDA stream: IDA items from a few heads before the covering head H until the
    alternative stream re-synchronises (or 14 items).
  * ALT stream: linear decode_insn from T until it lands on a validated head or
    a CF_STOP (max 14 insns).
  * the source chain back to a validated head through ida\out\sub-gap\raw\reach.tsv.
Output: ida\out\sub-phase\raw\conflict_dump.txt and conflict_rows.tsv
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
RAW = os.path.join(ROOT, r"ida\out\sub-phase\raw")
STATUS = os.path.join(RAW, "h10_conflicts_status.txt")
CF_STOP = 0x1


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_idp, idautils, idc
    ida_auto.auto_wait()
    os.makedirs(RAW, exist_ok=True)

    rows = []
    with open(os.path.join(ROOT, r"ida\out\sub-window\functions.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            if p[2] in ("xref", "body"):
                rows.append((int(p[0], 16), int(p[1], 16)))
    valid = set(); vbytes = set(); owner = {}
    for s, e in rows:
        ea = s
        while ea < e:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                sz = max(ida_bytes.get_item_size(ea), 1)
                valid.add(ea); owner[ea] = s
                for k in range(sz):
                    if ea + k < e:
                        vbytes.add(ea + k)
                ea += sz
            else:
                ea += 1
    log("valid heads %d bytes %d" % (len(valid), len(vbytes)))

    reach = {}
    with open(os.path.join(ROOT, r"ida\out\sub-gap\raw\reach.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            reach[int(p[0], 16)] = (int(p[2], 16), p[3], p[4])

    conf = {}
    with open(os.path.join(ROOT, r"ida\out\sub-gap\raw\conflicts.tsv"), encoding="utf-8") as h:
        next(h)
        for ln in h:
            p = ln.rstrip("\n").split("\t")
            conf.setdefault(int(p[0], 16), []).append((int(p[1], 16), p[2]))

    def fmt(ea):
        insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            return 1, "%02x" % ida_bytes.get_byte(ea), "<invalid>", False
        bb = (ida_bytes.get_bytes(ea, ln) or b"").hex()
        ops = []
        for op in insn.ops:
            if op.type == 0:
                break
            if op.type == ida_ua.o_reg:
                ops.append(ida_idp.get_reg_name(op.reg, 4))
            elif op.type == ida_ua.o_imm:
                ops.append("#%X" % (op.value & 0xFFFFFFFF))
            elif op.type in (ida_ua.o_near, ida_ua.o_far):
                ops.append("%08X" % op.addr)
            elif op.type == ida_ua.o_mem:
                ops.append("[%X]" % op.addr)
            elif op.type == ida_ua.o_phrase:
                ops.append("[%s]" % ida_idp.get_reg_name(op.reg, 4))
            elif op.type == ida_ua.o_displ:
                ops.append("%X[%s]" % (op.value & 0xFFFFFFFF, ida_idp.get_reg_name(op.reg, 4)))
            else:
                ops.append("t%d(r%d,v%X,a%X)" % (op.type, op.reg, op.value & 0xFFFFFFFF, op.addr))
        txt = insn.get_canon_mnem() + " " + ", ".join(ops)
        return ln, bb, txt, bool(insn.get_canon_feature() & CF_STOP)

    def state(ea):
        fl = ida_bytes.get_flags(ea)
        if ea in valid:
            return "V"
        if ea in vbytes:
            return "v"
        return "C" if ida_bytes.is_code(fl) else ("D" if ida_bytes.is_data(fl) else ("t" if ida_bytes.is_tail(fl) else "u"))

    out = open(os.path.join(RAW, "conflict_dump.txt"), "w", encoding="utf-8", newline="\n")
    tsv = open(os.path.join(RAW, "conflict_rows.tsv"), "w", encoding="utf-8", newline="\n")
    tsv.write("target\tcover_head\tcover_owner\tida_insn\talt_first\talt_resync\talt_n\talt_invalid\talt_bytes\tida_bytes\tsrcs\tchain\n")
    for T in sorted(conf):
        H = ida_bytes.get_item_head(T)
        f = ida_funcs.get_func(T)
        out.write("=" * 70 + "\n== target %08X  cover head %08X  owner(valid) %s  idafunc %s\n" % (
            T, H, ("%08X" % owner[H]) if H in owner else "-", ("%08X" % f.start_ea) if f else "-"))
        chains = []
        for src, kind in conf[T]:
            ch = [("%08X" % src) + ":" + kind]
            cur = src; guard = 0
            while cur not in valid and cur in reach and guard < 400:
                s2, k2, t2 = reach[cur]
                ch.append("%08X:%s" % (s2, k2)); cur = s2; guard += 1
            ch.append("root=%s" % ("valid" if cur in valid else "notvalid"))
            chains.append(" <- ".join(ch))
        for c in sorted(set(chains)):
            out.write("   src chain: " + c[:600] + "\n")
        # sources decoded
        for src in sorted(set(s for s, _ in conf[T])):
            ln, bb, txt, st = fmt(src)
            out.write("   SRC %08X %s %-14s %s\n" % (src, state(src), bb, txt))
        # IDA stream
        out.write("  IDA items:\n")
        ea = H
        for _ in range(4):
            p = idc.prev_head(ea, H - 0x40)
            if p == idc.BADADDR:
                break
            ea = p
        alt = []
        cur = T; inval = 0
        for _ in range(14):
            ln, bb, txt, st = fmt(cur)
            alt.append((cur, ln, bb, txt, st))
            if txt == "<invalid>":
                inval += 1
            cur += ln
            if cur in valid or st:
                break
        resync = cur
        n = 0
        while ea <= max(resync, T) and n < 24:
            ln, bb, txt, st = fmt(ea)
            sz = max(ida_bytes.get_item_size(ea), 1)
            out.write("   %s %08X %-14s %s%s\n" % (state(ea), ea, bb, txt, "   <== covers T" if ea == H else ""))
            ea += sz; n += 1
        out.write("  ALT linear from T:\n")
        for a, ln, bb, txt, st in alt:
            out.write("   %s %08X %-14s %s\n" % (state(a), a, bb, txt))
        out.write("   resync at %08X (%s)\n" % (resync, state(resync)))
        tsv.write("%08X\t%08X\t%s\t%s\t%s\t%08X\t%d\t%d\t%s\t%s\t%s\t%s\n" % (
            T, H, ("%08X" % owner[H]) if H in owner else "-", fmt(H)[2], alt[0][3], resync, len(alt), inval,
            (ida_bytes.get_bytes(T, max(1, resync - T)) or b"").hex()[:64],
            (ida_bytes.get_bytes(H, max(1, ida_bytes.get_item_size(H))) or b"").hex(),
            ";".join("%08X:%s" % x for x in conf[T]), " | ".join(sorted(set(chains)))[:400]))
    out.close(); tsv.close()
    log("done %d targets" % len(conf))


try:
    main()
except Exception:
    os.makedirs(RAW, exist_ok=True)
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)

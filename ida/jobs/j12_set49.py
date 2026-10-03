r"""Lane J12 - attribute the 49 unattributed MAIN settings bytes.

Read-only analysis of a PRIVATE copy of MAIN_FINAL2 (seed via run_job --copy-from).
For each dedicated writer call-site of the 49 bytes it finds the containing function
and every caller (with caller-function + short context), and it scans the whole code
for every reader/writer of each of the 49 RAM addresses (abs16/abs32 and base+displ).

    python "ida/run_job.py" --script ida\jobs\j12_set49.py \
        --db J12_SET49 --copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64
    python "...\run_job.py" --script ida\jobs\j12_set49.py --db J12_SET49 --reopen
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

BASE = str(_REPO / "ida/out/settings-49")
OUT = os.path.join(BASE, "dump.txt")
ERR = os.path.join(BASE, "j12_error.txt")

# dedicated writer call-sites of the 49 bytes (from F5 settings-bytes.tsv)
WSITES = [0x192AC, 0x15E9C, 0x19356, 0x1935E, 0x1938E, 0x19402, 0x19768,
          0x198C8, 0x198D8, 0x1990C, 0x19A3A, 0x19A50, 0x19A58, 0x19A60,
          0x19A68, 0x19A70, 0x19A78, 0x19A86]

# RAM addresses of the 49 bytes
RADDRS = ([0xFF8937] +
          list(range(0xFF8978, 0xFF8988)) +         # 0x58..0x67
          [0xFF89C9, 0xFF89CA, 0xFF89CB] +
          [0xFF8A58, 0xFF8A59] +
          [0xFF8AAA, 0xFF8C2C] +
          [0xFF8DD0, 0xFF8DD1, 0xFF8DD5, 0xFF8DD6] +
          [0xFF8DDE, 0xFF8DDF, 0xFF8DE0, 0xFF8DE1, 0xFF8DE2, 0xFF8DE7] +
          list(range(0xFF8E40, 0xFF8E4F)))          # 0x120..0x12E

# region base loads to catch base+displacement access
REGION_BASES = [0xFF8920, 0xFF8AA0, 0xFF8D20]


def main():
    import ida_auto, ida_ua, ida_funcs, ida_bytes, idc, idautils
    ida_auto.auto_wait()
    out = []
    w = out.append

    def ops(insn):
        r = []
        for i in range(8):
            op = insn.ops[i]
            if op.type == ida_ua.o_void:
                break
            if op.type == ida_ua.o_imm:
                r.append("#0x%X" % (op.value & 0xFFFFFFFF))
            elif op.type == ida_ua.o_displ:
                r.append("d(R%d,+0x%X)" % (op.reg, op.value & 0xFFFFFFFF))
            elif op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far):
                r.append("a=0x%X" % (op.addr & 0xFFFFFFFF))
            elif op.type == ida_ua.o_reg:
                r.append("R%d" % op.reg)
            else:
                r.append("t%d" % op.type)
        return " ".join(r)

    def line(ea):
        insn = ida_ua.insn_t()
        n = ida_ua.decode_insn(insn, ea)
        if n <= 0:
            return None, 1
        raw = ida_bytes.get_bytes(ea, n).hex(" ")
        dis = idc.generate_disasm_line(ea, 0) or ""
        return "%08X  %-26s %-40s ; %s" % (ea, raw, dis.split(";")[0].strip(), ops(insn)), n

    def fname(ea):
        f = ida_funcs.get_func(ea)
        return ("%08X" % f.start_ea) if f else "-"

    # ---- 1. writer sites -> containing function + callers ----
    w("================ WRITER SITES -> FUNCTION + CALLERS ================")
    seen_funcs = {}
    for s in WSITES:
        f = ida_funcs.get_func(s)
        if f is None:
            ida_ua.create_insn(s)
            ida_funcs.add_func(s)
            ida_auto.auto_wait()
            f = ida_funcs.get_func(s)
        if f is None:
            w("## wsite %08X : NO FUNCTION" % s)
            continue
        key = f.start_ea
        w("## wsite %08X  in func %08X-%08X" % (s, f.start_ea, f.end_ea))
        if key in seen_funcs:
            w("   (same function as wsite %08X)" % seen_funcs[key])
            continue
        seen_funcs[key] = s
        callers = sorted(set(x.frm for x in idautils.XrefsTo(f.start_ea)))
        w("   callers of %08X: %s" % (f.start_ea, " ".join("%08X" % c for c in callers) or "(none)"))
        for c in callers:
            w("     caller %08X [fn %s]" % (c, fname(c)))
            # 4 heads of context before+at+after the caller
            st = c
            for _k in range(4):
                q = idc.prev_head(st)
                if q == idc.BADADDR or st - q > 10:
                    break
                st = q
            cur = st
            for _k in range(8):
                sline, n = line(cur)
                if sline is None:
                    w("       %08X  ?? %02X" % (cur, ida_bytes.get_byte(cur)))
                    cur += 1
                else:
                    w(("     => " if cur == c else "        ") + sline)
                    cur += n
                if cur > c + 8:
                    break

    # ---- 2. full function listing of each distinct composite routine ----
    w("")
    w("================ COMPOSITE SAVE ROUTINES (full) ================")
    for key in sorted(seen_funcs):
        f = ida_funcs.get_func(key)
        if f is None:
            continue
        w("###### func %08X-%08X" % (f.start_ea, f.end_ea))
        for ch in idautils.Chunks(f.start_ea):
            ea2 = ch[0]
            while ea2 < ch[1]:
                if ida_bytes.is_code(ida_bytes.get_flags(ea2)):
                    sline, n = line(ea2)
                    if sline:
                        w(sline)
                    ea2 += n
                else:
                    sz = ida_bytes.get_item_size(ea2) or 1
                    w("%08X  data %s" % (ea2, ida_bytes.get_bytes(ea2, min(sz, 16)).hex(" ")))
                    ea2 += sz

    # ---- 2b. full decode of the three screen tables (to resolve table-reached stubs) ----
    w("")
    w("================ SCREEN TABLES (0x782C notify, 0x12268 dial, 0x19A9E exit) ================")

    def rd_be16(ea):
        return (ida_bytes.get_byte(ea) << 8) | ida_bytes.get_byte(ea + 1)

    def rd_be32(ea):
        return (ida_bytes.get_byte(ea) << 24) | (ida_bytes.get_byte(ea + 1) << 16) | \
               (ida_bytes.get_byte(ea + 2) << 8) | ida_bytes.get_byte(ea + 3)

    # exit table 0x19A9E: BE16 x206, handler = 0x148A0 + val, index = id-0x0E
    w("-- exit table 0x19A9E (id -> handler = 0x148A0+BE16) --")
    for idx in range(206):
        idd = idx + 0x0E
        val = rd_be16(0x19A9E + 2 * idx)
        hdl = 0x148A0 + val
        w("  id 0x%02X  off 0x%04X  handler 0x%06X" % (idd, val, hdl))
    # notifier 0x782C: BE32 x239, index = id
    w("-- notifier table 0x782C (id -> notifier BE32) --")
    for idd in range(239):
        val = rd_be32(0x782C + 4 * idd)
        w("  id 0x%02X  notify 0x%06X" % (idd, val & 0xFFFFFF))
    # dial 0x12268: BE32 x219, index = id-0x0E
    w("-- dial table 0x12268 (id -> dial BE32) --")
    for idx in range(219):
        idd = idx + 0x0E
        val = rd_be32(0x12268 + 4 * idx)
        w("  id 0x%02X  dial 0x%06X" % (idd, val & 0xFFFFFF))

    # ---- 3. readers/writers of each of the 49 RAM bytes ----
    w("")
    w("================ ALL REFERENCES TO THE 49 RAM BYTES ================")
    def norm(a):
        return a & 0xFFFFF   # low 20 bits: 0xFFFF8xxx and 0xFF8xxx both -> 0xF8xxx
    raddr_set = set(norm(a) for a in RADDRS)
    norm2addr = {norm(a): a for a in RADDRS}
    base_set = set(REGION_BASES)
    refs = {a: [] for a in RADDRS}
    base_hits = []   # base+displacement accesses that land in one of the 49
    for seg in idautils.Segments():
        end = idc.get_segm_end(seg)
        for h in idautils.Heads(seg, end):
            if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                continue
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, h) <= 0:
                continue
            # direct abs16/abs32 (o_mem) or immediate equal to a target addr
            for i in range(8):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                if op.type == ida_ua.o_mem and norm(op.addr & 0xFFFFFFFF) in raddr_set:
                    sline, _ = line(h)
                    refs[norm2addr[norm(op.addr & 0xFFFFFFFF)]].append("%s   [fn %s]" % (sline, fname(h)))
                elif op.type == ida_ua.o_imm and norm(op.value & 0xFFFFFFFF) in raddr_set and (op.value & 0xFFFFFFFF) >= 0xFF0000:
                    sline, _ = line(h)
                    refs[norm2addr[norm(op.value & 0xFFFFFFFF)]].append("IMM %s   [fn %s]" % (sline, fname(h)))
            # base+displacement: base reg loaded with a region base in prior 4 heads
            for i in range(4):
                op = insn.ops[i]
                if op.type not in (ida_ua.o_displ, ida_ua.o_phrase):
                    continue
                reg = op.reg
                disp = (op.value & 0xFFFFFFFF) if op.type == ida_ua.o_displ else 0
                q = h
                baseval = None
                for _k in range(5):
                    q = idc.prev_head(q)
                    if q == idc.BADADDR:
                        break
                    pi = ida_ua.insn_t()
                    if ida_ua.decode_insn(pi, q) <= 0:
                        break
                    o0, o1 = pi.ops[0], pi.ops[1]
                    if o1.type == ida_ua.o_reg and o1.reg == reg:
                        if o0.type == ida_ua.o_imm:
                            baseval = o0.value & 0xFFFFFFFF
                        break
                if baseval is not None and (baseval in base_set):
                    eff = (baseval + disp) & 0xFFFFFFFF
                    if norm(eff) in raddr_set:
                        sline, _ = line(h)
                        base_hits.append("eff=%08X base=%08X disp=0x%X  %s   [fn %s]" %
                                         (eff, baseval, disp, sline, fname(h)))

    for a in RADDRS:
        w("-- %08X (%d refs) --" % (a, len(refs[a])))
        for r in refs[a]:
            w("   " + r)
    w("")
    w("-- base+displacement hits landing in the 49 --")
    for bh in base_hits:
        w("   " + bh)

    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")
    w2 = len(out)
    print("J12 wrote %d lines to %s" % (w2, OUT))


try:
    main()
except Exception:
    with open(ERR, "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
import idc
idc.qexit(0)

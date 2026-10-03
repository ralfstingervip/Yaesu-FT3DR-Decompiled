r"""Lane 4 -- SUB code window 0xFFED0000-0xFFF50000.

Classifies every function whose start is in the window into
  reached-by-xref  : a call/jump/vector reaches its start
  validated-by-body: no such xref, but real prologue + clean decode + a return
  rejected         : sweep noise (no prologue, or body does not decode/return)
then recovers code the prologue sweep missed (call/jump targets, pointer-table
targets, the RTE stub run), and proves an instruction-byte denominator by
byte-classifying the window and pinning the known data tables.

    python ida/run_job.py --script ida\jobs\full_l4_window.py \
        --db SUB_WINDOW --copy-from ida\db\jobs\SUB_VEC\SUB_VEC.i64 --timeout 7000
    (iterate with --reopen)
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

OUT = str(_REPO / "ida/out/sub-window")
BASE = 0xFFC00000
WIN_LO = 0xFFED0000
WIN_HI = 0xFFF50000
MINE_HI = 0xFFFFFF80
STATUS = os.path.join(OUT, "l4_status.txt")

# known peripheral registers (from doc 02) for purpose attribution
PERIPH = {
    0x0008A000: "SCI0", 0x0008A002: "SCI0.SCR", 0x0008A004: "SCI0.SSR", 0x0008A005: "SCI0.RDR",
    0x0008A040: "SCI2", 0x0008A042: "SCI2.SCR", 0x0008A044: "SCI2.SSR", 0x0008A045: "SCI2.RDR",
    0x0008A060: "SCI3", 0x0008A062: "SCI3.SCR", 0x0008A064: "SCI3.SSR", 0x0008A065: "SCI3.RDR",
    0x0008AC00: "SDHI", 0x0008AC38: "SDHI.SDSTS1", 0x0008AC3C: "SDHI.SDSTS2", 0x0008AC60: "SDHI.SDBUFR",
    0x000820C0: "DMAC3", 0x000820DE: "DMAC3.DMSTS",
    0x00082800: "EXDMAC0", 0x0008281E: "EXDMAC0.EDMSTS",
    0x00088150: "TPU4", 0x00088155: "TPU4.TSR", 0x00088110: "TPU0", 0x00088115: "TPU0.TSR",
    0x00088140: "TPU3", 0x00088145: "TPU3.TSR", 0x00088018: "CMT3.CMCR", 0x0008801C: "CMT3.CMCOR",
    0x00089000: "S12AD0.ADCSR", 0x00089004: "S12AD0.ADANSA", 0x00089020: "S12AD0.ADDR0",
    0x00088040: "R12DA.DADR0", 0x00088044: "R12DA.DACR",
    0x000C1A00: "MTU6", 0x000C1A80: "MTU.TSTRB", 0x000C1A84: "MTU.TRWERB", 0x000C1284: "MTU.TRWERA",
    0x00080010: "MSTPCRA", 0x000803FE: "PRCR", 0x00080020: "SCKCR", 0x00080028: "PLLCR",
    0x00083010: "BSC.CS", 0x00083802: "BSC.CSnCR", 0x0008C100: "MPC.PFCSE",
    0x00087000: "ICU.IR", 0x00087200: "ICU.IER", 0x00087300: "ICU.IPR",
    0x00087780: "ICU.SLIBXR", 0x000879D0: "ICU.SLIAR", 0x00087630: "ICU.GRPBL0",
}
BLIT = {0xFFEF0648, 0xFFEF04F7, 0xFFEF68D5}  # UI draw chain (doc 16)


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc

    def gb(ea):
        b = ida_bytes.get_byte(ea)
        return b if b is not None else 0xFF

    def is_ret_at(ea):
        b0 = gb(ea)
        if b0 == 0x02:            # rts
            return 1
        if b0 == 0x7F and gb(ea + 1) in (0x94, 0x95):   # rtfi / rte
            return 2
        if b0 == 0x67:            # rtsd #imm
            return 2
        if b0 == 0x3F:            # rtsd rlo-rhi,#imm
            return 3
        return 0

    def is_prologue(ea):
        b0, b1 = gb(ea), gb(ea + 1)
        if b0 == 0x6E:                                  # pushm rA-rB
            return 1 <= (b1 >> 4) < (b1 & 0xF) <= 15
        if b0 == 0x7E and 0xA0 <= b1 <= 0xAF:           # push.l rN
            return True
        if b0 == 0x60 and (b1 & 0x0F) == 0 and (b1 >> 4):   # sub #imm4,sp
            return True
        if b0 == 0x71 and b1 == 0x04:                   # add #imm,sp,sp
            return True
        if b0 == 0xFB and (b1 & 0x0F) in (0x02, 0x0E):  # mov.l #imm,rd  (frame ptr / arg setup)
            return True
        return False

    def has_call_or_jump_ref(ea):
        # incoming code xref that is not fall-through flow (call or jump or vector-created)
        for xr in idautils.XrefsTo(ea, 0):
            if xr.iscode and xr.type != 21:   # 21 = fl_F ordinary flow
                return True
        return False

    # ---------- Phase A: classify existing window functions ----------
    win_funcs = [s for s in idautils.Functions(WIN_LO, WIN_HI)]
    log("window functions at start (pre-recovery): %d" % len(win_funcs))

    # ---------- Phase B: recover missed code ----------
    # B1: call/jump targets inside the window that are not yet functions
    created_bt = 0
    for s in list(idautils.Functions(WIN_LO, MINE_HI)):
        f = ida_funcs.get_func(s)
        if not f:
            continue
        e = f.start_ea
        while e < f.end_ea and e != idc.BADADDR:
            for ref in idautils.CodeRefsFrom(e, 0):   # calls+jumps only (no flow)
                if WIN_LO <= ref < WIN_HI and ida_funcs.get_func(ref) is None:
                    ida_bytes.del_items(ref, ida_bytes.DELIT_SIMPLE, 2)
                    if ida_ua.create_insn(ref):
                        ida_auto.auto_make_proc(ref)
                        created_bt += 1
            e = idc.next_head(e, f.end_ea)
    ida_auto.auto_wait()
    log("B1 call/jump targets created %d" % created_bt)

    # B2: pointer-table follows -- aligned dwords anywhere pointing at a window prologue
    created_pt = 0
    seg = None
    import ida_segment
    seg = ida_segment.get_first_seg()
    ptrseen = set()
    while seg is not None:
        blob = ida_bytes.get_bytes(seg.start_ea, seg.end_ea - seg.start_ea) or b""
        for off in range(0, len(blob) - 3, 4):
            v = int.from_bytes(blob[off:off + 4], "little")
            if WIN_LO <= v < WIN_HI and v not in ptrseen:
                ptrseen.add(v)
                if ida_funcs.get_func(v) is None and is_prologue(v):
                    ida_bytes.del_items(v, ida_bytes.DELIT_SIMPLE, 2)
                    if ida_ua.create_insn(v):
                        ida_auto.auto_make_proc(v)
                        created_pt += 1
        seg = ida_segment.get_next_seg(seg.start_ea)
    ida_auto.auto_wait()
    log("B2 pointer-table targets created %d" % created_pt)

    # B3: the RTE/WAIT empty-handler stub run 0xFFF47E34-0xFFF47FD0 (2-byte instrs)
    created_stub = 0
    ea = 0xFFF47E34
    while ea < 0xFFF47FD0:
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 2)
            if ida_ua.create_insn(ea):
                created_stub += 1
        ea += 2
    ida_auto.auto_wait()
    log("B3 stub-run insns created %d" % created_stub)

    # B4: xref closure
    for rnd in range(25):
        add = set()
        for s in list(idautils.Functions(WIN_LO, MINE_HI)):
            f = ida_funcs.get_func(s)
            if not f:
                continue
            e = f.start_ea
            while e < f.end_ea and e != idc.BADADDR:
                for ref in idautils.CodeRefsFrom(e, 0):
                    if WIN_LO <= ref < WIN_HI and ida_funcs.get_func(ref) is None:
                        add.add(ref)
                e = idc.next_head(e, f.end_ea)
        if not add:
            log("B4 xref closure settled after %d rounds" % rnd)
            break
        made = 0
        for ref in add:
            ida_bytes.del_items(ref, ida_bytes.DELIT_SIMPLE, 2)
            if ida_ua.create_insn(ref):
                ida_auto.auto_make_proc(ref)
                made += 1
        ida_auto.auto_wait()
        if made == 0:
            break
    ida_auto.auto_wait()

    # ---------- Phase A' : classify after recovery ----------
    def peripheral_purpose(f):
        hits = []
        e = f.start_ea
        cnt = 0
        while e < f.end_ea and e != idc.BADADDR and cnt < 400:
            cnt += 1
            if gb(e) == 0xFB:
                lo = gb(e + 1) & 0x0F
                if lo == 0x0E:
                    v = int.from_bytes(ida_bytes.get_bytes(e + 2, 3) or b"\0", "little")
                elif lo == 0x02:
                    v = int.from_bytes(ida_bytes.get_bytes(e + 2, 4) or b"\0", "little")
                else:
                    v = -1
                if v in PERIPH:
                    hits.append(PERIPH[v])
                elif v in BLIT:
                    hits.append("UI-draw")
            for ref in idautils.CodeRefsFrom(e, 0):
                if ref in BLIT:
                    hits.append("UI-draw")
            e = idc.next_head(e, f.end_ea)
        # dedupe preserve order
        seen = []
        for h in hits:
            if h not in seen:
                seen.append(h)
        return seen

    rows = []
    n_xref = n_body = n_reject = 0
    ib_xref = ib_body = 0
    purposed = 0
    reject_list = []
    for s in idautils.Functions(WIN_LO, WIN_HI):
        f = ida_funcs.get_func(s)
        if not f:
            continue
        size = f.end_ea - f.start_ea
        xref = has_call_or_jump_ref(s)
        # body decode + return check
        good = True
        ret = 0
        ins = 0
        e = f.start_ea
        while e < f.end_ea and e != idc.BADADDR:
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, e)
            if ln <= 0:
                good = False
                break
            ins += 1
            if is_ret_at(e):
                ret += 1
            nxt = idc.next_head(e, f.end_ea)
            if nxt == idc.BADADDR:
                break
            e = nxt
        prol = is_prologue(f.start_ea)
        firstbytes = (ida_bytes.get_bytes(s, min(8, size)) or b"").hex()
        purposes = peripheral_purpose(f)
        purpose = ",".join(purposes)
        if xref:
            validated = "xref"
            n_xref += 1
            ib_xref += size
        elif good and ret > 0 and prol:
            validated = "body"
            n_body += 1
            ib_body += size
            if purpose:
                purposed += 1
        else:
            validated = "rejected"
            n_reject += 1
            reject_list.append((s, f.end_ea, size, prol, ret, good))
        ev = "start %08X:%s ret=%d ins=%d prol=%d" % (s, firstbytes, ret, ins, int(prol))
        rows.append((s, f.end_ea, validated, "yes" if xref else "no", purpose, ev, size))
    log("classified: xref %d body %d rejected %d  ib_xref %d ib_body %d purposed %d" % (
        n_xref, n_body, n_reject, ib_xref, ib_body, purposed))

    # ---------- Phase C: instruction-byte denominator ----------
    code_b = data_b = undef_b = 0
    ff_b = zero_b = 0
    ea = WIN_LO
    while ea < WIN_HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            code_b += 1
        elif ida_bytes.is_data(fl):
            data_b += 1
        else:
            undef_b += 1
        b = gb(ea)
        if b == 0xFF:
            ff_b += 1
        elif b == 0x00:
            zero_b += 1
        ea += 1

    # proved data subregions in the window
    DESC_LO, DESC_HI = 0xFFED0000, 0xFFED3F6C   # bitmap descriptor-table tail (doc 16)
    INTB_LO, INTB_HI = 0xFFED8A70, 0xFFED8E70   # 256*4 relocatable vector table (doc 02)
    desc_bytes = DESC_HI - DESC_LO
    intb_bytes = INTB_HI - INTB_LO

    # printable-ASCII string runs (>=6 chars) in the window, as data evidence
    str_bytes = 0
    run = 0
    ea = WIN_LO
    while ea < WIN_HI:
        b = gb(ea)
        if 0x20 <= b < 0x7F:
            run += 1
        else:
            if b == 0 and run >= 6:
                str_bytes += run + 1
            run = 0
        ea += 1

    # ---------- outputs ----------
    with open(os.path.join(OUT, "functions.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tvalidated\txref\tpurpose\tevidence\n")
        for s, e, v, x, p, ev, sz in sorted(rows):
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\n" % (s, e, v, x, p, ev))

    with open(os.path.join(OUT, "rejected.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tsize\thas_prologue\tn_ret\tdecodes\n")
        for s, e, sz, pr, rt, gd in sorted(reject_list):
            h.write("%08X\t%08X\t%d\t%d\t%d\t%d\n" % (s, e, sz, int(pr), rt, int(gd)))

    total_win = WIN_HI - WIN_LO
    with open(os.path.join(OUT, "coverage.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("Lane 4 SUB code window coverage\n")
        h.write("database SUB_WINDOW  (copy of SUB_VEC.i64)\n")
        h.write("window %08X-%08X = %d bytes\n" % (WIN_LO, WIN_HI, total_win))
        h.write("\n-- recovery this pass --\n")
        h.write("B1 call/jump targets created  %d\n" % created_bt)
        h.write("B2 pointer-table targets created %d\n" % created_pt)
        h.write("B3 RTE/WAIT stub insns created  %d\n" % created_stub)
        h.write("\n-- function classification (start in window) --\n")
        h.write("reached-by-xref     %d functions  %d instruction bytes\n" % (n_xref, ib_xref))
        h.write("validated-by-body   %d functions  %d instruction bytes\n" % (n_body, ib_body))
        h.write("rejected (noise)    %d functions\n" % n_reject)
        h.write("validated total     %d functions  %d instruction bytes  (numerator)\n" % (
            n_xref + n_body, ib_xref + ib_body))
        h.write("body funcs with non-empty purpose citing start: %d\n" % purposed)
        h.write("\n-- byte classification of window --\n")
        h.write("IDA-code bytes      %d (%.1f%%)\n" % (code_b, 100.0 * code_b / total_win))
        h.write("IDA-data bytes      %d (%.1f%%)\n" % (data_b, 100.0 * data_b / total_win))
        h.write("undefined bytes     %d (%.1f%%)\n" % (undef_b, 100.0 * undef_b / total_win))
        h.write("0xFF bytes          %d\n" % ff_b)
        h.write("0x00 bytes          %d\n" % zero_b)
        h.write("printable-string bytes (>=6-run) %d\n" % str_bytes)
        h.write("\n-- proved data subregions (denominator method) --\n")
        h.write("bitmap descriptor-table tail %08X-%08X = %d bytes (doc16: 16-byte records)\n" % (
            DESC_LO, DESC_HI, desc_bytes))
        h.write("INTB relocatable vector table %08X-%08X = %d bytes (doc02: 256 x 4)\n" % (
            INTB_LO, INTB_HI, intb_bytes))
        proved_data = desc_bytes + intb_bytes
        instr_denom = total_win - proved_data
        h.write("proved data (tables)            %d bytes\n" % proved_data)
        h.write("instruction-byte denominator    %d bytes (window - proved tables)\n" % instr_denom)
        h.write("  numerator/denominator = %d/%d = %.1f%%\n" % (
            ib_xref + ib_body, instr_denom, 100.0 * (ib_xref + ib_body) / instr_denom))
        h.write("  numerator/full-window = %d/%d = %.1f%%\n" % (
            ib_xref + ib_body, total_win, 100.0 * (ib_xref + ib_body) / total_win))

    log("outputs written")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "l4_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)

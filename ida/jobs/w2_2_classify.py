r"""Lane W2-2: MAIN functions 0x05A000 <= ea <= 0x07B753 -- validate + purpose.

Seeded --copy-from ida\db\jobs\MAIN_FULL\MAIN_FULL.i64 into DB W2_MAIN_HI_B.

Stage A  conservative recovery of missed code inside the range:
           * call/jump/vector targets in [LO,HI] not yet functions
           * undefined runs in [LO,HI] that decode cleanly (prologue+return)
Stage B  classify every function with LO <= start <= HI:
           * validated test, decode stats, peripherals, callees, callers,
             settings writers, string refs, dispatch idioms
           * purpose line citing start address; closed window gets closed line
Stage C  byte accounting in range; write main-high-b.tsv + counts log.

Outputs under ida\out\fnindex\ :
  main-high-b.tsv        start,end,validated,xref,purpose,evidence
  main-high-b-extra.tsv  callees / callers / regs / strings detail
  w2_2_counts.txt        the integers the score needs
  w2_2_log.txt           run log / traceback
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_segment
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "fnindex")
os.makedirs(OUT, exist_ok=True)
LOG_PATH = os.path.join(OUT, "w2_2_log.txt")
_LOG = []

LO = 0x05A000
HI = 0x07B753          # inclusive; functions with LO <= start <= HI
CONTENT_END = 0x07B754  # fill begins here
CLOSED_LO = 0x078106    # DSP loader / CDC-ACM service window (closed)
CLOSED_HI = 0x07B753
FUNCS_TSV = os.path.join(ROOT, "ida", "out", "main-full", "functions.tsv")

RET = ("rts", "rte", "rtsl")
CALL = ("jsr", "bsr")
BRANCH = ("bra", "beq", "bne", "bcs", "bcc", "bhi", "bls", "bmi", "bpl", "bvs",
          "bvc", "bge", "blt", "bgt", "ble", "bt", "bf")
JMP = ("jmp",)
ODD = ("stc", "ldc", "eepmov", "trapa", "andc", "orc", "xorc", "tas", "mac",
       "clrmac", "ldmac", "stmac", "sleep")
WRITE_MNEMS = ("mov", "bset", "bclr", "bst", "bnot")

# Known purposes reused from deep docs 24 (host-surface) and 25 (ABI/IPC),
# keyed by function start address. Each already cites the start address.
KNOWN = {
    0x6BAC8: "node-link inbound command dispatcher: cmp.b chain on command letter at 0xFF1AC9, 8 letters (B C E F N S V W) + default at 0x6BB04",
    0x5E9E2: "MAIN->SUB F0/status-frame builder: fills 0xFF3D72 IPC mailbox and calls sub_B6B6 sender",
    0x73540: "cable-clone entry: sets SCI_4 to 19200 8N1 polled (BRR 0xFFFE91=0x19), clone port setup",
    0x7358E: "cable-clone RECEIVE: reads AH72M header + streamed EEPROM blocks, verifies 8-bit mod-256 checksum",
    0x737FC: "cable-clone SEND: transmits AH72M header then streams EEPROM image",
    0x734C2: "cable-clone port restore after send",
    0x736E6: "cable-clone header receive: unbounded wait for sync byte 'A' (0x41), services timers",
    0x73686: "cable-clone progress-segment display update (writes 0xFFA9DD, sets event bit 0xFF817E.1)",
    0x736B6: "cable-clone progress-segment display update (writes 0xFFA9DD, sets event bit 0xFF817E.1)",
    0x7374A: "cable-clone byte receive: 1200-count timeout, accumulates 8-bit checksum 0xFF812E",
    0x737A8: "cable-clone send handshake: waits for 0x06 ACK before streaming",
    0x737C8: "cable-clone header check vs template 0x738A2",
    0x738CC: "cable-clone send-side checksum accumulator (state 3)",
    0x73908: "cable-clone header builder: AH72M magic (0x73908 stub) + version byte + region dword",
    0x7390A: "cable-clone header builder: AH72M magic + version byte + region dword",
    0x73AB4: "cable-clone ACK/NAK transmit helper (0x06 ack / 0x15 nak)",
}

# Function starts confirmed by byte-level disassembly in deep docs 24/25 even
# where the seed DB shows no xref/recognized prologue: force validated.
DOC_VALID = {0x5E9E2}

# Reachable entries missing from the seed DB that must be created as functions.
# 0x078106 is the boot USB-enable loader entry (JSR @0x078106 from 0x002234),
# inside the closed service window; recorded with the closed one-line purpose.
FORCE_CREATE = {0x078106}


def classify_reg(a):
    if 0xFFEE00 <= a <= 0xFFEE53:
        return "USB"
    if 0xFFF610 <= a <= 0xFFF617:
        return "SCI-D(500k/IPC)"
    if 0xFFFE90 <= a <= 0xFFFE97:
        return "SCI-A(DATA-jack)"
    if 0xFFFF60 <= a <= 0xFFFF67:
        return "SCI-B"
    if 0xFFFF88 <= a <= 0xFFFF8F:
        return "SCI-C(DSP)"
    if 0xFFFF90 <= a <= 0xFFFFA1:
        return "A/D"
    if 0xFFFC00 <= a <= 0xFFFC5F or 0xFFFD20 <= a <= 0xFFFD22:
        return "DMAC"
    if (0xFFFFC0 <= a <= 0xFFFFFF or 0xFFFEC0 <= a <= 0xFFFECB
            or 0xFFFEE0 <= a <= 0xFFFEE7 or 0xFFFEF0 <= a <= 0xFFFEF8
            or a in (0xFFFD68, 0xFFFD6A)):
        return "timer"
    if 0xFFFB80 <= a <= 0xFFFBCF:
        return "port-dir"
    if 0xFFFF00 <= a <= 0xFFFF5F:
        return "port-io"
    if 0xFFFDC2 <= a <= 0xFFFDCC:
        return "bus/clk-cfg"
    return None


def is_ram_config(a):
    return (0xFF8000 <= a <= 0xFFBFFF) or (0xFEE000 <= a <= 0xFF72FF)


def log(text):
    _LOG.append(text)
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\n", " ").replace("\r", " ")


def scan(func):
    st = collections.Counter()
    regs = collections.Counter()
    reg_addrs = set()
    callees = set()
    ram_writes = set()
    data_refs = set()
    has_indirect_jmp = False
    insn = ida_ua.insn_t()
    first_mnem = None
    ea = func.start_ea
    while ea < func.end_ea:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) and ida_ua.decode_insn(insn, ea) > 0:
            mnem = (ida_ua.print_insn_mnem(ea) or "").lower()
            base_m = mnem.split(".")[0]
            if first_mnem is None:
                first_mnem = mnem
            st["insn"] += 1
            if base_m in RET:
                st["ret"] += 1
            elif base_m in CALL:
                st["call"] += 1
            elif base_m in BRANCH:
                st["branch"] += 1
            elif base_m in JMP:
                st["branch"] += 1
            if base_m in ODD:
                st["odd"] += 1
            if base_m == "eepmov":
                st["eepmov"] += 1
            if not mnem:
                st["bad"] += 1
            for op in insn.ops:
                if op.type == 0:
                    break
                if base_m in ("jmp", "jsr") and op.type in (ida_ua.o_phrase, ida_ua.o_displ, ida_ua.o_reg):
                    has_indirect_jmp = True
            for idx, op in enumerate(insn.ops):
                if op.type == 0:
                    break
                if op.type == ida_ua.o_mem:
                    a24 = op.addr & 0xFFFFFF
                    rc = classify_reg(a24)
                    if rc:
                        regs[rc] += 1
                        reg_addrs.add(a24)
                    if a24 < 0x080000:
                        data_refs.add(a24)
                    if base_m in WRITE_MNEMS and idx == 0 and is_ram_config(a24):
                        ram_writes.add(a24)
                if base_m in CALL and op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                    callees.add(op.addr & 0xFFFFFF)
        ea = max(ea + 1, ida_bytes.get_item_end(ea))
    return st, regs, reg_addrs, callees, ram_writes, data_refs, first_mnem, has_indirect_jmp


def plausible_prologue(func, first_mnem):
    if first_mnem is None:
        return False
    base_m = first_mnem.split(".")[0]
    if base_m in ("push", "stm"):
        return True
    insn = ida_ua.insn_t()
    if ida_ua.decode_insn(insn, func.start_ea) > 0:
        line = (idc.generate_disasm_line(func.start_ea, 0) or "").lower()
        if "@-sp" in line or "@-er7" in line:
            return True
    if base_m == "sub":
        line = (idc.generate_disasm_line(func.start_ea, 0) or "").lower()
        if "sp" in line or "er7" in line:
            return True
    return False


def load_functions_tsv():
    known = set()
    try:
        with open(FUNCS_TSV, "r", encoding="utf-8") as h:
            next(h, None)
            for line in h:
                p = line.split("\t")
                if p:
                    try:
                        known.add(int(p[0], 16))
                    except ValueError:
                        pass
    except OSError:
        pass
    return known


def main():
    ida_auto.auto_wait()
    seg = ida_segment.get_first_seg()
    base = seg.start_ea

    pre_starts = set(idautils.Functions())
    tsv_starts = load_functions_tsv()
    log("seeded functions total %d; functions.tsv starts %d" % (len(pre_starts), len(tsv_starts)))

    # ===== Stage A: conservative recovery inside [LO, HI] =====
    added = 0
    targets = set()
    for start in list(pre_starts):
        f = ida_funcs.get_func(start)
        if f is None:
            continue
        insn = ida_ua.insn_t()
        ea = f.start_ea
        while ea < f.end_ea:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) and ida_ua.decode_insn(insn, ea) > 0:
                m = (ida_ua.print_insn_mnem(ea) or "").lower().split(".")[0]
                if m in ("jsr", "bsr", "jmp"):
                    for op in insn.ops:
                        if op.type == 0:
                            break
                        if op.type in (ida_ua.o_near, ida_ua.o_far, ida_ua.o_mem):
                            t = op.addr
                            if LO <= t <= HI:
                                targets.add(t)
            ea = max(ea + 1, ida_bytes.get_item_end(ea))
    for i in range(256):
        v = ida_bytes.get_dword(base + i * 4)
        if LO <= v <= HI:
            targets.add(v)
    targets |= FORCE_CREATE
    for t in sorted(targets):
        if ida_funcs.get_func(t) is not None:
            continue
        fl = ida_bytes.get_flags(t)
        if ida_bytes.is_code(fl) or ida_bytes.is_unknown(fl):
            if ida_funcs.add_func(t):
                added += 1
    ida_auto.auto_wait()
    log("stage A1 added %d functions from code-xref/vector targets" % added)

    a2 = 0
    ea = LO
    insn = ida_ua.insn_t()
    while ea <= HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_unknown(fl) and ida_funcs.get_func(ea) is None:
            b0 = ida_bytes.get_byte(ea)
            b1 = ida_bytes.get_byte(ea + 1)
            head_ok = (b0 == 0x6D and (b1 & 0xF0) == 0xF0) or (b0 == 0x01 and b1 == 0x00)
            if head_ok:
                cur = ea
                ok = True
                seen_ret = False
                n = 0
                while cur <= HI and n < 400:
                    sz = ida_ua.decode_insn(insn, cur)
                    if sz <= 0 or insn.itype == 0:
                        ok = False
                        break
                    m = (ida_ua.print_insn_mnem(cur) or "").lower().split(".")[0]
                    n += 1
                    if m in RET:
                        seen_ret = True
                        break
                    cur += sz
                if ok and seen_ret and n >= 4:
                    if ida_funcs.add_func(ea):
                        a2 += 1
                        fnew = ida_funcs.get_func(ea)
                        if fnew:
                            ea = fnew.end_ea
                            continue
        ea += 2
    ida_auto.auto_wait()
    log("stage A2 added %d functions from clean undefined runs" % a2)
    new_starts = set(idautils.Functions()) - pre_starts
    log("recovered new functions total %d" % len(new_starts))

    # ===== Stage B: classify =====
    fname = {s: (idc.get_func_name(s) or "") for s in idautils.Functions()}

    def read_str(a, maxlen=40):
        raw = ida_bytes.get_bytes(a, maxlen) or b""
        out = []
        for c in raw:
            if 32 <= c < 127:
                out.append(chr(c))
            else:
                break
        s = "".join(out)
        return s if len(s) >= 3 else ""

    rows = []
    extra = []
    T_fn = D_fn = 0
    rejected = 0
    new_validated = 0
    closed_cnt = 0
    insn_bytes_validated = 0

    for start in sorted(s for s in idautils.Functions() if LO <= s <= HI):
        func = ida_funcs.get_func(start)
        if func is None:
            continue
        end = func.end_ea
        size = end - start
        st, regs, reg_addrs, callees, ram_writes, data_refs, first_mnem, indirect = scan(func)
        xrefs = list(idautils.XrefsTo(start, 0))
        nrefs = len(xrefs)
        insn_n = st["insn"] or 1
        structural = st["ret"] + st["call"] + st["branch"]
        odd_ratio = st["odd"] / float(insn_n)
        looks_data = (nrefs == 0 and size >= 24 and
                      (structural == 0 or (odd_ratio > 0.30 and st["call"] == 0)))
        byte_ok = (st["ret"] >= 1 and st["insn"] >= 3 and st["bad"] == 0
                   and plausible_prologue(func, first_mnem) and structural > 0)
        doc_valid = (start in DOC_VALID or start in KNOWN)
        validated = (nrefs > 0 and not looks_data) or byte_ok or doc_valid
        if not validated:
            rejected += 1
            continue
        T_fn += 1
        is_new = start not in tsv_starts
        if is_new:
            new_validated += 1

        ib = 0
        ea = start
        while ea < end:
            fl = ida_bytes.get_flags(ea)
            step = max(1, ida_bytes.get_item_end(ea) - ea)
            if ida_bytes.is_code(fl):
                ib += step
            ea += step
        insn_bytes_validated += ib

        if nrefs:
            how = "reachable"
        elif byte_ok:
            how = "byte-validated"
        else:
            how = "doc-cited(24/25)"

        # ---- closed window: one-line purpose only, no protocol detail ----
        if CLOSED_LO <= start <= CLOSED_HI:
            closed_cnt += 1
            purpose_full = "service-mode DSP loader / CDC-ACM stack (closed) [start %08X]" % start
            ev = "size=%d insn=%d ret=%d call=%d br=%d nrefs=%d %s%s" % (
                size, st["insn"], st["ret"], st["call"], st["branch"], nrefs, how,
                " NEW" if is_new else "")
            D_fn += 1
            rows.append((start, end, "yes", nrefs, purpose_full, ev))
            extra.append((start, end, "", "", "", ""))
            continue

        # ---- known purpose overlay (docs 24/25) ----
        srefs = []
        for a in sorted(data_refs):
            s = read_str(a)
            if s and any(ch.isalpha() for ch in s):
                srefs.append((a, s))
            if len(srefs) >= 3:
                break

        if start in KNOWN:
            purpose_full = KNOWN[start] + " [start %08X]" % start
        else:
            parts = []
            weak = False
            if regs:
                top = ", ".join("%s" % k for k, _ in regs.most_common(3))
                parts.append("touches %s (%s)" % (top,
                             "/".join("%06X" % a for a in sorted(reg_addrs)[:6])))
            if ram_writes:
                parts.append("writes settings/RAM %s" %
                             "/".join("%06X" % a for a in sorted(ram_writes)[:6]))
            ipc = {0xB6B6} & callees
            if ipc:
                parts.append("calls IPC sender sub_B6B6 (MAIN->SUB frame)")
            eeprom = {0x334CA, 0x33532, 0x3B770, 0x3C99C} & callees
            if eeprom:
                parts.append("calls EEPROM writer (%s)" %
                             "/".join("sub_%X" % a for a in sorted(eeprom)))
            if indirect:
                parts.append("indirect dispatch (jmp/jsr @reg)")
            if st["eepmov"]:
                parts.append("block copy (eepmov)")
            if srefs:
                parts.append("refs " + ", ".join('"%s"@%06X' % (esc(s), a) for a, s in srefs))
            if not parts:
                weak = True
                # caller context for weak helpers
                caller_names = []
                for xr in xrefs[:4]:
                    cn = idc.get_func_name(xr.frm) or ""
                    if cn and cn not in caller_names:
                        caller_names.append(cn)
                ctx = (" (called by %s)" % ", ".join(caller_names[:3])) if caller_names else ""
                if st["call"] == 0 and structural <= st["ret"] and insn_n <= 8:
                    parts.append("small leaf helper (%d insn)%s" % (insn_n, ctx))
                elif st["branch"] >= 2 and st["call"] == 0:
                    parts.append("branch-heavy compute/decode helper (%d insn)%s" % (insn_n, ctx))
                elif st["call"] >= 1:
                    parts.append("caller/orchestration helper -> %d callee(s)%s" % (len(callees), ctx))
                else:
                    parts.append("helper routine (%d insn, %d ret)%s" % (insn_n, st["ret"], ctx))
            purpose = "; ".join(parts)
            if weak:
                purpose = "[weak] " + purpose
            purpose_full = purpose + " [start %08X]" % start

        ev = "size=%d insn=%d ret=%d call=%d br=%d nrefs=%d %s%s" % (
            size, st["insn"], st["ret"], st["call"], st["branch"], nrefs, how,
            " NEW" if is_new else "")
        D_fn += 1

        # caller names for extra table
        caller_names = []
        for xr in xrefs[:8]:
            cn = idc.get_func_name(xr.frm) or ("loc_%X" % xr.frm)
            if cn not in caller_names:
                caller_names.append(cn)

        rows.append((start, end, "yes", nrefs, purpose_full, ev))
        extra.append((start, end,
                      ",".join("%06X" % a for a in sorted(reg_addrs)),
                      ",".join(sorted(set(fname.get(c, "sub_%X" % c) for c in callees))[:12]),
                      ",".join(caller_names[:8]),
                      ";".join('%s@%06X' % (esc(s), a) for a, s in srefs)))

    # ===== Stage C: byte accounting =====
    content_in_range = CONTENT_END - LO
    blob = ida_bytes.get_bytes(LO, content_in_range) or b""
    nonff = sum(1 for b in blob if b != 0xFF)

    with open(os.path.join(OUT, "main-high-b.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tvalidated\txref\tpurpose\tevidence\n")
        for start, end, v, nrefs, purpose, ev in rows:
            h.write("%08X\t%08X\t%s\t%d\t%s\t%s\n" % (start, end, v, nrefs, esc(purpose), esc(ev)))

    with open(os.path.join(OUT, "main-high-b-extra.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tregs\tcallees\tcallers\tstrings\n")
        for r in extra:
            h.write("%08X\t%08X\t%s\t%s\t%s\t%s\n" % r)

    with open(os.path.join(OUT, "main-high-b-new.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tname\thow\n")
        for start, end, v, nrefs, purpose, ev in rows:
            if ev.endswith(" NEW"):
                tail = ev[:-4].rsplit(" ", 1)[-1]
                h.write("%08X\t%08X\t%s\t%s\n" % (start, end, idc.get_func_name(start) or "", tail))

    counts = [
        "T_fn (validated, %06X<=start<=%06X)\t%d" % (LO, HI, T_fn),
        "D_fn (with purpose citing start)\t%d" % D_fn,
        "new_validated_not_in_functions_tsv\t%d" % new_validated,
        "recovered_by_stageA (in range or elsewhere)\t%d" % len(new_starts),
        "rejected_sweep_only\t%d" % rejected,
        "closed_window_functions\t%d" % closed_cnt,
        "instruction_bytes_in_validated\t%d" % insn_bytes_validated,
        "content_bytes_in_range (%06X..%06X)\t%d" % (LO, CONTENT_END, content_in_range),
        "nonFF_bytes_in_range\t%d" % nonff,
        "instr_pct_of_content\t%.2f" % (100.0 * insn_bytes_validated / content_in_range),
    ]
    with open(os.path.join(OUT, "w2_2_counts.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(counts) + "\n")
    log("COUNTS:\n" + "\n".join(counts))


try:
    main()
except Exception:
    _LOG.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG_PATH, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_LOG) + "\n")
idc.qexit(0)

r"""Lane W2-5 (slice 3): purpose derivation for body-validated SUB functions.

Recomputes the shared list L identically to the sibling lanes:
  L = rows of ida\out\sub-window\functions.tsv that are validated
      (col 'validated' in {xref,body}), whose start ea is NOT in
      ida\out\fnindex\sub-xref.tsv, and whose purpose is empty.
  Sort by ea ascending. slice_size = ceil(len(L)/5).
  SLICE 3 = L[2*slice_size : 3*slice_size].

For every function in SLICE 3, collects: real-function check (prologue/return/
clean decode), callers, callees (+known descriptors and lane-3 purposes),
peripheral blocks touched (constant-prop), strings/flash-table landmarks,
RAM landmarks, loop shape, switch tables. Emits a rich facts TSV plus a
preliminary purpose. Read-only against the seeded DB.

Run:
  Set-Location "."
  python ida\run_job.py --script ida\jobs\w2_sub_purpose_3_scan.py \
      --db W2_SUBP_3 --copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64
  (afterwards: --reopen)
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import math
import os
import traceback

ROOT = str(_REPO)
FUNCS_TSV = os.path.join(ROOT, "ida", "out", "sub-window", "functions.tsv")
XREF_TSV = os.path.join(ROOT, "ida", "out", "fnindex", "sub-xref.tsv")
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", "W2_SUBP_3")
FACTS = os.path.join(LOGDIR, "facts.tsv")
VAGUE = os.path.join(LOGDIR, "vague_disasm.txt")
REJD = os.path.join(LOGDIR, "reject_disasm.txt")
STATUS = os.path.join(LOGDIR, "scan_status.txt")

BASE = 0xFFC00000
WLO = 0xFFED0000
WHI = 0xFFF50000
PLO = 0x00080000
PHI = 0x00100000
RAMHI = 0x00080000  # RX64M on-chip SRAM sits below the peripheral region

# peripheral block table (from full_l3_xref.py)
BLOCKS = [
    (0x00080000, 0x00080400, "SYSTEM"),
    (0x00081000, 0x00082000, "BSC"),
    (0x00082000, 0x00082200, "DMAC"),
    (0x00082200, 0x00082400, "DMAC_common"),
    (0x00082400, 0x00082800, "DTC"),
    (0x00082800, 0x00082A00, "EXDMAC_ctl"),
    (0x00082A00, 0x00082B00, "EXDMAC"),
    (0x00083000, 0x00084000, "BSC_CS"),
    (0x00087000, 0x00087100, "ICU_IR"),
    (0x00087100, 0x00087200, "ICU_DTCER"),
    (0x00087200, 0x00087300, "ICU_IER"),
    (0x00087300, 0x00087400, "ICU_IPR"),
    (0x00087400, 0x00087800, "ICU_misc"),
    (0x00087800, 0x00088000, "ICU_other"),
    (0x00088000, 0x00088020, "CMT"),
    (0x00088040, 0x00088050, "R12DA"),
    (0x00088100, 0x00088170, "TPU"),
    (0x00088200, 0x00088280, "TMR"),
    (0x00089000, 0x00089200, "S12AD0"),
    (0x0008A000, 0x0008A020, "SCI0"),
    (0x0008A040, 0x0008A060, "SCI2"),
    (0x0008A060, 0x0008A080, "SCI3"),
    (0x0008AC00, 0x0008B000, "SDHI"),
    (0x0008B000, 0x0008B100, "CAC"),
    (0x0008C000, 0x0008C100, "PORT"),
    (0x0008C100, 0x0008C200, "MPC"),
    (0x0008C400, 0x0008C500, "RTC"),
    (0x000A0000, 0x000A0400, "USB0"),
    (0x000C1200, 0x000C2000, "MTU3"),
    (0x000D0100, 0x000D0180, "RSPI"),
]

# Known-purpose callees from docs 25/27 (and lane 10 text/blit chain), plus the
# UI widget/draw helpers reversed for this lane (helpers_disasm.txt).
BEGIN_WIDGET = 0xFFEEF9BB
END_WIDGET = 0xFFEF036F
KNOWN = {
    0xFFEFB268: "memcpy(dst,src,n)",
    0xFFEF2184: "1bpp glyph resolver",
    0xFFEE5269: "glyph width lookup",
    0xFFEF190D: "kanji glyph blit",
    0xFFEF1B23: "ASCII glyph blit",
    0xFFEFA7E7: "string renderer",
    0xFFEF0648: "RGB565 blit",
    0xFFEF68D5: "blit/draw",
    0xFFEF1F90: "EXDMAC draw",
    0xFFEF0385: "IPC slot->buf copy",
    0xFFEDC1F6: "IPC ring dequeue",
    0xFFEDF1D8: "IPC opcode dispatch",
    0xFFEDF269: "IPC F0 sub-dispatch",
    0xFFEDF016: "IPC frame processor",
    0xFFF36CA2: "main-loop IPC pump",
    0xFFF0964A: "menu walker",
    0xFFF08201: "menu settings screen",
    0xFFF45DBC: "_INITSCT startup",
    0xFFF1EE20: "set current-object ptr@65E30 + process",
    0xFFEF1C48: "draw rect/region on current surface (x,y,w,h,mode)",
    0xFFEF0581: "surface draw primitive (rect/region)",
    # UI widget/draw framework (reversed here)
    0xFFEEF9BB: "begin_widget(alloc draw-slot@8F75,publish desc@1D3C8)",
    0xFFEF036F: "end_widget(commit@1D3B8+advance ui-state@8C4C)",
    0xFFEEFA9E: "commit widget desc->layer table@1D3CC",
    0xFFEEFEA4: "mark screen region dirty@1D3B0",
    0xFFEFAA2B: "bar/scale segment geometry (divu)",
    0xFFEF1BB1: "positioned draw w/ source ptr",
    0xFFF03652: "draw 5-state indicator box",
    0xFFEF2505: "render menu field cell (rec tbl@68868)",
    0xFFEE1D6D: "u16->3-digit glyph format",
    0xFFEE1DE8: "u16->3-digit format (leading-zero blank)",
    0xFFEF153B: "grid-cell->pixel coord mapper (stride 0x140)",
    0xFFEF1DDA: "EXDMAC display-blit kickoff",
    0xFFEF1DE8: "EXDMAC display-blit kickoff",
    0xFFEF2724: "menu-cell record lookup helper",
}

# Flash/RAM landmarks worth naming when referenced as an immediate.
LANDMARK = [
    (0xFFED4644, 0xFFED46A4, "font1bpp_master_tbl"),
    (0xFFECFDCC, 0xFFECFDD0, "rgb565_atlas_desc"),
    (0xFFED4050, 0xFFED4054, "ui_screen_handler_tbl"),
    (0xFFED74E8, 0xFFED7A00, "screen_handler_tbl(0xFFED74E8 region)"),
    (0xFFECE55C, 0xFFED0000, "bitmap_atlas_desc"),
    (0x0001D3C8, 0x0001D3CC, "framebuffer_ptr"),
    (0x00008E46, 0x00008E48, "ipc_pending_buf"),
    (0x000084C8, 0x000084CA, "ipc_opcode_mirror"),
    (0x00012D44, 0x00012D48, "ipc_ring_ctl"),
    (0x00008C4C, 0x00008C4E, "ui_mode_state@8C4C"),
    (0x00008C4D, 0x00008C4F, "screen/menu id@8C4D"),
    (0x00008F73, 0x00008F74, "field-state@8F73"),
    (0x00008F75, 0x00008F77, "widget-slot bookkeeping@8F75"),
    (0x0001D3B0, 0x0001D3D0, "screen surface/dirty bookkeeping@1D3B0"),
    (0xFFEC5900, 0xFFEC6400, "glyph-metric/field-coord tbl"),
    (0x00068868, 0x00068880, "menu-cell record tbl@68868"),
]


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def block_of(addr):
    for lo, hi, name in BLOCKS:
        if lo <= addr < hi:
            return name
    return None


def landmark_of(addr):
    for lo, hi, name in LANDMARK:
        if lo <= addr < hi:
            return name
    return None


def build_slice():
    xref_starts = set()
    with open(XREF_TSV, encoding="utf-8") as f:
        next(f)
        for line in f:
            c = line.rstrip("\n").split("\t")
            if c and c[0]:
                xref_starts.add(c[0].strip().upper())
    rows = []
    with open(FUNCS_TSV, encoding="utf-8") as f:
        next(f)
        for line in f:
            c = line.rstrip("\n").split("\t")
            if len(c) < 6:
                continue
            start, end, validated, xref, purpose, evidence = c[:6]
            s = start.strip().upper()
            if validated.strip() not in ("xref", "body"):
                continue
            if s in xref_starts:
                continue
            if purpose.strip() != "":
                continue
            rows.append((int(s, 16), int(end.strip(), 16)))
    rows.sort()
    n = len(rows)
    ss = math.ceil(n / 5)
    sl3 = rows[2 * ss:3 * ss]
    return n, ss, sl3, xref_starts


def load_xref_purposes():
    """map start-ea(int) -> short descriptor pulled from sub-xref purpose col."""
    m = {}
    with open(XREF_TSV, encoding="utf-8") as f:
        next(f)
        for line in f:
            c = line.rstrip("\n").split("\t")
            if len(c) < 5 or not c[0]:
                continue
            ea = int(c[0], 16)
            p = c[4]
            tag = ""
            # keep the informative fragment: touches/refs, else the [..] class
            for frag in p.split(" | "):
                frag = frag.strip()
                if frag.startswith("touches ") or frag.startswith("refs "):
                    tag = frag
                    break
            if not tag:
                if "[low]" in p:
                    tag = "leaf/util"
                elif "[med]" in p:
                    tag = "wrapper/dispatch"
            m[ea] = tag
    return m


def load_body_purposes():
    """map start-ea(int) -> purpose for the 188 body funcs that already carry one
    (used only as callee vocabulary; those funcs are not in our slice)."""
    m = {}
    with open(FUNCS_TSV, encoding="utf-8") as f:
        next(f)
        for line in f:
            c = line.rstrip("\n").split("\t")
            if len(c) < 6 or not c[0]:
                continue
            if c[4].strip():
                m[int(c[0], 16)] = c[4].strip()
    return m


def read_str(addr, ida_bytes):
    raw = ida_bytes.get_bytes(addr, 48)
    if not raw:
        return None
    s = bytearray()
    for ch in raw:
        if ch == 0:
            break
        if 0x20 <= ch < 0x7F:
            s.append(ch)
        else:
            return None
    if len(s) >= 4:
        return s.decode("ascii")
    return None


def main():
    import ida_bytes
    import ida_funcs
    import ida_idp
    import ida_ua
    import ida_xref
    import idautils
    import idc

    o_reg, o_mem, o_phrase, o_displ, o_imm = 1, 2, 3, 4, 5
    o_near, o_far = 7, 6
    CF_STOP = ida_idp.CF_STOP

    n, ss, sl3, xref_starts = build_slice()
    log("len(L)=%d slice_size=%d slice3=%d first=%08X last=%08X" % (
        n, ss, len(sl3), sl3[0][0], sl3[-1][0]))

    xr_purp = load_xref_purposes()
    body_purp = load_body_purposes()
    all_func_starts = set(idautils.Functions())

    RET_MNEMS = ("rts", "rtsd", "rte", "rtfi")

    def callers_of(ea):
        out = []
        xr = ida_xref.xrefblk_t()
        ok = xr.first_to(ea, ida_xref.XREF_ALL)
        while ok:
            if xr.iscode and xr.type in (ida_xref.fl_CF, ida_xref.fl_CN,
                                         ida_xref.fl_JF, ida_xref.fl_JN):
                out.append(xr.frm)
            ok = xr.next_to()
        return out

    def scan(f):
        regs = {}
        periph = {}
        strings = []
        marks = set()
        callees = []
        indirect_calls = 0
        icount = 0
        ibytes = 0
        backbr = 0
        has_ret = False
        tail_branch = False
        decode_ok = True
        first_mnem = ""
        ea = f.start_ea
        last_ea = None
        last_stop = False
        any_stop = False
        last_mnem = ""
        reads_mode8c4c = False
        while ea != idc.BADADDR and ea < f.end_ea:
            fl = ida_bytes.get_flags(ea)
            if not ida_bytes.is_code(fl):
                ea = idc.next_head(ea, f.end_ea)
                regs = {}
                continue
            insn = ida_ua.insn_t()
            dlen = ida_ua.decode_insn(insn, ea)
            if dlen <= 0:
                decode_ok = False
                ea = idc.next_head(ea, f.end_ea)
                continue
            sz = idc.get_item_size(ea)
            mnem = idc.print_insn_mnem(ea) or ""
            base_mnem = mnem.split(".")[0]
            if not first_mnem:
                first_mnem = mnem
            icount += 1
            ibytes += sz
            last_ea = ea
            feat = insn.get_canon_feature()
            stop = bool(feat & CF_STOP)
            last_stop = stop
            last_mnem = base_mnem
            if stop:
                any_stop = True
            if base_mnem in RET_MNEMS:
                has_ret = True
            # operands
            for k in range(6):
                op = insn.ops[k]
                if op.type == 0:
                    break
                if op.type == o_imm:
                    v = op.value & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                    else:
                        lm = landmark_of(v)
                        if lm:
                            marks.add(lm)
                        elif (0xFFC00000 <= v <= 0xFFFFFFFF) or (v < RAMHI):
                            s = read_str(v, ida_bytes)
                            if s:
                                strings.append(s)
                elif op.type in (o_mem, o_far, o_near):
                    v = op.addr & 0xFFFFFFFF
                    if PLO <= v < PHI:
                        b = block_of(v)
                        if b:
                            periph.setdefault(b, set()).add(v)
                    else:
                        lm = landmark_of(v)
                        if lm:
                            marks.add(lm)
                elif op.type in (o_phrase, o_displ):
                    r = op.reg
                    disp = op.value & 0xFFFFFFFF
                    if r in regs:
                        v = (regs[r] + disp) & 0xFFFFFFFF
                        if PLO <= v < PHI:
                            b = block_of(v)
                            if b:
                                periph.setdefault(b, set()).add(v)
                        else:
                            lm = landmark_of(v)
                            if lm:
                                marks.add(lm)
            # calls
            if base_mnem in ("bsr", "jsr"):
                op0 = insn.ops[0]
                if op0.type in (o_near, o_far):
                    callees.append(op0.addr)
                else:
                    indirect_calls += 1
            # branch / loop shape
            elif (base_mnem.startswith("b") and base_mnem != "bsr") or base_mnem == "jmp":
                op0 = insn.ops[0]
                if op0.type in (o_near, o_far):
                    tgt = op0.addr
                    if f.start_ea <= tgt < ea:
                        backbr += 1
                if base_mnem in ("bra", "jmp") and stop:
                    tail_branch = True
            # mode-state byte read
            if reads_mode8c4c is False:
                for k in range(6):
                    op = insn.ops[k]
                    if op.type == 0:
                        break
                    if op.type == o_imm and (op.value & 0xFFFFFFFF) == 0x00008C4C:
                        reads_mode8c4c = True
            # register const tracking
            if (base_mnem.startswith("mov") and insn.ops[0].type == o_imm
                    and insn.ops[1].type == o_reg and insn.ops[2].type == 0):
                regs[insn.ops[1].reg] = insn.ops[0].value & 0xFFFFFFFF
            elif (base_mnem == "add" and insn.ops[0].type == o_imm
                  and insn.ops[1].type == o_reg and insn.ops[2].type == 0):
                r = insn.ops[1].reg
                if r in regs:
                    regs[r] = (regs[r] + (insn.ops[0].value & 0xFFFFFFFF)) & 0xFFFFFFFF
            else:
                if insn.ops[1].type == o_reg:
                    regs.pop(insn.ops[1].reg, None)
                elif insn.ops[0].type == o_reg:
                    regs.pop(insn.ops[0].reg, None)
                if insn.ops[2].type == o_reg:
                    regs.pop(insn.ops[2].reg, None)
                if base_mnem in ("bsr", "jsr", "bra", "jmp") or base_mnem in RET_MNEMS:
                    regs = {}
            ea = idc.next_head(ea, f.end_ea)
        # switch?
        has_switch = False
        try:
            si = idc.get_switch_info(f.start_ea)
            has_switch = si is not None
        except Exception:
            has_switch = False
        return dict(periph=periph, strings=strings, marks=marks, callees=callees,
                    indirect=indirect_calls, icount=icount, ibytes=ibytes,
                    backbr=backbr, has_ret=has_ret, tail_branch=tail_branch,
                    decode_ok=decode_ok, first_mnem=first_mnem,
                    has_switch=has_switch, last_ea=last_ea,
                    last_stop=last_stop, any_stop=any_stop, last_mnem=last_mnem,
                    reads_mode=reads_mode8c4c)

    PROLOGUE_STARTS = ("pushm", "push", "mov", "movu", "add", "sub", "mvtc",
                       "mvfc", "and", "or", "shll", "shlr", "shar", "cmp",
                       "bset", "bclr", "not", "neg", "xor", "stz", "stnz",
                       "emul", "mul", "div", "setpsw", "clrpsw", "nop",
                       "bsr", "bra", "jsr", "jmp", "btst", "sccnz", "scceq")

    def classify(f, s):
        """Return (validated, note). Reject only genuine non-code (data /
        undecodable / empty). Terminator-less bodies are real code that
        lane-4 over-split at internal frame boundaries; keep them validated
        and tag the shape so the map stays honest."""
        if s["icount"] == 0:
            return "no", "empty/no-instructions"
        if not s["decode_ok"]:
            return "no", "undecodable-bytes(data)"
        own_term = s["last_stop"] or s["has_ret"]
        if own_term:
            return "yes", ""
        # no own terminator: describe why it's still real code
        if s["last_mnem"] in ("bsr", "jsr"):
            return "yes", "tail-call(no own rts)"
        if s["last_mnem"] in ("add", "sub"):
            return "yes", "over-split fragment(epilogue, no own rts)"
        if s["any_stop"]:
            return "yes", "converging tail(rts earlier in body)"
        return "yes", "over-split fragment(no own rts)"

    def callee_desc(tgt):
        if tgt in KNOWN:
            return KNOWN[tgt]
        if tgt in body_purp:
            return body_purp[tgt]
        if tgt in xr_purp and xr_purp[tgt]:
            return xr_purp[tgt]
        return ""

    def compose(ea, s):
        parts = ["@%08X" % ea]
        how = []
        # strings first
        us, seen = [], set()
        for st in s["strings"]:
            if st not in seen:
                seen.add(st)
                us.append(st)
        # peripheral
        pdesc = []
        if s["periph"]:
            names = sorted(s["periph"], key=lambda k: -len(s["periph"][k]))
            for b in names[:4]:
                pdesc.append("%s x%d" % (b, len(s["periph"][b])))
        # callees with descriptors
        cset = []
        cseen = set()
        for c in s["callees"]:
            if c not in cseen:
                cseen.add(c)
                cset.append(c)
        named = []
        for c in cset:
            d = callee_desc(c)
            if d and not d.startswith(("touches", "wrapper", "leaf")):
                named.append("%08X=%s" % (c, d))
        # marks
        marks = sorted(s["marks"])

        # the UI screen-state dispatcher idiom: read mode byte @0x8C4C, clamp,
        # jsr through a per-screen handler pointer table (off_FFED74xx region).
        is_state_disp = (s["reads_mode"] and s["indirect"]
                         and any(m.startswith("screen_handler_tbl") for m in marks))
        if is_state_disp:
            parts.append("UI screen-state dispatcher: reads mode @0x8C4C, "
                         "indexes screen_handler_tbl, jsr handler")
            how.append("state-dispatch")

        # the begin_widget -> body -> end_widget draw-step triple
        is_triple = (BEGIN_WIDGET in cset and END_WIDGET in cset)
        if is_triple:
            bodies = [c for c in cset if c not in (BEGIN_WIDGET, END_WIDGET)]
            bstr = ",".join("%08X" % b for b in bodies[:3]) or "(inline)"
            parts.append("screen-element draw step: begin_widget -> body %s "
                         "-> end_widget" % bstr)
            how.append("draw-triple")

        if us:
            parts.append("refs " + "; ".join('"%s"' % x for x in us[:3]))
            how.append("strings")
        if pdesc:
            parts.append("accesses " + ", ".join(pdesc))
            how.append("periph")
        if marks and not is_state_disp:
            parts.append("uses " + ", ".join(marks[:4]))
            how.append("landmark")
        if named and not is_triple:
            parts.append("calls " + "; ".join(named[:4]))
            how.append("named-callee")
        # generic callee/caller shape
        if cset and not named and not is_triple:
            parts.append("calls %d (%s%s)" % (
                len(cset), ",".join("%08X" % c for c in cset[:4]),
                ".." if len(cset) > 4 else ""))
        if s["indirect"] and not is_state_disp:
            parts.append("indirect-call x%d" % s["indirect"])
            how.append("indirect")
        if s["has_switch"]:
            parts.append("switch/jumptable")
            how.append("switch")
        if s["reads_mode"] and not is_state_disp and not is_triple:
            parts.append("reads ui_mode_state@8C4C")
            how.append("mode")
        if s["backbr"]:
            parts.append("loop x%d" % s["backbr"])
        # classification fallback
        if (not us and not pdesc and not marks and not named
                and not is_state_disp and not is_triple and not s["reads_mode"]):
            fm = s["first_mnem"].split(".")[0]
            if (s["icount"] <= 3 and not cset and not s["indirect"]
                    and fm in ("sub", "add")):
                parts.append("stack-frame prologue fragment (alloc; over-split "
                             "head of following draw routine)")
                how.append("prologue-frag")
            elif cset or s["indirect"]:
                parts.append("[med] wrapper/dispatch")
                how.append("shape")
            else:
                parts.append("[low] leaf/util (%d insn)" % s["icount"])
                how.append("shape")
        return " | ".join(parts), ("+".join(how) if how else "shape")

    # ---- sweep the slice ----
    rows = []
    vague = []
    rejects = []
    npurp = 0
    nrej = 0
    ibytes_purp = 0
    for start, end in sl3:
        f = ida_funcs.get_func(start)
        if f is None or f.start_ea != start:
            rows.append((start, end, end - start, "no", "no-func",
                         "@%08X no IDA function at slice start" % start, ""))
            nrej += 1
            rejects.append((start, end))
            continue
        s = scan(f)
        val, rej = classify(f, s)
        callers = callers_of(start)
        if val == "no":
            purpose = "@%08X rejected: %s" % (start, rej)
            ev = "insns=%d bytes=%d first=%s ret=%s laststop=%s anystop=%s" % (
                s["icount"], s["ibytes"], s["first_mnem"], s["has_ret"],
                s["last_stop"], s["any_stop"])
            rows.append((start, f.end_ea, f.end_ea - start, "no", "reject:" + rej,
                         purpose, ev))
            nrej += 1
            rejects.append((start, f.end_ea))
            continue
        purpose, how = compose(start, s)
        if rej:  # fragment / tail-call shape note
            purpose = purpose + " | " + rej
            how = how + "+frag"
        # evidence string
        evparts = []
        if callers:
            evparts.append("callers=%d(%s%s)" % (
                len(callers), ",".join("%08X" % c for c in callers[:4]),
                ".." if len(callers) > 4 else ""))
        else:
            evparts.append("callers=0")
        evparts.append("insns=%d bytes=%d" % (s["icount"], s["ibytes"]))
        if s["periph"]:
            regs_all = [r for b in s["periph"] for r in sorted(s["periph"][b])]
            evparts.append("periphregs=" + ",".join("%08X" % r for r in regs_all[:8]))
        if s["marks"]:
            evparts.append("marks=" + ",".join(sorted(s["marks"])))
        if s["strings"]:
            evparts.append("str=" + "|".join(dict.fromkeys(s["strings"]))[:120])
        if s["callees"]:
            evparts.append("callees=" + ",".join(
                "%08X" % c for c in dict.fromkeys(s["callees"]))[:120])
        if rej:
            evparts.append("note=" + rej)
        ev = "; ".join(evparts)
        rows.append((start, f.end_ea, f.end_ea - start, "yes", how, purpose, ev))
        npurp += 1
        ibytes_purp += s["ibytes"]
        # flag vague for manual review
        low = "[low]" in purpose or ("[med]" in purpose and not s["callees"])
        if low:
            vague.append((start, f.end_ea))

    os.makedirs(LOGDIR, exist_ok=True)
    with open(FACTS, "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tend\tsize\tvalidated\thow\tpurpose\tevidence\n")
        for r in rows:
            h.write("%08X\t%08X\t%d\t%s\t%s\t%s\t%s\n" % (
                r[0], r[1], r[2], r[3], esc(r[4]), esc(r[5]), esc(r[6])))
    log("facts rows=%d purposed=%d rejected=%d ibytes_purp=%d vague=%d" % (
        len(rows), npurp, nrej, ibytes_purp, len(vague)))

    # dump disasm for vague functions for manual review
    with open(VAGUE, "w", encoding="utf-8", newline="\n") as h:
        for start, end in vague:
            f = ida_funcs.get_func(start)
            h.write("\n===== %08X - %08X  size %d  file_off %06X =====\n" % (
                start, end, end - start, start - BASE))
            cl = callers_of(start)
            h.write("  callers: %s\n" % ", ".join("%08X" % c for c in cl[:12]))
            cur = start
            while cur != idc.BADADDR and cur < end:
                line = idc.generate_disasm_line(cur, 0) or ""
                h.write("  %08X  %s\n" % (cur, esc(line)))
                cur = idc.next_head(cur, end)
    log("wrote vague_disasm rows=%d" % len(vague))

    # dump disasm for rejected functions for manual confirmation
    with open(REJD, "w", encoding="utf-8", newline="\n") as h:
        for start, end in rejects:
            f = ida_funcs.get_func(start)
            e = f.end_ea if f is not None else end
            h.write("\n===== %08X - %08X  size %d  file_off %06X =====\n" % (
                start, e, e - start, start - BASE))
            cl = callers_of(start)
            h.write("  callers: %s\n" % ", ".join("%08X" % c for c in cl[:12]))
            cur = start
            while cur != idc.BADADDR and cur < e:
                line = idc.generate_disasm_line(cur, 0) or ""
                h.write("  %08X  %s\n" % (cur, esc(line)))
                cur = idc.next_head(cur, e)
    log("wrote reject_disasm rows=%d" % len(rejects))
    log("done")


if True:
    os.makedirs(LOGDIR, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(LOGDIR, "traceback.txt"), "w",
                  encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)

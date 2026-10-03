# -*- coding: utf-8 -*-
r"""Lane G2 (G2_BANKS): resolve MAIN fixed-stride dispatch banks + full MAIN->SUB
IPC opcode census. Seeded from FIN_MAIN_IND. Pure read; writes TSV/txt.
H8S advanced, big-endian, base 0 (file offset == mapped address).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, idc, idautils, ida_xref

ROOT = str(_REPO)
OUTDIR = os.path.join(ROOT, "ida", "out", "main-banks")
os.makedirs(OUTDIR, exist_ok=True)
TB = os.path.join(OUTDIR, "g2_banks_tb.txt")

MAILBOX = {0xFF3D72: "total", 0xFF3D74: "opcode", 0xFF3D76: "len"}
B6B6 = 0xB6B6
C7C20 = 0x7C20

# bank candidate starts: the A6FE IPC family + every residual "standalone" row
BANK_TARGETS = [0xA6FE, 0xA73A, 0xA776, 0xA7B2, 0xA7EE, 0xA82A]
STANDALONE = [0x3532,0x4894,0x5B2E,0x85D6,0xA73A,0xA7B2,0xCD3E,0x109F0,0x10B44,
    0x16628,0x174C2,0x174E8,0x1758C,0x17D34,0x1BA52,0x1C1FC,0x1F96E,0x20AD0,
    0x22CE0,0x233F6,0x237A8,0x24CCA,0x3E66C,0x3ECC4,0x3F974,0x3FA52,0x44B10,
    0x4B7F4,0x4D9E2,0x4FE8E,0x50AD8,0x50B38,0x528DA,0x532EE,0x53372,0x56036,
    0x5DCE0,0x5E416,0x5E634,0x623C6,0x6EB50,0x6F6CA]


def mnem(ea):
    return (idc.print_insn_mnem(ea) or "").lower()

def opr(ea, n):
    return idc.print_operand(ea, n) or ""

def mask24(a):
    return a & 0xFFFFFF

def disasm_func(start):
    """Return list of (ea, text, mnem, [immediates], [mem_targets], [call_targets])."""
    f = ida_funcs.get_func(start)
    end = f.end_ea if f else start + 0x80
    rows = []
    ea = start
    guard = 0
    while ea < end and guard < 400:
        guard += 1
        flg = ida_bytes.get_flags(ea)
        if not ida_bytes.is_code(flg):
            nxt = ida_bytes.next_head(ea, end)
            rows.append((ea, "[data] " + " ".join("%02X" % ida_bytes.get_byte(ea+i) for i in range(min(4, (nxt-ea) if nxt > ea else 1))), "data", [], [], []))
            ea = nxt if nxt > ea else ea + 1
            continue
        insn = ida_ua.insn_t()
        ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            rows.append((ea, "[undec] %02X" % ida_bytes.get_byte(ea), "undec", [], [], []))
            ea += 1
            continue
        m = mnem(ea)
        imms = []
        mems = []
        calls = []
        for k in range(6):
            op = insn.ops[k]
            if op.type == ida_ua.o_void:
                break
            if op.type == ida_ua.o_imm:
                imms.append(op.value & 0xFFFFFFFF)
            elif op.type in (ida_ua.o_mem, ida_ua.o_displ):
                mems.append(mask24(op.addr))
            elif op.type == ida_ua.o_near:
                calls.append(mask24(op.addr))
        if m in ("jsr", "bsr") and not calls:
            for xr in idautils.CodeRefsFrom(ea, 0):
                calls.append(mask24(xr))
        txt = idc.generate_disasm_line(ea, 0) or (m)
        rows.append((ea, txt, m, imms, mems, calls))
        ea += ln
    return start, end, rows


def main():
    ida_auto.auto_wait()

    # ---- 1. bank + candidate decode dump, with incoming callers ----
    with open(os.path.join(OUTDIR, "bank_decode.txt"), "w", encoding="utf-8", newline="\n") as h:
        for start in sorted(set(BANK_TARGETS + STANDALONE)):
            s, e, rows = disasm_func(start)
            callers = []
            for xr in idautils.CodeRefsTo(start, 0):
                callers.append(mask24(xr))
            drefs = []
            for xr in idautils.DataRefsTo(start):
                drefs.append(mask24(xr))
            h.write("\n==== %06X-%06X (%d B)  callers(code)=%s  datarefs=%s ====\n" % (
                s, e, e - s,
                ",".join("%06X" % c for c in sorted(set(callers))) or "NONE",
                ",".join("%06X" % c for c in sorted(set(drefs))) or "NONE"))
            for ea, txt, m, imms, mems, calls in rows:
                tag = ""
                for mm in mems:
                    if mm in MAILBOX:
                        tag += " <%s>" % MAILBOX[mm]
                for c in calls:
                    if c == B6B6: tag += " <SEND sub_B6B6>"
                    if c == C7C20: tag += " <fill sub_7C20>"
                h.write("  %06X  %-44s%s\n" % (ea, txt, tag))

    # ---- 2. full IPC opcode census over every function ----
    # forward scan; track last immediate loaded into each register; detect
    # mailbox stores and resolve the written opcode/total/len; detect send/fill.
    ipc_rows = []  # (func, ea, opcode, total, length, calls_send, calls_fill, payload_hint)
    senders = {}   # func -> dict of fields seen
    funcs = list(idautils.Functions())
    for fstart in funcs:
        f = ida_funcs.get_func(fstart)
        if not f:
            continue
        regimm = {}
        cur = {"opcode": None, "total": None, "len": None, "send": 0, "fill": 0,
               "op_ea": None}
        ea = f.start_ea
        guard = 0
        while ea < f.end_ea and guard < 4000:
            guard += 1
            flg = ida_bytes.get_flags(ea)
            if not ida_bytes.is_code(flg):
                nxt = ida_bytes.next_head(ea, f.end_ea)
                ea = nxt if nxt > ea else ea + 1
                continue
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, ea)
            if ln <= 0:
                ea += 1
                continue
            m = mnem(ea)
            # track immediate -> register
            if m in ("mov.w", "mov.b", "mov.l") and insn.ops[0].type == ida_ua.o_imm:
                dst = opr(ea, 1).lower()
                regimm[dst] = insn.ops[0].value & 0xFFFFFFFF
            # store to mailbox?
            if m.startswith("mov") and insn.ops[1].type in (ida_ua.o_mem, ida_ua.o_displ):
                tgt = mask24(insn.ops[1].addr)
                if tgt in MAILBOX:
                    src = opr(ea, 0).lower()
                    val = None
                    if insn.ops[0].type == ida_ua.o_imm:
                        val = insn.ops[0].value & 0xFFFFFFFF
                    else:
                        val = regimm.get(src)
                    field = MAILBOX[tgt]
                    if field == "opcode":
                        cur["opcode"] = val; cur["op_ea"] = ea
                    elif field == "total":
                        cur["total"] = val
                    elif field == "len":
                        cur["len"] = val
            # calls
            if m in ("jsr", "bsr"):
                tgts = [mask24(x) for x in idautils.CodeRefsFrom(ea, 0)]
                if insn.ops[0].type == ida_ua.o_near:
                    tgts.append(mask24(insn.ops[0].addr))
                for t in set(tgts):
                    if t == B6B6:
                        cur["send"] = 1
                        # a send fires: record current mailbox snapshot
                        ipc_rows.append((fstart, ea, cur["opcode"], cur["total"],
                                         cur["len"], 1, cur["fill"], cur["op_ea"]))
                    if t == C7C20:
                        cur["fill"] = 1
            ea += ln
        # if a function wrote opcode but never called B6B6 (bank-style mailbox fill)
        if cur["opcode"] is not None and cur["send"] == 0:
            ipc_rows.append((fstart, cur["op_ea"] or fstart, cur["opcode"],
                             cur["total"], cur["len"], 0, cur["fill"], cur["op_ea"]))

    with open(os.path.join(OUTDIR, "ipc_raw.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("func\twrite_ea\topcode\ttotal\tlen\tcalls_send_B6B6\tcalls_fill_7C20\n")
        for fstart, ea, opc, tot, ln, snd, fil, opea in ipc_rows:
            h.write("%06X\t%06X\t%s\t%s\t%s\t%d\t%d\n" % (
                fstart, ea,
                ("%04X" % opc) if opc is not None else "?",
                ("%d" % tot) if tot is not None else "?",
                ("%d" % ln) if ln is not None else "?",
                snd, fil))

    # ---- 3. direct callers of sub_B6B6 (the true send sites) ----
    with open(os.path.join(OUTDIR, "b6b6_callers.txt"), "w", encoding="utf-8", newline="\n") as h:
        for xr in sorted(set(mask24(x) for x in idautils.CodeRefsTo(B6B6, 0))):
            f = ida_funcs.get_func(xr)
            h.write("%06X  in %s\n" % (xr, ("%06X" % f.start_ea) if f else "?"))

    with open(os.path.join(OUTDIR, "g2_banks_log.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("functions scanned: %d\n" % len(funcs))
        h.write("ipc rows: %d\n" % len(ipc_rows))
        h.write("B6B6 callers (code xref): %d\n" % len(list(idautils.CodeRefsTo(B6B6, 0))))


try:
    main()
except Exception:
    with open(TB, "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Lane K4. Read-only instruction-level forward reachability (MAIN, h8sxa).
From each start EA follow ordinary flow, direct branches/jumps and direct calls (callee entry),
NOT register-indirect jsr/jmp (reported separately). Stop at target EAs. Writes env K4_OUT.
Start/target lists from env K4_STARTS / K4_TARGETS (comma hex). Closed window skipped."""
from __future__ import annotations
import os, traceback, collections
import ida_auto, idc, idautils, ida_funcs, ida_ua

OUT = os.environ.get("K4_OUT", "")
CW_LO, CW_HI = 0x078106, 0x07B754
MAXN = int(os.environ.get("K4_MAXN", "60000"))


def fname(ea):
    f = ida_funcs.get_func(ea)
    return ("%s" % ida_funcs.get_func_name(f.start_ea)) if f else "?"


def is_indirect(ea):
    m = idc.print_insn_mnem(ea)
    if m not in ("jsr", "jmp"):
        return False
    return idc.get_operand_type(ea, 0) not in (idc.o_near, idc.o_far, idc.o_mem)


def main():
    ida_auto.auto_wait()
    starts = [int(x, 16) for x in os.environ["K4_STARTS"].split(",") if x]
    targets = set(int(x, 16) for x in os.environ["K4_TARGETS"].split(",") if x)
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        for s in starts:
            prev = {s: None}
            q = collections.deque([s])
            hits, indir, n = [], set(), 0
            while q and n < MAXN:
                ea = q.popleft(); n += 1
                if ea in targets and ea != s:
                    hits.append(ea); continue
                if CW_LO <= ea < CW_HI:
                    continue
                if not idc.is_code(idc.get_full_flags(ea)):
                    continue
                if is_indirect(ea):
                    indir.add(ea)
                m = idc.print_insn_mnem(ea)
                for to in idautils.CodeRefsFrom(ea, True):
                    if is_indirect(ea) and to != ea + idc.get_item_size(ea):
                        continue
                    if to not in prev:
                        prev[to] = ea; q.append(to)
            h.write("### start %06X (%s): visited %d insns%s; targets hit: %s\n" % (
                s, fname(s), n, " (CAPPED)" if q else "", ",".join("%06X" % t for t in hits) or "none"))
            h.write("    indirect jsr/jmp sites not followed: %s\n" % (",".join("%06X" % x for x in sorted(indir)) or "none"))
            for t in hits:
                chain, x = [], t
                while x is not None:
                    chain.append(x); x = prev.get(x)
                # compress: keep call/branch transitions only
                chain.reverse()
                keep = [c for i, c in enumerate(chain) if i == 0 or i == len(chain) - 1 or chain[i] != chain[i - 1] + idc.get_item_size(chain[i - 1])]
                h.write("    -> %06X via %s\n" % (t, " > ".join("%06X[%s]" % (c, fname(c)) for c in keep)))
            h.write("\n")


try:
    main()
except Exception:
    with open(OUT + ".tb", "w", encoding="utf-8") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)

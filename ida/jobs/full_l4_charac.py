r"""Lane 4 pass 4 -- characterize the still-undefined bytes in the code band so the
instruction-byte denominator can be stated with evidence. No DB mutation.

Splits remaining undefined into:
  ptrtable  : aligned runs of >=4 dwords all pointing into 0xFFEDB000-0xFFF50000
              (switch/jump/vtable pointer tables -> data)
  validrun  : linear decode is fully valid to the run end (probable code, tracing
              could not validate a static flow-stop)
  brokenrun : decode hits invalid opcodes (probable data/const pool)

    python ida/run_job.py --script ida\jobs\full_l4_charac.py --db SUB_WINDOW --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/sub-window")
WIN_LO = 0xFFED0000
WIN_HI = 0xFFF50000
BANDS = [(0xFFEDB000, 0xFFF48000), (0xFFF4C000, 0xFFF50000)]
CODE_PTR_LO = 0xFFEDB000
CODE_PTR_HI = 0xFFF50000
STATUS = os.path.join(OUT, "l4_charac_status.txt")


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_bytes, ida_ua, idc

    def gb(ea):
        b = ida_bytes.get_byte(ea)
        return b if b is not None else 0xFF

    def undef(ea):
        fl = ida_bytes.get_flags(ea)
        return not ida_bytes.is_code(fl) and not ida_bytes.is_data(fl)

    total_undef = 0
    ptr_bytes = 0
    valid_bytes = 0
    broken_bytes = 0
    runs = 0
    ptr_runs = []
    for blo, bhi in BANDS:
        ea = blo
        while ea < bhi:
            if not undef(ea):
                ea += 1
                continue
            rs = ea
            while ea < bhi and undef(ea):
                ea += 1
            rl = ea - rs
            total_undef += rl
            runs += 1
            # (a) pointer-table detection: aligned dwords into code region
            a = rs
            while a + 4 <= ea:
                # count consecutive dwords pointing into code region
                c = 0
                b = a
                while b + 4 <= ea:
                    v = int.from_bytes(ida_bytes.get_bytes(b, 4) or b"\0\0\0\0", "little")
                    if CODE_PTR_LO <= v < CODE_PTR_HI:
                        c += 1
                        b += 4
                    else:
                        break
                if c >= 4:
                    ptr_bytes += c * 4
                    ptr_runs.append((a, c))
                    a = b
                else:
                    a += 4
            # (b) linear decode validity over the whole run
            cur = rs
            bad = 0
            while cur < ea:
                insn = ida_ua.insn_t()
                ln = ida_ua.decode_insn(insn, cur)
                if ln <= 0 or ln > 8:
                    bad += 1
                    cur += 1
                else:
                    cur += ln
            if bad == 0:
                valid_bytes += rl
            else:
                broken_bytes += rl

    log("undefined-in-band total %d in %d runs" % (total_undef, runs))
    log("pointer-table bytes %d (%d runs>=4)" % (ptr_bytes, len(ptr_runs)))
    log("valid-linear-decode runs bytes %d" % valid_bytes)
    log("broken (has invalid opcode) runs bytes %d" % broken_bytes)

    with open(os.path.join(OUT, "undefined_charac.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("Lane 4 -- characterization of still-undefined bytes in the code band\n")
        h.write("bands: 0xFFEDB000-0xFFF48000 and 0xFFF4C000-0xFFF50000\n\n")
        h.write("total undefined in band   %d bytes  (%d runs)\n" % (total_undef, runs))
        h.write("  pointer-table dwords    %d bytes  (%d runs of >=4 code pointers -> DATA: switch/jump/vtable)\n" % (
            ptr_bytes, len(ptr_runs)))
        h.write("  runs w/ fully-valid decode %d bytes (probable code, no static flow-stop reached)\n" % valid_bytes)
        h.write("  runs w/ invalid opcodes    %d bytes (probable const/data pool)\n" % broken_bytes)
        h.write("\nnote: pointer-table bytes overlap the run buckets; they are the strongest\n")
        h.write("proof of DATA within the undefined remainder.\n\n")
        h.write("sample pointer-table runs (addr, dword_count):\n")
        for a, c in ptr_runs[:40]:
            h.write("  %08X x%d\n" % (a, c))
    log("done")


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "l4_charac_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)

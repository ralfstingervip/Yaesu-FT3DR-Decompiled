r"""Lane I6 - decode every instruction listed in ida\out\orphan-screens\exit-table-new-insns.tsv with IDA
(h8sxa, private DB I6_MAIN) without changing items, and compare the instruction length with the binutils oracle.
Output: ida\out\orphan-screens\exit-table-lencheck.txt (UTF-8)."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
BASE = str(_REPO / "ida/out/orphan-screens")
ERR = os.path.join(BASE, "i6_lencheck_error.txt")
def main():
    import ida_auto, ida_ua, ida_bytes, idc
    ida_auto.auto_wait()
    rows = open(os.path.join(BASE, "exit-table-new-insns.tsv"), encoding="utf-8").read().splitlines()[1:]
    bad = []; ok = 0; notcode = 0
    for ln in rows:
        a, n = ln.split("\t")[:2]; a = int(a, 16); n = int(n)
        insn = ida_ua.insn_t()
        m = ida_ua.decode_insn(insn, a)
        if not ida_bytes.is_code(ida_bytes.get_flags(a)): notcode += 1
        if m == n: ok += 1
        else: bad.append("%06X oracle=%d ida=%d" % (a, n, m))
    with open(os.path.join(BASE, "exit-table-lencheck.txt"), "w", encoding="utf-8") as fh:
        fh.write("insns %d  length-match %d  mismatch %d  heads-not-code-in-I6_MAIN %d\n" % (len(rows), ok, len(bad), notcode))
        fh.write("\n".join(bad) + "\n")
try:
    main()
except Exception:
    with open(ERR, "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
import idc
idc.qexit(0)

# -*- coding: utf-8 -*-
r"""Reusable job: apply MAIN dispatch-table -> target code xrefs from a TSV to
any MAIN database copy. H8S advanced, big-endian, base 0.

TSV columns (header required): from_table_entry <TAB> target
  from_table_entry = file/mapped address of the 32-bit BE pointer slot
  target           = code address the slot points at

For each row it: makes the slot a dword, marks it a 32-bit offset to target
(creating a data xref), and promotes target to code + a function. Idempotent.

Run standalone:
  python ida\run_job.py --script ida\jobs\g2_apply_table_xrefs.py --db <YOURDB> \
      --reopen --env G2_XREF_TSV=ida\out\main-banks\table-xrefs.tsv
Or import apply_from_tsv(path) from a driver script.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_offset, ida_xref, idc

ROOT = str(_REPO)
DEFAULT_TSV = os.path.join(ROOT, "ida", "out", "main-banks", "table-xrefs.tsv")


def apply_from_tsv(path):
    """Apply xrefs listed in the TSV. Returns (rows, xrefs_added, funcs_made)."""
    rows = 0
    xrefs = 0
    funcs = 0
    with open(path, encoding="utf-8") as h:
        header = h.readline()
        for line in h:
            line = line.rstrip("\n")
            if not line or line.startswith("#"):
                continue
            p = line.split("\t")
            if len(p) < 2:
                continue
            try:
                entry = int(p[0], 16)
                target = int(p[1], 16)
            except ValueError:
                continue
            rows += 1
            # 1. make the slot a clean 32-bit item and a 32-bit offset to target
            ida_bytes.del_items(entry, ida_bytes.DELIT_SIMPLE, 4)
            ida_bytes.create_dword(entry, 4)
            try:
                ida_offset.op_offset(entry, 0, ida_offset.REF_OFF32 if hasattr(ida_offset, "REF_OFF32") else idc.REF_OFF32)
            except Exception:
                pass
            # 2. explicit data xref slot -> target (survives even if op_offset fails)
            ida_xref.add_dref(entry, target, ida_xref.dr_O | ida_xref.XREF_USER)
            xrefs += 1
            # 3. promote target to code + function
            if not ida_bytes.is_code(ida_bytes.get_flags(target)):
                idc.create_insn(target)
            if ida_funcs.get_func(target) is None:
                if ida_funcs.add_func(target):
                    funcs += 1
    return rows, xrefs, funcs


def main():
    ida_auto.auto_wait()
    path = os.environ.get("G2_XREF_TSV", DEFAULT_TSV)
    if not os.path.isabs(path):
        path = os.path.join(ROOT, path)
    rows, xrefs, funcs = apply_from_tsv(path)
    ida_auto.auto_wait()
    out = os.path.join(os.path.dirname(path), "apply_xrefs_log.txt")
    with open(out, "w", encoding="utf-8", newline="\n") as h:
        h.write("tsv: %s\nrows: %d\nxrefs_added: %d\nfuncs_made: %d\n" % (path, rows, xrefs, funcs))


if __name__ == "__main__":
    try:
        main()
    except Exception:
        with open(os.path.join(ROOT, "ida", "out", "main-banks", "apply_xrefs_tb.txt"),
                  "w", encoding="utf-8", newline="\n") as h:
            h.write(traceback.format_exc())
    finally:
        idc.qexit(0)

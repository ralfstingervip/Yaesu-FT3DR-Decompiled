# Lane M5 shared loader. Offline, read-only on every input.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import re, collections, os
R = _REPO_S
O = R + r"\ida\out\dead-code-tier"
HI = 0x7B754
sys.exit("The firmware image is not in this repository.")
PM = open(R + r"\ida\out\l-wave-recon\final6_proven_mask.bin", "rb").read()[:HI]
NM = open(R + r"\ida\out\l-wave-recon\final6_named_mask.bin", "rb").read()[:HI]

# binutils H8SX oracle: one decode per byte offset
bu = {}
for l in open(R + r"\ida\out\h8s-decode\work\bu_all.tsv", encoding="utf-8"):
    p = l.rstrip("\n").split("\t")
    bu[int(p[0], 16)] = (int(p[1]), p[2], p[3] if len(p) > 3 else "")

# IDA heads of the M5_DEADCODE copy of L1_MAIN_FINAL5
heads = {}
for l in list(open(O + r"\work\m5_heads.tsv", encoding="utf-8"))[1:]:
    p = l.rstrip("\n").split("\t")
    heads[int(p[0], 16)] = (int(p[1]), p[2], p[3], p[4] if len(p) > 4 else "")
headof = [None] * HI
for ea, (sz, k, f, t) in heads.items():
    for i in range(ea, min(ea + max(sz, 1), HI)): headof[i] = ea

pieces = []
for l in open(O + r"\work\pieces_in.tsv", encoding="utf-8"):
    p = l.rstrip("\n").split("\t")
    pieces.append((int(p[0], 16), int(p[1], 16), p[3]))
pid = [None] * HI
for a, b, _ in pieces:
    for i in range(a, b): pid[i] = a

TERM = {"rts", "rte", "rts/l", "rte/l", "jmp", "sleep"}       # bra handled separately (bra/s has a delay slot)
BAD = {".word", "(bad)"}
RX_PAR = re.compile(r"\(0x([0-9a-f]+)\)")
RX_ABS = re.compile(r"@0x([0-9a-f]+):(24|32)")
RX_HEX = re.compile(r"0x([0-9a-f]+)")


def be32(s):
    return int.from_bytes(img[s:s + 4], "big")


def is_term(i):
    ln, mn, op = bu[i]
    if mn in TERM: return True
    if mn == "bra" and not op.startswith(("r", "e")) and "(" in op: return True     # bra .+d (target)
    if mn == "bra" and op.startswith(("r", "e")): return True                       # bra rN (switch)
    return False


def targets(i):
    """control-flow targets of the oracle decode at i: list of (kind, target)"""
    ln, mn, op = bu[i]
    out = []
    if mn.startswith("b") and mn not in ("bset", "bclr", "bnot", "btst", "bld", "bst", "band", "bor", "bxor", "biand",
                                          "bior", "bixor", "bild", "bist", "bfld", "bfst", "bset/ne", "bpt") or mn in ("bsr",):
        m = RX_PAR.search(op)
        if m: out.append(("rel", int(m.group(1), 16)))
    if mn in ("jsr", "jmp"):
        if op.startswith("@@"):
            m = RX_PAR.search(op)
            if m:
                v = int(m.group(1), 16)
                out.append(("mem@@%X" % v, be32(v) & 0xFFFFFF))
        else:
            m = RX_ABS.search(op)
            if m: out.append(("abs", int(m.group(1), 16)))
    return out


def lin(a, b):
    i, out = a, []
    while i < b:
        ln, mn, op = bu[i]
        out.append((i, ln, mn, op))
        if ln <= 0: break
        i += ln
    return out


def cls(i):
    if i >= HI: return "X"
    return "P" if PM[i] else ("N" if NM[i] else "R")

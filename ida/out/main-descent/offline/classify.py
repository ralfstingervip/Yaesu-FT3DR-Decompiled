from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[4]
# H9: byte classes for spans the descent does not reach. Read-only.
import sys, re
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO) + r"/ida/out/main-descent/offline")
from common import *

STOPM = ("rts", "rte", "rts/l", "rte/l", "jmp", "bra", "bra/s")
REACHED_INSN = set()   # filled by the caller (analyze.py): flowing into reached code is a proper end

def lin(s, e):
    """linear oracle decode s..e: (n_insn, ok, end_kind, stop_at)"""
    a = s; k = 0; last = None
    while a < e:
        n, t = bu(a)
        if n == 0: return k, False, "bad@%06X" % a, a
        m = t.split(" ", 1)[0]; k += 1; last = m; a += n
        if m in STOPM and a >= e - 1: return k, True, m, a
    return k, a == e, last or "-", a

def walk(c, limit=400):
    """structural walk from even c: returns end address if the straight-line decode reaches a stop
    (rts/rte/jmp/bra) or runs into reached code before any undecodable word; else None."""
    a = c; k = 0
    while k < limit and a < HI:
        if a != c and a in REACHED_INSN: return a
        n, t = bu(a)
        if n == 0: return None
        a += n; k += 1
        if t.split(" ", 1)[0] in STOPM: return a
    return None

def codeish(s, e):
    """strong code evidence in a linear decode of s..e: an rts/rte, or a jsr/jmp/bsr whose target is a reached instruction"""
    a = s
    while a < e:
        n, t = bu(a)
        if n == 0: a += 2; continue
        m = t.split(" ", 1)[0]
        if m in ("rts", "rte", "rts/l", "rte/l"): return True
        if m in ("jsr", "jmp"):
            mo = re.match(r"(?:jsr|jmp) @(0x[0-9a-f]+):", t)
            if mo and int(mo.group(1), 16) in REACHED_INSN: return True
        a += n
    return False

def ptrlike(v): return (0x400 <= v < HI and v % 2 == 0) or (0xFF0000 <= v <= 0xFFFFFF)

def classify_span(s, e):
    """per-byte class: text / fill / table / code-structural / junk"""
    cls = {}
    b = IMG[s:e]
    i = 0
    while i < len(b):                       # text: printable run >= 4 plus up to 2 terminator bytes (00/FF)
        j = i
        while j < len(b) and printable(b[j]): j += 1
        if j - i >= 4:
            for x in range(i, j): cls[s + x] = "text"
            k = j
            while k < len(b) and b[k] in (0, 0xFF) and k - j < 2: cls[s + k] = "text"; k += 1
            i = k
        else:
            i = max(j, i + 1)
    for x in range(s, e):                   # fill: FF FF
        if x not in cls and IMG[x] == 0xFF and ((x + 1 < e and IMG[x + 1] == 0xFF) or (x > s and IMG[x - 1] == 0xFF)):
            cls[x] = "fill"
    rest = [x for x in range(s, e) if x not in cls]
    subs = []
    if rest:
        st = rest[0]; pv = rest[0]
        for x in rest[1:]:
            if x != pv + 1: subs.append((st, pv + 1)); st = x
            pv = x
        subs.append((st, pv + 1))
    for a, z in subs:
        bb = IMG[a:z]
        a2 = a + (a & 1)
        dw = [int.from_bytes(IMG[y:y + 4], "big") for y in range(a2, z - 3, 4)]
        pt = sum(1 for v in dw if ptrlike(v))
        words = [bb[i:i + 2] for i in range(0, len(bb) - 1, 2)]
        smooth = sum(1 for i in range(len(bb) - 1) if abs(bb[i + 1] - bb[i]) <= 2)
        lowdiv = len(words) >= 4 and len(set(words)) * 10 < len(words) * 4
        if not codeish(a2, z) and len(dw) >= 2 and pt * 2 >= len(dw):
            for x in range(a, z): cls[x] = "table"
            continue
        if not codeish(a2, z) and len(bb) >= 8 and (lowdiv or smooth * 10 >= (len(bb) - 1) * 6):
            for x in range(a, z): cls[x] = "table"
            continue
        # greedy structural sweep
        p = a
        if p & 1: cls[p] = "junk"; p += 1
        while p < z:
            end = walk(p)
            if end is not None:
                for x in range(p, min(end, z)): cls[x] = "code-structural"
                p = max(min(end, z), p + 2)
            else:
                cls[p] = "junk"
                if p + 1 < z: cls[p + 1] = "junk"
                p += 2
    return cls

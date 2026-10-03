# Lane L6. Re-check K2/K3's negative at the new edge: from every handler the resolver joins to a touch zone,
# run a depth-bounded descent (D=4, K3's dclosure edge rules, plus: rts/l, rte/l, sleep terminate; the reset
# entries 0x2050/0x2092 are recorded, not followed) and look for
#  (a) a branch/call target inside the closed window 0x078106-0x07B753,
#  (b) an operand on the USB module 0xFFEE00-0xFFEE53 or SCI-C 0xFFFF88-0xFFFF8F,
#  (c) a screen write / screen API call with a constant id in K3's 69 unopened ids.
# Two root sets: P = handlers joined to the 195 formerly pending zones; J = handlers of K3-joined zones.
# Read-only. Imports K3's generator modules from ida\out\touch-screens\gen (unchanged).
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import sys, re, os
K3GEN = (_REPO_S + "/ida/out/touch-screens/gen")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, K3GEN)
cwd = os.getcwd(); os.chdir(K3GEN)
from dclos import screen_writes, UNOPENED, BU, CW
os.chdir(cwd)
sys.path.insert(0, HERE)
import trace as TR

OUT = (_REPO_S + "/ida/out/home-keytable/")
rows = [l.rstrip("\n").split("\t") for l in open(OUT + "zones-resolved.tsv", encoding="utf-8") if not l.startswith("#")]


def roots_of(pred):
    s = set()
    for r in rows[1:]:
        if pred(r) and r[10].startswith(('resolved', 'K3-join')):
            for m in re.finditer(r"(?:slot\d+=|-> |=|jsr |jmp )([0-9A-F]{6})\b", r[-1]):
                v = int(m.group(1), 16)
                if 0x400 <= v < 0x80000: s.add(v)
    s.discard(0x3FFA0)
    return s


lines = []
for tag, pred in (("P", lambda r: r[9] == 'K3-pending'), ("J", lambda r: r[9] == 'K3-joined')):
    roots = roots_of(pred)
    TR.RESTART_HITS.clear()
    best, par = TR.trace(sorted(roots), D=4)
    ins = set(best)
    win, io = [], []
    for a in sorted(ins):
        t = BU[a][1]
        for m in re.finditer(r"0x([0-9a-f]+)", t):
            v = int(m.group(1), 16)
            if CW[0] <= v < CW[1] and re.match(r"(jsr|jmp|bsr|bra|b\w+) ", t): win.append((a, t))
            vv = v | 0xFF0000 if (':16' in t and v >= 0x8000) else v
            if 0xFFEE00 <= vv <= 0xFFEE53 or 0xFFFF88 <= vv <= 0xFFFF8F: io.append((a, t))
    sw = screen_writes(ins)
    const = sorted({v for a, k, v, s in sw if v is not None})
    hit69 = [x for x in sw if x[2] is not None and x[2] in UNOPENED]
    unres = [a for a in ins if re.match(r"(jmp|jsr) @er\d$", BU[a][1])]
    rs = sorted(set(TR.RESTART_HITS))
    lines.append("# set %s: roots=%d instructions=%d ; window targets=%d ; USB/SCI-C operands=%d ; reset-entry jumps=%d ; screen-write sites=%d ; constant ids: %s ; in K3's 69 unopened: %d ; indirect @erN sites=%d"
                 % (tag, len(roots), len(ins), len(win), len(io), len(rs), len(sw), " ".join("%02X" % v for v in const), len(hit69), len(unres)))
    for a, t in win: lines.append("%s\twindow\t%06X\t%s\t%s" % (tag, a, t, " ".join(TR.chain(par, a))))
    for a, tg in rs: lines.append("%s\trestart\t%06X\tjump/call to reset entry %06X\t%s" % (tag, a, tg, " ".join(TR.chain(par, a))))
    for a, t in io: lines.append("%s\tio\t%06X\t%s\t%s" % (tag, a, t, " ".join(TR.chain(par, a))))
    for a, k, v, s in sw:
        lines.append("%s\tscreen\t%06X\t%s value=%s src=%s in69=%s\t%s" % (tag, a, k, ("%02X" % v) if v is not None else '?', s,
                     'YES' if (v is not None and v in UNOPENED) else 'no', " ".join(TR.chain(par, a))))
head = [l for l in lines if l.startswith('#')]
body = [l for l in lines if not l.startswith('#')]
open(OUT + "work/open-check.tsv", "w", encoding="utf-8", newline="\n").write(
    "# Lane L6 open-check (gen/check_open.py). chain = descent parents back to a root (block starts).\n" + "\n".join(head) +
    "\nset\tkind\taddr\ttext\tchain\n" + "\n".join(body) + "\n")
print("\n".join(head))

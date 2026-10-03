# Lane L6. Concrete/symbolic path walker over the H8SX oracle text (read-only).
# walk(root, known) enumerates paths from a key handler under a partial state assignment `known`
# (var -> int). Branches on known vars are decided; others fork and are recorded as conditions.
# Terminal "actions" are the calls made on the path (helper index-dispatch and jump tables are
# resolved when their index var is known).
import re, sys
sys.path.insert(0, '.')
from l6lib import *

BR = {'beq', 'bne', 'bcs', 'bcc', 'bhi', 'bls', 'bpl', 'bmi', 'bge', 'blt', 'bgt', 'ble', 'bvs', 'bvc'}
REGN = re.compile(r"^e?r(\d)[lh]?$")


def regno(r):
    m = re.match(r"^(?:er|e?r)(\d)([lh]?)$", r)
    return (int(m.group(1)), m.group(2)) if m else (None, None)


def memvar(op):
    m = re.match(r"^@(0x[0-9a-f]+):(8|16|32|24)$", op)
    if m:
        v = int(m.group(1), 16)
        if m.group(2) == '16' and v >= 0x8000: v |= 0xFF0000
        if m.group(2) == '8': v |= 0xFFFF00
        return "[%06X]" % v
    m = re.match(r"^@\((0x[0-9a-f]+):16,er0\)$", op)
    if m: return "rec+0x%X" % int(m.group(1), 16)
    return None


ALIAS = {"[FFBBC2]": "IDX", "[FF3D74]": "PAGE"}


def fmt(c):
    return c


RECF = {3: 0x0C, 4: 0x08, 5: 0x08, 6: 0x14, 7: 0x18}


def rec_action(rec, k):
    """dispatcher 0x028CBC on a 32-byte record (K3 records.tsv semantics; index = [FFBBC2])"""
    if rec is None: return "record ? (er1 unknown)"
    if k is None: return "record %06X (index unknown)" % rec
    if k in (1, 2): return "record %06X: cursor-mode (BC34) toggle" % rec
    if k in RECF: return "record %06X+%02X -> %06X" % (rec, RECF[k], be32(rec + RECF[k]))
    if 10 <= k < 0x14 or k > 0x14: return "record %06X+00 -> %06X (char %d -> A9F0)" % (rec, be32(rec), k - 10)
    if k == 0x14: return "record %06X+04/+1C -> %06X/%06X" % (rec, be32(rec + 4), be32(rec + 0x1C))
    return "record %06X: softkey_clear (idx %d)" % (rec, k)


class Path:
    __slots__ = ('regs', 'flag', 'conds', 'acts', 'stack', 'steps')

    def __init__(s):
        s.regs = {}; s.flag = None; s.conds = []; s.acts = []; s.stack = []; s.steps = 0

    def copy(s):
        p = Path(); p.regs = dict(s.regs); p.flag = s.flag; p.conds = list(s.conds); p.acts = list(s.acts)
        p.stack = list(s.stack); p.steps = s.steps; return p


def val(p, known, r):
    """return ('c',int) or ('v',name) or None for register operand r"""
    n, part = regno(r)
    if n is None: return None
    v = p.regs.get(n)
    if v is None: return None
    if v[0] == 'v' and v[1] in known: return ('c', known[v[1]])
    return v


def evalcond(m, flag, known):
    """flag = (kind, lhs, rhs, width) ; lhs ('c',int)|('v',name)|None. return True/False/None and text"""
    kind, lhs, rhs, w = flag
    if kind == 'bit':
        name, bit = lhs
        key = "%s.b%d" % (name, bit)
        if key in known:
            z = (known[key] == 0)
        elif name in known:
            z = ((known[name] >> bit) & 1) == 0
        else:
            z = None
        if m == 'beq': return (z, "%s=0" % key, "%s=1" % key)
        if m == 'bne': return ((None if z is None else not z), "%s=1" % key, "%s=0" % key)
        return (None, "?", "?")
    name = lhs[1] if lhs and lhs[0] == 'v' else None
    x = lhs[1] if lhs and lhs[0] == 'c' else None
    mask = (1 << w) - 1
    sgn = lambda v: v - (1 << w) if v & (1 << (w - 1)) else v
    disp = ALIAS.get(name, name) if name else ("%#x" % x if x is not None else "?")
    r = rhs
    ops = {'beq': ('==', lambda a: a == r), 'bne': ('!=', lambda a: a != r), 'bcs': ('<', lambda a: a < r),
           'bcc': ('>=', lambda a: a >= r), 'bhi': ('>', lambda a: a > r), 'bls': ('<=', lambda a: a <= r),
           'bge': ('>=s', lambda a: sgn(a) >= sgn(r)), 'blt': ('<s', lambda a: sgn(a) < sgn(r)),
           'bgt': ('>s', lambda a: sgn(a) > sgn(r)), 'ble': ('<=s', lambda a: sgn(a) <= sgn(r))}
    inv = {'==': '!=', '!=': '==', '<': '>=', '>=': '<', '>': '<=', '<=': '>', '>=s': '<s', '<s': '>=s', '>s': '<=s', '<=s': '>s'}
    if m in ('bpl', 'bmi'):
        if kind == 'tst':
            t = None if x is None else (sgn(x & mask) < 0)
            if m == 'bmi': return (t, "%s<0" % disp, "%s>=0" % disp)
            return ((None if t is None else not t), "%s>=0" % disp, "%s<0" % disp)
        if x is not None:
            t = sgn((x - r) & mask) < 0
            return ((t if m == 'bmi' else not t), "N", "N")
        return (None, "%s-%#x<0" % (disp, r) if m == 'bmi' else "%s-%#x>=0" % (disp, r), "N")
    if m not in ops: return (None, m, m)
    o, f = ops[m]
    t = None if x is None else f(x & mask)
    return (t, "%s%s%#x" % (disp, o, r), "%s%s%#x" % (disp, inv[o], r))


def walk(root, known, maxpaths=200, follow=(), maxsteps=600, stop_at_call=True):
    """Enumerate paths. known: dict var->int, e.g. {'[FFB3EA]':0x37,'IDX':3}. IDX/PAGE aliases accepted."""
    K = dict(known)
    if 'IDX' in K: K['[FFBBC2]'] = K['IDX']
    if 'PAGE' in K: K['[FF3D74]'] = K['PAGE']
    res = []
    work = [(root, Path())]
    while work and len(res) < maxpaths:
        a, p = work.pop()
        while True:
            p.steps += 1
            if p.steps > maxsteps:
                res.append((p, "steplimit@%06X" % a)); break
            if not okcode(a):
                res.append((p, "bad@%06X" % a)); break
            if a == 0x28CBC:
                r1 = p.regs.get(1)
                rec = r1[1] if r1 and r1[0] == 'c' else None
                p.acts.append(rec_action(rec, K.get('IDX')))
                if p.stack: a = p.stack.pop(); continue
                res.append((p, "end")); break
            n, t = BU[a]
            parts = t.split(' ', 1); m = parts[0]; op = parts[1] if len(parts) > 1 else ''
            nxt = a + n
            # ---- data movement
            if m in ('mov.b', 'mov.w', 'mov.l') and ',' in op:
                src, dst = op.rsplit(',', 1)
                w = {'mov.b': 8, 'mov.w': 16, 'mov.l': 32}[m]
                dn, part = regno(dst)
                mv = memvar(src)
                if dn is not None:
                    if src.startswith('#'):
                        v = int(src[1:], 16); p.regs[dn] = ('c', v); p.flag = ('tst', ('c', v), 0, w)
                    elif mv:
                        name = mv
                        v = ('c', K[name]) if name in K else ('v', name)
                        p.regs[dn] = v; p.flag = ('tst', v, 0, w)
                    else:
                        mt = re.match(r"^@\((0x[0-9a-f]+):32,er(\d)\)$", src)
                        sn, _ = regno(src)
                        if mt:
                            base = int(mt.group(1), 16); ix = p.regs.get(int(mt.group(2)))
                            if ix and ix[0] == 'c':
                                p.regs[dn] = ('c', be32(base + ix[1]) if w == 32 else (be16(base + ix[1]) if w == 16 else IMG[base + ix[1]]))
                            elif ix and ix[0] == 'idx' and ix[1] in K:
                                p.regs[dn] = ('c', be32(base + ix[2] * K[ix[1]]) if ix[2] == 4 else be16(base + ix[2] * K[ix[1]]))
                            elif ix and ix[0] == 'idx':
                                p.regs[dn] = ('jt', base, ix[1], ix[2])
                            else:
                                p.regs[dn] = None
                        elif sn is not None:
                            v = p.regs.get(sn); p.regs[dn] = v; p.flag = ('tst', v, 0, w)
                        else:
                            p.regs[dn] = None; p.flag = None
                else:
                    # store to memory: track known-state writes of interest
                    mv = memvar(dst)
                    if mv and src.startswith('r'):
                        sv = val(p, K, src)
                        p.acts.append("store %s=%s" % (ALIAS.get(mv, mv), ("%#x" % sv[1]) if sv and sv[0] == 'c' else '?'))
                a = nxt; continue
            if m in ('and.l', 'and.w', 'extu.l', 'extu.w', 'exts.l') :
                a = nxt; continue  # keep symbolic value (zero-extension of a byte var)
            if m == 'shll.l':
                mm = re.match(r"^(?:#(\d),)?er(\d)$", op)
                if mm:
                    k = int(mm.group(1) or 1); r_ = int(mm.group(2)); v = p.regs.get(r_)
                    if v and v[0] == 'v': p.regs[r_] = ('idx', v[1], 1 << k)
                    elif v and v[0] == 'idx': p.regs[r_] = ('idx', v[1], v[2] << k)
                    elif v and v[0] == 'c': p.regs[r_] = ('c', v[1] << k)
                    else: p.regs[r_] = None
                a = nxt; continue
            if m.startswith('cmp.'):
                c, r = op.split(',')
                w = {'cmp.b': 8, 'cmp.w': 16, 'cmp.l': 32}[m]
                if c.startswith('#'):
                    p.flag = ('cmp', val(p, K, r), int(c[1:], 16), w)
                else:
                    p.flag = None
                a = nxt; continue
            if m == 'btst':
                mo = re.match(r"^#0x([0-9a-f]+),(.*)$", op)
                if mo:
                    bit = int(mo.group(1), 16); tgt = mo.group(2); mv = memvar(tgt)
                    if mv: p.flag = ('bit', (mv, bit), 0, 8)
                    else:
                        v = val(p, K, tgt)
                        if v and v[0] == 'v': p.flag = ('bit', (v[1], bit), 0, 8)
                        elif v and v[0] == 'c': p.flag = ('bit', ("#%#x" % v[1], bit), 0, 8); K["#%#x.b%d" % (v[1], bit)] = (v[1] >> bit) & 1
                        else: p.flag = None
                a = nxt; continue
            if m in ('sub.w', 'add.w', 'sub.b', 'add.b', 'dec.w', 'dec.b', 'inc.w', 'inc.b', 'sub.l', 'add.l'):
                mo = re.match(r"^(?:#)?(0x[0-9a-f]+|1|2),(e?r\d[lh]?)$", op) if m.startswith(('sub', 'add')) else re.match(r"^#?(1|2),(e?r\d[lh]?)$", op)
                if mo:
                    k = int(mo.group(1), 16) if mo.group(1).startswith('0x') else int(mo.group(1))
                    rn, _ = regno(mo.group(2)); v = p.regs.get(rn)
                    neg = m.startswith(('sub', 'dec'))
                    if v and v[0] == 'c':
                        nv = v[1] - k if neg else v[1] + k; p.regs[rn] = ('c', nv)
                        p.flag = ('tst', ('c', nv), 0, 16 if '.w' in m else (8 if '.b' in m else 32))
                    elif v and v[0] == 'v' and v[1] in K:
                        nv = K[v[1]] - k if neg else K[v[1]] + k; p.regs[rn] = ('c', nv)
                        p.flag = ('tst', ('c', nv), 0, 16 if '.w' in m else (8 if '.b' in m else 32))
                    else:
                        p.regs[rn] = ('v', "%s%s%d" % (v[1] if v and v[0] == 'v' else '?', '-' if neg else '+', k)) if v and v[0] == 'v' else None
                        p.flag = None
                else:
                    p.flag = None
                a = nxt; continue
            if m in ('rts', 'rte'):
                if p.stack:
                    a = p.stack.pop(); continue
                res.append((p, "rts")); break
            # ---- calls / jumps
            if m in ('jsr', 'jmp'):
                ma = re.match(r"^@(0x[0-9a-f]+):24$", op)
                if ma:
                    tg = int(ma.group(1), 16)
                    if tg in HELP:
                        L = HELP[tg]; T = p.regs.get(6)
                        if T and T[0] == 'jt':
                            base_, var_, sc_ = T[1], T[2], T[3]
                            forks = []
                            for i in range(32):
                                tt = be32(base_ + sc_ * i)
                                if not (0x400 <= tt < 0x80000 and okcode(be32(tt))): break
                                forks.append((i, tt))
                            for i, tt in forks:
                                q = p.copy(); q.conds.append("%s==%#x" % (ALIAS.get(var_, var_), i)); q.regs[6] = ('c', tt)
                                work.append((a, q))
                            if forks: break
                        T = T[1] if T and T[0] == 'c' else None
                        if 'IDX' in K and T is not None:
                            k = K['IDX']
                            if 1 <= k < L:
                                h = be32(T + 4 * (k - 1))
                                p.acts.append("idx%#x(tbl %06X[%d]) -> %06X" % (L, T, k - 1, h))
                                if h in follow:
                                    if m == 'jsr': p.stack.append(nxt)
                                    a = h; continue
                            else:
                                p.acts.append("idx%#x(tbl %06X) out of range -> softkey_clear" % (L, T or 0))
                        else:
                            p.acts.append("idx%#x(tbl %s)" % (L, ("%06X" % T) if T else '?'))
                        if m == 'jmp':
                            if p.stack: a = p.stack.pop(); continue
                            res.append((p, "end")); break
                        a = nxt; continue
                    if tg == SOFTKEY:
                        p.acts.append("softkey_clear(3FFA0)")
                    elif tg in PASSER:
                        p.acts.append("record %06X" % PASSER[tg])
                    elif tg == 0x28CBC:
                        r1 = p.regs.get(1)
                        p.acts.append("record %s" % (("%06X" % r1[1]) if r1 and r1[0] == 'c' else '?'))
                    else:
                        p.acts.append("%s %06X" % (m, tg))
                        if tg in follow:
                            if m == 'jsr': p.stack.append(nxt)
                            a = tg; continue
                    if m == 'jmp':
                        if p.stack: a = p.stack.pop(); continue
                        res.append((p, "end")); break
                    a = nxt; continue
                if op == '@er6':
                    v = p.regs.get(6)
                    if v and v[0] == 'c':
                        p.acts.append("%s @er6=%06X" % (m, v[1]))
                        if m == 'jsr': p.stack.append(nxt)
                        a = v[1]; continue
                    if v and v[0] == 'jt':
                        T, var, sc = v[1], v[2], v[3]
                        n_ = 0
                        while n_ < 72 and okcode(be32(T + sc * n_)): n_ += 1
                        for i in range(n_):
                            q = p.copy(); q.conds.append("%s==%#x" % (ALIAS.get(var, var), i))
                            q.acts.append("%s jt %06X[%d]=%06X" % (m, T, i, be32(T + sc * i)))
                            if m == 'jsr': q.stack.append(nxt)
                            work.append((be32(T + sc * i), q))
                        break
                    else:
                        p.acts.append("%s @er6 (unknown)" % m)
                    if m == 'jmp':
                        res.append((p, "end")); break
                    a = nxt; continue
                p.acts.append("%s %s" % (m, op))
                if m == 'jmp': res.append((p, "end")); break
                a = nxt; continue
            mm = TGT.search(op)
            if m == 'bsr' and mm:
                p.stack.append(nxt); a = int(mm.group(1), 16); continue
            if m == 'bra' and mm:
                a = int(mm.group(1), 16); continue
            if m in BR and mm:
                tg = int(mm.group(1), 16)
                if p.flag is None:
                    q = p.copy(); q.conds.append("%s?" % m); work.append((tg, q))
                    p.conds.append("!%s?" % m); a = nxt; continue
                t, ctrue, cfalse = evalcond(m, p.flag, K)
                if t is True: a = tg; continue
                if t is False: a = nxt; continue
                q = p.copy(); q.conds.append(ctrue); work.append((tg, q))
                p.conds.append(cfalse); a = nxt; continue
            if m in ('bld', 'bst', 'bset', 'bclr', 'bnot', 'nop', 'orc', 'andc', 'stc', 'ldc', 'push.l', 'pop.l', 'push.w', 'pop.w'):
                if m in ('bset', 'bclr', 'bnot'):
                    mv = memvar(op.split(',', 1)[1]) if ',' in op else None
                    if mv: p.acts.append("%s %s %s" % (m, op.split(',')[0], mv))
                a = nxt; continue
            # any other op: clobber destination register and flags
            if ',' in op:
                dn, _ = regno(op.rsplit(',', 1)[1])
                if dn is not None: p.regs[dn] = None
            p.flag = None
            a = nxt
    return res


def summarize(res, skipcalls=()):
    out = []
    for p, end in res:
        acts = [x for x in p.acts if not any(x.endswith("%06X" % s) for s in skipcalls)]
        out.append((p.conds, acts, end))
    return out

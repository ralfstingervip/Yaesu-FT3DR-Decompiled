import sys
from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# M13 -- extract every (address, byte-run) citation from docs 98-112, the L-wave section of RESUME-FULL.md (lines 12-216)
# and ida\out\l-wave-recon\README.md, and check each against the images. Read-only. Writes citations.tsv, coverage.tsv.
# Grading engine adapted from L13's l13_citations.py (ledger-reverify-k); scope and manual list (m13_manual.py) are M13's.
# OUTDIR env var redirects outputs (used for the scratch re-run).
# Run: python "ida/out/ledger-reverify-l/m13_citations.py"
import os, re, struct, sys
sys.dont_write_bytecode = True

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r'ida\out\ledger-reverify-l')
OUTW = os.environ.get('OUTDIR', OUT)
DOCS = os.path.join(ROOT, r'docs\deep')
P = lambda *a: os.path.join(ROOT, *a)
sys.exit('The firmware image is not in this repository.')
SUBB = 0xFFC00000

DOCNUMS = list(range(98, 113))
DOCFILES = {}
for f in os.listdir(DOCS):
    m = re.match(r'(\d{2,3})-.*\.md$', f)
    if m and int(m.group(1)) in DOCNUMS:
        DOCFILES[f] = f
DOCFILES['RESUME-FULL.md'] = 'RESUME-FULL.md'
R_LO, R_HI = 12, 216          # L-wave section of RESUME-FULL.md (1-based, inclusive); other lines blanked, numbering kept
LINES = {k: open(os.path.join(DOCS, k), encoding='utf-8').read().split('\n') for k in DOCFILES}
LINES['RESUME-FULL.md'] = [L if R_LO <= i <= R_HI else '' for i, L in enumerate(LINES['RESUME-FULL.md'], 1)]
LINES['README.md'] = open(P(r'ida\out\l-wave-recon\README.md'), encoding='utf-8').read().split('\n')

HX2 = r'(?:[0-9A-Fa-f]{2}|\?\?|xx)'
SEP = r'(?: | \| |\s*…\s*|\s*\.\.\.\s*)'
BYTERUN = HX2 + r'(?:' + SEP + HX2 + r')*'
ADDR = r'(?:0x[0-9A-Fa-f]{4,8}|[0-9A-Fa-f]{6}|FF[0-9A-Fa-f]{6}|ff[0-9a-f]{6})'
RE_INSPAN = re.compile(r'^(?:sub_|loc_)?(' + ADDR + r')(?:\s*[:=]\s*|\s+)(' + BYTERUN + r')(?:\s+[A-Za-z][A-Za-z.]{2,}.*)?$')
RE_ADDRONLY = re.compile(r'^(?:(?:sub_|loc_)([0-9A-Fa-f]{4,8})|(' + ADDR + r'))$')
RE_BYTESONLY = re.compile(r'^(' + BYTERUN + r')$')
RE_HEX8 = re.compile(r'^([0-9A-Fa-f]{8})$')
RE_LISTING = re.compile(r'^\s*(?:0x)?([0-9A-Fa-f]{6,8}):?\s{1,3}((?:[0-9a-f]{2} )*[0-9a-f]{2})(?:\s{2,}|\s*$)')
RE_LISTING_CMT = re.compile(r'^\s*(?:0x)?([0-9A-Fa-f]{6,8})\s+.*;\s*((?:[0-9a-f]{2} )*[0-9a-f]{2})\s*$')
RE_LISTING_CAT = re.compile(r'^\s*(?:0x)?([0-9A-Fa-f]{6,8})\s+((?:[0-9a-f]{2}){2,})\s{2,}\S')
GAP_FWD = re.compile(r'^\s*(?:=|:|\(|\||is|are|holds|begins|ends)?\s*(?:\(|\|)?\s*$')
GAP_AT = re.compile(r'^\s*at\s*$')
GAP_REV = re.compile(r'^\s*\(\s*$')


def is_addr_token(t):
    if not re.fullmatch(ADDR, t):
        return False
    if not t.lower().startswith('0x') and not re.search(r'[0-9]', t):
        return False                 # e.g. "facade"
    return True


def addr_only(t, allow_sub=True):
    m = RE_ADDRONLY.match(t.strip())
    if not m:
        return None
    if m.group(1):
        return int(m.group(1), 16) if allow_sub else None
    return parse_addr(m.group(2)) if is_addr_token(m.group(2)) else None


def parse_addr(t):
    return int(t[2:] if t.lower().startswith('0x') else t, 16)


def mkbytes(run):
    """'6b 04 bb c2 | 79 24 … 5d 60' -> list of segments (lists of ints); '…' splits segments."""
    run = run.replace('...', '…').replace('|', ' ')
    segs = [s.split() for s in run.split('…')]
    lead = run.strip().startswith('…')
    out = [[None if x in ('??', 'xx') else int(x, 16) for x in s] for s in segs if s]
    return ([[]] + out) if lead else out


def locate(a):
    """return (image_name, buffer, offset) or (None,..) for RAM / out of image."""
    if a >= SUBB:
        return 'SUB', S, a - SUBB
    if a < 0x100000:
        return 'MAIN', M, a
    if a < 0x400000:
        return 'SUB', S, a          # 0x100000..0x3FFFFF can only be a SUB file offset
    return None, None, None


def match_at(buf, off, segs, gapmax=96):
    """first segment exactly at off; later segments in order within gapmax of the previous end."""
    def eq(o, s):
        return 0 <= o and o + len(s) <= len(buf) and all(x is None or buf[o + k] == x for k, x in enumerate(s))
    if segs[0] and not eq(off, segs[0]):
        return False
    pos = off + len(segs[0])
    for s in segs[1:]:
        j = next((j for j in range(pos, pos + gapmax + 1) if eq(j, s)), -1)
        if j < 0:
            return False
        pos = j + len(s)
    return True


def grade(a, segs, ctx_sub=False):
    """returns (verdict, image, actual_hex, true_addr_note)"""
    img, buf, off = locate(a)
    n = len(segs[0]) if segs[0] else len(segs[1])
    if img is None:
        return 'DROPPED', '-', '', 'address %X is a RAM operand, not an image location (bytes are the instruction acting on it; no image address given)' % a
    act = buf[off:off + max(n, 1)].hex(' ') if off + n <= len(buf) else ''
    if match_at(buf, off, segs):
        return 'PASS', img, act, ''
    # SUB file offset written without the FF base
    if img == 'MAIN' and a < len(S) and match_at(S, a, segs):
        return 'PASS-SUBFILE', 'SUB', S[a:a + n].hex(' '), 'file offset in SUB = %X' % (a + SUBB)
    for d in sorted(range(-8, 9), key=abs):
        if d and match_at(buf, off + d, segs):
            return 'WRONG-ADDR', img, act, 'run found at %X (delta %+d)' % (a + d, d)
    if img == 'MAIN' and a < len(S):
        for d in sorted(range(-8, 9), key=abs):
            if d and match_at(S, a + d, segs):
                return 'WRONG-ADDR', 'SUB', S[a:a + n].hex(' '), 'run found at SUB file %X (delta %+d)' % (a + d, d)
    # whole-image search for runs >= 4 bytes
    flat = bytes(x for x in segs[0] if x is not None) if None not in segs[0] else b''
    if len(flat) >= 4:
        hits = []
        for nm, bb, base in (('MAIN', M, 0), ('SUB', S, SUBB)):
            j = bb.find(flat)
            while j >= 0 and len(hits) < 6:
                if match_at(bb, j, segs):
                    hits.append((nm, j + base))
                j = bb.find(flat, j + 1)
        if hits:
            return 'WRONG-ADDR', img, act, 'run found elsewhere: ' + ', '.join('%s %X' % h for h in hits[:5]) + (' (+more)' if len(hits) > 5 else '')
    return 'FAIL', img, act, ''


rows = []          # doc, line, address, bytes_cited, bytes_actual, verdict, image, source, note
seen = set()


def add(doc, ln, a, segs, src, note='', kind='bytes', subname=False):
    key = (doc, ln, a, tuple(map(tuple, segs)))
    if key in seen:
        return
    seen.add(key)
    v, img, act, tn = grade(a, segs)
    if subname and v != 'PASS':
        flat = segs[0]
        if len(segs) == 1 and len(flat) == 4 and flat[0] in (0x5E, 0x5A) and (flat[1] << 16 | flat[2] << 8 | flat[3]) == a:
            v, tn = 'PASS-ENCODING', 'bytes are the jsr/jmp encoding of sub_%X (call site not given)' % a
        else:
            img2, buf, off = locate(a)
            if img2 and any(match_at(buf, off + d, segs) for d in range(1, 33)):
                d = next(d for d in range(1, 33) if match_at(buf, off + d, segs))
                v, tn = 'PASS-WITHIN', 'parenthetical after sub_%X: bytes are inside the routine at %X (+%d), not at its entry' % (a, a + d, d)
    cited = ' … '.join(' '.join('??' if x is None else '%02x' % x for x in s) for s in segs)
    rows.append([doc, ln, '%X' % a, cited, act, v, img, src, '; '.join(x for x in (note, tn) if x)])


in_fence = {}
for doc, lines in LINES.items():
    fence = False
    for i, line in enumerate(lines, 1):
        if line.strip().startswith('```'):
            fence = not fence
            continue
        # listing lines (fenced code blocks, indented blocks)
        if fence or line.startswith('    ') or re.match(r'^[0-9A-Fa-f]{6,8}\s', line):
            m = RE_LISTING.match(line)
            if m and is_addr_token(m.group(1)):
                add(doc, i, parse_addr(m.group(1)), mkbytes(m.group(2)), 'listing')
                continue
            m = RE_LISTING_CAT.match(line)
            if m and is_addr_token(m.group(1)) and len(m.group(2)) % 2 == 0:
                add(doc, i, parse_addr(m.group(1)), [[int(m.group(2)[k:k + 2], 16) for k in range(0, len(m.group(2)), 2)]], 'listing-concat')
                continue
            m = RE_LISTING_CMT.match(line)
            if m and is_addr_token(m.group(1)):
                add(doc, i, parse_addr(m.group(1)), mkbytes(m.group(2)), 'listing-comment')
                continue
        spans = [(mm.start(), mm.end(), mm.group(1)) for mm in re.finditer(r'`([^`]+)`', line)]
        used = set()
        # reverse ' at ': `BYTES` at `ADDR`
        for k in range(len(spans) - 1):
            mb = RE_BYTESONLY.match(spans[k][2].strip())
            aa = addr_only(spans[k + 1][2], allow_sub=False)
            if mb and aa is not None and len(mb.group(1).split()) >= 2 and GAP_AT.match(line[spans[k][1]:spans[k + 1][0]]):
                add(doc, i, aa, mkbytes(mb.group(1)), 'bytes-at-addr')
                used.update((k, k + 1))
        for k, (s0, s1, t) in enumerate(spans):
            if k in used:
                continue
            t = t.strip()
            m = RE_INSPAN.match(t)
            if m and is_addr_token(m.group(1)) and len(m.group(2).replace('|', ' ').replace('…', ' ').split()) >= 2:
                add(doc, i, parse_addr(m.group(1)), mkbytes(m.group(2)), 'in-span')
                continue
            a0 = addr_only(t)
            if a0 is not None:
                # forward: ADDR [/ ADDR]* gap BYTES
                addrs = [a0]
                kk = k
                while kk + 1 < len(spans) and re.fullmatch(r'\s*/\s*', line[spans[kk][1]:spans[kk + 1][0]]) and addr_only(spans[kk + 1][2], False) is not None:
                    kk += 1
                    addrs.append(addr_only(spans[kk][2], False))
                if kk + 1 < len(spans) and kk + 1 not in used:
                    gap = line[spans[kk][1]:spans[kk + 1][0]]
                    nxt = spans[kk + 1][2].strip()
                    if GAP_FWD.match(gap):
                        mb = RE_BYTESONLY.match(nxt)
                        if mb and len(mb.group(1).split()) >= 2:
                            for a in addrs:
                                add(doc, i, a, mkbytes(mb.group(1)), 'adjacent-span' if not t.startswith(('sub_', 'loc_')) else 'sub-paren', subname=t.startswith(('sub_', 'loc_')))
                            continue
                        mh = RE_HEX8.match(nxt)
                        if mh and '=' in gap:
                            v = int(mh.group(1), 16)
                            for a in addrs:
                                bs = list(struct.pack('<I' if a >= SUBB else '>I', v))
                                add(doc, i, a, [bs], 'adjacent-span-dword', 'dword %08X read %s' % (v, 'LE' if a >= SUBB else 'BE'))
                            continue
                # reverse: BYTES (ADDR)
                if k > 0 and k - 1 not in used and GAP_REV.match(line[spans[k - 1][1]:s0]):
                    mb = RE_BYTESONLY.match(spans[k - 1][2].strip())
                    if mb and len(mb.group(1).split()) >= 2 and not RE_INSPAN.match(spans[k - 1][2].strip()):
                        if not t.startswith(('sub_', 'loc_')):
                            add(doc, i, a0, mkbytes(mb.group(1)), 'reverse-span')

# manual additions
sys.path.insert(0, OUT)
import m13_manual as l13_manual
for (doc, anchor, a, kind, exp, note) in l13_manual.CITES:
    lines = LINES[doc]
    ln = next((j + 1 for j, L in enumerate(lines) if anchor in L), None)
    if ln is None:
        rows.append([doc, 'ANCHOR-NOT-FOUND', '%X' % a, str(exp), '', 'ERROR', '', 'manual', anchor])
        continue
    if kind == 'bytes':
        add(doc, ln, a, mkbytes(exp), 'manual', note)
    elif kind in ('be32', 'le32'):
        add(doc, ln, a, [list(struct.pack('>I' if kind == 'be32' else '<I', exp))], 'manual-' + kind, (note + '; ' if note else '') + '%s 0x%08X' % (kind, exp))
    elif kind == 'ascii':
        add(doc, ln, a, [list(exp)], 'manual-ascii', (note + '; ' if note else '') + 'ascii %r' % exp)
    elif kind == 'na':
        rows.append([doc, ln, '%X' % a, str(exp), '', 'UNCHECKABLE', '', 'manual', note])
    elif kind == 'drop':
        # an automatic extraction that is not a byte citation (e.g. an immediate written next to an address)
        for r in rows:
            if r[0] == doc and r[1] == ln and r[2] == '%X' % a and r[7] != 'manual' and r[5] != 'DROPPED':
                r[8] = (r[8] + '; ' if r[8] else '') + 'not a byte citation: ' + note
                r[5] = 'DROPPED'
    elif kind == 'regrade':
        # replace verdict of an automatic row after manual inspection
        for r in rows:
            if r[0] == doc and r[1] == ln and r[2] == '%X' % a and r[7] != 'manual' and r[5] != 'PASS':
                r[5] = exp
                r[8] = (r[8] + '; ' if r[8] else '') + note

rows = [r for r in rows if r[5] != 'DROPPED'] + [r for r in rows if r[5] == 'DROPPED']
with open(os.path.join(OUTW, 'citations.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('doc\tline\taddress\tbytes_cited\tbytes_actual\tverdict\timage\tsource\tnote\n')
    for r in rows:
        f.write('\t'.join(str(x) for x in r) + '\n')

# coverage: every line in scope with a backticked / listing run of >=2 hex byte tokens
cited_lines = {(r[0], r[1]) for r in rows if r[5] != 'DROPPED'}
RE_ANYRUN = re.compile(r'(?<![0-9A-Za-z])' + HX2 + r' ' + HX2 + r'(?![0-9A-Za-z])')
COUNT_WORDS = ('×', ' times', 'exactly', 'scan', 'Nineteen', 'image has', 'once', 'zero hits', '0 of ', 'in the image')
def reason(doc, i, line):
    if any(w in line for w in COUNT_WORDS):
        return 'pattern count -> counts_tables.tsv'
    if (doc, i - 1) in cited_lines and line.lstrip().startswith(tuple('0123456789abcdef')):
        return 'continuation of a cited span on the previous line'
    if 'citations_note' in line:
        return ''
    return 'notation / opcode or value list / lane-test output; no image address'
cov = []
for doc, lines in LINES.items():
    for i, line in enumerate(lines, 1):
        if RE_ANYRUN.search(line):
            st = 'cited' if (doc, i) in cited_lines else 'UNCITED'
            cov.append((doc, i, st, (reason(doc, i, line) if st == 'UNCITED' else ''), line.strip()[:200]))
with open(os.path.join(OUTW, 'coverage.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('doc\tline\tstatus\ttext\n')
    for r in cov:
        f.write('%s\t%d\t%s\t%s\n' % (r[0], r[1], r[2], r[3].replace('\t', ' ')))

from collections import Counter
live = [r for r in rows if r[5] != 'DROPPED']
print('citations:', len(live), Counter(r[5] for r in live))
print('dropped:', len(rows) - len(live))
print('coverage lines:', len(cov), Counter(c[2] for c in cov))

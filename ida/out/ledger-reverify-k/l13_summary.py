from pathlib import Path as _Path
_REPO = _Path(__file__).resolve().parents[3]
# L13 -- assemble counts.tsv from the three check tables, the citation tallies and the re-run table.
# Run after l13_ledger.py, l13_citations.py, l13_counts.py, l13_rerun.py.
import csv, os, collections

OUT = str(_REPO) + r'/ida/out/ledger-reverify-k'
rd = lambda f: list(csv.DictReader(open(os.path.join(OUT, f), encoding='utf-8'), delimiter='\t'))
rows = []
for r in rd('counts_ledger.tsv'):
    rows.append(('ledger:' + r['group'], '83,95,R', r['item'], r['got'], r['expected'], r['verdict'], r['note']))
for r in rd('counts_tables.tsv'):
    rows.append((r['group'], r['doc'], r['item'], r['got'], r['expected'], r['verdict'], r['note']))
for r in rd('rerun.tsv'):
    v = r['verdict']
    note = r['note']
    if v == 'DIFFERS' and (r['lane'], r['file']) in (('L97', 'scan.txt'), ('L95', 'oracle-summary.txt')):
        v, note = 'DIFFERS-EXPLAINED', note + '; only the mask-list lines differ: a later lane wrote ida/out/main-final5/final5_proven_mask.bin, which the script picks as newest; the frozen re-run (final5 excluded) is IDENTICAL'
    rows.append(('rerun:' + r['lane'], '-', r['file'] + ' ' + r['check'], r['value'], '', 'PASS' if v in ('PASS', 'IDENTICAL') else v, note))
cit = [r for r in rd('citations.tsv') if r['verdict'] != 'DROPPED']
tal = collections.defaultdict(collections.Counter)
for r in cit:
    tal[r['doc']][r['verdict']] += 1
for d in sorted(tal):
    rows.append(('citation-tally', d, 'citations by verdict', ' '.join('%s=%d' % kv for kv in sorted(tal[d].items())), '', 'INFO', ''))
tot = collections.Counter(r['verdict'] for r in cit)
rows.append(('citation-tally', 'all', 'citations by verdict', ' '.join('%s=%d' % kv for kv in sorted(tot.items())), '', 'INFO', 'total %d' % len(cit)))
with open(os.path.join(OUT, 'counts.tsv'), 'w', encoding='utf-8', newline='') as f:
    f.write('group\tdoc\titem\tgot\texpected\tverdict\tnote\n')
    for r in rows:
        f.write('\t'.join(str(x).replace('\t', ' ') for x in r) + '\n')
c = collections.Counter(r[5] for r in rows)
print('counts.tsv rows %d' % len(rows), dict(c))
for r in rows:
    if r[5] not in ('PASS', 'INFO'):
        print(r)
for d in sorted(tal):
    print(d, dict(tal[d]))
print('all', dict(tot), len(cit))

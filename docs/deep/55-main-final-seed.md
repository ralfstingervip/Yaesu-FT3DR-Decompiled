# 55 — MAIN_FINAL: the consolidated MAIN seed database (Lane I3)

> Lane I3. Private DB `MAIN_FINAL` (`ida\db\jobs\MAIN_FINAL\MAIN_FINAL.i64`), seeded with
> `--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64` (H2's H8SX seed). Job: `ida\jobs\i3_apply_main_final.py`
> (reusable, idempotent). Tables: `ida\out\main-final\`. Image: `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (MAIN, H8SX core, base 0, big-endian, so file offset = mapped address). No other database was opened;
> `--copy-from` only read the MAIN_H8SX seed. Static analysis only: no image byte was modified and nothing
> was connected to or written to a radio. The closed CDC-ACM / DSP-download window `0x078106`–`0x07B753`
> was never analysed; its code is byte-identical to the seed (318 code bytes, 99 code heads). Reconciliation
> re-ran H9's own offline scripts (`ida\out\main-descent\offline\`) read-only against their session pickles.
> Model: claude-opus-5-5 (Claude Opus 5.5).

## Verdict

**`ida\db\jobs\MAIN_FINAL\MAIN_FINAL.i64` is the final MAIN seed. It is a true fixed point** (a second
`--reopen` pass changes 0 functions, 0 code bytes, 0 heads) and it carries every H-wave MAIN result:
H2's H8SX decode and filtered G2 table xrefs, H3's 119 pointer arrays, H9's six excluded data tables and
RAM-callback hooks, and H1's F1 / fnindex start corrections. Processor `h8sxa`; one segment
`ROM 0x000000-0x100000`; 5,337 functions; 390,440 code bytes (390,122 in `0x000000`–`0x078106` + 318 in the
closed window); **0 odd-aligned code heads**; the six H9 data tables hold 0 code heads and 0 outgoing xrefs.

**Both H-wave coverage headlines reproduce to the byte against this database's inputs**, so this lane
introduces **no ledger delta**: MAIN proven code **365,570** and MAIN named/typed **497,139** (`ledger-delta.tsv`,
all rows delta 0). Survival of F1's 444 indirect functions rises to **324 strict / 417 corrected**
(H3 was 323 / 352; the MAIN_H8SX baseline was 269 / 361). 365,536 of the 365,570 proven bytes are code in the
DB; the 34 that are not are 2-byte lead-ins at 16 sites where IDA places the instruction head at the F1
`+2` entry (explained below, not a defect). 24,904 DB code bytes sit outside H9's proven set; they are
listed and classified (`dbcode-not-proven.tsv`) and are overwhelmingly typed "recovered code" that H9's
strict descent does not reach — exactly the typed-but-unproven surplus the named/typed figure already credits.

## Method

Every IDA step ran through `python ida\run_job.py --script ida\jobs\i3_apply_main_final.py --db MAIN_FINAL`,
first with `--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`, thereafter with `--reopen`.

1. **Offline prep (plain Python).** From the H9 descent pickle and the wave's TSVs I generated three
   inputs under `ida\out\main-final\`: `g2-xrefs-final.tsv` (H2's 3,888-row filtered G2 set minus the 7
   rows of the six H9 tables = 3,881 rows), `h9-excl-tables.tsv` (the six table extents), and
   `ram-hook-edges.tsv` (H9's 19 RAM-callback edges: target + store site).

2. **`i3_apply_main_final.py` (idempotent).** Per pass it runs the mutation sequence **twice** (so targets
   that only form on a second analysis round are baked in, making a later `--reopen` a true fixed point):
   - apply `g2-xrefs-final.tsv` and `ptr-arrays\xrefs.tsv` (H3 tiers A/B/C, 1,331 rows) — slot → dword
     offset, user data xref, target → code + function;
   - add the 19 RAM-hook targets as code + functions, with a user dref from the store site;
   - apply H1's F1 start corrections: the 5 `proved-corrected.tsv` text-trimmed rows (ASCII prefix → string,
     true entry → function) and the 30 `fnindex-corrections.tsv` junk/text spans (delete the bogus function,
     retype string/data);
   - exclude the six H9 data tables **last** (so any pre-existing or re-added ref is stripped): remove every
     outgoing xref from their slots, type the extent as plain-number dwords (`op_hex`, to stop IDA
     auto-re-creating an offset on reload), delete any function starting inside.
   Analysis is drained with `auto_wait()` only; **no broad `plan_and_wait`** (an early trial showed a full
   re-plan of `0x000400`–`0x078106` mis-decoded data tables into 61 odd heads — those were not real). A final
   odd-head sweep deletes any odd code head outside the window and settles; it removed 0. The window's code
   heads are snapshotted and restored (restored 0 — the window was never disturbed).

3. **Fixed point.** `--copy-from` pass then `--reopen` pass. The reopen's round 1 and round 2 both make
   0 functions and remove 0 xrefs; BEFORE == AFTER (`MAIN_FINAL_log.txt`): funcs 5,337, code bytes 390,122
   (scope) + 318 (window), odd heads 0, survival 324/417. DELTA all 0.

4. **Reconciliation (read-only).** I re-ran H9's `masks.py` (which still finds its `reach.pkl`) and loaded
   H9's `descent.pkl`, rebuilt the proven byte mask `P = (A|RC|D|G1A) \ demoted(RC,D) ∪ new-proven` from
   the published `main-descent\demoted.tsv` / `reached.tsv`, and compared it to the DB code mask dumped by
   the job (`MAIN_FINAL_codemask.bin`, one byte per address over every code item).

**Scope / limits.** The closed window was not analysed. I did not re-purpose any function or resolve the
indirect `jmp/jsr @ERn` callbacks (lane I8). The H9 proven/named figures are a descent+mask computation, not
a direct DB property; I reproduced them from H9's own inputs and verified the DB is consistent with them.

## Findings

### 1. What MAIN_H8SX already contained vs. what I added (task 1)

| Input | In MAIN_H8SX? | Action in MAIN_FINAL |
| --- | --- | --- |
| h8sxa, 0 odd heads, 390,184 code B, F1 six-row fixes, 306-row-filtered G2 | yes | carried |
| H3's 119 pointer arrays (1,331 xrefs) | **no** | applied; +315 functions (round 1) +18 (round 2) |
| H9's 6 data tables excluded | no (H2 only dropped G2's 306 rows) | 7 applied G2 rows removed, extents → data, 0 heads inside |
| H9 RAM-callback hooks (19 edges, cells `0xFF811A`/`0xFF811E`/`0xFFB288`/`0xFFB3C6`) | no | 15 new target functions + store-site drefs |
| H1 F1 text-trims (5 rows) | 2 of 5 (04DE6E/04DF72) | all 5 applied (adds 04E320/04E538/051694) |
| H1 fnindex junk-span corrections (30) | no | 29 functions deleted, 30 spans retyped |

### 2. The database is a fixed point (task 3; `MAIN_FINAL_log.txt`)

| Pass | funcs | code B (scope+win) | odd heads | survival strict/corr |
| --- | ---: | ---: | ---: | --- |
| `--copy-from` BEFORE (= MAIN_H8SX) | 5,022 | 389,866 + 318 | 0 | 269 / 361 |
| `--copy-from` AFTER | 5,337 | 390,122 + 318 | 0 | 324 / 417 |
| `--reopen` BEFORE | 5,337 | 390,122 + 318 | 0 | 324 / 417 |
| `--reopen` AFTER (round 1 & 2 each: 0 funcs, 0 xref) | **5,337** | **390,122 + 318** | **0** | **324 / 417** |

`--reopen` DELTA: funcs +0, code bytes +0, odd heads +0. The six excluded tables carry 0 code heads and
0 outgoing xrefs (`MAIN_FINAL_tables.tsv`).

### 3. F1 survival (task 4)

MAIN_FINAL: **324 strict**, **417 corrected** of 444 (`MAIN_FINAL_survival.tsv`). This beats H3's 323 / 352
(H3 measured on the `h8s300a` DB `FIN_MAIN_IND`). Corrected climbs most because MAIN_H8SX had already moved
the F1 starts to their true entries, so the H3 arrays + G2 + RAM edges now land an incoming xref on the
real entry rather than on a mid-instruction byte.

### 4. Proven-set coverage of the DB (task 4)

- **Every proven byte but 34 is code in the DB.** 365,536 / 365,570 (99.99%). The 34 bytes are 2-byte
  lead-ins at 16 sites (`proven-not-dbcode.tsv`), e.g. `0x001FDE`, `0x002020`−2, `0x006944` (`5e 00`, the
  `jsr @0x85DA` whose fnindex start sits +2 inside it), `0x046B82`, `0x04AAA8`. H9's binutils oracle begins
  the instruction 2 bytes before where IDA `h8sxa` places the head (the F1 `+2` / fnindex-overlap entry).
  The bytes are identical and executed either way; the DB uses the true entry. Confirmed, benign.
- **24,904 DB code bytes are outside the proven set** (`dbcode-not-proven.tsv`, 98 of them in the window).
  Classified outside the window: recovered code 15,742, untyped 3,564, text 2,992, parameter table 1,560,
  string 516, fill 270, other 138, pointer table 24. This is H9's point restated at the byte level: the DB
  types the full recovered-code superset (390,440 B) while *proven* is the strict-reachable subset
  (365,570 B); the 24,870-byte difference (= 24,904 − 34) is typed-but-unproven and is credited under its
  type in the named/typed figure, not in proven.

### 5. Recount reconciled to the byte (task 5; `ledger-delta.tsv`)

Rebuilding H9's masks from H9's own inputs:

| Figure | H9 | I3 reproduced | delta |
| --- | ---: | ---: | ---: |
| MAIN proven code | 365,570 | **365,570** | **0** |
| MAIN named / typed | 497,139 | **497,139** | **0** |

- **Proven** `P = (A ∪ RC ∪ D ∪ G1A) \ demoted(RC,D) ∪ new-proven`. Byte union `PU = 375,217`
  (= H1's additive 375,469 − 28 doc-33 − 224 RC∩G1A, both removed by the union). `demoted = 17,704`
  (`demoted.tsv` RC+D = 17,080 + 624), `new-proven = 8,057` (`reached.tsv`). `375,217 − 17,704 + 8,057 =`
  **365,570**, confirmed by summing the mask. The 220 bytes H9 keeps inside the closed window (28 A + 192 RC)
  are part of that 365,570, matching H9's arithmetic.
- **Named** `= 492,708 − leaves(1,096 + 547 + 2) + join(6,076)`, where `join` = reached bytes outside the
  H1 named union (A∪B∪D∪E∪F∪H). Recomputed join = **6,076** exactly → **497,139**.
- **No double count** (byte-mask argument, against `main-descent\ledger-delta.tsv` and `recount\recount.tsv`):
  `new-proven ∩ demoted = 0`; `new-proven ⊆ P` (all 8,057); `demoted ∩ P = 0` (fully removed). The three
  adjustment sets are pairwise disjoint over the kept proven union, so nothing is added or subtracted twice.

### 6. Function model (task 6; `functions.tsv`)

5,337 functions with a reach class derived from the proven mask: **5,212 proven**, 30 partly-proven,
89 typed-unreached, 6 in the closed window. `functions.tsv` columns: `start`, `end`, `size`, `reach_class`.

### How to seed from MAIN_FINAL

A future MAIN lane starts cold from this DB and inherits the whole H wave:

```
python ida\run_job.py --script ida\jobs\<your>.py --db <YOURDB> \
    --copy-from ida\db\jobs\MAIN_FINAL\MAIN_FINAL.i64
```

It is `h8sxa`, base 0, a fixed point, so no re-analysis is needed before you work. Do **not** run a broad
`plan_and_wait` over `0x000400`–`0x078106` (it re-decodes data tables into odd heads — see Method 2); drain
with `auto_wait()` after your own edits. Never `plan` into `0x078106`–`0x07B753` (the closed window) unless
your lane owns it. `i3_apply_main_final.py` is idempotent and can be re-run on a copy to rebuild the state.

## USB relevance

Tooling, not new USB content, but it hardens three USB facts for later lanes:
- The six excluded data tables include **`0x05584A`**, the pointer list to the USB configuration/interface/
  endpoint descriptors at `0x05585E` (`09 02 20 00 …`). It is now data in the seed, not a jump table, so no
  future lane will mis-promote the descriptors to code.
- The vector-235 USB control-transfer dispatch (`0x055002`, 12 states on `0xFF8183`) and the `0x056B8A`
  28-state dispatch now carry their H3-array xrefs in the seed, so the vendor-class stack is reachable in the
  DB without re-deriving the `78 b0 6b 26` loads.
- The RAM interrupt hooks `0xFF811A` / `0xFF811E` (vectors 88 / 97) and their installers are now functions
  with incoming xrefs. No array or RAM edge lands in the closed CDC-ACM / DSP-download window; it is
  untouched. SDR and DSP answers are unchanged.

## Open

Most valuable first:
1. **Resolve the 267 `jmp/jsr @ERn` struct-member callbacks** (lane I8). The 89 typed-unreached functions
   and the 15,742 B of unreached "recovered code" in `dbcode-not-proven.tsv` are the ceiling for what that
   could move back into the proven set.
2. **Retype the residual text/table-as-code in the DB.** 2,992 B text + 516 B string + 270 B fill + 24 B
   pointer table are still `is_code` in the seed (H9 demoted them from proven but they remain typed code).
   A lane could create the strings/data to make the DB match H9's classification; this does not change any
   headline (they stay named/typed under their type) but tidies the function model.
3. **The 34-byte boundary difference** (`proven-not-dbcode.tsv`): decide per site whether IDA's `+2` head or
   H9's oracle boundary is correct; four of them (`001FE0`, `002020`, `046B84`, `04AAAA`) are H9 "weak-714"
   rows and one is the `sub_6946`/`0x006944` overlap.
4. Settle the 30 partly-proven and 89 typed-unreached functions against the indirect-callback work before
   any final function-count headline.
```

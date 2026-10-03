# 100 — fnindex-only proven runs 0x030000–0x04FFFF: edge check (Lane L3)

> Lane L3, model `claude-opus-5-5`. Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, base 0,
> big-endian, file offset = address; sha256 `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…`, both re-checked, unchanged).
> Nothing was written to or connected with any radio or device. Only my DB `ida\db\jobs\L3_FNIDX_MID\L3_FNIDX_MID.i64`
> was opened (`--copy-from` K1_MAIN_FINAL4; read-only job, no item edited). No mask, seed or DB was changed; every
> demotion below is a proposal. Tables: `ida\out\fnindex-mid\`.

## Verdict

**None of the 31 runs (2,532 B) is reached. All 31 should leave the proven mask.** These are the `fnindex`-only runs
with start in `0x030000`–`0x04FFFF`. The split is:

| Class | Runs | Bytes |
| --- | ---: | ---: |
| DEAD | 16 | 1,960 |
| SPLIT-TAIL | 8 | 428 |
| DATA-MISTYPED | 7 | 144 |
| REACHED | 0 | 0 |
| UNCERTAIN | 0 | 0 |

The 16 DEAD runs include `0x03C668` (820 B) and `0x046210` (472 B).

- **`0x03C668` (820 B) is DEAD (Confirmed).** It is J14's 64-B I2C page writer. The only edge into it is its own retry
  `0x03C996 58 60 fc ce` (`bne 0x3C668`). It follows the `rts` at `0x03C666`. Whole-image there are 0 jsr/jmp, bsr/bra,
  BE32 and immediate references.
- **`0x046210` (472 B) is DEAD (Confirmed).** It holds three NMEA field parsers. All three of their calls (`0x0460C8`,
  `0x0460D6`, `0x046104`) sit in `0x0460C2`–`0x04612F`. That block of the live GPS parser `sub_45FBA` is jumped over by
  the unconditional `0x0460C0 40 6e` (`bra 0x46130`) and no edge enters it.

**Measured.** I re-ran K1's folded descent with only the 45 fnindex seeds inside these runs removed:
- It loses **2,760 B**. 2,508 B are in my runs.
- The other 252 B are fnindex-only runs `0x077CC2` (168) and `0x07778C` (84). Those are callees of the dead
  `0x0337xx` trio and belong to another lane.
- The remaining 24 B of my runs (`0x03CE0A`) stay reached only through fnindex run `0x022DF0`. That run is itself dead:
  its only caller `0x022DE6` is in head `0x022DDE`, which has 0 references. Dropping `0x022DF0`'s two seeds as well
  loses all 2,532 B.

**Proposed MAIN proven:**
- 368,346 (after the pending `0x054AE2` −278) − 2,532 = **365,814 (72.340 %)**.
- With the measured spillover of 252 B: 365,562.
- With the 116 B of adjacent proven-unreached bytes in the same dead routines: 365,446.

**Named is unchanged** at 497,451 under the I12 convention (code stays typed, and the 144 B of data get retyped as
data, which keeps them named).

## Method

All of the passes below were run this session.

1. **Offline reproduction** (`ida\out\fnindex-mid\offline\l3_edges.py`). I exec'd the pure, write-free prefix of K1's
   `k1_build_masks.py` (everything before "attribution runs"). Then I ran K1's `run_folded(COMBINED)`.
   - Asserted: it reproduces `final4_proven_mask.bin` byte for byte (368,624).
   - With `FNSEED` emptied, `proven ∧ ¬reach0 ∧ reachK` = 4,850 B, which equals `fnindex-only-runs.tsv` (94 runs).
   - Per run, I removed only the fnindex seeds inside that run and measured what was lost (`work\l3_edges_log.txt`).
2. **Whole-image inbound scan** (`offline\l3_refs.py`, `offline\l3_classify.py` → `refs-detail.tsv`). The scope is
   `0x000000`–`0x07B753`, including the closed window, which is decoded only. It covers:
   - the binutils oracle decode at every even address: direct `bra/bcc/bsr` (8/16-bit), `jsr/jmp @aa:24`, and every
     numeric operand (`#imm`, `@aa:16/24/32`, `@(d:32,ERn)`);
   - `jsr/jmp @@aa:8` slots, resolved through the BE32 cell;
   - `mov.w #hi,eN`/`mov.w #lo,rN` pointer pairs;
   - raw BE32 at **every byte offset** of the 1 MB image, which covers the vector table `0x0`–`0x3FF`, all dispatch and
     record tables, and RAM-cell callback sources;
   - raw `5A`/`5E` + BE24 at every offset;
   - fall-through from the preceding instruction;
   - doc 60's 267 resolved `@ERn` targets (`indirect-cb\targets.tsv`): 0 in range.

   **Register-relative branches.** There are 6 proven `bra/bsr rN.w` in the image (`0x02B3F8`, `0x02B450`,
   `0x05569C`, `0x0559B4`, `0x0559CA`, `0x076308`). None can reach `0x033790`–`0x04C3D1` within ±32 KB.

   Each scan was applied both to the run and to the enclosing routine unit (the true head when the run is a tail). A
   positive control returned all 4 known callers of `0x03C378`.
3. **IDA cross-check.** `ida\jobs\l3_fnidx_xrefs.py` on `L3_FNIDX_MID` dumped every head of the 31 runs and every
   `XrefsTo` of every byte (`work\l3_ida_heads.tsv`, `l3_ida_xrefs.tsv`, 35 xrefs). Every IDA xref is one of the oracle
   rows, and IDA found no extra edge.
4. **Combined measurement** (`measure.txt`). Two variants: removing all 45 seeds inside the 31 runs, and removing those
   plus the 2 seeds of run `0x022DF0`.

**Not done.** I did not check arithmetic pointer construction other than `mov.w` pairs, for example `base + offset`
from an unrelated base. That is Not found within the forms listed. I did not edge-check the cross-lane runs
`0x022DF0`, `0x077CC2` and `0x07778C` beyond the rows cited here.

## Findings

Full per-run evidence is in `runs.tsv`. Ranges, byte sums and sha256 are in `proposed-demotions.tsv`. Every inbound
row is in `refs-detail.tsv`. "0 refs" always means the whole-image scope above.

### DEAD (1,960 B; 0 inbound edges from reached code)

| Run | B | What it is | Evidence (Confirmed) |
| --- | ---: | --- | --- |
| `03C668`–`03C99B` | 820 | J14 multi-page I2C writer (`01 00 6d f0 6a 0a 81 6e 79 06 00 40 5c 00 fd 00`) | Only edge is its own `bne` at `03C996`. The live single-page sibling `03C99C` (`6a 0a 81 6e 79 06 00 40 5c 00 f9 d0`) stays. |
| `046210`–`0463E7` | 472 | NMEA field parsers `046210`/`046290`/`04633C` | Callers `0460C8 5e 04 62 10`, `0460D6 5e 04 62 90` and `046104 5e 04 63 3c` all lie in the skipped block. Other hits are not code edges: `0442E0 bhi` (unproven bytes) and BE32 `@01FBF3` (odd, unproven). |
| `045F88`–`045FB9` | 50 | NMEA field parser | Sole caller `04612A 5e 04 5f 88` is in the same skipped block. |
| `03D3A6`–`03D40D` | 104 | EEPROM verify/rewrite wrappers `03D3A6`/`03D3E6`/`03D3FE` (`sub_3AB80` load, `sub_3AD20` save) | 0 refs; preceded by `rts 03D3A4`. |
| `03A9A2`–`03A9F5` | 84 | EEPROM load + scan of `FFAA58` for `0xFFFFFFFF` | 0 refs; `rts 03A9A0` precedes. |
| `03D436` 60, `03D70E` 60, `03D61C` 50, `03DDCA` 50, `03DC48` 50, `03CDBE` 44, `03D68A` 38, `03D36E` 16 | 368 | EEPROM record load/save wrappers (`01 30 6d f0 … 5e 03 ab 80`/`5e 03 ad 20`/`5e 03 bd ac`/`5e 03 bf 4c … 54 70`) | 0 refs each; each is preceded by an `rts`. Internal leaves `03D63C` and `03DDEA` are called only from inside their runs. |
| `03CDFC`–`03CE21` | 38 | `03CDFC` (14 B) wrapper; `03CE0A` (24 B) EEPROM load of `FFAC24` | `03CDFC` has 0 refs. `03CE0A` is called only from `022E06`/`022E0E` (`5e 03 ce 0a`) in run `022DF0`. That run's only caller is `022DE6 55 08` inside head `022DDE`, which has 0 refs. |
| `03FFCA`–`03FFDF` | 22 | 8-bit sum of 63 B at `FF8EA0` | Callers are `bsr` at `03FFC2` (store to `BBB9`) and `03FFE0` (compare, then `jsr 0x1BF40`). Both are in heads with 0 refs. |
| `048B84`–`048B85` | 2 | orphan `54 70` | It follows the "LON " string at `048B80`. The string's consumer copies exactly 4 B (`048764 79 04 00 04`, `eepmov.w`). 0 refs. |

**Why the descent saw only a seed.** Each of these is a fnindex-validated start with `nrefs = 0` in
`fnindex\main-*.tsv` (`03C668` shows 1, its own self-loop), or a callee whose only callers are such starts. The skipped
block `0460C2`–`04612F` is in H9's proven mask but is reached by nothing. In context it is a run of field parsers that
the compiled `sub_45FBA` bypasses with `0460C0 bra 0x46130`. Which fields they are is Inferred: the trailing GGA fields.

### SPLIT-TAIL (428 B): H9's split cut a routine whose head is unreferenced

| Run | B | Real head (unproven) | Evidence (Confirmed) |
| --- | ---: | --- | --- |
| `033790` | 20 | `033780 6e 0c 00 19 ac 01 47 1c 6a 0c bc 8d ac 3d 47 12` | The run starts after the not-taken `beq` at `03378E`. The head has 0 refs; `rts 03377E` precedes it. |
| `0337AC` | 20 | `0337A4 6a 0c bc 8d ac 3f 47 12` | Only inbound edge is `033786 beq .+28`, inside dead `033780`. |
| `0337C8` | 20 | `0337C0 6a 0c bc 8d ac 3c 47 12` | 0 refs; `rts 0337BE` precedes. |
| `045D1E` 106 + `045D8E` 8 | 114 | `045D18 68 1b ab 2c 47 6a` (`mov.b @er1,r3l; cmp.b #0x2C; beq 0x45D88`) | Same shape as `0x054AE2`. Head has 0 refs; `rts 045D16` precedes. `045D8E` is the routine's exit block. |
| `046532` 92 + `0465AE` 84 | 176 | multi-entry decimal-digit formatter `046482`–`046601` | Entries `046482/8A/F0/F8/046500/8E/96/9E/A6` are each `6a 18 aa 33 72/70 60; bra`. 0 refs from outside: `046474 blt` is ASCII template bytes, and BE32 `@04F3C5`/`@04F459` straddle `add.l #0x465`. |
| `04A394` | 78 | `04A390 6b 8c a5 58` (`mov.w e4,@0xA558`), which falls through into the run | `rts 04A38E` precedes the head. Head and run both have 0 refs. |

### DATA-MISTYPED (144 B): proven "code" that is a data operand of live code

| Run | B | Data | Reader (Confirmed bytes) |
| --- | ---: | --- | --- |
| `033B70` | 6 | `03 06 0d 10 ff 00`, an FF-terminated byte list | `033B4A 7a 05 00 03 3b 70` → `jsr 0x3F768`, which runs `mov.b @er5+` until `0xFF` (`03F768 6c 5c ac ff`) |
| `03400E` | 4 | `27 29 2a 29`, a lookup table | `034004 7a 05 00 03 40 0e`; `bsr 0x34022` = `and.l #0xff,er3; add.l er3,er5; mov.b @er5,r3l` |
| `03531E` | 16 | `05000000 13700000 22200000 42000000`, packed-BCD band bases (50/137/222/420 MHz) | `mov.l #0x3531E/22/26/2A,er6` at `0352EC/CE/B0/8C` → BCD subtract `0x3F94C` (`6f 64 00 02 … 1f 0b`) |
| `035422` | 16 | byte tables | `0353D0 78 20 6a 25 00 03 54 22` = `mov.b @(0x35422:32,er2),r5h` (and the `/26/2A/2E` siblings) |
| `03799E` 74 + `037A02` 18 | 92 | inside BCD range table `037988` {stride 8, count 17, (lo,hi)×17}, `14050000`…`46260000` | `03793E 7a 06 00 03 79 88` → `jsr 0x3F5B2` (`6d 62 6d 63 01 00 69 64`) |
| `04C3C8` | 10 | `02 03 04 ff 05 06 07 08 09 ff` | It follows the 17×9-B APRS device-name table `04C32C` (reader `04C2A8`). It decodes as `orc #0xff,ccr`/`ldc #8,ccr` with no `rts`. 0 refs; IDA's `04C364 blt` is the ASCII "Mc". The reader of the `04C3C7` byte list is Unknown. |

The many BE32 `00037a0x` hits (for example `@00EAEC`, `@009818`) all straddle unrelated instructions and are not
references. All are listed in `refs-detail.tsv`.

### Measured loss (`measure.txt`)

| Variant | Lost B | In my runs | Spillover |
| --- | ---: | ---: | --- |
| A: drop the 45 seeds in the 31 runs | 2,760 | 2,508 / 2,532 | `077CC2` 168, `07778C` 84 (fnindex-only callees of `0337xx`) |
| B: A + `022DF0` seeds (`022DF0`, `022E3A`) | 2,898 | 2,532 / 2,532 | as A, + `022DF0` 114 |

**Proposed demotions** (`proposed-demotions.tsv`): the 31 runs, 2,532 B, byte sum 160,167. The file also lists two
**ADJACENT** proven-but-unreached ranges in the same dead routines: `045D88`–`045D8D` 6 B (`0b 01 fc 00 40 06`) and
`0460C2`–`04612F` 110 B. Their sum is 116 B, and they belong in the same proposal. Lane range total of such
proven-unreached bytes, all classes: 504 B in 18 spans, not otherwise examined.

## USB relevance

None. No run touches USB `0xFFEE00`–`0xFFEE53`, SCI-C `0xFFFF88` (DSP), SCI `0xFFF610`/`0xFFFF60`, DMAC or the closed
window.
- The only real I/O is `03C668`'s I2C bit-bang on `0xFFFBA0`/`A4`/`A8` (EEPROM).
- `FFFF20`/`29`/`41`/`53` "hits" come from data decoded as `@aa:8`.
- The NMEA parsers are GPS text handling and dead.

Mission answers are unchanged.

## Open

1. **Next seed.** Apply −2,532 B (the 31 runs) together with K1's −278 B. Have the `0x05`–`0x07` lane confirm the
   252 B spillover in `077CC2`/`07778C`. Have the low lane confirm `022DF0` (114 B, dead chain via `022DDE`).
2. Retype the 7 DATA-MISTYPED runs as data (`033B70`, `03400E`, `03531E`, `035422`, `037988` table, `04C3C7` list).
3. Demote the 116 B ADJACENT bytes. Then audit the other 388 B of proven-unreached bytes in `0x030000`–`0x04FFFF`
   (`0348EC` 42, `03D0EE` 98, `04F87C` 48, `04F8DA` 44, …) by the same method.

### Files

| File | Content |
| --- | --- |
| `ida\out\fnindex-mid\runs.tsv` | 31 runs: class, units checked, reached-code inbound edges, evidence |
| `ida\out\fnindex-mid\proposed-demotions.tsv` | exact ranges, proven/named counts, byte sums, sha256; ADJACENT rows |
| `ida\out\fnindex-mid\refs-detail.tsv` | every whole-image inbound row per run and per routine unit |
| `ida\out\fnindex-mid\measure.txt` | leave-out measurements A/B |
| `ida\out\fnindex-mid\offline\l3_*.py` | edges, refs scanner, disassembler, classifier (read-only) |
| `ida\out\fnindex-mid\work\` | descent pickles, per-run leave-out log, IDA head/xref/context dumps |
| `ida\jobs\l3_fnidx_xrefs.py` | read-only IDA job (DB `L3_FNIDX_MID`) |

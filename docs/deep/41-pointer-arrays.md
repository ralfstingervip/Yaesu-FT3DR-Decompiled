# 41 — MAIN pointer arrays outside the 149 tables, and the 194 residual functions (Lane H3)

Owner-side static analysis of firmware already on disk. No device, USB, serial or
flash access. Nothing was written to a radio, and no image byte was modified. MAIN
is H8SX (decoded by IDA as `h8s300a`), big-endian, base 0, so file offset equals
mapped address. Content ends below `0x07B754`. The closed window
`0x078106`–`0x07B753` was not analysed. Model: **claude-opus-5-5**.

Tables are in `ida\out\ptr-arrays\`:

- `arrays.tsv`: 198 candidate arrays plus the known `0x012268` row, with tier, referencing instruction and targets.
- `xrefs.tsv`: 1,331 slot→target rows. It has the same format as G2's `table-xrefs.tsv`, plus `tier`.
- `refsites.tsv`: 280 H8SX indexed-load sites.
- `residual-retest.tsv`: 194 rows.
- `g2only_*` and `g2h3_*`: survival rows and residual state after re-analysis.
- `query_*.txt`: disassembly evidence.
- `state\seed_*`: the seed DB's functions, per-byte item class and immediates.

Jobs:

- `ida\jobs\h3_apply_ptr_xrefs.py`: the reusable apply and survival job.
- `h3_scan_ptr_arrays.py`: the offline scanner, plain Python.
- `h3_dump_state.py` and `h3_query.py`: read-only dumps.
- `h3_residual_retest.py`: plain Python.

## Verdict

**MAIN has 119 code-pointer arrays outside the 149 known tables (1,430 slots, 791 distinct targets).** IDA never linked them for one reason. **73 of them are read by the H8SX indexed load `78 b0 6b 26 <base32>` followed immediately by `jmp @er6` (`59 60`) or `jsr @er6` (`5d 60`).** IDA's `h8s300a` module cannot decode that instruction and prints it as `.long 0x78B06B26, <base>`, so no reference to the table ever existed.

I emitted the 1,331 slot→target xrefs on top of G2's 4,194 and re-analysed a fresh copy. **Survival of F1's 444 proved functions rose from 261/444 to 323/444** (function at the proved start with an incoming xref). That beats the 149-table ceiling of 257 and slightly exceeds the new exact-start ceiling of 320. A fresh G2-only control run reproduces 261 exactly.

Measured at the point the pointer actually reaches, survival is **352/444**. Of the 92 that remain:

- **71 are F1 boundary errors.** The cited table entry lands inside the F1 "function", usually 2 bytes in, so the F1 start sits mid-instruction.
- **21 rest on single BE24/BE32 hits that I cannot reproduce as pointers.** At least 6 of those hits are text or bitmap data.

Against the 194 residual functions, **13 now contain a pointer-array entry point.** They yield **608 B of new proven code that does not overlap `proved.tsv`**. 38 B of that is already credited by G1's `absorbed.tsv`, so **570 B is new to the headline**.

A further 8 functions (468 B) are exact array targets. Each falls through into an IDA function, so they are reached but not counted. The rest are unchanged:

| Category | Functions | Bytes |
| --- | ---: | ---: |
| Over-split continuations | 120 | 6,826 |
| Standalone routines with no pointer anywhere | 40 | 1,702 |
| 1–2-instruction stubs | 9 | 26 |
| Closed-window | 4 | 98 |

## Method

1. **Seed state.** `h3_dump_state.py` ran on DB `H3_PTRS`, seeded by `run_job.py --copy-from ida\db\jobs\FIN_MAIN_IND\FIN_MAIN_IND.i64`. It dumped the 3,899 functions, a per-byte item class for `0x0`–`0x7B754`, and every instruction operand in the content range. No shared DB and no other lane's DB was opened.

2. **Offline scan** (`h3_scan_ptr_arrays.py`). I read every even offset of the image as BE32. A value counts as a candidate when it is even and lies in `[0x400, 0x7B754)`, and it is either a function start (seed, `proved.tsv` or `residual.tsv`), the sentinel `0x3FFA0`, or a decoded code head. That gave 10,156 slots. Slots inside the 149 tables in `main-full\jumptables.tsv` were excluded.

   **Referencing instructions** were found by raw byte pattern, on even addresses:
   - `78 [1sss]0 6B 2d d32`: the H8SX `MOV.L @(d:32,ERs),ERd`. There are 280 sites. In 173 of them the next word is `59 d0` (`jmp`) or `5D d0` (`jsr`).
   - `7A 0d imm32` (`mov.l #imm`).
   - `01 00 6B 2d abs32`.

   **Tiers:**
   - **A, dispatch-proven.** The base is a `ldx_d32` + `jmp/jsr` operand. Slots are read while the value is 0 (a null handler in a sparse table) or an even in-range pointer that is a code head, a function start, or within 4 KB of the table. Reading stops at the first target above the base (the code that follows an inline table), at the next known table or dispatch base, and at trailing far, weak entries. In this way `0x0629D2[5]` = `00FF00` was dropped.
   - **B.** A stride-4 run of at least 2 slots, referenced by a `mov.l #imm32`, a non-dispatch `ldx_d32` or an `abs32` operand in `[base−0x10, end)`. The slots must not overlap decoded code. More than half the targets must be "strong", meaning a function start or a code head that follows `rts`, `rte`, `bra`, `jmp` or `0000`.
   - **C.** An unreferenced run with no code bytes and all targets strong.
   - **X.** Rejected: code bytes read as a pointer pair, numeric records such as `010500/000540`, or slots inside the closed window.

3. **Apply and survival** (`h3_apply_ptr_xrefs.py`, `H3_MODE=survival`). Two fresh copies of `FIN_MAIN_IND` were used:
   - `H3_G2ONLY` applied G2's `table-xrefs.tsv` only, as the control.
   - `H3_PTRS` applied G2 plus H3 `xrefs.tsv` (tiers A, B and C).

   Each slot becomes a dword with an `REF_OFF32` operand, plus a user `dr_O` xref. The target is made code and a function. Then `plan_and_wait(0x400, 0x7B754)` and `auto_wait()` run. Two measures are recorded:
   - **strict** (G2's measure): a function at the `proved.tsv` start with any incoming xref;
   - **corrected**: the same test at the address F1 itself cites as the reach point (`inside->X`).

4. **Residual re-test** (`h3_residual_retest.py`). For each of the 194 rows I checked whether an H3 slot targets the row's start (exact) or a point inside it. Every hit was read in the post-analysis DB (`query_cand.txt`, `query_helper*.txt`), and new bytes were counted only for the code from the array-cited entry up to its `rts`, `rte` or tail branch. Overlap was checked against `proved.tsv` (0 B) and G1 `absorbed.tsv` (38 B).

**Not done:**

- `jmp @ERn` targets computed at run time with no static base.
- BE24 and odd-address hits (F1's mechanism) were not emitted.
- The closed window `0x078106`–`0x07B753` was only noted. Two candidate pairs sit there (`0x07B4DE`, `0x07B4E8`, slots in the window). F1's BE24 proof of `0x023602` is a value at `0x078570`, inside the window.

## Findings

### 1. The arrays (Confirmed bytes; `arrays.tsv`)

| Tier | Arrays | Slots | Xref rows (sentinel and nulls dropped) |
| --- | ---: | ---: | ---: |
| A: `ldx_d32` + `jmp/jsr @er6` | 73 | 1,183 | 1,125 |
| B: `mov.l #base` / load / abs | 36 | 210 | 174 |
| C: unreferenced, all strong | 10 | 37 | 32 |
| X: rejected | 78 | 182 | — |

**The "known pointer array" `0x012268`–`0x0148A0` is already one of the 149 tables.** It has 2,446 entries, which is exactly `(0x0148A0 − 0x012268) / 4`. Its first entry is `0x012268` = `00 01 5e d0`; its last is `0x01489C` = `00 03 ff a0`; `0x0148A0` = `ab 4d 46 0a` is code. G2 already emitted its xrefs, so H3 adds nothing there. It is recorded as row `KNOWN149`.

**The slot at `0x009196` belongs to an 8-entry switch table at `0x00917E`.** Dispatch at `0x009174` = `78 b0 6b 26 00 00 91 7e 59 60`. The table bytes are `0000919e 0000d91a 0000d9d2 0000db58 0000db5e 0000db88 0000d910 0000d9c8`, so `0x009196` is index 6 = `sub_D910` (F401). Entry 0 = `0x00919E` is the code that follows the table.

All A sites share one compiler idiom: `and.l #0xFF,er3` (`7a 63 00 00 00 ff`), `shll.l #2,er3` (`10 73`), `78 b0 6b 26 <base>`, then `59 60` or `5d 60`. Examples, all Confirmed:

| Base | Entries | Site bytes | Note |
| --- | ---: | --- | --- |
| `0x05A3CE` | 44 | `0x05A3B8` `78 b0 6b 26 00 05 a3 ce 5d 60` | targets `058f86 05905e 059240 …` |
| `0x074472` | 48 | `0x073A34` `… 00 07 44 72 5d 60` | entry 1 = `00002070`, so F1's `sub_2070` is now really reached |
| `0x061C5A` | 59 | `0x061C30` `… 00 06 1c 5a 59 60` | |
| `0x0704A2` | 25, sparse | `0x0703B8` `… 00 07 04 a2 59 60` | Loader `0x07039A` = `10 74 78 c0 6b 24 00 07 04 a2` then `beq`. Nulls mean no handler; live entries 11–13 = `06f2ba 06f2f6 06f31c` and 20–23 = `06f190 06f1ac 06f1e8 06f20e`. |
| `0x018B82` | 11 | `0x018AEC` | Targets `0x018AF6`–`0x018B76` were never decoded by IDA. |

Tier B arrays are passed in a register to call-through helpers. Each helper loads the pointer and calls it:

- `sub_15260`: `01 00 69 56` `mov.l @er5,er6`, then `5d 60` at `0x015292`.
- `sub_285AA`, `sub_285CE`, `sub_286A6`: `01 00 69 66` `mov.l @er6,er6`, then `5d 60`.
- `sub_53384`: `jsr @er5` at `0x0533C6`.

For example, `0x0174D0` = `7a 05 00 01 74 da 5a 01 52 60` is `mov.l #0x174DA,er5` then `jmp sub_15260`. All Confirmed.

The rejected class includes numeric arrays that pass a naive scan:

- `0x00F8FA`–`0x00F94E` `010500/000540` pairs;
- `0x0255D6` `00FF00…`;
- `0x040EC2`–`0x0414D6` `(00xxxx, 000x04)` pairs;
- ten code-overlap pairs at `0x0755E6`–`0x075D5E`.

### 2. Survival (`g2only_apply_log.txt`, `g2h3_apply_log.txt`)

| Run (fresh `FIN_MAIN_IND` copy) | xrefs applied | funcs made | function at proved start | strict | corrected |
| --- | ---: | ---: | ---: | ---: | ---: |
| `H3_G2ONLY` (control) | 4,194 | 943 | 416 | **261 / 444** | 280 / 444 |
| `H3_PTRS` (G2 + H3) | 4,194 + 1,331 | 943 + 333 | 402 | **323 / 444** | **352 / 444** |

The exact-start ceiling (proved starts that are an emitted target) is 257 for G2 and 320 for G2 + H3. That is +63 from H3.

"Function at proved start" falls from 416 to 402, and this is expected. When the true entry 2 bytes later gets a xref, IDA dissolves the bogus F1 start. Examples: `0x0174E8`→`0x0174EA`, `0x02ACA8`→`0x02ACBC`, `0x04BA2C`→`0x04BA32`.

The remaining 92 losses on the corrected measure:

- **71: the reach point is an interior case label.** The table entry lands inside what F1 called a function, so IDA correctly keeps it as a label. These are F1 boundary errors of the same kind G1 found 4 of. Examples: `0x015F02` cites `0x015F04`; `0x005798` cites `0x0057A8` in the `0x007814` switch.
- **11 (556 B): F1 proofs by a BE24 value at an odd address.** Examples: `0x032E8E` ← `0x030D8D`, `0x038104` ← `0x042F0E`, `0x023602` ← `0x078570` (closed window). H8S code loads 32-bit pointers from even addresses, so these are not a pointer mechanism. **Inferred: unsupported.**
- **10: F1 single BE32 hits.**
  - **Data, Confirmed by bytes (158 B):**
    - `0x042932` `00001fe0` sits in a bitmap run (`0c46 0c46 07fc | 00001fe0 | 1024 178c`).
    - `0x008250` `00002020` is ASCII spaces.
    - `0x003C4A` `00005050` is in a byte table.
    - `0x0400FA` `0004aaaa` is in ASCII `#50\F06I5&`.
    - `0x005608` `00046b84` straddles `79 04 00 04` and `6b 84 b0 70`.
    - `0x004AA6` `00034644` sits among odd values `00024643 00024654`.
  - **Genuine code pointers (Confirmed):**
    - `0x0060C0` is the immediate of `0x0060BE` `7a 06 00 00 61 7c` (`mov.l #0x617C,er6`), stored by `01 00 6b 86 b2 88` to RAM `0xFFB288`. `0x053692` `01 00 6b 06 b2 88 59 60` then jumps through that RAM cell, so `sub_617C` is a real callback.
    - `0x04765E` is the immediate of `mov.l #0x6E9A,er1` (Inferred pointer).
  - **Unknown:** `0x037E98` and `0x001634`.

### 3. The 194 residual functions (`residual-retest.tsv`)

**PROVEN-PTR, 13 rows. 608 B new versus `proved.tsv`, 570 B net of G1.** Every F1 start except two is 2 bytes early: its first 2 bytes are the tail of the preceding instruction, so the start is mid-instruction. The true entry is the array target. All of these are Confirmed from disassembly in the post-analysis DB.

| F1 row | True code (B) | Ends | Array entry (slot = bytes) |
| --- | --- | --- | --- |
| `0x009188` | `0x00919E`–`0x009246` (168) | `rts` `0x009244` | `0x00917E[0]` = `0000919e`. The first 22 B of the F1 row are table slots. |
| `0x00DB48` | `0x00DB58`–`0x00DB5E` (6) | `rts` | `0x00917E[3]` @`0x00918A` = `0000db58`. The prefix is ASCII `-------\0`. |
| `0x01026C` | `0x01026E`–`0x010276` (8) | `rts` | `0x010242[7]` @`0x01025E` = `0001026e` |
| `0x0174E8` | `0x0174EA`–`0x01750A` (32) | `rts` `0x017508` | B `0x0174DA[1..3]` = `000174ea 000174f6 00017502`, via `sub_15260` |
| `0x01EEC8` | `0x01EED0`–`0x01EEF6` (38) | five 8-B stubs, each `bra 0x01EEF6` | `0x01EABE[7..11]` = `0001eed0 …eef0`. G1 already credits this range. |
| `0x0237A8` | `0x0237AA`–`0x023812` (104) | `rts` `0x023810` | `0x023792[1]`, `[3]` = `000237aa`. The prefix `ff a0` is the tail of `jsr @0x3FFA0`. |
| `0x034530` | `0x034532`–`0x034534` (2) | `rts` | `0x0340DE[3]` @`0x0340EA` = `00034532` |
| `0x035090` | `0x035092`–`0x0350C0` (46) | `rts` `0x0350BE` | `0x035086[0]` = `00035092` |
| `0x053684` | `0x053686`–`0x05369A` (20) | `jmp @er6` `0x053698` | B `0x05365E[5]` @`0x053672` = `00053686`, via `sub_53384` |
| `0x05B3AC` | `0x05B3AE`–`0x05B3C8` (26) | `rts` | `0x05B39E[0]` = `0005b3ae` |
| `0x05C434` | `0x05C436`–`0x05C44C` (22) | `bra 0x05C45C` (shared exit) | `0x05C40A[4]` @`0x05C41A` = `0005c436` |
| `0x063F48` | `0x063F4A`–`0x063F84` (58), three handlers | `rts` `0x063F4A`; `bra 0x064230` twice | `0x05FEA2[12..15]`, `0x063E36[7]` = `00063f4c`, `[50]` = `00063f76` |
| `0x073170` | `0x073172`–`0x0731C0` (78) | `rts` `0x0731BE` | `0x073162[1]` @`0x073166` = `00073172` |

The other 181 rows:

- **REACHED-OVERSPLIT, 8 rows, 468 B.** Each is an exact A-array target with no return inside F1's extent, and each falls into an IDA function. They are reached, but under F1's rule they are not independent routines, so they are not counted:
  - `0x010556` ← `0x010242[9]`, falls into `0x01058A`
  - `0x033180` ← `0x03308E[0]`
  - `0x033448` ← `[4]`
  - `0x04723C` ← `0x047316[2]`, falls into `nullsub` `0x047314` = `54 70`
  - `0x067370` ← `0x061C5A[23]`
  - `0x06B2C2` ← `0x06B556[4]`
  - `0x06FDC2` ← `0x06FDAA[0]`
  - `0x073C66` ← `0x074472[7]`

  With G1's "falls into the next function" rule these 468 B would count.
- **OVERSPLIT, 120 rows, 6,826 B.** These keep F1's reasons: fall-through continuations, switch fragments, over-split tails, and table-reached rows that fall through. In the G2 + H3 DB, 17 residual starts are no longer functions after re-analysis, because IDA re-split or dissolved them.
- **UNPROVEN-STANDALONE, 40 rows, 1,702 B.** These are self-contained, with no slot in the 149 tables or in any A, B or C array, and no direct caller (G2). **Not found, in this scope:** every even BE32 in `0x0`–`0x7B754`, every `ldx_d32`, `mov.l #imm32` and `abs32` operand, and the 149 tables.
- **JUNK-STUB, 9 rows, 26 B.** 1–2-instruction stubs.
- **CLOSED, 4 rows, 98 B.** Untouched.

**Proven-byte delta: +608 B new versus `proved.tsv` (0 B overlap). The net headline delta is +570 B after removing G1's 38 B (`0x01EED0`–`0x01EEF6` inside G1's `0x01EEBA`–`0x01EF08`).**

**Correction candidates for `proved.tsv` (not applied, rules):**

- **Start corrections.** 14 F1 starts are dissolved by IDA once the true entry has a xref. 71 cite an interior target.
- **Proofs to drop or re-prove.**
  - 556 B rest on BE24 odd-address hits.
  - 158 B rest on BE32 hits inside text or bitmap data: `0x001FE0`, `0x002020`, `0x005050`, `0x034644`, `0x046B84`, `0x04AAAA`.

  They may still be reachable some other way. That is **Unknown**.

## USB relevance

This lane is mostly bookkeeping, but it touches the MAIN USB stack.

**`0x055002` is a 12-entry state-machine dispatch.** The site is `0x054FEC` `6a 0b 81 83` (`mov.b @0xFF8183,r3l`), then `0x054FF8` `78 b0 6b 26 00 05 50 02 59 60`. It sits directly after the `rte` (`0x054FEA` `56 70`) of the code that begins at the vector-235 handler `0x054EC2`. Inferred: this is the USB control-transfer state machine, indexed by state byte `0xFF8183`.

**`0x056B8A` is a 28-entry dispatch indexed by `0xFFB102`.** The site is `0x056B58` `6a 0b b1 02` … `0x056B64` `78 b0 6b 26 00 05 6b 8a 59 60`. Its targets `0x056EE4`–`0x058C06` lie in the USB-stack support runs from doc 22.

`0x055BF2`, `0x055C06` and `0x055C12` (5, 3 and 3 entries, index `0xFFBC50`) sit beside the vendor descriptor at `0x055818`. `0x05584A` is rejected: it holds pointers to 32-byte records at `0x05585E` and onward, which are data, not code.

These tables explain why parts of the USB stack looked unreferenced. They add no new USB capability: no new endpoint, descriptor, bulk or isochronous path appeared, and **no array target lands in the closed CDC-ACM / DSP-download window.** For the SDR and DSP questions this changes nothing.

## Open

1. **Apply the boundary corrections to `proved.tsv`.**
   - Move the 13 + 14 two-byte-early starts to their array-cited entries.
   - Re-prove or drop the 714 B resting on BE24 and data-embedded BE32 hits.
   - Merge the 71 interior-target rows into their parent functions.

   Together these make strict survival meaningful; it is currently capped by F1's own starts.
2. **Rebuild the MAIN seed DB as `h8sxa`.** Then IDA decodes `78 b0 6b 26` itself and could resolve these switches natively. Re-run `h3_apply_ptr_xrefs.py` on that DB to compare.
3. **Decode the USB dispatches.**
   - `0x055002`: 12 states on `0xFF8183`.
   - `0x056B8A`: 28 states on `0xFFB102`.

   They are the control-request and state handling of the vendor-class stack. Naming each state is the next USB step that stays outside the closed window.
4. **The 40 standalone routines (1,702 B) remain without any static reference** in every scope tested. Next tests: an `h8sxa` caller scan, and RAM callback cells written with `mov.l #imm32` and then `jmp @ERn`, as in the `0xFFB288` pattern above.

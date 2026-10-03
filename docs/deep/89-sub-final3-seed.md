# SUB_FINAL3: J10's 31 merges applied, 125 dead functions marked, byte-neutral (Lane K7)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian, mapped at
`0xFFC00000`, file offset = address − `0xFFC00000`). The private DB is
`ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64`, seeded with `--copy-from
ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64`. Model: **claude-opus-5-5**.

Hashes before and after the run:

- The SUB_FINAL2 seed is `933f1ded…`, the same value as I17's hand-off.
- SUB sha256 is `b93570b3…` and MAIN sha256 is `8e3ecd05…`. Both are unchanged.

No other DB was opened, no image byte was modified, and nothing was written to a radio or any device.

Tables are in `ida\out\sub-final3\` and listed under Files.

## Verdict

**K7_SUB_FINAL3 is the new SUB seed.** It is SUB_FINAL2 with J10's frozen plan (doc 78) applied, and the apply changed **0 bytes**:

- **31 merges.** All 31 continuations were merged into their J10 roots, with 0 owner mismatches. All 43 J10 edges were re-verified in the DB before merging, with 0 FAIL.
- **125 dead functions marked.** The 125 dead chain heads are now named `dead_XXXXXXXX` and carry a repeatable function comment. No code byte was removed.
- **Function count.** It falls from 2,426 to **2,395**. Every dead function is now one contiguous chunk.

**Byte-neutrality is Confirmed.** The before and after masks are identical to I17's masks byte for byte, so each of the five ledger masks is **+0/−0**:

| Mask | Before | After |
| --- | --- | --- |
| Headline | 464,165 | 464,165 |
| **Headline + w2 (the SUB window code figure)** | **464,263** | **464,263** |
| Reach-only | 454,692 | 454,692 |
| Reach-only + w2 | 457,462 | 457,462 |
| All-well-formed | 467,999 | 467,999 |

The other checks also hold:

- **Code+typed** is **520,552** before and after.
- **Fixed point.** Pass 1 made all the changes. Passes 2 and 3 changed 0 items, functions, names and comments, and the layout hash stayed `9864126aca9eb476` through both.
- **Sanity.** There are **0 mid-instruction edges** and **40/40 switch tables**. The 172,723 code heads equal I2's `target-heads.tsv` exactly.
- **USB regression check.** No instruction anywhere in the image references USB0, USBA or the FCU/flash window.

**Two corrections to doc 78:**

1. **The residue is 10,670 B, not 10,059 B.** J10 sized each function as `end − start`, which leaves out three tail chunks, 611 B in all. The merged continuations therefore total 2,890 B, not 2,279 B.
2. **`FFF2A70B` is a separate subroutine, not a continuation.** It was merged as instructed, and the merge is flagged in Open.

## Method

All IDA work ran through `run_job.py` on `K7_SUB_FINAL3`. Every job calls `auto_wait`, writes UTF-8, wraps its body in try/except with the traceback written to a status file, and ends with `qexit(0)`.

| Step | Job | Result |
| --- | --- | --- |
| 1 | `k7_recount.py`, `--copy-from` SUB_FINAL2, `K7_PHASE=before` | baseline, written to `raw\before\` |
| 2 | **`k7_apply_sub_final3.py`**, `K7_PASS=1` | merges, renames, comments, `plan_range` and `auto_wait`, then measures the pass |
| 3 | `k7_apply_sub_final3.py`, `K7_PASS=2` | fixed-point check |
| 4 | `k7_recount.py`, `K7_PHASE=after` | counts, five masks, sanity, ledger |
| 5 | `k7_usbscan.py` (read-only) | whole-image USB/FCU scan |
| 6 | `k7_apply_sub_final3.py`, `K7_PASS=3` | fixed-point check after the read-only reopens |

**`k7_apply_sub_final3.py`.** The job is idempotent and takes its input only from `ida\out\sub-merge\disposition.tsv`. It asserts that the plan contains 31 merge-into rows, 125 dead rows and 0 other rows.

- **Step 0: re-verify each J10 edge in this DB.** Each edge kind has its own test:
  - flow: `prev_head(dst) == src`, the source is code, it is not `CF_STOP`, and `src + size == dst`
  - jump: an `fl_JF`/`fl_JN` xref
  - call: an `fl_CF`/`fl_CN` xref
- **Step 1: merges.** These use I17's mechanics: `del_func`, then each chunk either extends the root's adjacent chunk or is appended as a tail. Each continuation is merged only after all its edge sources already sit inside the root.
  - Every old start gets the repeatable comment `K7: was sub_X (J10 merge-into sub_Y, <edge kinds>)`.
  - The job then checks that `get_func(old).start_ea` equals the root.
- **Step 2: dead heads.** Each `sub_X` default name is renamed to `dead_X`, and each function gets a repeatable function comment.
  - The comment reads `K7/J10: DEAD - no flow, branch, switch, call, data, pointer, imm or vector edge enters this function from outside its chunks … Was sub_X.`
  - The job then re-checks every head of every chunk for an inbound flow edge from a non-stop predecessor, any xref other than ordinary flow, or membership in any of the 288 INTB+EXTB slots.
- **Step 3: measure.** `plan_range` and `auto_wait` run over `FFECE4E4`–`FFF50A00`. The job then diffs a before and after snapshot of items, function chunks, names, function comments, address comments and a layout hash.

**`k7_recount.py`.** This is `i17_recount.py` with only its outputs redirected. The counting rules are unchanged, and the ledger is taken against `ida\out\sub-final2\raw\mask_final2_*.bin`.

**`k7_usbscan.py`.** The scan has three scopes:

- **A.** Every operand of every code head in every DB segment: 172,739 heads and 312,465 operands. It tests `o_imm` values, `o_displ` `op.value`, `o_mem` addresses and `o_near`/`o_far` addresses.
- **B.** Every byte offset of the 4,194,304-B image decoded as `MOV.L #imm,Rd` (`FB`, li = 32/8/16/24-bit, sign-extended), regardless of DB state: 14,968 patterns.
- **C.** Every 4-byte-aligned LE32 value in the image.

The regions tested are:

- USB0 `000A0000`–`000A0400`
- USBA `000D0000`–`000D1000`, which covers the RX64M USBA block at `D0400`
- FCU/FACI and flash P/E `007E0000`–`00800000`

**Not done.**

- No function purposes were assigned.
- The disposition of J10's 156 was not re-derived. Its edges were re-verified in this DB, and the 125 heads were re-checked for inbound edges.
- MAIN was not touched.
- The scan does not test the USB0 bit in `MSTPCRB`. Earlier lanes settled that, and it is outside a regression check of references.

## Findings

### 1. The 31 merges (Confirmed; `merges.tsv`, `raw\apply_pass1_changes.tsv`)

| Edge kind | Merges | Bytes (J10 main chunk) | Bytes (all chunks) |
| --- | --- | --- | --- |
| flow | 20 | 644 | 644 |
| flow + jump | 7 | 731 | 731 |
| jump | 3 | 532 | **1,143** |
| call from a dead caller | 1 | 372 | 372 |
| **total** | **31** | **2,279** | **2,890** |

**Apply pass 1:**

- 31 `del_func` calls
- 34 chunk extensions
- **0 appended tails**: every chunk was adjacent to its root, so each of the 15 owners grew into one contiguous chunk
- 31 address comments
- 0 owner mismatches

The 15 owners are `FFEF05DD`, `FFEF13A1`, `FFF12437`, `FFF13DDA`, `FFF1E789`, `FFF1EBC3`, `FFF1ED7B`, `FFF2A6D1`, `FFF2ED6E`, `FFF301DD`, `FFF30B28`, `FFF3202F`, `FFF3753A`, `FFF3887C` and `FFF3B8CB`.

Cited bytes, read from the image:

- `FFF13DEC 3e 01 00` (not a stop) falls into `FFF13DEF`. `FFF13EE8 2a 19` bgt.b falls through into `FFF13EEA`. `FFF13EFF 2e 17` bra.b leaves.
  - The result is `dead_FFF13DDA`, `FFF13DDA`–`FFF13F01`, as one chunk.
  - `FFF13F01` is I17's reachable shared tail and stays its own function.
- `FFEF05E9 2e 53` bra.b `FFEF063C` is the jump into the `FFEF0609` chunk. The result is `dead_FFEF05DD`, `FFEF05DD`–`FFEF0648`.
- `FFF12447 5d 0f 03` falls into `FFF1244A`, and the following 8 prologues chain the same way. The result is `dead_FFF12437`, `FFF12437`–`FFF12565`, 302 B.
- `FFF3753A fb ee 12 38 08` mov.l #83812h,r14 is the first of the 9-stub register-poke routine. The result is `dead_FFF3753A`, `FFF3753A`–`FFF3758F`, 85 B.

### 2. Correction to doc 78: three tail chunks, 611 B (Confirmed)

Doc 78 reported the residue as 10,059 B; it is 10,670 B. J10's `size` column is `end − start` of each function's entry chunk. SUB_FINAL2's own `functions.tsv` gives the chunk sum, and over the 156 functions that sum is **10,670 B**. The three jump-merged continuations each had a second chunk:

| Continuation | Missed tail | Bytes |
| --- | --- | --- |
| `FFEF0609` | `FFEF05EB`–`FFEF0609` | 30 |
| `FFF1EA05` | `FFF1E7C6`–`FFF1EA05` | 575 |
| `FFF1EDBC` | `FFF1EDB6`–`FFF1EDBC` | 6 |

After the merge, those tails sit contiguously inside their owners. The corrected figures are:

- **125 dead heads (J10's 7,780 B) + 31 merged continuations (2,890 B) = 10,670 B**, all in the 125 `dead_` functions
- `dead.tsv` totals 10,670 B, and every one of the 125 functions is single-chunk

This changes no headline, because all five masks are unchanged.

### 3. The 125 dead functions (Confirmed; `dead.tsv`, `alias-final3.tsv`)

- **Renames.** All 125 had default `sub_` names. Each was renamed to `dead_XXXXXXXX` and given the repeatable function comment above.
- **No inbound edges.** The post-merge re-check finds **0** inbound edges for all 125. The test covers flow from a non-stop predecessor, every xref type, and all 288 vectors.
- **Recount class.** The recount still classes **59 of them (4,813 B) as credited-unreached** under the carried-forward H8/H10 byte-credit standard, and **66 (5,857 B) as dead**. The 59 are J10's former credited-unreached heads plus their merged members.
  - The `dead_` name records J10's **reachability** verdict, not removal from the headline.
  - Doc 78 Open 1 explains the two standards; do not mix them.
- **Function classes.** Before the merges there were 2,269 reachable, 89 credited-unreached, 67 dead and 1 outside the window. After, there are 2,269 reachable, 59 credited-unreached, 66 dead and 1 outside the window.

### 4. Byte-neutrality and sanity (Confirmed; `counts-before-after.tsv`, `ledger-delta.tsv`, `sanity.txt`)

| Figure | SUB_FINAL2 | Before | After | Δ |
| --- | --- | --- | --- | --- |
| mask 1, headline | 464,165 | 464,165 | 464,165 | 0 |
| **mask 2, headline + w2 (SUB window code)** | **464,263** | 464,263 | 464,263 | **0** |
| mask 3, reach-only | 454,692 | 454,692 | 454,692 | 0 |
| mask 4, reach-only + w2 | 457,462 | 457,462 | 457,462 | 0 |
| mask 5, all-well-formed | 467,999 | 467,999 | 467,999 | 0 |
| **code+typed (headline + w2)** | **520,552** | 520,552 | 520,552 | **0** |
| DB code bytes in window / unexplored | 468,012 / 0 | same | same | 0 |
| code heads (= I2 `target-heads`, extra/missing 0/0) | 172,723 | same | same | 0 |
| mid-instruction edges / edges onto non-code | 0 / 0 | 0 / 0 | 0 / 0 | 0 |
| switch tables matching H8 | 40/40 | 40/40 | 40/40 | 0 |
| RX-trap mismatches (imm24 / imm32 / uimm8 / dsp5) | 0/0/0/0 | same | same | 0 |
| functions | 2,426 | 2,426 | 2,395 | −31 |

The mask files `raw\mask_final3_{before,after}_*.bin` are byte-identical to `sub-final2\raw\mask_final2_*.bin` for all five figures. In the apply snapshot over `FFECE4E4`–`FFF50A00`, code bytes are 470,305 and data bytes 63,401, both before and after. Passes 1, 2 and 3 each changed 0 items.

### 5. USB regression check (Confirmed for scopes A and B)

| Region | A, instruction operands | B, `FB` MOV.L imm at any offset | C, aligned LE32 values |
| --- | --- | --- | --- |
| USB0 | **0** | **0** | 24 |
| USBA | **0** | **0** | 109 |
| FCU/flash | **0** | **0** | 51 |

The 184 scope-C hits are not references. Every one was classified (`usb-scan.tsv`):

- **6 are `BSR.A` heads.** Opcode `05` is followed by a 24-bit displacement, and the aligned dword reads as `007Fxx05`. Examples:
  - `FFEE7F8C 05 62 7f 00` bsr.a `sub_FFEEFEEE`
  - `FFF26C30 05 fc 7f 00` bsr.a `sub_FFF2EC2C`
- **5 straddle two instructions** (`code@+1`). An example is `FFF4C5E3` bgt.b.
- **100 are u16-pair fields inside typed records.** 15 sit at offset +0 of descriptor records, for example `FFED1F4C 01 00 0a 00` = w 1, h 10. 85 sit at offset +4 of icon records. This is the same class I17 reported.
- **73 are bytes outside the window that the DB has not explored.** They are in `FFC31E40`–`FFC3A438` and `FFEB7568`–`FFEC5DBC`, and none of them is a code head.

**Not found** (scope: every operand of every code head in the whole DB, and every `FB` MOV.L encoding at every byte offset of the 4 MB image): no reference to USB0, USBA or FCU/flash. This repeats J10's result after the apply.

### 6. `FFF2A70B` is a separate callee, not a continuation (Confirmed)

The call-only merge does not fit the continuation pattern:

- `dead_FFF2A6D1` ends with `FFF2A709 67 06`, which is rtsd #6 and matches its `FFF2A6D1 71 00 e8` add #-18h,sp.
- `FFF2A70B 71 00 d8` add #-28h,sp is a **new prologue**.
- `FFF2A6F7 39 14 00` bsr.w calls it.

So it is a separate subroutine with exactly one caller, and that caller is dead. It is not a fall-through continuation.

J10's rule and this task merge it, and IDA kept the merge: pass 1's `plan_range` did not recreate the function, and passes 2 and 3 confirm it. It now sits inside `dead_FFF2A6D1` (`FFF2A6D1`–`FFF2A87F`). The merge is byte-neutral either way. It does mean the owner's body contains a `bsr` to its own interior, which is a modelling oddity rather than a byte change. See Open 1.

## USB relevance

None of the three mission answers changes.

- **USB0, USBA and FCU.** The SUB image still has no instruction reference to USB0, USBA or FCU/flash anywhere in the DB or in any `FB` immediate encoding in the 4 MB image (§5). This regression check holds on the new seed.
- **Dead code.** The 125 `dead_` functions include the only peripheral-adjacent code in the residue. One is `dead_FFEDC455`, which writes `FFEDC459 fb e2 44 2d 01 00` mov.l #12D44h to the SCI0 IPC RAM block. The other is `dead_FFF3753A`, which writes PRCR, DMAC and PORT registers. Both are now explicitly marked dead in the seed.
- **SDR and DSP.** There is still no SUB-side path for either.

## Open

1. **`FFF2A70B` (optional, byte-neutral).** A strict continuation-only seed would split it back out as its own `dead_FFF2A70B` with one chunk, `FFF2A70B`–`FFF2A87F`. It was merged here because the task and J10 call for it. To undo it:
   - Drop that row from the plan.
   - Or run `ida_funcs.remove_func_tail` / `set_func_end(FFF2A6D1, FFF2A70B)` followed by `add_func(FFF2A70B)`.
2. **Doc 78 numbers for the orchestrator:**
   - the residue is 10,670 B, not 10,059 B
   - the merged continuations are 2,890 B, not 2,279 B
   - the 125 dead functions span 10,670 B after the merge
3. **Naming.** The 24-member screen-handler clone family among the 125 could be given purpose names. It is dead code, so this is low priority.

## How to seed from K7_SUB_FINAL3

```text
python "ida/run_job.py" --script ida\jobs\<lane>_x.py --db <YOURDB> --copy-from ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64
```

- **Layout.** The DB has 2,395 functions. Code heads are identical to SUB_FINAL2 and to I2's `target-heads.tsv`. The credited code mask is `ida\out\sub-final3\raw\mask_final3_after_headline_w2.bin`, which is identical to I17's and I2's.
- **Labels.** A doc citation `sub_X` of one of the 31 merged starts appears as `loc_X`, with the comment `K7: was sub_X …`. The 125 dead heads appear as `dead_X`. `alias-final3.tsv` maps all 156, and I17's `sub-final2\alias.tsv` still maps the earlier 1,666.
- **Rebuild.** Run `k7_apply_sub_final3.py --copy-from ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64 --env K7_PASS=1`, then `--reopen --env K7_PASS=2` to confirm 0 changes.
- **Hash.** At hand-off the `.i64` sha256 was `bc2d8537…`. IDA rewrites the file on every reopen, so use content checks (layout hash `9864126aca9eb476`, the masks) as the reference.

## Files (`ida\out\sub-final3\`)

| Path | Contents |
| --- | --- |
| `merges.tsv` | The 31 merges: old name, start and end, J10 bytes and all-chunk bytes, previous reach class, root, edge kinds, per-edge verification, owner now and the old chunk bounds. |
| `dead.tsv` | The 125 dead functions: bounds, chunk count and bounds, new and old name, previous reach class, J10 head bytes, merged members and the inbound-edge re-check (all 0). |
| `alias-final3.tsv` | All 156 rows in `alias.tsv` style: old name, old start, owner now, owner name, decision and reason. |
| `counts-before-after.tsv` | Every figure as published for SUB_FINAL2, before this lane's apply and after it, with the delta. |
| `counts.txt`, `sanity.txt`, `switches.tsv`, `ledger-delta.tsv`, `functions.tsv`, `mask-diff-h10.tsv` | The after recount. The before copies are in `raw\before\`. |
| `usb-scan.tsv` | Scopes A, B and C of the regression scan, with every hit classified. |
| `raw\apply_pass{1,2,3}{.txt,_changes.tsv,_delta.tsv}` | Per-pass logs, actions and deltas. |
| `raw\mask_final3_{before,after}_*.bin` | The five masks. |
| `raw\recount_status_{before,after}.txt`, `raw\usbscan_status.txt` | Run logs. |

The jobs are `ida\jobs\k7_apply_sub_final3.py`, `ida\jobs\k7_recount.py` and `ida\jobs\k7_usbscan.py`.

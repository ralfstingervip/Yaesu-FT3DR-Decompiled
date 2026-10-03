# SUB window: out-of-phase decodes, wave-2 rejects and unreferenced functions (Lane H10)

This lane is owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin`. The image is RX64M, little-endian, mapped at `0xFFC00000`, so file offset = address − `0xFFC00000`.

- **Database:** private DB `H10_SUB`, made with `--copy-from ida\db\jobs\H8_SUBGAP\H8_SUBGAP.i64`.
- **Changes made:** no shared DB was opened, no image was modified, nothing was written to a radio, and the DB itself was not changed (every script is read-only).
- **Model:** claude-opus-5-5.

Tables are in `ida\out\sub-phase\`:

- `conflicts-resolved.tsv`: 82 rows. These are the 63 H8 conflict edges, the 18 H8 "code-conflict" gap runs, and 1 edge found here.
- `orphans.tsv`: the 54 H8 runs that start with a `71 00` prologue.
- `ledger-delta.tsv`
- Raw job outputs and the table builder are in `raw\`.

## Verdict

The 63 H8 phase-conflict edges come down to **53 targets in 6 patterns**:

- In 50 targets, IDA's validated items are out of phase and the linear decode from the incoming edge is right.
- 10 edges are fake: each comes from an out-of-phase item. They hit 4 targets. At 3 of them IDA is right; the fourth, `FFEEC160`, is still a true head through another edge.

Re-seating the decodes replaces **108 out-of-phase IDA heads with 187 true heads**. Of those 108 heads, **34 are lane-4 "function starts" that begin in the middle of an instruction**. These replacements cost **0 bytes**, because every byte involved is code under both decodes. **Confirmed.**

The true decodes do add new code:

- They complete 13 `f8 04 00` fragments (+26 B) and one `f8 06 00` fragment (+3 B).
- They settle H8's 40 B of "code-conflict" bytes as code.
- They expose two real `bsr.w` calls that reach two of H8's 54 unreferenced functions: `FFF3627B` (116 B) and `FFF40314` (21 B).

Removing the 68 wave-2 rejects correctly costs **98 B**. That is 49 two-byte `60 40` slivers that nothing reaches. The other 149 B of reject bytes are reached by flow and stay credited.

The remaining **52 unreferenced functions (3,692 B)** have no reference by any mechanism this firmware uses to obtain a code address. All of them call application UI routines, so they are **dead application code, not library code**.

**Final SUB window code = 464,166 / 524,288 = 88.53 %, a delta of +108 B on H8's 464,058.** Typed data stays at 56,289 B and the unresolved residue is 3,833 B (0.73 %).

The window's "body"-validated code has a second honesty issue. If code is only credited when it is reachable from a call, a vector or a pointer, **9,527 B** of the credited set (8,782 B of it lane-4 "body" functions) has no reference either. **Confirmed** for the functions spot-checked; the numbers come from a closure, so they are Inferred.

## Method

All IDA work ran through `run_job.py` against `H10_SUB`. Each script calls `auto_wait`, writes UTF-8, writes its traceback to a file and ends with `qexit(0)`.

| Script | What it did |
| --- | --- |
| `ida\jobs\h10_conflicts.py` | For each of the 53 unique targets in `sub-gap\raw\conflicts.tsv`, dumped IDA's items around the covering head, a linear `decode_insn` from the target to resync, and the H8 reach chain of each source (`raw\conflict_dump.txt`, `conflict_rows.tsv`). |
| `ida\jobs\h10_query.py` | Spot linear decodes, for the H8 code-conflict runs, the fragments and the brute-force hits (`raw\query.txt`). |
| `ida\jobs\h10_phase.py` | Applied the adjudication. It decoded the true phase from each anchor to resync (`raw\repairs.tsv`), then ran H8's closure twice under identical rules: **BASE** (H8's roots) and **FIX** (out-of-phase heads and wave-2 rejects removed, true heads added, no IDA xrefs taken from out-of-phase heads). It also produced the orphan probe, the census of indirect transfers, the census of code-address stores and arguments, and a closure that uses reachability only (`raw\closure_cmp.txt`, `fix_new.tsv`, `fix_lost.tsv`, `fix_conflicts.tsv`, `rej2.tsv`, `orphan_probe.tsv`, `indirect.tsv`, `ram_cb.tsv`, `reach_only.txt`). |
| `ida\jobs\h10_ramscan.py` | Every code head in `FFC00000`–`FFF50A00` with an immediate or memory operand in RAM `0x12D00`–`0x12E00` (`raw\ramscan.txt`). |
| `raw\h10_build.py` | Plain Python. Builds the three tables. |

Outside IDA I also ran a Python scan of the image (scratchpad, read-only) for every orphan start, with three probes:

- the 3-byte LE prefix (which covers both LE32 and the RX 24-bit sign-extended `mov.l #imm`), at every offset of the whole 4 MB image
- `04`/`05` (`.a`), `38`/`39`/`3A`/`3B` (`.w`), `20`–`2F` (`.b`) and `08`–`1F` (`.s`) branch encodings, at every offset of `0xFFED0000`–`0xFFF509DE`

**Reproduction:** BASE recomputes 464,089 against H8's 464,058. The difference is fully explained:

- +40 B: the "code-conflict" bytes, which H8 deliberately left out
- −9 B: the hand-decoded pair at `FFEDFFFD`, which IDA cannot decode across `0xFFEE0000`

FIX ends with **0 conflicts** (BASE had 63).

**Not done:**

- No instructions or functions were created in the DB.
- Pointer arithmetic on function pointers was not modelled. It is not expressible in C, and the indirect-call census below finds no form that needs it.

## Findings

### 1. The 63 conflicts: which decode is right (`conflicts-resolved.tsv`)

| Cluster | Targets / edges | Pattern (true decode vs IDA) | Verdict |
| --- | --- | --- | --- |
| **C**: `sub_FFEEC0D3` case block | 14 / 16 | `bra.l r14` at `FFEEC131` (`7f 4e`, table `FFF48076`) lands in a run of `bsr.a; bra` pairs. The true decode is `FFEEC133 05 a3 c5 ff` bsr FFEE86D6, `38 86 00` bra.w FFEEC1BD, `05 67 f1 ff`, `05 59 f2 ff`, `2e 7b`, `05 f6 a6 ff`, `2e 75`, … , `05 37 92 05`, `2e 35`. IDA read it as `a3 c5`, `ff 38 86` (mul), `00` (brk), `f2 ff 2e 7b` (bclr), `f6 a6 ff 2e` (btst), `75 05 ae` … | True decode right. 22 IDA heads in `FFEEC134`–`FFEEC186` are out of phase. All 14 targets are true heads. |
| **A**: call-site argument block | 18 / 18 | The true decode is `71 04 60` add #60h,sp,r4 then `a0 0c` (5 targets, e.g. `FFF1B3AE`), or `71 03 60`, `a0 0b`, `f8 04 00` (13 targets, e.g. `FFF2A989`: `60 c0 a0 82 71 03 60 a0 0b f8 04 00`). Lane 4 started a function at the third byte: `60 a0` "sub #A,sp", `0b`/`0c` bra.s, `00` brk. | True decode right. These 18 lane-4 "functions" are mid-instruction splits. |
| **P**: an operand `6e` read as `pushm` | 7 / 7 | `FFEE97EC 3c 0f 6e` then `3c 80 6f`; `FFEEA54D 45 fe 6e` then `15` beq; `FFEF495A 68 6e` then `7c 1e`; `FFEF532D`/`FFEF95BC 61 6e` then `1d`/`17`; `FFF454E4 7c 6e` then `17`; `FFF4C680 4b 6e` then `59 ee 1e`, `2e 3d` (inside validated `sub_FFF4C442`). IDA heads at +1 read as `6e xx` pushm. | True decode right. |
| **O**: other phase slips | 11 / 12 | For example `FFF366C4 39 83 fb` bsr.w, `a2 09`, `a8 89`, `39 b0 fb` bsr.w FFF3627B, where IDA had `FFF366C6 fb a2 09 a8 89 39` "mov #3989A809,r10". `FFF40306 05 38 a8 fb` bsr, `62 40`, `39 08 00` bsr.w FFF40314, where IDA had `FFF40309 fb 62 40 39 08 00`. `FFEDB0AB a8 89`, `75 11 18`, reached by `blt` at `FFEDB125`, where IDA had `7e a8` push r8. `FFEF378A 75 51 60`, `20 65`, `75 51 6a`, `20 4a`, `75 51 5a`. `FFEFE44D`/`FFF04EDA 05 6e .. ..` bsr then `62 40`. Also `FFEF1B4F`, `FFEF1B64`, `FFF0041F`, `FFF03E2F`, `FFF38E52`. | True decode right. |
| **S**: fake edges | 4 targets / 10 edges | `FFEDB0B7` ← `FFEDB0AE`/`AF` (the `11`/`18` "beq/bne" bytes are inside the true `75 11 18`). `FFF40C9F` ← `FFEEC171` (the "bsr" is inside the true `05 bf 4f 05` at `FFEEC16E`). `FFEF1B70` ← `FFEF1B67` (inside the true `61 11`). `FFEEC160` ← `FFEEC157` (inside the true `05 19 bf ff`). | **IDA right** at the target. The edge is not real. `FFEEC160` is still a true head, reached by flow from `FFEEC15C`. |

The first FIX run left 2 conflicts. Both were one more fake edge, from `FFEF1B5B` (`0a`, the tail of the true `b0 0a` at `FFEF1B5A`). I added it as an anchor, recorded as row "H10".

**Byte impact of the 63 edges:**

- Deduction **0 B**. No validated byte turned out to be data. The bytes from the earliest disagreement to resync are contiguous code in the true decode, and FIX lost no byte except the rejects in finding 2.
- Additions are listed per row: +26 (`f8 04` completions), +3 (`FFEEA555`), +116 (`FFF3627B`) and +21 (`FFF40314`).

The 18 H8 "code-conflict" runs (40 B: `FFEE97C5 71 01 0a`, 13× `a0 84` after `71 04 60`, `FFF33683 3e 01 00 2e 1c`, and others) are the same phenomenon. They are code, reached by flow from H8-credited heads: **+40 B**.

### 2. The 247 B of wave-2 rejects (`raw\rej2.tsv`)

The rejects were dropped from the validated roots and the closure was re-run.

- **149 B (19 rejects) are re-reached by flow.** For example, `FFEF3715` (59 B) and `FFF1B3A9 71 04 5c a0 84`, a split argument block. They stay credited as reached code, so nothing is counted twice.
- **98 B (49 rejects) are unreached.** Each is a two-byte `60 40` (`sub #4,sp`) in front of a validated function that also begins with `60 40`, for example `FFF0F059 67 01 | 60 40 | 60 40 f8 05`. The previous function ends in `rtsd`, and no branch, call or pointer targets the sliver. **−98 B** moves to the residue.

### 3. The 54 orphan `71 00` functions (`orphans.tsv`)

**Reached (2 functions, 137 B, Confirmed):**

- **`FFF3627B`** (`71 00 f0 a0 89 3e 01 00`…). It is called by the true-phase `bsr.w` at `FFF366CB` (`39 b0 fb`). It maps a 2-bit field (`[r1+9]&3`) through a chain of `cmp #n` cases to the masks 4, 8, 0x10, 0x20, 0x40, 0x80, 0x100 and 0x200, then returns with `rtsd #4`.
- **`FFF40314`**. It is called by the `bsr.w` at `FFF4030C` (`39 08 00`), and it zero-initialises locals.

H8's brute-force branch scan missed both calls because each call site sat inside an out-of-phase IDA item.

**Dead application code (52 runs, 3,692 B):**

- 24 are a screen-handler clone family: `mov.l #-31,r1` (`fb 16 e1`), `bsr FFF15E96`, then `bsr FFF1EE20`/`FFF1EE7B`. Examples are `FFF2C17D`, `FFF2C72B`, `FFF2CC9F`, `FFF2D157` and `FFF2A6D1`.
- 17 more call other UI routines (`FFF1EE20`, `FFF2EC2C`, `FFF1D5D9`, `FFEF0648` …).
- The other 11 have no call in their first linear block.
- 6 of them are the **true heads of lane-4 "body" functions**, which makes the whole function unreferenced: `FFF253AC` → `FFF253AF`, `FFF2511D`, `FFF257B1`, `FFEF6A78`, `FFF33BF8`, `FFF36999`.

**Dead library code: none.** No orphan lies in or calls into the CC-RX runtime area (where `_INITSCT` sits, around `FFF45DE0`). Every one with calls calls application UI code. That they were left in because the linker keeps unreferenced external functions is **Inferred** (it is a general CC-RX property and is not visible in the image). **Unknown: 0.**

**Reachability searched (Not found, scope stated):**

1. **LE32 and 24-bit immediates.** The 3-byte LE value of each start was searched at every offset of all 4,194,304 bytes. This covers ROM pointer tables, the three `.data` initialiser images `FFED8E70`–`FFEDAB4C` (copied to RAM `0x1217E`, `0x12570` and `0x68514`), 32-bit `mov.l #imm`, and the 24-bit sign-extended `fb ?e` form. **No hits for any of the 52 dead starts.**
2. **Relative branches.** `.a`/`.w`/`.b`/`.s` encodings were checked at every offset of the window. The 2 real hits are now reached. The other 6 hits all lie inside true instructions: for example `FFEF1399` is inside `06 c5 01 10` at `FFEF1396`, and `FFF2C1D5` is inside `2e 28`.
3. **Switch tables.** None of the 643 `bra.l` case edges hits an orphan start.
4. **Indirect transfers** (`raw\indirect.tsv`, census over all credited code). There are 359 sites: 319 `jsr Rn` and 40 `bra.l Rn` (the 40 resolved switches). There are **0 `jmp Rn` and 0 `bsr.l Rn`**. Every `jsr` loads its target from memory (for example 133 × `mov.l [r14],r14 ; jsr r14`). So every code pointer must exist somewhere as an absolute 32-bit value, either as ROM data or as an immediate, and probe 1 covers both.
5. **RAM callback stores** (`raw\ram_cb.tsv`). In the code band, 46 code addresses are passed or stored. 45 are arguments to registration routines (`FFF39ABC` ×12, `FFF39D6B`, `FFF3992E`, `FFF1427F`, `FFEDB63A`, `FFEDB6BD`, `FFEDBA44` …), and one is `FFEDE847 fb 12 97 e8 ed ff` stored to `4C[sp]`. None of them is an orphan.
6. **The 0x12D20 block** (`raw\ramscan.txt`, 60 accesses) is the SCI0 control block, not a table. It holds two callback slots:
   - `+0` is written by `FFEDB63A` (`e1 0e 01`, from r2; set to `FFEDB081` at `FFEDAC72 fb 22 81 b0 ed ff`). It is dispatched at `FFEDB860`/`FFEDB8AA` (`mov.l [r1],r1` … `jsr r4`/`jsr r14`).
   - `+4` is written by `FFEDB6BD` (`e5 0e 01 01`, set to `FFEDB131` at `FFEDACE7`). It is dispatched at `FFEDB82A` (`a8 19` mov.l 4[r1] … `jsr r4` at `FFEDB845`).
   - `FFEDB300`/`FFEDB690` clear it.
   - Both installed callbacks were already credited by H8.

   The sibling block at `0x12D44` (375 accesses) has the same shape.

### 4. Fragments, the 40 B misalignment and the 13 B wrapper

- **Code-conflict runs (40 B):** resolved as code (finding 1).
- **Fragments (72 B):** 29 B are resolved as code (`f8 04` ×13 and `FFEEA555`). The other **43 B** are well-formed but unreferenced:
  - lone `02` empty functions at `FFEE177F`, `FFF3758F` and `FFF375A4` (×2)
  - `FFF47E60 02`, which breaks the 2-byte RTE-stub alignment (`7f 95 ×4, 02, 7f 95`)
  - `FFEF202A 75 41 28 05 6b c2 fe 02` (mov #40,r1; bsr.a; rts)
  - the function heads `FFF13DDA` (`72 00 e0 fe`…) and `FFF3B8CB`
- **`FFF4B077`, 13 B** (`60 40 66 04 f8 06 01 39 06 00 62 40 02`): dead. It has no LE32/LE24 value and no relative branch. Its twin `FFF4B06C` is called by `bsr.a` at `FFEDE86F`. It lies inside the published string-pool data region, so it does not move the code figure. It would move from data to residue only if the pool bound is corrected to `FFF4B059`.

### 5. Ledger (`ledger-delta.tsv`)

| Item | Bytes |
| --- | --- |
| H8 window code | 464,058 |
| + code-conflict runs are code | +40 |
| + `f8 04 00` completions | +26 |
| + `FFEEA555` | +3 |
| + `FFF3627B` reached | +116 |
| + `FFF40314` reached | +21 |
| − 49 unreached `60 40` reject slivers | −98 |
| phase repairs, 149 B re-reached rejects, `FFEDFFFD` pair | 0 |
| **SUB window code** | **464,166 / 524,288 = 88.53 %** (+108) |
| typed data (H8, unchanged) | 56,289 |
| unresolved residue | 3,833 = 3,692 dead orphans + 43 fragments + 98 slivers |

The counts are checked two ways:

- FIX credited 464,157, plus H8's hand-decoded 9 B, gives 464,166.
- 464,166 + 56,289 + 3,833 = 524,288.

**The standard is inconsistent, and here is what each consistent version gives.** H8 credits gap code only if it is reachable, but the 438,300 includes lane-4 "body" functions validated on structure alone.

- **Structural standard** (every well-formed function is code, dead or not): the 3,833 residue is well-formed code, so window code = 467,999 (89.26 %), which is the whole non-data window.
- **Reachability standard** (roots are the 1,601 lane-4 xref starts, 410 pointer-reached starts, H8's 141 tier-2 roots and the vectors): 454,630 B are reachable (86.71 %). The unreached 9,527 B are:
  - 8,782 B of "body" functions, for example `FFF1EA05` (383 B), `FFF253AF` (365), `FFEF13F4` (327), `FFF13DEF` (251) and `FFEE1780` (232). I spot-checked six of them: none has an LE32/LE24 value or a relative branch anywhere.
  - 102 B of `FFF38800`, whose only xref comes from dead `FFF387C9`
  - 643 B of gap code reached only from those

The H8-compatible figure, 88.53 %, is the one to carry forward. The two alternatives bracket it.

## USB relevance

None. The repaired decodes and the two newly reached functions are UI and screen code:

- the `bsr.a` dispatch in `FFEEC0D3`
- the argument blocks for the draw calls
- a bit-mask helper (`FFF3627B`)
- a local-init helper (`FFF40314`)

No peripheral immediate appears. The 0x12D20 callbacks are SCI0 completions, already known. The dead functions are screen handlers. The settled SUB negatives stand: USB0 is dark, and there is no SDR or DSP path on the SUB side. **Confirmed** within the window.

## Open

1. Apply the result in a DB:
   - undefine the 108 out-of-phase heads (34 bogus lane-4 function starts, listed in `conflicts-resolved.tsv` `of_which_lane4_fn_starts`)
   - create the 187 true heads, plus `FFF3627B` and `FFF40314`
   - delete the 49 `60 40` sliver functions
2. Decide the standard for the headline. Either credit dead but well-formed code (+3,833 B) or remove lane-4 "body" functions that are unreachable (−9,527 B). Do not mix the two.
3. Lane 4's split heuristic (`60 a0`/`6e xx` treated as prologues) almost certainly produced more mid-instruction starts than the 34 that a conflict edge exposed. Checking every lane-4 "body" start for a predecessor instruction that spans it would find them. The byte impact is expected to be 0 apart from the newly found edges.

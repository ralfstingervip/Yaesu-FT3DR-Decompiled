# 99 — fnindex-only proven runs below 0x030000 (Lane L2)

> Lane L2, model `claude-opus-5-5`. Owner-side, read-only static analysis of
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, big-endian, base 0, file offset = address). No image byte was modified,
> no mask or seed was edited, and nothing was connected to or written to a radio. The private IDA DB `L2_FNIDX_LO`
> was copied from `K1_MAIN_FINAL4` and only queried. Image sha256 `8e3ecd05409b2c31…` (checked before and after).
> Tables: `ida\out\fnindex-lo\`.

## Verdict

K1 listed 36 fnindex-only runs (938 B) below `0x030000`. All 36 are now classified and none is left UNCERTAIN.
- **4 runs (54 B) are REACHED.** All four come from one indirect edge the descent does not model. Code does
  `mov.l #T,er1 ; jsr @0x15206`, and `sub_15206` reaches `0x015224 5d 10` (`jsr @er1`). I9 seeded only one
  target of this helper (`0x01A084`). This lane adds three more: `0x018250`, `0x018ABE` and `0x01A094`. A fourth run,
  `0x01A0A4`, is reached by a call from `0x018ABE`.
- **18 runs (760 B) are DEAD.** Every caller of each one is unreferenced code. The callers fall into two kinds:
  (a) whole routines after an `rts` that nothing references;
  (b) "dead arms": blocks placed after an unconditional `bra`, with no branch into them.
- **2 runs (44 B) are SPLIT-TAIL.** H9 cut routine `0x01CCB0` and routine `0x01CCFA` at an internal join point.
  This is the same class as `0x054AE2`.
- **12 runs (80 B) are DATA-MISTYPED.** H9 placed the fnindex start on a byte table, a word table, a range pair, a
  record list or an `eepmov` source. Reached code reads each one as data.

**Proposed demotion: 32 runs, 884 B** (`proposed-demotions.tsv`). **Proposed seeds: 3 er1-callback edges**
(`proposed-seeds.tsv`). With those three seeds and every fnindex seed removed, the folded descent reaches exactly the
54 REACHED bytes of this set. It reaches 0 other new bytes. None of the 938 B touches the USB, SCI or DMAC
registers.

## Method

1. **Reproduce the set.** `offline\l2_reach.py` imports H9's `descent.py` unchanged. It rebuilds K1's folded seeds
   (J1 I6/I8/I9/I15, K1a table re-admission, K1b helper-table fixpoint) and runs the descent twice: with H9's fnindex
   seeds (rK) and without them (rN). The result is `final4_proven & rK & ~rN` = **94 runs / 4,850 B**, identical to
   `fnindex-only-runs.tsv`. That is the published list, reproduced exactly. The 36 runs with start < `0x030000` are
   the scope of this lane.
2. **Whole-image inbound scan** (`offline\l2_refs.py` → `inbound-scan.txt`). For every byte of every run the scan
   covered these inbound forms:
   - BE32 at every byte offset of the 1 MB image, including the vector table `0x0`–`0x3FF`, with a 24-bit-masked
     variant for `@@aa:8` slots;
   - every constant in the binutils H8SX oracle decode at every even address `0`–`0x7B754`: abs24 `jsr`/`jmp`,
     8/16-bit `bra`/`bsr`/`Bcc`, `mov.l #imm`, `@(d:32,ERn)` loads, and the 25 H8SX `bra/bc`/`bra/bs` bit-branches
     (none targets a run);
   - BE16 for run starts below `0x8000`;
   - the decode that ends exactly at the run start, for fall-through.

   Every hit is tagged by site class: reached-without-fnindex, fnindex-only, proven-unreached, IDA code but
   unproven, data, or window.
3. **Backward closure** (`offline\l2_back.py` → `backward-closure.txt`). From each run, the scan walks predecessor flow
   edges (branch, call, fall-through) through IDA-code or proven sites. It collects every non-flow reference
   (immediate, BE32) to any instruction in that closure. A run is reached only if the closure meets reached code
   through a reference the descent does not model.
4. **Caller heads** (`offline\heads.py`). There are 27 heads of the unproven caller regions. Each one was checked
   whole-image for BE32, 3-byte packed pointers, vector slots and decode constants. Every head has 0 references,
   except `0x01758E`, which is loaded only inside the dead block `0x017570`.
5. **IDA cross-check** (`ida\jobs\l2_xrefs.py` on DB `L2_FNIDX_LO` → `ida-xrefs.tsv`, `ida-items.tsv`). IDA `h8sxa`
   lists 0 xrefs to every dead caller head, which agrees with the oracle. The only non-flow IDA references into the
   runs are the `mov.l #imm` / `@(d:32,ERn)` data loads and the three er1 loads cited below.
6. **Known relative-offset dispatch.** The only `bra rN` in reached code is H1's `0x076308`. The 16-bit exit table
   `0x19A9E` (base `0x148A0`) is already folded into the seeds. All 267 `jmp/jsr @ERn` sites are doc 60's. No other
   relative table was found. For an arbitrary 16-bit offset table with an unknown base, the scan is incomplete
   (scope stated).
7. **Verify** (`offline\verify.py`). The verify run re-runs the descent with fnindex seeds removed plus the three
   er1 seeds. It reaches exactly `018250`–`018261`, `018ABE`–`018AD1`, `01A094`–`01A09B` and `01A0A4`–`01A0AB`
   (54 B). It reaches 0 other bytes.
8. **Citations.** `offline\l2_emit.py` asserts every (address, bytes) pair in `runs.tsv` against the image. 106/106
   pass.

Not done: runs ≥ `0x030000` (the other lane), and the closed window `0x078106`–`0x07B753` (no run lies in it, and no
reference from it to any of these runs was found).

## Findings

### 1. REACHED — the er1-callback helper `sub_15206` (Confirmed bytes; trigger values Inferred)

`sub_15206` runs as follows:
- `0x015206 fc 00`
- `0x01520E 6a 0a ad 68` (`r2l = FFAD68`)
- `0x015212 46 06` (if `r2l ≠ 0` go to `0x01521A`)
- `0x01521A 6a 0c ad 9d`
- `0x01521E 46 04` (if `FFAD9D ≠ 0`)
- `0x015224 5d 10` `jsr @er1`

`er1` is not written on that path. Reached code writes `FFAD9D = 1` at `0x015A26`, `0x015BC2` and `0x01CEF4`, and
sets `FFAD68` non-zero at dozens of sites, so the call is live. That both values are set at once is Inferred, which is
the same standard as I9.

| Run | Len | Registration (load ; call) | Body |
| --- | ---: | --- | --- |
| `0x018250` | 18 | `0x018276 7a 01 00 01 82 50` ; `0x01827C 5e 01 52 06` | `FF8BCC ≠ 0` → `jsr 0x1A0DC` else `0x3FFA0` |
| `0x018ABE` | 20 | `0x018AD2 7a 01 00 01 8a be` ; `0x018AD8 5e 01 52 06` | `FF8C26` b7 (`6a 10 8c 26 73 70`) → `jsr 0x1A0A4` else `0x3FFA0` |
| `0x01A094` | 8 | `0x018BE8 7a 01 00 01 a0 94` ; `0x018BEE 5e 01 52 06` | landing pad `7a 02 00 01 a1 ec 40 4e` (record `0x1A1EC`) |
| `0x01A0A4` | 8 | called `0x018AC6 5e 01 a0 a4` from `0x018ABE` | landing pad `7a 02 00 01 a1 e0 40 3e` (record `0x1A1E0`) |

**Why only the seed reached them.** I9 hand-seeded a single target of this helper (`0x01A084`, doc 60's
"call_return_value 0x015224"). The image has 14 `mov.l #T,er1 ; jsr @0x15206` sites, and 13 of them are reached:
- 9 load a target that is already reached, including `0x01A084`;
- 3 are this lane's runs;
- 1 is `0x05E8E0`, in the high lane.

The fourteenth site, `0x017576`, is in the dead block `0x017570`. The rule was never generalised. The same pattern sits above this lane's scope at
`0x05E862 7a 01 00 05 e8 e0` / `0x05E868`, with target `0x05E8E0`, which is fnindex-only.

### 2. DEAD — 18 runs, 760 B (Confirmed: 0 inbound whole-image, IDA 0 xrefs)

| Run | Len | Only inbound | Why that inbound is dead |
| --- | ---: | --- | --- |
| `0x00619C` | 8 | `0x04FB44 5e 00 61 9c 54 70` | J4-DEAD stub after data `.word 0002 5458`; 0 refs |
| `0x00CFC2` | 34 | `0x0076DA 5e 00 cf c2` | stub `0x0076D8`–`DF` after `rts 0x0076D6`; 0 refs (companion, proven-unreached) |
| `0x01522E` + `0x01525E` | 44+2 | none | routine `0x01522E`–`0x01525F`, preceded by `rts 0x01522C`; 0 refs |
| `0x015EB4` | 28 | `bsr` `0x015E80`/`0x015E86` | in block `0x015E64`–`EA1` skipped by reached `0x015E62 40 3e`; its tail is also the body of unreferenced `0x015EA8` |
| `0x018464` | 42 | `0x018460 55 02` | in `0x01844E` after unproven `0x018420`–`0x01844D`; 0 refs |
| `0x018A74` | 8 | `0x0188D0 5e 01 8a 74`, `0x018A94 55 de` | both fragments start after a reached `rts`; 0 refs |
| `0x0192A0` | 8 | `0x022E24 5e 01 92 a0` | inside DEAD `0x022DF0`; body is EEPROM writer stub `79 01 00 16 5a 03 cc bc` |
| `0x0198C4` | 8 | `0x05142C`, `0x051472` | arms after reached `0x051420 40 24` / `0x051466 40 1e`; writer stub `79 01 01 8c 5a 03 cc ec` |
| `0x01C4D2` | 194 | `0x01C28E`, `0x01D93C` (`5e 01 c4 d2`) | arms after reached `0x01C27C 40 1a` / `0x01D932 40 12`; 0 refs |
| `0x01CD38` | 68 | `0x01C584 5e 01 cd 38` | inside DEAD `0x01C4D2` |
| `0x01F540` | 86 | `0x01F4F2 55 4c`, `0x01F520 55 1e` | routines `0x01F4DA`, `0x01F508` after `rts`; 0 refs |
| `0x01F930` | 16 | `0x01F926`, `0x01F98C` | routines `0x01F916`, `0x01F96E` (J4-DEAD); 0 refs |
| `0x01F996` | 48 | `0x01F976`, `0x01F94C` | routines `0x01F96E`, `0x01F940`; 0 refs |
| `0x022DF0` | 114 | `0x022DE6 55 08`, `0x022DEA 5e 02 2e 3a` | routine `0x022DDE` after reached `rts 0x022DDC`; 0 refs |
| `0x02370E` | 30 | `0x01DB46`, `0x01E87C` | `0x01DB3A` follows a BE32 handler table ending `00 03 ff a0`; `0x01E870` follows `rts`; 0 refs |
| `0x024440` | 20 | `0x010B44 5e 02 44 40` | arm after reached `0x010B40 58 00 ff 74`, with no compare that selects it |
| `0x02AAE8` | 2 | `0x02AB92 5e 02 aa e8` | `rts` stub; arm after reached `0x02AB90 40 14` |

Two of the callers are themselves proven but unreached, and so outside the fnindex-only set:
- `0x0076D8`–`0x0076DF` (8 B);
- `0x01C27E`–`0x01C293` (22 B).

They are listed as optional companions (`#C` rows) in `proposed-demotions.tsv`.

### 3. SPLIT-TAIL — 2 runs, 44 B (Confirmed)

- `0x01CCD6` (28 B). Head `0x01CCB0` follows reached `0x01CCAE 40 42`. Inside the routine, `0x01CCC8 47 0c` and
  `0x01CCD4 40 00` flow into `0x01CCD6`. There are 0 refs to `0x01CCB0`.
- `0x01CD26` (16 B). Head `0x01CCFA` (J4-DEAD) follows reached `0x01CCF8 40 3c`. `0x01CD22 6a 8c 8e b3` falls into
  `0x01CD26` and `0x01CD14 40 10` branches to it.

### 4. DATA-MISTYPED — 12 runs, 80 B (Confirmed by the reader)

| Run | Len | Reader |
| --- | ---: | --- |
| `0x00245C` | 16 | `0x002416 7a 05 00 00 24 5c` + `r4=0x10` + `eepmov` `0x002422` → `FFA998`/`FFA9A8` (00×8 FF×8) |
| `0x00C63C` | 4 | 6-B record list `0xC624` (`00 06` + records) loaded `0x00D4A2`, copied by `sub_B516` (`0x00B52E 6d 54`, `eepmov`) |
| `0x0151E6` | 6 | `0x01509A 78 30 6a 2b 00 01 51 e6` byte map; pointer cell `0x014D9A` in H9-excluded table `0x014D6A` |
| `0x016642` | 6 | `0x016634 78 40 6a 2c 00 01 66 42` (values 30/50/70/100/150/0) |
| `0x01E22C` | 12 | `0x01E174 7a 05 00 01 e2 2c` then `0x01E184 69 54` (`mov.w @er5`) |
| `0x01E5EE` | 8 | `0x01E5BE 7a 06 00 01 e5 ee` → `sub_3F5EE` range compare `{0x38021250, 0x38131250}` |
| `0x024000` | 6 | `0x023F9E`/`0x023FD6` `78 40 6a 2b 00 02 40 00` |
| `0x02D704`, `0x02D7FE`, `0x02E2D8`, `0x02E3D2` | 4 each | `mov.l #T,er5 ; bsr +0x18` → `7a 63 00 00 00 ff 0a b5 68 5b` (byte index) |
| `0x02E640` | 6 | `0x02E61A 7a 05 00 02 e6 40` → `sub_3F768` (`6c 5c ac ff`, FF-terminated search) |

### 5. Ledger effect if applied (Inferred arithmetic; masks not rewritten)

Proven code would fall by **884 B**: 760 DEAD + 44 SPLIT-TAIL + 80 DATA-MISTYPED. Applying the two optional
companions would remove another 30 B. Under the I12 convention named/typed stays unchanged: all 938 B are in
`final4_named_mask.bin`. The 80 DATA-MISTYPED bytes should be retyped as data rather than kept as code. Measured
against the follow-up headline (MAIN proven 369,214), the result would be **368,330**, or 368,300 with the
companions. The 54 REACHED bytes keep their credit only if the three er1 seeds are added before the fnindex seeds
are dropped.

## USB relevance

None of the 938 B reads or writes `0xFFEE00`–`0xFFEE53` (USB), `0xFFF610`, `0xFFFF60`–`0xFFFF9F` (SCI) or the DMAC
blocks. The scan covered every absolute operand of every decoded instruction in the runs. The only hit in range,
`0x01E22E` `mov.b r7h,@0x90:8`, is a misdecode inside the DATA-MISTYPED table `0x01E22C`.

Two areas are adjacent to the mission questions but not on the USB path:
- **DSP-adjacent (DEAD).** `0x01C4D2`, `0x01CD38` and the two split tails save and restore the DSP-mode gates
  `FF8D20`, `FF8DD5`, `FF8EA0`, `FF8EB3` and `FF8EC0`/`C1`. They call `0x05E5BE`, which tests `FF8EA0` b7 and
  `FF8DD5` (doc 52's mode gates), and `0x0198DC`, which runs the EEPROM writer `sub_3CD30` on `FF8D20`. All of it is
  unreachable in v1.02.
- **SCI-adjacent (REACHED).** `0x018ABE` tests `FF8C26` b7, the DATA-jack trace flag (docs 05/12). As a menu
  callback it only selects landing pad `0x1A1E0`.

There is no new USB, SDR or DSP surface. All three mission answers are unchanged.

## Open

1. Apply the three er1-callback seeds (`proposed-seeds.tsv`) as a general rule: every `mov.l #T,er1` reaching
   `jsr @0x15206`. Then apply the 884 B demotion. Re-run K1's builder to confirm −884 and +0 elsewhere.
2. The high lane should treat `0x05E8E0` (`0x05E862`/`0x05E868`) as the same er1-callback edge.
3. The 14 landing pads `0x01A07C`–`0x01A0E9` include two unreached ones:
   - `0x01A0D4` has a BE32 at `0x01792E`, inside unreached code;
   - `0x01A0E4` is proven but has 0 references.

   Both are outside this lane.
4. The "dead arm after `bra`" pattern (`0x01C27E`, `0x01D934`, `0x051422`, `0x051468`, `0x010B44`, `0x02AB92`,
   `0x015E64`) suggests code the compiler emitted for cases that were later disabled. A pass over the whole image
   for blocks with 0 references that follow an unconditional `bra` would size this class.
5. Arbitrary 16-bit offset tables with unknown bases were not searched. Only the known bases `0x148A0`/`0x19A9E` and
   `0x076308` were checked.

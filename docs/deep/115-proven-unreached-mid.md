# 115 — proven-but-unreached runs 0x030000–0x057FFF: edge check (Lane M3)

> Lane M3, model `claude-opus-5-5`. This is owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin`.
> - Image: H8SX, base 0, big-endian, file offset = address. sha256 MAIN `8e3ecd05409b2c31…` and SUB `b93570b3c2f69ccb…`, both re-checked and unchanged.
> - Nothing was written to, or connected with, any radio or device.
> - Only my DB `ida\db\jobs\M3_PUNR_MID\M3_PUNR_MID.i64` was opened, as a `--copy-from` of `L1_MAIN_FINAL5`. The job was read-only and edited no item.
> - No mask, seed or DB was changed. Every demotion below is a proposal.
> - Tables are in `ida\out\punr-mid\`.

## Verdict

**None of the 22 runs (574 B) is reached, and all 22 should leave the proven mask.** These are the runs in
`ida\out\l-wave-recon\proven-unreached-runs.tsv` with `0x030000 <= start < 0x058000`.

Each byte is kept proven by one H9 rule only: **addend A**, meaning fnindex-validated span × IDA `items_before` code.
- `analyze.py` builds proven as `(A|RC|D|G1A) & ~RCU & ~DU | NEWP`.
- It re-measures RC and D against the descent, but never A.
- So unreachable blocks inside a validated fnindex span whose head is live stay proven.
- Not one byte of the 574 is RC, D, G1A, RM (H9 reach) or NEWP (`work\m3_rules.txt`).

| Class | Runs | Bytes |
| --- | ---: | ---: |
| DEAD | 19 | 552 |
| SPLIT-TAIL | 2 | 20 |
| DATA-MISTYPED | 1 | 2 |
| REACHED | 0 | 0 |
| UNCERTAIN | 0 | 0 |

**Two patterns account for most of the bytes.**
- Most DEAD runs are a block after an unconditional `bra` with no inbound edge. These are the compiler's leftover arms.
- The rest are **unreferenced entries of multi-entry routines**, shaped `mov #param ; bra shared-body`. Their siblings
  are called by abs24 `jsr`; they are not. Four families: `0334A0`, `04B830`/`04B856`, `04F87C`/`04F8DA`, `05291E`.

Four runs do have one inbound edge each, but every such edge comes from code that is itself dead (Confirmed):

| Run | Inbound edge | Why the source is dead |
| --- | --- | --- |
| `04BB78` | `04BAEE 5e 04 bb 78` | in arm `04BACE`, which sits after `04BACC 40 4a` |
| `04C198` | `04C04A 5e 04 c1 98` | in arm `04C02A`, which sits after `04C028 40 4a` |
| `050CD0` | `050C6E 47 60` | in routine `050C68`, which sits after `rts 050C66` |
| `04B856` | `04B810 40 44` | in 4-digit entry `04B7F4`, which sits after `rts 04B7F2` |

Each source block or head has 0 inbound references, whole image.

**No descent rule is missing in this scope.** I re-ran K1's folded descent with all 8 L-wave entries, both with and
without fnindex seeds. It reaches 0 of the 574 B (`work\m3_descent.txt`).

**Proposed:**
- MAIN proven 364,786 − 574 = **364,212**: 72.02 % of 505,684 content, 93.57 % of the 389,260 decodable bytes.
- Named stays **501,656** (I12 convention; the 2 data bytes are retyped and stay named).
- Headline unchanged at 965,919 / 1,029,972 = **93.78 %**.

## Method

All passes below were run this session. Each one is reproducible from `ida\out\punr-mid\offline\`.

1. **Rule attribution** (`m3_rules.py`). I imported H9's `analyze.py`, `masks.py` and `descent.py` read-only and labelled
   every run byte with its addends: A, RC, D, G1A, RM, NEWP, RCU, DU. I also recorded the covering fnindex span.
   - Result: all 574 B are `A` only.
   - All 574 B are set in `h9_proven_mask.bin`, in final4 and in the proposed final6 mask.
   - The enclosing fnindex spans are listed per run in `runs.tsv`.
2. **Whole-image inbound scan** (`m3_refs.py`, `m3_scan.py` → `refs-detail.tsv`; `m3_even.py` → `work\m3_even.txt`).
   - **Targets:** every oracle instruction start in every run (194 targets including the enclosing span heads). A second
     pass covered **every even address** in the runs (287 targets).
   - **Scope `0x000000`–`0x07B753`, decoded at every even address, including the closed window:**
     - direct `bra`/`bcc`/`bsr` (8- and 16-bit) and `jsr`/`jmp @aa:24`;
     - every numeric operand (`#imm`, `@aa:16/24/32`, `@(d,ERn)`), which covers `mov.l #imm,erN` callback and er1-helper
       loads;
     - `@@aa:8` slots resolved through their cell;
     - `mov.w #hi,eN` / `mov.w #lo,rN` pairs.
   - **Scope: every byte offset of the 1 MB image:** raw BE32 (exact and `& 0xFFFFFF`) and raw BE24. This covers the
     vector table, all switch and jump tables, the helper tables (doc 83 rule), records and RAM-cell sources (doc 60).
   - **Indirect transfers:**
     - All 267 reached `jmp/jsr @erN` sites are in doc 60's `sites.tsv`, and 0 of its targets fall in the runs.
     - The K1 descent reaches exactly one register-relative branch, `076308 59 06` (`bra r0.w`), whose table is in the
       closed window and which is far out of ±32 KB range.
   - **Positive control:** every reached sibling entry of the multi-entry families is found with its abs24 `jsr`.
3. **Descent re-run** (`m3_descent.py`).
   - I exec'd the write-free prefix of K1's `k1_build_masks.py` exactly as L3 did; its asserts reproduce final3.
   - I then ran `run_folded(COMBINED + 8)` with and without `FNSEED`. The 8 are L2's `0x018250`/`0x018ABE`/`0x01A094`,
     L4's `0x05E8E0`/`0x066FB4`/`0x067250`, and the orchestrator's `0x066FBE`/`0x06726A`.
   - Reach over the 574 B: 0 and 0.
4. **IDA cross-check.** `ida\jobs\m3_punr_xrefs.py` ran on `M3_PUNR_MID` and dumped heads and `XrefsTo` for the 22 runs
   and 12 companion blocks (`work\m3_ida_heads.tsv`, `m3_ida_xrefs.tsv`).
   - IDA has all 574 B as code.
   - Its 14 xrefs are all rows the oracle scan already has (the dead callers above, internal `bra`, and the data reads of
     `03D1C6` and `04F82A`). IDA found no extra edge.
5. **Citation check** (`m3_verify.py` → `work\m3_verify.txt`): **114 / 114 pass.** It covers 100 byte citations, 6
   decode claims and 8 mask/sha checks.

**Not done.** I did not check arithmetic pointer construction other than `mov.w` pairs, for example `base + offset` into
a RAM table filled at run time. That remains Not found within the forms listed. For it to reach these runs, some code
would have to build the address of a block that starts right after an unconditional `bra` in a routine whose other
entries are called directly.

## Findings

All rows are Confirmed by bytes (`m3_verify.py`). "0 refs" means the whole-image scope in Method 2.

### DEAD (552 B)

| Run | B | Unit | Evidence |
| --- | ---: | --- | --- |
| `0334A0`–`0334A3` | 4 | delay helper with 3 entries | The three entries are `033494 79 06 00 64` (#100), `03349A 79 06 01 f4` (#500) and `0334A0 79 06 03 e8` (#1000), all feeding the loop at `0334A4`. Only `03349A` is called (`033488 55 10` bsr). `0334A0` has 0 refs and follows `03349E 40 04`. |
| `034032`–`03403F` | 14 | `sub_34022` | The cmp chain `fd 00 ab 27 47 0c ab 29 47 04 ab 2a 46 e0` follows `034030 40 0e` (bra `0x34040`). 0 refs. The BE24 hits `029B5C fb 03 40 32`, `00DC2E 80 03 40 34` and `04954E f6 03 40 38` are `mov.b #3`/`add.b #3` followed by `bra` opcodes, not pointers. |
| `0348EC`–`034915` | 42 | span `03486C` | Block `7e 5b 73 30 …` follows `0348EA 40 2a`. The only inbound edge is its own `0348F0 47 12`. |
| `03D0EE`–`03D14F` | 98 | `sub_3D022` switch, `03CF2A 78 c0 6b 26 00 03 cf 34` / `03CF32 59 60` | The case body starts `7a 04 77 91 25 00`, with BCD bases 779.125 / 797.125 (`03D10A`) / 806.125 MHz (`03D11C`) and 12.5 kHz steps. It follows `03D0EA 58 00 01 00`. The 12-slot table `03CF34` has no slot for it (the 13th word is `00ff0000`), and there are 0 refs. Inferred: an 800 MHz band case that this build's switch never selects. |
| `03EF60`, `03EFA0`, `03EFE0` | 3×4 | three sibling routines `03EF2E`/`03EF6E`/`03EFAE` | Each is `fc 07 40 08` following `40 0c`. 0 refs. The next arm in each, `fc 03 40 04`, is also unreached (unproven, unnamed). |
| `0460C2`–`04612F` | 110 | `sub_45FBA` | Skipped by `0460C0 40 6e`. Only internal branches enter it. It holds the only calls to `046210`/`046290`/`04633C`/`045F88` (`0460C8`, `0460D6`, `046104`, `04612A`). Same as L3. |
| `04B1D0`–`04B1E5` | 22 | span `04B1B4` | Block `6a 10 9e 22 73 00 58 60 00 06` with calls `5e 05 14 c6` / `5e 05 16 fe` follows `04B1CE 40 1a`. 0 refs. The BE24 hit `05FADA 6b 04 b1 d4` is `mov.w @0xB1D4:16`. |
| `04B830`–`04B84D` | 30 | digit-parser family `04B7F4`/`04B812`/`04B830` | This is the 2-digit entry `7a 03 00 00 00 00 f4 02`. The 3-digit entry `04B812` (`f4 03`) is called 9 times (`025AA0`…`0634DA 5e 04 b8 12`). `04B830` has 0 refs. |
| `04BB78`–`04BB85` | 14 | entry family `04BB54`…`04BB86` | Bytes `fc 80 6a 8c a7 c8 7a 02 00 ff a8 82 40 0c`. The only caller, `04BAEE 5e 04 bb 78`, is in arm `04BACE`, which follows `04BACC 40 4a` and has 0 refs. The live twin `04BAF4` calls `04BB6A` (`04BB14`), and siblings are called at `047332`/`045654`. |
| `04C198`–`04C1BD` | 38 | entry, sibling of `04C172` | Starts `7a 02 00 ff a8 88`. The only caller, `04C04A 5e 04 c1 98`, is in arm `04C02A`, which follows `04C028 40 4a` and has 0 refs. `04C172` is called from `04692C`/`0469DE`/`04C070`. |
| `04F534`–`04F539` | 6 | span `04F4B0` | `fd 1e 40 02 fd 1d` follows `04F532 40 06`. 0 refs. |
| `04F87C`–`04F8AB` | 48 | entry family `04F85C`…`04F8A4` | Six entries `7a 01 00 00 00 {00,0c,18,24,30,3c}` + `bra 0x4F8DA`. 0 refs. Siblings `04F85C/64/6C/74` are called from `04F5E8`/`04F61E`/`04F654`/`04F68A`. The `beq`/`bhi` "edges" at `04F82E`/`04F832` are bytes of the string `"MSG GRP BLN "` at `04F82A` (`4d 53 47 20 …`), which `04F7D2 01 00 6b 24 00 04 f8 2a` reads as data. |
| `04F8DA`–`04F905` | 44 | shared body of the dead entries above | `79 04 00 01 6b 84 b0 50 …`. Its only inbound edges are the six `bra` from `04F882`…`04F8AA`. It follows `04F8D8 40 2c`. |
| `050812`–`050825` | 20 | span `0507AC` | `5e 01 d0 fc fc 05 6a 8c a9 f9 … 5e 05 09 5a` follows `050810 40 14`. 0 refs. |
| `050CD0`–`050CD3` | 4 | span `050C9C` | `5e 03 ff a0` follows `050CCE 40 04`. The only inbound edge is `050C6E 47 60` in `050C68 6a 0c a5 07 ac 00 47 60`, which follows `rts 050C66` and has 0 refs. The live entry `050C9C` is called from `02A9C2`. |
| `05291E`–`052937` | 26 | entry family `0528F2`/`0528FC`/`05290E`/`05291E` | Entry `7a 03 00 07 00 00 6a 02 a4 f7` follows `05291C 40 1a`. 0 refs. Only `05290E` is called (`052AFA`/`052B06 5e 05 29 0e`). |
| `0532BA`–`0532CD` | 20 | span `05327C` | `7a 06 00 ff 3d ab fc 00 68 ec 7a 06 00 ff 3d ac fc 00 68 ec` follows `0532B8 40 14`. 0 refs. |

### SPLIT-TAIL (20 B): the fnindex span holds the tail of a routine whose head is outside it and unreferenced

| Run | B | Head | Evidence |
| --- | ---: | --- | --- |
| `045D88`–`045D8D` | 6 | `045D18 68 1b ab 2c 47 6a` | `0b 01 fc 00 40 06` is the target of `045D1C beq`. The head follows `rts 045D16` and has 0 refs. This is L3's routine; its `045D1E` (106 B) and `045D8E` (8 B) are already demoted. |
| `04B856`–`04B863` | 14 | `04B7F4 7a 03 00 00 00 00 f4 04` (4-digit entry; unproven, unnamed; IDA `sub_4B7F4`) | `6c 2b 19 d3 47 08 79 04 03 e8` is the ×1000 step. The only inbound edge is `04B810 40 44`. The head follows `rts 04B7F2` and has 0 refs. The live 3-digit entry `04B812` skips it (`04B82E 40 34` → `0x4B864`). |

### DATA-MISTYPED (2 B)

| Run | B | Data | Reader |
| --- | ---: | --- | --- |
| `03D1C8`–`03D1C9` | 2 | low word of the packed-BCD constant `00 40 00 00` at `03D1C6` | `03D1B4 7a 06 00 03 d1 c6` (`mov.l #0x3D1C6,er6`) → `03D1BA 5e 03 f9 4c`. `0x3F94C` is a 32-bit BCD subtract `@er5 -= @er6` that reads `@(2,er6)` (`03F954 6f 64 00 02`) and `@er6` (`03F966 69 64`). |

### Same dead code outside the proven mask (no demotion; for the next seed's typing)

| Range | B | State |
| --- | ---: | --- |
| `033494`–`033499` | 6 | named |
| `03EF64`/`03EFA4`/`03EFE4` | 3×4 | unnamed |
| `04B7F4`–`04B811` | 30 | unnamed |
| `04BACE`–`04BAF3` | 38 | named |
| `04C02A`–`04C04F` | 38 | named |
| `050C68`–`050C9B` | 52 | named |
| `0528F2` / `0528FC` entries | — | named |

### Corrections to earlier docs

- **Doc 100 (L3), Method 2, "6 proven `bra/bsr rN.w`".** Five of the six are oracle decodes at odd offsets *inside*
  other instructions, not instructions:

  | Claimed site | Decoded as | Real instruction containing it |
  | --- | --- | --- |
  | `02B3F8` | `5d 26` | `02B3F6 5e 06 5d 26` (`jsr @0x65D26`) |
  | `02B450` | `5d 66` | `02B44E 5e 06 5d 66` (`jsr`) |
  | `05569C` | `59 76` | `05569A 5e 05 59 76` (`jsr`) |
  | `0559B4` | `59 06` | `0559B0 7a 05 00 ff 59 06` (`mov.l #0xFF5906,er5`) |
  | `0559CA` | `59 06` | `0559C6 7a 06 00 ff 59 06` (`mov.l`) |

  Only `076308 59 06` is a reached `bra r0.w`. L3's conclusion (no register-relative branch reaches its runs) is
  unaffected.
- **No other correction.** L3's ADJACENT figures (`045D88` 6 B, `0460C2` 110 B; "504 B in 18 spans" for
  `0x030000`–`0x04FFFF`) are exact: my 18 runs below `0x050000` sum to 504 B. The L-wave README's run sizes
  (`0x0460C2` 110 B, `0x03D0EE` 98 B) match.

## USB relevance

None.
- No run touches the USB module `0xFFEE00`–`0xFFEE53`, the DSP SCI-C `0xFFFF88`, the link SCI `0xFFF610`/`0xFFFF60`,
  the DMAC, or the closed window.
- The RAM cells the runs write (`FFAA3E`, `FFAC76`, `FFA7C8`, `FFA51E/F`, `FFB050`–`FFB05B`, `FFA9F9`, `FF3DAB/AC`,
  `FF9074`) belong to frequency, band, display and GPS/APRS-text state.
- The `03D0EE` case is an 800 MHz band-plan block that this build never selects (Inferred).
- Mission answers are unchanged.

## Open

1. **Apply M3-R1 image-wide** (`proposed-rules.tsv`): re-measure addend A the way RC and D already are. In this scope it
   removes exactly the 574 B. The other two M lanes' ranges should give the rest of the 1,692 B.
2. Next seed: demote the 22 ranges in `proposed-demotions.tsv` (574 B, byte sum 49,600) and retype `03D1C6`–`03D1C9`
   as a 4-byte BCD constant. Optionally mark the unproven companions above as dead-code typed.
3. Arithmetic pointer construction (`base + offset` into RAM tables) is still unscanned image-wide. It is a low prior for
   these runs, but it is the one form no lane has covered.

### Files

| File | Content |
| --- | --- |
| `ida\out\punr-mid\runs.tsv` | 22 runs: class, H9 rule, unit, inbound edges from reached code, descent reach, evidence |
| `ida\out\punr-mid\proposed-demotions.tsv` | exact ranges, P6/N6 counts, byte sums, sha256, total and ledger line |
| `ida\out\punr-mid\proposed-rules.tsv` | M3-R1 (re-measure A), M3-R2 (no reach inheritance between multi-entry siblings), M3-R3 (BCD-operand typing), M3-R4 (no missing edge) |
| `ida\out\punr-mid\refs-detail.tsv` | every inbound row for the 194 instruction-start targets |
| `ida\out\punr-mid\work\` | `m3_rules.txt`, `m3_even.txt`, `m3_descent.txt`, `m3_ida_heads.tsv`, `m3_ida_xrefs.tsv`, `m3_verify.txt` |
| `ida\out\punr-mid\offline\m3_*.py` | common loaders, disassembler, refs scanner, rule attribution, descent re-run, tables, verifier (all read-only) |
| `ida\jobs\m3_punr_xrefs.py` | read-only IDA job (DB `M3_PUNR_MID`) |

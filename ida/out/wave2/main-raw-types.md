# MAIN raw remainder — lane W2-8 re-typing of the residual `other` runs

> Wave-2 lane W2-8, continuing lane 5 (`docs\deep\22-main-raw.md`). Owner-side,
> read-only static analysis of the decrypted FT3DR/E ver 1.02 **MAIN** image
> (`decrypted\FT3D_MAIN_ver102_EXP.bin`, H8SX/1668R, `h8s300a`, big-endian,
> base 0, content region `0x000000`–`0x07B753`). Nothing written to any radio.
>
> Machine table: `ida\out\wave2\main-raw-types.tsv` — the complete **3,854-row**
> run table, columns `start end size type source evidence`, `source` = `lane5`
> (carried through unchanged) or `w2-8` (newly typed here).
> Helper data (IDA-produced, my job DB `W2_MAIN_RAW2`):
> `ida\log\jobs\W2_MAIN_RAW2\w2_8_task2.tsv` (per-function re-validation) and
> `w2_8_probe2.tsv` (decode-probe of every residual `other` run).
> Model: claude-opus-4-8 (Opus 4.8).

## Verdict

Lane 5 left **997 runs (7,844 B) as `other`**. I newly typed **473 of them
(3,824 B moved out of `other`)** using the raw image bytes, neighbouring typed
runs, an IDA decode-probe, pointer target-range tests, ASCII density and byte
shape. **524 runs (4,020 B) remain `other`**: 508 irreducible sub-16-byte
interstitial fragments plus three large mixed code/data blocks (3,122 B), and 16
runs (898 B) inside the closed CDC-ACM/DSP-loader service window that get a
byte-class label only. No new *class* of content appeared — the residue resolves
into the same families lane 5 established (recovered code fragments, pointer/
parameter tables, string-table structure, padding). Separately, re-validating
lane 5's 1,596 recovered functions against the literal definition (a vector/call/
jump reaches it, OR a clean prologue+return byte-decode) raises the validated
count from **745 to 1,197 (net +452)** — almost entirely because 446 functions
are reached through MAIN's indirect jump/switch dispatch tables, which lane 5's
direct-xref check did not count.

## Method

- **Task 1 (re-typing).** `ida\jobs\w2_8_classify.py` (pure Python) reads lane 5's
  `runs.tsv`, the MAIN image (base 0 ⇒ file offset = address), lane 5's
  `functions.tsv`/`jumptables.tsv`/`switch_tables.tsv` (for pointer target tests),
  and the IDA decode-probe. It carries every non-`other` run through **unchanged**
  and applies, in priority order, to each `other` run outside the closed window:
  (1) **code** — IDA decode-probe shows a clean full-length decode of ≥2
  instructions ending in a return/call/branch or referencing an in-range target;
  (2) **fill** — single padding byte, or ≥75 % 0x00/0xFF/0x20, or an all-padding
  run ≤12 B (short alignment gaps below lane 5's 4/8-byte thresholds);
  (3) **string** — ≥80 % printable with a letter, or a printable field between two
  string runs; (4) **pointer table** — 4-byte-aligned BE dwords all in ROM
  `[0x400,0x07B754)` or on-chip RAM `[0xFE0000,0x1000000)`, confirmed by a
  function-start hit or a pointer-table neighbour; (5) **parameter table** — small
  ints interleaved in a pointer/record array, a data island in a 0x00-padded
  table region, a byte-ramp/monotonic LUT (≥20 non-decreasing bytes), a 16-bit BE
  value table, or a small byte/index table. Anything left is `other` with a
  one-line reason.
- **Decode-probe.** `ida\jobs\w2_8_probe2.py` on a private copy of `MAIN_RAW`
  (`--copy-from ida\db\jobs\MAIN_RAW\MAIN_RAW.i64` → `W2_MAIN_RAW2`) linearly
  decodes each residual `other` run with `ida_ua.decode_insn`. Note: these bytes
  are IDA-undefined, so `print_insn_mnem` returns "" even on a valid decode;
  validity is taken from `size>0 and itype!=0`, mnemonics from
  `insn.get_canon_mnem`. **Closed boundary honoured:** the CDC-ACM / USB↔DSP-
  download service window **`0x078106`–`0x07B753`** is never probe-decoded; its 16
  residual `other` runs keep a byte-class label only ("service-window fill/data,
  closed"), with no protocol or content detail.
- **Task 2 (re-validation).** `ida\jobs\w2_8_probe.py` on the same DB independently
  recomputes, for all 1,596 functions in lane 5's `recovered-functions.tsv`:
  `XrefsTo` (all + code-flow via `.iscode`), membership in the jump/switch/vector
  target sets (built from `main-full\xrefs.tsv`, `jumptables.tsv`,
  `switch_tables.tsv`, `vectors.tsv`), and a fresh body decode (first mnemonic,
  insn/ret/call/branch counts, bad-byte count). It then applies the literal
  definition and diffs against lane 5's flag.
- **What did not run.** No writes to any lane-5 file, the shared `.i64`s, or
  `ida\db\radio\`. No self-write / SDR / band-unlock questions reopened. No
  Hex-Rays (H8S). Byte-sum of the output table verified `== 226,212`.

## Findings — Task 1

### Byte accounting (unchanged runs carried through; `other` re-typed)

Untyped (`other`) at start: **997 runs, 7,844 B.** Newly typed by w2-8:

| New type | Runs | Bytes | How identified |
| --- | ---: | ---: | --- |
| parameter table | 316 | 2,862 | 16-bit BE value tables, byte/index tables, data islands in 0x00-padded regions, one byte-ramp LUT |
| code | 66 | 526 | clean full decode ≥2 insns ending in ret/call/branch (embedded code fragments the sweep missed) |
| fill | 66 | 265 | short 0x00/0xFF/0x20 alignment padding below lane 5's length thresholds |
| string | 20 | 139 | recovered labels + string-table field/placeholder padding |
| pointer table | 5 | 32 | short in-range BE-dword pointer runs (some confirmed function-start targets) |
| **total newly typed** | **473** | **3,824** | |

Resulting full-table type totals (3,854 runs, 226,212 B): recovered code 1,298 /
100,125 B · **code (w2-8) 66 / 526 B** · pointer table 289 / 35,264 B · parameter
table 726 / 38,619 B · string 450 / 36,154 B · fill 501 / 11,504 B · font 0 ·
**other 524 / 4,020 B**.

### Remaining `other` (524 runs, 4,020 B) — why

- **508 non-closed runs, 3,122 B.** Of these, 505 are sub-16-byte interstitial
  fragments (constant-pool tails, 2–3-byte data/operand remnants, mixed
  code/data between functions) with no dominant byte-class — irreducible under the
  "outside functions.tsv" run definition, matching lane 5's assessment. The other
  3 are large **mixed code/data blocks** that do not decode cleanly from the run
  start (leading code stub + embedded table): `0x001825` (539 B, between a string
  table and a pointer table), `0x0562C8` (287 B, USB stack-A support code with an
  embedded table), `0x076B50` (157 B, loader-adjacent code+data; references into
  the service window, left neutral). A byte-exact hand split of these was not done
  (low value; `0x076B50` abuts the closed region).
- **16 closed-window runs, 898 B** (`0x078106`–`0x07B753`): byte-class only by the
  service-window rule; labelled "service-window fill/data, closed", not analysed.

### Notable newly-typed tables (addresses)

- **`0x02AEFA` (12 B) — pointer table**: three BE dwords `0x6067C, 0x6038C,
  0x60354`, two of them confirmed function starts. A 3-entry code-pointer array
  lane 5 dropped for being under its 4-entry threshold.
- **`0x003A84` (153 B) — parameter/calibration LUT**: a 5-byte header
  (`84 A1 C8 FF FF`), two byte level-ramps (`00 00 01 01 … 10`), then a 16-bit BE
  monotonically-decreasing curve (`01DE 01C3 01AA … 003C`) and a short tail
  (`06 19 2D 4B 64`). A gamma/taper-style lookup table. Odd length hid it from
  lane 5's even-length heuristics.
- **Sparse parameter region `0x02C4xx`–`0x02C7xx`**: ~40 small data islands
  (e.g. `0x02C68F` = `00 00 1E 00 01`) between 0x00 padding — a 0x00-padded record
  table; the non-zero islands are the record fields.
- **16-bit BE value tables** recovered at e.g. `0x036D14`, `0x037200`, `0x037232`,
  `0x0372CA`, `0x04E8B2`, `0x073162` (7 entries each) — parameter/step tables.
- **Recovered string-table content**: menu labels at `0x066FFF` (`BACK`/`TOP`),
  `0x06701C` (`CLEAR`), plus `.MUTE` (`0x08834D`), `.LAT ` (`0x048B7B`),
  `.log` (`0x071040`); and fixed-width blank/`---` placeholder fields inside the
  broadcast/label string tables around `0x044C65` and `0x04BE71`.
- **Embedded code fragments** (class `code`) — short thunks/epilogues the sweep
  left as data, e.g. `0x004876` (`JSR; …`), `0x02927C` (`MOV.L #imm; JMP @abs`),
  `0x0010BA` (`LDM; RTS` epilogue), `0x010008` (4 insns ending in a branch).

## Findings — Task 2 (recovered-function re-validation)

Re-checked all **1,596** functions against the literal definition. Results
(`ida\log\jobs\W2_MAIN_RAW2\w2_8_task2.tsv`):

| Outcome | Count |
| --- | ---: |
| lane 5 validated (baseline) | 745 |
| **w2-8 validated** | **1,197** |
| confirmed (lane 5 yes → w2-8 yes) | 743 |
| newly rejected (lane 5 yes → w2-8 no) | 2 |
| newly validated (lane 5 no → w2-8 yes) | 454 |
| both no | 397 |
| **delta vs lane 5's 745** | **+452 net** |

- **Newly validated (454): 446 via jump/switch-table reachability, 8 via a direct
  code xref** lane 5's per-function `XrefsTo` missed; 0 via vector, 0 via
  prologue+return. The dominant effect is definitional: lane 5 counted only direct
  `XrefsTo`, but the literal "a jump reaches it" includes targets of MAIN's
  indirect dispatch tables (`jumptables.tsv` + `switch_tables.tsv`, 1,561 distinct
  targets). Example: `0x001424` (150 insns, clean, 4 returns) is a target of the
  jump table at `0x001108` — a real, indirectly-dispatched function. This is not a
  correction of lane 5's decode, but a stricter application of the reachability
  clause.
- **Newly rejected (2):** `0x01A084` (`mov;bra`, 2 insns, no return) and
  `0x01D8F8` (`btst…`, 4 insns, no return) — each reached only by a **data**
  reference (address-taken), not a call/jump, and neither has a clean
  prologue+return, so neither meets the literal definition. Lane 5 validated them
  because its `XrefsTo(...,0)` counted the data ref as reachability.
- **Both no (397):** genuinely unreachable and no clean prologue+return — single-
  instruction `rts` stubs, mid-function fall-through blocks, and sweep/byte
  fragments. This is the low-confidence residue doc 04 / lane 5 flagged.

## USB relevance / scope

Nothing here reopens a settled question. The closed CDC-ACM/DSP-loader window was
not probed. The re-typing confirms the MAIN raw remainder is dispatch tables,
parameter/calibration data, string tables, padding and unowned code fragments —
no memory-peek surface, loader, or band/MARS unlock. The 446 table-reached
functions newly validated are the indirect-dispatch backbone a later owner
feature would hook, consistent with lane 5's "Extension" note.

## Open

- Three large mixed code/data blocks (`0x001825`, `0x0562C8`, `0x076B50`, 983 B)
  await a byte-exact code/table hand split (low value; one is loader-adjacent).
- 505 sub-16-byte interstitial fragments (~2.1 KB) remain uncharacterised by run
  definition.
- The 399 functions w2-8 leaves unvalidated (397 both-no + 2 newly-rejected, down
  from lane 5's 851) are low-confidence sweep residue — single-`rts` stubs and
  mid-function blocks; a targeted per-function disassembly pass could promote a
  few, but value is low.

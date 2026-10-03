# MAIN functions 0x038000–0x059FFF — validation, purpose (Lane W2-1)

**Range split:** this document and `ida\out\fnindex\main-high-a.tsv` cover
`0x038000`–`0x059FFF` (the high-A window). Lane **W2-2** covers
`0x05A000`–`0x07B753` in `ida\out\fnindex\main-high-b.tsv`. Together with Lane 1's
`main-low.tsv` (`< 0x038000`) the three tables span the whole MAIN content region
`0x000000`–`0x07B753`.

## Verdict

Every one of the **995** pre-existing MAIN functions with start
`0x038000 <= ea < 0x05A000` in `ida\out\main-full\functions.tsv` was covered.
**899 are validated** (880 reached by a call, jump or vector xref; 19 accepted only
on a byte-level prologue+return decode) and each carries an evidence-based purpose
line citing its start address, so `T == D == 899`. **96 of the original rows were
rejected** (zero xref *and* no register-save prologue — the residue of the earlier
forced linear sweep), plus **3 candidates recovered in-range by Stage A were also
rejected** on the same test, giving **99 rejected total**. **No new validated
function** was found in the range that `functions.tsv` was missing — the
`MAIN_FULL` pass already had complete coverage here, matching Lane 1's low-yield
result below the cut. This window is where the **communication drivers** live: the
on-chip **USB Function Module** driver and its three interrupt handlers, the four
**SCI** channels (IPC-to-SUB, DATA-jack CAT/clone, camera/GPS/BT, and the DSP
link), the **DMAC** setup for the IPC and DSP serial links, and a dense cluster of
**menu/UI table dispatchers** (eepmov block-copy + `jmp/jsr @reg`). Machine-readable
table: `ida\out\fnindex\main-high-a.tsv` (899 rows).

## Method

Private DB `W2_MAIN_HI_A`, seeded `--copy-from ida\db\jobs\MAIN_FULL\MAIN_FULL.i64`
(the 3,899-function state) and reopened. One IDA job through `ida\run_job.py`:

- `ida\jobs\w2_1_classify.py` — adapted from Lane 1's `full_l1_classify.py` with
  the window shifted to `[0x038000, 0x05A000)`. **Stage A** conservative recovery
  in-range (A1: call/jump/vector code-xref targets not yet functions — 0 added;
  A2: undefined runs that decode cleanly from an H8S prologue to a return, ≥4
  instructions, no bad decode — 3 added, all later rejected in Stage B). **Stage B**
  classifies every function `0x038000 <= start < 0x05A000`: validated test,
  per-function decode stats, an absolute-operand peripheral map, settings/RAM
  writers, callees, string refs, indirect-dispatch idiom, purpose synthesis.
  **Stage C** byte accounting in-range. Outputs `main-high-a.tsv`,
  `main-high-a-extra.tsv`, `w2_1_new.tsv`, `w2_1_counts.txt`, `w2_1_log.txt` under
  `ida\out\fnindex\`.

**Validated** test (identical bar to Lane 1, and to the assignment's definition):
`nrefs > 0` and not a data signature, OR a byte-level decode with a plausible H8S
register-save prologue (`push`/`stm`/`mov …,@-sp`/`sub …,sp`), at least one return,
≥3 instructions, zero bad decodes, and at least one structural instruction.
Zero-xref sweep candidates failing this are rejected and counted, not listed. Five
rejected starts were byte-checked in the raw image (`0x38104`, `0x3819C`,
`0x382BE`, `0x38486`, `0x39136`): each begins with a store/ALU op (`MOV.W Rs,@aa`,
`ADD.B #imm`, `BCLR`), not a register save — confirming they are linear-sweep
fragments or leaf bodies with no resolvable entry, correctly rejected. Some may be
targets of indirect jump tables IDA did not resolve; recorded as one fact, not
chased. Column layout copied from `main-low.tsv`:
`start end validated xref purpose evidence`.

Addresses are true 24-bit effective addresses; IDA's `h8s300a` module prints the
16-bit-absolute register page as `0xFFFFxxxx`. The DSP boot / CDC-ACM service
loader window `0x078106`–`0x07B753` and its CDC-ACM stack lie **outside** this
range (in W2-2's), so nothing here required the closed one-liner; a defensive guard
in the script would have applied it. The SCI-C (DSP-link) functions in range are
reported only as register touches, with no frame/protocol detail. Band-coverage /
MARS/CAP were not searched for an unlock; where a function happens to write the
stored destination index `0xFF9E1F` that is recorded as a plain register touch, no
recipe.

Did **not** run: no device access; nothing written to `decrypted\`,
`ida\db\radio\`, or the shared `.i64`s; no re-proving of settled RESUME-DEEP
answers.

## Findings

### Region character

Peripheral touches among validated functions in range (from `w2_1_counts.txt`):
`port-dir 25, port-io 19, USB 12, timer 8, SCI-A(DATA-jack) 6, SCI-B 5,
SCI-D(500k/IPC) 4, DMAC 4, SCI-C(DSP) 3, bus/clk-cfg 1`. Unlike the reset/C-runtime
and UI-state region below `0x038000`, this window is **where the serial and USB
drivers actually live**. 458 of the 899 validated functions carry a `[weak]`
structural purpose (small leaf/branch/orchestration helpers with no
peripheral/string/settings signature) — marked so, not invented; 441 carry a
concrete purpose.

### Notable subsystems (with addresses)

**On-chip USB Function Module driver — `0x054C44`–`0x0557A2`** (register block
`0xFFEE00`). Three interrupt handlers match the brief's vector map exactly:
`sub_54D50` (vector 234), `sub_54EC2` (vector 235), `sub_54CFA` (vector 238).
`sub_54D50` writes the personality selector `0xFF813A` and RX/TX state
(`0xFF8156/8183/FFB094/FFB09E`); `sub_54EC2` and `sub_557A2` drive the bulk
endpoint queues (`0xFF8184/89CD/89CE`). This is the shared hardware driver behind
both device personalities; the CDC-ACM protocol layer and DSP loader are out of
range and stay closed.

**SCI-D — IPC link to SUB (`0xFFF610`, ~500 kbaud).** `sub_446BE`, `sub_44A70`
(RX/TX + status `0xFFF614/615`, writes `0xFF8146`); DMA-driven at `sub_482D4`,
`sub_48328` (DMAC channel `0xFFFC00/04/0C/14`).

**SCI-A — DATA-jack CAT/clone/debug (`0xFFFE90`).** `sub_45186`–`sub_45462`:
init/baud with port-dir `0xFFFB95`, RX/TX (`0xFFFE92/93/94/95`), settings
`0xFF8C27/8C28/8DDE`, ring buffers `0xFFB03A`–`0xFFB044`.

**SCI-B — camera/GPS/BT class channel (`0xFFFF60`).** `sub_454E2`, `sub_45520`,
`sub_4556E`, `sub_48BF2`, `sub_510DA` (port-dir `0xFFFB90`, buffers
`0xFFB0D2/0D4`, flag `0xFF814E`).

**SCI-C — DSP link (`0xFFFF88`, clocked-sync).** `sub_4834E`, `sub_483D2` (DMA to
DSP, DMAC `0xFFFC20`+), `sub_5615C` (writes selector `0xFF813A` and `0xFF815E`).
Register touches only; no frame detail.

**DMAC setup — `0x0482D4`–`0x0483D2`.** Programs the three DMAC channels for the
SCI-D (IPC) and SCI-C (DSP) transfers.

**Menu/UI table dispatchers — `0x05290E`–`0x0534E0`.** A dense cluster using
`jmp/jsr @reg` indirect dispatch plus `eepmov` block copy, writing menu-state RAM
`0xFFBBE8/FFBC2C` and `0xFFA4F5/A4F7`. These are the settings-screen state machines
for this region (e.g. `sub_53110/5314A/53300/53384/5345C/534E0`).

**APRS / emergency text.** `sub_4F792` copies message/group/balloon labels
("MSG GRP BLN"@`0x04F82A`) and writes `0xFFA4B6`; `sub_52C8C`/`sub_52E4E` handle an
emergency mode ("Emg"@`0x003EC0`) and write settings `0xFF9E08/FF9E1F/FFA9C4`
(`0xFF9E1F` = stored destination/band index — factual touch only).

### Recovered / new functions

Stage A added 3 in-range candidates from clean undefined runs; all 3 failed the
Stage-B validation bar and were rejected. **Zero** validated functions in range are
absent from `functions.tsv` (`w2_1_new.tsv` is empty apart from its header). The
`MAIN_FULL` pass had complete coverage of this window.

## Counts

- **T** (validated, `0x038000 <= start < 0x05A000`): **899** (880 reached by
  xref/vector, 19 byte-validated only)
- **D** (validated with a purpose citing the start address): **899**
- **Rejected** (zero-xref sweep residue, no prologue): **99** (96 original rows +
  3 Stage-A candidates)
- **New** (validated in range, missing from `functions.tsv`): **0**
- **Instruction bytes inside validated functions in range**: **80,850**
- Content bytes in range (`0x038000`–`0x05A000`): **139,264** (non-`0xFF`: 135,727;
  the whole range is inside the content area — fill begins at `0x07B754`)
- Derived MAIN instruction share in range: 80,850 / 139,264 = **58.06%**
- Original `functions.tsv` rows in range: 995 → 899 validated + 96 rejected = 995
  (all accounted for)
- Weak vs concrete purposes: 458 `[weak]` / 441 concrete

Machine-readable tables under `ida\out\fnindex\`: `main-high-a.tsv` (899 rows,
the deliverable index), `main-high-a-extra.tsv` (per-function regs/callees/
ram_writes/strings), `w2_1_new.tsv` (empty), `w2_1_counts.txt`.

## Open

1. The 458 `[weak]` helpers carry only a structural purpose; a caller-context pass
   (who calls them, with what constants) would upgrade many "caller/orchestration
   helper" and "branch-heavy compute helper" entries — e.g. the large unclassified
   compute bodies `sub_542AC` (212 insn), `sub_3F778` (194 insn), `sub_45A64`
   (109 insn) — to concrete purposes. Left as Lane 1 did.
2. The 99 rejected zero-xref bodies could be re-tested as indirect jump-table
   targets: resolving the menu/UI dispatch tables (`sub_53110` cluster) may reach
   some of them and flip them to validated.

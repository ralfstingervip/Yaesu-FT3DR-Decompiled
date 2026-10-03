# MAIN proven descent with pointer-array and RAM-callback edges (Lane H9)

> Lane H9. Private DB `H9_DESCENT` (`ida\db\jobs\H9_DESCENT\H9_DESCENT.i64`), seeded with
> `--copy-from ida\db\jobs\H1_RECOUNT\H1_RECOUNT.i64` (processor `h8sxa`, 0 odd code heads). It was used
> read-only, through `ida\jobs\h9_descent.py` and `--reopen`. No other database was opened and `run_ida.py` was not run.
> Offline scripts are in `ida\out\main-descent\offline\`: `descent.py`, `masks.py`, `classify.py`, `analyze.py`,
> `breakdown.py` and `cmp_h1.py`. Tables are in `ida\out\main-descent\`. Image: `decrypted\FT3D_MAIN_ver102_EXP.bin`.
> Base is 0, so file offset = address. Static analysis only: no image was modified, and nothing was connected
> to or written to a radio. The closed window `0x078106`–`0x07B753` was not analysed. Its bytes are excluded from
> every count below. Model: claude-opus-5-5 (Claude Opus 5.5).

## Verdict

**MAIN proven code is 365,570 B (72.29 % of content), not 375,469 B. That is −9,899 B against H1.** Named or typed
**rises to 497,139 B (98.31 %, +4,431)**, and the **headline becomes 935,439 / 1,029,972 = 90.82 %** (H1 90.39 %).
The proven-code figure falls for three reasons:

- **Lane-5 "recovered code" was over-credited.** The new pointer-array and RAM-callback edges reach only **1,570 B**
  of H1's 16,784 unreached bytes.
- **H1's reach was partly false.** H1 reached another **2,167 B** of recovered code only through table rows that are
  data. H2 excluded 306 such rows. This lane found **six more data tables**, each Confirmed from its load site or its
  bytes: `0x014D6A`, `0x014DAA`, `0x020D74`, `0x025496`, `0x0254D0` and `0x05584A`. The last one points at the
  USB configuration descriptors (`09 02 20 00 01 01 00 c0 32 …` at `0x05585E`).
- **H1's proven figure double-counted 252 B.** These are 224 B of recovered code that is also G1 tier A, and the
  28 B doc-33 bytes.

In total **17,080 B of recovered-code runs and 624 B of F1 rows are demoted**. Against that, **8,057 B are newly
proven**: code that the descent reaches but that sat in no proven addend. Most of it is F1 "residual" functions
(5,864 B), plus H3's 13 PROVEN-PTR rows (598 B) and H5's F00A builder (72 B).

**H3's 714 B of weak F1 proofs:**

- **670 B are re-proven** by other edges, with every path Confirmed.
- **44 B are demoted.** These are row `0x023602` (28 B, wholly unreached), the 12 B prefix of `0x02556E`, and the
  2 B mid-instruction starts of `0x000E20` and `0x029DF4`.

Two of H2's three data-table-only F1 proofs are also demoted: `0x000760` and `0x000800`, 68 B. The third,
`0x001740`, is re-proven through the RAM hook `0xFF811A`.

## Method

1. **Decoder.** The descent walks G1's binutils H8SX oracle (`h8s-decode\work\bu_all.tsv`), using the same flow rules
   as H1's `reach.py`.
   - **IDA cross-check (Confirmed):** `h9_descent.py` decoded all **113,541** reached instructions with IDA `h8sxa`.
     The result has **0 length mismatches** (`work\ida_len_check.tsv` is empty, and `work\ida_meta.txt` records 0).
   - 1,422 reached bytes are not IDA code in H1_RECOUNT. They are mostly G1-typed "parameter table" code and
     RAM-callback targets.
   - The descent has **0 overlapping instructions** (no reached instruction starts inside another one).
2. **Roots** (`descent.py`):
   - reset `0x2092` and the 30 handler vectors, including NMI `0x267C` (it reaches `0x7FF6`, as H5 found);
   - every entry of the F1/W2 tables (`main-full\jumptables.tsv`, `switch_tables.tsv`), read in full from the image.
     The sentinel `0x3FFA0` is dropped. **H2's 306 excluded rows** (`h8sx-seed\table-xrefs-excluded.tsv`) are
     removed, and so are this lane's 6 data tables (`H9_EXCL_TABLES` in `descent.py`, with evidence);
   - the fnindex-validated starts, minus H1's 30 junk or leading-text spans and the mid-instruction `sub_6946`.

   **F1 starts are not seeded.** Each F1 row must be re-reached through a table entry, flow, or a new edge.
3. **Gated edges.** Each is added only when its referencing instruction is itself reached, and the process iterates
   to a fixed point:
   - **H3 arrays** (`ptr-arrays\arrays.tsv`, `xrefs.tsv`): tiers A and B. A tier is gated on a ref instruction listed
     in `arrays.tsv`, or on any reached `mov.l @(base:32,ERs)` or `mov.l #base`. Tier C (no reference) is excluded.
   - **RAM-callback cells.** A cell X qualifies when a reached `mov.l @X,ERn` is followed within 4 instructions by
     `jmp/jsr @ERn`. Each reached `mov.l #imm,ERn` followed by `mov.l ERn,@X` then adds an edge to `imm`. Four cells
     were found: `0xFF811A` (`0x0028DA: 01 00 6b 06 81 1a 59 60`), `0xFF811E` (`0x0028EC`), `0xFFB288`
     (`0x053692: 01 00 6b 06 b2 88 59 60`) and `0xFFB3C6`. That gave 19 edges. One example: `0x0060BE: 7a 06 00 00 61
     7c` then `0x0060C4: 01 00 6b 86 b2 88`, giving `sub_617C`.
   - `jmp/jsr @@vec` slots. The only reached instance is `jsr @@0` at `0x015168`, which adds nothing.
   - H1's `bra r0.w` switch at `0x076308`. Its case table is at `0x078546`, inside the closed window, so only the
     edge is noted.
4. **Strict control.** Roots are the vectors alone, and the 149 tables are also gated on a reached referencing
   instruction. This reaches **356,820 B of the full descent's 363,758 B**.
5. **Inferred tier, not credited.** H3 tier C, plus every reached `mov.l #imm` whose value is an IDA code head that is
   not text. This adds only 1.6 KB.
6. **Ledger** (`masks.py`, `analyze.py`). H1's addend masks are rebuilt byte for byte; the named union reproduces
   **492,708** exactly. For every byte, the script records whether it is reached, whether it is in RC or D, and its
   class.
7. **Classification of unreached bytes** (`classify.py`), applied in this order:
   - **text:** a printable run of at least 4 bytes, plus up to 2 `00`/`FF` terminators;
   - **fill:** `FF FF`;
   - **table:** at least half the BE32 values look like pointers, or the bytes are low-diversity or smooth. This test
     applies only when a linear decode shows no `rts`/`rte` and no call into reached code;
   - **code-structural:** a straight-line oracle decode reaches a stop, or reached code, with no undecodable word;
   - **junk:** anything else.

   One further rule comes from the IDA job: a code-structural run that reached code *reads or takes the address of*
   becomes **data-referenced**. The job's `ida_span_refs.tsv` gives the `dr_O`/`dr_R` xrefs used for this.

**Not done:**

- **267 `jmp/jsr @ERn` sites** in reached code are still resolved only when a known table, array or RAM cell feeds
  them. Struct-member callbacks are not followed.
- The A addend (fnindex) and G1 tier A were not re-proven; their bytes are carried. 1,592 A bytes are unreached
  (Open 2). All G1 tier-A bytes are reached.
- SUB was not touched.

## Findings

### 1. The 16,784 B re-measured (`reached.tsv` kind `rc-new`, `demoted.tsv` addend `RC`)

| Step | Bytes |
| --- | ---: |
| H1 unreached recovered code (`recount\open-measure.txt`) | 16,784 |
| − inside the closed window | −64 |
| H1 unreached, in scope | 16,720 |
| **now reached** by the new edges: H3 tier B 986, RAM cell `0xFFB288` 506, `0xFF811E` 22, tier A 56 | **−1,570** |
| + reached by H1 only through table rows that are data | +2,167 |
| **H9 unreached recovered code** | **17,317** |
| − already removed by H1 (odd-head data, 117 + 120) | −237 |
| **Demoted from the RC proven addend** | **17,080** |

**Classes of the 17,080 B.** The first column is the part H1 also left unreached; the second is the part H1 had
reached through a data table.

| Class | H1-unreached | H1 via data table | Total | Example (Confirmed bytes) |
| --- | ---: | ---: | ---: | --- |
| code-structural (unreached, well formed) | 8,041 | 185 | **8,226** | `0x01976C` `79 01 00 00 5a 03 cc ec` = `mov.w #0,r1; jmp @0x3CCEC` landing pads; `0x076EFA` H8SX USB-module routine |
| table | 2,234 | 1,691 | **3,925** | `0x036534` `11 11 11 … 12 12 12`, monotonic byte tables at `0x0362xx`–`0x0376xx`; `0x0254F3` record block |
| text | 3,376 | 75 | **3,451** | printable runs |
| junk | 1,031 | 65 | **1,096** | `0x05585E` `09 02 20 00` (USB config descriptor head, 4 B per descriptor); odd bytes between text |
| fill | 103 | 131 | **234** | `FF FF` |
| data-referenced | 128 | 20 | **148** | `0x016D08` `00 00 00 00 15 00 00 00 …` read by `0x016C9E mov.l @0x16d08:32,er4`; `0x01E1DE` BCD table passed by `0x01E132 mov.l #0x1e20e,er5` |

**The 8,226 B of well-formed but unreached code break down as follows:**

- 7,727 B have **no reference** anywhere: no reached immediate, and no even BE32 equal to their start.
- 389 B have an even BE32 hit.
- 110 B are reached by the Inferred `mov.l #imm` tier.

They stay typed as "recovered code" (credited), but **not as proven**. Examples:

- the unreferenced H8SX module routines `0x076C0A`, `0x076EFA` and `0x077924`;
- the `0x0192A8`/`0x01933A`/`0x01976C`/`0x019976` thunk blocks (`79 01 nn nn 5a 03 cc bc`);
- H5's dead F280 builder `0x009534`–`0x009562` (46 B, Confirmed unreached).

### 2. Six more data tables among the 149 (Confirmed; `descent.py` `H9_EXCL_TABLES`)

| Table | Evidence |
| --- | --- |
| `0x014D6A`, `0x014DAA` | Load sites `0x014CD8` and `0x014CEE`: `mov.l @(0x14daa:32,er4),er5`, then `add.l er3,er5`, then `mov.b @er5,r3l`. This is a byte lookup. The targets `0x015166`.. are character maps (`b8 b5 c1 b2 c2 c3 …`). |
| `0x020D74` | Entries `0001000a 00014382 00004394`, followed by `45000001 …`. `0x01000A` is mid-instruction (inside `0x010008 mov.b r4l,@0xa9f1:16`), and `0x004394` is `ff ff ff ff`. These are the only 2 overlapping instructions the earlier descent produced. |
| `0x025496` | `0x025464 mov.l @(0x25496:32,er1),er5`, then `add.l er4,er5`, then `mov.b @er5+,r3l`. These are record pointers to `0x0254CE`.. = `0000 0000 ff00 …`. |
| `0x0254D0` | `0000ff00` ×4 inside that record block |
| `0x05584A` | Targets `0x05585E`/`7E`/`9E`/`BE`/`DE` = `09 02 20 00 01 01 00 c0 32 09 04 00 00 02 ff 01 ff 00 07 05 …`, which are **USB configuration, interface and endpoint descriptors**. H3 had already rejected this table. Lane 5 typed 4 B of each descriptor as "recovered code", and IDA `h8sxa` has them as code. |

Also Confirmed: fnindex `sub_6946` starts inside `0x006944: 5e 00 85 da` (`jsr @0x85DA`). Its bytes are reached
from `0x006944`, so no bytes change.

### 3. H3's 714 B of weak F1 proofs (task 3; `reached.tsv` kind `f1-row`, `work\breakdown.txt`)

| F1 row | B | Reached | Re-proving edge (Confirmed path) | Verdict |
| --- | ---: | ---: | --- | --- |
| `000E20` | 26 | 24 | true entry `0x000E22`, flow from fnindex `0x030FA4` | 24 kept, 2 demoted |
| `001FE0` | 10 | 10 | instruction at `0x001FDE` (row starts +2); RAM hook `0xFF811E` (`0x0315CE: 7a 04 00 00 1f ea; 01 00 6b 84 81 1e`) | kept |
| `002020` | 48 | 48 | `0x00201E`, the same `0xFF811E` hook chain | kept |
| `005050` | 10 | 10 | flow from table `0x007814` | kept |
| `006040` | 6 | 6 | flow from table `0x007814` | kept |
| `023602` | 28 | 0 | none. The only hit is a BE24 value at `0x078570`, in the closed window. Bytes: `aa 56 5e 03 ed aa … 54 70` | **demoted 28** |
| `02556E` | 52 | 40 | flow from table `0x012268` | 40 kept, **12 demoted** |
| `029DF4` | 14 | 12 | `0x029DF6` ← table `0x02A1C8` | 12 kept, 2 demoted |
| `032D8E` | 94 | 94 | flow from table `0x02F288` | kept |
| `032E8E` | 114 | 114 | flow from table `0x030DA8` | kept |
| `034644` | 48 | 48 | `0x034642` (H1 re-attribution) | kept |
| `038104` | 92 | 92 | `0x038102` (H1 re-attribution) | kept |
| `0382BE` | 76 | 76 | flow from table `0x030DA8` | kept |
| `03FEDC` | 16 | 16 | flow from table `0x012268` | kept |
| `046B84` | 12 | 12 | `0x046B82` ← table `0x01109C` | kept |
| `04AAAA` | 30 | 30 | `0x04AAA8`, flow from fnindex `0x04A58C` | kept |
| `06AC14` | 38 | 38 | `0x06AC12` ← table `0x06AC3A` | kept |
| **Total** | **714** | **670** | | **44 demoted** |

Other rows with a weak proof:

| F1 row | Status |
| --- | --- |
| `0x000760` (52 B) | **Demoted**: unreached, its only proof is H2's data table `0x00F020` |
| `0x000800` (16 B) | **Demoted**: unreached, its only proof is H2's data table `0x01DE24` |
| `0x001740` (68 B) | **Re-proven** through `0xFF811A`: `0x02FB4E: 7a 04 00 00 17 1c`, then `0x02FB54: 01 00 6b 84 81 1a`, then the hook at `0x0028DA` |
| `0x01BF28` (16 B) | **Demoted**: still unreached (BE24 survivor in H3) |
| `0x06DBE0` (2 B) | **Demoted**: still unreached (BE24 survivor in H3) |

### 4. F1 row demotion (624 B, `demoted.tsv` addend `D`)

| Reason | B |
| --- | ---: |
| H2 entry moves: prefixes before the table-proven entry, for example `005798` 16, `00589A` 36, `01682E` 30, `018718` 62, `017514` 20, plus 2 B mid-instruction prefixes | 292 |
| Other 2–16 B prefixes and unreached tails, for example `06F586` 46 (H2 "listed"), `050A3C` 16, `051408` 16, `002D2C` 12, `00FC0E` 14, `02B39E` 14 | 202 |
| H2 data-table rows `0x000760` and `0x000800` | 68 |
| Weak-714 rows (Section 3) | 44 |
| BE24 survivors `01BF28`, `06DBE0` | 18 |

**H2's ~98 start corrections are folded in here, by byte mask, so nothing is counted twice.**

- A row's bytes leave D only where the descent does not reach them.
- H1's own text-trimmed rows start at their corrected entry in `proved-corrected.tsv`, so their text is not counted
  again.
- H2's "+2 into MOV.L" rows (`034644`, `038104`, `04F3A4`, `06AC14`) are reached and stay.

### 5. Newly proven bytes (8,057 B; `reached.tsv` kind `new-proven`)

| Where | B |
| --- | ---: |
| F1 `residual.tsv` rows (not credited before): 5,860 not named + 4 named | 5,864 |
| W2-8 "parameter table" (G1: code; named, not proven) | 1,502 |
| W2-8 "other" (205 named, 138 not) | 343 |
| F2 "code" | 200 |
| IDA code outside any function | 78 |
| W2-8 "string" or "fill" that decodes as reached code, for example `0x00D18E: 7a 05 00 00 d2 2a` | 70 |

These bytes include several items found by other lanes:

- **H3's 13 PROVEN-PTR ranges.** 598 of their 608 B are reached and all 598 are new; 10 B are unreached (`0x01026E`
  2, `0x073172` 8).
- **H3's 8 REACHED-OVERSPLIT starts.** All are reached.
- **H5's F00A builder** `0x0085DA`–`0x008622` (72 B), reached from table `0x007814` slot `0x007BE0`.

**Double count.** H3's "+570 B" is not added separately; it is inside the 8,057. The 38 B H3 attributed to G1
(`0x01EED0`–`0x01EEF6`) are in no ledger mask, so they are counted once, here.

### 6. Ledger delta on H1 (`ledger-delta.tsv`)

| Term | Bytes |
| --- | ---: |
| MAIN proven code, H1 | 375,469 |
| double count: doc-33 bytes inside H1's published-basis A | −28 |
| double count: RC ∩ G1 tier A (`0x02F2E0`–`0x02F35E`, `0x030E00`–`0x030E62`) | −224 |
| recovered code not reached | −17,080 |
| F1 row bytes not reached | −624 |
| reached bytes in no proven addend | +8,057 |
| **MAIN proven code, H9** (asserted equal to the byte union) | **365,570** = 72.29 % of content, 94.10 % of H1's 388,490 decodable |

| Term | Bytes |
| --- | ---: |
| MAIN named or typed, H1 | 492,708 |
| RC junk → `other` | −1,096 |
| D unreached code with no proof, and D junk (unvalidated function bytes, treated as F1 residual) | −549 |
| reached bytes outside every named mask | +6,076 |
| **MAIN named or typed, H9** | **497,139** (98.31 %) |
| **Headline** | **935,439 / 1,029,972 = 90.82 %** |

Notes on the named figure:

- RC text, table, fill, data-referenced and well-formed bytes stay credited under their new type.
- D text, table and fill bytes are retyped and stay credited.

## USB relevance

- **Everything USB.** Three points:
  - Table `0x05584A` is the USB configuration-descriptor pointer list (5 descriptors at `0x05585E`–`0x0558FE`). Its
    user, `0x05510C: mov.l @(0x5584a:32,er5),er5`, does not dispatch: it branches to `0x055144`, and `0x055148`
    stores ER5 as a descriptor pointer (`mov.l er5,@0xb09e:16`). Confirmed.
  - The vector-235 state machine (`0x054FF8` → array `0x055002`) and the `0x056B8A` dispatch (`0x056B64`) are reached,
    and all 12/12 and 28/28 of their targets are reached through the H3 arrays.
  - The H8SX USB-module routines `0x076C0A`, `0x076EFA` and `0x077924` remain **unreached**: no reference was found in
    scope (outside the window). That matches G1 Open 3, which says the module's callers are in the closed window.
- **Interrupt hooks.** Vectors 88 (`0x28D0`) and 97 (`0x28E2`) jump through the RAM hooks `0xFF811A` and `0xFF811E`,
  which the application installs at runtime from table `0x001108` (`0x0010D6`) and from `0x02FB4E`/`0x0315CE`.
  Inferred: these are serial-port receive hooks, because `2c 40` = `mov.b @0x40:8` (port register `0xFFFF40`). This
  lane did not check that further.
- **No change** to the SDR or DSP answers. No new USB endpoint, descriptor or transport was reached.

## Open

1. **Resolve the 267 `jmp/jsr @ERn` sites** that no table, array or RAM cell feeds, especially struct-member callbacks.
   The 7,727 B of unreferenced well-formed recovered code is the ceiling for what that could add back to proven code.
2. **Re-prove the A addend.** 1,592 fnindex-validated bytes are unreached by this descent (not applied here). Look also
   for more data tables among the 149: `0x02941C`, `0x0357CC` and `0x07308C` each reach non-IDA code exclusively
   (per-table exclusion test, `ida\out\main-descent\work\excl_all.txt`, pre-exclusion run: 56, 20 and 36 B).
3. **Block copy `0x01A080` → RAM `0xFF476E`, 0x898 B.** The copy is at `0x03DE38`–`0x03DE48`. The source decodes as
   `mov.l #imm; bra` pairs. Settle whether this is code run from RAM or a record block.
4. Name the RAM hooks `0xFF811A`/`0xFF811E` and their installers (`0x0010D6`, `0x02FB4E`, `0x0315CE`).

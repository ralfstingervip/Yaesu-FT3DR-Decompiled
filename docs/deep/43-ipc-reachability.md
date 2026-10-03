# 43 — MAIN↔SUB IPC opcode reachability: F102, F392/F3D1, SUB-only opcodes, reconciled matrix (Lane H5)

Owner-side static analysis of the decrypted ver 1.02 images on disk. Nothing was written
to any device, no image byte was changed, no shared database was opened. MAIN is H8SX
(base 0, big-endian, file offset = address). SUB is RX64M (base `0xFFC00000`,
little-endian). Model: **claude-opus-5-5**.

Tables in `ida\out\ipc-reach\`:
- `opcode-matrix.tsv`: 254 rows. Each row gives the opcode, every MAIN emission site, live
  or dead, the SUB link-layer action, the SUB classifier decision, the screen handler, a
  class, a purpose label and the prior-lane status.
- `main-sites.tsv`: 263 emission sites, each with its reach chain back to a vector.
- `generic-sender-calls.tsv`: 91 call sites of the 13 variable-opcode senders, with the
  opcode resolved at each site.
- `overcount.tsv`: the numerator check.
- SUB evidence dumps: `sub_probe.txt`, `sub_probe2.txt` … `sub_probe11.txt`,
  `sub_opbyte_cmps.tsv`, `sub_pending_uses.tsv`.
- `offline\*.py`: the raw-image MAIN scripts.

## Verdict

**F102 is live, and it is not a builder.** `0x008B7C` is an opcode rewriter: if the staged
mailbox opcode is `F101`, flag `0xFFBBE0.0` is set and `0xFF8EA0.7` is clear, it changes the
opcode to `F102` in place. The main loop then sends the frame.

On SUB, an F102 frame goes through the link-layer handler `sub_FFEDC976`, like any other
frame. That handler applies the common status bytes the frame carries and queues the
frame. The F1 classifier then sends low byte `02` to its default case (jump-table byte
`0x58` → `FFEDF360`), which returns `0xFF`. The top-level classifier then clears `[8A8E]`,
so no screen handler runs and the current screen does not change. **In effect, F102 is "F101
without a screen update".** That this is deliberate is Inferred.

**F392 and F3D1 are both reached, so nothing is over-counted (0 B).** G2 took their start
addresses from the middle of each routine:
- The F392 code really starts at `0xA15C`. It is called from `0x5840`, which is
  `T_sw_7814` slot 119, menu row `0x71`.
- The F3D1 code really starts at `0xA654`. It is called from `0x6444` in `sub_643A`, which
  is `proved.tsv` row `00643A`, slot 220.

**The real correction runs the other way.** F00A, which F1 and G2 called a dead builder, is
live. Its entry is `0x85DA`, called from `0x693C` and `0x6944`, not `0x85D6`. Its 72 B are
in no numerator table. **Numerator correction: +72 B, 0 B removed.**

**G2's list of 18 "SUB-only" opcodes was mostly an artefact of an incomplete MAIN census.**
G2 found 99 opcodes. MAIN actually emits **245 distinct opcodes, 243 of them from live code**
(202 if the 44 F2 index codes count as one). The extra sources are:
- 13 variable-opcode senders (`mov.w e3,@0xFF3D74`), which add 90 F3/F4 codes;
- builders that emit more than one opcode;
- the F200 low-byte rewrite;
- the F102 rewriter;
- a raw F00F frame sent from the NMI handler.

Of G2's 18, nine have a live MAIN sender (`F003`, `F00A`, `F10D`, `F10F`, `F115`, `F400`,
`F401`, `F402`, `F703`). Two are SUB-internal: `FF01` and `FFFE` are 2-byte frames that SUB's
own link layer builds and queues. Two are MAIN dead builders (`F501`, `F503`). The other
five have no emitter anywhere and are vestigial: `F109`, `F10A`, `F113`, `F404`, `F801`.
`F3B3` is a sixth vestigial code that G2 did not list.

**SUB does not treat the opcodes the way doc 25 and G2 assumed.**
- FC00, FE00, FFFF, F3D5 and F3D6 are handled in the link layer and are never queued, so
  the screen classifier never sees them.
- The F9–FC family slots and any high byte below `F0` classify to screen 0. They are not
  dropped.
- F000 and F001 do their work inside the classifier: they send LCD commands `0x28` and
  `0x29` and return `0xFF`.

## Method

Private databases only: `H5_SUB`, copied from `G2_SUB`. `H5_MAIN` was not created because
MAIN needed no IDA work: it was analysed from the raw image plus G1's binutils H8SX decode (`h8s-decode\work\
bu_all.tsv`, every address decoded) and G1's item/function export. IDA jobs
`ida\jobs\h5_sub.py`, `h5_sub2.py`, `h5_sub3.py` (each `auto_wait`, try/except to
`*_tb.txt`, UTF-8, `qexit(0)`); run with `run_job.py --copy-from …G2_SUB.i64` then `--reopen`.
No traceback was produced.

MAIN (raw image, scripts in `ida\out\ipc-reach\offline\`):
1. **Mailbox census.** I scanned every occurrence of `00 FF 3D 70`–`7B` in
   `0x000000`–`0x07B753` and classified the instruction that contains it. The scan found:
   - 139 stores to the opcode word: `6B Ax 00 FF 3D 74` = `mov.w Rs,@0xFF3D74:32`;
   - 1 byte store to `0xFF3D75`, through `er6` at `0x9456`;
   - 26 reads;
   - no `mov.l` stores to `0xFF3D72`.

   Every `0xFFBC2C` payload pointer that resolves is `≥ 0xFF3D94`, so those pointers never
   reach the opcode word.
2. **Value resolution.**
   - 126 stores take an immediate from `79 0r iiii` just before them.
   - 13 store `e3`. These are generic senders: `0x976A`, `0x9792`, `0x97DC`, `0x9834`,
     `0x98CA`, `0x9922`, `0x997A`, `0x99DE`, `0x9A1A`, `0x9A54`, `0x9BDA`, `0x9C16` and
     `0x9C52`.
   - All 91 call sites of those senders are `jsr`. Each one loads `e3` with
     `79 0B iiii` in a straight line before the call, so all 91 resolve.
   - No BE32 or BE24 pointer to any of the 13 senders exists.
3. **Reachability.** I ran recursive descent from the 256 vectors over the binutils decode,
   following direct branches and calls. For tables, an immediate that points at non-code data
   holding code pointers enqueues every slot. Every chain is in `main-sites.tsv`. Limits of
   this method:
   - A table slot is counted as reached. Whether its index value can actually occur is
     **Inferred**, which is the same standard F1's `proved.tsv` uses.
   - The table heuristic over-approximates.
   - I checked the contested sites by hand: F102, F392, F3D1, F00A, F280, F501 and F503.
4. **Dead checks.** For each dead candidate I scanned every even start address from −8 to the
   end of the body for:
   - `jsr`, `jmp`, `bsr` and `Bcc` (d8 and d16) targets;
   - BE32 and BE24 pointers.

SUB (`H5_SUB`):
1. **Classifier.** I decoded `sub_FFEDF016`, `sub_FFEDF1D8`, every family classifier and
   the jump tables, and re-read the bytes from the `.bin`.
2. **Pending-buffer readers.** I swept all 1,163 `mov.l #8E46h,rX` sites. At 1,018 of them
   the first use of `rX` decodes within 8 instructions.
3. **Value scan.** I scanned for 16-bit immediates equal to each opcode, in either byte
   order.
4. **Pump and parser.** I traced the receive pump to the parser:
   `sub_FFF36CA2` → `sub_FFEDC5EE` → `sub_FFEDC976`, the link layer. I decoded the link
   layer completely (`FFEDC976`–`FFEDD0D2`) together with the ring enqueue
   `sub_FFEDD0D4` and the dequeue `sub_FFEDC1F6`.

Not covered:
- the 145 `8E46` sites that did not decode;
- the bodies of the per-opcode SUB link-layer callees: `sub_FFF3BC97`, `sub_FFF38338`,
  `sub_FFF38107`, `sub_FFEDC4DD`, and so on;
- the SUB→MAIN reply path, beyond showing that `sub_FFEDC493` sends `FFFE`;
- MAIN computed `jsr @ERn` whose target is built by arithmetic rather than loaded from a
  table.

## Findings

### 1. F102 — MAIN side (Confirmed bytes)

`0x008B7C` (bytes `6A 10 8E A0 73 70 46 1E 6B 24 00 FF 3D 74 79 24 F1 01 46 12 6A 10 BB E0 73 00
47 0A 79 04 F1 02 6B A4 00 FF 3D 74 54 70`):

```c
void sub_8B7C(void) {                 /* H8SX, no args */
    if (!(*(u8*)0xFF8EA0 & 0x80) && *(u16*)0xFF3D74 == 0xF101 && (*(u8*)0xFFBBE0 & 1))
        *(u16*)0xFF3D74 = 0xF102;     /* rewrite staged opcode; length/payload unchanged */
}
```

- **Reachability (Confirmed chain; slot value Inferred).**
  - The only reference to `0x8B7C` is `jsr` at `0x4938` (`5E 00 8B 7C`). A full BE32/BE24
    scan finds no other: the only BE24 hit is that `jsr` operand.
  - `0x4938` is reached only through `T_sw_7814` slots 0 and 2 (BE32 `00004938` at `0x7814`
    and `0x781C`).
  - The dispatch is at `0x6C32` (`78 B0 6B 26 00 00 78 14` = `mov.l @(0x7814:32,er3),er6`,
    then `jsr @er6`). The index is byte `@(5,er0)` of the band record `er0 = 0xFF90F0`, which
    `0x6D16` loads.
  - That code sits under `sub_45F6`, which the reset routine `0x2092` calls (`jsr` at
    `0x2CD8`).
- **Sent (Confirmed).**
  - `0x47CA`–`0x47D2` stages F101 with `jsr 0x88E4`.
  - `0x47E8`–`0x47F6` → `0x7078`/`0x6EAC` → `0x6BFE` → the `0x6C32` dispatch → `sub_4938` →
    `sub_8B7C`.
  - `bra 0x487C` → `jsr @0xB6B6` (`5E 00 B6 B6`) sends the mailbox.

  The rewriter requires `0xFF8EA0.7 = 0`, the same condition as the branch at `0x47AC`. So
  F102 is an F101 frame of 0x91 bytes with its opcode replaced.
- **Side finding.** The F101 builder `0x88E4` also emits **F115** (`0x8900`–`0x891E`) when
  `@(5,er0)=2 && @(1,er0)=3`. G2 recorded only F101.

### 2. F102 — SUB side (Confirmed bytes)

| Step | Address | Bytes | Effect for F1 02 |
| --- | --- | --- | --- |
| link-layer family switch | `FFEDCA50`–`FFEDCA6D` | `75 51 F6 … 75 51 FC … 75 51 FE … 75 51 FF` | F1 matches none; falls to the generic path `FFEDCE15` |
| common header | `FFEDCEBC`–`FFEDD0C3` | `F5 E6 0C` (btst #6,frame+7) … | frame bytes +7…+9 (MAIN `0xFF3D7B…`, written by `sub_7C20`) are applied: `sub_FFEDF7F4/F795/F81A/F86A/F89E`, port `0x8C021.7`, `sub_FFF3C165`, `sub_FFF3850B`, `sub_FFF38402`, `sub_FFF3EF94` |
| enqueue | `FFEDCF2B` | `39 A9 01` bsr `sub_FFEDD0D4` | frame copied to ring slot `0x12D44+0x8016+n*0x12C` |
| dequeue | `FFEDC2BF` | bsr `sub_FFEF0385` | slot → pending buffer `0x8E46` |
| F1 classifier | `FFEDF2E0`, table `FFF47FED` | table bytes `02 07 58 0C …` — case 2 = `0x58` → `FFEDF308+0x58 = FFEDF360` (default) | returns `0xFF` (`3C 02 FF` at `FFEDF2E2`) |
| top level | `FFEDF23B`–`FFEDF253` | `B0 81 75 51 FF 20 0D` … `F8 E4 00` | `cmp #255` (UIMM8; IDA prints `#-1`) → `[8A8E]=0`, returns the old `[8A8C]` |
| frame processor | `FFEDF069`–`FFEDF073` | `61 1E 3B 35 01` | `[8A8E]≠1` → `rtsd`; no handler at `off_FFED4050[id]`, no `sub_FFEDF677` reset |

Scope for "nothing else handles F102":
- (Not found) A compare against low byte `0x02` under high byte `F1`, in all 1,018 decoded
  `8E46` readers (`sub_pending_uses.tsv`). Their offset-0/1 compares are only `F1`, `F8`,
  `FF`, `0x80`, `0x4D` and `0x16`, besides the classifier.
- (Not found) An immediate `0xF102` or `0x02F1` anywhere in the 4 MB SUB image.
- (Not found) Any SUB code that writes opcode bytes into `0x8E46` other than the dequeue
  memcpy.

So, **verdict:** the common status fields of an F102 frame are applied, but no screen or UI
action follows (Confirmed). That this is a deliberate "no-screen" variant is Inferred.

### 3. F392 and F3D1 (Confirmed; over-count 0 B)

| Opcode | G2 start | Real entry | Caller | Caller's reach | Numerator rows |
| --- | --- | --- | --- | --- | --- |
| F392 | `0xA160` | `0xA15C` (`79 04 00 35`, the total-length load) | `jsr` `0x5840` = `5E 00 A1 5C` | `T_sw_7814` slot 119 = BE32 `00005840` at `0x79F0` (G3 row `0x71`, DATE & TIME ADJ) | fnindex `0000A15C` (4 B) + `0000A160` (166 B); `0x5840` in typed run `0x583A`–`0x589A` |
| F3D1 | `0xA684` | `0xA654` (`6A 0C 89 C6`) | `jsr` `0x6444` = `5E 00 A6 54` | `sub_643A` = `proved.tsv` row `00643A … 007814 220 … calls 00A654` | lane-5 typed run `0xA654`–`0xA664` (16 B, recovered code) + `0xA664`–`0xA684` (32 B typed "parameter table", but code: H8SX `78 C0 6B 25 00 00 64 4C`, G1 `sites.tsv`) + fnindex `0000A684` (122 B, xref 0) |

Neither builder has a `proved.tsv` row of its own (Not found). Both are fall-through
continuations of reached code, so the 292 fnindex bytes and 48 typed bytes are rightly
counted. **Over-count = 0 B, rows to change: none.** The `0xA664` type disagreement was
already recorded by G1 and is counted once.

### 4. Corrections to G2's dead-builder list (Confirmed)

- **F00A is live.** `0x85D4`–`0x85D9` is the data table `00 02 03 01 04 00`. F1 decoded
  `03 01 04 00` as `ldc`/`orc` code, which put the "function" at `0x85D6`.
  - The true entry is `0x85DA` (`6D F3 79 04 00 2D`).
  - `jsr @0x85DA` appears at `0x693C` and `0x6944`.
  - `0x693A` and `0x6942` are 0x782C-table rows `0xEC` and `0xED` (BE32 at `0x7BDC` and
    `0x7BE0`). They are dispatched at `0x481C`, and the guard at `0x46D2`
    (`AC E8 58 40` = `cmp.b #0xE8; bcc`) admits rows ≥ `0xE8`.
  - Rows to change: `main-banks\newly-proven.tsv` `0085D6` (DEAD → live, start `0x85DA`),
    `bank-entries.tsv` `0085D6`, and `main-indirect\residual.tsv` `0085D6`.
- **A third F280 builder at `0x9534` is dead** (46 B, the `0x9542` store). No `jsr`, `jmp`,
  `bsr` or BE32/BE24 reference exists. The only nearby branch is `0x9518` → `0x9532`, the
  `rts` of the previous routine. It is typed "recovered code" in `wave2`, which is correct.
- **F501 at `0xA73A` and F503 at `0xA7B2` are confirmed dead** with the same scan. Neither
  is in any numerator file.

### 5. The full MAIN emission set (Confirmed sites, live = Inferred via table slots)

- 245 distinct opcodes are emitted; 243 have a live site. Sites: 260 live and 3 dead
  (`0x9542`, `0xA748`, `0xA7C0`).
- Sources beyond G2's 106 builders:
  - **13 generic senders** (`mov.w e3,@0xFF3D74`, e.g. `0x9774` = `6B AB 00 FF 3D 74`) with
    91 call sites. Example: `0x4E4A` = `79 0B F3 80` then `jsr 0x976A`. They cover 90 codes:
    `F311`–`F3D4` and `F400`, plus `F3BC` twice. This is the F3 "setup item" layer that G3
    labelled.
  - **The F2 index rewrite.**
    - `0x9456` stores `r3l = [0xFFBC76]` into `0xFF3D75` (`7A 06 00 FF 3D 75 68 EB`).
    - `[0xFFBC76]` is written only at `0x2A16A`. Its value is the index of a match in the
      word table `0x1BD80`, which has a count of `0x002C`.
    - So F200 is really `F200`–`F22B`, all of which SUB maps to screen `0x1C`.
  - **Multi-opcode builders.**
    - `0x807A`: `F003`/`F004`.
    - `0x88E4`: `F101`/`F115`.
    - `0x9246`: `F111`, `F10D` and `F10F` (`0x926C`, `0x9340`).
    - `0xD9C8`: `F402` (`0xD9E0`).
    - `0xB090`: `F703` (`0xB09E`).
    - `0xD2DE`: `F3D2`, which IDA had not made code.
    - `0xD4C0`: `F3D5`.
  - **The F102 rewriter** (§1).
  - **A raw frame from NMI vector 7.**
    - The NMI vector (`0x1C` = `0000267C`) runs `0x267C` → `jsr 0x7FF6`.
    - That routine polls the SCI_6 TDR `0xFFF613` directly (`6A 8C F6 13`, at `0x800E`) and
      writes 8 ROM bytes from `0x802A`: `F0 0F 00 04 01 03 01 07`.
    - So the frame is F00F, with header checksum `0x0103` and frame checksum `0x0107`. It
      bypasses `sub_B6B6`.
- **No other path to SUB exists (Confirmed in scope).**
  - `sub_482D4` (DMAC ch0 → SCI_6) has one caller, `0xB7D8` in `sub_B6B6`.
  - The only direct TDR write is `0x800E`.
  - The paths at `0x61DAC` and similar only re-arm `0xFF3D72` with the previous length. The
    opcode left in the mailbox is reused, so they cannot create a new opcode.

### 6. SUB link layer `sub_FFEDC976` — opcode-specific handling (Confirmed bytes)

The receive pump `FFF36CBB` calls `sub_FFEDC5EE`, which calls `sub_FFEDC976`. That routine
sees each complete frame at `0x12D49` (high byte) and `0x12D4A` (low byte) before it is
queued.

| Frame | Branch | Action | Queued for classifier? |
| --- | --- | --- | --- |
| F0 0F | `FFEDC986`–`FFEDC9B9` (`75 51 F0`, `61 F1`) | `bclr` `0x8C027.3`, `0x8C021.5`, `0x8C022.2`, `0x8C028.7` (port outputs — power-down, Inferred) | yes → F0 classifier default → `0xFF`, no screen |
| FC 00 | `FFEDCDC6`–`FFEDCDDB` | `sub_FFF3BC97(frame)` (bulk apply; corrects G2's `sub_FFEF4142`, which is only a latch comparator) | **no** |
| FE 00 | `FFEDCD83`–`FFEDCDC0` | block request: word +0D/0E vs `[0x1CC3C]`, then `sub_FFEDC4DD(word +0B/0C)` | **no** |
| FF FE/FF | `FFEDCA70`–`FFEDCD2D` | block receive: 256-byte blocks at `0x070E1000+(n-1)*0x100`, sum check vs `[0x1CC44]`; a mismatch sends `FFFE` back via `sub_FFEDC493(0xFFFE)` | **no**; SUB queues synthetic 2-byte `FF FE` / `FF FF` |
| FF other | `FFEDCD30`–`FFEDCD7D` | counters reset; if the mirror `[0x1B20C]==FF`, queue synthetic **`FF 01`** (`3C 15 FF`, `3C 16 01`, `bsr sub_FFEDD0D4`, r2=2) | no |
| F3 D5 | `FFEDCE15`–`FFEDCE47` (`75 51 F3`, `75 51 D5`) | `sub_FFF38338(frame)`, then exit; no common-header pass | **no** |
| F3 D6 | `FFEDCEE0`–`FFEDCF1D`, `FFEDCFD8` | common header applied, enqueue skipped, `sub_FFF38107(frame)` | **no** |
| F3 D3 / F3 D2 | `FFEDCFDD` / `FFEDCFE2` | extra `sub_FFF38292` / `sub_FFF37D88(frame,1)` | yes |
| F6 3x, F6 40 | `FFEDCDE2`, `FFEDD067` | `sub_FFF36B1E` if `[0x12180]==1`; `sub_FFF3E98C(frame)` | yes |
| everything else | `FFEDCE15` → `FFEDCF2B` | common header (+7…+9) applied, then queued | yes |

Corrections:
- The doc-25 "mirror `0x84C8/0x84C9`" is really `0x12D44+0x84C8` = `0x1B20C`/`0x1B20D`
  (`5A EF C7 84` forms).
- The doc-25 statement that FC is dead in the dispatcher is true but beside the point:
  FC00 never reaches the dispatcher.

### 7. SUB classifier semantics (Confirmed bytes; new points)

- **Top-level default is 0, not `0xFF`.**
  - `FFEDF1DA` = `3C 02 00`. For F9–FC (jump-table bytes `45 45 45 45` → `FFEDF23B`) and for
    any high byte below `F0` (`bgtu`), the result is screen `0x00` with `[8A8E]=1`.
  - Screen 0 (`FFEE837F`) acts only when the high byte is `F1` (`75 5E F1`).
  - Only an unknown low byte inside an implemented family produces `0xFF`, which means "no
    dispatch".
- **F000 and F001** are handled inside the F0 classifier (cases 0 and 1):
  - `sub_FFEDE259(0/1)` writes `[8A8A]`.
  - `sub_FFEF2022` and `sub_FFEF201A` pass `0x28` and `0x29` to `FFEDE298`. That routine
    clears `0x8C028.2`, writes the byte to `0x06000000` (external bus) and sets `0x8C028.2`
    again. In DCS terms this is an LCD display-off/display-on command (Inferred).
  - The result stays `0xFF`, so the screen does not change.
- **F003 and F004 both give screen `0x15`.** Jump-table bytes `1F 1F` point both cases at
  `FFEDF2AF`, where `mov #14h` is immediately overwritten by `mov #15h`.
- **The FE/FF classifier** (`FFEDF652` = `75 5E FF`) requires high byte `FF`. FE00 would
  therefore return `0xFF`, but it never arrives (§6).

### 8. The SUB-only opcodes (task 3)

| Opcode | SUB decision | Screen handler `off_FFED4050[id]` | MAIN emitter (all paths incl. generic) | Class |
| --- | --- | --- | --- | --- |
| F109 | F1 case 9 → `0x09` | `FFEEA1AE` (shared with live F108 → `0x08`) | none | vestigial |
| F10A | F1 case 0x0A → `0x0A` | `FFEEA1AE` | none | vestigial |
| F113 | F1 case 0x13 → `0x41` | `FFF409DA` (checks `[8E46]==F1`) | none | vestigial |
| F3B3 | F3 `75 51 B3` → `0x20` | `FFEFD6E9` (shared with live F3B8) | none | vestigial (not in G2's list) |
| F404 | F4 `61 41` → `0x48` | `FFF43D0B` | none | vestigial |
| F801 | F8 `61 11` → `0x31` | `FFF0EBB5` | none | vestigial |
| F501, F503 | F5 lo ≤ 3 → `0x22` | `FFEE2248` (shared with live F500/F502) | dead builders `0xA73A`, `0xA7B2` | vestigial (dead both ends) |
| FF01 | FF `61 11` → `0x3E` | `FFEDE387` | none; **synthesised by SUB** at `FFEDCD61`–`FFEDCD7D` | SUB-internal |
| FFFE | FF `FE` → `0x3E` | `FFEDE387` | none; **synthesised by SUB** (`FFEDC917`–`FFEDC94A`, `FFEDCCFF`–`FFEDCD1B`); also a SUB→MAIN reply via `sub_FFEDC493` | SUB-internal |
| F003, F00A, F10D, F10F, F115, F400, F401, F402, F703 | handled | see matrix | live (§4, §5) | sent (G2 census gap) |

"None" has a stated scope:
- all 139 opcode-word stores and the one low-byte store;
- the 91 generic-sender call sites, every one resolved to an immediate;
- the F2 index path, whose values stop at `0x2B`;
- the F102 rewriter and the NMI raw frame;
- and, on SUB, no code was found that writes these values into the ring or `0x8E46`.

### 9. Reconciled matrix (task 4)

`opcode-matrix.tsv` has 254 rows. Count by class:

| Class | Count |
| --- | --- |
| matched: live MAIN sender, SUB handles it | 235 |
| MAIN-sent, handled only at the SUB link layer | 5 (FC00, FE00, FFFF, F3D5, F3D6) |
| MAIN-sent, link-layer generic processing, classifier drops | 2 (F102, F00F) |
| SUB-internal | 2 (FF01, FFFE) |
| vestigial, no emitter | 6 (F109, F10A, F113, F3B3, F404, F801) |
| vestigial, dead builder | 2 (F501, F503) |
| range edge only | 1 (F22C) |

Purpose labels:
- F3 and F4 rows carry G3's setup-item labels, for example F392 DATE & TIME ADJ and F3D0
  USB CAMERA.
- The other rows carry family or screen labels.

## USB relevance

None of this touches USB.
- The 245-opcode surface is UI, setting and status traffic.
- One block-transfer pair, FE00 (request block n) and FFFF (256-byte block), moves data
  between MAIN and SUB's external memory window `0x070E1000+` over the same SCI link. This
  is a bulk path for clone or backup data (Inferred). It is not a sample stream. It runs at
  SCI speed and has no USB endpoint behind it.
- The NMI F00F frame drives SUB port pins low, which looks like a power-fail shutdown. It
  is not a DSP or vocoder path.

The answers to the three mission questions do not change. The links still missing for SDR
are the ones named in earlier lanes.

## Open

1. **Re-sum the MAIN numerator with +72 B** for F00A `0x85DA`–`0x8622`. Flip G2's
   `newly-proven.tsv` and `bank-entries.tsv` rows `0085D6` to live, and record the F1
   residual start `0x85D6` as wrong; `0x85D4`–`0x85D9` is data. If the "proven" metric
   requires reachability, also take 46 B (`0x9534`) out.
2. **Reverse the SUB link-layer callees** that carry the real behaviour: `sub_FFF3BC97`
   (FC00 bulk apply), `sub_FFEDC4DD` and the FF block path (the `0x070E1000` window),
   `sub_FFF38338` (F3D5) and `sub_FFF38107` (F3D6).
3. **Decode the common-header byte map**, frame bytes +7 to +9, which every frame carries.
   Start from MAIN `sub_7C20` at `0x7C20`–`0x7C6C` and SUB `FFEDCEBC`–`FFEDD0C3`.
4. **Pin down the slot-index feasibility** for `T_sw_7814` indexed by `@(5,er0)` and for the
   0x782C table indexed by `@(1,er0)`, so that "reached via table slot" becomes Confirmed.
5. **Update doc 25 and doc 37**, which I did not edit, per the rules:
   - F9 to FC are not no-ops; they map to screen 0.
   - The mirror address is `0x1B20C`.
   - FC00, FE00, FFFF, F3D5 and F3D6 are link-layer opcodes.
   - The MAIN opcode count is 245, not 99.

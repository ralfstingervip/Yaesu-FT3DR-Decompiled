# Errata for the J-wave docs 70–80, and an index of K-wave corrections (lane L14)

## Verdict

Every one of K12's 18 non-pass citations was re-read from the images. The bytes K12
reported are what the images hold, so on bytes this lane agrees with K12 throughout.
K12's one uncheckable row can now be checked: doc 77:92 "`0x15` (table `05C40A`,
`1C 03`)" is correct. Table `0x05C40A` is session `0x15`'s step script, and its step 4
writes `1C 03` into the first two bytes of the 32-byte DSP frame (E20).

This lane also found four slips that K12 did not list:

- doc 72:129 calls the false `5A` match a `jsr`. Opcode `5A` is `jmp @aa:24`.
- doc 72:154 places the table base at `0x02B3C0`. That byte is the `rts`; the base is
  `0x02B3C2`.
- doc 76:173 writes `@0xFFFF0` for `0xFFFFF0`.
- doc 80:115 repeats the `0x1935E` slip from line 24.

Counting these with K12's own prose notes, there are **24 errata rows**:

- 18 are K12's non-pass rows;
- 3 come from K12's prose and its Open 3: the lane TSV and doc 76's `r4`/`e4` (two lines);
- 3 are new to this lane.

None changes a ledger mask. None changes a mission answer. In 16 of the rows the corrected
address sits inside proven code. In each of those, the instruction bytes are right and
only the address label or mnemonic is wrong.

Section 3 indexes the K-wave corrections to docs 70–80. Each entry points to the
superseding doc and line. Docs 70–80 were not edited.

## Method

`ida\out\errata-j\l14_errata_check.py` is a read-only Python script. It makes no IDA call
and opens no device. It does the following:

1. Hashes both images. MAIN is `8e3ecd05…c1bcce` and SUB is `b93570b3…8c6230`, both
   unchanged.
2. Re-reads **61 byte runs and computed checks** (`bytecheck.tsv`), all PASS:
   - 42 for the errata;
   - 14 anchors for the K-wave index;
   - 5 computed checks:
     - the ramp structure of `0x0376C8`;
     - the 26 SUB font blocks;
     - the extent of the `0x05C40A` step table;
     - a whole-content scan for stores to `0xFFBBC2`;
     - a count of `jsr @0x026F08` call sites.

   MAIN file offset equals the address. SUB file offset is the address minus `0xFFC00000`.
3. Checks that the quoted "as written" text appears on the cited line of the owning doc.
   All 24 rows PASS.
4. Checks both ends of each K-wave index row: the owning doc's line and the superseding
   doc's line. All 46 PASS.
5. Reads the mask byte at each corrected address from `main-final4\final4_proven_mask.bin`
   and `final4_named_mask.bin`. For the SUB font table it reads
   `sub-final3\raw\mask_final3_after_{headline_w2,allwf}.bin`.

Limits of scope:

- This lane did not re-run K12's other 292 PASS rows.
- It did not re-check the K-wave lanes' own findings. Section 3 points to them, and only
  the 14 anchor runs listed there were re-read.
- Mnemonics are hand-decoded H8S/H8SX from the bytes. The H8SX indexed forms (`78 b0 6b
  26`, `78 30 6a 2b`) are decoded as "indexed load from the 32-bit displacement". The
  table contents fix the stride, so the stride is Inferred from them.

## Findings

### 1. Corrected citations (`errata.tsv`)

Every corrected citation below was byte-checked. The check IDs refer to `bytecheck.tsv`.
"Mask" is final4 at the corrected address (P = proven, N = named).

| # | doc:line | as written | corrected (Confirmed bytes) | class | mask / credit |
| --- | --- | --- | --- | --- | --- |
| E01 | 70:107 | `04E31A 5e 05 27 80 jsr @0x052780` | `0x04E318 5e 05 27 80`. The instruction before it is `0x04E312 7a 01 00 ff b0 67`; `rts` follows at `0x04E31C 54 70` | address −2 | P N. The J2 extent is unchanged because the `rts` cite is right |
| E02 | 71:86 | `0x026F4A mov.w r3,@0xFFBBC2` | `0x026F48 6b 83 bb c2`, after `0x026F42 6f 53 00 08` (`mov.w @(8,er5),r3`) and `0x026F46 4b 1e` (`bmi`). The whole content holds exactly 3 stores: `026F3C`/`026F48`/`026F6A`. The row's own path column already says `sub_26F48` | address +2 | P N |
| E03 | `ida\out\key-dispatch\writers-0xFFBBC2.tsv`:6 | `026F4A 6b 83 bb c2` | `026F48` (same as E02) | address +2 (lane table) | P N |
| E04 | 72:63 | `00 06 5F 00` at `0x02B3DC` | `0x02B3DA 00 06 5f 00`, slot 6 of table `0x02B3C2` | address +2 | N |
| E05 | 72:64 | `00 06 5F 06` at `0x02B3E0` | `0x02B3DE 00 06 5f 06`, slot 7 and the last. `0x02B3E2 7a 06 00 02 b4 1a` is code | address +2 | N |
| E06 | 72:62/71/152/154 | `~0x02B3C0` table; "`0x02B3C0` base held in a register" | The base is `0x02B3C2`; `0x02B3C0 54 70` is the `rts`. Slots 0–4 = `0x02B3B2`, slots 5–7 = `0x065EFA`/`F00`/`F06`. Loaded by `0x02B3A8 7a 06 00 02 b3 c2 5a 02 86 16`. The reader is helper `0x028616` (`6b 04 bb c2 79 24 00 09` … `0x028630 5d 60`). It is **not** an indexed `jmp` inside `0x065EC2`–`0x065F3A`, which is what l.153 says | address (approximate base and wrong reader site) | N |
| E07 | 72:91 | `0x0376C8` "152 B monotonic" | Three non-decreasing ramps: `0376C8`–`0376F9` (50 B, `11`..`1a`), `0376FA`–`03772B` (50 B, `11`..`19`), `03772C`–`03775F` (52 B, `0f`..`5b`). The `5b` run continues to `0x037762` | wording | not in either mask |
| E08 | 72:129 | "`jsr` operand `5A` at `0x074342`" | The false abs24 match is `0x074340 5a 03 6b 84`. Read as code it would be **`jmp`** `@0x036B84`, because `5A` is `jmp`; `jsr` is `5E`. The real code is `0x07433E 79 04 5a 03` (`mov.w #0x5A03,r4`) and `0x074342 6b 84 96 f8` (`mov.w r4,@0xFF96F8`). The target `0x036B84` holds `1d`×10 then `1e 1e` | address −2 and mnemonic | P N. The conclusion (a false positive) stands |
| E09 | 73:94 | writer `0x054F1E` | `0x054F1C 01 00 6b 84 81 84` (`mov.l er4,@0xFF8184`). `er4 = 0x0100FFFF` is built from `0x054F12`: `f4 01`, `fc 00`, `0d 4c`, `79 04 ff ff` | address +2 | P N |
| E10 | 73:95 | writer `0x05601E` | `0x05601C`, the same 16-byte sequence starting at `0x056012` | address +2 | P N |
| E11 | 74:152 | `05549c fc 08 6a 8c 81 83` | `05549a fc 08 6a 8c 81 83`. The store `6a 8c 81 83` is at `0x05549C`. Line 148 uses the load address, so l.152 is inconsistent with it | address (listing convention) | P N |
| E12 | 74:158 | `038674 fc 00 6a 8c aa e8` | `038672 fc 00 6a 8c aa e8`. The store is at `0x038674`, so l.40's store-address cite is right | address (listing convention) | P N |
| E13 | 76:126 | `002A5A 56 70 rts` | `002A5C 6d 74` (`pop.w r4`), then `002A5E 56 70` **`rte`**. Vector 110 at `0x1B8` = `00 00 2a 30`, and the handler opens with `6d f4` (`push.w r4`) | address +4 and mnemonic | P N |
| E14–E16 | 76:172 | `056776 / 056826 / 056950  79 04 00 00 3c f0 6b 84 ff f6` | The bytes start at `056772` / `056822` / `05694C`. The TCR store `3c f0` is at the cited addresses, so l.199's cites are right | address −4 (listing convention) ×3 | P N |
| E17 | 76:173 | `mov.b r4l,@0xFFFF0` | `mov.b r4l,@0xF0:8`, which is `0xFFFFF0` (TCR3) | address typo (**new**) | P N |
| E18 | 76:155 | `05B8A8 6b 0c ff f6 mov.w @0xFFFFF6:16,r4` | `… ,e4`. The register nibble `c` selects `e4` | mnemonic (K12 Open 3) | P N |
| E19 | 76:156 | `05B8AC 79 2c 89 80 cmp.w #0x8980,r4` | `cmp.w #0x8980,e4`. The value and the 2.2 ms period are unchanged | mnemonic (K12 Open 3) | P N |
| E20 | 77:92 | "`0x15` (table `05C40A`, `1C 03`)" | **Checkable and correct**; details below | notation, resolved | P N |
| E21 | 79:128–130 | blocks 0–7 "14×14" kanji; blocks 9–25 "base `0x0020`" | Block 3 is **7×14 with base `0x0020`** (half-width ASCII). Blocks 0–2 and 4–8 are 14×14, with bases `9321`/`5021`/`2121`/`2D21`/`2124`/`7921`/`2122`/`2121`. Block 8 equals block 2 in all 12 B. Of blocks 9–25, the base is `0x0020` except **block 11** (10×9, `0x0023`) and **block 18** (5×14, `0x002E`). The range 14×27 → 4×7 is right. Record layout `{u8 w, u8 h, u16 base, u32 ord, u32 pix}` LE at `FFED4644` (file `0x2D4644`) | wording | SUB data, not in the code masks |
| E22 | 80:24 | save stub at `0x1935E` | `0x01935A 79 01 00 aa` (`mov.w #0xAA,r1`). `0x01935E 5a 03 cc bc` is the stub's `jmp @0x03CCBC`. Lines 45 and 145 already say `0x1935A` | address +4 | N only (dead stub) |
| E23 | 80:115 | save stub `0x1935E` | `0x01935A`, as E22 (**new**) | address +4 | N |
| E24 | 80:66–67 | table `0xCE40` = `02 … 09 01 0F 00` | `0x00CE40 02 03 04 05 06 07 08 09 0a 01 0f 00`: 12 B, `0x00CE40`–`0x00CE4B`, with code resuming at `0x00CE4C 6a 0c 94 c1`. The reader at `0x00CE1E` loads `r3l = [FF89CB]` and `r3l = [0xCE40 + er3]` (`78 30 6a 2b 00 00 ce 40`), then stores to record `+0x3E`. Index 8 gives `0x0A`; 9, 10 and 11 give `01`, `0f`, `00` | byte (dropped `0a`) | N |

**E20 in full (Confirmed bytes; the role is Inferred where marked).**

1. Selecting the script:
   - `0x0563CE 6a 0b b0 be … 78 b0 6b 26 00 05 b3 10 5d 60` indexes `0x05B310` by `B0BE`.
   - `0x05B364` (= `0x05B310 + 0x15×4`) holds `00 05 c3 f4`.
2. The step dispatcher:
   - `0x05C3F4 6a 0b b0 bf … 78 b0 6b 26 00 05 c4 0a 59 60` indexes `0x05C40A` by `B0BF`.
   - The table has 11 pointers, `0x05C40A`–`0x05C435`. Code starts at `0x05C436`.
   - Slot 4, at `0x05C41A`, holds `00 05 c4 36`.
3. Step 4:
   - `0x05C436 6a 0c b0 a4 4a 2a 73 3c 46 26` is the link-ready test (Inferred role).
   - It then sets `B0B8 = 3` (`fc 03 6a 8c b0 b8`) and calls `0x05A040` (`5e 05 a0 40`).
4. Building the frame at `0x05A040`:
   - It clears 32 B at `FFB13E`: `7a 05 00 ff b1 3e`, then 8 × `01 00 69 d4 0b 95`.
   - At `0x05A07C` it runs `f3 1c 6a 0b b0 b8 6b 83 b1 3e`, which writes `1C`, `[B0B8]` = `1C 03` as frame bytes 0–1.
5. Where the session code comes from:
   - `sub_5A2F8` stores `0x15` to `B0B7` at `0x05A32E` (`fc 15 6a 8c b0 b7`).
   - `0x05A3A0 6a 0c b0 b7 6a 8c b0 be` copies `B0B7` into `B0BE`.

So doc 77's "session `0x15`" is right through that copy. The meaning of DSP opcode `0x1C`
is still Unknown (doc 93 l.73).

### 2. Agreement with K12

On bytes this lane agrees with all 18 of K12's rows. It refines or adds the following:

- **77:92.** K12 called this row "not checkable". It is checkable and passes (E20).
- **72:129.** K12 has the address right. The doc also has the mnemonic wrong: the false
  match is a `jmp` (`5A`), not a `jsr` (E08).
- **80:66.** K12 cites line 66, but the table spans lines 66–67, and the missing `0a`
  belongs on l.67.
- **K12 missed three repeats:**
  - 80:115 (`0x1935E` again);
  - 76:173 (`@0xFFFF0`);
  - 72:154 (base `0x02B3C0`, with the reader placed in the wrong function). K1 already
    gives the right base and reader in doc 83 l.230–231.
- **"None touches a credited byte."** I agree that no mask changes. In 16 rows (E01–E03
  and E08–E20) the corrected address does sit inside **proven** code. The bytes there were
  always right, and only the address label or mnemonic changes.

### 3. Index of K-wave corrections to docs 70–80 (`kwave-index.tsv`)

A reader of docs 70–80 should treat the statements below as superseded. "Lines" are in
the owning doc. Anchor bytes were re-read by this lane (`bytecheck.tsv` K01–K14), and
both line pointers were text-checked.

| # | doc:lines | superseded statement | now | superseding doc:line | anchor (Confirmed) |
| --- | --- | --- | --- | --- | --- |
| K-01 | 70:38–39, 98 | I8's walk of `0x04ABE4` truncated before slot 68 | A stale `mid_code` exclusion of slot `0x04ACF4` hid `0x04E2D6`. The handler is also slots 134/154/245 of `0x04ABE4` and 274/358 of `0x04AB70` | 83:227–229 (K1) | `0x04ACF4 00 04 e2 d6` |
| K-02 | 71:43, 95, 141, 165 | nine touch-zone tables | 99 tables / 511 zones / 5,296 B; 125 hit-test sites | 85:241–242; 83:234 (K1/K2/K3) | 125 × `5e 02 6f 08` |
| K-03 | 71:51, 158–159 | `0xF3xx`–`0xFDxx` are raw touch events; the ladder is at `0x026500`/`0x026580` | They are the screen opcode echoed by SUB. The ladder has 94 arms and starts at `0x02639C`/`0x0263A2` | 84:24–26 (K2/K3) | `0x02639C 01 00 6b 02 bb d4 79 24 f0 03` |
| K-04 | 71:92 | `sub_26F9C`/`BBC4` = secondary coordinate | the pending hold/repeat button | 85:245 (K3) | — |
| K-05 | 71:142–143 | the `0x02843C`/`0x0270CA` values are button indices | the `0xF00x` values are virtual-key codes | 85:243–244 (K3) | — |
| K-06 | 72:63–64 | cells `0x02B3DC`/`E0` | `0x02B3D6`/`DA`/`DE`, table `0x02B3C2` (E04–E06) | 83:120, 230 (K1/K12) | C11–C13 |
| K-07 | 72:69–72 | J4 +16 B is Inferred; the reader is not pinned | Confirmed and credited under rule K1b. The reader is helper `0x028616` | 83:230–232 (K1) | C08, C15, C16 |
| K-08 | 72:131 | nothing beyond the 5 functions | That claim was scoped to unproven DB code. K1b finds 170 B more | 83:231–233 (K1) | — |
| K-09 | 77:20–21, 77–80, 197, 232 | PTT = `0xFFFF4D` b3 | PTT = **`0xFFFF4E` b7**. `0xFFFF4D` b3 is an RF-status interlock | 93:15, 225–227 (K11) | `0x00FC66 2a 4e ea 80`; `0x034984 7e 4d 73 30` |
| K-10 | 77:69, 233–234 | `FF956D` = TOT | `FF956D` is a 10–20 ms settle. The TOT is `FF95EA` | 93:228 (K11) | `0x03497C 6a 0c 95 6d` |
| K-11 | 77:20, 27–28, 216–218 | only PTT and the SCI-A node link key the radio | Add the four APRS paths, the PDN `S` frame, remote `']'`, the GM beacon and the addressed ACK | 90:254–257 (K8); 86:228–231 (K4); 93 (K11); 92 (K10) | `0x034A5A`/`0x034A62 6a 18 a4 f0 70 60/70` |
| K-12 | 77:30–31, 219 | session `0x17` is an automatic reply to decoded messages | the PDN form of a WIRES-X request | 86:218–226 (K4) | `0x06D08A fc 17 6a 8c b0 b7 6a 8c b0 be` |
| K-13 | 77:93, 106 | `AAD4.b0` = data/message/**APRS** queued | `AAD4.b0` setters are C4FM GM engines; APRS uses `AAD3` b0/b2 | 90:258–259 (K8) | as K-11 |
| K-14 | 77:39, 181–190 | `0x32` = AMS/mode frame; F3A3/F3AB unresolved | F3A3 = APRS MODEM and F3AB = APRS TX DELAY; `0x32` = APRS modem config | 87:287–290 (K5); 90:260 (K8) | `0x005AAE 79 0b f3 a3 6a 0b 8a a0` |
| K-15 | 77:144–155 | the opcode `0x11`/`0x12` layouts | `0x11` bytes [15..17] are an overlay and [27..30] were omitted; byte [3] of `0x12` (`FF8D87`) was omitted | 87:291–294 (K5) | — |
| K-16 | 77:111–113, 235 | `B0CC` is a whole-byte boot/node write; its role is open | It is a flag set by remote `']'` | 93:229 (K11) | `0x0743BA fc 01 6a 8c b0 cc`; `0x0743CA fc 00 6a 8c b0 cc` |
| K-17 | 77:27 | `sub_73E58` = host command `0x11` | table `0x074472` slot `0x10`; the numbering basis is not settled | 93:230–232 (K11) | `0x0744B2 00 07 3e 58` |
| K-18 | 78:24, 144 | residue 10,059 B; merges 2,279 B | 10,670 B and 2,890 B (three tail chunks were missed) | 89:44 (K7) | — |
| K-19 | 78:24–25, 108–109 | `FFF2A70B` is a continuation | It is a separate subroutine, merged only as instructed | 89:45 (K7) | SUB `FFF2A6F7 39 14 00` (file `0x32A6F7`) |
| K-20 | 79:27, 153–155, 190 | an 18-entry status/capability mask table; `+0x2C6` = index | 7 {SD,MMC} R1-mask pairs plus 4 CMD6 args; `+0x2C6` = card family | 88:333–335 (K6) | SUB `FFED7F50` = `0x00FFF0FF`…`0x00FFF3FF` (file `0x2D7F50`) |
| K-21 | 79:163–168 | the `0x7DFFFF` split is SDSC/SDHC; fields 0/7 | The split is inside SDHC. Field 0 = {spt, heads}; field 7 = RSC | 88:337–339 (K6) | — |
| K-22 | 79:190 | the geometry records are the live lead | They are reached only from the dead `sub_FFF36999` | 88:340 (K6) | — |
| K-23 | 70–80 (citations) | K12 errata | §1 of this doc and doc 94 §2 | 94:110–148; this doc | E01–E24 |

RESUME's correction list records no substantive K-wave correction for docs 73, 74, 75, 76
or 80 beyond the citation errata in §1. Section 3 is limited to docs 70–80.

RESUME's correction list also covers docs outside 70–80, and these are not indexed here:

- docs 02, 04/05/11/14 and 13 → docs 88, 90, 91, 92, 93;
- doc 32 → 87:296; doc 51 → 84; doc 60 → 83:236;
- pc-01/pc-02 → doc 91.

Those pointers were not text-checked by this lane.

## USB relevance

None of the three mission answers changes. Four rows touch the USB status byte 0 path and
the USB status-stage path (E09–E12). Eight touch the DSP tick and session paths
(E13–E20). In every case the cited instruction exists, its bytes are right and its
meaning is unchanged; only an address label or a register name was wrong. E20 adds one
Confirmed detail for Q3: session `0x15` sends `1C 03` as bytes 0–1 of a 32-byte frame
built at `FFB13E`. The opcode's meaning is still Unknown.

## Open

1. **A docs-only pass** can apply §1 to docs 70–80, if the owner wants that. The rows in
   `errata.tsv` can be pasted as they stand.
2. **Unresolved items carried forward:**
   - the slot `0x10` vs `0x11` basis for `sub_73E58` (K-17);
   - the meaning of DSP opcode `0x1C` (E20).

## Files (`ida\out\errata-j\`)

- `l14_errata_check.py` is the read-only checker and reruns in seconds.
- `errata.tsv` has 24 rows with these columns:
  - `doc`, `line`, `as_written`, `corrected`, `class`, `credited_byte_affected`,
    `evidence`;
  - then `id`, `mission_answer_affected`, `k12`, `mask_final4_at_corrected` and
    `doc_text_check`.
- `bytecheck.tsv` holds 61 checks, all PASS.
- `kwave-index.tsv` holds 23 rows with 46/46 text checks.
- `run.txt` holds the hashes and the summary.

Model: claude-opus-5-5.

# 142 — Errata index for the M wave (lane N15)

## Verdict

Every slip the M wave recorded was re-read from the images:

- the three reconciliation slips (M2, M10, doc 121);
- all 22 rows of RESUME-FULL's "Corrections recorded this wave" table, split into 51 single-slip rows.

**All 54 are confirmed on bytes.** One of them, M1's caller count for `0x067522`, is confirmed only in part, as follows.

- **M1's count is wrong.** M1 (doc 113:223) and RESUME:201 say `0x067522` has "two callers, both inside dead
  `0x06B4B0`". There are **five** abs24 callers:
  - `0x06B154`, `0x06B194` and `0x06B3CC`, which M1 did not list;
  - `0x06B4F6` and `0x06B536`.
- **The dead verdict still holds for all five.** Each is a FINAL6 code head with P7 = 0. Each sits in a region
  that follows an `rts`, and a whole-image scan finds no edge into any of these regions from outside.
- **This lane finds three new slips.** Each has the right bytes at the wrong address, or a wrong label.
  - `dsp-1c03\opcode-1c.tsv` line 40 cites `0743CC` + `fc 00 6a 8c b0 cc`. The run starts at `0x0743CA`.
  - RESUME-FULL:36 and `m-wave-recon\README.md`:22 cite the dead-arm head as `0x06ADE4`. The run
    `0x06ADE6 0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e` starts 2 B later.
  - RESUME-FULL:40 lists `0x06281A` and `0x06724A` as jsr sites "to the leaves". Both call `0x066FAA`,
    which is not one of the four dropped leaves.

**No row changes a mask byte or a mission answer.** Named Δ = 0 B and proven Δ = 0 B against the FINAL7 masks
(365,358 / 505,165). No existing doc was edited.

## Method

`ida\out\errata-m\n15_errata_check.py` is plain read-only Python. It makes no IDA call, opens no device and writes
only into `ida\out\errata-m\`. Two runs gave byte-identical outputs. Here is what the script does.

1. **Hashes both images and stops on a mismatch.** MAIN `8e3ecd05…c1bcce` and SUB `b93570b3…8c6230` were
   unchanged at the start and the end of the lane.
2. **Re-reads 99 anchor runs, C01–C99.** All 99 PASS. MAIN file offset = address. SUB file offset = address − `0xFFC00000`.
3. **Re-reads 14 as-written runs at their cited addresses, W01–W14.** All 14 differ from the image, so each slip is
   reproduced (`SLIP-CONFIRMED`).
4. **Runs 17 computed checks, X01–X17.** All 17 PASS. Each states its scope:
   - **X01, X02, X06, X09, X10:** whole MAIN content `0x000000`–`0x07FFFF`.
   - **X07:** whole-image edge scan:
     - every 3-byte big-endian value at every offset (this covers abs24 `jsr`/`jmp`/`mov.l` and BE32 with high byte 0);
     - rel8 `Bcc`/`bsr` and rel16 `Bcc`/`bsr` at every even offset.
   - **X11:** whole SUB image, LE immediate `b8 2c 01 00`.
   - **X14:** whole SUB image, every 3-byte LE value at every offset.
   - **X15:** `ida\out\h8s-decode\work\bu_all.tsv`.
   - **X16:** the backticked `ADDR hh …` citations in RESUME-FULL lines 13–250 and the recon README. It found 9
     citations. The one non-PASS is E56, whose run is found 2 B later.
   - **X17:** a self-check of this doc. All 104 backticked `ADDR hh …` citations in it match the image. As-written
     slips are quoted with the address and the bytes in separate spans, so they are not counted.
5. **Text-checks every row twice:**
   - the as-written text on the owning doc or table line: 57/57 PASS;
   - the line that recorded it (RESUME, or the lane doc): 54/54 PASS, plus 3 rows that are new here.
6. **Reads `final7_proven_mask.bin` (P7) and `final7_named_mask.bin` (N7)** at each corrected address.

What this lane did not do:

- **It does not re-derive the superseding lanes' semantics.** M12's Bluetooth labels and M11's 666 kHz record name
  are cases where the bytes are Confirmed and the label stays Inferred. They are marked that way per row.
- **The M8 orchestrator note** (an early `m8_verify.py` re-run wrote into `ida\out\an1-tones\`) is a process event
  with no byte claim. It is not a row.
- **The mnemonics are hand-decoded.** H8SX uses the `h8sxa` conventions, and abs16 operands sign-extend to
  `0xFFFF8xxx`. RX follows BRIEF correction 4.

## Findings

Full rows, with anchors, mask state and both text checks, are in `ida\out\errata-m\errata.tsv`. Byte runs and computed
checks are in `bytecheck.tsv`. Section A covers the reconciliation slips, B the RESUME corrections table, and C the
slips that are new here.

### A. Reconciliation slips (RESUME:184–188)

| # | doc:line | as written | Confirmed bytes / correction | verdict |
| --- | --- | --- | --- | --- |
| E01 | 114:95, :20 | `0x00932A`–`0x009332` "Confirmed by the reader" | The reader is `0x009294 6a 0c 8e b2 7a 64 00 00 00 ff 78 40 6a 2b 00 00 93 2c`: `mov.b @0x8EB2:16,r4l`; `and.l #0xFF,er4`; `mov.b @(0x932C:32,er4),r3l`. It reads `0x932C`..`0x942B` only. `0x00932A 05 04` lies 2 B below the base. No `00 93 2a` value occurs anywhere, and `00 00 93 2c` occurs once (`0x0092A2`). Data by inference, and the demotion stands (P7 = 0) | Confirmed |
| E02 | 122:117, :35 | `0x063C04` (`fc 0a 6a 8c a9 f9`) | `0x063C04 fc 00 6a 8c b2 a3` is the routine entry. Its only callers are `0x01CE9A 5e 06 3c 04` and `0x01CEAA 5e 06 3c 04`. The mode-10 run is `0x063C10 fc 0a 6a 8c a9 f9`, with the store at `0x063C12` (122:106 is right) | Confirmed |
| E03 | 121:139 vs :162 | `[0x18]==3` vs `[+0x13]==3` | These are the same byte, `0x12D5C`. Line 139 counts from `0x12D44`: `0xFFEDCE76 fb 12 44 2d 01 00 b6 11 61 31` (`movu.b 0x18[r1]`, `cmp #3`). Line 162 counts from frame body F = `0x12D49` (doc 51:110): the opcode-hi read is `0xFFEDCE56 fb 12 44 2d 01 00 b1 19 75 51 f3`, which is `movu.b 5[r1]`. No byte is wrong | Confirmed, no erratum |

### B. RESUME "Corrections recorded this wave" (RESUME:197–218), one row per slip

| # | doc:line | as written | Confirmed bytes / correction | verdict |
| --- | --- | --- | --- | --- |
| E04 | 105:187 | UHF 230–419.995 → 5 | `0x035140 00 0a 00 02 30 00 00 00 41 99 95 00 00 05`: **300.000**–419.995 → 5. The VHF table `0x03510A 00 0a 00 05` ends at 222.000–229.995 → 4, so 230–299.995 has no entry | Confirmed |
| E05 | 105:321 | popup `0x23` shown | `0x01BF40 ac 02 45 32 ac 0c 44 2e`: codes ≥ `0x0C` return, so `0x23` is never shown | Confirmed |
| E06 | 105:288 | DCS "Inferred, moderate" | The 104 BE32 entries at `0x000B8C` have their low 9 bits zero. Bit-reversed, they are D023…D754 in standard order, and all 104 are Golay(23,12) codewords under g = `0xC75`. The tick is set by `0x000476 79 04 0b a0`: period 2977 gives 5374.5 Hz, and /40 gives 134.36 bps | Confirmed |
| E07 | 105:293 | TPU1 sine clock "Inferred" | `0x0351D6 fc 20 3c d0 79 04 00 00 6b 84 ff d6 79 04 09 89 6b 84 ff d8`: TGRA1 = `0x0989`, so 16e6/2442 = 6552.0 Hz | Confirmed (clock) |
| E08 | 105:301 | T-CALL clock select "not read" | `0x002336 fc 02 6a 8c fe c1` sets φ/64. With TCORA `0x47`, that gives 1736.1 Hz | Confirmed |
| E09 | 105:432 Open 4 | key event 13 unidentified | It is a DIAL step. Raw `0x16` is formed only at `0x00FBBE 77 0b 6a 18 a9 ee 67 00 fc 16`. The F-code is `0x00A210 79 04 f3 96`; the setting is read at `0x00A228 6a 0b 89 b5` | Confirmed bytes |
| E10 | 101:61 | leaves reached via `off_74472` | The 48 BE32 entries of `off_74472` (`0x074472`–`0x074531`) include none of the four leaves, and no BE32 to them exists. All 12 jsr sites to the leaves are P7 = 0. The arm head is `0x06ADE6 0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e`, and `0x06ACD6 0f 95 7a 15 00 00 00 2e` is an ordinary routine | Confirmed |
| **E11** | 101:95; 113:223; RESUME:201 | 101: "0 inbound"; M1: "two callers" | **Five** callers, all `5e 06 75 22`: `0x06B14C ab 06 47 40 f2 00 fa 08 5e 06 75 22` (call at `0x06B154`), `0x06B18C b1 ec 59 60 f2 00 fa 0a 5e 06 75 22` (`0x06B194`), `0x06B3C4 5e 06 1d 6e f2 00 fa 01 5e 06 75 22` (`0x06B3CC`), `0x06B4F6 5e 06 75 22` and `0x06B536 5e 06 75 22`. All are P7 = 0 / N7 = 1. Their regions `0x06B10E`–`0x06B25B`, `0x06B3BE`–`0x06B407` and `0x06B4B0`–`0x06B555` each follow `54 70` and have no inbound edge from outside (X07). The only outside hit is `0x05D23E 6b 06 b1 26`, an abs16 RAM operand | **Refined: 2 → 5; dead stands** |
| E12 | 100:68 | 6 proven `bra/bsr rN.w` | 5 are mid-instruction: `0x02B3F6 5e 06 5d 26`, `0x02B44E 5e 06 5d 66`, `0x05569A 5e 05 59 76`, `0x0559B0 7a 05 00 ff 59 06` and `0x0559C6 7a 06 00 ff 59 06`. Only `0x076308 59 06` is a real `bra r0.w` | Confirmed |
| E13 | 100:126 | `6d 62 6d 63 01 00 69 64` contiguous | The image reads `0x03F5B2 01 00 6d f2 6d 62 79 0a 00 00 6d 63 01 00 69 64`, so the cited bytes are not contiguous | Confirmed |
| E14 | runs.tsv:279 (102) | "named insn 0x01E1BE (mov.w …)" | `0x01E1BE 10 73 78 b0 6b 26 00 01 e1 de`: `shll.l #2,er3`, then the 8 B `mov.l @(0x1E1DE:32,er3),er6` at `0x01E1C0` | Confirmed |
| E15 | runs.tsv:280 (102) | dead piece from `0x01E1C6` | `e1 de` is an operand tail; the dead code starts at `0x01E1C8 01 10 6d 75` | Confirmed |
| E16 | runs.tsv:185 (102 §5) | `0x018FAA` unreachable | `0x017924 7a 05 00 01 79 2e 5a 01 52 60` passes record `0x01792E` to `sub_15260`, which calls `0x015288 10 72 0a a5 01 00 69 56 47 08 5d 60`. Six `jsr @0x018FAA` calls follow, at `0x017950`…`0x017984`. The target is `0x018FAA 6a 18 8a ac 61 c0` (P7 = 1) | Confirmed |
| E17 | runs.tsv:2 (102) | table `0x000E00` | The table is `0x000DEA`, read by `0x000938 78 e0 6b 26 00 00 0d ea` (also at `0x00095C` and `0x000A04`). `0x000E1E 00 7f 31 9c` is its slot 13 | Confirmed |
| E18 | runs.tsv:77 (102) | in list `0x015164` | Index 6 of the u8 map `0x01518C`, read by `0x014F8E 78 30 6a 2b 00 01 51 8c` | Confirmed |
| E19 | 102:199 | `0x069A7F` un-nameable | It is a stale copy of `sub_69964`. The first 37 B equal those at `0x069964` and byte 38 differs (`02` vs `0e`). N7 = 0, held for the owner | Confirmed |
| E20 | 102:122 | proven +4 B | `0x006A06 40 12` and `0x0077CC 40 36` are branches before blocks the descent never reaches. P7 = 0 at `0x006A0C` and at `0x0077F8` | Confirmed |
| E21 | 104:145 | `'A'` = channel index | `'A'` is a key injector. `0x073EB4 a1 17 44 24` NAKs arguments ≥ `0x17`, and `0x073ECE fc 09 18 c1 6a 81 a9 ed` stores the event. It cannot inject event 14 | Confirmed bytes |
| E22–E24 | 104:164 ×2, 104:28 | `0x073E88`, `0x073E90` | `0x073E86 5e 03 4a 52` and `0x073E8E 5e 03 50 e4` | Confirmed |
| E25–E28 | 106:130, :151, :153 ×2 | `0x0743BC`, `0x031BEE` store, `0x030242`, `0x031CD4` | `0x0743BA fc 01 6a 8c b0 cc`; `0x031BEE fc c8 6a 8c 95 89` (store at `0x031BF0`); `0x030240 fc 05 6a 8c aa ce`; `0x031CD2 fc 05 6a 8c aa ce` | Confirmed |
| E29 | 107:119 | `0x00FAFE` BT-ON test | `0x00FB04 6a 10 89 20 73 00 46 0c`. `0x00FAFE 6a 0c 89 bb 47 14` is the VOX test | Confirmed |
| E30 | 107:280–281 | 12CB8 writers: 3 | There are **6 writers** among 13 `mov.l #0x12CB8` sites. They set 2 at `0xFFF38627`, `0xFFF3865A` and `0xFFF387B6 fb e2 b8 2c 01 00 f8 e5 02`, and set 1 at `0xFFF38759 fb e2 b8 2c 01 00 f8 e5 01`, `0xFFF388EB` and `0xFFF38F75 fb e2 b8 2c 01 00 f8 e5 01`. The other 7 sites read | Confirmed |
| E31 | 107:151 | TXAT=1 from one routine | Also sent from `0xFFF38467 39 7b 00` (`bsr.w FFF384E2`); the path meaning is M12's | Confirmed bytes |
| E32 | 107:181 | 1229D from F3D2 only | The common path `0xFFEDD019 05 f2 b4 05` (`bsr.a FFF3850B`) reaches `0xFFF3851D b6 11 75 21 20` | Confirmed |
| E33 | 109:100–101 | `0x2433A` / `0x243BA` | `0xFFEDD533 fb e2 44 2d 01 00 c9 0e 0f f6 95` gives `0x12D44 + 0x95F6` = **`0x1C33A`**. `0xFFEDD706 fb e2 44 2d 01 00 c9 0e 0f 76 96` gives **`0x1C3BA`** | Confirmed |
| E34 | builders.tsv:7 | FE `0x2443A` | `0xFFEDD8F4 fb e2 44 2d 01 00 c9 0e 0b f6 96` gives **`0x1C43A`** | Confirmed |
| E35 | 109:272 | E5 link Unknown | Sent through `FFEDD528` from `0xFFF394CF 05 59 40 fa` and `0xFFF39516 05 12 40 fa` (both `bsr.a`). It is the BT-VOX level, per M12 | Confirmed bytes, label Inferred |
| E36 | 109:147 | PAIR=/FIND= are sends | They are replies. The `PAIR=<addr>` linked state is set at `0xFFF3A77B f8 e4 05`. Per M12 | Confirmed bytes, role Inferred |
| E37 | 108:130, :134 | E4 = WIRES-X/GM status | E4 is Bluetooth link/scan status: `0xFFF38AEA 05 3e 4a fa` (`bsr.a FFEDD528`) and MAIN `0x073292 ac 03` | Confirmed bytes, label Inferred |
| E38 | 112:84 | `0x054D50` `6a 0c 81 3a …` | `0x054D50 01 10 6d f4 6a 0c 81 3a`, so the cited run starts at `0x054D54` | Confirmed |
| E39 | 85:61, :202–203 | 16 / 4 chars | The descriptors are `0x05E376 00 0f 00 ff b9 ed` (15) and `0x05E3B4 00 03 00 ff b9 ed` (3) | Confirmed |
| E40 | 49-key-seq:400; 112:210 | `0x66600` unidentified | It is BCD 666.00 kHz. `00 06 66 00` occurs only at `0x014986` and `0x0149A2`, inside `0x014984 7a 24 00 06 66 00` and `0x0149A0 7a 24 00 06 66 00` | Confirmed |
| E41 | 35:134 | `FF90F0` = sub/B band | It is the broadcast record: `0x03FB32 7a 06 00 ff 91 02`, with row `0x022176 00 05 00 00 00 17 95 00` (0.500–1.795 MHz). A is `0x00216A 7a 04 00 ff 8e e0` and B is `0x00217E 7a 04 00 ff 8f e8` | Confirmed bytes |
| E42 | 14:229, :235, :237 | PINF/FIND/PAIR roles | They are acks. Evidence: `0xFFF3A50B 61 c1`, `0xFFF3A57F 61 f1`, `0xFFF3A77B f8 e4 05`, `0xFFF3A8CF 75 51 2b`; PINF comes only from F3D5 (`0x07336C ac 09`) | Confirmed bytes, roles Inferred |
| E43 | 51:251 | F3D5/F3D6 identity handshake | They are Bluetooth delete and (re)connect: `0xFFF383DE 05 8a 18 00`, `0xFFF381A8 05 9d 16 00` | Confirmed bytes, labels Inferred |
| E44 | 07:103 | 10-bit word reads | They are byte reads: `0x0032D2 2c 94`, `0x003346 2c 90`, plus `2c 96`/`2c 98`/`2c 9a` at `0x0032EA`/`0x003308`/`0x003320` | Confirmed |
| E45 | 04:195 | no A/D vector handler | Vector 67 is `0x00010C 00 00 24 b6` (`sub_24B6`). Init writes `0x0021EE fc 00 3c a0 3c a1` | Confirmed |
| E46 | 04:213, :219 | `FFFEC0` 16-bit timer; word reads; no D/A row | `FFFEC0` is an 8-bit timer pair (`0x002336 fc 02 6a 8c fe c1`). The reads are byte reads, and D/A is at `0xFFFF68` (`0x0029A8 3e 68`) | Confirmed bytes |
| E47 | 48:119; 62:26, :92 | every `jsr Rn` loads from memory | 2 of 319 load 0: `0xFFEE2220 66 03 7f 13` and `0xFFEE223B 66 03 7f 13` | Confirmed |
| E48 | 68:30; 89:32; counts.txt:5 | reach-only 457,462 | The strict figure is 457,342. The 120 B of stale-root reach (half-open: 98 + 11 + 11) have no LE24 value pointing into them anywhere in SUB (X14) | Confirmed |
| E49 | 93:64 | dispatcher `0x073A36` | It is mid-instruction in `0x073A34 78 b0 6b 26 00 07 44 72` | Confirmed |
| E50 | 93:98–99 | n = 9 via AAD3 only | `0x01101A 6a 0c aa d4 ec 01 46 02`: `AAD4.b0` also selects n = 9 | Confirmed |
| E51 | opcode-1c.tsv:39 | `0743BC` | `0743BA` (as E25) | Confirmed |
| E52 | 101:99 | `0x062962` er5 overwrite | `0x062972 7a 05 00 ff b3 2e`. `0x062962 7a 05 00 06 21 78` is the handler load | Confirmed |
| E53 | 101:**103** (recorded as :104) | BE32 at `0x01D33E` | The BE32 `00 06 46 0e` starts at `0x01D340`, inside `0x01D33E 6e 0c 00 06 46 0e`. Its twin cite `0x01D360` is right (`0x01D35E 6e 0c 00 06 46 10`). The recorded line number is off by one | Confirmed (+ line nit) |
| E54 | 103:78 | 301 `rts/l`, 251 `rte/l` | Not reproduced. `bu_all.tsv` gives, for `rts/l`/`rte/l`: every offset 654/530, even offsets 181/73, even ∧ P6 68/4, even ∧ P7 81/4. One `rts/l` was checked: `0x0767BC 54 13` | Confirmed, not reproducible |

### C. New slips found by this lane

| # | doc:line | as written | Confirmed bytes / correction |
| --- | --- | --- | --- |
| E55 | `dsp-1c03\opcode-1c.tsv`:40 | `0743CC` + `fc 00 6a 8c b0 cc` | The run is `0x0743CA fc 00 6a 8c b0 cc`; `0x0743CC` is the store. This is the twin of E51, one row lower. 106:131 cites `0x0743CC` with no bytes and is right |
| E56 | RESUME-FULL:36; `m-wave-recon\README.md`:22 | `0x06ADE4` + `0c cb 58 70 …` | The run is `0x06ADE6 0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e`. `0x06ADE4` holds `00 2e` |
| E57 | RESUME-FULL:39–40 | other jsr sites "to the leaves" `0x06281A`, `0x06724A`, `0x062814` | `0x062806 40 16 5e 06 6f b4 40 10 5e 06 72 50 40 0a 5e 06 72 6a 40 04 5e 06 6f aa 54 70` and `0x06723A 5e 06 6f b4 58 00 00 0c 55 0c 40 08 55 22 40 04 5e 06 6f aa 54 70` show the following. `0x06281A` and `0x06724A` call `0x066FAA`, which is not one of the four leaves (it is P7 = 1). Only `0x062814` is a leaf site outside M4's demoted runs. All 12 leaf sites are P7 = 0, so the conclusion holds |

### Ledger

- **Named Δ = 0 B and proven Δ = 0 B.** No row adds or removes a credited byte against the FINAL7 masks.
- **E11 needs no mask change.** All five callers of `0x067522` are already P7 = 0 / N7 = 1, and `0x067522` itself is
  P7 = 0.
- **E19's 43 B stay N7 = 0.** They are held for the owner, as the recon README says.

## USB relevance

- **Q1 (USB): none.** No row touches the USB module `0xFFEE00`–`0xFFEE53`, a descriptor or an endpoint. E38 only moves
  a byte citation inside the vector-234 entry, `0x054D50 01 10 6d f4 6a 0c 81 3a`. The USB answers of docs 64, 73–75,
  95 and 119 stand.
- **Q2 (SDR): no.**
  - E44 and E46 make the A/D picture more precise: 8-bit byte reads of a polled SAR.
  - E06–E08 confirm that the only sample streams go *out* to the D/A for tone synthesis.
- **Q3 (DSP): unchanged.** E25–E28 and E51/E55 are address-convention fixes inside DSP-adjacent code, with no new path.

## Open

1. **Fold E11's five-caller count into the owner-facing record of doc 101 / 113.** The extra regions `0x06B10E`–`0x06B25B`
   and `0x06B3BE`–`0x06B407` are named but not functions in FINAL6. A FINAL7 seed job could make them dead functions.
2. **Check doc 122's mode-10 entry list.** A second `[A9F9] = 0x0A` writer exists at `0x01D09E fc 0a 6a 8c a9 f9`
   (P7 = 1, reached code). Doc 122 does not claim that `0x063C04` is the only entry, and its value set `{…,0x0A}` is
   unaffected. But the screen-8/10 table row names only the key-1 path. Whether `0x01D09E` is a second way into mode 10,
   or a restore, was not traced here.
3. **Apply E55/E56/E57 to RESUME-FULL and the recon README** at the next reconciliation (they are not edited here).
4. **Give doc 103's 301/251 count a scope, or retire it.** No scope tried here reproduces it (X15).

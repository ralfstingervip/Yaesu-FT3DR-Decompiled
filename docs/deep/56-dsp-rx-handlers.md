# The 28 DSP receive-state handlers (MAIN 0x056B8A)

> Lane I4. Private DB `I4_MAIN` (`ida\db\jobs\I4_MAIN\I4_MAIN.i64`), seeded with
> `--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64` (h8sxa). No other database was opened, no image
> was modified, and nothing was written to or connected with any device. Model: claude-opus-5-5.
> Image `decrypted\FT3D_MAIN_ver102_EXP.bin`, base 0, so file offset = address, big-endian.
> Job scripts: `ida\jobs\i4_dump.py` (range dumper, a copy of `h15_dump.py` with its own output
> directory) and `ida\jobs\i4_refs.py` (operand-reference census). Byte checks:
> `ida\out\dsp-rx\verify.py` reads the image directly (67 checks, 0 failures, `verify.tsv`).
> Tables, all in `ida\out\dsp-rx\`: `states.tsv`, `frames.tsv`, `messages.tsv`, `cells.tsv`,
> `ledger-delta.tsv`, `verify.tsv`. Raw listings: `ida\out\dsp-rx\work\*.txt`, `work\refs.tsv`.
> Boundary: nothing in `0x078106`–`0x07B753` was decoded or dumped. This lane covers the receive
> side only. The TX session scripts, the tick and `0xFF8DDE` belong to lane I5.

## Verdict

The table at `0x056B8A` is a C4FM **channel-data reassembler**. It is not a protocol parser for
arbitrary DSP traffic. Its index is the RAM byte `0xFFB102`.

- **Bounds.** There is no explicit bounds check. The index is only zero-extended (`and.l #0xFF`).
  Safety rests on the writers: all 79 stores to `0xFFB102` in the image are `mov.b #imm` with
  values 0–26.
- **Dead states.** States 2, 8, 14 and 23 (A8 in the header phase) are never stored, so they are
  unreachable. Slot 27 is never stored either; it is a duplicate of slot 12.
- **What the DSP sends.** It sends the already-decoded channel fields as fixed 32-byte frames.
  - `A6`/`A7`/`A8` (band A) and `B6`/`B7`/`B8` (band B) carry CSD1/CSD2/CSD3. CSD1 is the
    destination and source callsigns, CSD2 the downlink and uplink IDs, CSD3 15 text bytes plus a
    5-byte radio ID. Each frame also carries the 4 FICH bytes and 2 status bytes.
  - `A9`/`AA` (and `B9`/`BA`) carry 20- or 10-byte data-channel blocks.
  - `AB`/`BB` mean "terminator received". The vendor's own trace string says `DSP>CPU: TERM RX`.
- **Handler work.** The handlers check DT (data type), FI (frame type), the CS field and DG-ID.
  They store the three 20-byte callsign blocks in `0xFEF920`–`0xFEF961`. They reassemble data
  messages into `0xFEF962`, at most 1,040 bytes. They then validate the message by class and
  letter, filter it by destination callsign, and copy it into one of three RAM stores
  (`0xFF07A4`, `0xFF0BF4`, `0xFF1440`).
- **H15's claim holds handler by handler.** No audio, PCM, sample or IQ payload crosses the link.
  The largest per-frame payload is 26 bytes. The largest object is a ≤1,037-byte over-the-air data
  message (callsign/ID text and Yaesu digital data messages). It is not a sample stream.

## Method

What ran, all on `I4_MAIN` with `--reopen` after the first `--copy-from`:

1. **`i4_dump.py`** dumped these ranges to `work\`:
   - `0x056800`–`0x058000` and `0x058000`–`0x058F00` (`rx.txt`, `post.txt`): the assembler tail,
     `dsp_rx_frame`, the tables and all 28 handlers;
   - `0x05A47E`–`0x05AE60` (`tr.txt`, the vendor trace formatter);
   - `0x05D300`–`0x05DAB8` (`d5d.txt`, `gate.txt`);
   - `0x05EA30`–`0x05EB60`, `0x05FB70`–`0x05FC40`, `0x06C200`–`0x06C2A0`, `0x055D80`–`0x055E60`,
     `0x00C7E4`–`0x00C860`, `0x0520F8`–`0x0521D0`, `0x02F2E0`–`0x02F4F0`, `0x02FCC8`–`0x02FE40`;
   - small consumer windows.
2. **`i4_refs.py`** walked every decoded code head in `0x000000`–`0x080000`, skipping the closed
   window: 124,004 instructions. It wrote every operand that resolves to RAM ≥ `0xFE0000` and every
   call target, 60,690 rows, to `work\refs.tsv`. Writer/reader classification is by operand
   position (`mov` op1 and `bset`/`bclr` count as writes).
3. **Python byte scans of the image.** These covered:
   - every abs16 and abs32 form of `0xFFB102`;
   - 24-bit literals for `0xFEF920`/`26`/`3A`/`4E`/`62`, `0xFF07A4`/`A6`, `0xFF0BF4`/`F6` and
     `0xFF1440`/`42`;
   - displacement forms of `0x07A4`–`0x07A6`;
   - all call/branch forms (`jsr`/`jmp` abs24, BE32, `bsr`/`bra`/`bcc` 8/16) to `0x056BFA`,
     `0x05841E`, `0x056FFE` and `0x058670`.
4. **Reach check.** The handler region was compared with H9's `work\reached_insns.tsv` for the
   ledger.

Not covered:

- The UI routines that read the status cells (`0x02CD66`–`0x035EB6`, `0x046602`…) were listed,
  not decoded.
- The three downstream message engines (`0x05EEAC`–`0x05FB64`, `0x060656`–`0x063304`,
  `0x067AB0`–`0x068DC0`) were mapped by reference only.
- The meaning of the Yaesu message letters is not decoded.

## Findings

### 1. Entry, dispatch and bounds (Confirmed)

The assembler `0x05683E` hands every checksum-good frame except `9F`/`A0`/`90` to `sub_056A94`.
`A6`–`AB` and `B6`–`BB` are not ACKed; the rest are (`0x0569BE ac a6 58 50 00 86 … ac bc 45 7c`).

`sub_056A94` loads `rx[0..3]` (`0x056A94 01 00 6b 02 b0 e0`). It then forms:

- `r1h` = opcode;
- `r1l = rx[1] & 0xC0` (FI);
- `r2l = rx[3] & 3` (DT) (`0x056A9C e9 c0 ea 03`).

Gating before the jump:

- **Header-repeat counter.** While `[B111]` is set and the gate passes, `rx[6] & 0xC0 == 0xC0`
  frames run the counter `B0C5` (reloaded from `[FF8E20]`) and the 100-tick timer `0xFF9558`.
- **`A6`/`B6`.** These must pass `loc_05DA00`. Then flag table `0x056B6E[B102]` decides:
  - flag 1 (a non-A6 state) resets the machine to state 0 first;
  - flag 0 with FI=0 (a new header) also resets.
- **`AB`/`BB`.** These pass `sub_05D9E6`, then set `B0C6 = 2`, `B111 = 0` and `B113 = 0`.
- **Every other opcode** passes `sub_05D9E6`.
- **Band arbitration.** Both gates return "pass" unless `0xFF8EA0` bit 7 is set. When it is set,
  `0xFFBC5D` latches which band (`A6` → 0, `B6` → 1) owns the sequence, and frames from the other
  band are refused while `B111` or `B102` is non-zero (`0x05D9E6`–`0x05DAB4`).

The jump itself:

```
056B58  6a 0b b1 02              mov.b  @0xFFB102:16, r3l
056B5C  7a 63 00 00 00 ff        and.l  #0xFF, er3          ; the only "bound"
056B62  10 73                    shll.l #2, er3
056B64  78 b0 6b 26 00 05 6b 8a  mov.l  @(0x56B8A:32,er3), er6
056B6C  59 60                    jmp    @er6
```

- Flag table `0x056B6E` (28 bytes): `00 01 01 00 01 01 01 01 01 00 01 01 01 01 01 00 01 01 01 00
  01 01 01 01 00 01 01 01`. The zeros are exactly the A6-expecting states 0, 3, 9, 15, 19 and 24.
- Jump table `0x056B8A`–`0x056BF9`: 28 BE32 slots. Each one is byte-checked in `verify.tsv`.
- All 79 writers of `0xFFB102` are `fc XX 6a 8c b1 02`, i.e. `mov.b #XX,r4l` then a store. The
  values are {0, 1, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 24, 25, 26},
  with 0 used 33 times (`verify.py`).
- The only readers are `0x056B10`, `0x056B58`, `0x057154`, `0x057E4E`, `0x057F0C`, `0x05D9F6` and
  `0x05DA10`.
- There is no out-of-range path.

**Correction to the H2 seed.** IDA's function `0x056BF8`–`0x056C2C` begins 2 bytes inside slot 27
(`0x056BF6 00 05 8c 06`). The real routine starts at `0x056BFA`: `fc 14 f4 00 7a 05 00 00 4c 14`,
which copies 20 ROM spaces to `0xFEF926` and `0xFFB0E7`. It has no caller of any form in the image
(Not found; scope: the whole of `0x000000`–`0x080000`, all call/branch/pointer forms).

### 2. Field layout the handlers use (Confirmed bytes; naming Inferred from C4FM)

| rx byte | Use | Evidence |
| --- | --- | --- |
| `[0]` | opcode; `Ax` = band A, `Bx` = band B (Inferred from `BC01`/`BC02` = `0xB6` selecting the B records at `0x05D3CE`, `0x05D484`) | |
| `[1]` b7:6 | FI: 0 = header, 1 = communication | `cmp.b #0x40, r1l` in every handler |
| `[1]` b5:4 | must equal 2 | `0x056F06 6a 0c b0 e1 ec 30 11 4c 11 4c ac 02` |
| `[1]` b3:2 | CM; 0, 1 and 3 accepted | `0x056F18`–`0x056F26` |
| `[1]` b1:0 | BN, block number in data-FR mode | `0x0588EA` |
| `[2]` b7:6 | BT, last block number | `0x0588FA` |
| `[3]` b1:0 | DT (0 V/D-1, 1 data FR, 2 V/D-2, 3 voice FR) | `0x056A9E ea 03` |
| `[4]` & `0x7F` | DG-ID compared with `[8ED6]`/`[8ED8]`, or `[8D24]`/`B131` in host-link mode | `0x056FDE` |
| `[5]` | data frame number (high nibble) and frame count (low nibble) | `0x05868E` |
| `[6]` | DSP status: b7:6 header-repeat, b2 ID-list match (Inferred), b0 V/D-2 gate | `0x056F3A`, `0x056FF4`, `0x057B3E` |
| `[7..26]` | 20-byte payload; `[7..16]` for `AA`/`BA` | copies below |
| `[31]` | additive checksum (assembler) | H15 |

The vendor's trace formatter `0x05A7F2` prints `A6`/`A7` as op, 6 hex bytes, 10 chars, 10 chars
(`0x05A8CE`–`0x05A946`), and `A8` as op, 6 hex, 15 chars, 5 chars (`0x05A948`–`0x05A9BE`). It maps
`9C`/`9E`/`AB`/`BB` to the strings at `0x05AF34`/`0x05AF4C`/`0x05AF5E` (`DATA TEXT SET`,
`TERM TX`, `TERM RX`).

### 3. The state machine (Confirmed; full table in `states.tsv`)

Four parallel tracks run off state 0, one per DT. Each track is header then CSD1/CSD2/CSD3, then
data:

| DT | Header (FI=0) | Comm (FI=1) | Data | Bytes/frame |
| --- | --- | --- | --- | --- |
| 0 V/D-1 | 0 →A6→ 1 →A7→ 3 | 3 →A6→ 4 →A7→ 5 →A8→ 6 | 6: `A9`, count < 6 | 20 |
| 2 V/D-2 | 0 → 7 → 9 | 9 → 10 → 11 → 12 | 12: `AA`, count < 3 | 10 |
| 1 data FR | 0 → 13 → 15 | 15 → 16 → 17 → 18 | 18: `A9`, count < 14, BN/BT blocks; 19 → 20 → 21 resync between blocks | 20 |
| 3 voice FR | 0 → 22 → 24 | 24 → 25 → 26 → 24 (loop) | none; `sub_058E02` on each A8/A6 cycle | — |

From state 0, an `A6` with FI=1 jumps straight to 4/16/10/25.

**Dead branches (Confirmed).** `0xFFB110` has one writer, `0x056F14 6a 8c b1 10`. It stores the
CS field after the `== 2` test, so it always holds 2. Every "`B110 == 0`" or "`B110 != 2`" branch
(→ 6/12/18/24 from A6, or from A7 states) is therefore dead. The header A8 states 2, 8, 14 and 23
are never stored. Any opcode/DT/FI mismatch outside state 0 runs the common reset: `B107 = 0xFF`,
`B256 = B103 = B105 = 0`, `FEF926 = FEF93A = FEF94E = 0xFF`, `B102 = 0`.

**DG-ID (state 0, `0x056F34`–`0x05703E`).**

- `r4l = 1` when a DG-ID filter is active. The expected value `r4h` comes from:
  - band A: `[8ED6]`;
  - band B: `[8ED8]`/`[8ED6]` per `B0D6`;
  - host-link mode: `[8D24]` or `B130`/`B131`.
- Accept (`B111 = 1`) when `rx[4] & 0x7F` is `0x7F` or equals the expected value, or when
  `[AA35]` b6 is set.
- With the host link off and `rx[6]` b2 set, `rx[4]` is rewritten to the expected value and the
  frame is accepted.
- Otherwise `B111 = 0` and `B113 = 2`.
- Header assembly continues either way. `B111`/`B113` are read by the UI routines
  `0x02CD66`–`0x034736` (DG-ID squelch, Inferred).
- `0x056FFE 0d 4b 5e 05 6c be` (`jsr sub_056CBE`, a search of the 24-entry ID list at `0xFF4576`)
  is unreachable: nothing branches to `0x056FFE`. The DSP's own `rx[6]` b2 has taken over that test
  (Inferred: the list is pushed to the DSP by TX opcode `0x15/0x01`, doc 52).

### 4. Payload moves (Confirmed), with H15's audio claim re-tested

| Handler | Source | Destination | Size |
| --- | --- | --- | --- |
| A6 states 0/3/9/15/24 | `rx+1` | `0xFEF920` (`0x057130 7a 05 00 ff b0 e1 7a 06 00 fe f9 20`, `fc 1a`) | 26 |
| A7 states | `rx+7` | `0xFEF93A` (`0x057312`) | 20 |
| A8 states | `rx+7` | `0xFEF94E` (`0x0577C0`) | 20 |
| A9 states 6/18 | `rx+7` | `*[B118]`, from `0xFEF962` (`0x0586C0 fc 14`) | 20 per frame |
| AA state 12 | `rx+7` | `*[B118]` (`0x058C4E fc 0a`) | 10 per frame |
| `sub_056C2C` | `rx+12` | `0xFF4706` when `[FF4705]==1` (`0x056C46`) | 16 |
| host-link `sub_06C200` | `rx+1`, `rx+7` | `0xFFB3BE`, `0xFEEB2A…` (tags '1'/'2'/'3') | 6 + 20 |

The accumulator `0xFEF962` is bounded by the nibble checks:

| Mode | Limit | Maximum |
| --- | --- | --- |
| V/D-1 | ≤ 5 frames × 20 | 100 B |
| V/D-2 | ≤ 2 frames × 10 | 20 B |
| data FR | ≤ 4 blocks (BT ≤ 3) × 13 frames × 20 | 1,040 B |

The 1,040-byte maximum ends exactly at `0xFEFD72`, the next buffer.

Messages end at an `0x03` byte followed by an additive checksum. For `Nb`, the length is also
preset from `rx[15..16]` or `0x400`, plus `0xB` (`0x058962`).

**Re-test of H15.** Every multi-byte move above is callsign/ID text or a data-channel message. No
handler accepts a stream: each frame is one 32-byte turn, and no buffer is a ring of samples.
Confirmed for all 23 live states.

**Over-the-air data (note for lane I1).** A data-FR message of up to 1,037 bytes (`N` class `b`)
is the one large received object, and it is a plausible carrier for pictures or files sent over
the air (Inferred from size only). It lands in `0xFF07A4`/`0xFF07A6`, whose readers use offsets,
e.g. `0x05EECE mov.l #0xFF07ED`.

**No RX handler writes `0xFF5806`–`0xFF5B06`** (Not found; scope: all 60,690 operand refs plus
24-bit literal scans). However:

- the `G` store `0xFF1440`/`0xFF1442` is shared with the image-push area;
- `0x055DFC` copies `0x118` bytes from `0xFF9800` into `0xFF1489` (`0x055E06 79 04 01 18 7a 05 00
  ff 98 00 7a 06 00 ff 14 89`), called from `0x047B66`.

### 5. Message classes and downstream (`messages.tsv`, `cells.tsv`)

- **Dispatch.** Completion dispatches on `FEF963` (`'^' '"' 'N' ']' 'G'`), then on the `FEF964`
  letter against ROM letter tables `0x40CC`/`0x41CC`/`0x42CC`/`0x43CC` and per-letter length
  checks.
- **Destination filter `sub_058E6E`** (`0x058E80`, `0x059B44 2a×10`):
  - group (CM=0) must be addressed to `**********`;
  - individual (CM=3) must be addressed to the own callsign `0xFFA8DA`;
  - radio-ID (CM=1) needs 5 alphanumeric characters.
- **Stores.**
  - `N` → `0xFF07A4`; readers in `0x05EEAC`–`0x05FB64`.
  - `]` → `0xFF0BF4`; readers in `0x060656`–`0x063304` and `0x068E9A`. The TX builder `0x0594FA`
    also reads `0xFF0BF6`.
  - `G` → `0xFF1440`; readers in `0x067AB0`–`0x068DC0` and `0x06C22A`.
  - The letter goes to `B259`/`B267`/`B3FA`, which those readers poll and clear.
- **Host-link copy.** In host-link mode `sub_05EA3A` also copies the message to `0xFEFD72`.
- **Caller registration.** `sub_05D3BA`/`sub_05D720` copy the source callsign `FEF930` (or the one
  inside the message, `FEF988`) and the radio ID `FEF95D` into per-band records:
  - band A: `0xFFA81E`, `0xFFB1C6`, `0xFFAA04`;
  - band B: `0xFFBC8E`, `0xFFBC0C`, `0xFFBC20`.
  `0x0520F8`/`0x052164` then pass a 12-byte line (2-character tag + 10-character callsign) to
  `sub_00C7E4`, which queues it at `*[FFBC2C]+4`.
- **IPC.** No direct MAIN→SUB IPC emit site sits in any of these readers (checked against H5
  `main-sites.tsv`). The SUB path is indirect and was not traced (Unknown).

### 6. Hand-reconstructed C

```c
/* 0x056A94 */
void dsp_rx_frame(void) {
    uint8_t op = rx[0], fi = rx[1] & 0xC0, dt = rx[3] & 3;
    if (B111 && gate_5D9E6() == 0) {                                /* 0x056AA0-0x056AD2 */
        if ((rx[6] & 0xC0) == 0xC0) {                               /* header repeat */
            if (B0C5) { if (--B0C5 == 0) T9558 = 0; else T9558 = 100; }
        } else { B0C5 = F8E20; T9558 = 100; }
    }
    if (op == 0xA6 || op == 0xB6) {
        if (gate_5DA00()) return;
        if (resync_flag[B102] || fi == 0) rx_reset();               /* back to state 0 */
    } else if (op == 0xAB || op == 0xBB) {                          /* TERM RX */
        if (gate_5D9E6()) return;
        B0C6 = 2; B111 = 0; B113 = 0;
    } else if (gate_5D9E6()) return;
    rx_state[(uint8_t)B102](op, fi, dt);                            /* 0x056B8A, no bound */
}

static void rx_reset(void) {                                        /* inlined ~40 times */
    B107 = 0xFF; B256 = 0; B103 = 0; B105 = 0;
    FEF926 = FEF93A = FEF94E = 0xFF; B102 = 0;
}

/* state 0, 0x056EE4 (abridged) */
void rx_s0(uint8_t op, uint8_t fi, uint8_t dt) {
    if (op != 0xA6 && op != 0xB6) return;
    BC01 = op;
    if (dt == 2 && fi == 0x40 && B111 && !(rx[6] & 1)) return;
    uint8_t cs = (rx[1] & 0x30) >> 4; if (cs != 2) return; B110 = cs;      /* always 2 */
    uint8_t cm = rx[1] & 0x0C; if (cm != 0 && cm != 4 && cm != 0x0C) return;
    dgid_check();                                  /* sets B111/B113, B0C5, T9558 (section 3) */
    if (op == 0xA6) { B112 = dt; if (dt == 1) { B11C |= 1; T957B = 50; } }
    else            { BC5F = dt; if (dt == 1) { B11C |= 2; T958C = 50; } }
    static const uint8_t hc[4] = {1, 13, 7, 22}, cc[4] = {4, 16, 10, 25};
    if (fi == 0x00) B102 = hc[dt]; else if (fi == 0x40) B102 = cc[dt]; else return;
    BC02 = BC01; memcpy(FEF920, &rx[1], 26);
    if (F8DDE) host_hdr('1');                      /* 0x06C200 */
    dpid_capture();                                /* 0x056C2C */
}

/* state 16 (DT1, A7), 0x0578D2: the CSD2 pattern shared by every A7 state */
void rx_s16(uint8_t op, uint8_t fi, uint8_t dt) {
    if ((op != 0xA7 && op != 0xB7) || dt != 1 || fi != 0x40) { rx_reset(); return; }
    B102 = 17;                                     /* B110 == 2 always */
    if (FEF93A == 0xFF) { memcpy(FEF93A, &rx[7], 20); if (F8DDE) host_hdr('2'); }
}

/* state 18 (DT1 data), 0x058874 (abridged) */
void rx_s18(uint8_t op, uint8_t fi, uint8_t dt) {
    if (op == 0xB9) B11C |= 0x80; else B11C &= ~0x80;
    if ((op != 0xA9 && op != 0xB9) || dt != 1 || fi != 0x40) goto fail;
    uint8_t n = rx[5] >> 4, cnt = rx[5] & 15;
    if (n != B108 || cnt >= 14) goto fail;
    if (B109 == 0xFF) { B109 = cnt; B10C = cnt; } else if (B109 != cnt) goto fail;
    if ((rx[1] & 3) != B10A) goto fail;
    uint8_t bt = rx[2] >> 6;
    if (B10B == 0xFF) { B10B = bt; B10D = bt; } else if (B10B != bt) goto fail;
    if (B108 == 1 && B10A == 0 && rx[8] == 'N')          /* preset expected length */
        B256 = rx[9]=='b' ? ((rx[15]<<8|rx[16]) ? (rx[15]<<8|rx[16]) : 0x400) + 0xB
             : rx[9]=='c' ? 0x4F : rx[9]=='d' ? 0x61 : rx[9]=='e' ? 0x0D : 0;
    if (!append(&rx[7], 20)) return;                     /* copies to *B118, sums into B104,
                                                            stops at ETX 0x03 */
    if (--B10C) { B108++; return; }                      /* more frames in this block */
    if ((int8_t)--B10D < 0) goto fail;
    B108 = 1; B109 = 0xFF; B10A++; B102 = 19; return;    /* resync on CSD1..3, then 18 */
    /* on ETX + good checksum: */
    /* if host link: relay_5EA3A(); else switch (FEF963) { case '^': cls_5863A(); case '"':
       cls_58616(); case 'N': cls_57FC0(); case ']': cls_58060(); case 'G': cls_58440(); }
       then the reset sequence without the B107=0xFF store (0x058B9A) */
fail:
    if (F89C4 & 0x10) AAE0 = 0x16;
    rx_reset();
}

/* 0x058E6E: destination filter, 0 = accept */
int dest_filter(void) {
    switch (FEF920 & 0x0C) {                   /* CM of the stored CSD1 */
    case 0x04: return !alnum5(&FEF92B);        /* radio-ID addressing */
    case 0x0C: return memcmp(&FEF926, own_call_FFA8DA, 10) != 0;
    default:   return memcmp(&FEF926, "**********", 10) != 0;   /* ROM 0x059B44 */
    }
}
```

## USB relevance

- **Q1 (USB).** No receive handler touches `0xFFEE00`–`0xFFEE53` or the closed window
  (refs census). The only external relay of received data is the `0xFF8DDE` host path (SCI-A,
  H15).
  - Lane I1 lead: the `G` message store `0xFF1440`/`0xFF1442` is also written by `0x055DFC` from
    `0xFF9800`, next to the image-push driver.
  - The RX path never writes `0xFF5806`–`0xFF5B06`.
- **Q2 (SDR).** No, at this link, now per handler. The DSP returns decoded CSD fields and data
  messages. The largest is 1,040 B per message, at ≤ 26 B per 32-byte frame turn. No sample or IQ
  path exists.
- **Q3 (DSP).** The receive side accepts only the fixed opcode set `0x86`–`0xBB`. Only
  `A6`–`AB`/`B6`–`BB`, `9C`, `9E` and `9F` change state, and every value written is a constant.
  The one unbounded-looking jump is safe by construction.

## Open

1. Lane I1: trace `0xFF9800` (the source of `0x055DFC`) and the `N`-store readers
   `0x05F330`–`0x05FB64`. Together they decide whether over-the-air pictures reach the image-push
   buffers.
2. Name the message letters (`]`, `N`, `G`, `"`, `^`) by decoding the three downstream engines
   (`0x05EEAC`–`0x05FB64`, `0x060656`–`0x063304`, `0x067AB0`–`0x068DC0`).
3. Lane I5 shared state:
   - `B12D` b0/b7 (set here on `9C`/`9E`) are consumed by the session scripts
     `0x059C28`–`0x05C44C`;
   - `B0A4`/`B0B2` are the link flags;
   - the TX header builder `0x0594FA` reads `0xFF0BF6`, the same store the `]` receive path fills,
     and `0x05B04C` writes it.
4. Confirm the `rx[6]` bit meanings (b2 = ID-list match, b0 = V/D-2 gate) against the TX `0x15`
   list push.
5. Remove the bogus function head `0x056BF8` from the next MAIN seed and create `0x056BFA` as an
   unreferenced function.

Ledger: **no change**. MAIN named/typed stays 497,139 and proven stays 365,570.
`ida\out\dsp-rx\ledger-delta.tsv` lists every range touched. All of them are absent from H9's
`reached_insns.tsv`: `0x056B6E`–`0x056C2C`, `0x056FFE`–`0x057006`, `0x058398`–`0x0583C8`,
`0x05841E`–`0x058440` and `0x058670`–`0x058674`. The other 8,886 of 9,170 bytes in
`0x056A94`–`0x058E66` are already reached. This lane adds no reached bytes and retypes none, so
there is nothing to double count against `ida\out\main-descent\ledger-delta.tsv`.

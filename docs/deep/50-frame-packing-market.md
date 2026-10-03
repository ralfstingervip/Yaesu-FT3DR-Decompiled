# 50 — MAIN→SUB settings-frame packing, the destination (market) byte, SCAN WIDTH record (lane H12)

Owner-side static analysis of the owner's FT3DR/FT3DE ver 1.02 images. MAIN (`decrypted\FT3D_MAIN_ver102_EXP.bin`) is H8SX, big-endian, base 0. SUB (`decrypted\FT3D_SUB_ver102_ALL.bin`) is RX64M, little-endian, at `0xFFC00000`. Nothing was written to any device and no image was modified. The closed MAIN window `0x078106`–`0x07B753` was not analysed. Model: **Opus 5.5 (`claude-opus-5-5`)**.

Tables: `ida\out\frame-pack\senders.tsv` (one row per generic sender) and `ida\out\frame-pack\market.tsv` (every site that reads or writes the destination bytes). The raw IDA listings behind every claim are `ida\out\frame-pack\main1.txt`..`main8.txt` and `sub1.txt`..`sub3.txt`, with the request files `req_*.txt` beside them.

## Verdict

1. **Frame packing (Confirmed).** All the generic senders use the same shape. Each sets total/opcode/len at `FF3D72/74/76`. It then writes 0, 2 or 3 header bytes at frame `+0x20`, and copies N bytes from the staging buffer `FFB05A` into the frame in address order. The copy is `mov.w`/`eepmov.w`. The total is always `0x28 + payload bytes`.
   - Multi-byte values are big-endian only because H8 `mov.w`/`mov.l` stores to `FFB05A` put the high byte first. In practice every field is a byte or a bit.
   - The SUB never reassembles an integer. Its store handlers copy `0x8E46+k → 0x8C4D+k` byte by byte, and the byte counts match MAIN's exactly for all 25 codes checked.
2. **`sub_3ECB8` is a destination test (Confirmed).** It returns Z iff `FF800F == 0`.
   - The factory-default routine (`sub_DEFA`) calls it at `0x0E80E`. For any destination ≠ 0 it sets English (`bset #1,@FF89C2` at `0x0E832`), sets TIME ZONE `0x1A` (UTC 00:00), and sets six other defaults.
   - So **destination 0 is the Japanese-default market**. The language default follows from this, but the radio does not test the language bit itself.
3. **The destination source.** It is a three-byte set:
   - `FF800F`: index 0..7, persisted in EEPROM `0x21` per pc-02. A virgin or invalid EEPROM defaults it to **2** (`0x0DE0A`).
   - `FF8010`: sub-variant 0/1.
   - `FF8011`: **a hardware strap**, port `0xFFFF4E` bit 2, re-sampled on every boot by `sub_DDE4`.

   The string `"USA JPN EXP "` at `0x06BE28` is *not* indexed by `FF800F`. It is indexed by `sub_734BE`, which returns the constant 2, so it always yields `EXP`: the build identity. The per-destination code names live at `0x68A8`: ` F1 `, ` A1 `, ` B1 `, ` C1 `, ` D1 `, ` H1 `, `***`, `HAM`.

   About 50 sites read `FF800F`. They change band-plan edges, default frequencies, step/mode tables, factory defaults and clone-load conversion. Four of the gates are no-op branches.
4. **A hidden destination editor exists (contradicts doc 12 §8.2).**
   - **Path (Confirmed):** the power-on key table `0x10216` has a parallel handler-pointer table at `0x10242`. Index 7 dispatches `0x1026E` → `sub_10276`, which opens screen `0xE8`. Its commit at `0x0236E2` writes `FF800F`/`FF8010` to EEPROM and restarts.
   - **Gates (Confirmed):** an opening-message comparison against a ROM constant. If the strap `FF8011` = 0, the only choices are destinations 2↔3.
   - **Purpose:** Inferred.
5. **SCAN WIDTH (Confirmed).** Record `+0x50` (VFO) and `+0x51` (MEMORY) live in three RAM records: `FF8EE0`, `FF8FE8` and `FF90F0`, each `0x108` bytes.
   - Every UI and default writer stores **3 or 4**.
   - The PMS path stores **5 + pair index** (`sub_1D966`). So the "blank" draw on the SUB is reachable for values ≥ 5 (Inferred: whenever a PMS scan range is active).
   - **No writer stores 0..2.** Those values can come only from a restored or cloned image.
6. **The SUB number formatters (Confirmed).**
   - `sub_FFEE1FCB(char *dst, uint8 *len, uint16 v)`: left-aligned, 1–3 digits, `v % 1000`.
   - `sub_FFEE1E8D(char *dst, uint16 v)`: exactly 5 characters, right-aligned, leading zeros become spaces.
   - Neither inserts commas.

## Method

- **Private databases, via `run_job.py` only.**
  - `H12_MAIN`: `--copy-from ida\db\jobs\H1_RECOUNT\H1_RECOUNT.i64` (`h8sxa`).
  - `H12_SUB`: `--copy-from ida\db\jobs\G3_SUB\G3_SUB.i64`.
  - Both were then iterated with `--reopen`. Every run exited `idat_exit 0` and no `h12_dump_error.txt` was written.
  - No shared DB was opened and `run_ida.py` was not run.
- **Script.** `ida\jobs\h12_dump.py` is a copy of `h6_dump.py` (`auto_wait`, try/except traceback file, UTF-8 out, `qexit(0)`). It adds two commands:
  - `displ`: every code head whose `o_displ` displacement is in a set, over `[lo,hi)`;
  - `ctx`: a read-only context window.
  - Note that the `lin`/`range` commands re-create code at data bytes. They were used only inside the private DB.
- **Scope.**
  - The 8 assigned senders plus their neighbours `0x97DC`–`0x9C8E`, all callers of each, and `sub_9A8E`.
  - The SUB store handlers for groups 1, 2/0x15–17, 4, 5, 6, 8, 9, 0xA and 0xB (`FFEFE727`, `FFEFEA4B`, `FFEFF034`, `FFEFF4E5`, `FFEFF68A`, `FFEFF906`, `FFEFFEB8`, `FFF000AC`, `FFF00220`), with the jump tables `FFF48150` (g4), `FFF4816C` (g8) and `FFF4819C` (g9) decoded from file bytes.
  - Every reference to `FF800F`/`FF8010`/`FF8011`/`F6C2` in IDA's code heads `0..0x80000`.
  - Every `@(0x50|0x51,ERn)` access in `0..0x078106` and `0x07B754..0x80000`, cross-checked by a raw-byte scan for `6E xx 00 50/51` over `0..0x80000` minus the closed window: 17 + 16 hits, all `er0`-based.
  - Absolute aliases `FF8F30/31`, `FF9038/39` and `FF9140/41`.
- **Not done.**
  - Purposes of the 11 `sub_3ECDE` callers and most `sub_3F386` users.
  - The screen-`0xE8` draw handler.
  - The eepmov block copies between records at `0x24AE8`..`0x24D38` and the EEPROM save/restore family `0x3974E`..`0x3A0FE`. These move whole records, so they preserve whatever values the writers below stored.
  - The key identity of port value `0x73`.

## Findings

### 1. Generic sender packing

**Mailbox (Confirmed, every sender).**
- `mov.w #T,r4 ; mov.w r4,@FF3D72` sets the total.
- `mov.w e3,@FF3D74` sets the opcode; the caller loads `e3 = 0xF3cc`.
- `mov.w #T-10,@FF3D76` sets the length.
- Then `jsr sub_7C20` fills the shared header `+6..+0x1F` and `sub_B6B6` sends the frame.
- Frame `+0x20` is `FF3D94`, which maps to SUB latch `0x8C6D`.

| Sender | total/len | Header | Payload | Frame bytes |
| --- | --- | --- | --- | --- |
| `sub_976A` | `29/1F` | none | `r3l` | `+0x20` |
| `sub_9792` | `2C/22` | A | word `[FFB05A]` (`0x97CC 6b 04 b0 5a 6b a4 00 ff 3d 96`) | `+0x22` = caller r3h, `+0x23` = r3l |
| `sub_98CA` | `2D/23` | A | 3 B eepmov `FFB05A→FF3D96` (`0x9904`) | `+0x22..24` |
| `sub_9922` | `2E/24` | A | 4 B eepmov | `+0x22..25` |
| `sub_9A54` | `34/2A` | B | 9 B eepmov → `FF3D97` | `+0x23..2B` |
| `sub_9BDA` | `35/2B` | B | 10 B | `+0x23..2C` |
| `sub_9C16` | `3B/31` | B | 16 B | `+0x23..32` |
| `sub_9C52` | `3D/33` | B | 18 B | `+0x23..34` |

**Header A** is inline (`0x97AC`–`0x97CA`):
- `+0x20 = !(FFAD9D & 1)`;
- `+0x21 = FFAD68 − (FFAD68 ≠ 0)`.

**Header B** is `sub_9A8E` (`0x9A8E`–`0x9AD2`). It is a list-window header:
- `+0x20` = the same edit flag as A;
- `+0x21` = top row = `tbl[FFAD68]`, where table `0x9AF4` = `00 ×6, 01, 02 … 19` (i.e. `max(0, n−5)`), or `0x19` if `FFAD68 ≥ 0x1F`;
- `+0x22` = row within the window = `FFAD68 ? FFAD68−1−top : 0`.

**Byte order (Confirmed).** Callers fill `FFB05A` with `mov.w r3,@FFB05A`, which puts r3h at `FFB05A` (for example SCAN WIDTH, `0x56A6`). Or they fill it with `mov.l er4,@FFB05A`, which puts the e4 high byte first (DG-ID, `0x5E98E`). Or they use single `mov.b`/eepmov. The frame therefore carries the high byte at the lower offset, and SUB reads each byte as its own field.

**SUB side (Confirmed).** For every code, the store handler compares `0x8C4D+k` against `0x8E46+k`. On a difference it calls `sub_FFEEFEA4(0x8000)` (the dirty flag) and copies the byte. The multi-byte cases use `sub_FFEF208D(dst, src, n, mask)`, whose body (`FFEF20A4`..`FFEF20CB`) is a byte compare-and-copy loop that returns "changed". The counts match MAIN's:
- flags+2: F314 (`FFEFE831 cmp #2`), F340/F34C (`FFEFF126`), F353 (`FFEFF5DA`), F382/F395 (`FFEFF9F9`), F32B/F32C (`FFEFEC9E`; the case map is Inferred from the pattern);
- flags+3: F343 (`FFEFF2B8`), F354 (`FFEFF684`), F383 (`FFEFFAA3`), F3D0 (`FFF002E5`);
- F365: 6 B from `+0x20` (`FFEFF6EA`);
- group 9 totals: A4/AC/AE/B4/B7 = 5, A8 = 19, A9 = 21, B0 = 13, BD = 12. Each equals the MAIN header (2 or 3) plus N.

So doc 45's "byte order Inferred" items are now Confirmed. For example, D0 USB CAMERA is `+0x22 = [FF89CE]` SIZE, `+0x23 = [FF89CD]` QUALITY, `+0x24 = FF89C5.b1` SP SEL (`0x594C`–`0x5962`). The per-caller layouts are in `senders.tsv`.

**Hand-written C (MAIN), faithful to the instruction order:**

```c
extern uint16_t F3D72, F3D74, F3D76; extern uint8_t FRAME[];   /* FRAME = 0xFF3D74 */
extern uint8_t FFB05A[]; extern uint8_t FFAD9D, FFAD68;
static void hdr_a(void) {                       /* inline in 9792/98CA/9922 */
    FRAME[0x20] = !(FFAD9D & 1);
    FRAME[0x21] = FFAD68 ? FFAD68 - 1 : 0;
}
static void hdr_b(void) {                       /* sub_9A8E */
    uint8_t top = FFAD68 < 0x1F ? tbl_9AF4[FFAD68] : 0x19;   /* max(0,n-5) */
    FRAME[0x20] = !(FFAD9D & 1);
    FRAME[0x21] = top;
    FRAME[0x22] = FFAD68 ? FFAD68 - 1 - top : 0;
}
#define SET(op,n,hl) do{F3D72=0x28+(n);F3D74=(op);F3D76=F3D72-10;}while(0)
void sub_976A(uint16_t op, uint8_t v){ SET(op,1,0); FRAME[0x20]=v; sub_7C20(); }
void sub_9792(uint16_t op){ SET(op,4,0); hdr_a(); FRAME[0x22]=FFB05A[0]; FRAME[0x23]=FFB05A[1]; sub_7C20(); }
void sub_98CA(uint16_t op){ SET(op,5,0); hdr_a(); memcpy(&FRAME[0x22],FFB05A,3);  sub_7C20(); }
void sub_9922(uint16_t op){ SET(op,6,0); hdr_a(); memcpy(&FRAME[0x22],FFB05A,4);  sub_7C20(); }
void sub_9A54(uint16_t op){ SET(op,12,0); hdr_b(); memcpy(&FRAME[0x23],FFB05A,9);  sub_7C20(); }
void sub_9BDA(uint16_t op){ SET(op,13,0); hdr_b(); memcpy(&FRAME[0x23],FFB05A,10); sub_7C20(); }
void sub_9C16(uint16_t op){ SET(op,19,0); hdr_b(); memcpy(&FRAME[0x23],FFB05A,16); sub_7C20(); }
void sub_9C52(uint16_t op){ SET(op,21,0); hdr_b(); memcpy(&FRAME[0x23],FFB05A,18); sub_7C20(); }
/* SUB side, every code: */
bool store(uint8_t k0, uint8_t n){ return sub_FFEF208D(&L8C4D[k0], &P8E46[k0], n, 0x8000); }
```

The caller passes `op` in `e3` and `v` in `r3l`. All of these jump to `sub_7C20`, which jumps to `sub_B6B6`.

Neighbours found in the same block (not assigned; listed in `senders.tsv`): `sub_97DC` (3 B, F323), `sub_9834`, `sub_997A`, `sub_99DE` and `sub_9A1A` (8 B, F3A2).

### 2. Destination / market

**`sub_3ECB8` (Confirmed, `0x3ECB8`):**

```text
6a 0c 80 0f   mov.b @FF800F,r4l
f4 01         mov.b #1,r4h
47 02         beq   rts
ac 00         cmp.b #0,r4l
54 70         rts
```

`mov.b #1` clears Z, so `beq` is never taken, and the routine returns Z iff `FF800F == 0`. The siblings follow the same pattern:
- `sub_3ECD4`: Z iff `FF800F == 1`;
- `sub_3ECDE`: Z iff 2 ≤ `FF800F` ≤ 4;
- `sub_3ECC4`: 0 or 6, with no caller.

**The language default (Confirmed, `sub_DEFA`, factory defaults):** `0x0E80E jsr sub_3ECB8 ; beq ret` → `0x0E814`–`0x0E840`. For destination ≠ 0 this:
- sets `FF8BC9 = 0x1A` (TIME ZONE UTC 00:00, decoded per doc 45; the Japan default is `0x2C` = +09:00);
- sets `FF89BA = 6`;
- does `bset FF89BE.7` (the default for SCAN WIDTH = BAND, §3);
- does `bset FF89C0.2/.1`;
- does **`bset FF89C2.1`** (LANGUAGE = English, `0x0E832` `6a 18 89 c2 70 10`);
- does `bclr FF89C2.5`;
- sets `FF8D8E = 1`.

Before that, `0x0E7F8` `btst FF800F,@0xF6C2`, with `[F6C2] = 0x3F`, sets `FF89C0.7` and `FF89BE.3` for destinations 0–5. Afterwards `0x0E844` sets `FF89C0.0` for 2–4. So "export defaults to English" is Confirmed, with destination 0 the Japanese case. Inferred support for that identification:
- the ` F1 ` name;
- 76 MHz FM edges at index 0 (`F022`);
- TIME ZONE +9.

**Source (Confirmed).**
- `FF800F`, `FF8010` and `FF8011` are written only at the sites listed below and in `market.tsv`.
- At boot, `sub_DEFA` loops `0x80` times on `sub_39566` plus a word check against `[0xF010]`. On failure it calls `sub_DDFE`, which writes `FF800F = 2` (`0x0DE08` `fc 02 6a 8c 80 0f`) and `FF8010 = 1`.
- `sub_DDE4` samples bit 2 of `@0x4E:8` (`7e 4e 77 20` = `bld #2,@0xFFFF4E`, an input-port register per BRIEF correction 2) until two reads agree. Its result goes to `FF8011` (`0x0DE1A`, and `0x0DF46` if the value changed).

So the market is an EEPROM byte (`0x21`, from pc-02's ID-block analysis), a second EEPROM byte, and a board strap. Not found: any flash-resident destination constant other than `sub_734BE`'s build constant 2.

**The `"USA JPN EXP "` table (Confirmed, `0x06BE28`).** It is read only at `0x6BD7C` (`7a 15 00 06 be 28`, `add.l`), with index `sub_734BE()` = `fc 02 54 70` = 2. Result: `EXP` is copied into the clone header at `0xFEE016`. Doc 05 and doc 12 placed the table at `0x06BE24`/`0x06BE26`; the bytes start at `0x06BE28`.

Doc 12 §6a also tied the table to `FF800F`. That link does not hold: the per-destination 3-character code comes instead from `sub_6864` (table `0x68A8`, index `dest + {0, 8, 16}` chosen by `FF8010`/`FF8011`).

**Gated behaviour.** `market.tsv` lists 55 rows. In summary:
- the band-plan builder `sub_E9CC`, `0x0E9E0` and `0x0EA14`: 51.0→50.0 MHz and 380.0→222.0 MHz segment starts;
- per-destination BCD tables `F022`/`F042`/`F062`/`F082`/`F6A2`/`F682`, and home frequencies `F958`/`F980` (`0x0E440`–`0x0E4A6`);
- fixed-mode and fixed-step segment tables chosen by destination 0/6, 1/5 or other (`0x1E652`, `0x1E6EE`);
- menu-cycle exceptions (`0x16FAC`, `0x1D24C`, `0x14F96`);
- PLL constants (`0x2FB00`, `0x315A8`);
- `FFB963`/`FFB421` (`0x63C7A`);
- clone-load conversion switches (`0x7516A`, `0x75554`);
- the BACKUP.dat ID check (`sub_7357A`).

**No-op branches (Confirmed).** `0x0EAA8`, `0x1E524`, `0x2CE8A` and `0x3F56E` branch to the next instruction, so these tests have no effect.

**SUB side.** `sub_7C20` writes frame `+6` (`FF3D7A`, SUB `0x8C53`) as the constant **2** (`0x7C26` `fb 02 6a ab 00 ff 3d 7a`). In frames built through `sub_7C20`, no destination byte reaches the SUB; the destination's only effect there is the language bit (frame `+7` b0).
- Doc 12's reading of `0x8C53` as a market flag (WX ALERT) is therefore unsupported for the F3xx path.
- Three other word writes to `FF3D7A` (`0x0B5FC`, `0x0B672`, `0x7119A`) were not traced.

**Hidden destination editor.** This corrects doc 12 §8.2, which says only index 6 has a handler.
- **Handler table (Confirmed).** `0x101DA` `78 b0 6b 26 00 01 02 42 ; 5d 60` is `jsr @(0x10242 + 4·idx)`. That table holds 11 handlers, `{103D8, 103E6, 10506, 102A6, 73540, 10528, 10444, 1026E, 103C0, 10556, 1054A}`, so every boot-hold index has its own handler.
- **Index 7 (Confirmed).** Port pattern `0x73` → `0x1026E` → `sub_10276`.
  - It requires `sub_23410` to pass: `FF8955 == 2`, plus `FF8958`/`FF895C` equal to the ROM constant at `0x23442`/`0x23446`. That is, the opening-message fields must match a constant.
  - It also requires `FF8EA7.7` to be clear.
  - It then copies `FF800F`/`FF8010` to `AD95`/`AD96` and sets the screen to `0xE8`.
- **Edit and commit (Confirmed).**
  - Editor helpers `0x2365C`/`0x23698` cycle the destination 0..7 when `FF8011 ≠ 0`, and only 2↔3 when it is 0.
  - Commit `0x236B8`–`0x236EE` writes `FF800F`/`FF8010`, calls `sub_39544` (EEPROM write via `sub_3AD20`), and jumps to warm restart `0xDBD8`.
- A second writer, `sub_740E2` (`0x740F6`), takes the value in a register. It is reached from `0x740D8`, which has no static xref (a dispatch table, Unknown).

Following doc 12 §6's convention, this document records the mechanism and its addresses only. The ROM constant's value and a key-to-port mapping are deliberately not decoded into a procedure.

### 3. SCAN WIDTH record `+0x50` / `+0x51`

**Records (Confirmed).** `[FF812A]` points at one of three records:
- `FF8EE0`, set at `0x216A` → `FF8122`;
- `FF8FE8`, set at `0x217E` → `FF8126`;
- `FF90F0`.

They are `0x108` apart: the aliases `FF8F30`/`FF9038`/`FF9140` are written together at `0x0E8CE`–`0x0E8D6`. The packed-record unpack `sub_3FB0C` writes only working `+0x12..+0x39`, so `+0x50/+0x51` is VFO/scan state, not memory-channel data. The sender is `0x569E`: `6e 03 00 50` and `6e 0b 00 51` → `mov.w r3,@FFB05A`, plus `FF89C5.6` → `FFB05C`, then `sub_98CA` with F354.

**Every writer (Confirmed).**

| Site | Field | Value |
| --- | --- | --- |
| `0x16AD0` (menu VFO field, handler table `0x16AAE` [1]) | +0x50 | `loc_3F628` with limits `{03,04,&FFAA56}` (`0x16AF6`): up/down within 3..4; any out-of-range value becomes 3 (up) or 4 (down) |
| `0x16AE8` (menu MEMORY field, [2]) | +0x51 | same, table `0x16AFC` = `03 04 00ff aa56` |
| `0x1C748` (`sub_1C724`) | +0x50 | if ≥5 and PMS slot `[FF92DE+(v−5)]` == 0 → `3 + !FF89BE.7` |
| `0x0E8CE`–`0x0E8D6` (`sub_E8AE`, reset `0xDCDE`) | +0x50 ×3 | `3 + !FF89BE.7` (`bild #7` / `add.b #3`) |
| `0x0E936`–`0x0E93E` (`sub_E934`, also clone-load `0x74DF4`) | +0x51 ×3 | 4 |
| `0x10466`–`0x1046E` (boot-hold index 6 handler `0x10444`) | +0x51 ×3 | 4 |
| `0x1D982`/`0x1D988` (`sub_1D966`) | +0x50 | `5 + sub_1D950()` = `5 + ((word+8 − 1000) & ~1) / 2` (PMS pair index) |
| `0x1D994` | +0x51 | same value, if the old value ≥ 5 |
| `0x239CC` | +0x51 | copied from the previous record's `+0x51` |

Readers distinguish `<3`, `3`, `4` and `≥5`. For example `0x237C4 cmp #5` → PMS path `sub_23914` (which subtracts 5 at `0x23934`), and `0x237DA cmp #3`.

**Conclusion.**
- Values ≥ 5 are produced by firmware: the PMS path is Confirmed. They reach the SUB unchanged through `0x569E`, where `FFF03513`/`FFF03533` draw them blank. That this occurs whenever a PMS range is the active scan width is Inferred.
- Values 0–2: **Not found** among the writers. The scope was every `@(0x50/0x51,ERn)` site and every absolute alias in `0..0x80000` excluding the closed window.
- 0–2 can therefore only arrive through the record block copies, EEPROM restore or clone load of an image holding such bytes (Inferred). The reader at `0x237D6` handles that case defensively.
- The default is BAND (3) when `FF89BE.7` is set, which the factory-defaults routine does for destination ≠ 0, and ALL (4) otherwise.

### 4. SUB number formatters

Both use the digit table `FFC0012D` = `"0123456789ABCDEF"`.

```c
/* sub_FFEE1FCB (FFEE1FCB-FFEE206B, rtsd #3): callers FFEE51BD, FFF07B07 (BD SmartBeaconing), FFF0C320 */
void fmt_u3(char *dst, uint8_t *len, uint16_t v) {
    v %= 1000;                                       /* divu/mul #3E8h */
    if (v >= 100) { *dst++ = HEX[v / 100];      (*len)++; }
    if (v >= 10)  { *dst++ = HEX[(v % 100) / 10]; (*len)++; }
    *dst = HEX[v % 10]; (*len)++;                    /* no NUL written */
}
/* sub_FFEE1E8D (FFEE1E8D-FFEE1FC9, rtsd #4): callers FFF07F5C, FFF07FD9, FFF08056 (MEMORY INFO), FFF0AB93 */
void fmt_u5(char *dst, uint16_t v) {                /* exactly 5 chars, right-aligned */
    static const uint16_t p[4] = {10000, 1000, 100, 10};
    bool started = false;
    for (int i = 0; i < 4; i++) {
        uint8_t d = v / p[i]; v %= p[i];
        if (d == 0 && !started) *dst++ = ' ';
        else { *dst++ = HEX[d]; started = true; }
    }
    *dst = HEX[v];                                   /* units always a digit */
}
```

The comma grouping and the "MB" unit that doc 45 reports for MEMORY INFO are therefore added by the callers (`FFF07F37`..`FFF08056`), not by `sub_FFEE1E8D`.

## USB relevance

No change to the three mission answers. Everything here is MAIN→SUB display IPC on SCI_6 → SCI0, plus EEPROM-resident destination data. No USB endpoint, sample path or DSP access is involved.

Two points matter to the owner:
- **The radio's band limits and defaults are a function of `FF800F`/`FF8010`/`FF8011`.** These are an EEPROM byte pair plus a board strap. A hidden firmware path rewrites the byte pair and is gated as described in §2.
- **The BACKUP.dat region check** (`sub_7357A`) compares exactly these three bytes.

## Open

1. **Screen `0xE8` draw handler** (MAIN `0x046D2`/`0x34AA0`/`0x356D0`/`0x357F0` compare `0xE8`), and the SUB side: does it show the `0x68A8` names?
2. **The 11 `sub_3ECDE` callers** (destinations 2–4) and the `sub_3F386` index tables (`0x1C2BA`..`0x75096`): name the behaviour behind each.
3. **The handlers of the other boot-hold indices** (`0x103D8`, `0x103E6`, `0x10506`, `0x102A6`, `0x73540`, `0x10528`, `0x10556`, `0x1054A`). Doc 12 §8.2 assumed these were flag-only.
4. **The caller of `0x740D8`** (the register-argument destination writer). It is probably an entry in a DATA-jack command table.
5. **The other `FF3D7A` word writers** (`0x0B5FC`, `0x0B672`, `0x7119A`), to settle whether any frame carries a market byte to SUB `0x8C53`.
6. **The record block copies** (`0x24AE8`..`0x24D38`) and the EEPROM restore family (`0x3974E`..`0x3A0FE`), to state exactly how a 0–2 SCAN WIDTH value could be restored.

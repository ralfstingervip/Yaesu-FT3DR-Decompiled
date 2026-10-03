# Accessory PTT frame at `FF9800` (lane L10)

## Verdict

`FF9800` is not an accessory port buffer. It is MAIN's single receive buffer for the framed SUB→MAIN
link on SCI_6 (doc 04's "SCI-D", `0xFFF610`, 500 kbaud). The "accessory PTT" K11 found is SUB→MAIN
frame type `0xE6`. It has one payload byte, at `FF980B`, and bit 0 of that byte keys or unkeys the
radio.

SUB sends this frame from its Bluetooth driver. The driver recognises the module line
`RXAT=CKPD=200`. The character compares are Confirmed byte by byte at `0xFFF3A9D3`–`0xFFF3AA5A`.
`CKPD=200` is the HSP headset-button command, so the accessory is a **Bluetooth headset's button**
(Inferred from that string, high confidence). Each press flips SUB's state: the first press sends
`E6 … 01` and MAIN keys; the next press sends `E6 … 00` and MAIN unkeys.

On MAIN, the byte is copied to `FFBB91`. `sub_FD22` turns it into raw key `0x17`/`0x18`. The key
translator turns that into event 14/15, the same TX request (`sub_2244C`) and release (`sub_22718`)
that the hardware PTT uses. MAIN polls this path only when `FF8920` bit 0 is set. That bit is EEPROM
`0x580` bit 0, toggled by `sub_19CFE`. Doc 58 labels the item "Bluetooth" (Inferred).

So this path **can key TX** when all of the following hold:

- Bluetooth is ON.
- A headset is linked, and the module has acknowledged `TXAT=1`.
- One of two SUB conditions holds: MAIN status bit `FF3D8C.5` is set (BT on, VOX off, `FF8920.b7`),
  or SUB word `12CB8 == 2`.

Hardware PTT activity takes priority, and clone/remote mode (`FF8004 ≥ 2`) disables the poll.

## Method

- **Databases.** Two private databases:
  - `L10_ACC_PTT`, a copy of `K1_MAIN_FINAL4` (h8sxa).
  - `L10_ACC_PTT_SUB`, a copy of `K7_SUB_FINAL3` (rx). This second database was added because the
    frame source is on SUB, the same practice as K2/K5.
- **Job.** One read-only job, `ida\jobs\l10_dump.py`. It supports `dis`, `func`, `xref`, `callers`,
  `refrange` and `imm`. `refrange` normalises every operand addr/value to 24 bits on MAIN.
  Requests and outputs are in `ida\out\accessory-ptt\work\` (`req*.txt`/`out*.txt` for MAIN,
  `reqs*.txt`/`outs*.txt` for SUB).
- **MAIN scope.** Every code head in `0x000000`–`0x07FFFF`, except the closed window
  `0x078106`–`0x07B753`, scanned for operands in:
  - `FF9800`–`FF991F` (75 hits);
  - `FF8920`, `FFBB91`/`92`, `FFBA92`, `FFBAD7`, `FFAAD2`, `FFA9ED`, `FFAC0A`.
- **SUB scope.** Every caller of the SUB→MAIN frame builders `sub_FFEDD528` (17 sites) and
  `sub_FFEDD182` (5 sites), every reference to the Bluetooth state words, the callback slots
  `683B0`–`683DF`, and the module line classifier `sub_FFF3A259`.
- **Verification.** `ida\out\accessory-ptt\verify.py` re-reads 137 cited byte runs straight from the
  two images. Result: **137/137 PASS**. The images are unchanged (sha256 `8e3ecd05…` / `b93570b3…`).
- **Not covered.**
  - The Bluetooth module's own firmware, which is not in the package.
  - The SUB SCI3 driver below `sub_FFEDAF2D`. Channel 2 = SCI3 `0x8A060` is taken from doc 14.
  - The full meaning of SUB word `12CB8`.
  - TX states 4/5.
  - The E4/E5/EA/FE payload semantics beyond their destination bytes.

## Findings

### 1. `FF9800` is the SCI_6 SUB→MAIN frame buffer (Confirmed)

| Step | Location | Bytes | What it does |
| --- | --- | --- | --- |
| Vectors 224, 226 | `0x000380`, `0x000388` | `00 04 4a 70` ×2 | ERI/RXI of SCI_6 go to ISR `0x044A70` |
| ISR | `0x044A74`, `0x044A84`, `0x044A8E` | `6a 0d f6 14` · `6a 0d f6 15` · `68 cd` | reads SSR `0xFFF614` (error mask `ed 38`) and RDR `0xFFF615`, then stores at the ring head `FF8146` |
| Ring | `0x044A92`, `0x044A9A` | `7a 24 00 ff 3c 6b` · `7a 04 00 ff 30 6a` | `FF306A`–`FF3C6A`, with wrap |
| Deframer | `sub_4753E`; `0x047560`, `0x04756E`, `0x047590` | `01 00 6b 04 81 42 6b 06 81 48` · `6c 4a` · `78 b0 6b 26 00 04 75 c8` | reads at the tail `FF8142`, then dispatches on state `FF9D2D` |
| State table | `0x0475C8` | 12 dwords | 0 null; 1 `sub_4761E` (start byte); 2 E0 `47792`; 3 E1 `47B7C`; 4 E3 `478AA`; 5 FF `47A7E`; 6 E2 `4799A`; 7 FE `47E2C`; 8 EA `47F4E`; 9 E4 `4802E`; 0xA **E6 `4811E`**; 0xB E5 `481FE` |

**Writers of `FF9800`–`FF9910`.** There are 25 sites, listed in `writers.tsv`.

- 10 start-byte stores in `sub_4761E`. Each is `7a 01 00 00 00 00` followed by `6e 9a 98 00`
  (`mov.b r2l,@(-0x6800:16,er1)`).
- 13 indexed body stores, one or two per type handler. All are `6e 9a 98 00`.
- One second writer: E1 GPS NMEA frames are compacted in place by `eepmov` `FF980B→FF9800` at
  `0x047C82`, with a `0x0A` terminator stored at `0x047C8C`. After that, `FF9800` holds `$GP…` text,
  which `sub_458F4`/`sub_45FBA` parse. The matches are `cmp.l #'PGGA'` at `0x047CA0` and `'PRMC'` at
  `0x047CAA`.
- Not found: any other writer, in the scope above. Register-indirect stores through a computed
  pointer are not excluded.

All bytes come from the SCI_6 ring. **No other serial link feeds `FF9800`.** That rules out SCI-A,
SCI-B, SCI-C, USB and the bit-banged buses (Not found in the operand scan).

### 2. Frame format (Confirmed on both ends; `frame.tsv`)

The SUB builder is `sub_FFEDD528(type, b1, ptr, n)`, with its buffer at `0x1C33A`. It sends on SCI
channel 0 (`0xFFEDD6F3 66 01 05 38 d8 ff`). MAIN's checks in `sub_4811E` mirror it byte for byte.

```text
+0  type        E0..FF                 SUB 0xFFEDD539 c9 0e 0f f6 95 / MAIN 0x04812C aa e6
+1  sub         00                     MAIN 0x048174 aa 00
+2  L (BE)      n+9                    SUB 0xFFEDD549 b8 89 62 91 / MAIN 0x04816E aa 00, 0x048168 aa 0a
+4  hdr sum BE  sum(+0..+3)            MAIN 0x048148 .. 0x04815C
+6  01 02 00                           SUB 0xFFEDD5AE / 5B9 / 5C4
+9  echo word   SUB RAM 1B20C/1B20D    (doc 84: echoed MAIN->SUB opcode)
+11 payload     n bytes                FF980B = first payload byte
+L+2 frame sum BE  sum(+0..+L+1)       MAIN 0x0481C0 .. 0x0481DC
+L+4 00 x6 pad                         ignored: state 1 skips zero bytes (0x04761E 0c ac 47 d8)
```

**E6 on the wire:** `E6 00 00 0A 00 F0 01 02 00 xx xx P s s 00 00 00 00 00 00`.

- **P** = `FF980B`. Bit 0 is PTT: 1 = key, 0 = unkey. Bits 1–7 are ignored (`and.b #1` at
  `0x00FD34`).
- The header-sum high byte is `00` (`E6+0A = F0`, checked by `aa 00` at `0x048162`).
- E4 is the only type whose header-sum high byte is `01` (`0x048072 aa 01`; `E4+26 = 0x10A`).

**Correction to doc 84's receive table.** E4 goes to `sub_4802E` and E6 goes to `sub_4811E`; doc 84
swaps them. The re-sync compares `0x04803C aa e4` and `0x04812C aa e6` prove it. K11's
"`sub_4811E`, `0x0481E8`" is correct, and is the E6 handler.

### 3. MAIN consumer: frame → TX (Confirmed)

1. **E6 handler.** After both sums pass, `0x0481DE 6a 18 ba 92 70 30` sets `FFBA92.b3`, and
   `0x0481E4 6a 0c 98 0b` / `6a 8c bb 91` copy `FF980B` to `FFBB91`. `FFBB91` has exactly one writer
   and one reader.
2. **Key scan `sub_FA30`.**
   - `0x00FAF6 6a 0c 80 04 ac 02 44 e8`: with `FF8004 ≥ 2` (clone/remote), every key state is cleared
     and the routine returns. The accessory PTT is dead in that mode.
   - `0x00FAFE`: with Bluetooth ON (`6a 10 89 20 73 00 46 0c`), the VOX hold that would freeze the PTT
     state machine is skipped.
   - `0x00FB18 5e 00 fc 66 … 58 a0 00 a4`: the hardware PTT state machine runs first. If it produced
     an event, the accessory check is skipped for that pass.
   - `0x00FB2C 6a 10 89 20 73 00 47 0c 5e 00 fd 22`: only when `FF8920.b0` is set is `sub_FD22`
     called.
3. **`sub_FD22`** (`0x00FD22`–`0x00FD5D`, whole routine re-read):

   ```c
   if (!(BA92 & 0x08)) return;  BA92 &= ~0x08;        /* new E6 frame          */
   raw = ((BB91 & 1) ^ 1) + 0x17;                     /* b0=1 -> 0x17, 0 -> 0x18 */
   if (raw == 0x17) { AAD2 |= 1; A9ED = 0x17; }        /* press; BT owns this TX */
   else A9ED = (AAD2 & 1) ? 0x18 : 0xFF;               /* release only if BT keyed */
   ```

   - A hardware-PTT press clears `AAD2.b0` (`0x00FCC2`, `0x00FD06`). After that, a headset "unkey"
     cannot release a TX that the hardware PTT started.
   - `AAD2.b0` is not cleared on a Bluetooth release (Not found outside those two sites).
4. **Translator.** `0x00FBD4 fb 09 18 bc` computes event = raw − 9: 14 = TX request, 15 = release.
   K11 (doc 93) takes it from there:
   - event 14 goes to `sub_2244C`, with the PTT LOCK check, then `FF94C0 = 1`;
   - event 15 goes to `sub_22718`.

   The accessory therefore inherits PTT LOCK, the TX-range check (doc 97) and TOT `FF95EA` (doc 93).

### 4. SUB source: the Bluetooth headset button (Confirmed bytes; labels Inferred)

**Link.** The Bluetooth module talks ASCII lines on SUB channel 2. The `printf` wrapper loads
`mov.l #2,r1` (`0xFFF3B652 66 21`). Channel 2 is SCI3 `0x8A060` per doc 14.

**Classifier B, index 5** (`0xFFF3A27E 61 51 20 7f`) routes `RXAT=` lines to `sub_FFF3A95B`. It does
so only while `[10578] == 1` (`0xFFF3A2FF … 61 1e 21 36`). `[10578]` is set to 1 when the module
answers `TXAT=1` (`0xFFF3AEB4 fb e2 78 05 01 00 f8 e4 01`). SUB sends `TXAT=1` from `sub_FFF39BAF`:
the argument is `0xFFF39BB3 3c 05 01`, the format string is `TXAT=%d\r\n` at `0xFFF4AEDA`, and the
callback is stored at `683C4` (`0xFFF39BF6`). That call comes from `sub_FFF384E2`, with callback
`sub_FFF39216` (`0xFFF384E9`), reached from the MAIN→SUB `F3D2` handler (`0xFFEDCFE2 75 51 d2`,
`0xFFF37DF7`).

**`sub_FFF3A95B`.** It echoes the line, then compares the line bytes:

| Offset | Address | Char |
| --- | --- | --- |
| `[5]` | `0xFFF3A9D3` | `C` |
| `[6]` | `0xFFF3A9DC` | `K` |
| `[7]` | `0xFFF3A9F1` | `P` |
| `[8]` | `0xFFF3AA06` | `D` |
| `[9]` | `0xFFF3AA1B` | `=` |
| `[10]` | `0xFFF3AA30` | `2` |
| `[11]` | `0xFFF3AA45` | `0` |
| `[12]` | `0xFFF3AA5A` | `0` |

Each compare is `75 51 xx`. On a full match it calls `[683C4](6)`
(`0xFFF3AA6B … 66 61 7f 1e`). The full line is therefore `RXAT=CKPD=200`.

**`sub_FFF39216(code)`** acts only on code 6 (`0xFFF39225 61 61`). It is a toggle on word `12CBC`:

- **`12CBC ≠ 2` (receiving).** Payload is 1 (`0xFFF39261 66 15 fe 0f e5`), `12CBC = 2`, and
  `E6` is sent. There are two sites: `0xFFF39281 75 41 e6 05 a4 42 fa` (taken when
  `[1229D] == 0x20`) and `0xFFF3930F` (taken when `12CB8 == 2`). If neither holds, no frame is sent.
  It then asks for audio with `SCOL=1` (`0xFFF392AF`), callback `sub_FFF38EFB`.
- **`12CBC == 2` (transmitting).** Payload is 0 (`0xFFF39395 66 0f`), `12CBC = 3`, and `E6` is sent
  at `0xFFF393B3` or `0xFFF393F1`, under the same two conditions.
- **`[1229D]`** is `frame[0x18] & 0x20` from MAIN's `F3D2` frame (`0xFFF3851D b6 11 75 21 20 …`).
  MAIN builds that byte at `FF3D8C`: `FF3D74` is the opcode word (`0x009774`), and `+0x18` puts the
  byte at `FF3D8C` (offset match, Inferred).
  - bit 7 = `FF8920.b0` (`0x007DC8`);
  - bit 5 = BT on ∧ VOX `FF89BB == 0` ∧ `FF8920.b7` (`0x007E38`/`0x007E4C`);
  - bit 6 = `!BB8F.b7`.

**Other E6 senders, all in the Bluetooth cluster `0xFFF37D88`–`0xFFF393F4`:**

- `0xFFF38FCF`: payload 1, when the SCO audio link opens and `[122A0] == 3`.
- `0xFFF3906C`: payload 0, when SCO is closed by the radio and `[122A0] == 3`.
- `0xFFF37FAD` and `0xFFF38212`: payload 0, on MAIN commands `F3D2` and `F3D6`.

**Accessory class.**

- **Confirmed bytes:** the key event is the module line `RXAT=CKPD=200`.
- **Inferred (high):** `AT+CKPD=200` is the Bluetooth Headset Profile button press. `SCOL`/`SCOI` are
  the SCO voice link (doc 14). So the device is a Bluetooth headset with a single button, used as
  push-to-toggle.
- **Not found:** a wired speaker-mic or data accessory feeding `E6`. All 8 `E6` sites are in the
  Bluetooth cluster, and `FF9800` is fed only by SCI_6.
- No model name such as SSM-BT10 or BH-2A appears in either image (Not searched exhaustively; Unknown).

**Correction to doc 14 / `bt_commands.tsv`** (Inferred). `TXAT`/`RXAT` are not attenuation levels.
`RXAT=` carries an AT command received from the headset. Sending `TXAT=1` and getting the reply
enables that pass-through (`[10578]`). `ERAT=` goes to the same callback with code 5
(`0xFFF3A8B4 66 51`).

### 5. Can it key TX, and under which settings

**Yes.** Required (all Confirmed as code conditions; labels Inferred):

- `FF8920.b0 = 1` (EEPROM `0x580` b0; "Bluetooth" ON).
- `FF8004 < 2`.
- Hardware PTT idle on that pass.
- SUB has received `TXAT=1`.
- `[1229D] == 0x20` (`FF8920.b7` set, VOX off) or `12CB8 == 2`.
- The headset sends `CKPD=200`.

After that, the usual TX gates apply: PTT LOCK, TX range, TOT.

**Behaviour.** One press keys and the next press unkeys. MAIN releases only a TX that the headset
started (`AAD2.b0`).

**Caveat (Confirmed code, effect Inferred).** When the headset drops SCO itself (callback code 5,
`sub_FFF38EFB` `0xFFF390A2`–`0xFFF3916D`) while keyed, SUB re-requests `SCOL=1` but sends no
`E6 00`. A keyed radio would then stay keyed until another press or TOT.

**Open interaction.** TX states 4/5 (`sub_34D5C`/`sub_34D66` → `sub_34D70`, `0x034D70 6a 10 aa d2 73
10 … 6a 0c a9 ea ac 02 46 2a`) end TX when `A9EA ≠ 2` unless `AC0A ≠ 0`. A headset-keyed TX never
sets `A9EA = 2`. Whether it reaches those states is not established.

### 6. Proven/named bytes

**+0 credited.** Every MAIN routine in the chain is already proven or named in `final4_*_mask`. The
checked ranges are:

- `0x00FAF6`–`0x00FB3F`;
- `0x00FD22`–`0x00FD5D`;
- `0x044A70`–`0x044AC7`;
- `0x04761E`–`0x047791`;
- `0x047BF6`–`0x047CDF`;
- `0x04802E`–`0x0481FD`;
- `0x019CFE`–`0x019D21`.

The state table `0x0475C8`–`0x0475F7` is named data.

**Candidate, not credited.** `0x007E2C`–`0x007E31`, `00 28 14 2d 18 00` (6 B), is a lookup read by
`0x007E0A 78 50 6a 2b 00 00 7e 2c` with index `r5l` = `FF89BB` (+2 when Bluetooth is ON). Today it is
neither proven nor named. The index bound depends on the VOX value range, which was not verified.

**Name proposals:**

| Address | Proposed name |
| --- | --- |
| `sub_FD22` | `bt_ptt_poll` |
| `sub_4811E` | `sci6_rx_E6_bt_ptt` |
| `FFBB91` | `bt_ptt_byte` |
| `FFAAD2.b0` | `bt_owns_tx` |
| `sub_FFEDD528` | `sub2main_send_frame` |
| `sub_FFF39216` | `bt_ckpd_toggle_cb` |
| `sub_FFF3A95B` | `bt_rxat_handler` |

## USB relevance

None. The accessory PTT rides SCI_6 (MAIN↔SUB) and, on SUB, the Bluetooth module UART. No USB
register, endpoint or CDC path touches `FF9800`, `FFBB91` or `sub_FD22` (Not found, operand scan
above).

- **Q2 (SDR):** unchanged. This path carries one control bit.
- **Q3 (DSP):** unchanged. No DSP frame is involved before the normal TX state machine.

**Owner-relevant addition to the list of TX sources:** a paired Bluetooth headset's button keys the
radio as a toggle when Bluetooth is ON.

## Open

1. **TX states 4/5 vs a headset-keyed TX.** Find what enters `sub_34D5C`/`sub_34D66`, and whether
   `AC0A` is non-zero for this path.
2. **SUB word `12CB8`.** It is set to 2 at `0xFFF38627`/`0xFFF3865A` on BT on/off transitions and to
   1 at `0xFFF38F7B`. This is the second gate on `E6`.
3. **Settle the labels of `FF8920.b7` and `BB8F.b7`.** One is the item at table `0x0122AC` →
   `0x019D10`. Doc 58 says "Bluetooth Save"; SUB's 1000-tick idle close at `0xFFF3959C` fits a power
   save.
4. **Payload meanings for E4, E5, EA and FE.** For E4 (`FFBB71`, 29 B) and E5 (`FFBB92`; no reader
   found), decode the payloads. For EA and FE, also trace the SUB senders.
5. **Headset SCO drop while keyed.** Confirm on hardware whether the radio stays keyed until TOT.
   This needs the owner's radio; it is not a static-analysis task.

Tables: `ida\out\accessory-ptt\writers.tsv`, `frame.tsv` and `verify.tsv` (137/137; 185/185 after the addendum), `e6-sites.tsv`, plus the work
listings in `ida\out\accessory-ptt\work\`. Job: `ida\jobs\l10_dump.py`.

## Addendum — reconciliation with L12's census of the 8 SUB E6 sites

**Scope.** Same as above: owner-side static analysis, read-only, own databases with `--reopen`.
Table: `ida\out\accessory-ptt\e6-sites.tsv`. `verify.py` now re-reads **185/185** byte runs, all PASS,
including every citation below.

**Site addresses.** L12 lists the `bsr.a` addresses (`FFF37FB0`, `FFF38215`, `FFF38FD2`, `FFF3906F`,
`FFF39284`, `FFF39312`, `FFF393B6`, `FFF393F4`). The body above cites the `mov.l #E6,r1` three bytes
earlier (`…81`, `…0F`, `…B3`, `…F1`). These are the same eight sites, and the census agrees. The
correction to the body: **E6 is not sent only by the CKPD=200 toggle.** Four sites are the toggle
and four are not.

### Q1. Can audio coming up (SCOL callback code 1, `FFF38FD2`) key the radio without a button press?

**No.** Code 1 sends `E6 01` only when `[122A0] == 3`
(`0xFFF38F1F fb e2 a0 22 01 00 58 ee 61 4e 20 57 61 3e 20 79`).

`[122A0] = 3` is written at exactly three places, all inside the CKPD=200 handler `sub_FFF39216`.
Each comes right after a button press has already been handled and `SCOL=1` was issued because SCO
was down:

- `0xFFF392C3` (`… f8 e4 03`)
- `0xFFF3935D`
- `0xFFF3943C`

Every other writer of `122A0` stores something other than 3:

| Value | Writers |
| --- | --- |
| 2 | `FFF37E53`, `FFF384C0`, `FFF386EF`, `FFF38997`, `FFF39101`, `FFF3915B`, `FFF391A4`, `FFF39367`, `FFF39446`, `FFF39547` |
| 0 | `FFF37D58`, `FFF37EB9`, `FFF39099`, `FFF390A9`, `FFF39173` |
| 4 | `FFF39486` |
| 1 | `FFF3885F` (dead function) |

This covers every link-setup path: F3D2 sub-op 0, `sub_FFF38402`, `sub_FFF3867F`, `sub_FFF388FF`,
the code 2 and code 5 re-opens, and the idle timer. Separately, word `12CBC = 2` is written only at
`0xFFF38FBC` (behind the `122A0 == 3` check) and at the two CKPD sites `0xFFF3926E`/`0xFFF392FC`.

**Normal effect: a harmless duplicate.** In the keying branches, `E6 01` has already gone out at
`FFF39284`/`FFF39312`. When SCO comes up, the second `E6 01` reaches MAIN while it is transmitting.
There, event 14 is `sub_229D2` in three of the TX-time tables (`0x011998`/`0x011AEC`/`0x011B30`
= `00 02 29 d2`) and the no-op `0x03FFA0` in the fourth. `sub_229D2` only calls
`sub_3FF9C`/`sub_3FFA0` (`0x0229D2 … 5e 03 ff 9c 40 04 5e 03 ff a0 54 70`); it never calls
`sub_2244C`.

**One edge case re-keys after an *unkey* press** (path Confirmed; how often it is reachable is
Inferred). The conditions, in order:

1. An unkey press: `12CBC == 2`, `[1229D] ≠ 0x20`, `12CB8 == 2` (`0xFFF393C4 61 2e`).
2. SUB sends `E6 00` at `FFF393F4`.
3. If SCO is down (`[122AB]` not `0x18`/`0x19`, `0xFFF393F8`), SUB issues `SCOL=1` and, because
   `12CB8 == 2`, stores `122A0 = 3` (`0xFFF39430` → `0xFFF3943C`).
4. When SCO comes up, code 1 sends `E6 01` and MAIN keys again.

This needs SCO to be down while the radio is keyed, with no `SCOL=1` re-open already pending.
Example: a headset-side drop whose `SCOL=1` retry failed.

### Q2. Does `FFF3906F` (code 3, payload 0) answer Open #2?

**No.** Code 3 means the radio itself closed SCO. The `SCOI=0` handler picks code 3 only when
`[12CC2] == 1`, which is set solely by the radio's own `SCOL=0` senders (`0xFFF39B62`/`0xFFF39B95`).
Otherwise it uses code 5 (`0xFFF3A7DA … 61 1e … 66 31 7f 1e 0d 66 51 7f 1e`).

So the radio unkeys on SCO loss only when **the radio** closed SCO and `122A0 == 3`. Then
`FFF3906F` sends `E6 00`, `12CBC = 3` (`0xFFF39059`) and `122A0 = 0` (`0xFFF39099`).

A **headset-side** drop is code 5 (`0xFFF390A4 61 51 3b c7 00`). That block sends no E6; it only
clears `122A0` (`0xFFF390A9`) and retries `SCOL=1`. **Open #2 stands**, now Confirmed in code: after
a headset-side SCO loss, the radio stays keyed until the next button press or TOT.

### Q3. Can the F3D2/F3D6 closes (payload 0) release a TX the headset did not start?

**Not one started by the hardware PTT. Possibly one started by another source** (Inferred, a narrow
case).

**SUB side.** SUB sends these `E6 00` frames only when `12CBC == 2`:

- `0xFFF37F78 … 5c ee 61 2e 21 32` (F3D2, sub-op 2 branch selected at `0xFFF37DB5`);
- `0xFFF381DD` (F3D6).

`12CBC == 2` is set only on headset paths (Q1).

**MAIN side.** The ownership flag `AAD2.b0` is sticky:

- set at `0x00FD52`;
- cleared only by a hardware-PTT press (`0x00FCC2`, `0x00FD06`);
- `sub_3266E`'s `and.b #0x9D` (`0x03266E 6a 0c aa d2 ec 9d`) keeps bit 0.

**The narrow case.** Suppose a headset-keyed TX ends some other way than an unkey press, for example
by TOT. Then `AAD2.b0` stays 1 and SUB's `12CBC` stays 2. A later F3D2/F3D6 close, or the next CKPD
press (which takes the unkey branch), sends `E6 00`. MAIN turns that into raw `0x18` → event 15.
While some other source is transmitting (APRS beacon, WIRES-X `S`, remote `']'`), event 15 dispatches
to `sub_22718` in all four TX-time tables (`0x01199C` etc. = `00 02 27 18`) and would end that TX.
When the radio is idle, event 15 is a no-op.

**SUB also forgets "keyed" silently.** These sites store `12CBC = 3` without sending E6:

- `0xFFF37EF0` (F3D2 sub-op 1);
- `0xFFF38CDB`/`0xFFF38EB6` (`sub_FFF38BDA`).

After one of them, the next press sends `E6 01`, which MAIN ignores while transmitting (`sub_229D2`).
A second press is then needed to unkey.

### Updated Open items from this addendum

1. How SCO can be down while keyed with no re-open pending. This decides whether the edge re-key and
   the stay-keyed-until-TOT case happen in practice. Hardware observation would settle it.
2. What MAIN commands F3D2 sub-op 1/2 and F3D6 are, on the MAIN sender side. This decides when the
   F3D2/F3D6 closes fire.

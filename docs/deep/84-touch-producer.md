# 84 — Touch-event producer: resistive panel on the SUB's S12AD1, the E0 report frame, and the MAIN zone ladder (Lane K2)

> Lane K2, model `claude-opus-5-5`. Private DBs: `K2_TOUCH` (`--copy-from
> ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64`) and `K2_TOUCH_SUB` (`--copy-from
> ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64`), iterated with `--reopen`. The second DB is a
> deviation from the single DB name I was given. I added it because the producer turned out to
> live on the SUB. It is lane-private and was used read-only. Job scripts: `ida\jobs\k2_dump.py`
> (dumper) and `ida\jobs\k2_refscan.py` (operand scanner). Both are read-only apart from IDA's
> own state. No image byte was changed (sha256 `8e3ecd05…` / `b93570b3…` re-checked). No shared
> DB was opened. Nothing was connected to a radio. The closed window `0x078106`–`0x07B753` was
> not entered. Tables are in `ida\out\touch-producer\`.

## Verdict

**The touch panel is a 4-wire resistive panel read by the SUB (RX64M), not by MAIN.**

- **Sampling.** The SUB samples it on **S12AD1 channels AN118/AN119**, driven through port bits
  **P54/P55/P56/P83**, one software-triggered conversion per **TPU0 tick**. It debounces 4 samples,
  calibrates with ROM constants, and scales to 320×240.
- **Reporting.** It sends exactly **two reports per touch**, press and release. Each is an 18-byte
  SUB→MAIN frame with start byte **`0xE0`** carrying `pen, X, Y` and an **echo of the last MAIN→SUB
  opcode** the SUB processed. No drag stream exists.
- **Receipt on MAIN.** MAIN receives the frame on SCI-D and copies it to `0xFFBBC8`.
- **The `0xF3xx`–`0xFDxx` codes are not raw touch events.** The ladder in `sub_262E4` is keyed on
  that echoed screen opcode. It has 94 arms, `0xF003`…`0xFD00`, and starts at `0x0263A2`, not
  `0x026500`. Each arm picks one or more of **99 zone tables**, and the hit-test `sub_26F08` turns
  `(X,Y)` into one of two things:
  - a button index `0xFFBBC2` with event code `0x0A`, which is key-table slot 10;
  - a directly injected key code `0x00`–`0x10`, optionally long-press capable.
- **Gestures.** The only gestures are **tap** and **long-press**. One slider reads the X
  coordinate (screen `0x0B`, `sub_29354`). One SUB-local seek bar reads the last coordinate.

**Hidden/service screens: Not found.** No ladder opcode belongs to a hidden or orphan screen, and
no zone, coordinate or gesture opens one. The scope was:
- the complete ladder and all 99 tables;
- every MAIN reader of `0xFFBBC8`–`0xFFBBD7`/`0xFFBBDA`;
- every SUB reader of the coordinate cells.

The only contact with the known hidden mechanisms is that tapping a setup group on screen `0x0C`
sets `0xFF8F2E` (via `sub_298C8`). That is one precondition of the LOCK-key arm in doc 49-key-seq.

**No touch path touches USB, the DSP bus, or a sample path.** Net proven/named byte delta: **0**.

## Method

- **MAIN (`K2_TOUCH`).**
  - Dumped `sub_262E4`, `sub_26F08`/`26F48`/`26F9C`, `sub_28F52`/`28FB8`/`266E8`/`26926`/`26FD8`,
    `sub_FAF6` and its sources, the SCI-D ISR `sub_44A70`, the ring drain `sub_4753E`, the state
    table `0x0475C8`, `sub_4761E`/`47792`/`478AA`, `sub_29306`/`29354`/`298C8`, and the
    hidden-code digit handlers `sub_163CC`/`sub_19100`.
  - Ran an operand scan (`k2_refscan.py`, every code head `0`–`0x80000`, abs16 sign-extension
    masked to 24 bits). It covered the touch cells, all of `0xFFBB80`–`0xFFBBFF`, the
    hidden-buffer cells `0xFFAD8E`–`91`, `FFA9F0`, `FFB0C8` and `FF8F2E`.
  - Parsed the ladder and every zone table offline from `decrypted\FT3D_MAIN_ver102_EXP.bin` by
    breadth-first search over the ladder targets `0x0266E0`–`0x026F08`, including the nested
    `sub_26FD8`, `sub_26F02` and `sub_28F52`.
  - Joined the result with H5's `ida\out\ipc-reach\opcode-matrix.tsv`.
- **SUB (`K2_TOUCH_SUB`).**
  - Dumped the SUB→MAIN transmitter `sub_FFEDD182` and its five callers, the touch driver range
    `FFEE1105`–`FFEE177F`, the tick ISR `vec_intb_135` and `sub_FFF36CAB`, the reset init
    `sub_FFF36C53`, the echo writers in `sub_FFEDC976`/`FFEDC1F6`, and the SUB-local consumers
    `sub_FFF37BBC`/`375FB`/`377D3`.
  - Ran the operand scan over `0xFFC00000`–`0xFFFFFFFF` for S12AD1 (`0x89100`), the ports, and
    the touch RAM.
- **Whole-image string scan** of both images for `touch`/`calib`/`panel`/`adjust`
  (case-insensitive): 0 hits.
- **Byte ledger.** All 5,296 zone-table bytes are already set in J1's `final3_named_mask.bin`
  (5,296/5,296) and are 0 in `final3_proven_mask.bin` (data). **Delta 0.**
- **Not done.**
  - I did not trace who decrements `0xFF954B` (no abs16 operand; probably a pointer-walked timer
    array).
  - I did not decode the meaning of mode gates `FF94C0`/`FF94C1` or of `AAE0=0x1D`.
  - I did not enumerate callers of the keypad-screen senders (see Open 1).
  - I did not decode the slider's value (`sub_24EAE`, table `0x293DE`).
  - I did not name the SUB-local F640 screen beyond "Inferred .wav playback".

## Findings

### 1. SUB: the panel driver (Confirmed bytes; pin/channel names Inferred from the RX64M map)

**Init `sub_FFEE1393`.** Called once from the reset path `sub_FFF36C53` at `FFF36C71`.
- Module stop and pins:
  - `PRCR=A502`, clear `MSTPCRA` bit 16 (`FFEE13A5 7b 0f`) = S12AD1 out of module stop, then
    `PRCR=A500`.
  - `PORT0.PMR` b0/b1 cleared.
  - PWPR unlock, `P00PFS`/`P01PFS` ASEL set (`FFEE13D5 f1 e7 21`, `FFEE13DD f1 e7 22`), relock.
- S12AD1 at `0x89100`:
  - `ADCSR=0`, `ADANSA0=0`, `ADANSA1=0x000C` (`FFEE1403 3d 13 0c` = AN118+AN119).
  - `ADADS0/1=0`, `ADCER` b15 cleared.
- Drive state `P56=1 P83=0 P54=1 P55=0`; debounce `8BF8=4`, `8BF9=0`, `8BFA=0`; ring cleared;
  state `8BF6=1`.

**Clock `vec_intb_135` (`FFEE11B8`, INTB slot 135 = `FFED8C8C`, TPU0 TGI0A).**
- The ISR clears `TSR0.TGFA`, increments tick `0x124D4`, and calls `sub_FFF36CAB`.
- `sub_FFF36CAB` calls, in order, `sub_FFEE131F` (software timers), **`sub_FFEE1480`** (touch),
  `sub_FFEDFA70`, `sub_FFF3B69B`, and `sub_FFEDC5EE` (link RX).
- TPU0 setup `sub_FFEE1105` writes `TCR0=0x01` (`FFEE1132 f8 e4 01`), `TIER0=0x41` and
  `TGRA0=0xEA5F`.
- `TGRA0=0xEA5F` = 60,000 counts at PCLK/4 is a 5.000 ms design value. But `TCR0.CCLR=000`, so
  the counter is never cleared and compare-A recurs every 65,536 counts. **5.461 ms at
  PCLKB = 48 MHz** (Inferred; PCLKB from doc 03/14).

**Step `sub_FFEE1480`, once per tick.**
- `ADCSR |= 0x8000` (ADST), then busy-wait until it clears (`FFEE1489`–`FFEE149D`).
- Then branch on `0x8BF6`:

| state | reads | action | next drive (P56,P83,P54,P55) |
| --- | --- | --- | --- |
| 1 detect | `ADDR18` (`0x89144`) | **≥ `0xAF0`** (`FFEE14C1 76 01 f0 0a`) → pen down. If a pair is valid, push `{X,Y}` into ring `0x124D6[idx&3]`. `8BF8--`; at 0 → **report(pen=1)**, `8BF9=4`. **< `0xAF0`** → if `8BF9`: `8BF9--`; at 0 → `8BF8=4`, **report(pen=0)**, clear ring. | X: (0,1,1,0), state 2 |
| 2 X | `ADDR18` | raw ≤`0x81`→0; ≤`0x3E7`→raw−`0x82`; ≥`0xF00`→`0xFFF`; ≥`0xBB9`→raw+`0x100`; X=raw·`0x140`/`0xFFF` → `0x124E6` | Y: (0,0,0,1), state 3 |
| 3 Y | `ADDR19` (`0x89146`) | raw ≤`0x77`→0; ≤`0x3E7`→raw−`0x78`; ≥`0xEEC`→`0xFFF`; ≥`0xBB9`→raw+`0x114`; Y=raw·`0xF0`/`0xFFF` → `0x124E8`; `8BFA=1` | detect: (1,0,1,0), state 1 |

**Debounce and calibration.**
- Calibration is entirely ROM immediates. No calibration table, EEPROM value or setup item
  exists. The string scan finds no "TOUCH"/"CALIB".
- A press is reported after 4 valid X/Y pairs, about 13 ticks ≈ 71 ms (Inferred).
- A release is reported after 4 not-touched detects. Neither counter is re-armed by the opposite
  condition, so the samples need not be consecutive.

**Report `sub_FFEE16EE(pen)`.** It has exactly two callers: `FFEE153B` (pen=1) and `FFEE159F`
(pen=0).
- It averages the 4 ring entries.
- **X = `0x140` − avgX, Y = `0xF0` − avgY**: both axes are inverted. See `FFEE174E fb 1a 40 01`
  and `FFEE1758 75 41 f0`. The latter is `MOV.L #uimm8`; IDA shows it as `#-10h`.
- It stores `0x124EA`/`0x124EC` and calls `sub_FFEDC3BD(pen, X, Y)`.

```c
/* SUB, reconstructed from FFEE1480/FFEE16EE (one call per TPU0 tick) */
void touch_step(void) {
    S12AD1.ADCSR |= 0x8000; while (S12AD1.ADCSR & 0x8000) ;
    switch (st /*0x8BF6*/) {
    case 1: if (S12AD1.ADDR18 >= 0xAF0) {
                if (pair_ok) { ring[idx++ & 3] = cur; pair_ok = 0;
                               if (press_cnt && --press_cnt == 0) { report(1); rel_cnt = 4; } }
                drive_X(); st = 2;
            } else if (rel_cnt && --rel_cnt == 0) { press_cnt = 4; report(0); clear_ring(); pair_ok = 0; }
            break;
    case 2: cur.x = cal_x(S12AD1.ADDR18) * 320 / 4095; drive_Y(); st = 3; break;
    case 3: cur.y = cal_y(S12AD1.ADDR19) * 240 / 4095; pair_ok = 1; drive_detect(); st = 1; break;
    }
}
void report(u8 pen) { avg4(&ax,&ay); X = 320-ax; Y = 240-ay; send_E0(pen, X, Y); }
```

### 2. The SUB→MAIN frame (Confirmed; closes doc 51 Open 4 and part of doc 09 Open 2)

**Builder.** `sub_FFEDD182(type, b1, n)` builds the frame at `0x12D44+0x85F6`:

| bytes | content |
| --- | --- |
| 0 | `type` |
| 1 | `b1` |
| 2–3 | length `n+9`, big-endian |
| 4–5 | big-endian sum of bytes 0..3 |
| 6–8 | constants **`01 02 00`** (`FFEDD206`/`0211`/`021C`) |
| 9–10 | **echo `[0x84C8]`,`[0x84C9]`** |
| 11.. | `n` payload bytes from `0x84CA` |
| after payload | big-endian sum of all preceding bytes |
| last 6 | `0x00` pad |

The frame goes out through `sub_FFEDAF2D(0, …)` (SCI0).

**The echo.** It is the opcode (frame bytes `+5`,`+6`, proven by the `F00F` compare at
`FFEDC98E`/`FFEDC99B`) of the last MAIN frame the SUB processed. There are two writers:
- `FFEDCECD`/`FFEDCED8` (immediate path);
- `FFEDC292`/`FFEDC2A6` (queued path, skipped for `0xFCxx`).

**Senders.** The five callers use **uimm8** type bytes (`75 41 xx`):

| caller | type | payload |
| --- | --- | --- |
| `sub_FFEDC3BD` | `0xE0` | touch, n=5 |
| `sub_FFEDC2E1` | `0xE1` | up to 299 bytes |
| `sub_FFEDC429` | `0xE3` | 3 zero bytes, acknowledgement |
| `sub_FFEDC493` | `0xE2` | status |
| `sub_FFEDC4DD` | `0xFF` | block read-back |

IDA's RX module prints these as `#-20h`/`#-1Fh`/`#-1Dh`. The MAIN start-byte switch confirms the
unsigned values.

**MAIN receive** (`sub_4761E` start-byte switch, `047622`–`047656`):

| start | state | handler | bytes after start | notes |
| --- | --- | --- | --- | --- |
| `E0` | 2 | `sub_47792` | 0x11 | **touch**: header checks (idx1<2, idx2=0, idx3=`0E`, idx4=0, header sum), frame sum, eepmov 18 B `FF9800`→**`FFBBC8`**, one-shot `01 02 00`→`FF813F` |
| `E1` | 3 | `sub_47B7C` | 0x7F | |
| `E2` | 6 | `sub_4799A` | 0x10 | |
| `E3` | 4 | `sub_478AA` | 0x0F | acknowledgement; copies `FF9806..08`→`FF813F` |
| `E4` | 9 | `sub_4811E` | 0x29 | |
| `E5` | 0x0B | `sub_481FE` | 0x0D | |
| `E6` | 0x0A | `sub_4802E` | 0x0D | |
| `EA` | 8 | `sub_47F4E` | 0x0D | |
| `FE` | 7 | `sub_47E2C` | 0xC7 | |
| `FF` | 5 | `sub_47A7E` | 0x110 (`FFBC4C`) | |

**MAIN layout of the touch frame at `0xFFBBC8`:**

| offset | content |
| --- | --- |
| `C8` | `E0` |
| `C9` | pen |
| `CA..CB` | `000E` |
| `CC..CD` | header sum |
| `CE..D0` | `01 02 00` |
| **`D1..D2`** | **echo opcode** |
| **`D3`** | **pen** |
| **`D4..D5`** | **X** |
| **`D6..D7`** | **Y** |
| `D8..D9` | frame sum |

**Readers.** A scan of every instruction referencing `0xFFBB80`–`0xFFBBFF` found:
- `0xFFBBD4`: read only at `026358`/`02639C`;
- `0xFFBBD3`: read only at `026342`;
- `0xFFBBC8` as an immediate: `047864` only.

The image bytes `00 FF BB C8` also appear at `0x6620`, inside the RAM pointer list
`0x6600`–`0x663F` (data). That list is not code and does not access the frame.

### 3. MAIN consumer `sub_262E4` (Confirmed)

**Call path.** The main loop calls the input poller **`sub_FAF6`** from 5 sites (IDA's
`sub_FA30` head is mis-bounded data). It polls these sources in order: `sub_FC66`, `sub_FD22`,
`sub_FE18` (keypad `sub_100E4`), `sub_FD5E`, `sub_FDC8`, **`sub_262E4`** (`00FBA8`), then
`sub_105BE`. After touch, `00FBB0 4a 34 bpl 0xFBE6` **skips the −9 remap at `0xFBC8`**. A touch
button event `A9ED=0x0A` therefore dispatches **key-table slot 10** directly. The other sources
are remapped (code−9; doc 74/J6).

```c
void touch_consume(void) {                       /* 0x0262E4 */
  if (!FFBBC8w) {                                /* no new frame: long-press timer */
    if (BBC7==1 && !FF954B) { if (A9EE&0x40) { sub_26F48(BBC4); A9EE=(A9EE&~0x40)|0x80; }
                              else { A9EE|=0x80; A9ED=BBC6; BBC7=2; } }
    return; }
  FFBBC8w = 0;
  if (!BBD3) { if (BBC7==1) { if (A9EE&0x40) { sub_26F48(BBC4); A9EE&=~0x40; } } BBC7=0; return; }
  op = BBD1<<8|BBD2;  last = FF3D74;  xy = BBD4;              /* X<<16|Y */
  if (sub_28F52(op, xy)) return;                 /* F100: tap/long arm on band areas */
  if (last!=0xFC00 && last!=0xFE00 && last!=0xFFFF && op!=last) {
      AAE0=0x1D; BBE5=1; FF817E|=2; return; }    /* stale touch: dropped */
  if (FF94C0==1 && sub_28FB8(op)) return;        /* only F100/F101/F103/F107/FD00 pass */
  switch (op) { case 0xF003: hit(0x270CA); … case 0xFD00: hit(0x2843C); default: return; }
}
```

**Hit-test `sub_26F08(er5, er2)`.** The table is a BE16 count followed by 10-byte
`{x0,y0,x1,y1,val}` records. A record matches when `x0≤X≤x1 && y0≤Y≤y1`, and the first match
wins.

| result | effect |
| --- | --- |
| miss | `BBC2=0`, `BBC7=2` |
| hit, `val≥0` | `sub_26F48`: `BBC2=val`, `A9ED=0x0A`, `BBC7=2` |
| hit, `val<0` | `BBC2=0`, `A9ED=BBC6=val&0xFF`. If bit 8 is set (`0xFFxx` vs `0xF0xx`), `FF954B=0x32` and `BBC7=1`: a long-press second event follows with `A9EE.7` |

**Ladder (`event-ladder.tsv`).**
- **94 arms: 93 exact opcodes plus one range.** The range compare is `0xF200≤op<0xF22D`. The
  arms use **99 tables / 511 records** (`zone-tables.tsv`).
- **Value range.**
  - `BBC2` takes the values 1–24 and 30–45.
  - The value 66 occurs only in a never-matching trailing record of the dead `F801` tables. Their
    count is one too high, so the last record overlaps the next table with `x0=0x810F > x1`.
- **Injected key codes** go to `A9ED`:
  - **digits** `0x00`–`0x09` from on-screen numeric keypads (`0x270CA`, `0x27334`, `0x279EA`,
    `0x27648`, `0x2782E`);
  - `0x10` (`F104` keypad, bottom-right);
  - bottom soft-keys `0xFF02` (long-press-capable) and `0xF007` on the main display `F100`–`F115`,
    and `F004`/`F001` on `FD00`.
- **Digit conversion.** Only the keypad handlers convert codes below `0x0A` into a digit
  (`A9F0`, slot 0) and codes `≥0x0A` to code−9. These are:
  - `0x026712` (`F003`/`F3B3`/`F3B8`/`F513`);
  - `0x026794` (`F514`/`F515`/`F623`);
  - `sub_26926` (`F104`/`F105`);
  - `0x026E2C` (`F801`).

  Elsewhere the injected code is used directly as the key-table slot.
- **Dead arms**:
  - `F3B3`, `F801` (no MAIN sender, H5);
  - `F501`, `F503` (dead senders only);
  - `F10C`, `F10E`, `F110`, `F3C2`, `F3C3` (absent from H5's sender census; Inferred).
- **Gestures.**
  - **Tap vs long-press on the main display band areas.** `sub_28F52`, `F100`, tables
    `0x27870`/`0x2785A`, upper/lower half through `sub_26F9C`→`BBC4`.
  - **Long-press second event** on bit-8 zones.
  - **X-slider.** `F10B`/`F112` store `er2`→`0xFFBBDA` (`02698C`/`0269C2`). Screen `0x0B` slot 10
    (`0x0128A4`→`sub_29306`) calls `sub_29354` when `BBC2==5`. It reads X (`02937C`) and steps a
    value N times through `sub_24EAE` (meaning not decoded).
- **No other MAIN code reads a coordinate.**
- **SUB-local consumer.** `sub_FFF37BBC` reads `0x124EA/EC` through `sub_FFEE1467`. It accepts
  `0≤X≤320`, `60≤Y≤174` and clamps to `X 20..300`, `Y 110..124`. `sub_FFF375FB` converts X to a
  fraction `(X−20)/280` of a length at `0x68338+0x20`. This is a seek bar in the F640 screen
  family (`.wav` playback; Inferred).

### 4. Hidden/service screens (Not found; scope stated)

**Hidden and orphan screens.**
- Doc 58 notes that 29 of its 32 orphan screens have an `rts` notifier. None of the three that
  would draw has an arm in the ladder:
  - `0x41` (`F316`);
  - `0x5C` (`F31A`);
  - `0x80` (`F395`; the ladder has `F396`, DIAL KNOB CHANGE).
- SOFTWARE VERSION (`0xC0`, `F31B`) has no arm either. On that screen touch produces no event, so
  touch cannot drive the LOCK-key step handlers (screen `0xC0` slots 1/5/6/8).
- Hidden-but-active screens `0x3E`/`0x49` and service screen `0x32` send no frame (`rts`
  notifiers; doc 58), so they cannot be the echoed opcode.
- **Confirmed** over the complete 94-arm ladder.

**Digit back doors (doc 49-key-seq F4).** The 4-digit buffer `0xFFAD8E` is filled only from
`A9F0` by these handlers:

| handler | key-table slot | screen | notifier sends |
| --- | --- | --- | --- |
| `sub_163CC` | slot 0 at `0x128C0` | `0x0C` | `F300` |
| `0x163EA` | slot 0 at `0x12E10` | orphan `0x32` | nothing |
| `sub_19100` | slot 0 at `0x14680` | `0xEA` | `F000`/`F001` |

A whole-image BE32 pointer scan finds each handler referenced exactly once. Touch produces digit
events only when the echoed opcode is one of the keypad opcodes listed in §3. The opcodes these
screens send are not:
- `F300`'s table `0x27E0C` is twelve plain buttons (setup groups 1–12);
- `F000`/`F001` have no arm.

So **touch cannot type the hidden codes while those screens are being displayed** (Confirmed for
that state). Whether a keypad opcode could be staged while screen `0x0C`/`0xEA` is current is
Unknown (Open 1).

**What touch does do on screen `0x0C`.** A group tap gives `BBC2=n`, slot 10 → `sub_298C8`
(`0x0128E8`): `FF8F2E = n−1`, then it enters the group (`sub_14AF4`). That sets the
group-index precondition of the LOCK-key arm. The arm itself is the physical LOCK handler
`sub_1CF0A`.

## USB relevance

None. The panel driver touches only S12AD1, port 0/5/8 and TPU0 on SUB, and the link is SCI0↔SCI-D.
No instruction in this chain addresses USB `0xFFEE00`–`0x53`, SCI-C `0xFFFF88`, or the closed
window. The touch report is 5 payload bytes on the inter-processor UART, so it is not a sample
path. The answers stand:
- Q1: USB is MAIN's `0xFFEE00`.
- Q2: no SDR.
- Q3: the DSP is on SCI-C.

One by-product for Q1/Q2: the SUB's second ADC unit, S12AD1, is fully committed to the touch panel
(AN118/AN119, software-triggered, one conversion per ~5.5 ms tick). It is not a receiver-sample
source.

## Open

1. **Keypad opcode while screen `0x0C`/`0xEA` is current.** Enumerate the callers of the
   keypad-screen senders (`F003` `0x808E`, `F104` `0x8C6A`, `F105` `0x8C4A`, `F3B8` `0xA2EC`/`A34C`,
   `F513` `0xA934`, `F514` `0xAA22`, `F515` `0xA9C6`/`A9F2`, `F623` `0xACFC`). That would show
   whether any of them can be staged while screen `0x0C`/`0xEA` is current. This is the only route
   by which a touch digit could reach `sub_163CC`/`sub_19100`.
2. **The long-press countdown.** Find the decrementer of `0xFF954B` (pointer-walked timer array)
   to pin the long-press time. Decode `FF94C0`/`FF94C1` and the `AAE0=0x1D` stale-touch request.
3. **Other start bytes.** Decode `E1`/`E2`/`E4`/`E5`/`E6`/`EA`/`FE` (`sub_47B7C`, `4799A`,
   `4811E`, `481FE`, `4802E`, `47F4E`, `47E2C`) to finish the SUB→MAIN opcode set (doc 09 Open 2).
4. **Typing in the next seed.** Type the 99 zone tables as `{u16 n; rec[n]}` in the next MAIN
   seed (bytes already named; 0 proven change), and name `sub_FAF6` as the real poller head.
5. **Drive lines.** Confirm X+/X−/Y+/Y− assignment of P54/P55/P56/P83 from a schematic. It cannot
   be determined from the image.

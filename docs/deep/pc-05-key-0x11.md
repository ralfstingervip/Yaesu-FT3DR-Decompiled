# PC lane 5: which button is key code `0x11`

Residual #1 from `RESUME-DEEP.md`. This is static analysis of the MAIN image
(`decrypted\FT3D_MAIN_ver102_EXP.bin`, H8S, base 0) plus a few SUB strings.
Nothing was written to a radio. Private IDA DB: `ida\db\jobs\PC_L5_MAIN\` (seeded
from `MAIN_FULL`). Scripts: `ida\jobs\pc_l5_dump.py`, `pc_l5_keyreads.py` and
`pc_l5_writes.py` (IDA), plus `pc_l5_tables.py` (plain Python, which reproduces
every table below from the image). Table: `ida\out\pc\L5-keycodes.tsv`.

## Answer

**Key code `0x11` (bit 1 of `0xFFFF4C`) is the operating-band key, the A/B key.**
In normal use a short press swaps the operating band between A and B. A long press
toggles the second band flag, which is most likely dual versus single receive.

- **That this is the key's function: high confidence.** The evidence is below and
  every point has an address.
- **That the key is printed "[A/B]": medium confidence (about 70 %).** That label
  comes from memory of Yaesu's FT3D documentation. No legend exists in this
  package.

The firmware pins down the rest of the key column well enough that only bits 1, 2
and 3 carry any doubt. Bit 1's behaviour is the least ambiguous of the three.

## 1. The scanner: full code table (`sub_100E4`, `0x0100E4`–`0x010166`)

`sub_100E4` does **no strobe/row drive**: it reads `@0xFFFF4C:8` once at
`0x0100F8`, masks `&0x7F`, and matches one-bit-low patterns. So these are 7 direct
active-low key lines, one key per bit, on a single "column". It returns:

- `r1h = 1` with `r1l` = the code for exactly one key
- `r1h = 9` when more than one key is down
- `r1h = 0xFF` when no key is down

It also returns `er2` = the raw masked port value, which `0x01017C` uses to match
key chords.

| port&0x7F | bit low | raw code | event (= raw−9, `0x00FBD4`) | proposed key |
| --- | --- | --- | --- | --- |
| `0x7E` | 0 | `0x0E` | 5 | V/M |
| `0x7D` | 1 | **`0x11`** | **8** | **A/B** |
| `0x7B` | 2 | `0x0A` | 1 | D/X (medium) |
| `0x77` | 3 | `0x0F` | 6 | digital-function key (GM or X, low) |
| `0x6F` | 4 | `0x0D` | 4 | BAND |
| `0x5F` | 5 | `0x0C` | 3 | DISP |
| `0x3F` | 6 | `0x12` | 9 | BACK |
| other | ≥2 | `r1h=9` | — | chord |

### How a key becomes an action

1. The key state machine at `0x00FE18` (state table `0x00FE38`) calls `sub_100E4`
   at `0x00FE1E`, debounces, and latches the code in `0xFFA9F1`, then in `0xFFA9ED`.
   Hold state is bit 7 of `0xFFA9EE`: it is set at `0x00FF8A`, `0x00FFF8` and
   `0x01005A`, and every handler tests it as "long press". Codes `0x0D` and `0x0F`
   auto-repeat (`0x00FFEC`, `sub_FC2E`).
2. `sub_FA30` at `0x00FBC8`–`0x00FBD8` translates the code. A raw code ≥ `0x0A`
   becomes **event = raw − 9**. A code < `0x0A` becomes event 0, with the digit
   kept in `0xFFA9F0`.
3. `sub_1079E` dispatches the event through **17-entry, 0x44-byte per-screen
   tables**. The main frequency screen uses `0x0115EC + mode*0x44`, selected in
   `sub_10CC4` at `0x010E4E`. Other screens use `0x0125D4 + word_1208C[screen−1]`
   (`sub_10EB8`). The call itself is at `0x01096A`–`0x010982`. `sub_3FFA0` is the
   "invalid key" stub.
4. The same event byte is also written directly by two other sources, so touch and
   remote actions reuse the key handlers:
   - Touch-panel hit tables (`sub_262E4`, `sub_26F08` at `0x026F74`).
   - The SUB-to-MAIN command module, table `0x074472`.

## 2. Anchors that fix the known keys

- **DISP = bit 5 (`0x0C`).**
  - Holding `0x11` at power-on runs `sub_103C0`, which gives `r3l=0xEE` →
    `sub_3FF10`. That opens screen `0xEE`.
  - Screen `0xEE`'s key table (`0x014790`) has exactly one live column, event 3
    → `0x05DCD8`. That handler sets DSP power `0xFFFF52.0` and starts the loader
    with `0xFFB0C4 = 1`.
  - SUB draws that screen with `---DSP WRITE MODE----` (`0xFFF4ACF8`) and
    `Push DISP Key!` (`0xFFF4AD0E`). So event 3, raw `0x0C`, is DISP.
- **BAND and BACK = bits 4 and 6.**
  - The manual's recovery combo is `[BACK]+[DISP]+[BAND]`
    (`ida\out\host-usb\manual-ver-up-2206B.txt`, line 141).
  - The firmware's power-on chord table (below) has port `0x0F`, bits {4,5,6}
    → screen `0xEC`. Its confirm column goes to `0x00DBD8` (full re-init) and
    every other column goes to `0x00DC40` (restart). That is the "ALL RESET?"
    screen.
  - Event 9 (bit 6) is `sub_3FFA0` in every main-screen mode (`0x0115EC` column 9)
    and is exempt from key lock (`0x010BA6`). That fits BACK, which does nothing
    on the frequency screen.
  - Event 4 (bit 4) has mode-dependent handlers and a long-press handler
    (`0x01C6DA`), which fits BAND.
- **V/M = bit 0 (`0x0E`).** The SUB-to-MAIN "set mode" command `0x073CFC` writes
  event 5 into `0xFFA9ED`. It then calls the mode-1 table's column-5 handler
  `sub_1C7B2`, or the mode-2 handler `sub_1D3A4`, to move between modes 1 and 2.
  That is the V/M action, reused by a remote command.

## 3. What key `0x11` (event 8) does in normal operation

Main-screen column 8 is `0x020FF2` in all four modes (`0x0115EC`/`30`/`74`/`B8`).
The work happens in `sub_20FF2`, on two flags in `0xFF8EA0`.

- **Bit 6 = "operating band is B".** The communication-mode routines pick band B's
  mode byte `0xFF8DD5` instead of band A's `0xFF8D20` when bit 6 is set. See
  `0x01C85E` (in `sub_1C9C2`), `0x02244C`, `0x022A3E` and `0x06F5D0`. Band
  validity checks are `sub_2D5A6` (band A, `0xFF8EE1`) and `sub_2E198` (band B,
  `0xFF8FE9`).
- **Short press** (`0xFFA9EE.7` clear) toggles bit 6:
  - bit 7 set: `sub_210C8` clears it, `sub_21256` sets it;
  - bit 7 clear: `sub_21056` clears it, `sub_211B2` sets it.

  The handler then raises the redraw flags of both VFO blocks (`0xFF8F6C`,
  `0xFF9074`, `0xFF917C`) and updates DSP need (`sub_5DC9C`/`sub_5DCBC` set
  `0xFFB0AA.7` if the band now in use is digital). **This is an A↔B band swap.**
- **Long press** runs `sub_21072` or `sub_211EE`, which toggle bit 7
  (`bnot #7,@0xFF8EA0` at `0x021086` and `0x021212`). Bit 7 changes whether one
  band or both bands count for DSP need (`0x05DC9C`–`0x05DCD6`). That is most
  consistent with **dual versus single receive** (medium confidence on this
  meaning).
- **Touch path:** touching the band that is not in use calls the same routine
  (`sub_28E1A` → `jsr sub_20FF2` at `0x028E2E`).
- **Remote path:** the command module has separate "set bit 7 := arg" and "set
  bit 6 := arg" entries (`0x07410C` → `sub_2113C`, `0x074134` → `sub_21176`).
  So the bit-6/bit-7 pair is a user-visible, remotely settable band state, not an
  internal service flag.
- **Power-on hold** (idx 8 of the chord table): two things happen.
  - The boot gate at `0x002200` sets `0xFF813A = 1`, which selects the CDC-ACM
    USB personality.
  - `0x0101B2` calls `sub_103C0`, which clears `0xFF8DDE`, sets `0xFFB0C4 = 0` and
    opens screen `0xEE` "DSP WRITE MODE".

## 4. Power-on chord table (`0x010216` values / `0x010242` handlers, matched at `0x01018E`–`0x0101E2`)

| idx | port | keys held (by bit) | handler | effect |
| --- | --- | --- | --- | --- |
| 0 | `0x0F` | BAND+DISP+BACK | `0x0103D8` | screen `0xEC` ALL RESET? (manual combo) |
| 1 | `0x1F` | DISP+BACK | `0x0103E6` | screen `0xED`; confirm = `0x0103F2` clears `0xFF8970..0xFF8A1C` (settings reset) |
| 2 | `0x5F` | DISP | `0x010506` | `sub_734C2`, screen `0xEB` |
| 3 | `0x7B` | bit2 | `0x0102A6` | screen `0xDC` (only if single-band A, analog, mode 1) |
| 4 | `0x77` | bit3 | `0x073540` | SCI-A `0xFFFE90` set to BRR `0x19` (19200 bps), `0xFF8004=1`: clone mode |
| 5 | `0x6F` | BAND | `0x010528` | screen `0xEA` |
| 6 | `0x7E` | V/M | `0x010444` | per-band VFO field reset |
| 7 | `0x73` | bit2+bit3 | `0x01026E` | screen `0xE8` |
| 8 | `0x7D` | **A/B (`0x11`)** | `0x0103C0` | **DSP WRITE MODE, screen `0xEE`** (+ CDC-ACM from boot `0x002200`) |
| 9 | `0x37` | bit3+BACK | `0x010556` | `0xFF8DDE = 1`: PC/clone serial personality (38400, doc 14) |
| 10 | `0x67` | bit3+BAND | `0x01054A` | `0xFF8DDE = 0xFF`: WIRES-X PDN node mode |

A correction to `12-hidden-features.md` §8.2: that section says only index 6 has a
distinct handler. In fact every index dispatches through the handler table at
`0x010242`.

Separately, `sub_2AA0` (`0x002AC4`) checks for DISP held alone (`dword_1021E =
0x5F`). If it is, the routine collects 18 key events and compares them with the
hard-coded sequence at `0x0037B6`: events `8 5 6 1 5 8 8 5 3 8 5 6 1 5 8 1 8 5`
(A/B, V/M, bit3, D/X, DISP…) (`sub_3756`). This is noted here, not analysed.

## 5. Keys not on the `0xFFFF4C` column (for completeness; see TSV)

| raw code | event | source | notes |
| --- | --- | --- | --- |
| `0x0B` | 2 | touch | sets `0xFF94C1=1`, the function-menu key layer (`sub_1F26A`) |
| `0x10` | 7 | touch | mode-icon step, or OK on reset screens |
| `0x13` | 10 | touch | item select (`0x026F4C`) |
| `0x14` | 11 | USB-area flag `0xFFB096` | set at `0x0554EC`, turned into an event at `0x00FDFE` |
| `0x16` | 13 | internal flags | `0x00FBC6` |
| `0x17` / `0x18` | 14 / 15 | SUB-reported | press/release, no beep (`0x010BE8`) |
| `0x19` | 16 | port `0xFFFF4E` bit 4 | state machine `0x00FD5E`, likely a side key |

So PTT, MONI and POWER are not on `0xFFFF4C`. The seven lines of that port are the
front-panel keys.

## 6. Confidence and what would settle the legend

- **Function of `0x11`: high.** Several independent paths agree: the key handler,
  the touch path and the remote-command setters.
- **Printed legend "[A/B]": medium.** The firmware proves that the button swaps A
  and B. It cannot prove what is printed on it.
- **Bits 2 and 3 are the weak points.** Both call the communication-mode routine
  `sub_1CDBA`. Bit 3 is also the clone / PDN / PC power-on key. Which of them
  is printed D/X, GM or X is not settled.

**Settling evidence, with no risk and no power-on hold:**

1. **Easiest test.** With the radio in normal operation (dual receive on),
   short-press each front key once. The key that moves the operating-band marker
   between A and B is `0x11`. Its long press should switch between one band and
   two.
2. The FT3DR Operating Manual pages "Controls and switches" and "Switching the
   operating band" would name it directly.
3. A keypad schematic would place the line on `P?`/`0xFFFF4C.1`.

**Do not** hold that key while powering on as a test. That enters DSP WRITE MODE
(screen `0xEE`), where a DISP press starts the DSP loader (`0x05DCD8`).

# 17 — PC software for the FT3DR: what the files support, and what is still unknown

Orchestrator synthesis of the PC-software pass, 2026-09-27. Seven lanes ran in parallel;
their notes are `docs\deep\pc-01` … `pc-07`, one table each under `ida\out\pc\`. Lane 3 was
cut off by a safety filter mid-run and respawned once; its replacement delivered. Nothing
was written to a radio. `Firmware\`, `decrypted\` and `ida\db\radio\` are unchanged; all
IDA work used new private databases `ida\db\jobs\PC_L*`.

Tags used below: **[B]** byte-confirmed in the MAIN/SUB image (address given in the lane
note), **[O]** checked by the orchestrator in the image during synthesis, **[I]** inferred.

## 0. Headline

A PC program for this radio has **four real surfaces**, and none of them is a general
"CAT" control port:

| # | Surface | Transport | What a PC can do | Maturity |
| --- | --- | --- | --- | --- |
| A | **microSD `BACKUP.dat` / `MEMORY.dat`** | card reader | read, edit, write full settings and memory channels | **implementable now** (layout + checksum byte-confirmed; some channel bit-fields unknown) |
| B | **DATA-jack raw clone** | serial, 19200 8N1, radio in clone mode | receive/send the same EEPROM image as `BACKUP.dat` | framing mostly known; needs one more targeted pass |
| C | **DATA-jack WIRES-X node link** | serial, 38400 8N1, radio in node mode | identify, retune, status, GPS text, relay on-air data, **key TX** | frame + commands byte-confirmed; five `M` fields unknown |
| D | **USB `26AA:0001` (camera personality)** | USB, WinUSB/libusb | read camera size/quality, **push a JPEG** into the radio | request set byte-confirmed; host acceptance inferred |
| + | **microSD `PHOTO\` + `QSOLOG\` picture files** | card reader | read pictures and the picture log; write is feasible but riskier | layouts byte-confirmed; FAT flag bits unknown |

What a PC program **cannot** do from any surface in normal operation: arbitrary memory
read/write, flash write, firmware update, band-coverage change outside a full clone image,
SDR/IQ streaming. (Settled negatives in `RESUME-DEEP.md` stand; nothing this pass
contradicts them.)

## 1. Corrections this pass makes to earlier docs

| Earlier claim | Correction | Source |
| --- | --- | --- |
| doc 04 §10 / 05 / 09 / 11: the SOH-framed DATA-jack protocol is the "clone/CAT" API | It is the **WIRES-X node-radio link**, armed only when `0xFF8DDE` ≠ 0 (power-on codes `0x37`/`0x67`). The real **clone** is a separate raw block protocol (§3). | pc-01 [B]; §3 here [O] |
| doc 04 §11: MAIN is H8S/2456 group; `compiler.md`: H8S/2370 | MAIN is **H8SX/1668R group — R5F61668R (or its twin R5F61668M)**, 1 MB flash, 56 KB RAM at `0xFEE000`, 16 MHz clock (SCKCR `0x0111`). Doc-04's "SCI-A" is on-chip **SCI_4**, "SCI-D" `0xFFF610` is **SCI_6** (500 kbaud to SUB). IDA's `h8s300a` disassembly stays valid (H8SX runs H8S code). | pc-07 [B] |
| doc 05 / RESUME residual 5: camera on SCI-B `0xFFFF60`, parser `sub_48C44` | **Refuted.** SCI-B is the APRS packet-modem input; `sub_48C44` is a software HDLC/AX.25 deframer (CRC residue `0xF0B8`). The camera is a **USB host** on MAIN's USB port; the radio is the device `26AA:0001`. | pc-06, pc-03 [B] |
| doc 08: "USB CAMERA is not USB" | It **is** USB: `26AA:0001` is the snapshot-camera transport (vendor requests `D1`–`D4`). | pc-03, pc-06 [B] |
| docs 09/12: `0x8C4D`/`0x8E46` on SUB are a "settings block" | They hold the **last MAIN→SUB IPC frame**; `0x8C4E` is the low byte of its `0xF0xx` opcode. | pc-04 [B] |
| doc 12 §8.2: only power-on combo index 6 has its own handler | All 11 power-on combos have handlers (table `0x10216` → `0x10242`). | pc-05 [B] |
| pc-03 first draft: `HMSEUSBDRIVER.exe`/`RFP_USB_VB.dll` drive `26AA:0001` | They do not; they are the Renesas boot-mode stack (`045B:0025` only). Nothing in the package references VID `0x26AA`. Corrected in pc-03. | doc 10 [O] |
| pc-01: power-on code `0x77` is an SCI-A→SCI-B bridge at 19200 | `sub_73540` sets SCI-A BRR `0x19` (19200 at 16 MHz), SCR `0x30` (TE+RE, **no RIE** → polled) and `0xFF8004 = 1`: this is the **clone mode**, matching pc-05. The `0x5F` handler (`sub_734C2`, 38400, RIE on) remains the likely bridge. | [O] |

## 2. Surface A — microSD `BACKUP.dat` and `MEMORY.dat` (implement first)

Full detail: `pc-02-dat-files.md`, `ida\out\pc\L2-dat-layout.tsv`.

**Implementable now [B]:**

- **`\FT3D\BACKUP\BACKUP.dat`**, exactly **0x1FDC0** bytes: raw MAIN serial EEPROM
  `0x00140–0x0FFFF`, then `0x10100–0x1FFFB`, then a 4-byte checksum. No header.
- **`\FT3D_MEMORY-CH\MEMORY.dat`**, exactly **0xAC80** bytes: EEPROM `0x1680–0xB7FF`,
  0x80 zero bytes, EEPROM `0x1A000–0x1A917`, checksum, zero padding.
- **Checksum:** unsigned byte sum of everything before it, 32-bit accumulator from 0,
  wraps mod 2³², stored **big-endian** immediately after the covered range. Not a CRC.
- **Memory channels:** 1100 × 32-byte records at `MEMORY.dat` + `0x1800`
  (`BACKUP.dat` + `0x2D40`). RX frequency 3-byte BCD at +0x02 (1 kHz resolution; the
  .25/.5/.75 kHz part implied by the low digits); name 16 bytes at +0x08, all `0xFF` =
  unnamed; offset/split 3-byte BCD at +0x18; CTCSS index at +0x1B (0–49); DCS index at
  +0x1C (0–103).
- **What the radio checks on restore** (RESUME residual 3 — answered):
  - exact file size, only to enable the restore menu item;
  - `BACKUP.dat` only: a 14-byte ID at file offset `0x220` — `"AH72M"`, `0x02`, then the
    radio's own region code from EEPROM `0x21–0x23` (outside the file). A backup from a
    different-region radio is refused **before** anything is written;
  - the checksum — **only after the whole file has been streamed into EEPROM**. A bad sum
    makes the radio reboot and reset settings to defaults.
  - No field range checks and no length field; a malformed file cannot overflow a buffer,
    but it can put out-of-range values into settings.

**Rules for the PC program:** never change file size; never touch the 14-byte ID at
`0x220`; recompute the checksum on every save and verify it before the user copies the file;
edit only fields whose meaning is known; keep the user's original file as an undo copy.

**Unknown:** bit-fields in channel bytes +0x00, +0x01, +0x05, +0x1D–+0x1F (mode, step,
shift direction, power, tone mode, skip); slot → channel-number/bank mapping and the
per-slot flag arrays; the name character set.

## 3. Surface B — DATA-jack raw clone (the real clone path)

Sources: pc-02 (EEPROM ranges), pc-05 (power-on code), orchestrator check [O].

- **Entry:** power-on key code `0x77` (key bit 3 held alone at cold power-on) →
  `sub_73540`: SCI_4 ("SCI-A", `0xFFFE90`) **19200 8N1**, polled, `0xFF8004 = 1` [O].
  Which physical key bit 3 is: not in the image (pc-05: probably a digital-function key,
  low–medium confidence).
- **Direction:** `0x2AD0A` reads `0xFFBBC2` (written by the clone screen code around
  `0x26F3C`); `== 1` → `sub_7358E` (**receive**), otherwise → `sub_737FC` (**send**) [O].
- **Send sequence** (`sub_737FC`) [O]: build a 10-byte header at `0xFF96F8` (`sub_7390A`),
  transmit it through `sub_738CC` (the only writer of TDR `0xFFFE93`/SSR `0xFFFE94` in this
  code), wait for **ACK `0x06`** (`sub_737A8`, retries on anything else); then 0x3FB
  blocks of **64 bytes** read from EEPROM from `0x140`, then 0x3FC blocks of 64 bytes from
  `0x10100`; then a final byte. These are exactly the `BACKUP.dat` ranges, so a clone
  image and `BACKUP.dat` carry the same data.
- **Receive** (`sub_7358E`) runs the same `sub_737C8` ID check as the card restore
  (`"AH72M"`, version 2, region) before writing anything [B, pc-02].

**Unknown before a PC can clone safely:** per-block ACK and any per-block checksum
(`sub_73686`, `sub_736B6`, `sub_7374A`), the final byte, timeouts, whether the receive side
checks the 32-bit sum the way the card restore does. This needs one short targeted pass on
`0x7358E–0x73920`. Until then, **use Surface A** — it moves the same bytes with a
known checksum.

## 4. Surface C — DATA-jack WIRES-X node link

Full card: `pc-01-cat-api.md`, `ida\out\pc\L1-cat-commands.tsv`.

- **Entry:** power-on codes `0x37` (`0xFF8DDE` 0↔`0x01`) or `0x67` (0↔`0xFF`); the mode
  survives power cycles [I]. In plain COM mode the port carries NMEA/waypoint text at the
  menu-selected 4800/9600/19200/38400 instead.
- **Port:** 38400 8N1, fixed, no echo [B].
- **Frame:** `SOH(0x01) letter NNNN(4 hex, payload length) payload EOT(0x04) CC(2 hex)`,
  CC = 8-bit sum of SOH…EOT [B]. No NAK ever sent; bad frames are dropped.
- **Session:** `V` → 57-byte ident (model, destination "EXP", radio ID); `M` opens the
  data phase. Keep-alive: a good frame at least every ~3 s, or mode `0x01` restarts MAIN
  after ~10 s and mode `0xFF` drops the session after ~5 s.
- **Reads:** `C` status + radio ID, `N` GPS text; unsolicited `P`, `H`, `R`, `G`, `W`.
- **Writes (fixed, bounded):** `M` retunes the live radio (frequency, shift, offset,
  CTCSS, DCS, mode) in mode `0x01`; `E`, `F` load data for on-air transmission.

**Must never send:** a length field above `0x8F7` (no bounds check — RAM overrun, live in
every mode); `S` with payload `'1'` (keys the transmitter — only with a licensed operator in
control); `V` after the session is open (restarts MAIN); an `M` with any field not chosen
deliberately; anything while the port is in a bridge mode.

**Unknown:** five `M` fields and the frequency tables (`sub_25D72`, `sub_3F522`); status
characters; the mode-`0xFF` position state machine; main-loop rate vs the 512-byte RX ring;
whether `M` changes persist to EEPROM; the zero handler pointer `0xFFB3C6` called in plain
mode.

## 5. Surface D — USB `26AA:0001` (snapshot-camera personality)

Full detail: `pc-03-usb-bulk.md`, `pc-06-camera-files.md`, `ida\out\pc\L3-usb-requests.tsv`.

- Normal (centre-switch) operation; radio is the USB **device**, PC/camera is host.
  Attach = bit 2 of `0xFFEE2D` (D+ pull-up) [pc-07].
- Descriptors at `0x055818` [B]: one interface FF/01/FF; **EP1 bulk OUT 64 B**,
  **EP3 interrupt IN 8 B**, **no bulk IN**; five config variants differing only in EP3
  bInterval (selected by `0xFF89CF`).
- EP0 requests [B]: `GET_DESCRIPTOR` (device/config, no strings); `C1 D4` (1 byte: quality
  code `0x18`/`0x30`/`0x50`); `41 D1` start image, 24-bit length in wValue/wIndex;
  bulk-OUT raw JPEG in 64-byte packets; `41 D2` end/commit; `41 D3` set a parameter/status.
  EP3 report byte 0 = size (`0xFF89CE`), byte 1 = quality (`0xFF89CD`).
- MAIN relays the JPEG to SUB in 256-byte IPC blocks (`0xFFFF` command, block no./total,
  32-bit running sum, 16-bit checksum); SUB previews it (320×240) and on confirm writes it to
  the card (§6) [B].
- **Driver:** no Yaesu driver for `26AA` exists in this tree. Bind **WinUSB** (custom INF or
  Zadig) to `USB\VID_26AA&PID_0001`, or use libusb/libusbK.

**A PC can:** read size/quality, and push a JPEG as if it were the camera. **Cannot:** pull
images (no IN pipe), or reach memory, flash, clone data or the node-link commands — the
request set is closed.

**Unknown:** whether the radio accepts a non-camera host at run time [I]; meaning of `D3`
and of the `0xFF8184` command values; mapping of size/quality codes to menu labels; EP3
bytes 2–7.

**Avoid:** PID **`0x0020`** (CDC-ACM). It only appears when key `0x11` is held at cold
power-on, and bytes sent to it go into the DSP boot loader (§7). A PC program should refuse
to talk to a radio enumerating as `26AA:0020`.

## 6. Picture files on the card

Full detail: `pc-06-camera-files.md`, `ida\out\pc\L6-camera-path.tsv`.

- **Image:** `PHOTO\H<5-char ID>0<5-digit serial>.jpg`, the raw JPEG as received, no
  wrapper [B]. Received C4FM pictures use the same writer.
- **Index (MAIN writes, `QSOLOG\`)** [B]: append a 128-byte record to `QSOPCTDIR.dat`
  (callsign, date/time, size, filename, 20-byte position); append a 4-byte entry
  `(n-1)*0x80 | 0x40000000` to `QSOPCTFAT.dat`; rewrite counters in `QSOMNG.dat`
  (+0x10 count, +0x12 serial).

**A PC can read** all of this now (picture viewer / log export). **Writing** new pictures
for the radio to send is feasible from this layout, but pc-02 advises read-only for
`QSO*.dat` until the FAT flag bits and the read-back validation are known.

**Unknown:** FAT flag bits; file ops `0x0B`/`0x14`/`0x50`/`0x64`; whether `0xFF8060` is the
radio's own ID; whether the radio validates the `QSO*` files on read-back.

## 7. Modes a PC program must stay out of

- **DSP WRITE MODE** (pc-04, 23-step chain, all but one high confidence): SUB `0x8C4E`
  becomes 8 **only** when key `0x11` is held at cold power-on → `0xFF813A = 1` →
  `sub_103C0` → UI mode `0xEE` → `sub_5E9E2` sends IPC opcode `0xF008`. The radio stops
  normal operation, shows "Push DISP Key!", and on DISP starts `0x5DCD8`, which resets the
  DSP, holds it in boot mode, and relays CDC-ACM bytes into it. Only a power cycle exits.
  **No CAT, clone, USB request or SD file can enter it** — a software restart sets warm
  flag `0xFF816F`, which skips the power-on combo check. Keep config bit `0xFF89C2`.0
  unchanged (when set it blocks entry; meaning otherwise unknown).
- **Key `0x11`** (pc-05): by behaviour it is the **A/B operating-band key** (short press
  toggles `0xFF8EA0`.6 = band B; long press toggles `.7`, probably dual/single receive).
  Printed legend "A/B" ≈ 70 % — from recall of Yaesu documentation, not from this tree.
  Safe confirmation: in normal use press each front key once; the one that swaps A↔B is
  `0x11`. **Do not** test it by holding at power-on.
- **Bridge modes** (power-on code `0x5F`, likely others): SCI-A transparently wired to
  another serial peripheral; do not drive.
- **Silicon boot mode** (program switch up/down): the USB boot ROM erases the whole MAIN
  flash as soon as its startup queries finish (pc-07). Outside scope; never run.

## 8. Hardware facts the program needs (pc-07)

- MAIN: **R5F61668R / R5F61668M** (H8SX/1668R group). φ = 16 MHz, USB clock 48 MHz.
  SCI: B = 16 MHz / (32 × (N+1)). BRR table `0x452C2` gives 4800/9600/19200/38400
  (+0.16 %). DATA jack = SCI_4 (P60/P61). SUB link SCI_6 = 500 kbaud.
- The chip marking on the board would settle 1668R vs 1668M; nothing in software depends on it.

## 9. Suggested build order

1. **Card editor** (Surface A): open `BACKUP.dat`/`MEMORY.dat`, validate size + checksum +
   ID, show/edit frequency, name, offset, CTCSS, DCS; re-sum on save; never resize.
2. **Picture/log viewer** (§6), read-only.
3. **Node-link monitor** (Surface C), read-only commands first (`V`, `C`, `N`, passive
   frames), with hard guards: max length `0x8F7`, no `S '1'`, no second `V`.
4. **Clone over cable** (Surface B) after the short follow-up pass on `0x7358E–0x73920`.
5. **USB picture push** (Surface D), optional.

## 10. Still unknown — ranked by value to the program

1. Channel record bit-fields (mode, power, step, shift, tone mode, skip), slot→bank
   mapping, name charset. Fastest route: diff two `MEMORY.dat` files saved by the radio
   before and after changing a single field on the radio.
2. Clone block protocol details: per-block ACK/checksum, trailer byte, timeouts
   (`sub_73686`, `sub_736B6`, `sub_7374A`, `sub_7390A`).
3. The five unknown `M` fields and whether `M` persists to EEPROM.
4. `QSOPCTFAT.dat` flag bits and `QSO*` read-back validation.
5. Physical legends of key bits 2, 3 (clone / node power-on key) and 0x11 — one look at
   the radio or its Operating Manual "Controls" page.
6. Whether the radio accepts a non-camera USB host; meaning of `41 D3`.
7. `0xFFB3C6` zero handler pointer in plain COM mode; the unexplained write of `0x03` to
   `0xFFFF6B` at `0x2352`.

## Deliverables of this pass

| Lane | Note | Table |
| --- | --- | --- |
| 1 CAT/node link | `pc-01-cat-api.md` | `ida\out\pc\L1-cat-commands.tsv` |
| 2 `.dat` files | `pc-02-dat-files.md` | `ida\out\pc\L2-dat-layout.tsv` |
| 3 USB `26AA:0001` | `pc-03-usb-bulk.md` | `ida\out\pc\L3-usb-requests.tsv` |
| 4 DSP-WRITE-MODE | `pc-04-dsp-write-mode.md` | `ida\out\pc\L4-dsp-write-chain.tsv` |
| 5 Key `0x11` | `pc-05-key-0x11.md` | `ida\out\pc\L5-keycodes.tsv` |
| 6 Camera files | `pc-06-camera-files.md` | `ida\out\pc\L6-camera-path.tsv` |
| 7 MAIN part | `pc-07-h8s-part.md` | `ida\out\pc\L7-register-match.tsv` |

Working files beyond the one table per lane (raw dumps, listings) were also left by lanes
2, 4 and 6: `ida\out\pc\L2-listings\`, `ida\out\pc\PC_L4_*.txt`, `ida\out\pc\L6_*.txt`;
scripts are `ida\jobs\pc_l*_*.py`; private databases `ida\db\jobs\PC_L1…PC_L6_*`.

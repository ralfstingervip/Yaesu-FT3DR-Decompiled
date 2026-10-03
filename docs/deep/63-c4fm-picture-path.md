# 63 — Pictures over C4FM: the received-picture path and the send path (lane I11)

Owner-side static analysis of the decrypted ver 1.02 images on disk. Nothing was written to any
device, no image byte was changed, and no shared database was opened. MAIN is H8SX, big-endian, base
0, so file offset = mapped address. SUB is RX64M, little-endian, mapped at `0xFFC00000`
(file offset = addr − `0xFFC00000`). The closed MAIN window `0x078106`–`0x07B753` was not decoded.
Model: **claude-opus-5-5**.

Private DB `I11_MAIN`, via `run_job.py` only, seeded `--copy-from ida\db\jobs\MAIN_FINAL\MAIN_FINAL.i64`
(h8sxa), then `--reopen`. Job script `ida\jobs\i11_dump.py` (range/xref/func dumper; `auto_wait`,
try/except→`traceback.txt`, UTF-8, `qexit(0)`, never decodes inside the closed window). No traceback
was produced. Every byte cite below was independently read from `decrypted\*.bin` in Python
(`ida\out\c4fm-picture\verify.tsv`, 20 checks). Tables under `ida\out\c4fm-picture\`:
`receive-path.tsv`, `send-path.tsv`, `picture-cells.tsv`, `framing.tsv`, `verify.tsv`; raw listings in
`work\`.

## Verdict

**Conflict settled first: at `0x055DFC` the `EEPMOV.W` copies 280 (`0x118`) bytes FROM `0xFF9800`
INTO `0xFF1489`. Lane I4 (doc 56) is right; lane I1 (doc 53) has the direction reversed.** The bytes
at `0x055E06` are `79 04 01 18` (`mov.w #0x118,r4`), `7a 05 00 ff 98 00` (`mov.l #0xFF9800,er5`),
`7a 06 00 ff 14 89` (`mov.l #0xFF1489,er6`), then `7b d4 59 8f` (`eepmov.w`) at `0x055E16`. H8S/H8SX
`EEPMOV` is defined `@ER5 → @ER6` with ER5 = source, ER6 = destination, R4 = byte count — so source is
`0xFF9800`, destination is `0xFF1489` (both *verified*). I1 read the registers correctly but applied
the convention backwards. (Also: it is `0x118` **bytes**, not words.)

**The received-picture path is fully traced, end to end, and it does not resemble I1's model.** A
C4FM picture is not carried on the "reverse SCI-D buffer `0xFF9800`" — that buffer is the SUB→MAIN
read-back used by the *send* path. A received over-the-air picture travels: C4FM data frames → DSP
(SCI-C) → MAIN DSP-RX reassembler → `N`/`G` message stores → a picture-transfer state machine that
copies each 1,024-byte data block into staging buffer `0xFF5006` → the **same FFFF block-transfer
engine the camera uses** (`sub_B610`, with the source pointer `0xFFBC48` repointed to `0xFF5006`) →
SUB external graphics RAM `0x070E1000` (the JPEG-decoder input) → baseline JPEG decode → 320×240 LCD
preview → on user confirm, a `0xFC00` SD request has SUB `f_write` the raw JPEG from `0x070E1000` to
`I:\PHOTO\H<id5>0<nnnnn>.jpg`. The picture is thus stored as the exact JPEG byte stream received, in
the same folder and with the same filename scheme as a camera snapshot (doc pc-06). The SUB side has
**exactly two** writers of `0x070E1000` in the whole 4 MB image — the FFFF handler and the SD-file
reader `sub_FFF3CAD0` — so this is the only way received pixels can reach the decoder, and it is
confirmed.

**A send path exists** (transmit a stored `.jpg` over C4FM): MAIN opens the SD file, SUB streams it
back to MAIN as reverse `0xFF` SCI-D frames into `0xFF9800`, MAIN reassembles (`sub_55DFC`) and packs
1,024-byte blocks (`sub_5FA26`, from `0xFF5406`) into C4FM data messages for the DSP TX session.

**USB answer: no.** No received or sent picture byte is exposed on USB or the DATA jack outside the
closed service window. The picture data plane is DSP(SCI-C) ↔ MAIN RAM ↔ SCI-D ↔ SUB ↔ SD card; it
never touches the USB function module `0xFFEE00` or the DATA-jack SCIs (A/B). The only USB picture
surface is the *camera input* (`VID 26AA:0001`, EP1 bulk-OUT → `0xFF5806`, host→radio; I1 doc 53), and
the SD card is not exported as a USB mass-storage device.

## Method

- `I11_MAIN` seeded from `MAIN_FINAL`. `i11_dump.py` dumped, with per-line xrefs, the N/G message
  readers (`0x05EC00`–`0x05FB80`), the picture save/forward region (`0x055A42`–`0x056036`), the SD
  request builders (`0x06FD00`–`0x071340`), the generic IPC senders (`0x00ADC0`–`0x00B13E`), the
  reverse-frame driver family (`0x047600`–`0x048300`), the DSP-RX completion/classifier
  (`0x058400`–`0x0586A0`), and the picture-dialog UI handler (`0x02ACAA`). Function lists and xref
  censuses were taken on the save triggers, the push engine, and `sub_B610`.
- Decisive raw-byte scans of `decrypted\FT3D_MAIN_ver102_EXP.bin`: every `jsr @aa:24` to `sub_B610`
  (exactly 4 sites) / `sub_55976` / `sub_559F4` / `sub_B6B6` / `sub_55DFC`; every 32-bit immediate load
  of `0xFF5006`/`0xFF5406`/`0xFF5806`/`0xFF9800`/`0xFF1489`/`0xFF07A4`; every writer of the SD op field
  `0xFFBA9E`. Raw-byte scan of `decrypted\FT3D_SUB_ver102_ALL.bin` for every reference to `0x070E1000`
  (exactly 5), `0x070E0000`, `0x07000000`, and the strings `I:\PHOTO`/`I:\QSOLOG`.
- I4's operand-reference census (`ida\out\dsp-rx\work\refs.tsv`) was read for leads only; every
  load-bearing fact below was re-read from the image bytes.
- Cross-checked against docs 53 (I1), 56 (I4), 51 (H14 SUB link), 52 (H15 DSP), 34 (F7 FatFs/JPEG),
  pc-06 (camera files), 50 (frame packing). Corrections to 53 are recorded below.
- **Not done / Not found.** No SUB database was opened this lane; the SUB-side claims rest on the
  5-reference `0x070E1000` scan plus the first-hand work in docs 51/34/pc-06 (re-verified strings).
  The DSP TX session that emits picture messages (`0x05B458` area, lane I5 territory) and the exact
  block-retransmit/ACK handshake (`0xFFB252`/`0xFFB24E`, `sub_5F250`) were mapped but not reconstructed
  instruction-by-instruction. The `0xFFB20E`/`B22A`/`B23C` date/position/ASCII-date fields are filled
  from N-store copies (`0x05F3xx`) but the GPS-position byte format was not decoded.

## Findings

### 1. The `0x055DFC` EEPMOV — conflict resolved (Confirmed, byte-verified)

`sub_55DFC` (`0x055DFC`, sole caller `0x047B66`) is the SUB→MAIN **read-back** reassembler used by the
send/re-save path, gated on `[0xFFBC54]==2`. It first copies the 280-byte reverse-frame header block
`0xFF9800 → 0xFF1489` (the EEPMOV), then validates the frame (sub-length `[0xFF9802/03]−0x11 ≤ 0x100`,
block number `[0xFF980B/0C]` vs `[0xFFBC40]`, total `[0xFF980D/0E]` vs `[0xFFBC42]`), then copies the
payload from `0xFF9813` into `*[0xFFBC48]` summing a 32-bit checksum into `0xFFBC44` (`0x055E9E`,
*verified* `7a 05 00 ff 98 13 01 00 6b 06 bc 48`). So `0xFF9800` is the reverse-direction SCI-D
*receive* buffer and `0xFF1489` is a scratch copy — source `0xFF9800`, dest `0xFF1489`. **Correction to
doc 53 (I1):** its "EEPMOV from `0xFF1489`" and "C4FM-received pictures arrive … into `0xFF9800`" are
both wrong; `0xFF9800` carries the SUB→MAIN read-back for *transmit/re-save*, not over-air reception.

### 2. Received-picture control plane (Confirmed)

Over-air C4FM data frames are reassembled by the DSP-RX machine (`0x056B8A` dispatch, doc 56) into
data-FR messages in `0xFEF962` (≤1,040 B), classified by `0xFEF963` (class) + `0xFEF964` (letter) and
copied to a class store — `N` → `0xFF07A4`, `G` → `0xFF1440` (writers `0x057FC0`/`0x058440`,
*verified*). The picture message processor `sub_05ED18` runs a state machine on `0xFFB25F` /
`0xFFB263`:

- **Header** (`sub_5F330`, letter `c`/`d` in `0xFFB259`): copies sender radio ID → `0xFFB1DE`,
  callsign/ID text → `0xFFB1F0`/`0xFFB203`, and reads the picture size `0xFFB208`, dividing by `0x400`
  (1,024) to set the block count `0xFFB25A` (*verified* `0x05F3F4` … `79 05 04 00` `divxu.w`,
  `0x05F408` → `0xFFB25A`). Sets `0xFFB263=2`, screen `0xFF95E0='P'`.
- **Data block** (`sub_5F458`, letter `b`): copies the 1,024-byte block from the N-store payload
  `0xFF07F2` into staging buffer **`0xFF5006`** (`0x05F480` `7a 02 00 ff 50 06`), accumulates the 32-bit
  picture checksum into `0xFFB1D4`, sets the FFFF-push source pointer **`0xFFBC48 = 0xFF5006`**
  (`0x05F4B6` `7a 04 00 ff 50 06 01 00 6b 84 bc 48`), and raises the push trigger `0xFFBC55=1`.
- **End** (`sub_5F53E`, letter `e`): final block/total and 32-bit checksum compare vs `0xFFB1D4`.

### 3. Received-picture data plane: it reuses the camera FFFF engine (Confirmed)

`sub_B610` (the `0xFFFF` block-transfer frame builder → `sub_B6B6` → SCI-D) has **exactly four** call
sites in the whole image (raw scan): `0x0559DA`, `0x055A06` (camera, source `0xFF5806`), `0x055D32`
(view/send stored picture), and **`0x055FDE`** (received picture). All four push from the pointer
`0xFFBC48`. The received-picture push is wired through the SD/transfer tick `sub_55B7A` (`0x055B7A`,
called from `0x02C20`): at `0x055BCA` it reads the trigger `0xFFBC55`, clears it, and dispatches
`0xFFBC57` through `off_55C12 = {sub_55F84, sub_55F96, sub_55FF0}` (*verified* `0x055C12`
`00 05 5f 84 00 05 5f 96 00 05 5f f0`). `sub_55F96` is the pusher: it walks `0xFFBC48` in 256-byte
steps and `jsr sub_B610` at `0x055FDE` (*verified* `5e 00 b6 10`). So each 1,024-byte received block
goes out as four `0xFFFF` frames into SUB `0x070E1000` — identical transport to the camera, just
sourced from `0xFF5006` instead of `0xFF5806`. **Correction to doc 53 (I1):** it labels `0x055FDE` as
"the `0xFE00` read-back request via `sub_B5CE`" — `0x055FDE` is `jsr sub_B610` inside `sub_55F96`, the
received-block push; `sub_B5CE` is called at `0x055DEE`, a different routine.

### 4. SUB receives, decodes, displays, and saves (Confirmed by scan + docs 51/34/pc-06)

`0x070E1000` is referenced exactly 5 times in the SUB image: written by the FFFF handler
(`0xFFEDC517`, doc 51) and by the SD image-file reader `sub_FFF3CAD0` (`0xFFF3CBF5`); read by the JPEG
decoder `sub_FFEDE804` (`0xFFEDE80A`) and the save-length helper `sub_FFEDE93A` (`0xFFEDE954`). So for a
received picture the pixels arrive via the FFFF handler, are decoded by the baseline JPEG core
`sub_FFF4B084` into the 320×240 RGB565 framebuffer `0x070BB800` (doc 34) and shown on the LCD
(`0x06000000`, doc 51). On user confirm the picture is saved; `sub_FFF3CAD0` (SD-file read into
`0x070E1000`) is the path for *viewing an already-saved* picture from the gallery.

### 5. The save (Confirmed, byte-verified)

Picture-dialog confirm `0x02ACAA` sets `0xFFBA81` bit 1 and `jsr sub_55A70` (`0x02ACD2`, *verified*).
`sub_55A70` sets the save source type `0xFFBC52=3` (camera uses `sub_55A42`, `=2`) and calls
`sub_710C4`→`sub_710DE`, which builds the SD request (template `0x71326`): op `0xFFBA9E=1` (create
`"w"`), param `0xFFBA9F=4` (data from SUB `0x070E1000`), dir `0xFFBAA0=5` (`PHOTO`), size
`0xFFBA96 ← 0xFFB208`, filename from `sub_6EE38` + `".jpg"` (*verified* `0x0710F8`
`fc 01 6a 8c ba 9e fc 04 … fc 05 …`). The request is transmitted to SUB with opcode **`0xFC00`**
(`sub_D53A` → `sub_71196` → `sub_B6B6`, *verified* `0x00D554` `79 0c fc 00`). SUB parses it
(`sub_FFF3E4A7`, pc-06), builds `I:\PHOTO\` (string at `0xFFF4AD9D`, *verified* `50 48 4f 54 4f`) +
name, and `f_open`/`f_write`s the raw JPEG from `0x070E1000` (docs 34/pc-06). The QSOPCTDIR/QSOPCTFAT
index records in `I:\QSOLOG` (`0xFFF4AD93`) are appended as for the camera (pc-06 §4–5); the received
record carries the sender ID/callsign, position and date parsed from the picture header message
(§2) rather than the local GPS fix.

### 6. The send path (Confirmed core, Inferred tail)

To transmit a stored `.jpg`: the `0xFFBC50` tick machine (`sub_55C1E`, state 0) opens the file (name
`0xFF301E`, size `0xFF301A → 0xFFB208`) and computes the block count. SUB streams the file back to
MAIN as reverse `0xFF` SCI-D frames into `0xFF9800`, which `sub_55DFC` reassembles (§1) into a MAIN
buffer, verifying block number/total and a 32-bit checksum. MAIN then packs 1,024-byte blocks:
`sub_5FA26` copies from `0xFF5406` into the outgoing message buffer `*[0xFFBABE]` while summing the
32-bit checksum `0xFFB1D4` (*verified* `0x05FA30` `7a 02 00 ff 54 06`), and `sub_5F89C` loads the size
from `0xFF2F9A` into `0xFFB208` and recomputes the block count. These blocks become C4FM data
messages (header letter `c`/`d`, data letter `b`, end letter `e`) handed to the DSP TX session
(`0x05B458` area, doc 52 / lane I5) — this last hop is Inferred from the shared framing, not decoded
here. Max picture size is bounded by the SUB decode window `0x14000` = 81,920 B (pc-06), i.e. up to
~80 blocks of 1,024 B.

### 7. Framing summary (Confirmed where cited; see `framing.tsv`)

A picture is a sequence of Yaesu C4FM data messages: a header (`c`/`d`) carrying sender radio ID (5),
callsign/ID, size (u32) and position/date; one message per 1,024-byte block (`b`), block-numbered and
retransmit-capable via `0xFFB252`/`0xFFB24E`; and an end (`e`) with a 32-bit additive checksum of all
picture bytes (`0xFFB1D4`). Each DSP frame carries its own additive checksum and an `0x03` ETX. The
on-card filename is `H` + the radio's 5-char C4FM ID (`0xFF8060`) + `'0'` + a 5-digit serial + `.jpg`
(`sub_6EE38`); the 128-byte QSOPCTDIR record holds sender/own callsign, BCD and ASCII date/time, size,
name and a 20-byte GPS-position block (pc-06 §4).

## USB relevance

- **Q1 (everything USB).** The C4FM picture path adds no USB surface. Receive and send both run on
  SCI-C (DSP), MAIN RAM, SCI-D (MAIN↔SUB IPC) and the SD card; none of the picture buffers
  (`0xFF5006`/`0xFF5406`/`0xFF5806`/`0xFF9800`/`0xFF1489`), the `N`/`G` stores, or the SD-request path
  touches the USB function module `0xFFEE00`–`0xFFEE53` or the DATA-jack SCIs. The one USB picture
  surface is the **camera input** (`26AA:0001` EP1 bulk-OUT → `0xFF5806`, host→radio, I1 doc 53); that
  is a different buffer from the C4FM receive buffer `0xFF5006`, confirming I1's exclusion. A received
  picture is reachable from a PC only by reading the SD card's `I:\PHOTO\*.jpg` (not a USB function of
  this firmware — there is no USB mass-storage descriptor).
- **Q2 (USB SDR): still no, and reinforced.** The largest MAIN→SUB bulk transfer is again the FFFF
  image path terminating in a JPEG framebuffer; the received-picture data plane is byte-reblocked at
  SCI speed and ends as a `.jpg` on the SD card. No sample/IQ stream, no USB endpoint, in this path.
- **Q3 (DSP): unaffected.** Pictures ride the existing C4FM data-message service of the DSP link
  (opcodes/letters, §2/§7); no new DSP access, and nothing enters the closed download window.

## Open (most valuable first)

1. Decode the DSP TX session that emits the picture `b`/`c`/`d`/`e` messages (`0x05B458` area, lane
   I5) to make the send path's last hop Confirmed, and confirm whether the TX uses the `N` or `G`
   message class.
2. Reconstruct the block retransmit/ACK handshake (`sub_5F250`, `0xFFB252`/`0xFFB24E`, `0xFFBC54`
   machine) so partial/out-of-order picture reception is fully specified.
3. Decode the GPS-position byte layout in the picture header (`0xFFB22A`) and the QSOPCTDIR +0x64
   block, and the `0xFFB266` flag bits that pc-06 §4 left open for received records.
4. Confirm first-hand on a SUB DB that `sub_FFF3E4A7`/`f_open`/`f_write` write the received JPEG to
   `I:\PHOTO` (currently cross-referenced from docs 34/pc-06 plus the verified `0x070E1000` scan and
   path strings).

## Ledger

No coverage-number change. Every routine and byte cited here is already named/typed code in the
`MAIN_FINAL` seed (all appear as `sub_*`/data with existing names) and is counted in MAIN named/typed
497,139 / proven 365,570. This lane attributes and byte-verifies existing code and resolves a
direction conflict; it adds no new proven or named bytes, retypes nothing, and creates no
`ledger-delta.tsv`. It touches no SUB bytes (no SUB DB opened), so there is no interaction with
`ida\out\orphan-screens\exit-table-new-insns.tsv`, `ida\out\indirect-cb\ledger-delta.tsv`, or
`ida\out\suspect-tables\new-proven-bytes.tsv`.

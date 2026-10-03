# 74 — Vendor-USB loose ends: key 0x14 (`41 D3`) and tone event 0x4F (lane J6)

Owner-side static analysis of the ver 1.02 images already on disk. Nothing was written to any radio or
device, nothing was enumerated, no image byte was changed, and the closed window `0x078106`–`0x07B753`
was never decoded. MAIN is H8SX, big-endian, base 0, so the file offset equals the mapped address for
every MAIN cite below. Model: **claude-opus-4-8**.

Tables are in `ida\out\usb-key14\`: `sub_708b6-trace.tsv`, `ffaae8-refs.tsv`, `event-4f-path.tsv`, with
raw IDA dumps in `ida\out\usb-key14\work\p1` and `work\p2`. All 14 load-bearing byte runs were
re-read from the image (`decrypted\FT3D_MAIN_ver102_EXP.bin`, unchanged): `mismatch 0 of 14`.

## Verdict

Both loose ends resolve to ordinary UI plumbing with no new USB surface.

**(1) Key 0x14** is the camera accessory's second button, exposed over USB by vendor request `41 D3`.
`D3` drives a 3-state edge detector (`sub_FDC8`) whose press branch at `0x00FDFE` injects raw key code
`0x14` into the key-event cell `FFA9ED`. That is the **only** injector of `0x14` in the entire image
(Confirmed by whole-image scan). The key scanner then remaps the raw code (`0x14 − 9 = 0x0B`) so it
dispatches as key index 11, whose handler is `0x06F5D0`. The handler fires only when the operating band
is in a digital mode, a picture is currently on-screen (`FFBA32 ≠ 0`) and no picture operation is in
progress (`FF2EC9 == 0`); otherwise it falls through to the default `sub_3FFA0`. When it fires it builds
the filename "`<last-picture-stem>.jpg`" in RAM and calls `sub_708B6`. **`sub_708B6` does not itself read
the SD card** — it posts a photo-viewer request: it sets the "request pending" lock `FFBA30.7`, writes a
geometry word, a layout-record pointer, the viewer op-code `FFBA9E = 0x14`, and copies the 16-byte
filename into the viewer's open buffer `FFBAC2`. The key handler then sets the top-level UI screen id
`FFBAA3 = 0x25`. The photo-viewer/SD task (`sub_6FD82` family, `0x06Fxxx`–`0x071xxx`, the FatFs JPEG
viewer already documented in the completion wave) picks up the request, opens that `.jpg` and renders it.
End to end: "key 0x14" opens the last snapshot on the radio's photo-display screen. It can do nothing
else — the handler has exactly one action path and no other injector exists.

**(2) Tone event 0x4F** is a **tone/beep event code**: one of four "restart / high-priority" entries in
the sequencer's accepted-event table at `0x03839C` (`4f 1e 35 5d ff`). It is posted to the event mailbox
`FFAAE0` at exactly one site in the image — `0x05548E`, the USB `41 D1` image-upload-accept handler —
so event 0x4F *is* the "camera upload start" confirmation beep. `FFAAE8` is the tone sequencer's **phase
counter** (0 = idle, 1/2/3 = a tone is playing); it is written only by the sequencer `sub_3835E` and its
phase handlers, and read cross-subsystem by the USB D1 gate (`0x055520`) and five UI/audio waiters. The
D1 handler sets control-machine state 8; state 8 (`sub_55520`, `0x055520 = 6a 0c aa e8 46 f8`) spins on
`FFAAE8 == 0` and NAKs the control-transfer status stage until the sequencer finishes playing the 0x4F
beep and clears `FFAAE8` back to 0 (`0x038674` / `0x038762`). So the tone event bounds the delay: the
host's `D1` transfer completes only after the confirmation beep has played out.

## Method

One private DB, `J6_USBKEY`, seeded `--copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64`, then
`--reopen` for a second pass. Both passes exited 0, no traceback. The job script `ida\jobs\j6_dump.py`
is read-only (no edits, no auto-analysis; it skips the closed window) — a J6 copy of I12's dumper.

- **Pass p1** dumped the key-0x14 handler (`0x06F4E0`–`0x06F700`), `sub_708B6` and its whole sibling
  family (`0x0708B6`–`0x070E00`), the `D3` reader/key-scan (`0x00FB40`–`0x00FE90`), the tone sequencer
  (`0x038330`–`0x0385C0`), and the state-8 gate (`0x055480`–`0x055560`); plus an xref census and a
  code-head grep for every `FFAAE8` / `FFAAE0` / `FFBA32` / `FFBAA3` reference.
- **Pass p2** dumped the sequencer tail (`sub_38638`, `sub_38686`), the event-table search `sub_3F768`,
  and the viewer-request consumer (`sub_6FD82`).
- **Independent Python byte scans** over the unchanged image found every store to `FFA9ED`, `FFAAE0`,
  `FFAAE8`, `FFBA30/86/88/9E/A3/C2`, `FFBA32`, and every `#0x14`/`#0x4F` immediate feeding them, then
  byte-verified all 14 cites. These do not depend on IDA's analysis.

Not done: the exact pitch/melody of the 0x4F beep (its note-script lives in `off_387FA[0x4F−0x16]`
reached via `sub_38410`; only its *duration* bounds the USB delay, and that is the sequencer's generic
note-countdown, so the melody was not decoded). No host code was written or run.

## Findings

### 1. Key-0x14 injector is unique and USB-only (Confirmed)

The physical-key path and the remote-button path share the scanner in `sub_FB..`. The relevant readers,
each guarded by "no key already pending" (`FFA9ED` positive = pending):

```
00fb9e  jsr sub_FDC8            ; the 41 D3 remote-button edge detector
00fba2  mov.b @FFA9ED, r4l
00fba6  bpl  loc_FBC8           ; event present -> go remap
```

`sub_FDC8` (`0x00FDC8`) is a 3-state edge detector on the `D3` parameter cells `FFB096`/`FFB097` (a clone
of the port-`0xFFFF4E` debouncer `sub_FD5E`). Its press branch:

```
00fdfe  fc 14          mov.b #0x14, r4l
00fe00  6a 8c a9 ed    mov.b r4l, @FFA9ED     ; inject raw key code 0x14
```

A whole-image scan for stores to `FFA9ED` and for `#0x14` immediates feeding it finds **exactly one**
`0x14` injector: `0x00FDFE`. (Scope: every `6a 8r a9 ed` store and every `fc 14` within 8 bytes of an
`a9 ed` store, whole image.) The remote button has no physical matrix position; `0x14` can only arrive
from the USB `41 D3` request. **Correction to I12 §7:** the dispatched key index is not `0x14` itself —
the shared remap at `0x00FBC8` computes `0x14 − 9 = 0x0B`, so `FFA9ED` holds `0x0B` (key index 11) at
dispatch time. `0x14` is the raw/identifying code; index `0x0B` selects handler `0x06F5D0`. I12's
handler address (`0x06F5D0`) and column (11) are correct.

### 2. Key-0x14 handler `0x06F5D0` and what `sub_708B6` does (Confirmed)

```
06f5d0  btst #6,@FF8EA0 ; pick operating band's digital-mode byte (FF8DD5 or FF8D20)
06f5e2  beq  default    ; not a digital mode -> sub_3FFA0
06f5e6  mov.b @FFBA32   ; a picture must be on-screen
06f5ea  beq  default
06f5ee  mov.b @FF2EC9   ; no picture op already running
06f5f4  bne  default
06f5f8  jsr  sub_3DD98(0)                 ; fetch last-picture 12-byte name stem -> FF2F9E
06f5fe  eepmov 12 B  FF2F9E -> FFBA4A      ; stem to scratch
06f61c  cmp.l #0xFFFFFFFF -> beq default   ; reject empty stem
06f628  eepmov 12 B  FFBA4A -> FFBA5A      ; stem to filename buffer
06f640  mov.l #0x2E6A7067 -> @FFBA66       ; append ".jpg"  (2e 6a 70 67)
06f64a  jsr  sub_708B6                     ; post the view request
06f650  mov.b #0x25 -> @FFBAA3             ; top-level UI screen id = 0x25
```

`sub_708B6` (`0x0708B6`) is one of ~40 near-identical "open screen/view X" posters (`sub_708FC` …
`sub_70E2A`), each setting `FFBA30.7` and a `{FFBA86 geometry, FFBA88 layout-record ptr, FFBA9E op}`
triple. `sub_708B6` additionally copies the 16-byte filename `FFBA5A → FFBAC2`. Full cell trace in
`sub_708b6-trace.tsv`:

| cell | value | meaning |
| --- | --- | --- |
| `FFBA30` bit7 | 1 | view-request-pending / transition lock |
| `FFBA86` | `0x0098` | view geometry/size |
| `FFBA88` | `0x071326` | ptr to layout record `unk_71326` |
| `FFBA9E` | `0x14` | viewer op-code (photo display) — a *viewer* op, unrelated to the key code |
| `FFBAA0` | `0x05` | viewer sub-mode |
| `FFBAD4` | `0x10` | viewer param |
| `FFBAC2` | "`<stem>.jpg`" | 16-byte filename for the FatFs open |

`FFBAC2` has **no** direct `@aa:16` code reference (Confirmed, whole-image scan): it is read only through
a pointer by the filesystem open, consistent with it being a pathname buffer. The consumer is the
photo-viewer/SD task `sub_6FD82` (`0x06FD82`, main-loop ticks `0x2C0C`/`0x3812`/`0x3956`): it waits for
`FFBA30.7` to be released, then dispatches on `FFBA30` through `off_6FDAA` into the picture state machine
that opens and decodes the JPEG. This is the same microSD JPEG viewer documented in the completion wave;
key 0x14 is simply another entry into it. **`FFBA32`** (I12's open question) is the viewer's
picture-view state: cleared to 0 by the viewer reset `sub_6FDD6` (`0x06FDF0`), set when a picture is
displayed; the handler's `FFBA32 ≠ 0` gate means "only transmit when a picture is actually on-screen".

**Can key 0x14 do anything else?** No. The handler has a single action path (the sequence above) and one
fall-through to the default handler. No other injector, and no second branch. (Confirmed.)

### 3. Tone event 0x4F and the `FFAAE8` gate (Confirmed)

`FFAAE0` is the tone/beep **event mailbox**: ~200 sites across the firmware post a one-byte event code
to it (every beep in the radio). `FFAAE8` is the sequencer **phase counter**. The full writer/reader
census is in `ffaae8-refs.tsv`; the essential facts:

- **Every writer of `FFAAE8` is inside the tone sequencer** `sub_3835E`/`sub_383A2`/`sub_384C2`/
  `sub_38638`/`sub_38686` (`0x038340`–`0x038762`). No other subsystem writes it.
- **`FFAAE8` readers outside the sequencer**: `0x010628`, `0x0340F6`, `0x0346D2`, `0x035D36`, `0x0394A8`
  (UI/audio-state waiters) and **`0x055520` (the USB vendor D1 status-stage gate)**.

Event 0x4F (`event-4f-path.tsv`):

```
05548e  fc 4f 6a 8c aa e0   D1-accept: FFAAE0 = 0x4F     (ONLY 0x4F poster in the image)
05549c  fc 08 6a 8c 81 83   D1-accept: control state FF8183 = 8
--- tone sequencer tick sub_3835E, run from the main loop ---
03835e  6a 0a aa e0         r2l = FFAAE0 (event)
0383ac  mov.l #unk_3839C    sub_383A2 searches table {4f,1e,35,5d,ff} (sub_3F768)
                            0x4F is in the table -> "restart": force FFAAE8=0 so it plays from phase 0
0384c2  (phase 0)           start tone, FFAAE8 := 1/2/3 while the note engine runs (AAE6 countdown)
038674  fc 00 6a 8c aa e8   script terminator (0x25) reached -> FFAAE8 := 0   (also 0x038762)
--- USB control machine, state 8 = sub_55520 ---
055520  6a 0c aa e8 46 f8   while FFAAE8 != 0: return without sending status ZLP (host NAKed)
055526  fc 09 ...           FFAAE8 == 0: arm EP0 status ZLP, advance to state 9 (UPLOAD)
```

`sub_3F768` is a trivial table-search returning Z=1 when the event is found; the four table events
`{0x4F, 0x1E, 0x35, 0x5D}` are the ones that pre-empt a tone already playing and restart from phase 0.
So event 0x4F is an audible "upload accepted" confirmation beep that interrupts any lower-priority tone.

**How the delay is bounded.** The sequencer is a note player: `FFAAE2` points at the note script,
`FFAAE6` is the remaining-duration counter decremented each tick (`0x0385C6`), and the next 2-byte note
is fetched until the terminator byte `0x25`. `FFAAE8` stays non-zero for the whole script and returns to
0 at the terminator. Because state 8 reads `FFAAE8` every poll pass and returns early while it is
non-zero, the host's `D1` control-transfer **status stage is held for exactly the play-out time of the
0x4F beep** — a short, firmware-fixed interval, not an unbounded wait. (I12 §5 correctly flagged this
deferral; this lane identifies the event, the writer, and the release mechanism.)

## USB relevance

- **Q1 (everything USB).** Closes three of I12's open items. `41 D3`/key 0x14 is a remote shutter-style
  button that opens the last JPEG on the radio's own screen — it moves no data to the host and reaches
  no new hardware (SD + LCD only). `41 D1`'s deferred status stage is a self-imposed wait for a
  confirmation beep (event 0x4F) to finish; a host driver must tolerate a short NAK window on the `D1`
  status stage but nothing more. Neither path widens the USB data surface.
- **Q2 (USB SDR).** Unaffected and reinforced. Key 0x14 and event 0x4F touch only the UI, the tone
  timer (`FFFEC3`/`FFFEC4`), the SD/JPEG viewer and the SUB link — no IN-endpoint source of samples.
- **Q3 (DSP).** Unaffected. Neither path touches SCI-C or the DSP driver.

## Open (most valuable first)

1. The exact 0x4F note script (`off_387FA[0x4F−0x16]` via `sub_38410`) if the owner wants the literal
   worst-case `D1`-status NAK duration in milliseconds; needs the TPU/PWM tick period at `FFFEC3/C4/C8`.
2. Enumerate the `sub_708xxx`/`sub_70Axxx` viewer-poster family (op `FFBA9E` values `0x14`/`0x50`/… and
   geometry `FFBA86`) to label each camera/photo/QR sub-screen — breadth, not depth.
3. Prove no physical-matrix key can compute final index `0x0B`; this lane proved no *literal* `0x14`
   injector exists, but the matrix scanners (`sub_262E4`, `sub_105BE`) use computed values with the
   same `−9` remap, so a full proof would decode their lookup tables.

## Files

- `docs\deep\74-usb-key14-tone4f.md` (this doc)
- `ida\jobs\j6_dump.py` (read-only IDA job; a J6 copy of I12's dumper)
- `ida\out\usb-key14\sub_708b6-trace.tsv`, `ffaae8-refs.tsv`, `event-4f-path.tsv`
- `ida\out\usb-key14\work\p1`, `work\p2` (raw dumps, xref census, greps)
- DB `ida\db\jobs\J6_USBKEY\J6_USBKEY.i64`; logs `ida\log\jobs\J6_USBKEY\`

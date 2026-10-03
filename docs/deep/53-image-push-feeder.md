# 53 — Who feeds MAIN's image-push driver (lane I1)

Owner-side static analysis of the decrypted ver 1.02 images on disk. Nothing was written to any
device, no image byte was changed, and no shared database was opened. MAIN is H8SX, big-endian,
base 0, so file offset = mapped address. Model: **claude-opus-5-5**.

Private DB `I1_MAIN`, via `run_job.py` only, seeded `--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`
(h8sxa), then `--reopen`. Job script `ida\jobs\i1_push.py` (dump + funcs + xref census; `auto_wait`,
try/except→`traceback.txt`, UTF-8, `qexit(0)`, never decodes inside the closed window
`0x078106`–`0x07B753`). No traceback was produced. Every byte cite below was independently read from
`decrypted\FT3D_MAIN_ver102_EXP.bin` in Python. Tables under `ida\out\image-push\`:
`buffers.tsv`, `buffer-refs.tsv`, `state-vars.tsv`, `senders.tsv`, `driver-functions.txt`, and the raw
disassembly dumps in `work\` (`bulk.txt`, `ctrl.txt`, `sel.txt`, `d1.txt`, `d2.txt`, `end.txt`,
`setup.txt`, `sender.txt`, `funcs.txt`, `xrefs.txt`).

## Verdict

**Confirmed: the image data in MAIN's buffers `0xFF5806`–`0xFF5B06` comes from the on-chip USB
Function Module — candidate (a), the vendor-class device `VID 0x26AA / PID 0x0001` (the "USB CAMERA"
personality), read one byte at a time off endpoint 1 bulk-OUT.** The single instruction that stores
into that buffer window is the byte-copy loop at `0x055684`/`0x055688`, which reads the EP1 data
register `0xFFEE10` (EPDR1) and writes it to `0xFF5806 + index`. That loop is reached only when USB
IFR0 (`0xFFEE00`) bit 6 — EP1-OUT data-received — is set (`0x055556 btst #6`, `0x0556cc btst #6`), so
nothing but the USB engine can drive it. The transfer is armed by the USB vendor control request
`0x41 D1` (`0x05540C`), which latches the 24-bit image size, resets the write index, and points the
block sender at `0xFF5806`; it is terminated by `0x41 D2` (`0x0555F4`). The whole driver lives at
`0x05540C`–`0x055FFE`, **entirely outside the closed window** (`0x078106`–`0x07B753`), and is the one
live USB-adjacent thread outside that window.

**No other source writes these buffers.** A whole-image byte scan (the only way to form the address
`0xFF5806`, which is below the `@aa:16` sign-extension range and so must be built from a 32-bit
immediate) finds 12 references to the four bases, all inside `0x0554xx`–`0x055Fxx`; exactly one of
them is a store, and it is the USB loop. **Not found** (scope: whole MAIN image, all addressing
forms): any write to `0xFF5806`–`0xFF5B06` from a DSP RX handler, an SCI RDR, an SD/FatFs read, a
DMAC/DTC destination, or the CDC-ACM stack. The candidates (b) DATA jack, (c) a non-USB camera bus,
(d) microSD, and (e) C4FM-over-air are all refuted as the source of *this* buffer: the DATA-jack SCIs
and the DSP link never touch it; the microSD is the *sink* (the received JPEG is written to
`I:\PHOTO\…` afterward, doc pc-06); and C4FM-received pictures arrive on the **reverse** SCI-D path
into a different buffer (`0xFF9800`, filled by `EEPMOV` from `0xFF1489` at `0x055E0A`), never through
`0xFF5806`.

The "camera" is a USB host and the radio is the USB device, so a PC that opens `26AA:0001` and speaks
the four vendor requests can stand in for the camera (pc-06 §6). Either way the byte source is the USB
EP1 FIFO. This closes H14 Open #1.

## Method

- `I1_MAIN` seeded from the H8SX MAIN seed; `i1_push.py` dumped the driver region with per-line
  xrefs, listed every function in `0x054C00`–`0x056400` with its callers, and ran an xref census on
  the handler entries, the senders (`sub_B610` `0xB610`, `sub_B6B6` `0xB6B6`), and the state cells.
- Independent Python byte scans over the full 1 MB image for: the four buffer bases as BE32
  (immediate-load and abs32 forms), the state/length cells, and the USB register operands
  (`0xEE00`/`EE04`/`EE10`/`EE18`/`EE25`/`EE2C` in `@aa:16` form). The bulk loop, the D1/D2 handlers,
  and the forward selector were hand-decoded from raw bytes and cross-checked against the IDA
  disassembly.
- Cross-checked against prior docs 51 (H14, SUB side of the block transfer), 52 (H15, DSP driver),
  15 (CDC-ACM live/dead), and pc-06 (camera transport). Where pc-06 already traced a fact I
  re-verified the load-bearing bytes rather than restating.
- **Not done / Not found.** The USB SETUP/interrupt dispatch above the control machine (`sub_54D50`
  vector 234 etc.) was confirmed structurally (IFR-gated entry into the handlers) but not re-decoded
  instruction-by-instruction — doc 15 already did that. The `0x41 D3` status semantics and the
  `0xFF8184` camera-command values remain unknown (same residue pc-06 flagged).

## Findings

### 1. The driver, delimited (Confirmed)

The image-push driver is a contiguous set of functions in the normal-mode vendor USB stack. Full
bounds and callers in `driver-functions.txt`; the load-bearing ones:

| Func | Range | Role | Reached from |
| --- | --- | --- | --- |
| `sub_55034` | `0x055034`–`0x055116` | SETUP handler: copies the 8-byte packet to `0xFF3D6A`, dispatches vendor requests | USB ISR `sub_54D50` |
| `loc_5540C`…`0x0554E6` | in the dispatch | **`0x41 D1` start-of-image** / `0x41 D2` end / `0x41 D3` / `C1 D4` / `80 06` | SETUP handler |
| `sub_55652` | `0x055652`–`0x055684` | **EP1 bulk-OUT entry**: read EP1 byte count `0xFFEE25`, compute `dst = 0xFF5806 + index` | `0x055558`, `0x0556ce` (both IFR0-bit6 branches) |
| `sub_5568A` | `0x05568A`–`0x0556C8` | **the byte-copy loop + block-boundary forward** | falls through from `sub_55652` |
| `sub_55976` | `0x055976`–`0x0559F4` | forward selector: when index hits `0x100/0x200/0x300/0x400`, hand that 256-B sub-buffer to `sub_B610` | `0x05569a` |
| `sub_559F4` | `0x0559F4`–`0x055A24` | D2 end: send the final short block | `0x055612` (D2 handler) |
| `loc_55B28` | — | compute total block count → `0xFFBC42` | D1, reverse init |
| `sub_55CF8`/`sub_55D8C`/`sub_55DC6`/`sub_55DFC`/`sub_55EB2` | `0x055CF8`–`0x055F84` | **reverse / resend** path (SUB→MAIN readback into `0xFF9800`, retransmit) | IPC / `0x47B66` |
| `sub_B610` | `0x00B610` | build the `0xFFFF` image-block IPC frame | the 4 senders below |
| `sub_B6B6` | `0x00B6B6` | checksum + SCI-D DMA send to SUB | `sub_B610` and 10 other IPC builders |

Buffers (`buffers.tsv`): four 256-byte sub-buffers `0xFF5806 / 0xFF5906 / 0xFF5A06 / 0xFF5B06`, a
contiguous 1 KB window (`0xFF5806`–`0xFF5C05`) used as a quad-buffer. State/length cells in
`state-vars.tsv` (size `0xFFB098`/`0xFFBA46`/`0xFFBA6E`, index `0xFFBA6C`, block fields
`0xFFBC3E`/`40`/`42`/`44`, source pointer `0xFFBC48`, busy `0xFF2EC9`/`0xFF94C0`, abort `0xFFBA72`).

### 2. The writer = USB EP1 bulk-OUT (Confirmed, byte-verified)

Bulk entry and loop, `decrypted\…MAIN….bin` offsets = addresses:

```
055652  6a 04 ee 25     mov.b  @0xFFEE25,r4h     ; r4h = EP1 received byte count (EPSZ)
055656  58 70 00 66     beq    loc_556C0         ; nothing received -> re-arm & return
...
055670  6a 0c ba 72     mov.b  @0xFFBA72,r4l     ; abort/refuse flag
055674  58 60 00 40     bne    loc_556B8         ; set -> drain FIFO, discard
055678  6b 05 ba 6c     mov.w  @0xFFBA6C,r5      ; r5 = current write index
05567c  17 75           extu.l er5
05567e  7a 15 00 ff 58 06  add.l #0xFF5806,er5   ; dst = 0xFF5806 + index
055684  6a 0c ee 10     mov.b  @0xFFEE10,r4l     ; <-- read one byte from USB EP1 data reg (EPDR1)
055688  68 dc           mov.b  r4l,@er5          ; <-- store into the image buffer
05568a  0b 05           adds   #1,er5
05568c  1a 04           dec.b  r4h               ; count down
05568e  46 f4           bne    loc_55684         ; loop over the whole EP1 packet
055690  7a 35 00 ff 58 06  sub.l #0xFF5806,er5   ; index = dst - base
055696  6b 85 ba 6c     mov.w  r5,@0xFFBA6C      ; save new index
05569a  5e 05 59 76     jsr    sub_55976         ; forward completed 256-B block(s) to SUB
...
0556c0  fc 20           mov.b  #0x20,r4l
0556c2  6a 8c ee 2c     mov.b  r4l,@0xFFEE2C     ; re-arm EP1 (USB TRG/EP-control)
```

The entry is gated by IFR0 bit 6 at both call sites (`0x055552 mov.b @0xFFEE00,r4l / 0x055556 btst
#6 / 0x055558 bne sub_55652`, and the same at `0x0556c8`/`cc`/`ce`). `0xFFEE00`/`EE10`/`EE25`/`EE2C`
are the Renesas USB Function Module IFR0 / EPDR1 / EPSZ1 / EP-control registers (BRIEF correction 1).
**The store at `0x055688` is the only instruction in the whole image that writes the buffer window**;
`buffer-refs.tsv` lists all 12 references to the four bases and every other one is a pointer-set
(`0xFFBC48 <- base`) or a read-side source for the forward copy.

### 3. The forward path (Confirmed, matches H14 doc 51)

`sub_55976` (`sel.txt`) tests the index against `0x100/0x200/0x300/0x400`, selects the just-filled
256-B sub-buffer, writes the source pointer to `0xFFBC48` and the length `0x100` to `0xFFBC3E`, then
`jsr sub_B610` (`0x0559da`). `sub_B610` builds the `0xFFFF` frame (block#, total, running checksum)
and `sub_B6B6` checksums it and DMAs it over SCI-D to SUB, where H14 confirmed it lands in the JPEG
decoder input buffer `0x070E1000`. So the end-to-end path is:

```
USB host (camera / PC)  --EP1 bulk-OUT-->  EPDR1 0xFFEE10
   --byte loop 0x055684/0x055688-->  MAIN RAM 0xFF5806..0xFF5B06 (4x256)
   --sub_55976/sub_B610/sub_B6B6, SCI-D DMA, opcode 0xFFFF-->  SUB 0x070E1000 (JPEG decoder input)
   --JPEG decode-->  SUB framebuffer 0x070BB800 -> LCD;  on confirm -> microSD I:\PHOTO\*.jpg
```

### 4. What starts a transfer (Confirmed)

The USB vendor control request **`0x41 D1`** (bmRequestType `0x41` = vendor, host→device, interface;
bRequest `0xD1`) at `0x05540C`:

```
05540c  cmp.w #0x41D1,e2 ; bne ...
055414  mov.b @0xFF94C0,r4l ; bne refuse        ; global busy gate
05541e  btst #3,@0xFF89C1 ; ... btst #0,@0xFF89AB ; mode gates
055430  mov.b @0xFF2EC9,r4l ; bne refuse         ; transfer-in-progress gate
05543a  mov.b #0,@0xFFBA72                       ; clear abort
05543e..05545a  er4 = size(24b from SETUP 0xFF3D6C..6E) -> 0xFFB098, 0xFFBA46, 0xFFBA6E
055466  divxu.w #0x40 -> 0xFFB09C                ; 64-byte packet count
055476  mov.w #0,@0xFFBA6C                       ; reset write index
05547a  jsr sub_6F512 ; jsr sub_6A700            ; start a QSOPCTDIR index record (pc-06)
055496  mov.b #1,@0xFF8184 ; #8,@0xFF8183        ; camera command on EP0x83 int-IN
0554a0  jsr loc_55B28                            ; total blocks -> 0xFFBC42
0554a4  mov.l #0xFF5806,er4 ; -> 0xFFBC48        ; point the sender at buffer base
```

`0x41 D2` (`0x0555F4`) ends the image: `sub_559F4` sends the final partial block (`0x055a06 jsr
sub_B610`) and clears the busy flag. So a transfer is a host-initiated sequence: `41 D1`(size) →
stream JPEG on EP1 bulk-OUT → `41 D2`. The gating RAM flags are `0xFF94C0` (global busy), `0xFF2EC9`
(image in progress) and the `0xFF89C1`/`0xFF89AB` mode bits. `C1 D4` (`0x0552D8`) returns the quality
code and EP `0x83` interrupt-IN reports `[0xFF8184 cmd, 0xFF89CE, quality]` (pc-06 §1).

### 5. The four `sub_B610` callers, and why only (a) feeds the buffer (Confirmed)

`senders.tsv`. `sub_B610` has exactly four call sites (xref census):

- `0x0559da` (in `sub_55976`) and `0x055a06` (in `sub_559F4`) — the **forward push**; source
  `0xFFBC48` points into the USB-filled `0xFF5806` window. Live camera/USB path.
- `0x055d32` (in `sub_55CF8`) — **retransmit**; walks `0xFFBC48` in `0x100` steps to resend blocks
  (e.g. after SUB's `0xFFFE` checksum error). Source is still the `0xFF5806` window (pointer
  re-initialised to `0xFF5806` by `sub_55DC6` at `0x055dd4`).
- `0x055fde` (in `sub_55EB2`) — issues the `0xFE00` read-back request via `sub_B5CE`.

The **reverse** direction (SUB→MAIN, a stored/received picture coming back for transmit or re-save)
uses a *separate* buffer: `sub_55DFC` (`0x055DFC`) does `EEPMOV.W` of `0x118` words from the SCI-D
receive area `0xFF1489` into `0xFF9800` (`0x055E0A mov.l #0xFF9800,er5 ; 0x055E10 mov.l #0xFF1489,er6
; 0x055E16 eepmov.w`). That path never touches `0xFF5806`–`0xFF5B06`. This is also where
C4FM-received pictures and the picture-size cell `0xFFB208` live (pc-06 §5) — i.e. candidate (e)
reaches the *subsystem* but through the reverse buffer, not through the buffers in question.

### 6. Exclusion of the other candidates (Confirmed / Not found)

- **(e) C4FM-over-air / DSP link.** The DSP driver (doc 52) is a 32/96-byte half-duplex frame link on
  SCI-C `0xFFFF88`; its receive ring is `0xFF23C8`–`0xFF27C8` and its RX payloads land in
  `0xFEF920`-area 20/26-byte slots. No DSP RX handler references `0xFF5806`–`0xFF5B06` (not among the
  12 buffer references, all of which are in `0x0554xx`–`0x055Fxx`). C4FM-received pictures take the
  reverse SCI-D buffer `0xFF9800` (§5), not this one.
- **(b) DATA jack.** SCI-B `0xFFFF60` is the APRS/AX.25 packet modem (doc pc-06 §1); SCI-A is the
  host-link relay (doc 52 §5). Neither writes the buffer.
- **(d) microSD.** The SD/FatFs path is the *output*: after decode, SUB writes `I:\PHOTO\H…….jpg`
  from `0x070E1000` (pc-06 §3). It is a sink, not the source of `0xFF5806`.
- **CDC-ACM (second USB personality).** Lives in the copied `.data` stack (`0x076xxx`/`0x078xxx`,
  closed window) with its own queues `0xFF6288`/`0xFF62D8` (doc 15). It does not write `0xFF5806`,
  and it is reached only on a held-key power-on, so it is not the normal-mode feeder.

## USB relevance

- **Q1 (everything USB).** This is the one live USB data path outside the closed window, now traced
  end to end: USB vendor device `0x26AA:0x0001`, EP1 bulk-OUT 64-byte → PIO byte loop → MAIN RAM →
  SCI-D IPC `0xFFFF` → SUB JPEG decoder. The USB side is pure programmed I/O off EPDR1 (`0xFFEE10`),
  not DMA. Arm/finish is by vendor requests `0x41 D1`/`0x41 D2`; status/quality by `C1 D4` and EP
  `0x83`. A PC can drive it in place of the camera.
- **Q2 (USB SDR): still no, and this narrows it further.** The one USB bulk-IN-ish bulk path here is
  OUT only (host→radio image upload); it terminates in a JPEG framebuffer, and the transport is a
  byte-at-a-time EP1 read re-blocked to SCI speed. There is no sample source behind it and no path by
  which samples enter this buffer. The reverse direction is a stored-JPEG read-back, not a stream.
- **Q3 (DSP): unaffected.** This path does not touch the DSP; it confirms the DSP-adjacent
  C4FM-picture path is the *reverse* SCI-D buffer, separate from the USB-fed buffer.

## Open (most valuable first)

1. Decode the `0x41 D3` status table (`0x0FDC8` dispatch) and the `0xFF8184` camera-command values
   to fully specify the EP `0x83` interrupt-IN control channel (last residue of the camera protocol).
2. Pin `loc_55B28` arithmetic and the `0xFFBC52`/`0xFFBC53`/`0xFFBC54` reverse-path state machine so
   the SUB→MAIN read-back/retransmit contract is Confirmed rather than Inferred.
3. Trace the UI/menu action that enables the camera mode bits (`0xFF89C1` bit 3, `0xFF89AB` bit 0,
   `0xFF8184` writer `0x39462`/`0x393DC`) to tie "USB CAMERA" menu selection to the arm gate.

## Ledger

No coverage-number change. The entire driver (`0x05540C`–`0x055FFE`, `sub_B610`/`sub_B6B6`) is already
named/typed code in the `MAIN_H8SX` seed and counted in MAIN named/typed 497,139 / proven 365,570.
This lane attributes and byte-verifies existing code; it adds no new bytes, so there is no
`ledger-delta.tsv` for I1 and no addend changes against `ida\out\main-descent\ledger-delta.tsv`.

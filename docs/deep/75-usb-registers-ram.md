# 75 — The eight unnamed MAIN USB registers, and the owner of RAM 0xFF5C06-0xFF5C44 (lane J7)

Owner-side, strictly read-only static analysis of the ver 1.02 images already on disk. Nothing was written,
flashed, transmitted, or connected to any radio or device; no image byte was changed; no shared database was
opened. MAIN is H8SX, big-endian, base 0, so file offset = mapped address for every MAIN cite below. The
closed window 0x078106-0x07B753 was never decoded. Model: **claude-opus-4-8**.

Tables in `ida\out\usb-registers\`: `reg-access.tsv` (per-register access list), `reg-analysis.tsv`
(best-fit names + roles), `ram-owner.tsv` (0xFF5C06-0xFF5C44 owner analysis), and raw dumps in `work\`
(`reg-fullmap.txt` = every access to 0xFFEE00-0xFFEE53, `reg-context.txt`, `ranges.txt`, `ep1-loop.txt`,
`ram-neighborhood.txt`, `buffer-probe.txt`, `ram-names.txt`).

## Verdict

**Thread 1 — the eight registers.** All eight are write-only, write-once (or dead) sites with no live reader,
which is why they resisted naming. Three of them — **0xFFEE08 / 09 / 0A** — are written 0x00 / 0x07 / 0x1F in
one block immediately before IER0/1/2 (0xFFEE04/05/06) at USB init; they are the **Interrupt Select Registers
ISR0 / ISR1 / ISR2** of the Renesas USB Function Module (Inferred: a third 3-register triad that parallels the
IFR0/1/2 and IER0/1/2 triads, programmed once, never read). **0xFFEE2E, 0xFFEE2F, 0xFFEE44** are USB-module
control/aux registers zeroed once in the module-reset routine; the only non-zero touch of 0xFFEE2F is an 8→0
pulse in the **unreachable** tail of the vector-238 suspend/resume ISR (a would-be bus-resume / remote-wakeup
drive that never executes). **0xFFEE50, 0xFFEE51, 0xFFEE53 are not on the USB data path at all**: they are
written only by boot, by the NMI/standby handler (inside port-DDR init blocks), and by an SCI init routine
(bit-set next to the 0xFFF610 SCI registers) — port/clock/pin control bits that happen to sit in the top of the
0xFFEE page, not USB function-module registers.

**Thread 2 — RAM 0xFF5C06-0xFF5C44.** It is owned by nobody. There is no 32-bit immediate, no @aa:16 operand,
and no named object anywhere in MAIN that addresses this range (Confirmed by two independent whole-image scans
plus an IDA name scan). It is unallocated slack immediately above three tiled 1 KB buffers — 0xFF5006, 0xFF5406,
0xFF5806 — that end exactly at 0xFF5C05. The only code that can ever write it is the **USB EP1 bulk-OUT
byte-copy loop** (0x055684/0x055688), whose destination `0xFF5806 + index` can overrun up to 0xFF5C44 on a
misaligned image upload before the `cmp.w #0x400` wrap check fires. So the range is USB-adjacent only as the
63-byte overrun tail of the USB image buffer; it holds no structure and belongs to no subsystem.

## Method

One private DB, `J7_USBREG`, seeded `--copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64`, then `--reopen`
three times. Every pass exited 0; no traceback. Job script `ida\jobs\j7_usbreg.py` is read-only (no edits, no
auto-analysis beyond the inherited db; `auto_wait()`, try/except→`traceback.txt`, UTF-8, `qexit(0)`; it never
decodes inside the closed window).

- **IDA operand scan.** Decoded every code head in the image (skipping the window), and for every `o_mem` /
  `o_imm` operand recorded its value (masking the register page's 0xFFFFEExx sign-extension to 24-bit). This
  produced the complete 0xFFEE00-0xFFEE53 access map (`reg-fullmap.txt`) and the per-target lists.
- **IDA xref + context.** `XrefsTo` on each target IO address (0xFFFFEExx), plus a ±3-instruction context dump
  and targeted range disassembly of the init, reset, vector-238 ISR, boot, NMI and SCI routines (`ranges.txt`).
- **Independent Python byte scan** over `decrypted\FT3D_MAIN_ver102_EXP.bin` for every BE32 immediate forming
  an address in 0xFF5000-0xFF6100, and specifically in 0xFF5C06-0xFF5C44.
- **IDA named-object scan** of 0xFF5000-0xFF6100 (`ram-names.txt`: empty — no symbol in the whole region).
- The EP1 copy loop and its wrap bound were disassembled byte-for-byte (`ep1-loop.txt`).

**Not done / scope.** No analysis inside the closed window, so CDC-stack USB register use (0x0767FA-0x0770E8,
which also touches IER/IFR/TRG and the 0xFF6000 CDC buffers) is listed from outside only. Base-plus-displacement
reach into 0xFF5C06-0xFF5C44 from a register loaded elsewhere cannot be fully excluded by a static operand
scan, but the three source buffers are each ≤0x400 and tile up to 0xFF5C05, and the one demonstrated path into
the range is the EP1 loop's register-indirect store. The exact H8SX part datasheet is not in this package, so
the register names are Inferred, not read.

## Findings

### 1. 0xFFEE08 / 0xFFEE09 / 0xFFEE0A — Interrupt Select Registers ISR0/1/2 (Inferred)

`sub_54C44` is the USB interrupt-enable init. The relevant bytes (Confirmed, `ranges.txt`):

```
054c7c  fc 00            mov.b #0,   r4l
054c7e  6a 8c ee 08      mov.b r4l,  @0xFFEE08      ; ISR0 = 0x00
054c82  fc 07            mov.b #7,   r4l
054c84  6a 8c ee 09      mov.b r4l,  @0xFFEE09      ; ISR1 = 0x07
054c88  fc 1f            mov.b #0x1F, r4l
054c8a  6a 8c ee 0a      mov.b r4l,  @0xFFEE0A      ; ISR2 = 0x1F
054c8e  00 00  (x3 nop)
054c94  fc 8d            mov.b #0x8D, r4l
054c96  6a 8c ee 04      mov.b r4l,  @0xFFEE04      ; IER0 = 0x8D
054c9a  fc 03 ...        mov.b #3  -> @0xFFEE05     ; IER1 = 0x03
054ca0  fc 18 ...        mov.b #0x18 -> @0xFFEE06   ; IER2 = 0x18
054ca6  6a 18 ee 2d 70 20  bset #2, @0xFFEE2D       ; module enable
```

- Each of EE08/09/0A is written **exactly once** in the whole image (outside the window) and **read nowhere**.
- The register page already resolves as IFR0/1/2 = EE00/01/02 and IER0/1/2 = EE04/05/06 (I12 doc-64, BRIEF
  correction 1). EE08/09/0A are a third consecutive 3-register triad, one register per IFR/IER group, with a
  reserved byte between groups (EE03, EE07, EE0B). In the Renesas/Hitachi USB Function Module the triad that
  accompanies IFR and IER is the **Interrupt Select Register** group, which selects per source how/whether a
  flag raises an interrupt and is set once at init. That is the best structural fit. **Inferred** — the exact
  H8SX variant's datasheet is not in this package, so the identity is not provable from bytes; the behaviour
  (write-once, 0x00/0x07/0x1F, immediately before the three IER writes) is Confirmed.

### 2. 0xFFEE2E / 0xFFEE2F / 0xFFEE44 — module control/aux, reset-zeroed (Inferred)

`sub_54CAE` is the USB module reset/clear routine (called first thing by `sub_54C44`). It writes, in order,
FCLR0 (EE28=0x73), IFR0/1/2=0, EE2D (control)=0, **EE2E=0, EE2F=0**, EPSTL (EE2A)=0, **EE44=0**, then fills the
SETUP ring at 0xFF3C6A. So EE2E / EE2F / EE44 are USB-module registers cleared to 0 at reset. None has a live
reader or a live non-zero writer.

The one non-zero touch of **EE2F** is a pulse in the vector-238 (IFR2 b4 suspend/resume) ISR `sub_54CFA`:

```
054d1e  46 2c   bne loc_54D4C      ; both paths jump past the block
054d20  40 2a   bra loc_54D4C
054d22  fc 08 / 6a 8c ee 2f   mov.b #8 -> @0xFFEE2F   ; <-- 8
054d24..054d44  15x nop
054d46  fc 00 / 6a 8c ee 2f   mov.b #0 -> @0xFFEE2F   ; <-- 0
054d4c  pop / rte
```

The block at 054d22 is **unreachable** (the branch/bra at 054d1e/054d20 both skip it; I12 proved it dead by a
whole-image branch scan). It would drive EE2F bit 3 high for ~15 nop cycles then low — the shape of a USB
bus-resume / remote-wakeup K-state pulse issued from a suspend/resume handler. Best-fit for EE2F: a **USB
control register with a resume/wakeup drive bit (b3)**, Inferred; it is never executed in ver 1.02. EE2E and
EE44 are adjacent control/aux registers whose only access is the init zero; function not provable from bytes
(Inferred: USB-module control, reserved in this firmware).

### 3. 0xFFEE50 / 0xFFEE51 / 0xFFEE53 — not the USB data path (Inferred)

These three sit at the very top of the 0xFFEE page but are touched only by low-level hardware init, never by the
USB stack:

- **EE51 then EE50** in `sub_20FA` (the cold-boot/selector routine), embedded in a port-direction init block
  (writes to 0xFFFBA9, 0xFFFBB9, 0xFFFBA5, and the 8-bit-absolute port data regs @0xC0/C1/C2 = 0xFFFFC0..):
  `0022ba mov.b #0 -> @0xFFEE51 ; 0022c0 mov.b #0 -> @0xFFEE50`.
- **EE50** twice in `nmi_handler` (`sub_267C`), each time inside a long run of port-DDR writes
  (0xFFFB8A-8E, 0xFFFBA8/A9, 0xFFFBB4-B6) using the same source register — i.e. a "park all I/O pins" sequence
  for a standby/power event: `002748` and `0027fc mov.b r2l -> @0xFFEE50`.
- **EE53** in `sub_446BE`, an SCI init routine: `0446c4 bset #1, @0xFFEE53` interleaved with clears of the SCI
  registers at 0xFFF610/611/612 (SMR/BRR/SCR-class).

Because they are written only alongside I/O-port and SCI setup and are never read or written by any USB handler,
the honest best-fit is **not a USB Function Module register**: they are port/clock/pin control bits (an enable
or direction bit for a port in the 0xFFEE page, and for EE53 a module/pin enable for the 0xFFF610 SCI). They do
not fit the USBF data-path model, and I decline to force a USBF name onto them. **Inferred.**

### 4. Complete 0xFFEE00-0xFFEE53 access census (Confirmed)

`work\reg-fullmap.txt` lists every mem/imm access. Summary of the eight targets (`reg-access.tsv`):

| reg | accesses (outside window) | value(s) | site(s) |
| --- | --- | --- | --- |
| FFEE08 | 1 W | 0x00 | 054c7e (sub_54C44) |
| FFEE09 | 1 W | 0x07 | 054c84 (sub_54C44) |
| FFEE0A | 1 W | 0x1F | 054c8a (sub_54C44) |
| FFEE2E | 1 W | 0x00 | 054cca (sub_54CAE) |
| FFEE2F | 3 W | 0x00 init; 0x08→0x00 (dead) | 054cd0; 054d24/054d48 (dead) |
| FFEE44 | 1 W | 0x00 | 054cdc (sub_54CAE) |
| FFEE50 | 3 W | port-init value | 0022c0 (boot); 002748, 0027fc (NMI) |
| FFEE51 | 1 W | 0x00 | 0022ba (boot) |
| FFEE53 | 1 W | bset #1 | 0446c4 (SCI init) |

### 5. RAM 0xFF5C06-0xFF5C44 is unowned slack (Confirmed)

Three independent results agree:

1. **Python byte scan**, whole image outside the window: no BE32 immediate forms any address in 0xFF5C06-0xFF5C44.
2. **IDA operand scan**, every code head: no `o_mem`/`o_imm` operand in 0xFF5C06-0xFF5C44 (`ram-ff5c06.tsv` = NONE).
3. **IDA name scan**, 0xFF5000-0xFF6100: no named object anywhere in the region (`ram-names.txt` empty).

The RAM map around the image buffer (`ram-neighborhood.txt`, `buffer-probe.txt`):

```
0xFF5006  1KB  stored-picture / SD staging (sub_6EF20, EEPMOV source)   ends 0xFF5405
0xFF5406  1KB  picture/JPEG work buffer (#0x300 counts)                 ends 0xFF5805
0xFF5806  1KB  USB image-push quad-buffer (4x256, EP1 bulk-OUT landing) ends 0xFF5C05
0xFF5C06  ---  UNOWNED SLACK (no ref, no name) up to next object 0xFF6000 (CDC)
```

(The 0xFF5E01/0xFF5E03 "hits" my raw byte scan reported are false positives: they are the trailing bytes of
`and.l #0xFF` immediates, not address operands — the IDA operand scan does not see them.)

The sole path that can touch the slack is the USB EP1 copy loop (`ep1-loop.txt`), Confirmed byte-for-byte:

```
055678  mov.w @0xFFBA6C,r5     ; index
05567e  add.l #0xFF5806,er5    ; dst = base + index   (then @er5 store, register-indirect)
055684  mov.b @0xFFEE10,r4l    ; EPDR1 (USB EP1 bulk-OUT data)
055688  mov.b r4l,@er5         ; store one byte
05568e  bne   055684           ; loop over the EP1 packet
...
05569e  cmp.w #0x400,r5        ; wrap check happens AFTER the packet
0556a2  bcs   loc_556C0        ; index<0x400 re-arm; else wrap to 0
```

Because the 0x400 wrap is checked only after a full packet is copied, a misaligned upload that reaches index
0x3FF and then receives a 64-byte packet writes 0xFF5806+0x3FF .. +0x43E = up to **0xFF5C44** — the exact 63-byte
overrun I12 doc-64 §5 flagged. That is a bug consequence, not an owner. No reader of the slack exists.

## USB relevance

- **Q1 (everything USB).** The USB Function Module register map is now complete outside the window: the eight
  previously-unnamed registers are resolved to ISR0/1/2 (init-time interrupt select), three reset-zeroed
  control/aux registers (one with a dead resume-pulse), and three non-USB port/SCI control bits. No new live USB
  behaviour hides behind them — all eight are init/dead sites. The vendor personality's live register surface
  remains IFR0/1/2, IER0/1/2, EPDR0i/0o/0s/1/3, EPSZ0o/1, DASTS, FCLR, EPSTL, TRG, EPIR (I12 doc-64).
- **Q2 (USB SDR).** No change and no new capacity. None of the eight registers opens an IN data path; EE2F's
  only non-init use is dead. The RAM finding reinforces that the USB OUT buffer is a fixed 1 KB image staging
  area with nothing but guard slack above it — no sample buffer, no ring, no DMA target.
- **Q3 (DSP).** Unaffected. EE53 is a control bit for the 0xFFF610 SCI (not SCI-C/DSP at 0xFFFF88), and nothing
  here touches the DSP link.

## Open (most valuable first)

1. **Confirm ISR0/1/2 against a datasheet.** A hardware manual for the exact H8SX USB-function variant (register
   page at 0xFFEE00) would upgrade EE08/09/0A, EE2E, EE2F, EE44 from Inferred to Confirmed names. Pinning the
   part is the single remaining unlock.
2. **EE50/51/53 identity.** Trace the port/clock subsystem that owns 0xFFEE50-0xFFEE53 (they pattern with the
   0xFFFB8x port DDRs and the 0xFFF610 SCI). Likely a port or clock-control block aliased into the 0xFFEE page;
   decode the NMI/standby handler `sub_267C` to name the standby state they set.
3. **Guard the EP1 overrun (owner-side note only).** The 63-byte slack above 0xFF5806 absorbs a misaligned
   upload up to 0xFF5C44; a next pass could confirm nothing live is ever placed in 0xFF5C06-0xFF5FFF so the
   overrun is harmless, or flag it if a future build moves an object there.

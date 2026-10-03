# Boot, self-programming, and the MAIN/SUB inter-processor link

Agent BOOT-IPC. Static analysis of the two decrypted radio images only; no device,
serial, USB or flash access was performed. File offsets equal mapped addresses on
MAIN (base 0). Machine-readable tables under `ida\out\boot-ipc\` are named in-line.

## Verdict

The radio is three processors. **MAIN** (Hitachi/Renesas H8S,
`FT3D_MAIN_ver102_EXP.bin`) is the controller: RF path, persistent configuration,
the DSP/vocoder link, MAIN's on-chip USB, and the external DATA-jack serial port.
**SUB** (Renesas RX64M, `FT3D_SUB_ver102_ALL.bin`) is the display/UI + SD/GPS
processor. **DSP** is a third, external vocoder/baseband device not in this package.

**Neither application writes its own code flash** (re-confirmed; scope in Finding 2).
The only writer of code flash is the factory Renesas boot ROM, selected in silicon by
the DATA-jack program switch before any application code runs.

**The MAIN↔SUB link is one UART: MAIN SCI-D `0xFFF610` ↔ SUB SCI0 `0x0008A000`, ~500
kbaud, confirmed both directions.** MAIN→SUB is a checksummed 2-byte-opcode frame
protocol (families `0xF0xx`..`0xF8xx` + bulk `0xFC00`/`0xFD00`/`0xFE00`) built by
`sub_B6B6` and pushed by DMA ch0; it carries display/VFO/meter state, memory-channel
records, menu content, and the ~254-byte settings block. SUB→MAIN is a parsed byte
stream drained from ring `0xFF306A` by the consumer at `0x47560` (byte state machine
at `0xFF9D2D`).

**Correction to `06-dsp-vocoder.md`:** SCI-A `0xFFFE90` is the **external DATA-jack
CAT/clone/debug port, not the inter-processor link.** Its RX ISR `sub_45462` routes
bytes by flag `0xFF817F.7` to the CAT interpreter `sub_06B77E` (`0xFF27C8` ring) or
to the PC↔module pass-through (`0xFF95F8`); its TX side emits the DSP debug trace
(`sub_453A0`) and the `AH72M`/`0x5A`/`0x5B` **ID/version responses** (`sub_738CC`,
writing TDR `0xFFFE93`). Those version messages go **out the data jack**, not to SUB;
SUB gets its DSP-version digit over SCI-D.

**Headline result — the DSP is field-reprogrammable over MAIN's USB, and this
resolves the project's #1 open conflict (is the CDC-ACM USB personality live or
dead?) in favour of LIVE.** Holding one keypad key at power-on pulls bit 1 of the
key-scan input `0xFFFF4C` low (port reads `0x7D`; `sub_100E4` decodes it as internal
key code `0x11`). Boot (`sub_20FA`) then sets the flag `0xFF813A = 1`, and that single
flag is read by **both** the USB interrupt handler `sub_54D50` (to present the second
USB personality) **and** the DSP SCI ISR `sub_5615C` (to enter bridge mode) and the
mode handler at `0x101B2` (to enter DSP-WRITE mode). In that mode an 8-state loader
(`sub_5DCFE`) pulses the DSP's reset and boot-mode lines on port `0xFFFF52`,
reconfigures the DSP's SCI to asynchronous, and a queue engine streams firmware bytes
between the **on-chip USB Function Module** (`0xFFEE00` status / EPDR `0xFFEE2C`) and
the DSP's serial port (`0xFFFF88`). So MAIN's alternate (CDC-ACM) USB personality is
**not dead vendor-library data — it is the transport for DSP WRITE MODE.** The stock
radio still cannot be made to send arbitrary voice frames to the DSP over USB (that
path is a byte relay into the DSP's own loader, gated by the reset/boot lines), and
entering the mode is a hardware key-hold decision, not a command.

## Method

- Two private IDA 9.1 databases seeded with `run_job.py --copy-from`: `BOOT_IPC_MAIN`
  (H8S, from `ida\db\radio\MAIN.i64`, 1298 funcs) and `BOOT_IPC_SUB` (RX64M, from
  `SUB.i64`, 455 funcs). Job scripts: `ida\jobs\boot_map.py`, `boot_probe.py`, and new
  `ida\jobs\boot_close.py` (side-aware function/xref/range dumper; env-overridable via
  `BOOT_FUNCS`/`BOOT_XREFS`/`BOOT_RANGES`/`BOOT_OUT`).
- Note for re-runs: the workspace was relocated to the repository root, so the
  shared `ida\run_job.py` (which hardcodes `ROOT = .`) can no longer find the
  job DBs. I ran through a private copy with the corrected root
  (`scratchpad\run_job_fixed.py`); I did **not** modify the shared launcher. A future
  pass should either use that copy or fix `ROOT` in `run_job.py` to derive from
  `__file__`.
- Byte/operand ground truth from `BOOT_IPC_MAIN_regops.tsv` (register/RAM operand
  census) plus targeted disassembly (`BOOT_IPC_MAIN_close.txt`, `_close2.txt`,
  `BOOT_IPC_SUB_close.txt`).
- Coverage: MAIN 1298 funcs, SUB 455 funcs. Negative flash results are corroborated
  at byte level so they hold whole-image. The SUB-side high-level frame parser (the
  consumer that dispatches MAIN→SUB opcodes and lands the settings block) was not
  isolated; the SUB physical driver and settings-apply were.

## Findings

### 1. Startup (both confirmed; unchanged from prior pass)

MAIN reset `0x2092` → `sub_20FA` (hardware init: SFR setup, BSS zero-fill
`0xFEE000..0xFF7300`, `.data` copy `0x4AE` bytes ROM `0x7B2A6`→RAM `0xFF6034`, SCI-D
init `sub_446BE`, the `0xFFFF4C` strap poll) → `sub_20D8` peer handshake → app main
`loc_DC5A`. SUB reset `0xFFC00000` → `mvtc` USP/ISP/EXTB/INTB/FPSW → `_INITSCT`
`sub_FFF45DBC` → app main `sub_FFF36C53`. SUB INTB `0xFFED8A70`: 17 real handlers
(SCI0/2/3 RXI+TXI, SCI-error GROUPBL0, SDHI, CMT timers), rest a shared RTE stub.

### 2. Self-programming — NONE for either application (re-confirmed)

SUB (RX64M): no FCU/FACI/FENTRYR/FSTATR/FWEPROR/FCU-RAM reference anywhere in 4 MB
(byte + operand level). MAIN (H8S): no write to FKEY `0xFFFFCC` / FMATS `0xFFFFCD` and
no FCCS P/E sequence in the register-page operand census. Code-flash writing is the
boot ROM's job, entered by the reset-time mode pins the program switch drives.
Persistence lives off SUB entirely; MAIN owns the config (memory-mapped
`0xFF8000..0xFFBFFF`, which reset does not zero) and ships the settings block to SUB.

### 3. Ports behind the boot strap and the DSP — `0xFFFF4C` and `0xFFFF52` (table `ports_4C_52.tsv`)

**`0xFFFF4C` is a keypad-matrix return column, input-only, active-low.** It is read in
exactly two places — the boot strap `sub_20FA` (`0x2200`) and the key scanner
`sub_100E4` (`0x100F8`) — and is never written anywhere in the image. `sub_100E4`
(`0x100E4`) masks bit 7 and decodes one-bit-low patterns to internal key codes:

```
0x7F=no key   0x7E->0x0E   0x7D->0x11   0x7B->0x0A   0x77->0x0F
0x6F->0x0D    0x5F->0x0C   0x3F->0x12
```

So each of bits 0..6 is one physical key. The bridge/DSP-write strap is **the key on
bit 1** (`(x&0x7F)==0x7D`, internal code `0x11`) held at power-on. The exact silkscreen
label is Unknown from this package (no keypad map/schematic), but the electrical role
— a held keypad key — is Confirmed. Other boot straps read the same way:
`0xFFFF40` bit 7 (`0x239C`) and `0xFFFF45` bit 2 (`0x23BA`) set model/band bits in
`0xFF8170`.

**`0xFFFF52` is the DSP control output port** (DDR `0xFFFB82` init `0xBF` → bits 0-5,7
output, bit 6 input; data init `0xA0`). Bit functions, each proven by the DSP power-on
(`sub_564B2`/`sub_564FA`), the loader (`sub_5DCFE`), and the shutdown `sub_56056`
(which clears exactly bits 0-4):

| bit | function | evidence |
| --- | --- | --- |
| 0 | DSP power/enable | `sub_5DCDA` `0x5DCE6` bset; `sub_56056` bclr |
| 1 | DSP direction/strobe | `sub_4834E` `0x483C6` bclr (per-frame); `sub_56056` bclr |
| 2 | DSP control | `sub_564FA` `0x5650A` bset; `sub_56056` bclr |
| 3 | **DSP RESET** (assert/release) | `sub_5DCFE` `0x5DD62` bset / `0x5DD76` bclr |
| 4 | **DSP BOOT-MODE** (held during load) | `sub_5DCFE` `0x5DD50` bset / `0x5DDD4` bclr |
| 5 | non-DSP peripheral | `sub_2F400`/`sub_30F00` bset; not touched by DSP shutdown |
| 6 | input | DDR bit6 = 0 |
| 7 | non-DSP strobe/latch | `bst #7` in `reset_handler`, `sub_30E0`, `sub_3EA28` |

The DSP handshake/ready input is **`0xFFFF49` bit 7**, polled only by the loader
(`0x5DDAE`, `0x5DDBE`).

### 4. DSP loader / DSP-WRITE state machine — `sub_5DCFE` (table `dsp_loader_states.tsv`)

`sub_5DCFE` (`0x5DCFE`) is a per-tick FSM on state byte `0xFFB0C4` (0..7), ticked from
`reset_handler` (`0x2CE6`/`0x38FC`/`0x3A4A`) and started by `sub_5DCDA`. It is entered
from the strap/UI path `0x101B2 → sub_103C0` (`0x103C0`, which pushes UI mode `0xEE`
and clears `0xFFB0C4`). Fully decoded:

| state | action |
| --- | --- |
| 0→1 | `sub_5DCDA`: `bset #0 @0xFFFF52` (assert DSP power); timer `0xFF9552=0x0A` |
| 1→2 | timer 0 → `bset #3 @0xFFFF52` (assert **RESET**); timer `0xFF9552=3` |
| 2→3 | timer 0 → `bclr #3 @0xFFFF52` (release RESET); timer `0xFF9554=0x0A` |
| 3→4 | timer 0 → `jsr sub_78222` (DSP SCI `0xFFFF88` → **async**: SMR `0x08`, BRR `0x0C`, SCR `0x70`) |
| 4→5 | wait `0xFFFF49` bit7 == 0, then `bset #3 @0xFFFBA4` |
| 5→6 | wait `0xFFFF49` bit7 == 1, then timer `0xFF9554=0x0B` |
| 6→7 | timer 0 → `bclr #4 @0xFFFF52` (release **BOOT-MODE**); post `0x16`→`0xFFAAE0` (UI "complete") |
| 5,6,7 | each tick calls `loc_7815C` — the **queue-engine pump** that streams firmware bytes |

So the loader resets the DSP, holds it in boot mode, switches the link to async, waits
for a two-edge handshake on `0xFFFF49.7`, then streams the image and releases boot
mode. Progress `(phase,progress)` for the SUB screen is computed by `sub_5E9E2`
(`0x5E9E2`) and pushed via `sub_8532` into the shared status block at SUB `0x8C4D+0x20/
+0x21`. Shutdown `sub_56056` clears all of `0xFFFF52` bits 0-4.

**The byte relay (queue engine, `0x76800`-`0x78560`).** `loc_7815C` (`0x7815C`) walks
the control block at `0xFF6288` (init by `loc_78508`: staging `0xFEE008`/`0xFEE010`,
DSP-RX buffer `0xFF62C8`, second block `0xFF62D8`). Its endpoints:

- **USB side:** `0x78192` tests **`0xFFEE00` bit 4** (USB Function Module status) and
  writes a queued byte to **EPDR `0xFFEE2C`**; `sub_768A8` moves `0xFF6354`/`0xFF62C8`
  against the USB endpoint. Started by `loc_78106`, called from `sub_20FA` `0x2234`
  only when the strap set `0xFF813A=1`.
- **DSP side:** TX is the polled loop `0x7701E` (wait SSR `0xFFFF8C.7`, write TDR
  `0xFFFF8B`); RX is the bridge branch of the DSP SCI ISR `sub_5615C` (`0x561B0 → loc_7711E`,
  reading RDR `0xFFFF8D`, enqueue to `0xFF62C8`).

That is the DSP firmware-download data path: **USB host (CDC-ACM) ↔ USB module
`0xFFEE00`/`0xFFEE2C` ↔ queue `0xFF6288` ↔ DSP async serial `0xFFFF88`.** There is no
DSP image or DSP filename in either plaintext image (matching `06`), so the image
arrives over this wire while the radio is in DSP-WRITE mode.

### 5. The MAIN↔SUB link — SCI-D `0xFFF610`, confirmed both directions (tables `serial_channels.tsv`, `ipc_frames.tsv`, `ipc_commands.tsv`, `opcodes_main_to_sub.tsv`)

- **Physical.** MAIN SCI-D `0xFFF610` (TDR `0xFFF613`), async, BRR=0 → ~500 kbaud
  (φ16 MHz/32). TX by **DMAC ch0** (`sub_482D4`: MAR=buffer, DAR=`0xFFF613`, trigger
  `0xFFFD20=0xE1`, then SCR.TIE). RX by ISR **`sub_44A70`** (vec 224) into 3 KB ring
  **`0xFF306A..0xFF3C6A`**. Init `sub_446BE`. SUB end = **SCI0 `0x0008A000`**, opened by
  `sub_FFEDAB4C` via the generic ring driver (channel table `0x12CD8`, RX/TX callbacks
  `sub_FFEDB131`/`sub_FFEDB081`); baud config `0xFFC3EB44` = high-speed matching ~500k.
- **MAIN→SUB frame** (`sub_B6B6` `0xB6B6`): `opcode(2 BE)` + `len(2)=total-10` +
  `hdr_cksum(2)` + payload + `frame_cksum(2)` + six `0x00` pad. De-duplicated against
  the last frame at `0xFF4176`. **124 distinct opcodes** harvested
  (`opcodes_main_to_sub.tsv`), grouped by high byte: F0xx status/VFO (12), F1xx (16),
  F3xx display/menu (36, largest), F5xx (13), F6xx memory-channel records (10, e.g.
  `0xF630` `sub_AE3C` 104-byte record from table `0xC540`), F8xx (13), plus bulk
  `0xFC00` (`sub_D53A`, variable length via payload filler `sub_71196`) — the bulk
  class is the carrier for the ~254-byte settings/memory block.
- **SUB→MAIN**: byte stream received into ring `0xFF306A`, drained by the consumer at
  **`0x47560`** (reads `0xFF8142` read-ptr vs `0xFF8148` write-ptr; per-byte state
  machine on `0xFF9D2D`, value accumulator `0xFF9D2A`). Carries user input / acks.
- **Settings block** lands on SUB as the "pending" copy at **`0x8E46`** and is applied
  field-by-field to the shadow **`0x8C4D`** by `sub_FFEF4142` (`0xFFEF4142`), which
  calls `sub_FFEEFEA4(1)` on each changed field. That shadow is where the version
  digits (`+0x27..+0x29`) and the RAM-DISPLAY / market flags live — so the settings bit
  that reaches SUB does so over this SCI-D link.

**Channel resolution (which SCI is which on MAIN):**

| base | vec | role | proof |
| --- | --- | --- | --- |
| `0xFFF610` | 224 | **MAIN↔SUB** (0xF0xx frames + SUB byte stream) | `sub_B6B6`→DMA ch0→`0xFFF613`; consumer `0x47560` |
| `0xFFFE90` | 160/161 | **external DATA jack** (CAT/clone/debug) | `sub_06B77E` interp; `sub_738CC` ID/version; `sub_453A0` DSP trace |
| `0xFFFF60` | 152 | on-board module UART (BT/GPS) | `sub_45520` → ring `0xFF1AC8` |
| `0xFFFF88` | 148 | **DSP** (sync normally; async in DSP-WRITE) | `sub_04834E` DMA ch1; `sub_78222` async |

### 6. The external DATA-jack port — SCI-A `0xFFFE90` (not the SUB link)

`sub_45462` (RXI) routes received bytes by flag `0xFF817F.7`: clear → ring `0xFF27C8`
(consumed by the CAT interpreter `sub_06B77E`, LF/EOT-terminated, additive checksum
`0xFFB3DC`, with a software-reset `jmp loc_2050` and a DMA RAM-dump from `0xFEE000`);
set → ring `0xFF95F8` (PC↔module pass-through). `sub_45406` (TXI) drains ring
`0xFF29C8`. The DSP debug trace (`CPU>DSP:`/`DSP>CPU:` strings) is emitted here by
`sub_453A0`, gated by `0xFF8C26.7` / trace-mode `0xFF8C28`. The `0xFF96F8` "messages"
(`0x5A` DSP ver, `0x5B` MAIN ver, `0x32`, `AH72M` unit ID) are transmitted here by
`sub_738CC` (poll SSR `0xFFFE94`, write TDR `0xFFFE93`, additive checksum) — i.e. they
are the radio's **CAT/clone identify+version responses to a PC**, which is why
`06-dsp-vocoder.md` mistook this channel for the inter-processor link when it traced
the DSP version outward.

## USB relevance (three mission questions)

1. **Everything USB.** New, high-value: MAIN's **alternate USB personality is live and
   is the DSP firmware-download transport.** The queue engine actively polls USB status
   `0xFFEE00.4` and writes EPDR `0xFFEE2C` (Finding 4), and it is started by the same
   `0xFFFF4C` key-strap that flips `0xFF813A`, which `sub_54D50` (the USB ISR) reads to
   pick the second personality. This corroborates MAIN-IO's "CDC-ACM is live" over
   DSP-AMBE's "dead vendor data," and supplies the mechanism and purpose. The external
   application-visible control API is the DATA-jack UART `sub_06B77E` (SCI-A), not USB.
2. **USB SDR.** Unchanged "no": the MAIN↔SUB, DSP, and DATA-jack links are all
   control/voice-frame or byte-relay UARTs, not IQ paths; SUB never touches USB0. The
   DSP-write USB bridge moves opaque loader bytes, not samples.
3. **Reach the DSP.** The DSP is reprogrammable through MAIN over USB in DSP-WRITE mode
   (Finding 4), but only as a byte relay into the DSP's own loader while its reset/boot
   lines are held (`0xFFFF52` bits 3/4); the framed voice protocol is not exposed to
   any external port on a stock radio. Entering the mode is a hardware key-hold.

## Hand-offs

- **MAIN-IO / HOST-USB:** the CDC-ACM (2nd) USB personality is **live** — it is the
  DSP-WRITE transport. Selector `0xFF813A` (strap `0xFFFF4C`==`0x7D`, key code `0x11`)
  is read by the USB ISR `sub_54D50` *and* starts the USB↔DSP queue engine
  (`loc_78106`, control block `0xFF6288`, endpoint `0xFFEE00`/`0xFFEE2C`). The
  "peripheral block at `0xFFEE00`" that DSP-AMBE could not identify **is** the USB
  Function Module. The external CAT interpreter `sub_06B77E` and the ID/version
  responder `sub_738CC` are on SCI-A `0xFFFE90` (data jack), the RAM-dump/soft-reset
  API of `10-host-usb-protocol.md` item 2.
- **DSP-AMBE:** `0xFFFE90` is the **external data jack, not the inter-processor link**;
  the `0x5A`/`0x5B` version messages you traced go out the jack. SUB's DSP-version digit
  arrives over SCI-D. The loader `sub_5DCFE` states 5-7 are the async firmware stream
  (queue `0xFF6288` ↔ USB), handshake `0xFFFF49.7`, completion marker `0x16→0xFFAAE0`.
- **MENU:** the ~254-byte settings block travels MAIN→SUB over SCI-D and is applied by
  SUB `sub_FFEF4142` (`0x8E46` pending → `0x8C4D` shadow, field-by-field).

## Open (most valuable first)

1. **Confirm the exact SCI-D opcode that carries the ~254-byte settings block to SUB**
   (candidate `0xFC00`/`sub_D53A` via `sub_71196`) and map its offsets to settings,
   including RAM-DISPLAY. Pair with the SUB-side frame parser that lands `0x8E46`.
2. **Enumerate the SUB→MAIN opcode set** by reversing the ring-`0xFF306A` consumer at
   `0x47560` (state machine `0xFF9D2D`) and the SUB SCI0 RX consumer.
3. **Name the physical keypad key** on `0xFFFF4C` bit 1 (code `0x11`) — needs the
   keypad-matrix map (MAIN-IO's port/DDR work), to turn "a held key" into a label.
4. **Decode the DSP async loader handshake** on the wire: the byte protocol the DSP's
   own boot loader speaks during `sub_5DCFE` states 5-7 (queue contents, `0xFFFF49.7`
   edges).

## Resume here

- Databases: `BOOT_IPC_MAIN`, `BOOT_IPC_SUB` (under `ida\db\jobs\`), resume with
  `--reopen`. Scripts: `ida\jobs\boot_map.py`, `boot_probe.py`, `boot_close.py`
  (side-aware; env `BOOT_FUNCS`/`BOOT_XREFS`/`BOOT_RANGES`/`BOOT_OUT`).
- **Launcher caveat:** run through `scratchpad\run_job_fixed.py` (ROOT corrected to
  the repository root) or fix `ROOT` in the shared `ida\run_job.py`.
- Output tables in `ida\out\boot-ipc\`: `serial_channels.tsv`, `ipc_frames.tsv`,
  `ipc_commands.tsv`, `opcodes_main_to_sub.tsv`, **`dsp_loader_states.tsv`** (new),
  **`ports_4C_52.tsv`** (new). Raw disassembly: `BOOT_IPC_MAIN_close.txt`,
  `_close2.txt`, `BOOT_IPC_SUB_close.txt`, plus the earlier `_boot/_dsp/_links/_frame/
  _cmds/_txcallers/_regops` dumps.

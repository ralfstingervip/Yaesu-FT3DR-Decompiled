# MAIN SCI-C byte pump — who uses it, and can anything outside the service window reach it

> Lane H4. Private DB `H4_PUMP` (`ida\db\jobs\H4_PUMP\H4_PUMP.i64`), seeded
> `--copy-from ida\db\jobs\G1_H8S\G1_H8S.i64` (H8SX `h8sxa`, the fully-decoded module). No other
> database was opened; nothing was written to a radio; no image was modified. Job scripts
> `ida\jobs\h4_pump.py`, `ida\jobs\h4_prologue.py`. Machine tables `ida\out\sci-c-pump\callers.tsv`,
> `routines.tsv`, raw dumps in `ida\out\sci-c-pump\work\`. Image `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (base 0, file offset = address). Model: claude-opus-5-5 (Claude Opus 5.5).
>
> PROJECT BOUNDARY respected: the CDC-ACM / DSP-download window `0x078106`–`0x07B753` is CLOSED. Its
> contents were not disassembled or decoded. Where a call/reference crosses that boundary only the edge
> address is stated.

## Verdict

**The SCI-C byte pump is not reachable from the normal runtime UI or from any USB-host request handled in
normal operation.** The pump is one function, `0x076FC8`–`0x07711E`, and it has **exactly one caller in the
whole image: `0x0781C0`, which is inside the closed service window** (Confirmed: IDA xref set = one
`call` from `0x0781C0`; 0 BE32 pointer-table references anywhere in the 1 MB image). There is no direct
`jsr`/`bsr`, no pointer-array entry, and no indirect-dispatch edge to the pump from any code outside the
window. The window itself is entered from ordinary firmware at only **four gated edges**, every one of them
guarded by either the boot-time bridge strap (`0xFF813A`, set only at reset when the held-line condition
`0xFFFF4C & 0x7F == 0x7D` is met) or the DSP-WRITE-MODE state machine `sub_5DD00`. The receive half of the
same transport, the bridge handler `0x07711E`, is reached only from the SCI-C interrupt's bridge branch,
which the ISR takes only when that same `0xFF813A` flag is set. So the pump is the transmit half of a
boot-strap / service-mode transport, mutually exclusive with normal operation — consistent with G1's
"DSP-download transport" inference, now pinned to its single caller. The pump rides the **same physical
SCI-C** (`0xFFFF88`) as the runtime DSP frame driver of doc 06, but is a **separate software path**: the
same SCI is reconfigured from clocked-synchronous DMA framing to async 8-N-2 polled bytes, and the ISR
and TX routines are swapped by the `0xFF813A` flag. Of the four module routines G1 flagged as
unreferenced, three (`0x07801C`, `0x0773E8`, `0x0779C4`) are **genuinely dead** (0 code xrefs, 0 pointer
refs — orphan USB-library code, and `0773E8`/`0779C4` are a byte-identical pair); the fourth, `0x076B4E`,
is **not** unreferenced — it is a live intra-module branch target (`0x076B2A` → `0x076B4E`). `0x056450`'s
P3DR-bit-0 test lives in the scheduler-driven dispatcher, not in the pump path; the DSP reset/boot line
`0xFFFF52` is driven entirely by the DSP driver (`0x056xxx`) and the DSP-WRITE-MODE machine
(`sub_5DD00`), never by the pump or the module.

## Method

All through `ida\run_job.py --db H4_PUMP`.

1. Raw BE32 scan of the whole image for pointer-table references to every candidate address
   (`local-temp`, `ptr.py`): base 0, so a 4-byte big-endian pointer equal to the address.
2. Raw scan for every `jsr @aa:24` (`5E`) and `jmp @aa:24` (`5A`) whose 24-bit target lands in
   `0x075000`–`0x07C000` (`jsrscan.py`) — the complete direct-call edge map for the module and the
   window boundary.
3. `h4_pump.py` on H4_PUMP (seeded from G1_H8S, so the H8SX module is fully decoded): authoritative
   function bounds and IDA xref sets for every probe address; a recursive upward call-tree walker
   (code xrefs, depth 6) from the pump, the bridge handler, the four routines, `0x056450`, `sub_5DD00`
   and `sub_103C0`; annotated disassembly of the pump, the four routines, the P3DR test and the SCI-C
   ISR; a function table for `0x075F36`–`0x078105` (`modfuncs.tsv`); and every code xref whose target
   is in the module or crosses the window boundary (`xrefs.tsv`).
4. `h4_prologue.py` (reopen): the pump prologue `0x076FC8`–`0x077018` for the argument/register setup.
5. Raw scan for every bit-op and byte access on P3DR `0xFFFF52` across the whole image (`p3dr.py`),
   decoded (bit# = operand nibble; `7F`=write bset/bnot/bclr, `7E`=read btst).

Scope not covered: the closed window `0x078106`–`0x07B753` was never disassembled; its internal control
flow (e.g. what inside it decides to call `0x0781C0`) is out of scope by the project boundary, so the
claim "pump reachable only through the window" is stated at the boundary, not inside it.

## Findings

### 1. The pump: boundaries, arguments, SCI-C accesses (Confirmed)

Function **`0x076FC8`–`0x07711E`** (342 B), the routine containing `0x077018`. Prologue
(`work\prologue.txt`):

```
076FC8  01 30 6D F2        stm.l  er2-er5,@-sp        ; callee-saves er2..er6
076FCC  01 00 6D F6        push.l er6
076FD0  0F 83              mov.l  er0,er3             ; ER0 = the one argument: a channel control block -> ER3
076FD2  7A 06 00 FF 62 88  mov.l  #0xFF6288,er6       ; ER6 = fixed global queue-engine block 0xFF6288
076FD8  01 00 6F 60 00 50  mov.l  @(0x50,er6),er0     ; ring head/tail/wrap fields of 0xFF6288 ...
  ...   (computes pending-byte count into e2)
077008  79 2A 00 40        cmp.w  #0x40,e2            ; clamp length to 0x40 = 64 = one FS bulk packet
07700C  43 04              bls    .+4
07700E  79 0A 00 40        mov.w  #0x40,e2
```

Transmit inner loop `0x077018`–`0x07704A` (Confirmed SCI-C bytes):

```
077018  01 01 69 31        mov.l  @(4,er3),er1        ; read ptr in caller's control block
07701C  68 10              mov.b  @er1,r0h            ; next byte
07701E  29 8C              mov.b  @0xFFFF8C,r1l       ; SCI-C SSR
077020  4A FC              bpl    0x07701E            ; wait TDRE (bit7)
077022  30 8B              mov.b  r0h,@0xFFFF8B       ; SCI-C TDR
077024  7F 8C 72 70        bclr   #7,@0xFFFF8C        ; clear TDRE
  ...   advance/wrap @(4,er3) against base @(8,er3) and limit @(0xC,er3); loop up to 64 bytes
```

Tail `0x07704C`–`0x07711C`: reads a busy flag `0xFF6240`, computes free space in the `0xFF6288` ring,
and on a low-water condition **re-arms the USB side**: `0x07709E 6A 18 EE 04 70 60 bset #6,@0xFFEE04`
(USB IER0 bit 6), reads IER0/1/2 `0xFFEE04`/`05`/`06`, assembles a 32-bit word with
`or.l #0x82000`, and stores it to `0xFF62F8` (`0x077110`). So the pump is a **USB-OUT → SCI-C
forwarder with host flow control**: it drains host bytes from the `0xFF6288` queue to the DSP serial
port 64 at a time and re-enables the USB bulk-OUT endpoint interrupt when the queue has room.

- Argument: **ER0** = per-channel control block (ring with read-ptr `+4`, base `+8`, limit `+0xC`).
  **ER6** fixed at `0xFF6288` (the generic queue-engine block of doc 06). Returns via `rts/l er2-er5`
  (`0x07711C`), i.e. restores the pushed set.
- A **single-byte polled TX variant** sits at `0x0771D6`–`0x0771E0` (`20 8C` SSR / `4A FC` wait /
  `38 8B` TDR / `7F 8C 72 70` clear), same SCI-C registers; no caller found (likely dead).

### 2. Same SCI-C as the runtime DSP driver, separate software path (Confirmed)

The pump and doc 06's frame driver use the **same SCI-C block** — TDR `0xFFFF8B`, SSR `0xFFFF8C`, SCR
`0xFFFF8A`. They are two mutually-exclusive drivers selected by the bridge flag `0xFF813A`:

| | Normal runtime (doc 06) | Pump / bridge path (this lane) |
| --- | --- | --- |
| SCI-C mode | clocked-synchronous, DMA (SMR `0x80`) | async 8-N-2 (SMR `0x08`, BRR `0x0C`), reconfigured by window helper `0x078222` called at `0x05DD9E` |
| TX | DMAC ch1 `0xFFFC20`→`0xFFFF8B`, 32/96-B frame | polled pump `0x076FC8` (≤64 B/call), no DMA |
| RX | ISR `sub_5615C` normal branch → ring `0xFF23C8` | ISR `sub_5615C` bridge branch → `jsr 0x07711E` |
| selector | `0xFF813A == 0` | `0xFF813A != 0` |

The SCI-C ISR `sub_5615C` (`0x05615C`–`0x0561C2`, INTB vector slots 148/149 at `0x250`/`0x254`) decides
at `0x056160 6A 0C 81 3A mov.b @0xFF813A,r4l` / `0x056164 bne 0x0561A8`: flag clear → normal frame RX;
flag set → `0x0561B0 5E 07 71 1E jsr 0x07711E` (the bridge RX handler). Confirmed bytes.

### 3. The call tree upward — every path outside the window

Direct-edge map (`work\xrefs.tsv`, `jsrscan.py`). The pump's **only** caller:

```
0x0781C0 (WINDOW)  --call-->  0x076FC8 (pump)     [sole caller; walk-up stays entirely in the window]
```

The window `0x078106`–`0x07B753` is entered from ordinary firmware (code neither in the window nor in the
`0x075F36`–`0x078105` module) at exactly **four edges**, each gated:

| Edge | From | Gate |
| --- | --- | --- |
| `0x002234` → `0x078106` | reset init `sub_20FA`, branch `loc_221E` | taken only if `0xFFFF4C & 0x7F == 0x7D` held at power-on (boot strap) → sets `0xFF813A=1` |
| `0x054EB0` → `0x07827C` | USB ISR `sub_54D50` | taken only if `0xFF813A != 0` |
| `0x05DD12` → `0x07815C` | DSP-WRITE state machine `sub_5DD00` (state ≥ 5) | DSP-WRITE MODE only |
| `0x05DD9E` → `0x078222` | `sub_5DD00` (SCI-C → async) | DSP-WRITE MODE only |

`sub_5DD00` is scheduler-driven and entered through mode code `0xEE` (`sub_103C0`, doc 06). The module
itself calls many window helpers (`0x078334`, `0x07837C`, `0x0783DA`, `0x078442`, `0x078508`, `0x07821E`,
`0x07823C`) and the window calls two module routines (`0x0768A8`, and the pump `0x076FC8`) — module and
window are one coupled unit, the CDC-ACM / DSP-download service. No runtime-UI menu action and no
normally-handled USB control request appears anywhere on these paths.

The receive-side handler `0x07711E` has one caller, `0x0561B0` (the SCI-C ISR bridge branch), itself
gated by `0xFF813A != 0`.

### 4. The four "unreferenced" routines (`routines.tsv`)

| Addr | IDA fn | Code xrefs | BE32 ptrs | Status |
| --- | --- | --- | --- | --- |
| `0x07801C` | none (standalone, ends `0x078084` `rts/l`) | 0 | 0 | **Dead.** USB channel/endpoint config over the `0xFF6000` block via `sub_77F00`/`77E28`/`77DB8`; writes `0xFFAFFE`/`0xFFB000`/`0xFFB002`. Orphan library routine. |
| `0x0773E8` | none | 0 | 0 | **Dead.** Endpoint-status query: `and.b #0x3F` (ep# 0..63), selectors `0x4000`/`0x4001` via `sub_77FC6`/`sub_78086`, result → `0xFFB01E`/`0xFFB020`. |
| `0x0779C4` | none | 0 | 0 | **Dead.** Byte-identical twin of `0x0773E8` (compiler-emitted duplicate). |
| `0x076B4E` | none (inside block `0x0767BE`–`0x076C08`) | **1 jump from `0x076B2A`** | 0 | **Not unreferenced — live intra-module branch target.** USB EP control: writes TRG `0xFFEE2C`, IER `0xFFEE04/05/06`, IFR0 `0xFFEE00` (`#0xFD`/`#0xFE`), reads `0xFEE000/01`. |

`0x076B4E` sits in a module-internal USB control/state block `0x0767BE`–`0x076C08` whose only external
entry is a window call `0x078176` → `0x0768A8`; every other entry is an internal jump. So it is live
relative to its block, and that block, like the pump, is reachable only through window code. G1's list
should be corrected: three orphans, one live branch target.

Note `0x0768A8` is the one module routine referenced by a pointer: BE32 `0x000768A8` appears once, at
`0x07B4EC` — **inside the closed window** (edge only; contents not examined).

### 5. P3DR bit 0 (`0x056450`) and the DSP reset/boot line `0xFFFF52` (Confirmed)

`0x056450 7E 52 73 00 btst #0,@0xFFFF52` then `0x056454 beq .` / `0x056456 5E 05 60 46 jsr sub_56046`:
if P3DR bit 0 (DSP enable line) is asserted, call the DSP-link shutdown `sub_56046`. It is reached by
jump from `0x0562F8`, inside dispatcher `0x056272`–`0x05645C`, whose caller chain is
`0x0030B8` → scheduler `0x002C76` → reset/main `0x002092`. **This runs in the normal
scheduler/dispatcher, not in the pump path** — it is a housekeeping check that tears the DSP link down
when the enable line is still high. It never calls, and is never called by, the pump.

A whole-image scan of `0xFFFF52` bit-ops (`p3dr.py`, 46 real sites) shows the DSP reset/boot line is
driven **only** by the DSP driver and the DSP-WRITE machine — never by the pump or the
`0x075F36`–`0x078105` module:

- bit 0 (enable): `bset` in DSP power-on `0x056498` and DSP-WRITE state 0 `0x05DCE6`; `bclr` in shutdown
  `0x056056`.
- bit 3 (reset pulse): `bset` `0x05650E` (power-on) / `0x05DD62` (DSP-WRITE state 1 assert);
  `bclr` `0x056526` / `0x05DD76` (release) / `0x05605A` (shutdown).
- bit 4 (boot/mode): `bset` `0x05DD50` (DSP-WRITE state 3); `bclr` `0x05DDD4` (state 6) / `0x05606C`.
- bit 1 (frame strobe/direction): `0x0483C6` (before DSP DMA), `0x05674C` etc.

Sequence relative to the pump: the DSP-WRITE machine `sub_5DD00` pulses reset (bit 3) and asserts
boot/mode (bit 4) on `0xFFFF52`, then at state 3 reconfigures SCI-C to async (`0x05DD9E` → `0x078222`),
then from state 5 drives the byte queues each tick (`0x05DD12` → window `0x07815C`), whose transmit side
is the polled pump at `0x0781C0` → `0x076FC8`. So the reset/boot pulse precedes and sets up the pump;
the pump never touches `0xFFFF52`.

## USB relevance

- **Question 1 (everything USB).** The pump is the transmit half of a **USB-CDC-bulk-OUT → SCI-C
  forwarder**: it drains the host byte stream from the `0xFF6288` queue to the DSP serial port 64 bytes
  per call and re-arms the USB bulk-OUT endpoint (`bset #6,@0xFFEE04`, IER0) for flow control. This is the
  DSP-download data path, and it is wholly inside the boot-strap / DSP-WRITE-MODE service, never in normal
  operation. It confirms and localises doc 05/06's "generic queue-driven byte relay" at `0xFF6288`.
- **Question 2 (USB SDR).** Nothing new in favour. The pump moves vocoder-rate command bytes on a byte-wide
  SCI, re-armed against a 64-byte full-speed bulk endpoint; there is no sample source, no wide converter
  port, no isochronous path on this route. Not a help to SDR.
- **Question 3 (reaching the DSP).** This pins the earlier inference: the DSP-download transport is
  reachable only by (a) the boot strap on `0xFFFF4C` (sets `0xFF813A`), or (b) DSP-WRITE MODE
  (`sub_5DD00`, mode `0xEE`). Neither is a stock-radio runtime UI action or a normally-serviced USB
  request. A host on the USB CDC port can feed the pump's queue **only once the radio is already in that
  service mode**; it cannot put it there over USB.

## Open

Most valuable first.

1. **Inside the window (`0x078106`–`0x07B753`, CLOSED here):** resolve what at/around `0x0781C0` decides to
   call the pump, and what triggers mode `0xEE` / the `0xFFFF4C` strap, to state the runtime-UI reachability
   as Confirmed rather than Inferred. Needs a lane cleared into the window.
2. **Name the `0xFF6288` / `0xFF62F8` / `0xFF6240` queue block fields** and the peripheral at
   `0xFFEE00`–`0xFFEE53` the module programs, to identify which physical connector the bridge feeds
   (the open question doc 06 left).
3. **Confirm `0x076B4E`'s enclosing block reachability** — whether block `0x0767BE`–`0x076C08` is reached
   in DSP-WRITE MODE or is dead apart from `0x0768A8`.
4. **Pin the `0xFFFF4C` strap line** to a physical key/jumper (shared with MAIN-IO Open #3: the line maps
   to internal key code `0x11`).

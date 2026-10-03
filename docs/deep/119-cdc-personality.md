# 119 — The CDC-ACM device personality (`26AA:0020`): control plane and data pump (lane M7)

Owner-side, strictly read-only static analysis of the ver 1.02 images already on disk. Nothing was
written, flashed, transmitted, or connected to any radio or device; no image byte was changed; no shared
database was opened. MAIN is H8SX, big-endian, base 0, so file offset = mapped address for every MAIN
cite below. Model: **claude-opus-5-5** (exact model ID `claude-opus-5-5`).

Tables and reconstructed C in `ida\out\cdc-personality\`: `verify.py` (66 byte-cites re-read from the
image, **0 mismatch**), `m7_cdc_requests.c`, `m7_cdc_datapump.c`, `reached-ranges.tsv`, and
`work\disasm.txt` / `work\heads.tsv` / `work\xrefs.txt` (the IDA force-decode, job `ida\jobs\m7_cdc.py`,
DB `M7_CDC` seeded `--copy-from L1_MAIN_FINAL5`, exit 0, no traceback).

## Verdict

The CDC-ACM personality is a **fully implemented USB virtual COM port that is a transparent byte bridge
to the on-chip SCI-C serial link — i.e. to the DSP** (SCI-C `0xFFFF88`–`0xFFFF8D`, BRIEF correction 6).
Its control plane answers exactly four CDC class requests — **`0x20` SET_LINE_CODING, `0x21`
GET_LINE_CODING, `0x22` SET_CONTROL_LINE_STATE, `0x23` SEND_BREAK** — plus standard GET_DESCRIPTOR; every
other request, including all vendor (`0x40`/`0xC0`) requests, is **STALLed** via EPSTL (`0xFFEE2A`) — a
real stall, unlike the vendor personality which never stalls. The line coding the PC sets (baud/parity/
stop/data bits) is **stored at RAM `0xFF63DE` but never programmed into SCI-C**: the DSP link runs at the
fixed 8-N-2 rate set by `0x078222` (SMR `0x08` / BRR `0x0C` / SCR `0x70`). `SET_CONTROL_LINE_STATE` with
`wValue == 3` (DTR+RTS, i.e. the host opening the port) is the one class request with a side effect: it
(re)initialises the data queue (`sub_78508`). The data endpoints are **EP `0x01` bulk-OUT (host→radio),
EP `0x82` bulk-IN (radio→host), EP `0x83` interrupt-IN (notification)**; bytes written by the PC to EP
`0x01` land in the `0xFF62D8` ring and are drained 64 at a time to SCI-C TDR by the pump `sub_76FC8`,
while bytes the DSP sends arrive on the SCI-C receive interrupt (`sub_7711E`), land in the `0xFF62C8`
ring, and are drained to EP `0x82`. **Entry is gated three ways:** the held-key strap at `0x002200`
(`(P@0xFFFF4C & 0x7F) == 0x7D`, key code `0x11`) sets `FF813A = 1`, which alone brings up enumeration and
the receive half; the **transmit pump additionally requires DSP-WRITE state ≥ 5** (`FFB0C4 >= 5`), since
its only caller `0x0781C0` sits in the service loop `0x07815C`. **This path cannot write MAIN's own
program flash** (re-tested here: the entire decoded CDC control+data path touches only `0xFFEExx` USB
registers, `0xFFFF8x` SCI-C, the `0xFEExxxx`/`0xFF6xxx` RAM rings, and the DSP reset pins on `0xFFFF52`
driven by the DSP-WRITE machine — no flash-control register appears; consistent with BRIEF correction 7),
and it **carries no sample/IQ stream** (64-byte bulk, byte-wide polled SCI-C, no ADC/DMA/isochronous
source anywhere on the path). What the virtual COM port is *for* is the **DSP command / firmware-download
link**: it is the host-visible front end of the same DSP-WRITE transport documented in docs 42/15.

## Method

One private DB, `M7_CDC`, seeded `--copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64` (service
window opened to 336 heads), run once through `ida\run_job.py` (job `ida\jobs\m7_cdc.py`, exit 0, no
traceback). The job force-decodes, following instruction flow, the handler block and USB module body that
the ISR demux `0x07827C` reaches — `0x0767BE`–`0x0770F0`, the RX bridge `0x07711E`–`0x077240`, the ISR
demux `0x07827C`–`0x078334`, and the bus-reset handler `0x0784BE` — and dumps bytes+mnemonic per head,
xrefs, and the call edges out of the handler block.

Independently of IDA, `verify.py` re-read **66 load-bearing byte runs** straight from
`decrypted\FT3D_MAIN_ver102_EXP.bin` (sha256 `8e3ecd05409b2c31…`, re-checked, unchanged): the handler
record table, the ISR-demux walk, the SETUP handler, every compare in the request dispatcher `sub_76C0A`
and the class handler `sub_76EF8`, the descriptor pointer records, the CDC descriptor set, the three
entry gates, and the pump/bridge SCI-C accesses. **0 mismatch.** The C in the two `.c` files was written
from the disassembly, each block carrying the mapped address of its bytes; there is no Hex-Rays for H8SX.

**Not done / scope.** The two near-duplicate EP0 handlers `0x076ADE`/`0x076B20` (incl. the live branch
target `0x076B4E`, doc 42) have no handler-table entry and no absolute reference (docs 95/42 agree); I did
not establish how, or whether, they are reached, so they are left Unknown and are **not** in my proven
proposal. The window-internal helpers (`sub_78334`/`sub_7837C`/`sub_783DA`/`sub_78442`/`sub_78508`,
`0x078222`) were read only to name the call, per doc 95. No host code was written or run; no device was
touched.

## Findings

### 1. Handler-record table and the ISR demux (Confirmed)

The boot `.data` copy publishes 1198 bytes `0x07B2A6`→`0xFF6034` (doc 95). Inside it, the handler record
table lands at RAM `0xFF6242` = flash `0x07B4B4`, stride 10. The ISR demux `0x07827C` builds a pending
word `IFR0<<24 | IFR1<<16 | IFR2<<8` (`0x0782B6`–`0x0782D4`), ANDs it with the IER snapshot, then walks
each 10-byte record: `{mask:u32 @+0, code:u8 @+4, handler:u32 @+6}`. When `mask & pending` is non-zero it
calls `handler(er0=pending, r1l=code)` via `jsr @er2` (`0x078308 5d 20`); `mulxu.b #0xa` (`0x078310`) is
the stride. Records (Confirmed, `verify.py`):

| flash | mask | IFR0 bit | code | handler | role |
| --- | --- | --- | ---: | --- | --- |
| `07B4B4` | `80000000` | b7 | 0 | `0784BE` | bus reset → re-init rings, FCLR |
| `07B4BE` | `05000000` | b0\|b2 | 1 | `0769AA` | EP0-IN sent / EP0-OUT |
| `07B4C8` | `08000000` | b3 | 0 | `0768C8` | **SETUP** → request parser |
| `07B4D2` | `02000000` | b1 | 1 | `0769AA` | EP0-IN request |
| `07B4DC` | `40000000` | b6 | 5 | `0767BE` | EP `0x01` bulk-OUT data |
| `07B4E6` | `10000000` | b4 | 4 | `0768A8` | EP `0x82` bulk-IN serviceable |
| `07B4F0` | — | — | `ff` | — | end marker |

All six live masks sit in the top byte, so only `IFR0` bits select a handler. The BE32 handler pointers
in the record `+6` field are what make this code reachable by a pointer-descent over the copied `.data`
image; `BE32 0x000768A8` at `0x07B4EC` was already noted by doc 42.

### 2. Control-request dispatcher `sub_76C0A` (`0x076C0A`, Confirmed)

The SETUP handler `0x0768C8` acks `IFR0` (`0x0768CC` `EE00=0xF7`, then `0xFD`), copies the 8 SETUP bytes
into the EP0 control engine, sets `ep0_state (FF6314) = 0`, and calls `sub_76C0A` (`0x07691A`). The parser
reads the SETUP packet from on-chip RAM **`0xFEE000`** (`0x076C12`; note this differs from the vendor
stack's `0xFF3CEA` ring) and dispatches on `bmRequestType` (`0x076C18`):

| `bmRequestType` | compare | target | meaning |
| --- | --- | --- | --- |
| `0x80` | `0x076C1A a8 80` | `0x076D44` | standard device GET → GET_DESCRIPTOR (`bRequest==6`, `0x076D4A`) |
| `0x00` | `0x076C22 47 40` | `0x076C64` | standard device SET (`bRequest==7`, `0x076C6A`); SET_DESCRIPTOR-shaped (Inferred) |
| `0x20`–`0x23`, `0xA0`–`0xA3` | `0x076C24`/`28`/`2C`/`30` | `0x076C34` → `sub_76EF8` | **CDC class requests** |
| `0x40`–`0x43`, `0xC0`–`0xC3` | `0x076C42`/`4A` | `0x076C56` → `sub_76FC4` | vendor → returns 1 → **STALL** |
| else | — | `0x076ECC` | STALL |

The finish (`0x076ED2`) sets `ep0_state (FF6314, == FF6304+0x10)`: **3** = STALL (`0x076ECC`
`6b f3 … 63 14`), else **1** = IN data stage for a device-to-host request (`bmReqType & 0x80`,
`0x076EE4`), else **2** = status/ZLP stage (`0x076EEC`). Back in `0x0768C8`, `ep0_state==1` enables EP0
interrupts and kicks the EP0-IN FIFO (`sub_7837C`), `==2` arms the ZLP, and `==3` disables EP0 ints and
asserts **EPSTL (`0xFFEE2A`) |= record stall mask** (`0x076974`). So this personality really stalls bad
requests.

GET_DESCRIPTOR serves **device** (record `0xFF637C` → ptr `0xFF640E`, byte length `0x12`), **config**
(`0xFF6382` → `0xFF649F`, word length `0x43`), and **string** index 0/3 (record `0xFF6388`; string
pointers `0x0007B272`/`76`/`86` are read directly from **flash**, below the copied region). Device/config
are served from their RAM images; strings from flash. Length is clamped to `wLength` (`sub_78442`,
little-endian).

### 3. The four CDC class requests `sub_76EF8` (`0x076EF8`, Confirmed bRequest compares)

`r0l = @FEE001` (`bRequest`, `0x076EFE`), then:

| `bRequest` | compare | handler | effect |
| --- | --- | --- | --- |
| `0x20` SET_LINE_CODING | `0x076F04 a8 20` | `0x076F7E` | arm EP0-OUT to receive the 7–8 line-coding bytes into **`0xFF63DE`** (record `0xFF63E6` = `{len 8, ptr 0xFF63DE}`, flash `0x07B658`). **Not applied to SCI-C.** |
| `0x21` GET_LINE_CODING | `0x076F0A a8 21` | `0x076F38` | send the stored bytes back on EP0-IN, clamped to `wLength` and to len 8 |
| `0x22` SET_CONTROL_LINE_STATE | `0x076F0E a8 22` | `0x076F24` | `@FEE002` (DTR/RTS); **only `==3` acts** (`0x076F2A a8 03`) → `sub_78508` opens the data queue |
| `0x23` SEND_BREAK | `0x076F12 a8 23` | `0x076FC0` | accepted, no action |
| anything else | `0x076F18` | `0x076F1E fb 01` | `r3l = 1` → caller STALLs (so SEND/GET_ENCAPSULATED are not implemented) |

`sub_76FC4` (`0x076FC4 0f 10 54 70`) is the vendor stub: it just returns 1, forcing a STALL. There are no
vendor requests on this personality.

### 4. The data pump and the SCI-C bridge (Confirmed; extends doc 42)

- **TX pump `sub_76FC8`** (`0x076FC8`): drains ≤ 64 bytes from the `0xFF62D8` OUT ring to SCI-C TDR
  `0xFFFF8B` by polled I/O (`0x07701E` wait TDRE `@FFFF8C`, `0x077022` write TDR), then re-arms the USB
  bulk-OUT interrupt `IER0 b6` (`0x07709E 6a 18 ee 04 70 60`) when the ring has room. Sole caller
  `0x0781C0` in the service loop (DSP-WRITE ≥ 5).
- **RX bridge `sub_7711E`** (`0x07711E`): called from the SCI-C ISR `sub_5615C` at `0x0561B0` **only when
  `FF813A != 0`** (`0x056160` loads the selector). Reads SSR `@FFFF8C`, handles framing/parity/overrun
  bits, and on a normal receive stores RDR `@FFFF8D` (`0x077134 28 8d`) into the `0xFF62C8` IN ring.
- **b6 handler `0x0767BE`**: moves an EP `0x01` bulk-OUT packet into the OUT ring (`sub_78334`,
  src `0xFF6368`, ring `0xFF62D8`) and NAKs the host (clears `IER0 b6`, `0x0767FA`) when the ring is full.
- **b4 handler `0x0768A8`**: drains the `0xFF62C8` IN ring into the EP `0x82` bulk-IN FIFO (`sub_7837C`,
  `0x0768BC`) and records the moved count at `0xFF63F8`.

Net data flow: `PC —EP0x01→ FF62D8 —pump→ SCI-C TDR → DSP` and `DSP → SCI-C RDR —ISR→ FF62C8 —b4→ EP0x82 → PC`.

### 5. Entry conditions (Confirmed)

- **Strap** `0x002200`: `(P@0xFFFF4C & 0x7F) == 0x7D` (key code `0x11`) → `FF813A = 1` (`0x002224`) →
  `jsr 0x078106` (`0x002234`). Otherwise `FF813A = 0` and the vendor stack runs.
- **USB ISR gate** `0x054D54`: `FF813A != 0` → `0x054EB0 jsr 0x07827C` (the CDC demux). Enumeration and
  the receive half need only this.
- **DSP-WRITE gate** `0x05DD06`/`0x05DD12`: `FFB0C4 >= 5` → `jsr 0x07815C`, whose `0x0781C0` is the pump's
  only caller. So the **transmit** half needs DSP-WRITE mode (entered via mode `0xEE`, `sub_5DD00`, which
  also pulses the DSP reset/boot pins on `0xFFFF52`).

### 6. Flash-write re-test and sample/IQ re-test (Confirmed for this path)

Every register write on the decoded CDC control and data path targets `0xFFEExx` (USB function module),
`0xFFFF88`–`0xFFFF8D` (SCI-C), `0xFF6xxx`/`0xFEExxxx` RAM rings, and `0xFFFF52` (external-DSP reset/boot,
driven by the DSP-WRITE machine, not by the CDC code itself). **No program-flash control register is
referenced on any CDC routine**, so this path does not write MAIN's own flash — it reflashes the external
DSP over SCI-C. This is the path-local confirmation of BRIEF correction 7 (which already established the
whole-image negative). No ADC, DMA, or isochronous endpoint exists on the path; the bulk pipes are 64
bytes of byte-wide polled serial relay. **No sample/IQ stream, as expected.**

### 7. Proven/named byte proposal (proposals only — masks/seeds unchanged)

The **named** mask (final5 and final6) already covers 100% of this CDC code. The **proven** mask does not:
the handler bodies are ~3% proven and the request parser `sub_76C0A` (`0x076C0A`–`0x076FC7`, 958 B) is
**0% proven**, because the final5/final6 folded descent never seeded the BE32 handler pointers in the
copied `.data` table. Proposed proven additions for the code reached by that descent (and from the SETUP
handler's `jsr sub_76C0A`), measured against `final5_proven_mask.bin`:

| range | role | add (B) |
| --- | --- | ---: |
| `0767BE`–`076ADE` | live handlers b6/b4/b3/EP0 (800 B, 32 already proven) | **+768** |
| `076C0A`–`076FC7` | request parser + CDC class handler + vendor stub | **+958** |
| `07711E`–`0771E1` | SCI-C RX bridge (196 B, 144 already proven) | **+52** |
| **total** | | **+1,778** |

Named delta **0** (already named). The near-duplicate EP0 handlers `0x076ADE`–`0x076C08` (≈300 B, incl.
`0x076B4E`) have no table or absolute reference and are **not** proposed (Unknown reachability). Seeds: the
descent needs the six `+6` dwords of the handler records at `0x07B4BA`/`C4`/`CE`/`D8`/`E2`/`EC` as pointer
seeds. Full list: `reached-ranges.tsv`.

## USB relevance

- **Q1 (everything USB).** The second MAIN personality is now specified end to end on top of docs 15/42/95:
  the handler-record demux, the full control-request parser with its exact `bmRequestType`/`bRequest`
  compares, the four CDC class requests, the EPSTL stall behaviour, the descriptor serving, and the
  USB↔SCI-C data bridge with its three entry gates. The USB surface of the radio is exactly two
  personalities — vendor `26AA:0001` (normal boot) and CDC `26AA:0020` (strap-held boot) — and both are
  now reconstructed.
- **Q2 (USB SDR): still no.** The CDC data endpoints are 64-byte bulk relays to a byte-wide SCI-C link.
  No sample source, no DMA, no isochronous pipe. The virtual COM port's far end is the DSP command/
  download channel, not a receiver tap.
- **Q3 (DSP): this is the host-visible door to the DSP.** A PC on this COM port exchanges raw bytes with
  the DSP over SCI-C — but only once the radio is already in the strap/DSP-WRITE service mode, which a
  host cannot set over USB. The SET_LINE_CODING baud is ignored; the DSP link is fixed 8-N-2 at the
  `0x078222` rate.

## Open (most valuable first)

1. **The two unreferenced EP0 handlers `0x076ADE`/`0x076B20`** (incl. `0x076B4E`): establish whether the
   service loop `0x07815C` reaches them through a pointer not yet traced, or they are dead duplicates.
   This closes the last ~300 B of the handler block.
2. **Apply the +1,778 B proven proposal** (seed the six handler-record pointers into the descent) and
   re-derive the mask; confirm the request parser and live handlers become proven.
3. **Name `0xFFFD54`/`0xFFFD62`** written by the RX bridge's framing/break path (`0x077140`/`0x077156`):
   likely the CDC SERIAL_STATE notification shadow or a line-event latch — would complete the EP `0x83`
   notification story.
4. **Pin the `0xFFFF4C` strap line to a physical key** (key code `0x11`) — shared Open with docs 15/64;
   the single fact that makes this COM port usable to the owner.

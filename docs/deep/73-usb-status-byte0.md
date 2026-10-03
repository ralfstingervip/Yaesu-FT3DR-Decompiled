# 73 — The vendor USB status report, byte 0: `FF8184` and the audio state machine `0x039080` (lane J5)

Owner-side static analysis of the decrypted ver 1.02 images on disk. Nothing was written to any radio
or device, nothing was enumerated, and no image byte was changed. MAIN is H8SX, big-endian, base 0, so
file offset = mapped address for every MAIN cite. Model: **claude-opus-4-8**.

Tables in `ida\out\usb-status0\`: `writers-readers.tsv` (every writer/reader of `FF8184` and
`FF8183`), `state-machine.tsv` (the `FFA9E5` dispatch table and the byte-0 decision tree), and
`work\` (IDA disassembly dumps `sm_core.txt`, `sm_pre.txt`, `ep3_6.txt`, `ep3_sub.txt`, `init_c.txt`,
plus `funcs.txt`, `xrefs.txt`). Byte facts were re-read independently from
`decrypted\FT3D_MAIN_ver102_EXP.bin` with a Python @aa:16 decoder.

## Verdict

**Status byte 0 of the 3-byte EP `0x83` report is `FF8184`, a 0/1 audio-routing / activity flag.**
It is computed by the radio's audio-path state machine entered at **`0x039080`** (IDA `sub_3906A`;
the heavy lifting is in `sub_391C0`), and stored once per pass at `0x0393DC` (`mov.b r3l,@0xFF8184`).
The decision tree (Confirmed from the code; camera-side purpose Inferred) is:

- **1** when `USB CAMERA → SP SEL` (`FF89C5` bit 1) selects CAMERA — audio is routed out to the
  accessory — **or** when the radio is idle with no internal audio;
- **0** when the radio is driving its own audio path right now: transmitting (`FFA9E3 & 0x2C`
  TX/mute bits set) or receiving live audio on a monitored band while `SP SEL = INT SP`
  (per-band flags `FFA9AD`/`FFA9AC` non-zero).

So byte 0 tells the camera/speaker-mic accessory whether the radio's audio is available to it (1) or
the radio is busy on its internal audio path (0). It is also forced to **1** at three points where
"a transfer/session is active" must be announced: the `41 D1` image-push start (`0x055496`), the
session-start state 5 of the audio machine (`0x039462`), and the settings-refresh EP3 builder
(`0x0557A4`). Its reset value is **1** (idle), set by the init long-word `0x0100FFFF` at `0x054C64`.

**The task's alternative hypothesis — that "the real state may be `FF8183`" — is refuted.** `FF8183`
is a completely different variable: it is the USB **control-transfer** state (0..11, the 12-slot
dispatch table at `0x055002`, I12 doc 64). `FF8183` is read only by the control dispatcher
(`sub_54FEC` at `0x054FEC`), the SETUP handler (`0x05512A`) and the EP0-IN ZLP check (`0x054E30`); it
is **never read by any EP `0x83` builder** and never appears on the wire. The two cells sit next to
each other and the `41 D1` handler happens to write both (`FF8184=1`, `FF8183=8`), which is the likely
source of the earlier confusion, but they are unrelated: `FF8183` = control FSM state, `FF8184` =
report byte 0.

**Bytes 1 and 2 are the two USB-CAMERA menu settings, confirmed byte for byte:** byte 1 = `FF89CE`
(SIZE: 0 = 320x240, 1 = 160x120), byte 2 = a QUALITY code derived from `FF89CD` (0→`0x18`, 1→`0x30`,
≥2→`0x50`; LOW/NORMAL/HIGH ≈ JPEG quality 24/48/80). This matches I12 exactly.

## Method

- IDA job `ida\jobs\j5_usbstat.py` (read-only, no edits, no auto-analysis), DB `J5_USBSTAT` seeded
  `--copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64`, one pass, exit 0, no traceback. It dumped the
  state machine `0x039080`–`0x0394D0` with its prologue and tail, the three live EP3 builders and the
  vendor init, listed function bounds `0x038F00`–`0x039700`, and ran an xref census (the census came
  back empty because `MAIN_FINAL2` has no RAM segment mapped at `0xFF8000+`, so `@aa:16` operands carry
  no data xref — expected; the disassembly dumps and the byte scan carry the evidence instead).
- Independent Python scan of the whole 1 MB MAIN image for every `@aa:16` byte/word/bit access to
  `FF8180`/`FF8183`/`FF8184`/`FF8185`/`FF8186`/`FF8187`, decoding opcode and direction. Results in
  `writers-readers.tsv`. The long-word init forms (`01 00 6b 84 81 84`) were cross-checked against the
  IDA disassembly in `init_c.txt`.
- The closed window `0x078106`–`0x07B753` was never decoded. None of the `FF8184`/`FF8183` accesses
  fall inside it (the scan prints a `[WINDOW]` tag; none appeared).

Not done: the per-band receive-audio predicate inside `sub_391C0` (`sub_1E80A`/`sub_1E7C2` squelch
queries, `FF8EA0`/`FF8EA6`/`FFBAD6`/`FF89D1` band state) was read structurally, not decoded to the DSP
level — enough to name `FFA9AD`/`FFA9AC` as per-band RX-audio-active flags, not enough to name every
band-state bit. That residue does not change byte 0's meaning.

## Findings

### 1. The three-byte report, byte for byte (Confirmed; `ep3_6.txt`, `ep3_sub.txt`)

All three live builders (state 6 `0x055202`, state 7/10 `0x055326`, `sub_557A2` `0x0557A2`) write the
same sequence to EPDR3 (`0xFFEE18`), gated by DASTS `0xFFEE27` bit 5 (previous report still in FIFO)
and a send-on-change compare against shadows `FF8185` (byte 0) and `FF8186` (bytes 1-2):

```
byte 0  <- FF8184            (05520A -> EE18)   audio-routing/activity flag, 0 or 1
byte 1  <- FF89CE            (055216/05521A)    SIZE: 0 = 320x240, 1 = 160x120
byte 2  <- {0x18,0x30,0x50}  (05521E..055232)   from FF89CD QUALITY 0/1/>=2
TRG = 0x40                   (05523A)           send 3-byte EP3 packet
```

`sub_557A2` (the settings-refresh builder, reached from `sub_74B08`) is identical except it first
forces `FF8184 = 1` (`0x0557A4`) — a refresh always reports "idle/available".

### 2. `FF8184` is written only by the audio machine and the session/refresh forces (Confirmed)

Seven writers, all accounted for (`writers-readers.tsv`):

| ea | writes | context |
| --- | --- | --- |
| `0x0393DC` | `r3l` (0/1 computed) | `sub_391C0` body — **the** data-driven writer |
| `0x039462` | 1 | `sub_39454` = state 5 (session start) |
| `0x055496` | 1 | `41 D1` image-push start |
| `0x0557A4` | 1 | settings-refresh builder |
| `0x054C64` | `0x0100FFFF` long | cold-boot vendor init (byte0=1) |
| `0x054F1E` | `0x0100FFFF` long | VBUS-gone soft reset |
| `0x05601E` | `0x0100FFFF` long | selector=1 / soft reset |

Nine readers, **every one inside the USB vendor stack's EP `0x83` path**: three push byte 0 to EPDR3
(`0x05520A`, `0x055336`, `0x0557D8`), three read the `FF8184/FF8185` word for the send-on-change
compare (`0x0551DA`, `0x055306`, `0x0557A8`), and one is the known-dead block `0x054F4E` (I12). There
is **no reader of `FF8184` anywhere else in the image** (scope: whole MAIN, all `@aa:16` byte/word/bit
forms). That is the proof that `FF8184` exists solely to be byte 0 of the report.

### 3. The state machine at `0x039080` (Confirmed; `state-machine.tsv`, `sm_core.txt`)

Entry `0x039080` is called from 9 sites — the main loop/scheduler (`0x002CC4`, `0x003166`,
`0x0038CE`, `0x003A26`), TX/RX control (`0x02D1B0`, `0x02DDEA`), audio/band control (`0x033C30`,
`0x034746`) and the USB settings-refresh neighbourhood (`0x074B1C`). The state variable is **`FFA9E5`
(0..8)**; the event/request byte is **`FFA9E3`**.

- **Prologue `0x039080`–`0x0390FA`:** latch `FFA9E3` into `r2l`, clear bit 7; if `FFA9E3` bit 4 is set
  force `FFA9E5 = 5` (this is how `41 D1` enters the push session — I12 §5 sets `FFA9E3` bit 4);
  otherwise, with no TX bits pending, clear `FFA9AD`/`FFA9AC` and advance `2→4` or settle to `0`.
  Then dispatch through the table at `0x0390FC` (`index = FFA9E5 * 4`).
- **States 0–4** are the normal audio-routing cycle: idle → route speaker (drive port `0xFFFF59`
  bit 2 from `SP SEL` and VBUS `FF8180.0`) → teardown. Every one of these calls `sub_391C0`, which is
  where byte 0 is (re)computed.
- **States 5–8** are a session (the camera image push, and the confirmation tone): state 5
  (`sub_39454`) sets `FF8184 = 1` and the speaker-route port bit directly; state 8 (`sub_394A8`) spins
  until the tone/event sequencer `FFAAE8 == 0`, then tears down to state 0.

The full byte-0 decision inside `sub_391C0` (convergence at `0x03935A`, store at `0x0393DC`) is the
three-priority tree in the Verdict; `FFA9AD`/`FFA9AC` are the per-band RX-audio-active flags set to
`0xFF`/`0` earlier in `sub_391C0` from the squelch/busy queries `sub_1E80A`/`sub_1E7C2` and band
state. The same routine also drives the hardware audio-mux pin `0xFFFF59` bit 2 from the same `SP SEL`
and VBUS inputs — so byte 0 is the software mirror of the physical speaker routing the accessory sees.

### 4. `FF8183` is the control FSM state, not the report (Confirmed)

15 writers and 3 readers, all in the vendor **control** stack (`writers-readers.tsv`). Readers are the
dispatcher `sub_54FEC` (`0x054FEC`, index into the 12-slot table `0x055002`), the SETUP handler
(`0x05512A`) and the EP0-IN ZLP check (`0x054E30`). No EP3 builder reads it. It never reaches the
wire. Byte 0 of the report is `FF8184`, unambiguously.

## USB relevance

- **Q1 (everything USB).** The EP `0x83` 3-byte interrupt-IN report is now fully specified:
  byte 0 = `FF8184` (audio-routing/activity, 0/1), byte 1 = `FF89CE` (SIZE), byte 2 = QUALITY code.
  Byte 0 is not a camera command and not the USB state — it is an audio-domain status bit produced by
  the radio's audio/TX session machine at `0x039080`, surfaced to the accessory so it can coordinate
  its speaker/shutter with whether the radio is talking, listening, or idle. This closes I12 Open #1
  and I1 Open #1 (the `FF8184` residue).
- **Q2 (USB SDR).** Unchanged and still no. Byte 0 is a single routing bit; it carries no samples and
  opens no new IN path. The EP `0x83` pipe remains 3 status bytes on change over a 20 ms interrupt
  endpoint.
- **Q3 (DSP).** Unaffected. The byte-0 computation only *queries* audio/squelch state
  (`sub_1E80A`/`sub_1E7C2`) and toggles the speaker-mux port; it does not touch SCI-C or the DSP link.

## Open (most valuable first)

1. Decode the per-band RX predicate in `sub_391C0` (`sub_1E80A`/`sub_1E7C2`, `FF8EA0`/`FF8EA6` band
   bits, `FFBAD6`, `FF89D1`) to name `FFA9AD`/`FFA9AC` precisely and state exactly which receive
   conditions drive byte 0 to 0. Not required to know byte 0's meaning; it would make the mapping
   exhaustive.
2. Identify the `FFA9E3` bit roles end to end (bit 4 = force session, bits 0x2C = TX/mute, bits 0/1/5/7
   consumed in the prologue). This is the audio machine's full input contract.
3. Tie the tone sequencer wait in state 8 (`FFAAE8`) to I12 Open #3 (event `0x4F` delay on the `D1`
   status stage) — same sequencer, two lanes converge here.

## Files

- `docs\deep\73-usb-status-byte0.md` (this doc)
- `ida\jobs\j5_usbstat.py` (IDA job, read-only)
- `ida\out\usb-status0\writers-readers.tsv`, `state-machine.tsv`, and `work\` (IDA dumps + scan log)
- DB `ida\db\jobs\J5_USBSTAT\J5_USBSTAT.i64`; logs in `ida\log\jobs\J5_USBSTAT\`

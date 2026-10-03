# UI sources of DSP TX sessions, and the 11/12/32 setting payloads (MAIN)

> Lane J9. Private DB `J9_DSPTX` (`ida\db\jobs\J9_DSPTX\J9_DSPTX.i64`), seeded
> `--copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64` (h8sxa). No other database was opened,
> no image was modified, nothing was written to or connected with any device. Model:
> **claude-opus-4-8** (claude-opus-4-8). Image `decrypted\FT3D_MAIN_ver102_EXP.bin`, base 0, so
> file offset = mapped address, big-endian. Job scripts `ida\jobs\j9_txsrc.py` and
> `ida\jobs\j9_txsrc2.py`. The closed window `0x078106`–`0x07B753` was not entered.
>
> Tables in `ida\out\dsp-tx-src\`:
> - `session-caller-map.tsv` — every session entry point, its callers, the user action, the gate;
> - `opcode-11-12-32-payload.tsv` — field-by-field frame decode with source RAM address,
>   EEPROM address, default and packing;
> - `caller-edges.tsv` — the raw upward caller edge list (IDA xrefs, up to 5 levels);
> - `caller-trace.txt`, `opcode-builders.txt`, `txstart-context.txt`, `txkey-chain.txt`,
>   `flag-setters.tsv` — the supporting disassembly and census.

## Verdict

**Two things key the radio up, and only two: the hardware PTT, and the WIRES-X/PDN host link.**
The PTT line is **port input `0xFFFF4D` bit 3** (active low), polled by the transmit state handler
`sub_34966` at `0x034984`. A press runs `sub_34966 → sub_34A52 → sub_35872`, the TX-start
dispatcher, which chooses a DSP session from three runtime flags and calls one of the three
`dsp_request` entries (`sub_5A1BE`/`sub_5A28A`/`sub_5A2F8`, I13's `0x05A1BE`…). The whole chain
hangs off the main loop `sub_2070` through the PTT/TX state machine `sub_34538` (jump table
`off_34674` indexed by the TX-state byte `0xFFAAD5`). The second keyer is `sub_73E58`, reached only
in node mode (`0xFF8DDE ≠ 0`): host command byte `0x11` on the SCI-A link calls the same
`sub_34A52 → sub_35872`, so **the PC can key the radio** when node mode is on. Everything else that
reaches the DSP is either a single-frame request (a setting/mode change re-sending `0x12`/`0x1A`/
`0x32`/`0x16`) or the **automatic** data-reply session `0x17`, which the radio starts on its own
when it decodes certain over-the-air messages — no keypress.

**What 11/12/32 carry.** All three are config frames built from the persisted settings regions
(doc 32), copied as opaque field values; the opcode is always chosen by firmware. `0x11` packs the
23-byte R3 **DSP digital-audio parameter block** `FF8E20`–`FF8E36` (plus a 12-byte constant ROM
tail `0x00F9A8`). `0x12` is the **mode / data-type** frame: byte[1] low two bits are the DT
(V/D-1, data-FR, V/D-2, voice-FR), the upper bits are `FF8D85`, bit 7 is a settings-dirty flag;
byte[2] is `FF8D86` with the squelch/monitor request bits and the RX/mode state. `0x32` is the
**AMS / mode** frame: byte[1] packs `FF8AA0` (menu item F3A3), byte[2] packs `FF8ABD` (F3AB,
clamped 0–8), byte[3] bit 0 is the runtime DG-ID/monitor flag `FFAA35` b7. The human menu names for
F3A3/F3AB and for the `FF8Exx` block are **not decoded in this package** (the SUB-side F3xx→label
map is still open, doc 32 #1); what each byte *means to the DSP* is unknowable because the DSP
firmware is not in the package.

## Method

- `j9_txsrc.py` (fresh seed, `auto_wait`): walked IDA code xrefs **upward** from nine session/
  request entry points to depth 5, writing `caller-edges.tsv`/`caller-trace.txt`; disassembled the
  11/12/32/31 builders, `frame_finish`, the init-step handlers, the request senders and the
  TX-start dispatcher `sub_35872` (`opcode-builders.txt`, `txstart-context.txt`).
- `j9_txsrc2.py` (`--reopen`): disassembled the PTT chain `sub_34538`/`sub_34966`/`sub_34A52`/
  the node entry `sub_73E58`/the twin dispatcher `sub_35C14`/`sub_35F6A`, the op-11 tail and the
  op-12 helpers `sub_59DE8`/`sub_593C8`; took a write census of the twelve selector flag bytes
  (`flag-setters.tsv`).
- Cross-checked every source address against `ida\out\settings\settings-bytes.tsv` (doc 32) for
  region/EEPROM/default, and against docs 44/17 for `FF8EA0` and the DG-ID cells.
- Not covered: the DSP's interpretation of any config byte (no DSP firmware in the package); the
  SUB F3xx→label decode; the `~20` individual `B0AA.b7` setters were counted, not each decoded;
  the closed window was not entered.

## Findings

### 1. The transmit chain and the PTT line (Confirmed bytes; "PTT" Inferred from role)

```
sub_2070 (main loop)
  -> sub_34538         TX/PTT state machine; jmp off_34674[AAD5]  (0x034642)
     -> sub_34966      transmit-key handler
        0x03497C  mov.b @0xFF956D -> if !=0 return         ; TX-inhibit timer (TOT)
        0x034984  btst #3, @0x4D:8                          ; read port input 0xFFFF4D b3
        0x034988  bne  loc_34A70                            ; bit set (released) -> stop/RX path
        ...       compute band digital mode (FF8EA0 b6 = band B) ...
     -> sub_34A52
        0x034A6A  jsr  sub_35872                            ; TX-start dispatcher
```

`@0x4D:8` is the H8S 8-bit-absolute form of `0xFFFF4D`, in the port-input block `0xFFFF40`–`0xFFFF4F`
(BRIEF; the boot held-key check uses the neighbour `0xFFFF4C`). Bit 3 low = key down. When it is
high the handler diverts to `loc_34A70`/`sub_34FF4` (end session, return to receive). So **bit 3 of
`0xFFFF4D` is the PTT input, active-low** (Confirmed instruction; PTT identity Inferred from the
routine's position at the head of the DSP-TX chain). A parallel node-mode state machine exists at
`sub_35C14` (table `off_35CD8`, mostly `nullsub`) feeding the twin dispatcher `sub_35F6A`; both end
in the same `dsp_request` calls.

### 2. The TX-start dispatcher `sub_35872` picks the session (Confirmed)

After arming TX (`FF9598 = 0x1F`, `jsr sub_34A7C`), the dispatcher selects in this order
(`0x0358CA`–`0x03596A`):

| Test | Session | `dsp_request` | Meaning |
| --- | --- | --- | --- |
| `B0CC.b0` set | `0x15` (table `05C40A`, `1C 03`) | `sub_5A2F8` (`0x0359C8`) | the B0CC.b0 mode (tone/analog carrier path) |
| `AAD4.b0` set | `0x0A` (table `05BDA8`) | `sub_5A28A` (`0x0359A8`) | a data/message/APRS packet is queued |
| else (voice) | `0x02`/`0x0B`/`0x10` | `sub_5A1BE` (`0x03596A`) | C4FM digital voice; DT from band mode |

For the voice arm it first computes `B0C7`, the band's digital submode: `btst #6,@FF8EA0`
selects band B (`FF8EC5`/`FF8EC3`) vs band A (`FF8EB6`/`FF8EB4`); `FF8D20`/`FF8DD5` (comm mode,
`== 1` branch) selects which pair. `sub_5A1BE` then maps `B0C7` → `B0BE`: `2`→`0x02` (DT0),
`3`→`0x10` (DT3), else `0x02`, with `B0C7 == 2` giving `0x0B` (DT2) at `0x05A224`. A 0 `B0C7` is
forced to 2 (`0x03594C`). This is the AMS/C4FM-mode → session mapping H15 and I13 left open.

### 3. Upward origins of every session (Confirmed callers; `session-caller-map.tsv`)

- **`0x02`/`0x0B`/`0x10` voice TX (`sub_5A1BE`)** — PTT, via the chain in §1/§2. Also entered from
  `sub_35F6A` (node-mode twin) and from `sub_6CF30` (§below).
- **`0x0A` data-FR TX (`sub_5A28A`)** — `AAD4.b0`. The flag is set/cleared in the message and APRS
  engines `sub_5F712`/`sub_5F78C`/`sub_5F8F4`/`sub_5FA66` and `sub_62ACA`…`sub_63040`,
  `sub_67AB0`…`sub_67F18` (`flag-setters.tsv`). These are the **send-message / send-APRS / send-
  image menu actions**. Also called directly from the node command handler `sub_6CA6E`
  (`06CA8E`/`06CABA`).
- **`0x15` session (`sub_5A2F8`)** — `B0CC.b0`. `B0CC` is written as a whole byte by `sub_2DCE`
  (boot/band set), `sub_73AFE` (node), `sub_74396` (an IPC handler from SUB). This is the
  carrier/tone TX path (`1C 03`).
- **`0x16` host-link data session (`sub_6CF30`)** — only with `FF8DDE ≠ 0` and `B3D8.b7` clear.
  It forces `B0C7 = 2`, calls `sub_5A1BE`, then overwrites `B0BE = 0x16`. Reached from
  `sub_1079E` (the host/node dispatch). PC-driven WIRES-X/PDN header+block push.
- **`0x17` automatic data reply (`sub_6D052`)** — **not a user action.** Its callers
  `sub_62DA4`/`sub_62E14`/`sub_62EAC`/`sub_62F64`/`sub_62FC6`/`sub_63040` are the received-message
  decode engines (`sub_60656`/`sub_62xxx`). Decoding a message that demands a reply makes the radio
  **auto-key** and transmit `0x17`. Worth flagging: a received over-the-air message can start a
  transmission with no keypress.
- **Short TX `BB94` (`0x05EBD2`)** — `FF89BB ≠ 0`, checked in both `sub_34538` (`0x0349D4`) and
  `sub_35872` (`0x0358DE`). `FF89BB` is set by `sub_2AA0` (main loop) and `sub_103C0` (a mode
  entry). A payload-less one-shot keyup: `12, 1A, TXON, hold ~2 s (FF95A2=0x14), 18 STOP, 9E,
  TXOFF, 12, END`.
- **`0x16` header resend request `B0C9.b7` (`sub_19954`→`019962`)** — set right after the own
  callsign/ID block `FF8D26` is written; i.e. **editing your callsign / DG-ID** pushes the `0x16`
  header to the DSP.
- **ID-list push `B0AF`/`B0AE` (`sub_5B208`)** — from `sub_56D16` and `sub_696CA`, the **DG-ID /
  radio-ID list editor**; pushes `15 01` / `15 11` (needs DSP ≥ `0x041E`).
- **Single-frame requests.** `B0AA.b7`/`BBF9.b7` (`sub_5B210`) re-send `0x12` on any digital
  setting/mode change (the ~20 UI routines `0x019C5A`–`0x06CE60`). `B0AC.b7` (`sub_5B254`) re-sends
  `0x12` from the squelch/monitor routines `sub_492D4`/`sub_49400`. `B0CE.b7` (`sub_5B28C`) sends
  `1A` RX ENABLE/DISABLE (MONI / mute). `B0CE.b3` (`sub_5B2D8`) re-sends `0x32` on an AMS/mode-setup
  change (`sub_17822` only when `FF8DDE == 0`, `sub_17990`, `sub_49344`).

### 4. Opcode 11 — DSP digital-audio config block (Confirmed; `opcode-builders.txt` 05905E)

32-byte frame. The whole R3 block `FF8E20`–`FF8E36` is packed in, then a 12-byte constant from ROM.
Byte map (builder `sub_05905E`; defaults and EEPROM from `settings-bytes.tsv`):

| Byte | Source | Packing | Default |
| --- | --- | --- | --- |
| [0] | const | `0x11` | – |
| [1] | `FF8E2A` | `\|0x80`, and `\|0x02` if `FF8DDE ≠ 0` | 0x08 |
| [2] | `FF8E20`,`FF8E21` | `FF8E20<<4 \| (FF8E21&0x0F)` | 0x04/0x07 |
| [3] | `FF8E22..25` | four 2-bit: `(E22<<6)\|((E23&3)<<4)\|((E24&3)<<2)\|(E25&3)` | 2/3 |
| [4..7] | `FF8E26..29` | raw `mov.l` | 06/06/FC/0C |
| [8] | `FF8E2E` | raw | 0x02 |
| [9] | `FF8E2F` | raw | 0x23 |
| [10] | `FF8E30`,`FF8E31` | `E30<<4 \| (E31&0x0F)` | 0x02/0x0D |
| [11] | `FF8E32`,`FF8E33` | `E32<<4 \| (E33&0x0F)` | 0x06/0x08 |
| [12..13] | `FF8E34` | `mov.w` | – |
| [14] | `FF8E36` | raw | – |
| [15..26] | ROM `0x00F9A8` | `eepmov` 12 B | `39 2a 2a 00 28 04 30 60 3f 6f 19 19` |

`FF8E2B`/`2C`/`2D` are **not** in this frame — they feed opcode `1C` (`sub_05A040`). All of
`FF8E20`–`FF8E36` are R3 bytes `n = 0x100`–`0x116`, written by the `sub_19xxx` settings-apply
routines (block writers at `0x019988`/`019996`/`0199A4`/`0199BA`/`0199C8` and singles at
`0x01992A`/`0199AC`/`0199D0`) with **no F3xx sender** — so they are confirmed persisted settings
whose individual menu names are Unknown from this package (doc 32's "663 confirmed-setting bytes,
item Unknown" / "bulk-only" classes). Functionally this is the C4FM/DSP audio-parameter block.

### 5. Opcode 12 — mode / data-type frame (Confirmed; 059240…)

The TX-session opener and the mode-change frame. Entry picks `r2l` (0/2/2/3 at
`059240`/`05923C`/`059238`/`059234`); `sub_59DE8` (the band comm-mode sum over `FF8D20`/`FF8DD5`,
gated by `FF8EA0` b6/b7) forces `r2l = 2` when the sum is 0.

- **byte[1]** `= (FF8D85 & 0xFC) | (B11E & 3)`, then bit 7 `= NOT B0AA.b0` (`bist #7`).
  `B11E` is the DT: 0 = V/D-1, 1 = data-FR, 2 = V/D-2, 3 = voice-FR. `FF8D85` (R3 `n=0x65`,
  EEPROM `0xD065`, default `0x3C`) supplies bits 2–6 — a digital audio/mode field, no F3xx name.
- **byte[2]** `= FF8D86` (R3 `n=0x66`, `0xD066`) with **b6 = B0AC.b1**, **b5 = B0AC.b0**, and the
  low bits OR'd with `r2l` (0/2/3, or the 4/`'B'`/`'C'` state from `sub_593C8`). `B0AC` is the
  squelch/monitor request state.

Mode changes reach the DSP only through this frame; every TX session begins with it.

### 6. Opcode 32 — AMS / mode frame (Confirmed; 05EB4E)

- **byte[1]** `= (FF8AA0 != 0)<<7 | (FF8AA0<<2) | FF8AA0`. `FF8AA0` is R2 `n=0`, EEPROM `0xC000`,
  menu item **F3A3**, default `0x00`. It is a small enum (compared with 1 and 2 in the TX state
  machine `sub_34538`/`sub_34B44`); a top-level operating-mode selector. Packed redundantly into
  b7 and b0–b3.
- **byte[2]** `= ((FF8ABD < 9 ? FF8ABD : 0) + 3) << 4`. `FF8ABD` is R2 `n=0x1D`, EEPROM `0xC01D`,
  menu item **F3AB**, default `0x04`. Clamped to 0–8, biased by 3, into the high nibble.
- **byte[3]** bit 0 `= FFAA35 b7`. `FFAA35` is a runtime flag byte (not persisted); its b6 is the
  promiscuous-DG-ID accept flag on RX (doc 56). This bit is a runtime DG-ID/monitor flag.

F3A3/F3AB human labels are not resolved here (SUB F3xx→label still open). Opcode 32 is sent at
power-on (init step 6) and re-sent whenever `B0CE.b3` is set — an AMS/digital-setup change.

### 7. Corrections / refinements to I13 and I4

- **I13 §3 / caller table.** I13 listed `0x05A1BE` callers as the TX-start routine "`0x035872`" and
  `0x035EEE`; confirmed, and the chain above it is now named: `sub_35872 ← sub_34A52 ← sub_34966 ←
  sub_34538 ← sub_2070`, with the **PTT at `0xFFFF4D` b3** (`0x034984`) as the actual user input.
  I13 called `0x0359A8` "`AAD4.b0`" and `0x0359C8` "`B0CC.b0`"; confirmed as the dispatcher's own
  selector tests inside `sub_35872` (`0x0358CA`/`0x0358D4`), not separate callers.
- **I13's `0x06D052` (B0BE=0x17)** — confirmed its callers are the RX message-decode engines
  (`sub_62xxx ← sub_60656`), i.e. this session is an **automatic reply to a received message**, not
  a UI action. (I13 said "message engine"; this sharpens it to: receiving triggers a TX.)
- **I13 §4 opcode-12 note "r2l (0, 2 or 3)".** The 0/2/3 and the extra `4/'B'/'C'` come from
  `sub_593C8`, gated on `FF8EA0` b4/b6/b7 and `FF8D20`/`FF8DD5`/`FF94C0`; byte[2] low bits carry
  this, not byte[1]. Byte[1]'s b7 is `NOT B0AA.b0` (settings-dirty), confirmed.
- **Opcode 11 full field map** (I13/H15 gave "~20 setting bytes `FF8E20`–`FF8E36`"): the exact
  per-byte packing and the exclusion of `FF8E2B`/`2C`/`2D` are now in `opcode-11-12-32-payload.tsv`.
- No disagreement with I4.

## USB relevance

- **Q1 (USB): none.** The entire TX-source chain (`sub_2070`, `sub_34538`, `sub_34966`,
  `sub_35872`, the builders, the request senders) touches no USB register (`0xFFEE00`–`0xFFEE53`)
  and never enters the closed window. The only external keyer is the **SCI-A** node link, not USB.
- **Q2 (SDR): unchanged no.** Keying up drives the fixed session scripts; the densest payload is
  still the 96-byte `0x16`/`0x19` frame. No TX path requests or streams samples.
- **Q3 (DSP reachability): bounded.** The radio keys the DSP from exactly two external-controllable
  places — the hardware PTT, and node-mode host command `0x11` (`sub_73E58`, SCI-A). Everything
  else is a fixed single-frame config request or the automatic `0x17` reply. The config frames
  11/12/32 carry only persisted setting bytes as opaque fields; the opcode is always firmware-
  chosen. There is still **no generic "send arbitrary opcode" entry** from any UI or host path
  (the only index-to-builder table, `0x05A3CE`, is dead — H15).

## Open

1. **SUB F3xx→label decode** for F3A3 (`FF8AA0`) and F3AB (`FF8ABD`), and the `FF8E20`–`FF8E36`
   block, to put human names on the 11/32 payload. This is the one missing piece; it is a SUB-side
   task (doc 32 #1) and needs the SUB setup-label routing, not MAIN.
2. **The `0x17` auto-reply trigger.** Decode which received message classes/letters in
   `sub_60656`/`sub_62xxx` arm `sub_6D052`, to state exactly which inbound messages make the radio
   transmit unattended. Owner-relevant (unattended keyup).
3. **Confirm the PTT pin.** `0xFFFF4D` b3 is Confirmed as the gate; tie it to the schematic/pin to
   upgrade "PTT" from Inferred to Confirmed, and check whether `FF956D` (the inhibit timer at
   `0x03497C`) is the TOT or a debounce.
4. **`B0CC` byte semantics.** `B0CC.b0` selects the `0x15`/`1C 03` session; decode the full `B0CC`
   byte written by `sub_2DCE`/`sub_73AFE`/`sub_74396` to name that TX mode.

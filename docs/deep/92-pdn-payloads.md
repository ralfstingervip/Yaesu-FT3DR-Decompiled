# WIRES-X / PDN framed protocol — H / R / W / E / F / S payload layouts (MAIN, SCI-A)

## Verdict

The DATA-jack framed protocol (SCI-A `0xFFFE90`, `0x01`|letter|4-hex-len|data|`0x04`|2-hex-cksum,
38400 8N1, armed only when `0xFF8DDE != 0`) is the **WIRES-X portable-digital-node (PDN) / HRI-200
node link**. Its full frame grammar and the byte layout of every letter are now recovered. The three
things doc 14 Open #2 asked are answered:

1. **Field layouts recovered** for all frame types: `V`/`M`/`B`/`C`/`P`/`N`/`E`/`F`/`S`/`W`/`H`/`R`/`G`.
   Builders/parsers, RAM sources/sinks, and the `0xFEE000` DMA staging all cited below.
2. **The `R` 97/137/187-byte frames do NOT carry the on-air DV DATA payloads.** They carry the
   **AMBE+2 vocoder bitstream** — 45/65/90 raw bytes (DT0/DT2/DT3) hex-encoded. `R` is exactly the
   DSP→host half of doc 52's `0xFF8DDE` codec relay (DSP opcodes `0xAC`/`0xAD`/`0xAE`), and `E` is
   the host→DSP half (opcodes `0x0C`/`0x0D`/`0x0E`). The on-air DV DATA *messages* are relayed on a
   **different** letter, `G` (and the heard-station header on `H`). So doc 14's hypothesis ("if the
   `R` sizes match the air-frame sizes, PDN relays the same DV DATA") is **refuted**: `R` is voice
   codec, not data. (Confirmed.)
3. **Direction + accept table built.** The radio accepts `V M B C N E F S W`; it emits (solicited or
   not) `V M B C P N E F S W H R G`. Exactly one accepted framed letter can request TX: **`S` with
   `p0` bit 0 = 1 keys the transmitter** (`sub_2244C`, `0xFF94C0 = 1`), and it transmits whatever
   `E`/`F` loaded. This reconciles with J9 ("SCI-A host link keys the radio"): besides `S`, the
   non-letter node command byte `0x11` (`sub_73E58 → sub_34A52 → sub_35872`) and the host data
   session `0x16` (`sub_6CF30`) also key TX. `M` retunes but does not key.

No image was modified; nothing was connected to a radio. MAIN sha256 `8e3ecd05…`, SUB `b93570b3…`.

## Method

Private DB `K10_PDN`, seeded `--copy-from ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64` (h8sxa),
driven through `run_job.py` with `ida\jobs\k10_dump.py` (a copy of `i5_dump.py`; range dumper +
xref + abs16/abs32 access scanner). Passes dumped and read, all outside the closed window
`0x078106`–`0x07B753`:

- `0x06B700`–`0x06D200` the whole host-link handler (frame assembler, gate/data coroutine, every
  letter builder/parser, the hex and checksum helpers, `sub_6CF30`/`sub_6D052` session starters);
- `0x073400`–`0x074900` the node command dispatcher `sub_73E58` and the SCI-A↔module transport
  (`sub_7374A` etc.), plus `0x0037C8`–`0x003A80` the node-mode main loop;
- `0x010100`–`0x010310` the power-on held-key mode-select table (`0x10242` pointers) that reaches
  the two `0xFF8DDE` setters;
- `0x025E80`–`0x026400` the `M` parser (`sub_25EAE`/`sub_2611A`) and `W` position formatter
  (`loc_261FA`, `loc_26196`);
- `0x05BA22` (host→DSP codec sender), `0x05EA3A` (message relay `FEF920`→`FEFD72`), `0x068E9A`
  (data-message relay into `FEFD72`), `0x06C402` (DSP→host codec accept);
- `0x022400`–`0x022800` the TX keyer `sub_2244C` / stop `sub_22718`.

Byte scan (`K10_ACC`) of every abs16/abs32 reference to the 34 protocol RAM cells and staging
buffers → `ida\out\pdn-payloads\work\acc_a.tsv`. Every template and table byte-verified against the
image directly. ~40 cited byte runs re-read from disk.

Not covered: the SUB-side WIRES-X search/connect UI (doc 14 §4 already has it); the on-air C4FM
modem (PROTOCOLS/doc 11 scope); DSP firmware semantics (absent from package). `sub_73E58`'s full
node command map beyond the TX-relevant `0x11`/`0x12` was read but only the keyer arms are decoded.

## Findings

### 1. Frame grammar (confirms doc 14 §4 / pc-01, no change)

`[0]=0x01` SOH · `[1]`=letter · `[2..5]`=N as 4 ASCII-hex nibbles (`sub_6CB5E`, stored `0xFFB3CA`) ·
`[6..5+N]`=payload · `[6+N]=0x04` EOT · `[7+N][8+N]`=2 ASCII-hex of the 8-bit additive sum of bytes
`[0]..[6+N]`. Total `N+9`. Assembly buffer `0xFF1AC8`; replies DMA'd from `0xFEE000` to TDR
`0xFFFE93` by DMAC ch2 (`0x06B92E`–`0x06B97E`), finalized by `loc_6CC76` (sum → 2 hex at tail).
Hex pair decode `sub_6CB40`; byte→hex `sub_6CC04`; the three copy-with-hex helpers are `sub_6CBAE`
(decode run), `sub_6CBDA`/`sub_6CC22`/`sub_6CC4A` (encode run, 1/2-wide).

The accepted-letter dispatcher is `sub_6BAC8` at `0x06BAD6`: `B C F E S N W V` (and `M` in the gate
coroutine `sub_6B9AC` at `0x06B9FE`). Full byte layouts: `ida\out\pdn-payloads\pdn-frames.tsv`.

### 2. H — periodic status / heard-station, 30 data bytes (Confirmed)

Builder `sub_6C19A` (`0x06C19A`). The template `0x06C5CA` (`01 'H' "001E"`) supplies the 6-byte
**frame header** (SOH/`'H'`/`"001E"`) into `0xFEE000`; the 30-byte payload starts at `0xFEE006`:
- `p0..p7` eight FICH/CM/DT nibbles bit-packed from the 6-byte heard record `0xFFB3BE` by
  `sub_6C10A` (`0x06C10A`): `p0=((b0&0x30)>>2)|'0'`, `p1=((b0&0x0C)>>2)|'0'`, `p2` from `b2&0x38`,
  `p3` bit of `b2.2`, `p4=b2&3`, `p5` bit of `b3.7`, `p6..p7` = hex of `b3&0x7F` (`sub_6CC04`);
- `p8` = `FEEB28` (voice-mode tag `'0'`/`'1'`/`'2'`), `p9` = `FEEB29`;
- `p0A..p1D` = 20 bytes from `0xFEEB14` (the decoded callsign/radio-ID block).

`FFB3BE` (6 B) and `FEEB14` (20 B) are filled by the DSP→host header relay `sub_6C200` (`0x06C24A`:
`rx[1..6]→FFB3BE`, `0x06C2A0`: `rx[7..26]→FEEB14`), tags `'1'`/`'2'`/`'3'` from CSD1/2/3 states
(doc 52 §7c). So **H carries the decoded C4FM header + callsign block of the currently heard
station** (FICH frame-info/CM/DT fields re-encoded as ASCII nibbles). Unsolicited: sent when
`B3D7.b7` is set.

### 3. R — vocoder-bit relay, 97/137/187 data bytes (Confirmed; refutes doc 14 guess)

Builder `sub_6C344` (`0x06C344`). It reads slot type `0xFEEAAC` and branches to one of three sizes
(`0x06C352`/`0x06C356`):

| FEEAAC | raw bytes | hex payload N | template | selector char p0 |
| --- | --- | --- | --- | --- |
| 2 (DT2) | 0x41=65 | 0x89=137 | `0x06C5D8` `R0089` | `'A'` (0x41) |
| 3 (DT3) | 0x5A=90 | 0xBB=187 | `0x06C5E0` `R00BB` | `'Z'` (0x5A) |
| else (DT0) | 0x2D=45 | 0x61=97 | `0x06C5D0` `R0061` | `'-'` (0x2D) |

The raw block is read from `0xFEE944` and hex-encoded with `sub_6CC4A`. Those 45/65/90-byte blocks
are written by the DSP→host accept routine **`sub_6C402`** (`0x06C40E`: accepts DSP opcode in
`FFB0E0` only when `0xAC ≤ op < 0xAF`), i.e. the `0xAC`/`0xAD`/`0xAE` codec frames. This is exactly
doc 52 §5's host-link codec relay — the lengths `45/65/90` come from the same table
`0x05BBD6 = 2D 00 41 5A` and the opcodes from `0x05BBD2 = 0C 00 0D 0E`. The DT0/DT2/DT3 sizes are the
C4FM V/D-mode-1 / V/D-mode-2 / Voice-FR **vocoder (AMBE+2) bit** payloads, not data-channel blocks.

**Cross-check against docs 56/11 (answer to task 2): Confirmed NOT the same payloads.** The on-air
DV **DATA** structures per doc 56 are the 20-/10-byte data-channel blocks (`A9`/`AA`, `0xFEF926`/`3A`
slots) and the ≤1,040-byte reassembled data message (`0xFEF962`). Those reach the PC on **`G`** (via
`sub_5EA3A`/`sub_68E9A`, copying `FEF920`→`FEFD72`, `FEFD72` is `G`'s source at `0x06C09E`), and the
header on **`H`**. The `R` 97/137/187 sizes derive from the codec bit counts (72/104/144 bits ×5
slots → 45/65/90 B), not from any data-block size. So the PDN link carries both the codec stream
(`E`/`R`) and the data/header (`F`/`G`/`H`), on different letters — HRI-200-style audio-over-the-node
plus DV data relay.

### 4. W — position/route record, 72 data bytes (Confirmed layout, field names Inferred)

Template `0x06C602` (`01 'W' "0048"`); 0x48 = 72. Builder: `sub_6C3DE` eepmov's the 72-byte template
into `0xFEE000+6`, then `loc_261FA` (`0x0261FA`) overwrites the live fields. Byte map (payload index
`p`, staging `0xFEE006+p`):

- `p0` = `'2'` (record/format tag).
- `p1..10` latitude `"DDDD.DDDDD"` — filled by `loc_26196` from a 4-byte packed source (`sub_26196`
  nibble-expands 5 BCD bytes into `0000.00000` positions, source `er0+0x1A` or `er0+0x42` chosen by
  `er0+0x46` bit 0 at `0x0261FA`).
- `p13` lat/`'-'` sign at `FEE013` (`0x026236`); longitude `"DDD.DDDDD"` at `p14..` from the second
  `loc_26196` call (`0x026246`, source `er0+0x1E`).
- `p1D` (`FEE01D`) DG-ID/flag bit from `er0+0x12` bit 5 (`0x026252`).
- `p20..21` (`FEE026/27`) = `0xFF8ED7` DG-ID as 2 hex (`0x026266`).
- `p22` (`FEE028`) symbol byte, table `0x0262E0` (`"3210"`), index `er0+0x13` (`0x02628E`).
- `p23..42` (`FEE029..`) 32-byte block copied from `0xFEE009` (`eepmov #0x20`, `0x0262A6`) — the
  formatted lat/lon text re-used as the route/comment field.
- `p44` (`FEE04A`) = `(FF8DDF & 1)|'0'` (`0x0262BE`), `p47` (`FEE04D`) = `FF8DE0.b7` bit (`0x0262CE`).

So `W` is a GPS position + DG-ID + APRS-style symbol record. In mode B it is emitted at state 3 of
the position state machine (jump table `0x06BD26`, `B3E4`), and the PC acks it with an inbound `W`
(`p0=='0'` advances `B3E4` 3→4, `0x06BD0A`). (Field *names* Inferred from format; byte sources
Confirmed.)

### 5. E / F / S — the host-controlled TX load/key path (Confirmed)

- **`E`** (`sub_6C850`, `0x06C850`): host supplies a DT char in `p0` and 45/65/90 hex bytes; parser
  hex-decodes into slot ring `0xFEE944 + s·len` (`s = FFB3E3`, 0..3), with the per-slot DT at
  `FEEAAC[s]`, aux bytes at `FEEAB0[s]`/`FEEAB4[s]`. `sub_5BA22` then feeds one 96-byte frame to the
  DSP per `0x9A` pacing request, opcode from `0x05BBD2`. This is the host→DSP codec injection — a PC
  can push arbitrary vocoder bits into the transmitter.
- **`F`** (`sub_6C686`, `0x06C686`): loads a 60-byte on-air header (`p0x08..0x44 → 0xFF0BFC`,
  `0x06C6D2`) plus a hex data body of `(N−0x44)/2` bytes, capped `0x40C`, into `0xFF0C38`
  (`0x06C704`); subheader fields `p0..5` are bit-packed to `0xFF0BF6/F8/F9` by `sub_6C7D8`. In
  mode A it also gates on a 5-byte callsign/ID at `p+0x45` matching `0xFF0C33` when transmitting
  (`0x06C6A0`).
- **`S`** (`sub_6C8E8`, `0x06C8E8`): `p0` bit 0. Bit set → `0x06C982 bset #0,@AAD4` then
  `sub_6CAF8`/`sub_5C468` → `sub_2244C` keys TX (`0xFF94C0 = 1` at `0x022542`). Bit clear →
  `sub_22718` stops TX. **This is the only accepted framed letter that keys the radio.**

### 6. Node command keyers (not framed letters; reconciles J9)

`sub_73E58` (`0x073E58`), the node command handler reached from the SCI-A/module transport
`sub_739FA` (jump table `off_74472`, index `FF97FC`), runs only while `FF94C0 == 1` and keys on
command byte `r1h`: `0x11 → sub_34A52 → sub_35872` (TX start, `0x073E66`), `0x12 → sub_350E4`
(stop), `0x17` range → auto-reply bookkeeping (`0x073EB4`). The host data session `sub_6CF30`
(`0x06CF30`, reached from `sub_1079E` dispatch) forces `B0C7 = 2`, calls `sub_5A1BE`, then sets
`B0BE = 0x16` — the PC-driven header+block push J9 flagged. All three confirm J9's "SCI-A host link
keys the radio": the keyers are `S` (framed), node cmd `0x11`, and session `0x16`.

## USB relevance

- **Q1 (USB).** None directly — this protocol lives on **SCI-A `0xFFFE90` (DATA jack)**, not USB.
  It confirms that the radio's externally-reachable TX-control and codec-relay surface is on the
  serial DATA jack, independent of the USB vendor/CDC device. No new USB endpoint.
- **Q2 (USB SDR).** Reinforces "no". The densest the PDN link carries is the codec bit relay (`E`/`R`:
  45/65/90 B per voice slot, ~7.2 kbit/s of already-compressed AMBE+2) — the same ceiling doc 52
  found. No frame on this link carries PCM, raw samples, or IQ; `R`'s payload is vocoder bits read
  from a fixed 90-byte RAM block (`0xFEE944`), not a sample stream. The sample source behind the DSP
  is still absent.
- **Q3 (DSP reach).** The PDN link is the one runtime path that puts **external bytes inside DSP
  frames**: `E` → host→DSP opcodes `0x0C`/`0x0D`/`0x0E`, and `F` loads the on-air header/data. But it
  is a fixed codec-bit + data relay chosen from a 4-entry table, not a generic DSP command channel,
  and the version still comes only from the DSP's own `0x9F`. A PC in node mode can key the radio
  (`S` p0.b0=1) and drive its C4FM voice/data transmission — an owner-relevant external TX control.

## Open

Most valuable first.
1. **Decode the node-command jump table `off_74472` (index `FF97FC`) fully** — `sub_73E58` is only
   one entry; the table at `0x074472` holds the rest of the node protocol (the `AH72M` handshake at
   `0x0737C8`, connect/disconnect commands). This is where the PDN *link-layer* (vs the framed CAT
   layer) lives.
2. **Name the `C`/`P` status-lo digit values** (`sub_6BB6E`, chars `0/1/2/3/4/6/9/D`) against the
   SUB connect-result renderer `sub_FFF0B84D` states (`0x09` Connected … `0x0D` Not Connected) —
   they look like the same connection-state code surfaced on the wire.
3. **Confirm the `H`/`FFB3BE` nibble packing against the C4FM FICH field spec** (doc 11) to label
   FI/CM/DT/BN/BT precisely.
4. **Trace `W`'s `er0` source struct** (`er0+0x12/13/1A/1E/42/46`) to the GPS/position RAM to name
   the lat/lon/course/altitude fields with certainty (currently Inferred from the ASCII format).

Machine tables: `ida\out\pdn-payloads\pdn-frames.tsv` (per-letter byte layout, builder/parser,
evidence), `pdn-direction.tsv` (send/accept, TX-request, effect). Raw listings under
`ida\out\pdn-payloads\work\`.

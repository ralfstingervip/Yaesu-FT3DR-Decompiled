# Protocols: on-air DV layer, host control grammar, and the boot-read question

Agent PROTOCOLS (deep-pass item 11). Owner-side static analysis of the two
decrypted radio images and cross-reference to the host-side findings in doc 10.
No device was touched. Private databases `PROTO_MAIN` (h8s300a) and `PROTO_SUB`
(rx); the prior full pass (1298/1575 MAIN funcs force-coded, 237k SUB operands)
is reused via `ida\out\protocols\main_operands.tsv` / `sub_*.tsv` and the binary
is read directly. Machine-readable summary: `ida\out\protocols\protocol_findings.tsv`.

## Verdict

**The on-air C4FM / System Fusion framing is not in either image — it lives in
the external DSP — and what static analysis of MAIN/SUB actually reaches is the
analog-signalling and control layers around it.** An exhaustive symbol/sync
sweep (5.24 MB, every bit offset, 172 probes per pattern) finds **no** YSF, DMR,
P25, D-STAR, NXDN or dPMR frame-sync constant above the noise floor, and the
"FEC polynomial" and "AMBE deinterleave" hits the interim scan collected are
false positives (ordinary `add #1021h,sp` immediates; byte coincidences inside
SUB's display-resource region). The DV bit-processing — sync, Golay/FEC,
interleave, AMBE — is delegated to the DSP on MAIN's SCI-C (BRIEF corr #6, doc
06), and MAIN speaks to it with a short ASCII command set (`CPU>DSP: STOP
ENCODE`, `CPU>DSP:VER?`, `DSP>CPU: DATA TEXT SET`, `TERM TX/RX`, `0x5AF10`). What
**is** in MAIN, confirmed byte-for-byte, is the analog-subaudible layer — the
standard **50-tone CTCSS table** (`0x35158`) and **104-code DCS table**
(`0x5072`), each with its consumer routine — plus DTMF, and the digital-data
application layer: **APRS** (3.5 KB symbol table, Mic-E/addressee/beacon strings,
`$GPRMC`/`$GPGGA` NMEA, an AX.25-FCS packet cluster).

**The host-facing control protocol is a Yaesu clone/CAT ASCII grammar on the DATA
jack, and it is distinct from the boot updater.** Frame builder `sub_6B77E`
wraps single-letter ASCII opcodes (`V B E F S N C P H R W`) carrying fixed-width
hex fields, terminated by `0x04` (EOT) with an 8-bit additive checksum at
`0xFFB3DC`. The `R` opcode is a **read/query** (`sub_6C344` returns canned radio
state as ASCII hex), `W` writes, `V` returns identity (`V0030FT3D…20180418…0C01`,
and a cross-model `V0020FT2D`). SUB carries **no** serial/CRC/protocol role at
all (no SCI, no CRC unit, USB0 dark) — the whole radio-protocol surface is MAIN's.

**Boot-ROM read question (RESUME-DEEP open #3):** From the files, a read command
is supported **only by the host DLL, and only on its debugger path** —
`RComms.dll`'s `ULE_ReadMemory` (`0x1000C5F0`, cmd `0x80070000`) is part of the
Renesas **on-chip-debugger** (E8a/E10A) protocol, gated by `IsSupportedDevice`
(`0x1000AB40`) to emulator PIDs `0x8233`/`0x8236`, never the radio's `045B:0025`,
and unreachable from the updaters. The **shipped serial boot-loader protocol the
radio speaks is write-only** (verify-by-checksum, `0x4B`/`0x4D`; doc 10).
**Whether the radio's own mask-ROM boot loader would answer a read is Unknown and
not determinable from this package** — that ROM is on-chip and is not in these
images (the decrypted files are application flash), and settling it means issuing
a command to a device, which this effort does not do.

## Method

- **Sync / symbol sweep.** `sync_sweep.tsv` (2.4 MB) and `sync_sweep2.tsv`: every
  published DV frame-sync pattern (YSF, DMR BS/MS/TDMA, P25, D-STAR, NXDN, dPMR,
  plus M17/POCSAG/FLEX controls) searched over MAIN+SUB (5,242,880 bytes) at all
  8 bit offsets, packed/per-byte/per-nibble forms, and a 4FSK dibit-mapping sweep
  (all 24 permutations, both orders). Summaries in `sync_sweep_summary.txt`,
  `sync_sweep2_summary.txt`.
- **Table verification.** CTCSS/DCS tables read directly from
  `decrypted\FT3D_MAIN_ver102_EXP.bin` with `xxd` and decoded by hand.
- **Consumers.** From the full operand cross-reference `main_operands.tsv`
  (8 MB, every immediate/mem/displ operand in `0x2000–0x80000`) I resolved who
  loads each table base and dumped the consuming routines' operands. Command
  templates and their builder functions found the same way.
- **String scan.** `PROTO_MAIN_strings.tsv` / `PROTO_SUB_strings.tsv` and
  `PROTO_*_kwhits.tsv` for protocol vocabulary (APRS, NMEA, DTMF, WIRES-X, CAT).
- **SUB peripheral use.** `sub_periph_refs.tsv` bounds SUB's role.
- **Part C** cross-references doc 10 (HOST-USB) and doc 09 lead; no new host pass.
- **Not done / limits.** No fresh IDA pass this session: this checkout is
  relocated to the repository root, so `run_job.py`'s hard-coded
  `ROOT=.` and `proto_lib.OUT` are stale and a `--reopen` would miss the
  DB / write to the wrong tree; patching shared infra while nine agents run in
  parallel was not worth it when the prior pass's tables plus direct binary reads
  already carry the evidence. The FIR-coefficient consumers were not pinned
  (accessed via base+displacement, not a bare immediate). The DSP wire framing is
  doc 06's; I cite it, I do not re-derive it.

## Findings

### A. On-air / digital layer

**A1. No DV framing constants in either image — Confirmed (negative).** Over the
full 5.24 MB, YSF FT frame sync (40-bit) = 0 hits, all DMR syncs = 0, P25 FS = 0,
D-STAR syncs = 0, NXDN FSW = 20 vs 40 expected (below floor), dPMR = 0–2.
Everything that scores above zero (M17 `FF5D`, NXDN `5757` preamble, DMR EMB
null) is a short pattern sitting at or near its random expectation in an image
this size, i.e. noise; and M17 postdates the 2018 firmware. This is the expected
result once BRIEF corr #6 is taken seriously: the C4FM modem (sync, FEC,
interleave, AMBE) is in the **external DSP**, not in MAIN or SUB. MAIN drives it
over SCI-C with the ASCII control set at `0x5AF10` (`CPU>DSP: STOP ENCODE`,
`CPU>DSP:VER?`, `DSP>CPU: DATA TEXT SET`, `DSP>CPU: TERM TX`, `DSP>CPU: TERM RX`)
— voice/data DV frames are a DSP responsibility (detail: doc 06).

**A2. CTCSS 50-tone table — Confirmed.** `MAIN 0x35158` (file `0x35158`), 50 ×
`u16` big-endian = frequency × 10 Hz:
`0x029E`=670=**67.0 Hz** … `0x0885`=2181=218.1 … `0x09C7`=2503=250.3 …
`0x09ED`=2541=**254.1 Hz**. Exactly the standard 50-tone CTCSS set. Consumer
`sub_34BCA` at `0x34BFA`: `and.l #0xFF; shll.l er3` (index × 2) then
`mov.w @(0x35158:32,er3), r4`, storing the result to `0xFFFFAAB4` and setting a
strobe bit at `0xFFFFAAD2` — the **CTCSS-encode tone programmer**.

**A3. DCS 104-code table — Confirmed.** `MAIN 0x5072` (file `0x5072`), 104 ×
`u16` BE holding the octal DCS code as BCD: `0x0023`=**023** … `0x0754`=**754**
(104 entries, the Yaesu DCS set). Consumers `sub_D13E` (at `0xD1EC`) and
`sub_25EAE` (at `0x2608E`), both `mov.l #0x5072, er5` — the tone/DCS setup and a
second reader; the `Data  Freq  TONE/DCS  TONE REF` menu string is at `0x0D16D`.

**A4. DTMF — Confirmed.** `MAIN 0xC8BE` `": DTMF -"` and the 16-symbol alphabet
`DTMF -0123456789ABCD*#` (`0xC8CC`); handler window at `sub_C814`.

**A5. The interim "FEC/interleaver" tables are not on-air FEC.** Three separate
false leads, each resolved:
- *Polynomial constant scan* (`fec_constants.tsv`, `sub_crc_poly_refs.tsv`) —
  **Not found as FEC.** The `0x1021` "CRC-CCITT" hits disassemble to
  `add #1021h, sp, r8`; `0x43` hits are `rtsd #43h`; `0x8408`/`0xC75`/`0x8005`
  land at or below the arithmetic noise floor (e.g. `0x1021` appears 814× in 4 MB
  of SUB). No Golay or CRC generator is confirmed by constant.
- *"AMBE 49-bit deinterleave" matches* (`fec_tables.tsv`) — **coincidental.**
  Hundreds of hits, clustered in `0xFFC00000–0xFFC36000` and spaced ~2 bytes
  apart (impossible for one real table), inside the region doc 01 (SUB-LOWER)
  established as display resources. No AMBE table exists here — consistent with
  the vocoder being an external chip.
- *Permutation tables* (`struct_tables.tsv`) — **real tables, wrong purpose.**
  `SUB 0xFFF508F8` is a 62-entry **JPEG zig-zag scan order**
  (`00 01 08 10 09 02 03 0a 17 …`) consumed by JPEG-decode routines
  `sub_FFF4B084`/`sub_FFF4C57B`/`sub_FFF4F29D` (camera/display). `MAIN 0x5DF52`
  (126 bytes) is consumed by `sub_68276` (at `0x682DC`), which is an ASCII
  character classifier (`cmp #'0'/#':'/#'A'/#'['/#'a'`) — a **text-entry / keypad
  character map**, not an interleaver. The rest are identity/rotation tables.

**A6. FIR coefficient tables — Inferred (audio).** `MAIN 0x42966–0x42FBE`
(`filter_candidates.tsv`) are symmetric, linear-phase 11/13/15-tap integer
arrays — audio/subaudible signal conditioning around the CTCSS/audio path.
Consumers not pinned this pass (loaded via base+displacement). Tangential to the
protocol question; noted, not claimed as framing.

**A7. System Fusion mode logic — Confirmed (UI/mode only).** `MAIN 0x5D279`
`Voice&Data CT=1`…`CT=5`, `0x5D2E5` `Extend Voice1`/`YAESU`; `DN`/`VW` labels
image-wide; DG-ID and WIRES-X strings (`0x8264` `WIRES-X`, `WIRES-X NODE`,
`WIRES-X DIRECT`, `WIRES-X PDN`). These are mode selection and UI — the framing
they select is executed in the DSP.

### B. Host-facing control protocol (DATA jack) — distinct from the boot updater

The DATA-jack (accessory/PC) serial channel carries a Yaesu **clone/CAT ASCII
protocol**. MAIN-FULL (doc 04, RESUME open #2) owns the per-opcode dispatch and
the 9-byte binary frame header; my contribution is the **byte-level grammar and
the command/response strings**.

**B1. Frame wrapper — Confirmed.** `sub_6B77E` builds the frame; the 8-bit
additive checksum accumulator is `0xFFFFB3DC`, read-modify-written at
`0x6B874`/`0x6B87A`/`0x6B88A`. Records terminate with `0x04` (EOT) — visible both
in the response builders (`mov.b #4, r4l` before the finaliser, e.g. `0x6C3D4`)
and in the template bytes below.

**B2. Command/response grammar — Confirmed.** Template block at `MAIN 0x6C539`
(raw), each `= <ASCII opcode><fixed hex fields> 04 [00 01|01]`:

| Opcode | Template (ASCII) | Meaning |
| --- | --- | --- |
| `V` | `V0030FT3D … 201804180 … 0C01` | identity / version (build 2018-04-18, ver 0C01) |
| `V` | `V0020FT2D    JPN     Ver0202 20180418` | **cross-model FT2D** identity also present |
| `R` | `R00610` / `R00892` / `R00BB3` | **read / status query** |
| `W` | `W0048` + position payload (`…000000.00000+000.00000…`) | write / set (e.g. GPS position) |
| `B E F S N` | `B00010` … `N00010` | fixed-field commands |
| `C P` | `C000B00000000000` / `P000B0…` | 11-byte-field commands |
| `H` | `H001E` | command |

**B3. The `R` read handler — Confirmed.** `sub_6C344`: clears a status bit at
`0xFFFFB3D7`, reads a mode byte at `0xFEEAAC`, and by its value (2/3/default)
selects one of `R00892`/`R00BB3`/`R00610`; it then reads radio state bytes
(`0xFEEAB0`, …), converts them to ASCII hex (`sub_6CC04`), assembles the reply in
RAM at `0xFEE000`, and appends `0x04`. So `R` is a **structured status query, not
an arbitrary memory peek** — it returns a fixed set of state fields as ASCII.
(RESUME notes a separate response path `0x6B91A` that can arm DMA ch2 from
`0xFEE000` out the serial port, and `0x6B7DC` that software-resets MAIN; those
are MAIN-FULL's to characterise.)

**B4. Application-layer protocols on the DATA jack — Confirmed / Inferred.**
- **APRS — Confirmed.** 3543-byte symbol-description table at `0x437C0`;
  addressee/message/beacon vocabulary at `0x5039E`
  (`APCQ … MICE RTCM TEST DRILL SPACE BEACON`); `TNC Strm.Switch` strings.
- **NMEA-0183 GPS — Confirmed.** `$GPRMC,…` template `0x463E6`, `$GPGGA,…`
  `0x4642E`, sentence tags `%PGGA`/`%PRMC` at `0x47CA0`/`0x47CAA` — position
  source for APRS beacons.
- **AX.25 FCS — Inferred (strong).** Packet-handler cluster `0x48C44–0x539A0`;
  the reflected CRC-CCITT/AX.25 poly `0x8408` appears at `0x494AA`/`0x49894`
  within it. APRS rides AX.25 UI frames; the string evidence is decisive, the
  constant is corroborating.
- *Not present:* **no KISS TNC** — the `KISS-FM` hits (`0x41C5E`, `0x41C8A`) are a
  Japanese FM-broadcast preset name in the radio's FM station list, not the KISS
  framing protocol.

**B5. SUB has no protocol role — Confirmed.** `sub_periph_refs.tsv`: SUB touches
IO ports (252), TPU (42), DMAC/DTC (35), 12-bit ADC (29), CMT (9) and USB0 (1 —
the module-stop bit, USB0 dark per doc 03). **No SCI, no CRC unit, no RSPI/SSI.**
SUB is the display/graphics/JPEG processor; the entire on-air and host-control
surface is MAIN's.

### C. Does the radio's boot ROM answer a READ? (RESUME-DEEP open #3)

Separating the two protocols the package contains is the whole answer:

**C1. The shipped serial boot-loader protocol is write-only — Confirmed (files,
doc 10).** Neither the H8S nor the RX updater state machine implements a
memory-read command; both verify by a device-computed checksum (`0x4B` on H8S,
`0x4D` on RX), never read-back. HOST-USB enumerated every packet builder to reach
this.

**C2. The only read primitives in the package belong to the debugger protocol,
not the boot loader — Confirmed (files, doc 10).** `RComms.dll` carries
`ULE_ReadMemory` (`0x1000C5F0`, command `0x80070000`) plus E7-read
(`0x80050000`) and H-UDI read (`0x80110000–0x80140000`). These are the Renesas
**on-chip-debugger (E8a/E10A)** command family — a different protocol from the
serial boot loader the radio speaks. They are gated by `IsSupportedDevice`
(`0x1000AB40`) to emulator PIDs `0x8233`/`0x8236`, `ScanPorts` (`0x1000A660`)
hard-codes `045B:8236`, and nothing in either updater references any `ULE_*`.
So the read capability that exists on disk is **host-side, emulator-only, and can
never be aimed at the radio's `045B:0025` boot device.**

**C3. Whether the radio's mask-ROM boot loader itself implements a read —
Unknown, not determinable from this package.** The on-chip boot loader is
**not** in these files: the decrypted images are application flash
(`0x000000–0x0FFFFF` H8S, `0xFFC00000–0xFFFFFFFF` RX), while the boot loader lives
in separate on-chip mask ROM that no updater resource contains. Its command
dispatcher therefore cannot be read here. Deciding it means sending a read frame
to a device and observing the reply — out of scope, and no device is touched.

**C4. Nuance the owner should keep.** A read *does* exist in the **application**
firmware — the DATA-jack `R` query (B3) — but that is the SCI serial port during
normal operation, it returns only canned status fields (not arbitrary flash), and
it is a different physical path from the USB boot device. "The radio can be
queried" is true for the running application, false for the shipped USB boot
path, and Unknown for the boot ROM.

## USB relevance

- **Q1 (everything USB).** The protocol layer adds no new USB surface. The DV
  framing is off-CPU (DSP), the tone/APRS/CAT layers ride the DATA-jack **SCI**,
  not USB, and SUB's USB0 is dark. The only USB-borne protocol remains the boot
  updater (doc 10) and MAIN's two application USB stacks (doc 05). The DATA-jack
  CAT `R`/`W` grammar is the radio's non-USB external control API and is
  independent of the `26AA` USB personalities.
- **Q2 (USB SDR).** Nothing here changes the answer, and it removes a distraction:
  there is **no IQ/sample framing, no wideband-capture protocol, and no
  sample-transport table** anywhere in MAIN or SUB — the only signal-domain
  constants are subaudible tone tables and narrow audio FIR taps. The on-air
  sample processing that would feed an SDR path is in the DSP, reachable only over
  MAIN's SCI-C control link, which moves DV frames, not raw IQ.
- **Q3 (DSP/vocoder).** Reinforced: no AMBE/FEC/sync framing in either image, an
  explicit `CPU>DSP` ASCII control vocabulary (`0x5AF10`), and no DV constants —
  all consistent with doc 06's finding that the vocoder is an external DSP on
  SCI-C with proprietary framing, not reachable from the PC.

## Open

Most valuable first.

1. **Pin the CAT/clone opcode semantics (MAIN-FULL's table).** I have the grammar
   and the `R`/`W`/`V` builders; the full `B E F S N C P H` field meanings and the
   `0x6B91A` DMA-dump / `0x6B7DC` reset paths decide how much the DATA-jack API
   exposes. If any opcode reads arbitrary RAM/flash as ASCII hex, that is a
   file-derivable read path into the running radio (contrast with C).
2. **Confirm the AX.25 FCS routine** at `0x48C44–0x539A0` by disassembling the
   `0x8408`-referencing functions (`sub_49476`/`sub_4986A` cluster) — turns the
   APRS-over-AX.25 inference into a confirmed CRC implementation.
3. **Characterise the DSP ASCII control link** (`0x5AF10` strings, SCI-C at
   `0xFFFF88`) end-to-end — doc 06 owns this; it is the real "digital protocol"
   the radio implements internally and the only route toward the vocoder.
4. **Pin the FIR-coefficient consumers** (`0x42966–0x42FBE`) if the audio/CTCSS
   filter chain matters; low priority for the protocol question.
5. The boot-ROM read (C3) is answerable only on hardware and is deliberately left
   as Unknown; if a device is ever in scope it is a single-frame experiment.

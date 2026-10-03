# Receive-side CTCSS tone and DCS decoders (MAIN)

> Lane N9. Private DB `N9_RX_TONE` (`--copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64`).
> One read-only dumper `ida\jobs\n9_dump.py` (copy of M8's), three `--reopen` passes. No database
> edits, nothing connected to or written to a radio. This documents code already on disk; it is not
> a procedure, a tone to transmit, or a bit string to send. sha256 MAIN
> `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…`, checked at launch and at finish, unchanged.
> Model: `claude-opus-5-5`.
>
> Tables in `ida\out\rx-tone-dcs\`:
> - `vectors.tsv` — the five TPU/IRQ vectors the RX decoders ride on.
> - `routines.tsv` — every RX decode routine, its band, family, installer, prescaler and constants.
> - `flags.tsv` — every RAM state/result flag with width, band and role.
> - `n9_verify.py` — asserts all 73 byte citations in this doc against the MAIN image and
>   re-derives the DCS rate. Last run: `PASS 73, 0 fail`.
> - `n9_dis.txt`, `n9_dis2.txt`, `n9_dis3.txt` — the IDA disassembly dumps behind every citation.

## Verdict

**Both receive decoders are present in this image and fully decode here.** They answer doc 120's
Open item 3. The radio has a two-band subaudible-squelch front end built on four interrupt vectors:
**IRQ4 (vector 68 → `0x0028F4`)** and **TPU0 TGIA (vector 88 → `0x0028D0`)** serve receiver band A,
**IRQ5 (vector 69 → `0x002922`)** and **TPU2 TGIA (vector 97 → `0x0028E2`)** serve band B. All four
are thin stubs that acknowledge their flag and `JMP` through a RAM function pointer — `FF811A` for
band A, `FF811E` for band B — so the active decoder is swapped in by writing that pointer. Two
decoder families are swapped in depending on the squelch mode:

1. **CTCSS / analog-tone decoders** (period/frequency-window integrators): band A `0x00171C`,
   `0x001784`, `0x00181A`; band B `0x001F54`, `0x001FEA`, `0x001EEC`. The IRQ edge captures the
   TPU free-running count between zero crossings (the tone period), the routine tests it against a
   period window and integrates match/attempt down-counters, then sets a result byte that the
   squelch state machine reads. **Confirmed** at the mechanism and system level; the mapping from
   period count to an exact CTCSS Hz is **Inferred** and not fully pinned (see Findings §4).
2. **DCS decoders** (Golay-word correlators): `0x001114`, `0x0012AC`, `0x001424`, installed by
   `sub_10C0` from the config records at `0x00158C` through pointer table `0x001108`. These are
   TGIA-sampled at **537.6 Hz** (TGRA0 = `0x7440`, φ/1), 4× the 134.4 bps DCS data; they clock the
   recovered data bit into a 24-bit shift register at `FF8FDC`, correlate against the 32-entry
   validity table at `0x00128C`, and raise the DCS lock flag `FF8F86.0`. **Confirmed.** The
   `0x7440` → 537.6 Hz figure matches doc 120 exactly.

No part of either decoder touches USB, the DSP SCI-C link, or any host byte. Everything cited is
already named in the FINAL7 MAIN masks and all decode code is proven, so the **named and proven
delta is zero** (see §5).

## Method

- **DB.** `--copy-from M1_MAIN_FINAL6`; dumper `n9_dump.py` (the M8/L8 dumper, renamed env vars).
- **Passes.** `n9_req.txt`: the capture ISRs, TGIA stubs, the six band-A/B tone routines, the two
  selectors, config `sub_10C0`, and xrefs to every state/result RAM byte and to `FF811A`/`FF811E`.
  `n9_req2.txt`: the handler tails, the squelch consumers, the TCR/TGRA writes, the `FF811A`
  pointer table and the window table. `n9_req3.txt`: the TPU0 init and RX start/stop, the DCS TX
  period site, and the three DCS decoders.
- **Prescaler.** Read directly: TPU0 init `0x0022C4 fc 20 3c c0` (TCR0 = `0x20`), RX start
  `sub_2F5A0` writes TCR0 = `0x01` (φ/4) or `0x00` (φ/1) per mode. TPU internal ladder φ/1·φ/4·
  φ/16·φ/64 (doc 76); φ = 16 MHz (doc 76).
- **Byte proof.** `n9_verify.py` re-reads all 73 citations and asserts them; it also asserts
  `16e6/0x7440 = 537.6` and `4e6/0x7440 = 134.4`.
- **Not covered / honest limits.** I did not reconstruct the analog recovered-tone conditioning, so
  I cannot convert the tone-period compare windows into exact CTCSS frequencies (the edges-per-tone-
  cycle is set by hardware outside the image). I did not fully map each of the three tone handlers
  to a named SQL TYPE; I report the mode byte the selector writes (states 6/7/8) and leave the
  name binding open. I did not trace the DCS received-word back to the standard code list (that
  needs the RAM shift register at run time; the 104-word *transmit* list is doc 120 §7).

## Findings

### 1. The capture/timeout front end (Confirmed)

Vector table (256 BE32 at `0`), bytes read at the offsets in `vectors.tsv`:

| Vector | Off | Bytes | Target |
| --- | --- | --- | --- |
| 68 IRQ4 | `0x110` | `00 00 28 f4` | `0x0028F4` |
| 69 IRQ5 | `0x114` | `00 00 29 22` | `0x002922` |
| 88 TPU0 TGIA | `0x160` | `00 00 28 d0` | `0x0028D0` |
| 97 TPU2 TGIA | `0x184` | `00 00 28 e2` | `0x0028E2` |

**IRQ4 `0x0028F4` (band A), the edge-period capture:**

```
0028F8  6b 0d ff c6     mov.w  @0xFFFFC6, e5     ; e5 = TPU0 TCNT = counts since last edge
002900  6b 84 ff c6     mov.w  r4, @0xFFFFC6      ; TCNT = 0 (restart the period timer)
002904  6b 04 ff 36 72 4c 6b 84 ff 36            ; clear edge flag FFFF36 bit4
00290E  25 c5 73 45     mov.b  @0xC5,r5h; btst #4 ; TPU0 TSR.4 -> "timeout/overflow?" tag
00291A  01 00 6b 04 81 1a 59 40                   ; er4 = [FF811A]; JMP @er4  (active decoder)
```

IRQ5 `0x002922` is the exact band-B counterpart: TPU2 TCNT `@0xFFFFE6`, edge flag `FFFF36` **bit5**,
TSR `@0xE5`, dispatch `@[FF811E]`. The TGIA stubs `0x0028D0`/`0x0028E2` clear their channel's TGFA
(`@0xC5.0` / `@0xE5.0`), read the recovered-data port `@0xFFFF40` into `r4l`, and dispatch through
the same pointers. So each decoder is entered two ways — on an input edge (period in `e5`) and on a
TGRA compare (a timer tick / timeout, with the data bit in `r4l`) — and tells them apart by the TSR
bit-4 test. `FF811A`/`FF811E` default to the idle stubs `0x0004AA`/`0x000E5E` (`06 7f`, set at
`0x00DC12`/`0x00DC1E`), i.e. no decode when squelch is off.

### 2. The CTCSS / analog-tone decoders (Confirmed mechanism)

Installed by the band-A selector `sub_2FAEC` and band-B `sub_31594`, which pick one of three
routines by the squelch class returned from `sub_3EEEE`/`sub_3ECB8` and write a mode byte (6/7/8):

| Install site | → `FF811A` | state | prescaler |
| --- | --- | --- | --- |
| `0x2FB4E 7a 04 00 00 17 1c …6b 84 81 1a` | `0x00171C` | 6 | φ/1 |
| `0x2FB0A 7a 04 00 00 17 84 …6b 84 81 1a` | `0x001784` | 7 | φ/1 |
| `0x2FB26 7a 04 00 00 18 1a …6b 84 81 1a` | `0x00181A` | 8 | φ/4 |

Band B (`sub_31594`) installs the twins `0x001F54`/`0x001FEA`/`0x001EEC` into `FF811E`
(`0x315B2`/`0x315CE`/`0x315F6`). The band-B routines are byte-for-byte the same algorithm with the
RAM block shifted +0x100 (`8F87→908F`, `8F88→9090`, `8F7C→9084`, `8F7E→9086`).

**The algorithm (routine `0x001784`, the clearest).** On each entry:
- `6a 0c 8f 87` read run-state; `0` ⇒ (re)seed counters and set state 1.
- `73 45` test TSR.4; set ⇒ a timeout/overflow ⇒ declare "no tone" (`8F88 = 1`).
- else a period is in `e5`: decrement the attempt counter `8F7E`; compare `e5` against the window
  `cmp.w #0x1882,e5` (`0x179A`) / `cmp.w #0x1F90,e5` (`0x17A0`); outside ⇒ return and keep counting;
  inside ⇒ decrement the match counter `8F7C`, and when it reaches 0 set the **result `8F88 = 2`**.
- seed values are `mov.w #0x7A,e4 ; mov.w #0xC8,r4` (`0x17C0`) = 122 required matches within 200.

Routine `0x00171C` uses the fixed window `[0x398C, 0x3D84]` (`0x172A`/`0x1730`) and seeds 150/300
(`0x176A 79 0c 00 96 79 04 01 2c`); it latches `8F88 = 1`, state = 2 on success. Routine `0x00181A`
takes its window from RAM `8F8C` (low) / `8F8A` (high) (`0x1830`/`0x1838`), which the loader
`sub_17DA` fills from the 16-byte-stride table at `0x001880` indexed by a mode sub-index, halving
both limits when `FFFF89BE` bit4 is clear (`0x17F8 6a 10 89 be 73 40`). The decode result byte
`8F88` (band A) / `9090` (band B) is read by the squelch state machine `sub_30310` (`0x3037C`),
`sub_30410` (`0x30464`) and `sub_304DC` (`0x3052A`), which open/close the audio gate and set the
open latch `8F89`. See `flags.tsv` for the full RAM list.

### 3. The DCS decoders (Confirmed)

`sub_10C0` is the DCS receive setup. It walks the 8-byte config records at `0x00158C`
(`0x10C8 7a 15 00 00 15 8c`), takes record byte 0 as an index into pointer table `0x001108`
(`0x10D6 01 00 6f 43 11 08`) and writes the chosen routine to `FF811A`
(`0x10DC …6b 83 81 1a`). Table `0x001108` holds three BE32 pointers:
`00 00 11 14`, `00 00 12 ac`, `00 00 14 24` → `0x1114`, `0x12AC`, `0x1424`.

`sub_2F55A` (stop/arm) copies the period word `FF8F96` into TPU0 TGRA0 `@0xFFFFC8`
(`0x2F566 6b 04 8f 96 6b 84 ff c8`). For DCS that period is `0x7440` = 29760
(`sub_42C 0x000440 79 04 74 40 6b 84 8f 96`, band B `sub_E3A 0x000E4E`), giving a TGIA sample rate
of **16e6 / 29760 = 537.6 Hz**, i.e. 4 samples per 134.4 bps DCS bit (doc 120 §7). On each TGIA
sample, `0x001114`:

```
00111A  7a 05 00 ff 8f dc     er5 = FF8FDC        ; base of the 24-bit received-word shift register
0011??  (bld #5 / bst #5 ; rotxl.b … ×6 words)   ; shift the recovered data bit in (bit5 of r4l)
0011D8  7a 05 00 00 00 18     er5 = 0x18 = 24     ; walk the 24-bit frame window
0011EC  6e 44 12 8c           @(0x128C,er4)       ; look up the 32-entry validity table at 0x128C
001214  6a 18 8f 86 70 00     bset #0,@0xFFFF8F86 ; DCS LOCK: valid Golay word matched
00121A  6b 04 8f 80 6b 84 8f 98                   ; load confirm/hold count 8F98 <- 8F80
```

`0x0012AC` is the same correlator driven from recovered-data bit 4 (`bld #4`), and `0x001424` is a
third polarity/band variant. The validity table `0x00128C` = `01 01 01 00 01 01 00 00 …` (32 bytes
of 0/1) is the per-position frame mask the correlator checks. The DCS lock flag `FF8F86.0` is read
at the top of `0x001114` (`0x11C8 6a 10 8f 86 73 00`) and cleared when the
confirm counter lapses (`0x1272 6a 18 8f 86 72 00`).

### 4. What the tone-period windows mean in Hz (Inferred, not pinned)

The window constants are Confirmed as TPU counts: `0x398C`=14732, `0x3D84`=15748 (routine
`0x171C`, φ/1); `0x1882`=6274, `0x1F90`=8080 (routine `0x1784`, φ/1); and the programmable table
`0x1880` records (routine `0x181A`, φ/4). Converting a count to Hz needs the number of input edges
per tone cycle produced by the analog recovered-tone conditioning, which is not in this image.
Taking one edge per cycle, routine `0x171C` brackets ≈1016–1086 Hz and `0x1784` ≈1980–2550 Hz at
φ/1 — not the subaudible CTCSS band (67–254 Hz) — so the front end is clearly multiplying or
dividing the recovered tone before it reaches IRQ4/5, or sampling a harmonic. **The counts, the
prescaler and the clock are Confirmed; the exact tone frequency each window accepts is Unknown from
firmware alone.** This does not affect the role: these routines are the analog-squelch tone decoders
(installed by the squelch-mode selector, result consumed by the audio gate).

### 5. Mask coverage and delta (proposal only)

Measured against `ida\out\m-wave-recon\final7_{named,proven}_mask.bin`:

| Range | Bytes | named | proven |
| --- | --- | --- | --- |
| `0x00171C`–`0x001819` (tone routines) | 254 | 254/254 | 254/254 |
| `0x001114`–`0x001423` (DCS routines) | 784 | 784/784 | 752/784 |
| ptr table `0x1108`–`0x1113` | 12 | 12/12 | 0/12 (data) |
| window table `0x1880`–`0x18CF` | 80 | 80/80 | 0/80 (data) |
| cfg records `0x158C`–`0x15FF` | 116 | 116/116 | 0/116 (data) |
| DCS validity tbl `0x128C`–`0x12AB` | 32 | 32/32 | 0/32 (data) |

The 32 "unproven" bytes inside the DCS routine span are exactly the validity table `0x128C`, which
is data and correctly stays named-not-proven. Everything else is already named and the code is
proven. **Named delta = 0, proven delta = 0.** (Zero is a valid delta.)

## USB relevance

- **Q1 USB: none.** The RX decoders touch only TPU0/TPU2 (`0xFFFFC0`/`E0`), the IRQ edge logic
  (`0xFFFFFD6A`, `0xFFFFFB90`, `0xFFFF34`/`36`), the recovered-data port `0xFFFF40`, and their
  decode RAM. None reads or writes the USB Function Module `0xFFEE00`–`0xFFEE53`.
- **Q2 SDR: no, unchanged.** The only sample stream *into* the CPU here is one recovered-baseband
  bit at 537.6 Hz (DCS) or edge timestamps at the subaudible rate (CTCSS). These are squelch
  decisions, not receiver samples, and there is no path from them to a bulk endpoint.
- **Q3 DSP: none.** These are analog-squelch decoders independent of the SCI-C DSP link; the DCS
  and tone paths never invoke it.

## Corrections to earlier docs (owning docs not edited)

| Doc | Earlier state | This lane | Evidence |
| --- | --- | --- | --- |
| **120** (M8) Open 3 | "Decode the RX side … IRQ4/IRQ5 + TPU0/TPU2 period decoders, handlers `0x171C`/`0x1784`/`0x181A`, the `0x10C0` config records at `0x158C`, and the `0x3C70/0x3C7C` RX class maps" (left open) | Done: `0x171C`/`0x1784`/`0x181A` (+ band-B twins) are the analog-tone period/window decoders; `sub_10C0` + records `0x158C` + ptr table `0x1108` install the DCS Golay decoders `0x1114`/`0x12AC`/`0x1424`; vectors 68/69/88/97 are the capture/timeout front end | §1–§3; `n9_verify.py` 73/73 |
| **120** (M8) §4 vector table | vectors 68/69 "IRQ4/IRQ5 … RX tone/DCS period decoders" (named only) | Confirmed and decoded: edge-capture ISRs that dispatch through `FF811A`/`FF811E`; the DCS half is TGIA-sampled at 537.6 Hz, not edge-period | §1, §3 |

## Open

1. **Hz binding of the tone windows.** Identify the recovered-tone conditioning (edges per cycle)
   to turn the Confirmed counts in §4 into named CTCSS frequencies; a service manual or the analog
   schematic settles it. Firmware alone does not.
2. **Name the three tone handlers to SQL TYPEs.** Trace `sub_3EEEE`/`sub_3ECB8` (the class source)
   and the `0x3C70`/`0x3C7C` maps to bind states 6/7/8 to TONE SQL / REV TONE / PAGER etc.
3. **DCS received-word → standard code.** Capture the `FF8FDC` register against the doc 120 §7
   transmit code list to confirm the receive decode inverts to the same 104 codes.
4. **Band-B result consumers.** `sub_30310`/`30410`/`304DC` read band-A `8F88`; find the band-B
   (`9090`) readers to confirm the dual-receiver squelch is fully symmetric.

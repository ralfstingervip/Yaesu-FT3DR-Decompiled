# The DSP 5 ms tick and the 2.2 ms script guard, proven from the image (MAIN)

> Lane J8 (FT3DR firmware J wave). Model: `claude-opus-4-8`. Owner-side, offline,
> strictly read-only static analysis. No database was written to a radio, no image
> was modified, nothing was connected to any device. Image
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (1,048,576 bytes, base 0, big-endian, so file
> offset = mapped address, unchanged).
>
> Method note: every byte cited below was read directly from the image with Python
> (read-only) and the H8S instructions hand-decoded, then cross-checked against the
> prior IDA-based lanes I13 (`57-dsp-session-scripts.md`) and H15
> (`52-dsp-runtime-driver.md`). I did not spin up a fresh IDA database: the evidence
> here is register/vector bytes, which are dispositive on their own, and I13 established
> the same methodology (byte re-read without running IDA). The instruction forms
> involved (`mov.b`/`mov.w` immediate + store, `cmp.w`, bit ops) are unambiguous.
>
> Tables in `ida\out\dsp-tick\`: `tpu-config.tsv` (register config bytes),
> `period-calc.txt` (the derivation), `guard-sites.tsv` (all nine 0x8980 guard sites),
> and the vector proof inside `period-calc.txt`.

## Verdict

**The 5 ms tick is CONFIRMED, and the 2.2 ms script guard is CONFIRMED — both now
byte-proven, not inferred.** The periodic interrupt is TPU channel 5 (register base
`0xFFFEF0`): `TCR = 0x21` selects `TPSC = 001 = Pφ/4`, `TGRA = 0x4E20 = 20000`, cleared
on compare match, TGRA-match interrupt enabled (`TIER = 0x41`). At φ = 16 MHz the count
clock is 4 MHz (250 ns), so the interrupt period is `20001 / 4 MHz = 5.00025 ms ≈ 5 ms`.
The exact divider is **φ/4**. Vector 110 (file offset `0x1B8`, bytes `00 00 2a 30`)
points at handler `0x002A30`, which acknowledges TPU5's TGFA flag (`bclr #0,@0xFFFEF5`)
and decrements the scheduler down-counters — CONFIRMED. I13's 5 ms correction of H15 is
right; H15's φ/8 → 10 ms reading is wrong, and not merely unproven: **φ/8 is not a TPU
clock-select value at all** (the TPU internal ladder is φ/1, φ/4, φ/16, φ/64 = TPSC
000/001/010/011), so TPSC = 001 can only be φ/4. The script-step guard is a *different*
TPU channel — channel 3, base `0xFFFFF0` — running free at `TCR = 0x00` (`TPSC = 000 =
Pφ/1`); its handlers compare `TCNT (0xFFFFF6)` against `0x8980 = 35200`, i.e.
`35200 / 16 MHz = 2.2000 ms` exactly, with a 16-bit-overflow backstop at 4.096 ms. The
"3 second" label H15 gave the `0x8980` compares is a correction: every such compare in
the DSP driver is 2.2 ms on the φ/1 channel.

## Method

What I ran (all read-only, scratch scripts in the lane scratchpad):

1. Direct byte reads of the TPU init block `0x002482`–`0x0024B4` (channel `0xFFFEF0`),
   the six-channel init loop `0x0022C4`–`0x00231C`, the vector table at `0x0`
   (slots 110 and 66), the ISR `0x002A30`, the script-guard handler `0x05B8A0`, and the
   main-loop call site `0x0030B8`.
2. Whole-image scans to prove uniqueness / rule out reconfiguration:
   - the only `mov.b r4l,@0xFFFEF0` store (TCR5) in the image;
   - the only `mov.w #0x4E20` TGRA write;
   - every `mov.b …,@0xFFFFF0` store (TCR3) — four of them, all value `0x00`;
   - every `cmp.w #0x8980` site (nine), with context.
3. Hand-decode of each H8S instruction and cross-check against the I13 and H15 listings.

Scope I did **not** cover: I did not re-derive φ = 16 MHz (taken as established from the
SCI BRR ladder in docs 05/14); I did not decode the full control flow of the two guard
handler variants byte-for-byte beyond the channel/compare/flag operations that set the
timing; I did not chase the scheduler tier contents (I13 already enumerated them).

## Findings

### 1. The periodic tick is TPU channel 5 at `0xFFFEF0` (Confirmed)

Init at `0x002482` (`tpu-config.tsv`):

```
002482  fc 21 6a 8c fe f0        mov.b #0x21,r4l ; mov.b r4l,@0xFFFEF0:16   TCR  = 0x21
002488  fc c0 6a 8c fe f1        mov.b #0xC0,r4l ; mov.b r4l,@0xFFFEF1:16   TMDR = 0xC0
00248E  fc 00 6a 8c fe f2        mov.b #0,r4l    ; mov.b r4l,@0xFFFEF2:16   TIOR = 0x00
002494  fc 41 6a 8c fe f4        mov.b #0x41,r4l ; mov.b r4l,@0xFFFEF4:16   TIER = 0x41
00249A  79 04 00 00 6b 84 fe f6  mov.w #0,r4     ; mov.w r4,@0xFFFEF6:16    TCNT = 0
0024A2  79 04 4e 20 6b 84 fe f8  mov.w #0x4E20,r4; mov.w r4,@0xFFFEF8:16    TGRA = 0x4E20
0024AA  fc 20 3c bc              mov.b #0x20,r4l ; mov.b r4l,@0xFFBC:8      TSTR = 0x20
0024AE  fc 00 3c bd              mov.b #0,r4l    ; mov.b r4l,@0xFFBD:8      TSYR = 0x00
```

The register file at `0xFFFEF0` is a standard H8S TPU channel: `+0 TCR, +1 TMDR,
+2 TIORH, +3 TIORL, +4 TIER, +5 TSR, +6 TCNT (word), +8 TGRA (word)`. The ISR clears
`TSR.TGFA` at `0xFFFEF5` (`+5`), which pins this as a TPU channel, not an 8-bit TMR (a
TMR has no TMDR and 8-bit TCORA/TCNT).

**`TCR = 0x21` decode.** Bits 7:5 `CCLR = 001` = clear TCNT on TGRA compare match; bits
4:3 `CKEG = 00`; **bits 2:0 `TPSC = 001` = internal clock Pφ/4** (the prescaler byte read
is `0x21`). `TIER = 0x41` sets `TGIEA` (bit 0), so the TGRA match is the interrupt
source. `TMDR = 0xC0` is normal mode (`MD = 0000`; bits 7:6 reserved).

**The channel is channel 5.** `TSTR = 0x20` (bit 5) starts it; the shared start register is
`0xFFFFBC`. The six-channel init loop (`0x0022C4`–`0x00231C`) sets up channels at
`0xFFFFC0, 0xFFFFD0, 0xFFFFE0, 0xFFFFF0, 0xFFFEE0, 0xFFFEF0`, but only `0xFFFEF0` gets
`TIER = 0x41` (TGIEA set); the other five get `TIER = 0x40` (TGIEA clear). So channel 5 is
the one and only periodic interrupt source among the TPU channels.

**Uniqueness.** The store `6a 8c fe f0` (TCR5) occurs exactly once in the whole image
(`0x002484`); `79 04 4e 20` (TGRA = 20000) occurs exactly once as an instruction
(`0x0024A2`). The prescaler and compare value are therefore never changed after boot.

### 2. Period = 5.000 ms, divider φ/4 (Confirmed)

```
count clock   = φ / 4 = 16 MHz / 4 = 4 MHz          -> 250 ns / count
counts/cycle  = TGRA + 1 = 20001  (counts 0..20000, then CCLR clears)
period        = 20001 / 4 MHz = 5.00025 ms  ~= 5.000 ms
```

The "5 ms" is confirmed. Why φ/4 is not in doubt: the H8S/H8SX TPU internal clock ladder
is fixed as `TPSC 000 = φ/1, 001 = φ/4, 010 = φ/16, 011 = φ/64` across all channels; φ/8
(H15's assumption) is simply not an option. So reading `TPSC = 001` settles it as φ/4.
This makes the scheduler tiers (ISR decrements `FF94B8` with reload 2; cascade counters
`FF9534`/`FF9535` reload 10) **5 ms / 10 ms / 100 ms / 1 s** — I13's figures, now proven
rather than inferred.

### 3. Vector 110 → `0x002A30` (Confirmed)

Vector table is 256 BE32 dwords at `0x0`. Slot 110 at file offset `110 × 4 = 0x1B8`:

```
0001B8  00 00 2a 30     -> 0x002A30
```

Handler `0x002A30`:

```
002A32  6a 18 fe f5 72 00   bclr #0,@0xFFFEF5     ; TSR.TGFA acknowledge (TPU5)
002A38  6a 0c 94 b8 47 06 1a 0c 6a 8c 94 b8   if (FF94B8) FF94B8--
        ... same for FF94B9, FF94BA ...
002A5A  56 70               rts
```

The flag it clears is TPU5's TGFA, so vector 110 is TPU5 TGIA — consistent with channel 5
being the only TGRA-interrupt-enabled channel. Cross-check: slot 66 (`0x108`) = `00 05 61
c2` → `0x0561C2` (IRQ2), matching H15.

The DSP driver tick itself (`0x056272`) is **not** this interrupt — it is a `jsr @aa:24`
from the main loop (`0x0030B8: 5e 05 62 72 = jsr @0x056272`). The 5 ms interrupt only
drives the down-counters the scheduler cascades; this matches I13 and H15 and is
unchanged.

### 4. The script guard is a *second* channel: TPU3 at `0xFFFFF0`, φ/1, 2.2 ms (Confirmed)

This is a different channel from the tick. It is set up in the same six-channel loop:

```
0022F6  fc 00 3c f0     mov.b #0,r4l ; mov.b r4l,@0xFFF0:8   TCR(0xFFFFF0) = 0x00
0022FA  fc c0 3c f1     TMDR = 0xC0
002304  fc 40 3c f4     TIER = 0x40   (TGIEA clear -> no interrupt; polled)
```

`TCR = 0x00`: `CCLR = 000` (free-running, no clear) and **`TPSC = 000 = Pφ/1`**. The guard
handler `0x05B8A0`:

```
05B8A0  7e bc 73 30             btst #3,@0xFFFFBC            ; is TPU3 running?
05B8A4  47 20                   beq  (start it)
05B8A6  2c f5                   mov.b @0xFFFFF5:8,r4l        ; TSR
05B8A8  6b 0c ff f6             mov.w @0xFFFFF6:16,r4        ; TCNT
05B8AC  79 2c 89 80             cmp.w #0x8980,r4             ; >= 35200 ?
05B8B0  44 06 ...               (branch on carry)
05B8B2  73 4c                   btst #4,r4l                 ; TSR.TCIV overflow backstop
        ... on timeout: bclr #3,@0xFFFFBC (stop), advance step counter B0BF ...
```

```
count clock   = φ / 1 = 16 MHz                 -> 62.5 ns / count
compare value = 0x8980 = 35200 counts
guard period  = 35200 x 62.5 ns = 2,200,000 ns = 2.2000 ms  (exact)
```

**φ/1 is proven in four independent places**, not just at init. The three driver-side
restarts write it again before reusing the counter:

```
056776 / 056826 / 056950   79 04 00 00  3c f0  6b 84 ff f6
                           mov.w #0,r4 ; mov.b r4l,@0xFFFF0 (TCR=0x00) ; mov.w r4,@0xFFFFF6 (TCNT=0)
```

So every restart re-asserts `TCR = 0x00` (Pφ/1) and zeroes TCNT. A whole-image scan finds
**no nonzero TCR ever written to `0xFFFFF0`** — the four stores are all `0x00`. The guard
prescaler is therefore φ/1 with certainty, and `0x8980` is unambiguously 2.2 ms.

The backstop: the handler also exits on `TSR.TCIV` (bit 4), the 16-bit TCNT overflow at
`65536 / 16 MHz = 4.096 ms`. Because TCNT counts monotonically from 0 and `0x8980 <
0x10000`, the compare fires first at 2.2 ms whenever the handler is polled inside the
window; the overflow only catches a step that was not polled during that window. Primary
guard = **2.2 ms**, worst case 4.096 ms.

**All nine `0x8980` compares are this same channel** (`guard-sites.tsv`): the DSP link
turn/receive timeout (`0x565FA`, `0x56650`), the session-request guards
(`0x5A1CA`–`0x5A352`), and the two script-step guard variants (`0x5B8AC`, `0x5B8E4`). All
nine read `TCNT @0xFFFFF6` and gate on `TSTR 0xFFFFBC` bit 3. None is 3 seconds.

### 5. Corrections to I13 and H15

| Doc | Claim | Status after byte proof |
| --- | --- | --- |
| I13 §5 | 5 ms tick, φ/4, "register reads Confirmed, bit decode Inferred" | Upgraded to **Confirmed**: TPSC=001 is φ/4 by the fixed TPU ladder; φ/8 is impossible. Register and vector bytes re-read here. |
| I13 §5 / Open 1 | "resolve the 0xFFFFF0 guard: TCR=0x00 and 0x8980 do not give 3 s" | Resolved: TCR=0x00 = φ/1, 0x8980 = **2.2 ms** exactly. φ/1 confirmed in 4 places. |
| H15 §2.2 | ISR 10 ms (φ/8); fast 20 ms, slow 200 ms; watchdog ≈24 s | **Corrected**: ISR 5 ms (φ/4); tiers 10/100/1000 ms; watchdog 12 s. |
| H15 §1 | TPU 0xFFFFF5/F6 "3-second receive timeout (cmp.w #0x8980)" | **Corrected**: 2.2 ms (φ/1, 0x8980). |
| H15 §3.3 | state 5 "restart 3 s TPU timeout (0xFFFFF0/F6)" | **Corrected**: 2.2 ms restart (the `0x56776`/`0x56826`/`0x56950` restart writes). |

I13's channel identification (`0xFFFEF0` tick, `0xFFFFF0` guard, `0xFFFFBC` TSTR) is
confirmed exactly. One refinement of vocabulary: by TSTR bit position the tick channel is
TPU **channel 5** (start bit 5) and the guard channel is TPU **channel 3** (start bit 3);
their base addresses are not in channel-number order on this part.

## USB relevance

No USB bytes here — the TPU block (`0xFFFEE0`–`0xFFFEF8`, `0xFFFFC0`–`0xFFFFF8`,
`0xFFFFBC`/`BD`) is distinct from the USB Function Module at `0xFFEE00`–`0xFFEE53`, and
none of the init, ISR, scheduler or guard code touches it. The result matters indirectly
to the three mission questions by fixing the **timebase** everyone else's figures ride on:

- **Q2 (USB SDR).** The DSP link is paced by this 5 ms scheduler and the per-step 2.2 ms
  guard, one frame per link turn. With the tick now proven at 5 ms (not 10 ms), the
  densest host-link codec payload H15 computed (90 B per ~100 ms, ~7.2 kbit/s) is
  unchanged in rate — it is set by the 100 ms scheduler tier, which is 10 × the 5 ms ISR
  (×2 ×10). No timing on this path approaches a sample-stream rate. The 2.2 ms guard only
  bounds how long a script step waits for a DSP ACK/event before giving up; it is a
  liveness watchdog, not a data clock.
- **Q3 (DSP reachability).** The guard confirms the link is a bounded-wait half-duplex
  handshake: a step that does not see its ACK/NAK/event within 2.2 ms (overflow 4.096 ms)
  is abandoned, so the DSP cannot stall the MAIN main loop. This reinforces that there is
  no free-running, high-rate DSP channel to repurpose.

## Open

1. **Pin the exact H8SX part and its TPU interrupt-vector map.** Vector 110 = TPU5 TGIA is
   inferred from the handler's TGFA ack; a part datasheet would confirm the vector
   assignment and the `0xFFFEF0`/`0xFFFFF0` ↔ channel-5/3 base-address mapping outright.
   The register layout and the φ/4·φ/1 clock ladder do not depend on it.
2. **The `0xFFFEE0` channel** (sixth, `TIER = 0x40`, φ/1) is configured but its consumer
   was not traced here; H15 tied a TMR-style turn timeout to `0xFFFEE5/E6`. Worth a pass
   to confirm it is not a second guard.
3. **φ = 16 MHz** rests on the SCI BRR ladder (docs 05/14); if a later lane reads the
   clock-generator (`SCKCR 0xFFFDC4 = 0x0111` at `0x0020FC`, noted but undecoded by I13),
   that would make the absolute millisecond figures fully self-contained.

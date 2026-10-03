# Transmit gate: the PTT input, the FF956D timer and the B0CC TX-mode byte (MAIN)

> Lane K11. Private DB `K11_TXGATE` (`--copy-from ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64`),
> generic read-only dump job `ida\jobs\k11_dump.py` (24 `--reopen` passes). Image
> `decrypted\FT3D_MAIN_ver102_EXP.bin`, base 0, file offset = mapped address; sha256 `8e3ecd05…`
> (unchanged; SUB `b93570b3…` unchanged). A few SUB strings were read as bytes for labels.
> No image was modified. Nothing was connected to or written to a radio. The CDC-ACM/DSP-download
> window `0x078106`–`0x07B753` was not entered. The TX frequency-range check was located but
> not decoded, as the brief requires. Model: `claude-opus-5-5`.
>
> Tables in `ida\out\tx-gate\`: `ptt-evidence.txt`, `ff956d.tsv`, `b0cc-bits.tsv`, `tx-inhibits.tsv`.

## Verdict

**The PTT key is port input `0xFFFF4E` bit 7 (active low), not `0xFFFF4D` bit 3.** Doc 77's PTT
identification is refuted from inside the firmware.

- **What bit 7 drives.** A debounce state machine (`sub_FC66`) turns bit 7 into raw key `0x17`
  (press) and `0x18` (release). Those become events 14 and 15.
  - Event 14 on the main screen is `sub_2244C`, the only TX request, and it is gated by the
    **PTT LOCK** types.
  - Event 15 in the TX-time key tables is `sub_22718`, the release that ends TX.
  - The press is delayed by `byte[0x00FCDC+FF89B0]` = 0/20/50/100/200 ms. This matches the SUB
    "PTT DELAY" list `OFF / 20 ms / 50 ms / 100 ms / 200 ms` entry for entry.
- **What `0xFFFF4D` bit 3 is.** It is a per-band RF status line. Band A uses bit 3; band B's
  mirror-image code uses bit 2. Low means OK.
  - The TX state machine samples it after the TX retune: TX keys only once it is low, and TX drops
    30–40 ms after it goes high.
  - The band-A receiver needs it low before evaluating squelch.
  - Its physical identity is Unknown. Synthesizer lock-detect is the best fit (Inferred).
  - It is a hardware TX interlock, not the PTT.
- **`FF956D` is not a TOT.** It is a 10 ms-tier byte, always loaded with the constant 2, giving a
  **10–20 ms post-retune settle**. It gates when that status line is trusted.
- **The real TOT** is the 1 s-tier word `FF95EA`.
  - It is loaded at every TX start with `FF89BA × 30 s`. `FF89BA` is menu item F393, default 6,
    which gives **3 min**. When `FF8DDE ≠ 0` (node/PC mode) 10 s is added.
  - Tone `0x1B` warns 10 s before cut-off.
  - On expiry TX is forced off (analog `sub_34FF4`, digital `sub_22718`).
- **`B0CC` is a one-bit flag.** Only 0 and 1 are ever stored.
  - It is set or cleared only by command slot `0x2D` (frame byte `']'`) of the `0x30`-based
    command protocol, and only in a digital mode with the DSP initialised.
  - It is cleared at boot and by the "enter remote mode" command `'0'`.
  - While it is set, PTT in a digital mode transmits DSP session `0x15`
    (`12`, `1A 01`, **`1C 03`**, TXON … TXOFF) instead of voice or data. This is a
    remote/service-commanded fixed-content transmission; what the DSP sends is Unknown.

## Method

- **Seed and job.** Seeded `K11_TXGATE` from `J1_MAIN_FINAL3`. Wrote one generic read-only
  IDAPython job (`k11_dump.py`: `dis`/`func`/`xref`/`callers`/`grep` over every code head
  `0`–`0x80000`, skipping the window). Iterated with `--reopen`, 24 passes.
- **Census.** Took a whole-image text census of every operand naming `956D`/`956C`, `B0CC`,
  `AACF`, `B0BB`, `94C0`, `A9EA`, `89B0`, `953D`, `BB91` and `89BA`. Did the same for every 8-bit
  absolute access to the port-input block `@0x40:8`–`@0x4F:8`. Ran a separate raw-byte scan of the
  image for abs16 and abs32 forms of `FF956D`/`FF956C` (`6a/6b xx 95 6d`, `… 00 ff 95 6d`).
- **Routines read.**
  - The scheduler tier routine `sub_3576` and the 5 ms ISR `0x002A30`.
  - The whole key path: `sub_FAF6`, the three key state machines, `sub_105BE`, and the
    dispatcher `sub_1079E`/`sub_10FA8` with its tables.
  - The TX request (`sub_2244C`, `sub_22562`, `sub_22676`), the release (`sub_22718`,
    `sub_227BC`), and TX state machine states 0–5 and `0x10`.
  - The TOT state machine `sub_34EEE`.
  - The band-A/B receive routines that read `0xFFFF4D`.
  - The command dispatcher `0x073A36` and tables `0x074472`/`0x074532`.
  - Every `B0CC` writer and reader.
- **SUB strings.** Read as bytes only, for labels: "PTT DELAY" at `0xFFC3E3C1`, the
  `0xFFF49041` value list, the lock list at `0xFFF48FD9`, and the "VOX" label at `0xFFC3E849`.
- **Not covered.**
  - The schematic and pin; the package has neither.
  - The SUB-side F3xx→label routing. Label matches are therefore by value list, Inferred.
  - TX state machine states 6–`0x14` other than `0x10`.
  - The TX frequency-range check `sub_34E42`, located only, as ruled.
  - The meaning of DSP opcode `1C 03`.
  - Which accessory or SCI feeds the serial PTT frame at `FF9800`.

## Findings

### 1. PTT = `0xFFFF4E` bit 7 (Confirmed role; "PTT" label Inferred, high)

`sub_FC66` at `0x00FC66` does `2a 4e ea 80`, which is `mov.b @0x4E:8,r2l ; and.b #0x80`. It
dispatches through `off_FC80[FFA9EA]`:

| State | Test | Action |
| --- | --- | --- |
| 0 `0x00FC90` | released? | → 1. PTT held at power-on is ignored until it is released. |
| 1 `0x00FC9C` | pressed | `FF89B0 == 0`: raw `0x17` (`0x00FCCE`), state 2. Otherwise `FF953D = byte[0x00FCDC+FF89B0]`, state 3. |
| 3 `0x00FCF4` | still pressed and `FF953D == 0` | raw `0x17`, state 2. A release here goes back to 1 with no event. |
| 2 `0x00FCE2` | released | raw `0x18` (`0x00FCE6`), state 1 |

The translator converts raw to event as `raw − 9` (`0x00FBD4`), so 14 is press and 15 is release.

- **Press.** The main-screen tables `0x0115EC + mode×0x44` have event 14 = `0x02244C` in modes 0–5
  and 8.
  - `sub_2244C` checks PTT LOCK first (`jsr sub_22562` at `0x022492`).
  - `sub_22562` is `6a 10 89 c1 73 30 … 6a 0c 89 ab ac 03 45 04`, i.e. lock on and lock type ≥ 3.
    Types 3–6 are PTT, KEY&PTT, DIAL&PTT and ALL (SUB list `0xFFF48FF4`).
  - It then posts `AACF = 1` (`0x02253C`) and `FF94C0 = 1` (`0x022542`).
- **Release.** While `FF94C0 ≠ 0`, `sub_10FA8` selects the TX-time tables
  `0x011960 + (n−1)×0x44`. Event 15 there is `0x022718` in all four.
  - `sub_22718` clears `B0BB.b0` (digital) or posts `AACF` 7 or 8 (end of TX).
  - `FFA9EA == 2` is used as the "PTT held" level by TX states 4/5 (`0x034D7E`), by the T-CALL
    release (`0x022AAC`) and by `0x038EDE`.
- **PTT DELAY.** Bytes `0x00FCDC` = `00 02 05 0a 14`. `FF953D` sits in the 10 ms tier, so these are
  0/20/50/100/200 ms. The SUB list at `0xFFF49041` (10-byte stride) reads `OFF`, `20 ms`, `50 ms`,
  `100 ms`, `200 ms`, and the SUB label is "PTT DELAY". `FF89B0` is menu item F38C.
- **Other keyers that synthesise the same events.** Bytes are Confirmed; the labels are Inferred.
  - **`0xFFFF4E` bit 0 keyer, best fit VOX.** A level state machine (`sub_105BE`, state `BB93`),
    active when `FF89BB ≠ 0`.
    - Release hang is `byte[0x01070C+FF89BC]` = `06 0b 10 15 1a 1f` on the 100 ms tier, i.e.
      0.5–3.0 s.
    - It enables output `0xFFFF50.b6` with a 300 ms warm-up.
    - While it is armed, the PTT key state machine is held in reset (`0x00FB0C`–`0x00FB28`).
    - Doc 77's "short TX `BB94`" is what this keyer runs on the analog path.
  - **Serial-frame bit.** `FF980B.b0` → `BB91` (`sub_4811E`, `0x0481E8`) → `sub_FD22`, active when
    `FF8920.b0` is set. This is an accessory PTT over a serial frame; which link is Unknown.
  - **Command slot `0x03`** (`'3'`, `sub_73BB4`) injects event 14 or 15 directly.
  - **T-CALL.** The side key `0xFFFF4E.b4` gives event 16, `sub_22A28`, which calls `sub_2244C`
    when `FF89C0.b0` is set.
- **Clone/remote mode.** With `FF8004 ≥ 2`, all key state machines are reset on every pass
  (`0x00FAF6`).

### 2. `0xFFFF4D` bit 3 is a per-band RF status line, not the PTT (roles Confirmed; identity Inferred)

All readers are listed in `ptt-evidence.txt` §G.

- **Band split.**
  - Band-A code (`sub_2FA7C`, `sub_30590`, `sub_3080C`; struct `FF8122`, timers
    `FF956D`/`FF9568`) reads bit 3.
  - The byte-for-byte band-B twins read bit 2: `sub_31524` (`… 7e 4d 73 20` at `0x031534`) and
    `sub_31F9E`, with timers `FF9580`/`FF957D`.
  - Command slot `0x2E` (`sub_743E0`) reports bit 3 for band A and bit 2 for band B. It replies
    only after the post-settle flag `0x8F.b2` is set; otherwise it returns `0x15`.
- **Receive.** After a retune, `FF956D` must reach 0.
  - Then a low line moves the band to the normal receive states (`sub_2FAEC`).
  - A line that stays high for 30–40 ms (`FF9568`) sets `0x8F.b3` and **parks** the band state
    machine in `nullsub_128` (state 2) until the next band event.
  - In the steady state, high forces `0x90 = 2` (mute). Low lets the RSSI squelch `sub_306EA`
    (`A992` against setting `FF8970`) decide.
  - A carrier/busy line would park the receiver on every quiet channel, so the line is a "fault or
    OK" signal, not carrier detect.
- **Transmit.**
  - `sub_34782` → `sub_34838` sets up the TX offset class and arms `FF956D = 2`.
  - State 1 (`sub_34966`) keys only once bit 3 is low. If it stays high past `FF9568` it aborts
    with `sub_34FF4`.
  - States 2 and 3 (`sub_34CCE`/`sub_34D42`) end TX 30–40 ms after it goes high.
  - Host-keyed node mode (`FF8DDE < 0` with `FF8DE0.b7` or `B3D9.b2`) skips the check
    (`0x03496A`).
- **Conclusion.** The line is a hardware interlock sampled before and during TX. Synthesizer
  lock-detect fits all uses (Inferred, moderate). The physical pin is Unknown.

### 3. `FF956D` (`ff956d.tsv`)

- **Tier.** It is byte `FF9536 + 0x37` of the 88-byte array that `sub_3576` decrements to zero
  every 10 ms. `sub_3576` runs only when the 5 ms ISR counter `FF94B8` (reload 2) is zero, at
  `0x003576`–`0x003598`. That pointer loop is the **only** decrement: the raw scan found no other
  abs16 or abs32 reference.
- **Writers.** Twelve sites, all storing `fc 02`, i.e. the constant 2. No setting is involved.
  - `0x02F622` band-A re-init/retune.
  - `0x03111E` band-B twin, only when in dual mode.
  - `0x0341E4`/`0x03421A`/`0x03429A`/`0x0342BE`/`0x0342D2`/`0x034316`/`0x03433A`: redraw/retune of
    the band blocks.
  - `0x034860`: TX setup in `sub_34838`.
  - `0x039436`: `sub_3941A`, on the `A9E3.b0` event.
- **Readers.** Two: `0x02FA7C` (band-A receive state 1) and `0x03497C` (TX state 1).
- **Timing and expiry.** 2 ticks is **10–20 ms**. Expiry triggers no action; it only lets the
  `0xFFFF4D.b3` sample happen.
- **Verdict.** Post-retune settle (Inferred role). It is neither the TOT nor a key debounce. The
  key debounce is `FF953D` plus the key state machine.

### 4. TOT (Confirmed)

`sub_34EEE` is called from the main loop at `0x002CBC`, `0x0038C6` and `0x003A1E`. It is a
3-state machine on `AADA`:

- **Arm** (`0x034F24`):
  - Trigger: `AA30.b2`, set at TX start (`0x034A08` analog, `0x03599A` digital).
  - Conditions: `FF89BA ≠ 0` and `AA33.b0` clear.
  - Load: `fc 1e 50 c3` gives `FF89BA × 30`, plus `79 13 00 0a` (+10) when `FF8DDE ≠ 0`. The
    result goes to `FF95EA`, a 1 s-tier word.
- **Warn** (`0x034F50`): at 10 s remaining, tone `0x1B` (only when `FF8DDE == 0`).
- **Expire** (`0x034F6E`): analog → `sub_34FF4`; digital → `sub_22718` plus node-flag cleanup.

The setting values give 0 = OFF and n = n × 30 s. `FF89BA` is F393, default 6 (`0x00E81C`), so
the default is **180 s**.

Two more facts:

- Remote command `'0'` writes `FF89BA = 0`, turning the TOT off (`0x073B34`).
- The power-on chord 0x7B handler `sub_102A6` sets `AA33.b0`, which also disables it.

### 5. `B0CC` (`b0cc-bits.tsv`)

There are 8 references in the whole image, with 4 stores, all immediate 0 or 1.

- **Clear at boot.** `sub_2DCE` at `0x002E18` (skipped when `FF8004` is 1–3).
- **Clear on remote entry.** Command `'0'` `sub_73AFE` at `0x073B3A`.
- **Set/clear by command.** Command `']'` (slot `0x2D`) `sub_74396`.
  - Accepted only if the operating band's comm mode is not 0 and `B0A4.b2` is set (DSP init done).
  - Arg 1 sets it (`0x0743BC`).
  - Arg 0 clears it and re-initialises the DSP link (`sub_56046`: `B0B4 = 5`, `B0A4 = 0`).
- **Readers.**
  - The TX-start dispatcher `0x0358CA` and its node twin `0x035EDC`: `b0` → `sub_5A2F8` →
    session `0x15`, AAD5 = `0x10`. This takes priority over data (`AAD4.b0`) and voice.
  - State `0x10` `0x035A22`: `b0` suppresses the 3.5 s follow-up `sub_5CA34`.
- **Session `0x15`** (doc 57, script `0x05C40A`): `12`, `1A 01`, `1C 03` (`B0B8 = 3`; opcode
  `1C` trace label "DATA TEXT SET", doc 06), then TXON, hold while PTT is held, TXOFF.
- **Bits 1–7** are never written non-zero and are never read.

### 6. Other TX inhibits on the PTT→TX path (`tx-inhibits.tsv`, 27 rows)

- **Key stage:** clone/remote mode, the alternate-keyer lockout, PTT DELAY, and stuck-PTT at
  power-on.
- **Request stage (`sub_2244C`).** Each of these refuses with tone `0x1D`:
  - DSP not initialised (`B0A4.b2`) in digital mode;
  - PTT LOCK;
  - `FF89BF.b4` with band `0x90 ≠ 2` — busy-channel lockout (label Inferred);
  - the `FF8EA6` slot-consistency check;
  - the TX frequency-range gate `sub_34E42`, located only and not decoded.
- **State-machine stage:** the 10–20 ms settle, the RF status line (abort or end after
  30–40 ms), TOT, and the DSP link-ready test in `sub_5A2F8`.
- **Battery, temperature, ADC:** **Not found** in the routines read (scope in the TSV).

### 7. Corrections to earlier docs (owning docs not edited)

- **Doc 77 §1 / Verdict / Q3 text and RESUME J9.** "PTT = `0xFFFF4D` b3" is wrong.
  - The PTT is `0xFFFF4E` b7, and it reaches `sub_34966` indirectly, via event 14 → `AACF = 1`.
  - `0xFFFF4D` b3 is the band-A RF status interlock.
  - Doc 77's "`FF956D` TX-inhibit timer (TOT)" is the 10–20 ms settle. The TOT is `FF95EA`.
  - Doc 77's open item 4: `B0CC` is a 1-bit remote-commanded flag (above).
  - **Possible numbering mismatch.** Doc 77 places `sub_73E58` at "host command `0x11`". In table
    `0x074472` it is slot `0x10` (frame byte `0x40` `'@'`). This may only be a numbering-basis
    difference; it was not re-checked.
- **Doc 05 port table.** The "PTT / TX enable" row (`0xFFFF49` b7, `0xFFFF41` b3, `0xFFFF42` b6)
  names no PTT. `0x49.b7` and `0x41.b3` are a band-A/band-B pair read in comm-mode-2 receive.
- **pc-05 §5.** Raw `0x17`/`0x18` come primarily from the `0xFFFF4E.b7` state machine
  (`sub_FC66`), not only from `BB91` or `sub_73BB4`. Event-15 handling exists in the TX-time
  tables (`0x011960`…), not "mostly none".

## USB relevance

- **Q1 (USB): none.** Every routine here is outside `0xFFEE00`–`0xFFEE53` and outside the closed
  window. The PTT and its alternate keyers are GPIO, a serial frame, and the `0x30`-based command
  protocol, not USB.
  - The command protocol can key the radio (`'3'` = PTT press/release) and arm session `0x15`
    (`']'`), but only in remote mode (`FF8004 ≥ 2`).
  - Its upstream link is per docs 17/24/pc-05 (SCI-A host or SUB link) and was not re-derived.
- **Q2 (SDR): unchanged no.** Nothing in the TX gate moves samples.
- **Q3 (DSP).** One refinement: the only non-voice/non-data TX session a host can select is
  `0x15` (`1C 03`), armed by command `']'`. Its content is DSP-defined and Unknown. There is still
  no arbitrary-opcode path.

## Open

1. **Pin the `0xFFFF4D` b3/b2 identity** (lock-detect vs. RF-ready) from a schematic or the
   service manual. In firmware, the remaining test is to read TX states 6–`0x14` and the band
   state 2 exit to see whether any UI shows an unlock or error.
2. **Name the `0x30`-command protocol slots** (`0x074472`/`0x074532`): which link feeds ring
   `FF95F8`, and the full list (`'0'` remote enter, `'3'` PTT, `'@'` node TX, `']'` B0CC,
   `'^'` RF status). This is the radio's whole remote-control surface.
3. **Decode opcode `1C` sub-codes** (`B0B8` = 3/9/`0x0D`) on the SUB/label side; the DSP meaning
   stays Unknown.
4. **Confirm the alternate-keyer labels.** Settle the VOX (`FF89BB`/`FF89BC`, `0x4E.b0`,
   `0x50.b6`) and accessory serial-PTT (`FF8920.b0`, frame `FF9800`) labels by SUB F3xx routing,
   and identify the SCI behind `sub_4811E`.

# FT3DR Firmware Decompilation — Resume 👋

Welcome back! This is the **Yaesu FT3DR/FT3DE ver 1.02** firmware decompilation
project. This page records where the work left off. No
rush and no ceremony — read this page, then dive into whatever you feel like.

> **Start here:** read `docs/deep/BRIEF.md` for the shared context (hardware map,
> RX/H8S encoding traps, rules), then `docs/deep/RESUME-FULL.md` for the full
> decompile and completion-wave record. The firmware images (`decrypted/`), the vendor
> packages (`Firmware/`) and the IDA databases (`ida/db/`) are not in this repository.

**One ground rule that never changes:** this is owner-side **static** reverse
engineering of firmware you already own. Nothing here ever touches a radio — no
serial, no USB, no device access. We only ever read files on disk.

*(The launchers self-locate, so the scripts and docs use paths relative to the
repository root.)*

---

## Where things stand

The hard parts are done. Both firmware images are decrypted, the USB question is
answered, and a full decompile pass plus an 8-lane completion wave are finished.

- **Both ver 1.02 images are decrypted** and verified:
  - MAIN EXP 1.02 → `decrypted/FT3D_MAIN_ver102_EXP.bin` (1,048,576 B)
    `sha256 8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce`
  - SUB ALL 1.02 → `decrypted/FT3D_SUB_ver102_ALL.bin` (4,194,304 B)
    `sha256 b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230`
- **USB survey done** — `docs/usb-survey.md`, `docs/sub-usb.md`, `docs/sub-usb-comms.md`.
- **Decompile pass + completion wave + G through N waves done** — the full story is
  in `docs/deep/RESUME-FULL.md`. Headline after the N wave, **convention D** (a byte counts when named or
  typed on both images, including dead code and dead residue already proved):
  **Decompile 99.9589% (1,029,549 / 1,029,972)**. Earlier convention-A headline (SUB code only) is 94.13%.
  - **MAIN:** **99.916%** named/typed (505,261 / 505,684). Proven code is **365,358** B (72.25% of content),
    unchanged — the N wave found no new inbound edge.
  - **The 519 bytes that were unnamed are now all classed** (N2, doc 129): **96 Confirmed** (now named —
    20 read by proven code, 7 table-extent, 26 fill, 43 the re-cited stale copy at `0x069A7F`) and
    **423 Inferred** — clean data tables that nothing in the image reads (382 B the curve region
    `0x03624B`–`0x0377C1`, 41 B in small runs). The 423 are why this is 99.9589% and not 100%.
  - **Strict-reach companion (convention E, unrenamed):** MAIN proven 365,358 + SUB strict reach 457,342
    = 822,700 / 1,029,972 = **79.876%**. This is not the finish line.
  - **One decision reaches 100%:** whether no-reader IDA-typed bytes count as named. The named mask already
    counts 5,209 such bytes; naming the 423 the same way (N3's "unread constant" proposal) would make MAIN
    505,684 and convention D 100.000%. Strict (reader required) keeps it at 99.9589%. Your call.
  - Write-ups are `docs/deep/01` through `142`. **New MAIN seed `N1_MAIN_FINAL7`** reproduces the FINAL7
    masks byte for byte and is a fixed point; it does not replace `M1_MAIN_FINAL6`.
- **Seed databases**: `M1_MAIN_FINAL6` (new in the M wave; it reproduces the L-wave masks byte for byte)
  and `K7_SUB_FINAL3` in `ida/db/jobs/`, both fixed points. Seed new MAIN work from `M1_MAIN_FINAL6`, SUB
  work from `K7_SUB_FINAL3`.
- **MAIN's CPU is H8SX, not H8S** — the "undecodable" instructions were H8SX all
  along; IDA's own `h8sxa` module decodes them (doc 36).

## The big questions, answered

1. **Anything USB?** The radio's USB lives on **MAIN** (on-chip Renesas USB module at
   `0xFFEE00`, with two device descriptors — a vendor class and a CDC-ACM virtual COM
   port). **SUB's USB is dark** (powered down, never addressed). Firmware updates go
   through the Renesas boot ROM (`VID_045B&PID_0025`).
2. **Could it do USB SDR?** No. The on-chip ADC is a ~12-bit / ~1 Msps SAR converter
   (not IF-sampling), there's no IQ source and no streaming path. The hardware simply
   isn't wired for it.
3. **Can you reach the DSP directly?** It's **MAIN's**, on SCI-C `0xFFFF88`, speaking a
   proprietary 1-byte-opcode fixed-length frame (not AMBE-3000R). No firmware path
   exposes it beyond that link, and its own image isn't in this package.

The completion wave also cracked the biggest mystery routines: they turned out to be
a microSD **photo viewer** (JPEG decode → YCbCr→RGB565 → LCD) and a **FatFs**
filesystem layer. Everything examined is ordinary UI / menu / IPC / imaging /
filesystem plumbing — no hidden USB, SDR, DSP, or self-flashing anywhere.

The H wave firmed all three up: the DSP link carries **no audio or samples** in
normal use (doc 52), the only bulk MAIN→SUB transfer feeds SUB's JPEG decoder
(doc 51), and the DSP-download byte pump is called only from inside the closed
service window (doc 42).

Lane H11 is reconciled in `docs/deep/49-key-sequence-hidden.md` (the 8-step
machine at MAIN `0x01494C`, checked against the image on 2026-10-03).
`49-hidden-settings.md` (H13) is the doc for the screen model where the two overlap.

The I wave closed the last USB thread outside the closed window:
- **Image-push buffer:** fed only by the radio's own "USB CAMERA" vendor device, an EP1 bulk-OUT upload (doc 53).
- **Vendor device (`26AA:0001`):** fully decoded. It has 4 vendor requests, and the only thing it sends back is a 3-byte status report (doc 64).
- **Pictures over C4FM:** sent and received pictures run DSP ↔ MAIN ↔ SUB ↔ SD and never touch USB (doc 63).

It also decoded the DSP's receive state machine and TX scripts (docs 56, 57). Neither carries audio or samples.

## What the K wave found (the short version)

- **The touchscreen is read by SUB**, not MAIN (a 4-wire resistive panel on SUB's ADC);
  SUB sends MAIN a press and a release per touch. **No touch path opens a hidden or
  service screen** — checked over all 99 zone tables (511 zones). (K2/K3)
- **PTT is port `0xFFFF4E` bit 7.** The bit earlier called PTT (`0xFFFF4D` b3) is an RF
  status interlock. The real time-out timer defaults to 180 s. (K11)
- **APRS:** standard AX.25 (CRC-16/X.25, tested offline) over SCI-B. With APRS MODEM on
  (default off) the radio transmits on its own for beacons, SmartBeaconing, message
  retries, and an automatic `ack` to messages addressed to you — no setting turns the
  `ack` off. No digipeater. (K8)
- **DATA jack:** the framed protocol is the WIRES-X node / PC link; **no command reads or
  writes an address the PC chooses**. Its `R` frame carries codec bits; only `S` keys TX.
  Clone is a separate front-panel EEPROM copy. (K9/K10)
- **DSP opcode `0x32` is the APRS modem setting**; LOCATION SERVICE is a normal menu item;
  16 DSP-config rows are hidden and unreachable. (K5)
- **microSD runs on SDHI** (native SD mode); the built-in card formatter is unreachable,
  and the write-protect switch is never read. (K6)

## What the L wave found (the short version)

- **A Bluetooth headset's button can key the radio.** The "accessory PTT" K11 left open
  is SUB→MAIN frame `E6`, sent when the Bluetooth module reports `RXAT=CKPD=200`. It works as a
  toggle (press to key, press again to unkey) and only with Bluetooth ON. If the headset drops
  its audio link while keyed, the radio **stays keyed** until the next press or the time-out
  timer (180 s by default). (L10/L11/L12)
- **The TX state machine is fully decoded.** States 4 and 6–`0x0C` can never be entered. TX power
  folds back and finally cuts off when an analog input (AN1) reads high, most likely PA
  temperature (Inferred). (L8)
- **WIRES-X node commands:** 48 single-character commands; none lets a PC read or write memory it
  chooses. `'@'` is slot `0x10`. Command `'3'` injects a PTT press. (L7)
- **DSP `1C 03`** is a fixed, empty frame sent only in remote-armed session `0x15`. The analog
  answer-back carrier is about 2.5 s. The last unexplained message-reply trigger needs a
  keypress. (L9)
- **SUB→MAIN link:** exactly ten frame types, matched on both sides; none carries anything from
  USB, writes EEPROM or reaches the DSP. (L11/L12)
- **Touch:** 154 more zones tied to handlers, 41 can never fire; F8 pages are WIRES-X. Still no
  touch or key path to a hidden or service screen. (L6)
- **Housekeeping:** `L1_MAIN_FINAL5` seed; 4,428 B of seed-only code demoted, including J14's
  dead page writer `0x03C668`; +3,337 B of data typed; the J-wave errata are in doc 111; the
  K wave re-verified (doc 110); hand-written C for the USB vendor device and the TX gate
  (doc 112). (L1–L5, L13–L15)

## What the M wave found (the short version)

- **The USB virtual COM port (CDC-ACM, `26AA:0020`) is a plain bridge to the DSP link.** It exists only in
  service mode: the strap key held at cold power-on. It answers the 4 standard serial-port requests and blocks
  everything else. Your PC's baud setting is stored but ignored, because the DSP link's speed is fixed. It
  cannot write the radio's flash and carries no samples. (M7)
- **Tones decoded:** CTCSS from a sine table at 6,552 Hz; DCS at 134.36 bps; T-CALL at 1,736 Hz (design
  1,750). AN0 is battery voltage. Dry cells cap TX at LOW2. What AN1 measures is still unknown (PA
  temperature is a guess), and its popup `0x23` is never actually shown. (M8)
- **The hidden-key guard is a frequency:** the two hidden menu toggles need the broadcast (AM) receiver left
  on 666 kHz. Key event 13 is one DIAL step. (M11)
- **WIRES-X node commands:** `'A'` injects key presses but can't key TX. `'@'` with argument `0x11` adds a
  T-CALL tone while keyed. (M11)
- **Bluetooth:** the headset's `CKPD=200` button is the only Bluetooth input that keys TX. A device search
  writes the found-device list to EEPROM. (M12)
- **The SUB↔MAIN link is robust:** every frame is padded with zeros that MAIN skips, so no frame can swallow
  or corrupt the next; nothing there can key or unkey TX. (M9)
- **Touch:** 462 of 511 zones lead to a handler and 49 can never fire. Still no route to a hidden or service
  screen. (M10)
- **Housekeeping:**
  - `M1_MAIN_FINAL6` seed.
  - 1,692 B of "proven" code audited: 1,472 B are dead, and the window's 220 B stay. Four WIRES-X helpers the
    L wave restored turn out to have only dead callers.
  - L5's leftovers typed.
  - The L wave re-verified (1,098 / 1,110 citations pass). One real error found: UHF sub-band 5 starts at
    300 MHz, not 230.
  - K/L errata indexed. SUB residue all dead. (M1–M6, M13–M15)

## What's left (and what's most worth your time)

1. **One decision for you (the only thing between the headline and 100%):** whether no-reader
   IDA-typed bytes count as named. The N wave adopted **convention D** for the headline (99.9589%),
   and N2 fully classed the 519 formerly-unnamed MAIN bytes as 96 Confirmed + 423 Inferred. The
   423 Inferred are clean data tables with no reader; the named mask already counts 5,209 similar
   no-reader bytes. Keep the reader-required rule → **99.9589%**; count no-reader IDA-typed bytes
   as named → MAIN 505,684 and convention D **100.000%**. The SUB-convention and stale-copy
   questions from the M wave are now settled (D adopted; the stale copy counts, re-cited by N2).
2. **Done this wave:** the `N1_MAIN_FINAL7` seed; the 425 B unread tables, the 300 B duplicate EP0
   handlers `0x076ADE`–`0x076C09`, and the 52 B at `0x0771AE` are all classified (all dead/unread,
   0 proven); the RX tone/DCS decoders are decoded (doc 136); AN2–AN5 are identified (doc 137);
   the SUB strict reach is closed at 457,342 without the stale lane-4 roots (doc 134).
3. Things only the hardware can answer (add zero bytes): what AN1 measures, whether the Bluetooth
   VOX line reaches MAIN's `0xFFFF4E` bit 0, and the physical turn direction of the IRQ7 / IRQ10
   knob (which knob is DIAL vs VOL is now resolved from the image — doc 139).
4. **Not produced:** N11's writers of AADE / BB70 and the F301/F3C0/F3C1 sender — that lane was
   stopped by a safety classifier (its byte deltas were 0 regardless).

Not done in the I wave: the EEPROM map (lane I16 was stopped by a safety
classifier). Lane I7 (market gates) left `docs/deep/59-market-gates.md` and
`ida/out/market-gates/` on disk; those files were not edited and are still not
summarised here. How `FF800F` / `FF8010` / `FF8011` get their values is
`docs/deep/96-market-values.md`. `sub_34E42` is decoded in
`docs/deep/97-tx-freq-range.md`. Doc 93 was not edited.

## Project layout

| Path | What it is |
| --- | --- |
| `Firmware/` | Vendor ver 1.02 updater packages. Source material — never modify. Not in this repository. |
| `decrypted/` | The plaintext MAIN and SUB images (+ `.meta.txt`). Keep unchanged. Not in this repository. |
| `docs/` | All the write-ups. `docs/deep/` is the full decompile pass (`01`–`112`). |
| `docs/deep/RESUME-FULL.md` | The detailed decompile + completion-wave resume. |
| `docs/deep/BRIEF.md` | Shared context: hardware map, RX/H8S encoding traps, rules. |
| `ida/run_job.py` | The IDA 9.1 job launcher (self-locating). Your main tool. |
| `ida/jobs/` | IDAPython job scripts. |
| `ida/out/` | Machine-readable tables (function indexes, coverage, etc.). |
| `ida/db/` | IDA databases — `radio/`, the updater `.i64`s, and the `jobs/` seeds. Not in this repository. |
| `docs/agents.md` | Project instructions and the re-run commands. |

## Running IDA jobs

`idat.exe` is a local IDA Professional 9.1 install (local tree, not in this repo) — only ever call
it through the launcher. Each job gets its own private database; seed a new one from
an existing database instead of re-analysing from scratch:

```text
python "ida/run_job.py" --script ida/jobs/<yours>.py --db <YOURDB> --copy-from ida/db/jobs/<SEED>/<SEED>.i64
python "ida/run_job.py" --script ida/jobs/<yours>.py --db <YOURDB> --reopen
```

Already-built seeds (nothing to regenerate): **`M1_MAIN_FINAL6`** (preferred for MAIN —
`L1_MAIN_FINAL5` minus the L wave's 4,428 B demotion plus L5's typing; masks equal
`ida/out/l-wave-recon/`; fixed point, layout hash `8ebdd76d4cf1cf86`), **`L1_MAIN_FINAL5`** (previous MAIN seed —
`K1_MAIN_FINAL4` plus the −278 B demotion and the service window's 336 code heads; fixed
point, layout hash `42111f94aa98d911`; don't run a broad re-plan over it), **`K1_MAIN_FINAL4`**
(H8SX-native, one folded descent; carries J2's edge, the touch helper-table rule and the 99
typed zone tables) and
**`K7_SUB_FINAL3`** (preferred for SUB — SUB_FINAL2 plus J10's merges, dead functions
named `dead_*`; old labels map through `ida/out/sub-final3/alias-final3.tsv` and
`ida/out/sub-final2/alias.tsv`). Older: `J1_MAIN_FINAL3`, `SUB_FINAL2`,
**`MAIN_FINAL2`**, `MAIN_H8SX`, `MAIN_FINAL`,
`SUB_FINAL`, `MAIN_FULL`, `SUB_WINDOW`, `MAIN_RAW`,
`EXT_MENU_MAIN` in `ida/db/jobs/`; the radio databases in `ida/db/radio/`
(`MAIN.i64`, `SUB.i64`, `RComms.i64`, `RFP_USB_VB.i64`); and the updater databases
`ida/db/FT3D_MAIN.i64`, `FT3D_SUB.i64`.

## House rules

- Nothing is ever written to a radio. Static analysis of files on disk, full stop.
- Never modify `Firmware/` or `decrypted/*.bin`.
- Shell is Windows PowerShell — chain commands with `;`, not `&&`. A Bash tool is
  also available. Write binary / non-ASCII output from Python with an explicit
  encoding; don't pipe firmware bytes through PowerShell.
- `run_ida.py` is the cipher pass and deletes the updater databases first — that pass
  is already done, so you shouldn't need it.

## Project history (newest first)

- **2026-10-04 — N wave.** Fifteen Opus lanes (`docs/deep/128`–`142`). Fourteen finished
  reporting `claude-opus-5-5`; **N11 was stopped by a safety classifier** and did no work
  (its byte deltas were 0 regardless). The parent dispatched the wave as `claude-opus-5-5`;
  the final reconciliation turn was reported by the harness as `claude-opus-4-8` (model
  drift) — all arithmetic is tool-verified from the files on disk.
  - **Headline (convention D):** 99.9496% → **99.9589% (1,029,549)**. MAIN named 505,165 →
    **505,261** (+96, the only Confirmed bytes among the 519 formerly-unnamed). Proven
    **365,358**, unchanged. SUB unchanged.
  - **The 519 unnamed MAIN bytes are fully classed** (N2): 96 Confirmed, 423 Inferred
    (no-reader data tables). Not 100% — publishing the real fraction, as the brief directed.
  - **New seed `N1_MAIN_FINAL7`** (byte-equal to the M-wave masks, fixed point).
  - **Owner-relevant:** AN2/AN4 = squelch input, AN3/AN5 = S-meter (Confirmed by the on-radio
    alignment-screen labels); AN1 still Unknown. IRQ7/IRQ10 are the two halves of the dual
    concentric knob (DIAL/VOL, swapped by setup `FF89B5`). RX CTCSS/DCS decoders located and
    decoded. The 300 B duplicate EP0 handlers and the 52 B tail are both dead code.
  - **Open:** one convention decision (name no-reader IDA-typed bytes → 100.000%, or keep the
    reader-required rule → 99.9589%); the hardware-only Unknowns (AN1, the VOX net, knob turn
    direction); N11's un-produced deliverable. **No radio write.**

- **2026-10-03 — M wave.** Fifteen Opus lanes (`docs/deep/113`–`127`), all reporting
  `claude-opus-5-5`.
  - **Headline:** 93.78% → **94.12%** (969,428). MAIN named 501,656 → **505,165**. Proven 364,786 →
    **365,358**: −1,472 dead runs (M2–M4), −72 orphaned WIRES-X leaves, +390 `sub_15260` record rule (M6),
    +1,726 CDC handlers (M7). Masks in `ida/out/m-wave-recon/`, re-derived from one descent. SUB unchanged.
  - **New seed:** `M1_MAIN_FINAL6`.
  - **Owner-relevant:** the CDC port is a service-mode USB↔DSP bridge with no flash write (M7); node `'A'`
    injects keys and `'@'` `0x11` sends T-CALL while keyed (M11); `CKPD=200` is the only Bluetooth keying
    input (M12); dry cells cap TX at LOW2 (M8).
  - **Reconciled:**
    - M4's dead arms also orphan the L wave's four restored leaves, so those leaves are dropped.
    - M7's 52 B at `0x0771AE` have no inbound edge and get no proven credit.
    - M5 and M6 agree on `0x018FAA`.
    - M9, M12 and M13 agree on the `12CB8` gate.
  - **Verification:** the orchestrator:
    - re-read every lane's key byte runs;
    - re-ran the checkers of M1, M7, M8, M9, M11, M12, M14 and M15 from scratch copies (all identical);
    - re-checked the UHF table at `0x035140` and the dead-arm structure at `0x06ADE4`;
    - recorded 2 lane citation slips (M2 `0x932C` base, M10 `0x063C10`).
  - **No radio write.**

- **2026-10-03 — L wave.** Fifteen Opus lanes (`docs/deep/98`–`112`), all reporting
  `claude-opus-5-5`.
  - **Headline:** 93.46% → **93.78%** (965,919). MAIN named 498,319 → **501,656** (+3,337, L5's
    Confirmed typing); proven 369,214 → **364,786** (−4,428; L2/L3/L4 demotions, settled by
    one re-run of the folded descent). Masks in `ida/out/l-wave-recon/`; SUB unchanged.
  - **New seed:** `L1_MAIN_FINAL5`.
  - **Owner-relevant:** Bluetooth headset button keys TX (toggle; can stay keyed if the headset
    drops audio) (L10); AN1 TX power foldback / cutoff (L8); node command `'3'` injects PTT (L7).
  - **Reconciled:** L8 over L7 on `'@'` (it sets a flag, it does not start TX); L3 over L4 on
    `0x033780` (no pointer or call anywhere → dead); L10 + L11 agree that K2 swapped E4/E6.
  - **Verification:** the orchestrator re-read every lane's key byte runs, re-ran the L10, L14
    and L13 checkers, re-counted all masks, and found 6 lane citation slips (+2 B addresses,
    recorded). **No radio write.**

- **2026-10-03 — three closed items.** Docs `95`, `96`, `97`. One private
  `--copy-from K1_MAIN_FINAL4` database each. The service window
  `0x078106`–`0x07B753` is 13,902 B: 1,088 B of code (`0x078106`–`0x078545`) and a
  CDC-ACM descriptor set plus lookup tables. **+868 B** proven and named, clear in
  both `final4` masks; the orchestrator re-counted the ranges and matched all 336
  heads to the image and to `bu_all.tsv`. Market bytes are EEPROM `0x21`–`0x23`.
  `sub_34E42` allows `FFAAAE` inside `FF92CE` or `FF92D6`. Citation check: 465/465,
  94/94, 91/91 MAIN, and SUB file `0x349073`. Docs 96 and 97 add no proven bytes.
  Masks, seeds, and older owning docs were not edited. **No radio write.**

- **2026-10-03 — K wave.** Twelve Opus lanes (`docs/deep/83`–`94`; no `86`).
  - **Headline:** 93.37% (961,647 → **961,714**). MAIN proven 368,438 → **368,346**
    (+258 from K1's one-descent seed, −278 demoted at reconciliation); named 497,384 →
    **497,451**; SUB unchanged at 464,263 (K7's masks byte-identical).
  - **New seeds:** `K1_MAIN_FINAL4` and `K7_SUB_FINAL3`.
  - **Touch:** SUB-side resistive panel; 99 zone tables; no hidden screen via touch
    (K2/K3). **TX:** PTT is `0xFFFF4E` b7; TOT 180 s default (K11). **APRS:** four
    automatic TX paths, all off unless APRS MODEM is on (K8). **DATA jack:** no
    host-chosen memory access; only `S` keys TX (K9/K10). **DSP `0x32`** = APRS modem
    config (K5). **SD:** SDHI; formatter unreachable (K6).
  - **Verification:** K12 re-derived the whole J-wave ledger (exact) and checked 310
    citations (292 pass; 18 slips, none affecting a credited byte). The orchestrator
    re-read ~70 cited byte runs and both sha256.
  - **K4** was stopped by a safety classifier before its doc. Written up afterwards
    from the tables it left: `docs/deep/86-dsp-autoreply.md`. Session `0x17` is a PDN
    WIRES-X request. No ledger change.
  - **Models reported:** 11 lanes `claude-opus-5-5`, K10 `claude-opus-4-8`.
    **No radio write.**

- **2026-10-03 — J wave.** Fourteen Opus lanes (`docs/deep/69`–`82`).
  - **Headline:** 93.36% → **93.37%** (961,647 / 1,029,972). MAIN proven 368,366 →
    **368,438**; named/typed 497,314 → **497,384**; SUB unchanged at 464,263.
  - **New seed:** `MAIN_FINAL3` — proven 368,366 reproduces from a **single descent**
    (`H9∪I6∪I8∪I9∪I15 − I12`), fixed point (J1).
  - **The one real byte gain** is handler `0x04E2D6` (+72 B), which I8's table walk
    truncated past (J2); everything else was naming, verifying, or classifying.
  - **New structural fact:** the `0x028CBC` family is the **touch-panel on-screen
    keyboard** — the FT3D has a touchscreen (320×240 hit-test zones) (J3).
  - **USB:** status byte 0 = audio-routing flag `FF8184` (J5); remote button → opens
    last photo, tone `0x4F` bounds the D1 delay (J6); the 8 unnamed registers named and
    `0xFF5C06`–`44` shown to be overrun slack, re-confirming the 63-B overrun (J7).
  - **DSP:** 5 ms tick and 2.2 ms guard **byte-proven**, correcting H15's 10 ms/3 s
    (J8); only PTT and the SCI-A host link key the radio, and a `0x17` auto-reply can
    key it on a received message with no keypress (J9).
  - **SUB:** 156-function residue classified (31 merge, 125 dead, 0 new; +0 B) (J10);
    icon/font/storage record structs decoded (J11). **Settings:** 662/663 attributed
    (J12). **EEPROM:** all four I16 findings byte-confirmed (J14).
  - **Verification:** J13 independently reproduced the entire I-wave ledger and both
    sha256 from disk. All 14 lanes ran as `claude-opus-4-8`. **No radio write.**

- **2026-10-03 — I wave.** Seventeen Opus 5.5 lanes (`docs/deep/53`–`68`).
  - **Headline:** 93.3% → **93.36%**. MAIN proven code is now 365,570 → 368,366. All changes are unions of byte sets, so no byte is counted twice.
  - **New seeds:** `MAIN_FINAL2` and `SUB_FINAL2`.
  - **USB:** the image-push buffer is fed by the vendor USB EP1 OUT (I1). The vendor device is fully decoded (I12).
  - **Pictures:** the C4FM picture path never touches USB (I11).
  - **DSP:** the receive state machine (I4) and the TX scripts (I13, which re-ran I5) are decoded.
  - **Screens and tables:** the 32 orphan screens are classified (I6). The 267 indirect sites are resolved (I8). The "block copy" is an EEPROM cache (I9).
  - **SUB:** the leftovers (I10) and the descent rules (I15) are settled.
  - **Stopped by a safety classifier:** I5, I7 and I16. I7's leftover files were kept as they are by owner decision.
  - **No radio write.**

- **2026-10-02 — H wave.** Fifteen Opus 5.5 lanes (`docs/deep/39`–`52`). Headline
  **90.4% → 93.3%**: SUB window gap closed (+25,866 B code; H8/H10); MAIN re-proven
  with a strict H8SX descent (proven 365,570 B, named/typed 98.3%; H9). New
  `MAIN_H8SX` seed (H2); 119 pointer arrays (H3); DSP pump called only inside the
  closed window (H4); MAIN emits 245 opcodes to SUB (H5); all value tables and
  Japanese labels decoded (H6/H7/H12); F316/F31A dead (H13); SUB link layer and the
  JPEG block transfer (H14); DSP runtime driver, no audio on the link (H15). H11
  stopped by a safety classifier. No radio write.

- **2026-10-02 — G wave.** Three Opus 5.5 lanes (`docs/deep/36`–`38`). G1: MAIN's
  missing instructions are H8SX (`MOV.L @(d:32,ERs)`, 246 sites + a 8.6 KB H8SX USB
  module); +10,701 B decoded, headline +794 B → **90.4%**; core confirmed H8SX.
  G2: the "0xA7xx dispatch bank" doesn't exist — it's five separate IPC builders;
  full MAIN→SUB set = 99 opcodes; table xrefs keep 261/444 indirect functions.
  G3: F3xx menu codes labelled; mode 2 and step 0x0C are both **AUTO** (not AM /
  air step); JPEG decoder is strict baseline; the "8-colour" clamp was an IDA
  sign-display artefact. No radio write.

- **2026-10-02 — relocated** the project and repointed all paths; the launchers
  self-locate.
- **2026-10-02 — completion wave.** Eight Opus lanes closed the deep pass's open items
  (`docs/deep/28`–`35`). An audit found the 92.3% headline overstated (41,263 B of SUB
  layout data was credited below the window denominator) → honest baseline 88.3%; then
  +19,848 B of MAIN indirect-dispatch code was proven (all 149 dispatch tables
  resolved) and +983 B of MAIN raw data typed → **90.3%**. MAIN's remaining gap is
  ~1,867 B of undecodable H8S/2600 instructions. No radio write.
- **2026-09-27 — full decompile pass.** Ten lanes plus a five-lane second wave;
  see `docs/deep/RESUME-FULL.md`.
- **2026-09-26 — USB survey.** `docs/usb-survey.md` and the SUB-USB negatives.
- **Earlier** — the cipher pass and image decryption; `docs/firmware-decryption.md`.

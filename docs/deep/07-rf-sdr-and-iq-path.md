# 07 — RF-SDR and the IQ path (mission question 2)

## Verdict

**No. This radio cannot be made to stream IQ or raw receiver samples over USB, and
the missing link is the sample source itself — there is no wideband converter to
stream.** The FT3DR is a conventional dual-conversion superheterodyne (external
fractional-N PLL bit-banged from MAIN, VCO 1050–2100 MHz, LO 46.875–999.995 MHz,
1st IF 57.60 MHz, 2nd IF 450 kHz — all analog). The only analog-to-digital
converters in the package are on-chip ~12-bit ~1 Msps SAR units (SUB S12AD0/S12AD1)
and a 10-bit SAR on MAIN. They digitize **demodulated audio** (one mono channel,
DC-removed to signed 16-bit) and **housekeeping** values (S-meter/RSSI, battery,
AGC, tune voltage). There is no direct-sampling RF/IF ADC and no quadrature
mixer + stereo ADC producing IQ. Judging the chain link by link:

| Link | Exists? | Where it breaks |
| --- | --- | --- |
| 1. Sample source (IQ/direct-sampling ADC) | **NO** | Only audio/control SAR ADCs. **Hardware cannot** produce IQ or IF samples. This is the weakest link. |
| 2. Transport (DMA/DTC into a mover) | Hardware yes, wiring no | DMAC/EXDMAC exist but are wired to storage/serial/display, not to any converter; the one real sample stream is moved by the CPU in an ISR. |
| 3. USB engine (bulk-IN, throughput) | Partly | MAIN's on-chip USB is full-speed and *has* a bulk-IN endpoint, but it lives on the wrong processor; SUB (which owns every ADC) has **no USB** (USB0 dark). |
| 4. Firmware implementing it | **NO** | No path connects any converter to a USB IN endpoint; USB IN carries CDC-ACM / vendor serial only. |

Two independent reasons each defeat it: (a) **no IQ/RF sample source exists in the
silicon present** (a hardware limit, not a firmware one), and (b) **every ADC is on
SUB, whose USB is dark, while USB lives on MAIN** (a topology gap). Even the
audio-rate stream that does exist is a single mono channel that never reaches a USB
engine.

## Method

Iterated on the private databases `RF_SDR_MAIN`, `RF_SDR_MAIN2` (H8S MAIN, base 0)
and `RF_SDR_SUB` (RX64M SUB, base 0xFFC00000) via `run_job.py`, reusing the
`ida\jobs\rfsdr_*.py` scripts (main_dump/pll/rf/scope/loop, sub_dump/audio, lib).
Nothing touched a radio; files-on-disk only.

Covered:
- **Vectors, both cores.** MAIN 256-entry table at 0 decoded (`main_vectors.tsv`);
  SUB 256 INTB entries at 0xFFED8A70 decoded, unique vs. shared-dummy separated
  (`sub_vectors.tsv`).
- **Every ADC use.** SUB S12AD0 (0x89000) init + scan-end ISR + sample reader;
  SUB S12AD1 (0x89100) init + read; MAIN on-chip A/D (0x32C0). Disassembly in
  `ida\out\rf-sdr\asm\sub_adc_*.asm`, `sub2_audio_isr*.asm`, `sub2_dac_play.asm`,
  `sub2_s12ad1_tail.asm`, `main2_ad_smeter.asm`, `main_ad_read.asm`.
- **Whole-image SUB peripheral coverage** via `sub_periph_sites.tsv` (resolved
  peripheral address per instruction), used for the "Not found" scope claims on
  USB0, RSPI and ADC-fed DMA.
- **Transport.** DMAC ch3 (`sub_dmac3.asm`), EXDMAC (`sub_exdmac.asm`).
- **Front-end.** PLL writer + frequency-plan tables (`main2_pll_writer.asm`,
  `pll_writes.tsv`, `band_tables.tsv`, `main_pll_tables.txt`); band-scope/scan
  candidate (`main_sweep_candidates.tsv`, `main4_scan_engine.asm`).

Could not / did not:
- Did **not** re-derive MAIN's USB stack; cross-referenced BRIEF CORRECTION 1 (USB
  Function Module 0xFFEE00–53, byte-verified descriptors) as instructed.
- `main_iorefs.tsv` captured only top-page (`@0xFFFFxx`) absolute references, so it
  does not list the 24-bit `@0xFFEE00` USB block; that is a limitation of that
  table, not new evidence about USB.
- Did not pin the audio sample clock to a timer reload constant this pass (the
  `sub2_audio_isr2.asm` window is byte-misaligned at its head). The 16 kHz figure
  below is Inferred, not read from a reload register.
- `sub_periph_sites.tsv` reflects functions recovered in this pass, not a
  byte-exhaustive image scan; the USB0-dark conclusion rests primarily on the two
  prior whole-image scans (BRIEF CORRECTION 3), which this table corroborates.

## Findings

### Link 1 — sample source: audio/control SAR only, no IQ, no IF ADC

**SUB S12AD0 is an audio digitizer.** *Confirmed.* Init at file `0x315648`
(`0xFFF15648`): writes `ADCSR = 0x1200` (ADIE set, interrupt-driven), `ADANSA0 = 7`
(three channels AN000–AN002), trigger register `+0x10 = 0x600` (timer-triggered),
and enables the scan-end interrupt in the ICU (`0x87210` region, IPR/IER at
`+0x176`/`+0x576`). The scan-end ISR is INTB slot 134 → `0xFFF15A18`
(`sub_vectors.tsv`). In that ISR (file `0x315A18`):

```
FFF15A2D  bsr sub_FFF15967      ; read one S12AD0 channel (ADDR at 0x89020)
FFF15A32  add #-800h, r1, r1    ; subtract 2048 = 12-bit midpoint (remove DC)
FFF15A3A  shll #4, r1           ; <<4  -> promote 12-bit to signed 16-bit
...store low/high byte into ring buffer at [0x20278]+0x118, count to 0x18000...
```

`sub_FFF15967` (file `0x315967`) selects **one** of ADDR0/ADDR1/ADDR2 (`0x89020`,
`+2`, `+4`) by a mode variable at `0x1250A` and returns it — a single mono sample
per interrupt, **not** interleaved I/Q. The control block at `0x20278` is a
double-buffered record/play engine: buffer limit `0x18000` = 98304 bytes = 49152
16-bit samples (≈3.07 s at an inferred 16 kHz), active-buffer index at `+0x114`,
DAC playback path at `0xFFF159DF` reads `0x12510` → DAC. This is the voice
recorder / audio memory, digitizing post-detector audio. *Confirmed audio-band,
mono, 12→16-bit; rate ≈16 kHz Inferred.*

**SUB S12AD1 is a control ADC.** *Confirmed.* File `0x2E15B0` (`0xFFEE15B0`) reads
`ADDR +0x44/+0x46`, clamps to `0xFFF` (12-bit), scales (`mul #0x140` / `divu
#0xFFF`), and a companion routine (`0xFFEE16EE`) averages four samples and stores
to RAM `0x124D6`/`0x124E6`. Init at `0xFFEE1393` releases it from module stop:
unlock `PRCR = 0xA502` at `0x803FE`, `bclr #16` on `MSTPCRA` (`0x80010`), configure
analog pins via port region `0x8C0xx`, then a **polled single-scan** read (set
`ADCSR.ADST` bit 15 at `0xFFEE1482`, spin until clear at `0xFFEE148D`). No
interrupt, no DMA — a blocking control-loop measurement (RSSI/AGC/tune).

**MAIN on-chip A/D is housekeeping.** *Confirmed.* `sub_32C0` (file `0x32C0`):
`ADCSR @0xFFFFFFA0`, per-channel `bset #5` (ADST) / `btst #5` (poll) / `bclr #7`
(clear ADF), reads 10-bit results from `@0xFFFF90/95/96/99` across channels
0,2,3,4,5, scales (`mulxu.w #0x1AE6`) and quantizes to S-meter bars (thresholds
`0x73`–`0x76`). Polled SAR for S-meter/battery/temperature.

**Whole-image SUB coverage** (`sub_periph_sites.tsv`, region tallies): ports `0x8C`
(270), SCI `0x8A` (181), ICU `0x87` (131), SYSTEM/MSTP `0x80` (77), timers `0x88`
(61), DMAC/EXDMAC `0x82` (53), **ADC `0x89` (40)**, external/`0xC1` (25). The ADC
sites are `0x89000` (ADCSR ×25, ADDR `0x89020` ×4) and `0x89100` (×11). *No
peripheral above the ~1 Msps 12-bit SAR class exists.* No RSPI (`0x000D01xx`) region
appears — *Not found* — so there is no external high-speed ADC/codec on SPI either.

*Inference (strong):* an IQ front-end would read two ADC channels in lockstep into
an interleaved buffer; the firmware does the opposite (mode-selected single channel,
one mono stream). No quadrature/IF sample source exists.

### Link 2 — transport: DMA exists, but not from a converter and not to USB

*Confirmed.* DMAC channel 3 is set up at `0xFFF32E09`: channel registers at
`0x820C0`/`0x820D0`, activation source `0x2C` written to the ICU DMRSR block
(`0x87205` region), common enable at `0x82200`. EXDMAC (`0x82800`/`0x82810`/
`0x8281C`, 21 sites) handles bulk memory/display moves. **Neither references the ADC
(`0x89000`) as a source nor USB as a destination** — *Not found* in the recovered
functions. The one genuine sample stream (S12AD0 audio) is moved **by the CPU inside
the scan-end ISR**, which is adequate at ~16 kHz mono but is not a streaming DMA
pipe. So a transport primitive exists in silicon, but nothing wires a converter
through it toward USB.

### Link 3 — USB engine: present on MAIN, absent on SUB (cross-referenced)

Per BRIEF CORRECTION 1 (byte-verified by the orchestrator, not re-derived here):
MAIN has a Renesas USB Function Module at `0xFFEE00`–`0xFFEE53`, full speed
(~12 Mbit/s), vectors 234/235/238, and a CDC-ACM descriptor at `0x07B680` exposing
**EP2 IN bulk 64** — i.e. a bulk-IN endpoint capable of carrying a stream in
principle (16-bit audio at 48 kHz ≈ 1.5 Mbit/s would fit). But:
- **SUB USB0 is dark.** *Confirmed.* `sub_periph_sites.tsv` shows **0** references to
  `0x000A0xxx` (the USB0 register block), corroborating the two prior whole-image
  scans and doc `03-sub-usb-hardware.md`. Every ADC and the audio buffer live on
  SUB, which has no working USB — so the sample stream cannot reach a USB engine on
  its own processor.
- MAIN's USB IN endpoints are driven by the CDC-ACM / vendor-class stacks (command
  and response bytes), not by any sample buffer.

### Link 4 — firmware: no converter→USB path exists

*Not found* (MAIN + SUB recovered functions). No routine copies an ADC result or an
audio/IQ buffer into a USB endpoint data register. The audio buffer at `0x20278`
(SUB) is consumed locally (playback DAC, and/or handed to the DSP/inter-processor
link per docs 06/09), never to USB. Installing new firmware would not help link 4,
because link 1 has no IQ/IF source to feed it, and BRIEF CORRECTION 7 already
established **neither application can write its own flash** and the update path is a
hardware-strap decision.

### RF architecture context (why link 1 is a hardware limit)

*Confirmed.* MAIN bit-bangs a 3-wire bus on port `0xFFFF5D` (CLK bit2, DATA bit3,
LE bit6/bit7) to an external fractional-N PLL (writers `0x037BA0`/`0x037BA4`;
`pll_writes.tsv`). Frequency plan (`band_tables.tsv`): VCO 1050–2100 MHz with output
dividers /2../32 giving continuous LO 46.875–999.995 MHz; fixed LO constants imply
1st IF 57.60 MHz and 2nd IF 450 kHz; LO resolution 1250 Hz; RF preselector filters
switched per band. This is a textbook narrowband superhet: the signal is never
digitized at IF or as IQ — only the demodulated audio is (link 1). The **BAND SCOPE**
is therefore a swept-power display, not an IQ/FFT spectrum: the only function
reaching both the RSSI reader (`0x3466`) and the synthesizer-tune path (`0x37A56`)
with a loop is `sub_03EA28` (`main_sweep_candidates.tsv`), i.e. step LO → read
S-meter → plot.

## USB relevance

- **Q2 (this doc):** USB SDR is not feasible. Missing link = the sample source; the
  hardware present cannot produce IQ or IF samples, and separately the ADCs and USB
  sit on different processors with SUB's USB dark.
- **Q1 (Everything USB):** reinforces that the radio's live USB surface is MAIN's
  Function Module only, and its IN endpoints move CDC-ACM/vendor serial, not bulk
  sample data. The `0x20278` audio record/play engine is a data structure another
  agent may map to the SD voice-recorder or the DSP link — not to USB.
- **Q3 (DSP reachable):** consistent with doc 06 — the C4FM demod/vocoder is MAIN's
  on SCI-C `0xFFFF88` and outputs fixed 32/96-byte frames, not IQ; it is not a
  sample source for SDR.

## Open

Most valuable first:
1. **Confirm the audio buffer's consumer.** Trace `0x20278` (SUB) reads: does it go
   to SDHI (voice recorder to microSD) or across the inter-processor SCI to MAIN?
   Settles definitively that no sample data path aims at USB. (STORAGE/BOOT-IPC
   overlap.)
2. **Pin the audio sample rate** from the MTU6 timer reload (INTB slot 210 →
   `0xFFF1527B`) to replace the inferred 16 kHz with a read value. Cheap.
3. **Identify DMAC ch3 source `0x2C` and the EXDMAC endpoints** to name what the DMA
   actually serves (expected: SDHI / SCI / display), closing link 2 with positive
   attribution rather than "not the ADC."
4. **The `0x000C1xxx` region on SUB (25 sites)** is unclassified here (external-bus /
   display class, not an ADC); identify it so the SUB peripheral map is complete.

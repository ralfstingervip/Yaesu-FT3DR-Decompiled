# main-051CD8-058C06 — wave C notes

Range 0x051CD8–0x058C06 (237 functions; 202 Confirmed, 34 Inferred, 1 Skeleton). Subsystems:

1. **APRS address encoder** (0x051CD8–0x052000): TNC2 text `CALL-SSID` → 10-byte slot
   (6 chars bit7-clear, 3 SSID-text bytes, AX.25 SSID octet `0x60|ssid<<1`), path list with
   H/EA bits, status FFA50A (0/1 bad SSID/2 long call).
2. **Caller/log display lines** (0x05206E–0x0521F6) queued by sub_C7E4 (12 bytes to *[FFBC2C]+4).
3. **APRS duplicate check + per-type payload extent routines** (0x0521F6–0x05266C).
4. **Decimal formatter** with nine entry points (0x05270A–0x052888) and row-callback runners /
   row thunks into *FFB288 (0x0528DA–0x053784).
5. **APRS list/detail screen frame builders** (0x052B7C–0x05327C): text lines into the MAIN→SUB
   IPC frame FF3D72, senders F500/F502/F511/F518 (doc 37).
6. **Own position, distance and bearing** (0x053784–0x054502): position records, a 1488-byte
   flat-earth distance + 16-point bearing routine (sub_539DE).
7. **APRS automatic TX tasks** (0x054536–0x054AC0): beacon mode, band check, busy check, message
   retry (60 s / 3 s), auto-ack (3 s). Matches doc 90.
8. **USB function module driver** (0x054BF8–0x0557A2) — re-verified against l15_usb_vendor.c.
9. **Picture block-transfer engine** (0x055976–0x055FFE) — docs 53/63.
10. **DSP SCI-C driver** (0x056036–0x056A94) — doc 52; **DSP RX state handlers and message
    stores** (0x056A94–0x058C06) — doc 56 / ida/out/dsp-rx/states.tsv.

## Findings / contradictions

- **Doc 12 §8.4 is wrong about sub_52C8C.** It is the APRS station-list line formatter: FF9E08..27
  is a 32-byte copy of a list record from FEE000+32n (copied at 0x052C0C), FF9E1F is record +0x17
  (a station-type index into the ROM char table 0x3EA2, default 0x1D), and "Emg" marks an
  emergency record (FF9E22 b5). Destination lives in FF800F (doc 50), not FF9E1F.
- **Doc 70's "sensor display" table 0x04ABE4** starts with this range's APRS payload-extent
  routines (0x052278 ×2, 0x05230E ×12, 0x0523D0 ×8, 0x052470 ×4, 0x052504, 0x052582, 0x0525F6),
  dispatched by FF9DFF from the duplicate-packet check sub_521F6. 0x04ABE4 = 0x04AB70 + 0x1D×4,
  so the two tables overlap; slot 68's baro handler belongs to the 0x04AB70 reading.
- **L15 corrections (l15_usb_vendor.c):** FF8156 is the SETUP-ring *write* pointer (ISR) and
  FF8152 the *read* pointer (poll); FF8158 is only the low word of FF8156. State 11's D2 path
  stores usb_latch = 0x0A (0x055774), not 4. IFR2 b3 sets FF8180 b7 (0x054FCE), missing in L15.
- ']'-class letter 'P' and 'G'-class letters 'g'/'h' branch into the N-store (0x058032), so
  those messages land in FF07A4, not their own class store.
- Message retry task: after a found retry slot the timer is 3 s; an empty scan re-arms 60 s.

## Left undone

- sub_539DE: cos-latitude table maths and bearing mirror tables summarised, not transcribed.
- sub_53496: loop body 0x0534C0 outside chunk (dead tier).
- Gap targets outside the chunk not decoded: 0x05460C (beacon send body), 0x056626 (link idle
  line-high part), 0x053FAE (failure branch of sub_539C6), 0x0583C8 (host-link copy).
- RX state handlers for the A7/A8 duplicate states are written as one template with per-state
  next-state table rather than 25 separate bodies.

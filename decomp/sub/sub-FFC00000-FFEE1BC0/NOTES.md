# sub-FFC00000-FFEE1BC0: notes

Range: the SUB reset entry `FFC00000` plus the first code band `FFEDAB4C`–`FFEE1BC0` (204 functions).
All 204 have a header and a C body in `sub-FFC00000-FFEE1BC0.c`: 200 Confirmed, 4 Inferred, 0 Skeleton.
The work is static only, from the lane listing, the whole-image listings and the docs.

## Subsystems (address order)

1. The reset entry. It is the CC-RX `PowerON_Reset_PC`.
2. The 3-channel SCI ring driver (`FFEDAB4C`–`FFEDC16C`):
   - ch0 = SCI0, the MAIN link;
   - ch1 = SCI2, the GPS;
   - ch2 = SCI3, Bluetooth.

   The pieces are the ring descriptors at `0x12CD8`, the callback blocks at `0x12D20`, a per-SCI open/close/kick, the RXI/TXI ISRs, and the GROUPBL0 TEI/ERI dispatcher (vector 110).
3. The MAIN<->SUB link layer (`FFEDC16C`–`FFEDDED5`): the deframer, the dispatcher, the 4-slot queue, and the E0/E1/E2/E3/FF/FE/EA builders.
4. The LCD panel driver and the LCD power sequencer (`FFEDDED5`–`FFEDE387`).
5. The picture screen 0x3E (FFFF image -> JPEG decode -> blit) and the alignment screen 0x3F (FD00).
6. The UI phase machine (`0x1CC60`, table `FFED4040`) and the opcode->screen classifiers F0..FF.
7. GPS: power control, the NMEA assembler and parsers, the `$PMTK` sequencer and the fix accessors.
8. The TPU0 5.46 ms tick, the software timers (`0x1CDE4`) and the resistive touch panel.
9. The CC-RX `lowsrc.c` runtime: `_INIT_IOLIB`, `_CLOSEALL`, `open`, `close`, `write`, `read`, `lseek` and `sbrk`, plus two dead BCD helpers.

Some dispatch-table contents came from `ida/out/**/*.tsv` data refs:
- `FFECE50C` = {rts, power_on, display_on, blank};
- `FFED3F6C`, `FFED3F8C`, `FFED3FA0`, `FFED3FB0` are the picture and alignment step and event tables;
- `FFED4040` = {phase0, phase1, phase2, rts};
- `FFED4050[0x3E]` = `FFEDE387` and `FFED4050[0x3F]` = `FFEDE97B`.

## Most interesting findings

- **The dequeue keeps only the newest frame.** `link_dequeue_latest` (`FFEDC1F6`) discards every older queued slot. Frames that arrive faster than the TPU3 pump runs are coalesced. This was not stated in docs 51/84.
- **Pump-priority switch.** On an FFxx frame, `link_dispatch_frame` raises IPR136 (the TPU3 UI pump, vector 136) from 1 to 2. Other frames, except F6xx, drop it back to 1. While an image is arriving, the tick cannot preempt the pump.
- **Block read-back edge case.** For the last block, the data length is the low byte of the running byte count (`blk_bytes`). A final block of exactly 256 bytes is therefore echoed with 0 data bytes.
- **Queue slot overflow (latent).** `link_enqueue` copies `link_frame_cnt` bytes (up to 0x8001) into a 300-byte slot. It is safe only because MAIN frames are short.
- **SCI ring level formula is inconsistent.** `sci_write` and `sci_rx_ring_level` return free space when head >= tail and used space otherwise.
- **`sciN_set_format` hangs if SCR was live.** It spins forever (`FFEDB630`) when TIE/RIE/TE/RE was set on entry. The likely cause is a u8 delay loop with an always-true condition. It is reached only after `sci_hw_init` has cleared SCR.
- **LCD controller.** The init sequence is the ILITEK ILI9341/9342 command set (C8h FF 93 42 EXTC, MADCTL 08, COLMOD 55, gamma E0/E1). With the 320x240 window, an ILI9342-class panel is inferred.
- The LCD power-sequencer table has only 4 code entries, but `lcd_seq_set` accepts states up to 8.
- **GPS details:**
  - sentences without `*hh` are accepted;
  - the `$PMTK001` ACK advances the sequencer stage without checking which command was acknowledged;
  - no fix for 60/180 slot-2 periods triggers a `$PMTK102` warm restart;
  - a datum change from a set value triggers a `$PMTK103` cold restart.
- **Picture centring.** An image larger than 320x240 is halved. One of 160x120 or less is shown doubled: the decoder scales it via ctx+0x42.

## Corrections to existing docs (owning docs not edited)

- **doc 14 sec.3, GSV sort.** The GSV table is sorted by **PRN ascending**, not by SNR. The exchange sort compares record byte 0, the PRN. The SNR is at offset 4.
- **doc 14, `sub_FFEE0C85`.** It returns packed BCD with one implied decimal, not "hex".
- **doc 14, `sub_FFEE0CF3`.** It is unsigned: a '-' yields 0.
- **doc 14, sentence buffer.** The raw sentence is at `0x8A93`. `0x8B96` is the current-field scratch.
- **doc 109 builder table.** The buffers of `sub_FFEDD528` and `sub_FFEDD6FB` are `0x1C33A` and `0x1C3BA` (0x12D44+0x95F6/0x9676). Doc 109 has `0x2433A`/`0x243BA`, an arithmetic slip; doc 107 already has `0x1C33A`.
- **doc 84, echo skip.** The echo is skipped "for 0xFCxx", but the test reads the deframer's current frame byte `0x12D49`, not the dequeued slot.
- **doc 20, "polled twins".** `FFEDB7B6`/`FFEDB8A5` (and their SCI2/SCI3 copies) are the GROUPBL0 ERI and TEI handlers, not polled twins.

## Left undone / caveats

- **Imprecise bodies.** Some helper calls outside the range are named descriptively, for example `surface_open` = `sub_FFEEF9BB` and `draw_text` = `sub_FFEF1B23`. The address is given in a comment where it matters.
- **Unread data.** The LCD gamma bytes are not transcribed. The software-timer reload tables (`FFC3EB7E`, `FFEB74D8`) were not read, so the real timer periods are unknown.
- **Unknown meanings:**
  - the UI flags `0x8D79`–`0x8D7D` and `0x8F72`/`0x8F74`;
  - the frame byte +0x13 "mode" families.
- **Display traps.** IDA shows unsigned 8-bit immediates as negatives (#-1 = 0xFF). They were converted throughout. The one simm16 mask in `ui_phase2_run` is kept as 0xFFFF800F.

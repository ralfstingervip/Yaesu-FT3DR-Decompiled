# Lane main-06F48C-078546 (MAIN H8SX 0x06F48C-0x078546)

296 functions; functions.tsv: 249 Confirmed, 35 Inferred, 12 Skeleton.
Static analysis of the rebuilt listing plus the binutils oracle
(`ida/out/h8s-decode/work/bu_all.tsv`) for bytes outside defined functions.

## What the range is

- **06F48C-07131E: SD-card client.** MAIN keeps no FAT code; it posts fixed request
  frames to the SUB file server (pc-02). The state machine is `sd_task` (FFBA30, states
  0-5): mount wait (reply event C8/C9/CD), file-size probes (BACKUP.dat 0x1FDC0,
  QSOMNG 0x20, MEMORY.dat 0xAC80, WAVMNG 0x20), QSOLOG store initialisation, then
  idle. In the idle state, `sd_step_dispatch` runs one of 47 continuation steps
  (off_703E6[FFBAA3]) per FE reply, or a timeout handler (dword_704A2). About 40
  "poster" routines arm one request each (template ROM 071326-073030, name at +0x56);
  `sd_request_build` (071196) serialises it. The QSO list pager, the BACKUP/MEMORY-CH
  menu, the voice recorder (\VOICE, YYMMDDHHMMnn.wav), the GPS log (\FT3D\GPSLOG,
  .log) and photo save/stat all live here.
- **073030-073412: Bluetooth link FSM** (BB90/BB8E/BB70, the 5-slot device list at AAEC).
  It matches doc 124. Doc 108 called the E4 frame "WIRES-X/node status"; doc 124 and
  this code show it is the Bluetooth module status.
- **073412-073B62:** SCO hold, cable clone (doc 24) and the DATA-jack node parser.
- **073B6C-074472:** the 48 node-command handlers (doc 104).
- **074562-0750C2:** BACKUP.dat / MEMORY.dat writer and reader (pc-02).
- **0750C2-075F34:** apply hooks that run after a restore (per-destination conversion).
- **075F36-076256:** edit-buffer helpers.
- **0762DC-07711E:** USB CDC-ACM control and data path (docs 42/119).
- **0771E2-078102:** command layer for the separate 3-wire serial device (doc 82:
  sub_334CA write, sub_33532 read).
- **078106-078545:** service-window routines (doc 95).

## Notable findings / contradictions

1. **Node commands '4' and '5' are a RAM/IO peek and poke.** This contradicts doc 104,
   which says no node command exposes host-chosen memory access. `sub_73BE2` copies n
   bytes (n = 1..0x80) from `0x00FF0000 | arg16` (`073BEC mov.w r1,r5 ; mov.w #0xFF,e5`).
   `sub_73C24` copies host data to the same kind of address (`073C2E`). Commands '6'
   and '7' read and write the EEPROM at a host-chosen 16-bit address (sub_3AB80 /
   sub_3AD20). All four work only in remote mode (FF8004 >= 2, entered with command '0').
2. **Node command '3' polarity is the reverse of doc 104.** arg 1 gives key 0x0E (PTT
   press) and arg 0 gives 0x0F (release). When the radio is already keyed, arg 1 stores
   key index 1, because r4l still holds the FF94C0 value. This looks like a bug.
3. **FFBA32 is the SD card state, not "picture on-screen" as doc 74 says.** It is
   written from reply +0x0C (values 2/3) in `sd_state_mount_wait`. It gates every SD
   menu and popup 0xA7 means "no card". Key 0x14 therefore needs a card that is ready.
4. **Other doc-104 table corrections.** 'W' writes the radio ID: eepmov copies 96FA to
   8060. 'Y' loads a ROM block, not host data. 'E', 'M' and 'L' pick a band or a slot
   (8970/8971, 8974/8975, six trim words). 'A' injects a key or digit press.
5. **Restore apply hooks depend on the destination.** The BACKUP/MEMORY restore runs
   hooks 750C2/75160/754BC only when the market variant byte F1FA[sub_3F386()] is 0.
   pc-02 describes them as unconditional. FF89C4 is also set to 5.
6. **The probe retry path is odd.** At 0700FC it writes `(port FBA5 & 0xF0) - 1` into
   the retry counter BAA7. This is a literal reading and looks like a register-reuse quirk.
7. **Code that is not a defined function.** 070AFE (a QSOMNG poster, called from 070264)
   and the 06F786-06F795 tail of sub_6F6E2 were read from the oracle. 06F586-06F5B3 is
   template data, so the real entry is 06F5B4.

## Left undone

- `restore_convert_vfos` (075554, 2400 B): Skeleton. It has five unrolled
  per-destination bodies, and their windows and field rewrites are not decoded.
  075160/0753D4 are only partly done.
- `editbuf_input_char` (0762DC, 1250 B): Skeleton. 076080 and 0761C8 are abridged.
- CDC handlers 076C0A, 076EF8, 07711E and 07827C: bodies are summarised from doc 119
  and doc 95, not re-transcribed. The ring helpers 078334, 07837C and 0783DA are also
  summaries.
- 3-wire device helpers 0771E2-077D16: meanings are Inferred, and the bodies are short
  sketches.
- BACKUP/MEMORY reader and writer steps 7-9 (and the MEMORY steps) are described in the
  headers. The C bodies there are partial.

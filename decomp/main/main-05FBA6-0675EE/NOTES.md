# main-05FBA6-0675EE — WIRES-X UI, `]` requests, GM screens, message box

Wave C lane. 476 functions, MAIN `0x05FBA6`–`0x0675EE`. Output: `main-05FBA6-0675EE.c`,
`functions.tsv`, `globals.tsv`. Static analysis of the listing only.

## What the range is

- **WIRES-X user interface (home app mode 9, `[A9F9]=9`)**, `0x05FBA6`–`0x0631B8`. The X-key entry
  `wx_enter` (`0x05FC0E`), exit, and one handler per key per state. Every key handler dispatches on
  `wx_state` (`FFB3EA`) through a 69-entry table: DIAL `off_5FEA2`, key 7 `off_601F4`, PTT `off_610BA`,
  key 8 `off_617EA`, render `off_61C5A`. The key slots come from key table #11 (`0x011388`, doc 103):
  s05 key 5, s06 X key, s07 select, s08 view toggle, s13 DIAL, s14 PTT press, s15 PTT release.
- **The `]` request builders** (`0x062ACA`–`0x0631C4`) match doc 86's B0B9 census: `]c` 0x0D room
  connect, `]l` 0x0E, `]r` 0x0F read news item, `]q` 0x12 search, `]#` 0x13 connect (by list row or
  typed number), `]f` 0x14 list/search/news, `]g` 0x15 category status, `]*` 0x1D. All of them share
  one prologue (no TX already, `sub_22F78` digital/DSP/callsign check, `sub_22FEE` software TX
  request) and one epilogue `wx_msg_commit` (`0x0631C4`): build the `]` header, store the length in
  `B1C3`, body pointer `FF0C3D` in `B1D0`, and start a 12 s reply timeout in `FF9599`.
- **Node answers and the poller**: `wx_poll` (`0x063216`, from the main loop) dispatches received
  letters `A/B/Q/R/F`. It also runs the 2.8 s / 30 s search timer from doc 86 T6. Answer handlers:
  `wx_rx_node_info`, `wx_rx_room_status`, `wx_connected`, `wx_room_lost`, `wx_rx_no_data`.
- **Mode 10** (`0x063C04`–): group/member tables at `FFB4A8`/`FFB5B8`. The member table shares RAM
  with the WIRES-X category list.
- **Message box** (`0x064634`–`0x0661C8`): states 0x1F–0x3F (pages F6xx). There are 20 × 128-byte
  records per page at `FEEF20`, the open record is at `FF2FCA`, and an 80-character editor works on
  `FF061A`. Attachments go through SD jobs in `BAA3` (doc 63 names `FF301A`/`FF301E`).

## Findings

1. **PTT carries WIRES-X requests.** On SEARCH & DIRECT, the connected screen and the list screens,
   PTT keys up (`sub_2244C`) and also sets `AAD4.b1`/`B132=1` with the target ID in `B314`/`B349`.
   This is "connect by PTT", and it marks `wx_busy.b6`. While linked to a room (`B2C8>='3'`), PTT in
   the content states sends the room ID with the voice (`wx_ptt_talk`, `AAD4.b4`).
2. **Hold-PTT transmission (doc 86 T7) confirmed.** `wx_arm_hold_tx` (`0x0615AA`) arms state 0x29
   with a 3.5 s timer. PTT release (`wx_ptt_up`, key slot 15) cancels it. On expiry with PTT still
   held, `wx_timers` fires `sub_61624` → `sub_6631E` → TX. The upload variant (`wx_ptt_s1B`) keys up
   immediately with a 60 s `FF95E6` limit and tone 0x5B at timeout.
3. **Request body layout.** In WIRES-X mode the body is the 5-byte destination ID, then the node ID
   `B2AA` (5), then the arguments, then `0xFF`. In mode 10 it is the 10 bytes of `B314`. `]q` and `]*`
   send the fixed 10 ROM bytes at `0x004C14`.
4. **"DNEWS" is a pseudo-room.** `wx_check_id` refuses it as a connect target and blanks the target
   ID. The DNEWS path goes through `]c`/`]r` instead (`B26B.b4`).
5. **Popup protocol to SUB.** Set `BBE1`, and when it differs from `FF3D87`, re-arm the frame length
   `FF3D72←FF4174`. Result tones are 0x54 no data, 0x55 node found, 0x56 connected, 0x57 room lost,
   0x58 connect failed.

No contradiction with existing docs was found. Doc 86's T6/T7 timings use the 100 ms tier, and the
code here agrees (`FF959B`, `FF95E4` are slow-tier cells).

## Left undone

- About 119 functions from `0x065302` onward are **Skeleton**. Their headers list callers, state
  stores, tones, calls and globals, extracted from the listing, with a `TODO(waveC)`. This covers the
  message-editor tail, `0x0661C8`–`0x066966` (mode-10 PTT/keys, the upload TX), and the content-page
  renderers `0x066966`–`0x0675EE`.
- The dial descriptor bytes (`0x0601B0`, `0x064232`…) and ROM strings `0x067FA4`, `0x004C14`,
  `0x0631B8` are not in the listing, so their values are unknown.
- Physical key names for slots 5/7/8 are not identified, so the handlers are named by slot.
- Labels inside the poller's letter dispatch (`0x063390`–`0x063AAA` gaps) are outside the function
  list and are referenced by address only.

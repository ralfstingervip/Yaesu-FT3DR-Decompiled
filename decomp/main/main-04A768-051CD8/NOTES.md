# main-04A768-051CD8: notes

310 functions, 0x04A768 to 0x051CD8 on MAIN (H8SX). The whole range is the **APRS application
layer**, which sits above the HDLC/FCS layer that doc 90 covers:

- **Pop-ups** after a received packet (04A768..04AAE8): gated on the main-screen mode.
- **Station detail pages** (04AAE8..04F3E4). `aprs_detail_open` takes the page opener from table
  `0x04AB70` by packet type. Each opener decodes the position, then calls `page_open` (sub_52DB0)
  with a *page descriptor*: an array of row-callback pointers, the first being the title row.
  Each row callback formats one 22-char line into `disp_line` (FFB05A). `sub_5314A` shows 5 rows
  from `descriptor + 4*page_scroll`.
- **Position decoders**: Mic-E (destination-encoded latitude with ambiguity; longitude from
  info+1..3 with the +100 offset and 180..199 folding), uncompressed `DDMM.hhN`/`DDDMM.hhE`, and
  base-91 compressed. The compressed decoder uses `90 - y/380926` and `-180 + x/190463`, worked
  in 1e-4 degree units.
- **Extension rows**: PHG (power p², height 10·2^h ft, gain, directivity), CSE/SPD, compressed
  cs (course c·4, speed 1.08^s−1, range, altitude 1.002^cs), the weather fields g t r p P h b
  plus L/l/s, Mic-E speed/course/altitude, device type, and status text.
- **SUB frame builders** for message detail, compose, and status-text edit (04F564..05002A).
- **DTI classifier** `aprs_classify` (05017C) and the APRS generic-destination filter (0502D2).
- **Station/message list** cursor, load and delete logic, and message read/retry flags
  (050402..0507AC).
- **Message compose/editing** (CLR/INSERT/CLRALL/DELETE, labels at 0x4FDB0).
- **TX builders**: the message and ack frames from doc 90, the `APY03D` header, the
  source/digipeater path, and the Mic-E destination/info encoders called by the beacon builder
  sub_495DE.
- **AX.25 address decoding** into 10-byte records, and third-party (`}`) header parsing.

## Notable findings

1. **Packet type numbering** (FF9E1F / FF9DFF). 0/1 are Mic-E (`'` / `` ` ``). The table
   "////@@@@!!!!====;;;;))))_>" at 0x3CA2 gives four types per DTI: base = uncompressed,
   +1 = compressed, +2 = weather (or killed, for objects and items). Then 26 = `_` weather,
   27 = `>` status, 28 = other, 29 (0x1D) = none. This matches the names table at 0x3CBE
   (Mic-E, FIXED/fixed, WEATHER/weather, OBJECT/KILLOBJ, ITEM/KILLITM, STATUS, OTHER).
   `:` messages also return 0; the caller tells them apart by the DTI.
2. **Doc 70/83 correction, layout only.** `0x04ABE4` is not a 256-entry dispatcher. `0x04AB70`
   and `0x04ABE4` are two 29-entry per-type tables (29×4 = 0x74, so 0x04ABE4 + 0x74 = 0x04AC58).
   From 0x04AC58 onward come the page descriptors. Cell 0x04ACF4, which holds `0x04E2D6`, is
   row 10 of the descriptor at 0x04ACCC (the compressed weather page). The other cells doc 83
   lists (0x04ADFC, 0x04AE4C, 0x04AFB8) are the Baro rows of the other weather pages. The
   72-byte byte accounting is unaffected. `0x04E2D6` is now fully decoded as `row_baro`: tenths
   of hPa, rounded to whole hPa.
3. **Doc 118 tables named.** 0x04E76C (u16[91]) is compressed speed in knots. 0x04E822 /
   0x04E8D8 (u16[91]) are radio range in tenths of a mile / km. 0x04E98E (u32[91]) and 0x04EAFA
   (u16[91]) are the two factors of the 1.002^cs altitude.
4. **Mic-E device identification** (`mice_type`, `mice_yaesu_code`): `>`/`]` with `=`/`^`
   trailers decode to the Kenwood models, and `` `…_x `` trailers to Yaesu VX-8 … FT3D. The
   names table is at 0x04C32C.
5. **Generic-destination filter** (0502D2). Unless FF8AAF.0 is set, a frame is classified only
   when its destination matches a known APRS generic destination: 2-char (AP, CQ, DF, DX, WX,
   ID), 3-char (AIR, ALL, GPS, …), and longer entries. Other frames get type 0xFF and are
   discarded.
6. **Unit bits** of FF8AAC, from use here (doc 45 lists the labels only): b0 position format,
   b1 distance (mi), b3 altitude (ft), b4 temperature (°F), b5 rain (inch), b6 wind (mph).
   FF8AAD holds speed: 0 km/h, 1 knot, 2 mph.
7. The message record has outgoing / group / bulletin / read flags in +0x1A (b0/b1/b3/b7). Retry
   byte +0x1B: 0 = acked (shown `*`), FF = stopped by the user (sub_50748). An outgoing message
   loads FF95B6 = 0x1770 (60 s), which matches doc 90's retransmit interval.

## Conventions / caveats

- This code is hand-assembly style. The parse cursor is in er2 and the display cursor in er6,
  and results come back in r3l/r4l plus the flags. The C models er2 and er6 as globals `P` and
  `D`. Many IDA "functions" are mid-function entries or splits; each one is labelled as such.
- Label strings are referenced by address and are not quoted in full.

## Left undone

- `0x051366`–`0x0513D5` (the Mic-E `}` altitude encoder reached from sub_5135C/513D6) is absent
  from the listings. 051352 and 05135C are therefore Skeleton.
- The slot-to-handler mapping of jump table 0x4B9EA (row_mice_call_comment) needs the table bytes.
- In `mice_dest_build` (051144), the longitude-offset digit tests r1l. The call sites never
  visibly load r1l, so this is still open (possibly a firmware bug).
- The bodies for 04F3F8..051CD8 are briefer than the rest. Names and confidence levels are in
  functions.tsv.

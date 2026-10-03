# 95 — Service window `0x078106`–`0x07B753`

## Verdict

The inclusive span `0x078106`–`0x07B753` is 13902 bytes. The first 1088 (`0x078106`–`0x078545`, 336 instructions) are a gated USB function-module personality: a buffer clear and interrupt-enable setup, a polled service that calls `0x0768A8` and the SCI-C byte pump at `0x076FC8`, an ISR walk of a 10-byte handler table, ring helpers, and SCI-C asynchronous setup (bytes `0x08`, `0x0C`, `0x70` written to `FFFF88` / `FFFF89` / `FFFF8A`). Boot calls `0x078106` only on the branch where `(byte at FFFF4C & 0x7F) == 0x7D`, and that branch stores 1 to `FF813A`; the USB ISR calls `0x07827C` only when `FF813A` is nonzero; `0x07815C` runs only when the byte at `FFB0C4` is 5 or greater, and `0x078222` is the SCI reconfiguration on that same state machine. The strap-fail path stores 0 to `FF813A` and calls `0x054BF8` then `0x054C44` instead, so this personality stays off unless the strap matches or the DSP-WRITE state is in those upper values. The other 12814 bytes are data: a CDC-ACM descriptor set (class `0x02`, VID `0x26AA`, PID `0x0020`) in the block boot copies to `FF6034`, plus 16-bit lookup tables consumed from outside the window. No sample or IQ buffer is present.

## Method

Image `decrypted/FT3D_MAIN_ver102_EXP.bin`, 1048576 bytes, sha256 `8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce` (Confirmed). File offset equals address. The SUB image was not used.

Inclusive length is `0x07B753 - 0x078106 + 1` = 13902 (`0x364E`). The last byte is `00` and the next byte is `ff` (`citations.tsv` rows `07B753`, `07B754`). The older "898 B" figure is the 16 byte-class runs inside this same address span that `ida/out/wave2/main-raw-types.md` left unanalysed. That figure was not edited. It is not this span.

Instructions were decoded with the binutils oracle `ida/out/h8s-decode/work/bu_all.tsv` through `common.flow`, then checked against the image. The 336 heads in `ida/out/service-window/code-heads.tsv` match the image and the oracle (0 mismatches, 0 overlapping bytes). They occupy `0x078106`–`0x078545` with no gap. `ida/out/service-window/disasm.asm` is that listing plus a hex dump of `0x078546`–`0x07B753`.

IDA, private database only: `ida/run_job.py --db L95_SERVICE --copy-from ida/db/jobs/K1_MAIN_FINAL4/K1_MAIN_FINAL4.i64`, script `ida/jobs/l95_window.py`. The database bytes of the window match the image (`image_match True`, 13902). Before edits the window had 152 heads, 99 of them code. Items were deleted and recreated only inside `0x078106`–`0x07B753`. `plan_range` was limited to that range: 336 code heads, 0 extra code heads, collar `0x078000`–`0x078105` and `0x07B754`–`0x07B8FF` unchanged. All 336 IDA lengths matched the oracle and the image bytes. Eight mnemonics differ only as IDA synonyms (`push.l` / `pop.l` for `mov.l` through `er7`, `inc.b` for `inc`) at `0x07815C`, `0x078230`, `0x07824A`, `0x078280`, `0x07830C`, `0x07832E`, `0x07842E`, `0x078442`. IDA text is `ida-listing.txt`. Heads are not treated as proof ahead of the image bytes.

Caller sites below `0x078106` were read only far enough to name the edge. A handler-table entry (`0x0767BE`, `0x0768C8`, `0x0769AA`) was followed when the copied table names it. The pump and `0x0768A8` were read only far enough to name the call.

Proven mask, read-only, not modified: `ida/out/main-final4/final4_proven_mask.bin`, 1048576 bytes, 368624 bytes set. It is the newest `*proven_mask.bin` under `ida/out`. Inside the window it has 220 set bytes, all inside the 1088 code bytes, and 0 set bytes in the data. Code bytes unset in that mask: **868**. Ranges:

| range | bytes |
| --- | ---: |
| `07810C`–`07815B` | 80 |
| `0781A4`–`0781A9` | 6 |
| `0781C4`–`078221` | 94 |
| `07823C`–`07825F` | 36 |
| `078268`–`078279` | 18 |
| `07827C`–`078333` | 184 |
| `07833C`–`07837B` | 64 |
| `078384`–`0783D9` | 86 |
| `0783EE`–`07842D` | 64 |
| `078440`–`078441` | 2 |
| `078448`–`078459` | 18 |
| `078462`–`078507` | 166 |
| `078514`–`078545` | 50 |

Evidence words: Confirmed means the image bytes were read. Inferred means those bytes plus a stated assumption. Not found states the scope. Unknown is unnamed.

`:8` and `:16` immediates are the sign-extended addresses (`0x4c:8` is `FFFF4C`, `0xee04:16` is `FFEE04`, `0x8a:8` is `FFFF8A`). Names IFR/IER/ISR/TRG for `FFEE00`/`FFEE04`/`FFEE08`/`FFEE2C` are the names already used for those addresses (Inferred). SCI-C for `FFFF88`–`FFFF8C` is the same kind of assumption.

## Findings

### Two layers

| bytes | what |
| --- | --- |
| `078106`–`078545` (1088) | 18 routines, one contiguous instruction stream |
| `078546`–`07B25F` | 45-word branch table, six 16-byte maps, 5680 big-endian lookup words |
| `07B260`–`07B2A5` | 16 zero bytes, then USB string descriptors |
| `07B2A6`–`07B753` (0x4AE) | image copied to `FF6034`–`FF64E1` |

RAM address of a copied byte is `0xFF6034 + (flash - 0x07B2A6)` (Inferred from the `eepmov.w` operands below).

### How the code is entered

Boot clears the selector, polls the port, and branches:

| addr | hex | instruction |
| --- | --- | --- |
| `0021FA` | `6a 8c 81 3a` | `mov.b r4l,@0x813a:16` with `r4l` just set to 0 |
| `0021FE` | `fe c8` | `mov.b #0xc8,r6l` |
| `002200` | `2c 4c` | `mov.b @0x4c:8,r4l` |
| `002202` | `ec 7f` | `and.b #0x7f,r4l` |
| `002204` | `ac 7d` | `cmp.b #0x7d,r4l` |
| `002206` | `47 16` | `beq .+22 (0x221e)` |
| `002214` | `5e 05 4b f8` | `jsr @0x54bf8:24` on the fail path |
| `002218` | `5e 05 4c 44` | `jsr @0x54c44:24` |
| `002222` | `fc 01` | `mov.b #0x1,r4l` on the match path |
| `002224` | `6a 8c 81 3a` | `mov.b r4l,@0x813a:16` |
| `002234` | `5e 07 81 06` | `jsr @0x78106:24` |

Confirmed. What is wired to `FFFF4C` is Unknown.

USB ISR gate, Confirmed: `054D54` `6a 0c 81 3a` loads `FF813A`, `054D58` `58 60 01 4c` branches to `0x054EA8` when the byte is nonzero. `054EB0` `5e 07 82 7c` calls `0x07827C`, and `054EC0` `56 70` is `rte`. The zero case falls through in that ISR; that body was not re-analysed.

DSP-WRITE gate, Confirmed: `05DCFE` `6a 0c b0 c4` loads `FFB0C4`, `05DD02` `58 70 00 e4` skips when it is 0, `05DD06` `ac 05` / `05DD08` `45 14` skip the call when the byte is below 5, `05DD12` `5e 07 81 5c` calls `0x07815C`. Later, `05DD8A` `6a 18 fb a5 70 50` and `05DD98` `6a 18 fb 91 70 50` set bit 5 of `FFFBA5` and `FFFB91`, and `05DD9E` `5e 07 82 22` calls `0x078222`.

The copy that publishes the data, Confirmed, two sites with the same three operands and `eepmov.w`:

| addr | hex | instruction |
| --- | --- | --- |
| `002152` / `00251E` | `79 04 04 ae` | `mov.w #0x4ae,r4` |
| `002156` / `002522` | `7a 05 00 07 b2 a6` | `mov.l #0x7b2a6,er5` |
| `00215C` / `002528` | `7a 06 00 ff 60 34` | `mov.l #0xff6034,er6` |
| `002162` / `00252E` | `7b d4 59 8f` | `eepmov.w` |

`0x4AE` = 1198 = `0x07B754 - 0x07B2A6`. Both sites are heads in `reached_insns.tsv`. Why the copy is issued twice was not re-analysed.

### Routines

| entry | bytes | role | direct callers |
| --- | ---: | --- | --- |
| `078106` | 86 | USB init | `002234` |
| `07815C` | 106 | polled service | `05DD12` |
| `0781C6` | 24 | clear `FEE010`–`FEE20F` only | none found |
| `0781DE` | 64 | init twin, no clear | none found |
| `07821E` | 4 | `sleep`; `rts` | `076A8E`, `076BF2` |
| `078222` | 26 | SCI async init | `05DD9E` |
| `07823C` | 26 | same 26 bytes again | `076A88`, `076BEA` |
| `078256` | 10 | `SMR`/`BRR` only | none found |
| `078260` | 28 | burst to `FFEE32` | `07845E` |
| `07827C` | 184 | ISR demux | `054EB0` |
| `078334` | 72 | fill a ring, store `FFEE2C` | five `jsr` sites below |
| `07837C` | 94 | drain a ring, return count | `0768BC` and three more |
| `0783DA` | 84 | move between rings | `076A08`, `076B6A` |
| `07842E` | 20 | big-endian u16 | none found |
| `078442` | 24 | little-endian u16 | five `jsr` sites |
| `07845A` | 100 | arm IER/ISR and the 50-byte burst | `078150`, `078212` |
| `0784BE` | 74 | queue init plus `FFEE00=0x7F`, `FFEE28=0x73` | dword at `07B4BA` only |
| `078508` | 62 | queue init | `076F30` |

Every `jsr` listed there is a 4-byte code item in the K1 database (xref type 17) as well as an oracle `jsr`. The group at `0x076844`, `0x0768A2`, `0x076916`, `0x076944`, `0x0769E6`, `0x076A08`, `0x076A88`, `0x076A8E`, `0x076AD8`, `0x076D84`, `0x076DE0`, `0x076E3C`, `0x076E9C`, `0x076F30`, `0x076F54` is reached by a no-overlap walk from the handler entries `0x0767BE`, `0x0768C8`, and `0x0769AA`. The five at `0x076B1A`, `0x076B46`, `0x076B6A`, `0x076BEA`, `0x076BF2` sit in two clean streams that begin at `0x076ADE` and `0x076B20` and stop exactly at the called routine `0x076C0A`. No absolute reference to `0x076ADE` or `0x076B20` was found in the image (Not found). `0x0781C6`, `0x0781DE`, `0x078256`, and `0x07842E` have no `jsr`/`jmp` and no 32-bit pointer in the image, and IDA has no xref to them (Not found). They still decode as `rts`-terminated routines inside the 1088-byte stream, in both decoders.

`0x078222`–`0x07823B` and `0x07823C`–`0x078255` are the same 26 bytes (Confirmed).

### `0x078106` init

`078106` `7a 00 00 fe e0 10` loads `0xFEE010`. `07810C` `0f c9` is `mov.l #0x4,er1`. The loop stores 0 and adds 4 until the pointer passes `0xFEE20C` (`078114` `7a 20 00 fe e2 0c`, `07811A` `43 f2`). That is 128 dwords, `0xFEE010` through `0xFEE20F` (Confirmed).

It then packs `IER0<<24 | IER1<<16 | IER2<<8 | 0x82000` and stores the long at `FF62F8` (`07813E` `7a 40 00 08 20 00`, `078144` `01 00 6b a0 00 ff 62 f8`). `078150` `5e 07 84 5a` calls `0x07845A`. `078154` `6a 18 ee 2d 70 20` sets bit 2 of `FFEE2D`. `07815A` `54 70` returns.

`0x07845A` loads `r0` with `0x32` (`79 00 00 32`), calls `0x078260`, then writes `FFEE04 = 0xCD`, `FFEE05 = 0`, `FFEE06 = 0` (`078462` `01 7d 40 cd ee 04`). It clears bits 0 and 1 of `FFEE2D` (`e8 fc` is `and.b #0xfc,r0l`), sets bit 1 of `FFEE2F`, rebuilds the `FF62F8` snapshot, and writes `FFEE08 = 0`, `FFEE09 = 0`, `FFEE0A = 4` (`0784B0` `6a d0 ee 08`, `0784B8` `6a d4 ee 0a`).

`0x078260` writes `r0` bytes from `FF63AC` to `FFEE32` (`078268` indexes `0xff63ac:32`, `078270` `6a 80 ee 32`). The RAM image of those 50 bytes begins at flash `07B61E` `00 00 10 00 00 15 20 80 00 01 25 28 80 00 02 34 38 10 00 03` and the other 30 bytes are 0 (Confirmed; full run in `disasm.asm`). What `FFEE32` and `FFEE28` are named in a manual is Unknown. `0x0784BE` stores `0x73` to `FFEE28` (`078500` `01 7d 40 73 ee 28`) and `0x7F` to `FFEE00` (`0784FA` `01 7d 40 7f ee 00`) after the same pointer setup as `0x078508`.

`0x82000` forces bits 19 and 13 of the enable word. None of the six handler masks include those bits (Inferred from the masks below), so they do not select a handler.

### `0x07815C` service

Uses the block at `FF6288`. If the longs at `+0x44` and `+0x40` differ, `078176` `5e 07 68 a8` calls `0x0768A8`. Otherwise, if the word at `FF63F8` equals the byte addressed by the pointer at `FF6358`, and bit 4 of `FFEE00` is set (`078192` `6a 10 ee 00 73 40`), it stores the byte at `FF6360` to `FFEE2C` and clears `FF63F8`. Then, if the longs at `+0x54` and `+0x50` differ, `0781C0` `5e 07 6f c8` calls `0x076FC8` with `er0 = FF62D8`.

`0x0768A8` tests the same `FFEE00` bit 4 (`6a 10 ee 00 73 40`). When it is set, it calls `0x07837C` with `er0 = FF6354` and `er1 = FF62C8`, and stores the returned word at `FF63F8` (`0768C0` `6b a0 00 ff 63 f8`). Confirmed, naming only.

`0x076FC8` reads `FF6288+0x50` and `+0x54`, caps the count at `0x40` (`077008` `79 2a 00 40`, `07700E` `mov.w #0x40,e2`), waits while bit 7 of `FFFF8C` is clear (`07701E` `29 8c`, `077020` `bpl`), and stores the byte to `FFFF8B` (`077022` `30 8b`). Confirmed: the pump moves at most 64 ring bytes into the SCI transmit register. The rest of the pump was not re-analysed.

`0x078508` (and `0x0784BE`) set `FF6288+0` and `+4` to `0xFEE008`, `+0x50` and `+0x54` to `0xFEE010`, `+0x40` and `+0x44` to `0xFEE110`, store 1 at `FF6240`, and store 0 at `FF63F8`. The copied image already has `FF62D8` as the ring `0xFEE010` / limit `0xFEE10F` (`07B54A` `00 fe e0 10 00 fe e0 10 00 fe e0 10 00 fe e1 0f`) and `FF62C8` as `0xFEE110` / limit `0xFEE20F` (`07B53A`). `FF6330`'s image is `00 ff ee 24` (`07B5A2`). `FF62F8`'s image is `ff ff ff ff` (`07B56A`), overwritten by the snapshot.

### ISR `0x07827C`

Pushes `er2`–`er6`, rebuilds the `FF62F8` enable word the same way (including `0x82000`), packs `FFEE00<<24 | FFEE01<<16 | FFEE02<<8`, and ANDs the two (`0782D8` `01 f0 66 24`). If the byte at `FF6246` is `0xFF` it skips the walk (`0782E4` `a9 ff`). Otherwise it walks records at `FF6242`. Stride is 10 (`078310` `01 cc 50 a1` is `mulxu.b #0xa,r1`). A record whose mask AND the pending word is nonzero is called with `jsr @er2` (`078308` `5d 20`); `r1l` is the record's byte at `+4` and `er0` is the pending word. The walk stops when the byte at `+4` is `0xFF`. After the walk it reads `FFEE00`, `FFEE01`, and `FFEE02` and does not store them, then `rts/l er2-er5`.

`FF6246` is the `+4` byte of the first copied record. That byte is `00` (`07B4B4`), so the walk runs (Confirmed). Records, flash = RAM `FF6242`:

| flash | mask | +4 | handler |
| --- | --- | ---: | --- |
| `07B4B4` `80 00 00 00 00 00 00 07 84 be` | `80000000` | 0 | `0784BE` |
| `07B4BE` `05 00 00 00 01 00 00 07 69 aa` | `05000000` | 1 | `0769AA` |
| `07B4C8` `08 00 00 00 00 00 00 07 68 c8` | `08000000` | 0 | `0768C8` |
| `07B4D2` `02 00 00 00 01 00 00 07 69 aa` | `02000000` | 1 | `0769AA` |
| `07B4DC` `40 00 00 00 05 00 00 07 67 be` | `40000000` | 5 | `0767BE` |
| `07B4E6` `10 00 00 00 04 00 00 07 68 a8` | `10000000` | 4 | `0768A8` |
| `07B4F0` `00 00 00 00 ff 00 00 00 00 00` |  | `ff` | end |

The pending word's low 24 bits are 0 because `IFR2` is shifted by 8. Every live mask sits in the top byte, so only `FFEE00` bits select a handler (Inferred from those shifts and these masks). `0x0784BE` is taken only through `jsr @er2` when mask `0x80000000` hits. The other four handlers are outside this window; they were followed only to the `jsr` back into it.

### Ring and endian helpers

`0x078334` copies the count byte at `[struct+4]` from `[struct+8]` into the ring in `er1`, wrapping at the limit in `+0x0C` back to the base in `+8`, then stores the byte at `struct+0x0D` to `FFEE2C`.

`0x07837C` copies the other way, stores the byte at `struct+0x0C` to `FFEE2C`, and returns the number of bytes moved in `r0`.

`0x0783DA` returns 1 immediately when the byte at `[FF6330]` is nonzero (`0783E2` loads that pointer, `0783EA` tests the byte). Otherwise it copies from one ring to the other while neither side has caught up, and returns 0.

`0x07842E` returns `(mem[0]<<8) | mem[1]`. `0x078442` returns `(mem[1]<<8) | mem[0]` (`07844C` reads `er0` via `@(0xffff:16,er2)` after adding 1, `078452` reads the next byte into `r0h`). USB descriptor multi-byte fields are little-endian, so `0x078442` matches that layout (Inferred use; the instruction itself is Confirmed). `0x07821E` is `01 80` `sleep` and `54 70` `rts`.

### SCI-C bytes

`0x078222` stores 0 to `FFFF8A`, `0x08` to `FFFF88`, `0x0C` to `FFFF89`, spins `r0l` from 0 while it is below `0xFF`, then stores `0x70` to `FFFF8A`. Confirmed. Inferred from the H8SX SCI bit map: `SMR 0x08` is asynchronous 8-bit, no parity, 2 stop bits, φ clock; `SCR 0x70` is receive-interrupt enable plus transmitter and receiver enable; with φ = 16 MHz and the φ/1 clock, `BRR 0x0C` is 16000000 / (32 × 13) ≈ 38462 baud. The baud number was not measured in this window. `0x078256` writes only the `0x08` and the `0x0C`.

### Descriptors in the copied image

Field names below assume the USB descriptor layout. The bytes are Confirmed.

Device descriptor at `07B680` (RAM `FF640E`), 18 bytes `12 01 10 01 02 00 00 08 aa 26 20 00 00 01 00 00 03 01`: length 18, type 1, bcdUSB `0x0110`, class 2, subclass 0, protocol 0, EP0 max packet 8, VID `0x26AA`, PID `0x0020`, bcdDevice `0x0100`, string indexes 0, 0, 3, one configuration.

The copied pointer table addresses that RAM, not the flash address (no 32-bit pointer to `0x07B680` was found). `07B5F0` `00 ff 64 0e` (RAM `FF637E`), `07B5F4` `00 43`, `07B5F6` `00 ff 64 9f` (config at RAM `FF649F`).

Config at `07B711`, 67 bytes. `wTotalLength` is the little-endian field in `09 02 43 00 02 01 00 c0 10`, value `0x0043`. The record lengths 9+9+5+4+5+5+7+9+7+7 = 67, and `07B74D + 7 = 07B754`, so the config ends on the last image byte.

| addr | hex | layout |
| --- | --- | --- |
| `07B711` | `09 02 43 00 02 01 00 c0 10` | config, 2 interfaces, value 1, self-powered, 32 mA |
| `07B71A` | `09 04 00 00 01 02 02 01 00` | interface 0, 1 endpoint, class 02 / 02 / 01 |
| `07B723` | `05 24 00 10 01` | CS_INTERFACE header, bcdCDC `0x0110` |
| `07B728` | `04 24 02 06` | ACM, capabilities `0x06` |
| `07B72C` | `05 24 06 00 01` | union, master 0, subordinate 1 |
| `07B731` | `05 24 01 03 01` | call management |
| `07B736` | `07 05 83 03 08 00 10` | endpoint `0x83`, interrupt IN, 8 bytes, interval 16 |
| `07B73D` | `09 04 01 00 02 0a 00 00 00` | interface 1, 2 endpoints, class `0x0A` |
| `07B746` | `07 05 01 02 40 00 00` | endpoint `0x01`, bulk OUT, 64 bytes |
| `07B74D` | `07 05 82 02 40 00 00` | endpoint `0x82`, bulk IN, 64 bytes |

No instruction inside the window consumes these pointers (no absolute in the 336 instructions). They are data for code outside this window.

String descriptors, ahead of the copy, pointed at from inside it:

| addr | hex | |
| --- | --- | --- |
| `07B272` | `04 03 09 04` | length 4, type 3, LANGID `0x0409` |
| `07B276` | `10 03 52 00 65 00 6e 00 65 00 73 00 61 00 73 00` | type 3, UTF-16LE "Renesas" |
| `07B286` | `1a 03 30 00 30 00 30 00 30 00 30 00 30 00 30 00 30 00 30 00 30 00 30 00 30 00` | type 3, UTF-16LE "000000000000" |

`07B5FA` `04 00 00 07 b2 72`, `07B600` `10 00 00 07 b2 76`, `07B60C` `1a 00 00 07 b2 86` are little-endian lengths plus those pointers (Confirmed). `07B270` and `07B271` are `00 00`. Outside, `077F52` loads `07B270` and `077F5A` loads `07B271`; `077E3A` `7a 01 00 07 b2 60` takes the address of 16 zero bytes at `07B260`.

`07B697` `00 79` is a big-endian length 121 that includes those two bytes. The next 119 bytes (`07B699`–`07B70F`) are ASCII. The first 32 are `4d 41 4e 55 46 41 43 54 55 52 45 52 3a 41 43 4d 45 20 4d 61 6e 75 66 61 63 74 75 72 69 6e 67 3b` ("MANUFACTURER:ACME Manufacturing;"). `07B710` is `18`, then the config. No 32-bit pointer to `07B697`, `07B698`, or the RAM image of that string (`FF6426`) was found (Not found).

### Lookup tables, not samples

`0x0762FE` `78 01 6b 20 00 07 85 46` loads a word from `0x078546` indexed by the byte at `FFBC76`. `0762EA` `a0 2c` compares that index with `0x2C` (45 entries, 0..0x2C). `076306` `11 10` is `shlr.w r0`, `076308` `59 06` is `bra r0.w`. All 45 words, added to `0x07630A`, land on an instruction in `reached_insns.tsv` (45/45). The shifted word lands on one for 18/45. Inferred: `bra r0.w` scales by 2 and the shift cancels that, so each stored word is a byte displacement from `0x07630A`. The case bodies are outside this window. One result path stores a word to `FFBC74` (`0767B6` `6b a1 00 ff bc 74`).

`0x078600`–`0x07B25F` is 5680 big-endian words, minimum `0x2121`, maximum `0xFFFF`, 3201 distinct values. `078600` begins `30 21 30 22 30 23 30 24 30 25 30 26 30 27 30 28`. `07B120` begins `21 21 21 22 21 23 21 24 21 25 21 26 21 27 21 28`. `07B250` ends `26 48 26 4b 26 4c 26 50 26 56 26 58 ff ff ff ff`. The case at the switch computes an index and loads one of these words. Inferred: character-code lookup. Which standard the numbers belong to is Unknown; the image does not name one.

`0x07615E` reads `FFBC70`. For high nibbles `0xA` through `0xF` it indexes the 16-byte maps at `0785A0`, `0785B0`, `0785C0`, `0785D0`, `0785E0`, `0785F0` (`0761B8` through `076186`) and stores the byte to `FFBC71` (`0761C0`).

`0x0761D4` reads the word at `FFBC72`. `0761DA` `79 2b 24 21` compares it with `0x2421`, `0761E2` `79 2b 25 76` with `0x2576`. `0761FA` `78 88 7a c6 00 ff 60 34` takes an address in the copied image at `FF6034`. That image, `07B2A6`–`07B4B1`, is 524 bytes (262 words). It begins `24 21 24 22 24 22 24 21 24 23 24 24 24 24 24 23` and ends `25 6f 25 6e 25 74 25 26 25 75 25 2c 25 76 25 32`, so the last key is `0x2576`, the same bound. `0761CE` loads `0x82` (130). 524/4 = 131, so indexes 0..130 fit if each entry is a 4-byte key/value pair (Inferred). `07B4B2` is `01 00`, the `FF6240` initializer, and the handler table starts at `07B4B4`.

## USB relevance

USB role: yes, for this window. The 1088 code bytes program `FFEE04`–`FFEE06`, `FFEE08`–`FFEE0A`, `FFEE2C`, `FFEE2D`, `FFEE2F`, and `FFEE32`, and the ISR walks USB flag bytes `FFEE00`–`FFEE02` against the handler table. The copied image holds a CDC-ACM device (class `0x02`, VID `0x26AA`, PID `0x0020`, bcdUSB `0x0110`) and a 67-byte configuration whose endpoints are interrupt IN 8 bytes (`0x83`), bulk OUT 64 (`0x01`), and bulk IN 64 (`0x82`). It runs only through the gates in Findings. The strap-fail boot path does not call `0x078106` and leaves `FF813A` at 0, so the ISR does not call `0x07827C`.

SDR / IQ / sample path: Not found in this window. The bulk packets are 64 bytes and the interrupt packet is 8. The large arrays are 16-bit words from `0x2121` upward with `0xFFFF` fill, indexed by a one-byte selector and a `0x28 * byte + byte` formula, and the consumer stores one word to `FFBC74`. That is a lookup, not a sample stream.

DSP reach: SCI-C bytes only. `0x078222` and its twin write `FFFF88`/`FFFF89`/`FFFF8A`, and `0x07815C` calls `0x076FC8`, which stores ring bytes to `FFFF8B` with a cap of 64. No IQ, audio, or wide-DMA buffer is referenced by the 336 instructions.

## Open

- `0x0781C6`, `0x0781DE`, `0x078256`, and `0x07842E` decode and return, and nothing in the image points at them (Not found).
- `0x076ADE` and `0x076B20` have no absolute reference. The `jsr` instructions inside them are real K1 code heads. What reaches those two prologues is Unknown.
- Manual names for `FFEE28` and `FFEE32` are Unknown. The baud figure and the SCI bit names are Inferred.
- The character-code standard is Unknown.
- `0x0767BE`, `0x0768C8`, and `0x0769AA` were followed only until their calls back into this window.
- What drives `FFFF4C` to `0x7D` is Unknown.
- The 868 unset code bytes were not written into the proven mask.

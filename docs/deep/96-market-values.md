# 96 — How FF800F, FF8010 and FF8011 get their values

Owner-side static analysis of the owner's FT3DR/FT3DE ver 1.02 MAIN image
`decrypted\FT3D_MAIN_ver102_EXP.bin` (1,048,576 bytes, H8SX, big-endian, file offset = address).
sha256 `8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce`, confirmed.
Nothing was written to a radio, and the image was not modified. The closed window
`0x078106`–`0x07B753` was not disassembled. SUB was not opened.

Tables: `ida\out\market-values\writers.tsv`, `ida\out\market-values\citations.tsv`.
Every Confirmed run quoted below is a row in one of those files. Hex is lowercase and space-separated.

## Verdict

`FF800F`, `FF8010` and `FF8011` are three bytes of one 8-byte EEPROM block: offsets `0x20`–`0x27` load and store `FF800E`–`FF8015`, so the market bytes are EEPROM `0x21`, `0x22` and `0x23`. The only immediate that points a transfer at `FF800E` is `0x3955E`. Boot loads the block with `sub_39534`. When the word check at ROM `0xF010` (`96 69`) fails, `sub_DDFE` stores destination 2, companion 1, and a sample of port `0xFFFF4E` bit 2, and that same boot writes the block back. The held-key editor (power-on table `0x10216` index 7, port long `0x73`, screen byte `0xE8`) commits `FF800F` and `FF8010` through `sub_39544` after the ROM constant at `0x23442` matches; `FF8011 == 0` limits that destination to 2 and 3. A DATA-jack command slot writes and saves `FF800F`/`FF8010` as well, and two other slots force `FF8010` and `FF8011` to 1 in RAM only. A clone or BACKUP image starts at EEPROM `0x140` and does not carry `0x21`–`0x23`; its converters read `FF800F` and rewrite other record fields.

## Method

Private IDA database `L96_MARKET`, copied from `ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64` and opened only through `ida\run_job.py`. The first launch left `--env` unquoted, so argparse rejected the path and created no database. The quoted rerun exited `idat_exit 0`. The job `ida\jobs\l96_market.py` dumped the named functions and scanned 124031 code heads in `0..0x80000`, skipping `0x078106`–`0x07B754`. `ida\jobs\l96_bytes.py` and `ida\jobs\l96_cite.py` re-read the same bytes from the image. `l96_cite.py` also searched `0..0x80000` for `mov.b` stores to `0x800E`–`0x8011`, for `mov.l #0xFF800E, er1`, and for `jsr`/`jmp` to `sub_39534`, `sub_39544` and `sub_DDFE`.

Evidence words: Confirmed, Inferred, Not found (with scope), Unknown.

## Findings

### Writers

Confirmed direct stores, and the one block pointer. The encoding search returned these 13 hits and no others. None lie in `0x078106`–`0x07B753`. The IDA operand scan found the same stores and no further `op1` write of `FF800F`, `FF8010` or `FF8011`.

| Address | Bytes | Destination | What is stored | Saved? |
| --- | --- | --- | --- | --- |
| `0x00DE0A` | `6a 8c 80 0f` | `FF800F` | `r4l` after `fc 02` (value 2) | by the caller at `0x00DCE2` |
| `0x00DE10` | `6a 8c 80 10` | `FF8010` | `r4l` after `fc 01` (value 1) | by the caller at `0x00DCE2` |
| `0x00DE1A` | `6a 8d 80 11` | `FF8011` | `r5l` from `sub_DDE4` | by the caller at `0x00DCE2` |
| `0x00DF46` | `6a 8d 80 11` | `FF8011` | `r5l` if the two samples agreed and differ from the current byte | by `0x00DCE2` |
| `0x0236E2` | `6a 8c 80 0f` | `FF800F` | `r4l` = `FFAD95` | `jsr sub_39544` at `0x0236EA` |
| `0x0236E6` | `6a 8b 80 10` | `FF8010` | `r3l` | `jsr sub_39544` at `0x0236EA` |
| `0x073B12` | `6a 8c 80 10` | `FF8010` | `r4l` after `fc 01` (value 1) | RAM only |
| `0x073B16` | `6a 8c 80 11` | `FF8011` | same `r4l` (value 1) | RAM only |
| `0x073BA0` | `6a 8c 80 10` | `FF8010` | `r4l` after `fc 01` (value 1) | RAM only |
| `0x073BA4` | `6a 8c 80 11` | `FF8011` | same `r4l` (value 1) | RAM only |
| `0x0740F6` | `6a 81 80 0f` | `FF800F` | `r1h` | `jsr sub_39544` at `0x0740FE` |
| `0x0740FA` | `6a 8b 80 10` | `FF8010` | `r3l` | `jsr sub_39544` at `0x0740FE` |
| `0x03AC52` | `68 9c` | `FF800E` upward | each byte read from EEPROM, then `0b 01` (`adds #1, er1`) | the load itself |
| `0x03955E` | `7a 01 00 ff 80 0e` | pointer | `mov.l #0xFF800E, er1` | arms the load and the save |

`0x073B82` is `01 00 6b 04 80 0e`, `mov.l @FF800E, er4`. It copies `FF800E`–`FF8011` into `FF96FC`. It does not store a market. Doc 59's "clone-header builder" is this copy.

Not found, scope = those two searches over code bytes `0..0x80000` outside the closed window: any other direct store, and any other `jsr`/`jmp` to `sub_39534` or `sub_39544`. The three loads are `0x00DC8C`, `0x00DCD6` and `0x073B6C` (`5e 03 95 34`). The three saves are `0x00DCE2`, `0x0236EA` and `0x0740FE` (`5e 03 95 44`). `sub_39554` itself is reached only by the `bsr` inside `sub_39534` and `sub_39544`.

### EEPROM block

Confirmed. `sub_39554` is `79 06 00 08 7a 00 00 00 00 20 7a 01 00 ff 80 0e 54 70`: `r6 = 8`, `er0 = 0x20`, `er1 = 0xFF800E`. `sub_39534` (`01 30 6d f0 55 1a 5e 03 ab 80`) calls that helper and then `sub_3AB80`. `sub_39544` (`55 0a 5e 03 ad 20`) calls the same helper and then `sub_3AD20`.

`sub_3B14C` at `0x03B180` sends device `fd a0`, then `0c 0d` (`r0h`) and `0c 8d` (`r0l`). `sub_3AB80` stores each received byte with `68 9c` at `0x03AC52`, adds 1 to `er1`, and counts on `r6` (`1b 56` at `0x03AC5C`). `sub_3AD20` reads the source with `6c 1d` (`mov.b @er1+, r5l`) at `0x03AD5C`. The eight bytes therefore pair as EEPROM `0x20`+n ↔ `FF800E`+n. The market bytes are EEPROM `0x21` = `FF800F`, `0x22` = `FF8010`, `0x23` = `FF8011`.

Not found, scope = every `mov.l #imm, erN` in `0..0x80000` whose immediate is `0x10`, `0x20`, `0x21`, `0x22`, `0x23` or `0x40`: `mov.l #0x20, er0` occurs only at `0x039558`, and `mov.l #0x21`, `#0x22` or `#0x23` into `er0` occurs nowhere. The other hits are a second marker helper (`0x03D77C`, `mov.l #0x10, er0` with destination `FF800A`), the `0x40`/`0x100` image helper at `0x03958A`, and lengths or RAM strides in other registers (`er2`/`er3`/`er4`). Computed values of `er0` were not executed symbolically.

`FF800E` and `FF8012`–`FF8015` travel in the same block. Their meaning was not traced.

### Boot value

Confirmed. The marker dwords at `0x00DD0E` are `54 41 49 53 45 53 54 55 4d 41 52 55 43 48 41 4e 30 30 30 30` (`TAIS`, `ESTU`, `MARU`, `CHAN`, `0000`). `sub_DD5C` and `sub_DDA0` compare a loaded dword with `TAIS` at `0xDD0E` and `MARU` at `0xDD16`. `ESTU` and `CHAN` are the bytes between those two compares; these two functions do not compare against them.

On `TAIS`, `0x00DC8C` loads the 8-byte block. It then calls `sub_DDE4` with count `fb c8`. If the samples agree and `FF8011` differs, `0x00DCA8` is `5a 00 db d8`. That entry clears `FF8004` (`fc 00 6a 8c 80 04`), copies `MARU` through `sub_39512` into EEPROM `0x10` (`sub_39522` is `79 06 00 04 7a 00 00 00 00 10 7a 01 00 ff 80 06`), and falls into `0xDC12`, which sets `FF8003 = 2` (`fc 02 6a 8c 80 03`). The re-entry therefore takes the path below, and the new strap sample is stored by `sub_DEFA`, not by the first call. If `FF8004 == 3`, `0x00DC94` (`ac 03 47 14`) skips that compare. The static store of 3 is `sub_DBC4`, which also sets `FF8003 = 2` before the compare, so that entry leaves at `0x00DC8A`.

Any other marker result, and the case `FF8003 == 2`, reaches `0x00DCD6`: load the block, `jsr sub_DEFA`, then `0x00DCE2` `jsr sub_39544` and `0x00DCE6` `5e 03 95 76` (`jsr sub_39576`). `sub_39576` is the save twin of the `0x40`/`0x100` helper (`01 30 6d f0 55 0a 5e 03 ad 20`).

`sub_DEFA` at `0x00DEFA` is `a9 02 47 34`. When `r1l == 2` it skips the word check. Otherwise it loops `f9 80` times: zero `FF8094` and `FF8114`, `jsr sub_39566` (EEPROM `0x40`, length `0x100`, destination `FF8016`), and require both words to equal the word at `0x00F010`. The compare is `6b 0b 80 94 6b 03 81 14 6b 2c 00 00 f0 10 0d c4 1f b4`. ROM `0xF010` is `96 69`, so both words must be `0x9669`. Failure calls `sub_DDFE` (`5e 00 dd fe` at `0x00DF2C`). Success, and the `r1l == 2` path, fall into the strap update at `0x00DF32`: count `fb c8`, and `0x00DF46` stores `r5l` only when `sub_DDE4` returned with the samples equal and the value differs.

`sub_DDFE` is the default write. `0x00DE08` is `fc 02 6a 8c 80 0f`, `0x00DE0E` is `fc 01 6a 8c 80 10`, and `0x00DE14` is `fb 0a 5e 00 dd e4 6a 8d 80 11` (count 10, store unconditional). Its only caller is `0x00DF2C`. A `MARU` result sets `r1l = 2` and does not take this write; the EEPROM destination already in the block is kept, then saved again. The failing `0x9669` check is what stores 2.

`sub_DDE4` is `fd 00 7e 4e 77 20 67 0d f5 00 7e 4e 77 20 67 05 1c d5 46 04 1a 0b 46 f2 54 70`. `7e 4e 77 20` is `bld #2, @0x4E:8` (port `0xFFFF4E`). It repeats until `r5l == r5h` or `r3l` expires. Callers: `0x00DC9A` (sample only), `0x00DE16` (store always), `0x00DF38` (store if changed).

`sub_DE20`, called at the start of `sub_DDFE`, copies ROM to `FF8016`, `FF8096` and `FF80C6`. It does not address `FF800E`–`FF8011`. The first copy's last word is ROM `0xEF92+0x7E` = `0xF010`, written to `FF8094` and again to `FF8114`, so the image `sub_DDFE` builds carries `96 69` in both check words. `sub_39576` then saves that image.

### Held-key path and what FF8011 allows

Confirmed. `sub_100E4` does `7a 02 00 0f ff ff`, then `2c 4c ec 7f ac 7f`. The port byte is `@0x4C:8` (`0xFFFF4C`) masked with `0x7F`. If that value is `0x7F`, `er2` stays `0x000FFFFF` and the matcher rejects it (`7a 22 00 0f ff ff 47 68` at `0x01017C`). Otherwise `er2` becomes the masked byte (`7a 02 00 00 00 00 0c ca`). `0x73` is not among the seven values compared later in `sub_100E4` (`0x7E`, `0x7D`, `0x7B`, `0x77`, `0x6F`, `0x5F`, `0x3F`), so the matcher sees the raw long `0x73`. Which front-panel key produces that port value is Unknown.

`sub_10168` loads `er6` from `0x010216` and sets the count to 11 (`7a 06 00 01 02 16 f3 0b`). The eleven longs are `00 00 00 0f 00 00 00 1f 00 00 00 5f 00 00 00 7b 00 00 00 77 00 00 00 6f 00 00 00 7e 00 00 00 73 00 00 00 7d 00 00 00 37 00 00 00 67`. Index 7, at `0x010232`, is `00 00 00 73`. The handler longs at `0x010242` put `00 01 02 6e` at `0x01025E`. `0x01026E` is `55 06 40 02` (`bsr sub_10276`, then `bra` to the `rts`).

Index 7 is reached when `FF89C2` bit 0 is clear and `FF813A == 0` (`6a 10 89 c2 73 00` and `6a 0c 81 3a` at `0x01018E`). When `FF89C2` bit 0 is set, the matcher tests the first long and the long at `0x01022E` (`00 00 00 7e`) and, on the second match, stores index 6 and calls no handler. When `FF813A != 0` it calls `sub_103C0` and skips the table.

`sub_10276` calls `sub_23410` and leaves if Z is clear (`5e 02 34 10 46 26`). It also leaves if `FF8EA7` bit 7 is set (`6a 10 8e a7 73 70 46 1e`). Otherwise it copies `FF800F` to `FFAD95` and `FF8010` to `FFAD96`, then stores screen byte `0xE8` (`fc e8 6e 8c 00 01`).

`sub_23410` requires `FF8955 == 2` (`6a 0c 89 55 ac 02`), a non-negative byte at `FF8958` (`4b 20`), dword `FF8958` equal to the dword at `0x023442`, and word `FF895C` equal to the word at `0x023446`. The six bytes at `0x023442` are `41 48 30 37 32 4d`. Failure stores `fc 01` and returns with Z clear.

`FF8011` chooses the editor's destination set. `0x02365C` reads it (`6a 0c 80 11`).

- Value 0, and `FFAD95` already 2 or 3: call `sub_3F62E` with the table at `0x02368C`.
- Value 0, and `FFAD95` any other byte: `jsr sub_3FFA0` at `0x023692` (`5e 03 ff a0`).
- Any other value: call `sub_3F62E` with the table at `0x023686`.

The tables are `00 07 00 ff ad 95` and `02 03 00 ff ad 95` (min, max, pointer `FFAD95`). `sub_3F62E` loads that word (`69 64`) and the pointer (`01 00 6f 65 00 02`). One direction increments and wraps max to min; the other decrements and wraps min to max, selected by `FFA9EE` bit 0. Destination 0..7, or 2↔3, is what those two tables produce.

`0x023698` does not cycle the destination. `FF8011 == 0` branches to the reject (`47 f4` → `0x023692`). Otherwise destinations 6 and 7 reject, and any other destination toggles `FFAD96` bit 0 (`ec 01 71 0c 6a 8c ad 96`).

The commit `0x0236B8` is reached from the pointer `00 02 36 b8` at `0x02A692`. The cycler is reached from `00 02 36 5c` at `0x01462C`.

- `FF8011 == 0`: store only when `FFAD95` is 2 or 3. `FF8010` receives `FFAD96`.
- `FF8011 != 0`: if the destination is 6 or 7, `r3l` is forced 0 (`fb 00`); otherwise `r3l` is `FFAD96`.
- Both accepted cases execute `6a 8c 80 0f 6a 8b 80 10 5e 03 95 44 5a 00 db d8`.

### DATA-jack command slots

Confirmed. `sub_73A54` subtracts `0x30` from the byte in `r2l` and stores the index at `FF97FC` (`fd 30 18 dc 6a 8c 97 fc` at `0x073A6C`). Index 0 skips the following test. Every other index requires `FF8004 >= 2` (`6a 0c 80 04 ac 02 45 1a` at `0x073A62`). `sub_739FA` then takes the word at `FF96FA` into `r1` and calls `@(0x74472 + 4·index)` (`6b 01 96 fa` … `78 b0 6b 26 00 07 44 72 5d 60`).

| Slot | Table address | Bytes | Effect on the three bytes |
| --- | --- | --- | --- |
| 0 | `0x074472` | `00 07 3a fe` | `sub_73AFE`. Sets `FF8004 = 2`. Stores `FF8010 = 1` and `FF8011 = 1`. Does not store `FF800F` and does not call `sub_39544`. Also called directly at `0x07353A` when `sub_7351E` sees `FF8004 == 3`. |
| 2 | `0x07447A` | `00 07 3b 6c` | `sub_73B6C`. `jsr sub_39534` reloads EEPROM `0x21`–`0x23`. Copies the four RAM bytes out at `0x073B82`. Then stores `FF8010 = 1` and `FF8011 = 1` with no save. |
| `0x1E` | `0x0744EA` | `00 07 40 d8` | `sub_740D8` is `55 08` into `sub_740E2`. |

`sub_740E2` accepts the store when `r1h < 8` and `r1l < 2` (`a1 08 44 20 a9 02 44 1c`). It forces the companion to 0 when `r1h` is 6 or 7, and otherwise stores `r1l`. Then `6a 81 80 0f 6a 8b 80 10 5e 03 95 44 5a 00 db c4`. `sub_DBC4` sets `FF8004 = 3` (`fc 03 6a 8c 80 04`) and enters boot at `0xDC12`, which sets `FF8003 = 2`. That boot reloads the block just saved, runs `sub_DEFA` with `r1l == 2` (so the default-2 write is skipped), and may refresh `FF8011` from the strap before saving again. Later, `0x002B36` calls `sub_7351E`. Because `FF8004` is still 3, `0x07353A` calls `sub_73AFE`, which overwrites RAM `FF8010` and `FF8011` with 1 and sets `FF8004 = 2`, without `sub_39544`. Cold reset stores 0 to `FF8004` at `0x0020A0` (`fc 00 6a 8c 80 04`), so the next `sub_7351E` returns on `FF8004 == 0` and the EEPROM load remains.

The editor's restart is `sub_DBD8`, which stores 0 to `FF8004`, so that restart does not take the `sub_73AFE` overwrite.

### Clone and BACKUP

Confirmed. Cable-clone receive checks the buffer with `sub_737C8` before the EEPROM stream (`5e 07 37 c8` at `0x0735A6`). The check compares five bytes at `0x0738A2` (`41 48 37 32 4d`, the following byte is `00`) with `FF96F8`, the byte at `FF96FD` with `sub_734BE` (`fc 02 54 70`, constant 2), and the dword at `FF96FE` with `sub_7357A`. `sub_7357A` is `6a 0c 80 0f f4 01 f4 00 0d 4c 6a 04 80 10 6a 0c 80 11 54 70`: the high half of `r4` is cleared, and the returned dword is `00`, `FF800F`, `FF8010`, `FF8011`. A mismatch returns. The stream that follows starts at `7a 00 00 00 01 40` (`0x0735D4`) and later `7a 00 00 01 01 00` (`0x073610`). Both starts are above `0x27`, so the stream does not include EEPROM `0x21`–`0x23`.

The two BACKUP apply sites call the converters and then jump to `0xDC4E`:

- `0x074AD4`: `5e 07 50 c2 5e 07 51 60 5e 07 54 bc 5e 07 5e b4 5e 07 5e b6 5e 03 95 04 5a 00 dc 4e`
- `0x0750AC`: `55 14 5e 07 51 60 5e 07 5e b4 5e 07 5e b6 5e 03 95 04 5a 00 dc 4e`

Those calls are `sub_750C2`, `sub_75160`, `sub_754BC`, `0x75EB4`, `sub_75EB6` and `sub_39504`. They do not include `sub_39534`, `sub_39544`, `sub_DDFE` or `sub_740E2`. `sub_39504` falls into `sub_39512`, the EEPROM `0x10` marker save armed by `sub_39522`.

`sub_75160` and `sub_75554` read `FF800F` and branch on 1, 2, 3, 4, 5 and 7 (`6a 0c 80 0f f4 01 ac 01` … `ac 07`). The head at `0x075554` is the whole of that switch; case 7 then writes the record in `er0`, including `fc 06 6e 8c 00 04` at `0x075592` (value 6 at record `+4`). The visible bodies call `sub_3A632` / `sub_3F5EE` and store fields such as `FFBCAC` and `@(n, er0)`. `sub_75554` has no `jsr`/`jmp` abs24 caller; both `bsr` sites are inside `sub_754BC` (`55 3a` at `0x075518`, `55 0c` at `0x075546`). The operand scan shows the `FF800F` references here as reads.

Not found, scope = the direct-store search, the `jsr`/`jmp` search, the clone stream immediates, and these apply hooks: a clone or BACKUP load that writes `FF800F`, `FF8010` or `FF8011`, or that writes EEPROM `0x21`–`0x23`. The converters use the current `FF800F` to choose how other restored fields are rewritten. `sub_7357A` is the ID compare, not a market store. The separate command slot at `0x0744EA` can change `FF800F`/`FF8010` and save the block; that path is the command table, not the clone image.

## USB relevance

The writers are the I2C block (device byte `0xA0` at `0x03B180`, EEPROM `0x20`–`0x27`), the port sample of `0xFFFF4E` bit 2, the power-on compare against `0xFFFF4C`, and the DATA-jack command table at `0x074472`. No store in this set addresses a USB endpoint register. The byte search found no `mov.b` store of `FF800E`–`FF8011` and no `mov.l #0xFF800E` inside `0x078106`–`0x07B753`. That window was not disassembled.

## Open

- Unknown: which physical key produces port sample `0x73`. `sub_100E4` does not map that value onto one of its seven ids.
- Not traced: the meaning of `FF800E` / EEPROM `0x20` and of `FF8012`–`FF8015` / EEPROM `0x24`–`0x27`, which move with the 8-byte block.
- SUB screen byte `0xE8` was not followed. The SUB image was not opened.
- Not found inside `0x078106`–`0x07B753`, scope = the store and pointer encodings above. The window was not disassembled.
- Not executed: an `er0` computed to `0x21` without a `mov.l #0x21, er0`. No such immediate exists in `0..0x80000`.

## Reconciliation with doc 50

| Doc 50 claim | Verdict | Bytes |
| --- | --- | --- |
| `FF800F` is persisted at EEPROM `0x21` | Agrees. The same 8-byte transfer also pairs `0x22` with `FF8010` and `0x23` with `FF8011`. | `7a 00 00 00 00 20` at `0x039558`, `7a 01 00 ff 80 0e` at `0x03955E`, `68 9c 0b 01` at `0x03AC52` |
| A virgin or invalid image defaults `FF800F` to 2 at `0x00DE0A` | Agrees on the value and the store. The immediate sits at `0x00DE08`; the store is the next instruction. The write runs when the `0x9669` check fails. A `MARU` result (`r1l == 2`) skips that check and keeps the destination already in the block. | `fc 02 6a 8c 80 0f` at `0x00DE08`; `96 69` at `0x00F010`; `a9 02 47 34` at `0x00DEFA` |
| `FF8010` default | Agrees. The default store is 1. | `fc 01 6a 8c 80 10` at `0x00DE0E` |
| `sub_DDE4` samples `0xFFFF4E` bit 2 into `FF8011` | Agrees. Stores are `0x00DE1A` (always, count 10) and `0x00DF46` (only if the samples agreed and the value changed). The call at `0x00DC9A` samples and does not store; a mismatch there restarts through `0xDBD8`, and the following `sub_DEFA` performs the store. `0x00DC96` skips the `0xDC9A` call when `FF8004 == 3`. | `7e 4e 77 20` at `0x00DDE6`; `6a 8d 80 11` at `0x00DE1A` and `0x00DF46` |
| `sub_734BE` returns constant 2 | Agrees. | `fc 02 54 70` at `0x0734BE` |
| Destinations are 2↔3 when the strap is 0 | Agrees for the destination helper `0x02365C` and the commit `0x0236B8`. The table is min 2, max 3, and the commit accepts only 2 or 3. A current destination outside that pair is rejected. Disagrees that `0x023698` cycles the same way: `FF8011 == 0` rejects, and `FF8011 != 0` toggles `FFAD96` bit 0 unless the destination is 6 or 7, which also rejects. | `02 03 00 ff ad 95` at `0x02368C`; `00 07 00 ff ad 95` at `0x023686`; `47 f4` at `0x02369C`; `ec 01 71 0c` at `0x0236AE` |
| `0x0740D8` has no static xref | Disagrees. The long `00 07 40 d8` at `0x0744EA` is slot `0x1E` of the table at `0x074472`, called by `jsr @er6` at `0x073A3C`. `0x0740D8` is `55 08` into `sub_740E2`. | `00 07 40 d8` at `0x0744EA`; `78 b0 6b 26 00 07 44 72 5d 60` at `0x073A34` |

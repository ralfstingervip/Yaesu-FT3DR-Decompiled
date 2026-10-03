# 97 — TX frequency-range check `sub_34E42`

> Lane L97. Private DB `L97_TXFREQ`, seeded from `ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64`
> and reopened in place. Read-only IDAPython `ida\jobs\l97_txfreq.py` plus image cross-check
> `ida\jobs\l97_scan.py` and `ida\jobs\l97_tables.py`. Image
> `decrypted\FT3D_MAIN_ver102_EXP.bin`, 1,048,576 bytes, H8SX big-endian, base 0, file offset =
> address. sha256 `8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce` (match True).
> SUB strings were read as bytes from `decrypted\FT3D_SUB_ver102_ALL.bin` (sha256 `b93570b3…`).
> No image was modified. Nothing was connected to or written to a radio. The closed window
> `0x078106`–`0x07B753` was not entered. Doc 93 located this check and stopped; the call below is
> re-cited from this image.
>
> Tables in `ida\out\tx-freq-range\`: `ida-disasm.txt`, `scan.txt`, `tables.txt`, `windows.tsv`,
> `rewrite-maps.tsv`, `citations.tsv`.

## Verdict

`sub_34E42` (`0x034E42`) allows the candidate when the 4-byte packed-BCD long at `FFAAAE` (the integer in those digits is in units of 10 Hz, so `14 40 00 00` is 144.00000 MHz) lies inside either inclusive RAM window `FF92CE` or `FF92D6`, and blocks when it is outside both. `sub_3F4A2` is the only writer of those windows: `FF800F==6` or `FF8011==0` copies destination `FF800F`'s `F0A2` pairs at `+0x0C` and `+0x1C` (144.00000–146.00000 and 430.00000–440.00000 MHz for dest 0; 120.00000–221.99500 and 300.00000–579.99500 MHz for dest 6); every other market byte copies the fixed pair at `F672`, 140.00000–174.00000 and 420.00000–470.00000 MHz. `FF8010` is not an operand of the check or the filler. The long under test is the one the wrapper just built: the VFO wrapper copies `er0+0x1A` and, while `er0+0x46` bit 0 is clear, applies `er0+0x15` as keep, packed-BCD subtract, packed-BCD add, or replace using `er0+0x1E`; the staged wrapper does the same from `FFB392`, `FFB396`, and `FFB39C` and does not call `sub_325FA`. On the VFO path `sub_325FA` returns without storing, because `sub_32650` returns `r4l=0` and the `beq` at `0x032600` is taken. Allow returns `r4l=0` with Z set and sets `er0+0x86` bit 4; block returns `r4l=1` with Z clear and clears that bit. At the TX request, `0x022504` `jsr sub_34DC2` / `0x022508` `bne` takes the block arm `0x02254E`, which stores `FF94C0=2` and `FFAAE0=0x1D` and does not enter the setup that stores `FF94C0=1` and `FFAAE0=0xFF`.

## Method

- Hash and raw dumps: `l97_scan.py`, `l97_tables.py`. Every Confirmed run below is a row in `citations.tsv` and matches the image.
- IDA, through `ida\run_job.py` only, database `L97_TXFREQ`. First pass `--copy-from` the K1 final4 seed; later passes `--reopen`. Script `l97_txfreq.py` (window skip kept). Disassembly is `ida-disasm.txt`.
- `mov.b #imm` updates Z from the value written. The allow and block tails are `fc 00` / `fc 01` (`mov.b #0/#1, r4l`) immediately before `rts`, and every `bne` after `sub_34DC2` treats Z clear as block. The same rule makes `f4 01` (`mov.b #1, r4h`) clear Z. `rts` / `bsr` / `jsr` do not modify CCR, so `sub_34DC2` and `sub_34E82` return the check's Z.
- `cmp.l ERs, ERd` is `ERd − ERs`; C is set on an unsigned borrow. `sub_3F5EE` returns C clear exactly when `lo ≤ value ≤ hi`.
- Proven-byte check against `ida\out\main-final4\final4_proven_mask.bin` (length 1,048,576, 368,624 bytes set). No mask was edited.
- **No new proven bytes.** `sub_34E42` (`034E42–034E82`), both builders, `sub_32650`, `sub_3F4A2`, `sub_3F47E`, `sub_3F48E`, `sub_3F5EE`, `sub_3F5B2`, the BCD helpers, and the `022504` / `02254E` / `0226F0` sites are already set. The pointer tables `034E32–034E42` and `034EDE–034EEE`, the maps `020C48–020CAA`, and the words `01E21A–01E22C` are clear in that mask; they are data. `01E22C–01E237` is already set because the seed created `sub_1E22C` on top of the second word table.

## Findings

### 1. The compare (`sub_34E42`, Confirmed)

`0x034E42` is 64 bytes and ends at the `rts` at `0x034E80`.

```
034E42  01 00 6b 05 aa ae     mov.l   @FFAAAE, er5
034E48  7a 06 00 ff 92 ce     mov.l   #FF92CE, er6
034E4E  5e 03 f5 ee           jsr     sub_3F5EE
034E52  44 12                 bcc     034E66          ; C clear → in window A → allow
034E54  01 00 6b 05 aa ae     mov.l   @FFAAAE, er5
034E5A  7a 06 00 ff 92 d6     mov.l   #FF92D6, er6
034E60  5e 03 f5 ee           jsr     sub_3F5EE
034E64  45 0e                 bcs     034E74          ; C set → outside window B → block
034E66  6e 0c 00 86           mov.b   @(0x86,er0), r4l
034E6A  70 4c                 bset    #4, r4l
034E6C  6e 8c 00 86           mov.b   r4l, @(0x86,er0)
034E70  fc 00                 mov.b   #0, r4l        ; Z set, allow
034E72  40 0c                 bra     034E80
034E74  6e 0c 00 86           mov.b   @(0x86,er0), r4l
034E78  72 4c                 bclr    #4, r4l
034E7A  6e 8c 00 86           mov.b   r4l, @(0x86,er0)
034E7E  fc 01                 mov.b   #1, r4l        ; Z clear, block
034E80  54 70                 rts
```

`sub_3F5EE` (`0x03F5EE`, `01 00 69 64 1f c5 45 08 01 00 6f 64 00 04 1f d4 54 70`):

- `mov.l @er6, er4` then `cmp.l er4, er5`. C set means `value < lo`, and `bcs` returns with that C.
- Otherwise `mov.l @(4,er6), er4` then `cmp.l er5, er4`. C set means `hi < value`.
- Equal ends leave C clear (`value − lo = 0`, `hi − value = 0`). Both ends are inside the window. One BCD count past the high long (10 Hz) is outside.

Allow is window A **or** window B. Block is outside A and outside B. The function reads `FFAAAE` twice and does not read `FF800F`, `FF8010`, or `FF8011`.

Two entries, both returning this Z:

- `sub_34DC2` at `0x034DC2`: `55 04 55 7c 54 70` = `bsr sub_34DC8`; `bsr sub_34E42`; `rts`. The image has one `55 7c` whose target is `0x034E42` (next PC `0x034DC6` + `0x7C`).
- `sub_34E82` at `0x034E82`: `55 06 5e 03 4e 42 54 70` = `bsr sub_34E8A`; `jsr sub_34E42`; `rts`. The only `jsr sub_34E42` (`5e 03 4e 42`) in the image is `0x034E84`.

### 2. What is stored at `FFAAAE` before the compare (Confirmed arithmetic)

**VFO builder `sub_34DC8` (`0x034DC8`).** Copies the RX long, then maybe a shift, then calls `sub_325FA`.

```
034DC8  01 00 6f 04 00 1a        mov.l   @(0x1A,er0), er4     ; RX frequency
034DCE  01 00 6b 84 aa ae        mov.l   er4, @FFAAAE
034DD4  6e 0c 00 46              mov.b   @(0x46,er0), r4l
034DD8  73 0c                    btst    #0, r4l
034DDA  46 4a                    bne     034E26               ; bit 0 set → keep RX
034DDC  6e 0b 00 15              mov.b   @(0x15,er0), r3l     ; shift index
034DE0  7a 63 00 00 00 ff        and.l   #0xFF, er3
034DE6  10 73                    shll.l  #2, er3
034DE8  78 b0 6b 26 00 03 4e 32  mov.l   @(0x034E32,er3), er6
034DF0  59 60                    jmp     @er6
```

The four big-endian pointers at `0x034E32` are `00 03 4e 26 00 03 4d f2 00 03 4e 06 00 03 4e 1a`:

| `er0+0x15` | Target | Effect on `FFAAAE` |
| --- | --- | --- |
| 0 | `0x034E26` | Keep the RX long |
| 1 | `0x034DF2` | Packed-BCD subtract of `er0+0x1E` via `sub_3F94C` (`5e 03 f9 4c`) |
| 2 | `0x034E06` | Packed-BCD add of `er0+0x1E` via `sub_3F924` (`5e 03 f9 24`) |
| 3 | `0x034E1A` | Replace with `@(0x1E,er0)` (`01 00 6f 04 00 1e` / `01 00 6b 84 aa ae`) |

`sub_3F924` (`0x03F924`) clears C with `fc 00 08 cc` and then `addx`/`daa` on the low word at `+2` and the high word at `+0`. `sub_3F94C` (`0x03F94C`) is the same shape with `subx`/`das` (`1e cb 1f 0b 1e 43 1f 03`). The offset long is the same 4-byte BCD layout as the RX long. The table has four slots. `er0+0x1A` and `er0+0x1E` are the live RX and TX/offset longs (channel-record fields, re-used as labels). The UI names for index 0–3 are Inferred: SUB file `0x349073` is `53 49 4d 50 4c 45 58 00 2d 52 50 54 00 2b 52 50 54 00 44 55 50 4c 45 58 00`, the strings `SIMPLEX`, `-RPT`, `+RPT`, `DUPLEX` in that order, which matches keep / subtract / add / replace.

`er0+0x46` bit 0, when set, skips that table and leaves the RX long in `FFAAAE`. The bit's menu name is Unknown. One writer, not all of them: `0x025E98` is `6e 0c 00 46 72 0c` (`bclr #0`).

**`sub_325FA` does not change the long (Confirmed).** At `0x034E26` the builder does `7a 05 00 ff aa ae` / `5e 03 25 fa` (`jsr sub_325FA` with `er5 = #FFAAAE`). The callee starts:

```
0325FA  6e 0b 00 04     mov.b   @(4,er0), r3l
0325FE  55 50           bsr     sub_32650
032600  47 4c           beq     03264E          ; Z → rts, no store
03264E  54 70           rts
```

`sub_32650` (`0x032650`, 30 bytes):

```
032650  6a 0c 80 0f     mov.b   @FF800F, r4l
032654  f4 01           mov.b   #1, r4h        ; writes 1, Z clear
032656  46 12           bne     03266A         ; taken
03266A  fc 00           mov.b   #0, r4l        ; Z set
03266C  54 70           rts
```

The bytes between the `bne` and the return (`032658 ab 08 47 04 ab 0b 46 0a 6a 0c 80 11 46 04 fc 02 40 02`) compare `r3l` with 8 and with `0x0B`, test `FF8011`, and would return `r4l=2`. They have no path from this entry. The live return is `r4l=0` with Z set, so `0x032600` branches to the `rts` and the store at `0x032646` (`01 00 69 94`, `mov.l er4, @er1`) does not run. `er0+4` is loaded and is not read on this path. The candidate that `sub_34E42` sees is the shifted BCD long from section 2, with no further substitution.

The instructions that the `beq` skips do reference ROM maps. They are dumped in `rewrite-maps.tsv` so the immediates are on the record. `sub_3F5B2` (`0x03F5B2`) walks a header of stride word + count word, then rows of BCD lo, BCD hi, and a payload word at `+8`. A hit returns `r4l=0` and that payload in `r3`; a miss returns `r4l=1`. `0x020C48` is stride `00 0a`, count `00 03`: 824.00000–848.99500, 869.00000–893.99500, 940.10000–965.09500 MHz, payloads `00 00`, `00 01`, `00 02`. `0x020C6A` is stride `00 0a`, count `00 06`: 253.00000–275.99500, 380.00000–382.99500, 412.00000–415.99500, 810.00000–845.99500, 860.00000–900.99500, 915.00000–960.99500 MHz. On a hit the skipped code writes `(word << 16)` back to the frequency pointer: words at `0x01E21A` are `82 30`, `86 80`, `94 01` (823.00000, 868.00000, 940.10000 MHz); words at `0x01E22C` are `25 20 37 90 41 10 80 90 85 90 91 40` (252.00000 through 914.00000 MHz). `sub_325FA` does not apply them. Other `jsr sub_32650` sites are `0x01E114`, `0x01E30E`, `0x01E5A8`, and `0x032ACC`; this lane does not decode those functions. `0x01E168` and `0x01E354` use a third word base `0x01E220`, which `sub_325FA` does not.

**Staged builder `sub_34E8A` (`0x034E8A`).** No call to `sub_325FA`.

```
034E8A  01 00 6b 04 b3 92        mov.l   @FFB392, er4
034E90  01 00 6b 84 aa ae        mov.l   er4, @FFAAAE
034E96  6a 0b b3 9c              mov.b   @FFB39C, r3l
034E9A  7a 63 00 00 00 ff        and.l   #0xFF, er3
034EA0  10 73                    shll.l  #2, er3
034EA2  78 b0 6b 26 00 03 4e de  mov.l   @(0x034EDE,er3), er6
034EAA  59 60                    jmp     @er6
```

Pointers at `0x034EDE`: `00 03 4e dc 00 03 4e ac 00 03 4e be 00 03 4e d0`.

| `FFB39C` | Target | Effect |
| --- | --- | --- |
| 0 | `0x034EDC` `54 70` rts | `FFAAAE` stays `FFB392` |
| 1 | `0x034EAC` | BCD-subtract `FFB396` (`sub_3F94C`), then `rts` |
| 2 | `0x034EBE` | BCD-add `FFB396` (`sub_3F924`), then `rts` |
| 3 | `0x034ED0` | Replace with `@FFB396` |

Those `rts` instructions return to `0x034E84`, which is the `jsr sub_34E42`. Doc 24 names `FFB392` / `FFB396` / `FFB39C` the M-command staged frequency, offset, and shift; this lane cites the three loads.

`er0` at the TX request: `0x0224E0` is `81 2a` (`mov.l @FF812A, er0`). `sub_32FA2` (`0x032FA2`) returns that pointer: the `FF90F5==1` arm reloads it at `0x032FCC` (`01 00 6b 00 81 2a`), and the other arm does not write `er0`. The call at `0x0224EE` therefore still has `er0 = [FF812A]`. The call at `0x022504` is after `sub_33136`. When `FFAA37` bit 1 is clear, `0x03313C` `47 40` goes straight to the `rts` at `0x03317E` and `er0` is unchanged. When the bit is set, `0x03313E` calls `sub_3373E` before `er0` is saved. That path's `er0` is Unknown here.

### 3. Who fills `FF92CE` and `FF92D6` (Confirmed)

The only `mov.l #FF92CE` / `#FF92D6` stores are in `sub_3F4A2`. Other uses of the same RAM pair as a `sub_3F5EE` argument are `0x03478E` and `0x035D9C` (immediates at `0x034791` and `0x035D9F`); doc 61 owns those callers, and this lane does not decode them.

`sub_3F4A2` (`0x03F4A2`), sole `jsr` at `0x002DC8` (`5e 03 f4 a2 54 70`), which is the last call in `sub_2D7C` (`0x002D7C–0x002DCE`) and is reached by fall-through. `sub_2D7C` itself is called from `0x002B3E` and `0x073B26`.

```
03F4A2  6a 0c 80 0f              mov.b   @FF800F, r4l
03F4A6  f4 01                    mov.b   #1, r4h         ; Z clear
03F4A8  47 22                    beq     03F4CC          ; falls through
03F4AA  ac 06                    cmp.b   #6, r4l
03F4AC  47 1e                    beq     03F4CC          ; FF800F==6 → indexed
03F4AE  6a 04 80 11              mov.b   @FF8011, r4h
03F4B2  47 18                    beq     03F4CC          ; FF8011==0 → indexed
03F4B4  7a 06 00 00 f6 72        mov.l   #0xF672, er6    ; otherwise fixed
03F4BA  7a 05 00 ff 92 ce        mov.l   #FF92CE, er5
03F4C0  55 cc                    bsr     sub_3F48E
03F4C2  7a 05 00 ff 92 d6        mov.l   #FF92D6, er5
03F4C8  55 c4                    bsr     sub_3F48E       ; er6 already +8
03F4CA  40 1c                    bra     rts
03F4CC  7a 06 00 00 f0 ae        mov.l   #0xF0AE, er6
03F4D2  7a 05 00 ff 92 ce        mov.l   #FF92CE, er5
03F4D8  55 a4                    bsr     sub_3F47E
03F4DA  7a 06 00 00 f0 be        mov.l   #0xF0BE, er6
03F4E0  7a 05 00 ff 92 d6        mov.l   #FF92D6, er5
03F4E6  55 96                    bsr     sub_3F47E
03F4E8  54 70                    rts
```

`FF8010` does not occur in `0x034E42–0x03F4EA`. The indexed arm runs when `FF800F` equals 6, and when `FF8011` equals 0. The fixed arm runs for every other pair of those bytes, including `FF800F==0` with `FF8011` nonzero.

`sub_3F48E` copies two longs, 8 bytes, and post-increments `er6`: `01 00 6d 64 01 00 69 d4 01 00 6d 64 01 00 6f d4 00 04 54 70`. The fixed source `0x00F672` is `14 00 00 00 17 40 00 00 42 00 00 00 47 00 00 00`. That is `FF92CE` = 140.00000–174.00000 MHz and `FF92D6` = 420.00000–470.00000 MHz. The following `00 06` bytes are not copied.

`sub_3F47E` re-reads `FF800F`, clears `r4h` (`f4 01 f4 00`), multiplies by `0x24` (`79 03 00 24 52 43`), adds that to `er6`, and falls into the copy. `0xF0AE` is `F0A2+0x0C` and `0xF0BE` is `F0A2+0x1C`, so destination `d` supplies record `0x00F0A2 + d*0x24`. Each record starts `00 10 00 02`, which is not a frequency and is not copied. The copied pairs:

| `FF800F` | `FF92CE` (`+0x0C`) | `FF92D6` (`+0x1C`) |
| --- | --- | --- |
| 0 | `14 40 00 00`–`14 60 00 00` (144.00000–146.00000) | `43 00 00 00`–`44 00 00 00` (430.00000–440.00000) |
| 1 | `14 40 00 00`–`14 80 00 00` (144.00000–148.00000) | `43 00 00 00`–`45 00 00 00` (430.00000–450.00000) |
| 2 | `14 40 00 00`–`14 60 00 00` (144.00000–146.00000) | `43 00 00 00`–`44 00 00 00` (430.00000–440.00000) |
| 3 | `14 40 00 00`–`14 60 00 00` (144.00000–146.00000) | `43 00 00 00`–`44 00 00 00` (430.00000–440.00000) |
| 4 | `14 40 00 00`–`14 60 00 00` (144.00000–146.00000) | `43 20 00 00`–`43 80 00 00` (432.00000–438.00000) |
| 5 | `14 40 00 00`–`14 80 00 00` (144.00000–148.00000) | `43 00 00 00`–`45 00 00 00` (430.00000–450.00000) |
| 6 | `12 00 00 00`–`22 19 95 00` (120.00000–221.99500) | `30 00 00 00`–`57 99 95 00` (300.00000–579.99500) |
| 7 | `14 40 00 00`–`14 60 00 00` (144.00000–146.00000) | `43 00 00 00`–`44 00 00 00` (430.00000–440.00000) |

Dest 6's record also holds `+0x04` = 137.00000–174.00000 and `+0x14` = 420.00000–470.00000. Those two pairs are not what this copy writes. Full bytes are in `windows.tsv`. Inclusive high edge: `14 60 00 00` (146.00000 MHz) is allowed; `14 60 00 01` is not.

### 4. What the callers do with the flag

The image has 13 `jsr sub_34DC2` (`5e 03 4d c2`) and 2 `jsr sub_34E82` (`5e 03 4e 82`). Z set continues the caller's next instruction. Z clear takes the `bne`. This lane stops at that branch.

**TX request `sub_2244C`, the site doc 93 named (Confirmed).**

```
0224E6  6a 0c 89 92        mov.b   @FF8992, r4l
0224EA  ac 0a              cmp.b   #0x0A, r4l
0224EC  46 12              bne     022500
0224EE  5e 03 4d c2        jsr     sub_34DC2
0224F2  46 06              bne     0224FA          ; block
0224F4  5e 03 2f f4        jsr     sub_32FF4       ; allow
0224F8  40 10              bra     02250A
0224FA  5e 03 31 36        jsr     sub_33136
0224FE  40 4e              bra     02254E          ; same refuse as below
022500  5e 03 31 36        jsr     sub_33136
022504  5e 03 4d c2        jsr     sub_34DC2
022508  46 44              bne     02254E
02250A  55 6e              bsr     sub_2257A       ; allow: setup continues
022522  fc ff              mov.b   #0xFF, r4l
022524  6a 8c aa e0        mov.b   r4l, @FFAAE0
022540  fc 01              mov.b   #1, r4l
022542  6a 8c 94 c0        mov.b   r4l, @FF94C0
02254E  fc 02              mov.b   #2, r4l        ; block arm
022550  6a 8c 94 c0        mov.b   r4l, @FF94C0
022554  fc 1d              mov.b   #0x1D, r4l
022556  6a 8c aa e0        mov.b   r4l, @FFAAE0
02255A  6a 0c 94 c0        mov.b   @FF94C0, r4l
02255E  ac 01              cmp.b   #1, r4l
022560  54 70              rts                    ; Z clear, because FF94C0 is 2
```

On allow, setup continues at `0x02250A`, the tone byte is set to `0xFF`, and `FF94C0` is set to 1. On block, `FF94C0=2`, tone `FFAAE0=0x1D`, and the `0x02250A` setup is not entered. The `FF8992==0x0A` block arm joins that same refuse. `sub_32FF4` and `sub_33136` are not decoded here.

**`sub_22676` (Confirmed).** `0x022696` `5e 03 4d c2` / `0x02269A` `46 54` `bne 0x0226F0`. The refuse is the same shape: `0226F0 fc 02 6a 8c 94 c0 fc 1d 6a 8c aa e0`. Allow falls through at `0x02269C` into the setup that also stores `FFAAE0=0xFF` and `FF94C0=1`.

**Other `jsr sub_34DC2`, immediate arm only.**

| Site | Next bytes | Block arm |
| --- | --- | --- |
| `0x01C96C` | `46 1a` | `0x01C98C`. Allow at `0x01C972` sets `FF817E` bit 0, copies `[FF8126]` to `[FF812A]`, pops `er0`, `r4l=0` |
| `0x01C9AE` | `54 70` rts | The caller's caller receives the flag |
| `0x02F6B2` | `5e 03 25 90` | No test of Z in the next instruction |
| `0x030234` | `46 30` | Allow at `0x03023A`: `FFAAD1` bit 0 set, `FFAACE=5`, `FFAAE0=0xFF`, copy `FFAAAE`→`FFAAAA` |
| `0x0311A0` | `5e 03 25 90` | No test of Z in the next instruction (band-B twin of `0x02F6B2`) |
| `0x031CC6` | `46 30` | Same allow stores as `0x030234` |
| `0x037BE8` | `46 08` | Allow loads `@FFAAAE` into `er4` and branches. Block also loads `@FFAAAE`, then `037BFC 7a 24 05 00 00 00` `cmp.l #0x05000000, er4` / `44 08 bcc`. Below `05 00 00 00` (50.00000 MHz BCD) the constant is loaded into `er4` (`7a 04 05 00 00 00`); otherwise `@(0x42,er0)` is loaded. The rest of that function is not followed |
| `0x068202` | `46 30` | Allow continues to `jsr sub_67AB0` |
| `0x06CE38` | `46 70` | Allow at `0x06CE3E` toggles `FF8DE0` bit 7 |
| `0x06D0DE` | `46 0c` | Allow stores `FFB3E4=1` and calls `0x01CA72`. Block calls `sub_3FFA0` and returns |

**`jsr sub_34E82`.** `0x025B98` `46 0a`: both the range block and a later `bne` store `r4l=1` and return; the allow arm of both stores `r4l=0`. `0x025FD0` `58 60 01 54` branches to `0x02612C` on block.

### 5. `er0+0x86` bit 4 (Confirmed write, reader not a TX branch)

The allow path is the `bset #4` at `0x034E6A`. The block path is the `bclr #4` at `0x034E78`. A scan of `6e xx 00 86` found one `btst #4` of that byte: `0x010674` `6e 5c 00 86 73 4c 47 84`. The test uses `er5`, and it sits after `cmp.b #3` of `er5+0x93`. Z on the bit test branches toward `0x010600`. The fall-through reads `er5+0x90` and, when that byte is 2 and `FFBB93` is 0, stores `FFBB93=1` (`0x010684` `6a 0c bb 93 46 06 fc 01 6a 8c bb 93`). The TX request does not read the bit. It uses the Z flag from `fc 00` / `fc 01`. What `FFBB93` means is Unknown here.

## USB relevance

- **Q1 (USB): the check is not a USB path.** `sub_34E42` is at `0x034E42`, outside `0xFFEE00`–`0xFFEE53` and outside the closed window. It reads two RAM windows and `FFAAAE` and writes one bit of the record at `er0`.
- The same predicate is reachable from the staged builder: `jsr sub_34E82` at `0x025B98` and `0x025FD0`. Three more `jsr sub_34DC2` sites sit in the host-command address range (`0x068202`, `0x06CE38`, `0x06D0DE`) and branch on this flag. Their commands were not re-decoded.
- **Q2 (SDR): unchanged no.** The compare does not move samples.
- **Q3 (DSP): unchanged.** Tone `0x1D` is the byte doc 93 already reports for this refuse. This lane does not add a DSP session.

## Open

1. **Name of `er0+0x46` bit 0.** The bit skips the shift arithmetic. The menu label was not tied to a writer.
2. **`er0` on the `FFAA37` bit-1 set path** through `sub_3373E` before the `0x022504` call. The bit-clear path keeps `[FF812A]`.
3. **`FFBB93` at the bit-4 reader `0x010674`.** Outside the TX branch that consumes Z.
4. **Order of the two `sub_2D7C` callers** (`0x002B3E`, `0x073B26`) relative to the first use of the RAM windows. The check reads RAM; the only writer found is `sub_3F4A2`.

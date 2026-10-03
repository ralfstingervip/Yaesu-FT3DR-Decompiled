# SUB ver 1.02 — menu record walker search

Image: `decrypted/FT3D_SUB_ver102_ALL.bin`, 4,194,304 bytes, RX64M, base `0xFFC00000`
(file offset = address − `0xFFC00000`). Every claim below is anchored to an address in that image.
Work was done read-only on a disposable copy of `ida/db/radio/SUB.i64` under
`ida/db/investigate/` (since removed); nothing in `Firmware/`, `decrypted/`, `ida/db/radio/`,
or the radio was touched.

## Record map (layout CONFIRMED from the plaintext)

Records are little-endian `uint32 count`, `uint32 pointer`, 8 bytes each, starting at file
`0x2D74F0` (`FFED74F0`). Confirmed by reading the dwords directly:

| File | Addr | count | pointer | First label |
| --- | --- | --- | --- | --- |
| `2D74F0` | FFED74F0 | 9 | FFC3DF4D | TARGET LOCATION |
| `2D74F8` | FFED74F8 | 3 | FFC3E001 | MODE |
| `2D7500` | FFED7500 | 6 | FFC3E03D | BANK LINK |
| `2D7508` | FFED7508 | 0E | FFC3E0B5 | BELL |
| `2D7510` | FFED7510 | 6 | FFC3E1CD | DW TIME |
| `2D7518` | FFED7518 | 2 | FFC3E245 | DP-ID LIST |
| `2D7520` | FFED7520 | 5 | FFC3E26D | RPT/WIRES FREQ |
| `2D7528` | FFED7528 | 16 | FFC3E2D1 | APO |
| `2D7530` | FFED7530 | 1C | FFC3E489 | APRS block (COM PORT SETTING = slot idx 16, FFC3E5C9) |
| `2D7538` | FFED7538 | 4 | FFC3E6B9 | BACKUP, MEMORY CH, MEMORY INFO, FORMAT |
| `2D7540` | FFED7540 | 4 | FFC3E709 | USB CAMERA, Bluetooth, DEVICE LIST, Bluetooth Save |
| `2D7548` | FFED7548 | 1 | FFC3E76D | CALLSIGN |
| `2D7550`..`2D7588` | FFED7550.. | 0 | 0 | (zeros) |
| `2D7590` | FFED7590 | 3 | FFC3E781 | ANTENNA ATT |
| `2D7598` | FFED7598 | 4 | FFC3E7BD | DIGITAL POPUP |
| `2D75A0` | FFED75A0 | 5 | FFC3E80D | MIC GAIN |

`RAM DISPLAY` (`FFC3E759`) is the slot after `Bluetooth Save` and is in no record's count.

At file `2D75A8` (`FFED75A8`) the dwords stop being count/pointer records and become a run of
code pointers — this is a compiler-generated **switch jump table**, a separate object that merely
sits adjacent to the records in the same data blob:

```
FFED75A8 : FFF08994   FFED75AC : FFF089A6   FFED75B0 : FFF089D3   FFED75B4 : FFF08AC9   (table A, 4 cases)
FFED75B8 : FFEF2032 x16 (default), FFED75F4 : FFF08A00, FFED75F8 : FFF08A85            (table B)
```

## Search 1 — PC-relative / computed targets in the 455 functions

Every instruction in all 455 recovered functions was decoded (IDA RX decoder). Each operand's
resolved immediate, memory, and displacement value was tested against the record window.

- Operands landing in `FFED74F0`–`FFED75B8` (records + table A): **0**
- Operands landing in the broad window `FFED7400`–`FFED7600`: **0**
- The only `FFED7xxx` reference by any of the 455 functions is `mov.l #off_FFED7E90, r14`
  at `FFF12ACA` and `FFF12AFE` (string-pointer table for the drive-`I` `"FT3D"…` strings, already excluded — not the
  menu list).

No recovered function loads, points at, or indexes the count/pointer record table.
An absolute-dword scan of the whole 4 MB image agrees: **nothing** anywhere loads `FFED74F0`
as an immediate, and the only stored pointer into `FFED74F0`–`FFED75B8` is the switch-table
base described below.

## Search 2 — uncovered code around `FFF08960`–`FFF08B00`

`FFF0896A` is reached from the menu-handler pointer table at `FFED40C8` (`FFED40C8 -> FFF0896A`).
It is not inside any of the 455 functions. Forced RX decode of it (authoritative IDA disassembly):

```
FFF0896A  FB E2 4C 8C 00 00   mov.l   #8C4Ch, r14         ; &state byte at RAM 0x00008C4C
FFF08970  58 EE               movu.b  [r14], r14          ; r14 = state (0..)
FFF08972  61 3E               cmp     #3, r14
FFF08974  2A 16               bgt.b   FFF0898A            ; state > 3 -> default
FFF08976  FB E2 4C 8C 00 00   mov.l   #8C4Ch, r14
FFF0897C  58 EE               movu.b  [r14], r14          ; r14 = state (case index)
FFF0897E  FB F2 A8 75 ED FF   mov.l   #off_FFED75A8, r15  ; r15 = switch jump-table base (table A)
FFF08984  FE 6E FE            mov.l   [r14, r15], r14     ; r14 = table[index]  ([Ri,Rb].L scales *4)
FFF08987  7F 1E               jsr     r14                 ; call case handler
FFF08989  02                  rts
FFF0898A  FB E2 4C 8C 00 00   mov.l   #8C4Ch, r14         ; default:
FFF08990  F8 E4 03            mov.b   #3, [r14]           ; state = 3
FFF08993  02                  rts
```

A second, identical switch pattern uses table B:

```
FFF08B1D  58 EE               movu.b  [r14], r14          ; r14 = state byte at RAM 0x00008F73
FFF08B1F  FB F2 B8 75 ED FF   mov.l   #off_FFED75B8, r15  ; r15 = switch jump-table base (table B)
FFF08B25  FE 6E FE            mov.l   [r14, r15], r14     ; r14 = table[index]
FFF08B28  7F 1E               jsr     r14
```

### The two instructions whose target lands in the record window

Both are `mov.l #imm32, r15` (opcode `FB`, dest r15), loading a **switch jump-table base**, not
a count/pointer record:

| Addr | Bytes | Disassembly | Target |
| --- | --- | --- | --- |
| `FFF0897E` | `FB F2 A8 75 ED FF` | `mov.l #off_FFED75A8, r15` | FFED75A8 (jump table A) |
| `FFF08B1F` | `FB F2 B8 75 ED FF` | `mov.l #off_FFED75B8, r15` | FFED75B8 (jump table B) |

Note on the prior "`FFF08980` stores `FFED75A8`" observation: `FFF08980` is not a standalone data
pointer. Bytes `A8 75 ED FF` at `FFF08980`–`FFF08983` are the imm32 field of the
`mov.l #off_FFED75A8, r15` instruction that begins at `FFF0897E`. `FFF08980` decodes as RX
(it is the middle of that instruction), so it is code, not a back-pointer.

Following the four case entries `FFF08994`, `FFF089A6`, `FFF089D3`, `FFF08AC9` (each decodes as RX,
each ends in a call/branch to other handlers such as `sub_FFEEF9BB`, `sub_FFEF036F`, and back
into `FFF08B55`) stays inside this menu-handler function and its neighbors. Decoding stopped after
this function group (~`FFF08950`–`FFF08B60`, roughly 0.5 KB of newly decoded code, well under the
64 KB budget) because the walk was resolved: it is a self-contained state-machine switch.

## Search 3 — does this code read the records / select USB CAMERA or COM PORT?

No. `FFF0896A` and its second switch read RAM state bytes at `0x00008C4C` and `0x00008F73`
(`movu.b [r14], r14` at `FFF08970`/`FFF0897C` and `FFF08B1D`), bound them (`cmp #3` at `FFF08972`),
and index a jump table of **code pointers** (`mov.l [r14, r15], r14` at `FFF08984` / `FFF08B25`).
They never load `FFED74F0`, never read a `count`/`pointer` record, and never compute a menu-slot
address. No instruction reaches the USB CAMERA record (`FFED7540`), the USB CAMERA slot
(`FFC3E709`), the COM PORT SETTING slot (`FFC3E5C9`), or `RAM DISPLAY` (`FFC3E759`). One nearby
immediate, `mov.l #FFC3DF35, …` at `FFF08A11`, points 24 bytes before the first menu slot
(`FFC3DF4D`) and into no slot. So `RAM DISPLAY` does not count.

## Search 4 — USB0 window

No operand (immediate, memory, or displacement) in any of the 455 functions falls in the USB0
register window `0x000A0000`–`0x000A03FF` (0 hits). None of the newly decoded uncovered code at
`FFF0896A`+ touches USB0 either. The bytes around `FFF08980` do decode as RX (they are the tail of
the `FFF0897E` instruction), so there is nothing undecodable to quote there.

## Conclusion

The count/pointer record table at `FFED74F0` has no reader anywhere in the recovered code or in
the decoded adjacent uncovered code. The only code that references the `FFED75xx` region is the
menu-handler switch at `FFF0896A` (and a twin at `FFF08B1F`), which uses `FFED75A8`/`FFED75B8` as
compiler switch jump tables of code pointers — not as the menu records, and with no index path to
the USB CAMERA record, the COM PORT slot, `RAM DISPLAY`, or the USB0 registers.

Walker: none

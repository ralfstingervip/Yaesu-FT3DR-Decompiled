# FT3DR ver 1.02 USB functions

No recovered function is USB. There is no function section in this file.

The operand scan visited every row of `ida/out/survey/MAIN/functions.tsv` (1298) and `ida/out/survey/SUB/functions.tsv` (455). Both coverage lines are `equal=yes`. `usb_operands.tsv` in each folder has a header and no hit rows: no instruction operand, memory reference, or non-code literal in RX64M USB0 `0x000A0000`–`0x000A03FF`, and no reference to `USB CAMERA`, `COM PORT SETTING`, the delimited word `USB`, `VID_045B`, `PID_0025`, or the setup-table base at SUB `0xFFC3DF4D`. With no such function, no caller or callee is on a USB chain. `RAM DISPLAY` at `0xFFC3E759` is not on the list. `!sdr` at MAIN file `0xC4B2` is not a USB hit.

The four lane tables are `docs/usb-lanes/main-low.tsv`, `main-high.tsv`, `sub-low.tsv`, and `sub-high.tsv`. The merge is `docs/usb-census.tsv`.

## Score

`D` is 1753. Every recovered function is in the census as `not-usb` with `no-usb-operand`, `no-usb-string`, and `not-on-usb-chain`.

`T` is 1298 + 455 + 35 = 1788. The 35 added rows are gap hits the lanes appended with evidence and a blank disposition. They were not recovered into functions, so they stay out of `D`.

Completion: 98.0% (1753/1788).

### Gap hits left unrecovered

Three are ASCII strings in SUB bytes no function covers:

| Address | File | Bytes |
| --- | --- | --- |
| `FFC3E5C9` | `0003E5C9` | `COM PORT SETTING` |
| `FFC3E709` | `0003E709` | `USB CAMERA` |
| `FFF4AA16` | `0034AA16` | the delimited word `USB` |

The other 32 are 4-byte-aligned gap dwords whose value, in the endianness the lane named, falls in USB0 and survived that lane's 16-bit-table test. MAIN is big-endian. SUB is little-endian. A row can still be the other endianness, because the gap search used both layouts.

| Image | Address | Endian | Value |
| --- | --- | --- | --- |
| MAIN | `000166A4` | big | `000A00FF` |
| MAIN | `00016B78` | big | `000A00FF` |
| MAIN | `000170F8` | big | `000A00FF` |
| MAIN | `000179BC` | big | `000A00FF` |
| MAIN | `00020C48` | big | `000A0003` |
| MAIN | `00020D50` | big | `000A0001` |
| MAIN | `00020D84` | big | `000A0002` |
| MAIN | `00020D9C` | big | `000A0001` |
| MAIN | `0002FC68` | little | `000A035E` |
| MAIN | `0002FDEC` | little | `000A035E` |
| MAIN | `0002FF48` | little | `000A035E` |
| MAIN | `00030210` | little | `000A035E` |
| MAIN | `00030B00` | big | `000A000F` |
| MAIN | `00035140` | big | `000A0002` |
| MAIN | `00037E50` | big | `000A0009` |
| MAIN | `00039F30` | little | `000A0000` |
| MAIN | `00040D2C` | big | `000A003D` |
| MAIN | `0004116C` | big | `000A002F` |
| MAIN | `00041480` | big | `000A001F` |
| MAIN | `0007B740` | little | `000A0200` |
| SUB | `FFC00EC4` | big | `000A0029` |
| SUB | `FFC09398` | big | `000A0033` |
| SUB | `FFC0EC04` | big | `000A001A` |
| SUB | `FFC11D68` | big | `000A0033` |
| SUB | `FFC18010` | big | `000A0009` |
| SUB | `FFC1A7D0` | big | `000A0011` |
| SUB | `FFC33E44` | big | `000A0029` |
| SUB | `FFC3D694` | big | `000A0001` |
| SUB | `FFC3D748` | big | `000A0302` |
| SUB | `FFC3D900` | big | `000A0001` |
| SUB | `FFC3D9B4` | big | `000A0302` |
| SUB | `FFF46008` | big | `000A00ED` |

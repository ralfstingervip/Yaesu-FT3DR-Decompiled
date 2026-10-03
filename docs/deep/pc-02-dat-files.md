# PC lane 2: microSD `.dat` files (BACKUP, MEMORY, QSO)

Lane 2 of the PC-software pass. This lane covers the on-disk format of the files
the radio keeps on its microSD card, so that a PC program can read them and
write them safely. It also closes RESUME residual #3, the `.dat` reader
validation question. The field table is `ida\out\pc\L2-dat-layout.tsv`, with 52
rows. The IDA listings behind it are in `ida\out\pc\L2-listings\`.

Every analysis was static and run on files already on disk. Nothing was written
to a radio. The only IDA databases used were two private copies,
`ida\db\jobs\PC_L2_MAIN` (seeded from `MAIN_FULL`) and `PC_L2_SUB` (seeded from
`STOR_SUB`).

## Verdict

- **`BACKUP.dat` is a raw copy of MAIN's serial EEPROM.** It has no container
  header. It holds EEPROM `0x00140–0x0FFFF` followed by `0x10100–0x1FFFB`, then
  a 32-bit big-endian additive checksum. The file is exactly **0x1FDC0 bytes
  (130,496)**. These are the same EEPROM ranges the DATA-jack clone path
  streams, which suggests a clone image and a `BACKUP.dat` hold the same data.
  Compare `sub_737FC` and `sub_7358E`, which walk `0x140`, then `0x3FB × 0x40`,
  then `0x10100`, then `0x3FC × 0x40`.
- **`MEMORY.dat` is a raw copy of the memory-channel part of the EEPROM.** It
  holds EEPROM `0x1680–0xB7FF`, 0x80 bytes of padding, then EEPROM
  `0x1A000–0x1A917`, then the checksum and padding. The file is exactly
  **0xAC80 bytes (44,160)**. Channel slots are **32-byte records**, 1100 of
  them, starting at file offset `0x1800`.
- **Checksum.** Add every byte of the covered range as an unsigned 8-bit value
  into a 32-bit accumulator that starts at 0 and wraps modulo 2^32. Store the
  result big-endian in the four bytes directly after the covered range. This is
  not a CRC. There is no polynomial and no XOR, and the file has no other
  integrity field.
- **What the reader checks (closes RESUME #3).**
  - **File size** must be exact. This check only decides whether the restore
    menu item is enabled.
  - **For `BACKUP.dat` only**, a **14-byte ID at file offset 0x220** is checked:
    it must be `"AH72M"`, then `0x02`, then the radio's own 3-byte region code.
  - **The checksum** is compared, but **only after every byte has already been
    written into EEPROM**.

  If the checksum does not match, the EEPROM keeps its "restore in progress"
  marker (`"MARU"`). MAIN then restarts and takes its default-initialisation
  path, so a bad file ends in a settings reset rather than half-applied
  settings. No field is range-checked. The chunk sizes are fixed, so there is no
  length field to overflow.

## 1. Who does what

- **MAIN** (H8S) owns the file formats, the checksum and every validation step.
- **SUB** (RX64M) is a remote file server. It takes MAIN's fixed request frames
  over the SCI-D inter-processor link and turns them into FAT operations on
  drive `I:`.

MAIN never sees FAT structures. It asks for "read `len` bytes at `offset` of
file `name` in directory `dir`" and receives the bytes back.

- **Request frames.** Prebuilt templates sit at MAIN `0x71326–0x73030`, one
  every 0x96 bytes. The sender is `sub_71196`. It copies the template, patches
  the length (template `+0x76`, u32) from `0xFFBA96` and the offset (`+0x7A`,
  u32) from `0xFFBA9A`, then appends the payload from the template's buffer
  pointer at `+0x92`.
- **Template fields.**
  - `+0x10` is the operation code.
  - `+0x14` is the directory index.
  - `+0x56` is the file name.
  - `+0x90` is the payload length.
- **Operation codes, as used.** The purpose of each code is inferred from how
  MAIN uses it.

  | Code | Use |
  | --- | --- |
  | `0x14` | Get the file size (the reply carries the size at `+0x7E`) |
  | `0x05` | Create and write the first chunk |
  | `0x06` | Append a chunk |
  | `0x08` | Append the last chunk and close |
  | `0x0B` | Open and read `len` bytes at `off` |
  | `0x0D` | Open and read |
  | `0x0E` | Read the next chunk |
  | `0x0F` | Read the last chunk and close |
  | `0x01`, `0x02`, `0x03`, `0x0A`, `0x10`, `0x12` | Used by the QSO store |

- **Reply status.** The reply block is at `0xFF5006`. A non-zero word at
  `0xFF5014` (reply `+0x0E`) is an error, and every step aborts on it.

### Paths

The directory index is byte-confirmed. MAIN's template `+0x14` value selects the
entry `pathtab_bare[dir]`, and SUB builds the path as `"I:\"` followed by that
entry (SUB `0xFFF3E666`, prefix string at `0xFFF4AFF3`). Appending `"\" + name`
after that is inferred.

| dir | card directory | files MAIN uses |
| --- | --- | --- |
| 0 | `\FT3D` | — |
| 1 | `\FT3D\BACKUP` | `BACKUP.dat` |
| 2 | `\FT3D\GPSLOG` | GPS log (SUB-owned, not a MAIN `.dat`) |
| 3 | `\FT3D_MEMORY-CH` (note the underscore) | `MEMORY.dat` |
| 4 | `\QSOLOG` | `QSOMNG.dat`, `WAVMNG.dat`, `QSOMSG*.dat`, `QSOPCT*.dat`, `QSOWAV*.dat` |
| 5 | `\PHOTO` | `<12 chars>.jpg` pictures |
| 6 | `\VOICE` | `.wav` recordings |

Name matching goes through SUB's FAT layer, which supports long file names and
is case-insensitive. `QSOMSGDIR.dat` and similar names are longer than 8.3, so
they need LFN entries. The card must be FAT12, FAT16 or FAT32; exFAT is rejected
(doc 13).

## 2. `BACKUP.dat`

The writer is `sub_74562`, `sub_745EE` and `sub_7469E`/`sub_74702`. The reader
is `sub_747DE`, `sub_7481A`, `sub_748A0`, `sub_7494E` and `sub_749D6`. Both
reach the state machine through `sub_2ABA8`, entered from the menu at
`0x2AB8A`. Chunks are 0x300 bytes, and the final chunk of region A is 0x2C0.

| File offset | Length | Content | Source |
| --- | --- | --- | --- |
| `0x00000` | `0xFEC0` | EEPROM `0x00140–0x0FFFF`, device A0/A1 (`sub_3AB80` reads, `sub_3AD20` writes) | byte-confirmed |
| `0x00220` | `0x0E` | ID block, equal to EEPROM `0x360` (below) | byte-confirmed |
| `0x01540` | `0xA180` | the same bytes as `MEMORY.dat` `0x0000–0xA17F` | byte-confirmed (addresses) |
| `0x0FEC0` | `0xFEFC` | EEPROM `0x10100–0x1FFFB`, device A2/A3 (`sub_3BDAC` reads, `sub_3BF4C` writes) | byte-confirmed |
| `0x19DC0` | `0x0918` | the same bytes as `MEMORY.dat` `0xA200–0xAB17` | byte-confirmed (addresses) |
| `0x1FDBC` | 4 | checksum, u32 BE, the sum of bytes `[0, 0x1FDBC)` | byte-confirmed |

The mapping from file offset to EEPROM address is `eep = off + 0x140` for
`off < 0xFEC0`, and `eep = off − 0xFEC0 + 0x10100` otherwise.

Some EEPROM ranges are not in the file, so a restore never touches them:

- `0x000–0x13F`:
  - the boot marker at `0x10` (`"TAIS"` = valid, `"MARU"` = restore in
    progress; constants at `0xDD0E` and `0xDD16`)
  - the region code at `0x20–0x27`
  - a `0x100`-byte block at `0x40`
- `0x10000–0x100FF`, which probably holds the second device's marker, read by
  `sub_DDA0`.
- `0x1FFFC–0x1FFFF`. The radio does write the file's checksum bytes to these
  addresses on restore, because the last chunk is written whole, but a backup
  never saves them.

**ID block at file offset 0x220.** Before it reads the EEPROM, the writer
rebuilds this block at `loc_7390A` and stores it at EEPROM `0x360` with
`sub_3A028`. That way the file always carries the radio's current ID.

| Bytes | Value | Reader check (`sub_737C8`) |
| --- | --- | --- |
| 0–4 | `"AH72M"` | must be equal (`0x737CA`) |
| 5 | `0x02` | must equal `sub_734BE()`, which returns 2 (`0x737E2`) |
| 6–9 | `00`, EEP[`0x21`], EEP[`0x22`], EEP[`0x23`] (RAM `0xFF800F–11`) | must be equal (`0x737EE`, `sub_7357A`) |
| 10–13 | `00 00 00 00` | not checked |

**The region lock is real.** The region bytes live at EEPROM `0x21–0x23`, which
are outside the file, and the reader compares them against the file. A
`BACKUP.dat` from a radio with a different destination code is therefore
refused before anything is written. The `sub_7358E` clone-receive path runs the
same `sub_737C8` check.

**Restore sequence** (`0x747DE`):

1. Read four bytes of EEPROM `0x10`.
2. Open the file and read 0x40 bytes at offset `0x220`.
3. Copy 14 of those bytes to `0xFF96F8` and run `sub_737C8`. On failure, show
   an error and stop; nothing has been written yet.
4. Run `sub_74B08`, which quiesces the subsystems.
5. Write `"MARU"` to EEPROM `0x10`.
6. Stream the file from offset 0. Each chunk is added to the running sum and
   written straight to EEPROM.
7. At the end, compare the sum with the last four bytes (`0x74AA8`).
   - **If they match:** run the apply hooks (`sub_750C2`, `sub_75160`,
     `sub_754BC`, `sub_75EB6`), write `"TAIS"` back (`sub_39504`), and restart
     at `jmp 0xDC4E`.
   - **If they differ:** jump straight to `0xDC4E` with `"MARU"` still set. At
     boot, `sub_DD5C` sees `"MARU"` and takes the initialisation branch at
     `0xDCD6` (`sub_DEFA`, `sub_E8AE`, the default writers, then `"TAIS"`).

The restore branch is inferred to be a settings reset.

## 3. `MEMORY.dat`

The writer is `sub_74B2A`, `sub_74B90`, `sub_74C58` and `sub_74CBC`. The reader
is `sub_74DCA`, `sub_74E38`, `sub_74EE6`, `sub_74F6E` and `sub_7501C`.

| File offset | Length | Content | Confidence |
| --- | --- | --- | --- |
| `0x0000` | `0x12C0` | 24 × 0xC8 blocks (EEPROM `0x1680 + 0xC8·i`, `sub_3A172`); probably 24 banks × 100 u16 entries | stride byte-confirmed, meaning inferred |
| `0x12C0` | `0x0540` | one attribute byte per slot, slot n at `0x12C0 + n` (EEPROM `0x2940 + n`, `sub_3A7CE`) | addressing byte-confirmed |
| `0x1800` | `0x8980` | **1100 channel records × 32 bytes**, slot n at `0x1800 + 0x20·n` (EEPROM `0x2E80 + 0x20·n`, `sub_3A6EE`) | byte-confirmed |
| `0xA180` | `0x0080` | zeros (the last source chunk is 0x280 bytes, padded to 0x300); covered by the checksum; not restored | byte-confirmed |
| `0xA200` | `0x0048` | EEPROM `0x1A000–0x1A047`; per-band u16 arrays at `+0x18` and `+0x30` (`sub_3DEA8`) | addressing byte-confirmed |
| `0xA248` | `0x0038` | EEPROM `0x1A048–0x1A07F` | byte-confirmed (in range) |
| `0xA280` | `0x0898` | one u16 per slot, slot n at `0xA280 + 2n` (EEPROM `0x1A080 + 2n`, `sub_3DF1C`) | addressing byte-confirmed, meaning unknown |
| `0xAB18` | 4 | checksum, u32 BE, the sum of bytes `[0, 0xAB18)` | byte-confirmed |
| `0xAB1C` | `0x164` | zeros; not summed, not stored | byte-confirmed |

The mapping from file offset to EEPROM address is `eep = off + 0x1680` for
`off < 0xA180`, and `eep = off − 0xA200 + 0x1A000` for
`0xA200 ≤ off < 0xAB18`.

**Checks.** The size must be exactly `0xAC80` for the restore item to be
enabled (`0x70080` sets `0xFFBA42`, and `0x6FC66` tests it). The checksum is
tested at the end (`0x75092`). There is **no ID or region check**. As with
BACKUP, `"MARU"` is written to EEPROM `0x10` before the stream starts
(`0x74DF0`), and on a mismatch the flow reaches `loc_750BE`, which leaves the
marker in place. The restore also calls `sub_74B08`, `sub_E934` and
`loc_39CE6` first.

### 3.1 The 32-byte channel record

The record is unpacked by `sub_3FB0C` into the working VFO structure at
`VFO+0x12` and packed back by `sub_3FD48`. The bit splits below are
byte-confirmed in both directions. A field's meaning is marked where the
firmware proves it.

| Offset | Content |
| --- | --- |
| `+0x00` | flag byte, copied whole (meaning unknown) |
| `+0x01` | bits 0–3, 4–5 and 6–7 are three separate fields (meanings unknown; mode, step and shift are candidates) |
| `+0x02` | **RX frequency, 3 bytes BCD**: digits 100 MHz … 1 kHz, e.g. `14 65 20` = 146.520 MHz. The sub-kHz part is implied at or above 1.8 MHz: last two digits `12/37/62/87` → +0.50 kHz, `06/31/56/81` → +0.25 kHz, `18/43/68/93` → +0.75 kHz. |
| `+0x05` | bits 0–3, 4–5 and 6–7 are fields (unknown) |
| `+0x06` | u16 name-attribute word, always written together with the name as one 0x12-byte unit (`0x3A8E2`) |
| `+0x08` | **name, 16 bytes**; all `0xFF` means no name (`sub_3A796` tests 8 words against `0xFFFF`); character set not proven |
| `+0x18` | **second frequency**, same 3-byte BCD encoding; offset or split TX (role inferred) |
| `+0x1B` | **CTCSS index** 0–49 into the 50-tone table at MAIN `0x35158`; consumer `sub_34BCA` reads `VFO+0x17`; default 12 = 100.0 Hz |
| `+0x1C` | **DCS index** 0–103 into the table at `0x5072` (`VFO+0x18`) |
| `+0x1D` | bits 0–4 and 5–7 are fields (unknown) |
| `+0x1E` | bits 0–3, 4–5 and 6–7 are fields (unknown) |
| `+0x1F` | bits 0–2 and 3–7 are fields; bit 7 selects the alternate working buffer `0xFF9102` |

**Slot numbering.** Slots 1000–1099 are addressed as `1000 + 2k`
(`sub_3A9A2`), which fits 50 PMS pairs. The mapping of slots 0–999 to M001–M900
and any other uses is inferred. This record family matches the 32-byte Yaesu
FT1D/FT2D-style record (flags, BCD frequency, name attribute plus 16-character
tag, BCD offset, tone, DCS). That resemblance is how the unknown bit fields
should be approached: diff two backups of a real radio on either side of one
change.

## 4. QSO store and management files (read-only recommended)

These files form a small database: a management header, directory records, an
allocation table kept inside a file, and data files. They are all in `\QSOLOG`,
and the pictures are in `\PHOTO`. Only partial layouts were recovered; see the
TSV.

- **`QSOMNG.dat` (0x20 bytes).**
  - The size must be exactly 0x20, otherwise the radio does not load it
    (`0x6FFF8`).
  - `+0x00–0x0F` is the message-store block; `+0x10–0x1F` is the picture-store
    block.
  - The u16 at `+0` and at `+0x10` is the current index; `0xFFFF` means empty.
  - Defaults: the message block is 16 × `FF`; the picture block is
    `FF FF 00 01` followed by `FF`s (`0x6F4A6` / `0x6F4B6`).
- **`WAVMNG.dat` (0x20 bytes).** The same role for voice recordings (RAM
  `0xFF304A`).
- **`QSOMSGDIR`, `QSOPCTDIR` and `QSOWAVDIR.dat`.** Records of 0x80 bytes;
  record n (counting from 1) is at `(n−1)·0x80`. MAIN sets bit `0x40000000` in
  the requested offset; the reason is unknown.
  - The default record is at `0x6F534`. Its runs are 4×`00`, 42×`20`, 18×`00`,
    16×`20`, 4×`00`, 16×`20`, 20×`FF`, 8×`00`.
  - In picture records, `+0x54` holds a 12-character name; the radio opens
    `\PHOTO\<name>.jpg` (`0x6F5FE–0x6F646`).
- **`QSO*FAT.dat`.** 4-byte entries.
- **`QSOMSG.dat`.** Accessed in 0x50-byte units.

The only content check MAIN makes on any of these files is "index == 0xFFFF"
and "name == 0xFFFFFFFF". Out-of-range indexes are not bounded against the file
size on the MAIN side (inferred), so writing these files is not recommended
until the allocation-table semantics are mapped.

**Other card files, noted for completeness.** These are SUB-owned and not part
of MAIN's `.dat` family (doc 13):

- `\VOICE\*.wav` is standard RIFF/WAVE.
- The `\FT3D\GPSLOG` log is append-mode.
- `\RECBACKUP` holds voice-recording backups.
- `sub_FFF140C7` builds `<dir>\Backup.bin` inside a SUB structure at
  `0x1EE24+0x21C`. Its purpose is unknown and it is not `BACKUP.dat`.

## 5. What a PC program must get right

1. **Exact sizes.** `BACKUP.dat` must be 0x1FDC0 bytes and `MEMORY.dat` must be
   0xAC80. With any other size the restore menu item stays disabled.
2. **Exact paths.** Use `\FT3D\BACKUP\BACKUP.dat` and
   `\FT3D_MEMORY-CH\MEMORY.dat`, on a FAT12/16/32 card, never exFAT.
3. **Checksum.** Recompute it over the exact covered range and store it
   big-endian at `0x1FDBC` (BACKUP) or `0xAB18` (MEMORY).
   - MEMORY: the covered range includes the 0x80 padding at `0xA180`. Keep that
     padding as zeros, although any value works if it is summed.
   - BACKUP: the checksum sits inside region B's last chunk, which the radio
     writes whole to EEPROM `0x1FFFC–F`. That is harmless.
4. **Keep the BACKUP ID block unchanged** at `0x220–0x229`. The model string,
   the `0x02` byte and the region code must match the target radio. Editing the
   region bytes in the file does not change the radio's region, because
   EEPROM `0x21–0x23` is not in the file. It only makes the file load on a
   different radio, and the region-dependent settings image would then be
   applied under the wrong band plan.
5. **Change only what you understand.** Start every edit from a backup the
   radio itself wrote. Keep BCD digits valid, keep CTCSS below 50 and DCS below
   104, and use `0xFF×16` for "no name".

```python
def yaesu_sum(buf, end):          # end = 0x1FDBC (BACKUP) or 0xAB18 (MEMORY)
    s = sum(buf[:end]) & 0xFFFFFFFF
    buf[end:end+4] = s.to_bytes(4, "big")
```

## 6. What a PC program must not do

- **Do not rely on the checksum as a safety net.** The radio writes the whole
  file into EEPROM before it compares the sum. A wrong sum does not reject the
  file cleanly; it ends in a reboot with the `"MARU"` marker and a reset to
  defaults.
- **Do not produce out-of-range values.** Nothing is range-checked on restore:
  not tone and DCS indexes, not BCD digits, not bit fields. A tone index above
  49 makes `sub_34BCA` read past the tone table. That gives a wrong tone, not
  code execution. The data never reaches a code region.
- **Do not write the QSO store files.** Their allocation-table semantics are not
  mapped.
- **Do not swap the card while the radio is on.** The size check (the stat
  request) runs when the SD function starts, and its result is cached in
  `0xFFBA41`/`0xFFBA42`. Replacing the card while the radio is running can
  leave those flags stale; this is inferred. Insert the card with the radio
  powered off.

## 7. Open items

1. **Channel bit fields.** The meanings of `+0x00`, `+0x01`, `+0x05`, `+0x1D`,
   `+0x1E` and `+0x1F` (mode, step, shift direction, power, tone mode, skip,
   and so on). Resolve by diffing radio-written files, or by tracing the users
   of `VFO+0x14/+0x15/+0x16/+0x19/+0x34–0x39`.
2. **Slot map.** How slots 0–1099 map to user channel numbers (M001–M900, PMS,
   the remaining slots); what the per-slot byte at `0x12C0` and the u16 at
   `0xA280` mean; and whether the `0x0000` region really holds 24 bank lists.
3. **Name character set** and the meaning of the `+0x06` attribute word.
4. **QSO store.** Allocation-chain rules, the 0x50-byte message record, and the
   `0x40000000` offset flag.
5. **SUB side.** The exact string concatenation (`"\"` plus name) and the full
   operation-code semantics in the SUB file server (`0xFFF3C5xx` dispatcher,
   request table `0x683D0`). These affect the transport, not the file format.

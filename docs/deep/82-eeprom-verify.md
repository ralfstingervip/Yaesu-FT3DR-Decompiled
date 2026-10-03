# EEPROM storage-driver verification (Lane J14)

> Lane J14, model `claude-opus-4-8`. Private DB `J14_EEPROM`, seeded
> `--copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64`, used strictly read-only
> through `ida\jobs\j14_eeprom_verify.py` (`h8sxa`, one pass, no DB edits). Image
> `decrypted\FT3D_MAIN_ver102_EXP.bin`, base 0 so file offset = address, big-endian.
> All work static. No image modified, no radio touched, no other DB opened. The
> closed window `0x078106`–`0x07B753` was never dumped. Per-claim byte table:
> `ida\out\eeprom-verify\j14_verify_table.tsv`; xrefs `j14_xrefs.tsv`; call-site
> reachability `j14_callsite.tsv`; disassembly `j14_dis_*.txt`.
>
> Verify-only lane: this is a plain non-volatile settings store. No pairing of
> settings with market/region keys, no lockout/security analysis, no service
> window. Nothing drifted out of scope.

## Verdict

**All four of I16's reported-but-unverified findings are Confirmed from the bytes;
two carry a small naming correction, none is refuted.** MAIN has two independent,
disjoint non-volatile storage drivers. `sub_3BDAC` is a bit-banged **I2C** master
on one GPIO port (`0xFFFBA0`/`0xFFFBA4`/`0xFFFBA8`), talking to a >64 KB serial
EEPROM with device bytes `0xA2`/`0xA3` and 17-bit addressing (block-select bit +
two address bytes) — this is the driver behind the `0x1A080` per-channel cache.
`sub_33532` is a **separate 3-wire (microwire-style) serial device** on a
different set of port registers (`0xFFFF4A` in, `0xFFFF5A`/`0xFFFF5C` out,
`0xFFFB8A` direction); its two call sites are exactly as reported — `0x77DB2` is
an orphan not attached to any function (unreached), `0x77DF6` is inside the live
`sub_77DB8`. `sub_5E96A` packs the DG-ID working word (fed from the `0x1A080`
cache) with a second field into a 32-bit value and stores it; the store/field
math checks out. `sub_3C668` is a 64-byte-page I2C writer with **no caller**:
whole-image IDA xref and a raw byte scan both find zero references except the
routine's own retry self-loop. The two naming points: the specific H8S *port
letters* ("port H" for the I2C, "B/D" for the 3-wire) are not pinnable from this
package — only the register addresses are — and `sub_5E96A` reaches the `0x1A080`
cache one hop removed, through the RAM working words `0xFF8ED6`/`D7` and
`0xFF8ED8`/`D9` that cache reader `sub_3DF1C` populates (per I9), not by touching
`0x1A080` or `0xFF476E` directly.

## Method

- Direct byte reads from the image in Python for every cited address (file
  offset = mapped address).
- One read-only IDA `h8sxa` pass on `J14_EEPROM` (seed `MAIN_FINAL2`):
  whole-image `XrefsTo` for `0x3BDAC`, `0x33532`, `0x3C668`, `0x5E96A`,
  `0x3C378`, `0x3BF4C`; containing-function + code-xref count for call sites
  `0x77DB2`/`0x77DF6` and for `sub_3C668`; full disassembly of `sub_33532`,
  `sub_5E96A`, `sub_3C668` and the caller region `0x77D80`–`0x77E40`.
- Cross-check byte scan of the full 1 MB image for the absolute forms that could
  reference `0x3C668`: `jsr @aa:24` (`5e 03 c6 68`), `jmp @aa:24` (`5a 03 c6 68`),
  and a BE32 pointer (`00 03 c6 68`). All three = 0 hits.
- `sub_3BDAC`/`sub_3C378`/`sub_3C3C6` disassembly was taken from I16's own dump
  (`ida\out\eeprom-map\work\i16_dis_039000.txt`) and re-anchored to raw image
  bytes; it was not re-dumped. Could-not-do: confirm the physical port *letters*
  — the exact H8SX part is still open (BRIEF correction 2), so only register
  addresses are asserted.

## Findings

### Claim 1 — `sub_3BDAC` bit-banged I2C — CONFIRMED

The routine reads a shadow at `0xFF816E`, calls `sub_3C378` (START + write device
byte + two address bytes), then clocks and reads `r6` bytes into `@er1+`. Port
accesses, all against one GPIO port:

- `0x3BDB4` `6a 18 fb a4 70 00` → `bset #0,@0xFFFBA4` — SDA drive (bit 0).
- `0x3BDCE` `bset #1,@0xFFFBA4` / `0x3BDE8` `bclr #0` / `0x3BE02` `bclr #1` — SCL
  clock (bit 1) and SDA toggling.
- `0x3BE4E` `6a 10 fb a0` → `bld #0,@0xFFFBA0` — SDA sense (input).
- `0x3BE84` `6a 8a fb a8` → `mov.b r2l,@0xFFFBA8` — output latch.
- `0x3C3E2` `6a 18 fb a4 67 00` → `bst #0,@0xFFFBA4` — shift carry out onto SDA in
  the byte transmitter `sub_3C3C6`.

Device bytes: `0x3C3AC` `fd a2` (`mov.b #0xA2` write) and `0x3BE1C` `fd a3`
(`mov.b #0xA3` read). Bit 1 of the device byte is the block-select (A16); with two
following address bytes (`r0h`, `r0l` sent at `0x3C3B4`/`0x3C3BC`) that is 17-bit
addressing of a >64 KB device. Bank 0 uses `0xA0`/`0xA1` elsewhere (I9), so `0xA2`/
`0xA3` is the upper bank — which is where the `0x1A080` channel cache lives.
`sub_3BDAC` has 32 callers (all `jsr …:24`), all in the `0x3C`–`0x3D` and
`0x73`–`0x74` settings regions; none touch USB. The write twin is `sub_3BF4C`
(31 callers).

*Naming correction:* registers `0xFFFBA0`/`A4`/`A8` are confirmed; the "port H"
label is not verifiable from this package (Inferred).

### Claim 2 — `sub_33532` separate 3-wire device — CONFIRMED

Distinct register set, disjoint from the I2C port, so this is a different device
on different pins:

- `0xFF5C` bit 7 — chip-select/enable: `0x33536` `7f 5c 72 70` `bclr #7` (assert),
  `0x335BC` `7f 5c 70 70` `bset #7` (release).
- `0xFF5A` — serial clock bit 1 (`bset`/`bclr #1` in both shift loops) and
  data-out bit 0 (`0x33554` `7f 5a 67 00` `bst #0`).
- `0xFF4A` bit 0 — data-in: `0x335A4` `7e 4a 77 00` `bld #0` → `rotxl.w r3`.
- `0xFFFB8A` — data-line direction, written from shadow `0xFF816D`
  (`0x33580`/`0x335D0` `6a 8c fb 8a`).

Sequence: shift a command out of `@0xFFBC66<<10` (9-bit loop, `r6l=9`), then shift
16 bits in (`r6l=0x10`) building `r3`, stored `0x335B8` `mov.w r3,@0xFFBC68`. That
is a classic microwire 16-bit read (93C-series shape). The register set is
disjoint from `sub_3BDAC`'s `0xFFFBA0/A4/A8`, confirming a **separate** device and
a **separate** protocol (3-wire, not I2C).

Callers (IDA `XrefsTo`, exactly two): `0x77DB2` `5e 03 35 32` is **not inside any
function** (orphan fragment 6 bytes before `sub_77DB8`) → unreached, as reported;
`0x77DF6` `5e 03 35 32` is inside `sub_77DB8`, which has 9 code xrefs → live, as
reported.

*Naming correction:* the "port B/D" letters are Inferred; only the register
addresses above are Confirmed.

### Claim 3 — `sub_5E96A` DG-ID RX/TX field pack — CONFIRMED

```
05E96A 6a 04 8d d8   mov.b @0xFF8DD8,r4h
05E96E 6a 0c 8d d9   mov.b @0xFF8DD9,r4l
05E972 0d 4c         mov.w r4,e4            ; er4 high word = {8DD8,8DD9}
05E974 6a 10 8e a0 73 60  btst #6,@0xFF8EA0 ; RX/TX select
05E97A 47 0a         beq  0x5E986
05E97C 6a 04 8e d8   mov.b @0xFF8ED8,r4h    ; TX DG-ID working word
05E980 6a 0c 8e d9   mov.b @0xFF8ED9,r4l
05E984 40 08         bra  0x5E98E
05E986 6a 04 8e d6   mov.b @0xFF8ED6,r4h    ; RX DG-ID working word
05E98A 6a 0c 8e d7   mov.b @0xFF8ED7,r4l
05E98E 01 00 6b 84 b0 5a  mov.l er4,@0xFFB05A ; packed 32-bit store
05E994 79 0b f3 65   mov.w #0xF365,e3
05E998 5e 00 99 22   jsr  sub_9922          ; format/emit with id 0xF365
```

Field math: `er4 = (word@0xFF8DD8:D9) << 16 | (DG-ID word)`, where the low word is
the **RX** working word `0xFF8ED6`/`D7` or the **TX** working word `0xFF8ED8`/`D9`,
selected by **bit 6 of `0xFF8EA0`**, stored as a single `mov.l` to `0xFFB05A`. The
tail (`0x5E99E`–`0x5E9AE`) reads `0xFF3D95` and rewrites it as 1 or 2 — a small
state flag, not part of the pack. `0xFF8ED6`/`D7` and `0xFF8ED8`/`D9` are exactly
the per-channel working words that cache reader `sub_3DF1C` loads from the
`0x1A080` EEPROM cache (I9), so the `0x1A080 → DG-ID field` claim holds, one hop
removed; `sub_5E96A` does not read `0x1A080` or RAM cache `0xFF476E` directly.
Reached via a function-pointer `.long sub_5E96A` at `0x007910` (dr_O xref).

### Claim 4 — `sub_3C668` multi-page writer has no caller — CONFIRMED

`sub_3C668` reads the shadow `0xFF816E`, sets `r6 = 0x40` (64-byte page), calls
`sub_3C378` (START + device + address), and shifts bytes from `@er1+` out onto
`0xFFFBA4` bit 0 (`bst #0`) — a 64-byte I2C page write on the same port as
`sub_3BDAC`. IDA whole-image `XrefsTo(0x3C668)` returns exactly **one** edge:
`0x3C996` `bne sub_3C668:16`, the routine's own retry self-loop back to its entry.
The byte scan over the full 1 MB image finds **0** of `5e 03 c6 68` (jsr),
`5a 03 c6 68` (jmp) and `00 03 c6 68` (BE32 pointer). No external call, no data
pointer, no fall-through — **no caller**. It is present, correct-looking page-write
code that is never invoked in this image.

## USB relevance

None, and this reinforces I9. Both drivers are ordinary non-volatile settings
storage: `sub_3BDAC`/`sub_3BF4C`/`sub_3C668` are the serial-EEPROM I2C family that
backs the `0x1A080` per-channel cache; `sub_33532` is a separate microwire device
read into `0xFFBC68`. The 32 I2C callers sit in the `0x3C`–`0x3D`/`0x73`–`0x74`
settings code, never the USB module at `0xFFEE00`. The DG-ID pack in `sub_5E96A`
produces a 2-byte-per-field value (DG-ID is 0–99) handed to a formatter/IPC
(`sub_9922`), not a sample or bulk path. Nothing here is a USB, SDR, or DSP
transport. For mission questions 1–3 the answer is unchanged.

## Open

1. Pin the H8SX part so the port *letters* can be named — the register addresses
   (`0xFFFBA0/A4/A8`; `0xFFFF4A/5A/5C` + `0xFFFB8A`) are solid; the letters are
   not. Lowest value; cosmetic.
2. Identify the 3-wire device behind `sub_33532`: a 16-bit microwire read into
   `0xFFBC68` from a command built on `0xFFBC66`. Likely a 93C-series EEPROM or a
   serial pot/ADC. Only `sub_77DB8` uses it live.
3. Why `sub_3C668` (and the orphan `0x77DB2` call to `sub_33532`) exist with no
   live caller — dead factory/manufacturing code is the obvious guess, but not
   proven here. In scope only as "unreferenced", which is confirmed.

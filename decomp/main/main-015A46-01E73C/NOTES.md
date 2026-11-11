# main-015A46-01E73C — notes (wave C)

## What the range is
- **0x015A46-0x0177B8 — setup-menu key and dial handlers.** Generic key handlers (BACK / ENTER / SELECT)
  that drive the menu level `FFAD68`. The entry hook is `sub_15CCE`. The dial dispatcher `sub_15E1E` indexes
  `dial_tbl_12268[id-0x0E]`. After them come about 150 per-item dial handlers, named by screen id and label
  from `ida/out/hidden-settings/screens.tsv`. Most handlers are one of: a step record via `sub_3F600`/`sub_3F628`/`sub_3F62E`
  (`{lo, hi, u8 *}` ROM records), a bit toggle of `FF89BE..FF89C5` through the eight-entry block `0x017760-0x0177A4`,
  or a field of the band record (doc 35 offsets).
- **0x0177B8-0x019158 — APRS/GPS setup editors**: APRS callsign/SSID, the message and auto-reply editors,
  the filter mask, beacon mode (`sub_17A50` maps BEACON TX onto `FF8AAB` b6/b1), SmartBeaconing (lo<hi speed wrap),
  MY POSITION, MY SYMBOL, DIGI PATH, COM PORT and APRS POPUP. They share the character stepper `sub_189B2`
  (an alphanumeric filter, wildcard `'*'` mode, and an empty tail) and the clear/delete helpers.
- **0x019158-0x019A9E — exit (save) handlers.** `sub_19158` runs `0x148A0 + BE16 exit_tbl_19A9E[id-0x0E]`
  when `AA30.6` (value changed) is set. It then resets the menu state and stops any tone search. 119 of the stubs
  are plain `eep_save_rN(n)` / block saves (generated mechanically from the listing, Confirmed).
- **0x019C3A-0x01E73C — VFO/memory/band operations, tuning-step tables, record repack, etc.** Covered in
  the C file. The parts still marked Skeleton are listed below.

## Notable findings
1. The ANTENNA ATT dial (`sub_15F34`) keeps a **per-memory-channel ATT bitmap at `FF8976`** (R1 n=0x56). Its
   exit handler `sub_19426` saves the bitmap. In VFO mode the same dial toggles `rec+0x39.5`.
2. STEP (`sub_1700A`) has two step tables. Stepping onto index 0x0A/0x0B sets the fixed-step gate `+0x39.4`
   (doc 35). On the `rec[4]==0` path the loop stops only on 3, 0x0A or 0x0B.
3. COM PORT OUTPUT (`sub_18B60`) offers an extended choice list (record `0x018BBA`) only when the
   **RAM DISPLAY flag `FF89C4.4`** is set. This is a further user of that hidden bit (doc 49).
4. Screen 0x67's dial toggles **`FF89C4` bit 0** (`sub_16E7E` → `sub_17790`). Doc 35 says b0 has no individual
   reader or toggler. The bnot comes through the shared `0x017790` entry, which the bit-scan of doc 35 missed.
   This **contradicts doc 35** (b0 "Not found").
5. The UI-mode-0x10 digit sequence `08030706` (`sub_19100`) only writes `AAE0 = 0x16`, the tone/prompt mailbox.
   Doc 49's wording "requests UI mode 0x16" is looser than the code.
6. Band bitmap editor for screen 0x79 (`sub_17400`): bit per band in `FF898C`. It refuses to set every bit of the
   slot mask (0x0FE6 band A / 0x0019 B slot) and refuses the band currently in use.

## Left undone
- Functions marked `Skeleton` in functions.tsv carry a header (callees, RAM touched, table slot). Their bodies are TODO.
- Step-record limits are cited by ROM address only, because there is no image in the repo.
- Several cursor/scroll routines (`sub_17B5E`, `sub_17EFE`, `sub_18D74`) are Inferred. Their control flow is
  faithful, but the meaning of the layout records is a guess.

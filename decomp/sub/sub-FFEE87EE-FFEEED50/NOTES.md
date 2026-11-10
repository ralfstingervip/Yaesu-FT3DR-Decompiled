# sub-FFEE87EE-FFEEED50 (SUB, 119 functions)

## What the range is
SUB UI screen handlers for five MAIN->SUB F1xx screens plus the element-redraw machinery of the
operating (frequency) screen:

| range | screen (off_FFED4050 id) | IPC opcode | content |
| --- | --- | --- | --- |
| FFEE87EE-FFEE8AA5 | 0x06 | F106 | F-menu grid, 12 icon cells over the operating area |
| FFEE8AA5-FFEEA1AE | 0x11 | F111 | GPS information page (sky plot, SNR bars, date/time, lat/lon, speed, altitude) |
| FFEEA1AE-FFEEA7DB | 0x08 | F108/F109/F10A, F280 | 16-char text-entry line with blinking cursor + 20 icon slots |
| FFEEA7DB-FFEEAE5E | 0x0F | F10F | four text fields (22/7/17/17 chars) over the operating area |
| FFEEAE5E-FFEEB8E4 | 0x01 | F101 | main operating screen, single band; bottom strip (tone/DCS/APRS/DG-ID) |
| FFEEB8E4-FFEEED50 | shared | - | element event handlers, layout classifiers, 16 position locators |

Every screen is a 4-step machine on 0x8C4C (sync / frame / full draw / event loop) with a per-screen
event table of 64 dirty bits at 0x1D3B0/0x1D3B4 (see the file header for the framework).
Event tables decoded from ida/out/sub-final/raw/apply_pass1_changes.tsv (ptr_dword rows; F101's
FFED54B0..5514 rebuilt from the byte rows of the same file).

## Notable findings
- **F111 is the GPS page**, confirmed byte by byte: sky plot from a 32-sector x 10-ring position table
  (FFC3D3C9), SNR bars for up to 14 satellites with "AS" (PRN 33-64) / "QZ" (PRN 193) labels,
  time zone = menu index, 26 = UTC, 30-minute steps with day carry, speed stored as BCD 0.1 kn
  converted with exact factors (1.852, 1.1507), feet via IEEE double /0.3048. Two-digit-year leap
  test treats 00 as non-leap.
- **ui_screen_type (FFEEC232, doc 31's classifier)** returns the band row from the event being
  serviced: events 0..0x1D -> 1 (upper), 0x1E.. -> 2 (lower), 3 = single row. That is why screen 0
  has two copies of the element handlers (0x0F..0x1F and 0x20..0x2E). 4 only via the 0x12285 override.
- **F101 bottom strip**: shadow[0x5F] mode, 0x65 squelch type (3-char table), 0x66 CTCSS index (<50),
  0x67 DCS index (<104), 0x68 APRS block ("A12"/"A96"), digital modes show two 2-digit values
  0x69/0x6A (Inferred: DG-ID TX/RX).
- The docs' "out of phase" case block of sub_FFEEC0D3 (docs 46/48) decodes correctly here as
  ev_main_area_redraw (FFEEC08D): F1 sub -> main-area drawer table (F100 FFEE86D6 ... F115 FFF453BB).
- Quirks: uninitialised returns in ui_screen_type / ui_icon_layout_index for unmatched opcodes;
  ui_current_record returns NULL (F102, others) and callers dereference it; scr01_ev20 commits even
  when the region could not be opened; ev_elem17 computes a height it never uses;
  gps_draw_altitude_box hard-codes its text position; FFEEC369 is dead.

## Contradictions with existing docs
- doc 12 / pc-04 item 10 cite `sub_FFEEB057` at FFEEB09F as the copy that loads 0x8C4E for the
  DSP-write screen. FFEEB057 is the F101 (screen 1) reconciler and only runs on F101; the copy that
  runs on every screen is the common `sub_FFEF4069` (called e.g. at FFF0CBB8 in the boot-screen
  family). The conclusion 0x8C4E = 0x8E47 stands; the cited site is wrong (Inferred for the
  FFF0CBB8 call chain, not traced).
- 0x8F73 is called "menu cursor index" elsewhere; in these handlers it holds the dirty-event index.
- doc 31 says FFEEC232 returns 1..4; the body returns 1..3, 4 only through the override.

## Left undone
- Field meanings of screen 0x0F and of the 12/20 icon-slot fields (no string anchors here).
- Drawer callees FFEF4FCE..FFEF64D2 (other lanes) named only by address.
- Azimuth unit (0.1 deg) inferred from the 3600 wrap; parser side not re-checked.

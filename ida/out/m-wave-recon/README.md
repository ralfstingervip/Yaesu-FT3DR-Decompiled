# M-wave reconciliation — proposed FINAL7 MAIN masks

Orchestrator output, 2026-10-03. Owner-side static analysis only: no database opened, no image or
published mask modified, nothing written to a radio. Images unchanged (sha256 `8e3ecd05…` / `b93570b3…`).

## Files

| File | What it is |
| --- | --- |
| `m_recon.py` | One run: reproduces FINAL4/5/6 (asserted against the published files), then one folded descent for FINAL7. Run from `ida\out\main-final6\offline\`. |
| `_base.py` | Lane M1's `m1_build_masks.py` up to the FINAL6 named mask (DB checks and writes removed). Executed by `m_recon.py`. |
| `final7_proven_mask.bin` | 365,358 bytes set, sha256 `5585a9c6d810d964…` |
| `final7_named_mask.bin` | 505,165 bytes set, sha256 `0bcf995b1087e723…` |
| `final6-to-final7-diff.tsv` | Every changed run with its reason. |
| `masks-sha256.txt`, `recon_log.txt` | Full hashes and the run log. |

## FINAL7 rules (one descent, fnindex seeds removed, entry points re-validated to a fixpoint)

- **Kept:** L2's er1 callbacks `0x018250` / `0x018ABE` / `0x01A094` and L4's `0x05E8E0`. All four source sites
  (`0x018276`, `0x018AD2`, `0x018BE8`, `0x05E862`) are reached by this descent.
- **Dropped:** `0x066FB4`, `0x067250`, `0x066FBE`, `0x06726A`. Every caller is a dead case arm (M4, doc 116). The
  orchestrator checked the arm structure at `0x06ADE4 0c cb 58 70 00 28 eb 07 5e 06 ac d6 58 00 00 1e`:
  `0x06ACD6` is an ordinary routine (`0f 95 7a 15 …`), not a switch helper. A whole-image scan found no
  rel8/rel16/bsr/BE32/BE24 edge into the arms. All other `jsr` sites to the leaves are not proven.
- **Added, `sub_15260` record rule (M6, doc 118):** every field of every record handed to `0x015260` by a reached
  `mov.l #rec,er5 ; jmp/jsr 0x015260` (17 of 17 records have a reached loader). +390 B, equal to M6's
  core 148 + companion 242. This includes M5's `0x018FAA` chain (doc 117).
- **Added, CDC handler records (M7, doc 119):** the six BE32 handlers at `0x07B4B4 + 10k + 6`. They are walked by
  window ISR `0x07827C`, and the window has been credited since doc 95. +1,726 B.
  M7's further 52 B, `0x0771AE`–`0x0771E1`, are **not** reached: a whole-image scan finds no abs24 call or jump,
  no bsr and no BE32 value pointing to any even address in that range (Not found). They stay named, not proven.
- **Window:** the whole service-window code `0x078106`–`0x078545` (1,088 B = doc 95's 868 + M4's 220) stays proven.

## Ledger

    MAIN proven  364,786 - 1,472 (M2 368 + M3 574 + M4 530) - 72 (leaves) + 390 (M6) + 1,726 (M7) = 365,358
                 = 72.25% of 505,684 content, 93.86% of 389,260 decodable
    MAIN named   501,656 + 3,509 = 505,165 / 505,684 = 99.90%
                 (union of M5 2,880, M6 635 [C-read 310, C-extent 265, code 54, 0x018FAA 6] and M8 27;
                  M5 and M6 share 0x018FAA's 6 B, and M8's 27 B lie inside M6's rows)
    Headline     505,165 + SUB window code 464,263 = 969,428 / 1,029,972 = 94.12%

Held for the owner: the 43 B stale copy `0x069A7F` (M6 identifies it as a byte-shifted copy of `sub_69964`).
Counting it would make MAIN named 505,208 (99.91%) and leave 0 un-nameable bytes. Also held: SUB's headline
convention (M15, doc 127).

## Not yet in a seed DB

`M1_MAIN_FINAL6` matches the FINAL6 masks. A FINAL7 seed has to be built from it as a follow-up job:
- drop the 72 B leaves and the 1,472 B dead runs as proven (they stay named);
- add the 17 record-field and 6 CDC-handler entries;
- retype M2's `0x00932A` and M3's `0x03D1C8` as data;
- apply M5's 136 rows and M6's Confirmed rows.
Then require byte-equality with these two masks.

# FT3DR/FT3DE firmware ver 1.02: static decompile notes

Independent static-analysis notes static-analysis notes, IDA Python scripts, and outputs for the Yaesu FT3DR/FT3DE handheld radio firmware (v1.02).
⚠️ Key Details:
• Scope: Strictly owner-side, passive static analysis.
• Hardware Interaction: None. There is no serial, USB, or radio communication code included.
• Disclaimer: This is an unofficial project with no affiliation to or endorsement from Yaesu.


## The two cores

- **MAIN**: Renesas H8S/2370 family, big-endian. The core is H8SX: instructions that looked
  undecodable at first are H8SX, and IDA's `h8sxa` module decodes them.
- **SUB**: Renesas RX64M, little-endian. The image is mapped at `0xFFC00000`, so
  SUB file offset = address − `0xFFC00000`.

## Coverage

`docs/resume.md` gives the headline under **convention D**, where a byte counts once it is named
or IDA-typed:

- Decompile: **99.9589%** (1,029,549 / 1,029,972 bytes)
- MAIN: **99.916%** (505,261 / 505,684 bytes)

The 423 MAIN bytes that are not counted are classed as Inferred. They are clean data tables that
no code in the image reads.

## Where to start

1. `docs/deep/BRIEF.md`: the orientation brief for both cores.
2. `docs/resume.md`: current state, headline numbers and open questions.
3. `docs/INDEX.md`: an index of every deep write-up in `docs/deep/`.

## Layout

- `docs/deep/`: deep write-ups (numbered 01–142, plus BRIEF, RESUME-FULL, RESUME-DEEP and pc-01..07)
- `docs/`: top-level notes, `docs/usb-lanes/*.tsv`, `docs/agents.md`, `docs/resume.md`
- `ida/*.py`: runner and helper scripts
- `ida/jobs/`: IDA Python job scripts
- `ida/out/<topic>/`: IDA outputs (listings, tables, reconstructed C, coverage masks)
- `publish/`: packaging reports

Release assets: `ft3dr-docs.zip`, `ft3dr-ida-scripts.zip`, `ft3dr-ida-outputs.zip`.

## What is not here

- No firmware image, encrypted or decrypted
- No updater or flashing tool
- No IDA database (`.i64` / `.idb`)
- No radio write path of any kind

The scripts expect the decrypted image and the IDA databases, and neither is shipped. Treat the
scripts as reference material. They will not run as-is.

See `NOTICE.md`.

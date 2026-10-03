# FT3DR ver 1.02 compilers

The two radio images were compiled with Renesas compilers. Neither image stores a compiler version or the name of the IDE. Nothing here writes to a radio.

## Result

| Image | Part | Compiler |
| --- | --- | --- |
| MAIN EXP 1.02 | H8S/2370 | Renesas C/C++ compiler for the H8S, H8 family |
| SUB ALL 1.02 | RX64M | Renesas CC-RX, the RX Family C/C++ compiler |

The Windows updater is a different program. Its PDB path is a Visual Studio `vsinstall` build, recorded in `firmware-decryption.md`. That build is the flasher, not the compiler that produced either radio image.

## SUB, CC-RX

The standard-library sample that CC-RX projects ship as `lowsrc.c` is in the plaintext at file `0x3484B0` (address `0xFFC484B0`).

| File | Bytes |
| --- | --- |
| `0x3484B0` | `ENV1=temp01` |
| `0x3484BC` | `ENV2=temp02` |
| `0x3484C8` | `ENV9=end` |
| `0x3484D1` | the drive-C `stdin` sim-I/O path string, then the mode byte `r` |
| `0x3484DC` | the drive-C `stdout` sim-I/O path string, then the mode byte `w` |
| `0x3484E8` | the drive-C `stderr` sim-I/O path string |

Those three `ENV` strings are the sample `environ` table in `lowsrc.c`. The drive-C `stdin` / `stdout` / `stderr` path names are the `freopen` paths from the same file, with the `"r"` and `"w"` mode literals packed beside them.

Reset at `0xFFC00000` is that package's `resetprg.c` routine `PowerON_Reset_PC`:

```text
FFC00000  mvtc    #6A8FCh, usp
FFC00007  mvtc    #6B8FCh, isp
FFC0000E  mov.l   #off_FFFFFF80, r14
FFC00014  mvtc    r14, extb
FFC00017  mov.l   #off_FFED8A70, r14
FFC0001D  mvtc    r14, intb
FFC00020  mov.l   #100h, r14
FFC00024  mvtc    r14, fpsw
FFC00027  bsr.a   sub_FFF45DBC
FFC0002B  nop
FFC0002C  mov.l   #10000h, r14
FFC00031  mvtc    r14, psw
FFC00034  mov.l   #0, r1
FFC00036  bsr.a   sub_FFF36C53
FFC0003A  brk
FFC0003B  rts
```

`0x100` is the sample `FPSW_init`. `0x00010000` is the sample `PSW_init`. EXTB points at the fixed vector table. INTB points at the relocatable vector table. The routine ends on `brk` and then `rts`, which is what CC-RX emits for `brk()` at the end of `PowerON_Reset_PC`.

CS+ and e² studio both drop this `resetprg.c` and this `lowsrc.c` into a CC-RX project. The image has no string that picks one of those two IDEs.

## MAIN, H8S compiler

The plaintext has no `ENV1=temp01` and no drive-C `stdin` path string, so this image was linked without that sim-I/O sample. It also has no `GCC:`, IAR, or Renesas version string.

Of the 1298 recovered functions, 108 begin with one instruction and return through its pair:

```text
stm.l   er0-er3, @-sp
ldm.l   @sp+, er0-er3
rts
```

Ten more begin with `stm.l er4-er5, @-sp`. That register-window save is the Renesas H8S, H8/300 Series C/C++ compiler, the compiler High-performance Embedded Workshop drives. One example is `0x20EC4`–`0x20F18`. Another is `0x394B4`–`0x394D0`.

Startup at `reset_handler` (`0x2092`) loads the stack with `mov.l #0xFF7F00, sp`, writes the on-chip register page, and calls `sub_20FA`. That function is 850 bytes of immediate stores to absolute I/O addresses and finishes a block copy with `eepmov.w` at `0x243A`.

## What is not in either image

No compiler version, no build path for the compiler, and no IDE name. The `FT3D\GPSLOG` path on drive `I` and the other drive-`I` paths in the SUB image are radio file-system strings, not the machine the firmware was built on.

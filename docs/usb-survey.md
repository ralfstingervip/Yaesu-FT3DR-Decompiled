# FT3DR ver 1.02 USB survey

Owner notes on the official ver 1.02 MAIN and SUB images, plus the USB libraries that ship in those updater packages. The images were already decrypted. This pass did not find a second cipher around a USB block. Nothing here writes to a radio.

## Result

These two application images do not implement an SDR mode or an I/Q stream over USB.

The SUB processor family, Renesas RX64M, includes a full-speed USB controller (12 Mbit/s). In this ver 1.02 SUB image, none of the 455 recovered instructions use an immediate in the USB0 window `0x000A0000`–`0x000A03FF` or in `0x000D0000`–`0x000D7FFF`. The setup labels do not name SDR or I/Q. The USB path in the official update manual is the Renesas boot device used to write Main or Sub firmware.

A band-scope label is present in the same setup table as the ordinary radio settings. That label is the radio's own sweep display.

## Where the dumps are

IDA 9.1 produced these. Launch details are in `docs/agents.md`.

| Job | Input | Database | Functions | Xrefs to functions |
| --- | --- | --- | --- | --- |
| MAIN | `decrypted/FT3D_MAIN_ver102_EXP.bin` | `ida/db/radio/MAIN.i64` | 1298 | 3225 |
| SUB | `decrypted/FT3D_SUB_ver102_ALL.bin` | `ida/db/radio/SUB.i64` | 455 | 2073 |
| RCOMMS | `Firmware/.../RComms.dll` | `ida/db/radio/RComms.i64` | 699 | 2958 |
| RFP | `Firmware/.../RFP_USB_VB.dll` | `ida/db/radio/RFP_USB_VB.i64` | 233 | 406 |

Each job folder under `ida/out/survey/` holds `functions.tsv`, `xrefs.tsv`, `summary.txt`, and `insn_scan.txt` for the two radio images. SUB also has `menu_slots.tsv` (120 setup labels) and `vectors.tsv`.

The updater databases `ida/db/FT3D_MAIN.i64` and `FT3D_SUB.i64` are the Windows updaters from the earlier cipher pass. They were not rebuilt.

## The two processors

The updater strings name the parts. MAIN's updater talks about `H8S/2370`. SUB's updater talks about `RX64M` (`RX64M wait endian`, `RX64M wait erase`, and the rest of that set). IDA confirmed both.

### MAIN, H8S advanced

Processor module `h8s300a`. The file is 1,048,576 bytes. Use ends at `0x80000`. The rest is zero. All 1298 functions sit below `0x80000`. The image base is `0`. The vector table is 256 big-endian dwords. Vector 0 and the shared handler land at `0x2092`. Vector 7, the NMI slot on this family, lands at `0x267C`.

Startup at `reset_handler`:

```text
00002092  mov.l   #0xFF7F00, sp
00002098  bclr    #5, @0xFFFFAA31:16
0000209E  mov.b   #0, r4l
000020A0  mov.b   r4l, @0xFFFF8004:16
000020A4  jsr     sub_20FA:24
```

`0xFF7F00` is the initial stack, at the top of on-chip RAM. The following instructions are 16-bit absolute accesses in the on-chip register page. There is no USB register block in this image, and there is no `usb` string.

At file `0xC4B2` and `0xC4CC` the bytes are the fragment `!sdr\b`, beside the same shape of fragment `!cdr\b`, inside a binary table. `(In Service)` at `0x4C52A` is an APRS comment string.

### SUB, RX64M

Processor module `rx`. The file is 4,194,304 bytes, mapped at `0xFFC00000` so that it ends at `0xFFFFFFFF`. The last dword, at `0xFFFFFFFC`, is `0xFFC00000`, the reset address. The other fixed-vector slots share a handler near `0xFFF47E3E`.

Startup at `reset_handler`:

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
```

User stack `0x6A8FC` and interrupt stack `0x6B8FC` sit in the on-chip RAM window. `EXTB` points at the fixed vector table. `INTB` points at `0xFFED8A70` (file `0x2D8A70`). The first call leaves the stub for `sub_FFF45DBC` in the dense region. The stub later executes `brk` and `rts`.

Of the 455 functions, 1 is in the first 256 KB, 33 are in the resource span, and 421 are in `0xFFEE0000`–`0xFFF50000`. The head of the file is mostly the startup stub, a short pad, and the `$PMTK` GPS sentences. The middle of the file is display resources. This list is the set IDA recovered from reset, the fixed vectors, and the calls those reach.

## What the update manual says about USB

`Firmware/FT3DR_DE_MAIN_SUB_Firmware_Ver_Up_Manual_ENG_2206-B.pdf` (20 pages).

The version screen shows Main, Sub, and DSP. This package updates Main and Sub. It has no DSP image. Main firmware follows the destination on the box. Sub firmware is one file for every destination. The program switch behind the DATA jack has three positions: up for Main write, down for Sub write, center for normal operation. Both writes use the supplied USB cable and the same USB driver. The driver installs from the updater's USB Driver Install button. Device Manager is expected to show `Generic Boot USB Direct` under Renesas USB Development Tools. The manual's screen on page 15 shows `VID_045B&PID_0025`. The manual says `Renesas USB1653 USB Boot Mode Device` means the wrong driver was bound.

The pictures show blank COM-port and baud boxes. The text never tells you to set them. Camera, Bluetooth, SDR, debug, and test mode are absent from this manual.

`HMSEUSBDRIVER.exe` is the Renesas USB development-tools driver installer named by that manual. It is the same file in both packages.

## Programming libraries in the packages

`RComms.dll` and `RFP_USB_VB.dll` are byte-identical across the MAIN and SUB packages. They are ordinary PE files. IDA loaded `RComms.dll` as 32-bit x86 (`pc`). It loaded `RFP_USB_VB.dll` with the `cli` loader; the named methods are still in `functions.tsv`.

`RComms.dll` exports the E8A USB class used to find a device, open it, and move bytes. It also exports the programming and trace entry points that belong to that library:

| Group | Export names |
| --- | --- |
| E8A USB class | `Connect`, `ScanBus`, `ScanPorts`, `Read`, `Write`, `SendCommand`, descriptor and pipe helpers |
| HUDI / SCI | `HUDI_SERIALREAD`, `HUDI_SERIALWRITE`, `HUDI_SINGLEREAD`, `HUDI_SINGLEWRITE`, `H_UDI_TX`, `H_UDI_RX`, `H_SCI_RX` |
| ULE programming | `ULE_Identify`, `ULE_Initialise`, `ULE_ConnectDevice`, `ULE_ReadMemory`, `ULE_WriteMemory`, `ULE_FillMemory`, `ULE_SendData`, `ULE_ReciveData`, `ULE_TestConfiguration` |
| Download | `FIRM_Download`, `FPGA_Download`, `ProgDownload`, `AdapterProgramDownload` |
| Trace and status | `AUD_TraceRead`, `AUD_EventSetCh`, `CPU_StatusRead`, `E7_ReadMemory`, `E7_WriteMemory`, `MonpOpen` |

Addresses and sizes are in `ida/out/survey/RCOMMS/functions.tsv`. `ULE_ReadMemory` is 2609 bytes at `0x1000C5F0`. `ULE_TestConfiguration` is a 3-byte export at `0x10017360`.

`RFP_USB_VB.dll` is the updater's USB interface. The recovered methods include `Open_RE`, `Close_RE`, `ReadData_RE`, `WriteData_RE`, `CRFP_USB_MyIF.Open`, `SetTimeout`, `SetBaudrate`, `LoadUSBDriverLibrary`, and `CUSB_Operation` open, connect, read, and write. The PDB path inside the file is a drive-C vendor sample build path ending in `USB_BOOT_Sample\bin\Release\RFP_USB_VB.pdb`.

## Setup labels in the SUB image

From file `0x3DF4D` through `0x3E8D4`, labels are stored on a 20-byte stride. 120 of those slots contain text. The full list is `ida/out/survey/SUB/menu_slots.tsv`. The same table holds the ordinary setup names (SQL, GPS, APRS, Bluetooth, band scope, password, software version) and the labels below.

| File | Address | Label |
| --- | --- | --- |
| `0x3E5C9` | `0xFFC3E5C9` | `COM PORT SETTING` |
| `0x3E709` | `0xFFC3E709` | `USB CAMERA` |
| `0x3E71D` | `0xFFC3E71D` | `Bluetooth` |
| `0x3E759` | `0xFFC3E759` | `RAM DISPLAY` |
| `0x3E7D1` | `0xFFC3E7D1` | `LOCATION SERVICE` |
| `0x3DF75` | `0xFFC3DF75` | `BAND SCOPE` |

`USB CAMERA` sits between `FORMAT` and `Bluetooth`. `RAM DISPLAY` sits between `Bluetooth Save` and `CALLSIGN`. The recovered functions do not reference these strings by address, which fits a table walked by index. The update manual does not describe `USB CAMERA` or `RAM DISPLAY`.

A second pool around file `0x34A800` repeats many of the same words as display messages (`USB`, `Bluetooth`, `Connected`, `FIRM ERROR`, `EMERGENCY`). `In Service` there is the APRS status phrase.

`$PMTK` sentences at the start of the SUB image, and again near file `0x3483E8`, are MediaTek GPS commands. The `FT3D\GPSLOG` path on drive `I` at file `0x34AD6F` is a path string left in the image.

## Re-run

```text
python "ida/run_survey.py" RCOMMS
python "ida/run_survey.py" RFP MAIN SUB
python "ida/run_open.py" MAIN SUB
```

`run_survey.py` replaces only the named database under `ida/db/radio/`. `run_open.py` reopens an existing radio database and rewrites `insn_scan.txt`. `run_ida.py` still rebuilds the updater databases and is the cipher pass, not this survey.

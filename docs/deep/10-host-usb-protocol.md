# Host-side USB and the FT3DR/DE update wire protocol

Agent HOST-USB. Static analysis of the Windows side of the ver 1.02 update
packages. No device was touched, nothing under `Firmware\` was modified, and no
vendor executable was run.

## Verdict

**The radio has two entirely separate USB identities, and this package only
contains software for one of them.** MAIN-side agents have byte-verified two
application-firmware USB device stacks in the H8S image under Yaesu's own vendor
ID — `26AA:0001` (vendor class, EP1 OUT bulk + EP3 IN interrupt, vendor requests
`0x41D1`/`0x41D2`/`0x41D3`/`0xC1D4`) and `26AA:0020` (CDC-ACM, EP1 OUT + EP2 IN
bulk + EP3 IN interrupt). **Nothing in this update package references `26AA` at
all** — I searched all five host binaries and all four INFs as text and as binary
VID/PID pairs and found zero, and the driver package binds only the seven
`045B` Renesas IDs. So the application-mode interface is driven by *other*
software that is not shipped here (Yaesu's PC programming application), and
everything in this package concerns the *other* identity: the hardware-gated boot
device.

That boot device's cable carries a **Renesas serial boot-mode byte stream
tunnelled over a bulk USB pipe**, and nothing else. The USB device is Renesas's,
not Yaesu's: `VID_045B&PID_0025`, `Generic Boot USB Direct`, bound by Renesas's
own kernel driver `HmseUsb.sys` and opened as `\\.\HmseUsb<n>` with
`GENERIC_READ|GENERIC_WRITE`, `FILE_FLAG_OVERLAPPED|FILE_FLAG_NO_BUFFERING`.
Transfers are plain `ReadFile`/`WriteFile` on **bulk IN endpoint 1 (0x81) and
bulk OUT endpoint 2 (0x02)**, with a third IN pipe (0x83/0x84) for status; no
WinUSB, no CDC, no serial class. (There *is* a control-transfer path — IOCTL
`0x80002010` takes a literal 8-byte USB SETUP packet — but the host software only
ever issues one vendor request through it, and only for an E8a PID; see §9.) The
bytes inside the pipe are the target MCU's own boot-mode protocol: for MAIN the
Hitachi/Renesas **H8S** command set (`0x20`, `0x10`, `0x21`, `0x11`, `0x27`,
`0x3F`, `0x40`, `0x60`, `0x48`, `0x58`, `0x43`, `0x4B`, `0x50`, `0x55`, `0x06`),
programming **8192 bytes per command `0x50` at a 24-bit big-endian address**, 128
blocks covering `0x000000`–`0x0FFFFF`; for SUB the Renesas **RX** command set
(`0x00`, `0x13`, `0x36`, `0x38`, `0x4D`, `0x50`, plus `0x81`-prefixed data
packets) in `SOD|LNH|LNL|CMD|data|SUM|ETX` frames, programming **1024 bytes per
packet** over the declared range **`0xFFC00000`–`0xFFFFFFFF`**. **The shipped
protocol cannot read the radio's flash.** Neither state machine implements a
memory-read command; verification is a device-returned checksum (`0x4B` on H8S,
`0x4D` on RX), never a read-back. A read-memory capability *does* exist in
`RComms.dll` — `ULE_ReadMemory` sends E8a command `0x80070000` with an address,
a 16-bit count and an access width, and `ULE_WriteMemory`/`ULE_FillMemory` are
its siblings — but that entire family is **unreachable from the shipped
updaters**: neither EXE calls any `ULE_*`, `E7_*` or `HUDI_*` export, and the
PIDs those routines are wired for (`0x8233`, `0x8236`, `0x823F`) are E8a/E10A
emulator IDs, not the radio's. The other live-but-unreachable path is a complete
**COM-port transport**: both EXEs contain a full `\\.\COMn` implementation
(`CreateFileA`, `SetCommState`, 110–115200 baud, 7/8 data bits, parity, stop
bits, called with 19200 8N1) selected by a single dword in the encrypted update
descriptor, and the dialog's COM-port and baud-rate combo boxes — the blank boxes
in the manual's screenshots — are populated with `COM1`–`COM256` and
115200…2400 bps and then explicitly disabled. Flip that dword and the same
protocol runs over a real serial port. Net result for the boot identity: **a
write-only flash programmer for two address ranges, present only while the
program switch is off-centre, with no read and no streaming.** It remains the
*only* firmware-programming route, because MAIN's application firmware has been
confirmed unable to write its own flash. What the application-mode `26AA` device
can reach is a different question with a different answer, and it belongs to the
MAIN-side agents — but I can say that no host-side software for it exists in this
package, so its protocol cannot be cross-checked from here.

## Method

New IDA job script `ida/jobs/host_pe.py` — a generic x86 PE pass that
dumps functions, exports, imports, strings, string cross-references, and a
Hex-Rays decompilation of every function. Run through `run_job.py` on four
private databases:

| Database | Input (copied to scratch, originals untouched) | Result |
| --- | --- | --- |
| `HOST_USB` | `RComms.dll` | 699 functions, **698 decompiled**, 1 fail |
| `HOST_USB_RFP` | `RFP_USB_VB.dll`, forced `-T"Portable executable"` | 203 functions, 202 decompiled |
| `HOST_USB_UPDM` | `FT3D_MAIN_ver102(EXP).exe` | 1247 functions, 1242 decompiled |
| `HOST_USB_UPDS` | `FT3D_SUB_ver102(ALL).exe` | 1279 functions, 1274 decompiled |

Output under `ida/out/host-usb/{RComms,RFP_PE,UPD_MAIN,UPD_SUB}/`
(`functions.tsv`, `exports.tsv`, `imports.tsv`, `strings.tsv`, `data_xrefs.tsv`,
`decomp.c`, `decomp.log`).

The earlier survey loaded `RFP_USB_VB.dll` with IDA's `cli` loader, which is why
it looked opaque. **It is not a managed-only assembly — it is a mixed-mode
C++/CLI MFC extension DLL** (`COMIMAGE_FLAGS_NATIVE_ENTRYPOINT` only,
`<CppImplementationDetails>`, `gcroot<System::String^>`, MFC `CStringT`). Forcing
the PE loader gave real C for the native half. The managed half was recovered by
writing a CLI metadata reader from scratch (`clir.py` in scratch): it parses
`#~`, `#Strings`, `#US`, `TypeDef`, `MethodDef`, `MemberRef`, `ModuleRef`,
`ImplMap` and `FieldRVA`, and disassembles IL bodies with token resolution. No
.NET decompiler is installed and `dotnet` is not present.

The manual is an **AES-128 (AESV2, R4/V4, `/P -1340`) encrypted PDF** with an
empty user password, so every content stream and every object stream is
ciphertext. No PDF library is installed, so the extractor was written too
(`pdftext3.py`): standard-security-handler key derivation (Algorithm 2, 50 MD5
rounds), per-object `key‖objnum‖gen‖sAlT` keys, AES-CBC, then FlateDecode, PNG
predictors, object-stream expansion, `ToUnicode` CMaps and the page tree. All 20
pages are recovered verbatim in
`ida/out/host-usb/manual-ver-up-2206B.txt`.

`HMSEUSBDRIVER.exe` is an InstallShield 12 single-file setup. Its four INF files
are stored as plain text and were carved out to
`ida/out/host-usb/inf/inf0..inf3.txt`. **Scope limit:** `HmseUsb.sys`
itself lives inside the InstallShield-format `data2.cab` (625,624 bytes, `ISc(`
container) embedded in the EXE; I could not decompress it (no 7-Zip, no
InstallShield tooling, and a zlib/raw-deflate brute-force scan over the archive
region found no PE). So the driver's own IOCTL dispatch and its URB construction
are **not** examined here; everything stated about pipes and endpoints comes from
the user-mode side of that interface, from `RComms.dll`.

Tables and artefacts written under `ida/out/host-usb/`:

| File | Contents |
| --- | --- |
| `endpoints.tsv` | the USB transport layer: device node, IOCTLs, pipes, endpoint addresses, packet sizes, timeouts, and the serial alternative |
| `commands.tsv` | every protocol command byte, all four command sets, with reachability |
| `vidpid.tsv` | the complete VID/PID list from the driver INFs |
| `update-info-descriptor.tsv` | the plaintext `RES_UPDATE_INFO` trailer, field by field, for both images |
| `manual-ver-up-2206B.txt` | all 20 manual pages, verbatim |
| `inf\inf0..inf3.txt` | the four carved INF files |
| `rfp_usb_vb_metadata.txt` | full CLI metadata dump of `RFP_USB_VB.dll` (TypeDefs, MethodDefs, ImplMap, MemberRefs, `#US`) |
| `tools\pdftext3.py` | the AES-PDF text extractor, in case anyone needs another encrypted Yaesu PDF |
| `tools\clir.py` | the CLI metadata + IL reader |
| `tools\pedump.py` | PE section / VA-to-file-offset dumper |
| `{RComms,RFP_PE,UPD_MAIN,UPD_SUB}\` | per-binary `functions.tsv`, `exports.tsv`, `imports.tsv`, `strings.tsv`, `data_xrefs.tsv`, `decomp.c`, `decomp.log` |

## Findings

### 1. The software stack, settled

The updater does **not** import `RComms.dll` — neither EXE's import table
mentions it. The chain is three deep and the middle link was the missing piece:

```
FT3D_xxx_ver102(...).exe          Yaesu "yminstall.exe" 1.3.5.0, MFC, statically linked
  |  LoadLibraryA("RFP_USB_VB.dll")            UPD_MAIN 0x4048A0 -> 0x402900
  |  GetProcAddress: Open_RE, GetConfigInfo_RE, SetTimeout_RE,
  |                  WriteData_RE, ReadData_RE, Close_RE   (stored at this+8..28)
  v
RFP_USB_VB.dll                    Renesas "Generic USB Driver ( for Visual Basic)"
  |                               1.03.01.00, (C) 2012, PDB <drive C>\USB_BOOT_Sample\...
  |  managed class CRFP_USB_MyIF::LoadUSBDriverLibrary (IL, rva 0x2398):
  |      LoadLibraryW(L"RComms.dll")   string at 0x10005610
  |      GetProcAddress(h, "QueryInterface")  string at 0x10005628
  |  then calli through the returned COM vtable (IHCommsDevice3 / IHPort / SPortProps)
  v
RComms.dll                        "Renesas Communications Driver", LibraryVersion 1000
  |  E8A_USB::OpenInstance -> CreateFileA("\\.\HmseUsb%d", ...)
  |  E8A_USB::Read/Write  -> ReadFile/WriteFile, overlapped
  v
HmseUsb.sys                       Renesas kernel driver, class RenesasUSB
  v
USB bulk pipes  ->  VID_045B PID_0025 "Generic Boot USB Direct"
```

Managed surface recovered from the metadata (`MethodDef` table, all IL):

* `CRFP_USB_MyIF`: `Register`, `QueryInterface`, `AddRef`, `Release`, `Open`,
  `Close`, `SetTimeout`, **`SetBaudrate`**, `ReadData`, `WriteData`,
  `WriteAndReadData`, `GetConfigInfo`, `LoadUSBDriverLibrary`.
* `CUSB_Operation`: `OpenLink`, `Connect`, `GetAvailablePort`, `CloseLink`,
  `ReadBuffer`, `WriteBuffer`, `SetConfigString`, `GetConfigString`,
  `GetConfigItem`.
* `CRFP_USB_Component`, `CDLLContext`, `CRFP_USBApp`. Native C++ types declared
  through `NativeCppClassAttribute`: `IHCommsDevice3`, `IHPort`, `SPortProps`
  (the RComms-side COM interface it consumes), plus RTTI for the COM interfaces
  it *implements*, `IF_Component` and `IF_Driver_COM`
  (`??_R0?AUIF_Driver_COM@@@8`), and `IF_MainFrameAddin` / `IF_MainFrameOutput`
  — the Renesas Flash Programmer plug-in interfaces. `RComms.dll` provides the
  matching side through its two non-C++ exports, `LibraryRegister`
  (`0x10018354`) and `QueryInterface` (`0x10018371`), with
  `LibraryName` = `Renesas Communications` (`0x10022DB4`),
  `LibraryType` = `Driver` (`0x10022DCC`), `LibraryVersion` = 1000, and the
  banner `Renesas Technology Communications DLL V%lu.%lu.%lu %s %s`
  (`0x10022690`).
* Configuration strings (UTF-16, in the native `.rdata`):
  `<INTERFACE|USB><BUSID|0>` (the default), keys `BUSID` / `PRODUCT`, connection
  string format `USB|Busid:%s|Product:%s`, and the log lines
  `Loaded RComms.dll` / `Unloaded RComms.dll` /
  `RComms.dll not found or incorrect version of DLL` / `USB Open error` /
  `USB connection timed out` / `Failed to write the data` /
  `No data port is Available!` / `Error in getting of configuration`.
* `ja-JP\RFP_USB_Res.dll` — a Japanese resource DLL referenced but not shipped.

The `<INTERFACE|USB>` token is the tell: `RComms.dll`'s own configuration parser
(`sub_100068A0`) also accepts `SERIAL` and `BAUD` and emits
`Failed to set baudrate to "%s"`, `Expecting "BAUD"`,
`Failed to create Serial device interface`, `Serial device "%s" open at baud rate %lu`.
`RComms.dll` is a dual USB/serial transport library; only the USB half is used.

### 2. Endpoints, pipes and transfer sizes — confirmed

Full table in `ida\out\host-usb\endpoints.tsv`. The load-bearing items:

* **Device node** — `RComms.dll` `0x1000ABF0`:
  `sprintf(buf, "\\\\.\\HmseUsb%d", n); CreateFileA(buf, 0xC0000000, 0, 0, 3, 0x60000080, 0)`.
  `0x60000080` = `FILE_FLAG_OVERLAPPED | FILE_FLAG_NO_BUFFERING | FILE_ATTRIBUTE_NORMAL`.
  Instances 0..19 are probed (`OpenFirstDevice`, `0x1000AB70`).
* **No SetupAPI.** `RComms.dll` imports only KERNEL32, ADVAPI32, USER32, GDI32,
  MFC42 and MSVCRT. Device enumeration is done by reading
  `HKLM\SYSTEM\CurrentControlSet\Services\HmseUsb\Enum` (`0x1000A060`,
  `0x1000A130`) and, when a symbolic path is needed, formatting
  `\\?\USB#Vid_%.4x&Pid_%.4x#%s#{a5dcbf10-6530-11d2-901f-00c04fb951ed}`
  (`0x1000A030`; that GUID is `GUID_DEVINTERFACE_USB_DEVICE`).
* **Descriptors come from the driver by IOCTL**, device type `0x8000`,
  `METHOD_BUFFERED`, `FILE_ANY_ACCESS`:
  `0x80002000` device descriptor (18 bytes), `0x80002004` configuration
  descriptor (255 bytes), `0x80002008` get/set assigned pipes (2 bytes each way),
  `0x80002010` set protocol (8 bytes in: `in[0] = 0x40`, `in[2:3] = protocol
  selector`, `in[6:7] = 1`; 1 byte out). `SetProtocol` (`0x1000AF80`) runs its
  body **only if `idProduct == 0x8236`** and otherwise returns success
  immediately — so for the radio's `0x0025` it is a no-op, and `Connect`
  (`0x1000A6B0`) reduces to open → `GetDeviceDetails` → `GetDeviceId`. The
  re-enumeration dance in `SetProtocol` (out byte `== 2` → close, re-open the
  device under a new PID) is E8a-only.
* **Endpoint table** at `RComms.dll` `0x1001DE8C`, two 6-byte `_VPIPE` records,
  raw bytes `33 82 81 02 83 00 | 36 82 81 02 84 00`:

  | idProduct | pipe A | pipe B | pipe C |
  | --- | --- | --- | --- |
  | `0x8233` | `0x81` (bulk IN 1) | `0x02` (bulk OUT 2) | `0x83` (IN 3) |
  | `0x8236` | `0x81` | `0x02` | `0x84` (IN 4) |

  `GetPipeReAssignment` (`0x1000B2A0`) walks the live configuration descriptor's
  endpoint descriptors by `bLength`, matches `bEndpointAddress`, and sends the
  resulting *pipe indices* to the driver with IOCTL `0x80002008`.
  **PID `0x0025` is not in this table**, so for the radio `GetDeviceDetails`
  (`0x1000AEA0`) skips the reassignment and simply reads the driver's existing
  assignment back — the radio's own descriptor decides the endpoint numbers. Two
  data pipes plus one status pipe is the shape the library requires
  (`if (*v10 < 2u) return 0;`).
* **Packet size** — `GetEndpointPacketSizes` (`0x1000B3A0`) stores each pipe's
  `wMaxPacketSize` from the descriptor, and `E8A_USB::Read` (`0x1000A8F0`) rounds
  every read length **up to a whole multiple of the IN pipe's `wMaxPacketSize`**.
  All `ULE_*`/`ProgDownload`/`PreEraseWrite_Erase` traffic is exactly **64 bytes
  per transfer**, which is full-speed bulk `wMaxPacketSize`.
* **Timeouts** — library I/O waits `1000 × SetTimeout` milliseconds, i.e.
  `SetTimeout` takes seconds (`0x1000A500`); the updater calls
  `SetTimeout_RE(2000)`. The E8a layer uses 3000 ms for a write acknowledgement,
  60000 ms for a program read-back, and re-polls status every 200 ms.
  `SetProtocol` waits 1000 ms then retries the re-open 50 × 100 ms.
* Two exports are stubs: `E8A_USB::SendCommand` returns `-1` unconditionally
  (`0x1000A8E0`, 6 bytes) and `E8A_USB::GetStatus` returns `0` (`0x1000AAF0`).
  Anything in the surrounding code that depends on them is dead.

### 3. The update descriptor the decryption pass threw away

`RES_UPDATE_INFO` is **not** just the firmware image. `UPD_MAIN 0x4068D0` does
`qmemcpy(buf, resource, 0x100060)` — 1,048,672 bytes — and `UPD_SUB` copies
0x400074. The layout is `timestamp(4) | ciphertext(imagesize) | descriptor`, and
the trailing descriptor is **plaintext**. It is the file that tells the updater
what to do. Full map in `ida\out\host-usb\update-info-descriptor.tsv`; the
essentials, read directly out of the EXEs:

| | MAIN (`0x13D2A4`) | SUB (`0x43E2A4`) |
| --- | --- | --- |
| image size | `0x00100000` | `0x00400000` |
| start address | — (0) | **`0xFFC00000`** (+hi dword 0) |
| end address | — | **`0xFFFFFFFF`** (+hi dword 0) |
| transport | `1` = USB | `1` = USB |
| model / type / version | `FT3DR/E(MAIN)` / `EXP` / `1.02` | `FT3DR/E(SUB)` / `ALL` / `1.02` |
| protocol id | **`6`** = H8S/2370 | **`7`** = RX64M |
| input clock | `0x0640` = **16.00 MHz** | 0 (unused) |
| multiplier | `1` | 0 |
| ID code (16 bytes) | all `00` | all `00` |
| extra parameter | — | `1` (sent as the operand of RX command `0x36`) |
| `RES_START_DLG` / `RES_END_DLG` sizes | `0x20A` / `0x1AC` | `0x20B` / `0x1AC` |

Both resources are followed by literal ASCII `PADDINGX`. The 16-byte ID code
being all zeros means **no boot-mode protection key is set on either processor**.
The `1.02`/model/type strings feed dialog items 1003 and 1005, which is why the
GUI shows Model/Type/Version without reading anything from the radio.

The code dispatches on the protocol id with `== 5`, `== 6` and a default. Since
the shipped values are 6 and 7, **`== 5` is a branch neither package can take**
(see §6).

### 4. MAIN: the H8S boot protocol, byte-exact

Framing is `CMD [SIZE] [data…] SUM` with `SUM = -(sum of all preceding bytes) & 0xFF`
— verified against three literal checksums in the binary. Transmit is
`UPD_MAIN 0x4037F0`, which branches on the transport dword: `0` → serial
`WriteFile`, `1` → `WriteData_RE`.

| Command | Bytes | Builder |
| --- | --- | --- |
| bit-rate sync | `00` | `0x403900` |
| ACK | `06` | `0x403920` |
| boot handshake | `55` | `0x403A00` |
| supported-device inquiry | `20` | `0x403C00` |
| device selection | `10 LEN <ASCII device code> SUM` | `0x403C20` |
| clock-mode inquiry | `21` | `0x403D30` |
| clock-mode selection | `11 01 <mode> SUM` | `0x403D50` |
| programming-unit inquiry | `27` | `0x403D80` |
| new bit rate (short) | `3F <br/100 hi> <lo>` | `0x403AB0` |
| new bit rate (full) | `3F 07 <br hi> <lo> 06 40 02 01 01 SUM` | `0x403DA0` |
| program/erase state transition | `40` | `0x403E80` |
| **ID code check** | `60 10 <16 bytes, all 00> SUM` | `0x403EC0` |
| erasure selection | `48` | `0x403FD0` |
| block erase | `58 01 <block#> SUM` | `0x403FF0` |
| user-MAT programming selection | `43` | `0x404020` |
| checksum request | `4B` | `0x404060` |
| **program block** | `50 <A2> <A1> <A0> <8192 data bytes> SUM` — **8197 bytes on the wire** | `0x403AF0`, sent as `sub_4037F0(this, buf, 0x2005)` |
| end of programming | `50 FF FF FF FF B4` (literal) | `0x403BB0` |

Geometry, confirmed at `0x404F20` and `0x403330`:
`sub_4033A0(1, 0, 0x100000, 0x2000)` initialises the progress bar with total
`0x100000` and step `0x2000`; each accepted block does `address += 0x2000;
offset += 0x2000;` and sets the last-block flag when `offset == 0x100000`. Start
address is `0` (`this+84 = 0` at line 1548). So: **128 blocks of 8192 bytes at
H8S addresses `0x000000`–`0x0FFFFF`, 24-bit big-endian address in each command.**
The bit rate negotiated by `0x3F` is taken from the table at `0x424688`
(`115200, 57600, 38400, 19200, 9600, 4800, 2400, 0`); protocol id 6 selects
index 0 = **115200**. Success replies are `06`; `D0 <code>` (= `0x50|0x80`) is the
error form, and the specific pair `D0 11` is tolerated and the block re-sent.
The block size is *also* learned at runtime from the `0x27` reply
(`*(this+1048688) = a2[3] + (a2[2] << 8)`, big-endian) — but only the GEN writer
uses that value; the H8S writer hard-codes `0x2000`.

### 5. SUB: the RX boot protocol, byte-exact

Framing (from `UPD_SUB 0x403F50`, `0x403E50`, `0x403C00`):

```
command packet:  01 LNH LNL CMD [data...] SUM 03
data packet:     81 LNH LNL CMD [data...] SUM (17 | 03)
LNH:LNL = big-endian byte count of CMD+data
SUM     = -(LNH + LNL + CMD + data) & 0xFF
trailer = 0x03 ETX on the final packet, 0x17 ETB while bytes remain
error reply = CMD | 0x80, one error-code byte in data[0]
```

| Command | Bytes | Builder / handler |
| --- | --- | --- |
| (device announces) | `C1` | handled at `0x406870` |
| area/block inquiry | `01 00 01 38 C7 03` | `0x403C00`; reply parsed at `0x4068D0`, four big-endian 32-bit values from `data[8..23]` |
| selection ("endian") | `01 00 02 36 01 C7 03` | `0x403C50`, operand from descriptor `+0x70` |
| (reply `32`, error `B2`) | | `0x406AF0`, then sends `00` |
| inquiry / sync | `01 00 01 00 FF 03` | `0x403D70` |
| selection | `01 00 02 50 00 AE 03` | `0x403DC0`; error `D0` |
| **address range** | `01 00 09 13 FF C0 00 00 FF FF FF FF SUM 03` | `0x403E50`, operands from descriptor `+0x08` and `+0x10`; reply handler `0x406C70` then sets the block size to **1024** |
| **programming data** | `81 <LNH> <LNL> 13 <≤1024 bytes> SUM 17\|03` | `0x403F50` |
| finalise / sum | `01 00 02 4D 00 B1 03` | `0x4040A0`, issued from `0x406D40` once the last-block flag is set |
| error to `13` | `93 <code>` | `0x406D40` |

Geometry, confirmed at `0x403BB0` (UPD_SUB): `address += 1024; offset += 1024;`
last-block flag when `offset == descriptor image size`. So: **4096 packets of
1024 bytes covering `0xFFC00000`–`0xFFFFFFFF`, address range declared once.**
The range and the block size are exactly the mapping the BRIEF already
established for the SUB image — the host and the image agree.

### 6. Code the shipped UI cannot reach

Four distinct unreachable paths, in descending order of interest:

1. **The COM-port transport is complete and live code.** `UPD_MAIN 0x4048A0` is
   the single decision point:
   ```c
   if ( *(_DWORD *)(descriptor + 8) )        // 1 in both shipped packages
   {   LoadLibraryA("RFP_USB_VB.dll"); ...; SetTimeout_RE(2000); }
   else
   {   sub_408860(port_name, 19200, 0, 8, 0);  ...  }   // \\.\COMn, 19200 8N1
   ```
   `sub_408860` is a real implementation: `strstr(port,"COM")`, `\\.\%s` for
   ports ≥ 10, `CreateFileA(..., 0x80)` (non-overlapped), `SetCommMask(0)`,
   `SetupComm(2000,2000)`, `PurgeComm(0xF)`, `SetCommTimeouts(50/50/50/50/500)`,
   then `sub_408570` which fills a real `DCB` supporting 110, 300, 600, 1200,
   2400, 4800, 9600, 14400, 19200, 38400, 57600, 115200 baud, 7 or 8 data bits,
   none/odd/even parity and 1/1.5/2 stop bits. `sub_4084C0` closes with
   `EscapeCommFunction(h, CLRDTR)`. Every frame builder routes through the same
   `if (transport) USB else serial` switch, so **the whole boot protocol works
   over a serial port unchanged.** The UI confirms the intent: `sub_402DA0`
   fills dialog item 1014 with `COM1`…`COM256` and item 1007 with
   `115200/57600/38400/19200/9600/4800/2400 bps` — and then does
   `CB_SETCURSEL(-1); EnableWindow(combo, FALSE)` on the COM box when the
   transport is USB, and `EnableWindow(baud, FALSE)` **unconditionally, in every
   build**. That is precisely the pair of blank, unexplained boxes in the
   manual's screenshots (pages 12 and 15): a generic Yaesu updater shell
   (`yminstall.exe` 1.3.5.0) whose serial mode is switched off by one dword in
   the encrypted resource.
2. **A third protocol, `protocol id == 5`.** Both EXEs contain a full "generic
   writer download" state machine — state strings `Wait connect response`,
   `Wait initialize response`, `Wait writer size echo back`,
   `Wait writer data echo back`, `Wait rom deleted notification`,
   `Wait writer executed notification`, `Wait CPU clock response`,
   `Wait new baudrate response`, `Wait new baudrate set complete`,
   `Wait firmware data echo back`, `Wait complete` (`UPD_MAIN 0x4234E4`…`0x423694`).
   This one **downloads its own writer program into the target's RAM and runs
   it**, then programs with `50 <A3 A2 A1 A0> <N bytes> SUM` where the 32-bit
   address and the runtime-learned block size come from the device
   (`sub_403940`). Selected by descriptor word `5`, which neither package
   contains. `sub_403940` even indexes `this+1048688`, past the MAIN
   descriptor's end — a read the shipped configuration never performs. One of
   its handlers, `UPD_MAIN 0x405590`, still contains developer instrumentation:
   it appends `"12:true\n"` to `dbg.txt` in the working directory and calls
   `exit(1)` if the file cannot be opened.
3. **Cross-model protocol support.** `FT3D_SUB_ver102(ALL).exe` carries the
   *entire* H8S/2370 command set at `0x404110`–`0x404870` (the same functions as
   `UPD_MAIN 0x403900`–`0x404060`, shifted by `0x810`, including the 8192-byte
   `0x2005` writer) while its descriptor selects protocol 7, and
   `FT3D_MAIN_ver102(EXP).exe` carries the GEN machine it never selects. Only
   `UPD_SUB` has the RX64M block (`0x403C00`–`0x4040A0`) and the state names
   `RX64M wait init response / device type / endian / frequency / sync / erase /
   sum`. Both EXEs therefore contain more radio support than they ship for; a
   different descriptor is the only difference between them and a tool for
   another Yaesu model on either core.
4. **`RComms.dll`'s entire debug-probe protocol.** 64-byte frames,
   `seq(2 LE) | len(2 LE) | A5 F0 5A 0F | length(4 BE) | command(4 BE) |
   params(BE) | F0 A5 0F 5A | zero pad`. Commands, all confirmed by the
   constants passed to the big-endian store helper `sub_10014050`:
   `0x80000000` connect/version, `0x80010000` disconnect, `0x80020000`
   FPGA download, `0x80030000` AUD trace read, `0x80040000` CPU status read,
   `0x80050000`/`0x80060000` E7 read/write memory, **`0x80070000` ULE read
   memory**, **`0x80080000` ULE write memory**, `0x80090000` sum check and
   firmware download, `0x800A0000` monitor open, `0x80110000`–`0x80140000`
   H-UDI single/serial read and write, `0x80200000` AUD event set,
   `0x80230000` fill memory. `ULE_ReadMemory` (`0x1000C5F0`) takes
   `(count:u16, buffer, address:u32, width:u8)` and puts address, count and
   access width straight into the frame — an **arbitrary target-memory read**.
   `PreEraseWrite_Erase` (`0x100118A0`) even carries the H8S erase bytes `48 00`
   and `58 00` inside these frames. None of it is reachable: no `ULE_*`, `E7_*`,
   `HUDI_*`, `AUD_*`, `FIRM_Download`, `ProgDownload` or `MonpOpen` string or
   import appears in either updater, `RFP_USB_VB.dll` resolves only
   `QueryInterface` from `RComms.dll`, and `IsSupportedDevice` (`0x1000AB40`)
   accepts only PIDs `0x8233` and `0x8236` — E8a emulators, not the radio.
   `E8A_USB::ScanPorts` (`0x1000A660`) hard-codes VID `1115` (`0x045B`) and PID
   `33334` (`0x8236`) for every port it enumerates.

There is one more vestige worth naming: `sub_406590` in both EXEs formats every
transmitted and received byte as `"Tx %02x %02x …"` / `"Rx …"` into a 5 KB local
buffer and is called on **every** frame — a protocol tracer whose output sink has
been removed. It writes nowhere.

### 7. Device identity and the driver

Complete list in `ida\out\host-usb\vidpid.tsv`, carved from the four INFs inside
`HMSEUSBDRIVER.exe`. Setup class `RenesasUSB`, ClassGUID
`{4E95F166-78F1-4c09-A93C-0EF5ACB45B4A}`, class name
`Renesas USB Development Tools`, driver `HmseUsb.sys`, `ServiceType = 1`
(`SERVICE_KERNEL_DRIVER`), `StartType = 3` (demand), provider
`Renesas Technology Europe Ltd.`, `DriverVer 11/27/2003, 1.1.8.0` (x86) /
`07/07/2009, 1.1.9.0` (amd64).

| VID | PID | `DeviceDesc` |
| --- | --- | --- |
| `045B` | `000A` | `FDM` |
| `045B` | `000B` | `CE 2148` |
| `045B` | `000C` | `CE 3664` |
| `045B` | `000D` | `USB Direct` |
| `045B` | `823F` | `E8Direct` |
| `045B` | `0025` | **`Generic Boot USB Direct`** ← the FT3DR/DE |
| `045B` | `8236` | `E8a` — amd64 INF only, and `ExcludeFromSelect` |

So the radio is bound by an **emulator/programming-adapter driver**, not a
radio-specific one, and the "Generic Boot USB Direct" name is Renesas's own
string for *an MCU sitting in USB boot mode*.

**On the manual's warning.** Page 11 says that if
`Renesas USB1653 USB Boot Mode Device` appears under *Universal Serial Bus
controllers* then the wrong driver bound. `USB1653` does not appear anywhere in
this package — searched all five binaries as ASCII and as UTF-16LE, zero hits.
That name therefore belongs to a **different** Renesas driver that also claims
`VID_045B&PID_0025` and installs under the in-box USB-controller class rather
than under `RenesasUSB`. The distinction matters mechanically, not cosmetically:
`RComms.dll` finds the radio only by opening `\\.\HmseUsb<n>` or by reading
`HKLM\...\Services\HmseUsb\Enum`. If the other driver owns the device, neither
exists, `Open_RE` fails, and the updater reports `USB Open error` /
`Power is not turned on or cable is disconnected.` — which is the symptom.

### 8. The manual, on record

Full text: `ida/out/host-usb/manual-ver-up-2206B.txt`. Points other
agents should have:

* **The version screen shows three versions** — `Main Ver.`, `Sub Ver.` and
  **`DSP Ver.`** (`[DISP]` → `DISPLAY` → `9 SOFTWARE VERSION`, page 3). This
  package contains only two images. The DSP is a third firmware, not updatable
  from here.
* **Program switch**, behind the microSD/DATA jack cover on the right side,
  three positions: **up = Main write, down = Sub write, centre = normal**
  (pages 10 and 13). The manual is explicit that "the driver will not be
  displayed in the device manager if the FT3DR/DE and PC are not connected by the
  supplied cable" — i.e. the USB device only exists in a write position.
* **Power sequencing:** battery pack *and* AC adaptor removed, switch moved,
  USB connected, *then* the AC adaptor plugged into EXT DC IN (pages 10–11,
  13–14). The radio is powered up already in boot mode.
* **Timing:** "about Main Firmware: 20 seconds or Sub Firmware: 90 seconds"
  (page 15). 1 MiB/20 s ≈ 52 KiB/s and 4 MiB/90 s ≈ 47 KiB/s — about
  0.4 Mbit/s. **The USB pipe is nowhere near saturated**; flash programming time
  sets the rate.
* **An all-reset is forced after every update** and deletes all saved data
  (page 12); a recovery path exists by holding `[BACK]+[DISP]+[BAND]` while
  applying power (page 18).
* Host requirements: **.NET Framework 3.5 SP1** (because `RFP_USB_VB.dll` is a
  v2.0.50727 mixed-mode assembly) and **Visual C++ 2008 Redistributable**
  (because it links `mfc90u`/`MSVCR90`/`msvcm90`).
* The manual never mentions a COM port or a baud rate anywhere. The only
  reference to the screen's own prompt is the dialog string
  `First, complete the communication environment setting, then press the Update
  button.` — which in the USB build means nothing more than "press USB Driver
  Install first".
* The manual explicitly prohibits reverse engineering (page 2). Noted; this is
  owner-side analysis of firmware the owner already has, and nothing here was
  redistributed or written to a radio.

### 9. Yaesu's own VID `0x26AA` — not found, and the scope of that

MAIN-side agents confirmed two application-firmware device descriptors,
`26AA:0001` at MAIN `0x055818` and `26AA:0020` at MAIN `0x07B680`. I searched the
host side for both. **Result: zero references. Not found, with the scope stated
below.**

Scope searched — `FT3D_MAIN_ver102(EXP).exe`, `FT3D_SUB_ver102(ALL)).exe`,
`RComms.dll`, `RFP_USB_VB.dll`, `HMSEUSBDRIVER.exe`, and the four carved INFs, in
full, for:

| Pattern | Result |
| --- | --- |
| `"26AA"` as ASCII text, all four case variants | 0 in every file |
| `"26AA"` as UTF-16LE text, all case variants | 0 in every file |
| `AA 26 01 00` (LE idVendor `26AA` + LE idProduct `0001`) | 0 in every file |
| `AA 26 20 00` (LE `26AA` + LE `0020`) | 0 in every file |
| `AA 26 ?? 00` (LE `26AA` followed by any low-byte PID) | **0 in every file** |
| `26 AA 00 01` / `26 AA 00 20` (big-endian forms) | 0 in every file |
| `USB\VID_xxxx&PID_xxxx` hardware IDs, ASCII and UTF-16, across the whole 3.4 MB installer | **only the seven `045B` IDs already documented** |
| INF `Class=` / `ClassGUID=` across all four INFs | only `RenesasUSB` / `{4E95F166-…}` — no `Ports`, no `Modem`, no `USBDevice` class |
| `usbser`, `SERENUM`, `cdc`, "virtual com", `modem.inf`, `ADMS`, `RT Systems`, "programmer" | 0 real hits (one accidental substring `cdCF=B` inside binary data) |
| `ACME`, `PCL,MPL` (the sample-code strings in MAIN stack 2) | 0 |

The bare 2-byte pairs `AA 26` and `26 AA` do occur — 4/9 in UPD_MAIN, 31/19 in
UPD_SUB, 32/24 in HMSEUSBDRIVER, 1–2 in the INF carves — but that is **at or
below the arithmetic noise floor** for any given byte pair (`len/65536` ≈ 20, 68
and 52 respectively), the 4-byte VID+PID adjacencies are absent entirely, and I
checked the context of every INF hit by hand: all of them sit inside the
Authenticode/CAT signature blobs, i.e. random cryptographic bytes. `RComms.dll`
and `RFP_USB_VB.dll` — the only two binaries in the package that actually touch
USB — contain **no** occurrence of any form.

**What that means.** The vendor's update tooling talks only to the boot ROM. The
`26AA:0001` / `26AA:0020` interfaces in the application firmware are driven by
**different software that is not in this package** — Yaesu's PC programming /
cloning application, and for the CDC personality possibly nothing more than
Windows' in-box `usbser.sys`, since a `bDeviceClass = 0x02` CDC-ACM device needs
no vendor driver at all on Windows 10/11. Practical consequence for the owner:
the `26AA` protocol **cannot be cross-checked against host code from this
package**. It has to come out of the MAIN image, or out of a capture, or out of
the separate Yaesu application.

### 10. There *is* a control-transfer path, and it is a raw SETUP passthrough

This corrects something I understated earlier. IOCTL `0x80002010` is not a
bespoke "set protocol" call — its 8-byte input buffer is **a literal USB SETUP
packet**. Disassembled at `RComms.dll 0x1000B00B`–`0x1000B034`:

```
1000B024  C6 44 24 3C 40        mov byte  [buf+0x00], 0x40    ; bmRequestType
1000B029  88 5C 24 3D           mov byte  [buf+0x01], bl (0)  ; bRequest = 0
1000B00F  66 89 54 24 26        mov word  [buf+0x02], dx      ; wValue  = protocol arg
          (buf+0x04 zeroed at 1000AFFF)                       ; wIndex  = 0
1000B02D  66 C7 44 24 42 01 00  mov word  [buf+0x06], 1       ; wLength = 1
1000B01B  6A 08 / 52            push 8, push buf              ; nInBufferSize = 8
1000B014  6A 01 / 51            push 1, push outbuf           ; nOutBufferSize = 1
1000B01E  68 10 20 00 80        push 0x80002010
1000B034  E8 ...                call DeviceIoControl wrapper
```

`bmRequestType = 0x40` is `Host-to-Device | Vendor | Device`. So the shipped
driver stack **can issue arbitrary vendor control requests** — that is exactly
the transport the radio's `0x41D1` / `0x41D2` / `0x41D3` / `0xC1D4` requests would
need. *Inferred (strong)*: `HmseUsb.sys` builds a vendor URB from that buffer.
I could not confirm it from the driver binary itself (see the `data2.cab` scope
limit), but the buffer's contents are a SETUP packet field for field, it is the
only 8-in/1-out IOCTL in the interface, and the 1-byte reply is then tested for
`== 2` (device re-enumerated under a new PID) / `== 0` (failed) / else `Sleep(150)`.

**Does anything in the package speak `0xD1`–`0xD4`?** No.

* The only vendor request any host binary issues is `bmRequestType 0x40`,
  `bRequest 0x00`, `wValue = <protocol>`, `wIndex 0`, `wLength 1` — and
  `SetProtocol` runs its body **only when `idProduct == 0x8236`**
  (`1000AFA1: cmp word [esi+0x203E], 0x8236`), so for any other device, including
  the radio, it returns success without sending anything.
* Searched all five binaries for the setup words `0x41D1`, `0x41D2`, `0x41D3`,
  `0xC1D4` as both byte orders. `RComms.dll` and `RFP_USB_VB.dll`: **zero
  occurrences of any of the eight patterns.** The counts in the two EXEs and the
  installer are code noise — `D1 41`, for instance, is an ordinary x86
  shift/rotate encoding — and none of them sits in a data table.
* One of the five requests stack 1 answers *is* exercised by this package, but
  indirectly and by the driver, not by name in user mode: **`0x8006`
  GET_DESCRIPTOR** is what `HmseUsb.sys` must send to satisfy IOCTL
  `0x80002000` (device descriptor, 18 bytes) and `0x80002004` (configuration
  descriptor, 255 bytes). That is the one point of overlap between the two
  identities' request sets, and it is generic USB, not an FT3D API.

So: the radio's real USB API (`0x41D1`–`0xC1D4`, and whatever payload formats go
with them) has **no host-side counterpart here to decompile**. The bytes have to
be recovered from the MAIN image. What this package does contribute is the
finding that a *shipped, signed, installed* Windows driver on the owner's machine
already exposes a raw vendor-SETUP passthrough — so once the `26AA` request
payloads are known from the firmware, exercising them needs no new kernel driver,
only an INF that binds `26AA:0001` to `HmseUsb.sys` (or WinUSB, or libusb).

### 11. Three different serial channels — do not conflate them

The coordinator is right that this is the easiest mistake in this area. There are
three separate things, and only the first is mine:

1. **The updater's own COM-port transport for the boot protocol.** `UPD_MAIN
   0x4048A0` → `0x408860` → `0x408570`. Opens `\\.\COMn`, sets 19200 8N1, and
   sends the *H8S/RX boot-mode commands* down it instead of down the USB pipe.
   Selected by descriptor `+0x08` (MAIN) / `+0x18` (SUB) = 0. **Disabled in both
   shipped packages**, and the dialog's COM combo (item 1014) is greyed when the
   transport is USB while the baud combo (item 1007) is greyed unconditionally.
   This is what the blank boxes in the manual's screenshots are, and it has
   **nothing to do with the radio's own serial menu.**
2. **The radio's DATA-jack hardware serial channel** — the `COM PORT SETTING`
   menu item, user-selectable 4800/9600/19200/38400, φ = 16 MHz, BRR table at
   MAIN `0x0452C2` (other agents' finding). That is an H8S SCI channel on the
   DATA jack, a *different physical path* from the USB D+/D−, and it is not
   touched by anything in this package. The baud list in the updater's dialog
   (115200/57600/38400/19200/9600/4800/2400) is **not** that list — it is the
   generic Yaesu updater shell's own list and it includes rates the radio's menu
   does not offer.
3. **MAIN's CDC-ACM USB personality, `26AA:0020`.** `bDeviceClass = 0x02` means
   Windows presents it as a virtual COM port under `Ports (COM & LPT)` with no
   vendor driver. That *also* produces a "COM port", which is the third thing
   that looks like the other two and is not. Nothing in this package binds it, no
   INF in the driver package uses the `Ports` class, and there is no `usbser`
   reference anywhere in the five binaries.

If a document ever says "the COM port", it has to say which of these three.

## USB relevance

**Question 1 — everything USB, host side.** Answered above and in the four
tables. The complete USB surface exercised by the vendor's own tooling is: one
device (`045B:0025`), one bulk OUT pipe, one bulk IN pipe, one status IN pipe,
64-byte-granular full-speed bulk transfers, and a byte stream that is the target
MCU's serial boot protocol. No alternate interfaces, no isochronous endpoints, no
HID and no CDC anywhere in the stack. One vendor control request is issued
(`bmRequestType 0x40`, `bRequest 0x00`, `wLength 1`) and only for E8a PID
`0x8236`; the *capability* to issue any vendor request exists in the driver
interface (§10).

**Two USB identities, side by side.** This is the frame to keep. The radio
presents different USB devices depending on the program switch, and only one of
them is described by this package:

| | Boot identity | Application identity |
| --- | --- | --- |
| VID:PID | `045B:0025` `Generic Boot USB Direct` | `26AA:0001` (vendor) and `26AA:0020` (CDC-ACM) |
| whose ID | Renesas's | **Yaesu's own** |
| when present | **only** while the program switch is off-centre (up = Main, down = Sub) | normal operation, switch centred; selected in boot by a held-key check |
| Windows driver | `HmseUsb.sys`, class `RenesasUSB`, INF in this package | **nothing in this package**; `26AA:0001` needs some vendor driver, `26AA:0020` needs none (in-box CDC) |
| endpoints | bulk IN `0x81`, bulk OUT `0x02`, status IN `0x83`/`0x84` (driver-assigned for `0025`) | `0001`: EP1 OUT bulk 64 + EP3 IN int 8. `0020`: EP1 OUT bulk 64 + EP2 IN bulk 64 + EP3 IN int 8 |
| protocol | H8S / RX serial boot-mode commands, tunnelled | vendor requests `0x41D1`, `0x41D2`, `0x41D3`, `0xC1D4` (+ standard `0x8006`); `0x41D2` arms EP1 bulk reception |
| host software in this package | yes — the whole chain, decompiled above | **no** — see §9, zero references to `26AA` |
| what it can reach | erase + write two flash ranges, checksum; no read | unknown from the host side; must come from the MAIN image |
| runs application firmware? | no — the application is not executing | yes |

The two never coexist: in a write position the application firmware is not
running, so the `26AA` stacks cannot be up; with the switch centred the boot
device does not enumerate at all (the manual states this on page 10 and the whole
update flow depends on it).

**What the boot USB path can reach, per processor.** This is the part only the
host side can state precisely:

* **MAIN (H8S, protocol id 6).** Write access to `0x000000`–`0x0FFFFF` — 1 MiB,
  the whole shipped image — in 8192-byte blocks at 24-bit big-endian addresses.
  Erase is per-block (`48` then `58 01 <block#>`), so **erase granularity is a
  block index the device defines**, not a byte address. Clock configuration
  (`11`, `3F` at 16.00 MHz × 1, 115200 bps), device selection by ASCII device
  code (`10`), an ID-code gate (`60`) that is satisfied with sixteen zero bytes,
  and a checksum (`4B`). **No read command is implemented by the host.**
* **SUB (RX64M, protocol id 7).** Write access to the declared range
  `0xFFC00000`–`0xFFFFFFFF` — the entire 4 MiB code flash as mapped — in
  1024-byte packets. The range is declared once by command `0x13`; erase is
  driven by command `0x50`/`0x38` and the device's own block table (the four
  32-bit values the host stores from the `0x38` reply are that table).
  Finalise/checksum is `0x4D`. **No read command is implemented by the host.**
* **Both.** No execute-arbitrary-code primitive, no RAM write, no register
  access, no peripheral access. The only thing the cable can do is erase and
  fill two known flash ranges and ask for a checksum.

**Whether it can read.** Two separate answers, and they must not be conflated:

* The **boot protocol as the updaters implement it: no.** Neither the H8S nor
  the RX state machine contains a memory-read command. Verification is the
  device computing a sum and reporting it. Scope of that "not found": every
  packet builder in both EXEs — I enumerated them exhaustively by scanning the
  2516 successfully decompiled functions (of 2526 total; the 10 failures are all
  MFC/CRT helpers, named in the two `decomp.log` files) for byte-array
  construction and for calls to the two transmit wrappers (`UPD_MAIN 0x4037F0`,
  `UPD_SUB 0x403AF0`), and listed every literal command byte. Nothing reads.
  Independent check: neither EXE contains the string `ULE_`, `E7_Read`, `HUDI_`,
  `FIRM_Download`, `ProgDownload`, `MonpOpen`, `E8A_USB` or `RComms` anywhere
  (the apparent `ULE_` hits are the substring inside `AFX_MODULE_STATE`).
* The **Renesas boot ROMs themselves may well support a read command** that this
  host tool simply does not use — the documented H8S and RX boot command sets
  include read and checksum operations, and `RComms.dll` contains a full
  arbitrary-read implementation (`ULE_ReadMemory`, command `0x80070000`) for the
  emulator protocol. Whether the FT3D's boot ROM answers a read is **Unknown
  from this package**; it is a one-command experiment on hardware, which this
  effort does not do. If it does answer, a dump of both flashes is available over
  the stock cable with no hardware modification — which makes it the single
  highest-value open item in this whole document.

**Question 2 — USB SDR.** From the host side the answer is a firm no, and for a
structural reason rather than a throughput one. The USB device that appears
during an update is a **boot-mode ROM programming interface**. It exists only
while the program switch is off-centre; in that position the application firmware
is not running at all, so there is no sample source and no DSP behind it. In the
centre position the device does not enumerate — the manual says so explicitly and
the whole update flow depends on it. Full-speed bulk would be adequate for
48 kHz 16-bit IQ (1.5 Mbit/s of 12 Mbit/s raw), and the observed 0.4 Mbit/s
programming rate shows the link is not the constraint — but there is no
application-firmware endpoint to stream from in *this* position.

**That analysis no longer settles question 2, and I should say so plainly.** My
earlier "no" leaned on the premise that the application firmware had no USB. It
does: MAIN has an on-chip Renesas USB Function Module at `0xFFEE00`–`0xFFEE53`
with three interrupt vectors, and two complete device stacks. So link 3 — *a USB
device controller in device mode with a bulk endpoint* — **exists and is brought
up by shipped firmware.** From the host side I can add two things that bear on
whether it is usable for a stream, both of them constraints:

* Both `26AA` stacks' bulk endpoints are **64-byte full-speed bulk**, and the
  IN direction only exists on stack 2 (`26AA:0020`, EP2 IN bulk 64). Stack 1
  (`26AA:0001`) has **no bulk IN at all** — EP1 is OUT and EP3 is an 8-byte
  interrupt IN. A vendor-class interface with no bulk IN cannot stream samples to
  the PC by construction; the most it can return is 8 bytes per interrupt
  interval, plus whatever fits in control-transfer replies (`0xC1D4` returns one
  byte). So **the production personality is architecturally incapable of
  streaming IQ**, whatever the firmware does.
* Stack 2 does have a bulk IN. 64-byte full-speed bulk tops out around
  1 Mbyte/s theoretical and realistically well under that for a CDC-ACM
  implementation on a 16 MHz H8S — which is the real ceiling, not the USB spec.
  16-bit IQ at 48 kHz needs 192 kbyte/s sustained; that is not obviously
  impossible for the pipe, but it is a very long way from what a CDC-ACM control
  path on this class of MCU delivers, and the H8S is a control processor, not a
  sample mover.

So the honest answer now: **link 3 exists, links 1 and 2 are unresolved, and
link 4 is absent but installable.** Which link actually breaks is now a
radio-side question — does any ADC/IF path on either processor produce samples,
and can DMA/DTC move them — and MAIN-side and SUB-side agents own it. The one
thing the boot path still contributes is **link 4's escape hatch**: it can write
both flashes in full, so custom firmware *is* installable, and unlike before we
now know the target has a USB device controller for that firmware to drive.

**Question 3 — the DSP.** The manual confirms a third firmware version is
displayed (`DSP Ver.`) and this package contains no third image and no third
protocol id. The descriptor's protocol field is a 16-bit selector with only `5`,
`6` and `7` handled, so **there is no host-side path to a DSP at all**: the USB
cable can reach exactly the two flashes the two descriptors name. If the DSP is
reachable, it is from MAIN or SUB firmware over an internal bus, never from the
PC.

**For SUB-USB and BOOT-IPC, lined up for cross-checking.** My end of the same
operation:

| | MAIN | SUB |
| --- | --- | --- |
| address space written | `0x000000`–`0x0FFFFF` | `0xFFC00000`–`0xFFFFFFFF` |
| total bytes | `0x100000` | `0x400000` |
| write block | **8192** (`0x2000`) | **1024** |
| blocks | 128 | 4096 |
| address field on the wire | 24-bit big-endian, per block | 32-bit big-endian, range declared once |
| erase | block index (`48`, `58 01 <n>`) | device block table from the `38` reply |
| protection | 16-byte ID code, all zero | 16-byte field, all zero |
| verify | device checksum (`4B`) | device checksum (`4D`) |
| negotiated bit rate | 115200 (`3F`, clock 16.00 MHz × 1) | 19200 class (table index 3) |

If your flash driver in either image shows different erase-block boundaries than
the host assumes, that is a real discrepancy and worth chasing — the host's
`0x2000` on MAIN is hard-coded, while the same EXE also knows how to *ask* the
device for its programming unit and doesn't.

**One structural question I cannot close, and it matters.** The host uses the
**same** USB transport (descriptor word = 1) and the **same** device
(`045B:0025`, same driver, same manual steps) for both switch positions, yet it
speaks the H8S boot protocol in one and the RX boot protocol in the other, and it
negotiates an **SCI bit rate** in both — `CRFP_USB_MyIF.SetBaudrate` exists in
the managed layer, and command `3F` is sent even on the USB path. That is the
signature of a byte-transparent USB-to-boot-serial front end, not of a device
that understands the protocol. Three possibilities, and radio-side evidence
decides:

1. Each MCU has its own USB boot ROM and both present `045B:0025`. Requires the
   MAIN part to have a USB module — decisive test for the MAIN agents: does the
   H8S image or the part number support USB at all? The BRIEF's H8S/2370
   hypothesis says no.
2. A third, dedicated USB↔serial bridge sits behind the DATA jack and the
   program switch routes it to the selected MCU's boot pins. This fits
   everything I can see, and it would mean the USB silicon is **not** described
   by either shipped image — so the radio's USB surface is fixed firmware that
   this update package cannot change.
3. `045B:0025` is one MCU's boot ROM and it relays to the other. I can see no
   mechanism for this; a boot ROM does not forward.

If (2) holds, the answer to the owner's first question gains a hard boundary:
the radio's USB behaviour is defined by a part whose firmware is not in this
package and is not updatable through it.

## Open

Most valuable first.

1. **Try a boot-mode read.** The one test that would change the project: send the
   H8S or RX boot-mode read/checksum command over the stock cable with the
   program switch set, and see whether the ROM answers. If it does, both flashes
   can be dumped without touching the hardware, which independently verifies the
   decryption and exposes any factory data the update image does not contain.
   This is a hardware step and deliberately not done here.
2. **Identify the silicon behind `045B:0025`.** See the three options above.
   Cheapest route is the MAIN image: if the H8S has no USB module, option 2 is
   forced and a third part exists.
3. **Unpack `data2.cab` and read `HmseUsb.sys`.** It would give the driver's
   IOCTL dispatch, its URB construction, and — most useful — the endpoint/pipe
   layout it expects from a `045B:0025` device, which is the one endpoint fact I
   had to leave inferred for the radio rather than confirmed. Needs an
   InstallShield cab extractor (`unshield`, `i5comp`, or 7-Zip with the IS
   plugin); none is installed.
4. **Prove the serial path end to end on paper.** Patch the descriptor dword at
   image-end `+0x08` (MAIN) / `+0x18` (SUB) from 1 to 0 in a scratch copy, re-encrypt
   with the known session key, and confirm the dialog enables the COM combo and
   the frame builders route to `WriteFile` on `\\.\COMn`. That would turn
   "the serial code is live" from inferred-by-reading into demonstrated, and it
   would tell the owner whether the radio's boot pins are wired to a serial
   header at all.
5. **Recover the RX `0x32` sender and the `0x36`-reply handler.** One state in
   the RX chain (`UPD_SUB 0x406AF0`, reply `0x32`, error `B2`) has no builder in
   my literal-array scan, so one command in the RX sequence is still named only
   by its reply. `sub_403CC0` (14-byte packet) is the likely candidate.
6. **Decode the H8S device-code string sent by command `0x10`.** `UPD_MAIN
   0x403C20` reads it from the state object, not from the descriptor; finding
   where it is initialised names the exact H8S part the vendor's own tool
   believes is in the radio — a direct, independent answer to the MAIN part-number
   question.
7. **The GEN writer, for completeness.** If descriptor word 5 is ever seen in
   another Yaesu package, that path downloads and *executes* a writer program in
   the target's RAM. That is an arbitrary-code primitive over the same cable.
   Nothing in the FT3D packages selects it, but its presence means the vendor
   tooling family has one.

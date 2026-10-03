# FT3DR ver 1.02 firmware decryption

Both official updaters in `Firmware/` carry an encrypted image in a PE resource. IDA 9.1 recovered the key material from each updater. `ida/yaesu_cipher.py` applied it. This note is the record of that run.

## Packages

| Package | EXE | PDB path inside the EXE |
| --- | --- | --- |
| MAIN EXP 1.02 | `Firmware/FT3D_MAIN_ver102(EXP)/FT3D_MAIN_ver102(EXP).exe` | `firmware_updater_v1.350\vsinstall\Release\vsinstall.pdb` |
| SUB ALL 1.02 | `Firmware/FT3D_SUB_ver102(ALL)/FT3D_SUB_ver102(ALL).exe` | `20190619_firmware_updater_v1.500\vsinstall\Release\vsinstall.pdb` |

Each EXE is PE32, image base `0x400000`. The shared helpers `RComms.dll`, `RFP_USB_VB.dll`, and `HMSEUSBDRIVER.exe` match byte for byte between the packages.

## Resource

Custom resource type 23, name `RES_UPDATE_INFO`, language 1024.

| Field | MAIN | SUB |
| --- | --- | --- |
| File offset of the resource | `0x3D2A0` | `0x3E2A0` |
| Resource size | 1,048,672 | 4,194,424 |
| Unix timestamp (first dword) | 1576569521 | 1576569673 |
| UTC text `%Y%m%d%H%M%S` | `20191217075841` | `20191217080113` |
| Ciphertext length (dword after the ciphertext) | `0x100000` | `0x400000` |
| Trailer strings | `FT3DR/E(MAIN)`, `EXP`, `1.02` | `FT3DR/E(SUB)`, `ALL`, `1.02` |

Layout: 4-byte timestamp, then ciphertext, then a trailer whose first dword repeats the ciphertext length. The plaintext is the ciphertext only. The trailer stays in the JSON as strings.

## Where IDA found the key

`ida/find_key.py` does three structural searches after autoanalysis. It does not ship a copy of the tables.

1. In `.rdata`, one run of 16 little-endian dwords whose values are only 1 or 2. That is `key_config` (64 bytes). The following bytes must be a 48-byte index table (`key_config2`, values 1..56), a 48-byte index table (`encryption_config`, values 1..32), 2048 bytes of only 0 and 1 (`encryption_config2`), and a 32-byte permutation of 1..32 (`encryption_config3`).
2. In `.text`, one site that pushes four addresses `0x38` apart, each pointing at 56 bytes of mixed 0 and 1. Those are the timestamp tables.
3. The format string `%Y%m%d%H%M%S`.

The same static tables were recovered from both updaters. The session keys differ because the timestamps differ.

### MAIN

| Symbol the script names | Address |
| --- | --- |
| `yaesu_set_key` | `0x407850` |
| `yaesu_decrypt_block` | `0x407980` |
| `yaesu_derive_session_key` | `0x4082C0` |
| format string | `0x4244C4` |
| `yaesu_key_config` | `0x424DE0` |
| `key_config2` | `0x424E20` |
| `encryption_config` | `0x424E50` |
| `encryption_config2` | `0x424E80` |
| `encryption_config3` | `0x425680` |
| timestamp tables | `0x42C114`, `0x42C14C`, `0x42C184`, `0x42C1BC` |

Session key:

```text
0001010001000101010001000100000100010001010001000000000001000101000000000101010000000001000100010000010001000000
```

### SUB

| Symbol the script names | Address |
| --- | --- |
| `yaesu_set_key` | `0x4087E0` |
| `yaesu_decrypt_block` | `0x408910` |
| `yaesu_derive_session_key` | `0x409250` |
| format string | `0x4255F4` |
| `yaesu_key_config` | `0x425F58` |
| `key_config2` | `0x425F98` |
| `encryption_config` | `0x425FC8` |
| `encryption_config2` | `0x425FF8` |
| `encryption_config3` | `0x4267F8` |
| timestamp tables | `0x42D134`, `0x42D16C`, `0x42D1A4`, `0x42D1DC` |

Session key:

```text
0100010000000100010100010001000100010000010100010101010101000000000101000101010000000100010100000100000000000001
```

`set_key` turns 56 key bytes into a 768-byte schedule (`0x300`). That schedule is stored in each `ida/out/*.key.json` as `key_schedule_0x300`.

## Algorithm

Implemented in `ida/yaesu_cipher.py`. Block size is 8 bytes. Both ciphertext lengths are multiples of 8.

1. Format the timestamp in UTC with `%Y%m%d%H%M%S` (14 ASCII digits).
2. Four rounds. Each round installs one 56-byte timestamp table as the key, XORs the next date digits into a 64-byte buffer as individual bits (MSB of each digit first), and runs the block function in the encrypt direction. Digits past the 14th are zero.
3. The first 56 bytes of that buffer are the session key. `set_key` expands them.
4. For each 8 ciphertext bytes, expand each byte to 8 bits, run the block function in the decrypt direction, and pack the bits back.

`set_key` rotates two 28-byte halves left by one or two positions per round. `key_config` selects one versus two. It then gathers 48 bytes per round through `key_config2`, for 16 rounds.

The block function runs 16 rounds over the 64-bit buffer. Decrypt starts at schedule slot 15 and walks down to 0. The last round only XORs. Earlier rounds also swap halves of each 4-bit group. `encryption_config3` chooses the XOR source.

## Plaintext check

| Image | Bytes | Entropy | SHA-256 |
| --- | --- | --- | --- |
| MAIN | 1,048,576 | 4.135 | `8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce` |
| SUB | 4,194,304 | 3.721 | `b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230` |

The ciphertext blocks in the updaters sit near entropy 7.9. After decryption the MAIN image opens `00 00 20 92` repeated, a big-endian vector table, and contains `WIRES-X`, `DG-ID`, and `V0030FT3D`. The SUB image contains `$PMTK103`, `GPS SETUP`, `USB CAMERA`, and `Bluetooth`.

Output files:

- `decrypted/FT3D_MAIN_ver102_EXP.bin`
- `decrypted/FT3D_SUB_ver102_ALL.bin`
- `ida/db/FT3D_MAIN.i64`
- `ida/db/FT3D_SUB.i64`

## Run it again

```text
python "ida/run_ida.py"
```

`run_ida.py` is the only supported launcher. It keeps PowerShell away from `idat.exe -S` quoting and away from the plaintext bytes. IDA's log goes to `ida/log/`. The script's progress goes to `ida/out/*.status.txt`. A failure traceback goes to `ida/out/find_key_error.txt`.

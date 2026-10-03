# Writes ida/out/pc/L2-dat-layout.tsv (lane 2). Plain Python, no IDA.
# Run from the workspace root: python ida\jobs\pc_l2_tsv.py
import os

HDR = ("file", "offset", "length", "field", "encoding", "validated_by_reader", "source_address", "confidence")
rows = [
# ---------------- BACKUP.dat ----------------
("BACKUP.dat", "path", "-", r"card path \FT3D\BACKUP\BACKUP.dat (radio: I:\FT3D\BACKUP)", "name 'BACKUP.dat' + dir index 1 in IPC request +0x14", "Y (open fails if absent)", "MAIN 0x6FF66 name; template 0x71794 +0x14=1; SUB pathtab_bare 0xFFED8318 indexed at 0xFFF3E666", "byte-confirmed (dir index); backslash+name concat inferred"),
("BACKUP.dat", "0x00000", "0x1FDC0", "total file size = 130496", "exact", "Y (stat size==0x1FDC0 sets 0xFFBA41, which gates the restore menu item)", "MAIN 0x6FFAC cmp.l #0x1FDC0; gate 0x6FC20", "byte-confirmed"),
("BACKUP.dat", "0x00000", "0xFEC0", "EEPROM image A = EEPROM 0x00140..0x0FFFF", "raw bytes; file_off = eep - 0x140", "N (written straight to EEPROM)", "MAIN writer 0x74562/0x745EE (sub_3AB80 read); reader 0x748A0/0x7494E (sub_3AD20 write)", "byte-confirmed"),
("BACKUP.dat", "0x00220", "0x05", "model id 'AH72M'", "ASCII", "Y (must equal)", "MAIN sub_737C8 0x737CA; built by 0x7390A; stored to EEPROM 0x360 by sub_3A028 before backup", "byte-confirmed"),
("BACKUP.dat", "0x00225", "0x01", "id format byte = 0x02", "u8 constant", "Y (must equal sub_734BE()=2)", "MAIN 0x737E2 / 0x734BE", "byte-confirmed"),
("BACKUP.dat", "0x00226", "0x04", "destination/region code = 00,EEP[0x21],EEP[0x22],EEP[0x23]", "u32 BE", "Y (must equal radio's own RAM 0xFF800F..0xFF8011)", "MAIN 0x737EE; sub_7357A 0x7357A", "byte-confirmed"),
("BACKUP.dat", "0x0022A", "0x04", "id tail", "0 when written by radio", "N", "MAIN 0x7457A..0x74584 clears 0xFF9702", "byte-confirmed"),
("BACKUP.dat", "0x01540", "0xA180", "memory-channel area (identical bytes to MEMORY.dat 0x0000..0xA17F)", "see MEMORY.dat rows; file_off = eep - 0x140", "N", "MAIN 0x3A172 / 0x3A140 / 0x3A6EE", "byte-confirmed (addresses)"),
("BACKUP.dat", "0x02D40", "0x20 x 1100", "channel slot n record at 0x2D40+0x20*n", "32-byte record (see MEMORY.dat rec+ rows)", "N", "MAIN sub_3A6EE 0x3A700", "byte-confirmed"),
("BACKUP.dat", "0x0FEC0", "0xFEFC", "EEPROM image B = EEPROM 0x10100..0x1FFFB", "raw bytes; file_off = eep - 0x10100 + 0xFEC0", "N", "MAIN writer 0x7469E/0x74702 (sub_3BDAC); reader 0x749D6 (sub_3BF4C)", "byte-confirmed"),
("BACKUP.dat", "0x19DC0", "0x0918", "memory aux area (identical bytes to MEMORY.dat 0xA200..0xAB17)", "see MEMORY.dat rows", "N", "MAIN 0x3DE20", "byte-confirmed (addresses)"),
("BACKUP.dat", "0x1FDBC", "0x04", "checksum", "u32 BE = sum of bytes [0x00000,0x1FDBC) as unsigned 8-bit values, init 0, mod 2^32", "Y but only AFTER all data is already in EEPROM; on mismatch boot marker stays 'MARU' and MAIN restarts into its default-init path", "MAIN writer 0x74748..0x74772 (-> 0xFF5702); reader sum 0x749EE, cmp 0x74AA8 vs 0xFF539A; restart jmp 0xDC4E; marker check sub_DD5C", "byte-confirmed"),
("BACKUP.dat", "(excluded)", "-", "EEPROM 0x000-0x13F (boot marker @0x10 'TAIS'/'MARU', region @0x20-0x27, block @0x40-0x13F), 0x10000-0x100FF and 0x1FFFC-0x1FFFF are not in the file", "-", "-", "MAIN 0x39522 (0x10), 0x39554 (0x20), 0x39586 (0x40); ranges 0x74598 / 0x746AC", "byte-confirmed"),
# ---------------- MEMORY.dat ----------------
("MEMORY.dat", "path", "-", r"card path \FT3D_MEMORY-CH\MEMORY.dat", "name 'MEMORY.dat' + dir index 3", "Y (open)", "MAIN 0x708A0; template 0x71CDA +0x14=3; SUB pathtab_bare[3]", "byte-confirmed (dir index); concat inferred"),
("MEMORY.dat", "0x0000", "0xAC80", "total file size = 44160", "exact", "Y (stat size==0xAC80 sets 0xFFBA42, which gates the restore menu item)", "MAIN 0x70080 cmp.l #0xAC80; gate 0x6FC66", "byte-confirmed"),
("MEMORY.dat", "0x0000", "0x12C0", "24 blocks x 0xC8 (EEPROM 0x1680+0xC8*i)", "stride byte-confirmed; content likely 24 banks x 100 u16 member entries", "N", "MAIN sub_3A172 0x3A172", "stride byte-confirmed; meaning inferred"),
("MEMORY.dat", "0x12C0", "0x0540", "per-slot attribute byte, slot n at 0x12C0+n (EEPROM 0x2940+n)", "u8 bitfield: bits2-3 from 0xFFACD9, others from 0xFFACD5 (band/validity code)", "N", "MAIN sub_3A7CE 0x3A7FA..0x3A82A; sub_3A892", "byte-confirmed addressing; bit meaning unknown"),
("MEMORY.dat", "0x1800", "0x8980", "1100 channel slots x 32 bytes, slot n at 0x1800+0x20*n (EEPROM 0x2E80+0x20*n); slots 1000..1099 addressed as 1000+2k (pairs, likely PMS)", "32-byte record (rec+ rows)", "N", "MAIN sub_3A6EE 0x3A700; sub_3A9A2 0x3A9A8", "byte-confirmed layout; slot->channel-number map inferred"),
("MEMORY.dat", "rec+0x00", "1", "record byte 0 (copied to state+0)", "u8, unknown flags", "N", "MAIN sub_3FB0C 0x3FB44; sub_3FD48 0x3FDBE", "position byte-confirmed; meaning unknown"),
("MEMORY.dat", "rec+0x01", "1", "bits0-3 -> state+2; bits4-5 -> state+3; bits6-7 -> state+7", "bitfield", "N", "MAIN 0x3FB4C..0x3FB6C; 0x3FDC6..0x3FDE2", "split byte-confirmed; meanings unknown (mode/step/shift candidates)"),
("MEMORY.dat", "rec+0x02", "3", "RX frequency", "BCD 6 digits 100 MHz..1 kHz (14 65 20 = 146.520 MHz); implied sub-kHz when >= 1.8 MHz: last two digits 12/37/62/87 -> +0.50 kHz, 06/31/56/81 -> +0.25, 18/43/68/93 -> +0.75", "N", "MAIN unpack 0x3FB70..0x3FBBA; pack 0x3FDE6..0x3FDF0", "byte-confirmed"),
("MEMORY.dat", "rec+0x05", "1", "bits0-3 -> state+4; bits4-5 -> state+0x24 b4-5; bits6-7 -> state+1", "bitfield", "N", "MAIN 0x3FBC0..0x3FBDC; 0x3FD6A..0x3FD82", "split byte-confirmed; meanings unknown"),
("MEMORY.dat", "rec+0x06", "2", "name attribute word (always written together with the name)", "u16 BE, unknown bits", "N", "MAIN 0x3FBE0; 0x3A8E2 writes rec+6..rec+0x17 as one 0x12-byte unit", "position byte-confirmed; meaning inferred"),
("MEMORY.dat", "rec+0x08", "16", "channel name / tag", "16 bytes; all 0xFF = no name; character set not proven (ASCII inferred)", "N", "MAIN 0x3FBE8..0x3FC12; empty test sub_3A796 0x3A7B4", "length and 0xFF-empty byte-confirmed; charset inferred"),
("MEMORY.dat", "rec+0x18", "3", "second frequency (offset or split TX)", "same BCD + implied sub-kHz encoding as rec+0x02", "N", "MAIN 0x3FC18..0x3FC62; 0x3FDF4..0x3FDFE", "encoding byte-confirmed; role inferred"),
("MEMORY.dat", "rec+0x1B", "1", "CTCSS tone index 0..49 into the 50-tone table MAIN 0x35158 (default 12 = 100.0 Hz)", "u8 index", "N (not range-checked; >49 reads past the table)", "MAIN 0x3FC68 -> VFO+0x17; consumer 0x34BD4/0x34BFA; default 0x2606E", "byte-confirmed"),
("MEMORY.dat", "rec+0x1C", "1", "DCS code index 0..103 into table MAIN 0x5072", "u8 index", "N", "MAIN 0x3FC70 -> VFO+0x18; table search 0x2608E", "position byte-confirmed; DCS link strongly inferred"),
("MEMORY.dat", "rec+0x1D", "1", "bits0-4 -> state+0x22; bits5-7 -> state+0x23", "bitfield", "N", "MAIN 0x3FC78..0x3FC8C; 0x3FE12..0x3FE24", "split byte-confirmed; meanings unknown"),
("MEMORY.dat", "rec+0x1E", "1", "bits0-3 -> state+0x25; bits4-5 -> state+0x24 b0-1; bits6-7 -> state+0x24 b6-7", "bitfield", "N", "MAIN 0x3FC90..0x3FCB2; 0x3FE28..0x3FE42", "split byte-confirmed; meanings unknown"),
("MEMORY.dat", "rec+0x1F", "1", "bits0-2 -> state+0x26; bits3-7 -> state+0x27; bit7 selects the alternate working buffer 0xFF9102", "bitfield", "N", "MAIN 0x3FB0C..0x3FB38; 0x3FCB6..0x3FCC6; 0x3FEC4..0x3FECE", "split byte-confirmed; meanings unknown"),
("MEMORY.dat", "0xA180", "0x0080", "padding", "radio writes 0x00; included in the checksum; discarded on restore", "N", "MAIN writer 0x74BFE..0x74C20 (zero 0x300, read 0x280); reader 0x74F2A writes only 0x280", "byte-confirmed"),
("MEMORY.dat", "0xA200", "0x0048", "aux block EEPROM 0x1A000..0x1A047 (per-band u16 arrays at +0x18 and +0x30)", "u16 BE arrays", "N", "MAIN sub_3DE20 0x3DE24; sub_3DEA8 0x3DEB0/0x3DEC4", "addressing byte-confirmed; meaning unknown"),
("MEMORY.dat", "0xA248", "0x0038", "EEPROM 0x1A048..0x1A07F", "unknown; restored verbatim", "N", "MAIN 0x74C58 range", "byte-confirmed (in range)"),
("MEMORY.dat", "0xA280", "0x0898", "per-slot u16, slot n at 0xA280+2n (EEPROM 0x1A080+2n), 1100 entries", "u16 BE; meaning unknown (flag / bank-mask candidate)", "N", "MAIN sub_3DF1C 0x3DF20; loc_3DED2 stride 2", "addressing byte-confirmed; meaning unknown"),
("MEMORY.dat", "0xAB18", "0x0004", "checksum", "u32 BE = sum of bytes [0x0000,0xAB18) unsigned 8-bit, init 0, mod 2^32 (includes the 0xA180 padding)", "Y only AFTER data is already in EEPROM; mismatch -> marker stays 'MARU' -> MAIN restarts into default-init path", "MAIN writer 0x74D50..0x74D7A (-> 0xFF541E); reader 0x7503C..0x75094 vs 0xFF50B6", "byte-confirmed"),
("MEMORY.dat", "0xAB1C", "0x0164", "tail padding", "radio writes 0x00; not summed, not stored", "N", "MAIN 0x74D2A zero-fill; reader uses only 0x18 bytes of the last chunk (0x7506C)", "byte-confirmed"),
("MEMORY.dat", "(none)", "-", "no model/region header", "-", "N (MEMORY.dat is not model- or region-checked)", "MAIN restore sub_74DCA has no sub_737C8 call", "byte-confirmed"),
# ---------------- QSO / management ----------------
("QSOMNG.dat", "path", "0x20", r"\QSOLOG\QSOMNG.dat; exact size 0x20 required", "dir index 4", "Y (stat size==0x20, else not loaded)", "MAIN 0x6FFF8 cmp.l #0x20; 0x71066", "byte-confirmed"),
("QSOMNG.dat", "0x00", "0x10", "message-store management block (RAM 0xFEEF00); u16 @+0 = current/last message index, 0xFFFF = empty", "u16 BE + unknown; default 16 x 0xFF", "N (only 0xFFFF tested)", "MAIN 0x6F0B0, 0x6F0E6, 0x6F208; default ROM 0x6F4A6", "position byte-confirmed; semantics inferred"),
("QSOMNG.dat", "0x10", "0x10", "picture-store management block (RAM 0xFEEF10); u16 @+0x10 same role", "u16 BE + unknown; default FF FF 00 01 FF..", "N (only 0xFFFF tested)", "MAIN 0x6F0EE, 0x6F316; default ROM 0x6F4B6", "position byte-confirmed; semantics inferred"),
("WAVMNG.dat", "path", "0x20", r"\QSOLOG\WAVMNG.dat voice-store management (RAM 0xFF304A)", "dir index 4; u16 @+0 index, 0xFFFF = empty", "N (only 0xFFFF tested)", "MAIN 0x71046, 0x6F0F6, 0x6F3D4; template 0x725A4", "position byte-confirmed; semantics inferred"),
("QSOPCTDIR.dat / QSOWAVDIR.dat / QSOMSGDIR.dat", "(n-1)*0x80", "0x80", "directory record n (1-based); request offset carries flag bit 0x40000000", "see QSO*DIR rec+ rows", "N", "MAIN 0x6F1C8..0x6F1E2, 0x6F2D6..0x6F2F0, 0x6F39C; templates 0x7218A/0x726D0/0x72A54 len 0x80", "stride byte-confirmed; flag meaning inferred"),
("QSO*DIR.dat", "rec+0x00", "4", "default 00 00 00 00", "unknown", "N", "default record ROM 0x6F534 (copied by 0x6F4C6)", "default byte-confirmed; meaning unknown"),
("QSO*DIR.dat", "rec+0x04", "42", "text field (default spaces)", "ASCII space-padded (callsign/message text inferred)", "N", "ROM 0x6F538", "default byte-confirmed; meaning inferred"),
("QSO*DIR.dat", "rec+0x2E", "18", "default zeros", "unknown", "N", "ROM 0x6F562", "default byte-confirmed"),
("QSO*DIR.dat", "rec+0x40", "16", "text field (default spaces)", "ASCII space-padded", "N", "ROM 0x6F574", "default byte-confirmed"),
("QSO*DIR.dat", "rec+0x50", "4", "default zeros", "unknown", "N", "ROM 0x6F584", "default byte-confirmed"),
("QSOPCTDIR.dat", "rec+0x54", "16", r"picture file base name: first 12 bytes + '.jpg' -> \PHOTO\<name>.jpg (dir index 5)", "ASCII; 0xFFFFFFFF in the first 4 bytes = none", "N (only 0xFFFFFFFF tested)", "MAIN 0x6F5FE..0x6F646; request 0x708B6 (dir 5)", "byte-confirmed"),
("QSO*DIR.dat", "rec+0x64", "20", "default 0xFF", "unknown", "N", "ROM 0x6F598", "default byte-confirmed"),
("QSO*DIR.dat", "rec+0x78", "8", "default zeros", "unknown", "N", "ROM 0x6F5AC", "default byte-confirmed"),
("QSOPCTFAT.dat / QSOWAVFAT.dat / QSOMSGFAT.dat", "n*4 (inferred)", "4", "allocation-table entry (RAM 0xFFBB0C)", "u32 BE (inferred); FAT-inside-a-file", "N", "templates 0x722B6/0x72766/0x72B80 len 4", "length byte-confirmed; indexing inferred"),
("QSOMSG.dat", "caller offset", "0x50", "message record unit (RAM 0xFFBB10 <- 0xFF061A)", "unknown", "N", "MAIN 0x6F16C, 0x6F294 (len 0x50); template 0x729BE", "length byte-confirmed; layout unknown"),
]

os.makedirs(os.path.join("ida", "out", "pc"), exist_ok=True)
with open(os.path.join("ida", "out", "pc", "L2-dat-layout.tsv"), "w", encoding="utf-8", newline="\n") as f:
    for r in (HDR,) + tuple(rows):
        assert len(r) == 8, r
        f.write("\t".join(r) + "\n")
print(len(rows), "rows")

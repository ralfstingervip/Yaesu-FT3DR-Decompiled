; service window 078106-07B753 inclusive
; image decrypted/FT3D_MAIN_ver102_EXP.bin
; sha256 8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce
; span 13902 bytes; code 078106-078545 (1088 bytes, 336 insns)
; oracle ida/out/h8s-decode/work/bu_all.tsv ; IDA cross-check ida-listing.txt


; ---- 078106 usb_init : clear 0xFEE010-0xFEE20F, snapshot IER, jsr usb_arm, set FFEE2D bit 2 ----
078106  7a 00 00 fe e0 10         mov.l #0xfee010,er0
07810C  0f c9                     mov.l #0x4,er1
07810E  01 0d 00 00               mov.l #0x0,@er0
078112  0a 90                     add.l er1,er0
078114  7a 20 00 fe e2 0c         cmp.l #0xfee20c,er0
07811A  43 f2                     bls .-14 (0x7810e)
07811C  6a 08 ee 04               mov.b @0xee04:16,r0l
078120  17 60                     extu.l #2,er0
078122  03 98 10 30               shll.l #0x18,er0
078126  6a 09 ee 05               mov.b @0xee05:16,r1l
07812A  17 61                     extu.l #2,er1
07812C  10 f9                     shll.l #16,er1
07812E  01 f0 64 10               or.l er1,er0
078132  6a 09 ee 06               mov.b @0xee06:16,r1l
078136  17 61                     extu.l #2,er1
078138  10 79                     shll.l #8,er1
07813A  01 f0 64 10               or.l er1,er0
07813E  7a 40 00 08 20 00         or.l #0x82000,er0
078144  01 00 6b a0 00 ff 62 f8   mov.l er0,@0xff62f8:32
07814C  18 99                     sub.b r1l,r1l
07814E  1a 80                     sub.l er0,er0
078150  5e 07 84 5a               jsr @0x7845a:24
078154  6a 18 ee 2d 70 20         bset #0x2,@0xee2d:16
07815A  54 70                     rts 

; ---- 07815C usb_service : polled ring check; jsr 0x0768A8 or arm TRG; jsr pump 0x076FC8 ----
07815C  01 00 6d f2               mov.l er2,@-er7
078160  7a 02 00 ff 62 88         mov.l #0xff6288,er2
078166  01 00 6f 21 00 44         mov.l @(0x44:16,er2),er1
07816C  01 00 6f 20 00 40         mov.l @(0x40:16,er2),er0
078172  1f 81                     cmp.l er0,er1
078174  47 06                     beq .+6 (0x7817c)
078176  5e 07 68 a8               jsr @0x768a8:24
07817A  40 2e                     bra .+46 (0x781aa)
07817C  01 00 6b 20 00 ff 63 58   mov.l @0xff6358:32,er0
078184  68 08                     mov.b @er0,r0l
078186  17 50                     extu.w r0
078188  6b 21 00 ff 63 f8         mov.w @0xff63f8:32,r1
07818E  1d 01                     cmp.w r0,r1
078190  46 18                     bne .+24 (0x781aa)
078192  6a 10 ee 00 73 40         btst #0x4,@0xee00:16
078198  47 10                     beq .+16 (0x781aa)
07819A  6a 28 00 ff 63 60         mov.b @0xff6360:32,r0l
0781A0  6a 88 ee 2c               mov.b r0l,@0xee2c:16
0781A4  6b f0 00 ff 63 f8         mov.w #0x0,@0xff63f8:32
0781AA  01 00 6f 21 00 54         mov.l @(0x54:16,er2),er1
0781B0  01 00 6f 20 00 50         mov.l @(0x50:16,er2),er0
0781B6  1f 81                     cmp.l er0,er1
0781B8  47 0a                     beq .+10 (0x781c4)
0781BA  7a 00 00 ff 62 d8         mov.l #0xff62d8,er0
0781C0  5e 07 6f c8               jsr @0x76fc8:24
0781C4  54 02                     rts/l er2

; ---- 0781C6 usb_clear : clear 0xFEE010-0xFEE20F and return; no direct reference ----
0781C6  7a 01 00 fe e0 10         mov.l #0xfee010,er1
0781CC  0f c8                     mov.l #0x4,er0
0781CE  01 0d 01 00               mov.l #0x0,@er1
0781D2  0a 81                     add.l er0,er1
0781D4  7a 21 00 fe e2 0c         cmp.l #0xfee20c,er1
0781DA  43 f2                     bls .-14 (0x781ce)
0781DC  54 70                     rts 

; ---- 0781DE usb_init_twin : IER snapshot via er1, jsr usb_arm, set FFEE2D bit 2; no direct reference ----
0781DE  6a 09 ee 04               mov.b @0xee04:16,r1l
0781E2  17 61                     extu.l #2,er1
0781E4  03 98 10 31               shll.l #0x18,er1
0781E8  6a 08 ee 05               mov.b @0xee05:16,r0l
0781EC  17 60                     extu.l #2,er0
0781EE  10 f8                     shll.l #16,er0
0781F0  01 f0 64 01               or.l er0,er1
0781F4  6a 08 ee 06               mov.b @0xee06:16,r0l
0781F8  17 60                     extu.l #2,er0
0781FA  10 78                     shll.l #8,er0
0781FC  01 f0 64 01               or.l er0,er1
078200  7a 41 00 08 20 00         or.l #0x82000,er1
078206  01 00 6b a1 00 ff 62 f8   mov.l er1,@0xff62f8:32
07820E  18 99                     sub.b r1l,r1l
078210  1a 80                     sub.l er0,er0
078212  5e 07 84 5a               jsr @0x7845a:24
078216  6a 18 ee 2d 70 20         bset #0x2,@0xee2d:16
07821C  54 70                     rts 

; ---- 07821E sci_sleep : sleep; rts ----
07821E  01 80                     sleep 
078220  54 70                     rts 

; ---- 078222 sci_async : SCI SMR 0x08, BRR 0x0C, SCR 0 then 0x70 ----
078222  18 88                     sub.b r0l,r0l
078224  38 8a                     mov.b r0l,@0x8a:8
078226  f8 08                     mov.b #0x8,r0l
078228  38 88                     mov.b r0l,@0x88:8
07822A  f8 0c                     mov.b #0xc,r0l
07822C  38 89                     mov.b r0l,@0x89:8
07822E  18 88                     sub.b r0l,r0l
078230  0a 08                     inc r0l
078232  a8 ff                     cmp.b #0xff,r0l
078234  45 fa                     bcs .-6 (0x78230)
078236  f8 70                     mov.b #0x70,r0l
078238  38 8a                     mov.b r0l,@0x8a:8
07823A  54 70                     rts 

; ---- 07823C sci_async_twin : byte-identical SCI init ----
07823C  18 88                     sub.b r0l,r0l
07823E  38 8a                     mov.b r0l,@0x8a:8
078240  f8 08                     mov.b #0x8,r0l
078242  38 88                     mov.b r0l,@0x88:8
078244  f8 0c                     mov.b #0xc,r0l
078246  38 89                     mov.b r0l,@0x89:8
078248  18 88                     sub.b r0l,r0l
07824A  0a 08                     inc r0l
07824C  a8 ff                     cmp.b #0xff,r0l
07824E  45 fa                     bcs .-6 (0x7824a)
078250  f8 70                     mov.b #0x70,r0l
078252  38 8a                     mov.b r0l,@0x8a:8
078254  54 70                     rts 

; ---- 078256 sci_smr_brr : SMR 0x08 and BRR 0x0C only; no direct reference ----
078256  f8 08                     mov.b #0x8,r0l
078258  38 88                     mov.b r0l,@0x88:8
07825A  f8 0c                     mov.b #0xc,r0l
07825C  38 89                     mov.b r0l,@0x89:8
07825E  54 70                     rts 

; ---- 078260 ee32_burst : write r0 bytes from FF63AC to FFEE32 ----
078260  0d 08                     mov.w r0,e0
078262  19 11                     sub.w r1,r1
078264  0d 00                     mov.w r0,r0
078266  47 12                     beq .+18 (0x7827a)
078268  78 12 6a 20 00 ff 63 ac   mov.b @(0xff63ac:32,r1.w),r0h
078270  6a 80 ee 32               mov.b r0h,@0xee32:16
078274  0b 51                     inc.w #1,r1
078276  1d 81                     cmp.w e0,r1
078278  45 ee                     bcs .-18 (0x78268)
07827A  54 70                     rts 

; ---- 07827C usb_isr : pack IFR & IER, walk 10-byte handler table, jsr @er2 ----
07827C  01 30 6d f2               stm.l er2-er5,@-sp
078280  01 00 6d f6               mov.l er6,@-er7
078284  6a 09 ee 04               mov.b @0xee04:16,r1l
078288  17 61                     extu.l #2,er1
07828A  0f 92                     mov.l er1,er2
07828C  03 98 10 32               shll.l #0x18,er2
078290  6a 08 ee 05               mov.b @0xee05:16,r0l
078294  17 60                     extu.l #2,er0
078296  10 f8                     shll.l #16,er0
078298  01 f0 64 02               or.l er0,er2
07829C  6a 08 ee 06               mov.b @0xee06:16,r0l
0782A0  17 60                     extu.l #2,er0
0782A2  10 78                     shll.l #8,er0
0782A4  01 f0 64 02               or.l er0,er2
0782A8  7a 42 00 08 20 00         or.l #0x82000,er2
0782AE  01 00 6b a2 00 ff 62 f8   mov.l er2,@0xff62f8:32
0782B6  6a 09 ee 00               mov.b @0xee00:16,r1l
0782BA  0f 94                     mov.l er1,er4
0782BC  03 98 10 34               shll.l #0x18,er4
0782C0  6a 08 ee 01               mov.b @0xee01:16,r0l
0782C4  17 60                     extu.l #2,er0
0782C6  10 f8                     shll.l #16,er0
0782C8  01 f0 64 04               or.l er0,er4
0782CC  6a 08 ee 02               mov.b @0xee02:16,r0l
0782D0  17 60                     extu.l #2,er0
0782D2  10 78                     shll.l #8,er0
0782D4  01 f0 64 04               or.l er0,er4
0782D8  01 f0 66 24               and.l er2,er4
0782DC  18 aa                     sub.b r2l,r2l
0782DE  6a 29 00 ff 62 46         mov.b @0xff6246:32,r1l
0782E4  a9 ff                     cmp.b #0xff,r1l
0782E6  47 3a                     beq .+58 (0x78322)
0782E8  7a 05 00 ff 62 42         mov.l #0xff6242,er5
0782EE  0f d6                     mov.l er5,er6
0782F0  0f c0                     mov.l er4,er0
0782F2  01 00 69 61               mov.l @er6,er1
0782F6  01 f0 66 10               and.l er1,er0
0782FA  47 10                     beq .+16 (0x7830c)
0782FC  01 00 6f 62 00 06         mov.l @(0x6:16,er6),er2
078302  6e 69 00 04               mov.b @(0x4:16,er6),r1l
078306  0f c0                     mov.l er4,er0
078308  5d 20                     jsr @er2
07830A  40 16                     bra .+22 (0x78322)
07830C  0a 0a                     inc r2l
07830E  0c a9                     mov.b r2l,r1l
078310  01 cc 50 a1               mulxu.b #0xa,r1
078314  17 71                     extu.l er1
078316  0a d1                     add.l er5,er1
078318  0f 96                     mov.l er1,er6
07831A  6e 10 00 04               mov.b @(0x4:16,er1),r0h
07831E  a0 ff                     cmp.b #0xff,r0h
078320  46 ce                     bne .-50 (0x782f0)
078322  6a 08 ee 00               mov.b @0xee00:16,r0l
078326  6a 01 ee 01               mov.b @0xee01:16,r1h
07832A  6a 08 ee 02               mov.b @0xee02:16,r0l
07832E  01 00 6d 76               mov.l @er7+,er6
078332  54 35                     rts/l er2-er5

; ---- 078334 ring_fill : copy into a ring, then store struct+0x0D to FFEE2C ----
078334  01 20 6d f4               stm.l er4-er6,@-sp
078338  0f 95                     mov.l er1,er5
07833A  0f 84                     mov.l er0,er4
07833C  01 01 69 00               mov.l @(0x4:2,er0),er0
078340  68 08                     mov.b @er0,r0l
078342  17 50                     extu.w r0
078344  0d 06                     mov.w r0,r6
078346  47 2a                     beq .+42 (0x78372)
078348  01 02 69 40               mov.l @(0x8:2,er4),er0
07834C  68 01                     mov.b @er0,r1h
07834E  01 00 69 50               mov.l @er5,er0
078352  68 81                     mov.b r1h,@er0
078354  01 00 69 51               mov.l @er5,er1
078358  01 03 69 50               mov.l @(0xc:2,er5),er0
07835C  1f 81                     cmp.l er0,er1
07835E  45 06                     bcs .+6 (0x78366)
078360  01 08 25 05               mov.l @(0x8:2,er5),@er5
078364  40 08                     bra .+8 (0x7836e)
078366  0f 98                     mov.l #0x1,er0
078368  0a 81                     add.l er0,er1
07836A  01 00 69 d1               mov.l er1,@er5
07836E  1b 56                     dec.w #1,r6
078370  46 d6                     bne .-42 (0x78348)
078372  6e 49 00 0d               mov.b @(0xd:16,er4),r1l
078376  6a 89 ee 2c               mov.b r1l,@0xee2c:16
07837A  54 26                     rts/l er4-er6

; ---- 07837C ring_drain : copy out of a ring, store struct+0x0C to FFEE2C, return count ----
07837C  01 20 6d f4               stm.l er4-er6,@-sp
078380  0f 96                     mov.l er1,er6
078382  0f 84                     mov.l er0,er4
078384  01 01 69 00               mov.l @(0x4:2,er0),er0
078388  68 08                     mov.b @er0,r0l
07838A  17 50                     extu.w r0
07838C  0d 0d                     mov.w r0,e5
07838E  47 36                     beq .+54 (0x783c6)
078390  01 01 69 61               mov.l @(0x4:2,er6),er1
078394  01 00 69 60               mov.l @er6,er0
078398  1f 81                     cmp.l er0,er1
07839A  47 2a                     beq .+42 (0x783c6)
07839C  68 1d                     mov.b @er1,r5l
07839E  01 02 69 40               mov.l @(0x8:2,er4),er0
0783A2  68 8d                     mov.b r5l,@er0
0783A4  01 01 69 61               mov.l @(0x4:2,er6),er1
0783A8  01 03 69 60               mov.l @(0xc:2,er6),er0
0783AC  1f 81                     cmp.l er0,er1
0783AE  45 0a                     bcs .+10 (0x783ba)
0783B0  01 02 69 60               mov.l @(0x8:2,er6),er0
0783B4  01 01 69 e0               mov.l er0,@(0x4:2,er6)
0783B8  40 08                     bra .+8 (0x783c2)
0783BA  0f 98                     mov.l #0x1,er0
0783BC  0a 81                     add.l er0,er1
0783BE  01 01 69 e1               mov.l er1,@(0x4:2,er6)
0783C2  1b 5d                     dec.w #1,e5
0783C4  46 ca                     bne .-54 (0x78390)
0783C6  6e 49 00 0c               mov.b @(0xc:16,er4),r1l
0783CA  6a 89 ee 2c               mov.b r1l,@0xee2c:16
0783CE  01 01 69 41               mov.l @(0x4:2,er4),er1
0783D2  68 18                     mov.b @er1,r0l
0783D4  17 50                     extu.w r0
0783D6  19 d0                     sub.w e5,r0
0783D8  54 26                     rts/l er4-er6

; ---- 0783DA ring_move : copy between two rings unless the FF6330 byte is nonzero ----
0783DA  01 20 6d f4               stm.l er4-er6,@-sp
0783DE  0f 94                     mov.l er1,er4
0783E0  0f 86                     mov.l er0,er6
0783E2  01 00 6b 20 00 ff 63 30   mov.l @0xff6330:32,er0
0783EA  68 01                     mov.b @er0,r1h
0783EC  46 3c                     bne .+60 (0x7842a)
0783EE  01 01 69 41               mov.l @(0x4:2,er4),er1
0783F2  01 00 69 40               mov.l @er4,er0
0783F6  1f 81                     cmp.l er0,er1
0783F8  42 30                     bhi .+48 (0x7842a)
0783FA  1f 81                     cmp.l er0,er1
0783FC  47 28                     beq .+40 (0x78426)
0783FE  01 00 69 65               mov.l @er6,er5
078402  01 01 69 60               mov.l @(0x4:2,er6),er0
078406  1f 85                     cmp.l er0,er5
078408  47 1c                     beq .+28 (0x78426)
07840A  01 78 01 05               mov.b @er1,@er5
07840E  0f 98                     mov.l #0x1,er0
078410  01 09 06 10               add.l er0,@er6
078414  01 01 69 41               mov.l @(0x4:2,er4),er1
078418  0a 81                     add.l er0,er1
07841A  01 01 69 c1               mov.l er1,@(0x4:2,er4)
07841E  01 00 69 40               mov.l @er4,er0
078422  1f 81                     cmp.l er0,er1
078424  46 d8                     bne .-40 (0x783fe)
078426  19 00                     sub.w r0,r0
078428  54 26                     rts/l er4-er6
07842A  0f 10                     mov.w #0x1,r0
07842C  54 26                     rts/l er4-er6

; ---- 07842E load_be16 : r0 = mem[0]<<8 | mem[1]; no direct reference ----
07842E  01 00 6d f2               mov.l er2,@-er7
078432  0f 82                     mov.l er0,er2
078434  6e 09 00 01               mov.b @(0x1:16,er0),r1l
078438  17 51                     extu.w r1
07843A  68 20                     mov.b @er2,r0h
07843C  18 88                     sub.b r0l,r0l
07843E  64 10                     or.w r1,r0
078440  54 02                     rts/l er2

; ---- 078442 load_le16 : r0 = mem[1]<<8 | mem[0] ----
078442  01 00 6d f2               mov.l er2,@-er7
078446  0f 82                     mov.l er0,er2
078448  0f 99                     mov.l #0x1,er1
07844A  0a 92                     add.l er1,er2
07844C  6e 29 ff ff               mov.b @(0xffff:16,er2),r1l
078450  17 51                     extu.w r1
078452  68 20                     mov.b @er2,r0h
078454  18 88                     sub.b r0l,r0l
078456  64 10                     or.w r1,r0
078458  54 02                     rts/l er2

; ---- 07845A usb_arm : burst 0x32 bytes to FFEE32, IER0=0xCD, clear ISR0/1, ISR2=4 ----
07845A  79 00 00 32               mov.w #0x32,r0
07845E  5e 07 82 60               jsr @0x78260:24
078462  01 7d 40 cd ee 04         mov.b #0xcd,@0xee04:16
078468  6a d0 ee 05               mov.b #0x0,@0xee05:16
07846C  6a d0 ee 06               mov.b #0x0,@0xee06:16
078470  6a 08 ee 2d               mov.b @0xee2d:16,r0l
078474  e8 fc                     and.b #0xfc,r0l
078476  6a 88 ee 2d               mov.b r0l,@0xee2d:16
07847A  6a 18 ee 2f 70 10         bset #0x1,@0xee2f:16
078480  6a 08 ee 04               mov.b @0xee04:16,r0l
078484  17 60                     extu.l #2,er0
078486  03 98 10 30               shll.l #0x18,er0
07848A  6a 09 ee 05               mov.b @0xee05:16,r1l
07848E  17 61                     extu.l #2,er1
078490  10 f9                     shll.l #16,er1
078492  01 f0 64 10               or.l er1,er0
078496  6a 09 ee 06               mov.b @0xee06:16,r1l
07849A  17 61                     extu.l #2,er1
07849C  10 79                     shll.l #8,er1
07849E  01 f0 64 10               or.l er1,er0
0784A2  7a 40 00 08 20 00         or.l #0x82000,er0
0784A8  01 00 6b a0 00 ff 62 f8   mov.l er0,@0xff62f8:32
0784B0  6a d0 ee 08               mov.b #0x0,@0xee08:16
0784B4  6a d0 ee 09               mov.b #0x0,@0xee09:16
0784B8  6a d4 ee 0a               mov.b #0x4,@0xee0a:16
0784BC  54 70                     rts 

; ---- 0784BE queue_init_isr : handler mask 0x80000000: queue init, FFEE00=0x7F, FFEE28=0x73 ----
0784BE  7a 01 00 fe e0 08         mov.l #0xfee008,er1
0784C4  7a 00 00 ff 62 88         mov.l #0xff6288,er0
0784CA  01 01 69 81               mov.l er1,@(0x4:2,er0)
0784CE  01 00 69 81               mov.l er1,@er0
0784D2  f9 10                     mov.b #0x10,r1l
0784D4  01 00 6f 81 00 54         mov.l er1,@(0x54:16,er0)
0784DA  01 00 6f 81 00 50         mov.l er1,@(0x50:16,er0)
0784E0  f1 e1                     mov.b #0xe1,r1h
0784E2  01 00 6f 81 00 44         mov.l er1,@(0x44:16,er0)
0784E8  01 00 6f 81 00 40         mov.l er1,@(0x40:16,er0)
0784EE  6a f1 00 ff 62 40         mov.b #0x1,@0xff6240:32
0784F4  6b f0 00 ff 63 f8         mov.w #0x0,@0xff63f8:32
0784FA  01 7d 40 7f ee 00         mov.b #0x7f,@0xee00:16
078500  01 7d 40 73 ee 28         mov.b #0x73,@0xee28:16
078506  54 70                     rts 

; ---- 078508 queue_init : set FF6288 ring pointers equal and FF6240=1 ----
078508  7a 01 00 fe e0 08         mov.l #0xfee008,er1
07850E  7a 00 00 ff 62 88         mov.l #0xff6288,er0
078514  01 01 69 81               mov.l er1,@(0x4:2,er0)
078518  01 00 69 81               mov.l er1,@er0
07851C  f9 10                     mov.b #0x10,r1l
07851E  01 00 6f 81 00 54         mov.l er1,@(0x54:16,er0)
078524  01 00 6f 81 00 50         mov.l er1,@(0x50:16,er0)
07852A  f1 e1                     mov.b #0xe1,r1h
07852C  01 00 6f 81 00 44         mov.l er1,@(0x44:16,er0)
078532  01 00 6f 81 00 40         mov.l er1,@(0x40:16,er0)
078538  6a f1 00 ff 62 40         mov.b #0x1,@0xff6240:32
07853E  6b f0 00 ff 63 f8         mov.w #0x0,@0xff63f8:32
078544  54 70                     rts 

; ---- data 078546-07B753 ----
; switch displacements
078546  00 00 00 1c 00 36 00 50 00 6a 00 86 00 a2 00 bc
078556  00 d8 00 f4 01 10 01 2a 01 44 01 5e 01 7a 01 96
078566  01 b0 01 cc 01 e6 02 02 02 1c 02 36 02 50 02 6c
078576  02 86 02 a2 02 be 02 d8 02 f2 03 0c 03 26 03 42
078586  03 5c 03 78 03 94 03 ae 03 c8 03 e4 04 00 04 1a
078596  04 34 04 4c 04 64 04 7c 04 96 ff ff ff ff ff ff
0785A6  ff b1 b2 e0 b4 b5 d4 d5 d6 ed ff a7 a8 a9 aa ab
0785B6  e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec af ee ef ff
0785C6  ff ff ff ff f0 f1 f2 f3 f4 ff ff ff ff ff ac ad
0785D6  ae ff ff ff ff ff ff ff ff ff b3 b6 b7 b8 b9 ba
0785E6  bb bc bd be bf c0 c1 c2 c3 c4 f5 f6 f7 f8 f9 ca
0785F6  cb cc cd ce ff ff ff ff ff ff 30 21 30 22 30 23
078606  30 24 30 25 30 26 30 27 30 28 41 6a 4d 75 34 56
078616  30 29 32 71 39 67 41 78 34 3a 40 44 41 73 30 2a
078626  36 44 40 7a 40 56 3c 6b 39 24 3e 5a 36 47 5a 7c
078636  30 2b 4c 40 30 2c 3d 29 3e 26 3e 34 3e 3c 3e 3d
078646  39 38 4f 2f 49 4b 3e 4f 44 7c 4b 30 4a 72 30 2d
078656  30 2e 30 2f 33 29 3d 6c 35 73 4d 48 33 5c 46 34
078666  44 2b 4b 63 3b 7a 40 75 30 30 35 3d 41 2f 30 31
078676  30 32 42 2d 35 53 30 33 72 4d 4c 23 4d 42 30 34
078686  34 40 4d 37 35 58 32 41 4d 3f 32 39 43 48 46 2c
078696  3f 37 4a 55 45 76 30 35 30 36 38 7c 47 2e 3d 6b
0786A6  46 46 46 57 46 58 3d 5f 30 37 3d 38 3d 3c 30 38
0786B6  38 65 3a 2f 40 57 37 6a 49 6e 37 3b 30 39 3b 50
0786C6  4b 3d 4d 61 30 3a 34 6d 4c 7d 30 3e 41 46 40 76
0786D6  4d 3d 4d 72 41 68 32 7e 38 3d 35 42 30 3f 3a 5f
0786E6  4d 2d 4a 62 39 53 30 40 4b 22 43 38 30 41 4a 3b
0786F6  39 32 72 3a 30 42 30 43 30 44 30 45 30 46 30 47
078706  30 48 30 49 ff ff ff ff ff ff ff ff ff ff ff ff
078716  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078726  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078736  ff ff ff ff ff ff ff ff ff ff 30 4a 30 4b 30 4c
078746  30 4d 30 4e 30 4f 30 50 30 51 30 52 30 53 30 54
078756  30 55 30 56 30 57 30 58 30 59 30 5a 30 5b 30 5c
078766  30 5d 30 5e 30 5f 30 60 30 61 30 62 30 63 30 64
078776  30 65 30 66 30 67 38 40 32 48 4c 7e 30 43 44 76
078786  49 45 30 68 3f 68 42 29 40 2a 4a 30 33 68 40 38
078796  30 69 30 6a 34 76 39 54 43 53 37 46 37 2e 38 79
0787A6  37 69 3a 33 4d 26 34 52 40 50 41 43 40 74 30 6b
0787B6  4b 3b 35 5e 48 44 4d 4a 43 57 44 3a 3a 5c 44 4b
0787C6  45 69 5f 56 3b 6a 45 7e 4f 2b 30 6c 30 6d 3b 54
0787D6  67 75 43 78 30 6e 30 6f 3b 7c 38 5e 3b 65 31 44
0787E6  44 29 48 5d 38 24 58 7c 34 25 30 70 43 76 4c 3f
0787F6  35 27 30 71 3a 23 32 7c 34 77 30 72 4b 65 48 5c
078806  32 57 46 7e 35 6f 3c 4d 40 79 43 72 4d 46 3f 27
078816  3a 4c 34 64 48 58 3d 4b 5b 29 30 73 30 74 30 75
078826  30 76 30 77 30 78 30 79 30 7a 30 7b 30 7c 30 7d
078836  30 7e 31 21 31 22 31 23 31 24 31 25 32 3b ff ff
078846  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078856  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078866  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078876  ff ff ff ff ff ff ff ff ff ff 31 26 31 27 31 28
078886  31 29 31 2a 31 2b 31 2c 31 2d 4d 2d 3e 65 3f 22
078896  32 6e 35 32 31 2e 3b 47 40 7c 49 62 32 29 3c 75
0788A6  3e 35 46 30 45 46 31 2f 35 6d 3b 61 3c 3a 31 30
0788B6  31 31 47 76 31 32 61 56 31 33 31 34 32 4e 4d 58
0788C6  35 3f 31 63 46 62 31 35 31 36 42 47 37 62 46 24
0788D6  48 7e 3c 4c 41 4a 30 5c 31 47 34 6f 4f 53 41 42
0788E6  42 25 31 37 40 26 31 38 43 25 47 4f 31 39 3b 3a
0788F6  33 24 47 3f 47 5f 4b 64 36 33 37 49 31 3a 4e 22
078906  40 6a 31 65 3a 28 41 22 31 3b 47 64 31 3c 3d 61
078916  3c 3f 4e 6f 3d 25 4d 2b 34 72 3d 4f 4e 5a 31 3d
078926  31 3e 31 3f 31 40 ff ff ff ff ff ff ff ff ff ff
078936  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078946  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078956  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078966  ff ff ff ff ff ff ff ff ff ff 31 41 31 42 37 43
078976  39 3e 33 28 32 71 3d 45 4a 41 31 43 31 44 31 45
078986  31 46 31 47 31 48 31 49 31 4a 31 4b 31 4c 31 4d
078996  31 4e 31 4f 31 50 31 51 31 52 31 53 31 54 52 69
0789A6  49 41 31 55 31 56 31 57 31 58 3b 5e 31 59 31 5a
0789B6  31 5b 31 5c 31 5d 32 5c 32 7c 30 4e 41 2a 42 72
0789C6  36 5f 33 4d 46 40 31 5e 31 5f 31 60 31 61 31 62
0789D6  31 63 31 64 31 65 31 66 31 67 31 68 31 69 31 6a
0789E6  31 6b 31 6c 31 6d 31 6e 31 6f 31 70 31 71 31 72
0789F6  31 73 31 74 31 75 31 76 49 32 30 38 ff ff ff ff
078A06  ff ff ff ff ff ff ff ff ff ff 31 77 31 78 48 78
078A16  3d 6f 4d 3a 31 79 35 68 4f 37 31 7a 31 7b 31 7c
078A26  31 7d 31 7e 32 21 32 22 32 23 32 24 32 25 32 26
078A36  32 27 32 28 32 29 32 2a 32 2b 3a 79 44 49 40 70
078A46  42 67 42 3f 4a 24 4f 35 4b 31 4b 32 33 35 38 78
078A56  32 2c 35 56 4e 26 3f 2f 48 48 4b 41 47 52 32 2d
078A66  32 2e 59 5d 4a 64 35 2f 32 2f 32 30 32 31 32 32
078A76  43 56 41 77 42 23 43 59 32 33 42 55 36 3d 45 5c
078A86  4d 5e 4d 44 3d 24 3c 7d 47 3c 3d 47 40 4b 36 35
078A96  32 34 3f 64 3d 31 36 32 36 73 30 5a 34 59 4d 6e
078AA6  32 35 49 57 44 6f 43 4b 36 3c 4b 2c 53 79 4e 74
078AB6  4c 76 4d 59 3f 6a 36 43 46 31 35 34 49 60 33 46
078AC6  38 4a 42 53 36 31 33 50 45 2e 3f 43 3c 67 4c 4c
078AD6  3d 45 3b 57 41 5b 49 3d 3c 71 49 6b 3f 46 31 4b
078AE6  35 5a 39 5f 3f 25 40 5e 32 36 36 72 32 37 3d 2a
078AF6  32 38 32 39 32 3a 32 3b 31 73 70 2c 38 66 3d 77
078B06  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078B16  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078B26  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078B36  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078B46  ff ff ff ff ff ff ff ff ff ff 32 3c 32 3d 32 3e
078B56  32 3f 32 40 32 41 32 42 32 43 32 44 32 45 32 46
078B66  32 47 32 48 32 49 32 4a 32 4b 32 4c 32 4d 32 4e
078B76  32 4f 32 50 32 51 32 52 32 53 32 54 32 55 32 56
078B86  32 57 32 58 32 59 32 5a 32 5b 32 5c 32 5d 32 5e
078B96  32 5f 32 60 32 61 32 62 32 63 31 32 32 64 32 65
078BA6  32 66 32 67 32 68 32 69 32 6a 32 6b 32 6c 32 6d
078BB6  32 6e 32 6f 32 70 32 71 32 72 32 73 32 74 32 75
078BC6  32 76 32 77 32 78 32 79 32 7a 32 7b 32 7c 32 7d
078BD6  32 7e 33 21 33 22 33 23 33 24 33 25 33 26 33 27
078BE6  33 28 33 29 33 2a 33 2b 33 2c 33 2d 3a 66 44 59
078BF6  50 73 50 72 50 2a 33 2e 33 2f 33 30 33 31 33 32
078C06  33 33 33 34 33 35 33 36 33 37 33 38 33 39 33 3a
078C16  33 3b 33 3c 33 3d 3b 74 47 63 4a 56 49 76 38 5c
078C26  35 22 42 58 39 61 33 3e 37 30 37 47 6c 7b 36 40
078C36  36 7e 35 31 37 38 33 3f 33 40 33 41 33 42 33 43
078C46  38 30 38 42 33 44 33 45 33 46 33 47 33 48 33 49
078C56  33 4a 33 4b 33 4c 33 4d 33 4e 33 4f 33 50 33 51
078C66  33 52 33 53 33 54 33 55 33 56 33 57 3d 71 33 58
078C76  33 59 33 5a 33 5b 33 5c 32 3a 33 5d 31 22 31 46
078C86  36 6e 37 67 37 7c 45 52 4f 36 30 4f 33 5e 3b 31
078C96  3e 7e 33 5f 33 60 33 61 42 48 42 49 33 62 38 2d
078CA6  47 70 41 6c 42 5f 47 74 3f 74 4e 2b 49 77 33 63
078CB6  37 3f 38 2a 4a 52 4a 7d 37 78 39 45 45 28 37 41
078CC6  45 61 37 39 38 47 4a 50 38 6c 4b 35 33 64 33 65
078CD6  33 66 33 67 33 68 33 69 33 6a 33 6b 33 6c 33 6d
078CE6  33 6e 39 6e 3e 21 33 6f 37 4b 4e 48 4c 67 33 70
078CF6  48 61 41 55 4d 57 49 2c 36 62 3e 62 37 73 33 71
078D06  33 72 48 5f 33 73 33 74 33 75 49 73 45 2d 4a 49
078D16  33 76 33 77 33 78 33 79 4d 52 39 3d 3b 66 3f 40
078D26  48 31 4d 6b 33 7a 35 35 33 7b 3e 7a 32 2a 33 7c
078D36  33 7d 33 7e 34 21 61 5a 45 62 3f 49 31 28 42 4e
078D46  4d 6d 34 22 34 23 3c 5a 3c 6d 37 5a 48 60 38 4f
078D56  72 57 40 6e 42 26 48 69 34 24 42 65 4a 51 34 25
078D66  34 26 34 27 34 28 34 29 34 2a 34 2b 34 2c 34 2d
078D76  34 2e 34 2f 34 30 34 31 34 32 34 33 34 34 34 35
078D86  34 36 34 37 34 38 34 39 34 3a 34 3b 34 3c 34 3d
078D96  34 3e 34 3f 34 40 34 41 34 42 34 43 34 44 34 45
078DA6  34 46 34 47 34 48 34 49 34 4a 34 4b 34 4c 34 4d
078DB6  34 4e 34 4f 34 50 34 51 34 52 34 53 34 54 34 55
078DC6  34 56 34 57 34 58 34 59 34 5a 34 5b 34 5c 5f 73
078DD6  34 5d 34 5e 34 5f 34 60 34 61 34 62 34 63 34 64
078DE6  34 65 34 66 34 67 34 68 34 69 34 6a ff ff ff ff
078DF6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078E06  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078E16  ff ff ff ff ff ff ff ff ff ff 34 6b 34 6c 34 6d
078E26  34 6e 34 6f 34 70 34 71 34 72 34 73 34 74 34 75
078E36  34 76 34 77 34 78 34 79 34 7a 34 7b 34 7c 34 7d
078E46  34 7e 35 21 35 22 35 23 35 24 35 25 35 26 35 27
078E56  35 28 35 29 35 2a 35 2b 35 2c 35 2d 35 2e 35 2f
078E66  35 30 35 31 35 32 35 33 35 34 35 35 4d 68 4c 5a
078E76  3c 79 32 2b 73 4a 35 36 35 37 35 38 35 39 35 3a
078E86  35 3b 35 3c 35 3d 35 3e 35 3f 35 40 35 41 35 42
078E96  35 43 35 44 3e 43 35 45 35 46 35 47 38 7a 44 30
078EA6  4a 39 4d 78 48 5e 43 7b 39 6f 34 5f 72 65 3d 7d
078EB6  43 5b 65 2b 4b 4c 43 43 35 48 35 49 35 4a 35 4b
078EC6  35 4c 35 4d 38 51 38 28 35 4e 35 4f 32 67 35 50
078ED6  38 37 37 2f 38 78 37 68 34 4e 35 51 35 52 35 53
078EE6  35 54 35 55 31 31 35 56 35 57 35 58 35 59 35 5a
078EF6  35 5b 35 5c 35 5d 35 5e 35 5f 35 60 35 61 35 62
078F06  35 63 35 64 35 65 35 66 35 67 35 68 35 69 35 6a
078F16  35 6b 35 6c 35 6d 35 6e 35 6f 35 70 35 71 35 72
078F26  35 73 35 74 35 75 35 76 35 77 35 78 35 79 35 7a
078F36  35 7b 40 36 35 7c 35 7d 35 7e 36 21 36 22 36 23
078F46  36 24 36 25 36 26 36 27 36 28 36 29 36 2a 36 2b
078F56  36 2c 36 2d 36 2e 36 2f 36 30 36 31 36 32 36 33
078F66  36 34 36 35 36 36 36 37 36 38 36 39 36 3a 36 3b
078F76  36 3c 36 3d 36 3e 36 3f 36 40 36 41 36 42 36 43
078F86  36 44 36 45 36 46 36 47 36 48 71 2d 36 49 36 4a
078F96  36 4b 36 4c 37 79 36 4d 3f 6d 4c 38 3b 42 40 5a
078FA6  36 4e 3a 5d 36 4f 36 50 36 51 36 52 36 53 36 54
078FB6  36 55 36 56 36 57 36 58 36 59 36 5a 36 5b 36 5c
078FC6  36 5d 36 5e 36 5f 36 60 36 61 36 62 36 63 36 64
078FD6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078FE6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
078FF6  ff ff ff ff ff ff ff ff ff ff 36 65 36 66 36 67
079006  36 68 36 69 36 6a 36 6b 36 6c 36 6d 36 6e 36 6f
079016  36 70 35 57 36 71 36 72 36 73 36 74 39 3a 36 75
079026  36 76 36 77 36 78 36 79 37 54 45 23 33 67 41 70
079036  3a 3f 49 65 36 7a 36 7b 3a 43 37 5f 36 7c 3e 40
079046  46 6f 36 7d 33 6b 4c 74 4a 78 4a 4a 4a 35 34 49
079056  3a 55 38 7d 3f 30 35 60 36 7e 37 21 37 22 37 23
079066  37 24 34 32 37 25 39 71 4b 2e 47 5b 37 5b 3c 73
079076  37 26 37 27 37 28 35 62 3c 60 41 48 37 29 31 40
079086  43 58 46 5e 32 79 30 48 41 52 42 22 30 45 30 4c
079096  33 53 48 66 37 2a 37 2b 4d 68 50 54 36 38 3c 56
0790A6  38 62 4a 6b 39 75 37 2c 37 2d 32 43 3e 5c 34 6b
0790B6  37 2e 37 2f 37 30 37 31 37 32 37 33 37 34 ff ff
0790C6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0790D6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0790E6  ff ff ff ff ff ff ff ff ff ff 37 35 37 36 37 37
0790F6  32 48 4c 53 37 38 37 39 37 3a 37 3b 37 3c 37 3d
079106  37 3e 37 3f 37 40 37 41 37 42 37 43 37 44 37 45
079116  37 46 37 47 37 48 37 49 37 4a 37 4b 37 4c 37 4d
079126  37 4e 37 4f 37 50 37 51 37 52 37 53 37 54 37 55
079136  37 56 37 57 37 58 37 59 37 5a 37 5b 37 5c 37 5d
079146  37 5e 37 5f 37 60 37 61 37 62 37 63 37 64 3a 6f
079156  37 65 37 66 37 67 37 68 37 69 37 6a 37 6b 37 6c
079166  37 6d 37 6e 31 6c 3d 43 3d 33 37 6f 37 70 37 71
079176  37 72 37 73 37 74 37 75 37 76 37 77 37 78 37 79
079186  37 7a 37 7b 37 7c 37 7d 37 7e 38 21 38 22 38 23
079196  38 24 38 25 38 26 38 27 38 28 38 29 38 2a 38 2b
0791A6  38 2c 38 2d 38 2e 38 2f 38 30 38 31 38 32 38 33
0791B6  38 34 38 35 38 36 38 37 38 38 38 39 38 3a 38 3b
0791C6  38 3c 38 3d 38 3e 38 3f 38 40 38 41 38 42 ff ff
0791D6  ff ff ff ff ff ff ff ff ff ff 38 43 38 44 38 45
0791E6  38 46 38 47 38 48 38 49 38 4a 38 4b 38 4c 38 4d
0791F6  38 4e 38 4f 38 50 38 51 38 52 38 53 38 54 38 55
079206  38 56 38 57 38 58 38 59 38 5a 38 5b 38 5c 38 5d
079216  3e 2e 3b 46 3b 52 32 55 60 68 38 5e 38 5f 38 60
079226  38 61 38 62 38 63 38 64 38 65 38 66 38 67 38 68
079236  38 69 38 6a 38 6b 38 6c 38 6d 38 6e 38 6f 38 70
079246  38 71 4e 78 47 3b 38 72 38 73 38 74 38 75 38 76
079256  38 77 38 78 38 79 38 7a 38 7b 38 7c 38 7d 38 7e
079266  39 21 39 22 39 23 39 24 39 25 39 26 39 27 39 28
079276  39 29 39 2a 39 2b 39 2c 39 2d 39 2e 39 2f 39 30
079286  39 31 39 32 39 33 39 34 39 35 39 36 39 37 39 38
079296  39 39 39 3a 39 3b 39 3c 39 3d 39 3e 39 3f 39 40
0792A6  39 41 39 42 39 43 39 44 39 45 39 46 39 47 39 48
0792B6  39 49 39 4a 39 4b 39 4c 39 4d 39 4e 39 4f 39 50
0792C6  39 51 39 52 39 53 39 54 39 55 39 56 39 57 39 58
0792D6  39 59 39 5a 39 5b 39 5c 39 5d 39 5e 39 5f 39 60
0792E6  39 61 39 62 39 63 40 41 62 2b 66 6a 39 64 39 65
0792F6  39 66 39 67 39 68 39 69 39 6a 39 6b 39 6c 39 6d
079306  48 6f 40 3c 31 5b 44 36 48 6e 37 34 49 39 45 60
079316  39 6e 39 6f 39 70 39 71 39 72 39 73 39 74 39 75
079326  43 2b 51 6e 41 66 39 76 42 5d 3e 47 36 65 3f 34
079336  3b 56 32 77 39 77 39 78 39 79 3e 3f 31 7e 45 7a
079346  39 7a 39 7b 39 7c 63 74 36 57 3b 76 3c 6c 47 21
079356  30 5b 3c 77 38 41 4d 7d 4a 34 35 71 37 7d 36 70
079366  39 7d 39 7e 4a 46 4e 71 44 28 36 45 3a 21 3a 22
079376  3b 26 45 3e 30 61 49 5d 32 75 3a 23 3a 24 3a 25
079386  3a 26 3a 27 3a 28 3a 29 3a 2a 3a 2b 3a 2c 3a 2d
079396  3a 2e 3a 2f 3a 30 3a 31 3a 32 ff ff ff ff ff ff
0793A6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0793B6  ff ff ff ff ff ff ff ff ff ff 3a 33 3a 34 3a 35
0793C6  3a 36 3a 37 3a 38 3a 39 3a 3a 3a 3b 3a 3c 3a 3d
0793D6  3a 3e 3a 3f 3a 40 3a 41 3a 42 3a 43 3a 44 3a 45
0793E6  3a 46 3a 47 3a 48 3a 49 3a 4a 3a 4b 3a 4c 3a 4d
0793F6  3a 4e 3a 4f 3a 50 3a 51 3a 52 3a 53 3a 54 3a 55
079406  3a 56 3a 57 40 46 3a 58 63 37 3a 59 3a 5a 3a 5b
079416  3a 5c 3a 5d 3a 5e 3a 5f 3a 60 3a 61 3a 62 39 2c
079426  3c 57 3a 63 34 48 3a 64 3a 65 40 2d 36 2d 3a 66
079436  31 49 3a 67 41 5c 47 55 3a 68 35 7b 41 4c 35 55
079446  3a 69 3a 6a 94 33 3a 6b 3a 6c 40 68 3a 6d 3a 6e
079456  3a 6f 3a 70 3a 71 3a 72 3a 73 3a 74 3a 75 3a 76
079466  3a 77 3a 78 3f 5d 4e 76 3a 79 43 35 3a 7a 3c 72
079476  4a 4e 36 2b 48 72 44 73 3a 7b 3b 59 4a 7b 3a 7c
079486  3b 58 3b 49 41 5e 3c 78 4d 36 44 6a 3a 7d 3a 7e
079496  3b 21 3b 22 3b 23 3b 24 3b 25 3b 26 3b 27 3b 28
0794A6  3b 29 4e 24 41 6f 49 52 37 45 45 2f 4d 21 38 67
0794B6  3b 2a 3b 2b 3b 2c 3c 64 4e 54 4d 4d 4b 38 34 28
0794C6  3b 78 3b 2d 3e 64 3b 2e 39 39 3b 2f 31 6e 35 6e
0794D6  42 74 5f 37 41 7b 41 56 72 56 3e 63 3b 30 3b 31
0794E6  3b 32 3b 33 3b 34 3b 35 3b 36 3b 37 3b 38 3b 39
0794F6  3b 3a 3b 3b 3b 3c 3b 3d 3b 3e 3b 3f 3b 40 3b 41
079506  3b 42 3b 43 3b 44 ff ff ff ff ff ff ff ff ff ff
079516  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079526  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079536  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079546  ff ff ff ff ff ff ff ff ff ff 3b 45 3b 46 3b 47
079556  3b 48 3b 49 3b 4a 3b 4b 3b 4c 3b 4d 3b 4e 3b 4f
079566  3b 50 3b 51 3b 52 3b 53 3b 54 3b 55 3b 56 3b 57
079576  3b 58 3b 59 3b 5a 3b 5b 3b 5c 3b 5d 3b 5e 3b 5f
079586  3b 60 3b 61 3b 62 3b 63 3b 64 3b 65 3b 66 3b 67
079596  3b 68 3b 69 3b 6a 3b 6b 3b 6c 3b 6d 3b 6e 3b 6f
0795A6  3b 70 3b 71 3b 72 3b 73 3b 74 3b 75 4c 70 3b 76
0795B6  3b 77 3b 78 3b 79 3b 7a 3b 7b 3b 7c 3b 7d 3b 7e
0795C6  3c 21 3c 22 3c 23 3c 24 3c 25 3c 26 3c 27 3c 28
0795D6  3c 29 3c 2a 3c 2b 3c 2c 3c 2d 4f 29 43 4f 31 42
0795E6  35 54 3c 2e 31 76 44 2c 5b 59 3c 2f 3c 30 3c 31
0795F6  49 5f 3c 32 3c 33 3c 34 48 4b 48 59 4c 50 3c 35
079606  4c 6c 40 45 3c 36 45 29 44 40 44 43 32 3c 40 65
079616  4a 69 3c 37 3c 38 3c 39 3c 3a 3c 3b 3c 3c 3c 3d
079626  3c 3e 3c 3f 3c 40 3c 41 3c 42 6d 3f 3c 43 32 4a
079636  49 4a 3c 44 4e 3f 3c 45 47 26 3c 46 3c 47 3c 48
079646  3b 43 47 7b 3c 49 3a 71 3c 4a 45 67 45 68 44 79
079656  39 4a 41 7a 3c 4b 3c 4c 3c 4d 3c 4e 3c 4f 3c 50
079666  3c 51 3c 52 3c 53 3c 54 3c 55 3c 56 3c 57 3c 58
079676  3c 59 3c 5a 3c 5b 3c 5c 3c 5d 3c 5e 3c 5f 3c 60
079686  3c 61 3c 62 3c 63 3c 64 3c 65 3c 66 72 4f 43 7d
079696  3c 67 3c 68 3c 69 3c 6a 3c 6b 3c 6c 3c 6d 3c 6e
0796A6  3c 6f 3c 70 3c 71 3c 72 3c 73 3c 74 3c 75 3c 76
0796B6  3c 77 3c 78 3c 79 3c 7a 3c 7b 3c 7c 3c 7d 3c 7e
0796C6  3d 21 3d 22 3d 23 3d 24 3d 25 3d 26 3d 27 3d 28
0796D6  3d 29 3d 2a 3d 2b 3d 2c 3d 2d 3d 2e 3d 2f 3d 30
0796E6  3d 31 3d 32 3d 33 3d 34 3d 35 3d 36 3d 37 3d 38
0796F6  3d 39 3d 3a 42 35 3d 3b 3d 3c 3d 3d 3d 3e 3d 3f
079706  3d 40 3d 41 3d 42 3d 43 3d 44 3d 45 3d 46 38 48
079716  3d 47 3d 48 3d 49 3d 4a 3d 4b 3d 4c 3d 4d 3d 4e
079726  3d 4f 3d 50 3d 51 3d 52 3d 53 3d 54 3d 55 3d 56
079736  3d 57 3d 58 3d 59 3d 5a 3d 5b 3d 5c 3d 5d 3d 5e
079746  3d 5f 3d 60 3d 61 3d 62 3d 63 3d 64 3d 65 3d 66
079756  3d 67 3d 68 3d 69 3d 6a 3d 6b 3d 6c 3d 6d 3d 6e
079766  3d 6f 3d 70 3d 71 3d 72 3d 73 3d 74 3d 75 3d 76
079776  3d 77 3d 78 3d 79 3d 7a 3d 7b 3d 7c 3d 7d 3d 7e
079786  3e 21 3e 22 3e 23 3e 24 3e 25 3e 26 3e 27 3e 28
079796  3e 29 3e 2a 3e 2b 3e 2c 3e 2d 3e 2e 3e 2f 3e 30
0797A6  3e 31 3e 32 3e 33 3e 34 3e 35 3e 36 3e 37 3e 38
0797B6  3e 39 3e 3a 3e 3b 3e 3c 3e 3d 3e 3e 3e 3f 3e 40
0797C6  3e 41 3e 42 3e 43 3e 44 3e 45 3e 46 3e 47 3e 48
0797D6  3e 49 3e 4a 3e 4b 3e 4c 3e 4d 3e 4e 3e 4f 3e 50
0797E6  3e 51 3e 52 3e 53 3e 54 3e 55 3e 56 3e 57 3e 58
0797F6  3e 59 3e 5a 3e 5b 3e 5c 3e 5d 3e 5e 3e 5f 3e 60
079806  3e 61 3e 62 3e 63 3e 64 3e 65 3e 66 3e 67 3e 68
079816  3e 69 3e 6a 3e 6b 3e 6c 3e 6d 3e 6e 3e 6f 3e 70
079826  3e 71 3e 72 3e 73 3e 74 3e 75 3e 76 3e 77 3e 78
079836  3e 79 3e 7a 3e 7b 46 6c 3e 7c 3e 7d 3e 7e 3f 21
079846  3f 22 3f 23 3f 24 3f 25 3f 26 3f 27 3f 28 3f 29
079856  3f 2a 3f 2b 44 34 3f 2c 42 60 40 4d 43 4e 30 75
079866  35 2d 47 72 3f 2d 3f 2e 3f 2f 3f 30 3f 31 3f 32
079876  3f 33 3f 34 3f 35 3f 36 3f 37 3f 38 3f 39 3f 3a
079886  3f 3b 3f 3c 3f 3d 3f 3e 3f 3f 62 43 3f 40 3f 41
079896  3f 42 3f 43 3f 44 3f 45 3f 46 3f 47 3f 48 3f 49
0798A6  3f 4a 3f 4b 3f 4c 40 36 46 78 4b 6a 44 45 3f 4d
0798B6  3f 4e 3f 4f 3f 50 3f 51 3f 52 3f 53 3f 54 3f 55
0798C6  3f 56 3f 57 3f 58 3f 59 ff ff ff ff ff ff ff ff
0798D6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0798E6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0798F6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079906  ff ff ff ff ff ff ff ff ff ff 3f 5a 3f 5b 3f 5c
079916  3f 5d 41 47 40 34 3d 27 41 63 3f 5e 3f 5f 3f 60
079926  46 2c 3f 61 3f 62 3f 63 3f 64 3f 65 3f 66 3f 67
079936  3f 68 3f 69 3f 6a 3f 6b 3f 6c 3f 6d 3f 6e 3b 40
079946  57 42 3f 6f 3f 70 3f 71 3f 72 3f 73 3f 74 3f 75
079956  3f 76 3f 77 35 5b 3f 78 4b 76 3b 51 37 64 3f 79
079966  3f 7a 32 61 39 25 46 29 35 5f 3e 2f 4a 65 32 70
079976  4a 63 4e 3c 3f 7b 40 28 3f 7c 37 72 72 3f 36 5a
079986  47 61 4e 6b 3c 62 72 69 4e 43 3f 4a 34 2b 3e 29
079996  41 26 3f 7d 38 27 3f 7e 4e 7c 47 51 3c 4e 34 7b
0799A6  3a 3d 3a 3b 42 28 5a 65 41 34 33 6a 45 7d 40 21
0799B6  36 79 43 3a 4b 4f 3a 51 3d 3b 40 22 3a 7e 3b 24
0799C6  31 54 3a 42 40 23 ff ff ff ff ff ff ff ff ff ff
0799D6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0799E6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0799F6  ff ff ff ff ff ff ff ff ff ff 40 24 40 25 40 26
079A06  3b 5c 47 58 40 27 40 28 40 29 40 2a 40 2b 40 2c
079A16  40 2d 40 2e 40 2f 40 30 40 31 40 32 40 33 40 34
079A26  40 35 40 36 40 37 40 38 40 39 40 3a 40 3b 40 3c
079A36  40 3d 40 3e 40 3f 40 40 40 41 40 42 40 43 40 44
079A46  40 45 40 46 3e 4a 30 66 4c 3b 40 47 40 48 40 49
079A56  40 4a 40 4b 40 4c 40 4d 40 4e 40 4f 40 50 40 51
079A66  40 52 40 53 40 54 40 55 40 56 40 57 40 58 40 59
079A76  34 58 33 31 31 61 4d 3c 40 5a 40 5b 40 5c 40 5d
079A86  40 5e 40 5f 40 60 40 61 40 62 40 63 40 64 40 65
079A96  36 39 47 77 39 36 36 5c 40 66 40 67 40 68 40 69
079AA6  40 6a 40 6b 40 6c 40 6d 40 6e 40 6f 40 70 40 71
079AB6  40 72 40 73 40 74 40 75 40 76 40 77 40 78 40 79
079AC6  40 7a 40 7b 40 7c 40 7d 40 7e 41 21 41 22 41 23
079AD6  41 24 41 25 41 26 41 27 41 28 41 29 41 2a 41 2b
079AE6  41 2c 41 2d 41 2e 41 2f 36 7c 42 37 41 30 41 31
079AF6  41 32 41 33 41 34 41 35 41 36 41 37 41 38 ff ff
079B06  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079B16  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079B26  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079B36  ff ff ff ff ff ff ff ff ff ff 41 39 41 3a 41 3b
079B46  41 3c 41 3d 41 3e 41 3f 41 40 41 41 41 42 41 43
079B56  41 44 41 45 41 46 41 47 41 48 41 49 41 4a 41 4b
079B66  41 4c 41 4d 41 4e 41 4f 41 50 41 51 41 52 41 53
079B76  41 54 41 55 41 56 41 57 41 58 41 59 41 5a 41 5b
079B86  41 5c 41 5d 41 5e 41 5f 41 60 41 61 41 62 41 63
079B96  41 64 41 65 41 66 41 67 41 68 41 69 41 6a 41 6b
079BA6  41 6c 41 6d 41 6e 41 6f 41 70 41 71 41 72 41 73
079BB6  41 74 41 75 41 76 41 77 41 78 41 79 41 7a 41 7b
079BC6  3d 21 4c 2b 31 68 37 2c 41 7c 41 7d 41 7e 42 21
079BD6  42 22 42 23 42 24 3e 5d 38 75 45 3a 42 25 42 26
079BE6  42 27 42 28 42 29 42 2a 42 2b 42 2c 42 2d 42 2e
079BF6  3a 49 42 2f 42 30 42 31 42 32 42 33 44 6c 43 6d
079C06  3a 36 30 69 42 34 42 35 33 30 48 77 42 36 31 60
079C16  31 71 40 77 36 75 44 66 48 3f 42 37 42 38 42 39
079C26  42 3a 42 3b 42 3c 42 3d ff ff 42 3e 42 3f 42 40
079C36  42 41 45 44 42 42 42 43 42 44 42 45 42 46 42 47
079C46  42 48 42 49 42 4a 42 4b 42 4c 42 4d 42 4e 42 4f
079C56  42 50 42 51 42 52 42 53 42 54 42 55 42 56 42 57
079C66  42 58 42 59 42 5a 42 5b 42 5c 42 5d 42 5e 42 5f
079C76  42 60 42 61 42 62 42 63 42 64 42 65 42 66 42 67
079C86  42 68 42 69 42 6a 44 6f 34 2e 40 64 45 5d 42 6b
079C96  35 2e 4e 34 39 62 96 7e 38 5f 39 4c 4a 75 42 6c
079CA6  42 6d 3f 45 3f 66 42 6e 42 6f 42 70 42 71 42 72
079CB6  42 73 42 74 42 75 42 76 42 77 42 78 42 79 42 7a
079CC6  4a 7a 4e 60 3e 22 39 2a 43 5f 43 79 42 7b 43 5d
079CD6  33 59 3e 66 35 23 49 70 37 72 4c 54 64 23 42 7c
079CE6  42 7d 72 43 33 4e 3d 75 31 67 37 48 3f 52 42 7e
079CF6  40 6f 46 2e 43 21 43 22 40 35 43 69 44 3e 3e 76
079D06  49 3a 35 4c 43 23 43 24 3a 5b 4e 29 4e 35 70 67
079D16  43 25 43 26 43 27 43 28 34 5b 3d 44 3d 5d 3d 62
079D26  4a 74 37 7a 4e 63 43 29 43 2a 43 2b 43 2c 3c 6f
079D36  33 5a 4d 6a 42 2b 45 59 4e 39 3f 29 35 65 36 4c
079D46  3c 6e 4e 6e 34 44 4d 71 3a 32 71 59 4e 2f 4c 5b
079D56  3b 72 4c 31 30 59 3b 6e 36 3a 4a 5d 4a 58 43 2d
079D66  43 2e 43 2f 3f 62 35 3a 49 36 43 30 43 31 43 32
079D76  43 33 43 34 43 35 43 36 43 37 43 38 43 39 43 3a
079D86  43 3b 43 3c 43 3d 43 3e 43 3f 43 40 43 41 43 42
079D96  43 43 48 3f 70 5a 43 44 43 45 43 46 43 47 43 48
079DA6  43 49 43 4a 43 4b 43 4c ff ff ff ff ff ff ff ff
079DB6  ff ff ff ff ff ff ff ff ff ff 43 4d 43 4e 43 4f
079DC6  43 50 43 51 43 52 43 53 43 54 43 55 43 56 43 57
079DD6  43 58 43 59 43 5a 3c 23 37 6c 40 69 3e 2e 36 61
079DE6  40 40 30 63 4e 4f 37 40 43 5b 43 5c 43 5d 43 5e
079DF6  43 5f 43 60 49 63 46 7d 3d 4c 43 61 43 62 39 2b
079E06  43 63 43 64 43 65 43 66 43 67 43 68 43 69 43 6a
079E16  43 6b 43 6c 43 6d 43 6e 43 6f 43 70 43 71 43 72
079E26  43 73 32 2d 43 74 43 75 43 76 43 77 43 78 43 79
079E36  3d 6f 43 7a 43 7b 43 7c 43 7d 43 7e 44 21 44 22
079E46  44 23 44 24 44 25 44 26 44 27 44 28 44 29 44 2a
079E56  44 2b 44 2c 44 2d 44 2e 44 2f 44 30 44 31 44 32
079E66  44 33 44 34 44 35 44 36 44 37 44 38 44 39 44 3a
079E76  44 3b 44 60 40 21 44 3c 44 3d 44 3e 3f 50 3b 36
079E86  44 3f 44 40 44 41 44 42 44 43 44 44 ff ff ff ff
079E96  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079EA6  ff ff ff ff ff ff ff ff ff ff 44 45 45 54 44 46
079EB6  44 47 44 48 44 49 44 4a 42 50 3f 6b 48 71 44 4b
079EC6  44 4c 3e 73 44 4d 44 4e 3b 48 3b 45 3b 4a 44 4f
079ED6  48 68 38 2f 44 50 37 6e 3c 21 3d 22 43 65 46 4d
079EE6  37 51 3b 4c 40 5c 34 79 3f 54 44 51 3d 7e 3a 6e
079EF6  41 4f 42 24 41 36 44 52 44 53 49 55 39 70 44 54
079F06  44 55 40 5b 45 41 45 5a 47 5d 45 7b 42 33 36 60
079F16  3f 35 44 69 38 5d 4a 71 44 56 36 50 45 58 4a 59
079F26  4c 33 39 4b 37 52 3e 6f 39 31 4a 67 44 57 42 43
079F36  44 58 4d 63 31 6d 4e 33 44 59 44 5a 44 5b 54 64
079F46  44 5c 3a 4a 3a 61 40 51 45 26 44 5d 4b 42 44 5e
079F56  35 4d 31 70 4f 2a 36 2f 39 64 4f 22 34 53 4e 73
079F66  44 5f 44 60 44 61 38 39 4c 22 37 75 ff ff ff ff
079F76  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079F86  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
079F96  ff ff ff ff ff ff ff ff ff ff 3c 6a 44 62 44 63
079FA6  44 64 44 65 44 66 44 67 44 68 44 69 44 6a 44 6b
079FB6  44 6c 44 6d 44 6e 44 6f 44 70 44 71 44 72 44 73
079FC6  44 74 44 75 44 76 44 77 44 78 44 79 44 7a 44 7b
079FD6  44 7c 44 7d 44 7e 45 21 45 22 45 23 45 24 42 4e
079FE6  45 25 45 26 45 27 45 28 45 29 45 2a 45 2b 45 2c
079FF6  45 2d 45 2e 45 2f 45 30 45 31 45 32 45 33 45 34
07A006  3b 7b 3e 48 3d 50 45 35 45 36 45 37 45 38 45 39
07A016  45 3a 45 3b 45 3c 45 3d 45 3e 45 3f 45 40 45 41
07A026  45 42 45 43 45 44 45 45 ff ff ff ff ff ff ff ff
07A036  ff ff ff ff ff ff ff ff ff ff 45 46 45 47 45 48
07A046  45 49 45 4a 45 4b 45 4c 45 4d 45 4e 45 4f 45 50
07A056  45 51 45 52 45 53 45 54 45 55 45 56 45 57 3f 5e
07A066  38 4d 45 58 45 59 45 5a 45 5b 45 5c 45 5d 45 5e
07A076  45 5f 45 60 45 61 45 62 45 63 45 64 45 65 45 66
07A086  45 67 45 68 45 69 45 6a 45 6b 45 6c 45 6d 45 6e
07A096  45 6f 45 70 45 71 45 72 45 73 45 74 45 75 45 76
07A0A6  45 77 45 78 45 79 45 7a 45 7b 45 7c 45 7d 45 7e
07A0B6  46 21 46 22 46 23 46 24 46 25 46 26 46 27 46 28
07A0C6  46 29 43 2a 46 2b 46 2c 46 2d 46 2e 36 4d 30 70
07A0D6  4c 64 46 2f 46 30 46 31 46 32 46 33 46 34 46 35
07A0E6  46 36 46 37 46 38 46 39 46 3a 46 3b 46 3c 21 39
07A0F6  46 3d 35 2e 42 3a 3d 3d 31 73 44 4c 45 30 4d 3b
07A106  46 3e 3b 7e 46 3f 46 40 46 41 46 42 46 43 46 44
07A116  46 45 46 46 32 72 40 62 38 26 46 47 46 48 46 49
07A126  4d 4f 4d 50 3f 6b 3d 6a 47 2f 3a 50 4d 78 3d 53
07A136  4a 44 46 4a 46 4b 46 4c 46 4d 46 4e 46 4f 42 5a
07A146  40 30 39 6c 3e 27 4e 59 45 42 46 50 48 62 48 74
07A156  4b 33 46 51 3b 5f 47 71 49 59 44 24 4e 31 36 21
07A166  36 26 43 52 4a 7e 4d 27 47 43 48 3c 46 52 38 57
07A176  42 2a 4a 61 46 53 44 3b 4e 3a 3a 56 3a 4e 3b 23
07A186  3c 39 3c 68 46 54 45 25 46 55 46 56 46 57 46 58
07A196  46 59 46 5a 46 5b 46 5c 46 5d 46 5e 46 5f 50 27
07A1A6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A1B6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A1C6  ff ff ff ff ff ff ff ff ff ff 46 60 46 61 47 3c
07A1D6  3a 5a 4c 3e 46 62 4c 35 4b 34 49 44 30 60 3c 23
07A1E6  43 66 43 67 44 39 31 4a 48 3e 44 2f 46 63 4e 2e
07A1F6  46 64 46 65 3d 6d 35 63 4c 44 30 56 32 25 43 32
07A206  45 6a 3e 70 4d 7c 32 58 46 66 46 67 46 68 32 46
07A216  32 7b 49 6f 3c 37 3c 50 32 3f 46 69 4a 55 6e 35
07A226  6e 34 31 74 72 50 6b 42 4a 42 47 48 4f 32 4e 5e
07A236  5e 25 47 3a 46 6a 3d 2c 4a 6f 4c 69 40 2e 34 37
07A246  46 6b 46 6c 46 6d 46 6e 46 6f 46 70 46 71 46 72
07A256  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A266  ff ff ff ff ff ff ff ff ff ff 46 73 46 74 46 75
07A276  46 76 3b 77 3c 51 32 59 46 77 3d 2d 36 6c 30 2e
07A286  46 78 46 79 41 7e 46 28 42 79 40 3e 46 7a 36 53
07A296  46 7b 72 59 35 36 34 66 46 7c 43 34 46 5f 46 7d
07A2A6  46 7e 47 21 47 22 47 23 44 6d 37 5c 47 24 47 25
07A2B6  47 26 47 27 3f 4d 3f 4e ff ff 47 28 4b 25 39 47
07A2C6  48 34 43 26 3c 67 45 70 49 5b 3e 42 45 49 ff ff
07A2D6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A2E6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A2F6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A306  ff ff ff ff ff ff ff ff ff ff 47 29 47 2a 32 3b
07A316  3b 52 3a 2c 43 4d 47 2b 34 6a 47 2c 47 2d 41 4d
07A326  45 4a 47 2e 4c 32 41 40 3f 32 4e 7d 4e 7b 4f 23
07A336  47 2f 47 30 47 31 47 32 47 33 47 34 41 33 ff ff
07A346  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A356  ff ff ff ff ff ff ff ff ff ff 47 35 47 36 47 37
07A366  47 38 4c 6e 47 39 47 3a 47 3b 47 3c 47 3d 47 3e
07A376  47 3f 47 40 38 2e 35 78 3b 44 3a 5c 47 41 3d 7c
07A386  4e 57 4b 3e 42 27 39 22 30 76 47 4d 3f 2d 31 64
07A396  3d 52 45 50 3e 3a 47 42 30 7b 46 5d 35 2a 35 2c
07A3A6  37 7b 38 52 45 35 4b 21 3e 68 3a 5c 3c 76 ff ff
07A3B6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A3C6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A3D6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A3E6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A3F6  ff ff ff ff ff ff ff ff ff ff 47 43 47 44 47 45
07A406  47 46 47 47 47 48 47 49 47 4a 47 4b 3b 75 3f 4f
07A416  51 63 4d 55 47 4c 47 4d 47 4e 47 4f 3e 6c 47 50
07A426  47 51 47 52 47 53 47 54 47 55 47 56 47 57 47 58
07A436  47 59 47 5a 47 5b 33 25 47 5c 47 5d 47 5e 47 5f
07A446  47 60 47 61 47 62 47 63 47 64 47 65 47 66 31 34
07A456  5f 64 46 7e 47 67 47 68 4a 68 39 5d 38 53 47 69
07A466  37 57 3b 70 3f 5e 42 2c 4e 4c 4b 45 47 6a 47 6b
07A476  47 6c 47 6d 47 6e 47 6f 47 70 47 71 47 72 47 73
07A486  47 74 47 75 47 76 47 77 41 5d 45 47 4d 7a 60 61
07A496  47 78 47 79 47 7a 47 7b 47 7c 47 7d 47 7e 4b 6b
07A4A6  60 53 46 45 37 63 4e 65 32 3d 48 21 48 22 31 3f
07A4B6  48 23 36 34 48 24 36 36 43 3c 44 74 48 25 3b 4f
07A4C6  3d 69 43 6c 41 76 43 51 4f 21 48 26 3f 2b 43 5a
07A4D6  48 27 48 28 34 7a 3f 41 48 29 4d 67 48 2a 48 2b
07A4E6  32 4c 72 60 46 2f 48 2c 48 2d 4b 2a 48 2e 48 2f
07A4F6  48 30 48 31 48 32 48 33 48 34 48 35 48 36 48 37
07A506  32 56 32 5a 49 21 48 38 4a 7c 4f 43 3f 53 4e 25
07A516  48 39 31 29 44 37 4a 6c 49 7d 36 52 41 4b 3e 4a
07A526  49 4d 5f 40 48 3a 72 67 41 61 42 2e 4e 53 48 3b
07A536  38 36 4a 22 4a 27 3f 4b 4e 42 3d 55 44 25 45 3d
07A546  4d 5a 4d 2a 4e 4b 40 32 3c 70 48 3c 48 3d 48 3e
07A556  48 3f 48 40 48 41 48 42 48 43 48 44 48 45 48 46
07A566  48 47 48 48 48 49 48 4a 48 4b 48 4c 48 4d 48 4e
07A576  48 4f 48 50 48 51 48 52 48 53 3a 64 3a 65 48 54
07A586  48 55 48 56 48 57 48 58 48 59 48 5a ff ff ff ff
07A596  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A5A6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A5B6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A5C6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A5D6  ff ff ff ff ff ff ff ff ff ff 48 5b 48 5c 48 5d
07A5E6  48 5e 48 5f 48 60 48 61 48 62 48 63 48 64 48 65
07A5F6  48 66 48 67 48 68 48 69 48 6a 48 6b 48 6c 48 6d
07A606  48 6e 48 6f 48 70 48 71 48 72 48 73 48 74 48 75
07A616  48 76 34 33 46 7c 4d 5b 32 50 45 74 48 77 48 78
07A626  48 79 48 7a 48 7b 48 7c 48 7d 48 7e 49 21 49 22
07A636  49 23 4e 64 39 35 45 6c 4a 48 38 77 49 24 49 25
07A646  4e 28 30 7a 48 54 3c 66 31 48 44 63 49 26 49 27
07A656  49 28 35 57 49 29 49 2a 40 3b 4f 44 4c 29 33 5b
07A666  3f 3b 3a 38 49 2b 49 2c 49 2d 49 2e 49 2f 34 3d
07A676  4d 53 31 51 3d 28 3f 4d 3f 4e 45 79 30 6c 46 37
07A686  46 48 3f 77 47 31 47 32 49 30 5b 58 36 41 32 4b
07A696  49 31 49 32 49 33 49 34 49 35 49 36 49 37 49 38
07A6A6  49 39 49 3a 49 3b 49 3c 49 3d 49 3e 49 3f 47 6f
07A6B6  4a 3c 70 3b 49 40 49 41 49 42 49 43 49 44 49 45
07A6C6  49 46 47 2d 56 22 4a 3f 33 2b 42 73 72 39 41 2e
07A6D6  49 47 49 48 43 6b 4b 5d 49 49 39 2d 57 22 47 6e
07A6E6  39 40 39 28 39 30 3d 26 49 4a 49 4b 49 4c 49 4d
07A6F6  49 4e 49 4f 49 50 49 51 4c 46 49 52 49 53 4a 58
07A706  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A716  ff ff ff ff ff ff ff ff ff ff 49 54 49 55 49 56
07A726  49 57 49 58 49 59 49 5a 49 5b 49 5c 49 5d 49 5e
07A736  49 5f 49 60 49 61 49 62 49 63 49 64 49 65 49 66
07A746  49 67 49 68 49 69 49 6a 49 6b 49 6c 49 6d 4a 62
07A756  39 39 6b 3e 49 6e 49 6f 49 70 49 71 49 72 49 73
07A766  49 74 49 75 49 76 49 77 45 2b 41 7d 3f 23 3f 3c
07A776  49 78 49 79 49 7a 49 7b 49 7c 49 7d 49 7e 4a 21
07A786  4a 22 4a 23 4a 24 3f 61 3f 21 34 5e 4b 44 42 5e
07A796  4b 3c 3a 49 40 61 46 23 32 28 4b 49 33 38 46 73
07A7A6  41 50 3b 25 46 5a 3a 46 4a 25 5e 3c 31 6f 4a 26
07A7B6  4a 27 4a 28 4a 29 4a 2a 50 47 49 2e 42 40 4a 2b
07A7C6  41 25 3d 2e 3b 4b 46 27 4f 3c 45 5f 72 5e 3f 36
07A7D6  38 45 35 6c 3f 4c 3f 28 4a 2c 4a 2d 4a 2e 4a 2f
07A7E6  4a 30 4a 31 4a 32 4a 33 4a 34 4a 35 4a 36 4a 37
07A7F6  4a 38 4a 39 32 63 ff ff ff ff ff ff ff ff ff ff
07A806  ff ff ff ff ff ff ff ff ff ff 4a 3a 4a 3b 4a 3c
07A816  4a 3d 4a 3e 4a 3f 4a 40 4a 41 4a 42 4a 43 4a 44
07A826  4a 45 49 53 4c 5f 4a 46 4a 47 4a 48 4a 49 4a 4a
07A836  4a 4b 33 56 4a 4c 4a 4d 4a 4e 39 48 3c 58 4a 4f
07A846  38 3a 37 50 4a 50 4a 51 4a 52 4a 53 4a 54 4a 55
07A856  4a 56 4a 57 4a 58 4a 59 4a 5a 4a 5b 4a 5c ff ff
07A866  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A876  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A886  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A896  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A8A6  ff ff ff ff ff ff ff ff ff ff 4a 5d 4a 5e 67 54
07A8B6  4a 5f 4a 60 4a 61 4a 62 4a 63 4a 64 4a 65 4a 66
07A8C6  31 3a 48 41 4a 67 4a 68 4a 69 4a 6a 4a 6b 4a 6c
07A8D6  4a 6d 4a 6e 32 34 4a 6f 4a 70 4a 71 4a 72 4a 73
07A8E6  4a 74 4a 75 4a 76 4a 77 4a 78 4a 79 4a 7a 4a 7b
07A8F6  4a 7c 4a 7d 4a 7e 4b 21 4b 22 4b 23 4b 24 4b 25
07A906  4b 26 4b 27 4b 28 4b 29 4b 2a 4b 2b 4b 2c 4b 2d
07A916  4b 2e 4b 2f 4b 30 4b 31 4b 32 30 29 4b 33 4b 34
07A926  4b 35 4b 36 4b 37 4b 38 4b 39 4b 3a 4b 3b 4b 3c
07A936  4b 3d 4b 3e 4b 3f 4b 40 4b 41 4b 42 4b 43 4b 44
07A946  4b 45 4b 46 4b 47 4b 48 4b 49 41 72 4b 4a 4b 4b
07A956  42 3e 4f 2f 4b 4c 4b 4d 4b 4e 4b 4f 4b 50 4b 51
07A966  4b 52 4b 53 4b 54 4c 5a 4c 37 38 58 43 3e 40 31
07A976  34 33 3a 59 37 56 6a 25 4b 55 4b 56 4b 57 4d 5f
07A986  44 78 4a 29 3b 5c 4b 58 39 7c 31 6a 31 6b 4d 40
07A996  46 36 4b 59 37 21 44 26 39 7b 4b 5a 4c 47 4b 5b
07A9A6  4b 5c 4b 5d 4b 5e 4b 5f 48 51 ff ff ff ff ff ff
07A9B6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A9C6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A9D6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07A9E6  ff ff ff ff ff ff ff ff ff ff 4b 60 4b 61 4b 62
07A9F6  4b 63 34 56 47 4f 3f 3f 4b 64 4b 65 4b 66 4b 67
07AA06  4b 68 4b 69 4a 46 3b 32 49 71 41 30 47 24 4f 45
07AA16  36 4a 4b 6a 3f 45 4b 52 4a 36 4b 6b 4b 6c 34 2c
07AA26  3b 35 4b 6d 4b 6e 49 69 42 39 40 3f 4b 6f 32 6d
07AA36  3e 3b 40 35 40 2f 3a 2e 38 72 4b 70 4b 71 41 24
07AA46  31 57 3e 23 5b 46 49 4f 4b 72 4b 73 4b 74 38 54
07AA56  3a 35 38 59 3d 56 48 43 44 2e 33 39 4b 75 4b 76
07AA66  4b 77 3e 3e 42 54 3a 57 4b 78 45 2a 41 6b 45 3b
07AA76  4f 47 34 63 33 58 4c 48 3e 37 62 41 38 38 4b 79
07AA86  46 26 3c 69 38 6e 31 52 4b 7a 48 7d 4c 42 35 47
07AA96  34 5d 31 5f 35 29 34 75 4b 7b 32 73 32 76 3c 7e
07AAA6  4b 7c 68 5f 4b 7d 4b 7e 4c 21 4c 22 52 44 ff ff
07AAB6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AAC6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AAD6  ff ff ff ff ff ff ff ff ff ff 4c 23 4c 24 4c 25
07AAE6  4c 26 4c 27 48 7e 3c 42 3f 48 4b 61 34 34 31 26
07AAF6  56 60 41 60 4c 28 43 3b 3b 34 3f 65 3f 70 38 50
07AB06  3c 2b 45 39 39 42 33 22 30 7c 4d 70 4d 74 46 3b
07AB16  4f 29 46 33 4b 7e 4c 29 4c 2a 38 77 3b 30 39 57
07AB26  47 27 4e 50 3f 69 4a 4b 33 27 4c 2b 39 41 46 6e
07AB36  38 3b 3d 39 4a 76 4a 77 4e 66 4c 2c 4c 2d 3c 2a
07AB46  35 5c 4c 2e 45 54 32 6d 4c 2f 4c 30 38 2b 34 51
07AB56  3f 47 3b 6b 34 47 4c 31 4c 32 4c 40 ff ff ff ff
07AB66  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AB76  ff ff ff ff ff ff ff ff ff ff 4c 33 4c 34 4c 35
07AB86  4c 36 4c 37 4c 38 4c 39 49 70 37 5e 40 4e 47 7e
07AB96  4c 3a 38 7e 47 6d 4a 73 4c 3b 43 6e 3f 2a 3e 78
07ABA6  46 71 37 6b 4c 3c 4a 5c 4f 3b 4b 53 35 75 3b 5d
07ABB6  36 3b 45 6f 42 3c 3b 67 37 32 3c 3c ff ff ff ff
07ABC6  ff ff ff ff ff ff ff ff ff ff 4c 5c 34 63 3d 77
07ABD6  32 6a 4c 3d 4c 3e 4c 3f 4c 40 4c 41 4c 42 4c 43
07ABE6  4c 44 4c 45 37 43 32 76 3d 64 48 53 4c 46 3b 73
07ABF6  3e 24 44 41 4c 47 4c 48 4c 49 4c 4a 4c 4b 4c 4c
07AC06  4c 4d ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AC16  ff ff ff ff ff ff ff ff ff ff 4c 4e 4c 4f 4c 50
07AC26  41 74 41 53 4c 51 4c 52 4c 53 4c 54 4c 55 4c 56
07AC36  4c 57 4c 58 4c 59 40 5f 3f 3d 37 58 4b 28 47 33
07AC46  4c 5a 4c 5b 4c 5c 4c 5d 40 78 4c 5e 4c 5f 4d 51
07AC56  3b 7d 4c 60 40 6c 4f 2e 38 35 32 3c 41 47 34 70
07AC66  4b 5c 35 61 4c 61 4a 2a 3c 54 4c 62 45 6d 42 5c
07AC76  3a 45 4c 63 3f 39 40 39 45 4e 4f 33 4c 64 4c 65
07AC86  4c 66 4c 67 4c 68 4a 38 4a 39 ff ff ff ff ff ff
07AC96  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07ACA6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07ACB6  ff ff ff ff ff ff ff ff ff ff 4c 69 4c 6a 4c 6b
07ACC6  4c 6c 4c 6d 4c 6e 4c 6f 4c 70 43 2b 32 30 32 48
07ACD6  3a 48 34 5b 4c 71 4c 72 4c 73 4c 74 4c 75 4c 76
07ACE6  3e 46 42 70 30 57 4d 25 4d 5c 3c 52 4c 77 30 42
07ACF6  39 2f 42 59 35 59 41 69 45 5b 48 2c 38 5b 3d 49
07AD06  4c 78 4d 4c 4c 79 47 54 47 4b 3b 33 49 42 30 47
07AD16  3c 2d 4c 7a 41 64 3d 40 46 70 4f 42 ff ff ff ff
07AD26  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AD36  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AD46  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AD56  ff ff ff ff ff ff ff ff ff ff 4c 7b 4c 7c 4c 7d
07AD66  4c 7e 4d 21 4d 22 45 72 4d 23 4d 24 4d 25 4d 26
07AD76  4d 27 4d 28 4d 29 4d 2a 4d 2b 4d 2c 4d 2d 4d 2e
07AD86  4d 2f 4d 30 4d 31 4d 32 4d 33 4d 34 4d 35 4d 36
07AD96  4d 37 4d 38 4d 39 4d 3a 4d 3b 4d 3c 38 4e 3e 32
07ADA6  40 63 39 54 40 42 3e 79 4b 2d 30 51 3b 58 35 5d
07ADB6  4c 34 34 4b 35 76 4d 49 ff ff ff ff ff ff ff ff
07ADC6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07ADD6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07ADE6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07ADF6  ff ff ff ff ff ff ff ff ff ff 4d 3d 4d 3e 4d 3f
07AE06  4d 40 4d 41 4d 42 40 24 42 65 4c 6b 4e 49 41 31
07AE16  3e 2c 4d 43 4d 44 4d 45 4d 46 4d 47 4d 48 4d 49
07AE26  4d 4a 4d 4b 4d 4c 4d 4d 4d 4e 4d 4f 4d 50 4d 51
07AE36  4d 52 4d 53 4d 54 4d 55 4d 56 4d 57 4d 58 4d 59
07AE46  4d 5a 4d 5b 4d 5c 39 78 3f 6c 4d 5d 4d 5e 4d 5f
07AE56  4d 60 4d 61 4d 62 4d 63 32 23 31 78 39 25 32 42
07AE66  4b 27 35 48 35 41 4d 33 41 75 3b 4d 4d 64 38 46
07AE76  46 49 31 53 32 47 34 73 30 4d 30 78 33 3b 34 6e
07AE86  40 6b 3c 65 ff ff ff ff ff ff ff ff ff ff ff ff
07AE96  ff ff ff ff ff ff ff ff ff ff 4d 65 4d 66 4d 67
07AEA6  59 47 4d 68 4d 69 4d 6a 4d 6b 4d 6c 4d 6d 4d 6e
07AEB6  4d 6f 33 5a 4d 70 4d 71 4d 72 4d 73 4d 74 4d 75
07AEC6  4d 76 4d 77 ff ff ff ff ff ff ff ff ff ff ff ff
07AED6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AEE6  ff ff ff ff ff ff ff ff ff ff 4d 78 4d 79 4d 7a
07AEF6  4d 7b 4d 7c 4d 7d 4d 7e 4e 21 4e 22 4e 23 4e 24
07AF06  4e 25 4e 26 4e 27 4e 28 4e 29 4e 2a 37 2a 4e 2b
07AF16  4e 2c 4e 2d 4e 2e 4e 2f 4e 30 4e 31 4e 32 4e 33
07AF26  4e 34 4e 35 4e 36 33 5e 4c 78 4e 37 4e 38 4e 39
07AF36  4e 3a 4e 3b 4e 3c 4e 3d 4e 3e 4e 3f 4e 40 4e 41
07AF46  4e 42 4e 43 4e 44 4e 45 4e 46 4e 47 4e 48 4e 49
07AF56  4e 4a 4e 4b 4e 4c 4e 4d 4e 4e 35 79 6d 52 4e 4f
07AF66  4e 50 4e 51 4e 52 4e 53 4e 54 4e 55 4e 56 4e 57
07AF76  4e 58 4e 59 4e 5a 4e 5b 4e 6b ff ff ff ff ff ff
07AF86  ff ff ff ff ff ff ff ff ff ff 4e 5c 4e 31 4e 2e
07AF96  4e 5d 4e 5e 4e 5f 4e 60 ff ff ff ff ff ff ff ff
07AFA6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AFB6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AFC6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07AFD6  ff ff ff ff ff ff ff ff ff ff 4e 61 4e 62 4e 63
07AFE6  4e 64 4e 65 4e 66 4e 67 4e 68 4e 69 4e 6a 4e 6b
07AFF6  4e 6c 4e 6d 4e 6e 4e 6f 4e 70 4c 61 4e 71 4e 72
07B006  4e 73 4e 74 4e 75 4e 76 4e 77 4e 78 4e 79 4e 7a
07B016  4e 7b 4e 7c 4e 7d 4e 7e 4f 21 4f 22 4f 23 ff ff
07B026  ff ff ff ff ff ff ff ff ff ff 4f 24 4f 25 4f 26
07B036  4f 27 4f 28 4f 29 4f 2a 4f 2b 4f 2c 4f 2d 4f 2e
07B046  4f 2f 4f 30 4f 31 4f 32 4f 33 4f 34 4f 35 4f 36
07B056  4f 37 4f 38 4f 39 4f 3a 4f 3b 4f 3c 4f 3d 4f 3e
07B066  4f 3f 3c 2f 4f 40 ff ff ff ff ff ff ff ff ff ff
07B076  ff ff ff ff ff ff ff ff ff ff 4f 41 4f 42 4f 43
07B086  4e 58 4f 44 4f 45 3c 63 4a 4c 4f 46 4a 5b 4f 47
07B096  4f 48 4a 28 4d 2f 4c 75 4a 2c 35 3b 36 48 3a 52
07B0A6  32 52 4f 49 36 4f 34 35 48 51 4b 3a 4c 4a 4c 49
07B0B6  3b 64 45 4f 45 32 4f 4a 4f 4b 3e 44 66 2b 4f 4c
07B0C6  4f 4d 4f 4e 3e 50 4f 4f 46 38 33 64 30 2d 32 66
07B0D6  38 63 4f 50 4f 51 4f 52 4f 53 ff ff ff ff ff ff
07B0E6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07B0F6  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07B106  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
07B116  ff ff ff ff ff ff ff ff ff ff 21 21 21 22 21 23
07B126  21 24 21 25 21 26 21 27 21 28 21 29 21 2a 21 2b
07B136  21 2c 21 2d 21 2e 21 2f 21 30 21 31 21 32 21 33
07B146  21 34 21 35 21 36 21 37 21 38 21 39 21 3a 21 3b
07B156  21 3c 21 3d 21 3e 21 3f 21 40 21 41 21 42 21 43
07B166  21 44 21 45 21 46 21 47 21 48 21 49 21 4a 21 4b
07B176  21 4c 21 4d 21 4e 21 4f 21 50 21 51 21 52 21 53
07B186  21 54 21 55 21 56 21 57 21 58 21 59 21 5a 21 5b
07B196  21 5c 21 5d 21 5e 21 5f 21 60 21 61 21 62 21 63
07B1A6  21 64 21 65 21 66 21 67 21 68 21 69 21 6a 21 6b
07B1B6  21 6c 21 6d 21 6e 21 6f 21 70 21 71 21 72 21 73
07B1C6  21 74 21 75 21 76 21 77 21 78 21 79 21 7a 21 7b
07B1D6  21 7c 21 7d 21 7e 22 21 22 22 22 23 22 24 22 25
07B1E6  22 26 22 27 22 28 22 29 22 2a 22 2b 22 2c 22 2d
07B1F6  22 2e 22 3a 22 3b 22 3c 22 3d 22 3e 22 3f 22 40
07B206  22 41 22 4a 22 4b 22 4c 22 4d 22 4e 22 4f 22 50
07B216  22 5c 22 5d 22 5e 22 5f 22 60 22 61 22 62 22 63
07B226  22 64 22 65 22 66 22 67 22 68 22 69 22 6a 22 72
07B236  22 73 22 74 22 75 22 76 24 70 24 71 25 70 25 71
07B246  26 38 26 41 26 42 26 43 26 45 26 48 26 4b 26 4c
07B256  26 50 26 56 26 58 ff ff ff ff 00 00 00 00 00 00
07B266  00 00 00 00 00 00 00 00 00 00 00 00 04 03 09 04
07B276  10 03 52 00 65 00 6e 00 65 00 73 00 61 00 73 00
07B286  1a 03 30 00 30 00 30 00 30 00 30 00 30 00 30 00
07B296  30 00 30 00 30 00 30 00 30 00 00 00 00 00 00 ff
; copied image FF6034
07B2A6  24 21 24 22 24 22 24 21 24 23 24 24 24 24 24 23
07B2B6  24 25 24 26 24 26 24 25 24 27 24 28 24 28 24 27
07B2C6  24 29 24 2a 24 2a 24 29 24 2b 24 2c 24 2c 24 2b
07B2D6  24 2d 24 2e 24 2e 24 2d 24 2f 24 30 24 30 24 2f
07B2E6  24 31 24 32 24 32 24 31 24 33 24 34 24 34 24 33
07B2F6  24 35 24 36 24 36 24 35 24 37 24 38 24 38 24 37
07B306  24 39 24 3a 24 3a 24 39 24 3b 24 3c 24 3c 24 3b
07B316  24 3d 24 3e 24 3e 24 3d 24 3f 24 40 24 40 24 3f
07B326  24 41 24 42 24 42 24 41 24 43 24 45 24 44 24 43
07B336  24 45 24 44 24 46 24 47 24 47 24 46 24 48 24 49
07B346  24 49 24 48 24 4f 24 50 24 50 24 51 24 51 24 4f
07B356  24 52 24 53 24 53 24 54 24 54 24 52 24 55 24 56
07B366  24 56 24 57 24 57 24 55 24 58 24 59 24 59 24 5a
07B376  24 5a 24 58 24 5b 24 5c 24 5c 24 5d 24 5d 24 5b
07B386  24 63 24 64 24 64 24 63 24 65 24 66 24 66 24 65
07B396  24 67 24 68 24 68 24 67 24 6e 24 6f 24 6f 24 6e
07B3A6  25 21 25 22 25 22 25 21 25 23 25 24 25 24 25 23
07B3B6  25 25 25 74 25 26 25 25 25 27 25 28 25 28 25 27
07B3C6  25 29 25 2a 25 2a 25 29 25 2b 25 75 25 2c 25 2b
07B3D6  25 2d 25 2e 25 2e 25 2d 25 2f 25 30 25 30 25 2f
07B3E6  25 31 25 76 25 32 25 31 25 33 25 34 25 34 25 33
07B3F6  25 35 25 36 25 36 25 35 25 37 25 38 25 38 25 37
07B406  25 39 25 3a 25 3a 25 39 25 3b 25 3c 25 3c 25 3b
07B416  25 3d 25 3e 25 3e 25 3d 25 3f 25 40 25 40 25 3f
07B426  25 41 25 42 25 42 25 41 25 43 25 45 25 44 25 43
07B436  25 45 25 44 25 46 25 47 25 47 25 46 25 48 25 49
07B446  25 49 25 48 25 4f 25 50 25 50 25 51 25 51 25 4f
07B456  25 52 25 53 25 53 25 54 25 54 25 52 25 55 25 56
07B466  25 56 25 57 25 57 25 55 25 58 25 59 25 59 25 5a
07B476  25 5a 25 58 25 5b 25 5c 25 5c 25 5d 25 5d 25 5b
07B486  25 63 25 64 25 64 25 63 25 65 25 66 25 66 25 65
07B496  25 67 25 68 25 68 25 67 25 6e 25 6f 25 6f 25 6e
07B4A6  25 74 25 26 25 75 25 2c 25 76 25 32 01 00 80 00
07B4B6  00 00 00 00 00 07 84 be 05 00 00 00 01 00 00 07
07B4C6  69 aa 08 00 00 00 00 00 00 07 68 c8 02 00 00 00
07B4D6  01 00 00 07 69 aa 40 00 00 00 05 00 00 07 67 be
07B4E6  10 00 00 00 04 00 00 07 68 a8 00 00 00 00 ff 00
07B4F6  00 00 00 00 00 fe e0 08 00 fe e0 08 00 fe e0 08
07B506  00 fe e0 10 00 00 00 00 00 00 00 00 00 00 00 00
07B516  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
07B526  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
07B536  00 00 00 00 00 fe e1 10 00 fe e1 10 00 fe e1 10
07B546  00 fe e2 0f 00 fe e0 10 00 fe e0 10 00 fe e0 10
07B556  00 fe e1 0f 00 fe e0 00 00 fe e0 00 00 fe e0 00
07B566  00 fe e0 07 ff ff ff ff 00 00 00 00 00 00 00 00
07B576  00 00 00 00 00 ff 64 20 00 ff ee 0e 00 04 03 01
07B586  00 00 08 00 00 00 00 00 00 ff 64 20 00 ff ee 0c
07B596  01 02 01 01 00 00 08 00 00 00 00 00 00 ff ee 24
07B5A6  00 ff ee 0d 01 02 02 01 00 00 08 00 03 00 00 02
07B5B6  00 ff 64 20 00 ff ee 18 40 00 40 08 00 00 08 00
07B5C6  02 00 00 01 00 ff 64 23 00 ff ee 14 10 00 10 04
07B5D6  00 00 40 00 01 00 00 01 00 ff ee 25 00 ff ee 10
07B5E6  00 20 20 02 00 00 40 00 12 00 00 ff 64 0e 00 43
07B5F6  00 ff 64 9f 04 00 00 07 b2 72 10 00 00 07 b2 76
07B606  00 00 00 07 b2 a2 1a 00 00 07 b2 86 00 00 00 07
07B616  b2 a3 00 00 00 07 b2 a4 00 00 10 00 00 15 20 80
07B626  00 01 25 28 80 00 02 34 38 10 00 03 00 00 00 00
07B636  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
07B646  00 00 00 00 00 00 00 00 00 00 00 96 00 00 00 00
07B656  08 00 08 00 00 ff 63 de 00 00 00 ff 64 25 01 00
07B666  00 ff 64 9e 00 00 00 00 00 00 ff 00 00 00 00 00
07B676  00 00 00 00 ff 00 00 00 00 00 12 01 10 01 02 00
07B686  00 08 aa 26 20 00 00 01 00 00 03 01 08 10 31 40
07B696  80 00 79 4d 41 4e 55 46 41 43 54 55 52 45 52 3a
07B6A6  41 43 4d 45 20 4d 61 6e 75 66 61 63 74 75 72 69
07B6B6  6e 67 3b 43 4f 4d 4d 41 4e 44 20 53 45 54 3a 50
07B6C6  43 4c 2c 4d 50 4c 3b 4d 4f 44 45 4c 3a 4c 61 73
07B6D6  65 72 42 65 61 6d 20 3f 3b 43 4f 4d 4d 45 4e 54
07B6E6  3a 41 6e 79 74 68 69 6e 67 20 79 6f 75 20 6c 69
07B6F6  6b 65 3b 41 43 54 49 56 45 20 43 4f 4d 4d 41 4e
07B706  44 20 53 45 54 3a 50 43 4c 3b 18 09 02 43 00 02
07B716  01 00 c0 10 09 04 00 00 01 02 02 01 00 05 24 00
07B726  10 01 04 24 02 06 05 24 06 00 01 05 24 01 03 01
07B736  07 05 83 03 08 00 10 09 04 01 00 02 0a 00 00 00
07B746  07 05 01 02 40 00 00 07 05 82 02 40 00 00

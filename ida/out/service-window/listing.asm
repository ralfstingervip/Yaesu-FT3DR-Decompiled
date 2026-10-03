; L95 service window 078106-07B753 inclusive
; sha256 8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce
; oracle: ida/out/h8s-decode/work/bu_all.tsv (binutils H8SX)
; bytes re-read from decrypted/FT3D_MAIN_ver102_EXP.bin
; 299 instructions, 950 code bytes, 7 routines


; -------- 078106  bytes 86  insns 24  ext_edges 2  internal_calls_from -
;   edge 002234 call  jsr @0x78106:24
;   edge 002234 raw  jsr @0x78106:24
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

; -------- 07815C  bytes 106  insns 26  ext_edges 2  internal_calls_from -
;   edge 05DD12 call  jsr @0x7815c:24
;   edge 05DD12 raw  jsr @0x7815c:24
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

; -------- 078222  bytes 26  insns 13  ext_edges 2  internal_calls_from -
;   edge 05DD9E call  jsr @0x78222:24
;   edge 05DD9E raw  jsr @0x78222:24
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

; -------- 078260  bytes 28  insns 10  ext_edges 1  internal_calls_from 07845E
;   edge 07845E raw  jsr @0x78260:24
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

; -------- 07827C  bytes 184  insns 57  ext_edges 2  internal_calls_from -
;   edge 054EB0 call  jsr @0x7827c:24
;   edge 054EB0 raw  jsr @0x7827c:24
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

; -------- 07837C  bytes 94  insns 34  ext_edges 2  internal_calls_from -
;   edge 0768BC call  jsr @0x7837c:24
;   edge 0768BC raw  jsr @0x7837c:24
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

; -------- 07845A  bytes 100  insns 26  ext_edges 1  internal_calls_from 078150,078212
;   edge 078150 raw  jsr @0x7845a:24
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

; -------- leftover reached insns (not in a routine body)
0781FC  01 f0 64 01               or.l er0,er1
078200  7a 41 00 08 20 00         or.l #0x82000,er1
078206  01 00 6b a1 00 ff 62 f8   mov.l er1,@0xff62f8:32
07820E  18 99                     sub.b r1l,r1l
078210  1a 80                     sub.l er0,er0
078212  5e 07 84 5a               jsr @0x7845a:24
078216  6a 18 ee 2d 70 20         bset #0x2,@0xee2d:16
07821C  54 70                     rts 
07821E  01 80                     sleep 
078220  54 70                     rts 
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
07842E  01 00 6d f2               mov.l er2,@-er7
078432  0f 82                     mov.l er0,er2
078434  6e 09 00 01               mov.b @(0x1:16,er0),r1l
078438  17 51                     extu.w r1
07843A  68 20                     mov.b @er2,r0h
07843C  18 88                     sub.b r0l,r0l
07843E  64 10                     or.w r1,r0
078440  54 02                     rts/l er2
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

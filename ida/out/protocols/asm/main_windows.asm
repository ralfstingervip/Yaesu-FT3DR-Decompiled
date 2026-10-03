; ==== dsp_link_driver  0005A000-0005B400 ====
0005A000  69d4                                mov.l   er4, @er5
0005A002  0b95                                adds    #4, er5
0005A004  010069d4                            mov.l   er4, @er5
0005A008  0b95                                adds    #4, er5
0005A00A  010069d4                            mov.l   er4, @er5
0005A00E  0b95                                adds    #4, er5
0005A010  010069d4                            mov.l   er4, @er5
0005A014  0b95                                adds    #4, er5
0005A016  010069d4                            mov.l   er4, @er5
0005A01A  0b95                                adds    #4, er5
0005A01C  010069d4                            mov.l   er4, @er5
0005A020  0b95                                adds    #4, er5
0005A022  010069d4                            mov.l   er4, @er5
0005A026  0b95                                adds    #4, er5
0005A028  010069d4                            mov.l   er4, @er5
0005A02C  0b95                                adds    #4, er5
0005A02E  790a0b01                            mov.w   #0xB01, e2
0005A032  fa00                                mov.b   #0, r2l
0005A034  01006b82b13e                        mov.l   er2, @0xFFFFB13E:16
0005A03A  5e058fa2                            jsr     sub_58FA2:24
0005A03E  5470                                rts
0005A040  7a0400000000             sub_5A040  mov.l   #0, er4  ; <<< FUNC sub_5A040
0005A046  7a0500ffb13e                        mov.l   #0xFFB13E, er5
0005A04C  010069d4                            mov.l   er4, @er5
0005A050  0b95                                adds    #4, er5
0005A052  010069d4                            mov.l   er4, @er5
0005A056  0b95                                adds    #4, er5
0005A058  010069d4                            mov.l   er4, @er5
0005A05C  0b95                                adds    #4, er5
0005A05E  010069d4                            mov.l   er4, @er5
0005A062  0b95                                adds    #4, er5
0005A064  010069d4                            mov.l   er4, @er5
0005A068  0b95                                adds    #4, er5
0005A06A  010069d4                            mov.l   er4, @er5
0005A06E  0b95                                adds    #4, er5
0005A070  010069d4                            mov.l   er4, @er5
0005A074  0b95                                adds    #4, er5
0005A076  010069d4                            mov.l   er4, @er5
0005A07A  0b95                                adds    #4, er5
0005A07C  f31c                                mov.b   #0x1C, r3h
0005A07E  6a0bb0b8                            mov.b   @0xFFFFB0B8:16, r3l
0005A082  6b83b13e                            mov.w   r3, @0xFFFFB13E:16
0005A086  6a0cb0b8                            mov.b   @0xFFFFB0B8:16, r4l
0005A08A  ac09                                cmp.b   #9, r4l
0005A08C  470a                                beq     loc_5A098:8
0005A08E  ac0d                                cmp.b   #0xD, r4l
0005A090  461c                                bne     loc_5A0AE:8
0005A092  6a0b8e2d                            mov.b   @0xFFFF8E2D:16, r3l
0005A096  4012                                bra     loc_5A0AA:8
0005A098  6a0c8e2b                 loc_5A098  mov.b   @0xFFFF8E2B:16, r4l
0005A09C  104c                                shll.b  #2, r4l
0005A09E  104c                                shll.b  #2, r4l
0005A0A0  100c                                shll.b  r4l
0005A0A2  6a0b8e2c                            mov.b   @0xFFFF8E2C:16, r3l
0005A0A6  eb1f                                and.b   #0x1F, r3l
0005A0A8  14cb                                or.b    r4l, r3l
0005A0AA  6a8bb140                 loc_5A0AA  mov.b   r3l, @0xFFFFB140:16
0005A0AE  5e058fa2                 loc_5A0AE  jsr     sub_58FA2:24
0005A0B2  5470                                rts
0005A0B4  f201                     sub_5A0B4  mov.b   #1, r2h  ; <<< FUNC sub_5A0B4
0005A0B6  fa12                                mov.b   #0x12, r2l
0005A0B8  7a0100ff4576                        mov.l   #0xFF4576, er1
0005A0BE  400a                                bra     loc_5A0CA:8
0005A0C0  f211                     sub_5A0C0  mov.b   #0x11, r2h  ; <<< FUNC sub_5A0C0
0005A0C2  fa06                                mov.b   #6, r2l
0005A0C4  7a0100ff4696                        mov.l   #0xFF4696, er1
0005A0CA  7a0400000000             loc_5A0CA  mov.l   #0, er4
0005A0D0  7a0500ffb13e                        mov.l   #0xFFB13E, er5
0005A0D6  010069d4                            mov.l   er4, @er5
0005A0DA  0b95                                adds    #4, er5
0005A0DC  010069d4                            mov.l   er4, @er5
0005A0E0  0b95                                adds    #4, er5
0005A0E2  010069d4                            mov.l   er4, @er5
0005A0E6  0b95                                adds    #4, er5
0005A0E8  010069d4                            mov.l   er4, @er5
0005A0EC  0b95                                adds    #4, er5
0005A0EE  010069d4                            mov.l   er4, @er5
0005A0F2  0b95                                adds    #4, er5
0005A0F4  010069d4                            mov.l   er4, @er5
0005A0F8  0b95                                adds    #4, er5
0005A0FA  010069d4                            mov.l   er4, @er5
0005A0FE  0b95                                adds    #4, er5
0005A100  010069d4                            mov.l   er4, @er5
0005A104  0b95                                adds    #4, er5
0005A106  7a0400000000                        mov.l   #0, er4
0005A10C  7a0500ffb15e                        mov.l   #0xFFB15E, er5
0005A112  010069d4                            mov.l   er4, @er5
0005A116  0b95                                adds    #4, er5
0005A118  010069d4                            mov.l   er4, @er5
0005A11C  0b95                                adds    #4, er5
0005A11E  010069d4                            mov.l   er4, @er5
0005A122  0b95                                adds    #4, er5
0005A124  010069d4                            mov.l   er4, @er5
0005A128  0b95                                adds    #4, er5
0005A12A  010069d4                            mov.l   er4, @er5
0005A12E  0b95                                adds    #4, er5
0005A130  010069d4                            mov.l   er4, @er5
0005A134  0b95                                adds    #4, er5
0005A136  010069d4                            mov.l   er4, @er5
0005A13A  0b95                                adds    #4, er5
0005A13C  010069d4                            mov.l   er4, @er5
0005A140  0b95                                adds    #4, er5
0005A142  7a0400000000                        mov.l   #0, er4
0005A148  7a0500ffb17e                        mov.l   #0xFFB17E, er5
0005A14E  010069d4                            mov.l   er4, @er5
0005A152  0b95                                adds    #4, er5
0005A154  010069d4                            mov.l   er4, @er5
0005A158  0b95                                adds    #4, er5
0005A15A  010069d4                            mov.l   er4, @er5
0005A15E  0b95                                adds    #4, er5
0005A160  010069d4                            mov.l   er4, @er5
0005A164  0b95                                adds    #4, er5
0005A166  010069d4                            mov.l   er4, @er5
0005A16A  0b95                                adds    #4, er5
0005A16C  010069d4                            mov.l   er4, @er5
0005A170  0b95                                adds    #4, er5
0005A172  010069d4                            mov.l   er4, @er5
0005A176  0b95                                adds    #4, er5
0005A178  010069d4                            mov.l   er4, @er5
0005A17C  0b95                                adds    #4, er5
0005A17E  fc15                                mov.b   #0x15, r4l
0005A180  6a8cb13e                            mov.b   r4l, @0xFFFFB13E:16
0005A184  6a82b13f                            mov.b   r2h, @0xFFFFB13F:16
0005A188  7a0600ffb140                        mov.l   #0xFFB140, er6
0005A18E  0f95                     loc_5A18E  mov.l   er1, er5
0005A190  7a1500000000                        add.l   #0, er5
0005A196  685c                                mov.b   @er5, r4l
0005A198  acff                                cmp.b   #0xFF, r4l
0005A19A  4606                                bne     loc_5A1A2:8
0005A19C  7a0500004c14                        mov.l   #0x4C14, er5
0005A1A2  79040005                 loc_5A1A2  mov.w   #5, r4
0005A1A6  7bd4598f                 loc_5A1A6  eepmov.w
0005A1AA  0d44                                mov.w   r4, r4
0005A1AC  46f8                                bne     loc_5A1A6:8
0005A1AE  7a1100000010                        add.l   #0x10, er1
0005A1B4  1a0a                                dec.b   r2l
0005A1B6  46d6                                bne     loc_5A18E:8
0005A1B8  5e058fa2                            jsr     sub_58FA2:24
0005A1BC  5470                                rts
0005A1BE  7ebc7330                 sub_5A1BE  btst    #3, @0xFFFFFFBC:8  ; <<< FUNC sub_5A1BE
0005A1C2  4722                                beq     loc_5A1E6:8
0005A1C4  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A1C6  6b0cfff6                            mov.w   @0xFFFFFFF6:16, e4
0005A1CA  792c8980                            cmp.w   #0x8980, e4
0005A1CE  4408                                bcc     loc_5A1D8:8
0005A1D0  734c                                btst    #4, r4l
0005A1D2  4608                                bne     loc_5A1DC:8
0005A1D4  5800015e                            bra     loc_5A336:16
0005A1D8  734c                     loc_5A1D8  btst    #4, r4l
0005A1DA  4706                                beq     loc_5A1E2:8
0005A1DC  724c                     loc_5A1DC  bclr    #4, r4l
0005A1DE  3cf5                                mov.b   r4l, @0xFFFFFFF5:8
0005A1E0  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A1E2  7fbc7230                 loc_5A1E2  bclr    #3, @0xFFFFFFBC:8
0005A1E6  6a0cb0a4                 loc_5A1E6  mov.b   @0xFFFFB0A4:16, r4l
0005A1EA  58a00148                            bpl     loc_5A336:16
0005A1EE  733c                                btst    #3, r4l
0005A1F0  58600142                            bne     loc_5A336:16
0005A1F4  7a060005c876                        mov.l   #unk_5C876, er6
0005A1FA  5e03f636                            jsr     sub_3F636:24
0005A1FE  6a2c00ffb0c7                        mov.b   @0xFFB0C7:32, r4l
0005A204  4734                                beq     loc_5A23A:8
0005A206  ac02                                cmp.b   #2, r4l
0005A208  471a                                beq     loc_5A224:8
0005A20A  ac03                                cmp.b   #3, r4l
0005A20C  462c                                bne     loc_5A23A:8
0005A20E  fc01                                mov.b   #1, r4l
0005A210  6a8cb0b5                            mov.b   r4l, @0xFFFFB0B5:16
0005A214  fc10                                mov.b   #0x10, r4l
0005A216  6a8cb0b7                            mov.b   r4l, @0xFFFFB0B7:16
0005A21A  fc03                                mov.b   #3, r4l
0005A21C  6a8cb11e                            mov.b   r4l, @0xFFFFB11E:16
0005A220  58000152                            bra     loc_5A376:16
0005A224  fc01                     loc_5A224  mov.b   #1, r4l
0005A226  6a8cb0b5                            mov.b   r4l, @0xFFFFB0B5:16
0005A22A  fc0b                                mov.b   #0xB, r4l
0005A22C  6a8cb0b7                            mov.b   r4l, @0xFFFFB0B7:16
0005A230  fc02                                mov.b   #2, r4l
0005A232  6a8cb11e                            mov.b   r4l, @0xFFFFB11E:16
0005A236  5800013c                            bra     loc_5A376:16
0005A23A  fc01                     loc_5A23A  mov.b   #1, r4l
0005A23C  6a8cb0b5                            mov.b   r4l, @0xFFFFB0B5:16
0005A240  fc02                                mov.b   #2, r4l
0005A242  6a8cb0b7                            mov.b   r4l, @0xFFFFB0B7:16
0005A246  fc00                                mov.b   #0, r4l
0005A248  6a8cb11e                            mov.b   r4l, @0xFFFFB11E:16
0005A24C  58000126                            bra     loc_5A376:16
0005A250  7ebc7330                 sub_5A250  btst    #3, @0xFFFFFFBC:8  ; <<< FUNC sub_5A250
0005A254  4722                                beq     loc_5A278:8
0005A256  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A258  6b0cfff6                            mov.w   @0xFFFFFFF6:16, e4
0005A25C  792c8980                            cmp.w   #0x8980, e4
0005A260  4408                                bcc     loc_5A26A:8
0005A262  734c                                btst    #4, r4l
0005A264  4608                                bne     loc_5A26E:8
0005A266  580000cc                            bra     loc_5A336:16
0005A26A  734c                     loc_5A26A  btst    #4, r4l
0005A26C  4706                                beq     loc_5A274:8
0005A26E  724c                     loc_5A26E  bclr    #4, r4l
0005A270  3cf5                                mov.b   r4l, @0xFFFFFFF5:8
0005A272  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A274  7fbc7230                 loc_5A274  bclr    #3, @0xFFFFFFBC:8
0005A278  6a0cb0a4                 loc_5A278  mov.b   @0xFFFFB0A4:16, r4l
0005A27C  58a000b6                            bpl     loc_5A336:16
0005A280  733c                                btst    #3, r4l
0005A282  586000b0                            bne     loc_5A336:16
0005A286  fc00                                mov.b   #0, r4l
0005A288  5470                                rts
0005A28A  7ebc7330                 sub_5A28A  btst    #3, @0xFFFFFFBC:8  ; <<< FUNC sub_5A28A
0005A28E  4722                                beq     loc_5A2B2:8
0005A290  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A292  6b0cfff6                            mov.w   @0xFFFFFFF6:16, e4
0005A296  792c8980                            cmp.w   #0x8980, e4
0005A29A  4408                                bcc     loc_5A2A4:8
0005A29C  734c                                btst    #4, r4l
0005A29E  4608                                bne     loc_5A2A8:8
0005A2A0  58000092                            bra     loc_5A336:16
0005A2A4  734c                     loc_5A2A4  btst    #4, r4l
0005A2A6  4706                                beq     loc_5A2AE:8
0005A2A8  724c                     loc_5A2A8  bclr    #4, r4l
0005A2AA  3cf5                                mov.b   r4l, @0xFFFFFFF5:8
0005A2AC  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A2AE  7fbc7230                 loc_5A2AE  bclr    #3, @0xFFFFFFBC:8
0005A2B2  6a0cb0a4                 loc_5A2B2  mov.b   @0xFFFFB0A4:16, r4l
0005A2B6  58a0007c                            bpl     loc_5A336:16
0005A2BA  733c                                btst    #3, r4l
0005A2BC  58600076                            bne     loc_5A336:16
0005A2C0  6a0cb0be                            mov.b   @0xFFFFB0BE:16, r4l
0005A2C4  5860006e                            bne     loc_5A336:16
0005A2C8  6a0cb0b9                            mov.b   @0xFFFFB0B9:16, r4l
0005A2CC  ac0a                                cmp.b   #0xA, r4l
0005A2CE  4712                                beq     loc_5A2E2:8
0005A2D0  ac09                                cmp.b   #9, r4l
0005A2D2  470e                                beq     loc_5A2E2:8
0005A2D4  ac0b                                cmp.b   #0xB, r4l
0005A2D6  470a                                beq     loc_5A2E2:8
0005A2D8  7a060005c876                        mov.l   #unk_5C876, er6
0005A2DE  5e03f636                            jsr     sub_3F636:24
0005A2E2  fc01                     loc_5A2E2  mov.b   #1, r4l
0005A2E4  6a8cb0b5                            mov.b   r4l, @0xFFFFB0B5:16
0005A2E8  fc0a                                mov.b   #0xA, r4l
0005A2EA  6a8cb0b7                            mov.b   r4l, @0xFFFFB0B7:16
0005A2EE  fc01                                mov.b   #1, r4l
0005A2F0  6a8cb11e                            mov.b   r4l, @0xFFFFB11E:16
0005A2F4  5800007e                            bra     loc_5A376:16
0005A2F8  7ebc7330                 sub_5A2F8  btst    #3, @0xFFFFFFBC:8  ; <<< FUNC sub_5A2F8
0005A2FC  4720                                beq     loc_5A31E:8
0005A2FE  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A300  6b0cfff6                            mov.w   @0xFFFFFFF6:16, e4
0005A304  792c8980                            cmp.w   #0x8980, e4
0005A308  4406                                bcc     loc_5A310:8
0005A30A  734c                                btst    #4, r4l
0005A30C  4606                                bne     loc_5A314:8
0005A30E  4026                                bra     loc_5A336:8
0005A310  734c                     loc_5A310  btst    #4, r4l
0005A312  4706                                beq     loc_5A31A:8
0005A314  724c                     loc_5A314  bclr    #4, r4l
0005A316  3cf5                                mov.b   r4l, @0xFFFFFFF5:8
0005A318  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A31A  7fbc7230                 loc_5A31A  bclr    #3, @0xFFFFFFBC:8
0005A31E  6a0cb0a4                 loc_5A31E  mov.b   @0xFFFFB0A4:16, r4l
0005A322  4a12                                bpl     loc_5A336:8
0005A324  733c                                btst    #3, r4l
0005A326  460e                                bne     loc_5A336:8
0005A328  fc01                                mov.b   #1, r4l
0005A32A  6a8cb0b5                            mov.b   r4l, @0xFFFFB0B5:16
0005A32E  fc15                                mov.b   #0x15, r4l
0005A330  6a8cb0b7                            mov.b   r4l, @0xFFFFB0B7:16
0005A334  4040                                bra     loc_5A376:8
0005A336  5e03ffa0                 loc_5A336  jsr     sub_3FFA0:24
0005A33A  fc01                                mov.b   #1, r4l
0005A33C  5470                                rts
0005A33E  6a0c8d20                            mov.b   @0xFFFF8D20:16, r4l
0005A342  58700080                            beq     loc_5A3C6:16
0005A346  7ebc7330                            btst    #3, @0xFFFFFFBC:8
0005A34A  4720                                beq     loc_5A36C:8
0005A34C  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A34E  6b0cfff6                            mov.w   @0xFFFFFFF6:16, e4
0005A352  792c8980                            cmp.w   #0x8980, e4
0005A356  4406                                bcc     loc_5A35E:8
0005A358  734c                                btst    #4, r4l
0005A35A  4606                                bne     loc_5A362:8
0005A35C  4068                                bra     loc_5A3C6:8
0005A35E  734c                     loc_5A35E  btst    #4, r4l
0005A360  4706                                beq     loc_5A368:8
0005A362  724c                     loc_5A362  bclr    #4, r4l
0005A364  3cf5                                mov.b   r4l, @0xFFFFFFF5:8
0005A366  2cf5                                mov.b   @0xFFFFFFF5:8, r4l
0005A368  7fbc7230                 loc_5A368  bclr    #3, @0xFFFFFFBC:8
0005A36C  6a0cb0a4                 loc_5A36C  mov.b   @0xFFFFB0A4:16, r4l
0005A370  4a54                                bpl     loc_5A3C6:8
0005A372  733c                                btst    #3, r4l
0005A374  4650                                bne     loc_5A3C6:8
0005A376  fc00                     loc_5A376  mov.b   #0, r4l
0005A378  6a8cb0ac                            mov.b   r4l, @0xFFFFB0AC:16
0005A37C  fc00                                mov.b   #0, r4l
0005A37E  6a8cb0bb                            mov.b   r4l, @0xFFFFB0BB:16
0005A382  6a0cb0b5                            mov.b   @0xFFFFB0B5:16, r4l
0005A386  4724                                beq     loc_5A3AC:8
0005A388  ac01                                cmp.b   #1, r4l
0005A38A  4708                                beq     loc_5A394:8
0005A38C  5e05a040                            jsr     sub_5A040:24
0005A390  fc00                                mov.b   #0, r4l
0005A392  4038                                bra     locret_5A3CC:8
0005A394  6a0cb0be                 loc_5A394  mov.b   @0xFFFFB0BE:16, r4l
0005A398  462c                                bne     loc_5A3C6:8
0005A39A  fc01                                mov.b   #1, r4l
0005A39C  6a8cb0bd                            mov.b   r4l, @0xFFFFB0BD:16
0005A3A0  6a0cb0b7                            mov.b   @0xFFFFB0B7:16, r4l
0005A3A4  6a8cb0be                            mov.b   r4l, @0xFFFFB0BE:16
0005A3A8  fc00                                mov.b   #0, r4l
0005A3AA  4020                                bra     locret_5A3CC:8
0005A3AC  6a0bb0b6                 loc_5A3AC  mov.b   @0xFFFFB0B6:16, r3l
0005A3B0  7a63000000ff                        and.l   #0xFF, er3
0005A3B6  1073                                shll.l  #2, er3
0005A3B8  78                                  .byte 0x78 ; x
0005A3B9  b06b                                subx    #0x6B, r0h ; 'k'
0005A3BB  2600                                mov.b   @0xFFFFFF00:8, r6h
0005A3BD  05a3                                xorc    #0xA3, ccr
0005A3BF  ce5d                                or.b    #0x5D, r6l
0005A3C1  60fc                                bset    r7l, r4l
0005A3C3  00                                  .byte    0
0005A3C4  4006                                bra     locret_5A3CC:8
0005A3C6  5e03ffa0                 loc_5A3C6  jsr     sub_3FFA0:24
0005A3CA  fc01                                mov.b   #1, r4l
0005A3CC  5470                     locret_5A3CC rts
0005A3CE  00                                  .byte    0
0005A3CF  058f                                xorc    #0x8F, ccr
0005A3D1  8600                                add.b   #0, r6h
0005A3D3  0590                                xorc    #0x90, ccr
0005A3D5  5e000592                            jsr     sub_592:24
0005A3D9  4000                                bra     loc_5A3DB:8
0005A3DB  059d                     loc_5A3DB  xorc    #0x9D, ccr
0005A3DD  8e00                                add.b   #0, r6l
0005A3DF  059e                                xorc    #0x9E, ccr
0005A3E1  1000                                shll.b  r0h
0005A3E3  059a                                xorc    #0x9A, ccr
0005A3E5  6e00059b                            mov.b   @(0x59B:16,er0), r0h
0005A3E9  ba00                                subx    #0, r2l
0005A3EB  059b                                xorc    #0x9B, ccr
0005A3ED  de00                                xor.b   #0, r6l
0005A3EF  059c                                xorc    #0x9C, ccr
0005A3F1  d600                                xor.b   #0, r6h
0005A3F3  058f                                xorc    #0x8F, ccr
0005A3F5  9400                                addx    #0, r4h
0005A3F7  059e                                xorc    #0x9E, ccr
0005A3F9  6600                                and.w   r0, r0
0005A3FB  059e                                xorc    #0x9E, ccr
0005A3FD  b600                                subx    #0, r6h
0005A3FF  059f                                xorc    #0x9F, ccr
0005A401  0000                                nop
0005A403  059f                                xorc    #0x9F, ccr
0005A405  a000                                cmp.b   #0, r0h
0005A407  059f                                xorc    #0x9F, ccr
0005A409  0400                                orc     #0, ccr
0005A40B  059f                                xorc    #0x9F, ccr
0005A40D  a400                                cmp.b   #0, r4h
0005A40F  059f                                xorc    #0x9F, ccr
0005A411  0800                                add.b   r0h, r0h
0005A413  059f                                xorc    #0x9F, ccr
0005A415  a800                                cmp.b   #0, r0l
0005A417  059f                                xorc    #0x9F, ccr
0005A419  0c00                                mov.b   r0h, r0h
0005A41B  059f                                xorc    #0x9F, ccr
0005A41D  ac00                                cmp.b   #0, r4l
0005A41F  059f                                xorc    #0x9F, ccr
0005A421  1000                                shll.b  r0h
0005A423  059f                                xorc    #0x9F, ccr
0005A425  b000                                subx    #0, r0h
0005A427  059f                                xorc    #0x9F, ccr
0005A429  1400                                or.b    r0h, r0h
0005A42B  059f                                xorc    #0x9F, ccr
0005A42D  b400                                subx    #0, r4h
0005A42F  059f                                xorc    #0x9F, ccr
0005A431  1800                                sub.b   r0h, r0h
0005A433  059f                                xorc    #0x9F, ccr
0005A435  b800                                subx    #0, r0l
0005A437  059f                                xorc    #0x9F, ccr
0005A439  1c00                                cmp.b   r0h, r0h
0005A43B  059f                                xorc    #0x9F, ccr
0005A43D  bc00                                subx    #0, r4l
0005A43F  059f                                xorc    #0x9F, ccr
0005A441  2000                                mov.b   @0xFFFFFF00:8, r0h
0005A443  059f                                xorc    #0x9F, ccr
0005A445  c000                                or.b    #0, r0h
0005A447  059f                                xorc    #0x9F, ccr
0005A449  2400                                mov.b   @0xFFFFFF00:8, r4h
0005A44B  059f                                xorc    #0x9F, ccr
0005A44D  c400                                or.b    #0, r4h
0005A44F  059f                                xorc    #0x9F, ccr
0005A451  2800                                mov.b   @0xFFFFFF00:8, r0l
0005A453  059f                                xorc    #0x9F, ccr
0005A455  c800                                or.b    #0, r0l
0005A457  059f                                xorc    #0x9F, ccr
0005A459  2c00                                mov.b   @0xFFFFFF00:8, r4l
0005A45B  059f                                xorc    #0x9F, ccr
0005A45D  cc00                                or.b    #0, r4l
0005A45F  059f                                xorc    #0x9F, ccr
0005A461  3000                                mov.b   r0h, @0xFFFFFF00:8
0005A463  059f                                xorc    #0x9F, ccr
0005A465  d000                                xor.b   #0, r0h
0005A467  059f                                xorc    #0x9F, ccr
0005A469  3400                                mov.b   r4h, @0xFFFFFF00:8
0005A46B  059f                                xorc    #0x9F, ccr
0005A46D  d400                                xor.b   #0, r4h
0005A46F  059f                                xorc    #0x9F, ccr
0005A471  3800                                mov.b   r0l, @0xFFFFFF00:8
0005A473  059f                                xorc    #0x9F, ccr
0005A475  d800                                xor.b   #0, r0l
0005A477  059f                                xorc    #0x9F, ccr
0005A479  3c00                                mov.b   r4l, @0xFFFFFF00:8
0005A47B  059f                                xorc    #0x9F, ccr
0005A47D  dcfc                     loc_5A47D  xor.b   #0xFC, r4l
0005A47F  09f4                                add.w   e7, r4
0005A481  00                                  .byte    0
0005A482  7a050005ae1e                        mov.l   #loc_5AE1E, er5
0005A488  7a0600ff2dc8                        mov.l   #0xFF2DC8, er6
0005A48E  7bd4598f                 loc_5A48E  eepmov.w
0005A492  0d44                                mov.w   r4, r4
0005A494  46f8                                bne     loc_5A48E:8
0005A496  7a0500ffb1a0                        mov.l   #0xFFB1A0, er5
0005A49C  6a0c8c28                            mov.b   @0xFFFF8C28:16, r4l
0005A4A0  ac03                                cmp.b   #3, r4l
0005A4A2  587008e6                            beq     loc_5AD8C:16
0005A4A6  ac05                                cmp.b   #5, r4l
0005A4A8  587008e0                            beq     loc_5AD8C:16
0005A4AC  f32c                                mov.b   #0x2C, r3h ; ','
0005A4AE  7a0100000000                        mov.l   #0, er1
0005A4B4  0f92                                mov.l   er1, er2
0005A4B6  685c                                mov.b   @er5, r4l
0005A4B8  ac20                                cmp.b   #0x20, r4l ; ' '
0005A4BA  4708                                beq     loc_5A4C4:8
0005A4BC  7a03204e616b                        mov.l   #0x204E616B, er3
0005A4C2  4006                                bra     loc_5A4CA:8
0005A4C4  7a032041636b             loc_5A4C4  mov.l   #0x2041636B, er3
0005A4CA  1b06                     loc_5A4CA  subs    #1, er6
0005A4CC  010069e3                            mov.l   er3, @er6
0005A4D0  0b96                                adds    #4, er6
0005A4D2  0b05                                adds    #1, er5
0005A4D4  f401                                mov.b   #1, r4h
0005A4D6  6c59                     loc_5A4D6  mov.b   @er5+, r1l
0005A4D8  0c9a                                mov.b   r1l, r2l
0005A4DA  1149                                shlr.b  #2, r1l
0005A4DC  1149                                shlr.b  #2, r1l
0005A4DE  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A4E2  68ec                                mov.b   r4l, @er6
0005A4E4  0b06                                adds    #1, er6
0005A4E6  ea0f                                and.b   #0xF, r2l
0005A4E8  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A4EC  68ec                                mov.b   r4l, @er6
0005A4EE  0b06                                adds    #1, er6
0005A4F0  1a04                                dec.b   r4h
0005A4F2  46e2                                bne     loc_5A4D6:8
0005A4F4  fc0d                                mov.b   #0xD, r4l
0005A4F6  68ec                                mov.b   r4l, @er6
0005A4F8  0b06                                adds    #1, er6
0005A4FA  fc0a                                mov.b   #0xA, r4l
0005A4FC  68ec                                mov.b   r4l, @er6
0005A4FE  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A504  5470                                rts
0005A506  fc09                                mov.b   #9, r4l
0005A508  f400                                mov.b   #0, r4h
0005A50A  7a050005ae1e                        mov.l   #loc_5AE1E, er5
0005A510  7a0600ff2dc8                        mov.l   #0xFF2DC8, er6
0005A516  7bd4598f                 loc_5A516  eepmov.w
0005A51A  0d44                                mov.w   r4, r4
0005A51C  46f8                                bne     loc_5A516:8
0005A51E  01006b05b13a                        mov.l   @0xFFFFB13A:16, er5
0005A524  6a0c8c28                            mov.b   @0xFFFF8C28:16, r4l
0005A528  ac03                                cmp.b   #3, r4l
0005A52A  5870085e                            beq     loc_5AD8C:16
0005A52E  ac05                                cmp.b   #5, r4l
0005A530  58700858                            beq     loc_5AD8C:16
0005A534  f32c                                mov.b   #0x2C, r3h ; ','
0005A536  7a0100000000                        mov.l   #0, er1
0005A53C  0f92                                mov.l   er1, er2
0005A53E  685c                                mov.b   @er5, r4l
0005A540  ac06                                cmp.b   #6, r4l
0005A542  58700388                            beq     loc_5A8CE:16
0005A546  ac07                                cmp.b   #7, r4l
0005A548  58700382                            beq     loc_5A8CE:16
0005A54C  ac08                                cmp.b   #8, r4l
0005A54E  587003f6                            beq     loc_5A948:16
0005A552  ac09                                cmp.b   #9, r4l
0005A554  476e                                beq     loc_5A5C4:8
0005A556  ac0a                                cmp.b   #0xA, r4l
0005A558  476a                                beq     loc_5A5C4:8
0005A55A  ac18                                cmp.b   #0x18, r4l
0005A55C  4748                                beq     loc_5A5A6:8
0005A55E  ac1a                                cmp.b   #0x1A, r4l
0005A560  474c                                beq     loc_5A5AE:8
0005A562  ac12                                cmp.b   #0x12, r4l
0005A564  58700164                            beq     loc_5A6CC:16
0005A568  ac1d                                cmp.b   #0x1D, r4l
0005A56A  587001de                            beq     loc_5A74C:16
0005A56E  ac0b                                cmp.b   #0xB, r4l
0005A570  587001ee                            beq     loc_5A762:16
0005A574  ac11                                cmp.b   #0x11, r4l
0005A576  5870014c                            beq     loc_5A6C6:16
0005A57A  ac19                                cmp.b   #0x19, r4l
0005A57C  58700556                            beq     loc_5AAD6:16
0005A580  ac16                                cmp.b   #0x16, r4l
0005A582  58700476                            beq     loc_5A9FC:16
0005A586  ac15                                cmp.b   #0x15, r4l
0005A588  58700752                            beq     loc_5ACDE:16
0005A58C  ac32                                cmp.b   #0x32, r4l ; '2'
0005A58E  5870013a                            beq     loc_5A6CC:16
0005A592  ac31                                cmp.b   #0x31, r4l ; '1'
0005A594  5870012e                            beq     loc_5A6C6:16
0005A598  ac1f                                cmp.b   #0x1F, r4l
0005A59A  586007ee                            bne     loc_5AD8C:16
0005A59E  7a030005af26                        mov.l   #loc_5AF26, er3
0005A5A4  5470                                rts
0005A5A6  7a030005af10             loc_5A5A6  mov.l   #loc_5AF10, er3
0005A5AC  5470                                rts
0005A5AE  6e5c0001                 loc_5A5AE  mov.b   @(1:16,er5), r4l
0005A5B2  4608                                bne     loc_5A5BC:8
0005A5B4  7a030005aed6                        mov.l   #loc_5AED6, er3
0005A5BA  4006                                bra     locret_5A5C2:8
0005A5BC  7a030005aec0             loc_5A5BC  mov.l   #loc_5AEC0, er3
0005A5C2  5470                     locret_5A5C2 rts
0005A5C4  6a0bb122                 loc_5A5C4  mov.b   @0xFFFFB122:16, r3l
0005A5C8  f401                                mov.b   #1, r4h
0005A5CA  6c59                     loc_5A5CA  mov.b   @er5+, r1l
0005A5CC  0c9a                                mov.b   r1l, r2l
0005A5CE  1149                                shlr.b  #2, r1l
0005A5D0  1149                                shlr.b  #2, r1l
0005A5D2  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A5D6  68ec                                mov.b   r4l, @er6
0005A5D8  0b06                                adds    #1, er6
0005A5DA  ea0f                                and.b   #0xF, r2l
0005A5DC  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A5E0  68ec                                mov.b   r4l, @er6
0005A5E2  0b06                                adds    #1, er6
0005A5E4  1a04                                dec.b   r4h
0005A5E6  46e2                                bne     loc_5A5CA:8
0005A5E8  68e3                                mov.b   r3h, @er6
0005A5EA  0b06                                adds    #1, er6
0005A5EC  f406                                mov.b   #6, r4h
0005A5EE  6c59                     loc_5A5EE  mov.b   @er5+, r1l
0005A5F0  0c9a                                mov.b   r1l, r2l
0005A5F2  1149                                shlr.b  #2, r1l
0005A5F4  1149                                shlr.b  #2, r1l
0005A5F6  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A5FA  68ec                                mov.b   r4l, @er6
0005A5FC  0b06                                adds    #1, er6
0005A5FE  ea0f                                and.b   #0xF, r2l
0005A600  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A604  68ec                                mov.b   r4l, @er6
0005A606  0b06                                adds    #1, er6
0005A608  1a04                                dec.b   r4h
0005A60A  46e2                                bne     loc_5A5EE:8
0005A60C  68e3                                mov.b   r3h, @er6
0005A60E  0b06                                adds    #1, er6
0005A610  ab02                                cmp.b   #2, r3l
0005A612  4428                                bcc     loc_5A63C:8
0005A614  f401                                mov.b   #1, r4h
0005A616  6c59                     loc_5A616  mov.b   @er5+, r1l
0005A618  0c9a                                mov.b   r1l, r2l
0005A61A  1149                                shlr.b  #2, r1l
0005A61C  1149                                shlr.b  #2, r1l
0005A61E  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A622  68ec                                mov.b   r4l, @er6
0005A624  0b06                                adds    #1, er6
0005A626  ea0f                                and.b   #0xF, r2l
0005A628  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A62C  68ec                                mov.b   r4l, @er6
0005A62E  0b06                                adds    #1, er6
0005A630  1a04                                dec.b   r4h
0005A632  46e2                                bne     loc_5A616:8
0005A634  68e3                                mov.b   r3h, @er6
0005A636  0b06                                adds    #1, er6
0005A638  fb17                                mov.b   #0x17, r3l
0005A63A  4002                                bra     loc_5A63E:8
0005A63C  fb18                     loc_5A63C  mov.b   #0x18, r3l
0005A63E  6c59                     loc_5A63E  mov.b   @er5+, r1l
0005A640  a903                                cmp.b   #3, r1l
0005A642  4714                                beq     loc_5A658:8
0005A644  a920                                cmp.b   #0x20, r1l ; ' '
0005A646  4504                                bcs     loc_5A64C:8
0005A648  a97f                                cmp.b   #0x7F, r1l
0005A64A  4502                                bcs     loc_5A64E:8
0005A64C  f93f                     loc_5A64C  mov.b   #0x3F, r1l ; '?'
0005A64E  68e9                     loc_5A64E  mov.b   r1l, @er6
0005A650  0b06                                adds    #1, er6
0005A652  1a0b                                dec.b   r3l
0005A654  46e8                                bne     loc_5A63E:8
0005A656  402c                                bra     loc_5A684:8
0005A658  f940                     loc_5A658  mov.b   #0x40, r1l ; '@'
0005A65A  68e9                                mov.b   r1l, @er6
0005A65C  0b06                                adds    #1, er6
0005A65E  fc2c                                mov.b   #0x2C, r4l ; ','
0005A660  68ec                                mov.b   r4l, @er6
0005A662  0b06                                adds    #1, er6
0005A664  f401                                mov.b   #1, r4h
0005A666  6c59                     loc_5A666  mov.b   @er5+, r1l
0005A668  0c9a                                mov.b   r1l, r2l
0005A66A  1149                                shlr.b  #2, r1l
0005A66C  1149                                shlr.b  #2, r1l
0005A66E  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A672  68ec                                mov.b   r4l, @er6
0005A674  0b06                                adds    #1, er6
0005A676  ea0f                                and.b   #0xF, r2l
0005A678  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A67C  68ec                                mov.b   r4l, @er6
0005A67E  0b06                                adds    #1, er6
0005A680  1a04                                dec.b   r4h
0005A682  46e2                                bne     loc_5A666:8
0005A684  f32c                     loc_5A684  mov.b   #0x2C, r3h ; ','
0005A686  68e3                                mov.b   r3h, @er6
0005A688  0b06                                adds    #1, er6
0005A68A  68e3                                mov.b   r3h, @er6
0005A68C  0b06                                adds    #1, er6
0005A68E  7a0500ffb15d                        mov.l   #0xFFB15D, er5
0005A694  f401                                mov.b   #1, r4h
0005A696  6c59                     loc_5A696  mov.b   @er5+, r1l
0005A698  0c9a                                mov.b   r1l, r2l
0005A69A  1149                                shlr.b  #2, r1l
0005A69C  1149                                shlr.b  #2, r1l
0005A69E  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A6A2  68ec                                mov.b   r4l, @er6
0005A6A4  0b06                                adds    #1, er6
0005A6A6  ea0f                                and.b   #0xF, r2l
0005A6A8  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A6AC  68ec                                mov.b   r4l, @er6
0005A6AE  0b06                                adds    #1, er6
0005A6B0  1a04                                dec.b   r4h
0005A6B2  46e2                                bne     loc_5A696:8
0005A6B4  fc0d                                mov.b   #0xD, r4l
0005A6B6  68ec                                mov.b   r4l, @er6
0005A6B8  0b06                                adds    #1, er6
0005A6BA  fc0a                                mov.b   #0xA, r4l
0005A6BC  68ec                                mov.b   r4l, @er6
0005A6BE  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A6C4  5470                                rts
0005A6C6  790c0007                 loc_5A6C6  mov.w   #7, e4
0005A6CA  4008                                bra     loc_5A6D4:8
0005A6CC  790c0002                 loc_5A6CC  mov.w   #2, e4
0005A6D0  790c0007                            mov.w   #7, e4
0005A6D4  790c0008                 loc_5A6D4  mov.w   #8, e4
0005A6D8  f32c                                mov.b   #0x2C, r3h ; ','
0005A6DA  7a0100000000                        mov.l   #0, er1
0005A6E0  0f92                                mov.l   er1, er2
0005A6E2  f404                     loc_5A6E2  mov.b   #4, r4h
0005A6E4  6c59                     loc_5A6E4  mov.b   @er5+, r1l
0005A6E6  0c9a                                mov.b   r1l, r2l
0005A6E8  1149                                shlr.b  #2, r1l
0005A6EA  1149                                shlr.b  #2, r1l
0005A6EC  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A6F0  68ec                                mov.b   r4l, @er6
0005A6F2  0b06                                adds    #1, er6
0005A6F4  ea0f                                and.b   #0xF, r2l
0005A6F6  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A6FA  68ec                                mov.b   r4l, @er6
0005A6FC  0b06                                adds    #1, er6
0005A6FE  1a04                                dec.b   r4h
0005A700  46e2                                bne     loc_5A6E4:8
0005A702  68e3                                mov.b   r3h, @er6
0005A704  0b06                                adds    #1, er6
0005A706  1b5c                                dec.w   #1, e4
0005A708  46d8                                bne     loc_5A6E2:8
0005A70A  68e3                                mov.b   r3h, @er6
0005A70C  0b06                                adds    #1, er6
0005A70E  01006b05b13a                        mov.l   @0xFFFFB13A:16, er5
0005A714  7a150000001f                        add.l   #0x1F, er5
0005A71A  f401                                mov.b   #1, r4h
0005A71C  6c59                     loc_5A71C  mov.b   @er5+, r1l
0005A71E  0c9a                                mov.b   r1l, r2l
0005A720  1149                                shlr.b  #2, r1l
0005A722  1149                                shlr.b  #2, r1l
0005A724  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A728  68ec                                mov.b   r4l, @er6
0005A72A  0b06                                adds    #1, er6
0005A72C  ea0f                                and.b   #0xF, r2l
0005A72E  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A732  68ec                                mov.b   r4l, @er6
0005A734  0b06                                adds    #1, er6
0005A736  1a04                                dec.b   r4h
0005A738  46e2                                bne     loc_5A71C:8
0005A73A  fc0d                                mov.b   #0xD, r4l
0005A73C  68ec                                mov.b   r4l, @er6
0005A73E  0b06                                adds    #1, er6
0005A740  fc0a                                mov.b   #0xA, r4l
0005A742  68ec                                mov.b   r4l, @er6
0005A744  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A74A  5470                                rts
0005A74C  6e5c0001                 loc_5A74C  mov.b   @(1:16,er5), r4l
0005A750  4608                                bne     loc_5A75A:8
0005A752  7a030005aefc                        mov.l   #0x5AEFC, er3
0005A758  4006                                bra     locret_5A760:8
0005A75A  7a030005aeea             loc_5A75A  mov.l   #0x5AEEA, er3
0005A760  5470                     locret_5A760 rts
0005A762  7a032044544d             loc_5A762  mov.l   #0x2044544D, er3
0005A768  1b06                                subs    #1, er6
0005A76A  010069e3                            mov.l   er3, @er6
0005A76E  0b96                                adds    #4, er6
0005A770  7a034620204f                        mov.l   #0x4620204F, er3
0005A776  0b05                                adds    #1, er5
0005A778  6c5c                                mov.b   @er5+, r4l
0005A77A  ec01                                and.b   #1, r4l
0005A77C  4706                                beq     loc_5A784:8
0005A77E  7a0346202053                        mov.l   #0x46202053, er3
0005A784  010069e3                 loc_5A784  mov.l   er3, @er6
0005A788  6859                                mov.b   @er5, r1l
0005A78A  e90f                                and.b   #0xF, r1l
0005A78C  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A790  6eec0001                            mov.b   r4l, @(1:16,er6)
0005A794  0b96                                adds    #4, er6
0005A796  fc0d                                mov.b   #0xD, r4l
0005A798  68ec                                mov.b   r4l, @er6
0005A79A  0b06                                adds    #1, er6
0005A79C  fc0a                                mov.b   #0xA, r4l
0005A79E  68ec                                mov.b   r4l, @er6
0005A7A0  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A7A6  5470                                rts
0005A7A8  7a03204e616b             loc_5A7A8  mov.l   #0x204E616B, er3
0005A7AE  4006                                bra     loc_5A7B6:8
0005A7B0  7a032041636b             loc_5A7B0  mov.l   #0x2041636B, er3
0005A7B6  1b06                     loc_5A7B6  subs    #1, er6
0005A7B8  010069e3                            mov.l   er3, @er6
0005A7BC  0b96                                adds    #4, er6
0005A7BE  0b05                                adds    #1, er5
0005A7C0  f401                                mov.b   #1, r4h
0005A7C2  6c59                     loc_5A7C2  mov.b   @er5+, r1l
0005A7C4  0c9a                                mov.b   r1l, r2l
0005A7C6  1149                                shlr.b  #2, r1l
0005A7C8  1149                                shlr.b  #2, r1l
0005A7CA  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A7CE  68ec                                mov.b   r4l, @er6
0005A7D0  0b06                                adds    #1, er6
0005A7D2  ea0f                                and.b   #0xF, r2l
0005A7D4  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A7D8  68ec                                mov.b   r4l, @er6
0005A7DA  0b06                                adds    #1, er6
0005A7DC  1a04                                dec.b   r4h
0005A7DE  46e2                                bne     loc_5A7C2:8
0005A7E0  fc0d                                mov.b   #0xD, r4l
0005A7E2  68ec                                mov.b   r4l, @er6
0005A7E4  0b06                                adds    #1, er6
0005A7E6  fc0a                                mov.b   #0xA, r4l
0005A7E8  68ec                                mov.b   r4l, @er6
0005A7EA  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A7F0  5470                                rts
0005A7F2  fc09                     sub_5A7F2  mov.b   #9, r4l  ; <<< FUNC sub_5A7F2
0005A7F4  f400                                mov.b   #0, r4h
0005A7F6  7a050005ae28                        mov.l   #loc_5AE28, er5
0005A7FC  7a0600ff2dc8                        mov.l   #0xFF2DC8, er6
0005A802  7bd4598f                 loc_5A802  eepmov.w
0005A806  0d44                                mov.w   r4, r4
0005A808  46f8                                bne     loc_5A802:8
0005A80A  7a0500ffb0e0                        mov.l   #0xFFB0E0, er5
0005A810  6a0c8c28                            mov.b   @0xFFFF8C28:16, r4l
0005A814  ac03                                cmp.b   #3, r4l
0005A816  58700572                            beq     loc_5AD8C:16
0005A81A  ac05                                cmp.b   #5, r4l
0005A81C  5870056c                            beq     loc_5AD8C:16
0005A820  f32c                                mov.b   #0x2C, r3h ; ','
0005A822  7a0100000000                        mov.l   #0, er1
0005A828  0f92                                mov.l   er1, er2
0005A82A  685c                                mov.b   @er5, r4l
0005A82C  aca0                                cmp.b   #0xA0, r4l
0005A82E  4780                                beq     loc_5A7B0:8
0005A830  aca6                                cmp.b   #0xA6, r4l
0005A832  58700098                            beq     loc_5A8CE:16
0005A836  aca7                                cmp.b   #0xA7, r4l
0005A838  58700092                            beq     loc_5A8CE:16
0005A83C  aca8                                cmp.b   #0xA8, r4l
0005A83E  58700106                            beq     loc_5A948:16
0005A842  aca9                                cmp.b   #0xA9, r4l
0005A844  58700390                            beq     loc_5ABD8:16
0005A848  acaa                                cmp.b   #0xAA, r4l
0005A84A  5870038a                            beq     loc_5ABD8:16
0005A84E  ac9c                                cmp.b   #0x9C, r4l
0005A850  4764                                beq     loc_5A8B6:8
0005A852  ac9e                                cmp.b   #0x9E, r4l
0005A854  4768                                beq     loc_5A8BE:8
0005A856  acab                                cmp.b   #0xAB, r4l
0005A858  476c                                beq     loc_5A8C6:8
0005A85A  acb6                                cmp.b   #0xB6, r4l
0005A85C  4770                                beq     loc_5A8CE:8
0005A85E  acb7                                cmp.b   #0xB7, r4l
0005A860  476c                                beq     loc_5A8CE:8
0005A862  acb8                                cmp.b   #0xB8, r4l
0005A864  587000e0                            beq     loc_5A948:16
0005A868  acb9                                cmp.b   #0xB9, r4l
0005A86A  5870036a                            beq     loc_5ABD8:16
0005A86E  acba                                cmp.b   #0xBA, r4l
0005A870  58700364                            beq     loc_5ABD8:16
0005A874  acbb                                cmp.b   #0xBB, r4l
0005A876  474e                                beq     loc_5A8C6:8
0005A878  ac90                                cmp.b   #0x90, r4l
0005A87A  5870ff2a                            beq     loc_5A7A8:16
0005A87E  ac9f                                cmp.b   #0x9F, r4l
0005A880  58600508                            bne     loc_5AD8C:16
0005A884  f404                                mov.b   #4, r4h
0005A886  6c59                     loc_5A886  mov.b   @er5+, r1l
0005A888  0c9a                                mov.b   r1l, r2l
0005A88A  1149                                shlr.b  #2, r1l
0005A88C  1149                                shlr.b  #2, r1l
0005A88E  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A892  68ec                                mov.b   r4l, @er6
0005A894  0b06                                adds    #1, er6
0005A896  ea0f                                and.b   #0xF, r2l
0005A898  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A89C  68ec                                mov.b   r4l, @er6
0005A89E  0b06                                adds    #1, er6
0005A8A0  1a04                                dec.b   r4h
0005A8A2  46e2                                bne     loc_5A886:8
0005A8A4  fc0d                                mov.b   #0xD, r4l
0005A8A6  68ec                                mov.b   r4l, @er6
0005A8A8  0b06                                adds    #1, er6
0005A8AA  fc0a                                mov.b   #0xA, r4l
0005A8AC  68ec                                mov.b   r4l, @er6
0005A8AE  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A8B4  5470                                rts
0005A8B6  7a030005af34             loc_5A8B6  mov.l   #sub_5AF34, er3
0005A8BC  5470                                rts
0005A8BE  7a030005af4c             loc_5A8BE  mov.l   #loc_5AF4C, er3
0005A8C4  5470                                rts
0005A8C6  7a030005af5e             loc_5A8C6  mov.l   #loc_5AF5E, er3
0005A8CC  5470                                rts
0005A8CE  f401                     loc_5A8CE  mov.b   #1, r4h
0005A8D0  6c59                     loc_5A8D0  mov.b   @er5+, r1l
0005A8D2  0c9a                                mov.b   r1l, r2l
0005A8D4  1149                                shlr.b  #2, r1l
0005A8D6  1149                                shlr.b  #2, r1l
0005A8D8  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A8DC  68ec                                mov.b   r4l, @er6
0005A8DE  0b06                                adds    #1, er6
0005A8E0  ea0f                                and.b   #0xF, r2l
0005A8E2  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A8E6  68ec                                mov.b   r4l, @er6
0005A8E8  0b06                                adds    #1, er6
0005A8EA  1a04                                dec.b   r4h
0005A8EC  46e2                                bne     loc_5A8D0:8
0005A8EE  68e3                                mov.b   r3h, @er6
0005A8F0  0b06                                adds    #1, er6
0005A8F2  f406                                mov.b   #6, r4h
0005A8F4  6c59                     loc_5A8F4  mov.b   @er5+, r1l
0005A8F6  0c9a                                mov.b   r1l, r2l
0005A8F8  1149                                shlr.b  #2, r1l
0005A8FA  1149                                shlr.b  #2, r1l
0005A8FC  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A900  68ec                                mov.b   r4l, @er6
0005A902  0b06                                adds    #1, er6
0005A904  ea0f                                and.b   #0xF, r2l
0005A906  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A90A  68ec                                mov.b   r4l, @er6
0005A90C  0b06                                adds    #1, er6
0005A90E  1a04                                dec.b   r4h
0005A910  46e2                                bne     loc_5A8F4:8
0005A912  68e3                                mov.b   r3h, @er6
0005A914  0b06                                adds    #1, er6
0005A916  fc0a                                mov.b   #0xA, r4l
0005A918  6c54                     loc_5A918  mov.b   @er5+, r4h
0005A91A  a420                                cmp.b   #0x20, r4h ; ' '
0005A91C  4504                                bcs     loc_5A922:8
0005A91E  a47f                                cmp.b   #0x7F, r4h
0005A920  4502                                bcs     loc_5A924:8
0005A922  f43f                     loc_5A922  mov.b   #0x3F, r4h ; '?'
0005A924  68e4                     loc_5A924  mov.b   r4h, @er6
0005A926  0b06                                adds    #1, er6
0005A928  1a0c                                dec.b   r4l
0005A92A  46ec                                bne     loc_5A918:8
0005A92C  68e3                                mov.b   r3h, @er6
0005A92E  0b06                                adds    #1, er6
0005A930  fc0a                                mov.b   #0xA, r4l
0005A932  6c54                     loc_5A932  mov.b   @er5+, r4h
0005A934  a420                                cmp.b   #0x20, r4h ; ' '
0005A936  4504                                bcs     loc_5A93C:8
0005A938  a47f                                cmp.b   #0x7F, r4h
0005A93A  4502                                bcs     loc_5A93E:8
0005A93C  f43f                     loc_5A93C  mov.b   #0x3F, r4h ; '?'
0005A93E  68e4                     loc_5A93E  mov.b   r4h, @er6
0005A940  0b06                                adds    #1, er6
0005A942  1a0c                                dec.b   r4l
0005A944  46ec                                bne     loc_5A932:8
0005A946  4078                                bra     loc_5A9C0:8
0005A948  f401                     loc_5A948  mov.b   #1, r4h
0005A94A  6c59                     loc_5A94A  mov.b   @er5+, r1l
0005A94C  0c9a                                mov.b   r1l, r2l
0005A94E  1149                                shlr.b  #2, r1l
0005A950  1149                                shlr.b  #2, r1l
0005A952  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A956  68ec                                mov.b   r4l, @er6
0005A958  0b06                                adds    #1, er6
0005A95A  ea0f                                and.b   #0xF, r2l
0005A95C  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A960  68ec                                mov.b   r4l, @er6
0005A962  0b06                                adds    #1, er6
0005A964  1a04                                dec.b   r4h
0005A966  46e2                                bne     loc_5A94A:8
0005A968  68e3                                mov.b   r3h, @er6
0005A96A  0b06                                adds    #1, er6
0005A96C  f406                                mov.b   #6, r4h
0005A96E  6c59                     loc_5A96E  mov.b   @er5+, r1l
0005A970  0c9a                                mov.b   r1l, r2l
0005A972  1149                                shlr.b  #2, r1l
0005A974  1149                                shlr.b  #2, r1l
0005A976  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A97A  68ec                                mov.b   r4l, @er6
0005A97C  0b06                                adds    #1, er6
0005A97E  ea0f                                and.b   #0xF, r2l
0005A980  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A984  68ec                                mov.b   r4l, @er6
0005A986  0b06                                adds    #1, er6
0005A988  1a04                                dec.b   r4h
0005A98A  46e2                                bne     loc_5A96E:8
0005A98C  68e3                                mov.b   r3h, @er6
0005A98E  0b06                                adds    #1, er6
0005A990  fc0f                                mov.b   #0xF, r4l
0005A992  6c54                     loc_5A992  mov.b   @er5+, r4h
0005A994  a420                                cmp.b   #0x20, r4h ; ' '
0005A996  4504                                bcs     loc_5A99C:8
0005A998  a47f                                cmp.b   #0x7F, r4h
0005A99A  4502                                bcs     loc_5A99E:8
0005A99C  f43f                     loc_5A99C  mov.b   #0x3F, r4h ; '?'
0005A99E  68e4                     loc_5A99E  mov.b   r4h, @er6
0005A9A0  0b06                                adds    #1, er6
0005A9A2  1a0c                                dec.b   r4l
0005A9A4  46ec                                bne     loc_5A992:8
0005A9A6  68e3                                mov.b   r3h, @er6
0005A9A8  0b06                                adds    #1, er6
0005A9AA  fc05                                mov.b   #5, r4l
0005A9AC  6c54                     loc_5A9AC  mov.b   @er5+, r4h
0005A9AE  a420                                cmp.b   #0x20, r4h ; ' '
0005A9B0  4504                                bcs     loc_5A9B6:8
0005A9B2  a47f                                cmp.b   #0x7F, r4h
0005A9B4  4502                                bcs     loc_5A9B8:8
0005A9B6  f43f                     loc_5A9B6  mov.b   #0x3F, r4h ; '?'
0005A9B8  68e4                     loc_5A9B8  mov.b   r4h, @er6
0005A9BA  0b06                                adds    #1, er6
0005A9BC  1a0c                                dec.b   r4l
0005A9BE  46ec                                bne     loc_5A9AC:8
0005A9C0  68e3                     loc_5A9C0  mov.b   r3h, @er6
0005A9C2  0b06                                adds    #1, er6
0005A9C4  68e3                                mov.b   r3h, @er6
0005A9C6  0b06                                adds    #1, er6
0005A9C8  0b95                                adds    #4, er5
0005A9CA  f401                                mov.b   #1, r4h
0005A9CC  6c59                     loc_5A9CC  mov.b   @er5+, r1l
0005A9CE  0c9a                                mov.b   r1l, r2l
0005A9D0  1149                                shlr.b  #2, r1l
0005A9D2  1149                                shlr.b  #2, r1l
0005A9D4  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A9D8  68ec                                mov.b   r4l, @er6
0005A9DA  0b06                                adds    #1, er6
0005A9DC  ea0f                                and.b   #0xF, r2l
0005A9DE  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A9E2  68ec                                mov.b   r4l, @er6
0005A9E4  0b06                                adds    #1, er6
0005A9E6  1a04                                dec.b   r4h
0005A9E8  46e2                                bne     loc_5A9CC:8
0005A9EA  fc0d                                mov.b   #0xD, r4l
0005A9EC  68ec                                mov.b   r4l, @er6
0005A9EE  0b06                                adds    #1, er6
0005A9F0  fc0a                                mov.b   #0xA, r4l
0005A9F2  68ec                                mov.b   r4l, @er6
0005A9F4  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A9FA  5470                                rts
0005A9FC  f401                     loc_5A9FC  mov.b   #1, r4h
0005A9FE  6c59                     loc_5A9FE  mov.b   @er5+, r1l
0005AA00  0c9a                                mov.b   r1l, r2l
0005AA02  1149                                shlr.b  #2, r1l
0005AA04  1149                                shlr.b  #2, r1l
0005AA06  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AA0A  68ec                                mov.b   r4l, @er6
0005AA0C  0b06                                adds    #1, er6
0005AA0E  ea0f                                and.b   #0xF, r2l
0005AA10  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AA14  68ec                                mov.b   r4l, @er6
0005AA16  0b06                                adds    #1, er6
0005AA18  1a04                                dec.b   r4h
0005AA1A  46e2                                bne     loc_5A9FE:8
0005AA1C  68e3                                mov.b   r3h, @er6
0005AA1E  0b06                                adds    #1, er6
0005AA20  f406                                mov.b   #6, r4h
0005AA22  6c59                     loc_5AA22  mov.b   @er5+, r1l
0005AA24  0c9a                                mov.b   r1l, r2l
0005AA26  1149                                shlr.b  #2, r1l
0005AA28  1149                                shlr.b  #2, r1l
0005AA2A  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AA2E  68ec                                mov.b   r4l, @er6
0005AA30  0b06                                adds    #1, er6
0005AA32  ea0f                                and.b   #0xF, r2l
0005AA34  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AA38  68ec                                mov.b   r4l, @er6
0005AA3A  0b06                                adds    #1, er6
0005AA3C  1a04                                dec.b   r4h
0005AA3E  46e2                                bne     loc_5AA22:8
0005AA40  68e3                                mov.b   r3h, @er6
0005AA42  0b06                                adds    #1, er6
0005AA44  790c0004                            mov.w   #4, e4
0005AA48  fc0a                     loc_5AA48  mov.b   #0xA, r4l
0005AA4A  6c54                     loc_5AA4A  mov.b   @er5+, r4h
0005AA4C  a420                                cmp.b   #0x20, r4h ; ' '
0005AA4E  4504                                bcs     loc_5AA54:8
0005AA50  a47f                                cmp.b   #0x7F, r4h
0005AA52  4502                                bcs     loc_5AA56:8
0005AA54  f43f                     loc_5AA54  mov.b   #0x3F, r4h ; '?'
0005AA56  68e4                     loc_5AA56  mov.b   r4h, @er6
0005AA58  0b06                                adds    #1, er6
0005AA5A  1a0c                                dec.b   r4l
0005AA5C  46ec                                bne     loc_5AA4A:8
0005AA5E  68e3                                mov.b   r3h, @er6
0005AA60  0b06                                adds    #1, er6
0005AA62  1b5c                                dec.w   #1, e4
0005AA64  46e2                                bne     loc_5AA48:8
0005AA66  fc0f                                mov.b   #0xF, r4l
0005AA68  6c54                     loc_5AA68  mov.b   @er5+, r4h
0005AA6A  a420                                cmp.b   #0x20, r4h ; ' '
0005AA6C  4504                                bcs     loc_5AA72:8
0005AA6E  a47f                                cmp.b   #0x7F, r4h
0005AA70  4502                                bcs     loc_5AA74:8
0005AA72  f43f                     loc_5AA72  mov.b   #0x3F, r4h ; '?'
0005AA74  68e4                     loc_5AA74  mov.b   r4h, @er6
0005AA76  0b06                                adds    #1, er6
0005AA78  1a0c                                dec.b   r4l
0005AA7A  46ec                                bne     loc_5AA68:8
0005AA7C  68e3                                mov.b   r3h, @er6
0005AA7E  0b06                                adds    #1, er6
0005AA80  fc05                                mov.b   #5, r4l
0005AA82  6c54                     loc_5AA82  mov.b   @er5+, r4h
0005AA84  a420                                cmp.b   #0x20, r4h ; ' '
0005AA86  4504                                bcs     loc_5AA8C:8
0005AA88  a47f                                cmp.b   #0x7F, r4h
0005AA8A  4502                                bcs     loc_5AA8E:8
0005AA8C  f43f                     loc_5AA8C  mov.b   #0x3F, r4h ; '?'
0005AA8E  68e4                     loc_5AA8E  mov.b   r4h, @er6
0005AA90  0b06                                adds    #1, er6
0005AA92  1a0c                                dec.b   r4l
0005AA94  46ec                                bne     loc_5AA82:8
0005AA96  68e3                                mov.b   r3h, @er6
0005AA98  0b06                                adds    #1, er6
0005AA9A  68e3                                mov.b   r3h, @er6
0005AA9C  0b06                                adds    #1, er6
0005AA9E  7a150000001c                        add.l   #0x1C, er5
0005AAA4  f401                                mov.b   #1, r4h
0005AAA6  6c59                     loc_5AAA6  mov.b   @er5+, r1l
0005AAA8  0c9a                                mov.b   r1l, r2l
0005AAAA  1149                                shlr.b  #2, r1l
0005AAAC  1149                                shlr.b  #2, r1l
0005AAAE  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AAB2  68ec                                mov.b   r4l, @er6
0005AAB4  0b06                                adds    #1, er6
0005AAB6  ea0f                                and.b   #0xF, r2l
0005AAB8  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AABC  68ec                                mov.b   r4l, @er6
0005AABE  0b06                                adds    #1, er6
0005AAC0  1a04                                dec.b   r4h
0005AAC2  46e2                                bne     loc_5AAA6:8
0005AAC4  fc0d                                mov.b   #0xD, r4l
0005AAC6  68ec                                mov.b   r4l, @er6
0005AAC8  0b06                                adds    #1, er6
0005AACA  fc0a                                mov.b   #0xA, r4l
0005AACC  68ec                                mov.b   r4l, @er6
0005AACE  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005AAD4  5470                                rts
0005AAD6  6a0bb122                 loc_5AAD6  mov.b   @0xFFFFB122:16, r3l
0005AADA  f401                                mov.b   #1, r4h
0005AADC  6c59                     loc_5AADC  mov.b   @er5+, r1l
0005AADE  0c9a                                mov.b   r1l, r2l
0005AAE0  1149                                shlr.b  #2, r1l
0005AAE2  1149                                shlr.b  #2, r1l
0005AAE4  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AAE8  68ec                                mov.b   r4l, @er6
0005AAEA  0b06                                adds    #1, er6
0005AAEC  ea0f                                and.b   #0xF, r2l
0005AAEE  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AAF2  68ec                                mov.b   r4l, @er6
0005AAF4  0b06                                adds    #1, er6
0005AAF6  1a04                                dec.b   r4h
0005AAF8  46e2                                bne     loc_5AADC:8
0005AAFA  68e3                                mov.b   r3h, @er6
0005AAFC  0b06                                adds    #1, er6
0005AAFE  f406                                mov.b   #6, r4h
0005AB00  6c59                     loc_5AB00  mov.b   @er5+, r1l
0005AB02  0c9a                                mov.b   r1l, r2l
0005AB04  1149                                shlr.b  #2, r1l
0005AB06  1149                                shlr.b  #2, r1l
0005AB08  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AB0C  68ec                                mov.b   r4l, @er6
0005AB0E  0b06                                adds    #1, er6
0005AB10  ea0f                                and.b   #0xF, r2l
0005AB12  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AB16  68ec                                mov.b   r4l, @er6
0005AB18  0b06                                adds    #1, er6
0005AB1A  1a04                                dec.b   r4h
0005AB1C  46e2                                bne     loc_5AB00:8
0005AB1E  68e3                                mov.b   r3h, @er6
0005AB20  0b06                                adds    #1, er6
0005AB22  ab02                                cmp.b   #2, r3l
0005AB24  4428                                bcc     loc_5AB4E:8
0005AB26  f401                                mov.b   #1, r4h
0005AB28  6c59                     loc_5AB28  mov.b   @er5+, r1l
0005AB2A  0c9a                                mov.b   r1l, r2l
0005AB2C  1149                                shlr.b  #2, r1l
0005AB2E  1149                                shlr.b  #2, r1l
0005AB30  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AB34  68ec                                mov.b   r4l, @er6
0005AB36  0b06                                adds    #1, er6
0005AB38  ea0f                                and.b   #0xF, r2l
0005AB3A  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AB3E  68ec                                mov.b   r4l, @er6
0005AB40  0b06                                adds    #1, er6
0005AB42  1a04                                dec.b   r4h
0005AB44  46e2                                bne     loc_5AB28:8
0005AB46  68e3                                mov.b   r3h, @er6
0005AB48  0b06                                adds    #1, er6
0005AB4A  fb57                                mov.b   #0x57, r3l ; 'W'
0005AB4C  4002                                bra     loc_5AB50:8
0005AB4E  fb58                     loc_5AB4E  mov.b   #0x58, r3l ; 'X'
0005AB50  6c59                     loc_5AB50  mov.b   @er5+, r1l
0005AB52  a903                                cmp.b   #3, r1l
0005AB54  4714                                beq     loc_5AB6A:8
0005AB56  a920                                cmp.b   #0x20, r1l ; ' '
0005AB58  4504                                bcs     loc_5AB5E:8
0005AB5A  a97f                                cmp.b   #0x7F, r1l
0005AB5C  4502                                bcs     loc_5AB60:8
0005AB5E  f93f                     loc_5AB5E  mov.b   #0x3F, r1l ; '?'
0005AB60  68e9                     loc_5AB60  mov.b   r1l, @er6
0005AB62  0b06                                adds    #1, er6
0005AB64  1a0b                                dec.b   r3l
0005AB66  46e8                                bne     loc_5AB50:8
0005AB68  402c                                bra     loc_5AB96:8
0005AB6A  f940                     loc_5AB6A  mov.b   #0x40, r1l ; '@'
0005AB6C  68e9                                mov.b   r1l, @er6
0005AB6E  0b06                                adds    #1, er6
0005AB70  fc2c                                mov.b   #0x2C, r4l ; ','
0005AB72  68ec                                mov.b   r4l, @er6
0005AB74  0b06                                adds    #1, er6
0005AB76  f401                                mov.b   #1, r4h
0005AB78  6c59                     loc_5AB78  mov.b   @er5+, r1l
0005AB7A  0c9a                                mov.b   r1l, r2l
0005AB7C  1149                                shlr.b  #2, r1l
0005AB7E  1149                                shlr.b  #2, r1l
0005AB80  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AB84  68ec                                mov.b   r4l, @er6
0005AB86  0b06                                adds    #1, er6
0005AB88  ea0f                                and.b   #0xF, r2l
0005AB8A  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AB8E  68ec                                mov.b   r4l, @er6
0005AB90  0b06                                adds    #1, er6
0005AB92  1a04                                dec.b   r4h
0005AB94  46e2                                bne     loc_5AB78:8
0005AB96  f32c                     loc_5AB96  mov.b   #0x2C, r3h ; ','
0005AB98  68e3                                mov.b   r3h, @er6
0005AB9A  0b06                                adds    #1, er6
0005AB9C  68e3                                mov.b   r3h, @er6
0005AB9E  0b06                                adds    #1, er6
0005ABA0  7a0500ffb19d                        mov.l   #0xFFB19D, er5
0005ABA6  f401                                mov.b   #1, r4h
0005ABA8  6c59                     loc_5ABA8  mov.b   @er5+, r1l
0005ABAA  0c9a                                mov.b   r1l, r2l
0005ABAC  1149                                shlr.b  #2, r1l
0005ABAE  1149                                shlr.b  #2, r1l
0005ABB0  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ABB4  68ec                                mov.b   r4l, @er6
0005ABB6  0b06                                adds    #1, er6
0005ABB8  ea0f                                and.b   #0xF, r2l
0005ABBA  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ABBE  68ec                                mov.b   r4l, @er6
0005ABC0  0b06                                adds    #1, er6
0005ABC2  1a04                                dec.b   r4h
0005ABC4  46e2                                bne     loc_5ABA8:8
0005ABC6  fc0d                                mov.b   #0xD, r4l
0005ABC8  68ec                                mov.b   r4l, @er6
0005ABCA  0b06                                adds    #1, er6
0005ABCC  fc0a                                mov.b   #0xA, r4l
0005ABCE  68ec                                mov.b   r4l, @er6
0005ABD0  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005ABD6  5470                                rts
0005ABD8  6a0bb0e5                 loc_5ABD8  mov.b   @0xFFFFB0E5:16, r3l
0005ABDC  114b                                shlr.b  #2, r3l
0005ABDE  114b                                shlr.b  #2, r3l
0005ABE0  f401                                mov.b   #1, r4h
0005ABE2  6c59                     loc_5ABE2  mov.b   @er5+, r1l
0005ABE4  0c9a                                mov.b   r1l, r2l
0005ABE6  1149                                shlr.b  #2, r1l
0005ABE8  1149                                shlr.b  #2, r1l
0005ABEA  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ABEE  68ec                                mov.b   r4l, @er6
0005ABF0  0b06                                adds    #1, er6
0005ABF2  ea0f                                and.b   #0xF, r2l
0005ABF4  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ABF8  68ec                                mov.b   r4l, @er6
0005ABFA  0b06                                adds    #1, er6
0005ABFC  1a04                                dec.b   r4h
0005ABFE  46e2                                bne     loc_5ABE2:8
0005AC00  68e3                                mov.b   r3h, @er6
0005AC02  0b06                                adds    #1, er6
0005AC04  f406                                mov.b   #6, r4h
0005AC06  6c59                     loc_5AC06  mov.b   @er5+, r1l
0005AC08  0c9a                                mov.b   r1l, r2l
0005AC0A  1149                                shlr.b  #2, r1l
0005AC0C  1149                                shlr.b  #2, r1l
0005AC0E  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AC12  68ec                                mov.b   r4l, @er6
0005AC14  0b06                                adds    #1, er6
0005AC16  ea0f                                and.b   #0xF, r2l
0005AC18  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AC1C  68ec                                mov.b   r4l, @er6
0005AC1E  0b06                                adds    #1, er6
0005AC20  1a04                                dec.b   r4h
0005AC22  46e2                                bne     loc_5AC06:8
0005AC24  68e3                                mov.b   r3h, @er6
0005AC26  0b06                                adds    #1, er6
0005AC28  ab02                                cmp.b   #2, r3l
0005AC2A  4428                                bcc     loc_5AC54:8
0005AC2C  f401                                mov.b   #1, r4h
0005AC2E  6c59                     loc_5AC2E  mov.b   @er5+, r1l
0005AC30  0c9a                                mov.b   r1l, r2l
0005AC32  1149                                shlr.b  #2, r1l
0005AC34  1149                                shlr.b  #2, r1l
0005AC36  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AC3A  68ec                                mov.b   r4l, @er6
0005AC3C  0b06                                adds    #1, er6
0005AC3E  ea0f                                and.b   #0xF, r2l
0005AC40  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AC44  68ec                                mov.b   r4l, @er6
0005AC46  0b06                                adds    #1, er6
0005AC48  1a04                                dec.b   r4h
0005AC4A  46e2                                bne     loc_5AC2E:8
0005AC4C  68e3                                mov.b   r3h, @er6
0005AC4E  0b06                                adds    #1, er6
0005AC50  fb17                                mov.b   #0x17, r3l
0005AC52  4002                                bra     loc_5AC56:8
0005AC54  fb18                     loc_5AC54  mov.b   #0x18, r3l
0005AC56  6c59                     loc_5AC56  mov.b   @er5+, r1l
0005AC58  a903                                cmp.b   #3, r1l
0005AC5A  4714                                beq     loc_5AC70:8
0005AC5C  a920                                cmp.b   #0x20, r1l ; ' '
0005AC5E  4504                                bcs     loc_5AC64:8
0005AC60  a97f                                cmp.b   #0x7F, r1l
0005AC62  4502                                bcs     loc_5AC66:8
0005AC64  f93f                     loc_5AC64  mov.b   #0x3F, r1l ; '?'
0005AC66  68e9                     loc_5AC66  mov.b   r1l, @er6
0005AC68  0b06                                adds    #1, er6
0005AC6A  1a0b                                dec.b   r3l
0005AC6C  46e8                                bne     loc_5AC56:8
0005AC6E  402c                                bra     loc_5AC9C:8
0005AC70  f940                     loc_5AC70  mov.b   #0x40, r1l ; '@'
0005AC72  68e9                                mov.b   r1l, @er6
0005AC74  0b06                                adds    #1, er6
0005AC76  fc2c                                mov.b   #0x2C, r4l ; ','
0005AC78  68ec                                mov.b   r4l, @er6
0005AC7A  0b06                                adds    #1, er6
0005AC7C  f401                                mov.b   #1, r4h
0005AC7E  6c59                     loc_5AC7E  mov.b   @er5+, r1l
0005AC80  0c9a                                mov.b   r1l, r2l
0005AC82  1149                                shlr.b  #2, r1l
0005AC84  1149                                shlr.b  #2, r1l
0005AC86  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AC8A  68ec                                mov.b   r4l, @er6
0005AC8C  0b06                                adds    #1, er6
0005AC8E  ea0f                                and.b   #0xF, r2l
0005AC90  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AC94  68ec                                mov.b   r4l, @er6
0005AC96  0b06                                adds    #1, er6
0005AC98  1a04                                dec.b   r4h
0005AC9A  46e2                                bne     loc_5AC7E:8
0005AC9C  f32c                     loc_5AC9C  mov.b   #0x2C, r3h ; ','
0005AC9E  68e3                                mov.b   r3h, @er6
0005ACA0  0b06                                adds    #1, er6
0005ACA2  68e3                                mov.b   r3h, @er6
0005ACA4  0b06                                adds    #1, er6
0005ACA6  7a0500ffb0ff                        mov.l   #0xFFB0FF, er5
0005ACAC  f401                                mov.b   #1, r4h
0005ACAE  6c59                     loc_5ACAE  mov.b   @er5+, r1l
0005ACB0  0c9a                                mov.b   r1l, r2l
0005ACB2  1149                                shlr.b  #2, r1l
0005ACB4  1149                                shlr.b  #2, r1l
0005ACB6  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ACBA  68ec                                mov.b   r4l, @er6
0005ACBC  0b06                                adds    #1, er6
0005ACBE  ea0f                                and.b   #0xF, r2l
0005ACC0  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ACC4  68ec                                mov.b   r4l, @er6
0005ACC6  0b06                                adds    #1, er6
0005ACC8  1a04                                dec.b   r4h
0005ACCA  46e2                                bne     loc_5ACAE:8
0005ACCC  fc0d                                mov.b   #0xD, r4l
0005ACCE  68ec                                mov.b   r4l, @er6
0005ACD0  0b06                                adds    #1, er6
0005ACD2  fc0a                                mov.b   #0xA, r4l
0005ACD4  68ec                                mov.b   r4l, @er6
0005ACD6  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005ACDC  5470                                rts
0005ACDE  f401                     loc_5ACDE  mov.b   #1, r4h
0005ACE0  6c59                     loc_5ACE0  mov.b   @er5+, r1l
0005ACE2  0c9a                                mov.b   r1l, r2l
0005ACE4  1149                                shlr.b  #2, r1l
0005ACE6  1149                                shlr.b  #2, r1l
0005ACE8  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ACEC  68ec                                mov.b   r4l, @er6
0005ACEE  0b06                                adds    #1, er6
0005ACF0  ea0f                                and.b   #0xF, r2l
0005ACF2  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ACF6  68ec                                mov.b   r4l, @er6
0005ACF8  0b06                                adds    #1, er6
0005ACFA  1a04                                dec.b   r4h
0005ACFC  46e2                                bne     loc_5ACE0:8
0005ACFE  68e3                                mov.b   r3h, @er6
0005AD00  0b06                                adds    #1, er6
0005AD02  f401                                mov.b   #1, r4h
0005AD04  6c59                     loc_5AD04  mov.b   @er5+, r1l
0005AD06  0c9a                                mov.b   r1l, r2l
0005AD08  1149                                shlr.b  #2, r1l
0005AD0A  1149                                shlr.b  #2, r1l
0005AD0C  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AD10  68ec                                mov.b   r4l, @er6
0005AD12  0b06                                adds    #1, er6
0005AD14  ea0f                                and.b   #0xF, r2l
0005AD16  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AD1A  68ec                                mov.b   r4l, @er6
0005AD1C  0b06                                adds    #1, er6
0005AD1E  1a04                                dec.b   r4h
0005AD20  46e2                                bne     loc_5AD04:8
0005AD22  68e3                                mov.b   r3h, @er6
0005AD24  0b06                                adds    #1, er6
0005AD26  fb12                                mov.b   #0x12, r3l
0005AD28  6a0cb13f                            mov.b   @0xFFFFB13F:16, r4l
0005AD2C  ac01                                cmp.b   #1, r4l
0005AD2E  4702                                beq     loc_5AD32:8
0005AD30  fb06                                mov.b   #6, r3l
0005AD32  fc05                     loc_5AD32  mov.b   #5, r4l
0005AD34  6c54                     loc_5AD34  mov.b   @er5+, r4h
0005AD36  a420                                cmp.b   #0x20, r4h ; ' '
0005AD38  4504                                bcs     loc_5AD3E:8
0005AD3A  a47f                                cmp.b   #0x7F, r4h
0005AD3C  4502                                bcs     loc_5AD40:8
0005AD3E  f43f                     loc_5AD3E  mov.b   #0x3F, r4h ; '?'
0005AD40  68e4                     loc_5AD40  mov.b   r4h, @er6
0005AD42  0b06                                adds    #1, er6
0005AD44  1a0c                                dec.b   r4l
0005AD46  46ec                                bne     loc_5AD34:8
0005AD48  68e3                                mov.b   r3h, @er6
0005AD4A  0b06                                adds    #1, er6
0005AD4C  1a0b                                dec.b   r3l
0005AD4E  46e2                                bne     loc_5AD32:8
0005AD50  68e3                                mov.b   r3h, @er6
0005AD52  0b06                                adds    #1, er6
0005AD54  7a0500ffb19d                        mov.l   #0xFFB19D, er5
0005AD5A  f401                                mov.b   #1, r4h
0005AD5C  6c59                     loc_5AD5C  mov.b   @er5+, r1l
0005AD5E  0c9a                                mov.b   r1l, r2l
0005AD60  1149                                shlr.b  #2, r1l
0005AD62  1149                                shlr.b  #2, r1l
0005AD64  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AD68  68ec                                mov.b   r4l, @er6
0005AD6A  0b06                                adds    #1, er6
0005AD6C  ea0f                                and.b   #0xF, r2l
0005AD6E  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AD72  68ec                                mov.b   r4l, @er6
0005AD74  0b06                                adds    #1, er6
0005AD76  1a04                                dec.b   r4h
0005AD78  46e2                                bne     loc_5AD5C:8
0005AD7A  fc0d                                mov.b   #0xD, r4l
0005AD7C  68ec                                mov.b   r4l, @er6
0005AD7E  0b06                                adds    #1, er6
0005AD80  fc0a                                mov.b   #0xA, r4l
0005AD82  68ec                                mov.b   r4l, @er6
0005AD84  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005AD8A  5470                                rts
0005AD8C  6a0c8c28                 loc_5AD8C  mov.b   @0xFFFF8C28:16, r4l
0005AD90  ac05                                cmp.b   #5, r4l
0005AD92  4612                                bne     loc_5ADA6:8
0005AD94  685c                                mov.b   @er5, r4l
0005AD96  ac20                                cmp.b   #0x20, r4l ; ' '
0005AD98  4704                                beq     loc_5AD9E:8
0005AD9A  aca0                                cmp.b   #0xA0, r4l
0005AD9C  4608                                bne     loc_5ADA6:8
0005AD9E  fcff                     loc_5AD9E  mov.b   #0xFF, r4l
0005ADA0  6a8cb0c3                            mov.b   r4l, @0xFFFFB0C3:16
0005ADA4  4076                                bra     locret_5AE1C:8
0005ADA6  685c                     loc_5ADA6  mov.b   @er5, r4l
0005ADA8  ac19                                cmp.b   #0x19, r4l
0005ADAA  470a                                beq     loc_5ADB6:8
0005ADAC  ac16                                cmp.b   #0x16, r4l
0005ADAE  4706                                beq     loc_5ADB6:8
0005ADB0  790c0007                            mov.w   #7, e4
0005ADB4  4004                                bra     loc_5ADBA:8
0005ADB6  790c0017                 loc_5ADB6  mov.w   #0x17, e4
0005ADBA  f32c                     loc_5ADBA  mov.b   #0x2C, r3h ; ','
0005ADBC  7a0100000000                        mov.l   #0, er1
0005ADC2  0f92                                mov.l   er1, er2
0005ADC4  f404                     loc_5ADC4  mov.b   #4, r4h
0005ADC6  6c59                     loc_5ADC6  mov.b   @er5+, r1l
0005ADC8  0c9a                                mov.b   r1l, r2l
0005ADCA  1149                                shlr.b  #2, r1l
0005ADCC  1149                                shlr.b  #2, r1l
0005ADCE  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ADD2  68ec                                mov.b   r4l, @er6
0005ADD4  0b06                                adds    #1, er6
0005ADD6  ea0f                                and.b   #0xF, r2l
0005ADD8  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ADDC  68ec                                mov.b   r4l, @er6
0005ADDE  0b06                                adds    #1, er6
0005ADE0  1a04                                dec.b   r4h
0005ADE2  46e2                                bne     loc_5ADC6:8
0005ADE4  68e3                                mov.b   r3h, @er6
0005ADE6  0b06                                adds    #1, er6
0005ADE8  1b5c                                dec.w   #1, e4
0005ADEA  46d8                                bne     loc_5ADC4:8
0005ADEC  f404                                mov.b   #4, r4h
0005ADEE  6c59                     loc_5ADEE  mov.b   @er5+, r1l
0005ADF0  0c9a                                mov.b   r1l, r2l
0005ADF2  1149                                shlr.b  #2, r1l
0005ADF4  1149                                shlr.b  #2, r1l
0005ADF6  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ADFA  68ec                                mov.b   r4l, @er6
0005ADFC  0b06                                adds    #1, er6
0005ADFE  ea0f                                and.b   #0xF, r2l
0005AE00  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AE04  68ec                                mov.b   r4l, @er6
0005AE06  0b06                                adds    #1, er6
0005AE08  1a04                                dec.b   r4h
0005AE0A  46e2                                bne     loc_5ADEE:8
0005AE0C  fc0d                                mov.b   #0xD, r4l
0005AE0E  68ec                                mov.b   r4l, @er6
0005AE10  0b06                                adds    #1, er6
0005AE12  fc0a                                mov.b   #0xA, r4l
0005AE14  68ec                                mov.b   r4l, @er6
0005AE16  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005AE1C  5470                     locret_5AE1C rts
0005AE1E  4350                     loc_5AE1E  bls     loc_5AE70:8
0005AE20  553e                                bsr     loc_5AE5F+1:8
0005AE22  4453                                bcc     loc_5AE75+1:8
0005AE24  503a                                mulxu.b r3h, e2
0005AE26  2000                                mov.b   @0xFFFFFF00:8, r0h
0005AE28  4453                     loc_5AE28  bcc     loc_5AE7C:8
0005AE2A  503e                                mulxu.b r3h, e6
0005AE2C  4350                                bls     loc_5AE7E:8
0005AE2E  553a                                bsr     loc_5AE69+1:8
0005AE30  2000                                mov.b   @0xFFFFFF00:8, r0h
0005AE32  0000                                nop
0005AE34  0000                                nop
0005AE36  00                                  .byte    0
0005AE37  05ae                                xorc    #0xAE, ccr
0005AE39  5a0005ae                            jmp     loc_5AE:24
0005AE3D  7200                                bclr    #0, r0h
0005AE3F  05ae                                xorc    #0xAE, ccr
0005AE41  8200                                add.b   #0, r2h
0005AE43  ff2d                                mov.b   #0x2D, r7l ; '-'
0005AE45  c800                                or.b    #0, r0l
0005AE47  05ae                                xorc    #0xAE, ccr
0005AE49  8800                                add.b   #0, r0l
0005AE4B  05ae                                xorc    #0xAE, ccr
0005AE4D  9600                                addx    #0, r6h
0005AE4F  ff2d                                mov.b   #0x2D, r7l ; '-'
0005AE51  c800                                or.b    #0, r0l
0005AE53  05ae                                xorc    #0xAE, ccr
0005AE55  a400                                cmp.b   #0, r4h
0005AE57  05ae                                xorc    #0xAE, ccr
0005AE59  b244                                subx    #0x44, r2h ; 'D'
0005AE5B  5350                                divxu.w r5, er0
0005AE5D  2050                                mov.b   @0xFFFFFF50:8, r0h
0005AE5F  4f57                     loc_5AE5F  ble     loc_5AEB8:8
0005AE61  4552                                bcs     loc_5AEB4:8
0005AE63  3a4f                                mov.b   r2l, @0xFFFFFF4F:8
0005AE65  4e20                                bgt     loc_5AE86:8
0005AE67  2620                                mov.b   @0xFFFFFF20:8, r6h
0005AE69  5245                     loc_5AE69  mulxu.w r4, er5
0005AE6B  5345                                divxu.w r4, er5
0005AE6D  54                                  .byte 0x54 ; T
0005AE6E  2120                                mov.b   @0xFFFFFF20:8, r1h
0005AE70  0d0a                     loc_5AE70  mov.w   r0, e2
0005AE72  54                                  .byte 0x54 ; T
0005AE73  494d                                bvs     loc_5AEC2:8
0005AE75  4520                     loc_5AE75  bcs     loc_5AE96:8
0005AE77  4f55                                ble     loc_5AECE:8
0005AE79  54                                  .byte 0x54 ; T
0005AE7A  3a33                                mov.b   r2l, @0xFFFFFF33:8
0005AE7C  7365                     loc_5AE7C  btst    #6, r5h
0005AE7E  6321                     loc_5AE7E  btst    r2h, r1h
0005AE80  0d0a                                mov.w   r0, e2
0005AE82  4453                                bcc     loc_5AED6:8
0005AE84  503f                                mulxu.b r3h, e7
0005AE86  0d0a                     loc_5AE86  mov.w   r0, e2
0005AE88  4453                                bcc     loc_5AEDC:8
0005AE8A  503e                                mulxu.b r3h, e6
0005AE8C  4350                                bls     loc_5AEDE:8
0005AE8E  553a                                bsr     sub_5AECA:8
0005AE90  2041                                mov.b   @0xFFFFFF41:8, r0h
0005AE92  434b                                bls     loc_5AEDE:8
0005AE94  0d0a                                mov.w   r0, e2
0005AE96  4453                     loc_5AE96  bcc     loc_5AEEA:8
0005AE98  503e                                mulxu.b r3h, e6
0005AE9A  4350                                bls     loc_5AEEC:8
0005AE9C  553a                                bsr     sub_5AED8:8
0005AE9E  204e                                mov.b   @0xFFFFFF4E:8, r0h
0005AEA0  414b                                brn     loc_5AEEC:8
0005AEA2  0d0a                                mov.w   r0, e2
0005AEA4  4350                                bls     loc_5AEF6:8
0005AEA6  553e                                bsr     sub_5AEE6:8
0005AEA8  4453                                bcc     loc_5AEFC:8
0005AEAA  503a                                mulxu.b r3h, e2
0005AEAC  2041                                mov.b   @0xFFFFFF41:8, r0h
0005AEAE  434b                                bls     loc_5AEFA:8
0005AEB0  0d0a                                mov.w   r0, e2
0005AEB2  4350                                bls     loc_5AF04:8
0005AEB4  553e                     loc_5AEB4  bsr     sub_5AEF4:8
0005AEB6  4453                                bcc     loc_5AF0A:8
0005AEB8  503a                     loc_5AEB8  mulxu.b r3h, e2
0005AEBA  204e                                mov.b   @0xFFFFFF4E:8, r0h
0005AEBC  414b                                brn     loc_5AF08:8
0005AEBE  0d0a                                mov.w   r0, e2
0005AEC0  4350                     loc_5AEC0  bls     loc_5AF12:8
0005AEC2  553e                     loc_5AEC2  bsr     sub_5AF02:8
0005AEC4  4453                                bcc     loc_5AF18:8
0005AEC6  503a                                mulxu.b r3h, e2
0005AEC8  2052                                mov.b   @0xFFFFFF52:8, r0h
0005AECA  58204449                 sub_5AECA  bhi     loc_5F316:16  ; <<< FUNC sub_5AECA
0005AECE  5341                     loc_5AECE  divxu.w r4, er1
0005AED0  424c                                bhi     loc_5AF1D+1:8
0005AED2  450d                                bcs     loc_5AEE0:8
0005AED4  0a00                                inc.b   r0h
0005AED6  4350                     loc_5AED6  bls     loc_5AF28:8
0005AED8  553e                     sub_5AED8  bsr     loc_5AF18:8  ; <<< FUNC sub_5AED8
0005AEDA  4453                                bcc     unk_5AF2E:8
0005AEDC  503a                     loc_5AEDC  mulxu.b r3h, e2
0005AEDE  2052                     loc_5AEDE  mov.b   @0xFFFFFF52:8, r0h
0005AEE0  5820454e                 loc_5AEE0  bhi     loc_5F42E+4:16
0005AEE4  4142                                brn     loc_5AF28:8
0005AEE6  4c45                     sub_5AEE6  bge     loc_5AF2C:8  ; <<< FUNC sub_5AEE6
0005AEE8  0d0a                                mov.w   r0, e2
0005AEEA  4350                     loc_5AEEA  bls     loc_5AF3C:8
0005AEEC  553e                     loc_5AEEC  bsr     loc_5AF2C:8
0005AEEE  4453                                bcc     unk_5AF42:8
0005AEF0  503a                                mulxu.b r3h, e2
0005AEF2  204d                                mov.b   @0xFFFFFF4D:8, r0h
0005AEF4  5554                     sub_5AEF4  bsr     sub_5AF4A:8  ; <<< FUNC sub_5AEF4
0005AEF6  4520                     loc_5AEF6  bcs     loc_5AF18:8
0005AEF8  4f4e                                ble     loc_5AF48:8
0005AEFA  0d0a                     loc_5AEFA  mov.w   r0, e2
0005AEFC  4350                     loc_5AEFC  bls     loc_5AF4E:8
0005AEFE  553e                                bsr     loc_5AF3E:8
0005AF00  4453                                bcc     loc_5AF54:8
0005AF02  503a                     sub_5AF02  mulxu.b r3h, e2  ; <<< FUNC sub_5AF02
0005AF04  204d                     loc_5AF04  mov.b   @0xFFFFFF4D:8, r0h
0005AF06  5554                                bsr     sub_5AF5C:8
0005AF08  4520                     loc_5AF08  bcs     loc_5AF2A:8
0005AF0A  4f46                     loc_5AF0A  ble     loc_5AF52:8
0005AF0C  460d                                bne     unk_5AF1A:8
0005AF0E  0a00                                inc.b   r0h
0005AF10  4350                     loc_5AF10  bls     loc_5AF62:8
0005AF12  553e                     loc_5AF12  bsr     loc_5AF52:8
0005AF14  4453                                bcc     loc_5AF68:8
0005AF16  503a                                mulxu.b r3h, e2
0005AF18  2053                     loc_5AF18  mov.b   @0xFFFFFF53:8, r0h
0005AF1A  54                       unk_5AF1A  .byte 0x54 ; T
0005AF1B  4f50                                ble     unk_5AF6C:8
0005AF1D  2045                     loc_5AF1D  mov.b   @0xFFFFFF45:8, r0h
0005AF1F  4e43                                bgt     loc_5AF64:8
0005AF21  4f44                                ble     loc_5AF66:8
0005AF23  450d                                bcs     loc_5AF31+1:8
0005AF25  0a                                  .byte  0xA
0005AF26  4350                     loc_5AF26  bls     loc_5AF74+4:8
0005AF28  553e                     loc_5AF28  bsr     loc_5AF68:8
0005AF2A  4453                     loc_5AF2A  bcc     loc_5AF7D+1:8
0005AF2C  503a                     loc_5AF2C  mulxu.b r3h, e2
0005AF2E  56                       unk_5AF2E  .byte 0x56 ; V
0005AF2F  4552                                bcs     loc_5AF81+1:8
0005AF31  3f0d                     loc_5AF31  mov.b   r7l, @0xFFFFFF0D:8
0005AF33  0a                                  .byte  0xA
0005AF34  4453                     sub_5AF34  bcc     loc_5AF87+1:8  ; <<< FUNC sub_5AF34
0005AF36  503e                                mulxu.b r3h, e6
0005AF38  4350                                bls     loc_5AF89+1:8
0005AF3A  553a                                bsr     loc_5AF74+2:8
0005AF3C  2044                     loc_5AF3C  mov.b   @0xFFFFFF44:8, r0h
0005AF3E  4154                     loc_5AF3E  brn     loc_5AF93+1:8
0005AF40  4120                                brn     loc_5AF62:8
0005AF42  54                       unk_5AF42  .byte 0x54 ; T
0005AF43  4558                                bcs     loc_5AF9B+1:8
0005AF45  54                                  .byte 0x54 ; T
0005AF46  2053                                mov.b   @0xFFFFFF53:8, r0h
0005AF48  4554                     loc_5AF48  bcs     loc_5AF9D+1:8
0005AF4A  0d0a                     sub_5AF4A  mov.w   r0, e2  ; <<< FUNC sub_5AF4A
0005AF4C  4453                     loc_5AF4C  bcc     loc_5AF9F+1:8
0005AF4E  503e                     loc_5AF4E  mulxu.b r3h, e6
0005AF50  4350                                bls     loc_5AFA1+1:8
0005AF52  553a                     loc_5AF52  bsr     loc_5AF8D+1:8
0005AF54  2054                     loc_5AF54  mov.b   @0xFFFFFF54:8, r0h
0005AF56  4552                                bcs     loc_5AFA9+1:8
0005AF58  4d20                                blt     loc_5AF7A:8
0005AF5A  54                                  .byte 0x54 ; T
0005AF5B  58                                  .byte 0x58 ; X
0005AF5C  0d0a                     sub_5AF5C  mov.w   r0, e2  ; <<< FUNC sub_5AF5C
0005AF5E  4453                     loc_5AF5E  bcc     loc_5AFB1+1:8
0005AF60  503e                                mulxu.b r3h, e6
0005AF62  4350                     loc_5AF62  bls     loc_5AFB3+1:8
0005AF64  553a                     loc_5AF64  bsr     loc_5AF9F+1:8
0005AF66  2054                     loc_5AF66  mov.b   @0xFFFFFF54:8, r0h
0005AF68  4552                     loc_5AF68  bcs     loc_5AFBB+1:8
0005AF6A  4d20                                blt     loc_5AF8B+1:8
0005AF6C  52                       unk_5AF6C  .byte 0x52 ; R
0005AF6D  58                                  .byte 0x58 ; X
0005AF6E  0d0a                                mov.w   r0, e2
0005AF70  6a0bb0a9                 sub_5AF70  mov.b   @0xFFFFB0A9:16, r3l  ; <<< FUNC sub_5AF70
0005AF74  7a63000000ff             loc_5AF74  and.l   #0xFF, er3
0005AF7A  1073                     loc_5AF7A  shll.l  #2, er3
0005AF7C  78                                  .byte 0x78 ; x
0005AF7D  b06b                     loc_5AF7D  subx    #0x6B, r0h ; 'k'
0005AF7F  2600                                mov.b   @0xFFFFFF00:8, r6h
0005AF81  05af                     loc_5AF81  xorc    #0xAF, ccr
0005AF83  9259                                addx    #0x59, r2h ; 'Y'
0005AF85  6000                                bset    r0h, r0h
0005AF87  05af                     loc_5AF87  xorc    #0xAF, ccr
0005AF89  ee00                     loc_5AF89  and.b   #0, r6l
0005AF8B  05af                     loc_5AF8B  xorc    #0xAF, ccr
0005AF8D  f800                     loc_5AF8D  mov.b   #0, r0l
0005AF8F  05b0                                xorc    #0xB0, ccr
0005AF91  1e00                                subx    r0h, r0h
0005AF93  05af                     loc_5AF93  xorc    #0xAF, ccr
0005AF95  ca00                                or.b    #0, r2l
0005AF97  05af                                xorc    #0xAF, ccr
0005AF99  ee00                                and.b   #0, r6l
0005AF9B  05af                     loc_5AF9B  xorc    #0xAF, ccr
0005AF9D  f800                     loc_5AF9D  mov.b   #0, r0l
0005AF9F  05af                     loc_5AF9F  xorc    #0xAF, ccr
0005AFA1  ee00                     loc_5AFA1  and.b   #0, r6l
0005AFA3  05b1                                xorc    #0xB1, ccr
0005AFA5  580005af                            bra     loc_5B556+2:16
0005AFA9  ee00                     loc_5AFA9  and.b   #0, r6l
0005AFAB  05b1                                xorc    #0xB1, ccr
0005AFAD  6e0005af                            mov.b   @(0x5AF:16,er0), r0h
0005AFB1  ee00                     loc_5AFB1  and.b   #0, r6l
0005AFB3  05b0                     loc_5AFB3  xorc    #0xB0, ccr
0005AFB5  cc00                                or.b    #0, r4l
0005AFB7  05af                                xorc    #0xAF, ccr
0005AFB9  ee00                                and.b   #0, r6l
0005AFBB  05b0                     loc_5AFBB  xorc    #0xB0, ccr
0005AFBD  f800                                mov.b   #0, r0l
0005AFBF  05af                                xorc    #0xAF, ccr
0005AFC1  ee00                                and.b   #0, r6l
0005AFC3  05b0                                xorc    #0xB0, ccr
0005AFC5  3a00                                mov.b   r2l, @0xFFFFFF00:8
0005AFC7  05b0                                xorc    #0xB0, ccr
0005AFC9  1e6a                                subx    r6h, r2l
0005AFCB  0cb0                                mov.b   r3l, r0h
0005AFCD  a847                                cmp.b   #0x47, r0l ; 'G'
0005AFCF  686a                                mov.b   @er6, r2l
0005AFD1  10b0                                shal.l  er0
0005AFD3  a473                                cmp.b   #0x73, r4h ; 's'
0005AFD5  1047                                shll.b  #2, r7h
0005AFD7  606a                                bset    r6h, r2l
0005AFD9  0cb0                                mov.b   r3l, r0h
0005AFDB  a44a                                cmp.b   #0x4A, r4h ; 'J'
0005AFDD  5a733c46                            jmp     0x733C46:24
0005AFE1  56                                  .byte 0x56 ; V
0005AFE2  5e05905e                            jsr     loc_5905D+1:24
0005AFE6  fc00                                mov.b   #0, r4l
0005AFE8  6a8cb0a8                            mov.b   r4l, @0xFFFFB0A8:16
0005AFEC  4024                                bra     loc_5B012:8
0005AFEE  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005AFF2  ec30                                and.b   #0x30, r4l
0005AFF4  4742                                beq     locret_5B038:8
0005AFF6  401a                                bra     loc_5B012:8
0005AFF8  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005AFFC  4a3a                                bpl     locret_5B038:8
0005AFFE  733c                                btst    #3, r4l
0005B000  4636                                bne     locret_5B038:8
0005B002  5e059240                            jsr     sub_59240:24
0005B006  6a18b0aa7270                        bclr    #7, @0xFFFFB0AA:16
0005B00C  6a18bbf97270                        bclr    #7, @0xFFFFBBF9:16
0005B012  6a0cb0a9                 loc_5B012  mov.b   @0xFFFFB0A9:16, r4l
0005B016  0a0c                                inc.b   r4l
0005B018  6a8cb0a9                            mov.b   r4l, @0xFFFFB0A9:16
0005B01C  401a                                bra     locret_5B038:8
0005B01E  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B022  ec30                                and.b   #0x30, r4l
0005B024  4712                                beq     locret_5B038:8
0005B026  6a18b0ac7270                        bclr    #7, @0xFFFFB0AC:16
0005B02C  6a18b0a47020                        bset    #2, @0xFFFFB0A4:16
0005B032  fc00                                mov.b   #0, r4l
0005B034  6a8cb0a9                            mov.b   r4l, @0xFFFFB0A9:16
0005B038  5470                     locret_5B038 rts
0005B03A  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B03E  4af8                                bpl     locret_5B038:8
0005B040  733c                                btst    #3, r4l
0005B042  46f4                                bne     locret_5B038:8
0005B044  6a0c8dde                            mov.b   @0xFFFF8DDE:16, r4l
0005B048  4708                                beq     loc_5B052:8
0005B04A  fc24                                mov.b   #0x24, r4l ; '$'
0005B04C  6aac00ff0bf6                        mov.b   r4l, @0xFF0BF6:32
0005B052  5e05b680                 loc_5B052  jsr     sub_5B680:24
0005B056  40ba                                bra     loc_5B012:8
0005B058  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B05C  4ada                                bpl     locret_5B038:8
0005B05E  733c                                btst    #3, r4l
0005B060  46d6                                bne     locret_5B038:8
0005B062  5e05b6a0                            jsr     sub_5B6A0:24
0005B066  40aa                                bra     loc_5B012:8
0005B068  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B06C  4aca                                bpl     locret_5B038:8
0005B06E  733c                                btst    #3, r4l
0005B070  46c6                                bne     locret_5B038:8
0005B072  5e05b6dc                            jsr     sub_5B6DC:24
0005B076  409a                                bra     loc_5B012:8
0005B078  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B07C  4a4c                                bpl     locret_5B0CA:8
0005B07E  733c                                btst    #3, r4l
0005B080  4648                                bne     locret_5B0CA:8
0005B082  5e05b680                            jsr     sub_5B680:24
0005B086  4028                                bra     loc_5B0B0:8
0005B088  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B08C  4a3c                                bpl     locret_5B0CA:8
0005B08E  733c                                btst    #3, r4l
0005B090  4638                                bne     locret_5B0CA:8
0005B092  5e05b6a0                            jsr     sub_5B6A0:24
0005B096  4018                                bra     loc_5B0B0:8
0005B098  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B09C  4a2c                                bpl     locret_5B0CA:8
0005B09E  733c                                btst    #3, r4l
0005B0A0  4628                                bne     locret_5B0CA:8
0005B0A2  5e05b6dc                            jsr     sub_5B6DC:24
0005B0A6  4008                                bra     loc_5B0B0:8
0005B0A8  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B0AC  ec30                                and.b   #0x30, r4l
0005B0AE  471a                                beq     locret_5B0CA:8
0005B0B0  6a0cb0ca                 loc_5B0B0  mov.b   @0xFFFFB0CA:16, r4l
0005B0B4  0a0c                                inc.b   r4l
0005B0B6  6a8cb0ca                            mov.b   r4l, @0xFFFFB0CA:16
0005B0BA  400e                                bra     locret_5B0CA:8
0005B0BC  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B0C0  ec30                                and.b   #0x30, r4l
0005B0C2  4706                                beq     locret_5B0CA:8
0005B0C4  fc00                                mov.b   #0, r4l
0005B0C6  6a8cb0c9                            mov.b   r4l, @0xFFFFB0C9:16
0005B0CA  5470                     locret_5B0CA rts
0005B0CC  6b04b0dc                            mov.w   @0xFFFFB0DC:16, r4
0005B0D0  7924041e                            cmp.w   #0x41E, r4
0005B0D4  440c                                bcc     loc_5B0E2:8
0005B0D6  6a0cb0a9                            mov.b   @0xFFFFB0A9:16, r4l
0005B0DA  8c04                                add.b   #4, r4l
0005B0DC  6a8cb0a9                            mov.b   r4l, @0xFFFFB0A9:16
0005B0E0  5470                                rts
0005B0E2  6a0cb0a4                 loc_5B0E2  mov.b   @0xFFFFB0A4:16, r4l
0005B0E6  58a0ff4e                            bpl     locret_5B038:16
0005B0EA  733c                                btst    #3, r4l
0005B0EC  5860ff48                            bne     locret_5B038:16
0005B0F0  5e05a0b4                            jsr     sub_5A0B4:24
0005B0F4  5800ff1a                            bra     loc_5B012:16
0005B0F8  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B0FC  58a0ff38                            bpl     locret_5B038:16
0005B100  733c                                btst    #3, r4l
0005B102  5860ff32                            bne     locret_5B038:16
0005B106  5e05a0c0                            jsr     sub_5A0C0:24
0005B10A  5800ff04                            bra     loc_5B012:16
0005B10E  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B112  4a42                                bpl     locret_5B156:8
0005B114  733c                                btst    #3, r4l
0005B116  463e                                bne     locret_5B156:8
0005B118  5e05a0b4                            jsr     sub_5A0B4:24
0005B11C  4018                                bra     loc_5B136:8
0005B11E  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B122  4a32                                bpl     locret_5B156:8
0005B124  733c                                btst    #3, r4l
0005B126  462e                                bne     locret_5B156:8
0005B128  5e05a0c0                            jsr     sub_5A0C0:24
0005B12C  4008                                bra     loc_5B136:8
0005B12E  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B132  ec30                                and.b   #0x30, r4l
0005B134  4720                                beq     locret_5B156:8
0005B136  6a0cb0af                 loc_5B136  mov.b   @0xFFFFB0AF:16, r4l
0005B13A  0a0c                                inc.b   r4l
0005B13C  6a8cb0af                            mov.b   r4l, @0xFFFFB0AF:16
0005B140  4014                                bra     locret_5B156:8
0005B142  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B146  ec30                                and.b   #0x30, r4l
0005B148  470c                                beq     locret_5B156:8
0005B14A  fc00                                mov.b   #0, r4l
0005B14C  6a8cb0ae                            mov.b   r4l, @0xFFFFB0AE:16
0005B150  fc00                                mov.b   #0, r4l
0005B152  6a8cb0af                            mov.b   r4l, @0xFFFFB0AF:16
0005B156  5470                     locret_5B156 rts
0005B158  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B15C  58a0fed8                            bpl     locret_5B038:16
0005B160  733c                                btst    #3, r4l
0005B162  5860fed2                            bne     locret_5B038:16
0005B166  5e05eaee                            jsr     sub_5EAEE:24
0005B16A  5800fea4                            bra     loc_5B012:16
0005B16E  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B172  58a0fec2                            bpl     locret_5B038:16
0005B176  733c                                btst    #3, r4l
0005B178  5860febc                            bne     locret_5B038:16
0005B17C  5e05eb4e                            jsr     sub_5EB4E:24
0005B180  5800fe8e                            bra     loc_5B012:16
0005B184  6a0bb0ca                 loc_5B184  mov.b   @0xFFFFB0CA:16, r3l
0005B188  7a63000000ff                        and.l   #0xFF, er3
0005B18E  1073                                shll.l  #2, er3
0005B190  78                                  .byte 0x78 ; x
0005B191  b06b                                subx    #0x6B, r0h ; 'k'
0005B193  2600                                mov.b   @0xFFFFFF00:8, r6h
0005B195  05b1                                xorc    #0xB1, ccr
0005B197  9a59                                addx    #0x59, r2l ; 'Y'
0005B199  6000                                bset    r0h, r0h
0005B19B  05b0                                xorc    #0xB0, ccr
0005B19D  78                                  .byte 0x78 ; x
0005B19E  00                                  .byte    0
0005B19F  05b0                                xorc    #0xB0, ccr
0005B1A1  bc6b                     loc_5B1A1  subx    #0x6B, r4l ; 'k'
0005B1A3  04b0                                orc     #0xB0, ccr
0005B1A5  dc79                                xor.b   #0x79, r4l
0005B1A7  2404                                mov.b   @0xFFFFFF04:8, r4h
0005B1A9  1e44                                subx    r4h, r4h
0005B1AB  10                                  .byte 0x10
0005B1AC  fc00                                mov.b   #0, r4l
0005B1AE  6a8cb0ae                            mov.b   r4l, @0xFFFFB0AE:16
0005B1B2  fc00                                mov.b   #0, r4l
0005B1B4  6a8cb0af                            mov.b   r4l, @0xFFFFB0AF:16
0005B1B8  fc00                                mov.b   #0, r4l
0005B1BA  5470                                rts
0005B1BC  6a10b0ae7370                        btst    #7, @0xFFFFB0AE:16
0005B1C2  4712                                beq     loc_5B1D6:8
0005B1C4  6a18b0ae7270                        bclr    #7, @0xFFFFB0AE:16
0005B1CA  6a18b0ae7000                        bset    #0, @0xFFFFB0AE:16
0005B1D0  fc00                                mov.b   #0, r4l
0005B1D2  6a8cb0af                            mov.b   r4l, @0xFFFFB0AF:16
0005B1D6  6a10b0ae7300             loc_5B1D6  btst    #0, @0xFFFFB0AE:16
0005B1DC  4718                                beq     locret_5B1F6:8
0005B1DE  6a0bb0af                            mov.b   @0xFFFFB0AF:16, r3l
0005B1E2  7a63000000ff                        and.l   #0xFF, er3
0005B1E8  1073                                shll.l  #2, er3
0005B1EA  78                                  .byte 0x78 ; x
0005B1EB  b06b                                subx    #0x6B, r0h ; 'k'
0005B1ED  2600                                mov.b   @0xFFFFFF00:8, r6h
0005B1EF  05b1                                xorc    #0xB1, ccr
0005B1F1  f85d                                mov.b   #0x5D, r0l ; ']'
0005B1F3  60fc                                bset    r7l, r4l
0005B1F5  01                                  .byte    1
0005B1F6  5470                     locret_5B1F6 rts
0005B1F8  00                                  .byte    0
0005B1F9  05b1                                xorc    #0xB1, ccr
0005B1FB  0e00                                addx    r0h, r0h
0005B1FD  05b1                                xorc    #0xB1, ccr
0005B1FF  2e00                                mov.b   @0xFFFFFF00:8, r6l
0005B201  05b1                                xorc    #0xB1, ccr
0005B203  1e00                                subx    r0h, r0h
0005B205  05b1                                xorc    #0xB1, ccr
0005B207  426a                     loc_5B207  bhi     loc_5B270+2:8
0005B209  18b0                                sub.b   r3l, r0h
0005B20B  ae70                                cmp.b   #0x70, r6l ; 'p'
0005B20D  7054                                bset    #5, r4h
0005B20F  706a                     loc_5B20F  bset    #6, r2l
0005B211  2c00                                mov.b   @0xFFFFFF00:8, r4l
0005B213  ffb0                                mov.b   #0xB0, r7l
0005B215  ab46                                cmp.b   #0x46, r3l ; 'F'
0005B217  2c6a                                mov.b   @0xFFFFFF6A:8, r4l
0005B219  0cb0                                mov.b   r3l, r0h
0005B21B  a44a                                cmp.b   #0x4A, r4h ; 'J'
0005B21D  3473                                mov.b   r4h, @0xFFFFFF73:8
0005B21F  3c46                                mov.b   r4l, @0xFFFFFF46:8
0005B221  30fc                                mov.b   r0h, @0xFFFFFFFC:8
0005B223  00                                  .byte    0
0005B224  6a8cb0ac                            mov.b   r4l, @0xFFFFB0AC:16
0005B228  5e059240                            jsr     sub_59240:24
0005B22C  6a18b0aa7270                        bclr    #7, @0xFFFFB0AA:16
0005B232  6a18bbf97270                        bclr    #7, @0xFFFFBBF9:16
0005B238  6a0cb0ab                            mov.b   @0xFFFFB0AB:16, r4l
0005B23C  0a0c                                inc.b   r4l
0005B23E  6a8cb0ab                            mov.b   r4l, @0xFFFFB0AB:16
0005B242  400e                                bra     locret_5B252:8
0005B244  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B248  ec30                                and.b   #0x30, r4l
0005B24A  4706                                beq     locret_5B252:8
0005B24C  fc00                                mov.b   #0, r4l
0005B24E  6a8cb0ab                            mov.b   r4l, @0xFFFFB0AB:16
0005B252  5470                     locret_5B252 rts
0005B254  6a2c00ffb0ad             sub_5B254  mov.b   @0xFFB0AD:32, r4l  ; <<< FUNC sub_5B254
0005B25A  461a                                bne     loc_5B276:8
0005B25C  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B260  4a28                                bpl     locret_5B28A:8
0005B262  733c                                btst    #3, r4l
0005B264  4624                                bne     locret_5B28A:8
0005B266  5e059240                            jsr     sub_59240:24
0005B26A  6a0cb0ad                            mov.b   @0xFFFFB0AD:16, r4l
0005B26E  0a0c                                inc.b   r4l
0005B270  6a8cb0ad                 loc_5B270  mov.b   r4l, @0xFFFFB0AD:16
0005B274  4014                                bra     locret_5B28A:8
0005B276  6a0cb0a4                 loc_5B276  mov.b   @0xFFFFB0A4:16, r4l
0005B27A  ec30                                and.b   #0x30, r4l
0005B27C  470c                                beq     locret_5B28A:8
0005B27E  6a18b0ac7270                        bclr    #7, @0xFFFFB0AC:16
0005B284  fc00                                mov.b   #0, r4l
0005B286  6a8cb0ad                            mov.b   r4l, @0xFFFFB0AD:16
0005B28A  5470                     locret_5B28A rts
0005B28C  6a2c00ffb0cf             sub_5B28C  mov.b   @0xFFB0CF:32, r4l  ; <<< FUNC sub_5B28C
0005B292  4628                                bne     loc_5B2BC:8
0005B294  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B298  4a3c                                bpl     locret_5B2D6:8
0005B29A  733c                                btst    #3, r4l
0005B29C  4638                                bne     locret_5B2D6:8
0005B29E  6a10b0ce7360                        btst    #6, @0xFFFFB0CE:16
0005B2A4  4706                                beq     loc_5B2AC:8
0005B2A6  5e059e16                            jsr     sub_59E16:24
0005B2AA  4004                                bra     loc_5B2B0:8
0005B2AC  5e059d94                 loc_5B2AC  jsr     sub_59D94:24
0005B2B0  6a0cb0cf                 loc_5B2B0  mov.b   @0xFFFFB0CF:16, r4l
0005B2B4  0a0c                                inc.b   r4l
0005B2B6  6a8cb0cf                            mov.b   r4l, @0xFFFFB0CF:16
0005B2BA  401a                                bra     locret_5B2D6:8
0005B2BC  6a0cb0a4                 loc_5B2BC  mov.b   @0xFFFFB0A4:16, r4l
0005B2C0  ec30                                and.b   #0x30, r4l
0005B2C2  4712                                beq     locret_5B2D6:8
0005B2C4  6a18b0ce7270                        bclr    #7, @0xFFFFB0CE:16
0005B2CA  6a18b0ce7050                        bset    #5, @0xFFFFB0CE:16
0005B2D0  fc00                                mov.b   #0, r4l
0005B2D2  6a8cb0cf                            mov.b   r4l, @0xFFFFB0CF:16
0005B2D6  5470                     locret_5B2D6 rts
0005B2D8  6a2c00ffb0d0             sub_5B2D8  mov.b   @0xFFB0D0:32, r4l  ; <<< FUNC sub_5B2D8
0005B2DE  461a                                bne     loc_5B2FA:8
0005B2E0  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B2E4  4a28                                bpl     locret_5B30E:8
0005B2E6  733c                                btst    #3, r4l
0005B2E8  4624                                bne     locret_5B30E:8
0005B2EA  5e05eb4e                            jsr     sub_5EB4E:24
0005B2EE  6a0cb0d0                            mov.b   @0xFFFFB0D0:16, r4l
0005B2F2  0a0c                                inc.b   r4l
0005B2F4  6a8cb0d0                            mov.b   r4l, @0xFFFFB0D0:16
0005B2F8  4014                                bra     locret_5B30E:8
0005B2FA  6a0cb0a4                 loc_5B2FA  mov.b   @0xFFFFB0A4:16, r4l
0005B2FE  ec30                                and.b   #0x30, r4l
0005B300  470c                                beq     locret_5B30E:8
0005B302  6a18b0ce7230                        bclr    #3, @0xFFFFB0CE:16
0005B308  fc00                                mov.b   #0, r4l
0005B30A  6a8cb0d0                            mov.b   r4l, @0xFFFFB0D0:16
0005B30E  5470                     locret_5B30E rts
0005B310  00                                  .byte    0
0005B311  05b3                                xorc    #0xB3, ccr
0005B313  8800                                add.b   #0, r0l
0005B315  05b3                                xorc    #0xB3, ccr
0005B317  8800                                add.b   #0, r0l
0005B319  05b4                                xorc    #0xB4, ccr
0005B31B  4200                     loc_5B31B  bhi     loc_5B31B+1:8
0005B31D  05b4                                xorc    #0xB4, ccr
0005B31F  4200                     loc_5B31F  bhi     loc_5B31F+1:8
0005B321  05b4                                xorc    #0xB4, ccr
0005B323  4200                     loc_5B323  bhi     loc_5B323+1:8
0005B325  05b4                                xorc    #0xB4, ccr
0005B327  4200                     loc_5B327  bhi     loc_5B327+1:8
0005B329  05bc                                xorc    #0xBC, ccr
0005B32B  ce00                                or.b    #0, r6l
0005B32D  05bd                                xorc    #0xBD, ccr
0005B32F  9200                                addx    #0, r2h
0005B331  05bd                                xorc    #0xBD, ccr
0005B333  9200                                addx    #0, r2h
0005B335  05bd                                xorc    #0xBD, ccr
0005B337  9200                                addx    #0, r2h
0005B339  05bd                                xorc    #0xBD, ccr
0005B33B  9200                                addx    #0, r2h
0005B33D  05bf                                xorc    #0xBF, ccr
0005B33F  a600                                cmp.b   #0, r6h
0005B341  05bf                                xorc    #0xBF, ccr
0005B343  a600                                cmp.b   #0, r6h
0005B345  05bf                                xorc    #0xBF, ccr
0005B347  a600                                cmp.b   #0, r6h
0005B349  05bf                                xorc    #0xBF, ccr
0005B34B  a600                                cmp.b   #0, r6h
0005B34D  05c3                                xorc    #0xC3, ccr
0005B34F  5200                                mulxu.w r0, er0
0005B351  05bf                                xorc    #0xBF, ccr
0005B353  a600                                cmp.b   #0, r6h
0005B355  05bf                                xorc    #0xBF, ccr
0005B357  a600                                cmp.b   #0, r6h
0005B359  05bf                                xorc    #0xBF, ccr
0005B35B  a600                                cmp.b   #0, r6h
0005B35D  05bf                                xorc    #0xBF, ccr
0005B35F  a600                                cmp.b   #0, r6h
0005B361  05c3                                xorc    #0xC3, ccr
0005B363  5200                                mulxu.w r0, er0
0005B365  05c3                                xorc    #0xC3, ccr
0005B367  f400                                mov.b   #0, r4h
0005B369  05c0                                xorc    #0xC0, ccr
0005B36B  4800                     loc_5B36B  bvc     loc_5B36B+1:8
0005B36D  05c1                                xorc    #0xC1, ccr
0005B36F  8e00                                add.b   #0, r6l
0005B371  0000                                nop
0005B373  0000                                nop
0005B375  0000                                nop
0005B377  01                                  .byte    1
0005B378  01                                  .byte    1
0005B379  01                                  .byte    1
0005B37A  01                                  .byte    1
0005B37B  0202                                stc.b   ccr, r2h
0005B37D  0202                                stc.b   ccr, r2h
0005B37F  0203                                stc.b   ccr, r3h
0005B381  0303                                ldc.b   r3h, ccr
0005B383  0303                                ldc.b   r3h, ccr
0005B385  00                                  .byte    0
0005B386  0200                                stc.b   ccr, r0h
0005B388  6a0bb0bf                            mov.b   @0xFFFFB0BF:16, r3l
0005B38C  7a63000000ff                        and.l   #0xFF, er3
0005B392  1073                                shll.l  #2, er3
0005B394  78                                  .byte 0x78 ; x
0005B395  b06b                                subx    #0x6B, r0h ; 'k'
0005B397  2600                                mov.b   @0xFFFFFF00:8, r6h
0005B399  05b3                                xorc    #0xB3, ccr
0005B39B  9e59                                addx    #0x59, r6l ; 'Y'
0005B39D  6000                                bset    r0h, r0h
0005B39F  05b3                                xorc    #0xB3, ccr
0005B3A1  ae00                                cmp.b   #0, r6l
0005B3A3  05b3                                xorc    #0xB3, ccr
0005B3A5  e200                                and.b   #0, r2h
0005B3A7  05b3                                xorc    #0xB3, ccr
0005B3A9  c800                                or.b    #0, r0l
0005B3AB  05b4                                xorc    #0xB4, ccr
0005B3AD  1c6a                                cmp.b   r6h, r2l
0005B3AF  0cb0                                mov.b   r3l, r0h
0005B3B1  a44a                                cmp.b   #0x4A, r4h ; 'J'
0005B3B3  1273                                rotxl.l #2, er3
0005B3B5  3c46                                mov.b   r4l, @0xFFFFFF46:8
0005B3B7  0e5e                                addx    r5h, r6l
0005B3B9  0590                                xorc    #0x90, ccr
0005B3BB  5e6a0cb0                            jsr     0x6A0CB0:24
0005B3BF  bf0a                                subx    #0xA, r7l
0005B3C1  0c6a                                mov.b   r6h, r2l
0005B3C3  8cb0                                add.b   #0xB0, r4l
0005B3C5  bf54                                subx    #0x54, r7l ; 'T'
0005B3C7  706a                                bset    #6, r2l
0005B3C9  0cb0                                mov.b   r3l, r0h
0005B3CB  a44a                                cmp.b   #0x4A, r4h ; 'J'
0005B3CD  1273                                rotxl.l #2, er3
0005B3CF  3c46                                mov.b   r4l, @0xFFFFFF46:8
0005B3D1  0e5e                                addx    r5h, r6l
0005B3D3  0592                                xorc    #0x92, ccr
0005B3D5  406a                                bra     locret_5B440+1:8
0005B3D7  0cb0                                mov.b   r3l, r0h
0005B3D9  bf0a                                subx    #0xA, r7l
0005B3DB  0c6a                                mov.b   r6h, r2l
0005B3DD  8cb0                                add.b   #0xB0, r4l
0005B3DF  bf54                                subx    #0x54, r7l ; 'T'
0005B3E1  706a                                bset    #6, r2l
0005B3E3  0cb0                                mov.b   r3l, r0h
0005B3E5  a4ec                                cmp.b   #0xEC, r4h
0005B3E7  3047                                mov.b   r0h, @0xFFFFFF47:8
0005B3E9  0a                                  .byte  0xA
0005B3EA  6a0cb0bf                            mov.b   @0xFFFFB0BF:16, r4l
0005B3EE  0a0c                                inc.b   r4l
0005B3F0  6a8cb0bf                            mov.b   r4l, @0xFFFFB0BF:16
0005B3F4  5470                                rts
0005B3F6  6a0cb0a4                            mov.b   @0xFFFFB0A4:16, r4l
0005B3FA  ec30                                and.b   #0x30, r4l
0005B3FC  471c                                beq     locret_5B41A:8
0005B3FE  6a0cb134                            mov.b   @0xFFFFB134:16, r4l


; ==== fusion_mode_fn_sub_5C7DE  0005C700-0005D340 ====
0005C700  f400                                mov.b   #0, r4h
0005C702  7bd4598f                 loc_5C702  eepmov.w
0005C706  0d44                                mov.w   r4, r4
0005C708  46f8                                bne     loc_5C702:8
0005C70A  fc05                                mov.b   #5, r4l
0005C70C  7a0500067fa4                        mov.l   #sub_67FA4, er5
0005C712  f400                                mov.b   #0, r4h
0005C714  7bd4598f                 loc_5C714  eepmov.w
0005C718  0d44                                mov.w   r4, r4
0005C71A  46f8                                bne     loc_5C714:8
0005C71C  fa0d                                mov.b   #0xD, r2l
0005C71E  4026                                bra     loc_5C746:8
0005C720  fc05                     loc_5C720  mov.b   #5, r4l
0005C722  7a0500ffb34f                        mov.l   #0xFFB34F, er5
0005C728  f400                                mov.b   #0, r4h
0005C72A  7bd4598f                 loc_5C72A  eepmov.w
0005C72E  0d44                                mov.w   r4, r4
0005C730  46f8                                bne     loc_5C72A:8
0005C732  fc05                                mov.b   #5, r4l
0005C734  7a0500067fa4                        mov.l   #sub_67FA4, er5
0005C73A  f400                                mov.b   #0, r4h
0005C73C  7bd4598f                 loc_5C73C  eepmov.w
0005C740  0d44                                mov.w   r4, r4
0005C742  46f8                                bne     loc_5C73C:8
0005C744  fa0d                                mov.b   #0xD, r2l
0005C746  6b058dd0                 loc_5C746  mov.w   @0xFFFF8DD0:16, r5
0005C74A  790d0000                            mov.w   #0, e5
0005C74E  5e06ee90                            jsr     sub_6EE90:24
0005C752  7a1600000005                        add.l   #5, er6
0005C758  01006df6                            push.l  er6
0005C75C  7a060005c778                        mov.l   #unk_5C778, er6
0005C762  5e03f6fa                            jsr     sub_3F6FA:24
0005C766  5e019a30                            jsr     sub_19A30:24
0005C76A  01006d76                            pop.l   er6
0005C76E  79040000                            mov.w   #0, r4
0005C772  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005C776  5470                                rts
0005C778  00                       unk_5C778  .byte    0
0005C779  01                                  .byte    1
0005C77A  ea60                                and.b   #0x60, r2l
0005C77C  00                                  .byte    0
0005C77D  ff8d                                mov.b   #0x8D, r7l
0005C77F  d06c                     loc_5C77F  xor.b   #0x6C, r0h
0005C781  5c                                  .byte 0x5C ; \
0005C782  acff                                cmp.b   #0xFF, r4l
0005C784  4708                                beq     sub_5C78E:8
0005C786  68ec                                mov.b   r4l, @er6
0005C788  0b06                                adds    #1, er6
0005C78A  1a0a                                dec.b   r2l
0005C78C  46f2                                bne     loc_5C77F+1:8
0005C78E  fc03                     sub_5C78E  mov.b   #3, r4l  ; <<< FUNC sub_5C78E
0005C790  68ec                                mov.b   r4l, @er6
0005C792  0b06                                adds    #1, er6
0005C794  fb00                                mov.b   #0, r3l
0005C796  7a0500ff0206                        mov.l   #0xFF0206, er5
0005C79C  1fe5                     loc_5C79C  cmp.l   er6, er5
0005C79E  4406                                bcc     loc_5C7A6:8
0005C7A0  6c5c                                mov.b   @er5+, r4l
0005C7A2  08cb                                add.b   r4l, r3l
0005C7A4  40f6                                bra     loc_5C79C:8
0005C7A6  68eb                     loc_5C7A6  mov.b   r3l, @er6
0005C7A8  0b06                                adds    #1, er6
0005C7AA  7a3600ff0206                        sub.l   #0xFF0206, er6
0005C7B0  fc01                                mov.b   #1, r4l
0005C7B2  4704                                beq     loc_5C7B8:8
0005C7B4  6b86b126                            mov.w   r6, @0xFFFFB126:16
0005C7B8  fc14                     loc_5C7B8  mov.b   #0x14, r4l
0005C7BA  51c6                                divxu.b r4l, r6
0005C7BC  0c66                                mov.b   r6h, r6h
0005C7BE  4702                                beq     loc_5C7C2:8
0005C7C0  0a0e                                inc.b   r6l
0005C7C2  6a8eb123                 loc_5C7C2  mov.b   r6l, @0xFFFFB123:16
0005C7C6  fc00                                mov.b   #0, r4l
0005C7C8  6a8cb122                            mov.b   r4l, @0xFFFFB122:16
0005C7CC  6a8cb106                            mov.b   r4l, @0xFFFFB106:16
0005C7D0  7a0400ff0206                        mov.l   #0xFF0206, er4
0005C7D6  01006b84b128                        mov.l   er4, @0xFFFFB128:16
0005C7DC  5470                                rts
0005C7DE  7a060005c876             sub_5C7DE  mov.l   #unk_5C876, er6  ; <<< FUNC sub_5C7DE
0005C7E4  5e03f636                            jsr     sub_3F636:24
0005C7E8  6a0cb11e                            mov.b   @0xFFFFB11E:16, r4l
0005C7EC  4644                                bne     loc_5C832:8
0005C7EE  5e05c602                            jsr     sub_5C602:24
0005C7F2  6a0cb11f                            mov.b   @0xFFFFB11F:16, r4l
0005C7F6  7a64000000ff                        and.l   #0xFF, er4
0005C7FC  78406a2b0006d1e6                    mov.b   @(loc_6D1E6:32,er4), r3l
0005C804  6a0cb0b7                            mov.b   @0xFFFFB0B7:16, r4l
0005C808  ac04                                cmp.b   #4, r4l
0005C80A  470a                                beq     loc_5C816:8
0005C80C  68eb                     loc_5C80C  mov.b   r3l, @er6
0005C80E  0b06                                adds    #1, er6
0005C810  1a0a                                dec.b   r2l
0005C812  46f8                                bne     loc_5C80C:8
0005C814  4016                                bra     loc_5C82C:8
0005C816  79040006                 loc_5C816  mov.w   #6, r4
0005C81A  7a050005d2f2                        mov.l   #unk_5D2F2, er5
0005C820  7bd4598f                 loc_5C820  eepmov.w
0005C824  0d44                                mov.w   r4, r4
0005C826  46f8                                bne     loc_5C820:8
0005C828  68eb                                mov.b   r3l, @er6
0005C82A  0b06                                adds    #1, er6
0005C82C  5e05c78e                 loc_5C82C  jsr     sub_5C78E:24
0005C830  4042                                bra     locret_5C874:8
0005C832  5e05c87c                 loc_5C832  jsr     sub_5C87C:24
0005C836  6a0cb11f                            mov.b   @0xFFFFB11F:16, r4l
0005C83A  7a64000000ff                        and.l   #0xFF, er4
0005C840  78406a2b0006d1e6                    mov.b   @(loc_6D1E6:32,er4), r3l
0005C848  6a0cb0b7                            mov.b   @0xFFFFB0B7:16, r4l
0005C84C  ac0d                                cmp.b   #0xD, r4l
0005C84E  470a                                beq     loc_5C85A:8
0005C850  68eb                     loc_5C850  mov.b   r3l, @er6
0005C852  0b06                                adds    #1, er6
0005C854  1a0a                                dec.b   r2l
0005C856  46f8                                bne     loc_5C850:8
0005C858  4016                                bra     loc_5C870:8
0005C85A  79040005                 loc_5C85A  mov.w   #5, r4
0005C85E  7a050005d2f2                        mov.l   #unk_5D2F2, er5
0005C864  7bd4598f                 loc_5C864  eepmov.w
0005C868  0d44                                mov.w   r4, r4
0005C86A  46f8                                bne     loc_5C864:8
0005C86C  68eb                                mov.b   r3l, @er6
0005C86E  0b06                                adds    #1, er6
0005C870  5e05c9e4                 loc_5C870  jsr     sub_5C9E4:24
0005C874  5470                     locret_5C874 rts
0005C876  00                       unk_5C876  .byte    0
0005C877  7f                                  .byte 0x7F ; 
0005C878  00                                  .byte    0
0005C879  ffb1                                mov.b   #0xB1, r7l
0005C87B  1f                                  .byte 0x1F
0005C87C  6a03b11f                 sub_5C87C  mov.b   @0xFFFFB11F:16, r3h  ; <<< FUNC sub_5C87C
0005C880  fb22                                mov.b   #0x22, r3l ; '"'
0005C882  6ba300ff0206                        mov.w   r3, @0xFF0206:32
0005C888  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005C88E  461e                                bne     loc_5C8AE:8
0005C890  fb61                     loc_5C890  mov.b   #0x61, r3l ; 'a'
0005C892  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C898  68eb                                mov.b   r3l, @er6
0005C89A  0b06                                adds    #1, er6
0005C89C  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C89E  68ec                                mov.b   r4l, @er6
0005C8A0  0b06                                adds    #1, er6
0005C8A2  fc30                                mov.b   #0x30, r4l ; '0'
0005C8A4  68ec                                mov.b   r4l, @er6
0005C8A6  0b06                                adds    #1, er6
0005C8A8  fa0d                                mov.b   #0xD, r2l
0005C8AA  58000108                            bra     loc_5C9B6:16
0005C8AE  5e023038                 loc_5C8AE  jsr     sub_23038:24
0005C8B2  47dc                                beq     loc_5C890:8
0005C8B4  fb62                                mov.b   #0x62, r3l ; 'b'
0005C8B6  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C8BC  68eb                                mov.b   r3l, @er6
0005C8BE  0b06                                adds    #1, er6
0005C8C0  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C8C2  68ec                                mov.b   r4l, @er6
0005C8C4  0b06                                adds    #1, er6
0005C8C6  fc30                                mov.b   #0x30, r4l ; '0'
0005C8C8  68ec                                mov.b   r4l, @er6
0005C8CA  0b06                                adds    #1, er6
0005C8CC  5e049758                            jsr     sub_49758:24
0005C8D0  fc20                                mov.b   #0x20, r4l ; ' '
0005C8D2  68ec                                mov.b   r4l, @er6
0005C8D4  0b06                                adds    #1, er6
0005C8D6  fa0d                                mov.b   #0xD, r2l
0005C8D8  580000da                            bra     loc_5C9B6:16
0005C8DC  6a03b11f                            mov.b   @0xFFFFB11F:16, r3h
0005C8E0  fb5d                                mov.b   #0x5D, r3l ; ']'
0005C8E2  6ba300ff0206                        mov.w   r3, @0xFF0206:32
0005C8E8  fb61                                mov.b   #0x61, r3l ; 'a'
0005C8EA  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C8F0  68eb                                mov.b   r3l, @er6
0005C8F2  0b06                                adds    #1, er6
0005C8F4  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C8F6  68ec                                mov.b   r4l, @er6
0005C8F8  0b06                                adds    #1, er6
0005C8FA  fc30                                mov.b   #0x30, r4l ; '0'
0005C8FC  68ec                                mov.b   r4l, @er6
0005C8FE  0b06                                adds    #1, er6
0005C900  5e05c9c0                            jsr     sub_5C9C0:24
0005C904  fc0a                                mov.b   #0xA, r4l
0005C906  f400                                mov.b   #0, r4h
0005C908  7bd4598f                 loc_5C908  eepmov.w
0005C90C  0d44                                mov.w   r4, r4
0005C90E  46f8                                bne     loc_5C908:8
0005C910  fa0d                                mov.b   #0xD, r2l
0005C912  580000a0                            bra     loc_5C9B6:16
0005C916  6a03b11f                            mov.b   @0xFFFFB11F:16, r3h
0005C91A  fb5d                                mov.b   #0x5D, r3l ; ']'
0005C91C  6ba300ff0206                        mov.w   r3, @0xFF0206:32
0005C922  fb77                                mov.b   #0x77, r3l ; 'w'
0005C924  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C92A  68eb                                mov.b   r3l, @er6
0005C92C  0b06                                adds    #1, er6
0005C92E  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C930  68ec                                mov.b   r4l, @er6
0005C932  0b06                                adds    #1, er6
0005C934  fc30                                mov.b   #0x30, r4l ; '0'
0005C936  68ec                                mov.b   r4l, @er6
0005C938  0b06                                adds    #1, er6
0005C93A  4024                                bra     loc_5C960:8
0005C93C  6a03b11f                            mov.b   @0xFFFFB11F:16, r3h
0005C940  fb5d                                mov.b   #0x5D, r3l ; ']'
0005C942  6ba300ff0206                        mov.w   r3, @0xFF0206:32
0005C948  fb76                                mov.b   #0x76, r3l ; 'v'
0005C94A  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C950  68eb                                mov.b   r3l, @er6
0005C952  0b06                                adds    #1, er6
0005C954  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C956  68ec                                mov.b   r4l, @er6
0005C958  0b06                                adds    #1, er6
0005C95A  fc30                                mov.b   #0x30, r4l ; '0'
0005C95C  68ec                                mov.b   r4l, @er6
0005C95E  0b06                                adds    #1, er6
0005C960  6a0cb26e                 loc_5C960  mov.b   @0xFFFFB26E:16, r4l
0005C964  ac02                                cmp.b   #2, r4l
0005C966  4728                                beq     loc_5C990:8
0005C968  fc05                                mov.b   #5, r4l
0005C96A  7a0500ffb2c9                        mov.l   #0xFFB2C9, er5
0005C970  f400                                mov.b   #0, r4h
0005C972  7bd4598f                 loc_5C972  eepmov.w
0005C976  0d44                                mov.w   r4, r4
0005C978  46f8                                bne     loc_5C972:8
0005C97A  fc05                                mov.b   #5, r4l
0005C97C  7a0500067fa4                        mov.l   #sub_67FA4, er5
0005C982  f400                                mov.b   #0, r4h
0005C984  7bd4598f                 loc_5C984  eepmov.w
0005C988  0d44                                mov.w   r4, r4
0005C98A  46f8                                bne     loc_5C984:8
0005C98C  fa0d                                mov.b   #0xD, r2l
0005C98E  4026                                bra     loc_5C9B6:8
0005C990  fc05                     loc_5C990  mov.b   #5, r4l
0005C992  7a0500ffb34f                        mov.l   #0xFFB34F, er5
0005C998  f400                                mov.b   #0, r4h
0005C99A  7bd4598f                 loc_5C99A  eepmov.w
0005C99E  0d44                                mov.w   r4, r4
0005C9A0  46f8                                bne     loc_5C99A:8
0005C9A2  fc05                                mov.b   #5, r4l
0005C9A4  7a0500067fa4                        mov.l   #sub_67FA4, er5
0005C9AA  f400                                mov.b   #0, r4h
0005C9AC  7bd4598f                 loc_5C9AC  eepmov.w
0005C9B0  0d44                                mov.w   r4, r4
0005C9B2  46f8                                bne     loc_5C9AC:8
0005C9B4  fa0d                                mov.b   #0xD, r2l
0005C9B6  79040000                 loc_5C9B6  mov.w   #0, r4
0005C9BA  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005C9BE  5470                                rts
0005C9C0  7a0500ffb2c9             sub_5C9C0  mov.l   #0xFFB2C9, er5  ; <<< FUNC sub_5C9C0
0005C9C6  6a10aad47340                        btst    #4, @0xFFFFAAD4:16
0005C9CC  4606                                bne     locret_5C9D4:8
0005C9CE  7a0500ffb314                        mov.l   #0xFFB314, er5
0005C9D4  5470                     locret_5C9D4 rts
0005C9D6  6c5c                     sub_5C9D6  mov.b   @er5+, r4l  ; <<< FUNC sub_5C9D6
0005C9D8  acff                                cmp.b   #0xFF, r4l
0005C9DA  4708                                beq     sub_5C9E4:8
0005C9DC  68ec                                mov.b   r4l, @er6
0005C9DE  0b06                                adds    #1, er6
0005C9E0  1a0a                                dec.b   r2l
0005C9E2  46f2                                bne     sub_5C9D6:8
0005C9E4  fc03                     sub_5C9E4  mov.b   #3, r4l  ; <<< FUNC sub_5C9E4
0005C9E6  68ec                                mov.b   r4l, @er6
0005C9E8  0b06                                adds    #1, er6
0005C9EA  fb00                                mov.b   #0, r3l
0005C9EC  7a0500ff0206                        mov.l   #0xFF0206, er5
0005C9F2  1fe5                     loc_5C9F2  cmp.l   er6, er5
0005C9F4  4406                                bcc     loc_5C9FC:8
0005C9F6  6c5c                                mov.b   @er5+, r4l
0005C9F8  08cb                                add.b   r4l, r3l
0005C9FA  40f6                                bra     loc_5C9F2:8
0005C9FC  68eb                     loc_5C9FC  mov.b   r3l, @er6
0005C9FE  0b06                                adds    #1, er6
0005CA00  7a3600ff0206                        sub.l   #0xFF0206, er6
0005CA06  fc01                                mov.b   #1, r4l
0005CA08  4704                                beq     loc_5CA0E:8
0005CA0A  6b86b126                            mov.w   r6, @0xFFFFB126:16
0005CA0E  fc0a                     loc_5CA0E  mov.b   #0xA, r4l
0005CA10  51c6                                divxu.b r4l, r6
0005CA12  0c66                                mov.b   r6h, r6h
0005CA14  4702                                beq     loc_5CA18:8
0005CA16  0a0e                                inc.b   r6l
0005CA18  6a8eb123                 loc_5CA18  mov.b   r6l, @0xFFFFB123:16
0005CA1C  fc00                                mov.b   #0, r4l
0005CA1E  6a8cb122                            mov.b   r4l, @0xFFFFB122:16
0005CA22  6a8cb106                            mov.b   r4l, @0xFFFFB106:16
0005CA26  7a0400ff0206                        mov.l   #0xFF0206, er4
0005CA2C  01006b84b128                        mov.l   er4, @0xFFFFB128:16
0005CA32  5470                                rts
0005CA34  6a0cb0bf                 sub_5CA34  mov.b   @0xFFFFB0BF:16, r4l  ; <<< FUNC sub_5CA34
0005CA38  ac10                                cmp.b   #0x10, r4l
0005CA3A  461a                                bne     locret_5CA56:8
0005CA3C  7a060005c876             loc_5CA3C  mov.l   #unk_5C876, er6
0005CA42  5e03f636                            jsr     sub_3F636:24
0005CA46  5e05c50c                            jsr     sub_5C50C:24
0005CA4A  fc01                                mov.b   #1, r4l
0005CA4C  6a8cb0bc                            mov.b   r4l, @0xFFFFB0BC:16
0005CA50  fc19                                mov.b   #0x19, r4l
0005CA52  6a8c9597                            mov.b   r4l, @0xFFFF9597:16
0005CA56  5470                     locret_5CA56 rts
0005CA58  6a0cb0bf                 sub_5CA58  mov.b   @0xFFFFB0BF:16, r4l  ; <<< FUNC sub_5CA58
0005CA5C  ac0f                                cmp.b   #0xF, r4l
0005CA5E  47dc                                beq     loc_5CA3C:8
0005CA60  5470                                rts
0005CA62  f300                     sub_5CA62  mov.b   #0, r3h  ; <<< FUNC sub_5CA62
0005CA64  fb22                                mov.b   #0x22, r3l ; '"'
0005CA66  6ba300ff0206                        mov.w   r3, @0xFF0206:32
0005CA6C  fb61                                mov.b   #0x61, r3l ; 'a'
0005CA6E  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CA74  68eb                                mov.b   r3l, @er6
0005CA76  0b06                                adds    #1, er6
0005CA78  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CA7A  68ec                                mov.b   r4l, @er6
0005CA7C  0b06                                adds    #1, er6
0005CA7E  fc30                                mov.b   #0x30, r4l ; '0'
0005CA80  68ec                                mov.b   r4l, @er6
0005CA82  0b06                                adds    #1, er6
0005CA84  fa0d                                mov.b   #0xD, r2l
0005CA86  79040000                            mov.w   #0, r4
0005CA8A  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005CA8E  5470                                rts
0005CA90  fc03                     sub_5CA90  mov.b   #3, r4l  ; <<< FUNC sub_5CA90
0005CA92  68ec                                mov.b   r4l, @er6
0005CA94  0b06                                adds    #1, er6
0005CA96  fb00                                mov.b   #0, r3l
0005CA98  7a0500ff0206                        mov.l   #0xFF0206, er5
0005CA9E  1fe5                     loc_5CA9E  cmp.l   er6, er5
0005CAA0  4406                                bcc     loc_5CAA8:8
0005CAA2  6c5c                                mov.b   @er5+, r4l
0005CAA4  08cb                                add.b   r4l, r3l
0005CAA6  40f6                                bra     loc_5CA9E:8
0005CAA8  68eb                     loc_5CAA8  mov.b   r3l, @er6
0005CAAA  0b06                                adds    #1, er6
0005CAAC  7a3600ff0206                        sub.l   #0xFF0206, er6
0005CAB2  fc01                                mov.b   #1, r4l
0005CAB4  4704                                beq     loc_5CABA:8
0005CAB6  6b86b126                            mov.w   r6, @0xFFFFB126:16
0005CABA  fc0a                     loc_5CABA  mov.b   #0xA, r4l
0005CABC  51c6                                divxu.b r4l, r6
0005CABE  0c66                                mov.b   r6h, r6h
0005CAC0  4702                                beq     loc_5CAC4:8
0005CAC2  0a0e                                inc.b   r6l
0005CAC4  6a8eb123                 loc_5CAC4  mov.b   r6l, @0xFFFFB123:16
0005CAC8  fc00                                mov.b   #0, r4l
0005CACA  6a8cb122                            mov.b   r4l, @0xFFFFB122:16
0005CACE  6a8cb106                            mov.b   r4l, @0xFFFFB106:16
0005CAD2  7a0400ff0206                        mov.l   #0xFF0206, er4
0005CAD8  01006b84b128                        mov.l   er4, @0xFFFFB128:16
0005CADE  5470                                rts
0005CAE0  6a03b11f                            mov.b   @0xFFFFB11F:16, r3h
0005CAE4  fb5e                                mov.b   #0x5E, r3l ; '^'
0005CAE6  4018                                bra     loc_5CB00:8
0005CAE8  6a03b11f                 sub_5CAE8  mov.b   @0xFFFFB11F:16, r3h  ; <<< FUNC sub_5CAE8
0005CAEC  fb4e                                mov.b   #0x4E, r3l ; 'N'
0005CAEE  4010                                bra     loc_5CB00:8
0005CAF0  6a03b11f                 sub_5CAF0  mov.b   @0xFFFFB11F:16, r3h  ; <<< FUNC sub_5CAF0
0005CAF4  fb5d                                mov.b   #0x5D, r3l ; ']'
0005CAF6  4008                                bra     loc_5CB00:8
0005CAF8  6a03b11f                 sub_5CAF8  mov.b   @0xFFFFB11F:16, r3h  ; <<< FUNC sub_5CAF8
0005CAFC  fb47                                mov.b   #0x47, r3l ; 'G'
0005CAFE  4000                                bra     loc_5CB00:8
0005CB00  6ba300ff0206             loc_5CB00  mov.w   r3, @0xFF0206:32
0005CB06  6a0bb0b9                            mov.b   @0xFFFFB0B9:16, r3l
0005CB0A  7a63000000ff                        and.l   #0xFF, er3
0005CB10  1073                                shll.l  #2, er3
0005CB12  78                                  .byte 0x78 ; x
0005CB13  b06b                                subx    #0x6B, r0h ; 'k'
0005CB15  2600                                mov.b   @0xFFFFFF00:8, r6h
0005CB17  05ce                                xorc    #0xCE, ccr
0005CB19  9859                                addx    #0x59, r0l ; 'Y'
0005CB1B  606a                                bset    r6h, r2l
0005CB1D  108d                                shal.b  r5l
0005CB1F  8273                                add.b   #0x73, r2h ; 's'
0005CB21  00                                  .byte    0
0005CB22  461e                                bne     loc_5CB42:8
0005CB24  fb43                     loc_5CB24  mov.b   #0x43, r3l ; 'C'
0005CB26  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CB2C  68eb                                mov.b   r3l, @er6
0005CB2E  0b06                                adds    #1, er6
0005CB30  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CB32  68ec                                mov.b   r4l, @er6
0005CB34  0b06                                adds    #1, er6
0005CB36  fc30                                mov.b   #0x30, r4l ; '0'
0005CB38  68ec                                mov.b   r4l, @er6
0005CB3A  0b06                                adds    #1, er6
0005CB3C  790c0407                            mov.w   #0x407, e4
0005CB40  4026                                bra     locret_5CB68:8
0005CB42  5e023038                 loc_5CB42  jsr     sub_23038:24
0005CB46  47dc                                beq     loc_5CB24:8
0005CB48  fb44                                mov.b   #0x44, r3l ; 'D'
0005CB4A  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CB50  68eb                                mov.b   r3l, @er6
0005CB52  0b06                                adds    #1, er6
0005CB54  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CB56  68ec                                mov.b   r4l, @er6
0005CB58  0b06                                adds    #1, er6
0005CB5A  fc30                                mov.b   #0x30, r4l ; '0'
0005CB5C  68ec                                mov.b   r4l, @er6
0005CB5E  0b06                                adds    #1, er6
0005CB60  5e0496a6                            jsr     sub_496A6:24
0005CB64  790c03f5                            mov.w   #0x3F5, e4
0005CB68  5470                     locret_5CB68 rts
0005CB6A  7a0600ff020b                        mov.l   #0xFF020B, er6
0005CB70  fc20                                mov.b   #0x20, r4l ; ' '
0005CB72  68ec                                mov.b   r4l, @er6
0005CB74  0b06                                adds    #1, er6
0005CB76  68ec                                mov.b   r4l, @er6
0005CB78  0b06                                adds    #1, er6
0005CB7A  68ec                                mov.b   r4l, @er6
0005CB7C  0b06                                adds    #1, er6
0005CB7E  6a0db1c2                            mov.b   @0xFFFFB1C2:16, r5l
0005CB82  100d                                shll.b  r5l
0005CB84  7a65000000ff                        and.l   #0xFF, er5
0005CB8A  6f544004                            mov.w   @(0x4004:16,er5), r4
0005CB8E  68e4                                mov.b   r4h, @er6
0005CB90  0b06                                adds    #1, er6
0005CB92  68ec                                mov.b   r4l, @er6
0005CB94  0b06                                adds    #1, er6
0005CB96  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005CB9C  4624                                bne     loc_5CBC2:8
0005CB9E  fb45                     loc_5CB9E  mov.b   #0x45, r3l ; 'E'
0005CBA0  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CBA6  68eb                                mov.b   r3l, @er6
0005CBA8  0b06                                adds    #1, er6
0005CBAA  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CBAC  68ec                                mov.b   r4l, @er6
0005CBAE  0b06                                adds    #1, er6
0005CBB0  fc30                                mov.b   #0x30, r4l ; '0'
0005CBB2  68ec                                mov.b   r4l, @er6
0005CBB4  0b06                                adds    #1, er6
0005CBB6  7a1600000005                        add.l   #5, er6
0005CBBC  790c0402                            mov.w   #0x402, e4
0005CBC0  402c                                bra     locret_5CBEE:8
0005CBC2  5e023038                 loc_5CBC2  jsr     sub_23038:24
0005CBC6  47d6                                beq     loc_5CB9E:8
0005CBC8  fb46                                mov.b   #0x46, r3l ; 'F'
0005CBCA  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CBD0  68eb                                mov.b   r3l, @er6
0005CBD2  0b06                                adds    #1, er6
0005CBD4  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CBD6  68ec                                mov.b   r4l, @er6
0005CBD8  0b06                                adds    #1, er6
0005CBDA  fc30                                mov.b   #0x30, r4l ; '0'
0005CBDC  68ec                                mov.b   r4l, @er6
0005CBDE  0b06                                adds    #1, er6
0005CBE0  7a1600000005                        add.l   #5, er6
0005CBE6  5e0496a6                            jsr     sub_496A6:24
0005CBEA  790c03f0                            mov.w   #0x3F0, e4
0005CBEE  5470                     locret_5CBEE rts
0005CBF0  7a0600ff020b                        mov.l   #0xFF020B, er6
0005CBF6  fc20                                mov.b   #0x20, r4l ; ' '
0005CBF8  68ec                                mov.b   r4l, @er6
0005CBFA  0b06                                adds    #1, er6
0005CBFC  68ec                                mov.b   r4l, @er6
0005CBFE  0b06                                adds    #1, er6
0005CC00  68ec                                mov.b   r4l, @er6
0005CC02  0b06                                adds    #1, er6
0005CC04  6a0db1c2                            mov.b   @0xFFFFB1C2:16, r5l
0005CC08  100d                                shll.b  r5l
0005CC0A  7a65000000ff                        and.l   #0xFF, er5
0005CC10  6f544004                            mov.w   @(0x4004:16,er5), r4
0005CC14  68e4                                mov.b   r4h, @er6
0005CC16  0b06                                adds    #1, er6
0005CC18  68ec                                mov.b   r4l, @er6
0005CC1A  0b06                                adds    #1, er6
0005CC1C  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005CC22  4626                                bne     loc_5CC4A:8
0005CC24  fb65                     loc_5CC24  mov.b   #0x65, r3l ; 'e'
0005CC26  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CC2C  68eb                                mov.b   r3l, @er6
0005CC2E  0b06                                adds    #1, er6
0005CC30  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CC32  68ec                                mov.b   r4l, @er6
0005CC34  0b06                                adds    #1, er6
0005CC36  fc30                                mov.b   #0x30, r4l ; '0'
0005CC38  68ec                                mov.b   r4l, @er6
0005CC3A  0b06                                adds    #1, er6
0005CC3C  7a1600000005                        add.l   #5, er6
0005CC42  790c0058                            mov.w   #0x58, e4 ; 'X'
0005CC46  fa58                                mov.b   #0x58, r2l ; 'X'
0005CC48  402e                                bra     loc_5CC78:8
0005CC4A  5e023038                 loc_5CC4A  jsr     sub_23038:24
0005CC4E  47d4                                beq     loc_5CC24:8
0005CC50  fb66                                mov.b   #0x66, r3l ; 'f'
0005CC52  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CC58  68eb                                mov.b   r3l, @er6
0005CC5A  0b06                                adds    #1, er6
0005CC5C  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CC5E  68ec                                mov.b   r4l, @er6
0005CC60  0b06                                adds    #1, er6
0005CC62  fc30                                mov.b   #0x30, r4l ; '0'
0005CC64  68ec                                mov.b   r4l, @er6
0005CC66  0b06                                adds    #1, er6
0005CC68  7a1600000005                        add.l   #5, er6
0005CC6E  5e0496a6                            jsr     sub_496A6:24
0005CC72  790c0046                            mov.w   #0x46, e4 ; 'F'
0005CC76  fa46                                mov.b   #0x46, r2l ; 'F'
0005CC78  79040000                 loc_5CC78  mov.w   #0, r4
0005CC7C  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005CC80  5470                                rts
0005CC82  fb30                     loc_5CC82  mov.b   #0x30, r3l ; '0'
0005CC84  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CC8A  68eb                                mov.b   r3l, @er6
0005CC8C  0b06                                adds    #1, er6
0005CC8E  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CC90  68ec                                mov.b   r4l, @er6
0005CC92  0b06                                adds    #1, er6
0005CC94  fc30                                mov.b   #0x30, r4l ; '0'
0005CC96  68ec                                mov.b   r4l, @er6
0005CC98  0b06                                adds    #1, er6
0005CC9A  790c0058                            mov.w   #0x58, e4 ; 'X'
0005CC9E  fa58                                mov.b   #0x58, r2l ; 'X'
0005CCA0  402e                                bra     loc_5CCD0:8
0005CCA2  5e023038                            jsr     sub_23038:24
0005CCA6  47da                                beq     loc_5CC82:8
0005CCA8  fb31                                mov.b   #0x31, r3l ; '1'
0005CCAA  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CCB0  68eb                                mov.b   r3l, @er6
0005CCB2  0b06                                adds    #1, er6
0005CCB4  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CCB6  68ec                                mov.b   r4l, @er6
0005CCB8  0b06                                adds    #1, er6
0005CCBA  fc30                                mov.b   #0x30, r4l ; '0'
0005CCBC  68ec                                mov.b   r4l, @er6
0005CCBE  0b06                                adds    #1, er6
0005CCC0  7a1600000005                        add.l   #5, er6
0005CCC6  5e0496a6                            jsr     sub_496A6:24
0005CCCA  790c0046                            mov.w   #0x46, e4 ; 'F'
0005CCCE  fa46                                mov.b   #0x46, r2l ; 'F'
0005CCD0  79040000                 loc_5CCD0  mov.w   #0, r4
0005CCD4  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005CCD8  5470                                rts
0005CCDA  fb62                                mov.b   #0x62, r3l ; 'b'
0005CCDC  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CCE2  68eb                                mov.b   r3l, @er6
0005CCE4  0b06                                adds    #1, er6
0005CCE6  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CCE8  68ec                                mov.b   r4l, @er6
0005CCEA  0b06                                adds    #1, er6
0005CCEC  fc30                                mov.b   #0x30, r4l ; '0'
0005CCEE  68ec                                mov.b   r4l, @er6
0005CCF0  0b06                                adds    #1, er6
0005CCF2  790c0407                            mov.w   #0x407, e4
0005CCF6  5470                                rts
0005CCF8  fb72                                mov.b   #0x72, r3l ; 'r'
0005CCFA  4036                                bra     loc_5CD32:8
0005CCFC  fb41                                mov.b   #0x41, r3l ; 'A'
0005CCFE  4032                                bra     loc_5CD32:8
0005CD00  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005CD06  4604                                bne     loc_5CD0C:8
0005CD08  fb63                     loc_5CD08  mov.b   #0x63, r3l ; 'c'
0005CD0A  4026                                bra     loc_5CD32:8
0005CD0C  5e023038                 loc_5CD0C  jsr     sub_23038:24
0005CD10  47f6                                beq     loc_5CD08:8
0005CD12  fb64                                mov.b   #0x64, r3l ; 'd'
0005CD14  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CD1A  68eb                                mov.b   r3l, @er6
0005CD1C  0b06                                adds    #1, er6
0005CD1E  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CD20  68ec                                mov.b   r4l, @er6
0005CD22  0b06                                adds    #1, er6
0005CD24  fc30                                mov.b   #0x30, r4l ; '0'
0005CD26  68ec                                mov.b   r4l, @er6
0005CD28  0b06                                adds    #1, er6
0005CD2A  5e0496a6                            jsr     sub_496A6:24
0005CD2E  4018                                bra     loc_5CD48:8
0005CD30  fb65                                mov.b   #0x65, r3l ; 'e'
0005CD32  7a0600ff0208             loc_5CD32  mov.l   #0xFF0208, er6
0005CD38  68eb                                mov.b   r3l, @er6
0005CD3A  0b06                                adds    #1, er6
0005CD3C  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CD3E  68ec                                mov.b   r4l, @er6
0005CD40  0b06                                adds    #1, er6
0005CD42  fc30                                mov.b   #0x30, r4l ; '0'
0005CD44  68ec                                mov.b   r4l, @er6
0005CD46  0b06                                adds    #1, er6
0005CD48  790c005d                 loc_5CD48  mov.w   #0x5D, e4 ; ']'
0005CD4C  fa5d                                mov.b   #0x5D, r2l ; ']'
0005CD4E  79040000                            mov.w   #0, r4
0005CD52  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005CD56  5470                                rts
0005CD58  fb63                                mov.b   #0x63, r3l ; 'c'
0005CD5A  40d6                                bra     loc_5CD32:8
0005CD5C  fb6c                                mov.b   #0x6C, r3l ; 'l'
0005CD5E  40d2                                bra     loc_5CD32:8
0005CD60  fb72                                mov.b   #0x72, r3l ; 'r'
0005CD62  40ce                                bra     loc_5CD32:8
0005CD64  fb43                                mov.b   #0x43, r3l ; 'C'
0005CD66  40ca                                bra     loc_5CD32:8
0005CD68  fb4c                                mov.b   #0x4C, r3l ; 'L'
0005CD6A  40c6                                bra     loc_5CD32:8
0005CD6C  fb71                                mov.b   #0x71, r3l ; 'q'
0005CD6E  40c2                                bra     loc_5CD32:8
0005CD70  fb23                                mov.b   #0x23, r3l ; '#'
0005CD72  40be                                bra     loc_5CD32:8
0005CD74  fb2a                                mov.b   #0x2A, r3l ; '*'
0005CD76  40ba                                bra     loc_5CD32:8
0005CD78  fb66                                mov.b   #0x66, r3l ; 'f'
0005CD7A  40b6                                bra     loc_5CD32:8
0005CD7C  fb67                                mov.b   #0x67, r3l ; 'g'
0005CD7E  5800009a                            bra     loc_5CE1C:16
0005CD82  fb30                                mov.b   #0x30, r3l ; '0'
0005CD84  40ac                                bra     loc_5CD32:8
0005CD86  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005CD8C  4604                                bne     loc_5CD92:8
0005CD8E  fb63                     loc_5CD8E  mov.b   #0x63, r3l ; 'c'
0005CD90  40a0                                bra     loc_5CD32:8
0005CD92  5e023038                 loc_5CD92  jsr     sub_23038:24
0005CD96  47f6                                beq     loc_5CD8E:8
0005CD98  fb64                                mov.b   #0x64, r3l ; 'd'
0005CD9A  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CDA0  68eb                                mov.b   r3l, @er6
0005CDA2  0b06                                adds    #1, er6
0005CDA4  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CDA6  68ec                                mov.b   r4l, @er6
0005CDA8  0b06                                adds    #1, er6
0005CDAA  fc30                                mov.b   #0x30, r4l ; '0'
0005CDAC  68ec                                mov.b   r4l, @er6
0005CDAE  0b06                                adds    #1, er6
0005CDB0  5e0496a6                            jsr     sub_496A6:24
0005CDB4  4092                                bra     loc_5CD48:8
0005CDB6  fb6a                                mov.b   #0x6A, r3l ; 'j'
0005CDB8  5800ff76                            bra     loc_5CD32:16
0005CDBC  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005CDC2  4604                                bne     loc_5CDC8:8
0005CDC4  fb65                     loc_5CDC4  mov.b   #0x65, r3l ; 'e'
0005CDC6  4054                                bra     loc_5CE1C:8
0005CDC8  5e023038                 loc_5CDC8  jsr     sub_23038:24
0005CDCC  47f6                                beq     loc_5CDC4:8
0005CDCE  fb66                                mov.b   #0x66, r3l ; 'f'
0005CDD0  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CDD6  68eb                                mov.b   r3l, @er6
0005CDD8  0b06                                adds    #1, er6
0005CDDA  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CDDC  68ec                                mov.b   r4l, @er6
0005CDDE  0b06                                adds    #1, er6
0005CDE0  fc30                                mov.b   #0x30, r4l ; '0'
0005CDE2  68ec                                mov.b   r4l, @er6
0005CDE4  0b06                                adds    #1, er6
0005CDE6  5e0496a6                            jsr     sub_496A6:24
0005CDEA  4046                                bra     loc_5CE32:8
0005CDEC  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005CDF2  4604                                bne     loc_5CDF8:8
0005CDF4  fb67                     loc_5CDF4  mov.b   #0x67, r3l ; 'g'
0005CDF6  4024                                bra     loc_5CE1C:8
0005CDF8  5e023038                 loc_5CDF8  jsr     sub_23038:24
0005CDFC  47f6                                beq     loc_5CDF4:8
0005CDFE  fb68                                mov.b   #0x68, r3l ; 'h'
0005CE00  7a0600ff0208                        mov.l   #0xFF0208, er6
0005CE06  68eb                                mov.b   r3l, @er6
0005CE08  0b06                                adds    #1, er6
0005CE0A  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CE0C  68ec                                mov.b   r4l, @er6
0005CE0E  0b06                                adds    #1, er6
0005CE10  fc30                                mov.b   #0x30, r4l ; '0'
0005CE12  68ec                                mov.b   r4l, @er6
0005CE14  0b06                                adds    #1, er6
0005CE16  5e0496a6                            jsr     sub_496A6:24
0005CE1A  4016                                bra     loc_5CE32:8
0005CE1C  7a0600ff0208             loc_5CE1C  mov.l   #0xFF0208, er6
0005CE22  68eb                                mov.b   r3l, @er6
0005CE24  0b06                                adds    #1, er6
0005CE26  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CE28  68ec                                mov.b   r4l, @er6
0005CE2A  0b06                                adds    #1, er6
0005CE2C  fc30                                mov.b   #0x30, r4l ; '0'
0005CE2E  68ec                                mov.b   r4l, @er6
0005CE30  0b06                                adds    #1, er6
0005CE32  790c00fd                 loc_5CE32  mov.w   #0xFD, e4
0005CE36  fafd                                mov.b   #0xFD, r2l
0005CE38  79040000                            mov.w   #0, r4
0005CE3C  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005CE40  5470                                rts
0005CE42  fb72                                mov.b   #0x72, r3l ; 'r'
0005CE44  4008                                bra     loc_5CE4E:8
0005CE46  fb52                                mov.b   #0x52, r3l ; 'R'
0005CE48  4004                                bra     loc_5CE4E:8
0005CE4A  fb73                                mov.b   #0x73, r3l ; 's'
0005CE4C  4000                                bra     loc_5CE4E:8
0005CE4E  7a0600ff0208             loc_5CE4E  mov.l   #0xFF0208, er6
0005CE54  68eb                                mov.b   r3l, @er6
0005CE56  0b06                                adds    #1, er6
0005CE58  fc5f                                mov.b   #0x5F, r4l ; '_'
0005CE5A  68ec                                mov.b   r4l, @er6
0005CE5C  0b06                                adds    #1, er6
0005CE5E  fc30                                mov.b   #0x30, r4l ; '0'
0005CE60  68ec                                mov.b   r4l, @er6
0005CE62  0b06                                adds    #1, er6
0005CE64  790c0201                            mov.w   #0x201, e4
0005CE68  79020201                            mov.w   #0x201, r2
0005CE6C  79040000                            mov.w   #0, r4
0005CE70  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005CE74  5470                                rts
0005CE76  79040005                 sub_5CE76  mov.w   #5, r4  ; <<< FUNC sub_5CE76
0005CE7A  7a0500ff0c38                        mov.l   #0xFF0C38, er5
0005CE80  7a0600ff0206                        mov.l   #0xFF0206, er6
0005CE86  7bd4598f                 loc_5CE86  eepmov.w
0005CE8A  0d44                                mov.w   r4, r4
0005CE8C  46f8                                bne     loc_5CE86:8
0005CE8E  79040000                            mov.w   #0, r4
0005CE92  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005CE96  5470                                rts
0005CE98  00                                  .byte    0
0005CE99  05cb                                xorc    #0xCB, ccr
0005CE9B  1c00                                cmp.b   r0h, r0h
0005CE9D  05cb                                xorc    #0xCB, ccr
0005CE9F  1c00                                cmp.b   r0h, r0h
0005CEA1  05cb                                xorc    #0xCB, ccr
0005CEA3  6a0005cb                            mov.b   @byte_5CB:16, r0h
0005CEA7  f000                                mov.b   #0, r0h
0005CEA9  05cb                                xorc    #0xCB, ccr
0005CEAB  6a0005cb                            mov.b   @byte_5CB:16, r0h
0005CEAF  f000                                mov.b   #0, r0h
0005CEB1  05cc                                xorc    #0xCC, ccr
0005CEB3  8200                                add.b   #0, r2h
0005CEB5  05cc                                xorc    #0xCC, ccr
0005CEB7  8200                                add.b   #0, r2h
0005CEB9  05cc                                xorc    #0xCC, ccr
0005CEBB  fc00                                mov.b   #0, r4l
0005CEBD  05cd                                xorc    #0xCD, ccr
0005CEBF  0000                                nop
0005CEC1  05cc                                xorc    #0xCC, ccr
0005CEC3  da00                                xor.b   #0, r2l
0005CEC5  05cd                                xorc    #0xCD, ccr
0005CEC7  3000                                mov.b   r0h, @0xFFFFFF00:8
0005CEC9  05cc                                xorc    #0xCC, ccr
0005CECB  f800                                mov.b   #0, r0l
0005CECD  05cd                                xorc    #0xCD, ccr
0005CECF  580005cd                            bra     loc_5D49C+4:16
0005CED3  5c0005cd                            bsr     sub_5D4A4:16
0005CED7  6000                                bset    r0h, r0h
0005CED9  05cd                                xorc    #0xCD, ccr
0005CEDB  6400                                or.w    r0, r0
0005CEDD  05cd                                xorc    #0xCD, ccr
0005CEDF  6800                                mov.b   @er0, r0h
0005CEE1  05cd                                xorc    #0xCD, ccr
0005CEE3  6c00                                mov.b   @er0+, r0h
0005CEE5  05cd                                xorc    #0xCD, ccr
0005CEE7  7000                                bset    #0, r0h
0005CEE9  05cd                                xorc    #0xCD, ccr
0005CEEB  78                                  .byte 0x78 ; x
0005CEEC  00                                  .byte    0
0005CEED  05cd                                xorc    #0xCD, ccr
0005CEEF  7c                                  .byte 0x7C ; |
0005CEF0  00                                  .byte    0
0005CEF1  05cd                                xorc    #0xCD, ccr
0005CEF3  8600                                add.b   #0, r6h
0005CEF5  05cd                                xorc    #0xCD, ccr
0005CEF7  bc00                                subx    #0, r4l
0005CEF9  05cd                                xorc    #0xCD, ccr
0005CEFB  ec00                                and.b   #0, r4l
0005CEFD  05cd                                xorc    #0xCD, ccr
0005CEFF  8200                                add.b   #0, r2h
0005CF01  05ce                                xorc    #0xCE, ccr
0005CF03  4200                     loc_5CF03  bhi     loc_5CF03+1:8
0005CF05  05ce                                xorc    #0xCE, ccr
0005CF07  4600                     loc_5CF07  bne     loc_5CF07+1:8
0005CF09  05ce                                xorc    #0xCE, ccr
0005CF0B  4a00                     loc_5CF0B  bpl     loc_5CF0B+1:8
0005CF0D  05cd                                xorc    #0xCD, ccr
0005CF0F  7400                                bor     #0, r0h
0005CF11  05cd                                xorc    #0xCD, ccr
0005CF13  b600                                subx    #0, r6h
0005CF15  05cd                                xorc    #0xCD, ccr
0005CF17  b600                                subx    #0, r6h
0005CF19  05ce                                xorc    #0xCE, ccr
0005CF1B  9601                     loc_5CF1B  addx    #1, r6h
0005CF1D  00                                  .byte    0
0005CF1E  6df6                                push.w  r6
0005CF20  4022                                bra     loc_5CF44:8
0005CF22  01006df6                            push.l  er6
0005CF26  6a0bb0b9                            mov.b   @0xFFFFB0B9:16, r3l
0005CF2A  7a63000000ff                        and.l   #0xFF, er3
0005CF30  1073                                shll.l  #2, er3
0005CF32  78                                  .byte 0x78 ; x
0005CF33  b06b                                subx    #0x6B, r0h ; 'k'
0005CF35  2600                                mov.b   @0xFFFFFF00:8, r6h
0005CF37  05d0                                xorc    #0xD0, ccr
0005CF39  2859                                mov.b   @0xFFFFFF59:8, r0l
0005CF3B  606a                                bset    r6h, r2l
0005CF3D  108d                                shal.b  r5l
0005CF3F  8273                                add.b   #0x73, r2h ; 's'
0005CF41  00                                  .byte    0
0005CF42  4632                                bne     loc_5CF76:8
0005CF44  792a00fe                 loc_5CF44  cmp.w   #0xFE, e2
0005CF48  4524                                bcs     loc_5CF6E:8
0005CF4A  792a0201                            cmp.w   #0x201, e2
0005CF4E  4516                                bcs     loc_5CF66:8
0005CF50  792a0304                            cmp.w   #0x304, e2
0005CF54  4508                                bcs     loc_5CF5E:8
0005CF56  f903                                mov.b   #3, r1l
0005CF58  79020406                            mov.w   #0x406, r2
0005CF5C  4048                                bra     loc_5CFA6:8
0005CF5E  f902                     loc_5CF5E  mov.b   #2, r1l
0005CF60  79020303                            mov.w   #0x303, r2
0005CF64  4040                                bra     loc_5CFA6:8
0005CF66  f901                     loc_5CF66  mov.b   #1, r1l
0005CF68  79020200                            mov.w   #0x200, r2
0005CF6C  4038                                bra     loc_5CFA6:8
0005CF6E  f900                     loc_5CF6E  mov.b   #0, r1l
0005CF70  790200fd                            mov.w   #0xFD, r2
0005CF74  4030                                bra     loc_5CFA6:8
0005CF76  792a00ec                 loc_5CF76  cmp.w   #0xEC, e2
0005CF7A  4524                                bcs     loc_5CFA0:8
0005CF7C  792a01ef                            cmp.w   #0x1EF, e2
0005CF80  4516                                bcs     loc_5CF98:8
0005CF82  792a02f2                            cmp.w   #0x2F2, e2
0005CF86  4508                                bcs     loc_5CF90:8
0005CF88  f903                                mov.b   #3, r1l
0005CF8A  790203f4                            mov.w   #0x3F4, r2
0005CF8E  4016                                bra     loc_5CFA6:8
0005CF90  f902                     loc_5CF90  mov.b   #2, r1l
0005CF92  790202f1                            mov.w   #0x2F1, r2
0005CF96  400e                                bra     loc_5CFA6:8
0005CF98  f901                     loc_5CF98  mov.b   #1, r1l
0005CF9A  790201ee                            mov.w   #0x1EE, r2
0005CF9E  4006                                bra     loc_5CFA6:8
0005CFA0  f900                     loc_5CFA0  mov.b   #0, r1l
0005CFA2  790200eb                            mov.w   #0xEB, r2
0005CFA6  f100                     loc_5CFA6  mov.b   #0, r1h
0005CFA8  6b81b124                            mov.w   r1, @0xFFFFB124:16
0005CFAC  01006d76                            pop.l   er6
0005CFB0  5470                                rts
0005CFB2  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005CFB8  4632                                bne     loc_5CFEC:8
0005CFBA  792a00f9                            cmp.w   #0xF9, e2
0005CFBE  4524                                bcs     loc_5CFE4:8
0005CFC0  792a01fc                            cmp.w   #0x1FC, e2
0005CFC4  4516                                bcs     loc_5CFDC:8
0005CFC6  792a02ff                            cmp.w   #0x2FF, e2
0005CFCA  4508                                bcs     loc_5CFD4:8
0005CFCC  f903                                mov.b   #3, r1l
0005CFCE  79020401                            mov.w   #0x401, r2
0005CFD2  4048                                bra     loc_5D01C:8
0005CFD4  f902                     loc_5CFD4  mov.b   #2, r1l
0005CFD6  790202fe                            mov.w   #0x2FE, r2
0005CFDA  4040                                bra     loc_5D01C:8
0005CFDC  f901                     loc_5CFDC  mov.b   #1, r1l
0005CFDE  790201fb                            mov.w   #0x1FB, r2
0005CFE2  4038                                bra     loc_5D01C:8
0005CFE4  f900                     loc_5CFE4  mov.b   #0, r1l
0005CFE6  790200f8                            mov.w   #0xF8, r2
0005CFEA  4030                                bra     loc_5D01C:8
0005CFEC  792a00e7                 loc_5CFEC  cmp.w   #0xE7, e2
0005CFF0  4524                                bcs     loc_5D016:8
0005CFF2  792a01ea                            cmp.w   #0x1EA, e2
0005CFF6  4516                                bcs     loc_5D00E:8
0005CFF8  792a02ed                            cmp.w   #0x2ED, e2
0005CFFC  4508                                bcs     loc_5D006:8
0005CFFE  f903                     loc_5CFFE  mov.b   #3, r1l
0005D000  790203ef                            mov.w   #0x3EF, r2
0005D004  4016                                bra     loc_5D01C:8
0005D006  f902                     loc_5D006  mov.b   #2, r1l
0005D008  790202ec                            mov.w   #0x2EC, r2
0005D00C  400e                                bra     loc_5D01C:8
0005D00E  f901                     loc_5D00E  mov.b   #1, r1l
0005D010  790201e9                            mov.w   #0x1E9, r2
0005D014  4006                                bra     loc_5D01C:8
0005D016  f900                     loc_5D016  mov.b   #0, r1l
0005D018  790200e6                            mov.w   #0xE6, r2
0005D01C  f100                     loc_5D01C  mov.b   #0, r1h
0005D01E  6b81b124                            mov.w   r1, @0xFFFFB124:16
0005D022  01006d76                            pop.l   er6
0005D026  5470                                rts
0005D028  00                                  .byte    0
0005D029  05cf                                xorc    #0xCF, ccr
0005D02B  3c00                                mov.b   r4l, @0xFFFFFF00:8
0005D02D  05cf                                xorc    #0xCF, ccr
0005D02F  ac00                                cmp.b   #0, r4l
0005D031  05cf                                xorc    #0xCF, ccr
0005D033  b200                                subx    #0, r2h
0005D035  05cf                                xorc    #0xCF, ccr
0005D037  ac00                                cmp.b   #0, r4l
0005D039  05cf                                xorc    #0xCF, ccr
0005D03B  b200                                subx    #0, r2h
0005D03D  05cf                                xorc    #0xCF, ccr
0005D03F  ac00                                cmp.b   #0, r4l
0005D041  05cf                                xorc    #0xCF, ccr
0005D043  ac00                                cmp.b   #0, r4l
0005D045  05cf                                xorc    #0xCF, ccr
0005D047  ac00                                cmp.b   #0, r4l
0005D049  05cf                                xorc    #0xCF, ccr
0005D04B  ac00                                cmp.b   #0, r4l
0005D04D  05cf                                xorc    #0xCF, ccr
0005D04F  ac00                                cmp.b   #0, r4l
0005D051  05cf                                xorc    #0xCF, ccr
0005D053  ac00                                cmp.b   #0, r4l
0005D055  05cf                                xorc    #0xCF, ccr
0005D057  ac00                                cmp.b   #0, r4l
0005D059  05cf                                xorc    #0xCF, ccr
0005D05B  ac00                                cmp.b   #0, r4l
0005D05D  05cf                                xorc    #0xCF, ccr
0005D05F  ac00                                cmp.b   #0, r4l
0005D061  05cf                                xorc    #0xCF, ccr
0005D063  ac00                                cmp.b   #0, r4l
0005D065  05cf                                xorc    #0xCF, ccr
0005D067  ac00                                cmp.b   #0, r4l
0005D069  05cf                                xorc    #0xCF, ccr
0005D06B  ac00                                cmp.b   #0, r4l
0005D06D  05cf                                xorc    #0xCF, ccr
0005D06F  ac00                                cmp.b   #0, r4l
0005D071  05cf                                xorc    #0xCF, ccr
0005D073  ac00                                cmp.b   #0, r4l
0005D075  05cf                                xorc    #0xCF, ccr
0005D077  ac00                                cmp.b   #0, r4l
0005D079  05cf                                xorc    #0xCF, ccr
0005D07B  ac00                                cmp.b   #0, r4l
0005D07D  05cf                                xorc    #0xCF, ccr
0005D07F  ac00                                cmp.b   #0, r4l
0005D081  05cf                                xorc    #0xCF, ccr
0005D083  ac00                                cmp.b   #0, r4l
0005D085  05cf                                xorc    #0xCF, ccr
0005D087  ac00                                cmp.b   #0, r4l
0005D089  05cf                                xorc    #0xCF, ccr
0005D08B  ac00                                cmp.b   #0, r4l
0005D08D  05cf                                xorc    #0xCF, ccr
0005D08F  ac00                                cmp.b   #0, r4l
0005D091  05cf                                xorc    #0xCF, ccr
0005D093  ac00                                cmp.b   #0, r4l
0005D095  05cf                                xorc    #0xCF, ccr
0005D097  ac00                                cmp.b   #0, r4l
0005D099  05cf                                xorc    #0xCF, ccr
0005D09B  ac00                                cmp.b   #0, r4l
0005D09D  05cf                                xorc    #0xCF, ccr
0005D09F  ac00                                cmp.b   #0, r4l
0005D0A1  05cf                                xorc    #0xCF, ccr
0005D0A3  ac00                                cmp.b   #0, r4l
0005D0A5  05cf                                xorc    #0xCF, ccr
0005D0A7  ac00                                cmp.b   #0, r4l
0005D0A9  05cf                                xorc    #0xCF, ccr
0005D0AB  ac79                     loc_5D0AB  cmp.b   #0x79, r4l ; 'y'
0005D0AD  0903                                add.w   r0, r3
0005D0AF  0a                                  .byte  0xA
0005D0B0  7901040e                            mov.w   #0x40E, r1
0005D0B4  790b0512                            mov.w   #0x512, e3
0005D0B8  4006                                bra     loc_5D0C0:8
0005D0BA  fc00                     loc_5D0BA  mov.b   #0, r4l
0005D0BC  68ec                                mov.b   r4l, @er6
0005D0BE  0b06                                adds    #1, er6
0005D0C0  1d96                     loc_5D0C0  cmp.w   e1, r6
0005D0C2  47f6                                beq     loc_5D0BA:8
0005D0C4  1d16                                cmp.w   r1, r6
0005D0C6  47f2                                beq     loc_5D0BA:8
0005D0C8  1db6                                cmp.w   e3, r6
0005D0CA  47ee                                beq     loc_5D0BA:8
0005D0CC  6c5c                                mov.b   @er5+, r4l
0005D0CE  acff                                cmp.b   #0xFF, r4l
0005D0D0  471e                                beq     loc_5D0F0:8
0005D0D2  68ec                                mov.b   r4l, @er6
0005D0D4  0b06                                adds    #1, er6
0005D0D6  1b5a                                dec.w   #1, e2
0005D0D8  4704                                beq     loc_5D0DE:8
0005D0DA  1b52                                dec.w   #1, r2
0005D0DC  46e2                                bne     loc_5D0C0:8
0005D0DE  1d96                     loc_5D0DE  cmp.w   e1, r6
0005D0E0  4708                                beq     loc_5D0EA:8
0005D0E2  1d16                                cmp.w   r1, r6
0005D0E4  4704                                beq     loc_5D0EA:8
0005D0E6  1db6                                cmp.w   e3, r6
0005D0E8  4606                                bne     loc_5D0F0:8
0005D0EA  fc00                     loc_5D0EA  mov.b   #0, r4l
0005D0EC  68ec                                mov.b   r4l, @er6
0005D0EE  0b06                                adds    #1, er6
0005D0F0  fc03                     loc_5D0F0  mov.b   #3, r4l
0005D0F2  68ec                                mov.b   r4l, @er6
0005D0F4  0b06                                adds    #1, er6
0005D0F6  1d96                                cmp.w   e1, r6
0005D0F8  4708                                beq     loc_5D102:8
0005D0FA  1d16                                cmp.w   r1, r6
0005D0FC  4704                                beq     loc_5D102:8
0005D0FE  1db6                                cmp.w   e3, r6
0005D100  4606                                bne     loc_5D108:8
0005D102  fc00                     loc_5D102  mov.b   #0, r4l
0005D104  68ec                                mov.b   r4l, @er6
0005D106  0b06                                adds    #1, er6
0005D108  fb00                     loc_5D108  mov.b   #0, r3l
0005D10A  7a0500ff0206                        mov.l   #0xFF0206, er5
0005D110  1fe5                     loc_5D110  cmp.l   er6, er5
0005D112  4406                                bcc     loc_5D11A:8
0005D114  6c5c                                mov.b   @er5+, r4l
0005D116  08cb                                add.b   r4l, r3l
0005D118  40f6                                bra     loc_5D110:8
0005D11A  68eb                     loc_5D11A  mov.b   r3l, @er6
0005D11C  0b06                                adds    #1, er6
0005D11E  7a3600ff0206                        sub.l   #0xFF0206, er6
0005D124  fc01                                mov.b   #1, r4l
0005D126  4704                                beq     loc_5D12C:8
0005D128  6b86b126                            mov.w   r6, @0xFFFFB126:16
0005D12C  79260105                 loc_5D12C  cmp.w   #0x105, r6
0005D130  440c                                bcc     loc_5D13E:8
0005D132  fc14                                mov.b   #0x14, r4l
0005D134  51c6                                divxu.b r4l, r6
0005D136  0c66                                mov.b   r6h, r6h
0005D138  4706                                beq     loc_5D140:8
0005D13A  0a0e                                inc.b   r6l
0005D13C  4002                                bra     loc_5D140:8
0005D13E  fe0d                     loc_5D13E  mov.b   #0xD, r6l
0005D140  fc00                     loc_5D140  mov.b   #0, r4l
0005D142  730e                                btst    #0, r6l
0005D144  4610                                bne     loc_5D156:8
0005D146  0a0e                                inc.b   r6l
0005D148  ae03                                cmp.b   #3, r6l
0005D14A  470a                                beq     loc_5D156:8
0005D14C  ae07                                cmp.b   #7, r6l
0005D14E  4706                                beq     loc_5D156:8
0005D150  ae0b                                cmp.b   #0xB, r6l
0005D152  4702                                beq     loc_5D156:8
0005D154  fc01                                mov.b   #1, r4l
0005D156  6a8cb106                 loc_5D156  mov.b   r4l, @0xFFFFB106:16
0005D15A  6a8eb123                            mov.b   r6l, @0xFFFFB123:16
0005D15E  fc00                                mov.b   #0, r4l
0005D160  6a8cb122                            mov.b   r4l, @0xFFFFB122:16
0005D164  7a0400ff0206                        mov.l   #0xFF0206, er4
0005D16A  01006b84b128                        mov.l   er4, @0xFFFFB128:16
0005D170  5470                                rts
0005D172  7909030a                 sub_5D172  mov.w   #0x30A, e1  ; <<< FUNC sub_5D172
0005D176  7901040e                            mov.w   #0x40E, r1
0005D17A  790b0512                            mov.w   #0x512, e3
0005D17E  4006                                bra     loc_5D186:8
0005D180  fc00                     loc_5D180  mov.b   #0, r4l
0005D182  68ec                                mov.b   r4l, @er6
0005D184  0b06                                adds    #1, er6
0005D186  1d96                     loc_5D186  cmp.w   e1, r6
0005D188  47f6                                beq     loc_5D180:8
0005D18A  1d16                                cmp.w   r1, r6
0005D18C  47f2                                beq     loc_5D180:8
0005D18E  1db6                                cmp.w   e3, r6
0005D190  47ee                                beq     loc_5D180:8
0005D192  6c5c                                mov.b   @er5+, r4l
0005D194  68ec                                mov.b   r4l, @er6
0005D196  0b06                                adds    #1, er6
0005D198  1b5a                                dec.w   #1, e2
0005D19A  4704                                beq     loc_5D1A0:8
0005D19C  1b52                                dec.w   #1, r2
0005D19E  46e6                                bne     loc_5D186:8
0005D1A0  1d96                     loc_5D1A0  cmp.w   e1, r6
0005D1A2  4708                                beq     loc_5D1AC:8
0005D1A4  1d16                                cmp.w   r1, r6
0005D1A6  4704                                beq     loc_5D1AC:8
0005D1A8  1db6                                cmp.w   e3, r6
0005D1AA  4606                                bne     loc_5D1B2:8
0005D1AC  fc00                     loc_5D1AC  mov.b   #0, r4l
0005D1AE  68ec                                mov.b   r4l, @er6
0005D1B0  0b06                                adds    #1, er6
0005D1B2  fc03                     loc_5D1B2  mov.b   #3, r4l
0005D1B4  68ec                                mov.b   r4l, @er6
0005D1B6  0b06                                adds    #1, er6
0005D1B8  1d96                                cmp.w   e1, r6
0005D1BA  4708                                beq     loc_5D1C4:8
0005D1BC  1d16                                cmp.w   r1, r6
0005D1BE  4704                                beq     loc_5D1C4:8
0005D1C0  1db6                                cmp.w   e3, r6
0005D1C2  4606                                bne     loc_5D1CA:8
0005D1C4  fc00                     loc_5D1C4  mov.b   #0, r4l
0005D1C6  68ec                                mov.b   r4l, @er6
0005D1C8  0b06                                adds    #1, er6
0005D1CA  fb00                     loc_5D1CA  mov.b   #0, r3l
0005D1CC  7a0500ff0206                        mov.l   #0xFF0206, er5
0005D1D2  1fe5                     loc_5D1D2  cmp.l   er6, er5
0005D1D4  4406                                bcc     loc_5D1DC:8
0005D1D6  6c5c                                mov.b   @er5+, r4l
0005D1D8  08cb                                add.b   r4l, r3l
0005D1DA  40f6                                bra     loc_5D1D2:8
0005D1DC  68eb                     loc_5D1DC  mov.b   r3l, @er6
0005D1DE  0b06                                adds    #1, er6
0005D1E0  7a3600ff0206                        sub.l   #0xFF0206, er6
0005D1E6  fc01                                mov.b   #1, r4l
0005D1E8  4704                                beq     loc_5D1EE:8
0005D1EA  6b86b126                            mov.w   r6, @0xFFFFB126:16
0005D1EE  79260105                 loc_5D1EE  cmp.w   #0x105, r6
0005D1F2  440c                                bcc     loc_5D200:8
0005D1F4  fc14                                mov.b   #0x14, r4l
0005D1F6  51c6                                divxu.b r4l, r6
0005D1F8  0c66                                mov.b   r6h, r6h
0005D1FA  4706                                beq     loc_5D202:8
0005D1FC  0a0e                                inc.b   r6l
0005D1FE  4002                                bra     loc_5D202:8
0005D200  fe0d                     loc_5D200  mov.b   #0xD, r6l
0005D202  fc00                     loc_5D202  mov.b   #0, r4l
0005D204  730e                                btst    #0, r6l
0005D206  4610                                bne     loc_5D218:8
0005D208  0a0e                                inc.b   r6l
0005D20A  ae03                                cmp.b   #3, r6l
0005D20C  470a                                beq     loc_5D218:8
0005D20E  ae07                                cmp.b   #7, r6l
0005D210  4706                                beq     loc_5D218:8
0005D212  ae0b                                cmp.b   #0xB, r6l
0005D214  4702                                beq     loc_5D218:8
0005D216  fc01                                mov.b   #1, r4l
0005D218  6a8cb106                 loc_5D218  mov.b   r4l, @0xFFFFB106:16
0005D21C  6a8eb123                            mov.b   r6l, @0xFFFFB123:16
0005D220  fc00                                mov.b   #0, r4l
0005D222  6a8cb122                            mov.b   r4l, @0xFFFFB122:16
0005D226  7a0400ff0206                        mov.l   #0xFF0206, er4
0005D22C  01006b84b128                        mov.l   er4, @0xFFFFB128:16
0005D232  5470                                rts
0005D234  6a0cb124                 sub_5D234  mov.b   @0xFFFFB124:16, r4l  ; <<< FUNC sub_5D234
0005D238  0a0c                                inc.b   r4l
0005D23A  6a8cb124                            mov.b   r4l, @0xFFFFB124:16
0005D23E  6b06b126                            mov.w   @0xFFFFB126:16, r6
0005D242  79260105                            cmp.w   #0x105, r6
0005D246  440c                                bcc     loc_5D254:8
0005D248  fc14                                mov.b   #0x14, r4l
0005D24A  51c6                                divxu.b r4l, r6
0005D24C  0c66                                mov.b   r6h, r6h
0005D24E  4706                                beq     loc_5D256:8
0005D250  0a0e                                inc.b   r6l
0005D252  4002                                bra     loc_5D256:8
0005D254  fe0d                     loc_5D254  mov.b   #0xD, r6l
0005D256  fc00                     loc_5D256  mov.b   #0, r4l
0005D258  730e                                btst    #0, r6l
0005D25A  4610                                bne     loc_5D26C:8
0005D25C  0a0e                                inc.b   r6l
0005D25E  ae03                                cmp.b   #3, r6l
0005D260  470a                                beq     loc_5D26C:8
0005D262  ae07                                cmp.b   #7, r6l
0005D264  4706                                beq     loc_5D26C:8
0005D266  ae0b                                cmp.b   #0xB, r6l
0005D268  4702                                beq     loc_5D26C:8
0005D26A  fc01                                mov.b   #1, r4l
0005D26C  6a8cb106                 loc_5D26C  mov.b   r4l, @0xFFFFB106:16
0005D270  6a8eb123                            mov.b   r6l, @0xFFFFB123:16
0005D274  fc00                                mov.b   #0, r4l
0005D276  6a8cb122                            mov.b   r4l, @0xFFFFB122:16
0005D27A  5470                                rts
0005D27C  56                                  .byte 0x56 ; V
0005D27D  6f696365                            mov.w   @(0x6365:16,er6), e1
0005D281  2644                                mov.b   @0xFFFFFF44:8, r6h
0005D283  6174                                bnot    r7h, r4h
0005D285  6120                                bnot    r2h, r0h
0005D287  4354                                bls     loc_5D2DB+1:8
0005D289  3d31                                mov.b   r5l, @0xFFFFFF31:8
0005D28B  ff56                                mov.b   #0x56, r7l ; 'V'
0005D28D  6f696365                            mov.w   @(0x6365:16,er6), e1
0005D291  2644                                mov.b   @0xFFFFFF44:8, r6h
0005D293  6174                                bnot    r7h, r4h
0005D295  6120                                bnot    r2h, r0h
0005D297  4354                                bls     loc_5D2E9+3:8
0005D299  3d35                                mov.b   r5l, @0xFFFFFF35:8
0005D29B  2041                                mov.b   @0xFFFFFF41:8, r0h
0005D29D  4243                                bhi     loc_5D2E1+1:8
0005D29F  4445                                bcc     unk_5D2E6:8
0005D2A1  4647                                bne     loc_5D2E9+1:8
0005D2A3  4849                                bvc     loc_5D2ED+1:8
0005D2A5  4a4b                                bpl     unk_5D2F2:8
0005D2A7  4c4d                                bge     loc_5D2F5+1:8
0005D2A9  4e4f                                bgt     loc_5D2FA:8
0005D2AB  5051                                mulxu.b r5h, r1
0005D2AD  5253                                mulxu.w r5, er3
0005D2AF  54                                  .byte 0x54 ; T
0005D2B0  5556                                bsr     sub_5D308:8
0005D2B2  57                                  .byte 0x57 ; W
0005D2B3  58                                  .byte 0x58 ; X
0005D2B4  59                                  .byte 0x59 ; Y
0005D2B5  5a616263                            jmp     0x616263:24
0005D2B9  6465                                or.w    r6, r5
0005D2BB  6667                                and.w   r6, r7
0005D2BD  6869                                mov.b   @er6, r1l
0005D2BF  6a                                  .byte 0x6A ; j
0005D2C0  6b                                  .byte 0x6B ; k
0005D2C1  6c6d                                mov.b   @er6+, r5l
0005D2C3  6e6f7071                            mov.b   @(0x7071:16,er6), r7l
0005D2C7  7273                                bclr    #7, r3h
0005D2C9  7475                                bor     #7, r5h
0005D2CB  7677                                band    #7, r7h
0005D2CD  78                                  .byte 0x78 ; x
0005D2CE  79                                  .byte 0x79 ; y
0005D2CF  7a4142434445                        or.l    #0x42434445, er1
0005D2D5  4647                                bne     loc_5D31E:8
0005D2D7  4849                                bvc     loc_5D31E+4:8
0005D2D9  4a4b                                bpl     loc_5D326:8
0005D2DB  4c4d                     loc_5D2DB  bge     loc_5D326+4:8
0005D2DD  4e4f                                bgt     loc_5D32E:8
0005D2DF  5051                                mulxu.b r5h, r1
0005D2E1  5253                     loc_5D2E1  mulxu.w r5, er3
0005D2E3  54                                  .byte 0x54 ; T
0005D2E4  5556                                bsr     sub_5D33C:8
0005D2E6  57                       unk_5D2E6  .byte 0x57 ; W
0005D2E7  58                                  .byte 0x58 ; X
0005D2E8  59                                  .byte 0x59 ; Y
0005D2E9  5a616263                 loc_5D2E9  jmp     0x616263:24
0005D2ED  6465                     loc_5D2ED  or.w    r6, r5
0005D2EF  66ff                                and.w   e7, e7
0005D2F1  00                                  .byte    0
0005D2F2  59                       unk_5D2F2  .byte 0x59 ; Y
0005D2F3  4145                                brn     loc_5D33A:8
0005D2F5  5355                     loc_5D2F5  divxu.w r5, er5
0005D2F7  2020                                mov.b   @0xFFFFFF20:8, r0h
0005D2F9  59                                  .byte 0x59 ; Y
0005D2FA  4145                     loc_5D2FA  brn     loc_5D340:8
0005D2FC  5355                                divxu.w r5, er5
0005D2FE  ff00                                mov.b   #0, r7l
0005D300  4578                                bcs     loc_5D37A:8
0005D302  7465                                bor     #6, r5h
0005D304  6e642056                            mov.b   @(0x2056:16,er6), r4h
0005D308  6f696365                 sub_5D308  mov.w   @(0x6365:16,er6), e1  ; <<< FUNC sub_5D308
0005D30C  3132                                mov.b   r1h, @0xFFFFFF32:8
0005D30E  3334                                mov.b   r3h, @0xFFFFFF34:8
0005D310  3536                                mov.b   r5h, @0xFFFFFF36:8
0005D312  3738                                mov.b   r7h, @0xFFFFFF38:8
0005D314  ff00                                mov.b   #0, r7l
0005D316  6a0cb2a5                 sub_5D316  mov.b   @0xFFFFB2A5:16, r4l  ; <<< FUNC sub_5D316
0005D31A  ac02                                cmp.b   #2, r4l
0005D31C  462e                                bne     loc_5D34C:8
0005D31E  6a10b26b7300             loc_5D31E  btst    #0, @0xFFFFB26B:16
0005D324  4626                                bne     loc_5D34C:8
0005D326  7a0500fef94e             loc_5D326  mov.l   #0xFEF94E, er5
0005D32C  fb05                                mov.b   #5, r3l
0005D32E  7a0600ffb2aa             loc_5D32E  mov.l   #0xFFB2AA, er6
0005D334  6c6c                     loc_5D334  mov.b   @er6+, r4l
0005D336  6c54                                mov.b   @er5+, r4h
0005D338  a4ff                                cmp.b   #0xFF, r4h
0005D33A  4602                     loc_5D33A  bne     loc_5D33E:8
0005D33C  f420                     sub_5D33C  mov.b   #0x20, r4h ; ' '  ; <<< FUNC sub_5D33C
0005D33E  1c4c                     loc_5D33E  cmp.b   r4h, r4l


; ==== perm126_reader  00068240-00068400 ====
00068240  5470                     locret_68240 rts
00068242  6a0cb40d                 sub_68242  mov.b   @0xFFFFB40D:16, r4l  ; <<< FUNC sub_68242
00068246  472c                                beq     locret_68274:8
00068248  6a0c955a                            mov.b   @0xFFFF955A:16, r4l
0006824C  4626                                bne     locret_68274:8
0006824E  6a0c9559                            mov.b   @0xFFFF9559:16, r4l
00068252  4620                                bne     locret_68274:8
00068254  5e067f18                            jsr     sub_67F18:24
00068258  471a                                beq     locret_68274:8
0006825A  fc00                                mov.b   #0, r4l
0006825C  6a8cb40d                            mov.b   r4l, @0xFFFFB40D:16
00068260  6a1089c47340                        btst    #4, @0xFFFF89C4:16
00068266  470c                                beq     locret_68274:8
00068268  6a0cfba5                            mov.b   @0xFFFFFBA5:16, r4l
0006826C  ecf0                                and.b   #0xF0, r4l
0006826E  703c                                bset    #3, r4l
00068270  6a8cfba5                            mov.b   r4l, @0xFFFFFBA5:16
00068274  5470                     locret_68274 rts
00068276  7a0500ff8060             sub_68276  mov.l   #0xFF8060, er5  ; <<< FUNC sub_68276
0006827C  6a0cb416                            mov.b   @0xFFFFB416:16, r4l
00068280  471c                                beq     loc_6829E:8
00068282  ac01                                cmp.b   #1, r4l
00068284  4712                                beq     loc_68298:8
00068286  ac02                                cmp.b   #2, r4l
00068288  4708                                beq     loc_68292:8
0006828A  fc00                                mov.b   #0, r4l
0006828C  6a8cb416                            mov.b   r4l, @0xFFFFB416:16
00068290  400c                                bra     loc_6829E:8
00068292  6e5c0002                 loc_68292  mov.b   @(2:16,er5), r4l
00068296  400a                                bra     loc_682A2:8
00068298  6e5c0003                 loc_68298  mov.b   @(3:16,er5), r4l
0006829C  4004                                bra     loc_682A2:8
0006829E  6e5c0004                 loc_6829E  mov.b   @(4:16,er5), r4l
000682A2  ac30                     loc_682A2  cmp.b   #0x30, r4l ; '0'
000682A4  4514                                bcs     loc_682BA:8
000682A6  ac3a                                cmp.b   #0x3A, r4l ; ':'
000682A8  4512                                bcs     loc_682BC:8
000682AA  ac41                                cmp.b   #0x41, r4l ; 'A'
000682AC  450c                                bcs     loc_682BA:8
000682AE  ac5b                                cmp.b   #0x5B, r4l ; '['
000682B0  4510                                bcs     loc_682C2:8
000682B2  ac61                                cmp.b   #0x61, r4l ; 'a'
000682B4  4504                                bcs     loc_682BA:8
000682B6  ac7b                                cmp.b   #0x7B, r4l ; '{'
000682B8  4510                                bcs     loc_682CA:8
000682BA  fc30                     loc_682BA  mov.b   #0x30, r4l ; '0'
000682BC  f430                     loc_682BC  mov.b   #0x30, r4h ; '0'
000682BE  184c                                sub.b   r4h, r4l
000682C0  400e                                bra     loc_682D0:8
000682C2  f441                     loc_682C2  mov.b   #0x41, r4h ; 'A'
000682C4  184c                                sub.b   r4h, r4l
000682C6  8c0a                                add.b   #0xA, r4l
000682C8  4006                                bra     loc_682D0:8
000682CA  f461                     loc_682CA  mov.b   #0x61, r4h ; 'a'
000682CC  184c                                sub.b   r4h, r4l
000682CE  8c24                                add.b   #0x24, r4l ; '$'
000682D0  6a04b47e                 loc_682D0  mov.b   @0xFFFFB47E:16, r4h
000682D4  084c                                add.b   r4h, r4l
000682D6  7a64000000ff                        and.l   #0xFF, er4
000682DC  78406a2b0005df52                    mov.b   @((loc_5DF51+1):32,er4), r3l
000682E4  fc24                                mov.b   #0x24, r4l ; '$'
000682E6  50c3                                mulxu.b r4l, r3
000682E8  791300fa                            add.w   #0xFA, r3
000682EC  790b0000                            mov.w   #0, e3
000682F0  0fb4                                mov.l   er3, er4
000682F2  470e                                beq     locret_68302:8
000682F4  7905000a                            mov.w   #0xA, r5
000682F8  5353                                divxu.w r5, er3
000682FA  792b0005                            cmp.w   #5, e3
000682FE  4502                                bcs     locret_68302:8
00068300  0b53                                inc.w   #1, r3
00068302  5470                     locret_68302 rts
00068304  ac65                     sub_68304  cmp.b   #0x65, r4l ; 'e'  ; <<< FUNC sub_68304
00068306  58700190                            beq     loc_6849A:16
0006830A  ac66                                cmp.b   #0x66, r4l ; 'f'
0006830C  5870015c                            beq     loc_6846C:16
00068310  ac30                                cmp.b   #0x30, r4l ; '0'
00068312  58700aaa                            beq     sub_68DC0:16
00068316  5470                                rts
00068318  ac67                     sub_68318  cmp.b   #0x67, r4l ; 'g'  ; <<< FUNC sub_68318
0006831A  4708                                beq     loc_68324:8
0006831C  7a0500000017                        mov.l   #0x17, er5
00068322  4006                                bra     loc_6832A:8
00068324  7a0500000005             loc_68324  mov.l   #5, er5
0006832A  fc2d                     loc_6832A  mov.b   #0x2D, r4l ; '-'
0006832C  7a1500ff07e8                        add.l   #0xFF07E8, er5
00068332  7a0600ffb44e                        mov.l   #0xFFB44E, er6
00068338  f400                                mov.b   #0, r4h
0006833A  7bd4598f                 loc_6833A  eepmov.w
0006833E  0d44                                mov.w   r4, r4
00068340  46f8                                bne     loc_6833A:8
00068342  6a2400ff07eb                        mov.b   @0xFF07EB:32, r4h
00068348  6a2c00ff07ec                        mov.b   @0xFF07EC:32, r4l
0006834E  6b84b43a                            mov.w   r4, @0xFFFFB43A:16
00068352  7a0200ffb44e                        mov.l   #0xFFB44E, er2
00068358  5e04b724                            jsr     sub_4B724:24
0006835C  6ba300ff2f4c                        mov.w   r3, @0xFF2F4C:32
00068362  fc05                                mov.b   #5, r4l
00068364  f400                                mov.b   #0, r4h
00068366  7a0500ff07e3                        mov.l   #0xFF07E3, er5
0006836C  7a0600ff2f63                        mov.l   #0xFF2F63, er6
00068372  7bd4598f                 loc_68372  eepmov.w
00068376  0d44                                mov.w   r4, r4
00068378  46f8                                bne     loc_68372:8
0006837A  fc0a                                mov.b   #0xA, r4l
0006837C  f400                                mov.b   #0, r4h
0006837E  7a0500ff07b6                        mov.l   #0xFF07B6, er5
00068384  7a0600ff2f68                        mov.l   #0xFF2F68, er6
0006838A  7bd4598f                 loc_6838A  eepmov.w
0006838E  0d44                                mov.w   r4, r4
00068390  46f8                                bne     loc_6838A:8
00068392  fb0a                                mov.b   #0xA, r3l
00068394  7a0500059b44                        mov.l   #loc_59B44, er5
0006839A  7a0600ffb471                        mov.l   #0xFFB471, er6
000683A0  6c54                     loc_683A0  mov.b   @er5+, r4h
000683A2  6c6c                                mov.b   @er6+, r4l
000683A4  1c4c                                cmp.b   r4h, r4l
000683A6  4604                                bne     loc_683AC:8
000683A8  1a0b                                dec.b   r3l
000683AA  46f4                                bne     loc_683A0:8
000683AC  58700086                 loc_683AC  beq     loc_68436:16
000683B0  fb05                                mov.b   #5, r3l
000683B2  7a0500ff8060                        mov.l   #0xFF8060, er5
000683B8  7a0600ffb46c                        mov.l   #0xFFB46C, er6
000683BE  6c54                     loc_683BE  mov.b   @er5+, r4h
000683C0  6c6c                                mov.b   @er6+, r4l
000683C2  1c4c                                cmp.b   r4h, r4l
000683C4  4604                                bne     loc_683CA:8
000683C6  1a0b                                dec.b   r3l
000683C8  46f4                                bne     loc_683BE:8
000683CA  465e                     loc_683CA  bne     loc_6842A:8
000683CC  fb0a                                mov.b   #0xA, r3l
000683CE  7a0500ffa8da                        mov.l   #0xFFA8DA, er5
000683D4  7a0600ffb471                        mov.l   #0xFFB471, er6
000683DA  6c54                     loc_683DA  mov.b   @er5+, r4h
000683DC  6c6c                                mov.b   @er6+, r4l
000683DE  1c4c                                cmp.b   r4h, r4l
000683E0  4604                                bne     loc_683E6:8
000683E2  1a0b                                dec.b   r3l
000683E4  46f4                                bne     loc_683DA:8
000683E6  4642                     loc_683E6  bne     loc_6842A:8
000683E8  fc05                                mov.b   #5, r4l
000683EA  f400                                mov.b   #0, r4h
000683EC  7a0500ffb44e                        mov.l   #0xFFB44E, er5
000683F2  7a0600ffb424                        mov.l   #0xFFB424, er6
000683F8  7bd4598f                 loc_683F8  eepmov.w
000683FC  0d44                                mov.w   r4, r4
000683FE  46f8                                bne     loc_683F8:8


; ==== ctcss_band_fn  00034740-00034C40 ====
00034740  6a18b0bb7210                        bclr    #1, @0xFFFFB0BB:16
00034746  5e039080                            jsr     loc_3907F+1:24
0003474A  fc00                                mov.b   #0, r4l
0003474C  6a8ca9a8                            mov.b   r4l, @0xFFFFA9A8:16
00034750  6a8caada                            mov.b   r4l, @0xFFFFAADA:16
00034754  6a8c9551                            mov.b   r4l, @0xFFFF9551:16
00034758  6a8c8f64                            mov.b   r4l, @0xFFFF8F64:16
0003475C  6a8c906c                            mov.b   r4l, @0xFFFF906C:16
00034760  6a8c9174                            mov.b   r4l, @0xFFFF9174:16
00034764  fc00                                mov.b   #0, r4l
00034766  6a8c8f73                            mov.b   r4l, @0xFFFF8F73:16
0003476A  6a8c907b                            mov.b   r4l, @0xFFFF907B:16
0003476E  fcff                                mov.b   #0xFF, r4l
00034770  6a8caad8                            mov.b   r4l, @0xFFFFAAD8:16
00034774  fc00                                mov.b   #0, r4l
00034776  6a8caad9                            mov.b   r4l, @0xFFFFAAD9:16
0003477A  fc00                                mov.b   #0, r4l
0003477C  6a8c955c                            mov.b   r4l, @0xFFFF955C:16
00034780  5470                                rts
00034782  fc00                     sub_34782  mov.b   #0, r4l  ; <<< FUNC sub_34782
00034784  6a8cbb95                            mov.b   r4l, @0xFFFFBB95:16
00034788  01006b05aaaa                        mov.l   @0xFFFFAAAA:16, er5
0003478E  7a0600ff92ce                        mov.l   #0xFF92CE, er6
00034794  5e03f5ee                            jsr     sub_3F5EE:24
00034798  4424                                bcc     loc_347BE:8
0003479A  01006b05aaaa                        mov.l   @0xFFFFAAAA:16, er5
000347A0  7a0600ff92d6                        mov.l   #0xFF92D6, er6
000347A6  5e03f5ee                            jsr     sub_3F5EE:24
000347AA  4562                                bcs     loc_3480E:8
000347AC  6a1881767200                        bclr    #0, @0xFFFF8176:16
000347B2  5e037a3a                            jsr     sub_37A3A:24
000347B6  7a0600035140                        mov.l   #(loc_3513F+1), er6
000347BC  4010                                bra     loc_347CE:8
000347BE  6a1881767000             loc_347BE  bset    #0, @0xFFFF8176:16
000347C4  5e037a3a                            jsr     sub_37A3A:24
000347C8  7a060003510a                        mov.l   #(loc_35109+1), er6
000347CE  01006b05aaaa             loc_347CE  mov.l   @0xFFFFAAAA:16, er5
000347D4  5e03f5b2                            jsr     sub_3F5B2:24
000347D8  6a8baad0                            mov.b   r3l, @0xFFFFAAD0:16
000347DC  6a0c8dde                            mov.b   @0xFFFF8DDE:16, r4l
000347E0  4a10                                bpl     loc_347F2:8
000347E2  6a108de07370                        btst    #7, @0xFFFF8DE0:16
000347E8  462c                                bne     loc_34816:8
000347EA  6a10b3d97320                        btst    #2, @0xFFFFB3D9:16
000347F0  4624                                bne     loc_34816:8
000347F2  5544                     loc_347F2  bsr     sub_34838:8
000347F4  5576                                bsr     sub_3486C:8
000347F6  fc04                                mov.b   #4, r4l
000347F8  6a8c9568                            mov.b   r4l, @0xFFFF9568:16
000347FC  6e0c008f                            mov.b   @(0x8F:16,er0), r4l
00034800  723c                                bclr    #3, r4l
00034802  6e8c008f                            mov.b   r4l, @(0x8F:16,er0)
00034806  fc01                                mov.b   #1, r4l
00034808  6a8caad5                            mov.b   r4l, @0xFFFFAAD5:16
0003480C  4006                                bra     locret_34814:8
0003480E  fc03                     loc_3480E  mov.b   #3, r4l
00034810  6a8caad5                            mov.b   r4l, @0xFFFFAAD5:16
00034814  5470                     locret_34814 rts
00034816  6a18fba57060             loc_34816  bset    #6, @0xFFFFFBA5:16
0003481C  5e035e3c                            jsr     sub_35E3C:24
00034820  fc04                                mov.b   #4, r4l
00034822  6a8c9568                            mov.b   r4l, @0xFFFF9568:16
00034826  6e0c008f                            mov.b   @(0x8F:16,er0), r4l
0003482A  723c                                bclr    #3, r4l
0003482C  6e8c008f                            mov.b   r4l, @(0x8F:16,er0)
00034830  fc01                                mov.b   #1, r4l
00034832  6a8caad5                            mov.b   r4l, @0xFFFFAAD5:16
00034836  5470                                rts
00034838  6e040012                 sub_34838  mov.b   @(0x12:16,er0), r4h  ; <<< FUNC sub_34838
0003483C  fb00                                mov.b   #0, r3l
0003483E  6e0c0046                            mov.b   @(0x46:16,er0), r4l
00034842  730c                                btst    #0, r4l
00034844  4606                                bne     loc_3484C:8
00034846  7324                                btst    #2, r4h
00034848  4710                                beq     loc_3485A:8
0003484A  400c                                bra     loc_34858:8
0003484C  e403                     loc_3484C  and.b   #3, r4h
0003484E  470a                                beq     loc_3485A:8
00034850  a401                                cmp.b   #1, r4h
00034852  4704                                beq     loc_34858:8
00034854  fb04                                mov.b   #4, r3l
00034856  4002                                bra     loc_3485A:8
00034858  fb01                     loc_34858  mov.b   #1, r3l
0003485A  6e8b008d                 loc_3485A  mov.b   r3l, @(0x8D:16,er0)
0003485E  fc02                                mov.b   #2, r4l
00034860  6a8c956d                            mov.b   r4l, @0xFFFF956D:16
00034864  fc02                                mov.b   #2, r4l
00034866  6e8c0094                            mov.b   r4l, @(0x94:16,er0)
0003486A  5470                                rts
0003486C  7f527050                 sub_3486C  bset    #5, @0xFFFFFF52:8  ; <<< FUNC sub_3486C
00034870  7f527070                            bset    #7, @0xFFFFFF52:8
00034874  7e5b7330                            btst    #3, @0xFFFFFF5B:8
00034878  4712                                beq     loc_3488C:8
0003487A  fc01                                mov.b   #1, r4l
0003487C  6e8c0095                            mov.b   r4l, @(0x95:16,er0)
00034880  7f5b7230                            bclr    #3, @0xFFFFFF5B:8
00034884  7f5d7010                            bset    #1, @0xFFFFFF5D:8
00034888  5e0341b4                            jsr     sub_341B4:24
0003488C  7f5b7020                 loc_3488C  bset    #2, @0xFFFFFF5B:8
00034890  7f5d7200                            bclr    #0, @0xFFFFFF5D:8
00034894  6a10aad37320                        btst    #2, @0xFFFFAAD3:16
0003489A  4644                                bne     loc_348E0:8
0003489C  6a10aad37300                        btst    #0, @0xFFFFAAD3:16
000348A2  463c                                bne     loc_348E0:8
000348A4  6a108ea07360                        btst    #6, @0xFFFF8EA0:16
000348AA  4706                                beq     loc_348B2:8
000348AC  6a0c8dd5                            mov.b   @0xFFFF8DD5:16, r4l
000348B0  4004                                bra     loc_348B6:8
000348B2  6a0c8d20                 loc_348B2  mov.b   @0xFFFF8D20:16, r4l
000348B6  4720                     loc_348B6  beq     loc_348D8:8
000348B8  ac01                                cmp.b   #1, r4l
000348BA  4716                                beq     loc_348D2:8
000348BC  6a108ea07360                        btst    #6, @0xFFFF8EA0:16
000348C2  4706                                beq     loc_348CA:8
000348C4  6a0c8ec5                            mov.b   @0xFFFF8EC5:16, r4l
000348C8  4004                                bra     loc_348CE:8
000348CA  6a0c8eb6                 loc_348CA  mov.b   @0xFFFF8EB6:16, r4l
000348CE  ac04                     loc_348CE  cmp.b   #4, r4l
000348D0  4404                                bcc     loc_348D6:8
000348D2  fc01                     loc_348D2  mov.b   #1, r4l
000348D4  4002                                bra     loc_348D8:8
000348D6  fc00                     loc_348D6  mov.b   #0, r4l
000348D8  4606                     loc_348D8  bne     loc_348E0:8
000348DA  5e03446c                            jsr     sub_3446C:24
000348DE  4036                                bra     loc_34916:8
000348E0  7e597340                 loc_348E0  btst    #4, @0xFFFFFF59:8
000348E4  4730                                beq     loc_34916:8
000348E6  5e034458                            jsr     sub_34458:24
000348EA  402a                                bra     loc_34916:8
000348EC  7e5b7330                            btst    #3, @0xFFFFFF5B:8
000348F0  4712                                beq     loc_34904:8
000348F2  fc01                                mov.b   #1, r4l
000348F4  6e8c0095                            mov.b   r4l, @(0x95:16,er0)
000348F8  7f5b7230                            bclr    #3, @0xFFFFFF5B:8
000348FC  7f5d7010                            bset    #1, @0xFFFFFF5D:8
00034900  5e0341b4                            jsr     sub_341B4:24
00034904  7f5b7220                 loc_34904  bclr    #2, @0xFFFFFF5B:8
00034908  7f5d7000                            bset    #0, @0xFFFFFF5D:8
0003490C  fc01                                mov.b   #1, r4l
0003490E  6a8c9074                            mov.b   r4l, @0xFFFF9074:16
00034912  5e0342ec                            jsr     sub_342EC:24
00034916  6a0caad0                 loc_34916  mov.b   @0xFFFFAAD0:16, r4l
0003491A  7a64000000ff                        and.l   #0xFF, er4
00034920  78406a2b00034956                    mov.b   @(loc_34956:32,er4), r3l
00034928  6a038174                            mov.b   @0xFFFF8174:16, r3h
0003492C  e301                                and.b   #1, r3h
0003492E  14b3                                or.b    r3l, r3h
00034930  6a838172                            mov.b   r3h, @0xFFFF8172:16
00034934  78406a2b0003495e                    mov.b   @(loc_3495E:32,er4), r3l
0003493C  6a038175                            mov.b   @0xFFFF8175:16, r3h
00034940  e377                                and.b   #0x77, r3h
00034942  14b3                                or.b    r3l, r3h
00034944  6a838173                            mov.b   r3h, @0xFFFF8173:16
00034948  6a1881737230                        bclr    #3, @0xFFFF8173:16
0003494E  4000                                bra     loc_34950:8
00034950  5e037a1e                 loc_34950  jsr     sub_37A1E:24
00034954  5470                                rts
00034956  0202                     loc_34956  stc.b   ccr, r2h
00034958  0404                                orc     #4, ccr
0003495A  0408                                orc     #8, ccr
0003495C  0800                                add.b   r0h, r0h
0003495E  0000                     loc_3495E  nop
00034960  0000                                nop
00034962  0000                                nop
00034964  0000                                nop
00034966  6a0c8dde                            mov.b   @0xFFFF8DDE:16, r4l
0003496A  4a10                                bpl     loc_3497C:8
0003496C  6a108de07370                        btst    #7, @0xFFFF8DE0:16
00034972  4618                                bne     loc_3498C:8
00034974  6a10b3d97320                        btst    #2, @0xFFFFB3D9:16
0003497A  4610                                bne     loc_3498C:8
0003497C  6a0c956d                 loc_3497C  mov.b   @0xFFFF956D:16, r4l
00034980  586000f6                            bne     locret_34A7A:16
00034984  7e4d7330                            btst    #3, @0xFFFFFF4D:8
00034988  586000e4                            bne     loc_34A70:16
0003498C  6a10aad37320             loc_3498C  btst    #2, @0xFFFFAAD3:16
00034992  466c                                bne     loc_34A00:8
00034994  6a10aad37300                        btst    #0, @0xFFFFAAD3:16
0003499A  4664                                bne     loc_34A00:8
0003499C  6a108ea07360                        btst    #6, @0xFFFF8EA0:16
000349A2  4706                                beq     loc_349AA:8
000349A4  6a0c8dd5                            mov.b   @0xFFFF8DD5:16, r4l
000349A8  4004                                bra     loc_349AE:8
000349AA  6a0c8d20                 loc_349AA  mov.b   @0xFFFF8D20:16, r4l
000349AE  4720                     loc_349AE  beq     loc_349D0:8
000349B0  ac01                                cmp.b   #1, r4l
000349B2  4716                                beq     loc_349CA:8
000349B4  6a108ea07360                        btst    #6, @0xFFFF8EA0:16
000349BA  4706                                beq     loc_349C2:8
000349BC  6a0c8ec5                            mov.b   @0xFFFF8EC5:16, r4l
000349C0  4004                                bra     loc_349C6:8
000349C2  6a0c8eb6                 loc_349C2  mov.b   @0xFFFF8EB6:16, r4l
000349C6  ac04                     loc_349C6  cmp.b   #4, r4l
000349C8  4404                                bcc     loc_349CE:8
000349CA  fc01                     loc_349CA  mov.b   #1, r4l
000349CC  4002                                bra     loc_349D0:8
000349CE  fc00                     loc_349CE  mov.b   #0, r4l
000349D0  58600096                 loc_349D0  bne     loc_34A6A:16
000349D4  6a0c89bb                            mov.b   @0xFFFF89BB:16, r4l
000349D8  4726                                beq     loc_34A00:8
000349DA  fc03                                mov.b   #3, r4l
000349DC  6a8cbb95                            mov.b   r4l, @0xFFFFBB95:16
000349E0  6a18b0bb7000                        bset    #0, @0xFFFFB0BB:16
000349E6  fc01                                mov.b   #1, r4l
000349E8  6a8cbb94                            mov.b   r4l, @0xFFFFBB94:16
000349EC  fc00                                mov.b   #0, r4l
000349EE  6a8cb0ac                            mov.b   r4l, @0xFFFFB0AC:16
000349F2  fc00                                mov.b   #0, r4l
000349F4  6a8cb0bd                            mov.b   r4l, @0xFFFFB0BD:16
000349F8  6a8cb0be                            mov.b   r4l, @0xFFFFB0BE:16
000349FC  6a8cb0bf                            mov.b   r4l, @0xFFFFB0BF:16
00034A00  5e034a7c                 loc_34A00  jsr     sub_34A7C:24
00034A04  5e034b30                            jsr     sub_34B30:24
00034A08  6a18aa307020                        bset    #2, @0xFFFFAA30:16
00034A0E  6a18aad17270                        bclr    #7, @0xFFFFAAD1:16
00034A14  5e034b44                            jsr     sub_34B44:24
00034A18  fc02                                mov.b   #2, r4l
00034A1A  6a8caad5                            mov.b   r4l, @0xFFFFAAD5:16
00034A1E  6a10aad37320                        btst    #2, @0xFFFFAAD3:16
00034A24  463c                                bne     loc_34A62:8
00034A26  6a10aad37300                        btst    #0, @0xFFFFAAD3:16
00034A2C  462c                                bne     loc_34A5A:8
00034A2E  6a10aad17320                        btst    #2, @0xFFFFAAD1:16
00034A34  4616                                bne     loc_34A4C:8
00034A36  6a10aa367330                        btst    #3, @0xFFFFAA36:16
00034A3C  4606                                bne     loc_34A44:8
00034A3E  5e034c34                            jsr     sub_34C34:24
00034A42  4036                                bra     locret_34A7A:8
00034A44  fc1f                     loc_34A44  mov.b   #0x1F, r4l
00034A46  6a8caae0                            mov.b   r4l, @0xFFFFAAE0:16
00034A4A  402e                                bra     locret_34A7A:8
00034A4C  6a18aad17220             loc_34A4C  bclr    #2, @0xFFFFAAD1:16
00034A52  6a18aa307040             sub_34A52  bset    #4, @0xFFFFAA30:16  ; <<< FUNC sub_34A52
00034A58  4020                                bra     locret_34A7A:8
00034A5A  6a18a4f07060             loc_34A5A  bset    #6, @0xFFFFA4F0:16
00034A60  4018                                bra     locret_34A7A:8
00034A62  6a18a4f07070             loc_34A62  bset    #7, @0xFFFFA4F0:16
00034A68  4010                                bra     locret_34A7A:8
00034A6A  5e035872                 loc_34A6A  jsr     loc_35871+1:24
00034A6E  400a                                bra     locret_34A7A:8
00034A70  6a0c9568                 loc_34A70  mov.b   @0xFFFF9568:16, r4l
00034A74  4604                                bne     locret_34A7A:8
00034A76  5e034ff4                            jsr     sub_34FF4:24
00034A7A  5470                     locret_34A7A rts
00034A7C  6a0c8dde                 sub_34A7C  mov.b   @0xFFFF8DDE:16, r4l  ; <<< FUNC sub_34A7C
00034A80  4a10                                bpl     loc_34A92:8
00034A82  6a108de07370                        btst    #7, @0xFFFF8DE0:16
00034A88  4638                                bne     locret_34AC2:8
00034A8A  6a10b3d97320                        btst    #2, @0xFFFFB3D9:16
00034A90  4630                                bne     locret_34AC2:8
00034A92  6a18aad27230             loc_34A92  bclr    #3, @0xFFFFAAD2:16
00034A98  6e0c0001                            mov.b   @(1:16,er0), r4l
00034A9C  ace1                                cmp.b   #0xE1, r4l
00034A9E  4518                                bcs     loc_34AB8:8
00034AA0  ace8                                cmp.b   #0xE8, r4l
00034AA2  4414                                bcc     loc_34AB8:8
00034AA4  6a0d97f8                            mov.b   @0xFFFF97F8:16, r5l
00034AA8  7a65000000ff                        and.l   #0xFF, er5
00034AAE  78506a2a0002317a                    mov.b   @(0x2317A:32,er5), r2l
00034AB6  4006                                bra     loc_34ABE:8
00034AB8  5e034ad2                 loc_34AB8  jsr     sub_34AD2:24
00034ABC  4000                                bra     loc_34ABE:8
00034ABE  5e034b06                 loc_34ABE  jsr     sub_34B06:24
00034AC2  5470                     locret_34AC2 rts
00034AC4  6a18aad27260                        bclr    #6, @0xFFFFAAD2:16
00034ACA  fa01                                mov.b   #1, r2l
00034ACC  5470                                rts
00034ACE  0000                                nop
00034AD0  01                                  .byte    1
00034AD1  01                                  .byte    1
00034AD2  6e0a0013                 sub_34AD2  mov.b   @(0x13:16,er0), r2l  ; <<< FUNC sub_34AD2
00034AD6  6a0ca9be                            mov.b   @0xFFFFA9BE:16, r4l
00034ADA  ac02                                cmp.b   #2, r4l
00034ADC  4710                                beq     loc_34AEE:8
00034ADE  ac01                                cmp.b   #1, r4l
00034AE0  4700                                beq     loc_34AE2:8
00034AE2  6a10aad27360             loc_34AE2  btst    #6, @0xFFFFAAD2:16
00034AE8  4710                                beq     loc_34AFA:8
00034AEA  fa03                                mov.b   #3, r2l
00034AEC  400c                                bra     loc_34AFA:8
00034AEE  6a18aad27260             loc_34AEE  bclr    #6, @0xFFFFAAD2:16
00034AF4  aa02                                cmp.b   #2, r2l
00034AF6  4502                                bcs     loc_34AFA:8
00034AF8  fa01                                mov.b   #1, r2l
00034AFA  4008                     loc_34AFA  bra     locret_34B04:8
00034AFC  6a18aad27260                        bclr    #6, @0xFFFFAAD2:16
00034B02  fa01                                mov.b   #1, r2l
00034B04  5470                     locret_34B04 rts
00034B06  550c                     sub_34B06  bsr     sub_34B14:8  ; <<< FUNC sub_34B06
00034B08  6a18817e7010                        bset    #1, @0xFFFF817E:16
00034B0E  5e0351f4                            jsr     sub_351F4:24
00034B12  5470                                rts
00034B14  7a62000000ff             sub_34B14  and.l   #0xFF, er2  ; <<< FUNC sub_34B14
00034B1A  78206a2e00034b28                    mov.b   @(loc_34B28:32,er2), r6l
00034B22  6e8e0084                            mov.b   r6l, @(0x84:16,er0)
00034B26  5470                                rts
00034B28  0406                     loc_34B28  orc     #6, ccr
00034B2A  080a                                add.b   r0h, r2l
00034B2C  0404                                orc     #4, ccr
00034B2E  080a                                add.b   r0h, r2l
00034B30  6a108ea07360             sub_34B30  btst    #6, @0xFFFF8EA0:16  ; <<< FUNC sub_34B30
00034B36  4706                                beq     loc_34B3E:8
00034B38  5e03242e                            jsr     sub_3242E:24
00034B3C  4004                                bra     locret_34B42:8
00034B3E  5e030adc                 loc_34B3E  jsr     sub_30ADC:24
00034B42  5470                     locret_34B42 rts
00034B44  fc7f                     sub_34B44  mov.b   #0x7F, r4l  ; <<< FUNC sub_34B44
00034B46  3c69                                mov.b   r4l, @0xFFFFFF69:8
00034B48  6a108ea07360                        btst    #6, @0xFFFF8EA0:16
00034B4E  4710                                beq     loc_34B60:8
00034B50  6a0caad3                            mov.b   @0xFFFFAAD3:16, r4l
00034B54  ec0f                                and.b   #0xF, r4l
00034B56  4708                                beq     loc_34B60:8
00034B58  6a0c8aa0                            mov.b   @0xFFFF8AA0:16, r4l
00034B5C  ac02                                cmp.b   #2, r4l
00034B5E  4728                                beq     loc_34B88:8
00034B60  fc00                     loc_34B60  mov.b   #0, r4l
00034B62  6a8ca998                            mov.b   r4l, @0xFFFFA998:16
00034B66  6a8ca99c                            mov.b   r4l, @0xFFFFA99C:16
00034B6A  5e03ef6e                            jsr     sub_3EF6E:24
00034B6E  ac00                                cmp.b   #0, r4l
00034B70  4732                                beq     loc_34BA4:8
00034B72  ac03                                cmp.b   #3, r4l
00034B74  4704                                beq     loc_34B7A:8
00034B76  5552                                bsr     sub_34BCA:8
00034B78  402c                                bra     locret_34BA6:8
00034B7A  6a0caad1                 loc_34B7A  mov.b   @0xFFFFAAD1:16, r4l
00034B7E  ec30                                and.b   #0x30, r4l
00034B80  4624                                bne     locret_34BA6:8
00034B82  5e034c1a                            jsr     sub_34C1A:24
00034B86  401e                                bra     locret_34BA6:8
00034B88  fcff                     loc_34B88  mov.b   #0xFF, r4l
00034B8A  6a8ca998                            mov.b   r4l, @0xFFFFA998:16
00034B8E  fc00                                mov.b   #0, r4l
00034B90  6a8ca99c                            mov.b   r4l, @0xFFFFA99C:16
00034B94  6a0caad0                            mov.b   @0xFFFFAAD0:16, r4l
00034B98  ac05                                cmp.b   #5, r4l
00034B9A  4506                                bcs     loc_34BA2:8
00034B9C  fc96                                mov.b   #0x96, r4l
00034B9E  6a8ca998                            mov.b   r4l, @0xFFFFA998:16
00034BA2  5504                     loc_34BA2  bsr     sub_34BA8:8
00034BA4  5522                     loc_34BA4  bsr     nullsub_29:8
00034BA6  5470                     locret_34BA6 rts
00034BA8  790c8cdc                 sub_34BA8  mov.w   #0x8CDC, e4  ; <<< FUNC sub_34BA8
00034BAC  6a0caad0                            mov.b   @0xFFFFAAD0:16, r4l
00034BB0  ac00                                cmp.b   #0, r4l
00034BB2  470c                                beq     loc_34BC0:8
00034BB4  790c8cc8                            mov.w   #0x8CC8, e4
00034BB8  ac05                                cmp.b   #5, r4l
00034BBA  4504                                bcs     loc_34BC0:8
00034BBC  790ca082                            mov.w   #0xA082, e4
00034BC0  0dc4                     loc_34BC0  mov.w   e4, r4
00034BC2  6a84a998                            mov.b   r4h, @0xFFFFA998:16
00034BC6  5470                                rts
00034BC8  5470                     nullsub_29 rts  ; <<< FUNC nullsub_29
00034BCA  55fc                     sub_34BCA  bsr     nullsub_29:8  ; <<< FUNC sub_34BCA
00034BCC  5e0356c8                            jsr     loc_356C8:24
00034BD0  5e03ef6e                            jsr     sub_3EF6E:24
00034BD4  6e0b0017                            mov.b   @(0x17:16,er0), r3l
00034BD8  ac07                                cmp.b   #7, r4l
00034BDA  4616                                bne     loc_34BF2:8
00034BDC  fc32                                mov.b   #0x32, r4l ; '2'
00034BDE  6a8c9579                            mov.b   r4l, @0xFFFF9579:16
00034BE2  6a0b896a                            mov.b   @0xFFFF896A:16, r3l
00034BE6  6a10aad17370                        btst    #7, @0xFFFFAAD1:16
00034BEC  4704                                beq     loc_34BF2:8
00034BEE  6a0b896b                            mov.b   @0xFFFF896B:16, r3l
00034BF2  7a63000000ff             loc_34BF2  and.l   #0xFF, er3
00034BF8  1033                                shll.l  er3
00034BFA  78306b2400035158                    mov.w   @((loc_35157+1):32,er3), r4
00034C02  6b84aab4                            mov.w   r4, @0xFFFFAAB4:16
00034C06  79040000                            mov.w   #0, r4
00034C0A  6b84aab2                            mov.w   r4, @0xFFFFAAB2:16
00034C0E  6a18aad27070                        bset    #7, @0xFFFFAAD2:16
00034C14  5e0351d6                            jsr     sub_351D6:24
00034C18  5470                                rts
00034C1A  55ac                     sub_34C1A  bsr     nullsub_29:8  ; <<< FUNC sub_34C1A
00034C1C  5e0357e8                            jsr     loc_357E8:24
00034C20  5e02fbe2                            jsr     sub_2FBE2:24
00034C24  5e000450                            jsr     sub_450:24
00034C28  fc00                                mov.b   #0, r4l
00034C2A  6a8caacd                            mov.b   r4l, @0xFFFFAACD:16
00034C2E  5e02f55a                            jsr     sub_2F55A:24
00034C32  5470                                rts
00034C34  6a0c8dde                 sub_34C34  mov.b   @0xFFFF8DDE:16, r4l  ; <<< FUNC sub_34C34
00034C38  4a0c                                bpl     loc_34C46:8
00034C3A  fc00                                mov.b   #0, r4l
00034C3C  6a10b3d97700                        bld     #0, @0xFFFFB3D9:16


; ==== tone_dcs_ui_sub_D13E  0000D120-0000D300 ====
0000D120  68eb                                mov.b   r3l, @er6
0000D122  6d75                                pop.w   r5
0000D124  5470                                rts
0000D126  7a0600ff3de0             sub_D126   mov.l   #0xFF3DE0, er6  ; <<< FUNC sub_D126
0000D12C  fc0b                                mov.b   #0xB, r4l
0000D12E  68ec                                mov.b   r4l, @er6
0000D130  6e0c0001                            mov.b   @(1:16,er0), r4l
0000D134  acdc                                cmp.b   #0xDC, r4l
0000D136  461e                                bne     sub_D156:8
0000D138  6e0b0017                            mov.b   @(0x17:16,er0), r3l
0000D13C  4050                                bra     loc_D18D+1:8
0000D13E  7a0600ff3de0             sub_D13E   mov.l   #0xFF3DE0, er6  ; <<< FUNC sub_D13E
0000D144  fc0c                                mov.b   #0xC, r4l
0000D146  68ec                                mov.b   r4l, @er6
0000D148  6e0c0001                            mov.b   @(1:16,er0), r4l
0000D14C  acdc                                cmp.b   #0xDC, r4l
0000D14E  4606                                bne     sub_D156:8
0000D150  6e0b0018                            mov.b   @(0x18:16,er0), r3l
0000D154  407a                                bra     loc_D1D0:8
0000D156  6a0b97f9                 sub_D156   mov.b   @0xFFFF97F9:16, r3l  ; <<< FUNC sub_D156
0000D15A  7a050000d16c                        mov.l   #0xD16C, er5
0000D160  7a0600ff3de2                        mov.l   #0xFF3DE2, er6
0000D166  5e00c674                            jsr     sub_C674:24
0000D16A  5470                                rts
0000D16C  00                                  .byte    0
0000D16D  0844                                add.b   r4h, r4h
0000D16F  6174                                bnot    r7h, r4h
0000D171  6120                                bnot    r2h, r0h
0000D173  2020                                mov.b   @0xFFFFFF20:8, r0h
0000D175  2046                                mov.b   @0xFFFFFF46:8, r0h
0000D177  7265                                bclr    #6, r5h
0000D179  7120                                bnot    #2, r0h
0000D17B  2020                                mov.b   @0xFFFFFF20:8, r0h
0000D17D  2054                                mov.b   @0xFFFFFF54:8, r0h
0000D17F  4f4e                                ble     loc_D1CE:8
0000D181  452f                                bcs     loc_D1B0+2:8
0000D183  4443                                bcc     loc_D1C6+2:8
0000D185  5354                                divxu.w r5, er4
0000D187  4f4e                                ble     loc_D1D6:8
0000D189  4520                                bcs     loc_D1AA:8
0000D18B  5245                                mulxu.w r4, er5
0000D18D  467a                     loc_D18D   bne     loc_D208:8
0000D18F  0500                                xorc    #0, ccr
0000D191  00                                  .byte    0
0000D192  d22a                                xor.b   #0x2A, r2h
0000D194  6d54                                mov.w   @er5+, r4
0000D196  7a0600ff3de2                        mov.l   #0xFF3DE2, er6
0000D19C  7bd4598f                 loc_D19C   eepmov.w
0000D1A0  0d44                                mov.w   r4, r4
0000D1A2  46f8                                bne     loc_D19C:8
0000D1A4  7a0600ff3de2                        mov.l   #0xFF3DE2, er6
0000D1AA  7a050000585a             loc_D1AA   mov.l   #0x585A, er5
0000D1B0  7a63000000ff             loc_D1B0   and.l   #0xFF, er3
0000D1B6  1033                                shll.l  er3
0000D1B8  0ab5                                add.l   er3, er5
0000D1BA  685c                                mov.b   @er5, r4l
0000D1BC  ecf0                                and.b   #0xF0, r4l
0000D1BE  470a                                beq     loc_D1CA:8
0000D1C0  114c                                shlr.b  #2, r4l
0000D1C2  114c                                shlr.b  #2, r4l
0000D1C4  cc30                                or.b    #0x30, r4l
0000D1C6  6eec0000                 loc_D1C6   mov.b   r4l, @(0:16,er6)
0000D1CA  fa02                     loc_D1CA   mov.b   #2, r2l
0000D1CC  0b06                                adds    #1, er6
0000D1CE  4030                     loc_D1CE   bra     loc_D200:8
0000D1D0  7a050000d234             loc_D1D0   mov.l   #0xD234, er5
0000D1D6  6d54                     loc_D1D6   mov.w   @er5+, r4
0000D1D8  7a0600ff3de2                        mov.l   #0xFF3DE2, er6
0000D1DE  7bd4598f                 loc_D1DE   eepmov.w
0000D1E2  0d44                                mov.w   r4, r4
0000D1E4  46f8                                bne     loc_D1DE:8
0000D1E6  7a0600ff3de2                        mov.l   #0xFF3DE2, er6
0000D1EC  7a0500005072                        mov.l   #0x5072, er5
0000D1F2  7a63000000ff                        and.l   #0xFF, er3
0000D1F8  1033                                shll.l  er3
0000D1FA  0ab5                                add.l   er3, er5
0000D1FC  fa03                                mov.b   #3, r2l
0000D1FE  0b96                                adds    #4, er6
0000D200  6c5c                     loc_D200   mov.b   @er5+, r4l
0000D202  ec0f                                and.b   #0xF, r4l
0000D204  cc30                                or.b    #0x30, r4l
0000D206  68ec                                mov.b   r4l, @er6
0000D208  6854                     loc_D208   mov.b   @er5, r4h
0000D20A  0c4c                                mov.b   r4h, r4l
0000D20C  1144                                shlr.b  #2, r4h
0000D20E  1144                                shlr.b  #2, r4h
0000D210  c430                                or.b    #0x30, r4h
0000D212  6ee40001                            mov.b   r4h, @(1:16,er6)
0000D216  ec0f                                and.b   #0xF, r4l
0000D218  cc30                                or.b    #0x30, r4l
0000D21A  aa03                                cmp.b   #3, r2l
0000D21C  4706                                beq     loc_D224:8
0000D21E  6eec0003                            mov.b   r4l, @(3:16,er6)
0000D222  4004                                bra     locret_D228:8
0000D224  6eec0002                 loc_D224   mov.b   r4l, @(2:16,er6)
0000D228  5470                     locret_D228 rts
0000D22A  00                                  .byte    0
0000D22B  0720                                ldc.b   #0x20, ccr ; ' '
0000D22D  2020                                mov.b   @0xFFFFFF20:8, r0h
0000D22F  2e20                                mov.b   @0xFFFFFF20:8, r6l
0000D231  487a                                bvc     loc_D2AC:8
0000D233  0000                                nop
0000D235  0744                                ldc.b   #0x44, ccr ; 'D'
0000D237  4353                                bls     locret_D28C:8
0000D239  2020                                mov.b   @0xFFFFFF20:8, r0h
0000D23B  2020                                mov.b   @0xFFFFFF20:8, r0h
0000D23D  00                                  .byte    0
0000D23E  f500                     sub_D23E   mov.b   #0, r5h  ; <<< FUNC sub_D23E
0000D240  79250064                 sub_D240   cmp.w   #0x64, r5 ; 'd'  ; <<< FUNC sub_D240
0000D244  4414                                bcc     loc_D25A:8
0000D246  fc20                                mov.b   #0x20, r4l ; ' '
0000D248  6eec0000                            mov.b   r4l, @(0:16,er6)
0000D24C  ad0a                     sub_D24C   cmp.b   #0xA, r5l  ; <<< FUNC sub_D24C
0000D24E  441c                                bcc     loc_D26C:8
0000D250  fc20                                mov.b   #0x20, r4l ; ' '
0000D252  6eec0001                            mov.b   r4l, @(1:16,er6)
0000D256  0cd5                                mov.b   r5l, r5h
0000D258  401c                                bra     loc_D276:8
0000D25A  fc64                     loc_D25A   mov.b   #0x64, r4l ; 'd'
0000D25C  51c5                                divxu.b r4l, r5
0000D25E  ad0a                                cmp.b   #0xA, r5l
0000D260  4502                                bcs     loc_D264:8
0000D262  fd00                                mov.b   #0, r5l
0000D264  cd30                     loc_D264   or.b    #0x30, r5l
0000D266  68ed                                mov.b   r5l, @er6
0000D268  0c5d                                mov.b   r5h, r5l
0000D26A  f500                                mov.b   #0, r5h
0000D26C  fc0a                     loc_D26C   mov.b   #0xA, r4l
0000D26E  51c5                                divxu.b r4l, r5
0000D270  cd30                                or.b    #0x30, r5l
0000D272  6eed0001                            mov.b   r5l, @(1:16,er6)
0000D276  c530                     loc_D276   or.b    #0x30, r5h
0000D278  6ee50002                            mov.b   r5h, @(2:16,er6)
0000D27C  5470                                rts
0000D27E  6a0b8ddc                            mov.b   @0xFFFF8DDC:16, r3l
0000D282  710b                                bnot    #0, r3l
0000D284  790bf32a                            mov.w   #0xF32A, e3
0000D288  5e00976a                            jsr     sub_976A:24
0000D28C  5470                     locret_D28C rts
0000D28E  79040028                            mov.w   #0x28, r4 ; '('
0000D292  6ba400ff3d72                        mov.w   r4, @0xFF3D72:32
0000D298  7904f3c4                            mov.w   #0xF3C4, r4
0000D29C  6ba400ff3d74                        mov.w   r4, @0xFF3D74:32
0000D2A2  7904001e                            mov.w   #0x1E, r4
0000D2A6  6ba400ff3d76                        mov.w   r4, @0xFF3D76:32
0000D2AC  5e007c20                 loc_D2AC   jsr     sub_7C20:24
0000D2B0  5470                                rts
0000D2B2  fc01                     sub_D2B2   mov.b   #1, r4l  ; <<< FUNC sub_D2B2
0000D2B4  6a8cbbe5                            mov.b   r4l, @0xFFFFBBE5:16
0000D2B8  7904004c                            mov.w   #0x4C, r4 ; 'L'
0000D2BC  6ba400ff3d72                        mov.w   r4, @0xFF3D72:32
0000D2C2  7904f3d6                            mov.w   #0xF3D6, r4
0000D2C6  6ba400ff3d74                        mov.w   r4, @0xFF3D74:32
0000D2CC  79040042                            mov.w   #0x42, r4 ; 'B'
0000D2D0  6ba400ff3d76                        mov.w   r4, @0xFF3D76:32
0000D2D6  5524                                bsr     sub_D2FC:8
0000D2D8  5e00b6b6                            jsr     sub_B6B6:24
0000D2DC  5470                                rts
0000D2DE  7904004c                            mov.w   #0x4C, r4 ; 'L'
0000D2E2  6ba400ff3d72                        mov.w   r4, @0xFF3D72:32
0000D2E8  7904f3d2                            mov.w   #0xF3D2, r4
0000D2EC  6ba400ff3d74                        mov.w   r4, @0xFF3D74:32
0000D2F2  79040042                            mov.w   #0x42, r4 ; 'B'
0000D2F6  6ba400ff3d76                        mov.w   r4, @0xFF3D76:32
0000D2FC  5e007c20                 sub_D2FC   jsr     sub_7C20:24  ; <<< FUNC sub_D2FC


; ==== dcs_reader_sub_25EAE  00025EA0-000260E0 ====
00025EA0  0046                                mov.b   r4l, @(0x46:16,er0)
00025EA2  5e01c050                            jsr     sub_1C050:24
00025EA6  fc00                     loc_25EA6  mov.b   #0, r4l
00025EA8  4002                                bra     locret_25EAC:8
00025EAA  fc01                     loc_25EAA  mov.b   #1, r4l
00025EAC  5470                     locret_25EAC rts
00025EAE  7a0200ff1ad1             sub_25EAE  mov.l   #0xFF1AD1, er2  ; <<< FUNC sub_25EAE
00025EB4  6c2c                                mov.b   @er2+, r4l
00025EB6  ac46                                cmp.b   #0x46, r4l ; 'F'
00025EB8  477a                                beq     loc_25F34:8
00025EBA  ac30                                cmp.b   #0x30, r4l ; '0'
00025EBC  5860026c                            bne     loc_2612C:16
00025EC0  5e04b812                            jsr     sub_4B812:24
00025EC4  58b00264                            bmi     loc_2612C:16
00025EC8  7a0200ff1ad5                        mov.l   #0xFF1AD5, er2
00025ECE  6c2c                                mov.b   @er2+, r4l
00025ED0  ac2e                                cmp.b   #0x2E, r4l ; '.'
00025ED2  58600256                            bne     loc_2612C:16
00025ED6  5e04b812                            jsr     sub_4B812:24
00025EDA  58b0024e                            bmi     loc_2612C:16
00025EDE  7a0100ffb392                        mov.l   #0xFFB392, er1
00025EE4  7a0200ff1ad2                        mov.l   #0xFF1AD2, er2
00025EEA  5e025bac                            jsr     sub_25BAC:24
00025EEE  fc30                                mov.b   #0x30, r4l ; '0'
00025EF0  6c2e                                mov.b   @er2+, r6l
00025EF2  18ce                                sub.b   r4l, r6l
00025EF4  ee0f                                and.b   #0xF, r6l
00025EF6  fd0a                                mov.b   #0xA, r5l
00025EF8  50d6                                mulxu.b r5l, r6
00025EFA  682d                                mov.b   @er2, r5l
00025EFC  18cd                                sub.b   r4l, r5l
00025EFE  ed0f                                and.b   #0xF, r5l
00025F00  08de                                add.b   r5l, r6l
00025F02  7a66000000ff                        and.l   #0xFF, er6
00025F08  1036                                shll.l  er6
00025F0A  78606b2500025be2                    mov.w   @(loc_25BE2:32,er6), r5
00025F12  6b85b394                            mov.w   r5, @0xFFFFB394:16
00025F16  78606b2500025caa                    mov.w   @(loc_25CAA:32,er6), r5
00025F1E  6a8db39b                            mov.b   r5l, @0xFFFFB39B:16
00025F22  01006b05b392                        mov.l   @0xFFFFB392:16, er5
00025F28  5e03f522                            jsr     sub_3F522:24
00025F2C  586001fc                            bne     loc_2612C:16
00025F30  5e026172                            jsr     sub_26172:24
00025F34  6a2c00ff1adb             loc_25F34  mov.b   @0xFF1ADB:32, r4l
00025F3A  ac46                                cmp.b   #0x46, r4l ; 'F'
00025F3C  587000b6                            beq     loc_25FF6:16
00025F40  ac2b                                cmp.b   #0x2B, r4l ; '+'
00025F42  4704                                beq     loc_25F48:8
00025F44  ac2d                                cmp.b   #0x2D, r4l ; '-'
00025F46  4676                                bne     loc_25FBE:8
00025F48  790c0009                 loc_25F48  mov.w   #9, e4
00025F4C  7a0500ff1adc                        mov.l   #0xFF1ADC, er5
00025F52  7a0600026130                        mov.l   #loc_26130, er6
00025F58  6c54                     loc_25F58  mov.b   @er5+, r4h
00025F5A  6c6c                                mov.b   @er6+, r4l
00025F5C  1c4c                                cmp.b   r4h, r4l
00025F5E  4606                                bne     loc_25F66:8
00025F60  1b5c                                dec.w   #1, e4
00025F62  46f4                                bne     loc_25F58:8
00025F64  4058                                bra     loc_25FBE:8
00025F66  7a0200ff1adb             loc_25F66  mov.l   #0xFF1ADB, er2
00025F6C  6c2c                                mov.b   @er2+, r4l
00025F6E  fb02                                mov.b   #2, r3l
00025F70  ac2b                                cmp.b   #0x2B, r4l ; '+'
00025F72  4702                                beq     loc_25F76:8
00025F74  fb01                                mov.b   #1, r3l
00025F76  6a8bb39c                 loc_25F76  mov.b   r3l, @0xFFFFB39C:16
00025F7A  5e04b812                            jsr     sub_4B812:24
00025F7E  4b3e                                bmi     loc_25FBE:8
00025F80  7a0200ff1adf                        mov.l   #0xFF1ADF, er2
00025F86  6c2c                                mov.b   @er2+, r4l
00025F88  ac2e                                cmp.b   #0x2E, r4l ; '.'
00025F8A  4632                                bne     loc_25FBE:8
00025F8C  5e04b812                            jsr     sub_4B812:24
00025F90  4b2c                                bmi     loc_25FBE:8
00025F92  7a0100ffb396                        mov.l   #0xFFB396, er1
00025F98  7a0200ff1adc                        mov.l   #0xFF1ADC, er2
00025F9E  5e025bac                            jsr     sub_25BAC:24
00025FA2  fc30                                mov.b   #0x30, r4l ; '0'
00025FA4  6c26                                mov.b   @er2+, r6h
00025FA6  18c6                                sub.b   r4l, r6h
00025FA8  1046                                shll.b  #2, r6h
00025FAA  1046                                shll.b  #2, r6h
00025FAC  6c2e                                mov.b   @er2+, r6l
00025FAE  18ce                                sub.b   r4l, r6l
00025FB0  ee0f                                and.b   #0xF, r6l
00025FB2  146e                                or.b    r6h, r6l
00025FB4  689e                                mov.b   r6l, @er1
00025FB6  0b01                                adds    #1, er1
00025FB8  fc00                                mov.b   #0, r4l
00025FBA  689c                                mov.b   r4l, @er1
00025FBC  4012                                bra     loc_25FD0:8
00025FBE  fc00                     loc_25FBE  mov.b   #0, r4l
00025FC0  6a8cb39c                            mov.b   r4l, @0xFFFFB39C:16
00025FC4  7a0400000000                        mov.l   #0, er4
00025FCA  01006b84b396                        mov.l   er4, @0xFFFFB396:16
00025FD0  5e034e82                 loc_25FD0  jsr     sub_34E82:24
00025FD4  58600154                            bne     loc_2612C:16
00025FD8  6a0c8dde                            mov.b   @0xFFFF8DDE:16, r4l
00025FDC  4b0a                                bmi     loc_25FE8:8
00025FDE  5e025d72                            jsr     sub_25D72:24
00025FE2  58600146                            bne     loc_2612C:16
00025FE6  400e                                bra     loc_25FF6:8
00025FE8  01006b05b392             loc_25FE8  mov.l   @0xFFFFB392:16, er5
00025FEE  5e03f522                            jsr     sub_3F522:24
00025FF2  58600136                            bne     loc_2612C:16
00025FF6  6a2c00ff1ae5             loc_25FF6  mov.b   @0xFF1AE5:32, r4l
00025FFC  ac46                                cmp.b   #0x46, r4l ; 'F'
00025FFE  471c                                beq     loc_2601C:8
00026000  ac30                                cmp.b   #0x30, r4l ; '0'
00026002  4706                                beq     loc_2600A:8
00026004  ac31                                cmp.b   #0x31, r4l ; '1'
00026006  4702                                beq     loc_2600A:8
00026008  fc30                                mov.b   #0x30, r4l ; '0'
0002600A  6a048dde                 loc_2600A  mov.b   @0xFFFF8DDE:16, r4h
0002600E  4b0c                                bmi     loc_2601C:8
00026010  770c                                bld     #0, r4l
00026012  6e0c0012                            mov.b   @(0x12:16,er0), r4l
00026016  675c                                bst     #5, r4l
00026018  6e8c0012                            mov.b   r4l, @(0x12:16,er0)
0002601C  6a2c00ff1ae6             loc_2601C  mov.b   @0xFF1AE6:32, r4l
00026022  ac46                                cmp.b   #0x46, r4l ; 'F'
00026024  471e                                beq     loc_26044:8
00026026  ac31                                cmp.b   #0x31, r4l ; '1'
00026028  470c                                beq     loc_26036:8
0002602A  fb02                                mov.b   #2, r3l
0002602C  ac32                                cmp.b   #0x32, r4l ; '2'
0002602E  4708                                beq     loc_26038:8
00026030  fb03                                mov.b   #3, r3l
00026032  ac33                                cmp.b   #0x33, r4l ; '3'
00026034  4702                                beq     loc_26038:8
00026036  fb00                     loc_26036  mov.b   #0, r3l
00026038  fb00                     loc_26038  mov.b   #0, r3l
0002603A  6a0c8dde                            mov.b   @0xFFFF8DDE:16, r4l
0002603E  4b04                                bmi     loc_26044:8
00026040  6e8b0016                            mov.b   r3l, @(0x16:16,er0)
00026044  7a0200ff1ae7             loc_26044  mov.l   #0xFF1AE7, er2
0002604A  682c                                mov.b   @er2, r4l
0002604C  ac46                                cmp.b   #0x46, r4l ; 'F'
0002604E  472a                                beq     loc_2607A:8
00026050  5e02613e                            jsr     sub_2613E:24
00026054  4618                                bne     loc_2606E:8
00026056  fe00                                mov.b   #0, r6l
00026058  7a050000585a                        mov.l   #0x585A, er5
0002605E  6d54                     loc_2605E  mov.w   @er5+, r4
00026060  1154                                shlr.w  #2, r4
00026062  1154                                shlr.w  #2, r4
00026064  1d34                                cmp.w   r3, r4
00026066  4708                                beq     loc_26070:8
00026068  0a0e                                inc.b   r6l
0002606A  ae32                                cmp.b   #0x32, r6l ; '2'
0002606C  45f0                                bcs     loc_2605E:8
0002606E  fe0c                     loc_2606E  mov.b   #0xC, r6l
00026070  6a0c8dde                 loc_26070  mov.b   @0xFFFF8DDE:16, r4l
00026074  4b04                                bmi     loc_2607A:8
00026076  6e8e0017                            mov.b   r6l, @(0x17:16,er0)
0002607A  7a0200ff1aea             loc_2607A  mov.l   #0xFF1AEA, er2
00026080  682c                                mov.b   @er2, r4l
00026082  ac46                                cmp.b   #0x46, r4l ; 'F'
00026084  4726                                beq     loc_260AC:8
00026086  5e02613e                            jsr     sub_2613E:24
0002608A  4614                                bne     loc_260A0:8
0002608C  fe00                                mov.b   #0, r6l
0002608E  7a0500005072                        mov.l   #0x5072, er5
00026094  6d54                     loc_26094  mov.w   @er5+, r4
00026096  1d34                                cmp.w   r3, r4
00026098  4708                                beq     loc_260A2:8
0002609A  0a0e                                inc.b   r6l
0002609C  ae68                                cmp.b   #0x68, r6l ; 'h'
0002609E  45f4                                bcs     loc_26094:8
000260A0  fe00                     loc_260A0  mov.b   #0, r6l
000260A2  6a0c8dde                 loc_260A2  mov.b   @0xFFFF8DDE:16, r4l
000260A6  4b04                                bmi     loc_260AC:8
000260A8  6e8e0018                            mov.b   r6l, @(0x18:16,er0)
000260AC  6a2c00ff1aed             loc_260AC  mov.b   @0xFF1AED:32, r4l
000260B2  ac46                                cmp.b   #0x46, r4l ; 'F'
000260B4  4710                                beq     loc_260C6:8
000260B6  ac30                                cmp.b   #0x30, r4l ; '0'
000260B8  4706                                beq     loc_260C0:8
000260BA  ac31                                cmp.b   #0x31, r4l ; '1'
000260BC  4702                                beq     loc_260C0:8
000260BE  fc30                                mov.b   #0x30, r4l ; '0'
000260C0  ec01                     loc_260C0  and.b   #1, r4l
000260C2  6a8cb3d3                            mov.b   r4l, @0xFFFFB3D3:16
000260C6  7a0200ff1aee             loc_260C6  mov.l   #0xFF1AEE, er2
000260CC  682c                                mov.b   @er2, r4l
000260CE  ac46                                cmp.b   #0x46, r4l ; 'F'
000260D0  4712                                beq     loc_260E4:8
000260D2  6c23                                mov.b   @er2+, r3h
000260D4  682b                                mov.b   @er2, r3l
000260D6  5e06cb40                            jsr     sub_6CB40:24
000260DA  ab80                                cmp.b   #0x80, r3l
000260DC  4502                                bcs     loc_260E0:8
000260DE  fb00                                mov.b   #0, r3l


; ==== dtmf_sub_C814  0000C800-0000C900 ====
0000C800  46                                  bcc     loc_C846:8
0000C801  f801                                mov.b   #1, r0l
0000C803  00                                  .byte    0
0000C804  6b06bc2c                            mov.w   @0xFFFFBC2C:16, r6
0000C808  7a1600000000                        add.l   #0, er6
0000C80E  fc02                                mov.b   #2, r4l
0000C810  68ec                                mov.b   r4l, @er6
0000C812  5470                                rts
0000C814  6a10ac097310             sub_C814   btst    #1, @0xFFFFAC09:16  ; <<< FUNC sub_C814
0000C81A  4650                     loc_C81A   bne     loc_C86C:8
0000C81C  7a050000c8bc                        mov.l   #0xC8BC, er5
0000C822  6d54                                mov.w   @er5+, r4
0000C824  01006b06bc2c             loc_C824   mov.l   @0xFFFFBC2C:16, er6
0000C82A  7a1600000004                        add.l   #4, er6
0000C830  7bd4598f                 loc_C830   eepmov.w
0000C834  0d44                     loc_C834   mov.w   r4, r4
0000C836  46f8                                bne     loc_C830:8
0000C838  01006b06bc2c                        mov.l   @0xFFFFBC2C:16, er6
0000C83E  7a1600000004                        add.l   #4, er6
0000C844  0fe1                                mov.l   er6, er1
0000C846  6a0dac07                 loc_C846   mov.b   @0xFFFFAC07:16, r5l
0000C84A  f500                                mov.b   #0, r5h
0000C84C  0a0d                                inc.b   r5l
0000C84E  1b06                                subs    #1, er6
0000C850  5e00d24c                            jsr     sub_D24C:24
0000C854  6a0cac08                            mov.b   @0xFFFFAC08:16, r4l
0000C858  7a64000000ff                        and.l   #0xFF, er4
0000C85E  78406a2c0000c8d4                    mov.b   @(0xC8D4:32,er4), r4l
0000C866  6e9c000a                            mov.b   r4l, @(0xA:16,er1)
0000C86A  403e                                bra     loc_C8AA:8
0000C86C  7a050000c8ca             loc_C86C   mov.l   #0xC8CA, er5
0000C872  6d54                                mov.w   @er5+, r4
0000C874  01006b06bc2c                        mov.l   @0xFFFFBC2C:16, er6
0000C87A  7a1600000004                        add.l   #4, er6
0000C880  7bd4598f                 loc_C880   eepmov.w
0000C884  0d44                                mov.w   r4, r4
0000C886  46f8                                bne     loc_C880:8
0000C888  01006b06bc2c                        mov.l   @0xFFFFBC2C:16, er6
0000C88E  7a1600000004                        add.l   #4, er6
0000C894  6a0cac08                            mov.b   @0xFFFFAC08:16, r4l
0000C898  7a64000000ff                        and.l   #0xFF, er4
0000C89E  78406a2c0000c8d4                    mov.b   @(0xC8D4:32,er4), r4l
0000C8A6  6eec0006                            mov.b   r4l, @(6:16,er6)
0000C8AA  01006b06bc2c             loc_C8AA   mov.l   @0xFFFFBC2C:16, er6
0000C8B0  7a1600000000                        add.l   #0, er6
0000C8B6  fc02                                mov.b   #2, r4l
0000C8B8  68ec                                mov.b   r4l, @er6
0000C8BA  5470                                rts
0000C8BC  000b                     word_C8BC  .word 0xB
0000C8BE  2020                                mov.b   @0xFFFFFF20:8, r0h
0000C8C0  203a                                mov.b   @0xFFFFFF3A:8, r0h
0000C8C2  2044                                mov.b   @0xFFFFFF44:8, r0h
0000C8C4  54                                  .byte 0x54 ; T
0000C8C5  4d46                                blt     loc_C908+4:8
0000C8C7  202d                                mov.b   @0xFFFFFF2D:8, r0h
0000C8C9  0000                     loc_C8C9   nop
0000C8CB  0720                                ldc.b   #0x20, ccr ; ' '
0000C8CD  4454                                bcc     loc_C922:8
0000C8CF  4d46                                blt     loc_C916:8
0000C8D1  202d                                mov.b   @0xFFFFFF2D:8, r0h
0000C8D3  00                                  .byte    0
0000C8D4  3031                                mov.b   r0h, @0xFFFFFF31:8
0000C8D6  3233                                mov.b   r2h, @0xFFFFFF33:8
0000C8D8  3435                                mov.b   r4h, @0xFFFFFF35:8
0000C8DA  3637                                mov.b   r6h, @0xFFFFFF37:8
0000C8DC  3839                                mov.b   r0l, @0xFFFFFF39:8
0000C8DE  4142                                brn     loc_C922:8
0000C8E0  4344                                bls     loc_C926:8
0000C8E2  2a23                                mov.b   @0xFFFFFF23:8, r2l
0000C8E4  2d00                                mov.b   @0xFFFFFF00:8, r5l
0000C8E6  7a050000b83a             sub_C8E6   mov.l   #0xB83A, er5  ; <<< FUNC sub_C8E6
0000C8EC  6d54                                mov.w   @er5+, r4
0000C8EE  01006b06bc2c                        mov.l   @0xFFFFBC2C:16, er6
0000C8F4  7a1600000030                        add.l   #0x30, er6 ; '0'
0000C8FA  7bd4598f                 loc_C8FA   eepmov.w
0000C8FE  0d44                                mov.w   r4, r4


; ==== aprs_msgtype_sub_502D2  000502C0-00050440 ====
000502C0  0b96                     loc_502C0  adds    #4, er6
000502C2  5e04f260                            jsr     sub_4F260:24
000502C6  6a0ca503                            mov.b   @0xFFFFA503:16, r4l
000502CA  ac02                                cmp.b   #2, r4l
000502CC  4402                                bcc     locret_502D0:8
000502CE  8b02                                add.b   #2, r3l
000502D0  5470                     locret_502D0 rts
000502D2  01006b05a526             sub_502D2  mov.l   @0xFFFFA526:16, er5  ; <<< FUNC sub_502D2
000502D8  6c56                                mov.b   @er5+, r6h
000502DA  6c5e                                mov.b   @er5+, r6l
000502DC  0d6e                                mov.w   r6, e6
000502DE  6c56                                mov.b   @er5+, r6h
000502E0  6c5e                                mov.b   @er5+, r6l
000502E2  01006b86a52a                        mov.l   er6, @0xFFFFA52A:16
000502E8  6c54                                mov.b   @er5+, r4h
000502EA  6c5c                                mov.b   @er5+, r4l
000502EC  6b84a52e                            mov.w   r4, @0xFFFFA52E:16
000502F0  790c0006                            mov.w   #6, e4
000502F4  7a05000503a0                        mov.l   #loc_503A0, er5
000502FA  6d54                     loc_502FA  mov.w   @er5+, r4
000502FC  1de4                                cmp.w   e6, r4
000502FE  5870009c                            beq     locret_5039E:16
00050302  1b5c                                dec.w   #1, e4
00050304  46f4                                bne     loc_502FA:8
00050306  790c000b                            mov.w   #0xB, e4
0005030A  7a05000503ac                        mov.l   #loc_503AC, er5
00050310  6d54                     loc_50310  mov.w   @er5+, r4
00050312  1de4                                cmp.w   e6, r4
00050314  4608                                bne     loc_5031E:8
00050316  6854                                mov.b   @er5, r4h
00050318  1c64                                cmp.b   r6h, r4h
0005031A  58700080                            beq     locret_5039E:16
0005031E  0b85                     loc_5031E  adds    #2, er5
00050320  1b5c                                dec.w   #1, e4
00050322  46ec                                bne     loc_50310:8
00050324  790c0006                            mov.w   #6, e4
00050328  7a05000503d8                        mov.l   #(loc_503D7+1), er5
0005032E  6d54                     loc_5032E  mov.w   @er5+, r4
00050330  1de4                                cmp.w   e6, r4
00050332  4606                                bne     loc_5033A:8
00050334  6954                                mov.w   @er5, r4
00050336  1d64                                cmp.w   r6, r4
00050338  4764                                beq     locret_5039E:8
0005033A  0b85                     loc_5033A  adds    #2, er5
0005033C  1b5c                                dec.w   #1, e4
0005033E  46ee                                bne     loc_5032E:8
00050340  790c0002                            mov.w   #2, e4
00050344  7a05000503f0                        mov.l   #loc_503F0, er5
0005034A  6d54                     loc_5034A  mov.w   @er5+, r4
0005034C  1de4                                cmp.w   e6, r4
0005034E  4612                                bne     loc_50362:8
00050350  6954                                mov.w   @er5, r4
00050352  1d64                                cmp.w   r6, r4
00050354  460c                                bne     loc_50362:8
00050356  6e540002                            mov.b   @(2:16,er5), r4h
0005035A  6a0ca52e                            mov.b   @0xFFFFA52E:16, r4l
0005035E  1c4c                                cmp.b   r4h, r4l
00050360  473c                                beq     locret_5039E:8
00050362  0b95                     loc_50362  adds    #4, er5
00050364  1b5c                                dec.w   #1, e4
00050366  46e2                                bne     loc_5034A:8
00050368  790c0001                            mov.w   #1, e4
0005036C  7a05000503fc                        mov.l   #loc_503FC, er5
00050372  6d54                     loc_50372  mov.w   @er5+, r4
00050374  1de4                                cmp.w   e6, r4
00050376  461e                                bne     loc_50396:8
00050378  6954                                mov.w   @er5, r4
0005037A  1d64                                cmp.w   r6, r4
0005037C  4618                                bne     loc_50396:8
0005037E  6e540002                            mov.b   @(2:16,er5), r4h
00050382  6a0ca52e                            mov.b   @0xFFFFA52E:16, r4l
00050386  1c4c                                cmp.b   r4h, r4l
00050388  460c                                bne     loc_50396:8
0005038A  6e540003                            mov.b   @(3:16,er5), r4h
0005038E  6a0ca52f                            mov.b   @0xFFFFA52F:16, r4l
00050392  1c4c                                cmp.b   r4h, r4l
00050394  4708                                beq     locret_5039E:8
00050396  0b95                     loc_50396  adds    #4, er5
00050398  1b5c                                dec.w   #1, e4
0005039A  46d6                                bne     loc_50372:8
0005039C  fbff                                mov.b   #0xFF, r3l
0005039E  5470                     locret_5039E rts
000503A0  4150                     loc_503A0  brn     loc_503F2:8
000503A2  4351                                bls     loc_503F4:8
000503A4  4446                                bcc     unk_503EC:8
000503A6  4458                                bcc     loc_50400:8
000503A8  57                                  .byte 0x57 ; W
000503A9  58                                  .byte 0x58 ; X
000503AA  4944                                bvs     loc_503F0:8
000503AC  4149                     loc_503AC  brn     loc_503F6:8
000503AE  5220                                mulxu.w r2, er0
000503B0  414c                                brn     loc_503FE:8
000503B2  4c20                                bge     loc_503D3+1:8
000503B4  4750                                beq     sub_50402+4:8
000503B6  5320                                divxu.w r2, er0
000503B8  5153                                divxu.b r5h, r3
000503BA  54                                  .byte 0x54 ; T
000503BB  2051                                mov.b   @0xFFFFFF51:8, r0h
000503BD  54                                  .byte 0x54 ; T
000503BE  4820                                bvc     loc_503DF+1:8
000503C0  53                                  .byte 0x53 ; S
000503C1  4b59                                bmi     loc_5041A+2:8
000503C3  2053                                mov.b   @0xFFFFFF53:8, r0h
000503C5  5043                                mulxu.b r4h, r3
000503C7  2053                                mov.b   @0xFFFFFF53:8, r0h
000503C9  59                                  .byte 0x59 ; Y
000503CA  4d20                                blt     unk_503EC:8
000503CC  54                                  .byte 0x54 ; T
000503CD  454c                                bcs     loc_5041A:8
000503CF  2054                                mov.b   @0xFFFFFF54:8, r0h
000503D1  4c4d                                bge     loc_50420:8
000503D3  205a                     loc_503D3  mov.b   @0xFFFFFF5A:8, r0h
000503D5  4950                                bvs     loc_50426:8
000503D7  2044                     loc_503D7  mov.b   @0xFFFFFF44:8, r0h
000503D9  4750                                beq     loc_5042A:8
000503DB  53                                  .byte 0x53 ; S
000503DC  4a41                                bpl     loc_5041E:8
000503DE  56                                  .byte 0x56 ; V
000503DF  414d                     loc_503DF  brn     loc_5042C+2:8
000503E1  4149                                brn     loc_5042C:8
000503E3  4c4d                                bge     loc_50432:8
000503E5  4943                                bvs     loc_5042A:8
000503E7  4552                                bcs     sub_5043A:8
000503E9  54                                  .byte 0x54 ; T
000503EA  434d                                bls     locret_50438:8
000503EC  54                       unk_503EC  .byte 0x54 ; T
000503ED  4553                                bcs     loc_50440+2:8
000503EF  54                                  .byte 0x54 ; T
000503F0  4452                     loc_503F0  bcc     loc_50440+4:8
000503F2  494c                     loc_503F2  bvs     loc_50440:8
000503F4  4c20                     loc_503F4  bge     loc_50414+2:8
000503F6  5350                     loc_503F6  divxu.w r5, er0
000503F8  4143                                brn     sub_5043A+2:8
000503FA  4520                                bcs     loc_5041A+2:8
000503FC  4245                     loc_503FC  bhi     loc_50440+2:8
000503FE  4143                     loc_503FE  brn     loc_50440+2:8
00050400  4f4e                     loc_50400  ble     loc_50450:8
00050402  6a10a9fa7300             sub_50402  btst    #0, @0xFFFFA9FA:16  ; <<< FUNC sub_50402
00050408  462a                                bne     loc_50434:8
0005040A  6a0d8eab                            mov.b   @0xFFFF8EAB:16, r5l
0005040E  7a65000000ff                        and.l   #0xFF, er5
00050414  6e5da6ec                 loc_50414  mov.b   @(-0x5914:16,er5), r5l
00050418  4b1a                                bmi     loc_50434:8
0005041A  79040020                 loc_5041A  mov.w   #0x20, r4 ; ' '
0005041E  5245                     loc_5041E  mulxu.w r4, er5
00050420  7a1500fee000             loc_50420  add.l   #0xFEE000, er5
00050426  685c                     loc_50426  mov.b   @er5, r4l
00050428  acff                                cmp.b   #0xFF, r4l
0005042A  4708                     loc_5042A  beq     loc_50434:8
0005042C  6a18a5067000             loc_5042C  bset    #0, @0xFFFFA506:16
00050432  4004                     loc_50432  bra     locret_50438:8
00050434  5e03ffa0                 loc_50434  jsr     sub_3FFA0:24
00050438  5470                     locret_50438 rts
0005043A  7a04ffffffff             sub_5043A  mov.l   #0xFFFFFFFF, er4  ; <<< FUNC sub_5043A


; ==== aprs_symbol_reader  00006240-000062A0 ====
00006240  b05e                                mov.b   r3l, @0xFFFFB05E:16
00006242  5e044c36                            jsr     sub_44C36:24
00006246  6a8bb05f                            mov.b   r3l, @0xFFFFB05F:16
0000624A  5470                                rts
0000624C  5e00a55a                            jsr     sub_A55A:24
00006250  5470                                rts
00006252  6a0c8c1e                 sub_6252   mov.b   @0xFFFF8C1E:16, r4l  ; <<< FUNC sub_6252
00006256  ac03                                cmp.b   #3, r4l
00006258  470c                                beq     loc_6266:8
0000625A  7a64000000ff                        and.l   #0xFF, er4
00006260  6e4b8c1f                            mov.b   @(-0x73E1:16,er4), r3l
00006264  4004                                bra     locret_626A:8
00006266  6a0b8aa1                 loc_6266   mov.b   @0xFFFF8AA1:16, r3l
0000626A  5470                     locret_626A rts
0000626C  79040010                 sub_626C   mov.w   #0x10, r4  ; <<< FUNC sub_626C
00006270  0cbd                                mov.b   r3l, r5l
00006272  f500                                mov.b   #0, r5h
00006274  5245                                mulxu.w r4, er5
00006276  7a1500043946                        add.l   #sub_43946, er5
0000627C  5470                                rts
0000627E  5e0062a6                 sub_627E   jsr     sub_62A6:24  ; <<< FUNC sub_627E
00006282  790d00c4                            mov.w   #0xC4, e5
00006286  7a06000437be                        mov.l   #loc_437BE, er6
0000628C  fb00                                mov.b   #0, r3l
0000628E  6d65                     loc_628E   mov.w   @er6+, r5
00006290  1d54                                cmp.w   r5, r4
00006292  470e                                beq     loc_62A2:8
00006294  0a0b                                inc.b   r3l
00006296  1b5d                                dec.w   #1, e5
00006298  46f4                                bne     loc_628E:8
0000629A  7a0500004c14                        mov.l   #0x4C14, er5


; ==== pre_fusion_mode  0005C500-0005C700 ====
0005C500  6b05b1d0                            mov.l   @0xFFFFB1D0:16, er5
0005C504  fa5d                                mov.b   #0x5D, r2l ; ']'
0005C506  5e05c780                            jsr     loc_5C77F+1:24
0005C50A  5470                     locret_5C50A rts
0005C50C  6a0c8dde                 sub_5C50C  mov.b   @0xFFFF8DDE:16, r4l  ; <<< FUNC sub_5C50C
0005C510  4a0c                                bpl     loc_5C51E:8
0005C512  fc00                                mov.b   #0, r4l
0005C514  6a10b3d97700                        bld     #0, @0xFFFFB3D9:16
0005C51A  67fc                                bist    #7, r4l
0005C51C  0ccc                                mov.b   r4l, r4l
0005C51E  4726                     loc_5C51E  beq     loc_5C546:8
0005C520  4a10                                bpl     loc_5C532:8
0005C522  6a10b3d97300                        btst    #0, @0xFFFFB3D9:16
0005C528  461c                                bne     loc_5C546:8
0005C52A  6a10b3d97370                        btst    #7, @0xFFFFB3D9:16
0005C530  4614                                bne     loc_5C546:8
0005C532  6a108de07370             loc_5C532  btst    #7, @0xFFFF8DE0:16
0005C538  5870ff2c                            beq     sub_5C468:16
0005C53C  6a10b3d87370                        btst    #7, @0xFFFFB3D8:16
0005C542  5870ff22                            beq     sub_5C468:16
0005C546  6a0cb11e                 loc_5C546  mov.b   @0xFFFFB11E:16, r4l
0005C54A  5870009e                            beq     loc_5C5EC:16
0005C54E  ac01                                cmp.b   #1, r4l
0005C550  4736                                beq     loc_5C588:8
0005C552  ac02                                cmp.b   #2, r4l
0005C554  471a                                beq     loc_5C570:8
0005C556  ac03                                cmp.b   #3, r4l
0005C558  58600090                            bne     loc_5C5EC:16
0005C55C  6b04b126                            mov.w   @0xFFFFB126:16, r4
0005C560  5860009a                            bne     locret_5C5FE:16
0005C564  5e05ca62                            jsr     sub_5CA62:24
0005C568  5e05ca90                            jsr     sub_5CA90:24
0005C56C  5800008e                            bra     locret_5C5FE:16
0005C570  6b04b126                 loc_5C570  mov.w   @0xFFFFB126:16, r4
0005C574  58600086                            bne     locret_5C5FE:16
0005C578  5e05c87c                            jsr     sub_5C87C:24
0005C57C  7a050005c600                        mov.l   #sub_5C600, er5
0005C582  5e05c9d6                            jsr     sub_5C9D6:24
0005C586  4076                                bra     locret_5C5FE:8
0005C588  6b04b126                 loc_5C588  mov.w   @0xFFFFB126:16, r4
0005C58C  4670                                bne     locret_5C5FE:8
0005C58E  6a0eb1c3                            mov.b   @0xFFFFB1C3:16, r6l
0005C592  7a66000000ff                        and.l   #0xFF, er6
0005C598  7a1600ff0206                        add.l   #0xFF0206, er6
0005C59E  01006b05b1d0                        mov.l   @0xFFFFB1D0:16, er5
0005C5A4  6a2c00ff0207                        mov.b   @0xFF0207:32, r4l
0005C5AA  ac4e                                cmp.b   #0x4E, r4l ; 'N'
0005C5AC  4726                                beq     loc_5C5D4:8
0005C5AE  ac47                                cmp.b   #0x47, r4l ; 'G'
0005C5B0  461c                                bne     loc_5C5CE:8
0005C5B2  6a2c00ff0208                        mov.b   @0xFF0208:32, r4l
0005C5B8  ac72                                cmp.b   #0x72, r4l ; 'r'
0005C5BA  4708                                beq     loc_5C5C4:8
0005C5BC  ac52                                cmp.b   #0x52, r4l ; 'R'
0005C5BE  4704                                beq     loc_5C5C4:8
0005C5C0  ac73                                cmp.b   #0x73, r4l ; 's'
0005C5C2  460a                                bne     loc_5C5CE:8
0005C5C4  6b0ab480                 loc_5C5C4  mov.w   @0xFFFFB480:16, e2
0005C5C8  0da2                                mov.w   e2, r2
0005C5CA  5e05cf1c                            jsr     loc_5CF1B+1:24
0005C5CE  5e05d0ac                 loc_5C5CE  jsr     loc_5D0AB+1:24
0005C5D2  402a                                bra     locret_5C5FE:8
0005C5D4  6b0ab254                 loc_5C5D4  mov.w   @0xFFFFB254:16, e2
0005C5D8  0da2                                mov.w   e2, r2
0005C5DA  6a0cb0b9                            mov.b   @0xFFFFB0B9:16, r4l
0005C5DE  ac0a                                cmp.b   #0xA, r4l
0005C5E0  4604                                bne     loc_5C5E6:8
0005C5E2  5e05cf1c                            jsr     loc_5CF1B+1:24
0005C5E6  5e05d172                 loc_5C5E6  jsr     sub_5D172:24
0005C5EA  4012                                bra     locret_5C5FE:8
0005C5EC  6b04b126                 loc_5C5EC  mov.w   @0xFFFFB126:16, r4
0005C5F0  460c                                bne     locret_5C5FE:8
0005C5F2  550e                                bsr     sub_5C602:8
0005C5F4  7a050005c600                        mov.l   #sub_5C600, er5
0005C5FA  5e05c780                            jsr     loc_5C77F+1:24
0005C5FE  5470                     locret_5C5FE rts
0005C600  ffff                     sub_5C600  mov.b   #0xFF, r7l  ; <<< FUNC sub_5C600
0005C602  6a10aad47320             sub_5C602  btst    #2, @0xFFFFAAD4:16  ; <<< FUNC sub_5C602
0005C608  5860008e                            bne     loc_5C69A:16
0005C60C  6a10aad47330                        btst    #3, @0xFFFFAAD4:16
0005C612  5860005e                            bne     loc_5C674:16
0005C616  6a03b11f                            mov.b   @0xFFFFB11F:16, r3h
0005C61A  fb5e                                mov.b   #0x5E, r3l ; '^'
0005C61C  6ba300ff0206                        mov.w   r3, @0xFF0206:32
0005C622  6a108d827300                        btst    #0, @0xFFFF8D82:16
0005C628  461c                                bne     loc_5C646:8
0005C62A  fb61                     loc_5C62A  mov.b   #0x61, r3l ; 'a'
0005C62C  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C632  68eb                                mov.b   r3l, @er6
0005C634  0b06                                adds    #1, er6
0005C636  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C638  68ec                                mov.b   r4l, @er6
0005C63A  0b06                                adds    #1, er6
0005C63C  fc30                                mov.b   #0x30, r4l ; '0'
0005C63E  68ec                                mov.b   r4l, @er6
0005C640  0b06                                adds    #1, er6
0005C642  fa5d                                mov.b   #0x5D, r2l ; ']'
0005C644  4024                                bra     loc_5C66A:8
0005C646  5e023038                 loc_5C646  jsr     sub_23038:24
0005C64A  47de                                beq     loc_5C62A:8
0005C64C  fb62                                mov.b   #0x62, r3l ; 'b'
0005C64E  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C654  68eb                                mov.b   r3l, @er6
0005C656  0b06                                adds    #1, er6
0005C658  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C65A  68ec                                mov.b   r4l, @er6
0005C65C  0b06                                adds    #1, er6
0005C65E  fc30                                mov.b   #0x30, r4l ; '0'
0005C660  68ec                                mov.b   r4l, @er6
0005C662  0b06                                adds    #1, er6
0005C664  5e0496a6                            jsr     sub_496A6:24
0005C668  fa4b                                mov.b   #0x4B, r2l ; 'K'
0005C66A  79040000                 loc_5C66A  mov.w   #0, r4
0005C66E  6b84b124                            mov.w   r4, @0xFFFFB124:16
0005C672  5470                                rts
0005C674  6a03b11f                 loc_5C674  mov.b   @0xFFFFB11F:16, r3h
0005C678  fb5d                                mov.b   #0x5D, r3l ; ']'
0005C67A  6ba300ff0206                        mov.w   r3, @0xFF0206:32
0005C680  fb6d                                mov.b   #0x6D, r3l ; 'm'
0005C682  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C688  68eb                                mov.b   r3l, @er6
0005C68A  0b06                                adds    #1, er6
0005C68C  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C68E  68ec                                mov.b   r4l, @er6
0005C690  0b06                                adds    #1, er6
0005C692  fc30                                mov.b   #0x30, r4l ; '0'
0005C694  68ec                                mov.b   r4l, @er6
0005C696  0b06                                adds    #1, er6
0005C698  4024                                bra     loc_5C6BE:8
0005C69A  6a03b11f                 loc_5C69A  mov.b   @0xFFFFB11F:16, r3h
0005C69E  fb5d                                mov.b   #0x5D, r3l ; ']'
0005C6A0  6ba300ff0206             loc_5C6A0  mov.w   r3, @0xFF0206:32
0005C6A6  fb76                                mov.b   #0x76, r3l ; 'v'
0005C6A8  7a0600ff0208                        mov.l   #0xFF0208, er6
0005C6AE  68eb                                mov.b   r3l, @er6
0005C6B0  0b06                                adds    #1, er6
0005C6B2  fc5f                                mov.b   #0x5F, r4l ; '_'
0005C6B4  68ec                                mov.b   r4l, @er6
0005C6B6  0b06                                adds    #1, er6
0005C6B8  fc30                                mov.b   #0x30, r4l ; '0'
0005C6BA  68ec                                mov.b   r4l, @er6
0005C6BC  0b06                                adds    #1, er6
0005C6BE  6a108d827300             loc_5C6BE  btst    #0, @0xFFFF8D82:16
0005C6C4  4712                                beq     loc_5C6D8:8
0005C6C6  5e023038                            jsr     sub_23038:24
0005C6CA  470c                                beq     loc_5C6D8:8
0005C6CC  7a0600ff020b                        mov.l   #0xFF020B, er6
0005C6D2  5e0496a6                            jsr     sub_496A6:24
0005C6D6  4018                                bra     loc_5C6F0:8
0005C6D8  7a0600ff020b             loc_5C6D8  mov.l   #0xFF020B, er6
0005C6DE  fc12                                mov.b   #0x12, r4l
0005C6E0  7a050005f88a                        mov.l   #sub_5F88A, er5
0005C6E6  f400                                mov.b   #0, r4h
0005C6E8  7bd4598f                 loc_5C6E8  eepmov.w
0005C6EC  0d44                                mov.w   r4, r4
0005C6EE  46f8                                bne     loc_5C6E8:8
0005C6F0  6a0cb26e                 loc_5C6F0  mov.b   @0xFFFFB26E:16, r4l
0005C6F4  ac02                                cmp.b   #2, r4l
0005C6F6  4728                                beq     loc_5C720:8
0005C6F8  fc05                                mov.b   #5, r4l
0005C6FA  7a0500ffb2c9                        mov.l   #0xFFB2C9, er5



; ==== scan_engine  0002F1DA-0002F420 ====
0002F1DA  6a18aa367260             loc_2F1DA bclr    #6, @0xFFFFAA36:16
0002F1E0  6e0a008c                          mov.b   @(0x8C:16,er0), r2l
0002F1E4  4762                              beq     loc_2F248:8
0002F1E6  aa06                              cmp.b   #6, r2l
0002F1E8  470a                              beq     loc_2F1F4:8
0002F1EA  aa07                              cmp.b   #7, r2l
0002F1EC  4706                              beq     loc_2F1F4:8
0002F1EE  fc00                              mov.b   #0, r4l
0002F1F0  6e8c0092                          mov.b   r4l, @(0x92:16,er0)
0002F1F4  6e0b008c                 loc_2F1F4 mov.b   @(0x8C:16,er0), r3l
0002F1F8  7a63000000ff                      and.l   #0xFF, er3
0002F1FE  1073                              shll.l  #2, er3
0002F200  78                                .byte 0x78 ; x
0002F201  b06b                              subx    #0x6B, r0h ; 'k'
0002F203  2600                              mov.b   @0xFFFFFF00:8, r6h
0002F205  02                                .byte    2
0002F206  f288                              mov.b   #0x88, r2h
0002F208  5960                              jmp     @er6
0002F20A  5e02f4aa                          jsr     sub_2F4AA:24
0002F20E  fc00                              mov.b   #0, r4l
0002F210  6e8c0093                          mov.b   r4l, @(0x93:16,er0)
0002F214  4032                              bra     loc_2F248:8
0002F216  5e02f4aa                          jsr     sub_2F4AA:24
0002F21A  6e0c0093                          mov.b   @(0x93:16,er0), r4l
0002F21E  ac03                              cmp.b   #3, r4l
0002F220  4526                              bcs     loc_2F248:8
0002F222  5e02faec                          jsr     sub_2FAEC:24
0002F226  4020                              bra     loc_2F248:8
0002F228  5e02f4aa                          jsr     sub_2F4AA:24
0002F22C  6e0c0093                          mov.b   @(0x93:16,er0), r4l
0002F230  ac03                              cmp.b   #3, r4l
0002F232  4514                              bcs     loc_2F248:8
0002F234  fc00                              mov.b   #0, r4l
0002F236  6a8c95ac                          mov.b   r4l, @0xFFFF95AC:16
0002F23A  5e02fb94                          jsr     sub_2FB94:24
0002F23E  4008                              bra     loc_2F248:8
0002F240  5e02f4aa                          jsr     sub_2F4AA:24
0002F244  5e02f5ee                          jsr     sub_2F5EE:24
0002F248  6e0b0093                 loc_2F248 mov.b   @(0x93:16,er0), r3l
0002F24C  7a63000000ff                      and.l   #0xFF, er3
0002F252  1073                              shll.l  #2, er3
0002F254  78                                .byte 0x78 ; x
0002F255  b06b                              subx    #0x6B, r0h ; 'k'
0002F257  2600                              mov.b   @0xFFFFFF00:8, r6h
0002F259  02                                .byte    2
0002F25A  f2a8                              mov.b   #0xA8, r2h
0002F25C  5d60                              jsr     @er6
0002F25E  fc00                              mov.b   #0, r4l
0002F260  6e8c008c                          mov.b   r4l, @(0x8C:16,er0)
0002F264  6a0c8d20                          mov.b   @0xFFFF8D20:16, r4l
0002F268  4702                              beq     loc_2F26C:8
0002F26A  5574                              bsr     sub_2F2E0:8
0002F26C  5e032d8e                 loc_2F26C jsr     sub_32D8E:24
0002F270  5e038074                          jsr     loc_38074:24
0002F274  6e0a0094                          mov.b   @(0x94:16,er0), r2l
0002F278  4704                              beq     loc_2F27E:8
0002F27A  5e0377c2                          jsr     sub_377C2:24
0002F27E  6e0c0090                 loc_2F27E mov.b   @(0x90:16,er0), r4l
0002F282  6a8cbb96                          mov.b   r4l, @0xFFFFBB96:16
0002F286  5470                              rts
0002F288  00                                .byte    0
0002F289  02                                .byte    2
0002F28A  f248                              mov.b   #0x48, r2h ; 'H'
0002F28C  00                                .byte    0
0002F28D  02                                .byte    2
0002F28E  f20a                              mov.b   #0xA, r2h
0002F290  00                                .byte    0
0002F291  02                                .byte    2
0002F292  f20a                              mov.b   #0xA, r2h
0002F294  00                                .byte    0
0002F295  02                                .byte    2
0002F296  f216                              mov.b   #0x16, r2h
0002F298  00                                .byte    0
0002F299  02                                .byte    2
0002F29A  f228                              mov.b   #0x28, r2h ; '('
0002F29C  00                                .byte    0
0002F29D  02                                .byte    2
0002F29E  f228                              mov.b   #0x28, r2h ; '('
0002F2A0  00                                .byte    0
0002F2A1  02                                .byte    2
0002F2A2  f240                              mov.b   #0x40, r2h ; '@'
0002F2A4  00                                .byte    0
0002F2A5  02                                .byte    2
0002F2A6  f20a                              mov.b   #0xA, r2h
0002F2A8  00                                .byte    0
0002F2A9  02                                .byte    2
0002F2AA  f69e                              mov.b   #0x9E, r6h
0002F2AC  00                                .byte    0
0002F2AD  02                                .byte    2
0002F2AE  fa7c                              mov.b   #0x7C, r2l ; '|'
0002F2B0  00                                .byte    0
0002F2B1  02                                .byte    2
0002F2B2  fc0a                              mov.b   #0xA, r4l
0002F2B4  00                                .byte    0
0002F2B5  02                                .byte    2
0002F2B6  fc0c                              mov.b   #0xC, r4l
0002F2B8  00                                .byte    0
0002F2B9  02                                .byte    2
0002F2BA  fe44                              mov.b   #0x44, r6l ; 'D'
0002F2BC  00                                .byte    0
0002F2BD  0302                              ldc.b   r2h, ccr
0002F2BF  a000                              cmp.b   #0, r0h
0002F2C1  0303                              ldc.b   r3h, ccr
0002F2C3  1000                              shll.b  r0h
0002F2C5  0304                              ldc.b   r4h, ccr
0002F2C7  1000                              shll.b  r0h
0002F2C9  0304                              ldc.b   r4h, ccr
0002F2CB  dc00                              xor.b   #0, r4l
0002F2CD  0300                              ldc.b   r0h, ccr
0002F2CF  0c00                              mov.b   r0h, r0h
0002F2D1  0300                              ldc.b   r0h, ccr
0002F2D3  8c00                              add.b   #0, r4l
0002F2D5  0301                              ldc.b   r1h, ccr
0002F2D7  9e00                              addx    #0, r6l
0002F2D9  02                                .byte    2
0002F2DA  ff78                              mov.b   #0x78, r7l ; 'x'
0002F2DC  00                                .byte    0
0002F2DD  02                                .byte    2
0002F2DE  fc0c                              mov.b   #0xC, r4l
0002F2E0  6e0c0001                 sub_2F2E0 mov.b   @(1:16,er0), r4l  ; <<< FUNC sub_2F2E0
0002F2E4  ac03                              cmp.b   #3, r4l
0002F2E6  4732                              beq     loc_2F31A:8
0002F2E8  ac0b                              cmp.b   #0xB, r4l
0002F2EA  472e                              beq     loc_2F31A:8
0002F2EC  ac0a                              cmp.b   #0xA, r4l
0002F2EE  4708                              beq     loc_2F2F8:8
0002F2F0  6a108ea97370                      btst    #7, @0xFFFF8EA9:16
0002F2F6  4622                              bne     loc_2F31A:8
0002F2F8  6a0cb2a5                 loc_2F2F8 mov.b   @0xFFFFB2A5:16, r4l
0002F2FC  ac02                              cmp.b   #2, r4l
0002F2FE  4608                              bne     loc_2F308:8
0002F300  6a10b26b7300                      btst    #0, @0xFFFFB26B:16
0002F306  4612                              bne     loc_2F31A:8
0002F308  5e056c68                 loc_2F308 jsr     sub_56C68:24
0002F30C  6a0cb0d7                          mov.b   @0xFFFFB0D7:16, r4l
0002F310  1c4c                              cmp.b   r4h, r4l
0002F312  4706                              beq     loc_2F31A:8
0002F314  6a18b0aa7070                      bset    #7, @0xFFFFB0AA:16
0002F31A  6a0c8d20                 loc_2F31A mov.b   @0xFFFF8D20:16, r4l
0002F31E  ac01                              cmp.b   #1, r4l
0002F320  474a                              beq     loc_2F36C:8
0002F322  6a0bb112                          mov.b   @0xFFFFB112:16, r3l
0002F326  6a0cb111                          mov.b   @0xFFFFB111:16, r4l
0002F32A  4708                              beq     loc_2F334:8
0002F32C  6a0cbc5d                          mov.b   @0xFFFFBC5D:16, r4l
0002F330  4754                              beq     loc_2F386:8
0002F332  460c                              bne     loc_2F340:8
0002F334  ab01                     loc_2F334 cmp.b   #1, r3l
0002F336  4722                              beq     loc_2F35A:8
0002F338  6a0cb113                          mov.b   @0xFFFFB113:16, r4l
0002F33C  ac02                              cmp.b   #2, r4l
0002F33E  4746                              beq     loc_2F386:8
0002F340  6a0b8eb6                 loc_2F340 mov.b   @0xFFFF8EB6:16, r3l
0002F344  6a10a9e37300                      btst    #0, @0xFFFFA9E3:16
0002F34A  473a                              beq     loc_2F386:8
0002F34C  fb04                              mov.b   #4, r3l
0002F34E  6e0c0019                          mov.b   @(0x19:16,er0), r4l
0002F352  ac00                              cmp.b   #0, r4l
0002F354  4730                              beq     loc_2F386:8
0002F356  fb05                              mov.b   #5, r3l
0002F358  402c                              bra     loc_2F386:8
0002F35A  6a0c8eb6                 loc_2F35A mov.b   @0xFFFF8EB6:16, r4l
0002F35E  ac01                              cmp.b   #1, r4l
0002F360  4724                              beq     loc_2F386:8
0002F362  6a0c8eb6                          mov.b   @0xFFFF8EB6:16, r4l
0002F366  6a8c8eb7                          mov.b   r4l, @0xFFFF8EB7:16
0002F36A  401a                              bra     loc_2F386:8
0002F36C  6a0bb112                 loc_2F36C mov.b   @0xFFFFB112:16, r3l
0002F370  6a0cb111                          mov.b   @0xFFFFB111:16, r4l
0002F374  4708                              beq     loc_2F37E:8
0002F376  6a0cbc5d                          mov.b   @0xFFFFBC5D:16, r4l
0002F37A  470a                              beq     loc_2F386:8
0002F37C  4604                              bne     loc_2F382:8
0002F37E  ab01                     loc_2F37E cmp.b   #1, r3l
0002F380  4704                              beq     loc_2F386:8
0002F382  6a0b8eb4                 loc_2F382 mov.b   @0xFFFF8EB4:16, r3l
0002F386  6a0c8eb6                 loc_2F386 mov.b   @0xFFFF8EB6:16, r4l
0002F38A  6a8b8eb6                          mov.b   r3l, @0xFFFF8EB6:16
0002F38E  1cbc                              cmp.b   r3l, r4l
0002F390  4742                              beq     loc_2F3D4:8
0002F392  6a0ca9f9                          mov.b   @0xFFFFA9F9:16, r4l
0002F396  472e                              beq     loc_2F3C6:8
0002F398  ac01                              cmp.b   #1, r4l
0002F39A  472a                              beq     loc_2F3C6:8
0002F39C  ac0a                              cmp.b   #0xA, r4l
0002F39E  4716                              beq     loc_2F3B6:8
0002F3A0  ac09                              cmp.b   #9, r4l
0002F3A2  4630                              bne     loc_2F3D4:8
0002F3A4  6a10b39f7320                      btst    #2, @0xFFFFB39F:16
0002F3AA  461a                              bne     loc_2F3C6:8
0002F3AC  6a10b39f7310                      btst    #1, @0xFFFFB39F:16
0002F3B2  4612                              bne     loc_2F3C6:8
0002F3B4  401e                              bra     loc_2F3D4:8
0002F3B6  6a10b4207300             loc_2F3B6 btst    #0, @0xFFFFB420:16
0002F3BC  4608                              bne     loc_2F3C6:8
0002F3BE  6a0cb3ea                          mov.b   @0xFFFFB3EA:16, r4l
0002F3C2  ac07                              cmp.b   #7, r4l
0002F3C4  460e                              bne     loc_2F3D4:8
0002F3C6  6a10ad697370             loc_2F3C6 btst    #7, @0xFFFFAD69:16
0002F3CC  4606                              bne     loc_2F3D4:8
0002F3CE  6a18817e7010                      bset    #1, @0xFFFF817E:16
0002F3D4  6a108ea07340             loc_2F3D4 btst    #4, @0xFFFF8EA0:16
0002F3DA  4722                              beq     locret_2F3FE:8
0002F3DC  6a108ea07360                      btst    #6, @0xFFFF8EA0:16
0002F3E2  471a                              beq     locret_2F3FE:8
0002F3E4  6a0c8dd5                          mov.b   @0xFFFF8DD5:16, r4l
0002F3E8  4714                              beq     locret_2F3FE:8
0002F3EA  01006b058126                      mov.l   @0xFFFF8126:16, er5
0002F3F0  6e5c008a                          mov.b   @(0x8A:16,er5), r4l
0002F3F4  4708                              beq     locret_2F3FE:8
0002F3F6  6a0c8eb6                          mov.b   @0xFFFF8EB6:16, r4l
0002F3FA  6a8c8ec5                          mov.b   r4l, @0xFFFF8EC5:16
0002F3FE  5470                     locret_2F3FE rts
0002F400  6b048174                 loc_2F400 mov.w   @0xFFFF8174:16, r4
0002F404  7964febf                          and.w   #0xFEBF, r4
0002F408  79240000                          cmp.w   #0, r4
0002F40C  58700098                          beq     locret_2F4A8:16
0002F410  01006df0                          push.l  er0
0002F414  01006b008122                      mov.l   @0xFFFF8122:16, er0
0002F41A  01006b80812a                      mov.l   er0, @0xFFFF812A:16

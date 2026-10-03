; ==== retune  00034538-00034800 ====
00034538  6a0c9551                 loc_34538 mov.b   @0xFFFF9551:16, r4l
0003453C  461e                              bne     loc_3455C:8
0003453E  fc08                              mov.b   #8, r4l
00034540  6a8c9551                          mov.b   r4l, @0xFFFF9551:16
00034544  fc01                              mov.b   #1, r4l
00034546  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
00034548  7fa07050                          bset    #5, @0xFFFFFFA0:8
0003454C  7ea07350                 loc_3454C btst    #5, @0xFFFFFFA0:8
00034550  46fa                              bne     loc_3454C:8
00034552  7fa07270                          bclr    #7, @0xFFFFFFA0:8
00034556  2c92                              mov.b   @0xFFFFFF92:8, r4l
00034558  6a8ca996                          mov.b   r4l, @0xFFFFA996:16
0003455C  fc00                     loc_3455C mov.b   #0, r4l
0003455E  6a8caad7                          mov.b   r4l, @0xFFFFAAD7:16
00034562  6a0aaacf                          mov.b   @0xFFFFAACF:16, r2l
00034566  587000cc                          beq     loc_34636:16
0003456A  aa04                              cmp.b   #4, r2l
0003456C  476a                              beq     loc_345D8:8
0003456E  aa07                              cmp.b   #7, r2l
00034570  4774                              beq     loc_345E6:8
00034572  aa08                              cmp.b   #8, r2l
00034574  58700084                          beq     loc_345FC:16
00034578  6a10aad37320                      btst    #2, @0xFFFFAAD3:16
0003457E  463c                              bne     loc_345BC:8
00034580  6a10aad37300                      btst    #0, @0xFFFFAAD3:16
00034586  4622                              bne     loc_345AA:8
00034588  6a10aad47370                      btst    #7, @0xFFFFAAD4:16
0003458E  4710                              beq     loc_345A0:8
00034590  6a18aad47270                      bclr    #7, @0xFFFFAAD4:16
00034596  fc0d                              mov.b   #0xD, r4l
00034598  6a8caad5                          mov.b   r4l, @0xFFFFAAD5:16
0003459C  58000096                          bra     loc_34636:16
000345A0  fc00                     loc_345A0 mov.b   #0, r4l
000345A2  6a8caad5                          mov.b   r4l, @0xFFFFAAD5:16
000345A6  5800008c                          bra     loc_34636:16
000345AA  6a0c8aa0                 loc_345AA mov.b   @0xFFFF8AA0:16, r4l
000345AE  ac01                              cmp.b   #1, r4l
000345B0  4600                              bne     loc_345B2:8
000345B2  6a0c8c52                 loc_345B2 mov.b   @0xFFFF8C52:16, r4l
000345B6  47e8                              beq     loc_345A0:8
000345B8  fc4d                              mov.b   #0x4D, r4l ; 'M'
000345BA  4010                              bra     loc_345CC:8
000345BC  6a0c8aa0                 loc_345BC mov.b   @0xFFFF8AA0:16, r4l
000345C0  ac01                              cmp.b   #1, r4l
000345C2  4600                              bne     loc_345C4:8
000345C4  6a0c8c53                 loc_345C4 mov.b   @0xFFFF8C53:16, r4l
000345C8  47d6                              beq     loc_345A0:8
000345CA  fc4e                              mov.b   #0x4E, r4l ; 'N'
000345CC  6a8caae0                 loc_345CC mov.b   r4l, @0xFFFFAAE0:16
000345D0  fc0d                              mov.b   #0xD, r4l
000345D2  6a8caad5                          mov.b   r4l, @0xFFFFAAD5:16
000345D6  405e                              bra     loc_34636:8
000345D8  6a0caad5                 loc_345D8 mov.b   @0xFFFFAAD5:16, r4l
000345DC  ac02                              cmp.b   #2, r4l
000345DE  4556                              bcs     loc_34636:8
000345E0  5e034b44                          jsr     sub_34B44:24
000345E4  4050                              bra     loc_34636:8
000345E6  6a0caad5                 loc_345E6 mov.b   @0xFFFFAAD5:16, r4l
000345EA  ac02                              cmp.b   #2, r4l
000345EC  4406                              bcc     loc_345F4:8
000345EE  5e034ff4                          jsr     sub_34FF4:24
000345F2  4058                              bra     loc_3464C:8
000345F4  fc05                     loc_345F4 mov.b   #5, r4l
000345F6  6a8caad5                          mov.b   r4l, @0xFFFFAAD5:16
000345FA  403a                              bra     loc_34636:8
000345FC  6a0caad5                 loc_345FC mov.b   @0xFFFFAAD5:16, r4l
00034600  ac02                              cmp.b   #2, r4l
00034602  4406                              bcc     loc_3460A:8
00034604  5e034ff4                 loc_34604 jsr     sub_34FF4:24
00034608  4042                              bra     loc_3464C:8
0003460A  ac13                     loc_3460A cmp.b   #0x13, r4l
0003460C  4728                              beq     loc_34636:8
0003460E  6a10aad47300                      btst    #0, @0xFFFFAAD4:16
00034614  4620                              bne     loc_34636:8
00034616  6a18b0bb7200                      bclr    #0, @0xFFFFB0BB:16
0003461C  6a18b0bb7010                      bset    #1, @0xFFFFB0BB:16
00034622  6a0caad5                          mov.b   @0xFFFFAAD5:16, r4l
00034626  ac14                              cmp.b   #0x14, r4l
00034628  47da                              beq     loc_34604:8
0003462A  fc11                              mov.b   #0x11, r4l
0003462C  6a8caad5                          mov.b   r4l, @0xFFFFAAD5:16
00034630  fc64                              mov.b   #0x64, r4l ; 'd'
00034632  6a8c9553                          mov.b   r4l, @0xFFFF9553:16
00034636  6a0baad5                 loc_34636 mov.b   @0xFFFFAAD5:16, r3l
0003463A  7a63000000ff                      and.l   #0xFF, er3
00034640  1073                              shll.l  #2, er3
00034642  78                                .byte 0x78 ; x
00034643  b06b                              subx    #0x6B, r0h ; 'k'
00034645  2600                     loc_34645 mov.b   @0xFFFFFF00:8, r6h
00034647  03                                .byte    3
00034648  4674                              bne     loc_346BE:8
0003464A  5d60                              jsr     @er6
0003464C  fc00                     loc_3464C mov.b   #0, r4l
0003464E  6a8caacf                 loc_3464E mov.b   r4l, @0xFFFFAACF:16
00034652  6e0a0094                 loc_34652 mov.b   @(0x94:16,er0), r2l
00034656  4704                              beq     loc_3465C:8
00034658  5e0378a2                 loc_34658 jsr     sub_378A2:24
0003465C  6a0caad7                 loc_3465C mov.b   @0xFFFFAAD7:16, r4l
00034660  4710                              beq     locret_34672:8
00034662  fc00                              mov.b   #0, r4l
00034664  6a8caad7                          mov.b   r4l, @0xFFFFAAD7:16
00034668  6a0caad9                 loc_34668 mov.b   @0xFFFFAAD9:16, r4l
0003466C  4604                              bne     locret_34672:8
0003466E  5e035baa                          jsr     sub_35BAA:24
00034672  5470                     locret_34672 rts
00034674  00                       unk_34674 .byte    0
00034675  03                                .byte    3
00034676  46fa                              bne     locret_34672:8
00034678  00                                .byte    0
00034679  03                                .byte    3
0003467A  4966                              bvs     loc_346E2:8
0003467C  00                                .byte    0
0003467D  03                                .byte    3
0003467E  4cce                              bge     loc_3464E:8
00034680  00                                .byte    0
00034681  03                                .byte    3
00034682  4d42                     loc_34682 blt     unk_346C6:8
00034684  00                                .byte    0
00034685  03                                .byte    3
00034686  4d5c                              blt     loc_346E4:8
00034688  00                                .byte    0
00034689  03                                .byte    3
0003468A  4d66                              blt     loc_346F2:8
0003468C  00                       unk_3468C .byte    0
0003468D  03                                .byte    3
0003468E  4db6                              blt     loc_34645+1:8
00034690  00                                .byte    0
00034691  03                                .byte    3
00034692  4db8                              blt     loc_3464C:8
00034694  00                                .byte    0
00034695  03                                .byte    3
00034696  4dba                              blt     loc_34652:8
00034698  00                                .byte    0
00034699  03                                .byte    3
0003469A  4dbc                              blt     loc_34658:8
0003469C  00                                .byte    0
0003469D  03                                .byte    3
0003469E  4dbe                              blt     loc_3465C+2:8
000346A0  00                                .byte    0
000346A1  03                                .byte    3
000346A2  4db8                              blt     loc_3465C:8
000346A4  00                                .byte    0
000346A5  03                                .byte    3
000346A6  4dc0                              blt     loc_34668:8
000346A8  00                                .byte    0
000346A9  03                                .byte    3
000346AA  46c8                              bne     unk_34674:8
000346AC  00                                .byte    0
000346AD  03                                .byte    3
000346AE  46d2                              bne     loc_34682:8
000346B0  00                                .byte    0
000346B1  03                                .byte    3
000346B2  46d8                              bne     unk_3468C:8
000346B4  00                                .byte    0
000346B5  03                                .byte    3
000346B6  5a040003                          jmp     unk_40003:24
000346BA  5a8c0003                          jmp     0x8C0003:24
000346BE  5abe0003                 loc_346BE jmp     0xBE0003:24
000346C2  5b4a                              jmp     @@off_48+2:8
000346C4  00                                .byte    0
000346C5  03                                .byte    3
000346C6  59                       unk_346C6 .byte 0x59 ; Y
000346C7  ea55                              and.b   #0x55, r2l
000346C9  3cfc                              mov.b   r4l, @0xFFFFFFFC:8
000346CB  0e6a                              addx    r6h, r2l
000346CD  8caa                              add.b   #0xAA, r4l
000346CF  d554                              xor.b   #0x54, r5h
000346D1  706a                              bset    #6, r2l
000346D3  0caa                              mov.b   r2l, r2l
000346D5  e846                              and.b   #0x46, r0l
000346D7  045e                              orc     #0x5E, ccr ; '^'
000346D9  03                                .byte    3
000346DA  4782                              beq     loc_3465C+2:8
000346DC  5470                              rts
000346DE  6a0caad5                          mov.b   @0xFFFFAAD5:16, r4l
000346E2  ac0e                     loc_346E2 cmp.b   #0xE, r4l
000346E4  460e                     loc_346E4 bne     loc_346F4:8
000346E6  fcff                              mov.b   #0xFF, r4l
000346E8  6a8caae0                          mov.b   r4l, @0xFFFFAAE0:16
000346EC  fc0f                              mov.b   #0xF, r4l
000346EE  6a8caad5                          mov.b   r4l, @0xFFFFAAD5:16
000346F2  4004                     loc_346F2 bra     locret_346F8:8
000346F4  5e03ffa0                 loc_346F4 jsr     sub_3FFA0:24
000346F8  5470                     locret_346F8 rts
000346FA  0caa                              mov.b   r2l, r2l
000346FC  4706                              beq     locret_34704:8
000346FE  5506                              bsr     sub_34706:8
00034700  5e034782                          jsr     sub_34782:24
00034704  5470                     locret_34704 rts
00034706  5e02f550                 sub_34706 jsr     sub_2F550:24  ; <<< FUNC sub_34706
0003470A  5e030f00                          jsr     sub_30F00:24
0003470E  5e0330f0                          jsr     sub_330F0:24
00034712  6a18aad17210                      bclr    #1, @0xFFFFAAD1:16
00034718  6a0c8dde                          mov.b   @0xFFFF8DDE:16, r4l
0003471C  4a08                              bpl     loc_34726:8
0003471E  6a10b3d67320                      btst    #2, @0xFFFFB3D6:16
00034724  4604                              bne     loc_3472A:8
00034726  5e030a0c                 loc_34726 jsr     sub_30A0C:24
0003472A  fc02                     loc_3472A mov.b   #2, r4l
0003472C  6a8cb0c6                          mov.b   r4l, @0xFFFFB0C6:16
00034730  fc00                              mov.b   #0, r4l
00034732  6a8cb111                          mov.b   r4l, @0xFFFFB111:16
00034736  6a8cb113                          mov.b   r4l, @0xFFFFB113:16
0003473A  6a18b0bb7200                      bclr    #0, @0xFFFFB0BB:16
00034740  6a18b0bb7210                      bclr    #1, @0xFFFFB0BB:16
00034746  5e039080                          jsr     loc_39080:24
0003474A  fc00                              mov.b   #0, r4l
0003474C  6a8ca9a8                          mov.b   r4l, @0xFFFFA9A8:16
00034750  6a8caada                          mov.b   r4l, @0xFFFFAADA:16
00034754  6a8c9551                          mov.b   r4l, @0xFFFF9551:16
00034758  6a8c8f64                          mov.b   r4l, @0xFFFF8F64:16
0003475C  6a8c906c                          mov.b   r4l, @0xFFFF906C:16
00034760  6a8c9174                          mov.b   r4l, @0xFFFF9174:16
00034764  fc00                              mov.b   #0, r4l
00034766  6a8c8f73                          mov.b   r4l, @0xFFFF8F73:16
0003476A  6a8c907b                          mov.b   r4l, @0xFFFF907B:16
0003476E  fcff                              mov.b   #0xFF, r4l
00034770  6a8caad8                          mov.b   r4l, @0xFFFFAAD8:16
00034774  fc00                              mov.b   #0, r4l
00034776  6a8caad9                          mov.b   r4l, @0xFFFFAAD9:16
0003477A  fc00                              mov.b   #0, r4l
0003477C  6a8c955c                          mov.b   r4l, @0xFFFF955C:16
00034780  5470                              rts
00034782  fc00                     sub_34782 mov.b   #0, r4l  ; <<< FUNC sub_34782
00034784  6a8cbb95                          mov.b   r4l, @0xFFFFBB95:16
00034788  01006b05aaaa                      mov.l   @0xFFFFAAAA:16, er5
0003478E  7a0600ff92ce                      mov.l   #0xFF92CE, er6
00034794  5e03f5ee                          jsr     sub_3F5EE:24
00034798  4424                              bcc     loc_347BE:8
0003479A  01006b05aaaa                      mov.l   @0xFFFFAAAA:16, er5
000347A0  7a0600ff92d6                      mov.l   #0xFF92D6, er6
000347A6  5e03f5ee                          jsr     sub_3F5EE:24
000347AA  4562                              bcs     loc_3480E:8
000347AC  6a1881767200                      bclr    #0, @0xFFFF8176:16
000347B2  5e037a3a                          jsr     sub_37A3A:24
000347B6  7a0600035140                      mov.l   #unk_35140, er6
000347BC  4010                              bra     loc_347CE:8
000347BE  6a1881767000             loc_347BE bset    #0, @0xFFFF8176:16
000347C4  5e037a3a                          jsr     sub_37A3A:24
000347C8  7a060003510a                      mov.l   #unk_3510A, er6
000347CE  01006b05aaaa             loc_347CE mov.l   @0xFFFFAAAA:16, er5
000347D4  5e03f5b2                          jsr     sub_3F5B2:24
000347D8  6a8baad0                          mov.b   r3l, @0xFFFFAAD0:16
000347DC  6a0c8dde                          mov.b   @0xFFFF8DDE:16, r4l
000347E0  4a10                              bpl     loc_347F2:8
000347E2  6a108de07370                      btst    #7, @0xFFFF8DE0:16
000347E8  462c                              bne     loc_34816:8
000347EA  6a10b3d97320                      btst    #2, @0xFFFFB3D9:16
000347F0  4624                              bne     loc_34816:8
000347F2  5544                     loc_347F2 bsr     sub_34838:8
000347F4  5576                              bsr     sub_3486C:8
000347F6  fc04                              mov.b   #4, r4l
000347F8  6a8c9568                          mov.b   r4l, @0xFFFF9568:16
000347FC  6e0c008f                          mov.b   @(0x8F:16,er0), r4l

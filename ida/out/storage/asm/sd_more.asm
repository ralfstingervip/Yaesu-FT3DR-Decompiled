; ==== sd_more  FFF33C80-FFF34400  (file 333C80-334400) ====
FFF33C80  82a8                              mov.b   sp, 0Bh[r2]
FFF33C82  8961                              mov.b   4[r6], r1
FFF33C84  11                                beq.s   loc_FFF33C8D
FFF33C85  a82a                              mov.l   4[r2], r2
FFF33C87  2111                              bne.b   loc_FFF33C98
FFF33C89  a881                              mov.l   10h+var_8[sp], r1
FFF33C8B  ec1e                              mov.l   [r1], r14
FFF33C8D  dee16201               loc_FFF33C8D mov.w   2C4h[r14], r1
FFF33C91  ec2e                              mov.l   [r2], r14
FFF33C93  7f1e                              jsr     r14
FFF33C95  e301                              mov.l   r1, 10h+var_10[sp]
FFF33C97  08                                bra.s   loc_FFF33C9F
FFF33C98  a829                   loc_FFF33C98 mov.l   4[r2], r1
FFF33C9A  7f11                              jsr     r1
FFF33C9C  f80600                 sub_FFF33C9C mov.l   #0, 0[sp]   ; <<<< FUNC sub_FFF33C9C
FFF33C9F  ec01                   loc_FFF33C9F mov.l   10h+var_10[sp], r1
FFF33CA1  a009                              mov.l   r1, 10h+var_C[sp]
FFF33CA3  6704                              rtsd    #4
FFF33CA5  7100ec                 sub_FFF33CA5 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF33CA5
FFF33CA8  a101                              mov.l   r1, 14h+var_4[sp]
FFF33CAA  ec1e                              mov.l   [r1], r14
FFF33CAC  fae5560100                        mov.w   #0, 2ACh[r14]
FFF33CB1  a902                              mov.l   14h+var_4[sp], r2
FFF33CB3  ec2e                              mov.l   [r2], r14
FFF33CB5  5ee15601                          movu.w  2ACh[r14], r1
FFF33CB9  a82a                              mov.l   4[r2], r2
FFF33CBB  aaaa                              mov.l   2Ch[r2], r2
FFF33CBD  7f12                              jsr     r2
FFF33CBF  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF33CC2  2e20                              bra.b   loc_FFF33CE2
FFF33CC4  a901                   loc_FFF33CC4 mov.l   14h+var_4[sp], r1
FFF33CC6  ec14                              mov.l   [r1], r4
FFF33CC8  a819                              mov.l   4[r1], r1
FFF33CCA  ac95                              mov.l   48h[r1], r5
FFF33CCC  6601                              mov.l   #0, r1
FFF33CCE  ef12                              mov.l   r1, r2
FFF33CD0  ef13                              mov.l   r1, r3
FFF33CD2  7f15                              jsr     r5
FFF33CD4  a081                              mov.l   r1, 14h+var_C[sp]
FFF33CD6  a881                              mov.l   14h+var_C[sp], r1
FFF33CD8  6101                              cmp     #0, r1
FFF33CDA  200e                              beq.b   loc_FFF33CE8
FFF33CDC  a809                              mov.l   14h+var_10[sp], r1
FFF33CDE  6211                              add     #1, r1
FFF33CE0  a009                              mov.l   r1, 14h+var_10[sp]
FFF33CE2  a809                   loc_FFF33CE2 mov.l   14h+var_10[sp], r1
FFF33CE4  6131                              cmp     #3, r1
FFF33CE6  29de                              blt.b   loc_FFF33CC4
FFF33CE8  a809                   loc_FFF33CE8 mov.l   14h+var_10[sp], r1
FFF33CEA  6131                              cmp     #3, r1
FFF33CEC  2906                              blt.b   loc_FFF33CF2
FFF33CEE  f806f7                            mov.l   #-9, 14h+var_14[sp]
FFF33CF1  0c                                bra.s   loc_FFF33CF5
FFF33CF2  f80600                 loc_FFF33CF2 mov.l   #0, 14h+var_14[sp]
FFF33CF5  ec01                   loc_FFF33CF5 mov.l   14h+var_14[sp], r1
FFF33CF7  a089                              mov.l   r1, 14h+var_8[sp]
FFF33CF9  6705                              rtsd    #5
FFF33CFB  7100e4                 sub_FFF33CFB add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF33CFB
FFF33CFE  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF33D00  3e0400                            mov.l   #0, 1Ch+var_C[sp]
FFF33D03  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF33D06  38e100                            bra.w   loc_FFF33DE7
FFF33D09  a981                   loc_FFF33D09 mov.l   1Ch+var_4[sp], r1
FFF33D0B  ec14                              mov.l   [r1], r4
FFF33D0D  a819                              mov.l   4[r1], r1
FFF33D0F  ac95                              mov.l   48h[r1], r5
FFF33D11  6602                              mov.l   #0, r2
FFF33D13  754137                            mov.l   #37h, r1 ; '7'
FFF33D16  ef23                              mov.l   r2, r3
FFF33D18  7f15                              jsr     r5
FFF33D1A  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF33D1C  a881                              mov.l   1Ch+var_14[sp], r1
FFF33D1E  6101                              cmp     #0, r1
FFF33D20  207b                              beq.b   loc_FFF33D9B
FFF33D22  3e0300                            mov.l   #0, 1Ch+var_10[sp]
FFF33D25  2e69                              bra.b   loc_FFF33D8E
FFF33D27  a981                   loc_FFF33D27 mov.l   1Ch+var_4[sp], r1
FFF33D29  ec14                              mov.l   [r1], r4
FFF33D2B  a819                              mov.l   4[r1], r1
FFF33D2D  ac95                              mov.l   48h[r1], r5
FFF33D2F  fb320080ff00                      mov.l   #0FF8000h, r3
FFF33D35  6602                              mov.l   #0, r2
FFF33D37  6611                              mov.l   #1, r1
FFF33D39  7f15                              jsr     r5
FFF33D3B  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF33D3D  a881                              mov.l   1Ch+var_14[sp], r1
FFF33D3F  6101                              cmp     #0, r1
FFF33D41  17                                beq.s   loc_FFF33D48
FFF33D42  f806f7                            mov.l   #-9, 1Ch+var_1C[sp]
FFF33D45  382a01                            bra.w   loc_FFF33E6F
FFF33D48  a981                   loc_FFF33D48 mov.l   1Ch+var_4[sp], r1
FFF33D4A  ec12                              mov.l   [r1], r2
FFF33D4C  a819                              mov.l   4[r1], r1
FFF33D4E  ac9b                              mov.l   4Ch[r1], r3
FFF33D50  6631                              mov.l   #3, r1
FFF33D52  7f13                              jsr     r3
FFF33D54  a981                              mov.l   1Ch+var_4[sp], r1
FFF33D56  ec1e                              mov.l   [r1], r14
FFF33D58  edeeac                            mov.l   2B0h[r14], r14
FFF33D5B  742e00000080                      and     #80000000h, r14
FFF33D61  740e00000080                      cmp     #80000000h, r14
FFF33D67  211b                              bne.b   loc_FFF33D82
FFF33D69  a981                              mov.l   1Ch+var_4[sp], r1
FFF33D6B  ec1e                              mov.l   [r1], r14
FFF33D6D  fae96201ffff                      mov.w   #-1, 2C4h[r14]
FFF33D73  a981                              mov.l   1Ch+var_4[sp], r1
FFF33D75  ec1e                              mov.l   [r1], r14
FFF33D77  fae5630101                        mov.w   #1, 2C6h[r14]
FFF33D7C  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF33D7F  38f000                            bra.w   loc_FFF33E6F
FFF33D82  a889                   loc_FFF33D82 mov.l   1Ch+var_10[sp], r1
FFF33D84  6211                              add     #1, r1
FFF33D86  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF33D88  66a1                              mov.l   #0Ah, r1
FFF33D8A  05adeeff                          bsr.a   sub_FFF32C37
FFF33D8E  a889                   loc_FFF33D8E mov.l   1Ch+var_10[sp], r1
FFF33D90  755164                            cmp     #64h, r1 ; 'd'
FFF33D93  2394                              bltu.b  loc_FFF33D27
FFF33D95  f806ff                            mov.l   #-1, 1Ch+var_1C[sp]
FFF33D98  38d700                            bra.w   loc_FFF33E6F
FFF33D9B  a981                   loc_FFF33D9B mov.l   1Ch+var_4[sp], r1
FFF33D9D  ec12                              mov.l   [r1], r2
FFF33D9F  a819                              mov.l   4[r1], r1
FFF33DA1  ac9b                              mov.l   4Ch[r1], r3
FFF33DA3  6611                              mov.l   #1, r1
FFF33DA5  7f13                              jsr     r3
FFF33DA7  a981                              mov.l   1Ch+var_4[sp], r1
FFF33DA9  ec14                              mov.l   [r1], r4
FFF33DAB  a819                              mov.l   4[r1], r1
FFF33DAD  ac95                              mov.l   48h[r1], r5
FFF33DAF  6603                              mov.l   #0, r3
FFF33DB1  6612                              mov.l   #1, r2
FFF33DB3  754129                            mov.l   #29h, r1 ; ')'
FFF33DB6  7f15                              jsr     r5
FFF33DB8  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF33DBA  a881                              mov.l   1Ch+var_14[sp], r1
FFF33DBC  6101                              cmp     #0, r1
FFF33DBE  2123                              bne.b   loc_FFF33DE1
FFF33DC0  a981                              mov.l   1Ch+var_4[sp], r1
FFF33DC2  ec12                              mov.l   [r1], r2
FFF33DC4  a819                              mov.l   4[r1], r1
FFF33DC6  ac9b                              mov.l   4Ch[r1], r3
FFF33DC8  6631                              mov.l   #3, r1
FFF33DCA  7f13                              jsr     r3
FFF33DCC  a981                              mov.l   1Ch+var_4[sp], r1
FFF33DCE  ec1e                              mov.l   [r1], r14
FFF33DD0  ede1ac                            mov.l   2B0h[r14], r1
FFF33DD3  74210080ff00                      and     #0FF8000h, r1
FFF33DD9  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF33DDB  a901                              mov.l   1Ch+var_C[sp], r1
FFF33DDD  6101                              cmp     #0, r1
FFF33DDF  2111                              bne.b   loc_FFF33DF0
FFF33DE1  a809                   loc_FFF33DE1 mov.l   1Ch+var_18[sp], r1
FFF33DE3  6211                              add     #1, r1
FFF33DE5  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF33DE7  a809                   loc_FFF33DE7 mov.l   1Ch+var_18[sp], r1
FFF33DE9  6131                              cmp     #3, r1
FFF33DEB  2805                              bge.b   loc_FFF33DF0
FFF33DED  381cff                            bra.w   loc_FFF33D09
FFF33DF0  a809                   loc_FFF33DF0 mov.l   1Ch+var_18[sp], r1
FFF33DF2  6131                              cmp     #3, r1
FFF33DF4  2907                              blt.b   loc_FFF33DFB
FFF33DF6  f806ff                            mov.l   #-1, 1Ch+var_1C[sp]
FFF33DF9  2e76                              bra.b   loc_FFF33E6F
FFF33DFB  3e0300                 loc_FFF33DFB mov.l   #0, 1Ch+var_10[sp]
FFF33DFE  2e67                              bra.b   loc_FFF33E65
FFF33E00  a981                   loc_FFF33E00 mov.l   1Ch+var_4[sp], r1
FFF33E02  ec14                              mov.l   [r1], r4
FFF33E04  a819                              mov.l   4[r1], r1
FFF33E06  ac95                              mov.l   48h[r1], r5
FFF33E08  6602                              mov.l   #0, r2
FFF33E0A  754137                            mov.l   #37h, r1 ; '7'
FFF33E0D  ef23                              mov.l   r2, r3
FFF33E0F  7f15                              jsr     r5
FFF33E11  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF33E13  a881                              mov.l   1Ch+var_14[sp], r1
FFF33E15  6101                              cmp     #0, r1
FFF33E17  2142                              bne.b   loc_FFF33E59
FFF33E19  a981                              mov.l   1Ch+var_4[sp], r1
FFF33E1B  ec12                              mov.l   [r1], r2
FFF33E1D  a819                              mov.l   4[r1], r1
FFF33E1F  ac9b                              mov.l   4Ch[r1], r3
FFF33E21  6611                              mov.l   #1, r1
FFF33E23  7f13                              jsr     r3
FFF33E25  a981                              mov.l   1Ch+var_4[sp], r1
FFF33E27  ec14                              mov.l   [r1], r4
FFF33E29  a819                              mov.l   4[r1], r1
FFF33E2B  ac95                              mov.l   48h[r1], r5
FFF33E2D  a903                              mov.l   1Ch+var_C[sp], r3
FFF33E2F  6612                              mov.l   #1, r2
FFF33E31  754129                            mov.l   #29h, r1 ; ')'
FFF33E34  7f15                              jsr     r5
FFF33E36  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF33E38  a881                              mov.l   1Ch+var_14[sp], r1
FFF33E3A  6101                              cmp     #0, r1
FFF33E3C  211d                              bne.b   loc_FFF33E59
FFF33E3E  a981                              mov.l   1Ch+var_4[sp], r1
FFF33E40  ec12                              mov.l   [r1], r2
FFF33E42  a819                              mov.l   4[r1], r1
FFF33E44  ac9b                              mov.l   4Ch[r1], r3
FFF33E46  6631                              mov.l   #3, r1
FFF33E48  7f13                              jsr     r3
FFF33E4A  a981                              mov.l   1Ch+var_4[sp], r1
FFF33E4C  ec1e                              mov.l   [r1], r14
FFF33E4E  edeeac                            mov.l   2B0h[r14], r14
FFF33E51  7dfe                              btst    #1Fh, r14
FFF33E53  16                                beq.s   loc_FFF33E59
FFF33E54  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF33E57  2e18                              bra.b   loc_FFF33E6F
FFF33E59  a889                   loc_FFF33E59 mov.l   1Ch+var_10[sp], r1
FFF33E5B  6211                              add     #1, r1
FFF33E5D  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF33E5F  66a1                              mov.l   #0Ah, r1
FFF33E61  05d6edff                          bsr.a   sub_FFF32C37
FFF33E65  a889                   loc_FFF33E65 mov.l   1Ch+var_10[sp], r1
FFF33E67  755164                            cmp     #64h, r1 ; 'd'
FFF33E6A  2396                              bltu.b  loc_FFF33E00
FFF33E6C  f806ff                            mov.l   #-1, 1Ch+var_1C[sp]
FFF33E6F  ec01                   loc_FFF33E6F mov.l   1Ch+var_1C[sp], r1
FFF33E71  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF33E73  6707                              rtsd    #7
FFF33E75  7100e0                 sub_FFF33E75 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF33E75
FFF33E78  a189                              mov.l   r1, 20h+var_4[sp]
FFF33E7A  3e0500                            mov.l   #0, 20h+var_C[sp]
FFF33E7D  a989                              mov.l   20h+var_4[sp], r1
FFF33E7F  ec14                              mov.l   [r1], r4
FFF33E81  a819                              mov.l   4[r1], r1
FFF33E83  ac95                              mov.l   48h[r1], r5
FFF33E85  fb3aaa01                          mov.l   #1AAh, r3
FFF33E89  6602                              mov.l   #0, r2
FFF33E8B  6681                              mov.l   #8, r1
FFF33E8D  7f15                              jsr     r5
FFF33E8F  a089                              mov.l   r1, 20h+var_14[sp]
FFF33E91  a889                              mov.l   20h+var_14[sp], r1
FFF33E93  6101                              cmp     #0, r1
FFF33E95  10                                beq.s   loc_FFF33E9D
FFF33E96  f90601f7                          mov.l   #-9, 20h+var_1C[sp]
FFF33E9A  389a01                            bra.w   loc_FFF34034
FFF33E9D  a989                   loc_FFF33E9D mov.l   20h+var_4[sp], r1
FFF33E9F  ec12                              mov.l   [r1], r2
FFF33EA1  a819                              mov.l   4[r1], r1
FFF33EA3  ac9b                              mov.l   4Ch[r1], r3
FFF33EA5  6671                              mov.l   #7, r1
FFF33EA7  7f13                              jsr     r3
FFF33EA9  a989                              mov.l   20h+var_4[sp], r1
FFF33EAB  ec1e                              mov.l   [r1], r14
FFF33EAD  edeeac                            mov.l   2B0h[r14], r14
FFF33EB0  760eaa01                          cmp     #1AAh, r14
FFF33EB4  10                                beq.s   loc_FFF33EBC
FFF33EB5  f90601f7                          mov.l   #-9, 20h+var_1C[sp]
FFF33EB9  387b01                            bra.w   loc_FFF34034
FFF33EBC  a989                   loc_FFF33EBC mov.l   20h+var_4[sp], r1
FFF33EBE  ec14                              mov.l   [r1], r4
FFF33EC0  a819                              mov.l   4[r1], r1
FFF33EC2  ac95                              mov.l   48h[r1], r5
FFF33EC4  6602                              mov.l   #0, r2
FFF33EC6  6651                              mov.l   #5, r1
FFF33EC8  ef23                              mov.l   r2, r3
FFF33ECA  7f15                              jsr     r5
FFF33ECC  a089                              mov.l   r1, 20h+var_14[sp]
FFF33ECE  a889                              mov.l   20h+var_14[sp], r1
FFF33ED0  6101                              cmp     #0, r1
FFF33ED2  18                                bne.s   loc_FFF33EDA
FFF33ED3  f90601fb                          mov.l   #-5, 20h+var_1C[sp]
FFF33ED7  385d01                            bra.w   loc_FFF34034
FFF33EDA  3e0200                 loc_FFF33EDA mov.l   #0, 20h+var_18[sp]
FFF33EDD  2e67                              bra.b   loc_FFF33F44
FFF33EDF  a989                   loc_FFF33EDF mov.l   20h+var_4[sp], r1
FFF33EE1  ec14                              mov.l   [r1], r4
FFF33EE3  a819                              mov.l   4[r1], r1
FFF33EE5  ac95                              mov.l   48h[r1], r5
FFF33EE7  6602                              mov.l   #0, r2
FFF33EE9  754137                            mov.l   #37h, r1 ; '7'
FFF33EEC  ef23                              mov.l   r2, r3
FFF33EEE  7f15                              jsr     r5
FFF33EF0  a089                              mov.l   r1, 20h+var_14[sp]
FFF33EF2  a889                              mov.l   20h+var_14[sp], r1
FFF33EF4  6101                              cmp     #0, r1
FFF33EF6  2148                              bne.b   loc_FFF33F3E
FFF33EF8  a989                              mov.l   20h+var_4[sp], r1
FFF33EFA  ec12                              mov.l   [r1], r2
FFF33EFC  a819                              mov.l   4[r1], r1
FFF33EFE  ac9b                              mov.l   4Ch[r1], r3
FFF33F00  6611                              mov.l   #1, r1
FFF33F02  7f13                              jsr     r3
FFF33F04  a989                              mov.l   20h+var_4[sp], r1
FFF33F06  ec14                              mov.l   [r1], r4
FFF33F08  a819                              mov.l   4[r1], r1
FFF33F0A  ac95                              mov.l   48h[r1], r5
FFF33F0C  6603                              mov.l   #0, r3
FFF33F0E  6612                              mov.l   #1, r2
FFF33F10  754129                            mov.l   #29h, r1 ; ')'
FFF33F13  7f15                              jsr     r5
FFF33F15  a089                              mov.l   r1, 20h+var_14[sp]
FFF33F17  a889                              mov.l   20h+var_14[sp], r1
FFF33F19  6101                              cmp     #0, r1
FFF33F1B  2123                              bne.b   loc_FFF33F3E
FFF33F1D  a989                              mov.l   20h+var_4[sp], r1
FFF33F1F  ec12                              mov.l   [r1], r2
FFF33F21  a819                              mov.l   4[r1], r1
FFF33F23  ac9b                              mov.l   4Ch[r1], r3
FFF33F25  6631                              mov.l   #3, r1
FFF33F27  7f13                              jsr     r3
FFF33F29  a989                              mov.l   20h+var_4[sp], r1
FFF33F2B  ec1e                              mov.l   [r1], r14
FFF33F2D  ede1ac                            mov.l   2B0h[r14], r1
FFF33F30  74210080ff00                      and     #0FF8000h, r1
FFF33F36  a109                              mov.l   r1, 20h+var_C[sp]
FFF33F38  a909                              mov.l   20h+var_C[sp], r1
FFF33F3A  6101                              cmp     #0, r1
FFF33F3C  210e                              bne.b   loc_FFF33F4A
FFF33F3E  a881                   loc_FFF33F3E mov.l   20h+var_18[sp], r1
FFF33F40  6211                              add     #1, r1
FFF33F42  a081                              mov.l   r1, 20h+var_18[sp]
FFF33F44  a881                   loc_FFF33F44 mov.l   20h+var_18[sp], r1
FFF33F46  6131                              cmp     #3, r1
FFF33F48  2997                              blt.b   loc_FFF33EDF
FFF33F4A  a881                   loc_FFF33F4A mov.l   20h+var_18[sp], r1
FFF33F4C  6131                              cmp     #3, r1
FFF33F4E  2909                              blt.b   loc_FFF33F57
FFF33F50  f90601ff                          mov.l   #-1, 20h+var_1C[sp]
FFF33F54  38e000                            bra.w   loc_FFF34034
FFF33F57  3e0400                 loc_FFF33F57 mov.l   #0, 20h+var_10[sp]
FFF33F5A  38cc00                            bra.w   loc_FFF34026
FFF33F5D  a989                   loc_FFF33F5D mov.l   20h+var_4[sp], r1
FFF33F5F  a819                              mov.l   4[r1], r1
FFF33F61  a891                              mov.l   8[r1], r1
FFF33F63  7f11                              jsr     r1
FFF33F65  a089                              mov.l   r1, 20h+var_14[sp]
FFF33F67  a889                              mov.l   20h+var_14[sp], r1
FFF33F69  6101                              cmp     #0, r1
FFF33F6B  10                                beq.s   loc_FFF33F73
FFF33F6C  e5000301                          mov.l   20h+var_14[sp], 20h+var_1C[sp]
FFF33F70  38c400                            bra.w   loc_FFF34034
FFF33F73  a989                   loc_FFF33F73 mov.l   20h+var_4[sp], r1
FFF33F75  ec14                              mov.l   [r1], r4
FFF33F77  a819                              mov.l   4[r1], r1
FFF33F79  ac95                              mov.l   48h[r1], r5
FFF33F7B  6602                              mov.l   #0, r2
FFF33F7D  754137                            mov.l   #37h, r1 ; '7'
FFF33F80  ef23                              mov.l   r2, r3
FFF33F82  7f15                              jsr     r5
FFF33F84  a089                              mov.l   r1, 20h+var_14[sp]
FFF33F86  a889                              mov.l   20h+var_14[sp], r1
FFF33F88  6101                              cmp     #0, r1
FFF33F8A  3b9000                            bne.w   loc_FFF3401A
FFF33F8D  a989                              mov.l   20h+var_4[sp], r1
FFF33F8F  ec12                              mov.l   [r1], r2
FFF33F91  a819                              mov.l   4[r1], r1
FFF33F93  ac9b                              mov.l   4Ch[r1], r3
FFF33F95  6611                              mov.l   #1, r1
FFF33F97  7f13                              jsr     r3
FFF33F99  a989                              mov.l   20h+var_4[sp], r1
FFF33F9B  ec14                              mov.l   [r1], r4
FFF33F9D  a819                              mov.l   4[r1], r1
FFF33F9F  ac95                              mov.l   48h[r1], r5
FFF33FA1  a90b                              mov.l   20h+var_C[sp], r3
FFF33FA3  743300000041                      or      #41000000h, r3
FFF33FA9  6612                              mov.l   #1, r2
FFF33FAB  754129                            mov.l   #29h, r1 ; ')'
FFF33FAE  7f15                              jsr     r5
FFF33FB0  a089                              mov.l   r1, 20h+var_14[sp]
FFF33FB2  a889                              mov.l   20h+var_14[sp], r1
FFF33FB4  6101                              cmp     #0, r1
FFF33FB6  2164                              bne.b   loc_FFF3401A
FFF33FB8  a989                              mov.l   20h+var_4[sp], r1
FFF33FBA  ec12                              mov.l   [r1], r2
FFF33FBC  a819                              mov.l   4[r1], r1
FFF33FBE  ac9b                              mov.l   4Ch[r1], r3
FFF33FC0  6631                              mov.l   #3, r1
FFF33FC2  7f13                              jsr     r3
FFF33FC4  a989                              mov.l   20h+var_4[sp], r1
FFF33FC6  ec1e                              mov.l   [r1], r14
FFF33FC8  edeeac                            mov.l   2B0h[r14], r14
FFF33FCB  7dfe                              btst    #1Fh, r14
FFF33FCD  204d                              beq.b   loc_FFF3401A
FFF33FCF  a989                              mov.l   20h+var_4[sp], r1
FFF33FD1  ec1e                              mov.l   [r1], r14
FFF33FD3  edeeac                            mov.l   2B0h[r14], r14
FFF33FD6  7dee                              btst    #1Eh, r14
FFF33FD8  203d                              beq.b   loc_FFF34015
FFF33FDA  a989                              mov.l   20h+var_4[sp], r1
FFF33FDC  a819                              mov.l   4[r1], r1
FFF33FDE  a99a                              mov.l   1Ch[r1], r2
FFF33FE0  6601                              mov.l   #0, r1
FFF33FE2  7f12                              jsr     r2
FFF33FE4  a089                              mov.l   r1, 20h+var_14[sp]
FFF33FE6  a989                              mov.l   20h+var_4[sp], r1
FFF33FE8  ec1e                              mov.l   [r1], r14
FFF33FEA  edeeac                            mov.l   2B0h[r14], r14
FFF33FED  7d8e                              btst    #18h, r14
FFF33FEF  12                                beq.s   loc_FFF33FF9
FFF33FF0  a889                              mov.l   20h+var_14[sp], r1
FFF33FF2  6101                              cmp     #0, r1
FFF33FF4  1d                                bne.s   loc_FFF33FF9
FFF33FF5  f80601                            mov.l   #1, 20h+var_20[sp]
FFF33FF8  0c                                bra.s   loc_FFF33FFC
FFF33FF9  f80600                 loc_FFF33FF9 mov.l   #0, 20h+var_20[sp]
FFF33FFC  ec01                   loc_FFF33FFC mov.l   20h+var_20[sp], r1
FFF33FFE  6101                              cmp     #0, r1
FFF34000  2010                              beq.b   loc_FFF34010
FFF34002  a989                              mov.l   20h+var_4[sp], r1
FFF34004  ec1e                              mov.l   [r1], r14
FFF34006  deef6001                          mov.w   2C0h[r14], r15
FFF3400A  782f                              bset    #2, r15
FFF3400C  dbef6001                          mov.w   r15, 2C0h[r14]
FFF34010  3e0100                 loc_FFF34010 mov.l   #0, 20h+var_1C[sp]
FFF34013  2e21                              bra.b   loc_FFF34034
FFF34015  3e0101                 loc_FFF34015 mov.l   #1, 20h+var_1C[sp]
FFF34018  2e1c                              bra.b   loc_FFF34034
FFF3401A  a901                   loc_FFF3401A mov.l   20h+var_10[sp], r1
FFF3401C  6211                              add     #1, r1
FFF3401E  a101                              mov.l   r1, 20h+var_10[sp]
FFF34020  66a1                              mov.l   #0Ah, r1
FFF34022  0515ecff                          bsr.a   sub_FFF32C37
FFF34026  a901                   loc_FFF34026 mov.l   20h+var_10[sp], r1
FFF34028  755164                            cmp     #64h, r1 ; 'd'
FFF3402B  2205                              bgeu.b  loc_FFF34030
FFF3402D  3830ff                            bra.w   loc_FFF33F5D
FFF34030  f90601ff               loc_FFF34030 mov.l   #-1, 20h+var_1C[sp]
FFF34034  a809                   loc_FFF34034 mov.l   20h+var_1C[sp], r1
FFF34036  a181                              mov.l   r1, 20h+var_8[sp]
FFF34038  6708                              rtsd    #8
FFF3403A  7100ec                 sub_FFF3403A add     #-14h, sp, sp   ; <<<< FUNC sub_FFF3403A
FFF3403D  a101                              mov.l   r1, 14h+var_4[sp]
FFF3403F  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF34042  2e20                              bra.b   loc_FFF34062
FFF34044  a901                   loc_FFF34044 mov.l   14h+var_4[sp], r1
FFF34046  ec14                              mov.l   [r1], r4
FFF34048  a819                              mov.l   4[r1], r1
FFF3404A  ac95                              mov.l   48h[r1], r5
FFF3404C  6602                              mov.l   #0, r2
FFF3404E  66b1                              mov.l   #0Bh, r1
FFF34050  ef23                              mov.l   r2, r3
FFF34052  7f15                              jsr     r5
FFF34054  a081                              mov.l   r1, 14h+var_C[sp]
FFF34056  a881                              mov.l   14h+var_C[sp], r1
FFF34058  6101                              cmp     #0, r1
FFF3405A  200e                              beq.b   loc_FFF34068
FFF3405C  a809                              mov.l   14h+var_10[sp], r1
FFF3405E  6211                              add     #1, r1
FFF34060  a009                              mov.l   r1, 14h+var_10[sp]
FFF34062  a809                   loc_FFF34062 mov.l   14h+var_10[sp], r1
FFF34064  6131                              cmp     #3, r1
FFF34066  29de                              blt.b   loc_FFF34044
FFF34068  a809                   loc_FFF34068 mov.l   14h+var_10[sp], r1
FFF3406A  6131                              cmp     #3, r1
FFF3406C  2908                              blt.b   loc_FFF34074
FFF3406E  f806f7                            mov.l   #-9, 14h+var_14[sp]
FFF34071  389d00                            bra.w   loc_FFF3410E
FFF34074  a901                   loc_FFF34074 mov.l   14h+var_4[sp], r1
FFF34076  ec12                              mov.l   [r1], r2
FFF34078  a819                              mov.l   4[r1], r1
FFF3407A  ac9b                              mov.l   4Ch[r1], r3
FFF3407C  6611                              mov.l   #1, r1
FFF3407E  7f13                              jsr     r3
FFF34080  a901                              mov.l   14h+var_4[sp], r1
FFF34082  ec1e                              mov.l   [r1], r14
FFF34084  fbf20800c802                      mov.l   #2C80008h, r15
FFF3408A  06a10cefac                        tst     2B0h[r14].l, r15
FFF3408F  17                                beq.s   loc_FFF34096
FFF34090  f806e9                            mov.l   #-17h, 14h+var_14[sp]
FFF34093  387b00                            bra.w   loc_FFF3410E
FFF34096  a902                   loc_FFF34096 mov.l   14h+var_4[sp], r2
FFF34098  6601                              mov.l   #0, r1
FFF3409A  39e0fb                            bsr.w   sub_FFF33C7A
FFF3409D  a081                              mov.l   r1, 14h+var_C[sp]
FFF3409F  a881                              mov.l   14h+var_C[sp], r1
FFF340A1  6101                              cmp     #0, r1
FFF340A3  16                                beq.s   loc_FFF340A9
FFF340A4  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF340A7  2e67                              bra.b   loc_FFF3410E
FFF340A9  a901                   loc_FFF340A9 mov.l   14h+var_4[sp], r1
FFF340AB  a819                              mov.l   4[r1], r1
FFF340AD  a911                              mov.l   10h[r1], r1
FFF340AF  7f11                              jsr     r1
FFF340B1  a081                              mov.l   r1, 14h+var_C[sp]
FFF340B3  a881                              mov.l   14h+var_C[sp], r1
FFF340B5  6121                              cmp     #2, r1
FFF340B7  16                                beq.s   loc_FFF340BD
FFF340B8  f806f7                            mov.l   #-9, 14h+var_14[sp]
FFF340BB  2e53                              bra.b   loc_FFF3410E
FFF340BD  a901                   loc_FFF340BD mov.l   14h+var_4[sp], r1
FFF340BF  a819                              mov.l   4[r1], r1
FFF340C1  ab91                              mov.l   38h[r1], r1
FFF340C3  7f11                              jsr     r1
FFF340C5  66a1                              mov.l   #0Ah, r1
FFF340C7  0570ebff                          bsr.a   sub_FFF32C37
FFF340CB  a901                              mov.l   14h+var_4[sp], r1
FFF340CD  a819                              mov.l   4[r1], r1
FFF340CF  a919                              mov.l   14h[r1], r1
FFF340D1  7f11                              jsr     r1
FFF340D3  a081                              mov.l   r1, 14h+var_C[sp]
FFF340D5  a881                              mov.l   14h+var_C[sp], r1
FFF340D7  6101                              cmp     #0, r1
FFF340D9  16                                beq.s   loc_FFF340DF
FFF340DA  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF340DD  2e31                              bra.b   loc_FFF3410E
FFF340DF  a902                   loc_FFF340DF mov.l   14h+var_4[sp], r2
FFF340E1  6611                              mov.l   #1, r1
FFF340E3  3997fb                            bsr.w   sub_FFF33C7A
FFF340E6  a081                              mov.l   r1, 14h+var_C[sp]
FFF340E8  a881                              mov.l   14h+var_C[sp], r1
FFF340EA  6101                              cmp     #0, r1
FFF340EC  16                                beq.s   loc_FFF340F2
FFF340ED  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF340F0  2e1e                              bra.b   loc_FFF3410E
FFF340F2  66a1                   loc_FFF340F2 mov.l   #0Ah, r1
FFF340F4  0543ebff                          bsr.a   sub_FFF32C37
FFF340F8  a901                              mov.l   14h+var_4[sp], r1
FFF340FA  a819                              mov.l   4[r1], r1
FFF340FC  a911                              mov.l   10h[r1], r1
FFF340FE  7f11                              jsr     r1
FFF34100  a081                              mov.l   r1, 14h+var_C[sp]
FFF34102  a881                              mov.l   14h+var_C[sp], r1
FFF34104  6131                              cmp     #3, r1
FFF34106  15                                beq.s   loc_FFF3410B
FFF34107  f806f7                            mov.l   #-9, 14h+var_14[sp]
FFF3410A  0c                                bra.s   loc_FFF3410E
FFF3410B  f80600                 loc_FFF3410B mov.l   #0, 14h+var_14[sp]
FFF3410E  ec01                   loc_FFF3410E mov.l   14h+var_14[sp], r1
FFF34110  a089                              mov.l   r1, 14h+var_8[sp]
FFF34112  6705                              rtsd    #5
FFF34114  7100e8                 sub_FFF34114 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF34114
FFF34117  a109                              mov.l   r1, 18h+var_4[sp]
FFF34119  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF3411C  2e23                              bra.b   loc_FFF3413F
FFF3411E  a909                   loc_FFF3411E mov.l   18h+var_4[sp], r1
FFF34120  ec14                              mov.l   [r1], r4
FFF34122  a819                              mov.l   4[r1], r1
FFF34124  ac95                              mov.l   48h[r1], r5
FFF34126  6602                              mov.l   #0, r2
FFF34128  6621                              mov.l   #2, r1
FFF3412A  ef23                              mov.l   r2, r3
FFF3412C  7f15                              jsr     r5
FFF3412E  a089                              mov.l   r1, 18h+var_C[sp]
FFF34130  a889                              mov.l   18h+var_C[sp], r1
FFF34132  6101                              cmp     #0, r1
FFF34134  2011                              beq.b   loc_FFF34145
FFF34136  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF34139  a881                              mov.l   18h+var_10[sp], r1
FFF3413B  6211                              add     #1, r1
FFF3413D  a081                              mov.l   r1, 18h+var_10[sp]
FFF3413F  a881                   loc_FFF3413F mov.l   18h+var_10[sp], r1
FFF34141  6131                              cmp     #3, r1
FFF34143  29db                              blt.b   loc_FFF3411E
FFF34145  a881                   loc_FFF34145 mov.l   18h+var_10[sp], r1
FFF34147  6131                              cmp     #3, r1
FFF34149  2907                              blt.b   loc_FFF34150
FFF3414B  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF3414E  2e2f                              bra.b   loc_FFF3417D
FFF34150  a909                   loc_FFF34150 mov.l   18h+var_4[sp], r1
FFF34152  ec12                              mov.l   [r1], r2
FFF34154  a819                              mov.l   4[r1], r1
FFF34156  ac9b                              mov.l   4Ch[r1], r3
FFF34158  6621                              mov.l   #2, r1
FFF3415A  7f13                              jsr     r3
FFF3415C  3c0700                            mov.b   #0, 18h+var_11[sp]
FFF3415F  2e15                              bra.b   loc_FFF34174
FFF34161  a909                   loc_FFF34161 mov.l   18h+var_4[sp], r1
FFF34163  ec1e                              mov.l   [r1], r14
FFF34165  490e07                            add     18h+var_11[sp], r14
FFF34168  caeeb0021102                      mov.b   2B0h[r14], 211h[r14]
FFF3416E  b189                              movu.b  18h+var_11[sp], r1
FFF34170  6211                              add     #1, r1
FFF34172  8189                              mov.b   r1, 18h+var_11[sp]
FFF34174  b189                   loc_FFF34174 movu.b  18h+var_11[sp], r1
FFF34176  61f1                              cmp     #0Fh, r1
FFF34178  2be9                              ble.b   loc_FFF34161
FFF3417A  f80600                            mov.l   #0, 18h+var_18[sp]
FFF3417D  ec01                   loc_FFF3417D mov.l   18h+var_18[sp], r1
FFF3417F  a101                              mov.l   r1, 18h+var_8[sp]
FFF34181  6706                              rtsd    #6
FFF34183  7100e8                 sub_FFF34183 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF34183
FFF34186  a109                              mov.l   r1, 18h+var_4[sp]
FFF34188  ec1e                              mov.l   [r1], r14
FFF3418A  5eee6301                          movu.w  2C6h[r14], r14
FFF3418E  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF34191  611e                              cmp     #1, r14
FFF34193  2123                              bne.b   loc_FFF341B6
FFF34195  388900                            bra.w   loc_FFF3421E
FFF34198  a909                   loc_FFF34198 mov.l   18h+var_4[sp], r1
FFF3419A  ec14                              mov.l   [r1], r4
FFF3419C  a819                              mov.l   4[r1], r1
FFF3419E  ac95                              mov.l   48h[r1], r5
FFF341A0  6602                              mov.l   #0, r2
FFF341A2  6631                              mov.l   #3, r1
FFF341A4  ef23                              mov.l   r2, r3
FFF341A6  7f15                              jsr     r5
FFF341A8  a089                              mov.l   r1, 18h+var_C[sp]
FFF341AA  a889                              mov.l   18h+var_C[sp], r1
FFF341AC  6101                              cmp     #0, r1
FFF341AE  200e                              beq.b   loc_FFF341BC
FFF341B0  a881                              mov.l   18h+var_10[sp], r1
FFF341B2  6211                              add     #1, r1
FFF341B4  a081                              mov.l   r1, 18h+var_10[sp]
FFF341B6  a881                   loc_FFF341B6 mov.l   18h+var_10[sp], r1
FFF341B8  6131                              cmp     #3, r1
FFF341BA  29de                              blt.b   loc_FFF34198
FFF341BC  a881                   loc_FFF341BC mov.l   18h+var_10[sp], r1
FFF341BE  6131                              cmp     #3, r1
FFF341C0  2908                              blt.b   loc_FFF341C8
FFF341C2  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF341C5  38bf00                            bra.w   loc_FFF34284
FFF341C8  a909                   loc_FFF341C8 mov.l   18h+var_4[sp], r1
FFF341CA  ec12                              mov.l   [r1], r2
FFF341CC  a819                              mov.l   4[r1], r1
FFF341CE  ac9b                              mov.l   4Ch[r1], r3
FFF341D0  6661                              mov.l   #6, r1
FFF341D2  7f13                              jsr     r3
FFF341D4  a909                              mov.l   18h+var_4[sp], r1
FFF341D6  ec1e                              mov.l   [r1], r14
FFF341D8  edefac                            mov.l   2B0h[r14], r15
FFF341DB  690f                              shlr    #10h, r15
FFF341DD  dbef5501                          mov.w   r15, 2AAh[r14]
FFF341E1  a909                              mov.l   18h+var_4[sp], r1
FFF341E3  ec1e                              mov.l   [r1], r14
FFF341E5  d6e0580103                        mov.w   2B0h[r14], 18h+var_12[sp]
FFF341EA  fbee00e000                        mov.l   #0E000h, r14
FFF341EF  06e10c0e03                        tst     18h+var_12[sp].uw, r14
FFF341F4  3a8d00                            beq.w   loc_FFF34281
FFF341F7  f806f8                            mov.l   #-8, 18h+var_18[sp]
FFF341FA  388a00                            bra.w   loc_FFF34284
FFF341FD  a909                   loc_FFF341FD mov.l   18h+var_4[sp], r1
FFF341FF  ec14                              mov.l   [r1], r4
FFF34201  a819                              mov.l   4[r1], r1
FFF34203  ac95                              mov.l   48h[r1], r5
FFF34205  fb3e000001                        mov.l   #10000h, r3
FFF3420A  6602                              mov.l   #0, r2
FFF3420C  6631                              mov.l   #3, r1
FFF3420E  7f15                              jsr     r5
FFF34210  a089                              mov.l   r1, 18h+var_C[sp]
FFF34212  a889                              mov.l   18h+var_C[sp], r1
FFF34214  6101                              cmp     #0, r1
FFF34216  200e                              beq.b   loc_FFF34224
FFF34218  a881                              mov.l   18h+var_10[sp], r1
FFF3421A  6211                              add     #1, r1
FFF3421C  a081                              mov.l   r1, 18h+var_10[sp]
FFF3421E  a881                   loc_FFF3421E mov.l   18h+var_10[sp], r1
FFF34220  6131                              cmp     #3, r1
FFF34222  29db                              blt.b   loc_FFF341FD
FFF34224  a881                   loc_FFF34224 mov.l   18h+var_10[sp], r1
FFF34226  6131                              cmp     #3, r1
FFF34228  2907                              blt.b   loc_FFF3422F
FFF3422A  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF3422D  2e57                              bra.b   loc_FFF34284
FFF3422F  a909                   loc_FFF3422F mov.l   18h+var_4[sp], r1
FFF34231  ec12                              mov.l   [r1], r2
FFF34233  a819                              mov.l   4[r1], r1
FFF34235  ac9b                              mov.l   4Ch[r1], r3
FFF34237  6611                              mov.l   #1, r1
FFF34239  7f13                              jsr     r3
FFF3423B  a909                              mov.l   18h+var_4[sp], r1
FFF3423D  ec1e                              mov.l   [r1], r14
FFF3423F  fae5550101                        mov.w   #1, 2AAh[r14]
FFF34244  a909                              mov.l   18h+var_4[sp], r1
FFF34246  ec1e                              mov.l   [r1], r14
FFF34248  fbf20000d800                      mov.l   #0D80000h, r15
FFF3424E  06a10cefac                        tst     2B0h[r14].l, r15
FFF34253  202e                              beq.b   loc_FFF34281
FFF34255  a909                              mov.l   18h+var_4[sp], r1
FFF34257  ec1e                              mov.l   [r1], r14
FFF34259  edeeac                            mov.l   2B0h[r14], r14
FFF3425C  742e0000d800                      and     #0D80000h, r14
FFF34262  770e000040                        cmp     #400000h, r14
FFF34267  2116                              bne.b   loc_FFF3427D
FFF34269  a909                              mov.l   18h+var_4[sp], r1
FFF3426B  ec1e                              mov.l   [r1], r14
FFF3426D  edeeac                            mov.l   2B0h[r14], r14
FFF34270  762e001e                          and     #1E00h, r14
FFF34274  760e0004                          cmp     #400h, r14
FFF34278  1d                                bne.s   loc_FFF3427D
FFF34279  f80600                            mov.l   #0, 18h+var_18[sp]
FFF3427C  08                                bra.s   loc_FFF34284
FFF3427D  f806e9                 loc_FFF3427D mov.l   #-17h, 18h+var_18[sp]
FFF34280  0c                                bra.s   loc_FFF34284
FFF34281  f80600                 loc_FFF34281 mov.l   #0, 18h+var_18[sp]
FFF34284  ec01                   loc_FFF34284 mov.l   18h+var_18[sp], r1
FFF34286  a101                              mov.l   r1, 18h+var_8[sp]
FFF34288  6706                              rtsd    #6
FFF3428A  7100e8                 sub_FFF3428A add     #-18h, sp, sp   ; <<<< FUNC sub_FFF3428A
FFF3428D  a109                              mov.l   r1, 18h+var_4[sp]
FFF3428F  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF34292  2e24                              bra.b   loc_FFF342B6
FFF34294  a909                   loc_FFF34294 mov.l   18h+var_4[sp], r1
FFF34296  ec14                              mov.l   [r1], r4
FFF34298  de435501                          mov.w   2AAh[r4], r3
FFF3429C  a819                              mov.l   4[r1], r1
FFF3429E  ac95                              mov.l   48h[r1], r5
FFF342A0  6d03                              shll    #10h, r3
FFF342A2  6602                              mov.l   #0, r2
FFF342A4  6691                              mov.l   #9, r1
FFF342A6  7f15                              jsr     r5
FFF342A8  a089                              mov.l   r1, 18h+var_C[sp]
FFF342AA  a889                              mov.l   18h+var_C[sp], r1
FFF342AC  6101                              cmp     #0, r1
FFF342AE  200e                              beq.b   loc_FFF342BC
FFF342B0  a809                              mov.l   18h+var_14[sp], r1
FFF342B2  6211                              add     #1, r1
FFF342B4  a009                              mov.l   r1, 18h+var_14[sp]
FFF342B6  a809                   loc_FFF342B6 mov.l   18h+var_14[sp], r1
FFF342B8  6131                              cmp     #3, r1
FFF342BA  29da                              blt.b   loc_FFF34294
FFF342BC  a809                   loc_FFF342BC mov.l   18h+var_14[sp], r1
FFF342BE  6131                              cmp     #3, r1
FFF342C0  2907                              blt.b   loc_FFF342C7
FFF342C2  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF342C5  2e30                              bra.b   loc_FFF342F5
FFF342C7  a909                   loc_FFF342C7 mov.l   18h+var_4[sp], r1
FFF342C9  ec12                              mov.l   [r1], r2
FFF342CB  a819                              mov.l   4[r1], r1
FFF342CD  ac9b                              mov.l   4Ch[r1], r3
FFF342CF  6621                              mov.l   #2, r1
FFF342D1  7f13                              jsr     r3
FFF342D3  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF342D6  2e16                              bra.b   loc_FFF342EC
FFF342D8  a909                   loc_FFF342D8 mov.l   18h+var_4[sp], r1
FFF342DA  ec1e                              mov.l   [r1], r14
FFF342DC  06890e02                          add     18h+var_10[sp].l, r14
FFF342E0  caeeb0020102                      mov.b   2B0h[r14], 201h[r14]
FFF342E6  a881                              mov.l   18h+var_10[sp], r1
FFF342E8  6211                              add     #1, r1
FFF342EA  a081                              mov.l   r1, 18h+var_10[sp]
FFF342EC  a881                   loc_FFF342EC mov.l   18h+var_10[sp], r1
FFF342EE  61f1                              cmp     #0Fh, r1
FFF342F0  2be8                              ble.b   loc_FFF342D8
FFF342F2  f80600                            mov.l   #0, 18h+var_18[sp]
FFF342F5  ec01                   loc_FFF342F5 mov.l   18h+var_18[sp], r1
FFF342F7  a101                              mov.l   r1, 18h+var_8[sp]
FFF342F9  6706                              rtsd    #6
FFF342FB  7100ec                 sub_FFF342FB add     #-14h, sp, sp   ; <<<< FUNC sub_FFF342FB
FFF342FE  a101                              mov.l   r1, 14h+var_4[sp]
FFF34300  3c0b00                            mov.b   #0, 14h+var_9[sp]
FFF34303  a901                              mov.l   14h+var_4[sp], r1
FFF34305  5811                              movu.b  [r1], r1
FFF34307  6861                              shlr    #6, r1
FFF34309  8289                              mov.b   r1, 14h+var_9[sp]
FFF3430B  b289                              movu.b  14h+var_9[sp], r1
FFF3430D  6101                              cmp     #0, r1
FFF3430F  12                                beq.s   loc_FFF34319
FFF34310  b289                              movu.b  14h+var_9[sp], r1
FFF34312  6111                              cmp     #1, r1
FFF34314  15                                beq.s   loc_FFF34319
FFF34315  f80601                            mov.l   #1, 14h+var_14[sp]
FFF34318  0c                                bra.s   loc_FFF3431C
FFF34319  f80600                 loc_FFF34319 mov.l   #0, 14h+var_14[sp]
FFF3431C  ec01                   loc_FFF3431C mov.l   14h+var_14[sp], r1
FFF3431E  6101                              cmp     #0, r1
FFF34320  10                                beq.s   loc_FFF34328
FFF34321  f90601fb                          mov.l   #-5, 14h+var_10[sp]
FFF34325  388f00                            bra.w   loc_FFF343B4
FFF34328  a901                   loc_FFF34328 mov.l   14h+var_4[sp], r1
FFF3432A  5811                              movu.b  [r1], r1
FFF3432C  75213c                            and     #3Ch, r1 ; '<'
FFF3432F  6821                              shlr    #2, r1
FFF34331  8289                              mov.b   r1, 14h+var_9[sp]
FFF34333  b289                              movu.b  14h+var_9[sp], r1
FFF34335  6101                              cmp     #0, r1
FFF34337  12                                beq.s   loc_FFF34341
FFF34338  b289                              movu.b  14h+var_9[sp], r1
FFF3433A  6111                              cmp     #1, r1
FFF3433C  15                                beq.s   loc_FFF34341
FFF3433D  f80601                            mov.l   #1, 14h+var_14[sp]
FFF34340  0c                                bra.s   loc_FFF34344
FFF34341  f80600                 loc_FFF34341 mov.l   #0, 14h+var_14[sp]
FFF34344  ec01                   loc_FFF34344 mov.l   14h+var_14[sp], r1
FFF34346  6101                              cmp     #0, r1
FFF34348  12                                beq.s   loc_FFF34352
FFF34349  b289                              movu.b  14h+var_9[sp], r1
FFF3434B  6121                              cmp     #2, r1
FFF3434D  15                                beq.s   loc_FFF34352
FFF3434E  f80601                            mov.l   #1, 14h+var_14[sp]
FFF34351  0c                                bra.s   loc_FFF34355
FFF34352  f80600                 loc_FFF34352 mov.l   #0, 14h+var_14[sp]
FFF34355  ec01                   loc_FFF34355 mov.l   14h+var_14[sp], r1
FFF34357  6101                              cmp     #0, r1
FFF34359  17                                beq.s   loc_FFF34360
FFF3435A  f90601fb                          mov.l   #-5, 14h+var_10[sp]
FFF3435E  2e56                              bra.b   loc_FFF343B4
FFF34360  754180                 loc_FFF34360 mov.l   #-80h, r1
FFF34363  a902                              mov.l   14h+var_4[sp], r2
FFF34365  512101                            and     1[r2], r1
FFF34368  8289                              mov.b   r1, 14h+var_9[sp]
FFF3436A  b289                              movu.b  14h+var_9[sp], r1
FFF3436C  6101                              cmp     #0, r1
FFF3436E  17                                beq.s   loc_FFF34375
FFF3436F  f90601fb                          mov.l   #-5, 14h+var_10[sp]
FFF34373  2e41                              bra.b   loc_FFF343B4
FFF34375  754180                 loc_FFF34375 mov.l   #-80h, r1
FFF34378  a902                              mov.l   14h+var_4[sp], r2
FFF3437A  512103                            and     3[r2], r1
FFF3437D  8289                              mov.b   r1, 14h+var_9[sp]
FFF3437F  b289                              movu.b  14h+var_9[sp], r1
FFF34381  6101                              cmp     #0, r1
FFF34383  17                                beq.s   loc_FFF3438A
FFF34384  f90601fb                          mov.l   #-5, 14h+var_10[sp]
FFF34388  2e2c                              bra.b   loc_FFF343B4
FFF3438A  a901                   loc_FFF3438A mov.l   14h+var_4[sp], r1
FFF3438C  b119                              movu.b  5[r1], r1
FFF3438E  64f1                              and     #0Fh, r1
FFF34390  8289                              mov.b   r1, 14h+var_9[sp]
FFF34392  b289                              movu.b  14h+var_9[sp], r1
FFF34394  61c1                              cmp     #0Ch, r1
FFF34396  2908                              blt.b   loc_FFF3439E
FFF34398  f90601fb                          mov.l   #-5, 14h+var_10[sp]
FFF3439C  2e18                              bra.b   loc_FFF343B4
FFF3439E  a901                   loc_FFF3439E mov.l   14h+var_4[sp], r1
FFF343A0  b391                              movu.b  0Eh[r1], r1
FFF343A2  6431                              and     #3, r1
FFF343A4  8289                              mov.b   r1, 14h+var_9[sp]
FFF343A6  b289                              movu.b  14h+var_9[sp], r1
FFF343A8  6121                              cmp     #2, r1
FFF343AA  2907                              blt.b   loc_FFF343B1
FFF343AC  f90601fb                          mov.l   #-5, 14h+var_10[sp]
FFF343B0  0c                                bra.s   loc_FFF343B4
FFF343B1  3e0100                 loc_FFF343B1 mov.l   #0, 14h+var_10[sp]
FFF343B4  a809                   loc_FFF343B4 mov.l   14h+var_10[sp], r1
FFF343B6  a089                              mov.l   r1, 14h+var_8[sp]
FFF343B8  6705                              rtsd    #5
FFF343BA  7100f0                 sub_FFF343BA add     #-10h, sp, sp   ; <<<< FUNC sub_FFF343BA
FFF343BD  a089                              mov.l   r1, 10h+var_4[sp]
FFF343BF  3c0700                            mov.b   #0, 10h+var_9[sp]
FFF343C2  a889                              mov.l   10h+var_4[sp], r1
FFF343C4  5811                              movu.b  [r1], r1
FFF343C6  6861                              shlr    #6, r1
FFF343C8  8189                              mov.b   r1, 10h+var_9[sp]
FFF343CA  b189                              movu.b  10h+var_9[sp], r1
FFF343CC  6141                              cmp     #4, r1
FFF343CE  2908                              blt.b   loc_FFF343D6
FFF343D0  f806fb                            mov.l   #-5, 10h+var_10[sp]
FFF343D3  387f00                            bra.w   loc_FFF34452
FFF343D6  a889                   loc_FFF343D6 mov.l   10h+var_4[sp], r1
FFF343D8  5811                              movu.b  [r1], r1
FFF343DA  75213c                            and     #3Ch, r1 ; '<'
FFF343DD  6821                              shlr    #2, r1
FFF343DF  8189                              mov.b   r1, 10h+var_9[sp]
FFF343E1  b189                              movu.b  10h+var_9[sp], r1
FFF343E3  6151                              cmp     #5, r1
FFF343E5  2907                              blt.b   loc_FFF343EC
FFF343E7  f806fb                            mov.l   #-5, 10h+var_10[sp]
FFF343EA  2e68                              bra.b   loc_FFF34452
FFF343EC  754180                 loc_FFF343EC mov.l   #-80h, r1
FFF343EF  a88a                              mov.l   10h+var_4[sp], r2
FFF343F1  512101                            and     1[r2], r1
FFF343F4  8189                              mov.b   r1, 10h+var_9[sp]
FFF343F6  b189                              movu.b  10h+var_9[sp], r1
FFF343F8  6101                              cmp     #0, r1
FFF343FA  16                                beq.s   loc_FFF34400
FFF343FB  f806fb                            mov.l   #-5, 10h+var_10[sp]
FFF343FE  2e54                              bra.b   loc_FFF34452

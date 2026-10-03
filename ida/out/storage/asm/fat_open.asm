; ==== fat_open  FFF22C80-FFF23900  (file 322C80-323900) ====
FFF22C80  f9062800                          mov.l   #0, 0D4h+var_34[sp]
FFF22C84  387507                            bra.w   loc_FFF233F9
FFF22C87  ad02                   loc_FFF22C87 mov.l   0D4h+var_84[sp], r2
FFF22C89  710374                            add     #0D4h+var_60, sp, r3
FFF22C8C  0584d7ff                          bsr.a   sub_FFF20410
FFF22C90  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF22C93  ed012b                            mov.l   0D4h+var_28[sp], r1
FFF22C96  6101                              cmp     #0, r1
FFF22C98  10                                beq.s   loc_FFF22CA0
FFF22C99  e5002b01                          mov.l   0D4h+var_28[sp], 0D4h+var_D0[sp]
FFF22C9D  386f07                            bra.w   loc_FFF2340C
FFF22CA0  e5001411               loc_FFF22CA0 mov.l   0D4h+var_84[sp], 0D4h+var_90[sp]
FFF22CA4  e5001d0c                          mov.l   0D4h+var_60[sp], 0D4h+var_A4[sp]
FFF22CA8  a981                              mov.l   0D4h+var_BC[sp], r1
FFF22CAA  6111                              cmp     #1, r1
FFF22CAC  2147                              bne.b   loc_FFF22CF3
FFF22CAE  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22CB1  ed0233                            mov.l   0D4h+var_8[sp], r2
FFF22CB4  0685120d                          cmp     34h[r1].l, r2
FFF22CB8  2038                              beq.b   loc_FFF22CF0
FFF22CBA  ab01                              mov.l   0D4h+var_A4[sp], r1
FFF22CBC  66b3                              mov.l   #0Bh, r3
FFF22CBE  71020d                            add     #0D4h+var_C7, sp, r2
FFF22CC1  056dbc00                          bsr.a   sub_FFF2E92E
FFF22CC5  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF22CC8  ed012b                            mov.l   0D4h+var_28[sp], r1
FFF22CCB  6101                              cmp     #0, r1
FFF22CCD  10                                beq.s   loc_FFF22CD5
FFF22CCE  f90601b9                          mov.l   #-47h, 0D4h+var_D0[sp]
FFF22CD2  383a07                            bra.w   loc_FFF2340C
FFF22CD5  ed0134                 loc_FFF22CD5 mov.l   0D4h+var_4[sp], r1
FFF22CD8  8c12                              mov.b   10h[r1], r2
FFF22CDA  ab01                              mov.l   0D4h+var_A4[sp], r1
FFF22CDC  05bcd9ff                          bsr.a   sub_FFF20698
FFF22CE0  a081                              mov.l   r1, 0D4h+var_CC[sp]
FFF22CE2  a881                              mov.l   0D4h+var_CC[sp], r1
FFF22CE4  06850133                          cmp     0D4h+var_8[sp].l, r1
FFF22CE8  10                                beq.s   loc_FFF22CF0
FFF22CE9  f90601b9                          mov.l   #-47h, 0D4h+var_D0[sp]
FFF22CED  381f07                            bra.w   loc_FFF2340C
FFF22CF0  3e0600                 loc_FFF22CF0 mov.l   #0, 0D4h+var_BC[sp]
FFF22CF3  f9062800               loc_FFF22CF3 mov.l   #0, 0D4h+var_34[sp]
FFF22CF7  382006                            bra.w   loc_FFF23317
FFF22CFA  ab01                   loc_FFF22CFA mov.l   0D4h+var_A4[sp], r1
FFF22CFC  581e                              movu.b  [r1], r14
FFF22CFE  610e                              cmp     #0, r14
FFF22D00  3bb003                            bne.w   loc_FFF230B0
FFF22D03  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF22D06  6101                              cmp     #0, r1
FFF22D08  17                                beq.s   loc_FFF22D0F
FFF22D09  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF22D0C  6121                              cmp     #2, r1
FFF22D0E  1d                                bne.s   loc_FFF22D13
FFF22D0F  f80601                 loc_FFF22D0F mov.l   #1, 0D4h+var_D4[sp]
FFF22D12  0c                                bra.s   loc_FFF22D16
FFF22D13  f80600                 loc_FFF22D13 mov.l   #0, 0D4h+var_D4[sp]
FFF22D16  ec01                   loc_FFF22D16 mov.l   0D4h+var_D4[sp], r1
FFF22D18  6101                              cmp     #0, r1
FFF22D1A  10                                beq.s   loc_FFF22D22
FFF22D1B  f90601fc                          mov.l   #-4, 0D4h+var_D0[sp]
FFF22D1F  38ed06                            bra.w   loc_FFF2340C
FFF22D22  dd0155                 loc_FFF22D22 mov.w   0D4h+var_2A[sp], r1
FFF22D25  6101                              cmp     #0, r1
FFF22D27  2605                              bpz.b   loc_FFF22D2C
FFF22D29  388400                            bra.w   loc_FFF22DAD
FFF22D2C  dd0155                 loc_FFF22D2C mov.w   0D4h+var_2A[sp], r1
FFF22D2F  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF22D32  db21100b                          mov.w   r1, 1620h[r2]
FFF22D36  dd012c                            mov.w   0D4h+var_7C[sp], r1
FFF22D39  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF22D3C  db21110b                          mov.w   r1, 1622h[r2]
FFF22D40  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF22D43  72112416                          add     #1624h, r1, r1
FFF22D47  66c3                              mov.l   #0Ch, r3
FFF22D49  710238                            add     #0D4h+var_9C, sp, r2
FFF22D4C  052cb700                          bsr.a   sub_FFF2E478
FFF22D50  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF22D53  6131                              cmp     #3, r1
FFF22D55  1f                                bne.s   loc_FFF22D5C
FFF22D56  3e0100                            mov.l   #0, 0D4h+var_D0[sp]
FFF22D59  38b306                            bra.w   loc_FFF2340C
FFF22D5C  ed0134                 loc_FFF22D5C mov.l   0D4h+var_4[sp], r1
FFF22D5F  ad99                              mov.l   5Ch[r1], r1
FFF22D61  6851                              shlr    #5, r1
FFF22D63  068d010b                          mul     0D4h+var_A8[sp].l, r1
FFF22D67  06490155                          add     0D4h+var_2A[sp].w, r1
FFF22D6B  a209                              mov.l   r1, 0D4h+var_B0[sp]
FFF22D6D  aa09                              mov.l   0D4h+var_B0[sp], r1
FFF22D6F  6683                              mov.l   #8, r3
FFF22D71  71025a                            add     #0D4h+var_7A, sp, r2
FFF22D74  39bf09                            bsr.w   sub_FFF23733
FFF22D77  ed0131                            mov.l   0D4h+var_10[sp], r1
FFF22D7A  66b3                              mov.l   #0Bh, r3
FFF22D7C  71025a                            add     #0D4h+var_7A, sp, r2
FFF22D7F  05f9b600                          bsr.a   sub_FFF2E478
FFF22D83  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF22D86  5d052c                            movu.w  0D4h+var_7C[sp], r5
FFF22D89  ed0431                            mov.l   0D4h+var_10[sp], r4
FFF22D8C  5d0355                            movu.w  0D4h+var_2A[sp], r3
FFF22D8F  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22D92  60c0                              sub     #0Ch, sp
FFF22D94  a00d                              mov.l   r5, 0E0h+var_DC[sp]
FFF22D96  a082                              mov.l   r2, 0E0h+var_D8[sp]
FFF22D98  72220c04                          add     #40Ch, r2, r2
FFF22D9C  e302                              mov.l   r2, 0E0h+var_E0[sp]
FFF22D9E  710244                            add     #0E0h+var_9C, sp, r2
FFF22DA1  0566f1ff                          bsr.a   sub_FFF21F07
FFF22DA5  62c0                              add     #0Ch, sp
FFF22DA7  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF22DAA  38f302                            bra.w   loc_FFF2309D
FFF22DAD  ed0134                 loc_FFF22DAD mov.l   0D4h+var_4[sp], r1
FFF22DB0  ad99                              mov.l   5Ch[r1], r1
FFF22DB2  6851                              shlr    #5, r1
FFF22DB4  5d022c                            movu.w  0D4h+var_7C[sp], r2
FFF22DB7  06890228                          add     0D4h+var_34[sp].l, r2
FFF22DBB  6012                              sub     #1, r2
FFF22DBD  06810224                          sub     0D4h+var_44[sp].l, r2
FFF22DC1  fc2712                            divu    r1, r2
FFF22DC4  e70226                            mov.l   r2, 0D4h+var_3C[sp]
FFF22DC7  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22DCA  ad99                              mov.l   5Ch[r1], r1
FFF22DCC  6851                              shlr    #5, r1
FFF22DCE  5d022c                            movu.w  0D4h+var_7C[sp], r2
FFF22DD1  06890228                          add     0D4h+var_34[sp].l, r2
FFF22DD5  6012                              sub     #1, r2
FFF22DD7  06810224                          sub     0D4h+var_44[sp].l, r2
FFF22DDB  ef2e                              mov.l   r2, r14
FFF22DDD  fc271e                            divu    r1, r14
FFF22DE0  4f1e                              mul     r1, r14
FFF22DE2  43e2                              sub     r14, r2
FFF22DE4  d70255                            mov.w   r2, 0D4h+var_2A[sp]
FFF22DE7  f9062700                          mov.l   #0, 0D4h+var_38[sp]
FFF22DEB  38e201                            bra.w   loc_FFF22FCD
FFF22DEE  ad01                   loc_FFF22DEE mov.l   0D4h+var_84[sp], r1
FFF22DF0  6211                              add     #1, r1
FFF22DF2  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF22DF4  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22DF7  b892                              movu.w  4[r1], r2
FFF22DF9  6112                              cmp     #1, r2
FFF22DFB  3b8700                            bne.w   loc_FFF22E82
FFF22DFE  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF22E01  ed0333                            mov.l   0D4h+var_8[sp], r3
FFF22E04  6080                              sub     #8, sp
FFF22E06  a00a                              mov.l   r2, 0DCh+var_D8[sp]
FFF22E08  f80472                            mov.b   #72h, 0DCh+var_DC[sp] ; 'r'
FFF22E0B  6604                              mov.l   #0, r4
FFF22E0D  71025c                            add     #0DCh+var_80, sp, r2
FFF22E10  051f1500                          bsr.a   sub_FFF2432F
FFF22E14  6280                              add     #8, sp
FFF22E16  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF22E19  ad09                              mov.l   0D4h+var_80[sp], r1
FFF22E1B  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF22E21  18                                bne.s   loc_FFF22E29
FFF22E22  f90601c3                          mov.l   #-3Dh, 0D4h+var_D0[sp]
FFF22E26  38e605                            bra.w   loc_FFF2340C
FFF22E29  ad09                   loc_FFF22E29 mov.l   0D4h+var_80[sp], r1
FFF22E2B  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF22E31  2310                              bltu.b  loc_FFF22E41
FFF22E33  ad09                              mov.l   0D4h+var_80[sp], r1
FFF22E35  7401ffffff0f                      cmp     #0FFFFFFFh, r1
FFF22E3B  2406                              bgtu.b  loc_FFF22E41
FFF22E3D  f80601                            mov.l   #1, 0D4h+var_D4[sp]
FFF22E40  0c                                bra.s   loc_FFF22E44
FFF22E41  f80600                 loc_FFF22E41 mov.l   #0, 0D4h+var_D4[sp]
FFF22E44  ec01                   loc_FFF22E44 mov.l   0D4h+var_D4[sp], r1
FFF22E46  6101                              cmp     #0, r1
FFF22E48  2012                              beq.b   loc_FFF22E5A
FFF22E4A  ed032d                            mov.l   0D4h+var_20[sp], r3
FFF22E4D  ed0233                            mov.l   0D4h+var_8[sp], r2
FFF22E50  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22E53  05c9e0ff                          bsr.a   sub_FFF20F1C
FFF22E57  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF22E59  0d                                bra.s   loc_FFF22E5E
FFF22E5A  e5001514               loc_FFF22E5A mov.l   0D4h+var_80[sp], 0D4h+var_84[sp]
FFF22E5E  e5001433               loc_FFF22E5E mov.l   0D4h+var_84[sp], 0D4h+var_8[sp]
FFF22E62  05772eff                          bsr.a   sub_FFF15CD9
FFF22E66  a201                              mov.l   r1, 0D4h+var_B4[sp]
FFF22E68  aa01                              mov.l   0D4h+var_B4[sp], r1
FFF22E6A  6101                              cmp     #0, r1
FFF22E6C  10                                beq.s   loc_FFF22E74
FFF22E6D  e5000801                          mov.l   0D4h+var_B4[sp], 0D4h+var_D0[sp]
FFF22E71  389b05                            bra.w   loc_FFF2340C
FFF22E74  ad02                   loc_FFF22E74 mov.l   0D4h+var_84[sp], r2
FFF22E76  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22E79  0533c1ff                          bsr.a   sub_FFF1EFAC
FFF22E7D  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF22E7F  383201                            bra.w   loc_FFF22FB1
FFF22E82  ed0234                 loc_FFF22E82 mov.l   0D4h+var_4[sp], r2
FFF22E85  b8a2                              movu.w  4[r2], r2
FFF22E87  6012                              sub     #1, r2
FFF22E89  06850229                          cmp     0D4h+var_30[sp].l, r2
FFF22E8D  fcdbe0                            sceq.l  r14
FFF22E90  b891                              movu.w  4[r1], r1
FFF22E92  6121                              cmp     #2, r1
FFF22E94  3b9200                            bne.w   loc_FFF22F26
FFF22E97  5bee                              movu.b  r14, r14
FFF22E99  610e                              cmp     #0, r14
FFF22E9B  3a1601                            beq.w   loc_FFF22FB1
FFF22E9E  ed0e2d                            mov.l   0D4h+var_20[sp], r14
FFF22EA1  ed0333                            mov.l   0D4h+var_8[sp], r3
FFF22EA4  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22EA7  6080                              sub     #8, sp
FFF22EA9  e70e01                            mov.l   r14, 0DCh+var_D8[sp]
FFF22EAC  f80472                            mov.b   #72h, 0DCh+var_DC[sp] ; 'r'
FFF22EAF  6604                              mov.l   #0, r4
FFF22EB1  71025c                            add     #0DCh+var_80, sp, r2
FFF22EB4  057b1400                          bsr.a   sub_FFF2432F
FFF22EB8  6280                              add     #8, sp
FFF22EBA  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF22EBD  ed0e15                            mov.l   0D4h+var_80[sp], r14
FFF22EC0  740ef7ffff0f                      cmp     #0FFFFFF7h, r14
FFF22EC6  18                                bne.s   loc_FFF22ECE
FFF22EC7  f90601c3                          mov.l   #-3Dh, 0D4h+var_D0[sp]
FFF22ECB  384105                            bra.w   loc_FFF2340C
FFF22ECE  ed0e15                 loc_FFF22ECE mov.l   0D4h+var_80[sp], r14
FFF22ED1  740ef8ffff0f                      cmp     #0FFFFFF8h, r14
FFF22ED7  2311                              bltu.b  loc_FFF22EE8
FFF22ED9  ed0e15                            mov.l   0D4h+var_80[sp], r14
FFF22EDC  740effffff0f                      cmp     #0FFFFFFFh, r14
FFF22EE2  2406                              bgtu.b  loc_FFF22EE8
FFF22EE4  f80601                            mov.l   #1, 0D4h+var_D4[sp]
FFF22EE7  0c                                bra.s   loc_FFF22EEB
FFF22EE8  f80600                 loc_FFF22EE8 mov.l   #0, 0D4h+var_D4[sp]
FFF22EEB  ec0e                   loc_FFF22EEB mov.l   0D4h+var_D4[sp], r14
FFF22EED  610e                              cmp     #0, r14
FFF22EEF  2012                              beq.b   loc_FFF22F01
FFF22EF1  ed032d                            mov.l   0D4h+var_20[sp], r3
FFF22EF4  ed0233                            mov.l   0D4h+var_8[sp], r2
FFF22EF7  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22EFA  0522e0ff                          bsr.a   sub_FFF20F1C
FFF22EFE  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF22F00  0d                                bra.s   loc_FFF22F05
FFF22F01  e5001514               loc_FFF22F01 mov.l   0D4h+var_80[sp], 0D4h+var_84[sp]
FFF22F05  05d42dff               loc_FFF22F05 bsr.a   sub_FFF15CD9
FFF22F09  a201                              mov.l   r1, 0D4h+var_B4[sp]
FFF22F0B  ed0e08                            mov.l   0D4h+var_B4[sp], r14
FFF22F0E  610e                              cmp     #0, r14
FFF22F10  10                                beq.s   loc_FFF22F18
FFF22F11  e5000801                          mov.l   0D4h+var_B4[sp], 0D4h+var_D0[sp]
FFF22F15  38f704                            bra.w   loc_FFF2340C
FFF22F18  ad02                   loc_FFF22F18 mov.l   0D4h+var_84[sp], r2
FFF22F1A  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22F1D  058fc0ff                          bsr.a   sub_FFF1EFAC
FFF22F21  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF22F23  388e00                            bra.w   loc_FFF22FB1
FFF22F26  5bee                   loc_FFF22F26 movu.b  r14, r14
FFF22F28  610e                              cmp     #0, r14
FFF22F2A  3a8700                            beq.w   loc_FFF22FB1
FFF22F2D  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF22F30  ed0333                            mov.l   0D4h+var_8[sp], r3
FFF22F33  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22F36  6080                              sub     #8, sp
FFF22F38  a00a                              mov.l   r2, 0DCh+var_D8[sp]
FFF22F3A  f80472                            mov.b   #72h, 0DCh+var_DC[sp] ; 'r'
FFF22F3D  6604                              mov.l   #0, r4
FFF22F3F  71025c                            add     #0DCh+var_80, sp, r2
FFF22F42  05ed1300                          bsr.a   sub_FFF2432F
FFF22F46  6280                              add     #8, sp
FFF22F48  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF22F4B  ad09                              mov.l   0D4h+var_80[sp], r1
FFF22F4D  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF22F53  18                                bne.s   loc_FFF22F5B
FFF22F54  f90601c3                          mov.l   #-3Dh, 0D4h+var_D0[sp]
FFF22F58  38b404                            bra.w   loc_FFF2340C
FFF22F5B  ad09                   loc_FFF22F5B mov.l   0D4h+var_80[sp], r1
FFF22F5D  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF22F63  2310                              bltu.b  loc_FFF22F73
FFF22F65  ad09                              mov.l   0D4h+var_80[sp], r1
FFF22F67  7401ffffff0f                      cmp     #0FFFFFFFh, r1
FFF22F6D  2406                              bgtu.b  loc_FFF22F73
FFF22F6F  f80601                            mov.l   #1, 0D4h+var_D4[sp]
FFF22F72  0c                                bra.s   loc_FFF22F76
FFF22F73  f80600                 loc_FFF22F73 mov.l   #0, 0D4h+var_D4[sp]
FFF22F76  ec01                   loc_FFF22F76 mov.l   0D4h+var_D4[sp], r1
FFF22F78  6101                              cmp     #0, r1
FFF22F7A  2012                              beq.b   loc_FFF22F8C
FFF22F7C  ed032d                            mov.l   0D4h+var_20[sp], r3
FFF22F7F  ed0233                            mov.l   0D4h+var_8[sp], r2
FFF22F82  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22F85  0597dfff                          bsr.a   sub_FFF20F1C
FFF22F89  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF22F8B  0d                                bra.s   loc_FFF22F90
FFF22F8C  e5001514               loc_FFF22F8C mov.l   0D4h+var_80[sp], 0D4h+var_84[sp]
FFF22F90  05492dff               loc_FFF22F90 bsr.a   sub_FFF15CD9
FFF22F94  a201                              mov.l   r1, 0D4h+var_B4[sp]
FFF22F96  aa01                              mov.l   0D4h+var_B4[sp], r1
FFF22F98  6101                              cmp     #0, r1
FFF22F9A  10                                beq.s   loc_FFF22FA2
FFF22F9B  e5000801                          mov.l   0D4h+var_B4[sp], 0D4h+var_D0[sp]
FFF22F9F  386d04                            bra.w   loc_FFF2340C
FFF22FA2  ad02                   loc_FFF22FA2 mov.l   0D4h+var_84[sp], r2
FFF22FA4  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22FA7  0505c0ff                          bsr.a   sub_FFF1EFAC
FFF22FAB  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF22FAD  f9062900                          mov.l   #0, 0D4h+var_30[sp]
FFF22FB1  e5001213               loc_FFF22FB1 mov.l   0D4h+var_8C[sp], 0D4h+var_88[sp]
FFF22FB5  e5001112                          mov.l   0D4h+var_90[sp], 0D4h+var_8C[sp]
FFF22FB9  e5001411                          mov.l   0D4h+var_84[sp], 0D4h+var_90[sp]
FFF22FBD  ed0129                            mov.l   0D4h+var_30[sp], r1
FFF22FC0  6211                              add     #1, r1
FFF22FC2  e70129                            mov.l   r1, 0D4h+var_30[sp]
FFF22FC5  ed0127                            mov.l   0D4h+var_38[sp], r1
FFF22FC8  6211                              add     #1, r1
FFF22FCA  e70127                            mov.l   r1, 0D4h+var_38[sp]
FFF22FCD  ed0127                 loc_FFF22FCD mov.l   0D4h+var_38[sp], r1
FFF22FD0  06850126                          cmp     0D4h+var_3C[sp].l, r1
FFF22FD4  2805                              bge.b   loc_FFF22FD9
FFF22FD6  3818fe                            bra.w   loc_FFF22DEE
FFF22FD9  ad01                   loc_FFF22FD9 mov.l   0D4h+var_84[sp], r1
FFF22FDB  ed022e                            mov.l   0D4h+var_1C[sp], r2
FFF22FDE  e321                              mov.l   r1, [r2]
FFF22FE0  dd0155                            mov.w   0D4h+var_2A[sp], r1
FFF22FE3  ed022f                            mov.l   0D4h+var_18[sp], r2
FFF22FE6  e321                              mov.l   r1, [r2]
FFF22FE8  dd0155                            mov.w   0D4h+var_2A[sp], r1
FFF22FEB  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF22FEE  db21100b                          mov.w   r1, 1620h[r2]
FFF22FF2  dd012c                            mov.w   0D4h+var_7C[sp], r1
FFF22FF5  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF22FF8  db21110b                          mov.w   r1, 1622h[r2]
FFF22FFC  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF22FFF  72112416                          add     #1624h, r1, r1
FFF23003  66c3                              mov.l   #0Ch, r3
FFF23005  710244                            add     #0D4h+var_90, sp, r2
FFF23008  0570b400                          bsr.a   sub_FFF2E478
FFF2300C  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF2300F  6131                              cmp     #3, r1
FFF23011  1f                                bne.s   loc_FFF23018
FFF23012  3e0100                            mov.l   #0, 0D4h+var_D0[sp]
FFF23015  38f703                            bra.w   loc_FFF2340C
FFF23018  ed0134                 loc_FFF23018 mov.l   0D4h+var_4[sp], r1
FFF2301B  ad99                              mov.l   5Ch[r1], r1
FFF2301D  6851                              shlr    #5, r1
FFF2301F  068d010a                          mul     0D4h+var_AC[sp].l, r1
FFF23023  a209                              mov.l   r1, 0D4h+var_B0[sp]
FFF23025  5d012c                            movu.w  0D4h+var_7C[sp], r1
FFF23028  06890128                          add     0D4h+var_34[sp].l, r1
FFF2302C  6011                              sub     #1, r1
FFF2302E  06810124                          sub     0D4h+var_44[sp].l, r1
FFF23032  06890109                          add     0D4h+var_B0[sp].l, r1
FFF23036  a209                              mov.l   r1, 0D4h+var_B0[sp]
FFF23038  aa09                              mov.l   0D4h+var_B0[sp], r1
FFF2303A  6683                              mov.l   #8, r3
FFF2303C  71025a                            add     #0D4h+var_7A, sp, r2
FFF2303F  39f406                            bsr.w   sub_FFF23733
FFF23042  ed0131                            mov.l   0D4h+var_10[sp], r1
FFF23045  66b3                              mov.l   #0Bh, r3
FFF23047  71025a                            add     #0D4h+var_7A, sp, r2
FFF2304A  052eb400                          bsr.a   sub_FFF2E478
FFF2304E  ed0125                            mov.l   0D4h+var_40[sp], r1
FFF23051  6111                              cmp     #1, r1
FFF23053  ed0431                            mov.l   0D4h+var_10[sp], r4
FFF23056  dd0255                            mov.w   0D4h+var_2A[sp], r2
FFF23059  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF2305C  2124                              bne.b   loc_FFF23080
FFF2305E  ed032d                            mov.l   0D4h+var_20[sp], r3
FFF23061  5d052c                            movu.w  0D4h+var_7C[sp], r5
FFF23064  60c0                              sub     #0Ch, sp
FFF23066  a00d                              mov.l   r5, 0E0h+var_DC[sp]
FFF23068  a083                              mov.l   r3, 0E0h+var_D8[sp]
FFF2306A  72330c04                          add     #40Ch, r3, r3
FFF2306E  e303                              mov.l   r3, 0E0h+var_E0[sp]
FFF23070  5f23                              movu.w  r2, r3
FFF23072  710250                            add     #0E0h+var_90, sp, r2
FFF23075  0592eeff                          bsr.a   sub_FFF21F07
FFF23079  62c0                              add     #0Ch, sp
FFF2307B  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF2307E  2e1f                              bra.b   loc_FFF2309D
FFF23080  ed032d                 loc_FFF23080 mov.l   0D4h+var_20[sp], r3
FFF23083  5d052c                            movu.w  0D4h+var_7C[sp], r5
FFF23086  60c0                              sub     #0Ch, sp
FFF23088  a083                              mov.l   r3, 0E0h+var_D8[sp]
FFF2308A  a00d                              mov.l   r5, 0E0h+var_DC[sp]
FFF2308C  f80600                            mov.l   #0, 0E0h+var_E0[sp]
FFF2308F  5f23                              movu.w  r2, r3
FFF23091  710250                            add     #0E0h+var_90, sp, r2
FFF23094  0573eeff                          bsr.a   sub_FFF21F07
FFF23098  62c0                              add     #0Ch, sp
FFF2309A  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF2309D  ed012b                 loc_FFF2309D mov.l   0D4h+var_28[sp], r1
FFF230A0  6101                              cmp     #0, r1
FFF230A2  10                                beq.s   loc_FFF230AA
FFF230A3  e5002b01                          mov.l   0D4h+var_28[sp], 0D4h+var_D0[sp]
FFF230A7  386503                            bra.w   loc_FFF2340C
FFF230AA  3e0100                 loc_FFF230AA mov.l   #0, 0D4h+var_D0[sp]
FFF230AD  385f03                            bra.w   loc_FFF2340C
FFF230B0  ab01                   loc_FFF230B0 mov.l   0D4h+var_A4[sp], r1
FFF230B2  581e                              movu.b  [r1], r14
FFF230B4  755ee5                            cmp     #-1Bh, r14
FFF230B7  211e                              bne.b   loc_FFF230D5
FFF230B9  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF230BC  6111                              cmp     #1, r1
FFF230BE  17                                beq.s   loc_FFF230C5
FFF230BF  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF230C2  6131                              cmp     #3, r1
FFF230C4  1d                                bne.s   loc_FFF230C9
FFF230C5  f80601                 loc_FFF230C5 mov.l   #1, 0D4h+var_D4[sp]
FFF230C8  0c                                bra.s   loc_FFF230CC
FFF230C9  f80600                 loc_FFF230C9 mov.l   #0, 0D4h+var_D4[sp]
FFF230CC  ec01                   loc_FFF230CC mov.l   0D4h+var_D4[sp], r1
FFF230CE  6101                              cmp     #0, r1
FFF230D0  15                                beq.s   loc_FFF230D5
FFF230D1  f80601                            mov.l   #1, 0D4h+var_D4[sp]
FFF230D4  0c                                bra.s   loc_FFF230D8
FFF230D5  f80600                 loc_FFF230D5 mov.l   #0, 0D4h+var_D4[sp]
FFF230D8  ec01                   loc_FFF230D8 mov.l   0D4h+var_D4[sp], r1
FFF230DA  6101                              cmp     #0, r1
FFF230DC  2047                              beq.b   loc_FFF23123
FFF230DE  ed0124                            mov.l   0D4h+var_44[sp], r1
FFF230E1  6211                              add     #1, r1
FFF230E3  5d022c                            movu.w  0D4h+var_7C[sp], r2
FFF230E6  4712                              cmp     r1, r2
FFF230E8  2130                              bne.b   loc_FFF23118
FFF230EA  dd0155                            mov.w   0D4h+var_2A[sp], r1
FFF230ED  69f1                              shlr    #1Fh, r1
FFF230EF  6101                              cmp     #0, r1
FFF230F1  2027                              beq.b   loc_FFF23118
FFF230F3  ed0128                            mov.l   0D4h+var_34[sp], r1
FFF230F6  d70155                            mov.w   r1, 0D4h+var_2A[sp]
FFF230F9  66c3                              mov.l   #0Ch, r3
FFF230FB  710244                            add     #0D4h+var_90, sp, r2
FFF230FE  710138                            add     #0D4h+var_9C, sp, r1
FFF23101  0577b300                          bsr.a   sub_FFF2E478
FFF23105  ad01                              mov.l   0D4h+var_84[sp], r1
FFF23107  ed022e                            mov.l   0D4h+var_1C[sp], r2
FFF2310A  e321                              mov.l   r1, [r2]
FFF2310C  dd0155                            mov.w   0D4h+var_2A[sp], r1
FFF2310F  ed022f                            mov.l   0D4h+var_18[sp], r2
FFF23112  e321                              mov.l   r1, [r2]
FFF23114  e5000a0b                          mov.l   0D4h+var_AC[sp], 0D4h+var_A8[sp]
FFF23118  ed0124                 loc_FFF23118 mov.l   0D4h+var_44[sp], r1
FFF2311B  6211                              add     #1, r1
FFF2311D  e70124                            mov.l   r1, 0D4h+var_44[sp]
FFF23120  38e801                            bra.w   loc_FFF23308
FFF23123  f9062400               loc_FFF23123 mov.l   #0, 0D4h+var_44[sp]
FFF23127  ab01                              mov.l   0D4h+var_A4[sp], r1
FFF23129  f5150b                            btst    #5, 0Bh[r1].b
FFF2312C  1f                                bne.s   loc_FFF23133
FFF2312D  ab01                              mov.l   0D4h+var_A4[sp], r1
FFF2312F  f5140b                            btst    #4, 0Bh[r1].b
FFF23132  15                                beq.s   loc_FFF23137
FFF23133  f80601                 loc_FFF23133 mov.l   #1, 0D4h+var_D4[sp]
FFF23136  0c                                bra.s   loc_FFF2313A
FFF23137  f80600                 loc_FFF23137 mov.l   #0, 0D4h+var_D4[sp]
FFF2313A  ec01                   loc_FFF2313A mov.l   0D4h+var_D4[sp], r1
FFF2313C  6101                              cmp     #0, r1
FFF2313E  201c                              beq.b   loc_FFF2315A
FFF23140  ed0122                            mov.l   0D4h+var_4C[sp], r1
FFF23143  6101                              cmp     #0, r1
FFF23145  1f                                bne.s   loc_FFF2314C
FFF23146  f9054701                          mov.w   #1, 0D4h+var_46[sp]
FFF2314A  2e53                              bra.b   loc_FFF2319D
FFF2314C  dd0147                 loc_FFF2314C mov.w   0D4h+var_46[sp], r1
FFF2314F  6211                              add     #1, r1
FFF23151  d70147                            mov.w   r1, 0D4h+var_46[sp]
FFF23154  f9062200                          mov.l   #0, 0D4h+var_4C[sp]
FFF23158  2e45                              bra.b   loc_FFF2319D
FFF2315A  ed0122                 loc_FFF2315A mov.l   0D4h+var_4C[sp], r1
FFF2315D  6101                              cmp     #0, r1
FFF2315F  fcdbe0                            sceq.l  r14
FFF23162  ab01                              mov.l   0D4h+var_A4[sp], r1
FFF23164  b299                              movu.b  0Bh[r1], r1
FFF23166  64f1                              and     #0Fh, r1
FFF23168  61f1                              cmp     #0Fh, r1
FFF2316A  211c                              bne.b   loc_FFF23186
FFF2316C  5bee                              movu.b  r14, r14
FFF2316E  610e                              cmp     #0, r14
FFF23170  200c                              beq.b   loc_FFF2317C
FFF23172  f9054701                          mov.w   #1, 0D4h+var_46[sp]
FFF23176  f9062201                          mov.l   #1, 0D4h+var_4C[sp]
FFF2317A  2e23                              bra.b   loc_FFF2319D
FFF2317C  dd0e47                 loc_FFF2317C mov.w   0D4h+var_46[sp], r14
FFF2317F  621e                              add     #1, r14
FFF23181  d70e47                            mov.w   r14, 0D4h+var_46[sp]
FFF23184  2e19                              bra.b   loc_FFF2319D
FFF23186  5bee                   loc_FFF23186 movu.b  r14, r14
FFF23188  610e                              cmp     #0, r14
FFF2318A  17                                beq.s   loc_FFF23191
FFF2318B  f9054701                          mov.w   #1, 0D4h+var_46[sp]
FFF2318F  2e0e                              bra.b   loc_FFF2319D
FFF23191  dd0147                 loc_FFF23191 mov.w   0D4h+var_46[sp], r1
FFF23194  6211                              add     #1, r1
FFF23196  d70147                            mov.w   r1, 0D4h+var_46[sp]
FFF23199  f9062200                          mov.l   #0, 0D4h+var_4C[sp]
FFF2319D  ab01                   loc_FFF2319D mov.l   0D4h+var_A4[sp], r1
FFF2319F  f5130b                            btst    #3, 0Bh[r1].b
FFF231A2  15                                beq.s   loc_FFF231A7
FFF231A3  f80600                            mov.l   #0, 0D4h+var_D4[sp]
FFF231A6  0c                                bra.s   loc_FFF231AA
FFF231A7  f80601                 loc_FFF231A7 mov.l   #1, 0D4h+var_D4[sp]
FFF231AA  ec01                   loc_FFF231AA mov.l   0D4h+var_D4[sp], r1
FFF231AC  6101                              cmp     #0, r1
FFF231AE  3a5a01                            beq.w   loc_FFF23308
FFF231B1  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF231B4  6131                              cmp     #3, r1
FFF231B6  3a5201                            beq.w   loc_FFF23308
FFF231B9  ed0434                            mov.l   0D4h+var_4[sp], r4
FFF231BC  ed032d                            mov.l   0D4h+var_20[sp], r3
FFF231BF  ab02                              mov.l   0D4h+var_A4[sp], r2
FFF231C1  72330c04                          add     #40Ch, r3, r3
FFF231C5  710174                            add     #0D4h+var_60, sp, r1
FFF231C8  05dbf0ff                          bsr.a   sub_FFF222A3
FFF231CC  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF231CF  ed012b                            mov.l   0D4h+var_28[sp], r1
FFF231D2  6101                              cmp     #0, r1
FFF231D4  2032                              beq.b   loc_FFF23206
FFF231D6  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF231D9  72110c04                          add     #40Ch, r1, r1
FFF231DD  0566b400                          bsr.a   sub_FFF2E643
FFF231E1  a309                              mov.l   r1, 0D4h+var_A0[sp]
FFF231E3  ab09                              mov.l   0D4h+var_A0[sp], r1
FFF231E5  755118                            cmp     #18h, r1
FFF231E8  241e                              bgtu.b  loc_FFF23206
FFF231EA  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF231ED  72220c04                          add     #40Ch, r2, r2
FFF231F1  710167                            add     #0D4h+var_6D, sp, r1
FFF231F4  058cb100                          bsr.a   sub_FFF2E380
FFF231F8  ed0334                            mov.l   0D4h+var_4[sp], r3
FFF231FB  ab01                              mov.l   0D4h+var_A4[sp], r1
FFF231FD  710267                            add     #0D4h+var_6D, sp, r2
FFF23200  39a508                            bsr.w   sub_FFF23AA5
FFF23203  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF23206  ed012b                 loc_FFF23206 mov.l   0D4h+var_28[sp], r1
FFF23209  6101                              cmp     #0, r1
FFF2320B  3bfd00                            bne.w   loc_FFF23308
FFF2320E  ab02                              mov.l   0D4h+var_A4[sp], r2
FFF23210  ed0131                            mov.l   0D4h+var_10[sp], r1
FFF23213  754320                            mov.l   #20h, r3 ; ' '
FFF23216  0562b200                          bsr.a   sub_FFF2E478
FFF2321A  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF2321D  6101                              cmp     #0, r1
FFF2321F  213b                              bne.b   loc_FFF2325A
FFF23221  ad01                              mov.l   0D4h+var_84[sp], r1
FFF23223  ed022e                            mov.l   0D4h+var_1C[sp], r2
FFF23226  e321                              mov.l   r1, [r2]
FFF23228  ed0128                            mov.l   0D4h+var_34[sp], r1
FFF2322B  ed022f                            mov.l   0D4h+var_18[sp], r2
FFF2322E  e321                              mov.l   r1, [r2]
FFF23230  ed0128                            mov.l   0D4h+var_34[sp], r1
FFF23233  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF23236  db21100b                          mov.w   r1, 1620h[r2]
FFF2323A  dd012c                            mov.w   0D4h+var_7C[sp], r1
FFF2323D  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF23240  db21110b                          mov.w   r1, 1622h[r2]
FFF23244  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF23247  72112416                          add     #1624h, r1, r1
FFF2324B  66c3                              mov.l   #0Ch, r3
FFF2324D  710244                            add     #0D4h+var_90, sp, r2
FFF23250  0528b200                          bsr.a   sub_FFF2E478
FFF23254  3e0100                            mov.l   #0, 0D4h+var_D0[sp]
FFF23257  38b501                            bra.w   loc_FFF2340C
FFF2325A  cd01c3                 loc_FFF2325A mov.b   0D4h+var_11[sp], r1
FFF2325D  6121                              cmp     #2, r1
FFF2325F  3ba200                            bne.w   loc_FFF23301
FFF23262  ed0434                            mov.l   0D4h+var_4[sp], r4
FFF23265  5d0347                            movu.w  0D4h+var_46[sp], r3
FFF23268  ab01                              mov.l   0D4h+var_A4[sp], r1
FFF2326A  710274                            add     #0D4h+var_60, sp, r2
FFF2326D  0581efff                          bsr.a   sub_FFF221EE
FFF23271  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF23274  ed012b                            mov.l   0D4h+var_28[sp], r1
FFF23277  6101                              cmp     #0, r1
FFF23279  10                                beq.s   loc_FFF23281
FFF2327A  e5002b01                          mov.l   0D4h+var_28[sp], 0D4h+var_D0[sp]
FFF2327E  388e01                            bra.w   loc_FFF2340C
FFF23281  5d0147                 loc_FFF23281 movu.w  0D4h+var_46[sp], r1
FFF23284  06810128                          sub     0D4h+var_34[sp].l, r1
FFF23288  6011                              sub     #1, r1
FFF2328A  e70128                            mov.l   r1, 0D4h+var_34[sp]
FFF2328D  f9062601                          mov.l   #1, 0D4h+var_3C[sp]
FFF23291  2e19                              bra.b   loc_FFF232AA
FFF23293  ed0134                 loc_FFF23293 mov.l   0D4h+var_4[sp], r1
FFF23296  ad99                              mov.l   5Ch[r1], r1
FFF23298  6851                              shlr    #5, r1
FFF2329A  ed0228                            mov.l   0D4h+var_34[sp], r2
FFF2329D  4312                              sub     r1, r2
FFF2329F  e70228                            mov.l   r2, 0D4h+var_34[sp]
FFF232A2  ed0126                            mov.l   0D4h+var_3C[sp], r1
FFF232A5  6211                              add     #1, r1
FFF232A7  e70126                            mov.l   r1, 0D4h+var_3C[sp]
FFF232AA  ed0128                 loc_FFF232AA mov.l   0D4h+var_34[sp], r1
FFF232AD  6101                              cmp     #0, r1
FFF232AF  2ae4                              bgt.b   loc_FFF23293
FFF232B1  f9062700                          mov.l   #0, 0D4h+var_38[sp]
FFF232B5  2e3d                              bra.b   loc_FFF232F2
FFF232B7  710e44                 loc_FFF232B7 add     #0D4h+var_90, sp, r14
FFF232BA  ed0127                            mov.l   0D4h+var_38[sp], r1
FFF232BD  fe61ee                            mov.l   [r1, r14], r14
FFF232C0  610e                              cmp     #0, r14
FFF232C2  2039                              beq.b   loc_FFF232FB
FFF232C4  ed0127                            mov.l   0D4h+var_38[sp], r1
FFF232C7  710e74                            add     #0D4h+var_60, sp, r14
FFF232CA  fe61e3                            mov.l   [r1, r14], r3
FFF232CD  710e44                            add     #0D4h+var_90, sp, r14
FFF232D0  fe61e2                            mov.l   [r1, r14], r2
FFF232D3  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF232D6  05ccd1ff                          bsr.a   sub_FFF204A2
FFF232DA  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF232DD  ed012b                            mov.l   0D4h+var_28[sp], r1
FFF232E0  6101                              cmp     #0, r1
FFF232E2  10                                beq.s   loc_FFF232EA
FFF232E3  e5002b01                          mov.l   0D4h+var_28[sp], 0D4h+var_D0[sp]
FFF232E7  382501                            bra.w   loc_FFF2340C
FFF232EA  ed0127                 loc_FFF232EA mov.l   0D4h+var_38[sp], r1
FFF232ED  6211                              add     #1, r1
FFF232EF  e70127                            mov.l   r1, 0D4h+var_38[sp]
FFF232F2  ed0127                 loc_FFF232F2 mov.l   0D4h+var_38[sp], r1
FFF232F5  06850126                          cmp     0D4h+var_3C[sp].l, r1
FFF232F9  29be                              blt.b   loc_FFF232B7
FFF232FB  3e0100                 loc_FFF232FB mov.l   #0, 0D4h+var_D0[sp]
FFF232FE  380e01                            bra.w   loc_FFF2340C
FFF23301  f90601f3               loc_FFF23301 mov.l   #-0Dh, 0D4h+var_D0[sp]
FFF23305  380701                            bra.w   loc_FFF2340C
FFF23308  ab01                   loc_FFF23308 mov.l   0D4h+var_A4[sp], r1
FFF2330A  711120                            add     #20h, r1, r1 ; ' '
FFF2330D  a301                              mov.l   r1, 0D4h+var_A4[sp]
FFF2330F  ed0128                            mov.l   0D4h+var_34[sp], r1
FFF23312  6211                              add     #1, r1
FFF23314  e70128                            mov.l   r1, 0D4h+var_34[sp]
FFF23317  ed0134                 loc_FFF23317 mov.l   0D4h+var_4[sp], r1
FFF2331A  ad99                              mov.l   5Ch[r1], r1
FFF2331C  6851                              shlr    #5, r1
FFF2331E  06850128                          cmp     0D4h+var_34[sp].l, r1
FFF23322  2505                              bleu.b  loc_FFF23327
FFF23324  38d6f9                            bra.w   loc_FFF22CFA
FFF23327  ad01                   loc_FFF23327 mov.l   0D4h+var_84[sp], r1
FFF23329  6211                              add     #1, r1
FFF2332B  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF2332D  e5001d20                          mov.l   0D4h+var_60[sp], 0D4h+var_54[sp]
FFF23331  e5001f1d                          mov.l   0D4h+var_58[sp], 0D4h+var_60[sp]
FFF23335  e5001e1f                          mov.l   0D4h+var_5C[sp], 0D4h+var_58[sp]
FFF23339  e500201e                          mov.l   0D4h+var_54[sp], 0D4h+var_5C[sp]
FFF2333D  e5001213                          mov.l   0D4h+var_8C[sp], 0D4h+var_88[sp]
FFF23341  e5001112                          mov.l   0D4h+var_90[sp], 0D4h+var_8C[sp]
FFF23345  ed0129                            mov.l   0D4h+var_30[sp], r1
FFF23348  6211                              add     #1, r1
FFF2334A  e70129                            mov.l   r1, 0D4h+var_30[sp]
FFF2334D  aa81                              mov.l   0D4h+var_AC[sp], r1
FFF2334F  6211                              add     #1, r1
FFF23351  a281                              mov.l   r1, 0D4h+var_AC[sp]
FFF23353  ed0134                 loc_FFF23353 mov.l   0D4h+var_4[sp], r1
FFF23356  b892                              movu.w  4[r1], r2
FFF23358  06850229                          cmp     0D4h+var_30[sp].l, r2
FFF2335C  2b05                              ble.b   loc_FFF23361
FFF2335E  3829f9                            bra.w   loc_FFF22C87
FFF23361  ed022d                 loc_FFF23361 mov.l   0D4h+var_20[sp], r2
FFF23364  ed0333                            mov.l   0D4h+var_8[sp], r3
FFF23367  6080                              sub     #8, sp
FFF23369  a00a                              mov.l   r2, 0DCh+var_D8[sp]
FFF2336B  f80472                            mov.b   #72h, 0DCh+var_DC[sp] ; 'r'
FFF2336E  6604                              mov.l   #0, r4
FFF23370  71025c                            add     #0DCh+var_80, sp, r2
FFF23373  05bc0f00                          bsr.a   sub_FFF2432F
FFF23377  6280                              add     #8, sp
FFF23379  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF2337C  ad09                              mov.l   0D4h+var_80[sp], r1
FFF2337E  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF23384  18                                bne.s   loc_FFF2338C
FFF23385  f90601c3                          mov.l   #-3Dh, 0D4h+var_D0[sp]
FFF23389  388300                            bra.w   loc_FFF2340C
FFF2338C  ad09                   loc_FFF2338C mov.l   0D4h+var_80[sp], r1
FFF2338E  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF23394  2310                              bltu.b  loc_FFF233A4
FFF23396  ad09                              mov.l   0D4h+var_80[sp], r1
FFF23398  7401ffffff0f                      cmp     #0FFFFFFFh, r1
FFF2339E  2406                              bgtu.b  loc_FFF233A4
FFF233A0  f80601                            mov.l   #1, 0D4h+var_D4[sp]
FFF233A3  0c                                bra.s   loc_FFF233A7
FFF233A4  f80600                 loc_FFF233A4 mov.l   #0, 0D4h+var_D4[sp]
FFF233A7  ec01                   loc_FFF233A7 mov.l   0D4h+var_D4[sp], r1
FFF233A9  6101                              cmp     #0, r1
FFF233AB  204a                              beq.b   loc_FFF233F5
FFF233AD  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF233B0  6101                              cmp     #0, r1
FFF233B2  17                                beq.s   loc_FFF233B9
FFF233B3  cd01c3                            mov.b   0D4h+var_11[sp], r1
FFF233B6  6121                              cmp     #2, r1
FFF233B8  1d                                bne.s   loc_FFF233BD
FFF233B9  f80601                 loc_FFF233B9 mov.l   #1, 0D4h+var_D4[sp]
FFF233BC  0c                                bra.s   loc_FFF233C0
FFF233BD  f80600                 loc_FFF233BD mov.l   #0, 0D4h+var_D4[sp]
FFF233C0  ec01                   loc_FFF233C0 mov.l   0D4h+var_D4[sp], r1
FFF233C2  6101                              cmp     #0, r1
FFF233C4  17                                beq.s   loc_FFF233CB
FFF233C5  f90601fc                          mov.l   #-4, 0D4h+var_D0[sp]
FFF233C9  2e43                              bra.b   loc_FFF2340C
FFF233CB  dd0155                 loc_FFF233CB mov.w   0D4h+var_2A[sp], r1
FFF233CE  6101                              cmp     #0, r1
FFF233D0  2705                              bn.b    loc_FFF233D5
FFF233D2  3850f9                            bra.w   loc_FFF22D22
FFF233D5  ed032d                 loc_FFF233D5 mov.l   0D4h+var_20[sp], r3
FFF233D8  ed0233                            mov.l   0D4h+var_8[sp], r2
FFF233DB  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF233DE  053edbff                          bsr.a   sub_FFF20F1C
FFF233E2  a509                              mov.l   r1, 0D4h+var_80[sp]
FFF233E4  05f528ff                          bsr.a   sub_FFF15CD9
FFF233E8  a201                              mov.l   r1, 0D4h+var_B4[sp]
FFF233EA  aa01                              mov.l   0D4h+var_B4[sp], r1
FFF233EC  6101                              cmp     #0, r1
FFF233EE  17                                beq.s   loc_FFF233F5
FFF233EF  e5000801                          mov.l   0D4h+var_B4[sp], 0D4h+var_D0[sp]
FFF233F3  2e19                              bra.b   loc_FFF2340C
FFF233F5  e5001533               loc_FFF233F5 mov.l   0D4h+var_80[sp], 0D4h+var_8[sp]
FFF233F9  ed0233                 loc_FFF233F9 mov.l   0D4h+var_8[sp], r2
FFF233FC  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF233FF  05adbbff                          bsr.a   sub_FFF1EFAC
FFF23403  a501                              mov.l   r1, 0D4h+var_84[sp]
FFF23405  f9062900                          mov.l   #0, 0D4h+var_30[sp]
FFF23409  384aff                            bra.w   loc_FFF23353
FFF2340C  a809                   loc_FFF2340C mov.l   0D4h+var_D0[sp], r1
FFF2340E  e7012c                            mov.l   r1, 0D4h+var_24[sp]
FFF23411  6735                              rtsd    #35h
FFF23413  7100e8                 sub_FFF23413 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF23413
FFF23416  a109                              mov.l   r1, 18h+var_4[sp]
FFF23418  a102                              mov.l   r2, 18h+var_8[sp]
FFF2341A  e5000502                          mov.l   18h+var_4[sp], 18h+var_10[sp]
FFF2341E  a881                              mov.l   18h+var_10[sp], r1
FFF23420  cc1e                              mov.b   [r1], r14
FFF23422  755e5c                            cmp     #5Ch, r14 ; '\'
FFF23425  200d                              beq.b   loc_FFF23432
FFF23427  a881                              mov.l   18h+var_10[sp], r1
FFF23429  8819                              mov.b   1[r1], r1
FFF2342B  6101                              cmp     #0, r1
FFF2342D  15                                beq.s   loc_FFF23432
FFF2342E  f80601                            mov.l   #1, 18h+var_18[sp]
FFF23431  0c                                bra.s   loc_FFF23435
FFF23432  f80600                 loc_FFF23432 mov.l   #0, 18h+var_18[sp]
FFF23435  ec01                   loc_FFF23435 mov.l   18h+var_18[sp], r1
FFF23437  6101                              cmp     #0, r1
FFF23439  17                                beq.s   loc_FFF23440
FFF2343A  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF2343D  388800                            bra.w   loc_FFF234C5
FFF23440  a881                   loc_FFF23440 mov.l   18h+var_10[sp], r1
FFF23442  6221                              add     #2, r1
FFF23444  a081                              mov.l   r1, 18h+var_10[sp]
FFF23446  2e63                              bra.b   loc_FFF234A9
FFF23448  a881                   loc_FFF23448 mov.l   18h+var_10[sp], r1
FFF2344A  8819                              mov.b   1[r1], r1
FFF2344C  6101                              cmp     #0, r1
FFF2344E  1d                                bne.s   loc_FFF23453
FFF2344F  f80601                            mov.l   #1, 18h+var_18[sp]
FFF23452  0c                                bra.s   loc_FFF23456
FFF23453  f80600                 loc_FFF23453 mov.l   #0, 18h+var_18[sp]
FFF23456  ec01                   loc_FFF23456 mov.l   18h+var_18[sp], r1
FFF23458  6101                              cmp     #0, r1
FFF2345A  211e                              bne.b   loc_FFF23478
FFF2345C  a881                              mov.l   18h+var_10[sp], r1
FFF2345E  cc1e                              mov.b   [r1], r14
FFF23460  755e5c                            cmp     #5Ch, r14 ; '\'
FFF23463  210d                              bne.b   loc_FFF23470
FFF23465  a881                              mov.l   18h+var_10[sp], r1
FFF23467  8819                              mov.b   1[r1], r1
FFF23469  6101                              cmp     #0, r1
FFF2346B  1d                                bne.s   loc_FFF23470
FFF2346C  f80601                            mov.l   #1, 18h+var_18[sp]
FFF2346F  0c                                bra.s   loc_FFF23473
FFF23470  f80600                 loc_FFF23470 mov.l   #0, 18h+var_18[sp]
FFF23473  ec01                   loc_FFF23473 mov.l   18h+var_18[sp], r1
FFF23475  6101                              cmp     #0, r1
FFF23477  15                                beq.s   loc_FFF2347C
FFF23478  f80601                 loc_FFF23478 mov.l   #1, 18h+var_18[sp]
FFF2347B  0c                                bra.s   loc_FFF2347F
FFF2347C  f80600                 loc_FFF2347C mov.l   #0, 18h+var_18[sp]
FFF2347F  ec01                   loc_FFF2347F mov.l   18h+var_18[sp], r1
FFF23481  6101                              cmp     #0, r1
FFF23483  a901                              mov.l   18h+var_8[sp], r1
FFF23485  212e                              bne.b   loc_FFF234B3
FFF23487  a882                              mov.l   18h+var_10[sp], r2
FFF23489  c021                              mov.b   [r2], [r1]
FFF2348B  a901                              mov.l   18h+var_8[sp], r1
FFF2348D  6211                              add     #1, r1
FFF2348F  a101                              mov.l   r1, 18h+var_8[sp]
FFF23491  a881                              mov.l   18h+var_10[sp], r1
FFF23493  6211                              add     #1, r1
FFF23495  a081                              mov.l   r1, 18h+var_10[sp]
FFF23497  a881                              mov.l   18h+var_10[sp], r1
FFF23499  a902                              mov.l   18h+var_8[sp], r2
FFF2349B  c012                              mov.b   [r1], [r2]
FFF2349D  a901                              mov.l   18h+var_8[sp], r1
FFF2349F  6211                              add     #1, r1
FFF234A1  a101                              mov.l   r1, 18h+var_8[sp]
FFF234A3  a881                              mov.l   18h+var_10[sp], r1
FFF234A5  6211                              add     #1, r1
FFF234A7  a081                              mov.l   r1, 18h+var_10[sp]
FFF234A9  a881                   loc_FFF234A9 mov.l   18h+var_10[sp], r1
FFF234AB  cc1e                              mov.b   [r1], r14
FFF234AD  610e                              cmp     #0, r14
FFF234AF  2099                              beq.b   loc_FFF23448
FFF234B1  2ea2                              bra.b   loc_FFF23453
FFF234B3  f81400                 loc_FFF234B3 mov.b   #0, [r1]
FFF234B6  a901                              mov.l   18h+var_8[sp], r1
FFF234B8  6211                              add     #1, r1
FFF234BA  a101                              mov.l   r1, 18h+var_8[sp]
FFF234BC  a901                              mov.l   18h+var_8[sp], r1
FFF234BE  f81400                            mov.b   #0, [r1]
FFF234C1  e5000201                          mov.l   18h+var_10[sp], 18h+var_14[sp]
FFF234C5  a809                   loc_FFF234C5 mov.l   18h+var_14[sp], r1
FFF234C7  a089                              mov.l   r1, 18h+var_C[sp]
FFF234C9  6706                              rtsd    #6
FFF234CB  7200e4fd               sub_FFF234CB add     #-21Ch, sp, sp   ; <<<< FUNC sub_FFF234CB
FFF234CF  e70186                            mov.l   r1, 21Ch+var_4[sp]
FFF234D2  f9068400                          mov.l   #0, 21Ch+var_C[sp]
FFF234D6  ed0186                            mov.l   21Ch+var_4[sp], r1
FFF234D9  6241                              add     #4, r1
FFF234DB  e70183                            mov.l   r1, 21Ch+var_10[sp]
FFF234DE  2e58                              bra.b   loc_FFF23536
FFF234E0  ed0183                 loc_FFF234E0 mov.l   21Ch+var_10[sp], r1
FFF234E3  710206                            add     #21Ch+var_216, sp, r2
FFF234E6  392dff                            bsr.w   sub_FFF23413
FFF234E9  e70183                            mov.l   r1, 21Ch+var_10[sp]
FFF234EC  8981                              mov.b   21Ch+var_216[sp], r1
FFF234EE  6101                              cmp     #0, r1
FFF234F0  1a                                bne.s   loc_FFF234FA
FFF234F1  8989                              mov.b   21Ch+var_215[sp], r1
FFF234F3  6101                              cmp     #0, r1
FFF234F5  1d                                bne.s   loc_FFF234FA
FFF234F6  f80601                            mov.l   #1, 21Ch+var_21C[sp]
FFF234F9  0c                                bra.s   loc_FFF234FD
FFF234FA  f80600                 loc_FFF234FA mov.l   #0, 21Ch+var_21C[sp]
FFF234FD  ec01                   loc_FFF234FD mov.l   21Ch+var_21C[sp], r1
FFF234FF  6101                              cmp     #0, r1
FFF23501  2152                              bne.b   loc_FFF23553
FFF23503  ed0183                            mov.l   21Ch+var_10[sp], r1
FFF23506  cc1e                              mov.b   [r1], r14
FFF23508  610e                              cmp     #0, r14
FFF2350A  19                                bne.s   loc_FFF23513
FFF2350B  ed0183                            mov.l   21Ch+var_10[sp], r1
FFF2350E  8819                              mov.b   1[r1], r1
FFF23510  6101                              cmp     #0, r1
FFF23512  15                                beq.s   loc_FFF23517
FFF23513  f80601                 loc_FFF23513 mov.l   #1, 21Ch+var_21C[sp]
FFF23516  0c                                bra.s   loc_FFF2351A
FFF23517  f80600                 loc_FFF23517 mov.l   #0, 21Ch+var_21C[sp]
FFF2351A  ec01                   loc_FFF2351A mov.l   21Ch+var_21C[sp], r1
FFF2351C  6101                              cmp     #0, r1
FFF2351E  2018                              beq.b   loc_FFF23536
FFF23520  710106                            add     #21Ch+var_216, sp, r1
FFF23523  0520b100                          bsr.a   sub_FFF2E643
FFF23527  06890184                          add     21Ch+var_C[sp].l, r1
FFF2352B  e70184                            mov.l   r1, 21Ch+var_C[sp]
FFF2352E  ed0184                            mov.l   21Ch+var_C[sp], r1
FFF23531  6221                              add     #2, r1
FFF23533  e70184                            mov.l   r1, 21Ch+var_C[sp]
FFF23536  ed0183                 loc_FFF23536 mov.l   21Ch+var_10[sp], r1
FFF23539  cc1e                              mov.b   [r1], r14
FFF2353B  610e                              cmp     #0, r14
FFF2353D  19                                bne.s   loc_FFF23546
FFF2353E  ed0183                            mov.l   21Ch+var_10[sp], r1
FFF23541  8819                              mov.b   1[r1], r1
FFF23543  6101                              cmp     #0, r1
FFF23545  15                                beq.s   loc_FFF2354A
FFF23546  f80601                 loc_FFF23546 mov.l   #1, 21Ch+var_21C[sp]
FFF23549  0c                                bra.s   loc_FFF2354D
FFF2354A  f80600                 loc_FFF2354A mov.l   #0, 21Ch+var_21C[sp]
FFF2354D  ec01                   loc_FFF2354D mov.l   21Ch+var_21C[sp], r1
FFF2354F  6101                              cmp     #0, r1
FFF23551  218f                              bne.b   loc_FFF234E0
FFF23553  ed0184                 loc_FFF23553 mov.l   21Ch+var_C[sp], r1
FFF23556  6261                              add     #6, r1
FFF23558  e70185                            mov.l   r1, 21Ch+var_8[sp]
FFF2355B  6787                              rtsd    #-79h
FFF2355D  7100ec                 sub_FFF2355D add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2355D
FFF23560  a101                              mov.l   r1, 14h+var_4[sp]
FFF23562  2e46                              bra.b   loc_FFF235A8
FFF23564  fbe2d4940600           loc_FFF23564 mov.l   #694D4h, r14
FFF2356A  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF2356D  2e2d                              bra.b   loc_FFF2359A
FFF2356F  a881                   loc_FFF2356F mov.l   14h+var_C[sp], r1
FFF23571  cc1e                              mov.b   [r1], r14
FFF23573  a901                              mov.l   14h+var_4[sp], r1
FFF23575  06041e                            cmp     [r1].b, r14
FFF23578  210d                              bne.b   loc_FFF23585
FFF2357A  a901                              mov.l   14h+var_4[sp], r1
FFF2357C  8819                              mov.b   1[r1], r1
FFF2357E  6101                              cmp     #0, r1
FFF23580  1d                                bne.s   loc_FFF23585
FFF23581  f80601                            mov.l   #1, 14h+var_14[sp]
FFF23584  0c                                bra.s   loc_FFF23588
FFF23585  f80600                 loc_FFF23585 mov.l   #0, 14h+var_14[sp]
FFF23588  ec01                   loc_FFF23588 mov.l   14h+var_14[sp], r1
FFF2358A  6101                              cmp     #0, r1
FFF2358C  10                                beq.s   loc_FFF23594
FFF2358D  f90601ff                          mov.l   #-1, 14h+var_10[sp]
FFF23591  388500                            bra.w   loc_FFF23616
FFF23594  a881                   loc_FFF23594 mov.l   14h+var_C[sp], r1
FFF23596  6211                              add     #1, r1
FFF23598  a081                              mov.l   r1, 14h+var_C[sp]
FFF2359A  a881                   loc_FFF2359A mov.l   14h+var_C[sp], r1
FFF2359C  cc1e                              mov.b   [r1], r14
FFF2359E  610e                              cmp     #0, r14
FFF235A0  21cf                              bne.b   loc_FFF2356F
FFF235A2  a901                              mov.l   14h+var_4[sp], r1
FFF235A4  6221                              add     #2, r1
FFF235A6  a101                              mov.l   r1, 14h+var_4[sp]
FFF235A8  a901                   loc_FFF235A8 mov.l   14h+var_4[sp], r1
FFF235AA  cc1e                              mov.b   [r1], r14
FFF235AC  610e                              cmp     #0, r14
FFF235AE  18                                bne.s   loc_FFF235B6
FFF235AF  a901                              mov.l   14h+var_4[sp], r1
FFF235B1  8819                              mov.b   1[r1], r1
FFF235B3  6101                              cmp     #0, r1
FFF235B5  15                                beq.s   loc_FFF235BA
FFF235B6  f80601                 loc_FFF235B6 mov.l   #1, 14h+var_14[sp]
FFF235B9  0c                                bra.s   loc_FFF235BD
FFF235BA  f80600                 loc_FFF235BA mov.l   #0, 14h+var_14[sp]
FFF235BD  ec01                   loc_FFF235BD mov.l   14h+var_14[sp], r1
FFF235BF  6101                              cmp     #0, r1
FFF235C1  21a3                              bne.b   loc_FFF23564
FFF235C3  a901                              mov.l   14h+var_4[sp], r1
FFF235C5  6021                              sub     #2, r1
FFF235C7  a101                              mov.l   r1, 14h+var_4[sp]
FFF235C9  a901                              mov.l   14h+var_4[sp], r1
FFF235CB  cc1e                              mov.b   [r1], r14
FFF235CD  755e2e                            cmp     #2Eh, r14 ; '.'
FFF235D0  210d                              bne.b   loc_FFF235DD
FFF235D2  a901                              mov.l   14h+var_4[sp], r1
FFF235D4  8819                              mov.b   1[r1], r1
FFF235D6  6101                              cmp     #0, r1
FFF235D8  1d                                bne.s   loc_FFF235DD
FFF235D9  f80601                            mov.l   #1, 14h+var_14[sp]
FFF235DC  0c                                bra.s   loc_FFF235E0
FFF235DD  f80600                 loc_FFF235DD mov.l   #0, 14h+var_14[sp]
FFF235E0  ec01                   loc_FFF235E0 mov.l   14h+var_14[sp], r1
FFF235E2  6101                              cmp     #0, r1
FFF235E4  211e                              bne.b   loc_FFF23602
FFF235E6  a901                              mov.l   14h+var_4[sp], r1
FFF235E8  cc1e                              mov.b   [r1], r14
FFF235EA  755e20                            cmp     #20h, r14 ; ' '
FFF235ED  210d                              bne.b   loc_FFF235FA
FFF235EF  a901                              mov.l   14h+var_4[sp], r1
FFF235F1  8819                              mov.b   1[r1], r1
FFF235F3  6101                              cmp     #0, r1
FFF235F5  1d                                bne.s   loc_FFF235FA
FFF235F6  f80601                            mov.l   #1, 14h+var_14[sp]
FFF235F9  0c                                bra.s   loc_FFF235FD
FFF235FA  f80600                 loc_FFF235FA mov.l   #0, 14h+var_14[sp]
FFF235FD  ec01                   loc_FFF235FD mov.l   14h+var_14[sp], r1
FFF235FF  6101                              cmp     #0, r1
FFF23601  15                                beq.s   loc_FFF23606
FFF23602  f80601                 loc_FFF23602 mov.l   #1, 14h+var_14[sp]
FFF23605  0c                                bra.s   loc_FFF23609
FFF23606  f80600                 loc_FFF23606 mov.l   #0, 14h+var_14[sp]
FFF23609  ec01                   loc_FFF23609 mov.l   14h+var_14[sp], r1
FFF2360B  6101                              cmp     #0, r1
FFF2360D  16                                beq.s   loc_FFF23613
FFF2360E  f90601ff                          mov.l   #-1, 14h+var_10[sp]
FFF23612  0c                                bra.s   loc_FFF23616
FFF23613  3e0100                 loc_FFF23613 mov.l   #0, 14h+var_10[sp]
FFF23616  a809                   loc_FFF23616 mov.l   14h+var_10[sp], r1
FFF23618  a089                              mov.l   r1, 14h+var_8[sp]
FFF2361A  6705                              rtsd    #5
FFF2361C  7200e0fd               sub_FFF2361C add     #-220h, sp, sp   ; <<<< FUNC sub_FFF2361C
FFF23620  e70187                            mov.l   r1, 220h+var_4[sp]
FFF23623  cc1e                              mov.b   [r1], r14
FFF23625  755e41                            cmp     #41h, r14 ; 'A'
FFF23628  290c                              blt.b   loc_FFF23634
FFF2362A  ed0187                            mov.l   220h+var_4[sp], r1
FFF2362D  cc1e                              mov.b   [r1], r14
FFF2362F  755e5b                            cmp     #5Bh, r14 ; '['
FFF23632  2906                              blt.b   loc_FFF23638
FFF23634  f80601                 loc_FFF23634 mov.l   #1, 220h+var_220[sp]
FFF23637  0c                                bra.s   loc_FFF2363B
FFF23638  f80600                 loc_FFF23638 mov.l   #0, 220h+var_220[sp]
FFF2363B  ec01                   loc_FFF2363B mov.l   220h+var_220[sp], r1
FFF2363D  6101                              cmp     #0, r1
FFF2363F  2026                              beq.b   loc_FFF23665
FFF23641  ed0187                            mov.l   220h+var_4[sp], r1
FFF23644  cc1e                              mov.b   [r1], r14
FFF23646  755e61                            cmp     #61h, r14 ; 'a'
FFF23649  290c                              blt.b   loc_FFF23655
FFF2364B  ed0187                            mov.l   220h+var_4[sp], r1
FFF2364E  cc1e                              mov.b   [r1], r14
FFF23650  755e7b                            cmp     #7Bh, r14 ; '{'
FFF23653  2906                              blt.b   loc_FFF23659
FFF23655  f80601                 loc_FFF23655 mov.l   #1, 220h+var_220[sp]
FFF23658  0c                                bra.s   loc_FFF2365C
FFF23659  f80600                 loc_FFF23659 mov.l   #0, 220h+var_220[sp]
FFF2365C  ec01                   loc_FFF2365C mov.l   220h+var_220[sp], r1
FFF2365E  6101                              cmp     #0, r1
FFF23660  15                                beq.s   loc_FFF23665
FFF23661  f80601                            mov.l   #1, 220h+var_220[sp]
FFF23664  0c                                bra.s   loc_FFF23668
FFF23665  f80600                 loc_FFF23665 mov.l   #0, 220h+var_220[sp]
FFF23668  ec01                   loc_FFF23668 mov.l   220h+var_220[sp], r1
FFF2366A  6101                              cmp     #0, r1
FFF2366C  10                                beq.s   loc_FFF23674
FFF2366D  f90601f4                          mov.l   #-0Ch, 220h+var_21C[sp]
FFF23671  388300                            bra.w   loc_FFF236F4
FFF23674  ed0187                 loc_FFF23674 mov.l   220h+var_4[sp], r1
FFF23677  8891                              mov.b   2[r1], r1
FFF23679  75513a                            cmp     #3Ah, r1 ; ':'
FFF2367C  17                                beq.s   loc_FFF23683
FFF2367D  f90601ff                          mov.l   #-1, 220h+var_21C[sp]
FFF23681  2e73                              bra.b   loc_FFF236F4
FFF23683  ed0187                 loc_FFF23683 mov.l   220h+var_4[sp], r1
FFF23686  8911                              mov.b   4[r1], r1
FFF23688  75515c                            cmp     #5Ch, r1 ; '\'
FFF2368B  17                                beq.s   loc_FFF23692
FFF2368C  f90601ff                          mov.l   #-1, 220h+var_21C[sp]
FFF23690  2e64                              bra.b   loc_FFF236F4
FFF23692  ed0187                 loc_FFF23692 mov.l   220h+var_4[sp], r1
FFF23695  6241                              add     #4, r1
FFF23697  e70184                            mov.l   r1, 220h+var_10[sp]
FFF2369A  2e3a                              bra.b   loc_FFF236D4
FFF2369C  ed0184                 loc_FFF2369C mov.l   220h+var_10[sp], r1
FFF2369F  71020a                            add     #220h+var_216, sp, r2
FFF236A2  3971fd                            bsr.w   sub_FFF23413
FFF236A5  e70184                            mov.l   r1, 220h+var_10[sp]
FFF236A8  8a81                              mov.b   220h+var_216[sp], r1
FFF236AA  6101                              cmp     #0, r1
FFF236AC  1a                                bne.s   loc_FFF236B6
FFF236AD  8a89                              mov.b   220h+var_215[sp], r1
FFF236AF  6101                              cmp     #0, r1
FFF236B1  1d                                bne.s   loc_FFF236B6
FFF236B2  f80601                            mov.l   #1, 220h+var_220[sp]
FFF236B5  0c                                bra.s   loc_FFF236B9
FFF236B6  f80600                 loc_FFF236B6 mov.l   #0, 220h+var_220[sp]
FFF236B9  ec01                   loc_FFF236B9 mov.l   220h+var_220[sp], r1
FFF236BB  6101                              cmp     #0, r1
FFF236BD  2134                              bne.b   loc_FFF236F1
FFF236BF  71010a                            add     #220h+var_216, sp, r1
FFF236C2  399bfe                            bsr.w   sub_FFF2355D
FFF236C5  e70185                            mov.l   r1, 220h+var_C[sp]
FFF236C8  ed0185                            mov.l   220h+var_C[sp], r1
FFF236CB  6101                              cmp     #0, r1
FFF236CD  17                                beq.s   loc_FFF236D4
FFF236CE  e5008501                          mov.l   220h+var_C[sp], 220h+var_21C[sp]
FFF236D2  2e22                              bra.b   loc_FFF236F4
FFF236D4  ed0184                 loc_FFF236D4 mov.l   220h+var_10[sp], r1
FFF236D7  cc1e                              mov.b   [r1], r14
FFF236D9  610e                              cmp     #0, r14
FFF236DB  19                                bne.s   loc_FFF236E4
FFF236DC  ed0184                            mov.l   220h+var_10[sp], r1
FFF236DF  8819                              mov.b   1[r1], r1
FFF236E1  6101                              cmp     #0, r1
FFF236E3  15                                beq.s   loc_FFF236E8
FFF236E4  f80601                 loc_FFF236E4 mov.l   #1, 220h+var_220[sp]
FFF236E7  0c                                bra.s   loc_FFF236EB
FFF236E8  f80600                 loc_FFF236E8 mov.l   #0, 220h+var_220[sp]
FFF236EB  ec01                   loc_FFF236EB mov.l   220h+var_220[sp], r1
FFF236ED  6101                              cmp     #0, r1
FFF236EF  21ad                              bne.b   loc_FFF2369C
FFF236F1  3e0100                 loc_FFF236F1 mov.l   #0, 220h+var_21C[sp]
FFF236F4  a809                   loc_FFF236F4 mov.l   220h+var_21C[sp], r1
FFF236F6  e70186                            mov.l   r1, 220h+var_8[sp]
FFF236F9  6788                              rtsd    #-78h
FFF236FB  7100ec                 sub_FFF236FB add     #-14h, sp, sp   ; <<<< FUNC sub_FFF236FB
FFF236FE  a101                              mov.l   r1, 14h+var_4[sp]
FFF23700  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF23703  e5000401                          mov.l   14h+var_4[sp], 14h+var_10[sp]
FFF23707  2e1b                              bra.b   loc_FFF23722
FFF23709  a881                   loc_FFF23709 mov.l   14h+var_C[sp], r1
FFF2370B  6221                              add     #2, r1
FFF2370D  a081                              mov.l   r1, 14h+var_C[sp]
FFF2370F  a881                              mov.l   14h+var_C[sp], r1
FFF23711  76010502                          cmp     #205h, r1
FFF23715  2907                              blt.b   loc_FFF2371C
FFF23717  f806ff                            mov.l   #-1, 14h+var_14[sp]
FFF2371A  2e13                              bra.b   loc_FFF2372D
FFF2371C  a809                   loc_FFF2371C mov.l   14h+var_10[sp], r1
FFF2371E  6221                              add     #2, r1
FFF23720  a009                              mov.l   r1, 14h+var_10[sp]
FFF23722  a809                   loc_FFF23722 mov.l   14h+var_10[sp], r1
FFF23724  5c1e                              movu.w  [r1], r14
FFF23726  610e                              cmp     #0, r14
FFF23728  21e1                              bne.b   loc_FFF23709
FFF2372A  f80600                            mov.l   #0, 14h+var_14[sp]
FFF2372D  ec01                   loc_FFF2372D mov.l   14h+var_14[sp], r1
FFF2372F  a089                              mov.l   r1, 14h+var_8[sp]
FFF23731  6705                              rtsd    #5
FFF23733  7100f0                 sub_FFF23733 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF23733
FFF23736  a089                              mov.l   r1, 10h+var_4[sp]
FFF23738  a082                              mov.l   r2, 10h+var_8[sp]
FFF2373A  a00b                              mov.l   r3, 10h+var_C[sp]
FFF2373C  60a3                              sub     #0Ah, r3
FFF2373E  e303                              mov.l   r3, 10h+var_10[sp]
FFF23740  ec01                              mov.l   10h+var_10[sp], r1
FFF23742  6101                              cmp     #0, r1
FFF23744  2b1b                              ble.b   loc_FFF2375F
FFF23746  a80b                              mov.l   10h+var_C[sp], r3
FFF23748  a881                              mov.l   10h+var_8[sp], r1
FFF2374A  fb4a0002                          mov.l   #200h, r4
FFF2374E  754230                            mov.l   #30h, r2 ; '0'
FFF23751  055ead00                          bsr.a   sub_FFF2E4AF
FFF23755  a881                              mov.l   10h+var_8[sp], r1
FFF23757  068801                            add     [sp].l, r1
FFF2375A  a081                              mov.l   r1, 10h+var_8[sp]
FFF2375C  3e010a                            mov.l   #0Ah, 10h+var_C[sp]
FFF2375F  a809                   loc_FFF2375F mov.l   10h+var_C[sp], r1
FFF23761  6011                              sub     #1, r1
FFF23763  6191                              cmp     #9, r1
FFF23765  2505                              bleu.b  loc_FFF2376A
FFF23767  389e01                            bra.w   loc_FFF23905
FFF2376A  fbe28a83f4ff           loc_FFF2376A mov.l   #unk_FFF4838A, r14
FFF23770  fe51ee                            mov.w   [r1, r14], r14
FFF23773  7f4e                              bra.l   r14
FFF23775  a889                              mov.l   10h+var_4[sp], r1
FFF23777  fd709100ca9a3b                    divu    #3B9ACA00h, r1
FFF2377E  e301                              mov.l   r1, 10h+var_10[sp]
FFF23780  ec01                              mov.l   10h+var_10[sp], r1
FFF23782  711130                            add     #30h, r1, r1 ; '0'
FFF23785  a882                              mov.l   10h+var_8[sp], r2
FFF23787  c321                              mov.b   r1, [r2]
FFF23789  a889                              mov.l   10h+var_4[sp], r1
FFF2378B  ef1e                              mov.l   r1, r14
FFF2378D  fd709e00ca9a3b                    divu    #3B9ACA00h, r14
FFF23794  741e00ca9a3b                      mul     #3B9ACA00h, r14
FFF2379A  43e1                              sub     r14, r1
FFF2379C  a089                              mov.l   r1, 10h+var_4[sp]
FFF2379E  a881                              mov.l   10h+var_8[sp], r1
FFF237A0  6211                              add     #1, r1
FFF237A2  a081                              mov.l   r1, 10h+var_8[sp]
FFF237A4  a889                              mov.l   10h+var_4[sp], r1
FFF237A6  fd709100e1f505                    divu    #5F5E100h, r1
FFF237AD  e301                              mov.l   r1, 10h+var_10[sp]
FFF237AF  ec01                              mov.l   10h+var_10[sp], r1
FFF237B1  711130                            add     #30h, r1, r1 ; '0'
FFF237B4  a882                              mov.l   10h+var_8[sp], r2
FFF237B6  c321                              mov.b   r1, [r2]
FFF237B8  a889                              mov.l   10h+var_4[sp], r1
FFF237BA  ef1e                              mov.l   r1, r14
FFF237BC  fd709e00e1f505                    divu    #5F5E100h, r14
FFF237C3  741e00e1f505                      mul     #5F5E100h, r14
FFF237C9  43e1                              sub     r14, r1
FFF237CB  a089                              mov.l   r1, 10h+var_4[sp]
FFF237CD  a881                              mov.l   10h+var_8[sp], r1
FFF237CF  6211                              add     #1, r1
FFF237D1  a081                              mov.l   r1, 10h+var_8[sp]
FFF237D3  a889                              mov.l   10h+var_4[sp], r1
FFF237D5  fd709180969800                    divu    #989680h, r1
FFF237DC  e301                              mov.l   r1, 10h+var_10[sp]
FFF237DE  ec01                              mov.l   10h+var_10[sp], r1
FFF237E0  711130                            add     #30h, r1, r1 ; '0'
FFF237E3  a882                              mov.l   10h+var_8[sp], r2
FFF237E5  c321                              mov.b   r1, [r2]
FFF237E7  a889                              mov.l   10h+var_4[sp], r1
FFF237E9  ef1e                              mov.l   r1, r14
FFF237EB  fd709e80969800                    divu    #989680h, r14
FFF237F2  741e80969800                      mul     #989680h, r14
FFF237F8  43e1                              sub     r14, r1
FFF237FA  a089                              mov.l   r1, 10h+var_4[sp]
FFF237FC  a881                              mov.l   10h+var_8[sp], r1
FFF237FE  6211                              add     #1, r1
FFF23800  a081                              mov.l   r1, 10h+var_8[sp]
FFF23802  a889                              mov.l   10h+var_4[sp], r1
FFF23804  fd7c9140420f                      divu    #0F4240h, r1
FFF2380A  e301                              mov.l   r1, 10h+var_10[sp]
FFF2380C  ec01                              mov.l   10h+var_10[sp], r1
FFF2380E  711130                            add     #30h, r1, r1 ; '0'
FFF23811  a882                              mov.l   10h+var_8[sp], r2
FFF23813  c321                              mov.b   r1, [r2]
FFF23815  a889                              mov.l   10h+var_4[sp], r1
FFF23817  ef1e                              mov.l   r1, r14
FFF23819  fd7c9e40420f                      divu    #0F4240h, r14
FFF2381F  771e40420f                        mul     #0F4240h, r14
FFF23824  43e1                              sub     r14, r1
FFF23826  a089                              mov.l   r1, 10h+var_4[sp]
FFF23828  a881                              mov.l   10h+var_8[sp], r1
FFF2382A  6211                              add     #1, r1
FFF2382C  a081                              mov.l   r1, 10h+var_8[sp]
FFF2382E  a889                              mov.l   10h+var_4[sp], r1
FFF23830  fd7c91a08601                      divu    #186A0h, r1
FFF23836  e301                              mov.l   r1, 10h+var_10[sp]
FFF23838  ec01                              mov.l   10h+var_10[sp], r1
FFF2383A  711130                            add     #30h, r1, r1 ; '0'
FFF2383D  a882                              mov.l   10h+var_8[sp], r2
FFF2383F  c321                              mov.b   r1, [r2]
FFF23841  a889                              mov.l   10h+var_4[sp], r1
FFF23843  ef1e                              mov.l   r1, r14
FFF23845  fd7c9ea08601                      divu    #186A0h, r14
FFF2384B  771ea08601                        mul     #186A0h, r14
FFF23850  43e1                              sub     r14, r1
FFF23852  a089                              mov.l   r1, 10h+var_4[sp]
FFF23854  a881                              mov.l   10h+var_8[sp], r1
FFF23856  6211                              add     #1, r1
FFF23858  a081                              mov.l   r1, 10h+var_8[sp]
FFF2385A  a889                              mov.l   10h+var_4[sp], r1
FFF2385C  fd78911027                        divu    #2710h, r1
FFF23861  e301                              mov.l   r1, 10h+var_10[sp]
FFF23863  ec01                              mov.l   10h+var_10[sp], r1
FFF23865  711130                            add     #30h, r1, r1 ; '0'
FFF23868  a882                              mov.l   10h+var_8[sp], r2
FFF2386A  c321                              mov.b   r1, [r2]
FFF2386C  a889                              mov.l   10h+var_4[sp], r1
FFF2386E  ef1e                              mov.l   r1, r14
FFF23870  fd789e1027                        divu    #2710h, r14
FFF23875  761e1027                          mul     #2710h, r14
FFF23879  43e1                              sub     r14, r1
FFF2387B  a089                              mov.l   r1, 10h+var_4[sp]
FFF2387D  a881                              mov.l   10h+var_8[sp], r1
FFF2387F  6211                              add     #1, r1
FFF23881  a081                              mov.l   r1, 10h+var_8[sp]
FFF23883  a889                              mov.l   10h+var_4[sp], r1
FFF23885  fd7891e803                        divu    #3E8h, r1
FFF2388A  e301                              mov.l   r1, 10h+var_10[sp]
FFF2388C  ec01                              mov.l   10h+var_10[sp], r1
FFF2388E  711130                            add     #30h, r1, r1 ; '0'
FFF23891  a882                              mov.l   10h+var_8[sp], r2
FFF23893  c321                              mov.b   r1, [r2]
FFF23895  a889                              mov.l   10h+var_4[sp], r1
FFF23897  ef1e                              mov.l   r1, r14
FFF23899  fd789ee803                        divu    #3E8h, r14
FFF2389E  761ee803                          mul     #3E8h, r14
FFF238A2  43e1                              sub     r14, r1
FFF238A4  a089                              mov.l   r1, 10h+var_4[sp]
FFF238A6  a881                              mov.l   10h+var_8[sp], r1
FFF238A8  6211                              add     #1, r1
FFF238AA  a081                              mov.l   r1, 10h+var_8[sp]
FFF238AC  a889                              mov.l   10h+var_4[sp], r1
FFF238AE  fd749164                          divu    #64h, r1 ; 'd'
FFF238B2  e301                              mov.l   r1, 10h+var_10[sp]
FFF238B4  ec01                              mov.l   10h+var_10[sp], r1
FFF238B6  711130                            add     #30h, r1, r1 ; '0'
FFF238B9  a882                              mov.l   10h+var_8[sp], r2
FFF238BB  c321                              mov.b   r1, [r2]
FFF238BD  a889                              mov.l   10h+var_4[sp], r1
FFF238BF  ef1e                              mov.l   r1, r14
FFF238C1  fd749e64                          divu    #64h, r14 ; 'd'
FFF238C5  751e64                            mul     #64h, r14 ; 'd'
FFF238C8  43e1                              sub     r14, r1
FFF238CA  a089                              mov.l   r1, 10h+var_4[sp]
FFF238CC  a881                              mov.l   10h+var_8[sp], r1
FFF238CE  6211                              add     #1, r1
FFF238D0  a081                              mov.l   r1, 10h+var_8[sp]
FFF238D2  a889                              mov.l   10h+var_4[sp], r1
FFF238D4  fd74910a                          divu    #0Ah, r1
FFF238D8  e301                              mov.l   r1, 10h+var_10[sp]
FFF238DA  ec01                              mov.l   10h+var_10[sp], r1
FFF238DC  711130                            add     #30h, r1, r1 ; '0'
FFF238DF  a882                              mov.l   10h+var_8[sp], r2
FFF238E1  c321                              mov.b   r1, [r2]
FFF238E3  a889                              mov.l   10h+var_4[sp], r1
FFF238E5  ef1e                              mov.l   r1, r14
FFF238E7  fd749e0a                          divu    #0Ah, r14
FFF238EB  63ae                              mul     #0Ah, r14
FFF238ED  43e1                              sub     r14, r1
FFF238EF  a089                              mov.l   r1, 10h+var_4[sp]
FFF238F1  a881                              mov.l   10h+var_8[sp], r1
FFF238F3  6211                              add     #1, r1
FFF238F5  a081                              mov.l   r1, 10h+var_8[sp]
FFF238F7  e10003                            mov.l   10h+var_4[sp], 10h+var_10[sp]
FFF238FA  ec01                              mov.l   10h+var_10[sp], r1
FFF238FC  711130                            add     #30h, r1, r1 ; '0'
FFF238FF  a882                              mov.l   10h+var_8[sp], r2

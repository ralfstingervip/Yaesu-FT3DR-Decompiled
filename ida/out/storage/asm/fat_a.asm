; ==== fat_a  FFF1F980-FFF208C0  (file 31F980-3208C0) ====
FFF1F980  00                                brk
FFF1F981  33                                .byte  33h ; 3
FFF1F982  01                                .byte    1
FFF1F983  38fc07                            bra.w   loc_FFF2017F
FFF1F986  e5001310               loc_FFF1F986 mov.l   0F4h+var_A8[sp], 0F4h+var_B4[sp]
FFF1F98A  e500250b                          mov.l   0F4h+var_60[sp], 0F4h+var_C8[sp]
FFF1F98E  a981                              mov.l   0F4h+var_DC[sp], r1
FFF1F990  6111                              cmp     #1, r1
FFF1F992  2146                              bne.b   loc_FFF1F9D8
FFF1F994  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1F997  ed023b                            mov.l   0F4h+var_8[sp], r2
FFF1F99A  0685120d                          cmp     34h[r1].l, r2
FFF1F99E  2037                              beq.b   loc_FFF1F9D5
FFF1F9A0  aa89                              mov.l   0F4h+var_C8[sp], r1
FFF1F9A2  66b3                              mov.l   #0Bh, r3
FFF1F9A4  71020d                            add     #0F4h+var_E7, sp, r2
FFF1F9A7  0587ef00                          bsr.a   sub_FFF2E92E
FFF1F9AB  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1F9AE  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1F9B1  6101                              cmp     #0, r1
FFF1F9B3  10                                beq.s   loc_FFF1F9BB
FFF1F9B4  f90601b9                          mov.l   #-47h, 0F4h+var_F0[sp]
FFF1F9B8  38c707                            bra.w   loc_FFF2017F
FFF1F9BB  ed013c                 loc_FFF1F9BB mov.l   0F4h+var_4[sp], r1
FFF1F9BE  8c12                              mov.b   10h[r1], r2
FFF1F9C0  aa89                              mov.l   0F4h+var_C8[sp], r1
FFF1F9C2  39d60c                            bsr.w   sub_FFF20698
FFF1F9C5  a081                              mov.l   r1, 0F4h+var_EC[sp]
FFF1F9C7  a881                              mov.l   0F4h+var_EC[sp], r1
FFF1F9C9  0685013b                          cmp     0F4h+var_8[sp].l, r1
FFF1F9CD  10                                beq.s   loc_FFF1F9D5
FFF1F9CE  f90601b9                          mov.l   #-47h, 0F4h+var_F0[sp]
FFF1F9D2  38ad07                            bra.w   loc_FFF2017F
FFF1F9D5  3e0600                 loc_FFF1F9D5 mov.l   #0, 0F4h+var_DC[sp]
FFF1F9D8  f9063000               loc_FFF1F9D8 mov.l   #0, 0F4h+var_34[sp]
FFF1F9DC  38af06                            bra.w   loc_FFF2008B
FFF1F9DF  aa89                   loc_FFF1F9DF mov.l   0F4h+var_C8[sp], r1
FFF1F9E1  581e                              movu.b  [r1], r14
FFF1F9E3  610e                              cmp     #0, r14
FFF1F9E5  3bb503                            bne.w   loc_FFF1FD9A
FFF1F9E8  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1F9EB  6101                              cmp     #0, r1
FFF1F9ED  17                                beq.s   loc_FFF1F9F4
FFF1F9EE  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1F9F1  6121                              cmp     #2, r1
FFF1F9F3  1d                                bne.s   loc_FFF1F9F8
FFF1F9F4  f80601                 loc_FFF1F9F4 mov.l   #1, 0F4h+var_F4[sp]
FFF1F9F7  0c                                bra.s   loc_FFF1F9FB
FFF1F9F8  f80600                 loc_FFF1F9F8 mov.l   #0, 0F4h+var_F4[sp]
FFF1F9FB  ec01                   loc_FFF1F9FB mov.l   0F4h+var_F4[sp], r1
FFF1F9FD  6101                              cmp     #0, r1
FFF1F9FF  10                                beq.s   loc_FFF1FA07
FFF1FA00  f90601fc                          mov.l   #-4, 0F4h+var_F0[sp]
FFF1FA04  387b07                            bra.w   loc_FFF2017F
FFF1FA07  b789                   loc_FFF1FA07 movu.b  0F4h+var_D5[sp], r1
FFF1FA09  6111                              cmp     #1, r1
FFF1FA0B  2110                              bne.b   loc_FFF1FA1B
FFF1FA0D  aa01                              mov.l   0F4h+var_D4[sp], r1
FFF1FA0F  6011                              sub     #1, r1
FFF1FA11  66a3                              mov.l   #0Ah, r3
FFF1FA13  72028c00                          add     #0F4h+var_68, sp, r2
FFF1FA17  05adf100                          bsr.a   sub_FFF2EBC4
FFF1FA1B  72018c00               loc_FFF1FA1B add     #0F4h+var_68, sp, r1
FFF1FA1F  0579f100                          bsr.a   sub_FFF2EB98
FFF1FA23  6101                              cmp     #0, r1
FFF1FA25  2b16                              ble.b   loc_FFF1FA3B
FFF1FA27  72018c00                          add     #0F4h+var_68, sp, r1
FFF1FA2B  056df100                          bsr.a   sub_FFF2EB98
FFF1FA2F  74017f969800                      cmp     #98967Fh, r1
FFF1FA35  2a06                              bgt.b   loc_FFF1FA3B
FFF1FA37  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF1FA3A  0c                                bra.s   loc_FFF1FA3E
FFF1FA3B  f80600                 loc_FFF1FA3B mov.l   #0, 0F4h+var_F4[sp]
FFF1FA3E  ec01                   loc_FFF1FA3E mov.l   0F4h+var_F4[sp], r1
FFF1FA40  6101                              cmp     #0, r1
FFF1FA42  2030                              beq.b   loc_FFF1FA72
FFF1FA44  ed013a                            mov.l   0F4h+var_C[sp], r1
FFF1FA47  72038c00                          add     #0F4h+var_68, sp, r3
FFF1FA4B  71027f                            add     #0F4h+var_75, sp, r2
FFF1FA4E  395411                            bsr.w   sub_FFF20BA2
FFF1FA51  ed033c                            mov.l   0F4h+var_4[sp], r3
FFF1FA54  71027f                            add     #0F4h+var_75, sp, r2
FFF1FA57  710166                            add     #0F4h+var_8E, sp, r1
FFF1FA5A  39310e                            bsr.w   sub_FFF2088B
FFF1FA5D  ed0139                            mov.l   0F4h+var_10[sp], r1
FFF1FA60  66b3                              mov.l   #0Bh, r3
FFF1FA62  710266                            add     #0F4h+var_8E, sp, r2
FFF1FA65  0513ea00                          bsr.a   sub_FFF2E478
FFF1FA69  dd0165                            mov.w   0F4h+var_2A[sp], r1
FFF1FA6C  6101                              cmp     #0, r1
FFF1FA6E  260b                              bpz.b   loc_FFF1FA79
FFF1FA70  2e62                              bra.b   loc_FFF1FAD2
FFF1FA72  f90601be               loc_FFF1FA72 mov.l   #-42h, 0F4h+var_F0[sp]
FFF1FA76  380907                            bra.w   loc_FFF2017F
FFF1FA79  dd0165                 loc_FFF1FA79 mov.w   0F4h+var_2A[sp], r1
FFF1FA7C  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1FA7F  db21100b                          mov.w   r1, 1620h[r2]
FFF1FA83  dd012b                            mov.w   0F4h+var_9E[sp], r1
FFF1FA86  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1FA89  db21110b                          mov.w   r1, 1622h[r2]
FFF1FA8D  ed0135                            mov.l   0F4h+var_20[sp], r1
FFF1FA90  72112416                          add     #1624h, r1, r1
FFF1FA94  66c3                              mov.l   #0Ch, r3
FFF1FA96  710234                            add     #0F4h+var_C0, sp, r2
FFF1FA99  05dfe900                          bsr.a   sub_FFF2E478
FFF1FA9D  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1FAA0  6131                              cmp     #3, r1
FFF1FAA2  1f                                bne.s   loc_FFF1FAA9
FFF1FAA3  3e0100                            mov.l   #0, 0F4h+var_F0[sp]
FFF1FAA6  38d906                            bra.w   loc_FFF2017F
FFF1FAA9  ed0235                 loc_FFF1FAA9 mov.l   0F4h+var_20[sp], r2
FFF1FAAC  5d052b                            movu.w  0F4h+var_9E[sp], r5
FFF1FAAF  ed0439                            mov.l   0F4h+var_10[sp], r4
FFF1FAB2  5d0365                            movu.w  0F4h+var_2A[sp], r3
FFF1FAB5  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FAB8  60c0                              sub     #0Ch, sp
FFF1FABA  a00d                              mov.l   r5, 100h+var_FC[sp]
FFF1FABC  a082                              mov.l   r2, 100h+var_F8[sp]
FFF1FABE  72220c04                          add     #40Ch, r2, r2
FFF1FAC2  e302                              mov.l   r2, 100h+var_100[sp]
FFF1FAC4  710240                            add     #100h+var_C0, sp, r2
FFF1FAC7  394024                            bsr.w   sub_FFF21F07
FFF1FACA  62c0                              add     #0Ch, sp
FFF1FACC  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FACF  38b802                            bra.w   loc_FFF1FD87
FFF1FAD2  ed013c                 loc_FFF1FAD2 mov.l   0F4h+var_4[sp], r1
FFF1FAD5  ad99                              mov.l   5Ch[r1], r1
FFF1FAD7  6851                              shlr    #5, r1
FFF1FAD9  5d022b                            movu.w  0F4h+var_9E[sp], r2
FFF1FADC  06890230                          add     0F4h+var_34[sp].l, r2
FFF1FAE0  6012                              sub     #1, r2
FFF1FAE2  0681022c                          sub     0F4h+var_44[sp].l, r2
FFF1FAE6  fc2712                            divu    r1, r2
FFF1FAE9  e7022e                            mov.l   r2, 0F4h+var_3C[sp]
FFF1FAEC  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FAEF  ad99                              mov.l   5Ch[r1], r1
FFF1FAF1  6851                              shlr    #5, r1
FFF1FAF3  5d022b                            movu.w  0F4h+var_9E[sp], r2
FFF1FAF6  06890230                          add     0F4h+var_34[sp].l, r2
FFF1FAFA  6012                              sub     #1, r2
FFF1FAFC  0681022c                          sub     0F4h+var_44[sp].l, r2
FFF1FB00  ef2e                              mov.l   r2, r14
FFF1FB02  fc271e                            divu    r1, r14
FFF1FB05  4f1e                              mul     r1, r14
FFF1FB07  43e2                              sub     r14, r2
FFF1FB09  d70265                            mov.w   r2, 0F4h+var_2A[sp]
FFF1FB0C  f9062f00                          mov.l   #0, 0F4h+var_38[sp]
FFF1FB10  38df01                            bra.w   loc_FFF1FCEF
FFF1FB13  ac89                   loc_FFF1FB13 mov.l   0F4h+var_A8[sp], r1
FFF1FB15  6211                              add     #1, r1
FFF1FB17  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF1FB19  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FB1C  b892                              movu.w  4[r1], r2
FFF1FB1E  6112                              cmp     #1, r2
FFF1FB20  3b8600                            bne.w   loc_FFF1FBA6
FFF1FB23  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1FB26  ed033b                            mov.l   0F4h+var_8[sp], r3
FFF1FB29  6080                              sub     #8, sp
FFF1FB2B  a00a                              mov.l   r2, 0FCh+var_F8[sp]
FFF1FB2D  f80472                            mov.b   #72h, 0FCh+var_FC[sp] ; 'r'
FFF1FB30  6604                              mov.l   #0, r4
FFF1FB32  710258                            add     #0FCh+var_A4, sp, r2
FFF1FB35  05fa4700                          bsr.a   sub_FFF2432F
FFF1FB39  6280                              add     #8, sp
FFF1FB3B  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FB3E  ad01                              mov.l   0F4h+var_A4[sp], r1
FFF1FB40  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF1FB46  18                                bne.s   loc_FFF1FB4E
FFF1FB47  f90601c3                          mov.l   #-3Dh, 0F4h+var_F0[sp]
FFF1FB4B  383406                            bra.w   loc_FFF2017F
FFF1FB4E  ad01                   loc_FFF1FB4E mov.l   0F4h+var_A4[sp], r1
FFF1FB50  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF1FB56  2310                              bltu.b  loc_FFF1FB66
FFF1FB58  ad01                              mov.l   0F4h+var_A4[sp], r1
FFF1FB5A  7401ffffff0f                      cmp     #0FFFFFFFh, r1
FFF1FB60  2406                              bgtu.b  loc_FFF1FB66
FFF1FB62  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF1FB65  0c                                bra.s   loc_FFF1FB69
FFF1FB66  f80600                 loc_FFF1FB66 mov.l   #0, 0F4h+var_F4[sp]
FFF1FB69  ec01                   loc_FFF1FB69 mov.l   0F4h+var_F4[sp], r1
FFF1FB6B  6101                              cmp     #0, r1
FFF1FB6D  2011                              beq.b   loc_FFF1FB7E
FFF1FB6F  ed0335                            mov.l   0F4h+var_20[sp], r3
FFF1FB72  ed023b                            mov.l   0F4h+var_8[sp], r2
FFF1FB75  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FB78  39a413                            bsr.w   sub_FFF20F1C
FFF1FB7B  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF1FB7D  0d                                bra.s   loc_FFF1FB82
FFF1FB7E  e5001413               loc_FFF1FB7E mov.l   0F4h+var_A4[sp], 0F4h+var_A8[sp]
FFF1FB82  e500133b               loc_FFF1FB82 mov.l   0F4h+var_A8[sp], 0F4h+var_8[sp]
FFF1FB86  055361ff                          bsr.a   sub_FFF15CD9
FFF1FB8A  a281                              mov.l   r1, 0F4h+var_CC[sp]
FFF1FB8C  aa81                              mov.l   0F4h+var_CC[sp], r1
FFF1FB8E  6101                              cmp     #0, r1
FFF1FB90  10                                beq.s   loc_FFF1FB98
FFF1FB91  e5000a01                          mov.l   0F4h+var_CC[sp], 0F4h+var_F0[sp]
FFF1FB95  38ea05                            bra.w   loc_FFF2017F
FFF1FB98  ac8a                   loc_FFF1FB98 mov.l   0F4h+var_A8[sp], r2
FFF1FB9A  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FB9D  050ff4ff                          bsr.a   sub_FFF1EFAC
FFF1FBA1  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF1FBA3  383001                            bra.w   loc_FFF1FCD3
FFF1FBA6  ed023c                 loc_FFF1FBA6 mov.l   0F4h+var_4[sp], r2
FFF1FBA9  b8a2                              movu.w  4[r2], r2
FFF1FBAB  6012                              sub     #1, r2
FFF1FBAD  06850231                          cmp     0F4h+var_30[sp].l, r2
FFF1FBB1  fcdbe0                            sceq.l  r14
FFF1FBB4  b891                              movu.w  4[r1], r1
FFF1FBB6  6121                              cmp     #2, r1
FFF1FBB8  3b9100                            bne.w   loc_FFF1FC49
FFF1FBBB  5bee                              movu.b  r14, r14
FFF1FBBD  610e                              cmp     #0, r14
FFF1FBBF  3a1401                            beq.w   loc_FFF1FCD3
FFF1FBC2  ed0e35                            mov.l   0F4h+var_20[sp], r14
FFF1FBC5  ed033b                            mov.l   0F4h+var_8[sp], r3
FFF1FBC8  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FBCB  6080                              sub     #8, sp
FFF1FBCD  e70e01                            mov.l   r14, 0FCh+var_F8[sp]
FFF1FBD0  f80472                            mov.b   #72h, 0FCh+var_FC[sp] ; 'r'
FFF1FBD3  6604                              mov.l   #0, r4
FFF1FBD5  710258                            add     #0FCh+var_A4, sp, r2
FFF1FBD8  05574700                          bsr.a   sub_FFF2432F
FFF1FBDC  6280                              add     #8, sp
FFF1FBDE  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FBE1  ed0e14                            mov.l   0F4h+var_A4[sp], r14
FFF1FBE4  740ef7ffff0f                      cmp     #0FFFFFF7h, r14
FFF1FBEA  18                                bne.s   loc_FFF1FBF2
FFF1FBEB  f90601c3                          mov.l   #-3Dh, 0F4h+var_F0[sp]
FFF1FBEF  389005                            bra.w   loc_FFF2017F
FFF1FBF2  ed0e14                 loc_FFF1FBF2 mov.l   0F4h+var_A4[sp], r14
FFF1FBF5  740ef8ffff0f                      cmp     #0FFFFFF8h, r14
FFF1FBFB  2311                              bltu.b  loc_FFF1FC0C
FFF1FBFD  ed0e14                            mov.l   0F4h+var_A4[sp], r14
FFF1FC00  740effffff0f                      cmp     #0FFFFFFFh, r14
FFF1FC06  2406                              bgtu.b  loc_FFF1FC0C
FFF1FC08  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF1FC0B  0c                                bra.s   loc_FFF1FC0F
FFF1FC0C  f80600                 loc_FFF1FC0C mov.l   #0, 0F4h+var_F4[sp]
FFF1FC0F  ec0e                   loc_FFF1FC0F mov.l   0F4h+var_F4[sp], r14
FFF1FC11  610e                              cmp     #0, r14
FFF1FC13  2011                              beq.b   loc_FFF1FC24
FFF1FC15  ed0335                            mov.l   0F4h+var_20[sp], r3
FFF1FC18  ed023b                            mov.l   0F4h+var_8[sp], r2
FFF1FC1B  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FC1E  39fe12                            bsr.w   sub_FFF20F1C
FFF1FC21  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF1FC23  0d                                bra.s   loc_FFF1FC28
FFF1FC24  e5001413               loc_FFF1FC24 mov.l   0F4h+var_A4[sp], 0F4h+var_A8[sp]
FFF1FC28  05b160ff               loc_FFF1FC28 bsr.a   sub_FFF15CD9
FFF1FC2C  a281                              mov.l   r1, 0F4h+var_CC[sp]
FFF1FC2E  ed0e0a                            mov.l   0F4h+var_CC[sp], r14
FFF1FC31  610e                              cmp     #0, r14
FFF1FC33  10                                beq.s   loc_FFF1FC3B
FFF1FC34  e5000a01                          mov.l   0F4h+var_CC[sp], 0F4h+var_F0[sp]
FFF1FC38  384705                            bra.w   loc_FFF2017F
FFF1FC3B  ac8a                   loc_FFF1FC3B mov.l   0F4h+var_A8[sp], r2
FFF1FC3D  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FC40  056cf3ff                          bsr.a   sub_FFF1EFAC
FFF1FC44  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF1FC46  388d00                            bra.w   loc_FFF1FCD3
FFF1FC49  5bee                   loc_FFF1FC49 movu.b  r14, r14
FFF1FC4B  610e                              cmp     #0, r14
FFF1FC4D  3a8600                            beq.w   loc_FFF1FCD3
FFF1FC50  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1FC53  ed033b                            mov.l   0F4h+var_8[sp], r3
FFF1FC56  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FC59  6080                              sub     #8, sp
FFF1FC5B  a00a                              mov.l   r2, 0FCh+var_F8[sp]
FFF1FC5D  f80472                            mov.b   #72h, 0FCh+var_FC[sp] ; 'r'
FFF1FC60  6604                              mov.l   #0, r4
FFF1FC62  710258                            add     #0FCh+var_A4, sp, r2
FFF1FC65  05ca4600                          bsr.a   sub_FFF2432F
FFF1FC69  6280                              add     #8, sp
FFF1FC6B  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FC6E  ad01                              mov.l   0F4h+var_A4[sp], r1
FFF1FC70  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF1FC76  18                                bne.s   loc_FFF1FC7E
FFF1FC77  f90601c3                          mov.l   #-3Dh, 0F4h+var_F0[sp]
FFF1FC7B  380405                            bra.w   loc_FFF2017F
FFF1FC7E  ad01                   loc_FFF1FC7E mov.l   0F4h+var_A4[sp], r1
FFF1FC80  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF1FC86  2310                              bltu.b  loc_FFF1FC96
FFF1FC88  ad01                              mov.l   0F4h+var_A4[sp], r1
FFF1FC8A  7401ffffff0f                      cmp     #0FFFFFFFh, r1
FFF1FC90  2406                              bgtu.b  loc_FFF1FC96
FFF1FC92  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF1FC95  0c                                bra.s   loc_FFF1FC99
FFF1FC96  f80600                 loc_FFF1FC96 mov.l   #0, 0F4h+var_F4[sp]
FFF1FC99  ec01                   loc_FFF1FC99 mov.l   0F4h+var_F4[sp], r1
FFF1FC9B  6101                              cmp     #0, r1
FFF1FC9D  2011                              beq.b   loc_FFF1FCAE
FFF1FC9F  ed0335                            mov.l   0F4h+var_20[sp], r3
FFF1FCA2  ed023b                            mov.l   0F4h+var_8[sp], r2
FFF1FCA5  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FCA8  397412                            bsr.w   sub_FFF20F1C
FFF1FCAB  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF1FCAD  0d                                bra.s   loc_FFF1FCB2
FFF1FCAE  e5001413               loc_FFF1FCAE mov.l   0F4h+var_A4[sp], 0F4h+var_A8[sp]
FFF1FCB2  052760ff               loc_FFF1FCB2 bsr.a   sub_FFF15CD9
FFF1FCB6  a281                              mov.l   r1, 0F4h+var_CC[sp]
FFF1FCB8  aa81                              mov.l   0F4h+var_CC[sp], r1
FFF1FCBA  6101                              cmp     #0, r1
FFF1FCBC  10                                beq.s   loc_FFF1FCC4
FFF1FCBD  e5000a01                          mov.l   0F4h+var_CC[sp], 0F4h+var_F0[sp]
FFF1FCC1  38be04                            bra.w   loc_FFF2017F
FFF1FCC4  ac8a                   loc_FFF1FCC4 mov.l   0F4h+var_A8[sp], r2
FFF1FCC6  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FCC9  05e3f2ff                          bsr.a   sub_FFF1EFAC
FFF1FCCD  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF1FCCF  f9063100                          mov.l   #0, 0F4h+var_30[sp]
FFF1FCD3  e5001112               loc_FFF1FCD3 mov.l   0F4h+var_B0[sp], 0F4h+var_AC[sp]
FFF1FCD7  e5001011                          mov.l   0F4h+var_B4[sp], 0F4h+var_B0[sp]
FFF1FCDB  e5001310                          mov.l   0F4h+var_A8[sp], 0F4h+var_B4[sp]
FFF1FCDF  ed0131                            mov.l   0F4h+var_30[sp], r1
FFF1FCE2  6211                              add     #1, r1
FFF1FCE4  e70131                            mov.l   r1, 0F4h+var_30[sp]
FFF1FCE7  ed012f                            mov.l   0F4h+var_38[sp], r1
FFF1FCEA  6211                              add     #1, r1
FFF1FCEC  e7012f                            mov.l   r1, 0F4h+var_38[sp]
FFF1FCEF  ed012f                 loc_FFF1FCEF mov.l   0F4h+var_38[sp], r1
FFF1FCF2  0685012e                          cmp     0F4h+var_3C[sp].l, r1
FFF1FCF6  2805                              bge.b   loc_FFF1FCFB
FFF1FCF8  381bfe                            bra.w   loc_FFF1FB13
FFF1FCFB  ac89                   loc_FFF1FCFB mov.l   0F4h+var_A8[sp], r1
FFF1FCFD  ed0236                            mov.l   0F4h+var_1C[sp], r2
FFF1FD00  e321                              mov.l   r1, [r2]
FFF1FD02  dd0165                            mov.w   0F4h+var_2A[sp], r1
FFF1FD05  ed0237                            mov.l   0F4h+var_18[sp], r2
FFF1FD08  e321                              mov.l   r1, [r2]
FFF1FD0A  dd0165                            mov.w   0F4h+var_2A[sp], r1
FFF1FD0D  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1FD10  db21100b                          mov.w   r1, 1620h[r2]
FFF1FD14  dd012b                            mov.w   0F4h+var_9E[sp], r1
FFF1FD17  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1FD1A  db21110b                          mov.w   r1, 1622h[r2]
FFF1FD1E  ed0135                            mov.l   0F4h+var_20[sp], r1
FFF1FD21  72112416                          add     #1624h, r1, r1
FFF1FD25  66c3                              mov.l   #0Ch, r3
FFF1FD27  710240                            add     #0F4h+var_B4, sp, r2
FFF1FD2A  054ee700                          bsr.a   sub_FFF2E478
FFF1FD2E  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1FD31  6131                              cmp     #3, r1
FFF1FD33  1f                                bne.s   loc_FFF1FD3A
FFF1FD34  3e0100                            mov.l   #0, 0F4h+var_F0[sp]
FFF1FD37  384804                            bra.w   loc_FFF2017F
FFF1FD3A  ed012d                 loc_FFF1FD3A mov.l   0F4h+var_40[sp], r1
FFF1FD3D  6111                              cmp     #1, r1
FFF1FD3F  ed0439                            mov.l   0F4h+var_10[sp], r4
FFF1FD42  dd0265                            mov.w   0F4h+var_2A[sp], r2
FFF1FD45  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1FD48  2123                              bne.b   loc_FFF1FD6B
FFF1FD4A  ed0335                            mov.l   0F4h+var_20[sp], r3
FFF1FD4D  5d052b                            movu.w  0F4h+var_9E[sp], r5
FFF1FD50  60c0                              sub     #0Ch, sp
FFF1FD52  a00d                              mov.l   r5, 100h+var_FC[sp]
FFF1FD54  a083                              mov.l   r3, 100h+var_F8[sp]
FFF1FD56  72330c04                          add     #40Ch, r3, r3
FFF1FD5A  e303                              mov.l   r3, 100h+var_100[sp]
FFF1FD5C  5f23                              movu.w  r2, r3
FFF1FD5E  71024c                            add     #100h+var_B4, sp, r2
FFF1FD61  39a621                            bsr.w   sub_FFF21F07
FFF1FD64  62c0                              add     #0Ch, sp
FFF1FD66  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FD69  2e1e                              bra.b   loc_FFF1FD87
FFF1FD6B  ed0335                 loc_FFF1FD6B mov.l   0F4h+var_20[sp], r3
FFF1FD6E  5d052b                            movu.w  0F4h+var_9E[sp], r5
FFF1FD71  60c0                              sub     #0Ch, sp
FFF1FD73  a083                              mov.l   r3, 100h+var_F8[sp]
FFF1FD75  a00d                              mov.l   r5, 100h+var_FC[sp]
FFF1FD77  f80600                            mov.l   #0, 100h+var_100[sp]
FFF1FD7A  5f23                              movu.w  r2, r3
FFF1FD7C  71024c                            add     #100h+var_B4, sp, r2
FFF1FD7F  398821                            bsr.w   sub_FFF21F07
FFF1FD82  62c0                              add     #0Ch, sp
FFF1FD84  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FD87  ed0133                 loc_FFF1FD87 mov.l   0F4h+var_28[sp], r1
FFF1FD8A  6101                              cmp     #0, r1
FFF1FD8C  10                                beq.s   loc_FFF1FD94
FFF1FD8D  e5003301                          mov.l   0F4h+var_28[sp], 0F4h+var_F0[sp]
FFF1FD91  38ee03                            bra.w   loc_FFF2017F
FFF1FD94  3e0100                 loc_FFF1FD94 mov.l   #0, 0F4h+var_F0[sp]
FFF1FD97  38e803                            bra.w   loc_FFF2017F
FFF1FD9A  aa89                   loc_FFF1FD9A mov.l   0F4h+var_C8[sp], r1
FFF1FD9C  581e                              movu.b  [r1], r14
FFF1FD9E  755ee5                            cmp     #-1Bh, r14
FFF1FDA1  211e                              bne.b   loc_FFF1FDBF
FFF1FDA3  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1FDA6  6111                              cmp     #1, r1
FFF1FDA8  17                                beq.s   loc_FFF1FDAF
FFF1FDA9  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1FDAC  6131                              cmp     #3, r1
FFF1FDAE  1d                                bne.s   loc_FFF1FDB3
FFF1FDAF  f80601                 loc_FFF1FDAF mov.l   #1, 0F4h+var_F4[sp]
FFF1FDB2  0c                                bra.s   loc_FFF1FDB6
FFF1FDB3  f80600                 loc_FFF1FDB3 mov.l   #0, 0F4h+var_F4[sp]
FFF1FDB6  ec01                   loc_FFF1FDB6 mov.l   0F4h+var_F4[sp], r1
FFF1FDB8  6101                              cmp     #0, r1
FFF1FDBA  15                                beq.s   loc_FFF1FDBF
FFF1FDBB  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF1FDBE  0c                                bra.s   loc_FFF1FDC2
FFF1FDBF  f80600                 loc_FFF1FDBF mov.l   #0, 0F4h+var_F4[sp]
FFF1FDC2  ec01                   loc_FFF1FDC2 mov.l   0F4h+var_F4[sp], r1
FFF1FDC4  6101                              cmp     #0, r1
FFF1FDC6  2043                              beq.b   loc_FFF1FE09
FFF1FDC8  ed012c                            mov.l   0F4h+var_44[sp], r1
FFF1FDCB  6211                              add     #1, r1
FFF1FDCD  5d022b                            movu.w  0F4h+var_9E[sp], r2
FFF1FDD0  4712                              cmp     r1, r2
FFF1FDD2  212c                              bne.b   loc_FFF1FDFE
FFF1FDD4  dd0165                            mov.w   0F4h+var_2A[sp], r1
FFF1FDD7  69f1                              shlr    #1Fh, r1
FFF1FDD9  6101                              cmp     #0, r1
FFF1FDDB  2023                              beq.b   loc_FFF1FDFE
FFF1FDDD  ed0130                            mov.l   0F4h+var_34[sp], r1
FFF1FDE0  d70165                            mov.w   r1, 0F4h+var_2A[sp]
FFF1FDE3  66c3                              mov.l   #0Ch, r3
FFF1FDE5  710240                            add     #0F4h+var_B4, sp, r2
FFF1FDE8  710134                            add     #0F4h+var_C0, sp, r1
FFF1FDEB  058de600                          bsr.a   sub_FFF2E478
FFF1FDEF  ac89                              mov.l   0F4h+var_A8[sp], r1
FFF1FDF1  ed0236                            mov.l   0F4h+var_1C[sp], r2
FFF1FDF4  e321                              mov.l   r1, [r2]
FFF1FDF6  dd0165                            mov.w   0F4h+var_2A[sp], r1
FFF1FDF9  ed0237                            mov.l   0F4h+var_18[sp], r2
FFF1FDFC  e321                              mov.l   r1, [r2]
FFF1FDFE  ed012c                 loc_FFF1FDFE mov.l   0F4h+var_44[sp], r1
FFF1FE01  6211                              add     #1, r1
FFF1FE03  e7012c                            mov.l   r1, 0F4h+var_44[sp]
FFF1FE06  387602                            bra.w   loc_FFF2007C
FFF1FE09  f9062c00               loc_FFF1FE09 mov.l   #0, 0F4h+var_44[sp]
FFF1FE0D  aa89                              mov.l   0F4h+var_C8[sp], r1
FFF1FE0F  f5150b                            btst    #5, 0Bh[r1].b
FFF1FE12  1f                                bne.s   loc_FFF1FE19
FFF1FE13  aa89                              mov.l   0F4h+var_C8[sp], r1
FFF1FE15  f5140b                            btst    #4, 0Bh[r1].b
FFF1FE18  15                                beq.s   loc_FFF1FE1D
FFF1FE19  f80601                 loc_FFF1FE19 mov.l   #1, 0F4h+var_F4[sp]
FFF1FE1C  0c                                bra.s   loc_FFF1FE20
FFF1FE1D  f80600                 loc_FFF1FE1D mov.l   #0, 0F4h+var_F4[sp]
FFF1FE20  ec01                   loc_FFF1FE20 mov.l   0F4h+var_F4[sp], r1
FFF1FE22  6101                              cmp     #0, r1
FFF1FE24  201c                              beq.b   loc_FFF1FE40
FFF1FE26  ed012a                            mov.l   0F4h+var_4C[sp], r1
FFF1FE29  6101                              cmp     #0, r1
FFF1FE2B  1f                                bne.s   loc_FFF1FE32
FFF1FE2C  f9055701                          mov.w   #1, 0F4h+var_46[sp]
FFF1FE30  2e53                              bra.b   loc_FFF1FE83
FFF1FE32  dd0157                 loc_FFF1FE32 mov.w   0F4h+var_46[sp], r1
FFF1FE35  6211                              add     #1, r1
FFF1FE37  d70157                            mov.w   r1, 0F4h+var_46[sp]
FFF1FE3A  f9062a00                          mov.l   #0, 0F4h+var_4C[sp]
FFF1FE3E  2e45                              bra.b   loc_FFF1FE83
FFF1FE40  ed012a                 loc_FFF1FE40 mov.l   0F4h+var_4C[sp], r1
FFF1FE43  6101                              cmp     #0, r1
FFF1FE45  fcdbe0                            sceq.l  r14
FFF1FE48  aa89                              mov.l   0F4h+var_C8[sp], r1
FFF1FE4A  b299                              movu.b  0Bh[r1], r1
FFF1FE4C  64f1                              and     #0Fh, r1
FFF1FE4E  61f1                              cmp     #0Fh, r1
FFF1FE50  211c                              bne.b   loc_FFF1FE6C
FFF1FE52  5bee                              movu.b  r14, r14
FFF1FE54  610e                              cmp     #0, r14
FFF1FE56  200c                              beq.b   loc_FFF1FE62
FFF1FE58  f9055701                          mov.w   #1, 0F4h+var_46[sp]
FFF1FE5C  f9062a01                          mov.l   #1, 0F4h+var_4C[sp]
FFF1FE60  2e23                              bra.b   loc_FFF1FE83
FFF1FE62  dd0e57                 loc_FFF1FE62 mov.w   0F4h+var_46[sp], r14
FFF1FE65  621e                              add     #1, r14
FFF1FE67  d70e57                            mov.w   r14, 0F4h+var_46[sp]
FFF1FE6A  2e19                              bra.b   loc_FFF1FE83
FFF1FE6C  5bee                   loc_FFF1FE6C movu.b  r14, r14
FFF1FE6E  610e                              cmp     #0, r14
FFF1FE70  17                                beq.s   loc_FFF1FE77
FFF1FE71  f9055701                          mov.w   #1, 0F4h+var_46[sp]
FFF1FE75  2e0e                              bra.b   loc_FFF1FE83
FFF1FE77  dd0157                 loc_FFF1FE77 mov.w   0F4h+var_46[sp], r1
FFF1FE7A  6211                              add     #1, r1
FFF1FE7C  d70157                            mov.w   r1, 0F4h+var_46[sp]
FFF1FE7F  f9062a00                          mov.l   #0, 0F4h+var_4C[sp]
FFF1FE83  aa89                   loc_FFF1FE83 mov.l   0F4h+var_C8[sp], r1
FFF1FE85  f5130b                            btst    #3, 0Bh[r1].b
FFF1FE88  15                                beq.s   loc_FFF1FE8D
FFF1FE89  f80600                            mov.l   #0, 0F4h+var_F4[sp]
FFF1FE8C  0c                                bra.s   loc_FFF1FE90
FFF1FE8D  f80601                 loc_FFF1FE8D mov.l   #1, 0F4h+var_F4[sp]
FFF1FE90  ec01                   loc_FFF1FE90 mov.l   0F4h+var_F4[sp], r1
FFF1FE92  6101                              cmp     #0, r1
FFF1FE94  3ae801                            beq.w   loc_FFF2007C
FFF1FE97  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1FE9A  6131                              cmp     #3, r1
FFF1FE9C  3ae001                            beq.w   loc_FFF2007C
FFF1FE9F  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1FEA2  6111                              cmp     #1, r1
FFF1FEA4  210c                              bne.b   loc_FFF1FEB0
FFF1FEA6  ed012d                            mov.l   0F4h+var_40[sp], r1
FFF1FEA9  6111                              cmp     #1, r1
FFF1FEAB  1d                                bne.s   loc_FFF1FEB0
FFF1FEAC  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF1FEAF  0c                                bra.s   loc_FFF1FEB3
FFF1FEB0  f80600                 loc_FFF1FEB0 mov.l   #0, 0F4h+var_F4[sp]
FFF1FEB3  ec01                   loc_FFF1FEB3 mov.l   0F4h+var_F4[sp], r1
FFF1FEB5  6101                              cmp     #0, r1
FFF1FEB7  2041                              beq.b   loc_FFF1FEF8
FFF1FEB9  ed033c                            mov.l   0F4h+var_4[sp], r3
FFF1FEBC  71027f                            add     #0F4h+var_75, sp, r2
FFF1FEBF  710166                            add     #0F4h+var_8E, sp, r1
FFF1FEC2  39c909                            bsr.w   sub_FFF2088B
FFF1FEC5  cd0166                            mov.b   0F4h+var_8E[sp], r1
FFF1FEC8  7501e5                            cmp     #-1Bh, r1
FFF1FECB  1d                                bne.s   loc_FFF1FED0
FFF1FECC  f9046605                          mov.b   #5, 0F4h+var_8E[sp]
FFF1FED0  aa89                   loc_FFF1FED0 mov.l   0F4h+var_C8[sp], r1
FFF1FED2  6040                              sub     #4, sp
FFF1FED4  710e23                            add     #0F8h+var_D5, sp, r14
FFF1FED7  e30e                              mov.l   r14, 0F8h+var_F8[sp]
FFF1FED9  710424                            add     #0F8h+var_D4, sp, r4
FFF1FEDC  72039000                          add     #0F8h+var_68, sp, r3
FFF1FEE0  71026a                            add     #0F8h+var_8E, sp, r2
FFF1FEE3  39cd12                            bsr.w   sub_FFF211B0
FFF1FEE6  6240                              add     #4, sp
FFF1FEE8  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FEEB  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1FEEE  6101                              cmp     #0, r1
FFF1FEF0  10                                beq.s   loc_FFF1FEF8
FFF1FEF1  e5003301                          mov.l   0F4h+var_28[sp], 0F4h+var_F0[sp]
FFF1FEF5  388a02                            bra.w   loc_FFF2017F
FFF1FEF8  ed043c                 loc_FFF1FEF8 mov.l   0F4h+var_4[sp], r4
FFF1FEFB  ed0335                            mov.l   0F4h+var_20[sp], r3
FFF1FEFE  aa8a                              mov.l   0F4h+var_C8[sp], r2
FFF1FF00  72330c04                          add     #40Ch, r3, r3
FFF1FF04  72019400                          add     #0F4h+var_60, sp, r1
FFF1FF08  399b23                            bsr.w   sub_FFF222A3
FFF1FF0B  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FF0E  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1FF11  6101                              cmp     #0, r1
FFF1FF13  2067                              beq.b   loc_FFF1FF7A
FFF1FF15  ed013a                            mov.l   0F4h+var_C[sp], r1
FFF1FF18  050ae700                          bsr.a   sub_FFF2E622
FFF1FF1C  61c1                              cmp     #0Ch, r1
FFF1FF1E  245c                              bgtu.b  loc_FFF1FF7A
FFF1FF20  ed033c                            mov.l   0F4h+var_4[sp], r3
FFF1FF23  71027f                            add     #0F4h+var_75, sp, r2
FFF1FF26  710166                            add     #0F4h+var_8E, sp, r1
FFF1FF29  396209                            bsr.w   sub_FFF2088B
FFF1FF2C  cd0166                            mov.b   0F4h+var_8E[sp], r1
FFF1FF2F  7501e5                            cmp     #-1Bh, r1
FFF1FF32  1d                                bne.s   loc_FFF1FF37
FFF1FF33  f9046605                          mov.b   #5, 0F4h+var_8E[sp]
FFF1FF37  aa89                   loc_FFF1FF37 mov.l   0F4h+var_C8[sp], r1
FFF1FF39  6040                              sub     #4, sp
FFF1FF3B  710e23                            add     #0F8h+var_D5, sp, r14
FFF1FF3E  e30e                              mov.l   r14, 0F8h+var_F8[sp]
FFF1FF40  710424                            add     #0F8h+var_D4, sp, r4
FFF1FF43  72039000                          add     #0F8h+var_68, sp, r3
FFF1FF47  71026a                            add     #0F8h+var_8E, sp, r2
FFF1FF4A  396612                            bsr.w   sub_FFF211B0
FFF1FF4D  6240                              add     #4, sp
FFF1FF4F  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FF52  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1FF55  6101                              cmp     #0, r1
FFF1FF57  10                                beq.s   loc_FFF1FF5F
FFF1FF58  e5003301                          mov.l   0F4h+var_28[sp], 0F4h+var_F0[sp]
FFF1FF5C  382302                            bra.w   loc_FFF2017F
FFF1FF5F  ed013a                 loc_FFF1FF5F mov.l   0F4h+var_C[sp], r1
FFF1FF62  72038c00                          add     #0F4h+var_68, sp, r3
FFF1FF66  71027f                            add     #0F4h+var_75, sp, r2
FFF1FF69  39390c                            bsr.w   sub_FFF20BA2
FFF1FF6C  ed033c                            mov.l   0F4h+var_4[sp], r3
FFF1FF6F  aa89                              mov.l   0F4h+var_C8[sp], r1
FFF1FF71  71027f                            add     #0F4h+var_75, sp, r2
FFF1FF74  391024                            bsr.w   sub_FFF22384
FFF1FF77  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FF7A  ed0133                 loc_FFF1FF7A mov.l   0F4h+var_28[sp], r1
FFF1FF7D  6101                              cmp     #0, r1
FFF1FF7F  3bfd00                            bne.w   loc_FFF2007C
FFF1FF82  aa8a                              mov.l   0F4h+var_C8[sp], r2
FFF1FF84  ed0139                            mov.l   0F4h+var_10[sp], r1
FFF1FF87  754320                            mov.l   #20h, r3 ; ' '
FFF1FF8A  05eee400                          bsr.a   sub_FFF2E478
FFF1FF8E  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1FF91  6101                              cmp     #0, r1
FFF1FF93  213b                              bne.b   loc_FFF1FFCE
FFF1FF95  ac89                              mov.l   0F4h+var_A8[sp], r1
FFF1FF97  ed0236                            mov.l   0F4h+var_1C[sp], r2
FFF1FF9A  e321                              mov.l   r1, [r2]
FFF1FF9C  ed0130                            mov.l   0F4h+var_34[sp], r1
FFF1FF9F  ed0237                            mov.l   0F4h+var_18[sp], r2
FFF1FFA2  e321                              mov.l   r1, [r2]
FFF1FFA4  ed0130                            mov.l   0F4h+var_34[sp], r1
FFF1FFA7  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1FFAA  db21100b                          mov.w   r1, 1620h[r2]
FFF1FFAE  dd012b                            mov.w   0F4h+var_9E[sp], r1
FFF1FFB1  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1FFB4  db21110b                          mov.w   r1, 1622h[r2]
FFF1FFB8  ed0135                            mov.l   0F4h+var_20[sp], r1
FFF1FFBB  72112416                          add     #1624h, r1, r1
FFF1FFBF  66c3                              mov.l   #0Ch, r3
FFF1FFC1  710240                            add     #0F4h+var_B4, sp, r2
FFF1FFC4  05b4e400                          bsr.a   sub_FFF2E478
FFF1FFC8  3e0100                            mov.l   #0, 0F4h+var_F0[sp]
FFF1FFCB  38b401                            bra.w   loc_FFF2017F
FFF1FFCE  cd01e3                 loc_FFF1FFCE mov.b   0F4h+var_11[sp], r1
FFF1FFD1  6121                              cmp     #2, r1
FFF1FFD3  3ba200                            bne.w   loc_FFF20075
FFF1FFD6  ed043c                            mov.l   0F4h+var_4[sp], r4
FFF1FFD9  5d0357                            movu.w  0F4h+var_46[sp], r3
FFF1FFDC  aa89                              mov.l   0F4h+var_C8[sp], r1
FFF1FFDE  72029400                          add     #0F4h+var_60, sp, r2
FFF1FFE2  390c22                            bsr.w   sub_FFF221EE
FFF1FFE5  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1FFE8  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1FFEB  6101                              cmp     #0, r1
FFF1FFED  10                                beq.s   loc_FFF1FFF5
FFF1FFEE  e5003301                          mov.l   0F4h+var_28[sp], 0F4h+var_F0[sp]
FFF1FFF2  388d01                            bra.w   loc_FFF2017F
FFF1FFF5  5d0157                 loc_FFF1FFF5 movu.w  0F4h+var_46[sp], r1
FFF1FFF8  06810130                          sub     0F4h+var_34[sp].l, r1
FFF1FFFC  6011                              sub     #1, r1
FFF1FFFE  e70130                            mov.l   r1, 0F4h+var_34[sp]
FFF20001  f9062e01                          mov.l   #1, 0F4h+var_3C[sp]
FFF20005  2e19                              bra.b   loc_FFF2001E
FFF20007  ed013c                 loc_FFF20007 mov.l   0F4h+var_4[sp], r1
FFF2000A  ad99                              mov.l   5Ch[r1], r1
FFF2000C  6851                              shlr    #5, r1
FFF2000E  ed0230                            mov.l   0F4h+var_34[sp], r2
FFF20011  4312                              sub     r1, r2
FFF20013  e70230                            mov.l   r2, 0F4h+var_34[sp]
FFF20016  ed012e                            mov.l   0F4h+var_3C[sp], r1
FFF20019  6211                              add     #1, r1
FFF2001B  e7012e                            mov.l   r1, 0F4h+var_3C[sp]
FFF2001E  ed0130                 loc_FFF2001E mov.l   0F4h+var_34[sp], r1
FFF20021  6101                              cmp     #0, r1
FFF20023  2ae4                              bgt.b   loc_FFF20007
FFF20025  f9062f00                          mov.l   #0, 0F4h+var_38[sp]
FFF20029  2e3d                              bra.b   loc_FFF20066
FFF2002B  710e40                 loc_FFF2002B add     #0F4h+var_B4, sp, r14
FFF2002E  ed012f                            mov.l   0F4h+var_38[sp], r1
FFF20031  fe61ee                            mov.l   [r1, r14], r14
FFF20034  610e                              cmp     #0, r14
FFF20036  2039                              beq.b   loc_FFF2006F
FFF20038  ed012f                            mov.l   0F4h+var_38[sp], r1
FFF2003B  720e9400                          add     #0F4h+var_60, sp, r14
FFF2003F  fe61e3                            mov.l   [r1, r14], r3
FFF20042  710e40                            add     #0F4h+var_B4, sp, r14
FFF20045  fe61e2                            mov.l   [r1, r14], r2
FFF20048  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF2004B  395704                            bsr.w   sub_FFF204A2
FFF2004E  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF20051  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF20054  6101                              cmp     #0, r1
FFF20056  10                                beq.s   loc_FFF2005E
FFF20057  e5003301                          mov.l   0F4h+var_28[sp], 0F4h+var_F0[sp]
FFF2005B  382401                            bra.w   loc_FFF2017F
FFF2005E  ed012f                 loc_FFF2005E mov.l   0F4h+var_38[sp], r1
FFF20061  6211                              add     #1, r1
FFF20063  e7012f                            mov.l   r1, 0F4h+var_38[sp]
FFF20066  ed012f                 loc_FFF20066 mov.l   0F4h+var_38[sp], r1
FFF20069  0685012e                          cmp     0F4h+var_3C[sp].l, r1
FFF2006D  29be                              blt.b   loc_FFF2002B
FFF2006F  3e0100                 loc_FFF2006F mov.l   #0, 0F4h+var_F0[sp]
FFF20072  380d01                            bra.w   loc_FFF2017F
FFF20075  f90601f3               loc_FFF20075 mov.l   #-0Dh, 0F4h+var_F0[sp]
FFF20079  380601                            bra.w   loc_FFF2017F
FFF2007C  aa89                   loc_FFF2007C mov.l   0F4h+var_C8[sp], r1
FFF2007E  711120                            add     #20h, r1, r1 ; ' '
FFF20081  a289                              mov.l   r1, 0F4h+var_C8[sp]
FFF20083  ed0130                            mov.l   0F4h+var_34[sp], r1
FFF20086  6211                              add     #1, r1
FFF20088  e70130                            mov.l   r1, 0F4h+var_34[sp]
FFF2008B  ed013c                 loc_FFF2008B mov.l   0F4h+var_4[sp], r1
FFF2008E  ad99                              mov.l   5Ch[r1], r1
FFF20090  6851                              shlr    #5, r1
FFF20092  06850130                          cmp     0F4h+var_34[sp].l, r1
FFF20096  2505                              bleu.b  loc_FFF2009B
FFF20098  3847f9                            bra.w   loc_FFF1F9DF
FFF2009B  ac89                   loc_FFF2009B mov.l   0F4h+var_A8[sp], r1
FFF2009D  6211                              add     #1, r1
FFF2009F  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF200A1  e5002528                          mov.l   0F4h+var_60[sp], 0F4h+var_54[sp]
FFF200A5  e5002725                          mov.l   0F4h+var_58[sp], 0F4h+var_60[sp]
FFF200A9  e5002627                          mov.l   0F4h+var_5C[sp], 0F4h+var_58[sp]
FFF200AD  e5002826                          mov.l   0F4h+var_54[sp], 0F4h+var_5C[sp]
FFF200B1  e5001112                          mov.l   0F4h+var_B0[sp], 0F4h+var_AC[sp]
FFF200B5  e5001011                          mov.l   0F4h+var_B4[sp], 0F4h+var_B0[sp]
FFF200B9  ed0131                            mov.l   0F4h+var_30[sp], r1
FFF200BC  6211                              add     #1, r1
FFF200BE  e70131                            mov.l   r1, 0F4h+var_30[sp]
FFF200C1  ab01                              mov.l   0F4h+var_C4[sp], r1
FFF200C3  6211                              add     #1, r1
FFF200C5  a301                              mov.l   r1, 0F4h+var_C4[sp]
FFF200C7  ed013c                 loc_FFF200C7 mov.l   0F4h+var_4[sp], r1
FFF200CA  b892                              movu.w  4[r1], r2
FFF200CC  06850231                          cmp     0F4h+var_30[sp].l, r2
FFF200D0  2b05                              ble.b   loc_FFF200D5
FFF200D2  389bf8                            bra.w   loc_FFF1F96D
FFF200D5  ed0235                 loc_FFF200D5 mov.l   0F4h+var_20[sp], r2
FFF200D8  ed033b                            mov.l   0F4h+var_8[sp], r3
FFF200DB  6080                              sub     #8, sp
FFF200DD  a00a                              mov.l   r2, 0FCh+var_F8[sp]
FFF200DF  f80472                            mov.b   #72h, 0FCh+var_FC[sp] ; 'r'
FFF200E2  6604                              mov.l   #0, r4
FFF200E4  710258                            add     #0FCh+var_A4, sp, r2
FFF200E7  05484200                          bsr.a   sub_FFF2432F
FFF200EB  6280                              add     #8, sp
FFF200ED  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF200F0  ad01                              mov.l   0F4h+var_A4[sp], r1
FFF200F2  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF200F8  18                                bne.s   loc_FFF20100
FFF200F9  f90601c3                          mov.l   #-3Dh, 0F4h+var_F0[sp]
FFF200FD  388200                            bra.w   loc_FFF2017F
FFF20100  ad01                   loc_FFF20100 mov.l   0F4h+var_A4[sp], r1
FFF20102  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF20108  2310                              bltu.b  loc_FFF20118
FFF2010A  ad01                              mov.l   0F4h+var_A4[sp], r1
FFF2010C  7401ffffff0f                      cmp     #0FFFFFFFh, r1
FFF20112  2406                              bgtu.b  loc_FFF20118
FFF20114  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF20117  0c                                bra.s   loc_FFF2011B
FFF20118  f80600                 loc_FFF20118 mov.l   #0, 0F4h+var_F4[sp]
FFF2011B  ec01                   loc_FFF2011B mov.l   0F4h+var_F4[sp], r1
FFF2011D  6101                              cmp     #0, r1
FFF2011F  2049                              beq.b   loc_FFF20168
FFF20121  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF20124  6101                              cmp     #0, r1
FFF20126  17                                beq.s   loc_FFF2012D
FFF20127  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF2012A  6121                              cmp     #2, r1
FFF2012C  1d                                bne.s   loc_FFF20131
FFF2012D  f80601                 loc_FFF2012D mov.l   #1, 0F4h+var_F4[sp]
FFF20130  0c                                bra.s   loc_FFF20134
FFF20131  f80600                 loc_FFF20131 mov.l   #0, 0F4h+var_F4[sp]
FFF20134  ec01                   loc_FFF20134 mov.l   0F4h+var_F4[sp], r1
FFF20136  6101                              cmp     #0, r1
FFF20138  17                                beq.s   loc_FFF2013F
FFF20139  f90601fc                          mov.l   #-4, 0F4h+var_F0[sp]
FFF2013D  2e42                              bra.b   loc_FFF2017F
FFF2013F  dd0165                 loc_FFF2013F mov.w   0F4h+var_2A[sp], r1
FFF20142  6101                              cmp     #0, r1
FFF20144  2705                              bn.b    loc_FFF20149
FFF20146  38c1f8                            bra.w   loc_FFF1FA07
FFF20149  ed0335                 loc_FFF20149 mov.l   0F4h+var_20[sp], r3
FFF2014C  ed023b                            mov.l   0F4h+var_8[sp], r2
FFF2014F  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF20152  39ca0d                            bsr.w   sub_FFF20F1C
FFF20155  a501                              mov.l   r1, 0F4h+var_A4[sp]
FFF20157  05825bff                          bsr.a   sub_FFF15CD9
FFF2015B  a281                              mov.l   r1, 0F4h+var_CC[sp]
FFF2015D  aa81                              mov.l   0F4h+var_CC[sp], r1
FFF2015F  6101                              cmp     #0, r1
FFF20161  17                                beq.s   loc_FFF20168
FFF20162  e5000a01                          mov.l   0F4h+var_CC[sp], 0F4h+var_F0[sp]
FFF20166  2e19                              bra.b   loc_FFF2017F
FFF20168  e500143b               loc_FFF20168 mov.l   0F4h+var_A4[sp], 0F4h+var_8[sp]
FFF2016C  ed023b                 loc_FFF2016C mov.l   0F4h+var_8[sp], r2
FFF2016F  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF20172  053aeeff                          bsr.a   sub_FFF1EFAC
FFF20176  a489                              mov.l   r1, 0F4h+var_A8[sp]
FFF20178  f9063100                          mov.l   #0, 0F4h+var_30[sp]
FFF2017C  384bff                            bra.w   loc_FFF200C7
FFF2017F  a809                   loc_FFF2017F mov.l   0F4h+var_F0[sp], r1
FFF20181  e70134                            mov.l   r1, 0F4h+var_24[sp]
FFF20184  673d                              rtsd    #3Dh
FFF20186  7100e8                 sub_FFF20186 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF20186
FFF20189  a109                              mov.l   r1, 18h+var_4[sp]
FFF2018B  a102                              mov.l   r2, 18h+var_8[sp]
FFF2018D  e5000502                          mov.l   18h+var_4[sp], 18h+var_10[sp]
FFF20191  a881                              mov.l   18h+var_10[sp], r1
FFF20193  cc1e                              mov.b   [r1], r14
FFF20195  6211                              add     #1, r1
FFF20197  a081                              mov.l   r1, 18h+var_10[sp]
FFF20199  755e5c                            cmp     #5Ch, r14 ; '\'
FFF2019C  2037                              beq.b   loc_FFF201D3
FFF2019E  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF201A1  2e58                              bra.b   loc_FFF201F9
FFF201A3  a881                   loc_FFF201A3 mov.l   18h+var_10[sp], r1
FFF201A5  5811                              movu.b  [r1], r1
FFF201A7  0532da00                          bsr.a   sub_FFF2DBD9
FFF201AB  6101                              cmp     #0, r1
FFF201AD  2014                              beq.b   loc_FFF201C1
FFF201AF  a881                              mov.l   18h+var_10[sp], r1
FFF201B1  a902                              mov.l   18h+var_8[sp], r2
FFF201B3  c012                              mov.b   [r1], [r2]
FFF201B5  a901                              mov.l   18h+var_8[sp], r1
FFF201B7  6211                              add     #1, r1
FFF201B9  a101                              mov.l   r1, 18h+var_8[sp]
FFF201BB  a881                              mov.l   18h+var_10[sp], r1
FFF201BD  6211                              add     #1, r1
FFF201BF  a081                              mov.l   r1, 18h+var_10[sp]
FFF201C1  a881                   loc_FFF201C1 mov.l   18h+var_10[sp], r1
FFF201C3  a902                              mov.l   18h+var_8[sp], r2
FFF201C5  c012                              mov.b   [r1], [r2]
FFF201C7  a901                              mov.l   18h+var_8[sp], r1
FFF201C9  6211                              add     #1, r1
FFF201CB  a101                              mov.l   r1, 18h+var_8[sp]
FFF201CD  a881                              mov.l   18h+var_10[sp], r1
FFF201CF  6211                              add     #1, r1
FFF201D1  a081                              mov.l   r1, 18h+var_10[sp]
FFF201D3  a881                   loc_FFF201D3 mov.l   18h+var_10[sp], r1
FFF201D5  cc1e                              mov.b   [r1], r14
FFF201D7  610e                              cmp     #0, r14
FFF201D9  200e                              beq.b   loc_FFF201E7
FFF201DB  a881                              mov.l   18h+var_10[sp], r1
FFF201DD  cc1e                              mov.b   [r1], r14
FFF201DF  755e5c                            cmp     #5Ch, r14 ; '\'
FFF201E2  15                                beq.s   loc_FFF201E7
FFF201E3  f80601                            mov.l   #1, 18h+var_18[sp]
FFF201E6  0c                                bra.s   loc_FFF201EA
FFF201E7  f80600                 loc_FFF201E7 mov.l   #0, 18h+var_18[sp]
FFF201EA  ec01                   loc_FFF201EA mov.l   18h+var_18[sp], r1
FFF201EC  6101                              cmp     #0, r1
FFF201EE  21b5                              bne.b   loc_FFF201A3
FFF201F0  a901                              mov.l   18h+var_8[sp], r1
FFF201F2  f81400                            mov.b   #0, [r1]
FFF201F5  e5000201                          mov.l   18h+var_10[sp], 18h+var_14[sp]
FFF201F9  a809                   loc_FFF201F9 mov.l   18h+var_14[sp], r1
FFF201FB  a089                              mov.l   r1, 18h+var_C[sp]
FFF201FD  6706                              rtsd    #6
FFF201FF  7200e8fd               sub_FFF201FF add     #-218h, sp, sp   ; <<<< FUNC sub_FFF201FF
FFF20203  e70185                            mov.l   r1, 218h+var_4[sp]
FFF20206  f9068300                          mov.l   #0, 218h+var_C[sp]
FFF2020A  ed0185                            mov.l   218h+var_4[sp], r1
FFF2020D  6221                              add     #2, r1
FFF2020F  e70182                            mov.l   r1, 218h+var_10[sp]
FFF20212  2e33                              bra.b   loc_FFF20245
FFF20214  ed0182                 loc_FFF20214 mov.l   218h+var_10[sp], r1
FFF20217  710202                            add     #218h+var_216, sp, r2
FFF2021A  396cff                            bsr.w   sub_FFF20186
FFF2021D  e70182                            mov.l   r1, 218h+var_10[sp]
FFF20220  8881                              mov.b   218h+var_216[sp], r1
FFF20222  6101                              cmp     #0, r1
FFF20224  202a                              beq.b   loc_FFF2024E
FFF20226  ed0182                            mov.l   218h+var_10[sp], r1
FFF20229  cc1e                              mov.b   [r1], r14
FFF2022B  610e                              cmp     #0, r14
FFF2022D  2018                              beq.b   loc_FFF20245
FFF2022F  710102                            add     #218h+var_216, sp, r1
FFF20232  05f0e300                          bsr.a   sub_FFF2E622
FFF20236  06890183                          add     218h+var_C[sp].l, r1
FFF2023A  e70183                            mov.l   r1, 218h+var_C[sp]
FFF2023D  ed0183                            mov.l   218h+var_C[sp], r1
FFF20240  6211                              add     #1, r1
FFF20242  e70183                            mov.l   r1, 218h+var_C[sp]
FFF20245  ed0182                 loc_FFF20245 mov.l   218h+var_10[sp], r1
FFF20248  cc1e                              mov.b   [r1], r14
FFF2024A  610e                              cmp     #0, r14
FFF2024C  21c8                              bne.b   loc_FFF20214
FFF2024E  ed0183                 loc_FFF2024E mov.l   218h+var_C[sp], r1
FFF20251  6231                              add     #3, r1
FFF20253  e70184                            mov.l   r1, 218h+var_8[sp]
FFF20256  6786                              rtsd    #-7Ah
FFF20258  7100e4                 sub_FFF20258 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF20258
FFF2025B  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2025D  3e0300                            mov.l   #0, 1Ch+var_10[sp]
FFF20260  3e0201                            mov.l   #1, 1Ch+var_14[sp]
FFF20263  2e68                              bra.b   loc_FFF202CB
FFF20265  a981                   loc_FFF20265 mov.l   1Ch+var_4[sp], r1
FFF20267  cc1e                              mov.b   [r1], r14
FFF20269  755e20                            cmp     #20h, r14 ; ' '
FFF2026C  14                                beq.s   loc_FFF20270
FFF2026D  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF20270  a889                   loc_FFF20270 mov.l   1Ch+var_10[sp], r1
FFF20272  6101                              cmp     #0, r1
FFF20274  15                                beq.s   loc_FFF20279
FFF20275  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF20278  0c                                bra.s   loc_FFF2027C
FFF20279  f80601                 loc_FFF20279 mov.l   #1, 1Ch+var_1C[sp]
FFF2027C  ec01                   loc_FFF2027C mov.l   1Ch+var_1C[sp], r1
FFF2027E  6101                              cmp     #0, r1
FFF20280  203f                              beq.b   loc_FFF202BF
FFF20282  a981                              mov.l   1Ch+var_4[sp], r1
FFF20284  5811                              movu.b  [r1], r1
FFF20286  0553d900                          bsr.a   sub_FFF2DBD9
FFF2028A  6101                              cmp     #0, r1
FFF2028C  11                                beq.s   loc_FFF20295
FFF2028D  a889                              mov.l   1Ch+var_10[sp], r1
FFF2028F  6211                              add     #1, r1
FFF20291  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF20293  2e32                              bra.b   loc_FFF202C5
FFF20295  fbe2d4940600           loc_FFF20295 mov.l   #694D4h, r14
FFF2029B  e4e004                            mov.l   [r14], 1Ch+var_C[sp]
FFF2029E  2e18                              bra.b   loc_FFF202B6
FFF202A0  a901                   loc_FFF202A0 mov.l   1Ch+var_C[sp], r1
FFF202A2  cc1e                              mov.b   [r1], r14
FFF202A4  a981                              mov.l   1Ch+var_4[sp], r1
FFF202A6  06041e                            cmp     [r1].b, r14
FFF202A9  1f                                bne.s   loc_FFF202B0
FFF202AA  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF202AE  2e5a                              bra.b   loc_FFF20308
FFF202B0  a901                   loc_FFF202B0 mov.l   1Ch+var_C[sp], r1
FFF202B2  6211                              add     #1, r1
FFF202B4  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF202B6  a901                   loc_FFF202B6 mov.l   1Ch+var_C[sp], r1
FFF202B8  cc1e                              mov.b   [r1], r14
FFF202BA  610e                              cmp     #0, r14
FFF202BC  21e4                              bne.b   loc_FFF202A0
FFF202BE  0f                                bra.s   loc_FFF202C5
FFF202BF  a889                   loc_FFF202BF mov.l   1Ch+var_10[sp], r1
FFF202C1  6011                              sub     #1, r1
FFF202C3  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF202C5  a981                   loc_FFF202C5 mov.l   1Ch+var_4[sp], r1
FFF202C7  6211                              add     #1, r1
FFF202C9  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF202CB  a981                   loc_FFF202CB mov.l   1Ch+var_4[sp], r1
FFF202CD  cc1e                              mov.b   [r1], r14
FFF202CF  610e                              cmp     #0, r14
FFF202D1  2194                              bne.b   loc_FFF20265
FFF202D3  a881                              mov.l   1Ch+var_14[sp], r1
FFF202D5  6101                              cmp     #0, r1
FFF202D7  17                                beq.s   loc_FFF202DE
FFF202D8  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF202DC  2e2c                              bra.b   loc_FFF20308
FFF202DE  a981                   loc_FFF202DE mov.l   1Ch+var_4[sp], r1
FFF202E0  6011                              sub     #1, r1
FFF202E2  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF202E4  a981                              mov.l   1Ch+var_4[sp], r1
FFF202E6  cc1e                              mov.b   [r1], r14
FFF202E8  755e2e                            cmp     #2Eh, r14 ; '.'
FFF202EB  11                                beq.s   loc_FFF202F4
FFF202EC  a981                              mov.l   1Ch+var_4[sp], r1
FFF202EE  cc1e                              mov.b   [r1], r14
FFF202F0  755e20                            cmp     #20h, r14 ; ' '
FFF202F3  1d                                bne.s   loc_FFF202F8
FFF202F4  f80601                 loc_FFF202F4 mov.l   #1, 1Ch+var_1C[sp]
FFF202F7  0c                                bra.s   loc_FFF202FB
FFF202F8  f80600                 loc_FFF202F8 mov.l   #0, 1Ch+var_1C[sp]
FFF202FB  ec01                   loc_FFF202FB mov.l   1Ch+var_1C[sp], r1
FFF202FD  6101                              cmp     #0, r1
FFF202FF  16                                beq.s   loc_FFF20305
FFF20300  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF20304  0c                                bra.s   loc_FFF20308
FFF20305  3e0100                 loc_FFF20305 mov.l   #0, 1Ch+var_18[sp]
FFF20308  a809                   loc_FFF20308 mov.l   1Ch+var_18[sp], r1
FFF2030A  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF2030C  6707                              rtsd    #7
FFF2030E  7200dcfd               sub_FFF2030E add     #-224h, sp, sp   ; <<<< FUNC sub_FFF2030E
FFF20312  e70188                            mov.l   r1, 224h+var_4[sp]
FFF20315  cc1e                              mov.b   [r1], r14
FFF20317  755e41                            cmp     #41h, r14 ; 'A'
FFF2031A  290c                              blt.b   loc_FFF20326
FFF2031C  ed0188                            mov.l   224h+var_4[sp], r1
FFF2031F  cc1e                              mov.b   [r1], r14
FFF20321  755e5b                            cmp     #5Bh, r14 ; '['
FFF20324  2906                              blt.b   loc_FFF2032A
FFF20326  f80601                 loc_FFF20326 mov.l   #1, 224h+var_224[sp]
FFF20329  0c                                bra.s   loc_FFF2032D
FFF2032A  f80600                 loc_FFF2032A mov.l   #0, 224h+var_224[sp]
FFF2032D  ec01                   loc_FFF2032D mov.l   224h+var_224[sp], r1
FFF2032F  6101                              cmp     #0, r1
FFF20331  2026                              beq.b   loc_FFF20357
FFF20333  ed0188                            mov.l   224h+var_4[sp], r1
FFF20336  cc1e                              mov.b   [r1], r14
FFF20338  755e61                            cmp     #61h, r14 ; 'a'
FFF2033B  290c                              blt.b   loc_FFF20347
FFF2033D  ed0188                            mov.l   224h+var_4[sp], r1
FFF20340  cc1e                              mov.b   [r1], r14
FFF20342  755e7b                            cmp     #7Bh, r14 ; '{'
FFF20345  2906                              blt.b   loc_FFF2034B
FFF20347  f80601                 loc_FFF20347 mov.l   #1, 224h+var_224[sp]
FFF2034A  0c                                bra.s   loc_FFF2034E
FFF2034B  f80600                 loc_FFF2034B mov.l   #0, 224h+var_224[sp]
FFF2034E  ec01                   loc_FFF2034E mov.l   224h+var_224[sp], r1
FFF20350  6101                              cmp     #0, r1
FFF20352  15                                beq.s   loc_FFF20357
FFF20353  f80601                            mov.l   #1, 224h+var_224[sp]
FFF20356  0c                                bra.s   loc_FFF2035A
FFF20357  f80600                 loc_FFF20357 mov.l   #0, 224h+var_224[sp]
FFF2035A  ec01                   loc_FFF2035A mov.l   224h+var_224[sp], r1
FFF2035C  6101                              cmp     #0, r1
FFF2035E  10                                beq.s   loc_FFF20366
FFF2035F  f90601f4                          mov.l   #-0Ch, 224h+var_220[sp]
FFF20363  38a600                            bra.w   loc_FFF20409
FFF20366  ed0188                 loc_FFF20366 mov.l   224h+var_4[sp], r1
FFF20369  8819                              mov.b   1[r1], r1
FFF2036B  75513a                            cmp     #3Ah, r1 ; ':'
FFF2036E  10                                beq.s   loc_FFF20376
FFF2036F  f90601ff                          mov.l   #-1, 224h+var_220[sp]
FFF20373  389600                            bra.w   loc_FFF20409
FFF20376  ed0188                 loc_FFF20376 mov.l   224h+var_4[sp], r1
FFF20379  8891                              mov.b   2[r1], r1
FFF2037B  75515c                            cmp     #5Ch, r1 ; '\'
FFF2037E  10                                beq.s   loc_FFF20386
FFF2037F  f90601ff                          mov.l   #-1, 224h+var_220[sp]
FFF20383  388600                            bra.w   loc_FFF20409
FFF20386  e5008884               loc_FFF20386 mov.l   224h+var_4[sp], 224h+var_14[sp]
FFF2038A  f9068500                          mov.l   #0, 224h+var_10[sp]
FFF2038E  2e26                              bra.b   loc_FFF203B4
FFF20390  ed0184                 loc_FFF20390 mov.l   224h+var_14[sp], r1
FFF20393  5811                              movu.b  [r1], r1
FFF20395  0544d800                          bsr.a   sub_FFF2DBD9
FFF20399  6101                              cmp     #0, r1
FFF2039B  11                                beq.s   loc_FFF203A4
FFF2039C  ed0184                            mov.l   224h+var_14[sp], r1
FFF2039F  6211                              add     #1, r1
FFF203A1  e70184                            mov.l   r1, 224h+var_14[sp]
FFF203A4  ed0184                 loc_FFF203A4 mov.l   224h+var_14[sp], r1
FFF203A7  6211                              add     #1, r1
FFF203A9  e70184                            mov.l   r1, 224h+var_14[sp]
FFF203AC  ed0185                            mov.l   224h+var_10[sp], r1
FFF203AF  6211                              add     #1, r1
FFF203B1  e70185                            mov.l   r1, 224h+var_10[sp]
FFF203B4  ed0184                 loc_FFF203B4 mov.l   224h+var_14[sp], r1
FFF203B7  cc1e                              mov.b   [r1], r14
FFF203B9  610e                              cmp     #0, r14
FFF203BB  21d5                              bne.b   loc_FFF20390
FFF203BD  ed0185                            mov.l   224h+var_10[sp], r1
FFF203C0  76010301                          cmp     #103h, r1
FFF203C4  2908                              blt.b   loc_FFF203CC
FFF203C6  f90601ff                          mov.l   #-1, 224h+var_220[sp]
FFF203CA  2e3f                              bra.b   loc_FFF20409
FFF203CC  ed0188                 loc_FFF203CC mov.l   224h+var_4[sp], r1
FFF203CF  6221                              add     #2, r1
FFF203D1  e70184                            mov.l   r1, 224h+var_14[sp]
FFF203D4  2e29                              bra.b   loc_FFF203FD
FFF203D6  ed0184                 loc_FFF203D6 mov.l   224h+var_14[sp], r1
FFF203D9  71020a                            add     #224h+var_21A, sp, r2
FFF203DC  39aafd                            bsr.w   sub_FFF20186
FFF203DF  e70184                            mov.l   r1, 224h+var_14[sp]
FFF203E2  8a81                              mov.b   224h+var_21A[sp], r1
FFF203E4  6101                              cmp     #0, r1
FFF203E6  2020                              beq.b   loc_FFF20406
FFF203E8  71010a                            add     #224h+var_21A, sp, r1
FFF203EB  396dfe                            bsr.w   sub_FFF20258
FFF203EE  e70186                            mov.l   r1, 224h+var_C[sp]
FFF203F1  ed0186                            mov.l   224h+var_C[sp], r1
FFF203F4  6101                              cmp     #0, r1
FFF203F6  17                                beq.s   loc_FFF203FD
FFF203F7  e5008601                          mov.l   224h+var_C[sp], 224h+var_220[sp]
FFF203FB  2e0e                              bra.b   loc_FFF20409
FFF203FD  ed0184                 loc_FFF203FD mov.l   224h+var_14[sp], r1
FFF20400  cc1e                              mov.b   [r1], r14
FFF20402  610e                              cmp     #0, r14
FFF20404  21d2                              bne.b   loc_FFF203D6
FFF20406  3e0100                 loc_FFF20406 mov.l   #0, 224h+var_220[sp]
FFF20409  a809                   loc_FFF20409 mov.l   224h+var_220[sp], r1
FFF2040B  e70187                            mov.l   r1, 224h+var_8[sp]
FFF2040E  6789                              rtsd    #-77h
FFF20410  7100e0                 sub_FFF20410 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF20410
FFF20413  a189                              mov.l   r1, 20h+var_4[sp]
FFF20415  a182                              mov.l   r2, 20h+var_8[sp]
FFF20417  a10b                              mov.l   r3, 20h+var_C[sp]
FFF20419  a989                              mov.l   20h+var_4[sp], r1
FFF2041B  ac9a                              mov.l   4Ch[r1], r2
FFF2041D  6102                              cmp     #0, r2
FFF2041F  a982                              mov.l   20h+var_8[sp], r2
FFF20421  211d                              bne.b   loc_FFF2043E
FFF20423  a90b                              mov.l   20h+var_C[sp], r3
FFF20425  ec33                              mov.l   [r3], r3
FFF20427  6614                              mov.l   #1, r4
FFF20429  05e8ebff                          bsr.a   sub_FFF1F011
FFF2042D  a089                              mov.l   r1, 20h+var_14[sp]
FFF2042F  a889                              mov.l   20h+var_14[sp], r1
FFF20431  6101                              cmp     #0, r1
FFF20433  16                                beq.s   loc_FFF20439
FFF20434  e10003                            mov.l   20h+var_14[sp], 20h+var_20[sp]
FFF20437  2e65                              bra.b   loc_FFF2049C
FFF20439  f80600                 loc_FFF20439 mov.l   #0, 20h+var_20[sp]
FFF2043C  2e60                              bra.b   loc_FFF2049C
FFF2043E  0530c2ff               loc_FFF2043E bsr.a   sub_FFF1C66E
FFF20442  9081                              mov.w   r1, 20h+var_1C[sp]
FFF20444  b881                              movu.w  20h+var_1C[sp], r1
FFF20446  6101                              cmp     #0, r1
FFF20448  2119                              bne.b   loc_FFF20461
FFF2044A  a982                              mov.l   20h+var_8[sp], r2
FFF2044C  a989                              mov.l   20h+var_4[sp], r1
FFF2044E  710306                            add     #20h+var_1A, sp, r3
FFF20451  05b4c2ff                          bsr.a   sub_FFF1C705
FFF20455  a089                              mov.l   r1, 20h+var_14[sp]
FFF20457  a889                              mov.l   20h+var_14[sp], r1
FFF20459  6101                              cmp     #0, r1
FFF2045B  12                                beq.s   loc_FFF20465
FFF2045C  e10003                            mov.l   20h+var_14[sp], 20h+var_20[sp]
FFF2045F  2e3d                              bra.b   loc_FFF2049C
FFF20461  d5000203               loc_FFF20461 mov.w   20h+var_1C[sp], 20h+var_1A[sp]
FFF20465  b889                   loc_FFF20465 movu.w  20h+var_1A[sp], r1
FFF20467  6011                              sub     #1, r1
FFF20469  a98a                              mov.l   20h+var_4[sp], r2
FFF2046B  068d2117                          mul     5Ch[r2].l, r1
FFF2046F  5d2328                            movu.w  50h[r2], r3
FFF20472  6c23                              shll    #2, r3
FFF20474  06892313                          add     4Ch[r2].l, r3
FFF20478  4b13                              add     r1, r3
FFF2047A  a083                              mov.l   r3, 20h+var_18[sp]
FFF2047C  a881                              mov.l   20h+var_18[sp], r1
FFF2047E  a90a                              mov.l   20h+var_C[sp], r2
FFF20480  e321                              mov.l   r1, [r2]
FFF20482  b889                              movu.w  20h+var_1A[sp], r1
FFF20484  6011                              sub     #1, r1
FFF20486  a98a                              mov.l   20h+var_4[sp], r2
FFF20488  06e1082129                        div     52h[r2].uw, r1
FFF2048D  6211                              add     #1, r1
FFF2048F  9089                              mov.w   r1, 20h+var_1A[sp]
FFF20491  b88a                              movu.w  20h+var_1A[sp], r2
FFF20493  a989                              mov.l   20h+var_4[sp], r1
FFF20495  053ec5ff                          bsr.a   sub_FFF1C9D3
FFF20499  f80600                            mov.l   #0, 20h+var_20[sp]
FFF2049C  ec01                   loc_FFF2049C mov.l   20h+var_20[sp], r1
FFF2049E  a101                              mov.l   r1, 20h+var_10[sp]
FFF204A0  6708                              rtsd    #8
FFF204A2  7100dc                 sub_FFF204A2 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF204A2
FFF204A5  a201                              mov.l   r1, 24h+var_4[sp]
FFF204A7  a18a                              mov.l   r2, 24h+var_8[sp]
FFF204A9  a183                              mov.l   r3, 24h+var_C[sp]
FFF204AB  aa01                              mov.l   24h+var_4[sp], r1
FFF204AD  ac9a                              mov.l   4Ch[r1], r2
FFF204AF  6102                              cmp     #0, r2
FFF204B1  a98a                              mov.l   24h+var_8[sp], r2
FFF204B3  211b                              bne.b   loc_FFF204CE
FFF204B5  a983                              mov.l   24h+var_C[sp], r3
FFF204B7  6614                              mov.l   #1, r4
FFF204B9  05e9ebff                          bsr.a   sub_FFF1F0A2
FFF204BD  a101                              mov.l   r1, 24h+var_14[sp]
FFF204BF  a901                              mov.l   24h+var_14[sp], r1
FFF204C1  6101                              cmp     #0, r1
FFF204C3  16                                beq.s   loc_FFF204C9
FFF204C4  e10004                            mov.l   24h+var_14[sp], 24h+var_24[sp]
FFF204C7  2e74                              bra.b   loc_FFF2053B
FFF204C9  f80600                 loc_FFF204C9 mov.l   #0, 24h+var_24[sp]
FFF204CC  2e6f                              bra.b   loc_FFF2053B
FFF204CE  05a0c1ff               loc_FFF204CE bsr.a   sub_FFF1C66E
FFF204D2  9181                              mov.w   r1, 24h+var_18[sp]
FFF204D4  b981                              movu.w  24h+var_18[sp], r1
FFF204D6  6101                              cmp     #0, r1
FFF204D8  1e                                bne.s   loc_FFF204DE
FFF204D9  f806bb                            mov.l   #-45h, 24h+var_24[sp]
FFF204DC  2e5f                              bra.b   loc_FFF2053B
FFF204DE  d5000607               loc_FFF204DE mov.w   24h+var_18[sp], 24h+var_16[sp]
FFF204E2  b989                              movu.w  24h+var_16[sp], r1
FFF204E4  6011                              sub     #1, r1
FFF204E6  aa02                              mov.l   24h+var_4[sp], r2
FFF204E8  06e1082129                        div     52h[r2].uw, r1
FFF204ED  6211                              add     #1, r1
FFF204EF  9189                              mov.w   r1, 24h+var_16[sp]
FFF204F1  b98a                              movu.w  24h+var_16[sp], r2
FFF204F3  aa01                              mov.l   24h+var_4[sp], r1
FFF204F5  05dec4ff                          bsr.a   sub_FFF1C9D3
FFF204F9  aa01                              mov.l   24h+var_4[sp], r1
FFF204FB  ad9a                              mov.l   5Ch[r1], r2
FFF204FD  06cd1229                          mul     52h[r1].uw, r2
FFF20501  6262                              add     #6, r2
FFF20503  06cd1228                          mul     50h[r1].uw, r2
FFF20507  06891213                          add     4Ch[r1].l, r2
FFF2050B  8c11                              mov.b   10h[r1], r1
FFF2050D  755140                            cmp     #40h, r1 ; '@'
FFF20510  2116                              bne.b   loc_FFF20526
FFF20512  a00a                              mov.l   r2, 24h+var_20[sp]
FFF20514  b98a                              movu.w  24h+var_16[sp], r2
FFF20516  6c12                              shll    #1, r2
FFF20518  06890201                          add     24h+var_20[sp].l, r2
FFF2051C  6022                              sub     #2, r2
FFF2051E  dc2e                              mov.w   [r2], r14
FFF20520  78fe                              bset    #0Fh, r14
FFF20522  d32e                              mov.w   r14, [r2]
FFF20524  2e14                              bra.b   loc_FFF20538
FFF20526  a082                   loc_FFF20526 mov.l   r2, 24h+var_1C[sp]
FFF20528  b989                              movu.w  24h+var_16[sp], r1
FFF2052A  6c11                              shll    #1, r1
FFF2052C  06890102                          add     24h+var_1C[sp].l, r1
FFF20530  6021                              sub     #2, r1
FFF20532  dc1e                              mov.w   [r1], r14
FFF20534  78fe                              bset    #0Fh, r14
FFF20536  d31e                              mov.w   r14, [r1]
FFF20538  f80600                 loc_FFF20538 mov.l   #0, 24h+var_24[sp]
FFF2053B  ec01                   loc_FFF2053B mov.l   24h+var_24[sp], r1
FFF2053D  a109                              mov.l   r1, 24h+var_10[sp]
FFF2053F  6709                              rtsd    #9
FFF20541  7100e8                 sub_FFF20541 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF20541
FFF20544  a109                              mov.l   r1, 18h+var_4[sp]
FFF20546  a102                              mov.l   r2, 18h+var_8[sp]
FFF20548  a08b                              mov.l   r3, 18h+var_C[sp]
FFF2054A  a909                              mov.l   18h+var_4[sp], r1
FFF2054C  a89a                              mov.l   0Ch[r1], r2
FFF2054E  06cd1204                          mul     8[r1].uw, r2
FFF20552  06c91203                          add     6[r1].uw, r2
FFF20556  06890204                          add     18h+var_8[sp].l, r2
FFF2055A  a102                              mov.l   r2, 18h+var_8[sp]
FFF2055C  a909                              mov.l   18h+var_4[sp], r1
FFF2055E  a89a                              mov.l   0Ch[r1], r2
FFF20560  06cd1204                          mul     8[r1].uw, r2
FFF20564  06c91203                          add     6[r1].uw, r2
FFF20568  b91b                              movu.w  0Ah[r1], r3
FFF2056A  6c53                              shll    #5, r3
FFF2056C  06a1091317                        divu    5Ch[r1].l, r3
FFF20571  4b32                              add     r3, r2
FFF20573  06850204                          cmp     18h+var_8[sp].l, r2
FFF20577  2407                              bgtu.b  loc_FFF2057E
FFF20579  f806f5                            mov.l   #-0Bh, 18h+var_18[sp]
FFF2057C  2e10                              bra.b   loc_FFF2058C
FFF2057E  a88b                   loc_FFF2057E mov.l   18h+var_C[sp], r3
FFF20580  a902                              mov.l   18h+var_8[sp], r2
FFF20582  a909                              mov.l   18h+var_4[sp], r1
FFF20584  398cfe                            bsr.w   sub_FFF20410
FFF20587  a009                              mov.l   r1, 18h+var_14[sp]
FFF20589  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF2058C  ec01                   loc_FFF2058C mov.l   18h+var_18[sp], r1
FFF2058E  a081                              mov.l   r1, 18h+var_10[sp]
FFF20590  6706                              rtsd    #6
FFF20592  7100ec                 sub_FFF20592 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF20592
FFF20595  a101                              mov.l   r1, 14h+var_4[sp]
FFF20597  a08a                              mov.l   r2, 14h+var_8[sp]
FFF20599  a083                              mov.l   r3, 14h+var_C[sp]
FFF2059B  a901                              mov.l   14h+var_4[sp], r1
FFF2059D  a89a                              mov.l   0Ch[r1], r2
FFF2059F  06cd1204                          mul     8[r1].uw, r2
FFF205A3  06c91203                          add     6[r1].uw, r2
FFF205A7  06890203                          add     14h+var_8[sp].l, r2
FFF205AB  a08a                              mov.l   r2, 14h+var_8[sp]
FFF205AD  a901                              mov.l   14h+var_4[sp], r1
FFF205AF  a89a                              mov.l   0Ch[r1], r2
FFF205B1  06cd1204                          mul     8[r1].uw, r2
FFF205B5  06c91203                          add     6[r1].uw, r2
FFF205B9  b91b                              movu.w  0Ah[r1], r3
FFF205BB  6c53                              shll    #5, r3
FFF205BD  06a1091317                        divu    5Ch[r1].l, r3
FFF205C2  4b32                              add     r3, r2
FFF205C4  06850203                          cmp     14h+var_8[sp].l, r2
FFF205C8  2407                              bgtu.b  loc_FFF205CF
FFF205CA  f806f5                            mov.l   #-0Bh, 14h+var_14[sp]
FFF205CD  2e0d                              bra.b   loc_FFF205DA
FFF205CF  a883                   loc_FFF205CF mov.l   14h+var_C[sp], r3
FFF205D1  a88a                              mov.l   14h+var_8[sp], r2
FFF205D3  a901                              mov.l   14h+var_4[sp], r1
FFF205D5  39cdfe                            bsr.w   sub_FFF204A2
FFF205D8  e301                              mov.l   r1, 14h+var_14[sp]
FFF205DA  ec01                   loc_FFF205DA mov.l   14h+var_14[sp], r1
FFF205DC  a009                              mov.l   r1, 14h+var_10[sp]
FFF205DE  6705                              rtsd    #5
FFF205E0  7100c8                 sub_FFF205E0 add     #-38h, sp, sp   ; <<<< FUNC sub_FFF205E0
FFF205E3  a309                              mov.l   r1, 38h+var_4[sp]
FFF205E5  a302                              mov.l   r2, 38h+var_8[sp]
FFF205E7  c7032f                            mov.b   r3, 38h+var_9[sp]
FFF205EA  710108                            add     #38h+var_30, sp, r1
FFF205ED  05d658ff                          bsr.a   sub_FFF15EC3
FFF205F1  6101                              cmp     #0, r1
FFF205F3  2040                              beq.b   loc_FFF20633
FFF205F5  a881                              mov.l   38h+var_30[sp], r1
FFF205F7  fd748102                          div     #2, r1
FFF205FB  a009                              mov.l   r1, 38h+var_34[sp]
FFF205FD  a889                              mov.l   38h+var_2C[sp], r1
FFF205FF  6c51                              shll    #5, r1
FFF20601  06950101                          or      38h+var_34[sp].l, r1
FFF20605  a009                              mov.l   r1, 38h+var_34[sp]
FFF20607  a901                              mov.l   38h+var_28[sp], r1
FFF20609  6cb1                              shll    #0Bh, r1
FFF2060B  06950101                          or      38h+var_34[sp].l, r1
FFF2060F  a009                              mov.l   r1, 38h+var_34[sp]
FFF20611  e10005                            mov.l   38h+var_24[sp], 38h+var_38[sp]
FFF20614  a981                              mov.l   38h+var_20[sp], r1
FFF20616  6211                              add     #1, r1
FFF20618  6c51                              shll    #5, r1
FFF2061A  069401                            or      [sp].l, r1
FFF2061D  e301                              mov.l   r1, 38h+var_38[sp]
FFF2061F  a989                              mov.l   38h+var_1C[sp], r1
FFF20621  755150                            cmp     #50h, r1 ; 'P'
FFF20624  2915                              blt.b   loc_FFF20639
FFF20626  a989                              mov.l   38h+var_1C[sp], r1
FFF20628  7111b0                            add     #-50h, r1, r1
FFF2062B  6c91                              shll    #9, r1
FFF2062D  069401                            or      [sp].l, r1
FFF20630  e301                              mov.l   r1, 38h+var_38[sp]
FFF20632  0f                                bra.s   loc_FFF20639
FFF20633  f80600                 loc_FFF20633 mov.l   #0, 38h+var_38[sp]
FFF20636  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF20639  f5002f                 loc_FFF20639 btst    #0, 38h+var_9[sp].b
FFF2063C  2017                              beq.b   loc_FFF20653
FFF2063E  b882                              movu.w  38h+var_34[sp], r2
FFF20640  ab09                              mov.l   38h+var_4[sp], r1
FFF20642  62e1                              add     #0Eh, r1
FFF20644  053de600                          bsr.a   sub_FFF2EC81
FFF20648  5c02                              movu.w  38h+var_38[sp], r2
FFF2064A  ab09                              mov.l   38h+var_4[sp], r1
FFF2064C  711110                            add     #10h, r1, r1
FFF2064F  0532e600                          bsr.a   sub_FFF2EC81
FFF20653  f5012f                 loc_FFF20653 btst    #1, 38h+var_9[sp].b
FFF20656  202e                              beq.b   loc_FFF20684
FFF20658  b882                              movu.w  38h+var_34[sp], r2
FFF2065A  ab09                              mov.l   38h+var_4[sp], r1
FFF2065C  711116                            add     #16h, r1, r1
FFF2065F  0522e600                          bsr.a   sub_FFF2EC81
FFF20663  5c02                              movu.w  38h+var_38[sp], r2
FFF20665  ab09                              mov.l   38h+var_4[sp], r1
FFF20667  711118                            add     #18h, r1, r1
FFF2066A  0517e600                          bsr.a   sub_FFF2EC81
FFF2066E  ab01                              mov.l   38h+var_8[sp], r1
FFF20670  6101                              cmp     #0, r1
FFF20672  2012                              beq.b   loc_FFF20684
FFF20674  a809                              mov.l   38h+var_34[sp], r1
FFF20676  ab02                              mov.l   38h+var_8[sp], r2
FFF20678  db211a01                          mov.w   r1, 234h[r2]
FFF2067C  ec01                              mov.l   38h+var_38[sp], r1
FFF2067E  ab02                              mov.l   38h+var_8[sp], r2
FFF20680  db211b01                          mov.w   r1, 236h[r2]
FFF20684  f5022f                 loc_FFF20684 btst    #2, 38h+var_9[sp].b
FFF20687  200f                              beq.b   loc_FFF20696
FFF20689  5c02                              movu.w  38h+var_38[sp], r2
FFF2068B  ab09                              mov.l   38h+var_4[sp], r1
FFF2068D  711112                            add     #12h, r1, r1
FFF20690  05f1e500                          bsr.a   sub_FFF2EC81
FFF20694  670e                              rtsd    #0Eh
FFF20696  670e                   loc_FFF20696 rtsd    #0Eh
FFF20698  7100e8                 sub_FFF20698 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF20698
FFF2069B  a109                              mov.l   r1, 18h+var_4[sp]
FFF2069D  848a                              mov.b   r2, 18h+var_5[sp]
FFF2069F  8c89                              mov.b   18h+var_5[sp], r1
FFF206A1  61c1                              cmp     #0Ch, r1
FFF206A3  17                                beq.s   loc_FFF206AA
FFF206A4  8c89                              mov.b   18h+var_5[sp], r1
FFF206A6  755110                            cmp     #10h, r1
FFF206A9  1d                                bne.s   loc_FFF206AE
FFF206AA  f80601                 loc_FFF206AA mov.l   #1, 18h+var_18[sp]
FFF206AD  0c                                bra.s   loc_FFF206B1
FFF206AE  f80600                 loc_FFF206AE mov.l   #0, 18h+var_18[sp]
FFF206B1  a909                   loc_FFF206B1 mov.l   18h+var_4[sp], r1
FFF206B3  71111a                            add     #1Ah, r1, r1
FFF206B6  ec02                              mov.l   18h+var_18[sp], r2
FFF206B8  6102                              cmp     #0, r2
FFF206BA  11                                beq.s   loc_FFF206C3
FFF206BB  05e9e500                          bsr.a   sub_FFF2ECA4
FFF206BF  a009                              mov.l   r1, 18h+var_14[sp]
FFF206C1  2e1d                              bra.b   loc_FFF206DE
FFF206C3  05e1e500               loc_FFF206C3 bsr.a   sub_FFF2ECA4
FFF206C7  9109                              mov.w   r1, 18h+var_E[sp]
FFF206C9  a909                              mov.l   18h+var_4[sp], r1
FFF206CB  711114                            add     #14h, r1, r1
FFF206CE  05d6e500                          bsr.a   sub_FFF2ECA4
FFF206D2  9101                              mov.w   r1, 18h+var_10[sp]
FFF206D4  9901                              mov.w   18h+var_10[sp], r1
FFF206D6  6d01                              shll    #10h, r1
FFF206D8  06d50105                          or      18h+var_E[sp].uw, r1
FFF206DC  a009                              mov.l   r1, 18h+var_14[sp]
FFF206DE  a809                   loc_FFF206DE mov.l   18h+var_14[sp], r1
FFF206E0  a089                              mov.l   r1, 18h+var_C[sp]
FFF206E2  6706                              rtsd    #6
FFF206E4  7100ec                 sub_FFF206E4 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF206E4
FFF206E7  a101                              mov.l   r1, 14h+var_4[sp]
FFF206E9  a08a                              mov.l   r2, 14h+var_8[sp]
FFF206EB  828b                              mov.b   r3, 14h+var_9[sp]
FFF206ED  8a89                              mov.b   14h+var_9[sp], r1
FFF206EF  61c1                              cmp     #0Ch, r1
FFF206F1  17                                beq.s   loc_FFF206F8
FFF206F2  8a89                              mov.b   14h+var_9[sp], r1
FFF206F4  755110                            cmp     #10h, r1
FFF206F7  1d                                bne.s   loc_FFF206FC
FFF206F8  f80601                 loc_FFF206F8 mov.l   #1, 14h+var_14[sp]
FFF206FB  0c                                bra.s   loc_FFF206FF
FFF206FC  f80600                 loc_FFF206FC mov.l   #0, 14h+var_14[sp]
FFF206FF  ec01                   loc_FFF206FF mov.l   14h+var_14[sp], r1
FFF20701  6101                              cmp     #0, r1
FFF20703  200f                              beq.b   loc_FFF20712
FFF20705  b982                              movu.w  14h+var_8[sp], r2
FFF20707  a901                              mov.l   14h+var_4[sp], r1
FFF20709  71111a                            add     #1Ah, r1, r1
FFF2070C  0575e500                          bsr.a   sub_FFF2EC81
FFF20710  6705                              rtsd    #5
FFF20712  a889                   loc_FFF20712 mov.l   14h+var_8[sp], r1
FFF20714  9101                              mov.w   r1, 14h+var_C[sp]
FFF20716  a889                              mov.l   14h+var_8[sp], r1
FFF20718  6901                              shlr    #10h, r1
FFF2071A  9089                              mov.w   r1, 14h+var_E[sp]
FFF2071C  b902                              movu.w  14h+var_C[sp], r2
FFF2071E  a901                              mov.l   14h+var_4[sp], r1
FFF20720  71111a                            add     #1Ah, r1, r1
FFF20723  055ee500                          bsr.a   sub_FFF2EC81
FFF20727  b88a                              movu.w  14h+var_E[sp], r2
FFF20729  a901                              mov.l   14h+var_4[sp], r1
FFF2072B  711114                            add     #14h, r1, r1
FFF2072E  0553e500                          bsr.a   sub_FFF2EC81
FFF20732  6705                              rtsd    #5
FFF20734  60c0                   sub_FFF20734 sub     #0Ch, sp   ; <<<< FUNC sub_FFF20734
FFF20736  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF20738  908a                              mov.w   r2, 0Ch+var_6[sp]
FFF2073A  9083                              mov.w   r3, 0Ch+var_8[sp]
FFF2073C  710106                            add     #0Ch+var_6, sp, r1
FFF2073F  0565e500                          bsr.a   sub_FFF2ECA4
FFF20743  9009                              mov.w   r1, 0Ch+var_A[sp]
FFF20745  710104                            add     #0Ch+var_8, sp, r1
FFF20748  055ce500                          bsr.a   sub_FFF2ECA4
FFF2074C  d301                              mov.w   r1, 0Ch+var_C[sp]
FFF2074E  b809                              movu.w  0Ch+var_A[sp], r1
FFF20750  75211f                            and     #1Fh, r1
FFF20753  6c11                              shll    #1, r1
FFF20755  a882                              mov.l   0Ch+var_4[sp], r2
FFF20757  e321                              mov.l   r1, [r2]
FFF20759  9809                              mov.w   0Ch+var_A[sp], r1
FFF2075B  6851                              shlr    #5, r1
FFF2075D  75213f                            and     #3Fh, r1 ; '?'
FFF20760  a882                              mov.l   0Ch+var_4[sp], r2
FFF20762  a029                              mov.l   r1, 4[r2]
FFF20764  b809                              movu.w  0Ch+var_A[sp], r1
FFF20766  68b1                              shlr    #0Bh, r1
FFF20768  a882                              mov.l   0Ch+var_4[sp], r2
FFF2076A  a0a1                              mov.l   r1, 8[r2]
FFF2076C  5c01                              movu.w  0Ch+var_C[sp], r1
FFF2076E  75211f                            and     #1Fh, r1
FFF20771  a882                              mov.l   0Ch+var_4[sp], r2
FFF20773  a0a9                              mov.l   r1, 0Ch[r2]
FFF20775  dc01                              mov.w   0Ch+var_C[sp], r1
FFF20777  6851                              shlr    #5, r1
FFF20779  64f1                              and     #0Fh, r1
FFF2077B  6011                              sub     #1, r1
FFF2077D  a882                              mov.l   0Ch+var_4[sp], r2
FFF2077F  a121                              mov.l   r1, 10h[r2]
FFF20781  5c01                              movu.w  0Ch+var_C[sp], r1
FFF20783  6891                              shlr    #9, r1
FFF20785  711150                            add     #50h, r1, r1 ; 'P'
FFF20788  a882                              mov.l   0Ch+var_4[sp], r2
FFF2078A  a129                              mov.l   r1, 14h[r2]
FFF2078C  a881                              mov.l   0Ch+var_4[sp], r1
FFF2078E  3e1600                            mov.l   #0, 18h[r1]
FFF20791  a881                              mov.l   0Ch+var_4[sp], r1
FFF20793  3e1700                            mov.l   #0, 1Ch[r1]
FFF20796  a881                              mov.l   0Ch+var_4[sp], r1
FFF20798  3e1800                            mov.l   #0, 20h[r1]
FFF2079B  6703                              rtsd    #3
FFF2079D  7ea6                   sub_FFF2079D push.l  r6   ; <<<< FUNC sub_FFF2079D
FFF2079F  7100e8                            add     #-18h, sp, sp
FFF207A2  a109                              mov.l   r1, 18h+var_4[sp]
FFF207A4  a102                              mov.l   r2, 18h+var_8[sp]
FFF207A6  838b                              mov.b   r3, 18h+var_9[sp]
FFF207A8  e10005                            mov.l   18h+var_4[sp], 18h+var_18[sp]
FFF207AB  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF207AE  2e3c                              bra.b   loc_FFF207EA
FFF207B0  a809                   loc_FFF207B0 mov.l   18h+var_14[sp], r1
FFF207B2  a902                              mov.l   18h+var_8[sp], r2
FFF207B4  fec21e                            movu.b  [r2, r1], r14
FFF207B7  755e20                            cmp     #20h, r14 ; ' '
FFF207BA  2036                              beq.b   loc_FFF207F0
FFF207BC  a809                              mov.l   18h+var_14[sp], r1
FFF207BE  a902                              mov.l   18h+var_8[sp], r2
FFF207C0  fec21e                            movu.b  [r2, r1], r14
FFF207C3  b389                              movu.b  18h+var_9[sp], r1
FFF207C5  6481                              and     #8, r1
FFF207C7  6181                              cmp     #8, r1
FFF207C9  ec06                              mov.l   18h+var_18[sp], r6
FFF207CB  2111                              bne.b   loc_FFF207DC
FFF207CD  cfe1                              mov.b   r14, r1
FFF207CF  05eedf00                          bsr.a   sub_FFF2E7BD
FFF207D3  c361                              mov.b   r1, [r6]
FFF207D5  ec0e                              mov.l   18h+var_18[sp], r14
FFF207D7  621e                              add     #1, r14
FFF207D9  e30e                              mov.l   r14, 18h+var_18[sp]
FFF207DB  09                                bra.s   loc_FFF207E4
FFF207DC  c36e                   loc_FFF207DC mov.b   r14, [r6]
FFF207DE  ec01                              mov.l   18h+var_18[sp], r1
FFF207E0  6211                              add     #1, r1
FFF207E2  e301                              mov.l   r1, 18h+var_18[sp]
FFF207E4  a809                   loc_FFF207E4 mov.l   18h+var_14[sp], r1
FFF207E6  6211                              add     #1, r1
FFF207E8  a009                              mov.l   r1, 18h+var_14[sp]
FFF207EA  a809                   loc_FFF207EA mov.l   18h+var_14[sp], r1
FFF207EC  6181                              cmp     #8, r1
FFF207EE  29c2                              blt.b   loc_FFF207B0
FFF207F0  3e0108                 loc_FFF207F0 mov.l   #8, 18h+var_14[sp]
FFF207F3  2e67                              bra.b   loc_FFF2085A
FFF207F5  a809                   loc_FFF207F5 mov.l   18h+var_14[sp], r1
FFF207F7  a902                              mov.l   18h+var_8[sp], r2
FFF207F9  fec21e                            movu.b  [r2, r1], r14
FFF207FC  6181                              cmp     #8, r1
FFF207FE  fcdbf0                            sceq.l  r15
FFF20801  755e20                            cmp     #20h, r14 ; ' '
FFF20804  2115                              bne.b   loc_FFF20819
FFF20806  5bfe                              movu.b  r15, r14
FFF20808  610e                              cmp     #0, r14
FFF2080A  2056                              beq.b   loc_FFF20860
FFF2080C  ec0f                              mov.l   18h+var_18[sp], r15
FFF2080E  f8f400                            mov.b   #0, [r15]
FFF20811  ec0f                              mov.l   18h+var_18[sp], r15
FFF20813  621f                              add     #1, r15
FFF20815  e30f                              mov.l   r15, 18h+var_18[sp]
FFF20817  2e49                              bra.b   loc_FFF20860
FFF20819  5bfe                   loc_FFF20819 movu.b  r15, r14
FFF2081B  610e                              cmp     #0, r14
FFF2081D  200d                              beq.b   loc_FFF2082A
FFF2081F  ec01                              mov.l   18h+var_18[sp], r1
FFF20821  f8142e                            mov.b   #2Eh, [r1] ; '.'
FFF20824  ec01                              mov.l   18h+var_18[sp], r1
FFF20826  6211                              add     #1, r1
FFF20828  e301                              mov.l   r1, 18h+var_18[sp]
FFF2082A  a809                   loc_FFF2082A mov.l   18h+var_14[sp], r1
FFF2082C  a902                              mov.l   18h+var_8[sp], r2
FFF2082E  fec21e                            movu.b  [r2, r1], r14
FFF20831  b389                              movu.b  18h+var_9[sp], r1
FFF20833  752110                            and     #10h, r1
FFF20836  755110                            cmp     #10h, r1
FFF20839  ec06                              mov.l   18h+var_18[sp], r6
FFF2083B  2111                              bne.b   loc_FFF2084C
FFF2083D  cfe1                              mov.b   r14, r1
FFF2083F  057edf00                          bsr.a   sub_FFF2E7BD
FFF20843  c361                              mov.b   r1, [r6]
FFF20845  ec0e                              mov.l   18h+var_18[sp], r14
FFF20847  621e                              add     #1, r14
FFF20849  e30e                              mov.l   r14, 18h+var_18[sp]
FFF2084B  09                                bra.s   loc_FFF20854
FFF2084C  c36e                   loc_FFF2084C mov.b   r14, [r6]
FFF2084E  ec01                              mov.l   18h+var_18[sp], r1
FFF20850  6211                              add     #1, r1
FFF20852  e301                              mov.l   r1, 18h+var_18[sp]
FFF20854  a809                   loc_FFF20854 mov.l   18h+var_14[sp], r1
FFF20856  6211                              add     #1, r1
FFF20858  a009                              mov.l   r1, 18h+var_14[sp]
FFF2085A  a809                   loc_FFF2085A mov.l   18h+var_14[sp], r1
FFF2085C  61b1                              cmp     #0Bh, r1
FFF2085E  2997                              blt.b   loc_FFF207F5
FFF20860  ec01                   loc_FFF20860 mov.l   18h+var_18[sp], r1
FFF20862  f81400                            mov.b   #0, [r1]
FFF20865  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF20868  6601                              mov.l   #0, r1
FFF2086A  3f6607                            rtsd    #1Ch, r6-r6
FFF2086D  60c0                   sub_FFF2086D sub     #0Ch, sp   ; <<<< FUNC sub_FFF2086D
FFF2086F  8289                              mov.b   r1, 0Ch+var_1[sp]
FFF20871  8282                              mov.b   r2, 0Ch+var_2[sp]
FFF20873  8a81                              mov.b   0Ch+var_2[sp], r1
FFF20875  ef1e                              mov.l   r1, r14
FFF20877  06110e0b                          and     0Ch+var_1[sp].b, r14
FFF2087B  471e                              cmp     r1, r14
FFF2087D  1d                                bne.s   loc_FFF20882
FFF2087E  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF20881  0c                                bra.s   loc_FFF20885
FFF20882  f8069d                 loc_FFF20882 mov.l   #-63h, 0Ch+var_C[sp]
FFF20885  ec01                   loc_FFF20885 mov.l   0Ch+var_C[sp], r1
FFF20887  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF20889  6703                              rtsd    #3
FFF2088B  7100e4                 sub_FFF2088B add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2088B
FFF2088E  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF20890  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF20892  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF20894  adbc                              mov.l   5Ch[r3], r4
FFF20896  a981                              mov.l   1Ch+var_4[sp], r1
FFF20898  66b3                              mov.l   #0Bh, r3
FFF2089A  754220                            mov.l   #20h, r2 ; ' '
FFF2089D  0512dc00                          bsr.a   sub_FFF2E4AF
FFF208A1  a981                              mov.l   1Ch+var_4[sp], r1
FFF208A3  3c1b00                            mov.b   #0, 0Bh[r1]
FFF208A6  3c0a00                            mov.b   #0, 1Ch+var_12[sp]
FFF208A9  3c0b00                            mov.b   #0, 1Ch+var_11[sp]
FFF208AC  2e44                              bra.b   loc_FFF208F0
FFF208AE  b289                   loc_FFF208AE movu.b  1Ch+var_11[sp], r1
FFF208B0  a90a                              mov.l   1Ch+var_8[sp], r2
FFF208B2  fe421e                            mov.b   [r2, r1], r14
FFF208B5  610e                              cmp     #0, r14
FFF208B7  2052                              beq.b   loc_FFF20909
FFF208B9  b289                              movu.b  1Ch+var_11[sp], r1
FFF208BB  a90a                              mov.l   1Ch+var_8[sp], r2
FFF208BD  fe421e                            mov.b   [r2, r1], r14

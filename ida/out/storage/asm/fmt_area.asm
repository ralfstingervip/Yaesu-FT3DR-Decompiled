; ==== fmt_area  FFF37600-FFF37B00  (file 337600-337B00) ====
FFF37600  fbe216250100                      mov.l   #12516h, r14
FFF37606  5cee                              movu.w  [r14], r14
FFF37608  71eeec                            add     #-14h, r14, r14
FFF3760B  fc47e1                            itof    r14, r1
FFF3760E  fd724100008c43                    fdiv    #438C0000h, r1
FFF37615  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF37617  fbe238830600                      mov.l   #68338h, r14
FFF3761D  06a115ee08                        utof    20h[r14].l, r14
FFF37622  fc8d0e01                          fmul    0Ch+var_8[sp].l, r14
FFF37626  fca7e1                            ftou    r14, r1
FFF37629  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF3762B  ec01                              mov.l   0Ch+var_C[sp], r1
FFF3762D  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF3762F  6703                              rtsd    #3
FFF37631  6040                   sub_FFF37631 sub     #4, sp   ; <<<< FUNC sub_FFF37631
FFF37633  3c0300                            mov.b   #0, 4+var_1[sp]
FFF37636  fbe238830600                      mov.l   #68338h, r14
FFF3763C  f8e504                            mov.w   #4, [r14]
FFF3763F  3c0300                            mov.b   #0, 4+var_1[sp]
FFF37642  2e14                              bra.b   loc_FFF37656
FFF37644  fb1238830600           loc_FFF37644 mov.l   #68338h, r1
FFF3764A  490103                            add     4+var_1[sp], r1
FFF3764D  3c1200                            mov.b   #0, 2[r1]
FFF37650  b089                              movu.b  4+var_1[sp], r1
FFF37652  6211                              add     #1, r1
FFF37654  8089                              mov.b   r1, 4+var_1[sp]
FFF37656  b089                   loc_FFF37656 movu.b  4+var_1[sp], r1
FFF37658  75511e                            cmp     #1Eh, r1
FFF3765B  29e9                              blt.b   loc_FFF37644
FFF3765D  fb1238830600                      mov.l   #68338h, r1
FFF37663  3e1800                            mov.l   #0, 20h[r1]
FFF37666  fb1238830600                      mov.l   #68338h, r1
FFF3766C  3e1900                            mov.l   #0, 24h[r1]
FFF3766F  fb1238830600                      mov.l   #68338h, r1
FFF37675  3e1a00                            mov.l   #0, 28h[r1]
FFF37678  fb1238830600                      mov.l   #68338h, r1
FFF3767E  3e1b00                            mov.l   #0, 2Ch[r1]
FFF37681  fbe268830600                      mov.l   #68368h, r14
FFF37687  fbf238830600                      mov.l   #68338h, r15
FFF3768D  e1fe0a                            mov.l   28h[r15], [r14]
FFF37690  fbe21a250100                      mov.l   #1251Ah, r14
FFF37696  f8e514                            mov.w   #14h, [r14]
FFF37699  fb121a250100                      mov.l   #1251Ah, r1
FFF3769F  3d116e                            mov.w   #6Eh, 2[r1] ; 'n'
FFF376A2  fbe216250100                      mov.l   #12516h, r14
FFF376A8  fbf21a250100                      mov.l   #1251Ah, r15
FFF376AE  d0fe                              mov.w   [r15], [r14]
FFF376B0  d5fe0101                          mov.w   2[r15], 2[r14]
FFF376B4  6611                              mov.l   #1, r1
FFF376B6  39a601                            bsr.w   sub_FFF3785C
FFF376B9  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF376BF  58ef                              movu.b  [r14], r15
FFF376C1  621f                              add     #1, r15
FFF376C3  c3ef                              mov.b   r15, [r14]
FFF376C5  6701                              rtsd    #1
FFF376C7  6080                   sub_FFF376C7 sub     #8, sp   ; <<<< FUNC sub_FFF376C7
FFF376C9  05648cfb                          bsr.a   sub_FFEF032D
FFF376CD  059130fc                          bsr.a   sub_FFEFA75E
FFF376D1  3d0101                            mov.w   #1, 8+var_6[sp]
FFF376D4  b809                              movu.w  8+var_6[sp], r1
FFF376D6  63a1                              mul     #0Ah, r1
FFF376D8  711178                            add     #78h, r1, r1 ; 'x'
FFF376DB  fb2a4001                          mov.l   #140h, r2
FFF376DF  4312                              sub     r1, r2
FFF376E1  fd748202                          div     #2, r2
FFF376E5  908a                              mov.w   r2, 8+var_2[sp]
FFF376E7  3d0204                            mov.w   #4, 8+var_4[sp]
FFF376EA  b80b                              movu.w  8+var_6[sp], r3
FFF376EC  b882                              movu.w  8+var_4[sp], r2
FFF376EE  b889                              movu.w  8+var_2[sp], r1
FFF376F0  6040                              sub     #4, sp
FFF376F2  f90901ffff                        mov.w   #-1, 0Ch+var_A[sp]
FFF376F7  f8050a                            mov.w   #0Ah, 0Ch+var_C[sp]
FFF376FA  fb425caef4ff                      mov.l   #aVoicePlay, r4; "VOICE PLAY"
FFF37700  053e34fc                          bsr.a   sub_FFEFAB3E
FFF37704  6240                              add     #4, sp
FFF37706  66e4                              mov.l   #0Eh, r4
FFF37708  fb3a1801                          mov.l   #118h, r3
FFF3770C  75426e                            mov.l   #6Eh, r2 ; 'n'
FFF3770F  754114                            mov.l   #14h, r1
FFF37712  057a30fc                          bsr.a   sub_FFEFA78C
FFF37716  6661                              mov.l   #6, r1
FFF37718  057727fc                          bsr.a   sub_FFEF9E8F
FFF3771C  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF37722  58ef                              movu.b  [r14], r15
FFF37724  621f                              add     #1, r15
FFF37726  c3ef                              mov.b   r15, [r14]
FFF37728  6702                              rtsd    #2
FFF3772A  6040                   sub_FFF3772A sub     #4, sp   ; <<<< FUNC sub_FFF3772A
FFF3772C  6040                              sub     #4, sp
FFF3772E  3d00f0                            mov.w   #-10h, [sp]
FFF37731  fb4a4001                          mov.l   #140h, r4
FFF37735  6602                              mov.l   #0, r2
FFF37737  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF3773D  ef23                              mov.l   r2, r3
FFF3773F  057c82fb                          bsr.a   sub_FFEEF9BB
FFF37743  6240                              add     #4, sp
FFF37745  8089                              mov.b   r1, 4+var_1[sp]
FFF37747  b089                              movu.b  4+var_1[sp], r1
FFF37749  6111                              cmp     #1, r1
FFF3774B  1a                                bne.s   loc_FFF37755
FFF3774C  397002                            bsr.w   sub_FFF379BC
FFF3774F  05208cfb                          bsr.a   sub_FFEF036F
FFF37753  6701                              rtsd    #1
FFF37755  6701                   loc_FFF37755 rtsd    #1
FFF37757  6040                   sub_FFF37757 sub     #4, sp   ; <<<< FUNC sub_FFF37757
FFF37759  6040                              sub     #4, sp
FFF3775B  3d009f                            mov.w   #-61h, [sp]
FFF3775E  fb4a4001                          mov.l   #140h, r4
FFF37762  75431c                            mov.l   #1Ch, r3
FFF37765  6602                              mov.l   #0, r2
FFF37767  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF3776D  054e82fb                          bsr.a   sub_FFEEF9BB
FFF37771  6240                              add     #4, sp
FFF37773  8089                              mov.b   r1, 4+var_1[sp]
FFF37775  b089                              movu.b  4+var_1[sp], r1
FFF37777  6111                              cmp     #1, r1
FFF37779  2110                              bne.b   loc_FFF37789
FFF3777B  75421c                            mov.l   #1Ch, r2
FFF3777E  6601                              mov.l   #0, r1
FFF37780  390b03                            bsr.w   sub_FFF37A8B
FFF37783  05ec8bfb                          bsr.a   sub_FFEF036F
FFF37787  6701                              rtsd    #1
FFF37789  6701                   loc_FFF37789 rtsd    #1
FFF3778B  6040                   sub_FFF3778B sub     #4, sp   ; <<<< FUNC sub_FFF3778B
FFF3778D  fbe2738f0000                      mov.l   #8F73h, r14
FFF37793  58e1                              movu.b  [r14], r1
FFF37795  7111f0                            add     #-10h, r1, r1
FFF37798  8081                              mov.b   r1, 4+var_2[sp]
FFF3779A  b081                              movu.b  4+var_2[sp], r1
FFF3779C  6c31                              shll    #3, r1
FFF3779E  fb520860ecff                      mov.l   #unk_FFEC6008, r5
FFF377A4  4b15                              add     r1, r5
FFF377A6  b8d4                              movu.w  4[r5], r4
FFF377A8  b85b                              movu.w  2[r5], r3
FFF377AA  5c52                              movu.w  [r5], r2
FFF377AC  6040                              sub     #4, sp
FFF377AE  d15003                            mov.w   6[r5], 8+var_8[sp]
FFF377B1  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF377B7  050482fb                          bsr.a   sub_FFEEF9BB
FFF377BB  6240                              add     #4, sp
FFF377BD  8089                              mov.b   r1, 4+var_1[sp]
FFF377BF  b089                              movu.b  4+var_1[sp], r1
FFF377C1  6111                              cmp     #1, r1
FFF377C3  210e                              bne.b   loc_FFF377D1
FFF377C5  b081                              movu.b  4+var_2[sp], r1
FFF377C7  053eadfb                          bsr.a   sub_FFEF2505
FFF377CB  05a48bfb                          bsr.a   sub_FFEF036F
FFF377CF  6701                              rtsd    #1
FFF377D1  6701                   loc_FFF377D1 rtsd    #1
FFF377D3  6040                   sub_FFF377D3 sub     #4, sp   ; <<<< FUNC sub_FFF377D3
FFF377D5  056a88fb                          bsr.a   sub_FFEF003F
FFF377D9  fbe2738f0000                      mov.l   #8F73h, r14
FFF377DF  c3e1                              mov.b   r1, [r14]
FFF377E1  fbe2738f0000                      mov.l   #8F73h, r14
FFF377E7  58ee                              movu.b  [r14], r14
FFF377E9  755eff                            cmp     #-1, r14
FFF377EC  19                                bne.s   loc_FFF377F5
FFF377ED  39cf03                            bsr.w   sub_FFF37BBC
FFF377F0  6601                              mov.l   #0, r1
FFF377F2  396a00                            bsr.w   sub_FFF3785C
FFF377F5  fbe2738f0000           loc_FFF377F5 mov.l   #8F73h, r14
FFF377FB  58ee                              movu.b  [r14], r14
FFF377FD  755eff                            cmp     #-1, r14
FFF37800  2013                              beq.b   loc_FFF37813
FFF37802  fbe2738f0000                      mov.l   #8F73h, r14
FFF37808  58ee                              movu.b  [r14], r14
FFF3780A  755e12                            cmp     #12h, r14
FFF3780D  2406                              bgtu.b  loc_FFF37813
FFF3780F  f80601                            mov.l   #1, 4+var_4[sp]
FFF37812  0c                                bra.s   loc_FFF37816
FFF37813  f80600                 loc_FFF37813 mov.l   #0, 4+var_4[sp]
FFF37816  ec01                   loc_FFF37816 mov.l   4+var_4[sp], r1
FFF37818  6101                              cmp     #0, r1
FFF3781A  2029                              beq.b   loc_FFF37843
FFF3781C  056883fb                          bsr.a   sub_FFEEFB84
FFF37820  6101                              cmp     #0, r1
FFF37822  2121                              bne.b   loc_FFF37843
FFF37824  fbe2738f0000                      mov.l   #8F73h, r14
FFF3782A  58e1                              movu.b  [r14], r1
FFF3782C  05be87fb                          bsr.a   sub_FFEEFFEA
FFF37830  fbe2738f0000                      mov.l   #8F73h, r14
FFF37836  58ee                              movu.b  [r14], r14
FFF37838  fbf2ac81edff                      mov.l   #off_FFED81AC, r15
FFF3783E  fe6efe                            mov.l   [r14, r15], r14
FFF37841  7f1e                              jsr     r14
FFF37843  fbe24c8c0000           loc_FFF37843 mov.l   #8C4Ch, r14
FFF37849  58ee                              movu.b  [r14], r14
FFF3784B  614e                              cmp     #4, r14
FFF3784D  290d                              blt.b   loc_FFF3785A
FFF3784F  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF37855  f8e403                            mov.b   #3, [r14]
FFF37858  6701                              rtsd    #1
FFF3785A  6701                   loc_FFF3785A rtsd    #1
FFF3785C  6040                   sub_FFF3785C sub     #4, sp   ; <<<< FUNC sub_FFF3785C
FFF3785E  8089                              mov.b   r1, 4+var_1[sp]
FFF37860  0509c8fb                          bsr.a   sub_FFEF4069
FFF37864  391400                            bsr.w   sub_FFF37878
FFF37867  0553c8fb                          bsr.a   sub_FFEF40BA
FFF3786B  b089                              movu.b  4+var_1[sp], r1
FFF3786D  6111                              cmp     #1, r1
FFF3786F  1f                                bne.s   loc_FFF37876
FFF37870  05bc87fb                          bsr.a   sub_FFEF002C
FFF37874  6701                              rtsd    #1
FFF37876  6701                   loc_FFF37876 rtsd    #1
FFF37878  7100e4                 sub_FFF37878 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF37878
FFF3787B  fbe299220100                      mov.l   #12299h, r14
FFF37881  58ee                              movu.b  [r14], r14
FFF37883  611e                              cmp     #1, r14
FFF37885  2155                              bne.b   loc_FFF378DA
FFF37887  3d0101                            mov.w   #1, 1Ch+var_1A[sp]
FFF3788A  3d0872                            mov.w   #72h, 1Ch+var_C[sp] ; 'r'
FFF3788D  3d073a                            mov.w   #3Ah, 1Ch+var_E[sp] ; ':'
FFF37890  fbe2d0940600                      mov.l   #694D0h, r14
FFF37896  e4e002                            mov.l   [r14], 1Ch+var_14[sp]
FFF37899  a883                              mov.l   1Ch+var_14[sp], r3
FFF3789B  710204                            add     #1Ch+var_18, sp, r2
FFF3789E  710113                            add     #1Ch+var_9, sp, r1
FFF378A1  39bc02                            bsr.w   sub_FFF37B5D
FFF378A4  b80b                              movu.w  1Ch+var_1A[sp], r3
FFF378A6  b98a                              movu.w  1Ch+var_E[sp], r2
FFF378A8  ba01                              movu.w  1Ch+var_C[sp], r1
FFF378AA  6040                              sub     #4, sp
FFF378AC  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF378B1  f80508                            mov.w   #8, 20h+var_20[sp]
FFF378B4  710417                            add     #20h+var_9, sp, r4
FFF378B7  058732fc                          bsr.a   sub_FFEFAB3E
FFF378BB  6240                              add     #4, sp
FFF378BD  fbe238830600                      mov.l   #68338h, r14
FFF378C3  e50e0208                          mov.l   1Ch+var_14[sp], 20h[r14]
FFF378C7  fbe238830600                      mov.l   #68338h, r14
FFF378CD  e50e0109                          mov.l   1Ch+var_18[sp], 24h[r14]
FFF378D1  fbe299220100                      mov.l   #12299h, r14
FFF378D7  f8e400                            mov.b   #0, [r14]
FFF378DA  fbe2468e0000           loc_FFF378DA mov.l   #8E46h, r14
FFF378E0  71e220                            add     #20h, r14, r2 ; ' '
FFF378E3  71ee30                            add     #30h, r14, r14 ; '0'
FFF378E6  432e                              sub     r2, r14
FFF378E8  5be3                              movu.b  r14, r3
FFF378EA  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF378F0  711120                            add     #20h, r1, r1 ; ' '
FFF378F3  fb4e008000                        mov.l   #8000h, r4
FFF378F8  0595a7fb                          bsr.a   sub_FFEF208D
FFF378FC  3c8b00                            mov.b   #0, 1Ch+var_1[sp]
FFF378FF  388500                            bra.w   loc_FFF37984
FFF37902  b689                   loc_FFF37902 movu.b  1Ch+var_1[sp], r1
FFF37904  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF3790A  4b1e                              add     r1, r14
FFF3790C  59ee30                            movu.b  30h[r14], r14
FFF3790F  fbf2468e0000                      mov.l   #8E46h, r15
FFF37915  4b1f                              add     r1, r15
FFF37917  45fe30                            cmp     30h[r15], r14
FFF3791A  2026                              beq.b   loc_FFF37940
FFF3791C  b68a                              movu.b  1Ch+var_1[sp], r2
FFF3791E  fb1e000001                        mov.l   #10000h, r1
FFF37923  fd6221                            shll    r2, r1
FFF37926  057e85fb                          bsr.a   sub_FFEEFEA4
FFF3792A  b689                              movu.b  1Ch+var_1[sp], r1
FFF3792C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF37932  4b1e                              add     r1, r14
FFF37934  fbf2468e0000                      mov.l   #8E46h, r15
FFF3793A  4b1f                              add     r1, r15
FFF3793C  c5fe3030                          mov.b   30h[r15], 30h[r14]
FFF37940  b689                   loc_FFF37940 movu.b  1Ch+var_1[sp], r1
FFF37942  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF37948  4b1e                              add     r1, r14
FFF3794A  59ee33                            movu.b  33h[r14], r14
FFF3794D  fbf2468e0000                      mov.l   #8E46h, r15
FFF37953  4b1f                              add     r1, r15
FFF37955  45fe33                            cmp     33h[r15], r14
FFF37958  2026                              beq.b   loc_FFF3797E
FFF3795A  b68a                              movu.b  1Ch+var_1[sp], r2
FFF3795C  fb1e000001                        mov.l   #10000h, r1
FFF37961  fd6221                            shll    r2, r1
FFF37964  054085fb                          bsr.a   sub_FFEEFEA4
FFF37968  b689                              movu.b  1Ch+var_1[sp], r1
FFF3796A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF37970  4b1e                              add     r1, r14
FFF37972  fbf2468e0000                      mov.l   #8E46h, r15
FFF37978  4b1f                              add     r1, r15
FFF3797A  c5fe3333                          mov.b   33h[r15], 33h[r14]
FFF3797E  b689                   loc_FFF3797E movu.b  1Ch+var_1[sp], r1
FFF37980  6211                              add     #1, r1
FFF37982  8689                              mov.b   r1, 1Ch+var_1[sp]
FFF37984  b689                   loc_FFF37984 movu.b  1Ch+var_1[sp], r1
FFF37986  6131                              cmp     #3, r1
FFF37988  2805                              bge.b   loc_FFF3798D
FFF3798A  3878ff                            bra.w   loc_FFF37902
FFF3798D  fb1238830600           loc_FFF3798D mov.l   #68338h, r1
FFF37993  aa91                              mov.l   28h[r1], r1
FFF37995  fbe268830600                      mov.l   #68368h, r14
FFF3799B  0684e1                            cmp     [r14].l, r1
FFF3799E  201c                              beq.b   loc_FFF379BA
FFF379A0  fbe238830600                      mov.l   #68338h, r14
FFF379A6  fbf268830600                      mov.l   #68368h, r15
FFF379AC  e4fe0a                            mov.l   [r15], 28h[r14]
FFF379AF  fb1e008000                        mov.l   #8000h, r1
FFF379B4  05f084fb                          bsr.a   sub_FFEEFEA4
FFF379B8  6707                              rtsd    #7
FFF379BA  6707                   loc_FFF379BA rtsd    #7
FFF379BC  7100d4                 sub_FFF379BC add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF379BC
FFF379BF  3d041c                            mov.w   #1Ch, 2Ch+var_24[sp]
FFF379C2  fbe2798d0000                      mov.l   #8D79h, r14
FFF379C8  f8e400                            mov.b   #0, [r14]
FFF379CB  6601                              mov.l   #0, r1
FFF379CD  ef12                              mov.l   r1, r2
FFF379CF  05398afb                          bsr.a   sub_FFEF0408
FFF379D3  f9042b00                          mov.b   #0, 2Ch+var_1[sp]
FFF379D7  2e52                              bra.b   loc_FFF37A29
FFF379D9  59012b                 loc_FFF379D9 movu.b  2Ch+var_1[sp], r1
FFF379DC  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF379E2  4b1e                              add     r1, r14
FFF379E4  59ee21                            movu.b  21h[r14], r14
FFF379E7  710f0c                            add     #2Ch+var_20, sp, r15
FFF379EA  fe0f1e                            mov.b   r14, [r15, r1]
FFF379ED  59012b                            movu.b  2Ch+var_1[sp], r1
FFF379F0  710e0c                            add     #2Ch+var_20, sp, r14
FFF379F3  fece1e                            movu.b  [r14, r1], r14
FFF379F6  610e                              cmp     #0, r14
FFF379F8  200f                              beq.b   loc_FFF37A07
FFF379FA  59012b                            movu.b  2Ch+var_1[sp], r1
FFF379FD  710e0c                            add     #2Ch+var_20, sp, r14
FFF37A00  fece1e                            movu.b  [r14, r1], r14
FFF37A03  755eff                            cmp     #-1, r14
FFF37A06  1d                                bne.s   loc_FFF37A0B
FFF37A07  f80601                 loc_FFF37A07 mov.l   #1, 2Ch+var_2C[sp]
FFF37A0A  0c                                bra.s   loc_FFF37A0E
FFF37A0B  f80600                 loc_FFF37A0B mov.l   #0, 2Ch+var_2C[sp]
FFF37A0E  ec01                   loc_FFF37A0E mov.l   2Ch+var_2C[sp], r1
FFF37A10  6101                              cmp     #0, r1
FFF37A12  200f                              beq.b   loc_FFF37A21
FFF37A14  59012b                            movu.b  2Ch+var_1[sp], r1
FFF37A17  710e0c                            add     #2Ch+var_20, sp, r14
FFF37A1A  660f                              mov.l   #0, r15
FFF37A1C  fe0e1f                            mov.b   r15, [r14, r1]
FFF37A1F  2e11                              bra.b   loc_FFF37A30
FFF37A21  59012b                 loc_FFF37A21 movu.b  2Ch+var_1[sp], r1
FFF37A24  6211                              add     #1, r1
FFF37A26  c7012b                            mov.b   r1, 2Ch+var_1[sp]
FFF37A29  59012b                 loc_FFF37A29 movu.b  2Ch+var_1[sp], r1
FFF37A2C  61f1                              cmp     #0Fh, r1
FFF37A2E  29ab                              blt.b   loc_FFF379D9
FFF37A30  71010c                 loc_FFF37A30 add     #2Ch+var_20, sp, r1
FFF37A33  49012b                            add     2Ch+var_1[sp], r1
FFF37A36  fb2267aef4ff                      mov.l   #aWav_1, r2; ".wav"
FFF37A3C  0514db00                          bsr.a   sub_FFF45550
FFF37A40  c5002b2a                          mov.b   2Ch+var_1[sp], 2Ch+var_2[sp]
FFF37A44  3d0301                            mov.w   #1, 2Ch+var_26[sp]
FFF37A47  b889                              movu.w  2Ch+var_26[sp], r1
FFF37A49  62c1                              add     #0Ch, r1
FFF37A4B  59022a                            movu.b  2Ch+var_2[sp], r2
FFF37A4E  6242                              add     #4, r2
FFF37A50  4f21                              mul     r2, r1
FFF37A52  fb2a4001                          mov.l   #140h, r2
FFF37A56  4312                              sub     r1, r2
FFF37A58  fd748202                          div     #2, r2
FFF37A5C  910a                              mov.w   r2, 2Ch+var_22[sp]
FFF37A5E  3d0424                            mov.w   #24h, 2Ch+var_24[sp] ; '$'
FFF37A61  59042a                            movu.b  2Ch+var_2[sp], r4
FFF37A64  b88b                              movu.w  2Ch+var_26[sp], r3
FFF37A66  b902                              movu.w  2Ch+var_24[sp], r2
FFF37A68  b909                              movu.w  2Ch+var_22[sp], r1
FFF37A6A  6040                              sub     #4, sp
FFF37A6C  6244                              add     #4, r4
FFF37A6E  d304                              mov.w   r4, 30h+var_30[sp]
FFF37A70  f90901ffff                        mov.w   #-1, 30h+var_2E[sp]
FFF37A75  710410                            add     #30h+var_20, sp, r4
FFF37A78  05c630fc                          bsr.a   sub_FFEFAB3E
FFF37A7C  6240                              add     #4, sp
FFF37A7E  75421c                            mov.l   #1Ch, r2
FFF37A81  6601                              mov.l   #0, r1
FFF37A83  390800                            bsr.w   sub_FFF37A8B
FFF37A86  39bc00                            bsr.w   sub_FFF37B42
FFF37A89  670b                              rtsd    #0Bh
FFF37A8B  7100e4                 sub_FFF37A8B add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF37A8B
FFF37A8E  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF37A90  9302                              mov.w   r2, 1Ch+var_4[sp]
FFF37A92  754455                            mov.l   #55h, r4 ; 'U'
FFF37A95  fb3a4001                          mov.l   #140h, r3
FFF37A99  754266                            mov.l   #66h, r2 ; 'f'
FFF37A9C  6601                              mov.l   #0, r1
FFF37A9E  05598afb                          bsr.a   sub_FFEF04F7
FFF37AA2  3d0101                            mov.w   #1, 1Ch+var_1A[sp]
FFF37AA5  3d0b72                            mov.w   #72h, 1Ch+var_6[sp] ; 'r'
FFF37AA8  fb1238830600                      mov.l   #68338h, r1
FFF37AAE  aa93                              mov.l   28h[r1], r3
FFF37AB0  710208                            add     #1Ch+var_14, sp, r2
FFF37AB3  71010c                            add     #1Ch+var_10, sp, r1
FFF37AB6  39a700                            bsr.w   sub_FFF37B5D
FFF37AB9  fbe238830600                      mov.l   #68338h, r14
FFF37ABF  e50e020b                          mov.l   1Ch+var_14[sp], 2Ch[r14]
FFF37AC3  b80b                              movu.w  1Ch+var_1A[sp], r3
FFF37AC5  ba89                              movu.w  1Ch+var_6[sp], r1
FFF37AC7  6040                              sub     #4, sp
FFF37AC9  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF37ACE  f80508                            mov.w   #8, 20h+var_20[sp]
FFF37AD1  710410                            add     #20h+var_10, sp, r4
FFF37AD4  754296                            mov.l   #-6Ah, r2
FFF37AD7  056730fc                          bsr.a   sub_FFEFAB3E
FFF37ADB  6240                              add     #4, sp
FFF37ADD  fbe238830600                      mov.l   #68338h, r14
FFF37AE3  06a115ee09                        utof    24h[r14].l, r14
FFF37AE8  06a1150102                        utof    1Ch+var_14[sp].l, r1
FFF37AED  fc93e1                            fdiv    r14, r1
FFF37AF0  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF37AF2  a809                              mov.l   1Ch+var_18[sp], r1
FFF37AF4  fd723100008c43                    fmul    #438C0000h, r1
FFF37AFB  fca711                            ftou    r1, r1
FFF37AFE  9281                              mov.w   r1, 1Ch+var_8[sp]

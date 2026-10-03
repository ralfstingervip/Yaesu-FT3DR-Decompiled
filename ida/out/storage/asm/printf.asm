; ==== printf  FFF45F00-FFF46400  (file 345F00-346400) ====
FFF45F00  c6f5ff6601             sub_FFF45F00 mov.b   66FFh[r15], 1[r5]   ; <<<< FUNC sub_FFF45F00
FFF45F05  f88616                            mov.l   #16h, [r8]
FFF45F08  2e36                              bra.b   loc_FFF45F3E
FFF45F0A  621e                   loc_FFF45F0A add     #1, r14
FFF45F0C  fd38e7                 loc_FFF45F0C movu.b  [r14+], r7
FFF45F0F  755762                            cmp     #62h, r7 ; 'b'
FFF45F12  16                                beq.s   loc_FFF45F18
FFF45F13  75572b                            cmp     #2Bh, r7 ; '+'
FFF45F16  211a                              bne.b   loc_FFF45F30
FFF45F18  755762                 loc_FFF45F18 cmp     #62h, r7 ; 'b'
FFF45F1B  5f37                              movu.w  r3, r7
FFF45F1D  18                                bne.s   loc_FFF45F25
FFF45F1E  7c57                              btst    #5, r7
FFF45F20  2110                              bne.b   loc_FFF45F30
FFF45F22  7853                              bset    #5, r3
FFF45F24  08                                bra.s   loc_FFF45F2C
FFF45F25  6437                   loc_FFF45F25 and     #3, r7
FFF45F27  6137                              cmp     #3, r7
FFF45F29  17                                beq.s   loc_FFF45F30
FFF45F2A  6533                              or      #3, r3
FFF45F2C  d363                   loc_FFF45F2C mov.w   r3, [r6]
FFF45F2E  2ede                              bra.b   loc_FFF45F0C
FFF45F30  610f                   loc_FFF45F30 cmp     #0, r15
FFF45F32  210e                              bne.b   loc_FFF45F40
FFF45F34  cf4e                              mov.b   r4, r14
FFF45F36  610e                              cmp     #0, r14
FFF45F38  2721                              bn.b    loc_FFF45F59
FFF45F3A  80ec                              mov.b   r4, 3[r6]
FFF45F3C  ef61                   loc_FFF45F3C mov.l   r6, r1
FFF45F3E  2e27                   loc_FFF45F3E bra.b   loc_FFF45F65
FFF45F40  6105                   loc_FFF45F40 cmp     #0, r5
FFF45F42  5f32                              movu.w  r3, r2
FFF45F44  13                                beq.s   loc_FFF45F47
FFF45F45  7862                              bset    #6, r2
FFF45F47  755555                 loc_FFF45F47 cmp     #55h, r5 ; 'U'
FFF45F4A  eff1                              mov.l   r15, r1
FFF45F4C  fcdb30                            sceq.l  r3
FFF45F4F  05880a00                          bsr.a   sub_FFF469D7
FFF45F53  6101                              cmp     #0, r1
FFF45F55  80e9                              mov.b   r1, 3[r6]
FFF45F57  26e5                              bpz.b   loc_FFF45F3C
FFF45F59  ec87                   loc_FFF45F59 mov.l   [r8], r7
FFF45F5B  ef61                              mov.l   r6, r1
FFF45F5D  0568f5ff                          bsr.a   sub_FFF454C5
FFF45F61  6601                              mov.l   #0, r1
FFF45F63  e387                              mov.l   r7, [r8]
FFF45F65  3f6803                 loc_FFF45F65 rtsd    #0Ch, r6-r8
FFF45F68  6e67                   sub_FFF45F68 pushm   r6-r7   ; <<<< FUNC sub_FFF45F68
FFF45F6A  fbe27489edff                      mov.l   #unk_FFED8974, r14
FFF45F70  6606                              mov.l   #0, r6
FFF45F72  ecee                              mov.l   [r14], r14
FFF45F74  fb7214ce0100                      mov.l   #1CE14h, r7
FFF45F7A  47e6                   loc_FFF45F7A cmp     r14, r6
FFF45F7C  222c                              bgeu.b  loc_FFF45FA8
FFF45F7E  ec71                              mov.l   [r7], r1
FFF45F80  6101                              cmp     #0, r1
FFF45F82  2013                              beq.b   loc_FFF45F95
FFF45F84  5c1f                              movu.w  [r1], r15
FFF45F86  610f                              cmp     #0, r15
FFF45F88  17                                beq.s   loc_FFF45F8F
FFF45F89  6247                              add     #4, r7
FFF45F8B  6216                              add     #1, r6
FFF45F8D  2eed                              bra.b   loc_FFF45F7A
FFF45F8F  f8197fff               loc_FFF45F8F mov.w   #-81h, [r1]
FFF45F93  2e14                              bra.b   loc_FFF45FA7
FFF45F95  754148                 loc_FFF45F95 mov.l   #48h, r1 ; 'H'
FFF45F98  050b0e00                          bsr.a   sub_FFF46DA3
FFF45F9C  6101                              cmp     #0, r1
FFF45F9E  200c                              beq.b   loc_FFF45FAA
FFF45FA0  e371                              mov.l   r1, [r7]
FFF45FA2  3d1080                            mov.w   #-80h, [r1]
FFF45FA5  8096                              mov.b   r6, 2[r1]
FFF45FA7  0b                     loc_FFF45FA7 bra.s   loc_FFF45FAA
FFF45FA8  6601                   loc_FFF45FA8 mov.l   #0, r1
FFF45FAA  3f6702                 loc_FFF45FAA rtsd    #8, r6-r7
FFF45FAD  5c1e                   sub_FFF45FAD movu.w  [r1], r14   ; <<<< FUNC sub_FFF45FAD
FFF45FAF  7c7e                              btst    #7, r14
FFF45FB1  211f                              bne.b   loc_FFF45FD0
FFF45FB3  711244                            add     #44h, r1, r2 ; 'D'
FFF45FB6  f81500                            mov.w   #0, [r1]
FFF45FB9  3c13ff                            mov.b   #-1, 3[r1]
FFF45FBC  a01a                              mov.l   r2, 4[r1]
FFF45FBE  a09a                              mov.l   r2, 0Ch[r1]
FFF45FC0  a112                              mov.l   r2, 10h[r1]
FFF45FC2  a292                              mov.l   r2, 28h[r1]
FFF45FC4  a11a                              mov.l   r2, 14h[r1]
FFF45FC6  a29a                              mov.l   r2, 2Ch[r1]
FFF45FC8  a192                              mov.l   r2, 18h[r1]
FFF45FCA  711224                            add     #24h, r1, r2 ; '$'
FFF45FCD  a19a                              mov.l   r2, 1Ch[r1]
FFF45FCF  02                                rts
FFF45FD0  fbe27489edff           loc_FFF45FD0 mov.l   #unk_FFED8974, r14
FFF45FD6  660f                              mov.l   #0, r15
FFF45FD8  ecee                              mov.l   [r14], r14
FFF45FDA  fb5214ce0100                      mov.l   #1CE14h, r5
FFF45FE0  47ef                   loc_FFF45FE0 cmp     r14, r15
FFF45FE2  220f                              bgeu.b  loc_FFF45FF1
FFF45FE4  068451                            cmp     [r5].l, r1
FFF45FE7  17                                beq.s   loc_FFF45FEE
FFF45FE8  6245                              add     #4, r5
FFF45FEA  621f                              add     #1, r15
FFF45FEC  2ef4                              bra.b   loc_FFF45FE0
FFF45FEE  f85600                 loc_FFF45FEE mov.l   #0, [r5]
FFF45FF1  05c60400               loc_FFF45FF1 bsr.a   sub_FFF464B7
FFF45FF5  02                                rts
FFF45FF6  6e6d                   sub_FFF45FF6 pushm   r6-r13   ; <<<< FUNC sub_FFF45FF6
FFF45FF8  72006cff                          add     #-94h, sp, sp
FFF45FFC  ef36                              mov.l   r3, r6
FFF45FFE  a581                              mov.l   r1, 94h+var_3C[sp]
FFF46000  71014c                            add     #94h+var_48, sp, r1
FFF46003  a58a                              mov.l   r2, 94h+var_38[sp]
FFF46005  ef42                              mov.l   r4, r2
FFF46007  05000a00                          bsr.a   sub_FFF46A07
FFF4600B  ed012e                            mov.l   94h+arg_0[sp], r1
FFF4600E  72078c00                          add     #94h+var_8, sp, r7
FFF46012  fb8288970600                      mov.l   #69788h, r8
FFF46018  fb9271e9c3ff                      mov.l   #asc_FFC3E971, r9; " +-#0,;:_"
FFF4601E  fbd2c089edff                      mov.l   #unk_FFED89C0, r13
FFF46024  f9062100                          mov.l   #0, 94h+var_10[sp]
FFF46028  c7018f                            mov.b   r1, 94h+var_5[sp]
FFF4602B  586c                   loc_FFF4602B movu.b  [r6], r12
FFF4602D  610c                              cmp     #0, r12
FFF4602F  fcdbb1                            scne.l  r11
FFF46032  755c25                            cmp     #25h, r12 ; '%'
FFF46035  efba                              mov.l   r11, r10
FFF46037  1c                                bne.s   loc_FFF4603B
FFF46038  71baff                            add     #-1, r11, r10
FFF4603B  610a                   loc_FFF4603B cmp     #0, r10
FFF4603D  2b1a                              ble.b   loc_FFF46057
FFF4603F  ad89                              mov.l   94h+var_38[sp], r1
FFF46041  ef62                              mov.l   r6, r2
FFF46043  ad84                              mov.l   94h+var_3C[sp], r4
FFF46045  efa3                              mov.l   r10, r3
FFF46047  7f14                              jsr     r4
FFF46049  6101                              cmp     #0, r1
FFF4604B  a589                              mov.l   r1, 94h+var_38[sp]
FFF4604D  3a0502                            beq.w   loc_FFF46252
FFF46050  06890a21                          add     94h+var_10[sp].l, r10
FFF46054  e70a21                            mov.l   r10, 94h+var_10[sp]
FFF46057  4b6b                   loc_FFF46057 add     r6, r11
FFF46059  755c25                            cmp     #25h, r12 ; '%'
FFF4605C  3bfb01                            bne.w   loc_FFF46257
FFF4605F  610c                              cmp     #0, r12
FFF46061  660c                              mov.l   #0, r12
FFF46063  fcdbe1                            scne.l  r14
FFF46066  4be6                              add     r14, r6
FFF46068  3e8f00                            mov.l   #0, 94h+var_18[sp]
FFF4606B  ec8e                   loc_FFF4606B mov.l   [r8], r14
FFF4606D  716501                            add     #1, r6, r5
FFF46070  586f                              movu.b  [r6], r15
FFF46072  fedfee                            movu.w  [r15, r14], r14
FFF46075  7c5e                              btst    #5, r14
FFF46077  2016                              beq.b   loc_FFF4608D
FFF46079  63ac                              mul     #0Ah, r12
FFF4607B  ef56                              mov.l   r5, r6
FFF4607D  4bfc                              add     r15, r12
FFF4607F  71ccd0                            add     #-30h, r12, r12
FFF46082  760ce703                          cmp     #3E7h, r12
FFF46086  e70c1f                            mov.l   r12, 94h+var_18[sp]
FFF46089  2be2                              ble.b   loc_FFF4606B
FFF4608B  ef56                              mov.l   r5, r6
FFF4608D  fd386e                 loc_FFF4608D movu.b  [r6+], r14
FFF46090  755e24                            cmp     #24h, r14 ; '$'
FFF46093  19                                bne.s   loc_FFF4609C
FFF46094  601c                              sub     #1, r12
FFF46096  760ce603                          cmp     #3E6h, r12
FFF4609A  2507                              bleu.b  loc_FFF460A1
FFF4609C  efb6                   loc_FFF4609C mov.l   r11, r6
FFF4609E  3e8f00                            mov.l   #0, 94h+var_18[sp]
FFF460A1  660b                   loc_FFF460A1 mov.l   #0, r11
FFF460A3  ef6c                              mov.l   r6, r12
FFF460A5  e70b1e                            mov.l   r11, 94h+var_1C[sp]
FFF460A8  e70b1d                            mov.l   r11, 94h+var_20[sp]
FFF460AB  e70b1c                            mov.l   r11, 94h+var_24[sp]
FFF460AE  e70b1b                            mov.l   r11, 94h+var_28[sp]
FFF460B1  e70b1a                            mov.l   r11, 94h+var_2C[sp]
FFF460B4  e70b19                            mov.l   r11, 94h+var_30[sp]
FFF460B7  f9049020                          mov.b   #20h, 94h+var_4[sp] ; ' '
FFF460BB  d70b46                            mov.w   r11, 94h+var_8[sp]
FFF460BE  58c2                   loc_FFF460BE movu.b  [r12], r2
FFF460C0  ef91                              mov.l   r9, r1
FFF460C2  05320c00                          bsr.a   sub_FFF46CF4
FFF460C6  6101                              cmp     #0, r1
FFF460C8  201f                              beq.b   loc_FFF460E7
FFF460CA  4391                              sub     r9, r1
FFF460CC  6141                              cmp     #4, r1
FFF460CE  2410                              bgtu.b  loc_FFF460DE
FFF460D0  6c21                              shll    #2, r1
FFF460D2  4bd1                              add     r13, r1
FFF460D4  dc11                              mov.w   [r1], r1
FFF460D6  06550146                          or      94h+var_8[sp].w, r1
FFF460DA  d70146                            mov.w   r1, 94h+var_8[sp]
FFF460DD  0c                                bra.s   loc_FFF460E1
FFF460DE  c4c090                 loc_FFF460DE mov.b   [r12], 94h+var_4[sp]
FFF460E1  621b                   loc_FFF460E1 add     #1, r11
FFF460E3  621c                              add     #1, r12
FFF460E5  2ed9                              bra.b   loc_FFF460BE
FFF460E7  58ce                   loc_FFF460E7 movu.b  [r12], r14
FFF460E9  755e2a                            cmp     #2Ah, r14 ; '*'
FFF460EC  2120                              bne.b   loc_FFF4610C
FFF460EE  ed0c13                            mov.l   94h+var_48[sp], r12
FFF460F1  71c104                            add     #4, r12, r1
FFF460F4  a489                              mov.l   r1, 94h+var_48[sp]
FFF460F6  eccc                              mov.l   [r12], r12
FFF460F8  610c                              cmp     #0, r12
FFF460FA  e70c22                            mov.l   r12, 94h+var_C[sp]
FFF460FD  2609                              bpz.b   loc_FFF46106
FFF460FF  7e1c                              neg     r12
FFF46101  e70c22                            mov.l   r12, 94h+var_C[sp]
FFF46104  f072                              bset    #2, [r7].b
FFF46106  4b6b                   loc_FFF46106 add     r6, r11
FFF46108  621b                              add     #1, r11
FFF4610A  2e33                              bra.b   loc_FFF4613D
FFF4610C  660e                   loc_FFF4610C mov.l   #0, r14
FFF4610E  efec                              mov.l   r14, r12
FFF46110  f9062200                          mov.l   #0, 94h+var_C[sp]
FFF46114  ec8f                   loc_FFF46114 mov.l   [r8], r15
FFF46116  ff25eb                            add     r14, r11, r5
FFF46119  fec654                            movu.b  [r6, r5], r4
FFF4611C  4b65                              add     r6, r5
FFF4611E  fed4ff                            movu.w  [r4, r15], r15
FFF46121  7c5f                              btst    #5, r15
FFF46123  2018                              beq.b   loc_FFF4613B
FFF46125  740cffffff7f                      cmp     #7FFFFFFFh, r12
FFF4612B  200c                              beq.b   loc_FFF46137
FFF4612D  63ac                              mul     #0Ah, r12
FFF4612F  4b4c                              add     r4, r12
FFF46131  71ccd0                            add     #-30h, r12, r12
FFF46134  e70c22                            mov.l   r12, 94h+var_C[sp]
FFF46137  621e                   loc_FFF46137 add     #1, r14
FFF46139  2edb                              bra.b   loc_FFF46114
FFF4613B  ef5b                   loc_FFF4613B mov.l   r5, r11
FFF4613D  58be                   loc_FFF4613D movu.b  [r11], r14
FFF4613F  755e2e                            cmp     #2Eh, r14 ; '.'
FFF46142  2142                              bne.b   loc_FFF46184
FFF46144  59b601                            movu.b  1[r11], r6
FFF46147  75562a                            cmp     #2Ah, r6 ; '*'
FFF4614A  2111                              bne.b   loc_FFF4615B
FFF4614C  ac8e                              mov.l   94h+var_48[sp], r6
FFF4614E  622b                              add     #2, r11
FFF46150  716c04                            add     #4, r6, r12
FFF46153  e70c13                            mov.l   r12, 94h+var_48[sp]
FFF46156  e46020                            mov.l   [r6], 94h+var_14[sp]
FFF46159  2e2f                              bra.b   loc_FFF46188
FFF4615B  621b                   loc_FFF4615B add     #1, r11
FFF4615D  6606                              mov.l   #0, r6
FFF4615F  f9062000                          mov.l   #0, 94h+var_14[sp]
FFF46163  ec8e                   loc_FFF46163 mov.l   [r8], r14
FFF46165  58bf                              movu.b  [r11], r15
FFF46167  fedfee                            movu.w  [r15, r14], r14
FFF4616A  7c5e                              btst    #5, r14
FFF4616C  201c                              beq.b   loc_FFF46188
FFF4616E  7406ffffff7f                      cmp     #7FFFFFFFh, r6
FFF46174  200c                              beq.b   loc_FFF46180
FFF46176  63a6                              mul     #0Ah, r6
FFF46178  4bf6                              add     r15, r6
FFF4617A  7166d0                            add     #-30h, r6, r6
FFF4617D  e70620                            mov.l   r6, 94h+var_14[sp]
FFF46180  621b                   loc_FFF46180 add     #1, r11
FFF46182  2ee1                              bra.b   loc_FFF46163
FFF46184  f90620ff               loc_FFF46184 mov.l   #-1, 94h+var_14[sp]
FFF46188  58b2                   loc_FFF46188 movu.b  [r11], r2
FFF4618A  fb621cb0f4ff                      mov.l   #aHjltzl, r6; "hjltzL"
FFF46190  ef61                              mov.l   r6, r1
FFF46192  05620b00                          bsr.a   sub_FFF46CF4
FFF46196  6101                              cmp     #0, r1
FFF46198  660e                              mov.l   #0, r14
FFF4619A  14                                beq.s   loc_FFF4619E
FFF4619B  fd38be                            movu.b  [r11+], r14
FFF4619E  5bef                   loc_FFF4619E movu.b  r14, r15
FFF461A0  610f                              cmp     #0, r15
FFF461A2  c70e8e                            mov.b   r14, 94h+var_6[sp]
FFF461A5  210f                              bne.b   loc_FFF461B4
FFF461A7  58bf                              movu.b  [r11], r15
FFF461A9  755f76                            cmp     #76h, r15 ; 'v'
FFF461AC  18                                bne.s   loc_FFF461B4
FFF461AD  621b                              add     #1, r11
FFF461AF  effe                              mov.l   r15, r14
FFF461B1  c70f8e                            mov.b   r15, 94h+var_6[sp]
FFF461B4  5bee                   loc_FFF461B4 movu.b  r14, r14
FFF461B6  755e68                            cmp     #68h, r14 ; 'h'
FFF461B9  18                                bne.s   loc_FFF461C1
FFF461BA  58bf                              movu.b  [r11], r15
FFF461BC  755f76                            cmp     #76h, r15 ; 'v'
FFF461BF  204a                              beq.b   loc_FFF46209
FFF461C1  755e76                 loc_FFF461C1 cmp     #76h, r14 ; 'v'
FFF461C4  18                                bne.s   loc_FFF461CC
FFF461C5  58bf                              movu.b  [r11], r15
FFF461C7  755f68                            cmp     #68h, r15 ; 'h'
FFF461CA  203f                              beq.b   loc_FFF46209
FFF461CC  755e6c                 loc_FFF461CC cmp     #6Ch, r14 ; 'l'
FFF461CF  18                                bne.s   loc_FFF461D7
FFF461D0  58bf                              movu.b  [r11], r15
FFF461D2  755f76                            cmp     #76h, r15 ; 'v'
FFF461D5  202f                              beq.b   loc_FFF46204
FFF461D7  755e76                 loc_FFF461D7 cmp     #76h, r14 ; 'v'
FFF461DA  18                                bne.s   loc_FFF461E2
FFF461DB  58bf                              movu.b  [r11], r15
FFF461DD  755f6c                            cmp     #6Ch, r15 ; 'l'
FFF461E0  2024                              beq.b   loc_FFF46204
FFF461E2  755e68                 loc_FFF461E2 cmp     #68h, r14 ; 'h'
FFF461E5  210e                              bne.b   loc_FFF461F3
FFF461E7  58bf                              movu.b  [r11], r15
FFF461E9  755f68                            cmp     #68h, r15 ; 'h'
FFF461EC  1f                                bne.s   loc_FFF461F3
FFF461ED  f9048e62                          mov.b   #62h, 94h+var_6[sp] ; 'b'
FFF461F1  2e1c                              bra.b   loc_FFF4620D
FFF461F3  755e6c                 loc_FFF461F3 cmp     #6Ch, r14 ; 'l'
FFF461F6  2119                              bne.b   locret_FFF4620F
FFF461F8  58be                              movu.b  [r11], r14
FFF461FA  755e6c                            cmp     #6Ch, r14 ; 'l'
FFF461FD  2112                              bne.b   locret_FFF4620F
FFF461FF  f9048e71                          mov.b   #71h, 94h+var_6[sp] ; 'q'
FFF46203  0a                                bra.s   loc_FFF4620D
FFF46204  f9048e57               loc_FFF46204 mov.b   #57h, 94h+var_6[sp] ; 'W'
FFF46208  0d                                bra.s   loc_FFF4620D
FFF46209  f9048e77               loc_FFF46209 mov.b   #77h, 94h+var_6[sp] ; 'w'
FFF4620D  621b                   loc_FFF4620D add     #1, r11
FFF4620F  af8e                   locret_FFF4620F mov.l   94h+var_18[sp], r6
FFF46211  6106                              cmp     #0, r6
FFF46213  2b1c                              ble.b   loc_FFF4622F
FFF46215  6016                              sub     #1, r6
FFF46217  ef0c                              mov.l   sp, r12
FFF46219  efc1                              mov.l   r12, r1
FFF4621B  a78e                              mov.l   r6, 94h+var_18[sp]
FFF4621D  ac8a                              mov.l   94h+var_48[sp], r2
FFF4621F  05e80700                          bsr.a   sub_FFF46A07
FFF46223  58b3                              movu.b  [r11], r3
FFF46225  710404                            add     #94h+var_90, sp, r4
FFF46228  710150                            add     #94h+var_44, sp, r1
FFF4622B  efc2                              mov.l   r12, r2
FFF4622D  2e0d                              bra.b   loc_FFF4623A
FFF4622F  58b3                   loc_FFF4622F movu.b  [r11], r3
FFF46231  710404                            add     #94h+var_90, sp, r4
FFF46234  71024c                            add     #94h+var_48, sp, r2
FFF46237  710150                            add     #94h+var_44, sp, r1
FFF4623A  05000300               loc_FFF4623A bsr.a   sub_FFF4653A
FFF4623E  6101                              cmp     #0, r1
FFF46240  2112                              bne.b   loc_FFF46252
FFF46242  710204                            add     #94h+var_90, sp, r2
FFF46245  710150                            add     #94h+var_44, sp, r1
FFF46248  05c70700                          bsr.a   sub_FFF46A0F
FFF4624C  621b                              add     #1, r11
FFF4624E  6101                              cmp     #0, r1
FFF46250  260a                              bpz.b   loc_FFF4625A
FFF46252  fb16ff                 loc_FFF46252 mov.l   #-1, r1
FFF46255  2e0d                              bra.b   loc_FFF46262
FFF46257  610c                   loc_FFF46257 cmp     #0, r12
FFF46259  16                                beq.s   loc_FFF4625F
FFF4625A  efb6                   loc_FFF4625A mov.l   r11, r6
FFF4625C  38cffd                            bra.w   loc_FFF4602B
FFF4625F  ed0121                 loc_FFF4625F mov.l   94h+var_10[sp], r1
FFF46262  3f6d2d                 loc_FFF46262 rtsd    #0B4h, r6-r13
FFF46265  6e6d                   sub_FFF46265 pushm   r6-r13   ; <<<< FUNC sub_FFF46265
FFF46267  60c0                              sub     #0Ch, sp
FFF46269  6606                              mov.l   #0, r6
FFF4626B  ef37                              mov.l   r3, r7
FFF4626D  ef1d                              mov.l   r1, r13
FFF4626F  a082                              mov.l   r2, 0Ch+var_4[sp]
FFF46271  581c                   loc_FFF46271 movu.b  [r1], r12
FFF46273  711b01                            add     #1, r1, r11
FFF46276  fb2220eac3ff                      mov.l   #unk_FFC3EA20, r2
FFF4627C  fec2ce                            movu.b  [r2, r12], r14
FFF4627F  7c6e                              btst    #6, r14
FFF46281  2019                              beq.b   loc_FFF4629A
FFF46283  efb1                              mov.l   r11, r1
FFF46285  efd2                              mov.l   r13, r2
FFF46287  05830a00                          bsr.a   sub_FFF46D0A
FFF4628B  6216                              add     #1, r6
FFF4628D  6101                              cmp     #0, r1
FFF4628F  efb1                              mov.l   r11, r1
FFF46291  20e0                              beq.b   loc_FFF46271
FFF46293  660c                   loc_FFF46293 mov.l   #0, r12
FFF46295  efc1                   loc_FFF46295 mov.l   r12, r1
FFF46297  3f6d0b                            rtsd    #2Ch, r6-r13 ; ','
FFF4629A  755c2b                 loc_FFF4629A cmp     #2Bh, r12 ; '+'
FFF4629D  200c                              beq.b   loc_FFF462A9
FFF4629F  755c2d                            cmp     #2Dh, r12 ; '-'
FFF462A2  17                                beq.s   loc_FFF462A9
FFF462A3  6606                              mov.l   #0, r6
FFF462A5  a00e                              mov.l   r6, 0Ch+var_8[sp]
FFF462A7  2e1c                              bra.b   loc_FFF462C3
FFF462A9  4bd6                   loc_FFF462A9 add     r13, r6
FFF462AB  6216                              add     #1, r6
FFF462AD  ef61                              mov.l   r6, r1
FFF462AF  efd2                              mov.l   r13, r2
FFF462B1  05590a00                          bsr.a   sub_FFF46D0A
FFF462B5  755c2d                            cmp     #2Dh, r12 ; '-'
FFF462B8  fcdb20                            sceq.l  r2
FFF462BB  6101                              cmp     #0, r1
FFF462BD  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF462BF  21d4                              bne.b   loc_FFF46293
FFF462C1  ef61                              mov.l   r6, r1
FFF462C3  6107                   loc_FFF462C3 cmp     #0, r7
FFF462C5  ef16                              mov.l   r1, r6
FFF462C7  2145                              bne.b   loc_FFF4630C
FFF462C9  586e                              movu.b  [r6], r14
FFF462CB  66a7                              mov.l   #0Ah, r7
FFF462CD  755e30                            cmp     #30h, r14 ; '0'
FFF462D0  2173                              bne.b   loc_FFF46343
FFF462D2  716c01                            add     #1, r6, r12
FFF462D5  efc1                              mov.l   r12, r1
FFF462D7  efd2                              mov.l   r13, r2
FFF462D9  05310a00                          bsr.a   sub_FFF46D0A
FFF462DD  6101                              cmp     #0, r1
FFF462DF  21b4                              bne.b   loc_FFF46293
FFF462E1  b06f                              movu.b  1[r6], r7
FFF462E3  fb1220eac3ff                      mov.l   #unk_FFC3EA20, r1
FFF462E9  fec17e                            movu.b  [r1, r7], r14
FFF462EC  7c0e                              btst    #0, r14
FFF462EE  14                                beq.s   loc_FFF462F2
FFF462EF  717720                            add     #20h, r7, r7 ; ' '
FFF462F2  755778                 loc_FFF462F2 cmp     #78h, r7 ; 'x'
FFF462F5  6687                              mov.l   #8, r7
FFF462F7  214a                              bne.b   loc_FFF46341
FFF462F9  6226                              add     #2, r6
FFF462FB  ef61                              mov.l   r6, r1
FFF462FD  efd2                              mov.l   r13, r2
FFF462FF  050b0a00                          bsr.a   sub_FFF46D0A
FFF46303  6101                              cmp     #0, r1
FFF46305  754710                            mov.l   #10h, r7
FFF46308  218b                              bne.b   loc_FFF46293
FFF4630A  2e39                              bra.b   loc_FFF46343
FFF4630C  755710                 loc_FFF4630C cmp     #10h, r7
FFF4630F  2134                              bne.b   loc_FFF46343
FFF46311  586e                              movu.b  [r6], r14
FFF46313  755e30                            cmp     #30h, r14 ; '0'
FFF46316  212d                              bne.b   loc_FFF46343
FFF46318  b069                              movu.b  1[r6], r1
FFF4631A  716c01                            add     #1, r6, r12
FFF4631D  fb2220eac3ff                      mov.l   #unk_FFC3EA20, r2
FFF46323  fec21e                            movu.b  [r2, r1], r14
FFF46326  7c0e                              btst    #0, r14
FFF46328  14                                beq.s   loc_FFF4632C
FFF46329  711120                            add     #20h, r1, r1 ; ' '
FFF4632C  755178                 loc_FFF4632C cmp     #78h, r1 ; 'x'
FFF4632F  1d                                bne.s   loc_FFF46334
FFF46330  6226                              add     #2, r6
FFF46332  ef6c                              mov.l   r6, r12
FFF46334  efc1                   loc_FFF46334 mov.l   r12, r1
FFF46336  efd2                              mov.l   r13, r2
FFF46338  05d20900                          bsr.a   sub_FFF46D0A
FFF4633C  6101                              cmp     #0, r1
FFF4633E  3b55ff                            bne.w   loc_FFF46293
FFF46341  efc6                   loc_FFF46341 mov.l   r12, r6
FFF46343  717efe                 loc_FFF46343 add     #-2, r7, r14
FFF46346  755e22                            cmp     #22h, r14 ; '"'
FFF46349  2505                              bleu.b  loc_FFF4634E
FFF4634B  38ff00                            bra.w   loc_FFF4644A
FFF4634E  61b7                   loc_FFF4634E cmp     #0Bh, r7
FFF46350  2906                              blt.b   loc_FFF46356
FFF46352  717e56                            add     #56h, r7, r14 ; 'V'
FFF46355  0c                                bra.s   loc_FFF46359
FFF46356  717e2f                 loc_FFF46356 add     #2Fh, r7, r14 ; '/'
FFF46359  586f                   loc_FFF46359 movu.b  [r6], r15
FFF4635B  fb1220eac3ff                      mov.l   #unk_FFC3EA20, r1
FFF46361  fecf15                            movu.b  [r15, r1], r5
FFF46364  fd74c507                          tst     #7, r5
FFF46368  2112                              bne.b   loc_FFF4637A
FFF4636A  660c                   loc_FFF4636A mov.l   #0, r12
FFF4636C  a881                   loc_FFF4636C mov.l   0Ch+var_4[sp], r1
FFF4636E  6101                              cmp     #0, r1
FFF46370  3a25ff                            beq.w   loc_FFF46295
FFF46373  a881                              mov.l   0Ch+var_4[sp], r1
FFF46375  e316                              mov.l   r6, [r1]
FFF46377  381eff                            bra.w   loc_FFF46295
FFF4637A  7c05                   loc_FFF4637A btst    #0, r5
FFF4637C  14                                beq.s   loc_FFF46380
FFF4637D  71ff20                            add     #20h, r15, r15 ; ' '
FFF46380  5bec                   loc_FFF46380 movu.b  r14, r12
FFF46382  47cf                              cmp     r12, r15
FFF46384  e30c                              mov.l   r12, 0Ch+var_C[sp]
FFF46386  2ae4                              bgt.b   loc_FFF4636A
FFF46388  660b                              mov.l   #0, r11
FFF4638A  ef6c                              mov.l   r6, r12
FFF4638C  58ce                   loc_FFF4638C movu.b  [r12], r14
FFF4638E  621c                              add     #1, r12
FFF46390  755e30                            cmp     #30h, r14 ; '0'
FFF46393  2113                              bne.b   loc_FFF463A6
FFF46395  efc1                              mov.l   r12, r1
FFF46397  efd2                              mov.l   r13, r2
FFF46399  05710900                          bsr.a   sub_FFF46D0A
FFF4639D  621b                              add     #1, r11
FFF4639F  6101                              cmp     #0, r1
FFF463A1  3bf2fe                            bne.w   loc_FFF46293
FFF463A4  2ee8                              bra.b   loc_FFF4638C
FFF463A6  ed0c01                 loc_FFF463A6 mov.l   0Ch+var_8[sp], r12
FFF463A9  6609                              mov.l   #0, r9
FFF463AB  ef98                              mov.l   r9, r8
FFF463AD  70caffffff7f                      add     #7FFFFFFFh, r12, r10
FFF463B3  ef9c                              mov.l   r9, r12
FFF463B5  ff2e9b                 loc_FFF463B5 add     r9, r11, r14
FFF463B8  fb1220eac3ff                      mov.l   #unk_FFC3EA20, r1
FFF463BE  fec6ef                            movu.b  [r6, r14], r15
FFF463C1  4b6e                              add     r6, r14
FFF463C3  fecf15                            movu.b  [r15, r1], r5
FFF463C6  fd74c507                          tst     #7, r5
FFF463CA  2052                              beq.b   loc_FFF4641C
FFF463CC  7c05                              btst    #0, r5
FFF463CE  eff5                              mov.l   r15, r5
FFF463D0  14                                beq.s   loc_FFF463D4
FFF463D1  71f520                            add     #20h, r15, r5 ; ' '
FFF463D4  068405                 loc_FFF463D4 cmp     [sp].l, r5
FFF463D7  2a45                              bgt.b   loc_FFF4641C
FFF463D9  6108                              cmp     #0, r8
FFF463DB  212d                              bne.b   loc_FFF46408
FFF463DD  fbe220eac3ff                      mov.l   #unk_FFC3EA20, r14
FFF463E3  fecefe                            movu.b  [r14, r15], r14
FFF463E6  7c2e                              btst    #2, r14
FFF463E8  210c                              bne.b   loc_FFF463F4
FFF463EA  7c0e                              btst    #0, r14
FFF463EC  14                                beq.s   loc_FFF463F0
FFF463ED  71ff20                            add     #20h, r15, r15 ; ' '
FFF463F0  71ffa9                 loc_FFF463F0 add     #-57h, r15, r15
FFF463F3  0c                                bra.s   loc_FFF463F7
FFF463F4  71ffd0                 loc_FFF463F4 add     #-30h, r15, r15
FFF463F7  ff0efa                 loc_FFF463F7 sub     r15, r10, r14
FFF463FA  fc277e                            divu    r7, r14
FFF463FD  47ec                              cmp     r14, r12
FFF463FF  2505                              bleu.b  loc_FFF46404

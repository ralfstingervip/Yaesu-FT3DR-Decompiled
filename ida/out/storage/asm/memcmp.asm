; ==== memcmp  FFF45400-FFF45700  (file 345400-345700) ====
FFF45400  e505fb05                          mov.l   3ECh[sp], 14h[r5]
FFF45404  f801fb051c0c                      mov.w   #0C1C05FBh, [sp]
FFF4540A  fb                                .byte 0FBh
FFF4540B  05720ffb               sub_FFF4540B bsr.a   sub_FFEF637D   ; <<<< FUNC sub_FFF4540B
FFF4540F  6702                              rtsd    #2
FFF45411  6040                   sub_FFF45411 sub     #4, sp   ; <<<< FUNC sub_FFF45411
FFF45413  3c0200                            mov.b   #0, 4+var_2[sp]
FFF45416  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4541C  59ee7c                            movu.b  7Ch[r14], r14
FFF4541F  610e                              cmp     #0, r14
FFF45421  1e                                bne.s   loc_FFF45427
FFF45422  3c0203                            mov.b   #3, 4+var_2[sp]
FFF45425  2e1f                              bra.b   loc_FFF45444
FFF45427  fb125860ecff           loc_FFF45427 mov.l   #unk_FFEC6058, r1
FFF4542D  b81a                              movu.w  2[r1], r2
FFF4542F  5c11                              movu.w  [r1], r1
FFF45431  754ef0                            mov.l   #-10h, r14
FFF45434  432e                              sub     r2, r14
FFF45436  5fe4                              movu.w  r14, r4
FFF45438  fbea4001                          mov.l   #140h, r14
FFF4543C  431e                              sub     r1, r14
FFF4543E  5fe3                              movu.w  r14, r3
FFF45440  05b7b0fa                          bsr.a   sub_FFEF04F7
FFF45444  c5000203               loc_FFF45444 mov.b   4+var_2[sp], 4+var_1[sp]
FFF45448  2e0e                              bra.b   loc_FFF45456
FFF4544A  b089                   loc_FFF4544A movu.b  4+var_1[sp], r1
FFF4544C  05b9d0fa                          bsr.a   sub_FFEF2505
FFF45450  b089                              movu.b  4+var_1[sp], r1
FFF45452  6211                              add     #1, r1
FFF45454  8089                              mov.b   r1, 4+var_1[sp]
FFF45456  b089                   loc_FFF45456 movu.b  4+var_1[sp], r1
FFF45458  6161                              cmp     #6, r1
FFF4545A  29f0                              blt.b   loc_FFF4544A
FFF4545C  6701                              rtsd    #1
FFF4545E  6040                   sub_FFF4545E sub     #4, sp   ; <<<< FUNC sub_FFF4545E
FFF45460  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF45466  59ee7c                            movu.b  7Ch[r14], r14
FFF45469  610e                              cmp     #0, r14
FFF4546B  2129                              bne.b   loc_FFF45494
FFF4546D  3d01c9                            mov.w   #-37h, 4+var_2[sp]
FFF45470  3d009e                            mov.w   #-62h, [sp]
FFF45473  5c02                              movu.w  4+var_4[sp], r2
FFF45475  b809                              movu.w  4+var_2[sp], r1
FFF45477  6040                              sub     #4, sp
FFF45479  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF4547E  f80509                            mov.w   #9, 8+var_8[sp]
FFF45481  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF45487  71446c                            add     #6Ch, r4, r4 ; 'l'
FFF4548A  6613                              mov.l   #1, r3
FFF4548C  05b256fb                          bsr.a   sub_FFEFAB3E
FFF45490  6240                              add     #4, sp
FFF45492  6701                              rtsd    #1
FFF45494  6701                   loc_FFF45494 rtsd    #1
FFF45496  6e69                   sub_FFF45496 pushm   r6-r9   ; <<<< FUNC sub_FFF45496
FFF45498  ef16                              mov.l   r1, r6
FFF4549A  ef27                              mov.l   r2, r7
FFF4549C  ef38                              mov.l   r3, r8
FFF4549E  ef81                              mov.l   r8, r1
FFF454A0  5c89                              movu.w  [r8], r9
FFF454A2  f08f                              bclr    #7, [r8].b
FFF454A4  05210000                          bsr.a   sub_FFF454C5
FFF454A8  76298000                          and     #80h, r9
FFF454AC  6040                              sub     #4, sp
FFF454AE  fb46ff                            mov.l   #-1, r4
FFF454B1  ef61                              mov.l   r6, r1
FFF454B3  ef72                              mov.l   r7, r2
FFF454B5  ef83                              mov.l   r8, r3
FFF454B7  d389                              mov.w   r9, [r8]
FFF454B9  f80600                            mov.l   #0, 4+var_4[sp]
FFF454BC  05d40900                          bsr.a   loc_FFF45E90
FFF454C0  6240                              add     #4, sp
FFF454C2  3f6904                            rtsd    #10h, r6-r9
FFF454C5  6e68                   sub_FFF454C5 pushm   r6-r8   ; <<<< FUNC sub_FFF454C5
FFF454C7  663e                              mov.l   #3, r14
FFF454C9  ef16                              mov.l   r1, r6
FFF454CB  06e00c1e                          tst     [r1].uw, r14
FFF454CF  fb76ff                            mov.l   #-1, r7
FFF454D2  2033                              beq.b   loc_FFF45505
FFF454D4  88e9                              mov.b   3[r6], r1
FFF454D6  6101                              cmp     #0, r1
FFF454D8  272d                              bn.b    loc_FFF45505
FFF454DA  ef61                              mov.l   r6, r1
FFF454DC  05310900                          bsr.a   sub_FFF45E0D
FFF454E0  5c6e                              movu.w  [r6], r14
FFF454E2  ef18                              mov.l   r1, r8
FFF454E4  7c6e                              btst    #6, r14
FFF454E6  17                                beq.s   loc_FFF454ED
FFF454E7  a869                              mov.l   4[r6], r1
FFF454E9  05ce0f00                          bsr.a   sub_FFF464B7
FFF454ED  3e6100                 loc_FFF454ED mov.l   #0, 4[r6]
FFF454F0  88e9                              mov.b   3[r6], r1
FFF454F2  055bc4f9                          bsr.a   sub_FFEE194D
FFF454F6  6101                              cmp     #0, r1
FFF454F8  13                                beq.s   loc_FFF454FB
FFF454F9  ef78                              mov.l   r7, r8
FFF454FB  ef61                   loc_FFF454FB mov.l   r6, r1
FFF454FD  05b00a00                          bsr.a   sub_FFF45FAD
FFF45501  ef81                              mov.l   r8, r1
FFF45503  2e13                              bra.b   loc_FFF45516
FFF45505  ef61                   loc_FFF45505 mov.l   r6, r1
FFF45507  05a60a00                          bsr.a   sub_FFF45FAD
FFF4550B  fbe210850600                      mov.l   #68510h, r14
FFF45511  ef71                              mov.l   r7, r1
FFF45513  f8e609                            mov.l   #9, [r14]
FFF45516  3f6803                 loc_FFF45516 rtsd    #0Ch, r6-r8
FFF45519  ef1e                   sub_FFF45519 mov.l   r1, r14   ; <<<< FUNC sub_FFF45519
FFF4551B  ef3f                              mov.l   r3, r15
FFF4551D  7f8f                              smovf
FFF4551F  efe1                              mov.l   r14, r1
FFF45521  4bf1                              add     r15, r1
FFF45523  02                                rts
FFF45524  7ea6                   sub_FFF45524 push.l  r6   ; <<<< FUNC sub_FFF45524
FFF45526  ef16                              mov.l   r1, r6
FFF45528  6040                              sub     #4, sp
FFF4552A  710410                            add     #4+arg_4, sp, r4
FFF4552D  fb121955f4ff                      mov.l   #sub_FFF45519, r1
FFF45533  ef62                              mov.l   r6, r2
FFF45535  e304                              mov.l   r4, 4+var_4[sp]
FFF45537  6040                              sub     #4, sp
FFF45539  a903                              mov.l   8+arg_0[sp], r3
FFF4553B  f80600                            mov.l   #0, 8+var_8[sp]
FFF4553E  05b80a00                          bsr.a   sub_FFF45FF6
FFF45542  6240                              add     #4, sp
FFF45544  6101                              cmp     #0, r1
FFF45546  2707                              bn.b    loc_FFF4554D
FFF45548  660e                              mov.l   #0, r14
FFF4554A  fe061e                            mov.b   r14, [r6, r1]
FFF4554D  3f6602                 loc_FFF4554D rtsd    #8, r6-r6
FFF45550  ef1e                   sub_FFF45550 mov.l   r1, r14   ; <<<< FUNC sub_FFF45550
FFF45552  fb36ff                            mov.l   #-1, r3
FFF45555  7f87                              smovu
FFF45557  efe1                              mov.l   r14, r1
FFF45559  02                                rts
FFF4555A  660e                   sub_FFF4555A mov.l   #0, r14   ; <<<< FUNC sub_FFF4555A
FFF4555C  581f                   loc_FFF4555C movu.b  [r1], r15
FFF4555E  711501                            add     #1, r1, r5
FFF45561  5b24                              movu.b  r2, r4
FFF45563  474f                              cmp     r4, r15
FFF45565  13                                beq.s   loc_FFF45568
FFF45566  efe1                              mov.l   r14, r1
FFF45568  ef1e                   loc_FFF45568 mov.l   r1, r14
FFF4556A  5bff                              movu.b  r15, r15
FFF4556C  610f                              cmp     #0, r15
FFF4556E  ef51                              mov.l   r5, r1
FFF45570  21ec                              bne.b   loc_FFF4555C
FFF45572  efe1                              mov.l   r14, r1
FFF45574  02                                rts
FFF45575  66a3                   sub_FFF45575 mov.l   #0Ah, r3   ; <<<< FUNC sub_FFF45575
FFF45577  6602                              mov.l   #0, r2
FFF45579  04ec0c00                          bra.a   sub_FFF46265
FFF4557D  6103                   sub_FFF4557D cmp     #0, r3   ; <<<< FUNC sub_FFF4557D
FFF4557F  660e                              mov.l   #0, r14
FFF45581  1c                                bne.s   loc_FFF45585
FFF45582  6601                              mov.l   #0, r1
FFF45584  02                                rts
FFF45585  473e                   loc_FFF45585 cmp     r3, r14
FFF45587  220e                              bgeu.b  loc_FFF45595
FFF45589  fd381f                            movu.b  [r1+], r15
FFF4558C  621e                              add     #1, r14
FFF4558E  fd3825                            movu.b  [r2+], r5
FFF45591  475f                              cmp     r5, r15
FFF45593  20f2                              beq.b   loc_FFF45585
FFF45595  fbe6ff                 loc_FFF45595 mov.l   #-1, r14
FFF45598  6012                              sub     #1, r2
FFF4559A  fec1e1                            movu.b  [r1, r14], r1
FFF4559D  4021                              sub     [r2], r1
FFF4559F  02                                rts
FFF455A0  ef1e                   sub_FFF455A0 mov.l   r1, r14   ; <<<< FUNC sub_FFF455A0
FFF455A2  7f8f                              smovf
FFF455A4  efe1                              mov.l   r14, r1
FFF455A6  02                                rts
FFF455A7  fbe28c970600           sub_FFF455A7 mov.l   #6978Ch, r14   ; <<<< FUNC sub_FFF455A7
FFF455AD  ecee                              mov.l   [r14], r14
FFF455AF  610e                              cmp     #0, r14
FFF455B1  13                                beq.s   loc_FFF455B4
FFF455B2  7f1e                              jsr     r14
FFF455B4  fbe288970600           loc_FFF455B4 mov.l   #69788h, r14
FFF455BA  ece1                              mov.l   [r14], r1
FFF455BC  02                                rts
FFF455BD  5721                   sub_FFF455BD or      r2, r1   ; <<<< FUNC sub_FFF455BD
FFF455BF  3bc500                            bne.w   loc_FFF45684
FFF455C2  7606ff07                          cmp     #7FFh, r6
FFF455C6  3bab00                            bne.w   loc_FFF45671
FFF455C9  38bb00                            bra.w   loc_FFF45684
FFF455CC  5743                   loc_FFF455CC or      r4, r3
FFF455CE  3bb600                            bne.w   loc_FFF45684
FFF455D1  389500                            bra.w   loc_FFF45666
FFF455D4  ef2e                   loc_FFF455D4 mov.l   r2, r14
FFF455D6  571e                              or      r1, r14
FFF455D8  210f                              bne.b   loc_FFF455E7
FFF455DA  6106                              cmp     #0, r6
FFF455DC  3b8a00                            bne.w   loc_FFF45666
FFF455DF  5743                              or      r4, r3
FFF455E1  3b8500                            bne.w   loc_FFF45666
FFF455E4  38a000                            bra.w   loc_FFF45684
FFF455E7  6c11                   loc_FFF455E7 shll    #1, r1
FFF455E9  7e52                              rolc    r2
FFF455EB  7d42                              btst    #14h, r2
FFF455ED  2305                              bltu.b  loc_FFF455F2
FFF455EF  38d400                            bra.w   loc_FFF456C3
FFF455F2  6015                   loc_FFF455F2 sub     #1, r5
FFF455F4  6c11                              shll    #1, r1
FFF455F6  7e52                              rolc    r2
FFF455F8  7d42                              btst    #14h, r2
FFF455FA  2305                              bltu.b  loc_FFF455FF
FFF455FC  38c700                            bra.w   loc_FFF456C3
FFF455FF  6015                   loc_FFF455FF sub     #1, r5
FFF45601  6c11                              shll    #1, r1
FFF45603  7e52                              rolc    r2
FFF45605  7d42                              btst    #14h, r2
FFF45607  2305                              bltu.b  loc_FFF4560C
FFF45609  38ba00                            bra.w   loc_FFF456C3
FFF4560C  6015                   loc_FFF4560C sub     #1, r5
FFF4560E  6c11                              shll    #1, r1
FFF45610  7e52                              rolc    r2
FFF45612  7d42                              btst    #14h, r2
FFF45614  2305                              bltu.b  loc_FFF45619
FFF45616  38ad00                            bra.w   loc_FFF456C3
FFF45619  6015                   loc_FFF45619 sub     #1, r5
FFF4561B  6c11                              shll    #1, r1
FFF4561D  7e52                              rolc    r2
FFF4561F  7d42                              btst    #14h, r2
FFF45621  2305                              bltu.b  loc_FFF45626
FFF45623  38a000                            bra.w   loc_FFF456C3
FFF45626  2ecc                   loc_FFF45626 bra.b   loc_FFF455F2
FFF45628  ef4e                   loc_FFF45628 mov.l   r4, r14
FFF4562A  573e                              or      r3, r14
FFF4562C  2045                              beq.b   loc_FFF45671
FFF4562E  6c13                              shll    #1, r3
FFF45630  7e54                              rolc    r4
FFF45632  7d44                              btst    #14h, r4
FFF45634  2305                              bltu.b  loc_FFF45639
FFF45636  389200                            bra.w   loc_FFF456C8
FFF45639  6016                   loc_FFF45639 sub     #1, r6
FFF4563B  6c13                              shll    #1, r3
FFF4563D  7e54                              rolc    r4
FFF4563F  7d44                              btst    #14h, r4
FFF45641  2305                              bltu.b  loc_FFF45646
FFF45643  388500                            bra.w   loc_FFF456C8
FFF45646  6016                   loc_FFF45646 sub     #1, r6
FFF45648  6c13                              shll    #1, r3
FFF4564A  7e54                              rolc    r4
FFF4564C  7d44                              btst    #14h, r4
FFF4564E  227a                              bgeu.b  loc_FFF456C8
FFF45650  6016                              sub     #1, r6
FFF45652  6c13                              shll    #1, r3
FFF45654  7e54                              rolc    r4
FFF45656  7d44                              btst    #14h, r4
FFF45658  2270                              bgeu.b  loc_FFF456C8
FFF4565A  6016                              sub     #1, r6
FFF4565C  6c13                              shll    #1, r3
FFF4565E  7e54                              rolc    r4
FFF45660  7d44                              btst    #14h, r4
FFF45662  2266                              bgeu.b  loc_FFF456C8
FFF45664  2ed5                              bra.b   loc_FFF45639
FFF45666  6601                   loc_FFF45666 mov.l   #0, r1
FFF45668  6602                              mov.l   #0, r2
FFF4566A  6c17                              shll    #1, r7
FFF4566C  7e42                              rorc    r2
FFF4566E  3f6702                            rtsd    #8, r6-r7
FFF45671  fb220000f07f           loc_FFF45671 mov.l   #7FF00000h, r2
FFF45677  6601                              mov.l   #0, r1
FFF45679  742700000080                      and     #80000000h, r7
FFF4567F  5772                              or      r7, r2
FFF45681  3f6702                            rtsd    #8, r6-r7
FFF45684  6601                   loc_FFF45684 mov.l   #0, r1
FFF45686  fb220000f87f                      mov.l   #7FF80000h, r2
FFF4568C  3f6702                            rtsd    #8, r6-r7
FFF4568F  6e67                   sub_FFF4568F pushm   r6-r7   ; <<<< FUNC sub_FFF4568F
FFF45691  ef27                              mov.l   r2, r7
FFF45693  fc3747                            xor     r4, r7
FFF45696  ef25                              mov.l   r2, r5
FFF45698  6945                              shlr    #14h, r5
FFF4569A  7625ff07                          and     #7FFh, r5
FFF4569E  ef46                              mov.l   r4, r6
FFF456A0  6946                              shlr    #14h, r6
FFF456A2  7626ff07                          and     #7FFh, r6
FFF456A6  7722ffff0f                        and     #0FFFFFh, r2
FFF456AB  7724ffff0f                        and     #0FFFFFh, r4
FFF456B0  7605ff07                          cmp     #7FFh, r5
FFF456B4  3a09ff                            beq.w   sub_FFF455BD
FFF456B7  7606ff07                          cmp     #7FFh, r6
FFF456BB  3a11ff                            beq.w   loc_FFF455CC
FFF456BE  6105                              cmp     #0, r5
FFF456C0  3a14ff                            beq.w   loc_FFF455D4
FFF456C3  6106                   loc_FFF456C3 cmp     #0, r6
FFF456C5  3a63ff                            beq.w   loc_FFF45628
FFF456C8  4365                   loc_FFF456C8 sub     r6, r5
FFF456CA  7255ff03                          add     #3FFh, r5, r5
FFF456CE  ef5f                              mov.l   r5, r15
FFF456D0  750fcc                            cmp     #-34h, r15
FFF456D3  2993                              blt.b   loc_FFF45666
FFF456D5  7732000010                        or      #100000h, r2
FFF456DA  7734000010                        or      #100000h, r4
FFF456DF  6606                              mov.l   #0, r6
FFF456E1  fbea0001                          mov.l   #100h, r14
FFF456E5  6c13                              shll    #1, r3
FFF456E7  7e54                              rolc    r4
FFF456E9  6c11                   loc_FFF456E9 shll    #1, r1
FFF456EB  7e52                              rolc    r2
FFF456ED  230f                              bltu.b  loc_FFF456FC
FFF456EF  4b31                              add     r3, r1
FFF456F1  fc0b42                            adc     r4, r2
FFF456F4  7e5e                              rolc    r14
FFF456F6  7e56                              rolc    r6
FFF456F8  23f1                              bltu.b  loc_FFF456E9
FFF456FA  2e0d                              bra.b   loc_FFF45707
FFF456FC  4331                   loc_FFF456FC sub     r3, r1
FFF456FE  fc0342                            sbb     r4, r2

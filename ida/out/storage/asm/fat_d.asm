; ==== fat_d  FFF25F80-FFF2C200  (file 325F80-32C200) ====
FFF25F80  06                                mov.b   10h[r1], 6[r2]
FFF25F81  ab81                              mov.l   3Ch+var_4[sp], r1
FFF25F83  ae1a                              mov.l   64h[r1], r2
FFF25F85  490216                            add     3Ch+var_26[sp], r2
FFF25F88  ab03                              mov.l   3Ch+var_C[sp], r3
FFF25F8A  6614                              mov.l   #1, r4
FFF25F8C  051691ff                          bsr.a   sub_FFF1F0A2
FFF25F90  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF25F92  aa09                              mov.l   3Ch+var_18[sp], r1
FFF25F94  6101                              cmp     #0, r1
FFF25F96  10                                beq.s   loc_FFF25F9E
FFF25F97  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF25F9B  386802                            bra.w   loc_FFF26203
FFF25F9E  3c8500                 loc_FFF25F9E mov.b   #0, 3Ch+var_27[sp]
FFF25FA1  3c8700                 loc_FFF25FA1 mov.b   #0, 3Ch+var_25[sp]
FFF25FA4  382002                            bra.w   loc_FFF261C4
FFF25FA7  aa01                   loc_FFF25FA7 mov.l   3Ch+var_1C[sp], r1
FFF25FA9  b312                              movu.b  0Ch[r1], r2
FFF25FAB  6102                              cmp     #0, r2
FFF25FAD  19                                bne.s   loc_FFF25FB6
FFF25FAE  711120                            add     #20h, r1, r1 ; ' '
FFF25FB1  a201                              mov.l   r1, 3Ch+var_1C[sp]
FFF25FB3  380b02                            bra.w   loc_FFF261BE
FFF25FB6  b311                   loc_FFF25FB6 movu.b  0Ch[r1], r1
FFF25FB8  6111                              cmp     #1, r1
FFF25FBA  210e                              bne.b   loc_FFF25FC8
FFF25FBC  ab81                              mov.l   3Ch+var_4[sp], r1
FFF25FBE  8c11                              mov.b   10h[r1], r1
FFF25FC0  755120                            cmp     #20h, r1 ; ' '
FFF25FC3  15                                beq.s   loc_FFF25FC8
FFF25FC4  f80601                            mov.l   #1, 3Ch+var_3C[sp]
FFF25FC7  0c                                bra.s   loc_FFF25FCB
FFF25FC8  f80600                 loc_FFF25FC8 mov.l   #0, 3Ch+var_3C[sp]
FFF25FCB  ec01                   loc_FFF25FCB mov.l   3Ch+var_3C[sp], r1
FFF25FCD  6101                              cmp     #0, r1
FFF25FCF  203a                              beq.b   loc_FFF26009
FFF25FD1  aa01                              mov.l   3Ch+var_1C[sp], r1
FFF25FD3  a819                              mov.l   4[r1], r1
FFF25FD5  ab82                              mov.l   3Ch+var_4[sp], r2
FFF25FD7  adaa                              mov.l   5Ch[r2], r2
FFF25FD9  6852                              shlr    #5, r2
FFF25FDB  fc2721                            divu    r2, r1
FFF25FDE  a181                              mov.l   r1, 3Ch+var_24[sp]
FFF25FE0  ab81                              mov.l   3Ch+var_4[sp], r1
FFF25FE2  a89a                              mov.l   0Ch[r1], r2
FFF25FE4  06cd1204                          mul     8[r1].uw, r2
FFF25FE8  06c91203                          add     6[r1].uw, r2
FFF25FEC  06890206                          add     3Ch+var_24[sp].l, r2
FFF25FF0  aa01                              mov.l   3Ch+var_1C[sp], r1
FFF25FF2  e312                              mov.l   r2, [r1]
FFF25FF4  aa01                              mov.l   3Ch+var_1C[sp], r1
FFF25FF6  a81a                              mov.l   4[r1], r2
FFF25FF8  ab83                              mov.l   3Ch+var_4[sp], r3
FFF25FFA  adbb                              mov.l   5Ch[r3], r3
FFF25FFC  6853                              shlr    #5, r3
FFF25FFE  ef2e                              mov.l   r2, r14
FFF26000  fc273e                            divu    r3, r14
FFF26003  4f3e                              mul     r3, r14
FFF26005  43e2                              sub     r14, r2
FFF26007  a01a                              mov.l   r2, 4[r1]
FFF26009  aa01                   loc_FFF26009 mov.l   3Ch+var_1C[sp], r1
FFF2600B  b611                              movu.b  18h[r1], r1
FFF2600D  6111                              cmp     #1, r1
FFF2600F  210e                              bne.b   loc_FFF2601D
FFF26011  ab81                              mov.l   3Ch+var_4[sp], r1
FFF26013  8c11                              mov.b   10h[r1], r1
FFF26015  755120                            cmp     #20h, r1 ; ' '
FFF26018  15                                beq.s   loc_FFF2601D
FFF26019  f80601                            mov.l   #1, 3Ch+var_3C[sp]
FFF2601C  0c                                bra.s   loc_FFF26020
FFF2601D  f80600                 loc_FFF2601D mov.l   #0, 3Ch+var_3C[sp]
FFF26020  ec01                   loc_FFF26020 mov.l   3Ch+var_3C[sp], r1
FFF26022  6101                              cmp     #0, r1
FFF26024  203a                              beq.b   loc_FFF2605E
FFF26026  aa01                              mov.l   3Ch+var_1C[sp], r1
FFF26028  a819                              mov.l   4[r1], r1
FFF2602A  ab82                              mov.l   3Ch+var_4[sp], r2
FFF2602C  adaa                              mov.l   5Ch[r2], r2
FFF2602E  6852                              shlr    #5, r2
FFF26030  fc2721                            divu    r2, r1
FFF26033  a181                              mov.l   r1, 3Ch+var_24[sp]
FFF26035  ab81                              mov.l   3Ch+var_4[sp], r1
FFF26037  a89a                              mov.l   0Ch[r1], r2
FFF26039  06cd1204                          mul     8[r1].uw, r2
FFF2603D  06c91203                          add     6[r1].uw, r2
FFF26041  06890206                          add     3Ch+var_24[sp].l, r2
FFF26045  aa01                              mov.l   3Ch+var_1C[sp], r1
FFF26047  a112                              mov.l   r2, 10h[r1]
FFF26049  aa01                              mov.l   3Ch+var_1C[sp], r1
FFF2604B  a81a                              mov.l   4[r1], r2
FFF2604D  ab83                              mov.l   3Ch+var_4[sp], r3
FFF2604F  adbb                              mov.l   5Ch[r3], r3
FFF26051  6853                              shlr    #5, r3
FFF26053  ef2e                              mov.l   r2, r14
FFF26055  fc273e                            divu    r3, r14
FFF26058  4f3e                              mul     r3, r14
FFF2605A  43e2                              sub     r14, r2
FFF2605C  a11a                              mov.l   r2, 14h[r1]
FFF2605E  b509                   loc_FFF2605E movu.b  3Ch+var_27[sp], r1
FFF26060  6111                              cmp     #1, r1
FFF26062  3b3701                            bne.w   loc_FFF26199
FFF26065  aa01                   loc_FFF26065 mov.l   3Ch+var_1C[sp], r1
FFF26067  b612                              movu.b  18h[r1], r2
FFF26069  6102                              cmp     #0, r2
FFF2606B  1d                                bne.s   loc_FFF26070
FFF2606C  e41002                            mov.l   [r1], 3Ch+var_34[sp]
FFF2606F  0d                                bra.s   loc_FFF26074
FFF26070  e5100402               loc_FFF26070 mov.l   10h[r1], 3Ch+var_34[sp]
FFF26074  aa8b                   loc_FFF26074 mov.l   3Ch+var_10[sp], r3
FFF26076  a882                              mov.l   3Ch+var_34[sp], r2
FFF26078  ab81                              mov.l   3Ch+var_4[sp], r1
FFF2607A  72330602                          add     #206h, r3, r3
FFF2607E  6614                              mov.l   #1, r4
FFF26080  05918fff                          bsr.a   sub_FFF1F011
FFF26084  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF26086  aa09                              mov.l   3Ch+var_18[sp], r1
FFF26088  6101                              cmp     #0, r1
FFF2608A  10                                beq.s   loc_FFF26092
FFF2608B  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF2608F  387401                            bra.w   loc_FFF26203
FFF26092  aa89                   loc_FFF26092 mov.l   3Ch+var_10[sp], r1
FFF26094  72110602                          add     #206h, r1, r1
FFF26098  a189                              mov.l   r1, 3Ch+var_20[sp]
FFF2609A  aa01                              mov.l   3Ch+var_1C[sp], r1
FFF2609C  a819                              mov.l   4[r1], r1
FFF2609E  6c51                              shll    #5, r1
FFF260A0  06890107                          add     3Ch+var_20[sp].l, r1
FFF260A4  a189                              mov.l   r1, 3Ch+var_20[sp]
FFF260A6  a989                              mov.l   3Ch+var_20[sp], r1
FFF260A8  8a99                              mov.b   0Bh[r1], r1
FFF260AA  61f1                              cmp     #0Fh, r1
FFF260AC  3aed00                            beq.w   loc_FFF26199
FFF260AF  aa8d                              mov.l   3Ch+var_10[sp], r5
FFF260B1  ab0c                              mov.l   3Ch+var_8[sp], r4
FFF260B3  aa03                              mov.l   3Ch+var_1C[sp], r3
FFF260B5  a98a                              mov.l   3Ch+var_20[sp], r2
FFF260B7  ab81                              mov.l   3Ch+var_4[sp], r1
FFF260B9  6040                              sub     #4, sp
FFF260BB  e305                              mov.l   r5, 40h+var_40[sp]
FFF260BD  390504                            bsr.w   sub_FFF264C2
FFF260C0  6240                              add     #4, sp
FFF260C2  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF260C4  aa09                              mov.l   3Ch+var_18[sp], r1
FFF260C6  6101                              cmp     #0, r1
FFF260C8  10                                beq.s   loc_FFF260D0
FFF260C9  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF260CD  383601                            bra.w   loc_FFF26203
FFF260D0  aa8b                   loc_FFF260D0 mov.l   3Ch+var_10[sp], r3
FFF260D2  a882                              mov.l   3Ch+var_34[sp], r2
FFF260D4  ab81                              mov.l   3Ch+var_4[sp], r1
FFF260D6  72330602                          add     #206h, r3, r3
FFF260DA  6614                              mov.l   #1, r4
FFF260DC  05c68fff                          bsr.a   sub_FFF1F0A2
FFF260E0  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF260E2  aa09                              mov.l   3Ch+var_18[sp], r1
FFF260E4  6101                              cmp     #0, r1
FFF260E6  10                                beq.s   loc_FFF260EE
FFF260E7  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF260EB  381801                            bra.w   loc_FFF26203
FFF260EE  aa01                   loc_FFF260EE mov.l   3Ch+var_1C[sp], r1
FFF260F0  ec1e                              mov.l   [r1], r14
FFF260F2  aa8c                              mov.l   3Ch+var_10[sp], r4
FFF260F4  a98a                              mov.l   3Ch+var_20[sp], r2
FFF260F6  ab81                              mov.l   3Ch+var_4[sp], r1
FFF260F8  7100ec                            add     #-14h, sp, sp
FFF260FB  710320                            add     #50h+var_30, sp, r3
FFF260FE  a00b                              mov.l   r3, 50h+var_4C[sp]
FFF26100  e30e                              mov.l   r14, 50h+var_50[sp]
FFF26102  3c0c01                            mov.b   #1, 50h+var_44[sp]
FFF26105  3e0200                            mov.l   #0, 50h+var_48[sp]
FFF26108  a104                              mov.l   r4, 50h+var_40[sp]
FFF2610A  72440c08                          add     #80Ch, r4, r4
FFF2610E  6603                              mov.l   #0, r3
FFF26110  057a7fff                          bsr.a   sub_FFF1E08A
FFF26114  710014                            add     #14h, sp, sp
FFF26117  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF26119  aa09                              mov.l   3Ch+var_18[sp], r1
FFF2611B  6101                              cmp     #0, r1
FFF2611D  10                                beq.s   loc_FFF26125
FFF2611E  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF26122  38e100                            bra.w   loc_FFF26203
FFF26125  a889                   loc_FFF26125 mov.l   3Ch+var_30[sp], r1
FFF26127  6111                              cmp     #1, r1
FFF26129  210d                              bne.b   loc_FFF26136
FFF2612B  ab09                              mov.l   3Ch+var_8[sp], r1
FFF2612D  a892                              mov.l   8[r1], r2
FFF2612F  6212                              add     #1, r2
FFF26131  a092                              mov.l   r2, 8[r1]
FFF26133  3e0300                            mov.l   #0, 3Ch+var_30[sp]
FFF26136  aa8b                   loc_FFF26136 mov.l   3Ch+var_10[sp], r3
FFF26138  a882                              mov.l   3Ch+var_34[sp], r2
FFF2613A  ab81                              mov.l   3Ch+var_4[sp], r1
FFF2613C  72330602                          add     #206h, r3, r3
FFF26140  6614                              mov.l   #1, r4
FFF26142  05608fff                          bsr.a   sub_FFF1F0A2
FFF26146  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF26148  aa09                              mov.l   3Ch+var_18[sp], r1
FFF2614A  6101                              cmp     #0, r1
FFF2614C  10                                beq.s   loc_FFF26154
FFF2614D  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF26151  38b200                            bra.w   loc_FFF26203
FFF26154  aa8d                   loc_FFF26154 mov.l   3Ch+var_10[sp], r5
FFF26156  ab0c                              mov.l   3Ch+var_8[sp], r4
FFF26158  aa03                              mov.l   3Ch+var_1C[sp], r3
FFF2615A  a98a                              mov.l   3Ch+var_20[sp], r2
FFF2615C  ab81                              mov.l   3Ch+var_4[sp], r1
FFF2615E  6040                              sub     #4, sp
FFF26160  e305                              mov.l   r5, 40h+var_40[sp]
FFF26162  392c07                            bsr.w   sub_FFF2688E
FFF26165  6240                              add     #4, sp
FFF26167  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF26169  aa09                              mov.l   3Ch+var_18[sp], r1
FFF2616B  6101                              cmp     #0, r1
FFF2616D  10                                beq.s   loc_FFF26175
FFF2616E  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF26172  389100                            bra.w   loc_FFF26203
FFF26175  aa01                   loc_FFF26175 mov.l   3Ch+var_1C[sp], r1
FFF26177  b611                              movu.b  18h[r1], r1
FFF26179  6101                              cmp     #0, r1
FFF2617B  200e                              beq.b   loc_FFF26189
FFF2617D  a989                              mov.l   3Ch+var_20[sp], r1
FFF2617F  581e                              movu.b  [r1], r14
FFF26181  755ee5                            cmp     #-1Bh, r14
FFF26184  1d                                bne.s   loc_FFF26189
FFF26185  f80601                            mov.l   #1, 3Ch+var_3C[sp]
FFF26188  0c                                bra.s   loc_FFF2618C
FFF26189  f80600                 loc_FFF26189 mov.l   #0, 3Ch+var_3C[sp]
FFF2618C  ec01                   loc_FFF2618C mov.l   3Ch+var_3C[sp], r1
FFF2618E  6101                              cmp     #0, r1
FFF26190  11                                beq.s   loc_FFF26199
FFF26191  aa01                              mov.l   3Ch+var_1C[sp], r1
FFF26193  3c9800                            mov.b   #0, 18h[r1]
FFF26196  38cffe                            bra.w   loc_FFF26065
FFF26199  aa8c                   loc_FFF26199 mov.l   3Ch+var_10[sp], r4
FFF2619B  5a423116                          movu.b  1631h[r4], r2
FFF2619F  b58b                              movu.b  3Ch+var_25[sp], r3
FFF261A1  ab81                              mov.l   3Ch+var_4[sp], r1
FFF261A3  72440c06                          add     #60Ch, r4, r4
FFF261A7  39b502                            bsr.w   sub_FFF2645C
FFF261AA  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF261AC  aa09                              mov.l   3Ch+var_18[sp], r1
FFF261AE  6101                              cmp     #0, r1
FFF261B0  17                                beq.s   loc_FFF261B7
FFF261B1  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF261B5  2e4e                              bra.b   loc_FFF26203
FFF261B7  aa01                   loc_FFF261B7 mov.l   3Ch+var_1C[sp], r1
FFF261B9  711120                            add     #20h, r1, r1 ; ' '
FFF261BC  a201                              mov.l   r1, 3Ch+var_1C[sp]
FFF261BE  b589                   loc_FFF261BE movu.b  3Ch+var_25[sp], r1
FFF261C0  6211                              add     #1, r1
FFF261C2  8589                              mov.b   r1, 3Ch+var_25[sp]
FFF261C4  b589                   loc_FFF261C4 movu.b  3Ch+var_25[sp], r1
FFF261C6  06850104                          cmp     3Ch+var_2C[sp].l, r1
FFF261CA  2205                              bgeu.b  loc_FFF261CF
FFF261CC  38dbfd                            bra.w   loc_FFF25FA7
FFF261CF  b581                   loc_FFF261CF movu.b  3Ch+var_26[sp], r1
FFF261D1  6211                              add     #1, r1
FFF261D3  8581                              mov.b   r1, 3Ch+var_26[sp]
FFF261D5  ab81                   loc_FFF261D5 mov.l   3Ch+var_4[sp], r1
FFF261D7  b582                              movu.b  3Ch+var_26[sp], r2
FFF261D9  0685121a                          cmp     68h[r1].l, r2
FFF261DD  2205                              bgeu.b  loc_FFF261E2
FFF261DF  3841fd                            bra.w   loc_FFF25F20
FFF261E2  ab09                   loc_FFF261E2 mov.l   3Ch+var_8[sp], r1
FFF261E4  581e                              movu.b  [r1], r14
FFF261E6  611e                              cmp     #1, r14
FFF261E8  2118                              bne.b   loc_FFF26200
FFF261EA  ab81                              mov.l   3Ch+var_4[sp], r1
FFF261EC  8c19                              mov.b   11h[r1], r1
FFF261EE  aa8a                              mov.l   3Ch+var_10[sp], r2
FFF261F0  058e3700                          bsr.a   sub_FFF2997E
FFF261F4  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF261F6  aa09                              mov.l   3Ch+var_18[sp], r1
FFF261F8  6101                              cmp     #0, r1
FFF261FA  16                                beq.s   loc_FFF26200
FFF261FB  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF261FF  0c                                bra.s   loc_FFF26203
FFF26200  3e0100                 loc_FFF26200 mov.l   #0, 3Ch+var_38[sp]
FFF26203  a809                   loc_FFF26203 mov.l   3Ch+var_38[sp], r1
FFF26205  a281                              mov.l   r1, 3Ch+var_14[sp]
FFF26207  670f                              rtsd    #0Fh
FFF26209  7100e0                 sub_FFF26209 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF26209
FFF2620C  a189                              mov.l   r1, 20h+var_4[sp]
FFF2620E  a182                              mov.l   r2, 20h+var_8[sp]
FFF26210  a10b                              mov.l   r3, 20h+var_C[sp]
FFF26212  a989                              mov.l   20h+var_4[sp], r1
FFF26214  a919                              mov.l   14h[r1], r1
FFF26216  06850106                          cmp     20h+var_8[sp].l, r1
FFF2621A  2208                              bgeu.b  loc_FFF26222
FFF2621C  f90601f3                          mov.l   #-0Dh, 20h+var_1C[sp]
FFF26220  2e63                              bra.b   loc_FFF26283
FFF26222  a909                   loc_FFF26222 mov.l   20h+var_C[sp], r1
FFF26224  6101                              cmp     #0, r1
FFF26226  1f                                bne.s   loc_FFF2622D
FFF26227  f90601f3                          mov.l   #-0Dh, 20h+var_1C[sp]
FFF2622B  2e58                              bra.b   loc_FFF26283
FFF2622D  a90b                   loc_FFF2622D mov.l   20h+var_C[sp], r3
FFF2622F  a982                              mov.l   20h+var_8[sp], r2
FFF26231  a989                              mov.l   20h+var_4[sp], r1
FFF26233  6614                              mov.l   #1, r4
FFF26235  05dc8dff                          bsr.a   sub_FFF1F011
FFF26239  a089                              mov.l   r1, 20h+var_14[sp]
FFF2623B  a889                              mov.l   20h+var_14[sp], r1
FFF2623D  6101                              cmp     #0, r1
FFF2623F  17                                beq.s   loc_FFF26246
FFF26240  e5000301                          mov.l   20h+var_14[sp], 20h+var_1C[sp]
FFF26244  2e3f                              bra.b   loc_FFF26283
FFF26246  a909                   loc_FFF26246 mov.l   20h+var_C[sp], r1
FFF26248  055c8a00                          bsr.a   sub_FFF2ECA4
FFF2624C  9101                              mov.w   r1, 20h+var_18[sp]
FFF2624E  a989                              mov.l   20h+var_4[sp], r1
FFF26250  ad99                              mov.l   5Ch[r1], r1
FFF26252  06890105                          add     20h+var_C[sp].l, r1
FFF26256  6021                              sub     #2, r1
FFF26258  054c8a00                          bsr.a   sub_FFF2ECA4
FFF2625C  9109                              mov.w   r1, 20h+var_16[sp]
FFF2625E  b901                              movu.w  20h+var_18[sp], r1
FFF26260  770155aa00                        cmp     #0AA55h, r1
FFF26265  19                                bne.s   loc_FFF2626E
FFF26266  b909                              movu.w  20h+var_16[sp], r1
FFF26268  770155aa00                        cmp     #0AA55h, r1
FFF2626D  15                                beq.s   loc_FFF26272
FFF2626E  f80601                 loc_FFF2626E mov.l   #1, 20h+var_20[sp]
FFF26271  0c                                bra.s   loc_FFF26275
FFF26272  f80600                 loc_FFF26272 mov.l   #0, 20h+var_20[sp]
FFF26275  ec01                   loc_FFF26275 mov.l   20h+var_20[sp], r1
FFF26277  6101                              cmp     #0, r1
FFF26279  17                                beq.s   loc_FFF26280
FFF2627A  f90a01d3fe                        mov.l   #-12Dh, 20h+var_1C[sp]
FFF2627F  0c                                bra.s   loc_FFF26283
FFF26280  3e0100                 loc_FFF26280 mov.l   #0, 20h+var_1C[sp]
FFF26283  a809                   loc_FFF26283 mov.l   20h+var_1C[sp], r1
FFF26285  a101                              mov.l   r1, 20h+var_10[sp]
FFF26287  6708                              rtsd    #8
FFF26289  7100dc                 sub_FFF26289 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF26289
FFF2628C  a201                              mov.l   r1, 24h+var_4[sp]
FFF2628E  a18a                              mov.l   r2, 24h+var_8[sp]
FFF26290  a183                              mov.l   r3, 24h+var_C[sp]
FFF26292  a989                              mov.l   24h+var_8[sp], r1
FFF26294  6101                              cmp     #0, r1
FFF26296  1f                                bne.s   loc_FFF2629D
FFF26297  f806f3                            mov.l   #-0Dh, 24h+var_24[sp]
FFF2629A  38a600                            bra.w   loc_FFF26340
FFF2629D  aa01                   loc_FFF2629D mov.l   24h+var_4[sp], r1
FFF2629F  ad99                              mov.l   5Ch[r1], r1
FFF262A1  6851                              shlr    #5, r1
FFF262A3  6011                              sub     #1, r1
FFF262A5  8101                              mov.b   r1, 24h+var_20[sp]
FFF262A7  3c0500                            mov.b   #0, 24h+var_1F[sp]
FFF262AA  388100                            bra.w   loc_FFF2632B
FFF262AD  aa01                   loc_FFF262AD mov.l   24h+var_4[sp], r1
FFF262AF  ae1a                              mov.l   64h[r1], r2
FFF262B1  490205                            add     24h+var_1F[sp], r2
FFF262B4  a98b                              mov.l   24h+var_8[sp], r3
FFF262B6  3953ff                            bsr.w   sub_FFF26209
FFF262B9  a101                              mov.l   r1, 24h+var_14[sp]
FFF262BB  a901                              mov.l   24h+var_14[sp], r1
FFF262BD  6101                              cmp     #0, r1
FFF262BF  16                                beq.s   loc_FFF262C5
FFF262C0  e10004                            mov.l   24h+var_14[sp], 24h+var_24[sp]
FFF262C3  2e7d                              bra.b   loc_FFF26340
FFF262C5  a989                   loc_FFF262C5 mov.l   24h+var_8[sp], r1
FFF262C7  711110                            add     #10h, r1, r1
FFF262CA  a089                              mov.l   r1, 24h+var_18[sp]
FFF262CC  3c0700                            mov.b   #0, 24h+var_1D[sp]
FFF262CF  2e4f                              bra.b   loc_FFF2631E
FFF262D1  e5000302               loc_FFF262D1 mov.l   24h+var_18[sp], 24h+var_1C[sp]
FFF262D5  3c0600                            mov.b   #0, 24h+var_1E[sp]
FFF262D8  2e16                              bra.b   loc_FFF262EE
FFF262DA  a881                   loc_FFF262DA mov.l   24h+var_1C[sp], r1
FFF262DC  581e                              movu.b  [r1], r14
FFF262DE  610e                              cmp     #0, r14
FFF262E0  2115                              bne.b   loc_FFF262F5
FFF262E2  a881                              mov.l   24h+var_1C[sp], r1
FFF262E4  6211                              add     #1, r1
FFF262E6  a081                              mov.l   r1, 24h+var_1C[sp]
FFF262E8  b181                              movu.b  24h+var_1E[sp], r1
FFF262EA  6211                              add     #1, r1
FFF262EC  8181                              mov.b   r1, 24h+var_1E[sp]
FFF262EE  b181                   loc_FFF262EE movu.b  24h+var_1E[sp], r1
FFF262F0  755120                            cmp     #20h, r1 ; ' '
FFF262F3  23e7                              bltu.b  loc_FFF262DA
FFF262F5  b181                   loc_FFF262F5 movu.b  24h+var_1E[sp], r1
FFF262F7  755120                            cmp     #20h, r1 ; ' '
FFF262FA  2117                              bne.b   loc_FFF26311
FFF262FC  b109                              movu.b  24h+var_1F[sp], r1
FFF262FE  a982                              mov.l   24h+var_C[sp], r2
FFF26300  cb213116                          mov.b   r1, 1631h[r2]
FFF26304  b189                              movu.b  24h+var_1D[sp], r1
FFF26306  a982                              mov.l   24h+var_C[sp], r2
FFF26308  cb213216                          mov.b   r1, 1632h[r2]
FFF2630C  3e0400                            mov.l   #0, 24h+var_14[sp]
FFF2630F  2e2e                              bra.b   loc_FFF2633D
FFF26311  a889                   loc_FFF26311 mov.l   24h+var_18[sp], r1
FFF26313  711120                            add     #20h, r1, r1 ; ' '
FFF26316  a089                              mov.l   r1, 24h+var_18[sp]
FFF26318  b189                              movu.b  24h+var_1D[sp], r1
FFF2631A  6211                              add     #1, r1
FFF2631C  8189                              mov.b   r1, 24h+var_1D[sp]
FFF2631E  b189                   loc_FFF2631E movu.b  24h+var_1D[sp], r1
FFF26320  450104                            cmp     24h+var_20[sp], r1
FFF26323  29ae                              blt.b   loc_FFF262D1
FFF26325  b109                              movu.b  24h+var_1F[sp], r1
FFF26327  6211                              add     #1, r1
FFF26329  8109                              mov.b   r1, 24h+var_1F[sp]
FFF2632B  aa01                   loc_FFF2632B mov.l   24h+var_4[sp], r1
FFF2632D  b10a                              movu.b  24h+var_1F[sp], r2
FFF2632F  0685121a                          cmp     68h[r1].l, r2
FFF26333  2205                              bgeu.b  loc_FFF26338
FFF26335  3878ff                            bra.w   loc_FFF262AD
FFF26338  f90a04d4fe             loc_FFF26338 mov.l   #-12Ch, 24h+var_14[sp]
FFF2633D  e10004                 loc_FFF2633D mov.l   24h+var_14[sp], 24h+var_24[sp]
FFF26340  ec01                   loc_FFF26340 mov.l   24h+var_24[sp], r1
FFF26342  a109                              mov.l   r1, 24h+var_10[sp]
FFF26344  6709                              rtsd    #9
FFF26346  7100d0                 sub_FFF26346 add     #-30h, sp, sp   ; <<<< FUNC sub_FFF26346
FFF26349  a289                              mov.l   r1, 30h+var_4[sp]
FFF2634B  a282                              mov.l   r2, 30h+var_8[sp]
FFF2634D  a20b                              mov.l   r3, 30h+var_C[sp]
FFF2634F  a204                              mov.l   r4, 30h+var_10[sp]
FFF26351  c500341f                          mov.b   30h+arg_0[sp], 30h+var_11[sp]
FFF26355  e5000e06                          mov.l   30h+arg_4[sp], 30h+var_18[sp]
FFF26359  e5000f05                          mov.l   30h+arg_8[sp], 30h+var_1C[sp]
FFF2635D  aa89                              mov.l   30h+var_4[sp], r1
FFF2635F  a919                              mov.l   14h[r1], r1
FFF26361  06850109                          cmp     30h+var_C[sp].l, r1
FFF26365  2209                              bgeu.b  loc_FFF2636E
FFF26367  f90601f3                          mov.l   #-0Dh, 30h+var_2C[sp]
FFF2636B  38eb00                            bra.w   loc_FFF26456
FFF2636E  b789                   loc_FFF2636E movu.b  30h+var_11[sp], r1
FFF26370  6111                              cmp     #1, r1
FFF26372  16                                beq.s   loc_FFF26378
FFF26373  b789                              movu.b  30h+var_11[sp], r1
FFF26375  6121                              cmp     #2, r1
FFF26377  1d                                bne.s   loc_FFF2637C
FFF26378  f80601                 loc_FFF26378 mov.l   #1, 30h+var_30[sp]
FFF2637B  0c                                bra.s   loc_FFF2637F
FFF2637C  f80600                 loc_FFF2637C mov.l   #0, 30h+var_30[sp]
FFF2637F  ec01                   loc_FFF2637F mov.l   30h+var_30[sp], r1
FFF26381  6101                              cmp     #0, r1
FFF26383  3ad000                            beq.w   loc_FFF26453
FFF26386  a981                              mov.l   30h+var_18[sp], r1
FFF26388  711110                            add     #10h, r1, r1
FFF2638B  a081                              mov.l   r1, 30h+var_28[sp]
FFF2638D  a909                              mov.l   30h+var_1C[sp], r1
FFF2638F  5a113216                          movu.b  1632h[r1], r1
FFF26393  6c51                              shll    #5, r1
FFF26395  06890102                          add     30h+var_28[sp].l, r1
FFF26399  a081                              mov.l   r1, 30h+var_28[sp]
FFF2639B  a981                              mov.l   30h+var_18[sp], r1
FFF2639D  fb2e55aa00                        mov.l   #0AA55h, r2
FFF263A2  05df8800                          bsr.a   sub_FFF2EC81
FFF263A6  a981                              mov.l   30h+var_18[sp], r1
FFF263A8  6221                              add     #2, r1
FFF263AA  fb2206400001                      mov.l   #1004006h, r2
FFF263B0  05238900                          bsr.a   sub_FFF2ECD3
FFF263B4  aa89                              mov.l   30h+var_4[sp], r1
FFF263B6  a982                              mov.l   30h+var_18[sp], r2
FFF263B8  c5121006                          mov.b   10h[r1], 6[r2]
FFF263BC  a909                              mov.l   30h+var_1C[sp], r1
FFF263BE  5a1e3016                          movu.b  1630h[r1], r14
FFF263C2  610e                              cmp     #0, r14
FFF263C4  12                                beq.s   loc_FFF263CE
FFF263C5  a909                              mov.l   30h+var_1C[sp], r1
FFF263C7  5a1e3016                          movu.b  1630h[r1], r14
FFF263CB  611e                              cmp     #1, r14
FFF263CD  1d                                bne.s   loc_FFF263D2
FFF263CE  f80601                 loc_FFF263CE mov.l   #1, 30h+var_30[sp]
FFF263D1  0c                                bra.s   loc_FFF263D5
FFF263D2  f80600                 loc_FFF263D2 mov.l   #0, 30h+var_30[sp]
FFF263D5  ec01                   loc_FFF263D5 mov.l   30h+var_30[sp], r1
FFF263D7  6101                              cmp     #0, r1
FFF263D9  202d                              beq.b   loc_FFF26406
FFF263DB  aa09                              mov.l   30h+var_C[sp], r1
FFF263DD  a882                              mov.l   30h+var_28[sp], r2
FFF263DF  e321                              mov.l   r1, [r2]
FFF263E1  aa01                              mov.l   30h+var_10[sp], r1
FFF263E3  a882                              mov.l   30h+var_28[sp], r2
FFF263E5  a029                              mov.l   r1, 4[r2]
FFF263E7  aa81                              mov.l   30h+var_8[sp], r1
FFF263E9  a882                              mov.l   30h+var_28[sp], r2
FFF263EB  d5120704                          mov.w   0Eh[r1], 8[r2]
FFF263EF  aa81                              mov.l   30h+var_8[sp], r1
FFF263F1  a882                              mov.l   30h+var_28[sp], r2
FFF263F3  d5120805                          mov.w   10h[r1], 0Ah[r2]
FFF263F7  b789                              movu.b  30h+var_11[sp], r1
FFF263F9  a882                              mov.l   30h+var_28[sp], r2
FFF263FB  8321                              mov.b   r1, 0Ch[r2]
FFF263FD  aa81                              mov.l   30h+var_8[sp], r1
FFF263FF  a882                              mov.l   30h+var_28[sp], r2
FFF26401  c4120d                            mov.b   [r1], 0Dh[r2]
FFF26404  2e1e                              bra.b   loc_FFF26422
FFF26406  a909                   loc_FFF26406 mov.l   30h+var_1C[sp], r1
FFF26408  5a1e3016                          movu.b  1630h[r1], r14
FFF2640C  612e                              cmp     #2, r14
FFF2640E  2114                              bne.b   loc_FFF26422
FFF26410  aa09                              mov.l   30h+var_C[sp], r1
FFF26412  a882                              mov.l   30h+var_28[sp], r2
FFF26414  a121                              mov.l   r1, 10h[r2]
FFF26416  aa01                              mov.l   30h+var_10[sp], r1
FFF26418  a882                              mov.l   30h+var_28[sp], r2
FFF2641A  a129                              mov.l   r1, 14h[r2]
FFF2641C  b789                              movu.b  30h+var_11[sp], r1
FFF2641E  a882                              mov.l   30h+var_28[sp], r2
FFF26420  8621                              mov.b   r1, 18h[r2]
FFF26422  aa89                   loc_FFF26422 mov.l   30h+var_4[sp], r1
FFF26424  ad99                              mov.l   5Ch[r1], r1
FFF26426  06890106                          add     30h+var_18[sp].l, r1
FFF2642A  6021                              sub     #2, r1
FFF2642C  fb2e55aa00                        mov.l   #0AA55h, r2
FFF26431  05508800                          bsr.a   sub_FFF2EC81
FFF26435  aa89                              mov.l   30h+var_4[sp], r1
FFF26437  ae1a                              mov.l   64h[r1], r2
FFF26439  a90b                              mov.l   30h+var_1C[sp], r3
FFF2643B  4a323116                          add     1631h[r3], r2
FFF2643F  a983                              mov.l   30h+var_18[sp], r3
FFF26441  6614                              mov.l   #1, r4
FFF26443  055f8cff                          bsr.a   sub_FFF1F0A2
FFF26447  a089                              mov.l   r1, 30h+var_24[sp]
FFF26449  a889                              mov.l   30h+var_24[sp], r1
FFF2644B  6101                              cmp     #0, r1
FFF2644D  16                                beq.s   loc_FFF26453
FFF2644E  e5000301                          mov.l   30h+var_24[sp], 30h+var_2C[sp]
FFF26452  0c                                bra.s   loc_FFF26456
FFF26453  3e0100                 loc_FFF26453 mov.l   #0, 30h+var_2C[sp]
FFF26456  a809                   loc_FFF26456 mov.l   30h+var_2C[sp], r1
FFF26458  a101                              mov.l   r1, 30h+var_20[sp]
FFF2645A  670c                              rtsd    #0Ch
FFF2645C  7100e4                 sub_FFF2645C add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2645C
FFF2645F  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF26461  858a                              mov.b   r2, 1Ch+var_5[sp]
FFF26463  8583                              mov.b   r3, 1Ch+var_6[sp]
FFF26465  a104                              mov.l   r4, 1Ch+var_C[sp]
FFF26467  a981                              mov.l   1Ch+var_4[sp], r1
FFF26469  ae1a                              mov.l   64h[r1], r2
FFF2646B  490217                            add     1Ch+var_5[sp], r2
FFF2646E  ef43                              mov.l   r4, r3
FFF26470  3999fd                            bsr.w   sub_FFF26209
FFF26473  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF26475  a881                              mov.l   1Ch+var_14[sp], r1
FFF26477  6101                              cmp     #0, r1
FFF26479  16                                beq.s   loc_FFF2647F
FFF2647A  e10002                            mov.l   1Ch+var_14[sp], 1Ch+var_1C[sp]
FFF2647D  2e3f                              bra.b   loc_FFF264BC
FFF2647F  a901                   loc_FFF2647F mov.l   1Ch+var_C[sp], r1
FFF26481  711110                            add     #10h, r1, r1
FFF26484  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF26486  b581                              movu.b  1Ch+var_6[sp], r1
FFF26488  6c51                              shll    #5, r1
FFF2648A  06890101                          add     1Ch+var_18[sp].l, r1
FFF2648E  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF26490  a981                              mov.l   1Ch+var_4[sp], r1
FFF26492  ad9c                              mov.l   5Ch[r1], r4
FFF26494  a809                              mov.l   1Ch+var_18[sp], r1
FFF26496  754320                            mov.l   #20h, r3 ; ' '
FFF26499  6602                              mov.l   #0, r2
FFF2649B  05148000                          bsr.a   sub_FFF2E4AF
FFF2649F  a981                              mov.l   1Ch+var_4[sp], r1
FFF264A1  ae1a                              mov.l   64h[r1], r2
FFF264A3  490217                            add     1Ch+var_5[sp], r2
FFF264A6  a903                              mov.l   1Ch+var_C[sp], r3
FFF264A8  6614                              mov.l   #1, r4
FFF264AA  05f88bff                          bsr.a   sub_FFF1F0A2
FFF264AE  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF264B0  a881                              mov.l   1Ch+var_14[sp], r1
FFF264B2  6101                              cmp     #0, r1
FFF264B4  15                                beq.s   loc_FFF264B9
FFF264B5  e10002                            mov.l   1Ch+var_14[sp], 1Ch+var_1C[sp]
FFF264B8  0c                                bra.s   loc_FFF264BC
FFF264B9  f80600                 loc_FFF264B9 mov.l   #0, 1Ch+var_1C[sp]
FFF264BC  ec01                   loc_FFF264BC mov.l   1Ch+var_1C[sp], r1
FFF264BE  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF264C0  6707                              rtsd    #7
FFF264C2  7100b0                 sub_FFF264C2 add     #-50h, sp, sp   ; <<<< FUNC sub_FFF264C2
FFF264C5  a489                              mov.l   r1, 50h+var_4[sp]
FFF264C7  a482                              mov.l   r2, 50h+var_8[sp]
FFF264C9  a40b                              mov.l   r3, 50h+var_C[sp]
FFF264CB  a404                              mov.l   r4, 50h+var_10[sp]
FFF264CD  e500150f                          mov.l   50h+arg_0[sp], 50h+var_14[sp]
FFF264D1  3e0d00                            mov.l   #0, 50h+var_1C[sp]
FFF264D4  3e0c00                            mov.l   #0, 50h+var_20[sp]
FFF264D7  710108                            add     #50h+var_48, sp, r1
FFF264DA  05e9f9fe                          bsr.a   sub_FFF15EC3
FFF264DE  ac81                              mov.l   50h+var_8[sp], r1
FFF264E0  581e                              movu.b  [r1], r14
FFF264E2  755ee5                            cmp     #-1Bh, r14
FFF264E5  2111                              bne.b   loc_FFF264F6
FFF264E7  ac81                              mov.l   50h+var_8[sp], r1
FFF264E9  b999                              movu.w  0Eh[r1], r1
FFF264EB  ac0a                              mov.l   50h+var_C[sp], r2
FFF264ED  06c52104                          cmp     8[r2].uw, r1
FFF264F1  1d                                bne.s   loc_FFF264F6
FFF264F2  f80601                            mov.l   #1, 50h+var_50[sp]
FFF264F5  0c                                bra.s   loc_FFF264F9
FFF264F6  f80600                 loc_FFF264F6 mov.l   #0, 50h+var_50[sp]
FFF264F9  ec01                   loc_FFF264F9 mov.l   50h+var_50[sp], r1
FFF264FB  6101                              cmp     #0, r1
FFF264FD  2011                              beq.b   loc_FFF2650E
FFF264FF  ac81                              mov.l   50h+var_8[sp], r1
FFF26501  ba11                              movu.w  10h[r1], r1
FFF26503  ac0a                              mov.l   50h+var_C[sp], r2
FFF26505  06c52105                          cmp     0Ah[r2].uw, r1
FFF26509  1d                                bne.s   loc_FFF2650E
FFF2650A  f80601                            mov.l   #1, 50h+var_50[sp]
FFF2650D  0c                                bra.s   loc_FFF26511
FFF2650E  f80600                 loc_FFF2650E mov.l   #0, 50h+var_50[sp]
FFF26511  ec01                   loc_FFF26511 mov.l   50h+var_50[sp], r1
FFF26513  6101                              cmp     #0, r1
FFF26515  2011                              beq.b   loc_FFF26526
FFF26517  ac09                              mov.l   50h+var_C[sp], r1
FFF26519  ac82                              mov.l   50h+var_8[sp], r2
FFF2651B  c1120d                            mov.b   0Dh[r1], [r2]
FFF2651E  ac01                              mov.l   50h+var_10[sp], r1
FFF26520  a81a                              mov.l   4[r1], r2
FFF26522  6212                              add     #1, r2
FFF26524  a01a                              mov.l   r2, 4[r1]
FFF26526  ac81                   loc_FFF26526 mov.l   50h+var_8[sp], r1
FFF26528  754ec0                            mov.l   #-40h, r14
FFF2652B  fc311e0b                          tst     0Bh[r1], r14
FFF2652F  201a                              beq.b   loc_FFF26549
FFF26531  ac81                              mov.l   50h+var_8[sp], r1
FFF26533  b299                              movu.b  0Bh[r1], r1
FFF26535  64f1                              and     #0Fh, r1
FFF26537  61f1                              cmp     #0Fh, r1
FFF26539  2110                              bne.b   loc_FFF26549
FFF2653B  ac81                              mov.l   50h+var_8[sp], r1
FFF2653D  a99a                              mov.l   1Ch[r1], r2
FFF2653F  6102                              cmp     #0, r2
FFF26541  15                                beq.s   loc_FFF26546
FFF26542  3c1b20                            mov.b   #20h, 0Bh[r1] ; ' '
FFF26545  0c                                bra.s   loc_FFF26549
FFF26546  3c1b10                 loc_FFF26546 mov.b   #10h, 0Bh[r1]
FFF26549  ac81                   loc_FFF26549 mov.l   50h+var_8[sp], r1
FFF2654B  62e1                              add     #0Eh, r1
FFF2654D  05578700                          bsr.a   sub_FFF2ECA4
FFF26551  9589                              mov.w   r1, 50h+var_22[sp]
FFF26553  bd89                              movu.w  50h+var_22[sp], r1
FFF26555  772100f800                        and     #0F800h, r1
FFF2655A  770100b800                        cmp     #0B800h, r1
FFF2655F  2a0e                              bgt.b   loc_FFF2656D
FFF26561  bd89                              movu.w  50h+var_22[sp], r1
FFF26563  7621e007                          and     #7E0h, r1
FFF26567  76016107                          cmp     #761h, r1
FFF2656B  2906                              blt.b   loc_FFF26571
FFF2656D  f80601                 loc_FFF2656D mov.l   #1, 50h+var_50[sp]
FFF26570  0c                                bra.s   loc_FFF26574
FFF26571  f80600                 loc_FFF26571 mov.l   #0, 50h+var_50[sp]
FFF26574  ec01                   loc_FFF26574 mov.l   50h+var_50[sp], r1
FFF26576  6101                              cmp     #0, r1
FFF26578  210c                              bne.b   loc_FFF26584
FFF2657A  bd89                              movu.w  50h+var_22[sp], r1
FFF2657C  75211f                            and     #1Fh, r1
FFF2657F  75511e                            cmp     #1Eh, r1
FFF26582  2906                              blt.b   loc_FFF26588
FFF26584  f80601                 loc_FFF26584 mov.l   #1, 50h+var_50[sp]
FFF26587  0c                                bra.s   loc_FFF2658B
FFF26588  f80600                 loc_FFF26588 mov.l   #0, 50h+var_50[sp]
FFF2658B  ec01                   loc_FFF2658B mov.l   50h+var_50[sp], r1
FFF2658D  6101                              cmp     #0, r1
FFF2658F  2031                              beq.b   loc_FFF265C0
FFF26591  ac81                              mov.l   50h+var_8[sp], r1
FFF26593  3d1700                            mov.w   #0, 0Eh[r1]
FFF26596  a881                              mov.l   50h+var_48[sp], r1
FFF26598  fd748102                          div     #2, r1
FFF2659C  ac82                              mov.l   50h+var_8[sp], r2
FFF2659E  91a9                              mov.w   r1, 0Eh[r2]
FFF265A0  a889                              mov.l   50h+var_44[sp], r1
FFF265A2  6c51                              shll    #5, r1
FFF265A4  ac82                              mov.l   50h+var_8[sp], r2
FFF265A6  06552107                          or      0Eh[r2].w, r1
FFF265AA  91a9                              mov.w   r1, 0Eh[r2]
FFF265AC  a901                              mov.l   50h+var_40[sp], r1
FFF265AE  6cb1                              shll    #0Bh, r1
FFF265B0  ac82                              mov.l   50h+var_8[sp], r2
FFF265B2  06552107                          or      0Eh[r2].w, r1
FFF265B6  91a9                              mov.w   r1, 0Eh[r2]
FFF265B8  ac01                              mov.l   50h+var_10[sp], r1
FFF265BA  a81a                              mov.l   4[r1], r2
FFF265BC  6212                              add     #1, r2
FFF265BE  a01a                              mov.l   r2, 4[r1]
FFF265C0  ac81                   loc_FFF265C0 mov.l   50h+var_8[sp], r1
FFF265C2  711110                            add     #10h, r1, r1
FFF265C5  05df8600                          bsr.a   sub_FFF2ECA4
FFF265C9  9581                              mov.w   r1, 50h+var_24[sp]
FFF265CB  bd81                              movu.w  50h+var_24[sp], r1
FFF265CD  772100fe00                        and     #0FE00h, r1
FFF265D2  770100fe00                        cmp     #0FE00h, r1
FFF265D7  2a0e                              bgt.b   loc_FFF265E5
FFF265D9  bd81                              movu.w  50h+var_24[sp], r1
FFF265DB  7621e001                          and     #1E0h, r1
FFF265DF  76018101                          cmp     #181h, r1
FFF265E3  2906                              blt.b   loc_FFF265E9
FFF265E5  f80601                 loc_FFF265E5 mov.l   #1, 50h+var_50[sp]
FFF265E8  0c                                bra.s   loc_FFF265EC
FFF265E9  f80600                 loc_FFF265E9 mov.l   #0, 50h+var_50[sp]
FFF265EC  ec01                   loc_FFF265EC mov.l   50h+var_50[sp], r1
FFF265EE  6101                              cmp     #0, r1
FFF265F0  210c                              bne.b   loc_FFF265FC
FFF265F2  bd81                              movu.w  50h+var_24[sp], r1
FFF265F4  75211f                            and     #1Fh, r1
FFF265F7  755120                            cmp     #20h, r1 ; ' '
FFF265FA  2906                              blt.b   loc_FFF26600
FFF265FC  f80601                 loc_FFF265FC mov.l   #1, 50h+var_50[sp]
FFF265FF  0c                                bra.s   loc_FFF26603
FFF26600  f80600                 loc_FFF26600 mov.l   #0, 50h+var_50[sp]
FFF26603  ec01                   loc_FFF26603 mov.l   50h+var_50[sp], r1
FFF26605  6101                              cmp     #0, r1
FFF26607  2039                              beq.b   loc_FFF26640
FFF26609  ac81                              mov.l   50h+var_8[sp], r1
FFF2660B  3d1800                            mov.w   #0, 10h[r1]
FFF2660E  a909                              mov.l   50h+var_3C[sp], r1
FFF26610  ac82                              mov.l   50h+var_8[sp], r2
FFF26612  9221                              mov.w   r1, 10h[r2]
FFF26614  a981                              mov.l   50h+var_38[sp], r1
FFF26616  6211                              add     #1, r1
FFF26618  6c51                              shll    #5, r1
FFF2661A  ac82                              mov.l   50h+var_8[sp], r2
FFF2661C  06552108                          or      10h[r2].w, r1
FFF26620  9221                              mov.w   r1, 10h[r2]
FFF26622  a989                              mov.l   50h+var_34[sp], r1
FFF26624  755150                            cmp     #50h, r1 ; 'P'
FFF26627  2911                              blt.b   loc_FFF26638
FFF26629  a989                              mov.l   50h+var_34[sp], r1
FFF2662B  7111b0                            add     #-50h, r1, r1
FFF2662E  6c91                              shll    #9, r1
FFF26630  ac82                              mov.l   50h+var_8[sp], r2
FFF26632  06552108                          or      10h[r2].w, r1
FFF26636  9221                              mov.w   r1, 10h[r2]
FFF26638  ac01                   loc_FFF26638 mov.l   50h+var_10[sp], r1
FFF2663A  a81a                              mov.l   4[r1], r2
FFF2663C  6212                              add     #1, r2
FFF2663E  a01a                              mov.l   r2, 4[r1]
FFF26640  ac81                   loc_FFF26640 mov.l   50h+var_8[sp], r1
FFF26642  711112                            add     #12h, r1, r1
FFF26645  055f8600                          bsr.a   sub_FFF2ECA4
FFF26649  9581                              mov.w   r1, 50h+var_24[sp]
FFF2664B  bd81                              movu.w  50h+var_24[sp], r1
FFF2664D  772100fe00                        and     #0FE00h, r1
FFF26652  770100fe00                        cmp     #0FE00h, r1
FFF26657  2a0e                              bgt.b   loc_FFF26665
FFF26659  bd81                              movu.w  50h+var_24[sp], r1
FFF2665B  7621e001                          and     #1E0h, r1
FFF2665F  76018101                          cmp     #181h, r1
FFF26663  2906                              blt.b   loc_FFF26669
FFF26665  f80601                 loc_FFF26665 mov.l   #1, 50h+var_50[sp]
FFF26668  0c                                bra.s   loc_FFF2666C
FFF26669  f80600                 loc_FFF26669 mov.l   #0, 50h+var_50[sp]
FFF2666C  ec01                   loc_FFF2666C mov.l   50h+var_50[sp], r1
FFF2666E  6101                              cmp     #0, r1
FFF26670  210c                              bne.b   loc_FFF2667C
FFF26672  bd81                              movu.w  50h+var_24[sp], r1
FFF26674  75211f                            and     #1Fh, r1
FFF26677  755120                            cmp     #20h, r1 ; ' '
FFF2667A  2906                              blt.b   loc_FFF26680
FFF2667C  f80601                 loc_FFF2667C mov.l   #1, 50h+var_50[sp]
FFF2667F  0c                                bra.s   loc_FFF26683
FFF26680  f80600                 loc_FFF26680 mov.l   #0, 50h+var_50[sp]
FFF26683  ec01                   loc_FFF26683 mov.l   50h+var_50[sp], r1
FFF26685  6101                              cmp     #0, r1
FFF26687  2039                              beq.b   loc_FFF266C0
FFF26689  ac81                              mov.l   50h+var_8[sp], r1
FFF2668B  3d1900                            mov.w   #0, 12h[r1]
FFF2668E  a909                              mov.l   50h+var_3C[sp], r1
FFF26690  ac82                              mov.l   50h+var_8[sp], r2
FFF26692  9229                              mov.w   r1, 12h[r2]
FFF26694  a981                              mov.l   50h+var_38[sp], r1
FFF26696  6211                              add     #1, r1
FFF26698  6c51                              shll    #5, r1
FFF2669A  ac82                              mov.l   50h+var_8[sp], r2
FFF2669C  06552109                          or      12h[r2].w, r1
FFF266A0  9229                              mov.w   r1, 12h[r2]
FFF266A2  a989                              mov.l   50h+var_34[sp], r1
FFF266A4  755150                            cmp     #50h, r1 ; 'P'
FFF266A7  2911                              blt.b   loc_FFF266B8
FFF266A9  a989                              mov.l   50h+var_34[sp], r1
FFF266AB  7111b0                            add     #-50h, r1, r1
FFF266AE  6c91                              shll    #9, r1
FFF266B0  ac82                              mov.l   50h+var_8[sp], r2
FFF266B2  06552109                          or      12h[r2].w, r1
FFF266B6  9229                              mov.w   r1, 12h[r2]
FFF266B8  ac01                   loc_FFF266B8 mov.l   50h+var_10[sp], r1
FFF266BA  a81a                              mov.l   4[r1], r2
FFF266BC  6212                              add     #1, r2
FFF266BE  a01a                              mov.l   r2, 4[r1]
FFF266C0  ac81                   loc_FFF266C0 mov.l   50h+var_8[sp], r1
FFF266C2  711116                            add     #16h, r1, r1
FFF266C5  05df8500                          bsr.a   sub_FFF2ECA4
FFF266C9  9589                              mov.w   r1, 50h+var_22[sp]
FFF266CB  bd89                              movu.w  50h+var_22[sp], r1
FFF266CD  772100f800                        and     #0F800h, r1
FFF266D2  770100b800                        cmp     #0B800h, r1
FFF266D7  2a0e                              bgt.b   loc_FFF266E5
FFF266D9  bd89                              movu.w  50h+var_22[sp], r1
FFF266DB  7621e007                          and     #7E0h, r1
FFF266DF  76016107                          cmp     #761h, r1
FFF266E3  2906                              blt.b   loc_FFF266E9
FFF266E5  f80601                 loc_FFF266E5 mov.l   #1, 50h+var_50[sp]
FFF266E8  0c                                bra.s   loc_FFF266EC
FFF266E9  f80600                 loc_FFF266E9 mov.l   #0, 50h+var_50[sp]
FFF266EC  ec01                   loc_FFF266EC mov.l   50h+var_50[sp], r1
FFF266EE  6101                              cmp     #0, r1
FFF266F0  210c                              bne.b   loc_FFF266FC
FFF266F2  bd89                              movu.w  50h+var_22[sp], r1
FFF266F4  75211f                            and     #1Fh, r1
FFF266F7  75511e                            cmp     #1Eh, r1
FFF266FA  2906                              blt.b   loc_FFF26700
FFF266FC  f80601                 loc_FFF266FC mov.l   #1, 50h+var_50[sp]
FFF266FF  0c                                bra.s   loc_FFF26703
FFF26700  f80600                 loc_FFF26700 mov.l   #0, 50h+var_50[sp]
FFF26703  ec01                   loc_FFF26703 mov.l   50h+var_50[sp], r1
FFF26705  6101                              cmp     #0, r1
FFF26707  202d                              beq.b   loc_FFF26734
FFF26709  ac81                              mov.l   50h+var_8[sp], r1
FFF2670B  3d1b00                            mov.w   #0, 16h[r1]
FFF2670E  a881                              mov.l   50h+var_48[sp], r1
FFF26710  ac82                              mov.l   50h+var_8[sp], r2
FFF26712  92a9                              mov.w   r1, 16h[r2]
FFF26714  a901                              mov.l   50h+var_40[sp], r1
FFF26716  6cb1                              shll    #0Bh, r1
FFF26718  ac82                              mov.l   50h+var_8[sp], r2
FFF2671A  0655210b                          or      16h[r2].w, r1
FFF2671E  92a9                              mov.w   r1, 16h[r2]
FFF26720  a889                              mov.l   50h+var_44[sp], r1
FFF26722  6c51                              shll    #5, r1
FFF26724  ac82                              mov.l   50h+var_8[sp], r2
FFF26726  0655210b                          or      16h[r2].w, r1
FFF2672A  92a9                              mov.w   r1, 16h[r2]
FFF2672C  ac01                              mov.l   50h+var_10[sp], r1
FFF2672E  a81a                              mov.l   4[r1], r2
FFF26730  6212                              add     #1, r2
FFF26732  a01a                              mov.l   r2, 4[r1]
FFF26734  ac81                   loc_FFF26734 mov.l   50h+var_8[sp], r1
FFF26736  711118                            add     #18h, r1, r1
FFF26739  056b8500                          bsr.a   sub_FFF2ECA4
FFF2673D  9581                              mov.w   r1, 50h+var_24[sp]
FFF2673F  bd81                              movu.w  50h+var_24[sp], r1
FFF26741  772100fe00                        and     #0FE00h, r1
FFF26746  770100fe00                        cmp     #0FE00h, r1
FFF2674B  2a0e                              bgt.b   loc_FFF26759
FFF2674D  bd81                              movu.w  50h+var_24[sp], r1
FFF2674F  7621e001                          and     #1E0h, r1
FFF26753  76018101                          cmp     #181h, r1
FFF26757  2906                              blt.b   loc_FFF2675D
FFF26759  f80601                 loc_FFF26759 mov.l   #1, 50h+var_50[sp]
FFF2675C  0c                                bra.s   loc_FFF26760
FFF2675D  f80600                 loc_FFF2675D mov.l   #0, 50h+var_50[sp]
FFF26760  ec01                   loc_FFF26760 mov.l   50h+var_50[sp], r1
FFF26762  6101                              cmp     #0, r1
FFF26764  210c                              bne.b   loc_FFF26770
FFF26766  bd81                              movu.w  50h+var_24[sp], r1
FFF26768  75211f                            and     #1Fh, r1
FFF2676B  755120                            cmp     #20h, r1 ; ' '
FFF2676E  2906                              blt.b   loc_FFF26774
FFF26770  f80601                 loc_FFF26770 mov.l   #1, 50h+var_50[sp]
FFF26773  0c                                bra.s   loc_FFF26777
FFF26774  f80600                 loc_FFF26774 mov.l   #0, 50h+var_50[sp]
FFF26777  ec01                   loc_FFF26777 mov.l   50h+var_50[sp], r1
FFF26779  6101                              cmp     #0, r1
FFF2677B  2039                              beq.b   loc_FFF267B4
FFF2677D  ac81                              mov.l   50h+var_8[sp], r1
FFF2677F  3d1c00                            mov.w   #0, 18h[r1]
FFF26782  a909                              mov.l   50h+var_3C[sp], r1
FFF26784  ac82                              mov.l   50h+var_8[sp], r2
FFF26786  9321                              mov.w   r1, 18h[r2]
FFF26788  a981                              mov.l   50h+var_38[sp], r1
FFF2678A  6211                              add     #1, r1
FFF2678C  6c51                              shll    #5, r1
FFF2678E  ac82                              mov.l   50h+var_8[sp], r2
FFF26790  0655210c                          or      18h[r2].w, r1
FFF26794  9321                              mov.w   r1, 18h[r2]
FFF26796  a989                              mov.l   50h+var_34[sp], r1
FFF26798  755150                            cmp     #50h, r1 ; 'P'
FFF2679B  2911                              blt.b   loc_FFF267AC
FFF2679D  a989                              mov.l   50h+var_34[sp], r1
FFF2679F  7111b0                            add     #-50h, r1, r1
FFF267A2  6c91                              shll    #9, r1
FFF267A4  ac82                              mov.l   50h+var_8[sp], r2
FFF267A6  0655210c                          or      18h[r2].w, r1
FFF267AA  9321                              mov.w   r1, 18h[r2]
FFF267AC  ac01                   loc_FFF267AC mov.l   50h+var_10[sp], r1
FFF267AE  a81a                              mov.l   4[r1], r2
FFF267B0  6212                              add     #1, r2
FFF267B2  a01a                              mov.l   r2, 4[r1]
FFF267B4  ac89                   loc_FFF267B4 mov.l   50h+var_4[sp], r1
FFF267B6  8c12                              mov.b   10h[r1], r2
FFF267B8  61c2                              cmp     #0Ch, r2
FFF267BA  2114                              bne.b   loc_FFF267CE
FFF267BC  ad99                              mov.l   5Ch[r1], r1
FFF267BE  ac8a                              mov.l   50h+var_4[sp], r2
FFF267C0  068d2103                          mul     0Ch[r2].l, r1
FFF267C4  6c11                              shll    #1, r1
FFF267C6  fd749103                          divu    #3, r1
FFF267CA  a309                              mov.l   r1, 50h+var_1C[sp]
FFF267CC  2e34                              bra.b   loc_FFF26800
FFF267CE  8c11                   loc_FFF267CE mov.b   10h[r1], r1
FFF267D0  755110                            cmp     #10h, r1
FFF267D3  ac89                              mov.l   50h+var_4[sp], r1
FFF267D5  2110                              bne.b   loc_FFF267E5
FFF267D7  ad99                              mov.l   5Ch[r1], r1
FFF267D9  6811                              shlr    #1, r1
FFF267DB  ac8a                              mov.l   50h+var_4[sp], r2
FFF267DD  068d2103                          mul     0Ch[r2].l, r1
FFF267E1  a309                              mov.l   r1, 50h+var_1C[sp]
FFF267E3  2e1d                              bra.b   loc_FFF26800
FFF267E5  8c11                   loc_FFF267E5 mov.b   10h[r1], r1
FFF267E7  755120                            cmp     #20h, r1 ; ' '
FFF267EA  210f                              bne.b   loc_FFF267F9
FFF267EC  ac89                              mov.l   50h+var_4[sp], r1
FFF267EE  ad9a                              mov.l   5Ch[r1], r2
FFF267F0  6822                              shlr    #2, r2
FFF267F2  068d1203                          mul     0Ch[r1].l, r2
FFF267F6  a30a                              mov.l   r2, 50h+var_1C[sp]
FFF267F8  08                                bra.s   loc_FFF26800
FFF267F9  f90601f3               loc_FFF267F9 mov.l   #-0Dh, 50h+var_4C[sp]
FFF267FD  388b00                            bra.w   loc_FFF26888
FFF26800  ac89                   loc_FFF26800 mov.l   50h+var_4[sp], r1
FFF26802  a89a                              mov.l   0Ch[r1], r2
FFF26804  06cd1204                          mul     8[r1].uw, r2
FFF26808  06c91203                          add     6[r1].uw, r2
FFF2680C  b91b                              movu.w  0Ah[r1], r3
FFF2680E  6c53                              shll    #5, r3
FFF26810  06a1091317                        divu    5Ch[r1].l, r3
FFF26815  4b32                              add     r3, r2
FFF26817  a91b                              mov.l   14h[r1], r3
FFF26819  4323                              sub     r2, r3
FFF2681B  06e1091302                        divu    4[r1].uw, r3
FFF26820  6223                              add     #2, r3
FFF26822  0685030d                          cmp     50h+var_1C[sp].l, r3
FFF26826  2226                              bgeu.b  loc_FFF2684C
FFF26828  ac89                              mov.l   50h+var_4[sp], r1
FFF2682A  a89a                              mov.l   0Ch[r1], r2
FFF2682C  06cd1204                          mul     8[r1].uw, r2
FFF26830  06c91203                          add     6[r1].uw, r2
FFF26834  b91b                              movu.w  0Ah[r1], r3
FFF26836  6c53                              shll    #5, r3
FFF26838  06a1091317                        divu    5Ch[r1].l, r3
FFF2683D  4b32                              add     r3, r2
FFF2683F  a91b                              mov.l   14h[r1], r3
FFF26841  4323                              sub     r2, r3
FFF26843  06e1091302                        divu    4[r1].uw, r3
FFF26848  6223                              add     #2, r3
FFF2684A  a30b                              mov.l   r3, 50h+var_1C[sp]
FFF2684C  ab09                   loc_FFF2684C mov.l   50h+var_1C[sp], r1
FFF2684E  6021                              sub     #2, r1
FFF26850  a309                              mov.l   r1, 50h+var_1C[sp]
FFF26852  ac81                              mov.l   50h+var_8[sp], r1
FFF26854  71111a                            add     #1Ah, r1, r1
FFF26857  054d8400                          bsr.a   sub_FFF2ECA4
FFF2685B  a301                              mov.l   r1, 50h+var_20[sp]
FFF2685D  ac81                              mov.l   50h+var_8[sp], r1
FFF2685F  711114                            add     #14h, r1, r1
FFF26862  05428400                          bsr.a   sub_FFF2ECA4
FFF26866  6d01                              shll    #10h, r1
FFF26868  0695010c                          or      50h+var_20[sp].l, r1
FFF2686C  a301                              mov.l   r1, 50h+var_20[sp]
FFF2686E  ab09                              mov.l   50h+var_1C[sp], r1
FFF26870  0685010c                          cmp     50h+var_20[sp].l, r1
FFF26874  2211                              bgeu.b  loc_FFF26885
FFF26876  ac81                              mov.l   50h+var_8[sp], r1
FFF26878  3d1a00                            mov.w   #0, 14h[r1]
FFF2687B  ac81                              mov.l   50h+var_8[sp], r1
FFF2687D  3d1d00                            mov.w   #0, 1Ah[r1]
FFF26880  ac81                              mov.l   50h+var_8[sp], r1
FFF26882  3e1700                            mov.l   #0, 1Ch[r1]
FFF26885  3e0100                 loc_FFF26885 mov.l   #0, 50h+var_4C[sp]
FFF26888  a809                   loc_FFF26888 mov.l   50h+var_4C[sp], r1
FFF2688A  a381                              mov.l   r1, 50h+var_18[sp]
FFF2688C  6714                              rtsd    #14h
FFF2688E  7100b4                 sub_FFF2688E add     #-4Ch, sp, sp   ; <<<< FUNC sub_FFF2688E
FFF26891  a481                              mov.l   r1, 4Ch+var_4[sp]
FFF26893  a40a                              mov.l   r2, 4Ch+var_8[sp]
FFF26895  a403                              mov.l   r3, 4Ch+var_C[sp]
FFF26897  a38c                              mov.l   r4, 4Ch+var_10[sp]
FFF26899  e500140e                          mov.l   4Ch+arg_0[sp], 4Ch+var_14[sp]
FFF2689D  f9042a01                          mov.b   #1, 4Ch+var_22[sp]
FFF268A1  6601                              mov.l   #0, r1
FFF268A3  c70129                            mov.b   r1, 4Ch+var_23[sp]
FFF268A6  c70128                            mov.b   r1, 4Ch+var_24[sp]
FFF268A9  c70127                            mov.b   r1, 4Ch+var_25[sp]
FFF268AC  3c8a00                            mov.b   #0, 4Ch+var_32[sp]
FFF268AF  3e0500                            mov.l   #0, 4Ch+var_38[sp]
FFF268B2  3e0400                            mov.l   #0, 4Ch+var_3C[sp]
FFF268B5  3e0300                            mov.l   #0, 4Ch+var_40[sp]
FFF268B8  3e0200                            mov.l   #0, 4Ch+var_44[sp]
FFF268BB  ac0a                              mov.l   4Ch+var_8[sp], r2
FFF268BD  66b3                              mov.l   #0Bh, r3
FFF268BF  71011c                            add     #4Ch+var_30, sp, r1
FFF268C2  05cc7d00                          bsr.a   sub_FFF2E68E
FFF268C6  ac01                   loc_FFF268C6 mov.l   4Ch+var_C[sp], r1
FFF268C8  a819                              mov.l   4[r1], r1
FFF268CA  8609                              mov.b   r1, 4Ch+var_33[sp]
FFF268CC  f9042700                          mov.b   #0, 4Ch+var_25[sp]
FFF268D0  f9042b00                          mov.b   #0, 4Ch+var_21[sp]
FFF268D4  38bb02                            bra.w   loc_FFF26B8F
FFF268D7  59012b                 loc_FFF268D7 movu.b  4Ch+var_21[sp], r1
FFF268DA  6141                              cmp     #4, r1
FFF268DC  290a                              blt.b   loc_FFF268E6
FFF268DE  f90a01cffe                        mov.l   #-131h, 4Ch+var_48[sp]
FFF268E3  38b902                            bra.w   loc_FFF26B9C
FFF268E6  cd0127                 loc_FFF268E6 mov.b   4Ch+var_25[sp], r1
FFF268E9  6101                              cmp     #0, r1
FFF268EB  2149                              bne.b   loc_FFF26934
FFF268ED  ac01                              mov.l   4Ch+var_C[sp], r1
FFF268EF  b612                              movu.b  18h[r1], r2
FFF268F1  6102                              cmp     #0, r2
FFF268F3  19                                bne.s   loc_FFF268FC
FFF268F4  ec11                              mov.l   [r1], r1
FFF268F6  41012b                            sub     4Ch+var_21[sp], r1
FFF268F9  a109                              mov.l   r1, 4Ch+var_38[sp]
FFF268FB  08                                bra.s   loc_FFF26903
FFF268FC  a911                   loc_FFF268FC mov.l   10h[r1], r1
FFF268FE  41012b                            sub     4Ch+var_21[sp], r1
FFF26901  a109                              mov.l   r1, 4Ch+var_38[sp]
FFF26903  59012b                 loc_FFF26903 movu.b  4Ch+var_21[sp], r1
FFF26906  6101                              cmp     #0, r1
FFF26908  210e                              bne.b   loc_FFF26916
FFF2690A  ac81                              mov.l   4Ch+var_4[sp], r1
FFF2690C  8c11                              mov.b   10h[r1], r1
FFF2690E  755120                            cmp     #20h, r1 ; ' '
FFF26911  1d                                bne.s   loc_FFF26916
FFF26912  f80601                            mov.l   #1, 4Ch+var_4C[sp]
FFF26915  0c                                bra.s   loc_FFF26919
FFF26916  f80600                 loc_FFF26916 mov.l   #0, 4Ch+var_4C[sp]
FFF26919  ec01                   loc_FFF26919 mov.l   4Ch+var_4C[sp], r1
FFF2691B  6101                              cmp     #0, r1
FFF2691D  201d                              beq.b   loc_FFF2693A
FFF2691F  a90a                              mov.l   4Ch+var_38[sp], r2
FFF26921  ac81                              mov.l   4Ch+var_4[sp], r1
FFF26923  05c286ff                          bsr.a   sub_FFF1EFE5
FFF26927  a089                              mov.l   r1, 4Ch+var_40[sp]
FFF26929  a88a                              mov.l   4Ch+var_40[sp], r2
FFF2692B  ac81                              mov.l   4Ch+var_4[sp], r1
FFF2692D  057f86ff                          bsr.a   sub_FFF1EFAC
FFF26931  a101                              mov.l   r1, 4Ch+var_3C[sp]
FFF26933  0f                                bra.s   loc_FFF2693A
FFF26934  a909                   loc_FFF26934 mov.l   4Ch+var_38[sp], r1
FFF26936  6011                              sub     #1, r1
FFF26938  a109                              mov.l   r1, 4Ch+var_38[sp]
FFF2693A  ac81                   loc_FFF2693A mov.l   4Ch+var_4[sp], r1
FFF2693C  ab1a                              mov.l   34h[r1], r2
FFF2693E  056e86ff                          bsr.a   sub_FFF1EFAC
FFF26942  06850105                          cmp     4Ch+var_38[sp].l, r1
FFF26946  2505                              bleu.b  loc_FFF2694B
FFF26948  385102                            bra.w   loc_FFF26B99
FFF2694B  a909                   loc_FFF2694B mov.l   4Ch+var_38[sp], r1
FFF2694D  06850104                          cmp     4Ch+var_3C[sp].l, r1
FFF26951  220e                              bgeu.b  loc_FFF2695F
FFF26953  ac81                              mov.l   4Ch+var_4[sp], r1
FFF26955  8c11                              mov.b   10h[r1], r1
FFF26957  755120                            cmp     #20h, r1 ; ' '
FFF2695A  1d                                bne.s   loc_FFF2695F
FFF2695B  f80601                            mov.l   #1, 4Ch+var_4C[sp]
FFF2695E  0c                                bra.s   loc_FFF26962
FFF2695F  f80600                 loc_FFF2695F mov.l   #0, 4Ch+var_4C[sp]
FFF26962  ec01                   loc_FFF26962 mov.l   4Ch+var_4C[sp], r1
FFF26964  6101                              cmp     #0, r1
FFF26966  2037                              beq.b   loc_FFF2699D
FFF26968  ab84                              mov.l   4Ch+var_14[sp], r4
FFF2696A  a88a                              mov.l   4Ch+var_40[sp], r2
FFF2696C  ac81                              mov.l   4Ch+var_4[sp], r1
FFF2696E  710308                            add     #4Ch+var_44, sp, r3
FFF26971  052be4ff                          bsr.a   sub_FFF24D9C
FFF26975  a301                              mov.l   r1, 4Ch+var_1C[sp]
FFF26977  ab01                              mov.l   4Ch+var_1C[sp], r1
FFF26979  6101                              cmp     #0, r1
FFF2697B  10                                beq.s   loc_FFF26983
FFF2697C  e5000c01                          mov.l   4Ch+var_1C[sp], 4Ch+var_48[sp]
FFF26980  381c02                            bra.w   loc_FFF26B9C
FFF26983  a882                   loc_FFF26983 mov.l   4Ch+var_44[sp], r2
FFF26985  ac81                              mov.l   4Ch+var_4[sp], r1
FFF26987  052586ff                          bsr.a   sub_FFF1EFAC
FFF2698B  a109                              mov.l   r1, 4Ch+var_38[sp]
FFF2698D  ac81                              mov.l   4Ch+var_4[sp], r1
FFF2698F  b891                              movu.w  4[r1], r1
FFF26991  06890105                          add     4Ch+var_38[sp].l, r1
FFF26995  6011                              sub     #1, r1
FFF26997  a109                              mov.l   r1, 4Ch+var_38[sp]
FFF26999  f9042701                          mov.b   #1, 4Ch+var_25[sp]
FFF2699D  ab83                   loc_FFF2699D mov.l   4Ch+var_14[sp], r3
FFF2699F  a90a                              mov.l   4Ch+var_38[sp], r2
FFF269A1  ac81                              mov.l   4Ch+var_4[sp], r1
FFF269A3  72330602                          add     #206h, r3, r3
FFF269A7  6614                              mov.l   #1, r4
FFF269A9  056886ff                          bsr.a   sub_FFF1F011
FFF269AD  a301                              mov.l   r1, 4Ch+var_1C[sp]
FFF269AF  ab01                              mov.l   4Ch+var_1C[sp], r1
FFF269B1  6101                              cmp     #0, r1
FFF269B3  10                                beq.s   loc_FFF269BB
FFF269B4  e5000c01                          mov.l   4Ch+var_1C[sp], 4Ch+var_48[sp]
FFF269B8  38e401                            bra.w   loc_FFF26B9C
FFF269BB  59012b                 loc_FFF269BB movu.b  4Ch+var_21[sp], r1
FFF269BE  6101                              cmp     #0, r1
FFF269C0  2021                              beq.b   loc_FFF269E1
FFF269C2  ab81                              mov.l   4Ch+var_14[sp], r1
FFF269C4  72110602                          add     #206h, r1, r1
FFF269C8  a289                              mov.l   r1, 4Ch+var_20[sp]
FFF269CA  ac81                              mov.l   4Ch+var_4[sp], r1
FFF269CC  ad99                              mov.l   5Ch[r1], r1
FFF269CE  6851                              shlr    #5, r1
FFF269D0  8609                              mov.b   r1, 4Ch+var_33[sp]
FFF269D2  b609                              movu.b  4Ch+var_33[sp], r1
FFF269D4  6c51                              shll    #5, r1
FFF269D6  0689010b                          add     4Ch+var_20[sp].l, r1
FFF269DA  7111e0                            add     #-20h, r1, r1
FFF269DD  a289                              mov.l   r1, 4Ch+var_20[sp]
FFF269DF  2e35                              bra.b   loc_FFF26A14
FFF269E1  e500110b               loc_FFF269E1 mov.l   4Ch+var_8[sp], 4Ch+var_20[sp]
FFF269E5  aa89                              mov.l   4Ch+var_20[sp], r1
FFF269E7  7111e0                            add     #-20h, r1, r1
FFF269EA  a289                              mov.l   r1, 4Ch+var_20[sp]
FFF269EC  aa89                              mov.l   4Ch+var_20[sp], r1
FFF269EE  8a99                              mov.b   0Bh[r1], r1
FFF269F0  61f1                              cmp     #0Fh, r1
FFF269F2  2022                              beq.b   loc_FFF26A14
FFF269F4  ab83                              mov.l   4Ch+var_14[sp], r3
FFF269F6  a90a                              mov.l   4Ch+var_38[sp], r2
FFF269F8  ac81                              mov.l   4Ch+var_4[sp], r1
FFF269FA  72330602                          add     #206h, r3, r3
FFF269FE  6614                              mov.l   #1, r4
FFF26A00  05a286ff                          bsr.a   sub_FFF1F0A2
FFF26A04  a301                              mov.l   r1, 4Ch+var_1C[sp]
FFF26A06  ab01                              mov.l   4Ch+var_1C[sp], r1
FFF26A08  6101                              cmp     #0, r1
FFF26A0A  3a8f01                            beq.w   loc_FFF26B99
FFF26A0D  e5000c01                          mov.l   4Ch+var_1C[sp], 4Ch+var_48[sp]
FFF26A11  388b01                            bra.w   loc_FFF26B9C
FFF26A14  cd0129                 loc_FFF26A14 mov.b   4Ch+var_23[sp], r1
FFF26A17  6101                              cmp     #0, r1
FFF26A19  3ad600                            beq.w   loc_FFF26AEF
FFF26A1C  38e800                            bra.w   loc_FFF26B04
FFF26A1F  aa89                   loc_FFF26A1F mov.l   4Ch+var_20[sp], r1
FFF26A21  b319                              movu.b  0Dh[r1], r1
FFF26A23  45011b                            cmp     4Ch+var_31[sp], r1
FFF26A26  1d                                bne.s   loc_FFF26A2B
FFF26A27  f80601                            mov.l   #1, 4Ch+var_4C[sp]
FFF26A2A  0c                                bra.s   loc_FFF26A2E
FFF26A2B  f80600                 loc_FFF26A2B mov.l   #0, 4Ch+var_4C[sp]
FFF26A2E  ec01                   loc_FFF26A2E mov.l   4Ch+var_4C[sp], r1
FFF26A30  6101                              cmp     #0, r1
FFF26A32  200f                              beq.b   loc_FFF26A41
FFF26A34  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26A36  3c1b0f                            mov.b   #0Fh, 0Bh[r1]
FFF26A39  ab89                              mov.l   4Ch+var_10[sp], r1
FFF26A3B  a81a                              mov.l   4[r1], r2
FFF26A3D  6212                              add     #1, r2
FFF26A3F  a01a                              mov.l   r2, 4[r1]
FFF26A41  aa89                   loc_FFF26A41 mov.l   4Ch+var_20[sp], r1
FFF26A43  b319                              movu.b  0Dh[r1], r1
FFF26A45  45011b                            cmp     4Ch+var_31[sp], r1
FFF26A48  10                                beq.s   loc_FFF26A50
FFF26A49  f9042901                          mov.b   #1, 4Ch+var_23[sp]
FFF26A4D  3879fe                            bra.w   loc_FFF268C6
FFF26A50  aa89                   loc_FFF26A50 mov.l   4Ch+var_20[sp], r1
FFF26A52  b691                              movu.b  1Ah[r1], r1
FFF26A54  6101                              cmp     #0, r1
FFF26A56  200f                              beq.b   loc_FFF26A65
FFF26A58  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26A5A  3c9a00                            mov.b   #0, 1Ah[r1]
FFF26A5D  ab89                              mov.l   4Ch+var_10[sp], r1
FFF26A5F  a81a                              mov.l   4[r1], r2
FFF26A61  6212                              add     #1, r2
FFF26A63  a01a                              mov.l   r2, 4[r1]
FFF26A65  aa89                   loc_FFF26A65 mov.l   4Ch+var_20[sp], r1
FFF26A67  b699                              movu.b  1Bh[r1], r1
FFF26A69  6101                              cmp     #0, r1
FFF26A6B  200f                              beq.b   loc_FFF26A7A
FFF26A6D  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26A6F  3c9b00                            mov.b   #0, 1Bh[r1]
FFF26A72  ab89                              mov.l   4Ch+var_10[sp], r1
FFF26A74  a81a                              mov.l   4[r1], r2
FFF26A76  6212                              add     #1, r2
FFF26A78  a01a                              mov.l   r2, 4[r1]
FFF26A7A  aa89                   loc_FFF26A7A mov.l   4Ch+var_20[sp], r1
FFF26A7C  581e                              movu.b  [r1], r14
FFF26A7E  450e2a                            cmp     4Ch+var_22[sp], r14
FFF26A81  204e                              beq.b   loc_FFF26ACF
FFF26A83  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26A85  581e                              movu.b  [r1], r14
FFF26A87  752e40                            and     #40h, r14 ; '@'
FFF26A8A  755e40                            cmp     #40h, r14 ; '@'
FFF26A8D  213b                              bne.b   loc_FFF26AC8
FFF26A8F  59012a                            movu.b  4Ch+var_22[sp], r1
FFF26A92  aa8a                              mov.l   4Ch+var_20[sp], r2
FFF26A94  ef1e                              mov.l   r1, r14
FFF26A96  502e                              and     [r2], r14
FFF26A98  471e                              cmp     r1, r14
FFF26A9A  2127                              bne.b   loc_FFF26AC1
FFF26A9C  f1061a                            bset    #6, 4Ch+var_32[sp].b
FFF26A9F  b681                              movu.b  4Ch+var_32[sp], r1
FFF26AA1  49012a                            add     4Ch+var_22[sp], r1
FFF26AA4  8681                              mov.b   r1, 4Ch+var_32[sp]
FFF26AA6  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26AA8  581e                              movu.b  [r1], r14
FFF26AAA  450e1a                            cmp     4Ch+var_32[sp], r14
FFF26AAD  210d                              bne.b   loc_FFF26ABA
FFF26AAF  f9042900                          mov.b   #0, 4Ch+var_23[sp]
FFF26AB3  f9042801                          mov.b   #1, 4Ch+var_24[sp]
FFF26AB7  38ac00                            bra.w   loc_FFF26B63
FFF26ABA  f9042901               loc_FFF26ABA mov.b   #1, 4Ch+var_23[sp]
FFF26ABE  3808fe                            bra.w   loc_FFF268C6
FFF26AC1  f9042901               loc_FFF26AC1 mov.b   #1, 4Ch+var_23[sp]
FFF26AC5  3801fe                            bra.w   loc_FFF268C6
FFF26AC8  f9042901               loc_FFF26AC8 mov.b   #1, 4Ch+var_23[sp]
FFF26ACC  389700                            bra.w   loc_FFF26B63
FFF26ACF  59012a                 loc_FFF26ACF movu.b  4Ch+var_22[sp], r1
FFF26AD2  6211                              add     #1, r1
FFF26AD4  c7012a                            mov.b   r1, 4Ch+var_22[sp]
FFF26AD7  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26AD9  7111e0                            add     #-20h, r1, r1
FFF26ADC  a289                              mov.l   r1, 4Ch+var_20[sp]
FFF26ADE  b609                              movu.b  4Ch+var_33[sp], r1
FFF26AE0  6011                              sub     #1, r1
FFF26AE2  8609                              mov.b   r1, 4Ch+var_33[sp]
FFF26AE4  b609                              movu.b  4Ch+var_33[sp], r1
FFF26AE6  6101                              cmp     #0, r1
FFF26AE8  1f                                bne.s   loc_FFF26AEF
FFF26AE9  f9042900                          mov.b   #0, 4Ch+var_23[sp]
FFF26AED  2e76                              bra.b   loc_FFF26B63
FFF26AEF  71011c                 loc_FFF26AEF add     #4Ch+var_30, sp, r1
FFF26AF2  05209eff                          bsr.a   sub_FFF20912
FFF26AF6  8689                              mov.b   r1, 4Ch+var_31[sp]
FFF26AF8  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26AFA  8a99                              mov.b   0Bh[r1], r1
FFF26AFC  61f1                              cmp     #0Fh, r1
FFF26AFE  3b21ff                            bne.w   loc_FFF26A1F
FFF26B01  382aff                            bra.w   loc_FFF26A2B
FFF26B04  aa89                   loc_FFF26B04 mov.l   4Ch+var_20[sp], r1
FFF26B06  581e                              movu.b  [r1], r14
FFF26B08  755e2e                            cmp     #2Eh, r14 ; '.'
FFF26B0B  210e                              bne.b   loc_FFF26B19
FFF26B0D  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26B0F  b019                              movu.b  1[r1], r1
FFF26B11  75512e                            cmp     #2Eh, r1 ; '.'
FFF26B14  1d                                bne.s   loc_FFF26B19
FFF26B15  f80601                            mov.l   #1, 4Ch+var_4C[sp]
FFF26B18  0c                                bra.s   loc_FFF26B1C
FFF26B19  f80600                 loc_FFF26B19 mov.l   #0, 4Ch+var_4C[sp]
FFF26B1C  ec01                   loc_FFF26B1C mov.l   4Ch+var_4C[sp], r1
FFF26B1E  6101                              cmp     #0, r1
FFF26B20  2012                              beq.b   loc_FFF26B32
FFF26B22  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26B24  7111e0                            add     #-20h, r1, r1
FFF26B27  a289                              mov.l   r1, 4Ch+var_20[sp]
FFF26B29  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26B2B  581e                              movu.b  [r1], r14
FFF26B2D  755e2e                            cmp     #2Eh, r14 ; '.'
FFF26B30  2033                              beq.b   loc_FFF26B63
FFF26B32  aa89                   loc_FFF26B32 mov.l   4Ch+var_20[sp], r1
FFF26B34  581e                              movu.b  [r1], r14
FFF26B36  752e40                            and     #40h, r14 ; '@'
FFF26B39  755e40                            cmp     #40h, r14 ; '@'
FFF26B3C  1d                                bne.s   loc_FFF26B41
FFF26B3D  f9042801                          mov.b   #1, 4Ch+var_24[sp]
FFF26B41  aa89                   loc_FFF26B41 mov.l   4Ch+var_20[sp], r1
FFF26B43  f814e5                            mov.b   #-1Bh, [r1]
FFF26B46  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26B48  7111e0                            add     #-20h, r1, r1
FFF26B4B  a289                              mov.l   r1, 4Ch+var_20[sp]
FFF26B4D  b609                              movu.b  4Ch+var_33[sp], r1
FFF26B4F  6011                              sub     #1, r1
FFF26B51  8609                              mov.b   r1, 4Ch+var_33[sp]
FFF26B53  b609                              movu.b  4Ch+var_33[sp], r1
FFF26B55  6101                              cmp     #0, r1
FFF26B57  200c                              beq.b   loc_FFF26B63
FFF26B59  aa89                              mov.l   4Ch+var_20[sp], r1
FFF26B5B  b299                              movu.b  0Bh[r1], r1
FFF26B5D  64f1                              and     #0Fh, r1
FFF26B5F  61f1                              cmp     #0Fh, r1
FFF26B61  20a3                              beq.b   loc_FFF26B04
FFF26B63  ab83                   loc_FFF26B63 mov.l   4Ch+var_14[sp], r3
FFF26B65  a90a                              mov.l   4Ch+var_38[sp], r2
FFF26B67  ac81                              mov.l   4Ch+var_4[sp], r1
FFF26B69  72330602                          add     #206h, r3, r3
FFF26B6D  6614                              mov.l   #1, r4
FFF26B6F  053385ff                          bsr.a   sub_FFF1F0A2
FFF26B73  a301                              mov.l   r1, 4Ch+var_1C[sp]
FFF26B75  ab01                              mov.l   4Ch+var_1C[sp], r1
FFF26B77  6101                              cmp     #0, r1
FFF26B79  17                                beq.s   loc_FFF26B80
FFF26B7A  e5000c01                          mov.l   4Ch+var_1C[sp], 4Ch+var_48[sp]
FFF26B7E  2e1e                              bra.b   loc_FFF26B9C
FFF26B80  cd0128                 loc_FFF26B80 mov.b   4Ch+var_24[sp], r1
FFF26B83  6111                              cmp     #1, r1
FFF26B85  2014                              beq.b   loc_FFF26B99
FFF26B87  59012b                            movu.b  4Ch+var_21[sp], r1
FFF26B8A  6211                              add     #1, r1
FFF26B8C  c7012b                            mov.b   r1, 4Ch+var_21[sp]
FFF26B8F  59012b                 loc_FFF26B8F movu.b  4Ch+var_21[sp], r1
FFF26B92  6131                              cmp     #3, r1
FFF26B94  2805                              bge.b   loc_FFF26B99
FFF26B96  3841fd                            bra.w   loc_FFF268D7
FFF26B99  3e0100                 loc_FFF26B99 mov.l   #0, 4Ch+var_48[sp]
FFF26B9C  a809                   loc_FFF26B9C mov.l   4Ch+var_48[sp], r1
FFF26B9E  a309                              mov.l   r1, 4Ch+var_18[sp]
FFF26BA0  6713                              rtsd    #13h
FFF26BA2  7ea6                   sub_FFF26BA2 push.l  r6   ; <<<< FUNC sub_FFF26BA2
FFF26BA4  7100b0                            add     #-50h, sp, sp
FFF26BA7  a489                              mov.l   r1, 50h+var_4[sp]
FFF26BA9  a482                              mov.l   r2, 50h+var_8[sp]
FFF26BAB  ef21                              mov.l   r2, r1
FFF26BAD  72110c10                          add     #100Ch, r1, r1
FFF26BB1  710204                            add     #50h+var_4C, sp, r2
FFF26BB4  05e80900                          bsr.a   sub_FFF2759C
FFF26BB8  a401                              mov.l   r1, 50h+var_10[sp]
FFF26BBA  ac01                              mov.l   50h+var_10[sp], r1
FFF26BBC  6101                              cmp     #0, r1
FFF26BBE  16                                beq.s   loc_FFF26BC4
FFF26BBF  e10010                            mov.l   50h+var_10[sp], 50h+var_50[sp]
FFF26BC2  2e20                              bra.b   loc_FFF26BE2
FFF26BC4  e5000d0f               loc_FFF26BC4 mov.l   50h+var_1C[sp], 50h+var_14[sp]
FFF26BC8  ab89                              mov.l   50h+var_14[sp], r1
FFF26BCA  6101                              cmp     #0, r1
FFF26BCC  1f                                bne.s   loc_FFF26BD3
FFF26BCD  f80ad3fe                          mov.l   #-12Dh, 50h+var_50[sp]
FFF26BD1  2e11                              bra.b   loc_FFF26BE2
FFF26BD3  ac8e                   loc_FFF26BD3 mov.l   50h+var_4[sp], r6
FFF26BD5  ab8a                              mov.l   50h+var_14[sp], r2
FFF26BD7  ef61                              mov.l   r6, r1
FFF26BD9  05d383ff                          bsr.a   sub_FFF1EFAC
FFF26BDD  a669                              mov.l   r1, 64h[r6]
FFF26BDF  f80600                            mov.l   #0, 50h+var_50[sp]
FFF26BE2  ec01                   loc_FFF26BE2 mov.l   50h+var_50[sp], r1
FFF26BE4  a409                              mov.l   r1, 50h+var_C[sp]
FFF26BE6  3f6615                            rtsd    #54h, r6-r6
FFF26BE9  6080                   sub_FFF26BE9 sub     #8, sp   ; <<<< FUNC sub_FFF26BE9
FFF26BEB  a009                              mov.l   r1, 8+var_4[sp]
FFF26BED  3c0200                            mov.b   #0, 8+var_6[sp]
FFF26BF0  2e17                              bra.b   loc_FFF26C07
FFF26BF2  b081                   loc_FFF26BF2 movu.b  8+var_6[sp], r1
FFF26BF4  6211                              add     #1, r1
FFF26BF6  8081                              mov.b   r1, 8+var_6[sp]
FFF26BF8  09                                bra.s   loc_FFF26C01
FFF26BF9  a809                   loc_FFF26BF9 mov.l   8+var_4[sp], r1
FFF26BFB  cc1e                              mov.b   [r1], r14
FFF26BFD  610e                              cmp     #0, r14
FFF26BFF  2013                              beq.b   loc_FFF26C12
FFF26C01  a809                   loc_FFF26C01 mov.l   8+var_4[sp], r1
FFF26C03  6211                              add     #1, r1
FFF26C05  a009                              mov.l   r1, 8+var_4[sp]
FFF26C07  a809                   loc_FFF26C07 mov.l   8+var_4[sp], r1
FFF26C09  cc1e                              mov.b   [r1], r14
FFF26C0B  755e5c                            cmp     #5Ch, r14 ; '\'
FFF26C0E  20e4                              beq.b   loc_FFF26BF2
FFF26C10  2ee9                              bra.b   loc_FFF26BF9
FFF26C12  b081                   loc_FFF26C12 movu.b  8+var_6[sp], r1
FFF26C14  6131                              cmp     #3, r1
FFF26C16  2905                              blt.b   loc_FFF26C1B
FFF26C18  3c0202                            mov.b   #2, 8+var_6[sp]
FFF26C1B  c5000203               loc_FFF26C1B mov.b   8+var_6[sp], 8+var_5[sp]
FFF26C1F  b089                              movu.b  8+var_5[sp], r1
FFF26C21  5b11                              movu.b  r1, r1
FFF26C23  6702                              rtsd    #2
FFF26C25  7100f0                 sub_FFF26C25 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF26C25
FFF26C28  9189                              mov.w   r1, 10h+var_2[sp]
FFF26C2A  9182                              mov.w   r2, 10h+var_4[sp]
FFF26C2C  a083                              mov.l   r3, 10h+var_8[sp]
FFF26C2E  b989                              movu.w  10h+var_2[sp], r1
FFF26C30  05fc7f00                          bsr.a   sub_FFF2EC2C
FFF26C34  8089                              mov.b   r1, 10h+var_D[sp]
FFF26C36  a883                              mov.l   10h+var_8[sp], r3
FFF26C38  9982                              mov.w   10h+var_4[sp], r2
FFF26C3A  b089                              movu.b  10h+var_D[sp], r1
FFF26C3C  058aeeff                          bsr.a   sub_FFF25AC6
FFF26C40  a009                              mov.l   r1, 10h+var_C[sp]
FFF26C42  6704                              rtsd    #4
FFF26C44  60c0                   sub_FFF26C44 sub     #0Ch, sp   ; <<<< FUNC sub_FFF26C44
FFF26C46  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF26C48  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF26C4A  3c0200                            mov.b   #0, 0Ch+var_A[sp]
FFF26C4D  a882                              mov.l   0Ch+var_4[sp], r2
FFF26C4F  a809                              mov.l   0Ch+var_8[sp], r1
FFF26C51  05f47f00                          bsr.a   sub_FFF2EC45
FFF26C55  2e17                              bra.b   loc_FFF26C6C
FFF26C57  b081                   loc_FFF26C57 movu.b  0Ch+var_A[sp], r1
FFF26C59  6211                              add     #1, r1
FFF26C5B  8081                              mov.b   r1, 0Ch+var_A[sp]
FFF26C5D  09                                bra.s   loc_FFF26C66
FFF26C5E  a809                   loc_FFF26C5E mov.l   0Ch+var_8[sp], r1
FFF26C60  5c1e                              movu.w  [r1], r14
FFF26C62  610e                              cmp     #0, r14
FFF26C64  2013                              beq.b   loc_FFF26C77
FFF26C66  a809                   loc_FFF26C66 mov.l   0Ch+var_8[sp], r1
FFF26C68  6221                              add     #2, r1
FFF26C6A  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF26C6C  a809                   loc_FFF26C6C mov.l   0Ch+var_8[sp], r1
FFF26C6E  5c1e                              movu.w  [r1], r14
FFF26C70  755e5c                            cmp     #5Ch, r14 ; '\'
FFF26C73  20e4                              beq.b   loc_FFF26C57
FFF26C75  2ee9                              bra.b   loc_FFF26C5E
FFF26C77  b081                   loc_FFF26C77 movu.b  0Ch+var_A[sp], r1
FFF26C79  6131                              cmp     #3, r1
FFF26C7B  2905                              blt.b   loc_FFF26C80
FFF26C7D  3c0202                            mov.b   #2, 0Ch+var_A[sp]
FFF26C80  c5000203               loc_FFF26C80 mov.b   0Ch+var_A[sp], 0Ch+var_9[sp]
FFF26C84  b089                              movu.b  0Ch+var_9[sp], r1
FFF26C86  5b11                              movu.b  r1, r1
FFF26C88  6703                              rtsd    #3
FFF26C8A  7100e8                 sub_FFF26C8A add     #-18h, sp, sp   ; <<<< FUNC sub_FFF26C8A
FFF26C8D  a109                              mov.l   r1, 18h+var_4[sp]
FFF26C8F  a102                              mov.l   r2, 18h+var_8[sp]
FFF26C91  0505f2fe                          bsr.a   sub_FFF15E96
FFF26C95  a009                              mov.l   r1, 18h+var_14[sp]
FFF26C97  a809                              mov.l   18h+var_14[sp], r1
FFF26C99  6101                              cmp     #0, r1
FFF26C9B  210f                              bne.b   loc_FFF26CAA
FFF26C9D  6602                              mov.l   #0, r2
FFF26C9F  fb16e1                            mov.l   #-1Fh, r1
FFF26CA2  057e81ff                          bsr.a   sub_FFF1EE20
FFF26CA6  e301                              mov.l   r1, 18h+var_18[sp]
FFF26CA8  2e16                              bra.b   loc_FFF26CBE
FFF26CAA  a80b                   loc_FFF26CAA mov.l   18h+var_14[sp], r3
FFF26CAC  a902                              mov.l   18h+var_8[sp], r2
FFF26CAE  a909                              mov.l   18h+var_4[sp], r1
FFF26CB0  391400                            bsr.w   sub_FFF26CC4
FFF26CB3  a081                              mov.l   r1, 18h+var_10[sp]
FFF26CB5  a809                              mov.l   18h+var_14[sp], r1
FFF26CB7  05eff1fe                          bsr.a   sub_FFF15EA6
FFF26CBB  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF26CBE  ec01                   loc_FFF26CBE mov.l   18h+var_18[sp], r1
FFF26CC0  a089                              mov.l   r1, 18h+var_C[sp]
FFF26CC2  6706                              rtsd    #6
FFF26CC4  6e67                   sub_FFF26CC4 pushm   r6-r7   ; <<<< FUNC sub_FFF26CC4
FFF26CC6  7100dc                            add     #-24h, sp, sp
FFF26CC9  a201                              mov.l   r1, 24h+var_4[sp]
FFF26CCB  a18a                              mov.l   r2, 24h+var_8[sp]
FFF26CCD  a183                              mov.l   r3, 24h+var_C[sp]
FFF26CCF  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF26CD5  e4e003                            mov.l   [r14], 24h+var_18[sp]
FFF26CD8  0513e3ff                          bsr.a   sub_FFF24FEB
FFF26CDC  a101                              mov.l   r1, 24h+var_14[sp]
FFF26CDE  a901                              mov.l   24h+var_14[sp], r1
FFF26CE0  6101                              cmp     #0, r1
FFF26CE2  200f                              beq.b   loc_FFF26CF1
FFF26CE4  a901                              mov.l   24h+var_14[sp], r1
FFF26CE6  6602                              mov.l   #0, r2
FFF26CE8  053881ff                          bsr.a   sub_FFF1EE20
FFF26CEC  a009                              mov.l   r1, 24h+var_20[sp]
FFF26CEE  38e101                            bra.w   loc_FFF26ECF
FFF26CF1  aa01                   loc_FFF26CF1 mov.l   24h+var_4[sp], r1
FFF26CF3  6101                              cmp     #0, r1
FFF26CF5  16                                beq.s   loc_FFF26CFB
FFF26CF6  a989                              mov.l   24h+var_8[sp], r1
FFF26CF8  6101                              cmp     #0, r1
FFF26CFA  1d                                bne.s   loc_FFF26CFF
FFF26CFB  f80601                 loc_FFF26CFB mov.l   #1, 24h+var_24[sp]
FFF26CFE  0c                                bra.s   loc_FFF26D02
FFF26CFF  f80600                 loc_FFF26CFF mov.l   #0, 24h+var_24[sp]
FFF26D02  ec01                   loc_FFF26D02 mov.l   24h+var_24[sp], r1
FFF26D04  6101                              cmp     #0, r1
FFF26D06  2010                              beq.b   loc_FFF26D16
FFF26D08  6602                              mov.l   #0, r2
FFF26D0A  fb16ff                            mov.l   #-1, r1
FFF26D0D  051381ff                          bsr.a   sub_FFF1EE20
FFF26D11  a009                              mov.l   r1, 24h+var_20[sp]
FFF26D13  38bc01                            bra.w   loc_FFF26ECF
FFF26D16  aa01                   loc_FFF26D16 mov.l   24h+var_4[sp], r1
FFF26D18  05f695ff                          bsr.a   sub_FFF2030E
FFF26D1C  a101                              mov.l   r1, 24h+var_14[sp]
FFF26D1E  a901                              mov.l   24h+var_14[sp], r1
FFF26D20  6101                              cmp     #0, r1
FFF26D22  200f                              beq.b   loc_FFF26D31
FFF26D24  a901                              mov.l   24h+var_14[sp], r1
FFF26D26  6602                              mov.l   #0, r2
FFF26D28  05f880ff                          bsr.a   sub_FFF1EE20
FFF26D2C  a009                              mov.l   r1, 24h+var_20[sp]
FFF26D2E  38a101                            bra.w   loc_FFF26ECF
FFF26D31  a989                   loc_FFF26D31 mov.l   24h+var_8[sp], r1
FFF26D33  05db95ff                          bsr.a   sub_FFF2030E
FFF26D37  a101                              mov.l   r1, 24h+var_14[sp]
FFF26D39  a901                              mov.l   24h+var_14[sp], r1
FFF26D3B  6101                              cmp     #0, r1
FFF26D3D  200f                              beq.b   loc_FFF26D4C
FFF26D3F  a901                              mov.l   24h+var_14[sp], r1
FFF26D41  6602                              mov.l   #0, r2
FFF26D43  05dd80ff                          bsr.a   sub_FFF1EE20
FFF26D47  a009                              mov.l   r1, 24h+var_20[sp]
FFF26D49  388601                            bra.w   loc_FFF26ECF
FFF26D4C  aa01                   loc_FFF26D4C mov.l   24h+var_4[sp], r1
FFF26D4E  cc11                              mov.b   [r1], r1
FFF26D50  053b7a00                          bsr.a   sub_FFF2E78B
FFF26D54  ef16                              mov.l   r1, r6
FFF26D56  a989                              mov.l   24h+var_8[sp], r1
FFF26D58  cc11                              mov.b   [r1], r1
FFF26D5A  05317a00                          bsr.a   sub_FFF2E78B
FFF26D5E  4716                              cmp     r1, r6
FFF26D60  2010                              beq.b   loc_FFF26D70
FFF26D62  6602                              mov.l   #0, r2
FFF26D64  fb16f4                            mov.l   #-0Ch, r1
FFF26D67  05b980ff                          bsr.a   sub_FFF1EE20
FFF26D6B  a009                              mov.l   r1, 24h+var_20[sp]
FFF26D6D  386201                            bra.w   loc_FFF26ECF
FFF26D70  aa06                   loc_FFF26D70 mov.l   24h+var_4[sp], r6
FFF26D72  a987                              mov.l   24h+var_C[sp], r7
FFF26D74  ef61                              mov.l   r6, r1
FFF26D76  05ac7800                          bsr.a   sub_FFF2E622
FFF26D7A  72770c10                          add     #100Ch, r7, r7
FFF26D7E  ef13                              mov.l   r1, r3
FFF26D80  6213                              add     #1, r3
FFF26D82  ef71                              mov.l   r7, r1
FFF26D84  ef62                              mov.l   r6, r2
FFF26D86  05087900                          bsr.a   sub_FFF2E68E
FFF26D8A  a98e                              mov.l   24h+var_8[sp], r6
FFF26D8C  a987                              mov.l   24h+var_C[sp], r7
FFF26D8E  ef61                              mov.l   r6, r1
FFF26D90  05927800                          bsr.a   sub_FFF2E622
FFF26D94  72771212                          add     #1212h, r7, r7
FFF26D98  ef13                              mov.l   r1, r3
FFF26D9A  6213                              add     #1, r3
FFF26D9C  ef71                              mov.l   r7, r1
FFF26D9E  ef62                              mov.l   r6, r2
FFF26DA0  05ee7800                          bsr.a   sub_FFF2E68E
FFF26DA4  a981                              mov.l   24h+var_C[sp], r1
FFF26DA6  72110c10                          add     #100Ch, r1, r1
FFF26DAA  05777100                          bsr.a   sub_FFF2DF21
FFF26DAE  a981                              mov.l   24h+var_C[sp], r1
FFF26DB0  72111212                          add     #1212h, r1, r1
FFF26DB4  056d7100                          bsr.a   sub_FFF2DF21
FFF26DB8  a989                              mov.l   24h+var_8[sp], r1
FFF26DBA  05687800                          bsr.a   sub_FFF2E622
FFF26DBE  6101                              cmp     #0, r1
FFF26DC0  2110                              bne.b   loc_FFF26DD0
FFF26DC2  6602                              mov.l   #0, r2
FFF26DC4  fb16ff                            mov.l   #-1, r1
FFF26DC7  055980ff                          bsr.a   sub_FFF1EE20
FFF26DCB  a009                              mov.l   r1, 24h+var_20[sp]
FFF26DCD  380201                            bra.w   loc_FFF26ECF
FFF26DD0  a981                   loc_FFF26DD0 mov.l   24h+var_C[sp], r1
FFF26DD2  ce110c10                          mov.b   100Ch[r1], r1
FFF26DD6  05b57900                          bsr.a   sub_FFF2E78B
FFF26DDA  8289                              mov.b   r1, 24h+var_19[sp]
FFF26DDC  b289                              movu.b  24h+var_19[sp], r1
FFF26DDE  71020c                            add     #24h+var_18, sp, r2
FFF26DE1  053e81ff                          bsr.a   sub_FFF1EF1F
FFF26DE5  a101                              mov.l   r1, 24h+var_14[sp]
FFF26DE7  a901                              mov.l   24h+var_14[sp], r1
FFF26DE9  6101                              cmp     #0, r1
FFF26DEB  200f                              beq.b   loc_FFF26DFA
FFF26DED  a901                              mov.l   24h+var_14[sp], r1
FFF26DEF  6602                              mov.l   #0, r2
FFF26DF1  052f80ff                          bsr.a   sub_FFF1EE20
FFF26DF5  a009                              mov.l   r1, 24h+var_20[sp]
FFF26DF7  38d800                            bra.w   loc_FFF26ECF
FFF26DFA  a889                   loc_FFF26DFA mov.l   24h+var_18[sp], r1
FFF26DFC  591e6c                            movu.b  6Ch[r1], r14
FFF26DFF  641e                              and     #1, r14
FFF26E01  611e                              cmp     #1, r14
FFF26E03  200e                              beq.b   loc_FFF26E11
FFF26E05  a889                              mov.l   24h+var_18[sp], r1
FFF26E07  591e6c                            movu.b  6Ch[r1], r14
FFF26E0A  752e10                            and     #10h, r14
FFF26E0D  755e10                            cmp     #10h, r14
FFF26E10  1d                                bne.s   loc_FFF26E15
FFF26E11  f80601                 loc_FFF26E11 mov.l   #1, 24h+var_24[sp]
FFF26E14  0c                                bra.s   loc_FFF26E18
FFF26E15  f80600                 loc_FFF26E15 mov.l   #0, 24h+var_24[sp]
FFF26E18  ec01                   loc_FFF26E18 mov.l   24h+var_24[sp], r1
FFF26E1A  6101                              cmp     #0, r1
FFF26E1C  2035                              beq.b   loc_FFF26E51
FFF26E1E  a889                              mov.l   24h+var_18[sp], r1
FFF26E20  05c3effe                          bsr.a   sub_FFF15DE3
FFF26E24  a101                              mov.l   r1, 24h+var_14[sp]
FFF26E26  a901                              mov.l   24h+var_14[sp], r1
FFF26E28  6101                              cmp     #0, r1
FFF26E2A  2010                              beq.b   loc_FFF26E3A
FFF26E2C  6602                              mov.l   #0, r2
FFF26E2E  fb16c1                            mov.l   #-3Fh, r1
FFF26E31  05ef7fff                          bsr.a   sub_FFF1EE20
FFF26E35  a009                              mov.l   r1, 24h+var_20[sp]
FFF26E37  389800                            bra.w   loc_FFF26ECF
FFF26E3A  a983                   loc_FFF26E3A mov.l   24h+var_C[sp], r3
FFF26E3C  72321212                          add     #1212h, r3, r2
FFF26E40  72310c10                          add     #100Ch, r3, r1
FFF26E44  399200                            bsr.w   sub_FFF26ED6
FFF26E47  a101                              mov.l   r1, 24h+var_14[sp]
FFF26E49  a889                              mov.l   24h+var_18[sp], r1
FFF26E4B  05a3effe                          bsr.a   sub_FFF15DEE
FFF26E4F  2e11                              bra.b   loc_FFF26E60
FFF26E51  a983                   loc_FFF26E51 mov.l   24h+var_C[sp], r3
FFF26E53  72321212                          add     #1212h, r3, r2
FFF26E57  72310c10                          add     #100Ch, r3, r1
FFF26E5B  397b00                            bsr.w   sub_FFF26ED6
FFF26E5E  a101                              mov.l   r1, 24h+var_14[sp]
FFF26E60  a901                   loc_FFF26E60 mov.l   24h+var_14[sp], r1
FFF26E62  6101                              cmp     #0, r1
FFF26E64  200e                              beq.b   loc_FFF26E72
FFF26E66  a901                              mov.l   24h+var_14[sp], r1
FFF26E68  6602                              mov.l   #0, r2
FFF26E6A  05b67fff                          bsr.a   sub_FFF1EE20
FFF26E6E  a009                              mov.l   r1, 24h+var_20[sp]
FFF26E70  2e5f                              bra.b   loc_FFF26ECF
FFF26E72  a889                   loc_FFF26E72 mov.l   24h+var_18[sp], r1
FFF26E74  05685dff                          bsr.a   sub_FFF1CBDC
FFF26E78  a101                              mov.l   r1, 24h+var_14[sp]
FFF26E7A  a901                              mov.l   24h+var_14[sp], r1
FFF26E7C  6101                              cmp     #0, r1
FFF26E7E  200c                              beq.b   loc_FFF26E8A
FFF26E80  6602                              mov.l   #0, r2
FFF26E82  059e7fff                          bsr.a   sub_FFF1EE20
FFF26E86  a009                              mov.l   r1, 24h+var_20[sp]
FFF26E88  2e47                              bra.b   loc_FFF26ECF
FFF26E8A  6101                   loc_FFF26E8A cmp     #0, r1
FFF26E8C  200e                              beq.b   loc_FFF26E9A
FFF26E8E  a901                              mov.l   24h+var_14[sp], r1
FFF26E90  6602                              mov.l   #0, r2
FFF26E92  058e7fff                          bsr.a   sub_FFF1EE20
FFF26E96  a009                              mov.l   r1, 24h+var_20[sp]
FFF26E98  2e37                              bra.b   loc_FFF26ECF
FFF26E9A  a889                   loc_FFF26E9A mov.l   24h+var_18[sp], r1
FFF26E9C  05405dff                          bsr.a   sub_FFF1CBDC
FFF26EA0  a101                              mov.l   r1, 24h+var_14[sp]
FFF26EA2  a889                              mov.l   24h+var_18[sp], r1
FFF26EA4  591e6c                            movu.b  6Ch[r1], r14
FFF26EA7  752e10                            and     #10h, r14
FFF26EAA  755e10                            cmp     #10h, r14
FFF26EAD  2118                              bne.b   loc_FFF26EC5
FFF26EAF  a984                              mov.l   24h+var_C[sp], r4
FFF26EB1  5a433216                          movu.b  1632h[r4], r3
FFF26EB5  5a423116                          movu.b  1631h[r4], r2
FFF26EB9  a889                              mov.l   24h+var_18[sp], r1
FFF26EBB  72440c06                          add     #60Ch, r4, r4
FFF26EBF  059df5ff                          bsr.a   sub_FFF2645C
FFF26EC3  a101                              mov.l   r1, 24h+var_14[sp]
FFF26EC5  a901                   loc_FFF26EC5 mov.l   24h+var_14[sp], r1
FFF26EC7  6602                              mov.l   #0, r2
FFF26EC9  05577fff                          bsr.a   sub_FFF1EE20
FFF26ECD  a009                              mov.l   r1, 24h+var_20[sp]
FFF26ECF  a809                   loc_FFF26ECF mov.l   24h+var_20[sp], r1
FFF26ED1  a109                              mov.l   r1, 24h+var_10[sp]
FFF26ED3  3f670b                            rtsd    #2Ch, r6-r7
FFF26ED6  7100cc                 sub_FFF26ED6 add     #-34h, sp, sp   ; <<<< FUNC sub_FFF26ED6
FFF26ED9  a301                              mov.l   r1, 34h+var_4[sp]
FFF26EDB  a28a                              mov.l   r2, 34h+var_8[sp]
FFF26EDD  a283                              mov.l   r3, 34h+var_C[sp]
FFF26EDF  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF26EE5  e4e005                            mov.l   [r14], 34h+var_20[sp]
FFF26EE8  fbe2245e0600                      mov.l   #65E24h, r14
FFF26EEE  e4e004                            mov.l   [r14], 34h+var_24[sp]
FFF26EF1  3e0300                            mov.l   #0, 34h+var_28[sp]
FFF26EF4  3e0700                            mov.l   #0, 34h+var_18[sp]
FFF26EF7  389500                            bra.w   loc_FFF26F8C
FFF26EFA  05287700               loc_FFF26EFA bsr.a   sub_FFF2E622
FFF26EFE  a089                              mov.l   r1, 34h+var_28[sp]
FFF26F00  a88b                              mov.l   34h+var_28[sp], r3
FFF26F02  ab02                              mov.l   34h+var_4[sp], r2
FFF26F04  a901                              mov.l   34h+var_24[sp], r1
FFF26F06  72113c02                          add     #23Ch, r1, r1
FFF26F0A  058bb6ff                          bsr.a   sub_FFF22595
FFF26F0E  6101                              cmp     #0, r1
FFF26F10  212b                              bne.b   loc_FFF26F3B
FFF26F12  a901                              mov.l   34h+var_24[sp], r1
FFF26F14  06890103                          add     34h+var_28[sp].l, r1
FFF26F18  c6103c020a                        mov.b   23Ch[r1], 34h+var_2A[sp]
FFF26F1D  8a81                              mov.b   34h+var_2A[sp], r1
FFF26F1F  75515c                            cmp     #5Ch, r1 ; '\'
FFF26F22  16                                beq.s   loc_FFF26F28
FFF26F23  8a81                              mov.b   34h+var_2A[sp], r1
FFF26F25  6101                              cmp     #0, r1
FFF26F27  1d                                bne.s   loc_FFF26F2C
FFF26F28  f80601                 loc_FFF26F28 mov.l   #1, 34h+var_34[sp]
FFF26F2B  0c                                bra.s   loc_FFF26F2F
FFF26F2C  f80600                 loc_FFF26F2C mov.l   #0, 34h+var_34[sp]
FFF26F2F  ec01                   loc_FFF26F2F mov.l   34h+var_34[sp], r1
FFF26F31  6101                              cmp     #0, r1
FFF26F33  10                                beq.s   loc_FFF26F3B
FFF26F34  f90601f9                          mov.l   #-7, 34h+var_30[sp]
FFF26F38  38d500                            bra.w   loc_FFF2700D
FFF26F3B  aa89                   loc_FFF26F3B mov.l   34h+var_8[sp], r1
FFF26F3D  05e57600                          bsr.a   sub_FFF2E622
FFF26F41  a089                              mov.l   r1, 34h+var_28[sp]
FFF26F43  a88b                              mov.l   34h+var_28[sp], r3
FFF26F45  aa8a                              mov.l   34h+var_8[sp], r2
FFF26F47  a901                              mov.l   34h+var_24[sp], r1
FFF26F49  72113c02                          add     #23Ch, r1, r1
FFF26F4D  0548b6ff                          bsr.a   sub_FFF22595
FFF26F51  6101                              cmp     #0, r1
FFF26F53  212b                              bne.b   loc_FFF26F7E
FFF26F55  a901                              mov.l   34h+var_24[sp], r1
FFF26F57  06890103                          add     34h+var_28[sp].l, r1
FFF26F5B  c6103c020a                        mov.b   23Ch[r1], 34h+var_2A[sp]
FFF26F60  8a81                              mov.b   34h+var_2A[sp], r1
FFF26F62  75515c                            cmp     #5Ch, r1 ; '\'
FFF26F65  16                                beq.s   loc_FFF26F6B
FFF26F66  8a81                              mov.b   34h+var_2A[sp], r1
FFF26F68  6101                              cmp     #0, r1
FFF26F6A  1d                                bne.s   loc_FFF26F6F
FFF26F6B  f80601                 loc_FFF26F6B mov.l   #1, 34h+var_34[sp]
FFF26F6E  0c                                bra.s   loc_FFF26F72
FFF26F6F  f80600                 loc_FFF26F6F mov.l   #0, 34h+var_34[sp]
FFF26F72  ec01                   loc_FFF26F72 mov.l   34h+var_34[sp], r1
FFF26F74  6101                              cmp     #0, r1
FFF26F76  10                                beq.s   loc_FFF26F7E
FFF26F77  f90601f9                          mov.l   #-7, 34h+var_30[sp]
FFF26F7B  389200                            bra.w   loc_FFF2700D
FFF26F7E  a989                   loc_FFF26F7E mov.l   34h+var_18[sp], r1
FFF26F80  6211                              add     #1, r1
FFF26F82  a189                              mov.l   r1, 34h+var_18[sp]
FFF26F84  a901                              mov.l   34h+var_24[sp], r1
FFF26F86  72116804                          add     #468h, r1, r1
FFF26F8A  a101                              mov.l   r1, 34h+var_24[sp]
FFF26F8C  fbe212250100           loc_FFF26F8C mov.l   #12512h, r14
FFF26F92  dcee                              mov.w   [r14], r14
FFF26F94  06850e07                          cmp     34h+var_18[sp].l, r14
FFF26F98  ab01                              mov.l   34h+var_4[sp], r1
FFF26F9A  2b05                              ble.b   loc_FFF26F9F
FFF26F9C  385eff                            bra.w   loc_FFF26EFA
FFF26F9F  cc11                   loc_FFF26F9F mov.b   [r1], r1
FFF26FA1  05ea7700                          bsr.a   sub_FFF2E78B
FFF26FA5  8289                              mov.b   r1, 34h+var_29[sp]
FFF26FA7  b289                              movu.b  34h+var_29[sp], r1
FFF26FA9  710214                            add     #34h+var_20, sp, r2
FFF26FAC  05737fff                          bsr.a   sub_FFF1EF1F
FFF26FB0  a201                              mov.l   r1, 34h+var_14[sp]
FFF26FB2  aa01                              mov.l   34h+var_14[sp], r1
FFF26FB4  6101                              cmp     #0, r1
FFF26FB6  17                                beq.s   loc_FFF26FBD
FFF26FB7  e5000801                          mov.l   34h+var_14[sp], 34h+var_30[sp]
FFF26FBB  2e52                              bra.b   loc_FFF2700D
FFF26FBD  a909                   loc_FFF26FBD mov.l   34h+var_20[sp], r1
FFF26FBF  059e7fff                          bsr.a   sub_FFF1EF5D
FFF26FC3  a201                              mov.l   r1, 34h+var_14[sp]
FFF26FC5  aa01                              mov.l   34h+var_14[sp], r1
FFF26FC7  6101                              cmp     #0, r1
FFF26FC9  17                                beq.s   loc_FFF26FD0
FFF26FCA  e5000801                          mov.l   34h+var_14[sp], 34h+var_30[sp]
FFF26FCE  2e3f                              bra.b   loc_FFF2700D
FFF26FD0  a909                   loc_FFF26FD0 mov.l   34h+var_20[sp], r1
FFF26FD2  05bf7fff                          bsr.a   sub_FFF1EF91
FFF26FD6  a201                              mov.l   r1, 34h+var_14[sp]
FFF26FD8  aa01                              mov.l   34h+var_14[sp], r1
FFF26FDA  6101                              cmp     #0, r1
FFF26FDC  17                                beq.s   loc_FFF26FE3
FFF26FDD  e5000801                          mov.l   34h+var_14[sp], 34h+var_30[sp]
FFF26FE1  2e2c                              bra.b   loc_FFF2700D
FFF26FE3  a909                   loc_FFF26FE3 mov.l   34h+var_20[sp], r1
FFF26FE5  0508edfe                          bsr.a   sub_FFF15CED
FFF26FE9  a181                              mov.l   r1, 34h+var_1C[sp]
FFF26FEB  a981                              mov.l   34h+var_1C[sp], r1
FFF26FED  6101                              cmp     #0, r1
FFF26FEF  17                                beq.s   loc_FFF26FF6
FFF26FF0  f90601db                          mov.l   #-25h, 34h+var_30[sp]
FFF26FF4  2e19                              bra.b   loc_FFF2700D
FFF26FF6  aa84                   loc_FFF26FF6 mov.l   34h+var_C[sp], r4
FFF26FF8  aa8b                              mov.l   34h+var_8[sp], r3
FFF26FFA  ab02                              mov.l   34h+var_4[sp], r2
FFF26FFC  a909                              mov.l   34h+var_20[sp], r1
FFF26FFE  391500                            bsr.w   sub_FFF27013
FFF27001  a201                              mov.l   r1, 34h+var_14[sp]
FFF27003  a909                              mov.l   34h+var_20[sp], r1
FFF27005  05f3ecfe                          bsr.a   sub_FFF15CF8
FFF27009  e5000801                          mov.l   34h+var_14[sp], 34h+var_30[sp]
FFF2700D  a809                   loc_FFF2700D mov.l   34h+var_30[sp], r1
FFF2700F  a209                              mov.l   r1, 34h+var_10[sp]
FFF27011  670d                              rtsd    #0Dh
FFF27013  72004cff               sub_FFF27013 add     #-0B4h, sp, sp   ; <<<< FUNC sub_FFF27013
FFF27017  e7012c                            mov.l   r1, 0B4h+var_4[sp]
FFF2701A  e7022b                            mov.l   r2, 0B4h+var_8[sp]
FFF2701D  e7032a                            mov.l   r3, 0B4h+var_C[sp]
FFF27020  e70429                            mov.l   r4, 0B4h+var_10[sp]
FFF27023  f9062400                          mov.l   #0, 0B4h+var_24[sp]
FFF27027  f9062300                          mov.l   #0, 0B4h+var_28[sp]
FFF2702B  f9062200                          mov.l   #0, 0B4h+var_2C[sp]
FFF2702F  f9062100                          mov.l   #0, 0B4h+var_30[sp]
FFF27033  f9062000                          mov.l   #0, 0B4h+var_34[sp]
FFF27037  3e0300                            mov.l   #0, 0B4h+var_A8[sp]
FFF2703A  ed012a                            mov.l   0B4h+var_C[sp], r1
FFF2703D  6221                              add     #2, r1
FFF2703F  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF27042  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27045  e5100d22                          mov.l   34h[r1], 0B4h+var_2C[sp]
FFF27049  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF2704C  fa14301600                        mov.b   #0, 1630h[r1]
FFF27051  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27054  8c11                              mov.b   10h[r1], r1
FFF27056  755120                            cmp     #20h, r1 ; ' '
FFF27059  3a0a01                            beq.w   loc_FFF27163
FFF2705C  ed0229                            mov.l   0B4h+var_10[sp], r2
FFF2705F  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF27062  72220602                          add     #206h, r2, r2
FFF27066  052091ff                          bsr.a   sub_FFF20186
FFF2706A  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF2706D  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF27070  6101                              cmp     #0, r1
FFF27072  18                                bne.s   loc_FFF2707A
FFF27073  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF27077  381e05                            bra.w   loc_FFF27595
FFF2707A  ed0129                 loc_FFF2707A mov.l   0B4h+var_10[sp], r1
FFF2707D  ce1e0602                          mov.b   206h[r1], r14
FFF27081  610e                              cmp     #0, r14
FFF27083  18                                bne.s   loc_FFF2708B
FFF27084  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF27088  380d05                            bra.w   loc_FFF27595
FFF2708B  ed0229                 loc_FFF2708B mov.l   0B4h+var_10[sp], r2
FFF2708E  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27091  60c0                              sub     #0Ch, sp
FFF27093  72038800                          add     #0C0h+var_38, sp, r3
FFF27097  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF27099  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF2709C  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF2709E  72220602                          add     #206h, r2, r2
FFF270A2  6604                              mov.l   #0, r4
FFF270A4  71031c                            add     #0C0h+var_A4, sp, r3
FFF270A7  05e480ff                          bsr.a   sub_FFF1F18B
FFF270AB  62c0                              add     #0Ch, sp
FFF270AD  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF270B0  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF270B3  cc1e                              mov.b   [r1], r14
FFF270B5  610e                              cmp     #0, r14
FFF270B7  3aac00                            beq.w   loc_FFF27163
FFF270BA  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF270BD  6101                              cmp     #0, r1
FFF270BF  10                                beq.s   loc_FFF270C7
FFF270C0  f90601fc                          mov.l   #-4, 0B4h+var_B0[sp]
FFF270C4  38d104                            bra.w   loc_FFF27595
FFF270C7  ed012c                 loc_FFF270C7 mov.l   0B4h+var_4[sp], r1
FFF270CA  8c12                              mov.b   10h[r1], r2
FFF270CC  710110                            add     #0B4h+var_A4, sp, r1
FFF270CF  05c995ff                          bsr.a   sub_FFF20698
FFF270D3  e70122                            mov.l   r1, 0B4h+var_2C[sp]
FFF270D6  388d00                            bra.w   loc_FFF27163
FFF270D9  ed0229                 loc_FFF270D9 mov.l   0B4h+var_10[sp], r2
FFF270DC  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF270DF  72220602                          add     #206h, r2, r2
FFF270E3  05a390ff                          bsr.a   sub_FFF20186
FFF270E7  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF270EA  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF270ED  6101                              cmp     #0, r1
FFF270EF  18                                bne.s   loc_FFF270F7
FFF270F0  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF270F4  38a104                            bra.w   loc_FFF27595
FFF270F7  ed0129                 loc_FFF270F7 mov.l   0B4h+var_10[sp], r1
FFF270FA  ce1e0602                          mov.b   206h[r1], r14
FFF270FE  610e                              cmp     #0, r14
FFF27100  18                                bne.s   loc_FFF27108
FFF27101  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF27105  389004                            bra.w   loc_FFF27595
FFF27108  e5002220               loc_FFF27108 mov.l   0B4h+var_2C[sp], 0B4h+var_34[sp]
FFF2710C  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2710F  ed0222                            mov.l   0B4h+var_2C[sp], r2
FFF27112  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27115  7100f0                            add     #-10h, sp, sp
FFF27118  72048800                          add     #0C4h+var_3C, sp, r4
FFF2711C  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF2711E  72048c00                          add     #0C4h+var_38, sp, r4
FFF27122  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF27124  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF27127  f80400                            mov.b   #0, 0C4h+var_C4[sp]
FFF2712A  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF2712C  72330602                          add     #206h, r3, r3
FFF27130  710420                            add     #0C4h+var_A4, sp, r4
FFF27133  051f86ff                          bsr.a   sub_FFF1F752
FFF27137  710010                            add     #10h, sp, sp
FFF2713A  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2713D  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF27140  cc1e                              mov.b   [r1], r14
FFF27142  610e                              cmp     #0, r14
FFF27144  201f                              beq.b   loc_FFF27163
FFF27146  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF27149  7501fc                            cmp     #-4, r1
FFF2714C  18                                bne.s   loc_FFF27154
FFF2714D  f90601fc                          mov.l   #-4, 0B4h+var_B0[sp]
FFF27151  384404                            bra.w   loc_FFF27595
FFF27154  ed012c                 loc_FFF27154 mov.l   0B4h+var_4[sp], r1
FFF27157  8c12                              mov.b   10h[r1], r2
FFF27159  710110                            add     #0B4h+var_A4, sp, r1
FFF2715C  053c95ff                          bsr.a   sub_FFF20698
FFF27160  e70122                            mov.l   r1, 0B4h+var_2C[sp]
FFF27163  ed0125                 loc_FFF27163 mov.l   0B4h+var_20[sp], r1
FFF27166  cc1e                              mov.b   [r1], r14
FFF27168  610e                              cmp     #0, r14
FFF2716A  3b6fff                            bne.w   loc_FFF270D9
FFF2716D  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF27170  6101                              cmp     #0, r1
FFF27172  1c                                bne.s   loc_FFF27176
FFF27173  3e0301                            mov.l   #1, 0B4h+var_A8[sp]
FFF27176  ed012b                 loc_FFF27176 mov.l   0B4h+var_8[sp], r1
FFF27179  6221                              add     #2, r1
FFF2717B  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF2717E  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27181  e5100d22                          mov.l   34h[r1], 0B4h+var_2C[sp]
FFF27185  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27188  8c11                              mov.b   10h[r1], r1
FFF2718A  755120                            cmp     #20h, r1 ; ' '
FFF2718D  3a2301                            beq.w   loc_FFF272B0
FFF27190  ed0229                            mov.l   0B4h+var_10[sp], r2
FFF27193  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF27196  05f08fff                          bsr.a   sub_FFF20186
FFF2719A  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF2719D  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF271A0  6101                              cmp     #0, r1
FFF271A2  18                                bne.s   loc_FFF271AA
FFF271A3  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF271A7  38ee03                            bra.w   loc_FFF27595
FFF271AA  ed0129                 loc_FFF271AA mov.l   0B4h+var_10[sp], r1
FFF271AD  cc1e                              mov.b   [r1], r14
FFF271AF  610e                              cmp     #0, r14
FFF271B1  18                                bne.s   loc_FFF271B9
FFF271B2  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF271B6  38df03                            bra.w   loc_FFF27595
FFF271B9  ed0229                 loc_FFF271B9 mov.l   0B4h+var_10[sp], r2
FFF271BC  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF271BF  60c0                              sub     #0Ch, sp
FFF271C1  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF271C3  72038800                          add     #0C0h+var_38, sp, r3
FFF271C7  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF271C9  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF271CC  6604                              mov.l   #0, r4
FFF271CE  71033c                            add     #0C0h+var_84, sp, r3
FFF271D1  05ba7fff                          bsr.a   sub_FFF1F18B
FFF271D5  62c0                              add     #0Ch, sp
FFF271D7  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF271DA  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF271DD  6101                              cmp     #0, r1
FFF271DF  2018                              beq.b   loc_FFF271F7
FFF271E1  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF271E4  cc1e                              mov.b   [r1], r14
FFF271E6  610e                              cmp     #0, r14
FFF271E8  10                                beq.s   loc_FFF271F0
FFF271E9  f90601fc                          mov.l   #-4, 0B4h+var_B0[sp]
FFF271ED  38a803                            bra.w   loc_FFF27595
FFF271F0  f90601fd               loc_FFF271F0 mov.l   #-3, 0B4h+var_B0[sp]
FFF271F4  38a103                            bra.w   loc_FFF27595
FFF271F7  ed012c                 loc_FFF271F7 mov.l   0B4h+var_4[sp], r1
FFF271FA  8c12                              mov.b   10h[r1], r2
FFF271FC  710130                            add     #0B4h+var_84, sp, r1
FFF271FF  059994ff                          bsr.a   sub_FFF20698
FFF27203  e70122                            mov.l   r1, 0B4h+var_2C[sp]
FFF27206  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF27209  fa14301601                        mov.b   #1, 1630h[r1]
FFF2720E  38a200                            bra.w   loc_FFF272B0
FFF27211  ed0229                 loc_FFF27211 mov.l   0B4h+var_10[sp], r2
FFF27214  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF27217  056f8fff                          bsr.a   sub_FFF20186
FFF2721B  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF2721E  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF27221  6101                              cmp     #0, r1
FFF27223  18                                bne.s   loc_FFF2722B
FFF27224  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF27228  386d03                            bra.w   loc_FFF27595
FFF2722B  ed0129                 loc_FFF2722B mov.l   0B4h+var_10[sp], r1
FFF2722E  cc1e                              mov.b   [r1], r14
FFF27230  610e                              cmp     #0, r14
FFF27232  18                                bne.s   loc_FFF2723A
FFF27233  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF27237  385e03                            bra.w   loc_FFF27595
FFF2723A  e5002221               loc_FFF2723A mov.l   0B4h+var_2C[sp], 0B4h+var_30[sp]
FFF2723E  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF27241  ed0222                            mov.l   0B4h+var_2C[sp], r2
FFF27244  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27247  7100f0                            add     #-10h, sp, sp
FFF2724A  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF2724C  72048800                          add     #0C4h+var_3C, sp, r4
FFF27250  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF27252  72048c00                          add     #0C4h+var_38, sp, r4
FFF27256  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF27258  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF2725B  f80400                            mov.b   #0, 0C4h+var_C4[sp]
FFF2725E  710440                            add     #0C4h+var_84, sp, r4
FFF27261  05f184ff                          bsr.a   sub_FFF1F752
FFF27265  710010                            add     #10h, sp, sp
FFF27268  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2726B  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2726E  6101                              cmp     #0, r1
FFF27270  2029                              beq.b   loc_FFF27299
FFF27272  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF27275  cc1e                              mov.b   [r1], r14
FFF27277  610e                              cmp     #0, r14
FFF27279  210d                              bne.b   loc_FFF27286
FFF2727B  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2727E  7501fc                            cmp     #-4, r1
FFF27281  1d                                bne.s   loc_FFF27286
FFF27282  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF27285  0c                                bra.s   loc_FFF27289
FFF27286  f80600                 loc_FFF27286 mov.l   #0, 0B4h+var_B4[sp]
FFF27289  ec01                   loc_FFF27289 mov.l   0B4h+var_B4[sp], r1
FFF2728B  6101                              cmp     #0, r1
FFF2728D  15                                beq.s   loc_FFF27292
FFF2728E  f90627fd                          mov.l   #-3, 0B4h+var_18[sp]
FFF27292  e5002701               loc_FFF27292 mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF27296  38ff02                            bra.w   loc_FFF27595
FFF27299  ed012c                 loc_FFF27299 mov.l   0B4h+var_4[sp], r1
FFF2729C  8c12                              mov.b   10h[r1], r2
FFF2729E  710130                            add     #0B4h+var_84, sp, r1
FFF272A1  05f793ff                          bsr.a   sub_FFF20698
FFF272A5  e70122                            mov.l   r1, 0B4h+var_2C[sp]
FFF272A8  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF272AB  fa14301601                        mov.b   #1, 1630h[r1]
FFF272B0  ed0125                 loc_FFF272B0 mov.l   0B4h+var_20[sp], r1
FFF272B3  cc1e                              mov.b   [r1], r14
FFF272B5  610e                              cmp     #0, r14
FFF272B7  3b5aff                            bne.w   loc_FFF27211
FFF272BA  a889                              mov.l   0B4h+var_A8[sp], r1
FFF272BC  6101                              cmp     #0, r1
FFF272BE  fcdbe1                            scne.l  r14
FFF272C1  ed0121                            mov.l   0B4h+var_30[sp], r1
FFF272C4  06850120                          cmp     0B4h+var_34[sp].l, r1
FFF272C8  200f                              beq.b   loc_FFF272D7
FFF272CA  5bee                              movu.b  r14, r14
FFF272CC  610e                              cmp     #0, r14
FFF272CE  204d                              beq.b   loc_FFF2731B
FFF272D0  f90601fe                          mov.l   #-2, 0B4h+var_B0[sp]
FFF272D4  38c102                            bra.w   loc_FFF27595
FFF272D7  5bee                   loc_FFF272D7 movu.b  r14, r14
FFF272D9  610e                              cmp     #0, r14
FFF272DB  2040                              beq.b   loc_FFF2731B
FFF272DD  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF272E0  72120602                          add     #206h, r1, r2
FFF272E4  05ebb1ff                          bsr.a   sub_FFF224CF
FFF272E8  6101                              cmp     #0, r1
FFF272EA  2031                              beq.b   loc_FFF2731B
FFF272EC  f9062600                          mov.l   #0, 0B4h+var_1C[sp]
FFF272F0  2e24                              bra.b   loc_FFF27314
FFF272F2  ed0126                 loc_FFF272F2 mov.l   0B4h+var_1C[sp], r1
FFF272F5  710e30                            add     #0B4h+var_84, sp, r14
FFF272F8  fece1e                            movu.b  [r14, r1], r14
FFF272FB  710f10                            add     #0B4h+var_A4, sp, r15
FFF272FE  4b1f                              add     r1, r15
FFF27300  40fe                              sub     [r15], r14
FFF27302  610e                              cmp     #0, r14
FFF27304  10                                beq.s   loc_FFF2730C
FFF27305  f90601fe                          mov.l   #-2, 0B4h+var_B0[sp]
FFF27309  388c02                            bra.w   loc_FFF27595
FFF2730C  ed0126                 loc_FFF2730C mov.l   0B4h+var_1C[sp], r1
FFF2730F  6211                              add     #1, r1
FFF27311  e70126                            mov.l   r1, 0B4h+var_1C[sp]
FFF27314  ed0126                 loc_FFF27314 mov.l   0B4h+var_1C[sp], r1
FFF27317  61b1                              cmp     #0Bh, r1
FFF27319  29d9                              blt.b   loc_FFF272F2
FFF2731B  ed0129                 loc_FFF2731B mov.l   0B4h+var_10[sp], r1
FFF2731E  5a1e3016                          movu.b  1630h[r1], r14
FFF27322  611e                              cmp     #1, r14
FFF27324  2113                              bne.b   loc_FFF27337
FFF27326  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27329  591e6c                            movu.b  6Ch[r1], r14
FFF2732C  752e10                            and     #10h, r14
FFF2732F  755e10                            cmp     #10h, r14
FFF27332  1d                                bne.s   loc_FFF27337
FFF27333  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF27336  0c                                bra.s   loc_FFF2733A
FFF27337  f80600                 loc_FFF27337 mov.l   #0, 0B4h+var_B4[sp]
FFF2733A  ec01                   loc_FFF2733A mov.l   0B4h+var_B4[sp], r1
FFF2733C  6101                              cmp     #0, r1
FFF2733E  3a8100                            beq.w   loc_FFF273BF
FFF27341  ed012b                            mov.l   0B4h+var_8[sp], r1
FFF27344  05a5f8ff                          bsr.a   sub_FFF26BE9
FFF27348  8289                              mov.b   r1, 0B4h+var_A9[sp]
FFF2734A  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2734D  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27350  72320c06                          add     #60Ch, r3, r2
FFF27354  0535efff                          bsr.a   sub_FFF26289
FFF27358  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2735B  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2735E  6101                              cmp     #0, r1
FFF27360  2134                              bne.b   loc_FFF27394
FFF27362  ed0229                            mov.l   0B4h+var_10[sp], r2
FFF27365  b28d                              movu.b  0B4h+var_A9[sp], r5
FFF27367  af8c                              mov.l   0B4h+var_38[sp], r4
FFF27369  af83                              mov.l   0B4h+var_3C[sp], r3
FFF2736B  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2736E  60c0                              sub     #0Ch, sp
FFF27370  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF27372  72220c06                          add     #60Ch, r2, r2
FFF27376  a00a                              mov.l   r2, 0C0h+var_BC[sp]
FFF27378  c305                              mov.b   r5, 0C0h+var_C0[sp]
FFF2737A  71023c                            add     #0C0h+var_84, sp, r2
FFF2737D  05c9efff                          bsr.a   sub_FFF26346
FFF27381  62c0                              add     #0Ch, sp
FFF27383  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF27386  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF27389  6101                              cmp     #0, r1
FFF2738B  202c                              beq.b   loc_FFF273B7
FFF2738D  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF27391  380402                            bra.w   loc_FFF27595
FFF27394  ed0127                 loc_FFF27394 mov.l   0B4h+var_18[sp], r1
FFF27397  7601d3fe                          cmp     #-12Dh, r1
FFF2739B  11                                beq.s   loc_FFF273A4
FFF2739C  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2739F  7601d4fe                          cmp     #-12Ch, r1
FFF273A3  1d                                bne.s   loc_FFF273A8
FFF273A4  f80601                 loc_FFF273A4 mov.l   #1, 0B4h+var_B4[sp]
FFF273A7  0c                                bra.s   loc_FFF273AB
FFF273A8  f80600                 loc_FFF273A8 mov.l   #0, 0B4h+var_B4[sp]
FFF273AB  ec01                   loc_FFF273AB mov.l   0B4h+var_B4[sp], r1
FFF273AD  6101                              cmp     #0, r1
FFF273AF  18                                bne.s   loc_FFF273B7
FFF273B0  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF273B4  38e101                            bra.w   loc_FFF27595
FFF273B7  ed0129                 loc_FFF273B7 mov.l   0B4h+var_10[sp], r1
FFF273BA  fa14301602                        mov.b   #2, 1630h[r1]
FFF273BF  ed0120                 loc_FFF273BF mov.l   0B4h+var_34[sp], r1
FFF273C2  6101                              cmp     #0, r1
FFF273C4  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF273C7  2032                              beq.b   loc_FFF273F9
FFF273C9  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF273CC  ed0220                            mov.l   0B4h+var_34[sp], r2
FFF273CF  7100f0                            add     #-10h, sp, sp
FFF273D2  72049c00                          add     #0C4h+var_28, sp, r4
FFF273D6  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF273D8  7204a000                          add     #0C4h+var_24, sp, r4
FFF273DC  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF273DE  3c0101                            mov.b   #1, 0C4h+var_C3[sp]
FFF273E1  f80403                            mov.b   #3, 0C4h+var_C4[sp]
FFF273E4  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF273E6  72330602                          add     #206h, r3, r3
FFF273EA  710460                            add     #0C4h+var_64, sp, r4
FFF273ED  056583ff                          bsr.a   sub_FFF1F752
FFF273F1  710010                            add     #10h, sp, sp
FFF273F4  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF273F7  2e24                              bra.b   loc_FFF2741B
FFF273F9  ed0229                 loc_FFF273F9 mov.l   0B4h+var_10[sp], r2
FFF273FC  60c0                              sub     #0Ch, sp
FFF273FE  72039c00                          add     #0C0h+var_24, sp, r3
FFF27402  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF27404  f80401                            mov.b   #1, 0C0h+var_C0[sp]
FFF27407  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF27409  72220602                          add     #206h, r2, r2
FFF2740D  6634                              mov.l   #3, r4
FFF2740F  71035c                            add     #0C0h+var_64, sp, r3
FFF27412  05797dff                          bsr.a   sub_FFF1F18B
FFF27416  62c0                              add     #0Ch, sp
FFF27418  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2741B  ed0127                 loc_FFF2741B mov.l   0B4h+var_18[sp], r1
FFF2741E  6101                              cmp     #0, r1
FFF27420  10                                beq.s   loc_FFF27428
FFF27421  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF27425  387001                            bra.w   loc_FFF27595
FFF27428  ed0121                 loc_FFF27428 mov.l   0B4h+var_30[sp], r1
FFF2742B  6101                              cmp     #0, r1
FFF2742D  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27430  202e                              beq.b   loc_FFF2745E
FFF27432  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF27435  ed0221                            mov.l   0B4h+var_30[sp], r2
FFF27438  7100f0                            add     #-10h, sp, sp
FFF2743B  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF2743D  72048800                          add     #0C4h+var_3C, sp, r4
FFF27441  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF27443  72048c00                          add     #0C4h+var_38, sp, r4
FFF27447  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF27449  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF2744C  f80402                            mov.b   #2, 0C4h+var_C4[sp]
FFF2744F  710460                            add     #0C4h+var_64, sp, r4
FFF27452  050083ff                          bsr.a   sub_FFF1F752
FFF27456  710010                            add     #10h, sp, sp
FFF27459  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2745C  2e20                              bra.b   loc_FFF2747C
FFF2745E  ed0229                 loc_FFF2745E mov.l   0B4h+var_10[sp], r2
FFF27461  60c0                              sub     #0Ch, sp
FFF27463  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF27465  72038800                          add     #0C0h+var_38, sp, r3
FFF27469  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF2746B  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF2746E  6624                              mov.l   #2, r4
FFF27470  71035c                            add     #0C0h+var_64, sp, r3
FFF27473  05187dff                          bsr.a   sub_FFF1F18B
FFF27477  62c0                              add     #0Ch, sp
FFF27479  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2747C  ed0127                 loc_FFF2747C mov.l   0B4h+var_18[sp], r1
FFF2747F  6101                              cmp     #0, r1
FFF27481  10                                beq.s   loc_FFF27489
FFF27482  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF27486  380f01                            bra.w   loc_FFF27595
FFF27489  ed0120                 loc_FFF27489 mov.l   0B4h+var_34[sp], r1
FFF2748C  6101                              cmp     #0, r1
FFF2748E  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27491  2032                              beq.b   loc_FFF274C3
FFF27493  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF27496  ed0220                            mov.l   0B4h+var_34[sp], r2
FFF27499  7100f0                            add     #-10h, sp, sp
FFF2749C  72048800                          add     #0C4h+var_3C, sp, r4
FFF274A0  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF274A2  72048c00                          add     #0C4h+var_38, sp, r4
FFF274A6  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF274A8  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF274AB  f80401                            mov.b   #1, 0C4h+var_C4[sp]
FFF274AE  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF274B0  72330602                          add     #206h, r3, r3
FFF274B4  710440                            add     #0C4h+var_84, sp, r4
FFF274B7  059b82ff                          bsr.a   sub_FFF1F752
FFF274BB  710010                            add     #10h, sp, sp
FFF274BE  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF274C1  2e24                              bra.b   loc_FFF274E5
FFF274C3  ed0229                 loc_FFF274C3 mov.l   0B4h+var_10[sp], r2
FFF274C6  60c0                              sub     #0Ch, sp
FFF274C8  72038800                          add     #0C0h+var_38, sp, r3
FFF274CC  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF274CE  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF274D1  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF274D3  72220602                          add     #206h, r2, r2
FFF274D7  6614                              mov.l   #1, r4
FFF274D9  71033c                            add     #0C0h+var_84, sp, r3
FFF274DC  05af7cff                          bsr.a   sub_FFF1F18B
FFF274E0  62c0                              add     #0Ch, sp
FFF274E2  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF274E5  ed0127                 loc_FFF274E5 mov.l   0B4h+var_18[sp], r1
FFF274E8  6101                              cmp     #0, r1
FFF274EA  10                                beq.s   loc_FFF274F2
FFF274EB  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF274EF  38a600                            bra.w   loc_FFF27595
FFF274F2  f5043b                 loc_FFF274F2 btst    #4, 0B4h+var_79[sp].b
FFF274F5  200e                              beq.b   loc_FFF27503
FFF274F7  ed0121                            mov.l   0B4h+var_30[sp], r1
FFF274FA  06850120                          cmp     0B4h+var_34[sp].l, r1
FFF274FE  15                                beq.s   loc_FFF27503
FFF274FF  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF27502  0c                                bra.s   loc_FFF27506
FFF27503  f80600                 loc_FFF27503 mov.l   #0, 0B4h+var_B4[sp]
FFF27506  ec01                   loc_FFF27506 mov.l   0B4h+var_B4[sp], r1
FFF27508  6101                              cmp     #0, r1
FFF2750A  3a8800                            beq.w   loc_FFF27592
FFF2750D  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27510  8c12                              mov.b   10h[r1], r2
FFF27512  710130                            add     #0B4h+var_84, sp, r1
FFF27515  058391ff                          bsr.a   sub_FFF20698
FFF27519  a709                              mov.l   r1, 0B4h+var_40[sp]
FFF2751B  af0a                              mov.l   0B4h+var_40[sp], r2
FFF2751D  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27520  058c7aff                          bsr.a   sub_FFF1EFAC
FFF27524  a781                              mov.l   r1, 0B4h+var_3C[sp]
FFF27526  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF27529  af82                              mov.l   0B4h+var_3C[sp], r2
FFF2752B  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2752E  72330c0c                          add     #0C0Ch, r3, r3
FFF27532  6614                              mov.l   #1, r4
FFF27534  05dd7aff                          bsr.a   sub_FFF1F011
FFF27538  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2753B  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2753E  6101                              cmp     #0, r1
FFF27540  17                                beq.s   loc_FFF27547
FFF27541  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF27545  2e50                              bra.b   loc_FFF27595
FFF27547  ed0129                 loc_FFF27547 mov.l   0B4h+var_10[sp], r1
FFF2754A  72110c0c                          add     #0C0Ch, r1, r1
FFF2754E  a701                              mov.l   r1, 0B4h+var_44[sp]
FFF27550  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF27553  ed0220                            mov.l   0B4h+var_34[sp], r2
FFF27556  0685120d                          cmp     34h[r1].l, r2
FFF2755A  1d                                bne.s   locret_FFF2755F
FFF2755B  f9062000                          mov.l   #0, 0B4h+var_34[sp]
FFF2755F  af01                   locret_FFF2755F mov.l   0B4h+var_44[sp], r1
FFF27561  711120                            add     #20h, r1, r1 ; ' '
FFF27564  a701                              mov.l   r1, 0B4h+var_44[sp]
FFF27566  ed022c                            mov.l   0B4h+var_4[sp], r2
FFF27569  8c23                              mov.b   10h[r2], r3
FFF2756B  ed0220                            mov.l   0B4h+var_34[sp], r2
FFF2756E  057691ff                          bsr.a   sub_FFF206E4
FFF27572  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF27575  af82                              mov.l   0B4h+var_3C[sp], r2
FFF27577  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2757A  72330c0c                          add     #0C0Ch, r3, r3
FFF2757E  6614                              mov.l   #1, r4
FFF27580  05227bff                          bsr.a   sub_FFF1F0A2
FFF27584  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF27587  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2758A  6101                              cmp     #0, r1
FFF2758C  16                                beq.s   loc_FFF27592
FFF2758D  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF27591  0c                                bra.s   loc_FFF27595
FFF27592  3e0100                 loc_FFF27592 mov.l   #0, 0B4h+var_B0[sp]
FFF27595  a809                   loc_FFF27595 mov.l   0B4h+var_B0[sp], r1
FFF27597  e70128                            mov.l   r1, 0B4h+var_14[sp]
FFF2759A  672d                              rtsd    #2Dh
FFF2759C  7100e8                 sub_FFF2759C add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2759C
FFF2759F  a109                              mov.l   r1, 18h+var_4[sp]
FFF275A1  a102                              mov.l   r2, 18h+var_8[sp]
FFF275A3  05f3e8fe                          bsr.a   sub_FFF15E96
FFF275A7  a009                              mov.l   r1, 18h+var_14[sp]
FFF275A9  a809                              mov.l   18h+var_14[sp], r1
FFF275AB  6101                              cmp     #0, r1
FFF275AD  210f                              bne.b   loc_FFF275BC
FFF275AF  6602                              mov.l   #0, r2
FFF275B1  fb16e1                            mov.l   #-1Fh, r1
FFF275B4  056c78ff                          bsr.a   sub_FFF1EE20
FFF275B8  e301                              mov.l   r1, 18h+var_18[sp]
FFF275BA  2e16                              bra.b   loc_FFF275D0
FFF275BC  a80b                   loc_FFF275BC mov.l   18h+var_14[sp], r3
FFF275BE  a902                              mov.l   18h+var_8[sp], r2
FFF275C0  a909                              mov.l   18h+var_4[sp], r1
FFF275C2  391400                            bsr.w   sub_FFF275D6
FFF275C5  a081                              mov.l   r1, 18h+var_10[sp]
FFF275C7  a809                              mov.l   18h+var_14[sp], r1
FFF275C9  05dde8fe                          bsr.a   sub_FFF15EA6
FFF275CD  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF275D0  ec01                   loc_FFF275D0 mov.l   18h+var_18[sp], r1
FFF275D2  a089                              mov.l   r1, 18h+var_C[sp]
FFF275D4  6706                              rtsd    #6
FFF275D6  6e67                   sub_FFF275D6 pushm   r6-r7   ; <<<< FUNC sub_FFF275D6
FFF275D8  7100e8                            add     #-18h, sp, sp
FFF275DB  a109                              mov.l   r1, 18h+var_4[sp]
FFF275DD  a102                              mov.l   r2, 18h+var_8[sp]
FFF275DF  a08b                              mov.l   r3, 18h+var_C[sp]
FFF275E1  050adaff                          bsr.a   sub_FFF24FEB
FFF275E5  a009                              mov.l   r1, 18h+var_14[sp]
FFF275E7  a809                              mov.l   18h+var_14[sp], r1
FFF275E9  6101                              cmp     #0, r1
FFF275EB  200e                              beq.b   loc_FFF275F9
FFF275ED  a809                              mov.l   18h+var_14[sp], r1
FFF275EF  6602                              mov.l   #0, r2
FFF275F1  052f78ff                          bsr.a   sub_FFF1EE20
FFF275F5  e301                              mov.l   r1, 18h+var_18[sp]
FFF275F7  2e7d                              bra.b   loc_FFF27674
FFF275F9  a909                   loc_FFF275F9 mov.l   18h+var_4[sp], r1
FFF275FB  6101                              cmp     #0, r1
FFF275FD  210f                              bne.b   loc_FFF2760C
FFF275FF  6602                              mov.l   #0, r2
FFF27601  fb16ff                            mov.l   #-1, r1
FFF27604  051c78ff                          bsr.a   sub_FFF1EE20
FFF27608  e301                              mov.l   r1, 18h+var_18[sp]
FFF2760A  2e6a                              bra.b   loc_FFF27674
FFF2760C  a901                   loc_FFF2760C mov.l   18h+var_8[sp], r1
FFF2760E  6101                              cmp     #0, r1
FFF27610  210f                              bne.b   loc_FFF2761F
FFF27612  6602                              mov.l   #0, r2
FFF27614  fb16f3                            mov.l   #-0Dh, r1
FFF27617  050978ff                          bsr.a   sub_FFF1EE20
FFF2761B  e301                              mov.l   r1, 18h+var_18[sp]
FFF2761D  2e57                              bra.b   loc_FFF27674
FFF2761F  a909                   loc_FFF2761F mov.l   18h+var_4[sp], r1
FFF27621  05ed8cff                          bsr.a   sub_FFF2030E
FFF27625  a009                              mov.l   r1, 18h+var_14[sp]
FFF27627  a809                              mov.l   18h+var_14[sp], r1
FFF27629  6101                              cmp     #0, r1
FFF2762B  200e                              beq.b   loc_FFF27639
FFF2762D  a809                              mov.l   18h+var_14[sp], r1
FFF2762F  6602                              mov.l   #0, r2
FFF27631  05ef77ff                          bsr.a   sub_FFF1EE20
FFF27635  e301                              mov.l   r1, 18h+var_18[sp]
FFF27637  2e3d                              bra.b   loc_FFF27674
FFF27639  a90e                   loc_FFF27639 mov.l   18h+var_4[sp], r6
FFF2763B  a88f                              mov.l   18h+var_C[sp], r7
FFF2763D  ef61                              mov.l   r6, r1
FFF2763F  05e36f00                          bsr.a   sub_FFF2E622
FFF27643  72770c10                          add     #100Ch, r7, r7
FFF27647  ef13                              mov.l   r1, r3
FFF27649  6213                              add     #1, r3
FFF2764B  ef71                              mov.l   r7, r1
FFF2764D  ef62                              mov.l   r6, r2
FFF2764F  053f7000                          bsr.a   sub_FFF2E68E
FFF27653  a889                              mov.l   18h+var_C[sp], r1
FFF27655  72110c10                          add     #100Ch, r1, r1
FFF27659  05c86800                          bsr.a   sub_FFF2DF21
FFF2765D  a88b                              mov.l   18h+var_C[sp], r3
FFF2765F  a902                              mov.l   18h+var_8[sp], r2
FFF27661  72310c10                          add     #100Ch, r3, r1
FFF27665  391600                            bsr.w   sub_FFF2767B
FFF27668  a009                              mov.l   r1, 18h+var_14[sp]
FFF2766A  a809                              mov.l   18h+var_14[sp], r1
FFF2766C  6602                              mov.l   #0, r2
FFF2766E  05b277ff                          bsr.a   sub_FFF1EE20
FFF27672  e301                              mov.l   r1, 18h+var_18[sp]
FFF27674  ec01                   loc_FFF27674 mov.l   18h+var_18[sp], r1
FFF27676  a081                              mov.l   r1, 18h+var_10[sp]
FFF27678  3f6708                            rtsd    #20h, r6-r7
FFF2767B  7ea6                   sub_FFF2767B push.l  r6   ; <<<< FUNC sub_FFF2767B
FFF2767D  7100ac                            add     #-54h, sp, sp
FFF27680  a501                              mov.l   r1, 54h+var_4[sp]
FFF27682  a48a                              mov.l   r2, 54h+var_8[sp]
FFF27684  a483                              mov.l   r3, 54h+var_C[sp]
FFF27686  3e0e00                            mov.l   #0, 54h+var_1C[sp]
FFF27689  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2768F  e4e003                            mov.l   [r14], 54h+var_48[sp]
FFF27692  ad01                              mov.l   54h+var_4[sp], r1
FFF27694  cc11                              mov.b   [r1], r1
FFF27696  05f57000                          bsr.a   sub_FFF2E78B
FFF2769A  8289                              mov.b   r1, 54h+var_49[sp]
FFF2769C  b289                              movu.b  54h+var_49[sp], r1
FFF2769E  71020c                            add     #54h+var_48, sp, r2
FFF276A1  057e78ff                          bsr.a   sub_FFF1EF1F
FFF276A5  a401                              mov.l   r1, 54h+var_14[sp]
FFF276A7  ac01                              mov.l   54h+var_14[sp], r1
FFF276A9  6101                              cmp     #0, r1
FFF276AB  10                                beq.s   loc_FFF276B3
FFF276AC  e5001001                          mov.l   54h+var_14[sp], 54h+var_50[sp]
FFF276B0  386a01                            bra.w   loc_FFF2781A
FFF276B3  a889                   loc_FFF276B3 mov.l   54h+var_48[sp], r1
FFF276B5  05a878ff                          bsr.a   sub_FFF1EF5D
FFF276B9  a401                              mov.l   r1, 54h+var_14[sp]
FFF276BB  ac01                              mov.l   54h+var_14[sp], r1
FFF276BD  6101                              cmp     #0, r1
FFF276BF  10                                beq.s   loc_FFF276C7
FFF276C0  e5001001                          mov.l   54h+var_14[sp], 54h+var_50[sp]
FFF276C4  385601                            bra.w   loc_FFF2781A
FFF276C7  ad01                   loc_FFF276C7 mov.l   54h+var_4[sp], r1
FFF276C9  6221                              add     #2, r1
FFF276CB  a389                              mov.l   r1, 54h+var_18[sp]
FFF276CD  a889                              mov.l   54h+var_48[sp], r1
FFF276CF  e5100d0e                          mov.l   34h[r1], 54h+var_1C[sp]
FFF276D3  a889                              mov.l   54h+var_48[sp], r1
FFF276D5  8c11                              mov.b   10h[r1], r1
FFF276D7  755120                            cmp     #20h, r1 ; ' '
FFF276DA  3af100                            beq.w   loc_FFF277CB
FFF276DD  ac82                              mov.l   54h+var_C[sp], r2
FFF276DF  ab89                              mov.l   54h+var_18[sp], r1
FFF276E1  05a58aff                          bsr.a   sub_FFF20186
FFF276E5  a389                              mov.l   r1, 54h+var_18[sp]
FFF276E7  ab89                              mov.l   54h+var_18[sp], r1
FFF276E9  6101                              cmp     #0, r1
FFF276EB  18                                bne.s   loc_FFF276F3
FFF276EC  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF276F0  382a01                            bra.w   loc_FFF2781A
FFF276F3  ac81                   loc_FFF276F3 mov.l   54h+var_C[sp], r1
FFF276F5  cc1e                              mov.b   [r1], r14
FFF276F7  610e                              cmp     #0, r14
FFF276F9  18                                bne.s   loc_FFF27701
FFF276FA  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF276FE  381c01                            bra.w   loc_FFF2781A
FFF27701  ac82                   loc_FFF27701 mov.l   54h+var_C[sp], r2
FFF27703  a889                              mov.l   54h+var_48[sp], r1
FFF27705  60c0                              sub     #0Ch, sp
FFF27707  a082                              mov.l   r2, 60h+var_58[sp]
FFF27709  710340                            add     #60h+var_20, sp, r3
FFF2770C  a00b                              mov.l   r3, 60h+var_5C[sp]
FFF2770E  f80400                            mov.b   #0, 60h+var_60[sp]
FFF27711  6604                              mov.l   #0, r4
FFF27713  71031c                            add     #60h+var_44, sp, r3
FFF27716  051d7aff                          bsr.a   sub_FFF1F133
FFF2771A  62c0                              add     #0Ch, sp
FFF2771C  a401                              mov.l   r1, 54h+var_14[sp]
FFF2771E  ac01                              mov.l   54h+var_14[sp], r1
FFF27720  6101                              cmp     #0, r1
FFF27722  2017                              beq.b   loc_FFF27739
FFF27724  ab89                              mov.l   54h+var_18[sp], r1
FFF27726  cc1e                              mov.b   [r1], r14
FFF27728  610e                              cmp     #0, r14
FFF2772A  10                                beq.s   loc_FFF27732
FFF2772B  f90601fc                          mov.l   #-4, 54h+var_50[sp]
FFF2772F  38eb00                            bra.w   loc_FFF2781A
FFF27732  f90601fd               loc_FFF27732 mov.l   #-3, 54h+var_50[sp]
FFF27736  38e400                            bra.w   loc_FFF2781A
FFF27739  a889                   loc_FFF27739 mov.l   54h+var_48[sp], r1
FFF2773B  8c12                              mov.b   10h[r1], r2
FFF2773D  710110                            add     #54h+var_44, sp, r1
FFF27740  05588fff                          bsr.a   sub_FFF20698
FFF27744  a381                              mov.l   r1, 54h+var_1C[sp]
FFF27746  388500                            bra.w   loc_FFF277CB
FFF27749  ac82                   loc_FFF27749 mov.l   54h+var_C[sp], r2
FFF2774B  ab89                              mov.l   54h+var_18[sp], r1
FFF2774D  05398aff                          bsr.a   sub_FFF20186
FFF27751  a389                              mov.l   r1, 54h+var_18[sp]
FFF27753  ab89                              mov.l   54h+var_18[sp], r1
FFF27755  6101                              cmp     #0, r1
FFF27757  18                                bne.s   loc_FFF2775F
FFF27758  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2775C  38be00                            bra.w   loc_FFF2781A
FFF2775F  ac81                   loc_FFF2775F mov.l   54h+var_C[sp], r1
FFF27761  cc1e                              mov.b   [r1], r14
FFF27763  610e                              cmp     #0, r14
FFF27765  18                                bne.s   loc_FFF2776D
FFF27766  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2776A  38b000                            bra.w   loc_FFF2781A
FFF2776D  ac83                   loc_FFF2776D mov.l   54h+var_C[sp], r3
FFF2776F  ab82                              mov.l   54h+var_1C[sp], r2
FFF27771  a889                              mov.l   54h+var_48[sp], r1
FFF27773  7100f0                            add     #-10h, sp, sp
FFF27776  a08b                              mov.l   r3, 64h+var_58[sp]
FFF27778  710440                            add     #64h+var_24, sp, r4
FFF2777B  a084                              mov.l   r4, 64h+var_5C[sp]
FFF2777D  710444                            add     #64h+var_20, sp, r4
FFF27780  a00c                              mov.l   r4, 64h+var_60[sp]
FFF27782  3c0100                            mov.b   #0, 64h+var_63[sp]
FFF27785  f80400                            mov.b   #0, 64h+var_64[sp]
FFF27788  710420                            add     #64h+var_44, sp, r4
FFF2778B  05597fff                          bsr.a   sub_FFF1F6E4
FFF2778F  710010                            add     #10h, sp, sp
FFF27792  a401                              mov.l   r1, 54h+var_14[sp]
FFF27794  ac01                              mov.l   54h+var_14[sp], r1
FFF27796  6101                              cmp     #0, r1
FFF27798  2026                              beq.b   loc_FFF277BE
FFF2779A  ab89                              mov.l   54h+var_18[sp], r1
FFF2779C  cc1e                              mov.b   [r1], r14
FFF2779E  610e                              cmp     #0, r14
FFF277A0  210c                              bne.b   loc_FFF277AC
FFF277A2  ac01                              mov.l   54h+var_14[sp], r1
FFF277A4  7501fc                            cmp     #-4, r1
FFF277A7  1d                                bne.s   loc_FFF277AC
FFF277A8  f80601                            mov.l   #1, 54h+var_54[sp]
FFF277AB  0c                                bra.s   loc_FFF277AF
FFF277AC  f80600                 loc_FFF277AC mov.l   #0, 54h+var_54[sp]
FFF277AF  ec01                   loc_FFF277AF mov.l   54h+var_54[sp], r1
FFF277B1  6101                              cmp     #0, r1
FFF277B3  15                                beq.s   loc_FFF277B8
FFF277B4  f90610fd                          mov.l   #-3, 54h+var_14[sp]
FFF277B8  e5001001               loc_FFF277B8 mov.l   54h+var_14[sp], 54h+var_50[sp]
FFF277BC  2e5e                              bra.b   loc_FFF2781A
FFF277BE  a889                   loc_FFF277BE mov.l   54h+var_48[sp], r1
FFF277C0  8c12                              mov.b   10h[r1], r2
FFF277C2  710110                            add     #54h+var_44, sp, r1
FFF277C5  05d38eff                          bsr.a   sub_FFF20698
FFF277C9  a381                              mov.l   r1, 54h+var_1C[sp]
FFF277CB  ab89                   loc_FFF277CB mov.l   54h+var_18[sp], r1
FFF277CD  cc1e                              mov.b   [r1], r14
FFF277CF  610e                              cmp     #0, r14
FFF277D1  3b78ff                            bne.w   loc_FFF27749
FFF277D4  ac89                              mov.l   54h+var_8[sp], r1
FFF277D6  66b3                              mov.l   #0Bh, r3
FFF277D8  710210                            add     #54h+var_44, sp, r2
FFF277DB  059d6c00                          bsr.a   sub_FFF2E478
FFF277DF  ac89                              mov.l   54h+var_8[sp], r1
FFF277E1  cc1e                              mov.b   [r1], r14
FFF277E3  615e                              cmp     #5, r14
FFF277E5  1e                                bne.s   loc_FFF277EB
FFF277E6  ac89                              mov.l   54h+var_8[sp], r1
FFF277E8  f814e5                            mov.b   #-1Bh, [r1]
FFF277EB  b689                   loc_FFF277EB movu.b  54h+var_39[sp], r1
FFF277ED  ac8a                              mov.l   54h+var_8[sp], r2
FFF277EF  82a9                              mov.b   r1, 0Bh[r2]
FFF277F1  bd03                              movu.w  54h+var_2C[sp], r3
FFF277F3  bc8a                              movu.w  54h+var_2E[sp], r2
FFF277F5  ac89                              mov.l   54h+var_8[sp], r1
FFF277F7  62c1                              add     #0Ch, r1
FFF277F9  053b8fff                          bsr.a   sub_FFF20734
FFF277FD  a889                              mov.l   54h+var_48[sp], r1
FFF277FF  8c12                              mov.b   10h[r1], r2
FFF27801  ac8e                              mov.l   54h+var_8[sp], r6
FFF27803  710110                            add     #54h+var_44, sp, r1
FFF27806  05928eff                          bsr.a   sub_FFF20698
FFF2780A  a361                              mov.l   r1, 30h[r6]
FFF2780C  ac8e                              mov.l   54h+var_8[sp], r6
FFF2780E  71012c                            add     #54h+var_28, sp, r1
FFF27811  05097500                          bsr.a   sub_FFF2ED1A
FFF27815  a369                              mov.l   r1, 34h[r6]
FFF27817  3e0100                            mov.l   #0, 54h+var_50[sp]
FFF2781A  a809                   loc_FFF2781A mov.l   54h+var_50[sp], r1
FFF2781C  a409                              mov.l   r1, 54h+var_10[sp]
FFF2781E  3f6616                            rtsd    #58h, r6-r6
FFF27821  7100e8                 sub_FFF27821 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF27821
FFF27824  a109                              mov.l   r1, 18h+var_4[sp]
FFF27826  a102                              mov.l   r2, 18h+var_8[sp]
FFF27828  056ee6fe                          bsr.a   sub_FFF15E96
FFF2782C  a009                              mov.l   r1, 18h+var_14[sp]
FFF2782E  a809                              mov.l   18h+var_14[sp], r1
FFF27830  6101                              cmp     #0, r1
FFF27832  210f                              bne.b   loc_FFF27841
FFF27834  6602                              mov.l   #0, r2
FFF27836  fb16e1                            mov.l   #-1Fh, r1
FFF27839  05e775ff                          bsr.a   sub_FFF1EE20
FFF2783D  e301                              mov.l   r1, 18h+var_18[sp]
FFF2783F  2e16                              bra.b   loc_FFF27855
FFF27841  a80b                   loc_FFF27841 mov.l   18h+var_14[sp], r3
FFF27843  a902                              mov.l   18h+var_8[sp], r2
FFF27845  a909                              mov.l   18h+var_4[sp], r1
FFF27847  391400                            bsr.w   sub_FFF2785B
FFF2784A  a081                              mov.l   r1, 18h+var_10[sp]
FFF2784C  a809                              mov.l   18h+var_14[sp], r1
FFF2784E  0558e6fe                          bsr.a   sub_FFF15EA6
FFF27852  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF27855  ec01                   loc_FFF27855 mov.l   18h+var_18[sp], r1
FFF27857  a089                              mov.l   r1, 18h+var_C[sp]
FFF27859  6706                              rtsd    #6
FFF2785B  6e67                   sub_FFF2785B pushm   r6-r7   ; <<<< FUNC sub_FFF2785B
FFF2785D  7100d8                            add     #-28h, sp, sp
FFF27860  a209                              mov.l   r1, 28h+var_4[sp]
FFF27862  a202                              mov.l   r2, 28h+var_8[sp]
FFF27864  a18b                              mov.l   r3, 28h+var_C[sp]
FFF27866  aa01                              mov.l   28h+var_8[sp], r1
FFF27868  8489                              mov.b   r1, 28h+var_15[sp]
FFF2786A  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF27870  e4e003                            mov.l   [r14], 28h+var_1C[sp]
FFF27873  0578d7ff                          bsr.a   sub_FFF24FEB
FFF27877  a109                              mov.l   r1, 28h+var_14[sp]
FFF27879  a909                              mov.l   28h+var_14[sp], r1
FFF2787B  6101                              cmp     #0, r1
FFF2787D  200f                              beq.b   loc_FFF2788C
FFF2787F  a909                              mov.l   28h+var_14[sp], r1
FFF27881  6602                              mov.l   #0, r2
FFF27883  059d75ff                          bsr.a   sub_FFF1EE20
FFF27887  a009                              mov.l   r1, 28h+var_24[sp]
FFF27889  384101                            bra.w   loc_FFF279CA
FFF2788C  aa09                   loc_FFF2788C mov.l   28h+var_4[sp], r1
FFF2788E  6101                              cmp     #0, r1
FFF27890  2110                              bne.b   loc_FFF278A0
FFF27892  6602                              mov.l   #0, r2
FFF27894  fb16ff                            mov.l   #-1, r1
FFF27897  058975ff                          bsr.a   sub_FFF1EE20
FFF2789B  a009                              mov.l   r1, 28h+var_24[sp]
FFF2789D  382d01                            bra.w   loc_FFF279CA
FFF278A0  aa09                   loc_FFF278A0 mov.l   28h+var_4[sp], r1
FFF278A2  056c8aff                          bsr.a   sub_FFF2030E
FFF278A6  a109                              mov.l   r1, 28h+var_14[sp]
FFF278A8  a909                              mov.l   28h+var_14[sp], r1
FFF278AA  6101                              cmp     #0, r1
FFF278AC  200f                              beq.b   loc_FFF278BB
FFF278AE  a909                              mov.l   28h+var_14[sp], r1
FFF278B0  6602                              mov.l   #0, r2
FFF278B2  056e75ff                          bsr.a   sub_FFF1EE20
FFF278B6  a009                              mov.l   r1, 28h+var_24[sp]
FFF278B8  381201                            bra.w   loc_FFF279CA
FFF278BB  aa0e                   loc_FFF278BB mov.l   28h+var_4[sp], r6
FFF278BD  a98f                              mov.l   28h+var_C[sp], r7
FFF278BF  ef61                              mov.l   r6, r1
FFF278C1  05616d00                          bsr.a   sub_FFF2E622
FFF278C5  72770c10                          add     #100Ch, r7, r7
FFF278C9  ef13                              mov.l   r1, r3
FFF278CB  6213                              add     #1, r3
FFF278CD  ef71                              mov.l   r7, r1
FFF278CF  ef62                              mov.l   r6, r2
FFF278D1  05bd6d00                          bsr.a   sub_FFF2E68E
FFF278D5  a989                              mov.l   28h+var_C[sp], r1
FFF278D7  72110c10                          add     #100Ch, r1, r1
FFF278DB  05466600                          bsr.a   sub_FFF2DF21
FFF278DF  a989                              mov.l   28h+var_C[sp], r1
FFF278E1  ce110c10                          mov.b   100Ch[r1], r1
FFF278E5  05a66e00                          bsr.a   sub_FFF2E78B
FFF278E9  8289                              mov.b   r1, 28h+var_1D[sp]
FFF278EB  b289                              movu.b  28h+var_1D[sp], r1
FFF278ED  71020c                            add     #28h+var_1C, sp, r2
FFF278F0  052f76ff                          bsr.a   sub_FFF1EF1F
FFF278F4  a109                              mov.l   r1, 28h+var_14[sp]
FFF278F6  a909                              mov.l   28h+var_14[sp], r1
FFF278F8  6101                              cmp     #0, r1
FFF278FA  200f                              beq.b   loc_FFF27909
FFF278FC  a909                              mov.l   28h+var_14[sp], r1
FFF278FE  6602                              mov.l   #0, r2
FFF27900  052075ff                          bsr.a   sub_FFF1EE20
FFF27904  a009                              mov.l   r1, 28h+var_24[sp]
FFF27906  38c400                            bra.w   loc_FFF279CA
FFF27909  a889                   loc_FFF27909 mov.l   28h+var_1C[sp], r1
FFF2790B  591e6c                            movu.b  6Ch[r1], r14
FFF2790E  641e                              and     #1, r14
FFF27910  611e                              cmp     #1, r14
FFF27912  200e                              beq.b   loc_FFF27920
FFF27914  a889                              mov.l   28h+var_1C[sp], r1
FFF27916  591e6c                            movu.b  6Ch[r1], r14
FFF27919  752e10                            and     #10h, r14
FFF2791C  755e10                            cmp     #10h, r14
FFF2791F  1d                                bne.s   loc_FFF27924
FFF27920  f80601                 loc_FFF27920 mov.l   #1, 28h+var_28[sp]
FFF27923  0c                                bra.s   loc_FFF27927
FFF27924  f80600                 loc_FFF27924 mov.l   #0, 28h+var_28[sp]
FFF27927  ec01                   loc_FFF27927 mov.l   28h+var_28[sp], r1
FFF27929  6101                              cmp     #0, r1
FFF2792B  2036                              beq.b   loc_FFF27961
FFF2792D  a889                              mov.l   28h+var_1C[sp], r1
FFF2792F  05b4e4fe                          bsr.a   sub_FFF15DE3
FFF27933  a109                              mov.l   r1, 28h+var_14[sp]
FFF27935  a909                              mov.l   28h+var_14[sp], r1
FFF27937  6101                              cmp     #0, r1
FFF27939  2010                              beq.b   loc_FFF27949
FFF2793B  6602                              mov.l   #0, r2
FFF2793D  fb16c1                            mov.l   #-3Fh, r1
FFF27940  05e074ff                          bsr.a   sub_FFF1EE20
FFF27944  a009                              mov.l   r1, 28h+var_24[sp]
FFF27946  388400                            bra.w   loc_FFF279CA
FFF27949  a98c                   loc_FFF27949 mov.l   28h+var_C[sp], r4
FFF2794B  72410c10                          add     #100Ch, r4, r1
FFF2794F  6603                              mov.l   #0, r3
FFF27951  710213                            add     #28h+var_15, sp, r2
FFF27954  397d00                            bsr.w   sub_FFF279D1
FFF27957  a109                              mov.l   r1, 28h+var_14[sp]
FFF27959  a889                              mov.l   28h+var_1C[sp], r1
FFF2795B  0593e4fe                          bsr.a   sub_FFF15DEE
FFF2795F  2e12                              bra.b   loc_FFF27971
FFF27961  a98c                   loc_FFF27961 mov.l   28h+var_C[sp], r4
FFF27963  72410c10                          add     #100Ch, r4, r1
FFF27967  6603                              mov.l   #0, r3
FFF27969  710213                            add     #28h+var_15, sp, r2
FFF2796C  396500                            bsr.w   sub_FFF279D1
FFF2796F  a109                              mov.l   r1, 28h+var_14[sp]
FFF27971  a909                   loc_FFF27971 mov.l   28h+var_14[sp], r1
FFF27973  6101                              cmp     #0, r1
FFF27975  200e                              beq.b   loc_FFF27983
FFF27977  a909                              mov.l   28h+var_14[sp], r1
FFF27979  6602                              mov.l   #0, r2
FFF2797B  05a574ff                          bsr.a   sub_FFF1EE20
FFF2797F  a009                              mov.l   r1, 28h+var_24[sp]
FFF27981  2e49                              bra.b   loc_FFF279CA
FFF27983  a889                   loc_FFF27983 mov.l   28h+var_1C[sp], r1
FFF27985  055752ff                          bsr.a   sub_FFF1CBDC
FFF27989  a109                              mov.l   r1, 28h+var_14[sp]
FFF2798B  a909                              mov.l   28h+var_14[sp], r1
FFF2798D  6101                              cmp     #0, r1
FFF2798F  200e                              beq.b   loc_FFF2799D
FFF27991  a909                              mov.l   28h+var_14[sp], r1
FFF27993  6602                              mov.l   #0, r2
FFF27995  058b74ff                          bsr.a   sub_FFF1EE20
FFF27999  a009                              mov.l   r1, 28h+var_24[sp]
FFF2799B  2e2f                              bra.b   loc_FFF279CA
FFF2799D  a889                   loc_FFF2799D mov.l   28h+var_1C[sp], r1
FFF2799F  591e6c                            movu.b  6Ch[r1], r14
FFF279A2  752e10                            and     #10h, r14
FFF279A5  755e10                            cmp     #10h, r14
FFF279A8  2118                              bne.b   loc_FFF279C0
FFF279AA  a98c                              mov.l   28h+var_C[sp], r4
FFF279AC  5a433216                          movu.b  1632h[r4], r3
FFF279B0  5a423116                          movu.b  1631h[r4], r2
FFF279B4  a889                              mov.l   28h+var_1C[sp], r1
FFF279B6  72440c06                          add     #60Ch, r4, r4
FFF279BA  05a2eaff                          bsr.a   sub_FFF2645C
FFF279BE  a109                              mov.l   r1, 28h+var_14[sp]
FFF279C0  a909                   loc_FFF279C0 mov.l   28h+var_14[sp], r1
FFF279C2  6602                              mov.l   #0, r2
FFF279C4  055c74ff                          bsr.a   sub_FFF1EE20
FFF279C8  a009                              mov.l   r1, 28h+var_24[sp]
FFF279CA  a809                   loc_FFF279CA mov.l   28h+var_24[sp], r1
FFF279CC  a181                              mov.l   r1, 28h+var_10[sp]
FFF279CE  3f670c                            rtsd    #30h, r6-r7
FFF279D1  710084                 sub_FFF279D1 add     #-7Ch, sp, sp   ; <<<< FUNC sub_FFF279D1
FFF279D4  a781                              mov.l   r1, 7Ch+var_4[sp]
FFF279D6  a70a                              mov.l   r2, 7Ch+var_8[sp]
FFF279D8  a703                              mov.l   r3, 7Ch+var_C[sp]
FFF279DA  a68c                              mov.l   r4, 7Ch+var_10[sp]
FFF279DC  3e8500                            mov.l   #0, 7Ch+var_28[sp]
FFF279DF  3e8400                            mov.l   #0, 7Ch+var_2C[sp]
FFF279E2  3e8300                            mov.l   #0, 7Ch+var_30[sp]
FFF279E5  3e8200                            mov.l   #0, 7Ch+var_34[sp]
FFF279E8  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF279EE  e4e004                            mov.l   [r14], 7Ch+var_6C[sp]
FFF279F1  fbe2245e0600                      mov.l   #65E24h, r14
FFF279F7  e4e003                            mov.l   [r14], 7Ch+var_70[sp]
FFF279FA  ae89                              mov.l   7Ch+var_10[sp], r1
FFF279FC  fa14301600                        mov.b   #0, 1630h[r1]
FFF27A01  3e8800                            mov.l   #0, 7Ch+var_1C[sp]
FFF27A04  2e26                              bra.b   loc_FFF27A2A
FFF27A06  af82                   locret_FFF27A06 mov.l   7Ch+var_4[sp], r2
FFF27A08  a889                              mov.l   7Ch+var_70[sp], r1
FFF27A0A  72113c02                          add     #23Ch, r1, r1
FFF27A0E  05c1aaff                          bsr.a   sub_FFF224CF
FFF27A12  6101                              cmp     #0, r1
FFF27A14  18                                bne.s   loc_FFF27A1C
FFF27A15  f90601f9                          mov.l   #-7, 7Ch+var_78[sp]
FFF27A19  38b402                            bra.w   loc_FFF27CCD
FFF27A1C  ae01                   loc_FFF27A1C mov.l   7Ch+var_1C[sp], r1
FFF27A1E  6211                              add     #1, r1
FFF27A20  a601                              mov.l   r1, 7Ch+var_1C[sp]
FFF27A22  a889                              mov.l   7Ch+var_70[sp], r1
FFF27A24  72116804                          add     #468h, r1, r1
FFF27A28  a089                              mov.l   r1, 7Ch+var_70[sp]
FFF27A2A  fbe212250100           loc_FFF27A2A mov.l   #12512h, r14
FFF27A30  dcee                              mov.w   [r14], r14
FFF27A32  06850e18                          cmp     7Ch+var_1C[sp].l, r14
FFF27A36  2ad0                              bgt.b   locret_FFF27A06
FFF27A38  af81                              mov.l   7Ch+var_4[sp], r1
FFF27A3A  cc11                              mov.b   [r1], r1
FFF27A3C  054f6d00                          bsr.a   sub_FFF2E78B
FFF27A40  8289                              mov.b   r1, 7Ch+var_71[sp]
FFF27A42  b289                              movu.b  7Ch+var_71[sp], r1
FFF27A44  710210                            add     #7Ch+var_6C, sp, r2
FFF27A47  05d874ff                          bsr.a   sub_FFF1EF1F
FFF27A4B  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27A4D  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27A4F  6101                              cmp     #0, r1
FFF27A51  10                                beq.s   loc_FFF27A59
FFF27A52  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF27A56  387702                            bra.w   loc_FFF27CCD
FFF27A59  a901                   loc_FFF27A59 mov.l   7Ch+var_6C[sp], r1
FFF27A5B  050275ff                          bsr.a   sub_FFF1EF5D
FFF27A5F  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27A61  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27A63  6101                              cmp     #0, r1
FFF27A65  10                                beq.s   loc_FFF27A6D
FFF27A66  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF27A6A  386302                            bra.w   loc_FFF27CCD
FFF27A6D  a901                   loc_FFF27A6D mov.l   7Ch+var_6C[sp], r1
FFF27A6F  052275ff                          bsr.a   sub_FFF1EF91
FFF27A73  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27A75  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27A77  6101                              cmp     #0, r1
FFF27A79  10                                beq.s   locret_FFF27A81
FFF27A7A  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF27A7E  384f02                            bra.w   loc_FFF27CCD
FFF27A81  af81                   locret_FFF27A81 mov.l   7Ch+var_4[sp], r1
FFF27A83  6221                              add     #2, r1
FFF27A85  a581                              mov.l   r1, 7Ch+var_24[sp]
FFF27A87  a901                              mov.l   7Ch+var_6C[sp], r1
FFF27A89  e5100d13                          mov.l   34h[r1], 7Ch+var_30[sp]
FFF27A8D  e5000405                          mov.l   7Ch+var_6C[sp], 7Ch+var_68[sp]
FFF27A91  a901                              mov.l   7Ch+var_6C[sp], r1
FFF27A93  8c11                              mov.b   10h[r1], r1
FFF27A95  755120                            cmp     #20h, r1 ; ' '
FFF27A98  3a0401                            beq.w   loc_FFF27B9C
FFF27A9B  ae8a                              mov.l   7Ch+var_10[sp], r2
FFF27A9D  ad81                              mov.l   7Ch+var_24[sp], r1
FFF27A9F  05e786ff                          bsr.a   sub_FFF20186
FFF27AA3  a581                              mov.l   r1, 7Ch+var_24[sp]
FFF27AA5  ad81                              mov.l   7Ch+var_24[sp], r1
FFF27AA7  6101                              cmp     #0, r1
FFF27AA9  18                                bne.s   loc_FFF27AB1
FFF27AAA  f90601ff                          mov.l   #-1, 7Ch+var_78[sp]
FFF27AAE  381f02                            bra.w   loc_FFF27CCD
FFF27AB1  ae89                   loc_FFF27AB1 mov.l   7Ch+var_10[sp], r1
FFF27AB3  cc1e                              mov.b   [r1], r14
FFF27AB5  610e                              cmp     #0, r14
FFF27AB7  18                                bne.s   loc_FFF27ABF
FFF27AB8  f90601ff                          mov.l   #-1, 7Ch+var_78[sp]
FFF27ABC  381102                            bra.w   loc_FFF27CCD
FFF27ABF  ae8a                   loc_FFF27ABF mov.l   7Ch+var_10[sp], r2
FFF27AC1  a901                              mov.l   7Ch+var_6C[sp], r1
FFF27AC3  60c0                              sub     #0Ch, sp
FFF27AC5  a082                              mov.l   r2, 88h+var_80[sp]
FFF27AC7  710360                            add     #88h+var_28, sp, r3
FFF27ACA  a00b                              mov.l   r3, 88h+var_84[sp]
FFF27ACC  f80400                            mov.b   #0, 88h+var_88[sp]
FFF27ACF  6604                              mov.l   #0, r4
FFF27AD1  710324                            add     #88h+var_64, sp, r3
FFF27AD4  055f76ff                          bsr.a   sub_FFF1F133
FFF27AD8  62c0                              add     #0Ch, sp
FFF27ADA  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27ADC  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27ADE  6101                              cmp     #0, r1
FFF27AE0  2017                              beq.b   loc_FFF27AF7
FFF27AE2  ad81                              mov.l   7Ch+var_24[sp], r1
FFF27AE4  cc1e                              mov.b   [r1], r14
FFF27AE6  610e                              cmp     #0, r14
FFF27AE8  10                                beq.s   loc_FFF27AF0
FFF27AE9  f90601fc                          mov.l   #-4, 7Ch+var_78[sp]
FFF27AED  38e001                            bra.w   loc_FFF27CCD
FFF27AF0  f90601fd               loc_FFF27AF0 mov.l   #-3, 7Ch+var_78[sp]
FFF27AF4  38d901                            bra.w   loc_FFF27CCD
FFF27AF7  a901                   loc_FFF27AF7 mov.l   7Ch+var_6C[sp], r1
FFF27AF9  8c12                              mov.b   10h[r1], r2
FFF27AFB  710118                            add     #7Ch+var_64, sp, r1
FFF27AFE  059a8bff                          bsr.a   sub_FFF20698
FFF27B02  a489                              mov.l   r1, 7Ch+var_30[sp]
FFF27B04  ae89                              mov.l   7Ch+var_10[sp], r1
FFF27B06  fa14301601                        mov.b   #1, 1630h[r1]
FFF27B0B  389100                            bra.w   loc_FFF27B9C
FFF27B0E  ae8a                   loc_FFF27B0E mov.l   7Ch+var_10[sp], r2
FFF27B10  ad81                              mov.l   7Ch+var_24[sp], r1
FFF27B12  057486ff                          bsr.a   sub_FFF20186
FFF27B16  a581                              mov.l   r1, 7Ch+var_24[sp]
FFF27B18  ad81                              mov.l   7Ch+var_24[sp], r1
FFF27B1A  6101                              cmp     #0, r1
FFF27B1C  18                                bne.s   loc_FFF27B24
FFF27B1D  f90601ff                          mov.l   #-1, 7Ch+var_78[sp]
FFF27B21  38ac01                            bra.w   loc_FFF27CCD
FFF27B24  ae89                   loc_FFF27B24 mov.l   7Ch+var_10[sp], r1
FFF27B26  cc1e                              mov.b   [r1], r14
FFF27B28  610e                              cmp     #0, r14
FFF27B2A  18                                bne.s   loc_FFF27B32
FFF27B2B  f90601ff                          mov.l   #-1, 7Ch+var_78[sp]
FFF27B2F  389e01                            bra.w   loc_FFF27CCD
FFF27B32  e5001312               loc_FFF27B32 mov.l   7Ch+var_30[sp], 7Ch+var_34[sp]
FFF27B36  ae8b                              mov.l   7Ch+var_10[sp], r3
FFF27B38  ac8a                              mov.l   7Ch+var_30[sp], r2
FFF27B3A  a901                              mov.l   7Ch+var_6C[sp], r1
FFF27B3C  7100f0                            add     #-10h, sp, sp
FFF27B3F  a08b                              mov.l   r3, 8Ch+var_80[sp]
FFF27B41  710460                            add     #8Ch+var_2C, sp, r4
FFF27B44  a084                              mov.l   r4, 8Ch+var_84[sp]
FFF27B46  710464                            add     #8Ch+var_28, sp, r4
FFF27B49  a00c                              mov.l   r4, 8Ch+var_88[sp]
FFF27B4B  3c0100                            mov.b   #0, 8Ch+var_8B[sp]
FFF27B4E  f80400                            mov.b   #0, 8Ch+var_8C[sp]
FFF27B51  710428                            add     #8Ch+var_64, sp, r4
FFF27B54  05907bff                          bsr.a   sub_FFF1F6E4
FFF27B58  710010                            add     #10h, sp, sp
FFF27B5B  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27B5D  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27B5F  6101                              cmp     #0, r1
FFF27B61  2027                              beq.b   loc_FFF27B88
FFF27B63  ad81                              mov.l   7Ch+var_24[sp], r1
FFF27B65  cc1e                              mov.b   [r1], r14
FFF27B67  610e                              cmp     #0, r14
FFF27B69  210c                              bne.b   loc_FFF27B75
FFF27B6B  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27B6D  7501fc                            cmp     #-4, r1
FFF27B70  1d                                bne.s   loc_FFF27B75
FFF27B71  f80601                            mov.l   #1, 7Ch+var_7C[sp]
FFF27B74  0c                                bra.s   loc_FFF27B78
FFF27B75  f80600                 loc_FFF27B75 mov.l   #0, 7Ch+var_7C[sp]
FFF27B78  ec01                   loc_FFF27B78 mov.l   7Ch+var_7C[sp], r1
FFF27B7A  6101                              cmp     #0, r1
FFF27B7C  15                                beq.s   loc_FFF27B81
FFF27B7D  f90619fd                          mov.l   #-3, 7Ch+var_18[sp]
FFF27B81  e5001901               loc_FFF27B81 mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF27B85  384801                            bra.w   loc_FFF27CCD
FFF27B88  a901                   loc_FFF27B88 mov.l   7Ch+var_6C[sp], r1
FFF27B8A  8c12                              mov.b   10h[r1], r2
FFF27B8C  710118                            add     #7Ch+var_64, sp, r1
FFF27B8F  05098bff                          bsr.a   sub_FFF20698
FFF27B93  a489                              mov.l   r1, 7Ch+var_30[sp]
FFF27B95  ae89                              mov.l   7Ch+var_10[sp], r1
FFF27B97  fa14301601                        mov.b   #1, 1630h[r1]
FFF27B9C  ad81                   loc_FFF27B9C mov.l   7Ch+var_24[sp], r1
FFF27B9E  cc1e                              mov.b   [r1], r14
FFF27BA0  610e                              cmp     #0, r14
FFF27BA2  3b6cff                            bne.w   loc_FFF27B0E
FFF27BA5  ae89                              mov.l   7Ch+var_10[sp], r1
FFF27BA7  5a1e3016                          movu.b  1630h[r1], r14
FFF27BAB  611e                              cmp     #1, r14
FFF27BAD  2112                              bne.b   loc_FFF27BBF
FFF27BAF  a901                              mov.l   7Ch+var_6C[sp], r1
FFF27BB1  591e6c                            movu.b  6Ch[r1], r14
FFF27BB4  752e10                            and     #10h, r14
FFF27BB7  755e10                            cmp     #10h, r14
FFF27BBA  1d                                bne.s   loc_FFF27BBF
FFF27BBB  f80601                            mov.l   #1, 7Ch+var_7C[sp]
FFF27BBE  0c                                bra.s   loc_FFF27BC2
FFF27BBF  f80600                 loc_FFF27BBF mov.l   #0, 7Ch+var_7C[sp]
FFF27BC2  ec01                   loc_FFF27BC2 mov.l   7Ch+var_7C[sp], r1
FFF27BC4  6101                              cmp     #0, r1
FFF27BC6  206d                              beq.b   loc_FFF27C33
FFF27BC8  af81                              mov.l   7Ch+var_4[sp], r1
FFF27BCA  051ff0ff                          bsr.a   sub_FFF26BE9
FFF27BCE  8281                              mov.b   r1, 7Ch+var_72[sp]
FFF27BD0  ae8b                              mov.l   7Ch+var_10[sp], r3
FFF27BD2  a901                              mov.l   7Ch+var_6C[sp], r1
FFF27BD4  72320c06                          add     #60Ch, r3, r2
FFF27BD8  05b1e6ff                          bsr.a   sub_FFF26289
FFF27BDC  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27BDE  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27BE0  6101                              cmp     #0, r1
FFF27BE2  2130                              bne.b   loc_FFF27C12
FFF27BE4  ae8a                              mov.l   7Ch+var_10[sp], r2
FFF27BE6  b285                              movu.b  7Ch+var_72[sp], r5
FFF27BE8  ad0c                              mov.l   7Ch+var_28[sp], r4
FFF27BEA  ad03                              mov.l   7Ch+var_2C[sp], r3
FFF27BEC  a901                              mov.l   7Ch+var_6C[sp], r1
FFF27BEE  60c0                              sub     #0Ch, sp
FFF27BF0  a082                              mov.l   r2, 88h+var_80[sp]
FFF27BF2  72220c06                          add     #60Ch, r2, r2
FFF27BF6  a00a                              mov.l   r2, 88h+var_84[sp]
FFF27BF8  c305                              mov.b   r5, 88h+var_88[sp]
FFF27BFA  710224                            add     #88h+var_64, sp, r2
FFF27BFD  0549e7ff                          bsr.a   sub_FFF26346
FFF27C01  62c0                              add     #0Ch, sp
FFF27C03  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27C05  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27C07  6101                              cmp     #0, r1
FFF27C09  202a                              beq.b   loc_FFF27C33
FFF27C0B  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF27C0F  38be00                            bra.w   loc_FFF27CCD
FFF27C12  ae09                   loc_FFF27C12 mov.l   7Ch+var_18[sp], r1
FFF27C14  7601d3fe                          cmp     #-12Dh, r1
FFF27C18  10                                beq.s   loc_FFF27C20
FFF27C19  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27C1B  7601d4fe                          cmp     #-12Ch, r1
FFF27C1F  1d                                bne.s   loc_FFF27C24
FFF27C20  f80601                 loc_FFF27C20 mov.l   #1, 7Ch+var_7C[sp]
FFF27C23  0c                                bra.s   loc_FFF27C27
FFF27C24  f80600                 loc_FFF27C24 mov.l   #0, 7Ch+var_7C[sp]
FFF27C27  ec01                   loc_FFF27C27 mov.l   7Ch+var_7C[sp], r1
FFF27C29  6101                              cmp     #0, r1
FFF27C2B  18                                bne.s   loc_FFF27C33
FFF27C2C  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF27C30  389d00                            bra.w   loc_FFF27CCD
FFF27C33  e5001510               loc_FFF27C33 mov.l   7Ch+var_28[sp], 7Ch+var_3C[sp]
FFF27C37  ac81                              mov.l   7Ch+var_34[sp], r1
FFF27C39  6101                              cmp     #0, r1
FFF27C3B  200c                              beq.b   loc_FFF27C47
FFF27C3D  f9045f01                          mov.b   #1, 7Ch+var_1D[sp]
FFF27C41  e5001411                          mov.l   7Ch+var_2C[sp], 7Ch+var_38[sp]
FFF27C45  2e10                              bra.b   loc_FFF27C55
FFF27C47  f9045f00               loc_FFF27C47 mov.b   #0, 7Ch+var_1D[sp]
FFF27C4B  a901                              mov.l   7Ch+var_6C[sp], r1
FFF27C4D  6602                              mov.l   #0, r2
FFF27C4F  055d73ff                          bsr.a   sub_FFF1EFAC
FFF27C53  a409                              mov.l   r1, 7Ch+var_38[sp]
FFF27C55  a901                   loc_FFF27C55 mov.l   7Ch+var_6C[sp], r1
FFF27C57  8c12                              mov.b   10h[r1], r2
FFF27C59  710118                            add     #7Ch+var_64, sp, r1
FFF27C5C  053c8aff                          bsr.a   sub_FFF20698
FFF27C60  a381                              mov.l   r1, 7Ch+var_44[sp]
FFF27C62  e5000e0f                          mov.l   7Ch+var_44[sp], 7Ch+var_40[sp]
FFF27C66  af09                              mov.l   7Ch+var_8[sp], r1
FFF27C68  6101                              cmp     #0, r1
FFF27C6A  202f                              beq.b   locret_FFF27C99
FFF27C6C  af09                              mov.l   7Ch+var_8[sp], r1
FFF27C6E  581e                              movu.b  [r1], r14
FFF27C70  ae8d                              mov.l   7Ch+var_10[sp], r5
FFF27C72  ed0f0f                            mov.l   7Ch+var_40[sp], r15
FFF27C75  ac04                              mov.l   7Ch+var_3C[sp], r4
FFF27C77  ac0b                              mov.l   7Ch+var_38[sp], r3
FFF27C79  cd025f                            mov.b   7Ch+var_1D[sp], r2
FFF27C7C  a909                              mov.l   7Ch+var_68[sp], r1
FFF27C7E  60c0                              sub     #0Ch, sp
FFF27C80  a085                              mov.l   r5, 88h+var_80[sp]
FFF27C82  e70f01                            mov.l   r15, 88h+var_84[sp]
FFF27C85  c30e                              mov.b   r14, 88h+var_88[sp]
FFF27C87  394c00                            bsr.w   sub_FFF27CD3
FFF27C8A  62c0                              add     #0Ch, sp
FFF27C8C  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27C8E  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27C90  6101                              cmp     #0, r1
FFF27C92  17                                beq.s   locret_FFF27C99
FFF27C93  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF27C97  2e36                              bra.b   loc_FFF27CCD
FFF27C99  af01                   locret_FFF27C99 mov.l   7Ch+var_C[sp], r1
FFF27C9B  6101                              cmp     #0, r1
FFF27C9D  202d                              beq.b   loc_FFF27CCA
FFF27C9F  ae8d                              mov.l   7Ch+var_10[sp], r5
FFF27CA1  ed0f0f                            mov.l   7Ch+var_40[sp], r15
FFF27CA4  ed0e1c                            mov.l   7Ch+var_C[sp], r14
FFF27CA7  ac04                              mov.l   7Ch+var_3C[sp], r4
FFF27CA9  ac0b                              mov.l   7Ch+var_38[sp], r3
FFF27CAB  cd025f                            mov.b   7Ch+var_1D[sp], r2
FFF27CAE  a909                              mov.l   7Ch+var_68[sp], r1
FFF27CB0  60c0                              sub     #0Ch, sp
FFF27CB2  a085                              mov.l   r5, 88h+var_80[sp]
FFF27CB4  e70f01                            mov.l   r15, 88h+var_84[sp]
FFF27CB7  e30e                              mov.l   r14, 88h+var_88[sp]
FFF27CB9  397801                            bsr.w   sub_FFF27E31
FFF27CBC  62c0                              add     #0Ch, sp
FFF27CBE  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF27CC0  ae09                              mov.l   7Ch+var_18[sp], r1
FFF27CC2  6101                              cmp     #0, r1
FFF27CC4  16                                beq.s   loc_FFF27CCA
FFF27CC5  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF27CC9  0c                                bra.s   loc_FFF27CCD
FFF27CCA  3e0100                 loc_FFF27CCA mov.l   #0, 7Ch+var_78[sp]
FFF27CCD  a809                   loc_FFF27CCD mov.l   7Ch+var_78[sp], r1
FFF27CCF  a681                              mov.l   r1, 7Ch+var_14[sp]
FFF27CD1  671f                              rtsd    #1Fh
FFF27CD3  7100d4                 sub_FFF27CD3 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF27CD3
FFF27CD6  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF27CD8  c70227                            mov.b   r2, 2Ch+var_5[sp]
FFF27CDB  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF27CDD  a18c                              mov.l   r4, 2Ch+var_10[sp]
FFF27CDF  c500301b                          mov.b   2Ch+arg_0[sp], 2Ch+var_11[sp]
FFF27CE3  e5000d05                          mov.l   2Ch+arg_4[sp], 2Ch+var_18[sp]
FFF27CE7  e5000e04                          mov.l   2Ch+arg_8[sp], 2Ch+var_1C[sp]
FFF27CEB  aa81                              mov.l   2Ch+var_4[sp], r1
FFF27CED  0500e0fe                          bsr.a   sub_FFF15CED
FFF27CF1  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF27CF3  a809                              mov.l   2Ch+var_28[sp], r1
FFF27CF5  6101                              cmp     #0, r1
FFF27CF7  16                                beq.s   loc_FFF27CFD
FFF27CF8  f806db                            mov.l   #-25h, 2Ch+var_2C[sp]
FFF27CFB  2e2c                              bra.b   loc_FFF27D27
FFF27CFD  a905                   loc_FFF27CFD mov.l   2Ch+var_1C[sp], r5
FFF27CFF  ed0f05                            mov.l   2Ch+var_18[sp], r15
FFF27D02  590e1b                            movu.b  2Ch+var_11[sp], r14
FFF27D05  a98c                              mov.l   2Ch+var_10[sp], r4
FFF27D07  aa03                              mov.l   2Ch+var_C[sp], r3
FFF27D09  cd0227                            mov.b   2Ch+var_5[sp], r2
FFF27D0C  aa81                              mov.l   2Ch+var_4[sp], r1
FFF27D0E  60c0                              sub     #0Ch, sp
FFF27D10  a085                              mov.l   r5, 38h+var_30[sp]
FFF27D12  e70f01                            mov.l   r15, 38h+var_34[sp]
FFF27D15  c30e                              mov.b   r14, 38h+var_38[sp]
FFF27D17  391600                            bsr.w   sub_FFF27D2D
FFF27D1A  62c0                              add     #0Ch, sp
FFF27D1C  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF27D1E  aa81                              mov.l   2Ch+var_4[sp], r1
FFF27D20  05d8dffe                          bsr.a   sub_FFF15CF8
FFF27D24  e10002                            mov.l   2Ch+var_24[sp], 2Ch+var_2C[sp]
FFF27D27  ec01                   loc_FFF27D27 mov.l   2Ch+var_2C[sp], r1
FFF27D29  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF27D2B  670b                              rtsd    #0Bh
FFF27D2D  7100cc                 sub_FFF27D2D add     #-34h, sp, sp   ; <<<< FUNC sub_FFF27D2D
FFF27D30  a301                              mov.l   r1, 34h+var_4[sp]
FFF27D32  c7022f                            mov.b   r2, 34h+var_5[sp]
FFF27D35  a283                              mov.l   r3, 34h+var_C[sp]
FFF27D37  a20c                              mov.l   r4, 34h+var_10[sp]
FFF27D39  c5003823                          mov.b   34h+arg_0[sp], 34h+var_11[sp]
FFF27D3D  e5000f07                          mov.l   34h+arg_4[sp], 34h+var_18[sp]
FFF27D41  ac01                              mov.l   34h+arg_8[sp], r1
FFF27D43  a181                              mov.l   r1, 34h+var_1C[sp]
FFF27D45  72110c0c                          add     #0C0Ch, r1, r1
FFF27D49  a009                              mov.l   r1, 34h+var_30[sp]
FFF27D4B  cd012f                            mov.b   34h+var_5[sp], r1
FFF27D4E  6101                              cmp     #0, r1
FFF27D50  2177                              bne.b   loc_FFF27DC7
FFF27D52  ab01                              mov.l   34h+var_4[sp], r1
FFF27D54  ad99                              mov.l   5Ch[r1], r1
FFF27D56  6851                              shlr    #5, r1
FFF27D58  aa0a                              mov.l   34h+var_10[sp], r2
FFF27D5A  fc2712                            divu    r1, r2
FFF27D5D  a08a                              mov.l   r2, 34h+var_28[sp]
FFF27D5F  a88a                              mov.l   34h+var_28[sp], r2
FFF27D61  ab01                              mov.l   34h+var_4[sp], r1
FFF27D63  710304                            add     #34h+var_30, sp, r3
FFF27D66  05db87ff                          bsr.a   sub_FFF20541
FFF27D6A  a101                              mov.l   r1, 34h+var_24[sp]
FFF27D6C  a901                              mov.l   34h+var_24[sp], r1
FFF27D6E  6101                              cmp     #0, r1
FFF27D70  17                                beq.s   loc_FFF27D77
FFF27D71  e10004                            mov.l   34h+var_24[sp], 34h+var_34[sp]
FFF27D74  38b700                            bra.w   loc_FFF27E2B
FFF27D77  ab01                   loc_FFF27D77 mov.l   34h+var_4[sp], r1
FFF27D79  ad99                              mov.l   5Ch[r1], r1
FFF27D7B  6851                              shlr    #5, r1
FFF27D7D  aa0a                              mov.l   34h+var_10[sp], r2
FFF27D7F  ef2e                              mov.l   r2, r14
FFF27D81  fc271e                            divu    r1, r14
FFF27D84  4f1e                              mul     r1, r14
FFF27D86  43e2                              sub     r14, r2
FFF27D88  6c52                              shll    #5, r2
FFF27D8A  06890201                          add     34h+var_30[sp].l, r2
FFF27D8E  a082                              mov.l   r2, 34h+var_2C[sp]
FFF27D90  a881                              mov.l   34h+var_2C[sp], r1
FFF27D92  b299                              movu.b  0Bh[r1], r1
FFF27D94  fc350123                          xor     34h+var_11[sp], r1
FFF27D98  fd74c118                          tst     #18h, r1
FFF27D9C  17                                beq.s   loc_FFF27DA3
FFF27D9D  f806f3                            mov.l   #-0Dh, 34h+var_34[sp]
FFF27DA0  388b00                            bra.w   loc_FFF27E2B
FFF27DA3  590123                 loc_FFF27DA3 movu.b  34h+var_11[sp], r1
FFF27DA6  a882                              mov.l   34h+var_2C[sp], r2
FFF27DA8  82a9                              mov.b   r1, 0Bh[r2]
FFF27DAA  ab01                              mov.l   34h+var_4[sp], r1
FFF27DAC  8c13                              mov.b   10h[r1], r3
FFF27DAE  a98a                              mov.l   34h+var_18[sp], r2
FFF27DB0  a881                              mov.l   34h+var_2C[sp], r1
FFF27DB2  053289ff                          bsr.a   sub_FFF206E4
FFF27DB6  a80b                              mov.l   34h+var_30[sp], r3
FFF27DB8  a88a                              mov.l   34h+var_28[sp], r2
FFF27DBA  ab01                              mov.l   34h+var_4[sp], r1
FFF27DBC  05d687ff                          bsr.a   sub_FFF20592
FFF27DC0  a101                              mov.l   r1, 34h+var_24[sp]
FFF27DC2  e10004                            mov.l   34h+var_24[sp], 34h+var_34[sp]
FFF27DC5  2e66                              bra.b   loc_FFF27E2B
FFF27DC7  aa82                   loc_FFF27DC7 mov.l   34h+var_C[sp], r2
FFF27DC9  ab01                              mov.l   34h+var_4[sp], r1
FFF27DCB  710304                            add     #34h+var_30, sp, r3
FFF27DCE  054286ff                          bsr.a   sub_FFF20410
FFF27DD2  a101                              mov.l   r1, 34h+var_24[sp]
FFF27DD4  a901                              mov.l   34h+var_24[sp], r1
FFF27DD6  6101                              cmp     #0, r1
FFF27DD8  16                                beq.s   loc_FFF27DDE
FFF27DD9  e10004                            mov.l   34h+var_24[sp], 34h+var_34[sp]
FFF27DDC  2e4f                              bra.b   loc_FFF27E2B
FFF27DDE  ab01                   loc_FFF27DDE mov.l   34h+var_4[sp], r1
FFF27DE0  ad99                              mov.l   5Ch[r1], r1
FFF27DE2  6851                              shlr    #5, r1
FFF27DE4  aa0a                              mov.l   34h+var_10[sp], r2
FFF27DE6  ef2e                              mov.l   r2, r14
FFF27DE8  fc271e                            divu    r1, r14
FFF27DEB  4f1e                              mul     r1, r14
FFF27DED  43e2                              sub     r14, r2
FFF27DEF  6c52                              shll    #5, r2
FFF27DF1  06890201                          add     34h+var_30[sp].l, r2
FFF27DF5  a082                              mov.l   r2, 34h+var_2C[sp]
FFF27DF7  a881                              mov.l   34h+var_2C[sp], r1
FFF27DF9  b299                              movu.b  0Bh[r1], r1
FFF27DFB  fc350123                          xor     34h+var_11[sp], r1
FFF27DFF  fd74c118                          tst     #18h, r1
FFF27E03  16                                beq.s   loc_FFF27E09
FFF27E04  f806f3                            mov.l   #-0Dh, 34h+var_34[sp]
FFF27E07  2e24                              bra.b   loc_FFF27E2B
FFF27E09  590123                 loc_FFF27E09 movu.b  34h+var_11[sp], r1
FFF27E0C  a882                              mov.l   34h+var_2C[sp], r2
FFF27E0E  82a9                              mov.b   r1, 0Bh[r2]
FFF27E10  ab01                              mov.l   34h+var_4[sp], r1
FFF27E12  8c13                              mov.b   10h[r1], r3
FFF27E14  a98a                              mov.l   34h+var_18[sp], r2
FFF27E16  a881                              mov.l   34h+var_2C[sp], r1
FFF27E18  05cc88ff                          bsr.a   sub_FFF206E4
FFF27E1C  a80b                              mov.l   34h+var_30[sp], r3
FFF27E1E  aa82                              mov.l   34h+var_C[sp], r2
FFF27E20  ab01                              mov.l   34h+var_4[sp], r1
FFF27E22  058086ff                          bsr.a   sub_FFF204A2
FFF27E26  a101                              mov.l   r1, 34h+var_24[sp]
FFF27E28  e10004                            mov.l   34h+var_24[sp], 34h+var_34[sp]
FFF27E2B  ec01                   loc_FFF27E2B mov.l   34h+var_34[sp], r1
FFF27E2D  a109                              mov.l   r1, 34h+var_20[sp]
FFF27E2F  670d                              rtsd    #0Dh
FFF27E31  7100d4                 sub_FFF27E31 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF27E31
FFF27E34  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF27E36  c70227                            mov.b   r2, 2Ch+var_5[sp]
FFF27E39  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF27E3B  a18c                              mov.l   r4, 2Ch+var_10[sp]
FFF27E3D  e5000c06                          mov.l   2Ch+arg_0[sp], 2Ch+var_14[sp]
FFF27E41  e5000d05                          mov.l   2Ch+arg_4[sp], 2Ch+var_18[sp]
FFF27E45  e5000e04                          mov.l   2Ch+arg_8[sp], 2Ch+var_1C[sp]
FFF27E49  aa81                              mov.l   2Ch+var_4[sp], r1
FFF27E4B  05a2defe                          bsr.a   sub_FFF15CED
FFF27E4F  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF27E51  a809                              mov.l   2Ch+var_28[sp], r1
FFF27E53  6101                              cmp     #0, r1
FFF27E55  16                                beq.s   loc_FFF27E5B
FFF27E56  f806db                            mov.l   #-25h, 2Ch+var_2C[sp]
FFF27E59  2e2c                              bra.b   loc_FFF27E85
FFF27E5B  a905                   loc_FFF27E5B mov.l   2Ch+var_1C[sp], r5
FFF27E5D  ed0f05                            mov.l   2Ch+var_18[sp], r15
FFF27E60  ed0e06                            mov.l   2Ch+var_14[sp], r14
FFF27E63  a98c                              mov.l   2Ch+var_10[sp], r4
FFF27E65  aa03                              mov.l   2Ch+var_C[sp], r3
FFF27E67  cd0227                            mov.b   2Ch+var_5[sp], r2
FFF27E6A  aa81                              mov.l   2Ch+var_4[sp], r1
FFF27E6C  60c0                              sub     #0Ch, sp
FFF27E6E  a085                              mov.l   r5, 38h+var_30[sp]
FFF27E70  e70f01                            mov.l   r15, 38h+var_34[sp]
FFF27E73  e30e                              mov.l   r14, 38h+var_38[sp]
FFF27E75  391600                            bsr.w   sub_FFF27E8B
FFF27E78  62c0                              add     #0Ch, sp
FFF27E7A  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF27E7C  aa81                              mov.l   2Ch+var_4[sp], r1
FFF27E7E  057adefe                          bsr.a   sub_FFF15CF8
FFF27E82  e10002                            mov.l   2Ch+var_24[sp], 2Ch+var_2C[sp]
FFF27E85  ec01                   loc_FFF27E85 mov.l   2Ch+var_2C[sp], r1
FFF27E87  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF27E89  670b                              rtsd    #0Bh
FFF27E8B  7100c8                 sub_FFF27E8B add     #-38h, sp, sp   ; <<<< FUNC sub_FFF27E8B
FFF27E8E  a309                              mov.l   r1, 38h+var_4[sp]
FFF27E90  c70233                            mov.b   r2, 38h+var_5[sp]
FFF27E93  a28b                              mov.l   r3, 38h+var_C[sp]
FFF27E95  a284                              mov.l   r4, 38h+var_10[sp]
FFF27E97  e5000f09                          mov.l   38h+arg_0[sp], 38h+var_14[sp]
FFF27E9B  e5001008                          mov.l   38h+arg_4[sp], 38h+var_18[sp]
FFF27E9F  ac09                              mov.l   38h+arg_8[sp], r1
FFF27EA1  a189                              mov.l   r1, 38h+var_1C[sp]
FFF27EA3  72110c0c                          add     #0C0Ch, r1, r1
FFF27EA7  a009                              mov.l   r1, 38h+var_34[sp]
FFF27EA9  cd0133                            mov.b   38h+var_5[sp], r1
FFF27EAC  6101                              cmp     #0, r1
FFF27EAE  3bc300                            bne.w   loc_FFF27F71
FFF27EB1  ab09                              mov.l   38h+var_4[sp], r1
FFF27EB3  ad99                              mov.l   5Ch[r1], r1
FFF27EB5  6851                              shlr    #5, r1
FFF27EB7  aa82                              mov.l   38h+var_10[sp], r2
FFF27EB9  fc2712                            divu    r1, r2
FFF27EBC  a08a                              mov.l   r2, 38h+var_2C[sp]
FFF27EBE  a88a                              mov.l   38h+var_2C[sp], r2
FFF27EC0  ab09                              mov.l   38h+var_4[sp], r1
FFF27EC2  710304                            add     #38h+var_34, sp, r3
FFF27EC5  057c86ff                          bsr.a   sub_FFF20541
FFF27EC9  a109                              mov.l   r1, 38h+var_24[sp]
FFF27ECB  a909                              mov.l   38h+var_24[sp], r1
FFF27ECD  6101                              cmp     #0, r1
FFF27ECF  17                                beq.s   loc_FFF27ED6
FFF27ED0  e10005                            mov.l   38h+var_24[sp], 38h+var_38[sp]
FFF27ED3  384e01                            bra.w   loc_FFF28021
FFF27ED6  ab09                   loc_FFF27ED6 mov.l   38h+var_4[sp], r1
FFF27ED8  ad99                              mov.l   5Ch[r1], r1
FFF27EDA  6851                              shlr    #5, r1
FFF27EDC  aa82                              mov.l   38h+var_10[sp], r2
FFF27EDE  ef2e                              mov.l   r2, r14
FFF27EE0  fc271e                            divu    r1, r14
FFF27EE3  4f1e                              mul     r1, r14
FFF27EE5  43e2                              sub     r14, r2
FFF27EE7  6c52                              shll    #5, r2
FFF27EE9  06890201                          add     38h+var_34[sp].l, r2
FFF27EED  a082                              mov.l   r2, 38h+var_30[sp]
FFF27EEF  aa09                              mov.l   38h+var_14[sp], r1
FFF27EF1  ec11                              mov.l   [r1], r1
FFF27EF3  fd748102                          div     #2, r1
FFF27EF7  a101                              mov.l   r1, 38h+var_28[sp]
FFF27EF9  aa09                              mov.l   38h+var_14[sp], r1
FFF27EFB  a819                              mov.l   4[r1], r1
FFF27EFD  6c51                              shll    #5, r1
FFF27EFF  06950104                          or      38h+var_28[sp].l, r1
FFF27F03  a101                              mov.l   r1, 38h+var_28[sp]
FFF27F05  aa09                              mov.l   38h+var_14[sp], r1
FFF27F07  a891                              mov.l   8[r1], r1
FFF27F09  6cb1                              shll    #0Bh, r1
FFF27F0B  06950104                          or      38h+var_28[sp].l, r1
FFF27F0F  a101                              mov.l   r1, 38h+var_28[sp]
FFF27F11  ba02                              movu.w  38h+var_28[sp], r2
FFF27F13  a881                              mov.l   38h+var_30[sp], r1
FFF27F15  711116                            add     #16h, r1, r1
FFF27F18  05696d00                          bsr.a   sub_FFF2EC81
FFF27F1C  aa09                              mov.l   38h+var_14[sp], r1
FFF27F1E  e5100304                          mov.l   0Ch[r1], 38h+var_28[sp]
FFF27F22  aa09                              mov.l   38h+var_14[sp], r1
FFF27F24  a911                              mov.l   10h[r1], r1
FFF27F26  6211                              add     #1, r1
FFF27F28  6c51                              shll    #5, r1
FFF27F2A  06950104                          or      38h+var_28[sp].l, r1
FFF27F2E  a101                              mov.l   r1, 38h+var_28[sp]
FFF27F30  aa09                              mov.l   38h+var_14[sp], r1
FFF27F32  a919                              mov.l   14h[r1], r1
FFF27F34  755150                            cmp     #50h, r1 ; 'P'
FFF27F37  2911                              blt.b   loc_FFF27F48
FFF27F39  aa09                              mov.l   38h+var_14[sp], r1
FFF27F3B  a919                              mov.l   14h[r1], r1
FFF27F3D  7111b0                            add     #-50h, r1, r1
FFF27F40  6c91                              shll    #9, r1
FFF27F42  06950104                          or      38h+var_28[sp].l, r1
FFF27F46  a101                              mov.l   r1, 38h+var_28[sp]
FFF27F48  ba02                   loc_FFF27F48 movu.w  38h+var_28[sp], r2
FFF27F4A  a881                              mov.l   38h+var_30[sp], r1
FFF27F4C  711118                            add     #18h, r1, r1
FFF27F4F  05326d00                          bsr.a   sub_FFF2EC81
FFF27F53  ab09                              mov.l   38h+var_4[sp], r1
FFF27F55  8c13                              mov.b   10h[r1], r3
FFF27F57  aa02                              mov.l   38h+var_18[sp], r2
FFF27F59  a881                              mov.l   38h+var_30[sp], r1
FFF27F5B  058987ff                          bsr.a   sub_FFF206E4
FFF27F5F  a80b                              mov.l   38h+var_34[sp], r3
FFF27F61  a88a                              mov.l   38h+var_2C[sp], r2
FFF27F63  ab09                              mov.l   38h+var_4[sp], r1
FFF27F65  052d86ff                          bsr.a   sub_FFF20592
FFF27F69  a109                              mov.l   r1, 38h+var_24[sp]
FFF27F6B  e10005                            mov.l   38h+var_24[sp], 38h+var_38[sp]
FFF27F6E  38b300                            bra.w   loc_FFF28021
FFF27F71  aa8a                   loc_FFF27F71 mov.l   38h+var_C[sp], r2
FFF27F73  ab09                              mov.l   38h+var_4[sp], r1
FFF27F75  710304                            add     #38h+var_34, sp, r3
FFF27F78  059884ff                          bsr.a   sub_FFF20410
FFF27F7C  a109                              mov.l   r1, 38h+var_24[sp]
FFF27F7E  a909                              mov.l   38h+var_24[sp], r1
FFF27F80  6101                              cmp     #0, r1
FFF27F82  17                                beq.s   loc_FFF27F89
FFF27F83  e10005                            mov.l   38h+var_24[sp], 38h+var_38[sp]
FFF27F86  389b00                            bra.w   loc_FFF28021
FFF27F89  ab09                   loc_FFF27F89 mov.l   38h+var_4[sp], r1
FFF27F8B  ad99                              mov.l   5Ch[r1], r1
FFF27F8D  6851                              shlr    #5, r1
FFF27F8F  aa82                              mov.l   38h+var_10[sp], r2
FFF27F91  ef2e                              mov.l   r2, r14
FFF27F93  fc271e                            divu    r1, r14
FFF27F96  4f1e                              mul     r1, r14
FFF27F98  43e2                              sub     r14, r2
FFF27F9A  6c52                              shll    #5, r2
FFF27F9C  06890201                          add     38h+var_34[sp].l, r2
FFF27FA0  a082                              mov.l   r2, 38h+var_30[sp]
FFF27FA2  aa09                              mov.l   38h+var_14[sp], r1
FFF27FA4  ec11                              mov.l   [r1], r1
FFF27FA6  fd748102                          div     #2, r1
FFF27FAA  a101                              mov.l   r1, 38h+var_28[sp]
FFF27FAC  aa09                              mov.l   38h+var_14[sp], r1
FFF27FAE  a819                              mov.l   4[r1], r1
FFF27FB0  6c51                              shll    #5, r1
FFF27FB2  06950104                          or      38h+var_28[sp].l, r1
FFF27FB6  a101                              mov.l   r1, 38h+var_28[sp]
FFF27FB8  aa09                              mov.l   38h+var_14[sp], r1
FFF27FBA  a891                              mov.l   8[r1], r1
FFF27FBC  6cb1                              shll    #0Bh, r1
FFF27FBE  06950104                          or      38h+var_28[sp].l, r1
FFF27FC2  a101                              mov.l   r1, 38h+var_28[sp]
FFF27FC4  ba02                              movu.w  38h+var_28[sp], r2
FFF27FC6  a881                              mov.l   38h+var_30[sp], r1
FFF27FC8  711116                            add     #16h, r1, r1
FFF27FCB  05b66c00                          bsr.a   sub_FFF2EC81
FFF27FCF  aa09                              mov.l   38h+var_14[sp], r1
FFF27FD1  e5100304                          mov.l   0Ch[r1], 38h+var_28[sp]
FFF27FD5  aa09                              mov.l   38h+var_14[sp], r1
FFF27FD7  a911                              mov.l   10h[r1], r1
FFF27FD9  6211                              add     #1, r1
FFF27FDB  6c51                              shll    #5, r1
FFF27FDD  06950104                          or      38h+var_28[sp].l, r1
FFF27FE1  a101                              mov.l   r1, 38h+var_28[sp]
FFF27FE3  aa09                              mov.l   38h+var_14[sp], r1
FFF27FE5  a919                              mov.l   14h[r1], r1
FFF27FE7  755150                            cmp     #50h, r1 ; 'P'
FFF27FEA  2911                              blt.b   loc_FFF27FFB
FFF27FEC  aa09                              mov.l   38h+var_14[sp], r1
FFF27FEE  a919                              mov.l   14h[r1], r1
FFF27FF0  7111b0                            add     #-50h, r1, r1
FFF27FF3  6c91                              shll    #9, r1
FFF27FF5  06950104                          or      38h+var_28[sp].l, r1
FFF27FF9  a101                              mov.l   r1, 38h+var_28[sp]
FFF27FFB  ba02                   loc_FFF27FFB movu.w  38h+var_28[sp], r2
FFF27FFD  a881                              mov.l   38h+var_30[sp], r1
FFF27FFF  711118                            add     #18h, r1, r1
FFF28002  057f6c00                          bsr.a   sub_FFF2EC81
FFF28006  ab09                              mov.l   38h+var_4[sp], r1
FFF28008  8c13                              mov.b   10h[r1], r3
FFF2800A  aa02                              mov.l   38h+var_18[sp], r2
FFF2800C  a881                              mov.l   38h+var_30[sp], r1
FFF2800E  05d686ff                          bsr.a   sub_FFF206E4
FFF28012  a80b                              mov.l   38h+var_34[sp], r3
FFF28014  aa8a                              mov.l   38h+var_C[sp], r2
FFF28016  ab09                              mov.l   38h+var_4[sp], r1
FFF28018  058a84ff                          bsr.a   sub_FFF204A2
FFF2801C  a109                              mov.l   r1, 38h+var_24[sp]
FFF2801E  e10005                            mov.l   38h+var_24[sp], 38h+var_38[sp]
FFF28021  ec01                   loc_FFF28021 mov.l   38h+var_38[sp], r1
FFF28023  a181                              mov.l   r1, 38h+var_20[sp]
FFF28025  670e                              rtsd    #0Eh
FFF28027  7100b8                 sub_FFF28027 add     #-48h, sp, sp   ; <<<< FUNC sub_FFF28027
FFF2802A  a409                              mov.l   r1, 48h+var_4[sp]
FFF2802C  710204                            add     #48h+var_44, sp, r2
FFF2802F  396df5                            bsr.w   sub_FFF2759C
FFF28032  a389                              mov.l   r1, 48h+var_C[sp]
FFF28034  ab89                              mov.l   48h+var_C[sp], r1
FFF28036  6101                              cmp     #0, r1
FFF28038  16                                beq.s   loc_FFF2803E
FFF28039  e1000f                            mov.l   48h+var_C[sp], 48h+var_48[sp]
FFF2803C  2e0e                              bra.b   loc_FFF2804A
FFF2803E  6601                   loc_FFF2803E mov.l   #0, r1
FFF28040  ef12                              mov.l   r1, r2
FFF28042  05de6dff                          bsr.a   sub_FFF1EE20
FFF28046  8b89                              mov.b   48h+var_39[sp], r1
FFF28048  e301                              mov.l   r1, 48h+var_48[sp]
FFF2804A  ec01                   loc_FFF2804A mov.l   48h+var_48[sp], r1
FFF2804C  a401                              mov.l   r1, 48h+var_8[sp]
FFF2804E  6712                              rtsd    #12h
FFF28050  7100e8                 sub_FFF28050 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF28050
FFF28053  a109                              mov.l   r1, 18h+var_4[sp]
FFF28055  a102                              mov.l   r2, 18h+var_8[sp]
FFF28057  053fdefe                          bsr.a   sub_FFF15E96
FFF2805B  a009                              mov.l   r1, 18h+var_14[sp]
FFF2805D  a809                              mov.l   18h+var_14[sp], r1
FFF2805F  6101                              cmp     #0, r1
FFF28061  210f                              bne.b   loc_FFF28070
FFF28063  6602                              mov.l   #0, r2
FFF28065  fb16e1                            mov.l   #-1Fh, r1
FFF28068  05b86dff                          bsr.a   sub_FFF1EE20
FFF2806C  e301                              mov.l   r1, 18h+var_18[sp]
FFF2806E  2e16                              bra.b   loc_FFF28084
FFF28070  a80b                   loc_FFF28070 mov.l   18h+var_14[sp], r3
FFF28072  a902                              mov.l   18h+var_8[sp], r2
FFF28074  a909                              mov.l   18h+var_4[sp], r1
FFF28076  391400                            bsr.w   sub_FFF2808A
FFF28079  a081                              mov.l   r1, 18h+var_10[sp]
FFF2807B  a809                              mov.l   18h+var_14[sp], r1
FFF2807D  0529defe                          bsr.a   sub_FFF15EA6
FFF28081  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF28084  ec01                   loc_FFF28084 mov.l   18h+var_18[sp], r1
FFF28086  a089                              mov.l   r1, 18h+var_C[sp]
FFF28088  6706                              rtsd    #6
FFF2808A  7100e4                 sub_FFF2808A add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2808A
FFF2808D  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2808F  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF28091  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF28093  e5000601                          mov.l   1Ch+var_4[sp], 1Ch+var_18[sp]
FFF28097  0554cfff                          bsr.a   sub_FFF24FEB
FFF2809B  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2809D  a881                              mov.l   1Ch+var_14[sp], r1
FFF2809F  6101                              cmp     #0, r1
FFF280A1  200e                              beq.b   loc_FFF280AF
FFF280A3  a881                              mov.l   1Ch+var_14[sp], r1
FFF280A5  6602                              mov.l   #0, r2
FFF280A7  05796dff                          bsr.a   sub_FFF1EE20
FFF280AB  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF280AD  2e60                              bra.b   loc_FFF2810D
FFF280AF  a809                   loc_FFF280AF mov.l   1Ch+var_18[sp], r1
FFF280B1  05e56dff                          bsr.a   sub_FFF1EE96
FFF280B5  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF280B7  a881                              mov.l   1Ch+var_14[sp], r1
FFF280B9  6101                              cmp     #0, r1
FFF280BB  200e                              beq.b   loc_FFF280C9
FFF280BD  a881                              mov.l   1Ch+var_14[sp], r1
FFF280BF  6602                              mov.l   #0, r2
FFF280C1  055f6dff                          bsr.a   sub_FFF1EE20
FFF280C5  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF280C7  2e46                              bra.b   loc_FFF2810D
FFF280C9  a80a                   loc_FFF280C9 mov.l   1Ch+var_18[sp], r2
FFF280CB  ce2e4204                          mov.b   442h[r2], r14
FFF280CF  611e                              cmp     #1, r14
FFF280D1  210d                              bne.b   loc_FFF280DE
FFF280D3  fb16fb                            mov.l   #-5, r1
FFF280D6  054a6dff                          bsr.a   sub_FFF1EE20
FFF280DA  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF280DC  2e31                              bra.b   loc_FFF2810D
FFF280DE  ec21                   loc_FFF280DE mov.l   [r2], r1
FFF280E0  05b16eff                          bsr.a   sub_FFF1EF91
FFF280E4  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF280E6  a881                              mov.l   1Ch+var_14[sp], r1
FFF280E8  6101                              cmp     #0, r1
FFF280EA  200e                              beq.b   loc_FFF280F8
FFF280EC  a80a                              mov.l   1Ch+var_18[sp], r2
FFF280EE  a881                              mov.l   1Ch+var_14[sp], r1
FFF280F0  05306dff                          bsr.a   sub_FFF1EE20
FFF280F4  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF280F6  2e17                              bra.b   loc_FFF2810D
FFF280F8  a903                   loc_FFF280F8 mov.l   1Ch+var_C[sp], r3
FFF280FA  a90a                              mov.l   1Ch+var_8[sp], r2
FFF280FC  a809                              mov.l   1Ch+var_18[sp], r1
FFF280FE  391500                            bsr.w   sub_FFF28113
FFF28101  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF28103  a80a                              mov.l   1Ch+var_18[sp], r2
FFF28105  a881                              mov.l   1Ch+var_14[sp], r1
FFF28107  05196dff                          bsr.a   sub_FFF1EE20
FFF2810B  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2810D  ec01                   loc_FFF2810D mov.l   1Ch+var_1C[sp], r1
FFF2810F  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF28111  6707                              rtsd    #7
FFF28113  7100ec                 sub_FFF28113 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF28113
FFF28116  a101                              mov.l   r1, 14h+var_4[sp]
FFF28118  a08a                              mov.l   r2, 14h+var_8[sp]
FFF2811A  a083                              mov.l   r3, 14h+var_C[sp]
FFF2811C  a901                              mov.l   14h+var_4[sp], r1
FFF2811E  5a1e4304                          movu.b  443h[r1], r14
FFF28122  06a10d0e03                        xor     14h+var_8[sp].l, r14
FFF28127  fd74ce18                          tst     #18h, r14
FFF2812B  16                                beq.s   loc_FFF28131
FFF2812C  f806f3                            mov.l   #-0Dh, 14h+var_14[sp]
FFF2812F  2e0d                              bra.b   loc_FFF2813C
FFF28131  a889                   loc_FFF28131 mov.l   14h+var_8[sp], r1
FFF28133  a902                              mov.l   14h+var_4[sp], r2
FFF28135  cb214304                          mov.b   r1, 443h[r2]
FFF28139  f80600                            mov.l   #0, 14h+var_14[sp]
FFF2813C  ec01                   loc_FFF2813C mov.l   14h+var_14[sp], r1
FFF2813E  a009                              mov.l   r1, 14h+var_10[sp]
FFF28140  6705                              rtsd    #5
FFF28142  60c0                   sub_FFF28142 sub     #0Ch, sp   ; <<<< FUNC sub_FFF28142
FFF28144  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF28146  390b00                            bsr.w   sub_FFF28151
FFF28149  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF2814B  ec01                              mov.l   0Ch+var_C[sp], r1
FFF2814D  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF2814F  6703                              rtsd    #3
FFF28151  7100e8                 sub_FFF28151 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF28151
FFF28154  a109                              mov.l   r1, 18h+var_4[sp]
FFF28156  a009                              mov.l   r1, 18h+var_14[sp]
FFF28158  0593ceff                          bsr.a   sub_FFF24FEB
FFF2815C  a089                              mov.l   r1, 18h+var_C[sp]
FFF2815E  a889                              mov.l   18h+var_C[sp], r1
FFF28160  6101                              cmp     #0, r1
FFF28162  200e                              beq.b   loc_FFF28170
FFF28164  a889                              mov.l   18h+var_C[sp], r1
FFF28166  6602                              mov.l   #0, r2
FFF28168  05b86cff                          bsr.a   sub_FFF1EE20
FFF2816C  e301                              mov.l   r1, 18h+var_18[sp]
FFF2816E  2e3c                              bra.b   loc_FFF281AA
FFF28170  a809                   loc_FFF28170 mov.l   18h+var_14[sp], r1
FFF28172  05246dff                          bsr.a   sub_FFF1EE96
FFF28176  a089                              mov.l   r1, 18h+var_C[sp]
FFF28178  a889                              mov.l   18h+var_C[sp], r1
FFF2817A  6101                              cmp     #0, r1
FFF2817C  200e                              beq.b   loc_FFF2818A
FFF2817E  a889                              mov.l   18h+var_C[sp], r1
FFF28180  6602                              mov.l   #0, r2
FFF28182  059e6cff                          bsr.a   sub_FFF1EE20
FFF28186  e301                              mov.l   r1, 18h+var_18[sp]
FFF28188  2e22                              bra.b   loc_FFF281AA
FFF2818A  a909                   loc_FFF2818A mov.l   18h+var_4[sp], r1
FFF2818C  71020b                            add     #18h+var_D, sp, r2
FFF2818F  392100                            bsr.w   sub_FFF281B0
FFF28192  a089                              mov.l   r1, 18h+var_C[sp]
FFF28194  a889                              mov.l   18h+var_C[sp], r1
FFF28196  6101                              cmp     #0, r1
FFF28198  a80a                              mov.l   18h+var_14[sp], r2
FFF2819A  10                                beq.s   loc_FFF281A2
FFF2819B  05856cff                          bsr.a   sub_FFF1EE20
FFF2819F  e301                              mov.l   r1, 18h+var_18[sp]
FFF281A1  09                                bra.s   loc_FFF281AA
FFF281A2  057e6cff               loc_FFF281A2 bsr.a   sub_FFF1EE20
FFF281A6  8a89                              mov.b   18h+var_D[sp], r1
FFF281A8  e301                              mov.l   r1, 18h+var_18[sp]
FFF281AA  ec01                   loc_FFF281AA mov.l   18h+var_18[sp], r1
FFF281AC  a101                              mov.l   r1, 18h+var_8[sp]
FFF281AE  6706                              rtsd    #6
FFF281B0  60c0                   sub_FFF281B0 sub     #0Ch, sp   ; <<<< FUNC sub_FFF281B0
FFF281B2  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF281B4  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF281B6  a881                              mov.l   0Ch+var_4[sp], r1
FFF281B8  c2124304                          mov.b   443h[r1], [r2]
FFF281BC  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF281BF  6601                              mov.l   #0, r1
FFF281C1  6703                              rtsd    #3
FFF281C3  7100e8                 sub_FFF281C3 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF281C3
FFF281C6  a109                              mov.l   r1, 18h+var_4[sp]
FFF281C8  a102                              mov.l   r2, 18h+var_8[sp]
FFF281CA  05ccdcfe                          bsr.a   sub_FFF15E96
FFF281CE  a009                              mov.l   r1, 18h+var_14[sp]
FFF281D0  a809                              mov.l   18h+var_14[sp], r1
FFF281D2  6101                              cmp     #0, r1
FFF281D4  210f                              bne.b   loc_FFF281E3
FFF281D6  6602                              mov.l   #0, r2
FFF281D8  fb16e1                            mov.l   #-1Fh, r1
FFF281DB  05456cff                          bsr.a   sub_FFF1EE20
FFF281DF  e301                              mov.l   r1, 18h+var_18[sp]
FFF281E1  2e16                              bra.b   loc_FFF281F7
FFF281E3  a80b                   loc_FFF281E3 mov.l   18h+var_14[sp], r3
FFF281E5  a902                              mov.l   18h+var_8[sp], r2
FFF281E7  a909                              mov.l   18h+var_4[sp], r1
FFF281E9  391400                            bsr.w   sub_FFF281FD
FFF281EC  a081                              mov.l   r1, 18h+var_10[sp]
FFF281EE  a809                              mov.l   18h+var_14[sp], r1
FFF281F0  05b6dcfe                          bsr.a   sub_FFF15EA6
FFF281F4  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF281F7  ec01                   loc_FFF281F7 mov.l   18h+var_18[sp], r1
FFF281F9  a089                              mov.l   r1, 18h+var_C[sp]
FFF281FB  6706                              rtsd    #6
FFF281FD  6e67                   sub_FFF281FD pushm   r6-r7   ; <<<< FUNC sub_FFF281FD
FFF281FF  7100dc                            add     #-24h, sp, sp
FFF28202  a201                              mov.l   r1, 24h+var_4[sp]
FFF28204  a18a                              mov.l   r2, 24h+var_8[sp]
FFF28206  a183                              mov.l   r3, 24h+var_C[sp]
FFF28208  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2820E  e4e003                            mov.l   [r14], 24h+var_18[sp]
FFF28211  05dacdff                          bsr.a   sub_FFF24FEB
FFF28215  a101                              mov.l   r1, 24h+var_14[sp]
FFF28217  a901                              mov.l   24h+var_14[sp], r1
FFF28219  6101                              cmp     #0, r1
FFF2821B  200f                              beq.b   loc_FFF2822A
FFF2821D  a901                              mov.l   24h+var_14[sp], r1
FFF2821F  6602                              mov.l   #0, r2
FFF28221  05ff6bff                          bsr.a   sub_FFF1EE20
FFF28225  a009                              mov.l   r1, 24h+var_20[sp]
FFF28227  386a01                            bra.w   loc_FFF28391
FFF2822A  aa01                   loc_FFF2822A mov.l   24h+var_4[sp], r1
FFF2822C  6101                              cmp     #0, r1
FFF2822E  2110                              bne.b   loc_FFF2823E
FFF28230  6602                              mov.l   #0, r2
FFF28232  fb16ff                            mov.l   #-1, r1
FFF28235  05eb6bff                          bsr.a   sub_FFF1EE20
FFF28239  a009                              mov.l   r1, 24h+var_20[sp]
FFF2823B  385601                            bra.w   loc_FFF28391
FFF2823E  aa01                   loc_FFF2823E mov.l   24h+var_4[sp], r1
FFF28240  05ce80ff                          bsr.a   sub_FFF2030E
FFF28244  a101                              mov.l   r1, 24h+var_14[sp]
FFF28246  a901                              mov.l   24h+var_14[sp], r1
FFF28248  6101                              cmp     #0, r1
FFF2824A  200f                              beq.b   loc_FFF28259
FFF2824C  a901                              mov.l   24h+var_14[sp], r1
FFF2824E  6602                              mov.l   #0, r2
FFF28250  05d06bff                          bsr.a   sub_FFF1EE20
FFF28254  a009                              mov.l   r1, 24h+var_20[sp]
FFF28256  383b01                            bra.w   loc_FFF28391
FFF28259  a989                   loc_FFF28259 mov.l   24h+var_8[sp], r1
FFF2825B  6101                              cmp     #0, r1
FFF2825D  2110                              bne.b   loc_FFF2826D
FFF2825F  6602                              mov.l   #0, r2
FFF28261  fb16f3                            mov.l   #-0Dh, r1
FFF28264  05bc6bff                          bsr.a   sub_FFF1EE20
FFF28268  a009                              mov.l   r1, 24h+var_20[sp]
FFF2826A  382701                            bra.w   loc_FFF28391
FFF2826D  a989                   loc_FFF2826D mov.l   24h+var_8[sp], r1
FFF2826F  392901                            bsr.w   sub_FFF28398
FFF28272  6101                              cmp     #0, r1
FFF28274  2010                              beq.b   loc_FFF28284
FFF28276  6602                              mov.l   #0, r2
FFF28278  fb16f3                            mov.l   #-0Dh, r1
FFF2827B  05a56bff                          bsr.a   sub_FFF1EE20
FFF2827F  a009                              mov.l   r1, 24h+var_20[sp]
FFF28281  381001                            bra.w   loc_FFF28391
FFF28284  aa06                   loc_FFF28284 mov.l   24h+var_4[sp], r6
FFF28286  a987                              mov.l   24h+var_C[sp], r7
FFF28288  ef61                              mov.l   r6, r1
FFF2828A  05986300                          bsr.a   sub_FFF2E622
FFF2828E  72770c10                          add     #100Ch, r7, r7
FFF28292  ef13                              mov.l   r1, r3
FFF28294  6213                              add     #1, r3
FFF28296  ef71                              mov.l   r7, r1
FFF28298  ef62                              mov.l   r6, r2
FFF2829A  05f46300                          bsr.a   sub_FFF2E68E
FFF2829E  a981                              mov.l   24h+var_C[sp], r1
FFF282A0  72110c10                          add     #100Ch, r1, r1
FFF282A4  057d5c00                          bsr.a   sub_FFF2DF21
FFF282A8  a981                              mov.l   24h+var_C[sp], r1
FFF282AA  ce110c10                          mov.b   100Ch[r1], r1
FFF282AE  05dd6400                          bsr.a   sub_FFF2E78B
FFF282B2  8289                              mov.b   r1, 24h+var_19[sp]
FFF282B4  b289                              movu.b  24h+var_19[sp], r1
FFF282B6  71020c                            add     #24h+var_18, sp, r2
FFF282B9  05666cff                          bsr.a   sub_FFF1EF1F
FFF282BD  a101                              mov.l   r1, 24h+var_14[sp]
FFF282BF  a901                              mov.l   24h+var_14[sp], r1
FFF282C1  6101                              cmp     #0, r1
FFF282C3  200f                              beq.b   loc_FFF282D2
FFF282C5  a901                              mov.l   24h+var_14[sp], r1
FFF282C7  6602                              mov.l   #0, r2
FFF282C9  05576bff                          bsr.a   sub_FFF1EE20
FFF282CD  a009                              mov.l   r1, 24h+var_20[sp]
FFF282CF  38c200                            bra.w   loc_FFF28391
FFF282D2  a889                   loc_FFF282D2 mov.l   24h+var_18[sp], r1
FFF282D4  591e6c                            movu.b  6Ch[r1], r14
FFF282D7  641e                              and     #1, r14
FFF282D9  611e                              cmp     #1, r14
FFF282DB  200e                              beq.b   loc_FFF282E9
FFF282DD  a889                              mov.l   24h+var_18[sp], r1
FFF282DF  591e6c                            movu.b  6Ch[r1], r14
FFF282E2  752e10                            and     #10h, r14
FFF282E5  755e10                            cmp     #10h, r14
FFF282E8  1d                                bne.s   loc_FFF282ED
FFF282E9  f80601                 loc_FFF282E9 mov.l   #1, 24h+var_24[sp]
FFF282EC  0c                                bra.s   loc_FFF282F0
FFF282ED  f80600                 loc_FFF282ED mov.l   #0, 24h+var_24[sp]
FFF282F0  ec01                   loc_FFF282F0 mov.l   24h+var_24[sp], r1
FFF282F2  6101                              cmp     #0, r1
FFF282F4  2035                              beq.b   loc_FFF28329
FFF282F6  a889                              mov.l   24h+var_18[sp], r1
FFF282F8  05ebdafe                          bsr.a   sub_FFF15DE3
FFF282FC  a101                              mov.l   r1, 24h+var_14[sp]
FFF282FE  a901                              mov.l   24h+var_14[sp], r1
FFF28300  6101                              cmp     #0, r1
FFF28302  2010                              beq.b   loc_FFF28312
FFF28304  6602                              mov.l   #0, r2
FFF28306  fb16c1                            mov.l   #-3Fh, r1
FFF28309  05176bff                          bsr.a   sub_FFF1EE20
FFF2830D  a009                              mov.l   r1, 24h+var_20[sp]
FFF2830F  388200                            bra.w   loc_FFF28391
FFF28312  a984                   loc_FFF28312 mov.l   24h+var_C[sp], r4
FFF28314  a98b                              mov.l   24h+var_8[sp], r3
FFF28316  72410c10                          add     #100Ch, r4, r1
FFF2831A  6602                              mov.l   #0, r2
FFF2831C  39b5f6                            bsr.w   sub_FFF279D1
FFF2831F  a101                              mov.l   r1, 24h+var_14[sp]
FFF28321  a889                              mov.l   24h+var_18[sp], r1
FFF28323  05cbdafe                          bsr.a   sub_FFF15DEE
FFF28327  2e11                              bra.b   loc_FFF28338
FFF28329  a984                   loc_FFF28329 mov.l   24h+var_C[sp], r4
FFF2832B  a98b                              mov.l   24h+var_8[sp], r3
FFF2832D  72410c10                          add     #100Ch, r4, r1
FFF28331  6602                              mov.l   #0, r2
FFF28333  399ef6                            bsr.w   sub_FFF279D1
FFF28336  a101                              mov.l   r1, 24h+var_14[sp]
FFF28338  a901                   loc_FFF28338 mov.l   24h+var_14[sp], r1
FFF2833A  6101                              cmp     #0, r1
FFF2833C  200e                              beq.b   loc_FFF2834A
FFF2833E  a901                              mov.l   24h+var_14[sp], r1
FFF28340  6602                              mov.l   #0, r2
FFF28342  05de6aff                          bsr.a   sub_FFF1EE20
FFF28346  a009                              mov.l   r1, 24h+var_20[sp]
FFF28348  2e49                              bra.b   loc_FFF28391
FFF2834A  a889                   loc_FFF2834A mov.l   24h+var_18[sp], r1
FFF2834C  059048ff                          bsr.a   sub_FFF1CBDC
FFF28350  a101                              mov.l   r1, 24h+var_14[sp]
FFF28352  a901                              mov.l   24h+var_14[sp], r1
FFF28354  6101                              cmp     #0, r1
FFF28356  200e                              beq.b   loc_FFF28364
FFF28358  a901                              mov.l   24h+var_14[sp], r1
FFF2835A  6602                              mov.l   #0, r2
FFF2835C  05c46aff                          bsr.a   sub_FFF1EE20
FFF28360  a009                              mov.l   r1, 24h+var_20[sp]
FFF28362  2e2f                              bra.b   loc_FFF28391
FFF28364  a889                   loc_FFF28364 mov.l   24h+var_18[sp], r1
FFF28366  591e6c                            movu.b  6Ch[r1], r14
FFF28369  752e10                            and     #10h, r14
FFF2836C  755e10                            cmp     #10h, r14
FFF2836F  2118                              bne.b   loc_FFF28387
FFF28371  a984                              mov.l   24h+var_C[sp], r4
FFF28373  5a433216                          movu.b  1632h[r4], r3
FFF28377  5a423116                          movu.b  1631h[r4], r2
FFF2837B  a889                              mov.l   24h+var_18[sp], r1
FFF2837D  72440c06                          add     #60Ch, r4, r4
FFF28381  05dbe0ff                          bsr.a   sub_FFF2645C
FFF28385  a101                              mov.l   r1, 24h+var_14[sp]
FFF28387  a901                   loc_FFF28387 mov.l   24h+var_14[sp], r1
FFF28389  6602                              mov.l   #0, r2
FFF2838B  05956aff                          bsr.a   sub_FFF1EE20
FFF2838F  a009                              mov.l   r1, 24h+var_20[sp]
FFF28391  a809                   loc_FFF28391 mov.l   24h+var_20[sp], r1
FFF28393  a109                              mov.l   r1, 24h+var_10[sp]
FFF28395  3f670b                            rtsd    #2Ch, r6-r7
FFF28398  7100e8                 sub_FFF28398 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF28398
FFF2839B  a109                              mov.l   r1, 18h+var_4[sp]
FFF2839D  a919                              mov.l   14h[r1], r1
FFF2839F  72116c07                          add     #76Ch, r1, r1
FFF283A3  a089                              mov.l   r1, 18h+var_C[sp]
FFF283A5  a889                              mov.l   18h+var_C[sp], r1
FFF283A7  ef1e                              mov.l   r1, r14
FFF283A9  fd748e04                          div     #4, r14
FFF283AD  6c2e                              shll    #2, r14
FFF283AF  43e1                              sub     r14, r1
FFF283B1  6101                              cmp     #0, r1
FFF283B3  2116                              bne.b   loc_FFF283C9
FFF283B5  a889                              mov.l   18h+var_C[sp], r1
FFF283B7  ef1e                              mov.l   r1, r14
FFF283B9  fd748e64                          div     #64h, r14 ; 'd'
FFF283BD  751e64                            mul     #64h, r14 ; 'd'
FFF283C0  43e1                              sub     r14, r1
FFF283C2  6101                              cmp     #0, r1
FFF283C4  15                                beq.s   loc_FFF283C9
FFF283C5  f80601                            mov.l   #1, 18h+var_18[sp]
FFF283C8  0c                                bra.s   loc_FFF283CC
FFF283C9  f80600                 loc_FFF283C9 mov.l   #0, 18h+var_18[sp]
FFF283CC  ec01                   loc_FFF283CC mov.l   18h+var_18[sp], r1
FFF283CE  6101                              cmp     #0, r1
FFF283D0  2114                              bne.b   loc_FFF283E4
FFF283D2  a889                              mov.l   18h+var_C[sp], r1
FFF283D4  ef1e                              mov.l   r1, r14
FFF283D6  fd788e9001                        div     #190h, r14
FFF283DB  761e9001                          mul     #190h, r14
FFF283DF  43e1                              sub     r14, r1
FFF283E1  6101                              cmp     #0, r1
FFF283E3  1d                                bne.s   loc_FFF283E8
FFF283E4  f80601                 loc_FFF283E4 mov.l   #1, 18h+var_18[sp]
FFF283E7  0c                                bra.s   loc_FFF283EB
FFF283E8  f80600                 loc_FFF283E8 mov.l   #0, 18h+var_18[sp]
FFF283EB  e40002                 loc_FFF283EB mov.l   18h+var_18[sp], 18h+var_10[sp]
FFF283EE  a909                              mov.l   18h+var_4[sp], r1
FFF283F0  a919                              mov.l   14h[r1], r1
FFF283F2  6101                              cmp     #0, r1
FFF283F4  270b                              bn.b    loc_FFF283FF
FFF283F6  a909                              mov.l   18h+var_4[sp], r1
FFF283F8  a919                              mov.l   14h[r1], r1
FFF283FA  7551d0                            cmp     #-30h, r1
FFF283FD  2906                              blt.b   loc_FFF28403
FFF283FF  f80601                 loc_FFF283FF mov.l   #1, 18h+var_18[sp]
FFF28402  0c                                bra.s   loc_FFF28406
FFF28403  f80600                 loc_FFF28403 mov.l   #0, 18h+var_18[sp]
FFF28406  ec01                   loc_FFF28406 mov.l   18h+var_18[sp], r1
FFF28408  6101                              cmp     #0, r1
FFF2840A  10                                beq.s   loc_FFF28412
FFF2840B  f906019d                          mov.l   #-63h, 18h+var_14[sp]
FFF2840F  38c500                            bra.w   loc_FFF284D4
FFF28412  a909                   loc_FFF28412 mov.l   18h+var_4[sp], r1
FFF28414  a911                              mov.l   10h[r1], r1
FFF28416  6101                              cmp     #0, r1
FFF28418  270a                              bn.b    loc_FFF28422
FFF2841A  a909                              mov.l   18h+var_4[sp], r1
FFF2841C  a911                              mov.l   10h[r1], r1
FFF2841E  61c1                              cmp     #0Ch, r1
FFF28420  2906                              blt.b   loc_FFF28426
FFF28422  f80601                 loc_FFF28422 mov.l   #1, 18h+var_18[sp]
FFF28425  0c                                bra.s   loc_FFF28429
FFF28426  f80600                 loc_FFF28426 mov.l   #0, 18h+var_18[sp]
FFF28429  ec01                   loc_FFF28429 mov.l   18h+var_18[sp], r1
FFF2842B  6101                              cmp     #0, r1
FFF2842D  10                                beq.s   loc_FFF28435
FFF2842E  f906019d                          mov.l   #-63h, 18h+var_14[sp]
FFF28432  38a200                            bra.w   loc_FFF284D4
FFF28435  a909                   loc_FFF28435 mov.l   18h+var_4[sp], r1
FFF28437  a899                              mov.l   0Ch[r1], r1
FFF28439  6101                              cmp     #0, r1
FFF2843B  2b1c                              ble.b   loc_FFF28457
FFF2843D  a881                              mov.l   18h+var_10[sp], r1
FFF2843F  751130                            mul     #30h, r1 ; '0'
FFF28442  fbe2d8940600                      mov.l   #694D8h, r14
FFF28448  4b1e                              add     r1, r14
FFF2844A  a909                              mov.l   18h+var_4[sp], r1
FFF2844C  a912                              mov.l   10h[r1], r2
FFF2844E  fe62ee                            mov.l   [r2, r14], r14
FFF28451  a899                              mov.l   0Ch[r1], r1
FFF28453  47e1                              cmp     r14, r1
FFF28455  2b06                              ble.b   loc_FFF2845B
FFF28457  f80601                 loc_FFF28457 mov.l   #1, 18h+var_18[sp]
FFF2845A  0c                                bra.s   loc_FFF2845E
FFF2845B  f80600                 loc_FFF2845B mov.l   #0, 18h+var_18[sp]
FFF2845E  ec01                   loc_FFF2845E mov.l   18h+var_18[sp], r1
FFF28460  6101                              cmp     #0, r1
FFF28462  17                                beq.s   loc_FFF28469
FFF28463  f906019d                          mov.l   #-63h, 18h+var_14[sp]
FFF28467  2e6d                              bra.b   loc_FFF284D4
FFF28469  a909                   loc_FFF28469 mov.l   18h+var_4[sp], r1
FFF2846B  a891                              mov.l   8[r1], r1
FFF2846D  6101                              cmp     #0, r1
FFF2846F  270b                              bn.b    loc_FFF2847A
FFF28471  a909                              mov.l   18h+var_4[sp], r1
FFF28473  a891                              mov.l   8[r1], r1
FFF28475  755118                            cmp     #18h, r1
FFF28478  2906                              blt.b   loc_FFF2847E
FFF2847A  f80601                 loc_FFF2847A mov.l   #1, 18h+var_18[sp]
FFF2847D  0c                                bra.s   loc_FFF28481
FFF2847E  f80600                 loc_FFF2847E mov.l   #0, 18h+var_18[sp]
FFF28481  ec01                   loc_FFF28481 mov.l   18h+var_18[sp], r1
FFF28483  6101                              cmp     #0, r1
FFF28485  17                                beq.s   loc_FFF2848C
FFF28486  f906019d                          mov.l   #-63h, 18h+var_14[sp]
FFF2848A  2e4a                              bra.b   loc_FFF284D4
FFF2848C  a909                   loc_FFF2848C mov.l   18h+var_4[sp], r1
FFF2848E  a819                              mov.l   4[r1], r1
FFF28490  6101                              cmp     #0, r1
FFF28492  270b                              bn.b    loc_FFF2849D
FFF28494  a909                              mov.l   18h+var_4[sp], r1
FFF28496  a819                              mov.l   4[r1], r1
FFF28498  75513c                            cmp     #3Ch, r1 ; '<'
FFF2849B  2906                              blt.b   loc_FFF284A1
FFF2849D  f80601                 loc_FFF2849D mov.l   #1, 18h+var_18[sp]
FFF284A0  0c                                bra.s   loc_FFF284A4
FFF284A1  f80600                 loc_FFF284A1 mov.l   #0, 18h+var_18[sp]
FFF284A4  ec01                   loc_FFF284A4 mov.l   18h+var_18[sp], r1
FFF284A6  6101                              cmp     #0, r1
FFF284A8  17                                beq.s   loc_FFF284AF
FFF284A9  f906019d                          mov.l   #-63h, 18h+var_14[sp]
FFF284AD  2e27                              bra.b   loc_FFF284D4
FFF284AF  a909                   loc_FFF284AF mov.l   18h+var_4[sp], r1
FFF284B1  ec1e                              mov.l   [r1], r14
FFF284B3  610e                              cmp     #0, r14
FFF284B5  270b                              bn.b    loc_FFF284C0
FFF284B7  a909                              mov.l   18h+var_4[sp], r1
FFF284B9  ec1e                              mov.l   [r1], r14
FFF284BB  755e3c                            cmp     #3Ch, r14 ; '<'
FFF284BE  2906                              blt.b   loc_FFF284C4
FFF284C0  f80601                 loc_FFF284C0 mov.l   #1, 18h+var_18[sp]
FFF284C3  0c                                bra.s   loc_FFF284C7
FFF284C4  f80600                 loc_FFF284C4 mov.l   #0, 18h+var_18[sp]
FFF284C7  ec01                   loc_FFF284C7 mov.l   18h+var_18[sp], r1
FFF284C9  6101                              cmp     #0, r1
FFF284CB  16                                beq.s   loc_FFF284D1
FFF284CC  f906019d                          mov.l   #-63h, 18h+var_14[sp]
FFF284D0  0c                                bra.s   loc_FFF284D4
FFF284D1  3e0100                 loc_FFF284D1 mov.l   #0, 18h+var_14[sp]
FFF284D4  a809                   loc_FFF284D4 mov.l   18h+var_14[sp], r1
FFF284D6  a101                              mov.l   r1, 18h+var_8[sp]
FFF284D8  6706                              rtsd    #6
FFF284DA  7100b4                 sub_FFF284DA add     #-4Ch, sp, sp   ; <<<< FUNC sub_FFF284DA
FFF284DD  a481                              mov.l   r1, 4Ch+var_4[sp]
FFF284DF  a40a                              mov.l   r2, 4Ch+var_8[sp]
FFF284E1  6102                              cmp     #0, r2
FFF284E3  210f                              bne.b   loc_FFF284F2
FFF284E5  6602                              mov.l   #0, r2
FFF284E7  fb16f3                            mov.l   #-0Dh, r1
FFF284EA  053669ff                          bsr.a   sub_FFF1EE20
FFF284EE  e301                              mov.l   r1, 4Ch+var_4C[sp]
FFF284F0  2e2c                              bra.b   loc_FFF2851C
FFF284F2  ac81                   loc_FFF284F2 mov.l   4Ch+var_4[sp], r1
FFF284F4  710204                            add     #4Ch+var_48, sp, r2
FFF284F7  39a5f0                            bsr.w   sub_FFF2759C
FFF284FA  a389                              mov.l   r1, 4Ch+var_10[sp]
FFF284FC  ab89                              mov.l   4Ch+var_10[sp], r1
FFF284FE  6101                              cmp     #0, r1
FFF28500  16                                beq.s   loc_FFF28506
FFF28501  e1000f                            mov.l   4Ch+var_10[sp], 4Ch+var_4C[sp]
FFF28504  2e18                              bra.b   loc_FFF2851C
FFF28506  ac09                   loc_FFF28506 mov.l   4Ch+var_8[sp], r1
FFF28508  754324                            mov.l   #24h, r3 ; '$'
FFF2850B  710210                            add     #4Ch+var_3C, sp, r2
FFF2850E  056a5f00                          bsr.a   sub_FFF2E478
FFF28512  6601                              mov.l   #0, r1
FFF28514  ef12                              mov.l   r1, r2
FFF28516  050a69ff                          bsr.a   sub_FFF1EE20
FFF2851A  e301                              mov.l   r1, 4Ch+var_4C[sp]
FFF2851C  ec01                   loc_FFF2851C mov.l   4Ch+var_4C[sp], r1
FFF2851E  a401                              mov.l   r1, 4Ch+var_C[sp]
FFF28520  6713                              rtsd    #13h
FFF28522  7100e8                 sub_FFF28522 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF28522
FFF28525  a109                              mov.l   r1, 18h+var_4[sp]
FFF28527  a102                              mov.l   r2, 18h+var_8[sp]
FFF28529  056dd9fe                          bsr.a   sub_FFF15E96
FFF2852D  a009                              mov.l   r1, 18h+var_14[sp]
FFF2852F  a809                              mov.l   18h+var_14[sp], r1
FFF28531  6101                              cmp     #0, r1
FFF28533  210f                              bne.b   loc_FFF28542
FFF28535  6602                              mov.l   #0, r2
FFF28537  fb16e1                            mov.l   #-1Fh, r1
FFF2853A  05e668ff                          bsr.a   sub_FFF1EE20
FFF2853E  e301                              mov.l   r1, 18h+var_18[sp]
FFF28540  2e16                              bra.b   loc_FFF28556
FFF28542  a80b                   loc_FFF28542 mov.l   18h+var_14[sp], r3
FFF28544  a902                              mov.l   18h+var_8[sp], r2
FFF28546  a909                              mov.l   18h+var_4[sp], r1
FFF28548  391400                            bsr.w   sub_FFF2855C
FFF2854B  a081                              mov.l   r1, 18h+var_10[sp]
FFF2854D  a809                              mov.l   18h+var_14[sp], r1
FFF2854F  0557d9fe                          bsr.a   sub_FFF15EA6
FFF28553  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF28556  ec01                   loc_FFF28556 mov.l   18h+var_18[sp], r1
FFF28558  a089                              mov.l   r1, 18h+var_C[sp]
FFF2855A  6706                              rtsd    #6
FFF2855C  7100e4                 sub_FFF2855C add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2855C
FFF2855F  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF28561  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF28563  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF28565  e5000601                          mov.l   1Ch+var_4[sp], 1Ch+var_18[sp]
FFF28569  0582caff                          bsr.a   sub_FFF24FEB
FFF2856D  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2856F  a881                              mov.l   1Ch+var_14[sp], r1
FFF28571  6101                              cmp     #0, r1
FFF28573  200f                              beq.b   loc_FFF28582
FFF28575  a881                              mov.l   1Ch+var_14[sp], r1
FFF28577  6602                              mov.l   #0, r2
FFF28579  05a768ff                          bsr.a   sub_FFF1EE20
FFF2857D  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2857F  388c00                            bra.w   loc_FFF2860B
FFF28582  a809                   loc_FFF28582 mov.l   1Ch+var_18[sp], r1
FFF28584  051269ff                          bsr.a   sub_FFF1EE96
FFF28588  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2858A  a881                              mov.l   1Ch+var_14[sp], r1
FFF2858C  6101                              cmp     #0, r1
FFF2858E  200e                              beq.b   loc_FFF2859C
FFF28590  a881                              mov.l   1Ch+var_14[sp], r1
FFF28592  6602                              mov.l   #0, r2
FFF28594  058c68ff                          bsr.a   sub_FFF1EE20
FFF28598  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2859A  2e71                              bra.b   loc_FFF2860B
FFF2859C  a809                   loc_FFF2859C mov.l   1Ch+var_18[sp], r1
FFF2859E  ce1e4204                          mov.b   442h[r1], r14
FFF285A2  611e                              cmp     #1, r14
FFF285A4  210f                              bne.b   loc_FFF285B3
FFF285A6  a80a                              mov.l   1Ch+var_18[sp], r2
FFF285A8  fb16fb                            mov.l   #-5, r1
FFF285AB  057568ff                          bsr.a   sub_FFF1EE20
FFF285AF  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF285B1  2e5a                              bra.b   loc_FFF2860B
FFF285B3  a909                   loc_FFF285B3 mov.l   1Ch+var_8[sp], r1
FFF285B5  6101                              cmp     #0, r1
FFF285B7  210f                              bne.b   loc_FFF285C6
FFF285B9  a80a                              mov.l   1Ch+var_18[sp], r2
FFF285BB  fb16f3                            mov.l   #-0Dh, r1
FFF285BE  056268ff                          bsr.a   sub_FFF1EE20
FFF285C2  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF285C4  2e47                              bra.b   loc_FFF2860B
FFF285C6  a909                   loc_FFF285C6 mov.l   1Ch+var_8[sp], r1
FFF285C8  39d0fd                            bsr.w   sub_FFF28398
FFF285CB  6101                              cmp     #0, r1
FFF285CD  a80a                              mov.l   1Ch+var_18[sp], r2
FFF285CF  200d                              beq.b   loc_FFF285DC
FFF285D1  fb16f3                            mov.l   #-0Dh, r1
FFF285D4  054c68ff                          bsr.a   sub_FFF1EE20
FFF285D8  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF285DA  2e31                              bra.b   loc_FFF2860B
FFF285DC  ec21                   loc_FFF285DC mov.l   [r2], r1
FFF285DE  05b369ff                          bsr.a   sub_FFF1EF91
FFF285E2  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF285E4  a881                              mov.l   1Ch+var_14[sp], r1
FFF285E6  6101                              cmp     #0, r1
FFF285E8  200e                              beq.b   loc_FFF285F6
FFF285EA  a80a                              mov.l   1Ch+var_18[sp], r2
FFF285EC  a881                              mov.l   1Ch+var_14[sp], r1
FFF285EE  053268ff                          bsr.a   sub_FFF1EE20
FFF285F2  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF285F4  2e17                              bra.b   loc_FFF2860B
FFF285F6  a903                   loc_FFF285F6 mov.l   1Ch+var_C[sp], r3
FFF285F8  a90a                              mov.l   1Ch+var_8[sp], r2
FFF285FA  a809                              mov.l   1Ch+var_18[sp], r1
FFF285FC  391500                            bsr.w   sub_FFF28611
FFF285FF  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF28601  a80a                              mov.l   1Ch+var_18[sp], r2
FFF28603  a881                              mov.l   1Ch+var_14[sp], r1
FFF28605  051b68ff                          bsr.a   sub_FFF1EE20
FFF28609  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2860B  ec01                   loc_FFF2860B mov.l   1Ch+var_1C[sp], r1
FFF2860D  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2860F  6707                              rtsd    #7
FFF28611  7100ec                 sub_FFF28611 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF28611
FFF28614  a101                              mov.l   r1, 14h+var_4[sp]
FFF28616  a08a                              mov.l   r2, 14h+var_8[sp]
FFF28618  a083                              mov.l   r3, 14h+var_C[sp]
FFF2861A  a889                              mov.l   14h+var_8[sp], r1
FFF2861C  ec11                              mov.l   [r1], r1
FFF2861E  fd748102                          div     #2, r1
FFF28622  e301                              mov.l   r1, 14h+var_14[sp]
FFF28624  a889                              mov.l   14h+var_8[sp], r1
FFF28626  a819                              mov.l   4[r1], r1
FFF28628  6c51                              shll    #5, r1
FFF2862A  069401                            or      [sp].l, r1
FFF2862D  e301                              mov.l   r1, 14h+var_14[sp]
FFF2862F  a889                              mov.l   14h+var_8[sp], r1
FFF28631  a891                              mov.l   8[r1], r1
FFF28633  6cb1                              shll    #0Bh, r1
FFF28635  069401                            or      [sp].l, r1
FFF28638  e301                              mov.l   r1, 14h+var_14[sp]
FFF2863A  ec01                              mov.l   14h+var_14[sp], r1
FFF2863C  a902                              mov.l   14h+var_4[sp], r2
FFF2863E  db211a01                          mov.w   r1, 234h[r2]
FFF28642  a889                              mov.l   14h+var_8[sp], r1
FFF28644  e11003                            mov.l   0Ch[r1], 14h+var_14[sp]
FFF28647  a889                              mov.l   14h+var_8[sp], r1
FFF28649  a911                              mov.l   10h[r1], r1
FFF2864B  6211                              add     #1, r1
FFF2864D  6c51                              shll    #5, r1
FFF2864F  069401                            or      [sp].l, r1
FFF28652  e301                              mov.l   r1, 14h+var_14[sp]
FFF28654  a889                              mov.l   14h+var_8[sp], r1
FFF28656  a919                              mov.l   14h[r1], r1
FFF28658  755150                            cmp     #50h, r1 ; 'P'
FFF2865B  2910                              blt.b   loc_FFF2866B
FFF2865D  a889                              mov.l   14h+var_8[sp], r1
FFF2865F  a919                              mov.l   14h[r1], r1
FFF28661  7111b0                            add     #-50h, r1, r1
FFF28664  6c91                              shll    #9, r1
FFF28666  069401                            or      [sp].l, r1
FFF28669  e301                              mov.l   r1, 14h+var_14[sp]
FFF2866B  ec01                   loc_FFF2866B mov.l   14h+var_14[sp], r1
FFF2866D  a902                              mov.l   14h+var_4[sp], r2
FFF2866F  db211b01                          mov.w   r1, 236h[r2]
FFF28673  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF28676  6601                              mov.l   #0, r1
FFF28678  6705                              rtsd    #5
FFF2867A  7100f0                 sub_FFF2867A add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2867A
FFF2867D  a089                              mov.l   r1, 10h+var_4[sp]
FFF2867F  a082                              mov.l   r2, 10h+var_8[sp]
FFF28681  a889                              mov.l   10h+var_4[sp], r1
FFF28683  390b00                            bsr.w   sub_FFF2868E
FFF28686  e301                              mov.l   r1, 10h+var_10[sp]
FFF28688  ec01                              mov.l   10h+var_10[sp], r1
FFF2868A  a009                              mov.l   r1, 10h+var_C[sp]
FFF2868C  6704                              rtsd    #4
FFF2868E  7100e8                 sub_FFF2868E add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2868E
FFF28691  a109                              mov.l   r1, 18h+var_4[sp]
FFF28693  a102                              mov.l   r2, 18h+var_8[sp]
FFF28695  e5000501                          mov.l   18h+var_4[sp], 18h+var_14[sp]
FFF28699  0552c9ff                          bsr.a   sub_FFF24FEB
FFF2869D  a081                              mov.l   r1, 18h+var_10[sp]
FFF2869F  a881                              mov.l   18h+var_10[sp], r1
FFF286A1  6101                              cmp     #0, r1
FFF286A3  200e                              beq.b   loc_FFF286B1
FFF286A5  a881                              mov.l   18h+var_10[sp], r1
FFF286A7  6602                              mov.l   #0, r2
FFF286A9  057767ff                          bsr.a   sub_FFF1EE20
FFF286AD  e301                              mov.l   r1, 18h+var_18[sp]
FFF286AF  2e44                              bra.b   loc_FFF286F3
FFF286B1  a809                   loc_FFF286B1 mov.l   18h+var_14[sp], r1
FFF286B3  05e367ff                          bsr.a   sub_FFF1EE96
FFF286B7  a081                              mov.l   r1, 18h+var_10[sp]
FFF286B9  a881                              mov.l   18h+var_10[sp], r1
FFF286BB  6101                              cmp     #0, r1
FFF286BD  200e                              beq.b   loc_FFF286CB
FFF286BF  a881                              mov.l   18h+var_10[sp], r1
FFF286C1  6602                              mov.l   #0, r2
FFF286C3  055d67ff                          bsr.a   sub_FFF1EE20
FFF286C7  e301                              mov.l   r1, 18h+var_18[sp]
FFF286C9  2e2a                              bra.b   loc_FFF286F3
FFF286CB  a901                   loc_FFF286CB mov.l   18h+var_8[sp], r1
FFF286CD  6101                              cmp     #0, r1
FFF286CF  a80a                              mov.l   18h+var_14[sp], r2
FFF286D1  210d                              bne.b   loc_FFF286DE
FFF286D3  fb16f3                            mov.l   #-0Dh, r1
FFF286D6  054a67ff                          bsr.a   sub_FFF1EE20
FFF286DA  e301                              mov.l   r1, 18h+var_18[sp]
FFF286DC  2e17                              bra.b   loc_FFF286F3
FFF286DE  a903                   loc_FFF286DE mov.l   18h+var_8[sp], r3
FFF286E0  ef21                              mov.l   r2, r1
FFF286E2  ef32                              mov.l   r3, r2
FFF286E4  391500                            bsr.w   sub_FFF286F9
FFF286E7  a081                              mov.l   r1, 18h+var_10[sp]
FFF286E9  a80a                              mov.l   18h+var_14[sp], r2
FFF286EB  a881                              mov.l   18h+var_10[sp], r1
FFF286ED  053367ff                          bsr.a   sub_FFF1EE20
FFF286F1  e301                              mov.l   r1, 18h+var_18[sp]
FFF286F3  ec01                   loc_FFF286F3 mov.l   18h+var_18[sp], r1
FFF286F5  a089                              mov.l   r1, 18h+var_C[sp]
FFF286F7  6706                              rtsd    #6
FFF286F9  60c0                   sub_FFF286F9 sub     #0Ch, sp   ; <<<< FUNC sub_FFF286F9
FFF286FB  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF286FD  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF286FF  a881                              mov.l   0Ch+var_4[sp], r1
FFF28701  5e1e1a01                          movu.w  234h[r1], r14
FFF28705  752e1f                            and     #1Fh, r14
FFF28708  6c1e                              shll    #1, r14
FFF2870A  e32e                              mov.l   r14, [r2]
FFF2870C  a881                              mov.l   0Ch+var_4[sp], r1
FFF2870E  de111a01                          mov.w   234h[r1], r1
FFF28712  6851                              shlr    #5, r1
FFF28714  75213f                            and     #3Fh, r1 ; '?'
FFF28717  a80a                              mov.l   0Ch+var_8[sp], r2
FFF28719  a029                              mov.l   r1, 4[r2]
FFF2871B  a881                              mov.l   0Ch+var_4[sp], r1
FFF2871D  5e111a01                          movu.w  234h[r1], r1
FFF28721  68b1                              shlr    #0Bh, r1
FFF28723  a80a                              mov.l   0Ch+var_8[sp], r2
FFF28725  a0a1                              mov.l   r1, 8[r2]
FFF28727  a881                              mov.l   0Ch+var_4[sp], r1
FFF28729  5e111b01                          movu.w  236h[r1], r1
FFF2872D  75211f                            and     #1Fh, r1
FFF28730  a80a                              mov.l   0Ch+var_8[sp], r2
FFF28732  a0a9                              mov.l   r1, 0Ch[r2]
FFF28734  a881                              mov.l   0Ch+var_4[sp], r1
FFF28736  de111b01                          mov.w   236h[r1], r1
FFF2873A  6851                              shlr    #5, r1
FFF2873C  64f1                              and     #0Fh, r1
FFF2873E  6011                              sub     #1, r1
FFF28740  a80a                              mov.l   0Ch+var_8[sp], r2
FFF28742  a121                              mov.l   r1, 10h[r2]
FFF28744  a881                              mov.l   0Ch+var_4[sp], r1
FFF28746  5e111b01                          movu.w  236h[r1], r1
FFF2874A  6891                              shlr    #9, r1
FFF2874C  711150                            add     #50h, r1, r1 ; 'P'
FFF2874F  a80a                              mov.l   0Ch+var_8[sp], r2
FFF28751  a129                              mov.l   r1, 14h[r2]
FFF28753  a809                              mov.l   0Ch+var_8[sp], r1
FFF28755  3e1600                            mov.l   #0, 18h[r1]
FFF28758  a809                              mov.l   0Ch+var_8[sp], r1
FFF2875A  3e1700                            mov.l   #0, 1Ch[r1]
FFF2875D  a809                              mov.l   0Ch+var_8[sp], r1
FFF2875F  3e1800                            mov.l   #0, 20h[r1]
FFF28762  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF28765  6601                              mov.l   #0, r1
FFF28767  6703                              rtsd    #3
FFF28769  7100e4                 sub_FFF28769 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF28769
FFF2876C  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2876E  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF28770  e5000601                          mov.l   1Ch+var_4[sp], 1Ch+var_18[sp]
FFF28774  0522d7fe                          bsr.a   sub_FFF15E96
FFF28778  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2877A  a881                              mov.l   1Ch+var_14[sp], r1
FFF2877C  6101                              cmp     #0, r1
FFF2877E  210f                              bne.b   loc_FFF2878D
FFF28780  6602                              mov.l   #0, r2
FFF28782  fb16e1                            mov.l   #-1Fh, r1
FFF28785  059b66ff                          bsr.a   sub_FFF1EE20
FFF28789  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2878B  2e1d                              bra.b   loc_FFF287A8
FFF2878D  a883                   loc_FFF2878D mov.l   1Ch+var_14[sp], r3
FFF2878F  a90a                              mov.l   1Ch+var_8[sp], r2
FFF28791  a809                              mov.l   1Ch+var_18[sp], r1
FFF28793  391b00                            bsr.w   sub_FFF287AE
FFF28796  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF28798  a881                              mov.l   1Ch+var_14[sp], r1
FFF2879A  050cd7fe                          bsr.a   sub_FFF15EA6
FFF2879E  a80a                              mov.l   1Ch+var_18[sp], r2
FFF287A0  a889                              mov.l   1Ch+var_10[sp], r1
FFF287A2  057e66ff                          bsr.a   sub_FFF1EE20
FFF287A6  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF287A8  ec01                   loc_FFF287A8 mov.l   1Ch+var_1C[sp], r1
FFF287AA  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF287AC  6707                              rtsd    #7
FFF287AE  7100e8                 sub_FFF287AE add     #-18h, sp, sp   ; <<<< FUNC sub_FFF287AE
FFF287B1  a109                              mov.l   r1, 18h+var_4[sp]
FFF287B3  a102                              mov.l   r2, 18h+var_8[sp]
FFF287B5  a08b                              mov.l   r3, 18h+var_C[sp]
FFF287B7  0534c8ff                          bsr.a   sub_FFF24FEB
FFF287BB  a009                              mov.l   r1, 18h+var_14[sp]
FFF287BD  a809                              mov.l   18h+var_14[sp], r1
FFF287BF  6101                              cmp     #0, r1
FFF287C1  16                                beq.s   loc_FFF287C7
FFF287C2  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF287C5  2e36                              bra.b   loc_FFF287FB
FFF287C7  a909                   loc_FFF287C7 mov.l   18h+var_4[sp], r1
FFF287C9  05cd66ff                          bsr.a   sub_FFF1EE96
FFF287CD  a009                              mov.l   r1, 18h+var_14[sp]
FFF287CF  a809                              mov.l   18h+var_14[sp], r1
FFF287D1  6101                              cmp     #0, r1
FFF287D3  16                                beq.s   loc_FFF287D9
FFF287D4  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF287D7  2e24                              bra.b   loc_FFF287FB
FFF287D9  a88b                   loc_FFF287D9 mov.l   18h+var_C[sp], r3
FFF287DB  a902                              mov.l   18h+var_8[sp], r2
FFF287DD  a909                              mov.l   18h+var_4[sp], r1
FFF287DF  392200                            bsr.w   sub_FFF28801
FFF287E2  a009                              mov.l   r1, 18h+var_14[sp]
FFF287E4  a809                              mov.l   18h+var_14[sp], r1
FFF287E6  6101                              cmp     #0, r1
FFF287E8  16                                beq.s   loc_FFF287EE
FFF287E9  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF287EC  2e0f                              bra.b   loc_FFF287FB
FFF287EE  a909                   loc_FFF287EE mov.l   18h+var_4[sp], r1
FFF287F0  ec11                              mov.l   [r1], r1
FFF287F2  05ea43ff                          bsr.a   sub_FFF1CBDC
FFF287F6  a009                              mov.l   r1, 18h+var_14[sp]
FFF287F8  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF287FB  ec01                   loc_FFF287FB mov.l   18h+var_18[sp], r1
FFF287FD  a081                              mov.l   r1, 18h+var_10[sp]
FFF287FF  6706                              rtsd    #6
FFF28801  7100e4                 sub_FFF28801 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF28801
FFF28804  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF28806  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF28808  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF2880A  a981                              mov.l   1Ch+var_4[sp], r1
FFF2880C  ec11                              mov.l   [r1], r1
FFF2880E  05dfd4fe                          bsr.a   sub_FFF15CED
FFF28812  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF28814  a809                              mov.l   1Ch+var_18[sp], r1
FFF28816  6101                              cmp     #0, r1
FFF28818  16                                beq.s   loc_FFF2881E
FFF28819  f806db                            mov.l   #-25h, 1Ch+var_1C[sp]
FFF2881C  2e18                              bra.b   loc_FFF28834
FFF2881E  a903                   loc_FFF2881E mov.l   1Ch+var_C[sp], r3
FFF28820  a90a                              mov.l   1Ch+var_8[sp], r2
FFF28822  a981                              mov.l   1Ch+var_4[sp], r1
FFF28824  391600                            bsr.w   sub_FFF2883A
FFF28827  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF28829  a981                              mov.l   1Ch+var_4[sp], r1
FFF2882B  ec11                              mov.l   [r1], r1
FFF2882D  05cbd4fe                          bsr.a   sub_FFF15CF8
FFF28831  e10002                            mov.l   1Ch+var_14[sp], 1Ch+var_1C[sp]
FFF28834  ec01                   loc_FFF28834 mov.l   1Ch+var_1C[sp], r1
FFF28836  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF28838  6707                              rtsd    #7
FFF2883A  7ea6                   sub_FFF2883A push.l  r6   ; <<<< FUNC sub_FFF2883A
FFF2883C  7100bc                            add     #-44h, sp, sp
FFF2883F  a401                              mov.l   r1, 44h+var_4[sp]
FFF28841  a38a                              mov.l   r2, 44h+var_8[sp]
FFF28843  a383                              mov.l   r3, 44h+var_C[sp]
FFF28845  3e0b00                            mov.l   #0, 44h+var_18[sp]
FFF28848  3e0a00                            mov.l   #0, 44h+var_1C[sp]
FFF2884B  ac01                              mov.l   44h+var_4[sp], r1
FFF2884D  ce1e4204                          mov.b   442h[r1], r14
FFF28851  611e                              cmp     #1, r14
FFF28853  18                                bne.s   loc_FFF2885B
FFF28854  f90601fb                          mov.l   #-5, 44h+var_40[sp]
FFF28858  387003                            bra.w   loc_FFF28BC8
FFF2885B  ac01                   loc_FFF2885B mov.l   44h+var_4[sp], r1
FFF2885D  ab8a                              mov.l   44h+var_8[sp], r2
FFF2885F  0685120b                          cmp     2Ch[r1].l, r2
FFF28863  202e                              beq.b   loc_FFF28891
FFF28865  ac01                              mov.l   44h+var_4[sp], r1
FFF28867  ec11                              mov.l   [r1], r1
FFF28869  05f466ff                          bsr.a   sub_FFF1EF5D
FFF2886D  a301                              mov.l   r1, 44h+var_14[sp]
FFF2886F  ab01                              mov.l   44h+var_14[sp], r1
FFF28871  6101                              cmp     #0, r1
FFF28873  10                                beq.s   loc_FFF2887B
FFF28874  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF28878  385003                            bra.w   loc_FFF28BC8
FFF2887B  ac01                   loc_FFF2887B mov.l   44h+var_4[sp], r1
FFF2887D  ec11                              mov.l   [r1], r1
FFF2887F  051267ff                          bsr.a   sub_FFF1EF91
FFF28883  a301                              mov.l   r1, 44h+var_14[sp]
FFF28885  ab01                              mov.l   44h+var_14[sp], r1
FFF28887  6101                              cmp     #0, r1
FFF28889  10                                beq.s   loc_FFF28891
FFF2888A  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF2888E  383a03                            bra.w   loc_FFF28BC8
FFF28891  ac01                   loc_FFF28891 mov.l   44h+var_4[sp], r1
FFF28893  ab8a                              mov.l   44h+var_8[sp], r2
FFF28895  0685120b                          cmp     2Ch[r1].l, r2
FFF28899  2405                              bgtu.b  loc_FFF2889E
FFF2889B  381c01                            bra.w   loc_FFF289B7
FFF2889E  ab81                   loc_FFF2889E mov.l   44h+var_C[sp], r1
FFF288A0  72110c06                          add     #60Ch, r1, r1
FFF288A4  fb3a0002                          mov.l   #200h, r3
FFF288A8  6602                              mov.l   #0, r2
FFF288AA  ef34                              mov.l   r3, r4
FFF288AC  05035c00                          bsr.a   sub_FFF2E4AF
FFF288B0  ac01                              mov.l   44h+var_4[sp], r1
FFF288B2  ab8a                              mov.l   44h+var_8[sp], r2
FFF288B4  0681120b                          sub     2Ch[r1].l, r2
FFF288B8  ec1e                              mov.l   [r1], r14
FFF288BA  06a109e217                        divu    5Ch[r14].l, r2
FFF288BF  a10a                              mov.l   r2, 44h+var_30[sp]
FFF288C1  ac01                              mov.l   44h+var_4[sp], r1
FFF288C3  aa9a                              mov.l   2Ch[r1], r2
FFF288C5  6102                              cmp     #0, r2
FFF288C7  214f                              bne.b   loc_FFF28916
FFF288C9  ec11                              mov.l   [r1], r1
FFF288CB  ab84                              mov.l   44h+var_C[sp], r4
FFF288CD  710308                            add     #44h+var_3C, sp, r3
FFF288D0  6602                              mov.l   #0, r2
FFF288D2  05ffbcff                          bsr.a   sub_FFF245D1
FFF288D6  a301                              mov.l   r1, 44h+var_14[sp]
FFF288D8  ab01                              mov.l   44h+var_14[sp], r1
FFF288DA  6101                              cmp     #0, r1
FFF288DC  10                                beq.s   loc_FFF288E4
FFF288DD  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF288E1  38e702                            bra.w   loc_FFF28BC8
FFF288E4  a881                   loc_FFF288E4 mov.l   44h+var_3C[sp], r1
FFF288E6  ac02                              mov.l   44h+var_4[sp], r2
FFF288E8  a1a9                              mov.l   r1, 1Ch[r2]
FFF288EA  ac01                              mov.l   44h+var_4[sp], r1
FFF288EC  a999                              mov.l   1Ch[r1], r1
FFF288EE  6101                              cmp     #0, r1
FFF288F0  18                                bne.s   loc_FFF288F8
FFF288F1  f90601f5                          mov.l   #-0Bh, 44h+var_40[sp]
FFF288F5  38d302                            bra.w   loc_FFF28BC8
FFF288F8  ac06                   loc_FFF288F8 mov.l   44h+var_4[sp], r6
FFF288FA  a9ea                              mov.l   1Ch[r6], r2
FFF288FC  ec61                              mov.l   [r6], r1
FFF288FE  05ae66ff                          bsr.a   sub_FFF1EFAC
FFF28902  a261                              mov.l   r1, 20h[r6]
FFF28904  ac02                              mov.l   44h+var_4[sp], r2
FFF28906  a829                              mov.l   4[r2], r1
FFF28908  ec22                              mov.l   [r2], r2
FFF2890A  adab                              mov.l   5Ch[r2], r3
FFF2890C  6602                              mov.l   #0, r2
FFF2890E  ef34                              mov.l   r3, r4
FFF28910  059f5b00                          bsr.a   sub_FFF2E4AF
FFF28914  2e1a                              bra.b   loc_FFF2892E
FFF28916  ab84                   loc_FFF28916 mov.l   44h+var_C[sp], r4
FFF28918  6623                              mov.l   #2, r3
FFF2891A  6602                              mov.l   #0, r2
FFF2891C  05f70aff                          bsr.a   sub_FFF19413
FFF28920  a301                              mov.l   r1, 44h+var_14[sp]
FFF28922  ab01                              mov.l   44h+var_14[sp], r1
FFF28924  6101                              cmp     #0, r1
FFF28926  10                                beq.s   loc_FFF2892E
FFF28927  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF2892B  389d02                            bra.w   loc_FFF28BC8
FFF2892E  3e0700                 loc_FFF2892E mov.l   #0, 44h+var_28[sp]
FFF28931  2e35                              bra.b   loc_FFF28966
FFF28933  ac04                   loc_FFF28933 mov.l   44h+var_4[sp], r4
FFF28935  ec41                              mov.l   [r4], r1
FFF28937  ad9b                              mov.l   5Ch[r1], r3
FFF28939  ab81                              mov.l   44h+var_C[sp], r1
FFF2893B  6040                              sub     #4, sp
FFF2893D  e301                              mov.l   r1, 48h+var_48[sp]
FFF2893F  72110c06                          add     #60Ch, r1, r1
FFF28943  6612                              mov.l   #1, r2
FFF28945  054800ff                          bsr.a   sub_FFF1898D
FFF28949  6240                              add     #4, sp
FFF2894B  a101                              mov.l   r1, 44h+var_34[sp]
FFF2894D  ac01                              mov.l   44h+var_4[sp], r1
FFF2894F  ec1e                              mov.l   [r1], r14
FFF28951  a901                              mov.l   44h+var_34[sp], r1
FFF28953  0685e117                          cmp     5Ch[r14].l, r1
FFF28957  11                                beq.s   loc_FFF28960
FFF28958  0581d3fe                          bsr.a   sub_FFF15CD9
FFF2895C  a289                              mov.l   r1, 44h+var_18[sp]
FFF2895E  2e10                              bra.b   loc_FFF2896E
FFF28960  a989                   loc_FFF28960 mov.l   44h+var_28[sp], r1
FFF28962  6211                              add     #1, r1
FFF28964  a189                              mov.l   r1, 44h+var_28[sp]
FFF28966  a989                   loc_FFF28966 mov.l   44h+var_28[sp], r1
FFF28968  06850105                          cmp     44h+var_30[sp].l, r1
FFF2896C  23c7                              bltu.b  loc_FFF28933
FFF2896E  aa89                   loc_FFF2896E mov.l   44h+var_18[sp], r1
FFF28970  6101                              cmp     #0, r1
FFF28972  213e                              bne.b   loc_FFF289B0
FFF28974  ac01                              mov.l   44h+var_4[sp], r1
FFF28976  ab8a                              mov.l   44h+var_8[sp], r2
FFF28978  0681120b                          sub     2Ch[r1].l, r2
FFF2897C  ec11                              mov.l   [r1], r1
FFF2897E  ad99                              mov.l   5Ch[r1], r1
FFF28980  ef2e                              mov.l   r2, r14
FFF28982  fc271e                            divu    r1, r14
FFF28985  4f1e                              mul     r1, r14
FFF28987  43e2                              sub     r14, r2
FFF28989  a08a                              mov.l   r2, 44h+var_38[sp]
FFF2898B  ab81                              mov.l   44h+var_C[sp], r1
FFF2898D  ac04                              mov.l   44h+var_4[sp], r4
FFF2898F  a88b                              mov.l   44h+var_38[sp], r3
FFF28991  6040                              sub     #4, sp
FFF28993  e301                              mov.l   r1, 48h+var_48[sp]
FFF28995  72110c06                          add     #60Ch, r1, r1
FFF28999  6612                              mov.l   #1, r2
FFF2899B  05f2fffe                          bsr.a   sub_FFF1898D
FFF2899F  6240                              add     #4, sp
FFF289A1  a101                              mov.l   r1, 44h+var_34[sp]
FFF289A3  a901                              mov.l   44h+var_34[sp], r1
FFF289A5  06850103                          cmp     44h+var_38[sp].l, r1
FFF289A9  17                                beq.s   loc_FFF289B0
FFF289AA  052fd3fe                          bsr.a   sub_FFF15CD9
FFF289AE  a289                              mov.l   r1, 44h+var_18[sp]
FFF289B0  e5000b01               loc_FFF289B0 mov.l   44h+var_18[sp], 44h+var_40[sp]
FFF289B4  381402                            bra.w   loc_FFF28BC8
FFF289B7  ac01                   loc_FFF289B7 mov.l   44h+var_4[sp], r1
FFF289B9  aa99                              mov.l   2Ch[r1], r1
FFF289BB  0685010f                          cmp     44h+var_8[sp].l, r1
FFF289BF  2405                              bgtu.b  loc_FFF289C4
FFF289C1  380402                            bra.w   loc_FFF28BC5
FFF289C4  ac01                   loc_FFF289C4 mov.l   44h+var_4[sp], r1
FFF289C6  aa91                              mov.l   28h[r1], r1
FFF289C8  0685010f                          cmp     44h+var_8[sp].l, r1
FFF289CC  255f                              bleu.b  loc_FFF28A2B
FFF289CE  ab89                              mov.l   44h+var_8[sp], r1
FFF289D0  6101                              cmp     #0, r1
FFF289D2  ac01                              mov.l   44h+var_4[sp], r1
FFF289D4  263f                              bpz.b   loc_FFF28A13
FFF289D6  ab84                              mov.l   44h+var_C[sp], r4
FFF289D8  6603                              mov.l   #0, r3
FFF289DA  fb22ffffff7f                      mov.l   #7FFFFFFFh, r2
FFF289E0  05330aff                          bsr.a   sub_FFF19413
FFF289E4  a301                              mov.l   r1, 44h+var_14[sp]
FFF289E6  ab01                              mov.l   44h+var_14[sp], r1
FFF289E8  6101                              cmp     #0, r1
FFF289EA  10                                beq.s   loc_FFF289F2
FFF289EB  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF289EF  38d901                            bra.w   loc_FFF28BC8
FFF289F2  ab84                   loc_FFF289F2 mov.l   44h+var_C[sp], r4
FFF289F4  ab8a                              mov.l   44h+var_8[sp], r2
FFF289F6  ac01                              mov.l   44h+var_4[sp], r1
FFF289F8  702201000080                      add     #-7FFFFFFFh, r2, r2
FFF289FE  6613                              mov.l   #1, r3
FFF28A00  05130aff                          bsr.a   sub_FFF19413
FFF28A04  a301                              mov.l   r1, 44h+var_14[sp]
FFF28A06  ab01                              mov.l   44h+var_14[sp], r1
FFF28A08  6101                              cmp     #0, r1
FFF28A0A  2021                              beq.b   loc_FFF28A2B
FFF28A0C  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF28A10  38b801                            bra.w   loc_FFF28BC8
FFF28A13  ab84                   loc_FFF28A13 mov.l   44h+var_C[sp], r4
FFF28A15  ab8a                              mov.l   44h+var_8[sp], r2
FFF28A17  6603                              mov.l   #0, r3
FFF28A19  05fa09ff                          bsr.a   sub_FFF19413
FFF28A1D  a301                              mov.l   r1, 44h+var_14[sp]
FFF28A1F  ab01                              mov.l   44h+var_14[sp], r1
FFF28A21  6101                              cmp     #0, r1
FFF28A23  10                                beq.s   loc_FFF28A2B
FFF28A24  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF28A28  38a001                            bra.w   loc_FFF28BC8
FFF28A2B  ab89                   loc_FFF28A2B mov.l   44h+var_8[sp], r1
FFF28A2D  6101                              cmp     #0, r1
FFF28A2F  2016                              beq.b   loc_FFF28A45
FFF28A31  ac01                              mov.l   44h+var_4[sp], r1
FFF28A33  ec11                              mov.l   [r1], r1
FFF28A35  ad9a                              mov.l   5Ch[r1], r2
FFF28A37  06cd1202                          mul     4[r1].uw, r2
FFF28A3B  ab89                              mov.l   44h+var_8[sp], r1
FFF28A3D  6011                              sub     #1, r1
FFF28A3F  fc2721                            divu    r2, r1
FFF28A42  a181                              mov.l   r1, 44h+var_2C[sp]
FFF28A44  0c                                bra.s   loc_FFF28A48
FFF28A45  3e0600                 loc_FFF28A45 mov.l   #0, 44h+var_2C[sp]
FFF28A48  ac01                   loc_FFF28A48 mov.l   44h+var_4[sp], r1
FFF28A4A  e5100709                          mov.l   1Ch[r1], 44h+var_20[sp]
FFF28A4E  3e0700                            mov.l   #0, 44h+var_28[sp]
FFF28A51  2e64                              bra.b   loc_FFF28AB5
FFF28A53  6080                   loc_FFF28A53 sub     #8, sp
FFF28A55  a00a                              mov.l   r2, 4Ch+var_48[sp]
FFF28A57  f80472                            mov.b   #72h, 4Ch+var_4C[sp] ; 'r'
FFF28A5A  6604                              mov.l   #0, r4
FFF28A5C  71022c                            add     #4Ch+var_20, sp, r2
FFF28A5F  05d0b8ff                          bsr.a   sub_FFF2432F
FFF28A63  6280                              add     #8, sp
FFF28A65  a301                              mov.l   r1, 44h+var_14[sp]
FFF28A67  ab02                              mov.l   44h+var_14[sp], r2
FFF28A69  6102                              cmp     #0, r2
FFF28A6B  10                                beq.s   loc_FFF28A73
FFF28A6C  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF28A70  385801                            bra.w   loc_FFF28BC8
FFF28A73  aa0a                   loc_FFF28A73 mov.l   44h+var_20[sp], r2
FFF28A75  7402f8ffff0f                      cmp     #0FFFFFF8h, r2
FFF28A7B  2310                              bltu.b  loc_FFF28A8B
FFF28A7D  aa0a                              mov.l   44h+var_20[sp], r2
FFF28A7F  7402ffffff0f                      cmp     #0FFFFFFFh, r2
FFF28A85  2406                              bgtu.b  loc_FFF28A8B
FFF28A87  f80601                            mov.l   #1, 44h+var_44[sp]
FFF28A8A  0c                                bra.s   loc_FFF28A8E
FFF28A8B  f80600                 loc_FFF28A8B mov.l   #0, 44h+var_44[sp]
FFF28A8E  ec02                   loc_FFF28A8E mov.l   44h+var_44[sp], r2
FFF28A90  6102                              cmp     #0, r2
FFF28A92  1a                                bne.s   loc_FFF28A9C
FFF28A93  aa0a                              mov.l   44h+var_20[sp], r2
FFF28A95  7402f7ffff0f                      cmp     #0FFFFFF7h, r2
FFF28A9B  1d                                bne.s   loc_FFF28AA0
FFF28A9C  f80601                 loc_FFF28A9C mov.l   #1, 44h+var_44[sp]
FFF28A9F  0c                                bra.s   loc_FFF28AA3
FFF28AA0  f80600                 loc_FFF28AA0 mov.l   #0, 44h+var_44[sp]
FFF28AA3  ec02                   loc_FFF28AA3 mov.l   44h+var_44[sp], r2
FFF28AA5  6102                              cmp     #0, r2
FFF28AA7  10                                beq.s   loc_FFF28AAF
FFF28AA8  f90601c3                          mov.l   #-3Dh, 44h+var_40[sp]
FFF28AAC  381c01                            bra.w   loc_FFF28BC8
FFF28AAF  a98a                   loc_FFF28AAF mov.l   44h+var_28[sp], r2
FFF28AB1  6212                              add     #1, r2
FFF28AB3  a18a                              mov.l   r2, 44h+var_28[sp]
FFF28AB5  a98a                   loc_FFF28AB5 mov.l   44h+var_28[sp], r2
FFF28AB7  06850206                          cmp     44h+var_2C[sp].l, r2
FFF28ABB  ac02                              mov.l   44h+var_4[sp], r2
FFF28ABD  ec21                              mov.l   [r2], r1
FFF28ABF  ab82                              mov.l   44h+var_C[sp], r2
FFF28AC1  aa0b                              mov.l   44h+var_20[sp], r3
FFF28AC3  2390                              bltu.b  loc_FFF28A53
FFF28AC5  6080                              sub     #8, sp
FFF28AC7  a00a                              mov.l   r2, 4Ch+var_48[sp]
FFF28AC9  f80472                            mov.b   #72h, 4Ch+var_4C[sp] ; 'r'
FFF28ACC  6604                              mov.l   #0, r4
FFF28ACE  710228                            add     #4Ch+var_24, sp, r2
FFF28AD1  055eb8ff                          bsr.a   sub_FFF2432F
FFF28AD5  6280                              add     #8, sp
FFF28AD7  a301                              mov.l   r1, 44h+var_14[sp]
FFF28AD9  ab01                              mov.l   44h+var_14[sp], r1
FFF28ADB  6101                              cmp     #0, r1
FFF28ADD  10                                beq.s   loc_FFF28AE5
FFF28ADE  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF28AE2  38e600                            bra.w   loc_FFF28BC8
FFF28AE5  ab89                   loc_FFF28AE5 mov.l   44h+var_8[sp], r1
FFF28AE7  6101                              cmp     #0, r1
FFF28AE9  ac01                              mov.l   44h+var_4[sp], r1
FFF28AEB  ec11                              mov.l   [r1], r1
FFF28AED  ab82                              mov.l   44h+var_C[sp], r2
FFF28AEF  aa0b                              mov.l   44h+var_20[sp], r3
FFF28AF1  201c                              beq.b   loc_FFF28B0D
FFF28AF3  6080                              sub     #8, sp
FFF28AF5  a00a                              mov.l   r2, 4Ch+var_48[sp]
FFF28AF7  f80477                            mov.b   #77h, 4Ch+var_4C[sp] ; 'w'
FFF28AFA  fb42ffffff0f                      mov.l   #0FFFFFFFh, r4
FFF28B00  710230                            add     #4Ch+var_1C, sp, r2
FFF28B03  052cb8ff                          bsr.a   sub_FFF2432F
FFF28B07  6280                              add     #8, sp
FFF28B09  a301                              mov.l   r1, 44h+var_14[sp]
FFF28B0B  2e44                              bra.b   loc_FFF28B4F
FFF28B0D  6080                   loc_FFF28B0D sub     #8, sp
FFF28B0F  a00a                              mov.l   r2, 4Ch+var_48[sp]
FFF28B11  f80477                            mov.b   #77h, 4Ch+var_4C[sp] ; 'w'
FFF28B14  6604                              mov.l   #0, r4
FFF28B16  710230                            add     #4Ch+var_1C, sp, r2
FFF28B19  0516b8ff                          bsr.a   sub_FFF2432F
FFF28B1D  6280                              add     #8, sp
FFF28B1F  a301                              mov.l   r1, 44h+var_14[sp]
FFF28B21  ac01                              mov.l   44h+var_4[sp], r1
FFF28B23  ec11                              mov.l   [r1], r1
FFF28B25  aa99                              mov.l   2Ch[r1], r1
FFF28B27  6101                              cmp     #0, r1
FFF28B29  19                                bne.s   loc_FFF28B32
FFF28B2A  ac01                              mov.l   44h+var_4[sp], r1
FFF28B2C  ec11                              mov.l   [r1], r1
FFF28B2E  e501090b                          mov.l   44h+var_20[sp], 2Ch[r1]
FFF28B32  ac01                   loc_FFF28B32 mov.l   44h+var_4[sp], r1
FFF28B34  3e1700                            mov.l   #0, 1Ch[r1]
FFF28B37  3e1800                            mov.l   #0, 20h[r1]
FFF28B3A  ac01                              mov.l   44h+var_4[sp], r1
FFF28B3C  ec11                              mov.l   [r1], r1
FFF28B3E  8c11                              mov.b   10h[r1], r1
FFF28B40  755120                            cmp     #20h, r1 ; ' '
FFF28B43  210c                              bne.b   loc_FFF28B4F
FFF28B45  ac01                              mov.l   44h+var_4[sp], r1
FFF28B47  ec11                              mov.l   [r1], r1
FFF28B49  ab9a                              mov.l   3Ch[r1], r2
FFF28B4B  6212                              add     #1, r2
FFF28B4D  a39a                              mov.l   r2, 3Ch[r1]
FFF28B4F  ab01                   loc_FFF28B4F mov.l   44h+var_14[sp], r1
FFF28B51  6101                              cmp     #0, r1
FFF28B53  17                                beq.s   loc_FFF28B5A
FFF28B54  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF28B58  2e70                              bra.b   loc_FFF28BC8
FFF28B5A  aa01                   loc_FFF28B5A mov.l   44h+var_24[sp], r1
FFF28B5C  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF28B62  12                                beq.s   loc_FFF28B6C
FFF28B63  aa81                              mov.l   44h+var_1C[sp], r1
FFF28B65  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF28B6B  1d                                bne.s   loc_FFF28B70
FFF28B6C  f80601                 loc_FFF28B6C mov.l   #1, 44h+var_44[sp]
FFF28B6F  0c                                bra.s   loc_FFF28B73
FFF28B70  f80600                 loc_FFF28B70 mov.l   #0, 44h+var_44[sp]
FFF28B73  ec01                   loc_FFF28B73 mov.l   44h+var_44[sp], r1
FFF28B75  6101                              cmp     #0, r1
FFF28B77  17                                beq.s   loc_FFF28B7E
FFF28B78  f90601c3                          mov.l   #-3Dh, 44h+var_40[sp]
FFF28B7C  2e4c                              bra.b   loc_FFF28BC8
FFF28B7E  aa01                   loc_FFF28B7E mov.l   44h+var_24[sp], r1
FFF28B80  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF28B86  230c                              bltu.b  loc_FFF28B92
FFF28B88  aa01                              mov.l   44h+var_24[sp], r1
FFF28B8A  740100000010                      cmp     #10000000h, r1
FFF28B90  2306                              bltu.b  loc_FFF28B96
FFF28B92  f80601                 loc_FFF28B92 mov.l   #1, 44h+var_44[sp]
FFF28B95  0c                                bra.s   loc_FFF28B99
FFF28B96  f80600                 loc_FFF28B96 mov.l   #0, 44h+var_44[sp]
FFF28B99  ec01                   loc_FFF28B99 mov.l   44h+var_44[sp], r1
FFF28B9B  6101                              cmp     #0, r1
FFF28B9D  201b                              beq.b   loc_FFF28BB8
FFF28B9F  ac01                              mov.l   44h+var_4[sp], r1
FFF28BA1  ec11                              mov.l   [r1], r1
FFF28BA3  ab83                              mov.l   44h+var_C[sp], r3
FFF28BA5  aa02                              mov.l   44h+var_24[sp], r2
FFF28BA7  059cb6ff                          bsr.a   sub_FFF24243
FFF28BAB  a301                              mov.l   r1, 44h+var_14[sp]
FFF28BAD  ab01                              mov.l   44h+var_14[sp], r1
FFF28BAF  6101                              cmp     #0, r1
FFF28BB1  17                                beq.s   loc_FFF28BB8
FFF28BB2  e5000c01                          mov.l   44h+var_14[sp], 44h+var_40[sp]
FFF28BB6  2e12                              bra.b   loc_FFF28BC8
FFF28BB8  ab89                   loc_FFF28BB8 mov.l   44h+var_8[sp], r1
FFF28BBA  ac02                              mov.l   44h+var_4[sp], r2
FFF28BBC  a2a9                              mov.l   r1, 2Ch[r2]
FFF28BBE  ac01                              mov.l   44h+var_4[sp], r1
FFF28BC0  fa15320201                        mov.w   #1, 464h[r1]
FFF28BC5  3e0100                 loc_FFF28BC5 mov.l   #0, 44h+var_40[sp]
FFF28BC8  a809                   loc_FFF28BC8 mov.l   44h+var_40[sp], r1
FFF28BCA  a309                              mov.l   r1, 44h+var_10[sp]
FFF28BCC  3f6612                            rtsd    #48h, r6-r6
FFF28BCF  7100f0                 sub_FFF28BCF add     #-10h, sp, sp   ; <<<< FUNC sub_FFF28BCF
FFF28BD2  a089                              mov.l   r1, 10h+var_4[sp]
FFF28BD4  a082                              mov.l   r2, 10h+var_8[sp]
FFF28BD6  a889                              mov.l   10h+var_4[sp], r1
FFF28BD8  390b00                            bsr.w   sub_FFF28BE3
FFF28BDB  e301                              mov.l   r1, 10h+var_10[sp]
FFF28BDD  ec01                              mov.l   10h+var_10[sp], r1
FFF28BDF  a009                              mov.l   r1, 10h+var_C[sp]
FFF28BE1  6704                              rtsd    #4
FFF28BE3  7100e8                 sub_FFF28BE3 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF28BE3
FFF28BE6  a109                              mov.l   r1, 18h+var_4[sp]
FFF28BE8  a102                              mov.l   r2, 18h+var_8[sp]
FFF28BEA  e5000501                          mov.l   18h+var_4[sp], 18h+var_14[sp]
FFF28BEE  05fdc3ff                          bsr.a   sub_FFF24FEB
FFF28BF2  a081                              mov.l   r1, 18h+var_10[sp]
FFF28BF4  a881                              mov.l   18h+var_10[sp], r1
FFF28BF6  6101                              cmp     #0, r1
FFF28BF8  200e                              beq.b   loc_FFF28C06
FFF28BFA  a881                              mov.l   18h+var_10[sp], r1
FFF28BFC  6602                              mov.l   #0, r2
FFF28BFE  052262ff                          bsr.a   sub_FFF1EE20
FFF28C02  e301                              mov.l   r1, 18h+var_18[sp]
FFF28C04  2e44                              bra.b   loc_FFF28C48
FFF28C06  a809                   loc_FFF28C06 mov.l   18h+var_14[sp], r1
FFF28C08  058e62ff                          bsr.a   sub_FFF1EE96
FFF28C0C  a081                              mov.l   r1, 18h+var_10[sp]
FFF28C0E  a881                              mov.l   18h+var_10[sp], r1
FFF28C10  6101                              cmp     #0, r1
FFF28C12  200e                              beq.b   loc_FFF28C20
FFF28C14  a881                              mov.l   18h+var_10[sp], r1
FFF28C16  6602                              mov.l   #0, r2
FFF28C18  050862ff                          bsr.a   sub_FFF1EE20
FFF28C1C  e301                              mov.l   r1, 18h+var_18[sp]
FFF28C1E  2e2a                              bra.b   loc_FFF28C48
FFF28C20  a901                   loc_FFF28C20 mov.l   18h+var_8[sp], r1
FFF28C22  6101                              cmp     #0, r1
FFF28C24  a80a                              mov.l   18h+var_14[sp], r2
FFF28C26  210d                              bne.b   loc_FFF28C33
FFF28C28  fb16f3                            mov.l   #-0Dh, r1
FFF28C2B  05f561ff                          bsr.a   sub_FFF1EE20
FFF28C2F  e301                              mov.l   r1, 18h+var_18[sp]
FFF28C31  2e17                              bra.b   loc_FFF28C48
FFF28C33  a903                   loc_FFF28C33 mov.l   18h+var_8[sp], r3
FFF28C35  ef21                              mov.l   r2, r1
FFF28C37  ef32                              mov.l   r3, r2
FFF28C39  391500                            bsr.w   sub_FFF28C4E
FFF28C3C  a081                              mov.l   r1, 18h+var_10[sp]
FFF28C3E  a80a                              mov.l   18h+var_14[sp], r2
FFF28C40  a881                              mov.l   18h+var_10[sp], r1
FFF28C42  05de61ff                          bsr.a   sub_FFF1EE20
FFF28C46  e301                              mov.l   r1, 18h+var_18[sp]
FFF28C48  ec01                   loc_FFF28C48 mov.l   18h+var_18[sp], r1
FFF28C4A  a089                              mov.l   r1, 18h+var_C[sp]
FFF28C4C  6706                              rtsd    #6
FFF28C4E  60c0                   sub_FFF28C4E sub     #0Ch, sp   ; <<<< FUNC sub_FFF28C4E
FFF28C50  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF28C52  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF28C54  a884                              mov.l   0Ch+var_4[sp], r4
FFF28C56  71442c                            add     #2Ch, r4, r4 ; ','
FFF28C59  6643                              mov.l   #4, r3
FFF28C5B  ef21                              mov.l   r2, r1
FFF28C5D  ef42                              mov.l   r4, r2
FFF28C5F  05195800                          bsr.a   sub_FFF2E478
FFF28C63  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF28C66  6601                              mov.l   #0, r1
FFF28C68  6703                              rtsd    #3
FFF28C6A  7100ec                 sub_FFF28C6A add     #-14h, sp, sp   ; <<<< FUNC sub_FFF28C6A
FFF28C6D  8489                              mov.b   r1, 14h+var_1[sp]
FFF28C6F  a08a                              mov.l   r2, 14h+var_8[sp]
FFF28C71  a083                              mov.l   r3, 14h+var_C[sp]
FFF28C73  a88a                              mov.l   14h+var_8[sp], r2
FFF28C75  8c89                              mov.b   14h+var_1[sp], r1
FFF28C77  390b00                            bsr.w   sub_FFF28C82
FFF28C7A  e301                              mov.l   r1, 14h+var_14[sp]
FFF28C7C  ec01                              mov.l   14h+var_14[sp], r1
FFF28C7E  a009                              mov.l   r1, 14h+var_10[sp]
FFF28C80  6705                              rtsd    #5
FFF28C82  7100dc                 sub_FFF28C82 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF28C82
FFF28C85  c70123                            mov.b   r1, 24h+var_1[sp]
FFF28C88  a18a                              mov.l   r2, 24h+var_8[sp]
FFF28C8A  a183                              mov.l   r3, 24h+var_C[sp]
FFF28C8C  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF28C92  e4e003                            mov.l   [r14], 24h+var_18[sp]
FFF28C95  0556c3ff                          bsr.a   sub_FFF24FEB
FFF28C99  a101                              mov.l   r1, 24h+var_14[sp]
FFF28C9B  a901                              mov.l   24h+var_14[sp], r1
FFF28C9D  6101                              cmp     #0, r1
FFF28C9F  200f                              beq.b   loc_FFF28CAE
FFF28CA1  a901                              mov.l   24h+var_14[sp], r1
FFF28CA3  6602                              mov.l   #0, r2
FFF28CA5  057b61ff                          bsr.a   sub_FFF1EE20
FFF28CA9  a009                              mov.l   r1, 24h+var_20[sp]
FFF28CAB  388100                            bra.w   loc_FFF28D2C
FFF28CAE  a989                   loc_FFF28CAE mov.l   24h+var_8[sp], r1
FFF28CB0  6101                              cmp     #0, r1
FFF28CB2  16                                beq.s   loc_FFF28CB8
FFF28CB3  a981                              mov.l   24h+var_C[sp], r1
FFF28CB5  6101                              cmp     #0, r1
FFF28CB7  1d                                bne.s   loc_FFF28CBC
FFF28CB8  f80601                 loc_FFF28CB8 mov.l   #1, 24h+var_24[sp]
FFF28CBB  0c                                bra.s   loc_FFF28CBF
FFF28CBC  f80600                 loc_FFF28CBC mov.l   #0, 24h+var_24[sp]
FFF28CBF  ec01                   loc_FFF28CBF mov.l   24h+var_24[sp], r1
FFF28CC1  6101                              cmp     #0, r1
FFF28CC3  200f                              beq.b   loc_FFF28CD2
FFF28CC5  6602                              mov.l   #0, r2
FFF28CC7  fb16f3                            mov.l   #-0Dh, r1
FFF28CCA  055661ff                          bsr.a   sub_FFF1EE20
FFF28CCE  a009                              mov.l   r1, 24h+var_20[sp]
FFF28CD0  2e5c                              bra.b   loc_FFF28D2C
FFF28CD2  cd0123                 loc_FFF28CD2 mov.b   24h+var_1[sp], r1
FFF28CD5  05b65a00                          bsr.a   sub_FFF2E78B
FFF28CD9  8289                              mov.b   r1, 24h+var_19[sp]
FFF28CDB  b289                              movu.b  24h+var_19[sp], r1
FFF28CDD  71020c                            add     #24h+var_18, sp, r2
FFF28CE0  053f62ff                          bsr.a   sub_FFF1EF1F
FFF28CE4  a101                              mov.l   r1, 24h+var_14[sp]
FFF28CE6  a901                              mov.l   24h+var_14[sp], r1
FFF28CE8  6101                              cmp     #0, r1
FFF28CEA  200e                              beq.b   loc_FFF28CF8
FFF28CEC  a901                              mov.l   24h+var_14[sp], r1
FFF28CEE  6602                              mov.l   #0, r2
FFF28CF0  053061ff                          bsr.a   sub_FFF1EE20
FFF28CF4  a009                              mov.l   r1, 24h+var_20[sp]
FFF28CF6  2e36                              bra.b   loc_FFF28D2C
FFF28CF8  a889                   loc_FFF28CF8 mov.l   24h+var_18[sp], r1
FFF28CFA  056362ff                          bsr.a   sub_FFF1EF5D
FFF28CFE  a101                              mov.l   r1, 24h+var_14[sp]
FFF28D00  a901                              mov.l   24h+var_14[sp], r1
FFF28D02  6101                              cmp     #0, r1
FFF28D04  200e                              beq.b   loc_FFF28D12
FFF28D06  a901                              mov.l   24h+var_14[sp], r1
FFF28D08  6602                              mov.l   #0, r2
FFF28D0A  051661ff                          bsr.a   sub_FFF1EE20
FFF28D0E  a009                              mov.l   r1, 24h+var_20[sp]
FFF28D10  2e1c                              bra.b   loc_FFF28D2C
FFF28D12  cd0123                 loc_FFF28D12 mov.b   24h+var_1[sp], r1
FFF28D15  05765a00                          bsr.a   sub_FFF2E78B
FFF28D19  a983                              mov.l   24h+var_C[sp], r3
FFF28D1B  a98a                              mov.l   24h+var_8[sp], r2
FFF28D1D  391500                            bsr.w   sub_FFF28D32
FFF28D20  a101                              mov.l   r1, 24h+var_14[sp]
FFF28D22  a901                              mov.l   24h+var_14[sp], r1
FFF28D24  6602                              mov.l   #0, r2
FFF28D26  05fa60ff                          bsr.a   sub_FFF1EE20
FFF28D2A  a009                              mov.l   r1, 24h+var_20[sp]
FFF28D2C  a809                   loc_FFF28D2C mov.l   24h+var_20[sp], r1
FFF28D2E  a109                              mov.l   r1, 24h+var_10[sp]
FFF28D30  6709                              rtsd    #9
FFF28D32  7ea6                   sub_FFF28D32 push.l  r6   ; <<<< FUNC sub_FFF28D32
FFF28D34  7100e0                            add     #-20h, sp, sp
FFF28D37  8789                              mov.b   r1, 20h+var_1[sp]
FFF28D39  a182                              mov.l   r2, 20h+var_8[sp]
FFF28D3B  a10b                              mov.l   r3, 20h+var_C[sp]
FFF28D3D  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF28D43  e4e003                            mov.l   [r14], 20h+var_14[sp]
FFF28D46  2e0f                              bra.b   loc_FFF28D55
FFF28D48  ec11                   loc_FFF28D48 mov.l   [r1], r1
FFF28D4A  a089                              mov.l   r1, 20h+var_14[sp]
FFF28D4C  6101                              cmp     #0, r1
FFF28D4E  1f                                bne.s   loc_FFF28D55
FFF28D4F  f806ef                            mov.l   #-11h, 20h+var_20[sp]
FFF28D52  38c900                            bra.w   loc_FFF28E1B
FFF28D55  a889                   loc_FFF28D55 mov.l   20h+var_14[sp], r1
FFF28D57  8c1e                              mov.b   11h[r1], r6
FFF28D59  8f89                              mov.b   20h+var_1[sp], r1
FFF28D5B  05305a00                          bsr.a   sub_FFF2E78B
FFF28D5F  4716                              cmp     r1, r6
FFF28D61  a889                              mov.l   20h+var_14[sp], r1
FFF28D63  21e5                              bne.b   loc_FFF28D48
FFF28D65  8c11                              mov.b   10h[r1], r1
FFF28D67  61c1                              cmp     #0Ch, r1
FFF28D69  a889                              mov.l   20h+var_14[sp], r1
FFF28D6B  2114                              bne.b   loc_FFF28D7F
FFF28D6D  ad99                              mov.l   5Ch[r1], r1
FFF28D6F  a88a                              mov.l   20h+var_14[sp], r2
FFF28D71  068d2103                          mul     0Ch[r2].l, r1
FFF28D75  6c11                              shll    #1, r1
FFF28D77  fd749103                          divu    #3, r1
FFF28D7B  a081                              mov.l   r1, 20h+var_18[sp]
FFF28D7D  2e32                              bra.b   loc_FFF28DAF
FFF28D7F  8c11                   loc_FFF28D7F mov.b   10h[r1], r1
FFF28D81  755110                            cmp     #10h, r1
FFF28D84  a889                              mov.l   20h+var_14[sp], r1
FFF28D86  2110                              bne.b   loc_FFF28D96
FFF28D88  ad99                              mov.l   5Ch[r1], r1
FFF28D8A  6811                              shlr    #1, r1
FFF28D8C  a88a                              mov.l   20h+var_14[sp], r2
FFF28D8E  068d2103                          mul     0Ch[r2].l, r1
FFF28D92  a081                              mov.l   r1, 20h+var_18[sp]
FFF28D94  2e1b                              bra.b   loc_FFF28DAF
FFF28D96  8c11                   loc_FFF28D96 mov.b   10h[r1], r1
FFF28D98  755120                            cmp     #20h, r1 ; ' '
FFF28D9B  210f                              bne.b   loc_FFF28DAA
FFF28D9D  a889                              mov.l   20h+var_14[sp], r1
FFF28D9F  ad9a                              mov.l   5Ch[r1], r2
FFF28DA1  6822                              shlr    #2, r2
FFF28DA3  068d1203                          mul     0Ch[r1].l, r2
FFF28DA7  a082                              mov.l   r2, 20h+var_18[sp]
FFF28DA9  0e                                bra.s   loc_FFF28DAF
FFF28DAA  f806f3                 loc_FFF28DAA mov.l   #-0Dh, 20h+var_20[sp]
FFF28DAD  2e6e                              bra.b   loc_FFF28E1B
FFF28DAF  a889                   loc_FFF28DAF mov.l   20h+var_14[sp], r1
FFF28DB1  a89a                              mov.l   0Ch[r1], r2
FFF28DB3  06cd1204                          mul     8[r1].uw, r2
FFF28DB7  06c91203                          add     6[r1].uw, r2
FFF28DBB  b91b                              movu.w  0Ah[r1], r3
FFF28DBD  6c53                              shll    #5, r3
FFF28DBF  06a1091317                        divu    5Ch[r1].l, r3
FFF28DC4  4b32                              add     r3, r2
FFF28DC6  a91b                              mov.l   14h[r1], r3
FFF28DC8  4323                              sub     r2, r3
FFF28DCA  06e1091302                        divu    4[r1].uw, r3
FFF28DCF  6223                              add     #2, r3
FFF28DD1  06850302                          cmp     20h+var_18[sp].l, r3
FFF28DD5  2226                              bgeu.b  loc_FFF28DFB
FFF28DD7  a889                              mov.l   20h+var_14[sp], r1
FFF28DD9  a89a                              mov.l   0Ch[r1], r2
FFF28DDB  06cd1204                          mul     8[r1].uw, r2
FFF28DDF  06c91203                          add     6[r1].uw, r2
FFF28DE3  b91b                              movu.w  0Ah[r1], r3
FFF28DE5  6c53                              shll    #5, r3
FFF28DE7  06a1091317                        divu    5Ch[r1].l, r3
FFF28DEC  4b32                              add     r3, r2
FFF28DEE  a91b                              mov.l   14h[r1], r3
FFF28DF0  4323                              sub     r2, r3
FFF28DF2  06e1091302                        divu    4[r1].uw, r3
FFF28DF7  6223                              add     #2, r3
FFF28DF9  a083                              mov.l   r3, 20h+var_18[sp]
FFF28DFB  a881                   loc_FFF28DFB mov.l   20h+var_18[sp], r1
FFF28DFD  6021                              sub     #2, r1
FFF28DFF  a081                              mov.l   r1, 20h+var_18[sp]
FFF28E01  a889                              mov.l   20h+var_14[sp], r1
FFF28E03  b891                              movu.w  4[r1], r1
FFF28E05  068d0102                          mul     20h+var_18[sp].l, r1
FFF28E09  a009                              mov.l   r1, 20h+var_1C[sp]
FFF28E0B  a889                              mov.l   20h+var_14[sp], r1
FFF28E0D  ad9c                              mov.l   5Ch[r1], r4
FFF28E0F  a90b                              mov.l   20h+var_C[sp], r3
FFF28E11  a982                              mov.l   20h+var_8[sp], r2
FFF28E13  a809                              mov.l   20h+var_1C[sp], r1
FFF28E15  394906                            bsr.w   sub_FFF2945E
FFF28E18  f80600                            mov.l   #0, 20h+var_20[sp]
FFF28E1B  ec01                   loc_FFF28E1B mov.l   20h+var_20[sp], r1
FFF28E1D  a101                              mov.l   r1, 20h+var_10[sp]
FFF28E1F  3f6609                            rtsd    #24h, r6-r6
FFF28E22  7100e4                 sub_FFF28E22 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF28E22
FFF28E25  8689                              mov.b   r1, 1Ch+var_1[sp]
FFF28E27  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF28E29  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF28E2B  056bd0fe                          bsr.a   sub_FFF15E96
FFF28E2F  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF28E31  a809                              mov.l   1Ch+var_18[sp], r1
FFF28E33  6101                              cmp     #0, r1
FFF28E35  210f                              bne.b   loc_FFF28E44
FFF28E37  6602                              mov.l   #0, r2
FFF28E39  fb16e1                            mov.l   #-1Fh, r1
FFF28E3C  05e45fff                          bsr.a   sub_FFF1EE20
FFF28E40  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF28E42  2e18                              bra.b   loc_FFF28E5A
FFF28E44  a80c                   loc_FFF28E44 mov.l   1Ch+var_18[sp], r4
FFF28E46  a903                              mov.l   1Ch+var_C[sp], r3
FFF28E48  a90a                              mov.l   1Ch+var_8[sp], r2
FFF28E4A  8e89                              mov.b   1Ch+var_1[sp], r1
FFF28E4C  391400                            bsr.w   sub_FFF28E60
FFF28E4F  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF28E51  a809                              mov.l   1Ch+var_18[sp], r1
FFF28E53  0553d0fe                          bsr.a   sub_FFF15EA6
FFF28E57  e10002                            mov.l   1Ch+var_14[sp], 1Ch+var_1C[sp]
FFF28E5A  ec01                   loc_FFF28E5A mov.l   1Ch+var_1C[sp], r1
FFF28E5C  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF28E5E  6707                              rtsd    #7
FFF28E60  7100d8                 sub_FFF28E60 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF28E60
FFF28E63  c70127                            mov.b   r1, 28h+var_1[sp]
FFF28E66  a202                              mov.l   r2, 28h+var_8[sp]
FFF28E68  a18b                              mov.l   r3, 28h+var_C[sp]
FFF28E6A  a184                              mov.l   r4, 28h+var_10[sp]
FFF28E6C  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF28E72  e4e003                            mov.l   [r14], 28h+var_1C[sp]
FFF28E75  0576c1ff                          bsr.a   sub_FFF24FEB
FFF28E79  a101                              mov.l   r1, 28h+var_18[sp]
FFF28E7B  a901                              mov.l   28h+var_18[sp], r1
FFF28E7D  6101                              cmp     #0, r1
FFF28E7F  200f                              beq.b   loc_FFF28E8E
FFF28E81  a901                              mov.l   28h+var_18[sp], r1
FFF28E83  6602                              mov.l   #0, r2
FFF28E85  059b5fff                          bsr.a   sub_FFF1EE20
FFF28E89  a009                              mov.l   r1, 28h+var_24[sp]
FFF28E8B  388300                            bra.w   loc_FFF28F0E
FFF28E8E  aa01                   loc_FFF28E8E mov.l   28h+var_8[sp], r1
FFF28E90  6101                              cmp     #0, r1
FFF28E92  16                                beq.s   loc_FFF28E98
FFF28E93  a989                              mov.l   28h+var_C[sp], r1
FFF28E95  6101                              cmp     #0, r1
FFF28E97  1d                                bne.s   loc_FFF28E9C
FFF28E98  f80601                 loc_FFF28E98 mov.l   #1, 28h+var_28[sp]
FFF28E9B  0c                                bra.s   loc_FFF28E9F
FFF28E9C  f80600                 loc_FFF28E9C mov.l   #0, 28h+var_28[sp]
FFF28E9F  ec01                   loc_FFF28E9F mov.l   28h+var_28[sp], r1
FFF28EA1  6101                              cmp     #0, r1
FFF28EA3  200f                              beq.b   loc_FFF28EB2
FFF28EA5  6602                              mov.l   #0, r2
FFF28EA7  fb16f3                            mov.l   #-0Dh, r1
FFF28EAA  05765fff                          bsr.a   sub_FFF1EE20
FFF28EAE  a009                              mov.l   r1, 28h+var_24[sp]
FFF28EB0  2e5e                              bra.b   loc_FFF28F0E
FFF28EB2  cd0127                 loc_FFF28EB2 mov.b   28h+var_1[sp], r1
FFF28EB5  05d65800                          bsr.a   sub_FFF2E78B
FFF28EB9  8289                              mov.b   r1, 28h+var_1D[sp]
FFF28EBB  b289                              movu.b  28h+var_1D[sp], r1
FFF28EBD  71020c                            add     #28h+var_1C, sp, r2
FFF28EC0  055f60ff                          bsr.a   sub_FFF1EF1F
FFF28EC4  a101                              mov.l   r1, 28h+var_18[sp]
FFF28EC6  a901                              mov.l   28h+var_18[sp], r1
FFF28EC8  6101                              cmp     #0, r1
FFF28ECA  200e                              beq.b   loc_FFF28ED8
FFF28ECC  a901                              mov.l   28h+var_18[sp], r1
FFF28ECE  6602                              mov.l   #0, r2
FFF28ED0  05505fff                          bsr.a   sub_FFF1EE20
FFF28ED4  a009                              mov.l   r1, 28h+var_24[sp]
FFF28ED6  2e38                              bra.b   loc_FFF28F0E
FFF28ED8  a889                   loc_FFF28ED8 mov.l   28h+var_1C[sp], r1
FFF28EDA  058360ff                          bsr.a   sub_FFF1EF5D
FFF28EDE  a101                              mov.l   r1, 28h+var_18[sp]
FFF28EE0  a901                              mov.l   28h+var_18[sp], r1
FFF28EE2  6101                              cmp     #0, r1
FFF28EE4  200e                              beq.b   loc_FFF28EF2
FFF28EE6  a901                              mov.l   28h+var_18[sp], r1
FFF28EE8  6602                              mov.l   #0, r2
FFF28EEA  05365fff                          bsr.a   sub_FFF1EE20
FFF28EEE  a009                              mov.l   r1, 28h+var_24[sp]
FFF28EF0  2e1e                              bra.b   loc_FFF28F0E
FFF28EF2  cd0127                 loc_FFF28EF2 mov.b   28h+var_1[sp], r1
FFF28EF5  05965800                          bsr.a   sub_FFF2E78B
FFF28EF9  a984                              mov.l   28h+var_10[sp], r4
FFF28EFB  a98b                              mov.l   28h+var_C[sp], r3
FFF28EFD  aa02                              mov.l   28h+var_8[sp], r2
FFF28EFF  391500                            bsr.w   sub_FFF28F14
FFF28F02  a101                              mov.l   r1, 28h+var_18[sp]
FFF28F04  a901                              mov.l   28h+var_18[sp], r1
FFF28F06  6602                              mov.l   #0, r2
FFF28F08  05185fff                          bsr.a   sub_FFF1EE20
FFF28F0C  a009                              mov.l   r1, 28h+var_24[sp]
FFF28F0E  a809                   loc_FFF28F0E mov.l   28h+var_24[sp], r1
FFF28F10  a109                              mov.l   r1, 28h+var_14[sp]
FFF28F12  670a                              rtsd    #0Ah
FFF28F14  7100dc                 sub_FFF28F14 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF28F14
FFF28F17  c70123                            mov.b   r1, 24h+var_1[sp]
FFF28F1A  a18a                              mov.l   r2, 24h+var_8[sp]
FFF28F1C  a183                              mov.l   r3, 24h+var_C[sp]
FFF28F1E  a10c                              mov.l   r4, 24h+var_10[sp]
FFF28F20  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF28F26  e4e002                            mov.l   [r14], 24h+var_1C[sp]
FFF28F29  cd0123                            mov.b   24h+var_1[sp], r1
FFF28F2C  055f5800                          bsr.a   sub_FFF2E78B
FFF28F30  8189                              mov.b   r1, 24h+var_1D[sp]
FFF28F32  b189                              movu.b  24h+var_1D[sp], r1
FFF28F34  710208                            add     #24h+var_1C, sp, r2
FFF28F37  05e85fff                          bsr.a   sub_FFF1EF1F
FFF28F3B  a089                              mov.l   r1, 24h+var_18[sp]
FFF28F3D  a889                              mov.l   24h+var_18[sp], r1
FFF28F3F  6101                              cmp     #0, r1
FFF28F41  16                                beq.s   loc_FFF28F47
FFF28F42  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF28F45  2e4c                              bra.b   loc_FFF28F91
FFF28F47  a881                   loc_FFF28F47 mov.l   24h+var_1C[sp], r1
FFF28F49  8c12                              mov.b   10h[r1], r2
FFF28F4B  61c2                              cmp     #0Ch, r2
FFF28F4D  210f                              bne.b   loc_FFF28F5C
FFF28F4F  a90c                              mov.l   24h+var_10[sp], r4
FFF28F51  a983                              mov.l   24h+var_C[sp], r3
FFF28F53  a98a                              mov.l   24h+var_8[sp], r2
FFF28F55  394200                            bsr.w   sub_FFF28F97
FFF28F58  e301                              mov.l   r1, 24h+var_24[sp]
FFF28F5A  2e37                              bra.b   loc_FFF28F91
FFF28F5C  8c11                   loc_FFF28F5C mov.b   10h[r1], r1
FFF28F5E  755110                            cmp     #10h, r1
FFF28F61  a881                              mov.l   24h+var_1C[sp], r1
FFF28F63  210f                              bne.b   loc_FFF28F72
FFF28F65  a90c                              mov.l   24h+var_10[sp], r4
FFF28F67  a983                              mov.l   24h+var_C[sp], r3
FFF28F69  a98a                              mov.l   24h+var_8[sp], r2
FFF28F6B  39db01                            bsr.w   sub_FFF29146
FFF28F6E  e301                              mov.l   r1, 24h+var_24[sp]
FFF28F70  2e21                              bra.b   loc_FFF28F91
FFF28F72  8c11                   loc_FFF28F72 mov.b   10h[r1], r1
FFF28F74  755120                            cmp     #20h, r1 ; ' '
FFF28F77  2117                              bne.b   loc_FFF28F8E
FFF28F79  a90c                              mov.l   24h+var_10[sp], r4
FFF28F7B  a983                              mov.l   24h+var_C[sp], r3
FFF28F7D  a98a                              mov.l   24h+var_8[sp], r2
FFF28F7F  a881                              mov.l   24h+var_1C[sp], r1
FFF28F81  6040                              sub     #4, sp
FFF28F83  f80401                            mov.b   #1, 28h+var_28[sp]
FFF28F86  39ff02                            bsr.w   sub_FFF29285
FFF28F89  6240                              add     #4, sp
FFF28F8B  e301                              mov.l   r1, 24h+var_24[sp]
FFF28F8D  0c                                bra.s   loc_FFF28F91
FFF28F8E  f806f3                 loc_FFF28F8E mov.l   #-0Dh, 24h+var_24[sp]
FFF28F91  ec01                   loc_FFF28F91 mov.l   24h+var_24[sp], r1
FFF28F93  a101                              mov.l   r1, 24h+var_14[sp]
FFF28F95  6709                              rtsd    #9
FFF28F97  7100e0                 sub_FFF28F97 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF28F97
FFF28F9A  a189                              mov.l   r1, 20h+var_4[sp]
FFF28F9C  a182                              mov.l   r2, 20h+var_8[sp]
FFF28F9E  a10b                              mov.l   r3, 20h+var_C[sp]
FFF28FA0  a104                              mov.l   r4, 20h+var_10[sp]
FFF28FA2  a989                              mov.l   20h+var_4[sp], r1
FFF28FA4  0571cdfe                          bsr.a   sub_FFF15D15
FFF28FA8  a009                              mov.l   r1, 20h+var_1C[sp]
FFF28FAA  a809                              mov.l   20h+var_1C[sp], r1
FFF28FAC  6101                              cmp     #0, r1
FFF28FAE  16                                beq.s   loc_FFF28FB4
FFF28FAF  f806de                            mov.l   #-22h, 20h+var_20[sp]
FFF28FB2  2e18                              bra.b   loc_FFF28FCA
FFF28FB4  a904                   loc_FFF28FB4 mov.l   20h+var_10[sp], r4
FFF28FB6  a90b                              mov.l   20h+var_C[sp], r3
FFF28FB8  a982                              mov.l   20h+var_8[sp], r2
FFF28FBA  a989                              mov.l   20h+var_4[sp], r1
FFF28FBC  391400                            bsr.w   sub_FFF28FD0
FFF28FBF  a081                              mov.l   r1, 20h+var_18[sp]
FFF28FC1  a989                              mov.l   20h+var_4[sp], r1
FFF28FC3  055dcdfe                          bsr.a   sub_FFF15D20
FFF28FC7  e10002                            mov.l   20h+var_18[sp], 20h+var_20[sp]
FFF28FCA  ec01                   loc_FFF28FCA mov.l   20h+var_20[sp], r1
FFF28FCC  a089                              mov.l   r1, 20h+var_14[sp]
FFF28FCE  6708                              rtsd    #8
FFF28FD0  7100c4                 sub_FFF28FD0 add     #-3Ch, sp, sp   ; <<<< FUNC sub_FFF28FD0
FFF28FD3  a381                              mov.l   r1, 3Ch+var_4[sp]
FFF28FD5  a30a                              mov.l   r2, 3Ch+var_8[sp]
FFF28FD7  a303                              mov.l   r3, 3Ch+var_C[sp]
FFF28FD9  a28c                              mov.l   r4, 3Ch+var_10[sp]
FFF28FDB  3e0400                            mov.l   #0, 3Ch+var_2C[sp]
FFF28FDE  3e0100                            mov.l   #0, 3Ch+var_38[sp]
FFF28FE1  ab81                              mov.l   3Ch+var_4[sp], r1
FFF28FE3  ad9a                              mov.l   5Ch[r1], r2
FFF28FE5  068d1203                          mul     0Ch[r1].l, r2
FFF28FE9  6c12                              shll    #1, r2
FFF28FEB  fd749203                          divu    #3, r2
FFF28FEF  910a                              mov.w   r2, 3Ch+var_32[sp]
FFF28FF1  ab81                              mov.l   3Ch+var_4[sp], r1
FFF28FF3  a89a                              mov.l   0Ch[r1], r2
FFF28FF5  06cd1204                          mul     8[r1].uw, r2
FFF28FF9  06c91203                          add     6[r1].uw, r2
FFF28FFD  b91b                              movu.w  0Ah[r1], r3
FFF28FFF  6c53                              shll    #5, r3
FFF29001  06a1091317                        divu    5Ch[r1].l, r3
FFF29006  4b32                              add     r3, r2
FFF29008  a91b                              mov.l   14h[r1], r3
FFF2900A  4323                              sub     r2, r3
FFF2900C  06e1091302                        divu    4[r1].uw, r3
FFF29011  6223                              add     #2, r3
FFF29013  5f3e                              movu.w  r3, r14
FFF29015  b909                              movu.w  3Ch+var_32[sp], r1
FFF29017  47e1                              cmp     r14, r1
FFF29019  2b26                              ble.b   loc_FFF2903F
FFF2901B  ab81                              mov.l   3Ch+var_4[sp], r1
FFF2901D  a89a                              mov.l   0Ch[r1], r2
FFF2901F  06cd1204                          mul     8[r1].uw, r2
FFF29023  06c91203                          add     6[r1].uw, r2
FFF29027  b91b                              movu.w  0Ah[r1], r3
FFF29029  6c53                              shll    #5, r3
FFF2902B  06a1091317                        divu    5Ch[r1].l, r3
FFF29030  4b32                              add     r3, r2
FFF29032  a91b                              mov.l   14h[r1], r3
FFF29034  4323                              sub     r2, r3
FFF29036  06e1091302                        divu    4[r1].uw, r3
FFF2903B  6223                              add     #2, r3
FFF2903D  910b                              mov.w   r3, 3Ch+var_32[sp]
FFF2903F  3d0602                 loc_FFF2903F mov.w   #2, 3Ch+var_30[sp]
FFF29042  f90607ff                          mov.l   #-1, 3Ch+var_20[sp]
FFF29046  38d700                            bra.w   loc_FFF2911D
FFF29049  b981                   loc_FFF29049 movu.w  3Ch+var_30[sp], r1
FFF2904B  6331                              mul     #3, r1
FFF2904D  ab82                              mov.l   3Ch+var_4[sp], r2
FFF2904F  adaa                              mov.l   5Ch[r2], r2
FFF29051  6c12                              shll    #1, r2
FFF29053  fc2721                            divu    r2, r1
FFF29056  a181                              mov.l   r1, 3Ch+var_24[sp]
FFF29058  b981                              movu.w  3Ch+var_30[sp], r1
FFF2905A  6331                              mul     #3, r1
FFF2905C  6811                              shlr    #1, r1
FFF2905E  ab82                              mov.l   3Ch+var_4[sp], r2
FFF29060  adaa                              mov.l   5Ch[r2], r2
FFF29062  068d0206                          mul     3Ch+var_24[sp].l, r2
FFF29066  4321                              sub     r2, r1
FFF29068  a201                              mov.l   r1, 3Ch+var_1C[sp]
FFF2906A  a989                              mov.l   3Ch+var_20[sp], r1
FFF2906C  06850106                          cmp     3Ch+var_24[sp].l, r1
FFF29070  2020                              beq.b   loc_FFF29090
FFF29072  aa8c                              mov.l   3Ch+var_10[sp], r4
FFF29074  a982                              mov.l   3Ch+var_24[sp], r2
FFF29076  ab81                              mov.l   3Ch+var_4[sp], r1
FFF29078  710310                            add     #3Ch+var_2C, sp, r3
FFF2907B  0563b0ff                          bsr.a   sub_FFF240DE
FFF2907F  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF29081  aa09                              mov.l   3Ch+var_18[sp], r1
FFF29083  6101                              cmp     #0, r1
FFF29085  17                                beq.s   loc_FFF2908C
FFF29086  e10009                            mov.l   3Ch+var_18[sp], 3Ch+var_3C[sp]
FFF29089  38b700                            bra.w   loc_FFF29140
FFF2908C  e5000607               loc_FFF2908C mov.l   3Ch+var_24[sp], 3Ch+var_20[sp]
FFF29090  a901                   loc_FFF29090 mov.l   3Ch+var_2C[sp], r1
FFF29092  6101                              cmp     #0, r1
FFF29094  1f                                bne.s   loc_FFF2909B
FFF29095  f806f3                            mov.l   #-0Dh, 3Ch+var_3C[sp]
FFF29098  38a800                            bra.w   loc_FFF29140
FFF2909B  aa01                   loc_FFF2909B mov.l   3Ch+var_1C[sp], r1
FFF2909D  a902                              mov.l   3Ch+var_2C[sp], r2
FFF2909F  fec211                            movu.b  [r2, r1], r1
FFF290A2  8581                              mov.b   r1, 3Ch+var_26[sp]
FFF290A4  ab81                              mov.l   3Ch+var_4[sp], r1
FFF290A6  ad99                              mov.l   5Ch[r1], r1
FFF290A8  6011                              sub     #1, r1
FFF290AA  06850108                          cmp     3Ch+var_1C[sp].l, r1
FFF290AE  2127                              bne.b   loc_FFF290D5
FFF290B0  f90608ff                          mov.l   #-1, 3Ch+var_1C[sp]
FFF290B4  a982                              mov.l   3Ch+var_24[sp], r2
FFF290B6  6212                              add     #1, r2
FFF290B8  ab81                              mov.l   3Ch+var_4[sp], r1
FFF290BA  a182                              mov.l   r2, 3Ch+var_24[sp]
FFF290BC  aa8c                              mov.l   3Ch+var_10[sp], r4
FFF290BE  710310                            add     #3Ch+var_2C, sp, r3
FFF290C1  051db0ff                          bsr.a   sub_FFF240DE
FFF290C5  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF290C7  aa09                              mov.l   3Ch+var_18[sp], r1
FFF290C9  6101                              cmp     #0, r1
FFF290CB  16                                beq.s   loc_FFF290D1
FFF290CC  e10009                            mov.l   3Ch+var_18[sp], 3Ch+var_3C[sp]
FFF290CF  2e71                              bra.b   loc_FFF29140
FFF290D1  e5000607               loc_FFF290D1 mov.l   3Ch+var_24[sp], 3Ch+var_20[sp]
FFF290D5  aa01                   loc_FFF290D5 mov.l   3Ch+var_1C[sp], r1
FFF290D7  06890104                          add     3Ch+var_2C[sp].l, r1
FFF290DB  c5100117                          mov.b   1[r1], 3Ch+var_25[sp]
FFF290DF  710116                            add     #3Ch+var_26, sp, r1
FFF290E2  05c25b00                          bsr.a   sub_FFF2ECA4
FFF290E6  9189                              mov.w   r1, 3Ch+var_2E[sp]
FFF290E8  b981                              movu.w  3Ch+var_30[sp], r1
FFF290EA  7c01                              btst    #0, r1
FFF290EC  17                                beq.s   loc_FFF290F3
FFF290ED  b989                              movu.w  3Ch+var_2E[sp], r1
FFF290EF  6841                              shlr    #4, r1
FFF290F1  9189                              mov.w   r1, 3Ch+var_2E[sp]
FFF290F3  b989                   loc_FFF290F3 movu.w  3Ch+var_2E[sp], r1
FFF290F5  7621ff0f                          and     #0FFFh, r1
FFF290F9  9189                              mov.w   r1, 3Ch+var_2E[sp]
FFF290FB  b989                              movu.w  3Ch+var_2E[sp], r1
FFF290FD  7601f70f                          cmp     #0FF7h, r1
FFF29101  290b                              blt.b   loc_FFF2910C
FFF29103  9989                              mov.w   3Ch+var_2E[sp], r1
FFF29105  773100f000                        or      #0F000h, r1
FFF2910A  9189                              mov.w   r1, 3Ch+var_2E[sp]
FFF2910C  b989                   loc_FFF2910C movu.w  3Ch+var_2E[sp], r1
FFF2910E  6101                              cmp     #0, r1
FFF29110  1f                                bne.s   loc_FFF29117
FFF29111  a809                              mov.l   3Ch+var_38[sp], r1
FFF29113  6211                              add     #1, r1
FFF29115  a009                              mov.l   r1, 3Ch+var_38[sp]
FFF29117  9981                   loc_FFF29117 mov.w   3Ch+var_30[sp], r1
FFF29119  6211                              add     #1, r1
FFF2911B  9181                              mov.w   r1, 3Ch+var_30[sp]
FFF2911D  b981                   loc_FFF2911D movu.w  3Ch+var_30[sp], r1
FFF2911F  06c50105                          cmp     3Ch+var_32[sp].uw, r1
FFF29123  2805                              bge.b   loc_FFF29128
FFF29125  3824ff                            bra.w   loc_FFF29049
FFF29128  ab09                   loc_FFF29128 mov.l   3Ch+var_8[sp], r1
FFF2912A  f81600                            mov.l   #0, [r1]
FFF2912D  ab81                              mov.l   3Ch+var_4[sp], r1
FFF2912F  b892                              movu.w  4[r1], r2
FFF29131  068d1217                          mul     5Ch[r1].l, r2
FFF29135  068d0201                          mul     3Ch+var_38[sp].l, r2
FFF29139  ab01                              mov.l   3Ch+var_C[sp], r1
FFF2913B  e312                              mov.l   r2, [r1]
FFF2913D  f80600                            mov.l   #0, 3Ch+var_3C[sp]
FFF29140  ec01                   loc_FFF29140 mov.l   3Ch+var_3C[sp], r1
FFF29142  a281                              mov.l   r1, 3Ch+var_14[sp]
FFF29144  670f                              rtsd    #0Fh
FFF29146  7100e0                 sub_FFF29146 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF29146
FFF29149  a189                              mov.l   r1, 20h+var_4[sp]
FFF2914B  a182                              mov.l   r2, 20h+var_8[sp]
FFF2914D  a10b                              mov.l   r3, 20h+var_C[sp]
FFF2914F  a104                              mov.l   r4, 20h+var_10[sp]
FFF29151  a989                              mov.l   20h+var_4[sp], r1
FFF29153  05c2cbfe                          bsr.a   sub_FFF15D15
FFF29157  a009                              mov.l   r1, 20h+var_1C[sp]
FFF29159  a809                              mov.l   20h+var_1C[sp], r1
FFF2915B  6101                              cmp     #0, r1
FFF2915D  16                                beq.s   loc_FFF29163
FFF2915E  f806de                            mov.l   #-22h, 20h+var_20[sp]
FFF29161  2e18                              bra.b   loc_FFF29179
FFF29163  a904                   loc_FFF29163 mov.l   20h+var_10[sp], r4
FFF29165  a90b                              mov.l   20h+var_C[sp], r3
FFF29167  a982                              mov.l   20h+var_8[sp], r2
FFF29169  a989                              mov.l   20h+var_4[sp], r1
FFF2916B  391400                            bsr.w   sub_FFF2917F
FFF2916E  a081                              mov.l   r1, 20h+var_18[sp]
FFF29170  a989                              mov.l   20h+var_4[sp], r1
FFF29172  05aecbfe                          bsr.a   sub_FFF15D20
FFF29176  e10002                            mov.l   20h+var_18[sp], 20h+var_20[sp]
FFF29179  ec01                   loc_FFF29179 mov.l   20h+var_20[sp], r1
FFF2917B  a089                              mov.l   r1, 20h+var_14[sp]
FFF2917D  6708                              rtsd    #8
FFF2917F  7100c4                 sub_FFF2917F add     #-3Ch, sp, sp   ; <<<< FUNC sub_FFF2917F
FFF29182  a381                              mov.l   r1, 3Ch+var_4[sp]
FFF29184  a30a                              mov.l   r2, 3Ch+var_8[sp]
FFF29186  a303                              mov.l   r3, 3Ch+var_C[sp]
FFF29188  a28c                              mov.l   r4, 3Ch+var_10[sp]
FFF2918A  3e0500                            mov.l   #0, 3Ch+var_28[sp]
FFF2918D  3e0100                            mov.l   #0, 3Ch+var_38[sp]
FFF29190  ab81                              mov.l   3Ch+var_4[sp], r1
FFF29192  ad9a                              mov.l   5Ch[r1], r2
FFF29194  6812                              shlr    #1, r2
FFF29196  068d1203                          mul     0Ch[r1].l, r2
FFF2919A  a08a                              mov.l   r2, 3Ch+var_30[sp]
FFF2919C  ab81                              mov.l   3Ch+var_4[sp], r1
FFF2919E  a89a                              mov.l   0Ch[r1], r2
FFF291A0  06cd1204                          mul     8[r1].uw, r2
FFF291A4  06c91203                          add     6[r1].uw, r2
FFF291A8  b91b                              movu.w  0Ah[r1], r3
FFF291AA  6c53                              shll    #5, r3
FFF291AC  06a1091317                        divu    5Ch[r1].l, r3
FFF291B1  4b32                              add     r3, r2
FFF291B3  a91b                              mov.l   14h[r1], r3
FFF291B5  4323                              sub     r2, r3
FFF291B7  06e1091302                        divu    4[r1].uw, r3
FFF291BC  6223                              add     #2, r3
FFF291BE  06850303                          cmp     3Ch+var_30[sp].l, r3
FFF291C2  2226                              bgeu.b  loc_FFF291E8
FFF291C4  ab81                              mov.l   3Ch+var_4[sp], r1
FFF291C6  a89a                              mov.l   0Ch[r1], r2
FFF291C8  06cd1204                          mul     8[r1].uw, r2
FFF291CC  06c91203                          add     6[r1].uw, r2
FFF291D0  b91b                              movu.w  0Ah[r1], r3
FFF291D2  6c53                              shll    #5, r3
FFF291D4  06a1091317                        divu    5Ch[r1].l, r3
FFF291D9  4b32                              add     r3, r2
FFF291DB  a91b                              mov.l   14h[r1], r3
FFF291DD  4323                              sub     r2, r3
FFF291DF  06e1091302                        divu    4[r1].uw, r3
FFF291E4  6223                              add     #2, r3
FFF291E6  a08b                              mov.l   r3, 3Ch+var_30[sp]
FFF291E8  3e0402                 loc_FFF291E8 mov.l   #2, 3Ch+var_2C[sp]
FFF291EB  f90607ff                          mov.l   #-1, 3Ch+var_20[sp]
FFF291EF  2e70                              bra.b   loc_FFF2925F
FFF291F1  ab81                   loc_FFF291F1 mov.l   3Ch+var_4[sp], r1
FFF291F3  ad99                              mov.l   5Ch[r1], r1
FFF291F5  6811                              shlr    #1, r1
FFF291F7  a902                              mov.l   3Ch+var_2C[sp], r2
FFF291F9  fc2712                            divu    r1, r2
FFF291FC  a182                              mov.l   r2, 3Ch+var_24[sp]
FFF291FE  ab81                              mov.l   3Ch+var_4[sp], r1
FFF29200  ad99                              mov.l   5Ch[r1], r1
FFF29202  6811                              shlr    #1, r1
FFF29204  a902                              mov.l   3Ch+var_2C[sp], r2
FFF29206  ef2e                              mov.l   r2, r14
FFF29208  fc271e                            divu    r1, r14
FFF2920B  4f1e                              mul     r1, r14
FFF2920D  43e2                              sub     r14, r2
FFF2920F  6c12                              shll    #1, r2
FFF29211  a202                              mov.l   r2, 3Ch+var_1C[sp]
FFF29213  a989                              mov.l   3Ch+var_20[sp], r1
FFF29215  06850106                          cmp     3Ch+var_24[sp].l, r1
FFF29219  201f                              beq.b   loc_FFF29238
FFF2921B  aa8c                              mov.l   3Ch+var_10[sp], r4
FFF2921D  a982                              mov.l   3Ch+var_24[sp], r2
FFF2921F  ab81                              mov.l   3Ch+var_4[sp], r1
FFF29221  710304                            add     #3Ch+var_38, sp, r3
FFF29224  05baaeff                          bsr.a   sub_FFF240DE
FFF29228  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF2922A  aa09                              mov.l   3Ch+var_18[sp], r1
FFF2922C  6101                              cmp     #0, r1
FFF2922E  16                                beq.s   loc_FFF29234
FFF2922F  e10009                            mov.l   3Ch+var_18[sp], 3Ch+var_3C[sp]
FFF29232  2e4d                              bra.b   loc_FFF2927F
FFF29234  e5000607               loc_FFF29234 mov.l   3Ch+var_24[sp], 3Ch+var_20[sp]
FFF29238  a809                   loc_FFF29238 mov.l   3Ch+var_38[sp], r1
FFF2923A  6101                              cmp     #0, r1
FFF2923C  1e                                bne.s   loc_FFF29242
FFF2923D  f806f3                            mov.l   #-0Dh, 3Ch+var_3C[sp]
FFF29240  2e3f                              bra.b   loc_FFF2927F
FFF29242  a809                   loc_FFF29242 mov.l   3Ch+var_38[sp], r1
FFF29244  06890108                          add     3Ch+var_1C[sp].l, r1
FFF29248  055c5a00                          bsr.a   sub_FFF2ECA4
FFF2924C  9109                              mov.w   r1, 3Ch+var_32[sp]
FFF2924E  b909                              movu.w  3Ch+var_32[sp], r1
FFF29250  6101                              cmp     #0, r1
FFF29252  1f                                bne.s   loc_FFF29259
FFF29253  a909                              mov.l   3Ch+var_28[sp], r1
FFF29255  6211                              add     #1, r1
FFF29257  a109                              mov.l   r1, 3Ch+var_28[sp]
FFF29259  a901                   loc_FFF29259 mov.l   3Ch+var_2C[sp], r1
FFF2925B  6211                              add     #1, r1
FFF2925D  a101                              mov.l   r1, 3Ch+var_2C[sp]
FFF2925F  a901                   loc_FFF2925F mov.l   3Ch+var_2C[sp], r1
FFF29261  06850103                          cmp     3Ch+var_30[sp].l, r1
FFF29265  238c                              bltu.b  loc_FFF291F1
FFF29267  ab09                              mov.l   3Ch+var_8[sp], r1
FFF29269  f81600                            mov.l   #0, [r1]
FFF2926C  ab81                              mov.l   3Ch+var_4[sp], r1
FFF2926E  b892                              movu.w  4[r1], r2
FFF29270  068d1217                          mul     5Ch[r1].l, r2
FFF29274  068d0205                          mul     3Ch+var_28[sp].l, r2
FFF29278  ab01                              mov.l   3Ch+var_C[sp], r1
FFF2927A  e312                              mov.l   r2, [r1]
FFF2927C  f80600                            mov.l   #0, 3Ch+var_3C[sp]
FFF2927F  ec01                   loc_FFF2927F mov.l   3Ch+var_3C[sp], r1
FFF29281  a281                              mov.l   r1, 3Ch+var_14[sp]
FFF29283  670f                              rtsd    #0Fh
FFF29285  7100dc                 sub_FFF29285 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF29285
FFF29288  a201                              mov.l   r1, 24h+var_4[sp]
FFF2928A  a18a                              mov.l   r2, 24h+var_8[sp]
FFF2928C  a183                              mov.l   r3, 24h+var_C[sp]
FFF2928E  a10c                              mov.l   r4, 24h+var_10[sp]
FFF29290  c5002813                          mov.b   24h+arg_0[sp], 24h+var_11[sp]
FFF29294  aa01                              mov.l   24h+var_4[sp], r1
FFF29296  057fcafe                          bsr.a   sub_FFF15D15
FFF2929A  a009                              mov.l   r1, 24h+var_20[sp]
FFF2929C  a809                              mov.l   24h+var_20[sp], r1
FFF2929E  6101                              cmp     #0, r1
FFF292A0  16                                beq.s   loc_FFF292A6
FFF292A1  f806de                            mov.l   #-22h, 24h+var_24[sp]
FFF292A4  2e20                              bra.b   loc_FFF292C4
FFF292A6  b48d                   loc_FFF292A6 movu.b  24h+var_11[sp], r5
FFF292A8  a90c                              mov.l   24h+var_10[sp], r4
FFF292AA  a983                              mov.l   24h+var_C[sp], r3
FFF292AC  a98a                              mov.l   24h+var_8[sp], r2
FFF292AE  aa01                              mov.l   24h+var_4[sp], r1
FFF292B0  6040                              sub     #4, sp
FFF292B2  c305                              mov.b   r5, 28h+var_28[sp]
FFF292B4  391600                            bsr.w   sub_FFF292CA
FFF292B7  6240                              add     #4, sp
FFF292B9  a081                              mov.l   r1, 24h+var_1C[sp]
FFF292BB  aa01                              mov.l   24h+var_4[sp], r1
FFF292BD  0563cafe                          bsr.a   sub_FFF15D20
FFF292C1  e10002                            mov.l   24h+var_1C[sp], 24h+var_24[sp]
FFF292C4  ec01                   loc_FFF292C4 mov.l   24h+var_24[sp], r1
FFF292C6  a089                              mov.l   r1, 24h+var_18[sp]
FFF292C8  6709                              rtsd    #9
FFF292CA  7100ac                 sub_FFF292CA add     #-54h, sp, sp   ; <<<< FUNC sub_FFF292CA
FFF292CD  a501                              mov.l   r1, 54h+var_4[sp]
FFF292CF  a48a                              mov.l   r2, 54h+var_8[sp]
FFF292D1  a483                              mov.l   r3, 54h+var_C[sp]
FFF292D3  a40c                              mov.l   r4, 54h+var_10[sp]
FFF292D5  c5005843                          mov.b   54h+arg_0[sp], 54h+var_11[sp]
FFF292D9  3e0d00                            mov.l   #0, 54h+var_20[sp]
FFF292DC  3e0c00                            mov.l   #0, 54h+var_24[sp]
FFF292DF  3e0b00                            mov.l   #0, 54h+var_28[sp]
FFF292E2  3e0a00                            mov.l   #0, 54h+var_2C[sp]
FFF292E5  3e0900                            mov.l   #0, 54h+var_30[sp]
FFF292E8  3e0100                            mov.l   #0, 54h+var_50[sp]
FFF292EB  cd0143                            mov.b   54h+var_11[sp], r1
FFF292EE  6101                              cmp     #0, r1
FFF292F0  2028                              beq.b   loc_FFF29318
FFF292F2  ad01                              mov.l   54h+var_4[sp], r1
FFF292F4  ab99                              mov.l   3Ch[r1], r1
FFF292F6  7501ff                            cmp     #-1, r1
FFF292F9  201f                              beq.b   loc_FFF29318
FFF292FB  ad01                              mov.l   54h+var_4[sp], r1
FFF292FD  ab9a                              mov.l   3Ch[r1], r2
FFF292FF  06cd1202                          mul     4[r1].uw, r2
FFF29303  a082                              mov.l   r2, 54h+var_4C[sp]
FFF29305  ad01                              mov.l   54h+var_4[sp], r1
FFF29307  ad9c                              mov.l   5Ch[r1], r4
FFF29309  ac83                              mov.l   54h+var_C[sp], r3
FFF2930B  ac8a                              mov.l   54h+var_8[sp], r2
FFF2930D  a881                              mov.l   54h+var_4C[sp], r1
FFF2930F  394f01                            bsr.w   sub_FFF2945E
FFF29312  f80600                            mov.l   #0, 54h+var_54[sp]
FFF29315  384301                            bra.w   loc_FFF29458
FFF29318  ad01                   loc_FFF29318 mov.l   54h+var_4[sp], r1
FFF2931A  ad9a                              mov.l   5Ch[r1], r2
FFF2931C  6822                              shlr    #2, r2
FFF2931E  068d1203                          mul     0Ch[r1].l, r2
FFF29322  a08a                              mov.l   r2, 54h+var_48[sp]
FFF29324  ad01                              mov.l   54h+var_4[sp], r1
FFF29326  a89a                              mov.l   0Ch[r1], r2
FFF29328  06cd1204                          mul     8[r1].uw, r2
FFF2932C  06c91203                          add     6[r1].uw, r2
FFF29330  b91b                              movu.w  0Ah[r1], r3
FFF29332  6c53                              shll    #5, r3
FFF29334  06a1091317                        divu    5Ch[r1].l, r3
FFF29339  4b32                              add     r3, r2
FFF2933B  a91b                              mov.l   14h[r1], r3
FFF2933D  4323                              sub     r2, r3
FFF2933F  06e1091302                        divu    4[r1].uw, r3
FFF29344  6223                              add     #2, r3
FFF29346  06850303                          cmp     54h+var_48[sp].l, r3
FFF2934A  2226                              bgeu.b  loc_FFF29370
FFF2934C  ad01                              mov.l   54h+var_4[sp], r1
FFF2934E  a89a                              mov.l   0Ch[r1], r2
FFF29350  06cd1204                          mul     8[r1].uw, r2
FFF29354  06c91203                          add     6[r1].uw, r2
FFF29358  b91b                              movu.w  0Ah[r1], r3
FFF2935A  6c53                              shll    #5, r3
FFF2935C  06a1091317                        divu    5Ch[r1].l, r3
FFF29361  4b32                              add     r3, r2
FFF29363  a91b                              mov.l   14h[r1], r3
FFF29365  4323                              sub     r2, r3
FFF29367  06e1091302                        divu    4[r1].uw, r3
FFF2936C  6223                              add     #2, r3
FFF2936E  a08b                              mov.l   r3, 54h+var_48[sp]
FFF29370  3e0402                 loc_FFF29370 mov.l   #2, 54h+var_44[sp]
FFF29373  f90606ff                          mov.l   #-1, 54h+var_3C[sp]
FFF29377  389600                            bra.w   loc_FFF2940D
FFF2937A  ad01                   loc_FFF2937A mov.l   54h+var_4[sp], r1
FFF2937C  ad99                              mov.l   5Ch[r1], r1
FFF2937E  6821                              shlr    #2, r1
FFF29380  a902                              mov.l   54h+var_44[sp], r2
FFF29382  fc2712                            divu    r1, r2
FFF29385  a18a                              mov.l   r2, 54h+var_38[sp]
FFF29387  ad01                              mov.l   54h+var_4[sp], r1
FFF29389  ad99                              mov.l   5Ch[r1], r1
FFF2938B  6821                              shlr    #2, r1
FFF2938D  a902                              mov.l   54h+var_44[sp], r2
FFF2938F  ef2e                              mov.l   r2, r14
FFF29391  fc271e                            divu    r1, r14
FFF29394  4f1e                              mul     r1, r14
FFF29396  43e2                              sub     r14, r2
FFF29398  6c22                              shll    #2, r2
FFF2939A  a202                              mov.l   r2, 54h+var_34[sp]
FFF2939C  a981                              mov.l   54h+var_3C[sp], r1
FFF2939E  06850107                          cmp     54h+var_38[sp].l, r1
FFF293A2  2020                              beq.b   loc_FFF293C2
FFF293A4  ac0c                              mov.l   54h+var_10[sp], r4
FFF293A6  a98a                              mov.l   54h+var_38[sp], r2
FFF293A8  ad01                              mov.l   54h+var_4[sp], r1
FFF293AA  710304                            add     #54h+var_50, sp, r3
FFF293AD  0531adff                          bsr.a   sub_FFF240DE
FFF293B1  a381                              mov.l   r1, 54h+var_1C[sp]
FFF293B3  ab81                              mov.l   54h+var_1C[sp], r1
FFF293B5  6101                              cmp     #0, r1
FFF293B7  17                                beq.s   loc_FFF293BE
FFF293B8  e1000e                            mov.l   54h+var_1C[sp], 54h+var_54[sp]
FFF293BB  389d00                            bra.w   loc_FFF29458
FFF293BE  e5000706               loc_FFF293BE mov.l   54h+var_38[sp], 54h+var_3C[sp]
FFF293C2  a809                   loc_FFF293C2 mov.l   54h+var_50[sp], r1
FFF293C4  6101                              cmp     #0, r1
FFF293C6  1f                                bne.s   loc_FFF293CD
FFF293C7  f806f3                            mov.l   #-0Dh, 54h+var_54[sp]
FFF293CA  388e00                            bra.w   loc_FFF29458
FFF293CD  a809                   loc_FFF293CD mov.l   54h+var_50[sp], r1
FFF293CF  06890108                          add     54h+var_34[sp].l, r1
FFF293D3  05475900                          bsr.a   sub_FFF2ED1A
FFF293D7  a109                              mov.l   r1, 54h+var_40[sp]
FFF293D9  a909                              mov.l   54h+var_40[sp], r1
FFF293DB  6101                              cmp     #0, r1
FFF293DD  ab01                              mov.l   54h+var_24[sp], r1
FFF293DF  2117                              bne.b   loc_FFF293F6
FFF293E1  6101                              cmp     #0, r1
FFF293E3  1d                                bne.s   loc_FFF293E8
FFF293E4  e500040a                          mov.l   54h+var_44[sp], 54h+var_2C[sp]
FFF293E8  ab09                   loc_FFF293E8 mov.l   54h+var_20[sp], r1
FFF293EA  6211                              add     #1, r1
FFF293EC  a309                              mov.l   r1, 54h+var_20[sp]
FFF293EE  ab01                              mov.l   54h+var_24[sp], r1
FFF293F0  6211                              add     #1, r1
FFF293F2  a301                              mov.l   r1, 54h+var_24[sp]
FFF293F4  2e13                              bra.b   loc_FFF29407
FFF293F6  0685010b               loc_FFF293F6 cmp     54h+var_28[sp].l, r1
FFF293FA  250a                              bleu.b  loc_FFF29404
FFF293FC  e5000c0b                          mov.l   54h+var_24[sp], 54h+var_28[sp]
FFF29400  e5000a09                          mov.l   54h+var_2C[sp], 54h+var_30[sp]
FFF29404  3e0c00                 loc_FFF29404 mov.l   #0, 54h+var_24[sp]
FFF29407  a901                   loc_FFF29407 mov.l   54h+var_44[sp], r1
FFF29409  6211                              add     #1, r1
FFF2940B  a101                              mov.l   r1, 54h+var_44[sp]
FFF2940D  a901                   loc_FFF2940D mov.l   54h+var_44[sp], r1
FFF2940F  06850103                          cmp     54h+var_48[sp].l, r1
FFF29413  2205                              bgeu.b  loc_FFF29418
FFF29415  3865ff                            bra.w   loc_FFF2937A
FFF29418  aa89                   loc_FFF29418 mov.l   54h+var_28[sp], r1
FFF2941A  0685010c                          cmp     54h+var_24[sp].l, r1
FFF2941E  ad01                              mov.l   54h+var_4[sp], r1
FFF29420  250e                              bleu.b  loc_FFF2942E
FFF29422  e5010910                          mov.l   54h+var_30[sp], 40h[r1]
FFF29426  aa09                              mov.l   54h+var_30[sp], r1
FFF29428  ad02                              mov.l   54h+var_4[sp], r2
FFF2942A  a2a1                              mov.l   r1, 28h[r2]
FFF2942C  2e0c                              bra.b   loc_FFF29438
FFF2942E  e5010a10               loc_FFF2942E mov.l   54h+var_2C[sp], 40h[r1]
FFF29432  aa81                              mov.l   54h+var_2C[sp], r1
FFF29434  ad02                              mov.l   54h+var_4[sp], r2
FFF29436  a2a1                              mov.l   r1, 28h[r2]
FFF29438  ab09                   loc_FFF29438 mov.l   54h+var_20[sp], r1
FFF2943A  ad02                              mov.l   54h+var_4[sp], r2
FFF2943C  a3a9                              mov.l   r1, 3Ch[r2]
FFF2943E  ad01                              mov.l   54h+var_4[sp], r1
FFF29440  b891                              movu.w  4[r1], r1
FFF29442  068d010d                          mul     54h+var_20[sp].l, r1
FFF29446  a081                              mov.l   r1, 54h+var_4C[sp]
FFF29448  ad01                              mov.l   54h+var_4[sp], r1
FFF2944A  ad9c                              mov.l   5Ch[r1], r4
FFF2944C  ac83                              mov.l   54h+var_C[sp], r3
FFF2944E  ac8a                              mov.l   54h+var_8[sp], r2
FFF29450  a881                              mov.l   54h+var_4C[sp], r1
FFF29452  390c00                            bsr.w   sub_FFF2945E
FFF29455  f80600                            mov.l   #0, 54h+var_54[sp]
FFF29458  ec01                   loc_FFF29458 mov.l   54h+var_54[sp], r1
FFF2945A  a389                              mov.l   r1, 54h+var_18[sp]
FFF2945C  6715                              rtsd    #15h
FFF2945E  7100ec                 sub_FFF2945E add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2945E
FFF29461  a101                              mov.l   r1, 14h+var_4[sp]
FFF29463  a08a                              mov.l   r2, 14h+var_8[sp]
FFF29465  a083                              mov.l   r3, 14h+var_C[sp]
FFF29467  a00c                              mov.l   r4, 14h+var_10[sp]
FFF29469  6894                              shlr    #9, r4
FFF2946B  fb1200008000                      mov.l   #800000h, r1
FFF29471  fc2741                            divu    r4, r1
FFF29474  e301                              mov.l   r1, 14h+var_14[sp]
FFF29476  a901                              mov.l   14h+var_4[sp], r1
FFF29478  068401                            cmp     [sp].l, r1
FFF2947B  a889                              mov.l   14h+var_8[sp], r1
FFF2947D  2321                              bltu.b  loc_FFF2949E
FFF2947F  a902                              mov.l   14h+var_4[sp], r2
FFF29481  06a00902                          divu    [sp].l, r2
FFF29485  e312                              mov.l   r2, [r1]
FFF29487  a901                              mov.l   14h+var_4[sp], r1
FFF29489  ec02                              mov.l   14h+var_14[sp], r2
FFF2948B  ef1e                              mov.l   r1, r14
FFF2948D  fc272e                            divu    r2, r14
FFF29490  4f2e                              mul     r2, r14
FFF29492  43e1                              sub     r14, r1
FFF29494  068d0101                          mul     14h+var_10[sp].l, r1
FFF29498  a882                              mov.l   14h+var_C[sp], r2
FFF2949A  e321                              mov.l   r1, [r2]
FFF2949C  6705                              rtsd    #5
FFF2949E  f81600                 loc_FFF2949E mov.l   #0, [r1]
FFF294A1  a901                              mov.l   14h+var_4[sp], r1
FFF294A3  068d0101                          mul     14h+var_10[sp].l, r1
FFF294A7  a882                              mov.l   14h+var_C[sp], r2
FFF294A9  e321                              mov.l   r1, [r2]
FFF294AB  6705                              rtsd    #5
FFF294AD  7100ec                 sub_FFF294AD add     #-14h, sp, sp   ; <<<< FUNC sub_FFF294AD
FFF294B0  8489                              mov.b   r1, 14h+var_1[sp]
FFF294B2  05e4c9fe                          bsr.a   sub_FFF15E96
FFF294B6  a009                              mov.l   r1, 14h+var_10[sp]
FFF294B8  a809                              mov.l   14h+var_10[sp], r1
FFF294BA  6101                              cmp     #0, r1
FFF294BC  210f                              bne.b   loc_FFF294CB
FFF294BE  6602                              mov.l   #0, r2
FFF294C0  fb16e1                            mov.l   #-1Fh, r1
FFF294C3  055d59ff                          bsr.a   sub_FFF1EE20
FFF294C7  e301                              mov.l   r1, 14h+var_14[sp]
FFF294C9  2e14                              bra.b   loc_FFF294DD
FFF294CB  a80a                   loc_FFF294CB mov.l   14h+var_10[sp], r2
FFF294CD  8c89                              mov.b   14h+var_1[sp], r1
FFF294CF  391400                            bsr.w   sub_FFF294E3
FFF294D2  a081                              mov.l   r1, 14h+var_C[sp]
FFF294D4  a809                              mov.l   14h+var_10[sp], r1
FFF294D6  05d0c9fe                          bsr.a   sub_FFF15EA6
FFF294DA  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF294DD  ec01                   loc_FFF294DD mov.l   14h+var_14[sp], r1
FFF294DF  a089                              mov.l   r1, 14h+var_8[sp]
FFF294E1  6705                              rtsd    #5
FFF294E3  7100e4                 sub_FFF294E3 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF294E3
FFF294E6  8689                              mov.b   r1, 1Ch+var_1[sp]
FFF294E8  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF294EA  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF294F0  e4e002                            mov.l   [r14], 1Ch+var_14[sp]
FFF294F3  05f8baff                          bsr.a   sub_FFF24FEB
FFF294F7  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF294F9  a889                              mov.l   1Ch+var_10[sp], r1
FFF294FB  6101                              cmp     #0, r1
FFF294FD  200e                              beq.b   loc_FFF2950B
FFF294FF  a889                              mov.l   1Ch+var_10[sp], r1
FFF29501  6602                              mov.l   #0, r2
FFF29503  051d59ff                          bsr.a   sub_FFF1EE20
FFF29507  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF29509  2e52                              bra.b   loc_FFF2955B
FFF2950B  8e89                   loc_FFF2950B mov.b   1Ch+var_1[sp], r1
FFF2950D  057e5200                          bsr.a   sub_FFF2E78B
FFF29511  8189                              mov.b   r1, 1Ch+var_15[sp]
FFF29513  b189                              movu.b  1Ch+var_15[sp], r1
FFF29515  710208                            add     #1Ch+var_14, sp, r2
FFF29518  05075aff                          bsr.a   sub_FFF1EF1F
FFF2951C  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2951E  a889                              mov.l   1Ch+var_10[sp], r1
FFF29520  6101                              cmp     #0, r1
FFF29522  200e                              beq.b   loc_FFF29530
FFF29524  a889                              mov.l   1Ch+var_10[sp], r1
FFF29526  6602                              mov.l   #0, r2
FFF29528  05f858ff                          bsr.a   sub_FFF1EE20
FFF2952C  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2952E  2e2d                              bra.b   loc_FFF2955B
FFF29530  a90a                   loc_FFF29530 mov.l   1Ch+var_8[sp], r2
FFF29532  a881                              mov.l   1Ch+var_14[sp], r1
FFF29534  392d00                            bsr.w   sub_FFF29561
FFF29537  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF29539  a889                              mov.l   1Ch+var_10[sp], r1
FFF2953B  6101                              cmp     #0, r1
FFF2953D  210f                              bne.b   loc_FFF2954C
FFF2953F  a881                              mov.l   1Ch+var_14[sp], r1
FFF29541  8c11                              mov.b   10h[r1], r1
FFF29543  755120                            cmp     #20h, r1 ; ' '
FFF29546  16                                beq.s   loc_FFF2954C
FFF29547  a881                              mov.l   1Ch+var_14[sp], r1
FFF29549  3e1a02                            mov.l   #2, 28h[r1]
FFF2954C  a881                   loc_FFF2954C mov.l   1Ch+var_14[sp], r1
FFF2954E  f1186c                            bclr    #0, 6Ch[r1].b
FFF29551  a889                              mov.l   1Ch+var_10[sp], r1
FFF29553  6602                              mov.l   #0, r2
FFF29555  05cb58ff                          bsr.a   sub_FFF1EE20
FFF29559  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2955B  ec01                   loc_FFF2955B mov.l   1Ch+var_1C[sp], r1
FFF2955D  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF2955F  6707                              rtsd    #7
FFF29561  7100d4                 sub_FFF29561 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF29561
FFF29564  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF29566  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF29568  3e0500                            mov.l   #0, 2Ch+var_18[sp]
FFF2956B  3e0400                            mov.l   #0, 2Ch+var_1C[sp]
FFF2956E  aa81                              mov.l   2Ch+var_4[sp], r1
FFF29570  b899                              movu.w  6[r1], r1
FFF29572  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF29574  aa09                              mov.l   2Ch+var_8[sp], r1
FFF29576  72110c0c                          add     #0C0Ch, r1, r1
FFF2957A  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF2957C  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2957E  05df59ff                          bsr.a   sub_FFF1EF5D
FFF29582  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF29584  a989                              mov.l   2Ch+var_10[sp], r1
FFF29586  6101                              cmp     #0, r1
FFF29588  10                                beq.s   loc_FFF29590
FFF29589  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF2958D  38b503                            bra.w   loc_FFF29942
FFF29590  aa81                   loc_FFF29590 mov.l   2Ch+var_4[sp], r1
FFF29592  05ff59ff                          bsr.a   sub_FFF1EF91
FFF29596  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF29598  a989                              mov.l   2Ch+var_10[sp], r1
FFF2959A  6101                              cmp     #0, r1
FFF2959C  10                                beq.s   loc_FFF295A4
FFF2959D  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF295A1  38a103                            bra.w   loc_FFF29942
FFF295A4  a883                   loc_FFF295A4 mov.l   2Ch+var_24[sp], r3
FFF295A6  a88a                              mov.l   2Ch+var_20[sp], r2
FFF295A8  aa81                              mov.l   2Ch+var_4[sp], r1
FFF295AA  6614                              mov.l   #1, r4
FFF295AC  05655aff                          bsr.a   sub_FFF1F011
FFF295B0  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF295B2  a989                              mov.l   2Ch+var_10[sp], r1
FFF295B4  6101                              cmp     #0, r1
FFF295B6  10                                beq.s   loc_FFF295BE
FFF295B7  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF295BB  388703                            bra.w   loc_FFF29942
FFF295BE  aa81                   loc_FFF295BE mov.l   2Ch+var_4[sp], r1
FFF295C0  8c11                              mov.b   10h[r1], r1
FFF295C2  61c1                              cmp     #0Ch, r1
FFF295C4  2116                              bne.b   loc_FFF295DA
FFF295C6  a881                              mov.l   2Ch+var_24[sp], r1
FFF295C8  6231                              add     #3, r1
FFF295CA  fb4a0002                          mov.l   #200h, r4
FFF295CE  fb3afd01                          mov.l   #1FDh, r3
FFF295D2  6602                              mov.l   #0, r2
FFF295D4  05db4e00                          bsr.a   sub_FFF2E4AF
FFF295D8  2e42                              bra.b   loc_FFF2961A
FFF295DA  aa81                   loc_FFF295DA mov.l   2Ch+var_4[sp], r1
FFF295DC  8c11                              mov.b   10h[r1], r1
FFF295DE  755110                            cmp     #10h, r1
FFF295E1  2116                              bne.b   loc_FFF295F7
FFF295E3  a881                              mov.l   2Ch+var_24[sp], r1
FFF295E5  6241                              add     #4, r1
FFF295E7  fb4a0002                          mov.l   #200h, r4
FFF295EB  fb3afc01                          mov.l   #1FCh, r3
FFF295EF  6602                              mov.l   #0, r2
FFF295F1  05be4e00                          bsr.a   sub_FFF2E4AF
FFF295F5  2e25                              bra.b   loc_FFF2961A
FFF295F7  aa81                   loc_FFF295F7 mov.l   2Ch+var_4[sp], r1
FFF295F9  8c11                              mov.b   10h[r1], r1
FFF295FB  755120                            cmp     #20h, r1 ; ' '
FFF295FE  2115                              bne.b   loc_FFF29613
FFF29600  a881                              mov.l   2Ch+var_24[sp], r1
FFF29602  62c1                              add     #0Ch, r1
FFF29604  fb4a0002                          mov.l   #200h, r4
FFF29608  fb3af401                          mov.l   #1F4h, r3
FFF2960C  6602                              mov.l   #0, r2
FFF2960E  05a14e00                          bsr.a   sub_FFF2E4AF
FFF29612  08                                bra.s   loc_FFF2961A
FFF29613  f90601f3               loc_FFF29613 mov.l   #-0Dh, 2Ch+var_28[sp]
FFF29617  382b03                            bra.w   loc_FFF29942
FFF2961A  aa81                   loc_FFF2961A mov.l   2Ch+var_4[sp], r1
FFF2961C  8c11                              mov.b   10h[r1], r1
FFF2961E  755120                            cmp     #20h, r1 ; ' '
FFF29621  2155                              bne.b   loc_FFF29676
FFF29623  aa81                              mov.l   2Ch+var_4[sp], r1
FFF29625  ab1a                              mov.l   34h[r1], r2
FFF29627  ad99                              mov.l   5Ch[r1], r1
FFF29629  6821                              shlr    #2, r1
FFF2962B  fc2712                            divu    r1, r2
FFF2962E  a10a                              mov.l   r2, 2Ch+var_18[sp]
FFF29630  aa81                              mov.l   2Ch+var_4[sp], r1
FFF29632  ab1a                              mov.l   34h[r1], r2
FFF29634  ad99                              mov.l   5Ch[r1], r1
FFF29636  6821                              shlr    #2, r1
FFF29638  ef2e                              mov.l   r2, r14
FFF2963A  fc271e                            divu    r1, r14
FFF2963D  4f1e                              mul     r1, r14
FFF2963F  43e2                              sub     r14, r2
FFF29641  a102                              mov.l   r2, 2Ch+var_1C[sp]
FFF29643  a909                              mov.l   2Ch+var_18[sp], r1
FFF29645  6101                              cmp     #0, r1
FFF29647  210c                              bne.b   loc_FFF29653
FFF29649  a901                              mov.l   2Ch+var_1C[sp], r1
FFF2964B  6121                              cmp     #2, r1
FFF2964D  2306                              bltu.b  loc_FFF29653
FFF2964F  f80601                            mov.l   #1, 2Ch+var_2C[sp]
FFF29652  0c                                bra.s   loc_FFF29656
FFF29653  f80600                 loc_FFF29653 mov.l   #0, 2Ch+var_2C[sp]
FFF29656  ec01                   loc_FFF29656 mov.l   2Ch+var_2C[sp], r1
FFF29658  6101                              cmp     #0, r1
FFF2965A  2016                              beq.b   loc_FFF29670
FFF2965C  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2965E  ab19                              mov.l   34h[r1], r1
FFF29660  6c21                              shll    #2, r1
FFF29662  06890102                          add     2Ch+var_24[sp].l, r1
FFF29666  fb22ffffff0f                      mov.l   #0FFFFFFFh, r2
FFF2966C  05675600                          bsr.a   sub_FFF2ECD3
FFF29670  a901                   loc_FFF29670 mov.l   2Ch+var_1C[sp], r1
FFF29672  6c21                              shll    #2, r1
FFF29674  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF29676  a883                   loc_FFF29676 mov.l   2Ch+var_24[sp], r3
FFF29678  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2967A  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2967C  6614                              mov.l   #1, r4
FFF2967E  05245aff                          bsr.a   sub_FFF1F0A2
FFF29682  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF29684  a989                              mov.l   2Ch+var_10[sp], r1
FFF29686  6101                              cmp     #0, r1
FFF29688  10                                beq.s   loc_FFF29690
FFF29689  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF2968D  38b502                            bra.w   loc_FFF29942
FFF29690  aa81                   loc_FFF29690 mov.l   2Ch+var_4[sp], r1
FFF29692  b911                              movu.w  8[r1], r1
FFF29694  6121                              cmp     #2, r1
FFF29696  2920                              blt.b   loc_FFF296B6
FFF29698  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2969A  a89a                              mov.l   0Ch[r1], r2
FFF2969C  06890203                          add     2Ch+var_20[sp].l, r2
FFF296A0  a883                              mov.l   2Ch+var_24[sp], r3
FFF296A2  6614                              mov.l   #1, r4
FFF296A4  05fe59ff                          bsr.a   sub_FFF1F0A2
FFF296A8  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF296AA  a989                              mov.l   2Ch+var_10[sp], r1
FFF296AC  6101                              cmp     #0, r1
FFF296AE  10                                beq.s   loc_FFF296B6
FFF296AF  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF296B3  388f02                            bra.w   loc_FFF29942
FFF296B6  a881                   loc_FFF296B6 mov.l   2Ch+var_24[sp], r1
FFF296B8  fb3a0002                          mov.l   #200h, r3
FFF296BC  6602                              mov.l   #0, r2
FFF296BE  ef34                              mov.l   r3, r4
FFF296C0  05ef4d00                          bsr.a   sub_FFF2E4AF
FFF296C4  3e0601                            mov.l   #1, 2Ch+var_14[sp]
FFF296C7  2e78                              bra.b   loc_FFF2973F
FFF296C9  755120                 loc_FFF296C9 cmp     #20h, r1 ; ' '
FFF296CC  210d                              bne.b   loc_FFF296D9
FFF296CE  a909                              mov.l   2Ch+var_18[sp], r1
FFF296D0  06850106                          cmp     2Ch+var_14[sp].l, r1
FFF296D4  1d                                bne.s   loc_FFF296D9
FFF296D5  f80601                            mov.l   #1, 2Ch+var_2C[sp]
FFF296D8  0c                                bra.s   loc_FFF296DC
FFF296D9  f80600                 loc_FFF296D9 mov.l   #0, 2Ch+var_2C[sp]
FFF296DC  ec01                   loc_FFF296DC mov.l   2Ch+var_2C[sp], r1
FFF296DE  6101                              cmp     #0, r1
FFF296E0  2012                              beq.b   loc_FFF296F2
FFF296E2  a881                              mov.l   2Ch+var_24[sp], r1
FFF296E4  06890104                          add     2Ch+var_1C[sp].l, r1
FFF296E8  fb22ffffff0f                      mov.l   #0FFFFFFFh, r2
FFF296EE  05e55500                          bsr.a   sub_FFF2ECD3
FFF296F2  a88a                   loc_FFF296F2 mov.l   2Ch+var_20[sp], r2
FFF296F4  06890206                          add     2Ch+var_14[sp].l, r2
FFF296F8  a883                              mov.l   2Ch+var_24[sp], r3
FFF296FA  aa81                              mov.l   2Ch+var_4[sp], r1
FFF296FC  6614                              mov.l   #1, r4
FFF296FE  05a459ff                          bsr.a   sub_FFF1F0A2
FFF29702  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF29704  a989                              mov.l   2Ch+var_10[sp], r1
FFF29706  6101                              cmp     #0, r1
FFF29708  10                                beq.s   loc_FFF29710
FFF29709  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF2970D  383502                            bra.w   loc_FFF29942
FFF29710  aa81                   loc_FFF29710 mov.l   2Ch+var_4[sp], r1
FFF29712  8c11                              mov.b   10h[r1], r1
FFF29714  755120                            cmp     #20h, r1 ; ' '
FFF29717  210d                              bne.b   loc_FFF29724
FFF29719  a909                              mov.l   2Ch+var_18[sp], r1
FFF2971B  06850106                          cmp     2Ch+var_14[sp].l, r1
FFF2971F  1d                                bne.s   loc_FFF29724
FFF29720  f80601                            mov.l   #1, 2Ch+var_2C[sp]
FFF29723  0c                                bra.s   loc_FFF29727
FFF29724  f80600                 loc_FFF29724 mov.l   #0, 2Ch+var_2C[sp]
FFF29727  ec01                   loc_FFF29727 mov.l   2Ch+var_2C[sp], r1
FFF29729  6101                              cmp     #0, r1
FFF2972B  200e                              beq.b   loc_FFF29739
FFF2972D  a881                              mov.l   2Ch+var_24[sp], r1
FFF2972F  06890104                          add     2Ch+var_1C[sp].l, r1
FFF29733  6602                              mov.l   #0, r2
FFF29735  059e5500                          bsr.a   sub_FFF2ECD3
FFF29739  a981                   loc_FFF29739 mov.l   2Ch+var_14[sp], r1
FFF2973B  6211                              add     #1, r1
FFF2973D  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF2973F  aa81                   loc_FFF2973F mov.l   2Ch+var_4[sp], r1
FFF29741  a982                              mov.l   2Ch+var_14[sp], r2
FFF29743  06851203                          cmp     0Ch[r1].l, r2
FFF29747  8c11                              mov.b   10h[r1], r1
FFF29749  2205                              bgeu.b  loc_FFF2974E
FFF2974B  387eff                            bra.w   loc_FFF296C9
FFF2974E  aa82                   loc_FFF2974E mov.l   2Ch+var_4[sp], r2
FFF29750  a8ab                              mov.l   0Ch[r2], r3
FFF29752  06cd2304                          mul     8[r2].uw, r3
FFF29756  06c92303                          add     6[r2].uw, r3
FFF2975A  a08b                              mov.l   r3, 2Ch+var_20[sp]
FFF2975C  755120                            cmp     #20h, r1 ; ' '
FFF2975F  3bc900                            bne.w   loc_FFF29828
FFF29762  aa81                              mov.l   2Ch+var_4[sp], r1
FFF29764  ab19                              mov.l   34h[r1], r1
FFF29766  6121                              cmp     #2, r1
FFF29768  2312                              bltu.b  loc_FFF2977A
FFF2976A  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2976C  ab1a                              mov.l   34h[r1], r2
FFF2976E  6022                              sub     #2, r2
FFF29770  06cd1202                          mul     4[r1].uw, r2
FFF29774  06890203                          add     2Ch+var_20[sp].l, r2
FFF29778  a08a                              mov.l   r2, 2Ch+var_20[sp]
FFF2977A  3e0600                 loc_FFF2977A mov.l   #0, 2Ch+var_14[sp]
FFF2977D  2e24                              bra.b   loc_FFF297A1
FFF2977F  a88a                   loc_FFF2977F mov.l   2Ch+var_20[sp], r2
FFF29781  06890206                          add     2Ch+var_14[sp].l, r2
FFF29785  a883                              mov.l   2Ch+var_24[sp], r3
FFF29787  6614                              mov.l   #1, r4
FFF29789  051959ff                          bsr.a   sub_FFF1F0A2
FFF2978D  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF2978F  a989                              mov.l   2Ch+var_10[sp], r1
FFF29791  6101                              cmp     #0, r1
FFF29793  10                                beq.s   loc_FFF2979B
FFF29794  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF29798  38aa01                            bra.w   loc_FFF29942
FFF2979B  a981                   loc_FFF2979B mov.l   2Ch+var_14[sp], r1
FFF2979D  6211                              add     #1, r1
FFF2979F  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF297A1  aa81                   loc_FFF297A1 mov.l   2Ch+var_4[sp], r1
FFF297A3  b892                              movu.w  4[r1], r2
FFF297A5  06850206                          cmp     2Ch+var_14[sp].l, r2
FFF297A9  24d6                              bgtu.b  loc_FFF2977F
FFF297AB  aa82                              mov.l   2Ch+var_4[sp], r2
FFF297AD  adab                              mov.l   5Ch[r2], r3
FFF297AF  6823                              shlr    #2, r3
FFF297B1  068d2303                          mul     0Ch[r2].l, r3
FFF297B5  a39b                              mov.l   r3, 3Ch[r1]
FFF297B7  aa81                              mov.l   2Ch+var_4[sp], r1
FFF297B9  a89a                              mov.l   0Ch[r1], r2
FFF297BB  06cd1204                          mul     8[r1].uw, r2
FFF297BF  06c91203                          add     6[r1].uw, r2
FFF297C3  b91b                              movu.w  0Ah[r1], r3
FFF297C5  6c53                              shll    #5, r3
FFF297C7  06a1091317                        divu    5Ch[r1].l, r3
FFF297CC  4b32                              add     r3, r2
FFF297CE  a91b                              mov.l   14h[r1], r3
FFF297D0  4323                              sub     r2, r3
FFF297D2  06e1091302                        divu    4[r1].uw, r3
FFF297D7  6223                              add     #2, r3
FFF297D9  0685130f                          cmp     3Ch[r1].l, r3
FFF297DD  2226                              bgeu.b  loc_FFF29803
FFF297DF  aa81                              mov.l   2Ch+var_4[sp], r1
FFF297E1  a89a                              mov.l   0Ch[r1], r2
FFF297E3  06cd1204                          mul     8[r1].uw, r2
FFF297E7  06c91203                          add     6[r1].uw, r2
FFF297EB  b91b                              movu.w  0Ah[r1], r3
FFF297ED  6c53                              shll    #5, r3
FFF297EF  06a1091317                        divu    5Ch[r1].l, r3
FFF297F4  4b32                              add     r3, r2
FFF297F6  a91b                              mov.l   14h[r1], r3
FFF297F8  4323                              sub     r2, r3
FFF297FA  06e1091302                        divu    4[r1].uw, r3
FFF297FF  6223                              add     #2, r3
FFF29801  a39b                              mov.l   r3, 3Ch[r1]
FFF29803  aa81                   loc_FFF29803 mov.l   2Ch+var_4[sp], r1
FFF29805  ab9a                              mov.l   3Ch[r1], r2
FFF29807  6032                              sub     #3, r2
FFF29809  a39a                              mov.l   r2, 3Ch[r1]
FFF2980B  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2980D  3e1a03                            mov.l   #3, 28h[r1]
FFF29810  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF29812  aa81                              mov.l   2Ch+var_4[sp], r1
FFF29814  050eb1ff                          bsr.a   sub_FFF24922
FFF29818  a881                              mov.l   2Ch+var_24[sp], r1
FFF2981A  fb3a0002                          mov.l   #200h, r3
FFF2981E  6602                              mov.l   #0, r2
FFF29820  ef34                              mov.l   r3, r4
FFF29822  058d4c00                          bsr.a   sub_FFF2E4AF
FFF29826  2e3c                              bra.b   loc_FFF29862
FFF29828  3e0600                 loc_FFF29828 mov.l   #0, 2Ch+var_14[sp]
FFF2982B  2e26                              bra.b   loc_FFF29851
FFF2982D  a88a                   loc_FFF2982D mov.l   2Ch+var_20[sp], r2
FFF2982F  06890206                          add     2Ch+var_14[sp].l, r2
FFF29833  a883                              mov.l   2Ch+var_24[sp], r3
FFF29835  aa81                              mov.l   2Ch+var_4[sp], r1
FFF29837  6614                              mov.l   #1, r4
FFF29839  056958ff                          bsr.a   sub_FFF1F0A2
FFF2983D  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF2983F  a989                              mov.l   2Ch+var_10[sp], r1
FFF29841  6101                              cmp     #0, r1
FFF29843  10                                beq.s   loc_FFF2984B
FFF29844  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF29848  38fa00                            bra.w   loc_FFF29942
FFF2984B  a981                   loc_FFF2984B mov.l   2Ch+var_14[sp], r1
FFF2984D  6211                              add     #1, r1
FFF2984F  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF29851  aa81                   loc_FFF29851 mov.l   2Ch+var_4[sp], r1
FFF29853  b91a                              movu.w  0Ah[r1], r2
FFF29855  ad99                              mov.l   5Ch[r1], r1
FFF29857  6851                              shlr    #5, r1
FFF29859  fc2712                            divu    r1, r2
FFF2985C  06850206                          cmp     2Ch+var_14[sp].l, r2
FFF29860  24cd                              bgtu.b  loc_FFF2982D
FFF29862  aa81                   loc_FFF29862 mov.l   2Ch+var_4[sp], r1
FFF29864  b911                              movu.w  8[r1], r1
FFF29866  6111                              cmp     #1, r1
FFF29868  2a08                              bgt.b   loc_FFF29870
FFF2986A  3e0100                            mov.l   #0, 2Ch+var_28[sp]
FFF2986D  38d500                            bra.w   loc_FFF29942
FFF29870  aa81                   loc_FFF29870 mov.l   2Ch+var_4[sp], r1
FFF29872  b89a                              movu.w  6[r1], r2
FFF29874  06891203                          add     0Ch[r1].l, r2
FFF29878  a08a                              mov.l   r2, 2Ch+var_20[sp]
FFF2987A  3e0601                            mov.l   #1, 2Ch+var_14[sp]
FFF2987D  2e79                              bra.b   loc_FFF298F6
FFF2987F  8c11                   loc_FFF2987F mov.b   10h[r1], r1
FFF29881  755120                            cmp     #20h, r1 ; ' '
FFF29884  210d                              bne.b   loc_FFF29891
FFF29886  a909                              mov.l   2Ch+var_18[sp], r1
FFF29888  06850106                          cmp     2Ch+var_14[sp].l, r1
FFF2988C  1d                                bne.s   loc_FFF29891
FFF2988D  f80601                            mov.l   #1, 2Ch+var_2C[sp]
FFF29890  0c                                bra.s   loc_FFF29894
FFF29891  f80600                 loc_FFF29891 mov.l   #0, 2Ch+var_2C[sp]
FFF29894  ec01                   loc_FFF29894 mov.l   2Ch+var_2C[sp], r1
FFF29896  6101                              cmp     #0, r1
FFF29898  2012                              beq.b   loc_FFF298AA
FFF2989A  a881                              mov.l   2Ch+var_24[sp], r1
FFF2989C  06890104                          add     2Ch+var_1C[sp].l, r1
FFF298A0  fb22ffffff0f                      mov.l   #0FFFFFFFh, r2
FFF298A6  052d5400                          bsr.a   sub_FFF2ECD3
FFF298AA  a88a                   loc_FFF298AA mov.l   2Ch+var_20[sp], r2
FFF298AC  06890206                          add     2Ch+var_14[sp].l, r2
FFF298B0  a883                              mov.l   2Ch+var_24[sp], r3
FFF298B2  aa81                              mov.l   2Ch+var_4[sp], r1
FFF298B4  6614                              mov.l   #1, r4
FFF298B6  05ec57ff                          bsr.a   sub_FFF1F0A2
FFF298BA  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF298BC  a989                              mov.l   2Ch+var_10[sp], r1
FFF298BE  6101                              cmp     #0, r1
FFF298C0  17                                beq.s   loc_FFF298C7
FFF298C1  e5000701                          mov.l   2Ch+var_10[sp], 2Ch+var_28[sp]
FFF298C5  2e7d                              bra.b   loc_FFF29942
FFF298C7  aa81                   loc_FFF298C7 mov.l   2Ch+var_4[sp], r1
FFF298C9  8c11                              mov.b   10h[r1], r1
FFF298CB  755120                            cmp     #20h, r1 ; ' '
FFF298CE  210d                              bne.b   loc_FFF298DB
FFF298D0  a909                              mov.l   2Ch+var_18[sp], r1
FFF298D2  06850106                          cmp     2Ch+var_14[sp].l, r1
FFF298D6  1d                                bne.s   loc_FFF298DB
FFF298D7  f80601                            mov.l   #1, 2Ch+var_2C[sp]
FFF298DA  0c                                bra.s   loc_FFF298DE
FFF298DB  f80600                 loc_FFF298DB mov.l   #0, 2Ch+var_2C[sp]
FFF298DE  ec01                   loc_FFF298DE mov.l   2Ch+var_2C[sp], r1
FFF298E0  6101                              cmp     #0, r1
FFF298E2  200e                              beq.b   loc_FFF298F0
FFF298E4  a881                              mov.l   2Ch+var_24[sp], r1
FFF298E6  06890104                          add     2Ch+var_1C[sp].l, r1
FFF298EA  6602                              mov.l   #0, r2
FFF298EC  05e75300                          bsr.a   sub_FFF2ECD3
FFF298F0  a981                   loc_FFF298F0 mov.l   2Ch+var_14[sp], r1
FFF298F2  6211                              add     #1, r1
FFF298F4  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF298F6  aa81                   loc_FFF298F6 mov.l   2Ch+var_4[sp], r1
FFF298F8  a982                              mov.l   2Ch+var_14[sp], r2
FFF298FA  06851203                          cmp     0Ch[r1].l, r2
FFF298FE  2205                              bgeu.b  loc_FFF29903
FFF29900  387fff                            bra.w   loc_FFF2987F
FFF29903  ac19                   loc_FFF29903 mov.l   44h[r1], r1
FFF29905  6101                              cmp     #0, r1
FFF29907  2019                              beq.b   loc_FFF29920
FFF29909  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2990B  5d1324                            movu.w  48h[r1], r3
FFF2990E  06cd1325                          mul     4Ah[r1].uw, r3
FFF29912  ad9c                              mov.l   5Ch[r1], r4
FFF29914  ac19                              mov.l   44h[r1], r1
FFF29916  76130602                          mul     #206h, r3
FFF2991A  6602                              mov.l   #0, r2
FFF2991C  05934b00                          bsr.a   sub_FFF2E4AF
FFF29920  aa81                   loc_FFF29920 mov.l   2Ch+var_4[sp], r1
FFF29922  ac99                              mov.l   4Ch[r1], r1
FFF29924  6101                              cmp     #0, r1
FFF29926  2019                              beq.b   loc_FFF2993F
FFF29928  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2992A  5d1328                            movu.w  50h[r1], r3
FFF2992D  06cd1329                          mul     52h[r1].uw, r3
FFF29931  ad9c                              mov.l   5Ch[r1], r4
FFF29933  ac99                              mov.l   4Ch[r1], r1
FFF29935  76130802                          mul     #208h, r3
FFF29939  6602                              mov.l   #0, r2
FFF2993B  05744b00                          bsr.a   sub_FFF2E4AF
FFF2993F  3e0100                 loc_FFF2993F mov.l   #0, 2Ch+var_28[sp]
FFF29942  a809                   loc_FFF29942 mov.l   2Ch+var_28[sp], r1
FFF29944  a201                              mov.l   r1, 2Ch+var_C[sp]
FFF29946  670b                              rtsd    #0Bh
FFF29948  7100ec                 sub_FFF29948 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF29948
FFF2994B  8489                              mov.b   r1, 14h+var_1[sp]
FFF2994D  0549c5fe                          bsr.a   sub_FFF15E96
FFF29951  a009                              mov.l   r1, 14h+var_10[sp]
FFF29953  a809                              mov.l   14h+var_10[sp], r1
FFF29955  6101                              cmp     #0, r1
FFF29957  210f                              bne.b   loc_FFF29966
FFF29959  6602                              mov.l   #0, r2
FFF2995B  fb16e1                            mov.l   #-1Fh, r1
FFF2995E  05c254ff                          bsr.a   sub_FFF1EE20
FFF29962  e301                              mov.l   r1, 14h+var_14[sp]
FFF29964  2e14                              bra.b   loc_FFF29978
FFF29966  a80a                   loc_FFF29966 mov.l   14h+var_10[sp], r2
FFF29968  8c89                              mov.b   14h+var_1[sp], r1
FFF2996A  391400                            bsr.w   sub_FFF2997E
FFF2996D  a081                              mov.l   r1, 14h+var_C[sp]
FFF2996F  a809                              mov.l   14h+var_10[sp], r1
FFF29971  0535c5fe                          bsr.a   sub_FFF15EA6
FFF29975  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF29978  ec01                   loc_FFF29978 mov.l   14h+var_14[sp], r1
FFF2997A  a089                              mov.l   r1, 14h+var_8[sp]
FFF2997C  6705                              rtsd    #5
FFF2997E  7100e0                 sub_FFF2997E add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2997E
FFF29981  8789                              mov.b   r1, 20h+var_1[sp]
FFF29983  a182                              mov.l   r2, 20h+var_8[sp]
FFF29985  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2998B  e4e003                            mov.l   [r14], 20h+var_14[sp]
FFF2998E  055db6ff                          bsr.a   sub_FFF24FEB
FFF29992  a101                              mov.l   r1, 20h+var_10[sp]
FFF29994  a901                              mov.l   20h+var_10[sp], r1
FFF29996  6101                              cmp     #0, r1
FFF29998  200f                              beq.b   loc_FFF299A7
FFF2999A  a901                              mov.l   20h+var_10[sp], r1
FFF2999C  6602                              mov.l   #0, r2
FFF2999E  058254ff                          bsr.a   sub_FFF1EE20
FFF299A2  a009                              mov.l   r1, 20h+var_1C[sp]
FFF299A4  388800                            bra.w   loc_FFF29A2C
FFF299A7  8f89                   loc_FFF299A7 mov.b   20h+var_1[sp], r1
FFF299A9  05e24d00                          bsr.a   sub_FFF2E78B
FFF299AD  8289                              mov.b   r1, 20h+var_15[sp]
FFF299AF  b289                              movu.b  20h+var_15[sp], r1
FFF299B1  71020c                            add     #20h+var_14, sp, r2
FFF299B4  056b55ff                          bsr.a   sub_FFF1EF1F
FFF299B8  a101                              mov.l   r1, 20h+var_10[sp]
FFF299BA  a901                              mov.l   20h+var_10[sp], r1
FFF299BC  6101                              cmp     #0, r1
FFF299BE  200e                              beq.b   loc_FFF299CC
FFF299C0  a901                              mov.l   20h+var_10[sp], r1
FFF299C2  6602                              mov.l   #0, r2
FFF299C4  055c54ff                          bsr.a   sub_FFF1EE20
FFF299C8  a009                              mov.l   r1, 20h+var_1C[sp]
FFF299CA  2e62                              bra.b   loc_FFF29A2C
FFF299CC  a889                   loc_FFF299CC mov.l   20h+var_14[sp], r1
FFF299CE  591e6c                            movu.b  6Ch[r1], r14
FFF299D1  641e                              and     #1, r14
FFF299D3  611e                              cmp     #1, r14
FFF299D5  200e                              beq.b   loc_FFF299E3
FFF299D7  a889                              mov.l   20h+var_14[sp], r1
FFF299D9  591e6c                            movu.b  6Ch[r1], r14
FFF299DC  752e10                            and     #10h, r14
FFF299DF  755e10                            cmp     #10h, r14
FFF299E2  1d                                bne.s   loc_FFF299E7
FFF299E3  f80601                 loc_FFF299E3 mov.l   #1, 20h+var_20[sp]
FFF299E6  0c                                bra.s   loc_FFF299EA
FFF299E7  f80600                 loc_FFF299E7 mov.l   #0, 20h+var_20[sp]
FFF299EA  ec01                   loc_FFF299EA mov.l   20h+var_20[sp], r1
FFF299EC  6101                              cmp     #0, r1
FFF299EE  a889                              mov.l   20h+var_14[sp], r1
FFF299F0  202b                              beq.b   loc_FFF29A1B
FFF299F2  05f1c3fe                          bsr.a   sub_FFF15DE3
FFF299F6  a101                              mov.l   r1, 20h+var_10[sp]
FFF299F8  a901                              mov.l   20h+var_10[sp], r1
FFF299FA  6101                              cmp     #0, r1
FFF299FC  200f                              beq.b   loc_FFF29A0B
FFF299FE  6602                              mov.l   #0, r2
FFF29A00  fb16c1                            mov.l   #-3Fh, r1
FFF29A03  051d54ff                          bsr.a   sub_FFF1EE20
FFF29A07  a009                              mov.l   r1, 20h+var_1C[sp]
FFF29A09  2e23                              bra.b   loc_FFF29A2C
FFF29A0B  a982                   loc_FFF29A0B mov.l   20h+var_8[sp], r2
FFF29A0D  a889                              mov.l   20h+var_14[sp], r1
FFF29A0F  392300                            bsr.w   sub_FFF29A32
FFF29A12  a101                              mov.l   r1, 20h+var_10[sp]
FFF29A14  a889                              mov.l   20h+var_14[sp], r1
FFF29A16  05d8c3fe                          bsr.a   sub_FFF15DEE
FFF29A1A  08                                bra.s   loc_FFF29A22
FFF29A1B  a982                   loc_FFF29A1B mov.l   20h+var_8[sp], r2
FFF29A1D  391500                            bsr.w   sub_FFF29A32
FFF29A20  a101                              mov.l   r1, 20h+var_10[sp]
FFF29A22  a901                   loc_FFF29A22 mov.l   20h+var_10[sp], r1
FFF29A24  6602                              mov.l   #0, r2
FFF29A26  05fa53ff                          bsr.a   sub_FFF1EE20
FFF29A2A  a009                              mov.l   r1, 20h+var_1C[sp]
FFF29A2C  a809                   loc_FFF29A2C mov.l   20h+var_1C[sp], r1
FFF29A2E  a109                              mov.l   r1, 20h+var_C[sp]
FFF29A30  6708                              rtsd    #8
FFF29A32  7100e4                 sub_FFF29A32 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF29A32
FFF29A35  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF29A37  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF29A39  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF29A3C  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF29A3F  a981                              mov.l   1Ch+var_4[sp], r1
FFF29A41  8c11                              mov.b   10h[r1], r1
FFF29A43  755120                            cmp     #20h, r1 ; ' '
FFF29A46  16                                beq.s   loc_FFF29A4C
FFF29A47  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF29A4A  2e5c                              bra.b   loc_FFF29AA6
FFF29A4C  a981                   loc_FFF29A4C mov.l   1Ch+var_4[sp], r1
FFF29A4E  050f55ff                          bsr.a   sub_FFF1EF5D
FFF29A52  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF29A54  a889                              mov.l   1Ch+var_10[sp], r1
FFF29A56  6101                              cmp     #0, r1
FFF29A58  16                                beq.s   loc_FFF29A5E
FFF29A59  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF29A5C  2e4a                              bra.b   loc_FFF29AA6
FFF29A5E  a981                   loc_FFF29A5E mov.l   1Ch+var_4[sp], r1
FFF29A60  053155ff                          bsr.a   sub_FFF1EF91
FFF29A64  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF29A66  a889                              mov.l   1Ch+var_10[sp], r1
FFF29A68  6101                              cmp     #0, r1
FFF29A6A  16                                beq.s   loc_FFF29A70
FFF29A6B  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF29A6E  2e38                              bra.b   loc_FFF29AA6
FFF29A70  a90c                   loc_FFF29A70 mov.l   1Ch+var_8[sp], r4
FFF29A72  a981                              mov.l   1Ch+var_4[sp], r1
FFF29A74  6040                              sub     #4, sp
FFF29A76  f80400                            mov.b   #0, 20h+var_20[sp]
FFF29A79  710308                            add     #20h+var_18, sp, r3
FFF29A7C  71020c                            add     #20h+var_14, sp, r2
FFF29A7F  3906f8                            bsr.w   sub_FFF29285
FFF29A82  6240                              add     #4, sp
FFF29A84  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF29A86  a889                              mov.l   1Ch+var_10[sp], r1
FFF29A88  6101                              cmp     #0, r1
FFF29A8A  16                                beq.s   loc_FFF29A90
FFF29A8B  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF29A8E  2e18                              bra.b   loc_FFF29AA6
FFF29A90  a90a                   loc_FFF29A90 mov.l   1Ch+var_8[sp], r2
FFF29A92  a981                              mov.l   1Ch+var_4[sp], r1
FFF29A94  058eaeff                          bsr.a   sub_FFF24922
FFF29A98  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF29A9A  a889                              mov.l   1Ch+var_10[sp], r1
FFF29A9C  6101                              cmp     #0, r1
FFF29A9E  15                                beq.s   loc_FFF29AA3
FFF29A9F  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF29AA2  0c                                bra.s   loc_FFF29AA6
FFF29AA3  f80600                 loc_FFF29AA3 mov.l   #0, 1Ch+var_1C[sp]
FFF29AA6  ec01                   loc_FFF29AA6 mov.l   1Ch+var_1C[sp], r1
FFF29AA8  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF29AAA  6707                              rtsd    #7
FFF29AAC  7100e8                 sub_FFF29AAC add     #-18h, sp, sp   ; <<<< FUNC sub_FFF29AAC
FFF29AAF  a109                              mov.l   r1, 18h+var_4[sp]
FFF29AB1  a102                              mov.l   r2, 18h+var_8[sp]
FFF29AB3  05e3c3fe                          bsr.a   sub_FFF15E96
FFF29AB7  a009                              mov.l   r1, 18h+var_14[sp]
FFF29AB9  a809                              mov.l   18h+var_14[sp], r1
FFF29ABB  6101                              cmp     #0, r1
FFF29ABD  210f                              bne.b   loc_FFF29ACC
FFF29ABF  6602                              mov.l   #0, r2
FFF29AC1  fb16e1                            mov.l   #-1Fh, r1
FFF29AC4  055c53ff                          bsr.a   sub_FFF1EE20
FFF29AC8  e301                              mov.l   r1, 18h+var_18[sp]
FFF29ACA  2e16                              bra.b   loc_FFF29AE0
FFF29ACC  a80b                   loc_FFF29ACC mov.l   18h+var_14[sp], r3
FFF29ACE  a902                              mov.l   18h+var_8[sp], r2
FFF29AD0  a909                              mov.l   18h+var_4[sp], r1
FFF29AD2  391400                            bsr.w   sub_FFF29AE6
FFF29AD5  a081                              mov.l   r1, 18h+var_10[sp]
FFF29AD7  a809                              mov.l   18h+var_14[sp], r1
FFF29AD9  05cdc3fe                          bsr.a   sub_FFF15EA6
FFF29ADD  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF29AE0  ec01                   loc_FFF29AE0 mov.l   18h+var_18[sp], r1
FFF29AE2  a089                              mov.l   r1, 18h+var_C[sp]
FFF29AE4  6706                              rtsd    #6
FFF29AE6  7ea6                   sub_FFF29AE6 push.l  r6   ; <<<< FUNC sub_FFF29AE6
FFF29AE8  7100dc                            add     #-24h, sp, sp
FFF29AEB  a201                              mov.l   r1, 24h+var_4[sp]
FFF29AED  a18a                              mov.l   r2, 24h+var_8[sp]
FFF29AEF  a183                              mov.l   r3, 24h+var_C[sp]
FFF29AF1  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF29AF7  e4e003                            mov.l   [r14], 24h+var_18[sp]
FFF29AFA  05f1b4ff                          bsr.a   sub_FFF24FEB
FFF29AFE  a101                              mov.l   r1, 24h+var_14[sp]
FFF29B00  a901                              mov.l   24h+var_14[sp], r1
FFF29B02  6101                              cmp     #0, r1
FFF29B04  200f                              beq.b   loc_FFF29B13
FFF29B06  a901                              mov.l   24h+var_14[sp], r1
FFF29B08  6602                              mov.l   #0, r2
FFF29B0A  051653ff                          bsr.a   sub_FFF1EE20
FFF29B0E  a009                              mov.l   r1, 24h+var_20[sp]
FFF29B10  38e101                            bra.w   loc_FFF29CF1
FFF29B13  aa01                   loc_FFF29B13 mov.l   24h+var_4[sp], r1
FFF29B15  6101                              cmp     #0, r1
FFF29B17  16                                beq.s   loc_FFF29B1D
FFF29B18  a989                              mov.l   24h+var_8[sp], r1
FFF29B1A  6101                              cmp     #0, r1
FFF29B1C  1d                                bne.s   loc_FFF29B21
FFF29B1D  f80601                 loc_FFF29B1D mov.l   #1, 24h+var_24[sp]
FFF29B20  0c                                bra.s   loc_FFF29B24
FFF29B21  f80600                 loc_FFF29B21 mov.l   #0, 24h+var_24[sp]
FFF29B24  ec01                   loc_FFF29B24 mov.l   24h+var_24[sp], r1
FFF29B26  6101                              cmp     #0, r1
FFF29B28  2010                              beq.b   loc_FFF29B38
FFF29B2A  6602                              mov.l   #0, r2
FFF29B2C  fb16ff                            mov.l   #-1, r1
FFF29B2F  05f152ff                          bsr.a   sub_FFF1EE20
FFF29B33  a009                              mov.l   r1, 24h+var_20[sp]
FFF29B35  38bc01                            bra.w   loc_FFF29CF1
FFF29B38  aa01                   loc_FFF29B38 mov.l   24h+var_4[sp], r1
FFF29B3A  05c19bff                          bsr.a   sub_FFF236FB
FFF29B3E  a101                              mov.l   r1, 24h+var_14[sp]
FFF29B40  a901                              mov.l   24h+var_14[sp], r1
FFF29B42  6101                              cmp     #0, r1
FFF29B44  200f                              beq.b   loc_FFF29B53
FFF29B46  a901                              mov.l   24h+var_14[sp], r1
FFF29B48  6602                              mov.l   #0, r2
FFF29B4A  05d652ff                          bsr.a   sub_FFF1EE20
FFF29B4E  a009                              mov.l   r1, 24h+var_20[sp]
FFF29B50  38a101                            bra.w   loc_FFF29CF1
FFF29B53  a989                   loc_FFF29B53 mov.l   24h+var_8[sp], r1
FFF29B55  05a69bff                          bsr.a   sub_FFF236FB
FFF29B59  a101                              mov.l   r1, 24h+var_14[sp]
FFF29B5B  a901                              mov.l   24h+var_14[sp], r1
FFF29B5D  6101                              cmp     #0, r1
FFF29B5F  200f                              beq.b   loc_FFF29B6E
FFF29B61  a901                              mov.l   24h+var_14[sp], r1
FFF29B63  6602                              mov.l   #0, r2
FFF29B65  05bb52ff                          bsr.a   sub_FFF1EE20
FFF29B69  a009                              mov.l   r1, 24h+var_20[sp]
FFF29B6B  388601                            bra.w   loc_FFF29CF1
FFF29B6E  aa02                   loc_FFF29B6E mov.l   24h+var_4[sp], r2
FFF29B70  a981                              mov.l   24h+var_C[sp], r1
FFF29B72  72110c10                          add     #100Ch, r1, r1
FFF29B76  05cf5000                          bsr.a   sub_FFF2EC45
FFF29B7A  a98a                              mov.l   24h+var_8[sp], r2
FFF29B7C  a981                              mov.l   24h+var_C[sp], r1
FFF29B7E  72111212                          add     #1212h, r1, r1
FFF29B82  05c35000                          bsr.a   sub_FFF2EC45
FFF29B86  a981                              mov.l   24h+var_C[sp], r1
FFF29B88  72110c10                          add     #100Ch, r1, r1
FFF29B8C  05909aff                          bsr.a   sub_FFF2361C
FFF29B90  a101                              mov.l   r1, 24h+var_14[sp]
FFF29B92  a901                              mov.l   24h+var_14[sp], r1
FFF29B94  6101                              cmp     #0, r1
FFF29B96  200f                              beq.b   loc_FFF29BA5
FFF29B98  a901                              mov.l   24h+var_14[sp], r1
FFF29B9A  6602                              mov.l   #0, r2
FFF29B9C  058452ff                          bsr.a   sub_FFF1EE20
FFF29BA0  a009                              mov.l   r1, 24h+var_20[sp]
FFF29BA2  384f01                            bra.w   loc_FFF29CF1
FFF29BA5  a981                   loc_FFF29BA5 mov.l   24h+var_C[sp], r1
FFF29BA7  72111212                          add     #1212h, r1, r1
FFF29BAB  05719aff                          bsr.a   sub_FFF2361C
FFF29BAF  a101                              mov.l   r1, 24h+var_14[sp]
FFF29BB1  a901                              mov.l   24h+var_14[sp], r1
FFF29BB3  6101                              cmp     #0, r1
FFF29BB5  200f                              beq.b   loc_FFF29BC4
FFF29BB7  a901                              mov.l   24h+var_14[sp], r1
FFF29BB9  6602                              mov.l   #0, r2
FFF29BBB  056552ff                          bsr.a   sub_FFF1EE20
FFF29BBF  a009                              mov.l   r1, 24h+var_20[sp]
FFF29BC1  383001                            bra.w   loc_FFF29CF1
FFF29BC4  a981                   loc_FFF29BC4 mov.l   24h+var_C[sp], r1
FFF29BC6  ce110c10                          mov.b   100Ch[r1], r1
FFF29BCA  05c14b00                          bsr.a   sub_FFF2E78B
FFF29BCE  ef16                              mov.l   r1, r6
FFF29BD0  a981                              mov.l   24h+var_C[sp], r1
FFF29BD2  ce111212                          mov.b   1212h[r1], r1
FFF29BD6  05b54b00                          bsr.a   sub_FFF2E78B
FFF29BDA  4716                              cmp     r1, r6
FFF29BDC  2010                              beq.b   loc_FFF29BEC
FFF29BDE  6602                              mov.l   #0, r2
FFF29BE0  fb16f4                            mov.l   #-0Ch, r1
FFF29BE3  053d52ff                          bsr.a   sub_FFF1EE20
FFF29BE7  a009                              mov.l   r1, 24h+var_20[sp]
FFF29BE9  380801                            bra.w   loc_FFF29CF1
FFF29BEC  a981                   loc_FFF29BEC mov.l   24h+var_C[sp], r1
FFF29BEE  72111212                          add     #1212h, r1, r1
FFF29BF2  05514a00                          bsr.a   sub_FFF2E643
FFF29BF6  6101                              cmp     #0, r1
FFF29BF8  2110                              bne.b   loc_FFF29C08
FFF29BFA  6602                              mov.l   #0, r2
FFF29BFC  fb16ff                            mov.l   #-1, r1
FFF29BFF  052152ff                          bsr.a   sub_FFF1EE20
FFF29C03  a009                              mov.l   r1, 24h+var_20[sp]
FFF29C05  38ec00                            bra.w   loc_FFF29CF1
FFF29C08  a981                   loc_FFF29C08 mov.l   24h+var_C[sp], r1
FFF29C0A  ce110c10                          mov.b   100Ch[r1], r1
FFF29C0E  057d4b00                          bsr.a   sub_FFF2E78B
FFF29C12  8289                              mov.b   r1, 24h+var_19[sp]
FFF29C14  b289                              movu.b  24h+var_19[sp], r1
FFF29C16  71020c                            add     #24h+var_18, sp, r2
FFF29C19  050653ff                          bsr.a   sub_FFF1EF1F
FFF29C1D  a101                              mov.l   r1, 24h+var_14[sp]
FFF29C1F  a901                              mov.l   24h+var_14[sp], r1
FFF29C21  6101                              cmp     #0, r1
FFF29C23  200f                              beq.b   loc_FFF29C32
FFF29C25  a901                              mov.l   24h+var_14[sp], r1
FFF29C27  6602                              mov.l   #0, r2
FFF29C29  05f751ff                          bsr.a   sub_FFF1EE20
FFF29C2D  a009                              mov.l   r1, 24h+var_20[sp]
FFF29C2F  38c200                            bra.w   loc_FFF29CF1
FFF29C32  a889                   loc_FFF29C32 mov.l   24h+var_18[sp], r1
FFF29C34  591e6c                            movu.b  6Ch[r1], r14
FFF29C37  641e                              and     #1, r14
FFF29C39  611e                              cmp     #1, r14
FFF29C3B  200e                              beq.b   loc_FFF29C49
FFF29C3D  a889                              mov.l   24h+var_18[sp], r1
FFF29C3F  591e6c                            movu.b  6Ch[r1], r14
FFF29C42  752e10                            and     #10h, r14
FFF29C45  755e10                            cmp     #10h, r14
FFF29C48  1d                                bne.s   loc_FFF29C4D
FFF29C49  f80601                 loc_FFF29C49 mov.l   #1, 24h+var_24[sp]
FFF29C4C  0c                                bra.s   loc_FFF29C50
FFF29C4D  f80600                 loc_FFF29C4D mov.l   #0, 24h+var_24[sp]
FFF29C50  ec01                   loc_FFF29C50 mov.l   24h+var_24[sp], r1
FFF29C52  6101                              cmp     #0, r1
FFF29C54  2035                              beq.b   loc_FFF29C89
FFF29C56  a889                              mov.l   24h+var_18[sp], r1
FFF29C58  058bc1fe                          bsr.a   sub_FFF15DE3
FFF29C5C  a101                              mov.l   r1, 24h+var_14[sp]
FFF29C5E  a901                              mov.l   24h+var_14[sp], r1
FFF29C60  6101                              cmp     #0, r1
FFF29C62  2010                              beq.b   loc_FFF29C72
FFF29C64  6602                              mov.l   #0, r2
FFF29C66  fb16c1                            mov.l   #-3Fh, r1
FFF29C69  05b751ff                          bsr.a   sub_FFF1EE20
FFF29C6D  a009                              mov.l   r1, 24h+var_20[sp]
FFF29C6F  388200                            bra.w   loc_FFF29CF1
FFF29C72  a983                   loc_FFF29C72 mov.l   24h+var_C[sp], r3
FFF29C74  72321212                          add     #1212h, r3, r2
FFF29C78  72310c10                          add     #100Ch, r3, r1
FFF29C7C  397c00                            bsr.w   sub_FFF29CF8
FFF29C7F  a101                              mov.l   r1, 24h+var_14[sp]
FFF29C81  a889                              mov.l   24h+var_18[sp], r1
FFF29C83  056bc1fe                          bsr.a   sub_FFF15DEE
FFF29C87  2e11                              bra.b   loc_FFF29C98
FFF29C89  a983                   loc_FFF29C89 mov.l   24h+var_C[sp], r3
FFF29C8B  72321212                          add     #1212h, r3, r2
FFF29C8F  72310c10                          add     #100Ch, r3, r1
FFF29C93  396500                            bsr.w   sub_FFF29CF8
FFF29C96  a101                              mov.l   r1, 24h+var_14[sp]
FFF29C98  a901                   loc_FFF29C98 mov.l   24h+var_14[sp], r1
FFF29C9A  6101                              cmp     #0, r1
FFF29C9C  200e                              beq.b   loc_FFF29CAA
FFF29C9E  a901                              mov.l   24h+var_14[sp], r1
FFF29CA0  6602                              mov.l   #0, r2
FFF29CA2  057e51ff                          bsr.a   sub_FFF1EE20
FFF29CA6  a009                              mov.l   r1, 24h+var_20[sp]
FFF29CA8  2e49                              bra.b   loc_FFF29CF1
FFF29CAA  a889                   loc_FFF29CAA mov.l   24h+var_18[sp], r1
FFF29CAC  05302fff                          bsr.a   sub_FFF1CBDC
FFF29CB0  a101                              mov.l   r1, 24h+var_14[sp]
FFF29CB2  a901                              mov.l   24h+var_14[sp], r1
FFF29CB4  6101                              cmp     #0, r1
FFF29CB6  200e                              beq.b   loc_FFF29CC4
FFF29CB8  a901                              mov.l   24h+var_14[sp], r1
FFF29CBA  6602                              mov.l   #0, r2
FFF29CBC  056451ff                          bsr.a   sub_FFF1EE20
FFF29CC0  a009                              mov.l   r1, 24h+var_20[sp]
FFF29CC2  2e2f                              bra.b   loc_FFF29CF1
FFF29CC4  a889                   loc_FFF29CC4 mov.l   24h+var_18[sp], r1
FFF29CC6  591e6c                            movu.b  6Ch[r1], r14
FFF29CC9  752e10                            and     #10h, r14
FFF29CCC  755e10                            cmp     #10h, r14
FFF29CCF  2118                              bne.b   loc_FFF29CE7
FFF29CD1  a984                              mov.l   24h+var_C[sp], r4
FFF29CD3  5a433216                          movu.b  1632h[r4], r3
FFF29CD7  5a423116                          movu.b  1631h[r4], r2
FFF29CDB  a889                              mov.l   24h+var_18[sp], r1
FFF29CDD  72440c06                          add     #60Ch, r4, r4
FFF29CE1  057bc7ff                          bsr.a   sub_FFF2645C
FFF29CE5  a101                              mov.l   r1, 24h+var_14[sp]
FFF29CE7  a901                   loc_FFF29CE7 mov.l   24h+var_14[sp], r1
FFF29CE9  6602                              mov.l   #0, r2
FFF29CEB  053551ff                          bsr.a   sub_FFF1EE20
FFF29CEF  a009                              mov.l   r1, 24h+var_20[sp]
FFF29CF1  a809                   loc_FFF29CF1 mov.l   24h+var_20[sp], r1
FFF29CF3  a109                              mov.l   r1, 24h+var_10[sp]
FFF29CF5  3f660a                            rtsd    #28h, r6-r6
FFF29CF8  7100c8                 sub_FFF29CF8 add     #-38h, sp, sp   ; <<<< FUNC sub_FFF29CF8
FFF29CFB  a309                              mov.l   r1, 38h+var_4[sp]
FFF29CFD  a302                              mov.l   r2, 38h+var_8[sp]
FFF29CFF  a28b                              mov.l   r3, 38h+var_C[sp]
FFF29D01  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF29D07  e4e006                            mov.l   [r14], 38h+var_20[sp]
FFF29D0A  fbe2245e0600                      mov.l   #65E24h, r14
FFF29D10  e4e005                            mov.l   [r14], 38h+var_24[sp]
FFF29D13  3e0800                            mov.l   #0, 38h+var_18[sp]
FFF29D16  389b00                            bra.w   loc_FFF29DB1
FFF29D19  052a4900               loc_FFF29D19 bsr.a   sub_FFF2E643
FFF29D1D  a089                              mov.l   r1, 38h+var_2C[sp]
FFF29D1F  a88b                              mov.l   38h+var_2C[sp], r3
FFF29D21  ab0a                              mov.l   38h+var_4[sp], r2
FFF29D23  a909                              mov.l   38h+var_24[sp], r1
FFF29D25  6813                              shlr    #1, r3
FFF29D27  72113c02                          add     #23Ch, r1, r1
FFF29D2B  050aa0ff                          bsr.a   sub_FFF23D35
FFF29D2F  6101                              cmp     #0, r1
FFF29D31  212c                              bne.b   loc_FFF29D5D
FFF29D33  a909                              mov.l   38h+var_24[sp], r1
FFF29D35  06890103                          add     38h+var_2C[sp].l, r1
FFF29D39  ce113c02                          mov.b   23Ch[r1], r1
FFF29D3D  9109                              mov.w   r1, 38h+var_2E[sp]
FFF29D3F  b909                              movu.w  38h+var_2E[sp], r1
FFF29D41  75515c                            cmp     #5Ch, r1 ; '\'
FFF29D44  16                                beq.s   loc_FFF29D4A
FFF29D45  b909                              movu.w  38h+var_2E[sp], r1
FFF29D47  6101                              cmp     #0, r1
FFF29D49  1d                                bne.s   loc_FFF29D4E
FFF29D4A  f80601                 loc_FFF29D4A mov.l   #1, 38h+var_38[sp]
FFF29D4D  0c                                bra.s   loc_FFF29D51
FFF29D4E  f80600                 loc_FFF29D4E mov.l   #0, 38h+var_38[sp]
FFF29D51  ec01                   loc_FFF29D51 mov.l   38h+var_38[sp], r1
FFF29D53  6101                              cmp     #0, r1
FFF29D55  10                                beq.s   loc_FFF29D5D
FFF29D56  f90601f9                          mov.l   #-7, 38h+var_34[sp]
FFF29D5A  38d800                            bra.w   loc_FFF29E32
FFF29D5D  ab01                   loc_FFF29D5D mov.l   38h+var_8[sp], r1
FFF29D5F  05e44800                          bsr.a   sub_FFF2E643
FFF29D63  a089                              mov.l   r1, 38h+var_2C[sp]
FFF29D65  a88b                              mov.l   38h+var_2C[sp], r3
FFF29D67  ab02                              mov.l   38h+var_8[sp], r2
FFF29D69  a909                              mov.l   38h+var_24[sp], r1
FFF29D6B  6813                              shlr    #1, r3
FFF29D6D  72113c02                          add     #23Ch, r1, r1
FFF29D71  05c49fff                          bsr.a   sub_FFF23D35
FFF29D75  6101                              cmp     #0, r1
FFF29D77  212c                              bne.b   loc_FFF29DA3
FFF29D79  a909                              mov.l   38h+var_24[sp], r1
FFF29D7B  06890103                          add     38h+var_2C[sp].l, r1
FFF29D7F  ce113c02                          mov.b   23Ch[r1], r1
FFF29D83  9109                              mov.w   r1, 38h+var_2E[sp]
FFF29D85  b909                              movu.w  38h+var_2E[sp], r1
FFF29D87  75515c                            cmp     #5Ch, r1 ; '\'
FFF29D8A  16                                beq.s   loc_FFF29D90
FFF29D8B  b909                              movu.w  38h+var_2E[sp], r1
FFF29D8D  6101                              cmp     #0, r1
FFF29D8F  1d                                bne.s   loc_FFF29D94
FFF29D90  f80601                 loc_FFF29D90 mov.l   #1, 38h+var_38[sp]
FFF29D93  0c                                bra.s   loc_FFF29D97
FFF29D94  f80600                 loc_FFF29D94 mov.l   #0, 38h+var_38[sp]
FFF29D97  ec01                   loc_FFF29D97 mov.l   38h+var_38[sp], r1
FFF29D99  6101                              cmp     #0, r1
FFF29D9B  10                                beq.s   loc_FFF29DA3
FFF29D9C  f90601f9                          mov.l   #-7, 38h+var_34[sp]
FFF29DA0  389200                            bra.w   loc_FFF29E32
FFF29DA3  aa01                   loc_FFF29DA3 mov.l   38h+var_18[sp], r1
FFF29DA5  6211                              add     #1, r1
FFF29DA7  a201                              mov.l   r1, 38h+var_18[sp]
FFF29DA9  a909                              mov.l   38h+var_24[sp], r1
FFF29DAB  72116804                          add     #468h, r1, r1
FFF29DAF  a109                              mov.l   r1, 38h+var_24[sp]
FFF29DB1  fbe212250100           loc_FFF29DB1 mov.l   #12512h, r14
FFF29DB7  dcee                              mov.w   [r14], r14
FFF29DB9  06850e08                          cmp     38h+var_18[sp].l, r14
FFF29DBD  ab09                              mov.l   38h+var_4[sp], r1
FFF29DBF  2b05                              ble.b   loc_FFF29DC4
FFF29DC1  3858ff                            bra.w   loc_FFF29D19
FFF29DC4  cc11                   loc_FFF29DC4 mov.b   [r1], r1
FFF29DC6  05c54900                          bsr.a   sub_FFF2E78B
FFF29DCA  8489                              mov.b   r1, 38h+var_25[sp]
FFF29DCC  b489                              movu.b  38h+var_25[sp], r1
FFF29DCE  710218                            add     #38h+var_20, sp, r2
FFF29DD1  054e51ff                          bsr.a   sub_FFF1EF1F
FFF29DD5  a209                              mov.l   r1, 38h+var_14[sp]
FFF29DD7  aa09                              mov.l   38h+var_14[sp], r1
FFF29DD9  6101                              cmp     #0, r1
FFF29DDB  17                                beq.s   loc_FFF29DE2
FFF29DDC  e5000901                          mov.l   38h+var_14[sp], 38h+var_34[sp]
FFF29DE0  2e52                              bra.b   loc_FFF29E32
FFF29DE2  a981                   loc_FFF29DE2 mov.l   38h+var_20[sp], r1
FFF29DE4  057951ff                          bsr.a   sub_FFF1EF5D
FFF29DE8  a209                              mov.l   r1, 38h+var_14[sp]
FFF29DEA  aa09                              mov.l   38h+var_14[sp], r1
FFF29DEC  6101                              cmp     #0, r1
FFF29DEE  17                                beq.s   loc_FFF29DF5
FFF29DEF  e5000901                          mov.l   38h+var_14[sp], 38h+var_34[sp]
FFF29DF3  2e3f                              bra.b   loc_FFF29E32
FFF29DF5  a981                   loc_FFF29DF5 mov.l   38h+var_20[sp], r1
FFF29DF7  059a51ff                          bsr.a   sub_FFF1EF91
FFF29DFB  a209                              mov.l   r1, 38h+var_14[sp]
FFF29DFD  aa09                              mov.l   38h+var_14[sp], r1
FFF29DFF  6101                              cmp     #0, r1
FFF29E01  17                                beq.s   loc_FFF29E08
FFF29E02  e5000901                          mov.l   38h+var_14[sp], 38h+var_34[sp]
FFF29E06  2e2c                              bra.b   loc_FFF29E32
FFF29E08  a981                   loc_FFF29E08 mov.l   38h+var_20[sp], r1
FFF29E0A  05e3befe                          bsr.a   sub_FFF15CED
FFF29E0E  a189                              mov.l   r1, 38h+var_1C[sp]
FFF29E10  a989                              mov.l   38h+var_1C[sp], r1
FFF29E12  6101                              cmp     #0, r1
FFF29E14  17                                beq.s   loc_FFF29E1B
FFF29E15  f90601db                          mov.l   #-25h, 38h+var_34[sp]
FFF29E19  2e19                              bra.b   loc_FFF29E32
FFF29E1B  aa8c                   loc_FFF29E1B mov.l   38h+var_C[sp], r4
FFF29E1D  ab03                              mov.l   38h+var_8[sp], r3
FFF29E1F  ab0a                              mov.l   38h+var_4[sp], r2
FFF29E21  a981                              mov.l   38h+var_20[sp], r1
FFF29E23  391500                            bsr.w   sub_FFF29E38
FFF29E26  a209                              mov.l   r1, 38h+var_14[sp]
FFF29E28  a981                              mov.l   38h+var_20[sp], r1
FFF29E2A  05cebefe                          bsr.a   sub_FFF15CF8
FFF29E2E  e5000901                          mov.l   38h+var_14[sp], 38h+var_34[sp]
FFF29E32  a809                   loc_FFF29E32 mov.l   38h+var_34[sp], r1
FFF29E34  a281                              mov.l   r1, 38h+var_10[sp]
FFF29E36  670e                              rtsd    #0Eh
FFF29E38  72004cff               sub_FFF29E38 add     #-0B4h, sp, sp   ; <<<< FUNC sub_FFF29E38
FFF29E3C  e7012c                            mov.l   r1, 0B4h+var_4[sp]
FFF29E3F  e7022b                            mov.l   r2, 0B4h+var_8[sp]
FFF29E42  e7032a                            mov.l   r3, 0B4h+var_C[sp]
FFF29E45  e70429                            mov.l   r4, 0B4h+var_10[sp]
FFF29E48  f9062400                          mov.l   #0, 0B4h+var_24[sp]
FFF29E4C  f9062300                          mov.l   #0, 0B4h+var_28[sp]
FFF29E50  f9062200                          mov.l   #0, 0B4h+var_2C[sp]
FFF29E54  f9062100                          mov.l   #0, 0B4h+var_30[sp]
FFF29E58  f9062000                          mov.l   #0, 0B4h+var_34[sp]
FFF29E5C  3e0300                            mov.l   #0, 0B4h+var_A8[sp]
FFF29E5F  ed012a                            mov.l   0B4h+var_C[sp], r1
FFF29E62  6241                              add     #4, r1
FFF29E64  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF29E67  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF29E6A  e5100d22                          mov.l   34h[r1], 0B4h+var_2C[sp]
FFF29E6E  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF29E71  fa14301600                        mov.b   #0, 1630h[r1]
FFF29E76  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF29E79  8c11                              mov.b   10h[r1], r1
FFF29E7B  755120                            cmp     #20h, r1 ; ' '
FFF29E7E  3a3801                            beq.w   loc_FFF29FB6
FFF29E81  ed0229                            mov.l   0B4h+var_10[sp], r2
FFF29E84  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF29E87  72220602                          add     #206h, r2, r2
FFF29E8B  058895ff                          bsr.a   sub_FFF23413
FFF29E8F  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF29E92  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF29E95  6101                              cmp     #0, r1
FFF29E97  18                                bne.s   loc_FFF29E9F
FFF29E98  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF29E9C  387d05                            bra.w   loc_FFF2A419
FFF29E9F  ed0129                 loc_FFF29E9F mov.l   0B4h+var_10[sp], r1
FFF29EA2  ce1e0602                          mov.b   206h[r1], r14
FFF29EA6  610e                              cmp     #0, r14
FFF29EA8  2110                              bne.b   loc_FFF29EB8
FFF29EAA  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF29EAD  ce1e0702                          mov.b   207h[r1], r14
FFF29EB1  610e                              cmp     #0, r14
FFF29EB3  1d                                bne.s   loc_FFF29EB8
FFF29EB4  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF29EB7  0c                                bra.s   loc_FFF29EBB
FFF29EB8  f80600                 loc_FFF29EB8 mov.l   #0, 0B4h+var_B4[sp]
FFF29EBB  ec01                   loc_FFF29EBB mov.l   0B4h+var_B4[sp], r1
FFF29EBD  6101                              cmp     #0, r1
FFF29EBF  10                                beq.s   loc_FFF29EC7
FFF29EC0  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF29EC4  385505                            bra.w   loc_FFF2A419
FFF29EC7  ed0229                 loc_FFF29EC7 mov.l   0B4h+var_10[sp], r2
FFF29ECA  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF29ECD  60c0                              sub     #0Ch, sp
FFF29ECF  72038800                          add     #0C0h+var_38, sp, r3
FFF29ED3  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF29ED5  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF29ED8  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF29EDA  72220602                          add     #206h, r2, r2
FFF29EDE  6604                              mov.l   #0, r4
FFF29EE0  71031c                            add     #0C0h+var_A4, sp, r3
FFF29EE3  05e787ff                          bsr.a   sub_FFF226CA
FFF29EE7  62c0                              add     #0Ch, sp
FFF29EE9  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF29EEC  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF29EEF  cc1e                              mov.b   [r1], r14
FFF29EF1  610e                              cmp     #0, r14
FFF29EF3  3ac300                            beq.w   loc_FFF29FB6
FFF29EF6  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF29EF9  6101                              cmp     #0, r1
FFF29EFB  10                                beq.s   loc_FFF29F03
FFF29EFC  f90601fc                          mov.l   #-4, 0B4h+var_B0[sp]
FFF29F00  381905                            bra.w   loc_FFF2A419
FFF29F03  ed012c                 loc_FFF29F03 mov.l   0B4h+var_4[sp], r1
FFF29F06  8c12                              mov.b   10h[r1], r2
FFF29F08  710110                            add     #0B4h+var_A4, sp, r1
FFF29F0B  058d67ff                          bsr.a   sub_FFF20698
FFF29F0F  e70122                            mov.l   r1, 0B4h+var_2C[sp]
FFF29F12  38a400                            bra.w   loc_FFF29FB6
FFF29F15  ed0229                 loc_FFF29F15 mov.l   0B4h+var_10[sp], r2
FFF29F18  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF29F1B  72220602                          add     #206h, r2, r2
FFF29F1F  05f494ff                          bsr.a   sub_FFF23413
FFF29F23  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF29F26  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF29F29  6101                              cmp     #0, r1
FFF29F2B  18                                bne.s   loc_FFF29F33
FFF29F2C  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF29F30  38e904                            bra.w   loc_FFF2A419
FFF29F33  ed0129                 loc_FFF29F33 mov.l   0B4h+var_10[sp], r1
FFF29F36  ce1e0602                          mov.b   206h[r1], r14
FFF29F3A  610e                              cmp     #0, r14
FFF29F3C  2110                              bne.b   loc_FFF29F4C
FFF29F3E  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF29F41  ce1e0702                          mov.b   207h[r1], r14
FFF29F45  610e                              cmp     #0, r14
FFF29F47  1d                                bne.s   loc_FFF29F4C
FFF29F48  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF29F4B  0c                                bra.s   loc_FFF29F4F
FFF29F4C  f80600                 loc_FFF29F4C mov.l   #0, 0B4h+var_B4[sp]
FFF29F4F  ec01                   loc_FFF29F4F mov.l   0B4h+var_B4[sp], r1
FFF29F51  6101                              cmp     #0, r1
FFF29F53  10                                beq.s   loc_FFF29F5B
FFF29F54  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF29F58  38c104                            bra.w   loc_FFF2A419
FFF29F5B  e5002220               loc_FFF29F5B mov.l   0B4h+var_2C[sp], 0B4h+var_34[sp]
FFF29F5F  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF29F62  ed0222                            mov.l   0B4h+var_2C[sp], r2
FFF29F65  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF29F68  7100f0                            add     #-10h, sp, sp
FFF29F6B  72048800                          add     #0C4h+var_3C, sp, r4
FFF29F6F  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF29F71  72048c00                          add     #0C4h+var_38, sp, r4
FFF29F75  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF29F77  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF29F7A  f80400                            mov.b   #0, 0C4h+var_C4[sp]
FFF29F7D  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF29F7F  72330602                          add     #206h, r3, r3
FFF29F83  710420                            add     #0C4h+var_A4, sp, r4
FFF29F86  05b58bff                          bsr.a   sub_FFF22B3B
FFF29F8A  710010                            add     #10h, sp, sp
FFF29F8D  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF29F90  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF29F93  cc1e                              mov.b   [r1], r14
FFF29F95  610e                              cmp     #0, r14
FFF29F97  201f                              beq.b   loc_FFF29FB6
FFF29F99  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF29F9C  7501fc                            cmp     #-4, r1
FFF29F9F  18                                bne.s   loc_FFF29FA7
FFF29FA0  f90601fc                          mov.l   #-4, 0B4h+var_B0[sp]
FFF29FA4  387504                            bra.w   loc_FFF2A419
FFF29FA7  ed012c                 loc_FFF29FA7 mov.l   0B4h+var_4[sp], r1
FFF29FAA  8c12                              mov.b   10h[r1], r2
FFF29FAC  710110                            add     #0B4h+var_A4, sp, r1
FFF29FAF  05e966ff                          bsr.a   sub_FFF20698
FFF29FB3  e70122                            mov.l   r1, 0B4h+var_2C[sp]
FFF29FB6  ed0125                 loc_FFF29FB6 mov.l   0B4h+var_20[sp], r1
FFF29FB9  cc1e                              mov.b   [r1], r14
FFF29FBB  610e                              cmp     #0, r14
FFF29FBD  3b58ff                            bne.w   loc_FFF29F15
FFF29FC0  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF29FC3  6101                              cmp     #0, r1
FFF29FC5  1c                                bne.s   loc_FFF29FC9
FFF29FC6  3e0301                            mov.l   #1, 0B4h+var_A8[sp]
FFF29FC9  ed012b                 loc_FFF29FC9 mov.l   0B4h+var_8[sp], r1
FFF29FCC  6241                              add     #4, r1
FFF29FCE  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF29FD1  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF29FD4  e5100d22                          mov.l   34h[r1], 0B4h+var_2C[sp]
FFF29FD8  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF29FDB  8c11                              mov.b   10h[r1], r1
FFF29FDD  755120                            cmp     #20h, r1 ; ' '
FFF29FE0  3a4d01                            beq.w   loc_FFF2A12D
FFF29FE3  ed0229                            mov.l   0B4h+var_10[sp], r2
FFF29FE6  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF29FE9  052a94ff                          bsr.a   sub_FFF23413
FFF29FED  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF29FF0  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF29FF3  6101                              cmp     #0, r1
FFF29FF5  18                                bne.s   loc_FFF29FFD
FFF29FF6  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF29FFA  381f04                            bra.w   loc_FFF2A419
FFF29FFD  ed0129                 loc_FFF29FFD mov.l   0B4h+var_10[sp], r1
FFF2A000  cc1e                              mov.b   [r1], r14
FFF2A002  610e                              cmp     #0, r14
FFF2A004  210e                              bne.b   loc_FFF2A012
FFF2A006  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF2A009  8819                              mov.b   1[r1], r1
FFF2A00B  6101                              cmp     #0, r1
FFF2A00D  1d                                bne.s   loc_FFF2A012
FFF2A00E  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF2A011  0c                                bra.s   loc_FFF2A015
FFF2A012  f80600                 loc_FFF2A012 mov.l   #0, 0B4h+var_B4[sp]
FFF2A015  ec01                   loc_FFF2A015 mov.l   0B4h+var_B4[sp], r1
FFF2A017  6101                              cmp     #0, r1
FFF2A019  10                                beq.s   loc_FFF2A021
FFF2A01A  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF2A01E  38fb03                            bra.w   loc_FFF2A419
FFF2A021  ed0229                 loc_FFF2A021 mov.l   0B4h+var_10[sp], r2
FFF2A024  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A027  60c0                              sub     #0Ch, sp
FFF2A029  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF2A02B  72038800                          add     #0C0h+var_38, sp, r3
FFF2A02F  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF2A031  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF2A034  6604                              mov.l   #0, r4
FFF2A036  71033c                            add     #0C0h+var_84, sp, r3
FFF2A039  059186ff                          bsr.a   sub_FFF226CA
FFF2A03D  62c0                              add     #0Ch, sp
FFF2A03F  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A042  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2A045  6101                              cmp     #0, r1
FFF2A047  2018                              beq.b   loc_FFF2A05F
FFF2A049  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF2A04C  cc1e                              mov.b   [r1], r14
FFF2A04E  610e                              cmp     #0, r14
FFF2A050  10                                beq.s   loc_FFF2A058
FFF2A051  f90601fc                          mov.l   #-4, 0B4h+var_B0[sp]
FFF2A055  38c403                            bra.w   loc_FFF2A419
FFF2A058  f90601fd               loc_FFF2A058 mov.l   #-3, 0B4h+var_B0[sp]
FFF2A05C  38bd03                            bra.w   loc_FFF2A419
FFF2A05F  ed012c                 loc_FFF2A05F mov.l   0B4h+var_4[sp], r1
FFF2A062  8c12                              mov.b   10h[r1], r2
FFF2A064  710130                            add     #0B4h+var_84, sp, r1
FFF2A067  053166ff                          bsr.a   sub_FFF20698
FFF2A06B  e70122                            mov.l   r1, 0B4h+var_2C[sp]
FFF2A06E  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF2A071  fa14301601                        mov.b   #1, 1630h[r1]
FFF2A076  38b700                            bra.w   loc_FFF2A12D
FFF2A079  ed0229                 loc_FFF2A079 mov.l   0B4h+var_10[sp], r2
FFF2A07C  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF2A07F  059493ff                          bsr.a   sub_FFF23413
FFF2A083  e70125                            mov.l   r1, 0B4h+var_20[sp]
FFF2A086  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF2A089  6101                              cmp     #0, r1
FFF2A08B  18                                bne.s   loc_FFF2A093
FFF2A08C  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF2A090  388903                            bra.w   loc_FFF2A419
FFF2A093  ed0129                 loc_FFF2A093 mov.l   0B4h+var_10[sp], r1
FFF2A096  cc1e                              mov.b   [r1], r14
FFF2A098  610e                              cmp     #0, r14
FFF2A09A  210e                              bne.b   loc_FFF2A0A8
FFF2A09C  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF2A09F  8819                              mov.b   1[r1], r1
FFF2A0A1  6101                              cmp     #0, r1
FFF2A0A3  1d                                bne.s   loc_FFF2A0A8
FFF2A0A4  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF2A0A7  0c                                bra.s   loc_FFF2A0AB
FFF2A0A8  f80600                 loc_FFF2A0A8 mov.l   #0, 0B4h+var_B4[sp]
FFF2A0AB  ec01                   loc_FFF2A0AB mov.l   0B4h+var_B4[sp], r1
FFF2A0AD  6101                              cmp     #0, r1
FFF2A0AF  10                                beq.s   loc_FFF2A0B7
FFF2A0B0  f90601ff                          mov.l   #-1, 0B4h+var_B0[sp]
FFF2A0B4  386503                            bra.w   loc_FFF2A419
FFF2A0B7  e5002221               loc_FFF2A0B7 mov.l   0B4h+var_2C[sp], 0B4h+var_30[sp]
FFF2A0BB  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2A0BE  ed0222                            mov.l   0B4h+var_2C[sp], r2
FFF2A0C1  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A0C4  7100f0                            add     #-10h, sp, sp
FFF2A0C7  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF2A0C9  72048800                          add     #0C4h+var_3C, sp, r4
FFF2A0CD  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF2A0CF  72048c00                          add     #0C4h+var_38, sp, r4
FFF2A0D3  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF2A0D5  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF2A0D8  f80400                            mov.b   #0, 0C4h+var_C4[sp]
FFF2A0DB  710440                            add     #0C4h+var_84, sp, r4
FFF2A0DE  055d8aff                          bsr.a   sub_FFF22B3B
FFF2A0E2  710010                            add     #10h, sp, sp
FFF2A0E5  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A0E8  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2A0EB  6101                              cmp     #0, r1
FFF2A0ED  2029                              beq.b   loc_FFF2A116
FFF2A0EF  ed0125                            mov.l   0B4h+var_20[sp], r1
FFF2A0F2  cc1e                              mov.b   [r1], r14
FFF2A0F4  610e                              cmp     #0, r14
FFF2A0F6  210d                              bne.b   loc_FFF2A103
FFF2A0F8  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2A0FB  7501fc                            cmp     #-4, r1
FFF2A0FE  1d                                bne.s   loc_FFF2A103
FFF2A0FF  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF2A102  0c                                bra.s   loc_FFF2A106
FFF2A103  f80600                 loc_FFF2A103 mov.l   #0, 0B4h+var_B4[sp]
FFF2A106  ec01                   loc_FFF2A106 mov.l   0B4h+var_B4[sp], r1
FFF2A108  6101                              cmp     #0, r1
FFF2A10A  15                                beq.s   loc_FFF2A10F
FFF2A10B  f90627fd                          mov.l   #-3, 0B4h+var_18[sp]
FFF2A10F  e5002701               loc_FFF2A10F mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF2A113  380603                            bra.w   loc_FFF2A419
FFF2A116  ed012c                 loc_FFF2A116 mov.l   0B4h+var_4[sp], r1
FFF2A119  8c12                              mov.b   10h[r1], r2
FFF2A11B  710130                            add     #0B4h+var_84, sp, r1
FFF2A11E  057a65ff                          bsr.a   sub_FFF20698
FFF2A122  e70122                            mov.l   r1, 0B4h+var_2C[sp]
FFF2A125  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF2A128  fa14301601                        mov.b   #1, 1630h[r1]
FFF2A12D  ed0125                 loc_FFF2A12D mov.l   0B4h+var_20[sp], r1
FFF2A130  cc1e                              mov.b   [r1], r14
FFF2A132  610e                              cmp     #0, r14
FFF2A134  3b45ff                            bne.w   loc_FFF2A079
FFF2A137  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF2A13A  5a1e3016                          movu.b  1630h[r1], r14
FFF2A13E  611e                              cmp     #1, r14
FFF2A140  2113                              bne.b   loc_FFF2A153
FFF2A142  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A145  591e6c                            movu.b  6Ch[r1], r14
FFF2A148  752e10                            and     #10h, r14
FFF2A14B  755e10                            cmp     #10h, r14
FFF2A14E  1d                                bne.s   loc_FFF2A153
FFF2A14F  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF2A152  0c                                bra.s   loc_FFF2A156
FFF2A153  f80600                 loc_FFF2A153 mov.l   #0, 0B4h+var_B4[sp]
FFF2A156  ec01                   loc_FFF2A156 mov.l   0B4h+var_B4[sp], r1
FFF2A158  6101                              cmp     #0, r1
FFF2A15A  3a8800                            beq.w   loc_FFF2A1E2
FFF2A15D  ed0229                            mov.l   0B4h+var_10[sp], r2
FFF2A160  ed012b                            mov.l   0B4h+var_8[sp], r1
FFF2A163  72220c06                          add     #60Ch, r2, r2
FFF2A167  05ddcaff                          bsr.a   sub_FFF26C44
FFF2A16B  8289                              mov.b   r1, 0B4h+var_A9[sp]
FFF2A16D  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2A170  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A173  72320c06                          add     #60Ch, r3, r2
FFF2A177  0512c1ff                          bsr.a   sub_FFF26289
FFF2A17B  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A17E  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2A181  6101                              cmp     #0, r1
FFF2A183  2134                              bne.b   loc_FFF2A1B7
FFF2A185  ed0229                            mov.l   0B4h+var_10[sp], r2
FFF2A188  b28d                              movu.b  0B4h+var_A9[sp], r5
FFF2A18A  af8c                              mov.l   0B4h+var_38[sp], r4
FFF2A18C  af83                              mov.l   0B4h+var_3C[sp], r3
FFF2A18E  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A191  60c0                              sub     #0Ch, sp
FFF2A193  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF2A195  72220c06                          add     #60Ch, r2, r2
FFF2A199  a00a                              mov.l   r2, 0C0h+var_BC[sp]
FFF2A19B  c305                              mov.b   r5, 0C0h+var_C0[sp]
FFF2A19D  71023c                            add     #0C0h+var_84, sp, r2
FFF2A1A0  05a6c1ff                          bsr.a   sub_FFF26346
FFF2A1A4  62c0                              add     #0Ch, sp
FFF2A1A6  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A1A9  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2A1AC  6101                              cmp     #0, r1
FFF2A1AE  202c                              beq.b   loc_FFF2A1DA
FFF2A1B0  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF2A1B4  386502                            bra.w   loc_FFF2A419
FFF2A1B7  ed0127                 loc_FFF2A1B7 mov.l   0B4h+var_18[sp], r1
FFF2A1BA  7601d3fe                          cmp     #-12Dh, r1
FFF2A1BE  11                                beq.s   loc_FFF2A1C7
FFF2A1BF  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2A1C2  7601d4fe                          cmp     #-12Ch, r1
FFF2A1C6  1d                                bne.s   loc_FFF2A1CB
FFF2A1C7  f80601                 loc_FFF2A1C7 mov.l   #1, 0B4h+var_B4[sp]
FFF2A1CA  0c                                bra.s   loc_FFF2A1CE
FFF2A1CB  f80600                 loc_FFF2A1CB mov.l   #0, 0B4h+var_B4[sp]
FFF2A1CE  ec01                   loc_FFF2A1CE mov.l   0B4h+var_B4[sp], r1
FFF2A1D0  6101                              cmp     #0, r1
FFF2A1D2  18                                bne.s   loc_FFF2A1DA
FFF2A1D3  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF2A1D7  384202                            bra.w   loc_FFF2A419
FFF2A1DA  ed0129                 loc_FFF2A1DA mov.l   0B4h+var_10[sp], r1
FFF2A1DD  fa14301602                        mov.b   #2, 1630h[r1]
FFF2A1E2  a889                   loc_FFF2A1E2 mov.l   0B4h+var_A8[sp], r1
FFF2A1E4  6101                              cmp     #0, r1
FFF2A1E6  fcdbe1                            scne.l  r14
FFF2A1E9  ed0121                            mov.l   0B4h+var_30[sp], r1
FFF2A1EC  06850120                          cmp     0B4h+var_34[sp].l, r1
FFF2A1F0  200f                              beq.b   loc_FFF2A1FF
FFF2A1F2  5bee                              movu.b  r14, r14
FFF2A1F4  610e                              cmp     #0, r14
FFF2A1F6  204d                              beq.b   loc_FFF2A243
FFF2A1F8  f90601fe                          mov.l   #-2, 0B4h+var_B0[sp]
FFF2A1FC  381d02                            bra.w   loc_FFF2A419
FFF2A1FF  5bee                   loc_FFF2A1FF movu.b  r14, r14
FFF2A201  610e                              cmp     #0, r14
FFF2A203  2040                              beq.b   loc_FFF2A243
FFF2A205  ed0129                            mov.l   0B4h+var_10[sp], r1
FFF2A208  72120602                          add     #206h, r1, r2
FFF2A20C  05b49aff                          bsr.a   sub_FFF23CC0
FFF2A210  6101                              cmp     #0, r1
FFF2A212  2031                              beq.b   loc_FFF2A243
FFF2A214  f9062600                          mov.l   #0, 0B4h+var_1C[sp]
FFF2A218  2e24                              bra.b   loc_FFF2A23C
FFF2A21A  ed0126                 loc_FFF2A21A mov.l   0B4h+var_1C[sp], r1
FFF2A21D  710e30                            add     #0B4h+var_84, sp, r14
FFF2A220  fece1e                            movu.b  [r14, r1], r14
FFF2A223  710f10                            add     #0B4h+var_A4, sp, r15
FFF2A226  4b1f                              add     r1, r15
FFF2A228  40fe                              sub     [r15], r14
FFF2A22A  610e                              cmp     #0, r14
FFF2A22C  10                                beq.s   loc_FFF2A234
FFF2A22D  f90601fe                          mov.l   #-2, 0B4h+var_B0[sp]
FFF2A231  38e801                            bra.w   loc_FFF2A419
FFF2A234  ed0126                 loc_FFF2A234 mov.l   0B4h+var_1C[sp], r1
FFF2A237  6211                              add     #1, r1
FFF2A239  e70126                            mov.l   r1, 0B4h+var_1C[sp]
FFF2A23C  ed0126                 loc_FFF2A23C mov.l   0B4h+var_1C[sp], r1
FFF2A23F  61b1                              cmp     #0Bh, r1
FFF2A241  29d9                              blt.b   loc_FFF2A21A
FFF2A243  ed0120                 loc_FFF2A243 mov.l   0B4h+var_34[sp], r1
FFF2A246  6101                              cmp     #0, r1
FFF2A248  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A24B  2032                              beq.b   loc_FFF2A27D
FFF2A24D  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2A250  ed0220                            mov.l   0B4h+var_34[sp], r2
FFF2A253  7100f0                            add     #-10h, sp, sp
FFF2A256  72049c00                          add     #0C4h+var_28, sp, r4
FFF2A25A  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF2A25C  7204a000                          add     #0C4h+var_24, sp, r4
FFF2A260  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF2A262  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF2A265  f80403                            mov.b   #3, 0C4h+var_C4[sp]
FFF2A268  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF2A26A  72330602                          add     #206h, r3, r3
FFF2A26E  710460                            add     #0C4h+var_64, sp, r4
FFF2A271  05ca88ff                          bsr.a   sub_FFF22B3B
FFF2A275  710010                            add     #10h, sp, sp
FFF2A278  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A27B  2e24                              bra.b   loc_FFF2A29F
FFF2A27D  ed0229                 loc_FFF2A27D mov.l   0B4h+var_10[sp], r2
FFF2A280  60c0                              sub     #0Ch, sp
FFF2A282  72039c00                          add     #0C0h+var_24, sp, r3
FFF2A286  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF2A288  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF2A28B  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF2A28D  72220602                          add     #206h, r2, r2
FFF2A291  6634                              mov.l   #3, r4
FFF2A293  71035c                            add     #0C0h+var_64, sp, r3
FFF2A296  053484ff                          bsr.a   sub_FFF226CA
FFF2A29A  62c0                              add     #0Ch, sp
FFF2A29C  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A29F  ed0127                 loc_FFF2A29F mov.l   0B4h+var_18[sp], r1
FFF2A2A2  6101                              cmp     #0, r1
FFF2A2A4  10                                beq.s   loc_FFF2A2AC
FFF2A2A5  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF2A2A9  387001                            bra.w   loc_FFF2A419
FFF2A2AC  ed0121                 loc_FFF2A2AC mov.l   0B4h+var_30[sp], r1
FFF2A2AF  6101                              cmp     #0, r1
FFF2A2B1  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A2B4  202e                              beq.b   loc_FFF2A2E2
FFF2A2B6  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2A2B9  ed0221                            mov.l   0B4h+var_30[sp], r2
FFF2A2BC  7100f0                            add     #-10h, sp, sp
FFF2A2BF  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF2A2C1  72048800                          add     #0C4h+var_3C, sp, r4
FFF2A2C5  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF2A2C7  72048c00                          add     #0C4h+var_38, sp, r4
FFF2A2CB  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF2A2CD  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF2A2D0  f80402                            mov.b   #2, 0C4h+var_C4[sp]
FFF2A2D3  710460                            add     #0C4h+var_64, sp, r4
FFF2A2D6  056588ff                          bsr.a   sub_FFF22B3B
FFF2A2DA  710010                            add     #10h, sp, sp
FFF2A2DD  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A2E0  2e20                              bra.b   loc_FFF2A300
FFF2A2E2  ed0229                 loc_FFF2A2E2 mov.l   0B4h+var_10[sp], r2
FFF2A2E5  60c0                              sub     #0Ch, sp
FFF2A2E7  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF2A2E9  72038800                          add     #0C0h+var_38, sp, r3
FFF2A2ED  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF2A2EF  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF2A2F2  6624                              mov.l   #2, r4
FFF2A2F4  71035c                            add     #0C0h+var_64, sp, r3
FFF2A2F7  05d383ff                          bsr.a   sub_FFF226CA
FFF2A2FB  62c0                              add     #0Ch, sp
FFF2A2FD  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A300  ed0127                 loc_FFF2A300 mov.l   0B4h+var_18[sp], r1
FFF2A303  6101                              cmp     #0, r1
FFF2A305  10                                beq.s   loc_FFF2A30D
FFF2A306  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF2A30A  380f01                            bra.w   loc_FFF2A419
FFF2A30D  ed0120                 loc_FFF2A30D mov.l   0B4h+var_34[sp], r1
FFF2A310  6101                              cmp     #0, r1
FFF2A312  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A315  2032                              beq.b   loc_FFF2A347
FFF2A317  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2A31A  ed0220                            mov.l   0B4h+var_34[sp], r2
FFF2A31D  7100f0                            add     #-10h, sp, sp
FFF2A320  72048800                          add     #0C4h+var_3C, sp, r4
FFF2A324  a084                              mov.l   r4, 0C4h+var_BC[sp]
FFF2A326  72048c00                          add     #0C4h+var_38, sp, r4
FFF2A32A  a00c                              mov.l   r4, 0C4h+var_C0[sp]
FFF2A32C  3c0100                            mov.b   #0, 0C4h+var_C3[sp]
FFF2A32F  f80401                            mov.b   #1, 0C4h+var_C4[sp]
FFF2A332  a08b                              mov.l   r3, 0C4h+var_B8[sp]
FFF2A334  72330602                          add     #206h, r3, r3
FFF2A338  710440                            add     #0C4h+var_84, sp, r4
FFF2A33B  050088ff                          bsr.a   sub_FFF22B3B
FFF2A33F  710010                            add     #10h, sp, sp
FFF2A342  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A345  2e24                              bra.b   loc_FFF2A369
FFF2A347  ed0229                 loc_FFF2A347 mov.l   0B4h+var_10[sp], r2
FFF2A34A  60c0                              sub     #0Ch, sp
FFF2A34C  72038800                          add     #0C0h+var_38, sp, r3
FFF2A350  a00b                              mov.l   r3, 0C0h+var_BC[sp]
FFF2A352  f80400                            mov.b   #0, 0C0h+var_C0[sp]
FFF2A355  a082                              mov.l   r2, 0C0h+var_B8[sp]
FFF2A357  72220602                          add     #206h, r2, r2
FFF2A35B  6614                              mov.l   #1, r4
FFF2A35D  71033c                            add     #0C0h+var_84, sp, r3
FFF2A360  056a83ff                          bsr.a   sub_FFF226CA
FFF2A364  62c0                              add     #0Ch, sp
FFF2A366  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A369  ed0127                 loc_FFF2A369 mov.l   0B4h+var_18[sp], r1
FFF2A36C  6101                              cmp     #0, r1
FFF2A36E  10                                beq.s   loc_FFF2A376
FFF2A36F  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF2A373  38a600                            bra.w   loc_FFF2A419
FFF2A376  f5043b                 loc_FFF2A376 btst    #4, 0B4h+var_79[sp].b
FFF2A379  200e                              beq.b   loc_FFF2A387
FFF2A37B  ed0121                            mov.l   0B4h+var_30[sp], r1
FFF2A37E  06850120                          cmp     0B4h+var_34[sp].l, r1
FFF2A382  15                                beq.s   loc_FFF2A387
FFF2A383  f80601                            mov.l   #1, 0B4h+var_B4[sp]
FFF2A386  0c                                bra.s   loc_FFF2A38A
FFF2A387  f80600                 loc_FFF2A387 mov.l   #0, 0B4h+var_B4[sp]
FFF2A38A  ec01                   loc_FFF2A38A mov.l   0B4h+var_B4[sp], r1
FFF2A38C  6101                              cmp     #0, r1
FFF2A38E  3a8800                            beq.w   loc_FFF2A416
FFF2A391  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A394  8c12                              mov.b   10h[r1], r2
FFF2A396  710130                            add     #0B4h+var_84, sp, r1
FFF2A399  05ff62ff                          bsr.a   sub_FFF20698
FFF2A39D  a709                              mov.l   r1, 0B4h+var_40[sp]
FFF2A39F  af0a                              mov.l   0B4h+var_40[sp], r2
FFF2A3A1  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A3A4  05084cff                          bsr.a   sub_FFF1EFAC
FFF2A3A8  a781                              mov.l   r1, 0B4h+var_3C[sp]
FFF2A3AA  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2A3AD  af82                              mov.l   0B4h+var_3C[sp], r2
FFF2A3AF  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A3B2  72330c0c                          add     #0C0Ch, r3, r3
FFF2A3B6  6614                              mov.l   #1, r4
FFF2A3B8  05594cff                          bsr.a   sub_FFF1F011
FFF2A3BC  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A3BF  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2A3C2  6101                              cmp     #0, r1
FFF2A3C4  17                                beq.s   loc_FFF2A3CB
FFF2A3C5  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF2A3C9  2e50                              bra.b   loc_FFF2A419
FFF2A3CB  ed0129                 loc_FFF2A3CB mov.l   0B4h+var_10[sp], r1
FFF2A3CE  72110c0c                          add     #0C0Ch, r1, r1
FFF2A3D2  a701                              mov.l   r1, 0B4h+var_44[sp]
FFF2A3D4  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A3D7  ed0220                            mov.l   0B4h+var_34[sp], r2
FFF2A3DA  0685120d                          cmp     34h[r1].l, r2
FFF2A3DE  1d                                bne.s   locret_FFF2A3E3
FFF2A3DF  f9062000                          mov.l   #0, 0B4h+var_34[sp]
FFF2A3E3  af01                   locret_FFF2A3E3 mov.l   0B4h+var_44[sp], r1
FFF2A3E5  711120                            add     #20h, r1, r1 ; ' '
FFF2A3E8  a701                              mov.l   r1, 0B4h+var_44[sp]
FFF2A3EA  ed022c                            mov.l   0B4h+var_4[sp], r2
FFF2A3ED  8c23                              mov.b   10h[r2], r3
FFF2A3EF  ed0220                            mov.l   0B4h+var_34[sp], r2
FFF2A3F2  05f262ff                          bsr.a   sub_FFF206E4
FFF2A3F6  ed0329                            mov.l   0B4h+var_10[sp], r3
FFF2A3F9  af82                              mov.l   0B4h+var_3C[sp], r2
FFF2A3FB  ed012c                            mov.l   0B4h+var_4[sp], r1
FFF2A3FE  72330c0c                          add     #0C0Ch, r3, r3
FFF2A402  6614                              mov.l   #1, r4
FFF2A404  059e4cff                          bsr.a   sub_FFF1F0A2
FFF2A408  e70127                            mov.l   r1, 0B4h+var_18[sp]
FFF2A40B  ed0127                            mov.l   0B4h+var_18[sp], r1
FFF2A40E  6101                              cmp     #0, r1
FFF2A410  16                                beq.s   loc_FFF2A416
FFF2A411  e5002701                          mov.l   0B4h+var_18[sp], 0B4h+var_B0[sp]
FFF2A415  0c                                bra.s   loc_FFF2A419
FFF2A416  3e0100                 loc_FFF2A416 mov.l   #0, 0B4h+var_B0[sp]
FFF2A419  a809                   loc_FFF2A419 mov.l   0B4h+var_B0[sp], r1
FFF2A41B  e70128                            mov.l   r1, 0B4h+var_14[sp]
FFF2A41E  672d                              rtsd    #2Dh
FFF2A420  7100e8                 sub_FFF2A420 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2A420
FFF2A423  a109                              mov.l   r1, 18h+var_4[sp]
FFF2A425  a102                              mov.l   r2, 18h+var_8[sp]
FFF2A427  056fbafe                          bsr.a   sub_FFF15E96
FFF2A42B  a009                              mov.l   r1, 18h+var_14[sp]
FFF2A42D  a809                              mov.l   18h+var_14[sp], r1
FFF2A42F  6101                              cmp     #0, r1
FFF2A431  210f                              bne.b   loc_FFF2A440
FFF2A433  6602                              mov.l   #0, r2
FFF2A435  fb16e1                            mov.l   #-1Fh, r1
FFF2A438  05e849ff                          bsr.a   sub_FFF1EE20
FFF2A43C  e301                              mov.l   r1, 18h+var_18[sp]
FFF2A43E  2e16                              bra.b   loc_FFF2A454
FFF2A440  a80b                   loc_FFF2A440 mov.l   18h+var_14[sp], r3
FFF2A442  a902                              mov.l   18h+var_8[sp], r2
FFF2A444  a909                              mov.l   18h+var_4[sp], r1
FFF2A446  391400                            bsr.w   sub_FFF2A45A
FFF2A449  a081                              mov.l   r1, 18h+var_10[sp]
FFF2A44B  a809                              mov.l   18h+var_14[sp], r1
FFF2A44D  0559bafe                          bsr.a   sub_FFF15EA6
FFF2A451  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF2A454  ec01                   loc_FFF2A454 mov.l   18h+var_18[sp], r1
FFF2A456  a089                              mov.l   r1, 18h+var_C[sp]
FFF2A458  6706                              rtsd    #6
FFF2A45A  7100e8                 sub_FFF2A45A add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2A45A
FFF2A45D  a109                              mov.l   r1, 18h+var_4[sp]
FFF2A45F  a102                              mov.l   r2, 18h+var_8[sp]
FFF2A461  a08b                              mov.l   r3, 18h+var_C[sp]
FFF2A463  0588abff                          bsr.a   sub_FFF24FEB
FFF2A467  a009                              mov.l   r1, 18h+var_14[sp]
FFF2A469  a809                              mov.l   18h+var_14[sp], r1
FFF2A46B  6101                              cmp     #0, r1
FFF2A46D  200f                              beq.b   loc_FFF2A47C
FFF2A46F  a809                              mov.l   18h+var_14[sp], r1
FFF2A471  6602                              mov.l   #0, r2
FFF2A473  05ad49ff                          bsr.a   sub_FFF1EE20
FFF2A477  e301                              mov.l   r1, 18h+var_18[sp]
FFF2A479  388400                            bra.w   loc_FFF2A4FD
FFF2A47C  a909                   loc_FFF2A47C mov.l   18h+var_4[sp], r1
FFF2A47E  6101                              cmp     #0, r1
FFF2A480  210f                              bne.b   loc_FFF2A48F
FFF2A482  6602                              mov.l   #0, r2
FFF2A484  fb16ff                            mov.l   #-1, r1
FFF2A487  059949ff                          bsr.a   sub_FFF1EE20
FFF2A48B  e301                              mov.l   r1, 18h+var_18[sp]
FFF2A48D  2e70                              bra.b   loc_FFF2A4FD
FFF2A48F  a901                   loc_FFF2A48F mov.l   18h+var_8[sp], r1
FFF2A491  6101                              cmp     #0, r1
FFF2A493  210f                              bne.b   loc_FFF2A4A2
FFF2A495  6602                              mov.l   #0, r2
FFF2A497  fb16f3                            mov.l   #-0Dh, r1
FFF2A49A  058649ff                          bsr.a   sub_FFF1EE20
FFF2A49E  e301                              mov.l   r1, 18h+var_18[sp]
FFF2A4A0  2e5d                              bra.b   loc_FFF2A4FD
FFF2A4A2  a909                   loc_FFF2A4A2 mov.l   18h+var_4[sp], r1
FFF2A4A4  055792ff                          bsr.a   sub_FFF236FB
FFF2A4A8  a009                              mov.l   r1, 18h+var_14[sp]
FFF2A4AA  a809                              mov.l   18h+var_14[sp], r1
FFF2A4AC  6101                              cmp     #0, r1
FFF2A4AE  200e                              beq.b   loc_FFF2A4BC
FFF2A4B0  a809                              mov.l   18h+var_14[sp], r1
FFF2A4B2  6602                              mov.l   #0, r2
FFF2A4B4  056c49ff                          bsr.a   sub_FFF1EE20
FFF2A4B8  e301                              mov.l   r1, 18h+var_18[sp]
FFF2A4BA  2e43                              bra.b   loc_FFF2A4FD
FFF2A4BC  a90a                   loc_FFF2A4BC mov.l   18h+var_4[sp], r2
FFF2A4BE  a889                              mov.l   18h+var_C[sp], r1
FFF2A4C0  72110c10                          add     #100Ch, r1, r1
FFF2A4C4  05814700                          bsr.a   sub_FFF2EC45
FFF2A4C8  a889                              mov.l   18h+var_C[sp], r1
FFF2A4CA  72110c10                          add     #100Ch, r1, r1
FFF2A4CE  054e91ff                          bsr.a   sub_FFF2361C
FFF2A4D2  a009                              mov.l   r1, 18h+var_14[sp]
FFF2A4D4  a809                              mov.l   18h+var_14[sp], r1
FFF2A4D6  6101                              cmp     #0, r1
FFF2A4D8  200e                              beq.b   loc_FFF2A4E6
FFF2A4DA  a809                              mov.l   18h+var_14[sp], r1
FFF2A4DC  6602                              mov.l   #0, r2
FFF2A4DE  054249ff                          bsr.a   sub_FFF1EE20
FFF2A4E2  e301                              mov.l   r1, 18h+var_18[sp]
FFF2A4E4  2e19                              bra.b   loc_FFF2A4FD
FFF2A4E6  a88b                   loc_FFF2A4E6 mov.l   18h+var_C[sp], r3
FFF2A4E8  a902                              mov.l   18h+var_8[sp], r2
FFF2A4EA  72310c10                          add     #100Ch, r3, r1
FFF2A4EE  391500                            bsr.w   sub_FFF2A503
FFF2A4F1  a009                              mov.l   r1, 18h+var_14[sp]
FFF2A4F3  a809                              mov.l   18h+var_14[sp], r1
FFF2A4F5  6602                              mov.l   #0, r2
FFF2A4F7  052949ff                          bsr.a   sub_FFF1EE20
FFF2A4FB  e301                              mov.l   r1, 18h+var_18[sp]
FFF2A4FD  ec01                   loc_FFF2A4FD mov.l   18h+var_18[sp], r1
FFF2A4FF  a081                              mov.l   r1, 18h+var_10[sp]
FFF2A501  6706                              rtsd    #6
FFF2A503  7ea6                   sub_FFF2A503 push.l  r6   ; <<<< FUNC sub_FFF2A503
FFF2A505  7100ac                            add     #-54h, sp, sp
FFF2A508  a501                              mov.l   r1, 54h+var_4[sp]
FFF2A50A  a48a                              mov.l   r2, 54h+var_8[sp]
FFF2A50C  a483                              mov.l   r3, 54h+var_C[sp]
FFF2A50E  3e0e00                            mov.l   #0, 54h+var_1C[sp]
FFF2A511  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2A517  e4e003                            mov.l   [r14], 54h+var_48[sp]
FFF2A51A  ad01                              mov.l   54h+var_4[sp], r1
FFF2A51C  cc11                              mov.b   [r1], r1
FFF2A51E  056d4200                          bsr.a   sub_FFF2E78B
FFF2A522  8289                              mov.b   r1, 54h+var_49[sp]
FFF2A524  b289                              movu.b  54h+var_49[sp], r1
FFF2A526  71020c                            add     #54h+var_48, sp, r2
FFF2A529  05f649ff                          bsr.a   sub_FFF1EF1F
FFF2A52D  a401                              mov.l   r1, 54h+var_14[sp]
FFF2A52F  ac01                              mov.l   54h+var_14[sp], r1
FFF2A531  6101                              cmp     #0, r1
FFF2A533  10                                beq.s   loc_FFF2A53B
FFF2A534  e5001001                          mov.l   54h+var_14[sp], 54h+var_50[sp]
FFF2A538  389201                            bra.w   loc_FFF2A6CA
FFF2A53B  a889                   loc_FFF2A53B mov.l   54h+var_48[sp], r1
FFF2A53D  05204aff                          bsr.a   sub_FFF1EF5D
FFF2A541  a401                              mov.l   r1, 54h+var_14[sp]
FFF2A543  ac01                              mov.l   54h+var_14[sp], r1
FFF2A545  6101                              cmp     #0, r1
FFF2A547  10                                beq.s   loc_FFF2A54F
FFF2A548  e5001001                          mov.l   54h+var_14[sp], 54h+var_50[sp]
FFF2A54C  387e01                            bra.w   loc_FFF2A6CA
FFF2A54F  ad01                   loc_FFF2A54F mov.l   54h+var_4[sp], r1
FFF2A551  6241                              add     #4, r1
FFF2A553  a389                              mov.l   r1, 54h+var_18[sp]
FFF2A555  a889                              mov.l   54h+var_48[sp], r1
FFF2A557  e5100d0e                          mov.l   34h[r1], 54h+var_1C[sp]
FFF2A55B  a889                              mov.l   54h+var_48[sp], r1
FFF2A55D  8c11                              mov.b   10h[r1], r1
FFF2A55F  755120                            cmp     #20h, r1 ; ' '
FFF2A562  3a1901                            beq.w   loc_FFF2A67B
FFF2A565  ac82                              mov.l   54h+var_C[sp], r2
FFF2A567  ab89                              mov.l   54h+var_18[sp], r1
FFF2A569  05aa8eff                          bsr.a   sub_FFF23413
FFF2A56D  a389                              mov.l   r1, 54h+var_18[sp]
FFF2A56F  ab89                              mov.l   54h+var_18[sp], r1
FFF2A571  6101                              cmp     #0, r1
FFF2A573  18                                bne.s   loc_FFF2A57B
FFF2A574  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2A578  385201                            bra.w   loc_FFF2A6CA
FFF2A57B  ac81                   loc_FFF2A57B mov.l   54h+var_C[sp], r1
FFF2A57D  cc1e                              mov.b   [r1], r14
FFF2A57F  610e                              cmp     #0, r14
FFF2A581  210d                              bne.b   loc_FFF2A58E
FFF2A583  ac81                              mov.l   54h+var_C[sp], r1
FFF2A585  8819                              mov.b   1[r1], r1
FFF2A587  6101                              cmp     #0, r1
FFF2A589  1d                                bne.s   loc_FFF2A58E
FFF2A58A  f80601                            mov.l   #1, 54h+var_54[sp]
FFF2A58D  0c                                bra.s   loc_FFF2A591
FFF2A58E  f80600                 loc_FFF2A58E mov.l   #0, 54h+var_54[sp]
FFF2A591  ec01                   loc_FFF2A591 mov.l   54h+var_54[sp], r1
FFF2A593  6101                              cmp     #0, r1
FFF2A595  10                                beq.s   loc_FFF2A59D
FFF2A596  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2A59A  383001                            bra.w   loc_FFF2A6CA
FFF2A59D  ac82                   loc_FFF2A59D mov.l   54h+var_C[sp], r2
FFF2A59F  a889                              mov.l   54h+var_48[sp], r1
FFF2A5A1  60c0                              sub     #0Ch, sp
FFF2A5A3  a082                              mov.l   r2, 60h+var_58[sp]
FFF2A5A5  710340                            add     #60h+var_20, sp, r3
FFF2A5A8  a00b                              mov.l   r3, 60h+var_5C[sp]
FFF2A5AA  f80400                            mov.b   #0, 60h+var_60[sp]
FFF2A5AD  6604                              mov.l   #0, r4
FFF2A5AF  71031c                            add     #60h+var_44, sp, r3
FFF2A5B2  05c080ff                          bsr.a   sub_FFF22672
FFF2A5B6  62c0                              add     #0Ch, sp
FFF2A5B8  a401                              mov.l   r1, 54h+var_14[sp]
FFF2A5BA  ac01                              mov.l   54h+var_14[sp], r1
FFF2A5BC  6101                              cmp     #0, r1
FFF2A5BE  2017                              beq.b   loc_FFF2A5D5
FFF2A5C0  ab89                              mov.l   54h+var_18[sp], r1
FFF2A5C2  cc1e                              mov.b   [r1], r14
FFF2A5C4  610e                              cmp     #0, r14
FFF2A5C6  10                                beq.s   loc_FFF2A5CE
FFF2A5C7  f90601fc                          mov.l   #-4, 54h+var_50[sp]
FFF2A5CB  38ff00                            bra.w   loc_FFF2A6CA
FFF2A5CE  f90601fd               loc_FFF2A5CE mov.l   #-3, 54h+var_50[sp]
FFF2A5D2  38f800                            bra.w   loc_FFF2A6CA
FFF2A5D5  a889                   loc_FFF2A5D5 mov.l   54h+var_48[sp], r1
FFF2A5D7  8c12                              mov.b   10h[r1], r2
FFF2A5D9  710110                            add     #54h+var_44, sp, r1
FFF2A5DC  05bc60ff                          bsr.a   sub_FFF20698
FFF2A5E0  a381                              mov.l   r1, 54h+var_1C[sp]
FFF2A5E2  389900                            bra.w   loc_FFF2A67B
FFF2A5E5  ac82                   loc_FFF2A5E5 mov.l   54h+var_C[sp], r2
FFF2A5E7  ab89                              mov.l   54h+var_18[sp], r1
FFF2A5E9  052a8eff                          bsr.a   sub_FFF23413
FFF2A5ED  a389                              mov.l   r1, 54h+var_18[sp]
FFF2A5EF  ab89                              mov.l   54h+var_18[sp], r1
FFF2A5F1  6101                              cmp     #0, r1
FFF2A5F3  18                                bne.s   loc_FFF2A5FB
FFF2A5F4  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2A5F8  38d200                            bra.w   loc_FFF2A6CA
FFF2A5FB  ac81                   loc_FFF2A5FB mov.l   54h+var_C[sp], r1
FFF2A5FD  cc1e                              mov.b   [r1], r14
FFF2A5FF  610e                              cmp     #0, r14
FFF2A601  210d                              bne.b   loc_FFF2A60E
FFF2A603  ac81                              mov.l   54h+var_C[sp], r1
FFF2A605  8819                              mov.b   1[r1], r1
FFF2A607  6101                              cmp     #0, r1
FFF2A609  1d                                bne.s   loc_FFF2A60E
FFF2A60A  f80601                            mov.l   #1, 54h+var_54[sp]
FFF2A60D  0c                                bra.s   loc_FFF2A611
FFF2A60E  f80600                 loc_FFF2A60E mov.l   #0, 54h+var_54[sp]
FFF2A611  ec01                   loc_FFF2A611 mov.l   54h+var_54[sp], r1
FFF2A613  6101                              cmp     #0, r1
FFF2A615  10                                beq.s   loc_FFF2A61D
FFF2A616  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2A61A  38b000                            bra.w   loc_FFF2A6CA
FFF2A61D  ac83                   loc_FFF2A61D mov.l   54h+var_C[sp], r3
FFF2A61F  ab82                              mov.l   54h+var_1C[sp], r2
FFF2A621  a889                              mov.l   54h+var_48[sp], r1
FFF2A623  7100f0                            add     #-10h, sp, sp
FFF2A626  a08b                              mov.l   r3, 64h+var_58[sp]
FFF2A628  710440                            add     #64h+var_24, sp, r4
FFF2A62B  a084                              mov.l   r4, 64h+var_5C[sp]
FFF2A62D  710444                            add     #64h+var_20, sp, r4
FFF2A630  a00c                              mov.l   r4, 64h+var_60[sp]
FFF2A632  3c0100                            mov.b   #0, 64h+var_63[sp]
FFF2A635  f80400                            mov.b   #0, 64h+var_64[sp]
FFF2A638  710420                            add     #64h+var_44, sp, r4
FFF2A63B  059284ff                          bsr.a   sub_FFF22ACD
FFF2A63F  710010                            add     #10h, sp, sp
FFF2A642  a401                              mov.l   r1, 54h+var_14[sp]
FFF2A644  ac01                              mov.l   54h+var_14[sp], r1
FFF2A646  6101                              cmp     #0, r1
FFF2A648  2026                              beq.b   loc_FFF2A66E
FFF2A64A  ab89                              mov.l   54h+var_18[sp], r1
FFF2A64C  cc1e                              mov.b   [r1], r14
FFF2A64E  610e                              cmp     #0, r14
FFF2A650  210c                              bne.b   loc_FFF2A65C
FFF2A652  ac01                              mov.l   54h+var_14[sp], r1
FFF2A654  7501fc                            cmp     #-4, r1
FFF2A657  1d                                bne.s   loc_FFF2A65C
FFF2A658  f80601                            mov.l   #1, 54h+var_54[sp]
FFF2A65B  0c                                bra.s   loc_FFF2A65F
FFF2A65C  f80600                 loc_FFF2A65C mov.l   #0, 54h+var_54[sp]
FFF2A65F  ec01                   loc_FFF2A65F mov.l   54h+var_54[sp], r1
FFF2A661  6101                              cmp     #0, r1
FFF2A663  15                                beq.s   loc_FFF2A668
FFF2A664  f90610fd                          mov.l   #-3, 54h+var_14[sp]
FFF2A668  e5001001               loc_FFF2A668 mov.l   54h+var_14[sp], 54h+var_50[sp]
FFF2A66C  2e5e                              bra.b   loc_FFF2A6CA
FFF2A66E  a889                   loc_FFF2A66E mov.l   54h+var_48[sp], r1
FFF2A670  8c12                              mov.b   10h[r1], r2
FFF2A672  710110                            add     #54h+var_44, sp, r1
FFF2A675  052360ff                          bsr.a   sub_FFF20698
FFF2A679  a381                              mov.l   r1, 54h+var_1C[sp]
FFF2A67B  ab89                   loc_FFF2A67B mov.l   54h+var_18[sp], r1
FFF2A67D  cc1e                              mov.b   [r1], r14
FFF2A67F  610e                              cmp     #0, r14
FFF2A681  3b64ff                            bne.w   loc_FFF2A5E5
FFF2A684  ac89                              mov.l   54h+var_8[sp], r1
FFF2A686  66b3                              mov.l   #0Bh, r3
FFF2A688  710210                            add     #54h+var_44, sp, r2
FFF2A68B  05ed3d00                          bsr.a   sub_FFF2E478
FFF2A68F  ac89                              mov.l   54h+var_8[sp], r1
FFF2A691  cc1e                              mov.b   [r1], r14
FFF2A693  615e                              cmp     #5, r14
FFF2A695  1e                                bne.s   loc_FFF2A69B
FFF2A696  ac89                              mov.l   54h+var_8[sp], r1
FFF2A698  f814e5                            mov.b   #-1Bh, [r1]
FFF2A69B  b689                   loc_FFF2A69B movu.b  54h+var_39[sp], r1
FFF2A69D  ac8a                              mov.l   54h+var_8[sp], r2
FFF2A69F  82a9                              mov.b   r1, 0Bh[r2]
FFF2A6A1  bd03                              movu.w  54h+var_2C[sp], r3
FFF2A6A3  bc8a                              movu.w  54h+var_2E[sp], r2
FFF2A6A5  ac89                              mov.l   54h+var_8[sp], r1
FFF2A6A7  62c1                              add     #0Ch, r1
FFF2A6A9  058b60ff                          bsr.a   sub_FFF20734
FFF2A6AD  a889                              mov.l   54h+var_48[sp], r1
FFF2A6AF  8c12                              mov.b   10h[r1], r2
FFF2A6B1  ac8e                              mov.l   54h+var_8[sp], r6
FFF2A6B3  710110                            add     #54h+var_44, sp, r1
FFF2A6B6  05e25fff                          bsr.a   sub_FFF20698
FFF2A6BA  a361                              mov.l   r1, 30h[r6]
FFF2A6BC  ac8e                              mov.l   54h+var_8[sp], r6
FFF2A6BE  71012c                            add     #54h+var_28, sp, r1
FFF2A6C1  05594600                          bsr.a   sub_FFF2ED1A
FFF2A6C5  a369                              mov.l   r1, 34h[r6]
FFF2A6C7  3e0100                            mov.l   #0, 54h+var_50[sp]
FFF2A6CA  a809                   loc_FFF2A6CA mov.l   54h+var_50[sp], r1
FFF2A6CC  a409                              mov.l   r1, 54h+var_10[sp]
FFF2A6CE  3f6616                            rtsd    #58h, r6-r6
FFF2A6D1  7100e8                 sub_FFF2A6D1 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2A6D1
FFF2A6D4  a109                              mov.l   r1, 18h+var_4[sp]
FFF2A6D6  a102                              mov.l   r2, 18h+var_8[sp]
FFF2A6D8  05beb7fe                          bsr.a   sub_FFF15E96
FFF2A6DC  a009                              mov.l   r1, 18h+var_14[sp]
FFF2A6DE  a809                              mov.l   18h+var_14[sp], r1
FFF2A6E0  6101                              cmp     #0, r1
FFF2A6E2  210f                              bne.b   loc_FFF2A6F1
FFF2A6E4  6602                              mov.l   #0, r2
FFF2A6E6  fb16e1                            mov.l   #-1Fh, r1
FFF2A6E9  053747ff                          bsr.a   sub_FFF1EE20
FFF2A6ED  e301                              mov.l   r1, 18h+var_18[sp]
FFF2A6EF  2e16                              bra.b   loc_FFF2A705
FFF2A6F1  a80b                   loc_FFF2A6F1 mov.l   18h+var_14[sp], r3
FFF2A6F3  a902                              mov.l   18h+var_8[sp], r2
FFF2A6F5  a909                              mov.l   18h+var_4[sp], r1
FFF2A6F7  391400                            bsr.w   sub_FFF2A70B
FFF2A6FA  a081                              mov.l   r1, 18h+var_10[sp]
FFF2A6FC  a809                              mov.l   18h+var_14[sp], r1
FFF2A6FE  05a8b7fe                          bsr.a   sub_FFF15EA6
FFF2A702  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF2A705  ec01                   loc_FFF2A705 mov.l   18h+var_18[sp], r1
FFF2A707  a089                              mov.l   r1, 18h+var_C[sp]
FFF2A709  6706                              rtsd    #6
FFF2A70B  7100d8                 sub_FFF2A70B add     #-28h, sp, sp   ; <<<< FUNC sub_FFF2A70B
FFF2A70E  a209                              mov.l   r1, 28h+var_4[sp]
FFF2A710  a202                              mov.l   r2, 28h+var_8[sp]
FFF2A712  a18b                              mov.l   r3, 28h+var_C[sp]
FFF2A714  aa01                              mov.l   28h+var_8[sp], r1
FFF2A716  8489                              mov.b   r1, 28h+var_15[sp]
FFF2A718  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2A71E  e4e003                            mov.l   [r14], 28h+var_1C[sp]
FFF2A721  05caa8ff                          bsr.a   sub_FFF24FEB
FFF2A725  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A727  a909                              mov.l   28h+var_14[sp], r1
FFF2A729  6101                              cmp     #0, r1
FFF2A72B  200f                              beq.b   loc_FFF2A73A
FFF2A72D  a909                              mov.l   28h+var_14[sp], r1
FFF2A72F  6602                              mov.l   #0, r2
FFF2A731  05ef46ff                          bsr.a   sub_FFF1EE20
FFF2A735  a009                              mov.l   r1, 28h+var_24[sp]
FFF2A737  384201                            bra.w   loc_FFF2A879
FFF2A73A  aa09                   loc_FFF2A73A mov.l   28h+var_4[sp], r1
FFF2A73C  6101                              cmp     #0, r1
FFF2A73E  2110                              bne.b   loc_FFF2A74E
FFF2A740  6602                              mov.l   #0, r2
FFF2A742  fb16ff                            mov.l   #-1, r1
FFF2A745  05db46ff                          bsr.a   sub_FFF1EE20
FFF2A749  a009                              mov.l   r1, 28h+var_24[sp]
FFF2A74B  382e01                            bra.w   loc_FFF2A879
FFF2A74E  aa09                   loc_FFF2A74E mov.l   28h+var_4[sp], r1
FFF2A750  05ab8fff                          bsr.a   sub_FFF236FB
FFF2A754  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A756  a909                              mov.l   28h+var_14[sp], r1
FFF2A758  6101                              cmp     #0, r1
FFF2A75A  200f                              beq.b   loc_FFF2A769
FFF2A75C  a909                              mov.l   28h+var_14[sp], r1
FFF2A75E  6602                              mov.l   #0, r2
FFF2A760  05c046ff                          bsr.a   sub_FFF1EE20
FFF2A764  a009                              mov.l   r1, 28h+var_24[sp]
FFF2A766  381301                            bra.w   loc_FFF2A879
FFF2A769  aa0a                   loc_FFF2A769 mov.l   28h+var_4[sp], r2
FFF2A76B  a989                              mov.l   28h+var_C[sp], r1
FFF2A76D  72110c10                          add     #100Ch, r1, r1
FFF2A771  05d44400                          bsr.a   sub_FFF2EC45
FFF2A775  a989                              mov.l   28h+var_C[sp], r1
FFF2A777  72110c10                          add     #100Ch, r1, r1
FFF2A77B  05a18eff                          bsr.a   sub_FFF2361C
FFF2A77F  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A781  a909                              mov.l   28h+var_14[sp], r1
FFF2A783  6101                              cmp     #0, r1
FFF2A785  200f                              beq.b   loc_FFF2A794
FFF2A787  a909                              mov.l   28h+var_14[sp], r1
FFF2A789  6602                              mov.l   #0, r2
FFF2A78B  059546ff                          bsr.a   sub_FFF1EE20
FFF2A78F  a009                              mov.l   r1, 28h+var_24[sp]
FFF2A791  38e800                            bra.w   loc_FFF2A879
FFF2A794  a989                   loc_FFF2A794 mov.l   28h+var_C[sp], r1
FFF2A796  ce110c10                          mov.b   100Ch[r1], r1
FFF2A79A  05f13f00                          bsr.a   sub_FFF2E78B
FFF2A79E  8289                              mov.b   r1, 28h+var_1D[sp]
FFF2A7A0  b289                              movu.b  28h+var_1D[sp], r1
FFF2A7A2  71020c                            add     #28h+var_1C, sp, r2
FFF2A7A5  057a47ff                          bsr.a   sub_FFF1EF1F
FFF2A7A9  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A7AB  a909                              mov.l   28h+var_14[sp], r1
FFF2A7AD  6101                              cmp     #0, r1
FFF2A7AF  200f                              beq.b   loc_FFF2A7BE
FFF2A7B1  a909                              mov.l   28h+var_14[sp], r1
FFF2A7B3  6602                              mov.l   #0, r2
FFF2A7B5  056b46ff                          bsr.a   sub_FFF1EE20
FFF2A7B9  a009                              mov.l   r1, 28h+var_24[sp]
FFF2A7BB  38be00                            bra.w   loc_FFF2A879
FFF2A7BE  a889                   loc_FFF2A7BE mov.l   28h+var_1C[sp], r1
FFF2A7C0  591e6c                            movu.b  6Ch[r1], r14
FFF2A7C3  641e                              and     #1, r14
FFF2A7C5  611e                              cmp     #1, r14
FFF2A7C7  200e                              beq.b   loc_FFF2A7D5
FFF2A7C9  a889                              mov.l   28h+var_1C[sp], r1
FFF2A7CB  591e6c                            movu.b  6Ch[r1], r14
FFF2A7CE  752e10                            and     #10h, r14
FFF2A7D1  755e10                            cmp     #10h, r14
FFF2A7D4  1d                                bne.s   loc_FFF2A7D9
FFF2A7D5  f80601                 loc_FFF2A7D5 mov.l   #1, 28h+var_28[sp]
FFF2A7D8  0c                                bra.s   loc_FFF2A7DC
FFF2A7D9  f80600                 loc_FFF2A7D9 mov.l   #0, 28h+var_28[sp]
FFF2A7DC  ec01                   loc_FFF2A7DC mov.l   28h+var_28[sp], r1
FFF2A7DE  6101                              cmp     #0, r1
FFF2A7E0  2035                              beq.b   loc_FFF2A815
FFF2A7E2  a889                              mov.l   28h+var_1C[sp], r1
FFF2A7E4  05ffb5fe                          bsr.a   sub_FFF15DE3
FFF2A7E8  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A7EA  a909                              mov.l   28h+var_14[sp], r1
FFF2A7EC  6101                              cmp     #0, r1
FFF2A7EE  200f                              beq.b   loc_FFF2A7FD
FFF2A7F0  6602                              mov.l   #0, r2
FFF2A7F2  fb16c1                            mov.l   #-3Fh, r1
FFF2A7F5  052b46ff                          bsr.a   sub_FFF1EE20
FFF2A7F9  a009                              mov.l   r1, 28h+var_24[sp]
FFF2A7FB  2e7e                              bra.b   loc_FFF2A879
FFF2A7FD  a98c                   loc_FFF2A7FD mov.l   28h+var_C[sp], r4
FFF2A7FF  72410c10                          add     #100Ch, r4, r1
FFF2A803  6603                              mov.l   #0, r3
FFF2A805  710213                            add     #28h+var_15, sp, r2
FFF2A808  397700                            bsr.w   sub_FFF2A87F
FFF2A80B  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A80D  a889                              mov.l   28h+var_1C[sp], r1
FFF2A80F  05dfb5fe                          bsr.a   sub_FFF15DEE
FFF2A813  2e12                              bra.b   loc_FFF2A825
FFF2A815  a98c                   loc_FFF2A815 mov.l   28h+var_C[sp], r4
FFF2A817  72410c10                          add     #100Ch, r4, r1
FFF2A81B  6603                              mov.l   #0, r3
FFF2A81D  710213                            add     #28h+var_15, sp, r2
FFF2A820  395f00                            bsr.w   sub_FFF2A87F
FFF2A823  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A825  a889                   loc_FFF2A825 mov.l   28h+var_1C[sp], r1
FFF2A827  591e6c                            movu.b  6Ch[r1], r14
FFF2A82A  752e10                            and     #10h, r14
FFF2A82D  755e10                            cmp     #10h, r14
FFF2A830  211c                              bne.b   loc_FFF2A84C
FFF2A832  a889                              mov.l   28h+var_1C[sp], r1
FFF2A834  05a823ff                          bsr.a   sub_FFF1CBDC
FFF2A838  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A83A  a909                              mov.l   28h+var_14[sp], r1
FFF2A83C  6101                              cmp     #0, r1
FFF2A83E  200e                              beq.b   loc_FFF2A84C
FFF2A840  a909                              mov.l   28h+var_14[sp], r1
FFF2A842  6602                              mov.l   #0, r2
FFF2A844  05dc45ff                          bsr.a   sub_FFF1EE20
FFF2A848  a009                              mov.l   r1, 28h+var_24[sp]
FFF2A84A  2e2f                              bra.b   loc_FFF2A879
FFF2A84C  a889                   loc_FFF2A84C mov.l   28h+var_1C[sp], r1
FFF2A84E  591e6c                            movu.b  6Ch[r1], r14
FFF2A851  752e10                            and     #10h, r14
FFF2A854  755e10                            cmp     #10h, r14
FFF2A857  2118                              bne.b   loc_FFF2A86F
FFF2A859  a98c                              mov.l   28h+var_C[sp], r4
FFF2A85B  5a433216                          movu.b  1632h[r4], r3
FFF2A85F  5a423116                          movu.b  1631h[r4], r2
FFF2A863  a889                              mov.l   28h+var_1C[sp], r1
FFF2A865  72440c06                          add     #60Ch, r4, r4
FFF2A869  05f3bbff                          bsr.a   sub_FFF2645C
FFF2A86D  a109                              mov.l   r1, 28h+var_14[sp]
FFF2A86F  a909                   loc_FFF2A86F mov.l   28h+var_14[sp], r1
FFF2A871  6602                              mov.l   #0, r2
FFF2A873  05ad45ff                          bsr.a   sub_FFF1EE20
FFF2A877  a009                              mov.l   r1, 28h+var_24[sp]
FFF2A879  a809                   loc_FFF2A879 mov.l   28h+var_24[sp], r1
FFF2A87B  a181                              mov.l   r1, 28h+var_10[sp]
FFF2A87D  670a                              rtsd    #0Ah
FFF2A87F  710084                 sub_FFF2A87F add     #-7Ch, sp, sp   ; <<<< FUNC sub_FFF2A87F
FFF2A882  a781                              mov.l   r1, 7Ch+var_4[sp]
FFF2A884  a70a                              mov.l   r2, 7Ch+var_8[sp]
FFF2A886  a703                              mov.l   r3, 7Ch+var_C[sp]
FFF2A888  a68c                              mov.l   r4, 7Ch+var_10[sp]
FFF2A88A  3e8500                            mov.l   #0, 7Ch+var_28[sp]
FFF2A88D  3e8400                            mov.l   #0, 7Ch+var_2C[sp]
FFF2A890  3e8300                            mov.l   #0, 7Ch+var_30[sp]
FFF2A893  3e8200                            mov.l   #0, 7Ch+var_34[sp]
FFF2A896  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2A89C  e4e004                            mov.l   [r14], 7Ch+var_6C[sp]
FFF2A89F  fbe2245e0600                      mov.l   #65E24h, r14
FFF2A8A5  e4e003                            mov.l   [r14], 7Ch+var_70[sp]
FFF2A8A8  ae89                              mov.l   7Ch+var_10[sp], r1
FFF2A8AA  fa14301600                        mov.b   #0, 1630h[r1]
FFF2A8AF  3e8800                            mov.l   #0, 7Ch+var_1C[sp]
FFF2A8B2  2e26                              bra.b   loc_FFF2A8D8
FFF2A8B4  af82                   locret_FFF2A8B4 mov.l   7Ch+var_4[sp], r2
FFF2A8B6  a889                              mov.l   7Ch+var_70[sp], r1
FFF2A8B8  72113c02                          add     #23Ch, r1, r1
FFF2A8BC  050494ff                          bsr.a   sub_FFF23CC0
FFF2A8C0  6101                              cmp     #0, r1
FFF2A8C2  18                                bne.s   loc_FFF2A8CA
FFF2A8C3  f90601f9                          mov.l   #-7, 7Ch+var_78[sp]
FFF2A8C7  38e402                            bra.w   loc_FFF2ABAB
FFF2A8CA  ae01                   loc_FFF2A8CA mov.l   7Ch+var_1C[sp], r1
FFF2A8CC  6211                              add     #1, r1
FFF2A8CE  a601                              mov.l   r1, 7Ch+var_1C[sp]
FFF2A8D0  a889                              mov.l   7Ch+var_70[sp], r1
FFF2A8D2  72116804                          add     #468h, r1, r1
FFF2A8D6  a089                              mov.l   r1, 7Ch+var_70[sp]
FFF2A8D8  fbe212250100           loc_FFF2A8D8 mov.l   #12512h, r14
FFF2A8DE  dcee                              mov.w   [r14], r14
FFF2A8E0  06850e18                          cmp     7Ch+var_1C[sp].l, r14
FFF2A8E4  2ad0                              bgt.b   locret_FFF2A8B4
FFF2A8E6  af81                              mov.l   7Ch+var_4[sp], r1
FFF2A8E8  cc11                              mov.b   [r1], r1
FFF2A8EA  05a13e00                          bsr.a   sub_FFF2E78B
FFF2A8EE  8289                              mov.b   r1, 7Ch+var_71[sp]
FFF2A8F0  b289                              movu.b  7Ch+var_71[sp], r1
FFF2A8F2  710210                            add     #7Ch+var_6C, sp, r2
FFF2A8F5  052a46ff                          bsr.a   sub_FFF1EF1F
FFF2A8F9  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2A8FB  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2A8FD  6101                              cmp     #0, r1
FFF2A8FF  10                                beq.s   loc_FFF2A907
FFF2A900  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF2A904  38a702                            bra.w   loc_FFF2ABAB
FFF2A907  a901                   loc_FFF2A907 mov.l   7Ch+var_6C[sp], r1
FFF2A909  055446ff                          bsr.a   sub_FFF1EF5D
FFF2A90D  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2A90F  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2A911  6101                              cmp     #0, r1
FFF2A913  10                                beq.s   loc_FFF2A91B
FFF2A914  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF2A918  389302                            bra.w   loc_FFF2ABAB
FFF2A91B  a901                   loc_FFF2A91B mov.l   7Ch+var_6C[sp], r1
FFF2A91D  057446ff                          bsr.a   sub_FFF1EF91
FFF2A921  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2A923  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2A925  6101                              cmp     #0, r1
FFF2A927  10                                beq.s   locret_FFF2A92F
FFF2A928  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF2A92C  387f02                            bra.w   loc_FFF2ABAB
FFF2A92F  af81                   locret_FFF2A92F mov.l   7Ch+var_4[sp], r1
FFF2A931  6241                              add     #4, r1
FFF2A933  a581                              mov.l   r1, 7Ch+var_24[sp]
FFF2A935  a901                              mov.l   7Ch+var_6C[sp], r1
FFF2A937  e5100d13                          mov.l   34h[r1], 7Ch+var_30[sp]
FFF2A93B  e5000405                          mov.l   7Ch+var_6C[sp], 7Ch+var_68[sp]
FFF2A93F  a901                              mov.l   7Ch+var_6C[sp], r1
FFF2A941  8c11                              mov.b   10h[r1], r1
FFF2A943  755120                            cmp     #20h, r1 ; ' '
FFF2A946  3a2c01                            beq.w   loc_FFF2AA72
FFF2A949  ae8a                              mov.l   7Ch+var_10[sp], r2
FFF2A94B  ad81                              mov.l   7Ch+var_24[sp], r1
FFF2A94D  05c68aff                          bsr.a   sub_FFF23413
FFF2A951  a581                              mov.l   r1, 7Ch+var_24[sp]
FFF2A953  ad81                              mov.l   7Ch+var_24[sp], r1
FFF2A955  6101                              cmp     #0, r1
FFF2A957  18                                bne.s   loc_FFF2A95F
FFF2A958  f90601ff                          mov.l   #-1, 7Ch+var_78[sp]
FFF2A95C  384f02                            bra.w   loc_FFF2ABAB
FFF2A95F  ae89                   loc_FFF2A95F mov.l   7Ch+var_10[sp], r1
FFF2A961  cc1e                              mov.b   [r1], r14
FFF2A963  610e                              cmp     #0, r14
FFF2A965  210d                              bne.b   loc_FFF2A972
FFF2A967  ae89                              mov.l   7Ch+var_10[sp], r1
FFF2A969  8819                              mov.b   1[r1], r1
FFF2A96B  6101                              cmp     #0, r1
FFF2A96D  1d                                bne.s   loc_FFF2A972
FFF2A96E  f80601                            mov.l   #1, 7Ch+var_7C[sp]
FFF2A971  0c                                bra.s   loc_FFF2A975
FFF2A972  f80600                 loc_FFF2A972 mov.l   #0, 7Ch+var_7C[sp]
FFF2A975  ec01                   loc_FFF2A975 mov.l   7Ch+var_7C[sp], r1
FFF2A977  6101                              cmp     #0, r1
FFF2A979  10                                beq.s   loc_FFF2A981
FFF2A97A  f90601ff                          mov.l   #-1, 7Ch+var_78[sp]
FFF2A97E  382d02                            bra.w   loc_FFF2ABAB
FFF2A981  ae8a                   loc_FFF2A981 mov.l   7Ch+var_10[sp], r2
FFF2A983  a901                              mov.l   7Ch+var_6C[sp], r1
FFF2A985  60c0                              sub     #0Ch, sp
FFF2A987  a082                              mov.l   r2, 88h+var_80[sp]
FFF2A989  710360                            add     #88h+var_28, sp, r3
FFF2A98C  a00b                              mov.l   r3, 88h+var_84[sp]
FFF2A98E  f80400                            mov.b   #0, 88h+var_88[sp]
FFF2A991  6604                              mov.l   #0, r4
FFF2A993  710324                            add     #88h+var_64, sp, r3
FFF2A996  05dc7cff                          bsr.a   sub_FFF22672
FFF2A99A  62c0                              add     #0Ch, sp
FFF2A99C  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2A99E  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2A9A0  6101                              cmp     #0, r1
FFF2A9A2  2017                              beq.b   loc_FFF2A9B9
FFF2A9A4  ad81                              mov.l   7Ch+var_24[sp], r1
FFF2A9A6  cc1e                              mov.b   [r1], r14
FFF2A9A8  610e                              cmp     #0, r14
FFF2A9AA  10                                beq.s   loc_FFF2A9B2
FFF2A9AB  f90601fc                          mov.l   #-4, 7Ch+var_78[sp]
FFF2A9AF  38fc01                            bra.w   loc_FFF2ABAB
FFF2A9B2  f90601fd               loc_FFF2A9B2 mov.l   #-3, 7Ch+var_78[sp]
FFF2A9B6  38f501                            bra.w   loc_FFF2ABAB
FFF2A9B9  a901                   loc_FFF2A9B9 mov.l   7Ch+var_6C[sp], r1
FFF2A9BB  8c12                              mov.b   10h[r1], r2
FFF2A9BD  710118                            add     #7Ch+var_64, sp, r1
FFF2A9C0  05d85cff                          bsr.a   sub_FFF20698
FFF2A9C4  a489                              mov.l   r1, 7Ch+var_30[sp]
FFF2A9C6  ae89                              mov.l   7Ch+var_10[sp], r1
FFF2A9C8  fa14301601                        mov.b   #1, 1630h[r1]
FFF2A9CD  38a500                            bra.w   loc_FFF2AA72
FFF2A9D0  ae8a                   loc_FFF2A9D0 mov.l   7Ch+var_10[sp], r2
FFF2A9D2  ad81                              mov.l   7Ch+var_24[sp], r1
FFF2A9D4  053f8aff                          bsr.a   sub_FFF23413
FFF2A9D8  a581                              mov.l   r1, 7Ch+var_24[sp]
FFF2A9DA  ad81                              mov.l   7Ch+var_24[sp], r1
FFF2A9DC  6101                              cmp     #0, r1
FFF2A9DE  18                                bne.s   loc_FFF2A9E6
FFF2A9DF  f90601ff                          mov.l   #-1, 7Ch+var_78[sp]
FFF2A9E3  38c801                            bra.w   loc_FFF2ABAB
FFF2A9E6  ae89                   loc_FFF2A9E6 mov.l   7Ch+var_10[sp], r1
FFF2A9E8  cc1e                              mov.b   [r1], r14
FFF2A9EA  610e                              cmp     #0, r14
FFF2A9EC  210d                              bne.b   loc_FFF2A9F9
FFF2A9EE  ae89                              mov.l   7Ch+var_10[sp], r1
FFF2A9F0  8819                              mov.b   1[r1], r1
FFF2A9F2  6101                              cmp     #0, r1
FFF2A9F4  1d                                bne.s   loc_FFF2A9F9
FFF2A9F5  f80601                            mov.l   #1, 7Ch+var_7C[sp]
FFF2A9F8  0c                                bra.s   loc_FFF2A9FC
FFF2A9F9  f80600                 loc_FFF2A9F9 mov.l   #0, 7Ch+var_7C[sp]
FFF2A9FC  ec01                   loc_FFF2A9FC mov.l   7Ch+var_7C[sp], r1
FFF2A9FE  6101                              cmp     #0, r1
FFF2AA00  10                                beq.s   loc_FFF2AA08
FFF2AA01  f90601ff                          mov.l   #-1, 7Ch+var_78[sp]
FFF2AA05  38a601                            bra.w   loc_FFF2ABAB
FFF2AA08  e5001312               loc_FFF2AA08 mov.l   7Ch+var_30[sp], 7Ch+var_34[sp]
FFF2AA0C  ae8b                              mov.l   7Ch+var_10[sp], r3
FFF2AA0E  ac8a                              mov.l   7Ch+var_30[sp], r2
FFF2AA10  a901                              mov.l   7Ch+var_6C[sp], r1
FFF2AA12  7100f0                            add     #-10h, sp, sp
FFF2AA15  a08b                              mov.l   r3, 8Ch+var_80[sp]
FFF2AA17  710460                            add     #8Ch+var_2C, sp, r4
FFF2AA1A  a084                              mov.l   r4, 8Ch+var_84[sp]
FFF2AA1C  710464                            add     #8Ch+var_28, sp, r4
FFF2AA1F  a00c                              mov.l   r4, 8Ch+var_88[sp]
FFF2AA21  3c0100                            mov.b   #0, 8Ch+var_8B[sp]
FFF2AA24  f80400                            mov.b   #0, 8Ch+var_8C[sp]
FFF2AA27  710428                            add     #8Ch+var_64, sp, r4
FFF2AA2A  05a380ff                          bsr.a   sub_FFF22ACD
FFF2AA2E  710010                            add     #10h, sp, sp
FFF2AA31  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2AA33  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2AA35  6101                              cmp     #0, r1
FFF2AA37  2027                              beq.b   loc_FFF2AA5E
FFF2AA39  ad81                              mov.l   7Ch+var_24[sp], r1
FFF2AA3B  cc1e                              mov.b   [r1], r14
FFF2AA3D  610e                              cmp     #0, r14
FFF2AA3F  210c                              bne.b   loc_FFF2AA4B
FFF2AA41  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2AA43  7501fc                            cmp     #-4, r1
FFF2AA46  1d                                bne.s   loc_FFF2AA4B
FFF2AA47  f80601                            mov.l   #1, 7Ch+var_7C[sp]
FFF2AA4A  0c                                bra.s   loc_FFF2AA4E
FFF2AA4B  f80600                 loc_FFF2AA4B mov.l   #0, 7Ch+var_7C[sp]
FFF2AA4E  ec01                   loc_FFF2AA4E mov.l   7Ch+var_7C[sp], r1
FFF2AA50  6101                              cmp     #0, r1
FFF2AA52  15                                beq.s   loc_FFF2AA57
FFF2AA53  f90619fd                          mov.l   #-3, 7Ch+var_18[sp]
FFF2AA57  e5001901               loc_FFF2AA57 mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF2AA5B  385001                            bra.w   loc_FFF2ABAB
FFF2AA5E  a901                   loc_FFF2AA5E mov.l   7Ch+var_6C[sp], r1
FFF2AA60  8c12                              mov.b   10h[r1], r2
FFF2AA62  710118                            add     #7Ch+var_64, sp, r1
FFF2AA65  05335cff                          bsr.a   sub_FFF20698
FFF2AA69  a489                              mov.l   r1, 7Ch+var_30[sp]
FFF2AA6B  ae89                              mov.l   7Ch+var_10[sp], r1
FFF2AA6D  fa14301601                        mov.b   #1, 1630h[r1]
FFF2AA72  ad81                   loc_FFF2AA72 mov.l   7Ch+var_24[sp], r1
FFF2AA74  cc1e                              mov.b   [r1], r14
FFF2AA76  610e                              cmp     #0, r14
FFF2AA78  3b58ff                            bne.w   loc_FFF2A9D0
FFF2AA7B  ae89                              mov.l   7Ch+var_10[sp], r1
FFF2AA7D  5a1e3016                          movu.b  1630h[r1], r14
FFF2AA81  611e                              cmp     #1, r14
FFF2AA83  2112                              bne.b   loc_FFF2AA95
FFF2AA85  a901                              mov.l   7Ch+var_6C[sp], r1
FFF2AA87  591e6c                            movu.b  6Ch[r1], r14
FFF2AA8A  752e10                            and     #10h, r14
FFF2AA8D  755e10                            cmp     #10h, r14
FFF2AA90  1d                                bne.s   loc_FFF2AA95
FFF2AA91  f80601                            mov.l   #1, 7Ch+var_7C[sp]
FFF2AA94  0c                                bra.s   loc_FFF2AA98
FFF2AA95  f80600                 loc_FFF2AA95 mov.l   #0, 7Ch+var_7C[sp]
FFF2AA98  ec01                   loc_FFF2AA98 mov.l   7Ch+var_7C[sp], r1
FFF2AA9A  6101                              cmp     #0, r1
FFF2AA9C  2073                              beq.b   loc_FFF2AB0F
FFF2AA9E  ae8a                              mov.l   7Ch+var_10[sp], r2
FFF2AAA0  af81                              mov.l   7Ch+var_4[sp], r1
FFF2AAA2  72220c06                          add     #60Ch, r2, r2
FFF2AAA6  059ec1ff                          bsr.a   sub_FFF26C44
FFF2AAAA  8281                              mov.b   r1, 7Ch+var_72[sp]
FFF2AAAC  ae8b                              mov.l   7Ch+var_10[sp], r3
FFF2AAAE  a901                              mov.l   7Ch+var_6C[sp], r1
FFF2AAB0  72320c06                          add     #60Ch, r3, r2
FFF2AAB4  05d5b7ff                          bsr.a   sub_FFF26289
FFF2AAB8  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2AABA  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2AABC  6101                              cmp     #0, r1
FFF2AABE  2130                              bne.b   loc_FFF2AAEE
FFF2AAC0  ae8a                              mov.l   7Ch+var_10[sp], r2
FFF2AAC2  b285                              movu.b  7Ch+var_72[sp], r5
FFF2AAC4  ad0c                              mov.l   7Ch+var_28[sp], r4
FFF2AAC6  ad03                              mov.l   7Ch+var_2C[sp], r3
FFF2AAC8  a901                              mov.l   7Ch+var_6C[sp], r1
FFF2AACA  60c0                              sub     #0Ch, sp
FFF2AACC  a082                              mov.l   r2, 88h+var_80[sp]
FFF2AACE  72220c06                          add     #60Ch, r2, r2
FFF2AAD2  a00a                              mov.l   r2, 88h+var_84[sp]
FFF2AAD4  c305                              mov.b   r5, 88h+var_88[sp]
FFF2AAD6  710224                            add     #88h+var_64, sp, r2
FFF2AAD9  056db8ff                          bsr.a   sub_FFF26346
FFF2AADD  62c0                              add     #0Ch, sp
FFF2AADF  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2AAE1  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2AAE3  6101                              cmp     #0, r1
FFF2AAE5  202a                              beq.b   loc_FFF2AB0F
FFF2AAE7  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF2AAEB  38c000                            bra.w   loc_FFF2ABAB
FFF2AAEE  ae09                   loc_FFF2AAEE mov.l   7Ch+var_18[sp], r1
FFF2AAF0  7601d3fe                          cmp     #-12Dh, r1
FFF2AAF4  10                                beq.s   loc_FFF2AAFC
FFF2AAF5  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2AAF7  7601d4fe                          cmp     #-12Ch, r1
FFF2AAFB  1d                                bne.s   loc_FFF2AB00
FFF2AAFC  f80601                 loc_FFF2AAFC mov.l   #1, 7Ch+var_7C[sp]
FFF2AAFF  0c                                bra.s   loc_FFF2AB03
FFF2AB00  f80600                 loc_FFF2AB00 mov.l   #0, 7Ch+var_7C[sp]
FFF2AB03  ec01                   loc_FFF2AB03 mov.l   7Ch+var_7C[sp], r1
FFF2AB05  6101                              cmp     #0, r1
FFF2AB07  18                                bne.s   loc_FFF2AB0F
FFF2AB08  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF2AB0C  389f00                            bra.w   loc_FFF2ABAB
FFF2AB0F  e5001510               loc_FFF2AB0F mov.l   7Ch+var_28[sp], 7Ch+var_3C[sp]
FFF2AB13  ac81                              mov.l   7Ch+var_34[sp], r1
FFF2AB15  6101                              cmp     #0, r1
FFF2AB17  200c                              beq.b   loc_FFF2AB23
FFF2AB19  f9045f01                          mov.b   #1, 7Ch+var_1D[sp]
FFF2AB1D  e5001411                          mov.l   7Ch+var_2C[sp], 7Ch+var_38[sp]
FFF2AB21  2e10                              bra.b   loc_FFF2AB31
FFF2AB23  f9045f00               loc_FFF2AB23 mov.b   #0, 7Ch+var_1D[sp]
FFF2AB27  a901                              mov.l   7Ch+var_6C[sp], r1
FFF2AB29  6602                              mov.l   #0, r2
FFF2AB2B  058144ff                          bsr.a   sub_FFF1EFAC
FFF2AB2F  a409                              mov.l   r1, 7Ch+var_38[sp]
FFF2AB31  a901                   loc_FFF2AB31 mov.l   7Ch+var_6C[sp], r1
FFF2AB33  8c12                              mov.b   10h[r1], r2
FFF2AB35  710118                            add     #7Ch+var_64, sp, r1
FFF2AB38  05605bff                          bsr.a   sub_FFF20698
FFF2AB3C  a381                              mov.l   r1, 7Ch+var_44[sp]
FFF2AB3E  e5000e0f                          mov.l   7Ch+var_44[sp], 7Ch+var_40[sp]
FFF2AB42  af09                              mov.l   7Ch+var_8[sp], r1
FFF2AB44  6101                              cmp     #0, r1
FFF2AB46  2030                              beq.b   locret_FFF2AB76
FFF2AB48  af09                              mov.l   7Ch+var_8[sp], r1
FFF2AB4A  581e                              movu.b  [r1], r14
FFF2AB4C  ae8d                              mov.l   7Ch+var_10[sp], r5
FFF2AB4E  ed0f0f                            mov.l   7Ch+var_40[sp], r15
FFF2AB51  ac04                              mov.l   7Ch+var_3C[sp], r4
FFF2AB53  ac0b                              mov.l   7Ch+var_38[sp], r3
FFF2AB55  cd025f                            mov.b   7Ch+var_1D[sp], r2
FFF2AB58  a909                              mov.l   7Ch+var_68[sp], r1
FFF2AB5A  60c0                              sub     #0Ch, sp
FFF2AB5C  a085                              mov.l   r5, 88h+var_80[sp]
FFF2AB5E  e70f01                            mov.l   r15, 88h+var_84[sp]
FFF2AB61  c30e                              mov.b   r14, 88h+var_88[sp]
FFF2AB63  0570d1ff                          bsr.a   sub_FFF27CD3
FFF2AB67  62c0                              add     #0Ch, sp
FFF2AB69  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2AB6B  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2AB6D  6101                              cmp     #0, r1
FFF2AB6F  17                                beq.s   locret_FFF2AB76
FFF2AB70  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF2AB74  2e37                              bra.b   loc_FFF2ABAB
FFF2AB76  af01                   locret_FFF2AB76 mov.l   7Ch+var_C[sp], r1
FFF2AB78  6101                              cmp     #0, r1
FFF2AB7A  202e                              beq.b   loc_FFF2ABA8
FFF2AB7C  ae8d                              mov.l   7Ch+var_10[sp], r5
FFF2AB7E  ed0f0f                            mov.l   7Ch+var_40[sp], r15
FFF2AB81  ed0e1c                            mov.l   7Ch+var_C[sp], r14
FFF2AB84  ac04                              mov.l   7Ch+var_3C[sp], r4
FFF2AB86  ac0b                              mov.l   7Ch+var_38[sp], r3
FFF2AB88  cd025f                            mov.b   7Ch+var_1D[sp], r2
FFF2AB8B  a909                              mov.l   7Ch+var_68[sp], r1
FFF2AB8D  60c0                              sub     #0Ch, sp
FFF2AB8F  a085                              mov.l   r5, 88h+var_80[sp]
FFF2AB91  e70f01                            mov.l   r15, 88h+var_84[sp]
FFF2AB94  e30e                              mov.l   r14, 88h+var_88[sp]
FFF2AB96  059bd2ff                          bsr.a   sub_FFF27E31
FFF2AB9A  62c0                              add     #0Ch, sp
FFF2AB9C  a609                              mov.l   r1, 7Ch+var_18[sp]
FFF2AB9E  ae09                              mov.l   7Ch+var_18[sp], r1
FFF2ABA0  6101                              cmp     #0, r1
FFF2ABA2  16                                beq.s   loc_FFF2ABA8
FFF2ABA3  e5001901                          mov.l   7Ch+var_18[sp], 7Ch+var_78[sp]
FFF2ABA7  0c                                bra.s   loc_FFF2ABAB
FFF2ABA8  3e0100                 loc_FFF2ABA8 mov.l   #0, 7Ch+var_78[sp]
FFF2ABAB  a809                   loc_FFF2ABAB mov.l   7Ch+var_78[sp], r1
FFF2ABAD  a681                              mov.l   r1, 7Ch+var_14[sp]
FFF2ABAF  671f                              rtsd    #1Fh
FFF2ABB1  7100b8                 sub_FFF2ABB1 add     #-48h, sp, sp   ; <<<< FUNC sub_FFF2ABB1
FFF2ABB4  a409                              mov.l   r1, 48h+var_4[sp]
FFF2ABB6  710204                            add     #48h+var_44, sp, r2
FFF2ABB9  3967f8                            bsr.w   sub_FFF2A420
FFF2ABBC  a389                              mov.l   r1, 48h+var_C[sp]
FFF2ABBE  ab89                              mov.l   48h+var_C[sp], r1
FFF2ABC0  6101                              cmp     #0, r1
FFF2ABC2  16                                beq.s   loc_FFF2ABC8
FFF2ABC3  e1000f                            mov.l   48h+var_C[sp], 48h+var_48[sp]
FFF2ABC6  2e0e                              bra.b   loc_FFF2ABD4
FFF2ABC8  6601                   loc_FFF2ABC8 mov.l   #0, r1
FFF2ABCA  ef12                              mov.l   r1, r2
FFF2ABCC  055442ff                          bsr.a   sub_FFF1EE20
FFF2ABD0  8b89                              mov.b   48h+var_39[sp], r1
FFF2ABD2  e301                              mov.l   r1, 48h+var_48[sp]
FFF2ABD4  ec01                   loc_FFF2ABD4 mov.l   48h+var_48[sp], r1
FFF2ABD6  a401                              mov.l   r1, 48h+var_8[sp]
FFF2ABD8  6712                              rtsd    #12h
FFF2ABDA  7100e8                 sub_FFF2ABDA add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2ABDA
FFF2ABDD  a109                              mov.l   r1, 18h+var_4[sp]
FFF2ABDF  a102                              mov.l   r2, 18h+var_8[sp]
FFF2ABE1  05b5b2fe                          bsr.a   sub_FFF15E96
FFF2ABE5  a009                              mov.l   r1, 18h+var_14[sp]
FFF2ABE7  a809                              mov.l   18h+var_14[sp], r1
FFF2ABE9  6101                              cmp     #0, r1
FFF2ABEB  210f                              bne.b   loc_FFF2ABFA
FFF2ABED  6602                              mov.l   #0, r2
FFF2ABEF  fb16e1                            mov.l   #-1Fh, r1
FFF2ABF2  052e42ff                          bsr.a   sub_FFF1EE20
FFF2ABF6  e301                              mov.l   r1, 18h+var_18[sp]
FFF2ABF8  2e16                              bra.b   loc_FFF2AC0E
FFF2ABFA  a80b                   loc_FFF2ABFA mov.l   18h+var_14[sp], r3
FFF2ABFC  a902                              mov.l   18h+var_8[sp], r2
FFF2ABFE  a909                              mov.l   18h+var_4[sp], r1
FFF2AC00  391400                            bsr.w   sub_FFF2AC14
FFF2AC03  a081                              mov.l   r1, 18h+var_10[sp]
FFF2AC05  a809                              mov.l   18h+var_14[sp], r1
FFF2AC07  059fb2fe                          bsr.a   sub_FFF15EA6
FFF2AC0B  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF2AC0E  ec01                   loc_FFF2AC0E mov.l   18h+var_18[sp], r1
FFF2AC10  a089                              mov.l   r1, 18h+var_C[sp]
FFF2AC12  6706                              rtsd    #6
FFF2AC14  7100dc                 sub_FFF2AC14 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF2AC14
FFF2AC17  a201                              mov.l   r1, 24h+var_4[sp]
FFF2AC19  a18a                              mov.l   r2, 24h+var_8[sp]
FFF2AC1B  a183                              mov.l   r3, 24h+var_C[sp]
FFF2AC1D  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2AC23  e4e003                            mov.l   [r14], 24h+var_18[sp]
FFF2AC26  05c5a3ff                          bsr.a   sub_FFF24FEB
FFF2AC2A  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AC2C  a901                              mov.l   24h+var_14[sp], r1
FFF2AC2E  6101                              cmp     #0, r1
FFF2AC30  200f                              beq.b   loc_FFF2AC3F
FFF2AC32  a901                              mov.l   24h+var_14[sp], r1
FFF2AC34  6602                              mov.l   #0, r2
FFF2AC36  05ea41ff                          bsr.a   sub_FFF1EE20
FFF2AC3A  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AC3C  387201                            bra.w   loc_FFF2ADAE
FFF2AC3F  aa01                   loc_FFF2AC3F mov.l   24h+var_4[sp], r1
FFF2AC41  6101                              cmp     #0, r1
FFF2AC43  2110                              bne.b   loc_FFF2AC53
FFF2AC45  6602                              mov.l   #0, r2
FFF2AC47  fb16ff                            mov.l   #-1, r1
FFF2AC4A  05d641ff                          bsr.a   sub_FFF1EE20
FFF2AC4E  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AC50  385e01                            bra.w   loc_FFF2ADAE
FFF2AC53  aa01                   loc_FFF2AC53 mov.l   24h+var_4[sp], r1
FFF2AC55  05a68aff                          bsr.a   sub_FFF236FB
FFF2AC59  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AC5B  a901                              mov.l   24h+var_14[sp], r1
FFF2AC5D  6101                              cmp     #0, r1
FFF2AC5F  200f                              beq.b   loc_FFF2AC6E
FFF2AC61  a901                              mov.l   24h+var_14[sp], r1
FFF2AC63  6602                              mov.l   #0, r2
FFF2AC65  05bb41ff                          bsr.a   sub_FFF1EE20
FFF2AC69  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AC6B  384301                            bra.w   loc_FFF2ADAE
FFF2AC6E  aa02                   loc_FFF2AC6E mov.l   24h+var_4[sp], r2
FFF2AC70  a981                              mov.l   24h+var_C[sp], r1
FFF2AC72  72110c10                          add     #100Ch, r1, r1
FFF2AC76  05cf3f00                          bsr.a   sub_FFF2EC45
FFF2AC7A  a981                              mov.l   24h+var_C[sp], r1
FFF2AC7C  72110c10                          add     #100Ch, r1, r1
FFF2AC80  059c89ff                          bsr.a   sub_FFF2361C
FFF2AC84  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AC86  a901                              mov.l   24h+var_14[sp], r1
FFF2AC88  6101                              cmp     #0, r1
FFF2AC8A  200f                              beq.b   loc_FFF2AC99
FFF2AC8C  a901                              mov.l   24h+var_14[sp], r1
FFF2AC8E  6602                              mov.l   #0, r2
FFF2AC90  059041ff                          bsr.a   sub_FFF1EE20
FFF2AC94  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AC96  381801                            bra.w   loc_FFF2ADAE
FFF2AC99  a989                   loc_FFF2AC99 mov.l   24h+var_8[sp], r1
FFF2AC9B  6101                              cmp     #0, r1
FFF2AC9D  2110                              bne.b   loc_FFF2ACAD
FFF2AC9F  6602                              mov.l   #0, r2
FFF2ACA1  fb16f3                            mov.l   #-0Dh, r1
FFF2ACA4  057c41ff                          bsr.a   sub_FFF1EE20
FFF2ACA8  a009                              mov.l   r1, 24h+var_20[sp]
FFF2ACAA  380401                            bra.w   loc_FFF2ADAE
FFF2ACAD  a989                   loc_FFF2ACAD mov.l   24h+var_8[sp], r1
FFF2ACAF  05e9d6ff                          bsr.a   sub_FFF28398
FFF2ACB3  6101                              cmp     #0, r1
FFF2ACB5  2010                              beq.b   loc_FFF2ACC5
FFF2ACB7  6602                              mov.l   #0, r2
FFF2ACB9  fb16f3                            mov.l   #-0Dh, r1
FFF2ACBC  056441ff                          bsr.a   sub_FFF1EE20
FFF2ACC0  a009                              mov.l   r1, 24h+var_20[sp]
FFF2ACC2  38ec00                            bra.w   loc_FFF2ADAE
FFF2ACC5  a981                   loc_FFF2ACC5 mov.l   24h+var_C[sp], r1
FFF2ACC7  ce110c10                          mov.b   100Ch[r1], r1
FFF2ACCB  05c03a00                          bsr.a   sub_FFF2E78B
FFF2ACCF  8289                              mov.b   r1, 24h+var_19[sp]
FFF2ACD1  b289                              movu.b  24h+var_19[sp], r1
FFF2ACD3  71020c                            add     #24h+var_18, sp, r2
FFF2ACD6  054942ff                          bsr.a   sub_FFF1EF1F
FFF2ACDA  a101                              mov.l   r1, 24h+var_14[sp]
FFF2ACDC  a901                              mov.l   24h+var_14[sp], r1
FFF2ACDE  6101                              cmp     #0, r1
FFF2ACE0  200f                              beq.b   loc_FFF2ACEF
FFF2ACE2  a901                              mov.l   24h+var_14[sp], r1
FFF2ACE4  6602                              mov.l   #0, r2
FFF2ACE6  053a41ff                          bsr.a   sub_FFF1EE20
FFF2ACEA  a009                              mov.l   r1, 24h+var_20[sp]
FFF2ACEC  38c200                            bra.w   loc_FFF2ADAE
FFF2ACEF  a889                   loc_FFF2ACEF mov.l   24h+var_18[sp], r1
FFF2ACF1  591e6c                            movu.b  6Ch[r1], r14
FFF2ACF4  641e                              and     #1, r14
FFF2ACF6  611e                              cmp     #1, r14
FFF2ACF8  200e                              beq.b   loc_FFF2AD06
FFF2ACFA  a889                              mov.l   24h+var_18[sp], r1
FFF2ACFC  591e6c                            movu.b  6Ch[r1], r14
FFF2ACFF  752e10                            and     #10h, r14
FFF2AD02  755e10                            cmp     #10h, r14
FFF2AD05  1d                                bne.s   loc_FFF2AD0A
FFF2AD06  f80601                 loc_FFF2AD06 mov.l   #1, 24h+var_24[sp]
FFF2AD09  0c                                bra.s   loc_FFF2AD0D
FFF2AD0A  f80600                 loc_FFF2AD0A mov.l   #0, 24h+var_24[sp]
FFF2AD0D  ec01                   loc_FFF2AD0D mov.l   24h+var_24[sp], r1
FFF2AD0F  6101                              cmp     #0, r1
FFF2AD11  2035                              beq.b   loc_FFF2AD46
FFF2AD13  a889                              mov.l   24h+var_18[sp], r1
FFF2AD15  05ceb0fe                          bsr.a   sub_FFF15DE3
FFF2AD19  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AD1B  a901                              mov.l   24h+var_14[sp], r1
FFF2AD1D  6101                              cmp     #0, r1
FFF2AD1F  2010                              beq.b   loc_FFF2AD2F
FFF2AD21  6602                              mov.l   #0, r2
FFF2AD23  fb16c1                            mov.l   #-3Fh, r1
FFF2AD26  05fa40ff                          bsr.a   sub_FFF1EE20
FFF2AD2A  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AD2C  388200                            bra.w   loc_FFF2ADAE
FFF2AD2F  a984                   loc_FFF2AD2F mov.l   24h+var_C[sp], r4
FFF2AD31  a98b                              mov.l   24h+var_8[sp], r3
FFF2AD33  72410c10                          add     #100Ch, r4, r1
FFF2AD37  6602                              mov.l   #0, r2
FFF2AD39  3946fb                            bsr.w   sub_FFF2A87F
FFF2AD3C  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AD3E  a889                              mov.l   24h+var_18[sp], r1
FFF2AD40  05aeb0fe                          bsr.a   sub_FFF15DEE
FFF2AD44  2e11                              bra.b   loc_FFF2AD55
FFF2AD46  a984                   loc_FFF2AD46 mov.l   24h+var_C[sp], r4
FFF2AD48  a98b                              mov.l   24h+var_8[sp], r3
FFF2AD4A  72410c10                          add     #100Ch, r4, r1
FFF2AD4E  6602                              mov.l   #0, r2
FFF2AD50  392ffb                            bsr.w   sub_FFF2A87F
FFF2AD53  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AD55  a901                   loc_FFF2AD55 mov.l   24h+var_14[sp], r1
FFF2AD57  6101                              cmp     #0, r1
FFF2AD59  200e                              beq.b   loc_FFF2AD67
FFF2AD5B  a901                              mov.l   24h+var_14[sp], r1
FFF2AD5D  6602                              mov.l   #0, r2
FFF2AD5F  05c140ff                          bsr.a   sub_FFF1EE20
FFF2AD63  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AD65  2e49                              bra.b   loc_FFF2ADAE
FFF2AD67  a889                   loc_FFF2AD67 mov.l   24h+var_18[sp], r1
FFF2AD69  05731eff                          bsr.a   sub_FFF1CBDC
FFF2AD6D  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AD6F  a901                              mov.l   24h+var_14[sp], r1
FFF2AD71  6101                              cmp     #0, r1
FFF2AD73  200e                              beq.b   loc_FFF2AD81
FFF2AD75  a901                              mov.l   24h+var_14[sp], r1
FFF2AD77  6602                              mov.l   #0, r2
FFF2AD79  05a740ff                          bsr.a   sub_FFF1EE20
FFF2AD7D  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AD7F  2e2f                              bra.b   loc_FFF2ADAE
FFF2AD81  a889                   loc_FFF2AD81 mov.l   24h+var_18[sp], r1
FFF2AD83  591e6c                            movu.b  6Ch[r1], r14
FFF2AD86  752e10                            and     #10h, r14
FFF2AD89  755e10                            cmp     #10h, r14
FFF2AD8C  2118                              bne.b   loc_FFF2ADA4
FFF2AD8E  a984                              mov.l   24h+var_C[sp], r4
FFF2AD90  5a433216                          movu.b  1632h[r4], r3
FFF2AD94  5a423116                          movu.b  1631h[r4], r2
FFF2AD98  a889                              mov.l   24h+var_18[sp], r1
FFF2AD9A  72440c06                          add     #60Ch, r4, r4
FFF2AD9E  05beb6ff                          bsr.a   sub_FFF2645C
FFF2ADA2  a101                              mov.l   r1, 24h+var_14[sp]
FFF2ADA4  a901                   loc_FFF2ADA4 mov.l   24h+var_14[sp], r1
FFF2ADA6  6602                              mov.l   #0, r2
FFF2ADA8  057840ff                          bsr.a   sub_FFF1EE20
FFF2ADAC  a009                              mov.l   r1, 24h+var_20[sp]
FFF2ADAE  a809                   loc_FFF2ADAE mov.l   24h+var_20[sp], r1
FFF2ADB0  a109                              mov.l   r1, 24h+var_10[sp]
FFF2ADB2  6709                              rtsd    #9
FFF2ADB4  7100b4                 sub_FFF2ADB4 add     #-4Ch, sp, sp   ; <<<< FUNC sub_FFF2ADB4
FFF2ADB7  a481                              mov.l   r1, 4Ch+var_4[sp]
FFF2ADB9  a40a                              mov.l   r2, 4Ch+var_8[sp]
FFF2ADBB  6102                              cmp     #0, r2
FFF2ADBD  210f                              bne.b   loc_FFF2ADCC
FFF2ADBF  6602                              mov.l   #0, r2
FFF2ADC1  fb16f3                            mov.l   #-0Dh, r1
FFF2ADC4  055c40ff                          bsr.a   sub_FFF1EE20
FFF2ADC8  e301                              mov.l   r1, 4Ch+var_4C[sp]
FFF2ADCA  2e2c                              bra.b   loc_FFF2ADF6
FFF2ADCC  ac81                   loc_FFF2ADCC mov.l   4Ch+var_4[sp], r1
FFF2ADCE  710204                            add     #4Ch+var_48, sp, r2
FFF2ADD1  394ff6                            bsr.w   sub_FFF2A420
FFF2ADD4  a389                              mov.l   r1, 4Ch+var_10[sp]
FFF2ADD6  ab89                              mov.l   4Ch+var_10[sp], r1
FFF2ADD8  6101                              cmp     #0, r1
FFF2ADDA  16                                beq.s   loc_FFF2ADE0
FFF2ADDB  e1000f                            mov.l   4Ch+var_10[sp], 4Ch+var_4C[sp]
FFF2ADDE  2e18                              bra.b   loc_FFF2ADF6
FFF2ADE0  ac09                   loc_FFF2ADE0 mov.l   4Ch+var_8[sp], r1
FFF2ADE2  754324                            mov.l   #24h, r3 ; '$'
FFF2ADE5  710210                            add     #4Ch+var_3C, sp, r2
FFF2ADE8  05903600                          bsr.a   sub_FFF2E478
FFF2ADEC  6601                              mov.l   #0, r1
FFF2ADEE  ef12                              mov.l   r1, r2
FFF2ADF0  053040ff                          bsr.a   sub_FFF1EE20
FFF2ADF4  e301                              mov.l   r1, 4Ch+var_4C[sp]
FFF2ADF6  ec01                   loc_FFF2ADF6 mov.l   4Ch+var_4C[sp], r1
FFF2ADF8  a401                              mov.l   r1, 4Ch+var_C[sp]
FFF2ADFA  6713                              rtsd    #13h
FFF2ADFC  7100ec                 sub_FFF2ADFC add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2ADFC
FFF2ADFF  9209                              mov.w   r1, 14h+var_2[sp]
FFF2AE01  a08a                              mov.l   r2, 14h+var_8[sp]
FFF2AE03  a083                              mov.l   r3, 14h+var_C[sp]
FFF2AE05  a88a                              mov.l   14h+var_8[sp], r2
FFF2AE07  ba09                              movu.w  14h+var_2[sp], r1
FFF2AE09  390b00                            bsr.w   sub_FFF2AE14
FFF2AE0C  e301                              mov.l   r1, 14h+var_14[sp]
FFF2AE0E  ec01                              mov.l   14h+var_14[sp], r1
FFF2AE10  a009                              mov.l   r1, 14h+var_10[sp]
FFF2AE12  6705                              rtsd    #5
FFF2AE14  7100dc                 sub_FFF2AE14 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF2AE14
FFF2AE17  9409                              mov.w   r1, 24h+var_2[sp]
FFF2AE19  a18a                              mov.l   r2, 24h+var_8[sp]
FFF2AE1B  a183                              mov.l   r3, 24h+var_C[sp]
FFF2AE1D  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2AE23  e4e003                            mov.l   [r14], 24h+var_18[sp]
FFF2AE26  05c5a1ff                          bsr.a   sub_FFF24FEB
FFF2AE2A  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AE2C  a901                              mov.l   24h+var_14[sp], r1
FFF2AE2E  6101                              cmp     #0, r1
FFF2AE30  200f                              beq.b   loc_FFF2AE3F
FFF2AE32  a901                              mov.l   24h+var_14[sp], r1
FFF2AE34  6602                              mov.l   #0, r2
FFF2AE36  05ea3fff                          bsr.a   sub_FFF1EE20
FFF2AE3A  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AE3C  388400                            bra.w   loc_FFF2AEC0
FFF2AE3F  a989                   loc_FFF2AE3F mov.l   24h+var_8[sp], r1
FFF2AE41  6101                              cmp     #0, r1
FFF2AE43  16                                beq.s   loc_FFF2AE49
FFF2AE44  a981                              mov.l   24h+var_C[sp], r1
FFF2AE46  6101                              cmp     #0, r1
FFF2AE48  1d                                bne.s   loc_FFF2AE4D
FFF2AE49  f80601                 loc_FFF2AE49 mov.l   #1, 24h+var_24[sp]
FFF2AE4C  0c                                bra.s   loc_FFF2AE50
FFF2AE4D  f80600                 loc_FFF2AE4D mov.l   #0, 24h+var_24[sp]
FFF2AE50  ec01                   loc_FFF2AE50 mov.l   24h+var_24[sp], r1
FFF2AE52  6101                              cmp     #0, r1
FFF2AE54  200f                              beq.b   loc_FFF2AE63
FFF2AE56  6602                              mov.l   #0, r2
FFF2AE58  fb16f3                            mov.l   #-0Dh, r1
FFF2AE5B  05c53fff                          bsr.a   sub_FFF1EE20
FFF2AE5F  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AE61  2e5f                              bra.b   loc_FFF2AEC0
FFF2AE63  bc09                   loc_FFF2AE63 movu.w  24h+var_2[sp], r1
FFF2AE65  05c73d00                          bsr.a   sub_FFF2EC2C
FFF2AE69  8289                              mov.b   r1, 24h+var_19[sp]
FFF2AE6B  8a89                              mov.b   24h+var_19[sp], r1
FFF2AE6D  051e3900                          bsr.a   sub_FFF2E78B
FFF2AE71  8281                              mov.b   r1, 24h+var_1A[sp]
FFF2AE73  b281                              movu.b  24h+var_1A[sp], r1
FFF2AE75  71020c                            add     #24h+var_18, sp, r2
FFF2AE78  05a740ff                          bsr.a   sub_FFF1EF1F
FFF2AE7C  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AE7E  a901                              mov.l   24h+var_14[sp], r1
FFF2AE80  6101                              cmp     #0, r1
FFF2AE82  200e                              beq.b   loc_FFF2AE90
FFF2AE84  a901                              mov.l   24h+var_14[sp], r1
FFF2AE86  6602                              mov.l   #0, r2
FFF2AE88  05983fff                          bsr.a   sub_FFF1EE20
FFF2AE8C  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AE8E  2e32                              bra.b   loc_FFF2AEC0
FFF2AE90  a889                   loc_FFF2AE90 mov.l   24h+var_18[sp], r1
FFF2AE92  05cb40ff                          bsr.a   sub_FFF1EF5D
FFF2AE96  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AE98  a901                              mov.l   24h+var_14[sp], r1
FFF2AE9A  6101                              cmp     #0, r1
FFF2AE9C  200e                              beq.b   loc_FFF2AEAA
FFF2AE9E  a901                              mov.l   24h+var_14[sp], r1
FFF2AEA0  6602                              mov.l   #0, r2
FFF2AEA2  057e3fff                          bsr.a   sub_FFF1EE20
FFF2AEA6  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AEA8  2e18                              bra.b   loc_FFF2AEC0
FFF2AEAA  a983                   loc_FFF2AEAA mov.l   24h+var_C[sp], r3
FFF2AEAC  a98a                              mov.l   24h+var_8[sp], r2
FFF2AEAE  8a81                              mov.b   24h+var_1A[sp], r1
FFF2AEB0  0582deff                          bsr.a   sub_FFF28D32
FFF2AEB4  a101                              mov.l   r1, 24h+var_14[sp]
FFF2AEB6  a901                              mov.l   24h+var_14[sp], r1
FFF2AEB8  6602                              mov.l   #0, r2
FFF2AEBA  05663fff                          bsr.a   sub_FFF1EE20
FFF2AEBE  a009                              mov.l   r1, 24h+var_20[sp]
FFF2AEC0  a809                   loc_FFF2AEC0 mov.l   24h+var_20[sp], r1
FFF2AEC2  a109                              mov.l   r1, 24h+var_10[sp]
FFF2AEC4  6709                              rtsd    #9
FFF2AEC6  7100e4                 sub_FFF2AEC6 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2AEC6
FFF2AEC9  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF2AECB  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2AECD  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF2AECF  05c7affe                          bsr.a   sub_FFF15E96
FFF2AED3  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2AED5  a809                              mov.l   1Ch+var_18[sp], r1
FFF2AED7  6101                              cmp     #0, r1
FFF2AED9  210f                              bne.b   loc_FFF2AEE8
FFF2AEDB  6602                              mov.l   #0, r2
FFF2AEDD  fb16e1                            mov.l   #-1Fh, r1
FFF2AEE0  05403fff                          bsr.a   sub_FFF1EE20
FFF2AEE4  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2AEE6  2e18                              bra.b   loc_FFF2AEFE
FFF2AEE8  a80c                   loc_FFF2AEE8 mov.l   1Ch+var_18[sp], r4
FFF2AEEA  a903                              mov.l   1Ch+var_C[sp], r3
FFF2AEEC  a90a                              mov.l   1Ch+var_8[sp], r2
FFF2AEEE  bb09                              movu.w  1Ch+var_2[sp], r1
FFF2AEF0  391400                            bsr.w   sub_FFF2AF04
FFF2AEF3  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2AEF5  a809                              mov.l   1Ch+var_18[sp], r1
FFF2AEF7  05afaffe                          bsr.a   sub_FFF15EA6
FFF2AEFB  e10002                            mov.l   1Ch+var_14[sp], 1Ch+var_1C[sp]
FFF2AEFE  ec01                   loc_FFF2AEFE mov.l   1Ch+var_1C[sp], r1
FFF2AF00  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2AF02  6707                              rtsd    #7
FFF2AF04  7100d8                 sub_FFF2AF04 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF2AF04
FFF2AF07  9489                              mov.w   r1, 28h+var_2[sp]
FFF2AF09  a202                              mov.l   r2, 28h+var_8[sp]
FFF2AF0B  a18b                              mov.l   r3, 28h+var_C[sp]
FFF2AF0D  a184                              mov.l   r4, 28h+var_10[sp]
FFF2AF0F  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2AF15  e4e003                            mov.l   [r14], 28h+var_1C[sp]
FFF2AF18  05d3a0ff                          bsr.a   sub_FFF24FEB
FFF2AF1C  a101                              mov.l   r1, 28h+var_18[sp]
FFF2AF1E  a901                              mov.l   28h+var_18[sp], r1
FFF2AF20  6101                              cmp     #0, r1
FFF2AF22  200f                              beq.b   loc_FFF2AF31
FFF2AF24  a901                              mov.l   28h+var_18[sp], r1
FFF2AF26  6602                              mov.l   #0, r2
FFF2AF28  05f83eff                          bsr.a   sub_FFF1EE20
FFF2AF2C  a009                              mov.l   r1, 28h+var_24[sp]
FFF2AF2E  388600                            bra.w   loc_FFF2AFB4
FFF2AF31  aa01                   loc_FFF2AF31 mov.l   28h+var_8[sp], r1
FFF2AF33  6101                              cmp     #0, r1
FFF2AF35  16                                beq.s   loc_FFF2AF3B
FFF2AF36  a989                              mov.l   28h+var_C[sp], r1
FFF2AF38  6101                              cmp     #0, r1
FFF2AF3A  1d                                bne.s   loc_FFF2AF3F
FFF2AF3B  f80601                 loc_FFF2AF3B mov.l   #1, 28h+var_28[sp]
FFF2AF3E  0c                                bra.s   loc_FFF2AF42
FFF2AF3F  f80600                 loc_FFF2AF3F mov.l   #0, 28h+var_28[sp]
FFF2AF42  ec01                   loc_FFF2AF42 mov.l   28h+var_28[sp], r1
FFF2AF44  6101                              cmp     #0, r1
FFF2AF46  200f                              beq.b   loc_FFF2AF55
FFF2AF48  6602                              mov.l   #0, r2
FFF2AF4A  fb16f3                            mov.l   #-0Dh, r1
FFF2AF4D  05d33eff                          bsr.a   sub_FFF1EE20
FFF2AF51  a009                              mov.l   r1, 28h+var_24[sp]
FFF2AF53  2e61                              bra.b   loc_FFF2AFB4
FFF2AF55  bc89                   loc_FFF2AF55 movu.w  28h+var_2[sp], r1
FFF2AF57  05d53c00                          bsr.a   sub_FFF2EC2C
FFF2AF5B  8289                              mov.b   r1, 28h+var_1D[sp]
FFF2AF5D  8a89                              mov.b   28h+var_1D[sp], r1
FFF2AF5F  052c3800                          bsr.a   sub_FFF2E78B
FFF2AF63  8281                              mov.b   r1, 28h+var_1E[sp]
FFF2AF65  b281                              movu.b  28h+var_1E[sp], r1
FFF2AF67  71020c                            add     #28h+var_1C, sp, r2
FFF2AF6A  05b53fff                          bsr.a   sub_FFF1EF1F
FFF2AF6E  a101                              mov.l   r1, 28h+var_18[sp]
FFF2AF70  a901                              mov.l   28h+var_18[sp], r1
FFF2AF72  6101                              cmp     #0, r1
FFF2AF74  200e                              beq.b   loc_FFF2AF82
FFF2AF76  a901                              mov.l   28h+var_18[sp], r1
FFF2AF78  6602                              mov.l   #0, r2
FFF2AF7A  05a63eff                          bsr.a   sub_FFF1EE20
FFF2AF7E  a009                              mov.l   r1, 28h+var_24[sp]
FFF2AF80  2e34                              bra.b   loc_FFF2AFB4
FFF2AF82  a889                   loc_FFF2AF82 mov.l   28h+var_1C[sp], r1
FFF2AF84  05d93fff                          bsr.a   sub_FFF1EF5D
FFF2AF88  a101                              mov.l   r1, 28h+var_18[sp]
FFF2AF8A  a901                              mov.l   28h+var_18[sp], r1
FFF2AF8C  6101                              cmp     #0, r1
FFF2AF8E  200e                              beq.b   loc_FFF2AF9C
FFF2AF90  a901                              mov.l   28h+var_18[sp], r1
FFF2AF92  6602                              mov.l   #0, r2
FFF2AF94  058c3eff                          bsr.a   sub_FFF1EE20
FFF2AF98  a009                              mov.l   r1, 28h+var_24[sp]
FFF2AF9A  2e1a                              bra.b   loc_FFF2AFB4
FFF2AF9C  a984                   loc_FFF2AF9C mov.l   28h+var_10[sp], r4
FFF2AF9E  a98b                              mov.l   28h+var_C[sp], r3
FFF2AFA0  aa02                              mov.l   28h+var_8[sp], r2
FFF2AFA2  8a81                              mov.b   28h+var_1E[sp], r1
FFF2AFA4  0570dfff                          bsr.a   sub_FFF28F14
FFF2AFA8  a101                              mov.l   r1, 28h+var_18[sp]
FFF2AFAA  a901                              mov.l   28h+var_18[sp], r1
FFF2AFAC  6602                              mov.l   #0, r2
FFF2AFAE  05723eff                          bsr.a   sub_FFF1EE20
FFF2AFB2  a009                              mov.l   r1, 28h+var_24[sp]
FFF2AFB4  a809                   loc_FFF2AFB4 mov.l   28h+var_24[sp], r1
FFF2AFB6  a109                              mov.l   r1, 28h+var_14[sp]
FFF2AFB8  670a                              rtsd    #0Ah
FFF2AFBA  7100ec                 sub_FFF2AFBA add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2AFBA
FFF2AFBD  9209                              mov.w   r1, 14h+var_2[sp]
FFF2AFBF  05d7aefe                          bsr.a   sub_FFF15E96
FFF2AFC3  a009                              mov.l   r1, 14h+var_10[sp]
FFF2AFC5  a809                              mov.l   14h+var_10[sp], r1
FFF2AFC7  6101                              cmp     #0, r1
FFF2AFC9  210f                              bne.b   loc_FFF2AFD8
FFF2AFCB  6602                              mov.l   #0, r2
FFF2AFCD  fb16e1                            mov.l   #-1Fh, r1
FFF2AFD0  05503eff                          bsr.a   sub_FFF1EE20
FFF2AFD4  e301                              mov.l   r1, 14h+var_14[sp]
FFF2AFD6  2e14                              bra.b   loc_FFF2AFEA
FFF2AFD8  a80a                   loc_FFF2AFD8 mov.l   14h+var_10[sp], r2
FFF2AFDA  ba09                              movu.w  14h+var_2[sp], r1
FFF2AFDC  391400                            bsr.w   sub_FFF2AFF0
FFF2AFDF  a081                              mov.l   r1, 14h+var_C[sp]
FFF2AFE1  a809                              mov.l   14h+var_10[sp], r1
FFF2AFE3  05c3aefe                          bsr.a   sub_FFF15EA6
FFF2AFE7  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2AFEA  ec01                   loc_FFF2AFEA mov.l   14h+var_14[sp], r1
FFF2AFEC  a089                              mov.l   r1, 14h+var_8[sp]
FFF2AFEE  6705                              rtsd    #5
FFF2AFF0  7100e4                 sub_FFF2AFF0 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2AFF0
FFF2AFF3  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF2AFF5  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2AFF7  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2AFFD  e4e002                            mov.l   [r14], 1Ch+var_14[sp]
FFF2B000  05eb9fff                          bsr.a   sub_FFF24FEB
FFF2B004  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2B006  a889                              mov.l   1Ch+var_10[sp], r1
FFF2B008  6101                              cmp     #0, r1
FFF2B00A  200e                              beq.b   loc_FFF2B018
FFF2B00C  a889                              mov.l   1Ch+var_10[sp], r1
FFF2B00E  6602                              mov.l   #0, r2
FFF2B010  05103eff                          bsr.a   sub_FFF1EE20
FFF2B014  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2B016  2e5b                              bra.b   loc_FFF2B071
FFF2B018  bb09                   loc_FFF2B018 movu.w  1Ch+var_2[sp], r1
FFF2B01A  05123c00                          bsr.a   sub_FFF2EC2C
FFF2B01E  8189                              mov.b   r1, 1Ch+var_15[sp]
FFF2B020  8989                              mov.b   1Ch+var_15[sp], r1
FFF2B022  05693700                          bsr.a   sub_FFF2E78B
FFF2B026  8181                              mov.b   r1, 1Ch+var_16[sp]
FFF2B028  b181                              movu.b  1Ch+var_16[sp], r1
FFF2B02A  710208                            add     #1Ch+var_14, sp, r2
FFF2B02D  05f23eff                          bsr.a   sub_FFF1EF1F
FFF2B031  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2B033  a889                              mov.l   1Ch+var_10[sp], r1
FFF2B035  6101                              cmp     #0, r1
FFF2B037  200e                              beq.b   loc_FFF2B045
FFF2B039  a889                              mov.l   1Ch+var_10[sp], r1
FFF2B03B  6602                              mov.l   #0, r2
FFF2B03D  05e33dff                          bsr.a   sub_FFF1EE20
FFF2B041  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2B043  2e2e                              bra.b   loc_FFF2B071
FFF2B045  a90a                   loc_FFF2B045 mov.l   1Ch+var_8[sp], r2
FFF2B047  a881                              mov.l   1Ch+var_14[sp], r1
FFF2B049  0518e5ff                          bsr.a   sub_FFF29561
FFF2B04D  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2B04F  a889                              mov.l   1Ch+var_10[sp], r1
FFF2B051  6101                              cmp     #0, r1
FFF2B053  210f                              bne.b   loc_FFF2B062
FFF2B055  a881                              mov.l   1Ch+var_14[sp], r1
FFF2B057  8c11                              mov.b   10h[r1], r1
FFF2B059  755120                            cmp     #20h, r1 ; ' '
FFF2B05C  16                                beq.s   loc_FFF2B062
FFF2B05D  a881                              mov.l   1Ch+var_14[sp], r1
FFF2B05F  3e1a02                            mov.l   #2, 28h[r1]
FFF2B062  a881                   loc_FFF2B062 mov.l   1Ch+var_14[sp], r1
FFF2B064  f1186c                            bclr    #0, 6Ch[r1].b
FFF2B067  a889                              mov.l   1Ch+var_10[sp], r1
FFF2B069  6602                              mov.l   #0, r2
FFF2B06B  05b53dff                          bsr.a   sub_FFF1EE20
FFF2B06F  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2B071  ec01                   loc_FFF2B071 mov.l   1Ch+var_1C[sp], r1
FFF2B073  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF2B075  6707                              rtsd    #7
FFF2B077  60c0                   sub_FFF2B077 sub     #0Ch, sp   ; <<<< FUNC sub_FFF2B077
FFF2B079  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF2B07B  b909                              movu.w  0Ch+var_2[sp], r1
FFF2B07D  05af3b00                          bsr.a   sub_FFF2EC2C
FFF2B081  8089                              mov.b   r1, 0Ch+var_9[sp]
FFF2B083  8889                              mov.b   0Ch+var_9[sp], r1
FFF2B085  05c3e8ff                          bsr.a   sub_FFF29948
FFF2B089  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF2B08B  6703                              rtsd    #3
FFF2B08D  7100ec                 sub_FFF2B08D add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2B08D
FFF2B090  a101                              mov.l   r1, 14h+var_4[sp]
FFF2B092  0504aefe                          bsr.a   sub_FFF15E96
FFF2B096  a009                              mov.l   r1, 14h+var_10[sp]
FFF2B098  a809                              mov.l   14h+var_10[sp], r1
FFF2B09A  6101                              cmp     #0, r1
FFF2B09C  210f                              bne.b   loc_FFF2B0AB
FFF2B09E  6602                              mov.l   #0, r2
FFF2B0A0  fb16e1                            mov.l   #-1Fh, r1
FFF2B0A3  057d3dff                          bsr.a   sub_FFF1EE20
FFF2B0A7  e301                              mov.l   r1, 14h+var_14[sp]
FFF2B0A9  2e14                              bra.b   loc_FFF2B0BD
FFF2B0AB  a80a                   loc_FFF2B0AB mov.l   14h+var_10[sp], r2
FFF2B0AD  a901                              mov.l   14h+var_4[sp], r1
FFF2B0AF  391400                            bsr.w   sub_FFF2B0C3
FFF2B0B2  a081                              mov.l   r1, 14h+var_C[sp]
FFF2B0B4  a809                              mov.l   14h+var_10[sp], r1
FFF2B0B6  05f0adfe                          bsr.a   sub_FFF15EA6
FFF2B0BA  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2B0BD  ec01                   loc_FFF2B0BD mov.l   14h+var_14[sp], r1
FFF2B0BF  a089                              mov.l   r1, 14h+var_8[sp]
FFF2B0C1  6705                              rtsd    #5
FFF2B0C3  6e67                   sub_FFF2B0C3 pushm   r6-r7   ; <<<< FUNC sub_FFF2B0C3
FFF2B0C5  7100e0                            add     #-20h, sp, sp
FFF2B0C8  a189                              mov.l   r1, 20h+var_4[sp]
FFF2B0CA  a182                              mov.l   r2, 20h+var_8[sp]
FFF2B0CC  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2B0D2  e4e003                            mov.l   [r14], 20h+var_14[sp]
FFF2B0D5  05169fff                          bsr.a   sub_FFF24FEB
FFF2B0D9  a101                              mov.l   r1, 20h+var_10[sp]
FFF2B0DB  a901                              mov.l   20h+var_10[sp], r1
FFF2B0DD  6101                              cmp     #0, r1
FFF2B0DF  200f                              beq.b   loc_FFF2B0EE
FFF2B0E1  a901                              mov.l   20h+var_10[sp], r1
FFF2B0E3  6602                              mov.l   #0, r2
FFF2B0E5  053b3dff                          bsr.a   sub_FFF1EE20
FFF2B0E9  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2B0EB  383601                            bra.w   loc_FFF2B221
FFF2B0EE  a989                   loc_FFF2B0EE mov.l   20h+var_4[sp], r1
FFF2B0F0  6101                              cmp     #0, r1
FFF2B0F2  2110                              bne.b   loc_FFF2B102
FFF2B0F4  6602                              mov.l   #0, r2
FFF2B0F6  fb16ff                            mov.l   #-1, r1
FFF2B0F9  05273dff                          bsr.a   sub_FFF1EE20
FFF2B0FD  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2B0FF  382201                            bra.w   loc_FFF2B221
FFF2B102  a989                   loc_FFF2B102 mov.l   20h+var_4[sp], r1
FFF2B104  050a52ff                          bsr.a   sub_FFF2030E
FFF2B108  a101                              mov.l   r1, 20h+var_10[sp]
FFF2B10A  a901                              mov.l   20h+var_10[sp], r1
FFF2B10C  6101                              cmp     #0, r1
FFF2B10E  200f                              beq.b   loc_FFF2B11D
FFF2B110  a901                              mov.l   20h+var_10[sp], r1
FFF2B112  6602                              mov.l   #0, r2
FFF2B114  050c3dff                          bsr.a   sub_FFF1EE20
FFF2B118  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2B11A  380701                            bra.w   loc_FFF2B221
FFF2B11D  a98e                   loc_FFF2B11D mov.l   20h+var_4[sp], r6
FFF2B11F  a987                              mov.l   20h+var_8[sp], r7
FFF2B121  ef61                              mov.l   r6, r1
FFF2B123  05ff3400                          bsr.a   sub_FFF2E622
FFF2B127  72770c10                          add     #100Ch, r7, r7
FFF2B12B  ef13                              mov.l   r1, r3
FFF2B12D  6213                              add     #1, r3
FFF2B12F  ef71                              mov.l   r7, r1
FFF2B131  ef62                              mov.l   r6, r2
FFF2B133  055b3500                          bsr.a   sub_FFF2E68E
FFF2B137  a981                              mov.l   20h+var_8[sp], r1
FFF2B139  72110c10                          add     #100Ch, r1, r1
FFF2B13D  05e42d00                          bsr.a   sub_FFF2DF21
FFF2B141  a981                              mov.l   20h+var_8[sp], r1
FFF2B143  ce110c10                          mov.b   100Ch[r1], r1
FFF2B147  05443600                          bsr.a   sub_FFF2E78B
FFF2B14B  8289                              mov.b   r1, 20h+var_15[sp]
FFF2B14D  b289                              movu.b  20h+var_15[sp], r1
FFF2B14F  71020c                            add     #20h+var_14, sp, r2
FFF2B152  05cd3dff                          bsr.a   sub_FFF1EF1F
FFF2B156  a101                              mov.l   r1, 20h+var_10[sp]
FFF2B158  a901                              mov.l   20h+var_10[sp], r1
FFF2B15A  6101                              cmp     #0, r1
FFF2B15C  200f                              beq.b   loc_FFF2B16B
FFF2B15E  a901                              mov.l   20h+var_10[sp], r1
FFF2B160  6602                              mov.l   #0, r2
FFF2B162  05be3cff                          bsr.a   sub_FFF1EE20
FFF2B166  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2B168  38b900                            bra.w   loc_FFF2B221
FFF2B16B  a889                   loc_FFF2B16B mov.l   20h+var_14[sp], r1
FFF2B16D  591e6c                            movu.b  6Ch[r1], r14
FFF2B170  641e                              and     #1, r14
FFF2B172  611e                              cmp     #1, r14
FFF2B174  200e                              beq.b   loc_FFF2B182
FFF2B176  a889                              mov.l   20h+var_14[sp], r1
FFF2B178  591e6c                            movu.b  6Ch[r1], r14
FFF2B17B  752e10                            and     #10h, r14
FFF2B17E  755e10                            cmp     #10h, r14
FFF2B181  1d                                bne.s   loc_FFF2B186
FFF2B182  f80601                 loc_FFF2B182 mov.l   #1, 20h+var_20[sp]
FFF2B185  0c                                bra.s   loc_FFF2B189
FFF2B186  f80600                 loc_FFF2B186 mov.l   #0, 20h+var_20[sp]
FFF2B189  ec01                   loc_FFF2B189 mov.l   20h+var_20[sp], r1
FFF2B18B  6101                              cmp     #0, r1
FFF2B18D  2030                              beq.b   loc_FFF2B1BD
FFF2B18F  a889                              mov.l   20h+var_14[sp], r1
FFF2B191  0552acfe                          bsr.a   sub_FFF15DE3
FFF2B195  a101                              mov.l   r1, 20h+var_10[sp]
FFF2B197  a901                              mov.l   20h+var_10[sp], r1
FFF2B199  6101                              cmp     #0, r1
FFF2B19B  200f                              beq.b   loc_FFF2B1AA
FFF2B19D  6602                              mov.l   #0, r2
FFF2B19F  fb16c1                            mov.l   #-3Fh, r1
FFF2B1A2  057e3cff                          bsr.a   sub_FFF1EE20
FFF2B1A6  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2B1A8  2e79                              bra.b   loc_FFF2B221
FFF2B1AA  a982                   loc_FFF2B1AA mov.l   20h+var_8[sp], r2
FFF2B1AC  72210c10                          add     #100Ch, r2, r1
FFF2B1B0  397800                            bsr.w   sub_FFF2B228
FFF2B1B3  a101                              mov.l   r1, 20h+var_10[sp]
FFF2B1B5  a889                              mov.l   20h+var_14[sp], r1
FFF2B1B7  0537acfe                          bsr.a   sub_FFF15DEE
FFF2B1BB  2e0d                              bra.b   loc_FFF2B1C8
FFF2B1BD  a982                   loc_FFF2B1BD mov.l   20h+var_8[sp], r2
FFF2B1BF  72210c10                          add     #100Ch, r2, r1
FFF2B1C3  396500                            bsr.w   sub_FFF2B228
FFF2B1C6  a101                              mov.l   r1, 20h+var_10[sp]
FFF2B1C8  a901                   loc_FFF2B1C8 mov.l   20h+var_10[sp], r1
FFF2B1CA  6101                              cmp     #0, r1
FFF2B1CC  200e                              beq.b   loc_FFF2B1DA
FFF2B1CE  a901                              mov.l   20h+var_10[sp], r1
FFF2B1D0  6602                              mov.l   #0, r2
FFF2B1D2  054e3cff                          bsr.a   sub_FFF1EE20
FFF2B1D6  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2B1D8  2e49                              bra.b   loc_FFF2B221
FFF2B1DA  a889                   loc_FFF2B1DA mov.l   20h+var_14[sp], r1
FFF2B1DC  05001aff                          bsr.a   sub_FFF1CBDC
FFF2B1E0  a101                              mov.l   r1, 20h+var_10[sp]
FFF2B1E2  a901                              mov.l   20h+var_10[sp], r1
FFF2B1E4  6101                              cmp     #0, r1
FFF2B1E6  200e                              beq.b   loc_FFF2B1F4
FFF2B1E8  a901                              mov.l   20h+var_10[sp], r1
FFF2B1EA  6602                              mov.l   #0, r2
FFF2B1EC  05343cff                          bsr.a   sub_FFF1EE20
FFF2B1F0  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2B1F2  2e2f                              bra.b   loc_FFF2B221
FFF2B1F4  a889                   loc_FFF2B1F4 mov.l   20h+var_14[sp], r1
FFF2B1F6  591e6c                            movu.b  6Ch[r1], r14
FFF2B1F9  752e10                            and     #10h, r14
FFF2B1FC  755e10                            cmp     #10h, r14
FFF2B1FF  2118                              bne.b   loc_FFF2B217
FFF2B201  a984                              mov.l   20h+var_8[sp], r4
FFF2B203  5a433216                          movu.b  1632h[r4], r3
FFF2B207  5a423116                          movu.b  1631h[r4], r2
FFF2B20B  a889                              mov.l   20h+var_14[sp], r1
FFF2B20D  72440c06                          add     #60Ch, r4, r4
FFF2B211  054bb2ff                          bsr.a   sub_FFF2645C
FFF2B215  a101                              mov.l   r1, 20h+var_10[sp]
FFF2B217  a901                   loc_FFF2B217 mov.l   20h+var_10[sp], r1
FFF2B219  6602                              mov.l   #0, r2
FFF2B21B  05053cff                          bsr.a   sub_FFF1EE20
FFF2B21F  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2B221  a809                   loc_FFF2B221 mov.l   20h+var_1C[sp], r1
FFF2B223  a109                              mov.l   r1, 20h+var_C[sp]
FFF2B225  3f670a                            rtsd    #28h, r6-r7
FFF2B228  710098                 sub_FFF2B228 add     #-68h, sp, sp   ; <<<< FUNC sub_FFF2B228
FFF2B22B  a609                              mov.l   r1, 68h+var_4[sp]
FFF2B22D  a602                              mov.l   r2, 68h+var_8[sp]
FFF2B22F  3e8200                            mov.l   #0, 68h+var_20[sp]
FFF2B232  3e8100                            mov.l   #0, 68h+var_24[sp]
FFF2B235  3e8000                            mov.l   #0, 68h+var_28[sp]
FFF2B238  3e0f00                            mov.l   #0, 68h+var_2C[sp]
FFF2B23B  3e0e00                            mov.l   #0, 68h+var_30[sp]
FFF2B23E  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2B244  e4e005                            mov.l   [r14], 68h+var_54[sp]
FFF2B247  ae01                              mov.l   68h+var_8[sp], r1
FFF2B249  fa14301600                        mov.b   #0, 1630h[r1]
FFF2B24E  ae09                              mov.l   68h+var_4[sp], r1
FFF2B250  cc11                              mov.b   [r1], r1
FFF2B252  05393500                          bsr.a   sub_FFF2E78B
FFF2B256  8489                              mov.b   r1, 68h+var_55[sp]
FFF2B258  b489                              movu.b  68h+var_55[sp], r1
FFF2B25A  710214                            add     #68h+var_54, sp, r2
FFF2B25D  05c23cff                          bsr.a   sub_FFF1EF1F
FFF2B261  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B263  ad81                              mov.l   68h+var_10[sp], r1
FFF2B265  6101                              cmp     #0, r1
FFF2B267  10                                beq.s   loc_FFF2B26F
FFF2B268  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B26C  385c03                            bra.w   loc_FFF2B5C8
FFF2B26F  a909                   loc_FFF2B26F mov.l   68h+var_54[sp], r1
FFF2B271  05ec3cff                          bsr.a   sub_FFF1EF5D
FFF2B275  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B277  ad81                              mov.l   68h+var_10[sp], r1
FFF2B279  6101                              cmp     #0, r1
FFF2B27B  10                                beq.s   loc_FFF2B283
FFF2B27C  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B280  384803                            bra.w   loc_FFF2B5C8
FFF2B283  a909                   loc_FFF2B283 mov.l   68h+var_54[sp], r1
FFF2B285  050c3dff                          bsr.a   sub_FFF1EF91
FFF2B289  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B28B  ad81                              mov.l   68h+var_10[sp], r1
FFF2B28D  6101                              cmp     #0, r1
FFF2B28F  10                                beq.s   loc_FFF2B297
FFF2B290  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B294  383403                            bra.w   loc_FFF2B5C8
FFF2B297  ae09                   loc_FFF2B297 mov.l   68h+var_4[sp], r1
FFF2B299  6221                              add     #2, r1
FFF2B29B  a501                              mov.l   r1, 68h+var_18[sp]
FFF2B29D  a909                              mov.l   68h+var_54[sp], r1
FFF2B29F  e5100d10                          mov.l   34h[r1], 68h+var_28[sp]
FFF2B2A3  a909                              mov.l   68h+var_54[sp], r1
FFF2B2A5  8c11                              mov.b   10h[r1], r1
FFF2B2A7  755120                            cmp     #20h, r1 ; ' '
FFF2B2AA  3a2401                            beq.w   loc_FFF2B3CE
FFF2B2AD  ae02                              mov.l   68h+var_8[sp], r2
FFF2B2AF  ad01                              mov.l   68h+var_18[sp], r1
FFF2B2B1  05d54eff                          bsr.a   sub_FFF20186
FFF2B2B5  a501                              mov.l   r1, 68h+var_18[sp]
FFF2B2B7  ad01                              mov.l   68h+var_18[sp], r1
FFF2B2B9  6101                              cmp     #0, r1
FFF2B2BB  18                                bne.s   loc_FFF2B2C3
FFF2B2BC  f90601ff                          mov.l   #-1, 68h+var_64[sp]
FFF2B2C0  380803                            bra.w   loc_FFF2B5C8
FFF2B2C3  ae01                   loc_FFF2B2C3 mov.l   68h+var_8[sp], r1
FFF2B2C5  cc1e                              mov.b   [r1], r14
FFF2B2C7  610e                              cmp     #0, r14
FFF2B2C9  18                                bne.s   loc_FFF2B2D1
FFF2B2CA  f90601ff                          mov.l   #-1, 68h+var_64[sp]
FFF2B2CE  38fa02                            bra.w   loc_FFF2B5C8
FFF2B2D1  ae02                   loc_FFF2B2D1 mov.l   68h+var_8[sp], r2
FFF2B2D3  a909                              mov.l   68h+var_54[sp], r1
FFF2B2D5  60c0                              sub     #0Ch, sp
FFF2B2D7  a082                              mov.l   r2, 74h+var_6C[sp]
FFF2B2D9  710354                            add     #74h+var_20, sp, r3
FFF2B2DC  a00b                              mov.l   r3, 74h+var_70[sp]
FFF2B2DE  f80400                            mov.b   #0, 74h+var_74[sp]
FFF2B2E1  6604                              mov.l   #0, r4
FFF2B2E3  710324                            add     #74h+var_50, sp, r3
FFF2B2E6  054d3eff                          bsr.a   sub_FFF1F133
FFF2B2EA  62c0                              add     #0Ch, sp
FFF2B2EC  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B2EE  ad01                              mov.l   68h+var_18[sp], r1
FFF2B2F0  cc1e                              mov.b   [r1], r14
FFF2B2F2  610e                              cmp     #0, r14
FFF2B2F4  ad81                              mov.l   68h+var_10[sp], r1
FFF2B2F6  210d                              bne.b   loc_FFF2B303
FFF2B2F8  6101                              cmp     #0, r1
FFF2B2FA  212e                              bne.b   loc_FFF2B328
FFF2B2FC  f90601fe                          mov.l   #-2, 68h+var_64[sp]
FFF2B300  38c802                            bra.w   loc_FFF2B5C8
FFF2B303  6101                   loc_FFF2B303 cmp     #0, r1
FFF2B305  10                                beq.s   loc_FFF2B30D
FFF2B306  f90601fc                          mov.l   #-4, 68h+var_64[sp]
FFF2B30A  38be02                            bra.w   loc_FFF2B5C8
FFF2B30D  cd0123                 loc_FFF2B30D mov.b   68h+var_45[sp], r1
FFF2B310  754210                            mov.l   #10h, r2
FFF2B313  055a55ff                          bsr.a   sub_FFF2086D
FFF2B317  6101                              cmp     #0, r1
FFF2B319  10                                beq.s   loc_FFF2B321
FFF2B31A  f90601fc                          mov.l   #-4, 68h+var_64[sp]
FFF2B31E  38aa02                            bra.w   loc_FFF2B5C8
FFF2B321  ae01                   loc_FFF2B321 mov.l   68h+var_8[sp], r1
FFF2B323  fa14301601                        mov.b   #1, 1630h[r1]
FFF2B328  a909                   loc_FFF2B328 mov.l   68h+var_54[sp], r1
FFF2B32A  8c12                              mov.b   10h[r1], r2
FFF2B32C  710118                            add     #68h+var_50, sp, r1
FFF2B32F  056953ff                          bsr.a   sub_FFF20698
FFF2B333  a401                              mov.l   r1, 68h+var_28[sp]
FFF2B335  389900                            bra.w   loc_FFF2B3CE
FFF2B338  ae02                   loc_FFF2B338 mov.l   68h+var_8[sp], r2
FFF2B33A  ad01                              mov.l   68h+var_18[sp], r1
FFF2B33C  054a4eff                          bsr.a   sub_FFF20186
FFF2B340  a501                              mov.l   r1, 68h+var_18[sp]
FFF2B342  ad01                              mov.l   68h+var_18[sp], r1
FFF2B344  6101                              cmp     #0, r1
FFF2B346  18                                bne.s   loc_FFF2B34E
FFF2B347  f90601ff                          mov.l   #-1, 68h+var_64[sp]
FFF2B34B  387d02                            bra.w   loc_FFF2B5C8
FFF2B34E  ae01                   loc_FFF2B34E mov.l   68h+var_8[sp], r1
FFF2B350  cc1e                              mov.b   [r1], r14
FFF2B352  610e                              cmp     #0, r14
FFF2B354  18                                bne.s   loc_FFF2B35C
FFF2B355  f90601ff                          mov.l   #-1, 68h+var_64[sp]
FFF2B359  386f02                            bra.w   loc_FFF2B5C8
FFF2B35C  e500100f               loc_FFF2B35C mov.l   68h+var_28[sp], 68h+var_2C[sp]
FFF2B360  ae03                              mov.l   68h+var_8[sp], r3
FFF2B362  ac02                              mov.l   68h+var_28[sp], r2
FFF2B364  a909                              mov.l   68h+var_54[sp], r1
FFF2B366  7100f0                            add     #-10h, sp, sp
FFF2B369  a08b                              mov.l   r3, 78h+var_6C[sp]
FFF2B36B  710454                            add     #78h+var_24, sp, r4
FFF2B36E  a084                              mov.l   r4, 78h+var_70[sp]
FFF2B370  710458                            add     #78h+var_20, sp, r4
FFF2B373  a00c                              mov.l   r4, 78h+var_74[sp]
FFF2B375  3c0100                            mov.b   #0, 78h+var_77[sp]
FFF2B378  f80400                            mov.b   #0, 78h+var_78[sp]
FFF2B37B  710428                            add     #78h+var_50, sp, r4
FFF2B37E  056643ff                          bsr.a   sub_FFF1F6E4
FFF2B382  710010                            add     #10h, sp, sp
FFF2B385  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B387  ad01                              mov.l   68h+var_18[sp], r1
FFF2B389  cc1e                              mov.b   [r1], r14
FFF2B38B  610e                              cmp     #0, r14
FFF2B38D  ad81                              mov.l   68h+var_10[sp], r1
FFF2B38F  210d                              bne.b   loc_FFF2B39C
FFF2B391  6101                              cmp     #0, r1
FFF2B393  212e                              bne.b   loc_FFF2B3C1
FFF2B395  f90601fe                          mov.l   #-2, 68h+var_64[sp]
FFF2B399  382f02                            bra.w   loc_FFF2B5C8
FFF2B39C  6101                   loc_FFF2B39C cmp     #0, r1
FFF2B39E  10                                beq.s   loc_FFF2B3A6
FFF2B39F  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B3A3  382502                            bra.w   loc_FFF2B5C8
FFF2B3A6  cd0123                 loc_FFF2B3A6 mov.b   68h+var_45[sp], r1
FFF2B3A9  754210                            mov.l   #10h, r2
FFF2B3AC  05c154ff                          bsr.a   sub_FFF2086D
FFF2B3B0  6101                              cmp     #0, r1
FFF2B3B2  10                                beq.s   loc_FFF2B3BA
FFF2B3B3  f90601fc                          mov.l   #-4, 68h+var_64[sp]
FFF2B3B7  381102                            bra.w   loc_FFF2B5C8
FFF2B3BA  ae01                   loc_FFF2B3BA mov.l   68h+var_8[sp], r1
FFF2B3BC  fa14301601                        mov.b   #1, 1630h[r1]
FFF2B3C1  a909                   loc_FFF2B3C1 mov.l   68h+var_54[sp], r1
FFF2B3C3  8c12                              mov.b   10h[r1], r2
FFF2B3C5  710118                            add     #68h+var_50, sp, r1
FFF2B3C8  05d052ff                          bsr.a   sub_FFF20698
FFF2B3CC  a401                              mov.l   r1, 68h+var_28[sp]
FFF2B3CE  ad01                   loc_FFF2B3CE mov.l   68h+var_18[sp], r1
FFF2B3D0  cc1e                              mov.b   [r1], r14
FFF2B3D2  610e                              cmp     #0, r14
FFF2B3D4  3b64ff                            bne.w   loc_FFF2B338
FFF2B3D7  ae01                              mov.l   68h+var_8[sp], r1
FFF2B3D9  5a1e3016                          movu.b  1630h[r1], r14
FFF2B3DD  611e                              cmp     #1, r14
FFF2B3DF  2112                              bne.b   loc_FFF2B3F1
FFF2B3E1  a909                              mov.l   68h+var_54[sp], r1
FFF2B3E3  591e6c                            movu.b  6Ch[r1], r14
FFF2B3E6  752e10                            and     #10h, r14
FFF2B3E9  755e10                            cmp     #10h, r14
FFF2B3EC  1d                                bne.s   loc_FFF2B3F1
FFF2B3ED  f80601                            mov.l   #1, 68h+var_68[sp]
FFF2B3F0  0c                                bra.s   loc_FFF2B3F4
FFF2B3F1  f80600                 loc_FFF2B3F1 mov.l   #0, 68h+var_68[sp]
FFF2B3F4  ec01                   loc_FFF2B3F4 mov.l   68h+var_68[sp], r1
FFF2B3F6  6101                              cmp     #0, r1
FFF2B3F8  206d                              beq.b   loc_FFF2B465
FFF2B3FA  ae09                              mov.l   68h+var_4[sp], r1
FFF2B3FC  05edb7ff                          bsr.a   sub_FFF26BE9
FFF2B400  8289                              mov.b   r1, 68h+var_5D[sp]
FFF2B402  ae03                              mov.l   68h+var_8[sp], r3
FFF2B404  a909                              mov.l   68h+var_54[sp], r1
FFF2B406  72320c06                          add     #60Ch, r3, r2
FFF2B40A  057faeff                          bsr.a   sub_FFF26289
FFF2B40E  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B410  ad81                              mov.l   68h+var_10[sp], r1
FFF2B412  6101                              cmp     #0, r1
FFF2B414  2130                              bne.b   loc_FFF2B444
FFF2B416  ae02                              mov.l   68h+var_8[sp], r2
FFF2B418  b28d                              movu.b  68h+var_5D[sp], r5
FFF2B41A  ac84                              mov.l   68h+var_20[sp], r4
FFF2B41C  ac0b                              mov.l   68h+var_24[sp], r3
FFF2B41E  a909                              mov.l   68h+var_54[sp], r1
FFF2B420  60c0                              sub     #0Ch, sp
FFF2B422  a082                              mov.l   r2, 74h+var_6C[sp]
FFF2B424  72220c06                          add     #60Ch, r2, r2
FFF2B428  a00a                              mov.l   r2, 74h+var_70[sp]
FFF2B42A  c305                              mov.b   r5, 74h+var_74[sp]
FFF2B42C  710224                            add     #74h+var_50, sp, r2
FFF2B42F  0517afff                          bsr.a   sub_FFF26346
FFF2B433  62c0                              add     #0Ch, sp
FFF2B435  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B437  ad81                              mov.l   68h+var_10[sp], r1
FFF2B439  6101                              cmp     #0, r1
FFF2B43B  202a                              beq.b   loc_FFF2B465
FFF2B43D  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B441  388701                            bra.w   loc_FFF2B5C8
FFF2B444  ad81                   loc_FFF2B444 mov.l   68h+var_10[sp], r1
FFF2B446  7601d3fe                          cmp     #-12Dh, r1
FFF2B44A  10                                beq.s   loc_FFF2B452
FFF2B44B  ad81                              mov.l   68h+var_10[sp], r1
FFF2B44D  7601d4fe                          cmp     #-12Ch, r1
FFF2B451  1d                                bne.s   loc_FFF2B456
FFF2B452  f80601                 loc_FFF2B452 mov.l   #1, 68h+var_68[sp]
FFF2B455  0c                                bra.s   loc_FFF2B459
FFF2B456  f80600                 loc_FFF2B456 mov.l   #0, 68h+var_68[sp]
FFF2B459  ec01                   loc_FFF2B459 mov.l   68h+var_68[sp], r1
FFF2B45B  6101                              cmp     #0, r1
FFF2B45D  18                                bne.s   loc_FFF2B465
FFF2B45E  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B462  386601                            bra.w   loc_FFF2B5C8
FFF2B465  a909                   loc_FFF2B465 mov.l   68h+var_54[sp], r1
FFF2B467  ad9c                              mov.l   5Ch[r1], r4
FFF2B469  754320                            mov.l   #20h, r3 ; ' '
FFF2B46C  6602                              mov.l   #0, r2
FFF2B46E  710118                            add     #68h+var_50, sp, r1
FFF2B471  053e3000                          bsr.a   sub_FFF2E4AF
FFF2B475  ae04                              mov.l   68h+var_8[sp], r4
FFF2B477  a909                              mov.l   68h+var_54[sp], r1
FFF2B479  71034c                            add     #68h+var_1C, sp, r3
FFF2B47C  6602                              mov.l   #0, r2
FFF2B47E  055391ff                          bsr.a   sub_FFF245D1
FFF2B482  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B484  ad81                              mov.l   68h+var_10[sp], r1
FFF2B486  6101                              cmp     #0, r1
FFF2B488  10                                beq.s   loc_FFF2B490
FFF2B489  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B48D  383b01                            bra.w   loc_FFF2B5C8
FFF2B490  ac89                   loc_FFF2B490 mov.l   68h+var_1C[sp], r1
FFF2B492  6101                              cmp     #0, r1
FFF2B494  18                                bne.s   loc_FFF2B49C
FFF2B495  f90601f5                          mov.l   #-0Bh, 68h+var_64[sp]
FFF2B499  382f01                            bra.w   loc_FFF2B5C8
FFF2B49C  e5000f0e               loc_FFF2B49C mov.l   68h+var_2C[sp], 68h+var_30[sp]
FFF2B4A0  a909                              mov.l   68h+var_54[sp], r1
FFF2B4A2  8c11                              mov.b   10h[r1], r1
FFF2B4A4  755120                            cmp     #20h, r1 ; ' '
FFF2B4A7  210f                              bne.b   loc_FFF2B4B6
FFF2B4A9  a909                              mov.l   68h+var_54[sp], r1
FFF2B4AB  ab19                              mov.l   34h[r1], r1
FFF2B4AD  0685010f                          cmp     68h+var_2C[sp].l, r1
FFF2B4B1  1d                                bne.s   loc_FFF2B4B6
FFF2B4B2  f80601                            mov.l   #1, 68h+var_68[sp]
FFF2B4B5  0c                                bra.s   loc_FFF2B4B9
FFF2B4B6  f80600                 loc_FFF2B4B6 mov.l   #0, 68h+var_68[sp]
FFF2B4B9  ec01                   loc_FFF2B4B9 mov.l   68h+var_68[sp], r1
FFF2B4BB  6101                              cmp     #0, r1
FFF2B4BD  14                                beq.s   loc_FFF2B4C1
FFF2B4BE  3e0f00                            mov.l   #0, 68h+var_2C[sp]
FFF2B4C1  ae04                   loc_FFF2B4C1 mov.l   68h+var_8[sp], r4
FFF2B4C3  ab8b                              mov.l   68h+var_2C[sp], r3
FFF2B4C5  ac8a                              mov.l   68h+var_1C[sp], r2
FFF2B4C7  a909                              mov.l   68h+var_54[sp], r1
FFF2B4C9  390501                            bsr.w   sub_FFF2B5CE
FFF2B4CC  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B4CE  ad81                              mov.l   68h+var_10[sp], r1
FFF2B4D0  6101                              cmp     #0, r1
FFF2B4D2  203f                              beq.b   loc_FFF2B511
FFF2B4D4  ae02                              mov.l   68h+var_8[sp], r2
FFF2B4D6  ac8b                              mov.l   68h+var_1C[sp], r3
FFF2B4D8  a909                              mov.l   68h+var_54[sp], r1
FFF2B4DA  6080                              sub     #8, sp
FFF2B4DC  a00a                              mov.l   r2, 70h+var_6C[sp]
FFF2B4DE  f80477                            mov.b   #77h, 70h+var_70[sp] ; 'w'
FFF2B4E1  6604                              mov.l   #0, r4
FFF2B4E3  710214                            add     #70h+var_5C, sp, r2
FFF2B4E6  05498eff                          bsr.a   sub_FFF2432F
FFF2B4EA  6280                              add     #8, sp
FFF2B4EC  a509                              mov.l   r1, 68h+var_14[sp]
FFF2B4EE  ad09                              mov.l   68h+var_14[sp], r1
FFF2B4F0  6101                              cmp     #0, r1
FFF2B4F2  10                                beq.s   loc_FFF2B4FA
FFF2B4F3  e5001501                          mov.l   68h+var_14[sp], 68h+var_64[sp]
FFF2B4F7  38d100                            bra.w   loc_FFF2B5C8
FFF2B4FA  a909                   loc_FFF2B4FA mov.l   68h+var_54[sp], r1
FFF2B4FC  8c11                              mov.b   10h[r1], r1
FFF2B4FE  755120                            cmp     #20h, r1 ; ' '
FFF2B501  19                                bne.s   loc_FFF2B50A
FFF2B502  a909                              mov.l   68h+var_54[sp], r1
FFF2B504  ab9a                              mov.l   3Ch[r1], r2
FFF2B506  6212                              add     #1, r2
FFF2B508  a39a                              mov.l   r2, 3Ch[r1]
FFF2B50A  e5001601               loc_FFF2B50A mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B50E  38ba00                            bra.w   loc_FFF2B5C8
FFF2B511  e5000e0f               loc_FFF2B511 mov.l   68h+var_30[sp], 68h+var_2C[sp]
FFF2B515  a909                              mov.l   68h+var_54[sp], r1
FFF2B517  8c13                              mov.b   10h[r1], r3
FFF2B519  ac8a                              mov.l   68h+var_1C[sp], r2
FFF2B51B  710118                            add     #68h+var_50, sp, r1
FFF2B51E  05c651ff                          bsr.a   sub_FFF206E4
FFF2B522  f9042310                          mov.b   #10h, 68h+var_45[sp]
FFF2B526  6673                              mov.l   #7, r3
FFF2B528  6602                              mov.l   #0, r2
FFF2B52A  710118                            add     #68h+var_50, sp, r1
FFF2B52D  05b350ff                          bsr.a   sub_FFF205E0
FFF2B531  ab89                              mov.l   68h+var_2C[sp], r1
FFF2B533  6101                              cmp     #0, r1
FFF2B535  a909                              mov.l   68h+var_54[sp], r1
FFF2B537  2029                              beq.b   loc_FFF2B560
FFF2B539  ae03                              mov.l   68h+var_8[sp], r3
FFF2B53B  ab8a                              mov.l   68h+var_2C[sp], r2
FFF2B53D  7100f0                            add     #-10h, sp, sp
FFF2B540  a08b                              mov.l   r3, 78h+var_6C[sp]
FFF2B542  710454                            add     #78h+var_24, sp, r4
FFF2B545  a084                              mov.l   r4, 78h+var_70[sp]
FFF2B547  710458                            add     #78h+var_20, sp, r4
FFF2B54A  a00c                              mov.l   r4, 78h+var_74[sp]
FFF2B54C  3c0100                            mov.b   #0, 78h+var_77[sp]
FFF2B54F  f80401                            mov.b   #1, 78h+var_78[sp]
FFF2B552  710428                            add     #78h+var_50, sp, r4
FFF2B555  058f41ff                          bsr.a   sub_FFF1F6E4
FFF2B559  710010                            add     #10h, sp, sp
FFF2B55C  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B55E  2e1d                              bra.b   loc_FFF2B57B
FFF2B560  ae02                   loc_FFF2B560 mov.l   68h+var_8[sp], r2
FFF2B562  60c0                              sub     #0Ch, sp
FFF2B564  a082                              mov.l   r2, 74h+var_6C[sp]
FFF2B566  710354                            add     #74h+var_20, sp, r3
FFF2B569  a00b                              mov.l   r3, 74h+var_70[sp]
FFF2B56B  f80400                            mov.b   #0, 74h+var_74[sp]
FFF2B56E  6614                              mov.l   #1, r4
FFF2B570  710324                            add     #74h+var_50, sp, r3
FFF2B573  05c03bff                          bsr.a   sub_FFF1F133
FFF2B577  62c0                              add     #0Ch, sp
FFF2B579  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B57B  ad81                   loc_FFF2B57B mov.l   68h+var_10[sp], r1
FFF2B57D  6101                              cmp     #0, r1
FFF2B57F  a909                              mov.l   68h+var_54[sp], r1
FFF2B581  203b                              beq.b   loc_FFF2B5BC
FFF2B583  ae02                              mov.l   68h+var_8[sp], r2
FFF2B585  ac8b                              mov.l   68h+var_1C[sp], r3
FFF2B587  6080                              sub     #8, sp
FFF2B589  a00a                              mov.l   r2, 70h+var_6C[sp]
FFF2B58B  f80477                            mov.b   #77h, 70h+var_70[sp] ; 'w'
FFF2B58E  6604                              mov.l   #0, r4
FFF2B590  710214                            add     #70h+var_5C, sp, r2
FFF2B593  059c8dff                          bsr.a   sub_FFF2432F
FFF2B597  6280                              add     #8, sp
FFF2B599  a509                              mov.l   r1, 68h+var_14[sp]
FFF2B59B  ad09                              mov.l   68h+var_14[sp], r1
FFF2B59D  6101                              cmp     #0, r1
FFF2B59F  17                                beq.s   loc_FFF2B5A6
FFF2B5A0  e5001501                          mov.l   68h+var_14[sp], 68h+var_64[sp]
FFF2B5A4  2e24                              bra.b   loc_FFF2B5C8
FFF2B5A6  a909                   loc_FFF2B5A6 mov.l   68h+var_54[sp], r1
FFF2B5A8  8c11                              mov.b   10h[r1], r1
FFF2B5AA  755120                            cmp     #20h, r1 ; ' '
FFF2B5AD  19                                bne.s   loc_FFF2B5B6
FFF2B5AE  a909                              mov.l   68h+var_54[sp], r1
FFF2B5B0  ab9a                              mov.l   3Ch[r1], r2
FFF2B5B2  6212                              add     #1, r2
FFF2B5B4  a39a                              mov.l   r2, 3Ch[r1]
FFF2B5B6  e5001601               loc_FFF2B5B6 mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B5BA  2e0e                              bra.b   loc_FFF2B5C8
FFF2B5BC  ae02                   loc_FFF2B5BC mov.l   68h+var_8[sp], r2
FFF2B5BE  056493ff                          bsr.a   sub_FFF24922
FFF2B5C2  a581                              mov.l   r1, 68h+var_10[sp]
FFF2B5C4  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2B5C8  a809                   loc_FFF2B5C8 mov.l   68h+var_64[sp], r1
FFF2B5CA  a589                              mov.l   r1, 68h+var_C[sp]
FFF2B5CC  671a                              rtsd    #1Ah
FFF2B5CE  7100ac                 sub_FFF2B5CE add     #-54h, sp, sp   ; <<<< FUNC sub_FFF2B5CE
FFF2B5D1  a501                              mov.l   r1, 54h+var_4[sp]
FFF2B5D3  a48a                              mov.l   r2, 54h+var_8[sp]
FFF2B5D5  a483                              mov.l   r3, 54h+var_C[sp]
FFF2B5D7  a40c                              mov.l   r4, 54h+var_10[sp]
FFF2B5D9  ac8a                              mov.l   54h+var_8[sp], r2
FFF2B5DB  ad01                              mov.l   54h+var_4[sp], r1
FFF2B5DD  05cf39ff                          bsr.a   sub_FFF1EFAC
FFF2B5E1  a081                              mov.l   r1, 54h+var_4C[sp]
FFF2B5E3  ac09                              mov.l   54h+var_10[sp], r1
FFF2B5E5  72110c0c                          add     #0C0Ch, r1, r1
FFF2B5E9  fb3a0002                          mov.l   #200h, r3
FFF2B5ED  6602                              mov.l   #0, r2
FFF2B5EF  ef34                              mov.l   r3, r4
FFF2B5F1  05be2e00                          bsr.a   sub_FFF2E4AF
FFF2B5F5  ac09                              mov.l   54h+var_10[sp], r1
FFF2B5F7  72110c0c                          add     #0C0Ch, r1, r1
FFF2B5FB  a181                              mov.l   r1, 54h+var_3C[sp]
FFF2B5FD  ad01                              mov.l   54h+var_4[sp], r1
FFF2B5FF  ad9c                              mov.l   5Ch[r1], r4
FFF2B601  66b3                              mov.l   #0Bh, r3
FFF2B603  754220                            mov.l   #20h, r2 ; ' '
FFF2B606  71010d                            add     #54h+var_47, sp, r1
FFF2B609  05a62e00                          bsr.a   sub_FFF2E4AF
FFF2B60D  3c0d2e                            mov.b   #2Eh, 54h+var_47[sp] ; '.'
FFF2B610  ad01                              mov.l   54h+var_4[sp], r1
FFF2B612  ac8c                              mov.l   54h+var_8[sp], r4
FFF2B614  6040                              sub     #4, sp
FFF2B616  e301                              mov.l   r1, 58h+var_58[sp]
FFF2B618  754310                            mov.l   #10h, r3
FFF2B61B  710211                            add     #58h+var_47, sp, r2
FFF2B61E  710120                            add     #58h+var_38, sp, r1
FFF2B621  39a700                            bsr.w   sub_FFF2B6C8
FFF2B624  6240                              add     #4, sp
FFF2B626  a981                              mov.l   54h+var_3C[sp], r1
FFF2B628  711220                            add     #20h, r1, r2 ; ' '
FFF2B62B  a182                              mov.l   r2, 54h+var_3C[sp]
FFF2B62D  754320                            mov.l   #20h, r3 ; ' '
FFF2B630  71021c                            add     #54h+var_38, sp, r2
FFF2B633  05612f00                          bsr.a   sub_FFF2E594
FFF2B637  3c0e2e                            mov.b   #2Eh, 54h+var_46[sp] ; '.'
FFF2B63A  ad01                              mov.l   54h+var_4[sp], r1
FFF2B63C  ac84                              mov.l   54h+var_C[sp], r4
FFF2B63E  6040                              sub     #4, sp
FFF2B640  e301                              mov.l   r1, 58h+var_58[sp]
FFF2B642  754310                            mov.l   #10h, r3
FFF2B645  710211                            add     #58h+var_47, sp, r2
FFF2B648  710120                            add     #58h+var_38, sp, r1
FFF2B64B  397d00                            bsr.w   sub_FFF2B6C8
FFF2B64E  6240                              add     #4, sp
FFF2B650  a981                              mov.l   54h+var_3C[sp], r1
FFF2B652  754320                            mov.l   #20h, r3 ; ' '
FFF2B655  71021c                            add     #54h+var_38, sp, r2
FFF2B658  053c2f00                          bsr.a   sub_FFF2E594
FFF2B65C  ac0b                              mov.l   54h+var_10[sp], r3
FFF2B65E  a882                              mov.l   54h+var_4C[sp], r2
FFF2B660  ad01                              mov.l   54h+var_4[sp], r1
FFF2B662  72330c0c                          add     #0C0Ch, r3, r3
FFF2B666  6614                              mov.l   #1, r4
FFF2B668  053a3aff                          bsr.a   sub_FFF1F0A2
FFF2B66C  a389                              mov.l   r1, 54h+var_18[sp]
FFF2B66E  ab89                              mov.l   54h+var_18[sp], r1
FFF2B670  6101                              cmp     #0, r1
FFF2B672  16                                beq.s   loc_FFF2B678
FFF2B673  e1000f                            mov.l   54h+var_18[sp], 54h+var_54[sp]
FFF2B676  2e4c                              bra.b   loc_FFF2B6C2
FFF2B678  ac09                   loc_FFF2B678 mov.l   54h+var_10[sp], r1
FFF2B67A  72110c0c                          add     #0C0Ch, r1, r1
FFF2B67E  fb3a0002                          mov.l   #200h, r3
FFF2B682  6602                              mov.l   #0, r2
FFF2B684  ef34                              mov.l   r3, r4
FFF2B686  05292e00                          bsr.a   sub_FFF2E4AF
FFF2B68A  3d0301                            mov.w   #1, 54h+var_4E[sp]
FFF2B68D  2e28                              bra.b   loc_FFF2B6B5
FFF2B68F  a882                   loc_FFF2B68F mov.l   54h+var_4C[sp], r2
FFF2B691  06c90203                          add     54h+var_4E[sp].uw, r2
FFF2B695  ac0b                              mov.l   54h+var_10[sp], r3
FFF2B697  ad01                              mov.l   54h+var_4[sp], r1
FFF2B699  72330c0c                          add     #0C0Ch, r3, r3
FFF2B69D  6614                              mov.l   #1, r4
FFF2B69F  05033aff                          bsr.a   sub_FFF1F0A2
FFF2B6A3  a389                              mov.l   r1, 54h+var_18[sp]
FFF2B6A5  ab89                              mov.l   54h+var_18[sp], r1
FFF2B6A7  6101                              cmp     #0, r1
FFF2B6A9  16                                beq.s   loc_FFF2B6AF
FFF2B6AA  e1000f                            mov.l   54h+var_18[sp], 54h+var_54[sp]
FFF2B6AD  2e15                              bra.b   loc_FFF2B6C2
FFF2B6AF  9889                   loc_FFF2B6AF mov.w   54h+var_4E[sp], r1
FFF2B6B1  6211                              add     #1, r1
FFF2B6B3  9089                              mov.w   r1, 54h+var_4E[sp]
FFF2B6B5  ad01                   loc_FFF2B6B5 mov.l   54h+var_4[sp], r1
FFF2B6B7  b88a                              movu.w  54h+var_4E[sp], r2
FFF2B6B9  06c51202                          cmp     4[r1].uw, r2
FFF2B6BD  29d2                              blt.b   loc_FFF2B68F
FFF2B6BF  f80600                            mov.l   #0, 54h+var_54[sp]
FFF2B6C2  ec01                   loc_FFF2B6C2 mov.l   54h+var_54[sp], r1
FFF2B6C4  a401                              mov.l   r1, 54h+var_14[sp]
FFF2B6C6  6715                              rtsd    #15h
FFF2B6C8  7100ec                 sub_FFF2B6C8 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2B6C8
FFF2B6CB  a101                              mov.l   r1, 14h+var_4[sp]
FFF2B6CD  a08a                              mov.l   r2, 14h+var_8[sp]
FFF2B6CF  828b                              mov.b   r3, 14h+var_9[sp]
FFF2B6D1  a00c                              mov.l   r4, 14h+var_10[sp]
FFF2B6D3  a981                              mov.l   14h+arg_0[sp], r1
FFF2B6D5  e301                              mov.l   r1, 14h+var_14[sp]
FFF2B6D7  ad9c                              mov.l   5Ch[r1], r4
FFF2B6D9  a901                              mov.l   14h+var_4[sp], r1
FFF2B6DB  754320                            mov.l   #20h, r3 ; ' '
FFF2B6DE  6602                              mov.l   #0, r2
FFF2B6E0  05cf2d00                          bsr.a   sub_FFF2E4AF
FFF2B6E4  a88a                              mov.l   14h+var_8[sp], r2
FFF2B6E6  a901                              mov.l   14h+var_4[sp], r1
FFF2B6E8  66b3                              mov.l   #0Bh, r3
FFF2B6EA  058e2d00                          bsr.a   sub_FFF2E478
FFF2B6EE  b289                              movu.b  14h+var_9[sp], r1
FFF2B6F0  a902                              mov.l   14h+var_4[sp], r2
FFF2B6F2  82a9                              mov.b   r1, 0Bh[r2]
FFF2B6F4  a901                              mov.l   14h+var_4[sp], r1
FFF2B6F6  6673                              mov.l   #7, r3
FFF2B6F8  6602                              mov.l   #0, r2
FFF2B6FA  05e64eff                          bsr.a   sub_FFF205E0
FFF2B6FE  ec01                              mov.l   14h+var_14[sp], r1
FFF2B700  8c13                              mov.b   10h[r1], r3
FFF2B702  a80a                              mov.l   14h+var_10[sp], r2
FFF2B704  a901                              mov.l   14h+var_4[sp], r1
FFF2B706  05de4fff                          bsr.a   sub_FFF206E4
FFF2B70A  a901                              mov.l   14h+var_4[sp], r1
FFF2B70C  3e1700                            mov.l   #0, 1Ch[r1]
FFF2B70F  6705                              rtsd    #5
FFF2B711  7100ec                 sub_FFF2B711 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2B711
FFF2B714  a101                              mov.l   r1, 14h+var_4[sp]
FFF2B716  0580a7fe                          bsr.a   sub_FFF15E96
FFF2B71A  a009                              mov.l   r1, 14h+var_10[sp]
FFF2B71C  a809                              mov.l   14h+var_10[sp], r1
FFF2B71E  6101                              cmp     #0, r1
FFF2B720  210f                              bne.b   loc_FFF2B72F
FFF2B722  6602                              mov.l   #0, r2
FFF2B724  fb16e1                            mov.l   #-1Fh, r1
FFF2B727  05f936ff                          bsr.a   sub_FFF1EE20
FFF2B72B  e301                              mov.l   r1, 14h+var_14[sp]
FFF2B72D  2e14                              bra.b   loc_FFF2B741
FFF2B72F  a80a                   loc_FFF2B72F mov.l   14h+var_10[sp], r2
FFF2B731  a901                              mov.l   14h+var_4[sp], r1
FFF2B733  391400                            bsr.w   sub_FFF2B747
FFF2B736  a081                              mov.l   r1, 14h+var_C[sp]
FFF2B738  a809                              mov.l   14h+var_10[sp], r1
FFF2B73A  056ca7fe                          bsr.a   sub_FFF15EA6
FFF2B73E  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2B741  ec01                   loc_FFF2B741 mov.l   14h+var_14[sp], r1
FFF2B743  a089                              mov.l   r1, 14h+var_8[sp]
FFF2B745  6705                              rtsd    #5
FFF2B747  6e67                   sub_FFF2B747 pushm   r6-r7   ; <<<< FUNC sub_FFF2B747
FFF2B749  72008cfd                          add     #-274h, sp, sp
FFF2B74D  e7019c                            mov.l   r1, 274h+var_4[sp]
FFF2B750  e7029b                            mov.l   r2, 274h+var_8[sp]
FFF2B753  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2B759  e4e003                            mov.l   [r14], 274h+var_268[sp]
FFF2B75C  058f98ff                          bsr.a   sub_FFF24FEB
FFF2B760  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B763  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B766  6101                              cmp     #0, r1
FFF2B768  2010                              beq.b   loc_FFF2B778
FFF2B76A  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B76D  6602                              mov.l   #0, r2
FFF2B76F  05b136ff                          bsr.a   sub_FFF1EE20
FFF2B773  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B775  389f01                            bra.w   loc_FFF2B914
FFF2B778  ed019c                 loc_FFF2B778 mov.l   274h+var_4[sp], r1
FFF2B77B  6101                              cmp     #0, r1
FFF2B77D  2110                              bne.b   loc_FFF2B78D
FFF2B77F  6602                              mov.l   #0, r2
FFF2B781  fb16ff                            mov.l   #-1, r1
FFF2B784  059c36ff                          bsr.a   sub_FFF1EE20
FFF2B788  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B78A  388a01                            bra.w   loc_FFF2B914
FFF2B78D  ed019c                 loc_FFF2B78D mov.l   274h+var_4[sp], r1
FFF2B790  057e4bff                          bsr.a   sub_FFF2030E
FFF2B794  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B797  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B79A  6101                              cmp     #0, r1
FFF2B79C  2010                              beq.b   loc_FFF2B7AC
FFF2B79E  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B7A1  6602                              mov.l   #0, r2
FFF2B7A3  057d36ff                          bsr.a   sub_FFF1EE20
FFF2B7A7  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B7A9  386b01                            bra.w   loc_FFF2B914
FFF2B7AC  ed069c                 loc_FFF2B7AC mov.l   274h+var_4[sp], r6
FFF2B7AF  ed079b                            mov.l   274h+var_8[sp], r7
FFF2B7B2  ef61                              mov.l   r6, r1
FFF2B7B4  056e2e00                          bsr.a   sub_FFF2E622
FFF2B7B8  72770c10                          add     #100Ch, r7, r7
FFF2B7BC  ef13                              mov.l   r1, r3
FFF2B7BE  6213                              add     #1, r3
FFF2B7C0  ef71                              mov.l   r7, r1
FFF2B7C2  ef62                              mov.l   r6, r2
FFF2B7C4  05ca2e00                          bsr.a   sub_FFF2E68E
FFF2B7C8  ed019b                            mov.l   274h+var_8[sp], r1
FFF2B7CB  72110c10                          add     #100Ch, r1, r1
FFF2B7CF  05522700                          bsr.a   sub_FFF2DF21
FFF2B7D3  ed019b                            mov.l   274h+var_8[sp], r1
FFF2B7D6  ce110c10                          mov.b   100Ch[r1], r1
FFF2B7DA  05b12f00                          bsr.a   sub_FFF2E78B
FFF2B7DE  8289                              mov.b   r1, 274h+var_269[sp]
FFF2B7E0  b289                              movu.b  274h+var_269[sp], r1
FFF2B7E2  71020c                            add     #274h+var_268, sp, r2
FFF2B7E5  053a37ff                          bsr.a   sub_FFF1EF1F
FFF2B7E9  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B7EC  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B7EF  6101                              cmp     #0, r1
FFF2B7F1  2010                              beq.b   loc_FFF2B801
FFF2B7F3  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B7F6  6602                              mov.l   #0, r2
FFF2B7F8  052836ff                          bsr.a   sub_FFF1EE20
FFF2B7FC  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B7FE  381601                            bra.w   loc_FFF2B914
FFF2B801  3c8800                 loc_FFF2B801 mov.b   #0, 274h+var_25C[sp]
FFF2B804  ed039b                            mov.l   274h+var_8[sp], r3
FFF2B807  72310c10                          add     #100Ch, r3, r1
FFF2B80B  710214                            add     #274h+var_260, sp, r2
FFF2B80E  390605                            bsr.w   sub_FFF2BD14
FFF2B811  e70198                            mov.l   r1, 274h+var_14[sp]
FFF2B814  ed0198                            mov.l   274h+var_14[sp], r1
FFF2B817  6101                              cmp     #0, r1
FFF2B819  2117                              bne.b   loc_FFF2B830
FFF2B81B  05bea4fe                          bsr.a   sub_FFF15CD9
FFF2B81F  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B822  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B825  6602                              mov.l   #0, r2
FFF2B827  05f935ff                          bsr.a   sub_FFF1EE20
FFF2B82B  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B82D  38e700                            bra.w   loc_FFF2B914
FFF2B830  ed029b                 loc_FFF2B830 mov.l   274h+var_8[sp], r2
FFF2B833  ed0198                            mov.l   274h+var_14[sp], r1
FFF2B836  39cc09                            bsr.w   sub_FFF2C202
FFF2B839  a101                              mov.l   r1, 274h+var_264[sp]
FFF2B83B  a901                              mov.l   274h+var_264[sp], r1
FFF2B83D  6101                              cmp     #0, r1
FFF2B83F  2010                              beq.b   loc_FFF2B84F
FFF2B841  6602                              mov.l   #0, r2
FFF2B843  fb16ec                            mov.l   #-14h, r1
FFF2B846  05da35ff                          bsr.a   sub_FFF1EE20
FFF2B84A  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B84C  38c800                            bra.w   loc_FFF2B914
FFF2B84F  a889                   loc_FFF2B84F mov.l   274h+var_268[sp], r1
FFF2B851  591e6c                            movu.b  6Ch[r1], r14
FFF2B854  641e                              and     #1, r14
FFF2B856  611e                              cmp     #1, r14
FFF2B858  200e                              beq.b   loc_FFF2B866
FFF2B85A  a889                              mov.l   274h+var_268[sp], r1
FFF2B85C  591e6c                            movu.b  6Ch[r1], r14
FFF2B85F  752e10                            and     #10h, r14
FFF2B862  755e10                            cmp     #10h, r14
FFF2B865  1d                                bne.s   loc_FFF2B86A
FFF2B866  f80601                 loc_FFF2B866 mov.l   #1, 274h+var_274[sp]
FFF2B869  0c                                bra.s   loc_FFF2B86D
FFF2B86A  f80600                 loc_FFF2B86A mov.l   #0, 274h+var_274[sp]
FFF2B86D  ec01                   loc_FFF2B86D mov.l   274h+var_274[sp], r1
FFF2B86F  6101                              cmp     #0, r1
FFF2B871  2035                              beq.b   loc_FFF2B8A6
FFF2B873  a889                              mov.l   274h+var_268[sp], r1
FFF2B875  056ea5fe                          bsr.a   sub_FFF15DE3
FFF2B879  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B87C  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B87F  6101                              cmp     #0, r1
FFF2B881  2010                              beq.b   loc_FFF2B891
FFF2B883  6602                              mov.l   #0, r2
FFF2B885  fb16c1                            mov.l   #-3Fh, r1
FFF2B888  059835ff                          bsr.a   sub_FFF1EE20
FFF2B88C  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B88E  388600                            bra.w   loc_FFF2B914
FFF2B891  ed029b                 loc_FFF2B891 mov.l   274h+var_8[sp], r2
FFF2B894  72210c10                          add     #100Ch, r2, r1
FFF2B898  398400                            bsr.w   sub_FFF2B91C
FFF2B89B  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B89E  a889                              mov.l   274h+var_268[sp], r1
FFF2B8A0  054ea5fe                          bsr.a   sub_FFF15DEE
FFF2B8A4  2e0f                              bra.b   loc_FFF2B8B3
FFF2B8A6  ed029b                 loc_FFF2B8A6 mov.l   274h+var_8[sp], r2
FFF2B8A9  72210c10                          add     #100Ch, r2, r1
FFF2B8AD  396f00                            bsr.w   sub_FFF2B91C
FFF2B8B0  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B8B3  ed0199                 loc_FFF2B8B3 mov.l   274h+var_10[sp], r1
FFF2B8B6  6101                              cmp     #0, r1
FFF2B8B8  200f                              beq.b   loc_FFF2B8C7
FFF2B8BA  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B8BD  6602                              mov.l   #0, r2
FFF2B8BF  056135ff                          bsr.a   sub_FFF1EE20
FFF2B8C3  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B8C5  2e4f                              bra.b   loc_FFF2B914
FFF2B8C7  a889                   loc_FFF2B8C7 mov.l   274h+var_268[sp], r1
FFF2B8C9  051313ff                          bsr.a   sub_FFF1CBDC
FFF2B8CD  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B8D0  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B8D3  6101                              cmp     #0, r1
FFF2B8D5  200f                              beq.b   loc_FFF2B8E4
FFF2B8D7  ed0199                            mov.l   274h+var_10[sp], r1
FFF2B8DA  6602                              mov.l   #0, r2
FFF2B8DC  054435ff                          bsr.a   sub_FFF1EE20
FFF2B8E0  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B8E2  2e32                              bra.b   loc_FFF2B914
FFF2B8E4  a889                   loc_FFF2B8E4 mov.l   274h+var_268[sp], r1
FFF2B8E6  591e6c                            movu.b  6Ch[r1], r14
FFF2B8E9  752e10                            and     #10h, r14
FFF2B8EC  755e10                            cmp     #10h, r14
FFF2B8EF  211a                              bne.b   loc_FFF2B909
FFF2B8F1  ed049b                            mov.l   274h+var_8[sp], r4
FFF2B8F4  5a433216                          movu.b  1632h[r4], r3
FFF2B8F8  5a423116                          movu.b  1631h[r4], r2
FFF2B8FC  a889                              mov.l   274h+var_268[sp], r1
FFF2B8FE  72440c06                          add     #60Ch, r4, r4
FFF2B902  055aabff                          bsr.a   sub_FFF2645C
FFF2B906  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2B909  ed0199                 loc_FFF2B909 mov.l   274h+var_10[sp], r1
FFF2B90C  6602                              mov.l   #0, r2
FFF2B90E  051235ff                          bsr.a   sub_FFF1EE20
FFF2B912  a009                              mov.l   r1, 274h+var_270[sp]
FFF2B914  a809                   loc_FFF2B914 mov.l   274h+var_270[sp], r1
FFF2B916  e7019a                            mov.l   r1, 274h+var_C[sp]
FFF2B919  3f679f                            rtsd    #27Ch, r6-r7
FFF2B91C  7100ac                 sub_FFF2B91C add     #-54h, sp, sp   ; <<<< FUNC sub_FFF2B91C
FFF2B91F  a501                              mov.l   r1, 54h+var_4[sp]
FFF2B921  a48a                              mov.l   r2, 54h+var_8[sp]
FFF2B923  3e0f00                            mov.l   #0, 54h+var_18[sp]
FFF2B926  3e0e00                            mov.l   #0, 54h+var_1C[sp]
FFF2B929  3e0d00                            mov.l   #0, 54h+var_20[sp]
FFF2B92C  3e0c00                            mov.l   #0, 54h+var_24[sp]
FFF2B92F  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2B935  e4e003                            mov.l   [r14], 54h+var_48[sp]
FFF2B938  ac89                              mov.l   54h+var_8[sp], r1
FFF2B93A  fa14301600                        mov.b   #0, 1630h[r1]
FFF2B93F  ad01                              mov.l   54h+var_4[sp], r1
FFF2B941  cc11                              mov.b   [r1], r1
FFF2B943  05482e00                          bsr.a   sub_FFF2E78B
FFF2B947  8289                              mov.b   r1, 54h+var_49[sp]
FFF2B949  b289                              movu.b  54h+var_49[sp], r1
FFF2B94B  71020c                            add     #54h+var_48, sp, r2
FFF2B94E  05d135ff                          bsr.a   sub_FFF1EF1F
FFF2B952  a409                              mov.l   r1, 54h+var_10[sp]
FFF2B954  ac09                              mov.l   54h+var_10[sp], r1
FFF2B956  6101                              cmp     #0, r1
FFF2B958  10                                beq.s   loc_FFF2B960
FFF2B959  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2B95D  382f02                            bra.w   loc_FFF2BB8C
FFF2B960  a889                   loc_FFF2B960 mov.l   54h+var_48[sp], r1
FFF2B962  05fb35ff                          bsr.a   sub_FFF1EF5D
FFF2B966  a409                              mov.l   r1, 54h+var_10[sp]
FFF2B968  ac09                              mov.l   54h+var_10[sp], r1
FFF2B96A  6101                              cmp     #0, r1
FFF2B96C  10                                beq.s   loc_FFF2B974
FFF2B96D  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2B971  381b02                            bra.w   loc_FFF2BB8C
FFF2B974  a889                   loc_FFF2B974 mov.l   54h+var_48[sp], r1
FFF2B976  051b36ff                          bsr.a   sub_FFF1EF91
FFF2B97A  a409                              mov.l   r1, 54h+var_10[sp]
FFF2B97C  ac09                              mov.l   54h+var_10[sp], r1
FFF2B97E  6101                              cmp     #0, r1
FFF2B980  10                                beq.s   loc_FFF2B988
FFF2B981  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2B985  380702                            bra.w   loc_FFF2BB8C
FFF2B988  ad01                   loc_FFF2B988 mov.l   54h+var_4[sp], r1
FFF2B98A  6221                              add     #2, r1
FFF2B98C  a401                              mov.l   r1, 54h+var_14[sp]
FFF2B98E  a889                              mov.l   54h+var_48[sp], r1
FFF2B990  e5100d0d                          mov.l   34h[r1], 54h+var_20[sp]
FFF2B994  a889                              mov.l   54h+var_48[sp], r1
FFF2B996  8c11                              mov.b   10h[r1], r1
FFF2B998  755120                            cmp     #20h, r1 ; ' '
FFF2B99B  3ad500                            beq.w   loc_FFF2BA70
FFF2B99E  ac8a                              mov.l   54h+var_8[sp], r2
FFF2B9A0  ac01                              mov.l   54h+var_14[sp], r1
FFF2B9A2  05e447ff                          bsr.a   sub_FFF20186
FFF2B9A6  a401                              mov.l   r1, 54h+var_14[sp]
FFF2B9A8  ac01                              mov.l   54h+var_14[sp], r1
FFF2B9AA  6101                              cmp     #0, r1
FFF2B9AC  18                                bne.s   loc_FFF2B9B4
FFF2B9AD  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2B9B1  38db01                            bra.w   loc_FFF2BB8C
FFF2B9B4  ac89                   loc_FFF2B9B4 mov.l   54h+var_8[sp], r1
FFF2B9B6  cc1e                              mov.b   [r1], r14
FFF2B9B8  610e                              cmp     #0, r14
FFF2B9BA  18                                bne.s   loc_FFF2B9C2
FFF2B9BB  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2B9BF  38cd01                            bra.w   loc_FFF2BB8C
FFF2B9C2  ac8a                   loc_FFF2B9C2 mov.l   54h+var_8[sp], r2
FFF2B9C4  a889                              mov.l   54h+var_48[sp], r1
FFF2B9C6  60c0                              sub     #0Ch, sp
FFF2B9C8  a082                              mov.l   r2, 60h+var_58[sp]
FFF2B9CA  710348                            add     #60h+var_18, sp, r3
FFF2B9CD  a00b                              mov.l   r3, 60h+var_5C[sp]
FFF2B9CF  f80400                            mov.b   #0, 60h+var_60[sp]
FFF2B9D2  6604                              mov.l   #0, r4
FFF2B9D4  71031c                            add     #60h+var_44, sp, r3
FFF2B9D7  055c37ff                          bsr.a   sub_FFF1F133
FFF2B9DB  62c0                              add     #0Ch, sp
FFF2B9DD  a409                              mov.l   r1, 54h+var_10[sp]
FFF2B9DF  ac09                              mov.l   54h+var_10[sp], r1
FFF2B9E1  6101                              cmp     #0, r1
FFF2B9E3  10                                beq.s   loc_FFF2B9EB
FFF2B9E4  f90601fc                          mov.l   #-4, 54h+var_50[sp]
FFF2B9E8  38a401                            bra.w   loc_FFF2BB8C
FFF2B9EB  a889                   loc_FFF2B9EB mov.l   54h+var_48[sp], r1
FFF2B9ED  8c12                              mov.b   10h[r1], r2
FFF2B9EF  710110                            add     #54h+var_44, sp, r1
FFF2B9F2  05a64cff                          bsr.a   sub_FFF20698
FFF2B9F6  a309                              mov.l   r1, 54h+var_20[sp]
FFF2B9F8  ac89                              mov.l   54h+var_8[sp], r1
FFF2B9FA  fa14301601                        mov.b   #1, 1630h[r1]
FFF2B9FF  2e71                              bra.b   loc_FFF2BA70
FFF2BA01  ac8a                   loc_FFF2BA01 mov.l   54h+var_8[sp], r2
FFF2BA03  ac01                              mov.l   54h+var_14[sp], r1
FFF2BA05  058147ff                          bsr.a   sub_FFF20186
FFF2BA09  a401                              mov.l   r1, 54h+var_14[sp]
FFF2BA0B  ac01                              mov.l   54h+var_14[sp], r1
FFF2BA0D  6101                              cmp     #0, r1
FFF2BA0F  18                                bne.s   loc_FFF2BA17
FFF2BA10  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2BA14  387801                            bra.w   loc_FFF2BB8C
FFF2BA17  ac89                   loc_FFF2BA17 mov.l   54h+var_8[sp], r1
FFF2BA19  cc1e                              mov.b   [r1], r14
FFF2BA1B  610e                              cmp     #0, r14
FFF2BA1D  18                                bne.s   loc_FFF2BA25
FFF2BA1E  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2BA22  386a01                            bra.w   loc_FFF2BB8C
FFF2BA25  e5000d0c               loc_FFF2BA25 mov.l   54h+var_20[sp], 54h+var_24[sp]
FFF2BA29  ac8b                              mov.l   54h+var_8[sp], r3
FFF2BA2B  ab0a                              mov.l   54h+var_20[sp], r2
FFF2BA2D  a889                              mov.l   54h+var_48[sp], r1
FFF2BA2F  7100f0                            add     #-10h, sp, sp
FFF2BA32  a08b                              mov.l   r3, 64h+var_58[sp]
FFF2BA34  710448                            add     #64h+var_1C, sp, r4
FFF2BA37  a084                              mov.l   r4, 64h+var_5C[sp]
FFF2BA39  71044c                            add     #64h+var_18, sp, r4
FFF2BA3C  a00c                              mov.l   r4, 64h+var_60[sp]
FFF2BA3E  3c0100                            mov.b   #0, 64h+var_63[sp]
FFF2BA41  f80400                            mov.b   #0, 64h+var_64[sp]
FFF2BA44  710420                            add     #64h+var_44, sp, r4
FFF2BA47  059d3cff                          bsr.a   sub_FFF1F6E4
FFF2BA4B  710010                            add     #10h, sp, sp
FFF2BA4E  a409                              mov.l   r1, 54h+var_10[sp]
FFF2BA50  ac09                              mov.l   54h+var_10[sp], r1
FFF2BA52  6101                              cmp     #0, r1
FFF2BA54  10                                beq.s   loc_FFF2BA5C
FFF2BA55  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2BA59  383301                            bra.w   loc_FFF2BB8C
FFF2BA5C  a889                   loc_FFF2BA5C mov.l   54h+var_48[sp], r1
FFF2BA5E  8c12                              mov.b   10h[r1], r2
FFF2BA60  710110                            add     #54h+var_44, sp, r1
FFF2BA63  05354cff                          bsr.a   sub_FFF20698
FFF2BA67  a309                              mov.l   r1, 54h+var_20[sp]
FFF2BA69  ac89                              mov.l   54h+var_8[sp], r1
FFF2BA6B  fa14301601                        mov.b   #1, 1630h[r1]
FFF2BA70  ac01                   loc_FFF2BA70 mov.l   54h+var_14[sp], r1
FFF2BA72  cc1e                              mov.b   [r1], r14
FFF2BA74  610e                              cmp     #0, r14
FFF2BA76  218b                              bne.b   loc_FFF2BA01
FFF2BA78  a889                              mov.l   54h+var_48[sp], r1
FFF2BA7A  8c12                              mov.b   10h[r1], r2
FFF2BA7C  710110                            add     #54h+var_44, sp, r1
FFF2BA7F  05194cff                          bsr.a   sub_FFF20698
FFF2BA83  a309                              mov.l   r1, 54h+var_20[sp]
FFF2BA85  ac89                              mov.l   54h+var_8[sp], r1
FFF2BA87  5a1e3016                          movu.b  1630h[r1], r14
FFF2BA8B  611e                              cmp     #1, r14
FFF2BA8D  2112                              bne.b   loc_FFF2BA9F
FFF2BA8F  a889                              mov.l   54h+var_48[sp], r1
FFF2BA91  591e6c                            movu.b  6Ch[r1], r14
FFF2BA94  752e10                            and     #10h, r14
FFF2BA97  755e10                            cmp     #10h, r14
FFF2BA9A  1d                                bne.s   loc_FFF2BA9F
FFF2BA9B  f80601                            mov.l   #1, 54h+var_54[sp]
FFF2BA9E  0c                                bra.s   loc_FFF2BAA2
FFF2BA9F  f80600                 loc_FFF2BA9F mov.l   #0, 54h+var_54[sp]
FFF2BAA2  ec01                   loc_FFF2BAA2 mov.l   54h+var_54[sp], r1
FFF2BAA4  6101                              cmp     #0, r1
FFF2BAA6  206c                              beq.b   loc_FFF2BB12
FFF2BAA8  ad01                              mov.l   54h+var_4[sp], r1
FFF2BAAA  053fb1ff                          bsr.a   sub_FFF26BE9
FFF2BAAE  8281                              mov.b   r1, 54h+var_4A[sp]
FFF2BAB0  ac8b                              mov.l   54h+var_8[sp], r3
FFF2BAB2  a889                              mov.l   54h+var_48[sp], r1
FFF2BAB4  72320c06                          add     #60Ch, r3, r2
FFF2BAB8  05d1a7ff                          bsr.a   sub_FFF26289
FFF2BABC  a409                              mov.l   r1, 54h+var_10[sp]
FFF2BABE  ac09                              mov.l   54h+var_10[sp], r1
FFF2BAC0  6101                              cmp     #0, r1
FFF2BAC2  2130                              bne.b   loc_FFF2BAF2
FFF2BAC4  ac8a                              mov.l   54h+var_8[sp], r2
FFF2BAC6  b285                              movu.b  54h+var_4A[sp], r5
FFF2BAC8  ab8c                              mov.l   54h+var_18[sp], r4
FFF2BACA  ab83                              mov.l   54h+var_1C[sp], r3
FFF2BACC  a889                              mov.l   54h+var_48[sp], r1
FFF2BACE  60c0                              sub     #0Ch, sp
FFF2BAD0  a082                              mov.l   r2, 60h+var_58[sp]
FFF2BAD2  72220c06                          add     #60Ch, r2, r2
FFF2BAD6  a00a                              mov.l   r2, 60h+var_5C[sp]
FFF2BAD8  c305                              mov.b   r5, 60h+var_60[sp]
FFF2BADA  71021c                            add     #60h+var_44, sp, r2
FFF2BADD  0569a8ff                          bsr.a   sub_FFF26346
FFF2BAE1  62c0                              add     #0Ch, sp
FFF2BAE3  a409                              mov.l   r1, 54h+var_10[sp]
FFF2BAE5  ac09                              mov.l   54h+var_10[sp], r1
FFF2BAE7  6101                              cmp     #0, r1
FFF2BAE9  2029                              beq.b   loc_FFF2BB12
FFF2BAEB  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2BAEF  389d00                            bra.w   loc_FFF2BB8C
FFF2BAF2  ac09                   loc_FFF2BAF2 mov.l   54h+var_10[sp], r1
FFF2BAF4  7601d3fe                          cmp     #-12Dh, r1
FFF2BAF8  10                                beq.s   loc_FFF2BB00
FFF2BAF9  ac09                              mov.l   54h+var_10[sp], r1
FFF2BAFB  7601d4fe                          cmp     #-12Ch, r1
FFF2BAFF  1d                                bne.s   loc_FFF2BB04
FFF2BB00  f80601                 loc_FFF2BB00 mov.l   #1, 54h+var_54[sp]
FFF2BB03  0c                                bra.s   loc_FFF2BB07
FFF2BB04  f80600                 loc_FFF2BB04 mov.l   #0, 54h+var_54[sp]
FFF2BB07  ec01                   loc_FFF2BB07 mov.l   54h+var_54[sp], r1
FFF2BB09  6101                              cmp     #0, r1
FFF2BB0B  1f                                bne.s   loc_FFF2BB12
FFF2BB0C  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2BB10  2e7c                              bra.b   loc_FFF2BB8C
FFF2BB12  ab01                   loc_FFF2BB12 mov.l   54h+var_24[sp], r1
FFF2BB14  6101                              cmp     #0, r1
FFF2BB16  a889                              mov.l   54h+var_48[sp], r1
FFF2BB18  2029                              beq.b   loc_FFF2BB41
FFF2BB1A  ac8b                              mov.l   54h+var_8[sp], r3
FFF2BB1C  ab02                              mov.l   54h+var_24[sp], r2
FFF2BB1E  7100f0                            add     #-10h, sp, sp
FFF2BB21  a08b                              mov.l   r3, 64h+var_58[sp]
FFF2BB23  710448                            add     #64h+var_1C, sp, r4
FFF2BB26  a084                              mov.l   r4, 64h+var_5C[sp]
FFF2BB28  71044c                            add     #64h+var_18, sp, r4
FFF2BB2B  a00c                              mov.l   r4, 64h+var_60[sp]
FFF2BB2D  3c0100                            mov.b   #0, 64h+var_63[sp]
FFF2BB30  f80402                            mov.b   #2, 64h+var_64[sp]
FFF2BB33  710420                            add     #64h+var_44, sp, r4
FFF2BB36  05ae3bff                          bsr.a   sub_FFF1F6E4
FFF2BB3A  710010                            add     #10h, sp, sp
FFF2BB3D  a409                              mov.l   r1, 54h+var_10[sp]
FFF2BB3F  2e1d                              bra.b   loc_FFF2BB5C
FFF2BB41  ac8a                   loc_FFF2BB41 mov.l   54h+var_8[sp], r2
FFF2BB43  60c0                              sub     #0Ch, sp
FFF2BB45  a082                              mov.l   r2, 60h+var_58[sp]
FFF2BB47  710348                            add     #60h+var_18, sp, r3
FFF2BB4A  a00b                              mov.l   r3, 60h+var_5C[sp]
FFF2BB4C  f80400                            mov.b   #0, 60h+var_60[sp]
FFF2BB4F  6624                              mov.l   #2, r4
FFF2BB51  71031c                            add     #60h+var_44, sp, r3
FFF2BB54  05df35ff                          bsr.a   sub_FFF1F133
FFF2BB58  62c0                              add     #0Ch, sp
FFF2BB5A  a409                              mov.l   r1, 54h+var_10[sp]
FFF2BB5C  ac09                   loc_FFF2BB5C mov.l   54h+var_10[sp], r1
FFF2BB5E  6101                              cmp     #0, r1
FFF2BB60  17                                beq.s   loc_FFF2BB67
FFF2BB61  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2BB65  2e27                              bra.b   loc_FFF2BB8C
FFF2BB67  ac8b                   loc_FFF2BB67 mov.l   54h+var_8[sp], r3
FFF2BB69  ab0a                              mov.l   54h+var_20[sp], r2
FFF2BB6B  a889                              mov.l   54h+var_48[sp], r1
FFF2BB6D  05d686ff                          bsr.a   sub_FFF24243
FFF2BB71  a409                              mov.l   r1, 54h+var_10[sp]
FFF2BB73  ac09                              mov.l   54h+var_10[sp], r1
FFF2BB75  6101                              cmp     #0, r1
FFF2BB77  17                                beq.s   loc_FFF2BB7E
FFF2BB78  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2BB7C  2e10                              bra.b   loc_FFF2BB8C
FFF2BB7E  ac8a                   loc_FFF2BB7E mov.l   54h+var_8[sp], r2
FFF2BB80  a889                              mov.l   54h+var_48[sp], r1
FFF2BB82  05a08dff                          bsr.a   sub_FFF24922
FFF2BB86  a409                              mov.l   r1, 54h+var_10[sp]
FFF2BB88  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2BB8C  a809                   loc_FFF2BB8C mov.l   54h+var_50[sp], r1
FFF2BB8E  a481                              mov.l   r1, 54h+var_C[sp]
FFF2BB90  6715                              rtsd    #15h
FFF2BB92  7100ec                 sub_FFF2BB92 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2BB92
FFF2BB95  a101                              mov.l   r1, 14h+var_4[sp]
FFF2BB97  05ffa2fe                          bsr.a   sub_FFF15E96
FFF2BB9B  a009                              mov.l   r1, 14h+var_10[sp]
FFF2BB9D  a809                              mov.l   14h+var_10[sp], r1
FFF2BB9F  6101                              cmp     #0, r1
FFF2BBA1  210f                              bne.b   loc_FFF2BBB0
FFF2BBA3  6602                              mov.l   #0, r2
FFF2BBA5  fb16e1                            mov.l   #-1Fh, r1
FFF2BBA8  05d332ff                          bsr.a   sub_FFF1EE7B
FFF2BBAC  e301                              mov.l   r1, 14h+var_14[sp]
FFF2BBAE  2e14                              bra.b   loc_FFF2BBC2
FFF2BBB0  a80a                   loc_FFF2BBB0 mov.l   14h+var_10[sp], r2
FFF2BBB2  a901                              mov.l   14h+var_4[sp], r1
FFF2BBB4  391400                            bsr.w   sub_FFF2BBC8
FFF2BBB7  a081                              mov.l   r1, 14h+var_C[sp]
FFF2BBB9  a809                              mov.l   14h+var_10[sp], r1
FFF2BBBB  05eba2fe                          bsr.a   sub_FFF15EA6
FFF2BBBF  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2BBC2  ec01                   loc_FFF2BBC2 mov.l   14h+var_14[sp], r1
FFF2BBC4  a089                              mov.l   r1, 14h+var_8[sp]
FFF2BBC6  6705                              rtsd    #5
FFF2BBC8  6e67                   sub_FFF2BBC8 pushm   r6-r7   ; <<<< FUNC sub_FFF2BBC8
FFF2BBCA  7100e0                            add     #-20h, sp, sp
FFF2BBCD  a189                              mov.l   r1, 20h+var_4[sp]
FFF2BBCF  a182                              mov.l   r2, 20h+var_8[sp]
FFF2BBD1  051a94ff                          bsr.a   sub_FFF24FEB
FFF2BBD5  a101                              mov.l   r1, 20h+var_10[sp]
FFF2BBD7  a901                              mov.l   20h+var_10[sp], r1
FFF2BBD9  6101                              cmp     #0, r1
FFF2BBDB  200f                              beq.b   loc_FFF2BBEA
FFF2BBDD  a901                              mov.l   20h+var_10[sp], r1
FFF2BBDF  6602                              mov.l   #0, r2
FFF2BBE1  059a32ff                          bsr.a   sub_FFF1EE7B
FFF2BBE5  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2BBE7  382601                            bra.w   loc_FFF2BD0D
FFF2BBEA  a989                   loc_FFF2BBEA mov.l   20h+var_4[sp], r1
FFF2BBEC  6101                              cmp     #0, r1
FFF2BBEE  2110                              bne.b   loc_FFF2BBFE
FFF2BBF0  6602                              mov.l   #0, r2
FFF2BBF2  fb16ff                            mov.l   #-1, r1
FFF2BBF5  058632ff                          bsr.a   sub_FFF1EE7B
FFF2BBF9  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2BBFB  381201                            bra.w   loc_FFF2BD0D
FFF2BBFE  a98e                   loc_FFF2BBFE mov.l   20h+var_4[sp], r6
FFF2BC00  a987                              mov.l   20h+var_8[sp], r7
FFF2BC02  ef61                              mov.l   r6, r1
FFF2BC04  051e2a00                          bsr.a   sub_FFF2E622
FFF2BC08  72770c10                          add     #100Ch, r7, r7
FFF2BC0C  ef13                              mov.l   r1, r3
FFF2BC0E  6213                              add     #1, r3
FFF2BC10  ef71                              mov.l   r7, r1
FFF2BC12  ef62                              mov.l   r6, r2
FFF2BC14  057a2a00                          bsr.a   sub_FFF2E68E
FFF2BC18  a981                              mov.l   20h+var_8[sp], r1
FFF2BC1A  72110c10                          add     #100Ch, r1, r1
FFF2BC1E  05032300                          bsr.a   sub_FFF2DF21
FFF2BC22  a981                              mov.l   20h+var_8[sp], r1
FFF2BC24  72110c10                          add     #100Ch, r1, r1
FFF2BC28  05fa2900                          bsr.a   sub_FFF2E622
FFF2BC2C  a081                              mov.l   r1, 20h+var_18[sp]
FFF2BC2E  a881                              mov.l   20h+var_18[sp], r1
FFF2BC30  6111                              cmp     #1, r1
FFF2BC32  2133                              bne.b   loc_FFF2BC65
FFF2BC34  a981                              mov.l   20h+var_8[sp], r1
FFF2BC36  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2BC3A  755e2f                            cmp     #2Fh, r14 ; '/'
FFF2BC3D  2010                              beq.b   loc_FFF2BC4D
FFF2BC3F  a981                              mov.l   20h+var_8[sp], r1
FFF2BC41  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2BC45  755e5c                            cmp     #5Ch, r14 ; '\'
FFF2BC48  15                                beq.s   loc_FFF2BC4D
FFF2BC49  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2BC4C  0c                                bra.s   loc_FFF2BC50
FFF2BC4D  f80600                 loc_FFF2BC4D mov.l   #0, 20h+var_20[sp]
FFF2BC50  ec01                   loc_FFF2BC50 mov.l   20h+var_20[sp], r1
FFF2BC52  6101                              cmp     #0, r1
FFF2BC54  3aa800                            beq.w   loc_FFF2BCFC
FFF2BC57  6602                              mov.l   #0, r2
FFF2BC59  fb16f4                            mov.l   #-0Ch, r1
FFF2BC5C  051f32ff                          bsr.a   sub_FFF1EE7B
FFF2BC60  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2BC62  38ab00                            bra.w   loc_FFF2BD0D
FFF2BC65  a981                   loc_FFF2BC65 mov.l   20h+var_8[sp], r1
FFF2BC67  72110c10                          add     #100Ch, r1, r1
FFF2BC6B  a882                              mov.l   20h+var_18[sp], r2
FFF2BC6D  6122                              cmp     #2, r2
FFF2BC6F  2175                              bne.b   loc_FFF2BCE4
FFF2BC71  cc1e                              mov.b   [r1], r14
FFF2BC73  755e41                            cmp     #41h, r14 ; 'A'
FFF2BC76  290d                              blt.b   loc_FFF2BC83
FFF2BC78  a981                              mov.l   20h+var_8[sp], r1
FFF2BC7A  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2BC7E  755e5b                            cmp     #5Bh, r14 ; '['
FFF2BC81  2906                              blt.b   loc_FFF2BC87
FFF2BC83  f80601                 loc_FFF2BC83 mov.l   #1, 20h+var_20[sp]
FFF2BC86  0c                                bra.s   loc_FFF2BC8A
FFF2BC87  f80600                 loc_FFF2BC87 mov.l   #0, 20h+var_20[sp]
FFF2BC8A  ec01                   loc_FFF2BC8A mov.l   20h+var_20[sp], r1
FFF2BC8C  6101                              cmp     #0, r1
FFF2BC8E  2028                              beq.b   loc_FFF2BCB6
FFF2BC90  a981                              mov.l   20h+var_8[sp], r1
FFF2BC92  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2BC96  755e61                            cmp     #61h, r14 ; 'a'
FFF2BC99  290d                              blt.b   loc_FFF2BCA6
FFF2BC9B  a981                              mov.l   20h+var_8[sp], r1
FFF2BC9D  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2BCA1  755e7b                            cmp     #7Bh, r14 ; '{'
FFF2BCA4  2906                              blt.b   loc_FFF2BCAA
FFF2BCA6  f80601                 loc_FFF2BCA6 mov.l   #1, 20h+var_20[sp]
FFF2BCA9  0c                                bra.s   loc_FFF2BCAD
FFF2BCAA  f80600                 loc_FFF2BCAA mov.l   #0, 20h+var_20[sp]
FFF2BCAD  ec01                   loc_FFF2BCAD mov.l   20h+var_20[sp], r1
FFF2BCAF  6101                              cmp     #0, r1
FFF2BCB1  15                                beq.s   loc_FFF2BCB6
FFF2BCB2  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2BCB5  0c                                bra.s   loc_FFF2BCB9
FFF2BCB6  f80600                 loc_FFF2BCB6 mov.l   #0, 20h+var_20[sp]
FFF2BCB9  ec01                   loc_FFF2BCB9 mov.l   20h+var_20[sp], r1
FFF2BCBB  6101                              cmp     #0, r1
FFF2BCBD  200f                              beq.b   loc_FFF2BCCC
FFF2BCBF  6602                              mov.l   #0, r2
FFF2BCC1  fb16f4                            mov.l   #-0Ch, r1
FFF2BCC4  05b731ff                          bsr.a   sub_FFF1EE7B
FFF2BCC8  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2BCCA  2e43                              bra.b   loc_FFF2BD0D
FFF2BCCC  a981                   loc_FFF2BCCC mov.l   20h+var_8[sp], r1
FFF2BCCE  ce1e0d10                          mov.b   100Dh[r1], r14
FFF2BCD2  755e3a                            cmp     #3Ah, r14 ; ':'
FFF2BCD5  2027                              beq.b   loc_FFF2BCFC
FFF2BCD7  6602                              mov.l   #0, r2
FFF2BCD9  fb16ff                            mov.l   #-1, r1
FFF2BCDC  059f31ff                          bsr.a   sub_FFF1EE7B
FFF2BCE0  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2BCE2  2e2b                              bra.b   loc_FFF2BD0D
FFF2BCE4  052a46ff               loc_FFF2BCE4 bsr.a   sub_FFF2030E
FFF2BCE8  a101                              mov.l   r1, 20h+var_10[sp]
FFF2BCEA  a901                              mov.l   20h+var_10[sp], r1
FFF2BCEC  6101                              cmp     #0, r1
FFF2BCEE  200e                              beq.b   loc_FFF2BCFC
FFF2BCF0  a901                              mov.l   20h+var_10[sp], r1
FFF2BCF2  6602                              mov.l   #0, r2
FFF2BCF4  058731ff                          bsr.a   sub_FFF1EE7B
FFF2BCF8  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2BCFA  2e13                              bra.b   loc_FFF2BD0D
FFF2BCFC  a983                   loc_FFF2BCFC mov.l   20h+var_8[sp], r3
FFF2BCFE  72310c10                          add     #100Ch, r3, r1
FFF2BD02  6602                              mov.l   #0, r2
FFF2BD04  391000                            bsr.w   sub_FFF2BD14
FFF2BD07  a089                              mov.l   r1, 20h+var_14[sp]
FFF2BD09  e5000301                          mov.l   20h+var_14[sp], 20h+var_1C[sp]
FFF2BD0D  a809                   loc_FFF2BD0D mov.l   20h+var_1C[sp], r1
FFF2BD0F  a109                              mov.l   r1, 20h+var_C[sp]
FFF2BD11  3f670a                            rtsd    #28h, r6-r7
FFF2BD14  7100d4                 sub_FFF2BD14 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF2BD14
FFF2BD17  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF2BD19  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF2BD1B  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF2BD1D  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2BD23  e4e003                            mov.l   [r14], 2Ch+var_20[sp]
FFF2BD26  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2BD28  cc1e                              mov.b   [r1], r14
FFF2BD2A  755e2f                            cmp     #2Fh, r14 ; '/'
FFF2BD2D  11                                beq.s   loc_FFF2BD36
FFF2BD2E  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2BD30  cc1e                              mov.b   [r1], r14
FFF2BD32  755e5c                            cmp     #5Ch, r14 ; '\'
FFF2BD35  1d                                bne.s   loc_FFF2BD3A
FFF2BD36  f80601                 loc_FFF2BD36 mov.l   #1, 2Ch+var_2C[sp]
FFF2BD39  0c                                bra.s   loc_FFF2BD3D
FFF2BD3A  f80600                 loc_FFF2BD3A mov.l   #0, 2Ch+var_2C[sp]
FFF2BD3D  ec01                   loc_FFF2BD3D mov.l   2Ch+var_2C[sp], r1
FFF2BD3F  6101                              cmp     #0, r1
FFF2BD41  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2BD43  201d                              beq.b   loc_FFF2BD60
FFF2BD45  aa03                              mov.l   2Ch+var_C[sp], r3
FFF2BD47  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF2BD49  397e00                            bsr.w   sub_FFF2BDC7
FFF2BD4C  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF2BD4E  058b9ffe                          bsr.a   sub_FFF15CD9
FFF2BD52  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF2BD54  a902                              mov.l   2Ch+var_1C[sp], r2
FFF2BD56  a909                              mov.l   2Ch+var_18[sp], r1
FFF2BD58  052331ff                          bsr.a   sub_FFF1EE7B
FFF2BD5C  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2BD5E  2e63                              bra.b   loc_FFF2BDC1
FFF2BD60  cc11                   loc_FFF2BD60 mov.b   [r1], r1
FFF2BD62  05292a00                          bsr.a   sub_FFF2E78B
FFF2BD66  8289                              mov.b   r1, 2Ch+var_21[sp]
FFF2BD68  b289                              movu.b  2Ch+var_21[sp], r1
FFF2BD6A  71020c                            add     #2Ch+var_20, sp, r2
FFF2BD6D  05b231ff                          bsr.a   sub_FFF1EF1F
FFF2BD71  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF2BD73  a909                              mov.l   2Ch+var_18[sp], r1
FFF2BD75  6101                              cmp     #0, r1
FFF2BD77  200e                              beq.b   loc_FFF2BD85
FFF2BD79  a909                              mov.l   2Ch+var_18[sp], r1
FFF2BD7B  6602                              mov.l   #0, r2
FFF2BD7D  05fe30ff                          bsr.a   sub_FFF1EE7B
FFF2BD81  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2BD83  2e3e                              bra.b   loc_FFF2BDC1
FFF2BD85  a889                   loc_FFF2BD85 mov.l   2Ch+var_20[sp], r1
FFF2BD87  05669ffe                          bsr.a   sub_FFF15CED
FFF2BD8B  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF2BD8D  a981                              mov.l   2Ch+var_14[sp], r1
FFF2BD8F  6101                              cmp     #0, r1
FFF2BD91  200f                              beq.b   loc_FFF2BDA0
FFF2BD93  6602                              mov.l   #0, r2
FFF2BD95  fb16db                            mov.l   #-25h, r1
FFF2BD98  05e330ff                          bsr.a   sub_FFF1EE7B
FFF2BD9C  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2BD9E  2e23                              bra.b   loc_FFF2BDC1
FFF2BDA0  aa03                   loc_FFF2BDA0 mov.l   2Ch+var_C[sp], r3
FFF2BDA2  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF2BDA4  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2BDA6  392100                            bsr.w   sub_FFF2BDC7
FFF2BDA9  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF2BDAB  052e9ffe                          bsr.a   sub_FFF15CD9
FFF2BDAF  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF2BDB1  a889                              mov.l   2Ch+var_20[sp], r1
FFF2BDB3  05459ffe                          bsr.a   sub_FFF15CF8
FFF2BDB7  a902                              mov.l   2Ch+var_1C[sp], r2
FFF2BDB9  a909                              mov.l   2Ch+var_18[sp], r1
FFF2BDBB  05c030ff                          bsr.a   sub_FFF1EE7B
FFF2BDBF  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2BDC1  a809                   loc_FFF2BDC1 mov.l   2Ch+var_28[sp], r1
FFF2BDC3  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF2BDC5  670b                              rtsd    #0Bh
FFF2BDC7  7ea6                   sub_FFF2BDC7 push.l  r6   ; <<<< FUNC sub_FFF2BDC7
FFF2BDC9  7100a0                            add     #-60h, sp, sp
FFF2BDCC  a589                              mov.l   r1, 60h+var_4[sp]
FFF2BDCE  a582                              mov.l   r2, 60h+var_8[sp]
FFF2BDD0  a50b                              mov.l   r3, 60h+var_C[sp]
FFF2BDD2  e5001610                          mov.l   60h+var_8[sp], 60h+var_20[sp]
FFF2BDD6  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2BDDC  e4e00f                            mov.l   [r14], 60h+var_24[sp]
FFF2BDDF  6601                              mov.l   #0, r1
FFF2BDE1  ef12                              mov.l   r1, r2
FFF2BDE3  059830ff                          bsr.a   sub_FFF1EE7B
FFF2BDE7  05ac9ffe                          bsr.a   sub_FFF15D93
FFF2BDEB  a089                              mov.l   r1, 60h+var_54[sp]
FFF2BDED  a889                              mov.l   60h+var_54[sp], r1
FFF2BDEF  6101                              cmp     #0, r1
FFF2BDF1  2010                              beq.b   loc_FFF2BE01
FFF2BDF3  6602                              mov.l   #0, r2
FFF2BDF5  fb16d5                            mov.l   #-2Bh, r1
FFF2BDF8  058330ff                          bsr.a   sub_FFF1EE7B
FFF2BDFC  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BDFE  38fe02                            bra.w   loc_FFF2C0FC
FFF2BE01  ac01                   loc_FFF2BE01 mov.l   60h+var_20[sp], r1
FFF2BE03  6101                              cmp     #0, r1
FFF2BE05  2154                              bne.b   loc_FFF2BE59
FFF2BE07  3e8200                            mov.l   #0, 60h+var_18[sp]
FFF2BE0A  fbe2285e0600                      mov.l   #65E28h, r14
FFF2BE10  e4e010                            mov.l   [r14], 60h+var_20[sp]
FFF2BE13  2e18                              bra.b   loc_FFF2BE2B
FFF2BE15  ac01                   loc_FFF2BE15 mov.l   60h+var_20[sp], r1
FFF2BE17  8911                              mov.b   4[r1], r1
FFF2BE19  6101                              cmp     #0, r1
FFF2BE1B  201e                              beq.b   loc_FFF2BE39
FFF2BE1D  ac81                              mov.l   60h+var_18[sp], r1
FFF2BE1F  6211                              add     #1, r1
FFF2BE21  a481                              mov.l   r1, 60h+var_18[sp]
FFF2BE23  ac01                              mov.l   60h+var_20[sp], r1
FFF2BE25  72114c02                          add     #24Ch, r1, r1
FFF2BE29  a401                              mov.l   r1, 60h+var_20[sp]
FFF2BE2B  fbe214250100           loc_FFF2BE2B mov.l   #12514h, r14
FFF2BE31  dcee                              mov.w   [r14], r14
FFF2BE33  06850e12                          cmp     60h+var_18[sp].l, r14
FFF2BE37  2ade                              bgt.b   loc_FFF2BE15
FFF2BE39  fbe214250100           loc_FFF2BE39 mov.l   #12514h, r14
FFF2BE3F  dcee                              mov.w   [r14], r14
FFF2BE41  06850e12                          cmp     60h+var_18[sp].l, r14
FFF2BE45  2114                              bne.b   loc_FFF2BE59
FFF2BE47  05579ffe                          bsr.a   sub_FFF15D9E
FFF2BE4B  6602                              mov.l   #0, r2
FFF2BE4D  fb16f1                            mov.l   #-0Fh, r1
FFF2BE50  052b30ff                          bsr.a   sub_FFF1EE7B
FFF2BE54  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BE56  38a602                            bra.w   loc_FFF2C0FC
FFF2BE59  ac01                   loc_FFF2BE59 mov.l   60h+var_20[sp], r1
FFF2BE5B  3c14ff                            mov.b   #-1, 4[r1]
FFF2BE5E  05409ffe                          bsr.a   sub_FFF15D9E
FFF2BE62  ab89                              mov.l   60h+var_24[sp], r1
FFF2BE64  ad9c                              mov.l   5Ch[r1], r4
FFF2BE66  754320                            mov.l   #20h, r3 ; ' '
FFF2BE69  6602                              mov.l   #0, r2
FFF2BE6B  71011c                            add     #60h+var_44, sp, r1
FFF2BE6E  05412600                          bsr.a   sub_FFF2E4AF
FFF2BE72  ab89                              mov.l   60h+var_24[sp], r1
FFF2BE74  6101                              cmp     #0, r1
FFF2BE76  2115                              bne.b   loc_FFF2BE8B
FFF2BE78  ac01                              mov.l   60h+var_20[sp], r1
FFF2BE7A  3c1400                            mov.b   #0, 4[r1]
FFF2BE7D  6602                              mov.l   #0, r2
FFF2BE7F  fb16ef                            mov.l   #-11h, r1
FFF2BE82  05f92fff                          bsr.a   sub_FFF1EE7B
FFF2BE86  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BE88  387402                            bra.w   loc_FFF2C0FC
FFF2BE8B  ad89                   loc_FFF2BE8B mov.l   60h+var_4[sp], r1
FFF2BE8D  cc1e                              mov.b   [r1], r14
FFF2BE8F  755e2f                            cmp     #2Fh, r14 ; '/'
FFF2BE92  11                                beq.s   loc_FFF2BE9B
FFF2BE93  ad89                              mov.l   60h+var_4[sp], r1
FFF2BE95  cc1e                              mov.b   [r1], r14
FFF2BE97  755e5c                            cmp     #5Ch, r14 ; '\'
FFF2BE9A  1d                                bne.s   loc_FFF2BE9F
FFF2BE9B  f80601                 loc_FFF2BE9B mov.l   #1, 60h+var_60[sp]
FFF2BE9E  0c                                bra.s   loc_FFF2BEA2
FFF2BE9F  f80600                 loc_FFF2BE9F mov.l   #0, 60h+var_60[sp]
FFF2BEA2  ec01                   loc_FFF2BEA2 mov.l   60h+var_60[sp], r1
FFF2BEA4  6101                              cmp     #0, r1
FFF2BEA6  201f                              beq.b   loc_FFF2BEC5
FFF2BEA8  ac01                              mov.l   60h+var_20[sp], r1
FFF2BEAA  3c1401                            mov.b   #1, 4[r1]
FFF2BEAD  ac01                              mov.l   60h+var_20[sp], r1
FFF2BEAF  3c1500                            mov.b   #0, 5[r1]
FFF2BEB2  ab89                              mov.l   60h+var_24[sp], r1
FFF2BEB4  ac02                              mov.l   60h+var_20[sp], r2
FFF2BEB6  e321                              mov.l   r1, [r2]
FFF2BEB8  ac02                              mov.l   60h+var_20[sp], r2
FFF2BEBA  6601                              mov.l   #0, r1
FFF2BEBC  05bf2fff                          bsr.a   sub_FFF1EE7B
FFF2BEC0  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BEC2  383a02                            bra.w   loc_FFF2C0FC
FFF2BEC5  ad89                   loc_FFF2BEC5 mov.l   60h+var_4[sp], r1
FFF2BEC7  cc11                              mov.b   [r1], r1
FFF2BEC9  05c22800                          bsr.a   sub_FFF2E78B
FFF2BECD  8289                              mov.b   r1, 60h+var_55[sp]
FFF2BECF  b289                              movu.b  60h+var_55[sp], r1
FFF2BED1  71023c                            add     #60h+var_24, sp, r2
FFF2BED4  054b30ff                          bsr.a   sub_FFF1EF1F
FFF2BED8  a489                              mov.l   r1, 60h+var_14[sp]
FFF2BEDA  ac89                              mov.l   60h+var_14[sp], r1
FFF2BEDC  6101                              cmp     #0, r1
FFF2BEDE  2014                              beq.b   loc_FFF2BEF2
FFF2BEE0  ac01                              mov.l   60h+var_20[sp], r1
FFF2BEE2  3c1400                            mov.b   #0, 4[r1]
FFF2BEE5  ac89                              mov.l   60h+var_14[sp], r1
FFF2BEE7  6602                              mov.l   #0, r2
FFF2BEE9  05922fff                          bsr.a   sub_FFF1EE7B
FFF2BEED  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BEEF  380d02                            bra.w   loc_FFF2C0FC
FFF2BEF2  ab89                   loc_FFF2BEF2 mov.l   60h+var_24[sp], r1
FFF2BEF4  056930ff                          bsr.a   sub_FFF1EF5D
FFF2BEF8  a489                              mov.l   r1, 60h+var_14[sp]
FFF2BEFA  ac89                              mov.l   60h+var_14[sp], r1
FFF2BEFC  6101                              cmp     #0, r1
FFF2BEFE  2014                              beq.b   loc_FFF2BF12
FFF2BF00  ac01                              mov.l   60h+var_20[sp], r1
FFF2BF02  3c1400                            mov.b   #0, 4[r1]
FFF2BF05  ac89                              mov.l   60h+var_14[sp], r1
FFF2BF07  6602                              mov.l   #0, r2
FFF2BF09  05722fff                          bsr.a   sub_FFF1EE7B
FFF2BF0D  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BF0F  38ed01                            bra.w   loc_FFF2C0FC
FFF2BF12  ad89                   loc_FFF2BF12 mov.l   60h+var_4[sp], r1
FFF2BF14  050e2700                          bsr.a   sub_FFF2E622
FFF2BF18  6131                              cmp     #3, r1
FFF2BF1A  245c                              bgtu.b  loc_FFF2BF76
FFF2BF1C  ac01                              mov.l   60h+var_20[sp], r1
FFF2BF1E  3c1401                            mov.b   #1, 4[r1]
FFF2BF21  ac01                              mov.l   60h+var_20[sp], r1
FFF2BF23  3d1300                            mov.w   #0, 6[r1]
FFF2BF26  ab89                              mov.l   60h+var_24[sp], r1
FFF2BF28  ac02                              mov.l   60h+var_20[sp], r2
FFF2BF2A  e321                              mov.l   r1, [r2]
FFF2BF2C  ab89                              mov.l   60h+var_24[sp], r1
FFF2BF2E  ac02                              mov.l   60h+var_20[sp], r2
FFF2BF30  e5120d02                          mov.l   34h[r1], 8[r2]
FFF2BF34  ac01                              mov.l   60h+var_20[sp], r1
FFF2BF36  3c1501                            mov.b   #1, 5[r1]
FFF2BF39  ab89                              mov.l   60h+var_24[sp], r1
FFF2BF3B  8c12                              mov.b   10h[r1], r2
FFF2BF3D  755220                            cmp     #20h, r2 ; ' '
FFF2BF40  ac06                              mov.l   60h+var_20[sp], r6
FFF2BF42  201d                              beq.b   loc_FFF2BF5F
FFF2BF44  ab8a                              mov.l   60h+var_24[sp], r2
FFF2BF46  a8ab                              mov.l   0Ch[r2], r3
FFF2BF48  06cd2304                          mul     8[r2].uw, r3
FFF2BF4C  06c91303                          add     6[r1].uw, r3
FFF2BF50  a0eb                              mov.l   r3, 0Ch[r6]
FFF2BF52  ac02                              mov.l   60h+var_20[sp], r2
FFF2BF54  6601                              mov.l   #0, r1
FFF2BF56  05252fff                          bsr.a   sub_FFF1EE7B
FFF2BF5A  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BF5C  38a001                            bra.w   loc_FFF2C0FC
FFF2BF5F  ac02                   loc_FFF2BF5F mov.l   60h+var_20[sp], r2
FFF2BF61  a8a2                              mov.l   8[r2], r2
FFF2BF63  054930ff                          bsr.a   sub_FFF1EFAC
FFF2BF67  a0e9                              mov.l   r1, 0Ch[r6]
FFF2BF69  ac02                              mov.l   60h+var_20[sp], r2
FFF2BF6B  6601                              mov.l   #0, r1
FFF2BF6D  050e2fff                          bsr.a   sub_FFF1EE7B
FFF2BF71  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BF73  388901                            bra.w   loc_FFF2C0FC
FFF2BF76  ad89                   loc_FFF2BF76 mov.l   60h+var_4[sp], r1
FFF2BF78  6221                              add     #2, r1
FFF2BF7A  a409                              mov.l   r1, 60h+var_1C[sp]
FFF2BF7C  ab89                              mov.l   60h+var_24[sp], r1
FFF2BF7E  e5100d06                          mov.l   34h[r1], 60h+var_48[sp]
FFF2BF82  ab89                              mov.l   60h+var_24[sp], r1
FFF2BF84  8c11                              mov.b   10h[r1], r1
FFF2BF86  755120                            cmp     #20h, r1 ; ' '
FFF2BF89  3a1101                            beq.w   loc_FFF2C09A
FFF2BF8C  ad0a                              mov.l   60h+var_C[sp], r2
FFF2BF8E  ac09                              mov.l   60h+var_1C[sp], r1
FFF2BF90  05f641ff                          bsr.a   sub_FFF20186
FFF2BF94  a409                              mov.l   r1, 60h+var_1C[sp]
FFF2BF96  ac09                              mov.l   60h+var_1C[sp], r1
FFF2BF98  6101                              cmp     #0, r1
FFF2BF9A  2115                              bne.b   loc_FFF2BFAF
FFF2BF9C  ac01                              mov.l   60h+var_20[sp], r1
FFF2BF9E  3c1400                            mov.b   #0, 4[r1]
FFF2BFA1  6602                              mov.l   #0, r2
FFF2BFA3  fb16ff                            mov.l   #-1, r1
FFF2BFA6  05d52eff                          bsr.a   sub_FFF1EE7B
FFF2BFAA  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BFAC  385001                            bra.w   loc_FFF2C0FC
FFF2BFAF  ad09                   loc_FFF2BFAF mov.l   60h+var_C[sp], r1
FFF2BFB1  cc1e                              mov.b   [r1], r14
FFF2BFB3  610e                              cmp     #0, r14
FFF2BFB5  2115                              bne.b   loc_FFF2BFCA
FFF2BFB7  ac01                              mov.l   60h+var_20[sp], r1
FFF2BFB9  3c1400                            mov.b   #0, 4[r1]
FFF2BFBC  6602                              mov.l   #0, r2
FFF2BFBE  fb16ff                            mov.l   #-1, r1
FFF2BFC1  05ba2eff                          bsr.a   sub_FFF1EE7B
FFF2BFC5  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BFC7  383501                            bra.w   loc_FFF2C0FC
FFF2BFCA  ad0a                   loc_FFF2BFCA mov.l   60h+var_C[sp], r2
FFF2BFCC  ab89                              mov.l   60h+var_24[sp], r1
FFF2BFCE  60c0                              sub     #0Ch, sp
FFF2BFD0  a082                              mov.l   r2, 6Ch+var_64[sp]
FFF2BFD2  71031c                            add     #6Ch+var_50, sp, r3
FFF2BFD5  a00b                              mov.l   r3, 6Ch+var_68[sp]
FFF2BFD7  f80400                            mov.b   #0, 6Ch+var_6C[sp]
FFF2BFDA  6604                              mov.l   #0, r4
FFF2BFDC  710328                            add     #6Ch+var_44, sp, r3
FFF2BFDF  05ac31ff                          bsr.a   sub_FFF1F18B
FFF2BFE3  62c0                              add     #0Ch, sp
FFF2BFE5  a489                              mov.l   r1, 60h+var_14[sp]
FFF2BFE7  ac89                              mov.l   60h+var_14[sp], r1
FFF2BFE9  6101                              cmp     #0, r1
FFF2BFEB  2015                              beq.b   loc_FFF2C000
FFF2BFED  ac01                              mov.l   60h+var_20[sp], r1
FFF2BFEF  3c1400                            mov.b   #0, 4[r1]
FFF2BFF2  6602                              mov.l   #0, r2
FFF2BFF4  fb16fc                            mov.l   #-4, r1
FFF2BFF7  05842eff                          bsr.a   sub_FFF1EE7B
FFF2BFFB  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2BFFD  38ff00                            bra.w   loc_FFF2C0FC
FFF2C000  ab89                   loc_FFF2C000 mov.l   60h+var_24[sp], r1
FFF2C002  8c12                              mov.b   10h[r1], r2
FFF2C004  71011c                            add     #60h+var_44, sp, r1
FFF2C007  059146ff                          bsr.a   sub_FFF20698
FFF2C00B  a181                              mov.l   r1, 60h+var_48[sp]
FFF2C00D  388d00                            bra.w   loc_FFF2C09A
FFF2C010  ad0a                   loc_FFF2C010 mov.l   60h+var_C[sp], r2
FFF2C012  ac09                              mov.l   60h+var_1C[sp], r1
FFF2C014  057241ff                          bsr.a   sub_FFF20186
FFF2C018  a409                              mov.l   r1, 60h+var_1C[sp]
FFF2C01A  ac09                              mov.l   60h+var_1C[sp], r1
FFF2C01C  6101                              cmp     #0, r1
FFF2C01E  2115                              bne.b   loc_FFF2C033
FFF2C020  ac01                              mov.l   60h+var_20[sp], r1
FFF2C022  3c1400                            mov.b   #0, 4[r1]
FFF2C025  6602                              mov.l   #0, r2
FFF2C027  fb16ff                            mov.l   #-1, r1
FFF2C02A  05512eff                          bsr.a   sub_FFF1EE7B
FFF2C02E  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2C030  38cc00                            bra.w   loc_FFF2C0FC
FFF2C033  ad09                   loc_FFF2C033 mov.l   60h+var_C[sp], r1
FFF2C035  cc1e                              mov.b   [r1], r14
FFF2C037  610e                              cmp     #0, r14
FFF2C039  2115                              bne.b   loc_FFF2C04E
FFF2C03B  ac01                              mov.l   60h+var_20[sp], r1
FFF2C03D  3c1400                            mov.b   #0, 4[r1]
FFF2C040  6602                              mov.l   #0, r2
FFF2C042  fb16ff                            mov.l   #-1, r1
FFF2C045  05362eff                          bsr.a   sub_FFF1EE7B
FFF2C049  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2C04B  38b100                            bra.w   loc_FFF2C0FC
FFF2C04E  ad0b                   loc_FFF2C04E mov.l   60h+var_C[sp], r3
FFF2C050  a982                              mov.l   60h+var_48[sp], r2
FFF2C052  ab89                              mov.l   60h+var_24[sp], r1
FFF2C054  7100f0                            add     #-10h, sp, sp
FFF2C057  a08b                              mov.l   r3, 70h+var_64[sp]
FFF2C059  710424                            add     #70h+var_4C, sp, r4
FFF2C05C  a084                              mov.l   r4, 70h+var_68[sp]
FFF2C05E  710420                            add     #70h+var_50, sp, r4
FFF2C061  a00c                              mov.l   r4, 70h+var_6C[sp]
FFF2C063  3c0100                            mov.b   #0, 70h+var_6F[sp]
FFF2C066  f80400                            mov.b   #0, 70h+var_70[sp]
FFF2C069  71042c                            add     #70h+var_44, sp, r4
FFF2C06C  05e636ff                          bsr.a   sub_FFF1F752
FFF2C070  710010                            add     #10h, sp, sp
FFF2C073  a489                              mov.l   r1, 60h+var_14[sp]
FFF2C075  ac89                              mov.l   60h+var_14[sp], r1
FFF2C077  6101                              cmp     #0, r1
FFF2C079  2014                              beq.b   loc_FFF2C08D
FFF2C07B  ac01                              mov.l   60h+var_20[sp], r1
FFF2C07D  3c1400                            mov.b   #0, 4[r1]
FFF2C080  6602                              mov.l   #0, r2
FFF2C082  fb16fc                            mov.l   #-4, r1
FFF2C085  05f62dff                          bsr.a   sub_FFF1EE7B
FFF2C089  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2C08B  2e71                              bra.b   loc_FFF2C0FC
FFF2C08D  ab89                   loc_FFF2C08D mov.l   60h+var_24[sp], r1
FFF2C08F  8c12                              mov.b   10h[r1], r2
FFF2C091  71011c                            add     #60h+var_44, sp, r1
FFF2C094  050446ff                          bsr.a   sub_FFF20698
FFF2C098  a181                              mov.l   r1, 60h+var_48[sp]
FFF2C09A  ac09                   loc_FFF2C09A mov.l   60h+var_1C[sp], r1
FFF2C09C  cc1e                              mov.b   [r1], r14
FFF2C09E  610e                              cmp     #0, r14
FFF2C0A0  3b70ff                            bne.w   loc_FFF2C010
FFF2C0A3  ab89                              mov.l   60h+var_24[sp], r1
FFF2C0A5  8c12                              mov.b   10h[r1], r2
FFF2C0A7  71011c                            add     #60h+var_44, sp, r1
FFF2C0AA  05ee45ff                          bsr.a   sub_FFF20698
FFF2C0AE  a181                              mov.l   r1, 60h+var_48[sp]
FFF2C0B0  f50427                            btst    #4, 60h+var_39[sp].b
FFF2C0B3  15                                beq.s   loc_FFF2C0B8
FFF2C0B4  f80600                            mov.l   #0, 60h+var_60[sp]
FFF2C0B7  0c                                bra.s   loc_FFF2C0BB
FFF2C0B8  f80601                 loc_FFF2C0B8 mov.l   #1, 60h+var_60[sp]
FFF2C0BB  ec01                   loc_FFF2C0BB mov.l   60h+var_60[sp], r1
FFF2C0BD  6101                              cmp     #0, r1
FFF2C0BF  ac01                              mov.l   60h+var_20[sp], r1
FFF2C0C1  2012                              beq.b   loc_FFF2C0D3
FFF2C0C3  3c1400                            mov.b   #0, 4[r1]
FFF2C0C6  6602                              mov.l   #0, r2
FFF2C0C8  fb16fc                            mov.l   #-4, r1
FFF2C0CB  05b02dff                          bsr.a   sub_FFF1EE7B
FFF2C0CF  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2C0D1  2e2b                              bra.b   loc_FFF2C0FC
FFF2C0D3  3c1501                 loc_FFF2C0D3 mov.b   #1, 5[r1]
FFF2C0D6  ac01                              mov.l   60h+var_20[sp], r1
FFF2C0D8  3c1401                            mov.b   #1, 4[r1]
FFF2C0DB  a981                              mov.l   60h+var_48[sp], r1
FFF2C0DD  ac02                              mov.l   60h+var_20[sp], r2
FFF2C0DF  a0a1                              mov.l   r1, 8[r2]
FFF2C0E1  a982                              mov.l   60h+var_48[sp], r2
FFF2C0E3  ab89                              mov.l   60h+var_24[sp], r1
FFF2C0E5  ac06                              mov.l   60h+var_20[sp], r6
FFF2C0E7  05c52eff                          bsr.a   sub_FFF1EFAC
FFF2C0EB  a0e9                              mov.l   r1, 0Ch[r6]
FFF2C0ED  ac01                              mov.l   60h+var_20[sp], r1
FFF2C0EF  3d1300                            mov.w   #0, 6[r1]
FFF2C0F2  ab89                              mov.l   60h+var_24[sp], r1
FFF2C0F4  ac02                              mov.l   60h+var_20[sp], r2
FFF2C0F6  e321                              mov.l   r1, [r2]
FFF2C0F8  e5001001                          mov.l   60h+var_20[sp], 60h+var_5C[sp]
FFF2C0FC  a809                   loc_FFF2C0FC mov.l   60h+var_5C[sp], r1
FFF2C0FE  a501                              mov.l   r1, 60h+var_10[sp]
FFF2C100  3f6619                            rtsd    #64h, r6-r6
FFF2C103  60c0                   sub_FFF2C103 sub     #0Ch, sp   ; <<<< FUNC sub_FFF2C103
FFF2C105  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF2C107  390b00                            bsr.w   sub_FFF2C112
FFF2C10A  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF2C10C  ec01                              mov.l   0Ch+var_C[sp], r1
FFF2C10E  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF2C110  6703                              rtsd    #3
FFF2C112  7100ec                 sub_FFF2C112 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2C112
FFF2C115  a101                              mov.l   r1, 14h+var_4[sp]
FFF2C117  a009                              mov.l   r1, 14h+var_10[sp]
FFF2C119  05d28eff                          bsr.a   sub_FFF24FEB
FFF2C11D  a081                              mov.l   r1, 14h+var_C[sp]
FFF2C11F  a881                              mov.l   14h+var_C[sp], r1
FFF2C121  6101                              cmp     #0, r1
FFF2C123  200e                              beq.b   loc_FFF2C131
FFF2C125  a881                              mov.l   14h+var_C[sp], r1
FFF2C127  6602                              mov.l   #0, r2
FFF2C129  05f72cff                          bsr.a   sub_FFF1EE20
FFF2C12D  e301                              mov.l   r1, 14h+var_14[sp]
FFF2C12F  2e2d                              bra.b   loc_FFF2C15C
FFF2C131  a809                   loc_FFF2C131 mov.l   14h+var_10[sp], r1
FFF2C133  05852dff                          bsr.a   sub_FFF1EEB8
FFF2C137  a081                              mov.l   r1, 14h+var_C[sp]
FFF2C139  a881                              mov.l   14h+var_C[sp], r1
FFF2C13B  6101                              cmp     #0, r1
FFF2C13D  200e                              beq.b   loc_FFF2C14B
FFF2C13F  a881                              mov.l   14h+var_C[sp], r1
FFF2C141  6602                              mov.l   #0, r2
FFF2C143  05dd2cff                          bsr.a   sub_FFF1EE20
FFF2C147  e301                              mov.l   r1, 14h+var_14[sp]
FFF2C149  2e13                              bra.b   loc_FFF2C15C
FFF2C14B  a901                   loc_FFF2C14B mov.l   14h+var_4[sp], r1
FFF2C14D  391500                            bsr.w   sub_FFF2C162
FFF2C150  a081                              mov.l   r1, 14h+var_C[sp]
FFF2C152  a881                              mov.l   14h+var_C[sp], r1
FFF2C154  6602                              mov.l   #0, r2
FFF2C156  05ca2cff                          bsr.a   sub_FFF1EE20
FFF2C15A  e301                              mov.l   r1, 14h+var_14[sp]
FFF2C15C  ec01                   loc_FFF2C15C mov.l   14h+var_14[sp], r1
FFF2C15E  a089                              mov.l   r1, 14h+var_8[sp]
FFF2C160  6705                              rtsd    #5
FFF2C162  60c0                   sub_FFF2C162 sub     #0Ch, sp   ; <<<< FUNC sub_FFF2C162
FFF2C164  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF2C166  8911                              mov.b   4[r1], r1
FFF2C168  6101                              cmp     #0, r1
FFF2C16A  1d                                bne.s   loc_FFF2C16F
FFF2C16B  f806f3                            mov.l   #-0Dh, 0Ch+var_C[sp]
FFF2C16E  09                                bra.s   loc_FFF2C177
FFF2C16F  a881                   loc_FFF2C16F mov.l   0Ch+var_4[sp], r1
FFF2C171  3c1400                            mov.b   #0, 4[r1]
FFF2C174  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF2C177  ec01                   loc_FFF2C177 mov.l   0Ch+var_C[sp], r1
FFF2C179  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF2C17B  6703                              rtsd    #3
FFF2C17D  7100ec                 sub_FFF2C17D add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2C17D
FFF2C180  a101                              mov.l   r1, 14h+var_4[sp]
FFF2C182  05149dfe                          bsr.a   sub_FFF15E96
FFF2C186  a009                              mov.l   r1, 14h+var_10[sp]
FFF2C188  a809                              mov.l   14h+var_10[sp], r1
FFF2C18A  6101                              cmp     #0, r1
FFF2C18C  210f                              bne.b   loc_FFF2C19B
FFF2C18E  6602                              mov.l   #0, r2
FFF2C190  fb16e1                            mov.l   #-1Fh, r1
FFF2C193  05e82cff                          bsr.a   sub_FFF1EE7B
FFF2C197  e301                              mov.l   r1, 14h+var_14[sp]
FFF2C199  2e14                              bra.b   loc_FFF2C1AD
FFF2C19B  a80a                   loc_FFF2C19B mov.l   14h+var_10[sp], r2
FFF2C19D  a901                              mov.l   14h+var_4[sp], r1
FFF2C19F  391400                            bsr.w   sub_FFF2C1B3
FFF2C1A2  a081                              mov.l   r1, 14h+var_C[sp]
FFF2C1A4  a809                              mov.l   14h+var_10[sp], r1
FFF2C1A6  05009dfe                          bsr.a   sub_FFF15EA6
FFF2C1AA  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2C1AD  ec01                   loc_FFF2C1AD mov.l   14h+var_14[sp], r1
FFF2C1AF  a089                              mov.l   r1, 14h+var_8[sp]
FFF2C1B1  6705                              rtsd    #5
FFF2C1B3  7100e4                 sub_FFF2C1B3 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2C1B3
FFF2C1B6  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2C1B8  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2C1BA  e5000601                          mov.l   1Ch+var_4[sp], 1Ch+var_18[sp]
FFF2C1BE  052d8eff                          bsr.a   sub_FFF24FEB
FFF2C1C2  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2C1C4  a889                              mov.l   1Ch+var_10[sp], r1
FFF2C1C6  6101                              cmp     #0, r1
FFF2C1C8  200e                              beq.b   loc_FFF2C1D6
FFF2C1CA  a889                              mov.l   1Ch+var_10[sp], r1
FFF2C1CC  6602                              mov.l   #0, r2
FFF2C1CE  05ad2cff                          bsr.a   sub_FFF1EE7B
FFF2C1D2  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2C1D4  2e28                              bra.b   loc_FFF2C1FC
FFF2C1D6  a809                   loc_FFF2C1D6 mov.l   1Ch+var_18[sp], r1
FFF2C1D8  05e02cff                          bsr.a   sub_FFF1EEB8
FFF2C1DC  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2C1DE  a889                              mov.l   1Ch+var_10[sp], r1
FFF2C1E0  6101                              cmp     #0, r1
FFF2C1E2  200e                              beq.b   loc_FFF2C1F0
FFF2C1E4  a889                              mov.l   1Ch+var_10[sp], r1
FFF2C1E6  6602                              mov.l   #0, r2
FFF2C1E8  05932cff                          bsr.a   sub_FFF1EE7B
FFF2C1EC  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2C1EE  2e0e                              bra.b   loc_FFF2C1FC
FFF2C1F0  a90a                   loc_FFF2C1F0 mov.l   1Ch+var_8[sp], r2
FFF2C1F2  a981                              mov.l   1Ch+var_4[sp], r1
FFF2C1F4  390e00                            bsr.w   sub_FFF2C202
FFF2C1F7  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2C1F9  e10002                            mov.l   1Ch+var_14[sp], 1Ch+var_1C[sp]
FFF2C1FC  ec01                   loc_FFF2C1FC mov.l   1Ch+var_1C[sp], r1
FFF2C1FE  a101                              mov.l   r1, 1Ch+var_C[sp]

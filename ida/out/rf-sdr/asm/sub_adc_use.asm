; window adc_use file 315000-3152C0 map FFF15000-FFF152C0 forced 219
; ==== adc_use  FFF15000-FFF152C0 ====
FFF15000  02                                rts
FFF15001  01                                .byte    1
FFF15002  d5000103                          mov.w   2[sp], 6[sp]
FFF15006  b889                              movu.w  6[sp], r1
FFF15008  6702                              rtsd    #2
FFF1500A  60c0                              sub     #0Ch, sp
FFF1500C  a081                              mov.l   r1, 8[sp]
FFF1500E  3d0200                            mov.w   #0, 4[sp]
FFF15011  fbe2b8930600                      mov.l   #693B8h, r14
FFF15017  5cee                              movu.w  [r14], r14
FFF15019  613e                              cmp     #3, r14
FFF1501B  18                                bne.s   loc_FFF15023
FFF1501C  f90901ffff                        mov.w   #-1, 2[sp]
FFF15021  2e2c                              bra.b   loc_FFF1504D
FFF15023  fbe2b8930600             loc_FFF15023 mov.l   #693B8h, r14
FFF15029  a881                              mov.l   8[sp], r1
FFF1502B  d0e1                              mov.w   [r14], [r1]
FFF1502D  a881                              mov.l   8[sp], r1
FFF1502F  fb22b8930600                      mov.l   #693B8h, r2
FFF15035  6222                              add     #2, r2
FFF15037  6221                              add     #2, r1
FFF15039  05170503                          bsr.a   sub_FFF45550
FFF1503D  fbe2b8930600                      mov.l   #693B8h, r14
FFF15043  a881                              mov.l   8[sp], r1
FFF15045  e5e14141                          mov.l   104h[r14], 104h[r1]
FFF15049  d5000201                          mov.w   4[sp], 2[sp]
FFF1504D  d5000103                 loc_FFF1504D mov.w   2[sp], 6[sp]
FFF15051  b889                              movu.w  6[sp], r1
FFF15053  6703                              rtsd    #3
FFF15055  fbee100008               loc_FFF15055 mov.l   #80010h, r14
FFF1505A  ecef                              mov.l   [r14], r15
FFF1505C  7b3f                              bclr    #13h, r15
FFF1505E  e3ef                              mov.l   r15, [r14]
FFF15060  fbee458008                        mov.l   #88045h, r14
FFF15065  f8e400                            mov.b   #0, [r14]
FFF15068  fb1e458008                        mov.l   #88045h, r1
FFF1506D  3c1100                            mov.b   #0, 1[r1]
FFF15070  fbee00c008                        mov.l   #8C000h, r14
FFF15075  f1eb60                            bclr    #3, 60h[r14].b
FFF15078  fbee00c008                        mov.l   #8C000h, r14
FFF1507D  f0eb                              bclr    #3, [r14].b
FFF1507F  fbee43c108                        mov.l   #8C143h, r14
FFF15084  f0e7                              bset    #7, [r14].b
FFF15086  02                                rts
FFF15087  fbee867008               loc_FFF15087 mov.l   #87086h, r14
FFF1508C  f2e29401                          bset    #2, 194h[r14].b
FFF15090  fbee801a0c                        mov.l   #0C1A80h, r14
FFF15095  f0e6                              bset    #6, [r14].b
FFF15097  fbee009008                        mov.l   #89000h, r14
FFF1509C  5cef                              movu.w  [r14], r15
FFF1509E  762fff7f                          and     #7FFFh, r15
FFF150A2  d3ef                              mov.w   r15, [r14]
FFF150A4  fbee867008                        mov.l   #87086h, r14
FFF150A9  f2ee8a01                          bclr    #6, 18Ah[r14].b
FFF150AD  fbee867008                        mov.l   #87086h, r14
FFF150B2  f0e8                              bclr    #0, [r14].b
FFF150B4  fbee867008                        mov.l   #87086h, r14
FFF150B9  72eeee05                          add     #5EEh, r14, r14
FFF150BD  ecef                              mov.l   [r14], r15
FFF150BF  7b4f                              bclr    #14h, r15
FFF150C1  e3ef                              mov.l   r15, [r14]
FFF150C3  fbee448008                        mov.l   #88044h, r14
FFF150C8  f0ed                              bclr    #5, [r14].b
FFF150CA  fbee448008                        mov.l   #88044h, r14
FFF150CF  f0e6                              bset    #6, [r14].b
FFF150D1  02                                rts
FFF150D2  6040                     loc_FFF150D2 sub     #4, sp
FFF150D4  fb1a0008                          mov.l   #800h, r1
FFF150D8  397d00                            bsr.w   sub_FFF15155
FFF150DB  fbee867008                        mov.l   #87086h, r14
FFF150E0  f2ea9401                          bclr    #2, 194h[r14].b
FFF150E4  fbee801a0c                        mov.l   #0C1A80h, r14
FFF150E9  f0ee                              bclr    #6, [r14].b
FFF150EB  fbe20a250100                      mov.l   #1250Ah, r14
FFF150F1  5cee                              movu.w  [r14], r14
FFF150F3  611e                              cmp     #1, r14
FFF150F5  200d                              beq.b   loc_FFF15102
FFF150F7  fb120a250100                      mov.l   #1250Ah, r1
FFF150FD  b819                              movu.w  2[r1], r1
FFF150FF  6111                              cmp     #1, r1
FFF15101  1d                                bne.s   loc_FFF15106
FFF15102  f80601                   loc_FFF15102 mov.l   #1, [sp]
FFF15105  0c                                bra.s   loc_FFF15109
FFF15106  f80600                   loc_FFF15106 mov.l   #0, [sp]
FFF15109  ec01                     loc_FFF15109 mov.l   [sp], r1
FFF1510B  6101                              cmp     #0, r1
FFF1510D  210d                              bne.b   loc_FFF1511A
FFF1510F  fb120a250100                      mov.l   #1250Ah, r1
FFF15115  b891                              movu.w  4[r1], r1
FFF15117  6111                              cmp     #1, r1
FFF15119  1d                                bne.s   loc_FFF1511E
FFF1511A  f80601                   loc_FFF1511A mov.l   #1, [sp]
FFF1511D  0c                                bra.s   loc_FFF15121
FFF1511E  f80600                   loc_FFF1511E mov.l   #0, [sp]
FFF15121  ec01                     loc_FFF15121 mov.l   [sp], r1
FFF15123  6101                              cmp     #0, r1
FFF15125  202e                              beq.b   loc_FFF15153
FFF15127  fbee867008                        mov.l   #87086h, r14
FFF1512C  f0e8                              bclr    #0, [r14].b
FFF1512E  fbee867008                        mov.l   #87086h, r14
FFF15133  f2e68a01                          bset    #6, 18Ah[r14].b
FFF15137  fbee867008                        mov.l   #87086h, r14
FFF1513C  72eeee05                          add     #5EEh, r14, r14
FFF15140  ecef                              mov.l   [r14], r15
FFF15142  794f                              bset    #14h, r15
FFF15144  e3ef                              mov.l   r15, [r14]
FFF15146  fbee009008                        mov.l   #89000h, r14
FFF1514B  dcef                              mov.w   [r14], r15
FFF1514D  78ff                              bset    #0Fh, r15
FFF1514F  d3ef                              mov.w   r15, [r14]
FFF15151  6701                              rtsd    #1
FFF15153  6701                     loc_FFF15153 rtsd    #1
FFF15155  6040                     sub_FFF15155 sub     #4, sp  ; <<< FUNC sub_FFF15155
FFF15157  9009                              mov.w   r1, 4+var_2[sp]
FFF15159  b809                              movu.w  4+var_2[sp], r1
FFF1515B  7621ff0f                          and     #0FFFh, r1
FFF1515F  fbee408008                        mov.l   #88040h, r14
FFF15164  d3e1                              mov.w   r1, [r14]
FFF15166  6701                              rtsd    #1
FFF15168  fbee80120c               loc_FFF15168 mov.l   #0C1280h, r14
FFF1516D  f1e004                            bset    #0, 4[r14].b
FFF15170  fbee80120c                        mov.l   #0C1280h, r14
FFF15175  f2e00408                          bset    #0, 804h[r14].b
FFF15179  fbee80120c                        mov.l   #0C1280h, r14
FFF1517E  f8e400                            mov.b   #0, [r14]
FFF15181  fbeeb41c0c                        mov.l   #0C1CB4h, r14
FFF15186  f8e400                            mov.b   #0, [r14]
FFF15189  fbee80120c                        mov.l   #0C1280h, r14
FFF1518E  fae4000800                        mov.b   #0, 800h[r14]
FFF15193  fbeed27308                        mov.l   #873D2h, r14
FFF15198  fae400061e                        mov.b   #1Eh, 600h[r14]
FFF1519D  fbeed27308                        mov.l   #873D2h, r14
FFF151A2  58ef                              movu.b  [r14], r15
FFF151A4  65ff                              or      #0Fh, r15
FFF151A6  c3ef                              mov.b   r15, [r14]
FFF151A8  fbee80120c                        mov.l   #0C1280h, r14
FFF151AD  f2ee0108                          bclr    #6, 801h[r14].b
FFF151B1  fbee001a0c                        mov.l   #0C1A00h, r14
FFF151B6  f8e420                            mov.b   #20h, [r14] ; ' '
FFF151B9  fbee001a0c                        mov.l   #0C1A00h, r14
FFF151BE  f9e44c00                          mov.b   #0, 4Ch[r14]
FFF151C2  fb1e001a0c                        mov.l   #0C1A00h, r1
FFF151C7  3c1881                            mov.b   #-7Fh, 8[r1]
FFF151CA  fb1e001a0c                        mov.l   #0C1A00h, r1
FFF151CF  3c1200                            mov.b   #0, 2[r1]
FFF151D2  fb1e001a0c                        mov.l   #0C1A00h, r1
FFF151D7  3c1400                            mov.b   #0, 4[r1]
FFF151DA  fb1e001a0c                        mov.l   #0C1A00h, r1
FFF151DF  3c1500                            mov.b   #0, 5[r1]
FFF151E2  fbee001a0c                        mov.l   #0C1A00h, r14
FFF151E7  f9e90cb70b                        mov.w   #0BB7h, 18h[r14]
FFF151EC  fbee001a0c                        mov.l   #0C1A00h, r14
FFF151F1  f9e90db70b                        mov.w   #0BB7h, 1Ah[r14]
FFF151F6  fbee001a0c                        mov.l   #0C1A00h, r14
FFF151FB  f9e912b70b                        mov.w   #0BB7h, 24h[r14]
FFF15200  fbee001a0c                        mov.l   #0C1A00h, r14
FFF15205  f9e913b70b                        mov.w   #0BB7h, 26h[r14]
FFF1520A  fbee80120c                        mov.l   #0C1280h, r14
FFF1520F  f1e804                            bclr    #0, 4[r14].b
FFF15212  fbee80120c                        mov.l   #0C1280h, r14
FFF15217  f2e80408                          bclr    #0, 804h[r14].b
FFF1521B  02                                rts
FFF1521C  fbee1a7208               loc_FFF1521C mov.l   #8721Ah, r14
FFF15221  f0e2                              bset    #2, [r14].b
FFF15223  fbee801a0c                        mov.l   #0C1A80h, r14
FFF15228  f0e6                              bset    #6, [r14].b
FFF1522A  02                                rts
FFF1522B  6040                     loc_FFF1522B sub     #4, sp
FFF1522D  fbe20a250100                      mov.l   #1250Ah, r14
FFF15233  5cee                              movu.w  [r14], r14
FFF15235  610e                              cmp     #0, r14
FFF15237  2111                              bne.b   loc_FFF15248
FFF15239  fb120a250100                      mov.l   #1250Ah, r1
FFF1523F  b819                              movu.w  2[r1], r1
FFF15241  6101                              cmp     #0, r1
FFF15243  1d                                bne.s   loc_FFF15248
FFF15244  f80601                            mov.l   #1, [sp]
FFF15247  0c                                bra.s   loc_FFF1524B
FFF15248  f80600                   loc_FFF15248 mov.l   #0, [sp]
FFF1524B  ec01                     loc_FFF1524B mov.l   [sp], r1
FFF1524D  6101                              cmp     #0, r1
FFF1524F  2011                              beq.b   loc_FFF15260
FFF15251  fb120a250100                      mov.l   #1250Ah, r1
FFF15257  b891                              movu.w  4[r1], r1
FFF15259  6101                              cmp     #0, r1
FFF1525B  1d                                bne.s   loc_FFF15260
FFF1525C  f80601                            mov.l   #1, [sp]
FFF1525F  0c                                bra.s   loc_FFF15263
FFF15260  f80600                   loc_FFF15260 mov.l   #0, [sp]
FFF15263  ec01                     loc_FFF15263 mov.l   [sp], r1
FFF15265  6101                              cmp     #0, r1
FFF15267  2012                              beq.b   loc_FFF15279
FFF15269  fbee1a7208                        mov.l   #8721Ah, r14
FFF1526E  f0ea                              bclr    #2, [r14].b
FFF15270  fbee801a0c                        mov.l   #0C1A80h, r14
FFF15275  f0ee                              bclr    #6, [r14].b
FFF15277  6701                              rtsd    #1
FFF15279  6701                     loc_FFF15279 rtsd    #1
FFF1527B  6eef                     loc_FFF1527B pushm   r14-r15
FFF1527D  6e15                              pushm   r1-r5
FFF1527F  7100e0                            add     #-20h, sp, sp
FFF15282  3c8f00                            mov.b   #0, 1Fh[sp]
FFF15285  3c8e00                            mov.b   #0, 1Eh[sp]
FFF15288  3d0e00                            mov.w   #0, 1Ch[sp]
FFF1528B  3d0d00                            mov.w   #0, 1Ah[sp]
FFF1528E  fb1278020200                      mov.l   #20278h, r1
FFF15294  5c11                              movu.w  [r1], r1
FFF15296  6111                              cmp     #1, r1
FFF15298  3ba703                            bne.w   loc_FFF1563F
FFF1529B  fb1278020200                      mov.l   #20278h, r1
FFF152A1  5d118a                            movu.w  114h[r1], r1
FFF152A4  6121                              cmp     #2, r1
FFF152A6  3ac701                            beq.w   loc_FFF1546D
FFF152A9  6111                              cmp     #1, r1
FFF152AB  3b9403                            bne.w   loc_FFF1563F
FFF152AE  fb1278020200                      mov.l   #20278h, r1
FFF152B4  5d1190                            movu.w  120h[r1], r1
FFF152B7  6111                              cmp     #1, r1
FFF152B9  3b8603                            bne.w   loc_FFF1563F
FFF152BC  fb1278020200                      mov.l   #20278h, r1

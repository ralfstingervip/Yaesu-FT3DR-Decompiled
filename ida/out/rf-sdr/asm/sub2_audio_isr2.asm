; ==== audio_isr2  FFF15280-FFF15600 ====
FFF15280  00                                brk
FFF15281  e03c                              mov.l   [r3], [r12]
FFF15283  8f00                              mov.b   1Ch[sp], sp
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
FFF152C2  ed1146                            mov.l   118h[r1], r1
FFF152C5  6101                              cmp     #0, r1
FFF152C7  2174                              bne.b   loc_FFF1533B
FFF152C9  fb1278020200                      mov.l   #20278h, r1
FFF152CF  ed1243                            mov.l   10Ch[r1], r2
FFF152D2  06851242                          cmp     108h[r1].l, r2
FFF152D6  2265                              bgeu.b  loc_FFF1533B
FFF152D8  f80500                            mov.w   #0, [sp]
FFF152DB  fb1278020200                      mov.l   #20278h, r1
FFF152E1  6261                              add     #6, r1
FFF152E3  a009                              mov.l   r1, 4[sp]
FFF152E5  fb1278020200                      mov.l   #20278h, r1
FFF152EB  e5104202                          mov.l   108h[r1], 8[sp]
FFF152EF  fb1278020200                      mov.l   #20278h, r1
FFF152F5  ed1243                            mov.l   10Ch[r1], r2
FFF152F8  06891247                          add     11Ch[r1].l, r2
FFF152FC  a102                              mov.l   r2, 10h[sp]
FFF152FE  fb1278020200                      mov.l   #20278h, r1
FFF15304  73112e8101                        add     #1812Eh, r1, r1
FFF15309  a089                              mov.l   r1, 0Ch[sp]
FFF1530B  fb1278020200                      mov.l   #20278h, r1
FFF15311  fa1596c000                        mov.w   #0, 1812Ch[r1]
FFF15316  fb1278020200                      mov.l   #20278h, r1
FFF1531C  73113a0103                        add     #3013Ah, r1, r1
FFF15321  5c11                              movu.w  [r1], r1
FFF15323  6101                              cmp     #0, r1
FFF15325  2116                              bne.b   loc_FFF1533B
FFF15327  7100ec                            add     #-14h, sp, sp
FFF1532A  754314                            mov.l   #14h, r3
FFF1532D  710214                            add     #14h, sp, r2
FFF15330  ef01                              mov.l   sp, r1
FFF15332  7f8f                              smovf
FFF15334  0545edff                          bsr.a   sub_FFF14079
FFF15338  710014                            add     #14h, sp, sp
FFF1533B  fb1278020200             loc_FFF1533B mov.l   #20278h, r1
FFF15341  ed1246                            mov.l   118h[r1], r2
FFF15344  06851247                          cmp     11Ch[r1].l, r2
FFF15348  223a                              bgeu.b  loc_FFF15382
FFF1534A  fb1278020200                      mov.l   #20278h, r1
FFF15350  06891146                          add     118h[r1].l, r1
FFF15354  c61022011f                        mov.b   122h[r1], 1Fh[sp]
FFF15359  fb1278020200                      mov.l   #20278h, r1
FFF1535F  ed1246                            mov.l   118h[r1], r2
FFF15362  6212                              add     #1, r2
FFF15364  e71246                            mov.l   r2, 118h[r1]
FFF15367  fb1278020200                      mov.l   #20278h, r1
FFF1536D  ed1243                            mov.l   10Ch[r1], r2
FFF15370  6212                              add     #1, r2
FFF15372  e71243                            mov.l   r2, 10Ch[r1]
FFF15375  fb1278020200                      mov.l   #20278h, r1
FFF1537B  ed1143                            mov.l   10Ch[r1], r1
FFF1537E  05522202                          bsr.a   sub_FFF375D0
FFF15382  fb1278020200             loc_FFF15382 mov.l   #20278h, r1
FFF15388  ed1246                            mov.l   118h[r1], r2
FFF1538B  06851247                          cmp     11Ch[r1].l, r2
FFF1538F  223a                              bgeu.b  loc_FFF153C9
FFF15391  fb1278020200                      mov.l   #20278h, r1
FFF15397  06891146                          add     118h[r1].l, r1
FFF1539B  c61022011e                        mov.b   122h[r1], 1Eh[sp]
FFF153A0  fb1278020200                      mov.l   #20278h, r1
FFF153A6  ed1246                            mov.l   118h[r1], r2
FFF153A9  6212                              add     #1, r2
FFF153AB  e71246                            mov.l   r2, 118h[r1]
FFF153AE  fb1278020200                      mov.l   #20278h, r1
FFF153B4  ed1243                            mov.l   10Ch[r1], r2
FFF153B7  6212                              add     #1, r2
FFF153B9  e71243                            mov.l   r2, 10Ch[r1]
FFF153BC  fb1278020200                      mov.l   #20278h, r1
FFF153C2  ed1143                            mov.l   10Ch[r1], r1
FFF153C5  050b2202                          bsr.a   sub_FFF375D0
FFF153C9  b781                     loc_FFF153C9 movu.b  1Eh[sp], r1
FFF153CB  6c81                              shll    #8, r1
FFF153CD  55011f                            or      1Fh[sp], r1
FFF153D0  9381                              mov.w   r1, 1Ch[sp]
FFF153D2  bb81                              movu.w  1Ch[sp], r1
FFF153D4  6281                              add     #8, r1
FFF153D6  6a41                              shar    #4, r1
FFF153D8  72110008                          add     #800h, r1, r1
FFF153DC  9309                              mov.w   r1, 1Ah[sp]
FFF153DE  bb09                              movu.w  1Ah[sp], r1
FFF153E0  3975fd                            bsr.w   sub_FFF15155
FFF153E3  fb1278020200                      mov.l   #20278h, r1
FFF153E9  ed1246                            mov.l   118h[r1], r2
FFF153EC  06851247                          cmp     11Ch[r1].l, r2
FFF153F0  2205                              bgeu.b  loc_FFF153F5
FFF153F2  384d02                            bra.w   loc_FFF1563F
FFF153F5  fb1278020200             loc_FFF153F5 mov.l   #20278h, r1
FFF153FB  f9164600                          mov.l   #0, 118h[r1]
FFF153FF  fb1278020200                      mov.l   #20278h, r1
FFF15405  f9164700                          mov.l   #0, 11Ch[r1]
FFF15409  fb2278020200                      mov.l   #20278h, r2
FFF1540F  ed2143                            mov.l   10Ch[r2], r1
FFF15412  06852142                          cmp     108h[r2].l, r1
FFF15416  2335                              bltu.b  loc_FFF1544B
FFF15418  05b82102                          bsr.a   sub_FFF375D0
FFF1541C  3908f4                            bsr.w   sub_FFF14824
FFF1541F  fb1278020200                      mov.l   #20278h, r1
FFF15425  e6104cc005                        mov.l   30130h[r1], 14h[sp]
FFF1542A  a909                              mov.l   14h[sp], r1
FFF1542C  6101                              cmp     #0, r1
FFF1542E  17                                beq.s   loc_FFF15435
FFF1542F  a90a                              mov.l   14h[sp], r2
FFF15431  6611                              mov.l   #1, r1
FFF15433  7f12                              jsr     r2
FFF15435  fb1278020200             loc_FFF15435 mov.l   #20278h, r1
FFF1543B  ed1143                            mov.l   10Ch[r1], r1
FFF1543E  05922102                          bsr.a   sub_FFF375D0
FFF15442  710020                            add     #20h, sp, sp ; ' '
FFF15445  6f15                              popm    r1-r5
FFF15447  6fef                              popm    r14-r15
FFF15449  7f95                              rte
FFF1544B  fb2278020200             loc_FFF1544B mov.l   #20278h, r2
FFF15451  06852142                          cmp     108h[r2].l, r1
FFF15455  2305                              bltu.b  loc_FFF1545A
FFF15457  38e801                            bra.w   loc_FFF1563F
FFF1545A  fb1278020200             loc_FFF1545A mov.l   #20278h, r1
FFF15460  f9158a02                          mov.w   #2, 114h[r1]
FFF15464  710020                            add     #20h, sp, sp ; ' '
FFF15467  6f15                              popm    r1-r5
FFF15469  6fef                              popm    r14-r15
FFF1546B  7f95                              rte
FFF1546D  fb1278020200             loc_FFF1546D mov.l   #20278h, r1
FFF15473  5e1196c0                          movu.w  1812Ch[r1], r1
FFF15477  6111                              cmp     #1, r1
FFF15479  3bc601                            bne.w   loc_FFF1563F
FFF1547C  fb1278020200                      mov.l   #20278h, r1
FFF15482  ee114960                          mov.l   18124h[r1], r1
FFF15486  6101                              cmp     #0, r1
FFF15488  2173                              bne.b   loc_FFF154FB
FFF1548A  fb1278020200                      mov.l   #20278h, r1
FFF15490  ed1243                            mov.l   10Ch[r1], r2
FFF15493  06851242                          cmp     108h[r1].l, r2
FFF15497  2264                              bgeu.b  loc_FFF154FB
FFF15499  f80500                            mov.w   #0, [sp]
FFF1549C  fb1278020200                      mov.l   #20278h, r1
FFF154A2  6261                              add     #6, r1
FFF154A4  a009                              mov.l   r1, 4[sp]
FFF154A6  fb1278020200                      mov.l   #20278h, r1
FFF154AC  e5104202                          mov.l   108h[r1], 8[sp]
FFF154B0  fb1278020200                      mov.l   #20278h, r1
FFF154B6  ee124a60                          mov.l   18128h[r1], r2
FFF154BA  06891243                          add     10Ch[r1].l, r2
FFF154BE  a102                              mov.l   r2, 10h[sp]
FFF154C0  fb1278020200                      mov.l   #20278h, r1
FFF154C6  72112201                          add     #122h, r1, r1
FFF154CA  a089                              mov.l   r1, 0Ch[sp]
FFF154CC  fb1278020200                      mov.l   #20278h, r1
FFF154D2  f9159000                          mov.w   #0, 120h[r1]
FFF154D6  fb1278020200                      mov.l   #20278h, r1
FFF154DC  73113a0103                        add     #3013Ah, r1, r1
FFF154E1  5c11                              movu.w  [r1], r1
FFF154E3  6101                              cmp     #0, r1
FFF154E5  2116                              bne.b   loc_FFF154FB
FFF154E7  7100ec                            add     #-14h, sp, sp
FFF154EA  754314                            mov.l   #14h, r3
FFF154ED  710214                            add     #14h, sp, r2
FFF154F0  ef01                              mov.l   sp, r1
FFF154F2  7f8f                              smovf
FFF154F4  0585ebff                          bsr.a   sub_FFF14079
FFF154F8  710014                            add     #14h, sp, sp
FFF154FB  fb1278020200             loc_FFF154FB mov.l   #20278h, r1
FFF15501  ee124960                          mov.l   18124h[r1], r2
FFF15505  0686124a60                        cmp     18128h[r1].l, r2
FFF1550A  2242                              bgeu.b  loc_FFF1554C
FFF1550C  fb1278020200                      mov.l   #20278h, r1
FFF15512  068a114960                        add     18124h[r1].l, r1
FFF15517  fb2e2e8101                        mov.l   #1812Eh, r2
FFF1551C  fec121                            movu.b  [r1, r2], r1
FFF1551F  8789                              mov.b   r1, 1Fh[sp]
FFF15521  fb1278020200                      mov.l   #20278h, r1
FFF15527  ee124960                          mov.l   18124h[r1], r2
FFF1552B  6212                              add     #1, r2
FFF1552D  eb124960                          mov.l   r2, 18124h[r1]
FFF15531  fb1278020200                      mov.l   #20278h, r1
FFF15537  ed1243                            mov.l   10Ch[r1], r2
FFF1553A  6212                              add     #1, r2
FFF1553C  e71243                            mov.l   r2, 10Ch[r1]
FFF1553F  fb1278020200                      mov.l   #20278h, r1
FFF15545  ed1143                            mov.l   10Ch[r1], r1
FFF15548  05882002                          bsr.a   sub_FFF375D0
FFF1554C  fb1278020200             loc_FFF1554C mov.l   #20278h, r1
FFF15552  ee124960                          mov.l   18124h[r1], r2
FFF15556  0686124a60                        cmp     18128h[r1].l, r2
FFF1555B  2242                              bgeu.b  loc_FFF1559D
FFF1555D  fb1278020200                      mov.l   #20278h, r1
FFF15563  068a114960                        add     18124h[r1].l, r1
FFF15568  fb2e2e8101                        mov.l   #1812Eh, r2
FFF1556D  fec121                            movu.b  [r1, r2], r1
FFF15570  8781                              mov.b   r1, 1Eh[sp]
FFF15572  fb1278020200                      mov.l   #20278h, r1
FFF15578  ee124960                          mov.l   18124h[r1], r2
FFF1557C  6212                              add     #1, r2
FFF1557E  eb124960                          mov.l   r2, 18124h[r1]
FFF15582  fb1278020200                      mov.l   #20278h, r1
FFF15588  ed1243                            mov.l   10Ch[r1], r2
FFF1558B  6212                              add     #1, r2
FFF1558D  e71243                            mov.l   r2, 10Ch[r1]
FFF15590  fb1278020200                      mov.l   #20278h, r1
FFF15596  ed1143                            mov.l   10Ch[r1], r1
FFF15599  05372002                          bsr.a   sub_FFF375D0
FFF1559D  b781                     loc_FFF1559D movu.b  1Eh[sp], r1
FFF1559F  6c81                              shll    #8, r1
FFF155A1  55011f                            or      1Fh[sp], r1
FFF155A4  9381                              mov.w   r1, 1Ch[sp]
FFF155A6  bb81                              movu.w  1Ch[sp], r1
FFF155A8  6281                              add     #8, r1
FFF155AA  6a41                              shar    #4, r1
FFF155AC  72110008                          add     #800h, r1, r1
FFF155B0  9309                              mov.w   r1, 1Ah[sp]
FFF155B2  bb09                              movu.w  1Ah[sp], r1
FFF155B4  39a1fb                            bsr.w   sub_FFF15155
FFF155B7  fb1278020200                      mov.l   #20278h, r1
FFF155BD  ee124960                          mov.l   18124h[r1], r2
FFF155C1  0686124a60                        cmp     18128h[r1].l, r2
FFF155C6  2379                              bltu.b  loc_FFF1563F
FFF155C8  fb1278020200                      mov.l   #20278h, r1
FFF155CE  fa16496000                        mov.l   #0, 18124h[r1]
FFF155D3  fb1278020200                      mov.l   #20278h, r1
FFF155D9  fa164a6000                        mov.l   #0, 18128h[r1]
FFF155DE  fb2278020200                      mov.l   #20278h, r2
FFF155E4  ed2143                            mov.l   10Ch[r2], r1
FFF155E7  06852142                          cmp     108h[r2].l, r1
FFF155EB  2335                              bltu.b  loc_FFF15620
FFF155ED  05e31f02                          bsr.a   sub_FFF375D0
FFF155F1  3933f2                            bsr.w   sub_FFF14824
FFF155F4  fb1278020200                      mov.l   #20278h, r1
FFF155FA  e6104cc005                        mov.l   30130h[r1], 14h[sp]
FFF155FF  a909                              mov.l   14h[sp], r1

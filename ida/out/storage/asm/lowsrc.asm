; ==== lowsrc  FFEE1300-FFEE1A80  (file 2E1300-2E1A80) ====
FFEE1300  09                     sub_FFEE1300 bra.s   loc_FFEE1308+1   ; <<<< FUNC sub_FFEE1300
FFEE1301  06c4e1                 sub_FFEE1301 cmp     [r14].uw, r1   ; <<<< FUNC sub_FFEE1301
FFEE1304  2819                              bge.b   loc_FFEE131D
FFEE1306  a809                              mov.l   arg_0[sp], r1
FFEE1308  63c1                   loc_FFEE1308 mul     #0Ch, r1
FFEE130A  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE1310  4b12                              add     r1, r2
FFEE1312  a829                              mov.l   4[r2], r1
FFEE1314  660e                              mov.l   #0, r14
FFEE1316  b80a                              movu.w  2[sp], r2
FFEE1318  fe121e                            mov.w   r14, [r2, r1]
FFEE131B  6702                              rtsd    #2
FFEE131D  6702                   loc_FFEE131D rtsd    #2
FFEE131F  6080                   sub_FFEE131F sub     #8, sp   ; <<<< FUNC sub_FFEE131F
FFEE1321  056cfeff               loc_FFEE1321 bsr.a   sub_FFEE118D
FFEE1325  6101                              cmp     #0, r1
FFEE1327  20fa                              beq.b   loc_FFEE1321
FFEE1329  3e0100                 loc_FFEE1329 mov.l   #0, 8+var_4[sp]
FFEE132C  2e53                              bra.b   loc_FFEE137F
FFEE132E  3d0100                 loc_FFEE132E mov.w   #0, 8+var_6[sp]
FFEE1331  2e35                              bra.b   loc_FFEE1366
FFEE1333  63c1                   loc_FFEE1333 mul     #0Ch, r1
FFEE1335  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE133B  4b12                              add     r1, r2
FFEE133D  a829                              mov.l   4[r2], r1
FFEE133F  b80a                              movu.w  8+var_6[sp], r2
FFEE1341  fed21e                            movu.w  [r2, r1], r14
FFEE1344  610e                              cmp     #0, r14
FFEE1346  201a                              beq.b   loc_FFEE1360
FFEE1348  a809                              mov.l   8+var_4[sp], r1
FFEE134A  63c1                              mul     #0Ch, r1
FFEE134C  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE1352  4b12                              add     r1, r2
FFEE1354  a829                              mov.l   4[r2], r1
FFEE1356  b80a                              movu.w  8+var_6[sp], r2
FFEE1358  fe521e                            mov.w   [r2, r1], r14
FFEE135B  601e                              sub     #1, r14
FFEE135D  fe121e                            mov.w   r14, [r2, r1]
FFEE1360  9809                   loc_FFEE1360 mov.w   8+var_6[sp], r1
FFEE1362  6211                              add     #1, r1
FFEE1364  9009                              mov.w   r1, 8+var_6[sp]
FFEE1366  a809                   loc_FFEE1366 mov.l   8+var_4[sp], r1
FFEE1368  ef1e                              mov.l   r1, r14
FFEE136A  63ce                              mul     #0Ch, r14
FFEE136C  fbf2e4cd0100                      mov.l   #1CDE4h, r15
FFEE1372  4bef                              add     r14, r15
FFEE1374  b80a                              movu.w  8+var_6[sp], r2
FFEE1376  06c4f2                            cmp     [r15].uw, r2
FFEE1379  29ba                              blt.b   loc_FFEE1333
FFEE137B  6211                              add     #1, r1
FFEE137D  a009                              mov.l   r1, 8+var_4[sp]
FFEE137F  a809                   loc_FFEE137F mov.l   8+var_4[sp], r1
FFEE1381  6141                              cmp     #4, r1
FFEE1383  29ab                              blt.b   loc_FFEE132E
FFEE1385  0519feff                          bsr.a   sub_FFEE119E
FFEE1389  0504feff                          bsr.a   sub_FFEE118D
FFEE138D  6101                              cmp     #0, r1
FFEE138F  219a                              bne.b   loc_FFEE1329
FFEE1391  6702                              rtsd    #2
FFEE1393  fbee100008             sub_FFEE1393 mov.l   #80010h, r14   ; <<<< FUNC sub_FFEE1393
FFEE1398  fae9f70102a5                      mov.w   #-5AFEh, 3EEh[r14]
FFEE139E  fbee100008                        mov.l   #80010h, r14
FFEE13A3  ecef                              mov.l   [r14], r15
FFEE13A5  7b0f                              bclr    #10h, r15
FFEE13A7  e3ef                              mov.l   r15, [r14]
FFEE13A9  fbee100008                        mov.l   #80010h, r14
FFEE13AE  fae9f70100a5                      mov.w   #-5B00h, 3EEh[r14]
FFEE13B4  fbee60c008                        mov.l   #8C060h, r14
FFEE13B9  f0e8                              bclr    #0, [r14].b
FFEE13BB  fbee60c008                        mov.l   #8C060h, r14
FFEE13C0  f0e9                              bclr    #1, [r14].b
FFEE13C2  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13C7  f0ef                              bclr    #7, [r14].b
FFEE13C9  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13CE  f0e6                              bset    #6, [r14].b
FFEE13D0  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13D5  f1e721                            bset    #7, 21h[r14].b
FFEE13D8  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13DD  f1e722                            bset    #7, 22h[r14].b
FFEE13E0  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13E5  f0ee                              bclr    #6, [r14].b
FFEE13E7  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13EC  f0e7                              bset    #7, [r14].b
FFEE13EE  fbee009108                        mov.l   #89100h, r14
FFEE13F3  f8e500                            mov.w   #0, [r14]
FFEE13F6  fb1e009108                        mov.l   #89100h, r1
FFEE13FB  3d1200                            mov.w   #0, 4[r1]
FFEE13FE  fb1e009108                        mov.l   #89100h, r1
FFEE1403  3d130c                            mov.w   #0Ch, 6[r1]
FFEE1406  fb1e009108                        mov.l   #89100h, r1
FFEE140B  3d1400                            mov.w   #0, 8[r1]
FFEE140E  fb1e009108                        mov.l   #89100h, r1
FFEE1413  3d1500                            mov.w   #0, 0Ah[r1]
FFEE1416  fb1e009108                        mov.l   #89100h, r1
FFEE141B  b99a                              movu.w  0Eh[r1], r2
FFEE141D  7622ff7f                          and     #7FFFh, r2
FFEE1421  919a                              mov.w   r2, 0Eh[r1]
FFEE1423  fbee25c008                        mov.l   #8C025h, r14
FFEE1428  f0e6                              bset    #6, [r14].b
FFEE142A  fbee28c008                        mov.l   #8C028h, r14
FFEE142F  f0eb                              bclr    #3, [r14].b
FFEE1431  fbee25c008                        mov.l   #8C025h, r14
FFEE1436  f0e4                              bset    #4, [r14].b
FFEE1438  fbee25c008                        mov.l   #8C025h, r14
FFEE143D  f0ed                              bclr    #5, [r14].b
FFEE143F  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE1445  f8e404                            mov.b   #4, [r14]
FFEE1448  fbe2f98b0000                      mov.l   #8BF9h, r14
FFEE144E  f8e400                            mov.b   #0, [r14]
FFEE1451  fbe2fa8b0000                      mov.l   #8BFAh, r14
FFEE1457  f8e400                            mov.b   #0, [r14]
FFEE145A  395802                            bsr.w   sub_FFEE16B2
FFEE145D  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE1463  f8e401                            mov.b   #1, [r14]
FFEE1466  02                                rts
FFEE1467  6040                   sub_FFEE1467 sub     #4, sp   ; <<<< FUNC sub_FFEE1467
FFEE1469  e301                              mov.l   r1, 4+var_4[sp]
FFEE146B  fbe2ea240100                      mov.l   #124EAh, r14
FFEE1471  d0e1                              mov.w   [r14], [r1]
FFEE1473  ec01                              mov.l   4+var_4[sp], r1
FFEE1475  fbe2ec240100                      mov.l   #124ECh, r14
FFEE147B  d4e101                            mov.w   [r14], 2[r1]
FFEE147E  6701                              rtsd    #1
FFEE1480  6040                   sub_FFEE1480 sub     #4, sp   ; <<<< FUNC sub_FFEE1480
FFEE1482  fbee009108                        mov.l   #89100h, r14
FFEE1487  dcef                              mov.w   [r14], r15
FFEE1489  78ff                              bset    #0Fh, r15
FFEE148B  d3ef                              mov.w   r15, [r14]
FFEE148D  fbee009108             loc_FFEE148D mov.l   #89100h, r14
FFEE1492  5cee                              movu.w  [r14], r14
FFEE1494  772e008000                        and     #8000h, r14
FFEE1499  68fe                              shlr    #0Fh, r14
FFEE149B  610e                              cmp     #0, r14
FFEE149D  21f0                              bne.b   loc_FFEE148D
FFEE149F  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE14A5  58ee                              movu.b  [r14], r14
FFEE14A7  613e                              cmp     #3, r14
FFEE14A9  3a8301                            beq.w   loc_FFEE162C
FFEE14AC  612e                              cmp     #2, r14
FFEE14AE  3a0201                            beq.w   loc_FFEE15B0
FFEE14B1  611e                              cmp     #1, r14
FFEE14B3  3bfd01                            bne.w   loc_FFEE16B0
FFEE14B6  fbee009108                        mov.l   #89100h, r14
FFEE14BB  d5e02201                          mov.w   44h[r14], 4+var_2[sp]
FFEE14BF  b809                              movu.w  4+var_2[sp], r1
FFEE14C1  7601f00a                          cmp     #0AF0h, r1
FFEE14C5  2805                              bge.b   loc_FFEE14CA
FFEE14C7  38a700                            bra.w   loc_FFEE156E
FFEE14CA  fbe2fa8b0000           loc_FFEE14CA mov.l   #8BFAh, r14
FFEE14D0  58ee                              movu.b  [r14], r14
FFEE14D2  611e                              cmp     #1, r14
FFEE14D4  2173                              bne.b   loc_FFEE1547
FFEE14D6  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE14DC  58ee                              movu.b  [r14], r14
FFEE14DE  6c2e                              shll    #2, r14
FFEE14E0  fbf2d6240100                      mov.l   #124D6h, r15
FFEE14E6  4bef                              add     r14, r15
FFEE14E8  fbe2e6240100                      mov.l   #124E6h, r14
FFEE14EE  d0ef                              mov.w   [r14], [r15]
FFEE14F0  d5ef0101                          mov.w   2[r14], 2[r15]
FFEE14F4  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE14FA  58ef                              movu.b  [r14], r15
FFEE14FC  621f                              add     #1, r15
FFEE14FE  c3ef                              mov.b   r15, [r14]
FFEE1500  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE1506  58ef                              movu.b  [r14], r15
FFEE1508  643f                              and     #3, r15
FFEE150A  c3ef                              mov.b   r15, [r14]
FFEE150C  fbe2fa8b0000                      mov.l   #8BFAh, r14
FFEE1512  f8e400                            mov.b   #0, [r14]
FFEE1515  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE151B  58ee                              movu.b  [r14], r14
FFEE151D  610e                              cmp     #0, r14
FFEE151F  2028                              beq.b   loc_FFEE1547
FFEE1521  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE1527  58ef                              movu.b  [r14], r15
FFEE1529  601f                              sub     #1, r15
FFEE152B  c3ef                              mov.b   r15, [r14]
FFEE152D  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE1533  58ee                              movu.b  [r14], r14
FFEE1535  610e                              cmp     #0, r14
FFEE1537  2110                              bne.b   loc_FFEE1547
FFEE1539  6611                              mov.l   #1, r1
FFEE153B  39b301                            bsr.w   sub_FFEE16EE
FFEE153E  fbe2f98b0000                      mov.l   #8BF9h, r14
FFEE1544  f8e404                            mov.b   #4, [r14]
FFEE1547  fbee25c008             loc_FFEE1547 mov.l   #8C025h, r14
FFEE154C  f0ee                              bclr    #6, [r14].b
FFEE154E  fbee28c008                        mov.l   #8C028h, r14
FFEE1553  f0e3                              bset    #3, [r14].b
FFEE1555  fbee25c008                        mov.l   #8C025h, r14
FFEE155A  f0e4                              bset    #4, [r14].b
FFEE155C  fbee25c008                        mov.l   #8C025h, r14
FFEE1561  f0ed                              bclr    #5, [r14].b
FFEE1563  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE1569  f8e402                            mov.b   #2, [r14]
FFEE156C  6701                              rtsd    #1
FFEE156E  fbe2f98b0000           loc_FFEE156E mov.l   #8BF9h, r14
FFEE1574  58ee                              movu.b  [r14], r14
FFEE1576  610e                              cmp     #0, r14
FFEE1578  3a3801                            beq.w   loc_FFEE16B0
FFEE157B  fbe2f98b0000                      mov.l   #8BF9h, r14
FFEE1581  58ef                              movu.b  [r14], r15
FFEE1583  601f                              sub     #1, r15
FFEE1585  c3ef                              mov.b   r15, [r14]
FFEE1587  fbe2f98b0000                      mov.l   #8BF9h, r14
FFEE158D  58ee                              movu.b  [r14], r14
FFEE158F  610e                              cmp     #0, r14
FFEE1591  3b1f01                            bne.w   loc_FFEE16B0
FFEE1594  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE159A  f8e404                            mov.b   #4, [r14]
FFEE159D  6601                              mov.l   #0, r1
FFEE159F  394f01                            bsr.w   sub_FFEE16EE
FFEE15A2  391001                            bsr.w   sub_FFEE16B2
FFEE15A5  fbe2fa8b0000                      mov.l   #8BFAh, r14
FFEE15AB  f8e400                            mov.b   #0, [r14]
FFEE15AE  6701                              rtsd    #1
FFEE15B0  fbee009108             loc_FFEE15B0 mov.l   #89100h, r14
FFEE15B5  d5e02201                          mov.w   44h[r14], 4+var_2[sp]
FFEE15B9  b809                              movu.w  4+var_2[sp], r1
FFEE15BB  755181                            cmp     #-7Fh, r1
FFEE15BE  2a07                              bgt.b   loc_FFEE15C5
FFEE15C0  3d0100                            mov.w   #0, 4+var_2[sp]
FFEE15C3  2e2f                              bra.b   loc_FFEE15F2
FFEE15C5  b809                   loc_FFEE15C5 movu.w  4+var_2[sp], r1
FFEE15C7  7601e703                          cmp     #3E7h, r1
FFEE15CB  2a0a                              bgt.b   loc_FFEE15D5
FFEE15CD  72117eff                          add     #-82h, r1, r1
FFEE15D1  9009                              mov.w   r1, 4+var_2[sp]
FFEE15D3  2e1f                              bra.b   loc_FFEE15F2
FFEE15D5  7601000f               loc_FFEE15D5 cmp     #0F00h, r1
FFEE15D9  2909                              blt.b   loc_FFEE15E2
FFEE15DB  f90901ff0f                        mov.w   #0FFFh, 4+var_2[sp]
FFEE15E0  2e12                              bra.b   loc_FFEE15F2
FFEE15E2  b809                   loc_FFEE15E2 movu.w  4+var_2[sp], r1
FFEE15E4  7601b90b                          cmp     #0BB9h, r1
FFEE15E8  290a                              blt.b   loc_FFEE15F2
FFEE15EA  b809                              movu.w  4+var_2[sp], r1
FFEE15EC  72110001                          add     #100h, r1, r1
FFEE15F0  9009                              mov.w   r1, 4+var_2[sp]
FFEE15F2  b809                   loc_FFEE15F2 movu.w  4+var_2[sp], r1
FFEE15F4  76114001                          mul     #140h, r1
FFEE15F8  fd7891ff0f                        divu    #0FFFh, r1
FFEE15FD  fbe2e6240100                      mov.l   #124E6h, r14
FFEE1603  d3e1                              mov.w   r1, [r14]
FFEE1605  fbee25c008                        mov.l   #8C025h, r14
FFEE160A  f0ee                              bclr    #6, [r14].b
FFEE160C  fbee28c008                        mov.l   #8C028h, r14
FFEE1611  f0eb                              bclr    #3, [r14].b
FFEE1613  fbee25c008                        mov.l   #8C025h, r14
FFEE1618  f0ec                              bclr    #4, [r14].b
FFEE161A  fbee25c008                        mov.l   #8C025h, r14
FFEE161F  f0e5                              bset    #5, [r14].b
FFEE1621  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE1627  f8e403                            mov.b   #3, [r14]
FFEE162A  6701                              rtsd    #1
FFEE162C  fbee009108             loc_FFEE162C mov.l   #89100h, r14
FFEE1631  d5e02301                          mov.w   46h[r14], 4+var_2[sp]
FFEE1635  b809                              movu.w  4+var_2[sp], r1
FFEE1637  755177                            cmp     #77h, r1 ; 'w'
FFEE163A  2a07                              bgt.b   loc_FFEE1641
FFEE163C  3d0100                            mov.w   #0, 4+var_2[sp]
FFEE163F  2e2e                              bra.b   loc_FFEE166D
FFEE1641  b809                   loc_FFEE1641 movu.w  4+var_2[sp], r1
FFEE1643  7601e703                          cmp     #3E7h, r1
FFEE1647  2a09                              bgt.b   loc_FFEE1650
FFEE1649  711188                            add     #-78h, r1, r1
FFEE164C  9009                              mov.w   r1, 4+var_2[sp]
FFEE164E  2e1f                              bra.b   loc_FFEE166D
FFEE1650  7601ec0e               loc_FFEE1650 cmp     #0EECh, r1
FFEE1654  2909                              blt.b   loc_FFEE165D
FFEE1656  f90901ff0f                        mov.w   #0FFFh, 4+var_2[sp]
FFEE165B  2e12                              bra.b   loc_FFEE166D
FFEE165D  b809                   loc_FFEE165D movu.w  4+var_2[sp], r1
FFEE165F  7601b90b                          cmp     #0BB9h, r1
FFEE1663  290a                              blt.b   loc_FFEE166D
FFEE1665  b809                              movu.w  4+var_2[sp], r1
FFEE1667  72111401                          add     #114h, r1, r1
FFEE166B  9009                              mov.w   r1, 4+var_2[sp]
FFEE166D  b809                   loc_FFEE166D movu.w  4+var_2[sp], r1
FFEE166F  7611f000                          mul     #0F0h, r1
FFEE1673  fd7891ff0f                        divu    #0FFFh, r1
FFEE1678  fb22e6240100                      mov.l   #124E6h, r2
FFEE167E  9029                              mov.w   r1, 2[r2]
FFEE1680  fbe2fa8b0000                      mov.l   #8BFAh, r14
FFEE1686  f8e401                            mov.b   #1, [r14]
FFEE1689  fbee25c008                        mov.l   #8C025h, r14
FFEE168E  f0e6                              bset    #6, [r14].b
FFEE1690  fbee28c008                        mov.l   #8C028h, r14
FFEE1695  f0eb                              bclr    #3, [r14].b
FFEE1697  fbee25c008                        mov.l   #8C025h, r14
FFEE169C  f0e4                              bset    #4, [r14].b
FFEE169E  fbee25c008                        mov.l   #8C025h, r14
FFEE16A3  f0ed                              bclr    #5, [r14].b
FFEE16A5  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE16AB  f8e401                            mov.b   #1, [r14]
FFEE16AE  6701                              rtsd    #1
FFEE16B0  6701                   loc_FFEE16B0 rtsd    #1
FFEE16B2  6040                   sub_FFEE16B2 sub     #4, sp   ; <<<< FUNC sub_FFEE16B2
FFEE16B4  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE16BA  f8e400                            mov.b   #0, [r14]
FFEE16BD  3c0300                            mov.b   #0, 4+var_1[sp]
FFEE16C0  2e26                              bra.b   loc_FFEE16E6
FFEE16C2  b089                   loc_FFEE16C2 movu.b  4+var_1[sp], r1
FFEE16C4  6c21                              shll    #2, r1
FFEE16C6  fbe2d6240100                      mov.l   #124D6h, r14
FFEE16CC  4b1e                              add     r1, r14
FFEE16CE  f8e500                            mov.w   #0, [r14]
FFEE16D1  b089                              movu.b  4+var_1[sp], r1
FFEE16D3  6c21                              shll    #2, r1
FFEE16D5  fb22d6240100                      mov.l   #124D6h, r2
FFEE16DB  4b12                              add     r1, r2
FFEE16DD  3d2100                            mov.w   #0, 2[r2]
FFEE16E0  b089                              movu.b  4+var_1[sp], r1
FFEE16E2  6211                              add     #1, r1
FFEE16E4  8089                              mov.b   r1, 4+var_1[sp]
FFEE16E6  b089                   loc_FFEE16E6 movu.b  4+var_1[sp], r1
FFEE16E8  6141                              cmp     #4, r1
FFEE16EA  29d8                              blt.b   loc_FFEE16C2
FFEE16EC  6701                              rtsd    #1
FFEE16EE  6080                   sub_FFEE16EE sub     #8, sp   ; <<<< FUNC sub_FFEE16EE
FFEE16F0  8189                              mov.b   r1, 8+var_1[sp]
FFEE16F2  3d0100                            mov.w   #0, 8+var_6[sp]
FFEE16F5  3d0200                            mov.w   #0, 8+var_4[sp]
FFEE16F8  fbe2ec240100                      mov.l   #124ECh, r14
FFEE16FE  f8e500                            mov.w   #0, [r14]
FFEE1701  fbf2ea240100                      mov.l   #124EAh, r15
FFEE1707  d0ef                              mov.w   [r14], [r15]
FFEE1709  3c0100                            mov.b   #0, 8+var_7[sp]
FFEE170C  2e30                              bra.b   loc_FFEE173C
FFEE170E  b009                   loc_FFEE170E movu.b  8+var_7[sp], r1
FFEE1710  6c21                              shll    #2, r1
FFEE1712  fbe2d6240100                      mov.l   #124D6h, r14
FFEE1718  4b1e                              add     r1, r14
FFEE171A  5ce1                              movu.w  [r14], r1
FFEE171C  06c90101                          add     8+var_6[sp].uw, r1
FFEE1720  9009                              mov.w   r1, 8+var_6[sp]
FFEE1722  b009                              movu.b  8+var_7[sp], r1
FFEE1724  6c21                              shll    #2, r1
FFEE1726  fb22d6240100                      mov.l   #124D6h, r2
FFEE172C  4b12                              add     r1, r2
FFEE172E  b829                              movu.w  2[r2], r1
FFEE1730  06c90102                          add     8+var_4[sp].uw, r1
FFEE1734  9081                              mov.w   r1, 8+var_4[sp]
FFEE1736  b009                              movu.b  8+var_7[sp], r1
FFEE1738  6211                              add     #1, r1
FFEE173A  8009                              mov.b   r1, 8+var_7[sp]
FFEE173C  b009                   loc_FFEE173C movu.b  8+var_7[sp], r1
FFEE173E  6141                              cmp     #4, r1
FFEE1740  29ce                              blt.b   loc_FFEE170E
FFEE1742  b809                              movu.w  8+var_6[sp], r1
FFEE1744  6821                              shlr    #2, r1
FFEE1746  9009                              mov.w   r1, 8+var_6[sp]
FFEE1748  b881                              movu.w  8+var_4[sp], r1
FFEE174A  6821                              shlr    #2, r1
FFEE174C  9081                              mov.w   r1, 8+var_4[sp]
FFEE174E  fb1a4001                          mov.l   #140h, r1
FFEE1752  06c10101                          sub     8+var_6[sp].uw, r1
FFEE1756  9009                              mov.w   r1, 8+var_6[sp]
FFEE1758  7541f0                            mov.l   #-10h, r1
FFEE175B  06c10102                          sub     8+var_4[sp].uw, r1
FFEE175F  9081                              mov.w   r1, 8+var_4[sp]
FFEE1761  fbe2ea240100                      mov.l   #124EAh, r14
FFEE1767  d10e01                            mov.w   8+var_6[sp], [r14]
FFEE176A  fbe2ec240100                      mov.l   #124ECh, r14
FFEE1770  d10e02                            mov.w   8+var_4[sp], [r14]
FFEE1773  b883                              movu.w  8+var_4[sp], r3
FFEE1775  b80a                              movu.w  8+var_6[sp], r2
FFEE1777  b189                              movu.b  8+var_1[sp], r1
FFEE1779  0544acff                          bsr.a   sub_FFEDC3BD
FFEE177D  6702                              rtsd    #2
FFEE177F  02                     sub_FFEE177F rts   ; <<<< FUNC sub_FFEE177F
FFEE1780  fbe214ce0100           sub_FFEE1780 mov.l   #1CE14h, r14   ; <<<< FUNC sub_FFEE1780
FFEE1786  fbf2b0960600                      mov.l   #696B0h, r15
FFEE178C  e3ef                              mov.l   r15, [r14]
FFEE178E  fb1214ce0100                      mov.l   #1CE14h, r1
FFEE1794  fb22f8960600                      mov.l   #696F8h, r2
FFEE179A  a01a                              mov.l   r2, 4[r1]
FFEE179C  fb1214ce0100                      mov.l   #1CE14h, r1
FFEE17A2  fb2240970600                      mov.l   #69740h, r2
FFEE17A8  a092                              mov.l   r2, 8[r1]
FFEE17AA  fb32b0960600                      mov.l   #696B0h, r3
FFEE17B0  fb22da84f4ff                      mov.l   #aR_3, r2; "r"
FFEE17B6  fb12d184f4ff                      mov.l   #aCStdin, r1; "local tree, not in this repo"
FFEE17BC  05da3c06                          bsr.a   sub_FFF45496
FFEE17C0  6101                              cmp     #0, r1
FFEE17C2  210c                              bne.b   loc_FFEE17CE
FFEE17C4  fbe2b0960600                      mov.l   #696B0h, r14
FFEE17CA  f8e9ffff                          mov.w   #-1, [r14]
FFEE17CE  fbe2b0960600           loc_FFEE17CE mov.l   #696B0h, r14
FFEE17D4  f8e501                            mov.w   #1, [r14]
FFEE17D7  fbe2b0960600                      mov.l   #696B0h, r14
FFEE17DD  dcef                              mov.w   [r14], r15
FFEE17DF  78bf                              bset    #0Bh, r15
FFEE17E1  d3ef                              mov.w   r15, [r14]
FFEE17E3  fb12b0960600                      mov.l   #696B0h, r1
FFEE17E9  a81a                              mov.l   4[r1], r2
FFEE17EB  6212                              add     #1, r2
FFEE17ED  a092                              mov.l   r2, 8[r1]
FFEE17EF  fb32f8960600                      mov.l   #696F8h, r3
FFEE17F5  fb22e684f4ff                      mov.l   #aW_1, r2; "w"
FFEE17FB  fb12dc84f4ff                      mov.l   #aCStdout, r1; "local tree, not in this repo"
FFEE1801  05953c06                          bsr.a   sub_FFF45496
FFEE1805  6101                              cmp     #0, r1
FFEE1807  210c                              bne.b   loc_FFEE1813
FFEE1809  fbe2f8960600                      mov.l   #696F8h, r14
FFEE180F  f8e9ffff                          mov.w   #-1, [r14]
FFEE1813  fbe2f8960600           loc_FFEE1813 mov.l   #696F8h, r14
FFEE1819  dcef                              mov.w   [r14], r15
FFEE181B  78bf                              bset    #0Bh, r15
FFEE181D  d3ef                              mov.w   r15, [r14]
FFEE181F  fb12f8960600                      mov.l   #696F8h, r1
FFEE1825  a81a                              mov.l   4[r1], r2
FFEE1827  6212                              add     #1, r2
FFEE1829  a092                              mov.l   r2, 8[r1]
FFEE182B  fb3240970600                      mov.l   #69740h, r3
FFEE1831  fb22e684f4ff                      mov.l   #aW_1, r2; "w"
FFEE1837  fb12e884f4ff                      mov.l   #aCStderr, r1; "local tree, not in this repo"
FFEE183D  05593c06                          bsr.a   sub_FFF45496
FFEE1841  6101                              cmp     #0, r1
FFEE1843  210c                              bne.b   loc_FFEE184F
FFEE1845  fbe240970600                      mov.l   #69740h, r14
FFEE184B  f8e9ffff                          mov.w   #-1, [r14]
FFEE184F  fbe240970600           loc_FFEE184F mov.l   #69740h, r14
FFEE1855  dcef                              mov.w   [r14], r15
FFEE1857  78bf                              bset    #0Bh, r15
FFEE1859  d3ef                              mov.w   r15, [r14]
FFEE185B  fb1240970600                      mov.l   #69740h, r1
FFEE1861  a81a                              mov.l   4[r1], r2
FFEE1863  6212                              add     #1, r2
FFEE1865  a092                              mov.l   r2, 8[r1]
FFEE1867  02                                rts
FFEE1868  6040                   sub_FFEE1868 sub     #4, sp   ; <<<< FUNC sub_FFEE1868
FFEE186A  f80600                            mov.l   #0, 4+var_4[sp]
FFEE186D  2e2a                              bra.b   loc_FFEE1897
FFEE186F  fbe214ce0100           loc_FFEE186F mov.l   #1CE14h, r14
FFEE1875  ec01                              mov.l   4+var_4[sp], r1
FFEE1877  fe61ee                            mov.l   [r1, r14], r14
FFEE187A  667f                              mov.l   #7, r15
FFEE187C  06e00cef                          tst     [r14].uw, r15
FFEE1880  2011                              beq.b   loc_FFEE1891
FFEE1882  fbe214ce0100                      mov.l   #1CE14h, r14
FFEE1888  ec01                              mov.l   4+var_4[sp], r1
FFEE188A  fe61e1                            mov.l   [r1, r14], r1
FFEE188D  05383c06                          bsr.a   sub_FFF454C5
FFEE1891  ec01                   loc_FFEE1891 mov.l   4+var_4[sp], r1
FFEE1893  6211                              add     #1, r1
FFEE1895  e301                              mov.l   r1, 4+var_4[sp]
FFEE1897  fbe27489edff           loc_FFEE1897 mov.l   #unk_FFED8974, r14
FFEE189D  ec01                              mov.l   4+var_4[sp], r1
FFEE189F  0684e1                            cmp     [r14].l, r1
FFEE18A2  29cd                              blt.b   loc_FFEE186F
FFEE18A4  6701                              rtsd    #1
FFEE18A6  7100ec                 sub_FFEE18A6 add     #-14h, sp, sp   ; <<<< FUNC sub_FFEE18A6
FFEE18A9  a101                              mov.l   r1, 14h+var_4[sp]
FFEE18AB  a08a                              mov.l   r2, 14h+var_8[sp]
FFEE18AD  a083                              mov.l   r3, 14h+var_C[sp]
FFEE18AF  fb36ff                            mov.l   #-1, r3
FFEE18B2  fb22d184f4ff                      mov.l   #aCStdin, r2; "local tree, not in this repo"
FFEE18B8  a901                              mov.l   14h+var_4[sp], r1
FFEE18BA  7f83                              scmpu
FFEE18BC  fcdbe2                            scgeu.l r14
FFEE18BF  fcdbf5                            scleu.l r15
FFEE18C2  43fe                              sub     r15, r14
FFEE18C4  610e                              cmp     #0, r14
FFEE18C6  211b                              bne.b   loc_FFEE18E1
FFEE18C8  a889                              mov.l   14h+var_8[sp], r1
FFEE18CA  7c01                              btst    #0, r1
FFEE18CC  1e                                bne.s   loc_FFEE18D2
FFEE18CD  f806ff                            mov.l   #-1, 14h+var_14[sp]
FFEE18D0  2e77                              bra.b   loc_FFEE1947
FFEE18D2  a889                   loc_FFEE18D2 mov.l   14h+var_8[sp], r1
FFEE18D4  fbe2fb8b0000                      mov.l   #8BFBh, r14
FFEE18DA  c3e1                              mov.b   r1, [r14]
FFEE18DC  f80600                            mov.l   #0, 14h+var_14[sp]
FFEE18DF  2e68                              bra.b   loc_FFEE1947
FFEE18E1  fb36ff                 loc_FFEE18E1 mov.l   #-1, r3
FFEE18E4  fb22dc84f4ff                      mov.l   #aCStdout, r2; "local tree, not in this repo"
FFEE18EA  a901                              mov.l   14h+var_4[sp], r1
FFEE18EC  7f83                              scmpu
FFEE18EE  fcdbe2                            scgeu.l r14
FFEE18F1  fcdbf5                            scleu.l r15
FFEE18F4  43fe                              sub     r15, r14
FFEE18F6  610e                              cmp     #0, r14
FFEE18F8  211b                              bne.b   loc_FFEE1913
FFEE18FA  a889                              mov.l   14h+var_8[sp], r1
FFEE18FC  7c11                              btst    #1, r1
FFEE18FE  1e                                bne.s   loc_FFEE1904
FFEE18FF  f806ff                            mov.l   #-1, 14h+var_14[sp]
FFEE1902  2e45                              bra.b   loc_FFEE1947
FFEE1904  a889                   loc_FFEE1904 mov.l   14h+var_8[sp], r1
FFEE1906  fb22fb8b0000                      mov.l   #8BFBh, r2
FFEE190C  8029                              mov.b   r1, 1[r2]
FFEE190E  f80601                            mov.l   #1, 14h+var_14[sp]
FFEE1911  2e36                              bra.b   loc_FFEE1947
FFEE1913  fb36ff                 loc_FFEE1913 mov.l   #-1, r3
FFEE1916  fb22e884f4ff                      mov.l   #aCStderr, r2; "local tree, not in this repo"
FFEE191C  a901                              mov.l   14h+var_4[sp], r1
FFEE191E  7f83                              scmpu
FFEE1920  fcdbe2                            scgeu.l r14
FFEE1923  fcdbf5                            scleu.l r15
FFEE1926  43fe                              sub     r15, r14
FFEE1928  610e                              cmp     #0, r14
FFEE192A  211a                              bne.b   loc_FFEE1944
FFEE192C  a889                              mov.l   14h+var_8[sp], r1
FFEE192E  7c11                              btst    #1, r1
FFEE1930  1e                                bne.s   loc_FFEE1936
FFEE1931  f806ff                            mov.l   #-1, 14h+var_14[sp]
FFEE1934  2e13                              bra.b   loc_FFEE1947
FFEE1936  a889                   loc_FFEE1936 mov.l   14h+var_8[sp], r1
FFEE1938  fb22fb8b0000                      mov.l   #8BFBh, r2
FFEE193E  80a1                              mov.b   r1, 2[r2]
FFEE1940  f80602                            mov.l   #2, 14h+var_14[sp]
FFEE1943  0c                                bra.s   loc_FFEE1947
FFEE1944  f806ff                 loc_FFEE1944 mov.l   #-1, 14h+var_14[sp]
FFEE1947  ec01                   loc_FFEE1947 mov.l   14h+var_14[sp], r1
FFEE1949  a009                              mov.l   r1, 14h+var_10[sp]
FFEE194B  6705                              rtsd    #5
FFEE194D  6080                   sub_FFEE194D sub     #8, sp   ; <<<< FUNC sub_FFEE194D
FFEE194F  a009                              mov.l   r1, 8+var_4[sp]
FFEE1951  f80601                            mov.l   #1, 8+var_8[sp]
FFEE1954  6611                              mov.l   #1, r1
FFEE1956  6702                              rtsd    #2
FFEE1958  7100e0                 sub_FFEE1958 add     #-20h, sp, sp   ; <<<< FUNC sub_FFEE1958
FFEE195B  a189                              mov.l   r1, 20h+var_4[sp]
FFEE195D  a182                              mov.l   r2, 20h+var_8[sp]
FFEE195F  a10b                              mov.l   r3, 20h+var_C[sp]
FFEE1961  fbe2fb8b0000                      mov.l   #8BFBh, r14
FFEE1967  a989                              mov.l   20h+var_4[sp], r1
FFEE1969  fece1e                            movu.b  [r14, r1], r14
FFEE196C  7c1e                              btst    #1, r14
FFEE196E  2110                              bne.b   loc_FFEE197E
FFEE1970  a989                              mov.l   20h+var_4[sp], r1
FFEE1972  fbe2fb8b0000                      mov.l   #8BFBh, r14
FFEE1978  fece1e                            movu.b  [r14, r1], r14
FFEE197B  7c2e                              btst    #2, r14
FFEE197D  15                                beq.s   loc_FFEE1982
FFEE197E  f80601                 loc_FFEE197E mov.l   #1, 20h+var_20[sp]
FFEE1981  0c                                bra.s   loc_FFEE1985
FFEE1982  f80600                 loc_FFEE1982 mov.l   #0, 20h+var_20[sp]
FFEE1985  ec01                   loc_FFEE1985 mov.l   20h+var_20[sp], r1
FFEE1987  6101                              cmp     #0, r1
FFEE1989  2051                              beq.b   loc_FFEE19DA
FFEE198B  a989                              mov.l   20h+var_4[sp], r1
FFEE198D  6101                              cmp     #0, r1
FFEE198F  1f                                bne.s   loc_FFEE1996
FFEE1990  f90601ff                          mov.l   #-1, 20h+var_1C[sp]
FFEE1994  2e4a                              bra.b   loc_FFEE19DE
FFEE1996  a989                   loc_FFEE1996 mov.l   20h+var_4[sp], r1
FFEE1998  6111                              cmp     #1, r1
FFEE199A  16                                beq.s   loc_FFEE19A0
FFEE199B  a989                              mov.l   20h+var_4[sp], r1
FFEE199D  6121                              cmp     #2, r1
FFEE199F  1d                                bne.s   loc_FFEE19A4
FFEE19A0  f80601                 loc_FFEE19A0 mov.l   #1, 20h+var_20[sp]
FFEE19A3  0c                                bra.s   loc_FFEE19A7
FFEE19A4  f80600                 loc_FFEE19A4 mov.l   #0, 20h+var_20[sp]
FFEE19A7  ec01                   loc_FFEE19A7 mov.l   20h+var_20[sp], r1
FFEE19A9  6101                              cmp     #0, r1
FFEE19AB  202a                              beq.b   loc_FFEE19D5
FFEE19AD  e5000503                          mov.l   20h+var_C[sp], 20h+var_14[sp]
FFEE19B1  2e19                              bra.b   loc_FFEE19CA
FFEE19B3  a981                   loc_FFEE19B3 mov.l   20h+var_8[sp], r1
FFEE19B5  c4100b                            mov.b   [r1], 20h+var_15[sp]
FFEE19B8  a981                              mov.l   20h+var_8[sp], r1
FFEE19BA  6211                              add     #1, r1
FFEE19BC  a181                              mov.l   r1, 20h+var_8[sp]
FFEE19BE  b289                              movu.b  20h+var_15[sp], r1
FFEE19C0  05480800                          bsr.a   sub_FFEE2208
FFEE19C4  a889                              mov.l   20h+var_14[sp], r1
FFEE19C6  6011                              sub     #1, r1
FFEE19C8  a089                              mov.l   r1, 20h+var_14[sp]
FFEE19CA  a889                   loc_FFEE19CA mov.l   20h+var_14[sp], r1
FFEE19CC  6101                              cmp     #0, r1
FFEE19CE  2ae5                              bgt.b   loc_FFEE19B3
FFEE19D0  e5000501                          mov.l   20h+var_C[sp], 20h+var_1C[sp]
FFEE19D4  0a                                bra.s   loc_FFEE19DE
FFEE19D5  f90601ff               loc_FFEE19D5 mov.l   #-1, 20h+var_1C[sp]
FFEE19D9  0d                                bra.s   loc_FFEE19DE
FFEE19DA  f90601ff               loc_FFEE19DA mov.l   #-1, 20h+var_1C[sp]
FFEE19DE  a809                   loc_FFEE19DE mov.l   20h+var_1C[sp], r1
FFEE19E0  a101                              mov.l   r1, 20h+var_10[sp]
FFEE19E2  6708                              rtsd    #8
FFEE19E4  7ea6                   sub_FFEE19E4 push.l  r6   ; <<<< FUNC sub_FFEE19E4
FFEE19E6  7100e4                            add     #-1Ch, sp, sp
FFEE19E9  a181                              mov.l   r1, 1Ch+var_4[sp]
FFEE19EB  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFEE19ED  a103                              mov.l   r3, 1Ch+var_C[sp]
FFEE19EF  fbe2fb8b0000                      mov.l   #8BFBh, r14
FFEE19F5  a981                              mov.l   1Ch+var_4[sp], r1
FFEE19F7  fece1e                            movu.b  [r14, r1], r14
FFEE19FA  7c0e                              btst    #0, r14
FFEE19FC  2110                              bne.b   loc_FFEE1A0C
FFEE19FE  a981                              mov.l   1Ch+var_4[sp], r1
FFEE1A00  fbe2fb8b0000                      mov.l   #8BFBh, r14
FFEE1A06  fece1e                            movu.b  [r14, r1], r14
FFEE1A09  7c2e                              btst    #2, r14
FFEE1A0B  15                                beq.s   loc_FFEE1A10
FFEE1A0C  f80601                 loc_FFEE1A0C mov.l   #1, 1Ch+var_1C[sp]
FFEE1A0F  0c                                bra.s   loc_FFEE1A13
FFEE1A10  f80600                 loc_FFEE1A10 mov.l   #0, 1Ch+var_1C[sp]
FFEE1A13  ec01                   loc_FFEE1A13 mov.l   1Ch+var_1C[sp], r1
FFEE1A15  6101                              cmp     #0, r1
FFEE1A17  2033                              beq.b   loc_FFEE1A4A
FFEE1A19  e5000402                          mov.l   1Ch+var_C[sp], 1Ch+var_14[sp]
FFEE1A1D  2e22                              bra.b   loc_FFEE1A3F
FFEE1A1F  a90e                   loc_FFEE1A1F mov.l   1Ch+var_8[sp], r6
FFEE1A21  05040800                          bsr.a   sub_FFEE2225
FFEE1A25  c361                              mov.b   r1, [r6]
FFEE1A27  a909                              mov.l   1Ch+var_8[sp], r1
FFEE1A29  581e                              movu.b  [r1], r14
FFEE1A2B  61de                              cmp     #0Dh, r14
FFEE1A2D  1e                                bne.s   loc_FFEE1A33
FFEE1A2E  a909                              mov.l   1Ch+var_8[sp], r1
FFEE1A30  f8140a                            mov.b   #0Ah, [r1]
FFEE1A33  a909                   loc_FFEE1A33 mov.l   1Ch+var_8[sp], r1
FFEE1A35  6211                              add     #1, r1
FFEE1A37  a109                              mov.l   r1, 1Ch+var_8[sp]
FFEE1A39  a881                              mov.l   1Ch+var_14[sp], r1
FFEE1A3B  6011                              sub     #1, r1
FFEE1A3D  a081                              mov.l   r1, 1Ch+var_14[sp]
FFEE1A3F  a881                   loc_FFEE1A3F mov.l   1Ch+var_14[sp], r1
FFEE1A41  6101                              cmp     #0, r1
FFEE1A43  2adc                              bgt.b   loc_FFEE1A1F
FFEE1A45  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFEE1A49  0d                                bra.s   loc_FFEE1A4E
FFEE1A4A  f90601ff               loc_FFEE1A4A mov.l   #-1, 1Ch+var_18[sp]
FFEE1A4E  a809                   loc_FFEE1A4E mov.l   1Ch+var_18[sp], r1
FFEE1A50  a089                              mov.l   r1, 1Ch+var_10[sp]
FFEE1A52  3f6608                            rtsd    #20h, r6-r6
FFEE1A55  7100f0                 sub_FFEE1A55 add     #-10h, sp, sp   ; <<<< FUNC sub_FFEE1A55
FFEE1A58  a089                              mov.l   r1, 10h+var_4[sp]
FFEE1A5A  a082                              mov.l   r2, 10h+var_8[sp]
FFEE1A5C  a00b                              mov.l   r3, 10h+var_C[sp]
FFEE1A5E  f806ff                            mov.l   #-1, 10h+var_10[sp]
FFEE1A61  fb16ff                            mov.l   #-1, r1
FFEE1A64  6704                              rtsd    #4
FFEE1A66  60c0                   sub_FFEE1A66 sub     #0Ch, sp   ; <<<< FUNC sub_FFEE1A66
FFEE1A68  a081                              mov.l   r1, 0Ch+var_4[sp]
FFEE1A6A  fbe258870600                      mov.l   #68758h, r14
FFEE1A70  0688e1                            add     [r14].l, r1
FFEE1A73  fbe264ce0100                      mov.l   #1CE64h, r14
FFEE1A79  72ee0004                          add     #400h, r14, r14
FFEE1A7D  47e1                              cmp     r14, r1
FFEE1A7F  2507                              bleu.b  loc_FFEE1A86

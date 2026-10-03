; ==== s12ad1_tail  FFEE15B0-FFEE1780 ====
FFEE15B0  fbee009108               loc_FFEE15B0 mov.l   #89100h, r14
FFEE15B5  d5e02201                          mov.w   44h[r14], 4+var_2[sp]
FFEE15B9  b809                              movu.w  4+var_2[sp], r1
FFEE15BB  755181                            cmp     #-7Fh, r1
FFEE15BE  2a07                              bgt.b   loc_FFEE15C5
FFEE15C0  3d0100                            mov.w   #0, 4+var_2[sp]
FFEE15C3  2e2f                              bra.b   loc_FFEE15F2
FFEE15C5  b809                     loc_FFEE15C5 movu.w  4+var_2[sp], r1
FFEE15C7  7601e703                          cmp     #3E7h, r1
FFEE15CB  2a0a                              bgt.b   loc_FFEE15D5
FFEE15CD  72117eff                          add     #-82h, r1, r1
FFEE15D1  9009                              mov.w   r1, 4+var_2[sp]
FFEE15D3  2e1f                              bra.b   loc_FFEE15F2
FFEE15D5  7601000f                 loc_FFEE15D5 cmp     #0F00h, r1
FFEE15D9  2909                              blt.b   loc_FFEE15E2
FFEE15DB  f90901ff0f                        mov.w   #0FFFh, 4+var_2[sp]
FFEE15E0  2e12                              bra.b   loc_FFEE15F2
FFEE15E2  b809                     loc_FFEE15E2 movu.w  4+var_2[sp], r1
FFEE15E4  7601b90b                          cmp     #0BB9h, r1
FFEE15E8  290a                              blt.b   loc_FFEE15F2
FFEE15EA  b809                              movu.w  4+var_2[sp], r1
FFEE15EC  72110001                          add     #100h, r1, r1
FFEE15F0  9009                              mov.w   r1, 4+var_2[sp]
FFEE15F2  b809                     loc_FFEE15F2 movu.w  4+var_2[sp], r1
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
FFEE162C  fbee009108               loc_FFEE162C mov.l   #89100h, r14
FFEE1631  d5e02301                          mov.w   46h[r14], 4+var_2[sp]
FFEE1635  b809                              movu.w  4+var_2[sp], r1
FFEE1637  755177                            cmp     #77h, r1 ; 'w'
FFEE163A  2a07                              bgt.b   loc_FFEE1641
FFEE163C  3d0100                            mov.w   #0, 4+var_2[sp]
FFEE163F  2e2e                              bra.b   loc_FFEE166D
FFEE1641  b809                     loc_FFEE1641 movu.w  4+var_2[sp], r1
FFEE1643  7601e703                          cmp     #3E7h, r1
FFEE1647  2a09                              bgt.b   loc_FFEE1650
FFEE1649  711188                            add     #-78h, r1, r1
FFEE164C  9009                              mov.w   r1, 4+var_2[sp]
FFEE164E  2e1f                              bra.b   loc_FFEE166D
FFEE1650  7601ec0e                 loc_FFEE1650 cmp     #0EECh, r1
FFEE1654  2909                              blt.b   loc_FFEE165D
FFEE1656  f90901ff0f                        mov.w   #0FFFh, 4+var_2[sp]
FFEE165B  2e12                              bra.b   loc_FFEE166D
FFEE165D  b809                     loc_FFEE165D movu.w  4+var_2[sp], r1
FFEE165F  7601b90b                          cmp     #0BB9h, r1
FFEE1663  290a                              blt.b   loc_FFEE166D
FFEE1665  b809                              movu.w  4+var_2[sp], r1
FFEE1667  72111401                          add     #114h, r1, r1
FFEE166B  9009                              mov.w   r1, 4+var_2[sp]
FFEE166D  b809                     loc_FFEE166D movu.w  4+var_2[sp], r1
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
FFEE16B0  6701                     loc_FFEE16B0 rtsd    #1
FFEE16B2  6040                     sub_FFEE16B2 sub     #4, sp  ; <<< FUNC sub_FFEE16B2
FFEE16B4  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE16BA  f8e400                            mov.b   #0, [r14]
FFEE16BD  3c0300                            mov.b   #0, 4+var_1[sp]
FFEE16C0  2e26                              bra.b   loc_FFEE16E6
FFEE16C2  b089                     loc_FFEE16C2 movu.b  4+var_1[sp], r1
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
FFEE16E6  b089                     loc_FFEE16E6 movu.b  4+var_1[sp], r1
FFEE16E8  6141                              cmp     #4, r1
FFEE16EA  29d8                              blt.b   loc_FFEE16C2
FFEE16EC  6701                              rtsd    #1
FFEE16EE  6080                     sub_FFEE16EE sub     #8, sp  ; <<< FUNC sub_FFEE16EE
FFEE16F0  8189                              mov.b   r1, 8+var_1[sp]
FFEE16F2  3d0100                            mov.w   #0, 8+var_6[sp]
FFEE16F5  3d0200                            mov.w   #0, 8+var_4[sp]
FFEE16F8  fbe2ec240100                      mov.l   #124ECh, r14
FFEE16FE  f8e500                            mov.w   #0, [r14]
FFEE1701  fbf2ea240100                      mov.l   #124EAh, r15
FFEE1707  d0ef                              mov.w   [r14], [r15]
FFEE1709  3c0100                            mov.b   #0, 8+var_7[sp]
FFEE170C  2e30                              bra.b   loc_FFEE173C
FFEE170E  b009                     loc_FFEE170E movu.b  8+var_7[sp], r1
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
FFEE173C  b009                     loc_FFEE173C movu.b  8+var_7[sp], r1
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
FFEE177F  02                                rts

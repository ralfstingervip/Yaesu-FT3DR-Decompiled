; ==== voice_io  FFF12B80-FFF14F80  (file 312B80-314F80) ====
FFF12B80  8589                              mov.b   r1, 20h+var_9[sp]
FFF12B82  8d89                              mov.b   20h+var_9[sp], r1
FFF12B84  6101                              cmp     #0, r1
FFF12B86  10                                beq.s   loc_FFF12B8E
FFF12B87  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF12B8C  2e19                              bra.b   loc_FFF12BA5
FFF12B8E  6604                   loc_FFF12B8E mov.l   #0, r4
FFF12B90  fb3e000010                        mov.l   #100000h, r3
FFF12B95  a882                              mov.l   20h+var_18[sp], r2
FFF12B97  a809                              mov.l   20h+var_1C[sp], r1
FFF12B99  05012c03                          bsr.a   sub_FFF4579A
FFF12B9D  a98a                              mov.l   20h+var_4[sp], r2
FFF12B9F  a0a1                              mov.l   r1, 8[r2]
FFF12BA1  d5000c01                          mov.w   20h+var_8[sp], 20h+var_1E[sp]
FFF12BA5  d500010d               loc_FFF12BA5 mov.w   20h+var_1E[sp], 20h+var_6[sp]
FFF12BA9  bb09                              movu.w  20h+var_6[sp], r1
FFF12BAB  6708                              rtsd    #8
FFF12BAD  60c0                   sub_FFF12BAD sub     #0Ch, sp   ; <<<< FUNC sub_FFF12BAD
FFF12BAF  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF12BB1  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF12BB4  3c0300                            mov.b   #0, 0Ch+var_9[sp]
FFF12BB7  a881                              mov.l   0Ch+var_4[sp], r1
FFF12BB9  05d48401                          bsr.a   sub_FFF2B08D
FFF12BBD  8089                              mov.b   r1, 0Ch+var_9[sp]
FFF12BBF  8889                              mov.b   0Ch+var_9[sp], r1
FFF12BC1  6101                              cmp     #0, r1
FFF12BC3  16                                beq.s   loc_FFF12BC9
FFF12BC4  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF12BC8  0c                                bra.s   loc_FFF12BCC
FFF12BC9  d10002                 loc_FFF12BC9 mov.w   0Ch+var_8[sp], 0Ch+var_C[sp]
FFF12BCC  d40003                 loc_FFF12BCC mov.w   0Ch+var_C[sp], 0Ch+var_6[sp]
FFF12BCF  b889                              movu.w  0Ch+var_6[sp], r1
FFF12BD1  6703                              rtsd    #3
FFF12BD3  60c0                   sub_FFF12BD3 sub     #0Ch, sp   ; <<<< FUNC sub_FFF12BD3
FFF12BD5  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF12BD7  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF12BDA  3c0300                            mov.b   #0, 0Ch+var_9[sp]
FFF12BDD  a881                              mov.l   0Ch+var_4[sp], r1
FFF12BDF  05328b01                          bsr.a   sub_FFF2B711
FFF12BE3  8089                              mov.b   r1, 0Ch+var_9[sp]
FFF12BE5  8889                              mov.b   0Ch+var_9[sp], r1
FFF12BE7  6101                              cmp     #0, r1
FFF12BE9  16                                beq.s   loc_FFF12BEF
FFF12BEA  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF12BEE  0c                                bra.s   loc_FFF12BF2
FFF12BEF  d10002                 loc_FFF12BEF mov.w   0Ch+var_8[sp], 0Ch+var_C[sp]
FFF12BF2  d40003                 loc_FFF12BF2 mov.w   0Ch+var_C[sp], 0Ch+var_6[sp]
FFF12BF5  b889                              movu.w  0Ch+var_6[sp], r1
FFF12BF7  6703                              rtsd    #3
FFF12BF9  7100f0                 sub_FFF12BF9 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF12BF9
FFF12BFC  a089                              mov.l   r1, 10h+var_4[sp]
FFF12BFE  3c0a01                            mov.b   #1, 10h+var_6[sp]
FFF12C01  a889                              mov.l   10h+var_4[sp], r1
FFF12C03  058f8f01                          bsr.a   sub_FFF2BB92
FFF12C07  a009                              mov.l   r1, 10h+var_C[sp]
FFF12C09  a809                              mov.l   10h+var_C[sp], r1
FFF12C0B  6101                              cmp     #0, r1
FFF12C0D  1e                                bne.s   loc_FFF12C13
FFF12C0E  3c0302                            mov.b   #2, 10h+var_D[sp]
FFF12C11  2e0c                              bra.b   loc_FFF12C1D
FFF12C13  a809                   loc_FFF12C13 mov.l   10h+var_C[sp], r1
FFF12C15  05ee9401                          bsr.a   sub_FFF2C103
FFF12C19  c5000a03                          mov.b   10h+var_6[sp], 10h+var_D[sp]
FFF12C1D  c500030b               loc_FFF12C1D mov.b   10h+var_D[sp], 10h+var_5[sp]
FFF12C21  b289                              movu.b  10h+var_5[sp], r1
FFF12C23  6704                              rtsd    #4
FFF12C25  7100e8                 sub_FFF12C25 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12C25
FFF12C28  a109                              mov.l   r1, 18h+var_4[sp]
FFF12C2A  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF12C2D  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12C30  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF12C33  a909                              mov.l   18h+var_4[sp], r1
FFF12C35  5c1e                              movu.w  [r1], r14
FFF12C37  770effff00                        cmp     #0FFFFh, r14
FFF12C3C  11                                beq.s   loc_FFF12C45
FFF12C3D  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12C42  384b01                            bra.w   loc_FFF12D8D
FFF12C45  a909                   loc_FFF12C45 mov.l   18h+var_4[sp], r1
FFF12C47  ba91                              movu.w  14h[r1], r1
FFF12C49  6121                              cmp     #2, r1
FFF12C4B  3a9b00                            beq.w   loc_FFF12CE6
FFF12C4E  6111                              cmp     #1, r1
FFF12C50  204f                              beq.b   loc_FFF12C9F
FFF12C52  6101                              cmp     #0, r1
FFF12C54  3bfc00                            bne.w   loc_FFF12D50
FFF12C57  a909                              mov.l   18h+var_4[sp], r1
FFF12C59  a819                              mov.l   4[r1], r1
FFF12C5B  fb22acadf4ff                      mov.l   #unk_FFF4ADAC, r2
FFF12C61  05e73200                          bsr.a   sub_FFF15F48
FFF12C65  a089                              mov.l   r1, 18h+var_C[sp]
FFF12C67  a889                              mov.l   18h+var_C[sp], r1
FFF12C69  6101                              cmp     #0, r1
FFF12C6B  3be500                            bne.w   loc_FFF12D50
FFF12C6E  a909                              mov.l   18h+var_4[sp], r1
FFF12C70  a819                              mov.l   4[r1], r1
FFF12C72  a88a                              mov.l   18h+var_C[sp], r2
FFF12C74  39a10e                            bsr.w   sub_FFF13B15
FFF12C77  a909                              mov.l   18h+var_4[sp], r1
FFF12C79  a819                              mov.l   4[r1], r1
FFF12C7B  fb22acadf4ff                      mov.l   #unk_FFF4ADAC, r2
FFF12C81  05c73200                          bsr.a   sub_FFF15F48
FFF12C85  a089                              mov.l   r1, 18h+var_C[sp]
FFF12C87  a889                              mov.l   18h+var_C[sp], r1
FFF12C89  6101                              cmp     #0, r1
FFF12C8B  3bc500                            bne.w   loc_FFF12D50
FFF12C8E  a909                              mov.l   18h+var_4[sp], r1
FFF12C90  a819                              mov.l   4[r1], r1
FFF12C92  a88a                              mov.l   18h+var_C[sp], r2
FFF12C94  39810e                            bsr.w   sub_FFF13B15
FFF12C97  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12C9C  38f100                            bra.w   loc_FFF12D8D
FFF12C9F  a909                   loc_FFF12C9F mov.l   18h+var_4[sp], r1
FFF12CA1  a819                              mov.l   4[r1], r1
FFF12CA3  fb22aeadf4ff                      mov.l   #unk_FFF4ADAE, r2
FFF12CA9  059f3200                          bsr.a   sub_FFF15F48
FFF12CAD  a089                              mov.l   r1, 18h+var_C[sp]
FFF12CAF  a889                              mov.l   18h+var_C[sp], r1
FFF12CB1  6101                              cmp     #0, r1
FFF12CB3  3b9d00                            bne.w   loc_FFF12D50
FFF12CB6  a909                              mov.l   18h+var_4[sp], r1
FFF12CB8  a819                              mov.l   4[r1], r1
FFF12CBA  a88a                              mov.l   18h+var_C[sp], r2
FFF12CBC  39590e                            bsr.w   sub_FFF13B15
FFF12CBF  a909                              mov.l   18h+var_4[sp], r1
FFF12CC1  a819                              mov.l   4[r1], r1
FFF12CC3  fb22aeadf4ff                      mov.l   #unk_FFF4ADAE, r2
FFF12CC9  057f3200                          bsr.a   sub_FFF15F48
FFF12CCD  a089                              mov.l   r1, 18h+var_C[sp]
FFF12CCF  a889                              mov.l   18h+var_C[sp], r1
FFF12CD1  6101                              cmp     #0, r1
FFF12CD3  217d                              bne.b   loc_FFF12D50
FFF12CD5  a909                              mov.l   18h+var_4[sp], r1
FFF12CD7  a819                              mov.l   4[r1], r1
FFF12CD9  a88a                              mov.l   18h+var_C[sp], r2
FFF12CDB  393a0e                            bsr.w   sub_FFF13B15
FFF12CDE  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12CE3  38aa00                            bra.w   loc_FFF12D8D
FFF12CE6  a909                   loc_FFF12CE6 mov.l   18h+var_4[sp], r1
FFF12CE8  a819                              mov.l   4[r1], r1
FFF12CEA  fb22b0adf4ff                      mov.l   #unk_FFF4ADB0, r2
FFF12CF0  05583200                          bsr.a   sub_FFF15F48
FFF12CF4  a089                              mov.l   r1, 18h+var_C[sp]
FFF12CF6  a889                              mov.l   18h+var_C[sp], r1
FFF12CF8  6101                              cmp     #0, r1
FFF12CFA  2131                              bne.b   loc_FFF12D2B
FFF12CFC  a909                              mov.l   18h+var_4[sp], r1
FFF12CFE  a819                              mov.l   4[r1], r1
FFF12D00  a88a                              mov.l   18h+var_C[sp], r2
FFF12D02  39130e                            bsr.w   sub_FFF13B15
FFF12D05  a909                              mov.l   18h+var_4[sp], r1
FFF12D07  a819                              mov.l   4[r1], r1
FFF12D09  fb22b0adf4ff                      mov.l   #unk_FFF4ADB0, r2
FFF12D0F  05393200                          bsr.a   sub_FFF15F48
FFF12D13  a089                              mov.l   r1, 18h+var_C[sp]
FFF12D15  a889                              mov.l   18h+var_C[sp], r1
FFF12D17  6101                              cmp     #0, r1
FFF12D19  2112                              bne.b   loc_FFF12D2B
FFF12D1B  a909                              mov.l   18h+var_4[sp], r1
FFF12D1D  a819                              mov.l   4[r1], r1
FFF12D1F  a88a                              mov.l   18h+var_C[sp], r2
FFF12D21  39f40d                            bsr.w   sub_FFF13B15
FFF12D24  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12D29  2e64                              bra.b   loc_FFF12D8D
FFF12D2B  a909                   loc_FFF12D2B mov.l   18h+var_4[sp], r1
FFF12D2D  a892                              mov.l   8[r1], r2
FFF12D2F  a889                              mov.l   18h+var_C[sp], r1
FFF12D31  6603                              mov.l   #0, r3
FFF12D33  051c6600                          bsr.a   sub_FFF1934F
FFF12D37  a009                              mov.l   r1, 18h+var_14[sp]
FFF12D39  a809                              mov.l   18h+var_14[sp], r1
FFF12D3B  7501ff                            cmp     #-1, r1
FFF12D3E  2112                              bne.b   loc_FFF12D50
FFF12D40  a909                              mov.l   18h+var_4[sp], r1
FFF12D42  a819                              mov.l   4[r1], r1
FFF12D44  a88a                              mov.l   18h+var_C[sp], r2
FFF12D46  39cf0d                            bsr.w   sub_FFF13B15
FFF12D49  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12D4E  2e3f                              bra.b   loc_FFF12D8D
FFF12D50  a909                   loc_FFF12D50 mov.l   18h+var_4[sp], r1
FFF12D52  a913                              mov.l   10h[r1], r3
FFF12D54  a899                              mov.l   0Ch[r1], r1
FFF12D56  a88c                              mov.l   18h+var_C[sp], r4
FFF12D58  6612                              mov.l   #1, r2
FFF12D5A  05b65700                          bsr.a   sub_FFF18510
FFF12D5E  a081                              mov.l   r1, 18h+var_10[sp]
FFF12D60  a909                              mov.l   18h+var_4[sp], r1
FFF12D62  a882                              mov.l   18h+var_10[sp], r2
FFF12D64  06851204                          cmp     10h[r1].l, r2
FFF12D68  2012                              beq.b   loc_FFF12D7A
FFF12D6A  a909                              mov.l   18h+var_4[sp], r1
FFF12D6C  a819                              mov.l   4[r1], r1
FFF12D6E  a88a                              mov.l   18h+var_C[sp], r2
FFF12D70  39a50d                            bsr.w   sub_FFF13B15
FFF12D73  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12D78  2e15                              bra.b   loc_FFF12D8D
FFF12D7A  a889                   loc_FFF12D7A mov.l   18h+var_C[sp], r1
FFF12D7C  05ac4400                          bsr.a   sub_FFF17228
FFF12D80  a909                              mov.l   18h+var_4[sp], r1
FFF12D82  a819                              mov.l   4[r1], r1
FFF12D84  a88a                              mov.l   18h+var_C[sp], r2
FFF12D86  398f0d                            bsr.w   sub_FFF13B15
FFF12D89  d5000801                          mov.w   18h+var_8[sp], 18h+var_16[sp]
FFF12D8D  d5000109               loc_FFF12D8D mov.w   18h+var_16[sp], 18h+var_6[sp]
FFF12D91  ba09                              movu.w  18h+var_6[sp], r1
FFF12D93  6706                              rtsd    #6
FFF12D95  7100ec                 sub_FFF12D95 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF12D95
FFF12D98  a101                              mov.l   r1, 14h+var_4[sp]
FFF12D9A  3d0600                            mov.w   #0, 14h+var_8[sp]
FFF12D9D  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF12DA0  a901                              mov.l   14h+var_4[sp], r1
FFF12DA2  5c1e                              movu.w  [r1], r14
FFF12DA4  770effff00                        cmp     #0FFFFh, r14
FFF12DA9  11                                beq.s   loc_FFF12DB2
FFF12DAA  f90903ffff                        mov.w   #-1, 14h+var_E[sp]
FFF12DAF  38d400                            bra.w   loc_FFF12E83
FFF12DB2  a901                   loc_FFF12DB2 mov.l   14h+var_4[sp], r1
FFF12DB4  ba91                              movu.w  14h[r1], r1
FFF12DB6  6151                              cmp     #5, r1
FFF12DB8  216b                              bne.b   loc_FFF12E23
FFF12DBA  a901                              mov.l   14h+var_4[sp], r1
FFF12DBC  a819                              mov.l   4[r1], r1
FFF12DBE  fb22acadf4ff                      mov.l   #unk_FFF4ADAC, r2
FFF12DC4  05843100                          bsr.a   sub_FFF15F48
FFF12DC8  fbe274f20100                      mov.l   #1F274h, r14
FFF12DCE  e3e1                              mov.l   r1, [r14]
FFF12DD0  fbe274f20100                      mov.l   #1F274h, r14
FFF12DD6  ecee                              mov.l   [r14], r14
FFF12DD8  610e                              cmp     #0, r14
FFF12DDA  2149                              bne.b   loc_FFF12E23
FFF12DDC  fbe274f20100                      mov.l   #1F274h, r14
FFF12DE2  ece2                              mov.l   [r14], r2
FFF12DE4  a901                              mov.l   14h+var_4[sp], r1
FFF12DE6  a819                              mov.l   4[r1], r1
FFF12DE8  392d0d                            bsr.w   sub_FFF13B15
FFF12DEB  a901                              mov.l   14h+var_4[sp], r1
FFF12DED  a819                              mov.l   4[r1], r1
FFF12DEF  fb22acadf4ff                      mov.l   #unk_FFF4ADAC, r2
FFF12DF5  05533100                          bsr.a   sub_FFF15F48
FFF12DF9  fbe274f20100                      mov.l   #1F274h, r14
FFF12DFF  e3e1                              mov.l   r1, [r14]
FFF12E01  fbe274f20100                      mov.l   #1F274h, r14
FFF12E07  ecee                              mov.l   [r14], r14
FFF12E09  610e                              cmp     #0, r14
FFF12E0B  2118                              bne.b   loc_FFF12E23
FFF12E0D  fbe274f20100                      mov.l   #1F274h, r14
FFF12E13  ece2                              mov.l   [r14], r2
FFF12E15  a901                              mov.l   14h+var_4[sp], r1
FFF12E17  a819                              mov.l   4[r1], r1
FFF12E19  39fc0c                            bsr.w   sub_FFF13B15
FFF12E1C  f90903ffff                        mov.w   #-1, 14h+var_E[sp]
FFF12E21  2e62                              bra.b   loc_FFF12E83
FFF12E23  fbe274f20100           loc_FFF12E23 mov.l   #1F274h, r14
FFF12E29  ece4                              mov.l   [r14], r4
FFF12E2B  a901                              mov.l   14h+var_4[sp], r1
FFF12E2D  a913                              mov.l   10h[r1], r3
FFF12E2F  a899                              mov.l   0Ch[r1], r1
FFF12E31  6612                              mov.l   #1, r2
FFF12E33  05dd5600                          bsr.a   sub_FFF18510
FFF12E37  a081                              mov.l   r1, 14h+var_C[sp]
FFF12E39  a901                              mov.l   14h+var_4[sp], r1
FFF12E3B  a882                              mov.l   14h+var_C[sp], r2
FFF12E3D  06851204                          cmp     10h[r1].l, r2
FFF12E41  2016                              beq.b   loc_FFF12E57
FFF12E43  fbe274f20100                      mov.l   #1F274h, r14
FFF12E49  ece2                              mov.l   [r14], r2
FFF12E4B  a819                              mov.l   4[r1], r1
FFF12E4D  39c80c                            bsr.w   sub_FFF13B15
FFF12E50  f90903ffff                        mov.w   #-1, 14h+var_E[sp]
FFF12E55  2e2e                              bra.b   loc_FFF12E83
FFF12E57  ba91                   loc_FFF12E57 movu.w  14h[r1], r1
FFF12E59  6181                              cmp     #8, r1
FFF12E5B  10                                beq.s   loc_FFF12E63
FFF12E5C  a901                              mov.l   14h+var_4[sp], r1
FFF12E5E  ba91                              movu.w  14h[r1], r1
FFF12E60  6191                              cmp     #9, r1
FFF12E62  1d                                bne.s   loc_FFF12E67
FFF12E63  f80601                 loc_FFF12E63 mov.l   #1, 14h+var_14[sp]
FFF12E66  0c                                bra.s   loc_FFF12E6A
FFF12E67  f80600                 loc_FFF12E67 mov.l   #0, 14h+var_14[sp]
FFF12E6A  ec01                   loc_FFF12E6A mov.l   14h+var_14[sp], r1
FFF12E6C  6101                              cmp     #0, r1
FFF12E6E  2011                              beq.b   loc_FFF12E7F
FFF12E70  fbe274f20100                      mov.l   #1F274h, r14
FFF12E76  ece2                              mov.l   [r14], r2
FFF12E78  a901                              mov.l   14h+var_4[sp], r1
FFF12E7A  a819                              mov.l   4[r1], r1
FFF12E7C  39990c                            bsr.w   sub_FFF13B15
FFF12E7F  d5000603               loc_FFF12E7F mov.w   14h+var_8[sp], 14h+var_E[sp]
FFF12E83  d5000307               loc_FFF12E83 mov.w   14h+var_E[sp], 14h+var_6[sp]
FFF12E87  b989                              movu.w  14h+var_6[sp], r1
FFF12E89  6705                              rtsd    #5
FFF12E8B  7100e8                 sub_FFF12E8B add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12E8B
FFF12E8E  a109                              mov.l   r1, 18h+var_4[sp]
FFF12E90  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF12E93  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12E96  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF12E99  a909                              mov.l   18h+var_4[sp], r1
FFF12E9B  5c1e                              movu.w  [r1], r14
FFF12E9D  610e                              cmp     #0, r14
FFF12E9F  11                                beq.s   loc_FFF12EA8
FFF12EA0  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12EA5  38ee00                            bra.w   loc_FFF12F93
FFF12EA8  a909                   loc_FFF12EA8 mov.l   18h+var_4[sp], r1
FFF12EAA  ba91                              movu.w  14h[r1], r1
FFF12EAC  6111                              cmp     #1, r1
FFF12EAE  204e                              beq.b   loc_FFF12EFC
FFF12EB0  6101                              cmp     #0, r1
FFF12EB2  3bb400                            bne.w   loc_FFF12F66
FFF12EB5  a909                              mov.l   18h+var_4[sp], r1
FFF12EB7  a819                              mov.l   4[r1], r1
FFF12EB9  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF12EBF  05893000                          bsr.a   sub_FFF15F48
FFF12EC3  a089                              mov.l   r1, 18h+var_C[sp]
FFF12EC5  a889                              mov.l   18h+var_C[sp], r1
FFF12EC7  6101                              cmp     #0, r1
FFF12EC9  3b9d00                            bne.w   loc_FFF12F66
FFF12ECC  a909                              mov.l   18h+var_4[sp], r1
FFF12ECE  a819                              mov.l   4[r1], r1
FFF12ED0  a88a                              mov.l   18h+var_C[sp], r2
FFF12ED2  39430c                            bsr.w   sub_FFF13B15
FFF12ED5  a909                              mov.l   18h+var_4[sp], r1
FFF12ED7  a819                              mov.l   4[r1], r1
FFF12ED9  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF12EDF  05693000                          bsr.a   sub_FFF15F48
FFF12EE3  a089                              mov.l   r1, 18h+var_C[sp]
FFF12EE5  a889                              mov.l   18h+var_C[sp], r1
FFF12EE7  6101                              cmp     #0, r1
FFF12EE9  217d                              bne.b   loc_FFF12F66
FFF12EEB  a909                              mov.l   18h+var_4[sp], r1
FFF12EED  a819                              mov.l   4[r1], r1
FFF12EEF  a88a                              mov.l   18h+var_C[sp], r2
FFF12EF1  39240c                            bsr.w   sub_FFF13B15
FFF12EF4  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12EF9  389a00                            bra.w   loc_FFF12F93
FFF12EFC  a909                   loc_FFF12EFC mov.l   18h+var_4[sp], r1
FFF12EFE  a819                              mov.l   4[r1], r1
FFF12F00  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF12F06  05423000                          bsr.a   sub_FFF15F48
FFF12F0A  a089                              mov.l   r1, 18h+var_C[sp]
FFF12F0C  a889                              mov.l   18h+var_C[sp], r1
FFF12F0E  6101                              cmp     #0, r1
FFF12F10  2131                              bne.b   loc_FFF12F41
FFF12F12  a909                              mov.l   18h+var_4[sp], r1
FFF12F14  a819                              mov.l   4[r1], r1
FFF12F16  a88a                              mov.l   18h+var_C[sp], r2
FFF12F18  39fd0b                            bsr.w   sub_FFF13B15
FFF12F1B  a909                              mov.l   18h+var_4[sp], r1
FFF12F1D  a819                              mov.l   4[r1], r1
FFF12F1F  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF12F25  05233000                          bsr.a   sub_FFF15F48
FFF12F29  a089                              mov.l   r1, 18h+var_C[sp]
FFF12F2B  a889                              mov.l   18h+var_C[sp], r1
FFF12F2D  6101                              cmp     #0, r1
FFF12F2F  2112                              bne.b   loc_FFF12F41
FFF12F31  a909                              mov.l   18h+var_4[sp], r1
FFF12F33  a819                              mov.l   4[r1], r1
FFF12F35  a88a                              mov.l   18h+var_C[sp], r2
FFF12F37  39de0b                            bsr.w   sub_FFF13B15
FFF12F3A  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F3F  2e54                              bra.b   loc_FFF12F93
FFF12F41  a909                   loc_FFF12F41 mov.l   18h+var_4[sp], r1
FFF12F43  a892                              mov.l   8[r1], r2
FFF12F45  a889                              mov.l   18h+var_C[sp], r1
FFF12F47  6603                              mov.l   #0, r3
FFF12F49  05066400                          bsr.a   sub_FFF1934F
FFF12F4D  a009                              mov.l   r1, 18h+var_14[sp]
FFF12F4F  a809                              mov.l   18h+var_14[sp], r1
FFF12F51  7501ff                            cmp     #-1, r1
FFF12F54  2112                              bne.b   loc_FFF12F66
FFF12F56  a909                              mov.l   18h+var_4[sp], r1
FFF12F58  a819                              mov.l   4[r1], r1
FFF12F5A  a88a                              mov.l   18h+var_C[sp], r2
FFF12F5C  39b90b                            bsr.w   sub_FFF13B15
FFF12F5F  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F64  2e2f                              bra.b   loc_FFF12F93
FFF12F66  a909                   loc_FFF12F66 mov.l   18h+var_4[sp], r1
FFF12F68  a913                              mov.l   10h[r1], r3
FFF12F6A  a899                              mov.l   0Ch[r1], r1
FFF12F6C  a88c                              mov.l   18h+var_C[sp], r4
FFF12F6E  6612                              mov.l   #1, r2
FFF12F70  053f4f00                          bsr.a   sub_FFF17EAF
FFF12F74  a081                              mov.l   r1, 18h+var_10[sp]
FFF12F76  a909                              mov.l   18h+var_4[sp], r1
FFF12F78  a882                              mov.l   18h+var_10[sp], r2
FFF12F7A  06851204                          cmp     10h[r1].l, r2
FFF12F7E  a819                              mov.l   4[r1], r1
FFF12F80  a88a                              mov.l   18h+var_C[sp], r2
FFF12F82  12                                beq.s   loc_FFF12F8C
FFF12F83  39920b                            bsr.w   sub_FFF13B15
FFF12F86  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F8B  08                                bra.s   loc_FFF12F93
FFF12F8C  39890b                 loc_FFF12F8C bsr.w   sub_FFF13B15
FFF12F8F  d5000801                          mov.w   18h+var_8[sp], 18h+var_16[sp]
FFF12F93  d5000109               loc_FFF12F93 mov.w   18h+var_16[sp], 18h+var_6[sp]
FFF12F97  ba09                              movu.w  18h+var_6[sp], r1
FFF12F99  6706                              rtsd    #6
FFF12F9B  7100e8                 sub_FFF12F9B add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12F9B
FFF12F9E  a109                              mov.l   r1, 18h+var_4[sp]
FFF12FA0  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF12FA3  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF12FA6  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12FA9  a909                              mov.l   18h+var_4[sp], r1
FFF12FAB  5c1e                              movu.w  [r1], r14
FFF12FAD  610e                              cmp     #0, r14
FFF12FAF  11                                beq.s   loc_FFF12FB8
FFF12FB0  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF12FB5  383601                            bra.w   loc_FFF130EB
FFF12FB8  a909                   loc_FFF12FB8 mov.l   18h+var_4[sp], r1
FFF12FBA  ba91                              movu.w  14h[r1], r1
FFF12FBC  61d1                              cmp     #0Dh, r1
FFF12FBE  11                                beq.s   loc_FFF12FC7
FFF12FBF  a909                              mov.l   18h+var_4[sp], r1
FFF12FC1  ba91                              movu.w  14h[r1], r1
FFF12FC3  755110                            cmp     #10h, r1
FFF12FC6  1d                                bne.s   loc_FFF12FCB
FFF12FC7  f80601                 loc_FFF12FC7 mov.l   #1, 18h+var_18[sp]
FFF12FCA  0c                                bra.s   loc_FFF12FCE
FFF12FCB  f80600                 loc_FFF12FCB mov.l   #0, 18h+var_18[sp]
FFF12FCE  ec01                   loc_FFF12FCE mov.l   18h+var_18[sp], r1
FFF12FD0  6101                              cmp     #0, r1
FFF12FD2  206c                              beq.b   loc_FFF1303E
FFF12FD4  a909                              mov.l   18h+var_4[sp], r1
FFF12FD6  a819                              mov.l   4[r1], r1
FFF12FD8  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF12FDE  056a2f00                          bsr.a   sub_FFF15F48
FFF12FE2  fbe274f20100                      mov.l   #1F274h, r14
FFF12FE8  e3e1                              mov.l   r1, [r14]
FFF12FEA  fbe274f20100                      mov.l   #1F274h, r14
FFF12FF0  ecee                              mov.l   [r14], r14
FFF12FF2  610e                              cmp     #0, r14
FFF12FF4  214a                              bne.b   loc_FFF1303E
FFF12FF6  fbe274f20100                      mov.l   #1F274h, r14
FFF12FFC  ece2                              mov.l   [r14], r2
FFF12FFE  a909                              mov.l   18h+var_4[sp], r1
FFF13000  a819                              mov.l   4[r1], r1
FFF13002  39130b                            bsr.w   sub_FFF13B15
FFF13005  a909                              mov.l   18h+var_4[sp], r1
FFF13007  a819                              mov.l   4[r1], r1
FFF13009  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF1300F  05392f00                          bsr.a   sub_FFF15F48
FFF13013  fbe274f20100                      mov.l   #1F274h, r14
FFF13019  e3e1                              mov.l   r1, [r14]
FFF1301B  fbe274f20100                      mov.l   #1F274h, r14
FFF13021  ecee                              mov.l   [r14], r14
FFF13023  610e                              cmp     #0, r14
FFF13025  2119                              bne.b   loc_FFF1303E
FFF13027  fbe274f20100                      mov.l   #1F274h, r14
FFF1302D  ece2                              mov.l   [r14], r2
FFF1302F  a909                              mov.l   18h+var_4[sp], r1
FFF13031  a819                              mov.l   4[r1], r1
FFF13033  39e20a                            bsr.w   sub_FFF13B15
FFF13036  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF1303B  38b000                            bra.w   loc_FFF130EB
FFF1303E  a909                   loc_FFF1303E mov.l   18h+var_4[sp], r1
FFF13040  ba91                              movu.w  14h[r1], r1
FFF13042  61e1                              cmp     #0Eh, r1
FFF13044  11                                beq.s   loc_FFF1304D
FFF13045  a909                              mov.l   18h+var_4[sp], r1
FFF13047  ba91                              movu.w  14h[r1], r1
FFF13049  755110                            cmp     #10h, r1
FFF1304C  1d                                bne.s   loc_FFF13051
FFF1304D  f80601                 loc_FFF1304D mov.l   #1, 18h+var_18[sp]
FFF13050  0c                                bra.s   loc_FFF13054
FFF13051  f80600                 loc_FFF13051 mov.l   #0, 18h+var_18[sp]
FFF13054  ec01                   loc_FFF13054 mov.l   18h+var_18[sp], r1
FFF13056  6101                              cmp     #0, r1
FFF13058  18                                bne.s   loc_FFF13060
FFF13059  a909                              mov.l   18h+var_4[sp], r1
FFF1305B  ba91                              movu.w  14h[r1], r1
FFF1305D  61f1                              cmp     #0Fh, r1
FFF1305F  1d                                bne.s   loc_FFF13064
FFF13060  f80601                 loc_FFF13060 mov.l   #1, 18h+var_18[sp]
FFF13063  0c                                bra.s   loc_FFF13067
FFF13064  f80600                 loc_FFF13064 mov.l   #0, 18h+var_18[sp]
FFF13067  ec01                   loc_FFF13067 mov.l   18h+var_18[sp], r1
FFF13069  6101                              cmp     #0, r1
FFF1306B  2033                              beq.b   loc_FFF1309E
FFF1306D  a909                              mov.l   18h+var_4[sp], r1
FFF1306F  a892                              mov.l   8[r1], r2
FFF13071  fbe274f20100                      mov.l   #1F274h, r14
FFF13077  ece1                              mov.l   [r14], r1
FFF13079  6603                              mov.l   #0, r3
FFF1307B  05d46200                          bsr.a   sub_FFF1934F
FFF1307F  a081                              mov.l   r1, 18h+var_10[sp]
FFF13081  a881                              mov.l   18h+var_10[sp], r1
FFF13083  7501ff                            cmp     #-1, r1
FFF13086  2118                              bne.b   loc_FFF1309E
FFF13088  fbe274f20100                      mov.l   #1F274h, r14
FFF1308E  ece2                              mov.l   [r14], r2
FFF13090  a909                              mov.l   18h+var_4[sp], r1
FFF13092  a819                              mov.l   4[r1], r1
FFF13094  39810a                            bsr.w   sub_FFF13B15
FFF13097  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF1309C  2e4f                              bra.b   loc_FFF130EB
FFF1309E  fbe274f20100           loc_FFF1309E mov.l   #1F274h, r14
FFF130A4  ece4                              mov.l   [r14], r4
FFF130A6  a909                              mov.l   18h+var_4[sp], r1
FFF130A8  a913                              mov.l   10h[r1], r3
FFF130AA  a899                              mov.l   0Ch[r1], r1
FFF130AC  6612                              mov.l   #1, r2
FFF130AE  05014e00                          bsr.a   sub_FFF17EAF
FFF130B2  a089                              mov.l   r1, 18h+var_C[sp]
FFF130B4  a909                              mov.l   18h+var_4[sp], r1
FFF130B6  a88a                              mov.l   18h+var_C[sp], r2
FFF130B8  06851204                          cmp     10h[r1].l, r2
FFF130BC  2016                              beq.b   loc_FFF130D2
FFF130BE  fbe274f20100                      mov.l   #1F274h, r14
FFF130C4  ece2                              mov.l   [r14], r2
FFF130C6  a819                              mov.l   4[r1], r1
FFF130C8  394d0a                            bsr.w   sub_FFF13B15
FFF130CB  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF130D0  2e1b                              bra.b   loc_FFF130EB
FFF130D2  ba91                   loc_FFF130D2 movu.w  14h[r1], r1
FFF130D4  61f1                              cmp     #0Fh, r1
FFF130D6  2111                              bne.b   loc_FFF130E7
FFF130D8  fbe274f20100                      mov.l   #1F274h, r14
FFF130DE  ece2                              mov.l   [r14], r2
FFF130E0  a909                              mov.l   18h+var_4[sp], r1
FFF130E2  a819                              mov.l   4[r1], r1
FFF130E4  39310a                            bsr.w   sub_FFF13B15
FFF130E7  d5000803               loc_FFF130E7 mov.w   18h+var_8[sp], 18h+var_12[sp]
FFF130EB  d5000309               loc_FFF130EB mov.w   18h+var_12[sp], 18h+var_6[sp]
FFF130EF  ba09                              movu.w  18h+var_6[sp], r1
FFF130F1  6706                              rtsd    #6
FFF130F3  7100e8                 sub_FFF130F3 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF130F3
FFF130F6  a109                              mov.l   r1, 18h+var_4[sp]
FFF130F8  a102                              mov.l   r2, 18h+var_8[sp]
FFF130FA  3d0600                            mov.w   #0, 18h+var_C[sp]
FFF130FD  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF13100  3c0300                            mov.b   #0, 18h+var_15[sp]
FFF13103  a909                              mov.l   18h+var_4[sp], r1
FFF13105  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF1310B  053d2e00                          bsr.a   sub_FFF15F48
FFF1310F  a009                              mov.l   r1, 18h+var_14[sp]
FFF13111  a809                              mov.l   18h+var_14[sp], r1
FFF13113  6101                              cmp     #0, r1
FFF13115  210f                              bne.b   loc_FFF13124
FFF13117  a80a                              mov.l   18h+var_14[sp], r2
FFF13119  a909                              mov.l   18h+var_4[sp], r1
FFF1311B  39fa09                            bsr.w   sub_FFF13B15
FFF1311E  f809ffff                          mov.w   #-1, 18h+var_18[sp]
FFF13122  2e30                              bra.b   loc_FFF13152
FFF13124  a809                   loc_FFF13124 mov.l   18h+var_14[sp], r1
FFF13126  710208                            add     #18h+var_10, sp, r2
FFF13129  05a65a01                          bsr.a   sub_FFF28BCF
FFF1312D  8089                              mov.b   r1, 18h+var_15[sp]
FFF1312F  8889                              mov.b   18h+var_15[sp], r1
FFF13131  6101                              cmp     #0, r1
FFF13133  200f                              beq.b   loc_FFF13142
FFF13135  a80a                              mov.l   18h+var_14[sp], r2
FFF13137  a909                              mov.l   18h+var_4[sp], r1
FFF13139  39dc09                            bsr.w   sub_FFF13B15
FFF1313C  f809ffff                          mov.w   #-1, 18h+var_18[sp]
FFF13140  2e12                              bra.b   loc_FFF13152
FFF13142  a881                   loc_FFF13142 mov.l   18h+var_10[sp], r1
FFF13144  a902                              mov.l   18h+var_8[sp], r2
FFF13146  e321                              mov.l   r1, [r2]
FFF13148  a80a                              mov.l   18h+var_14[sp], r2
FFF1314A  a909                              mov.l   18h+var_4[sp], r1
FFF1314C  39c909                            bsr.w   sub_FFF13B15
FFF1314F  d10006                            mov.w   18h+var_C[sp], 18h+var_18[sp]
FFF13152  d40007                 loc_FFF13152 mov.w   18h+var_18[sp], 18h+var_A[sp]
FFF13155  b989                              movu.w  18h+var_A[sp], r1
FFF13157  6706                              rtsd    #6
FFF13159  7100f0                 sub_FFF13159 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF13159
FFF1315C  a089                              mov.l   r1, 10h+var_4[sp]
FFF1315E  a082                              mov.l   r2, 10h+var_8[sp]
FFF13160  3d0200                            mov.w   #0, 10h+var_C[sp]
FFF13163  3c0300                            mov.b   #0, 10h+var_D[sp]
FFF13166  a882                              mov.l   10h+var_8[sp], r2
FFF13168  a889                              mov.l   10h+var_4[sp], r1
FFF1316A  05e86a00                          bsr.a   sub_FFF19C52
FFF1316E  8089                              mov.b   r1, 10h+var_D[sp]
FFF13170  8889                              mov.b   10h+var_D[sp], r1
FFF13172  6101                              cmp     #0, r1
FFF13174  16                                beq.s   loc_FFF1317A
FFF13175  f809ffff                          mov.w   #-1, 10h+var_10[sp]
FFF13179  0c                                bra.s   loc_FFF1317D
FFF1317A  d10002                 loc_FFF1317A mov.w   10h+var_C[sp], 10h+var_10[sp]
FFF1317D  d40003                 loc_FFF1317D mov.w   10h+var_10[sp], 10h+var_A[sp]
FFF13180  b889                              movu.w  10h+var_A[sp], r1
FFF13182  6704                              rtsd    #4
FFF13184  60c0                   sub_FFF13184 sub     #0Ch, sp   ; <<<< FUNC sub_FFF13184
FFF13186  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF13188  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF1318B  3c0300                            mov.b   #0, 0Ch+var_9[sp]
FFF1318E  a881                              mov.l   0Ch+var_4[sp], r1
FFF13190  05f17100                          bsr.a   sub_FFF1A381
FFF13194  8089                              mov.b   r1, 0Ch+var_9[sp]
FFF13196  8889                              mov.b   0Ch+var_9[sp], r1
FFF13198  6101                              cmp     #0, r1
FFF1319A  16                                beq.s   loc_FFF131A0
FFF1319B  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF1319F  0c                                bra.s   loc_FFF131A3
FFF131A0  d10002                 loc_FFF131A0 mov.w   0Ch+var_8[sp], 0Ch+var_C[sp]
FFF131A3  d40003                 loc_FFF131A3 mov.w   0Ch+var_C[sp], 0Ch+var_6[sp]
FFF131A6  b889                              movu.w  0Ch+var_6[sp], r1
FFF131A8  6703                              rtsd    #3
FFF131AA  7100e0                 sub_FFF131AA add     #-20h, sp, sp   ; <<<< FUNC sub_FFF131AA
FFF131AD  a189                              mov.l   r1, 20h+var_4[sp]
FFF131AF  a182                              mov.l   r2, 20h+var_8[sp]
FFF131B1  a10b                              mov.l   r3, 20h+var_C[sp]
FFF131B3  3d0800                            mov.w   #0, 20h+var_10[sp]
FFF131B6  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF131B9  fbe224ee0100                      mov.l   #1EE24h, r14
FFF131BF  5cee                              movu.w  [r14], r14
FFF131C1  612e                              cmp     #2, r14
FFF131C3  19                                bne.s   loc_FFF131CC
FFF131C4  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF131C9  38d600                            bra.w   loc_FFF1329F
FFF131CC  a989                   loc_FFF131CC mov.l   20h+var_4[sp], r1
FFF131CE  71020c                            add     #20h+var_14, sp, r2
FFF131D1  3922ff                            bsr.w   sub_FFF130F3
FFF131D4  9201                              mov.w   r1, 20h+var_10[sp]
FFF131D6  ba01                              movu.w  20h+var_10[sp], r1
FFF131D8  6101                              cmp     #0, r1
FFF131DA  11                                beq.s   loc_FFF131E3
FFF131DB  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF131E0  38bf00                            bra.w   loc_FFF1329F
FFF131E3  a989                   loc_FFF131E3 mov.l   20h+var_4[sp], r1
FFF131E5  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF131EB  055d2d00                          bsr.a   sub_FFF15F48
FFF131EF  a081                              mov.l   r1, 20h+var_18[sp]
FFF131F1  a881                              mov.l   20h+var_18[sp], r1
FFF131F3  6101                              cmp     #0, r1
FFF131F5  2110                              bne.b   loc_FFF13205
FFF131F7  a881                              mov.l   20h+var_18[sp], r1
FFF131F9  05213c00                          bsr.a   sub_FFF16E1A
FFF131FD  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF13202  389d00                            bra.w   loc_FFF1329F
FFF13205  a989                   loc_FFF13205 mov.l   20h+var_4[sp], r1
FFF13207  39c00e                            bsr.w   sub_FFF140C7
FFF1320A  fb1224ee0100                      mov.l   #1EE24h, r1
FFF13210  72111c02                          add     #21Ch, r1, r1
FFF13214  fb22aeadf4ff                      mov.l   #unk_FFF4ADAE, r2
FFF1321A  052e2d00                          bsr.a   sub_FFF15F48
FFF1321E  a009                              mov.l   r1, 20h+var_1C[sp]
FFF13220  a809                              mov.l   20h+var_1C[sp], r1
FFF13222  6101                              cmp     #0, r1
FFF13224  210f                              bne.b   loc_FFF13233
FFF13226  a809                              mov.l   20h+var_1C[sp], r1
FFF13228  05f23b00                          bsr.a   sub_FFF16E1A
FFF1322C  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF13231  2e6e                              bra.b   loc_FFF1329F
FFF13233  fb1224ee0100           loc_FFF13233 mov.l   #1EE24h, r1
FFF13239  6221                              add     #2, r1
FFF1323B  fb36ff                            mov.l   #-1, r3
FFF1323E  a98a                              mov.l   20h+var_4[sp], r2
FFF13240  7f87                              smovu
FFF13242  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13248  f8e502                            mov.w   #2, [r14]
FFF1324B  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13251  e50e0341                          mov.l   20h+var_14[sp], 104h[r14]
FFF13255  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1325B  f9e64600                          mov.l   #0, 118h[r14]
FFF1325F  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13265  e50e02c7                          mov.l   20h+var_18[sp], 31Ch[r14]
FFF13269  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1326F  e50e01c8                          mov.l   20h+var_1C[sp], 320h[r14]
FFF13273  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13279  f9e6e90a                          mov.l   #0Ah, 3A4h[r14]
FFF1327D  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13283  e50e06ea                          mov.l   20h+var_8[sp], 3A8h[r14]
FFF13287  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1328D  f9e6eb00                          mov.l   #0, 3ACh[r14]
FFF13291  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13297  e50e05ec                          mov.l   20h+var_C[sp], 3B0h[r14]
FFF1329B  d5000801                          mov.w   20h+var_10[sp], 20h+var_1E[sp]
FFF1329F  d5000109               loc_FFF1329F mov.w   20h+var_1E[sp], 20h+var_E[sp]
FFF132A3  ba09                              movu.w  20h+var_E[sp], r1
FFF132A5  6708                              rtsd    #8
FFF132A7  7100ec                 sub_FFF132A7 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF132A7
FFF132AA  fbe224ee0100                      mov.l   #1EE24h, r14
FFF132B0  5cee                              movu.w  [r14], r14
FFF132B2  612e                              cmp     #2, r14
FFF132B4  1c                                bne.s   loc_FFF132B8
FFF132B5  39ba02                            bsr.w   sub_FFF1356F
FFF132B8  fbe2b8930600           loc_FFF132B8 mov.l   #693B8h, r14
FFF132BE  5cee                              movu.w  [r14], r14
FFF132C0  612e                              cmp     #2, r14
FFF132C2  1c                                bne.s   loc_FFF132C6
FFF132C3  394305                            bsr.w   sub_FFF13806
FFF132C6  fbe293220100           loc_FFF132C6 mov.l   #12293h, r14
FFF132CC  58ee                              movu.b  [r14], r14
FFF132CE  610e                              cmp     #0, r14
FFF132D0  2b3b                              ble.b   loc_FFF1330B
FFF132D2  ef01                              mov.l   sp, r1
FFF132D4  39440d                            bsr.w   sub_FFF14018
FFF132D7  5c01                              movu.w  14h+var_14[sp], r1
FFF132D9  6111                              cmp     #1, r1
FFF132DB  201b                              beq.b   loc_FFF132F6
FFF132DD  6101                              cmp     #0, r1
FFF132DF  212c                              bne.b   loc_FFF1330B
FFF132E1  7100ec                            add     #-14h, sp, sp
FFF132E4  754314                            mov.l   #14h, r3
FFF132E7  710214                            add     #28h+var_14, sp, r2
FFF132EA  ef01                              mov.l   sp, r1
FFF132EC  7f8f                              smovf
FFF132EE  391f00                            bsr.w   sub_FFF1330D
FFF132F1  710014                            add     #14h, sp, sp
FFF132F4  6705                              rtsd    #5
FFF132F6  7100ec                 loc_FFF132F6 add     #-14h, sp, sp
FFF132F9  754314                            mov.l   #14h, r3
FFF132FC  710214                            add     #28h+var_14, sp, r2
FFF132FF  ef01                              mov.l   sp, r1
FFF13301  7f8f                              smovf
FFF13303  394601                            bsr.w   sub_FFF13449
FFF13306  710014                            add     #14h, sp, sp
FFF13309  6705                              rtsd    #5
FFF1330B  6705                   loc_FFF1330B rtsd    #5
FFF1330D  60c0                   sub_FFF1330D sub     #0Ch, sp   ; <<<< FUNC sub_FFF1330D
FFF1330F  3d0500                            mov.w   #0, 0Ch+var_2[sp]
FFF13312  3d0400                            mov.w   #0, 0Ch+var_4[sp]
FFF13315  710110                            add     #0Ch+arg_0, sp, r1
FFF13318  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF1331B  fbe20cee0100                      mov.l   #1EE0Ch, r14
FFF13321  f8e500                            mov.w   #0, [r14]
FFF13324  fbe20cee0100                      mov.l   #1EE0Ch, r14
FFF1332A  e51e0101                          mov.l   4[r1], 4[r14]
FFF1332E  fbe20cee0100                      mov.l   #1EE0Ch, r14
FFF13334  e51e0303                          mov.l   0Ch[r1], 0Ch[r14]
FFF13338  fbe20cee0100                      mov.l   #1EE0Ch, r14
FFF1333E  e51e0402                          mov.l   10h[r1], 8[r14]
FFF13342  fbe278020200                      mov.l   #20278h, r14
FFF13348  a912                              mov.l   10h[r1], r2
FFF1334A  7322008000                        add     #8000h, r2, r2
FFF1334F  0685e242                          cmp     108h[r14].l, r2
FFF13353  240d                              bgtu.b  loc_FFF13360
FFF13355  f90e01008000                      mov.l   #8000h, 0Ch+var_8[sp]
FFF1335B  3d0400                            mov.w   #0, 0Ch+var_4[sp]
FFF1335E  2e14                              bra.b   loc_FFF13372
FFF13360  fbe278020200           loc_FFF13360 mov.l   #20278h, r14
FFF13366  ede242                            mov.l   108h[r14], r2
FFF13369  06811204                          sub     10h[r1].l, r2
FFF1336D  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF1336F  3d0401                            mov.w   #1, 0Ch+var_4[sp]
FFF13372  a809                   loc_FFF13372 mov.l   0Ch+var_8[sp], r1
FFF13374  6101                              cmp     #0, r1
FFF13376  3ad100                            beq.w   loc_FFF13447
FFF13379  fbe20cee0100                      mov.l   #1EE0Ch, r14
FFF1337F  e50e0104                          mov.l   0Ch+var_8[sp], 10h[r14]
FFF13383  fb120cee0100                      mov.l   #1EE0Ch, r1
FFF13389  39b307                            bsr.w   sub_FFF13B3C
FFF1338C  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF1338E  b909                              movu.w  0Ch+var_2[sp], r1
FFF13390  6101                              cmp     #0, r1
FFF13392  203e                              beq.b   loc_FFF133D0
FFF13394  05901400                          bsr.a   sub_FFF14824
FFF13398  fbe278020200                      mov.l   #20278h, r14
FFF1339E  eeee4dc0                          mov.l   30134h[r14], r14
FFF133A2  610e                              cmp     #0, r14
FFF133A4  2010                              beq.b   loc_FFF133B4
FFF133A6  fbe278020200                      mov.l   #20278h, r14
FFF133AC  eee14dc0                          mov.l   30134h[r14], r1
FFF133B0  056a3a00                          bsr.a   sub_FFF16E1A
FFF133B4  fbe278020200           loc_FFF133B4 mov.l   #20278h, r14
FFF133BA  e2e04cc0                          mov.l   30130h[r14], 0Ch+var_C[sp]
FFF133BE  ec01                              mov.l   0Ch+var_C[sp], r1
FFF133C0  6101                              cmp     #0, r1
FFF133C2  3a8500                            beq.w   loc_FFF13447
FFF133C5  ec02                              mov.l   0Ch+var_C[sp], r2
FFF133C7  fb1effff00                        mov.l   #0FFFFh, r1
FFF133CC  7f12                              jsr     r2
FFF133CE  6703                              rtsd    #3
FFF133D0  fbe278020200           loc_FFF133D0 mov.l   #20278h, r14
FFF133D6  5dee90                            movu.w  120h[r14], r14
FFF133D9  610e                              cmp     #0, r14
FFF133DB  211e                              bne.b   loc_FFF133F9
FFF133DD  fbe278020200                      mov.l   #20278h, r14
FFF133E3  fbf20cee0100                      mov.l   #1EE0Ch, r15
FFF133E9  e5fe0447                          mov.l   10h[r15], 11Ch[r14]
FFF133ED  fbe278020200                      mov.l   #20278h, r14
FFF133F3  f9e59001                          mov.w   #1, 120h[r14]
FFF133F7  2e2c                              bra.b   loc_FFF13423
FFF133F9  fbe278020200           loc_FFF133F9 mov.l   #20278h, r14
FFF133FF  5eee96c0                          movu.w  1812Ch[r14], r14
FFF13403  610e                              cmp     #0, r14
FFF13405  211e                              bne.b   loc_FFF13423
FFF13407  fbe278020200                      mov.l   #20278h, r14
FFF1340D  fbf20cee0100                      mov.l   #1EE0Ch, r15
FFF13413  e9fe044a60                        mov.l   10h[r15], 18128h[r14]
FFF13418  fbe278020200                      mov.l   #20278h, r14
FFF1341E  fae596c001                        mov.w   #1, 1812Ch[r14]
FFF13423  b901                   loc_FFF13423 movu.w  0Ch+var_4[sp], r1
FFF13425  6111                              cmp     #1, r1
FFF13427  2120                              bne.b   loc_FFF13447
FFF13429  fbe278020200                      mov.l   #20278h, r14
FFF1342F  eeee4dc0                          mov.l   30134h[r14], r14
FFF13433  610e                              cmp     #0, r14
FFF13435  2012                              beq.b   loc_FFF13447
FFF13437  fbe278020200                      mov.l   #20278h, r14
FFF1343D  eee14dc0                          mov.l   30134h[r14], r1
FFF13441  05d93900                          bsr.a   sub_FFF16E1A
FFF13445  6703                              rtsd    #3
FFF13447  6703                   loc_FFF13447 rtsd    #3
FFF13449  7ea6                   sub_FFF13449 push.l  r6   ; <<<< FUNC sub_FFF13449
FFF1344B  60c0                              sub     #0Ch, sp
FFF1344D  3d0500                            mov.w   #0, 0Ch+var_2[sp]
FFF13450  710614                            add     #0Ch+arg_0, sp, r6
FFF13453  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF13456  fbe278020200                      mov.l   #20278h, r14
FFF1345C  ede143                            mov.l   10Ch[r14], r1
FFF1345F  06896102                          add     8[r6].l, r1
FFF13463  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF13465  a809                              mov.l   0Ch+var_8[sp], r1
FFF13467  740101000080                      cmp     #-7FFFFFFFh, r1
FFF1346D  230a                              bltu.b  loc_FFF13477
FFF1346F  6631                              mov.l   #3, r1
FFF13471  390308                            bsr.w   sub_FFF13C74
FFF13474  3f6604                            rtsd    #10h, r6-r6
FFF13477  fbe20cee0100           loc_FFF13477 mov.l   #1EE0Ch, r14
FFF1347D  f8e9ffff                          mov.w   #-1, [r14]
FFF13481  fbe20cee0100                      mov.l   #1EE0Ch, r14
FFF13487  e56e0101                          mov.l   4[r6], 4[r14]
FFF1348B  fbe278020200                      mov.l   #20278h, r14
FFF13491  5dee90                            movu.w  120h[r14], r14
FFF13494  610e                              cmp     #0, r14
FFF13496  2116                              bne.b   loc_FFF134AC
FFF13498  fb1278020200                      mov.l   #20278h, r1
FFF1349E  72112201                          add     #122h, r1, r1
FFF134A2  fb220cee0100                      mov.l   #1EE0Ch, r2
FFF134A8  a0a9                              mov.l   r1, 0Ch[r2]
FFF134AA  2e23                              bra.b   loc_FFF134CD
FFF134AC  fbe278020200           loc_FFF134AC mov.l   #20278h, r14
FFF134B2  5eee96c0                          movu.w  1812Ch[r14], r14
FFF134B6  610e                              cmp     #0, r14
FFF134B8  2115                              bne.b   loc_FFF134CD
FFF134BA  fb1278020200                      mov.l   #20278h, r1
FFF134C0  73112e8101                        add     #1812Eh, r1, r1
FFF134C5  fb220cee0100                      mov.l   #1EE0Ch, r2
FFF134CB  a0a9                              mov.l   r1, 0Ch[r2]
FFF134CD  fbe20cee0100           loc_FFF134CD mov.l   #1EE0Ch, r14
FFF134D3  fbf278020200                      mov.l   #20278h, r15
FFF134D9  e5fe4302                          mov.l   10Ch[r15], 8[r14]
FFF134DD  fbe20cee0100                      mov.l   #1EE0Ch, r14
FFF134E3  e56e0204                          mov.l   8[r6], 10h[r14]
FFF134E7  fb120cee0100                      mov.l   #1EE0Ch, r1
FFF134ED  391707                            bsr.w   sub_FFF13C04
FFF134F0  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF134F2  b909                              movu.w  0Ch+var_2[sp], r1
FFF134F4  6101                              cmp     #0, r1
FFF134F6  11                                beq.s   loc_FFF134FF
FFF134F7  b909                              movu.w  0Ch+var_2[sp], r1
FFF134F9  397b07                            bsr.w   sub_FFF13C74
FFF134FC  3f6604                            rtsd    #10h, r6-r6
FFF134FF  fbe278020200           loc_FFF134FF mov.l   #20278h, r14
FFF13505  5dee90                            movu.w  120h[r14], r14
FFF13508  610e                              cmp     #0, r14
FFF1350A  210e                              bne.b   loc_FFF13518
FFF1350C  fbe278020200                      mov.l   #20278h, r14
FFF13512  f9e59001                          mov.w   #1, 120h[r14]
FFF13516  2e1b                              bra.b   loc_FFF13531
FFF13518  fbe278020200           loc_FFF13518 mov.l   #20278h, r14
FFF1351E  5eee96c0                          movu.w  1812Ch[r14], r14
FFF13522  610e                              cmp     #0, r14
FFF13524  210d                              bne.b   loc_FFF13531
FFF13526  fbe278020200                      mov.l   #20278h, r14
FFF1352C  fae596c001                        mov.w   #1, 1812Ch[r14]
FFF13531  fbe278020200           loc_FFF13531 mov.l   #20278h, r14
FFF13537  edef43                            mov.l   10Ch[r14], r15
FFF1353A  06896f02                          add     8[r6].l, r15
FFF1353E  e7ef43                            mov.l   r15, 10Ch[r14]
FFF13541  fb1278020200                      mov.l   #20278h, r1
FFF13547  b891                              movu.w  4[r1], r1
FFF13549  6141                              cmp     #4, r1
FFF1354B  2111                              bne.b   loc_FFF1355C
FFF1354D  fbe293220100                      mov.l   #12293h, r14
FFF13553  58ee                              movu.b  [r14], r14
FFF13555  610e                              cmp     #0, r14
FFF13557  1d                                bne.s   loc_FFF1355C
FFF13558  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF1355B  0c                                bra.s   loc_FFF1355F
FFF1355C  f80600                 loc_FFF1355C mov.l   #0, 0Ch+var_C[sp]
FFF1355F  ec01                   loc_FFF1355F mov.l   0Ch+var_C[sp], r1
FFF13561  6101                              cmp     #0, r1
FFF13563  11                                beq.s   loc_FFF1356C
FFF13564  6621                              mov.l   #2, r1
FFF13566  390e07                            bsr.w   sub_FFF13C74
FFF13569  3f6604                            rtsd    #10h, r6-r6
FFF1356C  3f6604                 loc_FFF1356C rtsd    #10h, r6-r6
FFF1356F  7100e4                 sub_FFF1356F add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF1356F
FFF13572  3e0600                            mov.l   #0, 1Ch+var_4[sp]
FFF13575  3e0500                            mov.l   #0, 1Ch+var_8[sp]
FFF13578  3e0400                            mov.l   #0, 1Ch+var_C[sp]
FFF1357B  3c0f00                            mov.b   #0, 1Ch+var_D[sp]
FFF1357E  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF13581  387102                            bra.w   loc_FFF137F2
FFF13584  fb1278020200           loc_FFF13584 mov.l   #20278h, r1
FFF1358A  b891                              movu.w  4[r1], r1
FFF1358C  6121                              cmp     #2, r1
FFF1358E  200d                              beq.b   loc_FFF1359B
FFF13590  fb1278020200                      mov.l   #20278h, r1
FFF13596  b891                              movu.w  4[r1], r1
FFF13598  6131                              cmp     #3, r1
FFF1359A  1d                                bne.s   loc_FFF1359F
FFF1359B  f80601                 loc_FFF1359B mov.l   #1, 1Ch+var_1C[sp]
FFF1359E  0c                                bra.s   loc_FFF135A2
FFF1359F  f80600                 loc_FFF1359F mov.l   #0, 1Ch+var_1C[sp]
FFF135A2  ec01                   loc_FFF135A2 mov.l   1Ch+var_1C[sp], r1
FFF135A4  6101                              cmp     #0, r1
FFF135A6  3b5e02                            bne.w   loc_FFF13804
FFF135A9  fbe224ee0100                      mov.l   #1EE24h, r14
FFF135AF  ede146                            mov.l   118h[r14], r1
FFF135B2  72118000                          add     #80h, r1, r1
FFF135B6  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF135B8  fbe224ee0100                      mov.l   #1EE24h, r14
FFF135BE  a909                              mov.l   1Ch+var_8[sp], r1
FFF135C0  0685e141                          cmp     104h[r14].l, r1
FFF135C4  2512                              bleu.b  loc_FFF135D6
FFF135C6  fbe224ee0100                      mov.l   #1EE24h, r14
FFF135CC  ede141                            mov.l   104h[r14], r1
FFF135CF  0681e146                          sub     118h[r14].l, r1
FFF135D3  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF135D5  0c                                bra.s   loc_FFF135D9
FFF135D6  3e0680                 loc_FFF135D6 mov.l   #-80h, 1Ch+var_4[sp]
FFF135D9  fbe224ee0100           loc_FFF135D9 mov.l   #1EE24h, r14
FFF135DF  ede246                            mov.l   118h[r14], r2
FFF135E2  ede1c7                            mov.l   31Ch[r14], r1
FFF135E5  6603                              mov.l   #0, r3
FFF135E7  05685d00                          bsr.a   sub_FFF1934F
FFF135EB  8389                              mov.b   r1, 1Ch+var_D[sp]
FFF135ED  8b89                              mov.b   1Ch+var_D[sp], r1
FFF135EF  7501ff                            cmp     #-1, r1
FFF135F2  2176                              bne.b   loc_FFF13668
FFF135F4  fbe224ee0100                      mov.l   #1EE24h, r14
FFF135FA  ede1c7                            mov.l   31Ch[r14], r1
FFF135FD  051d3800                          bsr.a   sub_FFF16E1A
FFF13601  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13607  f8e503                            mov.w   #3, [r14]
FFF1360A  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13610  f9e64100                          mov.l   #0, 104h[r14]
FFF13614  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1361A  f9e64600                          mov.l   #0, 118h[r14]
FFF1361E  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13624  f9e6e900                          mov.l   #0, 3A4h[r14]
FFF13628  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1362E  ede1c7                            mov.l   31Ch[r14], r1
FFF13631  05e93700                          bsr.a   sub_FFF16E1A
FFF13635  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1363B  ede1c8                            mov.l   320h[r14], r1
FFF1363E  05dc3700                          bsr.a   sub_FFF16E1A
FFF13642  fb1224ee0100                      mov.l   #1EE24h, r1
FFF13648  72111c02                          add     #21Ch, r1, r1
FFF1364C  3938fb                            bsr.w   sub_FFF13184
FFF1364F  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13655  e5e0ec01                          mov.l   3B0h[r14], 1Ch+var_18[sp]
FFF13659  a809                              mov.l   1Ch+var_18[sp], r1
FFF1365B  6101                              cmp     #0, r1
FFF1365D  3aa701                            beq.w   loc_FFF13804
FFF13660  a80a                              mov.l   1Ch+var_18[sp], r2
FFF13662  6611                              mov.l   #1, r1
FFF13664  7f12                              jsr     r2
FFF13666  6707                              rtsd    #7
FFF13668  fb1224ee0100           loc_FFF13668 mov.l   #1EE24h, r1
FFF1366E  ed14c7                            mov.l   31Ch[r1], r4
FFF13671  a983                              mov.l   1Ch+var_4[sp], r3
FFF13673  72112403                          add     #324h, r1, r1
FFF13677  6612                              mov.l   #1, r2
FFF13679  05364800                          bsr.a   sub_FFF17EAF
FFF1367D  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF1367F  a881                              mov.l   1Ch+var_14[sp], r1
FFF13681  06850106                          cmp     1Ch+var_4[sp].l, r1
FFF13685  2076                              beq.b   loc_FFF136FB
FFF13687  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1368D  ede1c7                            mov.l   31Ch[r14], r1
FFF13690  058a3700                          bsr.a   sub_FFF16E1A
FFF13694  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1369A  f8e503                            mov.w   #3, [r14]
FFF1369D  fbe224ee0100                      mov.l   #1EE24h, r14
FFF136A3  f9e64100                          mov.l   #0, 104h[r14]
FFF136A7  fbe224ee0100                      mov.l   #1EE24h, r14
FFF136AD  f9e64600                          mov.l   #0, 118h[r14]
FFF136B1  fbe224ee0100                      mov.l   #1EE24h, r14
FFF136B7  f9e6e900                          mov.l   #0, 3A4h[r14]
FFF136BB  fbe224ee0100                      mov.l   #1EE24h, r14
FFF136C1  ede1c7                            mov.l   31Ch[r14], r1
FFF136C4  05563700                          bsr.a   sub_FFF16E1A
FFF136C8  fbe224ee0100                      mov.l   #1EE24h, r14
FFF136CE  ede1c8                            mov.l   320h[r14], r1
FFF136D1  05493700                          bsr.a   sub_FFF16E1A
FFF136D5  fb1224ee0100                      mov.l   #1EE24h, r1
FFF136DB  72111c02                          add     #21Ch, r1, r1
FFF136DF  39a5fa                            bsr.w   sub_FFF13184
FFF136E2  fbe224ee0100                      mov.l   #1EE24h, r14
FFF136E8  e5e0ec01                          mov.l   3B0h[r14], 1Ch+var_18[sp]
FFF136EC  a809                              mov.l   1Ch+var_18[sp], r1
FFF136EE  6101                              cmp     #0, r1
FFF136F0  3a1401                            beq.w   loc_FFF13804
FFF136F3  a80a                              mov.l   1Ch+var_18[sp], r2
FFF136F5  6611                              mov.l   #1, r1
FFF136F7  7f12                              jsr     r2
FFF136F9  6707                              rtsd    #7
FFF136FB  fbe224ee0100           loc_FFF136FB mov.l   #1EE24h, r14
FFF13701  edefeb                            mov.l   3ACh[r14], r15
FFF13704  0685efea                          cmp     3A8h[r14].l, r15
FFF13708  223b                              bgeu.b  loc_FFF13743
FFF1370A  754e80                            mov.l   #-80h, r14
FFF1370D  fbf224ee0100                      mov.l   #1EE24h, r15
FFF13713  52fe2403                          and     324h[r15], r14
FFF13717  755e80                            cmp     #-80h, r14
FFF1371A  2119                              bne.b   loc_FFF13733
FFF1371C  fb1224ee0100                      mov.l   #1EE24h, r1
FFF13722  ed14c8                            mov.l   320h[r1], r4
FFF13725  a983                              mov.l   1Ch+var_4[sp], r3
FFF13727  72112403                          add     #324h, r1, r1
FFF1372B  6612                              mov.l   #1, r2
FFF1372D  05e34d00                          bsr.a   sub_FFF18510
FFF13731  2e27                              bra.b   loc_FFF13758
FFF13733  fbe224ee0100           loc_FFF13733 mov.l   #1EE24h, r14
FFF13739  edefeb                            mov.l   3ACh[r14], r15
FFF1373C  621f                              add     #1, r15
FFF1373E  e7efeb                            mov.l   r15, 3ACh[r14]
FFF13741  2e17                              bra.b   loc_FFF13758
FFF13743  fb1224ee0100           loc_FFF13743 mov.l   #1EE24h, r1
FFF13749  ed14c8                            mov.l   320h[r1], r4
FFF1374C  a983                              mov.l   1Ch+var_4[sp], r3
FFF1374E  72112403                          add     #324h, r1, r1
FFF13752  6612                              mov.l   #1, r2
FFF13754  05bc4d00                          bsr.a   sub_FFF18510
FFF13758  fbe224ee0100           loc_FFF13758 mov.l   #1EE24h, r14
FFF1375E  edef46                            mov.l   118h[r14], r15
FFF13761  06890f06                          add     1Ch+var_4[sp].l, r15
FFF13765  e7ef46                            mov.l   r15, 118h[r14]
FFF13768  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1376E  edef46                            mov.l   118h[r14], r15
FFF13771  0685ef41                          cmp     104h[r14].l, r15
FFF13775  2377                              bltu.b  loc_FFF137EC
FFF13777  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1377D  f8e503                            mov.w   #3, [r14]
FFF13780  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13786  f9e64100                          mov.l   #0, 104h[r14]
FFF1378A  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13790  f9e64600                          mov.l   #0, 118h[r14]
FFF13794  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1379A  f9e6e900                          mov.l   #0, 3A4h[r14]
FFF1379E  fbe224ee0100                      mov.l   #1EE24h, r14
FFF137A4  ede1c7                            mov.l   31Ch[r14], r1
FFF137A7  05733600                          bsr.a   sub_FFF16E1A
FFF137AB  fbe224ee0100                      mov.l   #1EE24h, r14
FFF137B1  ede1c8                            mov.l   320h[r14], r1
FFF137B4  05663600                          bsr.a   sub_FFF16E1A
FFF137B8  fb1224ee0100                      mov.l   #1EE24h, r1
FFF137BE  6221                              add     #2, r1
FFF137C0  39c4f9                            bsr.w   sub_FFF13184
FFF137C3  fb1224ee0100                      mov.l   #1EE24h, r1
FFF137C9  72121c01                          add     #11Ch, r1, r2
FFF137CD  72111c02                          add     #21Ch, r1, r1
FFF137D1  3988f9                            bsr.w   sub_FFF13159
FFF137D4  fbe224ee0100                      mov.l   #1EE24h, r14
FFF137DA  e5e0ec01                          mov.l   3B0h[r14], 1Ch+var_18[sp]
FFF137DE  a809                              mov.l   1Ch+var_18[sp], r1
FFF137E0  6101                              cmp     #0, r1
FFF137E2  2022                              beq.b   loc_FFF13804
FFF137E4  a80a                              mov.l   1Ch+var_18[sp], r2
FFF137E6  6601                              mov.l   #0, r1
FFF137E8  7f12                              jsr     r2
FFF137EA  6707                              rtsd    #7
FFF137EC  a901                   loc_FFF137EC mov.l   1Ch+var_C[sp], r1
FFF137EE  6211                              add     #1, r1
FFF137F0  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF137F2  fbe224ee0100           loc_FFF137F2 mov.l   #1EE24h, r14
FFF137F8  edeee9                            mov.l   3A4h[r14], r14
FFF137FB  06850e04                          cmp     1Ch+var_C[sp].l, r14
FFF137FF  2505                              bleu.b  loc_FFF13804
FFF13801  3883fd                            bra.w   loc_FFF13584
FFF13804  6707                   loc_FFF13804 rtsd    #7
FFF13806  6080                   sub_FFF13806 sub     #8, sp   ; <<<< FUNC sub_FFF13806
FFF13808  3d0300                            mov.w   #0, 8+var_2[sp]
FFF1380B  fbe295220100                      mov.l   #12295h, r14
FFF13811  58ee                              movu.b  [r14], r14
FFF13813  610e                              cmp     #0, r14
FFF13815  3a9400                            beq.w   loc_FFF138A9
FFF13818  fb12d8f10100                      mov.l   #1F1D8h, r1
FFF1381E  05072400                          bsr.a   sub_FFF15C25
FFF13822  fbe25cf20100                      mov.l   #1F25Ch, r14
FFF13828  f8e9ffff                          mov.w   #-1, [r14]
FFF1382C  fb12b8930600                      mov.l   #693B8h, r1
FFF13832  6221                              add     #2, r1
FFF13834  fb225cf20100                      mov.l   #1F25Ch, r2
FFF1383A  a029                              mov.l   r1, 4[r2]
FFF1383C  fb12d8f10100                      mov.l   #1F1D8h, r1
FFF13842  6241                              add     #4, r1
FFF13844  fb225cf20100                      mov.l   #1F25Ch, r2
FFF1384A  a0a9                              mov.l   r1, 0Ch[r2]
FFF1384C  fbe25cf20100                      mov.l   #1F25Ch, r14
FFF13852  fbf2b8930600                      mov.l   #693B8h, r15
FFF13858  e5fe4102                          mov.l   104h[r15], 8[r14]
FFF1385C  fbe25cf20100                      mov.l   #1F25Ch, r14
FFF13862  fbf2d8f10100                      mov.l   #1F1D8h, r15
FFF13868  e4fe04                            mov.l   [r15], 10h[r14]
FFF1386B  fb125cf20100                      mov.l   #1F25Ch, r1
FFF13871  393d07                            bsr.w   sub_FFF13FAE
FFF13874  9089                              mov.w   r1, 8+var_2[sp]
FFF13876  b889                              movu.w  8+var_2[sp], r1
FFF13878  6101                              cmp     #0, r1
FFF1387A  201d                              beq.b   loc_FFF13897
FFF1387C  05801600                          bsr.a   sub_FFF14EFC
FFF13880  fbe2b8930600                      mov.l   #693B8h, r14
FFF13886  e1e044                            mov.l   110h[r14], 8+var_8[sp]
FFF13889  ec01                              mov.l   8+var_8[sp], r1
FFF1388B  6101                              cmp     #0, r1
FFF1388D  201c                              beq.b   loc_FFF138A9
FFF1388F  b889                              movu.w  8+var_2[sp], r1
FFF13891  ec02                              mov.l   8+var_8[sp], r2
FFF13893  7f12                              jsr     r2
FFF13895  6702                              rtsd    #2
FFF13897  fbe2b8930600           loc_FFF13897 mov.l   #693B8h, r14
FFF1389D  edef41                            mov.l   104h[r14], r15
FFF138A0  72ff8000                          add     #80h, r15, r15
FFF138A4  e7ef41                            mov.l   r15, 104h[r14]
FFF138A7  6702                              rtsd    #2
FFF138A9  6702                   loc_FFF138A9 rtsd    #2
FFF138AB  7100b0                 sub_FFF138AB add     #-50h, sp, sp   ; <<<< FUNC sub_FFF138AB
FFF138AE  a489                              mov.l   r1, 50h+var_4[sp]
FFF138B0  a482                              mov.l   r2, 50h+var_8[sp]
FFF138B2  a40b                              mov.l   r3, 50h+var_C[sp]
FFF138B4  f9052000                          mov.w   #0, 50h+var_10[sp]
FFF138B8  3e0f00                            mov.l   #0, 50h+var_14[sp]
FFF138BB  3e0200                            mov.l   #0, 50h+var_48[sp]
FFF138BE  3e0100                            mov.l   #0, 50h+var_4C[sp]
FFF138C1  ac89                              mov.l   50h+var_4[sp], r1
FFF138C3  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF138C9  057f2600                          bsr.a   sub_FFF15F48
FFF138CD  a381                              mov.l   r1, 50h+var_18[sp]
FFF138CF  ab81                              mov.l   50h+var_18[sp], r1
FFF138D1  6101                              cmp     #0, r1
FFF138D3  212c                              bne.b   loc_FFF138FF
FFF138D5  ab82                              mov.l   50h+var_18[sp], r2
FFF138D7  ac89                              mov.l   50h+var_4[sp], r1
FFF138D9  393c02                            bsr.w   sub_FFF13B15
FFF138DC  ac89                              mov.l   50h+var_4[sp], r1
FFF138DE  fb22b3adf4ff                      mov.l   #unk_FFF4ADB3, r2
FFF138E4  05642600                          bsr.a   sub_FFF15F48
FFF138E8  a381                              mov.l   r1, 50h+var_18[sp]
FFF138EA  ab81                              mov.l   50h+var_18[sp], r1
FFF138EC  6101                              cmp     #0, r1
FFF138EE  2111                              bne.b   loc_FFF138FF
FFF138F0  ab82                              mov.l   50h+var_18[sp], r2
FFF138F2  ac89                              mov.l   50h+var_4[sp], r1
FFF138F4  392102                            bsr.w   sub_FFF13B15
FFF138F7  f90901ffff                        mov.w   #-1, 50h+var_4E[sp]
FFF138FC  38fb00                            bra.w   loc_FFF139F7
FFF138FF  ab84                   loc_FFF138FF mov.l   50h+var_18[sp], r4
FFF13901  75432c                            mov.l   #2Ch, r3 ; ','
FFF13904  6612                              mov.l   #1, r2
FFF13906  71010c                            add     #50h+var_44, sp, r1
FFF13909  05a64500                          bsr.a   sub_FFF17EAF
FFF1390D  a389                              mov.l   r1, 50h+var_14[sp]
FFF1390F  ab89                              mov.l   50h+var_14[sp], r1
FFF13911  75512c                            cmp     #2Ch, r1 ; ','
FFF13914  2010                              beq.b   loc_FFF13924
FFF13916  ab81                              mov.l   50h+var_18[sp], r1
FFF13918  05023500                          bsr.a   sub_FFF16E1A
FFF1391C  f90901ffff                        mov.w   #-1, 50h+var_4E[sp]
FFF13921  38d600                            bra.w   loc_FFF139F7
FFF13924  f9052007               loc_FFF13924 mov.w   #7, 50h+var_10[sp]
FFF13928  3e0100                            mov.l   #0, 50h+var_4C[sp]
FFF1392B  5d0120                            movu.w  50h+var_10[sp], r1
FFF1392E  710e0c                            add     #50h+var_44, sp, r14
FFF13931  fece11                            movu.b  [r14, r1], r1
FFF13934  a009                              mov.l   r1, 50h+var_4C[sp]
FFF13936  dd0120                            mov.w   50h+var_10[sp], r1
FFF13939  6011                              sub     #1, r1
FFF1393B  d70120                            mov.w   r1, 50h+var_10[sp]
FFF1393E  a809                              mov.l   50h+var_4C[sp], r1
FFF13940  6c81                              shll    #8, r1
FFF13942  710e0c                            add     #50h+var_44, sp, r14
FFF13945  06c90e20                          add     50h+var_10[sp].uw, r14
FFF13949  54e1                              or      [r14], r1
FFF1394B  a009                              mov.l   r1, 50h+var_4C[sp]
FFF1394D  dd0120                            mov.w   50h+var_10[sp], r1
FFF13950  6011                              sub     #1, r1
FFF13952  d70120                            mov.w   r1, 50h+var_10[sp]
FFF13955  a809                              mov.l   50h+var_4C[sp], r1
FFF13957  6c81                              shll    #8, r1
FFF13959  710e0c                            add     #50h+var_44, sp, r14
FFF1395C  06c90e20                          add     50h+var_10[sp].uw, r14
FFF13960  54e1                              or      [r14], r1
FFF13962  a009                              mov.l   r1, 50h+var_4C[sp]
FFF13964  dd0120                            mov.w   50h+var_10[sp], r1
FFF13967  6011                              sub     #1, r1
FFF13969  d70120                            mov.w   r1, 50h+var_10[sp]
FFF1396C  a809                              mov.l   50h+var_4C[sp], r1
FFF1396E  6c81                              shll    #8, r1
FFF13970  710e0c                            add     #50h+var_44, sp, r14
FFF13973  06c90e20                          add     50h+var_10[sp].uw, r14
FFF13977  54e1                              or      [r14], r1
FFF13979  a009                              mov.l   r1, 50h+var_4C[sp]
FFF1397B  dd0120                            mov.w   50h+var_10[sp], r1
FFF1397E  6011                              sub     #1, r1
FFF13980  d70120                            mov.w   r1, 50h+var_10[sp]
FFF13983  f905202b                          mov.w   #2Bh, 50h+var_10[sp] ; '+'
FFF13987  3e0200                            mov.l   #0, 50h+var_48[sp]
FFF1398A  5d0120                            movu.w  50h+var_10[sp], r1
FFF1398D  710e0c                            add     #50h+var_44, sp, r14
FFF13990  fece11                            movu.b  [r14, r1], r1
FFF13993  a081                              mov.l   r1, 50h+var_48[sp]
FFF13995  dd0120                            mov.w   50h+var_10[sp], r1
FFF13998  6011                              sub     #1, r1
FFF1399A  d70120                            mov.w   r1, 50h+var_10[sp]
FFF1399D  a881                              mov.l   50h+var_48[sp], r1
FFF1399F  6c81                              shll    #8, r1
FFF139A1  710e0c                            add     #50h+var_44, sp, r14
FFF139A4  06c90e20                          add     50h+var_10[sp].uw, r14
FFF139A8  54e1                              or      [r14], r1
FFF139AA  a081                              mov.l   r1, 50h+var_48[sp]
FFF139AC  dd0120                            mov.w   50h+var_10[sp], r1
FFF139AF  6011                              sub     #1, r1
FFF139B1  d70120                            mov.w   r1, 50h+var_10[sp]
FFF139B4  a881                              mov.l   50h+var_48[sp], r1
FFF139B6  6c81                              shll    #8, r1
FFF139B8  710e0c                            add     #50h+var_44, sp, r14
FFF139BB  06c90e20                          add     50h+var_10[sp].uw, r14
FFF139BF  54e1                              or      [r14], r1
FFF139C1  a081                              mov.l   r1, 50h+var_48[sp]
FFF139C3  dd0120                            mov.w   50h+var_10[sp], r1
FFF139C6  6011                              sub     #1, r1
FFF139C8  d70120                            mov.w   r1, 50h+var_10[sp]
FFF139CB  a881                              mov.l   50h+var_48[sp], r1
FFF139CD  6c81                              shll    #8, r1
FFF139CF  710e0c                            add     #50h+var_44, sp, r14
FFF139D2  06c90e20                          add     50h+var_10[sp].uw, r14
FFF139D6  54e1                              or      [r14], r1
FFF139D8  a081                              mov.l   r1, 50h+var_48[sp]
FFF139DA  dd0120                            mov.w   50h+var_10[sp], r1
FFF139DD  6011                              sub     #1, r1
FFF139DF  d70120                            mov.w   r1, 50h+var_10[sp]
FFF139E2  a881                              mov.l   50h+var_48[sp], r1
FFF139E4  ac82                              mov.l   50h+var_8[sp], r2
FFF139E6  e321                              mov.l   r1, [r2]
FFF139E8  a809                              mov.l   50h+var_4C[sp], r1
FFF139EA  ac0a                              mov.l   50h+var_C[sp], r2
FFF139EC  e321                              mov.l   r1, [r2]
FFF139EE  ab81                              mov.l   50h+var_18[sp], r1
FFF139F0  052a3400                          bsr.a   sub_FFF16E1A
FFF139F4  3d0100                            mov.w   #0, 50h+var_4E[sp]
FFF139F7  d5000121               loc_FFF139F7 mov.w   50h+var_4E[sp], 50h+var_E[sp]
FFF139FB  5d0121                            movu.w  50h+var_E[sp], r1
FFF139FE  6714                              rtsd    #14h
FFF13A00  7100dc                 sub_FFF13A00 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF13A00
FFF13A03  a201                              mov.l   r1, 24h+var_4[sp]
FFF13A05  a18a                              mov.l   r2, 24h+var_8[sp]
FFF13A07  3d0c00                            mov.w   #0, 24h+var_C[sp]
FFF13A0A  3e0500                            mov.l   #0, 24h+var_10[sp]
FFF13A0D  3e0300                            mov.l   #0, 24h+var_18[sp]
FFF13A10  3e0200                            mov.l   #0, 24h+var_1C[sp]
FFF13A13  aa01                              mov.l   24h+var_4[sp], r1
FFF13A15  710214                            add     #24h+var_10, sp, r2
FFF13A18  39dbf6                            bsr.w   sub_FFF130F3
FFF13A1B  9301                              mov.w   r1, 24h+var_C[sp]
FFF13A1D  bb01                              movu.w  24h+var_C[sp], r1
FFF13A1F  6101                              cmp     #0, r1
FFF13A21  11                                beq.s   loc_FFF13A2A
FFF13A22  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13A27  38e600                            bra.w   loc_FFF13B0D
FFF13A2A  aa01                   loc_FFF13A2A mov.l   24h+var_4[sp], r1
FFF13A2C  710308                            add     #24h+var_1C, sp, r3
FFF13A2F  71020c                            add     #24h+var_18, sp, r2
FFF13A32  3979fe                            bsr.w   sub_FFF138AB
FFF13A35  9301                              mov.w   r1, 24h+var_C[sp]
FFF13A37  bb01                              movu.w  24h+var_C[sp], r1
FFF13A39  6101                              cmp     #0, r1
FFF13A3B  11                                beq.s   loc_FFF13A44
FFF13A3C  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13A41  38cc00                            bra.w   loc_FFF13B0D
FFF13A44  a881                   loc_FFF13A44 mov.l   24h+var_1C[sp], r1
FFF13A46  6101                              cmp     #0, r1
FFF13A48  16                                beq.s   loc_FFF13A4E
FFF13A49  a889                              mov.l   24h+var_18[sp], r1
FFF13A4B  6101                              cmp     #0, r1
FFF13A4D  1d                                bne.s   loc_FFF13A52
FFF13A4E  f80601                 loc_FFF13A4E mov.l   #1, 24h+var_24[sp]
FFF13A51  0c                                bra.s   loc_FFF13A55
FFF13A52  f80600                 loc_FFF13A52 mov.l   #0, 24h+var_24[sp]
FFF13A55  ec01                   loc_FFF13A55 mov.l   24h+var_24[sp], r1
FFF13A57  6101                              cmp     #0, r1
FFF13A59  3a8900                            beq.w   loc_FFF13AE2
FFF13A5C  a909                              mov.l   24h+var_10[sp], r1
FFF13A5E  6081                              sub     #8, r1
FFF13A60  fb22b4030500                      mov.l   #503B4h, r2
FFF13A66  a029                              mov.l   r1, 4[r2]
FFF13A68  a909                              mov.l   24h+var_10[sp], r1
FFF13A6A  7111d4                            add     #-2Ch, r1, r1
FFF13A6D  fb22b4030500                      mov.l   #503B4h, r2
FFF13A73  a2a1                              mov.l   r1, 28h[r2]
FFF13A75  aa01                              mov.l   24h+var_4[sp], r1
FFF13A77  fb22b0adf4ff                      mov.l   #unk_FFF4ADB0, r2
FFF13A7D  05cb2400                          bsr.a   sub_FFF15F48
FFF13A81  a101                              mov.l   r1, 24h+var_14[sp]
FFF13A83  a901                              mov.l   24h+var_14[sp], r1
FFF13A85  6101                              cmp     #0, r1
FFF13A87  212b                              bne.b   loc_FFF13AB2
FFF13A89  a902                              mov.l   24h+var_14[sp], r2
FFF13A8B  aa01                              mov.l   24h+var_4[sp], r1
FFF13A8D  398800                            bsr.w   sub_FFF13B15
FFF13A90  aa01                              mov.l   24h+var_4[sp], r1
FFF13A92  fb22b0adf4ff                      mov.l   #unk_FFF4ADB0, r2
FFF13A98  05b02400                          bsr.a   sub_FFF15F48
FFF13A9C  a101                              mov.l   r1, 24h+var_14[sp]
FFF13A9E  a901                              mov.l   24h+var_14[sp], r1
FFF13AA0  6101                              cmp     #0, r1
FFF13AA2  2110                              bne.b   loc_FFF13AB2
FFF13AA4  a902                              mov.l   24h+var_14[sp], r2
FFF13AA6  aa01                              mov.l   24h+var_4[sp], r1
FFF13AA8  396d00                            bsr.w   sub_FFF13B15
FFF13AAB  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13AB0  2e5d                              bra.b   loc_FFF13B0D
FFF13AB2  a904                   loc_FFF13AB2 mov.l   24h+var_14[sp], r4
FFF13AB4  75432c                            mov.l   #2Ch, r3 ; ','
FFF13AB7  6612                              mov.l   #1, r2
FFF13AB9  fb12b4030500                      mov.l   #503B4h, r1
FFF13ABF  05514a00                          bsr.a   sub_FFF18510
FFF13AC3  a901                              mov.l   24h+var_14[sp], r1
FFF13AC5  05553300                          bsr.a   sub_FFF16E1A
FFF13AC9  aa01                              mov.l   24h+var_4[sp], r1
FFF13ACB  710308                            add     #24h+var_1C, sp, r3
FFF13ACE  71020c                            add     #24h+var_18, sp, r2
FFF13AD1  39dafd                            bsr.w   sub_FFF138AB
FFF13AD4  9301                              mov.w   r1, 24h+var_C[sp]
FFF13AD6  bb01                              movu.w  24h+var_C[sp], r1
FFF13AD8  6101                              cmp     #0, r1
FFF13ADA  10                                beq.s   loc_FFF13AE2
FFF13ADB  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13AE0  2e2d                              bra.b   loc_FFF13B0D
FFF13AE2  a909                   loc_FFF13AE2 mov.l   24h+var_10[sp], r1
FFF13AE4  6081                              sub     #8, r1
FFF13AE6  06850102                          cmp     24h+var_1C[sp].l, r1
FFF13AEA  10                                beq.s   loc_FFF13AF2
FFF13AEB  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13AF0  2e1d                              bra.b   loc_FFF13B0D
FFF13AF2  a909                   loc_FFF13AF2 mov.l   24h+var_10[sp], r1
FFF13AF4  7111d4                            add     #-2Ch, r1, r1
FFF13AF7  06850103                          cmp     24h+var_18[sp].l, r1
FFF13AFB  10                                beq.s   loc_FFF13B03
FFF13AFC  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13B01  2e0c                              bra.b   loc_FFF13B0D
FFF13B03  a909                   loc_FFF13B03 mov.l   24h+var_10[sp], r1
FFF13B05  a98a                              mov.l   24h+var_8[sp], r2
FFF13B07  e321                              mov.l   r1, [r2]
FFF13B09  d5000c03                          mov.w   24h+var_C[sp], 24h+var_1E[sp]
FFF13B0D  d500030d               loc_FFF13B0D mov.w   24h+var_1E[sp], 24h+var_A[sp]
FFF13B11  bb09                              movu.w  24h+var_A[sp], r1
FFF13B13  6709                              rtsd    #9
FFF13B15  7100f0                 sub_FFF13B15 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF13B15
FFF13B18  a089                              mov.l   r1, 10h+var_4[sp]
FFF13B1A  a082                              mov.l   r2, 10h+var_8[sp]
FFF13B1C  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF13B1F  a881                              mov.l   10h+var_8[sp], r1
FFF13B21  6101                              cmp     #0, r1
FFF13B23  2017                              beq.b   loc_FFF13B3A
FFF13B25  a881                              mov.l   10h+var_8[sp], r1
FFF13B27  05f33200                          bsr.a   sub_FFF16E1A
FFF13B2B  a009                              mov.l   r1, 10h+var_C[sp]
FFF13B2D  a809                              mov.l   10h+var_C[sp], r1
FFF13B2F  6101                              cmp     #0, r1
FFF13B31  11                                beq.s   loc_FFF13B3A
FFF13B32  05e0b200                          bsr.a   sub_FFF1EE12
FFF13B36  e301                              mov.l   r1, 10h+var_10[sp]
FFF13B38  6704                              rtsd    #4
FFF13B3A  6704                   loc_FFF13B3A rtsd    #4
FFF13B3C  7100ec                 sub_FFF13B3C add     #-14h, sp, sp   ; <<<< FUNC sub_FFF13B3C
FFF13B3F  a101                              mov.l   r1, 14h+var_4[sp]
FFF13B41  3d0600                            mov.w   #0, 14h+var_8[sp]
FFF13B44  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF13B47  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF13B4A  a901                              mov.l   14h+var_4[sp], r1
FFF13B4C  5c1e                              movu.w  [r1], r14
FFF13B4E  610e                              cmp     #0, r14
FFF13B50  11                                beq.s   loc_FFF13B59
FFF13B51  f90901ffff                        mov.w   #-1, 14h+var_12[sp]
FFF13B56  38a600                            bra.w   loc_FFF13BFC
FFF13B59  fbe278020200           loc_FFF13B59 mov.l   #20278h, r14
FFF13B5F  73ee3a0103                        add     #3013Ah, r14, r14
FFF13B64  5cee                              movu.w  [r14], r14
FFF13B66  612e                              cmp     #2, r14
FFF13B68  215a                              bne.b   loc_FFF13BC2
FFF13B6A  fbe278020200                      mov.l   #20278h, r14
FFF13B70  eee14dc0                          mov.l   30134h[r14], r1
FFF13B74  fb3a0004                          mov.l   #400h, r3
FFF13B78  fb220cd40100                      mov.l   #1D40Ch, r2
FFF13B7E  05405700                          bsr.a   sub_FFF192BE
FFF13B82  a009                              mov.l   r1, 14h+var_10[sp]
FFF13B84  a809                              mov.l   14h+var_10[sp], r1
FFF13B86  6101                              cmp     #0, r1
FFF13B88  10                                beq.s   loc_FFF13B90
FFF13B89  f90901ffff                        mov.w   #-1, 14h+var_12[sp]
FFF13B8E  2e6e                              bra.b   loc_FFF13BFC
FFF13B90  fbe278020200           loc_FFF13B90 mov.l   #20278h, r14
FFF13B96  eee14dc0                          mov.l   30134h[r14], r1
FFF13B9A  6613                              mov.l   #1, r3
FFF13B9C  fb2e0080fd                        mov.l   #off_FFFD8000, r2
FFF13BA1  05ae5700                          bsr.a   sub_FFF1934F
FFF13BA5  a009                              mov.l   r1, 14h+var_10[sp]
FFF13BA7  a809                              mov.l   14h+var_10[sp], r1
FFF13BA9  6101                              cmp     #0, r1
FFF13BAB  2017                              beq.b   loc_FFF13BC2
FFF13BAD  fbe278020200                      mov.l   #20278h, r14
FFF13BB3  eee14dc0                          mov.l   30134h[r14], r1
FFF13BB7  05633200                          bsr.a   sub_FFF16E1A
FFF13BBB  f90901ffff                        mov.w   #-1, 14h+var_12[sp]
FFF13BC0  2e3c                              bra.b   loc_FFF13BFC
FFF13BC2  fbe278020200           loc_FFF13BC2 mov.l   #20278h, r14
FFF13BC8  eee44dc0                          mov.l   30134h[r14], r4
FFF13BCC  a901                              mov.l   14h+var_4[sp], r1
FFF13BCE  a913                              mov.l   10h[r1], r3
FFF13BD0  a899                              mov.l   0Ch[r1], r1
FFF13BD2  6612                              mov.l   #1, r2
FFF13BD4  05db4200                          bsr.a   sub_FFF17EAF
FFF13BD8  a081                              mov.l   r1, 14h+var_C[sp]
FFF13BDA  a901                              mov.l   14h+var_4[sp], r1
FFF13BDC  a882                              mov.l   14h+var_C[sp], r2
FFF13BDE  06851204                          cmp     10h[r1].l, r2
FFF13BE2  2016                              beq.b   loc_FFF13BF8
FFF13BE4  fbe278020200                      mov.l   #20278h, r14
FFF13BEA  eee14dc0                          mov.l   30134h[r14], r1
FFF13BEE  052c3200                          bsr.a   sub_FFF16E1A
FFF13BF2  f90901ffff                        mov.w   #-1, 14h+var_12[sp]
FFF13BF7  0d                                bra.s   loc_FFF13BFC
FFF13BF8  d5000601               loc_FFF13BF8 mov.w   14h+var_8[sp], 14h+var_12[sp]
FFF13BFC  d5000107               loc_FFF13BFC mov.w   14h+var_12[sp], 14h+var_6[sp]
FFF13C00  b989                              movu.w  14h+var_6[sp], r1
FFF13C02  6705                              rtsd    #5
FFF13C04  7100ec                 sub_FFF13C04 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF13C04
FFF13C07  a101                              mov.l   r1, 14h+var_4[sp]
FFF13C09  3d0600                            mov.w   #0, 14h+var_8[sp]
FFF13C0C  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF13C0F  a901                              mov.l   14h+var_4[sp], r1
FFF13C11  5c1e                              movu.w  [r1], r14
FFF13C13  770effff00                        cmp     #0FFFFh, r14
FFF13C18  10                                beq.s   loc_FFF13C20
FFF13C19  f90901ffff                        mov.w   #-1, 14h+var_12[sp]
FFF13C1E  2e4e                              bra.b   loc_FFF13C6C
FFF13C20  fbe278020200           loc_FFF13C20 mov.l   #20278h, r14
FFF13C26  eee44dc0                          mov.l   30134h[r14], r4
FFF13C2A  a901                              mov.l   14h+var_4[sp], r1
FFF13C2C  a913                              mov.l   10h[r1], r3
FFF13C2E  a899                              mov.l   0Ch[r1], r1
FFF13C30  6612                              mov.l   #1, r2
FFF13C32  05de4800                          bsr.a   sub_FFF18510
FFF13C36  a081                              mov.l   r1, 14h+var_C[sp]
FFF13C38  a901                              mov.l   14h+var_4[sp], r1
FFF13C3A  a882                              mov.l   14h+var_C[sp], r2
FFF13C3C  06851204                          cmp     10h[r1].l, r2
FFF13C40  201a                              beq.b   loc_FFF13C5A
FFF13C42  05d0b100                          bsr.a   sub_FFF1EE12
FFF13C46  a009                              mov.l   r1, 14h+var_10[sp]
FFF13C48  a809                              mov.l   14h+var_10[sp], r1
FFF13C4A  7501f5                            cmp     #-0Bh, r1
FFF13C4D  1e                                bne.s   loc_FFF13C53
FFF13C4E  3d0104                            mov.w   #4, 14h+var_12[sp]
FFF13C51  2e1b                              bra.b   loc_FFF13C6C
FFF13C53  f90901ffff             loc_FFF13C53 mov.w   #-1, 14h+var_12[sp]
FFF13C58  2e14                              bra.b   loc_FFF13C6C
FFF13C5A  fbe278020200           loc_FFF13C5A mov.l   #20278h, r14
FFF13C60  eee14dc0                          mov.l   30134h[r14], r1
FFF13C64  05c43500                          bsr.a   sub_FFF17228
FFF13C68  d5000601                          mov.w   14h+var_8[sp], 14h+var_12[sp]
FFF13C6C  d5000107               loc_FFF13C6C mov.w   14h+var_12[sp], 14h+var_6[sp]
FFF13C70  b989                              movu.w  14h+var_6[sp], r1
FFF13C72  6705                              rtsd    #5
FFF13C74  6080                   sub_FFF13C74 sub     #8, sp   ; <<<< FUNC sub_FFF13C74
FFF13C76  9089                              mov.w   r1, 8+var_2[sp]
FFF13C78  3d0200                            mov.w   #0, 8+var_4[sp]
FFF13C7B  b889                              movu.w  8+var_2[sp], r1
FFF13C7D  6121                              cmp     #2, r1
FFF13C7F  2114                              bne.b   loc_FFF13C93
FFF13C81  39b100                            bsr.w   sub_FFF13D32
FFF13C84  9081                              mov.w   r1, 8+var_4[sp]
FFF13C86  b881                              movu.w  8+var_4[sp], r1
FFF13C88  6101                              cmp     #0, r1
FFF13C8A  2018                              beq.b   loc_FFF13CA2
FFF13C8C  f90903ffff                        mov.w   #-1, 8+var_2[sp]
FFF13C91  2e11                              bra.b   loc_FFF13CA2
FFF13C93  fb1278020200           loc_FFF13C93 mov.l   #20278h, r1
FFF13C99  ee124dc0                          mov.l   30134h[r1], r2
FFF13C9D  6261                              add     #6, r1
FFF13C9F  3976fe                            bsr.w   sub_FFF13B15
FFF13CA2  05891500               loc_FFF13CA2 bsr.a   sub_FFF1522B
FFF13CA6  05f41a00                          bsr.a   sub_FFF1579A
FFF13CAA  fbe278020200                      mov.l   #20278h, r14
FFF13CB0  f8e500                            mov.w   #0, [r14]
FFF13CB3  fbe278020200                      mov.l   #20278h, r14
FFF13CB9  f9e58a00                          mov.w   #0, 114h[r14]
FFF13CBD  fbe278020200                      mov.l   #20278h, r14
FFF13CC3  f9e64600                          mov.l   #0, 118h[r14]
FFF13CC7  fbe278020200                      mov.l   #20278h, r14
FFF13CCD  f9e64700                          mov.l   #0, 11Ch[r14]
FFF13CD1  fbe278020200                      mov.l   #20278h, r14
FFF13CD7  f9e59003                          mov.w   #3, 120h[r14]
FFF13CDB  fbe278020200                      mov.l   #20278h, r14
FFF13CE1  fae6496000                        mov.l   #0, 18124h[r14]
FFF13CE6  fbe278020200                      mov.l   #20278h, r14
FFF13CEC  fae64a6000                        mov.l   #0, 18128h[r14]
FFF13CF1  fbe278020200                      mov.l   #20278h, r14
FFF13CF7  fae596c003                        mov.w   #3, 1812Ch[r14]
FFF13CFC  fbe278020200                      mov.l   #20278h, r14
FFF13D02  f9e64200                          mov.l   #0, 108h[r14]
FFF13D06  fbe278020200                      mov.l   #20278h, r14
FFF13D0C  f9e64300                          mov.l   #0, 10Ch[r14]
FFF13D10  fb1278020200                      mov.l   #20278h, r1
FFF13D16  3d1200                            mov.w   #0, 4[r1]
FFF13D19  fbe278020200                      mov.l   #20278h, r14
FFF13D1F  e2e04cc0                          mov.l   30130h[r14], 8+var_8[sp]
FFF13D23  ec01                              mov.l   8+var_8[sp], r1
FFF13D25  6101                              cmp     #0, r1
FFF13D27  11                                beq.s   loc_FFF13D30
FFF13D28  b889                              movu.w  8+var_2[sp], r1
FFF13D2A  ec02                              mov.l   8+var_8[sp], r2
FFF13D2C  7f12                              jsr     r2
FFF13D2E  6702                              rtsd    #2
FFF13D30  6702                   loc_FFF13D30 rtsd    #2
FFF13D32  7100f0                 sub_FFF13D32 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF13D32
FFF13D35  3d0600                            mov.w   #0, 10h+var_4[sp]
FFF13D38  3e0200                            mov.l   #0, 10h+var_8[sp]
FFF13D3B  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF13D3E  fbe278020200                      mov.l   #20278h, r14
FFF13D44  ede143                            mov.l   10Ch[r14], r1
FFF13D47  6081                              sub     #8, r1
FFF13D49  fb22b4030500                      mov.l   #503B4h, r2
FFF13D4F  a029                              mov.l   r1, 4[r2]
FFF13D51  fbe278020200                      mov.l   #20278h, r14
FFF13D57  ede143                            mov.l   10Ch[r14], r1
FFF13D5A  7111d4                            add     #-2Ch, r1, r1
FFF13D5D  fb22b4030500                      mov.l   #503B4h, r2
FFF13D63  a2a1                              mov.l   r1, 28h[r2]
FFF13D65  2e53                              bra.b   loc_FFF13DB8
FFF13D67  f90901ffff             loc_FFF13D67 mov.w   #-1, 10h+var_E[sp]
FFF13D6C  2e66                              bra.b   loc_FFF13DD2
FFF13D6E  fbe278020200           loc_FFF13D6E mov.l   #20278h, r14
FFF13D74  eee14dc0                          mov.l   30134h[r14], r1
FFF13D78  6602                              mov.l   #0, r2
FFF13D7A  ef23                              mov.l   r2, r3
FFF13D7C  05d35500                          bsr.a   sub_FFF1934F
FFF13D80  a009                              mov.l   r1, 10h+var_C[sp]
FFF13D82  a809                              mov.l   10h+var_C[sp], r1
FFF13D84  7501ff                            cmp     #-1, r1
FFF13D87  19                                bne.s   loc_FFF13D90
FFF13D88  9981                              mov.w   10h+var_4[sp], r1
FFF13D8A  6211                              add     #1, r1
FFF13D8C  9181                              mov.w   r1, 10h+var_4[sp]
FFF13D8E  2e2a                              bra.b   loc_FFF13DB8
FFF13D90  fbe278020200           loc_FFF13D90 mov.l   #20278h, r14
FFF13D96  eee44dc0                          mov.l   30134h[r14], r4
FFF13D9A  75432c                            mov.l   #2Ch, r3 ; ','
FFF13D9D  6612                              mov.l   #1, r2
FFF13D9F  fb12b4030500                      mov.l   #503B4h, r1
FFF13DA5  056b4700                          bsr.a   sub_FFF18510
FFF13DA9  a081                              mov.l   r1, 10h+var_8[sp]
FFF13DAB  a881                              mov.l   10h+var_8[sp], r1
FFF13DAD  75512c                            cmp     #2Ch, r1 ; ','
FFF13DB0  2010                              beq.b   loc_FFF13DC0
FFF13DB2  9981                              mov.w   10h+var_4[sp], r1
FFF13DB4  6211                              add     #1, r1
FFF13DB6  9181                              mov.w   r1, 10h+var_4[sp]
FFF13DB8  b981                   loc_FFF13DB8 movu.w  10h+var_4[sp], r1
FFF13DBA  6141                              cmp     #4, r1
FFF13DBC  2aab                              bgt.b   loc_FFF13D67
FFF13DBE  2eb0                              bra.b   loc_FFF13D6E
FFF13DC0  fb1278020200           loc_FFF13DC0 mov.l   #20278h, r1
FFF13DC6  ee124dc0                          mov.l   30134h[r1], r2
FFF13DCA  6261                              add     #6, r1
FFF13DCC  3949fd                            bsr.w   sub_FFF13B15
FFF13DCF  3d0100                            mov.w   #0, 10h+var_E[sp]
FFF13DD2  d5000107               loc_FFF13DD2 mov.w   10h+var_E[sp], 10h+var_2[sp]
FFF13DD6  b989                              movu.w  10h+var_2[sp], r1
FFF13DD8  6704                              rtsd    #4
FFF13DDA  7200e0fe               sub_FFF13DDA add     #-120h, sp, sp   ; <<<< FUNC sub_FFF13DDA
FFF13DDE  f9058e00                          mov.w   #0, 120h+var_4[sp]
FFF13DE2  f9058d00                          mov.w   #0, 120h+var_6[sp]
FFF13DE6  3c8400                            mov.b   #0, 120h+var_10C[sp]
FFF13DE9  3e0200                            mov.l   #0, 120h+var_118[sp]
FFF13DEC  3e0100                            mov.l   #0, 120h+var_11C[sp]
FFF13DEF  fbe278020200                      mov.l   #20278h, r14
FFF13DF5  ede143                            mov.l   10Ch[r14], r1
FFF13DF8  6081                              sub     #8, r1
FFF13DFA  fb22b4030500                      mov.l   #503B4h, r2
FFF13E00  a029                              mov.l   r1, 4[r2]
FFF13E02  fbe278020200                      mov.l   #20278h, r14
FFF13E08  ede143                            mov.l   10Ch[r14], r1
FFF13E0B  7111d4                            add     #-2Ch, r1, r1
FFF13E0E  fb22b4030500                      mov.l   #503B4h, r2
FFF13E14  a2a1                              mov.l   r1, 28h[r2]
FFF13E16  fbe278020200                      mov.l   #20278h, r14
FFF13E1C  eee14dc0                          mov.l   30134h[r14], r1
FFF13E20  6602                              mov.l   #0, r2
FFF13E22  ef23                              mov.l   r2, r3
FFF13E24  052b5500                          bsr.a   sub_FFF1934F
FFF13E28  a809                              mov.l   120h+var_11C[sp], r1
FFF13E2A  7501ff                            cmp     #-1, r1
FFF13E2D  fbe278020200                      mov.l   #20278h, r14
FFF13E33  eee44dc0                          mov.l   30134h[r14], r4
FFF13E37  2110                              bne.b   loc_FFF13E47
FFF13E39  ef41                              mov.l   r4, r1
FFF13E3B  05df2f00                          bsr.a   sub_FFF16E1A
FFF13E3F  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF13E44  386101                            bra.w   loc_FFF13FA5
FFF13E47  75432c                 loc_FFF13E47 mov.l   #2Ch, r3 ; ','
FFF13E4A  6612                              mov.l   #1, r2
FFF13E4C  fb12b4030500                      mov.l   #503B4h, r1
FFF13E52  05be4600                          bsr.a   sub_FFF18510
FFF13E56  a081                              mov.l   r1, 120h+var_118[sp]
FFF13E58  a881                              mov.l   120h+var_118[sp], r1
FFF13E5A  75512c                            cmp     #2Ch, r1 ; ','
FFF13E5D  fbe278020200                      mov.l   #20278h, r14
FFF13E63  eee14dc0                          mov.l   30134h[r14], r1
FFF13E67  200e                              beq.b   loc_FFF13E75
FFF13E69  05b12f00                          bsr.a   sub_FFF16E1A
FFF13E6D  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF13E72  383301                            bra.w   loc_FFF13FA5
FFF13E75  05a52f00               loc_FFF13E75 bsr.a   sub_FFF16E1A
FFF13E79  3c842e                            mov.b   #2Eh, 120h+var_10C[sp] ; '.'
FFF13E7C  b502                              movu.b  120h+var_10C[sp], r2
FFF13E7E  fb1278020200                      mov.l   #20278h, r1
FFF13E84  6261                              add     #6, r1
FFF13E86  05d41603                          bsr.a   sub_FFF4555A
FFF13E8A  a101                              mov.l   r1, 120h+var_110[sp]
FFF13E8C  fbe6ff                            mov.l   #-1, r14
FFF13E8F  6602                              mov.l   #0, r2
FFF13E91  a901                              mov.l   120h+var_110[sp], r1
FFF13E93  efe3                              mov.l   r14, r3
FFF13E95  7f80                              suntil.b
FFF13E97  fb46fe                            mov.l   #-2, r4
FFF13E9A  ff0f34                            sub     r3, r4, r15
FFF13E9D  fb1278020200                      mov.l   #20278h, r1
FFF13EA3  6261                              add     #6, r1
FFF13EA5  efe3                              mov.l   r14, r3
FFF13EA7  7f80                              suntil.b
FFF13EA9  4334                              sub     r3, r4
FFF13EAB  43f4                              sub     r15, r4
FFF13EAD  d7048e                            mov.w   r4, 120h+var_4[sp]
FFF13EB0  fb3a0001                          mov.l   #100h, r3
FFF13EB4  6602                              mov.l   #0, r2
FFF13EB6  71011a                            add     #120h+var_106, sp, r1
FFF13EB9  7f88                              sstr.b
FFF13EBB  fb2278020200                      mov.l   #20278h, r2
FFF13EC1  6262                              add     #6, r2
FFF13EC3  5d048e                            movu.w  120h+var_4[sp], r4
FFF13EC6  710e1a                            add     #120h+var_106, sp, r14
FFF13EC9  efe1                              mov.l   r14, r1
FFF13ECB  ef43                              mov.l   r4, r3
FFF13ECD  7f87                              smovu
FFF13ECF  4b4e                              add     r4, r14
FFF13ED1  efe1                              mov.l   r14, r1
FFF13ED3  4331                              sub     r3, r1
FFF13ED5  6602                              mov.l   #0, r2
FFF13ED7  7f88                              sstr.b
FFF13ED9  fbe278020200                      mov.l   #20278h, r14
FFF13EDF  73ee380103                        add     #30138h, r14, r14
FFF13EE4  5ce1                              movu.w  [r14], r1
FFF13EE6  6191                              cmp     #9, r1
FFF13EE8  2a19                              bgt.b   loc_FFF13F01
FFF13EEA  6080                              sub     #8, sp
FFF13EEC  fbe2b5adf4ff                      mov.l   #unk_FFF4ADB5, r14
FFF13EF2  e30e                              mov.l   r14, 128h+var_128[sp]
FFF13EF4  a009                              mov.l   r1, 128h+var_124[sp]
FFF13EF6  71011d                            add     #128h+var_10B, sp, r1
FFF13EF9  052b1603                          bsr.a   sub_FFF45524
FFF13EFD  6280                              add     #8, sp
FFF13EFF  2e17                              bra.b   loc_FFF13F16
FFF13F01  6080                   loc_FFF13F01 sub     #8, sp
FFF13F03  fbe2b9adf4ff                      mov.l   #unk_FFF4ADB9, r14
FFF13F09  e30e                              mov.l   r14, 128h+var_128[sp]
FFF13F0B  a009                              mov.l   r1, 128h+var_124[sp]
FFF13F0D  71011d                            add     #128h+var_10B, sp, r1
FFF13F10  05141603                          bsr.a   sub_FFF45524
FFF13F14  6280                              add     #8, sp
FFF13F16  fb36ff                 loc_FFF13F16 mov.l   #-1, r3
FFF13F19  6602                              mov.l   #0, r2
FFF13F1B  71011a                            add     #120h+var_106, sp, r1
FFF13F1E  7f80                              suntil.b
FFF13F20  6011                              sub     #1, r1
FFF13F22  710215                            add     #120h+var_10B, sp, r2
FFF13F25  7f87                              smovu
FFF13F27  fb36ff                            mov.l   #-1, r3
FFF13F2A  6602                              mov.l   #0, r2
FFF13F2C  71011a                            add     #120h+var_106, sp, r1
FFF13F2F  7f80                              suntil.b
FFF13F31  6011                              sub     #1, r1
FFF13F33  fb22bcadf4ff                      mov.l   #aWav, r2; ".wav"
FFF13F39  7f87                              smovu
FFF13F3B  fb22acadf4ff                      mov.l   #unk_FFF4ADAC, r2
FFF13F41  71011a                            add     #120h+var_106, sp, r1
FFF13F44  05042000                          bsr.a   sub_FFF15F48
FFF13F48  a089                              mov.l   r1, 120h+var_114[sp]
FFF13F4A  a88c                              mov.l   120h+var_114[sp], r4
FFF13F4C  6104                              cmp     #0, r4
FFF13F4E  210f                              bne.b   loc_FFF13F5D
FFF13F50  ef41                              mov.l   r4, r1
FFF13F52  05c82e00                          bsr.a   sub_FFF16E1A
FFF13F56  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF13F5B  2e4a                              bra.b   loc_FFF13FA5
FFF13F5D  75432c                 loc_FFF13F5D mov.l   #2Ch, r3 ; ','
FFF13F60  6612                              mov.l   #1, r2
FFF13F62  fb12b4030500                      mov.l   #503B4h, r1
FFF13F68  05a84500                          bsr.a   sub_FFF18510
FFF13F6C  a081                              mov.l   r1, 120h+var_118[sp]
FFF13F6E  a881                              mov.l   120h+var_118[sp], r1
FFF13F70  75512c                            cmp     #2Ch, r1 ; ','
FFF13F73  200f                              beq.b   loc_FFF13F82
FFF13F75  a889                              mov.l   120h+var_114[sp], r1
FFF13F77  05a32e00                          bsr.a   sub_FFF16E1A
FFF13F7B  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF13F80  2e25                              bra.b   loc_FFF13FA5
FFF13F82  fbe278020200           loc_FFF13F82 mov.l   #20278h, r14
FFF13F88  f9e6432c                          mov.l   #2Ch, 10Ch[r14] ; ','
FFF13F8C  fbe278020200                      mov.l   #20278h, r14
FFF13F92  f9e64200                          mov.l   #0, 108h[r14]
FFF13F96  fbe278020200                      mov.l   #20278h, r14
FFF13F9C  e90e034dc0                        mov.l   120h+var_114[sp], 30134h[r14]
FFF13FA1  d5008d01                          mov.w   120h+var_6[sp], 120h+var_11E[sp]
FFF13FA5  d500018f               loc_FFF13FA5 mov.w   120h+var_11E[sp], 120h+var_2[sp]
FFF13FA9  5d018f                            movu.w  120h+var_2[sp], r1
FFF13FAC  6748                              rtsd    #48h
FFF13FAE  7100ec                 sub_FFF13FAE add     #-14h, sp, sp   ; <<<< FUNC sub_FFF13FAE
FFF13FB1  a101                              mov.l   r1, 14h+var_4[sp]
FFF13FB3  3d0600                            mov.w   #0, 14h+var_8[sp]
FFF13FB6  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF13FB9  a901                              mov.l   14h+var_4[sp], r1
FFF13FBB  5c1e                              movu.w  [r1], r14
FFF13FBD  770effff00                        cmp     #0FFFFh, r14
FFF13FC2  16                                beq.s   loc_FFF13FC8
FFF13FC3  3d0101                            mov.w   #1, 14h+var_12[sp]
FFF13FC6  2e4a                              bra.b   loc_FFF14010
FFF13FC8  fbe2b8930600           loc_FFF13FC8 mov.l   #693B8h, r14
FFF13FCE  ede445                            mov.l   114h[r14], r4
FFF13FD1  a901                              mov.l   14h+var_4[sp], r1
FFF13FD3  a913                              mov.l   10h[r1], r3
FFF13FD5  a899                              mov.l   0Ch[r1], r1
FFF13FD7  6612                              mov.l   #1, r2
FFF13FD9  05374500                          bsr.a   sub_FFF18510
FFF13FDD  a081                              mov.l   r1, 14h+var_C[sp]
FFF13FDF  a901                              mov.l   14h+var_4[sp], r1
FFF13FE1  a882                              mov.l   14h+var_C[sp], r2
FFF13FE3  06851204                          cmp     10h[r1].l, r2
FFF13FE7  2018                              beq.b   loc_FFF13FFF
FFF13FE9  0529ae00                          bsr.a   sub_FFF1EE12
FFF13FED  a009                              mov.l   r1, 14h+var_10[sp]
FFF13FEF  a809                              mov.l   14h+var_10[sp], r1
FFF13FF1  7501f5                            cmp     #-0Bh, r1
FFF13FF4  1e                                bne.s   loc_FFF13FFA
FFF13FF5  3d0102                            mov.w   #2, 14h+var_12[sp]
FFF13FF8  2e18                              bra.b   loc_FFF14010
FFF13FFA  3d0101                 loc_FFF13FFA mov.w   #1, 14h+var_12[sp]
FFF13FFD  2e13                              bra.b   loc_FFF14010
FFF13FFF  fbe2b8930600           loc_FFF13FFF mov.l   #693B8h, r14
FFF14005  ede145                            mov.l   114h[r14], r1
FFF14008  05203200                          bsr.a   sub_FFF17228
FFF1400C  d5000601                          mov.w   14h+var_8[sp], 14h+var_12[sp]
FFF14010  d5000107               loc_FFF14010 mov.w   14h+var_12[sp], 14h+var_6[sp]
FFF14014  b989                              movu.w  14h+var_6[sp], r1
FFF14016  6705                              rtsd    #5
FFF14018  6040                   sub_FFF14018 sub     #4, sp   ; <<<< FUNC sub_FFF14018
FFF1401A  e301                              mov.l   r1, 4+var_4[sp]
FFF1401C  fbe293220100                      mov.l   #12293h, r14
FFF14022  58ee                              movu.b  [r14], r14
FFF14024  610e                              cmp     #0, r14
FFF14026  2051                              beq.b   loc_FFF14077
FFF14028  fbe294220100                      mov.l   #12294h, r14
FFF1402E  58ee                              movu.b  [r14], r14
FFF14030  751e14                            mul     #14h, r14
FFF14033  fb220ce40100                      mov.l   #1E40Ch, r2
FFF14039  4be2                              add     r14, r2
FFF1403B  fbe2986aecff                      mov.l   #unk_FFEC6A98, r14
FFF14041  5ce3                              movu.w  [r14], r3
FFF14043  ec01                              mov.l   4+var_4[sp], r1
FFF14045  7f8f                              smovf
FFF14047  fbe293220100                      mov.l   #12293h, r14
FFF1404D  58ef                              movu.b  [r14], r15
FFF1404F  601f                              sub     #1, r15
FFF14051  c3ef                              mov.b   r15, [r14]
FFF14053  fbe294220100                      mov.l   #12294h, r14
FFF14059  58ef                              movu.b  [r14], r15
FFF1405B  621f                              add     #1, r15
FFF1405D  c3ef                              mov.b   r15, [r14]
FFF1405F  fbe294220100                      mov.l   #12294h, r14
FFF14065  58ee                              movu.b  [r14], r14
FFF14067  755e80                            cmp     #-80h, r14
FFF1406A  210d                              bne.b   loc_FFF14077
FFF1406C  fbe294220100                      mov.l   #12294h, r14
FFF14072  f8e400                            mov.b   #0, [r14]
FFF14075  6701                              rtsd    #1
FFF14077  6701                   loc_FFF14077 rtsd    #1
FFF14079  fbe293220100           sub_FFF14079 mov.l   #12293h, r14   ; <<<< FUNC sub_FFF14079
FFF1407F  58ee                              movu.b  [r14], r14
FFF14081  710204                            add     #arg_0, sp, r2
FFF14084  755e80                            cmp     #-80h, r14
FFF14087  203f                              beq.b   loc_FFF140C6
FFF14089  fbe294220100                      mov.l   #12294h, r14
FFF1408F  58ee                              movu.b  [r14], r14
FFF14091  fbf293220100                      mov.l   #12293h, r15
FFF14097  48fe                              add     [r15], r14
FFF14099  efef                              mov.l   r14, r15
FFF1409B  fd788f8000                        div     #80h, r15
FFF140A0  6c7f                              shll    #7, r15
FFF140A2  43fe                              sub     r15, r14
FFF140A4  751e14                            mul     #14h, r14
FFF140A7  fb120ce40100                      mov.l   #1E40Ch, r1
FFF140AD  4be1                              add     r14, r1
FFF140AF  fbe2986aecff                      mov.l   #unk_FFEC6A98, r14
FFF140B5  5ce3                              movu.w  [r14], r3
FFF140B7  7f8f                              smovf
FFF140B9  fbe293220100                      mov.l   #12293h, r14
FFF140BF  58ef                              movu.b  [r14], r15
FFF140C1  621f                              add     #1, r15
FFF140C3  c3ef                              mov.b   r15, [r14]
FFF140C5  02                                rts
FFF140C6  02                     loc_FFF140C6 rts
FFF140C7  7200f0fe               sub_FFF140C7 add     #-110h, sp, sp   ; <<<< FUNC sub_FFF140C7
FFF140CB  e70143                            mov.l   r1, 110h+var_4[sp]
FFF140CE  f9058500                          mov.w   #0, 110h+var_6[sp]
FFF140D2  f9058400                          mov.w   #0, 110h+var_8[sp]
FFF140D6  3c075c                            mov.b   #5Ch, 110h+var_109[sp] ; '\'
FFF140D9  b18a                              movu.b  110h+var_109[sp], r2
FFF140DB  ed0143                            mov.l   110h+var_4[sp], r1
FFF140DE  057c1403                          bsr.a   sub_FFF4555A
FFF140E2  e301                              mov.l   r1, 110h+var_110[sp]
FFF140E4  660e                              mov.l   #0, r14
FFF140E6  ec04                              mov.l   110h+var_110[sp], r4
FFF140E8  fb36ff                            mov.l   #-1, r3
FFF140EB  ef41                              mov.l   r4, r1
FFF140ED  efe2                              mov.l   r14, r2
FFF140EF  7f80                              suntil.b
FFF140F1  fbf6fe                            mov.l   #-2, r15
FFF140F4  433f                              sub     r3, r15
FFF140F6  ef42                              mov.l   r4, r2
FFF140F8  6212                              add     #1, r2
FFF140FA  710508                            add     #110h+var_108, sp, r5
FFF140FD  ef51                              mov.l   r5, r1
FFF140FF  eff3                              mov.l   r15, r3
FFF14101  7f87                              smovu
FFF14103  4bf5                              add     r15, r5
FFF14105  ef51                              mov.l   r5, r1
FFF14107  4331                              sub     r3, r1
FFF14109  efe2                              mov.l   r14, r2
FFF1410B  7f88                              sstr.b
FFF1410D  fb1224ee0100                      mov.l   #1EE24h, r1
FFF14113  72111c01                          add     #11Ch, r1, r1
FFF14117  fb36ff                            mov.l   #-1, r3
FFF1411A  710208                            add     #110h+var_108, sp, r2
FFF1411D  7f87                              smovu
FFF1411F  fbe6ff                            mov.l   #-1, r14
FFF14122  6602                              mov.l   #0, r2
FFF14124  ed0143                            mov.l   110h+var_4[sp], r1
FFF14127  efe3                              mov.l   r14, r3
FFF14129  7f80                              suntil.b
FFF1412B  fbf6fe                            mov.l   #-2, r15
FFF1412E  ff043f                            sub     r3, r15, r4
FFF14131  ec01                              mov.l   110h+var_110[sp], r1
FFF14133  efe3                              mov.l   r14, r3
FFF14135  7f80                              suntil.b
FFF14137  433f                              sub     r3, r15
FFF14139  43f4                              sub     r15, r4
FFF1413B  d70485                            mov.w   r4, 110h+var_6[sp]
FFF1413E  f9058400                          mov.w   #0, 110h+var_8[sp]
FFF14142  2e19                              bra.b   loc_FFF1415B
FFF14144  5d0284                 loc_FFF14144 movu.w  110h+var_8[sp], r2
FFF14147  ed0343                            mov.l   110h+var_4[sp], r3
FFF1414A  fec32e                            movu.b  [r3, r2], r14
FFF1414D  710f08                            add     #110h+var_108, sp, r15
FFF14150  fe01fe                            mov.b   r14, [r1, r15]
FFF14153  dd0184                            mov.w   110h+var_8[sp], r1
FFF14156  6211                              add     #1, r1
FFF14158  d70184                            mov.w   r1, 110h+var_8[sp]
FFF1415B  5d0184                 loc_FFF1415B movu.w  110h+var_8[sp], r1
FFF1415E  06c50185                          cmp     110h+var_6[sp].uw, r1
FFF14162  29e2                              blt.b   loc_FFF14144
FFF14164  710e08                            add     #110h+var_108, sp, r14
FFF14167  660f                              mov.l   #0, r15
FFF14169  fe01ef                            mov.b   r15, [r1, r14]
FFF1416C  fb36ff                            mov.l   #-1, r3
FFF1416F  6602                              mov.l   #0, r2
FFF14171  710108                            add     #110h+var_108, sp, r1
FFF14174  7f80                              suntil.b
FFF14176  6011                              sub     #1, r1
FFF14178  fb22c1adf4ff                      mov.l   #aBackupBin, r2; "\\Backup.bin"
FFF1417E  7f87                              smovu
FFF14180  fb1224ee0100                      mov.l   #1EE24h, r1
FFF14186  72111c02                          add     #21Ch, r1, r1
FFF1418A  fb36ff                            mov.l   #-1, r3
FFF1418D  710208                            add     #110h+var_108, sp, r2
FFF14190  7f87                              smovu
FFF14192  6744                              rtsd    #44h
FFF14194  6080                   sub_FFF14194 sub     #8, sp   ; <<<< FUNC sub_FFF14194
FFF14196  3d0200                            mov.w   #0, 8+var_4[sp]
FFF14199  fbe297220100                      mov.l   #12297h, r14
FFF1419F  58ee                              movu.b  [r14], r14
FFF141A1  611e                              cmp     #1, r14
FFF141A3  19                                bne.s   loc_FFF141AC
FFF141A4  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF141A9  38ce00                            bra.w   loc_FFF14277
FFF141AC  fbe20a250100           loc_FFF141AC mov.l   #1250Ah, r14
FFF141B2  f8e500                            mov.w   #0, [r14]
FFF141B5  fb120a250100                      mov.l   #1250Ah, r1
FFF141BB  3d1100                            mov.w   #0, 2[r1]
FFF141BE  fb120a250100                      mov.l   #1250Ah, r1
FFF141C4  3d1200                            mov.w   #0, 4[r1]
FFF141C7  fbe278020200                      mov.l   #20278h, r14
FFF141CD  f8e500                            mov.w   #0, [r14]
FFF141D0  fb1278020200                      mov.l   #20278h, r1
FFF141D6  3d1205                            mov.w   #5, 4[r1]
FFF141D9  fbe2b4030500                      mov.l   #503B4h, r14
FFF141DF  f8e252494646                      mov.l   #46464952h, [r14]
FFF141E5  fb12b4030500                      mov.l   #503B4h, r1
FFF141EB  3e1100                            mov.l   #0, 4[r1]
FFF141EE  fbe2b4030500                      mov.l   #503B4h, r14
FFF141F4  f9e20257415645                    mov.l   #45564157h, 8[r14]
FFF141FB  fbe2b4030500                      mov.l   #503B4h, r14
FFF14201  f9e203666d7420                    mov.l   #20746D66h, 0Ch[r14]
FFF14208  fb12b4030500                      mov.l   #503B4h, r1
FFF1420E  3e1410                            mov.l   #10h, 10h[r1]
FFF14211  fb12b4030500                      mov.l   #503B4h, r1
FFF14217  3d1a01                            mov.w   #1, 14h[r1]
FFF1421A  fb12b4030500                      mov.l   #503B4h, r1
FFF14220  3d1b01                            mov.w   #1, 16h[r1]
FFF14223  fbe2b4030500                      mov.l   #503B4h, r14
FFF14229  f9ea06803e                        mov.l   #3E80h, 18h[r14]
FFF1422E  fbe2b4030500                      mov.l   #503B4h, r14
FFF14234  f9ea07007d                        mov.l   #7D00h, 1Ch[r14]
FFF14239  fb12b4030500                      mov.l   #503B4h, r1
FFF1423F  3d9002                            mov.w   #2, 20h[r1]
FFF14242  fb12b4030500                      mov.l   #503B4h, r1
FFF14248  3d9110                            mov.w   #10h, 22h[r1]
FFF1424B  fbe2b4030500                      mov.l   #503B4h, r14
FFF14251  f9e20964617461                    mov.l   #61746164h, 24h[r14]
FFF14258  fb12b4030500                      mov.l   #503B4h, r1
FFF1425E  3e1a00                            mov.l   #0, 28h[r1]
FFF14261  39070f                            bsr.w   sub_FFF15168
FFF14264  39f10d                            bsr.w   sub_FFF15055
FFF14267  39e113                            bsr.w   sub_FFF15648
FFF1426A  fbe297220100                      mov.l   #12297h, r14
FFF14270  f8e401                            mov.b   #1, [r14]
FFF14273  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]
FFF14277  d5000103               loc_FFF14277 mov.w   8+var_6[sp], 8+var_2[sp]
FFF1427B  b889                              movu.w  8+var_2[sp], r1
FFF1427D  6702                              rtsd    #2
FFF1427F  7100c8                 sub_FFF1427F add     #-38h, sp, sp   ; <<<< FUNC sub_FFF1427F
FFF14282  a309                              mov.l   r1, 38h+var_4[sp]
FFF14284  a302                              mov.l   r2, 38h+var_8[sp]
FFF14286  a28b                              mov.l   r3, 38h+var_C[sp]
FFF14288  3d8400                            mov.w   #0, 38h+var_10[sp]
FFF1428B  3e0400                            mov.l   #0, 38h+var_28[sp]
FFF1428E  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF14291  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF14294  fbe278020200                      mov.l   #20278h, r14
FFF1429A  5cee                              movu.w  [r14], r14
FFF1429C  612e                              cmp     #2, r14
FFF1429E  19                                bne.s   loc_FFF142A7
FFF1429F  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142A4  388701                            bra.w   loc_FFF1442B
FFF142A7  fb1278020200           loc_FFF142A7 mov.l   #20278h, r1
FFF142AD  b891                              movu.w  4[r1], r1
FFF142AF  6121                              cmp     #2, r1
FFF142B1  2121                              bne.b   loc_FFF142D2
FFF142B3  397105                            bsr.w   sub_FFF14824
FFF142B6  fbe278020200                      mov.l   #20278h, r14
FFF142BC  eeee4dc0                          mov.l   30134h[r14], r14
FFF142C0  610e                              cmp     #0, r14
FFF142C2  2010                              beq.b   loc_FFF142D2
FFF142C4  fbe278020200                      mov.l   #20278h, r14
FFF142CA  eee14dc0                          mov.l   30134h[r14], r1
FFF142CE  054c2b00                          bsr.a   sub_FFF16E1A
FFF142D2  ab09                   loc_FFF142D2 mov.l   38h+var_4[sp], r1
FFF142D4  710210                            add     #38h+var_28, sp, r2
FFF142D7  0529f7ff                          bsr.a   sub_FFF13A00
FFF142DB  9501                              mov.w   r1, 38h+var_10[sp]
FFF142DD  bd01                              movu.w  38h+var_10[sp], r1
FFF142DF  6101                              cmp     #0, r1
FFF142E1  11                                beq.s   loc_FFF142EA
FFF142E2  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142E7  384401                            bra.w   loc_FFF1442B
FFF142EA  ab01                   loc_FFF142EA mov.l   38h+var_8[sp], r1
FFF142EC  06850104                          cmp     38h+var_28[sp].l, r1
FFF142F0  250a                              bleu.b  loc_FFF142FA
FFF142F2  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142F7  383401                            bra.w   loc_FFF1442B
FFF142FA  fbe2d0940600           loc_FFF142FA mov.l   #694D0h, r14
FFF14300  e10e04                            mov.l   38h+var_28[sp], [r14]
FFF14303  fbe299220100                      mov.l   #12299h, r14
FFF14309  f8e401                            mov.b   #1, [r14]
FFF1430C  ab09                              mov.l   38h+var_4[sp], r1
FFF1430E  fb22d0adf4ff                      mov.l   #aR_1, r2; "r"
FFF14314  05341c00                          bsr.a   sub_FFF15F48
FFF14318  a081                              mov.l   r1, 38h+var_30[sp]
FFF1431A  a881                              mov.l   38h+var_30[sp], r1
FFF1431C  6101                              cmp     #0, r1
FFF1431E  212e                              bne.b   loc_FFF1434C
FFF14320  a882                              mov.l   38h+var_30[sp], r2
FFF14322  ab09                              mov.l   38h+var_4[sp], r1
FFF14324  05f1f7ff                          bsr.a   sub_FFF13B15
FFF14328  ab09                              mov.l   38h+var_4[sp], r1
FFF1432A  fb22d0adf4ff                      mov.l   #aR_1, r2; "r"
FFF14330  05181c00                          bsr.a   sub_FFF15F48
FFF14334  a081                              mov.l   r1, 38h+var_30[sp]
FFF14336  a881                              mov.l   38h+var_30[sp], r1
FFF14338  6101                              cmp     #0, r1
FFF1433A  2112                              bne.b   loc_FFF1434C
FFF1433C  a882                              mov.l   38h+var_30[sp], r2
FFF1433E  ab09                              mov.l   38h+var_4[sp], r1
FFF14340  05d5f7ff                          bsr.a   sub_FFF13B15
FFF14344  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14349  38e200                            bra.w   loc_FFF1442B
FFF1434C  ab01                   loc_FFF1434C mov.l   38h+var_8[sp], r1
FFF1434E  7c01                              btst    #0, r1
FFF14350  17                                beq.s   loc_FFF14357
FFF14351  ab01                              mov.l   38h+var_8[sp], r1
FFF14353  6211                              add     #1, r1
FFF14355  a301                              mov.l   r1, 38h+var_8[sp]
FFF14357  ab01                   loc_FFF14357 mov.l   38h+var_8[sp], r1
FFF14359  71112c                            add     #2Ch, r1, r1 ; ','
FFF1435C  a089                              mov.l   r1, 38h+var_2C[sp]
FFF1435E  a88a                              mov.l   38h+var_2C[sp], r2
FFF14360  a881                              mov.l   38h+var_30[sp], r1
FFF14362  6603                              mov.l   #0, r3
FFF14364  05eb4f00                          bsr.a   sub_FFF1934F
FFF14368  a009                              mov.l   r1, 38h+var_34[sp]
FFF1436A  a809                              mov.l   38h+var_34[sp], r1
FFF1436C  7501ff                            cmp     #-1, r1
FFF1436F  2110                              bne.b   loc_FFF1437F
FFF14371  a881                              mov.l   38h+var_30[sp], r1
FFF14373  05a72a00                          bsr.a   sub_FFF16E1A
FFF14377  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF1437C  38af00                            bra.w   loc_FFF1442B
FFF1437F  ab0a                   loc_FFF1437F mov.l   38h+var_4[sp], r2
FFF14381  fb1278020200                      mov.l   #20278h, r1
FFF14387  6261                              add     #6, r1
FFF14389  05c71103                          bsr.a   sub_FFF45550
FFF1438D  ab01                              mov.l   38h+var_8[sp], r1
FFF1438F  71112c                            add     #2Ch, r1, r1 ; ','
FFF14392  fbe278020200                      mov.l   #20278h, r14
FFF14398  e7e143                            mov.l   r1, 10Ch[r14]
FFF1439B  fbe278020200                      mov.l   #20278h, r14
FFF143A1  e50e0442                          mov.l   38h+var_28[sp], 108h[r14]
FFF143A5  fbe278020200                      mov.l   #20278h, r14
FFF143AB  e90e024dc0                        mov.l   38h+var_30[sp], 30134h[r14]
FFF143B0  3d0a00                            mov.w   #0, 38h+var_24[sp]
FFF143B3  e5000407                          mov.l   38h+var_28[sp], 38h+var_1C[sp]
FFF143B7  ab01                              mov.l   38h+var_8[sp], r1
FFF143B9  71112c                            add     #2Ch, r1, r1 ; ','
FFF143BC  a209                              mov.l   r1, 38h+var_14[sp]
FFF143BE  fb1278020200                      mov.l   #20278h, r1
FFF143C4  72112201                          add     #122h, r1, r1
FFF143C8  a201                              mov.l   r1, 38h+var_18[sp]
FFF143CA  e5000d06                          mov.l   38h+var_4[sp], 38h+var_20[sp]
FFF143CE  fbe278020200                      mov.l   #20278h, r14
FFF143D4  f9e59000                          mov.w   #0, 120h[r14]
FFF143D8  fbe278020200                      mov.l   #20278h, r14
FFF143DE  e90e0b4cc0                        mov.l   38h+var_C[sp], 30130h[r14]
FFF143E3  7100ec                            add     #-14h, sp, sp
FFF143E6  754314                            mov.l   #14h, r3
FFF143E9  710228                            add     #4Ch+var_24, sp, r2
FFF143EC  ef01                              mov.l   sp, r1
FFF143EE  7f8f                              smovf
FFF143F0  0589fcff                          bsr.a   sub_FFF14079
FFF143F4  710014                            add     #14h, sp, sp
FFF143F7  fbe278020200                      mov.l   #20278h, r14
FFF143FD  f8e501                            mov.w   #1, [r14]
FFF14400  fbe278020200                      mov.l   #20278h, r14
FFF14406  f9e58a01                          mov.w   #1, 114h[r14]
FFF1440A  fb1278020200                      mov.l   #20278h, r1
FFF14410  3d1202                            mov.w   #2, 4[r1]
FFF14413  fbe278020200                      mov.l   #20278h, r14
FFF14419  73ee3a0103                        add     #3013Ah, r14, r14
FFF1441E  f8e500                            mov.w   #0, [r14]
FFF14421  39fb0d                            bsr.w   sub_FFF1521C
FFF14424  39630c                            bsr.w   sub_FFF15087
FFF14427  d5001401                          mov.w   38h+var_10[sp], 38h+var_36[sp]
FFF1442B  d5000115               loc_FFF1442B mov.w   38h+var_36[sp], 38h+var_E[sp]
FFF1442F  bd09                              movu.w  38h+var_E[sp], r1
FFF14431  670e                              rtsd    #0Eh
FFF14433  7100cc                 sub_FFF14433 add     #-34h, sp, sp   ; <<<< FUNC sub_FFF14433
FFF14436  a301                              mov.l   r1, 34h+var_4[sp]
FFF14438  a28a                              mov.l   r2, 34h+var_8[sp]
FFF1443A  c7032b                            mov.b   r3, 34h+var_9[sp]
FFF1443D  3d8300                            mov.w   #0, 34h+var_E[sp]
FFF14440  3e0300                            mov.l   #0, 34h+var_28[sp]
FFF14443  3e0200                            mov.l   #0, 34h+var_2C[sp]
FFF14446  3e0100                            mov.l   #0, 34h+var_30[sp]
FFF14449  59012b                            movu.b  34h+var_9[sp], r1
FFF1444C  6111                              cmp     #1, r1
FFF1444E  3b1c01                            bne.w   loc_FFF1456A
FFF14451  396c04                            bsr.w   sub_FFF148BD
FFF14454  aa89                              mov.l   34h+var_8[sp], r1
FFF14456  7c01                              btst    #0, r1
FFF14458  17                                beq.s   loc_FFF1445F
FFF14459  aa89                              mov.l   34h+var_8[sp], r1
FFF1445B  6211                              add     #1, r1
FFF1445D  a289                              mov.l   r1, 34h+var_8[sp]
FFF1445F  fbe278020200           loc_FFF1445F mov.l   #20278h, r14
FFF14465  eee14dc0                          mov.l   30134h[r14], r1
FFF14469  fb3a0004                          mov.l   #400h, r3
FFF1446D  fb2278f20100                      mov.l   #1F278h, r2
FFF14473  054b4e00                          bsr.a   sub_FFF192BE
FFF14477  a009                              mov.l   r1, 34h+var_30[sp]
FFF14479  a809                              mov.l   34h+var_30[sp], r1
FFF1447B  6101                              cmp     #0, r1
FFF1447D  201a                              beq.b   loc_FFF14497
FFF1447F  39a503                            bsr.w   sub_FFF14824
FFF14482  fbe278020200                      mov.l   #20278h, r14
FFF14488  ede143                            mov.l   10Ch[r14], r1
FFF1448B  05453102                          bsr.a   sub_FFF375D0
FFF1448F  f90901ffff                        mov.w   #-1, 34h+var_32[sp]
FFF14494  38da00                            bra.w   loc_FFF1456E
FFF14497  fbe278020200           loc_FFF14497 mov.l   #20278h, r14
FFF1449D  eee14dc0                          mov.l   30134h[r14], r1
FFF144A1  05c95600                          bsr.a   sub_FFF19B6A
FFF144A5  a081                              mov.l   r1, 34h+var_2C[sp]
FFF144A7  aa89                              mov.l   34h+var_8[sp], r1
FFF144A9  06810102                          sub     34h+var_2C[sp].l, r1
FFF144AD  a089                              mov.l   r1, 34h+var_28[sp]
FFF144AF  fbe278020200                      mov.l   #20278h, r14
FFF144B5  eee14dc0                          mov.l   30134h[r14], r1
FFF144B9  a88a                              mov.l   34h+var_28[sp], r2
FFF144BB  6613                              mov.l   #1, r3
FFF144BD  05924e00                          bsr.a   sub_FFF1934F
FFF144C1  a009                              mov.l   r1, 34h+var_30[sp]
FFF144C3  a809                              mov.l   34h+var_30[sp], r1
FFF144C5  7501ff                            cmp     #-1, r1
FFF144C8  2128                              bne.b   loc_FFF144F0
FFF144CA  fbe278020200                      mov.l   #20278h, r14
FFF144D0  eee14dc0                          mov.l   30134h[r14], r1
FFF144D4  05462900                          bsr.a   sub_FFF16E1A
FFF144D8  394c03                            bsr.w   sub_FFF14824
FFF144DB  fbe278020200                      mov.l   #20278h, r14
FFF144E1  ede143                            mov.l   10Ch[r14], r1
FFF144E4  05ec3002                          bsr.a   sub_FFF375D0
FFF144E8  f90901ffff                        mov.w   #-1, 34h+var_32[sp]
FFF144ED  388100                            bra.w   loc_FFF1456E
FFF144F0  a881                   loc_FFF144F0 mov.l   34h+var_2C[sp], r1
FFF144F2  06890103                          add     34h+var_28[sp].l, r1
FFF144F6  fbe278020200                      mov.l   #20278h, r14
FFF144FC  e7e143                            mov.l   r1, 10Ch[r14]
FFF144FF  3d0800                            mov.w   #0, 34h+var_24[sp]
FFF14502  fbe278020200                      mov.l   #20278h, r14
FFF14508  e5e04308                          mov.l   10Ch[r14], 34h+var_14[sp]
FFF1450C  fb1278020200                      mov.l   #20278h, r1
FFF14512  72112201                          add     #122h, r1, r1
FFF14516  a189                              mov.l   r1, 34h+var_18[sp]
FFF14518  e5000c05                          mov.l   34h+var_4[sp], 34h+var_20[sp]
FFF1451C  7100ec                            add     #-14h, sp, sp
FFF1451F  754314                            mov.l   #14h, r3
FFF14522  710224                            add     #48h+var_24, sp, r2
FFF14525  ef01                              mov.l   sp, r1
FFF14527  7f8f                              smovf
FFF14529  0550fbff                          bsr.a   sub_FFF14079
FFF1452D  710014                            add     #14h, sp, sp
FFF14530  fbe278020200                      mov.l   #20278h, r14
FFF14536  f9e59000                          mov.w   #0, 120h[r14]
FFF1453A  fbe278020200                      mov.l   #20278h, r14
FFF14540  f8e501                            mov.w   #1, [r14]
FFF14543  fbe278020200                      mov.l   #20278h, r14
FFF14549  f9e58a01                          mov.w   #1, 114h[r14]
FFF1454D  fb1278020200                      mov.l   #20278h, r1
FFF14553  3d1202                            mov.w   #2, 4[r1]
FFF14556  fbe278020200                      mov.l   #20278h, r14
FFF1455C  73ee3a0103                        add     #3013Ah, r14, r14
FFF14561  f8e500                            mov.w   #0, [r14]
FFF14564  39b80c                            bsr.w   sub_FFF1521C
FFF14567  39200b                            bsr.w   sub_FFF15087
FFF1456A  d5001301               loc_FFF1456A mov.w   34h+var_E[sp], 34h+var_32[sp]
FFF1456E  d5000114               loc_FFF1456E mov.w   34h+var_32[sp], 34h+var_C[sp]
FFF14572  bd01                              movu.w  34h+var_C[sp], r1
FFF14574  670d                              rtsd    #0Dh
FFF14576  7100c8                 sub_FFF14576 add     #-38h, sp, sp   ; <<<< FUNC sub_FFF14576
FFF14579  a309                              mov.l   r1, 38h+var_4[sp]
FFF1457B  a302                              mov.l   r2, 38h+var_8[sp]
FFF1457D  a28b                              mov.l   r3, 38h+var_C[sp]
FFF1457F  3d8400                            mov.w   #0, 38h+var_10[sp]
FFF14582  3e0400                            mov.l   #0, 38h+var_28[sp]
FFF14585  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF14588  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF1458B  fbe278020200                      mov.l   #20278h, r14
FFF14591  5cee                              movu.w  [r14], r14
FFF14593  612e                              cmp     #2, r14
FFF14595  19                                bne.s   loc_FFF1459E
FFF14596  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF1459B  385901                            bra.w   loc_FFF146F4
FFF1459E  fb1278020200           loc_FFF1459E mov.l   #20278h, r1
FFF145A4  b891                              movu.w  4[r1], r1
FFF145A6  6121                              cmp     #2, r1
FFF145A8  2121                              bne.b   loc_FFF145C9
FFF145AA  397a02                            bsr.w   sub_FFF14824
FFF145AD  fbe278020200                      mov.l   #20278h, r14
FFF145B3  eeee4dc0                          mov.l   30134h[r14], r14
FFF145B7  610e                              cmp     #0, r14
FFF145B9  2010                              beq.b   loc_FFF145C9
FFF145BB  fbe278020200                      mov.l   #20278h, r14
FFF145C1  eee14dc0                          mov.l   30134h[r14], r1
FFF145C5  05552800                          bsr.a   sub_FFF16E1A
FFF145C9  ab09                   loc_FFF145C9 mov.l   38h+var_4[sp], r1
FFF145CB  710210                            add     #38h+var_28, sp, r2
FFF145CE  0532f4ff                          bsr.a   sub_FFF13A00
FFF145D2  9501                              mov.w   r1, 38h+var_10[sp]
FFF145D4  bd01                              movu.w  38h+var_10[sp], r1
FFF145D6  6101                              cmp     #0, r1
FFF145D8  11                                beq.s   loc_FFF145E1
FFF145D9  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF145DE  381601                            bra.w   loc_FFF146F4
FFF145E1  ab01                   loc_FFF145E1 mov.l   38h+var_8[sp], r1
FFF145E3  06850104                          cmp     38h+var_28[sp].l, r1
FFF145E7  250a                              bleu.b  loc_FFF145F1
FFF145E9  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF145EE  380601                            bra.w   loc_FFF146F4
FFF145F1  fbe2d0940600           loc_FFF145F1 mov.l   #694D0h, r14
FFF145F7  e10e04                            mov.l   38h+var_28[sp], [r14]
FFF145FA  fbe299220100                      mov.l   #12299h, r14
FFF14600  f8e401                            mov.b   #1, [r14]
FFF14603  ab09                              mov.l   38h+var_4[sp], r1
FFF14605  fb22d0adf4ff                      mov.l   #aR_1, r2; "r"
FFF1460B  053d1900                          bsr.a   sub_FFF15F48
FFF1460F  a081                              mov.l   r1, 38h+var_30[sp]
FFF14611  a881                              mov.l   38h+var_30[sp], r1
FFF14613  6101                              cmp     #0, r1
FFF14615  2110                              bne.b   loc_FFF14625
FFF14617  a881                              mov.l   38h+var_30[sp], r1
FFF14619  05012800                          bsr.a   sub_FFF16E1A
FFF1461D  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14622  38d200                            bra.w   loc_FFF146F4
FFF14625  ab01                   loc_FFF14625 mov.l   38h+var_8[sp], r1
FFF14627  7c01                              btst    #0, r1
FFF14629  17                                beq.s   loc_FFF14630
FFF1462A  ab01                              mov.l   38h+var_8[sp], r1
FFF1462C  6211                              add     #1, r1
FFF1462E  a301                              mov.l   r1, 38h+var_8[sp]
FFF14630  e5000c03               loc_FFF14630 mov.l   38h+var_8[sp], 38h+var_2C[sp]
FFF14634  a88a                              mov.l   38h+var_2C[sp], r2
FFF14636  a881                              mov.l   38h+var_30[sp], r1
FFF14638  6603                              mov.l   #0, r3
FFF1463A  05154d00                          bsr.a   sub_FFF1934F
FFF1463E  a009                              mov.l   r1, 38h+var_34[sp]
FFF14640  a809                              mov.l   38h+var_34[sp], r1
FFF14642  7501ff                            cmp     #-1, r1
FFF14645  2110                              bne.b   loc_FFF14655
FFF14647  a881                              mov.l   38h+var_30[sp], r1
FFF14649  05d12700                          bsr.a   sub_FFF16E1A
FFF1464D  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14652  38a200                            bra.w   loc_FFF146F4
FFF14655  ab0a                   loc_FFF14655 mov.l   38h+var_4[sp], r2
FFF14657  fb1278020200                      mov.l   #20278h, r1
FFF1465D  6261                              add     #6, r1
FFF1465F  05f10e03                          bsr.a   sub_FFF45550
FFF14663  fbe278020200                      mov.l   #20278h, r14
FFF14669  e50e0c43                          mov.l   38h+var_8[sp], 10Ch[r14]
FFF1466D  fbe278020200                      mov.l   #20278h, r14
FFF14673  e50e0442                          mov.l   38h+var_28[sp], 108h[r14]
FFF14677  fbe278020200                      mov.l   #20278h, r14
FFF1467D  e90e024dc0                        mov.l   38h+var_30[sp], 30134h[r14]
FFF14682  3d0a00                            mov.w   #0, 38h+var_24[sp]
FFF14685  e5000407                          mov.l   38h+var_28[sp], 38h+var_1C[sp]
FFF14689  e5000c09                          mov.l   38h+var_8[sp], 38h+var_14[sp]
FFF1468D  fb1278020200                      mov.l   #20278h, r1
FFF14693  72112201                          add     #122h, r1, r1
FFF14697  a201                              mov.l   r1, 38h+var_18[sp]
FFF14699  e5000d06                          mov.l   38h+var_4[sp], 38h+var_20[sp]
FFF1469D  fbe278020200                      mov.l   #20278h, r14
FFF146A3  f9e59000                          mov.w   #0, 120h[r14]
FFF146A7  fbe278020200                      mov.l   #20278h, r14
FFF146AD  e90e0b4cc0                        mov.l   38h+var_C[sp], 30130h[r14]
FFF146B2  7100ec                            add     #-14h, sp, sp
FFF146B5  754314                            mov.l   #14h, r3
FFF146B8  710228                            add     #4Ch+var_24, sp, r2
FFF146BB  ef01                              mov.l   sp, r1
FFF146BD  7f8f                              smovf
FFF146BF  05baf9ff                          bsr.a   sub_FFF14079
FFF146C3  710014                            add     #14h, sp, sp
FFF146C6  fbe278020200                      mov.l   #20278h, r14
FFF146CC  f8e501                            mov.w   #1, [r14]
FFF146CF  fbe278020200                      mov.l   #20278h, r14
FFF146D5  f9e58a01                          mov.w   #1, 114h[r14]
FFF146D9  fb1278020200                      mov.l   #20278h, r1
FFF146DF  3d1202                            mov.w   #2, 4[r1]
FFF146E2  fbe278020200                      mov.l   #20278h, r14
FFF146E8  73ee3a0103                        add     #3013Ah, r14, r14
FFF146ED  f8e500                            mov.w   #0, [r14]
FFF146F0  d5001401                          mov.w   38h+var_10[sp], 38h+var_36[sp]
FFF146F4  d5000115               loc_FFF146F4 mov.w   38h+var_36[sp], 38h+var_E[sp]
FFF146F8  bd09                              movu.w  38h+var_E[sp], r1
FFF146FA  670e                              rtsd    #0Eh
FFF146FC  6080                   sub_FFF146FC sub     #8, sp   ; <<<< FUNC sub_FFF146FC
FFF146FE  3e0100                            mov.l   #0, 8+var_4[sp]
FFF14701  fbe278020200                      mov.l   #20278h, r14
FFF14707  73ee3a0103                        add     #3013Ah, r14, r14
FFF1470C  f8e501                            mov.w   #1, [r14]
FFF1470F  fbe278020200                      mov.l   #20278h, r14
FFF14715  ede143                            mov.l   10Ch[r14], r1
FFF14718  7311008002                        add     #28000h, r1, r1
FFF1471D  a009                              mov.l   r1, 8+var_4[sp]
FFF1471F  fbe278020200                      mov.l   #20278h, r14
FFF14725  a809                              mov.l   8+var_4[sp], r1
FFF14727  0685e142                          cmp     108h[r14].l, r1
FFF1472B  250c                              bleu.b  loc_FFF14737
FFF1472D  fbe278020200                      mov.l   #20278h, r14
FFF14733  e5e04201                          mov.l   108h[r14], 8+var_4[sp]
FFF14737  fbe278020200           loc_FFF14737 mov.l   #20278h, r14
FFF1473D  f8e501                            mov.w   #1, [r14]
FFF14740  fbe278020200                      mov.l   #20278h, r14
FFF14746  f9e58a01                          mov.w   #1, 114h[r14]
FFF1474A  fbe278020200                      mov.l   #20278h, r14
FFF14750  fae596c000                        mov.w   #0, 1812Ch[r14]
FFF14755  fbe278020200                      mov.l   #20278h, r14
FFF1475B  e50e0143                          mov.l   8+var_4[sp], 10Ch[r14]
FFF1475F  a809                              mov.l   8+var_4[sp], r1
FFF14761  056f2e02                          bsr.a   sub_FFF375D0
FFF14765  fbe278020200                      mov.l   #20278h, r14
FFF1476B  a809                              mov.l   8+var_4[sp], r1
FFF1476D  0685e142                          cmp     108h[r14].l, r1
FFF14771  2129                              bne.b   loc_FFF1479A
FFF14773  39b100                            bsr.w   sub_FFF14824
FFF14776  fbe278020200                      mov.l   #20278h, r14
FFF1477C  e2e04cc0                          mov.l   30130h[r14], 8+var_8[sp]
FFF14780  ec01                              mov.l   8+var_8[sp], r1
FFF14782  6101                              cmp     #0, r1
FFF14784  17                                beq.s   loc_FFF1478B
FFF14785  ec02                              mov.l   8+var_8[sp], r2
FFF14787  6611                              mov.l   #1, r1
FFF14789  7f12                              jsr     r2
FFF1478B  fbe278020200           loc_FFF1478B mov.l   #20278h, r14
FFF14791  ede143                            mov.l   10Ch[r14], r1
FFF14794  053c2e02                          bsr.a   sub_FFF375D0
FFF14798  6702                              rtsd    #2
FFF1479A  6702                   loc_FFF1479A rtsd    #2
FFF1479C  6080                   sub_FFF1479C sub     #8, sp   ; <<<< FUNC sub_FFF1479C
FFF1479E  3e0100                            mov.l   #0, 8+var_4[sp]
FFF147A1  fbe278020200                      mov.l   #20278h, r14
FFF147A7  73ee3a0103                        add     #3013Ah, r14, r14
FFF147AC  f8e502                            mov.w   #2, [r14]
FFF147AF  fbe278020200                      mov.l   #20278h, r14
FFF147B5  edee43                            mov.l   10Ch[r14], r14
FFF147B8  770eff7f02                        cmp     #27FFFh, r14
FFF147BD  2407                              bgtu.b  loc_FFF147C4
FFF147BF  3e0100                            mov.l   #0, 8+var_4[sp]
FFF147C2  2e12                              bra.b   loc_FFF147D4
FFF147C4  fbe278020200           loc_FFF147C4 mov.l   #20278h, r14
FFF147CA  ede143                            mov.l   10Ch[r14], r1
FFF147CD  73110080fd                        add     #-28000h, r1, r1
FFF147D2  a009                              mov.l   r1, 8+var_4[sp]
FFF147D4  fbe278020200           loc_FFF147D4 mov.l   #20278h, r14
FFF147DA  f8e501                            mov.w   #1, [r14]
FFF147DD  fbe278020200                      mov.l   #20278h, r14
FFF147E3  f9e58a01                          mov.w   #1, 114h[r14]
FFF147E7  fbe278020200                      mov.l   #20278h, r14
FFF147ED  fae596c000                        mov.w   #0, 1812Ch[r14]
FFF147F2  fbe278020200                      mov.l   #20278h, r14
FFF147F8  e50e0143                          mov.l   8+var_4[sp], 10Ch[r14]
FFF147FC  a809                              mov.l   8+var_4[sp], r1
FFF147FE  05d22d02                          bsr.a   sub_FFF375D0
FFF14802  a809                              mov.l   8+var_4[sp], r1
FFF14804  6101                              cmp     #0, r1
FFF14806  211c                              bne.b   loc_FFF14822
FFF14808  39b500                            bsr.w   sub_FFF148BD
FFF1480B  fbe278020200                      mov.l   #20278h, r14
FFF14811  e2e04cc0                          mov.l   30130h[r14], 8+var_8[sp]
FFF14815  ec01                              mov.l   8+var_8[sp], r1
FFF14817  6101                              cmp     #0, r1
FFF14819  11                                beq.s   loc_FFF14822
FFF1481A  ec02                              mov.l   8+var_8[sp], r2
FFF1481C  6651                              mov.l   #5, r1
FFF1481E  7f12                              jsr     r2
FFF14820  6702                              rtsd    #2
FFF14822  6702                   loc_FFF14822 rtsd    #2
FFF14824  6040                   sub_FFF14824 sub     #4, sp   ; <<<< FUNC sub_FFF14824
FFF14826  f80500                            mov.w   #0, 4+var_4[sp]
FFF14829  39020a                            bsr.w   sub_FFF1522B
FFF1482C  39a608                            bsr.w   sub_FFF150D2
FFF1482F  fbe278020200                      mov.l   #20278h, r14
FFF14835  f8e500                            mov.w   #0, [r14]
FFF14838  fb1278020200                      mov.l   #20278h, r1
FFF1483E  3d1200                            mov.w   #0, 4[r1]
FFF14841  fbe278020200                      mov.l   #20278h, r14
FFF14847  f9e64200                          mov.l   #0, 108h[r14]
FFF1484B  fbe278020200                      mov.l   #20278h, r14
FFF14851  f9e64300                          mov.l   #0, 10Ch[r14]
FFF14855  fb1278020200                      mov.l   #20278h, r1
FFF1485B  6261                              add     #6, r1
FFF1485D  fb22d2adf4ff                      mov.l   #unk_FFF4ADD2, r2
FFF14863  05ed0c03                          bsr.a   sub_FFF45550
FFF14867  fbe278020200                      mov.l   #20278h, r14
FFF1486D  f9e64600                          mov.l   #0, 118h[r14]
FFF14871  fbe278020200                      mov.l   #20278h, r14
FFF14877  f9e64700                          mov.l   #0, 11Ch[r14]
FFF1487B  fbe278020200                      mov.l   #20278h, r14
FFF14881  f9e59001                          mov.w   #1, 120h[r14]
FFF14885  fbe278020200                      mov.l   #20278h, r14
FFF1488B  fae6496000                        mov.l   #0, 18124h[r14]
FFF14890  fbe278020200                      mov.l   #20278h, r14
FFF14896  fae64a6000                        mov.l   #0, 18128h[r14]
FFF1489B  fbe278020200                      mov.l   #20278h, r14
FFF148A1  fae596c001                        mov.w   #1, 1812Ch[r14]
FFF148A6  fbe278020200                      mov.l   #20278h, r14
FFF148AC  73ee3a0103                        add     #3013Ah, r14, r14
FFF148B1  f8e500                            mov.w   #0, [r14]
FFF148B4  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF148B7  9809                              mov.w   4+var_2[sp], r1
FFF148B9  5f11                              movu.w  r1, r1
FFF148BB  6701                              rtsd    #1
FFF148BD  396e09                 sub_FFF148BD bsr.w   sub_FFF1522B   ; <<<< FUNC sub_FFF148BD
FFF148C0  391208                            bsr.w   sub_FFF150D2
FFF148C3  fbe278020200                      mov.l   #20278h, r14
FFF148C9  f8e500                            mov.w   #0, [r14]
FFF148CC  fb1278020200                      mov.l   #20278h, r1
FFF148D2  3d1200                            mov.w   #0, 4[r1]
FFF148D5  fbe278020200                      mov.l   #20278h, r14
FFF148DB  f9e64600                          mov.l   #0, 118h[r14]
FFF148DF  fbe278020200                      mov.l   #20278h, r14
FFF148E5  f9e64700                          mov.l   #0, 11Ch[r14]
FFF148E9  fbe278020200                      mov.l   #20278h, r14
FFF148EF  f9e59001                          mov.w   #1, 120h[r14]
FFF148F3  fbe278020200                      mov.l   #20278h, r14
FFF148F9  fae6496000                        mov.l   #0, 18124h[r14]
FFF148FE  fbe278020200                      mov.l   #20278h, r14
FFF14904  fae64a6000                        mov.l   #0, 18128h[r14]
FFF14909  fbe278020200                      mov.l   #20278h, r14
FFF1490F  fae596c001                        mov.w   #1, 1812Ch[r14]
FFF14914  fbe278020200                      mov.l   #20278h, r14
FFF1491A  73ee3a0103                        add     #3013Ah, r14, r14
FFF1491F  f8e500                            mov.w   #0, [r14]
FFF14922  02                                rts
FFF14923  6080                   sub_FFF14923 sub     #8, sp   ; <<<< FUNC sub_FFF14923
FFF14925  3d0200                            mov.w   #0, 8+var_4[sp]
FFF14928  fb1278020200                      mov.l   #20278h, r1
FFF1492E  b891                              movu.w  4[r1], r1
FFF14930  6121                              cmp     #2, r1
FFF14932  10                                beq.s   loc_FFF1493A
FFF14933  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF14938  2e6b                              bra.b   loc_FFF149A3
FFF1493A  39f108                 loc_FFF1493A bsr.w   sub_FFF1522B
FFF1493D  399507                            bsr.w   sub_FFF150D2
FFF14940  fb1278020200                      mov.l   #20278h, r1
FFF14946  3d1200                            mov.w   #0, 4[r1]
FFF14949  fbe278020200                      mov.l   #20278h, r14
FFF1494F  f8e500                            mov.w   #0, [r14]
FFF14952  fbe278020200                      mov.l   #20278h, r14
FFF14958  f9e64600                          mov.l   #0, 118h[r14]
FFF1495C  fbe278020200                      mov.l   #20278h, r14
FFF14962  f9e64700                          mov.l   #0, 11Ch[r14]
FFF14966  fbe278020200                      mov.l   #20278h, r14
FFF1496C  f9e59001                          mov.w   #1, 120h[r14]
FFF14970  fbe278020200                      mov.l   #20278h, r14
FFF14976  fae6496000                        mov.l   #0, 18124h[r14]
FFF1497B  fbe278020200                      mov.l   #20278h, r14
FFF14981  fae64a6000                        mov.l   #0, 18128h[r14]
FFF14986  fbe278020200                      mov.l   #20278h, r14
FFF1498C  fae596c001                        mov.w   #1, 1812Ch[r14]
FFF14991  fbe278020200                      mov.l   #20278h, r14
FFF14997  73ee3a0103                        add     #3013Ah, r14, r14
FFF1499C  f8e500                            mov.w   #0, [r14]
FFF1499F  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]
FFF149A3  d5000103               loc_FFF149A3 mov.w   8+var_6[sp], 8+var_2[sp]
FFF149A7  b889                              movu.w  8+var_2[sp], r1
FFF149A9  6702                              rtsd    #2
FFF149AB  7100e4                 sub_FFF149AB add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF149AB
FFF149AE  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF149B0  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF149B2  3d0800                            mov.w   #0, 1Ch+var_C[sp]
FFF149B5  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF149B8  fbe278020200                      mov.l   #20278h, r14
FFF149BE  5cee                              movu.w  [r14], r14
FFF149C0  611e                              cmp     #1, r14
FFF149C2  19                                bne.s   loc_FFF149CB
FFF149C3  f90903ffff                        mov.w   #-1, 1Ch+var_16[sp]
FFF149C8  381f01                            bra.w   loc_FFF14AE7
FFF149CB  fb1278020200           loc_FFF149CB mov.l   #20278h, r1
FFF149D1  b891                              movu.w  4[r1], r1
FFF149D3  6131                              cmp     #3, r1
FFF149D5  200d                              beq.b   loc_FFF149E2
FFF149D7  fb1278020200                      mov.l   #20278h, r1
FFF149DD  b891                              movu.w  4[r1], r1
FFF149DF  6141                              cmp     #4, r1
FFF149E1  1d                                bne.s   loc_FFF149E6
FFF149E2  f80601                 loc_FFF149E2 mov.l   #1, 1Ch+var_1C[sp]
FFF149E5  0c                                bra.s   loc_FFF149E9
FFF149E6  f80600                 loc_FFF149E6 mov.l   #0, 1Ch+var_1C[sp]
FFF149E9  ec01                   loc_FFF149E9 mov.l   1Ch+var_1C[sp], r1
FFF149EB  6101                              cmp     #0, r1
FFF149ED  11                                beq.s   loc_FFF149F6
FFF149EE  f90903ffff                        mov.w   #-1, 1Ch+var_16[sp]
FFF149F3  38f400                            bra.w   loc_FFF14AE7
FFF149F6  a981                   loc_FFF149F6 mov.l   1Ch+var_4[sp], r1
FFF149F8  fb22d3adf4ff                      mov.l   #aW_0, r2; "w"
FFF149FE  054a1500                          bsr.a   sub_FFF15F48
FFF14A02  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF14A04  a889                              mov.l   1Ch+var_10[sp], r1
FFF14A06  6101                              cmp     #0, r1
FFF14A08  2110                              bne.b   loc_FFF14A18
FFF14A0A  a889                              mov.l   1Ch+var_10[sp], r1
FFF14A0C  050e2400                          bsr.a   sub_FFF16E1A
FFF14A10  f90903ffff                        mov.w   #-1, 1Ch+var_16[sp]
FFF14A15  38d200                            bra.w   loc_FFF14AE7
FFF14A18  fb12b4030500           loc_FFF14A18 mov.l   #503B4h, r1
FFF14A1E  3e1100                            mov.l   #0, 4[r1]
FFF14A21  fb12b4030500                      mov.l   #503B4h, r1
FFF14A27  3e1a00                            mov.l   #0, 28h[r1]
FFF14A2A  a88c                              mov.l   1Ch+var_10[sp], r4
FFF14A2C  75432c                            mov.l   #2Ch, r3 ; ','
FFF14A2F  6612                              mov.l   #1, r2
FFF14A31  fb12b4030500                      mov.l   #503B4h, r1
FFF14A37  05d93a00                          bsr.a   sub_FFF18510
FFF14A3B  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF14A3D  a881                              mov.l   1Ch+var_14[sp], r1
FFF14A3F  75512c                            cmp     #2Ch, r1 ; ','
FFF14A42  2010                              beq.b   loc_FFF14A52
FFF14A44  a889                              mov.l   1Ch+var_10[sp], r1
FFF14A46  05d42300                          bsr.a   sub_FFF16E1A
FFF14A4A  f90903ffff                        mov.w   #-1, 1Ch+var_16[sp]
FFF14A4F  389800                            bra.w   loc_FFF14AE7
FFF14A52  a982                   loc_FFF14A52 mov.l   1Ch+var_4[sp], r2
FFF14A54  fb1278020200                      mov.l   #20278h, r1
FFF14A5A  6261                              add     #6, r1
FFF14A5C  05f40a03                          bsr.a   sub_FFF45550
FFF14A60  fbe278020200                      mov.l   #20278h, r14
FFF14A66  f9e64300                          mov.l   #0, 10Ch[r14]
FFF14A6A  fbe278020200                      mov.l   #20278h, r14
FFF14A70  f9e64200                          mov.l   #0, 108h[r14]
FFF14A74  fbe278020200                      mov.l   #20278h, r14
FFF14A7A  f8e502                            mov.w   #2, [r14]
FFF14A7D  fbe278020200                      mov.l   #20278h, r14
FFF14A83  f9e58a01                          mov.w   #1, 114h[r14]
FFF14A87  fbe278020200                      mov.l   #20278h, r14
FFF14A8D  f9e64600                          mov.l   #0, 118h[r14]
FFF14A91  fbe278020200                      mov.l   #20278h, r14
FFF14A97  f9e59003                          mov.w   #3, 120h[r14]
FFF14A9B  fbe278020200                      mov.l   #20278h, r14
FFF14AA1  fae596c003                        mov.w   #3, 1812Ch[r14]
FFF14AA6  fb1278020200                      mov.l   #20278h, r1
FFF14AAC  3d1203                            mov.w   #3, 4[r1]
FFF14AAF  fbe278020200                      mov.l   #20278h, r14
FFF14AB5  f9e6432c                          mov.l   #2Ch, 10Ch[r14] ; ','
FFF14AB9  fbe278020200                      mov.l   #20278h, r14
FFF14ABF  e90e054cc0                        mov.l   1Ch+var_8[sp], 30130h[r14]
FFF14AC4  fbe278020200                      mov.l   #20278h, r14
FFF14ACA  e90e034dc0                        mov.l   1Ch+var_10[sp], 30134h[r14]
FFF14ACF  fbe278020200                      mov.l   #20278h, r14
FFF14AD5  73ee380103                        add     #30138h, r14, r14
FFF14ADA  f8e500                            mov.w   #0, [r14]
FFF14ADD  393f07                            bsr.w   sub_FFF1521C
FFF14AE0  39860c                            bsr.w   sub_FFF15766
FFF14AE3  d5000803                          mov.w   1Ch+var_C[sp], 1Ch+var_16[sp]
FFF14AE7  d5000309               loc_FFF14AE7 mov.w   1Ch+var_16[sp], 1Ch+var_A[sp]
FFF14AEB  ba09                              movu.w  1Ch+var_A[sp], r1
FFF14AED  6707                              rtsd    #7
FFF14AEF  7100e0                 sub_FFF14AEF add     #-20h, sp, sp   ; <<<< FUNC sub_FFF14AEF
FFF14AF2  3d0e00                            mov.w   #0, 20h+var_4[sp]
FFF14AF5  fb1278020200                      mov.l   #20278h, r1
FFF14AFB  b891                              movu.w  4[r1], r1
FFF14AFD  6131                              cmp     #3, r1
FFF14AFF  2011                              beq.b   loc_FFF14B10
FFF14B01  fb1278020200                      mov.l   #20278h, r1
FFF14B07  b891                              movu.w  4[r1], r1
FFF14B09  6111                              cmp     #1, r1
FFF14B0B  15                                beq.s   loc_FFF14B10
FFF14B0C  f80601                            mov.l   #1, 20h+var_20[sp]
FFF14B0F  0c                                bra.s   loc_FFF14B13
FFF14B10  f80600                 loc_FFF14B10 mov.l   #0, 20h+var_20[sp]
FFF14B13  ec01                   loc_FFF14B13 mov.l   20h+var_20[sp], r1
FFF14B15  6101                              cmp     #0, r1
FFF14B17  11                                beq.s   loc_FFF14B20
FFF14B18  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14B1D  38a300                            bra.w   loc_FFF14BC0
FFF14B20  390b07                 loc_FFF14B20 bsr.w   sub_FFF1522B
FFF14B23  39770c                            bsr.w   sub_FFF1579A
FFF14B26  fbe278020200                      mov.l   #20278h, r14
FFF14B2C  5dee8a                            movu.w  114h[r14], r14
FFF14B2F  612e                              cmp     #2, r14
FFF14B31  2035                              beq.b   loc_FFF14B66
FFF14B33  611e                              cmp     #1, r14
FFF14B35  2161                              bne.b   loc_FFF14B96
FFF14B37  3d0401                            mov.w   #1, 20h+var_18[sp]
FFF14B3A  fb1278020200                      mov.l   #20278h, r1
FFF14B40  6261                              add     #6, r1
FFF14B42  a089                              mov.l   r1, 20h+var_14[sp]
FFF14B44  fbe278020200                      mov.l   #20278h, r14
FFF14B4A  e5e04604                          mov.l   118h[r14], 20h+var_10[sp]
FFF14B4E  fb1278020200                      mov.l   #20278h, r1
FFF14B54  72112201                          add     #122h, r1, r1
FFF14B58  a109                              mov.l   r1, 20h+var_C[sp]
FFF14B5A  fbe278020200                      mov.l   #20278h, r14
FFF14B60  f9e59000                          mov.w   #0, 120h[r14]
FFF14B64  2e32                              bra.b   loc_FFF14B96
FFF14B66  3d0401                 loc_FFF14B66 mov.w   #1, 20h+var_18[sp]
FFF14B69  fb1278020200                      mov.l   #20278h, r1
FFF14B6F  6261                              add     #6, r1
FFF14B71  a089                              mov.l   r1, 20h+var_14[sp]
FFF14B73  fbe278020200                      mov.l   #20278h, r14
FFF14B79  e6e0496004                        mov.l   18124h[r14], 20h+var_10[sp]
FFF14B7E  fb1278020200                      mov.l   #20278h, r1
FFF14B84  73112e8101                        add     #1812Eh, r1, r1
FFF14B89  a109                              mov.l   r1, 20h+var_C[sp]
FFF14B8B  fbe278020200                      mov.l   #20278h, r14
FFF14B91  fae596c000                        mov.w   #0, 1812Ch[r14]
FFF14B96  7100ec                 loc_FFF14B96 add     #-14h, sp, sp
FFF14B99  754314                            mov.l   #14h, r3
FFF14B9C  71021c                            add     #34h+var_18, sp, r2
FFF14B9F  ef01                              mov.l   sp, r1
FFF14BA1  7f8f                              smovf
FFF14BA3  05d6f4ff                          bsr.a   sub_FFF14079
FFF14BA7  710014                            add     #14h, sp, sp
FFF14BAA  fb1278020200                      mov.l   #20278h, r1
FFF14BB0  3d1204                            mov.w   #4, 4[r1]
FFF14BB3  fbe278020200                      mov.l   #20278h, r14
FFF14BB9  f8e500                            mov.w   #0, [r14]
FFF14BBC  d5000e03                          mov.w   20h+var_4[sp], 20h+var_1A[sp]
FFF14BC0  d500030f               loc_FFF14BC0 mov.w   20h+var_1A[sp], 20h+var_2[sp]
FFF14BC4  bb89                              movu.w  20h+var_2[sp], r1
FFF14BC6  6708                              rtsd    #8
FFF14BC8  6080                   sub_FFF14BC8 sub     #8, sp   ; <<<< FUNC sub_FFF14BC8
FFF14BCA  3d0200                            mov.w   #0, 8+var_4[sp]
FFF14BCD  fb1278020200                      mov.l   #20278h, r1
FFF14BD3  b891                              movu.w  4[r1], r1
FFF14BD5  6131                              cmp     #3, r1
FFF14BD7  10                                beq.s   loc_FFF14BDF
FFF14BD8  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF14BDD  2e15                              bra.b   loc_FFF14BF2
FFF14BDF  394c06                 loc_FFF14BDF bsr.w   sub_FFF1522B
FFF14BE2  39b80b                            bsr.w   sub_FFF1579A
FFF14BE5  fb1278020200                      mov.l   #20278h, r1
FFF14BEB  3d1201                            mov.w   #1, 4[r1]
FFF14BEE  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]
FFF14BF2  d5000103               loc_FFF14BF2 mov.w   8+var_6[sp], 8+var_2[sp]
FFF14BF6  b889                              movu.w  8+var_2[sp], r1
FFF14BF8  6702                              rtsd    #2
FFF14BFA  7100e0                 sub_FFF14BFA add     #-20h, sp, sp   ; <<<< FUNC sub_FFF14BFA
FFF14BFD  a189                              mov.l   r1, 20h+var_4[sp]
FFF14BFF  a182                              mov.l   r2, 20h+var_8[sp]
FFF14C01  3d0a00                            mov.w   #0, 20h+var_C[sp]
FFF14C04  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF14C07  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF14C0A  fbe278020200                      mov.l   #20278h, r14
FFF14C10  5cee                              movu.w  [r14], r14
FFF14C12  611e                              cmp     #1, r14
FFF14C14  19                                bne.s   loc_FFF14C1D
FFF14C15  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C1A  381801                            bra.w   loc_FFF14D32
FFF14C1D  fb1278020200           loc_FFF14C1D mov.l   #20278h, r1
FFF14C23  b891                              movu.w  4[r1], r1
FFF14C25  6131                              cmp     #3, r1
FFF14C27  200d                              beq.b   loc_FFF14C34
FFF14C29  fb1278020200                      mov.l   #20278h, r1
FFF14C2F  b891                              movu.w  4[r1], r1
FFF14C31  6141                              cmp     #4, r1
FFF14C33  1d                                bne.s   loc_FFF14C38
FFF14C34  f80601                 loc_FFF14C34 mov.l   #1, 20h+var_20[sp]
FFF14C37  0c                                bra.s   loc_FFF14C3B
FFF14C38  f80600                 loc_FFF14C38 mov.l   #0, 20h+var_20[sp]
FFF14C3B  ec01                   loc_FFF14C3B mov.l   20h+var_20[sp], r1
FFF14C3D  6101                              cmp     #0, r1
FFF14C3F  11                                beq.s   loc_FFF14C48
FFF14C40  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C45  38ed00                            bra.w   loc_FFF14D32
FFF14C48  a989                   loc_FFF14C48 mov.l   20h+var_4[sp], r1
FFF14C4A  71020c                            add     #20h+var_14, sp, r2
FFF14C4D  05a6e4ff                          bsr.a   sub_FFF130F3
FFF14C51  9281                              mov.w   r1, 20h+var_C[sp]
FFF14C53  ba81                              movu.w  20h+var_C[sp], r1
FFF14C55  6101                              cmp     #0, r1
FFF14C57  11                                beq.s   loc_FFF14C60
FFF14C58  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C5D  38d500                            bra.w   loc_FFF14D32
FFF14C60  a989                   loc_FFF14C60 mov.l   20h+var_4[sp], r1
FFF14C62  fb22d5adf4ff                      mov.l   #aR_2, r2; "r+"
FFF14C68  05e01200                          bsr.a   sub_FFF15F48
FFF14C6C  a101                              mov.l   r1, 20h+var_10[sp]
FFF14C6E  a901                              mov.l   20h+var_10[sp], r1
FFF14C70  6101                              cmp     #0, r1
FFF14C72  210e                              bne.b   loc_FFF14C80
FFF14C74  05a62100                          bsr.a   sub_FFF16E1A
FFF14C78  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C7D  38b500                            bra.w   loc_FFF14D32
FFF14C80  a88a                   loc_FFF14C80 mov.l   20h+var_14[sp], r2
FFF14C82  6603                              mov.l   #0, r3
FFF14C84  05cb4600                          bsr.a   sub_FFF1934F
FFF14C88  a881                              mov.l   20h+var_18[sp], r1
FFF14C8A  7501ff                            cmp     #-1, r1
FFF14C8D  2110                              bne.b   loc_FFF14C9D
FFF14C8F  a901                              mov.l   20h+var_10[sp], r1
FFF14C91  05892100                          bsr.a   sub_FFF16E1A
FFF14C95  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C9A  389800                            bra.w   loc_FFF14D32
FFF14C9D  a98a                   loc_FFF14C9D mov.l   20h+var_4[sp], r2
FFF14C9F  fb1278020200                      mov.l   #20278h, r1
FFF14CA5  6261                              add     #6, r1
FFF14CA7  05a90803                          bsr.a   sub_FFF45550
FFF14CAB  fbe278020200                      mov.l   #20278h, r14
FFF14CB1  e50e0343                          mov.l   20h+var_14[sp], 10Ch[r14]
FFF14CB5  fbe278020200                      mov.l   #20278h, r14
FFF14CBB  e50e0342                          mov.l   20h+var_14[sp], 108h[r14]
FFF14CBF  fbe278020200                      mov.l   #20278h, r14
FFF14CC5  f8e502                            mov.w   #2, [r14]
FFF14CC8  fbe278020200                      mov.l   #20278h, r14
FFF14CCE  f9e58a01                          mov.w   #1, 114h[r14]
FFF14CD2  fbe278020200                      mov.l   #20278h, r14
FFF14CD8  f9e64600                          mov.l   #0, 118h[r14]
FFF14CDC  fbe278020200                      mov.l   #20278h, r14
FFF14CE2  f9e59003                          mov.w   #3, 120h[r14]
FFF14CE6  fbe278020200                      mov.l   #20278h, r14
FFF14CEC  fae596c003                        mov.w   #3, 1812Ch[r14]
FFF14CF1  fb1278020200                      mov.l   #20278h, r1
FFF14CF7  3d1203                            mov.w   #3, 4[r1]
FFF14CFA  fbe278020200                      mov.l   #20278h, r14
FFF14D00  e50e0343                          mov.l   20h+var_14[sp], 10Ch[r14]
FFF14D04  fbe278020200                      mov.l   #20278h, r14
FFF14D0A  e90e064cc0                        mov.l   20h+var_8[sp], 30130h[r14]
FFF14D0F  fbe278020200                      mov.l   #20278h, r14
FFF14D15  e90e044dc0                        mov.l   20h+var_10[sp], 30134h[r14]
FFF14D1A  fbe278020200                      mov.l   #20278h, r14
FFF14D20  73ee380103                        add     #30138h, r14, r14
FFF14D25  f8e500                            mov.w   #0, [r14]
FFF14D28  39f404                            bsr.w   sub_FFF1521C
FFF14D2B  393b0a                            bsr.w   sub_FFF15766
FFF14D2E  d5000a03                          mov.w   20h+var_C[sp], 20h+var_1A[sp]
FFF14D32  d500030b               loc_FFF14D32 mov.w   20h+var_1A[sp], 20h+var_A[sp]
FFF14D36  ba89                              movu.w  20h+var_A[sp], r1
FFF14D38  6708                              rtsd    #8
FFF14D3A  6080                   sub_FFF14D3A sub     #8, sp   ; <<<< FUNC sub_FFF14D3A
FFF14D3C  3d0200                            mov.w   #0, 8+var_4[sp]
FFF14D3F  fb1278020200                      mov.l   #20278h, r1
FFF14D45  b891                              movu.w  4[r1], r1
FFF14D47  6111                              cmp     #1, r1
FFF14D49  10                                beq.s   loc_FFF14D51
FFF14D4A  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF14D4F  2e15                              bra.b   loc_FFF14D64
FFF14D51  39cb04                 loc_FFF14D51 bsr.w   sub_FFF1521C
FFF14D54  39120a                            bsr.w   sub_FFF15766
FFF14D57  fb1278020200                      mov.l   #20278h, r1
FFF14D5D  3d1203                            mov.w   #3, 4[r1]
FFF14D60  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]
FFF14D64  d5000103               loc_FFF14D64 mov.w   8+var_6[sp], 8+var_2[sp]
FFF14D68  b889                              movu.w  8+var_2[sp], r1
FFF14D6A  6702                              rtsd    #2
FFF14D6C  60c0                   sub_FFF14D6C sub     #0Ch, sp   ; <<<< FUNC sub_FFF14D6C
FFF14D6E  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF14D70  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF14D73  fb1278020200                      mov.l   #20278h, r1
FFF14D79  b891                              movu.w  4[r1], r1
FFF14D7B  6151                              cmp     #5, r1
FFF14D7D  18                                bne.s   loc_FFF14D85
FFF14D7E  f90901ffff                        mov.w   #-1, 0Ch+var_A[sp]
FFF14D83  2e45                              bra.b   loc_FFF14DC8
FFF14D85  fbe278020200           loc_FFF14D85 mov.l   #20278h, r14
FFF14D8B  a881                              mov.l   0Ch+var_4[sp], r1
FFF14D8D  d1e102                            mov.w   4[r14], [r1]
FFF14D90  fbe278020200                      mov.l   #20278h, r14
FFF14D96  a881                              mov.l   0Ch+var_4[sp], r1
FFF14D98  e5e14241                          mov.l   108h[r14], 104h[r1]
FFF14D9C  fbe278020200                      mov.l   #20278h, r14
FFF14DA2  a881                              mov.l   0Ch+var_4[sp], r1
FFF14DA4  e5e14342                          mov.l   10Ch[r14], 108h[r1]
FFF14DA8  fbe278020200                      mov.l   #20278h, r14
FFF14DAE  a881                              mov.l   0Ch+var_4[sp], r1
FFF14DB0  d5e18886                          mov.w   110h[r14], 10Ch[r1]
FFF14DB4  a881                              mov.l   0Ch+var_4[sp], r1
FFF14DB6  fb2278020200                      mov.l   #20278h, r2
FFF14DBC  6262                              add     #6, r2
FFF14DBE  6221                              add     #2, r1
FFF14DC0  05900703                          bsr.a   sub_FFF45550
FFF14DC4  d5000201                          mov.w   0Ch+var_8[sp], 0Ch+var_A[sp]
FFF14DC8  d5000103               loc_FFF14DC8 mov.w   0Ch+var_A[sp], 0Ch+var_6[sp]
FFF14DCC  b889                              movu.w  0Ch+var_6[sp], r1
FFF14DCE  6703                              rtsd    #3
FFF14DD0  6080                   sub_FFF14DD0 sub     #8, sp   ; <<<< FUNC sub_FFF14DD0
FFF14DD2  3d0200                            mov.w   #0, 8+var_4[sp]
FFF14DD5  fbe298220100                      mov.l   #12298h, r14
FFF14DDB  58ee                              movu.b  [r14], r14
FFF14DDD  611e                              cmp     #1, r14
FFF14DDF  1e                                bne.s   loc_FFF14DE5
FFF14DE0  3d0100                            mov.w   #0, 8+var_6[sp]
FFF14DE3  2e34                              bra.b   loc_FFF14E17
FFF14DE5  fbe2b8930600           loc_FFF14DE5 mov.l   #693B8h, r14
FFF14DEB  f8e503                            mov.w   #3, [r14]
FFF14DEE  fbe2b8930600                      mov.l   #693B8h, r14
FFF14DF4  f9e64100                          mov.l   #0, 104h[r14]
FFF14DF8  fbe295220100                      mov.l   #12295h, r14
FFF14DFE  f8e400                            mov.b   #0, [r14]
FFF14E01  fbe296220100                      mov.l   #12296h, r14
FFF14E07  f8e400                            mov.b   #0, [r14]
FFF14E0A  fbe298220100                      mov.l   #12298h, r14
FFF14E10  f8e401                            mov.b   #1, [r14]
FFF14E13  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]
FFF14E17  d5000103               loc_FFF14E17 mov.w   8+var_6[sp], 8+var_2[sp]
FFF14E1B  b889                              movu.w  8+var_2[sp], r1
FFF14E1D  6702                              rtsd    #2
FFF14E1F  7100e0                 sub_FFF14E1F add     #-20h, sp, sp   ; <<<< FUNC sub_FFF14E1F
FFF14E22  a189                              mov.l   r1, 20h+var_4[sp]
FFF14E24  868a                              mov.b   r2, 20h+var_5[sp]
FFF14E26  a10b                              mov.l   r3, 20h+var_C[sp]
FFF14E28  3d0800                            mov.w   #0, 20h+var_10[sp]
FFF14E2B  3d0700                            mov.w   #0, 20h+var_12[sp]
FFF14E2E  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF14E31  fbe2b8930600                      mov.l   #693B8h, r14
FFF14E37  5cee                              movu.w  [r14], r14
FFF14E39  612e                              cmp     #2, r14
FFF14E3B  19                                bne.s   loc_FFF14E44
FFF14E3C  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF14E41  38b300                            bra.w   loc_FFF14EF4
FFF14E44  a98a                   loc_FFF14E44 mov.l   20h+var_4[sp], r2
FFF14E46  fb12b8930600                      mov.l   #693B8h, r1
FFF14E4C  6221                              add     #2, r1
FFF14E4E  05020703                          bsr.a   sub_FFF45550
FFF14E52  fb12b8930600                      mov.l   #693B8h, r1
FFF14E58  6221                              add     #2, r1
FFF14E5A  710208                            add     #20h+var_18, sp, r2
FFF14E5D  0596e2ff                          bsr.a   sub_FFF130F3
FFF14E61  9189                              mov.w   r1, 20h+var_12[sp]
FFF14E63  b989                              movu.w  20h+var_12[sp], r1
FFF14E65  6101                              cmp     #0, r1
FFF14E67  14                                beq.s   loc_FFF14E6B
FFF14E68  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF14E6B  fbe2b8930600           loc_FFF14E6B mov.l   #693B8h, r14
FFF14E71  e50e0241                          mov.l   20h+var_18[sp], 104h[r14]
FFF14E75  b689                              movu.b  20h+var_5[sp], r1
FFF14E77  6111                              cmp     #1, r1
FFF14E79  2027                              beq.b   loc_FFF14EA0
FFF14E7B  6101                              cmp     #0, r1
FFF14E7D  2144                              bne.b   loc_FFF14EC1
FFF14E7F  a989                              mov.l   20h+var_4[sp], r1
FFF14E81  fb22d3adf4ff                      mov.l   #aW_0, r2; "w"
FFF14E87  05c11000                          bsr.a   sub_FFF15F48
FFF14E8B  a009                              mov.l   r1, 20h+var_1C[sp]
FFF14E8D  a809                              mov.l   20h+var_1C[sp], r1
FFF14E8F  6101                              cmp     #0, r1
FFF14E91  2130                              bne.b   loc_FFF14EC1
FFF14E93  a809                              mov.l   20h+var_1C[sp], r1
FFF14E95  05851f00                          bsr.a   sub_FFF16E1A
FFF14E99  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF14E9E  2e56                              bra.b   loc_FFF14EF4
FFF14EA0  a989                   loc_FFF14EA0 mov.l   20h+var_4[sp], r1
FFF14EA2  fb22d8adf4ff                      mov.l   #aA, r2; "a"
FFF14EA8  05a01000                          bsr.a   sub_FFF15F48
FFF14EAC  a009                              mov.l   r1, 20h+var_1C[sp]
FFF14EAE  a809                              mov.l   20h+var_1C[sp], r1
FFF14EB0  6101                              cmp     #0, r1
FFF14EB2  210f                              bne.b   loc_FFF14EC1
FFF14EB4  a809                              mov.l   20h+var_1C[sp], r1
FFF14EB6  05641f00                          bsr.a   sub_FFF16E1A
FFF14EBA  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF14EBF  2e35                              bra.b   loc_FFF14EF4
FFF14EC1  fbe2b8930600           loc_FFF14EC1 mov.l   #693B8h, r14
FFF14EC7  f8e502                            mov.w   #2, [r14]
FFF14ECA  fbe2b8930600                      mov.l   #693B8h, r14
FFF14ED0  e50e0544                          mov.l   20h+var_C[sp], 110h[r14]
FFF14ED4  fbe2b8930600                      mov.l   #693B8h, r14
FFF14EDA  e50e0145                          mov.l   20h+var_1C[sp], 114h[r14]
FFF14EDE  fbe295220100                      mov.l   #12295h, r14
FFF14EE4  f8e400                            mov.b   #0, [r14]
FFF14EE7  fbe296220100                      mov.l   #12296h, r14
FFF14EED  f8e400                            mov.b   #0, [r14]
FFF14EF0  d5000801                          mov.w   20h+var_10[sp], 20h+var_1E[sp]
FFF14EF4  d5000109               loc_FFF14EF4 mov.w   20h+var_1E[sp], 20h+var_E[sp]
FFF14EF8  ba09                              movu.w  20h+var_E[sp], r1
FFF14EFA  6708                              rtsd    #8
FFF14EFC  6080                   sub_FFF14EFC sub     #8, sp   ; <<<< FUNC sub_FFF14EFC
FFF14EFE  3d0200                            mov.w   #0, 8+var_4[sp]
FFF14F01  fbe2b8930600                      mov.l   #693B8h, r14
FFF14F07  5cee                              movu.w  [r14], r14
FFF14F09  610e                              cmp     #0, r14
FFF14F0B  18                                bne.s   loc_FFF14F13
FFF14F0C  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF14F11  2e45                              bra.b   loc_FFF14F56
FFF14F13  fbe2b8930600           loc_FFF14F13 mov.l   #693B8h, r14
FFF14F19  f8e500                            mov.w   #0, [r14]
FFF14F1C  fbe2b8930600                      mov.l   #693B8h, r14
FFF14F22  f9e64100                          mov.l   #0, 104h[r14]
FFF14F26  fbe295220100                      mov.l   #12295h, r14
FFF14F2C  f8e400                            mov.b   #0, [r14]
FFF14F2F  fbe296220100                      mov.l   #12296h, r14
FFF14F35  f8e400                            mov.b   #0, [r14]
FFF14F38  fbe2b8930600                      mov.l   #693B8h, r14
FFF14F3E  edee45                            mov.l   114h[r14], r14
FFF14F41  610e                              cmp     #0, r14
FFF14F43  200f                              beq.b   loc_FFF14F52
FFF14F45  fbe2b8930600                      mov.l   #693B8h, r14
FFF14F4B  ede145                            mov.l   114h[r14], r1
FFF14F4E  05cc1e00                          bsr.a   sub_FFF16E1A
FFF14F52  d5000201               loc_FFF14F52 mov.w   8+var_4[sp], 8+var_6[sp]
FFF14F56  d5000103               loc_FFF14F56 mov.w   8+var_6[sp], 8+var_2[sp]
FFF14F5A  b889                              movu.w  8+var_2[sp], r1
FFF14F5C  6702                              rtsd    #2
FFF14F5E  6080                   sub_FFF14F5E sub     #8, sp   ; <<<< FUNC sub_FFF14F5E
FFF14F60  3d0200                            mov.w   #0, 8+var_4[sp]
FFF14F63  fbe2b8930600                      mov.l   #693B8h, r14
FFF14F69  5cee                              movu.w  [r14], r14
FFF14F6B  612e                              cmp     #2, r14
FFF14F6D  10                                beq.s   loc_FFF14F75
FFF14F6E  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF14F73  2e0f                              bra.b   loc_FFF14F82
FFF14F75  fbe2b8930600           loc_FFF14F75 mov.l   #693B8h, r14
FFF14F7B  f8e501                            mov.w   #1, [r14]
FFF14F7E  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]

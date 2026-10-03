; ==== gps_a  FFF0C900-FFF10000  (file 30C900-310000) ====
FFF0C900  8281                              mov.b   r1, 28h+var_1E[sp]
FFF0C902  b281                   loc_FFF0C902 movu.b  28h+var_1E[sp], r1
FFF0C904  6121                              cmp     #2, r1
FFF0C906  2805                              bge.b   loc_FFF0C90B
FFF0C908  381aff                            bra.w   loc_FFF0C822
FFF0C90B  66fe                   loc_FFF0C90B mov.l   #0Fh, r14
FFF0C90D  fc310e1f                          tst     28h+var_9[sp], r14
FFF0C911  2132                              bne.b   loc_FFF0C943
FFF0C913  ba02                              movu.w  28h+var_18[sp], r2
FFF0C915  ba09                              movu.w  28h+var_16[sp], r1
FFF0C917  62d2                              add     #0Dh, r2
FFF0C919  5f22                              movu.w  r2, r2
FFF0C91B  fb426cfdecff                      mov.l   #unk_FFECFD6C, r4
FFF0C921  6613                              mov.l   #1, r3
FFF0C923  05b29ffe                          bsr.a   sub_FFEF68D5
FFF0C927  ba09                              movu.w  28h+var_16[sp], r1
FFF0C929  06c90104                          add     28h+var_20[sp].uw, r1
FFF0C92D  ba02                              movu.w  28h+var_18[sp], r2
FFF0C92F  62d2                              add     #0Dh, r2
FFF0C931  5f22                              movu.w  r2, r2
FFF0C933  5f11                              movu.w  r1, r1
FFF0C935  fb427cfdecff                      mov.l   #unk_FFECFD7C, r4
FFF0C93B  6613                              mov.l   #1, r3
FFF0C93D  05989ffe                          bsr.a   sub_FFEF68D5
FFF0C941  670a                              rtsd    #0Ah
FFF0C943  ba01                   loc_FFF0C943 movu.w  28h+var_18[sp], r1
FFF0C945  62d1                              add     #0Dh, r1
FFF0C947  b78a                              movu.b  28h+var_9[sp], r2
FFF0C949  64f2                              and     #0Fh, r2
FFF0C94B  6122                              cmp     #2, r2
FFF0C94D  9a0b                              mov.w   28h+var_16[sp], r3
FFF0C94F  212c                              bne.b   loc_FFF0C97B
FFF0C951  5f12                              movu.w  r1, r2
FFF0C953  5f31                              movu.w  r3, r1
FFF0C955  fb326cfdecff                      mov.l   #unk_FFECFD6C, r3
FFF0C95B  05c448fe                          bsr.a   sub_FFEF121F
FFF0C95F  ba09                              movu.w  28h+var_16[sp], r1
FFF0C961  06c90104                          add     28h+var_20[sp].uw, r1
FFF0C965  ba03                              movu.w  28h+var_18[sp], r3
FFF0C967  62d3                              add     #0Dh, r3
FFF0C969  5f32                              movu.w  r3, r2
FFF0C96B  5f11                              movu.w  r1, r1
FFF0C96D  fb427cfdecff                      mov.l   #unk_FFECFD7C, r4
FFF0C973  6613                              mov.l   #1, r3
FFF0C975  05609ffe                          bsr.a   sub_FFEF68D5
FFF0C979  670a                              rtsd    #0Ah
FFF0C97B  5f12                   loc_FFF0C97B movu.w  r1, r2
FFF0C97D  5f31                              movu.w  r3, r1
FFF0C97F  fb426cfdecff                      mov.l   #unk_FFECFD6C, r4
FFF0C985  6613                              mov.l   #1, r3
FFF0C987  054e9ffe                          bsr.a   sub_FFEF68D5
FFF0C98B  ba09                              movu.w  28h+var_16[sp], r1
FFF0C98D  06c90104                          add     28h+var_20[sp].uw, r1
FFF0C991  ba02                              movu.w  28h+var_18[sp], r2
FFF0C993  62d2                              add     #0Dh, r2
FFF0C995  5f22                              movu.w  r2, r2
FFF0C997  5f11                              movu.w  r1, r1
FFF0C999  fb327cfdecff                      mov.l   #unk_FFECFD7C, r3
FFF0C99F  058048fe                          bsr.a   sub_FFEF121F
FFF0C9A3  670a                              rtsd    #0Ah
FFF0C9A5  7100e0                 sub_FFF0C9A5 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF0C9A5
FFF0C9A8  fbe2c8d30100                      mov.l   #1D3C8h, r14
FFF0C9AE  ece2                              mov.l   [r14], r2
FFF0C9B0  754310                            mov.l   #10h, r3
FFF0C9B3  710110                            add     #20h+var_10, sp, r1
FFF0C9B6  7f8f                              smovf
FFF0C9B8  754310                            mov.l   #10h, r3
FFF0C9BB  710210                            add     #20h+var_10, sp, r2
FFF0C9BE  ef01                              mov.l   sp, r1
FFF0C9C0  7f8f                              smovf
FFF0C9C2  f9020300580207                    mov.l   #7025800h, 20h+var_14[sp]
FFF0C9C9  6040                              sub     #4, sp
FFF0C9CB  710e16                            add     #24h+var_E, sp, r14
FFF0C9CE  e30e                              mov.l   r14, 24h+var_24[sp]
FFF0C9D0  710414                            add     #24h+var_10, sp, r4
FFF0C9D3  66e3                              mov.l   #0Eh, r3
FFF0C9D5  710206                            add     #24h+var_1E, sp, r2
FFF0C9D8  710104                            add     #24h+var_20, sp, r1
FFF0C9DB  05604bfe                          bsr.a   sub_FFEF153B
FFF0C9DF  6240                              add     #4, sp
FFF0C9E1  6708                              rtsd    #8
FFF0C9E3  fbe2c8d30100           sub_FFF0C9E3 mov.l   #1D3C8h, r14   ; <<<< FUNC sub_FFF0C9E3
FFF0C9E9  ece1                              mov.l   [r14], r1
FFF0C9EB  a89a                              mov.l   0Ch[r1], r2
FFF0C9ED  fb3e009600                        mov.l   #9600h, r3
FFF0C9F2  fb1200580207                      mov.l   #7025800h, r1
FFF0C9F8  0570e8fe                          bsr.a   sub_FFEFB268
FFF0C9FC  02                                rts
FFF0C9FD  fbe24c8c0000           sub_FFF0C9FD mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF0C9FD
FFF0CA03  58ee                              movu.b  [r14], r14
FFF0CA05  613e                              cmp     #3, r14
FFF0CA07  2a16                              bgt.b   loc_FFF0CA1D
FFF0CA09  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0CA0F  58ee                              movu.b  [r14], r14
FFF0CA11  fbf2dc76edff                      mov.l   #off_FFED76DC, r15
FFF0CA17  fe6efe                            mov.l   [r14, r15], r14
FFF0CA1A  7f1e                              jsr     r14
FFF0CA1C  02                                rts
FFF0CA1D  fbe24c8c0000           loc_FFF0CA1D mov.l   #8C4Ch, r14
FFF0CA23  f8e403                            mov.b   #3, [r14]
FFF0CA26  02                                rts
FFF0CA27  6611                   sub_FFF0CA27 mov.l   #1, r1   ; <<<< FUNC sub_FFF0CA27
FFF0CA29  398b01                            bsr.w   sub_FFF0CBB4
FFF0CA2C  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0CA32  58ef                              movu.b  [r14], r15
FFF0CA34  621f                              add     #1, r15
FFF0CA36  c3ef                              mov.b   r15, [r14]
FFF0CA38  02                                rts
FFF0CA39  05f438fe               sub_FFF0CA39 bsr.a   sub_FFEF032D   ; <<<< FUNC sub_FFF0CA39
FFF0CA3D  050addfe                          bsr.a   sub_FFEFA747
FFF0CA41  6621                              mov.l   #2, r1
FFF0CA43  054cd4fe                          bsr.a   sub_FFEF9E8F
FFF0CA47  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0CA4D  58ef                              movu.b  [r14], r15
FFF0CA4F  621f                              add     #1, r15
FFF0CA51  c3ef                              mov.b   r15, [r14]
FFF0CA53  02                                rts
FFF0CA54  6040                   sub_FFF0CA54 sub     #4, sp   ; <<<< FUNC sub_FFF0CA54
FFF0CA56  6040                              sub     #4, sp
FFF0CA58  3d00f0                            mov.w   #-10h, [sp]
FFF0CA5B  fb4a4001                          mov.l   #140h, r4
FFF0CA5F  6602                              mov.l   #0, r2
FFF0CA61  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0CA67  ef23                              mov.l   r2, r3
FFF0CA69  05522ffe                          bsr.a   sub_FFEEF9BB
FFF0CA6D  6240                              add     #4, sp
FFF0CA6F  8089                              mov.b   r1, 4+var_1[sp]
FFF0CA71  b089                              movu.b  4+var_1[sp], r1
FFF0CA73  6111                              cmp     #1, r1
FFF0CA75  1a                                bne.s   loc_FFF0CA7F
FFF0CA76  39a002                            bsr.w   sub_FFF0CD16
FFF0CA79  05f638fe                          bsr.a   sub_FFEF036F
FFF0CA7D  6701                              rtsd    #1
FFF0CA7F  6701                   loc_FFF0CA7F rtsd    #1
FFF0CA81  6040                   sub_FFF0CA81 sub     #4, sp   ; <<<< FUNC sub_FFF0CA81
FFF0CA83  6040                              sub     #4, sp
FFF0CA85  f80520                            mov.w   #20h, 8+var_8[sp] ; ' '
FFF0CA88  fb4a4001                          mov.l   #140h, r4
FFF0CA8C  6602                              mov.l   #0, r2
FFF0CA8E  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0CA94  ef23                              mov.l   r2, r3
FFF0CA96  05252ffe                          bsr.a   sub_FFEEF9BB
FFF0CA9A  6240                              add     #4, sp
FFF0CA9C  8089                              mov.b   r1, 4+var_1[sp]
FFF0CA9E  b089                              movu.b  4+var_1[sp], r1
FFF0CAA0  6111                              cmp     #1, r1
FFF0CAA2  210f                              bne.b   loc_FFF0CAB1
FFF0CAA4  6601                              mov.l   #0, r1
FFF0CAA6  ef12                              mov.l   r1, r2
FFF0CAA8  398a02                            bsr.w   sub_FFF0CD32
FFF0CAAB  05c438fe                          bsr.a   sub_FFEF036F
FFF0CAAF  6701                              rtsd    #1
FFF0CAB1  6701                   loc_FFF0CAB1 rtsd    #1
FFF0CAB3  6040                   sub_FFF0CAB3 sub     #4, sp   ; <<<< FUNC sub_FFF0CAB3
FFF0CAB5  6040                              sub     #4, sp
FFF0CAB7  3d00d0                            mov.w   #-30h, [sp]
FFF0CABA  fb4a4001                          mov.l   #140h, r4
FFF0CABE  754320                            mov.l   #20h, r3 ; ' '
FFF0CAC1  6602                              mov.l   #0, r2
FFF0CAC3  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0CAC9  05f22efe                          bsr.a   sub_FFEEF9BB
FFF0CACD  6240                              add     #4, sp
FFF0CACF  8089                              mov.b   r1, 4+var_1[sp]
FFF0CAD1  b089                              movu.b  4+var_1[sp], r1
FFF0CAD3  6111                              cmp     #1, r1
FFF0CAD5  210f                              bne.b   loc_FFF0CAE4
FFF0CAD7  6601                              mov.l   #0, r1
FFF0CAD9  ef12                              mov.l   r1, r2
FFF0CADB  395702                            bsr.w   sub_FFF0CD32
FFF0CADE  059138fe                          bsr.a   sub_FFEF036F
FFF0CAE2  6701                              rtsd    #1
FFF0CAE4  6701                   loc_FFF0CAE4 rtsd    #1
FFF0CAE6  6040                   sub_FFF0CAE6 sub     #4, sp   ; <<<< FUNC sub_FFF0CAE6
FFF0CAE8  fbe2738f0000                      mov.l   #8F73h, r14
FFF0CAEE  58e1                              movu.b  [r14], r1
FFF0CAF0  7111e0                            add     #-20h, r1, r1
FFF0CAF3  8081                              mov.b   r1, 4+var_2[sp]
FFF0CAF5  b081                              movu.b  4+var_2[sp], r1
FFF0CAF7  6c31                              shll    #3, r1
FFF0CAF9  fb52805eecff                      mov.l   #unk_FFEC5E80, r5
FFF0CAFF  4b15                              add     r1, r5
FFF0CB01  b8d4                              movu.w  4[r5], r4
FFF0CB03  b85b                              movu.w  2[r5], r3
FFF0CB05  5c52                              movu.w  [r5], r2
FFF0CB07  6040                              sub     #4, sp
FFF0CB09  d15003                            mov.w   6[r5], 8+var_8[sp]
FFF0CB0C  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0CB12  05a92efe                          bsr.a   sub_FFEEF9BB
FFF0CB16  6240                              add     #4, sp
FFF0CB18  8089                              mov.b   r1, 4+var_1[sp]
FFF0CB1A  b089                              movu.b  4+var_1[sp], r1
FFF0CB1C  6111                              cmp     #1, r1
FFF0CB1E  210e                              bne.b   loc_FFF0CB2C
FFF0CB20  b081                              movu.b  4+var_2[sp], r1
FFF0CB22  05e359fe                          bsr.a   sub_FFEF2505
FFF0CB26  054938fe                          bsr.a   sub_FFEF036F
FFF0CB2A  6701                              rtsd    #1
FFF0CB2C  6701                   loc_FFF0CB2C rtsd    #1
FFF0CB2E  6040                   sub_FFF0CB2E sub     #4, sp   ; <<<< FUNC sub_FFF0CB2E
FFF0CB30  050f35fe                          bsr.a   sub_FFEF003F
FFF0CB34  fbe2738f0000                      mov.l   #8F73h, r14
FFF0CB3A  c3e1                              mov.b   r1, [r14]
FFF0CB3C  fbe2738f0000                      mov.l   #8F73h, r14
FFF0CB42  58ee                              movu.b  [r14], r14
FFF0CB44  755eff                            cmp     #-1, r14
FFF0CB47  1e                                bne.s   loc_FFF0CB4D
FFF0CB48  6601                              mov.l   #0, r1
FFF0CB4A  396a00                            bsr.w   sub_FFF0CBB4
FFF0CB4D  fbe2738f0000           loc_FFF0CB4D mov.l   #8F73h, r14
FFF0CB53  58ee                              movu.b  [r14], r14
FFF0CB55  755eff                            cmp     #-1, r14
FFF0CB58  2013                              beq.b   loc_FFF0CB6B
FFF0CB5A  fbe2738f0000                      mov.l   #8F73h, r14
FFF0CB60  58ee                              movu.b  [r14], r14
FFF0CB62  755e35                            cmp     #35h, r14 ; '5'
FFF0CB65  2406                              bgtu.b  loc_FFF0CB6B
FFF0CB67  f80601                            mov.l   #1, 4+var_4[sp]
FFF0CB6A  0c                                bra.s   loc_FFF0CB6E
FFF0CB6B  f80600                 loc_FFF0CB6B mov.l   #0, 4+var_4[sp]
FFF0CB6E  ec01                   loc_FFF0CB6E mov.l   4+var_4[sp], r1
FFF0CB70  6101                              cmp     #0, r1
FFF0CB72  2029                              beq.b   loc_FFF0CB9B
FFF0CB74  051030fe                          bsr.a   sub_FFEEFB84
FFF0CB78  6101                              cmp     #0, r1
FFF0CB7A  2121                              bne.b   loc_FFF0CB9B
FFF0CB7C  fbe2738f0000                      mov.l   #8F73h, r14
FFF0CB82  58e1                              movu.b  [r14], r1
FFF0CB84  056634fe                          bsr.a   sub_FFEEFFEA
FFF0CB88  fbe2738f0000                      mov.l   #8F73h, r14
FFF0CB8E  58ee                              movu.b  [r14], r14
FFF0CB90  fbf2ec76edff                      mov.l   #off_FFED76EC, r15
FFF0CB96  fe6efe                            mov.l   [r14, r15], r14
FFF0CB99  7f1e                              jsr     r14
FFF0CB9B  fbe24c8c0000           loc_FFF0CB9B mov.l   #8C4Ch, r14
FFF0CBA1  58ee                              movu.b  [r14], r14
FFF0CBA3  614e                              cmp     #4, r14
FFF0CBA5  290d                              blt.b   loc_FFF0CBB2
FFF0CBA7  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0CBAD  f8e403                            mov.b   #3, [r14]
FFF0CBB0  6701                              rtsd    #1
FFF0CBB2  6701                   loc_FFF0CBB2 rtsd    #1
FFF0CBB4  6040                   sub_FFF0CBB4 sub     #4, sp   ; <<<< FUNC sub_FFF0CBB4
FFF0CBB6  8089                              mov.b   r1, 4+var_1[sp]
FFF0CBB8  05b174fe                          bsr.a   sub_FFEF4069
FFF0CBBC  391400                            bsr.w   sub_FFF0CBD0
FFF0CBBF  05fb74fe                          bsr.a   sub_FFEF40BA
FFF0CBC3  b089                              movu.b  4+var_1[sp], r1
FFF0CBC5  6111                              cmp     #1, r1
FFF0CBC7  1f                                bne.s   loc_FFF0CBCE
FFF0CBC8  056434fe                          bsr.a   sub_FFEF002C
FFF0CBCC  6701                              rtsd    #1
FFF0CBCE  6701                   loc_FFF0CBCE rtsd    #1
FFF0CBD0  6040                   sub_FFF0CBD0 sub     #4, sp   ; <<<< FUNC sub_FFF0CBD0
FFF0CBD2  fbe2748f0000                      mov.l   #8F74h, r14
FFF0CBD8  58ee                              movu.b  [r14], r14
FFF0CBDA  610e                              cmp     #0, r14
FFF0CBDC  2116                              bne.b   loc_FFF0CBF2
FFF0CBDE  6602                              mov.l   #0, r2
FFF0CBE0  fb1e000020                        mov.l   #200000h, r1
FFF0CBE5  057e35fe                          bsr.a   sub_FFEF0163
FFF0CBE9  fbe2748f0000                      mov.l   #8F74h, r14
FFF0CBEF  f8e401                            mov.b   #1, [r14]
FFF0CBF2  fbe24d8c0000           loc_FFF0CBF2 mov.l   #8C4Dh, r14
FFF0CBF8  59ee20                            movu.b  20h[r14], r14
FFF0CBFB  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CC01  45fe20                            cmp     20h[r15], r14
FFF0CC04  201b                              beq.b   loc_FFF0CC1F
FFF0CC06  fb1e000020                        mov.l   #200000h, r1
FFF0CC0B  05e332fe                          bsr.a   sub_FFEEFEEE
FFF0CC0F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CC15  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CC1B  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0CC1F  3c0300                 loc_FFF0CC1F mov.b   #0, 4+var_1[sp]
FFF0CC22  2e41                              bra.b   loc_FFF0CC63
FFF0CC24  b089                   loc_FFF0CC24 movu.b  4+var_1[sp], r1
FFF0CC26  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CC2C  4b1e                              add     r1, r14
FFF0CC2E  59ee21                            movu.b  21h[r14], r14
FFF0CC31  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CC37  4b1f                              add     r1, r15
FFF0CC39  45fe21                            cmp     21h[r15], r14
FFF0CC3C  2021                              beq.b   loc_FFF0CC5D
FFF0CC3E  fb1e000020                        mov.l   #200000h, r1
FFF0CC43  05ab32fe                          bsr.a   sub_FFEEFEEE
FFF0CC47  b089                              movu.b  4+var_1[sp], r1
FFF0CC49  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CC4F  4b1e                              add     r1, r14
FFF0CC51  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CC57  4b1f                              add     r1, r15
FFF0CC59  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF0CC5D  b089                   loc_FFF0CC5D movu.b  4+var_1[sp], r1
FFF0CC5F  6211                              add     #1, r1
FFF0CC61  8089                              mov.b   r1, 4+var_1[sp]
FFF0CC63  b089                   loc_FFF0CC63 movu.b  4+var_1[sp], r1
FFF0CC65  61a1                              cmp     #0Ah, r1
FFF0CC67  29bd                              blt.b   loc_FFF0CC24
FFF0CC69  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0CC6C  2e7a                              bra.b   loc_FFF0CCE6
FFF0CC6E  b089                   loc_FFF0CC6E movu.b  4+var_1[sp], r1
FFF0CC70  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CC76  4b1e                              add     r1, r14
FFF0CC78  59ee2b                            movu.b  2Bh[r14], r14
FFF0CC7B  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CC81  4b1f                              add     r1, r15
FFF0CC83  45fe2b                            cmp     2Bh[r15], r14
FFF0CC86  2021                              beq.b   loc_FFF0CCA7
FFF0CC88  fb1e000010                        mov.l   #100000h, r1
FFF0CC8D  056132fe                          bsr.a   sub_FFEEFEEE
FFF0CC91  b089                              movu.b  4+var_1[sp], r1
FFF0CC93  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CC99  4b1e                              add     r1, r14
FFF0CC9B  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CCA1  4b1f                              add     r1, r15
FFF0CCA3  c5fe2b2b                          mov.b   2Bh[r15], 2Bh[r14]
FFF0CCA7  b089                   loc_FFF0CCA7 movu.b  4+var_1[sp], r1
FFF0CCA9  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CCAF  4b1e                              add     r1, r14
FFF0CCB1  59ee3f                            movu.b  3Fh[r14], r14
FFF0CCB4  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CCBA  4b1f                              add     r1, r15
FFF0CCBC  45fe3f                            cmp     3Fh[r15], r14
FFF0CCBF  2021                              beq.b   loc_FFF0CCE0
FFF0CCC1  fb1e000010                        mov.l   #100000h, r1
FFF0CCC6  052832fe                          bsr.a   sub_FFEEFEEE
FFF0CCCA  b089                              movu.b  4+var_1[sp], r1
FFF0CCCC  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CCD2  4b1e                              add     r1, r14
FFF0CCD4  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CCDA  4b1f                              add     r1, r15
FFF0CCDC  c5fe3f3f                          mov.b   3Fh[r15], 3Fh[r14]
FFF0CCE0  b089                   loc_FFF0CCE0 movu.b  4+var_1[sp], r1
FFF0CCE2  6211                              add     #1, r1
FFF0CCE4  8089                              mov.b   r1, 4+var_1[sp]
FFF0CCE6  b089                   loc_FFF0CCE6 movu.b  4+var_1[sp], r1
FFF0CCE8  755114                            cmp     #14h, r1
FFF0CCEB  2983                              blt.b   loc_FFF0CC6E
FFF0CCED  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0CCF3  b219                              movu.b  9[r1], r1
FFF0CCF5  fbe2468e0000                      mov.l   #8E46h, r14
FFF0CCFB  45e109                            cmp     9[r14], r1
FFF0CCFE  2012                              beq.b   loc_FFF0CD10
FFF0CD00  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CD06  fbf2468e0000                      mov.l   #8E46h, r15
FFF0CD0C  c5fe0909                          mov.b   9[r15], 9[r14]
FFF0CD10  058435fe               loc_FFF0CD10 bsr.a   sub_FFEF0294
FFF0CD14  6701                              rtsd    #1
FFF0CD16  fbe2798d0000           sub_FFF0CD16 mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF0CD16
FFF0CD1C  f8e400                            mov.b   #0, [r14]
FFF0CD1F  6601                              mov.l   #0, r1
FFF0CD21  ef12                              mov.l   r1, r2
FFF0CD23  05e536fe                          bsr.a   sub_FFEF0408
FFF0CD27  6601                              mov.l   #0, r1
FFF0CD29  ef12                              mov.l   r1, r2
FFF0CD2B  390700                            bsr.w   sub_FFF0CD32
FFF0CD2E  39b200                            bsr.w   sub_FFF0CDE0
FFF0CD31  02                                rts
FFF0CD32  60c0                   sub_FFF0CD32 sub     #0Ch, sp   ; <<<< FUNC sub_FFF0CD32
FFF0CD34  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0CD36  9102                              mov.w   r2, 0Ch+var_4[sp]
FFF0CD38  3c0300                            mov.b   #0, 0Ch+var_9[sp]
FFF0CD3B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CD41  c1e020                            mov.b   20h[r14], 0Ch+var_C[sp]
FFF0CD44  754420                            mov.l   #20h, r4 ; ' '
FFF0CD47  fb3a4001                          mov.l   #140h, r3
FFF0CD4B  6601                              mov.l   #0, r1
FFF0CD4D  ef12                              mov.l   r1, r2
FFF0CD4F  05a837fe                          bsr.a   sub_FFEF04F7
FFF0CD53  3d035a                            mov.w   #5Ah, 0Ch+var_6[sp] ; 'Z'
FFF0CD56  3d0203                            mov.w   #3, 0Ch+var_8[sp]
FFF0CD59  059935fe                          bsr.a   sub_FFEF02F2
FFF0CD5D  8089                              mov.b   r1, 0Ch+var_9[sp]
FFF0CD5F  3c0200                            mov.b   #0, 0Ch+var_A[sp]
FFF0CD62  2e76                              bra.b   loc_FFF0CDD8
FFF0CD64  fbe24d8c0000           loc_FFF0CD64 mov.l   #8C4Dh, r14
FFF0CD6A  490e02                            add     0Ch+var_A[sp], r14
FFF0CD6D  c5e02101                          mov.b   21h[r14], 0Ch+var_B[sp]
FFF0CD71  b009                              movu.b  0Ch+var_B[sp], r1
FFF0CD73  6101                              cmp     #0, r1
FFF0CD75  2069                              beq.b   loc_FFF0CDDE
FFF0CD77  b009                              movu.b  0Ch+var_B[sp], r1
FFF0CD79  7551ff                            cmp     #-1, r1
FFF0CD7C  1c                                bne.s   loc_FFF0CD80
FFF0CD7D  3c0120                            mov.b   #20h, 0Ch+var_B[sp] ; ' '
FFF0CD80  b081                   loc_FFF0CD80 movu.b  0Ch+var_A[sp], r1
FFF0CD82  4401                              cmp     0Ch+var_C[sp], r1
FFF0CD84  2129                              bne.b   loc_FFF0CDAD
FFF0CD86  b089                              movu.b  0Ch+var_9[sp], r1
FFF0CD88  6111                              cmp     #1, r1
FFF0CD8A  2123                              bne.b   loc_FFF0CDAD
FFF0CD8C  b901                              movu.w  0Ch+var_4[sp], r1
FFF0CD8E  06c90102                          add     0Ch+var_8[sp].uw, r1
FFF0CD92  b90b                              movu.w  0Ch+var_2[sp], r3
FFF0CD94  06c90303                          add     0Ch+var_6[sp].uw, r3
FFF0CD98  6040                              sub     #4, sp
FFF0CD9A  f80980f9                          mov.w   #-680h, 10h+var_10[sp]
FFF0CD9E  5f12                              movu.w  r1, r2
FFF0CDA0  5f31                              movu.w  r3, r1
FFF0CDA2  75441c                            mov.l   #1Ch, r4
FFF0CDA5  66e3                              mov.l   #0Eh, r3
FFF0CDA7  05a14efe                          bsr.a   sub_FFEF1C48
FFF0CDAB  6240                              add     #4, sp
FFF0CDAD  b901                   loc_FFF0CDAD movu.w  0Ch+var_4[sp], r1
FFF0CDAF  06c90102                          add     0Ch+var_8[sp].uw, r1
FFF0CDB3  b90b                              movu.w  0Ch+var_2[sp], r3
FFF0CDB5  06c90303                          add     0Ch+var_6[sp].uw, r3
FFF0CDB9  b00c                              movu.b  0Ch+var_B[sp], r4
FFF0CDBB  6040                              sub     #4, sp
FFF0CDBD  f80401                            mov.b   #1, 10h+var_10[sp]
FFF0CDC0  5f12                              movu.w  r1, r2
FFF0CDC2  5f31                              movu.w  r3, r1
FFF0CDC4  66d3                              mov.l   #0Dh, r3
FFF0CDC6  05474bfe                          bsr.a   sub_FFEF190D
FFF0CDCA  6240                              add     #4, sp
FFF0CDCC  b889                              movu.w  0Ch+var_6[sp], r1
FFF0CDCE  62e1                              add     #0Eh, r1
FFF0CDD0  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF0CDD2  b081                              movu.b  0Ch+var_A[sp], r1
FFF0CDD4  6211                              add     #1, r1
FFF0CDD6  8081                              mov.b   r1, 0Ch+var_A[sp]
FFF0CDD8  b081                   loc_FFF0CDD8 movu.b  0Ch+var_A[sp], r1
FFF0CDDA  61a1                              cmp     #0Ah, r1
FFF0CDDC  2988                              blt.b   loc_FFF0CD64
FFF0CDDE  6703                   loc_FFF0CDDE rtsd    #3
FFF0CDE0  6040                   sub_FFF0CDE0 sub     #4, sp   ; <<<< FUNC sub_FFF0CDE0
FFF0CDE2  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0CDE5  2e0e                              bra.b   loc_FFF0CDF3
FFF0CDE7  b089                   loc_FFF0CDE7 movu.b  4+var_1[sp], r1
FFF0CDE9  051c57fe                          bsr.a   sub_FFEF2505
FFF0CDED  b089                              movu.b  4+var_1[sp], r1
FFF0CDEF  6211                              add     #1, r1
FFF0CDF1  8089                              mov.b   r1, 4+var_1[sp]
FFF0CDF3  b089                   loc_FFF0CDF3 movu.b  4+var_1[sp], r1
FFF0CDF5  755114                            cmp     #14h, r1
FFF0CDF8  29ef                              blt.b   loc_FFF0CDE7
FFF0CDFA  6701                              rtsd    #1
FFF0CDFC  fbe24c8c0000           sub_FFF0CDFC mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF0CDFC
FFF0CE02  58ee                              movu.b  [r14], r14
FFF0CE04  613e                              cmp     #3, r14
FFF0CE06  2a16                              bgt.b   loc_FFF0CE1C
FFF0CE08  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0CE0E  58ee                              movu.b  [r14], r14
FFF0CE10  fbf2c477edff                      mov.l   #off_FFED77C4, r15
FFF0CE16  fe6efe                            mov.l   [r14, r15], r14
FFF0CE19  7f1e                              jsr     r14
FFF0CE1B  02                                rts
FFF0CE1C  fbe24c8c0000           loc_FFF0CE1C mov.l   #8C4Ch, r14
FFF0CE22  f8e403                            mov.b   #3, [r14]
FFF0CE25  02                                rts
FFF0CE26  6611                   sub_FFF0CE26 mov.l   #1, r1   ; <<<< FUNC sub_FFF0CE26
FFF0CE28  39c102                            bsr.w   sub_FFF0D0E9
FFF0CE2B  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0CE31  58ef                              movu.b  [r14], r15
FFF0CE33  621f                              add     #1, r15
FFF0CE35  c3ef                              mov.b   r15, [r14]
FFF0CE37  02                                rts
FFF0CE38  6080                   sub_FFF0CE38 sub     #8, sp   ; <<<< FUNC sub_FFF0CE38
FFF0CE3A  05f334fe                          bsr.a   sub_FFEF032D
FFF0CE3E  0533d7fe                          bsr.a   sub_FFEFA571
FFF0CE42  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0CE48  b019                              movu.b  1[r1], r1
FFF0CE4A  61b1                              cmp     #0Bh, r1
FFF0CE4C  3aa900                            beq.w   loc_FFF0CEF5
FFF0CE4F  6151                              cmp     #5, r1
FFF0CE51  2056                              beq.b   loc_FFF0CEA7
FFF0CE53  711ef7                            add     #-9, r1, r14
FFF0CE56  612e                              cmp     #2, r14
FFF0CE58  2205                              bgeu.b  loc_FFF0CE5D
FFF0CE5A  389200                            bra.w   loc_FFF0CEEC
FFF0CE5D  6121                   loc_FFF0CE5D cmp     #2, r1
FFF0CE5F  3bb300                            bne.w   loc_FFF0CF12
FFF0CE62  3d032b                            mov.w   #2Bh, 8+var_2[sp] ; '+'
FFF0CE65  3d0214                            mov.w   #14h, 8+var_4[sp]
FFF0CE68  b882                              movu.w  8+var_4[sp], r2
FFF0CE6A  b889                              movu.w  8+var_2[sp], r1
FFF0CE6C  fb422cfdecff                      mov.l   #unk_FFECFD2C, r4
FFF0CE72  6613                              mov.l   #1, r3
FFF0CE74  05619afe                          bsr.a   sub_FFEF68D5
FFF0CE78  3d0314                            mov.w   #14h, 8+var_2[sp]
FFF0CE7B  3d0231                            mov.w   #31h, 8+var_4[sp] ; '1'
FFF0CE7E  3d0100                            mov.w   #0, 8+var_6[sp]
FFF0CE81  2e1e                              bra.b   loc_FFF0CE9F
FFF0CE83  b882                   loc_FFF0CE83 movu.w  8+var_4[sp], r2
FFF0CE85  06c90201                          add     8+var_6[sp].uw, r2
FFF0CE89  b889                              movu.w  8+var_2[sp], r1
FFF0CE8B  5f22                              movu.w  r2, r2
FFF0CE8D  fb423c1fedff                      mov.l   #unk_FFED1F3C, r4
FFF0CE93  6613                              mov.l   #1, r3
FFF0CE95  05409afe                          bsr.a   sub_FFEF68D5
FFF0CE99  9809                              mov.w   8+var_6[sp], r1
FFF0CE9B  6211                              add     #1, r1
FFF0CE9D  9009                              mov.w   r1, 8+var_6[sp]
FFF0CE9F  b809                   loc_FFF0CE9F movu.w  8+var_6[sp], r1
FFF0CEA1  6131                              cmp     #3, r1
FFF0CEA3  29e0                              blt.b   loc_FFF0CE83
FFF0CEA5  2e6d                              bra.b   loc_FFF0CF12
FFF0CEA7  3d032b                 loc_FFF0CEA7 mov.w   #2Bh, 8+var_2[sp] ; '+'
FFF0CEAA  3d0244                            mov.w   #44h, 8+var_4[sp] ; 'D'
FFF0CEAD  b882                              movu.w  8+var_4[sp], r2
FFF0CEAF  b889                              movu.w  8+var_2[sp], r1
FFF0CEB1  fb422cfdecff                      mov.l   #unk_FFECFD2C, r4
FFF0CEB7  6613                              mov.l   #1, r3
FFF0CEB9  051c9afe                          bsr.a   sub_FFEF68D5
FFF0CEBD  3d0314                            mov.w   #14h, 8+var_2[sp]
FFF0CEC0  3d0261                            mov.w   #61h, 8+var_4[sp] ; 'a'
FFF0CEC3  3d0100                            mov.w   #0, 8+var_6[sp]
FFF0CEC6  2e1e                              bra.b   loc_FFF0CEE4
FFF0CEC8  b882                   loc_FFF0CEC8 movu.w  8+var_4[sp], r2
FFF0CECA  06c90201                          add     8+var_6[sp].uw, r2
FFF0CECE  b889                              movu.w  8+var_2[sp], r1
FFF0CED0  5f22                              movu.w  r2, r2
FFF0CED2  fb423c1fedff                      mov.l   #unk_FFED1F3C, r4
FFF0CED8  6613                              mov.l   #1, r3
FFF0CEDA  05fb99fe                          bsr.a   sub_FFEF68D5
FFF0CEDE  9809                              mov.w   8+var_6[sp], r1
FFF0CEE0  6211                              add     #1, r1
FFF0CEE2  9009                              mov.w   r1, 8+var_6[sp]
FFF0CEE4  b809                   loc_FFF0CEE4 movu.w  8+var_6[sp], r1
FFF0CEE6  6131                              cmp     #3, r1
FFF0CEE8  29e0                              blt.b   loc_FFF0CEC8
FFF0CEEA  2e28                              bra.b   loc_FFF0CF12
FFF0CEEC  754113                 loc_FFF0CEEC mov.l   #13h, r1
FFF0CEEF  05a0cffe                          bsr.a   sub_FFEF9E8F
FFF0CEF3  2e1f                              bra.b   loc_FFF0CF12
FFF0CEF5  6040                   loc_FFF0CEF5 sub     #4, sp
FFF0CEF7  f809692a                          mov.w   #2A69h, 0Ch+var_C[sp]
FFF0CEFB  754414                            mov.l   #14h, r4
FFF0CEFE  fb3a4001                          mov.l   #140h, r3
FFF0CF02  6601                              mov.l   #0, r1
FFF0CF04  ef12                              mov.l   r1, r2
FFF0CF06  05424dfe                          bsr.a   sub_FFEF1C48
FFF0CF0A  6240                              add     #4, sp
FFF0CF0C  6661                              mov.l   #6, r1
FFF0CF0E  0581cffe                          bsr.a   sub_FFEF9E8F
FFF0CF12  fbe24c8c0000           loc_FFF0CF12 mov.l   #8C4Ch, r14
FFF0CF18  58ef                              movu.b  [r14], r15
FFF0CF1A  621f                              add     #1, r15
FFF0CF1C  c3ef                              mov.b   r15, [r14]
FFF0CF1E  6702                              rtsd    #2
FFF0CF20  6040                   sub_FFF0CF20 sub     #4, sp   ; <<<< FUNC sub_FFF0CF20
FFF0CF22  6040                              sub     #4, sp
FFF0CF24  3d00f0                            mov.w   #-10h, [sp]
FFF0CF27  fb4a4001                          mov.l   #140h, r4
FFF0CF2B  6602                              mov.l   #0, r2
FFF0CF2D  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0CF33  ef23                              mov.l   r2, r3
FFF0CF35  05862afe                          bsr.a   sub_FFEEF9BB
FFF0CF39  6240                              add     #4, sp
FFF0CF3B  8089                              mov.b   r1, 4+var_1[sp]
FFF0CF3D  b089                              movu.b  4+var_1[sp], r1
FFF0CF3F  6111                              cmp     #1, r1
FFF0CF41  1a                                bne.s   loc_FFF0CF4B
FFF0CF42  398207                            bsr.w   sub_FFF0D6C4
FFF0CF45  052a34fe                          bsr.a   sub_FFEF036F
FFF0CF49  6701                              rtsd    #1
FFF0CF4B  6701                   loc_FFF0CF4B rtsd    #1
FFF0CF4D  6040                   sub_FFF0CF4D sub     #4, sp   ; <<<< FUNC sub_FFF0CF4D
FFF0CF4F  6040                              sub     #4, sp
FFF0CF51  3d00f0                            mov.w   #-10h, [sp]
FFF0CF54  fb4a4001                          mov.l   #140h, r4
FFF0CF58  6602                              mov.l   #0, r2
FFF0CF5A  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0CF60  ef23                              mov.l   r2, r3
FFF0CF62  05592afe                          bsr.a   sub_FFEEF9BB
FFF0CF66  6240                              add     #4, sp
FFF0CF68  8089                              mov.b   r1, 4+var_1[sp]
FFF0CF6A  b089                              movu.b  4+var_1[sp], r1
FFF0CF6C  6111                              cmp     #1, r1
FFF0CF6E  1a                                bne.s   loc_FFF0CF78
FFF0CF6F  396a07                            bsr.w   sub_FFF0D6D9
FFF0CF72  05fd33fe                          bsr.a   sub_FFEF036F
FFF0CF76  6701                              rtsd    #1
FFF0CF78  6701                   loc_FFF0CF78 rtsd    #1
FFF0CF7A  6040                   sub_FFF0CF7A sub     #4, sp   ; <<<< FUNC sub_FFF0CF7A
FFF0CF7C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CF82  c5e00102                          mov.b   1[r14], 4+var_2[sp]
FFF0CF86  b081                              movu.b  4+var_2[sp], r1
FFF0CF88  61b1                              cmp     #0Bh, r1
FFF0CF8A  2120                              bne.b   loc_FFF0CFAA
FFF0CF8C  6040                              sub     #4, sp
FFF0CF8E  f80529                            mov.w   #29h, 8+var_8[sp] ; ')'
FFF0CF91  fb4a4001                          mov.l   #140h, r4
FFF0CF95  7543c7                            mov.l   #-39h, r3
FFF0CF98  6602                              mov.l   #0, r2
FFF0CF9A  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0CFA0  051b2afe                          bsr.a   sub_FFEEF9BB
FFF0CFA4  6240                              add     #4, sp
FFF0CFA6  8089                              mov.b   r1, 4+var_1[sp]
FFF0CFA8  2e1e                              bra.b   loc_FFF0CFC6
FFF0CFAA  6040                   loc_FFF0CFAA sub     #4, sp
FFF0CFAC  f80547                            mov.w   #47h, 8+var_8[sp] ; 'G'
FFF0CFAF  fb4a4001                          mov.l   #140h, r4
FFF0CFB3  7543a9                            mov.l   #-57h, r3
FFF0CFB6  6602                              mov.l   #0, r2
FFF0CFB8  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0CFBE  05fd29fe                          bsr.a   sub_FFEEF9BB
FFF0CFC2  6240                              add     #4, sp
FFF0CFC4  8089                              mov.b   r1, 4+var_1[sp]
FFF0CFC6  b089                   loc_FFF0CFC6 movu.b  4+var_1[sp], r1
FFF0CFC8  6111                              cmp     #1, r1
FFF0CFCA  1a                                bne.s   loc_FFF0CFD4
FFF0CFCB  395807                            bsr.w   sub_FFF0D723
FFF0CFCE  05a133fe                          bsr.a   sub_FFEF036F
FFF0CFD2  6701                              rtsd    #1
FFF0CFD4  6701                   loc_FFF0CFD4 rtsd    #1
FFF0CFD6  6040                   sub_FFF0CFD6 sub     #4, sp   ; <<<< FUNC sub_FFF0CFD6
FFF0CFD8  fbe2738f0000                      mov.l   #8F73h, r14
FFF0CFDE  58e1                              movu.b  [r14], r1
FFF0CFE0  6041                              sub     #4, r1
FFF0CFE2  8081                              mov.b   r1, 4+var_2[sp]
FFF0CFE4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0CFEA  c5e00101                          mov.b   1[r14], 4+var_3[sp]
FFF0CFEE  b009                              movu.b  4+var_3[sp], r1
FFF0CFF0  61b1                              cmp     #0Bh, r1
FFF0CFF2  b081                              movu.b  4+var_2[sp], r1
FFF0CFF4  212d                              bne.b   loc_FFF0D021
FFF0CFF6  b085                              movu.b  4+var_2[sp], r5
FFF0CFF8  6c35                              shll    #3, r5
FFF0CFFA  fbe23860ecff                      mov.l   #unk_FFEC6038, r14
FFF0D000  4be5                              add     r14, r5
FFF0D002  b8d4                              movu.w  4[r5], r4
FFF0D004  b85b                              movu.w  2[r5], r3
FFF0D006  6c31                              shll    #3, r1
FFF0D008  4b1e                              add     r1, r14
FFF0D00A  5ce2                              movu.w  [r14], r2
FFF0D00C  6040                              sub     #4, sp
FFF0D00E  d15003                            mov.w   6[r5], 8+var_8[sp]
FFF0D011  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0D017  05a429fe                          bsr.a   sub_FFEEF9BB
FFF0D01B  6240                              add     #4, sp
FFF0D01D  8089                              mov.b   r1, 4+var_1[sp]
FFF0D01F  2e2b                              bra.b   loc_FFF0D04A
FFF0D021  b085                   loc_FFF0D021 movu.b  4+var_2[sp], r5
FFF0D023  6c35                              shll    #3, r5
FFF0D025  fbe28061ecff                      mov.l   #unk_FFEC6180, r14
FFF0D02B  4be5                              add     r14, r5
FFF0D02D  b8d4                              movu.w  4[r5], r4
FFF0D02F  b85b                              movu.w  2[r5], r3
FFF0D031  6c31                              shll    #3, r1
FFF0D033  4b1e                              add     r1, r14
FFF0D035  5ce2                              movu.w  [r14], r2
FFF0D037  6040                              sub     #4, sp
FFF0D039  d15003                            mov.w   6[r5], 8+var_8[sp]
FFF0D03C  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0D042  057929fe                          bsr.a   sub_FFEEF9BB
FFF0D046  6240                              add     #4, sp
FFF0D048  8089                              mov.b   r1, 4+var_1[sp]
FFF0D04A  b089                   loc_FFF0D04A movu.b  4+var_1[sp], r1
FFF0D04C  6111                              cmp     #1, r1
FFF0D04E  210e                              bne.b   loc_FFF0D05C
FFF0D050  b081                              movu.b  4+var_2[sp], r1
FFF0D052  05b354fe                          bsr.a   sub_FFEF2505
FFF0D056  051933fe                          bsr.a   sub_FFEF036F
FFF0D05A  6701                              rtsd    #1
FFF0D05C  6701                   loc_FFF0D05C rtsd    #1
FFF0D05E  6040                   sub_FFF0D05E sub     #4, sp   ; <<<< FUNC sub_FFF0D05E
FFF0D060  6601                              mov.l   #0, r1
FFF0D062  398700                            bsr.w   sub_FFF0D0E9
FFF0D065  05da2ffe                          bsr.a   sub_FFEF003F
FFF0D069  fbe2738f0000                      mov.l   #8F73h, r14
FFF0D06F  c3e1                              mov.b   r1, [r14]
FFF0D071  fbe2738f0000                      mov.l   #8F73h, r14
FFF0D077  58ee                              movu.b  [r14], r14
FFF0D079  755eff                            cmp     #-1, r14
FFF0D07C  2012                              beq.b   loc_FFF0D08E
FFF0D07E  fbe2738f0000                      mov.l   #8F73h, r14
FFF0D084  58ee                              movu.b  [r14], r14
FFF0D086  616e                              cmp     #6, r14
FFF0D088  2406                              bgtu.b  loc_FFF0D08E
FFF0D08A  f80601                            mov.l   #1, 4+var_4[sp]
FFF0D08D  0c                                bra.s   loc_FFF0D091
FFF0D08E  f80600                 loc_FFF0D08E mov.l   #0, 4+var_4[sp]
FFF0D091  ec01                   loc_FFF0D091 mov.l   4+var_4[sp], r1
FFF0D093  6101                              cmp     #0, r1
FFF0D095  2029                              beq.b   loc_FFF0D0BE
FFF0D097  05ed2afe                          bsr.a   sub_FFEEFB84
FFF0D09B  6101                              cmp     #0, r1
FFF0D09D  2121                              bne.b   loc_FFF0D0BE
FFF0D09F  fbe2738f0000                      mov.l   #8F73h, r14
FFF0D0A5  58e1                              movu.b  [r14], r1
FFF0D0A7  05432ffe                          bsr.a   sub_FFEEFFEA
FFF0D0AB  fbe2738f0000                      mov.l   #8F73h, r14
FFF0D0B1  58ee                              movu.b  [r14], r14
FFF0D0B3  fbf2d477edff                      mov.l   #off_FFED77D4, r15
FFF0D0B9  fe6efe                            mov.l   [r14, r15], r14
FFF0D0BC  7f1e                              jsr     r14
FFF0D0BE  fbe24c8c0000           loc_FFF0D0BE mov.l   #8C4Ch, r14
FFF0D0C4  58ee                              movu.b  [r14], r14
FFF0D0C6  614e                              cmp     #4, r14
FFF0D0C8  290d                              blt.b   loc_FFF0D0D5
FFF0D0CA  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0D0D0  f8e403                            mov.b   #3, [r14]
FFF0D0D3  6701                              rtsd    #1
FFF0D0D5  fbe24c8c0000           loc_FFF0D0D5 mov.l   #8C4Ch, r14
FFF0D0DB  58ee                              movu.b  [r14], r14
FFF0D0DD  612e                              cmp     #2, r14
FFF0D0DF  2a08                              bgt.b   loc_FFF0D0E7
FFF0D0E1  054b2ffe                          bsr.a   sub_FFEF002C
FFF0D0E5  6701                              rtsd    #1
FFF0D0E7  6701                   loc_FFF0D0E7 rtsd    #1
FFF0D0E9  6040                   sub_FFF0D0E9 sub     #4, sp   ; <<<< FUNC sub_FFF0D0E9
FFF0D0EB  8089                              mov.b   r1, 4+var_1[sp]
FFF0D0ED  391700                            bsr.w   sub_FFF0D104
FFF0D0F0  395f00                            bsr.w   sub_FFF0D14F
FFF0D0F3  05c76ffe                          bsr.a   sub_FFEF40BA
FFF0D0F7  b089                              movu.b  4+var_1[sp], r1
FFF0D0F9  6111                              cmp     #1, r1
FFF0D0FB  1f                                bne.s   loc_FFF0D102
FFF0D0FC  05302ffe                          bsr.a   sub_FFEF002C
FFF0D100  6701                              rtsd    #1
FFF0D102  6701                   loc_FFF0D102 rtsd    #1
FFF0D104  fbe24d8c0000           sub_FFF0D104 mov.l   #8C4Dh, r14   ; <<<< FUNC sub_FFF0D104
FFF0D10A  58ee                              movu.b  [r14], r14
FFF0D10C  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D112  44fe                              cmp     [r15], r14
FFF0D114  2010                              beq.b   loc_FFF0D124
FFF0D116  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D11C  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D122  c0fe                              mov.b   [r15], [r14]
FFF0D124  fb124d8c0000           loc_FFF0D124 mov.l   #8C4Dh, r1
FFF0D12A  b019                              movu.b  1[r1], r1
FFF0D12C  fbe2468e0000                      mov.l   #8E46h, r14
FFF0D132  45e101                            cmp     1[r14], r1
FFF0D135  2019                              beq.b   loc_FFF0D14E
FFF0D137  6611                              mov.l   #1, r1
FFF0D139  056b2dfe                          bsr.a   sub_FFEEFEA4
FFF0D13D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D143  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D149  c5fe0101                          mov.b   1[r15], 1[r14]
FFF0D14D  02                                rts
FFF0D14E  02                     loc_FFF0D14E rts
FFF0D14F  6080                   sub_FFF0D14F sub     #8, sp   ; <<<< FUNC sub_FFF0D14F
FFF0D151  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0D157  b019                              movu.b  1[r1], r1
FFF0D159  61b1                              cmp     #0Bh, r1
FFF0D15B  3a8604                            beq.w   loc_FFF0D5E1
FFF0D15E  6171                              cmp     #7, r1
FFF0D160  3a3502                            beq.w   loc_FFF0D395
FFF0D163  6181                              cmp     #8, r1
FFF0D165  3a8702                            beq.w   loc_FFF0D3EC
FFF0D168  6191                              cmp     #9, r1
FFF0D16A  3ad902                            beq.w   loc_FFF0D443
FFF0D16D  61a1                              cmp     #0Ah, r1
FFF0D16F  3ab803                            beq.w   loc_FFF0D527
FFF0D172  6151                              cmp     #5, r1
FFF0D174  3b4e05                            bne.w   loc_FFF0D6C2
FFF0D177  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D17D  59ee20                            movu.b  20h[r14], r14
FFF0D180  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D186  45fe20                            cmp     20h[r15], r14
FFF0D189  2115                              bne.b   loc_FFF0D19E
FFF0D18B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D191  59ee21                            movu.b  21h[r14], r14
FFF0D194  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D19A  45fe21                            cmp     21h[r15], r14
FFF0D19D  15                                beq.s   loc_FFF0D1A2
FFF0D19E  f80601                 loc_FFF0D19E mov.l   #1, 8+var_8[sp]
FFF0D1A1  0c                                bra.s   loc_FFF0D1A5
FFF0D1A2  f80600                 loc_FFF0D1A2 mov.l   #0, 8+var_8[sp]
FFF0D1A5  ec01                   loc_FFF0D1A5 mov.l   8+var_8[sp], r1
FFF0D1A7  6101                              cmp     #0, r1
FFF0D1A9  2028                              beq.b   loc_FFF0D1D1
FFF0D1AB  6681                              mov.l   #8, r1
FFF0D1AD  05f72cfe                          bsr.a   sub_FFEEFEA4
FFF0D1B1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D1B7  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D1BD  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0D1C1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D1C7  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D1CD  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF0D1D1  3c0700                 loc_FFF0D1D1 mov.b   #0, 8+var_1[sp]
FFF0D1D4  2e3e                              bra.b   loc_FFF0D212
FFF0D1D6  b189                   loc_FFF0D1D6 movu.b  8+var_1[sp], r1
FFF0D1D8  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D1DE  4b1e                              add     r1, r14
FFF0D1E0  59ee22                            movu.b  22h[r14], r14
FFF0D1E3  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D1E9  4b1f                              add     r1, r15
FFF0D1EB  45fe22                            cmp     22h[r15], r14
FFF0D1EE  201e                              beq.b   loc_FFF0D20C
FFF0D1F0  6681                              mov.l   #8, r1
FFF0D1F2  05b22cfe                          bsr.a   sub_FFEEFEA4
FFF0D1F6  b189                              movu.b  8+var_1[sp], r1
FFF0D1F8  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D1FE  4b1e                              add     r1, r14
FFF0D200  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D206  4b1f                              add     r1, r15
FFF0D208  c5fe2222                          mov.b   22h[r15], 22h[r14]
FFF0D20C  b189                   loc_FFF0D20C movu.b  8+var_1[sp], r1
FFF0D20E  6211                              add     #1, r1
FFF0D210  8189                              mov.b   r1, 8+var_1[sp]
FFF0D212  b189                   loc_FFF0D212 movu.b  8+var_1[sp], r1
FFF0D214  61f1                              cmp     #0Fh, r1
FFF0D216  2bc0                              ble.b   loc_FFF0D1D6
FFF0D218  3c0700                            mov.b   #0, 8+var_1[sp]
FFF0D21B  2e3e                              bra.b   loc_FFF0D259
FFF0D21D  b189                   loc_FFF0D21D movu.b  8+var_1[sp], r1
FFF0D21F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D225  4b1e                              add     r1, r14
FFF0D227  59ee32                            movu.b  32h[r14], r14
FFF0D22A  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D230  4b1f                              add     r1, r15
FFF0D232  45fe32                            cmp     32h[r15], r14
FFF0D235  201e                              beq.b   loc_FFF0D253
FFF0D237  6681                              mov.l   #8, r1
FFF0D239  056b2cfe                          bsr.a   sub_FFEEFEA4
FFF0D23D  b189                              movu.b  8+var_1[sp], r1
FFF0D23F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D245  4b1e                              add     r1, r14
FFF0D247  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D24D  4b1f                              add     r1, r15
FFF0D24F  c5fe3232                          mov.b   32h[r15], 32h[r14]
FFF0D253  b189                   loc_FFF0D253 movu.b  8+var_1[sp], r1
FFF0D255  6211                              add     #1, r1
FFF0D257  8189                              mov.b   r1, 8+var_1[sp]
FFF0D259  b189                   loc_FFF0D259 movu.b  8+var_1[sp], r1
FFF0D25B  61a1                              cmp     #0Ah, r1
FFF0D25D  29c0                              blt.b   loc_FFF0D21D
FFF0D25F  3c0700                            mov.b   #0, 8+var_1[sp]
FFF0D262  2e3e                              bra.b   loc_FFF0D2A0
FFF0D264  b189                   loc_FFF0D264 movu.b  8+var_1[sp], r1
FFF0D266  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D26C  4b1e                              add     r1, r14
FFF0D26E  59ee3c                            movu.b  3Ch[r14], r14
FFF0D271  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D277  4b1f                              add     r1, r15
FFF0D279  45fe3c                            cmp     3Ch[r15], r14
FFF0D27C  201e                              beq.b   loc_FFF0D29A
FFF0D27E  6681                              mov.l   #8, r1
FFF0D280  05242cfe                          bsr.a   sub_FFEEFEA4
FFF0D284  b189                              movu.b  8+var_1[sp], r1
FFF0D286  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D28C  4b1e                              add     r1, r14
FFF0D28E  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D294  4b1f                              add     r1, r15
FFF0D296  c5fe3c3c                          mov.b   3Ch[r15], 3Ch[r14]
FFF0D29A  b189                   loc_FFF0D29A movu.b  8+var_1[sp], r1
FFF0D29C  6211                              add     #1, r1
FFF0D29E  8189                              mov.b   r1, 8+var_1[sp]
FFF0D2A0  b189                   loc_FFF0D2A0 movu.b  8+var_1[sp], r1
FFF0D2A2  61a1                              cmp     #0Ah, r1
FFF0D2A4  29c0                              blt.b   loc_FFF0D264
FFF0D2A6  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0D2AC  b291                              movu.b  0Ah[r1], r1
FFF0D2AE  fbe2468e0000                      mov.l   #8E46h, r14
FFF0D2B4  45e10a                            cmp     0Ah[r14], r1
FFF0D2B7  2018                              beq.b   loc_FFF0D2CF
FFF0D2B9  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D2BF  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D2C5  c5fe0a0a                          mov.b   0Ah[r15], 0Ah[r14]
FFF0D2C9  6681                              mov.l   #8, r1
FFF0D2CB  05d92bfe                          bsr.a   sub_FFEEFEA4
FFF0D2CF  fb124d8c0000           loc_FFF0D2CF mov.l   #8C4Dh, r1
FFF0D2D5  b299                              movu.b  0Bh[r1], r1
FFF0D2D7  fbe2468e0000                      mov.l   #8E46h, r14
FFF0D2DD  45e10b                            cmp     0Bh[r14], r1
FFF0D2E0  2018                              beq.b   loc_FFF0D2F8
FFF0D2E2  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D2E8  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D2EE  c5fe0b0b                          mov.b   0Bh[r15], 0Bh[r14]
FFF0D2F2  6681                              mov.l   #8, r1
FFF0D2F4  05b02bfe                          bsr.a   sub_FFEEFEA4
FFF0D2F8  fb124d8c0000           loc_FFF0D2F8 mov.l   #8C4Dh, r1
FFF0D2FE  b311                              movu.b  0Ch[r1], r1
FFF0D300  fbe2468e0000                      mov.l   #8E46h, r14
FFF0D306  45e10c                            cmp     0Ch[r14], r1
FFF0D309  2018                              beq.b   loc_FFF0D321
FFF0D30B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D311  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D317  c5fe0c0c                          mov.b   0Ch[r15], 0Ch[r14]
FFF0D31B  6681                              mov.l   #8, r1
FFF0D31D  05872bfe                          bsr.a   sub_FFEEFEA4
FFF0D321  3c0700                 loc_FFF0D321 mov.b   #0, 8+var_1[sp]
FFF0D324  2e3e                              bra.b   loc_FFF0D362
FFF0D326  b189                   loc_FFF0D326 movu.b  8+var_1[sp], r1
FFF0D328  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D32E  4b1e                              add     r1, r14
FFF0D330  59ee46                            movu.b  46h[r14], r14
FFF0D333  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D339  4b1f                              add     r1, r15
FFF0D33B  45fe46                            cmp     46h[r15], r14
FFF0D33E  201e                              beq.b   loc_FFF0D35C
FFF0D340  6681                              mov.l   #8, r1
FFF0D342  05622bfe                          bsr.a   sub_FFEEFEA4
FFF0D346  b189                              movu.b  8+var_1[sp], r1
FFF0D348  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D34E  4b1e                              add     r1, r14
FFF0D350  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D356  4b1f                              add     r1, r15
FFF0D358  c5fe4646                          mov.b   46h[r15], 46h[r14]
FFF0D35C  b189                   loc_FFF0D35C movu.b  8+var_1[sp], r1
FFF0D35E  6211                              add     #1, r1
FFF0D360  8189                              mov.b   r1, 8+var_1[sp]
FFF0D362  b189                   loc_FFF0D362 movu.b  8+var_1[sp], r1
FFF0D364  61f1                              cmp     #0Fh, r1
FFF0D366  2bc0                              ble.b   loc_FFF0D326
FFF0D368  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D36E  59ee56                            movu.b  56h[r14], r14
FFF0D371  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D377  45fe56                            cmp     56h[r15], r14
FFF0D37A  3a4803                            beq.w   loc_FFF0D6C2
FFF0D37D  6681                              mov.l   #8, r1
FFF0D37F  05252bfe                          bsr.a   sub_FFEEFEA4
FFF0D383  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D389  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D38F  c5fe5656                          mov.b   56h[r15], 56h[r14]
FFF0D393  6702                              rtsd    #2
FFF0D395  fbe24d8c0000           loc_FFF0D395 mov.l   #8C4Dh, r14
FFF0D39B  59ee20                            movu.b  20h[r14], r14
FFF0D39E  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D3A4  45fe20                            cmp     20h[r15], r14
FFF0D3A7  2018                              beq.b   loc_FFF0D3BF
FFF0D3A9  6681                              mov.l   #8, r1
FFF0D3AB  05f92afe                          bsr.a   sub_FFEEFEA4
FFF0D3AF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D3B5  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D3BB  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0D3BF  fbe24d8c0000           loc_FFF0D3BF mov.l   #8C4Dh, r14
FFF0D3C5  59ee21                            movu.b  21h[r14], r14
FFF0D3C8  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D3CE  45fe21                            cmp     21h[r15], r14
FFF0D3D1  3af102                            beq.w   loc_FFF0D6C2
FFF0D3D4  6681                              mov.l   #8, r1
FFF0D3D6  05ce2afe                          bsr.a   sub_FFEEFEA4
FFF0D3DA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D3E0  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D3E6  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF0D3EA  6702                              rtsd    #2
FFF0D3EC  fbe24d8c0000           loc_FFF0D3EC mov.l   #8C4Dh, r14
FFF0D3F2  59ee20                            movu.b  20h[r14], r14
FFF0D3F5  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D3FB  45fe20                            cmp     20h[r15], r14
FFF0D3FE  2018                              beq.b   loc_FFF0D416
FFF0D400  6681                              mov.l   #8, r1
FFF0D402  05a22afe                          bsr.a   sub_FFEEFEA4
FFF0D406  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D40C  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D412  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0D416  fbe24d8c0000           loc_FFF0D416 mov.l   #8C4Dh, r14
FFF0D41C  59ee21                            movu.b  21h[r14], r14
FFF0D41F  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D425  45fe21                            cmp     21h[r15], r14
FFF0D428  3a9a02                            beq.w   loc_FFF0D6C2
FFF0D42B  6681                              mov.l   #8, r1
FFF0D42D  05772afe                          bsr.a   sub_FFEEFEA4
FFF0D431  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D437  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D43D  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF0D441  6702                              rtsd    #2
FFF0D443  fbe24d8c0000           loc_FFF0D443 mov.l   #8C4Dh, r14
FFF0D449  59ee20                            movu.b  20h[r14], r14
FFF0D44C  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D452  45fe20                            cmp     20h[r15], r14
FFF0D455  2018                              beq.b   loc_FFF0D46D
FFF0D457  6681                              mov.l   #8, r1
FFF0D459  054b2afe                          bsr.a   sub_FFEEFEA4
FFF0D45D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D463  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D469  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0D46D  fbe24d8c0000           loc_FFF0D46D mov.l   #8C4Dh, r14
FFF0D473  59ee21                            movu.b  21h[r14], r14
FFF0D476  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D47C  45fe21                            cmp     21h[r15], r14
FFF0D47F  2018                              beq.b   loc_FFF0D497
FFF0D481  6681                              mov.l   #8, r1
FFF0D483  05212afe                          bsr.a   sub_FFEEFEA4
FFF0D487  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D48D  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D493  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF0D497  3c0700                 loc_FFF0D497 mov.b   #0, 8+var_1[sp]
FFF0D49A  388100                            bra.w   loc_FFF0D51B
FFF0D49D  b189                   loc_FFF0D49D movu.b  8+var_1[sp], r1
FFF0D49F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D4A5  4b1e                              add     r1, r14
FFF0D4A7  59ee22                            movu.b  22h[r14], r14
FFF0D4AA  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D4B0  4b1f                              add     r1, r15
FFF0D4B2  45fe22                            cmp     22h[r15], r14
FFF0D4B5  2024                              beq.b   loc_FFF0D4D9
FFF0D4B7  b18a                              movu.b  8+var_1[sp], r2
FFF0D4B9  754110                            mov.l   #10h, r1
FFF0D4BC  fd6221                            shll    r2, r1
FFF0D4BF  05e529fe                          bsr.a   sub_FFEEFEA4
FFF0D4C3  b189                              movu.b  8+var_1[sp], r1
FFF0D4C5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D4CB  4b1e                              add     r1, r14
FFF0D4CD  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D4D3  4b1f                              add     r1, r15
FFF0D4D5  c5fe2222                          mov.b   22h[r15], 22h[r14]
FFF0D4D9  b189                   loc_FFF0D4D9 movu.b  8+var_1[sp], r1
FFF0D4DB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D4E1  4b1e                              add     r1, r14
FFF0D4E3  59ee24                            movu.b  24h[r14], r14
FFF0D4E6  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D4EC  4b1f                              add     r1, r15
FFF0D4EE  45fe24                            cmp     24h[r15], r14
FFF0D4F1  2024                              beq.b   loc_FFF0D515
FFF0D4F3  b18a                              movu.b  8+var_1[sp], r2
FFF0D4F5  754110                            mov.l   #10h, r1
FFF0D4F8  fd6221                            shll    r2, r1
FFF0D4FB  05a929fe                          bsr.a   sub_FFEEFEA4
FFF0D4FF  b189                              movu.b  8+var_1[sp], r1
FFF0D501  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D507  4b1e                              add     r1, r14
FFF0D509  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D50F  4b1f                              add     r1, r15
FFF0D511  c5fe2424                          mov.b   24h[r15], 24h[r14]
FFF0D515  b189                   loc_FFF0D515 movu.b  8+var_1[sp], r1
FFF0D517  6211                              add     #1, r1
FFF0D519  8189                              mov.b   r1, 8+var_1[sp]
FFF0D51B  b189                   loc_FFF0D51B movu.b  8+var_1[sp], r1
FFF0D51D  6121                              cmp     #2, r1
FFF0D51F  2805                              bge.b   loc_FFF0D524
FFF0D521  387cff                            bra.w   loc_FFF0D49D
FFF0D524  389e01                 loc_FFF0D524 bra.w   loc_FFF0D6C2
FFF0D527  fbe24d8c0000           loc_FFF0D527 mov.l   #8C4Dh, r14
FFF0D52D  59ee20                            movu.b  20h[r14], r14
FFF0D530  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D536  45fe20                            cmp     20h[r15], r14
FFF0D539  2018                              beq.b   loc_FFF0D551
FFF0D53B  6681                              mov.l   #8, r1
FFF0D53D  056729fe                          bsr.a   sub_FFEEFEA4
FFF0D541  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D547  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D54D  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0D551  3c0700                 loc_FFF0D551 mov.b   #0, 8+var_1[sp]
FFF0D554  388100                            bra.w   loc_FFF0D5D5
FFF0D557  b189                   loc_FFF0D557 movu.b  8+var_1[sp], r1
FFF0D559  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D55F  4b1e                              add     r1, r14
FFF0D561  59ee21                            movu.b  21h[r14], r14
FFF0D564  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D56A  4b1f                              add     r1, r15
FFF0D56C  45fe21                            cmp     21h[r15], r14
FFF0D56F  2024                              beq.b   loc_FFF0D593
FFF0D571  b18a                              movu.b  8+var_1[sp], r2
FFF0D573  754110                            mov.l   #10h, r1
FFF0D576  fd6221                            shll    r2, r1
FFF0D579  052b29fe                          bsr.a   sub_FFEEFEA4
FFF0D57D  b189                              movu.b  8+var_1[sp], r1
FFF0D57F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D585  4b1e                              add     r1, r14
FFF0D587  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D58D  4b1f                              add     r1, r15
FFF0D58F  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF0D593  b189                   loc_FFF0D593 movu.b  8+var_1[sp], r1
FFF0D595  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D59B  4b1e                              add     r1, r14
FFF0D59D  59ee23                            movu.b  23h[r14], r14
FFF0D5A0  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D5A6  4b1f                              add     r1, r15
FFF0D5A8  45fe23                            cmp     23h[r15], r14
FFF0D5AB  2024                              beq.b   loc_FFF0D5CF
FFF0D5AD  b18a                              movu.b  8+var_1[sp], r2
FFF0D5AF  754110                            mov.l   #10h, r1
FFF0D5B2  fd6221                            shll    r2, r1
FFF0D5B5  05ef28fe                          bsr.a   sub_FFEEFEA4
FFF0D5B9  b189                              movu.b  8+var_1[sp], r1
FFF0D5BB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D5C1  4b1e                              add     r1, r14
FFF0D5C3  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D5C9  4b1f                              add     r1, r15
FFF0D5CB  c5fe2323                          mov.b   23h[r15], 23h[r14]
FFF0D5CF  b189                   loc_FFF0D5CF movu.b  8+var_1[sp], r1
FFF0D5D1  6211                              add     #1, r1
FFF0D5D3  8189                              mov.b   r1, 8+var_1[sp]
FFF0D5D5  b189                   loc_FFF0D5D5 movu.b  8+var_1[sp], r1
FFF0D5D7  6121                              cmp     #2, r1
FFF0D5D9  2805                              bge.b   loc_FFF0D5DE
FFF0D5DB  387cff                            bra.w   loc_FFF0D557
FFF0D5DE  38e400                 loc_FFF0D5DE bra.w   loc_FFF0D6C2
FFF0D5E1  fbe24d8c0000           loc_FFF0D5E1 mov.l   #8C4Dh, r14
FFF0D5E7  59ee20                            movu.b  20h[r14], r14
FFF0D5EA  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D5F0  45fe20                            cmp     20h[r15], r14
FFF0D5F3  2018                              beq.b   loc_FFF0D60B
FFF0D5F5  6681                              mov.l   #8, r1
FFF0D5F7  05ad28fe                          bsr.a   sub_FFEEFEA4
FFF0D5FB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D601  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D607  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0D60B  fbe24d8c0000           loc_FFF0D60B mov.l   #8C4Dh, r14
FFF0D611  59ee21                            movu.b  21h[r14], r14
FFF0D614  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D61A  45fe21                            cmp     21h[r15], r14
FFF0D61D  2018                              beq.b   loc_FFF0D635
FFF0D61F  6681                              mov.l   #8, r1
FFF0D621  058328fe                          bsr.a   sub_FFEEFEA4
FFF0D625  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D62B  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D631  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF0D635  3c0700                 loc_FFF0D635 mov.b   #0, 8+var_1[sp]
FFF0D638  388100                            bra.w   loc_FFF0D6B9
FFF0D63B  b189                   loc_FFF0D63B movu.b  8+var_1[sp], r1
FFF0D63D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D643  4b1e                              add     r1, r14
FFF0D645  59ee22                            movu.b  22h[r14], r14
FFF0D648  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D64E  4b1f                              add     r1, r15
FFF0D650  45fe22                            cmp     22h[r15], r14
FFF0D653  2024                              beq.b   loc_FFF0D677
FFF0D655  b18a                              movu.b  8+var_1[sp], r2
FFF0D657  754110                            mov.l   #10h, r1
FFF0D65A  fd6221                            shll    r2, r1
FFF0D65D  054728fe                          bsr.a   sub_FFEEFEA4
FFF0D661  b189                              movu.b  8+var_1[sp], r1
FFF0D663  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D669  4b1e                              add     r1, r14
FFF0D66B  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D671  4b1f                              add     r1, r15
FFF0D673  c5fe2222                          mov.b   22h[r15], 22h[r14]
FFF0D677  b189                   loc_FFF0D677 movu.b  8+var_1[sp], r1
FFF0D679  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D67F  4b1e                              add     r1, r14
FFF0D681  59ee24                            movu.b  24h[r14], r14
FFF0D684  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D68A  4b1f                              add     r1, r15
FFF0D68C  45fe24                            cmp     24h[r15], r14
FFF0D68F  2024                              beq.b   loc_FFF0D6B3
FFF0D691  b18a                              movu.b  8+var_1[sp], r2
FFF0D693  754110                            mov.l   #10h, r1
FFF0D696  fd6221                            shll    r2, r1
FFF0D699  050b28fe                          bsr.a   sub_FFEEFEA4
FFF0D69D  b189                              movu.b  8+var_1[sp], r1
FFF0D69F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0D6A5  4b1e                              add     r1, r14
FFF0D6A7  fbf2468e0000                      mov.l   #8E46h, r15
FFF0D6AD  4b1f                              add     r1, r15
FFF0D6AF  c5fe2424                          mov.b   24h[r15], 24h[r14]
FFF0D6B3  b189                   loc_FFF0D6B3 movu.b  8+var_1[sp], r1
FFF0D6B5  6211                              add     #1, r1
FFF0D6B7  8189                              mov.b   r1, 8+var_1[sp]
FFF0D6B9  b189                   loc_FFF0D6B9 movu.b  8+var_1[sp], r1
FFF0D6BB  6121                              cmp     #2, r1
FFF0D6BD  2805                              bge.b   loc_FFF0D6C2
FFF0D6BF  387cff                            bra.w   loc_FFF0D63B
FFF0D6C2  6702                   loc_FFF0D6C2 rtsd    #2
FFF0D6C4  fbe2798d0000           sub_FFF0D6C4 mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF0D6C4
FFF0D6CA  f8e400                            mov.b   #0, [r14]
FFF0D6CD  6601                              mov.l   #0, r1
FFF0D6CF  ef12                              mov.l   r1, r2
FFF0D6D1  05372dfe                          bsr.a   sub_FFEF0408
FFF0D6D5  390400                            bsr.w   sub_FFF0D6D9
FFF0D6D8  02                                rts
FFF0D6D9  fb124d8c0000           sub_FFF0D6D9 mov.l   #8C4Dh, r1   ; <<<< FUNC sub_FFF0D6D9
FFF0D6DF  b019                              movu.b  1[r1], r1
FFF0D6E1  61b1                              cmp     #0Bh, r1
FFF0D6E3  2038                              beq.b   loc_FFF0D71B
FFF0D6E5  6151                              cmp     #5, r1
FFF0D6E7  201a                              beq.b   loc_FFF0D701
FFF0D6E9  6171                              cmp     #7, r1
FFF0D6EB  201a                              beq.b   loc_FFF0D705
FFF0D6ED  6181                              cmp     #8, r1
FFF0D6EF  201a                              beq.b   loc_FFF0D709
FFF0D6F1  6191                              cmp     #9, r1
FFF0D6F3  201a                              beq.b   loc_FFF0D70D
FFF0D6F5  61a1                              cmp     #0Ah, r1
FFF0D6F7  201d                              beq.b   loc_FFF0D714
FFF0D6F9  6121                              cmp     #2, r1
FFF0D6FB  2127                              bne.b   loc_FFF0D722
FFF0D6FD  394100                            bsr.w   sub_FFF0D73E
FFF0D700  02                                rts
FFF0D701  394a03                 loc_FFF0D701 bsr.w   sub_FFF0DA4B
FFF0D704  02                                rts
FFF0D705  39fe03                 loc_FFF0D705 bsr.w   sub_FFF0DB03
FFF0D708  02                                rts
FFF0D709  394d07                 loc_FFF0D709 bsr.w   sub_FFF0DE56
FFF0D70C  02                                rts
FFF0D70D  390b0a                 loc_FFF0D70D bsr.w   sub_FFF0E118
FFF0D710  391300                            bsr.w   sub_FFF0D723
FFF0D713  02                                rts
FFF0D714  397e0c                 loc_FFF0D714 bsr.w   sub_FFF0E392
FFF0D717  390c00                            bsr.w   sub_FFF0D723
FFF0D71A  02                                rts
FFF0D71B  39fc0e                 loc_FFF0D71B bsr.w   sub_FFF0E617
FFF0D71E  390500                            bsr.w   sub_FFF0D723
FFF0D721  02                                rts
FFF0D722  02                     loc_FFF0D722 rts
FFF0D723  6040                   sub_FFF0D723 sub     #4, sp   ; <<<< FUNC sub_FFF0D723
FFF0D725  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0D728  2e0e                              bra.b   loc_FFF0D736
FFF0D72A  b089                   loc_FFF0D72A movu.b  4+var_1[sp], r1
FFF0D72C  05d94dfe                          bsr.a   sub_FFEF2505
FFF0D730  b089                              movu.b  4+var_1[sp], r1
FFF0D732  6211                              add     #1, r1
FFF0D734  8089                              mov.b   r1, 4+var_1[sp]
FFF0D736  b089                   loc_FFF0D736 movu.b  4+var_1[sp], r1
FFF0D738  6121                              cmp     #2, r1
FFF0D73A  29f0                              blt.b   loc_FFF0D72A
FFF0D73C  6701                              rtsd    #1
FFF0D73E  720078ff               sub_FFF0D73E add     #-88h, sp, sp   ; <<<< FUNC sub_FFF0D73E
FFF0D742  754316                            mov.l   #16h, r3
FFF0D745  fb22e0abf4ff                      mov.l   #aCallsignInput, r2; "---CALLSIGN  INPUT---"
FFF0D74B  710172                            add     #88h+var_16, sp, r1
FFF0D74E  7f8f                              smovf
FFF0D750  f905330e                          mov.w   #0Eh, 88h+var_22[sp]
FFF0D754  f9053220                          mov.w   #20h, 88h+var_24[sp] ; ' '
FFF0D758  7544f0                            mov.l   #-10h, r4
FFF0D75B  fb3a4001                          mov.l   #140h, r3
FFF0D75F  6601                              mov.l   #0, r1
FFF0D761  ef12                              mov.l   r1, r2
FFF0D763  05942dfe                          bsr.a   sub_FFEF04F7
FFF0D767  f905370d                          mov.w   #0Dh, 88h+var_1A[sp]
FFF0D76B  f9053646                          mov.w   #46h, 88h+var_1C[sp] ; 'F'
FFF0D76F  5d0236                            movu.w  88h+var_1C[sp], r2
FFF0D772  5d0137                            movu.w  88h+var_1A[sp], r1
FFF0D775  60c0                              sub     #0Ch, sp
FFF0D777  71037e                            add     #94h+var_16, sp, r3
FFF0D77A  a00b                              mov.l   r3, 94h+var_90[sp]
FFF0D77C  3c0801                            mov.b   #1, 94h+var_8C[sp]
FFF0D77F  f80415                            mov.b   #15h, 94h+var_94[sp]
FFF0D782  6604                              mov.l   #0, r4
FFF0D784  66d3                              mov.l   #0Dh, r3
FFF0D786  059d43fe                          bsr.a   sub_FFEF1B23
FFF0D78A  62c0                              add     #0Ch, sp
FFF0D78C  f9053400                          mov.w   #0, 88h+var_20[sp]
FFF0D790  fbe2728f0000                      mov.l   #8F72h, r14
FFF0D796  58ee                              movu.b  [r14], r14
FFF0D798  610e                              cmp     #0, r14
FFF0D79A  3be101                            bne.w   loc_FFF0D97B
FFF0D79D  754336                            mov.l   #36h, r3 ; '6'
FFF0D7A0  fb22f6abf4ff                      mov.l   #aHKJK0ak3K5SRFo, r2; "*$H;$$K$J$k$0AK$\"!3%<!k%5%$%s%r$!!!!~F"...
FFF0D7A6  71012e                            add     #88h+var_5A, sp, r1
FFF0D7A9  7f8f                              smovf
FFF0D7AB  f9047000                          mov.b   #0, 88h+var_18[sp]
FFF0D7AF  2e5b                              bra.b   loc_FFF0D80A
FFF0D7B1  f9047100               loc_FFF0D7B1 mov.b   #0, 88h+var_17[sp]
FFF0D7B5  2e46                              bra.b   loc_FFF0D7FB
FFF0D7B7  590170                 loc_FFF0D7B7 movu.b  88h+var_18[sp], r1
FFF0D7BA  751112                            mul     #12h, r1
FFF0D7BD  710e2e                            add     #88h+var_5A, sp, r14
FFF0D7C0  4b1e                              add     r1, r14
FFF0D7C2  590171                            movu.b  88h+var_17[sp], r1
FFF0D7C5  fed1e4                            movu.w  [r1, r14], r4
FFF0D7C8  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D7CB  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D7CF  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D7D2  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D7D6  6040                              sub     #4, sp
FFF0D7D8  f80401                            mov.b   #1, 8Ch+var_8C[sp]
FFF0D7DB  5f12                              movu.w  r1, r2
FFF0D7DD  5f31                              movu.w  r3, r1
FFF0D7DF  6623                              mov.l   #2, r3
FFF0D7E1  052c41fe                          bsr.a   sub_FFEF190D
FFF0D7E5  6240                              add     #4, sp
FFF0D7E7  5d0133                            movu.w  88h+var_22[sp], r1
FFF0D7EA  6c11                              shll    #1, r1
FFF0D7EC  06c90135                          add     88h+var_1E[sp].uw, r1
FFF0D7F0  d70135                            mov.w   r1, 88h+var_1E[sp]
FFF0D7F3  590171                            movu.b  88h+var_17[sp], r1
FFF0D7F6  6211                              add     #1, r1
FFF0D7F8  c70171                            mov.b   r1, 88h+var_17[sp]
FFF0D7FB  590171                 loc_FFF0D7FB movu.b  88h+var_17[sp], r1
FFF0D7FE  6191                              cmp     #9, r1
FFF0D800  29b7                              blt.b   loc_FFF0D7B7
FFF0D802  590170                            movu.b  88h+var_18[sp], r1
FFF0D805  6211                              add     #1, r1
FFF0D807  c70170                            mov.b   r1, 88h+var_18[sp]
FFF0D80A  dd0133                 loc_FFF0D80A mov.w   88h+var_22[sp], r1
FFF0D80D  590270                            movu.b  88h+var_18[sp], r2
FFF0D810  d70135                            mov.w   r1, 88h+var_1E[sp]
FFF0D813  5d0134                            movu.w  88h+var_20[sp], r1
FFF0D816  06c90132                          add     88h+var_24[sp].uw, r1
FFF0D81A  d70134                            mov.w   r1, 88h+var_20[sp]
FFF0D81D  6132                              cmp     #3, r2
FFF0D81F  2992                              blt.b   loc_FFF0D7B1
FFF0D821  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D824  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D828  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D82B  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D82F  60c0                              sub     #0Ch, sp
FFF0D831  fb222cacf4ff                      mov.l   #(aHKJK0ak3K5SRFo+36h), r2; "( "
FFF0D837  a00a                              mov.l   r2, 94h+var_90[sp]
FFF0D839  3c0801                            mov.b   #1, 94h+var_8C[sp]
FFF0D83C  f80402                            mov.b   #2, 94h+var_94[sp]
FFF0D83F  5f12                              movu.w  r1, r2
FFF0D841  5f31                              movu.w  r3, r1
FFF0D843  6604                              mov.l   #0, r4
FFF0D845  66d3                              mov.l   #0Dh, r3
FFF0D847  05dc42fe                          bsr.a   sub_FFEF1B23
FFF0D84B  62c0                              add     #0Ch, sp
FFF0D84D  5d0133                            movu.w  88h+var_22[sp], r1
FFF0D850  6c11                              shll    #1, r1
FFF0D852  06c90135                          add     88h+var_1E[sp].uw, r1
FFF0D856  d70135                            mov.w   r1, 88h+var_1E[sp]
FFF0D859  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D85C  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D860  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D863  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D867  6040                              sub     #4, sp
FFF0D869  f80401                            mov.b   #1, 8Ch+var_8C[sp]
FFF0D86C  5f12                              movu.w  r1, r2
FFF0D86E  5f31                              movu.w  r3, r1
FFF0D870  fb4a473a                          mov.l   #3A47h, r4
FFF0D874  6623                              mov.l   #2, r3
FFF0D876  059740fe                          bsr.a   sub_FFEF190D
FFF0D87A  6240                              add     #4, sp
FFF0D87C  5d0133                            movu.w  88h+var_22[sp], r1
FFF0D87F  6c11                              shll    #1, r1
FFF0D881  06c90135                          add     88h+var_1E[sp].uw, r1
FFF0D885  d70135                            mov.w   r1, 88h+var_1E[sp]
FFF0D888  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D88B  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D88F  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D892  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D896  6040                              sub     #4, sp
FFF0D898  f80401                            mov.b   #1, 8Ch+var_8C[sp]
FFF0D89B  5f12                              movu.w  r1, r2
FFF0D89D  5f31                              movu.w  r3, r1
FFF0D89F  fb4a6742                          mov.l   #4267h, r4
FFF0D8A3  6623                              mov.l   #2, r3
FFF0D8A5  056840fe                          bsr.a   sub_FFEF190D
FFF0D8A9  6240                              add     #4, sp
FFF0D8AB  5d0133                            movu.w  88h+var_22[sp], r1
FFF0D8AE  6c11                              shll    #1, r1
FFF0D8B0  06c90135                          add     88h+var_1E[sp].uw, r1
FFF0D8B4  d70135                            mov.w   r1, 88h+var_1E[sp]
FFF0D8B7  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D8BA  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D8BE  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D8C1  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D8C5  60c0                              sub     #0Ch, sp
FFF0D8C7  fb222facf4ff                      mov.l   #a10, r2; " 10 "
FFF0D8CD  a00a                              mov.l   r2, 94h+var_90[sp]
FFF0D8CF  3c0801                            mov.b   #1, 94h+var_8C[sp]
FFF0D8D2  f80404                            mov.b   #4, 94h+var_94[sp]
FFF0D8D5  5f12                              movu.w  r1, r2
FFF0D8D7  5f31                              movu.w  r3, r1
FFF0D8D9  6604                              mov.l   #0, r4
FFF0D8DB  66d3                              mov.l   #0Dh, r3
FFF0D8DD  054642fe                          bsr.a   sub_FFEF1B23
FFF0D8E1  62c0                              add     #0Ch, sp
FFF0D8E3  5d0133                            movu.w  88h+var_22[sp], r1
FFF0D8E6  6c21                              shll    #2, r1
FFF0D8E8  06c90135                          add     88h+var_1E[sp].uw, r1
FFF0D8EC  d70135                            mov.w   r1, 88h+var_1E[sp]
FFF0D8EF  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D8F2  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D8F6  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D8F9  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D8FD  6040                              sub     #4, sp
FFF0D8FF  f80401                            mov.b   #1, 8Ch+var_8C[sp]
FFF0D902  5f12                              movu.w  r1, r2
FFF0D904  5f31                              movu.w  r3, r1
FFF0D906  fb4a384a                          mov.l   #4A38h, r4
FFF0D90A  6623                              mov.l   #2, r3
FFF0D90C  050140fe                          bsr.a   sub_FFEF190D
FFF0D910  6240                              add     #4, sp
FFF0D912  5d0133                            movu.w  88h+var_22[sp], r1
FFF0D915  6c11                              shll    #1, r1
FFF0D917  06c90135                          add     88h+var_1E[sp].uw, r1
FFF0D91B  d70135                            mov.w   r1, 88h+var_1E[sp]
FFF0D91E  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D921  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D925  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D928  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D92C  6040                              sub     #4, sp
FFF0D92E  f80401                            mov.b   #1, 8Ch+var_8C[sp]
FFF0D931  5f12                              movu.w  r1, r2
FFF0D933  5f31                              movu.w  r3, r1
FFF0D935  fb4a7a3b                          mov.l   #3B7Ah, r4
FFF0D939  6623                              mov.l   #2, r3
FFF0D93B  05d23ffe                          bsr.a   sub_FFEF190D
FFF0D93F  6240                              add     #4, sp
FFF0D941  5d0133                            movu.w  88h+var_22[sp], r1
FFF0D944  6c11                              shll    #1, r1
FFF0D946  06c90135                          add     88h+var_1E[sp].uw, r1
FFF0D94A  d70135                            mov.w   r1, 88h+var_1E[sp]
FFF0D94D  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D950  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D954  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D957  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D95B  60c0                              sub     #0Ch, sp
FFF0D95D  fb2234acf4ff                      mov.l   #asc_FFF4AC34, r2; " )"
FFF0D963  a00a                              mov.l   r2, 94h+var_90[sp]
FFF0D965  3c0801                            mov.b   #1, 94h+var_8C[sp]
FFF0D968  f80402                            mov.b   #2, 94h+var_94[sp]
FFF0D96B  5f12                              movu.w  r1, r2
FFF0D96D  5f31                              movu.w  r3, r1
FFF0D96F  6604                              mov.l   #0, r4
FFF0D971  66d3                              mov.l   #0Dh, r3
FFF0D973  05b041fe                          bsr.a   sub_FFEF1B23
FFF0D977  62c0                              add     #0Ch, sp
FFF0D979  6722                              rtsd    #22h ; '"'
FFF0D97B  754312                 loc_FFF0D97B mov.l   #12h, r3
FFF0D97E  fb2237acf4ff                      mov.l   #aPleaseEnterYou, r2; "Please enter your"
FFF0D984  71011c                            add     #88h+var_6C, sp, r1
FFF0D987  7f8f                              smovf
FFF0D989  3d0d2e                            mov.w   #2Eh, 88h+var_6E[sp] ; '.'
FFF0D98C  710116                            add     #88h+var_72, sp, r1
FFF0D98F  f8127369676e                      mov.l   #6E676973h, [r1]
FFF0D995  710112                            add     #88h+var_76, sp, r1
FFF0D998  f81243616c6c                      mov.l   #6C6C6143h, [r1]
FFF0D99E  754311                            mov.l   #11h, r3
FFF0D9A1  fb2253acf4ff                      mov.l   #aMax10Letters, r2; "(Max 10 letters)"
FFF0D9A7  710101                            add     #88h+var_87, sp, r1
FFF0D9AA  7f8f                              smovf
FFF0D9AC  d5003335                          mov.w   88h+var_22[sp], 88h+var_1E[sp]
FFF0D9B0  5d0134                            movu.w  88h+var_20[sp], r1
FFF0D9B3  06c90132                          add     88h+var_24[sp].uw, r1
FFF0D9B7  d70134                            mov.w   r1, 88h+var_20[sp]
FFF0D9BA  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D9BD  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D9C1  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D9C4  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D9C8  60c0                              sub     #0Ch, sp
FFF0D9CA  710228                            add     #94h+var_6C, sp, r2
FFF0D9CD  a00a                              mov.l   r2, 94h+var_90[sp]
FFF0D9CF  3c0801                            mov.b   #1, 94h+var_8C[sp]
FFF0D9D2  f80411                            mov.b   #11h, 94h+var_94[sp]
FFF0D9D5  5f12                              movu.w  r1, r2
FFF0D9D7  5f31                              movu.w  r3, r1
FFF0D9D9  6604                              mov.l   #0, r4
FFF0D9DB  66d3                              mov.l   #0Dh, r3
FFF0D9DD  054641fe                          bsr.a   sub_FFEF1B23
FFF0D9E1  62c0                              add     #0Ch, sp
FFF0D9E3  5d0134                            movu.w  88h+var_20[sp], r1
FFF0D9E6  06c90132                          add     88h+var_24[sp].uw, r1
FFF0D9EA  d70134                            mov.w   r1, 88h+var_20[sp]
FFF0D9ED  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0D9F0  06c90134                          add     88h+var_20[sp].uw, r1
FFF0D9F4  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0D9F7  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0D9FB  60c0                              sub     #0Ch, sp
FFF0D9FD  71021e                            add     #94h+var_76, sp, r2
FFF0DA00  a00a                              mov.l   r2, 94h+var_90[sp]
FFF0DA02  3c0801                            mov.b   #1, 94h+var_8C[sp]
FFF0DA05  f80409                            mov.b   #9, 94h+var_94[sp]
FFF0DA08  5f12                              movu.w  r1, r2
FFF0DA0A  5f31                              movu.w  r3, r1
FFF0DA0C  6604                              mov.l   #0, r4
FFF0DA0E  66d3                              mov.l   #0Dh, r3
FFF0DA10  051341fe                          bsr.a   sub_FFEF1B23
FFF0DA14  62c0                              add     #0Ch, sp
FFF0DA16  5d0134                            movu.w  88h+var_20[sp], r1
FFF0DA19  06c90132                          add     88h+var_24[sp].uw, r1
FFF0DA1D  d70134                            mov.w   r1, 88h+var_20[sp]
FFF0DA20  5d0136                            movu.w  88h+var_1C[sp], r1
FFF0DA23  06c90134                          add     88h+var_20[sp].uw, r1
FFF0DA27  5d0337                            movu.w  88h+var_1A[sp], r3
FFF0DA2A  06c90335                          add     88h+var_1E[sp].uw, r3
FFF0DA2E  60c0                              sub     #0Ch, sp
FFF0DA30  71020d                            add     #94h+var_87, sp, r2
FFF0DA33  a00a                              mov.l   r2, 94h+var_90[sp]
FFF0DA35  3c0801                            mov.b   #1, 94h+var_8C[sp]
FFF0DA38  f80410                            mov.b   #10h, 94h+var_94[sp]
FFF0DA3B  5f12                              movu.w  r1, r2
FFF0DA3D  5f31                              movu.w  r3, r1
FFF0DA3F  6604                              mov.l   #0, r4
FFF0DA41  66d3                              mov.l   #0Dh, r3
FFF0DA43  05e040fe                          bsr.a   sub_FFEF1B23
FFF0DA47  62c0                              add     #0Ch, sp
FFF0DA49  6722                              rtsd    #22h
FFF0DA4B  6080                   sub_FFF0DA4B sub     #8, sp   ; <<<< FUNC sub_FFF0DA4B
FFF0DA4D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0DA53  c5e05603                          mov.b   56h[r14], 8+var_5[sp]
FFF0DA57  7544f0                            mov.l   #-10h, r4
FFF0DA5A  fb3a4001                          mov.l   #140h, r3
FFF0DA5E  6601                              mov.l   #0, r1
FFF0DA60  ef12                              mov.l   r1, r2
FFF0DA62  05952afe                          bsr.a   sub_FFEF04F7
FFF0DA66  3d035a                            mov.w   #5Ah, 8+var_2[sp] ; 'Z'
FFF0DA69  3d028a                            mov.w   #-76h, 8+var_4[sp]
FFF0DA6C  b882                              movu.w  8+var_4[sp], r2
FFF0DA6E  b889                              movu.w  8+var_2[sp], r1
FFF0DA70  60c0                              sub     #0Ch, sp
FFF0DA72  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF0DA78  713332                            add     #32h, r3, r3 ; '2'
FFF0DA7B  a00b                              mov.l   r3, 14h+var_10[sp]
FFF0DA7D  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF0DA80  f8040a                            mov.b   #0Ah, 14h+var_14[sp]
FFF0DA83  6604                              mov.l   #0, r4
FFF0DA85  66d3                              mov.l   #0Dh, r3
FFF0DA87  059c40fe                          bsr.a   sub_FFEF1B23
FFF0DA8B  62c0                              add     #0Ch, sp
FFF0DA8D  3d02aa                            mov.w   #-56h, 8+var_4[sp]
FFF0DA90  b882                              movu.w  8+var_4[sp], r2
FFF0DA92  b889                              movu.w  8+var_2[sp], r1
FFF0DA94  60c0                              sub     #0Ch, sp
FFF0DA96  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF0DA9C  71333c                            add     #3Ch, r3, r3 ; '<'
FFF0DA9F  a00b                              mov.l   r3, 14h+var_10[sp]
FFF0DAA1  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF0DAA4  f8040a                            mov.b   #0Ah, 14h+var_14[sp]
FFF0DAA7  6604                              mov.l   #0, r4
FFF0DAA9  66d3                              mov.l   #0Dh, r3
FFF0DAAB  057840fe                          bsr.a   sub_FFEF1B23
FFF0DAAF  62c0                              add     #0Ch, sp
FFF0DAB1  3d0330                            mov.w   #30h, 8+var_2[sp] ; '0'
FFF0DAB4  3d02ca                            mov.w   #-36h, 8+var_4[sp]
FFF0DAB7  b089                              movu.b  8+var_5[sp], r1
FFF0DAB9  6111                              cmp     #1, r1
FFF0DABB  211d                              bne.b   loc_FFF0DAD8
FFF0DABD  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF0DAC3  594320                            movu.b  20h[r4], r3
FFF0DAC6  6c83                              shll    #8, r3
FFF0DAC8  554321                            or      21h[r4], r3
FFF0DACB  b882                              movu.w  8+var_4[sp], r2
FFF0DACD  b889                              movu.w  8+var_2[sp], r1
FFF0DACF  714422                            add     #22h, r4, r4 ; '"'
FFF0DAD2  0515cdfe                          bsr.a   sub_FFEFA7E7
FFF0DAD6  6702                              rtsd    #2
FFF0DAD8  b089                   loc_FFF0DAD8 movu.b  8+var_5[sp], r1
FFF0DADA  6121                              cmp     #2, r1
FFF0DADC  2125                              bne.b   loc_FFF0DB01
FFF0DADE  b882                              movu.w  8+var_4[sp], r2
FFF0DAE0  b889                              movu.w  8+var_2[sp], r1
FFF0DAE2  60c0                              sub     #0Ch, sp
FFF0DAE4  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF0DAEA  713346                            add     #46h, r3, r3 ; 'F'
FFF0DAED  a00b                              mov.l   r3, 14h+var_10[sp]
FFF0DAEF  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF0DAF2  f80410                            mov.b   #10h, 14h+var_14[sp]
FFF0DAF5  6604                              mov.l   #0, r4
FFF0DAF7  66d3                              mov.l   #0Dh, r3
FFF0DAF9  052a40fe                          bsr.a   sub_FFEF1B23
FFF0DAFD  62c0                              add     #0Ch, sp
FFF0DAFF  6702                              rtsd    #2
FFF0DB01  6702                   loc_FFF0DB01 rtsd    #2
FFF0DB03  720060ff               sub_FFF0DB03 add     #-0A0h, sp, sp   ; <<<< FUNC sub_FFF0DB03
FFF0DB07  f9054e50                          mov.w   #50h, 0A0h+var_4[sp] ; 'P'
FFF0DB0B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0DB11  c5e0209b                          mov.b   20h[r14], 0A0h+var_5[sp]
FFF0DB15  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0DB1B  c5e0219a                          mov.b   21h[r14], 0A0h+var_6[sp]
FFF0DB1F  7544f0                            mov.l   #-10h, r4
FFF0DB22  fb3a4001                          mov.l   #140h, r3
FFF0DB26  6601                              mov.l   #0, r1
FFF0DB28  ef12                              mov.l   r1, r2
FFF0DB2A  05cd29fe                          bsr.a   sub_FFEF04F7
FFF0DB2E  59019b                            movu.b  0A0h+var_5[sp], r1
FFF0DB31  6101                              cmp     #0, r1
FFF0DB33  2b09                              ble.b   loc_FFF0DB3C
FFF0DB35  59019b                            movu.b  0A0h+var_5[sp], r1
FFF0DB38  6161                              cmp     #6, r1
FFF0DB3A  2906                              blt.b   loc_FFF0DB40
FFF0DB3C  f80601                 loc_FFF0DB3C mov.l   #1, 0A0h+var_A0[sp]
FFF0DB3F  0c                                bra.s   loc_FFF0DB43
FFF0DB40  f80600                 loc_FFF0DB40 mov.l   #0, 0A0h+var_A0[sp]
FFF0DB43  ec01                   loc_FFF0DB43 mov.l   0A0h+var_A0[sp], r1
FFF0DB45  6101                              cmp     #0, r1
FFF0DB47  3b0d03                            bne.w   loc_FFF0DE54
FFF0DB4A  fbe2728f0000                      mov.l   #8F72h, r14
FFF0DB50  58ee                              movu.b  [r14], r14
FFF0DB52  610e                              cmp     #0, r14
FFF0DB54  3be701                            bne.w   loc_FFF0DD3B
FFF0DB57  fbe264acf4ff                      mov.l   #aEefcEe04NEeIPC, r14; "<=EEfC<=EE04;N<=EE(%i%<!P%C%F%j%<!$LuAe"...
FFF0DB5D  d4e049                            mov.w   [r14], 0A0h+var_E[sp]
FFF0DB60  d5e0014a                          mov.w   2[r14], 0A0h+var_C[sp]
FFF0DB64  d5e0024b                          mov.w   4[r14], 0A0h+var_A[sp]
FFF0DB68  fbe26aacf4ff                      mov.l   #(aEefcEe04NEeIPC+6), r14; "<=EE04;N<=EE(%i%<!P%C%F%j%<!$LuAeC03tIE"...
FFF0DB6E  d4e045                            mov.w   [r14], 0A0h+var_16[sp]
FFF0DB71  d5e00146                          mov.w   2[r14], 0A0h+var_14[sp]
FFF0DB75  d5e00247                          mov.w   4[r14], 0A0h+var_12[sp]
FFF0DB79  d5e00348                          mov.w   6[r14], 0A0h+var_10[sp]
FFF0DB7D  fbe272acf4ff                      mov.l   #(aEefcEe04NEeIPC+0Eh), r14; "<=EE(%i%<!P%C%F%j%<!$LuAeC03tIEE;8\\@3B"
FFF0DB83  d4e040                            mov.w   [r14], 0A0h+var_20[sp]
FFF0DB86  d5e00141                          mov.w   2[r14], 0A0h+var_1E[sp]
FFF0DB8A  d5e00242                          mov.w   4[r14], 0A0h+var_1C[sp]
FFF0DB8E  d5e00343                          mov.w   6[r14], 0A0h+var_1A[sp]
FFF0DB92  d5e00444                          mov.w   8[r14], 0A0h+var_18[sp]
FFF0DB96  fbe27cacf4ff                      mov.l   #(aEefcEe04NEeIPC+18h), r14; "P%C%F%j%<!$LuAeC03tIEE;8\\@3B"
FFF0DB9C  d4e038                            mov.w   [r14], 0A0h+var_30[sp]
FFF0DB9F  d5e00139                          mov.w   2[r14], 0A0h+var_2E[sp]
FFF0DBA3  d5e0023a                          mov.w   4[r14], 0A0h+var_2C[sp]
FFF0DBA7  d5e0033b                          mov.w   6[r14], 0A0h+var_2A[sp]
FFF0DBAB  d5e0043c                          mov.w   8[r14], 0A0h+var_28[sp]
FFF0DBAF  d5e0053d                          mov.w   0Ah[r14], 0A0h+var_26[sp]
FFF0DBB3  d5e0063e                          mov.w   0Ch[r14], 0A0h+var_24[sp]
FFF0DBB7  d5e0073f                          mov.w   0Eh[r14], 0A0h+var_22[sp]
FFF0DBBB  fbe28cacf4ff                      mov.l   #(aEefcEe04NEeIPC+28h), r14; "03tIEE;8\\@3B"
FFF0DBC1  d4e032                            mov.w   [r14], 0A0h+var_3C[sp]
FFF0DBC4  d5e00133                          mov.w   2[r14], 0A0h+var_3A[sp]
FFF0DBC8  d5e00234                          mov.w   4[r14], 0A0h+var_38[sp]
FFF0DBCC  d5e00335                          mov.w   6[r14], 0A0h+var_36[sp]
FFF0DBD0  d5e00436                          mov.w   8[r14], 0A0h+var_34[sp]
FFF0DBD4  d5e00537                          mov.w   0Ah[r14], 0A0h+var_32[sp]
FFF0DBD8  59019b                            movu.b  0A0h+var_5[sp], r1
FFF0DBDB  6111                              cmp     #1, r1
FFF0DBDD  2144                              bne.b   loc_FFF0DC21
FFF0DBDF  f9054f74                          mov.w   #74h, 0A0h+var_2[sp] ; 't'
FFF0DBE3  f9049900                          mov.b   #0, 0A0h+var_7[sp]
FFF0DBE7  2e30                              bra.b   loc_FFF0DC17
FFF0DBE9  720e9200               loc_FFF0DBE9 add     #0A0h+var_E, sp, r14
FFF0DBED  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DBF0  fed1e4                            movu.w  [r1, r14], r4
FFF0DBF3  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DBF6  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DBF9  6040                              sub     #4, sp
FFF0DBFB  f80401                            mov.b   #1, 0A4h+var_A4[sp]
FFF0DBFE  6623                              mov.l   #2, r3
FFF0DC00  050d3dfe                          bsr.a   sub_FFEF190D
FFF0DC04  6240                              add     #4, sp
FFF0DC06  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DC09  71111e                            add     #1Eh, r1, r1
FFF0DC0C  d7014f                            mov.w   r1, 0A0h+var_2[sp]
FFF0DC0F  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DC12  6211                              add     #1, r1
FFF0DC14  c70199                            mov.b   r1, 0A0h+var_7[sp]
FFF0DC17  590199                 loc_FFF0DC17 movu.b  0A0h+var_7[sp], r1
FFF0DC1A  6131                              cmp     #3, r1
FFF0DC1C  29cd                              blt.b   loc_FFF0DBE9
FFF0DC1E  386a01                            bra.w   loc_FFF0DD88
FFF0DC21  59019b                 loc_FFF0DC21 movu.b  0A0h+var_5[sp], r1
FFF0DC24  6121                              cmp     #2, r1
FFF0DC26  2144                              bne.b   loc_FFF0DC6A
FFF0DC28  f9054f65                          mov.w   #65h, 0A0h+var_2[sp] ; 'e'
FFF0DC2C  f9049900                          mov.b   #0, 0A0h+var_7[sp]
FFF0DC30  2e30                              bra.b   loc_FFF0DC60
FFF0DC32  720e8a00               loc_FFF0DC32 add     #0A0h+var_16, sp, r14
FFF0DC36  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DC39  fed1e4                            movu.w  [r1, r14], r4
FFF0DC3C  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DC3F  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DC42  6040                              sub     #4, sp
FFF0DC44  f80401                            mov.b   #1, 0A4h+var_A4[sp]
FFF0DC47  6623                              mov.l   #2, r3
FFF0DC49  05c43cfe                          bsr.a   sub_FFEF190D
FFF0DC4D  6240                              add     #4, sp
FFF0DC4F  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DC52  71111e                            add     #1Eh, r1, r1
FFF0DC55  d7014f                            mov.w   r1, 0A0h+var_2[sp]
FFF0DC58  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DC5B  6211                              add     #1, r1
FFF0DC5D  c70199                            mov.b   r1, 0A0h+var_7[sp]
FFF0DC60  590199                 loc_FFF0DC60 movu.b  0A0h+var_7[sp], r1
FFF0DC63  6141                              cmp     #4, r1
FFF0DC65  29cd                              blt.b   loc_FFF0DC32
FFF0DC67  382101                            bra.w   loc_FFF0DD88
FFF0DC6A  59019b                 loc_FFF0DC6A movu.b  0A0h+var_5[sp], r1
FFF0DC6D  6131                              cmp     #3, r1
FFF0DC6F  2144                              bne.b   loc_FFF0DCB3
FFF0DC71  f9054f56                          mov.w   #56h, 0A0h+var_2[sp] ; 'V'
FFF0DC75  f9049900                          mov.b   #0, 0A0h+var_7[sp]
FFF0DC79  2e30                              bra.b   loc_FFF0DCA9
FFF0DC7B  720e8000               loc_FFF0DC7B add     #0A0h+var_20, sp, r14
FFF0DC7F  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DC82  fed1e4                            movu.w  [r1, r14], r4
FFF0DC85  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DC88  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DC8B  6040                              sub     #4, sp
FFF0DC8D  f80401                            mov.b   #1, 0A4h+var_A4[sp]
FFF0DC90  6623                              mov.l   #2, r3
FFF0DC92  057b3cfe                          bsr.a   sub_FFEF190D
FFF0DC96  6240                              add     #4, sp
FFF0DC98  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DC9B  71111e                            add     #1Eh, r1, r1
FFF0DC9E  d7014f                            mov.w   r1, 0A0h+var_2[sp]
FFF0DCA1  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DCA4  6211                              add     #1, r1
FFF0DCA6  c70199                            mov.b   r1, 0A0h+var_7[sp]
FFF0DCA9  590199                 loc_FFF0DCA9 movu.b  0A0h+var_7[sp], r1
FFF0DCAC  6151                              cmp     #5, r1
FFF0DCAE  29cd                              blt.b   loc_FFF0DC7B
FFF0DCB0  38d800                            bra.w   loc_FFF0DD88
FFF0DCB3  59019b                 loc_FFF0DCB3 movu.b  0A0h+var_5[sp], r1
FFF0DCB6  6141                              cmp     #4, r1
FFF0DCB8  2143                              bne.b   loc_FFF0DCFB
FFF0DCBA  f9054f29                          mov.w   #29h, 0A0h+var_2[sp] ; ')'
FFF0DCBE  f9049900                          mov.b   #0, 0A0h+var_7[sp]
FFF0DCC2  2e2f                              bra.b   loc_FFF0DCF1
FFF0DCC4  710e70                 loc_FFF0DCC4 add     #0A0h+var_30, sp, r14
FFF0DCC7  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DCCA  fed1e4                            movu.w  [r1, r14], r4
FFF0DCCD  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DCD0  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DCD3  6040                              sub     #4, sp
FFF0DCD5  f80401                            mov.b   #1, 0A4h+var_A4[sp]
FFF0DCD8  6623                              mov.l   #2, r3
FFF0DCDA  05333cfe                          bsr.a   sub_FFEF190D
FFF0DCDE  6240                              add     #4, sp
FFF0DCE0  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DCE3  71111e                            add     #1Eh, r1, r1
FFF0DCE6  d7014f                            mov.w   r1, 0A0h+var_2[sp]
FFF0DCE9  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DCEC  6211                              add     #1, r1
FFF0DCEE  c70199                            mov.b   r1, 0A0h+var_7[sp]
FFF0DCF1  590199                 loc_FFF0DCF1 movu.b  0A0h+var_7[sp], r1
FFF0DCF4  6181                              cmp     #8, r1
FFF0DCF6  29ce                              blt.b   loc_FFF0DCC4
FFF0DCF8  389000                            bra.w   loc_FFF0DD88
FFF0DCFB  f9054f47               loc_FFF0DCFB mov.w   #47h, 0A0h+var_2[sp] ; 'G'
FFF0DCFF  f9049900                          mov.b   #0, 0A0h+var_7[sp]
FFF0DD03  2e2f                              bra.b   loc_FFF0DD32
FFF0DD05  710e64                 loc_FFF0DD05 add     #0A0h+var_3C, sp, r14
FFF0DD08  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DD0B  fed1e4                            movu.w  [r1, r14], r4
FFF0DD0E  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DD11  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DD14  6040                              sub     #4, sp
FFF0DD16  f80401                            mov.b   #1, 0A4h+var_A4[sp]
FFF0DD19  6623                              mov.l   #2, r3
FFF0DD1B  05f23bfe                          bsr.a   sub_FFEF190D
FFF0DD1F  6240                              add     #4, sp
FFF0DD21  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DD24  71111e                            add     #1Eh, r1, r1
FFF0DD27  d7014f                            mov.w   r1, 0A0h+var_2[sp]
FFF0DD2A  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DD2D  6211                              add     #1, r1
FFF0DD2F  c70199                            mov.b   r1, 0A0h+var_7[sp]
FFF0DD32  590199                 loc_FFF0DD32 movu.b  0A0h+var_7[sp], r1
FFF0DD35  6161                              cmp     #6, r1
FFF0DD37  29ce                              blt.b   loc_FFF0DD05
FFF0DD39  2e4f                              bra.b   loc_FFF0DD88
FFF0DD3B  754360                 loc_FFF0DD3B mov.l   #60h, r3 ; '`'
FFF0DD3E  fb2298acf4ff                      mov.l   #(aEefcEe04NEeIPC+34h), r2; ""
FFF0DD44  710104                            add     #0A0h+var_9C, sp, r1
FFF0DD47  7f8f                              smovf
FFF0DD49  59019b                            movu.b  0A0h+var_5[sp], r1
FFF0DD4C  6141                              cmp     #4, r1
FFF0DD4E  1f                                bne.s   loc_FFF0DD55
FFF0DD4F  f9054f5a                          mov.w   #5Ah, 0A0h+var_2[sp] ; 'Z'
FFF0DD53  2e11                              bra.b   loc_FFF0DD64
FFF0DD55  59019b                 loc_FFF0DD55 movu.b  0A0h+var_5[sp], r1
FFF0DD58  6151                              cmp     #5, r1
FFF0DD5A  1e                                bne.s   loc_FFF0DD60
FFF0DD5B  f9054f53                          mov.w   #53h, 0A0h+var_2[sp] ; 'S'
FFF0DD5F  0d                                bra.s   loc_FFF0DD64
FFF0DD60  f9054f4c               loc_FFF0DD60 mov.w   #4Ch, 0A0h+var_2[sp] ; 'L'
FFF0DD64  59039b                 loc_FFF0DD64 movu.b  0A0h+var_5[sp], r3
FFF0DD67  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DD6A  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DD6D  60c0                              sub     #0Ch, sp
FFF0DD6F  6c43                              shll    #4, r3
FFF0DD71  710410                            add     #0ACh+var_9C, sp, r4
FFF0DD74  4b34                              add     r3, r4
FFF0DD76  a00c                              mov.l   r4, 0ACh+var_A8[sp]
FFF0DD78  3c0801                            mov.b   #1, 0ACh+var_A4[sp]
FFF0DD7B  f8040f                            mov.b   #0Fh, 0ACh+var_AC[sp]
FFF0DD7E  6604                              mov.l   #0, r4
FFF0DD80  66d3                              mov.l   #0Dh, r3
FFF0DD82  05a13dfe                          bsr.a   sub_FFEF1B23
FFF0DD86  62c0                              add     #0Ch, sp
FFF0DD88  59019a                 loc_FFF0DD88 movu.b  0A0h+var_6[sp], r1
FFF0DD8B  61b1                              cmp     #0Bh, r1
FFF0DD8D  2906                              blt.b   loc_FFF0DD93
FFF0DD8F  f9049a0a                          mov.b   #0Ah, 0A0h+var_6[sp]
FFF0DD93  f9054f4a               loc_FFF0DD93 mov.w   #4Ah, 0A0h+var_2[sp] ; 'J'
FFF0DD97  f9054e78                          mov.w   #78h, 0A0h+var_4[sp] ; 'x'
FFF0DD9B  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DD9E  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DDA1  6040                              sub     #4, sp
FFF0DDA3  f809ffff                          mov.w   #-1, 0A4h+var_A4[sp]
FFF0DDA7  6614                              mov.l   #1, r4
FFF0DDA9  7543ab                            mov.l   #-55h, r3
FFF0DDAC  059c3efe                          bsr.a   sub_FFEF1C48
FFF0DDB0  6240                              add     #4, sp
FFF0DDB2  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DDB5  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DDB8  6040                              sub     #4, sp
FFF0DDBA  f809ffff                          mov.w   #-1, 0A4h+var_A4[sp]
FFF0DDBE  62d2                              add     #0Dh, r2
FFF0DDC0  5f22                              movu.w  r2, r2
FFF0DDC2  6614                              mov.l   #1, r4
FFF0DDC4  7543ab                            mov.l   #-55h, r3
FFF0DDC7  05813efe                          bsr.a   sub_FFEF1C48
FFF0DDCB  6240                              add     #4, sp
FFF0DDCD  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DDD0  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DDD3  6040                              sub     #4, sp
FFF0DDD5  f809ffff                          mov.w   #-1, 0A4h+var_A4[sp]
FFF0DDD9  66d4                              mov.l   #0Dh, r4
FFF0DDDB  6613                              mov.l   #1, r3
FFF0DDDD  056b3efe                          bsr.a   sub_FFEF1C48
FFF0DDE1  6240                              add     #4, sp
FFF0DDE3  5d024e                            movu.w  0A0h+var_4[sp], r2
FFF0DDE6  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DDE9  6040                              sub     #4, sp
FFF0DDEB  f809ffff                          mov.w   #-1, 0A4h+var_A4[sp]
FFF0DDEF  7211ab00                          add     #0ABh, r1, r1
FFF0DDF3  5f11                              movu.w  r1, r1
FFF0DDF5  66d4                              mov.l   #0Dh, r4
FFF0DDF7  6613                              mov.l   #1, r3
FFF0DDF9  054f3efe                          bsr.a   sub_FFEF1C48
FFF0DDFD  6240                              add     #4, sp
FFF0DDFF  5d014e                            movu.w  0A0h+var_4[sp], r1
FFF0DE02  6221                              add     #2, r1
FFF0DE04  d7014e                            mov.w   r1, 0A0h+var_4[sp]
FFF0DE07  f9049900                          mov.b   #0, 0A0h+var_7[sp]
FFF0DE0B  2e41                              bra.b   loc_FFF0DE4C
FFF0DE0D  5d014f                 loc_FFF0DE0D movu.w  0A0h+var_2[sp], r1
FFF0DE10  6221                              add     #2, r1
FFF0DE12  d7014f                            mov.w   r1, 0A0h+var_2[sp]
FFF0DE15  f9049800                          mov.b   #0, 0A0h+var_8[sp]
FFF0DE19  2e24                              bra.b   loc_FFF0DE3D
FFF0DE1B  5d024e                 loc_FFF0DE1B movu.w  0A0h+var_4[sp], r2
FFF0DE1E  5d014f                            movu.w  0A0h+var_2[sp], r1
FFF0DE21  fb424c1fedff                      mov.l   #unk_FFED1F4C, r4
FFF0DE27  6613                              mov.l   #1, r3
FFF0DE29  05ac8afe                          bsr.a   sub_FFEF68D5
FFF0DE2D  dd014f                            mov.w   0A0h+var_2[sp], r1
FFF0DE30  6211                              add     #1, r1
FFF0DE32  d7014f                            mov.w   r1, 0A0h+var_2[sp]
FFF0DE35  590198                            movu.b  0A0h+var_8[sp], r1
FFF0DE38  6211                              add     #1, r1
FFF0DE3A  c70198                            mov.b   r1, 0A0h+var_8[sp]
FFF0DE3D  590198                 loc_FFF0DE3D movu.b  0A0h+var_8[sp], r1
FFF0DE40  61f1                              cmp     #0Fh, r1
FFF0DE42  29d9                              blt.b   loc_FFF0DE1B
FFF0DE44  590199                            movu.b  0A0h+var_7[sp], r1
FFF0DE47  6211                              add     #1, r1
FFF0DE49  c70199                            mov.b   r1, 0A0h+var_7[sp]
FFF0DE4C  590199                 loc_FFF0DE4C movu.b  0A0h+var_7[sp], r1
FFF0DE4F  45019a                            cmp     0A0h+var_6[sp], r1
FFF0DE52  29bb                              blt.b   loc_FFF0DE0D
FFF0DE54  6728                   loc_FFF0DE54 rtsd    #28h
FFF0DE56  7100b4                 sub_FFF0DE56 add     #-4Ch, sp, sp   ; <<<< FUNC sub_FFF0DE56
FFF0DE59  754316                            mov.l   #16h, r3
FFF0DE5C  fb22f8acf4ff                      mov.l   #aDspWriteMode, r2; "---DSP WRITE MODE----"
FFF0DE62  710136                            add     #4Ch+var_16, sp, r1
FFF0DE65  7f8f                              smovf
FFF0DE67  66f3                              mov.l   #0Fh, r3
FFF0DE69  fb220eadf4ff                      mov.l   #aPushDispKey, r2; "Push DISP Key!"
FFF0DE6F  710127                            add     #4Ch+var_25, sp, r1
FFF0DE72  7f8f                              smovf
FFF0DE74  66b3                              mov.l   #0Bh, r3
FFF0DE76  fb221dadf4ff                      mov.l   #aLoading, r2; "Loading..."
FFF0DE7C  71011c                            add     #4Ch+var_30, sp, r1
FFF0DE7F  7f8f                              smovf
FFF0DE81  3c8b00                            mov.b   #0, 4Ch+var_31[sp]
FFF0DE84  710117                            add     #4Ch+var_35, sp, r1
FFF0DE87  f8126c657465                      mov.l   #6574656Ch, [r1]
FFF0DE8D  710113                            add     #4Ch+var_39, sp, r1
FFF0DE90  f812436f6d70                      mov.l   #706D6F43h, [r1]
FFF0DE96  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0DE9C  c5e02011                          mov.b   20h[r14], 4Ch+var_3B[sp]
FFF0DEA0  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0DEA6  c5e02110                          mov.b   21h[r14], 4Ch+var_3C[sp]
FFF0DEAA  3d030e                            mov.w   #0Eh, 4Ch+var_46[sp]
FFF0DEAD  3d0220                            mov.w   #20h, 4Ch+var_48[sp] ; ' '
FFF0DEB0  7544f0                            mov.l   #-10h, r4
FFF0DEB3  fb3a4001                          mov.l   #140h, r3
FFF0DEB7  6601                              mov.l   #0, r1
FFF0DEB9  ef12                              mov.l   r1, r2
FFF0DEBB  053c26fe                          bsr.a   sub_FFEF04F7
FFF0DEBF  3d070d                            mov.w   #0Dh, 4Ch+var_3E[sp]
FFF0DEC2  3d063a                            mov.w   #3Ah, 4Ch+var_40[sp] ; ':'
FFF0DEC5  b982                              movu.w  4Ch+var_40[sp], r2
FFF0DEC7  b989                              movu.w  4Ch+var_3E[sp], r1
FFF0DEC9  60c0                              sub     #0Ch, sp
FFF0DECB  710342                            add     #58h+var_16, sp, r3
FFF0DECE  a00b                              mov.l   r3, 58h+var_54[sp]
FFF0DED0  3c0801                            mov.b   #1, 58h+var_50[sp]
FFF0DED3  f80415                            mov.b   #15h, 58h+var_58[sp]
FFF0DED6  6604                              mov.l   #0, r4
FFF0DED8  66d3                              mov.l   #0Dh, r3
FFF0DEDA  05493cfe                          bsr.a   sub_FFEF1B23
FFF0DEDE  62c0                              add     #0Ch, sp
FFF0DEE0  b889                              movu.w  4Ch+var_46[sp], r1
FFF0DEE2  6331                              mul     #3, r1
FFF0DEE4  9109                              mov.w   r1, 4Ch+var_42[sp]
FFF0DEE6  d5000204                          mov.w   4Ch+var_48[sp], 4Ch+var_44[sp]
FFF0DEEA  b409                              movu.b  4Ch+var_3B[sp], r1
FFF0DEEC  6101                              cmp     #0, r1
FFF0DEEE  2160                              bne.b   loc_FFF0DF4E
FFF0DEF0  b981                              movu.w  4Ch+var_40[sp], r1
FFF0DEF2  06c90104                          add     4Ch+var_44[sp].uw, r1
FFF0DEF6  b98b                              movu.w  4Ch+var_3E[sp], r3
FFF0DEF8  06c90305                          add     4Ch+var_42[sp].uw, r3
FFF0DEFC  60c0                              sub     #0Ch, sp
FFF0DEFE  710233                            add     #58h+var_25, sp, r2
FFF0DF01  a00a                              mov.l   r2, 58h+var_54[sp]
FFF0DF03  3c0801                            mov.b   #1, 58h+var_50[sp]
FFF0DF06  f8040e                            mov.b   #0Eh, 58h+var_58[sp]
FFF0DF09  5f12                              movu.w  r1, r2
FFF0DF0B  5f31                              movu.w  r3, r1
FFF0DF0D  6604                              mov.l   #0, r4
FFF0DF0F  66d3                              mov.l   #0Dh, r3
FFF0DF11  05123cfe                          bsr.a   sub_FFEF1B23
FFF0DF15  62c0                              add     #0Ch, sp
FFF0DF17  b901                              movu.w  4Ch+var_44[sp], r1
FFF0DF19  06c90102                          add     4Ch+var_48[sp].uw, r1
FFF0DF1D  9101                              mov.w   r1, 4Ch+var_44[sp]
FFF0DF1F  b981                              movu.w  4Ch+var_40[sp], r1
FFF0DF21  06c90104                          add     4Ch+var_44[sp].uw, r1
FFF0DF25  b98b                              movu.w  4Ch+var_3E[sp], r3
FFF0DF27  06c90305                          add     4Ch+var_42[sp].uw, r3
FFF0DF2B  60c0                              sub     #0Ch, sp
FFF0DF2D  710228                            add     #58h+var_30, sp, r2
FFF0DF30  a00a                              mov.l   r2, 58h+var_54[sp]
FFF0DF32  f90905ef7b                        mov.w   #7BEFh, 58h+var_4E[sp]
FFF0DF37  3c0801                            mov.b   #1, 58h+var_50[sp]
FFF0DF3A  f8040a                            mov.b   #0Ah, 58h+var_58[sp]
FFF0DF3D  5f12                              movu.w  r1, r2
FFF0DF3F  5f31                              movu.w  r3, r1
FFF0DF41  6604                              mov.l   #0, r4
FFF0DF43  66d3                              mov.l   #0Dh, r3
FFF0DF45  056c3cfe                          bsr.a   sub_FFEF1BB1
FFF0DF49  62c0                              add     #0Ch, sp
FFF0DF4B  38c700                            bra.w   loc_FFF0E012
FFF0DF4E  b409                   loc_FFF0DF4E movu.b  4Ch+var_3B[sp], r1
FFF0DF50  6111                              cmp     #1, r1
FFF0DF52  215f                              bne.b   loc_FFF0DFB1
FFF0DF54  b981                              movu.w  4Ch+var_40[sp], r1
FFF0DF56  06c90104                          add     4Ch+var_44[sp].uw, r1
FFF0DF5A  b98b                              movu.w  4Ch+var_3E[sp], r3
FFF0DF5C  06c90305                          add     4Ch+var_42[sp].uw, r3
FFF0DF60  60c0                              sub     #0Ch, sp
FFF0DF62  710233                            add     #58h+var_25, sp, r2
FFF0DF65  a00a                              mov.l   r2, 58h+var_54[sp]
FFF0DF67  f90905ef7b                        mov.w   #7BEFh, 58h+var_4E[sp]
FFF0DF6C  3c0801                            mov.b   #1, 58h+var_50[sp]
FFF0DF6F  f8040e                            mov.b   #0Eh, 58h+var_58[sp]
FFF0DF72  5f12                              movu.w  r1, r2
FFF0DF74  5f31                              movu.w  r3, r1
FFF0DF76  6604                              mov.l   #0, r4
FFF0DF78  66d3                              mov.l   #0Dh, r3
FFF0DF7A  05373cfe                          bsr.a   sub_FFEF1BB1
FFF0DF7E  62c0                              add     #0Ch, sp
FFF0DF80  b901                              movu.w  4Ch+var_44[sp], r1
FFF0DF82  06c90102                          add     4Ch+var_48[sp].uw, r1
FFF0DF86  9101                              mov.w   r1, 4Ch+var_44[sp]
FFF0DF88  b981                              movu.w  4Ch+var_40[sp], r1
FFF0DF8A  06c90104                          add     4Ch+var_44[sp].uw, r1
FFF0DF8E  b98b                              movu.w  4Ch+var_3E[sp], r3
FFF0DF90  06c90305                          add     4Ch+var_42[sp].uw, r3
FFF0DF94  60c0                              sub     #0Ch, sp
FFF0DF96  710228                            add     #58h+var_30, sp, r2
FFF0DF99  a00a                              mov.l   r2, 58h+var_54[sp]
FFF0DF9B  3c0801                            mov.b   #1, 58h+var_50[sp]
FFF0DF9E  f8040a                            mov.b   #0Ah, 58h+var_58[sp]
FFF0DFA1  5f12                              movu.w  r1, r2
FFF0DFA3  5f31                              movu.w  r3, r1
FFF0DFA5  6604                              mov.l   #0, r4
FFF0DFA7  66d3                              mov.l   #0Dh, r3
FFF0DFA9  057a3bfe                          bsr.a   sub_FFEF1B23
FFF0DFAD  62c0                              add     #0Ch, sp
FFF0DFAF  2e63                              bra.b   loc_FFF0E012
FFF0DFB1  b409                   loc_FFF0DFB1 movu.b  4Ch+var_3B[sp], r1
FFF0DFB3  6121                              cmp     #2, r1
FFF0DFB5  215d                              bne.b   loc_FFF0E012
FFF0DFB7  b981                              movu.w  4Ch+var_40[sp], r1
FFF0DFB9  06c90104                          add     4Ch+var_44[sp].uw, r1
FFF0DFBD  b98b                              movu.w  4Ch+var_3E[sp], r3
FFF0DFBF  06c90305                          add     4Ch+var_42[sp].uw, r3
FFF0DFC3  60c0                              sub     #0Ch, sp
FFF0DFC5  710233                            add     #58h+var_25, sp, r2
FFF0DFC8  a00a                              mov.l   r2, 58h+var_54[sp]
FFF0DFCA  f90905ef7b                        mov.w   #7BEFh, 58h+var_4E[sp]
FFF0DFCF  3c0801                            mov.b   #1, 58h+var_50[sp]
FFF0DFD2  f8040e                            mov.b   #0Eh, 58h+var_58[sp]
FFF0DFD5  5f12                              movu.w  r1, r2
FFF0DFD7  5f31                              movu.w  r3, r1
FFF0DFD9  6604                              mov.l   #0, r4
FFF0DFDB  66d3                              mov.l   #0Dh, r3
FFF0DFDD  05d43bfe                          bsr.a   sub_FFEF1BB1
FFF0DFE1  62c0                              add     #0Ch, sp
FFF0DFE3  b901                              movu.w  4Ch+var_44[sp], r1
FFF0DFE5  06c90102                          add     4Ch+var_48[sp].uw, r1
FFF0DFE9  9101                              mov.w   r1, 4Ch+var_44[sp]
FFF0DFEB  b981                              movu.w  4Ch+var_40[sp], r1
FFF0DFED  06c90104                          add     4Ch+var_44[sp].uw, r1
FFF0DFF1  b98b                              movu.w  4Ch+var_3E[sp], r3
FFF0DFF3  06c90305                          add     4Ch+var_42[sp].uw, r3
FFF0DFF7  60c0                              sub     #0Ch, sp
FFF0DFF9  71021f                            add     #58h+var_39, sp, r2
FFF0DFFC  a00a                              mov.l   r2, 58h+var_54[sp]
FFF0DFFE  3c0801                            mov.b   #1, 58h+var_50[sp]
FFF0E001  f80408                            mov.b   #8, 58h+var_58[sp]
FFF0E004  5f12                              movu.w  r1, r2
FFF0E006  5f31                              movu.w  r3, r1
FFF0E008  6604                              mov.l   #0, r4
FFF0E00A  66d3                              mov.l   #0Dh, r3
FFF0E00C  05173bfe                          bsr.a   sub_FFEF1B23
FFF0E010  62c0                              add     #0Ch, sp
FFF0E012  b409                   loc_FFF0E012 movu.b  4Ch+var_3B[sp], r1
FFF0E014  6121                              cmp     #2, r1
FFF0E016  17                                beq.s   loc_FFF0E01D
FFF0E017  b401                              movu.b  4Ch+var_3C[sp], r1
FFF0E019  61b1                              cmp     #0Bh, r1
FFF0E01B  2906                              blt.b   loc_FFF0E021
FFF0E01D  f80601                 loc_FFF0E01D mov.l   #1, 4Ch+var_4C[sp]
FFF0E020  0c                                bra.s   loc_FFF0E024
FFF0E021  f80600                 loc_FFF0E021 mov.l   #0, 4Ch+var_4C[sp]
FFF0E024  ec01                   loc_FFF0E024 mov.l   4Ch+var_4C[sp], r1
FFF0E026  6101                              cmp     #0, r1
FFF0E028  14                                beq.s   loc_FFF0E02C
FFF0E029  3c800a                            mov.b   #0Ah, 4Ch+var_3C[sp]
FFF0E02C  b409                   loc_FFF0E02C movu.b  4Ch+var_3B[sp], r1
FFF0E02E  6101                              cmp     #0, r1
FFF0E030  210c                              bne.b   loc_FFF0E03C
FFF0E032  b401                              movu.b  4Ch+var_3C[sp], r1
FFF0E034  6101                              cmp     #0, r1
FFF0E036  2b06                              ble.b   loc_FFF0E03C
FFF0E038  f80601                            mov.l   #1, 4Ch+var_4C[sp]
FFF0E03B  0c                                bra.s   loc_FFF0E03F
FFF0E03C  f80600                 loc_FFF0E03C mov.l   #0, 4Ch+var_4C[sp]
FFF0E03F  ec01                   loc_FFF0E03F mov.l   4Ch+var_4C[sp], r1
FFF0E041  6101                              cmp     #0, r1
FFF0E043  14                                beq.s   loc_FFF0E047
FFF0E044  3c8000                            mov.b   #0, 4Ch+var_3C[sp]
FFF0E047  b409                   loc_FFF0E047 movu.b  4Ch+var_3B[sp], r1
FFF0E049  6111                              cmp     #1, r1
FFF0E04B  210c                              bne.b   loc_FFF0E057
FFF0E04D  b401                              movu.b  4Ch+var_3C[sp], r1
FFF0E04F  61a1                              cmp     #0Ah, r1
FFF0E051  2906                              blt.b   loc_FFF0E057
FFF0E053  f80601                            mov.l   #1, 4Ch+var_4C[sp]
FFF0E056  0c                                bra.s   loc_FFF0E05A
FFF0E057  f80600                 loc_FFF0E057 mov.l   #0, 4Ch+var_4C[sp]
FFF0E05A  ec01                   loc_FFF0E05A mov.l   4Ch+var_4C[sp], r1
FFF0E05C  6101                              cmp     #0, r1
FFF0E05E  14                                beq.s   loc_FFF0E062
FFF0E05F  3c8009                            mov.b   #9, 4Ch+var_3C[sp]
FFF0E062  b409                   loc_FFF0E062 movu.b  4Ch+var_3B[sp], r1
FFF0E064  6111                              cmp     #1, r1
FFF0E066  1a                                bne.s   loc_FFF0E070
FFF0E067  b401                              movu.b  4Ch+var_3C[sp], r1
FFF0E069  6101                              cmp     #0, r1
FFF0E06B  1d                                bne.s   loc_FFF0E070
FFF0E06C  f80601                            mov.l   #1, 4Ch+var_4C[sp]
FFF0E06F  0c                                bra.s   loc_FFF0E073
FFF0E070  f80600                 loc_FFF0E070 mov.l   #0, 4Ch+var_4C[sp]
FFF0E073  ec01                   loc_FFF0E073 mov.l   4Ch+var_4C[sp], r1
FFF0E075  6101                              cmp     #0, r1
FFF0E077  14                                beq.s   loc_FFF0E07B
FFF0E078  3c8001                            mov.b   #1, 4Ch+var_3C[sp]
FFF0E07B  3d074a                 loc_FFF0E07B mov.w   #4Ah, 4Ch+var_3E[sp] ; 'J'
FFF0E07E  3d06a1                            mov.w   #-5Fh, 4Ch+var_40[sp]
FFF0E081  b982                              movu.w  4Ch+var_40[sp], r2
FFF0E083  b989                              movu.w  4Ch+var_3E[sp], r1
FFF0E085  6040                              sub     #4, sp
FFF0E087  f809ffff                          mov.w   #-1, 50h+var_50[sp]
FFF0E08B  6614                              mov.l   #1, r4
FFF0E08D  7543ab                            mov.l   #-55h, r3
FFF0E090  05b83bfe                          bsr.a   sub_FFEF1C48
FFF0E094  6240                              add     #4, sp
FFF0E096  b982                              movu.w  4Ch+var_40[sp], r2
FFF0E098  b989                              movu.w  4Ch+var_3E[sp], r1
FFF0E09A  6040                              sub     #4, sp
FFF0E09C  f809ffff                          mov.w   #-1, 50h+var_50[sp]
FFF0E0A0  62d2                              add     #0Dh, r2
FFF0E0A2  5f22                              movu.w  r2, r2
FFF0E0A4  6614                              mov.l   #1, r4
FFF0E0A6  7543ab                            mov.l   #-55h, r3
FFF0E0A9  059f3bfe                          bsr.a   sub_FFEF1C48
FFF0E0AD  6240                              add     #4, sp
FFF0E0AF  b982                              movu.w  4Ch+var_40[sp], r2
FFF0E0B1  b989                              movu.w  4Ch+var_3E[sp], r1
FFF0E0B3  6040                              sub     #4, sp
FFF0E0B5  f809ffff                          mov.w   #-1, 50h+var_50[sp]
FFF0E0B9  66d4                              mov.l   #0Dh, r4
FFF0E0BB  6613                              mov.l   #1, r3
FFF0E0BD  058b3bfe                          bsr.a   sub_FFEF1C48
FFF0E0C1  6240                              add     #4, sp
FFF0E0C3  b982                              movu.w  4Ch+var_40[sp], r2
FFF0E0C5  b989                              movu.w  4Ch+var_3E[sp], r1
FFF0E0C7  6040                              sub     #4, sp
FFF0E0C9  f809ffff                          mov.w   #-1, 50h+var_50[sp]
FFF0E0CD  7211ab00                          add     #0ABh, r1, r1
FFF0E0D1  5f11                              movu.w  r1, r1
FFF0E0D3  66d4                              mov.l   #0Dh, r4
FFF0E0D5  6613                              mov.l   #1, r3
FFF0E0D7  05713bfe                          bsr.a   sub_FFEF1C48
FFF0E0DB  6240                              add     #4, sp
FFF0E0DD  b989                              movu.w  4Ch+var_3E[sp], r1
FFF0E0DF  6221                              add     #2, r1
FFF0E0E1  9189                              mov.w   r1, 4Ch+var_3E[sp]
FFF0E0E3  b981                              movu.w  4Ch+var_40[sp], r1
FFF0E0E5  6221                              add     #2, r1
FFF0E0E7  9181                              mov.w   r1, 4Ch+var_40[sp]
FFF0E0E9  3c8200                            mov.b   #0, 4Ch+var_3A[sp]
FFF0E0EC  2e23                              bra.b   loc_FFF0E10F
FFF0E0EE  b982                   loc_FFF0E0EE movu.w  4Ch+var_40[sp], r2
FFF0E0F0  b989                              movu.w  4Ch+var_3E[sp], r1
FFF0E0F2  6040                              sub     #4, sp
FFF0E0F4  f809ff03                          mov.w   #3FFh, 50h+var_50[sp]
FFF0E0F8  66a4                              mov.l   #0Ah, r4
FFF0E0FA  66f3                              mov.l   #0Fh, r3
FFF0E0FC  054c3bfe                          bsr.a   sub_FFEF1C48
FFF0E100  6240                              add     #4, sp
FFF0E102  b989                              movu.w  4Ch+var_3E[sp], r1
FFF0E104  711111                            add     #11h, r1, r1
FFF0E107  9189                              mov.w   r1, 4Ch+var_3E[sp]
FFF0E109  b481                              movu.b  4Ch+var_3A[sp], r1
FFF0E10B  6211                              add     #1, r1
FFF0E10D  8481                              mov.b   r1, 4Ch+var_3A[sp]
FFF0E10F  b481                   loc_FFF0E10F movu.b  4Ch+var_3A[sp], r1
FFF0E111  450110                            cmp     4Ch+var_3C[sp], r1
FFF0E114  29da                              blt.b   loc_FFF0E0EE
FFF0E116  6713                              rtsd    #13h
FFF0E118  60c0                   sub_FFF0E118 sub     #0Ch, sp   ; <<<< FUNC sub_FFF0E118
FFF0E11A  3d0302                            mov.w   #2, 0Ch+var_6[sp]
FFF0E11D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0E123  c5e02005                          mov.b   20h[r14], 0Ch+var_7[sp]
FFF0E127  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0E12D  c5e02104                          mov.b   21h[r14], 0Ch+var_8[sp]
FFF0E131  7544f0                            mov.l   #-10h, r4
FFF0E134  fb3a4001                          mov.l   #140h, r3
FFF0E138  6601                              mov.l   #0, r1
FFF0E13A  ef12                              mov.l   r1, r2
FFF0E13C  05bb23fe                          bsr.a   sub_FFEF04F7
FFF0E140  b109                              movu.b  0Ch+var_7[sp], r1
FFF0E142  6141                              cmp     #4, r1
FFF0E144  2b05                              ble.b   loc_FFF0E149
FFF0E146  384a02                            bra.w   loc_FFF0E390
FFF0E149  3d0439                 loc_FFF0E149 mov.w   #39h, 0Ch+var_4[sp] ; '9'
FFF0E14C  b109                              movu.b  0Ch+var_7[sp], r1
FFF0E14E  6141                              cmp     #4, r1
FFF0E150  3a1801                            beq.w   loc_FFF0E268
FFF0E153  6111                              cmp     #1, r1
FFF0E155  202f                              beq.b   loc_FFF0E184
FFF0E157  6121                              cmp     #2, r1
FFF0E159  2065                              beq.b   loc_FFF0E1BE
FFF0E15B  6131                              cmp     #3, r1
FFF0E15D  3ad100                            beq.w   loc_FFF0E22E
FFF0E160  6101                              cmp     #0, r1
FFF0E162  3b8e01                            bne.w   loc_FFF0E2F0
FFF0E165  b101                              movu.b  0Ch+var_8[sp], r1
FFF0E167  6101                              cmp     #0, r1
FFF0E169  2b05                              ble.b   loc_FFF0E16E
FFF0E16B  3c0400                            mov.b   #0, 0Ch+var_8[sp]
FFF0E16E  3d056b                 loc_FFF0E16E mov.w   #6Bh, 0Ch+var_2[sp] ; 'k'
FFF0E171  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E173  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E175  fb425cfdecff                      mov.l   #unk_FFECFD5C, r4
FFF0E17B  6613                              mov.l   #1, r3
FFF0E17D  055887fe                          bsr.a   sub_FFEF68D5
FFF0E181  386f01                            bra.w   loc_FFF0E2F0
FFF0E184  b101                   loc_FFF0E184 movu.b  0Ch+var_8[sp], r1
FFF0E186  61b1                              cmp     #0Bh, r1
FFF0E188  2905                              blt.b   loc_FFF0E18D
FFF0E18A  3c040a                            mov.b   #0Ah, 0Ch+var_8[sp]
FFF0E18D  3d058b                 loc_FFF0E18D mov.w   #-75h, 0Ch+var_2[sp]
FFF0E190  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E192  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E194  fb423c00edff                      mov.l   #unk_FFED003C, r4
FFF0E19A  6613                              mov.l   #1, r3
FFF0E19C  053987fe                          bsr.a   sub_FFEF68D5
FFF0E1A0  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E1A2  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E1A6  711114                            add     #14h, r1, r1
FFF0E1A9  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E1AB  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E1AD  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E1AF  fb42bc00edff                      mov.l   #unk_FFED00BC, r4
FFF0E1B5  6613                              mov.l   #1, r3
FFF0E1B7  051e87fe                          bsr.a   sub_FFEF68D5
FFF0E1BB  383501                            bra.w   loc_FFF0E2F0
FFF0E1BE  b101                   loc_FFF0E1BE movu.b  0Ch+var_8[sp], r1
FFF0E1C0  61b1                              cmp     #0Bh, r1
FFF0E1C2  2905                              blt.b   loc_FFF0E1C7
FFF0E1C4  3c040a                            mov.b   #0Ah, 0Ch+var_8[sp]
FFF0E1C7  3d0575                 loc_FFF0E1C7 mov.w   #75h, 0Ch+var_2[sp] ; 'u'
FFF0E1CA  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E1CC  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E1CE  fb429c00edff                      mov.l   #unk_FFED009C, r4
FFF0E1D4  6613                              mov.l   #1, r3
FFF0E1D6  05ff86fe                          bsr.a   sub_FFEF68D5
FFF0E1DA  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E1DC  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E1E0  711114                            add     #14h, r1, r1
FFF0E1E3  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E1E5  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E1E7  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E1E9  fb42dcfdecff                      mov.l   #unk_FFECFDDC, r4
FFF0E1EF  6613                              mov.l   #1, r3
FFF0E1F1  05e486fe                          bsr.a   sub_FFEF68D5
FFF0E1F5  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E1F7  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E1FB  711114                            add     #14h, r1, r1
FFF0E1FE  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E200  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E202  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E204  fb42dcfeecff                      mov.l   #unk_FFECFEDC, r4
FFF0E20A  6613                              mov.l   #1, r3
FFF0E20C  05c986fe                          bsr.a   sub_FFEF68D5
FFF0E210  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E212  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E216  711114                            add     #14h, r1, r1
FFF0E219  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E21B  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E21D  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E21F  fb423c00edff                      mov.l   #unk_FFED003C, r4
FFF0E225  6613                              mov.l   #1, r3
FFF0E227  05ae86fe                          bsr.a   sub_FFEF68D5
FFF0E22B  38c500                            bra.w   loc_FFF0E2F0
FFF0E22E  b101                   loc_FFF0E22E movu.b  0Ch+var_8[sp], r1
FFF0E230  61b1                              cmp     #0Bh, r1
FFF0E232  2905                              blt.b   loc_FFF0E237
FFF0E234  3c040a                            mov.b   #0Ah, 0Ch+var_8[sp]
FFF0E237  3d058b                 loc_FFF0E237 mov.w   #-75h, 0Ch+var_2[sp]
FFF0E23A  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E23C  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E23E  fb42fcffecff                      mov.l   #unk_FFECFFFC, r4
FFF0E244  6613                              mov.l   #1, r3
FFF0E246  058f86fe                          bsr.a   sub_FFEF68D5
FFF0E24A  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E24C  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E250  711114                            add     #14h, r1, r1
FFF0E253  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E255  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E257  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E259  fb42bc00edff                      mov.l   #unk_FFED00BC, r4
FFF0E25F  6613                              mov.l   #1, r3
FFF0E261  057486fe                          bsr.a   sub_FFEF68D5
FFF0E265  388b00                            bra.w   loc_FFF0E2F0
FFF0E268  b101                   loc_FFF0E268 movu.b  0Ch+var_8[sp], r1
FFF0E26A  6101                              cmp     #0, r1
FFF0E26C  2b05                              ble.b   loc_FFF0E271
FFF0E26E  3c0400                            mov.b   #0, 0Ch+var_8[sp]
FFF0E271  3d056a                 loc_FFF0E271 mov.w   #6Ah, 0Ch+var_2[sp] ; 'j'
FFF0E274  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E276  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E278  fb425cfeecff                      mov.l   #unk_FFECFE5C, r4
FFF0E27E  6613                              mov.l   #1, r3
FFF0E280  055586fe                          bsr.a   sub_FFEF68D5
FFF0E284  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E286  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E28A  711114                            add     #14h, r1, r1
FFF0E28D  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E28F  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E291  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E293  fb42fcffecff                      mov.l   #unk_FFECFFFC, r4
FFF0E299  6613                              mov.l   #1, r3
FFF0E29B  053a86fe                          bsr.a   sub_FFEF68D5
FFF0E29F  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E2A1  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E2A5  711114                            add     #14h, r1, r1
FFF0E2A8  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E2AA  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E2AC  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E2AE  fb42fcffecff                      mov.l   #unk_FFECFFFC, r4
FFF0E2B4  6613                              mov.l   #1, r3
FFF0E2B6  051f86fe                          bsr.a   sub_FFEF68D5
FFF0E2BA  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E2BC  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E2C0  711114                            add     #14h, r1, r1
FFF0E2C3  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E2C5  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E2C7  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E2C9  fb429cffecff                      mov.l   #unk_FFECFF9C, r4
FFF0E2CF  6613                              mov.l   #1, r3
FFF0E2D1  050486fe                          bsr.a   sub_FFEF68D5
FFF0E2D5  b889                              movu.w  0Ch+var_6[sp], r1
FFF0E2D7  06c90105                          add     0Ch+var_2[sp].uw, r1
FFF0E2DB  711114                            add     #14h, r1, r1
FFF0E2DE  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E2E0  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E2E2  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E2E4  fb42fcffecff                      mov.l   #unk_FFECFFFC, r4
FFF0E2EA  6613                              mov.l   #1, r3
FFF0E2EC  05e985fe                          bsr.a   sub_FFEF68D5
FFF0E2F0  b101                   loc_FFF0E2F0 movu.b  0Ch+var_8[sp], r1
FFF0E2F2  61b1                              cmp     #0Bh, r1
FFF0E2F4  2905                              blt.b   loc_FFF0E2F9
FFF0E2F6  3c040a                            mov.b   #0Ah, 0Ch+var_8[sp]
FFF0E2F9  3d054a                 loc_FFF0E2F9 mov.w   #4Ah, 0Ch+var_2[sp] ; 'J'
FFF0E2FC  3d0461                            mov.w   #61h, 0Ch+var_4[sp] ; 'a'
FFF0E2FF  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E301  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E303  6040                              sub     #4, sp
FFF0E305  f809ffff                          mov.w   #-1, 10h+var_10[sp]
FFF0E309  6614                              mov.l   #1, r4
FFF0E30B  7543ac                            mov.l   #-54h, r3
FFF0E30E  053a39fe                          bsr.a   sub_FFEF1C48
FFF0E312  6240                              add     #4, sp
FFF0E314  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E316  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E318  6040                              sub     #4, sp
FFF0E31A  f809ffff                          mov.w   #-1, 10h+var_10[sp]
FFF0E31E  62d2                              add     #0Dh, r2
FFF0E320  5f22                              movu.w  r2, r2
FFF0E322  6614                              mov.l   #1, r4
FFF0E324  7543ac                            mov.l   #-54h, r3
FFF0E327  052139fe                          bsr.a   sub_FFEF1C48
FFF0E32B  6240                              add     #4, sp
FFF0E32D  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E32F  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E331  6040                              sub     #4, sp
FFF0E333  f809ffff                          mov.w   #-1, 10h+var_10[sp]
FFF0E337  66e4                              mov.l   #0Eh, r4
FFF0E339  6613                              mov.l   #1, r3
FFF0E33B  050d39fe                          bsr.a   sub_FFEF1C48
FFF0E33F  6240                              add     #4, sp
FFF0E341  b902                              movu.w  0Ch+var_4[sp], r2
FFF0E343  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E345  6040                              sub     #4, sp
FFF0E347  f809ffff                          mov.w   #-1, 10h+var_10[sp]
FFF0E34B  7211ab00                          add     #0ABh, r1, r1
FFF0E34F  5f11                              movu.w  r1, r1
FFF0E351  66e4                              mov.l   #0Eh, r4
FFF0E353  6613                              mov.l   #1, r3
FFF0E355  05f338fe                          bsr.a   sub_FFEF1C48
FFF0E359  6240                              add     #4, sp
FFF0E35B  3c0300                            mov.b   #0, 0Ch+var_9[sp]
FFF0E35E  2e2b                              bra.b   loc_FFF0E389
FFF0E360  b901                   loc_FFF0E360 movu.w  0Ch+var_4[sp], r1
FFF0E362  b90b                              movu.w  0Ch+var_2[sp], r3
FFF0E364  6040                              sub     #4, sp
FFF0E366  f809ff03                          mov.w   #3FFh, 10h+var_10[sp]
FFF0E36A  6221                              add     #2, r1
FFF0E36C  5f12                              movu.w  r1, r2
FFF0E36E  6223                              add     #2, r3
FFF0E370  5f31                              movu.w  r3, r1
FFF0E372  66a4                              mov.l   #0Ah, r4
FFF0E374  66f3                              mov.l   #0Fh, r3
FFF0E376  05d238fe                          bsr.a   sub_FFEF1C48
FFF0E37A  6240                              add     #4, sp
FFF0E37C  b909                              movu.w  0Ch+var_2[sp], r1
FFF0E37E  711111                            add     #11h, r1, r1
FFF0E381  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF0E383  b089                              movu.b  0Ch+var_9[sp], r1
FFF0E385  6211                              add     #1, r1
FFF0E387  8089                              mov.b   r1, 0Ch+var_9[sp]
FFF0E389  b089                   loc_FFF0E389 movu.b  0Ch+var_9[sp], r1
FFF0E38B  450104                            cmp     0Ch+var_8[sp], r1
FFF0E38E  29d2                              blt.b   loc_FFF0E360
FFF0E390  6703                   loc_FFF0E390 rtsd    #3
FFF0E392  6080                   sub_FFF0E392 sub     #8, sp   ; <<<< FUNC sub_FFF0E392
FFF0E394  3d025a                            mov.w   #5Ah, 8+var_4[sp] ; 'Z'
FFF0E397  3d0102                            mov.w   #2, 8+var_6[sp]
FFF0E39A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0E3A0  c5e02001                          mov.b   20h[r14], 8+var_7[sp]
FFF0E3A4  7544f0                            mov.l   #-10h, r4
FFF0E3A7  fb3a4001                          mov.l   #140h, r3
FFF0E3AB  6601                              mov.l   #0, r1
FFF0E3AD  ef12                              mov.l   r1, r2
FFF0E3AF  054821fe                          bsr.a   sub_FFEF04F7
FFF0E3B3  b009                              movu.b  8+var_7[sp], r1
FFF0E3B5  6101                              cmp     #0, r1
FFF0E3B7  3bf200                            bne.w   loc_FFF0E4A9
FFF0E3BA  3d0333                            mov.w   #33h, 8+var_2[sp] ; '3'
FFF0E3BD  b882                              movu.w  8+var_4[sp], r2
FFF0E3BF  b889                              movu.w  8+var_2[sp], r1
FFF0E3C1  fb42dcfdecff                      mov.l   #unk_FFECFDDC, r4
FFF0E3C7  6613                              mov.l   #1, r3
FFF0E3C9  050c85fe                          bsr.a   sub_FFEF68D5
FFF0E3CD  b809                              movu.w  8+var_6[sp], r1
FFF0E3CF  06c90103                          add     8+var_2[sp].uw, r1
FFF0E3D3  711114                            add     #14h, r1, r1
FFF0E3D6  9089                              mov.w   r1, 8+var_2[sp]
FFF0E3D8  b882                              movu.w  8+var_4[sp], r2
FFF0E3DA  b889                              movu.w  8+var_2[sp], r1
FFF0E3DC  fb423cffecff                      mov.l   #unk_FFECFF3C, r4
FFF0E3E2  6613                              mov.l   #1, r3
FFF0E3E4  05f184fe                          bsr.a   sub_FFEF68D5
FFF0E3E8  b809                              movu.w  8+var_6[sp], r1
FFF0E3EA  06c90103                          add     8+var_2[sp].uw, r1
FFF0E3EE  711114                            add     #14h, r1, r1
FFF0E3F1  9089                              mov.w   r1, 8+var_2[sp]
FFF0E3F3  b882                              movu.w  8+var_4[sp], r2
FFF0E3F5  b889                              movu.w  8+var_2[sp], r1
FFF0E3F7  fb423cffecff                      mov.l   #unk_FFECFF3C, r4
FFF0E3FD  6613                              mov.l   #1, r3
FFF0E3FF  05d684fe                          bsr.a   sub_FFEF68D5
FFF0E403  b809                              movu.w  8+var_6[sp], r1
FFF0E405  6c11                              shll    #1, r1
FFF0E407  06c90103                          add     8+var_2[sp].uw, r1
FFF0E40B  711128                            add     #28h, r1, r1 ; '('
FFF0E40E  9089                              mov.w   r1, 8+var_2[sp]
FFF0E410  b882                              movu.w  8+var_4[sp], r2
FFF0E412  b889                              movu.w  8+var_2[sp], r1
FFF0E414  fb42fcffecff                      mov.l   #unk_FFECFFFC, r4
FFF0E41A  6613                              mov.l   #1, r3
FFF0E41C  05b984fe                          bsr.a   sub_FFEF68D5
FFF0E420  b809                              movu.w  8+var_6[sp], r1
FFF0E422  06c90103                          add     8+var_2[sp].uw, r1
FFF0E426  711114                            add     #14h, r1, r1
FFF0E429  9089                              mov.w   r1, 8+var_2[sp]
FFF0E42B  b882                              movu.w  8+var_4[sp], r2
FFF0E42D  b889                              movu.w  8+var_2[sp], r1
FFF0E42F  fb425cfeecff                      mov.l   #unk_FFECFE5C, r4
FFF0E435  6613                              mov.l   #1, r3
FFF0E437  059e84fe                          bsr.a   sub_FFEF68D5
FFF0E43B  b809                              movu.w  8+var_6[sp], r1
FFF0E43D  06c90103                          add     8+var_2[sp].uw, r1
FFF0E441  711114                            add     #14h, r1, r1
FFF0E444  9089                              mov.w   r1, 8+var_2[sp]
FFF0E446  b882                              movu.w  8+var_4[sp], r2
FFF0E448  b889                              movu.w  8+var_2[sp], r1
FFF0E44A  fb421c00edff                      mov.l   #unk_FFED001C, r4
FFF0E450  6613                              mov.l   #1, r3
FFF0E452  058384fe                          bsr.a   sub_FFEF68D5
FFF0E456  b809                              movu.w  8+var_6[sp], r1
FFF0E458  06c90103                          add     8+var_2[sp].uw, r1
FFF0E45C  711114                            add     #14h, r1, r1
FFF0E45F  9089                              mov.w   r1, 8+var_2[sp]
FFF0E461  b882                              movu.w  8+var_4[sp], r2
FFF0E463  b889                              movu.w  8+var_2[sp], r1
FFF0E465  fb425cfeecff                      mov.l   #unk_FFECFE5C, r4
FFF0E46B  6613                              mov.l   #1, r3
FFF0E46D  056884fe                          bsr.a   sub_FFEF68D5
FFF0E471  b809                              movu.w  8+var_6[sp], r1
FFF0E473  06c90103                          add     8+var_2[sp].uw, r1
FFF0E477  711114                            add     #14h, r1, r1
FFF0E47A  9089                              mov.w   r1, 8+var_2[sp]
FFF0E47C  b882                              movu.w  8+var_4[sp], r2
FFF0E47E  b889                              movu.w  8+var_2[sp], r1
FFF0E480  fb423c00edff                      mov.l   #unk_FFED003C, r4
FFF0E486  6613                              mov.l   #1, r3
FFF0E488  054d84fe                          bsr.a   sub_FFEF68D5
FFF0E48C  b809                              movu.w  8+var_6[sp], r1
FFF0E48E  06c90103                          add     8+var_2[sp].uw, r1
FFF0E492  711114                            add     #14h, r1, r1
FFF0E495  9089                              mov.w   r1, 8+var_2[sp]
FFF0E497  b882                              movu.w  8+var_4[sp], r2
FFF0E499  b889                              movu.w  8+var_2[sp], r1
FFF0E49B  fb423c01edff                      mov.l   #unk_FFED013C, r4
FFF0E4A1  6613                              mov.l   #1, r3
FFF0E4A3  053284fe                          bsr.a   sub_FFEF68D5
FFF0E4A7  6702                              rtsd    #2
FFF0E4A9  b009                   loc_FFF0E4A9 movu.b  8+var_7[sp], r1
FFF0E4AB  6111                              cmp     #1, r1
FFF0E4AD  3b6801                            bne.w   loc_FFF0E615
FFF0E4B0  3d0308                            mov.w   #8, 8+var_2[sp]
FFF0E4B3  b882                              movu.w  8+var_4[sp], r2
FFF0E4B5  b889                              movu.w  8+var_2[sp], r1
FFF0E4B7  fb421c00edff                      mov.l   #unk_FFED001C, r4
FFF0E4BD  6613                              mov.l   #1, r3
FFF0E4BF  051684fe                          bsr.a   sub_FFEF68D5
FFF0E4C3  b809                              movu.w  8+var_6[sp], r1
FFF0E4C5  06c90103                          add     8+var_2[sp].uw, r1
FFF0E4C9  711114                            add     #14h, r1, r1
FFF0E4CC  9089                              mov.w   r1, 8+var_2[sp]
FFF0E4CE  b882                              movu.w  8+var_4[sp], r2
FFF0E4D0  b889                              movu.w  8+var_2[sp], r1
FFF0E4D2  fb425cfeecff                      mov.l   #unk_FFECFE5C, r4
FFF0E4D8  6613                              mov.l   #1, r3
FFF0E4DA  05fb83fe                          bsr.a   sub_FFEF68D5
FFF0E4DE  b809                              movu.w  8+var_6[sp], r1
FFF0E4E0  06c90103                          add     8+var_2[sp].uw, r1
FFF0E4E4  711114                            add     #14h, r1, r1
FFF0E4E7  9089                              mov.w   r1, 8+var_2[sp]
FFF0E4E9  b882                              movu.w  8+var_4[sp], r2
FFF0E4EB  b889                              movu.w  8+var_2[sp], r1
FFF0E4ED  fb423c00edff                      mov.l   #unk_FFED003C, r4
FFF0E4F3  6613                              mov.l   #1, r3
FFF0E4F5  05e083fe                          bsr.a   sub_FFEF68D5
FFF0E4F9  b809                              movu.w  8+var_6[sp], r1
FFF0E4FB  06c90103                          add     8+var_2[sp].uw, r1
FFF0E4FF  711114                            add     #14h, r1, r1
FFF0E502  9089                              mov.w   r1, 8+var_2[sp]
FFF0E504  b889                              movu.w  8+var_2[sp], r1
FFF0E506  62a1                              add     #0Ah, r1
FFF0E508  9089                              mov.w   r1, 8+var_2[sp]
FFF0E50A  b882                              movu.w  8+var_4[sp], r2
FFF0E50C  b889                              movu.w  8+var_2[sp], r1
FFF0E50E  fb425cffecff                      mov.l   #unk_FFECFF5C, r4
FFF0E514  6613                              mov.l   #1, r3
FFF0E516  05bf83fe                          bsr.a   sub_FFEF68D5
FFF0E51A  b809                              movu.w  8+var_6[sp], r1
FFF0E51C  06c90103                          add     8+var_2[sp].uw, r1
FFF0E520  711114                            add     #14h, r1, r1
FFF0E523  9089                              mov.w   r1, 8+var_2[sp]
FFF0E525  b882                              movu.w  8+var_4[sp], r2
FFF0E527  b889                              movu.w  8+var_2[sp], r1
FFF0E529  fb429cffecff                      mov.l   #unk_FFECFF9C, r4
FFF0E52F  6613                              mov.l   #1, r3
FFF0E531  05a483fe                          bsr.a   sub_FFEF68D5
FFF0E535  b809                              movu.w  8+var_6[sp], r1
FFF0E537  06c90103                          add     8+var_2[sp].uw, r1
FFF0E53B  711114                            add     #14h, r1, r1
FFF0E53E  9089                              mov.w   r1, 8+var_2[sp]
FFF0E540  b882                              movu.w  8+var_4[sp], r2
FFF0E542  b889                              movu.w  8+var_2[sp], r1
FFF0E544  fb423cfeecff                      mov.l   #unk_FFECFE3C, r4
FFF0E54A  6613                              mov.l   #1, r3
FFF0E54C  058983fe                          bsr.a   sub_FFEF68D5
FFF0E550  b809                              movu.w  8+var_6[sp], r1
FFF0E552  06c90103                          add     8+var_2[sp].uw, r1
FFF0E556  711114                            add     #14h, r1, r1
FFF0E559  9089                              mov.w   r1, 8+var_2[sp]
FFF0E55B  b882                              movu.w  8+var_4[sp], r2
FFF0E55D  b889                              movu.w  8+var_2[sp], r1
FFF0E55F  fb425cfeecff                      mov.l   #unk_FFECFE5C, r4
FFF0E565  6613                              mov.l   #1, r3
FFF0E567  056e83fe                          bsr.a   sub_FFEF68D5
FFF0E56B  b809                              movu.w  8+var_6[sp], r1
FFF0E56D  06c90103                          add     8+var_2[sp].uw, r1
FFF0E571  711114                            add     #14h, r1, r1
FFF0E574  9089                              mov.w   r1, 8+var_2[sp]
FFF0E576  b889                              movu.w  8+var_2[sp], r1
FFF0E578  62a1                              add     #0Ah, r1
FFF0E57A  9089                              mov.w   r1, 8+var_2[sp]
FFF0E57C  b882                              movu.w  8+var_4[sp], r2
FFF0E57E  b889                              movu.w  8+var_2[sp], r1
FFF0E580  fb42fcffecff                      mov.l   #unk_FFECFFFC, r4
FFF0E586  6613                              mov.l   #1, r3
FFF0E588  054d83fe                          bsr.a   sub_FFEF68D5
FFF0E58C  b809                              movu.w  8+var_6[sp], r1
FFF0E58E  06c90103                          add     8+var_2[sp].uw, r1
FFF0E592  711114                            add     #14h, r1, r1
FFF0E595  9089                              mov.w   r1, 8+var_2[sp]
FFF0E597  b882                              movu.w  8+var_4[sp], r2
FFF0E599  b889                              movu.w  8+var_2[sp], r1
FFF0E59B  fb425cfeecff                      mov.l   #unk_FFECFE5C, r4
FFF0E5A1  6613                              mov.l   #1, r3
FFF0E5A3  053283fe                          bsr.a   sub_FFEF68D5
FFF0E5A7  b809                              movu.w  8+var_6[sp], r1
FFF0E5A9  06c90103                          add     8+var_2[sp].uw, r1
FFF0E5AD  711114                            add     #14h, r1, r1
FFF0E5B0  9089                              mov.w   r1, 8+var_2[sp]
FFF0E5B2  b882                              movu.w  8+var_4[sp], r2
FFF0E5B4  b889                              movu.w  8+var_2[sp], r1
FFF0E5B6  fb421c00edff                      mov.l   #unk_FFED001C, r4
FFF0E5BC  6613                              mov.l   #1, r3
FFF0E5BE  051783fe                          bsr.a   sub_FFEF68D5
FFF0E5C2  b809                              movu.w  8+var_6[sp], r1
FFF0E5C4  06c90103                          add     8+var_2[sp].uw, r1
FFF0E5C8  711114                            add     #14h, r1, r1
FFF0E5CB  9089                              mov.w   r1, 8+var_2[sp]
FFF0E5CD  b882                              movu.w  8+var_4[sp], r2
FFF0E5CF  b889                              movu.w  8+var_2[sp], r1
FFF0E5D1  fb425cfeecff                      mov.l   #unk_FFECFE5C, r4
FFF0E5D7  6613                              mov.l   #1, r3
FFF0E5D9  05fc82fe                          bsr.a   sub_FFEF68D5
FFF0E5DD  b809                              movu.w  8+var_6[sp], r1
FFF0E5DF  06c90103                          add     8+var_2[sp].uw, r1
FFF0E5E3  711114                            add     #14h, r1, r1
FFF0E5E6  9089                              mov.w   r1, 8+var_2[sp]
FFF0E5E8  b882                              movu.w  8+var_4[sp], r2
FFF0E5EA  b889                              movu.w  8+var_2[sp], r1
FFF0E5EC  fb423c00edff                      mov.l   #unk_FFED003C, r4
FFF0E5F2  6613                              mov.l   #1, r3
FFF0E5F4  05e182fe                          bsr.a   sub_FFEF68D5
FFF0E5F8  b809                              movu.w  8+var_6[sp], r1
FFF0E5FA  06c90103                          add     8+var_2[sp].uw, r1
FFF0E5FE  711114                            add     #14h, r1, r1
FFF0E601  9089                              mov.w   r1, 8+var_2[sp]
FFF0E603  b882                              movu.w  8+var_4[sp], r2
FFF0E605  b889                              movu.w  8+var_2[sp], r1
FFF0E607  fb423c01edff                      mov.l   #unk_FFED013C, r4
FFF0E60D  6613                              mov.l   #1, r3
FFF0E60F  05c682fe                          bsr.a   sub_FFEF68D5
FFF0E613  6702                              rtsd    #2
FFF0E615  6702                   loc_FFF0E615 rtsd    #2
FFF0E617  7100e4                 sub_FFF0E617 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF0E617
FFF0E61A  3d0d05                            mov.w   #5, 1Ch+var_2[sp]
FFF0E61D  3d0c00                            mov.w   #0, 1Ch+var_4[sp]
FFF0E620  3d0b01                            mov.w   #1, 1Ch+var_6[sp]
FFF0E623  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0E629  c5e02015                          mov.b   20h[r14], 1Ch+var_7[sp]
FFF0E62D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0E633  c5e02114                          mov.b   21h[r14], 1Ch+var_8[sp]
FFF0E637  7544f0                            mov.l   #-10h, r4
FFF0E63A  fb3a4001                          mov.l   #140h, r3
FFF0E63E  6601                              mov.l   #0, r1
FFF0E640  ef12                              mov.l   r1, r2
FFF0E642  05b51efe                          bsr.a   sub_FFEF04F7
FFF0E646  3c8300                            mov.b   #0, 1Ch+var_9[sp]
FFF0E649  2e34                              bra.b   loc_FFF0E67D
FFF0E64B  fbe220930600           loc_FFF0E64B mov.l   #69320h, r14
FFF0E651  b489                              movu.b  1Ch+var_9[sp], r1
FFF0E653  fe61e4                            mov.l   [r1, r14], r4
FFF0E656  bb02                              movu.w  1Ch+var_4[sp], r2
FFF0E658  bb09                              movu.w  1Ch+var_2[sp], r1
FFF0E65A  6613                              mov.l   #1, r3
FFF0E65C  057982fe                          bsr.a   sub_FFEF68D5
FFF0E660  fbe220930600                      mov.l   #69320h, r14
FFF0E666  b489                              movu.b  1Ch+var_9[sp], r1
FFF0E668  fe61ee                            mov.l   [r1, r14], r14
FFF0E66B  5ce1                              movu.w  [r14], r1
FFF0E66D  06c9010b                          add     1Ch+var_6[sp].uw, r1
FFF0E671  06c9010d                          add     1Ch+var_2[sp].uw, r1
FFF0E675  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF0E677  b489                              movu.b  1Ch+var_9[sp], r1
FFF0E679  6211                              add     #1, r1
FFF0E67B  8489                              mov.b   r1, 1Ch+var_9[sp]
FFF0E67D  b489                   loc_FFF0E67D movu.b  1Ch+var_9[sp], r1
FFF0E67F  6141                              cmp     #4, r1
FFF0E681  29ca                              blt.b   loc_FFF0E64B
FFF0E683  3d0dbe                            mov.w   #-42h, 1Ch+var_2[sp]
FFF0E686  3c8300                            mov.b   #0, 1Ch+var_9[sp]
FFF0E689  2e44                              bra.b   loc_FFF0E6CD
FFF0E68B  fbe230930600           loc_FFF0E68B mov.l   #69330h, r14
FFF0E691  b489                              movu.b  1Ch+var_9[sp], r1
FFF0E693  fe61e4                            mov.l   [r1, r14], r4
FFF0E696  bb02                              movu.w  1Ch+var_4[sp], r2
FFF0E698  bb09                              movu.w  1Ch+var_2[sp], r1
FFF0E69A  6613                              mov.l   #1, r3
FFF0E69C  053982fe                          bsr.a   sub_FFEF68D5
FFF0E6A0  fbe230930600                      mov.l   #69330h, r14
FFF0E6A6  b489                              movu.b  1Ch+var_9[sp], r1
FFF0E6A8  fe61ee                            mov.l   [r1, r14], r14
FFF0E6AB  5ce1                              movu.w  [r14], r1
FFF0E6AD  06c9010b                          add     1Ch+var_6[sp].uw, r1
FFF0E6B1  06c9010d                          add     1Ch+var_2[sp].uw, r1
FFF0E6B5  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF0E6B7  b489                              movu.b  1Ch+var_9[sp], r1
FFF0E6B9  6141                              cmp     #4, r1
FFF0E6BB  210c                              bne.b   loc_FFF0E6C7
FFF0E6BD  ba89                              movu.w  1Ch+var_6[sp], r1
FFF0E6BF  06c9010d                          add     1Ch+var_2[sp].uw, r1
FFF0E6C3  62c1                              add     #0Ch, r1
FFF0E6C5  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF0E6C7  b489                   loc_FFF0E6C7 movu.b  1Ch+var_9[sp], r1
FFF0E6C9  6211                              add     #1, r1
FFF0E6CB  8489                              mov.b   r1, 1Ch+var_9[sp]
FFF0E6CD  b489                   loc_FFF0E6CD movu.b  1Ch+var_9[sp], r1
FFF0E6CF  6181                              cmp     #8, r1
FFF0E6D1  29ba                              blt.b   loc_FFF0E68B
FFF0E6D3  66b3                              mov.l   #0Bh, r3
FFF0E6D5  fb2231adf4ff                      mov.l   #aType, r2; "TYPE    : "
FFF0E6DB  710108                            add     #1Ch+var_14, sp, r1
FFF0E6DE  7f8f                              smovf
FFF0E6E0  fbe23cadf4ff                      mov.l   #unk_FFF4AD3C, r14
FFF0E6E6  c4e003                            mov.b   [r14], 1Ch+var_19[sp]
FFF0E6E9  c5e00104                          mov.b   1[r14], 1Ch+var_18[sp]
FFF0E6ED  c5e00205                          mov.b   2[r14], 1Ch+var_17[sp]
FFF0E6F1  c5e00306                          mov.b   3[r14], 1Ch+var_16[sp]
FFF0E6F5  c5e00407                          mov.b   4[r14], 1Ch+var_15[sp]
FFF0E6F9  3d0d14                            mov.w   #14h, 1Ch+var_2[sp]
FFF0E6FC  3d0c64                            mov.w   #64h, 1Ch+var_4[sp] ; 'd'
FFF0E6FF  bb02                              movu.w  1Ch+var_4[sp], r2
FFF0E701  bb09                              movu.w  1Ch+var_2[sp], r1
FFF0E703  60c0                              sub     #0Ch, sp
FFF0E705  710314                            add     #28h+var_14, sp, r3
FFF0E708  a00b                              mov.l   r3, 28h+var_24[sp]
FFF0E70A  3c0801                            mov.b   #1, 28h+var_20[sp]
FFF0E70D  f8040a                            mov.b   #0Ah, 28h+var_28[sp]
FFF0E710  6604                              mov.l   #0, r4
FFF0E712  66d3                              mov.l   #0Dh, r3
FFF0E714  050f34fe                          bsr.a   sub_FFEF1B23
FFF0E718  62c0                              add     #0Ch, sp
FFF0E71A  bb09                              movu.w  1Ch+var_2[sp], r1
FFF0E71C  72118c00                          add     #8Ch, r1, r1
FFF0E720  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF0E722  bb02                              movu.w  1Ch+var_4[sp], r2
FFF0E724  bb09                              movu.w  1Ch+var_2[sp], r1
FFF0E726  fb42ccfdecff                      mov.l   #unk_FFECFDCC, r4
FFF0E72C  6613                              mov.l   #1, r3
FFF0E72E  05a781fe                          bsr.a   sub_FFEF68D5
FFF0E732  fbe2ccfdecff                      mov.l   #unk_FFECFDCC, r14
FFF0E738  5ce1                              movu.w  [r14], r1
FFF0E73A  06c9010d                          add     1Ch+var_2[sp].uw, r1
FFF0E73E  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF0E740  b509                              movu.b  1Ch+var_7[sp], r1
FFF0E742  6151                              cmp     #5, r1
FFF0E744  2a42                              bgt.b   loc_FFF0E786
FFF0E746  b501                              movu.b  1Ch+var_8[sp], r1
FFF0E748  6131                              cmp     #3, r1
FFF0E74A  2905                              blt.b   loc_FFF0E74F
FFF0E74C  3c8402                            mov.b   #2, 1Ch+var_8[sp]
FFF0E74F  b509                   loc_FFF0E74F movu.b  1Ch+var_7[sp], r1
FFF0E751  fbe28a220100                      mov.l   #1228Ah, r14
FFF0E757  fece11                            movu.b  [r14, r1], r1
FFF0E75A  8089                              mov.b   r1, 1Ch+var_19[sp]
FFF0E75C  b501                              movu.b  1Ch+var_8[sp], r1
FFF0E75E  fbe290220100                      mov.l   #12290h, r14
FFF0E764  fece11                            movu.b  [r14, r1], r1
FFF0E767  8101                              mov.b   r1, 1Ch+var_18[sp]
FFF0E769  bb02                              movu.w  1Ch+var_4[sp], r2
FFF0E76B  bb09                              movu.w  1Ch+var_2[sp], r1
FFF0E76D  60c0                              sub     #0Ch, sp
FFF0E76F  71030f                            add     #28h+var_19, sp, r3
FFF0E772  a00b                              mov.l   r3, 28h+var_24[sp]
FFF0E774  3c0801                            mov.b   #1, 28h+var_20[sp]
FFF0E777  f80402                            mov.b   #2, 28h+var_28[sp]
FFF0E77A  6604                              mov.l   #0, r4
FFF0E77C  66d3                              mov.l   #0Dh, r3
FFF0E77E  05a533fe                          bsr.a   sub_FFEF1B23
FFF0E782  62c0                              add     #0Ch, sp
FFF0E784  6707                              rtsd    #7
FFF0E786  b509                   loc_FFF0E786 movu.b  1Ch+var_7[sp], r1
FFF0E788  6161                              cmp     #6, r1
FFF0E78A  2128                              bne.b   loc_FFF0E7B2
FFF0E78C  3c052a                            mov.b   #2Ah, 1Ch+var_17[sp] ; '*'
FFF0E78F  3c042a                            mov.b   #2Ah, 1Ch+var_18[sp] ; '*'
FFF0E792  3c032a                            mov.b   #2Ah, 1Ch+var_19[sp] ; '*'
FFF0E795  bb02                              movu.w  1Ch+var_4[sp], r2
FFF0E797  bb09                              movu.w  1Ch+var_2[sp], r1
FFF0E799  60c0                              sub     #0Ch, sp
FFF0E79B  71030f                            add     #28h+var_19, sp, r3
FFF0E79E  a00b                              mov.l   r3, 28h+var_24[sp]
FFF0E7A0  3c0801                            mov.b   #1, 28h+var_20[sp]
FFF0E7A3  f80403                            mov.b   #3, 28h+var_28[sp]
FFF0E7A6  6604                              mov.l   #0, r4
FFF0E7A8  66d3                              mov.l   #0Dh, r3
FFF0E7AA  057933fe                          bsr.a   sub_FFEF1B23
FFF0E7AE  62c0                              add     #0Ch, sp
FFF0E7B0  6707                              rtsd    #7
FFF0E7B2  b509                   loc_FFF0E7B2 movu.b  1Ch+var_7[sp], r1
FFF0E7B4  6171                              cmp     #7, r1
FFF0E7B6  2128                              bne.b   loc_FFF0E7DE
FFF0E7B8  3c0348                            mov.b   #48h, 1Ch+var_19[sp] ; 'H'
FFF0E7BB  3c0441                            mov.b   #41h, 1Ch+var_18[sp] ; 'A'
FFF0E7BE  3c054d                            mov.b   #4Dh, 1Ch+var_17[sp] ; 'M'
FFF0E7C1  bb02                              movu.w  1Ch+var_4[sp], r2
FFF0E7C3  bb09                              movu.w  1Ch+var_2[sp], r1
FFF0E7C5  60c0                              sub     #0Ch, sp
FFF0E7C7  71030f                            add     #28h+var_19, sp, r3
FFF0E7CA  a00b                              mov.l   r3, 28h+var_24[sp]
FFF0E7CC  3c0801                            mov.b   #1, 28h+var_20[sp]
FFF0E7CF  f80403                            mov.b   #3, 28h+var_28[sp]
FFF0E7D2  6604                              mov.l   #0, r4
FFF0E7D4  66d3                              mov.l   #0Dh, r3
FFF0E7D6  054d33fe                          bsr.a   sub_FFEF1B23
FFF0E7DA  62c0                              add     #0Ch, sp
FFF0E7DC  6707                              rtsd    #7
FFF0E7DE  6707                   loc_FFF0E7DE rtsd    #7
FFF0E7E0  fbe24c8c0000           sub_FFF0E7E0 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF0E7E0
FFF0E7E6  58ee                              movu.b  [r14], r14
FFF0E7E8  613e                              cmp     #3, r14
FFF0E7EA  2a16                              bgt.b   loc_FFF0E800
FFF0E7EC  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0E7F2  58ee                              movu.b  [r14], r14
FFF0E7F4  fbf2f077edff                      mov.l   #off_FFED77F0, r15
FFF0E7FA  fe6efe                            mov.l   [r14, r15], r14
FFF0E7FD  7f1e                              jsr     r14
FFF0E7FF  02                                rts
FFF0E800  fbe24c8c0000           loc_FFF0E800 mov.l   #8C4Ch, r14
FFF0E806  f8e403                            mov.b   #3, [r14]
FFF0E809  02                                rts
FFF0E80A  6611                   sub_FFF0E80A mov.l   #1, r1   ; <<<< FUNC sub_FFF0E80A
FFF0E80C  396f02                            bsr.w   sub_FFF0EA7B
FFF0E80F  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0E815  58ef                              movu.b  [r14], r15
FFF0E817  621f                              add     #1, r15
FFF0E819  c3ef                              mov.b   r15, [r14]
FFF0E81B  02                                rts
FFF0E81C  6080                   sub_FFF0E81C sub     #8, sp   ; <<<< FUNC sub_FFF0E81C
FFF0E81E  050f1bfe                          bsr.a   sub_FFEF032D
FFF0E822  053cbffe                          bsr.a   sub_FFEFA75E
FFF0E826  3d0206                            mov.w   #6, 8+var_4[sp]
FFF0E829  3d0100                            mov.w   #0, 8+var_6[sp]
FFF0E82C  3d034c                            mov.w   #4Ch, 8+var_2[sp] ; 'L'
FFF0E82F  3c0100                            mov.b   #0, 8+var_7[sp]
FFF0E832  2e51                              bra.b   loc_FFF0E883
FFF0E834  fbe250930600           loc_FFF0E834 mov.l   #69350h, r14
FFF0E83A  b009                              movu.b  8+var_7[sp], r1
FFF0E83C  fe61e4                            mov.l   [r1, r14], r4
FFF0E83F  b882                              movu.w  8+var_4[sp], r2
FFF0E841  b889                              movu.w  8+var_2[sp], r1
FFF0E843  6613                              mov.l   #1, r3
FFF0E845  059080fe                          bsr.a   sub_FFEF68D5
FFF0E849  fbe250930600                      mov.l   #69350h, r14
FFF0E84F  b009                              movu.b  8+var_7[sp], r1
FFF0E851  fe61ee                            mov.l   [r1, r14], r14
FFF0E854  5ce1                              movu.w  [r14], r1
FFF0E856  06c90101                          add     8+var_6[sp].uw, r1
FFF0E85A  06c90103                          add     8+var_2[sp].uw, r1
FFF0E85E  9089                              mov.w   r1, 8+var_2[sp]
FFF0E860  b009                              movu.b  8+var_7[sp], r1
FFF0E862  6141                              cmp     #4, r1
FFF0E864  2119                              bne.b   loc_FFF0E87D
FFF0E866  fbe250930600                      mov.l   #69350h, r14
FFF0E86C  b009                              movu.b  8+var_7[sp], r1
FFF0E86E  fe61ee                            mov.l   [r1, r14], r14
FFF0E871  5ce1                              movu.w  [r14], r1
FFF0E873  06c90101                          add     8+var_6[sp].uw, r1
FFF0E877  06c90103                          add     8+var_2[sp].uw, r1
FFF0E87B  9089                              mov.w   r1, 8+var_2[sp]
FFF0E87D  b009                   loc_FFF0E87D movu.b  8+var_7[sp], r1
FFF0E87F  6211                              add     #1, r1
FFF0E881  8009                              mov.b   r1, 8+var_7[sp]
FFF0E883  b009                   loc_FFF0E883 movu.b  8+var_7[sp], r1
FFF0E885  61d1                              cmp     #0Dh, r1
FFF0E887  29ad                              blt.b   loc_FFF0E834
FFF0E889  3d023c                            mov.w   #3Ch, 8+var_4[sp] ; '<'
FFF0E88C  3c0100                            mov.b   #0, 8+var_7[sp]
FFF0E88F  2e17                              bra.b   loc_FFF0E8A6
FFF0E891  b881                   loc_FFF0E891 movu.w  8+var_4[sp], r1
FFF0E893  6602                              mov.l   #0, r2
FFF0E895  05d91600                          bsr.a   sub_FFF0FF6E
FFF0E899  b881                              movu.w  8+var_4[sp], r1
FFF0E89B  71111e                            add     #1Eh, r1, r1
FFF0E89E  9081                              mov.w   r1, 8+var_4[sp]
FFF0E8A0  b009                              movu.b  8+var_7[sp], r1
FFF0E8A2  6211                              add     #1, r1
FFF0E8A4  8009                              mov.b   r1, 8+var_7[sp]
FFF0E8A6  b009                   loc_FFF0E8A6 movu.b  8+var_7[sp], r1
FFF0E8A8  6151                              cmp     #5, r1
FFF0E8AA  29e7                              blt.b   loc_FFF0E891
FFF0E8AC  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0E8B2  58ef                              movu.b  [r14], r15
FFF0E8B4  621f                              add     #1, r15
FFF0E8B6  c3ef                              mov.b   r15, [r14]
FFF0E8B8  6702                              rtsd    #2
FFF0E8BA  6040                   sub_FFF0E8BA sub     #4, sp   ; <<<< FUNC sub_FFF0E8BA
FFF0E8BC  6040                              sub     #4, sp
FFF0E8BE  3d00f0                            mov.w   #-10h, [sp]
FFF0E8C1  fb4a4001                          mov.l   #140h, r4
FFF0E8C5  6602                              mov.l   #0, r2
FFF0E8C7  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0E8CD  ef23                              mov.l   r2, r3
FFF0E8CF  05ec10fe                          bsr.a   sub_FFEEF9BB
FFF0E8D3  6240                              add     #4, sp
FFF0E8D5  8089                              mov.b   r1, 4+var_1[sp]
FFF0E8D7  b089                              movu.b  4+var_1[sp], r1
FFF0E8D9  6111                              cmp     #1, r1
FFF0E8DB  1a                                bne.s   loc_FFF0E8E5
FFF0E8DC  397702                            bsr.w   sub_FFF0EB53
FFF0E8DF  05901afe                          bsr.a   sub_FFEF036F
FFF0E8E3  6701                              rtsd    #1
FFF0E8E5  6701                   loc_FFF0E8E5 rtsd    #1
FFF0E8E7  6040                   sub_FFF0E8E7 sub     #4, sp   ; <<<< FUNC sub_FFF0E8E7
FFF0E8E9  6040                              sub     #4, sp
FFF0E8EB  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF0E8EE  fb4a4001                          mov.l   #140h, r4
FFF0E8F2  75431e                            mov.l   #1Eh, r3
FFF0E8F5  6602                              mov.l   #0, r2
FFF0E8F7  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0E8FD  05be10fe                          bsr.a   sub_FFEEF9BB
FFF0E901  6240                              add     #4, sp
FFF0E903  8089                              mov.b   r1, 4+var_1[sp]
FFF0E905  b089                              movu.b  4+var_1[sp], r1
FFF0E907  6111                              cmp     #1, r1
FFF0E909  2112                              bne.b   loc_FFF0E91B
FFF0E90B  75421e                            mov.l   #1Eh, r2
FFF0E90E  6601                              mov.l   #0, r1
FFF0E910  ef13                              mov.l   r1, r3
FFF0E912  397802                            bsr.w   sub_FFF0EB8A
FFF0E915  055a1afe                          bsr.a   sub_FFEF036F
FFF0E919  6701                              rtsd    #1
FFF0E91B  6701                   loc_FFF0E91B rtsd    #1
FFF0E91D  6040                   sub_FFF0E91D sub     #4, sp   ; <<<< FUNC sub_FFF0E91D
FFF0E91F  6040                              sub     #4, sp
FFF0E921  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF0E924  fb4a4001                          mov.l   #140h, r4
FFF0E928  75433c                            mov.l   #3Ch, r3 ; '<'
FFF0E92B  6602                              mov.l   #0, r2
FFF0E92D  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0E933  058810fe                          bsr.a   sub_FFEEF9BB
FFF0E937  6240                              add     #4, sp
FFF0E939  8089                              mov.b   r1, 4+var_1[sp]
FFF0E93B  b089                              movu.b  4+var_1[sp], r1
FFF0E93D  6111                              cmp     #1, r1
FFF0E93F  2112                              bne.b   loc_FFF0E951
FFF0E941  6613                              mov.l   #1, r3
FFF0E943  75423c                            mov.l   #3Ch, r2 ; '<'
FFF0E946  6601                              mov.l   #0, r1
FFF0E948  394202                            bsr.w   sub_FFF0EB8A
FFF0E94B  05241afe                          bsr.a   sub_FFEF036F
FFF0E94F  6701                              rtsd    #1
FFF0E951  6701                   loc_FFF0E951 rtsd    #1
FFF0E953  6040                   sub_FFF0E953 sub     #4, sp   ; <<<< FUNC sub_FFF0E953
FFF0E955  6040                              sub     #4, sp
FFF0E957  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF0E95A  fb4a4001                          mov.l   #140h, r4
FFF0E95E  75435a                            mov.l   #5Ah, r3 ; 'Z'
FFF0E961  6602                              mov.l   #0, r2
FFF0E963  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0E969  055210fe                          bsr.a   sub_FFEEF9BB
FFF0E96D  6240                              add     #4, sp
FFF0E96F  8089                              mov.b   r1, 4+var_1[sp]
FFF0E971  b089                              movu.b  4+var_1[sp], r1
FFF0E973  6111                              cmp     #1, r1
FFF0E975  2112                              bne.b   loc_FFF0E987
FFF0E977  6623                              mov.l   #2, r3
FFF0E979  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF0E97C  6601                              mov.l   #0, r1
FFF0E97E  390c02                            bsr.w   sub_FFF0EB8A
FFF0E981  05ee19fe                          bsr.a   sub_FFEF036F
FFF0E985  6701                              rtsd    #1
FFF0E987  6701                   loc_FFF0E987 rtsd    #1
FFF0E989  6040                   sub_FFF0E989 sub     #4, sp   ; <<<< FUNC sub_FFF0E989
FFF0E98B  6040                              sub     #4, sp
FFF0E98D  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF0E990  fb4a4001                          mov.l   #140h, r4
FFF0E994  754378                            mov.l   #78h, r3 ; 'x'
FFF0E997  6602                              mov.l   #0, r2
FFF0E999  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0E99F  051c10fe                          bsr.a   sub_FFEEF9BB
FFF0E9A3  6240                              add     #4, sp
FFF0E9A5  8089                              mov.b   r1, 4+var_1[sp]
FFF0E9A7  b089                              movu.b  4+var_1[sp], r1
FFF0E9A9  6111                              cmp     #1, r1
FFF0E9AB  2112                              bne.b   loc_FFF0E9BD
FFF0E9AD  6633                              mov.l   #3, r3
FFF0E9AF  754278                            mov.l   #78h, r2 ; 'x'
FFF0E9B2  6601                              mov.l   #0, r1
FFF0E9B4  39d601                            bsr.w   sub_FFF0EB8A
FFF0E9B7  05b819fe                          bsr.a   sub_FFEF036F
FFF0E9BB  6701                              rtsd    #1
FFF0E9BD  6701                   loc_FFF0E9BD rtsd    #1
FFF0E9BF  6040                   sub_FFF0E9BF sub     #4, sp   ; <<<< FUNC sub_FFF0E9BF
FFF0E9C1  6040                              sub     #4, sp
FFF0E9C3  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF0E9C6  fb4a4001                          mov.l   #140h, r4
FFF0E9CA  754396                            mov.l   #-6Ah, r3
FFF0E9CD  6602                              mov.l   #0, r2
FFF0E9CF  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0E9D5  05e60ffe                          bsr.a   sub_FFEEF9BB
FFF0E9D9  6240                              add     #4, sp
FFF0E9DB  8089                              mov.b   r1, 4+var_1[sp]
FFF0E9DD  b089                              movu.b  4+var_1[sp], r1
FFF0E9DF  6111                              cmp     #1, r1
FFF0E9E1  2112                              bne.b   loc_FFF0E9F3
FFF0E9E3  6643                              mov.l   #4, r3
FFF0E9E5  754296                            mov.l   #-6Ah, r2
FFF0E9E8  6601                              mov.l   #0, r1
FFF0E9EA  39a001                            bsr.w   sub_FFF0EB8A
FFF0E9ED  058219fe                          bsr.a   sub_FFEF036F
FFF0E9F1  6701                              rtsd    #1
FFF0E9F3  6701                   loc_FFF0E9F3 rtsd    #1
FFF0E9F5  6040                   sub_FFF0E9F5 sub     #4, sp   ; <<<< FUNC sub_FFF0E9F5
FFF0E9F7  054816fe                          bsr.a   sub_FFEF003F
FFF0E9FB  fbe2738f0000                      mov.l   #8F73h, r14
FFF0EA01  c3e1                              mov.b   r1, [r14]
FFF0EA03  fbe2738f0000                      mov.l   #8F73h, r14
FFF0EA09  58ee                              movu.b  [r14], r14
FFF0EA0B  755eff                            cmp     #-1, r14
FFF0EA0E  1e                                bne.s   loc_FFF0EA14
FFF0EA0F  6601                              mov.l   #0, r1
FFF0EA11  396a00                            bsr.w   sub_FFF0EA7B
FFF0EA14  fbe2738f0000           loc_FFF0EA14 mov.l   #8F73h, r14
FFF0EA1A  58ee                              movu.b  [r14], r14
FFF0EA1C  755eff                            cmp     #-1, r14
FFF0EA1F  2013                              beq.b   loc_FFF0EA32
FFF0EA21  fbe2738f0000                      mov.l   #8F73h, r14
FFF0EA27  58ee                              movu.b  [r14], r14
FFF0EA29  755e13                            cmp     #13h, r14
FFF0EA2C  2406                              bgtu.b  loc_FFF0EA32
FFF0EA2E  f80601                            mov.l   #1, 4+var_4[sp]
FFF0EA31  0c                                bra.s   loc_FFF0EA35
FFF0EA32  f80600                 loc_FFF0EA32 mov.l   #0, 4+var_4[sp]
FFF0EA35  ec01                   loc_FFF0EA35 mov.l   4+var_4[sp], r1
FFF0EA37  6101                              cmp     #0, r1
FFF0EA39  2029                              beq.b   loc_FFF0EA62
FFF0EA3B  054911fe                          bsr.a   sub_FFEEFB84
FFF0EA3F  6101                              cmp     #0, r1
FFF0EA41  2121                              bne.b   loc_FFF0EA62
FFF0EA43  fbe2738f0000                      mov.l   #8F73h, r14
FFF0EA49  58e1                              movu.b  [r14], r1
FFF0EA4B  059f15fe                          bsr.a   sub_FFEEFFEA
FFF0EA4F  fbe2738f0000                      mov.l   #8F73h, r14
FFF0EA55  58ee                              movu.b  [r14], r14
FFF0EA57  fbf20078edff                      mov.l   #off_FFED7800, r15
FFF0EA5D  fe6efe                            mov.l   [r14, r15], r14
FFF0EA60  7f1e                              jsr     r14
FFF0EA62  fbe24c8c0000           loc_FFF0EA62 mov.l   #8C4Ch, r14
FFF0EA68  58ee                              movu.b  [r14], r14
FFF0EA6A  614e                              cmp     #4, r14
FFF0EA6C  290d                              blt.b   loc_FFF0EA79
FFF0EA6E  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0EA74  f8e403                            mov.b   #3, [r14]
FFF0EA77  6701                              rtsd    #1
FFF0EA79  6701                   loc_FFF0EA79 rtsd    #1
FFF0EA7B  6040                   sub_FFF0EA7B sub     #4, sp   ; <<<< FUNC sub_FFF0EA7B
FFF0EA7D  8089                              mov.b   r1, 4+var_1[sp]
FFF0EA7F  05ea55fe                          bsr.a   sub_FFEF4069
FFF0EA83  391400                            bsr.w   sub_FFF0EA97
FFF0EA86  053456fe                          bsr.a   sub_FFEF40BA
FFF0EA8A  b089                              movu.b  4+var_1[sp], r1
FFF0EA8C  6111                              cmp     #1, r1
FFF0EA8E  1f                                bne.s   loc_FFF0EA95
FFF0EA8F  059d15fe                          bsr.a   sub_FFEF002C
FFF0EA93  6701                              rtsd    #1
FFF0EA95  6701                   loc_FFF0EA95 rtsd    #1
FFF0EA97  6040                   sub_FFF0EA97 sub     #4, sp   ; <<<< FUNC sub_FFF0EA97
FFF0EA99  fb22468e0000                      mov.l   #8E46h, r2
FFF0EA9F  712220                            add     #20h, r2, r2 ; ' '
FFF0EAA2  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0EAA8  711120                            add     #20h, r1, r1 ; ' '
FFF0EAAB  6614                              mov.l   #1, r4
FFF0EAAD  754317                            mov.l   #17h, r3
FFF0EAB0  05dd35fe                          bsr.a   sub_FFEF208D
FFF0EAB4  fbe2468e0000                      mov.l   #8E46h, r14
FFF0EABA  59ef37                            movu.b  37h[r14], r15
FFF0EABD  eff5                              mov.l   r15, r5
FFF0EABF  fd749505                          divu    #5, r5
FFF0EAC3  6355                              mul     #5, r5
FFF0EAC5  435f                              sub     r5, r15
FFF0EAC7  c7ef37                            mov.b   r15, 37h[r14]
FFF0EACA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EAD0  59ee37                            movu.b  37h[r14], r14
FFF0EAD3  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EAD9  45fe37                            cmp     37h[r15], r14
FFF0EADC  2037                              beq.b   loc_FFF0EB13
FFF0EADE  fbe2468e0000                      mov.l   #8E46h, r14
FFF0EAE4  59ee37                            movu.b  37h[r14], r14
FFF0EAE7  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF0EAED  59ff37                            movu.b  37h[r15], r15
FFF0EAF0  fb5e008000                        mov.l   #8000h, r5
FFF0EAF5  ef51                              mov.l   r5, r1
FFF0EAF7  fd62f1                            shll    r15, r1
FFF0EAFA  fd62e5                            shll    r14, r5
FFF0EAFD  5751                              or      r5, r1
FFF0EAFF  05a513fe                          bsr.a   sub_FFEEFEA4
FFF0EB03  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EB09  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EB0F  c5fe3737                          mov.b   37h[r15], 37h[r14]
FFF0EB13  3c0300                 loc_FFF0EB13 mov.b   #0, 4+var_1[sp]
FFF0EB16  2e31                              bra.b   loc_FFF0EB47
FFF0EB18  b08b                   loc_FFF0EB18 movu.b  4+var_1[sp], r3
FFF0EB1A  fb4e008000                        mov.l   #8000h, r4
FFF0EB1F  fd6234                            shll    r3, r4
FFF0EB22  6c43                              shll    #4, r3
FFF0EB24  fb22468e0000                      mov.l   #8E46h, r2
FFF0EB2A  4b32                              add     r3, r2
FFF0EB2C  712238                            add     #38h, r2, r2 ; '8'
FFF0EB2F  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0EB35  4b31                              add     r3, r1
FFF0EB37  711138                            add     #38h, r1, r1 ; '8'
FFF0EB3A  754310                            mov.l   #10h, r3
FFF0EB3D  055035fe                          bsr.a   sub_FFEF208D
FFF0EB41  b089                              movu.b  4+var_1[sp], r1
FFF0EB43  6211                              add     #1, r1
FFF0EB45  8089                              mov.b   r1, 4+var_1[sp]
FFF0EB47  b089                   loc_FFF0EB47 movu.b  4+var_1[sp], r1
FFF0EB49  6151                              cmp     #5, r1
FFF0EB4B  29cd                              blt.b   loc_FFF0EB18
FFF0EB4D  054717fe                          bsr.a   sub_FFEF0294
FFF0EB51  6701                              rtsd    #1
FFF0EB53  6040                   sub_FFF0EB53 sub     #4, sp   ; <<<< FUNC sub_FFF0EB53
FFF0EB55  fbe2798d0000                      mov.l   #8D79h, r14
FFF0EB5B  f8e400                            mov.b   #0, [r14]
FFF0EB5E  6601                              mov.l   #0, r1
FFF0EB60  ef12                              mov.l   r1, r2
FFF0EB62  05a618fe                          bsr.a   sub_FFEF0408
FFF0EB66  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0EB69  2e19                              bra.b   loc_FFF0EB82
FFF0EB6B  b08b                   loc_FFF0EB6B movu.b  4+var_1[sp], r3
FFF0EB6D  ef3e                              mov.l   r3, r14
FFF0EB6F  751e1e                            mul     #1Eh, r14
FFF0EB72  71ee1e                            add     #1Eh, r14, r14
FFF0EB75  5fe2                              movu.w  r14, r2
FFF0EB77  6601                              mov.l   #0, r1
FFF0EB79  391100                            bsr.w   sub_FFF0EB8A
FFF0EB7C  b089                              movu.b  4+var_1[sp], r1
FFF0EB7E  6211                              add     #1, r1
FFF0EB80  8089                              mov.b   r1, 4+var_1[sp]
FFF0EB82  b089                   loc_FFF0EB82 movu.b  4+var_1[sp], r1
FFF0EB84  6151                              cmp     #5, r1
FFF0EB86  29e5                              blt.b   loc_FFF0EB6B
FFF0EB88  6701                              rtsd    #1
FFF0EB8A  6080                   sub_FFF0EB8A sub     #8, sp   ; <<<< FUNC sub_FFF0EB8A
FFF0EB8C  9089                              mov.w   r1, 8+var_2[sp]
FFF0EB8E  9082                              mov.w   r2, 8+var_4[sp]
FFF0EB90  808b                              mov.b   r3, 8+var_5[sp]
FFF0EB92  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EB98  59e337                            movu.b  37h[r14], r3
FFF0EB9B  b08c                              movu.b  8+var_5[sp], r4
FFF0EB9D  b882                              movu.w  8+var_4[sp], r2
FFF0EB9F  b889                              movu.w  8+var_2[sp], r1
FFF0EBA1  6040                              sub     #4, sp
FFF0EBA3  fdc44f                            shll    #4, r4, r15
FFF0EBA6  4bfe                              add     r15, r14
FFF0EBA8  71ee38                            add     #38h, r14, r14 ; '8'
FFF0EBAB  e30e                              mov.l   r14, 0Ch+var_C[sp]
FFF0EBAD  05b01200                          bsr.a   sub_FFF0FE5D
FFF0EBB1  6240                              add     #4, sp
FFF0EBB3  6702                              rtsd    #2
FFF0EBB5  fbe24c8c0000           sub_FFF0EBB5 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF0EBB5
FFF0EBBB  58ee                              movu.b  [r14], r14
FFF0EBBD  613e                              cmp     #3, r14
FFF0EBBF  2a16                              bgt.b   loc_FFF0EBD5
FFF0EBC1  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0EBC7  58ee                              movu.b  [r14], r14
FFF0EBC9  fbf25078edff                      mov.l   #off_FFED7850, r15
FFF0EBCF  fe6efe                            mov.l   [r14, r15], r14
FFF0EBD2  7f1e                              jsr     r14
FFF0EBD4  02                                rts
FFF0EBD5  fbe24c8c0000           loc_FFF0EBD5 mov.l   #8C4Ch, r14
FFF0EBDB  f8e403                            mov.b   #3, [r14]
FFF0EBDE  02                                rts
FFF0EBDF  6611                   sub_FFF0EBDF mov.l   #1, r1   ; <<<< FUNC sub_FFF0EBDF
FFF0EBE1  395901                            bsr.w   sub_FFF0ED3A
FFF0EBE4  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0EBEA  58ef                              movu.b  [r14], r15
FFF0EBEC  621f                              add     #1, r15
FFF0EBEE  c3ef                              mov.b   r15, [r14]
FFF0EBF0  02                                rts
FFF0EBF1  053c17fe               sub_FFF0EBF1 bsr.a   sub_FFEF032D   ; <<<< FUNC sub_FFF0EBF1
FFF0EBF5  0552bbfe                          bsr.a   sub_FFEFA747
FFF0EBF9  6621                              mov.l   #2, r1
FFF0EBFB  0594b2fe                          bsr.a   sub_FFEF9E8F
FFF0EBFF  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0EC05  58ef                              movu.b  [r14], r15
FFF0EC07  621f                              add     #1, r15
FFF0EC09  c3ef                              mov.b   r15, [r14]
FFF0EC0B  02                                rts
FFF0EC0C  6040                   sub_FFF0EC0C sub     #4, sp   ; <<<< FUNC sub_FFF0EC0C
FFF0EC0E  6040                              sub     #4, sp
FFF0EC10  3d00f0                            mov.w   #-10h, [sp]
FFF0EC13  fb4a4001                          mov.l   #140h, r4
FFF0EC17  6602                              mov.l   #0, r2
FFF0EC19  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0EC1F  ef23                              mov.l   r2, r3
FFF0EC21  059a0dfe                          bsr.a   sub_FFEEF9BB
FFF0EC25  6240                              add     #4, sp
FFF0EC27  8089                              mov.b   r1, 4+var_1[sp]
FFF0EC29  b089                              movu.b  4+var_1[sp], r1
FFF0EC2B  6111                              cmp     #1, r1
FFF0EC2D  1a                                bne.s   loc_FFF0EC37
FFF0EC2E  394b02                            bsr.w   sub_FFF0EE79
FFF0EC31  053e17fe                          bsr.a   sub_FFEF036F
FFF0EC35  6701                              rtsd    #1
FFF0EC37  6701                   loc_FFF0EC37 rtsd    #1
FFF0EC39  6040                   sub_FFF0EC39 sub     #4, sp   ; <<<< FUNC sub_FFF0EC39
FFF0EC3B  6040                              sub     #4, sp
FFF0EC3D  f80520                            mov.w   #20h, 8+var_8[sp] ; ' '
FFF0EC40  fb4a4001                          mov.l   #140h, r4
FFF0EC44  6602                              mov.l   #0, r2
FFF0EC46  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0EC4C  ef23                              mov.l   r2, r3
FFF0EC4E  056d0dfe                          bsr.a   sub_FFEEF9BB
FFF0EC52  6240                              add     #4, sp
FFF0EC54  8089                              mov.b   r1, 4+var_1[sp]
FFF0EC56  b089                              movu.b  4+var_1[sp], r1
FFF0EC58  6111                              cmp     #1, r1
FFF0EC5A  2110                              bne.b   loc_FFF0EC6A
FFF0EC5C  6622                              mov.l   #2, r2
FFF0EC5E  754130                            mov.l   #30h, r1 ; '0'
FFF0EC61  393502                            bsr.w   sub_FFF0EE96
FFF0EC64  050b17fe                          bsr.a   sub_FFEF036F
FFF0EC68  6701                              rtsd    #1
FFF0EC6A  6701                   loc_FFF0EC6A rtsd    #1
FFF0EC6C  6040                   sub_FFF0EC6C sub     #4, sp   ; <<<< FUNC sub_FFF0EC6C
FFF0EC6E  fbe2738f0000                      mov.l   #8F73h, r14
FFF0EC74  58e1                              movu.b  [r14], r1
FFF0EC76  7111e0                            add     #-20h, r1, r1
FFF0EC79  8081                              mov.b   r1, 4+var_2[sp]
FFF0EC7B  b081                              movu.b  4+var_2[sp], r1
FFF0EC7D  6c31                              shll    #3, r1
FFF0EC7F  fb52805eecff                      mov.l   #unk_FFEC5E80, r5
FFF0EC85  4b15                              add     r1, r5
FFF0EC87  b8d4                              movu.w  4[r5], r4
FFF0EC89  b85b                              movu.w  2[r5], r3
FFF0EC8B  5c52                              movu.w  [r5], r2
FFF0EC8D  6040                              sub     #4, sp
FFF0EC8F  d15003                            mov.w   6[r5], 8+var_8[sp]
FFF0EC92  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0EC98  05230dfe                          bsr.a   sub_FFEEF9BB
FFF0EC9C  6240                              add     #4, sp
FFF0EC9E  8089                              mov.b   r1, 4+var_1[sp]
FFF0ECA0  b089                              movu.b  4+var_1[sp], r1
FFF0ECA2  6111                              cmp     #1, r1
FFF0ECA4  210e                              bne.b   loc_FFF0ECB2
FFF0ECA6  b081                              movu.b  4+var_2[sp], r1
FFF0ECA8  055d38fe                          bsr.a   sub_FFEF2505
FFF0ECAC  05c316fe                          bsr.a   sub_FFEF036F
FFF0ECB0  6701                              rtsd    #1
FFF0ECB2  6701                   loc_FFF0ECB2 rtsd    #1
FFF0ECB4  6040                   sub_FFF0ECB4 sub     #4, sp   ; <<<< FUNC sub_FFF0ECB4
FFF0ECB6  058913fe                          bsr.a   sub_FFEF003F
FFF0ECBA  fbe2738f0000                      mov.l   #8F73h, r14
FFF0ECC0  c3e1                              mov.b   r1, [r14]
FFF0ECC2  fbe2738f0000                      mov.l   #8F73h, r14
FFF0ECC8  58ee                              movu.b  [r14], r14
FFF0ECCA  755eff                            cmp     #-1, r14
FFF0ECCD  1e                                bne.s   loc_FFF0ECD3
FFF0ECCE  6601                              mov.l   #0, r1
FFF0ECD0  396a00                            bsr.w   sub_FFF0ED3A
FFF0ECD3  fbe2738f0000           loc_FFF0ECD3 mov.l   #8F73h, r14
FFF0ECD9  58ee                              movu.b  [r14], r14
FFF0ECDB  755eff                            cmp     #-1, r14
FFF0ECDE  2013                              beq.b   loc_FFF0ECF1
FFF0ECE0  fbe2738f0000                      mov.l   #8F73h, r14
FFF0ECE6  58ee                              movu.b  [r14], r14
FFF0ECE8  755e35                            cmp     #35h, r14 ; '5'
FFF0ECEB  2406                              bgtu.b  loc_FFF0ECF1
FFF0ECED  f80601                            mov.l   #1, 4+var_4[sp]
FFF0ECF0  0c                                bra.s   loc_FFF0ECF4
FFF0ECF1  f80600                 loc_FFF0ECF1 mov.l   #0, 4+var_4[sp]
FFF0ECF4  ec01                   loc_FFF0ECF4 mov.l   4+var_4[sp], r1
FFF0ECF6  6101                              cmp     #0, r1
FFF0ECF8  2029                              beq.b   loc_FFF0ED21
FFF0ECFA  058a0efe                          bsr.a   sub_FFEEFB84
FFF0ECFE  6101                              cmp     #0, r1
FFF0ED00  2121                              bne.b   loc_FFF0ED21
FFF0ED02  fbe2738f0000                      mov.l   #8F73h, r14
FFF0ED08  58e1                              movu.b  [r14], r1
FFF0ED0A  05e012fe                          bsr.a   sub_FFEEFFEA
FFF0ED0E  fbe2738f0000                      mov.l   #8F73h, r14
FFF0ED14  58ee                              movu.b  [r14], r14
FFF0ED16  fbf26078edff                      mov.l   #off_FFED7860, r15
FFF0ED1C  fe6efe                            mov.l   [r14, r15], r14
FFF0ED1F  7f1e                              jsr     r14
FFF0ED21  fbe24c8c0000           loc_FFF0ED21 mov.l   #8C4Ch, r14
FFF0ED27  58ee                              movu.b  [r14], r14
FFF0ED29  614e                              cmp     #4, r14
FFF0ED2B  290d                              blt.b   loc_FFF0ED38
FFF0ED2D  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0ED33  f8e403                            mov.b   #3, [r14]
FFF0ED36  6701                              rtsd    #1
FFF0ED38  6701                   loc_FFF0ED38 rtsd    #1
FFF0ED3A  6040                   sub_FFF0ED3A sub     #4, sp   ; <<<< FUNC sub_FFF0ED3A
FFF0ED3C  8089                              mov.b   r1, 4+var_1[sp]
FFF0ED3E  052b53fe                          bsr.a   sub_FFEF4069
FFF0ED42  391400                            bsr.w   sub_FFF0ED56
FFF0ED45  057553fe                          bsr.a   sub_FFEF40BA
FFF0ED49  b089                              movu.b  4+var_1[sp], r1
FFF0ED4B  6111                              cmp     #1, r1
FFF0ED4D  1f                                bne.s   loc_FFF0ED54
FFF0ED4E  05de12fe                          bsr.a   sub_FFEF002C
FFF0ED52  6701                              rtsd    #1
FFF0ED54  6701                   loc_FFF0ED54 rtsd    #1
FFF0ED56  6040                   sub_FFF0ED56 sub     #4, sp   ; <<<< FUNC sub_FFF0ED56
FFF0ED58  fbe2748f0000                      mov.l   #8F74h, r14
FFF0ED5E  58ee                              movu.b  [r14], r14
FFF0ED60  610e                              cmp     #0, r14
FFF0ED62  2116                              bne.b   loc_FFF0ED78
FFF0ED64  6602                              mov.l   #0, r2
FFF0ED66  fb1e000020                        mov.l   #200000h, r1
FFF0ED6B  05f813fe                          bsr.a   sub_FFEF0163
FFF0ED6F  fbe2748f0000                      mov.l   #8F74h, r14
FFF0ED75  f8e401                            mov.b   #1, [r14]
FFF0ED78  fbe24d8c0000           loc_FFF0ED78 mov.l   #8C4Dh, r14
FFF0ED7E  59ee6c                            movu.b  6Ch[r14], r14
FFF0ED81  fbf2468e0000                      mov.l   #8E46h, r15
FFF0ED87  45fe6c                            cmp     6Ch[r15], r14
FFF0ED8A  201b                              beq.b   loc_FFF0EDA5
FFF0ED8C  fb1e000020                        mov.l   #200000h, r1
FFF0ED91  055d11fe                          bsr.a   sub_FFEEFEEE
FFF0ED95  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0ED9B  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EDA1  c5fe6c6c                          mov.b   6Ch[r15], 6Ch[r14]
FFF0EDA5  3c0300                 loc_FFF0EDA5 mov.b   #0, 4+var_1[sp]
FFF0EDA8  2e41                              bra.b   loc_FFF0EDE9
FFF0EDAA  b089                   loc_FFF0EDAA movu.b  4+var_1[sp], r1
FFF0EDAC  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EDB2  4b1e                              add     r1, r14
FFF0EDB4  59ee6f                            movu.b  6Fh[r14], r14
FFF0EDB7  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EDBD  4b1f                              add     r1, r15
FFF0EDBF  45fe6f                            cmp     6Fh[r15], r14
FFF0EDC2  2021                              beq.b   loc_FFF0EDE3
FFF0EDC4  fb1e000020                        mov.l   #200000h, r1
FFF0EDC9  052511fe                          bsr.a   sub_FFEEFEEE
FFF0EDCD  b089                              movu.b  4+var_1[sp], r1
FFF0EDCF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EDD5  4b1e                              add     r1, r14
FFF0EDD7  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EDDD  4b1f                              add     r1, r15
FFF0EDDF  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF0EDE3  b089                   loc_FFF0EDE3 movu.b  4+var_1[sp], r1
FFF0EDE5  6211                              add     #1, r1
FFF0EDE7  8089                              mov.b   r1, 4+var_1[sp]
FFF0EDE9  b089                   loc_FFF0EDE9 movu.b  4+var_1[sp], r1
FFF0EDEB  61f1                              cmp     #0Fh, r1
FFF0EDED  2bbd                              ble.b   loc_FFF0EDAA
FFF0EDEF  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0EDF2  2e7a                              bra.b   loc_FFF0EE6C
FFF0EDF4  b089                   loc_FFF0EDF4 movu.b  4+var_1[sp], r1
FFF0EDF6  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EDFC  4b1e                              add     r1, r14
FFF0EDFE  59ee7f                            movu.b  7Fh[r14], r14
FFF0EE01  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EE07  4b1f                              add     r1, r15
FFF0EE09  45fe7f                            cmp     7Fh[r15], r14
FFF0EE0C  2021                              beq.b   loc_FFF0EE2D
FFF0EE0E  fb1e000010                        mov.l   #100000h, r1
FFF0EE13  05db10fe                          bsr.a   sub_FFEEFEEE
FFF0EE17  b089                              movu.b  4+var_1[sp], r1
FFF0EE19  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EE1F  4b1e                              add     r1, r14
FFF0EE21  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EE27  4b1f                              add     r1, r15
FFF0EE29  c5fe7f7f                          mov.b   7Fh[r15], 7Fh[r14]
FFF0EE2D  b089                   loc_FFF0EE2D movu.b  4+var_1[sp], r1
FFF0EE2F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EE35  4b1e                              add     r1, r14
FFF0EE37  59ee93                            movu.b  93h[r14], r14
FFF0EE3A  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EE40  4b1f                              add     r1, r15
FFF0EE42  45fe93                            cmp     93h[r15], r14
FFF0EE45  2021                              beq.b   loc_FFF0EE66
FFF0EE47  fb1e000010                        mov.l   #100000h, r1
FFF0EE4C  05a210fe                          bsr.a   sub_FFEEFEEE
FFF0EE50  b089                              movu.b  4+var_1[sp], r1
FFF0EE52  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EE58  4b1e                              add     r1, r14
FFF0EE5A  fbf2468e0000                      mov.l   #8E46h, r15
FFF0EE60  4b1f                              add     r1, r15
FFF0EE62  c5fe9393                          mov.b   93h[r15], 93h[r14]
FFF0EE66  b089                   loc_FFF0EE66 movu.b  4+var_1[sp], r1
FFF0EE68  6211                              add     #1, r1
FFF0EE6A  8089                              mov.b   r1, 4+var_1[sp]
FFF0EE6C  b089                   loc_FFF0EE6C movu.b  4+var_1[sp], r1
FFF0EE6E  755114                            cmp     #14h, r1
FFF0EE71  2983                              blt.b   loc_FFF0EDF4
FFF0EE73  052114fe                          bsr.a   sub_FFEF0294
FFF0EE77  6701                              rtsd    #1
FFF0EE79  fbe2798d0000           sub_FFF0EE79 mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF0EE79
FFF0EE7F  f8e400                            mov.b   #0, [r14]
FFF0EE82  6601                              mov.l   #0, r1
FFF0EE84  ef12                              mov.l   r1, r2
FFF0EE86  058215fe                          bsr.a   sub_FFEF0408
FFF0EE8A  6622                              mov.l   #2, r2
FFF0EE8C  754130                            mov.l   #30h, r1 ; '0'
FFF0EE8F  390700                            bsr.w   sub_FFF0EE96
FFF0EE92  399900                            bsr.w   sub_FFF0EF2B
FFF0EE95  02                                rts
FFF0EE96  7100f0                 sub_FFF0EE96 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF0EE96
FFF0EE99  9189                              mov.w   r1, 10h+var_2[sp]
FFF0EE9B  9182                              mov.w   r2, 10h+var_4[sp]
FFF0EE9D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EEA3  c5e06c0b                          mov.b   6Ch[r14], 10h+var_5[sp]
FFF0EEA7  3c0700                            mov.b   #0, 10h+var_9[sp]
FFF0EEAA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EEB0  59e16d                            movu.b  6Dh[r14], r1
FFF0EEB3  6c81                              shll    #8, r1
FFF0EEB5  55e16e                            or      6Eh[r14], r1
FFF0EEB8  9081                              mov.w   r1, 10h+var_C[sp]
FFF0EEBA  754420                            mov.l   #20h, r4 ; ' '
FFF0EEBD  fb3a4001                          mov.l   #140h, r3
FFF0EEC1  6601                              mov.l   #0, r1
FFF0EEC3  ef12                              mov.l   r1, r2
FFF0EEC5  053216fe                          bsr.a   sub_FFEF04F7
FFF0EEC9  052914fe                          bsr.a   sub_FFEF02F2
FFF0EECD  8189                              mov.b   r1, 10h+var_9[sp]
FFF0EECF  b189                              movu.b  10h+var_9[sp], r1
FFF0EED1  6111                              cmp     #1, r1
FFF0EED3  2143                              bne.b   loc_FFF0EF16
FFF0EED5  b289                              movu.b  10h+var_5[sp], r1
FFF0EED7  61f1                              cmp     #0Fh, r1
FFF0EED9  2b05                              ble.b   loc_FFF0EEDE
FFF0EEDB  3c0b0f                            mov.b   #0Fh, 10h+var_5[sp]
FFF0EEDE  fbee008000             loc_FFF0EEDE mov.l   #8000h, r14
FFF0EEE3  b289                              movu.b  10h+var_5[sp], r1
FFF0EEE5  fd601e                            shlr    r1, r14
FFF0EEE8  06e10c0e02                        tst     10h+var_C[sp].uw, r14
FFF0EEED  15                                beq.s   loc_FFF0EEF2
FFF0EEEE  3c031c                            mov.b   #1Ch, 10h+var_D[sp]
FFF0EEF1  0c                                bra.s   loc_FFF0EEF5
FFF0EEF2  3c030e                 loc_FFF0EEF2 mov.b   #0Eh, 10h+var_D[sp]
FFF0EEF5  b289                   loc_FFF0EEF5 movu.b  10h+var_5[sp], r1
FFF0EEF7  63e1                              mul     #0Eh, r1
FFF0EEF9  9101                              mov.w   r1, 10h+var_8[sp]
FFF0EEFB  b989                              movu.w  10h+var_2[sp], r1
FFF0EEFD  06c90104                          add     10h+var_8[sp].uw, r1
FFF0EF01  b08b                              movu.b  10h+var_D[sp], r3
FFF0EF03  b982                              movu.w  10h+var_4[sp], r2
FFF0EF05  6040                              sub     #4, sp
FFF0EF07  f80980f9                          mov.w   #-680h, 14h+var_14[sp]
FFF0EF0B  5f11                              movu.w  r1, r1
FFF0EF0D  75441c                            mov.l   #1Ch, r4
FFF0EF10  05382dfe                          bsr.a   sub_FFEF1C48
FFF0EF14  6240                              add     #4, sp
FFF0EF16  b883                   loc_FFF0EF16 movu.w  10h+var_C[sp], r3
FFF0EF18  b982                              movu.w  10h+var_4[sp], r2
FFF0EF1A  b989                              movu.w  10h+var_2[sp], r1
FFF0EF1C  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF0EF22  71446f                            add     #6Fh, r4, r4 ; 'o'
FFF0EF25  05c2b8fe                          bsr.a   sub_FFEFA7E7
FFF0EF29  6704                              rtsd    #4
FFF0EF2B  6040                   sub_FFF0EF2B sub     #4, sp   ; <<<< FUNC sub_FFF0EF2B
FFF0EF2D  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0EF30  2e0e                              bra.b   loc_FFF0EF3E
FFF0EF32  b089                   loc_FFF0EF32 movu.b  4+var_1[sp], r1
FFF0EF34  05d135fe                          bsr.a   sub_FFEF2505
FFF0EF38  b089                              movu.b  4+var_1[sp], r1
FFF0EF3A  6211                              add     #1, r1
FFF0EF3C  8089                              mov.b   r1, 4+var_1[sp]
FFF0EF3E  b089                   loc_FFF0EF3E movu.b  4+var_1[sp], r1
FFF0EF40  755114                            cmp     #14h, r1
FFF0EF43  29ef                              blt.b   loc_FFF0EF32
FFF0EF45  6701                              rtsd    #1
FFF0EF47  fbe24c8c0000           sub_FFF0EF47 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF0EF47
FFF0EF4D  58ee                              movu.b  [r14], r14
FFF0EF4F  613e                              cmp     #3, r14
FFF0EF51  2a16                              bgt.b   loc_FFF0EF67
FFF0EF53  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0EF59  58ee                              movu.b  [r14], r14
FFF0EF5B  fbf23879edff                      mov.l   #off_FFED7938, r15
FFF0EF61  fe6efe                            mov.l   [r14, r15], r14
FFF0EF64  7f1e                              jsr     r14
FFF0EF66  02                                rts
FFF0EF67  fbe24c8c0000           loc_FFF0EF67 mov.l   #8C4Ch, r14
FFF0EF6D  f8e403                            mov.b   #3, [r14]
FFF0EF70  02                                rts
FFF0EF71  6611                   sub_FFF0EF71 mov.l   #1, r1   ; <<<< FUNC sub_FFF0EF71
FFF0EF73  398302                            bsr.w   sub_FFF0F1F6
FFF0EF76  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0EF7C  58ef                              movu.b  [r14], r15
FFF0EF7E  621f                              add     #1, r15
FFF0EF80  c3ef                              mov.b   r15, [r14]
FFF0EF82  02                                rts
FFF0EF83  6080                   sub_FFF0EF83 sub     #8, sp   ; <<<< FUNC sub_FFF0EF83
FFF0EF85  05a813fe                          bsr.a   sub_FFEF032D
FFF0EF89  05beb7fe                          bsr.a   sub_FFEFA747
FFF0EF8D  3d0302                            mov.w   #2, 8+var_2[sp]
FFF0EF90  3d0204                            mov.w   #4, 8+var_4[sp]
FFF0EF93  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0EF99  59ee9d                            movu.b  9Dh[r14], r14
FFF0EF9C  610e                              cmp     #0, r14
FFF0EF9E  9881                              mov.w   8+var_4[sp], r1
FFF0EFA0  988b                              mov.w   8+var_2[sp], r3
FFF0EFA2  2114                              bne.b   loc_FFF0EFB6
FFF0EFA4  5f12                              movu.w  r1, r2
FFF0EFA6  5f31                              movu.w  r3, r1
FFF0EFA8  fb42dc22edff                      mov.l   #unk_FFED22DC, r4
FFF0EFAE  6613                              mov.l   #1, r3
FFF0EFB0  052579fe                          bsr.a   sub_FFEF68D5
FFF0EFB4  2e12                              bra.b   loc_FFF0EFC6
FFF0EFB6  5f12                   loc_FFF0EFB6 movu.w  r1, r2
FFF0EFB8  5f31                              movu.w  r3, r1
FFF0EFBA  fb425c20edff                      mov.l   #unk_FFED205C, r4
FFF0EFC0  6613                              mov.l   #1, r3
FFF0EFC2  051379fe                          bsr.a   sub_FFEF68D5
FFF0EFC6  3d0330                 loc_FFF0EFC6 mov.w   #30h, 8+var_2[sp] ; '0'
FFF0EFC9  3d0202                            mov.w   #2, 8+var_4[sp]
FFF0EFCC  b882                              movu.w  8+var_4[sp], r2
FFF0EFCE  b889                              movu.w  8+var_2[sp], r1
FFF0EFD0  60c0                              sub     #0Ch, sp
FFF0EFD2  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF0EFD8  713320                            add     #20h, r3, r3 ; ' '
FFF0EFDB  a00b                              mov.l   r3, 14h+var_10[sp]
FFF0EFDD  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF0EFE0  f80413                            mov.b   #13h, 14h+var_14[sp]
FFF0EFE3  6604                              mov.l   #0, r4
FFF0EFE5  66d3                              mov.l   #0Dh, r3
FFF0EFE7  053c2bfe                          bsr.a   sub_FFEF1B23
FFF0EFEB  62c0                              add     #0Ch, sp
FFF0EFED  3d021e                            mov.w   #1Eh, 8+var_4[sp]
FFF0EFF0  3c0300                            mov.b   #0, 8+var_5[sp]
FFF0EFF3  2e17                              bra.b   loc_FFF0F00A
FFF0EFF5  b881                   loc_FFF0EFF5 movu.w  8+var_4[sp], r1
FFF0EFF7  6612                              mov.l   #1, r2
FFF0EFF9  05750f00                          bsr.a   sub_FFF0FF6E
FFF0EFFD  b881                              movu.w  8+var_4[sp], r1
FFF0EFFF  71111e                            add     #1Eh, r1, r1
FFF0F002  9081                              mov.w   r1, 8+var_4[sp]
FFF0F004  b089                              movu.b  8+var_5[sp], r1
FFF0F006  6211                              add     #1, r1
FFF0F008  8089                              mov.b   r1, 8+var_5[sp]
FFF0F00A  b089                   loc_FFF0F00A movu.b  8+var_5[sp], r1
FFF0F00C  6151                              cmp     #5, r1
FFF0F00E  29e7                              blt.b   loc_FFF0EFF5
FFF0F010  7542b3                            mov.l   #-4Dh, r2
FFF0F013  754122                            mov.l   #22h, r1 ; '"'
FFF0F016  0539b5fe                          bsr.a   sub_FFEFA54F
FFF0F01A  6661                              mov.l   #6, r1
FFF0F01C  0573aefe                          bsr.a   sub_FFEF9E8F
FFF0F020  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0F026  58ef                              movu.b  [r14], r15
FFF0F028  621f                              add     #1, r15
FFF0F02A  c3ef                              mov.b   r15, [r14]
FFF0F02C  6702                              rtsd    #2
FFF0F02E  6040                   sub_FFF0F02E sub     #4, sp   ; <<<< FUNC sub_FFF0F02E
FFF0F030  6040                              sub     #4, sp
FFF0F032  3d00f0                            mov.w   #-10h, [sp]
FFF0F035  fb4a4001                          mov.l   #140h, r4
FFF0F039  6602                              mov.l   #0, r2
FFF0F03B  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F041  ef23                              mov.l   r2, r3
FFF0F043  057809fe                          bsr.a   sub_FFEEF9BB
FFF0F047  6240                              add     #4, sp
FFF0F049  8089                              mov.b   r1, 4+var_1[sp]
FFF0F04B  b089                              movu.b  4+var_1[sp], r1
FFF0F04D  6111                              cmp     #1, r1
FFF0F04F  1a                                bne.s   loc_FFF0F059
FFF0F050  39a304                            bsr.w   sub_FFF0F4F3
FFF0F053  051c13fe                          bsr.a   sub_FFEF036F
FFF0F057  6701                              rtsd    #1
FFF0F059  6701                   loc_FFF0F059 rtsd    #1
FFF0F05B  6040                   sub_FFF0F05B sub     #4, sp   ; <<<< FUNC sub_FFF0F05B
FFF0F05D  6040                              sub     #4, sp
FFF0F05F  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF0F062  fb4a4001                          mov.l   #140h, r4
FFF0F066  75431e                            mov.l   #1Eh, r3
FFF0F069  6602                              mov.l   #0, r2
FFF0F06B  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F071  054a09fe                          bsr.a   sub_FFEEF9BB
FFF0F075  6240                              add     #4, sp
FFF0F077  8089                              mov.b   r1, 4+var_1[sp]
FFF0F079  b089                              movu.b  4+var_1[sp], r1
FFF0F07B  6111                              cmp     #1, r1
FFF0F07D  2112                              bne.b   loc_FFF0F08F
FFF0F07F  75421e                            mov.l   #1Eh, r2
FFF0F082  6601                              mov.l   #0, r1
FFF0F084  ef13                              mov.l   r1, r3
FFF0F086  39c004                            bsr.w   sub_FFF0F546
FFF0F089  05e612fe                          bsr.a   sub_FFEF036F
FFF0F08D  6701                              rtsd    #1
FFF0F08F  6701                   loc_FFF0F08F rtsd    #1
FFF0F091  6040                   sub_FFF0F091 sub     #4, sp   ; <<<< FUNC sub_FFF0F091
FFF0F093  6040                              sub     #4, sp
FFF0F095  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF0F098  fb4a4001                          mov.l   #140h, r4
FFF0F09C  75433c                            mov.l   #3Ch, r3 ; '<'
FFF0F09F  6602                              mov.l   #0, r2
FFF0F0A1  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F0A7  051409fe                          bsr.a   sub_FFEEF9BB
FFF0F0AB  6240                              add     #4, sp
FFF0F0AD  8089                              mov.b   r1, 4+var_1[sp]
FFF0F0AF  b089                              movu.b  4+var_1[sp], r1
FFF0F0B1  6111                              cmp     #1, r1
FFF0F0B3  2112                              bne.b   loc_FFF0F0C5
FFF0F0B5  6613                              mov.l   #1, r3
FFF0F0B7  75423c                            mov.l   #3Ch, r2 ; '<'
FFF0F0BA  6601                              mov.l   #0, r1
FFF0F0BC  398a04                            bsr.w   sub_FFF0F546
FFF0F0BF  05b012fe                          bsr.a   sub_FFEF036F
FFF0F0C3  6701                              rtsd    #1
FFF0F0C5  6701                   loc_FFF0F0C5 rtsd    #1
FFF0F0C7  6040                   sub_FFF0F0C7 sub     #4, sp   ; <<<< FUNC sub_FFF0F0C7
FFF0F0C9  6040                              sub     #4, sp
FFF0F0CB  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF0F0CE  fb4a4001                          mov.l   #140h, r4
FFF0F0D2  75435a                            mov.l   #5Ah, r3 ; 'Z'
FFF0F0D5  6602                              mov.l   #0, r2
FFF0F0D7  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F0DD  05de08fe                          bsr.a   sub_FFEEF9BB
FFF0F0E1  6240                              add     #4, sp
FFF0F0E3  8089                              mov.b   r1, 4+var_1[sp]
FFF0F0E5  b089                              movu.b  4+var_1[sp], r1
FFF0F0E7  6111                              cmp     #1, r1
FFF0F0E9  2112                              bne.b   loc_FFF0F0FB
FFF0F0EB  6623                              mov.l   #2, r3
FFF0F0ED  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF0F0F0  6601                              mov.l   #0, r1
FFF0F0F2  395404                            bsr.w   sub_FFF0F546
FFF0F0F5  057a12fe                          bsr.a   sub_FFEF036F
FFF0F0F9  6701                              rtsd    #1
FFF0F0FB  6701                   loc_FFF0F0FB rtsd    #1
FFF0F0FD  6040                   sub_FFF0F0FD sub     #4, sp   ; <<<< FUNC sub_FFF0F0FD
FFF0F0FF  6040                              sub     #4, sp
FFF0F101  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF0F104  fb4a4001                          mov.l   #140h, r4
FFF0F108  754378                            mov.l   #78h, r3 ; 'x'
FFF0F10B  6602                              mov.l   #0, r2
FFF0F10D  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F113  05a808fe                          bsr.a   sub_FFEEF9BB
FFF0F117  6240                              add     #4, sp
FFF0F119  8089                              mov.b   r1, 4+var_1[sp]
FFF0F11B  b089                              movu.b  4+var_1[sp], r1
FFF0F11D  6111                              cmp     #1, r1
FFF0F11F  2112                              bne.b   loc_FFF0F131
FFF0F121  6633                              mov.l   #3, r3
FFF0F123  754278                            mov.l   #78h, r2 ; 'x'
FFF0F126  6601                              mov.l   #0, r1
FFF0F128  391e04                            bsr.w   sub_FFF0F546
FFF0F12B  054412fe                          bsr.a   sub_FFEF036F
FFF0F12F  6701                              rtsd    #1
FFF0F131  6701                   loc_FFF0F131 rtsd    #1
FFF0F133  6040                   sub_FFF0F133 sub     #4, sp   ; <<<< FUNC sub_FFF0F133
FFF0F135  6040                              sub     #4, sp
FFF0F137  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF0F13A  fb4a4001                          mov.l   #140h, r4
FFF0F13E  754396                            mov.l   #-6Ah, r3
FFF0F141  6602                              mov.l   #0, r2
FFF0F143  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F149  057208fe                          bsr.a   sub_FFEEF9BB
FFF0F14D  6240                              add     #4, sp
FFF0F14F  8089                              mov.b   r1, 4+var_1[sp]
FFF0F151  b089                              movu.b  4+var_1[sp], r1
FFF0F153  6111                              cmp     #1, r1
FFF0F155  2112                              bne.b   loc_FFF0F167
FFF0F157  6643                              mov.l   #4, r3
FFF0F159  754296                            mov.l   #-6Ah, r2
FFF0F15C  6601                              mov.l   #0, r1
FFF0F15E  39e803                            bsr.w   sub_FFF0F546
FFF0F161  050e12fe                          bsr.a   sub_FFEF036F
FFF0F165  6701                              rtsd    #1
FFF0F167  6701                   loc_FFF0F167 rtsd    #1
FFF0F169  66f1                   sub_FFF0F169 mov.l   #0Fh, r1   ; <<<< FUNC sub_FFF0F169
FFF0F16B  058f0d00                          bsr.a   sub_FFF0FEFA
FFF0F16F  02                                rts
FFF0F170  6040                   sub_FFF0F170 sub     #4, sp   ; <<<< FUNC sub_FFF0F170
FFF0F172  05cd0efe                          bsr.a   sub_FFEF003F
FFF0F176  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F17C  c3e1                              mov.b   r1, [r14]
FFF0F17E  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F184  58ee                              movu.b  [r14], r14
FFF0F186  755eff                            cmp     #-1, r14
FFF0F189  1e                                bne.s   loc_FFF0F18F
FFF0F18A  6601                              mov.l   #0, r1
FFF0F18C  396a00                            bsr.w   sub_FFF0F1F6
FFF0F18F  fbe2738f0000           loc_FFF0F18F mov.l   #8F73h, r14
FFF0F195  58ee                              movu.b  [r14], r14
FFF0F197  755eff                            cmp     #-1, r14
FFF0F19A  2013                              beq.b   loc_FFF0F1AD
FFF0F19C  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F1A2  58ee                              movu.b  [r14], r14
FFF0F1A4  755e16                            cmp     #16h, r14
FFF0F1A7  2406                              bgtu.b  loc_FFF0F1AD
FFF0F1A9  f80601                            mov.l   #1, 4+var_4[sp]
FFF0F1AC  0c                                bra.s   loc_FFF0F1B0
FFF0F1AD  f80600                 loc_FFF0F1AD mov.l   #0, 4+var_4[sp]
FFF0F1B0  ec01                   loc_FFF0F1B0 mov.l   4+var_4[sp], r1
FFF0F1B2  6101                              cmp     #0, r1
FFF0F1B4  2029                              beq.b   loc_FFF0F1DD
FFF0F1B6  05ce09fe                          bsr.a   sub_FFEEFB84
FFF0F1BA  6101                              cmp     #0, r1
FFF0F1BC  2121                              bne.b   loc_FFF0F1DD
FFF0F1BE  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F1C4  58e1                              movu.b  [r14], r1
FFF0F1C6  05240efe                          bsr.a   sub_FFEEFFEA
FFF0F1CA  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F1D0  58ee                              movu.b  [r14], r14
FFF0F1D2  fbf24879edff                      mov.l   #off_FFED7948, r15
FFF0F1D8  fe6efe                            mov.l   [r14, r15], r14
FFF0F1DB  7f1e                              jsr     r14
FFF0F1DD  fbe24c8c0000           loc_FFF0F1DD mov.l   #8C4Ch, r14
FFF0F1E3  58ee                              movu.b  [r14], r14
FFF0F1E5  614e                              cmp     #4, r14
FFF0F1E7  290d                              blt.b   loc_FFF0F1F4
FFF0F1E9  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0F1EF  f8e403                            mov.b   #3, [r14]
FFF0F1F2  6701                              rtsd    #1
FFF0F1F4  6701                   loc_FFF0F1F4 rtsd    #1
FFF0F1F6  6040                   sub_FFF0F1F6 sub     #4, sp   ; <<<< FUNC sub_FFF0F1F6
FFF0F1F8  8089                              mov.b   r1, 4+var_1[sp]
FFF0F1FA  056f4efe                          bsr.a   sub_FFEF4069
FFF0F1FE  391400                            bsr.w   sub_FFF0F212
FFF0F201  05b94efe                          bsr.a   sub_FFEF40BA
FFF0F205  b089                              movu.b  4+var_1[sp], r1
FFF0F207  6111                              cmp     #1, r1
FFF0F209  1f                                bne.s   loc_FFF0F210
FFF0F20A  05220efe                          bsr.a   sub_FFEF002C
FFF0F20E  6701                              rtsd    #1
FFF0F210  6701                   loc_FFF0F210 rtsd    #1
FFF0F212  6080                   sub_FFF0F212 sub     #8, sp   ; <<<< FUNC sub_FFF0F212
FFF0F214  3c0700                            mov.b   #0, 8+var_1[sp]
FFF0F217  2e66                              bra.b   loc_FFF0F27D
FFF0F219  b189                   loc_FFF0F219 movu.b  8+var_1[sp], r1
FFF0F21B  fb224d8c0000                      mov.l   #8C4Dh, r2
FFF0F221  4b12                              add     r1, r2
FFF0F223  b522                              movu.b  14h[r2], r2
FFF0F225  fbe2468e0000                      mov.l   #8E46h, r14
FFF0F22B  4b1e                              add     r1, r14
FFF0F22D  45e214                            cmp     14h[r14], r2
FFF0F230  2018                              beq.b   loc_FFF0F248
FFF0F232  b189                              movu.b  8+var_1[sp], r1
FFF0F234  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F23A  4b1e                              add     r1, r14
FFF0F23C  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F242  4b1f                              add     r1, r15
FFF0F244  c5fe1414                          mov.b   14h[r15], 14h[r14]
FFF0F248  b189                   loc_FFF0F248 movu.b  8+var_1[sp], r1
FFF0F24A  fb224d8c0000                      mov.l   #8C4Dh, r2
FFF0F250  4b12                              add     r1, r2
FFF0F252  b5a2                              movu.b  16h[r2], r2
FFF0F254  fbe2468e0000                      mov.l   #8E46h, r14
FFF0F25A  4b1e                              add     r1, r14
FFF0F25C  45e216                            cmp     16h[r14], r2
FFF0F25F  2018                              beq.b   loc_FFF0F277
FFF0F261  b189                              movu.b  8+var_1[sp], r1
FFF0F263  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F269  4b1e                              add     r1, r14
FFF0F26B  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F271  4b1f                              add     r1, r15
FFF0F273  c5fe1616                          mov.b   16h[r15], 16h[r14]
FFF0F277  b189                   loc_FFF0F277 movu.b  8+var_1[sp], r1
FFF0F279  6211                              add     #1, r1
FFF0F27B  8189                              mov.b   r1, 8+var_1[sp]
FFF0F27D  b189                   loc_FFF0F27D movu.b  8+var_1[sp], r1
FFF0F27F  6121                              cmp     #2, r1
FFF0F281  2998                              blt.b   loc_FFF0F219
FFF0F283  fb22468e0000                      mov.l   #8E46h, r2
FFF0F289  72229d00                          add     #9Dh, r2, r2
FFF0F28D  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0F293  72119d00                          add     #9Dh, r1, r1
FFF0F297  6613                              mov.l   #1, r3
FFF0F299  ef34                              mov.l   r3, r4
FFF0F29B  05f22dfe                          bsr.a   sub_FFEF208D
FFF0F29F  fb22468e0000                      mov.l   #8E46h, r2
FFF0F2A5  712220                            add     #20h, r2, r2 ; ' '
FFF0F2A8  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0F2AE  711120                            add     #20h, r1, r1 ; ' '
FFF0F2B1  6614                              mov.l   #1, r4
FFF0F2B3  754317                            mov.l   #17h, r3
FFF0F2B6  05d72dfe                          bsr.a   sub_FFEF208D
FFF0F2BA  fbe2468e0000                      mov.l   #8E46h, r14
FFF0F2C0  59ef37                            movu.b  37h[r14], r15
FFF0F2C3  eff5                              mov.l   r15, r5
FFF0F2C5  fd749505                          divu    #5, r5
FFF0F2C9  6355                              mul     #5, r5
FFF0F2CB  435f                              sub     r5, r15
FFF0F2CD  c7ef37                            mov.b   r15, 37h[r14]
FFF0F2D0  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F2D6  59ee37                            movu.b  37h[r14], r14
FFF0F2D9  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F2DF  45fe37                            cmp     37h[r15], r14
FFF0F2E2  204c                              beq.b   loc_FFF0F32E
FFF0F2E4  fbe2468e0000                      mov.l   #8E46h, r14
FFF0F2EA  59ee37                            movu.b  37h[r14], r14
FFF0F2ED  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF0F2F3  59ff37                            movu.b  37h[r15], r15
FFF0F2F6  fb5e000004                        mov.l   #40000h, r5
FFF0F2FB  ef51                              mov.l   r5, r1
FFF0F2FD  fd62f1                            shll    r15, r1
FFF0F300  fd62e5                            shll    r14, r5
FFF0F303  5751                              or      r5, r1
FFF0F305  059f0bfe                          bsr.a   sub_FFEEFEA4
FFF0F309  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F30F  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F315  c5fe3737                          mov.b   37h[r15], 37h[r14]
FFF0F319  fb12468e0000                      mov.l   #8E46h, r1
FFF0F31F  b499                              movu.b  13h[r1], r1
FFF0F321  755121                            cmp     #21h, r1 ; '!'
FFF0F324  1a                                bne.s   loc_FFF0F32E
FFF0F325  fbe27a8d0000                      mov.l   #8D7Ah, r14
FFF0F32B  f8e401                            mov.b   #1, [r14]
FFF0F32E  fbe24d8c0000           loc_FFF0F32E mov.l   #8C4Dh, r14
FFF0F334  59ee38                            movu.b  38h[r14], r14
FFF0F337  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F33D  45fe38                            cmp     38h[r15], r14
FFF0F340  2018                              beq.b   loc_FFF0F358
FFF0F342  6611                              mov.l   #1, r1
FFF0F344  05600bfe                          bsr.a   sub_FFEEFEA4
FFF0F348  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F34E  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F354  c5fe3838                          mov.b   38h[r15], 38h[r14]
FFF0F358  3c0700                 loc_FFF0F358 mov.b   #0, 8+var_1[sp]
FFF0F35B  38f800                            bra.w   loc_FFF0F453
FFF0F35E  b18b                   loc_FFF0F35E movu.b  8+var_1[sp], r3
FFF0F360  fb4e000004                        mov.l   #40000h, r4
FFF0F365  fd6234                            shll    r3, r4
FFF0F368  751314                            mul     #14h, r3
FFF0F36B  fb22468e0000                      mov.l   #8E46h, r2
FFF0F371  4b32                              add     r3, r2
FFF0F373  71223a                            add     #3Ah, r2, r2 ; ':'
FFF0F376  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0F37C  4b31                              add     r3, r1
FFF0F37E  71113a                            add     #3Ah, r1, r1 ; ':'
FFF0F381  754313                            mov.l   #13h, r3
FFF0F384  05092dfe                          bsr.a   sub_FFEF208D
FFF0F388  8181                              mov.b   r1, 8+var_2[sp]
FFF0F38A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F390  59ee37                            movu.b  37h[r14], r14
FFF0F393  450e07                            cmp     8+var_1[sp], r14
FFF0F396  2129                              bne.b   loc_FFF0F3BF
FFF0F398  b181                              movu.b  8+var_2[sp], r1
FFF0F39A  6111                              cmp     #1, r1
FFF0F39C  2112                              bne.b   loc_FFF0F3AE
FFF0F39E  fb12468e0000                      mov.l   #8E46h, r1
FFF0F3A4  b499                              movu.b  13h[r1], r1
FFF0F3A6  755121                            cmp     #21h, r1 ; '!'
FFF0F3A9  1d                                bne.s   loc_FFF0F3AE
FFF0F3AA  f80601                            mov.l   #1, 8+var_8[sp]
FFF0F3AD  0c                                bra.s   loc_FFF0F3B1
FFF0F3AE  f80600                 loc_FFF0F3AE mov.l   #0, 8+var_8[sp]
FFF0F3B1  ec01                   loc_FFF0F3B1 mov.l   8+var_8[sp], r1
FFF0F3B3  6101                              cmp     #0, r1
FFF0F3B5  12                                beq.s   loc_FFF0F3BF
FFF0F3B6  fbe27a8d0000                      mov.l   #8D7Ah, r14
FFF0F3BC  f8e401                            mov.b   #1, [r14]
FFF0F3BF  b189                   loc_FFF0F3BF movu.b  8+var_1[sp], r1
FFF0F3C1  751114                            mul     #14h, r1
FFF0F3C4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F3CA  4b1e                              add     r1, r14
FFF0F3CC  59ee39                            movu.b  39h[r14], r14
FFF0F3CF  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F3D5  4b1f                              add     r1, r15
FFF0F3D7  45fe39                            cmp     39h[r15], r14
FFF0F3DA  2073                              beq.b   loc_FFF0F44D
FFF0F3DC  b189                              movu.b  8+var_1[sp], r1
FFF0F3DE  751114                            mul     #14h, r1
FFF0F3E1  fbe2468e0000                      mov.l   #8E46h, r14
FFF0F3E7  4b1e                              add     r1, r14
FFF0F3E9  59ee39                            movu.b  39h[r14], r14
FFF0F3EC  613e                              cmp     #3, r14
FFF0F3EE  2114                              bne.b   loc_FFF0F402
FFF0F3F0  b189                              movu.b  8+var_1[sp], r1
FFF0F3F2  fb2e000004                        mov.l   #40000h, r2
FFF0F3F7  fd6212                            shll    r1, r2
FFF0F3FA  6601                              mov.l   #0, r1
FFF0F3FC  05670dfe                          bsr.a   sub_FFEF0163
FFF0F400  2e26                              bra.b   loc_FFF0F426
FFF0F402  b189                   loc_FFF0F402 movu.b  8+var_1[sp], r1
FFF0F404  751114                            mul     #14h, r1
FFF0F407  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F40D  4b1e                              add     r1, r14
FFF0F40F  59ee39                            movu.b  39h[r14], r14
FFF0F412  613e                              cmp     #3, r14
FFF0F414  2112                              bne.b   loc_FFF0F426
FFF0F416  b189                              movu.b  8+var_1[sp], r1
FFF0F418  fb2e000004                        mov.l   #40000h, r2
FFF0F41D  fd6212                            shll    r1, r2
FFF0F420  6601                              mov.l   #0, r1
FFF0F422  057c0dfe                          bsr.a   sub_FFEF019E
FFF0F426  b18a                   loc_FFF0F426 movu.b  8+var_1[sp], r2
FFF0F428  fb1e000004                        mov.l   #40000h, r1
FFF0F42D  fd6221                            shll    r2, r1
FFF0F430  05740afe                          bsr.a   sub_FFEEFEA4
FFF0F434  b189                              movu.b  8+var_1[sp], r1
FFF0F436  751114                            mul     #14h, r1
FFF0F439  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F43F  4b1e                              add     r1, r14
FFF0F441  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F447  4b1f                              add     r1, r15
FFF0F449  c5fe3939                          mov.b   39h[r15], 39h[r14]
FFF0F44D  b189                   loc_FFF0F44D movu.b  8+var_1[sp], r1
FFF0F44F  6211                              add     #1, r1
FFF0F451  8189                              mov.b   r1, 8+var_1[sp]
FFF0F453  b189                   loc_FFF0F453 movu.b  8+var_1[sp], r1
FFF0F455  6151                              cmp     #5, r1
FFF0F457  2805                              bge.b   loc_FFF0F45C
FFF0F459  3805ff                            bra.w   loc_FFF0F35E
FFF0F45C  3c0700                 loc_FFF0F45C mov.b   #0, 8+var_1[sp]
FFF0F45F  388500                            bra.w   loc_FFF0F4E4
FFF0F462  b189                   loc_FFF0F462 movu.b  8+var_1[sp], r1
FFF0F464  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F46A  4b1e                              add     r1, r14
FFF0F46C  59ee9e                            movu.b  9Eh[r14], r14
FFF0F46F  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F475  4b1f                              add     r1, r15
FFF0F477  45fe9e                            cmp     9Eh[r15], r14
FFF0F47A  2026                              beq.b   loc_FFF0F4A0
FFF0F47C  b18a                              movu.b  8+var_1[sp], r2
FFF0F47E  fb1e008000                        mov.l   #8000h, r1
FFF0F483  fd6221                            shll    r2, r1
FFF0F486  051e0afe                          bsr.a   sub_FFEEFEA4
FFF0F48A  b189                              movu.b  8+var_1[sp], r1
FFF0F48C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F492  4b1e                              add     r1, r14
FFF0F494  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F49A  4b1f                              add     r1, r15
FFF0F49C  c5fe9e9e                          mov.b   9Eh[r15], 9Eh[r14]
FFF0F4A0  b189                   loc_FFF0F4A0 movu.b  8+var_1[sp], r1
FFF0F4A2  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F4A8  4b1e                              add     r1, r14
FFF0F4AA  59eea1                            movu.b  0A1h[r14], r14
FFF0F4AD  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F4B3  4b1f                              add     r1, r15
FFF0F4B5  45fea1                            cmp     0A1h[r15], r14
FFF0F4B8  2026                              beq.b   loc_FFF0F4DE
FFF0F4BA  b18a                              movu.b  8+var_1[sp], r2
FFF0F4BC  fb1e008000                        mov.l   #8000h, r1
FFF0F4C1  fd6221                            shll    r2, r1
FFF0F4C4  05e009fe                          bsr.a   sub_FFEEFEA4
FFF0F4C8  b189                              movu.b  8+var_1[sp], r1
FFF0F4CA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F4D0  4b1e                              add     r1, r14
FFF0F4D2  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F4D8  4b1f                              add     r1, r15
FFF0F4DA  c5fea1a1                          mov.b   0A1h[r15], 0A1h[r14]
FFF0F4DE  b189                   loc_FFF0F4DE movu.b  8+var_1[sp], r1
FFF0F4E0  6211                              add     #1, r1
FFF0F4E2  8189                              mov.b   r1, 8+var_1[sp]
FFF0F4E4  b189                   loc_FFF0F4E4 movu.b  8+var_1[sp], r1
FFF0F4E6  6131                              cmp     #3, r1
FFF0F4E8  2805                              bge.b   loc_FFF0F4ED
FFF0F4EA  3878ff                            bra.w   loc_FFF0F462
FFF0F4ED  05a70dfe               loc_FFF0F4ED bsr.a   sub_FFEF0294
FFF0F4F1  6702                              rtsd    #2
FFF0F4F3  6040                   sub_FFF0F4F3 sub     #4, sp   ; <<<< FUNC sub_FFF0F4F3
FFF0F4F5  fbe2798d0000                      mov.l   #8D79h, r14
FFF0F4FB  f8e400                            mov.b   #0, [r14]
FFF0F4FE  6601                              mov.l   #0, r1
FFF0F500  ef12                              mov.l   r1, r2
FFF0F502  05060ffe                          bsr.a   sub_FFEF0408
FFF0F506  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0F509  2e19                              bra.b   loc_FFF0F522
FFF0F50B  b08b                   loc_FFF0F50B movu.b  4+var_1[sp], r3
FFF0F50D  ef3e                              mov.l   r3, r14
FFF0F50F  751e1e                            mul     #1Eh, r14
FFF0F512  71ee1e                            add     #1Eh, r14, r14
FFF0F515  5fe2                              movu.w  r14, r2
FFF0F517  6601                              mov.l   #0, r1
FFF0F519  392d00                            bsr.w   sub_FFF0F546
FFF0F51C  b089                              movu.b  4+var_1[sp], r1
FFF0F51E  6211                              add     #1, r1
FFF0F520  8089                              mov.b   r1, 4+var_1[sp]
FFF0F522  b089                   loc_FFF0F522 movu.b  4+var_1[sp], r1
FFF0F524  6151                              cmp     #5, r1
FFF0F526  29e5                              blt.b   loc_FFF0F50B
FFF0F528  7542b3                            mov.l   #-4Dh, r2
FFF0F52B  754122                            mov.l   #22h, r1 ; '"'
FFF0F52E  05d3a7fe                          bsr.a   sub_FFEF9D01
FFF0F532  6601                              mov.l   #0, r1
FFF0F534  05d12ffe                          bsr.a   sub_FFEF2505
FFF0F538  6611                              mov.l   #1, r1
FFF0F53A  05cb2ffe                          bsr.a   sub_FFEF2505
FFF0F53E  6621                              mov.l   #2, r1
FFF0F540  05c52ffe                          bsr.a   sub_FFEF2505
FFF0F544  6701                              rtsd    #1
FFF0F546  7100f0                 sub_FFF0F546 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF0F546
FFF0F549  9189                              mov.w   r1, 10h+var_2[sp]
FFF0F54B  9182                              mov.w   r2, 10h+var_4[sp]
FFF0F54D  828b                              mov.b   r3, 10h+var_5[sp]
FFF0F54F  b289                              movu.b  10h+var_5[sp], r1
FFF0F551  751114                            mul     #14h, r1
FFF0F554  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F55A  4b1e                              add     r1, r14
FFF0F55C  c5e03903                          mov.b   39h[r14], 10h+var_D[sp]
FFF0F560  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F566  c5e03702                          mov.b   37h[r14], 10h+var_E[sp]
FFF0F56A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F570  c5e03801                          mov.b   38h[r14], 10h+var_F[sp]
FFF0F574  b009                              movu.b  10h+var_F[sp], r1
FFF0F576  6141                              cmp     #4, r1
FFF0F578  2905                              blt.b   loc_FFF0F57D
FFF0F57A  3c0103                            mov.b   #3, 10h+var_F[sp]
FFF0F57D  b009                   loc_FFF0F57D movu.b  10h+var_F[sp], r1
FFF0F57F  6c41                              shll    #4, r1
FFF0F581  fb22a47aedff                      mov.l   #unk_FFED7AA4, r2
FFF0F587  4b12                              add     r1, r2
FFF0F589  a00a                              mov.l   r2, 10h+var_C[sp]
FFF0F58B  b981                              movu.w  10h+var_4[sp], r1
FFF0F58D  6211                              add     #1, r1
FFF0F58F  5f12                              movu.w  r1, r2
FFF0F591  75441d                            mov.l   #1Dh, r4
FFF0F594  fb3a3701                          mov.l   #137h, r3
FFF0F598  6601                              mov.l   #0, r1
FFF0F59A  055d0ffe                          bsr.a   sub_FFEF04F7
FFF0F59E  b089                              movu.b  10h+var_D[sp], r1
FFF0F5A0  6101                              cmp     #0, r1
FFF0F5A2  3ac700                            beq.w   loc_FFF0F669
FFF0F5A5  b081                              movu.b  10h+var_E[sp], r1
FFF0F5A7  45010b                            cmp     10h+var_5[sp], r1
FFF0F5AA  211d                              bne.b   loc_FFF0F5C7
FFF0F5AC  b981                              movu.w  10h+var_4[sp], r1
FFF0F5AE  6040                              sub     #4, sp
FFF0F5B0  f80980f9                          mov.w   #-680h, 14h+var_14[sp]
FFF0F5B4  6221                              add     #2, r1
FFF0F5B6  5f12                              movu.w  r1, r2
FFF0F5B8  75441c                            mov.l   #1Ch, r4
FFF0F5BB  fb3a2d01                          mov.l   #12Dh, r3
FFF0F5BF  6661                              mov.l   #6, r1
FFF0F5C1  058726fe                          bsr.a   sub_FFEF1C48
FFF0F5C5  6240                              add     #4, sp
FFF0F5C7  b089                   loc_FFF0F5C7 movu.b  10h+var_D[sp], r1
FFF0F5C9  6131                              cmp     #3, r1
FFF0F5CB  210c                              bne.b   loc_FFF0F5D7
FFF0F5CD  05980cfe                          bsr.a   sub_FFEF0265
FFF0F5D1  755110                            cmp     #10h, r1
FFF0F5D4  3a9500                            beq.w   loc_FFF0F669
FFF0F5D7  b089                   loc_FFF0F5D7 movu.b  10h+var_D[sp], r1
FFF0F5D9  6121                              cmp     #2, r1
FFF0F5DB  202e                              beq.b   loc_FFF0F609
FFF0F5DD  3d0717                            mov.w   #17h, 10h+var_2[sp]
FFF0F5E0  b982                              movu.w  10h+var_4[sp], r2
FFF0F5E2  b989                              movu.w  10h+var_2[sp], r1
FFF0F5E4  6242                              add     #4, r2
FFF0F5E6  5f22                              movu.w  r2, r2
FFF0F5E8  fb425c2eedff                      mov.l   #unk_FFED2E5C, r4
FFF0F5EE  6613                              mov.l   #1, r3
FFF0F5F0  05e572fe                          bsr.a   sub_FFEF68D5
FFF0F5F4  3d0733                            mov.w   #33h, 10h+var_2[sp] ; '3'
FFF0F5F7  a809                              mov.l   10h+var_C[sp], r1
FFF0F5F9  ec14                              mov.l   [r1], r4
FFF0F5FB  b982                              movu.w  10h+var_4[sp], r2
FFF0F5FD  b989                              movu.w  10h+var_2[sp], r1
FFF0F5FF  6242                              add     #4, r2
FFF0F601  5f22                              movu.w  r2, r2
FFF0F603  6613                              mov.l   #1, r3
FFF0F605  05d072fe                          bsr.a   sub_FFEF68D5
FFF0F609  3d074c                 loc_FFF0F609 mov.w   #4Ch, 10h+var_2[sp] ; 'L'
FFF0F60C  b28a                              movu.b  10h+var_5[sp], r2
FFF0F60E  b983                              movu.w  10h+var_4[sp], r3
FFF0F610  b989                              movu.w  10h+var_2[sp], r1
FFF0F612  60c0                              sub     #0Ch, sp
FFF0F614  751214                            mul     #14h, r2
FFF0F617  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF0F61D  4b24                              add     r2, r4
FFF0F61F  71443a                            add     #3Ah, r4, r4 ; ':'
FFF0F622  a00c                              mov.l   r4, 1Ch+var_18[sp]
FFF0F624  3c0801                            mov.b   #1, 1Ch+var_14[sp]
FFF0F627  f8040a                            mov.b   #0Ah, 1Ch+var_1C[sp]
FFF0F62A  6223                              add     #2, r3
FFF0F62C  5f32                              movu.w  r3, r2
FFF0F62E  6604                              mov.l   #0, r4
FFF0F630  66d3                              mov.l   #0Dh, r3
FFF0F632  05f124fe                          bsr.a   sub_FFEF1B23
FFF0F636  62c0                              add     #0Ch, sp
FFF0F638  3d07e6                            mov.w   #-1Ah, 10h+var_2[sp]
FFF0F63B  b28a                              movu.b  10h+var_5[sp], r2
FFF0F63D  b983                              movu.w  10h+var_4[sp], r3
FFF0F63F  b989                              movu.w  10h+var_2[sp], r1
FFF0F641  60c0                              sub     #0Ch, sp
FFF0F643  751214                            mul     #14h, r2
FFF0F646  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF0F64C  4b24                              add     r2, r4
FFF0F64E  714448                            add     #48h, r4, r4 ; 'H'
FFF0F651  a00c                              mov.l   r4, 1Ch+var_18[sp]
FFF0F653  3c0801                            mov.b   #1, 1Ch+var_14[sp]
FFF0F656  f80405                            mov.b   #5, 1Ch+var_1C[sp]
FFF0F659  6223                              add     #2, r3
FFF0F65B  5f32                              movu.w  r3, r2
FFF0F65D  6604                              mov.l   #0, r4
FFF0F65F  66d3                              mov.l   #0Dh, r3
FFF0F661  05c224fe                          bsr.a   sub_FFEF1B23
FFF0F665  62c0                              add     #0Ch, sp
FFF0F667  6704                              rtsd    #4
FFF0F669  6704                   loc_FFF0F669 rtsd    #4
FFF0F66B  fbe24c8c0000           sub_FFF0F66B mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF0F66B
FFF0F671  58ee                              movu.b  [r14], r14
FFF0F673  613e                              cmp     #3, r14
FFF0F675  2a16                              bgt.b   loc_FFF0F68B
FFF0F677  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0F67D  58ee                              movu.b  [r14], r14
FFF0F67F  fbf2a479edff                      mov.l   #off_FFED79A4, r15
FFF0F685  fe6efe                            mov.l   [r14, r15], r14
FFF0F688  7f1e                              jsr     r14
FFF0F68A  02                                rts
FFF0F68B  fbe24c8c0000           loc_FFF0F68B mov.l   #8C4Ch, r14
FFF0F691  f8e403                            mov.b   #3, [r14]
FFF0F694  02                                rts
FFF0F695  6611                   sub_FFF0F695 mov.l   #1, r1   ; <<<< FUNC sub_FFF0F695
FFF0F697  39f101                            bsr.w   sub_FFF0F888
FFF0F69A  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0F6A0  58ef                              movu.b  [r14], r15
FFF0F6A2  621f                              add     #1, r15
FFF0F6A4  c3ef                              mov.b   r15, [r14]
FFF0F6A6  02                                rts
FFF0F6A7  6040                   sub_FFF0F6A7 sub     #4, sp   ; <<<< FUNC sub_FFF0F6A7
FFF0F6A9  05840cfe                          bsr.a   sub_FFEF032D
FFF0F6AD  059ab0fe                          bsr.a   sub_FFEFA747
FFF0F6B1  3d0102                            mov.w   #2, 4+var_2[sp]
FFF0F6B4  f80505                            mov.w   #5, 4+var_4[sp]
FFF0F6B7  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F6BD  59ee21                            movu.b  21h[r14], r14
FFF0F6C0  610e                              cmp     #0, r14
FFF0F6C2  dc01                              mov.w   4+var_4[sp], r1
FFF0F6C4  980b                              mov.w   4+var_2[sp], r3
FFF0F6C6  2114                              bne.b   loc_FFF0F6DA
FFF0F6C8  5f12                              movu.w  r1, r2
FFF0F6CA  5f31                              movu.w  r3, r1
FFF0F6CC  fb42dc22edff                      mov.l   #unk_FFED22DC, r4
FFF0F6D2  6613                              mov.l   #1, r3
FFF0F6D4  050172fe                          bsr.a   sub_FFEF68D5
FFF0F6D8  2e16                              bra.b   loc_FFF0F6EE
FFF0F6DA  5f1e                   loc_FFF0F6DA movu.w  r1, r14
FFF0F6DC  621e                              add     #1, r14
FFF0F6DE  5fe2                              movu.w  r14, r2
FFF0F6E0  5f31                              movu.w  r3, r1
FFF0F6E2  fb425c20edff                      mov.l   #unk_FFED205C, r4
FFF0F6E8  6613                              mov.l   #1, r3
FFF0F6EA  05eb71fe                          bsr.a   sub_FFEF68D5
FFF0F6EE  3d0130                 loc_FFF0F6EE mov.w   #30h, 4+var_2[sp] ; '0'
FFF0F6F1  f80501                            mov.w   #1, 4+var_4[sp]
FFF0F6F4  fb12647aedff                      mov.l   #off_FFED7A64, r1
FFF0F6FA  ab14                              mov.l   30h[r1], r4
FFF0F6FC  5c02                              movu.w  4+var_4[sp], r2
FFF0F6FE  b809                              movu.w  4+var_2[sp], r1
FFF0F700  6613                              mov.l   #1, r3
FFF0F702  05d371fe                          bsr.a   sub_FFEF68D5
FFF0F706  b809                              movu.w  4+var_2[sp], r1
FFF0F708  71112a                            add     #2Ah, r1, r1 ; '*'
FFF0F70B  9009                              mov.w   r1, 4+var_2[sp]
FFF0F70D  5c02                              movu.w  4+var_4[sp], r2
FFF0F70F  b809                              movu.w  4+var_2[sp], r1
FFF0F711  60c0                              sub     #0Ch, sp
FFF0F713  fb32647aedff                      mov.l   #off_FFED7A64, r3
FFF0F719  713334                            add     #34h, r3, r3 ; '4'
FFF0F71C  a00b                              mov.l   r3, 10h+var_C[sp]
FFF0F71E  3c0801                            mov.b   #1, 10h+var_8[sp]
FFF0F721  f8040c                            mov.b   #0Ch, 10h+var_10[sp]
FFF0F724  6604                              mov.l   #0, r4
FFF0F726  66d3                              mov.l   #0Dh, r3
FFF0F728  05fb23fe                          bsr.a   sub_FFEF1B23
FFF0F72C  62c0                              add     #0Ch, sp
FFF0F72E  f8051e                            mov.w   #1Eh, 4+var_4[sp]
FFF0F731  5c01                              movu.w  4+var_4[sp], r1
FFF0F733  6602                              mov.l   #0, r2
FFF0F735  05390800                          bsr.a   sub_FFF0FF6E
FFF0F739  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0F73F  58ef                              movu.b  [r14], r15
FFF0F741  621f                              add     #1, r15
FFF0F743  c3ef                              mov.b   r15, [r14]
FFF0F745  6701                              rtsd    #1
FFF0F747  6040                   sub_FFF0F747 sub     #4, sp   ; <<<< FUNC sub_FFF0F747
FFF0F749  6040                              sub     #4, sp
FFF0F74B  3d00f0                            mov.w   #-10h, [sp]
FFF0F74E  fb4a4001                          mov.l   #140h, r4
FFF0F752  6602                              mov.l   #0, r2
FFF0F754  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F75A  ef23                              mov.l   r2, r3
FFF0F75C  055f02fe                          bsr.a   sub_FFEEF9BB
FFF0F760  6240                              add     #4, sp
FFF0F762  8089                              mov.b   r1, 4+var_1[sp]
FFF0F764  b089                              movu.b  4+var_1[sp], r1
FFF0F766  6111                              cmp     #1, r1
FFF0F768  1a                                bne.s   loc_FFF0F772
FFF0F769  39b101                            bsr.w   sub_FFF0F91A
FFF0F76C  05030cfe                          bsr.a   sub_FFEF036F
FFF0F770  6701                              rtsd    #1
FFF0F772  6701                   loc_FFF0F772 rtsd    #1
FFF0F774  6040                   sub_FFF0F774 sub     #4, sp   ; <<<< FUNC sub_FFF0F774
FFF0F776  6040                              sub     #4, sp
FFF0F778  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF0F77B  fb4a4001                          mov.l   #140h, r4
FFF0F77F  75431e                            mov.l   #1Eh, r3
FFF0F782  6602                              mov.l   #0, r2
FFF0F784  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F78A  053102fe                          bsr.a   sub_FFEEF9BB
FFF0F78E  6240                              add     #4, sp
FFF0F790  8089                              mov.b   r1, 4+var_1[sp]
FFF0F792  b089                              movu.b  4+var_1[sp], r1
FFF0F794  6111                              cmp     #1, r1
FFF0F796  2123                              bne.b   loc_FFF0F7B9
FFF0F798  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F79E  59e320                            movu.b  20h[r14], r3
FFF0F7A1  6040                              sub     #4, sp
FFF0F7A3  f80400                            mov.b   #0, 8+var_8[sp]
FFF0F7A6  75421e                            mov.l   #1Eh, r2
FFF0F7A9  6601                              mov.l   #0, r1
FFF0F7AB  ef14                              mov.l   r1, r4
FFF0F7AD  05c40500                          bsr.a   sub_FFF0FD71
FFF0F7B1  6240                              add     #4, sp
FFF0F7B3  05bc0bfe                          bsr.a   sub_FFEF036F
FFF0F7B7  6701                              rtsd    #1
FFF0F7B9  6701                   loc_FFF0F7B9 rtsd    #1
FFF0F7BB  6040                   sub_FFF0F7BB sub     #4, sp   ; <<<< FUNC sub_FFF0F7BB
FFF0F7BD  6040                              sub     #4, sp
FFF0F7BF  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF0F7C2  fb4a4001                          mov.l   #140h, r4
FFF0F7C6  75433c                            mov.l   #3Ch, r3 ; '<'
FFF0F7C9  6602                              mov.l   #0, r2
FFF0F7CB  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0F7D1  05ea01fe                          bsr.a   sub_FFEEF9BB
FFF0F7D5  6240                              add     #4, sp
FFF0F7D7  8089                              mov.b   r1, 4+var_1[sp]
FFF0F7D9  b089                              movu.b  4+var_1[sp], r1
FFF0F7DB  6111                              cmp     #1, r1
FFF0F7DD  2123                              bne.b   loc_FFF0F800
FFF0F7DF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F7E5  59e320                            movu.b  20h[r14], r3
FFF0F7E8  6040                              sub     #4, sp
FFF0F7EA  f80401                            mov.b   #1, 8+var_8[sp]
FFF0F7ED  6614                              mov.l   #1, r4
FFF0F7EF  75423c                            mov.l   #3Ch, r2 ; '<'
FFF0F7F2  6601                              mov.l   #0, r1
FFF0F7F4  057d0500                          bsr.a   sub_FFF0FD71
FFF0F7F8  6240                              add     #4, sp
FFF0F7FA  05750bfe                          bsr.a   sub_FFEF036F
FFF0F7FE  6701                              rtsd    #1
FFF0F800  6701                   loc_FFF0F800 rtsd    #1
FFF0F802  6040                   sub_FFF0F802 sub     #4, sp   ; <<<< FUNC sub_FFF0F802
FFF0F804  053b08fe                          bsr.a   sub_FFEF003F
FFF0F808  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F80E  c3e1                              mov.b   r1, [r14]
FFF0F810  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F816  58ee                              movu.b  [r14], r14
FFF0F818  755eff                            cmp     #-1, r14
FFF0F81B  1e                                bne.s   loc_FFF0F821
FFF0F81C  6601                              mov.l   #0, r1
FFF0F81E  396a00                            bsr.w   sub_FFF0F888
FFF0F821  fbe2738f0000           loc_FFF0F821 mov.l   #8F73h, r14
FFF0F827  58ee                              movu.b  [r14], r14
FFF0F829  755eff                            cmp     #-1, r14
FFF0F82C  2013                              beq.b   loc_FFF0F83F
FFF0F82E  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F834  58ee                              movu.b  [r14], r14
FFF0F836  755e10                            cmp     #10h, r14
FFF0F839  2406                              bgtu.b  loc_FFF0F83F
FFF0F83B  f80601                            mov.l   #1, 4+var_4[sp]
FFF0F83E  0c                                bra.s   loc_FFF0F842
FFF0F83F  f80600                 loc_FFF0F83F mov.l   #0, 4+var_4[sp]
FFF0F842  ec01                   loc_FFF0F842 mov.l   4+var_4[sp], r1
FFF0F844  6101                              cmp     #0, r1
FFF0F846  2029                              beq.b   loc_FFF0F86F
FFF0F848  053c03fe                          bsr.a   sub_FFEEFB84
FFF0F84C  6101                              cmp     #0, r1
FFF0F84E  2121                              bne.b   loc_FFF0F86F
FFF0F850  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F856  58e1                              movu.b  [r14], r1
FFF0F858  059207fe                          bsr.a   sub_FFEEFFEA
FFF0F85C  fbe2738f0000                      mov.l   #8F73h, r14
FFF0F862  58ee                              movu.b  [r14], r14
FFF0F864  fbf2b479edff                      mov.l   #off_FFED79B4, r15
FFF0F86A  fe6efe                            mov.l   [r14, r15], r14
FFF0F86D  7f1e                              jsr     r14
FFF0F86F  fbe24c8c0000           loc_FFF0F86F mov.l   #8C4Ch, r14
FFF0F875  58ee                              movu.b  [r14], r14
FFF0F877  614e                              cmp     #4, r14
FFF0F879  290d                              blt.b   loc_FFF0F886
FFF0F87B  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0F881  f8e403                            mov.b   #3, [r14]
FFF0F884  6701                              rtsd    #1
FFF0F886  6701                   loc_FFF0F886 rtsd    #1
FFF0F888  6040                   sub_FFF0F888 sub     #4, sp   ; <<<< FUNC sub_FFF0F888
FFF0F88A  8089                              mov.b   r1, 4+var_1[sp]
FFF0F88C  05dd47fe                          bsr.a   sub_FFEF4069
FFF0F890  391400                            bsr.w   sub_FFF0F8A4
FFF0F893  052748fe                          bsr.a   sub_FFEF40BA
FFF0F897  b089                              movu.b  4+var_1[sp], r1
FFF0F899  6111                              cmp     #1, r1
FFF0F89B  1f                                bne.s   loc_FFF0F8A2
FFF0F89C  059007fe                          bsr.a   sub_FFEF002C
FFF0F8A0  6701                              rtsd    #1
FFF0F8A2  6701                   loc_FFF0F8A2 rtsd    #1
FFF0F8A4  fbe2468e0000           sub_FFF0F8A4 mov.l   #8E46h, r14   ; <<<< FUNC sub_FFF0F8A4
FFF0F8AA  59ef20                            movu.b  20h[r14], r15
FFF0F8AD  641f                              and     #1, r15
FFF0F8AF  c7ef20                            mov.b   r15, 20h[r14]
FFF0F8B2  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F8B8  59ee20                            movu.b  20h[r14], r14
FFF0F8BB  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F8C1  45fe20                            cmp     20h[r15], r14
FFF0F8C4  2037                              beq.b   loc_FFF0F8FB
FFF0F8C6  fbe2468e0000                      mov.l   #8E46h, r14
FFF0F8CC  59ee20                            movu.b  20h[r14], r14
FFF0F8CF  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF0F8D5  59ff20                            movu.b  20h[r15], r15
FFF0F8D8  fb5e008000                        mov.l   #8000h, r5
FFF0F8DD  ef51                              mov.l   r5, r1
FFF0F8DF  fd62f1                            shll    r15, r1
FFF0F8E2  fd62e5                            shll    r14, r5
FFF0F8E5  5751                              or      r5, r1
FFF0F8E7  05bd05fe                          bsr.a   sub_FFEEFEA4
FFF0F8EB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F8F1  fbf2468e0000                      mov.l   #8E46h, r15
FFF0F8F7  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0F8FB  fb22468e0000           loc_FFF0F8FB mov.l   #8E46h, r2
FFF0F901  712221                            add     #21h, r2, r2 ; '!'
FFF0F904  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0F90A  711121                            add     #21h, r1, r1 ; '!'
FFF0F90D  6613                              mov.l   #1, r3
FFF0F90F  ef34                              mov.l   r3, r4
FFF0F911  057c27fe                          bsr.a   sub_FFEF208D
FFF0F915  057f09fe                          bsr.a   sub_FFEF0294
FFF0F919  02                                rts
FFF0F91A  6040                   sub_FFF0F91A sub     #4, sp   ; <<<< FUNC sub_FFF0F91A
FFF0F91C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0F922  c5e02003                          mov.b   20h[r14], 4+var_1[sp]
FFF0F926  fbe2798d0000                      mov.l   #8D79h, r14
FFF0F92C  f8e400                            mov.b   #0, [r14]
FFF0F92F  6601                              mov.l   #0, r1
FFF0F931  ef12                              mov.l   r1, r2
FFF0F933  05d50afe                          bsr.a   sub_FFEF0408
FFF0F937  b08b                              movu.b  4+var_1[sp], r3
FFF0F939  6040                              sub     #4, sp
FFF0F93B  f80400                            mov.b   #0, 8+var_8[sp]
FFF0F93E  75421e                            mov.l   #1Eh, r2
FFF0F941  6601                              mov.l   #0, r1
FFF0F943  ef14                              mov.l   r1, r4
FFF0F945  052c0400                          bsr.a   sub_FFF0FD71
FFF0F949  6240                              add     #4, sp
FFF0F94B  b08b                              movu.b  4+var_1[sp], r3
FFF0F94D  6040                              sub     #4, sp
FFF0F94F  f80401                            mov.b   #1, 8+var_8[sp]
FFF0F952  6614                              mov.l   #1, r4
FFF0F954  75423c                            mov.l   #3Ch, r2 ; '<'
FFF0F957  6601                              mov.l   #0, r1
FFF0F959  05180400                          bsr.a   sub_FFF0FD71
FFF0F95D  6240                              add     #4, sp
FFF0F95F  6701                              rtsd    #1
FFF0F961  fbe24c8c0000           sub_FFF0F961 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF0F961
FFF0F967  58ee                              movu.b  [r14], r14
FFF0F969  613e                              cmp     #3, r14
FFF0F96B  2a16                              bgt.b   loc_FFF0F981
FFF0F96D  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0F973  58ee                              movu.b  [r14], r14
FFF0F975  fbf2f879edff                      mov.l   #off_FFED79F8, r15
FFF0F97B  fe6efe                            mov.l   [r14, r15], r14
FFF0F97E  7f1e                              jsr     r14
FFF0F980  02                                rts
FFF0F981  fbe24c8c0000           loc_FFF0F981 mov.l   #8C4Ch, r14
FFF0F987  f8e403                            mov.b   #3, [r14]
FFF0F98A  02                                rts
FFF0F98B  6611                   sub_FFF0F98B mov.l   #1, r1   ; <<<< FUNC sub_FFF0F98B
FFF0F98D  397e01                            bsr.w   sub_FFF0FB0B
FFF0F990  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0F996  58ef                              movu.b  [r14], r15
FFF0F998  621f                              add     #1, r15
FFF0F99A  c3ef                              mov.b   r15, [r14]
FFF0F99C  02                                rts
FFF0F99D  6040                   sub_FFF0F99D sub     #4, sp   ; <<<< FUNC sub_FFF0F99D
FFF0F99F  058e09fe                          bsr.a   sub_FFEF032D
FFF0F9A3  05a4adfe                          bsr.a   sub_FFEFA747
FFF0F9A7  3d0102                            mov.w   #2, 4+var_2[sp]
FFF0F9AA  f80504                            mov.w   #4, 4+var_4[sp]
FFF0F9AD  5c02                              movu.w  4+var_4[sp], r2
FFF0F9AF  b809                              movu.w  4+var_2[sp], r1
FFF0F9B1  fb42dc22edff                      mov.l   #unk_FFED22DC, r4
FFF0F9B7  6613                              mov.l   #1, r3
FFF0F9B9  051c6ffe                          bsr.a   sub_FFEF68D5
FFF0F9BD  3d0132                            mov.w   #32h, 4+var_2[sp] ; '2'
FFF0F9C0  5c02                              movu.w  4+var_4[sp], r2
FFF0F9C2  b809                              movu.w  4+var_2[sp], r1
FFF0F9C4  fb42bc22edff                      mov.l   #unk_FFED22BC, r4
FFF0F9CA  6613                              mov.l   #1, r3
FFF0F9CC  05096ffe                          bsr.a   sub_FFEF68D5
FFF0F9D0  3d015a                            mov.w   #5Ah, 4+var_2[sp] ; 'Z'
FFF0F9D3  f80502                            mov.w   #2, 4+var_4[sp]
FFF0F9D6  5c02                              movu.w  4+var_4[sp], r2
FFF0F9D8  b809                              movu.w  4+var_2[sp], r1
FFF0F9DA  60c0                              sub     #0Ch, sp
FFF0F9DC  fb3271e8c3ff                      mov.l   #aLocalNews, r3; "LOCAL NEWS"
FFF0F9E2  a00b                              mov.l   r3, 10h+var_C[sp]
FFF0F9E4  3c0801                            mov.b   #1, 10h+var_8[sp]
FFF0F9E7  f8040a                            mov.b   #0Ah, 10h+var_10[sp]
FFF0F9EA  6604                              mov.l   #0, r4
FFF0F9EC  66d3                              mov.l   #0Dh, r3
FFF0F9EE  053521fe                          bsr.a   sub_FFEF1B23
FFF0F9F2  62c0                              add     #0Ch, sp
FFF0F9F4  f8051e                            mov.w   #1Eh, 4+var_4[sp]
FFF0F9F7  5c01                              movu.w  4+var_4[sp], r1
FFF0F9F9  6602                              mov.l   #0, r2
FFF0F9FB  397305                            bsr.w   sub_FFF0FF6E
FFF0F9FE  6661                              mov.l   #6, r1
FFF0FA00  058fa4fe                          bsr.a   sub_FFEF9E8F
FFF0FA04  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0FA0A  58ef                              movu.b  [r14], r15
FFF0FA0C  621f                              add     #1, r15
FFF0FA0E  c3ef                              mov.b   r15, [r14]
FFF0FA10  6701                              rtsd    #1
FFF0FA12  6040                   sub_FFF0FA12 sub     #4, sp   ; <<<< FUNC sub_FFF0FA12
FFF0FA14  6040                              sub     #4, sp
FFF0FA16  3d00f0                            mov.w   #-10h, [sp]
FFF0FA19  fb4a4001                          mov.l   #140h, r4
FFF0FA1D  6602                              mov.l   #0, r2
FFF0FA1F  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0FA25  ef23                              mov.l   r2, r3
FFF0FA27  0594fffd                          bsr.a   sub_FFEEF9BB
FFF0FA2B  6240                              add     #4, sp
FFF0FA2D  8089                              mov.b   r1, 4+var_1[sp]
FFF0FA2F  b089                              movu.b  4+var_1[sp], r1
FFF0FA31  6111                              cmp     #1, r1
FFF0FA33  1a                                bne.s   loc_FFF0FA3D
FFF0FA34  394f02                            bsr.w   sub_FFF0FC83
FFF0FA37  053809fe                          bsr.a   sub_FFEF036F
FFF0FA3B  6701                              rtsd    #1
FFF0FA3D  6701                   loc_FFF0FA3D rtsd    #1
FFF0FA3F  6040                   sub_FFF0FA3F sub     #4, sp   ; <<<< FUNC sub_FFF0FA3F
FFF0FA41  fbe2738f0000                      mov.l   #8F73h, r14
FFF0FA47  58e1                              movu.b  [r14], r1
FFF0FA49  60f1                              sub     #0Fh, r1
FFF0FA4B  8081                              mov.b   r1, 4+var_2[sp]
FFF0FA4D  b081                              movu.b  4+var_2[sp], r1
FFF0FA4F  75111e                            mul     #1Eh, r1
FFF0FA52  71111e                            add     #1Eh, r1, r1
FFF0FA55  d301                              mov.w   r1, 4+var_4[sp]
FFF0FA57  5c03                              movu.w  4+var_4[sp], r3
FFF0FA59  6040                              sub     #4, sp
FFF0FA5B  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF0FA5E  fb4a4001                          mov.l   #140h, r4
FFF0FA62  6602                              mov.l   #0, r2
FFF0FA64  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0FA6A  0551fffd                          bsr.a   sub_FFEEF9BB
FFF0FA6E  6240                              add     #4, sp
FFF0FA70  8089                              mov.b   r1, 4+var_1[sp]
FFF0FA72  b089                              movu.b  4+var_1[sp], r1
FFF0FA74  6111                              cmp     #1, r1
FFF0FA76  210d                              bne.b   loc_FFF0FA83
FFF0FA78  b081                              movu.b  4+var_2[sp], r1
FFF0FA7A  394602                            bsr.w   sub_FFF0FCC0
FFF0FA7D  05f208fe                          bsr.a   sub_FFEF036F
FFF0FA81  6701                              rtsd    #1
FFF0FA83  6701                   loc_FFF0FA83 rtsd    #1
FFF0FA85  6040                   sub_FFF0FA85 sub     #4, sp   ; <<<< FUNC sub_FFF0FA85
FFF0FA87  05b805fe                          bsr.a   sub_FFEF003F
FFF0FA8B  fbe2738f0000                      mov.l   #8F73h, r14
FFF0FA91  c3e1                              mov.b   r1, [r14]
FFF0FA93  fbe2738f0000                      mov.l   #8F73h, r14
FFF0FA99  58ee                              movu.b  [r14], r14
FFF0FA9B  755eff                            cmp     #-1, r14
FFF0FA9E  1e                                bne.s   loc_FFF0FAA4
FFF0FA9F  6601                              mov.l   #0, r1
FFF0FAA1  396a00                            bsr.w   sub_FFF0FB0B
FFF0FAA4  fbe2738f0000           loc_FFF0FAA4 mov.l   #8F73h, r14
FFF0FAAA  58ee                              movu.b  [r14], r14
FFF0FAAC  755eff                            cmp     #-1, r14
FFF0FAAF  2013                              beq.b   loc_FFF0FAC2
FFF0FAB1  fbe2738f0000                      mov.l   #8F73h, r14
FFF0FAB7  58ee                              movu.b  [r14], r14
FFF0FAB9  755e16                            cmp     #16h, r14
FFF0FABC  2406                              bgtu.b  loc_FFF0FAC2
FFF0FABE  f80601                            mov.l   #1, 4+var_4[sp]
FFF0FAC1  0c                                bra.s   loc_FFF0FAC5
FFF0FAC2  f80600                 loc_FFF0FAC2 mov.l   #0, 4+var_4[sp]
FFF0FAC5  ec01                   loc_FFF0FAC5 mov.l   4+var_4[sp], r1
FFF0FAC7  6101                              cmp     #0, r1
FFF0FAC9  2029                              beq.b   loc_FFF0FAF2
FFF0FACB  05b900fe                          bsr.a   sub_FFEEFB84
FFF0FACF  6101                              cmp     #0, r1
FFF0FAD1  2121                              bne.b   loc_FFF0FAF2
FFF0FAD3  fbe2738f0000                      mov.l   #8F73h, r14
FFF0FAD9  58e1                              movu.b  [r14], r1
FFF0FADB  050f05fe                          bsr.a   sub_FFEEFFEA
FFF0FADF  fbe2738f0000                      mov.l   #8F73h, r14
FFF0FAE5  58ee                              movu.b  [r14], r14
FFF0FAE7  fbf2087aedff                      mov.l   #off_FFED7A08, r15
FFF0FAED  fe6efe                            mov.l   [r14, r15], r14
FFF0FAF0  7f1e                              jsr     r14
FFF0FAF2  fbe24c8c0000           loc_FFF0FAF2 mov.l   #8C4Ch, r14
FFF0FAF8  58ee                              movu.b  [r14], r14
FFF0FAFA  614e                              cmp     #4, r14
FFF0FAFC  290d                              blt.b   loc_FFF0FB09
FFF0FAFE  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0FB04  f8e403                            mov.b   #3, [r14]
FFF0FB07  6701                              rtsd    #1
FFF0FB09  6701                   loc_FFF0FB09 rtsd    #1
FFF0FB0B  6040                   sub_FFF0FB0B sub     #4, sp   ; <<<< FUNC sub_FFF0FB0B
FFF0FB0D  8089                              mov.b   r1, 4+var_1[sp]
FFF0FB0F  055a45fe                          bsr.a   sub_FFEF4069
FFF0FB13  391400                            bsr.w   sub_FFF0FB27
FFF0FB16  05a445fe                          bsr.a   sub_FFEF40BA
FFF0FB1A  b089                              movu.b  4+var_1[sp], r1
FFF0FB1C  6111                              cmp     #1, r1
FFF0FB1E  1f                                bne.s   loc_FFF0FB25
FFF0FB1F  050d05fe                          bsr.a   sub_FFEF002C
FFF0FB23  6701                              rtsd    #1
FFF0FB25  6701                   loc_FFF0FB25 rtsd    #1
FFF0FB27  6040                   sub_FFF0FB27 sub     #4, sp   ; <<<< FUNC sub_FFF0FB27
FFF0FB29  fbe2468e0000                      mov.l   #8E46h, r14
FFF0FB2F  59ef20                            movu.b  20h[r14], r15
FFF0FB32  eff5                              mov.l   r15, r5
FFF0FB34  fd749505                          divu    #5, r5
FFF0FB38  6355                              mul     #5, r5
FFF0FB3A  435f                              sub     r5, r15
FFF0FB3C  c7ef20                            mov.b   r15, 20h[r14]
FFF0FB3F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FB45  59ee20                            movu.b  20h[r14], r14
FFF0FB48  fbf2468e0000                      mov.l   #8E46h, r15
FFF0FB4E  45fe20                            cmp     20h[r15], r14
FFF0FB51  2037                              beq.b   loc_FFF0FB88
FFF0FB53  fbe2468e0000                      mov.l   #8E46h, r14
FFF0FB59  59ee20                            movu.b  20h[r14], r14
FFF0FB5C  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF0FB62  59ff20                            movu.b  20h[r15], r15
FFF0FB65  fb5e008000                        mov.l   #8000h, r5
FFF0FB6A  ef51                              mov.l   r5, r1
FFF0FB6C  fd62f1                            shll    r15, r1
FFF0FB6F  fd62e5                            shll    r14, r5
FFF0FB72  5751                              or      r5, r1
FFF0FB74  053003fe                          bsr.a   sub_FFEEFEA4
FFF0FB78  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FB7E  fbf2468e0000                      mov.l   #8E46h, r15
FFF0FB84  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF0FB88  3c0300                 loc_FFF0FB88 mov.b   #0, 4+var_1[sp]
FFF0FB8B  2e5b                              bra.b   loc_FFF0FBE6
FFF0FB8D  b08b                   loc_FFF0FB8D movu.b  4+var_1[sp], r3
FFF0FB8F  fb4e008000                        mov.l   #8000h, r4
FFF0FB94  fd6234                            shll    r3, r4
FFF0FB97  751318                            mul     #18h, r3
FFF0FB9A  fb22468e0000                      mov.l   #8E46h, r2
FFF0FBA0  4b32                              add     r3, r2
FFF0FBA2  712221                            add     #21h, r2, r2 ; '!'
FFF0FBA5  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0FBAB  4b31                              add     r3, r1
FFF0FBAD  711121                            add     #21h, r1, r1 ; '!'
FFF0FBB0  6613                              mov.l   #1, r3
FFF0FBB2  05db24fe                          bsr.a   sub_FFEF208D
FFF0FBB6  b08b                              movu.b  4+var_1[sp], r3
FFF0FBB8  fb4e008000                        mov.l   #8000h, r4
FFF0FBBD  fd6234                            shll    r3, r4
FFF0FBC0  751318                            mul     #18h, r3
FFF0FBC3  fb22468e0000                      mov.l   #8E46h, r2
FFF0FBC9  4b32                              add     r3, r2
FFF0FBCB  712222                            add     #22h, r2, r2 ; '"'
FFF0FBCE  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0FBD4  4b31                              add     r3, r1
FFF0FBD6  711122                            add     #22h, r1, r1 ; '"'
FFF0FBD9  754317                            mov.l   #17h, r3
FFF0FBDC  05b124fe                          bsr.a   sub_FFEF208D
FFF0FBE0  b089                              movu.b  4+var_1[sp], r1
FFF0FBE2  6211                              add     #1, r1
FFF0FBE4  8089                              mov.b   r1, 4+var_1[sp]
FFF0FBE6  b089                   loc_FFF0FBE6 movu.b  4+var_1[sp], r1
FFF0FBE8  6151                              cmp     #5, r1
FFF0FBEA  29a3                              blt.b   loc_FFF0FB8D
FFF0FBEC  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0FBEF  388500                            bra.w   loc_FFF0FC74
FFF0FBF2  b089                   loc_FFF0FBF2 movu.b  4+var_1[sp], r1
FFF0FBF4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FBFA  4b1e                              add     r1, r14
FFF0FBFC  59ee99                            movu.b  99h[r14], r14
FFF0FBFF  fbf2468e0000                      mov.l   #8E46h, r15
FFF0FC05  4b1f                              add     r1, r15
FFF0FC07  45fe99                            cmp     99h[r15], r14
FFF0FC0A  2026                              beq.b   loc_FFF0FC30
FFF0FC0C  b08a                              movu.b  4+var_1[sp], r2
FFF0FC0E  fb1e000010                        mov.l   #100000h, r1
FFF0FC13  fd6221                            shll    r2, r1
FFF0FC16  058e02fe                          bsr.a   sub_FFEEFEA4
FFF0FC1A  b089                              movu.b  4+var_1[sp], r1
FFF0FC1C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FC22  4b1e                              add     r1, r14
FFF0FC24  fbf2468e0000                      mov.l   #8E46h, r15
FFF0FC2A  4b1f                              add     r1, r15
FFF0FC2C  c5fe9999                          mov.b   99h[r15], 99h[r14]
FFF0FC30  b089                   loc_FFF0FC30 movu.b  4+var_1[sp], r1
FFF0FC32  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FC38  4b1e                              add     r1, r14
FFF0FC3A  59ee9c                            movu.b  9Ch[r14], r14
FFF0FC3D  fbf2468e0000                      mov.l   #8E46h, r15
FFF0FC43  4b1f                              add     r1, r15
FFF0FC45  45fe9c                            cmp     9Ch[r15], r14
FFF0FC48  2026                              beq.b   loc_FFF0FC6E
FFF0FC4A  b08a                              movu.b  4+var_1[sp], r2
FFF0FC4C  fb1e000010                        mov.l   #100000h, r1
FFF0FC51  fd6221                            shll    r2, r1
FFF0FC54  055002fe                          bsr.a   sub_FFEEFEA4
FFF0FC58  b089                              movu.b  4+var_1[sp], r1
FFF0FC5A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FC60  4b1e                              add     r1, r14
FFF0FC62  fbf2468e0000                      mov.l   #8E46h, r15
FFF0FC68  4b1f                              add     r1, r15
FFF0FC6A  c5fe9c9c                          mov.b   9Ch[r15], 9Ch[r14]
FFF0FC6E  b089                   loc_FFF0FC6E movu.b  4+var_1[sp], r1
FFF0FC70  6211                              add     #1, r1
FFF0FC72  8089                              mov.b   r1, 4+var_1[sp]
FFF0FC74  b089                   loc_FFF0FC74 movu.b  4+var_1[sp], r1
FFF0FC76  6131                              cmp     #3, r1
FFF0FC78  2805                              bge.b   loc_FFF0FC7D
FFF0FC7A  3878ff                            bra.w   loc_FFF0FBF2
FFF0FC7D  051706fe               loc_FFF0FC7D bsr.a   sub_FFEF0294
FFF0FC81  6701                              rtsd    #1
FFF0FC83  6040                   sub_FFF0FC83 sub     #4, sp   ; <<<< FUNC sub_FFF0FC83
FFF0FC85  fbe2798d0000                      mov.l   #8D79h, r14
FFF0FC8B  f8e400                            mov.b   #0, [r14]
FFF0FC8E  6601                              mov.l   #0, r1
FFF0FC90  ef12                              mov.l   r1, r2
FFF0FC92  057607fe                          bsr.a   sub_FFEF0408
FFF0FC96  3c0300                            mov.b   #0, 4+var_1[sp]
FFF0FC99  2e0d                              bra.b   loc_FFF0FCA6
FFF0FC9B  b089                   loc_FFF0FC9B movu.b  4+var_1[sp], r1
FFF0FC9D  392300                            bsr.w   sub_FFF0FCC0
FFF0FCA0  b089                              movu.b  4+var_1[sp], r1
FFF0FCA2  6211                              add     #1, r1
FFF0FCA4  8089                              mov.b   r1, 4+var_1[sp]
FFF0FCA6  b089                   loc_FFF0FCA6 movu.b  4+var_1[sp], r1
FFF0FCA8  6151                              cmp     #5, r1
FFF0FCAA  29f1                              blt.b   loc_FFF0FC9B
FFF0FCAC  6601                              mov.l   #0, r1
FFF0FCAE  055728fe                          bsr.a   sub_FFEF2505
FFF0FCB2  6611                              mov.l   #1, r1
FFF0FCB4  055128fe                          bsr.a   sub_FFEF2505
FFF0FCB8  6621                              mov.l   #2, r1
FFF0FCBA  054b28fe                          bsr.a   sub_FFEF2505
FFF0FCBE  6701                              rtsd    #1
FFF0FCC0  6080                   sub_FFF0FCC0 sub     #8, sp   ; <<<< FUNC sub_FFF0FCC0
FFF0FCC2  8189                              mov.b   r1, 8+var_1[sp]
FFF0FCC4  3d0206                            mov.w   #6, 8+var_4[sp]
FFF0FCC7  b189                              movu.b  8+var_1[sp], r1
FFF0FCC9  75111e                            mul     #1Eh, r1
FFF0FCCC  71111e                            add     #1Eh, r1, r1
FFF0FCCF  9009                              mov.w   r1, 8+var_6[sp]
FFF0FCD1  b189                              movu.b  8+var_1[sp], r1
FFF0FCD3  751118                            mul     #18h, r1
FFF0FCD6  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FCDC  4b1e                              add     r1, r14
FFF0FCDE  c5e02101                          mov.b   21h[r14], 8+var_7[sp]
FFF0FCE2  b809                              movu.w  8+var_6[sp], r1
FFF0FCE4  6211                              add     #1, r1
FFF0FCE6  5f12                              movu.w  r1, r2
FFF0FCE8  75441d                            mov.l   #1Dh, r4
FFF0FCEB  fb3a4001                          mov.l   #140h, r3
FFF0FCEF  6601                              mov.l   #0, r1
FFF0FCF1  050608fe                          bsr.a   sub_FFEF04F7
FFF0FCF5  b009                              movu.b  8+var_7[sp], r1
FFF0FCF7  6111                              cmp     #1, r1
FFF0FCF9  216f                              bne.b   loc_FFF0FD68
FFF0FCFB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FD01  c1e020                            mov.b   20h[r14], 8+var_8[sp]
FFF0FD04  5801                              movu.b  8+var_8[sp], r1
FFF0FD06  450107                            cmp     8+var_1[sp], r1
FFF0FD09  211d                              bne.b   loc_FFF0FD26
FFF0FD0B  b809                              movu.w  8+var_6[sp], r1
FFF0FD0D  6040                              sub     #4, sp
FFF0FD0F  f80980f9                          mov.w   #-680h, 0Ch+var_C[sp]
FFF0FD13  6221                              add     #2, r1
FFF0FD15  5f12                              movu.w  r1, r2
FFF0FD17  75441c                            mov.l   #1Ch, r4
FFF0FD1A  fb3a3401                          mov.l   #134h, r3
FFF0FD1E  6661                              mov.l   #6, r1
FFF0FD20  05281ffe                          bsr.a   sub_FFEF1C48
FFF0FD24  6240                              add     #4, sp
FFF0FD26  b18a                   loc_FFF0FD26 movu.b  8+var_1[sp], r2
FFF0FD28  b80b                              movu.w  8+var_6[sp], r3
FFF0FD2A  b881                              movu.w  8+var_4[sp], r1
FFF0FD2C  60c0                              sub     #0Ch, sp
FFF0FD2E  751218                            mul     #18h, r2
FFF0FD31  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF0FD37  4b24                              add     r2, r4
FFF0FD39  714422                            add     #22h, r4, r4 ; '"'
FFF0FD3C  a00c                              mov.l   r4, 14h+var_10[sp]
FFF0FD3E  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF0FD41  f80416                            mov.b   #16h, 14h+var_14[sp]
FFF0FD44  6223                              add     #2, r3
FFF0FD46  5f32                              movu.w  r3, r2
FFF0FD48  6604                              mov.l   #0, r4
FFF0FD4A  66d3                              mov.l   #0Dh, r3
FFF0FD4C  05d71dfe                          bsr.a   sub_FFEF1B23
FFF0FD50  62c0                              add     #0Ch, sp
FFF0FD52  b189                              movu.b  8+var_1[sp], r1
FFF0FD54  6131                              cmp     #3, r1
FFF0FD56  2a12                              bgt.b   loc_FFF0FD68
FFF0FD58  b809                              movu.w  8+var_6[sp], r1
FFF0FD5A  71111e                            add     #1Eh, r1, r1
FFF0FD5D  9009                              mov.w   r1, 8+var_6[sp]
FFF0FD5F  b809                              movu.w  8+var_6[sp], r1
FFF0FD61  6602                              mov.l   #0, r2
FFF0FD63  390b02                            bsr.w   sub_FFF0FF6E
FFF0FD66  6702                              rtsd    #2
FFF0FD68  6702                   loc_FFF0FD68 rtsd    #2
FFF0FD6A  754114                 sub_FFF0FD6A mov.l   #14h, r1   ; <<<< FUNC sub_FFF0FD6A
FFF0FD6D  398d01                            bsr.w   sub_FFF0FEFA
FFF0FD70  02                                rts
FFF0FD71  7100f0                 sub_FFF0FD71 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF0FD71
FFF0FD74  9189                              mov.w   r1, 10h+var_2[sp]
FFF0FD76  9182                              mov.w   r2, 10h+var_4[sp]
FFF0FD78  828b                              mov.b   r3, 10h+var_5[sp]
FFF0FD7A  8284                              mov.b   r4, 10h+var_6[sp]
FFF0FD7C  c5001409                          mov.b   10h+arg_0[sp], 10h+var_7[sp]
FFF0FD80  b209                              movu.b  10h+var_7[sp], r1
FFF0FD82  6c41                              shll    #4, r1
FFF0FD84  fb22647aedff                      mov.l   #off_FFED7A64, r2
FFF0FD8A  4b12                              add     r1, r2
FFF0FD8C  a00a                              mov.l   r2, 10h+var_C[sp]
FFF0FD8E  b981                              movu.w  10h+var_4[sp], r1
FFF0FD90  6211                              add     #1, r1
FFF0FD92  5f12                              movu.w  r1, r2
FFF0FD94  75441d                            mov.l   #1Dh, r4
FFF0FD97  fb3a4001                          mov.l   #140h, r3
FFF0FD9B  6601                              mov.l   #0, r1
FFF0FD9D  055a07fe                          bsr.a   sub_FFEF04F7
FFF0FDA1  b289                              movu.b  10h+var_5[sp], r1
FFF0FDA3  45010a                            cmp     10h+var_6[sp], r1
FFF0FDA6  211d                              bne.b   loc_FFF0FDC3
FFF0FDA8  b981                              movu.w  10h+var_4[sp], r1
FFF0FDAA  6040                              sub     #4, sp
FFF0FDAC  f80980f9                          mov.w   #-680h, 14h+var_14[sp]
FFF0FDB0  6221                              add     #2, r1
FFF0FDB2  5f12                              movu.w  r1, r2
FFF0FDB4  75441c                            mov.l   #1Ch, r4
FFF0FDB7  fb3a3401                          mov.l   #134h, r3
FFF0FDBB  6661                              mov.l   #6, r1
FFF0FDBD  058b1efe                          bsr.a   sub_FFEF1C48
FFF0FDC1  6240                              add     #4, sp
FFF0FDC3  3d0732                 loc_FFF0FDC3 mov.w   #32h, 10h+var_2[sp] ; '2'
FFF0FDC6  b209                              movu.b  10h+var_7[sp], r1
FFF0FDC8  6101                              cmp     #0, r1
FFF0FDCA  210c                              bne.b   loc_FFF0FDD6
FFF0FDCC  b289                              movu.b  10h+var_5[sp], r1
FFF0FDCE  45010a                            cmp     10h+var_6[sp], r1
FFF0FDD1  1d                                bne.s   loc_FFF0FDD6
FFF0FDD2  f80601                            mov.l   #1, 10h+var_10[sp]
FFF0FDD5  0c                                bra.s   loc_FFF0FDD9
FFF0FDD6  f80600                 loc_FFF0FDD6 mov.l   #0, 10h+var_10[sp]
FFF0FDD9  b981                   loc_FFF0FDD9 movu.w  10h+var_4[sp], r1
FFF0FDDB  6241                              add     #4, r1
FFF0FDDD  ec02                              mov.l   10h+var_10[sp], r2
FFF0FDDF  6102                              cmp     #0, r2
FFF0FDE1  998b                              mov.w   10h+var_2[sp], r3
FFF0FDE3  2014                              beq.b   loc_FFF0FDF7
FFF0FDE5  5f12                              movu.w  r1, r2
FFF0FDE7  5f31                              movu.w  r3, r1
FFF0FDE9  fb42ac3dedff                      mov.l   #unk_FFED3DAC, r4
FFF0FDEF  6613                              mov.l   #1, r3
FFF0FDF1  05e46afe                          bsr.a   sub_FFEF68D5
FFF0FDF5  2e10                              bra.b   loc_FFF0FE05
FFF0FDF7  a80a                   loc_FFF0FDF7 mov.l   10h+var_C[sp], r2
FFF0FDF9  ec24                              mov.l   [r2], r4
FFF0FDFB  5f12                              movu.w  r1, r2
FFF0FDFD  5f31                              movu.w  r3, r1
FFF0FDFF  6613                              mov.l   #1, r3
FFF0FE01  05d46afe                          bsr.a   sub_FFEF68D5
FFF0FE05  3d075a                 loc_FFF0FE05 mov.w   #5Ah, 10h+var_2[sp] ; 'Z'
FFF0FE08  a80a                              mov.l   10h+var_C[sp], r2
FFF0FE0A  b983                              movu.w  10h+var_4[sp], r3
FFF0FE0C  b989                              movu.w  10h+var_2[sp], r1
FFF0FE0E  60c0                              sub     #0Ch, sp
FFF0FE10  6242                              add     #4, r2
FFF0FE12  a00a                              mov.l   r2, 1Ch+var_18[sp]
FFF0FE14  3c0801                            mov.b   #1, 1Ch+var_14[sp]
FFF0FE17  f8040c                            mov.b   #0Ch, 1Ch+var_1C[sp]
FFF0FE1A  6223                              add     #2, r3
FFF0FE1C  5f32                              movu.w  r3, r2
FFF0FE1E  6604                              mov.l   #0, r4
FFF0FE20  66d3                              mov.l   #0Dh, r3
FFF0FE22  05011dfe                          bsr.a   sub_FFEF1B23
FFF0FE26  62c0                              add     #0Ch, sp
FFF0FE28  b209                              movu.b  10h+var_7[sp], r1
FFF0FE2A  6131                              cmp     #3, r1
FFF0FE2C  16                                beq.s   loc_FFF0FE32
FFF0FE2D  b209                              movu.b  10h+var_7[sp], r1
FFF0FE2F  6121                              cmp     #2, r1
FFF0FE31  1d                                bne.s   loc_FFF0FE36
FFF0FE32  f80601                 loc_FFF0FE32 mov.l   #1, 10h+var_10[sp]
FFF0FE35  0c                                bra.s   loc_FFF0FE39
FFF0FE36  f80600                 loc_FFF0FE36 mov.l   #0, 10h+var_10[sp]
FFF0FE39  ec01                   loc_FFF0FE39 mov.l   10h+var_10[sp], r1
FFF0FE3B  6101                              cmp     #0, r1
FFF0FE3D  10                                beq.s   loc_FFF0FE45
FFF0FE3E  b981                              movu.w  10h+var_4[sp], r1
FFF0FE40  6602                              mov.l   #0, r2
FFF0FE42  392c01                            bsr.w   sub_FFF0FF6E
FFF0FE45  b209                   loc_FFF0FE45 movu.b  10h+var_7[sp], r1
FFF0FE47  6131                              cmp     #3, r1
FFF0FE49  2012                              beq.b   loc_FFF0FE5B
FFF0FE4B  b981                              movu.w  10h+var_4[sp], r1
FFF0FE4D  71111e                            add     #1Eh, r1, r1
FFF0FE50  9181                              mov.w   r1, 10h+var_4[sp]
FFF0FE52  b981                              movu.w  10h+var_4[sp], r1
FFF0FE54  6602                              mov.l   #0, r2
FFF0FE56  391801                            bsr.w   sub_FFF0FF6E
FFF0FE59  6704                              rtsd    #4
FFF0FE5B  6704                   loc_FFF0FE5B rtsd    #4
FFF0FE5D  7100f0                 sub_FFF0FE5D add     #-10h, sp, sp   ; <<<< FUNC sub_FFF0FE5D
FFF0FE60  9189                              mov.w   r1, 10h+var_2[sp]
FFF0FE62  9182                              mov.w   r2, 10h+var_4[sp]
FFF0FE64  828b                              mov.b   r3, 10h+var_5[sp]
FFF0FE66  8284                              mov.b   r4, 10h+var_6[sp]
FFF0FE68  e5000501                          mov.l   10h+arg_0[sp], 10h+var_C[sp]
FFF0FE6C  b981                              movu.w  10h+var_4[sp], r1
FFF0FE6E  6211                              add     #1, r1
FFF0FE70  5f12                              movu.w  r1, r2
FFF0FE72  75441d                            mov.l   #1Dh, r4
FFF0FE75  fb3a4001                          mov.l   #140h, r3
FFF0FE79  6601                              mov.l   #0, r1
FFF0FE7B  057c06fe                          bsr.a   sub_FFEF04F7
FFF0FE7F  b289                              movu.b  10h+var_5[sp], r1
FFF0FE81  45010a                            cmp     10h+var_6[sp], r1
FFF0FE84  211d                              bne.b   loc_FFF0FEA1
FFF0FE86  b981                              movu.w  10h+var_4[sp], r1
FFF0FE88  6040                              sub     #4, sp
FFF0FE8A  f80980f9                          mov.w   #-680h, 14h+var_14[sp]
FFF0FE8E  6221                              add     #2, r1
FFF0FE90  5f12                              movu.w  r1, r2
FFF0FE92  75441c                            mov.l   #1Ch, r4
FFF0FE95  fb3a3401                          mov.l   #134h, r3
FFF0FE99  6661                              mov.l   #6, r1
FFF0FE9B  05ad1dfe                          bsr.a   sub_FFEF1C48
FFF0FE9F  6240                              add     #4, sp
FFF0FEA1  3c0143                 loc_FFF0FEA1 mov.b   #43h, 10h+var_F[sp] ; 'C'
FFF0FEA4  b281                              movu.b  10h+var_6[sp], r1
FFF0FEA6  711131                            add     #31h, r1, r1 ; '1'
FFF0FEA9  8081                              mov.b   r1, 10h+var_E[sp]
FFF0FEAB  3c033a                            mov.b   #3Ah, 10h+var_D[sp] ; ':'
FFF0FEAE  b989                              movu.w  10h+var_2[sp], r1
FFF0FEB0  6261                              add     #6, r1
FFF0FEB2  9189                              mov.w   r1, 10h+var_2[sp]
FFF0FEB4  b982                              movu.w  10h+var_4[sp], r2
FFF0FEB6  b989                              movu.w  10h+var_2[sp], r1
FFF0FEB8  60c0                              sub     #0Ch, sp
FFF0FEBA  71030d                            add     #1Ch+var_F, sp, r3
FFF0FEBD  a00b                              mov.l   r3, 1Ch+var_18[sp]
FFF0FEBF  3c0801                            mov.b   #1, 1Ch+var_14[sp]
FFF0FEC2  f80403                            mov.b   #3, 1Ch+var_1C[sp]
FFF0FEC5  6222                              add     #2, r2
FFF0FEC7  5f22                              movu.w  r2, r2
FFF0FEC9  6604                              mov.l   #0, r4
FFF0FECB  66d3                              mov.l   #0Dh, r3
FFF0FECD  05561cfe                          bsr.a   sub_FFEF1B23
FFF0FED1  62c0                              add     #0Ch, sp
FFF0FED3  b989                              movu.w  10h+var_2[sp], r1
FFF0FED5  71112a                            add     #2Ah, r1, r1 ; '*'
FFF0FED8  9189                              mov.w   r1, 10h+var_2[sp]
FFF0FEDA  a80a                              mov.l   10h+var_C[sp], r2
FFF0FEDC  b983                              movu.w  10h+var_4[sp], r3
FFF0FEDE  b989                              movu.w  10h+var_2[sp], r1
FFF0FEE0  60c0                              sub     #0Ch, sp
FFF0FEE2  a00a                              mov.l   r2, 1Ch+var_18[sp]
FFF0FEE4  3c0801                            mov.b   #1, 1Ch+var_14[sp]
FFF0FEE7  f80410                            mov.b   #10h, 1Ch+var_1C[sp]
FFF0FEEA  6223                              add     #2, r3
FFF0FEEC  5f32                              movu.w  r3, r2
FFF0FEEE  6604                              mov.l   #0, r4
FFF0FEF0  66d3                              mov.l   #0Dh, r3
FFF0FEF2  05311cfe                          bsr.a   sub_FFEF1B23
FFF0FEF6  62c0                              add     #0Ch, sp
FFF0FEF8  6704                              rtsd    #4
FFF0FEFA  7100f0                 sub_FFF0FEFA add     #-10h, sp, sp   ; <<<< FUNC sub_FFF0FEFA
FFF0FEFD  8389                              mov.b   r1, 10h+var_1[sp]
FFF0FEFF  fbe2738f0000                      mov.l   #8F73h, r14
FFF0FF05  58e1                              movu.b  [r14], r1
FFF0FF07  41010f                            sub     10h+var_1[sp], r1
FFF0FF0A  8081                              mov.b   r1, 10h+var_E[sp]
FFF0FF0C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FF12  c4e009                            mov.b   [r14], 10h+var_7[sp]
FFF0FF15  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FF1B  c5e0010a                          mov.b   1[r14], 10h+var_6[sp]
FFF0FF1F  c500020c                          mov.b   10h+var_E[sp], 10h+var_4[sp]
FFF0FF23  710109                            add     #10h+var_7, sp, r1
FFF0FF26  05fe27fe                          bsr.a   sub_FFEF2724
FFF0FF2A  b289                              movu.b  10h+var_5[sp], r1
FFF0FF2C  6c21                              shll    #2, r1
FFF0FF2E  fbe268880600                      mov.l   #68868h, r14
FFF0FF34  4b1e                              add     r1, r14
FFF0FF36  b081                              movu.b  10h+var_E[sp], r1
FFF0FF38  6c31                              shll    #3, r1
FFF0FF3A  0688e1                            add     [r14].l, r1
FFF0FF3D  a009                              mov.l   r1, 10h+var_C[sp]
FFF0FF3F  a809                              mov.l   10h+var_C[sp], r1
FFF0FF41  b894                              movu.w  4[r1], r4
FFF0FF43  b81b                              movu.w  2[r1], r3
FFF0FF45  5c12                              movu.w  [r1], r2
FFF0FF47  6040                              sub     #4, sp
FFF0FF49  d11003                            mov.w   6[r1], 14h+var_14[sp]
FFF0FF4C  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0FF52  0569fafd                          bsr.a   sub_FFEEF9BB
FFF0FF56  6240                              add     #4, sp
FFF0FF58  8089                              mov.b   r1, 10h+var_D[sp]
FFF0FF5A  b089                              movu.b  10h+var_D[sp], r1
FFF0FF5C  6111                              cmp     #1, r1
FFF0FF5E  210e                              bne.b   loc_FFF0FF6C
FFF0FF60  b081                              movu.b  10h+var_E[sp], r1
FFF0FF62  05a325fe                          bsr.a   sub_FFEF2505
FFF0FF66  050904fe                          bsr.a   sub_FFEF036F
FFF0FF6A  6704                              rtsd    #4
FFF0FF6C  6704                   loc_FFF0FF6C rtsd    #4
FFF0FF6E  6080                   sub_FFF0FF6E sub     #8, sp   ; <<<< FUNC sub_FFF0FF6E
FFF0FF70  9089                              mov.w   r1, 8+var_2[sp]
FFF0FF72  810a                              mov.b   r2, 8+var_3[sp]
FFF0FF74  6112                              cmp     #1, r2
FFF0FF76  1f                                bne.s   loc_FFF0FF7D
FFF0FF77  f909012d01                        mov.w   #12Dh, 8+var_6[sp]
FFF0FF7C  0e                                bra.s   loc_FFF0FF82
FFF0FF7D  f909013401             loc_FFF0FF7D mov.w   #134h, 8+var_6[sp]
FFF0FF82  b80b                   loc_FFF0FF82 movu.w  8+var_6[sp], r3
FFF0FF84  b88a                              movu.w  8+var_2[sp], r2
FFF0FF86  6040                              sub     #4, sp
FFF0FF88  f80995ad                          mov.w   #-526Bh, 0Ch+var_C[sp]
FFF0FF8C  6614                              mov.l   #1, r4
FFF0FF8E  6661                              mov.l   #6, r1
FFF0FF90  05b81cfe                          bsr.a   sub_FFEF1C48
FFF0FF94  6240                              add     #4, sp
FFF0FF96  6702                              rtsd    #2
FFF0FF98  fbe24c8c0000           sub_FFF0FF98 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF0FF98
FFF0FF9E  58ee                              movu.b  [r14], r14
FFF0FFA0  613e                              cmp     #3, r14
FFF0FFA2  2a16                              bgt.b   loc_FFF0FFB8
FFF0FFA4  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0FFAA  58ee                              movu.b  [r14], r14
FFF0FFAC  fbf2e47aedff                      mov.l   #off_FFED7AE4, r15
FFF0FFB2  fe6efe                            mov.l   [r14, r15], r14
FFF0FFB5  7f1e                              jsr     r14
FFF0FFB7  02                                rts
FFF0FFB8  fbe24c8c0000           loc_FFF0FFB8 mov.l   #8C4Ch, r14
FFF0FFBE  f8e403                            mov.b   #3, [r14]
FFF0FFC1  02                                rts
FFF0FFC2  6611                   sub_FFF0FFC2 mov.l   #1, r1   ; <<<< FUNC sub_FFF0FFC2
FFF0FFC4  392c02                            bsr.w   sub_FFF101F0
FFF0FFC7  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF0FFCD  58ef                              movu.b  [r14], r15
FFF0FFCF  621f                              add     #1, r15
FFF0FFD1  c3ef                              mov.b   r15, [r14]
FFF0FFD3  02                                rts
FFF0FFD4  6040                   sub_FFF0FFD4 sub     #4, sp   ; <<<< FUNC sub_FFF0FFD4
FFF0FFD6  055703fe                          bsr.a   sub_FFEF032D
FFF0FFDA  056da7fe                          bsr.a   sub_FFEFA747
FFF0FFDE  3d0102                            mov.w   #2, 4+var_2[sp]
FFF0FFE1  f80505                            mov.w   #5, 4+var_4[sp]
FFF0FFE4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0FFEA  59ee39                            movu.b  39h[r14], r14
FFF0FFED  610e                              cmp     #0, r14
FFF0FFEF  dc01                              mov.w   4+var_4[sp], r1
FFF0FFF1  980b                              mov.w   4+var_2[sp], r3
FFF0FFF3  2114                              bne.b   loc_FFF10007
FFF0FFF5  5f12                              movu.w  r1, r2
FFF0FFF7  5f31                              movu.w  r3, r1
FFF0FFF9  fb42dc22edff                      mov.l   #unk_FFED22DC, r4
FFF0FFFF  6613                              mov.l   #1, r3

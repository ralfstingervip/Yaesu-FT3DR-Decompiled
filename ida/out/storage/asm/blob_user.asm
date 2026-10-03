; ==== blob_user  FFF40B00-FFF40D80  (file 340B00-340D80) ====
FFF40B00  58ee                   sub_FFF40B00 movu.b  [r14], r14   ; <<<< FUNC sub_FFF40B00
FFF40B02  755eff                            cmp     #-1, r14
FFF40B05  2013                              beq.b   loc_FFF40B18
FFF40B07  fbe2738f0000                      mov.l   #8F73h, r14
FFF40B0D  58ee                              movu.b  [r14], r14
FFF40B0F  755e23                            cmp     #23h, r14 ; '#'
FFF40B12  2406                              bgtu.b  loc_FFF40B18
FFF40B14  f80601                            mov.l   #1, 0[sp]
FFF40B17  0c                                bra.s   loc_FFF40B1B
FFF40B18  f80600                 loc_FFF40B18 mov.l   #0, 0[sp]
FFF40B1B  ec01                   loc_FFF40B1B mov.l   0[sp], r1
FFF40B1D  6101                              cmp     #0, r1
FFF40B1F  2029                              beq.b   loc_FFF40B48
FFF40B21  0563f0fa                          bsr.a   sub_FFEEFB84
FFF40B25  6101                              cmp     #0, r1
FFF40B27  2121                              bne.b   loc_FFF40B48
FFF40B29  fbe2738f0000                      mov.l   #8F73h, r14
FFF40B2F  58e1                              movu.b  [r14], r1
FFF40B31  05b9f4fa                          bsr.a   sub_FFEEFFEA
FFF40B35  fbe2738f0000                      mov.l   #8F73h, r14
FFF40B3B  58ee                              movu.b  [r14], r14
FFF40B3D  fbf2e883edff                      mov.l   #off_FFED83E8, r15
FFF40B43  fe6efe                            mov.l   [r14, r15], r14
FFF40B46  7f1e                              jsr     r14
FFF40B48  fbe24c8c0000           loc_FFF40B48 mov.l   #8C4Ch, r14
FFF40B4E  58ee                              movu.b  [r14], r14
FFF40B50  614e                              cmp     #4, r14
FFF40B52  290d                              blt.b   loc_FFF40B5F
FFF40B54  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF40B5A  f8e403                            mov.b   #3, [r14]
FFF40B5D  6701                              rtsd    #1
FFF40B5F  6701                   loc_FFF40B5F rtsd    #1
FFF40B61  6040                   sub_FFF40B61 sub     #4, sp   ; <<<< FUNC sub_FFF40B61
FFF40B63  8089                              mov.b   r1, 4+var_1[sp]
FFF40B65  050435fb                          bsr.a   sub_FFEF4069
FFF40B69  391400                            bsr.w   sub_FFF40B7D
FFF40B6C  054e35fb                          bsr.a   sub_FFEF40BA
FFF40B70  b089                              movu.b  4+var_1[sp], r1
FFF40B72  6111                              cmp     #1, r1
FFF40B74  1f                                bne.s   loc_FFF40B7B
FFF40B75  05b7f4fa                          bsr.a   sub_FFEF002C
FFF40B79  6701                              rtsd    #1
FFF40B7B  6701                   loc_FFF40B7B rtsd    #1
FFF40B7D  6040                   sub_FFF40B7D sub     #4, sp   ; <<<< FUNC sub_FFF40B7D
FFF40B7F  3c0300                            mov.b   #0, 4+var_1[sp]
FFF40B82  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40B85  3c0100                            mov.b   #0, 4+var_3[sp]
FFF40B88  f80400                            mov.b   #0, 4+var_4[sp]
FFF40B8B  fbe2468e0000                      mov.l   #8E46h, r14
FFF40B91  59e16c                            movu.b  6Ch[r14], r1
FFF40B94  6431                              and     #3, r1
FFF40B96  8089                              mov.b   r1, 4+var_1[sp]
FFF40B98  fbe2468e0000                      mov.l   #8E46h, r14
FFF40B9E  c1e06d                            mov.b   6Dh[r14], 4+var_4[sp]
FFF40BA1  05a135fb                          bsr.a   sub_FFEF4142
FFF40BA5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40BAB  71ee20                            add     #20h, r14, r14 ; ' '
FFF40BAE  fbf29cd30100                      mov.l   #1D39Ch, r15
FFF40BB4  e3fe                              mov.l   r14, [r15]
FFF40BB6  fb22468e0000                      mov.l   #8E46h, r2
FFF40BBC  712220                            add     #20h, r2, r2 ; ' '
FFF40BBF  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF40BC5  711120                            add     #20h, r1, r1 ; ' '
FFF40BC8  6633                              mov.l   #3, r3
FFF40BCA  05dd36fb                          bsr.a   sub_FFEF42A7
FFF40BCE  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40BD4  59ee6c                            movu.b  6Ch[r14], r14
FFF40BD7  450e03                            cmp     4+var_1[sp], r14
FFF40BDA  2012                              beq.b   loc_FFF40BEC
FFF40BDC  6611                              mov.l   #1, r1
FFF40BDE  0510f3fa                          bsr.a   sub_FFEEFEEE
FFF40BE2  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40BE8  c50e036c                          mov.b   4+var_1[sp], 6Ch[r14]
FFF40BEC  fbe24d8c0000           loc_FFF40BEC mov.l   #8C4Dh, r14
FFF40BF2  59ee6d                            movu.b  6Dh[r14], r14
FFF40BF5  440e                              cmp     4+var_4[sp], r14
FFF40BF7  2011                              beq.b   loc_FFF40C08
FFF40BF9  6611                              mov.l   #1, r1
FFF40BFB  05f3f2fa                          bsr.a   sub_FFEEFEEE
FFF40BFF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40C05  c40e6d                            mov.b   4+var_4[sp], 6Dh[r14]
FFF40C08  3c0100                 loc_FFF40C08 mov.b   #0, 4+var_3[sp]
FFF40C0B  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40C0E  2e3e                              bra.b   loc_FFF40C4C
FFF40C10  b081                   loc_FFF40C10 movu.b  4+var_2[sp], r1
FFF40C12  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40C18  4b1e                              add     r1, r14
FFF40C1A  59ee6e                            movu.b  6Eh[r14], r14
FFF40C1D  fbf2468e0000                      mov.l   #8E46h, r15
FFF40C23  4b1f                              add     r1, r15
FFF40C25  45fe6e                            cmp     6Eh[r15], r14
FFF40C28  201e                              beq.b   loc_FFF40C46
FFF40C2A  b081                              movu.b  4+var_2[sp], r1
FFF40C2C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40C32  4b1e                              add     r1, r14
FFF40C34  fbf2468e0000                      mov.l   #8E46h, r15
FFF40C3A  4b1f                              add     r1, r15
FFF40C3C  c5fe6e6e                          mov.b   6Eh[r15], 6Eh[r14]
FFF40C40  b009                              movu.b  4+var_3[sp], r1
FFF40C42  6211                              add     #1, r1
FFF40C44  8009                              mov.b   r1, 4+var_3[sp]
FFF40C46  b081                   loc_FFF40C46 movu.b  4+var_2[sp], r1
FFF40C48  6211                              add     #1, r1
FFF40C4A  8081                              mov.b   r1, 4+var_2[sp]
FFF40C4C  b089                   loc_FFF40C4C movu.b  4+var_1[sp], r1
FFF40C4E  fbe24ee9c3ff                      mov.l   #unk_FFC3E94E, r14
FFF40C54  fece1e                            movu.b  [r14, r1], r14
FFF40C57  b081                              movu.b  4+var_2[sp], r1
FFF40C59  47e1                              cmp     r14, r1
FFF40C5B  29b5                              blt.b   loc_FFF40C10
FFF40C5D  b009                              movu.b  4+var_3[sp], r1
FFF40C5F  6101                              cmp     #0, r1
FFF40C61  17                                beq.s   loc_FFF40C68
FFF40C62  6611                              mov.l   #1, r1
FFF40C64  058af2fa                          bsr.a   sub_FFEEFEEE
FFF40C68  fbe24d8c0000           loc_FFF40C68 mov.l   #8C4Dh, r14
FFF40C6E  59ee6c                            movu.b  6Ch[r14], r14
FFF40C71  612e                              cmp     #2, r14
FFF40C73  3ae702                            beq.w   loc_FFF40F5A
FFF40C76  611e                              cmp     #1, r14
FFF40C78  3a7501                            beq.w   loc_FFF40DED
FFF40C7B  610e                              cmp     #0, r14
FFF40C7D  3b4704                            bne.w   loc_FFF410C4
FFF40C80  3c0100                            mov.b   #0, 4+var_3[sp]
FFF40C83  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40C86  2e3e                              bra.b   loc_FFF40CC4
FFF40C88  b081                   loc_FFF40C88 movu.b  4+var_2[sp], r1
FFF40C8A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40C90  4b1e                              add     r1, r14
FFF40C92  59ee81                            movu.b  81h[r14], r14
FFF40C95  fbf2468e0000                      mov.l   #8E46h, r15
FFF40C9B  4b1f                              add     r1, r15
FFF40C9D  45fe81                            cmp     81h[r15], r14
FFF40CA0  201e                              beq.b   loc_FFF40CBE
FFF40CA2  b081                              movu.b  4+var_2[sp], r1
FFF40CA4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40CAA  4b1e                              add     r1, r14
FFF40CAC  fbf2468e0000                      mov.l   #8E46h, r15
FFF40CB2  4b1f                              add     r1, r15
FFF40CB4  c5fe8181                          mov.b   81h[r15], 81h[r14]
FFF40CB8  b009                              movu.b  4+var_3[sp], r1
FFF40CBA  6211                              add     #1, r1
FFF40CBC  8009                              mov.b   r1, 4+var_3[sp]
FFF40CBE  b081                   loc_FFF40CBE movu.b  4+var_2[sp], r1
FFF40CC0  6211                              add     #1, r1
FFF40CC2  8081                              mov.b   r1, 4+var_2[sp]
FFF40CC4  b081                   loc_FFF40CC4 movu.b  4+var_2[sp], r1
FFF40CC6  6141                              cmp     #4, r1
FFF40CC8  29c0                              blt.b   loc_FFF40C88
FFF40CCA  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40CCD  2e3e                              bra.b   loc_FFF40D0B
FFF40CCF  b081                   loc_FFF40CCF movu.b  4+var_2[sp], r1
FFF40CD1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40CD7  4b1e                              add     r1, r14
FFF40CD9  59ee85                            movu.b  85h[r14], r14
FFF40CDC  fbf2468e0000                      mov.l   #8E46h, r15
FFF40CE2  4b1f                              add     r1, r15
FFF40CE4  45fe85                            cmp     85h[r15], r14
FFF40CE7  201e                              beq.b   loc_FFF40D05
FFF40CE9  b081                              movu.b  4+var_2[sp], r1
FFF40CEB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40CF1  4b1e                              add     r1, r14
FFF40CF3  fbf2468e0000                      mov.l   #8E46h, r15
FFF40CF9  4b1f                              add     r1, r15
FFF40CFB  c5fe8585                          mov.b   85h[r15], 85h[r14]
FFF40CFF  b009                              movu.b  4+var_3[sp], r1
FFF40D01  6211                              add     #1, r1
FFF40D03  8009                              mov.b   r1, 4+var_3[sp]
FFF40D05  b081                   loc_FFF40D05 movu.b  4+var_2[sp], r1
FFF40D07  6211                              add     #1, r1
FFF40D09  8081                              mov.b   r1, 4+var_2[sp]
FFF40D0B  b081                   loc_FFF40D0B movu.b  4+var_2[sp], r1
FFF40D0D  6141                              cmp     #4, r1
FFF40D0F  29c0                              blt.b   loc_FFF40CCF
FFF40D11  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40D14  2e3e                              bra.b   loc_FFF40D52
FFF40D16  b081                   loc_FFF40D16 movu.b  4+var_2[sp], r1
FFF40D18  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40D1E  4b1e                              add     r1, r14
FFF40D20  59ee89                            movu.b  89h[r14], r14
FFF40D23  fbf2468e0000                      mov.l   #8E46h, r15
FFF40D29  4b1f                              add     r1, r15
FFF40D2B  45fe89                            cmp     89h[r15], r14
FFF40D2E  201e                              beq.b   loc_FFF40D4C
FFF40D30  b081                              movu.b  4+var_2[sp], r1
FFF40D32  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40D38  4b1e                              add     r1, r14
FFF40D3A  fbf2468e0000                      mov.l   #8E46h, r15
FFF40D40  4b1f                              add     r1, r15
FFF40D42  c5fe8989                          mov.b   89h[r15], 89h[r14]
FFF40D46  b009                              movu.b  4+var_3[sp], r1
FFF40D48  6211                              add     #1, r1
FFF40D4A  8009                              mov.b   r1, 4+var_3[sp]
FFF40D4C  b081                   loc_FFF40D4C movu.b  4+var_2[sp], r1
FFF40D4E  6211                              add     #1, r1
FFF40D50  8081                              mov.b   r1, 4+var_2[sp]
FFF40D52  b081                   loc_FFF40D52 movu.b  4+var_2[sp], r1
FFF40D54  6141                              cmp     #4, r1
FFF40D56  29c0                              blt.b   loc_FFF40D16
FFF40D58  b009                              movu.b  4+var_3[sp], r1
FFF40D5A  6101                              cmp     #0, r1
FFF40D5C  17                                beq.s   loc_FFF40D63
FFF40D5D  6611                              mov.l   #1, r1
FFF40D5F  058ff1fa                          bsr.a   sub_FFEEFEEE
FFF40D63  3c0200                 loc_FFF40D63 mov.b   #0, 4+var_2[sp]
FFF40D66  2e7e                              bra.b   loc_FFF40DE4
FFF40D68  b081                   loc_FFF40D68 movu.b  4+var_2[sp], r1
FFF40D6A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40D70  4b1e                              add     r1, r14
FFF40D72  59ee8d                            movu.b  8Dh[r14], r14
FFF40D75  fbf2468e0000                      mov.l   #8E46h, r15
FFF40D7B  4b1f                              add     r1, r15
FFF40D7D  45fe8d                            cmp     8Dh[r15], r14

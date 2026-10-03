; window sci_init file 2DB280-2DB520 map FFEDB280-FFEDB520 forced 204
; ==== sci_init  FFEDB280-FFEDB520 ====
FFEDB280  e2d82c01                          mov.l   4B0h[r13], [r8]
FFEDB284  00                                brk
FFEDB285  4b1e                              add     r1, r14
FFEDB287  d1e00b                            mov.w   16h[r14], 18h+var_18[sp]
FFEDB28A  a889                              mov.l   18h+var_C[sp], r1
FFEDB28C  751118                            mul     #18h, r1
FFEDB28F  fbe2d82c0100                      mov.l   #12CD8h, r14
FFEDB295  4b1e                              add     r1, r14
FFEDB297  5c01                              movu.w  18h+var_18[sp], r1
FFEDB299  06c5e10a                          cmp     14h[r14].uw, r1
FFEDB29D  2059                              beq.b   loc_FFEDB2F6
FFEDB29F  a889                              mov.l   18h+var_C[sp], r1
FFEDB2A1  751118                            mul     #18h, r1
FFEDB2A4  fb22d82c0100                      mov.l   #12CD8h, r2
FFEDB2AA  4b12                              add     r1, r2
FFEDB2AC  a829                              mov.l   4[r2], r1
FFEDB2AE  5c02                              movu.w  18h+var_18[sp], r2
FFEDB2B0  fec12e                            movu.b  [r1, r2], r14
FFEDB2B3  b809                              movu.w  18h+var_16[sp], r1
FFEDB2B5  a882                              mov.l   18h+var_10[sp], r2
FFEDB2B7  fe021e                            mov.b   r14, [r2, r1]
FFEDB2BA  dc01                              mov.w   18h+var_18[sp], r1
FFEDB2BC  6211                              add     #1, r1
FFEDB2BE  d301                              mov.w   r1, 18h+var_18[sp]
FFEDB2C0  a889                              mov.l   18h+var_C[sp], r1
FFEDB2C2  751118                            mul     #18h, r1
FFEDB2C5  fbe2d82c0100                      mov.l   #12CD8h, r14
FFEDB2CB  4b1e                              add     r1, r14
FFEDB2CD  5c01                              movu.w  18h+var_18[sp], r1
FFEDB2CF  06c5e106                          cmp     0Ch[r14].uw, r1
FFEDB2D3  2905                              blt.b   loc_FFEDB2D8
FFEDB2D5  f80500                            mov.w   #0, 18h+var_18[sp]
FFEDB2D8  a889                     loc_FFEDB2D8 mov.l   18h+var_C[sp], r1
FFEDB2DA  751118                            mul     #18h, r1
FFEDB2DD  fb22d82c0100                      mov.l   #12CD8h, r2
FFEDB2E3  4b12                              add     r1, r2
FFEDB2E5  d4020b                            mov.w   18h+var_18[sp], 16h[r2]
FFEDB2E8  9809                              mov.w   18h+var_16[sp], r1
FFEDB2EA  6211                              add     #1, r1
FFEDB2EC  9009                              mov.w   r1, 18h+var_16[sp]
FFEDB2EE  b809                     loc_FFEDB2EE movu.w  18h+var_16[sp], r1
FFEDB2F0  06c50103                          cmp     18h+var_12[sp].uw, r1
FFEDB2F4  2986                              blt.b   loc_FFEDB27A
FFEDB2F6  d5000102                 loc_FFEDB2F6 mov.w   18h+var_16[sp], 18h+var_14[sp]
FFEDB2FA  9881                              mov.w   4[sp], r1
FFEDB2FC  5f11                              movu.w  r1, r1
FFEDB2FE  6704                              rtsd    #4
FFEDB300  fbee3a7308               loc_FFEDB300 mov.l   #8733Ah, r14
FFEDB305  58ef                              movu.b  [r14], r15
FFEDB307  65ff                              or      #0Fh, r15
FFEDB309  c3ef                              mov.b   r15, [r14]
FFEDB30B  fbee3e7308                        mov.l   #8733Eh, r14
FFEDB310  58ef                              movu.b  [r14], r15
FFEDB312  653f                              or      #3, r15
FFEDB314  762ff300                          and     #0F3h, r15
FFEDB318  c3ef                              mov.b   r15, [r14]
FFEDB31A  fbee6e7308                        mov.l   #8736Eh, r14
FFEDB31F  58ef                              movu.b  [r14], r15
FFEDB321  653f                              or      #3, r15
FFEDB323  762ff300                          and     #0F3h, r15
FFEDB327  c3ef                              mov.b   r15, [r14]
FFEDB329  fbee3a7008                        mov.l   #8703Ah, r14
FFEDB32E  f0e8                              bclr    #0, [r14].b
FFEDB330  fbee3b7008                        mov.l   #8703Bh, r14
FFEDB335  f0e8                              bclr    #0, [r14].b
FFEDB337  fbee3e7008                        mov.l   #8703Eh, r14
FFEDB33C  f0e8                              bclr    #0, [r14].b
FFEDB33E  fbee3f7008                        mov.l   #8703Fh, r14
FFEDB343  f0e8                              bclr    #0, [r14].b
FFEDB345  fbee6e7008                        mov.l   #8706Eh, r14
FFEDB34A  f0e8                              bclr    #0, [r14].b
FFEDB34C  fbee077208                        mov.l   #87207h, r14
FFEDB351  f0e3                              bset    #3, [r14].b
FFEDB353  fbee077208                        mov.l   #87207h, r14
FFEDB358  f0e2                              bset    #2, [r14].b
FFEDB35A  fbee077208                        mov.l   #87207h, r14
FFEDB35F  f0e7                              bset    #7, [r14].b
FFEDB361  fbee077208                        mov.l   #87207h, r14
FFEDB366  f0e6                              bset    #6, [r14].b
FFEDB368  fbee0d7208                        mov.l   #8720Dh, r14
FFEDB36D  f0e6                              bset    #6, [r14].b
FFEDB36F  fbee707608                        mov.l   #87670h, r14
FFEDB374  ecef                              mov.l   [r14], r15
FFEDB376  781f                              bset    #1, r15
FFEDB378  e3ef                              mov.l   r15, [r14]
FFEDB37A  fbee707608                        mov.l   #87670h, r14
FFEDB37F  ecef                              mov.l   [r14], r15
FFEDB381  780f                              bset    #0, r15
FFEDB383  e3ef                              mov.l   r15, [r14]
FFEDB385  fbee707608                        mov.l   #87670h, r14
FFEDB38A  ecef                              mov.l   [r14], r15
FFEDB38C  785f                              bset    #5, r15
FFEDB38E  e3ef                              mov.l   r15, [r14]
FFEDB390  fbee707608                        mov.l   #87670h, r14
FFEDB395  ecef                              mov.l   [r14], r15
FFEDB397  784f                              bset    #4, r15
FFEDB399  e3ef                              mov.l   r15, [r14]
FFEDB39B  fbee507308                        mov.l   #87350h, r14
FFEDB3A0  58ef                              movu.b  [r14], r15
FFEDB3A2  653f                              or      #3, r15
FFEDB3A4  762ff300                          and     #0F3h, r15
FFEDB3A8  c3ef                              mov.b   r15, [r14]
FFEDB3AA  fbee517008                        mov.l   #87051h, r14
FFEDB3AF  f0e8                              bclr    #0, [r14].b
FFEDB3B1  fbee507008                        mov.l   #87050h, r14
FFEDB3B6  f0e8                              bclr    #0, [r14].b
FFEDB3B8  fbee0a7208                        mov.l   #8720Ah, r14
FFEDB3BD  f0e1                              bset    #1, [r14].b
FFEDB3BF  fbee0a7208                        mov.l   #8720Ah, r14
FFEDB3C4  f0e0                              bset    #0, [r14].b
FFEDB3C6  fbee707608                        mov.l   #87670h, r14
FFEDB3CB  ecef                              mov.l   [r14], r15
FFEDB3CD  786f                              bset    #6, r15
FFEDB3CF  e3ef                              mov.l   r15, [r14]
FFEDB3D1  fbee707608                        mov.l   #87670h, r14
FFEDB3D6  ecef                              mov.l   [r14], r15
FFEDB3D8  787f                              bset    #7, r15
FFEDB3DA  e3ef                              mov.l   r15, [r14]
FFEDB3DC  fb1e00a008                        mov.l   #8A000h, r1
FFEDB3E1  3c1710                            mov.b   #10h, 7[r1]
FFEDB3E4  fbee00a008                        mov.l   #8A000h, r14
FFEDB3E9  f8e400                            mov.b   #0, [r14]
FFEDB3EC  fb1e00a008                        mov.l   #8A000h, r1
FFEDB3F1  3c1200                            mov.b   #0, 2[r1]
FFEDB3F4  fbee00a008                        mov.l   #8A000h, r14
FFEDB3F9  754f38                            mov.l   #38h, r15 ; '8'
FFEDB3FC  fc31ef04                          tst     4[r14], r15
FFEDB400  11                                beq.s   loc_FFEDB409
FFEDB401  fb1e00a008                        mov.l   #8A000h, r1
FFEDB406  3c14c7                            mov.b   #-39h, 4[r1]
FFEDB409  fb1e00a008               loc_FFEDB409 mov.l   #8A000h, r1
FFEDB40E  3c16f2                            mov.b   #-0Eh, 6[r1]
FFEDB411  fb1e40a008                        mov.l   #8A040h, r1
FFEDB416  3c1710                            mov.b   #10h, 7[r1]
FFEDB419  fbee40a008                        mov.l   #8A040h, r14
FFEDB41E  f8e400                            mov.b   #0, [r14]
FFEDB421  fb1e40a008                        mov.l   #8A040h, r1
FFEDB426  3c1200                            mov.b   #0, 2[r1]
FFEDB429  fbee40a008                        mov.l   #8A040h, r14
FFEDB42E  754f38                            mov.l   #38h, r15 ; '8'
FFEDB431  fc31ef04                          tst     4[r14], r15
FFEDB435  11                                beq.s   loc_FFEDB43E
FFEDB436  fb1e40a008                        mov.l   #8A040h, r1
FFEDB43B  3c14c7                            mov.b   #-39h, 4[r1]
FFEDB43E  fb1e40a008               loc_FFEDB43E mov.l   #8A040h, r1
FFEDB443  3c1610                            mov.b   #10h, 6[r1]
FFEDB446  fb1e60a008                        mov.l   #8A060h, r1
FFEDB44B  3c1710                            mov.b   #10h, 7[r1]
FFEDB44E  fbee60a008                        mov.l   #8A060h, r14
FFEDB453  f8e400                            mov.b   #0, [r14]
FFEDB456  fb1e60a008                        mov.l   #8A060h, r1
FFEDB45B  3c1200                            mov.b   #0, 2[r1]
FFEDB45E  fbee60a008                        mov.l   #8A060h, r14
FFEDB463  754f38                            mov.l   #38h, r15 ; '8'
FFEDB466  fc31ef04                          tst     4[r14], r15
FFEDB46A  11                                beq.s   loc_FFEDB473
FFEDB46B  fb1e60a008                        mov.l   #8A060h, r1
FFEDB470  3c14c7                            mov.b   #-39h, 4[r1]
FFEDB473  fb1e60a008               loc_FFEDB473 mov.l   #8A060h, r1
FFEDB478  3c1610                            mov.b   #10h, 6[r1]
FFEDB47B  fbe2202d0100                      mov.l   #12D20h, r14
FFEDB481  f8e600                            mov.l   #0, [r14]
FFEDB484  fb12202d0100                      mov.l   #12D20h, r1
FFEDB48A  3e1100                            mov.l   #0, 4[r1]
FFEDB48D  fb12202d0100                      mov.l   #12D20h, r1
FFEDB493  3d1400                            mov.w   #0, 8[r1]
FFEDB496  fb12202d0100                      mov.l   #12D20h, r1
FFEDB49C  3d1500                            mov.w   #0, 0Ah[r1]
FFEDB49F  fb12202d0100                      mov.l   #12D20h, r1
FFEDB4A5  3e1300                            mov.l   #0, 0Ch[r1]
FFEDB4A8  fb12202d0100                      mov.l   #12D20h, r1
FFEDB4AE  3e1400                            mov.l   #0, 10h[r1]
FFEDB4B1  fb12202d0100                      mov.l   #12D20h, r1
FFEDB4B7  3d1a00                            mov.w   #0, 14h[r1]
FFEDB4BA  fb12202d0100                      mov.l   #12D20h, r1
FFEDB4C0  3d1b00                            mov.w   #0, 16h[r1]
FFEDB4C3  fb12202d0100                      mov.l   #12D20h, r1
FFEDB4C9  3e1600                            mov.l   #0, 18h[r1]
FFEDB4CC  fb12202d0100                      mov.l   #12D20h, r1
FFEDB4D2  3e1700                            mov.l   #0, 1Ch[r1]
FFEDB4D5  fb12202d0100                      mov.l   #12D20h, r1
FFEDB4DB  3d9000                            mov.w   #0, 20h[r1]
FFEDB4DE  fb12202d0100                      mov.l   #12D20h, r1
FFEDB4E4  3d9100                            mov.w   #0, 22h[r1]
FFEDB4E7  02                                rts
FFEDB4E8  6080                     loc_FFEDB4E8 sub     #8, sp
FFEDB4EA  a009                              mov.l   r1, 4[sp]
FFEDB4EC  fbee00a008                        mov.l   #8A000h, r14
FFEDB4F1  c5e00201                          mov.b   2[r14], 1[sp]
FFEDB4F5  fb1e00a008                        mov.l   #8A000h, r1
FFEDB4FA  3c1200                            mov.b   #0, 2[r1]
FFEDB4FD  a809                              mov.l   4[sp], r1
FFEDB4FF  5c1e                              movu.w  [r1], r14
FFEDB501  760e8813                          cmp     #1388h, r14
FFEDB505  3aaa00                            beq.w   loc_FFEDB5AF
FFEDB508  755e90                            cmp     #-70h, r14
FFEDB50B  2035                              beq.b   loc_FFEDB540
FFEDB50D  755ec0                            cmp     #-40h, r14
FFEDB510  2047                              beq.b   loc_FFEDB557
FFEDB512  760e8001                          cmp     #180h, r14
FFEDB516  2057                              beq.b   loc_FFEDB56D
FFEDB518  760ee001                          cmp     #1E0h, r14
FFEDB51C  2067                              beq.b   loc_FFEDB583
FFEDB51E  760ec409                          cmp     #9C4h, r14

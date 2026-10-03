; window icu_grp file 2DBC80-2DBD60 map FFEDBC80-FFEDBD60 forced 0
; ==== icu_grp  FFEDBC80-FFEDBD60 ====
FFEDBC80  7f95                              rte
FFEDBC82  fb1e42a008               loc_FFEDBC82 mov.l   #8A042h, r1
FFEDBC87  f01f                              bclr    #7, [r1].b
FFEDBC89  6240                              add     #4, sp
FFEDBC8B  6f15                              popm    r1-r5
FFEDBC8D  6fef                              popm    r14-r15
FFEDBC8F  7f95                              rte
FFEDBC91  6040                     sub_FFEDBC91 sub     #4, sp  ; <<< FUNC sub_FFEDBC91
FFEDBC93  f80500                            mov.w   #0, 4+var_4[sp]
FFEDBC96  fb12202d0100                      mov.l   #12D20h, r1
FFEDBC9C  a899                              mov.l   0Ch[r1], r1
FFEDBC9E  6101                              cmp     #0, r1
FFEDBCA0  2015                              beq.b   loc_FFEDBCB5
FFEDBCA2  fb22202d0100                      mov.l   #12D20h, r2
FFEDBCA8  baa1                              movu.w  14h[r2], r1
FFEDBCAA  a8ac                              mov.l   0Ch[r2], r4
FFEDBCAC  6613                              mov.l   #1, r3
FFEDBCAE  710203                            add     #4+var_1, sp, r2
FFEDBCB1  7f14                              jsr     r4
FFEDBCB3  d301                              mov.w   r1, 4+var_4[sp]
FFEDBCB5  5c01                     loc_FFEDBCB5 movu.w  4+var_4[sp], r1
FFEDBCB7  6101                              cmp     #0, r1
FFEDBCB9  2014                              beq.b   loc_FFEDBCCD
FFEDBCBB  fbee42a008                        mov.l   #8A042h, r14
FFEDBCC0  c50e0301                          mov.b   4+var_1[sp], 1[r14]
FFEDBCC4  fbee42a008                        mov.l   #8A042h, r14
FFEDBCC9  f0e7                              bset    #7, [r14].b
FFEDBCCB  6701                              rtsd    #1
FFEDBCCD  fbee42a008               loc_FFEDBCCD mov.l   #8A042h, r14
FFEDBCD2  f0ef                              bclr    #7, [r14].b
FFEDBCD4  fbee42a008                        mov.l   #8A042h, r14
FFEDBCD9  f0ea                              bclr    #2, [r14].b
FFEDBCDB  6701                              rtsd    #1
FFEDBCDD  6eef                     loc_FFEDBCDD pushm   r14-r15
FFEDBCDF  6e15                              pushm   r1-r5
FFEDBCE1  fb1e307608                        mov.l   #87630h, r1
FFEDBCE6  ec11                              mov.l   [r1], r1
FFEDBCE8  6df1                              shll    #1Fh, r1
FFEDBCEA  69f1                              shlr    #1Fh, r1
FFEDBCEC  6111                              cmp     #1, r1
FFEDBCEE  1c                                bne.s   loc_FFEDBCF2
FFEDBCEF  39b6fb                            bsr.w   sub_FFEDB8A5
FFEDBCF2  fb1e307608               loc_FFEDBCF2 mov.l   #87630h, r1
FFEDBCF7  ec11                              mov.l   [r1], r1
FFEDBCF9  6de1                              shll    #1Eh, r1
FFEDBCFB  69f1                              shlr    #1Fh, r1
FFEDBCFD  6111                              cmp     #1, r1
FFEDBCFF  1c                                bne.s   loc_FFEDBD03
FFEDBD00  39b6fa                            bsr.w   sub_FFEDB7B6
FFEDBD03  fb1e307608               loc_FFEDBD03 mov.l   #87630h, r1
FFEDBD08  ec11                              mov.l   [r1], r1
FFEDBD0A  6db1                              shll    #1Bh, r1
FFEDBD0C  69f1                              shlr    #1Fh, r1
FFEDBD0E  6111                              cmp     #1, r1
FFEDBD10  1c                                bne.s   loc_FFEDBD14
FFEDBD11  3980ff                            bsr.w   sub_FFEDBC91
FFEDBD14  fb1e307608               loc_FFEDBD14 mov.l   #87630h, r1
FFEDBD19  ec11                              mov.l   [r1], r1
FFEDBD1B  6da1                              shll    #1Ah, r1
FFEDBD1D  69f1                              shlr    #1Fh, r1
FFEDBD1F  6111                              cmp     #1, r1
FFEDBD21  1c                                bne.s   loc_FFEDBD25
FFEDBD22  3980fe                            bsr.w   sub_FFEDBBA2
FFEDBD25  fb1e307608               loc_FFEDBD25 mov.l   #87630h, r1
FFEDBD2A  ec11                              mov.l   [r1], r1
FFEDBD2C  6d91                              shll    #19h, r1
FFEDBD2E  69f1                              shlr    #1Fh, r1
FFEDBD30  6111                              cmp     #1, r1
FFEDBD32  1c                                bne.s   loc_FFEDBD36
FFEDBD33  39bc03                            bsr.w   sub_FFEDC0EF
FFEDBD36  fb1e307608               loc_FFEDBD36 mov.l   #87630h, r1
FFEDBD3B  ec11                              mov.l   [r1], r1
FFEDBD3D  6d81                              shll    #18h, r1
FFEDBD3F  69f1                              shlr    #1Fh, r1
FFEDBD41  6111                              cmp     #1, r1
FFEDBD43  1a                                bne.s   loc_FFEDBD4D
FFEDBD44  39f703                            bsr.w   sub_FFEDC13B
FFEDBD47  6f15                              popm    r1-r5
FFEDBD49  6fef                              popm    r14-r15
FFEDBD4B  7f95                              rte
FFEDBD4D  6f15                     loc_FFEDBD4D popm    r1-r5
FFEDBD4F  6fef                              popm    r14-r15
FFEDBD51  7f95                              rte
FFEDBD53  6080                     sub_FFEDBD53 sub     #8, sp  ; <<< FUNC sub_FFEDBD53
FFEDBD55  a009                              mov.l   r1, 8+var_4[sp]
FFEDBD57  3c0300                            mov.b   #0, 8+var_5[sp]
FFEDBD5A  3c0200                            mov.b   #0, 8+var_6[sp]
FFEDBD5D  3c0100                            mov.b   #0, 8+var_7[sp]

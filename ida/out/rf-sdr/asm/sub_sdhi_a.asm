; window sdhi_a file 333000-3336C0 map FFF33000-FFF336C0 forced 650
; ==== sdhi_a  FFF33000-FFF336C0 ====
FFF33000  3c9506                            mov.b   #6, 15h[r1]
FFF33003  00                                brk
FFF33004  0694e1                            or      [r14].l, r1
FFF33007  e3e1                              mov.l   r1, [r14]
FFF33009  6701                              rtsd    #1
FFF3300B  7100f0                   sub_FFF3300B add     #-10h, sp, sp  ; <<< FUNC sub_FFF3300B
FFF3300E  a089                              mov.l   r1, 10h+var_4[sp]
FFF33010  a082                              mov.l   r2, 10h+var_8[sp]
FFF33012  a889                              mov.l   10h+var_4[sp], r1
FFF33014  391a00                            bsr.w   sub_FFF3302E
FFF33017  e301                              mov.l   r1, 10h+var_10[sp]
FFF33019  a889                              mov.l   10h+var_4[sp], r1
FFF3301B  7e01                              not     r1
FFF3301D  fbe23c950600                      mov.l   #6953Ch, r14
FFF33023  0690e1                            and     [r14].l, r1
FFF33026  e3e1                              mov.l   r1, [r14]
FFF33028  ec01                              mov.l   10h+var_10[sp], r1
FFF3302A  a009                              mov.l   r1, 10h+var_C[sp]
FFF3302C  6704                              rtsd    #4
FFF3302E  7100ec                   sub_FFF3302E add     #-14h, sp, sp  ; <<< FUNC sub_FFF3302E
FFF33031  a101                              mov.l   r1, 14h+var_4[sp]
FFF33033  a08a                              mov.l   r2, 14h+var_8[sp]
FFF33035  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF33038  fbe238950600                      mov.l   #69538h, r14
FFF3303E  e0e0                              mov.l   [r14], 14h+var_14[sp]
FFF33040  fbe238950600             loc_FFF33040 mov.l   #69538h, r14
FFF33046  ecee                              mov.l   [r14], r14
FFF33048  06800e                            sub     [sp].l, r14
FFF3304B  06850e03                          cmp     14h+var_8[sp].l, r14
FFF3304F  2308                              bltu.b  loc_FFF33057
FFF33051  f90601ff                          mov.l   #-1, 14h+var_10[sp]
FFF33055  2e13                              bra.b   loc_FFF33068
FFF33057  fbe23c950600             loc_FFF33057 mov.l   #6953Ch, r14
FFF3305D  a901                              mov.l   14h+var_4[sp], r1
FFF3305F  06a00ce1                          tst     [r14].l, r1
FFF33063  20dd                              beq.b   loc_FFF33040
FFF33065  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF33068  a809                     loc_FFF33068 mov.l   14h+var_10[sp], r1
FFF3306A  a081                              mov.l   r1, 14h+var_C[sp]
FFF3306C  6705                              rtsd    #5
FFF3306E  7100ec                            add     #-14h, sp, sp
FFF33071  a101                              mov.l   r1, 10h[sp]
FFF33073  a08a                              mov.l   r2, 0Ch[sp]
FFF33075  e10004                            mov.l   10h[sp], [sp]
FFF33078  a88a                              mov.l   0Ch[sp], r2
FFF3307A  ec01                              mov.l   [sp], r1
FFF3307C  6c92                              shll    #9, r2
FFF3307E  052efeff                          bsr.a   sub_FFF32EAC
FFF33082  a88b                              mov.l   0Ch[sp], r3
FFF33084  ec01                              mov.l   [sp], r1
FFF33086  fb2e60ac08                        mov.l   #8AC60h, r2
FFF3308B  0529feff                          bsr.a   sub_FFF32EB4
FFF3308F  fbeeb0ad08                        mov.l   #8ADB0h, r14
FFF33094  ecef                              mov.l   [r14], r15
FFF33096  7a1f                              bclr    #1, r15
FFF33098  e3ef                              mov.l   r15, [r14]
FFF3309A  fbeeb0ad08                        mov.l   #8ADB0h, r14
FFF3309F  ecef                              mov.l   [r14], r15
FFF330A1  781f                              bset    #1, r15
FFF330A3  e3ef                              mov.l   r15, [r14]
FFF330A5  fb2af401                          mov.l   #1F4h, r2
FFF330A9  6641                              mov.l   #4, r1
FFF330AB  0560ffff                          bsr.a   sub_FFF3300B
FFF330AF  a009                              mov.l   r1, 4[sp]
FFF330B1  0560feff                          bsr.a   sub_FFF32F11
FFF330B5  a809                              mov.l   4[sp], r1
FFF330B7  6101                              cmp     #0, r1
FFF330B9  1d                                bne.s   loc_FFF330BE
FFF330BA  3e0100                            mov.l   #0, 4[sp]
FFF330BD  0d                                bra.s   loc_FFF330C2
FFF330BE  f90601f1                 loc_FFF330BE mov.l   #-0Fh, 4[sp]
FFF330C2  a809                     loc_FFF330C2 mov.l   4[sp], r1
FFF330C4  a081                              mov.l   r1, 8[sp]
FFF330C6  6705                              rtsd    #5
FFF330C8  7100ec                            add     #-14h, sp, sp
FFF330CB  a101                              mov.l   r1, 10h[sp]
FFF330CD  a08a                              mov.l   r2, 0Ch[sp]
FFF330CF  e10004                            mov.l   10h[sp], [sp]
FFF330D2  a88a                              mov.l   0Ch[sp], r2
FFF330D4  ec01                              mov.l   [sp], r1
FFF330D6  6c92                              shll    #9, r2
FFF330D8  05d4fdff                          bsr.a   sub_FFF32EAC
FFF330DC  a88b                              mov.l   0Ch[sp], r3
FFF330DE  ec02                              mov.l   [sp], r2
FFF330E0  fb1e60ac08                        mov.l   #8AC60h, r1
FFF330E5  0568feff                          bsr.a   sub_FFF32F4D
FFF330E9  fbeeb0ad08                        mov.l   #8ADB0h, r14
FFF330EE  ecef                              mov.l   [r14], r15
FFF330F0  7a1f                              bclr    #1, r15
FFF330F2  e3ef                              mov.l   r15, [r14]
FFF330F4  fbeeb0ad08                        mov.l   #8ADB0h, r14
FFF330F9  ecef                              mov.l   [r14], r15
FFF330FB  781f                              bset    #1, r15
FFF330FD  e3ef                              mov.l   r15, [r14]
FFF330FF  fb2af401                          mov.l   #1F4h, r2
FFF33103  6641                              mov.l   #4, r1
FFF33105  0506ffff                          bsr.a   sub_FFF3300B
FFF33109  a009                              mov.l   r1, 4[sp]
FFF3310B  05a1feff                          bsr.a   sub_FFF32FAC
FFF3310F  a809                              mov.l   4[sp], r1
FFF33111  6101                              cmp     #0, r1
FFF33113  1d                                bne.s   loc_FFF33118
FFF33114  3e0100                            mov.l   #0, 4[sp]
FFF33117  0d                                bra.s   loc_FFF3311C
FFF33118  f90601f0                 loc_FFF33118 mov.l   #-10h, 4[sp]
FFF3311C  a809                     loc_FFF3311C mov.l   4[sp], r1
FFF3311E  a081                              mov.l   r1, 8[sp]
FFF33120  6705                              rtsd    #5
FFF33122  0582fdff                 loc_FFF33122 bsr.a   sub_FFF32EA4
FFF33126  6641                              mov.l   #4, r1
FFF33128  05d2feff                          bsr.a   loc_FFF32FFA
FFF3312C  02                                rts
FFF3312D  7100e0                   loc_FFF3312D add     #-20h, sp, sp
FFF33130  9389                              mov.w   r1, 1Eh[sp]
FFF33132  3e0200                            mov.l   #0, 8[sp]
FFF33135  3e0300                            mov.l   #0, 0Ch[sp]
FFF33138  2e54                              bra.b   loc_FFF3318C
FFF3313A  fbee3cac08               loc_FFF3313A mov.l   #8AC3Ch, r14
FFF3313F  e4e004                            mov.l   [r14], 10h[sp]
FFF33142  a901                              mov.l   10h[sp], r1
FFF33144  7ce1                              btst    #0Eh, r1
FFF33146  15                                beq.s   loc_FFF3314B
FFF33147  f80600                            mov.l   #0, [sp]
FFF3314A  0c                                bra.s   loc_FFF3314E
FFF3314B  f80601                   loc_FFF3314B mov.l   #1, [sp]
FFF3314E  ec01                     loc_FFF3314E mov.l   [sp], r1
FFF33150  6101                              cmp     #0, r1
FFF33152  12                                beq.s   loc_FFF3315C
FFF33153  a901                              mov.l   10h[sp], r1
FFF33155  7cd1                              btst    #0Dh, r1
FFF33157  15                                beq.s   loc_FFF3315C
FFF33158  f80601                            mov.l   #1, [sp]
FFF3315B  0c                                bra.s   loc_FFF3315F
FFF3315C  f80600                   loc_FFF3315C mov.l   #0, [sp]
FFF3315F  ec01                     loc_FFF3315F mov.l   [sp], r1
FFF33161  6101                              cmp     #0, r1
FFF33163  2132                              bne.b   loc_FFF33195
FFF33165  fbee7f8000                        mov.l   #807Fh, r14
FFF3316A  06a10c0e04                        tst     10h[sp].l, r14
FFF3316F  17                                beq.s   loc_FFF33176
FFF33170  f90601f7                          mov.l   #-9, 4[sp]
FFF33174  2e6f                              bra.b   loc_FFF331E3
FFF33176  39a600                   loc_FFF33176 bsr.w   sub_FFF3321C
FFF33179  a081                              mov.l   r1, 8[sp]
FFF3317B  a881                              mov.l   8[sp], r1
FFF3317D  6101                              cmp     #0, r1
FFF3317F  17                                beq.s   loc_FFF33186
FFF33180  e5000201                          mov.l   8[sp], 4[sp]
FFF33184  2e5f                              bra.b   loc_FFF331E3
FFF33186  a889                     loc_FFF33186 mov.l   0Ch[sp], r1
FFF33188  6211                              add     #1, r1
FFF3318A  a089                              mov.l   r1, 0Ch[sp]
FFF3318C  a889                     loc_FFF3318C mov.l   0Ch[sp], r1
FFF3318E  7701000010                        cmp     #100000h, r1
FFF33193  23a7                              bltu.b  loc_FFF3313A
FFF33195  a889                     loc_FFF33195 mov.l   0Ch[sp], r1
FFF33197  7701000010                        cmp     #100000h, r1
FFF3319C  2308                              bltu.b  loc_FFF331A4
FFF3319E  f90601ff                          mov.l   #-1, 4[sp]
FFF331A2  2e41                              bra.b   loc_FFF331E3
FFF331A4  9b89                     loc_FFF331A4 mov.w   1Eh[sp], r1
FFF331A6  7501ff                            cmp     #-1, r1
FFF331A9  2023                              beq.b   loc_FFF331CC
FFF331AB  6121                              cmp     #2, r1
FFF331AD  2018                              beq.b   loc_FFF331C5
FFF331AF  6111                              cmp     #1, r1
FFF331B1  200d                              beq.b   loc_FFF331BE
FFF331B3  6101                              cmp     #0, r1
FFF331B5  211d                              bne.b   loc_FFF331D2
FFF331B7  f90a054001                        mov.l   #140h, 14h[sp]
FFF331BC  2e1c                              bra.b   loc_FFF331D8
FFF331BE  f90a050101               loc_FFF331BE mov.l   #101h, 14h[sp]
FFF331C3  2e15                              bra.b   loc_FFF331D8
FFF331C5  f90a050001               loc_FFF331C5 mov.l   #100h, 14h[sp]
FFF331CA  2e0e                              bra.b   loc_FFF331D8
FFF331CC  f90a050101               loc_FFF331CC mov.l   #101h, 14h[sp]
FFF331D1  0f                                bra.s   loc_FFF331D8
FFF331D2  f90601f8                 loc_FFF331D2 mov.l   #-8, 4[sp]
FFF331D6  2e0d                              bra.b   loc_FFF331E3
FFF331D8  fbee48ac08               loc_FFF331D8 mov.l   #8AC48h, r14
FFF331DD  e10e05                            mov.l   14h[sp], [r14]
FFF331E0  3e0100                            mov.l   #0, 4[sp]
FFF331E3  a809                     loc_FFF331E3 mov.l   4[sp], r1
FFF331E5  a181                              mov.l   r1, 18h[sp]
FFF331E7  6708                              rtsd    #8
FFF331E9  fbee48ac08               sub_FFF331E9 mov.l   #8AC48h, r14  ; <<< FUNC sub_FFF331E9
FFF331EE  f8ea0002                          mov.l   #200h, [r14]
FFF331F2  02                                rts
FFF331F3  6040                     sub_FFF331F3 sub     #4, sp  ; <<< FUNC sub_FFF331F3
FFF331F5  e301                              mov.l   r1, 4+var_4[sp]
FFF331F7  fbee4cac08                        mov.l   #8AC4Ch, r14
FFF331FC  e3e1                              mov.l   r1, [r14]
FFF331FE  6701                              rtsd    #1
FFF33200  6040                     sub_FFF33200 sub     #4, sp  ; <<< FUNC sub_FFF33200
FFF33202  e301                              mov.l   r1, 4+var_4[sp]
FFF33204  fbee14ac08                        mov.l   #8AC14h, r14
FFF33209  e3e1                              mov.l   r1, [r14]
FFF3320B  6701                              rtsd    #1
FFF3320D  6040                     sub_FFF3320D sub     #4, sp  ; <<< FUNC sub_FFF3320D
FFF3320F  9009                              mov.w   r1, 4+var_2[sp]
FFF33211  fbee10ac08                        mov.l   #8AC10h, r14
FFF33216  b809                              movu.w  4+var_2[sp], r1
FFF33218  e3e1                              mov.l   r1, [r14]
FFF3321A  6701                              rtsd    #1
FFF3321C  60c0                     sub_FFF3321C sub     #0Ch, sp  ; <<< FUNC sub_FFF3321C
FFF3321E  fbee38ac08                        mov.l   #8AC38h, r14
FFF33223  e4e001                            mov.l   [r14], 0Ch+var_8[sp]
FFF33226  a809                              mov.l   0Ch+var_8[sp], r1
FFF33228  7c51                              btst    #5, r1
FFF3322A  15                                beq.s   loc_FFF3322F
FFF3322B  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF3322E  0c                                bra.s   loc_FFF33232
FFF3322F  f806fa                   loc_FFF3322F mov.l   #-6, 0Ch+var_C[sp]
FFF33232  ec01                     loc_FFF33232 mov.l   0Ch+var_C[sp], r1
FFF33234  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF33236  6703                              rtsd    #3
FFF33238  6040                              sub     #4, sp
FFF3323A  f80600                            mov.l   #0, [sp]
FFF3323D  6601                              mov.l   #0, r1
FFF3323F  6701                              rtsd    #1
FFF33241  6040                              sub     #4, sp
FFF33243  f806f7                            mov.l   #-9, [sp]
FFF33246  fb16f7                            mov.l   #-9, r1
FFF33249  6701                              rtsd    #1
FFF3324B  6040                              sub     #4, sp
FFF3324D  f806f6                            mov.l   #-0Ah, [sp]
FFF33250  fb16f6                            mov.l   #-0Ah, r1
FFF33253  6701                              rtsd    #1
FFF33255  6080                              sub     #8, sp
FFF33257  8189                              mov.b   r1, 7[sp]
FFF33259  f80604                            mov.l   #4, [sp]
FFF3325C  6641                              mov.l   #4, r1
FFF3325E  6702                              rtsd    #2
FFF33260  6080                              sub     #8, sp
FFF33262  8189                              mov.b   r1, 7[sp]
FFF33264  f80605                            mov.l   #5, [sp]
FFF33267  6651                              mov.l   #5, r1
FFF33269  6702                              rtsd    #2
FFF3326B  6080                     sub_FFF3326B sub     #8, sp  ; <<< FUNC sub_FFF3326B
FFF3326D  8189                              mov.b   r1, 8+var_1[sp]
FFF3326F  fbeec0ad08                        mov.l   #8ADC0h, r14
FFF33274  f8e600                            mov.l   #0, [r14]
FFF33277  fbeec0ad08                        mov.l   #8ADC0h, r14
FFF3327C  f8e601                            mov.l   #1, [r14]
FFF3327F  f80600                            mov.l   #0, 8+var_8[sp]
FFF33282  6601                              mov.l   #0, r1
FFF33284  6702                              rtsd    #2
FFF33286  6040                              sub     #4, sp
FFF33288  f80600                            mov.l   #0, [sp]
FFF3328B  6601                              mov.l   #0, r1
FFF3328D  6701                              rtsd    #1
FFF3328F  395aff                            bsr.w   sub_FFF331E9
FFF33292  02                                rts
FFF33293  6040                              sub     #4, sp
FFF33295  9009                              mov.w   r1, 2[sp]
FFF33297  6121                              cmp     #2, r1
FFF33299  210d                              bne.b   loc_FFF332A6
FFF3329B  fbee50ac08                        mov.l   #8AC50h, r14
FFF332A0  f8eaee40                          mov.l   #40EEh, [r14]
FFF332A4  6701                              rtsd    #1
FFF332A6  fbee50ac08               loc_FFF332A6 mov.l   #8AC50h, r14
FFF332AB  f8eeeec000                        mov.l   #0C0EEh, [r14]
FFF332B0  6701                              rtsd    #1
FFF332B2  6040                              sub     #4, sp
FFF332B4  8089                              mov.b   r1, 3[sp]
FFF332B6  6701                              rtsd    #1
FFF332B8  6040                              sub     #4, sp
FFF332BA  8089                              mov.b   r1, 3[sp]
FFF332BC  6701                              rtsd    #1
FFF332BE  02                                rts
FFF332BF  6040                              sub     #4, sp
FFF332C1  9009                              mov.w   r1, 2[sp]
FFF332C3  6701                              rtsd    #1
FFF332C5  6080                              sub     #8, sp
FFF332C7  a009                              mov.l   r1, 4[sp]
FFF332C9  f806f7                            mov.l   #-9, [sp]
FFF332CC  fb16f7                            mov.l   #-9, r1
FFF332CF  6702                              rtsd    #2
FFF332D1  7100cc                   sub_FFF332D1 add     #-34h, sp, sp  ; <<< FUNC sub_FFF332D1
FFF332D4  c70133                            mov.b   r1, 34h+var_1[sp]
FFF332D7  3e0900                            mov.l   #0, 34h+var_10[sp]
FFF332DA  3e0800                            mov.l   #0, 34h+var_14[sp]
FFF332DD  3e0700                            mov.l   #0, 34h+var_18[sp]
FFF332E0  3e0500                            mov.l   #0, 34h+var_20[sp]
FFF332E3  3e0400                            mov.l   #0, 34h+var_24[sp]
FFF332E6  3e0300                            mov.l   #0, 34h+var_28[sp]
FFF332E9  3e0200                            mov.l   #0, 34h+var_2C[sp]
FFF332EC  fbee40ac08                        mov.l   #8AC40h, r14
FFF332F1  e4e003                            mov.l   [r14], 34h+var_28[sp]
FFF332F4  fbee44ac08                        mov.l   #8AC44h, r14
FFF332F9  e4e002                            mov.l   [r14], 34h+var_2C[sp]
FFF332FC  fbee40ac08                        mov.l   #8AC40h, r14
FFF33301  f8ea1d03                          mov.l   #31Dh, [r14]
FFF33305  fbee44ac08                        mov.l   #8AC44h, r14
FFF3330A  f8ee7f8b00                        mov.l   #8B7Fh, [r14]
FFF3330F  590133                            movu.b  34h+var_1[sp], r1
FFF33312  6111                              cmp     #1, r1
FFF33314  2028                              beq.b   loc_FFF3333C
FFF33316  6121                              cmp     #2, r1
FFF33318  202f                              beq.b   loc_FFF33347
FFF3331A  6131                              cmp     #3, r1
FFF3331C  2013                              beq.b   loc_FFF3332F
FFF3331E  6141                              cmp     #4, r1
FFF33320  2131                              bne.b   loc_FFF33351
FFF33322  f90e093cac08                      mov.l   #8AC3Ch, 34h+var_10[sp]
FFF33328  f90a040001                        mov.l   #100h, 34h+var_24[sp]
FFF3332D  2e2b                              bra.b   loc_FFF33358
FFF3332F  f90e093cac08             loc_FFF3332F mov.l   #8AC3Ch, 34h+var_10[sp]
FFF33335  f90a040002                        mov.l   #200h, 34h+var_24[sp]
FFF3333A  2e1e                              bra.b   loc_FFF33358
FFF3333C  f90e0938ac08             loc_FFF3333C mov.l   #8AC38h, 34h+var_10[sp]
FFF33342  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF33345  2e13                              bra.b   loc_FFF33358
FFF33347  f90e0938ac08             loc_FFF33347 mov.l   #8AC38h, 34h+var_10[sp]
FFF3334D  3e0404                            mov.l   #4, 34h+var_24[sp]
FFF33350  08                                bra.s   loc_FFF33358
FFF33351  f90601fe                 loc_FFF33351 mov.l   #-2, 34h+var_30[sp]
FFF33355  38c600                            bra.w   loc_FFF3341B
FFF33358  3e0a00                   loc_FFF33358 mov.l   #0, 34h+var_C[sp]
FFF3335B  2e6a                              bra.b   loc_FFF333C5
FFF3335D  aa09                     loc_FFF3335D mov.l   34h+var_10[sp], r1
FFF3335F  e41007                            mov.l   [r1], 34h+var_18[sp]
FFF33362  a901                              mov.l   34h+var_24[sp], r1
FFF33364  ef1e                              mov.l   r1, r14
FFF33366  06910e07                          and     34h+var_18[sp].l, r14
FFF3336A  471e                              cmp     r1, r14
FFF3336C  2120                              bne.b   loc_FFF3338C
FFF3336E  a901                              mov.l   34h+var_24[sp], r1
FFF33370  7e01                              not     r1
FFF33372  aa0a                              mov.l   34h+var_10[sp], r2
FFF33374  e321                              mov.l   r1, [r2]
FFF33376  fbee40ac08                        mov.l   #8AC40h, r14
FFF3337B  e10e03                            mov.l   34h+var_28[sp], [r14]
FFF3337E  fbee44ac08                        mov.l   #8AC44h, r14
FFF33383  e10e02                            mov.l   34h+var_2C[sp], [r14]
FFF33386  3e0100                            mov.l   #0, 34h+var_30[sp]
FFF33389  389200                            bra.w   loc_FFF3341B
FFF3338C  fbee3cac08               loc_FFF3338C mov.l   #8AC3Ch, r14
FFF33391  e4e007                            mov.l   [r14], 34h+var_18[sp]
FFF33394  754e48                            mov.l   #48h, r14 ; 'H'
FFF33397  06a10c0e07                        tst     34h+var_18[sp].l, r14
FFF3339C  2132                              bne.b   loc_FFF333CE
FFF3339E  397efe                            bsr.w   sub_FFF3321C
FFF333A1  a201                              mov.l   r1, 34h+var_14[sp]
FFF333A3  aa01                              mov.l   34h+var_14[sp], r1
FFF333A5  6101                              cmp     #0, r1
FFF333A7  2018                              beq.b   loc_FFF333BF
FFF333A9  fbee40ac08                        mov.l   #8AC40h, r14
FFF333AE  e10e03                            mov.l   34h+var_28[sp], [r14]
FFF333B1  fbee44ac08                        mov.l   #8AC44h, r14
FFF333B6  e10e02                            mov.l   34h+var_2C[sp], [r14]
FFF333B9  e5000801                          mov.l   34h+var_14[sp], 34h+var_30[sp]
FFF333BD  2e5e                              bra.b   loc_FFF3341B
FFF333BF  aa81                     loc_FFF333BF mov.l   34h+var_C[sp], r1
FFF333C1  6211                              add     #1, r1
FFF333C3  a281                              mov.l   r1, 34h+var_C[sp]
FFF333C5  aa81                     loc_FFF333C5 mov.l   34h+var_C[sp], r1
FFF333C7  7701000010                        cmp     #100000h, r1
FFF333CC  2391                              bltu.b  loc_FFF3335D
FFF333CE  590133                   loc_FFF333CE movu.b  34h+var_1[sp], r1
FFF333D1  6111                              cmp     #1, r1
FFF333D3  2134                              bne.b   loc_FFF33407
FFF333D5  fbee38ac08                        mov.l   #8AC38h, r14
FFF333DA  e4e006                            mov.l   [r14], 34h+var_1C[sp]
FFF333DD  fbee3cac08                        mov.l   #8AC3Ch, r14
FFF333E2  e4e005                            mov.l   [r14], 34h+var_20[sp]
FFF333E5  a981                              mov.l   34h+var_1C[sp], r1
FFF333E7  6411                              and     #1, r1
FFF333E9  6111                              cmp     #1, r1
FFF333EB  2011                              beq.b   loc_FFF333FC
FFF333ED  a909                              mov.l   34h+var_20[sp], r1
FFF333EF  76210040                          and     #4000h, r1
FFF333F3  76010040                          cmp     #4000h, r1
FFF333F7  1d                                bne.s   loc_FFF333FC
FFF333F8  f80601                            mov.l   #1, 34h+var_34[sp]
FFF333FB  0c                                bra.s   loc_FFF333FF
FFF333FC  f80600                   loc_FFF333FC mov.l   #0, 34h+var_34[sp]
FFF333FF  ec01                     loc_FFF333FF mov.l   34h+var_34[sp], r1
FFF33401  6101                              cmp     #0, r1
FFF33403  14                                beq.s   loc_FFF33407
FFF33404  393503                            bsr.w   sub_FFF33739
FFF33407  fbee40ac08               loc_FFF33407 mov.l   #8AC40h, r14
FFF3340C  e10e03                            mov.l   34h+var_28[sp], [r14]
FFF3340F  fbee44ac08                        mov.l   #8AC44h, r14
FFF33414  e10e02                            mov.l   34h+var_2C[sp], [r14]
FFF33417  f90601ff                          mov.l   #-1, 34h+var_30[sp]
FFF3341B  a809                     loc_FFF3341B mov.l   34h+var_30[sp], r1
FFF3341D  a289                              mov.l   r1, 34h+var_8[sp]
FFF3341F  670d                              rtsd    #0Dh
FFF33421  7100e4                   sub_FFF33421 add     #-1Ch, sp, sp  ; <<< FUNC sub_FFF33421
FFF33424  8689                              mov.b   r1, 1Ch+var_1[sp]
FFF33426  8682                              mov.b   r2, 1Ch+var_2[sp]
FFF33428  a10b                              mov.l   r3, 1Ch+var_8[sp]
FFF3342A  3e0300                            mov.l   #0, 1Ch+var_10[sp]
FFF3342D  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF33430  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF33433  fbee40ac08                        mov.l   #8AC40h, r14
FFF33438  e4e002                            mov.l   [r14], 1Ch+var_14[sp]
FFF3343B  fbee44ac08                        mov.l   #8AC44h, r14
FFF33440  e4e001                            mov.l   [r14], 1Ch+var_18[sp]
FFF33443  fbee40ac08                        mov.l   #8AC40h, r14
FFF33448  f8ea1d03                          mov.l   #31Dh, [r14]
FFF3344C  fbee44ac08                        mov.l   #8AC44h, r14
FFF33451  f8ee7f8b00                        mov.l   #8B7Fh, [r14]
FFF33456  fbee38ac08                        mov.l   #8AC38h, r14
FFF3345B  e4e003                            mov.l   [r14], 1Ch+var_10[sp]
FFF3345E  a889                              mov.l   1Ch+var_10[sp], r1
FFF33460  7721f8ff00                        and     #0FFF8h, r1
FFF33465  fbee38ac08                        mov.l   #8AC38h, r14
FFF3346A  e3e1                              mov.l   r1, [r14]
FFF3346C  fbee3cac08                        mov.l   #8AC3Ch, r14
FFF33471  e4e003                            mov.l   [r14], 1Ch+var_10[sp]
FFF33474  a889                              mov.l   1Ch+var_10[sp], r1
FFF33476  76210008                          and     #800h, r1
FFF3347A  fbee3cac08                        mov.l   #8AC3Ch, r14
FFF3347F  e3e1                              mov.l   r1, [r14]
FFF33481  fbee40ac08                        mov.l   #8AC40h, r14
FFF33486  e10e02                            mov.l   1Ch+var_14[sp], [r14]
FFF33489  fbee44ac08                        mov.l   #8AC44h, r14
FFF3348E  e10e01                            mov.l   1Ch+var_18[sp], [r14]
FFF33491  fbee08ac08                        mov.l   #8AC08h, r14
FFF33496  e10e05                            mov.l   1Ch+var_8[sp], [r14]
FFF33499  fbee3cac08                        mov.l   #8AC3Ch, r14
FFF3349E  e4e003                            mov.l   [r14], 1Ch+var_10[sp]
FFF334A1  a889                              mov.l   1Ch+var_10[sp], r1
FFF334A3  7ce1                              btst    #0Eh, r1
FFF334A5  16                                beq.s   loc_FFF334AB
FFF334A6  f806f7                            mov.l   #-9, 1Ch+var_1C[sp]
FFF334A9  2e60                              bra.b   loc_FFF33509
FFF334AB  b681                     loc_FFF334AB movu.b  1Ch+var_2[sp], r1
FFF334AD  6101                              cmp     #0, r1
FFF334AF  b689                              movu.b  1Ch+var_1[sp], r1
FFF334B1  2145                              bne.b   loc_FFF334F6
FFF334B3  6171                              cmp     #7, r1
FFF334B5  212d                              bne.b   loc_FFF334E2
FFF334B7  fbe2e4e1ecff                      mov.l   #unk_FFECE1E4, r14
FFF334BD  b689                              movu.b  1Ch+var_1[sp], r1
FFF334BF  fed1ee                            movu.w  [r1, r14], r14
FFF334C2  a909                              mov.l   1Ch+var_8[sp], r1
FFF334C4  6101                              cmp     #0, r1
FFF334C6  210f                              bne.b   loc_FFF334D5
FFF334C8  763e0003                          or      #300h, r14
FFF334CC  fbfe00ac08                        mov.l   #8AC00h, r15
FFF334D1  e3fe                              mov.l   r14, [r15]
FFF334D3  2e33                              bra.b   loc_FFF33506
FFF334D5  763e0005                 loc_FFF334D5 or      #500h, r14
FFF334D9  fbfe00ac08                        mov.l   #8AC00h, r15
FFF334DE  e3fe                              mov.l   r14, [r15]
FFF334E0  2e26                              bra.b   loc_FFF33506
FFF334E2  fbe2e4e1ecff             loc_FFF334E2 mov.l   #unk_FFECE1E4, r14
FFF334E8  b689                              movu.b  1Ch+var_1[sp], r1
FFF334EA  fed1ee                            movu.w  [r1, r14], r14
FFF334ED  fbfe00ac08                        mov.l   #8AC00h, r15
FFF334F2  e3fe                              mov.l   r14, [r15]
FFF334F4  2e12                              bra.b   loc_FFF33506
FFF334F6  fbe264e2ecff             loc_FFF334F6 mov.l   #unk_FFECE264, r14
FFF334FC  fed1ee                            movu.w  [r1, r14], r14
FFF334FF  fbfe00ac08                        mov.l   #8AC00h, r15
FFF33504  e3fe                              mov.l   r14, [r15]
FFF33506  f80600                   loc_FFF33506 mov.l   #0, 1Ch+var_1C[sp]
FFF33509  ec01                     loc_FFF33509 mov.l   1Ch+var_1C[sp], r1
FFF3350B  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF3350D  6707                              rtsd    #7
FFF3350F  60c0                     sub_FFF3350F sub     #0Ch, sp  ; <<< FUNC sub_FFF3350F
FFF33511  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF33514  6611                              mov.l   #1, r1
FFF33516  39bbfd                            bsr.w   sub_FFF332D1
FFF33519  6101                              cmp     #0, r1
FFF3351B  16                                beq.s   loc_FFF33521
FFF3351C  f806ff                            mov.l   #-1, 0Ch+var_C[sp]
FFF3351F  2e13                              bra.b   loc_FFF33532
FFF33521  fbee3cac08               loc_FFF33521 mov.l   #8AC3Ch, r14
FFF33526  e4e001                            mov.l   [r14], 0Ch+var_8[sp]
FFF33529  a809                              mov.l   0Ch+var_8[sp], r1
FFF3352B  77217f8000                        and     #807Fh, r1
FFF33530  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF33532  ec01                     loc_FFF33532 mov.l   0Ch+var_C[sp], r1
FFF33534  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF33536  6703                              rtsd    #3
FFF33538  7100ec                   sub_FFF33538 add     #-14h, sp, sp  ; <<< FUNC sub_FFF33538
FFF3353B  8489                              mov.b   r1, 14h+var_1[sp]
FFF3353D  8482                              mov.b   r2, 14h+var_2[sp]
FFF3353F  a08b                              mov.l   r3, 14h+var_8[sp]
FFF33541  a084                              mov.l   r4, 14h+var_C[sp]
FFF33543  f80600                            mov.l   #0, 14h+var_14[sp]
FFF33546  a88b                              mov.l   14h+var_8[sp], r3
FFF33548  b482                              movu.b  14h+var_2[sp], r2
FFF3354A  b489                              movu.b  14h+var_1[sp], r1
FFF3354C  39d5fe                            bsr.w   sub_FFF33421
FFF3354F  39c0ff                            bsr.w   sub_FFF3350F
FFF33552  e301                              mov.l   r1, 14h+var_14[sp]
FFF33554  ec01                              mov.l   14h+var_14[sp], r1
FFF33556  a009                              mov.l   r1, 14h+var_10[sp]
FFF33558  6705                              rtsd    #5
FFF3355A  7100ec                   sub_FFF3355A add     #-14h, sp, sp  ; <<< FUNC sub_FFF3355A
FFF3355D  9209                              mov.w   r1, 14h+var_2[sp]
FFF3355F  a08a                              mov.l   r2, 14h+var_8[sp]
FFF33561  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF33564  a889                              mov.l   14h+var_8[sp], r1
FFF33566  7211b002                          add     #2B0h, r1, r1
FFF3356A  a009                              mov.l   r1, 14h+var_10[sp]
FFF3356C  9a09                              mov.w   14h+var_2[sp], r1
FFF3356E  6111                              cmp     #1, r1
FFF33570  16                                beq.s   loc_FFF33576
FFF33571  9a09                              mov.w   14h+var_2[sp], r1
FFF33573  6161                              cmp     #6, r1
FFF33575  1d                                bne.s   loc_FFF3357A
FFF33576  f80601                   loc_FFF33576 mov.l   #1, 14h+var_14[sp]
FFF33579  0c                                bra.s   loc_FFF3357D
FFF3357A  f80600                   loc_FFF3357A mov.l   #0, 14h+var_14[sp]
FFF3357D  ec01                     loc_FFF3357D mov.l   14h+var_14[sp], r1
FFF3357F  6101                              cmp     #0, r1
FFF33581  1e                                bne.s   loc_FFF33587
FFF33582  9a09                              mov.w   14h+var_2[sp], r1
FFF33584  6171                              cmp     #7, r1
FFF33586  1d                                bne.s   loc_FFF3358B
FFF33587  f80601                   loc_FFF33587 mov.l   #1, 14h+var_14[sp]
FFF3358A  0c                                bra.s   loc_FFF3358E
FFF3358B  f80600                   loc_FFF3358B mov.l   #0, 14h+var_14[sp]
FFF3358E  ec01                     loc_FFF3358E mov.l   14h+var_14[sp], r1
FFF33590  6101                              cmp     #0, r1
FFF33592  201b                              beq.b   loc_FFF335AD
FFF33594  a809                              mov.l   14h+var_10[sp], r1
FFF33596  f81600                            mov.l   #0, [r1]
FFF33599  fbee18ac08                        mov.l   #8AC18h, r14
FFF3359E  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF335A1  a809                              mov.l   14h+var_10[sp], r1
FFF335A3  ec1e                              mov.l   [r1], r14
FFF335A5  06950e02                          or      14h+var_C[sp].l, r14
FFF335A9  e31e                              mov.l   r14, [r1]
FFF335AB  6705                              rtsd    #5
FFF335AD  9a09                     loc_FFF335AD mov.w   14h+var_2[sp], r1
FFF335AF  6131                              cmp     #3, r1
FFF335B1  211b                              bne.b   loc_FFF335CC
FFF335B3  a809                              mov.l   14h+var_10[sp], r1
FFF335B5  f81600                            mov.l   #0, [r1]
FFF335B8  fbee18ac08                        mov.l   #8AC18h, r14
FFF335BD  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF335C0  a809                              mov.l   14h+var_10[sp], r1
FFF335C2  ec1e                              mov.l   [r1], r14
FFF335C4  06950e02                          or      14h+var_C[sp].l, r14
FFF335C8  e31e                              mov.l   r14, [r1]
FFF335CA  6705                              rtsd    #5
FFF335CC  fbee30ac08               loc_FFF335CC mov.l   #8AC30h, r14
FFF335D1  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF335D4  a881                              mov.l   14h+var_C[sp], r1
FFF335D6  6901                              shlr    #10h, r1
FFF335D8  a80a                              mov.l   14h+var_10[sp], r2
FFF335DA  c321                              mov.b   r1, [r2]
FFF335DC  a881                              mov.l   14h+var_C[sp], r1
FFF335DE  6881                              shlr    #8, r1
FFF335E0  a80a                              mov.l   14h+var_10[sp], r2
FFF335E2  8029                              mov.b   r1, 1[r2]
FFF335E4  b201                              movu.b  14h+var_C[sp], r1
FFF335E6  a80a                              mov.l   14h+var_10[sp], r2
FFF335E8  80a1                              mov.b   r1, 2[r2]
FFF335EA  fbee28ac08                        mov.l   #8AC28h, r14
FFF335EF  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF335F2  a881                              mov.l   14h+var_C[sp], r1
FFF335F4  6981                              shlr    #18h, r1
FFF335F6  a80a                              mov.l   14h+var_10[sp], r2
FFF335F8  80a9                              mov.b   r1, 3[r2]
FFF335FA  a881                              mov.l   14h+var_C[sp], r1
FFF335FC  6901                              shlr    #10h, r1
FFF335FE  a80a                              mov.l   14h+var_10[sp], r2
FFF33600  8121                              mov.b   r1, 4[r2]
FFF33602  a881                              mov.l   14h+var_C[sp], r1
FFF33604  6881                              shlr    #8, r1
FFF33606  a80a                              mov.l   14h+var_10[sp], r2
FFF33608  8129                              mov.b   r1, 5[r2]
FFF3360A  b201                              movu.b  14h+var_C[sp], r1
FFF3360C  a80a                              mov.l   14h+var_10[sp], r2
FFF3360E  81a1                              mov.b   r1, 6[r2]
FFF33610  fbee20ac08                        mov.l   #8AC20h, r14
FFF33615  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF33618  a881                              mov.l   14h+var_C[sp], r1
FFF3361A  6981                              shlr    #18h, r1
FFF3361C  a80a                              mov.l   14h+var_10[sp], r2
FFF3361E  81a9                              mov.b   r1, 7[r2]
FFF33620  a881                              mov.l   14h+var_C[sp], r1
FFF33622  6901                              shlr    #10h, r1
FFF33624  a80a                              mov.l   14h+var_10[sp], r2
FFF33626  8221                              mov.b   r1, 8[r2]
FFF33628  a881                              mov.l   14h+var_C[sp], r1
FFF3362A  6881                              shlr    #8, r1
FFF3362C  a80a                              mov.l   14h+var_10[sp], r2
FFF3362E  8229                              mov.b   r1, 9[r2]
FFF33630  b201                              movu.b  14h+var_C[sp], r1
FFF33632  a80a                              mov.l   14h+var_10[sp], r2
FFF33634  82a1                              mov.b   r1, 0Ah[r2]
FFF33636  fbee18ac08                        mov.l   #8AC18h, r14
FFF3363B  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF3363E  a881                              mov.l   14h+var_C[sp], r1
FFF33640  6981                              shlr    #18h, r1
FFF33642  a80a                              mov.l   14h+var_10[sp], r2
FFF33644  82a9                              mov.b   r1, 0Bh[r2]
FFF33646  a881                              mov.l   14h+var_C[sp], r1
FFF33648  6901                              shlr    #10h, r1
FFF3364A  a80a                              mov.l   14h+var_10[sp], r2
FFF3364C  8321                              mov.b   r1, 0Ch[r2]
FFF3364E  a881                              mov.l   14h+var_C[sp], r1
FFF33650  6881                              shlr    #8, r1
FFF33652  a80a                              mov.l   14h+var_10[sp], r2
FFF33654  8329                              mov.b   r1, 0Dh[r2]
FFF33656  b201                              movu.b  14h+var_C[sp], r1
FFF33658  a80a                              mov.l   14h+var_10[sp], r2
FFF3365A  83a1                              mov.b   r1, 0Eh[r2]
FFF3365C  6705                              rtsd    #5
FFF3365E  7100e8                            add     #-18h, sp, sp
FFF33661  9289                              mov.w   r1, 16h[sp]
FFF33663  9282                              mov.w   r2, 14h[sp]
FFF33665  a103                              mov.l   r3, 10h[sp]
FFF33667  ba89                              movu.w  16h[sp], r1
FFF33669  398afb                            bsr.w   sub_FFF331F3
FFF3366C  ba81                              movu.w  14h[sp], r1
FFF3366E  3992fb                            bsr.w   sub_FFF33200
FFF33671  ba81                              movu.w  14h[sp], r1
FFF33673  6111                              cmp     #1, r1
FFF33675  1f                                bne.s   loc_FFF3367C
FFF33676  6601                              mov.l   #0, r1
FFF33678  3995fb                            bsr.w   sub_FFF3320D
FFF3367B  08                                bra.s   loc_FFF33683
FFF3367C  fb1a0001                 loc_FFF3367C mov.l   #100h, r1
FFF33680  398dfb                            bsr.w   sub_FFF3320D
FFF33683  3e0100                   loc_FFF33683 mov.l   #0, 4[sp]
FFF33686  2e1c                              bra.b   loc_FFF336A2
FFF33688  a904                     loc_FFF33688 mov.l   10h[sp], r4
FFF3368A  ba8b                              movu.w  16h[sp], r3
FFF3368C  6602                              mov.l   #0, r2
FFF3368E  754110                            mov.l   #10h, r1
FFF33691  39a7fe                            bsr.w   sub_FFF33538
FFF33694  a081                              mov.l   r1, 8[sp]
FFF33696  a881                              mov.l   8[sp], r1
FFF33698  6101                              cmp     #0, r1
FFF3369A  200e                              beq.b   loc_FFF336A8
FFF3369C  3e0100                            mov.l   #0, 4[sp]
FFF3369F  3e0101                            mov.l   #1, 4[sp]
FFF336A2  a809                     loc_FFF336A2 mov.l   4[sp], r1
FFF336A4  6131                              cmp     #3, r1
FFF336A6  29e2                              blt.b   loc_FFF33688
FFF336A8  a809                     loc_FFF336A8 mov.l   4[sp], r1
FFF336AA  6131                              cmp     #3, r1
FFF336AC  2907                              blt.b   loc_FFF336B3
FFF336AE  f806f7                            mov.l   #-9, [sp]
FFF336B1  2e25                              bra.b   loc_FFF336D6
FFF336B3  a902                     loc_FFF336B3 mov.l   10h[sp], r2
FFF336B5  6611                              mov.l   #1, r1
FFF336B7  39a3fe                            bsr.w   sub_FFF3355A
FFF336BA  a901                              mov.l   10h[sp], r1
FFF336BC  5e1e6301                          movu.w  2C6h[r1], r14

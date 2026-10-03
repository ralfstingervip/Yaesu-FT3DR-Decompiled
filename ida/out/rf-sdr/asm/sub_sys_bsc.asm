; window sys_bsc file 337400-3375C0 map FFF37400-FFF375C0 forced 123
; ==== sys_bsc  FFF37400-FFF375C0 ====
FFF37400  62c0                              add     #0Ch, sp
FFF37402  08                                bra.s   loc_FFF3740A
FFF37403  f0e0                              bset    #0, [r14].b
FFF37405  fbee62c008                        mov.l   #8C062h, r14
FFF3740A  f0e1                     loc_FFF3740A bset    #1, [r14].b
FFF3740C  fbee04c008                        mov.l   #8C004h, r14
FFF37411  f1e860                            bclr    #0, 60h[r14].b
FFF37414  fbee00c008                        mov.l   #8C000h, r14
FFF37419  f1e860                            bclr    #0, 60h[r14].b
FFF3741C  fbee00c008                        mov.l   #8C000h, r14
FFF37421  f1e960                            bclr    #1, 60h[r14].b
FFF37424  fbeefe0308                        mov.l   #803FEh, r14
FFF37429  f8e90ba5                          mov.w   #-5AF5h, [r14]
FFF3742D  fbeefe0308                        mov.l   #803FEh, r14
FFF37432  f2ee82be                          bclr    #6, -417Eh[r14].b
FFF37436  fbeefe0308                        mov.l   #803FEh, r14
FFF3743B  f8e900a5                          mov.w   #-5B00h, [r14]
FFF3743F  7fa8                              setpsw  i
FFF37441  02                                rts
FFF37442  02                       loc_FFF37442 rts
FFF37443  6040                              sub     #4, sp
FFF37445  fbee060008                        mov.l   #80006h, r14
FFF3744A  fae9fc0103a5                      mov.w   #-5AFDh, 3F8h[r14]
FFF37450  fbee060008                        mov.l   #80006h, r14
FFF37455  f8e9035a                          mov.w   #5A03h, [r14]
FFF37459  fbee060008               loc_FFF37459 mov.l   #80006h, r14
FFF3745E  dcee                              mov.w   [r14], r14
FFF37460  681e                              shlr    #1, r14
FFF37462  641e                              and     #1, r14
FFF37464  611e                              cmp     #1, r14
FFF37466  210e                              bne.b   loc_FFF37474
FFF37468  fbee060008                        mov.l   #80006h, r14
FFF3746D  5cee                              movu.w  [r14], r14
FFF3746F  641e                              and     #1, r14
FFF37471  611e                              cmp     #1, r14
FFF37473  15                                beq.s   loc_FFF37478
FFF37474  f80601                   loc_FFF37474 mov.l   #1, [sp]
FFF37477  0c                                bra.s   loc_FFF3747B
FFF37478  f80600                   loc_FFF37478 mov.l   #0, [sp]
FFF3747B  ec01                     loc_FFF3747B mov.l   [sp], r1
FFF3747D  6101                              cmp     #0, r1
FFF3747F  21da                              bne.b   loc_FFF37459
FFF37481  fb1e060008                        mov.l   #80006h, r1
FFF37486  3d11ff                            mov.w   #-1, 2[r1]
FFF37489  fb1e060008               loc_FFF37489 mov.l   #80006h, r1
FFF3748E  b819                              movu.w  2[r1], r1
FFF37490  7551ff                            cmp     #-1, r1
FFF37493  21f6                              bne.b   loc_FFF37489
FFF37495  fbee060008                        mov.l   #80006h, r14
FFF3749A  fae9fc0100a5                      mov.w   #-5B00h, 3F8h[r14]
FFF374A0  fbee00c108                        mov.l   #8C100h, r14
FFF374A5  f8e406                            mov.b   #6, [r14]
FFF374A8  fb1e00c108                        mov.l   #8C100h, r1
FFF374AD  3c1228                            mov.b   #28h, 2[r1] ; '('
FFF374B0  fb1e00c108                        mov.l   #8C100h, r1
FFF374B5  3c1300                            mov.b   #0, 3[r1]
FFF374B8  fb1e00c108                        mov.l   #8C100h, r1
FFF374BD  3c14ff                            mov.b   #-1, 4[r1]
FFF374C0  fb1e00c108                        mov.l   #8C100h, r1
FFF374C5  3c150f                            mov.b   #0Fh, 5[r1]
FFF374C8  fb1e00c108                        mov.l   #8C100h, r1
FFF374CD  3c1653                            mov.b   #53h, 6[r1] ; 'S'
FFF374D0  fb1e00c108                        mov.l   #8C100h, r1
FFF374D5  3c1700                            mov.b   #0, 7[r1]
FFF374D8  fbee103008                        mov.l   #83010h, r14
FFF374DD  f9e9010103                        mov.w   #301h, 2[r14]
FFF374E2  fb1e103008                        mov.l   #83010h, r1
FFF374E7  3d1901                            mov.w   #1, 12h[r1]
FFF374EA  fbee103008                        mov.l   #83010h, r14
FFF374EF  f9e20102020202                    mov.l   #2020202h, 4[r14]
FFF374F6  fbee103008                        mov.l   #83010h, r14
FFF374FB  f9e20505050505                    mov.l   #5050505h, 14h[r14]
FFF37502  fbee103008                        mov.l   #83010h, r14
FFF37507  f9e20210011101                    mov.l   #1110110h, 8[r14]
FFF3750E  fbee103008                        mov.l   #83010h, r14
FFF37513  f9e20633013212                    mov.l   #12320133h, 18h[r14]
FFF3751A  fbee103008                        mov.l   #83010h, r14
FFF3751F  fae5f90300                        mov.w   #0, 7F2h[r14]
FFF37524  fbee103008                        mov.l   #83010h, r14
FFF37529  fae5010401                        mov.w   #1, 802h[r14]
FFF3752E  fbee103008                        mov.l   #83010h, r14
FFF37533  fae5090401                        mov.w   #1, 812h[r14]
FFF37538  6701                              rtsd    #1
FFF3753A  fbee123808                        mov.l   #83812h, r14
FFF3753F  f8e500                            mov.w   #0, [r14]
FFF37542  fb1e123808                        mov.l   #83812h, r1
FFF37547  3d9000                            mov.w   #0, 20h[r1]
FFF3754A  fbee00c108                        mov.l   #8C100h, r14
FFF3754F  f0e1                              bset    #1, [r14].b
FFF37551  fbee00c108                        mov.l   #8C100h, r14
FFF37556  f0e3                              bset    #3, [r14].b
FFF37558  fbee040008                        mov.l   #80004h, r14
FFF3755D  fae9fd0103a5                      mov.w   #-5AFDh, 3FAh[r14]
FFF37563  fb1e040008                        mov.l   #80004h, r1
FFF37568  a99a                              mov.l   1Ch[r1], r2
FFF3756A  7972                              bset    #17h, r2
FFF3756C  a19a                              mov.l   r2, 1Ch[r1]
FFF3756E  fbee040008                        mov.l   #80004h, r14
FFF37573  f9e901015a                        mov.w   #5A01h, 2[r14]
FFF37578  fb1e040008                        mov.l   #80004h, r1
FFF3757D  a99a                              mov.l   1Ch[r1], r2
FFF3757F  7b72                              bclr    #17h, r2
FFF37581  a19a                              mov.l   r2, 1Ch[r1]
FFF37583  fbee040008                        mov.l   #80004h, r14
FFF37588  fae9fd0100a5                      mov.w   #-5B00h, 3FAh[r14]
FFF3758E  02                                rts
FFF3758F  02                                rts
FFF37590  fbee007a08               loc_FFF37590 mov.l   #87A00h, r14
FFF37595  f8e401                            mov.b   #1, [r14]
FFF37598  fbee007a08               loc_FFF37598 mov.l   #87A00h, r14
FFF3759D  58ee                              movu.b  [r14], r14
FFF3759F  611e                              cmp     #1, r14
FFF375A1  21f7                              bne.b   loc_FFF37598
FFF375A3  02                                rts
FFF375A4  02                                rts
FFF375A5  02                                rts
FFF375A6  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF375AC  58ee                              movu.b  [r14], r14
FFF375AE  613e                              cmp     #3, r14
FFF375B0  2a16                              bgt.b   loc_FFF375C6
FFF375B2  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF375B8  58ee                              movu.b  [r14], r14
FFF375BA  fbf29c81edff                      mov.l   #off_FFED819C, r15

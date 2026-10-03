; window tpu_a file 2DE260-2DE360 map FFEDE260-FFEDE360 forced 88
; ==== tpu_a  FFEDE260-FFEDE360 ====
FFEDE260  8a00                              mov.b   8[sp], sp
FFEDE262  00                                brk
FFEDE263  c3e1                              mov.b   r1, [r14]
FFEDE265  6701                              rtsd    #1
FFEDE267  6040                              sub     #4, sp
FFEDE269  fbe28a8a0000                      mov.l   #8A8Ah, r14
FFEDE26F  c4e003                            mov.b   [r14], 3[sp]
FFEDE272  b089                              movu.b  3[sp], r1
FFEDE274  5b11                              movu.b  r1, r1
FFEDE276  6701                              rtsd    #1
FFEDE278  fbee27c008                        mov.l   #8C027h, r14
FFEDE27D  f0e3                              bset    #3, [r14].b
FFEDE27F  66a1                              mov.l   #0Ah, r1
FFEDE281  397a00                            bsr.w   sub_FFEDE2FB
FFEDE284  fbee27c008                        mov.l   #8C027h, r14
FFEDE289  f0eb                              bclr    #3, [r14].b
FFEDE28B  6611                              mov.l   #1, r1
FFEDE28D  396e00                            bsr.w   sub_FFEDE2FB
FFEDE290  fbee27c008                        mov.l   #8C027h, r14
FFEDE295  f0e3                              bset    #3, [r14].b
FFEDE297  02                                rts
FFEDE298  6040                     loc_FFEDE298 sub     #4, sp
FFEDE29A  8089                              mov.b   r1, 3[sp]
FFEDE29C  fbee28c008                        mov.l   #8C028h, r14
FFEDE2A1  f0ea                              bclr    #2, [r14].b
FFEDE2A3  fbe200000006                      mov.l   #6000000h, r14
FFEDE2A9  c10e03                            mov.b   3[sp], [r14]
FFEDE2AC  fbee28c008                        mov.l   #8C028h, r14
FFEDE2B1  f0e2                              bset    #2, [r14].b
FFEDE2B3  6701                              rtsd    #1
FFEDE2B5  6040                     loc_FFEDE2B5 sub     #4, sp
FFEDE2B7  8089                              mov.b   r1, 3[sp]
FFEDE2B9  fbe200000006                      mov.l   #6000000h, r14
FFEDE2BF  c3e1                              mov.b   r1, [r14]
FFEDE2C1  6701                              rtsd    #1
FFEDE2C3  6040                     sub_FFEDE2C3 sub     #4, sp  ; <<< FUNC sub_FFEDE2C3
FFEDE2C5  9009                              mov.w   r1, 4+var_2[sp]
FFEDE2C7  fbe200000006                      mov.l   #6000000h, r14
FFEDE2CD  d3e1                              mov.w   r1, [r14]
FFEDE2CF  6701                              rtsd    #1
FFEDE2D1  fbee008108               loc_FFEDE2D1 mov.l   #88100h, r14
FFEDE2D6  f0ea                              bclr    #2, [r14].b
FFEDE2D8  fbee308108                        mov.l   #88130h, r14
FFEDE2DD  f8e422                            mov.b   #22h, [r14] ; '"'
FFEDE2E0  fb1e308108                        mov.l   #88130h, r1
FFEDE2E5  3c1200                            mov.b   #0, 2[r1]
FFEDE2E8  fbee308108                        mov.l   #88130h, r14
FFEDE2ED  f9e904b80b                        mov.w   #0BB8h, 8[r14]
FFEDE2F2  fb1e308108                        mov.l   #88130h, r1
FFEDE2F7  3c1100                            mov.b   #0, 1[r1]
FFEDE2FA  02                                rts
FFEDE2FB  6040                     sub_FFEDE2FB sub     #4, sp  ; <<< FUNC sub_FFEDE2FB
FFEDE2FD  9009                              mov.w   r1, 4+var_2[sp]
FFEDE2FF  fbee358108                        mov.l   #88135h, r14
FFEDE304  621e                              add     #1, r14
FFEDE306  f8e500                            mov.w   #0, [r14]
FFEDE309  fbee008108                        mov.l   #88100h, r14
FFEDE30E  f0e2                              bset    #2, [r14].b
FFEDE310  f80500                            mov.w   #0, 4+var_4[sp]
FFEDE313  2e18                              bra.b   loc_FFEDE32B
FFEDE315  fbee358108               loc_FFEDE315 mov.l   #88135h, r14
FFEDE31A  f4e0                              btst    #0, [r14].b
FFEDE31C  20f9                              beq.b   loc_FFEDE315
FFEDE31E  fbee358108                        mov.l   #88135h, r14
FFEDE323  f0e8                              bclr    #0, [r14].b
FFEDE325  dc01                              mov.w   4+var_4[sp], r1
FFEDE327  6211                              add     #1, r1
FFEDE329  d301                              mov.w   r1, 4+var_4[sp]
FFEDE32B  5c01                     loc_FFEDE32B movu.w  4+var_4[sp], r1
FFEDE32D  06c50101                          cmp     4+var_2[sp].uw, r1
FFEDE331  29e4                              blt.b   loc_FFEDE315
FFEDE333  fbee008108                        mov.l   #88100h, r14
FFEDE338  f0ea                              bclr    #2, [r14].b
FFEDE33A  6701                              rtsd    #1
FFEDE33C  6080                              sub     #8, sp
FFEDE33E  a009                              mov.l   r1, 4[sp]
FFEDE340  7544ef                            mov.l   #-11h, r4
FFEDE343  fb2a3f01                          mov.l   #13Fh, r2
FFEDE347  6601                              mov.l   #0, r1
FFEDE349  ef13                              mov.l   r1, r3
FFEDE34B  39aafe                            bsr.w   sub_FFEDE1F5
FFEDE34E  3d0100                            mov.w   #0, 2[sp]
FFEDE351  2e2d                              bra.b   loc_FFEDE37E
FFEDE353  f80500                   loc_FFEDE353 mov.w   #0, [sp]
FFEDE356  2e1a                              bra.b   loc_FFEDE370
FFEDE358  b809                     loc_FFEDE358 movu.w  2[sp], r1
FFEDE35A  76118002                          mul     #280h, r1
FFEDE35E  06890101                          add     4[sp].l, r1

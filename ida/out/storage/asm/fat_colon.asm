; ==== fat_colon  FFF2C200-FFF2C380  (file 32C200-32C380) ====
FFF2C200  6707                   sub_FFF2C200 rtsd    #7   ; <<<< FUNC sub_FFF2C200
FFF2C202  7100e4                 sub_FFF2C202 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2C202
FFF2C205  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2C207  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2C209  a981                              mov.l   1Ch+var_4[sp], r1
FFF2C20B  e41002                            mov.l   [r1], 1Ch+var_14[sp]
FFF2C20E  a881                              mov.l   1Ch+var_14[sp], r1
FFF2C210  05dd9afe                          bsr.a   sub_FFF15CED
FFF2C214  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2C216  a889                              mov.l   1Ch+var_10[sp], r1
FFF2C218  6101                              cmp     #0, r1
FFF2C21A  200f                              beq.b   loc_FFF2C229
FFF2C21C  6602                              mov.l   #0, r2
FFF2C21E  fb16db                            mov.l   #-25h, r1
FFF2C221  055a2cff                          bsr.a   sub_FFF1EE7B
FFF2C225  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2C227  2e14                              bra.b   loc_FFF2C23B
FFF2C229  a90a                   loc_FFF2C229 mov.l   1Ch+var_8[sp], r2
FFF2C22B  a981                              mov.l   1Ch+var_4[sp], r1
FFF2C22D  391400                            bsr.w   sub_FFF2C241
FFF2C230  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2C232  a881                              mov.l   1Ch+var_14[sp], r1
FFF2C234  05c49afe                          bsr.a   sub_FFF15CF8
FFF2C238  e10001                            mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF2C23B  ec01                   loc_FFF2C23B mov.l   1Ch+var_1C[sp], r1
FFF2C23D  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF2C23F  6707                              rtsd    #7
FFF2C241  7ea6                   sub_FFF2C241 push.l  r6   ; <<<< FUNC sub_FFF2C241
FFF2C243  7100c8                            add     #-38h, sp, sp
FFF2C246  a309                              mov.l   r1, 38h+var_4[sp]
FFF2C248  a302                              mov.l   r2, 38h+var_8[sp]
FFF2C24A  3c8b00                            mov.b   #0, 38h+var_1D[sp]
FFF2C24D  3c8a00                            mov.b   #0, 38h+var_1E[sp]
FFF2C250  3d0c00                            mov.w   #0, 38h+var_20[sp]
FFF2C253  ab09                              mov.l   38h+var_4[sp], r1
FFF2C255  e41005                            mov.l   [r1], 38h+var_24[sp]
FFF2C258  3e0400                            mov.l   #0, 38h+var_28[sp]
FFF2C25B  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF2C25E  3e0200                            mov.l   #0, 38h+var_30[sp]
FFF2C261  ab09                              mov.l   38h+var_4[sp], r1
FFF2C263  f9144200                          mov.b   #0, 42h[r1]
FFF2C267  6601                              mov.l   #0, r1
FFF2C269  ef12                              mov.l   r1, r2
FFF2C26B  05102cff                          bsr.a   sub_FFF1EE7B
FFF2C26F  ab09                              mov.l   38h+var_4[sp], r1
FFF2C271  b119                              movu.b  5[r1], r1
FFF2C273  6101                              cmp     #0, r1
FFF2C275  3bba01                            bne.w   loc_FFF2C42F
FFF2C278  ab09                              mov.l   38h+var_4[sp], r1
FFF2C27A  ec1e                              mov.l   [r1], r14
FFF2C27C  610e                              cmp     #0, r14
FFF2C27E  1f                                bne.s   loc_FFF2C285
FFF2C27F  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF2C282  38f302                            bra.w   loc_FFF2C575
FFF2C285  ab09                   loc_FFF2C285 mov.l   38h+var_4[sp], r1
FFF2C287  711218                            add     #18h, r1, r2
FFF2C28A  a392                              mov.l   r2, 38h[r1]
FFF2C28C  ab09                              mov.l   38h+var_4[sp], r1
FFF2C28E  ab92                              mov.l   38h[r1], r2
FFF2C290  ec1e                              mov.l   [r1], r14
FFF2C292  c1e211                            mov.b   11h[r14], [r2]
FFF2C295  ab09                              mov.l   38h+var_4[sp], r1
FFF2C297  ec1e                              mov.l   [r1], r14
FFF2C299  c5e11142                          mov.b   11h[r14], 42h[r1]
FFF2C29D  ab09                              mov.l   38h+var_4[sp], r1
FFF2C29F  ab91                              mov.l   38h[r1], r1
FFF2C2A1  6211                              add     #1, r1
FFF2C2A3  fb2248aef4ff                      mov.l   #asc_FFF4AE48, r2; ":"
FFF2C2A9  05bd2300                          bsr.a   sub_FFF2E666
FFF2C2AD  ab09                              mov.l   38h+var_4[sp], r1
FFF2C2AF  711143                            add     #43h, r1, r1 ; 'C'
FFF2C2B2  fb2248aef4ff                      mov.l   #asc_FFF4AE48, r2; ":"
FFF2C2B8  05ae2300                          bsr.a   sub_FFF2E666
FFF2C2BC  ab09                              mov.l   38h+var_4[sp], r1
FFF2C2BE  ec1e                              mov.l   [r1], r14
FFF2C2C0  e0e1                              mov.l   [r14], [r1]
FFF2C2C2  ab09                              mov.l   38h+var_4[sp], r1
FFF2C2C4  711138                            add     #38h, r1, r1 ; '8'
FFF2C2C7  a009                              mov.l   r1, 38h+var_34[sp]
FFF2C2C9  38ac02                            bra.w   loc_FFF2C575
FFF2C2CC  aa01                   loc_FFF2C2CC mov.l   38h+var_18[sp], r1
FFF2C2CE  581e                              movu.b  [r1], r14
FFF2C2D0  755e2e                            cmp     #2Eh, r14 ; '.'
FFF2C2D3  11                                beq.s   loc_FFF2C2DC
FFF2C2D4  aa01                              mov.l   38h+var_18[sp], r1
FFF2C2D6  581e                              movu.b  [r1], r14
FFF2C2D8  755ee5                            cmp     #-1Bh, r14
FFF2C2DB  1d                                bne.s   loc_FFF2C2E0
FFF2C2DC  f80601                 loc_FFF2C2DC mov.l   #1, 38h+var_38[sp]
FFF2C2DF  0c                                bra.s   loc_FFF2C2E3
FFF2C2E0  f80600                 loc_FFF2C2E0 mov.l   #0, 38h+var_38[sp]
FFF2C2E3  ec01                   loc_FFF2C2E3 mov.l   38h+var_38[sp], r1
FFF2C2E5  6101                              cmp     #0, r1
FFF2C2E7  12                                beq.s   loc_FFF2C2F1
FFF2C2E8  3c8a00                            mov.b   #0, 38h+var_1E[sp]
FFF2C2EB  3c8b00                            mov.b   #0, 38h+var_1D[sp]
FFF2C2EE  384101                            bra.w   loc_FFF2C42F
FFF2C2F1  aa01                   loc_FFF2C2F1 mov.l   38h+var_18[sp], r1
FFF2C2F3  8a99                              mov.b   0Bh[r1], r1
FFF2C2F5  61f1                              cmp     #0Fh, r1
FFF2C2F7  3b4801                            bne.w   loc_FFF2C43F
FFF2C2FA  b681                              movu.b  38h+var_1E[sp], r1
FFF2C2FC  6101                              cmp     #0, r1
FFF2C2FE  201d                              beq.b   loc_FFF2C31B
FFF2C300  754ebf                            mov.l   #-41h, r14
FFF2C303  aa01                              mov.l   38h+var_18[sp], r1
FFF2C305  501e                              and     [r1], r14
FFF2C307  b681                              movu.b  38h+var_1E[sp], r1
FFF2C309  6011                              sub     #1, r1
FFF2C30B  471e                              cmp     r1, r14
FFF2C30D  10                                beq.s   loc_FFF2C315
FFF2C30E  3c8a00                            mov.b   #0, 38h+var_1E[sp]
FFF2C311  3c8b00                            mov.b   #0, 38h+var_1D[sp]
FFF2C314  0f                                bra.s   loc_FFF2C31B
FFF2C315  b681                   loc_FFF2C315 movu.b  38h+var_1E[sp], r1
FFF2C317  6011                              sub     #1, r1
FFF2C319  8681                              mov.b   r1, 38h+var_1E[sp]
FFF2C31B  8e89                   loc_FFF2C31B mov.b   38h+var_1D[sp], r1
FFF2C31D  755114                            cmp     #14h, r1
FFF2C320  2908                              blt.b   loc_FFF2C328
FFF2C322  3c8a00                            mov.b   #0, 38h+var_1E[sp]
FFF2C325  3c8b00                            mov.b   #0, 38h+var_1D[sp]
FFF2C328  8e89                   loc_FFF2C328 mov.b   38h+var_1D[sp], r1
FFF2C32A  6101                              cmp     #0, r1
FFF2C32C  15                                beq.s   loc_FFF2C331
FFF2C32D  f80600                            mov.l   #0, 38h+var_38[sp]
FFF2C330  0c                                bra.s   loc_FFF2C334
FFF2C331  f80601                 loc_FFF2C331 mov.l   #1, 38h+var_38[sp]
FFF2C334  ec01                   loc_FFF2C334 mov.l   38h+var_38[sp], r1
FFF2C336  6101                              cmp     #0, r1
FFF2C338  3aa700                            beq.w   loc_FFF2C3DF
FFF2C33B  aa01                              mov.l   38h+var_18[sp], r1
FFF2C33D  f416                              btst    #6, [r1].b
FFF2C33F  3af000                            beq.w   loc_FFF2C42F
FFF2C342  7541bf                            mov.l   #-41h, r1
FFF2C345  aa02                              mov.l   38h+var_18[sp], r2
FFF2C347  5021                              and     [r2], r1
FFF2C349  8681                              mov.b   r1, 38h+var_1E[sp]
FFF2C34B  ab09                              mov.l   38h+var_4[sp], r1
FFF2C34D  a891                              mov.l   8[r1], r1
FFF2C34F  a90a                              mov.l   38h+var_24[sp], r2
FFF2C351  0685210d                          cmp     34h[r2].l, r1
FFF2C355  210e                              bne.b   loc_FFF2C363
FFF2C357  a909                              mov.l   38h+var_24[sp], r1
FFF2C359  8c11                              mov.b   10h[r1], r1
FFF2C35B  755120                            cmp     #20h, r1 ; ' '
FFF2C35E  15                                beq.s   loc_FFF2C363
FFF2C35F  f80601                            mov.l   #1, 38h+var_38[sp]
FFF2C362  0c                                bra.s   loc_FFF2C366
FFF2C363  f80600                 loc_FFF2C363 mov.l   #0, 38h+var_38[sp]
FFF2C366  ec01                   loc_FFF2C366 mov.l   38h+var_38[sp], r1
FFF2C368  6101                              cmp     #0, r1
FFF2C36A  2034                              beq.b   loc_FFF2C39E
FFF2C36C  a909                              mov.l   38h+var_24[sp], r1
FFF2C36E  a89a                              mov.l   0Ch[r1], r2
FFF2C370  06cd1204                          mul     8[r1].uw, r2
FFF2C374  06c91203                          add     6[r1].uw, r2
FFF2C378  a102                              mov.l   r2, 38h+var_28[sp]
FFF2C37A  ab09                              mov.l   38h+var_4[sp], r1
FFF2C37C  a919                              mov.l   14h[r1], r1
FFF2C37E  06810104                          sub     38h+var_28[sp].l, r1

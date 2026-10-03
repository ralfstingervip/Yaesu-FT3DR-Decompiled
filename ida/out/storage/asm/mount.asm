; ==== mount  FFF36300-FFF36C00  (file 336300-336C00) ====
FFF36300  2cfb                              bo.b    loc_FFF362F7+4
FFF36302  e2607fed                          mov.l   3B5FCh[r6], 8+var_8[sp]
FFF36306  ff                                .byte 0FFh
FFF36307  ef21                              mov.l   r2, r1
FFF36309  efe2                              mov.l   r14, r2
FFF3630B  056d81ff                          bsr.a   sub_FFF2E478
FFF3630F  6702                              rtsd    #2
FFF36311  fbe2607fedff           loc_FFF36311 mov.l   #unk_FFED7F60, r14
FFF36317  71ee2c                            add     #2Ch, r14, r14 ; ','
FFF3631A  75432c                            mov.l   #2Ch, r3 ; ','
FFF3631D  ef21                              mov.l   r2, r1
FFF3631F  efe2                   sub_FFF3631F mov.l   r14, r2   ; <<<< FUNC sub_FFF3631F
FFF36321  055781ff                          bsr.a   sub_FFF2E478
FFF36325  6702                              rtsd    #2
FFF36327  60c0                   sub_FFF36327 sub     #0Ch, sp   ; <<<< FUNC sub_FFF36327
FFF36329  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF3632B  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF3632D  a881                              mov.l   0Ch+var_4[sp], r1
FFF3632F  6891                              shlr    #9, r1
FFF36331  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF36333  ec01                              mov.l   0Ch+var_C[sp], r1
FFF36335  7601ff0f                          cmp     #0FFFh, r1
FFF36339  2413                              bgtu.b  loc_FFF3634C
FFF3633B  a809                              mov.l   0Ch+var_8[sp], r1
FFF3633D  75432c                            mov.l   #2Ch, r3 ; ','
FFF36340  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF36346  053281ff                          bsr.a   sub_FFF2E478
FFF3634A  6703                              rtsd    #3
FFF3634C  ec01                   loc_FFF3634C mov.l   0Ch+var_C[sp], r1
FFF3634E  7601ff3f                          cmp     #3FFFh, r1
FFF36352  2416                              bgtu.b  loc_FFF36368
FFF36354  a809                              mov.l   0Ch+var_8[sp], r1
FFF36356  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF3635C  71222c                            add     #2Ch, r2, r2 ; ','
FFF3635F  75432c                            mov.l   #2Ch, r3 ; ','
FFF36362  051681ff                          bsr.a   sub_FFF2E478
FFF36366  6703                              rtsd    #3
FFF36368  ec01                   loc_FFF36368 mov.l   0Ch+var_C[sp], r1
FFF3636A  7601ff7f                          cmp     #7FFFh, r1
FFF3636E  2416                              bgtu.b  loc_FFF36384
FFF36370  a809                              mov.l   0Ch+var_8[sp], r1
FFF36372  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF36378  712258                            add     #58h, r2, r2 ; 'X'
FFF3637B  75432c                            mov.l   #2Ch, r3 ; ','
FFF3637E  05fa80ff                          bsr.a   sub_FFF2E478
FFF36382  6703                              rtsd    #3
FFF36384  ec01                   loc_FFF36384 mov.l   0Ch+var_C[sp], r1
FFF36386  7701ffff00                        cmp     #0FFFFh, r1
FFF3638B  2417                              bgtu.b  loc_FFF363A2
FFF3638D  a809                              mov.l   0Ch+var_8[sp], r1
FFF3638F  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF36395  72228400                          add     #84h, r2, r2
FFF36399  75432c                            mov.l   #2Ch, r3 ; ','
FFF3639C  05dc80ff                          bsr.a   sub_FFF2E478
FFF363A0  6703                              rtsd    #3
FFF363A2  ec01                   loc_FFF363A2 mov.l   0Ch+var_C[sp], r1
FFF363A4  7701ffff01                        cmp     #1FFFFh, r1
FFF363A9  2417                              bgtu.b  loc_FFF363C0
FFF363AB  a809                              mov.l   0Ch+var_8[sp], r1
FFF363AD  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF363B3  7222b000                          add     #0B0h, r2, r2
FFF363B7  75432c                            mov.l   #2Ch, r3 ; ','
FFF363BA  05be80ff                          bsr.a   sub_FFF2E478
FFF363BE  6703                              rtsd    #3
FFF363C0  ec01                   loc_FFF363C0 mov.l   0Ch+var_C[sp], r1
FFF363C2  7701ffff03                        cmp     #3FFFFh, r1
FFF363C7  2417                              bgtu.b  loc_FFF363DE
FFF363C9  a809                              mov.l   0Ch+var_8[sp], r1
FFF363CB  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF363D1  7222dc00                          add     #0DCh, r2, r2
FFF363D5  75432c                            mov.l   #2Ch, r3 ; ','
FFF363D8  05a080ff                          bsr.a   sub_FFF2E478
FFF363DC  6703                              rtsd    #3
FFF363DE  ec01                   loc_FFF363DE mov.l   0Ch+var_C[sp], r1
FFF363E0  7701ffff07                        cmp     #7FFFFh, r1
FFF363E5  2417                              bgtu.b  loc_FFF363FC
FFF363E7  a809                              mov.l   0Ch+var_8[sp], r1
FFF363E9  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF363EF  72220801                          add     #108h, r2, r2
FFF363F3  75432c                            mov.l   #2Ch, r3 ; ','
FFF363F6  058280ff                          bsr.a   sub_FFF2E478
FFF363FA  6703                              rtsd    #3
FFF363FC  ec01                   loc_FFF363FC mov.l   0Ch+var_C[sp], r1
FFF363FE  7701ffbf0f                        cmp     #0FBFFFh, r1
FFF36403  2417                              bgtu.b  loc_FFF3641A
FFF36405  a809                              mov.l   0Ch+var_8[sp], r1
FFF36407  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF3640D  72223401                          add     #134h, r2, r2
FFF36411  75432c                            mov.l   #2Ch, r3 ; ','
FFF36414  056480ff                          bsr.a   sub_FFF2E478
FFF36418  6703                              rtsd    #3
FFF3641A  ec01                   loc_FFF3641A mov.l   0Ch+var_C[sp], r1
FFF3641C  7701ff7f1f                        cmp     #1F7FFFh, r1
FFF36421  2417                              bgtu.b  loc_FFF36438
FFF36423  a809                              mov.l   0Ch+var_8[sp], r1
FFF36425  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF3642B  72226001                          add     #160h, r2, r2
FFF3642F  75432c                            mov.l   #2Ch, r3 ; ','
FFF36432  054680ff                          bsr.a   sub_FFF2E478
FFF36436  6703                              rtsd    #3
FFF36438  ec01                   loc_FFF36438 mov.l   0Ch+var_C[sp], r1
FFF3643A  7701ffff3e                        cmp     #3EFFFFh, r1
FFF3643F  a809                              mov.l   0Ch+var_8[sp], r1
FFF36441  2415                              bgtu.b  loc_FFF36456
FFF36443  fb22b87fedff                      mov.l   #unk_FFED7FB8, r2
FFF36449  72228c01                          add     #18Ch, r2, r2
FFF3644D  75432c                            mov.l   #2Ch, r3 ; ','
FFF36450  052880ff                          bsr.a   sub_FFF2E478
FFF36454  6703                              rtsd    #3
FFF36456  fb22b87fedff           loc_FFF36456 mov.l   #unk_FFED7FB8, r2
FFF3645C  7222b801                          add     #1B8h, r2, r2
FFF36460  75432c                            mov.l   #2Ch, r3 ; ','
FFF36463  051580ff                          bsr.a   sub_FFF2E478
FFF36467  6703                              rtsd    #3
FFF36469  7100c8                 sub_FFF36469 add     #-38h, sp, sp   ; <<<< FUNC sub_FFF36469
FFF3646C  a309                              mov.l   r1, 38h+var_4[sp]
FFF3646E  3e0b00                            mov.l   #0, 38h+var_C[sp]
FFF36471  f9042b00                          mov.b   #0, 38h+var_D[sp]
FFF36475  3e0900                            mov.l   #0, 38h+var_14[sp]
FFF36478  3e0800                            mov.l   #0, 38h+var_18[sp]
FFF3647B  3e0700                            mov.l   #0, 38h+var_1C[sp]
FFF3647E  3e0600                            mov.l   #0, 38h+var_20[sp]
FFF36481  3e0500                            mov.l   #0, 38h+var_24[sp]
FFF36484  ab09                              mov.l   38h+var_4[sp], r1
FFF36486  ec11                              mov.l   [r1], r1
FFF36488  72110102                          add     #201h, r1, r1
FFF3648C  a089                              mov.l   r1, 38h+var_2C[sp]
FFF3648E  ab09                              mov.l   38h+var_4[sp], r1
FFF36490  ec11                              mov.l   [r1], r1
FFF36492  7211c802                          add     #2C8h, r1, r1
FFF36496  a081                              mov.l   r1, 38h+var_30[sp]
FFF36498  a889                              mov.l   38h+var_2C[sp], r1
FFF3649A  5811                              movu.b  [r1], r1
FFF3649C  6861                              shlr    #6, r1
FFF3649E  c7012b                            mov.b   r1, 38h+var_D[sp]
FFF364A1  59012b                            movu.b  38h+var_D[sp], r1
FFF364A4  6111                              cmp     #1, r1
FFF364A6  3b0d02                            bne.w   loc_FFF366B3
FFF364A9  a889                              mov.l   38h+var_2C[sp], r1
FFF364AB  b199                              movu.b  7[r1], r1
FFF364AD  75213f                            and     #3Fh, r1 ; '?'
FFF364B0  a209                              mov.l   r1, 38h+var_14[sp]
FFF364B2  aa09                              mov.l   38h+var_14[sp], r1
FFF364B4  6c81                              shll    #8, r1
FFF364B6  a88a                              mov.l   38h+var_2C[sp], r2
FFF364B8  552108                            or      8[r2], r1
FFF364BB  a209                              mov.l   r1, 38h+var_14[sp]
FFF364BD  aa09                              mov.l   38h+var_14[sp], r1
FFF364BF  6c81                              shll    #8, r1
FFF364C1  a88a                              mov.l   38h+var_2C[sp], r2
FFF364C3  552109                            or      9[r2], r1
FFF364C6  a209                              mov.l   r1, 38h+var_14[sp]
FFF364C8  aa09                              mov.l   38h+var_14[sp], r1
FFF364CA  6211                              add     #1, r1
FFF364CC  6ca1                              shll    #0Ah, r1
FFF364CE  a109                              mov.l   r1, 38h+var_24[sp]
FFF364D0  a882                              mov.l   38h+var_30[sp], r2
FFF364D2  a909                              mov.l   38h+var_24[sp], r1
FFF364D4  391bfe                            bsr.w   sub_FFF362EF
FFF364D7  a909                              mov.l   38h+var_24[sp], r1
FFF364D9  740100000004                      cmp     #4000000h, r1
FFF364DF  2309                              bltu.b  loc_FFF364E8
FFF364E1  f90601fb                          mov.l   #-5, 38h+var_34[sp]
FFF364E5  381404                            bra.w   loc_FFF368F9
FFF364E8  a909                   loc_FFF364E8 mov.l   38h+var_24[sp], r1
FFF364EA  a882                              mov.l   38h+var_30[sp], r2
FFF364EC  a0a9                              mov.l   r1, 0Ch[r2]
FFF364EE  a881                              mov.l   38h+var_30[sp], r1
FFF364F0  8d11                              mov.b   14h[r1], r1
FFF364F2  755140                            cmp     #40h, r1 ; '@'
FFF364F5  3ab101                            beq.w   loc_FFF366A6
FFF364F8  a881                              mov.l   38h+var_30[sp], r1
FFF364FA  a89a                              mov.l   0Ch[r1], r2
FFF364FC  06e1091208                        divu    10h[r1].uw, r2
FFF36501  060d1214                          mul     14h[r1].b, r2
FFF36505  ba1b                              movu.w  12h[r1], r3
FFF36507  6c33                              shll    #3, r3
FFF36509  fc2732                            divu    r3, r2
FFF3650C  a192                              mov.l   r2, 18h[r1]
FFF3650E  a881                              mov.l   38h+var_30[sp], r1
FFF36510  a89a                              mov.l   0Ch[r1], r2
FFF36512  06e1091208                        divu    10h[r1].uw, r2
FFF36517  060d1214                          mul     14h[r1].b, r2
FFF3651B  ba1b                              movu.w  12h[r1], r3
FFF3651D  6c33                              shll    #3, r3
FFF3651F  ef2e                              mov.l   r2, r14
FFF36521  fc273e                            divu    r3, r14
FFF36524  4f3e                              mul     r3, r14
FFF36526  43e2                              sub     r14, r2
FFF36528  6102                              cmp     #0, r2
FFF3652A  15                                beq.s   loc_FFF3652F
FFF3652B  f80601                            mov.l   #1, 38h+var_38[sp]
FFF3652E  0c                                bra.s   loc_FFF36532
FFF3652F  f80600                 loc_FFF3652F mov.l   #0, 38h+var_38[sp]
FFF36532  a992                   loc_FFF36532 mov.l   18h[r1], r2
FFF36534  068802                            add     [sp].l, r2
FFF36537  a192                              mov.l   r2, 18h[r1]
FFF36539  3e0401                            mov.l   #1, 38h+var_28[sp]
FFF3653C  0f                                bra.s   loc_FFF36543
FFF3653D  a901                   loc_FFF3653D mov.l   38h+var_28[sp], r1
FFF3653F  6211                              add     #1, r1
FFF36541  a101                              mov.l   r1, 38h+var_28[sp]
FFF36543  a881                   loc_FFF36543 mov.l   38h+var_30[sp], r1
FFF36545  a81a                              mov.l   4[r1], r2
FFF36547  068d0204                          mul     38h+var_28[sp].l, r2
FFF3654B  a991                              mov.l   18h[r1], r1
FFF3654D  6c11                              shll    #1, r1
FFF3654F  4712                              cmp     r1, r2
FFF36551  25ec                              bleu.b  loc_FFF3653D
FFF36553  a881                              mov.l   38h+var_30[sp], r1
FFF36555  a81a                              mov.l   4[r1], r2
FFF36557  068d0204                          mul     38h+var_28[sp].l, r2
FFF3655B  a993                              mov.l   18h[r1], r3
FFF3655D  6c13                              shll    #1, r3
FFF3655F  4332                              sub     r3, r2
FFF36561  9392                              mov.w   r2, 1Ch[r1]
FFF36563  a881                              mov.l   38h+var_30[sp], r1
FFF36565  bb91                              movu.w  1Ch[r1], r1
FFF36567  6181                              cmp     #8, r1
FFF36569  2a0c                              bgt.b   loc_FFF36575
FFF3656B  a881                              mov.l   38h+var_30[sp], r1
FFF3656D  bb92                              movu.w  1Ch[r1], r2
FFF3656F  06c91202                          add     4[r1].uw, r2
FFF36573  9392                              mov.w   r2, 1Ch[r1]
FFF36575  a881                   loc_FFF36575 mov.l   38h+var_30[sp], r1
FFF36577  a992                              mov.l   18h[r1], r2
FFF36579  6c12                              shll    #1, r2
FFF3657B  06c9120e                          add     1Ch[r1].uw, r2
FFF3657F  a212                              mov.l   r2, 20h[r1]
FFF36581  a881                              mov.l   38h+var_30[sp], r1
FFF36583  a89a                              mov.l   0Ch[r1], r2
FFF36585  06811202                          sub     8[r1].l, r2
FFF36589  06811208                          sub     20h[r1].l, r2
FFF3658D  06e1091208                        divu    10h[r1].uw, r2
FFF36592  6212                              add     #1, r2
FFF36594  a21a                              mov.l   r2, 24h[r1]
FFF36596  a881                              mov.l   38h+var_30[sp], r1
FFF36598  aa1a                              mov.l   24h[r1], r2
FFF3659A  6212                              add     #1, r2
FFF3659C  060d1214                          mul     14h[r1].b, r2
FFF365A0  ba1b                              movu.w  12h[r1], r3
FFF365A2  6c33                              shll    #3, r3
FFF365A4  fc2732                            divu    r3, r2
FFF365A7  a292                              mov.l   r2, 28h[r1]
FFF365A9  a881                              mov.l   38h+var_30[sp], r1
FFF365AB  aa1a                              mov.l   24h[r1], r2
FFF365AD  6212                              add     #1, r2
FFF365AF  060d1214                          mul     14h[r1].b, r2
FFF365B3  ba1b                              movu.w  12h[r1], r3
FFF365B5  6c33                              shll    #3, r3
FFF365B7  ef2e                              mov.l   r2, r14
FFF365B9  fc273e                            divu    r3, r14
FFF365BC  4f3e                              mul     r3, r14
FFF365BE  43e2                              sub     r14, r2
FFF365C0  6102                              cmp     #0, r2
FFF365C2  15                                beq.s   loc_FFF365C7
FFF365C3  f80601                            mov.l   #1, 38h+var_38[sp]
FFF365C6  0c                                bra.s   loc_FFF365CA
FFF365C7  f80600                 loc_FFF365C7 mov.l   #0, 38h+var_38[sp]
FFF365CA  aa92                   loc_FFF365CA mov.l   28h[r1], r2
FFF365CC  068802                            add     [sp].l, r2
FFF365CF  a292                              mov.l   r2, 28h[r1]
FFF365D1  38bf00                            bra.w   loc_FFF36690
FFF365D4  0685210a               loc_FFF365D4 cmp     28h[r2].l, r1
FFF365D8  a882                              mov.l   38h+var_30[sp], r2
FFF365DA  2218                              bgeu.b  loc_FFF365F2
FFF365DC  aa21                              mov.l   20h[r2], r1
FFF365DE  a883                              mov.l   38h+var_30[sp], r3
FFF365E0  06893101                          add     4[r3].l, r1
FFF365E4  a221                              mov.l   r1, 20h[r2]
FFF365E6  a882                              mov.l   38h+var_30[sp], r2
FFF365E8  bba1                              movu.w  1Ch[r2], r1
FFF365EA  06c92102                          add     4[r2].uw, r1
FFF365EE  93a1                              mov.w   r1, 1Ch[r2]
FFF365F0  2e50                              bra.b   loc_FFF36640
FFF365F2  a9a1                   loc_FFF365F2 mov.l   18h[r2], r1
FFF365F4  6011                              sub     #1, r1
FFF365F6  a1a1                              mov.l   r1, 18h[r2]
FFF365F8  3e0401                            mov.l   #1, 38h+var_28[sp]
FFF365FB  0f                                bra.s   loc_FFF36602
FFF365FC  a902                   loc_FFF365FC mov.l   38h+var_28[sp], r2
FFF365FE  6212                              add     #1, r2
FFF36600  a102                              mov.l   r2, 38h+var_28[sp]
FFF36602  a882                   loc_FFF36602 mov.l   38h+var_30[sp], r2
FFF36604  a829                              mov.l   4[r2], r1
FFF36606  068d0104                          mul     38h+var_28[sp].l, r1
FFF3660A  a9a2                              mov.l   18h[r2], r2
FFF3660C  6c12                              shll    #1, r2
FFF3660E  4721                              cmp     r2, r1
FFF36610  25ec                              bleu.b  loc_FFF365FC
FFF36612  a882                              mov.l   38h+var_30[sp], r2
FFF36614  a829                              mov.l   4[r2], r1
FFF36616  068d0104                          mul     38h+var_28[sp].l, r1
FFF3661A  a9a3                              mov.l   18h[r2], r3
FFF3661C  6c13                              shll    #1, r3
FFF3661E  4331                              sub     r3, r1
FFF36620  93a1                              mov.w   r1, 1Ch[r2]
FFF36622  a882                              mov.l   38h+var_30[sp], r2
FFF36624  bba2                              movu.w  1Ch[r2], r2
FFF36626  6182                              cmp     #8, r2
FFF36628  2a0c                              bgt.b   loc_FFF36634
FFF3662A  a882                              mov.l   38h+var_30[sp], r2
FFF3662C  bba1                              movu.w  1Ch[r2], r1
FFF3662E  06c92102                          add     4[r2].uw, r1
FFF36632  93a1                              mov.w   r1, 1Ch[r2]
FFF36634  a882                   loc_FFF36634 mov.l   38h+var_30[sp], r2
FFF36636  a9a1                              mov.l   18h[r2], r1
FFF36638  6c11                              shll    #1, r1
FFF3663A  06c9210e                          add     1Ch[r2].uw, r1
FFF3663E  a221                              mov.l   r1, 20h[r2]
FFF36640  a882                   loc_FFF36640 mov.l   38h+var_30[sp], r2
FFF36642  a8a9                              mov.l   0Ch[r2], r1
FFF36644  06812102                          sub     8[r2].l, r1
FFF36648  06812108                          sub     20h[r2].l, r1
FFF3664C  06e1092108                        divu    10h[r2].uw, r1
FFF36651  6211                              add     #1, r1
FFF36653  a229                              mov.l   r1, 24h[r2]
FFF36655  a882                              mov.l   38h+var_30[sp], r2
FFF36657  aa29                              mov.l   24h[r2], r1
FFF36659  6211                              add     #1, r1
FFF3665B  060d2114                          mul     14h[r2].b, r1
FFF3665F  ba2b                              movu.w  12h[r2], r3
FFF36661  6c33                              shll    #3, r3
FFF36663  fc2731                            divu    r3, r1
FFF36666  a2a1                              mov.l   r1, 28h[r2]
FFF36668  a882                              mov.l   38h+var_30[sp], r2
FFF3666A  aa29                              mov.l   24h[r2], r1
FFF3666C  6211                              add     #1, r1
FFF3666E  060d2114                          mul     14h[r2].b, r1
FFF36672  ba2b                              movu.w  12h[r2], r3
FFF36674  6c33                              shll    #3, r3
FFF36676  ef1e                              mov.l   r1, r14
FFF36678  fc273e                            divu    r3, r14
FFF3667B  4f3e                              mul     r3, r14
FFF3667D  43e1                              sub     r14, r1
FFF3667F  6101                              cmp     #0, r1
FFF36681  15                                beq.s   loc_FFF36686
FFF36682  f80601                            mov.l   #1, 38h+var_38[sp]
FFF36685  0c                                bra.s   loc_FFF36689
FFF36686  f80600                 loc_FFF36686 mov.l   #0, 38h+var_38[sp]
FFF36689  aaa1                   loc_FFF36689 mov.l   28h[r2], r1
FFF3668B  068801                            add     [sp].l, r1
FFF3668E  a2a1                              mov.l   r1, 28h[r2]
FFF36690  a882                   loc_FFF36690 mov.l   38h+var_30[sp], r2
FFF36692  a9a1                              mov.l   18h[r2], r1
FFF36694  0685210a                          cmp     28h[r2].l, r1
FFF36698  3b3cff                            bne.w   loc_FFF365D4
FFF3669B  06c92108                          add     10h[r2].uw, r1
FFF3669F  ab0a                              mov.l   38h+var_4[sp], r2
FFF366A1  ec22                              mov.l   [r2], r2
FFF366A3  3995f2                            bsr.w   sub_FFF35938
FFF366A6  a881                   loc_FFF366A6 mov.l   38h+var_30[sp], r1
FFF366A8  a89a                              mov.l   0Ch[r1], r2
FFF366AA  06811201                          sub     4[r1].l, r2
FFF366AE  a09a                              mov.l   r2, 0Ch[r1]
FFF366B0  384502                            bra.w   loc_FFF368F5
FFF366B3  59012b                 loc_FFF366B3 movu.b  38h+var_D[sp], r1
FFF366B6  6101                              cmp     #0, r1
FFF366B8  3b3902                            bne.w   loc_FFF368F1
FFF366BB  a889                              mov.l   38h+var_2C[sp], r1
FFF366BD  395bfb                            bsr.w   sub_FFF36218
FFF366C0  a189                              mov.l   r1, 38h+var_1C[sp]
FFF366C2  a889                              mov.l   38h+var_2C[sp], r1
FFF366C4  3983fb                            bsr.w   sub_FFF36247
FFF366C7  a209                              mov.l   r1, 38h+var_14[sp]
FFF366C9  a889                              mov.l   38h+var_2C[sp], r1
FFF366CB  39b0fb                            bsr.w   sub_FFF3627B
FFF366CE  a181                              mov.l   r1, 38h+var_20[sp]
FFF366D0  aa09                              mov.l   38h+var_14[sp], r1
FFF366D2  6211                              add     #1, r1
FFF366D4  068d0106                          mul     38h+var_20[sp].l, r1
FFF366D8  a201                              mov.l   r1, 38h+var_18[sp]
FFF366DA  aa01                              mov.l   38h+var_18[sp], r1
FFF366DC  068d0107                          mul     38h+var_1C[sp].l, r1
FFF366E0  a109                              mov.l   r1, 38h+var_24[sp]
FFF366E2  a882                              mov.l   38h+var_30[sp], r2
FFF366E4  a909                              mov.l   38h+var_24[sp], r1
FFF366E6  3941fc                            bsr.w   sub_FFF36327
FFF366E9  a909                              mov.l   38h+var_24[sp], r1
FFF366EB  6891                              shlr    #9, r1
FFF366ED  a882                              mov.l   38h+var_30[sp], r2
FFF366EF  a0a9                              mov.l   r1, 0Ch[r2]
FFF366F1  a881                              mov.l   38h+var_30[sp], r1
FFF366F3  a89a                              mov.l   0Ch[r1], r2
FFF366F5  06e1091208                        divu    10h[r1].uw, r2
FFF366FA  060d1214                          mul     14h[r1].b, r2
FFF366FE  ba1b                              movu.w  12h[r1], r3
FFF36700  6c33                              shll    #3, r3
FFF36702  fc2732                            divu    r3, r2
FFF36705  5f22                              movu.w  r2, r2
FFF36707  a192                              mov.l   r2, 18h[r1]
FFF36709  a881                              mov.l   38h+var_30[sp], r1
FFF3670B  a89a                              mov.l   0Ch[r1], r2
FFF3670D  06e1091208                        divu    10h[r1].uw, r2
FFF36712  060d1214                          mul     14h[r1].b, r2
FFF36716  ba1b                              movu.w  12h[r1], r3
FFF36718  6c33                              shll    #3, r3
FFF3671A  ef2e                              mov.l   r2, r14
FFF3671C  fc273e                            divu    r3, r14
FFF3671F  4f3e                              mul     r3, r14
FFF36721  43e2                              sub     r14, r2
FFF36723  6102                              cmp     #0, r2
FFF36725  15                                beq.s   loc_FFF3672A
FFF36726  f80601                            mov.l   #1, 38h+var_38[sp]
FFF36729  0c                                bra.s   loc_FFF3672D
FFF3672A  f80600                 loc_FFF3672A mov.l   #0, 38h+var_38[sp]
FFF3672D  a992                   loc_FFF3672D mov.l   18h[r1], r2
FFF3672F  068802                            add     [sp].l, r2
FFF36732  a192                              mov.l   r2, 18h[r1]
FFF36734  a881                              mov.l   38h+var_30[sp], r1
FFF36736  a992                              mov.l   18h[r1], r2
FFF36738  6c12                              shll    #1, r2
FFF3673A  06c9120e                          add     1Ch[r1].uw, r2
FFF3673E  712220                            add     #20h, r2, r2 ; ' '
FFF36741  a212                              mov.l   r2, 20h[r1]
FFF36743  a881                              mov.l   38h+var_30[sp], r1
FFF36745  a81a                              mov.l   4[r1], r2
FFF36747  06851208                          cmp     20h[r1].l, r2
FFF3674B  223b                              bgeu.b  loc_FFF36786
FFF3674D  aa11                              mov.l   20h[r1], r1
FFF3674F  a882                              mov.l   38h+var_30[sp], r2
FFF36751  06a1092101                        divu    4[r2].l, r1
FFF36756  a101                              mov.l   r1, 38h+var_28[sp]
FFF36758  a881                              mov.l   38h+var_30[sp], r1
FFF3675A  aa12                              mov.l   20h[r1], r2
FFF3675C  a819                              mov.l   4[r1], r1
FFF3675E  ef2e                              mov.l   r2, r14
FFF36760  fc271e                            divu    r1, r14
FFF36763  4f1e                              mul     r1, r14
FFF36765  43e2                              sub     r14, r2
FFF36767  6102                              cmp     #0, r2
FFF36769  15                                beq.s   loc_FFF3676E
FFF3676A  f80601                            mov.l   #1, 38h+var_38[sp]
FFF3676D  0c                                bra.s   loc_FFF36771
FFF3676E  f80600                 loc_FFF3676E mov.l   #0, 38h+var_38[sp]
FFF36771  a901                   loc_FFF36771 mov.l   38h+var_28[sp], r1
FFF36773  068801                            add     [sp].l, r1
FFF36776  a101                              mov.l   r1, 38h+var_28[sp]
FFF36778  a882                              mov.l   38h+var_30[sp], r2
FFF3677A  068d2101                          mul     4[r2].l, r1
FFF3677E  06812108                          sub     20h[r2].l, r1
FFF36782  a0a1                              mov.l   r1, 8[r2]
FFF36784  2e0c                              bra.b   loc_FFF36790
FFF36786  a882                   loc_FFF36786 mov.l   38h+var_30[sp], r2
FFF36788  a82b                              mov.l   4[r2], r3
FFF3678A  06812308                          sub     20h[r2].l, r3
FFF3678E  a093                              mov.l   r3, 8[r1]
FFF36790  a881                   loc_FFF36790 mov.l   38h+var_30[sp], r1
FFF36792  a892                              mov.l   8[r1], r2
FFF36794  06851201                          cmp     4[r1].l, r2
FFF36798  200c                              beq.b   loc_FFF367A4
FFF3679A  a881                              mov.l   38h+var_30[sp], r1
FFF3679C  a892                              mov.l   8[r1], r2
FFF3679E  06891201                          add     4[r1].l, r2
FFF367A2  a092                              mov.l   r2, 8[r1]
FFF367A4  a881                   loc_FFF367A4 mov.l   38h+var_30[sp], r1
FFF367A6  a89a                              mov.l   0Ch[r1], r2
FFF367A8  06811202                          sub     8[r1].l, r2
FFF367AC  06811208                          sub     20h[r1].l, r2
FFF367B0  06e1091208                        divu    10h[r1].uw, r2
FFF367B5  6212                              add     #1, r2
FFF367B7  a21a                              mov.l   r2, 24h[r1]
FFF367B9  a881                              mov.l   38h+var_30[sp], r1
FFF367BB  aa1a                              mov.l   24h[r1], r2
FFF367BD  6212                              add     #1, r2
FFF367BF  060d1214                          mul     14h[r1].b, r2
FFF367C3  ba1b                              movu.w  12h[r1], r3
FFF367C5  6c33                              shll    #3, r3
FFF367C7  fc2732                            divu    r3, r2
FFF367CA  a292                              mov.l   r2, 28h[r1]
FFF367CC  a881                              mov.l   38h+var_30[sp], r1
FFF367CE  aa1a                              mov.l   24h[r1], r2
FFF367D0  6212                              add     #1, r2
FFF367D2  060d1214                          mul     14h[r1].b, r2
FFF367D6  ba1b                              movu.w  12h[r1], r3
FFF367D8  6c33                              shll    #3, r3
FFF367DA  ef2e                              mov.l   r2, r14
FFF367DC  fc273e                            divu    r3, r14
FFF367DF  4f3e                              mul     r3, r14
FFF367E1  43e2                              sub     r14, r2
FFF367E3  6102                              cmp     #0, r2
FFF367E5  15                                beq.s   loc_FFF367EA
FFF367E6  f80601                            mov.l   #1, 38h+var_38[sp]
FFF367E9  0c                                bra.s   loc_FFF367ED
FFF367EA  f80600                 loc_FFF367EA mov.l   #0, 38h+var_38[sp]
FFF367ED  aa92                   loc_FFF367ED mov.l   28h[r1], r2
FFF367EF  068802                            add     [sp].l, r2
FFF367F2  a292                              mov.l   r2, 28h[r1]
FFF367F4  38dd00                            bra.w   loc_FFF368D1
FFF367F7  a882                   loc_FFF367F7 mov.l   38h+var_30[sp], r2
FFF367F9  0685210a                          cmp     28h[r2].l, r1
FFF367FD  220e                              bgeu.b  loc_FFF3680B
FFF367FF  a8a1                              mov.l   8[r2], r1
FFF36801  a883                              mov.l   38h+var_30[sp], r3
FFF36803  06893101                          add     4[r3].l, r1
FFF36807  a0a1                              mov.l   r1, 8[r2]
FFF36809  2e78                              bra.b   loc_FFF36881
FFF3680B  a881                   loc_FFF3680B mov.l   38h+var_30[sp], r1
FFF3680D  e5120a06                          mov.l   28h[r1], 18h[r2]
FFF36811  a881                              mov.l   38h+var_30[sp], r1
FFF36813  a992                              mov.l   18h[r1], r2
FFF36815  6c12                              shll    #1, r2
FFF36817  06c9120e                          add     1Ch[r1].uw, r2
FFF3681B  712220                            add     #20h, r2, r2 ; ' '
FFF3681E  a212                              mov.l   r2, 20h[r1]
FFF36820  a881                              mov.l   38h+var_30[sp], r1
FFF36822  a81a                              mov.l   4[r1], r2
FFF36824  06851208                          cmp     20h[r1].l, r2
FFF36828  223b                              bgeu.b  loc_FFF36863
FFF3682A  aa11                              mov.l   20h[r1], r1
FFF3682C  a882                              mov.l   38h+var_30[sp], r2
FFF3682E  06a1092101                        divu    4[r2].l, r1
FFF36833  a101                              mov.l   r1, 38h+var_28[sp]
FFF36835  a881                              mov.l   38h+var_30[sp], r1
FFF36837  aa12                              mov.l   20h[r1], r2
FFF36839  a819                              mov.l   4[r1], r1
FFF3683B  ef2e                              mov.l   r2, r14
FFF3683D  fc271e                            divu    r1, r14
FFF36840  4f1e                              mul     r1, r14
FFF36842  43e2                              sub     r14, r2
FFF36844  6102                              cmp     #0, r2
FFF36846  15                                beq.s   loc_FFF3684B
FFF36847  f80601                            mov.l   #1, 38h+var_38[sp]
FFF3684A  0c                                bra.s   loc_FFF3684E
FFF3684B  f80600                 loc_FFF3684B mov.l   #0, 38h+var_38[sp]
FFF3684E  a901                   loc_FFF3684E mov.l   38h+var_28[sp], r1
FFF36850  068801                            add     [sp].l, r1
FFF36853  a101                              mov.l   r1, 38h+var_28[sp]
FFF36855  a882                              mov.l   38h+var_30[sp], r2
FFF36857  068d2101                          mul     4[r2].l, r1
FFF3685B  06812108                          sub     20h[r2].l, r1
FFF3685F  a0a1                              mov.l   r1, 8[r2]
FFF36861  2e0c                              bra.b   loc_FFF3686D
FFF36863  a882                   loc_FFF36863 mov.l   38h+var_30[sp], r2
FFF36865  a82b                              mov.l   4[r2], r3
FFF36867  06812308                          sub     20h[r2].l, r3
FFF3686B  a093                              mov.l   r3, 8[r1]
FFF3686D  a881                   loc_FFF3686D mov.l   38h+var_30[sp], r1
FFF3686F  a892                              mov.l   8[r1], r2
FFF36871  06851201                          cmp     4[r1].l, r2
FFF36875  200c                              beq.b   loc_FFF36881
FFF36877  a881                              mov.l   38h+var_30[sp], r1
FFF36879  a892                              mov.l   8[r1], r2
FFF3687B  06891201                          add     4[r1].l, r2
FFF3687F  a092                              mov.l   r2, 8[r1]
FFF36881  a881                   loc_FFF36881 mov.l   38h+var_30[sp], r1
FFF36883  a89a                              mov.l   0Ch[r1], r2
FFF36885  06811202                          sub     8[r1].l, r2
FFF36889  06811208                          sub     20h[r1].l, r2
FFF3688D  06e1091208                        divu    10h[r1].uw, r2
FFF36892  6212                              add     #1, r2
FFF36894  a21a                              mov.l   r2, 24h[r1]
FFF36896  a881                              mov.l   38h+var_30[sp], r1
FFF36898  aa1a                              mov.l   24h[r1], r2
FFF3689A  6212                              add     #1, r2
FFF3689C  060d1214                          mul     14h[r1].b, r2
FFF368A0  ba1b                              movu.w  12h[r1], r3
FFF368A2  6c33                              shll    #3, r3
FFF368A4  fc2732                            divu    r3, r2
FFF368A7  a292                              mov.l   r2, 28h[r1]
FFF368A9  a881                              mov.l   38h+var_30[sp], r1
FFF368AB  aa1a                              mov.l   24h[r1], r2
FFF368AD  6212                              add     #1, r2
FFF368AF  060d1214                          mul     14h[r1].b, r2
FFF368B3  ba1b                              movu.w  12h[r1], r3
FFF368B5  6c33                              shll    #3, r3
FFF368B7  ef2e                              mov.l   r2, r14
FFF368B9  fc273e                            divu    r3, r14
FFF368BC  4f3e                              mul     r3, r14
FFF368BE  43e2                              sub     r14, r2
FFF368C0  6102                              cmp     #0, r2
FFF368C2  15                                beq.s   loc_FFF368C7
FFF368C3  f80601                            mov.l   #1, 38h+var_38[sp]
FFF368C6  0c                                bra.s   loc_FFF368CA
FFF368C7  f80600                 loc_FFF368C7 mov.l   #0, 38h+var_38[sp]
FFF368CA  aa92                   loc_FFF368CA mov.l   28h[r1], r2
FFF368CC  068802                            add     [sp].l, r2
FFF368CF  a292                              mov.l   r2, 28h[r1]
FFF368D1  a882                   loc_FFF368D1 mov.l   38h+var_30[sp], r2
FFF368D3  a9a1                              mov.l   18h[r2], r1
FFF368D5  0685210a                          cmp     28h[r2].l, r1
FFF368D9  3b1eff                            bne.w   loc_FFF367F7
FFF368DC  ab0a                              mov.l   38h+var_4[sp], r2
FFF368DE  ec22                              mov.l   [r2], r2
FFF368E0  711120                            add     #20h, r1, r1 ; ' '
FFF368E3  3955f0                            bsr.w   sub_FFF35938
FFF368E6  a881                              mov.l   38h+var_30[sp], r1
FFF368E8  a89a                              mov.l   0Ch[r1], r2
FFF368EA  06811202                          sub     8[r1].l, r2
FFF368EE  a09a                              mov.l   r2, 0Ch[r1]
FFF368F0  0d                                bra.s   loc_FFF368F5
FFF368F1  f9060bff               loc_FFF368F1 mov.l   #-1, 38h+var_C[sp]
FFF368F5  e5000b01               loc_FFF368F5 mov.l   38h+var_C[sp], 38h+var_34[sp]
FFF368F9  a809                   loc_FFF368F9 mov.l   38h+var_34[sp], r1
FFF368FB  a301                              mov.l   r1, 38h+var_8[sp]
FFF368FD  670e                              rtsd    #0Eh
FFF368FF  7100f0                 sub_FFF368FF add     #-10h, sp, sp   ; <<<< FUNC sub_FFF368FF
FFF36902  a089                              mov.l   r1, 10h+var_4[sp]
FFF36904  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF36907  a889                              mov.l   10h+var_4[sp], r1
FFF36909  ec11                              mov.l   [r1], r1
FFF3690B  7211c802                          add     #2C8h, r1, r1
FFF3690F  75432c                            mov.l   #2Ch, r3 ; ','
FFF36912  6602                              mov.l   #0, r2
FFF36914  ef24                              mov.l   r2, r4
FFF36916  05997bff                          bsr.a   sub_FFF2E4AF
FFF3691A  a889                              mov.l   10h+var_4[sp], r1
FFF3691C  394dfb                            bsr.w   sub_FFF36469
FFF3691F  a009                              mov.l   r1, 10h+var_C[sp]
FFF36921  a809                              mov.l   10h+var_C[sp], r1
FFF36923  6101                              cmp     #0, r1
FFF36925  16                                beq.s   loc_FFF3692B
FFF36926  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF36929  2e6a                              bra.b   loc_FFF36993
FFF3692B  a889                   loc_FFF3692B mov.l   10h+var_4[sp], r1
FFF3692D  3950f8                            bsr.w   sub_FFF3617D
FFF36930  a009                              mov.l   r1, 10h+var_C[sp]
FFF36932  a809                              mov.l   10h+var_C[sp], r1
FFF36934  6101                              cmp     #0, r1
FFF36936  16                                beq.s   loc_FFF3693C
FFF36937  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF3693A  2e59                              bra.b   loc_FFF36993
FFF3693C  a889                   loc_FFF3693C mov.l   10h+var_4[sp], r1
FFF3693E  ec1e                              mov.l   [r1], r14
FFF36940  ceeedc02                          mov.b   2DCh[r14], r14
FFF36944  755e40                            cmp     #40h, r14 ; '@'
FFF36947  2013                              beq.b   loc_FFF3695A
FFF36949  a889                              mov.l   10h+var_4[sp], r1
FFF3694B  39c0f3                            bsr.w   sub_FFF35D0B
FFF3694E  a009                              mov.l   r1, 10h+var_C[sp]
FFF36950  a809                              mov.l   10h+var_C[sp], r1
FFF36952  6101                              cmp     #0, r1
FFF36954  16                                beq.s   loc_FFF3695A
FFF36955  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF36958  2e3b                              bra.b   loc_FFF36993
FFF3695A  a889                   loc_FFF3695A mov.l   10h+var_4[sp], r1
FFF3695C  ec1e                              mov.l   [r1], r14
FFF3695E  ceeedc02                          mov.b   2DCh[r14], r14
FFF36962  755e20                            cmp     #20h, r14 ; ' '
FFF36965  2113                              bne.b   loc_FFF36978
FFF36967  a889                              mov.l   10h+var_4[sp], r1
FFF36969  3914f2                            bsr.w   sub_FFF35B7D
FFF3696C  a009                              mov.l   r1, 10h+var_C[sp]
FFF3696E  a809                              mov.l   10h+var_C[sp], r1
FFF36970  6101                              cmp     #0, r1
FFF36972  16                                beq.s   loc_FFF36978
FFF36973  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF36976  2e1d                              bra.b   loc_FFF36993
FFF36978  a889                   loc_FFF36978 mov.l   10h+var_4[sp], r1
FFF3697A  398ef0                            bsr.w   sub_FFF35A08
FFF3697D  a009                              mov.l   r1, 10h+var_C[sp]
FFF3697F  a809                              mov.l   10h+var_C[sp], r1
FFF36981  6101                              cmp     #0, r1
FFF36983  16                                beq.s   loc_FFF36989
FFF36984  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF36987  2e0c                              bra.b   loc_FFF36993
FFF36989  a889                   loc_FFF36989 mov.l   10h+var_4[sp], r1
FFF3698B  39bdef                            bsr.w   sub_FFF35948
FFF3698E  a009                              mov.l   r1, 10h+var_C[sp]
FFF36990  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF36993  ec01                   loc_FFF36993 mov.l   10h+var_10[sp], r1
FFF36995  a081                              mov.l   r1, 10h+var_8[sp]
FFF36997  6704                              rtsd    #4
FFF36999  7100e8                 sub_FFF36999 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF36999
FFF3699C  8589                              mov.b   r1, 18h+var_1[sp]
FFF3699E  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF369A4  e4e002                            mov.l   [r14], 18h+var_10[sp]
FFF369A7  0544e6fe                          bsr.a   sub_FFF24FEB
FFF369AB  a089                              mov.l   r1, 18h+var_C[sp]
FFF369AD  a889                              mov.l   18h+var_C[sp], r1
FFF369AF  6101                              cmp     #0, r1
FFF369B1  16                                beq.s   loc_FFF369B7
FFF369B2  f806f8                            mov.l   #-8, 18h+var_18[sp]
FFF369B5  2e37                              bra.b   loc_FFF369EC
FFF369B7  8d89                   loc_FFF369B7 mov.b   18h+var_1[sp], r1
FFF369B9  05d27dff                          bsr.a   sub_FFF2E78B
FFF369BD  8189                              mov.b   r1, 18h+var_11[sp]
FFF369BF  b189                              movu.b  18h+var_11[sp], r1
FFF369C1  710208                            add     #18h+var_10, sp, r2
FFF369C4  055b85fe                          bsr.a   sub_FFF1EF1F
FFF369C8  a089                              mov.l   r1, 18h+var_C[sp]
FFF369CA  a889                              mov.l   18h+var_C[sp], r1
FFF369CC  6101                              cmp     #0, r1
FFF369CE  16                                beq.s   loc_FFF369D4
FFF369CF  f806fe                            mov.l   #-2, 18h+var_18[sp]
FFF369D2  2e1a                              bra.b   loc_FFF369EC
FFF369D4  a881                   loc_FFF369D4 mov.l   18h+var_10[sp], r1
FFF369D6  aa19                              mov.l   24h[r1], r1
FFF369D8  6101                              cmp     #0, r1
FFF369DA  1e                                bne.s   loc_FFF369E0
FFF369DB  f806f8                            mov.l   #-8, 18h+var_18[sp]
FFF369DE  2e0e                              bra.b   loc_FFF369EC
FFF369E0  a881                   loc_FFF369E0 mov.l   18h+var_10[sp], r1
FFF369E2  aa19                              mov.l   24h[r1], r1
FFF369E4  390e00                            bsr.w   sub_FFF369F2
FFF369E7  a089                              mov.l   r1, 18h+var_C[sp]
FFF369E9  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF369EC  ec01                   loc_FFF369EC mov.l   18h+var_18[sp], r1
FFF369EE  a101                              mov.l   r1, 18h+var_8[sp]
FFF369F0  6706                              rtsd    #6
FFF369F2  7100e8                 sub_FFF369F2 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF369F2
FFF369F5  a109                              mov.l   r1, 18h+var_4[sp]
FFF369F7  a819                              mov.l   4[r1], r1
FFF369F9  aa19                              mov.l   24h[r1], r1
FFF369FB  7f11                              jsr     r1
FFF369FD  a081                              mov.l   r1, 18h+var_10[sp]
FFF369FF  a881                              mov.l   18h+var_10[sp], r1
FFF36A01  6101                              cmp     #0, r1
FFF36A03  10                                beq.s   loc_FFF36A0B
FFF36A04  e5000201                          mov.l   18h+var_10[sp], 18h+var_14[sp]
FFF36A08  381001                            bra.w   loc_FFF36B18
FFF36A0B  f90602ff               loc_FFF36A0B mov.l   #-1, 18h+var_10[sp]
FFF36A0F  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF36A12  38f900                            bra.w   loc_FFF36B0B
FFF36A15  a909                   loc_FFF36A15 mov.l   18h+var_4[sp], r1
FFF36A17  a819                              mov.l   4[r1], r1
FFF36A19  aa12                              mov.l   20h[r1], r2
FFF36A1B  6621                              mov.l   #2, r1
FFF36A1D  7f12                              jsr     r2
FFF36A1F  a081                              mov.l   r1, 18h+var_10[sp]
FFF36A21  a881                              mov.l   18h+var_10[sp], r1
FFF36A23  6101                              cmp     #0, r1
FFF36A25  3be000                            bne.w   loc_FFF36B05
FFF36A28  a909                              mov.l   18h+var_4[sp], r1
FFF36A2A  0583e7ff                          bsr.a   sub_FFF351AD
FFF36A2E  a081                              mov.l   r1, 18h+var_10[sp]
FFF36A30  a881                              mov.l   18h+var_10[sp], r1
FFF36A32  6101                              cmp     #0, r1
FFF36A34  3bd100                            bne.w   loc_FFF36B05
FFF36A37  a909                              mov.l   18h+var_4[sp], r1
FFF36A39  ec1e                              mov.l   [r1], r14
FFF36A3B  5eee6301                          movu.w  2C6h[r14], r14
FFF36A3F  611e                              cmp     #1, r14
FFF36A41  18                                bne.s   loc_FFF36A49
FFF36A42  f90601fb                          mov.l   #-5, 18h+var_14[sp]
FFF36A46  38d200                            bra.w   loc_FFF36B18
FFF36A49  a909                   loc_FFF36A49 mov.l   18h+var_4[sp], r1
FFF36A4B  0594e8ff                          bsr.a   sub_FFF352DF
FFF36A4F  a081                              mov.l   r1, 18h+var_10[sp]
FFF36A51  a881                              mov.l   18h+var_10[sp], r1
FFF36A53  6101                              cmp     #0, r1
FFF36A55  3bb000                            bne.w   loc_FFF36B05
FFF36A58  a90c                              mov.l   18h+var_4[sp], r4
FFF36A5A  ec4e                              mov.l   [r4], r14
FFF36A5C  5ee15501                          movu.w  2AAh[r14], r1
FFF36A60  6613                              mov.l   #1, r3
FFF36A62  fb2a0002                          mov.l   #200h, r2
FFF36A66  05e1e8ff                          bsr.a   sub_FFF35347
FFF36A6A  a081                              mov.l   r1, 18h+var_10[sp]
FFF36A6C  a881                              mov.l   18h+var_10[sp], r1
FFF36A6E  6101                              cmp     #0, r1
FFF36A70  3b9500                            bne.w   loc_FFF36B05
FFF36A73  a90a                              mov.l   18h+var_4[sp], r2
FFF36A75  ec2e                              mov.l   [r2], r14
FFF36A77  5ee15501                          movu.w  2AAh[r14], r1
FFF36A7B  051cdeff                          bsr.a   sub_FFF34897
FFF36A7F  a081                              mov.l   r1, 18h+var_10[sp]
FFF36A81  a881                              mov.l   18h+var_10[sp], r1
FFF36A83  6101                              cmp     #0, r1
FFF36A85  3b8000                            bne.w   loc_FFF36B05
FFF36A88  a909                              mov.l   18h+var_4[sp], r1
FFF36A8A  0510e9ff                          bsr.a   sub_FFF3539A
FFF36A8E  a081                              mov.l   r1, 18h+var_10[sp]
FFF36A90  a881                              mov.l   18h+var_10[sp], r1
FFF36A92  6101                              cmp     #0, r1
FFF36A94  2171                              bne.b   loc_FFF36B05
FFF36A96  a909                              mov.l   18h+var_4[sp], r1
FFF36A98  05aedeff                          bsr.a   sub_FFF34946
FFF36A9C  a081                              mov.l   r1, 18h+var_10[sp]
FFF36A9E  a881                              mov.l   18h+var_10[sp], r1
FFF36AA0  6101                              cmp     #0, r1
FFF36AA2  2163                              bne.b   loc_FFF36B05
FFF36AA4  a909                              mov.l   18h+var_4[sp], r1
FFF36AA6  0556e0ff                          bsr.a   sub_FFF34AFC
FFF36AAA  a081                              mov.l   r1, 18h+var_10[sp]
FFF36AAC  a881                              mov.l   18h+var_10[sp], r1
FFF36AAE  6101                              cmp     #0, r1
FFF36AB0  2155                              bne.b   loc_FFF36B05
FFF36AB2  a90a                              mov.l   18h+var_4[sp], r2
FFF36AB4  6611                              mov.l   #1, r1
FFF36AB6  05c4d1ff                          bsr.a   sub_FFF33C7A
FFF36ABA  a081                              mov.l   r1, 18h+var_10[sp]
FFF36ABC  a881                              mov.l   18h+var_10[sp], r1
FFF36ABE  6101                              cmp     #0, r1
FFF36AC0  2145                              bne.b   loc_FFF36B05
FFF36AC2  a909                              mov.l   18h+var_4[sp], r1
FFF36AC4  ec1e                              mov.l   [r1], r14
FFF36AC6  5eee6101                          movu.w  2C2h[r14], r14
FFF36ACA  612e                              cmp     #2, r14
FFF36ACC  200d                              beq.b   loc_FFF36AD9
FFF36ACE  a909                              mov.l   18h+var_4[sp], r1
FFF36AD0  ec1e                              mov.l   [r1], r14
FFF36AD2  5eee6101                          movu.w  2C2h[r14], r14
FFF36AD6  613e                              cmp     #3, r14
FFF36AD8  1d                                bne.s   loc_FFF36ADD
FFF36AD9  f80601                 loc_FFF36AD9 mov.l   #1, 18h+var_18[sp]
FFF36ADC  0c                                bra.s   loc_FFF36AE0
FFF36ADD  f80600                 loc_FFF36ADD mov.l   #0, 18h+var_18[sp]
FFF36AE0  ec01                   loc_FFF36AE0 mov.l   18h+var_18[sp], r1
FFF36AE2  6101                              cmp     #0, r1
FFF36AE4  2014                              beq.b   loc_FFF36AF8
FFF36AE6  a90a                              mov.l   18h+var_4[sp], r2
FFF36AE8  ec21                              mov.l   [r2], r1
FFF36AEA  a82a                              mov.l   4[r2], r2
FFF36AEC  ac22                              mov.l   40h[r2], r2
FFF36AEE  7f12                              jsr     r2
FFF36AF0  a081                              mov.l   r1, 18h+var_10[sp]
FFF36AF2  a881                              mov.l   18h+var_10[sp], r1
FFF36AF4  6101                              cmp     #0, r1
FFF36AF6  210f                              bne.b   loc_FFF36B05
FFF36AF8  a909                   loc_FFF36AF8 mov.l   18h+var_4[sp], r1
FFF36AFA  3905fe                            bsr.w   sub_FFF368FF
FFF36AFD  a081                              mov.l   r1, 18h+var_10[sp]
FFF36AFF  a881                              mov.l   18h+var_10[sp], r1
FFF36B01  6101                              cmp     #0, r1
FFF36B03  2011                              beq.b   loc_FFF36B14
FFF36B05  a889                   loc_FFF36B05 mov.l   18h+var_C[sp], r1
FFF36B07  6211                              add     #1, r1
FFF36B09  a089                              mov.l   r1, 18h+var_C[sp]
FFF36B0B  a889                   loc_FFF36B0B mov.l   18h+var_C[sp], r1
FFF36B0D  6131                              cmp     #3, r1
FFF36B0F  2805                              bge.b   loc_FFF36B14
FFF36B11  3804ff                            bra.w   loc_FFF36A15
FFF36B14  e5000201               loc_FFF36B14 mov.l   18h+var_10[sp], 18h+var_14[sp]
FFF36B18  a809                   loc_FFF36B18 mov.l   18h+var_14[sp], r1
FFF36B1A  a101                              mov.l   r1, 18h+var_8[sp]
FFF36B1C  6706                              rtsd    #6
FFF36B1E  fbee887008             sub_FFF36B1E mov.l   #87088h, r14   ; <<<< FUNC sub_FFF36B1E
FFF36B23  f2e88901                          bclr    #0, 189h[r14].b
FFF36B27  fbee008108                        mov.l   #88100h, r14
FFF36B2C  f0eb                              bclr    #3, [r14].b
FFF36B2E  fb1e408108                        mov.l   #88140h, r1
FFF36B33  3c1100                            mov.b   #0, 1[r1]
FFF36B36  fb1e408108                        mov.l   #88140h, r1
FFF36B3B  3c1200                            mov.b   #0, 2[r1]
FFF36B3E  fb1e408108                        mov.l   #88140h, r1
FFF36B43  3c1300                            mov.b   #0, 3[r1]
FFF36B46  fbee408108                        mov.l   #88140h, r14
FFF36B4B  f8e402                            mov.b   #2, [r14]
FFF36B4E  fb1e408108                        mov.l   #88140h, r1
FFF36B53  3c1441                            mov.b   #41h, 4[r1] ; 'A'
FFF36B56  fb1e408108                        mov.l   #88140h, r1
FFF36B5B  3d1300                            mov.w   #0, 6[r1]
FFF36B5E  fbee408108                        mov.l   #88140h, r14
FFF36B63  f9e9044b1d                        mov.w   #1D4Bh, 8[r14]
FFF36B68  fbee887008                        mov.l   #87088h, r14
FFF36B6D  fae400071c                        mov.b   #1Ch, 700h[r14]
FFF36B72  fbee887008                        mov.l   #87088h, r14
FFF36B77  5aef0003                          movu.b  300h[r14], r15
FFF36B7B  780f                              bset    #0, r15
FFF36B7D  762ff100                          and     #0F1h, r15
FFF36B81  cbef0003                          mov.b   r15, 300h[r14]
FFF36B85  fbee887008                        mov.l   #87088h, r14
FFF36B8A  f0e8                              bclr    #0, [r14].b
FFF36B8C  fbee887008                        mov.l   #87088h, r14
FFF36B91  f2e08901                          bset    #0, 189h[r14].b
FFF36B95  fbee008108                        mov.l   #88100h, r14
FFF36B9A  f0e3                              bset    #3, [r14].b
FFF36B9C  02                                rts
FFF36B9D  fbee887008             sub_FFF36B9D mov.l   #87088h, r14   ; <<<< FUNC sub_FFF36B9D
FFF36BA2  f2e88901                          bclr    #0, 189h[r14].b
FFF36BA6  fbee008108                        mov.l   #88100h, r14
FFF36BAB  f0eb                              bclr    #3, [r14].b
FFF36BAD  fb1e408108                        mov.l   #88140h, r1
FFF36BB2  3c1100                            mov.b   #0, 1[r1]
FFF36BB5  fb1e408108                        mov.l   #88140h, r1
FFF36BBA  3c1200                            mov.b   #0, 2[r1]
FFF36BBD  fb1e408108                        mov.l   #88140h, r1
FFF36BC2  3c1300                            mov.b   #0, 3[r1]
FFF36BC5  fbee408108                        mov.l   #88140h, r14
FFF36BCA  f8e406                            mov.b   #6, [r14]
FFF36BCD  fb1e408108                        mov.l   #88140h, r1
FFF36BD2  3c1441                            mov.b   #41h, 4[r1] ; 'A'
FFF36BD5  fb1e408108                        mov.l   #88140h, r1
FFF36BDA  3d1300                            mov.w   #0, 6[r1]
FFF36BDD  fbee408108                        mov.l   #88140h, r14
FFF36BE2  f9e9041ab7                        mov.w   #-48E6h, 8[r14]
FFF36BE7  fbee887008                        mov.l   #87088h, r14
FFF36BEC  fae400071c                        mov.b   #1Ch, 700h[r14]
FFF36BF1  fbee887008                        mov.l   #87088h, r14
FFF36BF6  5aef0003                          movu.b  300h[r14], r15
FFF36BFA  780f                              bset    #0, r15
FFF36BFC  762ff100                          and     #0F1h, r15

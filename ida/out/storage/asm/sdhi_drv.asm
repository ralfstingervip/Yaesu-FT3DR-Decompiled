; ==== sdhi_drv  FFF32900-FFF33C80  (file 332900-333C80) ====
FFF32900  710418                 sub_FFF32900 add     #arg_14, sp, r4   ; <<<< FUNC sub_FFF32900
FFF32903  053802ff                          bsr.a   sub_FFF22B3B
FFF32907  710010                            add     #10h, sp, sp
FFF3290A  a709                              mov.l   r1, -10h+arg_80[sp]
FFF3290C  2e21                              bra.b   locret_FFF3292D
FFF3290E  af8a                              mov.l   -10h+arg_88[sp], r2
FFF32910  60c0                              sub     #0Ch, sp
FFF32912  710360                            add     #-4+arg_60, sp, r3
FFF32915  a00b                              mov.l   r3, -4+arg_4[sp]
FFF32917  f80400                            mov.b   #0, -4+arg_0[sp]
FFF3291A  a082                              mov.l   r2, -4+arg_8[sp]
FFF3291C  72220602                          add     #206h, r2, r2
FFF32920  6624                              mov.l   #2, r4
FFF32922  710314                            add     #-4+arg_14, sp, r3
FFF32925  05a5fdfe                          bsr.a   sub_FFF226CA
FFF32929  62c0                              add     #0Ch, sp
FFF3292B  a709                              mov.l   r1, -10h+arg_80[sp]
FFF3292D  af09                   locret_FFF3292D mov.l   -10h+arg_80[sp], r1
FFF3292F  6101                              cmp     #0, r1
FFF32931  2010                              beq.b   locret_FFF32941
FFF32933  aa89                              mov.l   -10h+arg_38[sp], r1
FFF32935  fa14420400                        mov.b   #0, 442h[r1]
FFF3293A  e5001d01                          mov.l   -10h+arg_80[sp], -10h+arg_10[sp]
FFF3293E  389b00                            bra.w   loc_FFF329D9
FFF32941  af8a                   locret_FFF32941 mov.l   -10h+arg_88[sp], r2
FFF32943  ac04                              mov.l   -10h+arg_4C[sp], r4
FFF32945  ac8b                              mov.l   -10h+arg_58[sp], r3
FFF32947  ab01                              mov.l   -10h+arg_3C[sp], r1
FFF32949  6080                              sub     #8, sp
FFF3294B  a00a                              mov.l   r2, -8+arg_8[sp]
FFF3294D  f80477                            mov.b   #77h, -8+arg_4[sp] ; 'w'
FFF32950  710244                            add     #-8+arg_48, sp, r2
FFF32953  05dc19ff                          bsr.a   sub_FFF2432F
FFF32957  6280                              add     #8, sp
FFF32959  a709                              mov.l   r1, -10h+arg_80[sp]
FFF3295B  af09                              mov.l   -10h+arg_80[sp], r1
FFF3295D  6101                              cmp     #0, r1
FFF3295F  200f                              beq.b   loc_FFF3296E
FFF32961  aa89                              mov.l   -10h+arg_38[sp], r1
FFF32963  fa14420400                        mov.b   #0, 442h[r1]
FFF32968  e5001d01                          mov.l   -10h+arg_80[sp], -10h+arg_10[sp]
FFF3296C  2e6d                              bra.b   loc_FFF329D9
FFF3296E  ab89                   loc_FFF3296E mov.l   -10h+arg_48[sp], r1
FFF32970  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF32976  aa89                              mov.l   -10h+arg_38[sp], r1
FFF32978  210d                              bne.b   locret_FFF32985
FFF3297A  fa14420400                        mov.b   #0, 442h[r1]
FFF3297F  f90601c3                          mov.l   #-3Dh, -10h+arg_10[sp]
FFF32983  2e56                              bra.b   loc_FFF329D9
FFF32985  af8a                   locret_FFF32985 mov.l   -10h+arg_88[sp], r2
FFF32987  053947fe                          bsr.a   sub_FFF170C0
FFF3298B  a709                              mov.l   r1, -10h+arg_80[sp]
FFF3298D  af09                              mov.l   -10h+arg_80[sp], r1
FFF3298F  6101                              cmp     #0, r1
FFF32991  200f                              beq.b   loc_FFF329A0
FFF32993  aa89                              mov.l   -10h+arg_38[sp], r1
FFF32995  fa14420400                        mov.b   #0, 442h[r1]
FFF3299A  e5001d01                          mov.l   -10h+arg_80[sp], -10h+arg_10[sp]
FFF3299E  2e3b                              bra.b   loc_FFF329D9
FFF329A0  aa89                   loc_FFF329A0 mov.l   -10h+arg_38[sp], r1
FFF329A2  ed0221                            mov.l   -10h+arg_90[sp], r2
FFF329A5  e1120c                            mov.l   30h[r1], [r2]
FFF329A8  aa89                              mov.l   -10h+arg_38[sp], r1
FFF329AA  ab11                              mov.l   30h[r1], r1
FFF329AC  ab82                              mov.l   -10h+arg_44[sp], r2
FFF329AE  ef1e                              mov.l   r1, r14
FFF329B0  fc272e                            divu    r2, r14
FFF329B3  4f2e                              mul     r2, r14
FFF329B5  43e1                              sub     r14, r1
FFF329B7  ed0220                            mov.l   -10h+arg_8C[sp], r2
FFF329BA  e321                              mov.l   r1, [r2]
FFF329BC  ed0120                            mov.l   -10h+arg_8C[sp], r1
FFF329BF  ec1e                              mov.l   [r1], r14
FFF329C1  610e                              cmp     #0, r14
FFF329C3  200c                              beq.b   loc_FFF329CF
FFF329C5  ed0120                            mov.l   -10h+arg_8C[sp], r1
FFF329C8  ab82                              mov.l   -10h+arg_44[sp], r2
FFF329CA  068012                            sub     [r1].l, r2
FFF329CD  e312                              mov.l   r2, [r1]
FFF329CF  aa89                   loc_FFF329CF mov.l   -10h+arg_38[sp], r1
FFF329D1  fa14420400                        mov.b   #0, 442h[r1]
FFF329D6  3e0100                            mov.l   #0, -10h+arg_10[sp]
FFF329D9  a809                   loc_FFF329D9 mov.l   -10h+arg_10[sp], r1
FFF329DB  a781                              mov.l   r1, -10h+arg_84[sp]
FFF329DD  3f6625                            rtsd    #94h, r6-r6
FFF329E0  fbee0d7208             sub_FFF329E0 mov.l   #8720Dh, r14   ; <<<< FUNC sub_FFF329E0
FFF329E5  5cef                              movu.w  [r14], r15
FFF329E7  762fff7f                          and     #7FFFh, r15
FFF329EB  d3ef                              mov.w   r15, [r14]
FFF329ED  02                                rts
FFF329EE  fbee0d7208             sub_FFF329EE mov.l   #8720Dh, r14   ; <<<< FUNC sub_FFF329EE
FFF329F3  dcef                              mov.w   [r14], r15
FFF329F5  78ff                              bset    #0Fh, r15
FFF329F7  d3ef                              mov.w   r15, [r14]
FFF329F9  02                                rts
FFF329FA  60c0                   sub_FFF329FA sub     #0Ch, sp   ; <<<< FUNC sub_FFF329FA
FFF329FC  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF329FE  818a                              mov.b   r2, 0Ch+var_5[sp]
FFF32A00  fbe2345e0600                      mov.l   #65E34h, r14
FFF32A06  a881                              mov.l   0Ch+var_4[sp], r1
FFF32A08  b18a                              movu.b  0Ch+var_5[sp], r2
FFF32A0A  fe22e1                            mov.l   r1, [r2, r14]
FFF32A0D  fbe2385e0600                      mov.l   #65E38h, r14
FFF32A13  f8e600                            mov.l   #0, [r14]
FFF32A16  fbee40ac08                        mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF32A1B  ecef                              mov.l   [r14], r15
FFF32A1D  752fe7                            and     #-19h, r15
FFF32A20  e3ef                              mov.l   r15, [r14]
FFF32A22  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF32A25  6601                              mov.l   #0, r1
FFF32A27  6703                              rtsd    #3
FFF32A29  6080                   sub_FFF32A29 sub     #8, sp   ; <<<< FUNC sub_FFF32A29
FFF32A2B  3c0700                            mov.b   #0, 8+var_1[sp]
FFF32A2E  3c0700                            mov.b   #0, 8+var_1[sp]
FFF32A31  2e7f                              bra.b   loc_FFF32AB0
FFF32A33  fbee38ac08             loc_FFF32A33 mov.l   #8AC38h, r14; SDHI.SDSTS1
FFF32A38  e0e0                              mov.l   [r14], 8+var_8[sp]
FFF32A3A  ec01                              mov.l   8+var_8[sp], r1
FFF32A3C  752110                            and     #10h, r1
FFF32A3F  755110                            cmp     #10h, r1
FFF32A42  2132                              bne.b   loc_FFF32A74
FFF32A44  fbe2385e0600                      mov.l   #65E38h, r14
FFF32A4A  ecee                              mov.l   [r14], r14
FFF32A4C  611e                              cmp     #1, r14
FFF32A4E  2019                              beq.b   loc_FFF32A67
FFF32A50  fbe2385e0600                      mov.l   #65E38h, r14
FFF32A56  f8e601                            mov.l   #1, [r14]
FFF32A59  fbe2345e0600                      mov.l   #65E34h, r14
FFF32A5F  8989                              mov.b   8+var_1[sp], r1
FFF32A61  fe61ee                            mov.l   [r1, r14], r14
FFF32A64  f1e658                            bset    #6, 58h[r14].b
FFF32A67  fbee38ac08             loc_FFF32A67 mov.l   #8AC38h, r14; SDHI.SDSTS1
FFF32A6C  ecef                              mov.l   [r14], r15
FFF32A6E  7a4f                              bclr    #4, r15
FFF32A70  e3ef                              mov.l   r15, [r14]
FFF32A72  2e38                              bra.b   loc_FFF32AAA
FFF32A74  ec01                   loc_FFF32A74 mov.l   8+var_8[sp], r1
FFF32A76  6481                              and     #8, r1
FFF32A78  6181                              cmp     #8, r1
FFF32A7A  2130                              bne.b   loc_FFF32AAA
FFF32A7C  fbe2385e0600                      mov.l   #65E38h, r14
FFF32A82  ecee                              mov.l   [r14], r14
FFF32A84  611e                              cmp     #1, r14
FFF32A86  2119                              bne.b   loc_FFF32A9F
FFF32A88  fbe2385e0600                      mov.l   #65E38h, r14
FFF32A8E  f8e600                            mov.l   #0, [r14]
FFF32A91  fbe2345e0600                      mov.l   #65E34h, r14
FFF32A97  8989                              mov.b   8+var_1[sp], r1
FFF32A99  fe61ee                            mov.l   [r1, r14], r14
FFF32A9C  f1ee58                            bclr    #6, 58h[r14].b
FFF32A9F  fbee38ac08             loc_FFF32A9F mov.l   #8AC38h, r14; SDHI.SDSTS1
FFF32AA4  ecef                              mov.l   [r14], r15
FFF32AA6  7a3f                              bclr    #3, r15
FFF32AA8  e3ef                              mov.l   r15, [r14]
FFF32AAA  b189                   loc_FFF32AAA movu.b  8+var_1[sp], r1
FFF32AAC  6211                              add     #1, r1
FFF32AAE  8189                              mov.b   r1, 8+var_1[sp]
FFF32AB0  8989                   loc_FFF32AB0 mov.b   8+var_1[sp], r1
FFF32AB2  6101                              cmp     #0, r1
FFF32AB4  2a05                              bgt.b   loc_FFF32AB9
FFF32AB6  387dff                            bra.w   loc_FFF32A33
FFF32AB9  6702                   loc_FFF32AB9 rtsd    #2
FFF32ABB  7100e4                 sub_FFF32ABB add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF32ABB
FFF32ABE  8689                              mov.b   r1, 1Ch+var_1[sp]
FFF32AC0  3e0400                            mov.l   #0, 1Ch+var_C[sp]
FFF32AC3  fbe2345e0600                      mov.l   #65E34h, r14
FFF32AC9  b689                              movu.b  1Ch+var_1[sp], r1
FFF32ACB  fe61e1                            mov.l   [r1, r14], r1
FFF32ACE  aa19                              mov.l   24h[r1], r1
FFF32AD0  6101                              cmp     #0, r1
FFF32AD2  18                                bne.s   loc_FFF32ADA
FFF32AD3  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF32AD7  38c500                            bra.w   loc_FFF32B9C
FFF32ADA  fbe2345e0600           loc_FFF32ADA mov.l   #65E34h, r14
FFF32AE0  b689                              movu.b  1Ch+var_1[sp], r1
FFF32AE2  fe61e1                            mov.l   [r1, r14], r1
FFF32AE5  e5100902                          mov.l   24h[r1], 1Ch+var_14[sp]
FFF32AE9  a881                              mov.l   1Ch+var_14[sp], r1
FFF32AEB  a819                              mov.l   4[r1], r1
FFF32AED  a891                              mov.l   8[r1], r1
FFF32AEF  7f11                              jsr     r1
FFF32AF1  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF32AF3  a901                              mov.l   1Ch+var_C[sp], r1
FFF32AF5  6101                              cmp     #0, r1
FFF32AF7  211b                              bne.b   loc_FFF32B12
FFF32AF9  fbe2345e0600                      mov.l   #65E34h, r14
FFF32AFF  b689                              movu.b  1Ch+var_1[sp], r1
FFF32B01  fe61ee                            mov.l   [r1, r14], r14
FFF32B04  59ee58                            movu.b  58h[r14], r14
FFF32B07  752e40                            and     #40h, r14 ; '@'
FFF32B0A  755e40                            cmp     #40h, r14 ; '@'
FFF32B0D  1d                                bne.s   loc_FFF32B12
FFF32B0E  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF32B11  0c                                bra.s   loc_FFF32B15
FFF32B12  f80600                 loc_FFF32B12 mov.l   #0, 1Ch+var_1C[sp]
FFF32B15  ec01                   loc_FFF32B15 mov.l   1Ch+var_1C[sp], r1
FFF32B17  6101                              cmp     #0, r1
FFF32B19  2042                              beq.b   loc_FFF32B5B
FFF32B1B  3e0301                            mov.l   #1, 1Ch+var_10[sp]
FFF32B1E  fbe2345e0600                      mov.l   #65E34h, r14
FFF32B24  b689                              movu.b  1Ch+var_1[sp], r1
FFF32B26  fe61ee                            mov.l   [r1, r14], r14
FFF32B29  754f80                            mov.l   #-80h, r15
FFF32B2C  51ef58                            and     58h[r14], r15
FFF32B2F  755f80                            cmp     #-80h, r15
FFF32B32  2066                              beq.b   loc_FFF32B98
FFF32B34  fbe2345e0600                      mov.l   #65E34h, r14
FFF32B3A  b689                              movu.b  1Ch+var_1[sp], r1
FFF32B3C  fe61e1                            mov.l   [r1, r14], r1
FFF32B3F  05dd29ff                          bsr.a   sub_FFF2551C
FFF32B43  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF32B45  a901                              mov.l   1Ch+var_C[sp], r1
FFF32B47  6101                              cmp     #0, r1
FFF32B49  17                                beq.s   loc_FFF32B50
FFF32B4A  e5000403                          mov.l   1Ch+var_C[sp], 1Ch+var_10[sp]
FFF32B4E  2e4a                              bra.b   loc_FFF32B98
FFF32B50  fbe29b220100           loc_FFF32B50 mov.l   #1229Bh, r14
FFF32B56  f8e401                            mov.b   #1, [r14]
FFF32B59  2e3f                              bra.b   loc_FFF32B98
FFF32B5B  3e0300                 loc_FFF32B5B mov.l   #0, 1Ch+var_10[sp]
FFF32B5E  fbe2345e0600                      mov.l   #65E34h, r14
FFF32B64  b689                              movu.b  1Ch+var_1[sp], r1
FFF32B66  fe61ee                            mov.l   [r1, r14], r14
FFF32B69  754f80                            mov.l   #-80h, r15
FFF32B6C  51ef58                            and     58h[r14], r15
FFF32B6F  755f80                            cmp     #-80h, r15
FFF32B72  2126                              bne.b   loc_FFF32B98
FFF32B74  fbe2345e0600                      mov.l   #65E34h, r14
FFF32B7A  b689                              movu.b  1Ch+var_1[sp], r1
FFF32B7C  fe61e1                            mov.l   [r1, r14], r1
FFF32B7F  05c22aff                          bsr.a   sub_FFF25641
FFF32B83  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF32B85  a901                              mov.l   1Ch+var_C[sp], r1
FFF32B87  6101                              cmp     #0, r1
FFF32B89  16                                beq.s   loc_FFF32B8F
FFF32B8A  e5000403                          mov.l   1Ch+var_C[sp], 1Ch+var_10[sp]
FFF32B8E  0a                                bra.s   loc_FFF32B98
FFF32B8F  fbe29b220100           loc_FFF32B8F mov.l   #1229Bh, r14
FFF32B95  f8e400                            mov.b   #0, [r14]
FFF32B98  e5000301               loc_FFF32B98 mov.l   1Ch+var_10[sp], 1Ch+var_18[sp]
FFF32B9C  a809                   loc_FFF32B9C mov.l   1Ch+var_18[sp], r1
FFF32B9E  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF32BA0  6707                              rtsd    #7
FFF32BA2  6040                   sub_FFF32BA2 sub     #4, sp   ; <<<< FUNC sub_FFF32BA2
FFF32BA4  8089                              mov.b   r1, 4+var_1[sp]
FFF32BA6  fbe2345e0600                      mov.l   #65E34h, r14
FFF32BAC  b089                              movu.b  4+var_1[sp], r1
FFF32BAE  fe61e1                            mov.l   [r1, r14], r1
FFF32BB1  05902aff                          bsr.a   sub_FFF25641
FFF32BB5  6701                              rtsd    #1
FFF32BB7  fbee008108             sub_FFF32BB7 mov.l   #88100h, r14   ; <<<< FUNC sub_FFF32BB7
FFF32BBC  f0ec                              bclr    #4, [r14].b
FFF32BBE  fbee107208                        mov.l   #87210h, r14
FFF32BC3  f0e8                              bclr    #0, [r14].b
FFF32BC5  fbee807708                        mov.l   #87780h, r14
FFF32BCA  58ef                              movu.b  [r14], r15
FFF32BCC  f8e421                            mov.b   #21h, [r14] ; '!'
FFF32BCF  fbee807008                        mov.l   #87080h, r14
FFF32BD4  f0e8                              bclr    #0, [r14].b
FFF32BD6  fbee807308                        mov.l   #87380h, r14
FFF32BDB  58ef                              movu.b  [r14], r15
FFF32BDD  657f                              or      #7, r15
FFF32BDF  762ff700                          and     #0F7h, r15
FFF32BE3  c3ef                              mov.b   r15, [r14]
FFF32BE5  fbee107208                        mov.l   #87210h, r14
FFF32BEA  f0e0                              bset    #0, [r14].b
FFF32BEC  fbee508108                        mov.l   #88150h, r14
FFF32BF1  f8e422                            mov.b   #22h, [r14] ; '"'
FFF32BF4  fb1e508108                        mov.l   #88150h, r1
FFF32BF9  3c11c0                            mov.b   #-40h, 1[r1]
FFF32BFC  fb1e508108                        mov.l   #88150h, r1
FFF32C01  3c1200                            mov.b   #0, 2[r1]
FFF32C04  fbee508108                        mov.l   #88150h, r14
FFF32C09  f9e904b80b                        mov.w   #0BB8h, 8[r14]
FFF32C0E  fb1e508108                        mov.l   #88150h, r1
FFF32C13  3c1401                            mov.b   #1, 4[r1]
FFF32C16  fbee008108                        mov.l   #88100h, r14
FFF32C1B  f0e4                              bset    #4, [r14].b
FFF32C1D  02                                rts
FFF32C1E  6e12                   sub_FFF32C1E pushm   r1-r2   ; <<<< FUNC sub_FFF32C1E
FFF32C20  fb1238950600                      mov.l   #69538h, r1
FFF32C26  ec12                              mov.l   [r1], r2
FFF32C28  6212                              add     #1, r2
FFF32C2A  e312                              mov.l   r2, [r1]
FFF32C2C  fb1e558108                        mov.l   #88155h, r1
FFF32C31  f018                              bclr    #0, [r1].b
FFF32C33  6f12                              popm    r1-r2
FFF32C35  7f95                              rte
FFF32C37  6080                   sub_FFF32C37 sub     #8, sp   ; <<<< FUNC sub_FFF32C37
FFF32C39  a009                              mov.l   r1, 8+var_4[sp]
FFF32C3B  fbe238950600                      mov.l   #69538h, r14
FFF32C41  e0e0                              mov.l   [r14], 8+var_8[sp]
FFF32C43  fbe238950600           loc_FFF32C43 mov.l   #69538h, r14
FFF32C49  ecee                              mov.l   [r14], r14
FFF32C4B  06800e                            sub     [sp].l, r14
FFF32C4E  06850e01                          cmp     8+var_4[sp].l, r14
FFF32C52  23f1                              bltu.b  loc_FFF32C43
FFF32C54  6702                              rtsd    #2
FFF32C56  7100e8                 sub_FFF32C56 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF32C56
FFF32C59  a109                              mov.l   r1, 18h+var_4[sp]
FFF32C5B  a102                              mov.l   r2, 18h+var_8[sp]
FFF32C5D  a08b                              mov.l   r3, 18h+var_C[sp]
FFF32C5F  a084                              mov.l   r4, 18h+var_10[sp]
FFF32C61  d5000e03                          mov.w   18h+arg_0[sp], 18h+var_12[sp]
FFF32C65  fbe230800600                      mov.l   #68030h, r14
FFF32C6B  f8e400                            mov.b   #0, [r14]
FFF32C6E  fb522c830600                      mov.l   #6832Ch, r5
FFF32C74  e35e                              mov.l   r14, [r5]
FFF32C76  fb12b07eedff                      mov.l   #off_FFED7EB0, r1
FFF32C7C  a059                              mov.l   r1, 4[r5]
FFF32C7E  dd0f03                            mov.w   18h+var_12[sp], r15
FFF32C81  a884                              mov.l   18h+var_10[sp], r4
FFF32C83  a88b                              mov.l   18h+var_C[sp], r3
FFF32C85  a902                              mov.l   18h+var_8[sp], r2
FFF32C87  a909                              mov.l   18h+var_4[sp], r1
FFF32C89  6080                              sub     #8, sp
FFF32C8B  a00d                              mov.l   r5, 20h+var_1C[sp]
FFF32C8D  d30f                              mov.w   r15, 20h+var_20[sp]
FFF32C8F  05b52b00                          bsr.a   sub_FFF35844
FFF32C93  6280                              add     #8, sp
FFF32C95  e301                              mov.l   r1, 18h+var_18[sp]
FFF32C97  6706                              rtsd    #6
FFF32C99  6eef                   sub_FFF32C99 pushm   r14-r15   ; <<<< FUNC sub_FFF32C99
FFF32C9B  6e15                              pushm   r1-r5
FFF32C9D  058cfdff                          bsr.a   sub_FFF32A29
FFF32CA1  6f15                              popm    r1-r5
FFF32CA3  6fef                              popm    r14-r15
FFF32CA5  7f95                              rte
FFF32CA7  6eef                   sub_FFF32CA7 pushm   r14-r15   ; <<<< FUNC sub_FFF32CA7
FFF32CA9  6e15                              pushm   r1-r5
FFF32CAB  05fc0d00                          bsr.a   sub_FFF33AA7
FFF32CAF  6f15                              popm    r1-r5
FFF32CB1  6fef                              popm    r14-r15
FFF32CB3  7f95                              rte
FFF32CB5  02                     sub_FFF32CB5 rts   ; <<<< FUNC sub_FFF32CB5
FFF32CB6  6040                   sub_FFF32CB6 sub     #4, sp   ; <<<< FUNC sub_FFF32CB6
FFF32CB8  f80600                            mov.l   #0, 4+var_4[sp]
FFF32CBB  6601                              mov.l   #0, r1
FFF32CBD  6701                              rtsd    #1
FFF32CBF  fbee07c108             sub_FFF32CBF mov.l   #8C107h, r14   ; <<<< FUNC sub_FFF32CBF
FFF32CC4  f0e7                              bset    #7, [r14].b
FFF32CC6  fbee27c008                        mov.l   #8C027h, r14
FFF32CCB  f0e7                              bset    #7, [r14].b
FFF32CCD  fbee67c008                        mov.l   #8C067h, r14
FFF32CD2  f0e5                              bset    #5, [r14].b
FFF32CD4  fbee67c008                        mov.l   #8C067h, r14
FFF32CD9  f0e6                              bset    #6, [r14].b
FFF32CDB  fbee67c008                        mov.l   #8C067h, r14
FFF32CE0  f0e7                              bset    #7, [r14].b
FFF32CE2  fbee68c008                        mov.l   #8C068h, r14
FFF32CE7  f0e0                              bset    #0, [r14].b
FFF32CE9  fbee68c008                        mov.l   #8C068h, r14
FFF32CEE  f0e1                              bset    #1, [r14].b
FFF32CF0  fbee6cc008                        mov.l   #8C06Ch, r14
FFF32CF5  f0e2                              bset    #2, [r14].b
FFF32CF7  fbee6cc008                        mov.l   #8C06Ch, r14
FFF32CFC  f0e3                              bset    #3, [r14].b
FFF32CFE  fbee6cc008                        mov.l   #8C06Ch, r14
FFF32D03  f0e4                              bset    #4, [r14].b
FFF32D05  fbeeecc008                        mov.l   #8C0ECh, r14
FFF32D0A  f0e2                              bset    #2, [r14].b
FFF32D0C  fbeeecc008                        mov.l   #8C0ECh, r14
FFF32D11  f0e3                              bset    #3, [r14].b
FFF32D13  fbeeecc008                        mov.l   #8C0ECh, r14
FFF32D18  f0e4                              bset    #4, [r14].b
FFF32D1A  fbee07c108                        mov.l   #8C107h, r14
FFF32D1F  f1ef18                            bclr    #7, 18h[r14].b
FFF32D22  fbee07c108                        mov.l   #8C107h, r14
FFF32D27  f1e618                            bset    #6, 18h[r14].b
FFF32D2A  fbee07c108                        mov.l   #8C107h, r14
FFF32D2F  59ef76                            movu.b  76h[r14], r15
FFF32D32  753f1a                            or      #1Ah, r15
FFF32D35  762fda00                          and     #0DAh, r15
FFF32D39  c7ef76                            mov.b   r15, 76h[r14]
FFF32D3C  fbee07c108                        mov.l   #8C107h, r14
FFF32D41  59ef77                            movu.b  77h[r14], r15
FFF32D44  753f1a                            or      #1Ah, r15
FFF32D47  762fda00                          and     #0DAh, r15
FFF32D4B  c7ef77                            mov.b   r15, 77h[r14]
FFF32D4E  fbee07c108                        mov.l   #8C107h, r14
FFF32D53  59ef78                            movu.b  78h[r14], r15
FFF32D56  753f1a                            or      #1Ah, r15
FFF32D59  762fda00                          and     #0DAh, r15
FFF32D5D  c7ef78                            mov.b   r15, 78h[r14]
FFF32D60  fbee07c108                        mov.l   #8C107h, r14
FFF32D65  59ef79                            movu.b  79h[r14], r15
FFF32D68  753f1a                            or      #1Ah, r15
FFF32D6B  762fda00                          and     #0DAh, r15
FFF32D6F  c7ef79                            mov.b   r15, 79h[r14]
FFF32D72  fbee07c108                        mov.l   #8C107h, r14
FFF32D77  59ef7a                            movu.b  7Ah[r14], r15
FFF32D7A  753f1a                            or      #1Ah, r15
FFF32D7D  762fda00                          and     #0DAh, r15
FFF32D81  c7ef7a                            mov.b   r15, 7Ah[r14]
FFF32D84  fbee07c108                        mov.l   #8C107h, r14
FFF32D89  59ef9b                            movu.b  9Bh[r14], r15
FFF32D8C  753f1a                            or      #1Ah, r15
FFF32D8F  762fda00                          and     #0DAh, r15
FFF32D93  c7ef9b                            mov.b   r15, 9Bh[r14]
FFF32D96  fbee07c108                        mov.l   #8C107h, r14
FFF32D9B  59ef9c                            movu.b  9Ch[r14], r15
FFF32D9E  753f1a                            or      #1Ah, r15
FFF32DA1  762fda00                          and     #0DAh, r15
FFF32DA5  c7ef9c                            mov.b   r15, 9Ch[r14]
FFF32DA8  fbee07c108                        mov.l   #8C107h, r14
FFF32DAD  59ef9d                            movu.b  9Dh[r14], r15
FFF32DB0  753f1a                            or      #1Ah, r15
FFF32DB3  762fda00                          and     #0DAh, r15
FFF32DB7  c7ef9d                            mov.b   r15, 9Dh[r14]
FFF32DBA  fbee07c108                        mov.l   #8C107h, r14
FFF32DBF  f1ee18                            bclr    #6, 18h[r14].b
FFF32DC2  fbee07c108                        mov.l   #8C107h, r14
FFF32DC7  f1e718                            bset    #7, 18h[r14].b
FFF32DCA  fbee0d7208                        mov.l   #8720Dh, r14
FFF32DCF  f0ef                              bclr    #7, [r14].b
FFF32DD1  fbee0d7208                        mov.l   #8720Dh, r14
FFF32DD6  5aef6201                          movu.b  162h[r14], r15
FFF32DDA  656f                              or      #6, r15
FFF32DDC  762ff600                          and     #0F6h, r15
FFF32DE0  cbef6201                          mov.b   r15, 162h[r14]
FFF32DE4  fbee0d7208                        mov.l   #8720Dh, r14
FFF32DE9  72ee6704                          add     #467h, r14, r14
FFF32DED  ecef                              mov.l   [r14], r15
FFF32DEF  783f                              bset    #3, r15
FFF32DF1  e3ef                              mov.l   r15, [r14]
FFF32DF3  fbee0d7208                        mov.l   #8720Dh, r14
FFF32DF8  f0e7                              bset    #7, [r14].b
FFF32DFA  02                                rts
FFF32DFB  6eef                   sub_FFF32DFB pushm   r14-r15   ; <<<< FUNC sub_FFF32DFB
FFF32DFD  6e15                              pushm   r1-r5
FFF32DFF  05230300                          bsr.a   sub_FFF33122
FFF32E03  6f15                              popm    r1-r5
FFF32E05  6fef                              popm    r14-r15
FFF32E07  7f95                              rte
FFF32E09  6040                   sub_FFF32E09 sub     #4, sp   ; <<<< FUNC sub_FFF32E09
FFF32E0B  fbee002208                        mov.l   #82200h, r14
FFF32E10  f8e400                            mov.b   #0, [r14]
FFF32E13  399100                            bsr.w   sub_FFF32EA4
FFF32E16  fb1ed02008                        mov.l   #820D0h, r1
FFF32E1B  3c1c00                            mov.b   #0, 0Ch[r1]
FFF32E1E  fbee057208                        mov.l   #87205h, r14
FFF32E23  f0ec                              bclr    #4, [r14].b
FFF32E25  fbee057208                        mov.l   #87205h, r14
FFF32E2A  f1eb0a                            bclr    #3, 0Ah[r14].b
FFF32E2D  fbee057208                        mov.l   #87205h, r14
FFF32E32  fae407022c                        mov.b   #2Ch, 207h[r14] ; ','
FFF32E37  fbee057208                        mov.l   #87205h, r14
FFF32E3C  5aef2701                          movu.b  127h[r14], r15
FFF32E40  655f                              or      #5, r15
FFF32E42  762ff500                          and     #0F5h, r15
FFF32E46  cbef2701                          mov.b   r15, 127h[r14]
FFF32E4A  fbee057208                        mov.l   #87205h, r14
FFF32E4F  5aef7601                          movu.b  176h[r14], r15
FFF32E53  782f                              bset    #2, r15
FFF32E55  762ff400                          and     #0F4h, r15
FFF32E59  cbef7601                          mov.b   r15, 176h[r14]
FFF32E5D  fb1ed02008                        mov.l   #820D0h, r1
FFF32E62  3d1280                            mov.w   #-80h, 4[r1]
FFF32E65  fbeed02008                        mov.l   #820D0h, r14
FFF32E6A  f8e90192                          mov.w   #-6DFFh, [r14]
FFF32E6E  fb1ed02008                        mov.l   #820D0h, r1
FFF32E73  3c1f00                            mov.b   #0, 0Fh[r1]
FFF32E76  fbeed02008                        mov.l   #820D0h, r14
FFF32E7B  f1e00f                            bset    #0, 0Fh[r14].b
FFF32E7E  fb1ed02008                        mov.l   #820D0h, r1
FFF32E83  3c1310                            mov.b   #10h, 3[r1]
FFF32E86  fbee057208                        mov.l   #87205h, r14
FFF32E8B  f0e4                              bset    #4, [r14].b
FFF32E8D  fbee057208                        mov.l   #87205h, r14
FFF32E92  f1e30a                            bset    #3, 0Ah[r14].b
FFF32E95  fbee002208                        mov.l   #82200h, r14
FFF32E9A  f8e401                            mov.b   #1, [r14]
FFF32E9D  f80600                            mov.l   #0, 4+var_4[sp]
FFF32EA0  6601                              mov.l   #0, r1
FFF32EA2  6701                              rtsd    #1
FFF32EA4  fbeede2008             sub_FFF32EA4 mov.l   #820DEh, r14   ; <<<< FUNC sub_FFF32EA4
FFF32EA9  f0ec                              bclr    #4, [r14].b
FFF32EAB  02                                rts
FFF32EAC  6080                   sub_FFF32EAC sub     #8, sp   ; <<<< FUNC sub_FFF32EAC
FFF32EAE  a009                              mov.l   r1, 8+var_4[sp]
FFF32EB0  e302                              mov.l   r2, 8+var_8[sp]
FFF32EB2  6702                              rtsd    #2
FFF32EB4  60c0                   sub_FFF32EB4 sub     #0Ch, sp   ; <<<< FUNC sub_FFF32EB4
FFF32EB6  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF32EB8  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF32EBA  e303                              mov.l   r3, 0Ch+var_C[sp]
FFF32EBC  fb1ec02008                        mov.l   #820C0h, r1
FFF32EC1  3d1a80                            mov.w   #-80h, 14h[r1]
FFF32EC4  fbeec02008                        mov.l   #820C0h, r14
FFF32EC9  f9e9080192                        mov.w   #-6DFFh, 10h[r14]
FFF32ECE  fb1ec02008                        mov.l   #820C0h, r1
FFF32ED3  3c9c00                            mov.b   #0, 1Ch[r1]
FFF32ED6  fbeec02008                        mov.l   #820C0h, r14
FFF32EDB  e10e01                            mov.l   0Ch+var_8[sp], [r14]
FFF32EDE  fbeec02008                        mov.l   #820C0h, r14
FFF32EE3  e50e0201                          mov.l   0Ch+var_4[sp], 4[r14]
FFF32EE7  fbeec02008                        mov.l   #820C0h, r14
FFF32EEC  f9e20200008000                    mov.l   #800000h, 8[r14]
FFF32EF3  fb1ec02008                        mov.l   #820C0h, r1
FFF32EF8  a892                              mov.l   8[r1], r2
FFF32EFA  7872                              bset    #7, r2
FFF32EFC  a092                              mov.l   r2, 8[r1]
FFF32EFE  ec01                              mov.l   0Ch+var_C[sp], r1
FFF32F00  fb2ec02008                        mov.l   #820C0h, r2
FFF32F05  91a1                              mov.w   r1, 0Ch[r2]
FFF32F07  fb1ec02008                        mov.l   #820C0h, r1
FFF32F0C  3c9c01                            mov.b   #1, 1Ch[r1]
FFF32F0F  6703                              rtsd    #3
FFF32F11  60c0                   sub_FFF32F11 sub     #0Ch, sp   ; <<<< FUNC sub_FFF32F11
FFF32F13  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF32F16  2e24                              bra.b   loc_FFF32F3A
FFF32F18  fb1edc2008             loc_FFF32F18 mov.l   #820DCh, r1
FFF32F1D  b091                              movu.b  2[r1], r1
FFF32F1F  6871                              shlr    #7, r1
FFF32F21  8289                              mov.b   r1, 0Ch+var_1[sp]
FFF32F23  f5000b                            btst    #0, 0Ch+var_1[sp].b
FFF32F26  15                                beq.s   loc_FFF32F2B
FFF32F27  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF32F2A  0c                                bra.s   loc_FFF32F2E
FFF32F2B  f80601                 loc_FFF32F2B mov.l   #1, 0Ch+var_C[sp]
FFF32F2E  ec01                   loc_FFF32F2E mov.l   0Ch+var_C[sp], r1
FFF32F30  6101                              cmp     #0, r1
FFF32F32  2111                              bne.b   loc_FFF32F43
FFF32F34  a809                              mov.l   0Ch+var_8[sp], r1
FFF32F36  6211                              add     #1, r1
FFF32F38  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF32F3A  a809                   loc_FFF32F3A mov.l   0Ch+var_8[sp], r1
FFF32F3C  7701000010                        cmp     #100000h, r1
FFF32F41  23d7                              bltu.b  loc_FFF32F18
FFF32F43  fbeedc2008             loc_FFF32F43 mov.l   #820DCh, r14
FFF32F48  f8e400                            mov.b   #0, [r14]
FFF32F4B  6703                              rtsd    #3
FFF32F4D  60c0                   sub_FFF32F4D sub     #0Ch, sp   ; <<<< FUNC sub_FFF32F4D
FFF32F4F  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF32F51  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF32F53  e303                              mov.l   r3, 0Ch+var_C[sp]
FFF32F55  fbeec02008                        mov.l   #820C0h, r14
FFF32F5A  f9e90a0080                        mov.w   #-8000h, 14h[r14]
FFF32F5F  fbeec02008                        mov.l   #820C0h, r14
FFF32F64  f9e9080182                        mov.w   #-7DFFh, 10h[r14]
FFF32F69  fb1ec02008                        mov.l   #820C0h, r1
FFF32F6E  3c9c00                            mov.b   #0, 1Ch[r1]
FFF32F71  fbeec02008                        mov.l   #820C0h, r14
FFF32F76  e10e01                            mov.l   0Ch+var_8[sp], [r14]
FFF32F79  fbeec02008                        mov.l   #820C0h, r14
FFF32F7E  e50e0201                          mov.l   0Ch+var_4[sp], 4[r14]
FFF32F82  fbeec02008                        mov.l   #820C0h, r14
FFF32F87  f9e20200008000                    mov.l   #800000h, 8[r14]
FFF32F8E  fb1ec02008                        mov.l   #820C0h, r1
FFF32F93  a892                              mov.l   8[r1], r2
FFF32F95  7872                              bset    #7, r2
FFF32F97  a092                              mov.l   r2, 8[r1]
FFF32F99  ec01                              mov.l   0Ch+var_C[sp], r1
FFF32F9B  fb2ec02008                        mov.l   #820C0h, r2
FFF32FA0  91a1                              mov.w   r1, 0Ch[r2]
FFF32FA2  fb1ec02008                        mov.l   #820C0h, r1
FFF32FA7  3c9c01                            mov.b   #1, 1Ch[r1]
FFF32FAA  6703                              rtsd    #3
FFF32FAC  60c0                   sub_FFF32FAC sub     #0Ch, sp   ; <<<< FUNC sub_FFF32FAC
FFF32FAE  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF32FB1  2e24                              bra.b   loc_FFF32FD5
FFF32FB3  fb1edc2008             loc_FFF32FB3 mov.l   #820DCh, r1
FFF32FB8  b091                              movu.b  2[r1], r1
FFF32FBA  6871                              shlr    #7, r1
FFF32FBC  8289                              mov.b   r1, 0Ch+var_1[sp]
FFF32FBE  f5000b                            btst    #0, 0Ch+var_1[sp].b
FFF32FC1  15                                beq.s   loc_FFF32FC6
FFF32FC2  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF32FC5  0c                                bra.s   loc_FFF32FC9
FFF32FC6  f80601                 loc_FFF32FC6 mov.l   #1, 0Ch+var_C[sp]
FFF32FC9  ec01                   loc_FFF32FC9 mov.l   0Ch+var_C[sp], r1
FFF32FCB  6101                              cmp     #0, r1
FFF32FCD  2111                              bne.b   loc_FFF32FDE
FFF32FCF  a809                              mov.l   0Ch+var_8[sp], r1
FFF32FD1  6211                              add     #1, r1
FFF32FD3  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF32FD5  a809                   loc_FFF32FD5 mov.l   0Ch+var_8[sp], r1
FFF32FD7  7701000010                        cmp     #100000h, r1
FFF32FDC  23d7                              bltu.b  loc_FFF32FB3
FFF32FDE  fbeedc2008             loc_FFF32FDE mov.l   #820DCh, r14
FFF32FE3  f8e400                            mov.b   #0, [r14]
FFF32FE6  6703                              rtsd    #3
FFF32FE8  6040                   sub_FFF32FE8 sub     #4, sp   ; <<<< FUNC sub_FFF32FE8
FFF32FEA  fbe23c950600                      mov.l   #6953Ch, r14
FFF32FF0  f8e600                            mov.l   #0, [r14]
FFF32FF3  f80600                            mov.l   #0, 4+var_4[sp]
FFF32FF6  6601                              mov.l   #0, r1
FFF32FF8  6701                              rtsd    #1
FFF32FFA  6040                   sub_FFF32FFA sub     #4, sp   ; <<<< FUNC sub_FFF32FFA
FFF32FFC  e301                              mov.l   r1, 4+var_4[sp]
FFF32FFE  fbe23c950600                      mov.l   #6953Ch, r14
FFF33004  0694e1                            or      [r14].l, r1
FFF33007  e3e1                              mov.l   r1, [r14]
FFF33009  6701                              rtsd    #1
FFF3300B  7100f0                 sub_FFF3300B add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3300B
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
FFF3302E  7100ec                 sub_FFF3302E add     #-14h, sp, sp   ; <<<< FUNC sub_FFF3302E
FFF33031  a101                              mov.l   r1, 14h+var_4[sp]
FFF33033  a08a                              mov.l   r2, 14h+var_8[sp]
FFF33035  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF33038  fbe238950600                      mov.l   #69538h, r14
FFF3303E  e0e0                              mov.l   [r14], 14h+var_14[sp]
FFF33040  fbe238950600           loc_FFF33040 mov.l   #69538h, r14
FFF33046  ecee                              mov.l   [r14], r14
FFF33048  06800e                            sub     [sp].l, r14
FFF3304B  06850e03                          cmp     14h+var_8[sp].l, r14
FFF3304F  2308                              bltu.b  loc_FFF33057
FFF33051  f90601ff                          mov.l   #-1, 14h+var_10[sp]
FFF33055  2e13                              bra.b   loc_FFF33068
FFF33057  fbe23c950600           loc_FFF33057 mov.l   #6953Ch, r14
FFF3305D  a901                              mov.l   14h+var_4[sp], r1
FFF3305F  06a00ce1                          tst     [r14].l, r1
FFF33063  20dd                              beq.b   loc_FFF33040
FFF33065  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF33068  a809                   loc_FFF33068 mov.l   14h+var_10[sp], r1
FFF3306A  a081                              mov.l   r1, 14h+var_C[sp]
FFF3306C  6705                              rtsd    #5
FFF3306E  7100ec                 sub_FFF3306E add     #-14h, sp, sp   ; <<<< FUNC sub_FFF3306E
FFF33071  a101                              mov.l   r1, 14h+var_4[sp]
FFF33073  a08a                              mov.l   r2, 14h+var_8[sp]
FFF33075  e10004                            mov.l   14h+var_4[sp], 14h+var_14[sp]
FFF33078  a88a                              mov.l   14h+var_8[sp], r2
FFF3307A  ec01                              mov.l   14h+var_14[sp], r1
FFF3307C  6c92                              shll    #9, r2
FFF3307E  052efeff                          bsr.a   sub_FFF32EAC
FFF33082  a88b                              mov.l   14h+var_8[sp], r3
FFF33084  ec01                              mov.l   14h+var_14[sp], r1
FFF33086  fb2e60ac08                        mov.l   #8AC60h, r2; SDHI.SDBUFR
FFF3308B  0529feff                          bsr.a   sub_FFF32EB4
FFF3308F  fbeeb0ad08                        mov.l   #8ADB0h, r14; SDHI.SDDMAEN
FFF33094  ecef                              mov.l   [r14], r15
FFF33096  7a1f                              bclr    #1, r15
FFF33098  e3ef                              mov.l   r15, [r14]
FFF3309A  fbeeb0ad08                        mov.l   #8ADB0h, r14; SDHI.SDDMAEN
FFF3309F  ecef                              mov.l   [r14], r15
FFF330A1  781f                              bset    #1, r15
FFF330A3  e3ef                              mov.l   r15, [r14]
FFF330A5  fb2af401                          mov.l   #1F4h, r2
FFF330A9  6641                              mov.l   #4, r1
FFF330AB  0560ffff                          bsr.a   sub_FFF3300B
FFF330AF  a009                              mov.l   r1, 14h+var_10[sp]
FFF330B1  0560feff                          bsr.a   sub_FFF32F11
FFF330B5  a809                              mov.l   14h+var_10[sp], r1
FFF330B7  6101                              cmp     #0, r1
FFF330B9  1d                                bne.s   loc_FFF330BE
FFF330BA  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF330BD  0d                                bra.s   loc_FFF330C2
FFF330BE  f90601f1               loc_FFF330BE mov.l   #-0Fh, 14h+var_10[sp]
FFF330C2  a809                   loc_FFF330C2 mov.l   14h+var_10[sp], r1
FFF330C4  a081                              mov.l   r1, 14h+var_C[sp]
FFF330C6  6705                              rtsd    #5
FFF330C8  7100ec                 sub_FFF330C8 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF330C8
FFF330CB  a101                              mov.l   r1, 14h+var_4[sp]
FFF330CD  a08a                              mov.l   r2, 14h+var_8[sp]
FFF330CF  e10004                            mov.l   14h+var_4[sp], 14h+var_14[sp]
FFF330D2  a88a                              mov.l   14h+var_8[sp], r2
FFF330D4  ec01                              mov.l   14h+var_14[sp], r1
FFF330D6  6c92                              shll    #9, r2
FFF330D8  05d4fdff                          bsr.a   sub_FFF32EAC
FFF330DC  a88b                              mov.l   14h+var_8[sp], r3
FFF330DE  ec02                              mov.l   14h+var_14[sp], r2
FFF330E0  fb1e60ac08                        mov.l   #8AC60h, r1; SDHI.SDBUFR
FFF330E5  0568feff                          bsr.a   sub_FFF32F4D
FFF330E9  fbeeb0ad08                        mov.l   #8ADB0h, r14; SDHI.SDDMAEN
FFF330EE  ecef                              mov.l   [r14], r15
FFF330F0  7a1f                              bclr    #1, r15
FFF330F2  e3ef                              mov.l   r15, [r14]
FFF330F4  fbeeb0ad08                        mov.l   #8ADB0h, r14; SDHI.SDDMAEN
FFF330F9  ecef                              mov.l   [r14], r15
FFF330FB  781f                              bset    #1, r15
FFF330FD  e3ef                              mov.l   r15, [r14]
FFF330FF  fb2af401                          mov.l   #1F4h, r2
FFF33103  6641                              mov.l   #4, r1
FFF33105  0506ffff                          bsr.a   sub_FFF3300B
FFF33109  a009                              mov.l   r1, 14h+var_10[sp]
FFF3310B  05a1feff                          bsr.a   sub_FFF32FAC
FFF3310F  a809                              mov.l   14h+var_10[sp], r1
FFF33111  6101                              cmp     #0, r1
FFF33113  1d                                bne.s   loc_FFF33118
FFF33114  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF33117  0d                                bra.s   loc_FFF3311C
FFF33118  f90601f0               loc_FFF33118 mov.l   #-10h, 14h+var_10[sp]
FFF3311C  a809                   loc_FFF3311C mov.l   14h+var_10[sp], r1
FFF3311E  a081                              mov.l   r1, 14h+var_C[sp]
FFF33120  6705                              rtsd    #5
FFF33122  0582fdff               sub_FFF33122 bsr.a   sub_FFF32EA4   ; <<<< FUNC sub_FFF33122
FFF33126  6641                              mov.l   #4, r1
FFF33128  05d2feff                          bsr.a   sub_FFF32FFA
FFF3312C  02                                rts
FFF3312D  7100e0                 sub_FFF3312D add     #-20h, sp, sp   ; <<<< FUNC sub_FFF3312D
FFF33130  9389                              mov.w   r1, 20h+var_2[sp]
FFF33132  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF33135  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF33138  2e54                              bra.b   loc_FFF3318C
FFF3313A  fbee3cac08             loc_FFF3313A mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF3313F  e4e004                            mov.l   [r14], 20h+var_10[sp]
FFF33142  a901                              mov.l   20h+var_10[sp], r1
FFF33144  7ce1                              btst    #0Eh, r1
FFF33146  15                                beq.s   loc_FFF3314B
FFF33147  f80600                            mov.l   #0, 20h+var_20[sp]
FFF3314A  0c                                bra.s   loc_FFF3314E
FFF3314B  f80601                 loc_FFF3314B mov.l   #1, 20h+var_20[sp]
FFF3314E  ec01                   loc_FFF3314E mov.l   20h+var_20[sp], r1
FFF33150  6101                              cmp     #0, r1
FFF33152  12                                beq.s   loc_FFF3315C
FFF33153  a901                              mov.l   20h+var_10[sp], r1
FFF33155  7cd1                              btst    #0Dh, r1
FFF33157  15                                beq.s   loc_FFF3315C
FFF33158  f80601                            mov.l   #1, 20h+var_20[sp]
FFF3315B  0c                                bra.s   loc_FFF3315F
FFF3315C  f80600                 loc_FFF3315C mov.l   #0, 20h+var_20[sp]
FFF3315F  ec01                   loc_FFF3315F mov.l   20h+var_20[sp], r1
FFF33161  6101                              cmp     #0, r1
FFF33163  2132                              bne.b   loc_FFF33195
FFF33165  fbee7f8000                        mov.l   #807Fh, r14
FFF3316A  06a10c0e04                        tst     20h+var_10[sp].l, r14
FFF3316F  17                                beq.s   loc_FFF33176
FFF33170  f90601f7                          mov.l   #-9, 20h+var_1C[sp]
FFF33174  2e6f                              bra.b   loc_FFF331E3
FFF33176  39a600                 loc_FFF33176 bsr.w   sub_FFF3321C
FFF33179  a081                              mov.l   r1, 20h+var_18[sp]
FFF3317B  a881                              mov.l   20h+var_18[sp], r1
FFF3317D  6101                              cmp     #0, r1
FFF3317F  17                                beq.s   loc_FFF33186
FFF33180  e5000201                          mov.l   20h+var_18[sp], 20h+var_1C[sp]
FFF33184  2e5f                              bra.b   loc_FFF331E3
FFF33186  a889                   loc_FFF33186 mov.l   20h+var_14[sp], r1
FFF33188  6211                              add     #1, r1
FFF3318A  a089                              mov.l   r1, 20h+var_14[sp]
FFF3318C  a889                   loc_FFF3318C mov.l   20h+var_14[sp], r1
FFF3318E  7701000010                        cmp     #100000h, r1
FFF33193  23a7                              bltu.b  loc_FFF3313A
FFF33195  a889                   loc_FFF33195 mov.l   20h+var_14[sp], r1
FFF33197  7701000010                        cmp     #100000h, r1
FFF3319C  2308                              bltu.b  loc_FFF331A4
FFF3319E  f90601ff                          mov.l   #-1, 20h+var_1C[sp]
FFF331A2  2e41                              bra.b   loc_FFF331E3
FFF331A4  9b89                   loc_FFF331A4 mov.w   20h+var_2[sp], r1
FFF331A6  7501ff                            cmp     #-1, r1
FFF331A9  2023                              beq.b   loc_FFF331CC
FFF331AB  6121                              cmp     #2, r1
FFF331AD  2018                              beq.b   loc_FFF331C5
FFF331AF  6111                              cmp     #1, r1
FFF331B1  200d                              beq.b   loc_FFF331BE
FFF331B3  6101                              cmp     #0, r1
FFF331B5  211d                              bne.b   loc_FFF331D2
FFF331B7  f90a054001                        mov.l   #140h, 20h+var_C[sp]
FFF331BC  2e1c                              bra.b   loc_FFF331D8
FFF331BE  f90a050101             loc_FFF331BE mov.l   #101h, 20h+var_C[sp]
FFF331C3  2e15                              bra.b   loc_FFF331D8
FFF331C5  f90a050001             loc_FFF331C5 mov.l   #100h, 20h+var_C[sp]
FFF331CA  2e0e                              bra.b   loc_FFF331D8
FFF331CC  f90a050101             loc_FFF331CC mov.l   #101h, 20h+var_C[sp]
FFF331D1  0f                                bra.s   loc_FFF331D8
FFF331D2  f90601f8               loc_FFF331D2 mov.l   #-8, 20h+var_1C[sp]
FFF331D6  2e0d                              bra.b   loc_FFF331E3
FFF331D8  fbee48ac08             loc_FFF331D8 mov.l   #8AC48h, r14; SDHI.SDCLKCR
FFF331DD  e10e05                            mov.l   20h+var_C[sp], [r14]
FFF331E0  3e0100                            mov.l   #0, 20h+var_1C[sp]
FFF331E3  a809                   loc_FFF331E3 mov.l   20h+var_1C[sp], r1
FFF331E5  a181                              mov.l   r1, 20h+var_8[sp]
FFF331E7  6708                              rtsd    #8
FFF331E9  fbee48ac08             sub_FFF331E9 mov.l   #8AC48h, r14; SDHI.SDCLKCR   ; <<<< FUNC sub_FFF331E9
FFF331EE  f8ea0002                          mov.l   #200h, [r14]
FFF331F2  02                                rts
FFF331F3  6040                   sub_FFF331F3 sub     #4, sp   ; <<<< FUNC sub_FFF331F3
FFF331F5  e301                              mov.l   r1, 4+var_4[sp]
FFF331F7  fbee4cac08                        mov.l   #8AC4Ch, r14; SDHI.SDSIZE
FFF331FC  e3e1                              mov.l   r1, [r14]
FFF331FE  6701                              rtsd    #1
FFF33200  6040                   sub_FFF33200 sub     #4, sp   ; <<<< FUNC sub_FFF33200
FFF33202  e301                              mov.l   r1, 4+var_4[sp]
FFF33204  fbee14ac08                        mov.l   #8AC14h, r14; SDHI.SDBLKCNT
FFF33209  e3e1                              mov.l   r1, [r14]
FFF3320B  6701                              rtsd    #1
FFF3320D  6040                   sub_FFF3320D sub     #4, sp   ; <<<< FUNC sub_FFF3320D
FFF3320F  9009                              mov.w   r1, 4+var_2[sp]
FFF33211  fbee10ac08                        mov.l   #8AC10h, r14; SDHI.SDSTOP
FFF33216  b809                              movu.w  4+var_2[sp], r1
FFF33218  e3e1                              mov.l   r1, [r14]
FFF3321A  6701                              rtsd    #1
FFF3321C  60c0                   sub_FFF3321C sub     #0Ch, sp   ; <<<< FUNC sub_FFF3321C
FFF3321E  fbee38ac08                        mov.l   #8AC38h, r14; SDHI.SDSTS1
FFF33223  e4e001                            mov.l   [r14], 0Ch+var_8[sp]
FFF33226  a809                              mov.l   0Ch+var_8[sp], r1
FFF33228  7c51                              btst    #5, r1
FFF3322A  15                                beq.s   loc_FFF3322F
FFF3322B  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF3322E  0c                                bra.s   loc_FFF33232
FFF3322F  f806fa                 loc_FFF3322F mov.l   #-6, 0Ch+var_C[sp]
FFF33232  ec01                   loc_FFF33232 mov.l   0Ch+var_C[sp], r1
FFF33234  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF33236  6703                              rtsd    #3
FFF33238  6040                   sub_FFF33238 sub     #4, sp   ; <<<< FUNC sub_FFF33238
FFF3323A  f80600                            mov.l   #0, 4+var_4[sp]
FFF3323D  6601                              mov.l   #0, r1
FFF3323F  6701                              rtsd    #1
FFF33241  6040                   sub_FFF33241 sub     #4, sp   ; <<<< FUNC sub_FFF33241
FFF33243  f806f7                            mov.l   #-9, 4+var_4[sp]
FFF33246  fb16f7                            mov.l   #-9, r1
FFF33249  6701                              rtsd    #1
FFF3324B  6040                   sub_FFF3324B sub     #4, sp   ; <<<< FUNC sub_FFF3324B
FFF3324D  f806f6                            mov.l   #-0Ah, 4+var_4[sp]
FFF33250  fb16f6                            mov.l   #-0Ah, r1
FFF33253  6701                              rtsd    #1
FFF33255  6080                   sub_FFF33255 sub     #8, sp   ; <<<< FUNC sub_FFF33255
FFF33257  8189                              mov.b   r1, 8+var_1[sp]
FFF33259  f80604                            mov.l   #4, 8+var_8[sp]
FFF3325C  6641                              mov.l   #4, r1
FFF3325E  6702                              rtsd    #2
FFF33260  6080                   sub_FFF33260 sub     #8, sp   ; <<<< FUNC sub_FFF33260
FFF33262  8189                              mov.b   r1, 8+var_1[sp]
FFF33264  f80605                            mov.l   #5, 8+var_8[sp]
FFF33267  6651                              mov.l   #5, r1
FFF33269  6702                              rtsd    #2
FFF3326B  6080                   sub_FFF3326B sub     #8, sp   ; <<<< FUNC sub_FFF3326B
FFF3326D  8189                              mov.b   r1, 8+var_1[sp]
FFF3326F  fbeec0ad08                        mov.l   #8ADC0h, r14; SDHI.SDRST
FFF33274  f8e600                            mov.l   #0, [r14]
FFF33277  fbeec0ad08                        mov.l   #8ADC0h, r14; SDHI.SDRST
FFF3327C  f8e601                            mov.l   #1, [r14]
FFF3327F  f80600                            mov.l   #0, 8+var_8[sp]
FFF33282  6601                              mov.l   #0, r1
FFF33284  6702                              rtsd    #2
FFF33286  6040                   sub_FFF33286 sub     #4, sp   ; <<<< FUNC sub_FFF33286
FFF33288  f80600                            mov.l   #0, 4+var_4[sp]
FFF3328B  6601                              mov.l   #0, r1
FFF3328D  6701                              rtsd    #1
FFF3328F  395aff                 sub_FFF3328F bsr.w   sub_FFF331E9   ; <<<< FUNC sub_FFF3328F
FFF33292  02                                rts
FFF33293  6040                   sub_FFF33293 sub     #4, sp   ; <<<< FUNC sub_FFF33293
FFF33295  9009                              mov.w   r1, 4+var_2[sp]
FFF33297  6121                              cmp     #2, r1
FFF33299  210d                              bne.b   loc_FFF332A6
FFF3329B  fbee50ac08                        mov.l   #8AC50h, r14; SDHI.SDOPT
FFF332A0  f8eaee40                          mov.l   #40EEh, [r14]
FFF332A4  6701                              rtsd    #1
FFF332A6  fbee50ac08             loc_FFF332A6 mov.l   #8AC50h, r14; SDHI.SDOPT
FFF332AB  f8eeeec000                        mov.l   #0C0EEh, [r14]
FFF332B0  6701                              rtsd    #1
FFF332B2  6040                   sub_FFF332B2 sub     #4, sp   ; <<<< FUNC sub_FFF332B2
FFF332B4  8089                              mov.b   r1, 4+var_1[sp]
FFF332B6  6701                              rtsd    #1
FFF332B8  6040                   sub_FFF332B8 sub     #4, sp   ; <<<< FUNC sub_FFF332B8
FFF332BA  8089                              mov.b   r1, 4+var_1[sp]
FFF332BC  6701                              rtsd    #1
FFF332BE  02                     sub_FFF332BE rts   ; <<<< FUNC sub_FFF332BE
FFF332BF  6040                   sub_FFF332BF sub     #4, sp   ; <<<< FUNC sub_FFF332BF
FFF332C1  9009                              mov.w   r1, 4+var_2[sp]
FFF332C3  6701                              rtsd    #1
FFF332C5  6080                   sub_FFF332C5 sub     #8, sp   ; <<<< FUNC sub_FFF332C5
FFF332C7  a009                              mov.l   r1, 8+var_4[sp]
FFF332C9  f806f7                            mov.l   #-9, 8+var_8[sp]
FFF332CC  fb16f7                            mov.l   #-9, r1
FFF332CF  6702                              rtsd    #2
FFF332D1  7100cc                 sub_FFF332D1 add     #-34h, sp, sp   ; <<<< FUNC sub_FFF332D1
FFF332D4  c70133                            mov.b   r1, 34h+var_1[sp]
FFF332D7  3e0900                            mov.l   #0, 34h+var_10[sp]
FFF332DA  3e0800                            mov.l   #0, 34h+var_14[sp]
FFF332DD  3e0700                            mov.l   #0, 34h+var_18[sp]
FFF332E0  3e0500                            mov.l   #0, 34h+var_20[sp]
FFF332E3  3e0400                            mov.l   #0, 34h+var_24[sp]
FFF332E6  3e0300                            mov.l   #0, 34h+var_28[sp]
FFF332E9  3e0200                            mov.l   #0, 34h+var_2C[sp]
FFF332EC  fbee40ac08                        mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF332F1  e4e003                            mov.l   [r14], 34h+var_28[sp]
FFF332F4  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF332F9  e4e002                            mov.l   [r14], 34h+var_2C[sp]
FFF332FC  fbee40ac08                        mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF33301  f8ea1d03                          mov.l   #31Dh, [r14]
FFF33305  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
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
FFF33322  f90e093cac08                      mov.l   #8AC3Ch, 34h+var_10[sp]; SDHI.SDSTS2
FFF33328  f90a040001                        mov.l   #100h, 34h+var_24[sp]
FFF3332D  2e2b                              bra.b   loc_FFF33358
FFF3332F  f90e093cac08           loc_FFF3332F mov.l   #8AC3Ch, 34h+var_10[sp]; SDHI.SDSTS2
FFF33335  f90a040002                        mov.l   #200h, 34h+var_24[sp]
FFF3333A  2e1e                              bra.b   loc_FFF33358
FFF3333C  f90e0938ac08           loc_FFF3333C mov.l   #8AC38h, 34h+var_10[sp]; SDHI.SDSTS1
FFF33342  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF33345  2e13                              bra.b   loc_FFF33358
FFF33347  f90e0938ac08           loc_FFF33347 mov.l   #8AC38h, 34h+var_10[sp]; SDHI.SDSTS1
FFF3334D  3e0404                            mov.l   #4, 34h+var_24[sp]
FFF33350  08                                bra.s   loc_FFF33358
FFF33351  f90601fe               loc_FFF33351 mov.l   #-2, 34h+var_30[sp]
FFF33355  38c600                            bra.w   loc_FFF3341B
FFF33358  3e0a00                 loc_FFF33358 mov.l   #0, 34h+var_C[sp]
FFF3335B  2e6a                              bra.b   loc_FFF333C5
FFF3335D  aa09                   loc_FFF3335D mov.l   34h+var_10[sp], r1
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
FFF33376  fbee40ac08                        mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF3337B  e10e03                            mov.l   34h+var_28[sp], [r14]
FFF3337E  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF33383  e10e02                            mov.l   34h+var_2C[sp], [r14]
FFF33386  3e0100                            mov.l   #0, 34h+var_30[sp]
FFF33389  389200                            bra.w   loc_FFF3341B
FFF3338C  fbee3cac08             loc_FFF3338C mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF33391  e4e007                            mov.l   [r14], 34h+var_18[sp]
FFF33394  754e48                            mov.l   #48h, r14 ; 'H'
FFF33397  06a10c0e07                        tst     34h+var_18[sp].l, r14
FFF3339C  2132                              bne.b   loc_FFF333CE
FFF3339E  397efe                            bsr.w   sub_FFF3321C
FFF333A1  a201                              mov.l   r1, 34h+var_14[sp]
FFF333A3  aa01                              mov.l   34h+var_14[sp], r1
FFF333A5  6101                              cmp     #0, r1
FFF333A7  2018                              beq.b   loc_FFF333BF
FFF333A9  fbee40ac08                        mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF333AE  e10e03                            mov.l   34h+var_28[sp], [r14]
FFF333B1  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF333B6  e10e02                            mov.l   34h+var_2C[sp], [r14]
FFF333B9  e5000801                          mov.l   34h+var_14[sp], 34h+var_30[sp]
FFF333BD  2e5e                              bra.b   loc_FFF3341B
FFF333BF  aa81                   loc_FFF333BF mov.l   34h+var_C[sp], r1
FFF333C1  6211                              add     #1, r1
FFF333C3  a281                              mov.l   r1, 34h+var_C[sp]
FFF333C5  aa81                   loc_FFF333C5 mov.l   34h+var_C[sp], r1
FFF333C7  7701000010                        cmp     #100000h, r1
FFF333CC  2391                              bltu.b  loc_FFF3335D
FFF333CE  590133                 loc_FFF333CE movu.b  34h+var_1[sp], r1
FFF333D1  6111                              cmp     #1, r1
FFF333D3  2134                              bne.b   loc_FFF33407
FFF333D5  fbee38ac08                        mov.l   #8AC38h, r14; SDHI.SDSTS1
FFF333DA  e4e006                            mov.l   [r14], 34h+var_1C[sp]
FFF333DD  fbee3cac08                        mov.l   #8AC3Ch, r14; SDHI.SDSTS2
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
FFF333FC  f80600                 loc_FFF333FC mov.l   #0, 34h+var_34[sp]
FFF333FF  ec01                   loc_FFF333FF mov.l   34h+var_34[sp], r1
FFF33401  6101                              cmp     #0, r1
FFF33403  14                                beq.s   loc_FFF33407
FFF33404  393503                            bsr.w   sub_FFF33739
FFF33407  fbee40ac08             loc_FFF33407 mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF3340C  e10e03                            mov.l   34h+var_28[sp], [r14]
FFF3340F  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF33414  e10e02                            mov.l   34h+var_2C[sp], [r14]
FFF33417  f90601ff                          mov.l   #-1, 34h+var_30[sp]
FFF3341B  a809                   loc_FFF3341B mov.l   34h+var_30[sp], r1
FFF3341D  a289                              mov.l   r1, 34h+var_8[sp]
FFF3341F  670d                              rtsd    #0Dh
FFF33421  7100e4                 sub_FFF33421 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF33421
FFF33424  8689                              mov.b   r1, 1Ch+var_1[sp]
FFF33426  8682                              mov.b   r2, 1Ch+var_2[sp]
FFF33428  a10b                              mov.l   r3, 1Ch+var_8[sp]
FFF3342A  3e0300                            mov.l   #0, 1Ch+var_10[sp]
FFF3342D  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF33430  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF33433  fbee40ac08                        mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF33438  e4e002                            mov.l   [r14], 1Ch+var_14[sp]
FFF3343B  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF33440  e4e001                            mov.l   [r14], 1Ch+var_18[sp]
FFF33443  fbee40ac08                        mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF33448  f8ea1d03                          mov.l   #31Dh, [r14]
FFF3344C  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF33451  f8ee7f8b00                        mov.l   #8B7Fh, [r14]
FFF33456  fbee38ac08                        mov.l   #8AC38h, r14; SDHI.SDSTS1
FFF3345B  e4e003                            mov.l   [r14], 1Ch+var_10[sp]
FFF3345E  a889                              mov.l   1Ch+var_10[sp], r1
FFF33460  7721f8ff00                        and     #0FFF8h, r1
FFF33465  fbee38ac08                        mov.l   #8AC38h, r14; SDHI.SDSTS1
FFF3346A  e3e1                              mov.l   r1, [r14]
FFF3346C  fbee3cac08                        mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF33471  e4e003                            mov.l   [r14], 1Ch+var_10[sp]
FFF33474  a889                              mov.l   1Ch+var_10[sp], r1
FFF33476  76210008                          and     #800h, r1
FFF3347A  fbee3cac08                        mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF3347F  e3e1                              mov.l   r1, [r14]
FFF33481  fbee40ac08                        mov.l   #8AC40h, r14; SDHI.SDIMSK1
FFF33486  e10e02                            mov.l   1Ch+var_14[sp], [r14]
FFF33489  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF3348E  e10e01                            mov.l   1Ch+var_18[sp], [r14]
FFF33491  fbee08ac08                        mov.l   #8AC08h, r14; SDHI.SDARG
FFF33496  e10e05                            mov.l   1Ch+var_8[sp], [r14]
FFF33499  fbee3cac08                        mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF3349E  e4e003                            mov.l   [r14], 1Ch+var_10[sp]
FFF334A1  a889                              mov.l   1Ch+var_10[sp], r1
FFF334A3  7ce1                              btst    #0Eh, r1
FFF334A5  16                                beq.s   loc_FFF334AB
FFF334A6  f806f7                            mov.l   #-9, 1Ch+var_1C[sp]
FFF334A9  2e60                              bra.b   loc_FFF33509
FFF334AB  b681                   loc_FFF334AB movu.b  1Ch+var_2[sp], r1
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
FFF334CC  fbfe00ac08                        mov.l   #8AC00h, r15; SDHI.SDCMD
FFF334D1  e3fe                              mov.l   r14, [r15]
FFF334D3  2e33                              bra.b   loc_FFF33506
FFF334D5  763e0005               loc_FFF334D5 or      #500h, r14
FFF334D9  fbfe00ac08                        mov.l   #8AC00h, r15; SDHI.SDCMD
FFF334DE  e3fe                              mov.l   r14, [r15]
FFF334E0  2e26                              bra.b   loc_FFF33506
FFF334E2  fbe2e4e1ecff           loc_FFF334E2 mov.l   #unk_FFECE1E4, r14
FFF334E8  b689                              movu.b  1Ch+var_1[sp], r1
FFF334EA  fed1ee                            movu.w  [r1, r14], r14
FFF334ED  fbfe00ac08                        mov.l   #8AC00h, r15; SDHI.SDCMD
FFF334F2  e3fe                              mov.l   r14, [r15]
FFF334F4  2e12                              bra.b   loc_FFF33506
FFF334F6  fbe264e2ecff           loc_FFF334F6 mov.l   #unk_FFECE264, r14
FFF334FC  fed1ee                            movu.w  [r1, r14], r14
FFF334FF  fbfe00ac08                        mov.l   #8AC00h, r15; SDHI.SDCMD
FFF33504  e3fe                              mov.l   r14, [r15]
FFF33506  f80600                 loc_FFF33506 mov.l   #0, 1Ch+var_1C[sp]
FFF33509  ec01                   loc_FFF33509 mov.l   1Ch+var_1C[sp], r1
FFF3350B  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF3350D  6707                              rtsd    #7
FFF3350F  60c0                   sub_FFF3350F sub     #0Ch, sp   ; <<<< FUNC sub_FFF3350F
FFF33511  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF33514  6611                              mov.l   #1, r1
FFF33516  39bbfd                            bsr.w   sub_FFF332D1
FFF33519  6101                              cmp     #0, r1
FFF3351B  16                                beq.s   loc_FFF33521
FFF3351C  f806ff                            mov.l   #-1, 0Ch+var_C[sp]
FFF3351F  2e13                              bra.b   loc_FFF33532
FFF33521  fbee3cac08             loc_FFF33521 mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF33526  e4e001                            mov.l   [r14], 0Ch+var_8[sp]
FFF33529  a809                              mov.l   0Ch+var_8[sp], r1
FFF3352B  77217f8000                        and     #807Fh, r1
FFF33530  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF33532  ec01                   loc_FFF33532 mov.l   0Ch+var_C[sp], r1
FFF33534  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF33536  6703                              rtsd    #3
FFF33538  7100ec                 sub_FFF33538 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF33538
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
FFF3355A  7100ec                 sub_FFF3355A add     #-14h, sp, sp   ; <<<< FUNC sub_FFF3355A
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
FFF33576  f80601                 loc_FFF33576 mov.l   #1, 14h+var_14[sp]
FFF33579  0c                                bra.s   loc_FFF3357D
FFF3357A  f80600                 loc_FFF3357A mov.l   #0, 14h+var_14[sp]
FFF3357D  ec01                   loc_FFF3357D mov.l   14h+var_14[sp], r1
FFF3357F  6101                              cmp     #0, r1
FFF33581  1e                                bne.s   loc_FFF33587
FFF33582  9a09                              mov.w   14h+var_2[sp], r1
FFF33584  6171                              cmp     #7, r1
FFF33586  1d                                bne.s   loc_FFF3358B
FFF33587  f80601                 loc_FFF33587 mov.l   #1, 14h+var_14[sp]
FFF3358A  0c                                bra.s   loc_FFF3358E
FFF3358B  f80600                 loc_FFF3358B mov.l   #0, 14h+var_14[sp]
FFF3358E  ec01                   loc_FFF3358E mov.l   14h+var_14[sp], r1
FFF33590  6101                              cmp     #0, r1
FFF33592  201b                              beq.b   loc_FFF335AD
FFF33594  a809                              mov.l   14h+var_10[sp], r1
FFF33596  f81600                            mov.l   #0, [r1]
FFF33599  fbee18ac08                        mov.l   #8AC18h, r14; SDHI.SDRSP10
FFF3359E  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF335A1  a809                              mov.l   14h+var_10[sp], r1
FFF335A3  ec1e                              mov.l   [r1], r14
FFF335A5  06950e02                          or      14h+var_C[sp].l, r14
FFF335A9  e31e                              mov.l   r14, [r1]
FFF335AB  6705                              rtsd    #5
FFF335AD  9a09                   loc_FFF335AD mov.w   14h+var_2[sp], r1
FFF335AF  6131                              cmp     #3, r1
FFF335B1  211b                              bne.b   loc_FFF335CC
FFF335B3  a809                              mov.l   14h+var_10[sp], r1
FFF335B5  f81600                            mov.l   #0, [r1]
FFF335B8  fbee18ac08                        mov.l   #8AC18h, r14; SDHI.SDRSP10
FFF335BD  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF335C0  a809                              mov.l   14h+var_10[sp], r1
FFF335C2  ec1e                              mov.l   [r1], r14
FFF335C4  06950e02                          or      14h+var_C[sp].l, r14
FFF335C8  e31e                              mov.l   r14, [r1]
FFF335CA  6705                              rtsd    #5
FFF335CC  fbee30ac08             loc_FFF335CC mov.l   #8AC30h, r14; SDHI.SDRSP76
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
FFF335EA  fbee28ac08                        mov.l   #8AC28h, r14; SDHI.SDRSP54
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
FFF33610  fbee20ac08                        mov.l   #8AC20h, r14; SDHI.SDRSP32
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
FFF33636  fbee18ac08                        mov.l   #8AC18h, r14; SDHI.SDRSP10
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
FFF3365E  7100e8                 sub_FFF3365E add     #-18h, sp, sp   ; <<<< FUNC sub_FFF3365E
FFF33661  9289                              mov.w   r1, 18h+var_2[sp]
FFF33663  9282                              mov.w   r2, 18h+var_4[sp]
FFF33665  a103                              mov.l   r3, 18h+var_8[sp]
FFF33667  ba89                              movu.w  18h+var_2[sp], r1
FFF33669  398afb                            bsr.w   sub_FFF331F3
FFF3366C  ba81                              movu.w  18h+var_4[sp], r1
FFF3366E  3992fb                            bsr.w   sub_FFF33200
FFF33671  ba81                              movu.w  18h+var_4[sp], r1
FFF33673  6111                              cmp     #1, r1
FFF33675  1f                                bne.s   loc_FFF3367C
FFF33676  6601                              mov.l   #0, r1
FFF33678  3995fb                            bsr.w   sub_FFF3320D
FFF3367B  08                                bra.s   loc_FFF33683
FFF3367C  fb1a0001               loc_FFF3367C mov.l   #100h, r1
FFF33680  398dfb                            bsr.w   sub_FFF3320D
FFF33683  3e0100                 loc_FFF33683 mov.l   #0, 18h+var_14[sp]
FFF33686  2e1c                              bra.b   loc_FFF336A2
FFF33688  a904                   loc_FFF33688 mov.l   18h+var_8[sp], r4
FFF3368A  ba8b                              movu.w  18h+var_2[sp], r3
FFF3368C  6602                              mov.l   #0, r2
FFF3368E  754110                            mov.l   #10h, r1
FFF33691  39a7fe                            bsr.w   sub_FFF33538
FFF33694  a081                              mov.l   r1, 18h+var_10[sp]
FFF33696  a881                              mov.l   18h+var_10[sp], r1
FFF33698  6101                              cmp     #0, r1
FFF3369A  200e                              beq.b   loc_FFF336A8
FFF3369C  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF3369F  3e0101                            mov.l   #1, 18h+var_14[sp]
FFF336A2  a809                   loc_FFF336A2 mov.l   18h+var_14[sp], r1
FFF336A4  6131                              cmp     #3, r1
FFF336A6  29e2                              blt.b   loc_FFF33688
FFF336A8  a809                   loc_FFF336A8 mov.l   18h+var_14[sp], r1
FFF336AA  6131                              cmp     #3, r1
FFF336AC  2907                              blt.b   loc_FFF336B3
FFF336AE  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF336B1  2e25                              bra.b   loc_FFF336D6
FFF336B3  a902                   loc_FFF336B3 mov.l   18h+var_8[sp], r2
FFF336B5  6611                              mov.l   #1, r1
FFF336B7  39a3fe                            bsr.w   sub_FFF3355A
FFF336BA  a901                              mov.l   18h+var_8[sp], r1
FFF336BC  5e1e6301                          movu.w  2C6h[r1], r14
FFF336C0  fbf2307fedff                      mov.l   #unk_FFED7F30, r15
FFF336C6  fe6efe                            mov.l   [r14, r15], r14
FFF336C9  06a10c1eac                        tst     2B0h[r1].l, r14
FFF336CE  15                                beq.s   loc_FFF336D3
FFF336CF  f806e9                            mov.l   #-17h, 18h+var_18[sp]
FFF336D2  0c                                bra.s   loc_FFF336D6
FFF336D3  f80600                 loc_FFF336D3 mov.l   #0, 18h+var_18[sp]
FFF336D6  ec01                   loc_FFF336D6 mov.l   18h+var_18[sp], r1
FFF336D8  a089                              mov.l   r1, 18h+var_C[sp]
FFF336DA  6706                              rtsd    #6
FFF336DC  7100ec                 sub_FFF336DC add     #-14h, sp, sp   ; <<<< FUNC sub_FFF336DC
FFF336DF  a101                              mov.l   r1, 14h+var_4[sp]
FFF336E1  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF336E4  2e1b                              bra.b   loc_FFF336FF
FFF336E6  a904                   loc_FFF336E6 mov.l   14h+var_4[sp], r4
FFF336E8  6602                              mov.l   #0, r2
FFF336EA  66c1                              mov.l   #0Ch, r1
FFF336EC  ef23                              mov.l   r2, r3
FFF336EE  394afe                            bsr.w   sub_FFF33538
FFF336F1  a081                              mov.l   r1, 14h+var_C[sp]
FFF336F3  a881                              mov.l   14h+var_C[sp], r1
FFF336F5  6101                              cmp     #0, r1
FFF336F7  200e                              beq.b   loc_FFF33705
FFF336F9  a809                              mov.l   14h+var_10[sp], r1
FFF336FB  6211                              add     #1, r1
FFF336FD  a009                              mov.l   r1, 14h+var_10[sp]
FFF336FF  a809                   loc_FFF336FF mov.l   14h+var_10[sp], r1
FFF33701  6131                              cmp     #3, r1
FFF33703  29e3                              blt.b   loc_FFF336E6
FFF33705  a809                   loc_FFF33705 mov.l   14h+var_10[sp], r1
FFF33707  6131                              cmp     #3, r1
FFF33709  2907                              blt.b   loc_FFF33710
FFF3370B  f806f7                            mov.l   #-9, 14h+var_14[sp]
FFF3370E  2e25                              bra.b   loc_FFF33733
FFF33710  a902                   loc_FFF33710 mov.l   14h+var_4[sp], r2
FFF33712  6611                              mov.l   #1, r1
FFF33714  3946fe                            bsr.w   sub_FFF3355A
FFF33717  a901                              mov.l   14h+var_4[sp], r1
FFF33719  5e1e6301                          movu.w  2C6h[r1], r14
FFF3371D  fbf2207fedff                      mov.l   #unk_FFED7F20, r15
FFF33723  fe6efe                            mov.l   [r14, r15], r14
FFF33726  06a10c1eac                        tst     2B0h[r1].l, r14
FFF3372B  15                                beq.s   loc_FFF33730
FFF3372C  f806f7                            mov.l   #-9, 14h+var_14[sp]
FFF3372F  0c                                bra.s   loc_FFF33733
FFF33730  f80600                 loc_FFF33730 mov.l   #0, 14h+var_14[sp]
FFF33733  ec01                   loc_FFF33733 mov.l   14h+var_14[sp], r1
FFF33735  a089                              mov.l   r1, 14h+var_8[sp]
FFF33737  6705                              rtsd    #5
FFF33739  6080                   sub_FFF33739 sub     #8, sp   ; <<<< FUNC sub_FFF33739
FFF3373B  fbee48ac08                        mov.l   #8AC48h, r14; SDHI.SDCLKCR
FFF33740  e4e001                            mov.l   [r14], 8+var_4[sp]
FFF33743  fbee50ac08                        mov.l   #8AC50h, r14; SDHI.SDOPT
FFF33748  e0e0                              mov.l   [r14], 8+var_8[sp]
FFF3374A  6621                              mov.l   #2, r1
FFF3374C  391ffb                            bsr.w   sub_FFF3326B
FFF3374F  fbee48ac08                        mov.l   #8AC48h, r14; SDHI.SDCLKCR
FFF33754  e10e01                            mov.l   8+var_4[sp], [r14]
FFF33757  fbee50ac08                        mov.l   #8AC50h, r14; SDHI.SDOPT
FFF3375C  e00e                              mov.l   8+var_8[sp], [r14]
FFF3375E  6702                              rtsd    #2
FFF33760  7100e4                 sub_FFF33760 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF33760
FFF33763  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF33765  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF33767  920b                              mov.w   r3, 1Ch+var_A[sp]
FFF33769  a08c                              mov.l   r4, 1Ch+var_10[sp]
FFF3376B  ba09                              movu.w  1Ch+var_A[sp], r1
FFF3376D  6121                              cmp     #2, r1
FFF3376F  a90a                              mov.l   1Ch+var_8[sp], r2
FFF33771  a981                              mov.l   1Ch+var_4[sp], r1
FFF33773  214a                              bne.b   loc_FFF337BD
FFF33775  a88c                              mov.l   1Ch+var_10[sp], r4
FFF33777  6613                              mov.l   #1, r3
FFF33779  395e00                            bsr.w   sub_FFF337D7
FFF3377C  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF3377E  a809                              mov.l   1Ch+var_18[sp], r1
FFF33780  6101                              cmp     #0, r1
FFF33782  11                                beq.s   loc_FFF3378B
FFF33783  39b6ff                            bsr.w   sub_FFF33739
FFF33786  e10001                            mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF33789  2e48                              bra.b   loc_FFF337D1
FFF3378B  a889                   loc_FFF3378B mov.l   1Ch+var_10[sp], r1
FFF3378D  5e1e6001                          movu.w  2C0h[r1], r14
FFF33791  612e                              cmp     #2, r14
FFF33793  a981                              mov.l   1Ch+var_4[sp], r1
FFF33795  1e                                bne.s   loc_FFF3379B
FFF33796  6211                              add     #1, r1
FFF33798  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF3379A  0f                                bra.s   loc_FFF337A1
FFF3379B  72110002               loc_FFF3379B add     #200h, r1, r1
FFF3379F  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF337A1  a88c                   loc_FFF337A1 mov.l   1Ch+var_10[sp], r4
FFF337A3  a90a                              mov.l   1Ch+var_8[sp], r2
FFF337A5  a981                              mov.l   1Ch+var_4[sp], r1
FFF337A7  72220002                          add     #200h, r2, r2
FFF337AB  6613                              mov.l   #1, r3
FFF337AD  392a00                            bsr.w   sub_FFF337D7
FFF337B0  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF337B2  a809                              mov.l   1Ch+var_18[sp], r1
FFF337B4  6101                              cmp     #0, r1
FFF337B6  2018                              beq.b   loc_FFF337CE
FFF337B8  3981ff                            bsr.w   sub_FFF33739
FFF337BB  2e13                              bra.b   loc_FFF337CE
FFF337BD  a88c                   loc_FFF337BD mov.l   1Ch+var_10[sp], r4
FFF337BF  ba0b                              movu.w  1Ch+var_A[sp], r3
FFF337C1  391600                            bsr.w   sub_FFF337D7
FFF337C4  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF337C6  a809                              mov.l   1Ch+var_18[sp], r1
FFF337C8  6101                              cmp     #0, r1
FFF337CA  14                                beq.s   loc_FFF337CE
FFF337CB  396eff                            bsr.w   sub_FFF33739
FFF337CE  e10001                 loc_FFF337CE mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF337D1  ec01                   loc_FFF337D1 mov.l   1Ch+var_1C[sp], r1
FFF337D3  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF337D5  6707                              rtsd    #7
FFF337D7  7100dc                 sub_FFF337D7 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF337D7
FFF337DA  a201                              mov.l   r1, 24h+var_4[sp]
FFF337DC  a18a                              mov.l   r2, 24h+var_8[sp]
FFF337DE  930b                              mov.w   r3, 24h+var_A[sp]
FFF337E0  a10c                              mov.l   r4, 24h+var_10[sp]
FFF337E2  e5000701                          mov.l   24h+var_8[sp], 24h+var_20[sp]
FFF337E6  a90b                              mov.l   24h+var_10[sp], r3
FFF337E8  bb0a                              movu.w  24h+var_A[sp], r2
FFF337EA  fb1a0002                          mov.l   #200h, r1
FFF337EE  3970fe                            bsr.w   sub_FFF3365E
FFF337F1  a089                              mov.l   r1, 24h+var_18[sp]
FFF337F3  a889                              mov.l   24h+var_18[sp], r1
FFF337F5  6101                              cmp     #0, r1
FFF337F7  17                                beq.s   loc_FFF337FE
FFF337F8  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF337FB  38d600                            bra.w   loc_FFF338D1
FFF337FE  fbee44ac08             loc_FFF337FE mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF33803  ecef                              mov.l   [r14], r15
FFF33805  7a8f                              bclr    #8, r15
FFF33807  e3ef                              mov.l   r15, [r14]
FFF33809  bb09                              movu.w  24h+var_A[sp], r1
FFF3380B  3e0200                            mov.l   #0, 24h+var_1C[sp]
FFF3380E  6111                              cmp     #1, r1
FFF33810  201e                              beq.b   loc_FFF3382E
FFF33812  2e3e                              bra.b   loc_FFF33850
FFF33814  a90c                   loc_FFF33814 mov.l   24h+var_10[sp], r4
FFF33816  aa03                              mov.l   24h+var_4[sp], r3
FFF33818  6602                              mov.l   #0, r2
FFF3381A  754111                            mov.l   #11h, r1
FFF3381D  391bfd                            bsr.w   sub_FFF33538
FFF33820  a089                              mov.l   r1, 24h+var_18[sp]
FFF33822  a889                              mov.l   24h+var_18[sp], r1
FFF33824  6101                              cmp     #0, r1
FFF33826  2030                              beq.b   loc_FFF33856
FFF33828  a881                              mov.l   24h+var_1C[sp], r1
FFF3382A  6211                              add     #1, r1
FFF3382C  a081                              mov.l   r1, 24h+var_1C[sp]
FFF3382E  a881                   loc_FFF3382E mov.l   24h+var_1C[sp], r1
FFF33830  6131                              cmp     #3, r1
FFF33832  29e2                              blt.b   loc_FFF33814
FFF33834  2e22                              bra.b   loc_FFF33856
FFF33836  a90c                   loc_FFF33836 mov.l   24h+var_10[sp], r4
FFF33838  aa03                              mov.l   24h+var_4[sp], r3
FFF3383A  6602                              mov.l   #0, r2
FFF3383C  754112                            mov.l   #12h, r1
FFF3383F  39f9fc                            bsr.w   sub_FFF33538
FFF33842  a089                              mov.l   r1, 24h+var_18[sp]
FFF33844  a889                              mov.l   24h+var_18[sp], r1
FFF33846  6101                              cmp     #0, r1
FFF33848  200e                              beq.b   loc_FFF33856
FFF3384A  a881                              mov.l   24h+var_1C[sp], r1
FFF3384C  6211                              add     #1, r1
FFF3384E  a081                              mov.l   r1, 24h+var_1C[sp]
FFF33850  a881                   loc_FFF33850 mov.l   24h+var_1C[sp], r1
FFF33852  6131                              cmp     #3, r1
FFF33854  29e2                              blt.b   loc_FFF33836
FFF33856  a881                   loc_FFF33856 mov.l   24h+var_1C[sp], r1
FFF33858  6131                              cmp     #3, r1
FFF3385A  2907                              blt.b   loc_FFF33861
FFF3385C  f806f7                            mov.l   #-9, 24h+var_24[sp]
FFF3385F  2e72                              bra.b   loc_FFF338D1
FFF33861  a90a                   loc_FFF33861 mov.l   24h+var_10[sp], r2
FFF33863  6611                              mov.l   #1, r1
FFF33865  39f5fc                            bsr.w   sub_FFF3355A
FFF33868  a909                              mov.l   24h+var_10[sp], r1
FFF3386A  5e1e6301                          movu.w  2C6h[r1], r14
FFF3386E  fbf2387fedff                      mov.l   #unk_FFED7F38, r15
FFF33874  fe6efe                            mov.l   [r14, r15], r14
FFF33877  06a10c1eac                        tst     2B0h[r1].l, r14
FFF3387C  16                                beq.s   loc_FFF33882
FFF3387D  f806ea                            mov.l   #-16h, 24h+var_24[sp]
FFF33880  2e51                              bra.b   loc_FFF338D1
FFF33882  bb0a                   loc_FFF33882 movu.w  24h+var_A[sp], r2
FFF33884  a809                              mov.l   24h+var_20[sp], r1
FFF33886  39e8f7                            bsr.w   sub_FFF3306E
FFF33889  a089                              mov.l   r1, 24h+var_18[sp]
FFF3388B  a889                              mov.l   24h+var_18[sp], r1
FFF3388D  6101                              cmp     #0, r1
FFF3388F  201d                              beq.b   loc_FFF338AC
FFF33891  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF33896  ecef                              mov.l   [r14], r15
FFF33898  788f                              bset    #8, r15
FFF3389A  e3ef                              mov.l   r15, [r14]
FFF3389C  fbeeb0ad08                        mov.l   #8ADB0h, r14; SDHI.SDDMAEN
FFF338A1  ecef                              mov.l   [r14], r15
FFF338A3  7a1f                              bclr    #1, r15
FFF338A5  e3ef                              mov.l   r15, [r14]
FFF338A7  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF338AA  2e27                              bra.b   loc_FFF338D1
FFF338AC  fbee44ac08             loc_FFF338AC mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF338B1  ecef                              mov.l   [r14], r15
FFF338B3  788f                              bset    #8, r15
FFF338B5  e3ef                              mov.l   r15, [r14]
FFF338B7  fbeeb0ad08                        mov.l   #8ADB0h, r14; SDHI.SDDMAEN
FFF338BC  ecef                              mov.l   [r14], r15
FFF338BE  7a1f                              bclr    #1, r15
FFF338C0  e3ef                              mov.l   r15, [r14]
FFF338C2  6621                              mov.l   #2, r1
FFF338C4  390dfa                            bsr.w   sub_FFF332D1
FFF338C7  6101                              cmp     #0, r1
FFF338C9  15                                beq.s   loc_FFF338CE
FFF338CA  f806ff                            mov.l   #-1, 24h+var_24[sp]
FFF338CD  0c                                bra.s   loc_FFF338D1
FFF338CE  f80600                 loc_FFF338CE mov.l   #0, 24h+var_24[sp]
FFF338D1  ec01                   loc_FFF338D1 mov.l   24h+var_24[sp], r1
FFF338D3  a101                              mov.l   r1, 24h+var_14[sp]
FFF338D5  6709                              rtsd    #9
FFF338D7  7100e4                 sub_FFF338D7 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF338D7
FFF338DA  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF338DC  928a                              mov.w   r2, 1Ch+var_6[sp]
FFF338DE  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF338E1  e5000601                          mov.l   1Ch+var_4[sp], 1Ch+var_18[sp]
FFF338E5  3e0300                            mov.l   #0, 1Ch+var_10[sp]
FFF338E8  2e45                              bra.b   loc_FFF3392D
FFF338EA  fbee60ac08             loc_FFF338EA mov.l   #8AC60h, r14; SDHI.SDBUFR
FFF338EF  e0e0                              mov.l   [r14], 1Ch+var_1C[sp]
FFF338F1  ec01                              mov.l   1Ch+var_1C[sp], r1
FFF338F3  a80a                              mov.l   1Ch+var_18[sp], r2
FFF338F5  c321                              mov.b   r1, [r2]
FFF338F7  a809                              mov.l   1Ch+var_18[sp], r1
FFF338F9  6211                              add     #1, r1
FFF338FB  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF338FD  ec01                              mov.l   1Ch+var_1C[sp], r1
FFF338FF  6881                              shlr    #8, r1
FFF33901  a80a                              mov.l   1Ch+var_18[sp], r2
FFF33903  c321                              mov.b   r1, [r2]
FFF33905  a809                              mov.l   1Ch+var_18[sp], r1
FFF33907  6211                              add     #1, r1
FFF33909  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF3390B  ec01                              mov.l   1Ch+var_1C[sp], r1
FFF3390D  6901                              shlr    #10h, r1
FFF3390F  a80a                              mov.l   1Ch+var_18[sp], r2
FFF33911  c321                              mov.b   r1, [r2]
FFF33913  a809                              mov.l   1Ch+var_18[sp], r1
FFF33915  6211                              add     #1, r1
FFF33917  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF33919  ec01                              mov.l   1Ch+var_1C[sp], r1
FFF3391B  6981                              shlr    #18h, r1
FFF3391D  a80a                              mov.l   1Ch+var_18[sp], r2
FFF3391F  c321                              mov.b   r1, [r2]
FFF33921  a809                              mov.l   1Ch+var_18[sp], r1
FFF33923  6211                              add     #1, r1
FFF33925  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF33927  a889                              mov.l   1Ch+var_10[sp], r1
FFF33929  6211                              add     #1, r1
FFF3392B  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF3392D  ba89                   loc_FFF3392D movu.w  1Ch+var_6[sp], r1
FFF3392F  6821                              shlr    #2, r1
FFF33931  06850103                          cmp     1Ch+var_10[sp].l, r1
FFF33935  2ab5                              bgt.b   loc_FFF338EA
FFF33937  a881                              mov.l   1Ch+var_14[sp], r1
FFF33939  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF3393B  6707                              rtsd    #7
FFF3393D  7100e8                 sub_FFF3393D add     #-18h, sp, sp   ; <<<< FUNC sub_FFF3393D
FFF33940  a109                              mov.l   r1, 18h+var_4[sp]
FFF33942  a102                              mov.l   r2, 18h+var_8[sp]
FFF33944  918b                              mov.w   r3, 18h+var_A[sp]
FFF33946  a084                              mov.l   r4, 18h+var_10[sp]
FFF33948  b98b                              movu.w  18h+var_A[sp], r3
FFF3394A  a902                              mov.l   18h+var_8[sp], r2
FFF3394C  a909                              mov.l   18h+var_4[sp], r1
FFF3394E  391300                            bsr.w   sub_FFF33961
FFF33951  e301                              mov.l   r1, 18h+var_18[sp]
FFF33953  ec01                              mov.l   18h+var_18[sp], r1
FFF33955  6101                              cmp     #0, r1
FFF33957  14                                beq.s   loc_FFF3395B
FFF33958  39e1fd                            bsr.w   sub_FFF33739
FFF3395B  ec01                   loc_FFF3395B mov.l   18h+var_18[sp], r1
FFF3395D  a009                              mov.l   r1, 18h+var_14[sp]
FFF3395F  6706                              rtsd    #6
FFF33961  7100dc                 sub_FFF33961 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF33961
FFF33964  a201                              mov.l   r1, 24h+var_4[sp]
FFF33966  a18a                              mov.l   r2, 24h+var_8[sp]
FFF33968  930b                              mov.w   r3, 24h+var_A[sp]
FFF3396A  a10c                              mov.l   r4, 24h+var_10[sp]
FFF3396C  e5000701                          mov.l   24h+var_8[sp], 24h+var_20[sp]
FFF33970  a90b                              mov.l   24h+var_10[sp], r3
FFF33972  bb0a                              movu.w  24h+var_A[sp], r2
FFF33974  fb1a0002                          mov.l   #200h, r1
FFF33978  39e6fc                            bsr.w   sub_FFF3365E
FFF3397B  a089                              mov.l   r1, 24h+var_18[sp]
FFF3397D  a889                              mov.l   24h+var_18[sp], r1
FFF3397F  6101                              cmp     #0, r1
FFF33981  17                                beq.s   loc_FFF33988
FFF33982  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF33985  38d600                            bra.w   loc_FFF33A5B
FFF33988  fbee44ac08             loc_FFF33988 mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF3398D  ecef                              mov.l   [r14], r15
FFF3398F  7a9f                              bclr    #9, r15
FFF33991  e3ef                              mov.l   r15, [r14]
FFF33993  bb09                              movu.w  24h+var_A[sp], r1
FFF33995  3e0200                            mov.l   #0, 24h+var_1C[sp]
FFF33998  6111                              cmp     #1, r1
FFF3399A  201e                              beq.b   loc_FFF339B8
FFF3399C  2e3e                              bra.b   loc_FFF339DA
FFF3399E  a90c                   loc_FFF3399E mov.l   24h+var_10[sp], r4
FFF339A0  aa03                              mov.l   24h+var_4[sp], r3
FFF339A2  6602                              mov.l   #0, r2
FFF339A4  754118                            mov.l   #18h, r1
FFF339A7  3991fb                            bsr.w   sub_FFF33538
FFF339AA  a089                              mov.l   r1, 24h+var_18[sp]
FFF339AC  a889                              mov.l   24h+var_18[sp], r1
FFF339AE  6101                              cmp     #0, r1
FFF339B0  2030                              beq.b   loc_FFF339E0
FFF339B2  a881                              mov.l   24h+var_1C[sp], r1
FFF339B4  6211                              add     #1, r1
FFF339B6  a081                              mov.l   r1, 24h+var_1C[sp]
FFF339B8  a881                   loc_FFF339B8 mov.l   24h+var_1C[sp], r1
FFF339BA  6131                              cmp     #3, r1
FFF339BC  29e2                              blt.b   loc_FFF3399E
FFF339BE  2e22                              bra.b   loc_FFF339E0
FFF339C0  a90c                   loc_FFF339C0 mov.l   24h+var_10[sp], r4
FFF339C2  aa03                              mov.l   24h+var_4[sp], r3
FFF339C4  6602                              mov.l   #0, r2
FFF339C6  754119                            mov.l   #19h, r1
FFF339C9  396ffb                            bsr.w   sub_FFF33538
FFF339CC  a089                              mov.l   r1, 24h+var_18[sp]
FFF339CE  a889                              mov.l   24h+var_18[sp], r1
FFF339D0  6101                              cmp     #0, r1
FFF339D2  200e                              beq.b   loc_FFF339E0
FFF339D4  a881                              mov.l   24h+var_1C[sp], r1
FFF339D6  6211                              add     #1, r1
FFF339D8  a081                              mov.l   r1, 24h+var_1C[sp]
FFF339DA  a881                   loc_FFF339DA mov.l   24h+var_1C[sp], r1
FFF339DC  6131                              cmp     #3, r1
FFF339DE  29e2                              blt.b   loc_FFF339C0
FFF339E0  a881                   loc_FFF339E0 mov.l   24h+var_1C[sp], r1
FFF339E2  6131                              cmp     #3, r1
FFF339E4  2907                              blt.b   loc_FFF339EB
FFF339E6  f806f7                            mov.l   #-9, 24h+var_24[sp]
FFF339E9  2e72                              bra.b   loc_FFF33A5B
FFF339EB  a90a                   loc_FFF339EB mov.l   24h+var_10[sp], r2
FFF339ED  6611                              mov.l   #1, r1
FFF339EF  396bfb                            bsr.w   sub_FFF3355A
FFF339F2  a909                              mov.l   24h+var_10[sp], r1
FFF339F4  5e1e6301                          movu.w  2C6h[r1], r14
FFF339F8  fbf2487fedff                      mov.l   #unk_FFED7F48, r15
FFF339FE  fe6efe                            mov.l   [r14, r15], r14
FFF33A01  06a10c1eac                        tst     2B0h[r1].l, r14
FFF33A06  16                                beq.s   loc_FFF33A0C
FFF33A07  f806eb                            mov.l   #-15h, 24h+var_24[sp]
FFF33A0A  2e51                              bra.b   loc_FFF33A5B
FFF33A0C  bb0a                   loc_FFF33A0C movu.w  24h+var_A[sp], r2
FFF33A0E  a809                              mov.l   24h+var_20[sp], r1
FFF33A10  39b8f6                            bsr.w   sub_FFF330C8
FFF33A13  a089                              mov.l   r1, 24h+var_18[sp]
FFF33A15  a889                              mov.l   24h+var_18[sp], r1
FFF33A17  6101                              cmp     #0, r1
FFF33A19  201d                              beq.b   loc_FFF33A36
FFF33A1B  fbee44ac08                        mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF33A20  ecef                              mov.l   [r14], r15
FFF33A22  789f                              bset    #9, r15
FFF33A24  e3ef                              mov.l   r15, [r14]
FFF33A26  fbeeb0ad08                        mov.l   #8ADB0h, r14; SDHI.SDDMAEN
FFF33A2B  ecef                              mov.l   [r14], r15
FFF33A2D  7a1f                              bclr    #1, r15
FFF33A2F  e3ef                              mov.l   r15, [r14]
FFF33A31  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF33A34  2e27                              bra.b   loc_FFF33A5B
FFF33A36  fbee44ac08             loc_FFF33A36 mov.l   #8AC44h, r14; SDHI.SDIMSK2
FFF33A3B  ecef                              mov.l   [r14], r15
FFF33A3D  789f                              bset    #9, r15
FFF33A3F  e3ef                              mov.l   r15, [r14]
FFF33A41  fbeeb0ad08                        mov.l   #8ADB0h, r14; SDHI.SDDMAEN
FFF33A46  ecef                              mov.l   [r14], r15
FFF33A48  7a1f                              bclr    #1, r15
FFF33A4A  e3ef                              mov.l   r15, [r14]
FFF33A4C  6621                              mov.l   #2, r1
FFF33A4E  3983f8                            bsr.w   sub_FFF332D1
FFF33A51  6101                              cmp     #0, r1
FFF33A53  15                                beq.s   loc_FFF33A58
FFF33A54  f806ff                            mov.l   #-1, 24h+var_24[sp]
FFF33A57  0c                                bra.s   loc_FFF33A5B
FFF33A58  f80600                 loc_FFF33A58 mov.l   #0, 24h+var_24[sp]
FFF33A5B  ec01                   loc_FFF33A5B mov.l   24h+var_24[sp], r1
FFF33A5D  a101                              mov.l   r1, 24h+var_14[sp]
FFF33A5F  6709                              rtsd    #9
FFF33A61  60c0                   sub_FFF33A61 sub     #0Ch, sp   ; <<<< FUNC sub_FFF33A61
FFF33A63  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF33A66  0559f2ff                          bsr.a   sub_FFF32CBF
FFF33A6A  6621                              mov.l   #2, r1
FFF33A6C  39fff7                            bsr.w   sub_FFF3326B
FFF33A6F  0547f2ff                          bsr.a   sub_FFF32CB6
FFF33A73  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF33A75  a809                              mov.l   0Ch+var_8[sp], r1
FFF33A77  6101                              cmp     #0, r1
FFF33A79  16                                beq.s   loc_FFF33A7F
FFF33A7A  e10001                            mov.l   0Ch+var_8[sp], 0Ch+var_C[sp]
FFF33A7D  2e24                              bra.b   loc_FFF33AA1
FFF33A7F  0569f5ff               loc_FFF33A7F bsr.a   sub_FFF32FE8
FFF33A83  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF33A85  a809                              mov.l   0Ch+var_8[sp], r1
FFF33A87  6101                              cmp     #0, r1
FFF33A89  16                                beq.s   loc_FFF33A8F
FFF33A8A  e10001                            mov.l   0Ch+var_8[sp], 0Ch+var_C[sp]
FFF33A8D  2e14                              bra.b   loc_FFF33AA1
FFF33A8F  057af3ff               loc_FFF33A8F bsr.a   sub_FFF32E09
FFF33A93  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF33A95  a809                              mov.l   0Ch+var_8[sp], r1
FFF33A97  6101                              cmp     #0, r1
FFF33A99  15                                beq.s   loc_FFF33A9E
FFF33A9A  e10001                            mov.l   0Ch+var_8[sp], 0Ch+var_C[sp]
FFF33A9D  0c                                bra.s   loc_FFF33AA1
FFF33A9E  f80600                 loc_FFF33A9E mov.l   #0, 0Ch+var_C[sp]
FFF33AA1  ec01                   loc_FFF33AA1 mov.l   0Ch+var_C[sp], r1
FFF33AA3  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF33AA5  6703                              rtsd    #3
FFF33AA7  6040                   sub_FFF33AA7 sub     #4, sp   ; <<<< FUNC sub_FFF33AA7
FFF33AA9  f80600                            mov.l   #0, 4+var_4[sp]
FFF33AAC  0509f2ff                          bsr.a   sub_FFF32CB5
FFF33AB0  fbee3cac08                        mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF33AB5  e0e0                              mov.l   [r14], 4+var_4[sp]
FFF33AB7  ec01                              mov.l   4+var_4[sp], r1
FFF33AB9  76210001                          and     #100h, r1
FFF33ABD  76010001                          cmp     #100h, r1
FFF33AC1  210d                              bne.b   loc_FFF33ACE
FFF33AC3  fbee3cac08                        mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF33AC8  f8eafffe                          mov.l   #-101h, [r14]
FFF33ACC  6701                              rtsd    #1
FFF33ACE  ec01                   loc_FFF33ACE mov.l   4+var_4[sp], r1
FFF33AD0  76210002                          and     #200h, r1
FFF33AD4  76010002                          cmp     #200h, r1
FFF33AD8  210d                              bne.b   loc_FFF33AE5
FFF33ADA  fbee3cac08                        mov.l   #8AC3Ch, r14; SDHI.SDSTS2
FFF33ADF  f8eafffd                          mov.l   #-201h, [r14]
FFF33AE3  6701                              rtsd    #1
FFF33AE5  6701                   loc_FFF33AE5 rtsd    #1
FFF33AE7  7100e4                 sub_FFF33AE7 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF33AE7
FFF33AEA  fb3244740600                      mov.l   #67444h, r3
FFF33AF0  6652                              mov.l   #5, r2
FFF33AF2  fb123c5e0600                      mov.l   #65E3Ch, r1
FFF33AF8  ef24                              mov.l   r2, r4
FFF33AFA  051b15ff                          bsr.a   sub_FFF25015
FFF33AFE  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF33B00  a909                              mov.l   1Ch+var_8[sp], r1
FFF33B02  6101                              cmp     #0, r1
FFF33B04  16                                beq.s   loc_FFF33B0A
FFF33B05  e10005                            mov.l   1Ch+var_8[sp], 1Ch+var_1C[sp]
FFF33B08  2e77                              bra.b   loc_FFF33B7F
FFF33B0A  3c8300                 loc_FFF33B0A mov.b   #0, 1Ch+var_9[sp]
FFF33B0D  2e3e                              bra.b   loc_FFF33B4B
FFF33B0F  b489                   loc_FFF33B0F movu.b  1Ch+var_9[sp], r1
FFF33B11  ef1e                              mov.l   r1, r14
FFF33B13  761e9632                          mul     #3296h, r14
FFF33B17  fbf2978f0000                      mov.l   #8F97h, r15
FFF33B1D  4bef                              add     r14, r15
FFF33B1F  710e0c                            add     #1Ch+var_10, sp, r14
FFF33B22  fe21ef                            mov.l   r15, [r1, r14]
FFF33B25  b489                              movu.b  1Ch+var_9[sp], r1
FFF33B27  ef1e                              mov.l   r1, r14
FFF33B29  761e0041                          mul     #4100h, r14
FFF33B2D  fbf22dc20000                      mov.l   #0C22Dh, r15
FFF33B33  4bef                              add     r14, r15
FFF33B35  710e08                            add     #1Ch+var_14, sp, r14
FFF33B38  fe21ef                            mov.l   r15, [r1, r14]
FFF33B3B  b489                              movu.b  1Ch+var_9[sp], r1
FFF33B3D  710e04                            add     #1Ch+var_18, sp, r14
FFF33B40  660f                              mov.l   #0, r15
FFF33B42  fe21ef                            mov.l   r15, [r1, r14]
FFF33B45  b489                              movu.b  1Ch+var_9[sp], r1
FFF33B47  6211                              add     #1, r1
FFF33B49  8489                              mov.b   r1, 1Ch+var_9[sp]
FFF33B4B  b489                   loc_FFF33B4B movu.b  1Ch+var_9[sp], r1
FFF33B4D  6101                              cmp     #0, r1
FFF33B4F  2bc0                              ble.b   loc_FFF33B0F
FFF33B51  a809                              mov.l   1Ch+var_18[sp], r1
FFF33B53  a882                              mov.l   1Ch+var_14[sp], r2
FFF33B55  a88c                              mov.l   1Ch+var_10[sp], r4
FFF33B57  6080                              sub     #8, sp
FFF33B59  a009                              mov.l   r1, 24h+var_20[sp]
FFF33B5B  e302                              mov.l   r2, 24h+var_24[sp]
FFF33B5D  fb32562cf3ff                      mov.l   #sub_FFF32C56, r3
FFF33B63  754249                            mov.l   #49h, r2 ; 'I'
FFF33B66  fb12c07f0600                      mov.l   #67FC0h, r1
FFF33B6C  391900                            bsr.w   sub_FFF33B85
FFF33B6F  6280                              add     #8, sp
FFF33B71  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF33B73  a909                              mov.l   1Ch+var_8[sp], r1
FFF33B75  6101                              cmp     #0, r1
FFF33B77  15                                beq.s   loc_FFF33B7C
FFF33B78  e10005                            mov.l   1Ch+var_8[sp], 1Ch+var_1C[sp]
FFF33B7B  0c                                bra.s   loc_FFF33B7F
FFF33B7C  f80600                 loc_FFF33B7C mov.l   #0, 1Ch+var_1C[sp]
FFF33B7F  ec01                   loc_FFF33B7F mov.l   1Ch+var_1C[sp], r1
FFF33B81  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF33B83  6707                              rtsd    #7
FFF33B85  7100dc                 sub_FFF33B85 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF33B85
FFF33B88  a201                              mov.l   r1, 24h+var_4[sp]
FFF33B8A  878a                              mov.b   r2, 24h+var_5[sp]
FFF33B8C  a183                              mov.l   r3, 24h+var_C[sp]
FFF33B8E  a10c                              mov.l   r4, 24h+var_10[sp]
FFF33B90  e5000a04                          mov.l   24h+arg_0[sp], 24h+var_14[sp]
FFF33B94  e5000b03                          mov.l   24h+arg_4[sp], 24h+var_18[sp]
FFF33B98  a983                              mov.l   24h+var_C[sp], r3
FFF33B9A  8f8a                              mov.b   24h+var_5[sp], r2
FFF33B9C  aa01                              mov.l   24h+var_4[sp], r1
FFF33B9E  6080                              sub     #8, sp
FFF33BA0  f90a010002                        mov.l   #200h, 2Ch+var_28[sp]
FFF33BA5  f80401                            mov.b   #1, 2Ch+var_2C[sp]
FFF33BA8  6604                              mov.l   #0, r4
FFF33BAA  059c15ff                          bsr.a   sub_FFF25146
FFF33BAE  6280                              add     #8, sp
FFF33BB0  a009                              mov.l   r1, 24h+var_20[sp]
FFF33BB2  a809                              mov.l   24h+var_20[sp], r1
FFF33BB4  6101                              cmp     #0, r1
FFF33BB6  16                                beq.s   loc_FFF33BBC
FFF33BB7  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF33BBA  2e38                              bra.b   loc_FFF33BF2
FFF33BBC  a90a                   loc_FFF33BBC mov.l   24h+var_10[sp], r2
FFF33BBE  aa01                              mov.l   24h+var_4[sp], r1
FFF33BC0  6654                              mov.l   #5, r4
FFF33BC2  fb3a9632                          mov.l   #3296h, r3
FFF33BC6  053f86fe                          bsr.a   sub_FFF1C205
FFF33BCA  a009                              mov.l   r1, 24h+var_20[sp]
FFF33BCC  a809                              mov.l   24h+var_20[sp], r1
FFF33BCE  6101                              cmp     #0, r1
FFF33BD0  16                                beq.s   loc_FFF33BD6
FFF33BD1  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF33BD4  2e1e                              bra.b   loc_FFF33BF2
FFF33BD6  a902                   loc_FFF33BD6 mov.l   24h+var_14[sp], r2
FFF33BD8  aa01                              mov.l   24h+var_4[sp], r1
FFF33BDA  6684                              mov.l   #8, r4
FFF33BDC  fb3a0041                          mov.l   #4100h, r3
FFF33BE0  059989fe                          bsr.a   sub_FFF1C579
FFF33BE4  a009                              mov.l   r1, 24h+var_20[sp]
FFF33BE6  a809                              mov.l   24h+var_20[sp], r1
FFF33BE8  6101                              cmp     #0, r1
FFF33BEA  15                                beq.s   loc_FFF33BEF
FFF33BEB  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF33BEE  0c                                bra.s   loc_FFF33BF2
FFF33BEF  f80600                 loc_FFF33BEF mov.l   #0, 24h+var_24[sp]
FFF33BF2  ec01                   loc_FFF33BF2 mov.l   24h+var_24[sp], r1
FFF33BF4  a081                              mov.l   r1, 24h+var_1C[sp]
FFF33BF6  6709                              rtsd    #9
FFF33BF8  7100f0                 sub_FFF33BF8 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF33BF8
FFF33BFB  8389                              mov.b   r1, 10h+var_1[sp]
FFF33BFD  b38a                              movu.b  10h+var_1[sp], r2
FFF33BFF  751270                            mul     #70h, r2 ; 'p'
FFF33C02  fb12c07f0600                      mov.l   #67FC0h, r1
FFF33C08  4b21                              add     r2, r1
FFF33C0A  05bd8ffe                          bsr.a   sub_FFF1CBC7
FFF33C0E  a009                              mov.l   r1, 10h+var_C[sp]
FFF33C10  a809                              mov.l   10h+var_C[sp], r1
FFF33C12  6101                              cmp     #0, r1
FFF33C14  16                                beq.s   loc_FFF33C1A
FFF33C15  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF33C18  2e18                              bra.b   loc_FFF33C30
FFF33C1A  b38a                   loc_FFF33C1A movu.b  10h+var_1[sp], r2
FFF33C1C  751270                            mul     #70h, r2 ; 'p'
FFF33C1F  fb12c07f0600                      mov.l   #67FC0h, r1
FFF33C25  4b21                              add     r2, r1
FFF33C27  05f791fe                          bsr.a   sub_FFF1CE1E
FFF33C2B  a009                              mov.l   r1, 10h+var_C[sp]
FFF33C2D  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF33C30  ec01                   loc_FFF33C30 mov.l   10h+var_10[sp], r1
FFF33C32  a081                              mov.l   r1, 10h+var_8[sp]
FFF33C34  6704                              rtsd    #4
FFF33C36  fb12c07f0600           sub_FFF33C36 mov.l   #67FC0h, r1   ; <<<< FUNC sub_FFF33C36
FFF33C3C  05e291fe                          bsr.a   sub_FFF1CE1E
FFF33C40  02                                rts
FFF33C41  60c0                   sub_FFF33C41 sub     #0Ch, sp   ; <<<< FUNC sub_FFF33C41
FFF33C43  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF33C45  818a                              mov.b   r2, 0Ch+var_5[sp]
FFF33C47  a881                              mov.l   0Ch+var_4[sp], r1
FFF33C49  6101                              cmp     #0, r1
FFF33C4B  19                                bne.s   loc_FFF33C54
FFF33C4C  2e1e                              bra.b   loc_FFF33C6A
FFF33C4E  6611                   loc_FFF33C4E mov.l   #1, r1
FFF33C50  05e7efff                          bsr.a   sub_FFF32C37
FFF33C54  b189                   loc_FFF33C54 movu.b  0Ch+var_5[sp], r1
FFF33C56  0565eeff                          bsr.a   sub_FFF32ABB
FFF33C5A  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF33C5C  ec01                              mov.l   0Ch+var_C[sp], r1
FFF33C5E  6111                              cmp     #1, r1
FFF33C60  2018                              beq.b   loc_FFF33C78
FFF33C62  2eec                              bra.b   loc_FFF33C4E
FFF33C64  6611                   loc_FFF33C64 mov.l   #1, r1
FFF33C66  05d1efff                          bsr.a   sub_FFF32C37
FFF33C6A  b189                   loc_FFF33C6A movu.b  0Ch+var_5[sp], r1
FFF33C6C  054feeff                          bsr.a   sub_FFF32ABB
FFF33C70  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF33C72  ec01                              mov.l   0Ch+var_C[sp], r1
FFF33C74  6101                              cmp     #0, r1
FFF33C76  21ee                              bne.b   loc_FFF33C64
FFF33C78  6703                   loc_FFF33C78 rtsd    #3
FFF33C7A  7100f0                 sub_FFF33C7A add     #-10h, sp, sp   ; <<<< FUNC sub_FFF33C7A
FFF33C7D  a089                              mov.l   r1, 10h+var_4[sp]
FFF33C7F  a082                              mov.l   r2, 10h+var_8[sp]

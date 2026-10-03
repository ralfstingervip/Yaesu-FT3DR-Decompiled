; ==== audio_isr  FFF15A18-FFF15E80 ====
FFF15A18  6eef                     loc_FFF15A18 pushm   r14-r15
FFF15A1A  6e15                              pushm   r1-r5
FFF15A1C  7100e8                            add     #-18h, sp, sp
FFF15A1F  3c8700                            mov.b   #0, 17h[sp]
FFF15A22  3c8600                            mov.b   #0, 16h[sp]
FFF15A25  3d0a00                            mov.w   #0, 14h[sp]
FFF15A28  710214                            add     #14h, sp, r2
FFF15A2B  6601                              mov.l   #0, r1
FFF15A2D  393aff                            bsr.w   sub_FFF15967
FFF15A30  ba81                              movu.w  14h[sp], r1
FFF15A32  721100f8                          add     #-800h, r1, r1
FFF15A36  9281                              mov.w   r1, 14h[sp]
FFF15A38  9a81                              mov.w   14h[sp], r1
FFF15A3A  6c41                              shll    #4, r1
FFF15A3C  9281                              mov.w   r1, 14h[sp]
FFF15A3E  fb1278020200                      mov.l   #20278h, r1
FFF15A44  b891                              movu.w  4[r1], r1
FFF15A46  6131                              cmp     #3, r1
FFF15A48  3bd401                            bne.w   loc_FFF15C1C
FFF15A4B  fb1278020200                      mov.l   #20278h, r1
FFF15A51  5d118a                            movu.w  114h[r1], r1
FFF15A54  6121                              cmp     #2, r1
FFF15A56  3adc00                            beq.w   loc_FFF15B32
FFF15A59  6111                              cmp     #1, r1
FFF15A5B  3bc101                            bne.w   loc_FFF15C1C
FFF15A5E  fb1278020200                      mov.l   #20278h, r1
FFF15A64  5d1190                            movu.w  120h[r1], r1
FFF15A67  6101                              cmp     #0, r1
FFF15A69  3ab301                            beq.w   loc_FFF15C1C
FFF15A6C  ba81                              movu.w  14h[sp], r1
FFF15A6E  8589                              mov.b   r1, 17h[sp]
FFF15A70  ba81                              movu.w  14h[sp], r1
FFF15A72  6881                              shlr    #8, r1
FFF15A74  8581                              mov.b   r1, 16h[sp]
FFF15A76  fb1278020200                      mov.l   #20278h, r1
FFF15A7C  ed1146                            mov.l   118h[r1], r1
FFF15A7F  7701fe7f01                        cmp     #17FFEh, r1
FFF15A84  2505                              bleu.b  loc_FFF15A89
FFF15A86  389601                            bra.w   loc_FFF15C1C
FFF15A89  fb1278020200             loc_FFF15A89 mov.l   #20278h, r1
FFF15A8F  06891146                          add     118h[r1].l, r1
FFF15A93  c901172201                        mov.b   17h[sp], 122h[r1]
FFF15A98  fb1278020200                      mov.l   #20278h, r1
FFF15A9E  ed1246                            mov.l   118h[r1], r2
FFF15AA1  6212                              add     #1, r2
FFF15AA3  e71246                            mov.l   r2, 118h[r1]
FFF15AA6  fb1278020200                      mov.l   #20278h, r1
FFF15AAC  06891146                          add     118h[r1].l, r1
FFF15AB0  c901162201                        mov.b   16h[sp], 122h[r1]
FFF15AB5  fb1278020200                      mov.l   #20278h, r1
FFF15ABB  ed1246                            mov.l   118h[r1], r2
FFF15ABE  6212                              add     #1, r2
FFF15AC0  e71246                            mov.l   r2, 118h[r1]
FFF15AC3  fb1278020200                      mov.l   #20278h, r1
FFF15AC9  ed1146                            mov.l   118h[r1], r1
FFF15ACC  7701008001                        cmp     #18000h, r1
FFF15AD1  3b4b01                            bne.w   loc_FFF15C1C
FFF15AD4  f80501                            mov.w   #1, [sp]
FFF15AD7  fb1278020200                      mov.l   #20278h, r1
FFF15ADD  6261                              add     #6, r1
FFF15ADF  a009                              mov.l   r1, 4[sp]
FFF15AE1  fb1278020200                      mov.l   #20278h, r1
FFF15AE7  e5104602                          mov.l   118h[r1], 8[sp]
FFF15AEB  fb1278020200                      mov.l   #20278h, r1
FFF15AF1  72112201                          add     #122h, r1, r1
FFF15AF5  a089                              mov.l   r1, 0Ch[sp]
FFF15AF7  fb1278020200                      mov.l   #20278h, r1
FFF15AFD  f9159000                          mov.w   #0, 120h[r1]
FFF15B01  7100ec                            add     #-14h, sp, sp
FFF15B04  754314                            mov.l   #14h, r3
FFF15B07  710214                            add     #14h, sp, r2
FFF15B0A  ef01                              mov.l   sp, r1
FFF15B0C  7f8f                              smovf
FFF15B0E  056be5ff                          bsr.a   sub_FFF14079
FFF15B12  710014                            add     #14h, sp, sp
FFF15B15  fb1278020200                      mov.l   #20278h, r1
FFF15B1B  f9158a02                          mov.w   #2, 114h[r1]
FFF15B1F  fb1278020200                      mov.l   #20278h, r1
FFF15B25  f9164600                          mov.l   #0, 118h[r1]
FFF15B29  710018                            add     #18h, sp, sp
FFF15B2C  6f15                              popm    r1-r5
FFF15B2E  6fef                              popm    r14-r15
FFF15B30  7f95                              rte
FFF15B32  fb1278020200             loc_FFF15B32 mov.l   #20278h, r1
FFF15B38  5e1196c0                          movu.w  1812Ch[r1], r1
FFF15B3C  6101                              cmp     #0, r1
FFF15B3E  3ade00                            beq.w   loc_FFF15C1C
FFF15B41  ba81                              movu.w  14h[sp], r1
FFF15B43  8589                              mov.b   r1, 17h[sp]
FFF15B45  ba81                              movu.w  14h[sp], r1
FFF15B47  6881                              shlr    #8, r1
FFF15B49  8581                              mov.b   r1, 16h[sp]
FFF15B4B  fb1278020200                      mov.l   #20278h, r1
FFF15B51  ee114960                          mov.l   18124h[r1], r1
FFF15B55  7701fe7f01                        cmp     #17FFEh, r1
FFF15B5A  2505                              bleu.b  loc_FFF15B5F
FFF15B5C  38c000                            bra.w   loc_FFF15C1C
FFF15B5F  fb1278020200             loc_FFF15B5F mov.l   #20278h, r1
FFF15B65  068a114960                        add     18124h[r1].l, r1
FFF15B6A  fb2e2e8101                        mov.l   #1812Eh, r2
FFF15B6F  b58b                              movu.b  17h[sp], r3
FFF15B71  fe0123                            mov.b   r3, [r1, r2]
FFF15B74  fb1278020200                      mov.l   #20278h, r1
FFF15B7A  ee124960                          mov.l   18124h[r1], r2
FFF15B7E  6212                              add     #1, r2
FFF15B80  eb124960                          mov.l   r2, 18124h[r1]
FFF15B84  fb1278020200                      mov.l   #20278h, r1
FFF15B8A  068a114960                        add     18124h[r1].l, r1
FFF15B8F  fb2e2e8101                        mov.l   #1812Eh, r2
FFF15B94  b583                              movu.b  16h[sp], r3
FFF15B96  fe0123                            mov.b   r3, [r1, r2]
FFF15B99  fb1278020200                      mov.l   #20278h, r1
FFF15B9F  ee124960                          mov.l   18124h[r1], r2
FFF15BA3  6212                              add     #1, r2
FFF15BA5  eb124960                          mov.l   r2, 18124h[r1]
FFF15BA9  fb1278020200                      mov.l   #20278h, r1
FFF15BAF  ee114960                          mov.l   18124h[r1], r1
FFF15BB3  7701008001                        cmp     #18000h, r1
FFF15BB8  2164                              bne.b   loc_FFF15C1C
FFF15BBA  f80501                            mov.w   #1, [sp]
FFF15BBD  fb1278020200                      mov.l   #20278h, r1
FFF15BC3  6261                              add     #6, r1
FFF15BC5  a009                              mov.l   r1, 4[sp]
FFF15BC7  fb1278020200                      mov.l   #20278h, r1
FFF15BCD  e610496002                        mov.l   18124h[r1], 8[sp]
FFF15BD2  fb1278020200                      mov.l   #20278h, r1
FFF15BD8  73112e8101                        add     #1812Eh, r1, r1
FFF15BDD  a089                              mov.l   r1, 0Ch[sp]
FFF15BDF  fb1278020200                      mov.l   #20278h, r1
FFF15BE5  fa1596c000                        mov.w   #0, 1812Ch[r1]
FFF15BEA  7100ec                            add     #-14h, sp, sp
FFF15BED  754314                            mov.l   #14h, r3
FFF15BF0  710214                            add     #14h, sp, r2
FFF15BF3  ef01                              mov.l   sp, r1
FFF15BF5  7f8f                              smovf
FFF15BF7  0582e4ff                          bsr.a   sub_FFF14079
FFF15BFB  710014                            add     #14h, sp, sp
FFF15BFE  fb1278020200                      mov.l   #20278h, r1
FFF15C04  f9158a01                          mov.w   #1, 114h[r1]
FFF15C08  fb1278020200                      mov.l   #20278h, r1
FFF15C0E  fa16496000                        mov.l   #0, 18124h[r1]
FFF15C13  710018                            add     #18h, sp, sp
FFF15C16  6f15                              popm    r1-r5
FFF15C18  6fef                              popm    r14-r15
FFF15C1A  7f95                              rte
FFF15C1C  710018                   loc_FFF15C1C add     #18h, sp, sp
FFF15C1F  6f15                              popm    r1-r5
FFF15C21  6fef                              popm    r14-r15
FFF15C23  7f95                              rte
FFF15C25  6040                     sub_FFF15C25 sub     #4, sp  ; <<< FUNC sub_FFF15C25
FFF15C27  e301                              mov.l   r1, 4+var_4[sp]
FFF15C29  fbe295220100                      mov.l   #12295h, r14
FFF15C2F  58ee                              movu.b  [r14], r14
FFF15C31  610e                              cmp     #0, r14
FFF15C33  2053                              beq.b   loc_FFF15C86
FFF15C35  754e84                            mov.l   #-7Ch, r14
FFF15C38  fbf296220100                      mov.l   #12296h, r15
FFF15C3E  4cfe                              mul     [r15], r14
FFF15C40  fbf29a6aecff                      mov.l   #unk_FFEC6A9A, r15
FFF15C46  5cf3                              movu.w  [r15], r3
FFF15C48  ec01                              mov.l   4+var_4[sp], r1
FFF15C4A  fb22e0030500                      mov.l   #503E0h, r2
FFF15C50  4be2                              add     r14, r2
FFF15C52  054ef902                          bsr.a   sub_FFF455A0
FFF15C56  fbe295220100                      mov.l   #12295h, r14
FFF15C5C  58ef                              movu.b  [r14], r15
FFF15C5E  601f                              sub     #1, r15
FFF15C60  c3ef                              mov.b   r15, [r14]
FFF15C62  fbe296220100                      mov.l   #12296h, r14
FFF15C68  58ef                              movu.b  [r14], r15
FFF15C6A  621f                              add     #1, r15
FFF15C6C  c3ef                              mov.b   r15, [r14]
FFF15C6E  fbe296220100                      mov.l   #12296h, r14
FFF15C74  58ee                              movu.b  [r14], r14
FFF15C76  755e80                            cmp     #-80h, r14
FFF15C79  210d                              bne.b   loc_FFF15C86
FFF15C7B  fbe296220100                      mov.l   #12296h, r14
FFF15C81  f8e400                            mov.b   #0, [r14]
FFF15C84  6701                              rtsd    #1
FFF15C86  6701                     loc_FFF15C86 rtsd    #1
FFF15C88  fbe295220100             sub_FFF15C88 mov.l   #12295h, r14  ; <<< FUNC sub_FFF15C88
FFF15C8E  58ee                              movu.b  [r14], r14
FFF15C90  710204                            add     #arg_0, sp, r2
FFF15C93  755e80                            cmp     #-80h, r14
FFF15C96  2042                              beq.b   loc_FFF15CD8
FFF15C98  fbe296220100                      mov.l   #12296h, r14
FFF15C9E  58ee                              movu.b  [r14], r14
FFF15CA0  fbf295220100                      mov.l   #12295h, r15
FFF15CA6  48fe                              add     [r15], r14
FFF15CA8  fbf29a6aecff                      mov.l   #unk_FFEC6A9A, r15
FFF15CAE  5cf3                              movu.w  [r15], r3
FFF15CB0  efef                              mov.l   r14, r15
FFF15CB2  fd788f8000                        div     #80h, r15
FFF15CB7  6c7f                              shll    #7, r15
FFF15CB9  43fe                              sub     r15, r14
FFF15CBB  761e8400                          mul     #84h, r14
FFF15CBF  fb12e0030500                      mov.l   #503E0h, r1
FFF15CC5  4be1                              add     r14, r1
FFF15CC7  05d9f802                          bsr.a   sub_FFF455A0
FFF15CCB  fbe295220100                      mov.l   #12295h, r14
FFF15CD1  58ef                              movu.b  [r14], r15
FFF15CD3  621f                              add     #1, r15
FFF15CD5  c3ef                              mov.b   r15, [r14]
FFF15CD7  02                                rts
FFF15CD8  02                       loc_FFF15CD8 rts
FFF15CD9  6040                     sub_FFF15CD9 sub     #4, sp  ; <<< FUNC sub_FFF15CD9
FFF15CDB  fbe2305e0600                      mov.l   #65E30h, r14
FFF15CE1  ece1                              mov.l   [r14], r1
FFF15CE3  e301                              mov.l   r1, 4+var_4[sp]
FFF15CE5  6701                              rtsd    #1
FFF15CE7  6040                     sub_FFF15CE7 sub     #4, sp  ; <<< FUNC sub_FFF15CE7
FFF15CE9  e301                              mov.l   r1, 4+var_4[sp]
FFF15CEB  6701                              rtsd    #1
FFF15CED  6080                     sub_FFF15CED sub     #8, sp  ; <<< FUNC sub_FFF15CED
FFF15CEF  a009                              mov.l   r1, 8+var_4[sp]
FFF15CF1  f80600                            mov.l   #0, 8+var_8[sp]
FFF15CF4  6601                              mov.l   #0, r1
FFF15CF6  6702                              rtsd    #2
FFF15CF8  6080                     sub_FFF15CF8 sub     #8, sp  ; <<< FUNC sub_FFF15CF8
FFF15CFA  a009                              mov.l   r1, 8+var_4[sp]
FFF15CFC  f80600                            mov.l   #0, 8+var_8[sp]
FFF15CFF  6601                              mov.l   #0, r1
FFF15D01  6702                              rtsd    #2
FFF15D03  6040                     sub_FFF15D03 sub     #4, sp  ; <<< FUNC sub_FFF15D03
FFF15D05  f80600                            mov.l   #0, 4+var_4[sp]
FFF15D08  6601                              mov.l   #0, r1
FFF15D0A  6701                              rtsd    #1
FFF15D0C  6040                              sub     #4, sp
FFF15D0E  f80600                            mov.l   #0, [sp]
FFF15D11  6601                              mov.l   #0, r1
FFF15D13  6701                              rtsd    #1
FFF15D15  6080                     loc_FFF15D15 sub     #8, sp
FFF15D17  a009                              mov.l   r1, 4[sp]
FFF15D19  f80600                            mov.l   #0, [sp]
FFF15D1C  6601                              mov.l   #0, r1
FFF15D1E  6702                              rtsd    #2
FFF15D20  6080                     loc_FFF15D20 sub     #8, sp
FFF15D22  a009                              mov.l   r1, 4[sp]
FFF15D24  f80600                            mov.l   #0, [sp]
FFF15D27  6601                              mov.l   #0, r1
FFF15D29  6702                              rtsd    #2
FFF15D2B  6040                     loc_FFF15D2B sub     #4, sp
FFF15D2D  f80600                            mov.l   #0, [sp]
FFF15D30  6601                              mov.l   #0, r1
FFF15D32  6701                              rtsd    #1
FFF15D34  6040                              sub     #4, sp
FFF15D36  f80600                            mov.l   #0, [sp]
FFF15D39  6601                              mov.l   #0, r1
FFF15D3B  6701                              rtsd    #1
FFF15D3D  6080                     loc_FFF15D3D sub     #8, sp
FFF15D3F  a009                              mov.l   r1, 4[sp]
FFF15D41  f80600                            mov.l   #0, [sp]
FFF15D44  6601                              mov.l   #0, r1
FFF15D46  6702                              rtsd    #2
FFF15D48  6080                     loc_FFF15D48 sub     #8, sp
FFF15D4A  a009                              mov.l   r1, 4[sp]
FFF15D4C  f80600                            mov.l   #0, [sp]
FFF15D4F  6601                              mov.l   #0, r1
FFF15D51  6702                              rtsd    #2
FFF15D53  6080                     loc_FFF15D53 sub     #8, sp
FFF15D55  a009                              mov.l   r1, 4[sp]
FFF15D57  f80600                            mov.l   #0, [sp]
FFF15D5A  6601                              mov.l   #0, r1
FFF15D5C  6702                              rtsd    #2
FFF15D5E  6080                     loc_FFF15D5E sub     #8, sp
FFF15D60  a009                              mov.l   r1, 4[sp]
FFF15D62  f80600                            mov.l   #0, [sp]
FFF15D65  6601                              mov.l   #0, r1
FFF15D67  6702                              rtsd    #2
FFF15D69  6080                     loc_FFF15D69 sub     #8, sp
FFF15D6B  f80600                            mov.l   #0, [sp]
FFF15D6E  ec01                              mov.l   [sp], r1
FFF15D70  a009                              mov.l   r1, 4[sp]
FFF15D72  6702                              rtsd    #2
FFF15D74  6080                     loc_FFF15D74 sub     #8, sp
FFF15D76  f80600                            mov.l   #0, [sp]
FFF15D79  ec01                              mov.l   [sp], r1
FFF15D7B  a009                              mov.l   r1, 4[sp]
FFF15D7D  6702                              rtsd    #2
FFF15D7F  6080                     loc_FFF15D7F sub     #8, sp
FFF15D81  f80600                            mov.l   #0, [sp]
FFF15D84  ec01                              mov.l   [sp], r1
FFF15D86  a009                              mov.l   r1, 4[sp]
FFF15D88  6702                              rtsd    #2
FFF15D8A  6040                              sub     #4, sp
FFF15D8C  f80600                            mov.l   #0, [sp]
FFF15D8F  6601                              mov.l   #0, r1
FFF15D91  6701                              rtsd    #1
FFF15D93  6080                     loc_FFF15D93 sub     #8, sp
FFF15D95  f80600                            mov.l   #0, [sp]
FFF15D98  ec01                              mov.l   [sp], r1
FFF15D9A  a009                              mov.l   r1, 4[sp]
FFF15D9C  6702                              rtsd    #2
FFF15D9E  6080                     loc_FFF15D9E sub     #8, sp
FFF15DA0  f80600                            mov.l   #0, [sp]
FFF15DA3  ec01                              mov.l   [sp], r1
FFF15DA5  a009                              mov.l   r1, 4[sp]
FFF15DA7  6702                              rtsd    #2
FFF15DA9  6080                     loc_FFF15DA9 sub     #8, sp
FFF15DAB  f80600                            mov.l   #0, [sp]
FFF15DAE  ec01                              mov.l   [sp], r1
FFF15DB0  a009                              mov.l   r1, 4[sp]
FFF15DB2  6702                              rtsd    #2
FFF15DB4  6040                              sub     #4, sp
FFF15DB6  f80600                            mov.l   #0, [sp]
FFF15DB9  6601                              mov.l   #0, r1
FFF15DBB  6701                              rtsd    #1
FFF15DBD  6040                              sub     #4, sp
FFF15DBF  f80600                            mov.l   #0, [sp]
FFF15DC2  6601                              mov.l   #0, r1
FFF15DC4  6701                              rtsd    #1
FFF15DC6  6040                              sub     #4, sp
FFF15DC8  f80600                            mov.l   #0, [sp]
FFF15DCB  6601                              mov.l   #0, r1
FFF15DCD  6701                              rtsd    #1
FFF15DCF  6080                              sub     #8, sp
FFF15DD1  f80600                            mov.l   #0, [sp]
FFF15DD4  ec01                              mov.l   [sp], r1
FFF15DD6  a009                              mov.l   r1, 4[sp]
FFF15DD8  6702                              rtsd    #2
FFF15DDA  6040                              sub     #4, sp
FFF15DDC  f80600                            mov.l   #0, [sp]
FFF15DDF  6601                              mov.l   #0, r1
FFF15DE1  6701                              rtsd    #1
FFF15DE3  6080                     loc_FFF15DE3 sub     #8, sp
FFF15DE5  a009                              mov.l   r1, 4[sp]
FFF15DE7  f80600                            mov.l   #0, [sp]
FFF15DEA  6601                              mov.l   #0, r1
FFF15DEC  6702                              rtsd    #2
FFF15DEE  6080                     loc_FFF15DEE sub     #8, sp
FFF15DF0  a009                              mov.l   r1, 4[sp]
FFF15DF2  f80600                            mov.l   #0, [sp]
FFF15DF5  6601                              mov.l   #0, r1
FFF15DF7  6702                              rtsd    #2
FFF15DF9  6040                     loc_FFF15DF9 sub     #4, sp
FFF15DFB  f80600                            mov.l   #0, [sp]
FFF15DFE  6601                              mov.l   #0, r1
FFF15E00  6701                              rtsd    #1
FFF15E02  6040                              sub     #4, sp
FFF15E04  f80600                            mov.l   #0, [sp]
FFF15E07  6601                              mov.l   #0, r1
FFF15E09  6701                              rtsd    #1
FFF15E0B  7100f0                   loc_FFF15E0B add     #-10h, sp, sp
FFF15E0E  a089                              mov.l   r1, 0Ch[sp]
FFF15E10  f80600                            mov.l   #0, [sp]
FFF15E13  a889                              mov.l   0Ch[sp], r1
FFF15E15  7701000001                        cmp     #10000h, r1
FFF15E1A  243d                              bgtu.b  loc_FFF15E57
FFF15E1C  3c0700                            mov.b   #0, 7[sp]
FFF15E1F  2e32                              bra.b   loc_FFF15E51
FFF15E21  b189                     loc_FFF15E21 movu.b  7[sp], r1
FFF15E23  fbe29a220100                      mov.l   #1229Ah, r14
FFF15E29  fe4e1e                            mov.b   [r14, r1], r14
FFF15E2C  610e                              cmp     #0, r14
FFF15E2E  211f                              bne.b   loc_FFF15E4D
FFF15E30  5b1e                              movu.b  r1, r14
FFF15E32  fbf29a220100                      mov.l   #1229Ah, r15
FFF15E38  6615                              mov.l   #1, r5
FFF15E3A  fe0fe5                            mov.b   r5, [r15, r14]
FFF15E3D  b189                              movu.b  7[sp], r1
FFF15E3F  6d01                              shll    #10h, r1
FFF15E41  fb22e0450500                      mov.l   #545E0h, r2
FFF15E47  4b12                              add     r1, r2
FFF15E49  e302                              mov.l   r2, [sp]
FFF15E4B  2e0c                              bra.b   loc_FFF15E57
FFF15E4D  6211                     loc_FFF15E4D add     #1, r1
FFF15E4F  8189                              mov.b   r1, 7[sp]
FFF15E51  b189                     loc_FFF15E51 movu.b  7[sp], r1
FFF15E53  6101                              cmp     #0, r1
FFF15E55  2bcc                              ble.b   loc_FFF15E21
FFF15E57  ec01                     loc_FFF15E57 mov.l   [sp], r1
FFF15E59  a081                              mov.l   r1, 8[sp]
FFF15E5B  6704                              rtsd    #4
FFF15E5D  6080                     loc_FFF15E5D sub     #8, sp
FFF15E5F  a009                              mov.l   r1, 4[sp]
FFF15E61  3c0300                            mov.b   #0, 3[sp]
FFF15E64  2e28                              bra.b   loc_FFF15E8C
FFF15E66  b089                     loc_FFF15E66 movu.b  3[sp], r1
FFF15E68  fdd01e                            shll    #10h, r1, r14
FFF15E6B  fbf2e0450500                      mov.l   #545E0h, r15
FFF15E71  4bef                              add     r14, r15
FFF15E73  06850f01                          cmp     4[sp].l, r15
FFF15E77  2111                              bne.b   loc_FFF15E88
FFF15E79  5b1e                              movu.b  r1, r14
FFF15E7B  fbf29a220100                      mov.l   #1229Ah, r15

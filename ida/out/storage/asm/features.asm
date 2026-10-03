
; ######## sub_FFF0B665  FFF0B665-FFF0BE2E (file 30B665) callers: FFF0B30B(sub_FFF0B1DB)
FFF0B665  7100e8                 sub_FFF0B665 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF0B665
FFF0B668  9289                              mov.w   r1, 18h+var_2[sp]
FFF0B66A  9282                              mov.w   r2, 18h+var_4[sp]
FFF0B66C  920b                              mov.w   r3, 18h+var_6[sp]
FFF0B66E  9204                              mov.w   r4, 18h+var_8[sp]
FFF0B670  c5001c0f                          mov.b   18h+arg_0[sp], 18h+var_9[sp]
FFF0B674  393113                            bsr.w   sub_FFF0C9A5
FFF0B677  ba82                              movu.w  18h+var_4[sp], r2
FFF0B679  ba89                              movu.w  18h+var_2[sp], r1
FFF0B67B  391efd                            bsr.w   sub_FFF0B399
FFF0B67E  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0B684  c5e01a08                          mov.b   1Ah[r14], 18h+var_10[sp]
FFF0B688  056a4cfe                          bsr.a   sub_FFEF02F2
FFF0B68C  8189                              mov.b   r1, 18h+var_11[sp]
FFF0B68E  b201                              movu.b  18h+var_10[sp], r1
FFF0B690  6111                              cmp     #1, r1
FFF0B692  1a                                bne.s   loc_FFF0B69C
FFF0B693  b189                              movu.b  18h+var_11[sp], r1
FFF0B695  6101                              cmp     #0, r1
FFF0B697  1d                                bne.s   loc_FFF0B69C
FFF0B698  f80601                            mov.l   #1, 18h+var_18[sp]
FFF0B69B  0c                                bra.s   loc_FFF0B69F
FFF0B69C  f80600                 loc_FFF0B69C mov.l   #0, 18h+var_18[sp]
FFF0B69F  ec01                   loc_FFF0B69F mov.l   18h+var_18[sp], r1
FFF0B6A1  6101                              cmp     #0, r1
FFF0B6A3  3b8907                            bne.w   loc_FFF0BE2C
FFF0B6A6  3d050b                            mov.w   #0Bh, 18h+var_E[sp]
FFF0B6A9  b389                              movu.b  18h+var_9[sp], r1
FFF0B6AB  7551af                            cmp     #-51h, r1
FFF0B6AE  3a3f07                            beq.w   loc_FFF0BDED
FFF0B6B1  6121                              cmp     #2, r1
FFF0B6B3  3add00                            beq.w   loc_FFF0B790
FFF0B6B6  6131                              cmp     #3, r1
FFF0B6B8  3a1701                            beq.w   loc_FFF0B7CF
FFF0B6BB  6141                              cmp     #4, r1
FFF0B6BD  3a5101                            beq.w   loc_FFF0B80E
FFF0B6C0  6151                              cmp     #5, r1
FFF0B6C2  3a8b01                            beq.w   loc_FFF0B84D
FFF0B6C5  6161                              cmp     #6, r1
FFF0B6C7  3ac501                            beq.w   loc_FFF0B88C
FFF0B6CA  6171                              cmp     #7, r1
FFF0B6CC  3aff01                            beq.w   loc_FFF0B8CB
FFF0B6CF  6181                              cmp     #8, r1
FFF0B6D1  3a3902                            beq.w   loc_FFF0B90A
FFF0B6D4  6191                              cmp     #9, r1
FFF0B6D6  3a7302                            beq.w   loc_FFF0B949
FFF0B6D9  61a1                              cmp     #0Ah, r1
FFF0B6DB  3aad02                            beq.w   loc_FFF0B988
FFF0B6DE  61b1                              cmp     #0Bh, r1
FFF0B6E0  3acc02                            beq.w   loc_FFF0B9AC
FFF0B6E3  61c1                              cmp     #0Ch, r1
FFF0B6E5  3aeb02                            beq.w   loc_FFF0B9D0
FFF0B6E8  61d1                              cmp     #0Dh, r1
FFF0B6EA  3a2503                            beq.w   loc_FFF0BA0F
FFF0B6ED  61e1                              cmp     #0Eh, r1
FFF0B6EF  3a5f03                            beq.w   loc_FFF0BA4E
FFF0B6F2  7551a0                            cmp     #-60h, r1
FFF0B6F5  3a7d03                            beq.w   loc_FFF0BA72
FFF0B6F8  7551a1                            cmp     #-5Fh, r1
FFF0B6FB  3ab603                            beq.w   loc_FFF0BAB1
FFF0B6FE  7551a2                            cmp     #-5Eh, r1
FFF0B701  3aef03                            beq.w   loc_FFF0BAF0
FFF0B704  7551a3                            cmp     #-5Dh, r1
FFF0B707  3a2804                            beq.w   loc_FFF0BB2F
FFF0B70A  7551a4                            cmp     #-5Ch, r1
FFF0B70D  3a6104                            beq.w   loc_FFF0BB6E
FFF0B710  7551a5                            cmp     #-5Bh, r1
FFF0B713  3a9a04                            beq.w   loc_FFF0BBAD
FFF0B716  7551a6                            cmp     #-5Ah, r1
FFF0B719  3ad304                            beq.w   loc_FFF0BBEC
FFF0B71C  7551a7                            cmp     #-59h, r1
FFF0B71F  3a0c05                            beq.w   loc_FFF0BC2B
FFF0B722  7551a8                            cmp     #-58h, r1
FFF0B725  3a4505                            beq.w   loc_FFF0BC6A
FFF0B728  7551a9                            cmp     #-57h, r1
FFF0B72B  3a7e05                            beq.w   loc_FFF0BCA9
FFF0B72E  7551aa                            cmp     #-56h, r1
FFF0B731  3ab705                            beq.w   loc_FFF0BCE8
FFF0B734  7551ab                            cmp     #-55h, r1
FFF0B737  3af005                            beq.w   loc_FFF0BD27
FFF0B73A  7551ac                            cmp     #-54h, r1
FFF0B73D  3a2906                            beq.w   loc_FFF0BD66
FFF0B740  7551ad                            cmp     #-53h, r1
FFF0B743  3a4706                            beq.w   loc_FFF0BD8A
FFF0B746  7551ae                            cmp     #-52h, r1
FFF0B749  3a6506                            beq.w   loc_FFF0BDAE
FFF0B74C  6111                              cmp     #1, r1
FFF0B74E  3bde06                            bne.w   loc_FFF0BE2C
FFF0B751  3c0909                            mov.b   #9, 18h+var_F[sp]
FFF0B754  b209                              movu.b  18h+var_F[sp], r1
FFF0B756  63e1                              mul     #0Eh, r1
FFF0B758  7542ca                            mov.l   #-36h, r2
FFF0B75B  4312                              sub     r1, r2
FFF0B75D  fd748202                          div     #2, r2
FFF0B761  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B763  ba81                              movu.w  18h+var_4[sp], r1
FFF0B765  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B769  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B76B  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B76F  b20a                              movu.b  18h+var_F[sp], r2
FFF0B771  60c0                              sub     #0Ch, sp
FFF0B773  fb425caaf4ff                      mov.l   #loc_FFF4AA5C, r4
FFF0B779  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B77B  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B77D  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B780  5f12                              movu.w  r1, r2
FFF0B782  5f31                              movu.w  r3, r1
FFF0B784  6604                              mov.l   #0, r4
FFF0B786  66d3                              mov.l   #0Dh, r3
FFF0B788  059b63fe                          bsr.a   sub_FFEF1B23
FFF0B78C  62c0                              add     #0Ch, sp
FFF0B78E  6706                              rtsd    #6
FFF0B790  3c090d                 loc_FFF0B790 mov.b   #0Dh, 18h+var_F[sp]
FFF0B793  b209                              movu.b  18h+var_F[sp], r1
FFF0B795  63e1                              mul     #0Eh, r1
FFF0B797  7542ca                            mov.l   #-36h, r2
FFF0B79A  4312                              sub     r1, r2
FFF0B79C  fd748202                          div     #2, r2
FFF0B7A0  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B7A2  ba81                              movu.w  18h+var_4[sp], r1
FFF0B7A4  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B7A8  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B7AA  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B7AE  b20a                              movu.b  18h+var_F[sp], r2
FFF0B7B0  60c0                              sub     #0Ch, sp
FFF0B7B2  fb4266aaf4ff                      mov.l   #loc_FFF4AA66, r4
FFF0B7B8  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B7BA  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B7BC  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B7BF  5f12                              movu.w  r1, r2
FFF0B7C1  5f31                              movu.w  r3, r1
FFF0B7C3  6604                              mov.l   #0, r4
FFF0B7C5  66d3                              mov.l   #0Dh, r3
FFF0B7C7  055c63fe                          bsr.a   sub_FFEF1B23
FFF0B7CB  62c0                              add     #0Ch, sp
FFF0B7CD  6706                              rtsd    #6
FFF0B7CF  3c0907                 loc_FFF0B7CF mov.b   #7, 18h+var_F[sp]
FFF0B7D2  b209                              movu.b  18h+var_F[sp], r1
FFF0B7D4  63e1                              mul     #0Eh, r1
FFF0B7D6  7542ca                            mov.l   #-36h, r2
FFF0B7D9  4312                              sub     r1, r2
FFF0B7DB  fd748202                          div     #2, r2
FFF0B7DF  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B7E1  ba81                              movu.w  18h+var_4[sp], r1
FFF0B7E3  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B7E7  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B7E9  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B7ED  b20a                              movu.b  18h+var_F[sp], r2
FFF0B7EF  60c0                              sub     #0Ch, sp
FFF0B7F1  fb4274aaf4ff                      mov.l   #loc_FFF4AA74, r4
FFF0B7F7  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B7F9  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B7FB  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B7FE  5f12                              movu.w  r1, r2
FFF0B800  5f31                              movu.w  r3, r1
FFF0B802  6604                              mov.l   #0, r4
FFF0B804  66d3                              mov.l   #0Dh, r3
FFF0B806  051d63fe                          bsr.a   sub_FFEF1B23
FFF0B80A  62c0                              add     #0Ch, sp
FFF0B80C  6706                              rtsd    #6
FFF0B80E  3c0907                 loc_FFF0B80E mov.b   #7, 18h+var_F[sp]
FFF0B811  b209                              movu.b  18h+var_F[sp], r1
FFF0B813  63e1                              mul     #0Eh, r1
FFF0B815  7542ca                            mov.l   #-36h, r2
FFF0B818  4312                              sub     r1, r2
FFF0B81A  fd748202                          div     #2, r2
FFF0B81E  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B820  ba81                              movu.w  18h+var_4[sp], r1
FFF0B822  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B826  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B828  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B82C  b20a                              movu.b  18h+var_F[sp], r2
FFF0B82E  60c0                              sub     #0Ch, sp
FFF0B830  fb427caaf4ff                      mov.l   #loc_FFF4AA7C, r4
FFF0B836  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B838  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B83A  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B83D  5f12                              movu.w  r1, r2
FFF0B83F  5f31                              movu.w  r3, r1
FFF0B841  6604                              mov.l   #0, r4
FFF0B843  66d3                              mov.l   #0Dh, r3
FFF0B845  05de62fe                          bsr.a   sub_FFEF1B23
FFF0B849  62c0                              add     #0Ch, sp
FFF0B84B  6706                              rtsd    #6
FFF0B84D  3c0909                 loc_FFF0B84D mov.b   #9, 18h+var_F[sp]
FFF0B850  b209                              movu.b  18h+var_F[sp], r1
FFF0B852  63e1                              mul     #0Eh, r1
FFF0B854  7542ca                            mov.l   #-36h, r2
FFF0B857  4312                              sub     r1, r2
FFF0B859  fd748202                          div     #2, r2
FFF0B85D  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B85F  ba81                              movu.w  18h+var_4[sp], r1
FFF0B861  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B865  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B867  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B86B  b20a                              movu.b  18h+var_F[sp], r2
FFF0B86D  60c0                              sub     #0Ch, sp
FFF0B86F  fb4284aaf4ff                      mov.l   #loc_FFF4AA84, r4
FFF0B875  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B877  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B879  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B87C  5f12                              movu.w  r1, r2
FFF0B87E  5f31                              movu.w  r3, r1
FFF0B880  6604                              mov.l   #0, r4
FFF0B882  66d3                              mov.l   #0Dh, r3
FFF0B884  059f62fe                          bsr.a   sub_FFEF1B23
FFF0B888  62c0                              add     #0Ch, sp
FFF0B88A  6706                              rtsd    #6
FFF0B88C  3c090d                 loc_FFF0B88C mov.b   #0Dh, 18h+var_F[sp]
FFF0B88F  b209                              movu.b  18h+var_F[sp], r1
FFF0B891  63e1                              mul     #0Eh, r1
FFF0B893  7542ca                            mov.l   #-36h, r2
FFF0B896  4312                              sub     r1, r2
FFF0B898  fd748202                          div     #2, r2
FFF0B89C  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B89E  ba81                              movu.w  18h+var_4[sp], r1
FFF0B8A0  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B8A4  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B8A6  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B8AA  b20a                              movu.b  18h+var_F[sp], r2
FFF0B8AC  60c0                              sub     #0Ch, sp
FFF0B8AE  fb428eaaf4ff                      mov.l   #loc_FFF4AA8E, r4
FFF0B8B4  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B8B6  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B8B8  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B8BB  5f12                              movu.w  r1, r2
FFF0B8BD  5f31                              movu.w  r3, r1
FFF0B8BF  6604                              mov.l   #0, r4
FFF0B8C1  66d3                              mov.l   #0Dh, r3
FFF0B8C3  056062fe                          bsr.a   sub_FFEF1B23
FFF0B8C7  62c0                              add     #0Ch, sp
FFF0B8C9  6706                              rtsd    #6
FFF0B8CB  3c090a                 loc_FFF0B8CB mov.b   #0Ah, 18h+var_F[sp]
FFF0B8CE  b209                              movu.b  18h+var_F[sp], r1
FFF0B8D0  63e1                              mul     #0Eh, r1
FFF0B8D2  7542ca                            mov.l   #-36h, r2
FFF0B8D5  4312                              sub     r1, r2
FFF0B8D7  fd748202                          div     #2, r2
FFF0B8DB  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B8DD  ba81                              movu.w  18h+var_4[sp], r1
FFF0B8DF  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B8E3  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B8E5  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B8E9  b20a                              movu.b  18h+var_F[sp], r2
FFF0B8EB  60c0                              sub     #0Ch, sp
FFF0B8ED  fb429caaf4ff                      mov.l   #loc_FFF4AA9C, r4
FFF0B8F3  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B8F5  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B8F7  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B8FA  5f12                              movu.w  r1, r2
FFF0B8FC  5f31                              movu.w  r3, r1
FFF0B8FE  6604                              mov.l   #0, r4
FFF0B900  66d3                              mov.l   #0Dh, r3
FFF0B902  052162fe                          bsr.a   sub_FFEF1B23
FFF0B906  62c0                              add     #0Ch, sp
FFF0B908  6706                              rtsd    #6
FFF0B90A  3c090d                 loc_FFF0B90A mov.b   #0Dh, 18h+var_F[sp]
FFF0B90D  b209                              movu.b  18h+var_F[sp], r1
FFF0B90F  63e1                              mul     #0Eh, r1
FFF0B911  7542ca                            mov.l   #-36h, r2
FFF0B914  4312                              sub     r1, r2
FFF0B916  fd748202                          div     #2, r2
FFF0B91A  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B91C  ba81                              movu.w  18h+var_4[sp], r1
FFF0B91E  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B922  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B924  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B928  b20a                              movu.b  18h+var_F[sp], r2
FFF0B92A  60c0                              sub     #0Ch, sp
FFF0B92C  fb42a7aaf4ff                      mov.l   #loc_FFF4AAA7, r4
FFF0B932  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B934  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B936  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B939  5f12                              movu.w  r1, r2
FFF0B93B  5f31                              movu.w  r3, r1
FFF0B93D  6604                              mov.l   #0, r4
FFF0B93F  66d3                              mov.l   #0Dh, r3
FFF0B941  05e261fe                          bsr.a   sub_FFEF1B23
FFF0B945  62c0                              add     #0Ch, sp
FFF0B947  6706                              rtsd    #6
FFF0B949  3c090c                 loc_FFF0B949 mov.b   #0Ch, 18h+var_F[sp]
FFF0B94C  b209                              movu.b  18h+var_F[sp], r1
FFF0B94E  63e1                              mul     #0Eh, r1
FFF0B950  7542ca                            mov.l   #-36h, r2
FFF0B953  4312                              sub     r1, r2
FFF0B955  fd748202                          div     #2, r2
FFF0B959  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B95B  ba81                              movu.w  18h+var_4[sp], r1
FFF0B95D  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B961  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B963  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B967  b20a                              movu.b  18h+var_F[sp], r2
FFF0B969  60c0                              sub     #0Ch, sp
FFF0B96B  fb42b5aaf4ff                      mov.l   #loc_FFF4AAB5, r4
FFF0B971  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B973  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B975  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B978  5f12                              movu.w  r1, r2
FFF0B97A  5f31                              movu.w  r3, r1
FFF0B97C  6604                              mov.l   #0, r4
FFF0B97E  66d3                              mov.l   #0Dh, r3
FFF0B980  05a361fe                          bsr.a   sub_FFEF1B23
FFF0B984  62c0                              add     #0Ch, sp
FFF0B986  6706                              rtsd    #6
FFF0B988  3d061f                 loc_FFF0B988 mov.w   #1Fh, 18h+var_C[sp]
FFF0B98B  3d0509                            mov.w   #9, 18h+var_E[sp]
FFF0B98E  ba81                              movu.w  18h+var_4[sp], r1
FFF0B990  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B994  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B996  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B99A  5f12                              movu.w  r1, r2
FFF0B99C  5f31                              movu.w  r3, r1
FFF0B99E  fb42dc2eedff                      mov.l   #unk_FFED2EDC, r4
FFF0B9A4  6613                              mov.l   #1, r3
FFF0B9A6  052faffe                          bsr.a   sub_FFEF68D5
FFF0B9AA  6706                              rtsd    #6
FFF0B9AC  3d0609                 loc_FFF0B9AC mov.w   #9, 18h+var_C[sp]
FFF0B9AF  3d0509                            mov.w   #9, 18h+var_E[sp]
FFF0B9B2  ba81                              movu.w  18h+var_4[sp], r1
FFF0B9B4  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B9B8  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B9BA  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B9BE  5f12                              movu.w  r1, r2
FFF0B9C0  5f31                              movu.w  r3, r1
FFF0B9C2  fb42ec2eedff                      mov.l   #unk_FFED2EEC, r4
FFF0B9C8  6613                              mov.l   #1, r3
FFF0B9CA  050baffe                          bsr.a   sub_FFEF68D5
FFF0B9CE  6706                              rtsd    #6
FFF0B9D0  3c090a                 loc_FFF0B9D0 mov.b   #0Ah, 18h+var_F[sp]
FFF0B9D3  b209                              movu.b  18h+var_F[sp], r1
FFF0B9D5  63e1                              mul     #0Eh, r1
FFF0B9D7  7542ca                            mov.l   #-36h, r2
FFF0B9DA  4312                              sub     r1, r2
FFF0B9DC  fd748202                          div     #2, r2
FFF0B9E0  9182                              mov.w   r2, 18h+var_C[sp]
FFF0B9E2  ba81                              movu.w  18h+var_4[sp], r1
FFF0B9E4  06c90105                          add     18h+var_E[sp].uw, r1
FFF0B9E8  ba8b                              movu.w  18h+var_2[sp], r3
FFF0B9EA  06c90306                          add     18h+var_C[sp].uw, r3
FFF0B9EE  b20a                              movu.b  18h+var_F[sp], r2
FFF0B9F0  60c0                              sub     #0Ch, sp
FFF0B9F2  fb42c2aaf4ff                      mov.l   #loc_FFF4AAC2, r4
FFF0B9F8  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0B9FA  c302                              mov.b   r2, 24h+var_24[sp]
FFF0B9FC  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0B9FF  5f12                              movu.w  r1, r2
FFF0BA01  5f31                              movu.w  r3, r1
FFF0BA03  6604                              mov.l   #0, r4
FFF0BA05  66d3                              mov.l   #0Dh, r3
FFF0BA07  051c61fe                          bsr.a   sub_FFEF1B23
FFF0BA0B  62c0                              add     #0Ch, sp
FFF0BA0D  6706                              rtsd    #6
FFF0BA0F  3c090b                 loc_FFF0BA0F mov.b   #0Bh, 18h+var_F[sp]
FFF0BA12  b209                              movu.b  18h+var_F[sp], r1
FFF0BA14  63e1                              mul     #0Eh, r1
FFF0BA16  7542ca                            mov.l   #-36h, r2
FFF0BA19  4312                              sub     r1, r2
FFF0BA1B  fd748202                          div     #2, r2
FFF0BA1F  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BA21  ba81                              movu.w  18h+var_4[sp], r1
FFF0BA23  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BA27  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BA29  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BA2D  b20a                              movu.b  18h+var_F[sp], r2
FFF0BA2F  60c0                              sub     #0Ch, sp
FFF0BA31  fb42cdaaf4ff                      mov.l   #loc_FFF4AACD, r4
FFF0BA37  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BA39  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BA3B  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BA3E  5f12                              movu.w  r1, r2
FFF0BA40  5f31                              movu.w  r3, r1
FFF0BA42  6604                              mov.l   #0, r4
FFF0BA44  66d3                              mov.l   #0Dh, r3
FFF0BA46  05dd60fe                          bsr.a   sub_FFEF1B23
FFF0BA4A  62c0                              add     #0Ch, sp
FFF0BA4C  6706                              rtsd    #6
FFF0BA4E  3d061f                 loc_FFF0BA4E mov.w   #1Fh, 18h+var_C[sp]
FFF0BA51  3d0509                            mov.w   #9, 18h+var_E[sp]
FFF0BA54  ba81                              movu.w  18h+var_4[sp], r1
FFF0BA56  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BA5A  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BA5C  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BA60  5f12                              movu.w  r1, r2
FFF0BA62  5f31                              movu.w  r3, r1
FFF0BA64  fb421c2fedff                      mov.l   #unk_FFED2F1C, r4
FFF0BA6A  6613                              mov.l   #1, r3
FFF0BA6C  0569aefe                          bsr.a   sub_FFEF68D5
FFF0BA70  6706                              rtsd    #6
FFF0BA72  3c0909                 loc_FFF0BA72 mov.b   #9, 18h+var_F[sp]
FFF0BA75  b209                              movu.b  18h+var_F[sp], r1
FFF0BA77  63e1                              mul     #0Eh, r1
FFF0BA79  7542ca                            mov.l   #-36h, r2
FFF0BA7C  4312                              sub     r1, r2
FFF0BA7E  fd748202                          div     #2, r2
FFF0BA82  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BA84  ba81                              movu.w  18h+var_4[sp], r1
FFF0BA86  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BA8A  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BA8C  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BA90  b20a                              movu.b  18h+var_F[sp], r2
FFF0BA92  60c0                              sub     #0Ch, sp
FFF0BA94  fb42d9aaf4ff                      mov.l   #loc_FFF4AAD9, r4
FFF0BA9A  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BA9C  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BA9E  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BAA1  5f12                              movu.w  r1, r2
FFF0BAA3  5f31                              movu.w  r3, r1
FFF0BAA5  6604                              mov.l   #0, r4
FFF0BAA7  66d3                              mov.l   #0Dh, r3
FFF0BAA9  057a60fe                          bsr.a   sub_FFEF1B23
FFF0BAAD  62c0                              add     #0Ch, sp
FFF0BAAF  6706                              rtsd    #6
FFF0BAB1  3c0909                 loc_FFF0BAB1 mov.b   #9, 18h+var_F[sp]
FFF0BAB4  b209                              movu.b  18h+var_F[sp], r1
FFF0BAB6  63e1                              mul     #0Eh, r1
FFF0BAB8  7542ca                            mov.l   #-36h, r2
FFF0BABB  4312                              sub     r1, r2
FFF0BABD  fd748202                          div     #2, r2
FFF0BAC1  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BAC3  ba81                              movu.w  18h+var_4[sp], r1
FFF0BAC5  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BAC9  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BACB  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BACF  b20a                              movu.b  18h+var_F[sp], r2
FFF0BAD1  60c0                              sub     #0Ch, sp
FFF0BAD3  fb42e3aaf4ff                      mov.l   #loc_FFF4AAE3, r4
FFF0BAD9  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BADB  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BADD  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BAE0  5f12                              movu.w  r1, r2
FFF0BAE2  5f31                              movu.w  r3, r1
FFF0BAE4  6604                              mov.l   #0, r4
FFF0BAE6  66d3                              mov.l   #0Dh, r3
FFF0BAE8  053b60fe                          bsr.a   sub_FFEF1B23
FFF0BAEC  62c0                              add     #0Ch, sp
FFF0BAEE  6706                              rtsd    #6
FFF0BAF0  3c0909                 loc_FFF0BAF0 mov.b   #9, 18h+var_F[sp]
FFF0BAF3  b209                              movu.b  18h+var_F[sp], r1
FFF0BAF5  63e1                              mul     #0Eh, r1
FFF0BAF7  7542ca                            mov.l   #-36h, r2
FFF0BAFA  4312                              sub     r1, r2
FFF0BAFC  fd748202                          div     #2, r2
FFF0BB00  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BB02  ba81                              movu.w  18h+var_4[sp], r1
FFF0BB04  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BB08  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BB0A  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BB0E  b20a                              movu.b  18h+var_F[sp], r2
FFF0BB10  60c0                              sub     #0Ch, sp
FFF0BB12  fb42edaaf4ff                      mov.l   #loc_FFF4AAED, r4
FFF0BB18  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BB1A  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BB1C  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BB1F  5f12                              movu.w  r1, r2
FFF0BB21  5f31                              movu.w  r3, r1
FFF0BB23  6604                              mov.l   #0, r4
FFF0BB25  66d3                              mov.l   #0Dh, r3
FFF0BB27  05fc5ffe                          bsr.a   sub_FFEF1B23
FFF0BB2B  62c0                              add     #0Ch, sp
FFF0BB2D  6706                              rtsd    #6
FFF0BB2F  3c0908                 loc_FFF0BB2F mov.b   #8, 18h+var_F[sp]
FFF0BB32  b209                              movu.b  18h+var_F[sp], r1
FFF0BB34  63e1                              mul     #0Eh, r1
FFF0BB36  7542ca                            mov.l   #-36h, r2
FFF0BB39  4312                              sub     r1, r2
FFF0BB3B  fd748202                          div     #2, r2
FFF0BB3F  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BB41  ba81                              movu.w  18h+var_4[sp], r1
FFF0BB43  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BB47  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BB49  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BB4D  b20a                              movu.b  18h+var_F[sp], r2
FFF0BB4F  60c0                              sub     #0Ch, sp
FFF0BB51  fb42f7aaf4ff                      mov.l   #loc_FFF4AAF7, r4
FFF0BB57  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BB59  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BB5B  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BB5E  5f12                              movu.w  r1, r2
FFF0BB60  5f31                              movu.w  r3, r1
FFF0BB62  6604                              mov.l   #0, r4
FFF0BB64  66d3                              mov.l   #0Dh, r3
FFF0BB66  05bd5ffe                          bsr.a   sub_FFEF1B23
FFF0BB6A  62c0                              add     #0Ch, sp
FFF0BB6C  6706                              rtsd    #6
FFF0BB6E  3c0907                 loc_FFF0BB6E mov.b   #7, 18h+var_F[sp]
FFF0BB71  b209                              movu.b  18h+var_F[sp], r1
FFF0BB73  63e1                              mul     #0Eh, r1
FFF0BB75  7542ca                            mov.l   #-36h, r2
FFF0BB78  4312                              sub     r1, r2
FFF0BB7A  fd748202                          div     #2, r2
FFF0BB7E  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BB80  ba81                              movu.w  18h+var_4[sp], r1
FFF0BB82  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BB86  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BB88  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BB8C  b20a                              movu.b  18h+var_F[sp], r2
FFF0BB8E  60c0                              sub     #0Ch, sp
FFF0BB90  fb4200abf4ff                      mov.l   #loc_FFF4AB00, r4
FFF0BB96  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BB98  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BB9A  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BB9D  5f12                              movu.w  r1, r2
FFF0BB9F  5f31                              movu.w  r3, r1
FFF0BBA1  6604                              mov.l   #0, r4
FFF0BBA3  66d3                              mov.l   #0Dh, r3
FFF0BBA5  057e5ffe                          bsr.a   sub_FFEF1B23
FFF0BBA9  62c0                              add     #0Ch, sp
FFF0BBAB  6706                              rtsd    #6
FFF0BBAD  3c0908                 loc_FFF0BBAD mov.b   #8, 18h+var_F[sp]
FFF0BBB0  b209                              movu.b  18h+var_F[sp], r1
FFF0BBB2  63e1                              mul     #0Eh, r1
FFF0BBB4  7542ca                            mov.l   #-36h, r2
FFF0BBB7  4312                              sub     r1, r2
FFF0BBB9  fd748202                          div     #2, r2
FFF0BBBD  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BBBF  ba81                              movu.w  18h+var_4[sp], r1
FFF0BBC1  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BBC5  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BBC7  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BBCB  b20a                              movu.b  18h+var_F[sp], r2
FFF0BBCD  60c0                              sub     #0Ch, sp
FFF0BBCF  fb4208abf4ff                      mov.l   #loc_FFF4AB08, r4
FFF0BBD5  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BBD7  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BBD9  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BBDC  5f12                              movu.w  r1, r2
FFF0BBDE  5f31                              movu.w  r3, r1
FFF0BBE0  6604                              mov.l   #0, r4
FFF0BBE2  66d3                              mov.l   #0Dh, r3
FFF0BBE4  053f5ffe                          bsr.a   sub_FFEF1B23
FFF0BBE8  62c0                              add     #0Ch, sp
FFF0BBEA  6706                              rtsd    #6
FFF0BBEC  3c0909                 loc_FFF0BBEC mov.b   #9, 18h+var_F[sp]
FFF0BBEF  b209                              movu.b  18h+var_F[sp], r1
FFF0BBF1  63e1                              mul     #0Eh, r1
FFF0BBF3  7542ca                            mov.l   #-36h, r2
FFF0BBF6  4312                              sub     r1, r2
FFF0BBF8  fd748202                          div     #2, r2
FFF0BBFC  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BBFE  ba81                              movu.w  18h+var_4[sp], r1
FFF0BC00  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BC04  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BC06  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BC0A  b20a                              movu.b  18h+var_F[sp], r2
FFF0BC0C  60c0                              sub     #0Ch, sp
FFF0BC0E  fb4211abf4ff                      mov.l   #loc_FFF4AB11, r4
FFF0BC14  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BC16  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BC18  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BC1B  5f12                              movu.w  r1, r2
FFF0BC1D  5f31                              movu.w  r3, r1
FFF0BC1F  6604                              mov.l   #0, r4
FFF0BC21  66d3                              mov.l   #0Dh, r3
FFF0BC23  05005ffe                          bsr.a   sub_FFEF1B23
FFF0BC27  62c0                              add     #0Ch, sp
FFF0BC29  6706                              rtsd    #6
FFF0BC2B  3c090a                 loc_FFF0BC2B mov.b   #0Ah, 18h+var_F[sp]
FFF0BC2E  b209                              movu.b  18h+var_F[sp], r1
FFF0BC30  63e1                              mul     #0Eh, r1
FFF0BC32  7542ca                            mov.l   #-36h, r2
FFF0BC35  4312                              sub     r1, r2
FFF0BC37  fd748202                          div     #2, r2
FFF0BC3B  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BC3D  ba81                              movu.w  18h+var_4[sp], r1
FFF0BC3F  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BC43  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BC45  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BC49  b20a                              movu.b  18h+var_F[sp], r2
FFF0BC4B  60c0                              sub     #0Ch, sp
FFF0BC4D  fb421babf4ff                      mov.l   #(loc_FFF4AB18+3), r4
FFF0BC53  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BC55  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BC57  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BC5A  5f12                              movu.w  r1, r2
FFF0BC5C  5f31                              movu.w  r3, r1
FFF0BC5E  6604                              mov.l   #0, r4
FFF0BC60  66d3                              mov.l   #0Dh, r3
FFF0BC62  05c15efe                          bsr.a   sub_FFEF1B23
FFF0BC66  62c0                              add     #0Ch, sp
FFF0BC68  6706                              rtsd    #6
FFF0BC6A  3c090c                 loc_FFF0BC6A mov.b   #0Ch, 18h+var_F[sp]
FFF0BC6D  b209                              movu.b  18h+var_F[sp], r1
FFF0BC6F  63e1                              mul     #0Eh, r1
FFF0BC71  7542ca                            mov.l   #-36h, r2
FFF0BC74  4312                              sub     r1, r2
FFF0BC76  fd748202                          div     #2, r2
FFF0BC7A  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BC7C  ba81                              movu.w  18h+var_4[sp], r1
FFF0BC7E  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BC82  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BC84  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BC88  b20a                              movu.b  18h+var_F[sp], r2
FFF0BC8A  60c0                              sub     #0Ch, sp
FFF0BC8C  fb4226abf4ff                      mov.l   #loc_FFF4AB26, r4
FFF0BC92  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BC94  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BC96  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BC99  5f12                              movu.w  r1, r2
FFF0BC9B  5f31                              movu.w  r3, r1
FFF0BC9D  6604                              mov.l   #0, r4
FFF0BC9F  66d3                              mov.l   #0Dh, r3
FFF0BCA1  05825efe                          bsr.a   sub_FFEF1B23
FFF0BCA5  62c0                              add     #0Ch, sp
FFF0BCA7  6706                              rtsd    #6
FFF0BCA9  3c0904                 loc_FFF0BCA9 mov.b   #4, 18h+var_F[sp]
FFF0BCAC  b209                              movu.b  18h+var_F[sp], r1
FFF0BCAE  63e1                              mul     #0Eh, r1
FFF0BCB0  7542ca                            mov.l   #-36h, r2
FFF0BCB3  4312                              sub     r1, r2
FFF0BCB5  fd748202                          div     #2, r2
FFF0BCB9  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BCBB  ba81                              movu.w  18h+var_4[sp], r1
FFF0BCBD  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BCC1  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BCC3  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BCC7  b20a                              movu.b  18h+var_F[sp], r2
FFF0BCC9  60c0                              sub     #0Ch, sp
FFF0BCCB  fb4233abf4ff                      mov.l   #loc_FFF4AB33, r4
FFF0BCD1  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BCD3  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BCD5  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BCD8  5f12                              movu.w  r1, r2
FFF0BCDA  5f31                              movu.w  r3, r1
FFF0BCDC  6604                              mov.l   #0, r4
FFF0BCDE  66d3                              mov.l   #0Dh, r3
FFF0BCE0  05435efe                          bsr.a   sub_FFEF1B23
FFF0BCE4  62c0                              add     #0Ch, sp
FFF0BCE6  6706                              rtsd    #6
FFF0BCE8  3c0906                 loc_FFF0BCE8 mov.b   #6, 18h+var_F[sp]
FFF0BCEB  b209                              movu.b  18h+var_F[sp], r1
FFF0BCED  63e1                              mul     #0Eh, r1
FFF0BCEF  7542ca                            mov.l   #-36h, r2
FFF0BCF2  4312                              sub     r1, r2
FFF0BCF4  fd748202                          div     #2, r2
FFF0BCF8  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BCFA  ba81                              movu.w  18h+var_4[sp], r1
FFF0BCFC  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BD00  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BD02  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BD06  b20a                              movu.b  18h+var_F[sp], r2
FFF0BD08  60c0                              sub     #0Ch, sp
FFF0BD0A  fb4238abf4ff                      mov.l   #loc_FFF4AB38, r4
FFF0BD10  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BD12  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BD14  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BD17  5f12                              movu.w  r1, r2
FFF0BD19  5f31                              movu.w  r3, r1
FFF0BD1B  6604                              mov.l   #0, r4
FFF0BD1D  66d3                              mov.l   #0Dh, r3
FFF0BD1F  05045efe                          bsr.a   sub_FFEF1B23
FFF0BD23  62c0                              add     #0Ch, sp
FFF0BD25  6706                              rtsd    #6
FFF0BD27  3c090a                 loc_FFF0BD27 mov.b   #0Ah, 18h+var_F[sp]
FFF0BD2A  b209                              movu.b  18h+var_F[sp], r1
FFF0BD2C  63e1                              mul     #0Eh, r1
FFF0BD2E  7542ca                            mov.l   #-36h, r2
FFF0BD31  4312                              sub     r1, r2
FFF0BD33  fd748202                          div     #2, r2
FFF0BD37  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BD39  ba81                              movu.w  18h+var_4[sp], r1
FFF0BD3B  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BD3F  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BD41  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BD45  b20a                              movu.b  18h+var_F[sp], r2
FFF0BD47  60c0                              sub     #0Ch, sp
FFF0BD49  fb423fabf4ff                      mov.l   #loc_FFF4AB3F, r4
FFF0BD4F  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BD51  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BD53  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BD56  5f12                              movu.w  r1, r2
FFF0BD58  5f31                              movu.w  r3, r1
FFF0BD5A  6604                              mov.l   #0, r4
FFF0BD5C  66d3                              mov.l   #0Dh, r3
FFF0BD5E  05c55dfe                          bsr.a   sub_FFEF1B23
FFF0BD62  62c0                              add     #0Ch, sp
FFF0BD64  6706                              rtsd    #6
FFF0BD66  3d060d                 loc_FFF0BD66 mov.w   #0Dh, 18h+var_C[sp]
FFF0BD69  3d0509                            mov.w   #9, 18h+var_E[sp]
FFF0BD6C  ba81                              movu.w  18h+var_4[sp], r1
FFF0BD6E  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BD72  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BD74  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BD78  5f12                              movu.w  r1, r2
FFF0BD7A  5f31                              movu.w  r3, r1
FFF0BD7C  fb420c2fedff                      mov.l   #unk_FFED2F0C, r4
FFF0BD82  6613                              mov.l   #1, r3
FFF0BD84  0551abfe                          bsr.a   sub_FFEF68D5
FFF0BD88  6706                              rtsd    #6
FFF0BD8A  3d0618                 loc_FFF0BD8A mov.w   #18h, 18h+var_C[sp]
FFF0BD8D  3d0509                            mov.w   #9, 18h+var_E[sp]
FFF0BD90  ba81                              movu.w  18h+var_4[sp], r1
FFF0BD92  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BD96  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BD98  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BD9C  5f12                              movu.w  r1, r2
FFF0BD9E  5f31                              movu.w  r3, r1
FFF0BDA0  fb42fc2eedff                      mov.l   #unk_FFED2EFC, r4
FFF0BDA6  6613                              mov.l   #1, r3
FFF0BDA8  052dabfe                          bsr.a   sub_FFEF68D5
FFF0BDAC  6706                              rtsd    #6
FFF0BDAE  3c0909                 loc_FFF0BDAE mov.b   #9, 18h+var_F[sp]
FFF0BDB1  b209                              movu.b  18h+var_F[sp], r1
FFF0BDB3  63e1                              mul     #0Eh, r1
FFF0BDB5  7542ca                            mov.l   #-36h, r2
FFF0BDB8  4312                              sub     r1, r2
FFF0BDBA  fd748202                          div     #2, r2
FFF0BDBE  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BDC0  ba81                              movu.w  18h+var_4[sp], r1
FFF0BDC2  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BDC6  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BDC8  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BDCC  b20a                              movu.b  18h+var_F[sp], r2
FFF0BDCE  60c0                              sub     #0Ch, sp
FFF0BDD0  fb424aabf4ff                      mov.l   #loc_FFF4AB4A, r4
FFF0BDD6  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BDD8  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BDDA  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BDDD  5f12                              movu.w  r1, r2
FFF0BDDF  5f31                              movu.w  r3, r1
FFF0BDE1  6604                              mov.l   #0, r4
FFF0BDE3  66d3                              mov.l   #0Dh, r3
FFF0BDE5  053e5dfe                          bsr.a   sub_FFEF1B23
FFF0BDE9  62c0                              add     #0Ch, sp
FFF0BDEB  6706                              rtsd    #6
FFF0BDED  3c0909                 loc_FFF0BDED mov.b   #9, 18h+var_F[sp]
FFF0BDF0  b209                              movu.b  18h+var_F[sp], r1
FFF0BDF2  63e1                              mul     #0Eh, r1
FFF0BDF4  7542ca                            mov.l   #-36h, r2
FFF0BDF7  4312                              sub     r1, r2
FFF0BDF9  fd748202                          div     #2, r2
FFF0BDFD  9182                              mov.w   r2, 18h+var_C[sp]
FFF0BDFF  ba81                              movu.w  18h+var_4[sp], r1
FFF0BE01  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BE05  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BE07  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BE0B  b20a                              movu.b  18h+var_F[sp], r2
FFF0BE0D  60c0                              sub     #0Ch, sp
FFF0BE0F  fb4254abf4ff                      mov.l   #sub_FFF4AB54, r4
FFF0BE15  a00c                              mov.l   r4, 24h+var_20[sp]
FFF0BE17  c302                              mov.b   r2, 24h+var_24[sp]
FFF0BE19  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BE1C  5f12                              movu.w  r1, r2
FFF0BE1E  5f31                              movu.w  r3, r1
FFF0BE20  6604                              mov.l   #0, r4
FFF0BE22  66d3                              mov.l   #0Dh, r3
FFF0BE24  05ff5cfe                          bsr.a   sub_FFEF1B23
FFF0BE28  62c0                              add     #0Ch, sp
FFF0BE2A  6706                              rtsd    #6
FFF0BE2C  6706                   loc_FFF0BE2C rtsd    #6

; ######## sub_FFF3B8DE  FFF3B8DE-FFF3BA24 (file 33B8DE) callers: FFF3FC7B(sub_FFF3FC53), FFF3FD40(sub_FFF3FC53)
FFF3B8DE  7100d4                 sub_FFF3B8DE add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF3B8DE
FFF3B8E1  6601                              mov.l   #0, r1
FFF3B8E3  9509                              mov.w   r1, 2Ch+var_2[sp]
FFF3B8E5  9501                              mov.w   r1, 2Ch+var_4[sp]
FFF3B8E7  9489                              mov.w   r1, 2Ch+var_6[sp]
FFF3B8E9  f9042501                          mov.b   #1, 2Ch+var_7[sp]
FFF3B8ED  6601                              mov.l   #0, r1
FFF3B8EF  a201                              mov.l   r1, 2Ch+var_C[sp]
FFF3B8F1  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF3B8F3  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF3B8F5  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF3B8F7  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF3B8F9  fb1258250100                      mov.l   #12558h, r1
FFF3B8FF  6602                              mov.l   #0, r2
FFF3B901  9212                              mov.w   r2, 10h[r1]
FFF3B903  a09a                              mov.l   r2, 0Ch[r1]
FFF3B905  a092                              mov.l   r2, 8[r1]
FFF3B907  a01a                              mov.l   r2, 4[r1]
FFF3B909  e312                              mov.l   r2, [r1]
FFF3B90B  fbe29b220100                      mov.l   #1229Bh, r14
FFF3B911  58ee                              movu.b  [r14], r14
FFF3B913  611e                              cmp     #1, r14
FFF3B915  3b0d01                            bne.w   loc_FFF3BA22
FFF3B918  051e83ff                          bsr.a   sub_FFF33C36
FFF3B91C  710110                            add     #2Ch+var_1C, sp, r1
FFF3B91F  05f971fd                          bsr.a   sub_FFF12B18
FFF3B923  9489                              mov.w   r1, 2Ch+var_6[sp]
FFF3B925  bc89                              movu.w  2Ch+var_6[sp], r1
FFF3B927  6101                              cmp     #0, r1
FFF3B929  2152                              bne.b   loc_FFF3B97B
FFF3B92B  fbe26c250100                      mov.l   #1256Ch, r14
FFF3B931  d10e08                            mov.w   2Ch+var_1C[sp], [r14]
FFF3B934  2e47                              bra.b   loc_FFF3B97B
FFF3B936  fb1262080100           loc_FFF3B936 mov.l   #10862h, r1
FFF3B93C  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3B942  e0e1                              mov.l   [r14], [r1]
FFF3B944  fbe21883edff                      mov.l   #pathtab_bare, r14
FFF3B94A  bd0a                              movu.w  2Ch+var_2[sp], r2
FFF3B94C  fe62ee                            mov.l   [r2, r14], r14
FFF3B94F  fb36ff                            mov.l   #-1, r3
FFF3B952  6602                              mov.l   #0, r2
FFF3B954  7f80                              suntil.b
FFF3B956  6011                              sub     #1, r1
FFF3B958  efe2                              mov.l   r14, r2
FFF3B95A  7f87                              smovu
FFF3B95C  fb1262080100                      mov.l   #10862h, r1
FFF3B962  059772fd                          bsr.a   sub_FFF12BF9
FFF3B966  c70125                            mov.b   r1, 2Ch+var_7[sp]
FFF3B969  590125                            movu.b  2Ch+var_7[sp], r1
FFF3B96C  6111                              cmp     #1, r1
FFF3B96E  17                                beq.s   loc_FFF3B975
FFF3B96F  9d01                              mov.w   2Ch+var_4[sp], r1
FFF3B971  6211                              add     #1, r1
FFF3B973  9501                              mov.w   r1, 2Ch+var_4[sp]
FFF3B975  9d09                   loc_FFF3B975 mov.w   2Ch+var_2[sp], r1
FFF3B977  6211                              add     #1, r1
FFF3B979  9509                              mov.w   r1, 2Ch+var_2[sp]
FFF3B97B  fbe21883edff           loc_FFF3B97B mov.l   #pathtab_bare, r14
FFF3B981  bd09                              movu.w  2Ch+var_2[sp], r1
FFF3B983  fe61ee                            mov.l   [r1, r14], r14
FFF3B986  610e                              cmp     #0, r14
FFF3B988  21ae                              bne.b   loc_FFF3B936
FFF3B98A  fb1258250100                      mov.l   #12558h, r1
FFF3B990  3d1090                            mov.w   #-70h, [r1]
FFF3B993  fb1258250100                      mov.l   #12558h, r1
FFF3B999  3d1101                            mov.w   #1, 2[r1]
FFF3B99C  fb1258250100                      mov.l   #12558h, r1
FFF3B9A2  3d1300                            mov.w   #0, 6[r1]
FFF3B9A5  fbe258250100                      mov.l   #12558h, r14
FFF3B9AB  fbf26c250100                      mov.l   #1256Ch, r15
FFF3B9B1  d4fe02                            mov.w   [r15], 4[r14]
FFF3B9B4  bd01                              movu.w  2Ch+var_4[sp], r1
FFF3B9B6  6101                              cmp     #0, r1
FFF3B9B8  200c                              beq.b   loc_FFF3B9C4
FFF3B9BA  fb12d0830600                      mov.l   #683D0h, r1
FFF3B9C0  3d10c9                            mov.w   #-37h, [r1]
FFF3B9C3  0a                                bra.s   loc_FFF3B9CD
FFF3B9C4  fb12d0830600           loc_FFF3B9C4 mov.l   #683D0h, r1
FFF3B9CA  3d10c8                            mov.w   #-38h, [r1]
FFF3B9CD  fb12d0830600           loc_FFF3B9CD mov.l   #683D0h, r1
FFF3B9D3  3d1c00                            mov.w   #0, 18h[r1]
FFF3B9D6  7100c8                            add     #-38h, sp, sp
FFF3B9D9  754312                            mov.l   #12h, r3
FFF3B9DC  fb2258250100                      mov.l   #12558h, r2
FFF3B9E2  ef01                              mov.l   sp, r1
FFF3B9E4  7f8f                              smovf
FFF3B9E6  ef01                              mov.l   sp, r1
FFF3B9E8  711114                            add     #14h, r1, r1
FFF3B9EB  754324                            mov.l   #24h, r3 ; '$'
FFF3B9EE  fb22d0830600                      mov.l   #683D0h, r2
FFF3B9F4  7f8f                              smovf
FFF3B9F6  6602                              mov.l   #0, r2
FFF3B9F8  7541fe                            mov.l   #-2, r1
FFF3B9FB  05e11efa                          bsr.a   sub_FFEDD8DC
FFF3B9FF  710038                            add     #38h, sp, sp ; '8'
FFF3BA02  f80400                            mov.b   #0, 2Ch+var_2C[sp]
FFF3BA05  3e0100                            mov.l   #0, 2Ch+var_28[sp]
FFF3BA08  3e0200                            mov.l   #0, 2Ch+var_24[sp]
FFF3BA0B  ef03                              mov.l   sp, r3
FFF3BA0D  6642                              mov.l   #4, r2
FFF3BA0F  754149                            mov.l   #49h, r1 ; 'I'
FFF3BA12  05b4a0fe                          bsr.a   sub_FFF25AC6
FFF3BA16  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF3BA18  a889                              mov.l   2Ch+var_20[sp], r1
FFF3BA1A  6101                              cmp     #0, r1
FFF3BA1C  1e                                bne.s   loc_FFF3BA22
FFF3BA1D  39c93f                            bsr.w   sub_FFF3F9E6
FFF3BA20  670b                              rtsd    #0Bh
FFF3BA22  670b                   loc_FFF3BA22 rtsd    #0Bh

; ######## sub_FFF12A8F  FFF12A8F-FFF12B18 (file 312A8F) callers: FFF3D5F7(sub_FFF3D556)
FFF12A8F  7100e8                 sub_FFF12A8F add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12A8F
FFF12A92  3d0a00                            mov.w   #0, 18h+var_4[sp]
FFF12A95  3d0900                            mov.w   #0, 18h+var_6[sp]
FFF12A98  3c8100                            mov.b   #0, 18h+var_7[sp]
FFF12A9B  3c8000                            mov.b   #0, 18h+var_8[sp]
FFF12A9E  754149                            mov.l   #49h, r1 ; 'I'
FFF12AA1  050c6a01                          bsr.a   sub_FFF294AD
FFF12AA5  8409                              mov.b   r1, 18h+var_7[sp]
FFF12AA7  8c09                              mov.b   18h+var_7[sp], r1
FFF12AA9  6101                              cmp     #0, r1
FFF12AAB  10                                beq.s   loc_FFF12AB3
FFF12AAC  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12AB1  2e5f                              bra.b   loc_FFF12B10
FFF12AB3  3c0400                 loc_FFF12AB3 mov.b   #0, 18h+var_14[sp]
FFF12AB6  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12AB9  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF12ABC  710304                            add     #18h+var_14, sp, r3
FFF12ABF  6642                              mov.l   #4, r2
FFF12AC1  754149                            mov.l   #49h, r1 ; 'I'
FFF12AC4  05023001                          bsr.a   sub_FFF25AC6
FFF12AC8  2e36                              bra.b   loc_FFF12AFE
FFF12ACA  fbe2907eedff           loc_FFF12ACA mov.l   #pathtab_drive, r14
FFF12AD0  8c01                              mov.b   18h+var_8[sp], r1
FFF12AD2  fe61e1                            mov.l   [r1, r14], r1
FFF12AD5  39d800                            bsr.w   sub_FFF12BAD
FFF12AD8  9281                              mov.w   r1, 18h+var_4[sp]
FFF12ADA  ba81                              movu.w  18h+var_4[sp], r1
FFF12ADC  6101                              cmp     #0, r1
FFF12ADE  10                                beq.s   loc_FFF12AE6
FFF12ADF  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12AE4  2e2c                              bra.b   loc_FFF12B10
FFF12AE6  3d0900                 loc_FFF12AE6 mov.w   #0, 18h+var_6[sp]
FFF12AE9  0f                                bra.s   loc_FFF12AF0
FFF12AEA  9a09                   loc_FFF12AEA mov.w   18h+var_6[sp], r1
FFF12AEC  6211                              add     #1, r1
FFF12AEE  9209                              mov.w   r1, 18h+var_6[sp]
FFF12AF0  ba09                   loc_FFF12AF0 movu.w  18h+var_6[sp], r1
FFF12AF2  76010020                          cmp     #2000h, r1
FFF12AF6  29f4                              blt.b   loc_FFF12AEA
FFF12AF8  b401                              movu.b  18h+var_8[sp], r1
FFF12AFA  6211                              add     #1, r1
FFF12AFC  8401                              mov.b   r1, 18h+var_8[sp]
FFF12AFE  fbe2907eedff           loc_FFF12AFE mov.l   #pathtab_drive, r14
FFF12B04  8c01                              mov.b   18h+var_8[sp], r1
FFF12B06  fe61ee                            mov.l   [r1, r14], r14
FFF12B09  610e                              cmp     #0, r14
FFF12B0B  21bf                              bne.b   loc_FFF12ACA
FFF12B0D  3d0100                            mov.w   #0, 18h+var_16[sp]
FFF12B10  d500010b               loc_FFF12B10 mov.w   18h+var_16[sp], 18h+var_2[sp]
FFF12B14  ba89                              movu.w  18h+var_2[sp], r1
FFF12B16  6706                              rtsd    #6

; ######## sub_FFF3C765  FFF3C765-FFF3C911 (file 33C765) callers: FFF3C6ED(sub_FFF3C4BC)
FFF3C765  7ea6                   sub_FFF3C765 push.l  r6   ; <<<< FUNC sub_FFF3C765
FFF3C767  7100e0                            add     #-20h, sp, sp
FFF3C76A  8789                              mov.b   r1, 20h+var_1[sp]
FFF3C76C  3d0d00                            mov.w   #0, 20h+var_6[sp]
FFF3C76F  710628                            add     #20h+arg_0, sp, r6
FFF3C772  fb1258250100                      mov.l   #12558h, r1
FFF3C778  6602                              mov.l   #0, r2
FFF3C77A  9212                              mov.w   r2, 10h[r1]
FFF3C77C  a09a                              mov.l   r2, 0Ch[r1]
FFF3C77E  a092                              mov.l   r2, 8[r1]
FFF3C780  a01a                              mov.l   r2, 4[r1]
FFF3C782  e312                              mov.l   r2, [r1]
FFF3C784  f809ffff                          mov.w   #-1, 20h+var_20[sp]
FFF3C788  fb1262080100                      mov.l   #10862h, r1
FFF3C78E  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3C794  e0e1                              mov.l   [r14], [r1]
FFF3C796  a8e4                              mov.l   8[r6], r4
FFF3C798  fb36ff                            mov.l   #-1, r3
FFF3C79B  6602                              mov.l   #0, r2
FFF3C79D  7f80                              suntil.b
FFF3C79F  6011                              sub     #1, r1
FFF3C7A1  ef42                              mov.l   r4, r2
FFF3C7A3  7f87                              smovu
FFF3C7A5  fbe6ff                            mov.l   #-1, r14
FFF3C7A8  660f                              mov.l   #0, r15
FFF3C7AA  fb5262080100                      mov.l   #10862h, r5
FFF3C7B0  ef51                              mov.l   r5, r1
FFF3C7B2  eff2                              mov.l   r15, r2
FFF3C7B4  efe3                              mov.l   r14, r3
FFF3C7B6  7f80                              suntil.b
FFF3C7B8  6011                              sub     #1, r1
FFF3C7BA  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3C7C0  7f87                              smovu
FFF3C7C2  a8ec                              mov.l   0Ch[r6], r4
FFF3C7C4  ef51                              mov.l   r5, r1
FFF3C7C6  eff2                              mov.l   r15, r2
FFF3C7C8  efe3                              mov.l   r14, r3
FFF3C7CA  7f80                              suntil.b
FFF3C7CC  6011                              sub     #1, r1
FFF3C7CE  ef42                              mov.l   r4, r2
FFF3C7D0  7f87                              smovu
FFF3C7D2  fb1262080100                      mov.l   #10862h, r1
FFF3C7D8  a009                              mov.l   r1, 20h+var_1C[sp]
FFF3C7DA  e5600502                          mov.l   14h[r6], 20h+var_18[sp]
FFF3C7DE  e5600803                          mov.l   20h[r6], 20h+var_14[sp]
FFF3C7E2  e5600404                          mov.l   10h[r6], 20h+var_10[sp]
FFF3C7E6  754312                            mov.l   #12h, r3
FFF3C7E9  fb2234250100                      mov.l   #12534h, r2
FFF3C7EF  fb1258250100                      mov.l   #12558h, r1
FFF3C7F5  7f8f                              smovf
FFF3C7F7  5c6e                              movu.w  [r6], r14
FFF3C7F9  71effb                            add     #-5, r14, r15
FFF3C7FC  615f                              cmp     #5, r15
FFF3C7FE  2335                              bltu.b  loc_FFF3C833
FFF3C800  612e                              cmp     #2, r14
FFF3C802  2017                              beq.b   loc_FFF3C819
FFF3C804  613e                              cmp     #3, r14
FFF3C806  2020                              beq.b   loc_FFF3C826
FFF3C808  611e                              cmp     #1, r14
FFF3C80A  2135                              bne.b   loc_FFF3C83F
FFF3C80C  3d0a00                            mov.w   #0, 20h+var_C[sp]
FFF3C80F  ef01                              mov.l   sp, r1
FFF3C811  051464fd                          bsr.a   sub_FFF12C25
FFF3C815  9309                              mov.w   r1, 20h+var_6[sp]
FFF3C817  2e2d                              bra.b   loc_FFF3C844
FFF3C819  3d0a01                 loc_FFF3C819 mov.w   #1, 20h+var_C[sp]
FFF3C81C  ef01                              mov.l   sp, r1
FFF3C81E  050764fd                          bsr.a   sub_FFF12C25
FFF3C822  9309                              mov.w   r1, 20h+var_6[sp]
FFF3C824  2e20                              bra.b   loc_FFF3C844
FFF3C826  3d0a02                 loc_FFF3C826 mov.w   #2, 20h+var_C[sp]
FFF3C829  ef01                              mov.l   sp, r1
FFF3C82B  05fa63fd                          bsr.a   sub_FFF12C25
FFF3C82F  9309                              mov.w   r1, 20h+var_6[sp]
FFF3C831  2e13                              bra.b   loc_FFF3C844
FFF3C833  d4600a                 loc_FFF3C833 mov.w   [r6], 20h+var_C[sp]
FFF3C836  ef01                              mov.l   sp, r1
FFF3C838  055d65fd                          bsr.a   sub_FFF12D95
FFF3C83C  9309                              mov.w   r1, 20h+var_6[sp]
FFF3C83E  0e                                bra.s   loc_FFF3C844
FFF3C83F  f9090dffff             loc_FFF3C83F mov.w   #-1, 20h+var_6[sp]
FFF3C844  bb09                   loc_FFF3C844 movu.w  20h+var_6[sp], r1
FFF3C846  6101                              cmp     #0, r1
FFF3C848  205b                              beq.b   loc_FFF3C8A3
FFF3C84A  fbe258250100                      mov.l   #12558h, r14
FFF3C850  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3C855  fb1258250100                      mov.l   #12558h, r1
FFF3C85B  3d1090                            mov.w   #-70h, [r1]
FFF3C85E  fb1258250100                      mov.l   #12558h, r1
FFF3C864  3d1101                            mov.w   #1, 2[r1]
FFF3C867  fbe258250100                      mov.l   #12558h, r14
FFF3C86D  fbf26c250100                      mov.l   #1256Ch, r15
FFF3C873  d4fe02                            mov.w   [r15], 4[r14]
FFF3C876  3d6c00                            mov.w   #0, 18h[r6]
FFF3C879  7100c8                            add     #-38h, sp, sp
FFF3C87C  754312                            mov.l   #12h, r3
FFF3C87F  fb2258250100                      mov.l   #12558h, r2
FFF3C885  ef01                              mov.l   sp, r1
FFF3C887  7f8f                              smovf
FFF3C889  ef01                              mov.l   sp, r1
FFF3C88B  711114                            add     #14h, r1, r1
FFF3C88E  754324                            mov.l   #24h, r3 ; '$'
FFF3C891  ef62                              mov.l   r6, r2
FFF3C893  7f8f                              smovf
FFF3C895  6602                              mov.l   #0, r2
FFF3C897  7541fe                            mov.l   #-2, r1
FFF3C89A  054210fa                          bsr.a   sub_FFEDD8DC
FFF3C89E  710038                            add     #38h, sp, sp ; '8'
FFF3C8A1  2e65                              bra.b   loc_FFF3C906
FFF3C8A3  fbe234250100           loc_FFF3C8A3 mov.l   #12534h, r14
FFF3C8A9  b789                              movu.b  20h+var_1[sp], r1
FFF3C8AB  06c5e101                          cmp     2[r14].uw, r1
FFF3C8AF  2157                              bne.b   loc_FFF3C906
FFF3C8B1  fb1258250100                      mov.l   #12558h, r1
FFF3C8B7  3d1300                            mov.w   #0, 6[r1]
FFF3C8BA  fb1258250100                      mov.l   #12558h, r1
FFF3C8C0  3d1090                            mov.w   #-70h, [r1]
FFF3C8C3  fb1258250100                      mov.l   #12558h, r1
FFF3C8C9  3d1101                            mov.w   #1, 2[r1]
FFF3C8CC  fbe258250100                      mov.l   #12558h, r14
FFF3C8D2  fbf26c250100                      mov.l   #1256Ch, r15
FFF3C8D8  d4fe02                            mov.w   [r15], 4[r14]
FFF3C8DB  3d6c00                            mov.w   #0, 18h[r6]
FFF3C8DE  7100c8                            add     #-38h, sp, sp
FFF3C8E1  754312                            mov.l   #12h, r3
FFF3C8E4  fb2258250100                      mov.l   #12558h, r2
FFF3C8EA  ef01                              mov.l   sp, r1
FFF3C8EC  7f8f                              smovf
FFF3C8EE  ef01                              mov.l   sp, r1
FFF3C8F0  711114                            add     #14h, r1, r1
FFF3C8F3  754324                            mov.l   #24h, r3 ; '$'
FFF3C8F6  ef62                              mov.l   r6, r2
FFF3C8F8  7f8f                              smovf
FFF3C8FA  6602                              mov.l   #0, r2
FFF3C8FC  7541fe                            mov.l   #-2, r1
FFF3C8FF  05dd0ffa                          bsr.a   sub_FFEDD8DC
FFF3C903  710038                            add     #38h, sp, sp ; '8'
FFF3C906  d5000d0e               loc_FFF3C906 mov.w   20h+var_6[sp], 20h+var_4[sp]
FFF3C90A  9b81                              mov.w   20h+var_4[sp], r1
FFF3C90C  5f11                              movu.w  r1, r1
FFF3C90E  3f6609                            rtsd    #24h, r6-r6

; ######## sub_FFF3C911  FFF3C911-FFF3CAD0 (file 33C911) callers: FFF3C740(sub_FFF3C4BC)
FFF3C911  7ea6                   sub_FFF3C911 push.l  r6   ; <<<< FUNC sub_FFF3C911
FFF3C913  7100d4                            add     #-2Ch, sp, sp
FFF3C916  3d8400                            mov.w   #0, 2Ch+var_4[sp]
FFF3C919  710634                            add     #2Ch+arg_0, sp, r6
FFF3C91C  f9042700                          mov.b   #0, 2Ch+var_5[sp]
FFF3C920  fb1258250100                      mov.l   #12558h, r1
FFF3C926  6602                              mov.l   #0, r2
FFF3C928  9212                              mov.w   r2, 10h[r1]
FFF3C92A  a09a                              mov.l   r2, 0Ch[r1]
FFF3C92C  a092                              mov.l   r2, 8[r1]
FFF3C92E  a01a                              mov.l   r2, 4[r1]
FFF3C930  e312                              mov.l   r2, [r1]
FFF3C932  754312                            mov.l   #12h, r3
FFF3C935  fb2234250100                      mov.l   #12534h, r2
FFF3C93B  fb1258250100                      mov.l   #12558h, r1
FFF3C941  7f8f                              smovf
FFF3C943  71011c                            add     #2Ch+var_10, sp, r1
FFF3C946  05f41ffa                          bsr.a   sub_FFEDE93A
FFF3C94A  c70127                            mov.b   r1, 2Ch+var_5[sp]
FFF3C94D  590127                            movu.b  2Ch+var_5[sp], r1
FFF3C950  6111                              cmp     #1, r1
FFF3C952  2061                              beq.b   loc_FFF3C9B3
FFF3C954  fbe258250100                      mov.l   #12558h, r14
FFF3C95A  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3C95F  fb1258250100                      mov.l   #12558h, r1
FFF3C965  3d1090                            mov.w   #-70h, [r1]
FFF3C968  fb1258250100                      mov.l   #12558h, r1
FFF3C96E  3d1101                            mov.w   #1, 2[r1]
FFF3C971  fbe258250100                      mov.l   #12558h, r14
FFF3C977  fbf26c250100                      mov.l   #1256Ch, r15
FFF3C97D  d4fe02                            mov.w   [r15], 4[r14]
FFF3C980  3d6c00                            mov.w   #0, 18h[r6]
FFF3C983  7100c8                            add     #-38h, sp, sp
FFF3C986  754312                            mov.l   #12h, r3
FFF3C989  fb2258250100                      mov.l   #12558h, r2
FFF3C98F  ef01                              mov.l   sp, r1
FFF3C991  7f8f                              smovf
FFF3C993  ef01                              mov.l   sp, r1
FFF3C995  711114                            add     #14h, r1, r1
FFF3C998  754324                            mov.l   #24h, r3 ; '$'
FFF3C99B  ef62                              mov.l   r6, r2
FFF3C99D  7f8f                              smovf
FFF3C99F  6602                              mov.l   #0, r2
FFF3C9A1  7541fe                            mov.l   #-2, r1
FFF3C9A4  05380ffa                          bsr.a   sub_FFEDD8DC
FFF3C9A8  710038                            add     #38h, sp, sp ; '8'
FFF3C9AB  f90901ffff                        mov.w   #-1, 2Ch+var_2A[sp]
FFF3C9B0  381701                            bra.w   loc_FFF3CAC7
FFF3C9B3  fb1258250100           loc_FFF3C9B3 mov.l   #12558h, r1
FFF3C9B9  6602                              mov.l   #0, r2
FFF3C9BB  9212                              mov.w   r2, 10h[r1]
FFF3C9BD  a09a                              mov.l   r2, 0Ch[r1]
FFF3C9BF  a092                              mov.l   r2, 8[r1]
FFF3C9C1  a01a                              mov.l   r2, 4[r1]
FFF3C9C3  e312                              mov.l   r2, [r1]
FFF3C9C5  6601                              mov.l   #0, r1
FFF3C9C7  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF3C9C9  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF3C9CB  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF3C9CD  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF3C9CF  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF3C9D1  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF3C9D3  f90902ffff                        mov.w   #-1, 2Ch+var_28[sp]
FFF3C9D8  fbe262080100                      mov.l   #10862h, r14
FFF3C9DE  fbf2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r15
FFF3C9E4  e0fe                              mov.l   [r15], [r14]
FFF3C9E6  a8e4                              mov.l   8[r6], r4
FFF3C9E8  fb36ff                            mov.l   #-1, r3
FFF3C9EB  6602                              mov.l   #0, r2
FFF3C9ED  fb1262080100                      mov.l   #10862h, r1
FFF3C9F3  7f80                              suntil.b
FFF3C9F5  6011                              sub     #1, r1
FFF3C9F7  ef42                              mov.l   r4, r2
FFF3C9F9  7f87                              smovu
FFF3C9FB  fb36ff                            mov.l   #-1, r3
FFF3C9FE  6602                              mov.l   #0, r2
FFF3CA00  fb1262080100                      mov.l   #10862h, r1
FFF3CA06  7f80                              suntil.b
FFF3CA08  6011                              sub     #1, r1
FFF3CA0A  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3CA10  7f87                              smovu
FFF3CA12  a8ec                              mov.l   0Ch[r6], r4
FFF3CA14  fb36ff                            mov.l   #-1, r3
FFF3CA17  6602                              mov.l   #0, r2
FFF3CA19  fb1262080100                      mov.l   #10862h, r1
FFF3CA1F  7f80                              suntil.b
FFF3CA21  6011                              sub     #1, r1
FFF3CA23  ef42                              mov.l   r4, r2
FFF3CA25  7f87                              smovu
FFF3CA27  fb1262080100                      mov.l   #10862h, r1
FFF3CA2D  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF3CA2F  e5600503                          mov.l   14h[r6], 2Ch+var_20[sp]
FFF3CA33  e5000704                          mov.l   2Ch+var_10[sp], 2Ch+var_1C[sp]
FFF3CA37  e5600405                          mov.l   10h[r6], 2Ch+var_18[sp]
FFF3CA3B  5c6e                              movu.w  [r6], r14
FFF3CA3D  613e                              cmp     #3, r14
FFF3CA3F  2011                              beq.b   loc_FFF3CA50
FFF3CA41  612e                              cmp     #2, r14
FFF3CA43  11                                beq.s   loc_FFF3CA4C
FFF3CA44  611e                              cmp     #1, r14
FFF3CA46  210d                              bne.b   loc_FFF3CA53
FFF3CA48  3d0c00                            mov.w   #0, 2Ch+var_14[sp]
FFF3CA4B  08                                bra.s   loc_FFF3CA53
FFF3CA4C  3d0c01                 loc_FFF3CA4C mov.w   #1, 2Ch+var_14[sp]
FFF3CA4F  0c                                bra.s   loc_FFF3CA53
FFF3CA50  3d0c02                 loc_FFF3CA50 mov.w   #2, 2Ch+var_14[sp]
FFF3CA53  710104                 loc_FFF3CA53 add     #2Ch+var_28, sp, r1
FFF3CA56  05cf61fd                          bsr.a   sub_FFF12C25
FFF3CA5A  9501                              mov.w   r1, 2Ch+var_4[sp]
FFF3CA5C  bd01                              movu.w  2Ch+var_4[sp], r1
FFF3CA5E  6101                              cmp     #0, r1
FFF3CA60  200e                              beq.b   loc_FFF3CA6E
FFF3CA62  fbe258250100                      mov.l   #12558h, r14
FFF3CA68  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3CA6D  0a                                bra.s   loc_FFF3CA77
FFF3CA6E  fb1258250100           loc_FFF3CA6E mov.l   #12558h, r1
FFF3CA74  3d1300                            mov.w   #0, 6[r1]
FFF3CA77  fb1258250100           loc_FFF3CA77 mov.l   #12558h, r1
FFF3CA7D  3d1090                            mov.w   #-70h, [r1]
FFF3CA80  fb1258250100                      mov.l   #12558h, r1
FFF3CA86  3d1101                            mov.w   #1, 2[r1]
FFF3CA89  fbe258250100                      mov.l   #12558h, r14
FFF3CA8F  fbf26c250100                      mov.l   #1256Ch, r15
FFF3CA95  d4fe02                            mov.w   [r15], 4[r14]
FFF3CA98  3d6c00                            mov.w   #0, 18h[r6]
FFF3CA9B  7100c8                            add     #-38h, sp, sp
FFF3CA9E  754312                            mov.l   #12h, r3
FFF3CAA1  fb2258250100                      mov.l   #12558h, r2
FFF3CAA7  ef01                              mov.l   sp, r1
FFF3CAA9  7f8f                              smovf
FFF3CAAB  ef01                              mov.l   sp, r1
FFF3CAAD  711114                            add     #14h, r1, r1
FFF3CAB0  754324                            mov.l   #24h, r3 ; '$'
FFF3CAB3  ef62                              mov.l   r6, r2
FFF3CAB5  7f8f                              smovf
FFF3CAB7  6602                              mov.l   #0, r2
FFF3CAB9  7541fe                            mov.l   #-2, r1
FFF3CABC  05200efa                          bsr.a   sub_FFEDD8DC
FFF3CAC0  710038                            add     #38h, sp, sp ; '8'
FFF3CAC3  d5001401                          mov.w   2Ch+var_4[sp], 2Ch+var_2A[sp]
FFF3CAC7  d5000115               loc_FFF3CAC7 mov.w   2Ch+var_2A[sp], 2Ch+var_2[sp]
FFF3CACB  bd09                              movu.w  2Ch+var_2[sp], r1
FFF3CACD  3f660c                            rtsd    #30h, r6-r6

; ######## sub_FFF3CAD0  FFF3CAD0-FFF3CE12 (file 33CAD0) callers: FFF3C6AB(sub_FFF3C4BC)
FFF3CAD0  7ea6                   sub_FFF3CAD0 push.l  r6   ; <<<< FUNC sub_FFF3CAD0
FFF3CAD2  7200bcfb                          add     #-444h, sp, sp
FFF3CAD6  fa05200200                        mov.w   #0, 444h+var_4[sp]
FFF3CADB  fa051f0200                        mov.w   #0, 444h+var_6[sp]
FFF3CAE0  72064c04                          add     #444h+arg_0, sp, r6
FFF3CAE4  fa051e0200                        mov.w   #0, 444h+var_8[sp]
FFF3CAE9  fa051d0200                        mov.w   #0, 444h+var_A[sp]
FFF3CAEE  fa051c0200                        mov.w   #0, 444h+var_C[sp]
FFF3CAF3  fa060d0100                        mov.l   #0, 444h+var_10[sp]
FFF3CAF8  3d0900                            mov.w   #0, 444h+var_432[sp]
FFF3CAFB  3d0800                            mov.w   #0, 444h+var_434[sp]
FFF3CAFE  fb1258250100                      mov.l   #12558h, r1
FFF3CB04  6602                              mov.l   #0, r2
FFF3CB06  9212                              mov.w   r2, 10h[r1]
FFF3CB08  a09a                              mov.l   r2, 0Ch[r1]
FFF3CB0A  a092                              mov.l   r2, 8[r1]
FFF3CB0C  a01a                              mov.l   r2, 4[r1]
FFF3CB0E  e312                              mov.l   r2, [r1]
FFF3CB10  754312                            mov.l   #12h, r3
FFF3CB13  fb2234250100                      mov.l   #12534h, r2
FFF3CB19  fb1258250100                      mov.l   #12558h, r1
FFF3CB1F  7f8f                              smovf
FFF3CB21  fb1262080100                      mov.l   #10862h, r1
FFF3CB27  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3CB2D  e0e1                              mov.l   [r14], [r1]
FFF3CB2F  a8e4                              mov.l   8[r6], r4
FFF3CB31  fb36ff                            mov.l   #-1, r3
FFF3CB34  6602                              mov.l   #0, r2
FFF3CB36  7f80                              suntil.b
FFF3CB38  6011                              sub     #1, r1
FFF3CB3A  ef42                              mov.l   r4, r2
FFF3CB3C  7f87                              smovu
FFF3CB3E  fbe6ff                            mov.l   #-1, r14
FFF3CB41  660f                              mov.l   #0, r15
FFF3CB43  fb5262080100                      mov.l   #10862h, r5
FFF3CB49  ef51                              mov.l   r5, r1
FFF3CB4B  eff2                              mov.l   r15, r2
FFF3CB4D  efe3                              mov.l   r14, r3
FFF3CB4F  7f80                              suntil.b
FFF3CB51  6011                              sub     #1, r1
FFF3CB53  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3CB59  7f87                              smovu
FFF3CB5B  a8ec                              mov.l   0Ch[r6], r4
FFF3CB5D  ef51                              mov.l   r5, r1
FFF3CB5F  eff2                              mov.l   r15, r2
FFF3CB61  efe3                              mov.l   r14, r3
FFF3CB63  7f80                              suntil.b
FFF3CB65  6011                              sub     #1, r1
FFF3CB67  ef42                              mov.l   r4, r2
FFF3CB69  7f87                              smovu
FFF3CB6B  72023404                          add     #444h+var_10, sp, r2
FFF3CB6F  fb1262080100                      mov.l   #10862h, r1
FFF3CB75  057e65fd                          bsr.a   sub_FFF130F3
FFF3CB79  38d100                            bra.w   loc_FFF3CC4A
FFF3CB7C  5e011e02               loc_FFF3CB7C movu.w  444h+var_8[sp], r1
FFF3CB80  6ca1                              shll    #0Ah, r1
FFF3CB82  ee020d01                          mov.l   444h+var_10[sp], r2
FFF3CB86  4312                              sub     r1, r2
FFF3CB88  db021d02                          mov.w   r2, 444h+var_A[sp]
FFF3CB8C  0f                                bra.s   loc_FFF3CB93
FFF3CB8D  fa091d020004           loc_FFF3CB8D mov.w   #400h, 444h+var_A[sp]
FFF3CB93  5e011f02               loc_FFF3CB93 movu.w  444h+var_6[sp], r1
FFF3CB97  6101                              cmp     #0, r1
FFF3CB99  18                                bne.s   loc_FFF3CBA1
FFF3CB9A  fa051c020d                        mov.w   #0Dh, 444h+var_C[sp]
FFF3CB9F  2e17                              bra.b   loc_FFF3CBB6
FFF3CBA1  5e011d02               loc_FFF3CBA1 movu.w  444h+var_A[sp], r1
FFF3CBA5  7601ff03                          cmp     #3FFh, r1
FFF3CBA9  2a08                              bgt.b   loc_FFF3CBB1
FFF3CBAB  fa051c020f                        mov.w   #0Fh, 444h+var_C[sp]
FFF3CBB0  0e                                bra.s   loc_FFF3CBB6
FFF3CBB1  fa051c020e             loc_FFF3CBB1 mov.w   #0Eh, 444h+var_C[sp]
FFF3CBB6  3d0e00                 loc_FFF3CBB6 mov.w   #0, 444h+var_428[sp]
FFF3CBB9  fb1262080100                      mov.l   #10862h, r1
FFF3CBBF  a201                              mov.l   r1, 444h+var_424[sp]
FFF3CBC1  710134                            add     #444h+var_410, sp, r1
FFF3CBC4  a281                              mov.l   r1, 444h+var_41C[sp]
FFF3CBC6  5e011f02                          movu.w  444h+var_6[sp], r1
FFF3CBCA  a209                              mov.l   r1, 444h+var_420[sp]
FFF3CBCC  5e011d02                          movu.w  444h+var_A[sp], r1
FFF3CBD0  a289                              mov.l   r1, 444h+var_418[sp]
FFF3CBD2  d6001c0218                        mov.w   444h+var_C[sp], 444h+var_414[sp]
FFF3CBD7  71011c                            add     #444h+var_428, sp, r1
FFF3CBDA  05c163fd                          bsr.a   sub_FFF12F9B
FFF3CBDE  db012002                          mov.w   r1, 444h+var_4[sp]
FFF3CBE2  5e012002                          movu.w  444h+var_4[sp], r1
FFF3CBE6  6101                              cmp     #0, r1
FFF3CBE8  3b8c00                            bne.w   loc_FFF3CC74
FFF3CBEB  e5000a06                          mov.l   444h+var_41C[sp], 444h+var_42C[sp]
FFF3CBEF  5e011f02                          movu.w  444h+var_6[sp], r1
FFF3CBF3  701100100e07                      add     #70E1000h, r1, r1
FFF3CBF9  a109                              mov.l   r1, 444h+var_430[sp]
FFF3CBFB  5e011d02                          movu.w  444h+var_A[sp], r1
FFF3CBFF  fd8212                            shlr    #2, r1, r2
FFF3CC02  fd74c103                          tst     #3, r1
FFF3CC06  1c                                bne.s   loc_FFF3CC0A
FFF3CC07  920a                              mov.w   r2, 444h+var_432[sp]
FFF3CC09  0d                                bra.s   loc_FFF3CC0E
FFF3CC0A  6212                   loc_FFF3CC0A add     #1, r2
FFF3CC0C  920a                              mov.w   r2, 444h+var_432[sp]
FFF3CC0E  3d0800                 loc_FFF3CC0E mov.w   #0, 444h+var_434[sp]
FFF3CC11  2e1a                              bra.b   loc_FFF3CC2B
FFF3CC13  a981                   loc_FFF3CC13 mov.l   444h+var_42C[sp], r1
FFF3CC15  a90a                              mov.l   444h+var_430[sp], r2
FFF3CC17  e012                              mov.l   [r1], [r2]
FFF3CC19  a981                              mov.l   444h+var_42C[sp], r1
FFF3CC1B  6241                              add     #4, r1
FFF3CC1D  a181                              mov.l   r1, 444h+var_42C[sp]
FFF3CC1F  a909                              mov.l   444h+var_430[sp], r1
FFF3CC21  6241                              add     #4, r1
FFF3CC23  a109                              mov.l   r1, 444h+var_430[sp]
FFF3CC25  9a01                              mov.w   444h+var_434[sp], r1
FFF3CC27  6211                              add     #1, r1
FFF3CC29  9201                              mov.w   r1, 444h+var_434[sp]
FFF3CC2B  ba01                   loc_FFF3CC2B movu.w  444h+var_434[sp], r1
FFF3CC2D  06c50109                          cmp     444h+var_432[sp].uw, r1
FFF3CC31  29e2                              blt.b   loc_FFF3CC13
FFF3CC33  de011e02                          mov.w   444h+var_8[sp], r1
FFF3CC37  6211                              add     #1, r1
FFF3CC39  db011e02                          mov.w   r1, 444h+var_8[sp]
FFF3CC3D  5e011e02                          movu.w  444h+var_8[sp], r1
FFF3CC41  6ca1                              shll    #0Ah, r1
FFF3CC43  0686010d01                        cmp     444h+var_10[sp].l, r1
FFF3CC48  222c                              bgeu.b  loc_FFF3CC74
FFF3CC4A  fb3a0004               loc_FFF3CC4A mov.l   #400h, r3
FFF3CC4E  6602                              mov.l   #0, r2
FFF3CC50  710134                            add     #444h+var_410, sp, r1
FFF3CC53  7f88                              sstr.b
FFF3CC55  5e011e02                          movu.w  444h+var_8[sp], r1
FFF3CC59  6ca1                              shll    #0Ah, r1
FFF3CC5B  db011f02                          mov.w   r1, 444h+var_6[sp]
FFF3CC5F  5e011e02                          movu.w  444h+var_8[sp], r1
FFF3CC63  6211                              add     #1, r1
FFF3CC65  6ca1                              shll    #0Ah, r1
FFF3CC67  0686010d01                        cmp     444h+var_10[sp].l, r1
FFF3CC6C  2505                              bleu.b  loc_FFF3CC71
FFF3CC6E  380eff                            bra.w   loc_FFF3CB7C
FFF3CC71  381cff                 loc_FFF3CC71 bra.w   loc_FFF3CB8D
FFF3CC74  5e012002               loc_FFF3CC74 movu.w  444h+var_4[sp], r1
FFF3CC78  6101                              cmp     #0, r1
FFF3CC7A  2010                              beq.b   loc_FFF3CC8A
FFF3CC7C  fbe258250100                      mov.l   #12558h, r14
FFF3CC82  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3CC87  382c01                            bra.w   loc_FFF3CDB3
FFF3CC8A  fb3e005802             loc_FFF3CC8A mov.l   #25800h, r3
FFF3CC8F  6602                              mov.l   #0, r2
FFF3CC91  fb1200b80b07                      mov.l   #70BB800h, r1
FFF3CC97  0503e6fb                          bsr.a   sub_FFEFB29A
FFF3CC9B  05691bfa                          bsr.a   sub_FFEDE804
FFF3CC9F  8389                              mov.b   r1, 444h+var_435[sp]
FFF3CCA1  b389                              movu.b  444h+var_435[sp], r1
FFF3CCA3  6111                              cmp     #1, r1
FFF3CCA5  3b0301                            bne.w   loc_FFF3CDA8
FFF3CCA8  fbe20c230100                      mov.l   #1230Ch, r14
FFF3CCAE  d4e006                            mov.w   [r14], 444h+var_438[sp]
FFF3CCB1  fbe20c230100                      mov.l   #1230Ch, r14
FFF3CCB7  d5e00105                          mov.w   2[r14], 444h+var_43A[sp]
FFF3CCBB  b981                              movu.w  444h+var_438[sp], r1
FFF3CCBD  76014001                          cmp     #140h, r1
FFF3CCC1  2a09                              bgt.b   loc_FFF3CCCA
FFF3CCC3  b909                              movu.w  444h+var_43A[sp], r1
FFF3CCC5  7551f1                            cmp     #-0Fh, r1
FFF3CCC8  2906                              blt.b   loc_FFF3CCCE
FFF3CCCA  f80601                 loc_FFF3CCCA mov.l   #1, 444h+var_444[sp]
FFF3CCCD  0c                                bra.s   loc_FFF3CCD1
FFF3CCCE  f80600                 loc_FFF3CCCE mov.l   #0, 444h+var_444[sp]
FFF3CCD1  ec01                   loc_FFF3CCD1 mov.l   444h+var_444[sp], r1
FFF3CCD3  6101                              cmp     #0, r1
FFF3CCD5  200e                              beq.b   loc_FFF3CCE3
FFF3CCD7  b981                              movu.w  444h+var_438[sp], r1
FFF3CCD9  6811                              shlr    #1, r1
FFF3CCDB  9181                              mov.w   r1, 444h+var_438[sp]
FFF3CCDD  b909                              movu.w  444h+var_43A[sp], r1
FFF3CCDF  6811                              shlr    #1, r1
FFF3CCE1  9109                              mov.w   r1, 444h+var_43A[sp]
FFF3CCE3  b981                   loc_FFF3CCE3 movu.w  444h+var_438[sp], r1
FFF3CCE5  7551a0                            cmp     #-60h, r1
FFF3CCE8  2a0d                              bgt.b   loc_FFF3CCF5
FFF3CCEA  b909                              movu.w  444h+var_43A[sp], r1
FFF3CCEC  755178                            cmp     #78h, r1 ; 'x'
FFF3CCEF  2a06                              bgt.b   loc_FFF3CCF5
FFF3CCF1  f80601                            mov.l   #1, 444h+var_444[sp]
FFF3CCF4  0c                                bra.s   loc_FFF3CCF8
FFF3CCF5  f80600                 loc_FFF3CCF5 mov.l   #0, 444h+var_444[sp]
FFF3CCF8  ec01                   loc_FFF3CCF8 mov.l   444h+var_444[sp], r1
FFF3CCFA  6101                              cmp     #0, r1
FFF3CCFC  2014                              beq.b   loc_FFF3CD10
FFF3CCFE  3d0300                            mov.w   #0, 444h+var_43E[sp]
FFF3CD01  3d0400                            mov.w   #0, 444h+var_43C[sp]
FFF3CD04  9981                              mov.w   444h+var_438[sp], r1
FFF3CD06  6c11                              shll    #1, r1
FFF3CD08  9181                              mov.w   r1, 444h+var_438[sp]
FFF3CD0A  9909                              mov.w   444h+var_43A[sp], r1
FFF3CD0C  6c11                              shll    #1, r1
FFF3CD0E  9109                              mov.w   r1, 444h+var_43A[sp]
FFF3CD10  fb1a4001               loc_FFF3CD10 mov.l   #140h, r1
FFF3CD14  06c10106                          sub     444h+var_438[sp].uw, r1
FFF3CD18  fd748102                          div     #2, r1
FFF3CD1C  9101                              mov.w   r1, 444h+var_43C[sp]
FFF3CD1E  7541f0                            mov.l   #-10h, r1
FFF3CD21  06c10105                          sub     444h+var_43A[sp].uw, r1
FFF3CD25  fd748102                          div     #2, r1
FFF3CD29  9089                              mov.w   r1, 444h+var_43E[sp]
FFF3CD2B  050236fb                          bsr.a   sub_FFEF032D
FFF3CD2F  6040                              sub     #4, sp
FFF3CD31  f80500                            mov.w   #0, 448h+var_448[sp]
FFF3CD34  7544f0                            mov.l   #-10h, r4
FFF3CD37  fb3a4001                          mov.l   #140h, r3
FFF3CD3B  6601                              mov.l   #0, r1
FFF3CD3D  ef12                              mov.l   r1, r2
FFF3CD3F  05094ffb                          bsr.a   sub_FFEF1C48
FFF3CD43  6240                              add     #4, sp
FFF3CD45  b90c                              movu.w  444h+var_43A[sp], r4
FFF3CD47  b983                              movu.w  444h+var_438[sp], r3
FFF3CD49  b88a                              movu.w  444h+var_43E[sp], r2
FFF3CD4B  b901                              movu.w  444h+var_43C[sp], r1
FFF3CD4D  6040                              sub     #4, sp
FFF3CD4F  f80200b80b07                      mov.l   #70BB800h, 448h+var_448[sp]
FFF3CD55  05a31bfa                          bsr.a   sub_FFEDE8F8
FFF3CD59  6240                              add     #4, sp
FFF3CD5B  6040                              sub     #4, sp
FFF3CD5D  3d00f0                            mov.w   #-10h, [sp]
FFF3CD60  fb4a4001                          mov.l   #140h, r4
FFF3CD64  6602                              mov.l   #0, r2
FFF3CD66  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF3CD6C  ef23                              mov.l   r2, r3
FFF3CD6E  054d2cfb                          bsr.a   sub_FFEEF9BB
FFF3CD72  6240                              add     #4, sp
FFF3CD74  8389                              mov.b   r1, 444h+var_435[sp]
FFF3CD76  b389                              movu.b  444h+var_435[sp], r1
FFF3CD78  6111                              cmp     #1, r1
FFF3CD7A  2123                              bne.b   loc_FFF3CD9D
FFF3CD7C  fbe2798d0000                      mov.l   #8D79h, r14
FFF3CD82  f8e400                            mov.b   #0, [r14]
FFF3CD85  6601                              mov.l   #0, r1
FFF3CD87  ef12                              mov.l   r1, r2
FFF3CD89  057f36fb                          bsr.a   sub_FFEF0408
FFF3CD8D  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF3CD93  050b2dfb                          bsr.a   sub_FFEEFA9E
FFF3CD97  6621                              mov.l   #2, r1
FFF3CD99  05d41bfa                          bsr.a   sub_FFEDE96D
FFF3CD9D  fb1258250100           loc_FFF3CD9D mov.l   #12558h, r1
FFF3CDA3  3d1300                            mov.w   #0, 6[r1]
FFF3CDA6  2e0d                              bra.b   loc_FFF3CDB3
FFF3CDA8  fbe258250100           loc_FFF3CDA8 mov.l   #12558h, r14
FFF3CDAE  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3CDB3  fb1258250100           loc_FFF3CDB3 mov.l   #12558h, r1
FFF3CDB9  3d1090                            mov.w   #-70h, [r1]
FFF3CDBC  fb1258250100                      mov.l   #12558h, r1
FFF3CDC2  3d1101                            mov.w   #1, 2[r1]
FFF3CDC5  fbe258250100                      mov.l   #12558h, r14
FFF3CDCB  fbf26c250100                      mov.l   #1256Ch, r15
FFF3CDD1  d4fe02                            mov.w   [r15], 4[r14]
FFF3CDD4  3d6c00                            mov.w   #0, 18h[r6]
FFF3CDD7  7100c8                            add     #-38h, sp, sp
FFF3CDDA  754312                            mov.l   #12h, r3
FFF3CDDD  fb2258250100                      mov.l   #12558h, r2
FFF3CDE3  ef01                              mov.l   sp, r1
FFF3CDE5  7f8f                              smovf
FFF3CDE7  ef01                              mov.l   sp, r1
FFF3CDE9  711114                            add     #14h, r1, r1
FFF3CDEC  754324                            mov.l   #24h, r3 ; '$'
FFF3CDEF  ef62                              mov.l   r6, r2
FFF3CDF1  7f8f                              smovf
FFF3CDF3  6602                              mov.l   #0, r2
FFF3CDF5  7541fe                            mov.l   #-2, r1
FFF3CDF8  05e40afa                          bsr.a   sub_FFEDD8DC
FFF3CDFC  710038                            add     #38h, sp, sp ; '8'
FFF3CDFF  da0020022102                      mov.w   444h+var_4[sp], 444h+var_2[sp]
FFF3CE05  de012102                          mov.w   444h+var_2[sp], r1
FFF3CE09  5f11                              movu.w  r1, r1
FFF3CE0B  72004404                          add     #444h, sp, sp
FFF3CE0F  7eb6                              pop     r6
FFF3CE11  02                                rts

; ######## sub_FFF3CE12  FFF3CE12-FFF3CFD8 (file 33CE12) callers: FFF3C565(sub_FFF3C4BC)
FFF3CE12  7ea6                   sub_FFF3CE12 push.l  r6   ; <<<< FUNC sub_FFF3CE12
FFF3CE14  7200e0fb                          add     #-420h, sp, sp
FFF3CE18  fa050e0200                        mov.w   #0, 420h+var_4[sp]
FFF3CE1D  72062804                          add     #420h+arg_0, sp, r6
FFF3CE21  fa06060100                        mov.l   #0, 420h+var_8[sp]
FFF3CE26  fb1258250100                      mov.l   #12558h, r1
FFF3CE2C  6602                              mov.l   #0, r2
FFF3CE2E  9212                              mov.w   r2, 10h[r1]
FFF3CE30  a09a                              mov.l   r2, 0Ch[r1]
FFF3CE32  a092                              mov.l   r2, 8[r1]
FFF3CE34  a01a                              mov.l   r2, 4[r1]
FFF3CE36  e312                              mov.l   r2, [r1]
FFF3CE38  f80500                            mov.w   #0, 420h+var_420[sp]
FFF3CE3B  fb1262080100                      mov.l   #10862h, r1
FFF3CE41  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3CE47  e0e1                              mov.l   [r14], [r1]
FFF3CE49  a8e4                              mov.l   8[r6], r4
FFF3CE4B  fb36ff                            mov.l   #-1, r3
FFF3CE4E  6602                              mov.l   #0, r2
FFF3CE50  7f80                              suntil.b
FFF3CE52  6011                              sub     #1, r1
FFF3CE54  ef42                              mov.l   r4, r2
FFF3CE56  7f87                              smovu
FFF3CE58  fbe6ff                            mov.l   #-1, r14
FFF3CE5B  660f                              mov.l   #0, r15
FFF3CE5D  fb5262080100                      mov.l   #10862h, r5
FFF3CE63  ef51                              mov.l   r5, r1
FFF3CE65  eff2                              mov.l   r15, r2
FFF3CE67  efe3                              mov.l   r14, r3
FFF3CE69  7f80                              suntil.b
FFF3CE6B  6011                              sub     #1, r1
FFF3CE6D  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3CE73  7f87                              smovu
FFF3CE75  a8ec                              mov.l   0Ch[r6], r4
FFF3CE77  ef51                              mov.l   r5, r1
FFF3CE79  eff2                              mov.l   r15, r2
FFF3CE7B  efe3                              mov.l   r14, r3
FFF3CE7D  7f80                              suntil.b
FFF3CE7F  6011                              sub     #1, r1
FFF3CE81  ef42                              mov.l   r4, r2
FFF3CE83  7f87                              smovu
FFF3CE85  fb1262080100                      mov.l   #10862h, r1
FFF3CE8B  a009                              mov.l   r1, 420h+var_41C[sp]
FFF3CE8D  710118                            add     #420h+var_408, sp, r1
FFF3CE90  a089                              mov.l   r1, 420h+var_414[sp]
FFF3CE92  e5600502                          mov.l   14h[r6], 420h+var_418[sp]
FFF3CE96  e5600404                          mov.l   10h[r6], 420h+var_410[sp]
FFF3CE9A  754312                            mov.l   #12h, r3
FFF3CE9D  fb2234250100                      mov.l   #12534h, r2
FFF3CEA3  fb1258250100                      mov.l   #12558h, r1
FFF3CEA9  7f8f                              smovf
FFF3CEAB  5c6e                              movu.w  [r6], r14
FFF3CEAD  71eff3                            add     #-0Dh, r14, r15
FFF3CEB0  614f                              cmp     #4, r15
FFF3CEB2  2328                              bltu.b  loc_FFF3CEDA
FFF3CEB4  61be                              cmp     #0Bh, r14
FFF3CEB6  2015                              beq.b   loc_FFF3CECB
FFF3CEB8  61ae                              cmp     #0Ah, r14
FFF3CEBA  216a                              bne.b   loc_FFF3CF24
FFF3CEBC  3d0a00                            mov.w   #0, 420h+var_40C[sp]
FFF3CEBF  ef01                              mov.l   sp, r1
FFF3CEC1  05ca5ffd                          bsr.a   sub_FFF12E8B
FFF3CEC5  db010e02                          mov.w   r1, 420h+var_4[sp]
FFF3CEC9  2e61                              bra.b   loc_FFF3CF2A
FFF3CECB  3d0a01                 loc_FFF3CECB mov.w   #1, 420h+var_40C[sp]
FFF3CECE  ef01                              mov.l   sp, r1
FFF3CED0  05bb5ffd                          bsr.a   sub_FFF12E8B
FFF3CED4  db010e02                          mov.w   r1, 420h+var_4[sp]
FFF3CED8  2e52                              bra.b   loc_FFF3CF2A
FFF3CEDA  5c6e                   loc_FFF3CEDA movu.w  [r6], r14
FFF3CEDC  61de                              cmp     #0Dh, r14
FFF3CEDE  2116                              bne.b   loc_FFF3CEF4
FFF3CEE0  fbee1a7208                        mov.l   #8721Ah, r14
FFF3CEE5  f0ea                              bclr    #2, [r14].b
FFF3CEE7  fbee801a0c                        mov.l   #0C1A80h, r14
FFF3CEEC  f0ee                              bclr    #6, [r14].b
FFF3CEEE  6661                              mov.l   #6, r1
FFF3CEF0  0575d0ff                          bsr.a   sub_FFF39F65
FFF3CEF4  d4600a                 loc_FFF3CEF4 mov.w   [r6], 420h+var_40C[sp]
FFF3CEF7  ef01                              mov.l   sp, r1
FFF3CEF9  05a260fd                          bsr.a   sub_FFF12F9B
FFF3CEFD  db010e02                          mov.w   r1, 420h+var_4[sp]
FFF3CF01  5c6e                              movu.w  [r6], r14
FFF3CF03  61fe                              cmp     #0Fh, r14
FFF3CF05  2125                              bne.b   loc_FFF3CF2A
FFF3CF07  fbee1a7208                        mov.l   #8721Ah, r14
FFF3CF0C  f0e2                              bset    #2, [r14].b
FFF3CF0E  fbee801a0c                        mov.l   #0C1A80h, r14
FFF3CF13  f0e6                              bset    #6, [r14].b
FFF3CF15  fbe26e250100                      mov.l   #1256Eh, r14
FFF3CF1B  5ce2                              movu.w  [r14], r2
FFF3CF1D  6661                              mov.l   #6, r1
FFF3CF1F  05b9cfff                          bsr.a   sub_FFF39ED8
FFF3CF23  0f                                bra.s   loc_FFF3CF2A
FFF3CF24  fa090e02ffff           loc_FFF3CF24 mov.w   #-1, 420h+var_4[sp]
FFF3CF2A  5e010e02               loc_FFF3CF2A movu.w  420h+var_4[sp], r1
FFF3CF2E  6101                              cmp     #0, r1
FFF3CF30  2012                              beq.b   loc_FFF3CF42
FFF3CF32  fbe258250100                      mov.l   #12558h, r14
FFF3CF38  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3CF3D  3d6c00                            mov.w   #0, 18h[r6]
FFF3CF40  2e37                              bra.b   loc_FFF3CF77
FFF3CF42  fb1258250100           loc_FFF3CF42 mov.l   #12558h, r1
FFF3CF48  3d1300                            mov.w   #0, 6[r1]
FFF3CF4B  a961                              mov.l   10h[r6], r1
FFF3CF4D  9361                              mov.w   r1, 18h[r6]
FFF3CF4F  fa06060100                        mov.l   #0, 420h+var_8[sp]
FFF3CF54  2e1a                              bra.b   loc_FFF3CF6E
FFF3CF56  ee010601               loc_FFF3CF56 mov.l   420h+var_8[sp], r1
FFF3CF5A  a88a                              mov.l   420h+var_414[sp], r2
FFF3CF5C  fec21e                            movu.b  [r2, r1], r14
FFF3CF5F  aa62                              mov.l   20h[r6], r2
FFF3CF61  fe021e                            mov.b   r14, [r2, r1]
FFF3CF64  ee010601                          mov.l   420h+var_8[sp], r1
FFF3CF68  6211                              add     #1, r1
FFF3CF6A  eb010601                          mov.l   r1, 420h+var_8[sp]
FFF3CF6E  bb61                   loc_FFF3CF6E movu.w  18h[r6], r1
FFF3CF70  0686010601                        cmp     420h+var_8[sp].l, r1
FFF3CF75  24e1                              bgtu.b  loc_FFF3CF56
FFF3CF77  bb61                   loc_FFF3CF77 movu.w  18h[r6], r1
FFF3CF79  72119000                          add     #90h, r1, r1
FFF3CF7D  fbe258250100                      mov.l   #12558h, r14
FFF3CF83  d3e1                              mov.w   r1, [r14]
FFF3CF85  fb1258250100                      mov.l   #12558h, r1
FFF3CF8B  3d1101                            mov.w   #1, 2[r1]
FFF3CF8E  fbe258250100                      mov.l   #12558h, r14
FFF3CF94  fbf26c250100                      mov.l   #1256Ch, r15
FFF3CF9A  d4fe02                            mov.w   [r15], 4[r14]
FFF3CF9D  7100c8                            add     #-38h, sp, sp
FFF3CFA0  754312                            mov.l   #12h, r3
FFF3CFA3  fb2258250100                      mov.l   #12558h, r2
FFF3CFA9  ef01                              mov.l   sp, r1
FFF3CFAB  7f8f                              smovf
FFF3CFAD  ef01                              mov.l   sp, r1
FFF3CFAF  711114                            add     #14h, r1, r1
FFF3CFB2  754324                            mov.l   #24h, r3 ; '$'
FFF3CFB5  ef62                              mov.l   r6, r2
FFF3CFB7  7f8f                              smovf
FFF3CFB9  6602                              mov.l   #0, r2
FFF3CFBB  7541fe                            mov.l   #-2, r1
FFF3CFBE  051e09fa                          bsr.a   sub_FFEDD8DC
FFF3CFC2  710038                            add     #38h, sp, sp ; '8'
FFF3CFC5  da000e020f02                      mov.w   420h+var_4[sp], 420h+var_2[sp]
FFF3CFCB  de010f02                          mov.w   420h+var_2[sp], r1
FFF3CFCF  5f11                              movu.w  r1, r1
FFF3CFD1  72002004                          add     #420h, sp, sp
FFF3CFD5  7eb6                              pop     r6
FFF3CFD7  02                                rts

; ######## sub_FFF3CFD8  FFF3CFD8-FFF3D0D9 (file 33CFD8) callers: FFF3C585(sub_FFF3C4BC)
FFF3CFD8  7ea6                   sub_FFF3CFD8 push.l  r6   ; <<<< FUNC sub_FFF3CFD8
FFF3CFDA  6080                              sub     #8, sp
FFF3CFDC  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3CFDF  710610                            add     #8+arg_0, sp, r6
FFF3CFE2  f80600                            mov.l   #0, 8+var_8[sp]
FFF3CFE5  fb1258250100                      mov.l   #12558h, r1
FFF3CFEB  6602                              mov.l   #0, r2
FFF3CFED  9212                              mov.w   r2, 10h[r1]
FFF3CFEF  a09a                              mov.l   r2, 0Ch[r1]
FFF3CFF1  a092                              mov.l   r2, 8[r1]
FFF3CFF3  a01a                              mov.l   r2, 4[r1]
FFF3CFF5  e312                              mov.l   r2, [r1]
FFF3CFF7  fb1262080100                      mov.l   #10862h, r1
FFF3CFFD  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3D003  e0e1                              mov.l   [r14], [r1]
FFF3D005  a8e4                              mov.l   8[r6], r4
FFF3D007  fb36ff                            mov.l   #-1, r3
FFF3D00A  6602                              mov.l   #0, r2
FFF3D00C  7f80                              suntil.b
FFF3D00E  6011                              sub     #1, r1
FFF3D010  ef42                              mov.l   r4, r2
FFF3D012  7f87                              smovu
FFF3D014  fbe6ff                            mov.l   #-1, r14
FFF3D017  660f                              mov.l   #0, r15
FFF3D019  fb5262080100                      mov.l   #10862h, r5
FFF3D01F  ef51                              mov.l   r5, r1
FFF3D021  eff2                              mov.l   r15, r2
FFF3D023  efe3                              mov.l   r14, r3
FFF3D025  7f80                              suntil.b
FFF3D027  6011                              sub     #1, r1
FFF3D029  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3D02F  7f87                              smovu
FFF3D031  a8ec                              mov.l   0Ch[r6], r4
FFF3D033  ef51                              mov.l   r5, r1
FFF3D035  eff2                              mov.l   r15, r2
FFF3D037  efe3                              mov.l   r14, r3
FFF3D039  7f80                              suntil.b
FFF3D03B  6011                              sub     #1, r1
FFF3D03D  ef42                              mov.l   r4, r2
FFF3D03F  7f87                              smovu
FFF3D041  754312                            mov.l   #12h, r3
FFF3D044  fb2234250100                      mov.l   #12534h, r2
FFF3D04A  fb1258250100                      mov.l   #12558h, r1
FFF3D050  7f8f                              smovf
FFF3D052  ef02                              mov.l   sp, r2
FFF3D054  fb1262080100                      mov.l   #10862h, r1
FFF3D05A  059960fd                          bsr.a   sub_FFF130F3
FFF3D05E  9081                              mov.w   r1, 8+var_4[sp]
FFF3D060  b881                              movu.w  8+var_4[sp], r1
FFF3D062  6101                              cmp     #0, r1
FFF3D064  2012                              beq.b   loc_FFF3D076
FFF3D066  fbe258250100                      mov.l   #12558h, r14
FFF3D06C  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D071  3e6400                            mov.l   #0, 10h[r6]
FFF3D074  2e0e                              bra.b   loc_FFF3D082
FFF3D076  fb1258250100           loc_FFF3D076 mov.l   #12558h, r1
FFF3D07C  3d1300                            mov.w   #0, 6[r1]
FFF3D07F  e40604                            mov.l   8+var_8[sp], 10h[r6]
FFF3D082  fb1258250100           loc_FFF3D082 mov.l   #12558h, r1
FFF3D088  3d1090                            mov.w   #-70h, [r1]
FFF3D08B  fb1258250100                      mov.l   #12558h, r1
FFF3D091  3d1101                            mov.w   #1, 2[r1]
FFF3D094  fbe258250100                      mov.l   #12558h, r14
FFF3D09A  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D0A0  d4fe02                            mov.w   [r15], 4[r14]
FFF3D0A3  3d6c00                            mov.w   #0, 18h[r6]
FFF3D0A6  7100c8                            add     #-38h, sp, sp
FFF3D0A9  754312                            mov.l   #12h, r3
FFF3D0AC  fb2258250100                      mov.l   #12558h, r2
FFF3D0B2  ef01                              mov.l   sp, r1
FFF3D0B4  7f8f                              smovf
FFF3D0B6  ef01                              mov.l   sp, r1
FFF3D0B8  711114                            add     #14h, r1, r1
FFF3D0BB  754324                            mov.l   #24h, r3 ; '$'
FFF3D0BE  ef62                              mov.l   r6, r2
FFF3D0C0  7f8f                              smovf
FFF3D0C2  6602                              mov.l   #0, r2
FFF3D0C4  7541fe                            mov.l   #-2, r1
FFF3D0C7  051508fa                          bsr.a   sub_FFEDD8DC
FFF3D0CB  710038                            add     #38h, sp, sp ; '8'
FFF3D0CE  d5000203                          mov.w   8+var_4[sp], 8+var_2[sp]
FFF3D0D2  9889                              mov.w   8+var_2[sp], r1
FFF3D0D4  5f11                              movu.w  r1, r1
FFF3D0D6  3f6603                            rtsd    #0Ch, r6-r6

; ######## sub_FFF3D0D9  FFF3D0D9-FFF3D209 (file 33D0D9) callers: FFF3C5A5(sub_FFF3C4BC)
FFF3D0D9  7ea6                   sub_FFF3D0D9 push.l  r6   ; <<<< FUNC sub_FFF3D0D9
FFF3D0DB  7100d8                            add     #-28h, sp, sp
FFF3D0DE  3d8200                            mov.w   #0, 28h+var_4[sp]
FFF3D0E1  3d8100                            mov.w   #0, 28h+var_6[sp]
FFF3D0E4  710630                            add     #28h+arg_0, sp, r6
FFF3D0E7  fb1258250100                      mov.l   #12558h, r1
FFF3D0ED  6602                              mov.l   #0, r2
FFF3D0EF  9212                              mov.w   r2, 10h[r1]
FFF3D0F1  a09a                              mov.l   r2, 0Ch[r1]
FFF3D0F3  a092                              mov.l   r2, 8[r1]
FFF3D0F5  a01a                              mov.l   r2, 4[r1]
FFF3D0F7  e312                              mov.l   r2, [r1]
FFF3D0F9  3d8200                            mov.w   #0, 28h+var_4[sp]
FFF3D0FC  2e20                              bra.b   loc_FFF3D11C
FFF3D0FE  aa61                   loc_FFF3D0FE mov.l   20h[r6], r1
FFF3D100  bc82                              movu.w  28h+var_4[sp], r2
FFF3D102  fec12e                            movu.b  [r1, r2], r14
FFF3D105  610e                              cmp     #0, r14
FFF3D107  201c                              beq.b   loc_FFF3D123
FFF3D109  aa61                              mov.l   20h[r6], r1
FFF3D10B  bc82                              movu.w  28h+var_4[sp], r2
FFF3D10D  fec12e                            movu.b  [r1, r2], r14
FFF3D110  710f02                            add     #28h+var_26, sp, r15
FFF3D113  fe0f2e                            mov.b   r14, [r15, r2]
FFF3D116  9c81                              mov.w   28h+var_4[sp], r1
FFF3D118  6211                              add     #1, r1
FFF3D11A  9481                              mov.w   r1, 28h+var_4[sp]
FFF3D11C  bc81                   loc_FFF3D11C movu.w  28h+var_4[sp], r1
FFF3D11E  755120                            cmp     #20h, r1 ; ' '
FFF3D121  29dd                              blt.b   loc_FFF3D0FE
FFF3D123  bc81                   loc_FFF3D123 movu.w  28h+var_4[sp], r1
FFF3D125  710e02                            add     #28h+var_26, sp, r14
FFF3D128  660f                              mov.l   #0, r15
FFF3D12A  fe0e1f                            mov.b   r15, [r14, r1]
FFF3D12D  fb1262080100                      mov.l   #10862h, r1
FFF3D133  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3D139  e0e1                              mov.l   [r14], [r1]
FFF3D13B  a8e4                              mov.l   8[r6], r4
FFF3D13D  fb36ff                            mov.l   #-1, r3
FFF3D140  6602                              mov.l   #0, r2
FFF3D142  7f80                              suntil.b
FFF3D144  6011                              sub     #1, r1
FFF3D146  ef42                              mov.l   r4, r2
FFF3D148  7f87                              smovu
FFF3D14A  fbe6ff                            mov.l   #-1, r14
FFF3D14D  660f                              mov.l   #0, r15
FFF3D14F  fb5262080100                      mov.l   #10862h, r5
FFF3D155  ef51                              mov.l   r5, r1
FFF3D157  eff2                              mov.l   r15, r2
FFF3D159  efe3                              mov.l   r14, r3
FFF3D15B  7f80                              suntil.b
FFF3D15D  6011                              sub     #1, r1
FFF3D15F  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3D165  7f87                              smovu
FFF3D167  a8ec                              mov.l   0Ch[r6], r4
FFF3D169  ef51                              mov.l   r5, r1
FFF3D16B  eff2                              mov.l   r15, r2
FFF3D16D  efe3                              mov.l   r14, r3
FFF3D16F  7f80                              suntil.b
FFF3D171  6011                              sub     #1, r1
FFF3D173  ef42                              mov.l   r4, r2
FFF3D175  7f87                              smovu
FFF3D177  754312                            mov.l   #12h, r3
FFF3D17A  fb2234250100                      mov.l   #12534h, r2
FFF3D180  fb1258250100                      mov.l   #12558h, r1
FFF3D186  7f8f                              smovf
FFF3D188  710202                            add     #28h+var_26, sp, r2
FFF3D18B  fb1262080100                      mov.l   #10862h, r1
FFF3D191  05c85ffd                          bsr.a   sub_FFF13159
FFF3D195  9409                              mov.w   r1, 28h+var_6[sp]
FFF3D197  bc09                              movu.w  28h+var_6[sp], r1
FFF3D199  6101                              cmp     #0, r1
FFF3D19B  200e                              beq.b   loc_FFF3D1A9
FFF3D19D  fbe258250100                      mov.l   #12558h, r14
FFF3D1A3  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D1A8  0a                                bra.s   loc_FFF3D1B2
FFF3D1A9  fb1258250100           loc_FFF3D1A9 mov.l   #12558h, r1
FFF3D1AF  3d1300                            mov.w   #0, 6[r1]
FFF3D1B2  fb1258250100           loc_FFF3D1B2 mov.l   #12558h, r1
FFF3D1B8  3d1090                            mov.w   #-70h, [r1]
FFF3D1BB  fb1258250100                      mov.l   #12558h, r1
FFF3D1C1  3d1101                            mov.w   #1, 2[r1]
FFF3D1C4  fbe258250100                      mov.l   #12558h, r14
FFF3D1CA  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D1D0  d4fe02                            mov.w   [r15], 4[r14]
FFF3D1D3  3d6c00                            mov.w   #0, 18h[r6]
FFF3D1D6  7100c8                            add     #-38h, sp, sp
FFF3D1D9  754312                            mov.l   #12h, r3
FFF3D1DC  fb2258250100                      mov.l   #12558h, r2
FFF3D1E2  ef01                              mov.l   sp, r1
FFF3D1E4  7f8f                              smovf
FFF3D1E6  ef01                              mov.l   sp, r1
FFF3D1E8  711114                            add     #14h, r1, r1
FFF3D1EB  754324                            mov.l   #24h, r3 ; '$'
FFF3D1EE  ef62                              mov.l   r6, r2
FFF3D1F0  7f8f                              smovf
FFF3D1F2  6602                              mov.l   #0, r2
FFF3D1F4  7541fe                            mov.l   #-2, r1
FFF3D1F7  05e506fa                          bsr.a   sub_FFEDD8DC
FFF3D1FB  710038                            add     #38h, sp, sp ; '8'
FFF3D1FE  d5001113                          mov.w   28h+var_6[sp], 28h+var_2[sp]
FFF3D202  9c89                              mov.w   28h+var_2[sp], r1
FFF3D204  5f11                              movu.w  r1, r1
FFF3D206  3f660b                            rtsd    #2Ch, r6-r6

; ######## sub_FFF3D209  FFF3D209-FFF3D2FD (file 33D209) callers: FFF3C5C5(sub_FFF3C4BC)
FFF3D209  7ea6                   sub_FFF3D209 push.l  r6   ; <<<< FUNC sub_FFF3D209
FFF3D20B  6040                              sub     #4, sp
FFF3D20D  f80500                            mov.w   #0, 4+var_4[sp]
FFF3D210  71060c                            add     #4+arg_0, sp, r6
FFF3D213  fb1258250100                      mov.l   #12558h, r1
FFF3D219  6602                              mov.l   #0, r2
FFF3D21B  9212                              mov.w   r2, 10h[r1]
FFF3D21D  a09a                              mov.l   r2, 0Ch[r1]
FFF3D21F  a092                              mov.l   r2, 8[r1]
FFF3D221  a01a                              mov.l   r2, 4[r1]
FFF3D223  e312                              mov.l   r2, [r1]
FFF3D225  fb1262080100                      mov.l   #10862h, r1
FFF3D22B  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3D231  e0e1                              mov.l   [r14], [r1]
FFF3D233  a8e4                              mov.l   8[r6], r4
FFF3D235  fb36ff                            mov.l   #-1, r3
FFF3D238  6602                              mov.l   #0, r2
FFF3D23A  7f80                              suntil.b
FFF3D23C  6011                              sub     #1, r1
FFF3D23E  ef42                              mov.l   r4, r2
FFF3D240  7f87                              smovu
FFF3D242  fbe6ff                            mov.l   #-1, r14
FFF3D245  660f                              mov.l   #0, r15
FFF3D247  fb5262080100                      mov.l   #10862h, r5
FFF3D24D  ef51                              mov.l   r5, r1
FFF3D24F  eff2                              mov.l   r15, r2
FFF3D251  efe3                              mov.l   r14, r3
FFF3D253  7f80                              suntil.b
FFF3D255  6011                              sub     #1, r1
FFF3D257  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3D25D  7f87                              smovu
FFF3D25F  a8ec                              mov.l   0Ch[r6], r4
FFF3D261  ef51                              mov.l   r5, r1
FFF3D263  eff2                              mov.l   r15, r2
FFF3D265  efe3                              mov.l   r14, r3
FFF3D267  7f80                              suntil.b
FFF3D269  6011                              sub     #1, r1
FFF3D26B  ef42                              mov.l   r4, r2
FFF3D26D  7f87                              smovu
FFF3D26F  754312                            mov.l   #12h, r3
FFF3D272  fb2234250100                      mov.l   #12534h, r2
FFF3D278  fb1258250100                      mov.l   #12558h, r1
FFF3D27E  7f8f                              smovf
FFF3D280  fb1262080100                      mov.l   #10862h, r1
FFF3D286  05fe5efd                          bsr.a   sub_FFF13184
FFF3D28A  d301                              mov.w   r1, 4+var_4[sp]
FFF3D28C  5c01                              movu.w  4+var_4[sp], r1
FFF3D28E  6101                              cmp     #0, r1
FFF3D290  200e                              beq.b   loc_FFF3D29E
FFF3D292  fbe258250100                      mov.l   #12558h, r14
FFF3D298  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D29D  0a                                bra.s   loc_FFF3D2A7
FFF3D29E  fb1258250100           loc_FFF3D29E mov.l   #12558h, r1
FFF3D2A4  3d1300                            mov.w   #0, 6[r1]
FFF3D2A7  fb1258250100           loc_FFF3D2A7 mov.l   #12558h, r1
FFF3D2AD  3d1090                            mov.w   #-70h, [r1]
FFF3D2B0  fb1258250100                      mov.l   #12558h, r1
FFF3D2B6  3d1101                            mov.w   #1, 2[r1]
FFF3D2B9  fbe258250100                      mov.l   #12558h, r14
FFF3D2BF  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D2C5  d4fe02                            mov.w   [r15], 4[r14]
FFF3D2C8  3d6c00                            mov.w   #0, 18h[r6]
FFF3D2CB  7100c8                            add     #-38h, sp, sp
FFF3D2CE  754312                            mov.l   #12h, r3
FFF3D2D1  fb2258250100                      mov.l   #12558h, r2
FFF3D2D7  ef01                              mov.l   sp, r1
FFF3D2D9  7f8f                              smovf
FFF3D2DB  ef01                              mov.l   sp, r1
FFF3D2DD  711114                            add     #14h, r1, r1
FFF3D2E0  754324                            mov.l   #24h, r3 ; '$'
FFF3D2E3  ef62                              mov.l   r6, r2
FFF3D2E5  7f8f                              smovf
FFF3D2E7  6602                              mov.l   #0, r2
FFF3D2E9  7541fe                            mov.l   #-2, r1
FFF3D2EC  05f005fa                          bsr.a   sub_FFEDD8DC
FFF3D2F0  710038                            add     #38h, sp, sp ; '8'
FFF3D2F3  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3D2F6  9809                              mov.w   4+var_2[sp], r1
FFF3D2F8  5f11                              movu.w  r1, r1
FFF3D2FA  3f6602                            rtsd    #8, r6-r6

; ######## sub_FFF3D2FD  FFF3D2FD-FFF3D3C7 (file 33D2FD) callers: FFF3C5E5(sub_FFF3C4BC)
FFF3D2FD  7ea6                   sub_FFF3D2FD push.l  r6   ; <<<< FUNC sub_FFF3D2FD
FFF3D2FF  6040                              sub     #4, sp
FFF3D301  f80500                            mov.w   #0, 4+var_4[sp]
FFF3D304  71060c                            add     #4+arg_0, sp, r6
FFF3D307  fb1258250100                      mov.l   #12558h, r1
FFF3D30D  6602                              mov.l   #0, r2
FFF3D30F  9212                              mov.w   r2, 10h[r1]
FFF3D311  a09a                              mov.l   r2, 0Ch[r1]
FFF3D313  a092                              mov.l   r2, 8[r1]
FFF3D315  a01a                              mov.l   r2, 4[r1]
FFF3D317  e312                              mov.l   r2, [r1]
FFF3D319  fb1262080100                      mov.l   #10862h, r1
FFF3D31F  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3D325  e0e1                              mov.l   [r14], [r1]
FFF3D327  a8e4                              mov.l   8[r6], r4
FFF3D329  fb36ff                            mov.l   #-1, r3
FFF3D32C  6602                              mov.l   #0, r2
FFF3D32E  7f80                              suntil.b
FFF3D330  6011                              sub     #1, r1
FFF3D332  ef42                              mov.l   r4, r2
FFF3D334  7f87                              smovu
FFF3D336  754312                            mov.l   #12h, r3
FFF3D339  fb2234250100                      mov.l   #12534h, r2
FFF3D33F  fb1258250100                      mov.l   #12558h, r1
FFF3D345  7f8f                              smovf
FFF3D347  fb1262080100                      mov.l   #10862h, r1
FFF3D34D  056058fd                          bsr.a   sub_FFF12BAD
FFF3D351  d301                              mov.w   r1, 4+var_4[sp]
FFF3D353  5c01                              movu.w  4+var_4[sp], r1
FFF3D355  6101                              cmp     #0, r1
FFF3D357  200e                              beq.b   loc_FFF3D365
FFF3D359  fbe258250100                      mov.l   #12558h, r14
FFF3D35F  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D364  0a                                bra.s   loc_FFF3D36E
FFF3D365  fb1258250100           loc_FFF3D365 mov.l   #12558h, r1
FFF3D36B  3d1300                            mov.w   #0, 6[r1]
FFF3D36E  3d60c9                 loc_FFF3D36E mov.w   #-37h, [r6]
FFF3D371  fb1258250100                      mov.l   #12558h, r1
FFF3D377  3d1090                            mov.w   #-70h, [r1]
FFF3D37A  fb1258250100                      mov.l   #12558h, r1
FFF3D380  3d1101                            mov.w   #1, 2[r1]
FFF3D383  fbe258250100                      mov.l   #12558h, r14
FFF3D389  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D38F  d4fe02                            mov.w   [r15], 4[r14]
FFF3D392  3d6c00                            mov.w   #0, 18h[r6]
FFF3D395  7100c8                            add     #-38h, sp, sp
FFF3D398  754312                            mov.l   #12h, r3
FFF3D39B  fb2258250100                      mov.l   #12558h, r2
FFF3D3A1  ef01                              mov.l   sp, r1
FFF3D3A3  7f8f                              smovf
FFF3D3A5  ef01                              mov.l   sp, r1
FFF3D3A7  711114                            add     #14h, r1, r1
FFF3D3AA  754324                            mov.l   #24h, r3 ; '$'
FFF3D3AD  ef62                              mov.l   r6, r2
FFF3D3AF  7f8f                              smovf
FFF3D3B1  6602                              mov.l   #0, r2
FFF3D3B3  7541fe                            mov.l   #-2, r1
FFF3D3B6  052605fa                          bsr.a   sub_FFEDD8DC
FFF3D3BA  710038                            add     #38h, sp, sp ; '8'
FFF3D3BD  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3D3C0  9809                              mov.w   4+var_2[sp], r1
FFF3D3C2  5f11                              movu.w  r1, r1
FFF3D3C4  3f6602                            rtsd    #8, r6-r6

; ######## sub_FFF3D3C7  FFF3D3C7-FFF3D48F (file 33D3C7) callers: FFF3C605(sub_FFF3C4BC)
FFF3D3C7  7ea6                   sub_FFF3D3C7 push.l  r6   ; <<<< FUNC sub_FFF3D3C7
FFF3D3C9  6040                              sub     #4, sp
FFF3D3CB  3c0201                            mov.b   #1, 4+var_2[sp]
FFF3D3CE  71060c                            add     #4+arg_0, sp, r6
FFF3D3D1  fb1258250100                      mov.l   #12558h, r1
FFF3D3D7  6602                              mov.l   #0, r2
FFF3D3D9  9212                              mov.w   r2, 10h[r1]
FFF3D3DB  a09a                              mov.l   r2, 0Ch[r1]
FFF3D3DD  a092                              mov.l   r2, 8[r1]
FFF3D3DF  a01a                              mov.l   r2, 4[r1]
FFF3D3E1  e312                              mov.l   r2, [r1]
FFF3D3E3  fb1262080100                      mov.l   #10862h, r1
FFF3D3E9  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3D3EF  e0e1                              mov.l   [r14], [r1]
FFF3D3F1  a8e4                              mov.l   8[r6], r4
FFF3D3F3  fb36ff                            mov.l   #-1, r3
FFF3D3F6  6602                              mov.l   #0, r2
FFF3D3F8  7f80                              suntil.b
FFF3D3FA  6011                              sub     #1, r1
FFF3D3FC  ef42                              mov.l   r4, r2
FFF3D3FE  7f87                              smovu
FFF3D400  754312                            mov.l   #12h, r3
FFF3D403  fb2234250100                      mov.l   #12534h, r2
FFF3D409  fb1258250100                      mov.l   #12558h, r1
FFF3D40F  7f8f                              smovf
FFF3D411  fb1262080100                      mov.l   #10862h, r1
FFF3D417  05e257fd                          bsr.a   sub_FFF12BF9
FFF3D41B  8081                              mov.b   r1, 4+var_2[sp]
FFF3D41D  b081                              movu.b  4+var_2[sp], r1
FFF3D41F  6111                              cmp     #1, r1
FFF3D421  200e                              beq.b   loc_FFF3D42F
FFF3D423  fbe258250100                      mov.l   #12558h, r14
FFF3D429  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D42E  0a                                bra.s   loc_FFF3D438
FFF3D42F  fb1258250100           loc_FFF3D42F mov.l   #12558h, r1
FFF3D435  3d1300                            mov.w   #0, 6[r1]
FFF3D438  fb1258250100           loc_FFF3D438 mov.l   #12558h, r1
FFF3D43E  3d1090                            mov.w   #-70h, [r1]
FFF3D441  fb1258250100                      mov.l   #12558h, r1
FFF3D447  3d1101                            mov.w   #1, 2[r1]
FFF3D44A  fbe258250100                      mov.l   #12558h, r14
FFF3D450  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D456  d4fe02                            mov.w   [r15], 4[r14]
FFF3D459  3d6c00                            mov.w   #0, 18h[r6]
FFF3D45C  7100c8                            add     #-38h, sp, sp
FFF3D45F  754312                            mov.l   #12h, r3
FFF3D462  fb2258250100                      mov.l   #12558h, r2
FFF3D468  ef01                              mov.l   sp, r1
FFF3D46A  7f8f                              smovf
FFF3D46C  ef01                              mov.l   sp, r1
FFF3D46E  711114                            add     #14h, r1, r1
FFF3D471  754324                            mov.l   #24h, r3 ; '$'
FFF3D474  ef62                              mov.l   r6, r2
FFF3D476  7f8f                              smovf
FFF3D478  6602                              mov.l   #0, r2
FFF3D47A  7541fe                            mov.l   #-2, r1
FFF3D47D  055f04fa                          bsr.a   sub_FFEDD8DC
FFF3D481  710038                            add     #38h, sp, sp ; '8'
FFF3D484  c5000203                          mov.b   4+var_2[sp], 4+var_1[sp]
FFF3D488  b089                              movu.b  4+var_1[sp], r1
FFF3D48A  5b11                              movu.b  r1, r1
FFF3D48C  3f6602                            rtsd    #8, r6-r6

; ######## sub_FFF3D48F  FFF3D48F-FFF3D556 (file 33D48F) callers: FFF3C625(sub_FFF3C4BC)
FFF3D48F  7ea6                   sub_FFF3D48F push.l  r6   ; <<<< FUNC sub_FFF3D48F
FFF3D491  6040                              sub     #4, sp
FFF3D493  f80500                            mov.w   #0, 4+var_4[sp]
FFF3D496  71060c                            add     #4+arg_0, sp, r6
FFF3D499  fb1258250100                      mov.l   #12558h, r1
FFF3D49F  6602                              mov.l   #0, r2
FFF3D4A1  9212                              mov.w   r2, 10h[r1]
FFF3D4A3  a09a                              mov.l   r2, 0Ch[r1]
FFF3D4A5  a092                              mov.l   r2, 8[r1]
FFF3D4A7  a01a                              mov.l   r2, 4[r1]
FFF3D4A9  e312                              mov.l   r2, [r1]
FFF3D4AB  fb1262080100                      mov.l   #10862h, r1
FFF3D4B1  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3D4B7  e0e1                              mov.l   [r14], [r1]
FFF3D4B9  a8e4                              mov.l   8[r6], r4
FFF3D4BB  fb36ff                            mov.l   #-1, r3
FFF3D4BE  6602                              mov.l   #0, r2
FFF3D4C0  7f80                              suntil.b
FFF3D4C2  6011                              sub     #1, r1
FFF3D4C4  ef42                              mov.l   r4, r2
FFF3D4C6  7f87                              smovu
FFF3D4C8  754312                            mov.l   #12h, r3
FFF3D4CB  fb2234250100                      mov.l   #12534h, r2
FFF3D4D1  fb1258250100                      mov.l   #12558h, r1
FFF3D4D7  7f8f                              smovf
FFF3D4D9  fb1262080100                      mov.l   #10862h, r1
FFF3D4DF  05f456fd                          bsr.a   sub_FFF12BD3
FFF3D4E3  d301                              mov.w   r1, 4+var_4[sp]
FFF3D4E5  5c01                              movu.w  4+var_4[sp], r1
FFF3D4E7  6101                              cmp     #0, r1
FFF3D4E9  200e                              beq.b   loc_FFF3D4F7
FFF3D4EB  fbe258250100                      mov.l   #12558h, r14
FFF3D4F1  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D4F6  0a                                bra.s   loc_FFF3D500
FFF3D4F7  fb1258250100           loc_FFF3D4F7 mov.l   #12558h, r1
FFF3D4FD  3d1300                            mov.w   #0, 6[r1]
FFF3D500  fb1258250100           loc_FFF3D500 mov.l   #12558h, r1
FFF3D506  3d1090                            mov.w   #-70h, [r1]
FFF3D509  fb1258250100                      mov.l   #12558h, r1
FFF3D50F  3d1101                            mov.w   #1, 2[r1]
FFF3D512  fbe258250100                      mov.l   #12558h, r14
FFF3D518  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D51E  d4fe02                            mov.w   [r15], 4[r14]
FFF3D521  3d6c00                            mov.w   #0, 18h[r6]
FFF3D524  7100c8                            add     #-38h, sp, sp
FFF3D527  754312                            mov.l   #12h, r3
FFF3D52A  fb2258250100                      mov.l   #12558h, r2
FFF3D530  ef01                              mov.l   sp, r1
FFF3D532  7f8f                              smovf
FFF3D534  ef01                              mov.l   sp, r1
FFF3D536  711114                            add     #14h, r1, r1
FFF3D539  754324                            mov.l   #24h, r3 ; '$'
FFF3D53C  ef62                              mov.l   r6, r2
FFF3D53E  7f8f                              smovf
FFF3D540  6602                              mov.l   #0, r2
FFF3D542  7541fe                            mov.l   #-2, r1
FFF3D545  059703fa                          bsr.a   sub_FFEDD8DC
FFF3D549  710038                            add     #38h, sp, sp ; '8'
FFF3D54C  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3D54F  9809                              mov.w   4+var_2[sp], r1
FFF3D551  5f11                              movu.w  r1, r1
FFF3D553  3f6602                            rtsd    #8, r6-r6

; ######## sub_FFF3D680  FFF3D680-FFF3D887 (file 33D680) callers: FFF3C75D(sub_FFF3C4BC)
FFF3D680  6080                   sub_FFF3D680 sub     #8, sp   ; <<<< FUNC sub_FFF3D680
FFF3D682  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3D685  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3D688  fb12f0840600                      mov.l   #684F0h, r1
FFF3D68E  b819                              movu.w  2[r1], r1
FFF3D690  6111                              cmp     #1, r1
FFF3D692  18                                bne.s   loc_FFF3D69A
FFF3D693  f809ffff                          mov.w   #-1, 8+var_8[sp]
FFF3D697  38e901                            bra.w   loc_FFF3D880
FFF3D69A  fbe2f0840600           loc_FFF3D69A mov.l   #684F0h, r14
FFF3D6A0  f8e500                            mov.w   #0, [r14]
FFF3D6A3  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3D6A6  2e49                              bra.b   loc_FFF3D6EF
FFF3D6A8  b809                   loc_FFF3D6A8 movu.w  8+var_6[sp], r1
FFF3D6AA  751124                            mul     #24h, r1 ; '$'
FFF3D6AD  fbe260840600                      mov.l   #68460h, r14
FFF3D6B3  4b1e                              add     r1, r14
FFF3D6B5  5cee                              movu.w  [r14], r14
FFF3D6B7  755e5a                            cmp     #5Ah, r14 ; 'Z'
FFF3D6BA  212f                              bne.b   loc_FFF3D6E9
FFF3D6BC  b809                              movu.w  8+var_6[sp], r1
FFF3D6BE  751124                            mul     #24h, r1 ; '$'
FFF3D6C1  fb2260840600                      mov.l   #68460h, r2
FFF3D6C7  4b12                              add     r1, r2
FFF3D6C9  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D6CF  5ce1                              movu.w  [r14], r1
FFF3D6D1  751124                            mul     #24h, r1 ; '$'
FFF3D6D4  0689e102                          add     8[r14].l, r1
FFF3D6D8  754324                            mov.l   #24h, r3 ; '$'
FFF3D6DB  7f8f                              smovf
FFF3D6DD  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D6E3  dcef                              mov.w   [r14], r15
FFF3D6E5  621f                              add     #1, r15
FFF3D6E7  d3ef                              mov.w   r15, [r14]
FFF3D6E9  9809                   loc_FFF3D6E9 mov.w   8+var_6[sp], r1
FFF3D6EB  6211                              add     #1, r1
FFF3D6ED  9009                              mov.w   r1, 8+var_6[sp]
FFF3D6EF  fbe234250100           loc_FFF3D6EF mov.l   #12534h, r14
FFF3D6F5  b809                              movu.w  8+var_6[sp], r1
FFF3D6F7  06c5e101                          cmp     2[r14].uw, r1
FFF3D6FB  29ad                              blt.b   loc_FFF3D6A8
FFF3D6FD  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D703  5cee                              movu.w  [r14], r14
FFF3D705  610e                              cmp     #0, r14
FFF3D707  3a7601                            beq.w   loc_FFF3D87D
FFF3D70A  fb12f0840600                      mov.l   #684F0h, r1
FFF3D710  3d1101                            mov.w   #1, 2[r1]
FFF3D713  fbe25f080100                      mov.l   #1085Fh, r14
FFF3D719  f8e405                            mov.b   #5, [r14]
FFF3D71C  fb12f0840600                      mov.l   #684F0h, r1
FFF3D722  3d1200                            mov.w   #0, 4[r1]
FFF3D725  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3D728  384501                            bra.w   loc_FFF3D86D
FFF3D72B  fb1262080100           loc_FFF3D72B mov.l   #10862h, r1
FFF3D731  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3D737  e0e1                              mov.l   [r14], [r1]
FFF3D739  fb22f0840600                      mov.l   #684F0h, r2
FFF3D73F  a8a2                              mov.l   8[r2], r2
FFF3D741  a8a4                              mov.l   8[r2], r4
FFF3D743  fb36ff                            mov.l   #-1, r3
FFF3D746  6602                              mov.l   #0, r2
FFF3D748  7f80                              suntil.b
FFF3D74A  6011                              sub     #1, r1
FFF3D74C  ef42                              mov.l   r4, r2
FFF3D74E  7f87                              smovu
FFF3D750  fbe6ff                            mov.l   #-1, r14
FFF3D753  660f                              mov.l   #0, r15
FFF3D755  fb5262080100                      mov.l   #10862h, r5
FFF3D75B  ef51                              mov.l   r5, r1
FFF3D75D  eff2                              mov.l   r15, r2
FFF3D75F  efe3                              mov.l   r14, r3
FFF3D761  7f80                              suntil.b
FFF3D763  6011                              sub     #1, r1
FFF3D765  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3D76B  7f87                              smovu
FFF3D76D  fb12f0840600                      mov.l   #684F0h, r1
FFF3D773  a891                              mov.l   8[r1], r1
FFF3D775  a89c                              mov.l   0Ch[r1], r4
FFF3D777  ef51                              mov.l   r5, r1
FFF3D779  eff2                              mov.l   r15, r2
FFF3D77B  efe3                              mov.l   r14, r3
FFF3D77D  7f80                              suntil.b
FFF3D77F  6011                              sub     #1, r1
FFF3D781  ef42                              mov.l   r4, r2
FFF3D783  7f87                              smovu
FFF3D785  fb12f0840600                      mov.l   #684F0h, r1
FFF3D78B  9892                              mov.w   4[r1], r2
FFF3D78D  6212                              add     #1, r2
FFF3D78F  9092                              mov.w   r2, 4[r1]
FFF3D791  fb1258250100                      mov.l   #12558h, r1
FFF3D797  6602                              mov.l   #0, r2
FFF3D799  9212                              mov.w   r2, 10h[r1]
FFF3D79B  a09a                              mov.l   r2, 0Ch[r1]
FFF3D79D  a092                              mov.l   r2, 8[r1]
FFF3D79F  a01a                              mov.l   r2, 4[r1]
FFF3D7A1  e312                              mov.l   r2, [r1]
FFF3D7A3  754312                            mov.l   #12h, r3
FFF3D7A6  fb2246250100                      mov.l   #12546h, r2
FFF3D7AC  fb1258250100                      mov.l   #12558h, r1
FFF3D7B2  7f8f                              smovf
FFF3D7B4  fb12f0840600                      mov.l   #684F0h, r1
FFF3D7BA  a891                              mov.l   8[r1], r1
FFF3D7BC  a99a                              mov.l   1Ch[r1], r2
FFF3D7BE  fb3287d8f3ff                      mov.l   #sub_FFF3D887, r3
FFF3D7C4  fb1262080100                      mov.l   #10862h, r1
FFF3D7CA  05e059fd                          bsr.a   sub_FFF131AA
FFF3D7CE  9081                              mov.w   r1, 8+var_4[sp]
FFF3D7D0  b881                              movu.w  8+var_4[sp], r1
FFF3D7D2  6101                              cmp     #0, r1
FFF3D7D4  3aa900                            beq.w   loc_FFF3D87D
FFF3D7D7  fbe258250100                      mov.l   #12558h, r14
FFF3D7DD  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D7E2  fb1258250100                      mov.l   #12558h, r1
FFF3D7E8  3d1090                            mov.w   #-70h, [r1]
FFF3D7EB  fb1258250100                      mov.l   #12558h, r1
FFF3D7F1  3d1101                            mov.w   #1, 2[r1]
FFF3D7F4  fbe258250100                      mov.l   #12558h, r14
FFF3D7FA  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D800  d4fe02                            mov.w   [r15], 4[r14]
FFF3D803  fb12f0840600                      mov.l   #684F0h, r1
FFF3D809  a891                              mov.l   8[r1], r1
FFF3D80B  3d1c00                            mov.w   #0, 18h[r1]
FFF3D80E  fb12f0840600                      mov.l   #684F0h, r1
FFF3D814  a894                              mov.l   8[r1], r4
FFF3D816  7100c8                            add     #-38h, sp, sp
FFF3D819  754312                            mov.l   #12h, r3
FFF3D81C  fb2258250100                      mov.l   #12558h, r2
FFF3D822  ef01                              mov.l   sp, r1
FFF3D824  7f8f                              smovf
FFF3D826  ef01                              mov.l   sp, r1
FFF3D828  711114                            add     #14h, r1, r1
FFF3D82B  754324                            mov.l   #24h, r3 ; '$'
FFF3D82E  ef42                              mov.l   r4, r2
FFF3D830  7f8f                              smovf
FFF3D832  6602                              mov.l   #0, r2
FFF3D834  7541fe                            mov.l   #-2, r1
FFF3D837  05a500fa                          bsr.a   sub_FFEDD8DC
FFF3D83B  710038                            add     #38h, sp, sp ; '8'
FFF3D83E  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D844  5cef                              movu.w  [r14], r15
FFF3D846  06c5ef02                          cmp     4[r14].uw, r15
FFF3D84A  211d                              bne.b   loc_FFF3D867
FFF3D84C  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D852  f8e500                            mov.w   #0, [r14]
FFF3D855  fb12f0840600                      mov.l   #684F0h, r1
FFF3D85B  3d1200                            mov.w   #0, 4[r1]
FFF3D85E  fb12f0840600                      mov.l   #684F0h, r1
FFF3D864  3d1100                            mov.w   #0, 2[r1]
FFF3D867  9809                   loc_FFF3D867 mov.w   8+var_6[sp], r1
FFF3D869  6211                              add     #1, r1
FFF3D86B  9009                              mov.w   r1, 8+var_6[sp]
FFF3D86D  fbe2f0840600           loc_FFF3D86D mov.l   #684F0h, r14
FFF3D873  b809                              movu.w  8+var_6[sp], r1
FFF3D875  06c4e1                            cmp     [r14].uw, r1
FFF3D878  2805                              bge.b   loc_FFF3D87D
FFF3D87A  38b1fe                            bra.w   loc_FFF3D72B
FFF3D87D  f80500                 loc_FFF3D87D mov.w   #0, 8+var_8[sp]
FFF3D880  d40003                 loc_FFF3D880 mov.w   8+var_8[sp], 8+var_2[sp]
FFF3D883  b889                              movu.w  8+var_2[sp], r1
FFF3D885  6702                              rtsd    #2

; ######## sub_FFF3D887  FFF3D887-FFF3DB6E (file 33D887) callers: 
FFF3D887  6080                   sub_FFF3D887 sub     #8, sp   ; <<<< FUNC sub_FFF3D887
FFF3D889  9089                              mov.w   r1, 8+var_2[sp]
FFF3D88B  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3D88E  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3D891  f80500                            mov.w   #0, 8+var_8[sp]
FFF3D894  fb1258250100                      mov.l   #12558h, r1
FFF3D89A  6602                              mov.l   #0, r2
FFF3D89C  9212                              mov.w   r2, 10h[r1]
FFF3D89E  a09a                              mov.l   r2, 0Ch[r1]
FFF3D8A0  a092                              mov.l   r2, 8[r1]
FFF3D8A2  a01a                              mov.l   r2, 4[r1]
FFF3D8A4  e312                              mov.l   r2, [r1]
FFF3D8A6  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D8AC  d5e00202                          mov.w   4[r14], 8+var_4[sp]
FFF3D8B0  b889                              movu.w  8+var_2[sp], r1
FFF3D8B2  6101                              cmp     #0, r1
FFF3D8B4  3b8d00                            bne.w   loc_FFF3D941
FFF3D8B7  754312                            mov.l   #12h, r3
FFF3D8BA  fb2246250100                      mov.l   #12546h, r2
FFF3D8C0  fb1258250100                      mov.l   #12558h, r1
FFF3D8C6  7f8f                              smovf
FFF3D8C8  fb1258250100                      mov.l   #12558h, r1
FFF3D8CE  3d1300                            mov.w   #0, 6[r1]
FFF3D8D1  b881                              movu.w  8+var_4[sp], r1
FFF3D8D3  6011                              sub     #1, r1
FFF3D8D5  d301                              mov.w   r1, 8+var_8[sp]
FFF3D8D7  fb1258250100                      mov.l   #12558h, r1
FFF3D8DD  3d1090                            mov.w   #-70h, [r1]
FFF3D8E0  fb1258250100                      mov.l   #12558h, r1
FFF3D8E6  3d1101                            mov.w   #1, 2[r1]
FFF3D8E9  fbe258250100                      mov.l   #12558h, r14
FFF3D8EF  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D8F5  d4fe02                            mov.w   [r15], 4[r14]
FFF3D8F8  5c01                              movu.w  8+var_8[sp], r1
FFF3D8FA  751124                            mul     #24h, r1 ; '$'
FFF3D8FD  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D903  0689e102                          add     8[r14].l, r1
FFF3D907  3d1c00                            mov.w   #0, 18h[r1]
FFF3D90A  5c04                              movu.w  8+var_8[sp], r4
FFF3D90C  751424                            mul     #24h, r4 ; '$'
FFF3D90F  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D915  0689e402                          add     8[r14].l, r4
FFF3D919  7100c8                            add     #-38h, sp, sp
FFF3D91C  754312                            mov.l   #12h, r3
FFF3D91F  fb2258250100                      mov.l   #12558h, r2
FFF3D925  ef01                              mov.l   sp, r1
FFF3D927  7f8f                              smovf
FFF3D929  ef01                              mov.l   sp, r1
FFF3D92B  711114                            add     #14h, r1, r1
FFF3D92E  754324                            mov.l   #24h, r3 ; '$'
FFF3D931  ef42                              mov.l   r4, r2
FFF3D933  7f8f                              smovf
FFF3D935  6602                              mov.l   #0, r2
FFF3D937  7541fe                            mov.l   #-2, r1
FFF3D93A  05a2fff9                          bsr.a   sub_FFEDD8DC
FFF3D93E  710038                            add     #38h, sp, sp ; '8'
FFF3D941  b889                   loc_FFF3D941 movu.w  8+var_2[sp], r1
FFF3D943  6111                              cmp     #1, r1
FFF3D945  3b8f00                            bne.w   loc_FFF3D9D4
FFF3D948  754312                            mov.l   #12h, r3
FFF3D94B  fb2246250100                      mov.l   #12546h, r2
FFF3D951  fb1258250100                      mov.l   #12558h, r1
FFF3D957  7f8f                              smovf
FFF3D959  fbe258250100                      mov.l   #12558h, r14
FFF3D95F  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D964  b881                              movu.w  8+var_4[sp], r1
FFF3D966  6011                              sub     #1, r1
FFF3D968  d301                              mov.w   r1, 8+var_8[sp]
FFF3D96A  fb1258250100                      mov.l   #12558h, r1
FFF3D970  3d1090                            mov.w   #-70h, [r1]
FFF3D973  fb1258250100                      mov.l   #12558h, r1
FFF3D979  3d1101                            mov.w   #1, 2[r1]
FFF3D97C  fbe258250100                      mov.l   #12558h, r14
FFF3D982  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D988  d4fe02                            mov.w   [r15], 4[r14]
FFF3D98B  5c01                              movu.w  8+var_8[sp], r1
FFF3D98D  751124                            mul     #24h, r1 ; '$'
FFF3D990  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D996  0689e102                          add     8[r14].l, r1
FFF3D99A  3d1c00                            mov.w   #0, 18h[r1]
FFF3D99D  5c04                              movu.w  8+var_8[sp], r4
FFF3D99F  751424                            mul     #24h, r4 ; '$'
FFF3D9A2  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D9A8  0689e402                          add     8[r14].l, r4
FFF3D9AC  7100c8                            add     #-38h, sp, sp
FFF3D9AF  754312                            mov.l   #12h, r3
FFF3D9B2  fb2258250100                      mov.l   #12558h, r2
FFF3D9B8  ef01                              mov.l   sp, r1
FFF3D9BA  7f8f                              smovf
FFF3D9BC  ef01                              mov.l   sp, r1
FFF3D9BE  711114                            add     #14h, r1, r1
FFF3D9C1  754324                            mov.l   #24h, r3 ; '$'
FFF3D9C4  ef42                              mov.l   r4, r2
FFF3D9C6  7f8f                              smovf
FFF3D9C8  6602                              mov.l   #0, r2
FFF3D9CA  7541fe                            mov.l   #-2, r1
FFF3D9CD  050ffff9                          bsr.a   sub_FFEDD8DC
FFF3D9D1  710038                            add     #38h, sp, sp ; '8'
FFF3D9D4  fbe2f0840600           loc_FFF3D9D4 mov.l   #684F0h, r14
FFF3D9DA  b881                              movu.w  8+var_4[sp], r1
FFF3D9DC  06c4e1                            cmp     [r14].uw, r1
FFF3D9DF  2905                              blt.b   loc_FFF3D9E4
FFF3D9E1  386e01                            bra.w   loc_FFF3DB4F
FFF3D9E4  d10002                 loc_FFF3D9E4 mov.w   8+var_4[sp], 8+var_8[sp]
FFF3D9E7  385601                            bra.w   loc_FFF3DB3D
FFF3D9EA  fb1262080100           loc_FFF3D9EA mov.l   #10862h, r1
FFF3D9F0  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3D9F6  e0e1                              mov.l   [r14], [r1]
FFF3D9F8  5c02                              movu.w  8+var_8[sp], r2
FFF3D9FA  751224                            mul     #24h, r2 ; '$'
FFF3D9FD  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DA03  0689e202                          add     8[r14].l, r2
FFF3DA07  a8a4                              mov.l   8[r2], r4
FFF3DA09  fb36ff                            mov.l   #-1, r3
FFF3DA0C  6602                              mov.l   #0, r2
FFF3DA0E  7f80                              suntil.b
FFF3DA10  6011                              sub     #1, r1
FFF3DA12  ef42                              mov.l   r4, r2
FFF3DA14  7f87                              smovu
FFF3DA16  fbe6ff                            mov.l   #-1, r14
FFF3DA19  660f                              mov.l   #0, r15
FFF3DA1B  fb5262080100                      mov.l   #10862h, r5
FFF3DA21  ef51                              mov.l   r5, r1
FFF3DA23  eff2                              mov.l   r15, r2
FFF3DA25  efe3                              mov.l   r14, r3
FFF3DA27  7f80                              suntil.b
FFF3DA29  6011                              sub     #1, r1
FFF3DA2B  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3DA31  7f87                              smovu
FFF3DA33  5c01                              movu.w  8+var_8[sp], r1
FFF3DA35  751124                            mul     #24h, r1 ; '$'
FFF3DA38  fb42f0840600                      mov.l   #684F0h, r4
FFF3DA3E  06894102                          add     8[r4].l, r1
FFF3DA42  a89c                              mov.l   0Ch[r1], r4
FFF3DA44  ef51                              mov.l   r5, r1
FFF3DA46  eff2                              mov.l   r15, r2
FFF3DA48  efe3                              mov.l   r14, r3
FFF3DA4A  7f80                              suntil.b
FFF3DA4C  6011                              sub     #1, r1
FFF3DA4E  ef42                              mov.l   r4, r2
FFF3DA50  7f87                              smovu
FFF3DA52  fb12f0840600                      mov.l   #684F0h, r1
FFF3DA58  9892                              mov.w   4[r1], r2
FFF3DA5A  6212                              add     #1, r2
FFF3DA5C  9092                              mov.w   r2, 4[r1]
FFF3DA5E  754312                            mov.l   #12h, r3
FFF3DA61  fb2246250100                      mov.l   #12546h, r2
FFF3DA67  fb1258250100                      mov.l   #12558h, r1
FFF3DA6D  7f8f                              smovf
FFF3DA6F  5c01                              movu.w  8+var_8[sp], r1
FFF3DA71  751124                            mul     #24h, r1 ; '$'
FFF3DA74  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DA7A  0689e102                          add     8[r14].l, r1
FFF3DA7E  a99a                              mov.l   1Ch[r1], r2
FFF3DA80  fb3287d8f3ff                      mov.l   #sub_FFF3D887, r3
FFF3DA86  fb1262080100                      mov.l   #10862h, r1
FFF3DA8C  051e57fd                          bsr.a   sub_FFF131AA
FFF3DA90  9009                              mov.w   r1, 8+var_6[sp]
FFF3DA92  b809                              movu.w  8+var_6[sp], r1
FFF3DA94  6101                              cmp     #0, r1
FFF3DA96  3ad600                            beq.w   loc_FFF3DB6C
FFF3DA99  fbe258250100                      mov.l   #12558h, r14
FFF3DA9F  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3DAA4  fb1258250100                      mov.l   #12558h, r1
FFF3DAAA  3d1090                            mov.w   #-70h, [r1]
FFF3DAAD  fb1258250100                      mov.l   #12558h, r1
FFF3DAB3  3d1101                            mov.w   #1, 2[r1]
FFF3DAB6  fbe258250100                      mov.l   #12558h, r14
FFF3DABC  fbf26c250100                      mov.l   #1256Ch, r15
FFF3DAC2  d4fe02                            mov.w   [r15], 4[r14]
FFF3DAC5  5c01                              movu.w  8+var_8[sp], r1
FFF3DAC7  751124                            mul     #24h, r1 ; '$'
FFF3DACA  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DAD0  0689e102                          add     8[r14].l, r1
FFF3DAD4  3d1c00                            mov.w   #0, 18h[r1]
FFF3DAD7  5c04                              movu.w  8+var_8[sp], r4
FFF3DAD9  751424                            mul     #24h, r4 ; '$'
FFF3DADC  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DAE2  0689e402                          add     8[r14].l, r4
FFF3DAE6  7100c8                            add     #-38h, sp, sp
FFF3DAE9  754312                            mov.l   #12h, r3
FFF3DAEC  fb2258250100                      mov.l   #12558h, r2
FFF3DAF2  ef01                              mov.l   sp, r1
FFF3DAF4  7f8f                              smovf
FFF3DAF6  ef01                              mov.l   sp, r1
FFF3DAF8  711114                            add     #14h, r1, r1
FFF3DAFB  754324                            mov.l   #24h, r3 ; '$'
FFF3DAFE  ef42                              mov.l   r4, r2
FFF3DB00  7f8f                              smovf
FFF3DB02  6602                              mov.l   #0, r2
FFF3DB04  7541fe                            mov.l   #-2, r1
FFF3DB07  05d5fdf9                          bsr.a   sub_FFEDD8DC
FFF3DB0B  710038                            add     #38h, sp, sp ; '8'
FFF3DB0E  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DB14  5cef                              movu.w  [r14], r15
FFF3DB16  06c5ef02                          cmp     4[r14].uw, r15
FFF3DB1A  211d                              bne.b   loc_FFF3DB37
FFF3DB1C  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DB22  f8e500                            mov.w   #0, [r14]
FFF3DB25  fb12f0840600                      mov.l   #684F0h, r1
FFF3DB2B  3d1200                            mov.w   #0, 4[r1]
FFF3DB2E  fb12f0840600                      mov.l   #684F0h, r1
FFF3DB34  3d1100                            mov.w   #0, 2[r1]
FFF3DB37  dc01                   loc_FFF3DB37 mov.w   8+var_8[sp], r1
FFF3DB39  6211                              add     #1, r1
FFF3DB3B  d301                              mov.w   r1, 8+var_8[sp]
FFF3DB3D  fbe2f0840600           loc_FFF3DB3D mov.l   #684F0h, r14
FFF3DB43  5c01                              movu.w  8+var_8[sp], r1
FFF3DB45  06c4e1                            cmp     [r14].uw, r1
FFF3DB48  2805                              bge.b   loc_FFF3DB4D
FFF3DB4A  38a0fe                            bra.w   loc_FFF3D9EA
FFF3DB4D  2e1f                   loc_FFF3DB4D bra.b   loc_FFF3DB6C
FFF3DB4F  fbe2f0840600           loc_FFF3DB4F mov.l   #684F0h, r14
FFF3DB55  f8e500                            mov.w   #0, [r14]
FFF3DB58  fb12f0840600                      mov.l   #684F0h, r1
FFF3DB5E  3d1200                            mov.w   #0, 4[r1]
FFF3DB61  fb12f0840600                      mov.l   #684F0h, r1
FFF3DB67  3d1100                            mov.w   #0, 2[r1]
FFF3DB6A  6702                              rtsd    #2
FFF3DB6C  6702                   loc_FFF3DB6C rtsd    #2

; ######## sub_FFF3DE6A  FFF3DE6A-FFF3DF66 (file 33DE6A) callers: FFF3DDCB(sub_FFF3DB6E)
FFF3DE6A  7ea6                   sub_FFF3DE6A push.l  r6   ; <<<< FUNC sub_FFF3DE6A
FFF3DE6C  6040                              sub     #4, sp
FFF3DE6E  f80500                            mov.w   #0, 4+var_4[sp]
FFF3DE71  71060c                            add     #4+arg_0, sp, r6
FFF3DE74  fb1258250100                      mov.l   #12558h, r1
FFF3DE7A  6602                              mov.l   #0, r2
FFF3DE7C  9212                              mov.w   r2, 10h[r1]
FFF3DE7E  a09a                              mov.l   r2, 0Ch[r1]
FFF3DE80  a092                              mov.l   r2, 8[r1]
FFF3DE82  a01a                              mov.l   r2, 4[r1]
FFF3DE84  e312                              mov.l   r2, [r1]
FFF3DE86  fb1262080100                      mov.l   #10862h, r1
FFF3DE8C  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3DE92  e0e1                              mov.l   [r14], [r1]
FFF3DE94  a8e4                              mov.l   8[r6], r4
FFF3DE96  fb36ff                            mov.l   #-1, r3
FFF3DE99  6602                              mov.l   #0, r2
FFF3DE9B  7f80                              suntil.b
FFF3DE9D  6011                              sub     #1, r1
FFF3DE9F  ef42                              mov.l   r4, r2
FFF3DEA1  7f87                              smovu
FFF3DEA3  fbe6ff                            mov.l   #-1, r14
FFF3DEA6  660f                              mov.l   #0, r15
FFF3DEA8  fb5262080100                      mov.l   #10862h, r5
FFF3DEAE  ef51                              mov.l   r5, r1
FFF3DEB0  eff2                              mov.l   r15, r2
FFF3DEB2  efe3                              mov.l   r14, r3
FFF3DEB4  7f80                              suntil.b
FFF3DEB6  6011                              sub     #1, r1
FFF3DEB8  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3DEBE  7f87                              smovu
FFF3DEC0  a8ec                              mov.l   0Ch[r6], r4
FFF3DEC2  ef51                              mov.l   r5, r1
FFF3DEC4  eff2                              mov.l   r15, r2
FFF3DEC6  efe3                              mov.l   r14, r3
FFF3DEC8  7f80                              suntil.b
FFF3DECA  6011                              sub     #1, r1
FFF3DECC  ef42                              mov.l   r4, r2
FFF3DECE  7f87                              smovu
FFF3DED0  754312                            mov.l   #12h, r3
FFF3DED3  fb2234250100                      mov.l   #12534h, r2
FFF3DED9  fb1258250100                      mov.l   #12558h, r1
FFF3DEDF  7f8f                              smovf
FFF3DEE1  fb3262e0f3ff                      mov.l   #sub_FFF3E062, r3
FFF3DEE7  6602                              mov.l   #0, r2
FFF3DEE9  fb1262080100                      mov.l   #10862h, r1
FFF3DEEF  05306ffd                          bsr.a   sub_FFF14E1F
FFF3DEF3  d301                              mov.w   r1, 4+var_4[sp]
FFF3DEF5  5c01                              movu.w  4+var_4[sp], r1
FFF3DEF7  6101                              cmp     #0, r1
FFF3DEF9  200e                              beq.b   loc_FFF3DF07
FFF3DEFB  fbe258250100                      mov.l   #12558h, r14
FFF3DF01  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3DF06  0a                                bra.s   loc_FFF3DF10
FFF3DF07  fb1258250100           loc_FFF3DF07 mov.l   #12558h, r1
FFF3DF0D  3d1300                            mov.w   #0, 6[r1]
FFF3DF10  fb1258250100           loc_FFF3DF10 mov.l   #12558h, r1
FFF3DF16  3d1090                            mov.w   #-70h, [r1]
FFF3DF19  fb1258250100                      mov.l   #12558h, r1
FFF3DF1F  3d1101                            mov.w   #1, 2[r1]
FFF3DF22  fbe258250100                      mov.l   #12558h, r14
FFF3DF28  fbf26c250100                      mov.l   #1256Ch, r15
FFF3DF2E  d4fe02                            mov.w   [r15], 4[r14]
FFF3DF31  3d6c00                            mov.w   #0, 18h[r6]
FFF3DF34  7100c8                            add     #-38h, sp, sp
FFF3DF37  754312                            mov.l   #12h, r3
FFF3DF3A  fb2258250100                      mov.l   #12558h, r2
FFF3DF40  ef01                              mov.l   sp, r1
FFF3DF42  7f8f                              smovf
FFF3DF44  ef01                              mov.l   sp, r1
FFF3DF46  711114                            add     #14h, r1, r1
FFF3DF49  754324                            mov.l   #24h, r3 ; '$'
FFF3DF4C  ef62                              mov.l   r6, r2
FFF3DF4E  7f8f                              smovf
FFF3DF50  6602                              mov.l   #0, r2
FFF3DF52  7541fe                            mov.l   #-2, r1
FFF3DF55  0587f9f9                          bsr.a   sub_FFEDD8DC
FFF3DF59  710038                            add     #38h, sp, sp ; '8'
FFF3DF5C  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3DF5F  9809                              mov.w   4+var_2[sp], r1
FFF3DF61  5f11                              movu.w  r1, r1
FFF3DF63  3f6602                            rtsd    #8, r6-r6

; ######## sub_FFF3DF66  FFF3DF66-FFF3E062 (file 33DF66) callers: FFF3DE22(sub_FFF3DB6E)
FFF3DF66  7ea6                   sub_FFF3DF66 push.l  r6   ; <<<< FUNC sub_FFF3DF66
FFF3DF68  6040                              sub     #4, sp
FFF3DF6A  f80500                            mov.w   #0, 4+var_4[sp]
FFF3DF6D  71060c                            add     #4+arg_0, sp, r6
FFF3DF70  fb1258250100                      mov.l   #12558h, r1
FFF3DF76  6602                              mov.l   #0, r2
FFF3DF78  9212                              mov.w   r2, 10h[r1]
FFF3DF7A  a09a                              mov.l   r2, 0Ch[r1]
FFF3DF7C  a092                              mov.l   r2, 8[r1]
FFF3DF7E  a01a                              mov.l   r2, 4[r1]
FFF3DF80  e312                              mov.l   r2, [r1]
FFF3DF82  fb1262080100                      mov.l   #10862h, r1
FFF3DF88  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3DF8E  e0e1                              mov.l   [r14], [r1]
FFF3DF90  a8e4                              mov.l   8[r6], r4
FFF3DF92  fb36ff                            mov.l   #-1, r3
FFF3DF95  6602                              mov.l   #0, r2
FFF3DF97  7f80                              suntil.b
FFF3DF99  6011                              sub     #1, r1
FFF3DF9B  ef42                              mov.l   r4, r2
FFF3DF9D  7f87                              smovu
FFF3DF9F  fbe6ff                            mov.l   #-1, r14
FFF3DFA2  660f                              mov.l   #0, r15
FFF3DFA4  fb5262080100                      mov.l   #10862h, r5
FFF3DFAA  ef51                              mov.l   r5, r1
FFF3DFAC  eff2                              mov.l   r15, r2
FFF3DFAE  efe3                              mov.l   r14, r3
FFF3DFB0  7f80                              suntil.b
FFF3DFB2  6011                              sub     #1, r1
FFF3DFB4  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3DFBA  7f87                              smovu
FFF3DFBC  a8ec                              mov.l   0Ch[r6], r4
FFF3DFBE  ef51                              mov.l   r5, r1
FFF3DFC0  eff2                              mov.l   r15, r2
FFF3DFC2  efe3                              mov.l   r14, r3
FFF3DFC4  7f80                              suntil.b
FFF3DFC6  6011                              sub     #1, r1
FFF3DFC8  ef42                              mov.l   r4, r2
FFF3DFCA  7f87                              smovu
FFF3DFCC  754312                            mov.l   #12h, r3
FFF3DFCF  fb2234250100                      mov.l   #12534h, r2
FFF3DFD5  fb1258250100                      mov.l   #12558h, r1
FFF3DFDB  7f8f                              smovf
FFF3DFDD  fb3262e0f3ff                      mov.l   #sub_FFF3E062, r3
FFF3DFE3  6612                              mov.l   #1, r2
FFF3DFE5  fb1262080100                      mov.l   #10862h, r1
FFF3DFEB  05346efd                          bsr.a   sub_FFF14E1F
FFF3DFEF  d301                              mov.w   r1, 4+var_4[sp]
FFF3DFF1  5c01                              movu.w  4+var_4[sp], r1
FFF3DFF3  6101                              cmp     #0, r1
FFF3DFF5  200e                              beq.b   loc_FFF3E003
FFF3DFF7  fbe234250100                      mov.l   #12534h, r14
FFF3DFFD  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3E002  0a                                bra.s   loc_FFF3E00C
FFF3E003  fb1234250100           loc_FFF3E003 mov.l   #12534h, r1
FFF3E009  3d1300                            mov.w   #0, 6[r1]
FFF3E00C  fb1258250100           loc_FFF3E00C mov.l   #12558h, r1
FFF3E012  3d1090                            mov.w   #-70h, [r1]
FFF3E015  fb1258250100                      mov.l   #12558h, r1
FFF3E01B  3d1101                            mov.w   #1, 2[r1]
FFF3E01E  fbe258250100                      mov.l   #12558h, r14
FFF3E024  fbf26c250100                      mov.l   #1256Ch, r15
FFF3E02A  d4fe02                            mov.w   [r15], 4[r14]
FFF3E02D  3d6c00                            mov.w   #0, 18h[r6]
FFF3E030  7100c8                            add     #-38h, sp, sp
FFF3E033  754312                            mov.l   #12h, r3
FFF3E036  fb2258250100                      mov.l   #12558h, r2
FFF3E03C  ef01                              mov.l   sp, r1
FFF3E03E  7f8f                              smovf
FFF3E040  ef01                              mov.l   sp, r1
FFF3E042  711114                            add     #14h, r1, r1
FFF3E045  754324                            mov.l   #24h, r3 ; '$'
FFF3E048  ef62                              mov.l   r6, r2
FFF3E04A  7f8f                              smovf
FFF3E04C  6602                              mov.l   #0, r2
FFF3E04E  7541fe                            mov.l   #-2, r1
FFF3E051  058bf8f9                          bsr.a   sub_FFEDD8DC
FFF3E055  710038                            add     #38h, sp, sp ; '8'
FFF3E058  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3E05B  9809                              mov.w   4+var_2[sp], r1
FFF3E05D  5f11                              movu.w  r1, r1
FFF3E05F  3f6602                            rtsd    #8, r6-r6

; ######## sub_FFF3E398  FFF3E398-FFF3E4A7 (file 33E398) callers: FFF3C685(sub_FFF3C4BC)
FFF3E398  7ea6                   sub_FFF3E398 push.l  r6   ; <<<< FUNC sub_FFF3E398
FFF3E39A  60c0                              sub     #0Ch, sp
FFF3E39C  3d0400                            mov.w   #0, 0Ch+var_4[sp]
FFF3E39F  710614                            add     #0Ch+arg_0, sp, r6
FFF3E3A2  3d0300                            mov.w   #0, 0Ch+var_6[sp]
FFF3E3A5  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF3E3A8  3c0301                            mov.b   #1, 0Ch+var_9[sp]
FFF3E3AB  fb1258250100                      mov.l   #12558h, r1
FFF3E3B1  6602                              mov.l   #0, r2
FFF3E3B3  9212                              mov.w   r2, 10h[r1]
FFF3E3B5  a09a                              mov.l   r2, 0Ch[r1]
FFF3E3B7  a092                              mov.l   r2, 8[r1]
FFF3E3B9  a01a                              mov.l   r2, 4[r1]
FFF3E3BB  e312                              mov.l   r2, [r1]
FFF3E3BD  754312                            mov.l   #12h, r3
FFF3E3C0  fb2234250100                      mov.l   #12534h, r2
FFF3E3C6  fb1258250100                      mov.l   #12558h, r1
FFF3E3CC  7f8f                              smovf
FFF3E3CE  2e45                              bra.b   loc_FFF3E413
FFF3E3D0  fb1262080100           loc_FFF3E3D0 mov.l   #10862h, r1
FFF3E3D6  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3E3DC  e0e1                              mov.l   [r14], [r1]
FFF3E3DE  fbe21883edff                      mov.l   #pathtab_bare, r14
FFF3E3E4  b88a                              movu.w  0Ch+var_6[sp], r2
FFF3E3E6  fe62ee                            mov.l   [r2, r14], r14
FFF3E3E9  fb36ff                            mov.l   #-1, r3
FFF3E3EC  6602                              mov.l   #0, r2
FFF3E3EE  7f80                              suntil.b
FFF3E3F0  6011                              sub     #1, r1
FFF3E3F2  efe2                              mov.l   r14, r2
FFF3E3F4  7f87                              smovu
FFF3E3F6  fb1262080100                      mov.l   #10862h, r1
FFF3E3FC  05fd47fd                          bsr.a   sub_FFF12BF9
FFF3E400  8089                              mov.b   r1, 0Ch+var_9[sp]
FFF3E402  b089                              movu.b  0Ch+var_9[sp], r1
FFF3E404  6111                              cmp     #1, r1
FFF3E406  17                                beq.s   loc_FFF3E40D
FFF3E407  9881                              mov.w   0Ch+var_8[sp], r1
FFF3E409  6211                              add     #1, r1
FFF3E40B  9081                              mov.w   r1, 0Ch+var_8[sp]
FFF3E40D  9889                   loc_FFF3E40D mov.w   0Ch+var_6[sp], r1
FFF3E40F  6211                              add     #1, r1
FFF3E411  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF3E413  fbe21883edff           loc_FFF3E413 mov.l   #pathtab_bare, r14
FFF3E419  b889                              movu.w  0Ch+var_6[sp], r1
FFF3E41B  fe61ee                            mov.l   [r1, r14], r14
FFF3E41E  610e                              cmp     #0, r14
FFF3E420  21b0                              bne.b   loc_FFF3E3D0
FFF3E422  b881                              movu.w  0Ch+var_8[sp], r1
FFF3E424  6101                              cmp     #0, r1
FFF3E426  15                                beq.s   loc_FFF3E42B
FFF3E427  3d60c9                            mov.w   #-37h, [r6]
FFF3E42A  0c                                bra.s   loc_FFF3E42E
FFF3E42B  3d60c8                 loc_FFF3E42B mov.w   #-38h, [r6]
FFF3E42E  fbe29b220100           loc_FFF3E42E mov.l   #1229Bh, r14
FFF3E434  58ee                              movu.b  [r14], r14
FFF3E436  611e                              cmp     #1, r14
FFF3E438  210d                              bne.b   loc_FFF3E445
FFF3E43A  fb1258250100                      mov.l   #12558h, r1
FFF3E440  3d1300                            mov.w   #0, 6[r1]
FFF3E443  2e0d                              bra.b   loc_FFF3E450
FFF3E445  fbe258250100           loc_FFF3E445 mov.l   #12558h, r14
FFF3E44B  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3E450  fb1258250100           loc_FFF3E450 mov.l   #12558h, r1
FFF3E456  3d1090                            mov.w   #-70h, [r1]
FFF3E459  fb1258250100                      mov.l   #12558h, r1
FFF3E45F  3d1101                            mov.w   #1, 2[r1]
FFF3E462  fbe258250100                      mov.l   #12558h, r14
FFF3E468  fbf26c250100                      mov.l   #1256Ch, r15
FFF3E46E  d4fe02                            mov.w   [r15], 4[r14]
FFF3E471  3d6c00                            mov.w   #0, 18h[r6]
FFF3E474  7100c8                            add     #-38h, sp, sp
FFF3E477  754312                            mov.l   #12h, r3
FFF3E47A  fb2258250100                      mov.l   #12558h, r2
FFF3E480  ef01                              mov.l   sp, r1
FFF3E482  7f8f                              smovf
FFF3E484  ef01                              mov.l   sp, r1
FFF3E486  711114                            add     #14h, r1, r1
FFF3E489  754324                            mov.l   #24h, r3 ; '$'
FFF3E48C  ef62                              mov.l   r6, r2
FFF3E48E  7f8f                              smovf
FFF3E490  6602                              mov.l   #0, r2
FFF3E492  7541fe                            mov.l   #-2, r1
FFF3E495  0547f4f9                          bsr.a   sub_FFEDD8DC
FFF3E499  710038                            add     #38h, sp, sp ; '8'
FFF3E49C  d5000405                          mov.w   0Ch+var_4[sp], 0Ch+var_2[sp]
FFF3E4A0  9909                              mov.w   0Ch+var_2[sp], r1
FFF3E4A2  5f11                              movu.w  r1, r1
FFF3E4A4  3f6604                            rtsd    #10h, r6-r6

; ######## sub_FFF3E4A7  FFF3E4A7-FFF3E98C (file 33E4A7) callers: FFF3C125(sub_FFF3BC97), FFF3C13A(sub_FFF3BC97)
FFF3E4A7  710080                 sub_FFF3E4A7 add     #-80h, sp, sp   ; <<<< FUNC sub_FFF3E4A7
FFF3E4AA  a789                              mov.l   r1, 80h+var_4[sp]
FFF3E4AC  d7023d                            mov.w   r2, 80h+var_6[sp]
FFF3E4AF  a70b                              mov.l   r3, 80h+var_C[sp]
FFF3E4B1  a704                              mov.l   r4, 80h+var_10[sp]
FFF3E4B3  f9053600                          mov.w   #0, 80h+var_14[sp]
FFF3E4B7  f9053500                          mov.w   #0, 80h+var_16[sp]
FFF3E4BB  f9053400                          mov.w   #0, 80h+var_18[sp]
FFF3E4BF  f9053300                          mov.w   #0, 80h+var_1A[sp]
FFF3E4C3  3e8800                            mov.l   #0, 80h+var_20[sp]
FFF3E4C6  af09                              mov.l   80h+var_C[sp], r1
FFF3E4C8  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E4CB  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E4CE  af8a                              mov.l   80h+var_4[sp], r2
FFF3E4D0  fec211                            movu.b  [r2, r1], r1
FFF3E4D3  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E4D6  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E4D9  6211                              add     #1, r1
FFF3E4DB  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E4DE  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E4E1  6c81                              shll    #8, r1
FFF3E4E3  af8a                              mov.l   80h+var_4[sp], r2
FFF3E4E5  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E4E9  5421                              or      [r2], r1
FFF3E4EB  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E4EE  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E4F1  6211                              add     #1, r1
FFF3E4F3  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E4F6  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E4F9  751124                            mul     #24h, r1 ; '$'
FFF3E4FC  fbe2d0830600                      mov.l   #683D0h, r14
FFF3E502  4b1e                              add     r1, r14
FFF3E504  d10e35                            mov.w   80h+var_16[sp], [r14]
FFF3E507  fb12f0840600                      mov.l   #684F0h, r1
FFF3E50D  b819                              movu.w  2[r1], r1
FFF3E50F  6101                              cmp     #0, r1
FFF3E511  2113                              bne.b   loc_FFF3E524
FFF3E513  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E516  751124                            mul     #24h, r1 ; '$'
FFF3E519  fbe260840600                      mov.l   #68460h, r14
FFF3E51F  4b1e                              add     r1, r14
FFF3E521  d10e35                            mov.w   80h+var_16[sp], [r14]
FFF3E524  5d0136                 loc_FFF3E524 movu.w  80h+var_14[sp], r1
FFF3E527  af8a                              mov.l   80h+var_4[sp], r2
FFF3E529  fec211                            movu.b  [r2, r1], r1
FFF3E52C  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E52F  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E532  6211                              add     #1, r1
FFF3E534  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E537  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E53A  6c81                              shll    #8, r1
FFF3E53C  af8a                              mov.l   80h+var_4[sp], r2
FFF3E53E  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E542  5421                              or      [r2], r1
FFF3E544  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E547  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E54A  6211                              add     #1, r1
FFF3E54C  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E54F  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E552  751124                            mul     #24h, r1 ; '$'
FFF3E555  fb22d0830600                      mov.l   #683D0h, r2
FFF3E55B  4b12                              add     r1, r2
FFF3E55D  d5023501                          mov.w   80h+var_16[sp], 2[r2]
FFF3E561  fb12f0840600                      mov.l   #684F0h, r1
FFF3E567  b819                              movu.w  2[r1], r1
FFF3E569  6101                              cmp     #0, r1
FFF3E56B  2114                              bne.b   loc_FFF3E57F
FFF3E56D  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E570  751124                            mul     #24h, r1 ; '$'
FFF3E573  fb2260840600                      mov.l   #68460h, r2
FFF3E579  4b12                              add     r1, r2
FFF3E57B  d5023501                          mov.w   80h+var_16[sp], 2[r2]
FFF3E57F  5d0136                 loc_FFF3E57F movu.w  80h+var_14[sp], r1
FFF3E582  af8a                              mov.l   80h+var_4[sp], r2
FFF3E584  fec211                            movu.b  [r2, r1], r1
FFF3E587  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E58A  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E58D  6211                              add     #1, r1
FFF3E58F  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E592  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E595  6c81                              shll    #8, r1
FFF3E597  af8a                              mov.l   80h+var_4[sp], r2
FFF3E599  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E59D  5421                              or      [r2], r1
FFF3E59F  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E5A2  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E5A5  6211                              add     #1, r1
FFF3E5A7  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E5AA  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E5AD  751124                            mul     #24h, r1 ; '$'
FFF3E5B0  fb22d0830600                      mov.l   #683D0h, r2
FFF3E5B6  4b12                              add     r1, r2
FFF3E5B8  d5023502                          mov.w   80h+var_16[sp], 4[r2]
FFF3E5BC  fb12f0840600                      mov.l   #684F0h, r1
FFF3E5C2  b819                              movu.w  2[r1], r1
FFF3E5C4  6101                              cmp     #0, r1
FFF3E5C6  2114                              bne.b   loc_FFF3E5DA
FFF3E5C8  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E5CB  751124                            mul     #24h, r1 ; '$'
FFF3E5CE  fb2260840600                      mov.l   #68460h, r2
FFF3E5D4  4b12                              add     r1, r2
FFF3E5D6  d5023502                          mov.w   80h+var_16[sp], 4[r2]
FFF3E5DA  d5003633               loc_FFF3E5DA mov.w   80h+var_14[sp], 80h+var_1A[sp]
FFF3E5DE  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E5E1  751124                            mul     #24h, r1 ; '$'
FFF3E5E4  fb22d0830600                      mov.l   #683D0h, r2
FFF3E5EA  4b12                              add     r1, r2
FFF3E5EC  b8a1                              movu.w  4[r2], r1
FFF3E5EE  711eff                            add     #-1, r1, r14
FFF3E5F1  616e                              cmp     #6, r14
FFF3E5F3  2357                              bltu.b  loc_FFF3E64A
FFF3E5F5  6101                              cmp     #0, r1
FFF3E5F7  3b9200                            bne.w   loc_FFF3E689
FFF3E5FA  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E5FD  6211                              add     #1, r1
FFF3E5FF  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E602  f9053400                          mov.w   #0, 80h+var_18[sp]
FFF3E606  2e2f                              bra.b   loc_FFF3E635
FFF3E608  5d0136                 loc_FFF3E608 movu.w  80h+var_14[sp], r1
FFF3E60B  af8a                              mov.l   80h+var_4[sp], r2
FFF3E60D  fec21e                            movu.b  [r2, r1], r14
FFF3E610  610e                              cmp     #0, r14
FFF3E612  202b                              beq.b   loc_FFF3E63D
FFF3E614  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E617  af8a                              mov.l   80h+var_4[sp], r2
FFF3E619  fec21e                            movu.b  [r2, r1], r14
FFF3E61C  710f20                            add     #80h+var_60, sp, r15
FFF3E61F  5d0134                            movu.w  80h+var_18[sp], r1
FFF3E622  fe0f1e                            mov.b   r14, [r15, r1]
FFF3E625  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E628  6211                              add     #1, r1
FFF3E62A  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E62D  dd0134                            mov.w   80h+var_18[sp], r1
FFF3E630  6211                              add     #1, r1
FFF3E632  d70134                            mov.w   r1, 80h+var_18[sp]
FFF3E635  5d0134                 loc_FFF3E635 movu.w  80h+var_18[sp], r1
FFF3E638  755140                            cmp     #40h, r1 ; '@'
FFF3E63B  29cd                              blt.b   loc_FFF3E608
FFF3E63D  5d0134                 loc_FFF3E63D movu.w  80h+var_18[sp], r1
FFF3E640  710e20                            add     #80h+var_60, sp, r14
FFF3E643  660f                              mov.l   #0, r15
FFF3E645  fe0e1f                            mov.b   r15, [r14, r1]
FFF3E648  2e41                              bra.b   loc_FFF3E689
FFF3E64A  f9053400               loc_FFF3E64A mov.w   #0, 80h+var_18[sp]
FFF3E64E  2e34                              bra.b   loc_FFF3E682
FFF3E650  5d013d                 loc_FFF3E650 movu.w  80h+var_6[sp], r1
FFF3E653  751124                            mul     #24h, r1 ; '$'
FFF3E656  fb22d0830600                      mov.l   #683D0h, r2
FFF3E65C  4b12                              add     r1, r2
FFF3E65E  b8a1                              movu.w  4[r2], r1
FFF3E660  06c50134                          cmp     80h+var_18[sp].uw, r1
FFF3E664  2116                              bne.b   loc_FFF3E67A
FFF3E666  fbe21883edff                      mov.l   #pathtab_bare, r14
FFF3E66C  5d0134                            movu.w  80h+var_18[sp], r1
FFF3E66F  fe61e2                            mov.l   [r1, r14], r2
FFF3E672  fb36ff                            mov.l   #-1, r3
FFF3E675  710120                            add     #80h+var_60, sp, r1
FFF3E678  7f87                              smovu
FFF3E67A  dd0134                 loc_FFF3E67A mov.w   80h+var_18[sp], r1
FFF3E67D  6211                              add     #1, r1
FFF3E67F  d70134                            mov.w   r1, 80h+var_18[sp]
FFF3E682  5d0134                 loc_FFF3E682 movu.w  80h+var_18[sp], r1
FFF3E685  6171                              cmp     #7, r1
FFF3E687  29c9                              blt.b   loc_FFF3E650
FFF3E689  5d013d                 loc_FFF3E689 movu.w  80h+var_6[sp], r1
FFF3E68C  751124                            mul     #24h, r1 ; '$'
FFF3E68F  fb22d0830600                      mov.l   #683D0h, r2
FFF3E695  4b12                              add     r1, r2
FFF3E697  a8a1                              mov.l   8[r2], r1
FFF3E699  fb36ff                            mov.l   #-1, r3
FFF3E69C  710220                            add     #80h+var_60, sp, r2
FFF3E69F  7f87                              smovu
FFF3E6A1  fb12f0840600                      mov.l   #684F0h, r1
FFF3E6A7  b819                              movu.w  2[r1], r1
FFF3E6A9  6101                              cmp     #0, r1
FFF3E6AB  211a                              bne.b   loc_FFF3E6C5
FFF3E6AD  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E6B0  751124                            mul     #24h, r1 ; '$'
FFF3E6B3  fb2260840600                      mov.l   #68460h, r2
FFF3E6B9  4b12                              add     r1, r2
FFF3E6BB  a8a1                              mov.l   8[r2], r1
FFF3E6BD  fb36ff                            mov.l   #-1, r3
FFF3E6C0  710220                            add     #80h+var_60, sp, r2
FFF3E6C3  7f87                              smovu
FFF3E6C5  5d0133                 loc_FFF3E6C5 movu.w  80h+var_1A[sp], r1
FFF3E6C8  711140                            add     #40h, r1, r1 ; '@'
FFF3E6CB  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E6CE  d5003633                          mov.w   80h+var_14[sp], 80h+var_1A[sp]
FFF3E6D2  f9053400                          mov.w   #0, 80h+var_18[sp]
FFF3E6D6  2e2e                              bra.b   loc_FFF3E704
FFF3E6D8  5d0136                 loc_FFF3E6D8 movu.w  80h+var_14[sp], r1
FFF3E6DB  af8a                              mov.l   80h+var_4[sp], r2
FFF3E6DD  fec21e                            movu.b  [r2, r1], r14
FFF3E6E0  610e                              cmp     #0, r14
FFF3E6E2  202a                              beq.b   loc_FFF3E70C
FFF3E6E4  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E6E7  af8a                              mov.l   80h+var_4[sp], r2
FFF3E6E9  fec21e                            movu.b  [r2, r1], r14
FFF3E6EC  ef0f                              mov.l   sp, r15
FFF3E6EE  5d0134                            movu.w  80h+var_18[sp], r1
FFF3E6F1  fe0f1e                            mov.b   r14, [r15, r1]
FFF3E6F4  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E6F7  6211                              add     #1, r1
FFF3E6F9  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E6FC  dd0134                            mov.w   80h+var_18[sp], r1
FFF3E6FF  6211                              add     #1, r1
FFF3E701  d70134                            mov.w   r1, 80h+var_18[sp]
FFF3E704  5d0134                 loc_FFF3E704 movu.w  80h+var_18[sp], r1
FFF3E707  755120                            cmp     #20h, r1 ; ' '
FFF3E70A  29ce                              blt.b   loc_FFF3E6D8
FFF3E70C  5d0134                 loc_FFF3E70C movu.w  80h+var_18[sp], r1
FFF3E70F  ef0e                              mov.l   sp, r14
FFF3E711  660f                              mov.l   #0, r15
FFF3E713  fe0e1f                            mov.b   r15, [r14, r1]
FFF3E716  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E719  751124                            mul     #24h, r1 ; '$'
FFF3E71C  fb22d0830600                      mov.l   #683D0h, r2
FFF3E722  4b12                              add     r1, r2
FFF3E724  a8a9                              mov.l   0Ch[r2], r1
FFF3E726  fb36ff                            mov.l   #-1, r3
FFF3E729  ef02                              mov.l   sp, r2
FFF3E72B  7f87                              smovu
FFF3E72D  fb12f0840600                      mov.l   #684F0h, r1
FFF3E733  b819                              movu.w  2[r1], r1
FFF3E735  6101                              cmp     #0, r1
FFF3E737  2119                              bne.b   loc_FFF3E750
FFF3E739  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E73C  751124                            mul     #24h, r1 ; '$'
FFF3E73F  fb2260840600                      mov.l   #68460h, r2
FFF3E745  4b12                              add     r1, r2
FFF3E747  a8a9                              mov.l   0Ch[r2], r1
FFF3E749  fb36ff                            mov.l   #-1, r3
FFF3E74C  ef02                              mov.l   sp, r2
FFF3E74E  7f87                              smovu
FFF3E750  5d0133                 loc_FFF3E750 movu.w  80h+var_1A[sp], r1
FFF3E753  711120                            add     #20h, r1, r1 ; ' '
FFF3E756  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E759  3e8800                            mov.l   #0, 80h+var_20[sp]
FFF3E75C  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E75F  af8a                              mov.l   80h+var_4[sp], r2
FFF3E761  fec211                            movu.b  [r2, r1], r1
FFF3E764  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E766  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E769  6211                              add     #1, r1
FFF3E76B  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E76E  ae01                              mov.l   80h+var_20[sp], r1
FFF3E770  6c81                              shll    #8, r1
FFF3E772  af8a                              mov.l   80h+var_4[sp], r2
FFF3E774  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E778  5421                              or      [r2], r1
FFF3E77A  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E77C  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E77F  6211                              add     #1, r1
FFF3E781  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E784  ae01                              mov.l   80h+var_20[sp], r1
FFF3E786  6c81                              shll    #8, r1
FFF3E788  af8a                              mov.l   80h+var_4[sp], r2
FFF3E78A  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E78E  5421                              or      [r2], r1
FFF3E790  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E792  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E795  6211                              add     #1, r1
FFF3E797  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E79A  ae01                              mov.l   80h+var_20[sp], r1
FFF3E79C  6c81                              shll    #8, r1
FFF3E79E  af8a                              mov.l   80h+var_4[sp], r2
FFF3E7A0  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E7A4  5421                              or      [r2], r1
FFF3E7A6  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E7A8  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E7AB  6211                              add     #1, r1
FFF3E7AD  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E7B0  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E7B3  751124                            mul     #24h, r1 ; '$'
FFF3E7B6  fb22d0830600                      mov.l   #683D0h, r2
FFF3E7BC  4b12                              add     r1, r2
FFF3E7BE  e5021804                          mov.l   80h+var_20[sp], 10h[r2]
FFF3E7C2  fb12f0840600                      mov.l   #684F0h, r1
FFF3E7C8  b819                              movu.w  2[r1], r1
FFF3E7CA  6101                              cmp     #0, r1
FFF3E7CC  2114                              bne.b   loc_FFF3E7E0
FFF3E7CE  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E7D1  751124                            mul     #24h, r1 ; '$'
FFF3E7D4  fb2260840600                      mov.l   #68460h, r2
FFF3E7DA  4b12                              add     r1, r2
FFF3E7DC  e5021804                          mov.l   80h+var_20[sp], 10h[r2]
FFF3E7E0  3e8800                 loc_FFF3E7E0 mov.l   #0, 80h+var_20[sp]
FFF3E7E3  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E7E6  af8a                              mov.l   80h+var_4[sp], r2
FFF3E7E8  fec211                            movu.b  [r2, r1], r1
FFF3E7EB  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E7ED  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E7F0  6211                              add     #1, r1
FFF3E7F2  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E7F5  ae01                              mov.l   80h+var_20[sp], r1
FFF3E7F7  6c81                              shll    #8, r1
FFF3E7F9  af8a                              mov.l   80h+var_4[sp], r2
FFF3E7FB  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E7FF  5421                              or      [r2], r1
FFF3E801  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E803  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E806  6211                              add     #1, r1
FFF3E808  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E80B  ae01                              mov.l   80h+var_20[sp], r1
FFF3E80D  6c81                              shll    #8, r1
FFF3E80F  af8a                              mov.l   80h+var_4[sp], r2
FFF3E811  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E815  5421                              or      [r2], r1
FFF3E817  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E819  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E81C  6211                              add     #1, r1
FFF3E81E  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E821  ae01                              mov.l   80h+var_20[sp], r1
FFF3E823  6c81                              shll    #8, r1
FFF3E825  af8a                              mov.l   80h+var_4[sp], r2
FFF3E827  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E82B  5421                              or      [r2], r1
FFF3E82D  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E82F  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E832  6211                              add     #1, r1
FFF3E834  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E837  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E83A  751124                            mul     #24h, r1 ; '$'
FFF3E83D  fb22d0830600                      mov.l   #683D0h, r2
FFF3E843  4b12                              add     r1, r2
FFF3E845  e5021805                          mov.l   80h+var_20[sp], 14h[r2]
FFF3E849  fb12f0840600                      mov.l   #684F0h, r1
FFF3E84F  b819                              movu.w  2[r1], r1
FFF3E851  6101                              cmp     #0, r1
FFF3E853  2114                              bne.b   loc_FFF3E867
FFF3E855  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E858  751124                            mul     #24h, r1 ; '$'
FFF3E85B  fb2260840600                      mov.l   #68460h, r2
FFF3E861  4b12                              add     r1, r2
FFF3E863  e5021805                          mov.l   80h+var_20[sp], 14h[r2]
FFF3E867  f9053500               loc_FFF3E867 mov.w   #0, 80h+var_16[sp]
FFF3E86B  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E86E  af8a                              mov.l   80h+var_4[sp], r2
FFF3E870  fec211                            movu.b  [r2, r1], r1
FFF3E873  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E876  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E879  6211                              add     #1, r1
FFF3E87B  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E87E  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E881  6c81                              shll    #8, r1
FFF3E883  af8a                              mov.l   80h+var_4[sp], r2
FFF3E885  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E889  5421                              or      [r2], r1
FFF3E88B  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E88E  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E891  6211                              add     #1, r1
FFF3E893  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E896  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E899  751124                            mul     #24h, r1 ; '$'
FFF3E89C  fb22d0830600                      mov.l   #683D0h, r2
FFF3E8A2  4b12                              add     r1, r2
FFF3E8A4  d502350c                          mov.w   80h+var_16[sp], 18h[r2]
FFF3E8A8  fb12f0840600                      mov.l   #684F0h, r1
FFF3E8AE  b819                              movu.w  2[r1], r1
FFF3E8B0  6101                              cmp     #0, r1
FFF3E8B2  2114                              bne.b   loc_FFF3E8C6
FFF3E8B4  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E8B7  751124                            mul     #24h, r1 ; '$'
FFF3E8BA  fb2260840600                      mov.l   #68460h, r2
FFF3E8C0  4b12                              add     r1, r2
FFF3E8C2  d502350c                          mov.w   80h+var_16[sp], 18h[r2]
FFF3E8C6  f9053500               loc_FFF3E8C6 mov.w   #0, 80h+var_16[sp]
FFF3E8CA  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E8CD  af8a                              mov.l   80h+var_4[sp], r2
FFF3E8CF  fec211                            movu.b  [r2, r1], r1
FFF3E8D2  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E8D5  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E8D8  6211                              add     #1, r1
FFF3E8DA  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E8DD  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E8E0  6c81                              shll    #8, r1
FFF3E8E2  af8a                              mov.l   80h+var_4[sp], r2
FFF3E8E4  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E8E8  5421                              or      [r2], r1
FFF3E8EA  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E8ED  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E8F0  6211                              add     #1, r1
FFF3E8F2  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E8F5  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E8F8  751124                            mul     #24h, r1 ; '$'
FFF3E8FB  fb22d0830600                      mov.l   #683D0h, r2
FFF3E901  4b12                              add     r1, r2
FFF3E903  5d0135                            movu.w  80h+var_16[sp], r1
FFF3E906  a1a9                              mov.l   r1, 1Ch[r2]
FFF3E908  fb12f0840600                      mov.l   #684F0h, r1
FFF3E90E  b819                              movu.w  2[r1], r1
FFF3E910  6101                              cmp     #0, r1
FFF3E912  2115                              bne.b   loc_FFF3E927
FFF3E914  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E917  751124                            mul     #24h, r1 ; '$'
FFF3E91A  fb2260840600                      mov.l   #68460h, r2
FFF3E920  4b12                              add     r1, r2
FFF3E922  5d0135                            movu.w  80h+var_16[sp], r1
FFF3E925  a1a9                              mov.l   r1, 1Ch[r2]
FFF3E927  5d0136                 loc_FFF3E927 movu.w  80h+var_14[sp], r1
FFF3E92A  62e1                              add     #0Eh, r1
FFF3E92C  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E92F  f9053400                          mov.w   #0, 80h+var_18[sp]
FFF3E933  2e30                              bra.b   loc_FFF3E963
FFF3E935  5d0136                 loc_FFF3E935 movu.w  80h+var_14[sp], r1
FFF3E938  af8a                              mov.l   80h+var_4[sp], r2
FFF3E93A  fec21e                            movu.b  [r2, r1], r14
FFF3E93D  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E940  751124                            mul     #24h, r1 ; '$'
FFF3E943  fb22d0830600                      mov.l   #683D0h, r2
FFF3E949  4b12                              add     r1, r2
FFF3E94B  aa21                              mov.l   20h[r2], r1
FFF3E94D  5d0234                            movu.w  80h+var_18[sp], r2
FFF3E950  fe012e                            mov.b   r14, [r1, r2]
FFF3E953  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E956  6211                              add     #1, r1
FFF3E958  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E95B  dd0134                            mov.w   80h+var_18[sp], r1
FFF3E95E  6211                              add     #1, r1
FFF3E960  d70134                            mov.w   r1, 80h+var_18[sp]
FFF3E963  5d013d                 loc_FFF3E963 movu.w  80h+var_6[sp], r1
FFF3E966  751124                            mul     #24h, r1 ; '$'
FFF3E969  fbe2d0830600                      mov.l   #683D0h, r14
FFF3E96F  4b1e                              add     r1, r14
FFF3E971  5d0134                            movu.w  80h+var_18[sp], r1
FFF3E974  06c5e10c                          cmp     18h[r14].uw, r1
FFF3E978  29bd                              blt.b   loc_FFF3E935
FFF3E97A  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E97D  af02                              mov.l   80h+var_10[sp], r2
FFF3E97F  e321                              mov.l   r1, [r2]
FFF3E981  f9053700                          mov.w   #0, 80h+var_12[sp]
FFF3E985  dd0137                            mov.w   80h+var_12[sp], r1
FFF3E988  5f11                              movu.w  r1, r1
FFF3E98A  6720                              rtsd    #20h

; ######## sub_FFF3E98C  FFF3E98C-FFF3EAE2 (file 33E98C) callers: FFEDD08D(sub_FFEDC976)
FFF3E98C  7100f0                 sub_FFF3E98C add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3E98C
FFF3E98F  a089                              mov.l   r1, 10h+var_4[sp]
FFF3E991  3d0400                            mov.w   #0, 10h+var_8[sp]
FFF3E994  3d0300                            mov.w   #0, 10h+var_A[sp]
FFF3E997  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E99D  58ee                              movu.b  [r14], r14
FFF3E99F  610e                              cmp     #0, r14
FFF3E9A1  2011                              beq.b   loc_FFF3E9B2
FFF3E9A3  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E9A9  58ee                              movu.b  [r14], r14
FFF3E9AB  61ce                              cmp     #0Ch, r14
FFF3E9AD  15                                beq.s   loc_FFF3E9B2
FFF3E9AE  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3E9B1  0c                                bra.s   loc_FFF3E9B5
FFF3E9B2  f80600                 loc_FFF3E9B2 mov.l   #0, 10h+var_10[sp]
FFF3E9B5  ec01                   loc_FFF3E9B5 mov.l   10h+var_10[sp], r1
FFF3E9B7  6101                              cmp     #0, r1
FFF3E9B9  2011                              beq.b   loc_FFF3E9CA
FFF3E9BB  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E9C1  58ee                              movu.b  [r14], r14
FFF3E9C3  615e                              cmp     #5, r14
FFF3E9C5  15                                beq.s   loc_FFF3E9CA
FFF3E9C6  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3E9C9  0c                                bra.s   loc_FFF3E9CD
FFF3E9CA  f80600                 loc_FFF3E9CA mov.l   #0, 10h+var_10[sp]
FFF3E9CD  ec01                   loc_FFF3E9CD mov.l   10h+var_10[sp], r1
FFF3E9CF  3d0400                            mov.w   #0, 10h+var_8[sp]
FFF3E9D2  6101                              cmp     #0, r1
FFF3E9D4  202f                              beq.b   loc_FFF3EA03
FFF3E9D6  b901                              movu.w  10h+var_8[sp], r1
FFF3E9D8  fbe2661f0100                      mov.l   #11F66h, r14
FFF3E9DE  fbf6a0                            mov.l   #-60h, r15
FFF3E9E1  fe0e1f                            mov.b   r15, [r14, r1]
FFF3E9E4  9901                              mov.w   10h+var_8[sp], r1
FFF3E9E6  6211                              add     #1, r1
FFF3E9E8  9101                              mov.w   r1, 10h+var_8[sp]
FFF3E9EA  b904                              movu.w  10h+var_8[sp], r4
FFF3E9EC  fb32661f0100                      mov.l   #11F66h, r3
FFF3E9F2  6602                              mov.l   #0, r2
FFF3E9F4  7541ea                            mov.l   #-16h, r1
FFF3E9F7  0504edf9                          bsr.a   sub_FFEDD6FB
FFF3E9FB  f90902ffff                        mov.w   #-1, 10h+var_C[sp]
FFF3EA00  38da00                            bra.w   loc_FFF3EADA
FFF3EA03  3d0300                 loc_FFF3EA03 mov.w   #0, 10h+var_A[sp]
FFF3EA06  2e30                              bra.b   loc_FFF3EA36
FFF3EA08  b901                   loc_FFF3EA08 movu.w  10h+var_8[sp], r1
FFF3EA0A  06890103                          add     10h+var_4[sp].l, r1
FFF3EA0E  591e21                            movu.b  21h[r1], r14
FFF3EA11  755eff                            cmp     #-1, r14
FFF3EA14  2028                              beq.b   loc_FFF3EA3C
FFF3EA16  b901                              movu.w  10h+var_8[sp], r1
FFF3EA18  06890103                          add     10h+var_4[sp].l, r1
FFF3EA1C  591e21                            movu.b  21h[r1], r14
FFF3EA1F  fbf266200100                      mov.l   #12066h, r15
FFF3EA25  b889                              movu.w  10h+var_A[sp], r1
FFF3EA27  fe0f1e                            mov.b   r14, [r15, r1]
FFF3EA2A  9901                              mov.w   10h+var_8[sp], r1
FFF3EA2C  6211                              add     #1, r1
FFF3EA2E  9101                              mov.w   r1, 10h+var_8[sp]
FFF3EA30  9889                              mov.w   10h+var_A[sp], r1
FFF3EA32  6211                              add     #1, r1
FFF3EA34  9089                              mov.w   r1, 10h+var_A[sp]
FFF3EA36  b889                   loc_FFF3EA36 movu.w  10h+var_A[sp], r1
FFF3EA38  61f1                              cmp     #0Fh, r1
FFF3EA3A  29ce                              blt.b   loc_FFF3EA08
FFF3EA3C  b889                   loc_FFF3EA3C movu.w  10h+var_A[sp], r1
FFF3EA3E  fbe266200100                      mov.l   #12066h, r14
FFF3EA44  660f                              mov.l   #0, r15
FFF3EA46  fe0e1f                            mov.b   r15, [r14, r1]
FFF3EA49  fb1262080100                      mov.l   #10862h, r1
FFF3EA4F  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3EA55  e0e1                              mov.l   [r14], [r1]
FFF3EA57  fb221883edff                      mov.l   #pathtab_bare, r2
FFF3EA5D  a9a4                              mov.l   18h[r2], r4
FFF3EA5F  fb36ff                            mov.l   #-1, r3
FFF3EA62  6602                              mov.l   #0, r2
FFF3EA64  7f80                              suntil.b
FFF3EA66  6011                              sub     #1, r1
FFF3EA68  ef42                              mov.l   r4, r2
FFF3EA6A  7f87                              smovu
FFF3EA6C  fbe6ff                            mov.l   #-1, r14
FFF3EA6F  660f                              mov.l   #0, r15
FFF3EA71  fb5262080100                      mov.l   #10862h, r5
FFF3EA77  ef51                              mov.l   r5, r1
FFF3EA79  eff2                              mov.l   r15, r2
FFF3EA7B  efe3                              mov.l   r14, r3
FFF3EA7D  7f80                              suntil.b
FFF3EA7F  6011                              sub     #1, r1
FFF3EA81  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3EA87  7f87                              smovu
FFF3EA89  ef51                              mov.l   r5, r1
FFF3EA8B  eff2                              mov.l   r15, r2
FFF3EA8D  efe3                              mov.l   r14, r3
FFF3EA8F  7f80                              suntil.b
FFF3EA91  6011                              sub     #1, r1
FFF3EA93  fb2266200100                      mov.l   #12066h, r2
FFF3EA99  7f87                              smovu
FFF3EA9B  fb36ff                            mov.l   #-1, r3
FFF3EA9E  6602                              mov.l   #0, r2
FFF3EAA0  fb1262080100                      mov.l   #10862h, r1
FFF3EAA6  7f80                              suntil.b
FFF3EAA8  6011                              sub     #1, r1
FFF3EAAA  fb2205b0f4ff                      mov.l   #loc_FFF4B005, r2
FFF3EAB0  7f87                              smovu
FFF3EAB2  fb36ff                            mov.l   #-1, r3
FFF3EAB5  fb2262080100                      mov.l   #10862h, r2
FFF3EABB  fb1266200100                      mov.l   #12066h, r1
FFF3EAC1  7f87                              smovu
FFF3EAC3  a889                              mov.l   10h+var_4[sp], r1
FFF3EAC5  fbe2b7220100                      mov.l   #122B7h, r14
FFF3EACB  c11e20                            mov.b   20h[r1], [r14]
FFF3EACE  fbe2b5220100                      mov.l   #122B5h, r14
FFF3EAD4  f8e405                            mov.b   #5, [r14]
FFF3EAD7  3d0200                            mov.w   #0, 10h+var_C[sp]
FFF3EADA  d5000205               loc_FFF3EADA mov.w   10h+var_C[sp], 10h+var_6[sp]
FFF3EADE  b909                              movu.w  10h+var_6[sp], r1
FFF3EAE0  6704                              rtsd    #4

; ######## sub_FFF3EB8C  FFF3EB8C-FFF3EE00 (file 33EB8C) callers: FFF3C70C(sub_FFF3C4BC)
FFF3EB8C  7ea6                   sub_FFF3EB8C push.l  r6   ; <<<< FUNC sub_FFF3EB8C
FFF3EB8E  7200d4fb                          add     #-42Ch, sp, sp
FFF3EB92  fa05140200                        mov.w   #0, 42Ch+var_4[sp]
FFF3EB97  fa05130200                        mov.w   #0, 42Ch+var_6[sp]
FFF3EB9C  72063404                          add     #42Ch+arg_0, sp, r6
FFF3EBA0  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EBA6  58ee                              movu.b  [r14], r14
FFF3EBA8  610e                              cmp     #0, r14
FFF3EBAA  2011                              beq.b   loc_FFF3EBBB
FFF3EBAC  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EBB2  58ee                              movu.b  [r14], r14
FFF3EBB4  615e                              cmp     #5, r14
FFF3EBB6  15                                beq.s   loc_FFF3EBBB
FFF3EBB7  f80601                            mov.l   #1, 42Ch+var_42C[sp]
FFF3EBBA  0c                                bra.s   loc_FFF3EBBE
FFF3EBBB  f80600                 loc_FFF3EBBB mov.l   #0, 42Ch+var_42C[sp]
FFF3EBBE  ec01                   loc_FFF3EBBE mov.l   42Ch+var_42C[sp], r1
FFF3EBC0  6101                              cmp     #0, r1
FFF3EBC2  2037                              beq.b   loc_FFF3EBF9
FFF3EBC4  5e061402                          movu.w  42Ch+var_4[sp], r6
FFF3EBC8  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EBCE  fbf6a0                            mov.l   #-60h, r15
FFF3EBD1  fe0e6f                            mov.b   r15, [r14, r6]
FFF3EBD4  de061402                          mov.w   42Ch+var_4[sp], r6
FFF3EBD8  6216                              add     #1, r6
FFF3EBDA  db061402                          mov.w   r6, 42Ch+var_4[sp]
FFF3EBDE  5e041402                          movu.w  42Ch+var_4[sp], r4
FFF3EBE2  fb32661f0100                      mov.l   #11F66h, r3
FFF3EBE8  6602                              mov.l   #0, r2
FFF3EBEA  7541ea                            mov.l   #-16h, r1
FFF3EBED  050eebf9                          bsr.a   sub_FFEDD6FB
FFF3EBF1  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3EBF6  38fa01                            bra.w   loc_FFF3EDF0
FFF3EBF9  fbe2b4220100           loc_FFF3EBF9 mov.l   #122B4h, r14
FFF3EBFF  58ee                              movu.b  [r14], r14
FFF3EC01  617e                              cmp     #7, r14
FFF3EC03  2137                              bne.b   loc_FFF3EC3A
FFF3EC05  5e061402                          movu.w  42Ch+var_4[sp], r6
FFF3EC09  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EC0F  fbf6a0                            mov.l   #-60h, r15
FFF3EC12  fe0e6f                            mov.b   r15, [r14, r6]
FFF3EC15  de061402                          mov.w   42Ch+var_4[sp], r6
FFF3EC19  6216                              add     #1, r6
FFF3EC1B  db061402                          mov.w   r6, 42Ch+var_4[sp]
FFF3EC1F  5e041402                          movu.w  42Ch+var_4[sp], r4
FFF3EC23  fb32661f0100                      mov.l   #11F66h, r3
FFF3EC29  6602                              mov.l   #0, r2
FFF3EC2B  7541ea                            mov.l   #-16h, r1
FFF3EC2E  05cdeaf9                          bsr.a   sub_FFEDD6FB
FFF3EC32  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3EC37  38b901                            bra.w   loc_FFF3EDF0
FFF3EC3A  fa090602ffff           loc_FFF3EC3A mov.w   #-1, 42Ch+var_20[sp]
FFF3EC40  fa05100200                        mov.w   #0, 42Ch+var_C[sp]
FFF3EC45  66d3                              mov.l   #0Dh, r3
FFF3EC47  fb220ab0f4ff                      mov.l   #loc_FFF4B00A, r2
FFF3EC4D  fb1262080100                      mov.l   #10862h, r1
FFF3EC53  7f87                              smovu
FFF3EC55  fb1262080100                      mov.l   #10862h, r1
FFF3EC5B  eb010401                          mov.l   r1, 42Ch+var_1C[sp]
FFF3EC5F  fa06050100                        mov.l   #0, 42Ch+var_18[sp]
FFF3EC64  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3EC6A  e4e003                            mov.l   [r14], 42Ch+var_420[sp]
FFF3EC6D  a8e4                              mov.l   8[r6], r4
FFF3EC6F  fb36ff                            mov.l   #-1, r3
FFF3EC72  6602                              mov.l   #0, r2
FFF3EC74  71010c                            add     #42Ch+var_420, sp, r1
FFF3EC77  7f80                              suntil.b
FFF3EC79  6011                              sub     #1, r1
FFF3EC7B  ef42                              mov.l   r4, r2
FFF3EC7D  7f87                              smovu
FFF3EC7F  fbe6ff                            mov.l   #-1, r14
FFF3EC82  660f                              mov.l   #0, r15
FFF3EC84  71050c                            add     #42Ch+var_420, sp, r5
FFF3EC87  ef51                              mov.l   r5, r1
FFF3EC89  eff2                              mov.l   r15, r2
FFF3EC8B  efe3                              mov.l   r14, r3
FFF3EC8D  7f80                              suntil.b
FFF3EC8F  6011                              sub     #1, r1
FFF3EC91  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3EC97  7f87                              smovu
FFF3EC99  a8ec                              mov.l   0Ch[r6], r4
FFF3EC9B  ef51                              mov.l   r5, r1
FFF3EC9D  eff2                              mov.l   r15, r2
FFF3EC9F  efe3                              mov.l   r14, r3
FFF3ECA1  7f80                              suntil.b
FFF3ECA3  6011                              sub     #1, r1
FFF3ECA5  ef42                              mov.l   r4, r2
FFF3ECA7  7f87                              smovu
FFF3ECA9  71010c                            add     #42Ch+var_420, sp, r1
FFF3ECAC  eb010601                          mov.l   r1, 42Ch+var_14[sp]
FFF3ECB0  fb36ff                            mov.l   #-1, r3
FFF3ECB3  6602                              mov.l   #0, r2
FFF3ECB5  71010c                            add     #42Ch+var_420, sp, r1
FFF3ECB8  7f80                              suntil.b
FFF3ECBA  fb16fe                            mov.l   #-2, r1
FFF3ECBD  4331                              sub     r3, r1
FFF3ECBF  eb010701                          mov.l   r1, 42Ch+var_10[sp]
FFF3ECC3  72010c04                          add     #42Ch+var_20, sp, r1
FFF3ECC7  055e3ffd                          bsr.a   sub_FFF12C25
FFF3ECCB  db011302                          mov.w   r1, 42Ch+var_6[sp]
FFF3ECCF  5e011302                          movu.w  42Ch+var_6[sp], r1
FFF3ECD3  6101                              cmp     #0, r1
FFF3ECD5  3bc000                            bne.w   loc_FFF3ED95
FFF3ECD8  a882                              mov.l   42Ch+var_424[sp], r2
FFF3ECDA  6532                              or      #3, r2
FFF3ECDC  fb1262080100                      mov.l   #10862h, r1
FFF3ECE2  053f8bfe                          bsr.a   sub_FFF27821
FFF3ECE6  b869                              movu.w  2[r6], r1
FFF3ECE8  6161                              cmp     #6, r1
FFF3ECEA  205a                              beq.b   loc_FFF3ED44
FFF3ECEC  6151                              cmp     #5, r1
FFF3ECEE  3bed00                            bne.w   loc_FFF3EDDB
FFF3ECF1  7100dc                            add     #-24h, sp, sp
FFF3ECF4  754324                            mov.l   #24h, r3 ; '$'
FFF3ECF7  ef01                              mov.l   sp, r1
FFF3ECF9  ef62                              mov.l   r6, r2
FFF3ECFB  7f8f                              smovf
FFF3ECFD  390301                            bsr.w   sub_FFF3EE00
FFF3ED00  710024                            add     #24h, sp, sp ; '$'
FFF3ED03  db011302                          mov.w   r1, 42Ch+var_6[sp]
FFF3ED07  5e061302                          movu.w  42Ch+var_6[sp], r6
FFF3ED0B  6106                              cmp     #0, r6
FFF3ED0D  3ace00                            beq.w   loc_FFF3EDDB
FFF3ED10  66d3                              mov.l   #0Dh, r3
FFF3ED12  fb220ab0f4ff                      mov.l   #loc_FFF4B00A, r2
FFF3ED18  fb1262080100                      mov.l   #10862h, r1
FFF3ED1E  7f87                              smovu
FFF3ED20  fb1262080100                      mov.l   #10862h, r1
FFF3ED26  055e44fd                          bsr.a   sub_FFF13184
FFF3ED2A  fbe25f080100                      mov.l   #1085Fh, r14
FFF3ED30  f8e400                            mov.b   #0, [r14]
FFF3ED33  fbe2b4220100                      mov.l   #122B4h, r14
FFF3ED39  f8e400                            mov.b   #0, [r14]
FFF3ED3C  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3ED41  38af00                            bra.w   loc_FFF3EDF0
FFF3ED44  7100dc                 loc_FFF3ED44 add     #-24h, sp, sp
FFF3ED47  754324                            mov.l   #24h, r3 ; '$'
FFF3ED4A  ef01                              mov.l   sp, r1
FFF3ED4C  ef62                              mov.l   r6, r2
FFF3ED4E  7f8f                              smovf
FFF3ED50  397a01                            bsr.w   sub_FFF3EECA
FFF3ED53  710024                            add     #24h, sp, sp ; '$'
FFF3ED56  db011302                          mov.w   r1, 42Ch+var_6[sp]
FFF3ED5A  5e011302                          movu.w  42Ch+var_6[sp], r1
FFF3ED5E  6101                              cmp     #0, r1
FFF3ED60  207b                              beq.b   loc_FFF3EDDB
FFF3ED62  66d3                              mov.l   #0Dh, r3
FFF3ED64  fb220ab0f4ff                      mov.l   #loc_FFF4B00A, r2
FFF3ED6A  fb1262080100                      mov.l   #10862h, r1
FFF3ED70  7f87                              smovu
FFF3ED72  fb1262080100                      mov.l   #10862h, r1
FFF3ED78  050c44fd                          bsr.a   sub_FFF13184
FFF3ED7C  fbe25f080100                      mov.l   #1085Fh, r14
FFF3ED82  f8e400                            mov.b   #0, [r14]
FFF3ED85  fbe2b4220100                      mov.l   #122B4h, r14
FFF3ED8B  f8e400                            mov.b   #0, [r14]
FFF3ED8E  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3ED93  2e5d                              bra.b   loc_FFF3EDF0
FFF3ED95  5e011402               loc_FFF3ED95 movu.w  42Ch+var_4[sp], r1
FFF3ED99  fbe2661f0100                      mov.l   #11F66h, r14
FFF3ED9F  fbf6a0                            mov.l   #-60h, r15
FFF3EDA2  fe0e1f                            mov.b   r15, [r14, r1]
FFF3EDA5  de011402                          mov.w   42Ch+var_4[sp], r1
FFF3EDA9  6211                              add     #1, r1
FFF3EDAB  db011402                          mov.w   r1, 42Ch+var_4[sp]
FFF3EDAF  5e041402                          movu.w  42Ch+var_4[sp], r4
FFF3EDB3  fb32661f0100                      mov.l   #11F66h, r3
FFF3EDB9  6602                              mov.l   #0, r2
FFF3EDBB  7541ea                            mov.l   #-16h, r1
FFF3EDBE  053de9f9                          bsr.a   sub_FFEDD6FB
FFF3EDC2  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EDC8  f8e400                            mov.b   #0, [r14]
FFF3EDCB  fbe2b4220100                      mov.l   #122B4h, r14
FFF3EDD1  f8e400                            mov.b   #0, [r14]
FFF3EDD4  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3EDD9  2e17                              bra.b   loc_FFF3EDF0
FFF3EDDB  fbe2b6220100           loc_FFF3EDDB mov.l   #122B6h, r14
FFF3EDE1  f8e403                            mov.b   #3, [r14]
FFF3EDE4  754264                            mov.l   #64h, r2 ; 'd'
FFF3EDE7  6641                              mov.l   #4, r1
FFF3EDE9  05efb0ff                          bsr.a   sub_FFF39ED8
FFF3EDED  3d0300                            mov.w   #0, 42Ch+var_426[sp]
FFF3EDF0  d900031502             loc_FFF3EDF0 mov.w   42Ch+var_426[sp], 42Ch+var_2[sp]
FFF3EDF5  5e011502                          movu.w  42Ch+var_2[sp], r1
FFF3EDF9  72002c04                          add     #42Ch, sp, sp
FFF3EDFD  7eb6                              pop     r6
FFF3EDFF  02                                rts

; ######## sub_FFF3EE00  FFF3EE00-FFF3EECA (file 33EE00) callers: FFF3ECFD(sub_FFF3EB8C)
FFF3EE00  6080                   sub_FFF3EE00 sub     #8, sp   ; <<<< FUNC sub_FFF3EE00
FFF3EE02  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3EE05  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3EE08  71040c                            add     #8+arg_0, sp, r4
FFF3EE0B  fb1262080100                      mov.l   #10862h, r1
FFF3EE11  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3EE17  e0e1                              mov.l   [r14], [r1]
FFF3EE19  a8c5                              mov.l   8[r4], r5
FFF3EE1B  fb36ff                            mov.l   #-1, r3
FFF3EE1E  6602                              mov.l   #0, r2
FFF3EE20  7f80                              suntil.b
FFF3EE22  6011                              sub     #1, r1
FFF3EE24  ef52                              mov.l   r5, r2
FFF3EE26  7f87                              smovu
FFF3EE28  fbe6ff                            mov.l   #-1, r14
FFF3EE2B  660f                              mov.l   #0, r15
FFF3EE2D  fb5262080100                      mov.l   #10862h, r5
FFF3EE33  ef51                              mov.l   r5, r1
FFF3EE35  eff2                              mov.l   r15, r2
FFF3EE37  efe3                              mov.l   r14, r3
FFF3EE39  7f80                              suntil.b
FFF3EE3B  6011                              sub     #1, r1
FFF3EE3D  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3EE43  7f87                              smovu
FFF3EE45  a8cc                              mov.l   0Ch[r4], r4
FFF3EE47  ef51                              mov.l   r5, r1
FFF3EE49  eff2                              mov.l   r15, r2
FFF3EE4B  efe3                              mov.l   r14, r3
FFF3EE4D  7f80                              suntil.b
FFF3EE4F  6011                              sub     #1, r1
FFF3EE51  ef42                              mov.l   r4, r2
FFF3EE53  7f87                              smovu
FFF3EE55  fb22a5f8f3ff                      mov.l   #sub_FFF3F8A5, r2
FFF3EE5B  fb1262080100                      mov.l   #10862h, r1
FFF3EE61  054a5bfd                          bsr.a   sub_FFF149AB
FFF3EE65  9081                              mov.w   r1, 8+var_4[sp]
FFF3EE67  b881                              movu.w  8+var_4[sp], r1
FFF3EE69  6101                              cmp     #0, r1
FFF3EE6B  b809                              movu.w  8+var_6[sp], r1
FFF3EE6D  2028                              beq.b   loc_FFF3EE95
FFF3EE6F  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EE75  fbf6a0                            mov.l   #-60h, r15
FFF3EE78  fe01ef                            mov.b   r15, [r1, r14]
FFF3EE7B  9809                              mov.w   8+var_6[sp], r1
FFF3EE7D  6211                              add     #1, r1
FFF3EE7F  9009                              mov.w   r1, 8+var_6[sp]
FFF3EE81  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EE87  f8e400                            mov.b   #0, [r14]
FFF3EE8A  fbe2b4220100                      mov.l   #122B4h, r14
FFF3EE90  f8e400                            mov.b   #0, [r14]
FFF3EE93  2e1c                              bra.b   loc_FFF3EEAF
FFF3EE95  fbe2661f0100           loc_FFF3EE95 mov.l   #11F66h, r14
FFF3EE9B  660f                              mov.l   #0, r15
FFF3EE9D  fe01ef                            mov.b   r15, [r1, r14]
FFF3EEA0  9809                              mov.w   8+var_6[sp], r1
FFF3EEA2  6211                              add     #1, r1
FFF3EEA4  9009                              mov.w   r1, 8+var_6[sp]
FFF3EEA6  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EEAC  f8e40d                            mov.b   #0Dh, [r14]
FFF3EEAF  b80c                   loc_FFF3EEAF movu.w  8+var_6[sp], r4
FFF3EEB1  fb32661f0100                      mov.l   #11F66h, r3
FFF3EEB7  6602                              mov.l   #0, r2
FFF3EEB9  7541ea                            mov.l   #-16h, r1
FFF3EEBC  053fe8f9                          bsr.a   sub_FFEDD6FB
FFF3EEC0  d5000203                          mov.w   8+var_4[sp], 8+var_2[sp]
FFF3EEC4  9889                              mov.w   8+var_2[sp], r1
FFF3EEC6  5f11                              movu.w  r1, r1
FFF3EEC8  6702                              rtsd    #2

; ######## sub_FFF3EECA  FFF3EECA-FFF3EF94 (file 33EECA) callers: FFF3ED50(sub_FFF3EB8C)
FFF3EECA  6080                   sub_FFF3EECA sub     #8, sp   ; <<<< FUNC sub_FFF3EECA
FFF3EECC  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3EECF  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3EED2  71040c                            add     #8+arg_0, sp, r4
FFF3EED5  fb1262080100                      mov.l   #10862h, r1
FFF3EEDB  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3EEE1  e0e1                              mov.l   [r14], [r1]
FFF3EEE3  a8c5                              mov.l   8[r4], r5
FFF3EEE5  fb36ff                            mov.l   #-1, r3
FFF3EEE8  6602                              mov.l   #0, r2
FFF3EEEA  7f80                              suntil.b
FFF3EEEC  6011                              sub     #1, r1
FFF3EEEE  ef52                              mov.l   r5, r2
FFF3EEF0  7f87                              smovu
FFF3EEF2  fbe6ff                            mov.l   #-1, r14
FFF3EEF5  660f                              mov.l   #0, r15
FFF3EEF7  fb5262080100                      mov.l   #10862h, r5
FFF3EEFD  ef51                              mov.l   r5, r1
FFF3EEFF  eff2                              mov.l   r15, r2
FFF3EF01  efe3                              mov.l   r14, r3
FFF3EF03  7f80                              suntil.b
FFF3EF05  6011                              sub     #1, r1
FFF3EF07  fb2203b0f4ff                      mov.l   #loc_FFF4B003, r2
FFF3EF0D  7f87                              smovu
FFF3EF0F  a8cc                              mov.l   0Ch[r4], r4
FFF3EF11  ef51                              mov.l   r5, r1
FFF3EF13  eff2                              mov.l   r15, r2
FFF3EF15  efe3                              mov.l   r14, r3
FFF3EF17  7f80                              suntil.b
FFF3EF19  6011                              sub     #1, r1
FFF3EF1B  ef42                              mov.l   r4, r2
FFF3EF1D  7f87                              smovu
FFF3EF1F  fb22a5f8f3ff                      mov.l   #sub_FFF3F8A5, r2
FFF3EF25  fb1262080100                      mov.l   #10862h, r1
FFF3EF2B  05cf5cfd                          bsr.a   sub_FFF14BFA
FFF3EF2F  9081                              mov.w   r1, 8+var_4[sp]
FFF3EF31  b881                              movu.w  8+var_4[sp], r1
FFF3EF33  6101                              cmp     #0, r1
FFF3EF35  b809                              movu.w  8+var_6[sp], r1
FFF3EF37  2028                              beq.b   loc_FFF3EF5F
FFF3EF39  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EF3F  fbf6a0                            mov.l   #-60h, r15
FFF3EF42  fe01ef                            mov.b   r15, [r1, r14]
FFF3EF45  9809                              mov.w   8+var_6[sp], r1
FFF3EF47  6211                              add     #1, r1
FFF3EF49  9009                              mov.w   r1, 8+var_6[sp]
FFF3EF4B  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EF51  f8e400                            mov.b   #0, [r14]
FFF3EF54  fbe2b4220100                      mov.l   #122B4h, r14
FFF3EF5A  f8e400                            mov.b   #0, [r14]
FFF3EF5D  2e1c                              bra.b   loc_FFF3EF79
FFF3EF5F  fbe2661f0100           loc_FFF3EF5F mov.l   #11F66h, r14
FFF3EF65  660f                              mov.l   #0, r15
FFF3EF67  fe01ef                            mov.b   r15, [r1, r14]
FFF3EF6A  9809                              mov.w   8+var_6[sp], r1
FFF3EF6C  6211                              add     #1, r1
FFF3EF6E  9009                              mov.w   r1, 8+var_6[sp]
FFF3EF70  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EF76  f8e40d                            mov.b   #0Dh, [r14]
FFF3EF79  b80c                   loc_FFF3EF79 movu.w  8+var_6[sp], r4
FFF3EF7B  fb32661f0100                      mov.l   #11F66h, r3
FFF3EF81  6602                              mov.l   #0, r2
FFF3EF83  7541ea                            mov.l   #-16h, r1
FFF3EF86  0575e7f9                          bsr.a   sub_FFEDD6FB
FFF3EF8A  d5000203                          mov.w   8+var_4[sp], 8+var_2[sp]
FFF3EF8E  9889                              mov.w   8+var_2[sp], r1
FFF3EF90  5f11                              movu.w  r1, r1
FFF3EF92  6702                              rtsd    #2

; ######## sub_FFF3BB0C  FFF3BB0C-FFF3BC97 (file 33BB0C) callers: FFF3C68E(sub_FFF3C4BC)
FFF3BB0C  7100e4                 sub_FFF3BB0C add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF3BB0C
FFF3BB0F  3d0d00                            mov.w   #0, 1Ch+var_2[sp]
FFF3BB12  3d0c00                            mov.w   #0, 1Ch+var_4[sp]
FFF3BB15  3c8701                            mov.b   #1, 1Ch+var_5[sp]
FFF3BB18  6601                              mov.l   #0, r1
FFF3BB1A  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF3BB1C  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF3BB1E  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF3BB20  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF3BB22  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF3BB24  fb1258250100                      mov.l   #12558h, r1
FFF3BB2A  6602                              mov.l   #0, r2
FFF3BB2C  9212                              mov.w   r2, 10h[r1]
FFF3BB2E  a09a                              mov.l   r2, 0Ch[r1]
FFF3BB30  a092                              mov.l   r2, 8[r1]
FFF3BB32  a01a                              mov.l   r2, 4[r1]
FFF3BB34  e312                              mov.l   r2, [r1]
FFF3BB36  ef01                              mov.l   sp, r1
FFF3BB38  05e06ffd                          bsr.a   sub_FFF12B18
FFF3BB3C  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF3BB3E  bb09                              movu.w  1Ch+var_2[sp], r1
FFF3BB40  6101                              cmp     #0, r1
FFF3BB42  3bd300                            bne.w   loc_FFF3BC15
FFF3BB45  fbe26c250100                      mov.l   #1256Ch, r14
FFF3BB4B  d00e                              mov.w   1Ch+var_1C[sp], [r14]
FFF3BB4D  38c800                            bra.w   loc_FFF3BC15
FFF3BB50  fb1262080100           loc_FFF3BB50 mov.l   #10862h, r1
FFF3BB56  fbe2f3aff4ff                      mov.l   #(loc_FFF4AFF1+2), r14
FFF3BB5C  e0e1                              mov.l   [r14], [r1]
FFF3BB5E  fbe21883edff                      mov.l   #pathtab_bare, r14
FFF3BB64  bb02                              movu.w  1Ch+var_4[sp], r2
FFF3BB66  fe62ee                            mov.l   [r2, r14], r14
FFF3BB69  fb36ff                            mov.l   #-1, r3
FFF3BB6C  6602                              mov.l   #0, r2
FFF3BB6E  7f80                              suntil.b
FFF3BB70  6011                              sub     #1, r1
FFF3BB72  efe2                              mov.l   r14, r2
FFF3BB74  7f87                              smovu
FFF3BB76  fb1262080100                      mov.l   #10862h, r1
FFF3BB7C  057d70fd                          bsr.a   sub_FFF12BF9
FFF3BB80  8589                              mov.b   r1, 1Ch+var_5[sp]
FFF3BB82  b589                              movu.b  1Ch+var_5[sp], r1
FFF3BB84  6111                              cmp     #1, r1
FFF3BB86  3a8900                            beq.w   loc_FFF3BC0F
FFF3BB89  fb1262080100                      mov.l   #10862h, r1
FFF3BB8F  051e70fd                          bsr.a   sub_FFF12BAD
FFF3BB93  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF3BB95  bb09                              movu.w  1Ch+var_2[sp], r1
FFF3BB97  6101                              cmp     #0, r1
FFF3BB99  2076                              beq.b   loc_FFF3BC0F
FFF3BB9B  754312                            mov.l   #12h, r3
FFF3BB9E  fb2234250100                      mov.l   #12534h, r2
FFF3BBA4  fb1258250100                      mov.l   #12558h, r1
FFF3BBAA  7f8f                              smovf
FFF3BBAC  fb1258250100                      mov.l   #12558h, r1
FFF3BBB2  3d1090                            mov.w   #-70h, [r1]
FFF3BBB5  fb1258250100                      mov.l   #12558h, r1
FFF3BBBB  3d1101                            mov.w   #1, 2[r1]
FFF3BBBE  fbe258250100                      mov.l   #12558h, r14
FFF3BBC4  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3BBC9  fbe258250100                      mov.l   #12558h, r14
FFF3BBCF  fbf26c250100                      mov.l   #1256Ch, r15
FFF3BBD5  d4fe02                            mov.w   [r15], 4[r14]
FFF3BBD8  fb12d0830600                      mov.l   #683D0h, r1
FFF3BBDE  3d1c00                            mov.w   #0, 18h[r1]
FFF3BBE1  7100c8                            add     #-38h, sp, sp
FFF3BBE4  754312                            mov.l   #12h, r3
FFF3BBE7  fb2258250100                      mov.l   #12558h, r2
FFF3BBED  ef01                              mov.l   sp, r1
FFF3BBEF  7f8f                              smovf
FFF3BBF1  ef01                              mov.l   sp, r1
FFF3BBF3  711114                            add     #14h, r1, r1
FFF3BBF6  754324                            mov.l   #24h, r3 ; '$'
FFF3BBF9  fb22d0830600                      mov.l   #683D0h, r2
FFF3BBFF  7f8f                              smovf
FFF3BC01  6602                              mov.l   #0, r2
FFF3BC03  7541fe                            mov.l   #-2, r1
FFF3BC06  05d61cfa                          bsr.a   sub_FFEDD8DC
FFF3BC0A  710038                            add     #38h, sp, sp ; '8'
FFF3BC0D  6707                              rtsd    #7
FFF3BC0F  9b01                   loc_FFF3BC0F mov.w   1Ch+var_4[sp], r1
FFF3BC11  6211                              add     #1, r1
FFF3BC13  9301                              mov.w   r1, 1Ch+var_4[sp]
FFF3BC15  fbe21883edff           loc_FFF3BC15 mov.l   #pathtab_bare, r14
FFF3BC1B  bb01                              movu.w  1Ch+var_4[sp], r1
FFF3BC1D  fe61ee                            mov.l   [r1, r14], r14
FFF3BC20  610e                              cmp     #0, r14
FFF3BC22  3b2eff                            bne.w   loc_FFF3BB50
FFF3BC25  754312                            mov.l   #12h, r3
FFF3BC28  fb2234250100                      mov.l   #12534h, r2
FFF3BC2E  fb1258250100                      mov.l   #12558h, r1
FFF3BC34  7f8f                              smovf
FFF3BC36  fb1258250100                      mov.l   #12558h, r1
FFF3BC3C  3d1090                            mov.w   #-70h, [r1]
FFF3BC3F  fb1258250100                      mov.l   #12558h, r1
FFF3BC45  3d1101                            mov.w   #1, 2[r1]
FFF3BC48  fb1258250100                      mov.l   #12558h, r1
FFF3BC4E  3d1300                            mov.w   #0, 6[r1]
FFF3BC51  fbe258250100                      mov.l   #12558h, r14
FFF3BC57  fbf26c250100                      mov.l   #1256Ch, r15
FFF3BC5D  d4fe02                            mov.w   [r15], 4[r14]
FFF3BC60  fb12d0830600                      mov.l   #683D0h, r1
FFF3BC66  3d1c00                            mov.w   #0, 18h[r1]
FFF3BC69  7100c8                            add     #-38h, sp, sp
FFF3BC6C  754312                            mov.l   #12h, r3
FFF3BC6F  fb2258250100                      mov.l   #12558h, r2
FFF3BC75  ef01                              mov.l   sp, r1
FFF3BC77  7f8f                              smovf
FFF3BC79  ef01                              mov.l   sp, r1
FFF3BC7B  711114                            add     #14h, r1, r1
FFF3BC7E  754324                            mov.l   #24h, r3 ; '$'
FFF3BC81  fb22d0830600                      mov.l   #683D0h, r2
FFF3BC87  7f8f                              smovf
FFF3BC89  6602                              mov.l   #0, r2
FFF3BC8B  7541fe                            mov.l   #-2, r1
FFF3BC8E  054e1cfa                          bsr.a   sub_FFEDD8DC
FFF3BC92  710038                            add     #38h, sp, sp
FFF3BC95  6707                              rtsd    #7

; ######## sub_FFF3BA24  FFF3BA24-FFF3BA5A (file 33BA24) callers: FFF3FE06(sub_FFF3FC53)
FFF3BA24  7100f0                 sub_FFF3BA24 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3BA24
FFF3BA27  f80400                            mov.b   #0, 10h+var_10[sp]
FFF3BA2A  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF3BA2D  3e0200                            mov.l   #0, 10h+var_8[sp]
FFF3BA30  fb12f7aff4ff                      mov.l   #loc_FFF4AFF7, r1
FFF3BA36  054e77fd                          bsr.a   sub_FFF13184
FFF3BA3A  ef03                              mov.l   sp, r3
FFF3BA3C  6642                              mov.l   #4, r2
FFF3BA3E  754149                            mov.l   #49h, r1 ; 'I'
FFF3BA41  0585a0fe                          bsr.a   sub_FFF25AC6
FFF3BA45  a089                              mov.l   r1, 10h+var_4[sp]
FFF3BA47  a889                              mov.l   10h+var_4[sp], r1
FFF3BA49  6101                              cmp     #0, r1
FFF3BA4B  210d                              bne.b   loc_FFF3BA58
FFF3BA4D  fbe2b2220100                      mov.l   #122B2h, r14
FFF3BA53  f8e401                            mov.b   #1, [r14]
FFF3BA56  6704                              rtsd    #4
FFF3BA58  6704                   loc_FFF3BA58 rtsd    #4

; ######## sub_FFF13DDA  FFF13DDA-FFF13FAE (file 313DDA) callers: 
FFF13DDA  7200e0fe               sub_FFF13DDA add     #-120h, sp, sp   ; <<<< FUNC sub_FFF13DDA
FFF13DDE  f9058e00                          mov.w   #0, 120h+var_4[sp]
FFF13DE2  f9058d00                          mov.w   #0, 120h+var_6[sp]
FFF13DE6  3c8400                            mov.b   #0, 120h+var_10C[sp]
FFF13DE9  3e0200                            mov.l   #0, 120h+var_118[sp]
FFF13DEC  3e0100                            mov.l   #0, 120h+var_11C[sp]
FFF13DEF  fbe278020200                      mov.l   #20278h, r14
FFF13DF5  ede143                            mov.l   10Ch[r14], r1
FFF13DF8  6081                              sub     #8, r1
FFF13DFA  fb22b4030500                      mov.l   #503B4h, r2
FFF13E00  a029                              mov.l   r1, 4[r2]
FFF13E02  fbe278020200                      mov.l   #20278h, r14
FFF13E08  ede143                            mov.l   10Ch[r14], r1
FFF13E0B  7111d4                            add     #-2Ch, r1, r1
FFF13E0E  fb22b4030500                      mov.l   #503B4h, r2
FFF13E14  a2a1                              mov.l   r1, 28h[r2]
FFF13E16  fbe278020200                      mov.l   #20278h, r14
FFF13E1C  eee14dc0                          mov.l   30134h[r14], r1
FFF13E20  6602                              mov.l   #0, r2
FFF13E22  ef23                              mov.l   r2, r3
FFF13E24  052b5500                          bsr.a   sub_FFF1934F
FFF13E28  a809                              mov.l   120h+var_11C[sp], r1
FFF13E2A  7501ff                            cmp     #-1, r1
FFF13E2D  fbe278020200                      mov.l   #20278h, r14
FFF13E33  eee44dc0                          mov.l   30134h[r14], r4
FFF13E37  2110                              bne.b   loc_FFF13E47
FFF13E39  ef41                              mov.l   r4, r1
FFF13E3B  05df2f00                          bsr.a   sub_FFF16E1A
FFF13E3F  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF13E44  386101                            bra.w   loc_FFF13FA5
FFF13E47  75432c                 loc_FFF13E47 mov.l   #2Ch, r3 ; ','
FFF13E4A  6612                              mov.l   #1, r2
FFF13E4C  fb12b4030500                      mov.l   #503B4h, r1
FFF13E52  05be4600                          bsr.a   sub_FFF18510
FFF13E56  a081                              mov.l   r1, 120h+var_118[sp]
FFF13E58  a881                              mov.l   120h+var_118[sp], r1
FFF13E5A  75512c                            cmp     #2Ch, r1 ; ','
FFF13E5D  fbe278020200                      mov.l   #20278h, r14
FFF13E63  eee14dc0                          mov.l   30134h[r14], r1
FFF13E67  200e                              beq.b   loc_FFF13E75
FFF13E69  05b12f00                          bsr.a   sub_FFF16E1A
FFF13E6D  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF13E72  383301                            bra.w   loc_FFF13FA5
FFF13E75  05a52f00               loc_FFF13E75 bsr.a   sub_FFF16E1A
FFF13E79  3c842e                            mov.b   #2Eh, 120h+var_10C[sp] ; '.'
FFF13E7C  b502                              movu.b  120h+var_10C[sp], r2
FFF13E7E  fb1278020200                      mov.l   #20278h, r1
FFF13E84  6261                              add     #6, r1
FFF13E86  05d41603                          bsr.a   sub_FFF4555A
FFF13E8A  a101                              mov.l   r1, 120h+var_110[sp]
FFF13E8C  fbe6ff                            mov.l   #-1, r14
FFF13E8F  6602                              mov.l   #0, r2
FFF13E91  a901                              mov.l   120h+var_110[sp], r1
FFF13E93  efe3                              mov.l   r14, r3
FFF13E95  7f80                              suntil.b
FFF13E97  fb46fe                            mov.l   #-2, r4
FFF13E9A  ff0f34                            sub     r3, r4, r15
FFF13E9D  fb1278020200                      mov.l   #20278h, r1
FFF13EA3  6261                              add     #6, r1
FFF13EA5  efe3                              mov.l   r14, r3
FFF13EA7  7f80                              suntil.b
FFF13EA9  4334                              sub     r3, r4
FFF13EAB  43f4                              sub     r15, r4
FFF13EAD  d7048e                            mov.w   r4, 120h+var_4[sp]
FFF13EB0  fb3a0001                          mov.l   #100h, r3
FFF13EB4  6602                              mov.l   #0, r2
FFF13EB6  71011a                            add     #120h+var_106, sp, r1
FFF13EB9  7f88                              sstr.b
FFF13EBB  fb2278020200                      mov.l   #20278h, r2
FFF13EC1  6262                              add     #6, r2
FFF13EC3  5d048e                            movu.w  120h+var_4[sp], r4
FFF13EC6  710e1a                            add     #120h+var_106, sp, r14
FFF13EC9  efe1                              mov.l   r14, r1
FFF13ECB  ef43                              mov.l   r4, r3
FFF13ECD  7f87                              smovu
FFF13ECF  4b4e                              add     r4, r14
FFF13ED1  efe1                              mov.l   r14, r1
FFF13ED3  4331                              sub     r3, r1
FFF13ED5  6602                              mov.l   #0, r2
FFF13ED7  7f88                              sstr.b
FFF13ED9  fbe278020200                      mov.l   #20278h, r14
FFF13EDF  73ee380103                        add     #30138h, r14, r14
FFF13EE4  5ce1                              movu.w  [r14], r1
FFF13EE6  6191                              cmp     #9, r1
FFF13EE8  2a19                              bgt.b   loc_FFF13F01
FFF13EEA  6080                              sub     #8, sp
FFF13EEC  fbe2b5adf4ff                      mov.l   #unk_FFF4ADB5, r14
FFF13EF2  e30e                              mov.l   r14, 128h+var_128[sp]
FFF13EF4  a009                              mov.l   r1, 128h+var_124[sp]
FFF13EF6  71011d                            add     #128h+var_10B, sp, r1
FFF13EF9  052b1603                          bsr.a   sub_FFF45524
FFF13EFD  6280                              add     #8, sp
FFF13EFF  2e17                              bra.b   loc_FFF13F16
FFF13F01  6080                   loc_FFF13F01 sub     #8, sp
FFF13F03  fbe2b9adf4ff                      mov.l   #loc_FFF4ADB9, r14
FFF13F09  e30e                              mov.l   r14, 128h+var_128[sp]
FFF13F0B  a009                              mov.l   r1, 128h+var_124[sp]
FFF13F0D  71011d                            add     #128h+var_10B, sp, r1
FFF13F10  05141603                          bsr.a   sub_FFF45524
FFF13F14  6280                              add     #8, sp
FFF13F16  fb36ff                 loc_FFF13F16 mov.l   #-1, r3
FFF13F19  6602                              mov.l   #0, r2
FFF13F1B  71011a                            add     #120h+var_106, sp, r1
FFF13F1E  7f80                              suntil.b
FFF13F20  6011                              sub     #1, r1
FFF13F22  710215                            add     #120h+var_10B, sp, r2
FFF13F25  7f87                              smovu
FFF13F27  fb36ff                            mov.l   #-1, r3
FFF13F2A  6602                              mov.l   #0, r2
FFF13F2C  71011a                            add     #120h+var_106, sp, r1
FFF13F2F  7f80                              suntil.b
FFF13F31  6011                              sub     #1, r1
FFF13F33  fb22bcadf4ff                      mov.l   #sub_FFF4ADBC, r2
FFF13F39  7f87                              smovu
FFF13F3B  fb22acadf4ff                      mov.l   #(loc_FFF4ADAA+2), r2
FFF13F41  71011a                            add     #120h+var_106, sp, r1
FFF13F44  05042000                          bsr.a   sub_FFF15F48
FFF13F48  a089                              mov.l   r1, 120h+var_114[sp]
FFF13F4A  a88c                              mov.l   120h+var_114[sp], r4
FFF13F4C  6104                              cmp     #0, r4
FFF13F4E  210f                              bne.b   loc_FFF13F5D
FFF13F50  ef41                              mov.l   r4, r1
FFF13F52  05c82e00                          bsr.a   sub_FFF16E1A
FFF13F56  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF13F5B  2e4a                              bra.b   loc_FFF13FA5
FFF13F5D  75432c                 loc_FFF13F5D mov.l   #2Ch, r3 ; ','
FFF13F60  6612                              mov.l   #1, r2
FFF13F62  fb12b4030500                      mov.l   #503B4h, r1
FFF13F68  05a84500                          bsr.a   sub_FFF18510
FFF13F6C  a081                              mov.l   r1, 120h+var_118[sp]
FFF13F6E  a881                              mov.l   120h+var_118[sp], r1
FFF13F70  75512c                            cmp     #2Ch, r1 ; ','
FFF13F73  200f                              beq.b   loc_FFF13F82
FFF13F75  a889                              mov.l   120h+var_114[sp], r1
FFF13F77  05a32e00                          bsr.a   sub_FFF16E1A
FFF13F7B  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF13F80  2e25                              bra.b   loc_FFF13FA5
FFF13F82  fbe278020200           loc_FFF13F82 mov.l   #20278h, r14
FFF13F88  f9e6432c                          mov.l   #2Ch, 10Ch[r14] ; ','
FFF13F8C  fbe278020200                      mov.l   #20278h, r14
FFF13F92  f9e64200                          mov.l   #0, 108h[r14]
FFF13F96  fbe278020200                      mov.l   #20278h, r14
FFF13F9C  e90e034dc0                        mov.l   120h+var_114[sp], 30134h[r14]
FFF13FA1  d5008d01                          mov.w   120h+var_6[sp], 120h+var_11E[sp]
FFF13FA5  d500018f               loc_FFF13FA5 mov.w   120h+var_11E[sp], 120h+var_2[sp]
FFF13FA9  5d018f                            movu.w  120h+var_2[sp], r1
FFF13FAC  6748                              rtsd    #48h

; ######## sub_FFF14194  FFF14194-FFF1427F (file 314194) callers: FFF36C5D(sub_FFF36C53)
FFF14194  6080                   sub_FFF14194 sub     #8, sp   ; <<<< FUNC sub_FFF14194
FFF14196  3d0200                            mov.w   #0, 8+var_4[sp]
FFF14199  fbe297220100                      mov.l   #12297h, r14
FFF1419F  58ee                              movu.b  [r14], r14
FFF141A1  611e                              cmp     #1, r14
FFF141A3  19                                bne.s   loc_FFF141AC
FFF141A4  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF141A9  38ce00                            bra.w   loc_FFF14277
FFF141AC  fbe20a250100           loc_FFF141AC mov.l   #1250Ah, r14
FFF141B2  f8e500                            mov.w   #0, [r14]
FFF141B5  fb120a250100                      mov.l   #1250Ah, r1
FFF141BB  3d1100                            mov.w   #0, 2[r1]
FFF141BE  fb120a250100                      mov.l   #1250Ah, r1
FFF141C4  3d1200                            mov.w   #0, 4[r1]
FFF141C7  fbe278020200                      mov.l   #20278h, r14
FFF141CD  f8e500                            mov.w   #0, [r14]
FFF141D0  fb1278020200                      mov.l   #20278h, r1
FFF141D6  3d1205                            mov.w   #5, 4[r1]
FFF141D9  fbe2b4030500                      mov.l   #503B4h, r14
FFF141DF  f8e252494646                      mov.l   #46464952h, [r14]
FFF141E5  fb12b4030500                      mov.l   #503B4h, r1
FFF141EB  3e1100                            mov.l   #0, 4[r1]
FFF141EE  fbe2b4030500                      mov.l   #503B4h, r14
FFF141F4  f9e20257415645                    mov.l   #45564157h, 8[r14]
FFF141FB  fbe2b4030500                      mov.l   #503B4h, r14
FFF14201  f9e203666d7420                    mov.l   #20746D66h, 0Ch[r14]
FFF14208  fb12b4030500                      mov.l   #503B4h, r1
FFF1420E  3e1410                            mov.l   #10h, 10h[r1]
FFF14211  fb12b4030500                      mov.l   #503B4h, r1
FFF14217  3d1a01                            mov.w   #1, 14h[r1]
FFF1421A  fb12b4030500                      mov.l   #503B4h, r1
FFF14220  3d1b01                            mov.w   #1, 16h[r1]
FFF14223  fbe2b4030500                      mov.l   #503B4h, r14
FFF14229  f9ea06803e                        mov.l   #3E80h, 18h[r14]
FFF1422E  fbe2b4030500                      mov.l   #503B4h, r14
FFF14234  f9ea07007d                        mov.l   #7D00h, 1Ch[r14]
FFF14239  fb12b4030500                      mov.l   #503B4h, r1
FFF1423F  3d9002                            mov.w   #2, 20h[r1]
FFF14242  fb12b4030500                      mov.l   #503B4h, r1
FFF14248  3d9110                            mov.w   #10h, 22h[r1]
FFF1424B  fbe2b4030500                      mov.l   #503B4h, r14
FFF14251  f9e20964617461                    mov.l   #61746164h, 24h[r14]
FFF14258  fb12b4030500                      mov.l   #503B4h, r1
FFF1425E  3e1a00                            mov.l   #0, 28h[r1]
FFF14261  39070f                            bsr.w   sub_FFF15168
FFF14264  39f10d                            bsr.w   sub_FFF15055
FFF14267  39e113                            bsr.w   sub_FFF15648
FFF1426A  fbe297220100                      mov.l   #12297h, r14
FFF14270  f8e401                            mov.b   #1, [r14]
FFF14273  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]
FFF14277  d5000103               loc_FFF14277 mov.w   8+var_6[sp], 8+var_2[sp]
FFF1427B  b889                              movu.w  8+var_2[sp], r1
FFF1427D  6702                              rtsd    #2

; ######## sub_FFF140C7  FFF140C7-FFF14194 (file 3140C7) callers: FFF13207(sub_FFF131AA)
FFF140C7  7200f0fe               sub_FFF140C7 add     #-110h, sp, sp   ; <<<< FUNC sub_FFF140C7
FFF140CB  e70143                            mov.l   r1, 110h+var_4[sp]
FFF140CE  f9058500                          mov.w   #0, 110h+var_6[sp]
FFF140D2  f9058400                          mov.w   #0, 110h+var_8[sp]
FFF140D6  3c075c                            mov.b   #5Ch, 110h+var_109[sp] ; '\'
FFF140D9  b18a                              movu.b  110h+var_109[sp], r2
FFF140DB  ed0143                            mov.l   110h+var_4[sp], r1
FFF140DE  057c1403                          bsr.a   sub_FFF4555A
FFF140E2  e301                              mov.l   r1, 110h+var_110[sp]
FFF140E4  660e                              mov.l   #0, r14
FFF140E6  ec04                              mov.l   110h+var_110[sp], r4
FFF140E8  fb36ff                            mov.l   #-1, r3
FFF140EB  ef41                              mov.l   r4, r1
FFF140ED  efe2                              mov.l   r14, r2
FFF140EF  7f80                              suntil.b
FFF140F1  fbf6fe                            mov.l   #-2, r15
FFF140F4  433f                              sub     r3, r15
FFF140F6  ef42                              mov.l   r4, r2
FFF140F8  6212                              add     #1, r2
FFF140FA  710508                            add     #110h+var_108, sp, r5
FFF140FD  ef51                              mov.l   r5, r1
FFF140FF  eff3                              mov.l   r15, r3
FFF14101  7f87                              smovu
FFF14103  4bf5                              add     r15, r5
FFF14105  ef51                              mov.l   r5, r1
FFF14107  4331                              sub     r3, r1
FFF14109  efe2                              mov.l   r14, r2
FFF1410B  7f88                              sstr.b
FFF1410D  fb1224ee0100                      mov.l   #1EE24h, r1
FFF14113  72111c01                          add     #11Ch, r1, r1
FFF14117  fb36ff                            mov.l   #-1, r3
FFF1411A  710208                            add     #110h+var_108, sp, r2
FFF1411D  7f87                              smovu
FFF1411F  fbe6ff                            mov.l   #-1, r14
FFF14122  6602                              mov.l   #0, r2
FFF14124  ed0143                            mov.l   110h+var_4[sp], r1
FFF14127  efe3                              mov.l   r14, r3
FFF14129  7f80                              suntil.b
FFF1412B  fbf6fe                            mov.l   #-2, r15
FFF1412E  ff043f                            sub     r3, r15, r4
FFF14131  ec01                              mov.l   110h+var_110[sp], r1
FFF14133  efe3                              mov.l   r14, r3
FFF14135  7f80                              suntil.b
FFF14137  433f                              sub     r3, r15
FFF14139  43f4                              sub     r15, r4
FFF1413B  d70485                            mov.w   r4, 110h+var_6[sp]
FFF1413E  f9058400                          mov.w   #0, 110h+var_8[sp]
FFF14142  2e19                              bra.b   loc_FFF1415B
FFF14144  5d0284                 loc_FFF14144 movu.w  110h+var_8[sp], r2
FFF14147  ed0343                            mov.l   110h+var_4[sp], r3
FFF1414A  fec32e                            movu.b  [r3, r2], r14
FFF1414D  710f08                            add     #110h+var_108, sp, r15
FFF14150  fe01fe                            mov.b   r14, [r1, r15]
FFF14153  dd0184                            mov.w   110h+var_8[sp], r1
FFF14156  6211                              add     #1, r1
FFF14158  d70184                            mov.w   r1, 110h+var_8[sp]
FFF1415B  5d0184                 loc_FFF1415B movu.w  110h+var_8[sp], r1
FFF1415E  06c50185                          cmp     110h+var_6[sp].uw, r1
FFF14162  29e2                              blt.b   loc_FFF14144
FFF14164  710e08                            add     #110h+var_108, sp, r14
FFF14167  660f                              mov.l   #0, r15
FFF14169  fe01ef                            mov.b   r15, [r1, r14]
FFF1416C  fb36ff                            mov.l   #-1, r3
FFF1416F  6602                              mov.l   #0, r2
FFF14171  710108                            add     #110h+var_108, sp, r1
FFF14174  7f80                              suntil.b
FFF14176  6011                              sub     #1, r1
FFF14178  fb22c1adf4ff                      mov.l   #loc_FFF4ADC1, r2
FFF1417E  7f87                              smovu
FFF14180  fb1224ee0100                      mov.l   #1EE24h, r1
FFF14186  72111c02                          add     #21Ch, r1, r1
FFF1418A  fb36ff                            mov.l   #-1, r3
FFF1418D  710208                            add     #110h+var_108, sp, r2
FFF14190  7f87                              smovu
FFF14192  6744                              rtsd    #44h

; ######## sub_FFF12C25  FFF12C25-FFF12D95 (file 312C25) callers: FFF3C811(sub_FFF3C765), FFF3C81E(sub_FFF3C765), FFF3C82B(sub_FFF3C765), FFF3CA56(sub_FFF3C911), FFF3ECC7(sub_FFF3EB8C), FFF3FC1F(sub_FFF3FAF7)
FFF12C25  7100e8                 sub_FFF12C25 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12C25
FFF12C28  a109                              mov.l   r1, 18h+var_4[sp]
FFF12C2A  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF12C2D  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12C30  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF12C33  a909                              mov.l   18h+var_4[sp], r1
FFF12C35  5c1e                              movu.w  [r1], r14
FFF12C37  770effff00                        cmp     #0FFFFh, r14
FFF12C3C  11                                beq.s   loc_FFF12C45
FFF12C3D  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12C42  384b01                            bra.w   loc_FFF12D8D
FFF12C45  a909                   loc_FFF12C45 mov.l   18h+var_4[sp], r1
FFF12C47  ba91                              movu.w  14h[r1], r1
FFF12C49  6121                              cmp     #2, r1
FFF12C4B  3a9b00                            beq.w   loc_FFF12CE6
FFF12C4E  6111                              cmp     #1, r1
FFF12C50  204f                              beq.b   loc_FFF12C9F
FFF12C52  6101                              cmp     #0, r1
FFF12C54  3bfc00                            bne.w   loc_FFF12D50
FFF12C57  a909                              mov.l   18h+var_4[sp], r1
FFF12C59  a819                              mov.l   4[r1], r1
FFF12C5B  fb22acadf4ff                      mov.l   #(loc_FFF4ADAA+2), r2
FFF12C61  05e73200                          bsr.a   sub_FFF15F48
FFF12C65  a089                              mov.l   r1, 18h+var_C[sp]
FFF12C67  a889                              mov.l   18h+var_C[sp], r1
FFF12C69  6101                              cmp     #0, r1
FFF12C6B  3be500                            bne.w   loc_FFF12D50
FFF12C6E  a909                              mov.l   18h+var_4[sp], r1
FFF12C70  a819                              mov.l   4[r1], r1
FFF12C72  a88a                              mov.l   18h+var_C[sp], r2
FFF12C74  39a10e                            bsr.w   sub_FFF13B15
FFF12C77  a909                              mov.l   18h+var_4[sp], r1
FFF12C79  a819                              mov.l   4[r1], r1
FFF12C7B  fb22acadf4ff                      mov.l   #(loc_FFF4ADAA+2), r2
FFF12C81  05c73200                          bsr.a   sub_FFF15F48
FFF12C85  a089                              mov.l   r1, 18h+var_C[sp]
FFF12C87  a889                              mov.l   18h+var_C[sp], r1
FFF12C89  6101                              cmp     #0, r1
FFF12C8B  3bc500                            bne.w   loc_FFF12D50
FFF12C8E  a909                              mov.l   18h+var_4[sp], r1
FFF12C90  a819                              mov.l   4[r1], r1
FFF12C92  a88a                              mov.l   18h+var_C[sp], r2
FFF12C94  39810e                            bsr.w   sub_FFF13B15
FFF12C97  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12C9C  38f100                            bra.w   loc_FFF12D8D
FFF12C9F  a909                   loc_FFF12C9F mov.l   18h+var_4[sp], r1
FFF12CA1  a819                              mov.l   4[r1], r1
FFF12CA3  fb22aeadf4ff                      mov.l   #loc_FFF4ADAE, r2
FFF12CA9  059f3200                          bsr.a   sub_FFF15F48
FFF12CAD  a089                              mov.l   r1, 18h+var_C[sp]
FFF12CAF  a889                              mov.l   18h+var_C[sp], r1
FFF12CB1  6101                              cmp     #0, r1
FFF12CB3  3b9d00                            bne.w   loc_FFF12D50
FFF12CB6  a909                              mov.l   18h+var_4[sp], r1
FFF12CB8  a819                              mov.l   4[r1], r1
FFF12CBA  a88a                              mov.l   18h+var_C[sp], r2
FFF12CBC  39590e                            bsr.w   sub_FFF13B15
FFF12CBF  a909                              mov.l   18h+var_4[sp], r1
FFF12CC1  a819                              mov.l   4[r1], r1
FFF12CC3  fb22aeadf4ff                      mov.l   #loc_FFF4ADAE, r2
FFF12CC9  057f3200                          bsr.a   sub_FFF15F48
FFF12CCD  a089                              mov.l   r1, 18h+var_C[sp]
FFF12CCF  a889                              mov.l   18h+var_C[sp], r1
FFF12CD1  6101                              cmp     #0, r1
FFF12CD3  217d                              bne.b   loc_FFF12D50
FFF12CD5  a909                              mov.l   18h+var_4[sp], r1
FFF12CD7  a819                              mov.l   4[r1], r1
FFF12CD9  a88a                              mov.l   18h+var_C[sp], r2
FFF12CDB  393a0e                            bsr.w   sub_FFF13B15
FFF12CDE  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12CE3  38aa00                            bra.w   loc_FFF12D8D
FFF12CE6  a909                   loc_FFF12CE6 mov.l   18h+var_4[sp], r1
FFF12CE8  a819                              mov.l   4[r1], r1
FFF12CEA  fb22b0adf4ff                      mov.l   #loc_FFF4ADB0, r2
FFF12CF0  05583200                          bsr.a   sub_FFF15F48
FFF12CF4  a089                              mov.l   r1, 18h+var_C[sp]
FFF12CF6  a889                              mov.l   18h+var_C[sp], r1
FFF12CF8  6101                              cmp     #0, r1
FFF12CFA  2131                              bne.b   loc_FFF12D2B
FFF12CFC  a909                              mov.l   18h+var_4[sp], r1
FFF12CFE  a819                              mov.l   4[r1], r1
FFF12D00  a88a                              mov.l   18h+var_C[sp], r2
FFF12D02  39130e                            bsr.w   sub_FFF13B15
FFF12D05  a909                              mov.l   18h+var_4[sp], r1
FFF12D07  a819                              mov.l   4[r1], r1
FFF12D09  fb22b0adf4ff                      mov.l   #loc_FFF4ADB0, r2
FFF12D0F  05393200                          bsr.a   sub_FFF15F48
FFF12D13  a089                              mov.l   r1, 18h+var_C[sp]
FFF12D15  a889                              mov.l   18h+var_C[sp], r1
FFF12D17  6101                              cmp     #0, r1
FFF12D19  2112                              bne.b   loc_FFF12D2B
FFF12D1B  a909                              mov.l   18h+var_4[sp], r1
FFF12D1D  a819                              mov.l   4[r1], r1
FFF12D1F  a88a                              mov.l   18h+var_C[sp], r2
FFF12D21  39f40d                            bsr.w   sub_FFF13B15
FFF12D24  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12D29  2e64                              bra.b   loc_FFF12D8D
FFF12D2B  a909                   loc_FFF12D2B mov.l   18h+var_4[sp], r1
FFF12D2D  a892                              mov.l   8[r1], r2
FFF12D2F  a889                              mov.l   18h+var_C[sp], r1
FFF12D31  6603                              mov.l   #0, r3
FFF12D33  051c6600                          bsr.a   sub_FFF1934F
FFF12D37  a009                              mov.l   r1, 18h+var_14[sp]
FFF12D39  a809                              mov.l   18h+var_14[sp], r1
FFF12D3B  7501ff                            cmp     #-1, r1
FFF12D3E  2112                              bne.b   loc_FFF12D50
FFF12D40  a909                              mov.l   18h+var_4[sp], r1
FFF12D42  a819                              mov.l   4[r1], r1
FFF12D44  a88a                              mov.l   18h+var_C[sp], r2
FFF12D46  39cf0d                            bsr.w   sub_FFF13B15
FFF12D49  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12D4E  2e3f                              bra.b   loc_FFF12D8D
FFF12D50  a909                   loc_FFF12D50 mov.l   18h+var_4[sp], r1
FFF12D52  a913                              mov.l   10h[r1], r3
FFF12D54  a899                              mov.l   0Ch[r1], r1
FFF12D56  a88c                              mov.l   18h+var_C[sp], r4
FFF12D58  6612                              mov.l   #1, r2
FFF12D5A  05b65700                          bsr.a   sub_FFF18510
FFF12D5E  a081                              mov.l   r1, 18h+var_10[sp]
FFF12D60  a909                              mov.l   18h+var_4[sp], r1
FFF12D62  a882                              mov.l   18h+var_10[sp], r2
FFF12D64  06851204                          cmp     10h[r1].l, r2
FFF12D68  2012                              beq.b   loc_FFF12D7A
FFF12D6A  a909                              mov.l   18h+var_4[sp], r1
FFF12D6C  a819                              mov.l   4[r1], r1
FFF12D6E  a88a                              mov.l   18h+var_C[sp], r2
FFF12D70  39a50d                            bsr.w   sub_FFF13B15
FFF12D73  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12D78  2e15                              bra.b   loc_FFF12D8D
FFF12D7A  a889                   loc_FFF12D7A mov.l   18h+var_C[sp], r1
FFF12D7C  05ac4400                          bsr.a   sub_FFF17228
FFF12D80  a909                              mov.l   18h+var_4[sp], r1
FFF12D82  a819                              mov.l   4[r1], r1
FFF12D84  a88a                              mov.l   18h+var_C[sp], r2
FFF12D86  398f0d                            bsr.w   sub_FFF13B15
FFF12D89  d5000801                          mov.w   18h+var_8[sp], 18h+var_16[sp]
FFF12D8D  d5000109               loc_FFF12D8D mov.w   18h+var_16[sp], 18h+var_6[sp]
FFF12D91  ba09                              movu.w  18h+var_6[sp], r1
FFF12D93  6706                              rtsd    #6

; ######## sub_FFF12D95  FFF12D95-FFF12E8B (file 312D95) callers: FFF3C838(sub_FFF3C765)
FFF12D95  7100ec                 sub_FFF12D95 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF12D95
FFF12D98  a101                              mov.l   r1, 14h+var_4[sp]
FFF12D9A  3d0600                            mov.w   #0, 14h+var_8[sp]
FFF12D9D  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF12DA0  a901                              mov.l   14h+var_4[sp], r1
FFF12DA2  5c1e                              movu.w  [r1], r14
FFF12DA4  770effff00                        cmp     #0FFFFh, r14
FFF12DA9  11                                beq.s   loc_FFF12DB2
FFF12DAA  f90903ffff                        mov.w   #-1, 14h+var_E[sp]
FFF12DAF  38d400                            bra.w   loc_FFF12E83
FFF12DB2  a901                   loc_FFF12DB2 mov.l   14h+var_4[sp], r1
FFF12DB4  ba91                              movu.w  14h[r1], r1
FFF12DB6  6151                              cmp     #5, r1
FFF12DB8  216b                              bne.b   loc_FFF12E23
FFF12DBA  a901                              mov.l   14h+var_4[sp], r1
FFF12DBC  a819                              mov.l   4[r1], r1
FFF12DBE  fb22acadf4ff                      mov.l   #(loc_FFF4ADAA+2), r2
FFF12DC4  05843100                          bsr.a   sub_FFF15F48
FFF12DC8  fbe274f20100                      mov.l   #1F274h, r14
FFF12DCE  e3e1                              mov.l   r1, [r14]
FFF12DD0  fbe274f20100                      mov.l   #1F274h, r14
FFF12DD6  ecee                              mov.l   [r14], r14
FFF12DD8  610e                              cmp     #0, r14
FFF12DDA  2149                              bne.b   loc_FFF12E23
FFF12DDC  fbe274f20100                      mov.l   #1F274h, r14
FFF12DE2  ece2                              mov.l   [r14], r2
FFF12DE4  a901                              mov.l   14h+var_4[sp], r1
FFF12DE6  a819                              mov.l   4[r1], r1
FFF12DE8  392d0d                            bsr.w   sub_FFF13B15
FFF12DEB  a901                              mov.l   14h+var_4[sp], r1
FFF12DED  a819                              mov.l   4[r1], r1
FFF12DEF  fb22acadf4ff                      mov.l   #(loc_FFF4ADAA+2), r2
FFF12DF5  05533100                          bsr.a   sub_FFF15F48
FFF12DF9  fbe274f20100                      mov.l   #1F274h, r14
FFF12DFF  e3e1                              mov.l   r1, [r14]
FFF12E01  fbe274f20100                      mov.l   #1F274h, r14
FFF12E07  ecee                              mov.l   [r14], r14
FFF12E09  610e                              cmp     #0, r14
FFF12E0B  2118                              bne.b   loc_FFF12E23
FFF12E0D  fbe274f20100                      mov.l   #1F274h, r14
FFF12E13  ece2                              mov.l   [r14], r2
FFF12E15  a901                              mov.l   14h+var_4[sp], r1
FFF12E17  a819                              mov.l   4[r1], r1
FFF12E19  39fc0c                            bsr.w   sub_FFF13B15
FFF12E1C  f90903ffff                        mov.w   #-1, 14h+var_E[sp]
FFF12E21  2e62                              bra.b   loc_FFF12E83
FFF12E23  fbe274f20100           loc_FFF12E23 mov.l   #1F274h, r14
FFF12E29  ece4                              mov.l   [r14], r4
FFF12E2B  a901                              mov.l   14h+var_4[sp], r1
FFF12E2D  a913                              mov.l   10h[r1], r3
FFF12E2F  a899                              mov.l   0Ch[r1], r1
FFF12E31  6612                              mov.l   #1, r2
FFF12E33  05dd5600                          bsr.a   sub_FFF18510
FFF12E37  a081                              mov.l   r1, 14h+var_C[sp]
FFF12E39  a901                              mov.l   14h+var_4[sp], r1
FFF12E3B  a882                              mov.l   14h+var_C[sp], r2
FFF12E3D  06851204                          cmp     10h[r1].l, r2
FFF12E41  2016                              beq.b   loc_FFF12E57
FFF12E43  fbe274f20100                      mov.l   #1F274h, r14
FFF12E49  ece2                              mov.l   [r14], r2
FFF12E4B  a819                              mov.l   4[r1], r1
FFF12E4D  39c80c                            bsr.w   sub_FFF13B15
FFF12E50  f90903ffff                        mov.w   #-1, 14h+var_E[sp]
FFF12E55  2e2e                              bra.b   loc_FFF12E83
FFF12E57  ba91                   loc_FFF12E57 movu.w  14h[r1], r1
FFF12E59  6181                              cmp     #8, r1
FFF12E5B  10                                beq.s   loc_FFF12E63
FFF12E5C  a901                              mov.l   14h+var_4[sp], r1
FFF12E5E  ba91                              movu.w  14h[r1], r1
FFF12E60  6191                              cmp     #9, r1
FFF12E62  1d                                bne.s   loc_FFF12E67
FFF12E63  f80601                 loc_FFF12E63 mov.l   #1, 14h+var_14[sp]
FFF12E66  0c                                bra.s   loc_FFF12E6A
FFF12E67  f80600                 loc_FFF12E67 mov.l   #0, 14h+var_14[sp]
FFF12E6A  ec01                   loc_FFF12E6A mov.l   14h+var_14[sp], r1
FFF12E6C  6101                              cmp     #0, r1
FFF12E6E  2011                              beq.b   loc_FFF12E7F
FFF12E70  fbe274f20100                      mov.l   #1F274h, r14
FFF12E76  ece2                              mov.l   [r14], r2
FFF12E78  a901                              mov.l   14h+var_4[sp], r1
FFF12E7A  a819                              mov.l   4[r1], r1
FFF12E7C  39990c                            bsr.w   sub_FFF13B15
FFF12E7F  d5000603               loc_FFF12E7F mov.w   14h+var_8[sp], 14h+var_E[sp]
FFF12E83  d5000307               loc_FFF12E83 mov.w   14h+var_E[sp], 14h+var_6[sp]
FFF12E87  b989                              movu.w  14h+var_6[sp], r1
FFF12E89  6705                              rtsd    #5

; ######## sub_FFF12E8B  FFF12E8B-FFF12F9B (file 312E8B) callers: FFF3CEC1(sub_FFF3CE12), FFF3CED0(sub_FFF3CE12), FFF3FA4F(sub_FFF3F9E6)
FFF12E8B  7100e8                 sub_FFF12E8B add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12E8B
FFF12E8E  a109                              mov.l   r1, 18h+var_4[sp]
FFF12E90  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF12E93  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12E96  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF12E99  a909                              mov.l   18h+var_4[sp], r1
FFF12E9B  5c1e                              movu.w  [r1], r14
FFF12E9D  610e                              cmp     #0, r14
FFF12E9F  11                                beq.s   loc_FFF12EA8
FFF12EA0  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12EA5  38ee00                            bra.w   loc_FFF12F93
FFF12EA8  a909                   loc_FFF12EA8 mov.l   18h+var_4[sp], r1
FFF12EAA  ba91                              movu.w  14h[r1], r1
FFF12EAC  6111                              cmp     #1, r1
FFF12EAE  204e                              beq.b   loc_FFF12EFC
FFF12EB0  6101                              cmp     #0, r1
FFF12EB2  3bb400                            bne.w   loc_FFF12F66
FFF12EB5  a909                              mov.l   18h+var_4[sp], r1
FFF12EB7  a819                              mov.l   4[r1], r1
FFF12EB9  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12EBF  05893000                          bsr.a   sub_FFF15F48
FFF12EC3  a089                              mov.l   r1, 18h+var_C[sp]
FFF12EC5  a889                              mov.l   18h+var_C[sp], r1
FFF12EC7  6101                              cmp     #0, r1
FFF12EC9  3b9d00                            bne.w   loc_FFF12F66
FFF12ECC  a909                              mov.l   18h+var_4[sp], r1
FFF12ECE  a819                              mov.l   4[r1], r1
FFF12ED0  a88a                              mov.l   18h+var_C[sp], r2
FFF12ED2  39430c                            bsr.w   sub_FFF13B15
FFF12ED5  a909                              mov.l   18h+var_4[sp], r1
FFF12ED7  a819                              mov.l   4[r1], r1
FFF12ED9  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12EDF  05693000                          bsr.a   sub_FFF15F48
FFF12EE3  a089                              mov.l   r1, 18h+var_C[sp]
FFF12EE5  a889                              mov.l   18h+var_C[sp], r1
FFF12EE7  6101                              cmp     #0, r1
FFF12EE9  217d                              bne.b   loc_FFF12F66
FFF12EEB  a909                              mov.l   18h+var_4[sp], r1
FFF12EED  a819                              mov.l   4[r1], r1
FFF12EEF  a88a                              mov.l   18h+var_C[sp], r2
FFF12EF1  39240c                            bsr.w   sub_FFF13B15
FFF12EF4  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12EF9  389a00                            bra.w   loc_FFF12F93
FFF12EFC  a909                   loc_FFF12EFC mov.l   18h+var_4[sp], r1
FFF12EFE  a819                              mov.l   4[r1], r1
FFF12F00  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12F06  05423000                          bsr.a   sub_FFF15F48
FFF12F0A  a089                              mov.l   r1, 18h+var_C[sp]
FFF12F0C  a889                              mov.l   18h+var_C[sp], r1
FFF12F0E  6101                              cmp     #0, r1
FFF12F10  2131                              bne.b   loc_FFF12F41
FFF12F12  a909                              mov.l   18h+var_4[sp], r1
FFF12F14  a819                              mov.l   4[r1], r1
FFF12F16  a88a                              mov.l   18h+var_C[sp], r2
FFF12F18  39fd0b                            bsr.w   sub_FFF13B15
FFF12F1B  a909                              mov.l   18h+var_4[sp], r1
FFF12F1D  a819                              mov.l   4[r1], r1
FFF12F1F  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12F25  05233000                          bsr.a   sub_FFF15F48
FFF12F29  a089                              mov.l   r1, 18h+var_C[sp]
FFF12F2B  a889                              mov.l   18h+var_C[sp], r1
FFF12F2D  6101                              cmp     #0, r1
FFF12F2F  2112                              bne.b   loc_FFF12F41
FFF12F31  a909                              mov.l   18h+var_4[sp], r1
FFF12F33  a819                              mov.l   4[r1], r1
FFF12F35  a88a                              mov.l   18h+var_C[sp], r2
FFF12F37  39de0b                            bsr.w   sub_FFF13B15
FFF12F3A  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F3F  2e54                              bra.b   loc_FFF12F93
FFF12F41  a909                   loc_FFF12F41 mov.l   18h+var_4[sp], r1
FFF12F43  a892                              mov.l   8[r1], r2
FFF12F45  a889                              mov.l   18h+var_C[sp], r1
FFF12F47  6603                              mov.l   #0, r3
FFF12F49  05066400                          bsr.a   sub_FFF1934F
FFF12F4D  a009                              mov.l   r1, 18h+var_14[sp]
FFF12F4F  a809                              mov.l   18h+var_14[sp], r1
FFF12F51  7501ff                            cmp     #-1, r1
FFF12F54  2112                              bne.b   loc_FFF12F66
FFF12F56  a909                              mov.l   18h+var_4[sp], r1
FFF12F58  a819                              mov.l   4[r1], r1
FFF12F5A  a88a                              mov.l   18h+var_C[sp], r2
FFF12F5C  39b90b                            bsr.w   sub_FFF13B15
FFF12F5F  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F64  2e2f                              bra.b   loc_FFF12F93
FFF12F66  a909                   loc_FFF12F66 mov.l   18h+var_4[sp], r1
FFF12F68  a913                              mov.l   10h[r1], r3
FFF12F6A  a899                              mov.l   0Ch[r1], r1
FFF12F6C  a88c                              mov.l   18h+var_C[sp], r4
FFF12F6E  6612                              mov.l   #1, r2
FFF12F70  053f4f00                          bsr.a   sub_FFF17EAF
FFF12F74  a081                              mov.l   r1, 18h+var_10[sp]
FFF12F76  a909                              mov.l   18h+var_4[sp], r1
FFF12F78  a882                              mov.l   18h+var_10[sp], r2
FFF12F7A  06851204                          cmp     10h[r1].l, r2
FFF12F7E  a819                              mov.l   4[r1], r1
FFF12F80  a88a                              mov.l   18h+var_C[sp], r2
FFF12F82  12                                beq.s   loc_FFF12F8C
FFF12F83  39920b                            bsr.w   sub_FFF13B15
FFF12F86  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F8B  08                                bra.s   loc_FFF12F93
FFF12F8C  39890b                 loc_FFF12F8C bsr.w   sub_FFF13B15
FFF12F8F  d5000801                          mov.w   18h+var_8[sp], 18h+var_16[sp]
FFF12F93  d5000109               loc_FFF12F93 mov.w   18h+var_16[sp], 18h+var_6[sp]
FFF12F97  ba09                              movu.w  18h+var_6[sp], r1
FFF12F99  6706                              rtsd    #6

; ######## sub_FFF12F9B  FFF12F9B-FFF130F3 (file 312F9B) callers: FFF3CBDA(sub_FFF3CAD0), FFF3CEF9(sub_FFF3CE12)
FFF12F9B  7100e8                 sub_FFF12F9B add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12F9B
FFF12F9E  a109                              mov.l   r1, 18h+var_4[sp]
FFF12FA0  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF12FA3  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF12FA6  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12FA9  a909                              mov.l   18h+var_4[sp], r1
FFF12FAB  5c1e                              movu.w  [r1], r14
FFF12FAD  610e                              cmp     #0, r14
FFF12FAF  11                                beq.s   loc_FFF12FB8
FFF12FB0  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF12FB5  383601                            bra.w   loc_FFF130EB
FFF12FB8  a909                   loc_FFF12FB8 mov.l   18h+var_4[sp], r1
FFF12FBA  ba91                              movu.w  14h[r1], r1
FFF12FBC  61d1                              cmp     #0Dh, r1
FFF12FBE  11                                beq.s   loc_FFF12FC7
FFF12FBF  a909                              mov.l   18h+var_4[sp], r1
FFF12FC1  ba91                              movu.w  14h[r1], r1
FFF12FC3  755110                            cmp     #10h, r1
FFF12FC6  1d                                bne.s   loc_FFF12FCB
FFF12FC7  f80601                 loc_FFF12FC7 mov.l   #1, 18h+var_18[sp]
FFF12FCA  0c                                bra.s   loc_FFF12FCE
FFF12FCB  f80600                 loc_FFF12FCB mov.l   #0, 18h+var_18[sp]
FFF12FCE  ec01                   loc_FFF12FCE mov.l   18h+var_18[sp], r1
FFF12FD0  6101                              cmp     #0, r1
FFF12FD2  206c                              beq.b   loc_FFF1303E
FFF12FD4  a909                              mov.l   18h+var_4[sp], r1
FFF12FD6  a819                              mov.l   4[r1], r1
FFF12FD8  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12FDE  056a2f00                          bsr.a   sub_FFF15F48
FFF12FE2  fbe274f20100                      mov.l   #1F274h, r14
FFF12FE8  e3e1                              mov.l   r1, [r14]
FFF12FEA  fbe274f20100                      mov.l   #1F274h, r14
FFF12FF0  ecee                              mov.l   [r14], r14
FFF12FF2  610e                              cmp     #0, r14
FFF12FF4  214a                              bne.b   loc_FFF1303E
FFF12FF6  fbe274f20100                      mov.l   #1F274h, r14
FFF12FFC  ece2                              mov.l   [r14], r2
FFF12FFE  a909                              mov.l   18h+var_4[sp], r1
FFF13000  a819                              mov.l   4[r1], r1
FFF13002  39130b                            bsr.w   sub_FFF13B15
FFF13005  a909                              mov.l   18h+var_4[sp], r1
FFF13007  a819                              mov.l   4[r1], r1
FFF13009  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF1300F  05392f00                          bsr.a   sub_FFF15F48
FFF13013  fbe274f20100                      mov.l   #1F274h, r14
FFF13019  e3e1                              mov.l   r1, [r14]
FFF1301B  fbe274f20100                      mov.l   #1F274h, r14
FFF13021  ecee                              mov.l   [r14], r14
FFF13023  610e                              cmp     #0, r14
FFF13025  2119                              bne.b   loc_FFF1303E
FFF13027  fbe274f20100                      mov.l   #1F274h, r14
FFF1302D  ece2                              mov.l   [r14], r2
FFF1302F  a909                              mov.l   18h+var_4[sp], r1
FFF13031  a819                              mov.l   4[r1], r1
FFF13033  39e20a                            bsr.w   sub_FFF13B15
FFF13036  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF1303B  38b000                            bra.w   loc_FFF130EB
FFF1303E  a909                   loc_FFF1303E mov.l   18h+var_4[sp], r1
FFF13040  ba91                              movu.w  14h[r1], r1
FFF13042  61e1                              cmp     #0Eh, r1
FFF13044  11                                beq.s   loc_FFF1304D
FFF13045  a909                              mov.l   18h+var_4[sp], r1
FFF13047  ba91                              movu.w  14h[r1], r1
FFF13049  755110                            cmp     #10h, r1
FFF1304C  1d                                bne.s   loc_FFF13051
FFF1304D  f80601                 loc_FFF1304D mov.l   #1, 18h+var_18[sp]
FFF13050  0c                                bra.s   loc_FFF13054
FFF13051  f80600                 loc_FFF13051 mov.l   #0, 18h+var_18[sp]
FFF13054  ec01                   loc_FFF13054 mov.l   18h+var_18[sp], r1
FFF13056  6101                              cmp     #0, r1
FFF13058  18                                bne.s   loc_FFF13060
FFF13059  a909                              mov.l   18h+var_4[sp], r1
FFF1305B  ba91                              movu.w  14h[r1], r1
FFF1305D  61f1                              cmp     #0Fh, r1
FFF1305F  1d                                bne.s   loc_FFF13064
FFF13060  f80601                 loc_FFF13060 mov.l   #1, 18h+var_18[sp]
FFF13063  0c                                bra.s   loc_FFF13067
FFF13064  f80600                 loc_FFF13064 mov.l   #0, 18h+var_18[sp]
FFF13067  ec01                   loc_FFF13067 mov.l   18h+var_18[sp], r1
FFF13069  6101                              cmp     #0, r1
FFF1306B  2033                              beq.b   loc_FFF1309E
FFF1306D  a909                              mov.l   18h+var_4[sp], r1
FFF1306F  a892                              mov.l   8[r1], r2
FFF13071  fbe274f20100                      mov.l   #1F274h, r14
FFF13077  ece1                              mov.l   [r14], r1
FFF13079  6603                              mov.l   #0, r3
FFF1307B  05d46200                          bsr.a   sub_FFF1934F
FFF1307F  a081                              mov.l   r1, 18h+var_10[sp]
FFF13081  a881                              mov.l   18h+var_10[sp], r1
FFF13083  7501ff                            cmp     #-1, r1
FFF13086  2118                              bne.b   loc_FFF1309E
FFF13088  fbe274f20100                      mov.l   #1F274h, r14
FFF1308E  ece2                              mov.l   [r14], r2
FFF13090  a909                              mov.l   18h+var_4[sp], r1
FFF13092  a819                              mov.l   4[r1], r1
FFF13094  39810a                            bsr.w   sub_FFF13B15
FFF13097  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF1309C  2e4f                              bra.b   loc_FFF130EB
FFF1309E  fbe274f20100           loc_FFF1309E mov.l   #1F274h, r14
FFF130A4  ece4                              mov.l   [r14], r4
FFF130A6  a909                              mov.l   18h+var_4[sp], r1
FFF130A8  a913                              mov.l   10h[r1], r3
FFF130AA  a899                              mov.l   0Ch[r1], r1
FFF130AC  6612                              mov.l   #1, r2
FFF130AE  05014e00                          bsr.a   sub_FFF17EAF
FFF130B2  a089                              mov.l   r1, 18h+var_C[sp]
FFF130B4  a909                              mov.l   18h+var_4[sp], r1
FFF130B6  a88a                              mov.l   18h+var_C[sp], r2
FFF130B8  06851204                          cmp     10h[r1].l, r2
FFF130BC  2016                              beq.b   loc_FFF130D2
FFF130BE  fbe274f20100                      mov.l   #1F274h, r14
FFF130C4  ece2                              mov.l   [r14], r2
FFF130C6  a819                              mov.l   4[r1], r1
FFF130C8  394d0a                            bsr.w   sub_FFF13B15
FFF130CB  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF130D0  2e1b                              bra.b   loc_FFF130EB
FFF130D2  ba91                   loc_FFF130D2 movu.w  14h[r1], r1
FFF130D4  61f1                              cmp     #0Fh, r1
FFF130D6  2111                              bne.b   loc_FFF130E7
FFF130D8  fbe274f20100                      mov.l   #1F274h, r14
FFF130DE  ece2                              mov.l   [r14], r2
FFF130E0  a909                              mov.l   18h+var_4[sp], r1
FFF130E2  a819                              mov.l   4[r1], r1
FFF130E4  39310a                            bsr.w   sub_FFF13B15
FFF130E7  d5000803               loc_FFF130E7 mov.w   18h+var_8[sp], 18h+var_12[sp]
FFF130EB  d5000309               loc_FFF130EB mov.w   18h+var_12[sp], 18h+var_6[sp]
FFF130EF  ba09                              movu.w  18h+var_6[sp], r1
FFF130F1  6706                              rtsd    #6

; ######## sub_FFF130F3  FFF130F3-FFF13159 (file 3130F3) callers: FFF131D1(sub_FFF131AA), FFF13A18(sub_FFF13A00), FFF14C4D(sub_FFF14BFA), FFF14E5D(sub_FFF14E1F), FFF3CB75(sub_FFF3CAD0), FFF3D05A(sub_FFF3CFD8), FFF3FA24(sub_FFF3F9E6), FFF3FB1A(sub_FFF3FAF7)
FFF130F3  7100e8                 sub_FFF130F3 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF130F3
FFF130F6  a109                              mov.l   r1, 18h+var_4[sp]
FFF130F8  a102                              mov.l   r2, 18h+var_8[sp]
FFF130FA  3d0600                            mov.w   #0, 18h+var_C[sp]
FFF130FD  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF13100  3c0300                            mov.b   #0, 18h+var_15[sp]
FFF13103  a909                              mov.l   18h+var_4[sp], r1
FFF13105  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF1310B  053d2e00                          bsr.a   sub_FFF15F48
FFF1310F  a009                              mov.l   r1, 18h+var_14[sp]
FFF13111  a809                              mov.l   18h+var_14[sp], r1
FFF13113  6101                              cmp     #0, r1
FFF13115  210f                              bne.b   loc_FFF13124
FFF13117  a80a                              mov.l   18h+var_14[sp], r2
FFF13119  a909                              mov.l   18h+var_4[sp], r1
FFF1311B  39fa09                            bsr.w   sub_FFF13B15
FFF1311E  f809ffff                          mov.w   #-1, 18h+var_18[sp]
FFF13122  2e30                              bra.b   loc_FFF13152
FFF13124  a809                   loc_FFF13124 mov.l   18h+var_14[sp], r1
FFF13126  710208                            add     #18h+var_10, sp, r2
FFF13129  05a65a01                          bsr.a   sub_FFF28BCF
FFF1312D  8089                              mov.b   r1, 18h+var_15[sp]
FFF1312F  8889                              mov.b   18h+var_15[sp], r1
FFF13131  6101                              cmp     #0, r1
FFF13133  200f                              beq.b   loc_FFF13142
FFF13135  a80a                              mov.l   18h+var_14[sp], r2
FFF13137  a909                              mov.l   18h+var_4[sp], r1
FFF13139  39dc09                            bsr.w   sub_FFF13B15
FFF1313C  f809ffff                          mov.w   #-1, 18h+var_18[sp]
FFF13140  2e12                              bra.b   loc_FFF13152
FFF13142  a881                   loc_FFF13142 mov.l   18h+var_10[sp], r1
FFF13144  a902                              mov.l   18h+var_8[sp], r2
FFF13146  e321                              mov.l   r1, [r2]
FFF13148  a80a                              mov.l   18h+var_14[sp], r2
FFF1314A  a909                              mov.l   18h+var_4[sp], r1
FFF1314C  39c909                            bsr.w   sub_FFF13B15
FFF1314F  d10006                            mov.w   18h+var_C[sp], 18h+var_18[sp]
FFF13152  d40007                 loc_FFF13152 mov.w   18h+var_18[sp], 18h+var_A[sp]
FFF13155  b989                              movu.w  18h+var_A[sp], r1
FFF13157  6706                              rtsd    #6

; ######## sub_FFF131AA  FFF131AA-FFF132A7 (file 3131AA) callers: FFF3D7CA(sub_FFF3D680), FFF3DA8C(sub_FFF3D887)
FFF131AA  7100e0                 sub_FFF131AA add     #-20h, sp, sp   ; <<<< FUNC sub_FFF131AA
FFF131AD  a189                              mov.l   r1, 20h+var_4[sp]
FFF131AF  a182                              mov.l   r2, 20h+var_8[sp]
FFF131B1  a10b                              mov.l   r3, 20h+var_C[sp]
FFF131B3  3d0800                            mov.w   #0, 20h+var_10[sp]
FFF131B6  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF131B9  fbe224ee0100                      mov.l   #1EE24h, r14
FFF131BF  5cee                              movu.w  [r14], r14
FFF131C1  612e                              cmp     #2, r14
FFF131C3  19                                bne.s   loc_FFF131CC
FFF131C4  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF131C9  38d600                            bra.w   loc_FFF1329F
FFF131CC  a989                   loc_FFF131CC mov.l   20h+var_4[sp], r1
FFF131CE  71020c                            add     #20h+var_14, sp, r2
FFF131D1  3922ff                            bsr.w   sub_FFF130F3
FFF131D4  9201                              mov.w   r1, 20h+var_10[sp]
FFF131D6  ba01                              movu.w  20h+var_10[sp], r1
FFF131D8  6101                              cmp     #0, r1
FFF131DA  11                                beq.s   loc_FFF131E3
FFF131DB  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF131E0  38bf00                            bra.w   loc_FFF1329F
FFF131E3  a989                   loc_FFF131E3 mov.l   20h+var_4[sp], r1
FFF131E5  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF131EB  055d2d00                          bsr.a   sub_FFF15F48
FFF131EF  a081                              mov.l   r1, 20h+var_18[sp]
FFF131F1  a881                              mov.l   20h+var_18[sp], r1
FFF131F3  6101                              cmp     #0, r1
FFF131F5  2110                              bne.b   loc_FFF13205
FFF131F7  a881                              mov.l   20h+var_18[sp], r1
FFF131F9  05213c00                          bsr.a   sub_FFF16E1A
FFF131FD  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF13202  389d00                            bra.w   loc_FFF1329F
FFF13205  a989                   loc_FFF13205 mov.l   20h+var_4[sp], r1
FFF13207  39c00e                            bsr.w   sub_FFF140C7
FFF1320A  fb1224ee0100                      mov.l   #1EE24h, r1
FFF13210  72111c02                          add     #21Ch, r1, r1
FFF13214  fb22aeadf4ff                      mov.l   #loc_FFF4ADAE, r2
FFF1321A  052e2d00                          bsr.a   sub_FFF15F48
FFF1321E  a009                              mov.l   r1, 20h+var_1C[sp]
FFF13220  a809                              mov.l   20h+var_1C[sp], r1
FFF13222  6101                              cmp     #0, r1
FFF13224  210f                              bne.b   loc_FFF13233
FFF13226  a809                              mov.l   20h+var_1C[sp], r1
FFF13228  05f23b00                          bsr.a   sub_FFF16E1A
FFF1322C  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF13231  2e6e                              bra.b   loc_FFF1329F
FFF13233  fb1224ee0100           loc_FFF13233 mov.l   #1EE24h, r1
FFF13239  6221                              add     #2, r1
FFF1323B  fb36ff                            mov.l   #-1, r3
FFF1323E  a98a                              mov.l   20h+var_4[sp], r2
FFF13240  7f87                              smovu
FFF13242  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13248  f8e502                            mov.w   #2, [r14]
FFF1324B  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13251  e50e0341                          mov.l   20h+var_14[sp], 104h[r14]
FFF13255  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1325B  f9e64600                          mov.l   #0, 118h[r14]
FFF1325F  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13265  e50e02c7                          mov.l   20h+var_18[sp], 31Ch[r14]
FFF13269  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1326F  e50e01c8                          mov.l   20h+var_1C[sp], 320h[r14]
FFF13273  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13279  f9e6e90a                          mov.l   #0Ah, 3A4h[r14]
FFF1327D  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13283  e50e06ea                          mov.l   20h+var_8[sp], 3A8h[r14]
FFF13287  fbe224ee0100                      mov.l   #1EE24h, r14
FFF1328D  f9e6eb00                          mov.l   #0, 3ACh[r14]
FFF13291  fbe224ee0100                      mov.l   #1EE24h, r14
FFF13297  e50e05ec                          mov.l   20h+var_C[sp], 3B0h[r14]
FFF1329B  d5000801                          mov.w   20h+var_10[sp], 20h+var_1E[sp]
FFF1329F  d5000109               loc_FFF1329F mov.w   20h+var_1E[sp], 20h+var_E[sp]
FFF132A3  ba09                              movu.w  20h+var_E[sp], r1
FFF132A5  6708                              rtsd    #8

; ######## sub_FFF138AB  FFF138AB-FFF13A00 (file 3138AB) callers: FFF13A32(sub_FFF13A00), FFF13AD1(sub_FFF13A00)
FFF138AB  7100b0                 sub_FFF138AB add     #-50h, sp, sp   ; <<<< FUNC sub_FFF138AB
FFF138AE  a489                              mov.l   r1, 50h+var_4[sp]
FFF138B0  a482                              mov.l   r2, 50h+var_8[sp]
FFF138B2  a40b                              mov.l   r3, 50h+var_C[sp]
FFF138B4  f9052000                          mov.w   #0, 50h+var_10[sp]
FFF138B8  3e0f00                            mov.l   #0, 50h+var_14[sp]
FFF138BB  3e0200                            mov.l   #0, 50h+var_48[sp]
FFF138BE  3e0100                            mov.l   #0, 50h+var_4C[sp]
FFF138C1  ac89                              mov.l   50h+var_4[sp], r1
FFF138C3  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF138C9  057f2600                          bsr.a   sub_FFF15F48
FFF138CD  a381                              mov.l   r1, 50h+var_18[sp]
FFF138CF  ab81                              mov.l   50h+var_18[sp], r1
FFF138D1  6101                              cmp     #0, r1
FFF138D3  212c                              bne.b   loc_FFF138FF
FFF138D5  ab82                              mov.l   50h+var_18[sp], r2
FFF138D7  ac89                              mov.l   50h+var_4[sp], r1
FFF138D9  393c02                            bsr.w   sub_FFF13B15
FFF138DC  ac89                              mov.l   50h+var_4[sp], r1
FFF138DE  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF138E4  05642600                          bsr.a   sub_FFF15F48
FFF138E8  a381                              mov.l   r1, 50h+var_18[sp]
FFF138EA  ab81                              mov.l   50h+var_18[sp], r1
FFF138EC  6101                              cmp     #0, r1
FFF138EE  2111                              bne.b   loc_FFF138FF
FFF138F0  ab82                              mov.l   50h+var_18[sp], r2
FFF138F2  ac89                              mov.l   50h+var_4[sp], r1
FFF138F4  392102                            bsr.w   sub_FFF13B15
FFF138F7  f90901ffff                        mov.w   #-1, 50h+var_4E[sp]
FFF138FC  38fb00                            bra.w   loc_FFF139F7
FFF138FF  ab84                   loc_FFF138FF mov.l   50h+var_18[sp], r4
FFF13901  75432c                            mov.l   #2Ch, r3 ; ','
FFF13904  6612                              mov.l   #1, r2
FFF13906  71010c                            add     #50h+var_44, sp, r1
FFF13909  05a64500                          bsr.a   sub_FFF17EAF
FFF1390D  a389                              mov.l   r1, 50h+var_14[sp]
FFF1390F  ab89                              mov.l   50h+var_14[sp], r1
FFF13911  75512c                            cmp     #2Ch, r1 ; ','
FFF13914  2010                              beq.b   loc_FFF13924
FFF13916  ab81                              mov.l   50h+var_18[sp], r1
FFF13918  05023500                          bsr.a   sub_FFF16E1A
FFF1391C  f90901ffff                        mov.w   #-1, 50h+var_4E[sp]
FFF13921  38d600                            bra.w   loc_FFF139F7
FFF13924  f9052007               loc_FFF13924 mov.w   #7, 50h+var_10[sp]
FFF13928  3e0100                            mov.l   #0, 50h+var_4C[sp]
FFF1392B  5d0120                            movu.w  50h+var_10[sp], r1
FFF1392E  710e0c                            add     #50h+var_44, sp, r14
FFF13931  fece11                            movu.b  [r14, r1], r1
FFF13934  a009                              mov.l   r1, 50h+var_4C[sp]
FFF13936  dd0120                            mov.w   50h+var_10[sp], r1
FFF13939  6011                              sub     #1, r1
FFF1393B  d70120                            mov.w   r1, 50h+var_10[sp]
FFF1393E  a809                              mov.l   50h+var_4C[sp], r1
FFF13940  6c81                              shll    #8, r1
FFF13942  710e0c                            add     #50h+var_44, sp, r14
FFF13945  06c90e20                          add     50h+var_10[sp].uw, r14
FFF13949  54e1                              or      [r14], r1
FFF1394B  a009                              mov.l   r1, 50h+var_4C[sp]
FFF1394D  dd0120                            mov.w   50h+var_10[sp], r1
FFF13950  6011                              sub     #1, r1
FFF13952  d70120                            mov.w   r1, 50h+var_10[sp]
FFF13955  a809                              mov.l   50h+var_4C[sp], r1
FFF13957  6c81                              shll    #8, r1
FFF13959  710e0c                            add     #50h+var_44, sp, r14
FFF1395C  06c90e20                          add     50h+var_10[sp].uw, r14
FFF13960  54e1                              or      [r14], r1
FFF13962  a009                              mov.l   r1, 50h+var_4C[sp]
FFF13964  dd0120                            mov.w   50h+var_10[sp], r1
FFF13967  6011                              sub     #1, r1
FFF13969  d70120                            mov.w   r1, 50h+var_10[sp]
FFF1396C  a809                              mov.l   50h+var_4C[sp], r1
FFF1396E  6c81                              shll    #8, r1
FFF13970  710e0c                            add     #50h+var_44, sp, r14
FFF13973  06c90e20                          add     50h+var_10[sp].uw, r14
FFF13977  54e1                              or      [r14], r1
FFF13979  a009                              mov.l   r1, 50h+var_4C[sp]
FFF1397B  dd0120                            mov.w   50h+var_10[sp], r1
FFF1397E  6011                              sub     #1, r1
FFF13980  d70120                            mov.w   r1, 50h+var_10[sp]
FFF13983  f905202b                          mov.w   #2Bh, 50h+var_10[sp] ; '+'
FFF13987  3e0200                            mov.l   #0, 50h+var_48[sp]
FFF1398A  5d0120                            movu.w  50h+var_10[sp], r1
FFF1398D  710e0c                            add     #50h+var_44, sp, r14
FFF13990  fece11                            movu.b  [r14, r1], r1
FFF13993  a081                              mov.l   r1, 50h+var_48[sp]
FFF13995  dd0120                            mov.w   50h+var_10[sp], r1
FFF13998  6011                              sub     #1, r1
FFF1399A  d70120                            mov.w   r1, 50h+var_10[sp]
FFF1399D  a881                              mov.l   50h+var_48[sp], r1
FFF1399F  6c81                              shll    #8, r1
FFF139A1  710e0c                            add     #50h+var_44, sp, r14
FFF139A4  06c90e20                          add     50h+var_10[sp].uw, r14
FFF139A8  54e1                              or      [r14], r1
FFF139AA  a081                              mov.l   r1, 50h+var_48[sp]
FFF139AC  dd0120                            mov.w   50h+var_10[sp], r1
FFF139AF  6011                              sub     #1, r1
FFF139B1  d70120                            mov.w   r1, 50h+var_10[sp]
FFF139B4  a881                              mov.l   50h+var_48[sp], r1
FFF139B6  6c81                              shll    #8, r1
FFF139B8  710e0c                            add     #50h+var_44, sp, r14
FFF139BB  06c90e20                          add     50h+var_10[sp].uw, r14
FFF139BF  54e1                              or      [r14], r1
FFF139C1  a081                              mov.l   r1, 50h+var_48[sp]
FFF139C3  dd0120                            mov.w   50h+var_10[sp], r1
FFF139C6  6011                              sub     #1, r1
FFF139C8  d70120                            mov.w   r1, 50h+var_10[sp]
FFF139CB  a881                              mov.l   50h+var_48[sp], r1
FFF139CD  6c81                              shll    #8, r1
FFF139CF  710e0c                            add     #50h+var_44, sp, r14
FFF139D2  06c90e20                          add     50h+var_10[sp].uw, r14
FFF139D6  54e1                              or      [r14], r1
FFF139D8  a081                              mov.l   r1, 50h+var_48[sp]
FFF139DA  dd0120                            mov.w   50h+var_10[sp], r1
FFF139DD  6011                              sub     #1, r1
FFF139DF  d70120                            mov.w   r1, 50h+var_10[sp]
FFF139E2  a881                              mov.l   50h+var_48[sp], r1
FFF139E4  ac82                              mov.l   50h+var_8[sp], r2
FFF139E6  e321                              mov.l   r1, [r2]
FFF139E8  a809                              mov.l   50h+var_4C[sp], r1
FFF139EA  ac0a                              mov.l   50h+var_C[sp], r2
FFF139EC  e321                              mov.l   r1, [r2]
FFF139EE  ab81                              mov.l   50h+var_18[sp], r1
FFF139F0  052a3400                          bsr.a   sub_FFF16E1A
FFF139F4  3d0100                            mov.w   #0, 50h+var_4E[sp]
FFF139F7  d5000121               loc_FFF139F7 mov.w   50h+var_4E[sp], 50h+var_E[sp]
FFF139FB  5d0121                            movu.w  50h+var_E[sp], r1
FFF139FE  6714                              rtsd    #14h

; ######## sub_FFF13A00  FFF13A00-FFF13B15 (file 313A00) callers: FFF142D7(sub_FFF1427F), FFF145CE(sub_FFF14576), FFF3F6AE(sub_FFF3F648)
FFF13A00  7100dc                 sub_FFF13A00 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF13A00
FFF13A03  a201                              mov.l   r1, 24h+var_4[sp]
FFF13A05  a18a                              mov.l   r2, 24h+var_8[sp]
FFF13A07  3d0c00                            mov.w   #0, 24h+var_C[sp]
FFF13A0A  3e0500                            mov.l   #0, 24h+var_10[sp]
FFF13A0D  3e0300                            mov.l   #0, 24h+var_18[sp]
FFF13A10  3e0200                            mov.l   #0, 24h+var_1C[sp]
FFF13A13  aa01                              mov.l   24h+var_4[sp], r1
FFF13A15  710214                            add     #24h+var_10, sp, r2
FFF13A18  39dbf6                            bsr.w   sub_FFF130F3
FFF13A1B  9301                              mov.w   r1, 24h+var_C[sp]
FFF13A1D  bb01                              movu.w  24h+var_C[sp], r1
FFF13A1F  6101                              cmp     #0, r1
FFF13A21  11                                beq.s   loc_FFF13A2A
FFF13A22  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13A27  38e600                            bra.w   loc_FFF13B0D
FFF13A2A  aa01                   loc_FFF13A2A mov.l   24h+var_4[sp], r1
FFF13A2C  710308                            add     #24h+var_1C, sp, r3
FFF13A2F  71020c                            add     #24h+var_18, sp, r2
FFF13A32  3979fe                            bsr.w   sub_FFF138AB
FFF13A35  9301                              mov.w   r1, 24h+var_C[sp]
FFF13A37  bb01                              movu.w  24h+var_C[sp], r1
FFF13A39  6101                              cmp     #0, r1
FFF13A3B  11                                beq.s   loc_FFF13A44
FFF13A3C  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13A41  38cc00                            bra.w   loc_FFF13B0D
FFF13A44  a881                   loc_FFF13A44 mov.l   24h+var_1C[sp], r1
FFF13A46  6101                              cmp     #0, r1
FFF13A48  16                                beq.s   loc_FFF13A4E
FFF13A49  a889                              mov.l   24h+var_18[sp], r1
FFF13A4B  6101                              cmp     #0, r1
FFF13A4D  1d                                bne.s   loc_FFF13A52
FFF13A4E  f80601                 loc_FFF13A4E mov.l   #1, 24h+var_24[sp]
FFF13A51  0c                                bra.s   loc_FFF13A55
FFF13A52  f80600                 loc_FFF13A52 mov.l   #0, 24h+var_24[sp]
FFF13A55  ec01                   loc_FFF13A55 mov.l   24h+var_24[sp], r1
FFF13A57  6101                              cmp     #0, r1
FFF13A59  3a8900                            beq.w   loc_FFF13AE2
FFF13A5C  a909                              mov.l   24h+var_10[sp], r1
FFF13A5E  6081                              sub     #8, r1
FFF13A60  fb22b4030500                      mov.l   #503B4h, r2
FFF13A66  a029                              mov.l   r1, 4[r2]
FFF13A68  a909                              mov.l   24h+var_10[sp], r1
FFF13A6A  7111d4                            add     #-2Ch, r1, r1
FFF13A6D  fb22b4030500                      mov.l   #503B4h, r2
FFF13A73  a2a1                              mov.l   r1, 28h[r2]
FFF13A75  aa01                              mov.l   24h+var_4[sp], r1
FFF13A77  fb22b0adf4ff                      mov.l   #loc_FFF4ADB0, r2
FFF13A7D  05cb2400                          bsr.a   sub_FFF15F48
FFF13A81  a101                              mov.l   r1, 24h+var_14[sp]
FFF13A83  a901                              mov.l   24h+var_14[sp], r1
FFF13A85  6101                              cmp     #0, r1
FFF13A87  212b                              bne.b   loc_FFF13AB2
FFF13A89  a902                              mov.l   24h+var_14[sp], r2
FFF13A8B  aa01                              mov.l   24h+var_4[sp], r1
FFF13A8D  398800                            bsr.w   sub_FFF13B15
FFF13A90  aa01                              mov.l   24h+var_4[sp], r1
FFF13A92  fb22b0adf4ff                      mov.l   #loc_FFF4ADB0, r2
FFF13A98  05b02400                          bsr.a   sub_FFF15F48
FFF13A9C  a101                              mov.l   r1, 24h+var_14[sp]
FFF13A9E  a901                              mov.l   24h+var_14[sp], r1
FFF13AA0  6101                              cmp     #0, r1
FFF13AA2  2110                              bne.b   loc_FFF13AB2
FFF13AA4  a902                              mov.l   24h+var_14[sp], r2
FFF13AA6  aa01                              mov.l   24h+var_4[sp], r1
FFF13AA8  396d00                            bsr.w   sub_FFF13B15
FFF13AAB  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13AB0  2e5d                              bra.b   loc_FFF13B0D
FFF13AB2  a904                   loc_FFF13AB2 mov.l   24h+var_14[sp], r4
FFF13AB4  75432c                            mov.l   #2Ch, r3 ; ','
FFF13AB7  6612                              mov.l   #1, r2
FFF13AB9  fb12b4030500                      mov.l   #503B4h, r1
FFF13ABF  05514a00                          bsr.a   sub_FFF18510
FFF13AC3  a901                              mov.l   24h+var_14[sp], r1
FFF13AC5  05553300                          bsr.a   sub_FFF16E1A
FFF13AC9  aa01                              mov.l   24h+var_4[sp], r1
FFF13ACB  710308                            add     #24h+var_1C, sp, r3
FFF13ACE  71020c                            add     #24h+var_18, sp, r2
FFF13AD1  39dafd                            bsr.w   sub_FFF138AB
FFF13AD4  9301                              mov.w   r1, 24h+var_C[sp]
FFF13AD6  bb01                              movu.w  24h+var_C[sp], r1
FFF13AD8  6101                              cmp     #0, r1
FFF13ADA  10                                beq.s   loc_FFF13AE2
FFF13ADB  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13AE0  2e2d                              bra.b   loc_FFF13B0D
FFF13AE2  a909                   loc_FFF13AE2 mov.l   24h+var_10[sp], r1
FFF13AE4  6081                              sub     #8, r1
FFF13AE6  06850102                          cmp     24h+var_1C[sp].l, r1
FFF13AEA  10                                beq.s   loc_FFF13AF2
FFF13AEB  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13AF0  2e1d                              bra.b   loc_FFF13B0D
FFF13AF2  a909                   loc_FFF13AF2 mov.l   24h+var_10[sp], r1
FFF13AF4  7111d4                            add     #-2Ch, r1, r1
FFF13AF7  06850103                          cmp     24h+var_18[sp].l, r1
FFF13AFB  10                                beq.s   loc_FFF13B03
FFF13AFC  f90903ffff                        mov.w   #-1, 24h+var_1E[sp]
FFF13B01  2e0c                              bra.b   loc_FFF13B0D
FFF13B03  a909                   loc_FFF13B03 mov.l   24h+var_10[sp], r1
FFF13B05  a98a                              mov.l   24h+var_8[sp], r2
FFF13B07  e321                              mov.l   r1, [r2]
FFF13B09  d5000c03                          mov.w   24h+var_C[sp], 24h+var_1E[sp]
FFF13B0D  d500030d               loc_FFF13B0D mov.w   24h+var_1E[sp], 24h+var_A[sp]
FFF13B11  bb09                              movu.w  24h+var_A[sp], r1
FFF13B13  6709                              rtsd    #9

; ######## sub_FFF1427F  FFF1427F-FFF14433 (file 31427F) callers: FFF3F19D(sub_FFF3F146), FFF3F285(sub_FFF3F1FF), FFF3F71E(sub_FFF3F648)
FFF1427F  7100c8                 sub_FFF1427F add     #-38h, sp, sp   ; <<<< FUNC sub_FFF1427F
FFF14282  a309                              mov.l   r1, 38h+var_4[sp]
FFF14284  a302                              mov.l   r2, 38h+var_8[sp]
FFF14286  a28b                              mov.l   r3, 38h+var_C[sp]
FFF14288  3d8400                            mov.w   #0, 38h+var_10[sp]
FFF1428B  3e0400                            mov.l   #0, 38h+var_28[sp]
FFF1428E  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF14291  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF14294  fbe278020200                      mov.l   #20278h, r14
FFF1429A  5cee                              movu.w  [r14], r14
FFF1429C  612e                              cmp     #2, r14
FFF1429E  19                                bne.s   loc_FFF142A7
FFF1429F  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142A4  388701                            bra.w   loc_FFF1442B
FFF142A7  fb1278020200           loc_FFF142A7 mov.l   #20278h, r1
FFF142AD  b891                              movu.w  4[r1], r1
FFF142AF  6121                              cmp     #2, r1
FFF142B1  2121                              bne.b   loc_FFF142D2
FFF142B3  397105                            bsr.w   sub_FFF14824
FFF142B6  fbe278020200                      mov.l   #20278h, r14
FFF142BC  eeee4dc0                          mov.l   30134h[r14], r14
FFF142C0  610e                              cmp     #0, r14
FFF142C2  2010                              beq.b   loc_FFF142D2
FFF142C4  fbe278020200                      mov.l   #20278h, r14
FFF142CA  eee14dc0                          mov.l   30134h[r14], r1
FFF142CE  054c2b00                          bsr.a   sub_FFF16E1A
FFF142D2  ab09                   loc_FFF142D2 mov.l   38h+var_4[sp], r1
FFF142D4  710210                            add     #38h+var_28, sp, r2
FFF142D7  0529f7ff                          bsr.a   sub_FFF13A00
FFF142DB  9501                              mov.w   r1, 38h+var_10[sp]
FFF142DD  bd01                              movu.w  38h+var_10[sp], r1
FFF142DF  6101                              cmp     #0, r1
FFF142E1  11                                beq.s   loc_FFF142EA
FFF142E2  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142E7  384401                            bra.w   loc_FFF1442B
FFF142EA  ab01                   loc_FFF142EA mov.l   38h+var_8[sp], r1
FFF142EC  06850104                          cmp     38h+var_28[sp].l, r1
FFF142F0  250a                              bleu.b  loc_FFF142FA
FFF142F2  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142F7  383401                            bra.w   loc_FFF1442B
FFF142FA  fbe2d0940600           loc_FFF142FA mov.l   #694D0h, r14
FFF14300  e10e04                            mov.l   38h+var_28[sp], [r14]
FFF14303  fbe299220100                      mov.l   #12299h, r14
FFF14309  f8e401                            mov.b   #1, [r14]
FFF1430C  ab09                              mov.l   38h+var_4[sp], r1
FFF1430E  fb22d0adf4ff                      mov.l   #loc_FFF4ADD0, r2
FFF14314  05341c00                          bsr.a   sub_FFF15F48
FFF14318  a081                              mov.l   r1, 38h+var_30[sp]
FFF1431A  a881                              mov.l   38h+var_30[sp], r1
FFF1431C  6101                              cmp     #0, r1
FFF1431E  212e                              bne.b   loc_FFF1434C
FFF14320  a882                              mov.l   38h+var_30[sp], r2
FFF14322  ab09                              mov.l   38h+var_4[sp], r1
FFF14324  05f1f7ff                          bsr.a   sub_FFF13B15
FFF14328  ab09                              mov.l   38h+var_4[sp], r1
FFF1432A  fb22d0adf4ff                      mov.l   #loc_FFF4ADD0, r2
FFF14330  05181c00                          bsr.a   sub_FFF15F48
FFF14334  a081                              mov.l   r1, 38h+var_30[sp]
FFF14336  a881                              mov.l   38h+var_30[sp], r1
FFF14338  6101                              cmp     #0, r1
FFF1433A  2112                              bne.b   loc_FFF1434C
FFF1433C  a882                              mov.l   38h+var_30[sp], r2
FFF1433E  ab09                              mov.l   38h+var_4[sp], r1
FFF14340  05d5f7ff                          bsr.a   sub_FFF13B15
FFF14344  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14349  38e200                            bra.w   loc_FFF1442B
FFF1434C  ab01                   loc_FFF1434C mov.l   38h+var_8[sp], r1
FFF1434E  7c01                              btst    #0, r1
FFF14350  17                                beq.s   loc_FFF14357
FFF14351  ab01                              mov.l   38h+var_8[sp], r1
FFF14353  6211                              add     #1, r1
FFF14355  a301                              mov.l   r1, 38h+var_8[sp]
FFF14357  ab01                   loc_FFF14357 mov.l   38h+var_8[sp], r1
FFF14359  71112c                            add     #2Ch, r1, r1 ; ','
FFF1435C  a089                              mov.l   r1, 38h+var_2C[sp]
FFF1435E  a88a                              mov.l   38h+var_2C[sp], r2
FFF14360  a881                              mov.l   38h+var_30[sp], r1
FFF14362  6603                              mov.l   #0, r3
FFF14364  05eb4f00                          bsr.a   sub_FFF1934F
FFF14368  a009                              mov.l   r1, 38h+var_34[sp]
FFF1436A  a809                              mov.l   38h+var_34[sp], r1
FFF1436C  7501ff                            cmp     #-1, r1
FFF1436F  2110                              bne.b   loc_FFF1437F
FFF14371  a881                              mov.l   38h+var_30[sp], r1
FFF14373  05a72a00                          bsr.a   sub_FFF16E1A
FFF14377  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF1437C  38af00                            bra.w   loc_FFF1442B
FFF1437F  ab0a                   loc_FFF1437F mov.l   38h+var_4[sp], r2
FFF14381  fb1278020200                      mov.l   #20278h, r1
FFF14387  6261                              add     #6, r1
FFF14389  05c71103                          bsr.a   sub_FFF45550
FFF1438D  ab01                              mov.l   38h+var_8[sp], r1
FFF1438F  71112c                            add     #2Ch, r1, r1 ; ','
FFF14392  fbe278020200                      mov.l   #20278h, r14
FFF14398  e7e143                            mov.l   r1, 10Ch[r14]
FFF1439B  fbe278020200                      mov.l   #20278h, r14
FFF143A1  e50e0442                          mov.l   38h+var_28[sp], 108h[r14]
FFF143A5  fbe278020200                      mov.l   #20278h, r14
FFF143AB  e90e024dc0                        mov.l   38h+var_30[sp], 30134h[r14]
FFF143B0  3d0a00                            mov.w   #0, 38h+var_24[sp]
FFF143B3  e5000407                          mov.l   38h+var_28[sp], 38h+var_1C[sp]
FFF143B7  ab01                              mov.l   38h+var_8[sp], r1
FFF143B9  71112c                            add     #2Ch, r1, r1 ; ','
FFF143BC  a209                              mov.l   r1, 38h+var_14[sp]
FFF143BE  fb1278020200                      mov.l   #20278h, r1
FFF143C4  72112201                          add     #122h, r1, r1
FFF143C8  a201                              mov.l   r1, 38h+var_18[sp]
FFF143CA  e5000d06                          mov.l   38h+var_4[sp], 38h+var_20[sp]
FFF143CE  fbe278020200                      mov.l   #20278h, r14
FFF143D4  f9e59000                          mov.w   #0, 120h[r14]
FFF143D8  fbe278020200                      mov.l   #20278h, r14
FFF143DE  e90e0b4cc0                        mov.l   38h+var_C[sp], 30130h[r14]
FFF143E3  7100ec                            add     #-14h, sp, sp
FFF143E6  754314                            mov.l   #14h, r3
FFF143E9  710228                            add     #4Ch+var_24, sp, r2
FFF143EC  ef01                              mov.l   sp, r1
FFF143EE  7f8f                              smovf
FFF143F0  0589fcff                          bsr.a   sub_FFF14079
FFF143F4  710014                            add     #14h, sp, sp
FFF143F7  fbe278020200                      mov.l   #20278h, r14
FFF143FD  f8e501                            mov.w   #1, [r14]
FFF14400  fbe278020200                      mov.l   #20278h, r14
FFF14406  f9e58a01                          mov.w   #1, 114h[r14]
FFF1440A  fb1278020200                      mov.l   #20278h, r1
FFF14410  3d1202                            mov.w   #2, 4[r1]
FFF14413  fbe278020200                      mov.l   #20278h, r14
FFF14419  73ee3a0103                        add     #3013Ah, r14, r14
FFF1441E  f8e500                            mov.w   #0, [r14]
FFF14421  39fb0d                            bsr.w   sub_FFF1521C
FFF14424  39630c                            bsr.w   sub_FFF15087
FFF14427  d5001401                          mov.w   38h+var_10[sp], 38h+var_36[sp]
FFF1442B  d5000115               loc_FFF1442B mov.w   38h+var_36[sp], 38h+var_E[sp]
FFF1442F  bd09                              movu.w  38h+var_E[sp], r1
FFF14431  670e                              rtsd    #0Eh

; ######## sub_FFF14576  FFF14576-FFF146FC (file 314576) callers: FFF3F37D(sub_FFF3F30D)
FFF14576  7100c8                 sub_FFF14576 add     #-38h, sp, sp   ; <<<< FUNC sub_FFF14576
FFF14579  a309                              mov.l   r1, 38h+var_4[sp]
FFF1457B  a302                              mov.l   r2, 38h+var_8[sp]
FFF1457D  a28b                              mov.l   r3, 38h+var_C[sp]
FFF1457F  3d8400                            mov.w   #0, 38h+var_10[sp]
FFF14582  3e0400                            mov.l   #0, 38h+var_28[sp]
FFF14585  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF14588  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF1458B  fbe278020200                      mov.l   #20278h, r14
FFF14591  5cee                              movu.w  [r14], r14
FFF14593  612e                              cmp     #2, r14
FFF14595  19                                bne.s   loc_FFF1459E
FFF14596  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF1459B  385901                            bra.w   loc_FFF146F4
FFF1459E  fb1278020200           loc_FFF1459E mov.l   #20278h, r1
FFF145A4  b891                              movu.w  4[r1], r1
FFF145A6  6121                              cmp     #2, r1
FFF145A8  2121                              bne.b   loc_FFF145C9
FFF145AA  397a02                            bsr.w   sub_FFF14824
FFF145AD  fbe278020200                      mov.l   #20278h, r14
FFF145B3  eeee4dc0                          mov.l   30134h[r14], r14
FFF145B7  610e                              cmp     #0, r14
FFF145B9  2010                              beq.b   loc_FFF145C9
FFF145BB  fbe278020200                      mov.l   #20278h, r14
FFF145C1  eee14dc0                          mov.l   30134h[r14], r1
FFF145C5  05552800                          bsr.a   sub_FFF16E1A
FFF145C9  ab09                   loc_FFF145C9 mov.l   38h+var_4[sp], r1
FFF145CB  710210                            add     #38h+var_28, sp, r2
FFF145CE  0532f4ff                          bsr.a   sub_FFF13A00
FFF145D2  9501                              mov.w   r1, 38h+var_10[sp]
FFF145D4  bd01                              movu.w  38h+var_10[sp], r1
FFF145D6  6101                              cmp     #0, r1
FFF145D8  11                                beq.s   loc_FFF145E1
FFF145D9  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF145DE  381601                            bra.w   loc_FFF146F4
FFF145E1  ab01                   loc_FFF145E1 mov.l   38h+var_8[sp], r1
FFF145E3  06850104                          cmp     38h+var_28[sp].l, r1
FFF145E7  250a                              bleu.b  loc_FFF145F1
FFF145E9  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF145EE  380601                            bra.w   loc_FFF146F4
FFF145F1  fbe2d0940600           loc_FFF145F1 mov.l   #694D0h, r14
FFF145F7  e10e04                            mov.l   38h+var_28[sp], [r14]
FFF145FA  fbe299220100                      mov.l   #12299h, r14
FFF14600  f8e401                            mov.b   #1, [r14]
FFF14603  ab09                              mov.l   38h+var_4[sp], r1
FFF14605  fb22d0adf4ff                      mov.l   #loc_FFF4ADD0, r2
FFF1460B  053d1900                          bsr.a   sub_FFF15F48
FFF1460F  a081                              mov.l   r1, 38h+var_30[sp]
FFF14611  a881                              mov.l   38h+var_30[sp], r1
FFF14613  6101                              cmp     #0, r1
FFF14615  2110                              bne.b   loc_FFF14625
FFF14617  a881                              mov.l   38h+var_30[sp], r1
FFF14619  05012800                          bsr.a   sub_FFF16E1A
FFF1461D  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14622  38d200                            bra.w   loc_FFF146F4
FFF14625  ab01                   loc_FFF14625 mov.l   38h+var_8[sp], r1
FFF14627  7c01                              btst    #0, r1
FFF14629  17                                beq.s   loc_FFF14630
FFF1462A  ab01                              mov.l   38h+var_8[sp], r1
FFF1462C  6211                              add     #1, r1
FFF1462E  a301                              mov.l   r1, 38h+var_8[sp]
FFF14630  e5000c03               loc_FFF14630 mov.l   38h+var_8[sp], 38h+var_2C[sp]
FFF14634  a88a                              mov.l   38h+var_2C[sp], r2
FFF14636  a881                              mov.l   38h+var_30[sp], r1
FFF14638  6603                              mov.l   #0, r3
FFF1463A  05154d00                          bsr.a   sub_FFF1934F
FFF1463E  a009                              mov.l   r1, 38h+var_34[sp]
FFF14640  a809                              mov.l   38h+var_34[sp], r1
FFF14642  7501ff                            cmp     #-1, r1
FFF14645  2110                              bne.b   loc_FFF14655
FFF14647  a881                              mov.l   38h+var_30[sp], r1
FFF14649  05d12700                          bsr.a   sub_FFF16E1A
FFF1464D  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14652  38a200                            bra.w   loc_FFF146F4
FFF14655  ab0a                   loc_FFF14655 mov.l   38h+var_4[sp], r2
FFF14657  fb1278020200                      mov.l   #20278h, r1
FFF1465D  6261                              add     #6, r1
FFF1465F  05f10e03                          bsr.a   sub_FFF45550
FFF14663  fbe278020200                      mov.l   #20278h, r14
FFF14669  e50e0c43                          mov.l   38h+var_8[sp], 10Ch[r14]
FFF1466D  fbe278020200                      mov.l   #20278h, r14
FFF14673  e50e0442                          mov.l   38h+var_28[sp], 108h[r14]
FFF14677  fbe278020200                      mov.l   #20278h, r14
FFF1467D  e90e024dc0                        mov.l   38h+var_30[sp], 30134h[r14]
FFF14682  3d0a00                            mov.w   #0, 38h+var_24[sp]
FFF14685  e5000407                          mov.l   38h+var_28[sp], 38h+var_1C[sp]
FFF14689  e5000c09                          mov.l   38h+var_8[sp], 38h+var_14[sp]
FFF1468D  fb1278020200                      mov.l   #20278h, r1
FFF14693  72112201                          add     #122h, r1, r1
FFF14697  a201                              mov.l   r1, 38h+var_18[sp]
FFF14699  e5000d06                          mov.l   38h+var_4[sp], 38h+var_20[sp]
FFF1469D  fbe278020200                      mov.l   #20278h, r14
FFF146A3  f9e59000                          mov.w   #0, 120h[r14]
FFF146A7  fbe278020200                      mov.l   #20278h, r14
FFF146AD  e90e0b4cc0                        mov.l   38h+var_C[sp], 30130h[r14]
FFF146B2  7100ec                            add     #-14h, sp, sp
FFF146B5  754314                            mov.l   #14h, r3
FFF146B8  710228                            add     #4Ch+var_24, sp, r2
FFF146BB  ef01                              mov.l   sp, r1
FFF146BD  7f8f                              smovf
FFF146BF  05baf9ff                          bsr.a   sub_FFF14079
FFF146C3  710014                            add     #14h, sp, sp
FFF146C6  fbe278020200                      mov.l   #20278h, r14
FFF146CC  f8e501                            mov.w   #1, [r14]
FFF146CF  fbe278020200                      mov.l   #20278h, r14
FFF146D5  f9e58a01                          mov.w   #1, 114h[r14]
FFF146D9  fb1278020200                      mov.l   #20278h, r1
FFF146DF  3d1202                            mov.w   #2, 4[r1]
FFF146E2  fbe278020200                      mov.l   #20278h, r14
FFF146E8  73ee3a0103                        add     #3013Ah, r14, r14
FFF146ED  f8e500                            mov.w   #0, [r14]
FFF146F0  d5001401                          mov.w   38h+var_10[sp], 38h+var_36[sp]
FFF146F4  d5000115               loc_FFF146F4 mov.w   38h+var_36[sp], 38h+var_E[sp]
FFF146F8  bd09                              movu.w  38h+var_E[sp], r1
FFF146FA  670e                              rtsd    #0Eh

; ######## sub_FFF149AB  FFF149AB-FFF14AEF (file 3149AB) callers: FFF3EE61(sub_FFF3EE00)
FFF149AB  7100e4                 sub_FFF149AB add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF149AB
FFF149AE  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF149B0  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF149B2  3d0800                            mov.w   #0, 1Ch+var_C[sp]
FFF149B5  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF149B8  fbe278020200                      mov.l   #20278h, r14
FFF149BE  5cee                              movu.w  [r14], r14
FFF149C0  611e                              cmp     #1, r14
FFF149C2  19                                bne.s   loc_FFF149CB
FFF149C3  f90903ffff                        mov.w   #-1, 1Ch+var_16[sp]
FFF149C8  381f01                            bra.w   loc_FFF14AE7
FFF149CB  fb1278020200           loc_FFF149CB mov.l   #20278h, r1
FFF149D1  b891                              movu.w  4[r1], r1
FFF149D3  6131                              cmp     #3, r1
FFF149D5  200d                              beq.b   loc_FFF149E2
FFF149D7  fb1278020200                      mov.l   #20278h, r1
FFF149DD  b891                              movu.w  4[r1], r1
FFF149DF  6141                              cmp     #4, r1
FFF149E1  1d                                bne.s   loc_FFF149E6
FFF149E2  f80601                 loc_FFF149E2 mov.l   #1, 1Ch+var_1C[sp]
FFF149E5  0c                                bra.s   loc_FFF149E9
FFF149E6  f80600                 loc_FFF149E6 mov.l   #0, 1Ch+var_1C[sp]
FFF149E9  ec01                   loc_FFF149E9 mov.l   1Ch+var_1C[sp], r1
FFF149EB  6101                              cmp     #0, r1
FFF149ED  11                                beq.s   loc_FFF149F6
FFF149EE  f90903ffff                        mov.w   #-1, 1Ch+var_16[sp]
FFF149F3  38f400                            bra.w   loc_FFF14AE7
FFF149F6  a981                   loc_FFF149F6 mov.l   1Ch+var_4[sp], r1
FFF149F8  fb22d3adf4ff                      mov.l   #(loc_FFF4ADD0+3), r2
FFF149FE  054a1500                          bsr.a   sub_FFF15F48
FFF14A02  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF14A04  a889                              mov.l   1Ch+var_10[sp], r1
FFF14A06  6101                              cmp     #0, r1
FFF14A08  2110                              bne.b   loc_FFF14A18
FFF14A0A  a889                              mov.l   1Ch+var_10[sp], r1
FFF14A0C  050e2400                          bsr.a   sub_FFF16E1A
FFF14A10  f90903ffff                        mov.w   #-1, 1Ch+var_16[sp]
FFF14A15  38d200                            bra.w   loc_FFF14AE7
FFF14A18  fb12b4030500           loc_FFF14A18 mov.l   #503B4h, r1
FFF14A1E  3e1100                            mov.l   #0, 4[r1]
FFF14A21  fb12b4030500                      mov.l   #503B4h, r1
FFF14A27  3e1a00                            mov.l   #0, 28h[r1]
FFF14A2A  a88c                              mov.l   1Ch+var_10[sp], r4
FFF14A2C  75432c                            mov.l   #2Ch, r3 ; ','
FFF14A2F  6612                              mov.l   #1, r2
FFF14A31  fb12b4030500                      mov.l   #503B4h, r1
FFF14A37  05d93a00                          bsr.a   sub_FFF18510
FFF14A3B  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF14A3D  a881                              mov.l   1Ch+var_14[sp], r1
FFF14A3F  75512c                            cmp     #2Ch, r1 ; ','
FFF14A42  2010                              beq.b   loc_FFF14A52
FFF14A44  a889                              mov.l   1Ch+var_10[sp], r1
FFF14A46  05d42300                          bsr.a   sub_FFF16E1A
FFF14A4A  f90903ffff                        mov.w   #-1, 1Ch+var_16[sp]
FFF14A4F  389800                            bra.w   loc_FFF14AE7
FFF14A52  a982                   loc_FFF14A52 mov.l   1Ch+var_4[sp], r2
FFF14A54  fb1278020200                      mov.l   #20278h, r1
FFF14A5A  6261                              add     #6, r1
FFF14A5C  05f40a03                          bsr.a   sub_FFF45550
FFF14A60  fbe278020200                      mov.l   #20278h, r14
FFF14A66  f9e64300                          mov.l   #0, 10Ch[r14]
FFF14A6A  fbe278020200                      mov.l   #20278h, r14
FFF14A70  f9e64200                          mov.l   #0, 108h[r14]
FFF14A74  fbe278020200                      mov.l   #20278h, r14
FFF14A7A  f8e502                            mov.w   #2, [r14]
FFF14A7D  fbe278020200                      mov.l   #20278h, r14
FFF14A83  f9e58a01                          mov.w   #1, 114h[r14]
FFF14A87  fbe278020200                      mov.l   #20278h, r14
FFF14A8D  f9e64600                          mov.l   #0, 118h[r14]
FFF14A91  fbe278020200                      mov.l   #20278h, r14
FFF14A97  f9e59003                          mov.w   #3, 120h[r14]
FFF14A9B  fbe278020200                      mov.l   #20278h, r14
FFF14AA1  fae596c003                        mov.w   #3, 1812Ch[r14]
FFF14AA6  fb1278020200                      mov.l   #20278h, r1
FFF14AAC  3d1203                            mov.w   #3, 4[r1]
FFF14AAF  fbe278020200                      mov.l   #20278h, r14
FFF14AB5  f9e6432c                          mov.l   #2Ch, 10Ch[r14] ; ','
FFF14AB9  fbe278020200                      mov.l   #20278h, r14
FFF14ABF  e90e054cc0                        mov.l   1Ch+var_8[sp], 30130h[r14]
FFF14AC4  fbe278020200                      mov.l   #20278h, r14
FFF14ACA  e90e034dc0                        mov.l   1Ch+var_10[sp], 30134h[r14]
FFF14ACF  fbe278020200                      mov.l   #20278h, r14
FFF14AD5  73ee380103                        add     #30138h, r14, r14
FFF14ADA  f8e500                            mov.w   #0, [r14]
FFF14ADD  393f07                            bsr.w   sub_FFF1521C
FFF14AE0  39860c                            bsr.w   sub_FFF15766
FFF14AE3  d5000803                          mov.w   1Ch+var_C[sp], 1Ch+var_16[sp]
FFF14AE7  d5000309               loc_FFF14AE7 mov.w   1Ch+var_16[sp], 1Ch+var_A[sp]
FFF14AEB  ba09                              movu.w  1Ch+var_A[sp], r1
FFF14AED  6707                              rtsd    #7

; ######## sub_FFF14BFA  FFF14BFA-FFF14D3A (file 314BFA) callers: FFF3EF2B(sub_FFF3EECA)
FFF14BFA  7100e0                 sub_FFF14BFA add     #-20h, sp, sp   ; <<<< FUNC sub_FFF14BFA
FFF14BFD  a189                              mov.l   r1, 20h+var_4[sp]
FFF14BFF  a182                              mov.l   r2, 20h+var_8[sp]
FFF14C01  3d0a00                            mov.w   #0, 20h+var_C[sp]
FFF14C04  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF14C07  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF14C0A  fbe278020200                      mov.l   #20278h, r14
FFF14C10  5cee                              movu.w  [r14], r14
FFF14C12  611e                              cmp     #1, r14
FFF14C14  19                                bne.s   loc_FFF14C1D
FFF14C15  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C1A  381801                            bra.w   loc_FFF14D32
FFF14C1D  fb1278020200           loc_FFF14C1D mov.l   #20278h, r1
FFF14C23  b891                              movu.w  4[r1], r1
FFF14C25  6131                              cmp     #3, r1
FFF14C27  200d                              beq.b   loc_FFF14C34
FFF14C29  fb1278020200                      mov.l   #20278h, r1
FFF14C2F  b891                              movu.w  4[r1], r1
FFF14C31  6141                              cmp     #4, r1
FFF14C33  1d                                bne.s   loc_FFF14C38
FFF14C34  f80601                 loc_FFF14C34 mov.l   #1, 20h+var_20[sp]
FFF14C37  0c                                bra.s   loc_FFF14C3B
FFF14C38  f80600                 loc_FFF14C38 mov.l   #0, 20h+var_20[sp]
FFF14C3B  ec01                   loc_FFF14C3B mov.l   20h+var_20[sp], r1
FFF14C3D  6101                              cmp     #0, r1
FFF14C3F  11                                beq.s   loc_FFF14C48
FFF14C40  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C45  38ed00                            bra.w   loc_FFF14D32
FFF14C48  a989                   loc_FFF14C48 mov.l   20h+var_4[sp], r1
FFF14C4A  71020c                            add     #20h+var_14, sp, r2
FFF14C4D  05a6e4ff                          bsr.a   sub_FFF130F3
FFF14C51  9281                              mov.w   r1, 20h+var_C[sp]
FFF14C53  ba81                              movu.w  20h+var_C[sp], r1
FFF14C55  6101                              cmp     #0, r1
FFF14C57  11                                beq.s   loc_FFF14C60
FFF14C58  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C5D  38d500                            bra.w   loc_FFF14D32
FFF14C60  a989                   loc_FFF14C60 mov.l   20h+var_4[sp], r1
FFF14C62  fb22d5adf4ff                      mov.l   #loc_FFF4ADD5, r2
FFF14C68  05e01200                          bsr.a   sub_FFF15F48
FFF14C6C  a101                              mov.l   r1, 20h+var_10[sp]
FFF14C6E  a901                              mov.l   20h+var_10[sp], r1
FFF14C70  6101                              cmp     #0, r1
FFF14C72  210e                              bne.b   loc_FFF14C80
FFF14C74  05a62100                          bsr.a   sub_FFF16E1A
FFF14C78  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C7D  38b500                            bra.w   loc_FFF14D32
FFF14C80  a88a                   loc_FFF14C80 mov.l   20h+var_14[sp], r2
FFF14C82  6603                              mov.l   #0, r3
FFF14C84  05cb4600                          bsr.a   sub_FFF1934F
FFF14C88  a881                              mov.l   20h+var_18[sp], r1
FFF14C8A  7501ff                            cmp     #-1, r1
FFF14C8D  2110                              bne.b   loc_FFF14C9D
FFF14C8F  a901                              mov.l   20h+var_10[sp], r1
FFF14C91  05892100                          bsr.a   sub_FFF16E1A
FFF14C95  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF14C9A  389800                            bra.w   loc_FFF14D32
FFF14C9D  a98a                   loc_FFF14C9D mov.l   20h+var_4[sp], r2
FFF14C9F  fb1278020200                      mov.l   #20278h, r1
FFF14CA5  6261                              add     #6, r1
FFF14CA7  05a90803                          bsr.a   sub_FFF45550
FFF14CAB  fbe278020200                      mov.l   #20278h, r14
FFF14CB1  e50e0343                          mov.l   20h+var_14[sp], 10Ch[r14]
FFF14CB5  fbe278020200                      mov.l   #20278h, r14
FFF14CBB  e50e0342                          mov.l   20h+var_14[sp], 108h[r14]
FFF14CBF  fbe278020200                      mov.l   #20278h, r14
FFF14CC5  f8e502                            mov.w   #2, [r14]
FFF14CC8  fbe278020200                      mov.l   #20278h, r14
FFF14CCE  f9e58a01                          mov.w   #1, 114h[r14]
FFF14CD2  fbe278020200                      mov.l   #20278h, r14
FFF14CD8  f9e64600                          mov.l   #0, 118h[r14]
FFF14CDC  fbe278020200                      mov.l   #20278h, r14
FFF14CE2  f9e59003                          mov.w   #3, 120h[r14]
FFF14CE6  fbe278020200                      mov.l   #20278h, r14
FFF14CEC  fae596c003                        mov.w   #3, 1812Ch[r14]
FFF14CF1  fb1278020200                      mov.l   #20278h, r1
FFF14CF7  3d1203                            mov.w   #3, 4[r1]
FFF14CFA  fbe278020200                      mov.l   #20278h, r14
FFF14D00  e50e0343                          mov.l   20h+var_14[sp], 10Ch[r14]
FFF14D04  fbe278020200                      mov.l   #20278h, r14
FFF14D0A  e90e064cc0                        mov.l   20h+var_8[sp], 30130h[r14]
FFF14D0F  fbe278020200                      mov.l   #20278h, r14
FFF14D15  e90e044dc0                        mov.l   20h+var_10[sp], 30134h[r14]
FFF14D1A  fbe278020200                      mov.l   #20278h, r14
FFF14D20  73ee380103                        add     #30138h, r14, r14
FFF14D25  f8e500                            mov.w   #0, [r14]
FFF14D28  39f404                            bsr.w   sub_FFF1521C
FFF14D2B  393b0a                            bsr.w   sub_FFF15766
FFF14D2E  d5000a03                          mov.w   20h+var_C[sp], 20h+var_1A[sp]
FFF14D32  d500030b               loc_FFF14D32 mov.w   20h+var_1A[sp], 20h+var_A[sp]
FFF14D36  ba89                              movu.w  20h+var_A[sp], r1
FFF14D38  6708                              rtsd    #8

; ######## sub_FFF14E1F  FFF14E1F-FFF14EFC (file 314E1F) callers: FFF3DEEF(sub_FFF3DE6A), FFF3DFEB(sub_FFF3DF66)
FFF14E1F  7100e0                 sub_FFF14E1F add     #-20h, sp, sp   ; <<<< FUNC sub_FFF14E1F
FFF14E22  a189                              mov.l   r1, 20h+var_4[sp]
FFF14E24  868a                              mov.b   r2, 20h+var_5[sp]
FFF14E26  a10b                              mov.l   r3, 20h+var_C[sp]
FFF14E28  3d0800                            mov.w   #0, 20h+var_10[sp]
FFF14E2B  3d0700                            mov.w   #0, 20h+var_12[sp]
FFF14E2E  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF14E31  fbe2b8930600                      mov.l   #693B8h, r14
FFF14E37  5cee                              movu.w  [r14], r14
FFF14E39  612e                              cmp     #2, r14
FFF14E3B  19                                bne.s   loc_FFF14E44
FFF14E3C  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF14E41  38b300                            bra.w   loc_FFF14EF4
FFF14E44  a98a                   loc_FFF14E44 mov.l   20h+var_4[sp], r2
FFF14E46  fb12b8930600                      mov.l   #693B8h, r1
FFF14E4C  6221                              add     #2, r1
FFF14E4E  05020703                          bsr.a   sub_FFF45550
FFF14E52  fb12b8930600                      mov.l   #693B8h, r1
FFF14E58  6221                              add     #2, r1
FFF14E5A  710208                            add     #20h+var_18, sp, r2
FFF14E5D  0596e2ff                          bsr.a   sub_FFF130F3
FFF14E61  9189                              mov.w   r1, 20h+var_12[sp]
FFF14E63  b989                              movu.w  20h+var_12[sp], r1
FFF14E65  6101                              cmp     #0, r1
FFF14E67  14                                beq.s   loc_FFF14E6B
FFF14E68  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF14E6B  fbe2b8930600           loc_FFF14E6B mov.l   #693B8h, r14
FFF14E71  e50e0241                          mov.l   20h+var_18[sp], 104h[r14]
FFF14E75  b689                              movu.b  20h+var_5[sp], r1
FFF14E77  6111                              cmp     #1, r1
FFF14E79  2027                              beq.b   loc_FFF14EA0
FFF14E7B  6101                              cmp     #0, r1
FFF14E7D  2144                              bne.b   loc_FFF14EC1
FFF14E7F  a989                              mov.l   20h+var_4[sp], r1
FFF14E81  fb22d3adf4ff                      mov.l   #(loc_FFF4ADD0+3), r2
FFF14E87  05c11000                          bsr.a   sub_FFF15F48
FFF14E8B  a009                              mov.l   r1, 20h+var_1C[sp]
FFF14E8D  a809                              mov.l   20h+var_1C[sp], r1
FFF14E8F  6101                              cmp     #0, r1
FFF14E91  2130                              bne.b   loc_FFF14EC1
FFF14E93  a809                              mov.l   20h+var_1C[sp], r1
FFF14E95  05851f00                          bsr.a   sub_FFF16E1A
FFF14E99  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF14E9E  2e56                              bra.b   loc_FFF14EF4
FFF14EA0  a989                   loc_FFF14EA0 mov.l   20h+var_4[sp], r1
FFF14EA2  fb22d8adf4ff                      mov.l   #(loc_FFF4ADD5+3), r2
FFF14EA8  05a01000                          bsr.a   sub_FFF15F48
FFF14EAC  a009                              mov.l   r1, 20h+var_1C[sp]
FFF14EAE  a809                              mov.l   20h+var_1C[sp], r1
FFF14EB0  6101                              cmp     #0, r1
FFF14EB2  210f                              bne.b   loc_FFF14EC1
FFF14EB4  a809                              mov.l   20h+var_1C[sp], r1
FFF14EB6  05641f00                          bsr.a   sub_FFF16E1A
FFF14EBA  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF14EBF  2e35                              bra.b   loc_FFF14EF4
FFF14EC1  fbe2b8930600           loc_FFF14EC1 mov.l   #693B8h, r14
FFF14EC7  f8e502                            mov.w   #2, [r14]
FFF14ECA  fbe2b8930600                      mov.l   #693B8h, r14
FFF14ED0  e50e0544                          mov.l   20h+var_C[sp], 110h[r14]
FFF14ED4  fbe2b8930600                      mov.l   #693B8h, r14
FFF14EDA  e50e0145                          mov.l   20h+var_1C[sp], 114h[r14]
FFF14EDE  fbe295220100                      mov.l   #12295h, r14
FFF14EE4  f8e400                            mov.b   #0, [r14]
FFF14EE7  fbe296220100                      mov.l   #12296h, r14
FFF14EED  f8e400                            mov.b   #0, [r14]
FFF14EF0  d5000801                          mov.w   20h+var_10[sp], 20h+var_1E[sp]
FFF14EF4  d5000109               loc_FFF14EF4 mov.w   20h+var_1E[sp], 20h+var_E[sp]
FFF14EF8  ba09                              movu.w  20h+var_E[sp], r1
FFF14EFA  6708                              rtsd    #8

; ######## sub_FFF35454  FFF35454-FFF354F0 (file 335454) callers: FFF355B4(sub_FFF3556B), FFF359D2(sub_FFF35948), FFF35AA1(sub_FFF35A08), FFF35AD3(sub_FFF35A08), FFF35B29(sub_FFF35A08), FFF35B43(sub_FFF35A08), FFF35C0D(sub_FFF35B7D), FFF35C2E(sub_FFF35B7D), FFF35C74(sub_FFF35B7D), FFF35C94(sub_FFF35B7D), FFF35E1C(sub_FFF35D0B), FFF35EE1(sub_FFF35D0B), FFF35F01(sub_FFF35D0B), FFF3620C(sub_FFF3617D)
FFF35454  7100dc                 sub_FFF35454 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF35454
FFF35457  a201                              mov.l   r1, 24h+var_4[sp]
FFF35459  a18a                              mov.l   r2, 24h+var_8[sp]
FFF3545B  930b                              mov.w   r3, 24h+var_A[sp]
FFF3545D  a10c                              mov.l   r4, 24h+var_10[sp]
FFF3545F  a849                              mov.l   4[r4], r1
FFF35461  a899                              mov.l   0Ch[r1], r1
FFF35463  7f11                              jsr     r1
FFF35465  6101                              cmp     #0, r1
FFF35467  200c                              beq.b   loc_FFF35473
FFF35469  f90603f9                          mov.l   #-7, 24h+var_18[sp]
FFF3546D  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF35471  2e79                              bra.b   loc_FFF354EA
FFF35473  a909                   loc_FFF35473 mov.l   24h+var_10[sp], r1
FFF35475  ec1e                              mov.l   [r1], r14
FFF35477  5eee6001                          movu.w  2C0h[r14], r14
FFF3547B  7c1e                              btst    #1, r14
FFF3547D  aa01                              mov.l   24h+var_4[sp], r1
FFF3547F  14                                beq.s   loc_FFF35483
FFF35480  a081                              mov.l   r1, 24h+var_1C[sp]
FFF35482  0d                                bra.s   loc_FFF35487
FFF35483  6c91                   loc_FFF35483 shll    #9, r1
FFF35485  a081                              mov.l   r1, 24h+var_1C[sp]
FFF35487  a909                   loc_FFF35487 mov.l   24h+var_10[sp], r1
FFF35489  39e3f1                            bsr.w   sub_FFF3466C
FFF3548C  a089                              mov.l   r1, 24h+var_18[sp]
FFF3548E  a889                              mov.l   24h+var_18[sp], r1
FFF35490  6101                              cmp     #0, r1
FFF35492  17                                beq.s   loc_FFF35499
FFF35493  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF35497  2e53                              bra.b   loc_FFF354EA
FFF35499  a909                   loc_FFF35499 mov.l   24h+var_10[sp], r1
FFF3549B  ec1e                              mov.l   [r1], r14
FFF3549D  5eee6101                          movu.w  2C2h[r14], r14
FFF354A1  612e                              cmp     #2, r14
FFF354A3  200d                              beq.b   loc_FFF354B0
FFF354A5  a909                              mov.l   24h+var_10[sp], r1
FFF354A7  ec1e                              mov.l   [r1], r14
FFF354A9  5eee6101                          movu.w  2C2h[r14], r14
FFF354AD  613e                              cmp     #3, r14
FFF354AF  1d                                bne.s   loc_FFF354B4
FFF354B0  f80601                 loc_FFF354B0 mov.l   #1, 24h+var_24[sp]
FFF354B3  0c                                bra.s   loc_FFF354B7
FFF354B4  f80600                 loc_FFF354B4 mov.l   #0, 24h+var_24[sp]
FFF354B7  ec01                   loc_FFF354B7 mov.l   24h+var_24[sp], r1
FFF354B9  6101                              cmp     #0, r1
FFF354BB  2019                              beq.b   loc_FFF354D4
FFF354BD  a90a                              mov.l   24h+var_10[sp], r2
FFF354BF  ec21                              mov.l   [r2], r1
FFF354C1  a82a                              mov.l   4[r2], r2
FFF354C3  ac22                              mov.l   40h[r2], r2
FFF354C5  7f12                              jsr     r2
FFF354C7  a089                              mov.l   r1, 24h+var_18[sp]
FFF354C9  a889                              mov.l   24h+var_18[sp], r1
FFF354CB  6101                              cmp     #0, r1
FFF354CD  17                                beq.s   loc_FFF354D4
FFF354CE  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF354D2  2e18                              bra.b   loc_FFF354EA
FFF354D4  a909                   loc_FFF354D4 mov.l   24h+var_10[sp], r1
FFF354D6  ec14                              mov.l   [r1], r4
FFF354D8  a819                              mov.l   4[r1], r1
FFF354DA  ae15                              mov.l   60h[r1], r5
FFF354DC  bb0b                              movu.w  24h+var_A[sp], r3
FFF354DE  a98a                              mov.l   24h+var_8[sp], r2
FFF354E0  a881                              mov.l   24h+var_1C[sp], r1
FFF354E2  7f15                              jsr     r5
FFF354E4  a089                              mov.l   r1, 24h+var_18[sp]
FFF354E6  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF354EA  a809                   loc_FFF354EA mov.l   24h+var_20[sp], r1
FFF354EC  a101                              mov.l   r1, 24h+var_14[sp]
FFF354EE  6709                              rtsd    #9

; ######## sub_FFF3365E  FFF3365E-FFF336DC (file 33365E) callers: FFF337EE(sub_FFF337D7), FFF33978(sub_FFF33961)
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

; ######## sub_FFF336DC  FFF336DC-FFF33739 (file 3336DC) callers: 
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

; ######## sub_FFF33760  FFF33760-FFF337D7 (file 333760) callers: 
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

; ######## sub_FFF337D7  FFF337D7-FFF338D7 (file 3337D7) callers: FFF33779(sub_FFF33760), FFF337AD(sub_FFF33760), FFF337C1(sub_FFF33760)
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
FFF337FE  fbee44ac08             loc_FFF337FE mov.l   #8AC44h, r14
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
FFF33891  fbee44ac08                        mov.l   #8AC44h, r14
FFF33896  ecef                              mov.l   [r14], r15
FFF33898  788f                              bset    #8, r15
FFF3389A  e3ef                              mov.l   r15, [r14]
FFF3389C  fbeeb0ad08                        mov.l   #8ADB0h, r14
FFF338A1  ecef                              mov.l   [r14], r15
FFF338A3  7a1f                              bclr    #1, r15
FFF338A5  e3ef                              mov.l   r15, [r14]
FFF338A7  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF338AA  2e27                              bra.b   loc_FFF338D1
FFF338AC  fbee44ac08             loc_FFF338AC mov.l   #8AC44h, r14
FFF338B1  ecef                              mov.l   [r14], r15
FFF338B3  788f                              bset    #8, r15
FFF338B5  e3ef                              mov.l   r15, [r14]
FFF338B7  fbeeb0ad08                        mov.l   #8ADB0h, r14
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

; ######## sub_FFF33961  FFF33961-FFF33A61 (file 333961) callers: FFF3394E(sub_FFF3393D)
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
FFF33988  fbee44ac08             loc_FFF33988 mov.l   #8AC44h, r14
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
FFF33A1B  fbee44ac08                        mov.l   #8AC44h, r14
FFF33A20  ecef                              mov.l   [r14], r15
FFF33A22  789f                              bset    #9, r15
FFF33A24  e3ef                              mov.l   r15, [r14]
FFF33A26  fbeeb0ad08                        mov.l   #8ADB0h, r14
FFF33A2B  ecef                              mov.l   [r14], r15
FFF33A2D  7a1f                              bclr    #1, r15
FFF33A2F  e3ef                              mov.l   r15, [r14]
FFF33A31  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF33A34  2e27                              bra.b   loc_FFF33A5B
FFF33A36  fbee44ac08             loc_FFF33A36 mov.l   #8AC44h, r14
FFF33A3B  ecef                              mov.l   [r14], r15
FFF33A3D  789f                              bset    #9, r15
FFF33A3F  e3ef                              mov.l   r15, [r14]
FFF33A41  fbeeb0ad08                        mov.l   #8ADB0h, r14
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

; ######## sub_FFF08201  FFF08201-FFF0878C (file 308201) callers: FFF00556(sub_FFF004C2)
FFF08201  7100e0                 sub_FFF08201 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF08201
FFF08204  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0820A  c5e0201f                          mov.b   20h[r14], 20h+var_1[sp]
FFF0820E  3d0e22                            mov.w   #22h, 20h+var_4[sp] ; '"'
FFF08211  3d0dd0                            mov.w   #-30h, 20h+var_6[sp]
FFF08214  3d0c41                            mov.w   #41h, 20h+var_8[sp] ; 'A'
FFF08217  3d0b06                            mov.w   #6, 20h+var_A[sp]
FFF0821A  3d0ab4                            mov.w   #-4Ch, 20h+var_C[sp]
FFF0821D  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF08223  b019                              movu.b  1[r1], r1
FFF08225  7551d4                            cmp     #-2Ch, r1
FFF08228  3a2105                            beq.w   loc_FFF08749
FFF0822B  7551d2                            cmp     #-2Eh, r1
FFF0822E  3aa801                            beq.w   loc_FFF083D6
FFF08231  7551d3                            cmp     #-2Dh, r1
FFF08234  3a3b03                            beq.w   loc_FFF0856F
FFF08237  7551d0                            cmp     #-30h, r1
FFF0823A  3b5005                            bne.w   loc_FFF0878A
FFF0823D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF08243  c5e0211f                          mov.b   21h[r14], 20h+var_1[sp]
FFF08247  b789                              movu.b  20h+var_1[sp], r1
FFF08249  6131                              cmp     #3, r1
FFF0824B  2905                              blt.b   loc_FFF08250
FFF0824D  3c8f02                            mov.b   #2, 20h+var_1[sp]
FFF08250  fbe2728f0000           loc_FFF08250 mov.l   #8F72h, r14
FFF08256  58ee                              movu.b  [r14], r14
FFF08258  610e                              cmp     #0, r14
FFF0825A  9b01                              mov.w   20h+var_8[sp], r1
FFF0825C  9b83                              mov.w   20h+var_4[sp], r3
FFF0825E  2117                              bne.b   loc_FFF08275
FFF08260  5f12                              movu.w  r1, r2
FFF08262  5f31                              movu.w  r3, r1
FFF08264  fb4284a4f4ff                      mov.l   #loc_FFF4A484, r4
FFF0826A  fb3e00a800                        mov.l   #0A800h, r3
FFF0826F  057825ff                          bsr.a   sub_FFEFA7E7
FFF08273  2e12                              bra.b   loc_FFF08285
FFF08275  5f12                   loc_FFF08275 movu.w  r1, r2
FFF08277  5f31                              movu.w  r3, r1
FFF08279  fb428da4f4ff                      mov.l   #loc_FFF4A48D, r4
FFF0827F  6603                              mov.l   #0, r3
FFF08281  056625ff                          bsr.a   sub_FFEFA7E7
FFF08285  fbe24d8c0000           loc_FFF08285 mov.l   #8C4Dh, r14
FFF0828B  59ee22                            movu.b  22h[r14], r14
FFF0828E  610e                              cmp     #0, r14
FFF08290  9b01                              mov.w   20h+var_8[sp], r1
FFF08292  9b0b                              mov.w   20h+var_6[sp], r3
FFF08294  2114                              bne.b   loc_FFF082A8
FFF08296  5f12                              movu.w  r1, r2
FFF08298  5f31                              movu.w  r3, r1
FFF0829A  fb4296a4f4ff                      mov.l   #unk_FFF4A496, r4
FFF082A0  6603                              mov.l   #0, r3
FFF082A2  054525ff                          bsr.a   sub_FFEFA7E7
FFF082A6  2e12                              bra.b   loc_FFF082B8
FFF082A8  5f12                   loc_FFF082A8 movu.w  r1, r2
FFF082AA  5f31                              movu.w  r3, r1
FFF082AC  fb429ea4f4ff                      mov.l   #unk_FFF4A49E, r4
FFF082B2  6603                              mov.l   #0, r3
FFF082B4  053325ff                          bsr.a   sub_FFEFA7E7
FFF082B8  bb01                   loc_FFF082B8 movu.w  20h+var_8[sp], r1
FFF082BA  711124                            add     #24h, r1, r1 ; '$'
FFF082BD  9301                              mov.w   r1, 20h+var_8[sp]
FFF082BF  fbe2728f0000                      mov.l   #8F72h, r14
FFF082C5  58ee                              movu.b  [r14], r14
FFF082C7  610e                              cmp     #0, r14
FFF082C9  9b01                              mov.w   20h+var_8[sp], r1
FFF082CB  9b83                              mov.w   20h+var_4[sp], r3
FFF082CD  2117                              bne.b   loc_FFF082E4
FFF082CF  5f12                              movu.w  r1, r2
FFF082D1  5f31                              movu.w  r3, r1
FFF082D3  fb42a6a4f4ff                      mov.l   #unk_FFF4A4A6, r4
FFF082D9  fb3e00a000                        mov.l   #0A000h, r3
FFF082DE  050925ff                          bsr.a   sub_FFEFA7E7
FFF082E2  2e12                              bra.b   loc_FFF082F4
FFF082E4  5f12                   loc_FFF082E4 movu.w  r1, r2
FFF082E6  5f31                              movu.w  r3, r1
FFF082E8  fb42afa4f4ff                      mov.l   #loc_FFF4A4AF, r4
FFF082EE  6603                              mov.l   #0, r3
FFF082F0  05f724ff                          bsr.a   sub_FFEFA7E7
FFF082F4  fbe24d8c0000           loc_FFF082F4 mov.l   #8C4Dh, r14
FFF082FA  59ee23                            movu.b  23h[r14], r14
FFF082FD  610e                              cmp     #0, r14
FFF082FF  2114                              bne.b   loc_FFF08313
FFF08301  bb02                              movu.w  20h+var_8[sp], r2
FFF08303  bb09                              movu.w  20h+var_6[sp], r1
FFF08305  fb428289f4ff                      mov.l   #(loc_FFF48980+2), r4
FFF0830B  6603                              mov.l   #0, r3
FFF0830D  05da24ff                          bsr.a   sub_FFEFA7E7
FFF08311  2e35                              bra.b   loc_FFF08346
FFF08313  fbe24d8c0000           loc_FFF08313 mov.l   #8C4Dh, r14
FFF08319  59ee23                            movu.b  23h[r14], r14
FFF0831C  611e                              cmp     #1, r14
FFF0831E  9b01                              mov.w   20h+var_8[sp], r1
FFF08320  9b0b                              mov.w   20h+var_6[sp], r3
FFF08322  2114                              bne.b   loc_FFF08336
FFF08324  5f12                              movu.w  r1, r2
FFF08326  5f31                              movu.w  r3, r1
FFF08328  fb424d8af4ff                      mov.l   #loc_FFF48A4D, r4
FFF0832E  6603                              mov.l   #0, r3
FFF08330  05b724ff                          bsr.a   sub_FFEFA7E7
FFF08334  2e12                              bra.b   loc_FFF08346
FFF08336  5f12                   loc_FFF08336 movu.w  r1, r2
FFF08338  5f31                              movu.w  r3, r1
FFF0833A  fb428689f4ff                      mov.l   #loc_FFF48986, r4
FFF08340  6603                              mov.l   #0, r3
FFF08342  05a524ff                          bsr.a   sub_FFEFA7E7
FFF08346  bb01                   loc_FFF08346 movu.w  20h+var_8[sp], r1
FFF08348  711124                            add     #24h, r1, r1 ; '$'
FFF0834B  9301                              mov.w   r1, 20h+var_8[sp]
FFF0834D  bb02                              movu.w  20h+var_8[sp], r2
FFF0834F  bb81                              movu.w  20h+var_4[sp], r1
FFF08351  fb42b8a4f4ff                      mov.l   #(loc_FFF4A4B6+2), r4
FFF08357  6603                              mov.l   #0, r3
FFF08359  058e24ff                          bsr.a   sub_FFEFA7E7
FFF0835D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF08363  59ee24                            movu.b  24h[r14], r14
FFF08366  610e                              cmp     #0, r14
FFF08368  9b01                              mov.w   20h+var_8[sp], r1
FFF0836A  9b0b                              mov.w   20h+var_6[sp], r3
FFF0836C  2114                              bne.b   loc_FFF08380
FFF0836E  5f12                              movu.w  r1, r2
FFF08370  5f31                              movu.w  r3, r1
FFF08372  fb42c1a4f4ff                      mov.l   #(loc_FFF4A4BF+2), r4
FFF08378  6603                              mov.l   #0, r3
FFF0837A  056d24ff                          bsr.a   sub_FFEFA7E7
FFF0837E  2e12                              bra.b   loc_FFF08390
FFF08380  5f12                   loc_FFF08380 movu.w  r1, r2
FFF08382  5f31                              movu.w  r3, r1
FFF08384  fb42c8a4f4ff                      mov.l   #(loc_FFF4A4C5+3), r4
FFF0838A  6603                              mov.l   #0, r3
FFF0838C  055b24ff                          bsr.a   sub_FFEFA7E7
FFF08390  b789                   loc_FFF08390 movu.b  20h+var_1[sp], r1
FFF08392  751124                            mul     #24h, r1 ; '$'
FFF08395  711141                            add     #41h, r1, r1 ; 'A'
FFF08398  9209                              mov.w   r1, 20h+var_E[sp]
FFF0839A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF083A0  59ee20                            movu.b  20h[r14], r14
FFF083A3  610e                              cmp     #0, r14
FFF083A5  2112                              bne.b   loc_FFF083B7
FFF083A7  ba0a                              movu.w  20h+var_E[sp], r2
FFF083A9  ba89                              movu.w  20h+var_A[sp], r1
FFF083AB  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF083B1  059782fe                          bsr.a   sub_FFEF0648
FFF083B5  2e10                              bra.b   loc_FFF083C5
FFF083B7  ba0a                   loc_FFF083B7 movu.w  20h+var_E[sp], r2
FFF083B9  ba81                              movu.w  20h+var_C[sp], r1
FFF083BB  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF083C1  058782fe                          bsr.a   sub_FFEF0648
FFF083C5  6621                   loc_FFF083C5 mov.l   #2, r1
FFF083C7  395f04                            bsr.w   sub_FFF08826
FFF083CA  6631                              mov.l   #3, r1
FFF083CC  395a04                            bsr.w   sub_FFF08826
FFF083CF  6641                              mov.l   #4, r1
FFF083D1  395504                            bsr.w   sub_FFF08826
FFF083D4  6708                              rtsd    #8
FFF083D6  3d0779                 loc_FFF083D6 mov.w   #79h, 20h+var_12[sp] ; 'y'
FFF083D9  058523ff                          bsr.a   sub_FFEFA75E
FFF083DD  3c0d00                            mov.b   #0, 20h+var_13[sp]
FFF083E0  2e32                              bra.b   loc_FFF08412
FFF083E2  fbe248920600           loc_FFF083E2 mov.l   #69248h, r14
FFF083E8  b309                              movu.b  20h+var_13[sp], r1
FFF083EA  fe61e4                            mov.l   [r1, r14], r4
FFF083ED  b989                              movu.w  20h+var_12[sp], r1
FFF083EF  6613                              mov.l   #1, r3
FFF083F1  6642                              mov.l   #4, r2
FFF083F3  05e2e4fe                          bsr.a   sub_FFEF68D5
FFF083F7  fbe248920600                      mov.l   #69248h, r14
FFF083FD  b309                              movu.b  20h+var_13[sp], r1
FFF083FF  fe61ee                            mov.l   [r1, r14], r14
FFF08402  5ce1                              movu.w  [r14], r1
FFF08404  06c90107                          add     20h+var_12[sp].uw, r1
FFF08408  6211                              add     #1, r1
FFF0840A  9189                              mov.w   r1, 20h+var_12[sp]
FFF0840C  b309                              movu.b  20h+var_13[sp], r1
FFF0840E  6211                              add     #1, r1
FFF08410  8309                              mov.b   r1, 20h+var_13[sp]
FFF08412  b309                   loc_FFF08412 movu.b  20h+var_13[sp], r1
FFF08414  6161                              cmp     #6, r1
FFF08416  29cc                              blt.b   loc_FFF083E2
FFF08418  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0841E  c5e0201f                          mov.b   20h[r14], 20h+var_1[sp]
FFF08422  b789                              movu.b  20h+var_1[sp], r1
FFF08424  6121                              cmp     #2, r1
FFF08426  2905                              blt.b   loc_FFF0842B
FFF08428  3c8f01                            mov.b   #1, 20h+var_1[sp]
FFF0842B  b789                   loc_FFF0842B movu.b  20h+var_1[sp], r1
FFF0842D  6101                              cmp     #0, r1
FFF0842F  9b01                              mov.w   20h+var_8[sp], r1
FFF08431  9b83                              mov.w   20h+var_4[sp], r3
FFF08433  2115                              bne.b   loc_FFF08448
FFF08435  5f12                              movu.w  r1, r2
FFF08437  5f31                              movu.w  r3, r1
FFF08439  fb42dd86f4ff                      mov.l   #loc_FFF486DD, r4
FFF0843F  6603                              mov.l   #0, r3
FFF08441  05a623ff                          bsr.a   sub_FFEFA7E7
FFF08445  381101                            bra.w   loc_FFF08556
FFF08448  5f12                   loc_FFF08448 movu.w  r1, r2
FFF0844A  5f31                              movu.w  r3, r1
FFF0844C  fb428787f4ff                      mov.l   #(loc_FFF48785+2), r4
FFF08452  6603                              mov.l   #0, r3
FFF08454  059323ff                          bsr.a   sub_FFEFA7E7
FFF08458  fbe2728f0000                      mov.l   #8F72h, r14
FFF0845E  58ee                              movu.b  [r14], r14
FFF08460  610e                              cmp     #0, r14
FFF08462  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF08468  59ee21                            movu.b  21h[r14], r14
FFF0846B  215f                              bne.b   loc_FFF084CA
FFF0846D  613e                              cmp     #3, r14
FFF0846F  203c                              beq.b   loc_FFF084AB
FFF08471  71efff                            add     #-1, r14, r15
FFF08474  612f                              cmp     #2, r15
FFF08476  231e                              bltu.b  loc_FFF08494
FFF08478  610e                              cmp     #0, r14
FFF0847A  3bba00                            bne.w   loc_FFF08534
FFF0847D  bb81                              movu.w  20h+var_4[sp], r1
FFF0847F  fb42cfa4f4ff                      mov.l   #loc_FFF4A4CF, r4
FFF08485  fb3e00aa00                        mov.l   #0AA00h, r3
FFF0848A  754265                            mov.l   #65h, r2 ; 'e'
FFF0848D  055a23ff                          bsr.a   sub_FFEFA7E7
FFF08491  38a300                            bra.w   loc_FFF08534
FFF08494  bb81                   loc_FFF08494 movu.w  20h+var_4[sp], r1
FFF08496  fb42d8a4f4ff                      mov.l   #loc_FFF4A4D8, r4
FFF0849C  fb3e00a800                        mov.l   #0A800h, r3
FFF084A1  754265                            mov.l   #65h, r2 ; 'e'
FFF084A4  054323ff                          bsr.a   sub_FFEFA7E7
FFF084A8  388c00                            bra.w   loc_FFF08534
FFF084AB  05477efe               loc_FFF084AB bsr.a   sub_FFEF02F2
FFF084AF  6101                              cmp     #0, r1
FFF084B1  3a8300                            beq.w   loc_FFF08534
FFF084B4  bb81                              movu.w  20h+var_4[sp], r1
FFF084B6  fb42dfa4f4ff                      mov.l   #(loc_FFF4A4DC+3), r4
FFF084BC  fb3e00a800                        mov.l   #0A800h, r3
FFF084C1  754265                            mov.l   #65h, r2 ; 'e'
FFF084C4  052323ff                          bsr.a   sub_FFEFA7E7
FFF084C8  2e6c                              bra.b   loc_FFF08534
FFF084CA  613e                   loc_FFF084CA cmp     #3, r14
FFF084CC  2041                              beq.b   loc_FFF0850D
FFF084CE  71efff                            add     #-1, r14, r15
FFF084D1  612f                              cmp     #2, r15
FFF084D3  2319                              bltu.b  loc_FFF084EC
FFF084D5  610e                              cmp     #0, r14
FFF084D7  215d                              bne.b   loc_FFF08534
FFF084D9  bb81                              movu.w  20h+var_4[sp], r1
FFF084DB  fb42e6a4f4ff                      mov.l   #loc_FFF4A4E6, r4
FFF084E1  6603                              mov.l   #0, r3
FFF084E3  754265                            mov.l   #65h, r2 ; 'e'
FFF084E6  050123ff                          bsr.a   sub_FFEFA7E7
FFF084EA  2e4a                              bra.b   loc_FFF08534
FFF084EC  bb81                   loc_FFF084EC movu.w  20h+var_4[sp], r1
FFF084EE  60c0                              sub     #0Ch, sp
FFF084F0  fb22f0a4f4ff                      mov.l   #loc_FFF4A4F0, r2
FFF084F6  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF084F8  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF084FB  f8040d                            mov.b   #0Dh, 2Ch+var_2C[sp]
FFF084FE  6604                              mov.l   #0, r4
FFF08500  66d3                              mov.l   #0Dh, r3
FFF08502  754265                            mov.l   #65h, r2 ; 'e'
FFF08505  051e96fe                          bsr.a   sub_FFEF1B23
FFF08509  62c0                              add     #0Ch, sp
FFF0850B  2e29                              bra.b   loc_FFF08534
FFF0850D  05e57dfe               loc_FFF0850D bsr.a   sub_FFEF02F2
FFF08511  6101                              cmp     #0, r1
FFF08513  2021                              beq.b   loc_FFF08534
FFF08515  bb81                              movu.w  20h+var_4[sp], r1
FFF08517  60c0                              sub     #0Ch, sp
FFF08519  fb22fea4f4ff                      mov.l   #loc_FFF4A4FE, r2
FFF0851F  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF08521  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF08524  f8040a                            mov.b   #0Ah, 2Ch+var_2C[sp]
FFF08527  6604                              mov.l   #0, r4
FFF08529  66d3                              mov.l   #0Dh, r3
FFF0852B  754265                            mov.l   #65h, r2 ; 'e'
FFF0852E  05f595fe                          bsr.a   sub_FFEF1B23
FFF08532  62c0                              add     #0Ch, sp
FFF08534  bb81                   loc_FFF08534 movu.w  20h+var_4[sp], r1
FFF08536  60c0                              sub     #0Ch, sp
FFF08538  fb224d8c0000                      mov.l   #8C4Dh, r2
FFF0853E  712222                            add     #22h, r2, r2 ; '"'
FFF08541  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF08543  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF08546  f80410                            mov.b   #10h, 2Ch+var_2C[sp]
FFF08549  6604                              mov.l   #0, r4
FFF0854B  66d3                              mov.l   #0Dh, r3
FFF0854D  754289                            mov.l   #-77h, r2
FFF08550  05d395fe                          bsr.a   sub_FFEF1B23
FFF08554  62c0                              add     #0Ch, sp
FFF08556  055380ff               loc_FFF08556 bsr.a   sub_FFF005A9
FFF0855A  bb02                              movu.w  20h+var_8[sp], r2
FFF0855C  ba89                              movu.w  20h+var_A[sp], r1
FFF0855E  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF08564  05e480fe                          bsr.a   sub_FFEF0648
FFF08568  6621                              mov.l   #2, r1
FFF0856A  39bc02                            bsr.w   sub_FFF08826
FFF0856D  6708                              rtsd    #8
FFF0856F  3d0552                 loc_FFF0856F mov.w   #52h, 20h+var_16[sp] ; 'R'
FFF08572  05ec21ff                          bsr.a   sub_FFEFA75E
FFF08576  3c0900                            mov.b   #0, 20h+var_17[sp]
FFF08579  2e32                              bra.b   loc_FFF085AB
FFF0857B  fbe2f8900600           loc_FFF0857B mov.l   #690F8h, r14
FFF08581  b209                              movu.b  20h+var_17[sp], r1
FFF08583  fe61e4                            mov.l   [r1, r14], r4
FFF08586  b909                              movu.w  20h+var_16[sp], r1
FFF08588  6613                              mov.l   #1, r3
FFF0858A  6642                              mov.l   #4, r2
FFF0858C  0549e3fe                          bsr.a   sub_FFEF68D5
FFF08590  fbe2f8900600                      mov.l   #690F8h, r14
FFF08596  b209                              movu.b  20h+var_17[sp], r1
FFF08598  fe61ee                            mov.l   [r1, r14], r14
FFF0859B  5ce1                              movu.w  [r14], r1
FFF0859D  06c90105                          add     20h+var_16[sp].uw, r1
FFF085A1  6211                              add     #1, r1
FFF085A3  9109                              mov.w   r1, 20h+var_16[sp]
FFF085A5  b209                              movu.b  20h+var_17[sp], r1
FFF085A7  6211                              add     #1, r1
FFF085A9  8209                              mov.b   r1, 20h+var_17[sp]
FFF085AB  b209                   loc_FFF085AB movu.b  20h+var_17[sp], r1
FFF085AD  61b1                              cmp     #0Bh, r1
FFF085AF  29cc                              blt.b   loc_FFF0857B
FFF085B1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF085B7  c5e02011                          mov.b   20h[r14], 20h+var_F[sp]
FFF085BB  3d0306                            mov.w   #6, 20h+var_1A[sp]
FFF085BE  3d0219                            mov.w   #19h, 20h+var_1C[sp]
FFF085C1  3d011f                            mov.w   #1Fh, 20h+var_1E[sp]
FFF085C4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF085CA  c5e02101                          mov.b   21h[r14], 20h+var_1F[sp]
FFF085CE  3c8000                            mov.b   #0, 20h+var_10[sp]
FFF085D1  381201                            bra.w   loc_FFF086E3
FFF085D4  b401                   loc_FFF085D4 movu.b  20h+var_10[sp], r1
FFF085D6  6101                              cmp     #0, r1
FFF085D8  fcdbe0                            sceq.l  r14
FFF085DB  450111                            cmp     20h+var_F[sp], r1
FFF085DE  2156                              bne.b   loc_FFF08634
FFF085E0  5bee                              movu.b  r14, r14
FFF085E2  610e                              cmp     #0, r14
FFF085E4  2029                              beq.b   loc_FFF0860D
FFF085E6  b80c                              movu.w  20h+var_1E[sp], r4
FFF085E8  ef4e                              mov.l   r4, r14
FFF085EA  4d0e10                            mul     20h+var_10[sp], r14
FFF085ED  06c90e02                          add     20h+var_1C[sp].uw, r14
FFF085F1  b889                              movu.w  20h+var_1A[sp], r1
FFF085F3  6040                              sub     #4, sp
FFF085F5  f80980f9                          mov.w   #-680h, 24h+var_24[sp]
FFF085F9  fbfa3301                          mov.l   #133h, r15
FFF085FD  431f                              sub     r1, r15
FFF085FF  5ff3                              movu.w  r15, r3
FFF08601  621e                              add     #1, r14
FFF08603  5fe2                              movu.w  r14, r2
FFF08605  054396fe                          bsr.a   sub_FFEF1C48
FFF08609  6240                              add     #4, sp
FFF0860B  2e79                              bra.b   loc_FFF08684
FFF0860D  b80c                   loc_FFF0860D movu.w  20h+var_1E[sp], r4
FFF0860F  ef4e                              mov.l   r4, r14
FFF08611  4d0e10                            mul     20h+var_10[sp], r14
FFF08614  06c90e02                          add     20h+var_1C[sp].uw, r14
FFF08618  b889                              movu.w  20h+var_1A[sp], r1
FFF0861A  6040                              sub     #4, sp
FFF0861C  f80980f9                          mov.w   #-680h, 24h+var_24[sp]
FFF08620  fbfa3301                          mov.l   #133h, r15
FFF08624  431f                              sub     r1, r15
FFF08626  5ff3                              movu.w  r15, r3
FFF08628  622e                              add     #2, r14
FFF0862A  5fe2                              movu.w  r14, r2
FFF0862C  051c96fe                          bsr.a   sub_FFEF1C48
FFF08630  6240                              add     #4, sp
FFF08632  2e52                              bra.b   loc_FFF08684
FFF08634  5bee                   loc_FFF08634 movu.b  r14, r14
FFF08636  610e                              cmp     #0, r14
FFF08638  2028                              beq.b   loc_FFF08660
FFF0863A  b80c                              movu.w  20h+var_1E[sp], r4
FFF0863C  ef4e                              mov.l   r4, r14
FFF0863E  4d0e10                            mul     20h+var_10[sp], r14
FFF08641  06c90e02                          add     20h+var_1C[sp].uw, r14
FFF08645  b889                              movu.w  20h+var_1A[sp], r1
FFF08647  6040                              sub     #4, sp
FFF08649  f80500                            mov.w   #0, 24h+var_24[sp]
FFF0864C  fbfa3301                          mov.l   #133h, r15
FFF08650  431f                              sub     r1, r15
FFF08652  5ff3                              movu.w  r15, r3
FFF08654  621e                              add     #1, r14
FFF08656  5fe2                              movu.w  r14, r2
FFF08658  05f095fe                          bsr.a   sub_FFEF1C48
FFF0865C  6240                              add     #4, sp
FFF0865E  2e26                              bra.b   loc_FFF08684
FFF08660  b80c                   loc_FFF08660 movu.w  20h+var_1E[sp], r4
FFF08662  ef4e                              mov.l   r4, r14
FFF08664  4d0e10                            mul     20h+var_10[sp], r14
FFF08667  06c90e02                          add     20h+var_1C[sp].uw, r14
FFF0866B  b889                              movu.w  20h+var_1A[sp], r1
FFF0866D  6040                              sub     #4, sp
FFF0866F  f80500                            mov.w   #0, 24h+var_24[sp]
FFF08672  fbfa3301                          mov.l   #133h, r15
FFF08676  431f                              sub     r1, r15
FFF08678  5ff3                              movu.w  r15, r3
FFF0867A  622e                              add     #2, r14
FFF0867C  5fe2                              movu.w  r14, r2
FFF0867E  05ca95fe                          bsr.a   sub_FFEF1C48
FFF08682  6240                              add     #4, sp
FFF08684  b401                   loc_FFF08684 movu.b  20h+var_10[sp], r1
FFF08686  fdc41e                            shll    #4, r1, r14
FFF08689  fb224d8c0000                      mov.l   #8C4Dh, r2
FFF0868F  4be2                              add     r14, r2
FFF08691  712222                            add     #22h, r2, r2 ; '"'
FFF08694  ef1e                              mov.l   r1, r14
FFF08696  06cd0e01                          mul     20h+var_1E[sp].uw, r14
FFF0869A  71ee1d                            add     #1Dh, r14, r14
FFF0869D  b00b                              movu.b  20h+var_1F[sp], r3
FFF0869F  fc6b31                            btst    r1, r3
FFF086A2  9889                              mov.w   20h+var_1A[sp], r1
FFF086A4  2021                              beq.b   loc_FFF086C5
FFF086A6  60c0                              sub     #0Ch, sp
FFF086A8  f90905ef7b                        mov.w   #7BEFh, 2Ch+var_22[sp]
FFF086AD  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF086B0  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF086B2  f80410                            mov.b   #10h, 2Ch+var_2C[sp]
FFF086B5  5fe2                              movu.w  r14, r2
FFF086B7  5f11                              movu.w  r1, r1
FFF086B9  6604                              mov.l   #0, r4
FFF086BB  66d3                              mov.l   #0Dh, r3
FFF086BD  05f494fe                          bsr.a   sub_FFEF1BB1
FFF086C1  62c0                              add     #0Ch, sp
FFF086C3  2e1a                              bra.b   loc_FFF086DD
FFF086C5  60c0                   loc_FFF086C5 sub     #0Ch, sp
FFF086C7  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF086CA  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF086CC  f80410                            mov.b   #10h, 2Ch+var_2C[sp]
FFF086CF  5fe2                              movu.w  r14, r2
FFF086D1  5f11                              movu.w  r1, r1
FFF086D3  6604                              mov.l   #0, r4
FFF086D5  66d3                              mov.l   #0Dh, r3
FFF086D7  054c94fe                          bsr.a   sub_FFEF1B23
FFF086DB  62c0                              add     #0Ch, sp
FFF086DD  b401                   loc_FFF086DD movu.b  20h+var_10[sp], r1
FFF086DF  6211                              add     #1, r1
FFF086E1  8401                              mov.b   r1, 20h+var_10[sp]
FFF086E3  b401                   loc_FFF086E3 movu.b  20h+var_10[sp], r1
FFF086E5  6151                              cmp     #5, r1
FFF086E7  2805                              bge.b   loc_FFF086EC
FFF086E9  38ebfe                            bra.w   loc_FFF085D4
FFF086EC  3c8001                 loc_FFF086EC mov.b   #1, 20h+var_10[sp]
FFF086EF  2e2e                              bra.b   loc_FFF0871D
FFF086F1  b402                   loc_FFF086F1 movu.b  20h+var_10[sp], r2
FFF086F3  06cd0201                          mul     20h+var_1E[sp].uw, r2
FFF086F7  06c90202                          add     20h+var_1C[sp].uw, r2
FFF086FB  b889                              movu.w  20h+var_1A[sp], r1
FFF086FD  6040                              sub     #4, sp
FFF086FF  f80995ad                          mov.w   #-526Bh, 24h+var_24[sp]
FFF08703  fbea3301                          mov.l   #133h, r14
FFF08707  431e                              sub     r1, r14
FFF08709  5fe3                              movu.w  r14, r3
FFF0870B  6212                              add     #1, r2
FFF0870D  5f22                              movu.w  r2, r2
FFF0870F  6614                              mov.l   #1, r4
FFF08711  053795fe                          bsr.a   sub_FFEF1C48
FFF08715  6240                              add     #4, sp
FFF08717  b401                              movu.b  20h+var_10[sp], r1
FFF08719  6211                              add     #1, r1
FFF0871B  8401                              mov.b   r1, 20h+var_10[sp]
FFF0871D  b401                   loc_FFF0871D movu.b  20h+var_10[sp], r1
FFF0871F  6151                              cmp     #5, r1
FFF08721  29d0                              blt.b   loc_FFF086F1
FFF08723  05867eff                          bsr.a   sub_FFF005A9
FFF08727  b882                              movu.w  20h+var_1C[sp], r2
FFF08729  6040                              sub     #4, sp
FFF0872B  3c0200                            mov.b   #0, 24h+var_22[sp]
FFF0872E  3c0101                            mov.b   #1, 24h+var_23[sp]
FFF08731  f80401                            mov.b   #1, 24h+var_24[sp]
FFF08734  754eb7                            mov.l   #-49h, r14
FFF08737  432e                              sub     r2, r14
FFF08739  5fe4                              movu.w  r14, r4
FFF0873B  6663                              mov.l   #6, r3
FFF0873D  fb1a3701                          mov.l   #137h, r1
FFF08741  05ea22ff                          bsr.a   sub_FFEFAA2B
FFF08745  6240                              add     #4, sp
FFF08747  6708                              rtsd    #8
FFF08749  b789                   loc_FFF08749 movu.b  20h+var_1[sp], r1
FFF0874B  6101                              cmp     #0, r1
FFF0874D  9b01                              mov.w   20h+var_8[sp], r1
FFF0874F  9b83                              mov.w   20h+var_4[sp], r3
FFF08751  2114                              bne.b   loc_FFF08765
FFF08753  5f12                              movu.w  r1, r2
FFF08755  5f31                              movu.w  r3, r1
FFF08757  fb42dd86f4ff                      mov.l   #loc_FFF486DD, r4
FFF0875D  6603                              mov.l   #0, r3
FFF0875F  058820ff                          bsr.a   sub_FFEFA7E7
FFF08763  2e12                              bra.b   loc_FFF08775
FFF08765  5f12                   loc_FFF08765 movu.w  r1, r2
FFF08767  5f31                              movu.w  r3, r1
FFF08769  fb428787f4ff                      mov.l   #(loc_FFF48785+2), r4
FFF0876F  6603                              mov.l   #0, r3
FFF08771  057620ff                          bsr.a   sub_FFEFA7E7
FFF08775  bb02                   loc_FFF08775 movu.w  20h+var_8[sp], r2
FFF08777  ba89                              movu.w  20h+var_A[sp], r1
FFF08779  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF0877F  05c97efe                          bsr.a   sub_FFEF0648
FFF08783  6621                              mov.l   #2, r1
FFF08785  39a100                            bsr.w   sub_FFF08826
FFF08788  6708                              rtsd    #8
FFF0878A  6708                   loc_FFF0878A rtsd    #8

; ######## sub_FFF35D0B  FFF35D0B-FFF35F1A (file 335D0B) callers: FFF3694B(sub_FFF368FF)
FFF35D0B  7ea6                   sub_FFF35D0B push.l  r6   ; <<<< FUNC sub_FFF35D0B
FFF35D0D  7100e8                            add     #-18h, sp, sp
FFF35D10  a109                              mov.l   r1, 18h+var_4[sp]
FFF35D12  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF35D15  a909                              mov.l   18h+var_4[sp], r1
FFF35D17  ec11                              mov.l   [r1], r1
FFF35D19  7211c802                          add     #2C8h, r1, r1
FFF35D1D  a009                              mov.l   r1, 18h+var_14[sp]
FFF35D1F  a909                              mov.l   18h+var_4[sp], r1
FFF35D21  ec11                              mov.l   [r1], r1
FFF35D23  6211                              add     #1, r1
FFF35D25  fb3a0002                          mov.l   #200h, r3
FFF35D29  6602                              mov.l   #0, r2
FFF35D2B  ef24                              mov.l   r2, r4
FFF35D2D  058287ff                          bsr.a   sub_FFF2E4AF
FFF35D31  a909                              mov.l   18h+var_4[sp], r1
FFF35D33  ec11                              mov.l   [r1], r1
FFF35D35  6211                              add     #1, r1
FFF35D37  a80a                              mov.l   18h+var_14[sp], r2
FFF35D39  8d22                              mov.b   14h[r2], r2
FFF35D3B  755220                            cmp     #20h, r2 ; ' '
FFF35D3E  3af100                            beq.w   loc_FFF35E2F
FFF35D41  75433e                            mov.l   #3Eh, r3 ; '>'
FFF35D44  fb22a3e8c3ff                      mov.l   #unk_FFC3E8A3, r2
FFF35D4A  052e87ff                          bsr.a   sub_FFF2E478
FFF35D4E  a809                              mov.l   18h+var_14[sp], r1
FFF35D50  ba1a                              movu.w  12h[r1], r2
FFF35D52  a909                              mov.l   18h+var_4[sp], r1
FFF35D54  ec11                              mov.l   [r1], r1
FFF35D56  62c1                              add     #0Ch, r1
FFF35D58  05298fff                          bsr.a   sub_FFF2EC81
FFF35D5C  a809                              mov.l   18h+var_14[sp], r1
FFF35D5E  a90a                              mov.l   18h+var_4[sp], r2
FFF35D60  ec2e                              mov.l   [r2], r14
FFF35D62  c51e100e                          mov.b   10h[r1], 0Eh[r14]
FFF35D66  a809                              mov.l   18h+var_14[sp], r1
FFF35D68  bb92                              movu.w  1Ch[r1], r2
FFF35D6A  a909                              mov.l   18h+var_4[sp], r1
FFF35D6C  ec11                              mov.l   [r1], r1
FFF35D6E  62f1                              add     #0Fh, r1
FFF35D70  05118fff                          bsr.a   sub_FFF2EC81
FFF35D74  a809                              mov.l   18h+var_14[sp], r1
FFF35D76  bb12                              movu.w  18h[r1], r2
FFF35D78  a909                              mov.l   18h+var_4[sp], r1
FFF35D7A  ec11                              mov.l   [r1], r1
FFF35D7C  711117                            add     #17h, r1, r1
FFF35D7F  05028fff                          bsr.a   sub_FFF2EC81
FFF35D83  a809                              mov.l   18h+var_14[sp], r1
FFF35D85  5c12                              movu.w  [r1], r2
FFF35D87  a909                              mov.l   18h+var_4[sp], r1
FFF35D89  ec11                              mov.l   [r1], r1
FFF35D8B  711119                            add     #19h, r1, r1
FFF35D8E  05f38eff                          bsr.a   sub_FFF2EC81
FFF35D92  a809                              mov.l   18h+var_14[sp], r1
FFF35D94  b81a                              movu.w  2[r1], r2
FFF35D96  a909                              mov.l   18h+var_4[sp], r1
FFF35D98  ec11                              mov.l   [r1], r1
FFF35D9A  71111b                            add     #1Bh, r1, r1
FFF35D9D  05e48eff                          bsr.a   sub_FFF2EC81
FFF35DA1  a809                              mov.l   18h+var_14[sp], r1
FFF35DA3  a892                              mov.l   8[r1], r2
FFF35DA5  a909                              mov.l   18h+var_4[sp], r1
FFF35DA7  ec11                              mov.l   [r1], r1
FFF35DA9  71111d                            add     #1Dh, r1, r1
FFF35DAC  05278fff                          bsr.a   sub_FFF2ECD3
FFF35DB0  a909                              mov.l   18h+var_4[sp], r1
FFF35DB2  ec11                              mov.l   [r1], r1
FFF35DB4  6211                              add     #1, r1
FFF35DB6  a80a                              mov.l   18h+var_14[sp], r2
FFF35DB8  a8aa                              mov.l   0Ch[r2], r2
FFF35DBA  7702ffff00                        cmp     #0FFFFh, r2
FFF35DBF  240f                              bgtu.b  loc_FFF35DCE
FFF35DC1  a80a                              mov.l   18h+var_14[sp], r2
FFF35DC3  b9a2                              movu.w  0Ch[r2], r2
FFF35DC5  711113                            add     #13h, r1, r1
FFF35DC8  05b98eff                          bsr.a   sub_FFF2EC81
FFF35DCC  2e0d                              bra.b   loc_FFF35DD9
FFF35DCE  a80a                   loc_FFF35DCE mov.l   18h+var_14[sp], r2
FFF35DD0  a8aa                              mov.l   0Ch[r2], r2
FFF35DD2  711120                            add     #20h, r1, r1 ; ' '
FFF35DD5  05fe8eff                          bsr.a   sub_FFF2ECD3
FFF35DD9  a909                   loc_FFF35DD9 mov.l   18h+var_4[sp], r1
FFF35DDB  ec16                              mov.l   [r1], r6
FFF35DDD  39c6fe                            bsr.w   sub_FFF35CA3
FFF35DE0  ef12                              mov.l   r1, r2
FFF35DE2  ef61                              mov.l   r6, r1
FFF35DE4  711128                            add     #28h, r1, r1 ; '('
FFF35DE7  05ec8eff                          bsr.a   sub_FFF2ECD3
FFF35DEB  a809                              mov.l   18h+var_14[sp], r1
FFF35DED  8d11                              mov.b   14h[r1], r1
FFF35DEF  61c1                              cmp     #0Ch, r1
FFF35DF1  19                                bne.s   loc_FFF35DFA
FFF35DF2  a909                              mov.l   18h+var_4[sp], r1
FFF35DF4  ec1e                              mov.l   [r1], r14
FFF35DF6  f9e43b32                          mov.b   #32h, 3Bh[r14] ; '2'
FFF35DFA  a909                   loc_FFF35DFA mov.l   18h+var_4[sp], r1
FFF35DFC  ec1e                              mov.l   [r1], r14
FFF35DFE  fae4ff0155                        mov.b   #55h, 1FFh[r14] ; 'U'
FFF35E03  a909                              mov.l   18h+var_4[sp], r1
FFF35E05  ec1e                              mov.l   [r1], r14
FFF35E07  fae40002aa                        mov.b   #-56h, 200h[r14]
FFF35E0C  a809                              mov.l   18h+var_14[sp], r1
FFF35E0E  e5100202                          mov.l   8[r1], 18h+var_10[sp]
FFF35E12  a90c                              mov.l   18h+var_4[sp], r4
FFF35E14  ec42                              mov.l   [r4], r2
FFF35E16  a881                              mov.l   18h+var_10[sp], r1
FFF35E18  6212                              add     #1, r2
FFF35E1A  6613                              mov.l   #1, r3
FFF35E1C  0538f6ff                          bsr.a   sub_FFF35454
FFF35E20  a089                              mov.l   r1, 18h+var_C[sp]
FFF35E22  a889                              mov.l   18h+var_C[sp], r1
FFF35E24  6101                              cmp     #0, r1
FFF35E26  3aea00                            beq.w   loc_FFF35F10
FFF35E29  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35E2C  38e700                            bra.w   loc_FFF35F13
FFF35E2F  75435a                 loc_FFF35E2F mov.l   #5Ah, r3 ; 'Z'
FFF35E32  fb22e1e8c3ff                      mov.l   #unk_FFC3E8E1, r2
FFF35E38  054086ff                          bsr.a   sub_FFF2E478
FFF35E3C  a809                              mov.l   18h+var_14[sp], r1
FFF35E3E  ba1a                              movu.w  12h[r1], r2
FFF35E40  a909                              mov.l   18h+var_4[sp], r1
FFF35E42  ec11                              mov.l   [r1], r1
FFF35E44  62c1                              add     #0Ch, r1
FFF35E46  053b8eff                          bsr.a   sub_FFF2EC81
FFF35E4A  a809                              mov.l   18h+var_14[sp], r1
FFF35E4C  a90a                              mov.l   18h+var_4[sp], r2
FFF35E4E  ec2e                              mov.l   [r2], r14
FFF35E50  c51e100e                          mov.b   10h[r1], 0Eh[r14]
FFF35E54  a809                              mov.l   18h+var_14[sp], r1
FFF35E56  bb92                              movu.w  1Ch[r1], r2
FFF35E58  a909                              mov.l   18h+var_4[sp], r1
FFF35E5A  ec11                              mov.l   [r1], r1
FFF35E5C  62f1                              add     #0Fh, r1
FFF35E5E  05238eff                          bsr.a   sub_FFF2EC81
FFF35E62  a809                              mov.l   18h+var_14[sp], r1
FFF35E64  5c12                              movu.w  [r1], r2
FFF35E66  a909                              mov.l   18h+var_4[sp], r1
FFF35E68  ec11                              mov.l   [r1], r1
FFF35E6A  711119                            add     #19h, r1, r1
FFF35E6D  05148eff                          bsr.a   sub_FFF2EC81
FFF35E71  a809                              mov.l   18h+var_14[sp], r1
FFF35E73  b81a                              movu.w  2[r1], r2
FFF35E75  a909                              mov.l   18h+var_4[sp], r1
FFF35E77  ec11                              mov.l   [r1], r1
FFF35E79  71111b                            add     #1Bh, r1, r1
FFF35E7C  05058eff                          bsr.a   sub_FFF2EC81
FFF35E80  a809                              mov.l   18h+var_14[sp], r1
FFF35E82  a892                              mov.l   8[r1], r2
FFF35E84  a909                              mov.l   18h+var_4[sp], r1
FFF35E86  ec11                              mov.l   [r1], r1
FFF35E88  71111d                            add     #1Dh, r1, r1
FFF35E8B  05488eff                          bsr.a   sub_FFF2ECD3
FFF35E8F  a809                              mov.l   18h+var_14[sp], r1
FFF35E91  a89a                              mov.l   0Ch[r1], r2
FFF35E93  a909                              mov.l   18h+var_4[sp], r1
FFF35E95  ec11                              mov.l   [r1], r1
FFF35E97  711121                            add     #21h, r1, r1 ; '!'
FFF35E9A  05398eff                          bsr.a   sub_FFF2ECD3
FFF35E9E  a809                              mov.l   18h+var_14[sp], r1
FFF35EA0  a992                              mov.l   18h[r1], r2
FFF35EA2  a909                              mov.l   18h+var_4[sp], r1
FFF35EA4  ec11                              mov.l   [r1], r1
FFF35EA6  711125                            add     #25h, r1, r1 ; '%'
FFF35EA9  052a8eff                          bsr.a   sub_FFF2ECD3
FFF35EAD  a909                              mov.l   18h+var_4[sp], r1
FFF35EAF  ec16                              mov.l   [r1], r6
FFF35EB1  39f2fd                            bsr.w   sub_FFF35CA3
FFF35EB4  ef12                              mov.l   r1, r2
FFF35EB6  ef61                              mov.l   r6, r1
FFF35EB8  711144                            add     #44h, r1, r1 ; 'D'
FFF35EBB  05188eff                          bsr.a   sub_FFF2ECD3
FFF35EBF  a909                              mov.l   18h+var_4[sp], r1
FFF35EC1  ec1e                              mov.l   [r1], r14
FFF35EC3  fae4ff0155                        mov.b   #55h, 1FFh[r14] ; 'U'
FFF35EC8  a909                              mov.l   18h+var_4[sp], r1
FFF35ECA  ec1e                              mov.l   [r1], r14
FFF35ECC  fae40002aa                        mov.b   #-56h, 200h[r14]
FFF35ED1  a809                              mov.l   18h+var_14[sp], r1
FFF35ED3  e5100202                          mov.l   8[r1], 18h+var_10[sp]
FFF35ED7  a90c                              mov.l   18h+var_4[sp], r4
FFF35ED9  ec42                              mov.l   [r4], r2
FFF35EDB  a881                              mov.l   18h+var_10[sp], r1
FFF35EDD  6212                              add     #1, r2
FFF35EDF  6613                              mov.l   #1, r3
FFF35EE1  0573f5ff                          bsr.a   sub_FFF35454
FFF35EE5  a089                              mov.l   r1, 18h+var_C[sp]
FFF35EE7  a889                              mov.l   18h+var_C[sp], r1
FFF35EE9  6101                              cmp     #0, r1
FFF35EEB  16                                beq.s   loc_FFF35EF1
FFF35EEC  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35EEF  2e24                              bra.b   loc_FFF35F13
FFF35EF1  a881                   loc_FFF35EF1 mov.l   18h+var_10[sp], r1
FFF35EF3  6261                              add     #6, r1
FFF35EF5  a081                              mov.l   r1, 18h+var_10[sp]
FFF35EF7  a90c                              mov.l   18h+var_4[sp], r4
FFF35EF9  ec42                              mov.l   [r4], r2
FFF35EFB  a881                              mov.l   18h+var_10[sp], r1
FFF35EFD  6212                              add     #1, r2
FFF35EFF  6613                              mov.l   #1, r3
FFF35F01  0553f5ff                          bsr.a   sub_FFF35454
FFF35F05  a089                              mov.l   r1, 18h+var_C[sp]
FFF35F07  a889                              mov.l   18h+var_C[sp], r1
FFF35F09  6101                              cmp     #0, r1
FFF35F0B  15                                beq.s   loc_FFF35F10
FFF35F0C  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35F0F  0c                                bra.s   loc_FFF35F13
FFF35F10  e10003                 loc_FFF35F10 mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35F13  ec01                   loc_FFF35F13 mov.l   18h+var_18[sp], r1
FFF35F15  a101                              mov.l   r1, 18h+var_8[sp]
FFF35F17  3f6607                            rtsd    #1Ch, r6-r6

; ######## sub_FFF35A08  FFF35A08-FFF35B7D (file 335A08) callers: FFF3697A(sub_FFF368FF)
FFF35A08  7100dc                 sub_FFF35A08 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF35A08
FFF35A0B  a201                              mov.l   r1, 24h+var_4[sp]
FFF35A0D  3e0600                            mov.l   #0, 24h+var_C[sp]
FFF35A10  3e0300                            mov.l   #0, 24h+var_18[sp]
FFF35A13  3e0200                            mov.l   #0, 24h+var_1C[sp]
FFF35A16  aa01                              mov.l   24h+var_4[sp], r1
FFF35A18  ec11                              mov.l   [r1], r1
FFF35A1A  7211c802                          add     #2C8h, r1, r1
FFF35A1E  a009                              mov.l   r1, 24h+var_20[sp]
FFF35A20  aa01                              mov.l   24h+var_4[sp], r1
FFF35A22  ec11                              mov.l   [r1], r1
FFF35A24  6211                              add     #1, r1
FFF35A26  fb3a0002                          mov.l   #200h, r3
FFF35A2A  6602                              mov.l   #0, r2
FFF35A2C  ef24                              mov.l   r2, r4
FFF35A2E  05818aff                          bsr.a   sub_FFF2E4AF
FFF35A32  a809                              mov.l   24h+var_20[sp], r1
FFF35A34  8d11                              mov.b   14h[r1], r1
FFF35A36  61c1                              cmp     #0Ch, r1
FFF35A38  2116                              bne.b   loc_FFF35A4E
FFF35A3A  aa01                              mov.l   24h+var_4[sp], r1
FFF35A3C  ec11                              mov.l   [r1], r1
FFF35A3E  6211                              add     #1, r1
FFF35A40  6633                              mov.l   #3, r3
FFF35A42  fb224be9c3ff                      mov.l   #unk_FFC3E94B, r2
FFF35A48  05308aff                          bsr.a   sub_FFF2E478
FFF35A4C  2e41                              bra.b   loc_FFF35A8D
FFF35A4E  a809                   loc_FFF35A4E mov.l   24h+var_20[sp], r1
FFF35A50  8d11                              mov.b   14h[r1], r1
FFF35A52  755110                            cmp     #10h, r1
FFF35A55  2116                              bne.b   loc_FFF35A6B
FFF35A57  aa01                              mov.l   24h+var_4[sp], r1
FFF35A59  ec11                              mov.l   [r1], r1
FFF35A5B  6211                              add     #1, r1
FFF35A5D  6643                              mov.l   #4, r3
FFF35A5F  fb2247e9c3ff                      mov.l   #off_FFC3E947, r2
FFF35A65  05138aff                          bsr.a   sub_FFF2E478
FFF35A69  2e24                              bra.b   loc_FFF35A8D
FFF35A6B  a809                   loc_FFF35A6B mov.l   24h+var_20[sp], r1
FFF35A6D  8d11                              mov.b   14h[r1], r1
FFF35A6F  755120                            cmp     #20h, r1 ; ' '
FFF35A72  2115                              bne.b   loc_FFF35A87
FFF35A74  aa01                              mov.l   24h+var_4[sp], r1
FFF35A76  ec11                              mov.l   [r1], r1
FFF35A78  6211                              add     #1, r1
FFF35A7A  66c3                              mov.l   #0Ch, r3
FFF35A7C  fb223be9c3ff                      mov.l   #unk_FFC3E93B, r2
FFF35A82  05f689ff                          bsr.a   sub_FFF2E478
FFF35A86  0f                                bra.s   loc_FFF35A8D
FFF35A87  f806fe                 loc_FFF35A87 mov.l   #-2, 24h+var_24[sp]
FFF35A8A  38ed00                            bra.w   loc_FFF35B77
FFF35A8D  a809                   loc_FFF35A8D mov.l   24h+var_20[sp], r1
FFF35A8F  a892                              mov.l   8[r1], r2
FFF35A91  06c9120e                          add     1Ch[r1].uw, r2
FFF35A95  a08a                              mov.l   r2, 24h+var_18[sp]
FFF35A97  aa04                              mov.l   24h+var_4[sp], r4
FFF35A99  ec42                              mov.l   [r4], r2
FFF35A9B  a889                              mov.l   24h+var_18[sp], r1
FFF35A9D  6212                              add     #1, r2
FFF35A9F  6613                              mov.l   #1, r3
FFF35AA1  05b3f9ff                          bsr.a   sub_FFF35454
FFF35AA5  a181                              mov.l   r1, 24h+var_C[sp]
FFF35AA7  a981                              mov.l   24h+var_C[sp], r1
FFF35AA9  6101                              cmp     #0, r1
FFF35AAB  17                                beq.s   loc_FFF35AB2
FFF35AAC  e10006                            mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35AAF  38c800                            bra.w   loc_FFF35B77
FFF35AB2  a809                   loc_FFF35AB2 mov.l   24h+var_20[sp], r1
FFF35AB4  8d11                              mov.b   14h[r1], r1
FFF35AB6  755140                            cmp     #40h, r1 ; '@'
FFF35AB9  202b                              beq.b   loc_FFF35AE4
FFF35ABB  a809                              mov.l   24h+var_20[sp], r1
FFF35ABD  a892                              mov.l   8[r1], r2
FFF35ABF  06c9120e                          add     1Ch[r1].uw, r2
FFF35AC3  06891206                          add     18h[r1].l, r2
FFF35AC7  a082                              mov.l   r2, 24h+var_1C[sp]
FFF35AC9  aa04                              mov.l   24h+var_4[sp], r4
FFF35ACB  ec42                              mov.l   [r4], r2
FFF35ACD  a881                              mov.l   24h+var_1C[sp], r1
FFF35ACF  6212                              add     #1, r2
FFF35AD1  6613                              mov.l   #1, r3
FFF35AD3  0581f9ff                          bsr.a   sub_FFF35454
FFF35AD7  a181                              mov.l   r1, 24h+var_C[sp]
FFF35AD9  a981                              mov.l   24h+var_C[sp], r1
FFF35ADB  6101                              cmp     #0, r1
FFF35ADD  17                                beq.s   loc_FFF35AE4
FFF35ADE  e10006                            mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35AE1  389600                            bra.w   loc_FFF35B77
FFF35AE4  aa01                   loc_FFF35AE4 mov.l   24h+var_4[sp], r1
FFF35AE6  ec11                              mov.l   [r1], r1
FFF35AE8  3937fe                            bsr.w   sub_FFF3591F
FFF35AEB  aa01                              mov.l   24h+var_4[sp], r1
FFF35AED  ec11                              mov.l   [r1], r1
FFF35AEF  6211                              add     #1, r1
FFF35AF1  fb3a0002                          mov.l   #200h, r3
FFF35AF5  6602                              mov.l   #0, r2
FFF35AF7  ef24                              mov.l   r2, r4
FFF35AF9  05b689ff                          bsr.a   sub_FFF2E4AF
FFF35AFD  a809                              mov.l   24h+var_20[sp], r1
FFF35AFF  a991                              mov.l   18h[r1], r1
FFF35B01  6011                              sub     #1, r1
FFF35B03  a101                              mov.l   r1, 24h+var_14[sp]
FFF35B05  a809                              mov.l   24h+var_20[sp], r1
FFF35B07  8d11                              mov.b   14h[r1], r1
FFF35B09  755140                            cmp     #40h, r1 ; '@'
FFF35B0C  2068                              beq.b   loc_FFF35B74
FFF35B0E  a889                              mov.l   24h+var_18[sp], r1
FFF35B10  6211                              add     #1, r1
FFF35B12  a089                              mov.l   r1, 24h+var_18[sp]
FFF35B14  a881                              mov.l   24h+var_1C[sp], r1
FFF35B16  6211                              add     #1, r1
FFF35B18  a081                              mov.l   r1, 24h+var_1C[sp]
FFF35B1A  3e0500                            mov.l   #0, 24h+var_10[sp]
FFF35B1D  2e4f                              bra.b   loc_FFF35B6C
FFF35B1F  aa04                   loc_FFF35B1F mov.l   24h+var_4[sp], r4
FFF35B21  ec42                              mov.l   [r4], r2
FFF35B23  a889                              mov.l   24h+var_18[sp], r1
FFF35B25  6212                              add     #1, r2
FFF35B27  6613                              mov.l   #1, r3
FFF35B29  052bf9ff                          bsr.a   sub_FFF35454
FFF35B2D  a181                              mov.l   r1, 24h+var_C[sp]
FFF35B2F  a981                              mov.l   24h+var_C[sp], r1
FFF35B31  6101                              cmp     #0, r1
FFF35B33  16                                beq.s   loc_FFF35B39
FFF35B34  e10006                            mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35B37  2e40                              bra.b   loc_FFF35B77
FFF35B39  aa04                   loc_FFF35B39 mov.l   24h+var_4[sp], r4
FFF35B3B  ec42                              mov.l   [r4], r2
FFF35B3D  a881                              mov.l   24h+var_1C[sp], r1
FFF35B3F  6212                              add     #1, r2
FFF35B41  6613                              mov.l   #1, r3
FFF35B43  0511f9ff                          bsr.a   sub_FFF35454
FFF35B47  a181                              mov.l   r1, 24h+var_C[sp]
FFF35B49  a981                              mov.l   24h+var_C[sp], r1
FFF35B4B  6101                              cmp     #0, r1
FFF35B4D  16                                beq.s   loc_FFF35B53
FFF35B4E  e10006                            mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35B51  2e26                              bra.b   loc_FFF35B77
FFF35B53  aa01                   loc_FFF35B53 mov.l   24h+var_4[sp], r1
FFF35B55  ec11                              mov.l   [r1], r1
FFF35B57  39c8fd                            bsr.w   sub_FFF3591F
FFF35B5A  a909                              mov.l   24h+var_10[sp], r1
FFF35B5C  6211                              add     #1, r1
FFF35B5E  a109                              mov.l   r1, 24h+var_10[sp]
FFF35B60  a889                              mov.l   24h+var_18[sp], r1
FFF35B62  6211                              add     #1, r1
FFF35B64  a089                              mov.l   r1, 24h+var_18[sp]
FFF35B66  a881                              mov.l   24h+var_1C[sp], r1
FFF35B68  6211                              add     #1, r1
FFF35B6A  a081                              mov.l   r1, 24h+var_1C[sp]
FFF35B6C  a909                   loc_FFF35B6C mov.l   24h+var_10[sp], r1
FFF35B6E  06850104                          cmp     24h+var_14[sp].l, r1
FFF35B72  23ad                              bltu.b  loc_FFF35B1F
FFF35B74  e10006                 loc_FFF35B74 mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35B77  ec01                   loc_FFF35B77 mov.l   24h+var_24[sp], r1
FFF35B79  a189                              mov.l   r1, 24h+var_8[sp]
FFF35B7B  6709                              rtsd    #9

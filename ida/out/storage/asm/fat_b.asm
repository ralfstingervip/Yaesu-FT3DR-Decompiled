; ==== fat_b  FFF20A40-FFF22500  (file 320A40-322500) ====
FFF20A40  a102                              mov.l   r2, 18h+var_8[sp]
FFF20A42  a082                              mov.l   r2, 18h+var_10[sp]
FFF20A44  e5000501                          mov.l   18h+var_4[sp], 18h+var_14[sp]
FFF20A48  a809                              mov.l   18h+var_14[sp], r1
FFF20A4A  cc12                              mov.b   [r1], r2
FFF20A4C  6c82                              shll    #8, r2
FFF20A4E  551201                            or      1[r1], r2
FFF20A51  918a                              mov.w   r2, 18h+var_A[sp]
FFF20A53  b989                              movu.w  18h+var_A[sp], r1
FFF20A55  7701818200                        cmp     #8281h, r1
FFF20A5A  290f                              blt.b   loc_FFF20A69
FFF20A5C  b989                              movu.w  18h+var_A[sp], r1
FFF20A5E  77019a8200                        cmp     #829Ah, r1
FFF20A63  2a06                              bgt.b   loc_FFF20A69
FFF20A65  f80601                            mov.l   #1, 18h+var_18[sp]
FFF20A68  0c                                bra.s   loc_FFF20A6C
FFF20A69  f80600                 loc_FFF20A69 mov.l   #0, 18h+var_18[sp]
FFF20A6C  ec01                   loc_FFF20A6C mov.l   18h+var_18[sp], r1
FFF20A6E  6101                              cmp     #0, r1
FFF20A70  2021                              beq.b   loc_FFF20A91
FFF20A72  a809                              mov.l   18h+var_14[sp], r1
FFF20A74  a882                              mov.l   18h+var_10[sp], r2
FFF20A76  c012                              mov.b   [r1], [r2]
FFF20A78  a881                              mov.l   18h+var_10[sp], r1
FFF20A7A  6211                              add     #1, r1
FFF20A7C  a081                              mov.l   r1, 18h+var_10[sp]
FFF20A7E  a809                              mov.l   18h+var_14[sp], r1
FFF20A80  6211                              add     #1, r1
FFF20A82  a009                              mov.l   r1, 18h+var_14[sp]
FFF20A84  a809                              mov.l   18h+var_14[sp], r1
FFF20A86  cc1e                              mov.b   [r1], r14
FFF20A88  71eedf                            add     #-21h, r14, r14
FFF20A8B  a881                              mov.l   18h+var_10[sp], r1
FFF20A8D  c31e                              mov.b   r14, [r1]
FFF20A8F  6706                              rtsd    #6
FFF20A91  b989                   loc_FFF20A91 movu.w  18h+var_A[sp], r1
FFF20A93  7701bf8300                        cmp     #83BFh, r1
FFF20A98  290f                              blt.b   loc_FFF20AA7
FFF20A9A  b989                              movu.w  18h+var_A[sp], r1
FFF20A9C  7701d68300                        cmp     #83D6h, r1
FFF20AA1  2a06                              bgt.b   loc_FFF20AA7
FFF20AA3  f80601                            mov.l   #1, 18h+var_18[sp]
FFF20AA6  0c                                bra.s   loc_FFF20AAA
FFF20AA7  f80600                 loc_FFF20AA7 mov.l   #0, 18h+var_18[sp]
FFF20AAA  ec01                   loc_FFF20AAA mov.l   18h+var_18[sp], r1
FFF20AAC  6101                              cmp     #0, r1
FFF20AAE  2021                              beq.b   loc_FFF20ACF
FFF20AB0  a809                              mov.l   18h+var_14[sp], r1
FFF20AB2  a882                              mov.l   18h+var_10[sp], r2
FFF20AB4  c012                              mov.b   [r1], [r2]
FFF20AB6  a881                              mov.l   18h+var_10[sp], r1
FFF20AB8  6211                              add     #1, r1
FFF20ABA  a081                              mov.l   r1, 18h+var_10[sp]
FFF20ABC  a809                              mov.l   18h+var_14[sp], r1
FFF20ABE  6211                              add     #1, r1
FFF20AC0  a009                              mov.l   r1, 18h+var_14[sp]
FFF20AC2  a809                              mov.l   18h+var_14[sp], r1
FFF20AC4  cc1e                              mov.b   [r1], r14
FFF20AC6  71eee0                            add     #-20h, r14, r14
FFF20AC9  a881                              mov.l   18h+var_10[sp], r1
FFF20ACB  c31e                              mov.b   r14, [r1]
FFF20ACD  6706                              rtsd    #6
FFF20ACF  b989                   loc_FFF20ACF movu.w  18h+var_A[sp], r1
FFF20AD1  7701708400                        cmp     #8470h, r1
FFF20AD6  290f                              blt.b   loc_FFF20AE5
FFF20AD8  b989                              movu.w  18h+var_A[sp], r1
FFF20ADA  77017e8400                        cmp     #847Eh, r1
FFF20ADF  2a06                              bgt.b   loc_FFF20AE5
FFF20AE1  f80601                            mov.l   #1, 18h+var_18[sp]
FFF20AE4  0c                                bra.s   loc_FFF20AE8
FFF20AE5  f80600                 loc_FFF20AE5 mov.l   #0, 18h+var_18[sp]
FFF20AE8  ec01                   loc_FFF20AE8 mov.l   18h+var_18[sp], r1
FFF20AEA  6101                              cmp     #0, r1
FFF20AEC  2021                              beq.b   loc_FFF20B0D
FFF20AEE  a809                              mov.l   18h+var_14[sp], r1
FFF20AF0  a882                              mov.l   18h+var_10[sp], r2
FFF20AF2  c012                              mov.b   [r1], [r2]
FFF20AF4  a881                              mov.l   18h+var_10[sp], r1
FFF20AF6  6211                              add     #1, r1
FFF20AF8  a081                              mov.l   r1, 18h+var_10[sp]
FFF20AFA  a809                              mov.l   18h+var_14[sp], r1
FFF20AFC  6211                              add     #1, r1
FFF20AFE  a009                              mov.l   r1, 18h+var_14[sp]
FFF20B00  a809                              mov.l   18h+var_14[sp], r1
FFF20B02  cc1e                              mov.b   [r1], r14
FFF20B04  71eed0                            add     #-30h, r14, r14
FFF20B07  a881                              mov.l   18h+var_10[sp], r1
FFF20B09  c31e                              mov.b   r14, [r1]
FFF20B0B  6706                              rtsd    #6
FFF20B0D  b989                   loc_FFF20B0D movu.w  18h+var_A[sp], r1
FFF20B0F  7701808400                        cmp     #8480h, r1
FFF20B14  290f                              blt.b   loc_FFF20B23
FFF20B16  b989                              movu.w  18h+var_A[sp], r1
FFF20B18  7701918400                        cmp     #8491h, r1
FFF20B1D  2a06                              bgt.b   loc_FFF20B23
FFF20B1F  f80601                            mov.l   #1, 18h+var_18[sp]
FFF20B22  0c                                bra.s   loc_FFF20B26
FFF20B23  f80600                 loc_FFF20B23 mov.l   #0, 18h+var_18[sp]
FFF20B26  ec01                   loc_FFF20B26 mov.l   18h+var_18[sp], r1
FFF20B28  6101                              cmp     #0, r1
FFF20B2A  2021                              beq.b   loc_FFF20B4B
FFF20B2C  a809                              mov.l   18h+var_14[sp], r1
FFF20B2E  a882                              mov.l   18h+var_10[sp], r2
FFF20B30  c012                              mov.b   [r1], [r2]
FFF20B32  a881                              mov.l   18h+var_10[sp], r1
FFF20B34  6211                              add     #1, r1
FFF20B36  a081                              mov.l   r1, 18h+var_10[sp]
FFF20B38  a809                              mov.l   18h+var_14[sp], r1
FFF20B3A  6211                              add     #1, r1
FFF20B3C  a009                              mov.l   r1, 18h+var_14[sp]
FFF20B3E  a809                              mov.l   18h+var_14[sp], r1
FFF20B40  cc1e                              mov.b   [r1], r14
FFF20B42  71eecf                            add     #-31h, r14, r14
FFF20B45  a881                              mov.l   18h+var_10[sp], r1
FFF20B47  c31e                              mov.b   r14, [r1]
FFF20B49  6706                              rtsd    #6
FFF20B4B  b989                   loc_FFF20B4B movu.w  18h+var_A[sp], r1
FFF20B4D  770140fa00                        cmp     #0FA40h, r1
FFF20B52  290f                              blt.b   loc_FFF20B61
FFF20B54  b989                              movu.w  18h+var_A[sp], r1
FFF20B56  770149fa00                        cmp     #0FA49h, r1
FFF20B5B  2a06                              bgt.b   loc_FFF20B61
FFF20B5D  f80601                            mov.l   #1, 18h+var_18[sp]
FFF20B60  0c                                bra.s   loc_FFF20B64
FFF20B61  f80600                 loc_FFF20B61 mov.l   #0, 18h+var_18[sp]
FFF20B64  ec01                   loc_FFF20B64 mov.l   18h+var_18[sp], r1
FFF20B66  6101                              cmp     #0, r1
FFF20B68  2020                              beq.b   loc_FFF20B88
FFF20B6A  b989                              movu.w  18h+var_A[sp], r1
FFF20B6C  7211148d                          add     #-72ECh, r1, r1
FFF20B70  9181                              mov.w   r1, 18h+var_C[sp]
FFF20B72  b981                              movu.w  18h+var_C[sp], r1
FFF20B74  6881                              shlr    #8, r1
FFF20B76  a882                              mov.l   18h+var_10[sp], r2
FFF20B78  c321                              mov.b   r1, [r2]
FFF20B7A  a881                              mov.l   18h+var_10[sp], r1
FFF20B7C  6211                              add     #1, r1
FFF20B7E  a081                              mov.l   r1, 18h+var_10[sp]
FFF20B80  b301                              movu.b  18h+var_C[sp], r1
FFF20B82  a882                              mov.l   18h+var_10[sp], r2
FFF20B84  c321                              mov.b   r1, [r2]
FFF20B86  6706                              rtsd    #6
FFF20B88  a809                   loc_FFF20B88 mov.l   18h+var_14[sp], r1
FFF20B8A  a882                              mov.l   18h+var_10[sp], r2
FFF20B8C  c012                              mov.b   [r1], [r2]
FFF20B8E  a881                              mov.l   18h+var_10[sp], r1
FFF20B90  6211                              add     #1, r1
FFF20B92  a081                              mov.l   r1, 18h+var_10[sp]
FFF20B94  a809                              mov.l   18h+var_14[sp], r1
FFF20B96  6211                              add     #1, r1
FFF20B98  a009                              mov.l   r1, 18h+var_14[sp]
FFF20B9A  a809                              mov.l   18h+var_14[sp], r1
FFF20B9C  a882                              mov.l   18h+var_10[sp], r2
FFF20B9E  c012                              mov.b   [r1], [r2]
FFF20BA0  6706                              rtsd    #6
FFF20BA2  7100cc                 sub_FFF20BA2 add     #-34h, sp, sp   ; <<<< FUNC sub_FFF20BA2
FFF20BA5  a301                              mov.l   r1, 34h+var_4[sp]
FFF20BA7  a28a                              mov.l   r2, 34h+var_8[sp]
FFF20BA9  a283                              mov.l   r3, 34h+var_C[sp]
FFF20BAB  3c8b00                            mov.b   #0, 34h+var_19[sp]
FFF20BAE  3e0400                            mov.l   #0, 34h+var_24[sp]
FFF20BB1  3e0500                            mov.l   #0, 34h+var_20[sp]
FFF20BB4  e5000c08                          mov.l   34h+var_4[sp], 34h+var_14[sp]
FFF20BB8  2e0e                              bra.b   loc_FFF20BC6
FFF20BBA  aa01                   loc_FFF20BBA mov.l   34h+var_14[sp], r1
FFF20BBC  6211                              add     #1, r1
FFF20BBE  a201                              mov.l   r1, 34h+var_14[sp]
FFF20BC0  a909                              mov.l   34h+var_20[sp], r1
FFF20BC2  6211                              add     #1, r1
FFF20BC4  a109                              mov.l   r1, 34h+var_20[sp]
FFF20BC6  aa01                   loc_FFF20BC6 mov.l   34h+var_14[sp], r1
FFF20BC8  cc1e                              mov.b   [r1], r14
FFF20BCA  610e                              cmp     #0, r14
FFF20BCC  21ee                              bne.b   loc_FFF20BBA
FFF20BCE  e5000c07                          mov.l   34h+var_4[sp], 34h+var_18[sp]
FFF20BD2  2e16                              bra.b   loc_FFF20BE8
FFF20BD4  a989                   loc_FFF20BD4 mov.l   34h+var_18[sp], r1
FFF20BD6  3982fd                            bsr.w   sub_FFF20958
FFF20BD9  6101                              cmp     #0, r1
FFF20BDB  17                                beq.s   loc_FFF20BE2
FFF20BDC  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF20BDF  3c8b01                            mov.b   #1, 34h+var_19[sp]
FFF20BE2  a989                   loc_FFF20BE2 mov.l   34h+var_18[sp], r1
FFF20BE4  6211                              add     #1, r1
FFF20BE6  a189                              mov.l   r1, 34h+var_18[sp]
FFF20BE8  a989                   loc_FFF20BE8 mov.l   34h+var_18[sp], r1
FFF20BEA  cc1e                              mov.b   [r1], r14
FFF20BEC  610e                              cmp     #0, r14
FFF20BEE  21e6                              bne.b   loc_FFF20BD4
FFF20BF0  ab01                              mov.l   34h+var_4[sp], r1
FFF20BF2  754220                            mov.l   #20h, r2 ; ' '
FFF20BF5  0560db00                          bsr.a   sub_FFF2E755
FFF20BF9  a189                              mov.l   r1, 34h+var_18[sp]
FFF20BFB  a989                              mov.l   34h+var_18[sp], r1
FFF20BFD  6101                              cmp     #0, r1
FFF20BFF  17                                beq.s   loc_FFF20C06
FFF20C00  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF20C03  3c8b01                            mov.b   #1, 34h+var_19[sp]
FFF20C06  ab01                   loc_FFF20C06 mov.l   34h+var_4[sp], r1
FFF20C08  75422e                            mov.l   #2Eh, r2 ; '.'
FFF20C0B  054adb00                          bsr.a   sub_FFF2E755
FFF20C0F  a189                              mov.l   r1, 34h+var_18[sp]
FFF20C11  a989                              mov.l   34h+var_18[sp], r1
FFF20C13  6101                              cmp     #0, r1
FFF20C15  203f                              beq.b   loc_FFF20C54
FFF20C17  3e0200                            mov.l   #0, 34h+var_2C[sp]
FFF20C1A  2e0c                              bra.b   loc_FFF20C26
FFF20C1C  6011                   loc_FFF20C1C sub     #1, r1
FFF20C1E  a201                              mov.l   r1, 34h+var_14[sp]
FFF20C20  a881                              mov.l   34h+var_2C[sp], r1
FFF20C22  6211                              add     #1, r1
FFF20C24  a081                              mov.l   r1, 34h+var_2C[sp]
FFF20C26  aa01                   loc_FFF20C26 mov.l   34h+var_14[sp], r1
FFF20C28  cc1e                              mov.b   [r1], r14
FFF20C2A  755e2e                            cmp     #2Eh, r14 ; '.'
FFF20C2D  21ef                              bne.b   loc_FFF20C1C
FFF20C2F  06850107                          cmp     34h+var_18[sp].l, r1
FFF20C33  11                                beq.s   loc_FFF20C3C
FFF20C34  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF20C37  3c8b01                            mov.b   #1, 34h+var_19[sp]
FFF20C3A  2e0e                              bra.b   loc_FFF20C48
FFF20C3C  a881                   loc_FFF20C3C mov.l   34h+var_2C[sp], r1
FFF20C3E  6151                              cmp     #5, r1
FFF20C40  2908                              blt.b   loc_FFF20C48
FFF20C42  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF20C45  3c8b01                            mov.b   #1, 34h+var_19[sp]
FFF20C48  aa01                   loc_FFF20C48 mov.l   34h+var_14[sp], r1
FFF20C4A  05d8d900                          bsr.a   sub_FFF2E622
FFF20C4E  a90a                              mov.l   34h+var_20[sp], r2
FFF20C50  4312                              sub     r1, r2
FFF20C52  a10a                              mov.l   r2, 34h+var_20[sp]
FFF20C54  a909                   loc_FFF20C54 mov.l   34h+var_20[sp], r1
FFF20C56  6191                              cmp     #9, r1
FFF20C58  2908                              blt.b   loc_FFF20C60
FFF20C5A  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF20C5D  3c8b01                            mov.b   #1, 34h+var_19[sp]
FFF20C60  8e89                   loc_FFF20C60 mov.b   34h+var_19[sp], r1
FFF20C62  6101                              cmp     #0, r1
FFF20C64  3bab00                            bne.w   loc_FFF20D0F
FFF20C67  e5000c07                          mov.l   34h+var_4[sp], 34h+var_18[sp]
FFF20C6B  388f00                            bra.w   loc_FFF20CFA
FFF20C6E  a989                   loc_FFF20C6E mov.l   34h+var_18[sp], r1
FFF20C70  cc1e                              mov.b   [r1], r14
FFF20C72  755e61                            cmp     #61h, r14 ; 'a'
FFF20C75  290f                              blt.b   loc_FFF20C84
FFF20C77  a989                              mov.l   34h+var_18[sp], r1
FFF20C79  cc1e                              mov.b   [r1], r14
FFF20C7B  755e7a                            cmp     #7Ah, r14 ; 'z'
FFF20C7E  2a06                              bgt.b   loc_FFF20C84
FFF20C80  f80601                            mov.l   #1, 34h+var_34[sp]
FFF20C83  0c                                bra.s   loc_FFF20C87
FFF20C84  f80600                 loc_FFF20C84 mov.l   #0, 34h+var_34[sp]
FFF20C87  ec01                   loc_FFF20C87 mov.l   34h+var_34[sp], r1
FFF20C89  6101                              cmp     #0, r1
FFF20C8B  201e                              beq.b   loc_FFF20CA9
FFF20C8D  a989                              mov.l   34h+var_18[sp], r1
FFF20C8F  cc1e                              mov.b   [r1], r14
FFF20C91  71eee0                            add     #-20h, r14, r14
FFF20C94  aa89                              mov.l   34h+var_8[sp], r1
FFF20C96  c31e                              mov.b   r14, [r1]
FFF20C98  aa89                              mov.l   34h+var_8[sp], r1
FFF20C9A  6211                              add     #1, r1
FFF20C9C  a289                              mov.l   r1, 34h+var_8[sp]
FFF20C9E  a989                              mov.l   34h+var_18[sp], r1
FFF20CA0  6211                              add     #1, r1
FFF20CA2  a189                              mov.l   r1, 34h+var_18[sp]
FFF20CA4  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF20CA7  2e53                              bra.b   loc_FFF20CFA
FFF20CA9  a989                   loc_FFF20CA9 mov.l   34h+var_18[sp], r1
FFF20CAB  5811                              movu.b  [r1], r1
FFF20CAD  052ccf00                          bsr.a   sub_FFF2DBD9
FFF20CB1  6101                              cmp     #0, r1
FFF20CB3  a989                              mov.l   34h+var_18[sp], r1
FFF20CB5  2018                              beq.b   loc_FFF20CCD
FFF20CB7  aa8a                              mov.l   34h+var_8[sp], r2
FFF20CB9  3982fd                            bsr.w   sub_FFF20A3B
FFF20CBC  a989                              mov.l   34h+var_18[sp], r1
FFF20CBE  6221                              add     #2, r1
FFF20CC0  a189                              mov.l   r1, 34h+var_18[sp]
FFF20CC2  aa89                              mov.l   34h+var_8[sp], r1
FFF20CC4  6221                              add     #2, r1
FFF20CC6  a289                              mov.l   r1, 34h+var_8[sp]
FFF20CC8  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF20CCB  2e2f                              bra.b   loc_FFF20CFA
FFF20CCD  398bfc                 loc_FFF20CCD bsr.w   sub_FFF20958
FFF20CD0  6101                              cmp     #0, r1
FFF20CD2  aa89                              mov.l   34h+var_8[sp], r1
FFF20CD4  2016                              beq.b   loc_FFF20CEA
FFF20CD6  f8145f                            mov.b   #5Fh, [r1] ; '_'
FFF20CD9  aa89                              mov.l   34h+var_8[sp], r1
FFF20CDB  6211                              add     #1, r1
FFF20CDD  a289                              mov.l   r1, 34h+var_8[sp]
FFF20CDF  a989                              mov.l   34h+var_18[sp], r1
FFF20CE1  6211                              add     #1, r1
FFF20CE3  a189                              mov.l   r1, 34h+var_18[sp]
FFF20CE5  3e0401                            mov.l   #1, 34h+var_24[sp]
FFF20CE8  2e12                              bra.b   loc_FFF20CFA
FFF20CEA  a98a                   loc_FFF20CEA mov.l   34h+var_18[sp], r2
FFF20CEC  c021                              mov.b   [r2], [r1]
FFF20CEE  aa89                              mov.l   34h+var_8[sp], r1
FFF20CF0  6211                              add     #1, r1
FFF20CF2  a289                              mov.l   r1, 34h+var_8[sp]
FFF20CF4  a989                              mov.l   34h+var_18[sp], r1
FFF20CF6  6211                              add     #1, r1
FFF20CF8  a189                              mov.l   r1, 34h+var_18[sp]
FFF20CFA  a989                   loc_FFF20CFA mov.l   34h+var_18[sp], r1
FFF20CFC  cc1e                              mov.b   [r1], r14
FFF20CFE  610e                              cmp     #0, r14
FFF20D00  3b6eff                            bne.w   loc_FFF20C6E
FFF20D03  aa89                              mov.l   34h+var_8[sp], r1
FFF20D05  f81400                            mov.b   #0, [r1]
FFF20D08  e5000401                          mov.l   34h+var_24[sp], 34h+var_30[sp]
FFF20D0C  380a02                            bra.w   loc_FFF20F16
FFF20D0F  aa81                   loc_FFF20D0F mov.l   34h+var_C[sp], r1
FFF20D11  0511d900                          bsr.a   sub_FFF2E622
FFF20D15  a089                              mov.l   r1, 34h+var_28[sp]
FFF20D17  6671                              mov.l   #7, r1
FFF20D19  06810103                          sub     34h+var_28[sp].l, r1
FFF20D1D  a089                              mov.l   r1, 34h+var_28[sp]
FFF20D1F  e5000c07                          mov.l   34h+var_4[sp], 34h+var_18[sp]
FFF20D23  3e0200                            mov.l   #0, 34h+var_2C[sp]
FFF20D26  38c000                            bra.w   loc_FFF20DE6
FFF20D29  a989                   loc_FFF20D29 mov.l   34h+var_18[sp], r1
FFF20D2B  cc1e                              mov.b   [r1], r14
FFF20D2D  755e61                            cmp     #61h, r14 ; 'a'
FFF20D30  290f                              blt.b   loc_FFF20D3F
FFF20D32  a989                              mov.l   34h+var_18[sp], r1
FFF20D34  cc1e                              mov.b   [r1], r14
FFF20D36  755e7a                            cmp     #7Ah, r14 ; 'z'
FFF20D39  2a06                              bgt.b   loc_FFF20D3F
FFF20D3B  f80601                            mov.l   #1, 34h+var_34[sp]
FFF20D3E  0c                                bra.s   loc_FFF20D42
FFF20D3F  f80600                 loc_FFF20D3F mov.l   #0, 34h+var_34[sp]
FFF20D42  ec01                   loc_FFF20D42 mov.l   34h+var_34[sp], r1
FFF20D44  6101                              cmp     #0, r1
FFF20D46  201c                              beq.b   loc_FFF20D62
FFF20D48  a989                              mov.l   34h+var_18[sp], r1
FFF20D4A  cc1e                              mov.b   [r1], r14
FFF20D4C  71eee0                            add     #-20h, r14, r14
FFF20D4F  aa89                              mov.l   34h+var_8[sp], r1
FFF20D51  c31e                              mov.b   r14, [r1]
FFF20D53  aa89                              mov.l   34h+var_8[sp], r1
FFF20D55  6211                              add     #1, r1
FFF20D57  a289                              mov.l   r1, 34h+var_8[sp]
FFF20D59  a989                              mov.l   34h+var_18[sp], r1
FFF20D5B  6211                              add     #1, r1
FFF20D5D  a189                              mov.l   r1, 34h+var_18[sp]
FFF20D5F  388100                            bra.w   loc_FFF20DE0
FFF20D62  a989                   loc_FFF20D62 mov.l   34h+var_18[sp], r1
FFF20D64  5811                              movu.b  [r1], r1
FFF20D66  0573ce00                          bsr.a   sub_FFF2DBD9
FFF20D6A  6101                              cmp     #0, r1
FFF20D6C  a989                              mov.l   34h+var_18[sp], r1
FFF20D6E  201b                              beq.b   loc_FFF20D89
FFF20D70  aa8a                              mov.l   34h+var_8[sp], r2
FFF20D72  39c9fc                            bsr.w   sub_FFF20A3B
FFF20D75  a989                              mov.l   34h+var_18[sp], r1
FFF20D77  6221                              add     #2, r1
FFF20D79  a189                              mov.l   r1, 34h+var_18[sp]
FFF20D7B  aa89                              mov.l   34h+var_8[sp], r1
FFF20D7D  6221                              add     #2, r1
FFF20D7F  a289                              mov.l   r1, 34h+var_8[sp]
FFF20D81  a881                              mov.l   34h+var_2C[sp], r1
FFF20D83  6211                              add     #1, r1
FFF20D85  a081                              mov.l   r1, 34h+var_2C[sp]
FFF20D87  2e59                              bra.b   loc_FFF20DE0
FFF20D89  39cffb                 loc_FFF20D89 bsr.w   sub_FFF20958
FFF20D8C  6101                              cmp     #0, r1
FFF20D8E  2015                              beq.b   loc_FFF20DA3
FFF20D90  aa89                              mov.l   34h+var_8[sp], r1
FFF20D92  f8145f                            mov.b   #5Fh, [r1] ; '_'
FFF20D95  aa89                              mov.l   34h+var_8[sp], r1
FFF20D97  6211                              add     #1, r1
FFF20D99  a289                              mov.l   r1, 34h+var_8[sp]
FFF20D9B  a989                              mov.l   34h+var_18[sp], r1
FFF20D9D  6211                              add     #1, r1
FFF20D9F  a189                              mov.l   r1, 34h+var_18[sp]
FFF20DA1  2e3f                              bra.b   loc_FFF20DE0
FFF20DA3  a989                   loc_FFF20DA3 mov.l   34h+var_18[sp], r1
FFF20DA5  cc1e                              mov.b   [r1], r14
FFF20DA7  755e2e                            cmp     #2Eh, r14 ; '.'
FFF20DAA  11                                beq.s   loc_FFF20DB3
FFF20DAB  a989                              mov.l   34h+var_18[sp], r1
FFF20DAD  cc1e                              mov.b   [r1], r14
FFF20DAF  755e20                            cmp     #20h, r14 ; ' '
FFF20DB2  1d                                bne.s   loc_FFF20DB7
FFF20DB3  f80601                 loc_FFF20DB3 mov.l   #1, 34h+var_34[sp]
FFF20DB6  0c                                bra.s   loc_FFF20DBA
FFF20DB7  f80600                 loc_FFF20DB7 mov.l   #0, 34h+var_34[sp]
FFF20DBA  ec01                   loc_FFF20DBA mov.l   34h+var_34[sp], r1
FFF20DBC  6101                              cmp     #0, r1
FFF20DBE  2010                              beq.b   loc_FFF20DCE
FFF20DC0  a989                              mov.l   34h+var_18[sp], r1
FFF20DC2  6211                              add     #1, r1
FFF20DC4  a189                              mov.l   r1, 34h+var_18[sp]
FFF20DC6  a881                              mov.l   34h+var_2C[sp], r1
FFF20DC8  6011                              sub     #1, r1
FFF20DCA  a081                              mov.l   r1, 34h+var_2C[sp]
FFF20DCC  2e14                              bra.b   loc_FFF20DE0
FFF20DCE  a989                   loc_FFF20DCE mov.l   34h+var_18[sp], r1
FFF20DD0  aa8a                              mov.l   34h+var_8[sp], r2
FFF20DD2  c012                              mov.b   [r1], [r2]
FFF20DD4  aa89                              mov.l   34h+var_8[sp], r1
FFF20DD6  6211                              add     #1, r1
FFF20DD8  a289                              mov.l   r1, 34h+var_8[sp]
FFF20DDA  a989                              mov.l   34h+var_18[sp], r1
FFF20DDC  6211                              add     #1, r1
FFF20DDE  a189                              mov.l   r1, 34h+var_18[sp]
FFF20DE0  a881                   loc_FFF20DE0 mov.l   34h+var_2C[sp], r1
FFF20DE2  6211                              add     #1, r1
FFF20DE4  a081                              mov.l   r1, 34h+var_2C[sp]
FFF20DE6  a881                   loc_FFF20DE6 mov.l   34h+var_2C[sp], r1
FFF20DE8  06850103                          cmp     34h+var_28[sp].l, r1
FFF20DEC  280d                              bge.b   loc_FFF20DF9
FFF20DEE  a989                              mov.l   34h+var_18[sp], r1
FFF20DF0  06850108                          cmp     34h+var_14[sp].l, r1
FFF20DF4  15                                beq.s   loc_FFF20DF9
FFF20DF5  f80601                            mov.l   #1, 34h+var_34[sp]
FFF20DF8  0c                                bra.s   loc_FFF20DFC
FFF20DF9  f80600                 loc_FFF20DF9 mov.l   #0, 34h+var_34[sp]
FFF20DFC  ec01                   loc_FFF20DFC mov.l   34h+var_34[sp], r1
FFF20DFE  6101                              cmp     #0, r1
FFF20E00  3b29ff                            bne.w   loc_FFF20D29
FFF20E03  a881                              mov.l   34h+var_2C[sp], r1
FFF20E05  06850103                          cmp     34h+var_28[sp].l, r1
FFF20E09  2b08                              ble.b   loc_FFF20E11
FFF20E0B  aa89                              mov.l   34h+var_8[sp], r1
FFF20E0D  6021                              sub     #2, r1
FFF20E0F  a289                              mov.l   r1, 34h+var_8[sp]
FFF20E11  aa89                   loc_FFF20E11 mov.l   34h+var_8[sp], r1
FFF20E13  f8147e                            mov.b   #7Eh, [r1] ; '~'
FFF20E16  aa89                              mov.l   34h+var_8[sp], r1
FFF20E18  6211                              add     #1, r1
FFF20E1A  a289                              mov.l   r1, 34h+var_8[sp]
FFF20E1C  2e14                              bra.b   loc_FFF20E30
FFF20E1E  aa81                   loc_FFF20E1E mov.l   34h+var_C[sp], r1
FFF20E20  aa8a                              mov.l   34h+var_8[sp], r2
FFF20E22  c012                              mov.b   [r1], [r2]
FFF20E24  aa89                              mov.l   34h+var_8[sp], r1
FFF20E26  6211                              add     #1, r1
FFF20E28  a289                              mov.l   r1, 34h+var_8[sp]
FFF20E2A  aa81                              mov.l   34h+var_C[sp], r1
FFF20E2C  6211                              add     #1, r1
FFF20E2E  a281                              mov.l   r1, 34h+var_C[sp]
FFF20E30  aa81                   loc_FFF20E30 mov.l   34h+var_C[sp], r1
FFF20E32  cc1e                              mov.b   [r1], r14
FFF20E34  610e                              cmp     #0, r14
FFF20E36  21e8                              bne.b   loc_FFF20E1E
FFF20E38  3e0200                            mov.l   #0, 34h+var_2C[sp]
FFF20E3B  38ab00                            bra.w   loc_FFF20EE6
FFF20E3E  aa01                   loc_FFF20E3E mov.l   34h+var_14[sp], r1
FFF20E40  cc1e                              mov.b   [r1], r14
FFF20E42  755e61                            cmp     #61h, r14 ; 'a'
FFF20E45  290f                              blt.b   loc_FFF20E54
FFF20E47  aa01                              mov.l   34h+var_14[sp], r1
FFF20E49  cc1e                              mov.b   [r1], r14
FFF20E4B  755e7a                            cmp     #7Ah, r14 ; 'z'
FFF20E4E  2a06                              bgt.b   loc_FFF20E54
FFF20E50  f80601                            mov.l   #1, 34h+var_34[sp]
FFF20E53  0c                                bra.s   loc_FFF20E57
FFF20E54  f80600                 loc_FFF20E54 mov.l   #0, 34h+var_34[sp]
FFF20E57  ec01                   loc_FFF20E57 mov.l   34h+var_34[sp], r1
FFF20E59  6101                              cmp     #0, r1
FFF20E5B  201b                              beq.b   loc_FFF20E76
FFF20E5D  aa01                              mov.l   34h+var_14[sp], r1
FFF20E5F  cc1e                              mov.b   [r1], r14
FFF20E61  71eee0                            add     #-20h, r14, r14
FFF20E64  aa89                              mov.l   34h+var_8[sp], r1
FFF20E66  c31e                              mov.b   r14, [r1]
FFF20E68  aa89                              mov.l   34h+var_8[sp], r1
FFF20E6A  6211                              add     #1, r1
FFF20E6C  a289                              mov.l   r1, 34h+var_8[sp]
FFF20E6E  aa01                              mov.l   34h+var_14[sp], r1
FFF20E70  6211                              add     #1, r1
FFF20E72  a201                              mov.l   r1, 34h+var_14[sp]
FFF20E74  2e6c                              bra.b   loc_FFF20EE0
FFF20E76  aa01                   loc_FFF20E76 mov.l   34h+var_14[sp], r1
FFF20E78  5811                              movu.b  [r1], r1
FFF20E7A  055fcd00                          bsr.a   sub_FFF2DBD9
FFF20E7E  6101                              cmp     #0, r1
FFF20E80  aa01                              mov.l   34h+var_14[sp], r1
FFF20E82  201b                              beq.b   loc_FFF20E9D
FFF20E84  aa8a                              mov.l   34h+var_8[sp], r2
FFF20E86  39b5fb                            bsr.w   sub_FFF20A3B
FFF20E89  aa01                              mov.l   34h+var_14[sp], r1
FFF20E8B  6221                              add     #2, r1
FFF20E8D  a201                              mov.l   r1, 34h+var_14[sp]
FFF20E8F  aa89                              mov.l   34h+var_8[sp], r1
FFF20E91  6221                              add     #2, r1
FFF20E93  a289                              mov.l   r1, 34h+var_8[sp]
FFF20E95  a881                              mov.l   34h+var_2C[sp], r1
FFF20E97  6211                              add     #1, r1
FFF20E99  a081                              mov.l   r1, 34h+var_2C[sp]
FFF20E9B  2e45                              bra.b   loc_FFF20EE0
FFF20E9D  39bbfa                 loc_FFF20E9D bsr.w   sub_FFF20958
FFF20EA0  6101                              cmp     #0, r1
FFF20EA2  2015                              beq.b   loc_FFF20EB7
FFF20EA4  aa89                              mov.l   34h+var_8[sp], r1
FFF20EA6  f8145f                            mov.b   #5Fh, [r1] ; '_'
FFF20EA9  aa89                              mov.l   34h+var_8[sp], r1
FFF20EAB  6211                              add     #1, r1
FFF20EAD  a289                              mov.l   r1, 34h+var_8[sp]
FFF20EAF  aa01                              mov.l   34h+var_14[sp], r1
FFF20EB1  6211                              add     #1, r1
FFF20EB3  a201                              mov.l   r1, 34h+var_14[sp]
FFF20EB5  2e2b                              bra.b   loc_FFF20EE0
FFF20EB7  aa01                   loc_FFF20EB7 mov.l   34h+var_14[sp], r1
FFF20EB9  cc1e                              mov.b   [r1], r14
FFF20EBB  755e20                            cmp     #20h, r14 ; ' '
FFF20EBE  2110                              bne.b   loc_FFF20ECE
FFF20EC0  aa01                              mov.l   34h+var_14[sp], r1
FFF20EC2  6211                              add     #1, r1
FFF20EC4  a201                              mov.l   r1, 34h+var_14[sp]
FFF20EC6  a881                              mov.l   34h+var_2C[sp], r1
FFF20EC8  6011                              sub     #1, r1
FFF20ECA  a081                              mov.l   r1, 34h+var_2C[sp]
FFF20ECC  2e14                              bra.b   loc_FFF20EE0
FFF20ECE  aa01                   loc_FFF20ECE mov.l   34h+var_14[sp], r1
FFF20ED0  aa8a                              mov.l   34h+var_8[sp], r2
FFF20ED2  c012                              mov.b   [r1], [r2]
FFF20ED4  aa89                              mov.l   34h+var_8[sp], r1
FFF20ED6  6211                              add     #1, r1
FFF20ED8  a289                              mov.l   r1, 34h+var_8[sp]
FFF20EDA  aa01                              mov.l   34h+var_14[sp], r1
FFF20EDC  6211                              add     #1, r1
FFF20EDE  a201                              mov.l   r1, 34h+var_14[sp]
FFF20EE0  a881                   loc_FFF20EE0 mov.l   34h+var_2C[sp], r1
FFF20EE2  6211                              add     #1, r1
FFF20EE4  a081                              mov.l   r1, 34h+var_2C[sp]
FFF20EE6  a881                   loc_FFF20EE6 mov.l   34h+var_2C[sp], r1
FFF20EE8  6131                              cmp     #3, r1
FFF20EEA  2a0d                              bgt.b   loc_FFF20EF7
FFF20EEC  aa01                              mov.l   34h+var_14[sp], r1
FFF20EEE  cc1e                              mov.b   [r1], r14
FFF20EF0  610e                              cmp     #0, r14
FFF20EF2  15                                beq.s   loc_FFF20EF7
FFF20EF3  f80601                            mov.l   #1, 34h+var_34[sp]
FFF20EF6  0c                                bra.s   loc_FFF20EFA
FFF20EF7  f80600                 loc_FFF20EF7 mov.l   #0, 34h+var_34[sp]
FFF20EFA  ec01                   loc_FFF20EFA mov.l   34h+var_34[sp], r1
FFF20EFC  6101                              cmp     #0, r1
FFF20EFE  3b40ff                            bne.w   loc_FFF20E3E
FFF20F01  a881                              mov.l   34h+var_2C[sp], r1
FFF20F03  6151                              cmp     #5, r1
FFF20F05  2908                              blt.b   loc_FFF20F0D
FFF20F07  aa89                              mov.l   34h+var_8[sp], r1
FFF20F09  6021                              sub     #2, r1
FFF20F0B  a289                              mov.l   r1, 34h+var_8[sp]
FFF20F0D  aa89                   loc_FFF20F0D mov.l   34h+var_8[sp], r1
FFF20F0F  f81400                            mov.b   #0, [r1]
FFF20F12  e5000401                          mov.l   34h+var_24[sp], 34h+var_30[sp]
FFF20F16  a809                   loc_FFF20F16 mov.l   34h+var_30[sp], r1
FFF20F18  a209                              mov.l   r1, 34h+var_10[sp]
FFF20F1A  670d                              rtsd    #0Dh
FFF20F1C  7100dc                 sub_FFF20F1C add     #-24h, sp, sp   ; <<<< FUNC sub_FFF20F1C
FFF20F1F  ef34                              mov.l   r3, r4
FFF20F21  a201                              mov.l   r1, 24h+var_4[sp]
FFF20F23  a18a                              mov.l   r2, 24h+var_8[sp]
FFF20F25  a184                              mov.l   r4, 24h+var_C[sp]
FFF20F27  a98a                              mov.l   24h+var_8[sp], r2
FFF20F29  aa01                              mov.l   24h+var_4[sp], r1
FFF20F2B  710304                            add     #24h+var_20, sp, r3
FFF20F2E  05a33600                          bsr.a   sub_FFF245D1
FFF20F32  a101                              mov.l   r1, 24h+var_14[sp]
FFF20F34  a901                              mov.l   24h+var_14[sp], r1
FFF20F36  6101                              cmp     #0, r1
FFF20F38  200f                              beq.b   loc_FFF20F47
FFF20F3A  a901                              mov.l   24h+var_14[sp], r1
FFF20F3C  6602                              mov.l   #0, r2
FFF20F3E  05e2deff                          bsr.a   sub_FFF1EE20
FFF20F42  f80600                            mov.l   #0, 24h+var_24[sp]
FFF20F45  2e7d                              bra.b   loc_FFF20FC2
FFF20F47  a809                   loc_FFF20F47 mov.l   24h+var_20[sp], r1
FFF20F49  6101                              cmp     #0, r1
FFF20F4B  2110                              bne.b   loc_FFF20F5B
FFF20F4D  6602                              mov.l   #0, r2
FFF20F4F  fb16f5                            mov.l   #-0Bh, r1
FFF20F52  05cedeff                          bsr.a   sub_FFF1EE20
FFF20F56  f80600                            mov.l   #0, 24h+var_24[sp]
FFF20F59  2e69                              bra.b   loc_FFF20FC2
FFF20F5B  a80a                   loc_FFF20F5B mov.l   24h+var_20[sp], r2
FFF20F5D  aa01                              mov.l   24h+var_4[sp], r1
FFF20F5F  054de0ff                          bsr.a   sub_FFF1EFAC
FFF20F63  a081                              mov.l   r1, 24h+var_1C[sp]
FFF20F65  a981                              mov.l   24h+var_C[sp], r1
FFF20F67  72110c06                          add     #60Ch, r1, r1
FFF20F6B  fb3a0002                          mov.l   #200h, r3
FFF20F6F  6602                              mov.l   #0, r2
FFF20F71  ef34                              mov.l   r3, r4
FFF20F73  053cd500                          bsr.a   sub_FFF2E4AF
FFF20F77  3e0300                            mov.l   #0, 24h+var_18[sp]
FFF20F7A  2e33                              bra.b   loc_FFF20FAD
FFF20F7C  a983                   loc_FFF20F7C mov.l   24h+var_C[sp], r3
FFF20F7E  a882                              mov.l   24h+var_1C[sp], r2
FFF20F80  aa01                              mov.l   24h+var_4[sp], r1
FFF20F82  72330c06                          add     #60Ch, r3, r3
FFF20F86  6614                              mov.l   #1, r4
FFF20F88  051ae1ff                          bsr.a   sub_FFF1F0A2
FFF20F8C  a101                              mov.l   r1, 24h+var_14[sp]
FFF20F8E  a901                              mov.l   24h+var_14[sp], r1
FFF20F90  6101                              cmp     #0, r1
FFF20F92  200f                              beq.b   loc_FFF20FA1
FFF20F94  a901                              mov.l   24h+var_14[sp], r1
FFF20F96  6602                              mov.l   #0, r2
FFF20F98  0588deff                          bsr.a   sub_FFF1EE20
FFF20F9C  f80600                            mov.l   #0, 24h+var_24[sp]
FFF20F9F  2e23                              bra.b   loc_FFF20FC2
FFF20FA1  a889                   loc_FFF20FA1 mov.l   24h+var_18[sp], r1
FFF20FA3  6211                              add     #1, r1
FFF20FA5  a089                              mov.l   r1, 24h+var_18[sp]
FFF20FA7  a881                              mov.l   24h+var_1C[sp], r1
FFF20FA9  6211                              add     #1, r1
FFF20FAB  a081                              mov.l   r1, 24h+var_1C[sp]
FFF20FAD  aa01                   loc_FFF20FAD mov.l   24h+var_4[sp], r1
FFF20FAF  b891                              movu.w  4[r1], r1
FFF20FB1  06850103                          cmp     24h+var_18[sp].l, r1
FFF20FB5  2ac7                              bgt.b   loc_FFF20F7C
FFF20FB7  6601                              mov.l   #0, r1
FFF20FB9  ef12                              mov.l   r1, r2
FFF20FBB  0565deff                          bsr.a   sub_FFF1EE20
FFF20FBF  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF20FC2  ec01                   loc_FFF20FC2 mov.l   24h+var_24[sp], r1
FFF20FC4  a109                              mov.l   r1, 24h+var_10[sp]
FFF20FC6  6709                              rtsd    #9
FFF20FC8  7100c8                 sub_FFF20FC8 add     #-38h, sp, sp   ; <<<< FUNC sub_FFF20FC8
FFF20FCB  a309                              mov.l   r1, 38h+var_4[sp]
FFF20FCD  a302                              mov.l   r2, 38h+var_8[sp]
FFF20FCF  e5000d0a                          mov.l   38h+var_4[sp], 38h+var_10[sp]
FFF20FD3  e5000c09                          mov.l   38h+var_8[sp], 38h+var_14[sp]
FFF20FD7  3e0700                            mov.l   #0, 38h+var_1C[sp]
FFF20FDA  3e0200                            mov.l   #0, 38h+var_30[sp]
FFF20FDD  3e0800                            mov.l   #0, 38h+var_18[sp]
FFF20FE0  2e21                              bra.b   loc_FFF21001
FFF20FE2  aa01                   loc_FFF20FE2 mov.l   38h+var_18[sp], r1
FFF20FE4  ef12                              mov.l   r1, r2
FFF20FE6  0689020a                          add     38h+var_10[sp].l, r2
FFF20FEA  8a22                              mov.b   8[r2], r2
FFF20FEC  06890109                          add     38h+var_14[sp].l, r1
FFF20FF0  06051208                          cmp     8[r1].b, r2
FFF20FF4  17                                beq.s   loc_FFF20FFB
FFF20FF5  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF20FF8  38b201                            bra.w   loc_FFF211AA
FFF20FFB  aa01                   loc_FFF20FFB mov.l   38h+var_18[sp], r1
FFF20FFD  6211                              add     #1, r1
FFF20FFF  a201                              mov.l   r1, 38h+var_18[sp]
FFF21001  aa01                   loc_FFF21001 mov.l   38h+var_18[sp], r1
FFF21003  6131                              cmp     #3, r1
FFF21005  29dd                              blt.b   loc_FFF20FE2
FFF21007  3e0807                            mov.l   #7, 38h+var_18[sp]
FFF2100A  3c8b00                            mov.b   #0, 38h+var_1D[sp]
FFF2100D  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF21010  2e66                              bra.b   loc_FFF21076
FFF21012  aa01                   loc_FFF21012 mov.l   38h+var_18[sp], r1
FFF21014  aa82                              mov.l   38h+var_10[sp], r2
FFF21016  fe421e                            mov.b   [r2, r1], r14
FFF21019  755e20                            cmp     #20h, r14 ; ' '
FFF2101C  210c                              bne.b   loc_FFF21028
FFF2101E  710e13                            add     #38h+var_25, sp, r14
FFF21021  660f                              mov.l   #0, r15
FFF21023  fe01ef                            mov.b   r15, [r1, r14]
FFF21026  2e0f                              bra.b   loc_FFF21035
FFF21028  aa02                   loc_FFF21028 mov.l   38h+var_18[sp], r2
FFF2102A  aa83                              mov.l   38h+var_10[sp], r3
FFF2102C  fec32e                            movu.b  [r3, r2], r14
FFF2102F  710f13                            add     #38h+var_25, sp, r15
FFF21032  fe01fe                            mov.b   r14, [r1, r15]
FFF21035  aa01                   loc_FFF21035 mov.l   38h+var_18[sp], r1
FFF21037  aa82                              mov.l   38h+var_10[sp], r2
FFF21039  fe421e                            mov.b   [r2, r1], r14
FFF2103C  755e7e                            cmp     #7Eh, r14 ; '~'
FFF2103F  1a                                bne.s   loc_FFF21049
FFF21040  a889                              mov.l   38h+var_2C[sp], r1
FFF21042  6101                              cmp     #0, r1
FFF21044  1d                                bne.s   loc_FFF21049
FFF21045  f80601                            mov.l   #1, 38h+var_38[sp]
FFF21048  0c                                bra.s   loc_FFF2104C
FFF21049  f80600                 loc_FFF21049 mov.l   #0, 38h+var_38[sp]
FFF2104C  ec01                   loc_FFF2104C mov.l   38h+var_38[sp], r1
FFF2104E  6101                              cmp     #0, r1
FFF21050  200f                              beq.b   loc_FFF2105F
FFF21052  aa01                              mov.l   38h+var_18[sp], r1
FFF21054  710e13                            add     #38h+var_25, sp, r14
FFF21057  660f                              mov.l   #0, r15
FFF21059  fe0e1f                            mov.b   r15, [r14, r1]
FFF2105C  3e0301                            mov.l   #1, 38h+var_2C[sp]
FFF2105F  aa01                   loc_FFF2105F mov.l   38h+var_18[sp], r1
FFF21061  aa82                              mov.l   38h+var_10[sp], r2
FFF21063  fe421e                            mov.b   [r2, r1], r14
FFF21066  755e20                            cmp     #20h, r14 ; ' '
FFF21069  1f                                bne.s   loc_FFF21070
FFF2106A  a881                              mov.l   38h+var_30[sp], r1
FFF2106C  6211                              add     #1, r1
FFF2106E  a081                              mov.l   r1, 38h+var_30[sp]
FFF21070  aa01                   loc_FFF21070 mov.l   38h+var_18[sp], r1
FFF21072  6011                              sub     #1, r1
FFF21074  a201                              mov.l   r1, 38h+var_18[sp]
FFF21076  aa01                   loc_FFF21076 mov.l   38h+var_18[sp], r1
FFF21078  6101                              cmp     #0, r1
FFF2107A  2698                              bpz.b   loc_FFF21012
FFF2107C  3e0800                            mov.l   #0, 38h+var_18[sp]
FFF2107F  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF21082  2e3c                              bra.b   loc_FFF210BE
FFF21084  aa01                   loc_FFF21084 mov.l   38h+var_18[sp], r1
FFF21086  710e13                            add     #38h+var_25, sp, r14
FFF21089  fe4e1e                            mov.b   [r14, r1], r14
FFF2108C  610e                              cmp     #0, r14
FFF2108E  2036                              beq.b   loc_FFF210C4
FFF21090  aa01                              mov.l   38h+var_18[sp], r1
FFF21092  710e13                            add     #38h+var_25, sp, r14
FFF21095  fe4e1e                            mov.b   [r14, r1], r14
FFF21098  755e7e                            cmp     #7Eh, r14 ; '~'
FFF2109B  1f                                bne.s   loc_FFF210A2
FFF2109C  a889                              mov.l   38h+var_2C[sp], r1
FFF2109E  6211                              add     #1, r1
FFF210A0  a089                              mov.l   r1, 38h+var_2C[sp]
FFF210A2  aa01                   loc_FFF210A2 mov.l   38h+var_18[sp], r1
FFF210A4  710e13                            add     #38h+var_25, sp, r14
FFF210A7  fe4e1e                            mov.b   [r14, r1], r14
FFF210AA  aa0a                              mov.l   38h+var_14[sp], r2
FFF210AC  fe421f                            mov.b   [r2, r1], r15
FFF210AF  47fe                              cmp     r15, r14
FFF210B1  17                                beq.s   loc_FFF210B8
FFF210B2  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF210B5  38f500                            bra.w   loc_FFF211AA
FFF210B8  aa01                   loc_FFF210B8 mov.l   38h+var_18[sp], r1
FFF210BA  6211                              add     #1, r1
FFF210BC  a201                              mov.l   r1, 38h+var_18[sp]
FFF210BE  aa01                   loc_FFF210BE mov.l   38h+var_18[sp], r1
FFF210C0  6191                              cmp     #9, r1
FFF210C2  29c2                              blt.b   loc_FFF21084
FFF210C4  3e0807                 loc_FFF210C4 mov.l   #7, 38h+var_18[sp]
FFF210C7  38a300                            bra.w   loc_FFF2116A
FFF210CA  a881                   loc_FFF210CA mov.l   38h+var_30[sp], r1
FFF210CC  6101                              cmp     #0, r1
FFF210CE  aa81                              mov.l   38h+var_10[sp], r1
FFF210D0  cc1e                              mov.b   [r1], r14
FFF210D2  205a                              beq.b   loc_FFF2112C
FFF210D4  aa09                              mov.l   38h+var_14[sp], r1
FFF210D6  06041e                            cmp     [r1].b, r14
FFF210D9  201e                              beq.b   loc_FFF210F7
FFF210DB  ed0e09                            mov.l   38h+var_14[sp], r14
FFF210DE  58e1                              movu.b  [r14], r1
FFF210E0  05f9ca00                          bsr.a   sub_FFF2DBD9
FFF210E4  6101                              cmp     #0, r1
FFF210E6  15                                beq.s   loc_FFF210EB
FFF210E7  f80600                            mov.l   #0, 38h+var_38[sp]
FFF210EA  0c                                bra.s   loc_FFF210EE
FFF210EB  f80601                 loc_FFF210EB mov.l   #1, 38h+var_38[sp]
FFF210EE  ec0e                   loc_FFF210EE mov.l   38h+var_38[sp], r14
FFF210F0  610e                              cmp     #0, r14
FFF210F2  15                                beq.s   loc_FFF210F7
FFF210F3  f80601                            mov.l   #1, 38h+var_38[sp]
FFF210F6  0c                                bra.s   loc_FFF210FA
FFF210F7  f80600                 loc_FFF210F7 mov.l   #0, 38h+var_38[sp]
FFF210FA  ec0e                   loc_FFF210FA mov.l   38h+var_38[sp], r14
FFF210FC  610e                              cmp     #0, r14
FFF210FE  17                                beq.s   loc_FFF21105
FFF210FF  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF21102  38a800                            bra.w   loc_FFF211AA
FFF21105  ed0e0a                 loc_FFF21105 mov.l   38h+var_10[sp], r14
FFF21108  ccee                              mov.b   [r14], r14
FFF2110A  755e7e                            cmp     #7Eh, r14 ; '~'
FFF2110D  214b                              bne.b   loc_FFF21158
FFF2110F  ed0e03                            mov.l   38h+var_2C[sp], r14
FFF21112  610e                              cmp     #0, r14
FFF21114  15                                beq.s   loc_FFF21119
FFF21115  f80600                            mov.l   #0, 38h+var_38[sp]
FFF21118  0c                                bra.s   loc_FFF2111C
FFF21119  f80601                 loc_FFF21119 mov.l   #1, 38h+var_38[sp]
FFF2111C  ec0e                   loc_FFF2111C mov.l   38h+var_38[sp], r14
FFF2111E  610e                              cmp     #0, r14
FFF21120  2153                              bne.b   loc_FFF21173
FFF21122  ed0e03                            mov.l   38h+var_2C[sp], r14
FFF21125  601e                              sub     #1, r14
FFF21127  e70e03                            mov.l   r14, 38h+var_2C[sp]
FFF2112A  2e2e                              bra.b   loc_FFF21158
FFF2112C  755e7e                 loc_FFF2112C cmp     #7Eh, r14 ; '~'
FFF2112F  211a                              bne.b   loc_FFF21149
FFF21131  a889                              mov.l   38h+var_2C[sp], r1
FFF21133  6101                              cmp     #0, r1
FFF21135  15                                beq.s   loc_FFF2113A
FFF21136  f80600                            mov.l   #0, 38h+var_38[sp]
FFF21139  0c                                bra.s   loc_FFF2113D
FFF2113A  f80601                 loc_FFF2113A mov.l   #1, 38h+var_38[sp]
FFF2113D  ec01                   loc_FFF2113D mov.l   38h+var_38[sp], r1
FFF2113F  6101                              cmp     #0, r1
FFF21141  2132                              bne.b   loc_FFF21173
FFF21143  a889                              mov.l   38h+var_2C[sp], r1
FFF21145  6011                              sub     #1, r1
FFF21147  a089                              mov.l   r1, 38h+var_2C[sp]
FFF21149  aa81                   loc_FFF21149 mov.l   38h+var_10[sp], r1
FFF2114B  cc1e                              mov.b   [r1], r14
FFF2114D  aa09                              mov.l   38h+var_14[sp], r1
FFF2114F  06041e                            cmp     [r1].b, r14
FFF21152  16                                beq.s   loc_FFF21158
FFF21153  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF21156  2e54                              bra.b   loc_FFF211AA
FFF21158  aa01                   loc_FFF21158 mov.l   38h+var_18[sp], r1
FFF2115A  6011                              sub     #1, r1
FFF2115C  a201                              mov.l   r1, 38h+var_18[sp]
FFF2115E  aa81                              mov.l   38h+var_10[sp], r1
FFF21160  6211                              add     #1, r1
FFF21162  a281                              mov.l   r1, 38h+var_10[sp]
FFF21164  aa09                              mov.l   38h+var_14[sp], r1
FFF21166  6211                              add     #1, r1
FFF21168  a209                              mov.l   r1, 38h+var_14[sp]
FFF2116A  aa01                   loc_FFF2116A mov.l   38h+var_18[sp], r1
FFF2116C  6101                              cmp     #0, r1
FFF2116E  2b05                              ble.b   loc_FFF21173
FFF21170  385aff                            bra.w   loc_FFF210CA
FFF21173  aa01                   loc_FFF21173 mov.l   38h+var_18[sp], r1
FFF21175  06850102                          cmp     38h+var_30[sp].l, r1
FFF21179  2922                              blt.b   loc_FFF2119B
FFF2117B  aa01                              mov.l   38h+var_18[sp], r1
FFF2117D  06810102                          sub     38h+var_30[sp].l, r1
FFF21181  a201                              mov.l   r1, 38h+var_18[sp]
FFF21183  2e18                              bra.b   loc_FFF2119B
FFF21185  63a1                   loc_FFF21185 mul     #0Ah, r1
FFF21187  a189                              mov.l   r1, 38h+var_1C[sp]
FFF21189  aa81                              mov.l   38h+var_10[sp], r1
FFF2118B  711201                            add     #1, r1, r2
FFF2118E  a282                              mov.l   r2, 38h+var_10[sp]
FFF21190  8819                              mov.b   1[r1], r1
FFF21192  06890107                          add     38h+var_1C[sp].l, r1
FFF21196  7111d0                            add     #-30h, r1, r1
FFF21199  a189                              mov.l   r1, 38h+var_1C[sp]
FFF2119B  aa01                   loc_FFF2119B mov.l   38h+var_18[sp], r1
FFF2119D  7112ff                            add     #-1, r1, r2
FFF211A0  a202                              mov.l   r2, 38h+var_18[sp]
FFF211A2  6101                              cmp     #0, r1
FFF211A4  a989                              mov.l   38h+var_1C[sp], r1
FFF211A6  21df                              bne.b   loc_FFF21185
FFF211A8  a009                              mov.l   r1, 38h+var_34[sp]
FFF211AA  a809                   loc_FFF211AA mov.l   38h+var_34[sp], r1
FFF211AC  a289                              mov.l   r1, 38h+var_C[sp]
FFF211AE  670e                              rtsd    #0Eh
FFF211B0  7100d0                 sub_FFF211B0 add     #-30h, sp, sp   ; <<<< FUNC sub_FFF211B0
FFF211B3  a289                              mov.l   r1, 30h+var_4[sp]
FFF211B5  a282                              mov.l   r2, 30h+var_8[sp]
FFF211B7  a20b                              mov.l   r3, 30h+var_C[sp]
FFF211B9  a204                              mov.l   r4, 30h+var_10[sp]
FFF211BB  e5000d07                          mov.l   30h+arg_0[sp], 30h+var_14[sp]
FFF211BF  aa82                              mov.l   30h+var_8[sp], r2
FFF211C1  aa89                              mov.l   30h+var_4[sp], r1
FFF211C3  3905fe                            bsr.w   sub_FFF20FC8
FFF211C6  a109                              mov.l   r1, 30h+var_1C[sp]
FFF211C8  aa09                              mov.l   30h+var_C[sp], r1
FFF211CA  05ced900                          bsr.a   sub_FFF2EB98
FFF211CE  a101                              mov.l   r1, 30h+var_20[sp]
FFF211D0  e5000803                          mov.l   30h+var_10[sp], 30h+var_24[sp]
FFF211D4  a909                              mov.l   30h+var_1C[sp], r1
FFF211D6  6101                              cmp     #0, r1
FFF211D8  2b1d                              ble.b   loc_FFF211F5
FFF211DA  a889                              mov.l   30h+var_24[sp], r1
FFF211DC  ec1e                              mov.l   [r1], r14
FFF211DE  610e                              cmp     #0, r14
FFF211E0  1e                                bne.s   loc_FFF211E6
FFF211E1  e10105                            mov.l   30h+var_1C[sp], [r1]
FFF211E4  2e11                              bra.b   loc_FFF211F5
FFF211E6  a90a                   loc_FFF211E6 mov.l   30h+var_1C[sp], r2
FFF211E8  6012                              sub     #1, r2
FFF211EA  068412                            cmp     [r1].l, r2
FFF211ED  2808                              bge.b   loc_FFF211F5
FFF211EF  a909                              mov.l   30h+var_1C[sp], r1
FFF211F1  a88a                              mov.l   30h+var_24[sp], r2
FFF211F3  e321                              mov.l   r1, [r2]
FFF211F5  a909                   loc_FFF211F5 mov.l   30h+var_1C[sp], r1
FFF211F7  06850104                          cmp     30h+var_20[sp].l, r1
FFF211FB  290d                              blt.b   loc_FFF21208
FFF211FD  a989                              mov.l   30h+var_14[sp], r1
FFF211FF  581e                              movu.b  [r1], r14
FFF21201  610e                              cmp     #0, r14
FFF21203  1d                                bne.s   loc_FFF21208
FFF21204  f80601                            mov.l   #1, 30h+var_30[sp]
FFF21207  0c                                bra.s   loc_FFF2120B
FFF21208  f80600                 loc_FFF21208 mov.l   #0, 30h+var_30[sp]
FFF2120B  ec01                   loc_FFF2120B mov.l   30h+var_30[sp], r1
FFF2120D  6101                              cmp     #0, r1
FFF2120F  2030                              beq.b   loc_FFF2123F
FFF21211  a909                              mov.l   30h+var_1C[sp], r1
FFF21213  74017f969800                      cmp     #98967Fh, r1
FFF21219  2912                              blt.b   loc_FFF2122B
FFF2121B  66a3                              mov.l   #0Ah, r3
FFF2121D  710204                            add     #30h+var_2C, sp, r2
FFF21220  05a4d900                          bsr.a   sub_FFF2EBC4
FFF21224  a989                              mov.l   30h+var_14[sp], r1
FFF21226  f81401                            mov.b   #1, [r1]
FFF21229  2e0d                              bra.b   loc_FFF21236
FFF2122B  6211                   loc_FFF2122B add     #1, r1
FFF2122D  66a3                              mov.l   #0Ah, r3
FFF2122F  710204                            add     #30h+var_2C, sp, r2
FFF21232  0592d900                          bsr.a   sub_FFF2EBC4
FFF21236  aa09                   loc_FFF21236 mov.l   30h+var_C[sp], r1
FFF21238  710204                            add     #30h+var_2C, sp, r2
FFF2123B  052bd400                          bsr.a   sub_FFF2E666
FFF2123F  3e0600                 loc_FFF2123F mov.l   #0, 30h+var_18[sp]
FFF21242  6601                              mov.l   #0, r1
FFF21244  670c                              rtsd    #0Ch
FFF21246  7100d8                 sub_FFF21246 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF21246
FFF21249  a209                              mov.l   r1, 28h+var_4[sp]
FFF2124B  a202                              mov.l   r2, 28h+var_8[sp]
FFF2124D  a18b                              mov.l   r3, 28h+var_C[sp]
FFF2124F  adbc                              mov.l   5Ch[r3], r4
FFF21251  aa09                              mov.l   28h+var_4[sp], r1
FFF21253  754320                            mov.l   #20h, r3 ; ' '
FFF21256  6602                              mov.l   #0, r2
FFF21258  0557d200                          bsr.a   sub_FFF2E4AF
FFF2125C  a989                              mov.l   28h+var_C[sp], r1
FFF2125E  ad9c                              mov.l   5Ch[r1], r4
FFF21260  aa09                              mov.l   28h+var_4[sp], r1
FFF21262  6211                              add     #1, r1
FFF21264  66a3                              mov.l   #0Ah, r3
FFF21266  fb26ff                            mov.l   #-1, r2
FFF21269  0546d200                          bsr.a   sub_FFF2E4AF
FFF2126D  a989                              mov.l   28h+var_C[sp], r1
FFF2126F  ad9c                              mov.l   5Ch[r1], r4
FFF21271  aa09                              mov.l   28h+var_4[sp], r1
FFF21273  62e1                              add     #0Eh, r1
FFF21275  66c3                              mov.l   #0Ch, r3
FFF21277  fb26ff                            mov.l   #-1, r2
FFF2127A  0535d200                          bsr.a   sub_FFF2E4AF
FFF2127E  a989                              mov.l   28h+var_C[sp], r1
FFF21280  ad9c                              mov.l   5Ch[r1], r4
FFF21282  aa09                              mov.l   28h+var_4[sp], r1
FFF21284  71111c                            add     #1Ch, r1, r1
FFF21287  6643                              mov.l   #4, r3
FFF21289  fb26ff                            mov.l   #-1, r2
FFF2128C  0523d200                          bsr.a   sub_FFF2E4AF
FFF21290  aa09                              mov.l   28h+var_4[sp], r1
FFF21292  6211                              add     #1, r1
FFF21294  a081                              mov.l   r1, 28h+var_20[sp]
FFF21296  e5000803                          mov.l   28h+var_8[sp], 28h+var_1C[sp]
FFF2129A  3e0400                            mov.l   #0, 28h+var_18[sp]
FFF2129D  3e0500                            mov.l   #0, 28h+var_14[sp]
FFF212A0  2e63                              bra.b   loc_FFF21303
FFF212A2  a889                   loc_FFF212A2 mov.l   28h+var_1C[sp], r1
FFF212A4  581e                              movu.b  [r1], r14
FFF212A6  610e                              cmp     #0, r14
FFF212A8  210d                              bne.b   loc_FFF212B5
FFF212AA  a889                              mov.l   28h+var_1C[sp], r1
FFF212AC  b019                              movu.b  1[r1], r1
FFF212AE  6101                              cmp     #0, r1
FFF212B0  1d                                bne.s   loc_FFF212B5
FFF212B1  f80601                            mov.l   #1, 28h+var_28[sp]
FFF212B4  0c                                bra.s   loc_FFF212B8
FFF212B5  f80600                 loc_FFF212B5 mov.l   #0, 28h+var_28[sp]
FFF212B8  ec01                   loc_FFF212B8 mov.l   28h+var_28[sp], r1
FFF212BA  6101                              cmp     #0, r1
FFF212BC  a881                              mov.l   28h+var_20[sp], r1
FFF212BE  2017                              beq.b   loc_FFF212D5
FFF212C0  f81400                            mov.b   #0, [r1]
FFF212C3  a881                              mov.l   28h+var_20[sp], r1
FFF212C5  6211                              add     #1, r1
FFF212C7  a081                              mov.l   r1, 28h+var_20[sp]
FFF212C9  a881                              mov.l   28h+var_20[sp], r1
FFF212CB  f81400                            mov.b   #0, [r1]
FFF212CE  e5000501                          mov.l   28h+var_14[sp], 28h+var_24[sp]
FFF212D2  381f01                            bra.w   loc_FFF213F1
FFF212D5  a88a                   loc_FFF212D5 mov.l   28h+var_1C[sp], r2
FFF212D7  c021                              mov.b   [r2], [r1]
FFF212D9  a881                              mov.l   28h+var_20[sp], r1
FFF212DB  6211                              add     #1, r1
FFF212DD  a081                              mov.l   r1, 28h+var_20[sp]
FFF212DF  a889                              mov.l   28h+var_1C[sp], r1
FFF212E1  6211                              add     #1, r1
FFF212E3  a089                              mov.l   r1, 28h+var_1C[sp]
FFF212E5  a889                              mov.l   28h+var_1C[sp], r1
FFF212E7  a882                              mov.l   28h+var_20[sp], r2
FFF212E9  c012                              mov.b   [r1], [r2]
FFF212EB  a881                              mov.l   28h+var_20[sp], r1
FFF212ED  6211                              add     #1, r1
FFF212EF  a081                              mov.l   r1, 28h+var_20[sp]
FFF212F1  a889                              mov.l   28h+var_1C[sp], r1
FFF212F3  6211                              add     #1, r1
FFF212F5  a089                              mov.l   r1, 28h+var_1C[sp]
FFF212F7  a901                              mov.l   28h+var_18[sp], r1
FFF212F9  6211                              add     #1, r1
FFF212FB  a101                              mov.l   r1, 28h+var_18[sp]
FFF212FD  a909                              mov.l   28h+var_14[sp], r1
FFF212FF  6211                              add     #1, r1
FFF21301  a109                              mov.l   r1, 28h+var_14[sp]
FFF21303  a901                   loc_FFF21303 mov.l   28h+var_18[sp], r1
FFF21305  6151                              cmp     #5, r1
FFF21307  299b                              blt.b   loc_FFF212A2
FFF21309  aa09                              mov.l   28h+var_4[sp], r1
FFF2130B  62e1                              add     #0Eh, r1
FFF2130D  a081                              mov.l   r1, 28h+var_20[sp]
FFF2130F  3e0400                            mov.l   #0, 28h+var_18[sp]
FFF21312  2e63                              bra.b   loc_FFF21375
FFF21314  a889                   loc_FFF21314 mov.l   28h+var_1C[sp], r1
FFF21316  581e                              movu.b  [r1], r14
FFF21318  610e                              cmp     #0, r14
FFF2131A  210d                              bne.b   loc_FFF21327
FFF2131C  a889                              mov.l   28h+var_1C[sp], r1
FFF2131E  b019                              movu.b  1[r1], r1
FFF21320  6101                              cmp     #0, r1
FFF21322  1d                                bne.s   loc_FFF21327
FFF21323  f80601                            mov.l   #1, 28h+var_28[sp]
FFF21326  0c                                bra.s   loc_FFF2132A
FFF21327  f80600                 loc_FFF21327 mov.l   #0, 28h+var_28[sp]
FFF2132A  ec01                   loc_FFF2132A mov.l   28h+var_28[sp], r1
FFF2132C  6101                              cmp     #0, r1
FFF2132E  a881                              mov.l   28h+var_20[sp], r1
FFF21330  2017                              beq.b   loc_FFF21347
FFF21332  f81400                            mov.b   #0, [r1]
FFF21335  a881                              mov.l   28h+var_20[sp], r1
FFF21337  6211                              add     #1, r1
FFF21339  a081                              mov.l   r1, 28h+var_20[sp]
FFF2133B  a881                              mov.l   28h+var_20[sp], r1
FFF2133D  f81400                            mov.b   #0, [r1]
FFF21340  e5000501                          mov.l   28h+var_14[sp], 28h+var_24[sp]
FFF21344  38ad00                            bra.w   loc_FFF213F1
FFF21347  a88a                   loc_FFF21347 mov.l   28h+var_1C[sp], r2
FFF21349  c021                              mov.b   [r2], [r1]
FFF2134B  a881                              mov.l   28h+var_20[sp], r1
FFF2134D  6211                              add     #1, r1
FFF2134F  a081                              mov.l   r1, 28h+var_20[sp]
FFF21351  a889                              mov.l   28h+var_1C[sp], r1
FFF21353  6211                              add     #1, r1
FFF21355  a089                              mov.l   r1, 28h+var_1C[sp]
FFF21357  a889                              mov.l   28h+var_1C[sp], r1
FFF21359  a882                              mov.l   28h+var_20[sp], r2
FFF2135B  c012                              mov.b   [r1], [r2]
FFF2135D  a881                              mov.l   28h+var_20[sp], r1
FFF2135F  6211                              add     #1, r1
FFF21361  a081                              mov.l   r1, 28h+var_20[sp]
FFF21363  a889                              mov.l   28h+var_1C[sp], r1
FFF21365  6211                              add     #1, r1
FFF21367  a089                              mov.l   r1, 28h+var_1C[sp]
FFF21369  a901                              mov.l   28h+var_18[sp], r1
FFF2136B  6211                              add     #1, r1
FFF2136D  a101                              mov.l   r1, 28h+var_18[sp]
FFF2136F  a909                              mov.l   28h+var_14[sp], r1
FFF21371  6211                              add     #1, r1
FFF21373  a109                              mov.l   r1, 28h+var_14[sp]
FFF21375  a901                   loc_FFF21375 mov.l   28h+var_18[sp], r1
FFF21377  6161                              cmp     #6, r1
FFF21379  299b                              blt.b   loc_FFF21314
FFF2137B  aa09                              mov.l   28h+var_4[sp], r1
FFF2137D  71111c                            add     #1Ch, r1, r1
FFF21380  a081                              mov.l   r1, 28h+var_20[sp]
FFF21382  3e0400                            mov.l   #0, 28h+var_18[sp]
FFF21385  2e62                              bra.b   loc_FFF213E7
FFF21387  a889                   loc_FFF21387 mov.l   28h+var_1C[sp], r1
FFF21389  581e                              movu.b  [r1], r14
FFF2138B  610e                              cmp     #0, r14
FFF2138D  210d                              bne.b   loc_FFF2139A
FFF2138F  a889                              mov.l   28h+var_1C[sp], r1
FFF21391  b019                              movu.b  1[r1], r1
FFF21393  6101                              cmp     #0, r1
FFF21395  1d                                bne.s   loc_FFF2139A
FFF21396  f80601                            mov.l   #1, 28h+var_28[sp]
FFF21399  0c                                bra.s   loc_FFF2139D
FFF2139A  f80600                 loc_FFF2139A mov.l   #0, 28h+var_28[sp]
FFF2139D  ec01                   loc_FFF2139D mov.l   28h+var_28[sp], r1
FFF2139F  6101                              cmp     #0, r1
FFF213A1  a881                              mov.l   28h+var_20[sp], r1
FFF213A3  2016                              beq.b   loc_FFF213B9
FFF213A5  f81400                            mov.b   #0, [r1]
FFF213A8  a881                              mov.l   28h+var_20[sp], r1
FFF213AA  6211                              add     #1, r1
FFF213AC  a081                              mov.l   r1, 28h+var_20[sp]
FFF213AE  a881                              mov.l   28h+var_20[sp], r1
FFF213B0  f81400                            mov.b   #0, [r1]
FFF213B3  e5000501                          mov.l   28h+var_14[sp], 28h+var_24[sp]
FFF213B7  2e3a                              bra.b   loc_FFF213F1
FFF213B9  a88a                   loc_FFF213B9 mov.l   28h+var_1C[sp], r2
FFF213BB  c021                              mov.b   [r2], [r1]
FFF213BD  a881                              mov.l   28h+var_20[sp], r1
FFF213BF  6211                              add     #1, r1
FFF213C1  a081                              mov.l   r1, 28h+var_20[sp]
FFF213C3  a889                              mov.l   28h+var_1C[sp], r1
FFF213C5  6211                              add     #1, r1
FFF213C7  a089                              mov.l   r1, 28h+var_1C[sp]
FFF213C9  a889                              mov.l   28h+var_1C[sp], r1
FFF213CB  a882                              mov.l   28h+var_20[sp], r2
FFF213CD  c012                              mov.b   [r1], [r2]
FFF213CF  a881                              mov.l   28h+var_20[sp], r1
FFF213D1  6211                              add     #1, r1
FFF213D3  a081                              mov.l   r1, 28h+var_20[sp]
FFF213D5  a889                              mov.l   28h+var_1C[sp], r1
FFF213D7  6211                              add     #1, r1
FFF213D9  a089                              mov.l   r1, 28h+var_1C[sp]
FFF213DB  a901                              mov.l   28h+var_18[sp], r1
FFF213DD  6211                              add     #1, r1
FFF213DF  a101                              mov.l   r1, 28h+var_18[sp]
FFF213E1  a909                              mov.l   28h+var_14[sp], r1
FFF213E3  6211                              add     #1, r1
FFF213E5  a109                              mov.l   r1, 28h+var_14[sp]
FFF213E7  a901                   loc_FFF213E7 mov.l   28h+var_18[sp], r1
FFF213E9  6121                              cmp     #2, r1
FFF213EB  299c                              blt.b   loc_FFF21387
FFF213ED  e5000501                          mov.l   28h+var_14[sp], 28h+var_24[sp]
FFF213F1  a809                   loc_FFF213F1 mov.l   28h+var_24[sp], r1
FFF213F3  a181                              mov.l   r1, 28h+var_10[sp]
FFF213F5  670a                              rtsd    #0Ah
FFF213F7  7100dc                 sub_FFF213F7 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF213F7
FFF213FA  a201                              mov.l   r1, 24h+var_4[sp]
FFF213FC  a18a                              mov.l   r2, 24h+var_8[sp]
FFF213FE  a082                              mov.l   r2, 24h+var_1C[sp]
FFF21400  aa01                              mov.l   24h+var_4[sp], r1
FFF21402  6211                              add     #1, r1
FFF21404  a089                              mov.l   r1, 24h+var_18[sp]
FFF21406  3e0400                            mov.l   #0, 24h+var_14[sp]
FFF21409  3e0500                            mov.l   #0, 24h+var_10[sp]
FFF2140C  2e58                              bra.b   loc_FFF21464
FFF2140E  a889                   loc_FFF2140E mov.l   24h+var_18[sp], r1
FFF21410  581e                              movu.b  [r1], r14
FFF21412  610e                              cmp     #0, r14
FFF21414  210d                              bne.b   loc_FFF21421
FFF21416  a889                              mov.l   24h+var_18[sp], r1
FFF21418  b019                              movu.b  1[r1], r1
FFF2141A  6101                              cmp     #0, r1
FFF2141C  1d                                bne.s   loc_FFF21421
FFF2141D  f80601                            mov.l   #1, 24h+var_24[sp]
FFF21420  0c                                bra.s   loc_FFF21424
FFF21421  f80600                 loc_FFF21421 mov.l   #0, 24h+var_24[sp]
FFF21424  ec01                   loc_FFF21424 mov.l   24h+var_24[sp], r1
FFF21426  6101                              cmp     #0, r1
FFF21428  a881                              mov.l   24h+var_1C[sp], r1
FFF2142A  200c                              beq.b   loc_FFF21436
FFF2142C  f81400                            mov.b   #0, [r1]
FFF2142F  e5000501                          mov.l   24h+var_10[sp], 24h+var_20[sp]
FFF21433  380d01                            bra.w   loc_FFF21540
FFF21436  a88a                   loc_FFF21436 mov.l   24h+var_18[sp], r2
FFF21438  c021                              mov.b   [r2], [r1]
FFF2143A  a881                              mov.l   24h+var_1C[sp], r1
FFF2143C  6211                              add     #1, r1
FFF2143E  a081                              mov.l   r1, 24h+var_1C[sp]
FFF21440  a889                              mov.l   24h+var_18[sp], r1
FFF21442  6211                              add     #1, r1
FFF21444  a089                              mov.l   r1, 24h+var_18[sp]
FFF21446  a889                              mov.l   24h+var_18[sp], r1
FFF21448  a882                              mov.l   24h+var_1C[sp], r2
FFF2144A  c012                              mov.b   [r1], [r2]
FFF2144C  a881                              mov.l   24h+var_1C[sp], r1
FFF2144E  6211                              add     #1, r1
FFF21450  a081                              mov.l   r1, 24h+var_1C[sp]
FFF21452  a889                              mov.l   24h+var_18[sp], r1
FFF21454  6211                              add     #1, r1
FFF21456  a089                              mov.l   r1, 24h+var_18[sp]
FFF21458  a901                              mov.l   24h+var_14[sp], r1
FFF2145A  6211                              add     #1, r1
FFF2145C  a101                              mov.l   r1, 24h+var_14[sp]
FFF2145E  a909                              mov.l   24h+var_10[sp], r1
FFF21460  6211                              add     #1, r1
FFF21462  a109                              mov.l   r1, 24h+var_10[sp]
FFF21464  a901                   loc_FFF21464 mov.l   24h+var_14[sp], r1
FFF21466  6151                              cmp     #5, r1
FFF21468  29a6                              blt.b   loc_FFF2140E
FFF2146A  aa01                              mov.l   24h+var_4[sp], r1
FFF2146C  62e1                              add     #0Eh, r1
FFF2146E  a089                              mov.l   r1, 24h+var_18[sp]
FFF21470  3e0400                            mov.l   #0, 24h+var_14[sp]
FFF21473  2e58                              bra.b   loc_FFF214CB
FFF21475  a889                   loc_FFF21475 mov.l   24h+var_18[sp], r1
FFF21477  581e                              movu.b  [r1], r14
FFF21479  610e                              cmp     #0, r14
FFF2147B  210d                              bne.b   loc_FFF21488
FFF2147D  a889                              mov.l   24h+var_18[sp], r1
FFF2147F  b019                              movu.b  1[r1], r1
FFF21481  6101                              cmp     #0, r1
FFF21483  1d                                bne.s   loc_FFF21488
FFF21484  f80601                            mov.l   #1, 24h+var_24[sp]
FFF21487  0c                                bra.s   loc_FFF2148B
FFF21488  f80600                 loc_FFF21488 mov.l   #0, 24h+var_24[sp]
FFF2148B  ec01                   loc_FFF2148B mov.l   24h+var_24[sp], r1
FFF2148D  6101                              cmp     #0, r1
FFF2148F  a881                              mov.l   24h+var_1C[sp], r1
FFF21491  200c                              beq.b   loc_FFF2149D
FFF21493  f81400                            mov.b   #0, [r1]
FFF21496  e5000501                          mov.l   24h+var_10[sp], 24h+var_20[sp]
FFF2149A  38a600                            bra.w   loc_FFF21540
FFF2149D  a88a                   loc_FFF2149D mov.l   24h+var_18[sp], r2
FFF2149F  c021                              mov.b   [r2], [r1]
FFF214A1  a881                              mov.l   24h+var_1C[sp], r1
FFF214A3  6211                              add     #1, r1
FFF214A5  a081                              mov.l   r1, 24h+var_1C[sp]
FFF214A7  a889                              mov.l   24h+var_18[sp], r1
FFF214A9  6211                              add     #1, r1
FFF214AB  a089                              mov.l   r1, 24h+var_18[sp]
FFF214AD  a889                              mov.l   24h+var_18[sp], r1
FFF214AF  a882                              mov.l   24h+var_1C[sp], r2
FFF214B1  c012                              mov.b   [r1], [r2]
FFF214B3  a881                              mov.l   24h+var_1C[sp], r1
FFF214B5  6211                              add     #1, r1
FFF214B7  a081                              mov.l   r1, 24h+var_1C[sp]
FFF214B9  a889                              mov.l   24h+var_18[sp], r1
FFF214BB  6211                              add     #1, r1
FFF214BD  a089                              mov.l   r1, 24h+var_18[sp]
FFF214BF  a901                              mov.l   24h+var_14[sp], r1
FFF214C1  6211                              add     #1, r1
FFF214C3  a101                              mov.l   r1, 24h+var_14[sp]
FFF214C5  a909                              mov.l   24h+var_10[sp], r1
FFF214C7  6211                              add     #1, r1
FFF214C9  a109                              mov.l   r1, 24h+var_10[sp]
FFF214CB  a901                   loc_FFF214CB mov.l   24h+var_14[sp], r1
FFF214CD  6161                              cmp     #6, r1
FFF214CF  29a6                              blt.b   loc_FFF21475
FFF214D1  aa01                              mov.l   24h+var_4[sp], r1
FFF214D3  71111c                            add     #1Ch, r1, r1
FFF214D6  a089                              mov.l   r1, 24h+var_18[sp]
FFF214D8  3e0400                            mov.l   #0, 24h+var_14[sp]
FFF214DB  2e56                              bra.b   loc_FFF21531
FFF214DD  a889                   loc_FFF214DD mov.l   24h+var_18[sp], r1
FFF214DF  581e                              movu.b  [r1], r14
FFF214E1  610e                              cmp     #0, r14
FFF214E3  210d                              bne.b   loc_FFF214F0
FFF214E5  a889                              mov.l   24h+var_18[sp], r1
FFF214E7  b019                              movu.b  1[r1], r1
FFF214E9  6101                              cmp     #0, r1
FFF214EB  1d                                bne.s   loc_FFF214F0
FFF214EC  f80601                            mov.l   #1, 24h+var_24[sp]
FFF214EF  0c                                bra.s   loc_FFF214F3
FFF214F0  f80600                 loc_FFF214F0 mov.l   #0, 24h+var_24[sp]
FFF214F3  ec01                   loc_FFF214F3 mov.l   24h+var_24[sp], r1
FFF214F5  6101                              cmp     #0, r1
FFF214F7  a881                              mov.l   24h+var_1C[sp], r1
FFF214F9  12                                beq.s   loc_FFF21503
FFF214FA  f81400                            mov.b   #0, [r1]
FFF214FD  e5000501                          mov.l   24h+var_10[sp], 24h+var_20[sp]
FFF21501  2e3f                              bra.b   loc_FFF21540
FFF21503  a88a                   loc_FFF21503 mov.l   24h+var_18[sp], r2
FFF21505  c021                              mov.b   [r2], [r1]
FFF21507  a881                              mov.l   24h+var_1C[sp], r1
FFF21509  6211                              add     #1, r1
FFF2150B  a081                              mov.l   r1, 24h+var_1C[sp]
FFF2150D  a889                              mov.l   24h+var_18[sp], r1
FFF2150F  6211                              add     #1, r1
FFF21511  a089                              mov.l   r1, 24h+var_18[sp]
FFF21513  a889                              mov.l   24h+var_18[sp], r1
FFF21515  a882                              mov.l   24h+var_1C[sp], r2
FFF21517  c012                              mov.b   [r1], [r2]
FFF21519  a881                              mov.l   24h+var_1C[sp], r1
FFF2151B  6211                              add     #1, r1
FFF2151D  a081                              mov.l   r1, 24h+var_1C[sp]
FFF2151F  a889                              mov.l   24h+var_18[sp], r1
FFF21521  6211                              add     #1, r1
FFF21523  a089                              mov.l   r1, 24h+var_18[sp]
FFF21525  a901                              mov.l   24h+var_14[sp], r1
FFF21527  6211                              add     #1, r1
FFF21529  a101                              mov.l   r1, 24h+var_14[sp]
FFF2152B  a909                              mov.l   24h+var_10[sp], r1
FFF2152D  6211                              add     #1, r1
FFF2152F  a109                              mov.l   r1, 24h+var_10[sp]
FFF21531  a901                   loc_FFF21531 mov.l   24h+var_14[sp], r1
FFF21533  6121                              cmp     #2, r1
FFF21535  29a8                              blt.b   loc_FFF214DD
FFF21537  a881                              mov.l   24h+var_1C[sp], r1
FFF21539  f81400                            mov.b   #0, [r1]
FFF2153C  e5000501                          mov.l   24h+var_10[sp], 24h+var_20[sp]
FFF21540  a809                   loc_FFF21540 mov.l   24h+var_20[sp], r1
FFF21542  a181                              mov.l   r1, 24h+var_C[sp]
FFF21544  6709                              rtsd    #9
FFF21546  7100e4                 sub_FFF21546 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF21546
FFF21549  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2154B  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2154D  e5000603                          mov.l   1Ch+var_4[sp], 1Ch+var_10[sp]
FFF21551  e5000502                          mov.l   1Ch+var_8[sp], 1Ch+var_14[sp]
FFF21555  a889                              mov.l   1Ch+var_10[sp], r1
FFF21557  b019                              movu.b  1[r1], r1
FFF21559  6101                              cmp     #0, r1
FFF2155B  210d                              bne.b   loc_FFF21568
FFF2155D  a881                              mov.l   1Ch+var_14[sp], r1
FFF2155F  b019                              movu.b  1[r1], r1
FFF21561  6101                              cmp     #0, r1
FFF21563  1d                                bne.s   loc_FFF21568
FFF21564  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21567  0c                                bra.s   loc_FFF2156B
FFF21568  f80600                 loc_FFF21568 mov.l   #0, 1Ch+var_1C[sp]
FFF2156B  ec01                   loc_FFF2156B mov.l   1Ch+var_1C[sp], r1
FFF2156D  6101                              cmp     #0, r1
FFF2156F  3a7d00                            beq.w   loc_FFF215EC
FFF21572  a889                              mov.l   1Ch+var_10[sp], r1
FFF21574  581e                              movu.b  [r1], r14
FFF21576  755e41                            cmp     #41h, r14 ; 'A'
FFF21579  290f                              blt.b   loc_FFF21588
FFF2157B  a889                              mov.l   1Ch+var_10[sp], r1
FFF2157D  581e                              movu.b  [r1], r14
FFF2157F  755e5a                            cmp     #5Ah, r14 ; 'Z'
FFF21582  2a06                              bgt.b   loc_FFF21588
FFF21584  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21587  0c                                bra.s   loc_FFF2158B
FFF21588  f80600                 loc_FFF21588 mov.l   #0, 1Ch+var_1C[sp]
FFF2158B  ec01                   loc_FFF2158B mov.l   1Ch+var_1C[sp], r1
FFF2158D  6101                              cmp     #0, r1
FFF2158F  2012                              beq.b   loc_FFF215A1
FFF21591  a881                              mov.l   1Ch+var_14[sp], r1
FFF21593  a88a                              mov.l   1Ch+var_10[sp], r2
FFF21595  582e                              movu.b  [r2], r14
FFF21597  71ee20                            add     #20h, r14, r14 ; ' '
FFF2159A  441e                              cmp     [r1], r14
FFF2159C  1d                                bne.s   loc_FFF215A1
FFF2159D  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF215A0  0c                                bra.s   loc_FFF215A4
FFF215A1  f80600                 loc_FFF215A1 mov.l   #0, 1Ch+var_1C[sp]
FFF215A4  ec01                   loc_FFF215A4 mov.l   1Ch+var_1C[sp], r1
FFF215A6  6101                              cmp     #0, r1
FFF215A8  17                                beq.s   loc_FFF215AF
FFF215A9  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF215AC  386603                            bra.w   loc_FFF21912
FFF215AF  a889                   loc_FFF215AF mov.l   1Ch+var_10[sp], r1
FFF215B1  581e                              movu.b  [r1], r14
FFF215B3  755e61                            cmp     #61h, r14 ; 'a'
FFF215B6  290f                              blt.b   loc_FFF215C5
FFF215B8  a889                              mov.l   1Ch+var_10[sp], r1
FFF215BA  581e                              movu.b  [r1], r14
FFF215BC  755e7a                            cmp     #7Ah, r14 ; 'z'
FFF215BF  2a06                              bgt.b   loc_FFF215C5
FFF215C1  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF215C4  0c                                bra.s   loc_FFF215C8
FFF215C5  f80600                 loc_FFF215C5 mov.l   #0, 1Ch+var_1C[sp]
FFF215C8  ec01                   loc_FFF215C8 mov.l   1Ch+var_1C[sp], r1
FFF215CA  6101                              cmp     #0, r1
FFF215CC  2012                              beq.b   loc_FFF215DE
FFF215CE  a881                              mov.l   1Ch+var_14[sp], r1
FFF215D0  a88a                              mov.l   1Ch+var_10[sp], r2
FFF215D2  582e                              movu.b  [r2], r14
FFF215D4  71eee0                            add     #-20h, r14, r14
FFF215D7  441e                              cmp     [r1], r14
FFF215D9  1d                                bne.s   loc_FFF215DE
FFF215DA  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF215DD  0c                                bra.s   loc_FFF215E1
FFF215DE  f80600                 loc_FFF215DE mov.l   #0, 1Ch+var_1C[sp]
FFF215E1  ec01                   loc_FFF215E1 mov.l   1Ch+var_1C[sp], r1
FFF215E3  6101                              cmp     #0, r1
FFF215E5  17                                beq.s   loc_FFF215EC
FFF215E6  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF215E9  382903                            bra.w   loc_FFF21912
FFF215EC  a889                   loc_FFF215EC mov.l   1Ch+var_10[sp], r1
FFF215EE  b019                              movu.b  1[r1], r1
FFF215F0  7551ff                            cmp     #-1, r1
FFF215F3  210e                              bne.b   loc_FFF21601
FFF215F5  a881                              mov.l   1Ch+var_14[sp], r1
FFF215F7  b019                              movu.b  1[r1], r1
FFF215F9  7551ff                            cmp     #-1, r1
FFF215FC  1d                                bne.s   loc_FFF21601
FFF215FD  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21600  0c                                bra.s   loc_FFF21604
FFF21601  f80600                 loc_FFF21601 mov.l   #0, 1Ch+var_1C[sp]
FFF21604  ec01                   loc_FFF21604 mov.l   1Ch+var_1C[sp], r1
FFF21606  6101                              cmp     #0, r1
FFF21608  3a7d00                            beq.w   loc_FFF21685
FFF2160B  a889                              mov.l   1Ch+var_10[sp], r1
FFF2160D  581e                              movu.b  [r1], r14
FFF2160F  755e21                            cmp     #21h, r14 ; '!'
FFF21612  290f                              blt.b   loc_FFF21621
FFF21614  a889                              mov.l   1Ch+var_10[sp], r1
FFF21616  581e                              movu.b  [r1], r14
FFF21618  755e3a                            cmp     #3Ah, r14 ; ':'
FFF2161B  2a06                              bgt.b   loc_FFF21621
FFF2161D  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21620  0c                                bra.s   loc_FFF21624
FFF21621  f80600                 loc_FFF21621 mov.l   #0, 1Ch+var_1C[sp]
FFF21624  ec01                   loc_FFF21624 mov.l   1Ch+var_1C[sp], r1
FFF21626  6101                              cmp     #0, r1
FFF21628  2012                              beq.b   loc_FFF2163A
FFF2162A  a881                              mov.l   1Ch+var_14[sp], r1
FFF2162C  a88a                              mov.l   1Ch+var_10[sp], r2
FFF2162E  582e                              movu.b  [r2], r14
FFF21630  71ee20                            add     #20h, r14, r14 ; ' '
FFF21633  441e                              cmp     [r1], r14
FFF21635  1d                                bne.s   loc_FFF2163A
FFF21636  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21639  0c                                bra.s   loc_FFF2163D
FFF2163A  f80600                 loc_FFF2163A mov.l   #0, 1Ch+var_1C[sp]
FFF2163D  ec01                   loc_FFF2163D mov.l   1Ch+var_1C[sp], r1
FFF2163F  6101                              cmp     #0, r1
FFF21641  17                                beq.s   loc_FFF21648
FFF21642  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF21645  38cd02                            bra.w   loc_FFF21912
FFF21648  a889                   loc_FFF21648 mov.l   1Ch+var_10[sp], r1
FFF2164A  581e                              movu.b  [r1], r14
FFF2164C  755e41                            cmp     #41h, r14 ; 'A'
FFF2164F  290f                              blt.b   loc_FFF2165E
FFF21651  a889                              mov.l   1Ch+var_10[sp], r1
FFF21653  581e                              movu.b  [r1], r14
FFF21655  755e5a                            cmp     #5Ah, r14 ; 'Z'
FFF21658  2a06                              bgt.b   loc_FFF2165E
FFF2165A  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF2165D  0c                                bra.s   loc_FFF21661
FFF2165E  f80600                 loc_FFF2165E mov.l   #0, 1Ch+var_1C[sp]
FFF21661  ec01                   loc_FFF21661 mov.l   1Ch+var_1C[sp], r1
FFF21663  6101                              cmp     #0, r1
FFF21665  2012                              beq.b   loc_FFF21677
FFF21667  a881                              mov.l   1Ch+var_14[sp], r1
FFF21669  a88a                              mov.l   1Ch+var_10[sp], r2
FFF2166B  582e                              movu.b  [r2], r14
FFF2166D  71eee0                            add     #-20h, r14, r14
FFF21670  441e                              cmp     [r1], r14
FFF21672  1d                                bne.s   loc_FFF21677
FFF21673  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21676  0c                                bra.s   loc_FFF2167A
FFF21677  f80600                 loc_FFF21677 mov.l   #0, 1Ch+var_1C[sp]
FFF2167A  ec01                   loc_FFF2167A mov.l   1Ch+var_1C[sp], r1
FFF2167C  6101                              cmp     #0, r1
FFF2167E  17                                beq.s   loc_FFF21685
FFF2167F  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF21682  389002                            bra.w   loc_FFF21912
FFF21685  a889                   loc_FFF21685 mov.l   1Ch+var_10[sp], r1
FFF21687  b019                              movu.b  1[r1], r1
FFF21689  6131                              cmp     #3, r1
FFF2168B  210d                              bne.b   loc_FFF21698
FFF2168D  a881                              mov.l   1Ch+var_14[sp], r1
FFF2168F  b019                              movu.b  1[r1], r1
FFF21691  6131                              cmp     #3, r1
FFF21693  1d                                bne.s   loc_FFF21698
FFF21694  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21697  0c                                bra.s   loc_FFF2169B
FFF21698  f80600                 loc_FFF21698 mov.l   #0, 1Ch+var_1C[sp]
FFF2169B  ec01                   loc_FFF2169B mov.l   1Ch+var_1C[sp], r1
FFF2169D  6101                              cmp     #0, r1
FFF2169F  3af700                            beq.w   loc_FFF21796
FFF216A2  a889                              mov.l   1Ch+var_10[sp], r1
FFF216A4  581e                              movu.b  [r1], r14
FFF216A6  755e91                            cmp     #-6Fh, r14
FFF216A9  290f                              blt.b   loc_FFF216B8
FFF216AB  a889                              mov.l   1Ch+var_10[sp], r1
FFF216AD  581e                              movu.b  [r1], r14
FFF216AF  755ea1                            cmp     #-5Fh, r14
FFF216B2  2a06                              bgt.b   loc_FFF216B8
FFF216B4  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF216B7  0c                                bra.s   loc_FFF216BB
FFF216B8  f80600                 loc_FFF216B8 mov.l   #0, 1Ch+var_1C[sp]
FFF216BB  ec01                   loc_FFF216BB mov.l   1Ch+var_1C[sp], r1
FFF216BD  6101                              cmp     #0, r1
FFF216BF  2012                              beq.b   loc_FFF216D1
FFF216C1  a881                              mov.l   1Ch+var_14[sp], r1
FFF216C3  a88a                              mov.l   1Ch+var_10[sp], r2
FFF216C5  582e                              movu.b  [r2], r14
FFF216C7  71ee20                            add     #20h, r14, r14 ; ' '
FFF216CA  441e                              cmp     [r1], r14
FFF216CC  1d                                bne.s   loc_FFF216D1
FFF216CD  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF216D0  0c                                bra.s   loc_FFF216D4
FFF216D1  f80600                 loc_FFF216D1 mov.l   #0, 1Ch+var_1C[sp]
FFF216D4  ec01                   loc_FFF216D4 mov.l   1Ch+var_1C[sp], r1
FFF216D6  6101                              cmp     #0, r1
FFF216D8  17                                beq.s   loc_FFF216DF
FFF216D9  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF216DC  383602                            bra.w   loc_FFF21912
FFF216DF  a889                   loc_FFF216DF mov.l   1Ch+var_10[sp], r1
FFF216E1  581e                              movu.b  [r1], r14
FFF216E3  755ea3                            cmp     #-5Dh, r14
FFF216E6  290f                              blt.b   loc_FFF216F5
FFF216E8  a889                              mov.l   1Ch+var_10[sp], r1
FFF216EA  581e                              movu.b  [r1], r14
FFF216EC  755ea9                            cmp     #-57h, r14
FFF216EF  2a06                              bgt.b   loc_FFF216F5
FFF216F1  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF216F4  0c                                bra.s   loc_FFF216F8
FFF216F5  f80600                 loc_FFF216F5 mov.l   #0, 1Ch+var_1C[sp]
FFF216F8  ec01                   loc_FFF216F8 mov.l   1Ch+var_1C[sp], r1
FFF216FA  6101                              cmp     #0, r1
FFF216FC  2012                              beq.b   loc_FFF2170E
FFF216FE  a881                              mov.l   1Ch+var_14[sp], r1
FFF21700  a88a                              mov.l   1Ch+var_10[sp], r2
FFF21702  582e                              movu.b  [r2], r14
FFF21704  71ee20                            add     #20h, r14, r14 ; ' '
FFF21707  441e                              cmp     [r1], r14
FFF21709  1d                                bne.s   loc_FFF2170E
FFF2170A  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF2170D  0c                                bra.s   loc_FFF21711
FFF2170E  f80600                 loc_FFF2170E mov.l   #0, 1Ch+var_1C[sp]
FFF21711  ec01                   loc_FFF21711 mov.l   1Ch+var_1C[sp], r1
FFF21713  6101                              cmp     #0, r1
FFF21715  17                                beq.s   loc_FFF2171C
FFF21716  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF21719  38f901                            bra.w   loc_FFF21912
FFF2171C  a889                   loc_FFF2171C mov.l   1Ch+var_10[sp], r1
FFF2171E  581e                              movu.b  [r1], r14
FFF21720  755eb1                            cmp     #-4Fh, r14
FFF21723  290f                              blt.b   loc_FFF21732
FFF21725  a889                              mov.l   1Ch+var_10[sp], r1
FFF21727  581e                              movu.b  [r1], r14
FFF21729  755ec1                            cmp     #-3Fh, r14
FFF2172C  2a06                              bgt.b   loc_FFF21732
FFF2172E  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21731  0c                                bra.s   loc_FFF21735
FFF21732  f80600                 loc_FFF21732 mov.l   #0, 1Ch+var_1C[sp]
FFF21735  ec01                   loc_FFF21735 mov.l   1Ch+var_1C[sp], r1
FFF21737  6101                              cmp     #0, r1
FFF21739  2012                              beq.b   loc_FFF2174B
FFF2173B  a881                              mov.l   1Ch+var_14[sp], r1
FFF2173D  a88a                              mov.l   1Ch+var_10[sp], r2
FFF2173F  582e                              movu.b  [r2], r14
FFF21741  71eee0                            add     #-20h, r14, r14
FFF21744  441e                              cmp     [r1], r14
FFF21746  1d                                bne.s   loc_FFF2174B
FFF21747  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF2174A  0c                                bra.s   loc_FFF2174E
FFF2174B  f80600                 loc_FFF2174B mov.l   #0, 1Ch+var_1C[sp]
FFF2174E  ec01                   loc_FFF2174E mov.l   1Ch+var_1C[sp], r1
FFF21750  6101                              cmp     #0, r1
FFF21752  17                                beq.s   loc_FFF21759
FFF21753  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF21756  38bc01                            bra.w   loc_FFF21912
FFF21759  a889                   loc_FFF21759 mov.l   1Ch+var_10[sp], r1
FFF2175B  581e                              movu.b  [r1], r14
FFF2175D  755ec3                            cmp     #-3Dh, r14
FFF21760  290f                              blt.b   loc_FFF2176F
FFF21762  a889                              mov.l   1Ch+var_10[sp], r1
FFF21764  581e                              movu.b  [r1], r14
FFF21766  755ec9                            cmp     #-37h, r14
FFF21769  2a06                              bgt.b   loc_FFF2176F
FFF2176B  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF2176E  0c                                bra.s   loc_FFF21772
FFF2176F  f80600                 loc_FFF2176F mov.l   #0, 1Ch+var_1C[sp]
FFF21772  ec01                   loc_FFF21772 mov.l   1Ch+var_1C[sp], r1
FFF21774  6101                              cmp     #0, r1
FFF21776  2012                              beq.b   loc_FFF21788
FFF21778  a881                              mov.l   1Ch+var_14[sp], r1
FFF2177A  a88a                              mov.l   1Ch+var_10[sp], r2
FFF2177C  582e                              movu.b  [r2], r14
FFF2177E  71eee0                            add     #-20h, r14, r14
FFF21781  441e                              cmp     [r1], r14
FFF21783  1d                                bne.s   loc_FFF21788
FFF21784  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21787  0c                                bra.s   loc_FFF2178B
FFF21788  f80600                 loc_FFF21788 mov.l   #0, 1Ch+var_1C[sp]
FFF2178B  ec01                   loc_FFF2178B mov.l   1Ch+var_1C[sp], r1
FFF2178D  6101                              cmp     #0, r1
FFF2178F  17                                beq.s   loc_FFF21796
FFF21790  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF21793  387f01                            bra.w   loc_FFF21912
FFF21796  a889                   loc_FFF21796 mov.l   1Ch+var_10[sp], r1
FFF21798  b019                              movu.b  1[r1], r1
FFF2179A  6141                              cmp     #4, r1
FFF2179C  210d                              bne.b   loc_FFF217A9
FFF2179E  a881                              mov.l   1Ch+var_14[sp], r1
FFF217A0  b019                              movu.b  1[r1], r1
FFF217A2  6141                              cmp     #4, r1
FFF217A4  1d                                bne.s   loc_FFF217A9
FFF217A5  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF217A8  0c                                bra.s   loc_FFF217AC
FFF217A9  f80600                 loc_FFF217A9 mov.l   #0, 1Ch+var_1C[sp]
FFF217AC  ec01                   loc_FFF217AC mov.l   1Ch+var_1C[sp], r1
FFF217AE  6101                              cmp     #0, r1
FFF217B0  3ac900                            beq.w   loc_FFF21879
FFF217B3  a889                              mov.l   1Ch+var_10[sp], r1
FFF217B5  581e                              movu.b  [r1], r14
FFF217B7  61fe                              cmp     #0Fh, r14
FFF217B9  2b0f                              ble.b   loc_FFF217C8
FFF217BB  a889                              mov.l   1Ch+var_10[sp], r1
FFF217BD  581e                              movu.b  [r1], r14
FFF217BF  755e2f                            cmp     #2Fh, r14 ; '/'
FFF217C2  2a06                              bgt.b   loc_FFF217C8
FFF217C4  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF217C7  0c                                bra.s   loc_FFF217CB
FFF217C8  f80600                 loc_FFF217C8 mov.l   #0, 1Ch+var_1C[sp]
FFF217CB  ec01                   loc_FFF217CB mov.l   1Ch+var_1C[sp], r1
FFF217CD  6101                              cmp     #0, r1
FFF217CF  2012                              beq.b   loc_FFF217E1
FFF217D1  a881                              mov.l   1Ch+var_14[sp], r1
FFF217D3  a88a                              mov.l   1Ch+var_10[sp], r2
FFF217D5  582e                              movu.b  [r2], r14
FFF217D7  71ee20                            add     #20h, r14, r14 ; ' '
FFF217DA  441e                              cmp     [r1], r14
FFF217DC  1d                                bne.s   loc_FFF217E1
FFF217DD  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF217E0  0c                                bra.s   loc_FFF217E4
FFF217E1  f80600                 loc_FFF217E1 mov.l   #0, 1Ch+var_1C[sp]
FFF217E4  ec01                   loc_FFF217E4 mov.l   1Ch+var_1C[sp], r1
FFF217E6  6101                              cmp     #0, r1
FFF217E8  17                                beq.s   loc_FFF217EF
FFF217E9  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF217EC  382601                            bra.w   loc_FFF21912
FFF217EF  a889                   loc_FFF217EF mov.l   1Ch+var_10[sp], r1
FFF217F1  581e                              movu.b  [r1], r14
FFF217F3  611e                              cmp     #1, r14
FFF217F5  2112                              bne.b   loc_FFF21807
FFF217F7  a881                              mov.l   1Ch+var_14[sp], r1
FFF217F9  a88a                              mov.l   1Ch+var_10[sp], r2
FFF217FB  582e                              movu.b  [r2], r14
FFF217FD  71ee50                            add     #50h, r14, r14 ; 'P'
FFF21800  441e                              cmp     [r1], r14
FFF21802  1d                                bne.s   loc_FFF21807
FFF21803  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21806  0c                                bra.s   loc_FFF2180A
FFF21807  f80600                 loc_FFF21807 mov.l   #0, 1Ch+var_1C[sp]
FFF2180A  ec01                   loc_FFF2180A mov.l   1Ch+var_1C[sp], r1
FFF2180C  6101                              cmp     #0, r1
FFF2180E  17                                beq.s   loc_FFF21815
FFF2180F  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF21812  380001                            bra.w   loc_FFF21912
FFF21815  a889                   loc_FFF21815 mov.l   1Ch+var_10[sp], r1
FFF21817  581e                              movu.b  [r1], r14
FFF21819  755e30                            cmp     #30h, r14 ; '0'
FFF2181C  290f                              blt.b   loc_FFF2182B
FFF2181E  a889                              mov.l   1Ch+var_10[sp], r1
FFF21820  581e                              movu.b  [r1], r14
FFF21822  755e4f                            cmp     #4Fh, r14 ; 'O'
FFF21825  2a06                              bgt.b   loc_FFF2182B
FFF21827  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF2182A  0c                                bra.s   loc_FFF2182E
FFF2182B  f80600                 loc_FFF2182B mov.l   #0, 1Ch+var_1C[sp]
FFF2182E  ec01                   loc_FFF2182E mov.l   1Ch+var_1C[sp], r1
FFF21830  6101                              cmp     #0, r1
FFF21832  2012                              beq.b   loc_FFF21844
FFF21834  a881                              mov.l   1Ch+var_14[sp], r1
FFF21836  a88a                              mov.l   1Ch+var_10[sp], r2
FFF21838  582e                              movu.b  [r2], r14
FFF2183A  71eee0                            add     #-20h, r14, r14
FFF2183D  441e                              cmp     [r1], r14
FFF2183F  1d                                bne.s   loc_FFF21844
FFF21840  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21843  0c                                bra.s   loc_FFF21847
FFF21844  f80600                 loc_FFF21844 mov.l   #0, 1Ch+var_1C[sp]
FFF21847  ec01                   loc_FFF21847 mov.l   1Ch+var_1C[sp], r1
FFF21849  6101                              cmp     #0, r1
FFF2184B  17                                beq.s   loc_FFF21852
FFF2184C  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF2184F  38c300                            bra.w   loc_FFF21912
FFF21852  a889                   loc_FFF21852 mov.l   1Ch+var_10[sp], r1
FFF21854  581e                              movu.b  [r1], r14
FFF21856  755e51                            cmp     #51h, r14 ; 'Q'
FFF21859  2112                              bne.b   loc_FFF2186B
FFF2185B  a881                              mov.l   1Ch+var_14[sp], r1
FFF2185D  a88a                              mov.l   1Ch+var_10[sp], r2
FFF2185F  582e                              movu.b  [r2], r14
FFF21861  71eeb0                            add     #-50h, r14, r14
FFF21864  441e                              cmp     [r1], r14
FFF21866  1d                                bne.s   loc_FFF2186B
FFF21867  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF2186A  0c                                bra.s   loc_FFF2186E
FFF2186B  f80600                 loc_FFF2186B mov.l   #0, 1Ch+var_1C[sp]
FFF2186E  ec01                   loc_FFF2186E mov.l   1Ch+var_1C[sp], r1
FFF21870  6101                              cmp     #0, r1
FFF21872  17                                beq.s   loc_FFF21879
FFF21873  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF21876  389c00                            bra.w   loc_FFF21912
FFF21879  a889                   loc_FFF21879 mov.l   1Ch+var_10[sp], r1
FFF2187B  b019                              movu.b  1[r1], r1
FFF2187D  755121                            cmp     #21h, r1 ; '!'
FFF21880  210e                              bne.b   loc_FFF2188E
FFF21882  a881                              mov.l   1Ch+var_14[sp], r1
FFF21884  b019                              movu.b  1[r1], r1
FFF21886  755121                            cmp     #21h, r1 ; '!'
FFF21889  1d                                bne.s   loc_FFF2188E
FFF2188A  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF2188D  0c                                bra.s   loc_FFF21891
FFF2188E  f80600                 loc_FFF2188E mov.l   #0, 1Ch+var_1C[sp]
FFF21891  ec01                   loc_FFF21891 mov.l   1Ch+var_1C[sp], r1
FFF21893  6101                              cmp     #0, r1
FFF21895  3a7a00                            beq.w   loc_FFF2190F
FFF21898  a889                              mov.l   1Ch+var_10[sp], r1
FFF2189A  581e                              movu.b  [r1], r14
FFF2189C  755e60                            cmp     #60h, r14 ; '`'
FFF2189F  290f                              blt.b   loc_FFF218AE
FFF218A1  a889                              mov.l   1Ch+var_10[sp], r1
FFF218A3  581e                              movu.b  [r1], r14
FFF218A5  755e69                            cmp     #69h, r14 ; 'i'
FFF218A8  2a06                              bgt.b   loc_FFF218AE
FFF218AA  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF218AD  0c                                bra.s   loc_FFF218B1
FFF218AE  f80600                 loc_FFF218AE mov.l   #0, 1Ch+var_1C[sp]
FFF218B1  ec01                   loc_FFF218B1 mov.l   1Ch+var_1C[sp], r1
FFF218B3  6101                              cmp     #0, r1
FFF218B5  2012                              beq.b   loc_FFF218C7
FFF218B7  a881                              mov.l   1Ch+var_14[sp], r1
FFF218B9  a88a                              mov.l   1Ch+var_10[sp], r2
FFF218BB  582e                              movu.b  [r2], r14
FFF218BD  71ee10                            add     #10h, r14, r14
FFF218C0  441e                              cmp     [r1], r14
FFF218C2  1d                                bne.s   loc_FFF218C7
FFF218C3  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF218C6  0c                                bra.s   loc_FFF218CA
FFF218C7  f80600                 loc_FFF218C7 mov.l   #0, 1Ch+var_1C[sp]
FFF218CA  ec01                   loc_FFF218CA mov.l   1Ch+var_1C[sp], r1
FFF218CC  6101                              cmp     #0, r1
FFF218CE  16                                beq.s   loc_FFF218D4
FFF218CF  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF218D2  2e40                              bra.b   loc_FFF21912
FFF218D4  a889                   loc_FFF218D4 mov.l   1Ch+var_10[sp], r1
FFF218D6  581e                              movu.b  [r1], r14
FFF218D8  755e70                            cmp     #70h, r14 ; 'p'
FFF218DB  290f                              blt.b   loc_FFF218EA
FFF218DD  a889                              mov.l   1Ch+var_10[sp], r1
FFF218DF  581e                              movu.b  [r1], r14
FFF218E1  755e79                            cmp     #79h, r14 ; 'y'
FFF218E4  2a06                              bgt.b   loc_FFF218EA
FFF218E6  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF218E9  0c                                bra.s   loc_FFF218ED
FFF218EA  f80600                 loc_FFF218EA mov.l   #0, 1Ch+var_1C[sp]
FFF218ED  ec01                   loc_FFF218ED mov.l   1Ch+var_1C[sp], r1
FFF218EF  6101                              cmp     #0, r1
FFF218F1  2012                              beq.b   loc_FFF21903
FFF218F3  a881                              mov.l   1Ch+var_14[sp], r1
FFF218F5  a88a                              mov.l   1Ch+var_10[sp], r2
FFF218F7  582e                              movu.b  [r2], r14
FFF218F9  71eef0                            add     #-10h, r14, r14
FFF218FC  441e                              cmp     [r1], r14
FFF218FE  1d                                bne.s   loc_FFF21903
FFF218FF  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF21902  0c                                bra.s   loc_FFF21906
FFF21903  f80600                 loc_FFF21903 mov.l   #0, 1Ch+var_1C[sp]
FFF21906  ec01                   loc_FFF21906 mov.l   1Ch+var_1C[sp], r1
FFF21908  6101                              cmp     #0, r1
FFF2190A  15                                beq.s   loc_FFF2190F
FFF2190B  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF2190E  0c                                bra.s   loc_FFF21912
FFF2190F  3e0100                 loc_FFF2190F mov.l   #0, 1Ch+var_18[sp]
FFF21912  a809                   loc_FFF21912 mov.l   1Ch+var_18[sp], r1
FFF21914  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF21916  6707                              rtsd    #7
FFF21918  7100bc                 sub_FFF21918 add     #-44h, sp, sp   ; <<<< FUNC sub_FFF21918
FFF2191B  a401                              mov.l   r1, 44h+var_4[sp]
FFF2191D  978a                              mov.w   r2, 44h+var_6[sp]
FFF2191F  a383                              mov.l   r3, 44h+var_C[sp]
FFF21921  a30c                              mov.l   r4, 44h+var_10[sp]
FFF21923  d5002419                          mov.w   44h+arg_0[sp], 44h+var_12[sp]
FFF21927  e500130b                          mov.l   44h+arg_4[sp], 44h+var_18[sp]
FFF2192B  e5000d06                          mov.l   44h+var_10[sp], 44h+var_2C[sp]
FFF2192F  3e0300                            mov.l   #0, 44h+var_38[sp]
FFF21932  ab81                              mov.l   44h+var_C[sp], r1
FFF21934  3c1c00                            mov.b   #0, 0Ch[r1]
FFF21937  aa89                              mov.l   44h+var_18[sp], r1
FFF21939  72110c0e                          add     #0E0Ch, r1, r1
FFF2193D  a101                              mov.l   r1, 44h+var_34[sp]
FFF2193F  ac01                              mov.l   44h+var_4[sp], r1
FFF21941  ad99                              mov.l   5Ch[r1], r1
FFF21943  6851                              shlr    #5, r1
FFF21945  bf8a                              movu.w  44h+var_6[sp], r2
FFF21947  fc2712                            divu    r1, r2
FFF2194A  a18a                              mov.l   r2, 44h+var_28[sp]
FFF2194C  aa89                              mov.l   44h+var_18[sp], r1
FFF2194E  5a1e3016                          movu.b  1630h[r1], r14
FFF21952  610e                              cmp     #0, r14
FFF21954  2112                              bne.b   loc_FFF21966
FFF21956  ac01                              mov.l   44h+var_4[sp], r1
FFF21958  591e6c                            movu.b  6Ch[r1], r14
FFF2195B  752e10                            and     #10h, r14
FFF2195E  755e10                            cmp     #10h, r14
FFF21961  1d                                bne.s   loc_FFF21966
FFF21962  f80601                            mov.l   #1, 44h+var_44[sp]
FFF21965  0c                                bra.s   loc_FFF21969
FFF21966  f80600                 loc_FFF21966 mov.l   #0, 44h+var_44[sp]
FFF21969  ec01                   loc_FFF21969 mov.l   44h+var_44[sp], r1
FFF2196B  6101                              cmp     #0, r1
FFF2196D  aa89                              mov.l   44h+var_18[sp], r1
FFF2196F  3a7f00                            beq.w   loc_FFF219EE
FFF21972  72110c10                          add     #100Ch, r1, r1
FFF21976  05735200                          bsr.a   sub_FFF26BE9
FFF2197A  8289                              mov.b   r1, 44h+var_39[sp]
FFF2197C  aa8b                              mov.l   44h+var_18[sp], r3
FFF2197E  ac01                              mov.l   44h+var_4[sp], r1
FFF21980  72320c06                          add     #60Ch, r3, r2
FFF21984  05054900                          bsr.a   sub_FFF26289
FFF21988  a201                              mov.l   r1, 44h+var_24[sp]
FFF2198A  aa01                              mov.l   44h+var_24[sp], r1
FFF2198C  6101                              cmp     #0, r1
FFF2198E  2137                              bne.b   loc_FFF219C5
FFF21990  aa8d                              mov.l   44h+var_18[sp], r5
FFF21992  590f0b                            movu.b  44h+var_39[sp], r15
FFF21995  bf8c                              movu.w  44h+var_6[sp], r4
FFF21997  a88b                              mov.l   44h+var_38[sp], r3
FFF21999  ab82                              mov.l   44h+var_C[sp], r2
FFF2199B  ac01                              mov.l   44h+var_4[sp], r1
FFF2199D  60c0                              sub     #0Ch, sp
FFF2199F  a085                              mov.l   r5, 50h+var_48[sp]
FFF219A1  72550c06                          add     #60Ch, r5, r5
FFF219A5  a00d                              mov.l   r5, 50h+var_4C[sp]
FFF219A7  c30f                              mov.b   r15, 50h+var_50[sp]
FFF219A9  059d4900                          bsr.a   sub_FFF26346
FFF219AD  62c0                              add     #0Ch, sp
FFF219AF  a201                              mov.l   r1, 44h+var_24[sp]
FFF219B1  aa01                              mov.l   44h+var_24[sp], r1
FFF219B3  6101                              cmp     #0, r1
FFF219B5  3aac00                            beq.w   loc_FFF21A61
FFF219B8  aa01                              mov.l   44h+var_24[sp], r1
FFF219BA  6602                              mov.l   #0, r2
FFF219BC  0564d4ff                          bsr.a   sub_FFF1EE20
FFF219C0  a009                              mov.l   r1, 44h+var_40[sp]
FFF219C2  380102                            bra.w   loc_FFF21BC3
FFF219C5  aa01                   loc_FFF219C5 mov.l   44h+var_24[sp], r1
FFF219C7  7601d3fe                          cmp     #-12Dh, r1
FFF219CB  10                                beq.s   loc_FFF219D3
FFF219CC  aa01                              mov.l   44h+var_24[sp], r1
FFF219CE  7601d4fe                          cmp     #-12Ch, r1
FFF219D2  1d                                bne.s   loc_FFF219D7
FFF219D3  f80601                 loc_FFF219D3 mov.l   #1, 44h+var_44[sp]
FFF219D6  0c                                bra.s   loc_FFF219DA
FFF219D7  f80600                 loc_FFF219D7 mov.l   #0, 44h+var_44[sp]
FFF219DA  ec01                   loc_FFF219DA mov.l   44h+var_44[sp], r1
FFF219DC  6101                              cmp     #0, r1
FFF219DE  3b8300                            bne.w   loc_FFF21A61
FFF219E1  aa01                              mov.l   44h+var_24[sp], r1
FFF219E3  6602                              mov.l   #0, r2
FFF219E5  053bd4ff                          bsr.a   sub_FFF1EE20
FFF219E9  a009                              mov.l   r1, 44h+var_40[sp]
FFF219EB  38d801                            bra.w   loc_FFF21BC3
FFF219EE  5a1e3016               loc_FFF219EE movu.b  1630h[r1], r14
FFF219F2  612e                              cmp     #2, r14
FFF219F4  2112                              bne.b   loc_FFF21A06
FFF219F6  ac01                              mov.l   44h+var_4[sp], r1
FFF219F8  591e6c                            movu.b  6Ch[r1], r14
FFF219FB  752e10                            and     #10h, r14
FFF219FE  755e10                            cmp     #10h, r14
FFF21A01  1d                                bne.s   loc_FFF21A06
FFF21A02  f80601                            mov.l   #1, 44h+var_44[sp]
FFF21A05  0c                                bra.s   loc_FFF21A09
FFF21A06  f80600                 loc_FFF21A06 mov.l   #0, 44h+var_44[sp]
FFF21A09  ec01                   loc_FFF21A09 mov.l   44h+var_44[sp], r1
FFF21A0B  6101                              cmp     #0, r1
FFF21A0D  2054                              beq.b   loc_FFF21A61
FFF21A0F  ac01                              mov.l   44h+var_4[sp], r1
FFF21A11  ae1a                              mov.l   64h[r1], r2
FFF21A13  aa8b                              mov.l   44h+var_18[sp], r3
FFF21A15  4a323216                          add     1632h[r3], r2
FFF21A19  72330c06                          add     #60Ch, r3, r3
FFF21A1D  05ec4700                          bsr.a   sub_FFF26209
FFF21A21  a201                              mov.l   r1, 44h+var_24[sp]
FFF21A23  aa01                              mov.l   44h+var_24[sp], r1
FFF21A25  6101                              cmp     #0, r1
FFF21A27  10                                beq.s   loc_FFF21A2F
FFF21A28  e5000801                          mov.l   44h+var_24[sp], 44h+var_40[sp]
FFF21A2C  389701                            bra.w   loc_FFF21BC3
FFF21A2F  aa8d                   loc_FFF21A2F mov.l   44h+var_18[sp], r5
FFF21A31  bf8c                              movu.w  44h+var_6[sp], r4
FFF21A33  a88b                              mov.l   44h+var_38[sp], r3
FFF21A35  ab82                              mov.l   44h+var_C[sp], r2
FFF21A37  ac01                              mov.l   44h+var_4[sp], r1
FFF21A39  60c0                              sub     #0Ch, sp
FFF21A3B  a085                              mov.l   r5, 50h+var_48[sp]
FFF21A3D  72550c06                          add     #60Ch, r5, r5
FFF21A41  a00d                              mov.l   r5, 50h+var_4C[sp]
FFF21A43  f80401                            mov.b   #1, 50h+var_50[sp]
FFF21A46  05004900                          bsr.a   sub_FFF26346
FFF21A4A  62c0                              add     #0Ch, sp
FFF21A4C  a201                              mov.l   r1, 44h+var_24[sp]
FFF21A4E  aa01                              mov.l   44h+var_24[sp], r1
FFF21A50  6101                              cmp     #0, r1
FFF21A52  200f                              beq.b   loc_FFF21A61
FFF21A54  aa01                              mov.l   44h+var_24[sp], r1
FFF21A56  6602                              mov.l   #0, r2
FFF21A58  05c8d3ff                          bsr.a   sub_FFF1EE20
FFF21A5C  a009                              mov.l   r1, 44h+var_40[sp]
FFF21A5E  386501                            bra.w   loc_FFF21BC3
FFF21A61  a98a                   loc_FFF21A61 mov.l   44h+var_28[sp], r2
FFF21A63  ac01                              mov.l   44h+var_4[sp], r1
FFF21A65  710310                            add     #44h+var_34, sp, r3
FFF21A68  39d9ea                            bsr.w   sub_FFF20541
FFF21A6B  a201                              mov.l   r1, 44h+var_24[sp]
FFF21A6D  aa01                              mov.l   44h+var_24[sp], r1
FFF21A6F  6101                              cmp     #0, r1
FFF21A71  10                                beq.s   loc_FFF21A79
FFF21A72  e5000801                          mov.l   44h+var_24[sp], 44h+var_40[sp]
FFF21A76  384d01                            bra.w   loc_FFF21BC3
FFF21A79  ab81                   loc_FFF21A79 mov.l   44h+var_C[sp], r1
FFF21A7B  3997ee                            bsr.w   sub_FFF20912
FFF21A7E  8589                              mov.b   r1, 44h+var_2D[sp]
FFF21A80  ac01                              mov.l   44h+var_4[sp], r1
FFF21A82  ad99                              mov.l   5Ch[r1], r1
FFF21A84  6851                              shlr    #5, r1
FFF21A86  bf8a                              movu.w  44h+var_6[sp], r2
FFF21A88  ef2e                              mov.l   r2, r14
FFF21A8A  fc271e                            divu    r1, r14
FFF21A8D  4f1e                              mul     r1, r14
FFF21A8F  43e2                              sub     r14, r2
FFF21A91  6c52                              shll    #5, r2
FFF21A93  06890204                          add     44h+var_34[sp].l, r2
FFF21A97  a20a                              mov.l   r2, 44h+var_20[sp]
FFF21A99  ab82                              mov.l   44h+var_C[sp], r2
FFF21A9B  aa09                              mov.l   44h+var_20[sp], r1
FFF21A9D  754320                            mov.l   #20h, r3 ; ' '
FFF21AA0  05d8c900                          bsr.a   sub_FFF2E478
FFF21AA4  aa09                              mov.l   44h+var_20[sp], r1
FFF21AA6  06850104                          cmp     44h+var_34[sp].l, r1
FFF21AAA  2158                              bne.b   loc_FFF21B02
FFF21AAC  a903                              mov.l   44h+var_34[sp], r3
FFF21AAE  a98a                              mov.l   44h+var_28[sp], r2
FFF21AB0  ac01                              mov.l   44h+var_4[sp], r1
FFF21AB2  39e0ea                            bsr.w   sub_FFF20592
FFF21AB5  a201                              mov.l   r1, 44h+var_24[sp]
FFF21AB7  aa01                              mov.l   44h+var_24[sp], r1
FFF21AB9  6101                              cmp     #0, r1
FFF21ABB  10                                beq.s   loc_FFF21AC3
FFF21ABC  e5000801                          mov.l   44h+var_24[sp], 44h+var_40[sp]
FFF21AC0  380301                            bra.w   loc_FFF21BC3
FFF21AC3  a989                   loc_FFF21AC3 mov.l   44h+var_28[sp], r1
FFF21AC5  6101                              cmp     #0, r1
FFF21AC7  1f                                bne.s   loc_FFF21ACE
FFF21AC8  3e0100                            mov.l   #0, 44h+var_40[sp]
FFF21ACB  38f800                            bra.w   loc_FFF21BC3
FFF21ACE  be09                   loc_FFF21ACE movu.w  44h+var_12[sp], r1
FFF21AD0  6111                              cmp     #1, r1
FFF21AD2  1f                                bne.s   loc_FFF21AD9
FFF21AD3  3e0100                            mov.l   #0, 44h+var_40[sp]
FFF21AD6  38ed00                            bra.w   loc_FFF21BC3
FFF21AD9  a98a                   loc_FFF21AD9 mov.l   44h+var_28[sp], r2
FFF21ADB  6012                              sub     #1, r2
FFF21ADD  ac01                              mov.l   44h+var_4[sp], r1
FFF21ADF  a18a                              mov.l   r2, 44h+var_28[sp]
FFF21AE1  710310                            add     #44h+var_34, sp, r3
FFF21AE4  395dea                            bsr.w   sub_FFF20541
FFF21AE7  a201                              mov.l   r1, 44h+var_24[sp]
FFF21AE9  aa01                              mov.l   44h+var_24[sp], r1
FFF21AEB  6101                              cmp     #0, r1
FFF21AED  10                                beq.s   loc_FFF21AF5
FFF21AEE  e5000801                          mov.l   44h+var_24[sp], 44h+var_40[sp]
FFF21AF2  38d100                            bra.w   loc_FFF21BC3
FFF21AF5  ac01                   loc_FFF21AF5 mov.l   44h+var_4[sp], r1
FFF21AF7  ad99                              mov.l   5Ch[r1], r1
FFF21AF9  7521e0                            and     #-20h, r1
FFF21AFC  06890104                          add     44h+var_34[sp].l, r1
FFF21B00  a209                              mov.l   r1, 44h+var_20[sp]
FFF21B02  3d0a01                 loc_FFF21B02 mov.w   #1, 44h+var_30[sp]
FFF21B05  389100                            bra.w   loc_FFF21B96
FFF21B08  aa09                   loc_FFF21B08 mov.l   44h+var_20[sp], r1
FFF21B0A  7111e0                            add     #-20h, r1, r1
FFF21B0D  a209                              mov.l   r1, 44h+var_20[sp]
FFF21B0F  ac03                              mov.l   44h+var_4[sp], r3
FFF21B11  a982                              mov.l   44h+var_2C[sp], r2
FFF21B13  3933f7                            bsr.w   sub_FFF21246
FFF21B16  a201                              mov.l   r1, 44h+var_24[sp]
FFF21B18  aa01                              mov.l   44h+var_24[sp], r1
FFF21B1A  6c11                              shll    #1, r1
FFF21B1C  06890106                          add     44h+var_2C[sp].l, r1
FFF21B20  a181                              mov.l   r1, 44h+var_2C[sp]
FFF21B22  b501                              movu.b  44h+var_30[sp], r1
FFF21B24  aa0a                              mov.l   44h+var_20[sp], r2
FFF21B26  c321                              mov.b   r1, [r2]
FFF21B28  aa09                              mov.l   44h+var_20[sp], r1
FFF21B2A  3c1b0f                            mov.b   #0Fh, 0Bh[r1]
FFF21B2D  b589                              movu.b  44h+var_2D[sp], r1
FFF21B2F  aa0a                              mov.l   44h+var_20[sp], r2
FFF21B31  8329                              mov.b   r1, 0Dh[r2]
FFF21B33  aa09                              mov.l   44h+var_20[sp], r1
FFF21B35  06850104                          cmp     44h+var_34[sp].l, r1
FFF21B39  210f                              bne.b   loc_FFF21B48
FFF21B3B  be09                              movu.w  44h+var_12[sp], r1
FFF21B3D  6011                              sub     #1, r1
FFF21B3F  ba82                              movu.w  44h+var_30[sp], r2
FFF21B41  4712                              cmp     r1, r2
FFF21B43  15                                beq.s   loc_FFF21B48
FFF21B44  f80601                            mov.l   #1, 44h+var_44[sp]
FFF21B47  0c                                bra.s   loc_FFF21B4B
FFF21B48  f80600                 loc_FFF21B48 mov.l   #0, 44h+var_44[sp]
FFF21B4B  ec01                   loc_FFF21B4B mov.l   44h+var_44[sp], r1
FFF21B4D  6101                              cmp     #0, r1
FFF21B4F  2041                              beq.b   loc_FFF21B90
FFF21B51  a98a                              mov.l   44h+var_28[sp], r2
FFF21B53  7123ff                            add     #-1, r2, r3
FFF21B56  ac01                              mov.l   44h+var_4[sp], r1
FFF21B58  a18b                              mov.l   r3, 44h+var_28[sp]
FFF21B5A  a903                              mov.l   44h+var_34[sp], r3
FFF21B5C  3936ea                            bsr.w   sub_FFF20592
FFF21B5F  a201                              mov.l   r1, 44h+var_24[sp]
FFF21B61  aa01                              mov.l   44h+var_24[sp], r1
FFF21B63  6101                              cmp     #0, r1
FFF21B65  17                                beq.s   loc_FFF21B6C
FFF21B66  e5000801                          mov.l   44h+var_24[sp], 44h+var_40[sp]
FFF21B6A  2e59                              bra.b   loc_FFF21BC3
FFF21B6C  a98a                   loc_FFF21B6C mov.l   44h+var_28[sp], r2
FFF21B6E  ac01                              mov.l   44h+var_4[sp], r1
FFF21B70  710310                            add     #44h+var_34, sp, r3
FFF21B73  39cee9                            bsr.w   sub_FFF20541
FFF21B76  a201                              mov.l   r1, 44h+var_24[sp]
FFF21B78  aa01                              mov.l   44h+var_24[sp], r1
FFF21B7A  6101                              cmp     #0, r1
FFF21B7C  17                                beq.s   loc_FFF21B83
FFF21B7D  e5000801                          mov.l   44h+var_24[sp], 44h+var_40[sp]
FFF21B81  2e42                              bra.b   loc_FFF21BC3
FFF21B83  ac01                   loc_FFF21B83 mov.l   44h+var_4[sp], r1
FFF21B85  ad99                              mov.l   5Ch[r1], r1
FFF21B87  7521e0                            and     #-20h, r1
FFF21B8A  06890104                          add     44h+var_34[sp].l, r1
FFF21B8E  a209                              mov.l   r1, 44h+var_20[sp]
FFF21B90  9a81                   loc_FFF21B90 mov.w   44h+var_30[sp], r1
FFF21B92  6211                              add     #1, r1
FFF21B94  9281                              mov.w   r1, 44h+var_30[sp]
FFF21B96  ba81                   loc_FFF21B96 movu.w  44h+var_30[sp], r1
FFF21B98  06c50119                          cmp     44h+var_12[sp].uw, r1
FFF21B9C  2805                              bge.b   loc_FFF21BA1
FFF21B9E  386aff                            bra.w   loc_FFF21B08
FFF21BA1  be09                   loc_FFF21BA1 movu.w  44h+var_12[sp], r1
FFF21BA3  6121                              cmp     #2, r1
FFF21BA5  2906                              blt.b   loc_FFF21BAB
FFF21BA7  aa09                              mov.l   44h+var_20[sp], r1
FFF21BA9  f016                              bset    #6, [r1].b
FFF21BAB  a903                   loc_FFF21BAB mov.l   44h+var_34[sp], r3
FFF21BAD  a98a                              mov.l   44h+var_28[sp], r2
FFF21BAF  ac01                              mov.l   44h+var_4[sp], r1
FFF21BB1  39e1e9                            bsr.w   sub_FFF20592
FFF21BB4  a201                              mov.l   r1, 44h+var_24[sp]
FFF21BB6  aa01                              mov.l   44h+var_24[sp], r1
FFF21BB8  6101                              cmp     #0, r1
FFF21BBA  16                                beq.s   loc_FFF21BC0
FFF21BBB  e5000801                          mov.l   44h+var_24[sp], 44h+var_40[sp]
FFF21BBF  0c                                bra.s   loc_FFF21BC3
FFF21BC0  3e0100                 loc_FFF21BC0 mov.l   #0, 44h+var_40[sp]
FFF21BC3  a809                   loc_FFF21BC3 mov.l   44h+var_40[sp], r1
FFF21BC5  a281                              mov.l   r1, 44h+var_1C[sp]
FFF21BC7  6711                              rtsd    #11h
FFF21BC9  7100d4                 sub_FFF21BC9 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF21BC9
FFF21BCC  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF21BCE  948a                              mov.w   r2, 2Ch+var_6[sp]
FFF21BD0  9483                              mov.w   r3, 2Ch+var_8[sp]
FFF21BD2  a204                              mov.l   r4, 2Ch+var_C[sp]
FFF21BD4  72440c0e                          add     #0E0Ch, r4, r4
FFF21BD8  a084                              mov.l   r4, 2Ch+var_24[sp]
FFF21BDA  aa81                              mov.l   2Ch+var_4[sp], r1
FFF21BDC  ad99                              mov.l   5Ch[r1], r1
FFF21BDE  6851                              shlr    #5, r1
FFF21BE0  bc8a                              movu.w  2Ch+var_6[sp], r2
FFF21BE2  fc2712                            divu    r1, r2
FFF21BE5  a10a                              mov.l   r2, 2Ch+var_18[sp]
FFF21BE7  a90a                              mov.l   2Ch+var_18[sp], r2
FFF21BE9  aa81                              mov.l   2Ch+var_4[sp], r1
FFF21BEB  710308                            add     #2Ch+var_24, sp, r3
FFF21BEE  3953e9                            bsr.w   sub_FFF20541
FFF21BF1  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF21BF3  a981                              mov.l   2Ch+var_14[sp], r1
FFF21BF5  6101                              cmp     #0, r1
FFF21BF7  10                                beq.s   loc_FFF21BFF
FFF21BF8  e5000601                          mov.l   2Ch+var_14[sp], 2Ch+var_28[sp]
FFF21BFC  38da00                            bra.w   loc_FFF21CD6
FFF21BFF  aa81                   loc_FFF21BFF mov.l   2Ch+var_4[sp], r1
FFF21C01  ad99                              mov.l   5Ch[r1], r1
FFF21C03  6851                              shlr    #5, r1
FFF21C05  bc8a                              movu.w  2Ch+var_6[sp], r2
FFF21C07  ef2e                              mov.l   r2, r14
FFF21C09  fc271e                            divu    r1, r14
FFF21C0C  4f1e                              mul     r1, r14
FFF21C0E  43e2                              sub     r14, r2
FFF21C10  6c52                              shll    #5, r2
FFF21C12  06890202                          add     2Ch+var_24[sp].l, r2
FFF21C16  a08a                              mov.l   r2, 2Ch+var_20[sp]
FFF21C18  bc81                              movu.w  2Ch+var_8[sp], r1
FFF21C1A  6111                              cmp     #1, r1
FFF21C1C  1f                                bne.s   loc_FFF21C23
FFF21C1D  9c81                              mov.w   2Ch+var_8[sp], r1
FFF21C1F  6211                              add     #1, r1
FFF21C21  9481                              mov.w   r1, 2Ch+var_8[sp]
FFF21C23  3d0900                 loc_FFF21C23 mov.w   #0, 2Ch+var_1A[sp]
FFF21C26  387f00                            bra.w   loc_FFF21CA5
FFF21C29  a883                   loc_FFF21C29 mov.l   2Ch+var_24[sp], r3
FFF21C2B  a90a                              mov.l   2Ch+var_18[sp], r2
FFF21C2D  aa81                              mov.l   2Ch+var_4[sp], r1
FFF21C2F  3963e9                            bsr.w   sub_FFF20592
FFF21C32  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF21C34  a981                              mov.l   2Ch+var_14[sp], r1
FFF21C36  6101                              cmp     #0, r1
FFF21C38  10                                beq.s   loc_FFF21C40
FFF21C39  e5000601                          mov.l   2Ch+var_14[sp], 2Ch+var_28[sp]
FFF21C3D  389900                            bra.w   loc_FFF21CD6
FFF21C40  a909                   loc_FFF21C40 mov.l   2Ch+var_18[sp], r1
FFF21C42  6101                              cmp     #0, r1
FFF21C44  1f                                bne.s   loc_FFF21C4B
FFF21C45  3e0100                            mov.l   #0, 2Ch+var_28[sp]
FFF21C48  388e00                            bra.w   loc_FFF21CD6
FFF21C4B  a909                   loc_FFF21C4B mov.l   2Ch+var_18[sp], r1
FFF21C4D  6011                              sub     #1, r1
FFF21C4F  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF21C51  a90a                              mov.l   2Ch+var_18[sp], r2
FFF21C53  aa81                              mov.l   2Ch+var_4[sp], r1
FFF21C55  710308                            add     #2Ch+var_24, sp, r3
FFF21C58  39e9e8                            bsr.w   sub_FFF20541
FFF21C5B  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF21C5D  a981                              mov.l   2Ch+var_14[sp], r1
FFF21C5F  6101                              cmp     #0, r1
FFF21C61  17                                beq.s   loc_FFF21C68
FFF21C62  e5000601                          mov.l   2Ch+var_14[sp], 2Ch+var_28[sp]
FFF21C66  2e70                              bra.b   loc_FFF21CD6
FFF21C68  aa81                   loc_FFF21C68 mov.l   2Ch+var_4[sp], r1
FFF21C6A  ad99                              mov.l   5Ch[r1], r1
FFF21C6C  7521e0                            and     #-20h, r1
FFF21C6F  06890102                          add     2Ch+var_24[sp].l, r1
FFF21C73  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF21C75  a889                   loc_FFF21C75 mov.l   2Ch+var_20[sp], r1
FFF21C77  7111e0                            add     #-20h, r1, r1
FFF21C7A  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF21C7C  a889                              mov.l   2Ch+var_20[sp], r1
FFF21C7E  8a99                              mov.b   0Bh[r1], r1
FFF21C80  61f1                              cmp     #0Fh, r1
FFF21C82  213c                              bne.b   loc_FFF21CBE
FFF21C84  9a09                              mov.w   2Ch+var_1A[sp], r1
FFF21C86  6211                              add     #1, r1
FFF21C88  9209                              mov.w   r1, 2Ch+var_1A[sp]
FFF21C8A  ba09                              movu.w  2Ch+var_1A[sp], r1
FFF21C8C  06c50112                          cmp     2Ch+var_8[sp].uw, r1
FFF21C90  290c                              blt.b   loc_FFF21C9C
FFF21C92  b409                              movu.b  2Ch+var_1B[sp], r1
FFF21C94  755140                            cmp     #40h, r1 ; '@'
FFF21C97  1d                                bne.s   loc_FFF21C9C
FFF21C98  f80601                            mov.l   #1, 2Ch+var_2C[sp]
FFF21C9B  0c                                bra.s   loc_FFF21C9F
FFF21C9C  f80600                 loc_FFF21C9C mov.l   #0, 2Ch+var_2C[sp]
FFF21C9F  ec01                   loc_FFF21C9F mov.l   2Ch+var_2C[sp], r1
FFF21CA1  6101                              cmp     #0, r1
FFF21CA3  211b                              bne.b   loc_FFF21CBE
FFF21CA5  a889                   loc_FFF21CA5 mov.l   2Ch+var_20[sp], r1
FFF21CA7  5811                              movu.b  [r1], r1
FFF21CA9  752140                            and     #40h, r1 ; '@'
FFF21CAC  8409                              mov.b   r1, 2Ch+var_1B[sp]
FFF21CAE  a889                              mov.l   2Ch+var_20[sp], r1
FFF21CB0  f814e5                            mov.b   #-1Bh, [r1]
FFF21CB3  a889                              mov.l   2Ch+var_20[sp], r1
FFF21CB5  06850102                          cmp     2Ch+var_24[sp].l, r1
FFF21CB9  3a70ff                            beq.w   loc_FFF21C29
FFF21CBC  2eb9                              bra.b   loc_FFF21C75
FFF21CBE  a883                   loc_FFF21CBE mov.l   2Ch+var_24[sp], r3
FFF21CC0  a90a                              mov.l   2Ch+var_18[sp], r2
FFF21CC2  aa81                              mov.l   2Ch+var_4[sp], r1
FFF21CC4  39cee8                            bsr.w   sub_FFF20592
FFF21CC7  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF21CC9  a981                              mov.l   2Ch+var_14[sp], r1
FFF21CCB  6101                              cmp     #0, r1
FFF21CCD  16                                beq.s   loc_FFF21CD3
FFF21CCE  e5000601                          mov.l   2Ch+var_14[sp], 2Ch+var_28[sp]
FFF21CD2  0c                                bra.s   loc_FFF21CD6
FFF21CD3  3e0100                 loc_FFF21CD3 mov.l   #0, 2Ch+var_28[sp]
FFF21CD6  a809                   loc_FFF21CD6 mov.l   2Ch+var_28[sp], r1
FFF21CD8  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF21CDA  670b                              rtsd    #0Bh
FFF21CDC  71009c                 sub_FFF21CDC add     #-64h, sp, sp   ; <<<< FUNC sub_FFF21CDC
FFF21CDF  a601                              mov.l   r1, 64h+var_4[sp]
FFF21CE1  d7022f                            mov.w   r2, 64h+var_6[sp]
FFF21CE4  a583                              mov.l   r3, 64h+var_C[sp]
FFF21CE6  d7042b                            mov.w   r4, 64h+var_E[sp]
FFF21CE9  e5001a14                          mov.l   64h+arg_0[sp], 64h+var_14[sp]
FFF21CED  e5001b13                          mov.l   64h+arg_4[sp], 64h+var_18[sp]
FFF21CF1  e5001607                          mov.l   64h+var_C[sp], 64h+var_48[sp]
FFF21CF5  f90603ff                          mov.l   #-1, 64h+var_58[sp]
FFF21CF9  ac89                              mov.l   64h+var_18[sp], r1
FFF21CFB  72110c0e                          add     #0E0Ch, r1, r1
FFF21CFF  a081                              mov.l   r1, 64h+var_5C[sp]
FFF21D01  5d012f                            movu.w  64h+var_6[sp], r1
FFF21D04  6101                              cmp     #0, r1
FFF21D06  2b1b                              ble.b   loc_FFF21D21
FFF21D08  ae01                              mov.l   64h+var_4[sp], r1
FFF21D0A  ad99                              mov.l   5Ch[r1], r1
FFF21D0C  6851                              shlr    #5, r1
FFF21D0E  5d022f                            movu.w  64h+var_6[sp], r2
FFF21D11  ef2e                              mov.l   r2, r14
FFF21D13  fc271e                            divu    r1, r14
FFF21D16  4f1e                              mul     r1, r14
FFF21D18  43e2                              sub     r14, r2
FFF21D1A  6102                              cmp     #0, r2
FFF21D1C  1d                                bne.s   loc_FFF21D21
FFF21D1D  f80601                            mov.l   #1, 64h+var_64[sp]
FFF21D20  0c                                bra.s   loc_FFF21D24
FFF21D21  f80600                 loc_FFF21D21 mov.l   #0, 64h+var_64[sp]
FFF21D24  ec01                   loc_FFF21D24 mov.l   64h+var_64[sp], r1
FFF21D26  6101                              cmp     #0, r1
FFF21D28  5d012f                            movu.w  64h+var_6[sp], r1
FFF21D2B  2011                              beq.b   loc_FFF21D3C
FFF21D2D  ae02                              mov.l   64h+var_4[sp], r2
FFF21D2F  adaa                              mov.l   5Ch[r2], r2
FFF21D31  6852                              shlr    #5, r2
FFF21D33  6011                              sub     #1, r1
FFF21D35  fc2721                            divu    r2, r1
FFF21D38  a281                              mov.l   r1, 64h+var_3C[sp]
FFF21D3A  2e0d                              bra.b   loc_FFF21D47
FFF21D3C  ae02                   loc_FFF21D3C mov.l   64h+var_4[sp], r2
FFF21D3E  adaa                              mov.l   5Ch[r2], r2
FFF21D40  6852                              shlr    #5, r2
FFF21D42  fc2721                            divu    r2, r1
FFF21D45  a281                              mov.l   r1, 64h+var_3C[sp]
FFF21D47  aa82                   loc_FFF21D47 mov.l   64h+var_3C[sp], r2
FFF21D49  ae01                              mov.l   64h+var_4[sp], r1
FFF21D4B  710308                            add     #64h+var_5C, sp, r3
FFF21D4E  39f3e7                            bsr.w   sub_FFF20541
FFF21D51  a109                              mov.l   r1, 64h+var_50[sp]
FFF21D53  a909                              mov.l   64h+var_50[sp], r1
FFF21D55  6101                              cmp     #0, r1
FFF21D57  10                                beq.s   loc_FFF21D5F
FFF21D58  e5000501                          mov.l   64h+var_50[sp], 64h+var_60[sp]
FFF21D5C  385c01                            bra.w   loc_FFF21EB8
FFF21D5F  e5000a06               loc_FFF21D5F mov.l   64h+var_3C[sp], 64h+var_4C[sp]
FFF21D63  ae01                              mov.l   64h+var_4[sp], r1
FFF21D65  ad99                              mov.l   5Ch[r1], r1
FFF21D67  6851                              shlr    #5, r1
FFF21D69  5d022f                            movu.w  64h+var_6[sp], r2
FFF21D6C  ef2e                              mov.l   r2, r14
FFF21D6E  fc271e                            divu    r1, r14
FFF21D71  4f1e                              mul     r1, r14
FFF21D73  43e2                              sub     r14, r2
FFF21D75  6102                              cmp     #0, r2
FFF21D77  a881                              mov.l   64h+var_5C[sp], r1
FFF21D79  210f                              bne.b   loc_FFF21D88
FFF21D7B  ae02                              mov.l   64h+var_4[sp], r2
FFF21D7D  adaa                              mov.l   5Ch[r2], r2
FFF21D7F  7522e0                            and     #-20h, r2
FFF21D82  4b21                              add     r2, r1
FFF21D84  a101                              mov.l   r1, 64h+var_54[sp]
FFF21D86  2e1a                              bra.b   loc_FFF21DA0
FFF21D88  ae02                   loc_FFF21D88 mov.l   64h+var_4[sp], r2
FFF21D8A  adaa                              mov.l   5Ch[r2], r2
FFF21D8C  6852                              shlr    #5, r2
FFF21D8E  5d032f                            movu.w  64h+var_6[sp], r3
FFF21D91  ef3e                              mov.l   r3, r14
FFF21D93  fc272e                            divu    r2, r14
FFF21D96  4f2e                              mul     r2, r14
FFF21D98  43e3                              sub     r14, r3
FFF21D9A  6c53                              shll    #5, r3
FFF21D9C  4b31                              add     r3, r1
FFF21D9E  a101                              mov.l   r1, 64h+var_54[sp]
FFF21DA0  5d012f                 loc_FFF21DA0 movu.w  64h+var_6[sp], r1
FFF21DA3  6101                              cmp     #0, r1
FFF21DA5  18                                bne.s   loc_FFF21DAD
FFF21DA6  a881                              mov.l   64h+var_5C[sp], r1
FFF21DA8  711120                            add     #20h, r1, r1 ; ' '
FFF21DAB  a101                              mov.l   r1, 64h+var_54[sp]
FFF21DAD  3d8301                 loc_FFF21DAD mov.w   #1, 64h+var_3E[sp]
FFF21DB0  38c600                            bra.w   loc_FFF21E76
FFF21DB3  7111e0                 loc_FFF21DB3 add     #-20h, r1, r1
FFF21DB6  a101                              mov.l   r1, 64h+var_54[sp]
FFF21DB8  71022c                            add     #64h+var_38, sp, r2
FFF21DBB  393cf6                            bsr.w   sub_FFF213F7
FFF21DBE  a109                              mov.l   r1, 64h+var_50[sp]
FFF21DC0  71012c                            add     #64h+var_38, sp, r1
FFF21DC3  a201                              mov.l   r1, 64h+var_44[sp]
FFF21DC5  2e55                              bra.b   loc_FFF21E1A
FFF21DC7  a989                   loc_FFF21DC7 mov.l   64h+var_48[sp], r1
FFF21DC9  5c1e                              movu.w  [r1], r14
FFF21DCB  aa02                              mov.l   64h+var_44[sp], r2
FFF21DCD  06c42e                            cmp     [r2].uw, r14
FFF21DD0  2040                              beq.b   loc_FFF21E10
FFF21DD2  aa02                              mov.l   64h+var_44[sp], r2
FFF21DD4  3972f7                            bsr.w   sub_FFF21546
FFF21DD7  6101                              cmp     #0, r1
FFF21DD9  2010                              beq.b   loc_FFF21DE9
FFF21DDB  a989                              mov.l   64h+var_48[sp], r1
FFF21DDD  6221                              add     #2, r1
FFF21DDF  a189                              mov.l   r1, 64h+var_48[sp]
FFF21DE1  aa01                              mov.l   64h+var_44[sp], r1
FFF21DE3  6221                              add     #2, r1
FFF21DE5  a201                              mov.l   r1, 64h+var_44[sp]
FFF21DE7  2e33                              bra.b   loc_FFF21E1A
FFF21DE9  a981                   loc_FFF21DE9 mov.l   64h+var_4C[sp], r1
FFF21DEB  06850114                          cmp     64h+var_14[sp].l, r1
FFF21DEF  201a                              beq.b   loc_FFF21E09
FFF21DF1  ad02                              mov.l   64h+var_14[sp], r2
FFF21DF3  ae01                              mov.l   64h+var_4[sp], r1
FFF21DF5  710308                            add     #64h+var_5C, sp, r3
FFF21DF8  3949e7                            bsr.w   sub_FFF20541
FFF21DFB  a109                              mov.l   r1, 64h+var_50[sp]
FFF21DFD  a909                              mov.l   64h+var_50[sp], r1
FFF21DFF  6101                              cmp     #0, r1
FFF21E01  10                                beq.s   loc_FFF21E09
FFF21E02  e5000501                          mov.l   64h+var_50[sp], 64h+var_60[sp]
FFF21E06  38b200                            bra.w   loc_FFF21EB8
FFF21E09  f906019d               loc_FFF21E09 mov.l   #-63h, 64h+var_60[sp]
FFF21E0D  38ab00                            bra.w   loc_FFF21EB8
FFF21E10  6221                   loc_FFF21E10 add     #2, r1
FFF21E12  a189                              mov.l   r1, 64h+var_48[sp]
FFF21E14  aa01                              mov.l   64h+var_44[sp], r1
FFF21E16  6221                              add     #2, r1
FFF21E18  a201                              mov.l   r1, 64h+var_44[sp]
FFF21E1A  a909                   loc_FFF21E1A mov.l   64h+var_50[sp], r1
FFF21E1C  7112ff                            add     #-1, r1, r2
FFF21E1F  a10a                              mov.l   r2, 64h+var_50[sp]
FFF21E21  6101                              cmp     #0, r1
FFF21E23  21a4                              bne.b   loc_FFF21DC7
FFF21E25  a901                              mov.l   64h+var_54[sp], r1
FFF21E27  06850102                          cmp     64h+var_5C[sp].l, r1
FFF21E2B  2110                              bne.b   loc_FFF21E3B
FFF21E2D  5d012b                            movu.w  64h+var_E[sp], r1
FFF21E30  6011                              sub     #1, r1
FFF21E32  bc8a                              movu.w  64h+var_3E[sp], r2
FFF21E34  4712                              cmp     r1, r2
FFF21E36  15                                beq.s   loc_FFF21E3B
FFF21E37  f80601                            mov.l   #1, 64h+var_64[sp]
FFF21E3A  0c                                bra.s   loc_FFF21E3E
FFF21E3B  f80600                 loc_FFF21E3B mov.l   #0, 64h+var_64[sp]
FFF21E3E  ec01                   loc_FFF21E3E mov.l   64h+var_64[sp], r1
FFF21E40  6101                              cmp     #0, r1
FFF21E42  202e                              beq.b   loc_FFF21E70
FFF21E44  aa82                              mov.l   64h+var_3C[sp], r2
FFF21E46  6012                              sub     #1, r2
FFF21E48  ae01                              mov.l   64h+var_4[sp], r1
FFF21E4A  a282                              mov.l   r2, 64h+var_3C[sp]
FFF21E4C  710308                            add     #64h+var_5C, sp, r3
FFF21E4F  39f2e6                            bsr.w   sub_FFF20541
FFF21E52  a109                              mov.l   r1, 64h+var_50[sp]
FFF21E54  a909                              mov.l   64h+var_50[sp], r1
FFF21E56  6101                              cmp     #0, r1
FFF21E58  17                                beq.s   loc_FFF21E5F
FFF21E59  e5000501                          mov.l   64h+var_50[sp], 64h+var_60[sp]
FFF21E5D  2e5b                              bra.b   loc_FFF21EB8
FFF21E5F  e5000a06               loc_FFF21E5F mov.l   64h+var_3C[sp], 64h+var_4C[sp]
FFF21E63  ae01                              mov.l   64h+var_4[sp], r1
FFF21E65  ad99                              mov.l   5Ch[r1], r1
FFF21E67  7521e0                            and     #-20h, r1
FFF21E6A  06890102                          add     64h+var_5C[sp].l, r1
FFF21E6E  a101                              mov.l   r1, 64h+var_54[sp]
FFF21E70  9c89                   loc_FFF21E70 mov.w   64h+var_3E[sp], r1
FFF21E72  6211                              add     #1, r1
FFF21E74  9489                              mov.w   r1, 64h+var_3E[sp]
FFF21E76  bc89                   loc_FFF21E76 movu.w  64h+var_3E[sp], r1
FFF21E78  06c5012b                          cmp     64h+var_E[sp].uw, r1
FFF21E7C  a901                              mov.l   64h+var_54[sp], r1
FFF21E7E  2805                              bge.b   loc_FFF21E83
FFF21E80  3833ff                            bra.w   loc_FFF21DB3
FFF21E83  f416                   loc_FFF21E83 btst    #6, [r1].b
FFF21E85  14                                beq.s   loc_FFF21E89
FFF21E86  3e0300                            mov.l   #0, 64h+var_58[sp]
FFF21E89  a981                   loc_FFF21E89 mov.l   64h+var_4C[sp], r1
FFF21E8B  06850114                          cmp     64h+var_14[sp].l, r1
FFF21E8F  2019                              beq.b   loc_FFF21EA8
FFF21E91  ad02                              mov.l   64h+var_14[sp], r2
FFF21E93  ae01                              mov.l   64h+var_4[sp], r1
FFF21E95  710308                            add     #64h+var_5C, sp, r3
FFF21E98  39a9e6                            bsr.w   sub_FFF20541
FFF21E9B  a109                              mov.l   r1, 64h+var_50[sp]
FFF21E9D  a909                              mov.l   64h+var_50[sp], r1
FFF21E9F  6101                              cmp     #0, r1
FFF21EA1  17                                beq.s   loc_FFF21EA8
FFF21EA2  e5000501                          mov.l   64h+var_50[sp], 64h+var_60[sp]
FFF21EA6  2e12                              bra.b   loc_FFF21EB8
FFF21EA8  a989                   loc_FFF21EA8 mov.l   64h+var_48[sp], r1
FFF21EAA  581e                              movu.b  [r1], r14
FFF21EAC  610e                              cmp     #0, r14
FFF21EAE  16                                beq.s   loc_FFF21EB4
FFF21EAF  f906019d                          mov.l   #-63h, 64h+var_60[sp]
FFF21EB3  0d                                bra.s   loc_FFF21EB8
FFF21EB4  e5000301               loc_FFF21EB4 mov.l   64h+var_58[sp], 64h+var_60[sp]
FFF21EB8  a809                   loc_FFF21EB8 mov.l   64h+var_60[sp], r1
FFF21EBA  a481                              mov.l   r1, 64h+var_1C[sp]
FFF21EBC  6719                              rtsd    #19h
FFF21EBE  7100d8                 sub_FFF21EBE add     #-28h, sp, sp   ; <<<< FUNC sub_FFF21EBE
FFF21EC1  a209                              mov.l   r1, 28h+var_4[sp]
FFF21EC3  a202                              mov.l   r2, 28h+var_8[sp]
FFF21EC5  a18b                              mov.l   r3, 28h+var_C[sp]
FFF21EC7  e5000902                          mov.l   28h+var_4[sp], 28h+var_20[sp]
FFF21ECB  71010c                            add     #28h+var_1C, sp, r1
FFF21ECE  a009                              mov.l   r1, 28h+var_24[sp]
FFF21ED0  a98b                              mov.l   28h+var_C[sp], r3
FFF21ED2  aa02                              mov.l   28h+var_8[sp], r2
FFF21ED4  71010c                            add     #28h+var_1C, sp, r1
FFF21ED7  39b4e9                            bsr.w   sub_FFF2088B
FFF21EDA  2e1c                              bra.b   loc_FFF21EF6
FFF21EDC  a809                   loc_FFF21EDC mov.l   28h+var_24[sp], r1
FFF21EDE  581e                              movu.b  [r1], r14
FFF21EE0  6211                              add     #1, r1
FFF21EE2  a882                              mov.l   28h+var_20[sp], r2
FFF21EE4  582f                              movu.b  [r2], r15
FFF21EE6  a009                              mov.l   r1, 28h+var_24[sp]
FFF21EE8  a881                              mov.l   28h+var_20[sp], r1
FFF21EEA  6211                              add     #1, r1
FFF21EEC  a081                              mov.l   r1, 28h+var_20[sp]
FFF21EEE  47fe                              cmp     r15, r14
FFF21EF0  16                                beq.s   loc_FFF21EF6
FFF21EF1  f8069d                            mov.l   #-63h, 28h+var_28[sp]
FFF21EF4  2e0d                              bra.b   loc_FFF21F01
FFF21EF6  a809                   loc_FFF21EF6 mov.l   28h+var_24[sp], r1
FFF21EF8  581e                              movu.b  [r1], r14
FFF21EFA  610e                              cmp     #0, r14
FFF21EFC  21e0                              bne.b   loc_FFF21EDC
FFF21EFE  f80600                            mov.l   #0, 28h+var_28[sp]
FFF21F01  ec01                   loc_FFF21F01 mov.l   28h+var_28[sp], r1
FFF21F03  a181                              mov.l   r1, 28h+var_10[sp]
FFF21F05  670a                              rtsd    #0Ah
FFF21F07  7100b8                 sub_FFF21F07 add     #-48h, sp, sp   ; <<<< FUNC sub_FFF21F07
FFF21F0A  a409                              mov.l   r1, 48h+var_4[sp]
FFF21F0C  a402                              mov.l   r2, 48h+var_8[sp]
FFF21F0E  978b                              mov.w   r3, 48h+var_A[sp]
FFF21F10  a384                              mov.l   r4, 48h+var_10[sp]
FFF21F12  e500130d                          mov.l   48h+arg_0[sp], 48h+var_14[sp]
FFF21F16  e500140c                          mov.l   48h+arg_4[sp], 48h+var_18[sp]
FFF21F1A  e500150b                          mov.l   48h+arg_8[sp], 48h+var_1C[sp]
FFF21F1E  3e0700                            mov.l   #0, 48h+var_2C[sp]
FFF21F21  ab81                              mov.l   48h+var_10[sp], r1
FFF21F23  3c1c00                            mov.b   #0, 0Ch[r1]
FFF21F26  aa89                              mov.l   48h+var_1C[sp], r1
FFF21F28  72110c06                          add     #60Ch, r1, r1
FFF21F2C  a089                              mov.l   r1, 48h+var_3C[sp]
FFF21F2E  aa89                              mov.l   48h+var_1C[sp], r1
FFF21F30  5a1e3016                          movu.b  1630h[r1], r14
FFF21F34  610e                              cmp     #0, r14
FFF21F36  2112                              bne.b   loc_FFF21F48
FFF21F38  ac09                              mov.l   48h+var_4[sp], r1
FFF21F3A  591e6c                            movu.b  6Ch[r1], r14
FFF21F3D  752e10                            and     #10h, r14
FFF21F40  755e10                            cmp     #10h, r14
FFF21F43  1d                                bne.s   loc_FFF21F48
FFF21F44  f80601                            mov.l   #1, 48h+var_48[sp]
FFF21F47  0c                                bra.s   loc_FFF21F4B
FFF21F48  f80600                 loc_FFF21F48 mov.l   #0, 48h+var_48[sp]
FFF21F4B  ec01                   loc_FFF21F4B mov.l   48h+var_48[sp], r1
FFF21F4D  6101                              cmp     #0, r1
FFF21F4F  aa89                              mov.l   48h+var_1C[sp], r1
FFF21F51  3a8100                            beq.w   loc_FFF21FD2
FFF21F54  72110c10                          add     #100Ch, r1, r1
FFF21F58  05914c00                          bsr.a   sub_FFF26BE9
FFF21F5C  8289                              mov.b   r1, 48h+var_3D[sp]
FFF21F5E  aa8b                              mov.l   48h+var_1C[sp], r3
FFF21F60  ac09                              mov.l   48h+var_4[sp], r1
FFF21F62  72320c06                          add     #60Ch, r3, r2
FFF21F66  05234300                          bsr.a   sub_FFF26289
FFF21F6A  a209                              mov.l   r1, 48h+var_24[sp]
FFF21F6C  aa09                              mov.l   48h+var_24[sp], r1
FFF21F6E  6101                              cmp     #0, r1
FFF21F70  2139                              bne.b   loc_FFF21FA9
FFF21F72  ac01                              mov.l   48h+var_8[sp], r1
FFF21F74  ec13                              mov.l   [r1], r3
FFF21F76  aa8d                              mov.l   48h+var_1C[sp], r5
FFF21F78  590f0b                            movu.b  48h+var_3D[sp], r15
FFF21F7B  bf8c                              movu.w  48h+var_A[sp], r4
FFF21F7D  ab82                              mov.l   48h+var_10[sp], r2
FFF21F7F  ac09                              mov.l   48h+var_4[sp], r1
FFF21F81  60c0                              sub     #0Ch, sp
FFF21F83  a085                              mov.l   r5, 54h+var_4C[sp]
FFF21F85  72550c06                          add     #60Ch, r5, r5
FFF21F89  a00d                              mov.l   r5, 54h+var_50[sp]
FFF21F8B  c30f                              mov.b   r15, 54h+var_54[sp]
FFF21F8D  05b94300                          bsr.a   sub_FFF26346
FFF21F91  62c0                              add     #0Ch, sp
FFF21F93  a209                              mov.l   r1, 48h+var_24[sp]
FFF21F95  aa09                              mov.l   48h+var_24[sp], r1
FFF21F97  6101                              cmp     #0, r1
FFF21F99  3aae00                            beq.w   loc_FFF22047
FFF21F9C  aa09                              mov.l   48h+var_24[sp], r1
FFF21F9E  6602                              mov.l   #0, r2
FFF21FA0  0580ceff                          bsr.a   sub_FFF1EE20
FFF21FA4  a009                              mov.l   r1, 48h+var_44[sp]
FFF21FA6  384202                            bra.w   loc_FFF221E8
FFF21FA9  aa09                   loc_FFF21FA9 mov.l   48h+var_24[sp], r1
FFF21FAB  7601d3fe                          cmp     #-12Dh, r1
FFF21FAF  10                                beq.s   loc_FFF21FB7
FFF21FB0  aa09                              mov.l   48h+var_24[sp], r1
FFF21FB2  7601d4fe                          cmp     #-12Ch, r1
FFF21FB6  1d                                bne.s   loc_FFF21FBB
FFF21FB7  f80601                 loc_FFF21FB7 mov.l   #1, 48h+var_48[sp]
FFF21FBA  0c                                bra.s   loc_FFF21FBE
FFF21FBB  f80600                 loc_FFF21FBB mov.l   #0, 48h+var_48[sp]
FFF21FBE  ec01                   loc_FFF21FBE mov.l   48h+var_48[sp], r1
FFF21FC0  6101                              cmp     #0, r1
FFF21FC2  3b8500                            bne.w   loc_FFF22047
FFF21FC5  aa09                              mov.l   48h+var_24[sp], r1
FFF21FC7  6602                              mov.l   #0, r2
FFF21FC9  0557ceff                          bsr.a   sub_FFF1EE20
FFF21FCD  a009                              mov.l   r1, 48h+var_44[sp]
FFF21FCF  381902                            bra.w   loc_FFF221E8
FFF21FD2  5a1e3016               loc_FFF21FD2 movu.b  1630h[r1], r14
FFF21FD6  612e                              cmp     #2, r14
FFF21FD8  2112                              bne.b   loc_FFF21FEA
FFF21FDA  ac09                              mov.l   48h+var_4[sp], r1
FFF21FDC  591e6c                            movu.b  6Ch[r1], r14
FFF21FDF  752e10                            and     #10h, r14
FFF21FE2  755e10                            cmp     #10h, r14
FFF21FE5  1d                                bne.s   loc_FFF21FEA
FFF21FE6  f80601                            mov.l   #1, 48h+var_48[sp]
FFF21FE9  0c                                bra.s   loc_FFF21FED
FFF21FEA  f80600                 loc_FFF21FEA mov.l   #0, 48h+var_48[sp]
FFF21FED  ec01                   loc_FFF21FED mov.l   48h+var_48[sp], r1
FFF21FEF  6101                              cmp     #0, r1
FFF21FF1  2056                              beq.b   loc_FFF22047
FFF21FF3  ac09                              mov.l   48h+var_4[sp], r1
FFF21FF5  ae1a                              mov.l   64h[r1], r2
FFF21FF7  aa8b                              mov.l   48h+var_1C[sp], r3
FFF21FF9  4a323216                          add     1632h[r3], r2
FFF21FFD  72330c06                          add     #60Ch, r3, r3
FFF22001  05084200                          bsr.a   sub_FFF26209
FFF22005  a209                              mov.l   r1, 48h+var_24[sp]
FFF22007  aa09                              mov.l   48h+var_24[sp], r1
FFF22009  6101                              cmp     #0, r1
FFF2200B  10                                beq.s   loc_FFF22013
FFF2200C  e5000901                          mov.l   48h+var_24[sp], 48h+var_44[sp]
FFF22010  38d801                            bra.w   loc_FFF221E8
FFF22013  ac01                   loc_FFF22013 mov.l   48h+var_8[sp], r1
FFF22015  ec13                              mov.l   [r1], r3
FFF22017  aa8d                              mov.l   48h+var_1C[sp], r5
FFF22019  bf8c                              movu.w  48h+var_A[sp], r4
FFF2201B  ab82                              mov.l   48h+var_10[sp], r2
FFF2201D  ac09                              mov.l   48h+var_4[sp], r1
FFF2201F  60c0                              sub     #0Ch, sp
FFF22021  a085                              mov.l   r5, 54h+var_4C[sp]
FFF22023  72550c06                          add     #60Ch, r5, r5
FFF22027  a00d                              mov.l   r5, 54h+var_50[sp]
FFF22029  f80402                            mov.b   #2, 54h+var_54[sp]
FFF2202C  051a4300                          bsr.a   sub_FFF26346
FFF22030  62c0                              add     #0Ch, sp
FFF22032  a209                              mov.l   r1, 48h+var_24[sp]
FFF22034  aa09                              mov.l   48h+var_24[sp], r1
FFF22036  6101                              cmp     #0, r1
FFF22038  200f                              beq.b   loc_FFF22047
FFF2203A  aa09                              mov.l   48h+var_24[sp], r1
FFF2203C  6602                              mov.l   #0, r2
FFF2203E  05e2cdff                          bsr.a   sub_FFF1EE20
FFF22042  a009                              mov.l   r1, 48h+var_44[sp]
FFF22044  38a401                            bra.w   loc_FFF221E8
FFF22047  ac01                   loc_FFF22047 mov.l   48h+var_8[sp], r1
FFF22049  ec12                              mov.l   [r1], r2
FFF2204B  ac09                              mov.l   48h+var_4[sp], r1
FFF2204D  71030c                            add     #48h+var_3C, sp, r3
FFF22050  39c0e3                            bsr.w   sub_FFF20410
FFF22053  a209                              mov.l   r1, 48h+var_24[sp]
FFF22055  aa09                              mov.l   48h+var_24[sp], r1
FFF22057  6101                              cmp     #0, r1
FFF22059  10                                beq.s   loc_FFF22061
FFF2205A  e5000901                          mov.l   48h+var_24[sp], 48h+var_44[sp]
FFF2205E  388a01                            bra.w   loc_FFF221E8
FFF22061  e5000304               loc_FFF22061 mov.l   48h+var_3C[sp], 48h+var_38[sp]
FFF22065  bf89                              movu.w  48h+var_A[sp], r1
FFF22067  6c51                              shll    #5, r1
FFF22069  06890104                          add     48h+var_38[sp].l, r1
FFF2206D  a101                              mov.l   r1, 48h+var_38[sp]
FFF2206F  ab81                              mov.l   48h+var_10[sp], r1
FFF22071  581e                              movu.b  [r1], r14
FFF22073  755ee5                            cmp     #-1Bh, r14
FFF22076  1e                                bne.s   loc_FFF2207C
FFF22077  ab81                              mov.l   48h+var_10[sp], r1
FFF22079  f81405                            mov.b   #5, [r1]
FFF2207C  ab82                   loc_FFF2207C mov.l   48h+var_10[sp], r2
FFF2207E  a901                              mov.l   48h+var_38[sp], r1
FFF22080  754320                            mov.l   #20h, r3 ; ' '
FFF22083  05f5c300                          bsr.a   sub_FFF2E478
FFF22087  ab01                              mov.l   48h+var_18[sp], r1
FFF22089  6011                              sub     #1, r1
FFF2208B  a301                              mov.l   r1, 48h+var_18[sp]
FFF2208D  ab01                              mov.l   48h+var_18[sp], r1
FFF2208F  6101                              cmp     #0, r1
FFF22091  2124                              bne.b   loc_FFF220B5
FFF22093  ac01                              mov.l   48h+var_8[sp], r1
FFF22095  a98a                              mov.l   48h+var_2C[sp], r2
FFF22097  fe6212                            mov.l   [r2, r1], r2
FFF2209A  a88b                              mov.l   48h+var_3C[sp], r3
FFF2209C  ac09                              mov.l   48h+var_4[sp], r1
FFF2209E  3904e4                            bsr.w   sub_FFF204A2
FFF220A1  a209                              mov.l   r1, 48h+var_24[sp]
FFF220A3  aa09                              mov.l   48h+var_24[sp], r1
FFF220A5  6101                              cmp     #0, r1
FFF220A7  10                                beq.s   loc_FFF220AF
FFF220A8  e5000901                          mov.l   48h+var_24[sp], 48h+var_44[sp]
FFF220AC  383c01                            bra.w   loc_FFF221E8
FFF220AF  3e0100                 loc_FFF220AF mov.l   #0, 48h+var_44[sp]
FFF220B2  383601                            bra.w   loc_FFF221E8
FFF220B5  a901                   loc_FFF220B5 mov.l   48h+var_38[sp], r1
FFF220B7  06850103                          cmp     48h+var_3C[sp].l, r1
FFF220BB  2152                              bne.b   loc_FFF2210D
FFF220BD  ac01                              mov.l   48h+var_8[sp], r1
FFF220BF  a98a                              mov.l   48h+var_2C[sp], r2
FFF220C1  fe6212                            mov.l   [r2, r1], r2
FFF220C4  a88b                              mov.l   48h+var_3C[sp], r3
FFF220C6  ac09                              mov.l   48h+var_4[sp], r1
FFF220C8  39dae3                            bsr.w   sub_FFF204A2
FFF220CB  a209                              mov.l   r1, 48h+var_24[sp]
FFF220CD  aa09                              mov.l   48h+var_24[sp], r1
FFF220CF  6101                              cmp     #0, r1
FFF220D1  10                                beq.s   loc_FFF220D9
FFF220D2  e5000901                          mov.l   48h+var_24[sp], 48h+var_44[sp]
FFF220D6  381201                            bra.w   loc_FFF221E8
FFF220D9  a989                   loc_FFF220D9 mov.l   48h+var_2C[sp], r1
FFF220DB  6211                              add     #1, r1
FFF220DD  a189                              mov.l   r1, 48h+var_2C[sp]
FFF220DF  ac01                              mov.l   48h+var_8[sp], r1
FFF220E1  a98a                              mov.l   48h+var_2C[sp], r2
FFF220E3  fe6212                            mov.l   [r2, r1], r2
FFF220E6  ac09                              mov.l   48h+var_4[sp], r1
FFF220E8  71030c                            add     #48h+var_3C, sp, r3
FFF220EB  3925e3                            bsr.w   sub_FFF20410
FFF220EE  a209                              mov.l   r1, 48h+var_24[sp]
FFF220F0  aa09                              mov.l   48h+var_24[sp], r1
FFF220F2  6101                              cmp     #0, r1
FFF220F4  10                                beq.s   loc_FFF220FC
FFF220F5  e5000901                          mov.l   48h+var_24[sp], 48h+var_44[sp]
FFF220F9  38ef00                            bra.w   loc_FFF221E8
FFF220FC  e5000304               loc_FFF220FC mov.l   48h+var_3C[sp], 48h+var_38[sp]
FFF22100  ac09                              mov.l   48h+var_4[sp], r1
FFF22102  ad99                              mov.l   5Ch[r1], r1
FFF22104  7521e0                            and     #-20h, r1
FFF22107  06890104                          add     48h+var_38[sp].l, r1
FFF2210B  a101                              mov.l   r1, 48h+var_38[sp]
FFF2210D  e5000d06               loc_FFF2210D mov.l   48h+var_14[sp], 48h+var_30[sp]
FFF22111  ab81                              mov.l   48h+var_10[sp], r1
FFF22113  39ffe7                            bsr.w   sub_FFF20912
FFF22116  8589                              mov.b   r1, 48h+var_31[sp]
FFF22118  3e0801                            mov.l   #1, 48h+var_28[sp]
FFF2211B  389f00                            bra.w   loc_FFF221BA
FFF2211E  7111e0                 loc_FFF2211E add     #-20h, r1, r1
FFF22121  a101                              mov.l   r1, 48h+var_38[sp]
FFF22123  ac0b                              mov.l   48h+var_4[sp], r3
FFF22125  a982                              mov.l   48h+var_30[sp], r2
FFF22127  391ff1                            bsr.w   sub_FFF21246
FFF2212A  a209                              mov.l   r1, 48h+var_24[sp]
FFF2212C  aa09                              mov.l   48h+var_24[sp], r1
FFF2212E  6c11                              shll    #1, r1
FFF22130  06890106                          add     48h+var_30[sp].l, r1
FFF22134  a181                              mov.l   r1, 48h+var_30[sp]
FFF22136  aa01                              mov.l   48h+var_28[sp], r1
FFF22138  a902                              mov.l   48h+var_38[sp], r2
FFF2213A  c321                              mov.b   r1, [r2]
FFF2213C  a901                              mov.l   48h+var_38[sp], r1
FFF2213E  3c1b0f                            mov.b   #0Fh, 0Bh[r1]
FFF22141  b589                              movu.b  48h+var_31[sp], r1
FFF22143  a902                              mov.l   48h+var_38[sp], r2
FFF22145  8329                              mov.b   r1, 0Dh[r2]
FFF22147  a901                              mov.l   48h+var_38[sp], r1
FFF22149  06850103                          cmp     48h+var_3C[sp].l, r1
FFF2214D  1a                                bne.s   loc_FFF22157
FFF2214E  ab01                              mov.l   48h+var_18[sp], r1
FFF22150  6111                              cmp     #1, r1
FFF22152  15                                beq.s   loc_FFF22157
FFF22153  f80601                            mov.l   #1, 48h+var_48[sp]
FFF22156  0c                                bra.s   loc_FFF2215A
FFF22157  f80600                 loc_FFF22157 mov.l   #0, 48h+var_48[sp]
FFF2215A  ec01                   loc_FFF2215A mov.l   48h+var_48[sp], r1
FFF2215C  6101                              cmp     #0, r1
FFF2215E  2050                              beq.b   loc_FFF221AE
FFF22160  ac01                              mov.l   48h+var_8[sp], r1
FFF22162  a98a                              mov.l   48h+var_2C[sp], r2
FFF22164  fe6212                            mov.l   [r2, r1], r2
FFF22167  a88b                              mov.l   48h+var_3C[sp], r3
FFF22169  ac09                              mov.l   48h+var_4[sp], r1
FFF2216B  3937e3                            bsr.w   sub_FFF204A2
FFF2216E  a209                              mov.l   r1, 48h+var_24[sp]
FFF22170  aa09                              mov.l   48h+var_24[sp], r1
FFF22172  6101                              cmp     #0, r1
FFF22174  17                                beq.s   loc_FFF2217B
FFF22175  e5000901                          mov.l   48h+var_24[sp], 48h+var_44[sp]
FFF22179  2e6f                              bra.b   loc_FFF221E8
FFF2217B  a989                   loc_FFF2217B mov.l   48h+var_2C[sp], r1
FFF2217D  6211                              add     #1, r1
FFF2217F  a189                              mov.l   r1, 48h+var_2C[sp]
FFF22181  ac01                              mov.l   48h+var_8[sp], r1
FFF22183  a98a                              mov.l   48h+var_2C[sp], r2
FFF22185  fe6212                            mov.l   [r2, r1], r2
FFF22188  ac09                              mov.l   48h+var_4[sp], r1
FFF2218A  71030c                            add     #48h+var_3C, sp, r3
FFF2218D  3983e2                            bsr.w   sub_FFF20410
FFF22190  a209                              mov.l   r1, 48h+var_24[sp]
FFF22192  aa09                              mov.l   48h+var_24[sp], r1
FFF22194  6101                              cmp     #0, r1
FFF22196  17                                beq.s   loc_FFF2219D
FFF22197  e5000901                          mov.l   48h+var_24[sp], 48h+var_44[sp]
FFF2219B  2e4d                              bra.b   loc_FFF221E8
FFF2219D  e5000304               loc_FFF2219D mov.l   48h+var_3C[sp], 48h+var_38[sp]
FFF221A1  ac09                              mov.l   48h+var_4[sp], r1
FFF221A3  ad99                              mov.l   5Ch[r1], r1
FFF221A5  7521e0                            and     #-20h, r1
FFF221A8  06890104                          add     48h+var_38[sp].l, r1
FFF221AC  a101                              mov.l   r1, 48h+var_38[sp]
FFF221AE  ab01                   loc_FFF221AE mov.l   48h+var_18[sp], r1
FFF221B0  6011                              sub     #1, r1
FFF221B2  a301                              mov.l   r1, 48h+var_18[sp]
FFF221B4  aa01                              mov.l   48h+var_28[sp], r1
FFF221B6  6211                              add     #1, r1
FFF221B8  a201                              mov.l   r1, 48h+var_28[sp]
FFF221BA  ab01                   loc_FFF221BA mov.l   48h+var_18[sp], r1
FFF221BC  6101                              cmp     #0, r1
FFF221BE  a901                              mov.l   48h+var_38[sp], r1
FFF221C0  3b5eff                            bne.w   loc_FFF2211E
FFF221C3  a902                              mov.l   48h+var_38[sp], r2
FFF221C5  582e                              movu.b  [r2], r14
FFF221C7  786e                              bset    #6, r14
FFF221C9  c31e                              mov.b   r14, [r1]
FFF221CB  ac01                              mov.l   48h+var_8[sp], r1
FFF221CD  a98a                              mov.l   48h+var_2C[sp], r2
FFF221CF  fe6212                            mov.l   [r2, r1], r2
FFF221D2  a88b                              mov.l   48h+var_3C[sp], r3
FFF221D4  ac09                              mov.l   48h+var_4[sp], r1
FFF221D6  39cce2                            bsr.w   sub_FFF204A2
FFF221D9  a209                              mov.l   r1, 48h+var_24[sp]
FFF221DB  aa09                              mov.l   48h+var_24[sp], r1
FFF221DD  6101                              cmp     #0, r1
FFF221DF  16                                beq.s   loc_FFF221E5
FFF221E0  e5000901                          mov.l   48h+var_24[sp], 48h+var_44[sp]
FFF221E4  0c                                bra.s   loc_FFF221E8
FFF221E5  3e0100                 loc_FFF221E5 mov.l   #0, 48h+var_44[sp]
FFF221E8  a809                   loc_FFF221E8 mov.l   48h+var_44[sp], r1
FFF221EA  a281                              mov.l   r1, 48h+var_20[sp]
FFF221EC  6712                              rtsd    #12h
FFF221EE  7100dc                 sub_FFF221EE add     #-24h, sp, sp   ; <<<< FUNC sub_FFF221EE
FFF221F1  a201                              mov.l   r1, 24h+var_4[sp]
FFF221F3  a18a                              mov.l   r2, 24h+var_8[sp]
FFF221F5  930b                              mov.w   r3, 24h+var_A[sp]
FFF221F7  a10c                              mov.l   r4, 24h+var_10[sp]
FFF221F9  d5000d05                          mov.w   24h+var_A[sp], 24h+var_1A[sp]
FFF221FD  3e0300                            mov.l   #0, 24h+var_18[sp]
FFF22200  389300                            bra.w   loc_FFF22293
FFF22203  b909                   loc_FFF22203 movu.w  24h+var_1A[sp], r1
FFF22205  06c5010d                          cmp     24h+var_A[sp].uw, r1
FFF22209  10                                beq.s   loc_FFF22211
FFF2220A  aa01                              mov.l   24h+var_4[sp], r1
FFF2220C  8a99                              mov.b   0Bh[r1], r1
FFF2220E  61f1                              cmp     #0Fh, r1
FFF22210  1d                                bne.s   loc_FFF22215
FFF22211  f80601                 loc_FFF22211 mov.l   #1, 24h+var_24[sp]
FFF22214  0c                                bra.s   loc_FFF22218
FFF22215  f80600                 loc_FFF22215 mov.l   #0, 24h+var_24[sp]
FFF22218  ec01                   loc_FFF22218 mov.l   24h+var_24[sp], r1
FFF2221A  6101                              cmp     #0, r1
FFF2221C  16                                beq.s   loc_FFF22222
FFF2221D  aa01                              mov.l   24h+var_4[sp], r1
FFF2221F  f814e5                            mov.b   #-1Bh, [r1]
FFF22222  a989                   loc_FFF22222 mov.l   24h+var_8[sp], r1
FFF22224  a88a                              mov.l   24h+var_18[sp], r2
FFF22226  fe621e                            mov.l   [r2, r1], r14
FFF22229  aa01                              mov.l   24h+var_4[sp], r1
FFF2222B  47e1                              cmp     r14, r1
FFF2222D  19                                bne.s   loc_FFF22236
FFF2222E  9b09                              mov.w   24h+var_A[sp], r1
FFF22230  6011                              sub     #1, r1
FFF22232  9309                              mov.w   r1, 24h+var_A[sp]
FFF22234  2e33                              bra.b   loc_FFF22267
FFF22236  aa01                   loc_FFF22236 mov.l   24h+var_4[sp], r1
FFF22238  7111e0                            add     #-20h, r1, r1
FFF2223B  a201                              mov.l   r1, 24h+var_4[sp]
FFF2223D  bb09                              movu.w  24h+var_A[sp], r1
FFF2223F  6101                              cmp     #0, r1
FFF22241  200d                              beq.b   loc_FFF2224E
FFF22243  aa01                              mov.l   24h+var_4[sp], r1
FFF22245  8a99                              mov.b   0Bh[r1], r1
FFF22247  61f1                              cmp     #0Fh, r1
FFF22249  15                                beq.s   loc_FFF2224E
FFF2224A  f80601                            mov.l   #1, 24h+var_24[sp]
FFF2224D  0c                                bra.s   loc_FFF22251
FFF2224E  f80600                 loc_FFF2224E mov.l   #0, 24h+var_24[sp]
FFF22251  ec01                   loc_FFF22251 mov.l   24h+var_24[sp], r1
FFF22253  6101                              cmp     #0, r1
FFF22255  16                                beq.s   loc_FFF2225B
FFF22256  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF22259  2e44                              bra.b   loc_FFF2229D
FFF2225B  9b09                   loc_FFF2225B mov.w   24h+var_A[sp], r1
FFF2225D  6011                              sub     #1, r1
FFF2225F  9309                              mov.w   r1, 24h+var_A[sp]
FFF22261  bb09                   loc_FFF22261 movu.w  24h+var_A[sp], r1
FFF22263  6101                              cmp     #0, r1
FFF22265  2a9e                              bgt.b   loc_FFF22203
FFF22267  bb09                   loc_FFF22267 movu.w  24h+var_A[sp], r1
FFF22269  6101                              cmp     #0, r1
FFF2226B  1e                                bne.s   loc_FFF22271
FFF2226C  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF2226F  2e2e                              bra.b   loc_FFF2229D
FFF22271  a889                   loc_FFF22271 mov.l   24h+var_18[sp], r1
FFF22273  6c21                              shll    #2, r1
FFF22275  06890107                          add     24h+var_8[sp].l, r1
FFF22279  e5100108                          mov.l   4[r1], 24h+var_4[sp]
FFF2227D  a909                              mov.l   24h+var_10[sp], r1
FFF2227F  ad99                              mov.l   5Ch[r1], r1
FFF22281  7521e0                            and     #-20h, r1
FFF22284  06890108                          add     24h+var_4[sp].l, r1
FFF22288  7111e0                            add     #-20h, r1, r1
FFF2228B  a201                              mov.l   r1, 24h+var_4[sp]
FFF2228D  a889                              mov.l   24h+var_18[sp], r1
FFF2228F  6211                              add     #1, r1
FFF22291  a089                              mov.l   r1, 24h+var_18[sp]
FFF22293  a889                   loc_FFF22293 mov.l   24h+var_18[sp], r1
FFF22295  6131                              cmp     #3, r1
FFF22297  29ca                              blt.b   loc_FFF22261
FFF22299  f90601bc                          mov.l   #-44h, 24h+var_20[sp]
FFF2229D  a809                   loc_FFF2229D mov.l   24h+var_20[sp], r1
FFF2229F  a101                              mov.l   r1, 24h+var_14[sp]
FFF222A1  6709                              rtsd    #9
FFF222A3  7100b8                 sub_FFF222A3 add     #-48h, sp, sp   ; <<<< FUNC sub_FFF222A3
FFF222A6  a409                              mov.l   r1, 48h+var_4[sp]
FFF222A8  a402                              mov.l   r2, 48h+var_8[sp]
FFF222AA  a38b                              mov.l   r3, 48h+var_C[sp]
FFF222AC  a384                              mov.l   r4, 48h+var_10[sp]
FFF222AE  3e0400                            mov.l   #0, 48h+var_38[sp]
FFF222B1  ac01                              mov.l   48h+var_8[sp], r1
FFF222B3  395fe6                            bsr.w   sub_FFF20912
FFF222B6  8389                              mov.b   r1, 48h+var_39[sp]
FFF222B8  e5000f02                          mov.l   48h+var_C[sp], 48h+var_40[sp]
FFF222BC  ac09                   loc_FFF222BC mov.l   48h+var_4[sp], r1
FFF222BE  a902                              mov.l   48h+var_38[sp], r2
FFF222C0  fe621e                            mov.l   [r2, r1], r14
FFF222C3  ac01                              mov.l   48h+var_8[sp], r1
FFF222C5  47e1                              cmp     r14, r1
FFF222C7  212e                              bne.b   loc_FFF222F5
FFF222C9  a901                              mov.l   48h+var_38[sp], r1
FFF222CB  6211                              add     #1, r1
FFF222CD  fdc21e                            shll    #2, r1, r14
FFF222D0  06890e11                          add     48h+var_4[sp].l, r14
FFF222D4  a101                              mov.l   r1, 48h+var_38[sp]
FFF222D6  e4e010                            mov.l   [r14], 48h+var_8[sp]
FFF222D9  ac01                              mov.l   48h+var_8[sp], r1
FFF222DB  6101                              cmp     #0, r1
FFF222DD  1f                                bne.s   loc_FFF222E4
FFF222DE  f8069d                            mov.l   #-63h, 48h+var_48[sp]
FFF222E1  389d00                            bra.w   loc_FFF2237E
FFF222E4  ab81                   loc_FFF222E4 mov.l   48h+var_10[sp], r1
FFF222E6  ad99                              mov.l   5Ch[r1], r1
FFF222E8  7521e0                            and     #-20h, r1
FFF222EB  06890110                          add     48h+var_8[sp].l, r1
FFF222EF  7111e0                            add     #-20h, r1, r1
FFF222F2  a401                              mov.l   r1, 48h+var_8[sp]
FFF222F4  08                                bra.s   loc_FFF222FC
FFF222F5  ac01                   loc_FFF222F5 mov.l   48h+var_8[sp], r1
FFF222F7  7111e0                            add     #-20h, r1, r1
FFF222FA  a401                              mov.l   r1, 48h+var_8[sp]
FFF222FC  ac01                   loc_FFF222FC mov.l   48h+var_8[sp], r1
FFF222FE  8a99                              mov.b   0Bh[r1], r1
FFF22300  61f1                              cmp     #0Fh, r1
FFF22302  16                                beq.s   loc_FFF22308
FFF22303  f8069d                            mov.l   #-63h, 48h+var_48[sp]
FFF22306  2e78                              bra.b   loc_FFF2237E
FFF22308  ac01                   loc_FFF22308 mov.l   48h+var_8[sp], r1
FFF2230A  b319                              movu.b  0Dh[r1], r1
FFF2230C  45010f                            cmp     48h+var_39[sp], r1
FFF2230F  16                                beq.s   loc_FFF22315
FFF22310  f8069d                            mov.l   #-63h, 48h+var_48[sp]
FFF22313  2e6b                              bra.b   loc_FFF2237E
FFF22315  ac01                   loc_FFF22315 mov.l   48h+var_8[sp], r1
FFF22317  710218                            add     #48h+var_30, sp, r2
FFF2231A  39ddf0                            bsr.w   sub_FFF213F7
FFF2231D  a109                              mov.l   r1, 48h+var_34[sp]
FFF2231F  710118                            add     #48h+var_30, sp, r1
FFF22322  a009                              mov.l   r1, 48h+var_44[sp]
FFF22324  2e39                              bra.b   loc_FFF2235D
FFF22326  a881                   loc_FFF22326 mov.l   48h+var_40[sp], r1
FFF22328  5c1e                              movu.w  [r1], r14
FFF2232A  a80a                              mov.l   48h+var_44[sp], r2
FFF2232C  06c42e                            cmp     [r2].uw, r14
FFF2232F  201e                              beq.b   loc_FFF2234D
FFF22331  a80a                              mov.l   48h+var_44[sp], r2
FFF22333  3913f2                            bsr.w   sub_FFF21546
FFF22336  6101                              cmp     #0, r1
FFF22338  2010                              beq.b   loc_FFF22348
FFF2233A  a881                              mov.l   48h+var_40[sp], r1
FFF2233C  6221                              add     #2, r1
FFF2233E  a081                              mov.l   r1, 48h+var_40[sp]
FFF22340  a809                              mov.l   48h+var_44[sp], r1
FFF22342  6221                              add     #2, r1
FFF22344  a009                              mov.l   r1, 48h+var_44[sp]
FFF22346  2e11                              bra.b   loc_FFF22357
FFF22348  f8069d                 loc_FFF22348 mov.l   #-63h, 48h+var_48[sp]
FFF2234B  2e33                              bra.b   loc_FFF2237E
FFF2234D  6221                   loc_FFF2234D add     #2, r1
FFF2234F  a081                              mov.l   r1, 48h+var_40[sp]
FFF22351  a809                              mov.l   48h+var_44[sp], r1
FFF22353  6221                              add     #2, r1
FFF22355  a009                              mov.l   r1, 48h+var_44[sp]
FFF22357  a909                   loc_FFF22357 mov.l   48h+var_34[sp], r1
FFF22359  6011                              sub     #1, r1
FFF2235B  a109                              mov.l   r1, 48h+var_34[sp]
FFF2235D  a909                   loc_FFF2235D mov.l   48h+var_34[sp], r1
FFF2235F  6101                              cmp     #0, r1
FFF22361  2ac5                              bgt.b   loc_FFF22326
FFF22363  ac01                              mov.l   48h+var_8[sp], r1
FFF22365  581e                              movu.b  [r1], r14
FFF22367  752e40                            and     #40h, r14 ; '@'
FFF2236A  755e40                            cmp     #40h, r14 ; '@'
FFF2236D  3b4fff                            bne.w   loc_FFF222BC
FFF22370  a881                              mov.l   48h+var_40[sp], r1
FFF22372  5c1e                              movu.w  [r1], r14
FFF22374  610e                              cmp     #0, r14
FFF22376  1d                                bne.s   loc_FFF2237B
FFF22377  f80600                            mov.l   #0, 48h+var_48[sp]
FFF2237A  0c                                bra.s   loc_FFF2237E
FFF2237B  f8069d                 loc_FFF2237B mov.l   #-63h, 48h+var_48[sp]
FFF2237E  ec01                   loc_FFF2237E mov.l   48h+var_48[sp], r1
FFF22380  a309                              mov.l   r1, 48h+var_14[sp]
FFF22382  6712                              rtsd    #12h
FFF22384  7100d8                 sub_FFF22384 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF22384
FFF22387  a209                              mov.l   r1, 28h+var_4[sp]
FFF22389  a202                              mov.l   r2, 28h+var_8[sp]
FFF2238B  a18b                              mov.l   r3, 28h+var_C[sp]
FFF2238D  e5000902                          mov.l   28h+var_4[sp], 28h+var_20[sp]
FFF22391  71010c                            add     #28h+var_1C, sp, r1
FFF22394  a009                              mov.l   r1, 28h+var_24[sp]
FFF22396  a98b                              mov.l   28h+var_C[sp], r3
FFF22398  aa02                              mov.l   28h+var_8[sp], r2
FFF2239A  71010c                            add     #28h+var_1C, sp, r1
FFF2239D  39eee4                            bsr.w   sub_FFF2088B
FFF223A0  a809                              mov.l   28h+var_24[sp], r1
FFF223A2  581e                              movu.b  [r1], r14
FFF223A4  755ee5                            cmp     #-1Bh, r14
FFF223A7  2149                              bne.b   loc_FFF223F0
FFF223A9  a809                              mov.l   28h+var_24[sp], r1
FFF223AB  f81405                            mov.b   #5, [r1]
FFF223AE  2e42                              bra.b   loc_FFF223F0
FFF223B0  a809                   loc_FFF223B0 mov.l   28h+var_24[sp], r1
FFF223B2  5811                              movu.b  [r1], r1
FFF223B4  0525b800                          bsr.a   sub_FFF2DBD9
FFF223B8  6101                              cmp     #0, r1
FFF223BA  201c                              beq.b   loc_FFF223D6
FFF223BC  a809                              mov.l   28h+var_24[sp], r1
FFF223BE  581e                              movu.b  [r1], r14
FFF223C0  6211                              add     #1, r1
FFF223C2  a882                              mov.l   28h+var_20[sp], r2
FFF223C4  582f                              movu.b  [r2], r15
FFF223C6  a009                              mov.l   r1, 28h+var_24[sp]
FFF223C8  a881                              mov.l   28h+var_20[sp], r1
FFF223CA  6211                              add     #1, r1
FFF223CC  a081                              mov.l   r1, 28h+var_20[sp]
FFF223CE  47fe                              cmp     r15, r14
FFF223D0  16                                beq.s   loc_FFF223D6
FFF223D1  f8069d                            mov.l   #-63h, 28h+var_28[sp]
FFF223D4  2e27                              bra.b   loc_FFF223FB
FFF223D6  a809                   loc_FFF223D6 mov.l   28h+var_24[sp], r1
FFF223D8  581e                              movu.b  [r1], r14
FFF223DA  6211                              add     #1, r1
FFF223DC  a882                              mov.l   28h+var_20[sp], r2
FFF223DE  582f                              movu.b  [r2], r15
FFF223E0  a009                              mov.l   r1, 28h+var_24[sp]
FFF223E2  a881                              mov.l   28h+var_20[sp], r1
FFF223E4  6211                              add     #1, r1
FFF223E6  a081                              mov.l   r1, 28h+var_20[sp]
FFF223E8  47fe                              cmp     r15, r14
FFF223EA  16                                beq.s   loc_FFF223F0
FFF223EB  f8069d                            mov.l   #-63h, 28h+var_28[sp]
FFF223EE  2e0d                              bra.b   loc_FFF223FB
FFF223F0  a809                   loc_FFF223F0 mov.l   28h+var_24[sp], r1
FFF223F2  581e                              movu.b  [r1], r14
FFF223F4  610e                              cmp     #0, r14
FFF223F6  21ba                              bne.b   loc_FFF223B0
FFF223F8  f80600                            mov.l   #0, 28h+var_28[sp]
FFF223FB  ec01                   loc_FFF223FB mov.l   28h+var_28[sp], r1
FFF223FD  a181                              mov.l   r1, 28h+var_10[sp]
FFF223FF  670a                              rtsd    #0Ah
FFF22401  60c0                   sub_FFF22401 sub     #0Ch, sp   ; <<<< FUNC sub_FFF22401
FFF22403  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF22405  b909                              movu.w  0Ch+var_2[sp], r1
FFF22407  7701818200                        cmp     #8281h, r1
FFF2240C  290f                              blt.b   loc_FFF2241B
FFF2240E  b909                              movu.w  0Ch+var_2[sp], r1
FFF22410  77019a8200                        cmp     #829Ah, r1
FFF22415  2a06                              bgt.b   loc_FFF2241B
FFF22417  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF2241A  0c                                bra.s   loc_FFF2241E
FFF2241B  f80600                 loc_FFF2241B mov.l   #0, 0Ch+var_C[sp]
FFF2241E  ec01                   loc_FFF2241E mov.l   0Ch+var_C[sp], r1
FFF22420  6101                              cmp     #0, r1
FFF22422  b909                              movu.w  0Ch+var_2[sp], r1
FFF22424  11                                beq.s   loc_FFF2242D
FFF22425  7111df                            add     #-21h, r1, r1
FFF22428  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF2242A  389b00                            bra.w   loc_FFF224C5
FFF2242D  7701bf8300             loc_FFF2242D cmp     #83BFh, r1
FFF22432  290f                              blt.b   loc_FFF22441
FFF22434  b909                              movu.w  0Ch+var_2[sp], r1
FFF22436  7701d68300                        cmp     #83D6h, r1
FFF2243B  2a06                              bgt.b   loc_FFF22441
FFF2243D  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF22440  0c                                bra.s   loc_FFF22444
FFF22441  f80600                 loc_FFF22441 mov.l   #0, 0Ch+var_C[sp]
FFF22444  ec01                   loc_FFF22444 mov.l   0Ch+var_C[sp], r1
FFF22446  6101                              cmp     #0, r1
FFF22448  b909                              movu.w  0Ch+var_2[sp], r1
FFF2244A  10                                beq.s   loc_FFF22452
FFF2244B  7111e0                            add     #-20h, r1, r1
FFF2244E  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF22450  2e75                              bra.b   loc_FFF224C5
FFF22452  7701708400             loc_FFF22452 cmp     #8470h, r1
FFF22457  290f                              blt.b   loc_FFF22466
FFF22459  b909                              movu.w  0Ch+var_2[sp], r1
FFF2245B  77017e8400                        cmp     #847Eh, r1
FFF22460  2a06                              bgt.b   loc_FFF22466
FFF22462  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF22465  0c                                bra.s   loc_FFF22469
FFF22466  f80600                 loc_FFF22466 mov.l   #0, 0Ch+var_C[sp]
FFF22469  ec01                   loc_FFF22469 mov.l   0Ch+var_C[sp], r1
FFF2246B  6101                              cmp     #0, r1
FFF2246D  b909                              movu.w  0Ch+var_2[sp], r1
FFF2246F  10                                beq.s   loc_FFF22477
FFF22470  7111d0                            add     #-30h, r1, r1
FFF22473  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF22475  2e50                              bra.b   loc_FFF224C5
FFF22477  7701808400             loc_FFF22477 cmp     #8480h, r1
FFF2247C  290f                              blt.b   loc_FFF2248B
FFF2247E  b909                              movu.w  0Ch+var_2[sp], r1
FFF22480  7701918400                        cmp     #8491h, r1
FFF22485  2a06                              bgt.b   loc_FFF2248B
FFF22487  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF2248A  0c                                bra.s   loc_FFF2248E
FFF2248B  f80600                 loc_FFF2248B mov.l   #0, 0Ch+var_C[sp]
FFF2248E  ec01                   loc_FFF2248E mov.l   0Ch+var_C[sp], r1
FFF22490  6101                              cmp     #0, r1
FFF22492  b909                              movu.w  0Ch+var_2[sp], r1
FFF22494  10                                beq.s   loc_FFF2249C
FFF22495  7111cf                            add     #-31h, r1, r1
FFF22498  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF2249A  2e2b                              bra.b   loc_FFF224C5
FFF2249C  770140fa00             loc_FFF2249C cmp     #0FA40h, r1
FFF224A1  290f                              blt.b   loc_FFF224B0
FFF224A3  b909                              movu.w  0Ch+var_2[sp], r1
FFF224A5  770149fa00                        cmp     #0FA49h, r1
FFF224AA  2a06                              bgt.b   loc_FFF224B0
FFF224AC  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF224AF  0c                                bra.s   loc_FFF224B3
FFF224B0  f80600                 loc_FFF224B0 mov.l   #0, 0Ch+var_C[sp]
FFF224B3  ec01                   loc_FFF224B3 mov.l   0Ch+var_C[sp], r1
FFF224B5  6101                              cmp     #0, r1
FFF224B7  9909                              mov.w   0Ch+var_2[sp], r1
FFF224B9  12                                beq.s   loc_FFF224C3
FFF224BA  5f11                              movu.w  r1, r1
FFF224BC  7211148d                          add     #-72ECh, r1, r1
FFF224C0  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF224C2  0b                                bra.s   loc_FFF224C5
FFF224C3  9089                   loc_FFF224C3 mov.w   r1, 0Ch+var_6[sp]
FFF224C5  d5000304               loc_FFF224C5 mov.w   0Ch+var_6[sp], 0Ch+var_4[sp]
FFF224C9  9901                              mov.w   0Ch+var_4[sp], r1
FFF224CB  5f11                              movu.w  r1, r1
FFF224CD  6703                              rtsd    #3
FFF224CF  7ea6                   sub_FFF224CF push.l  r6   ; <<<< FUNC sub_FFF224CF
FFF224D1  7100e0                            add     #-20h, sp, sp
FFF224D4  a189                              mov.l   r1, 20h+var_4[sp]
FFF224D6  a182                              mov.l   r2, 20h+var_8[sp]
FFF224D8  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF224DB  389f00                            bra.w   loc_FFF2257A
FFF224DE  8c81                   loc_FFF224DE mov.b   20h+var_E[sp], r1
FFF224E0  6101                              cmp     #0, r1
FFF224E2  1d                                bne.s   loc_FFF224E7
FFF224E3  f80601                            mov.l   #1, 20h+var_20[sp]
FFF224E6  0c                                bra.s   loc_FFF224EA
FFF224E7  f80600                 loc_FFF224E7 mov.l   #0, 20h+var_20[sp]
FFF224EA  ec01                   loc_FFF224EA mov.l   20h+var_20[sp], r1
FFF224EC  6101                              cmp     #0, r1
FFF224EE  3ba000                            bne.w   loc_FFF2258E
FFF224F1  8c89                              mov.b   20h+var_D[sp], r1
FFF224F3  6101                              cmp     #0, r1
FFF224F5  18                                bne.s   loc_FFF224FD
FFF224F6  f90603ff                          mov.l   #-1, 20h+var_14[sp]
FFF224FA  389400                            bra.w   loc_FFF2258E
FFF224FD  8c81                   loc_FFF224FD mov.b   20h+var_E[sp], r1
FFF224FF  6101                              cmp     #0, r1

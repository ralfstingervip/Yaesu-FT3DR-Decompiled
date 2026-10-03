; ==== feat_d  FFF40D80-FFF42000  (file 340D80-342000) ====
FFF40D80  2023                              beq.b   loc_FFF40DA3
FFF40D82  b082                              movu.b  4+var_2[sp], r2
FFF40D84  6621                              mov.l   #2, r1
FFF40D86  fd6221                            shll    r2, r1
FFF40D89  0565f1fa                          bsr.a   sub_FFEEFEEE
FFF40D8D  b081                              movu.b  4+var_2[sp], r1
FFF40D8F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40D95  4b1e                              add     r1, r14
FFF40D97  fbf2468e0000                      mov.l   #8E46h, r15
FFF40D9D  4b1f                              add     r1, r15
FFF40D9F  c5fe8d8d                          mov.b   8Dh[r15], 8Dh[r14]
FFF40DA3  b081                   loc_FFF40DA3 movu.b  4+var_2[sp], r1
FFF40DA5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40DAB  4b1e                              add     r1, r14
FFF40DAD  59ee90                            movu.b  90h[r14], r14
FFF40DB0  fbf2468e0000                      mov.l   #8E46h, r15
FFF40DB6  4b1f                              add     r1, r15
FFF40DB8  45fe90                            cmp     90h[r15], r14
FFF40DBB  2023                              beq.b   loc_FFF40DDE
FFF40DBD  b082                              movu.b  4+var_2[sp], r2
FFF40DBF  6621                              mov.l   #2, r1
FFF40DC1  fd6221                            shll    r2, r1
FFF40DC4  052af1fa                          bsr.a   sub_FFEEFEEE
FFF40DC8  b081                              movu.b  4+var_2[sp], r1
FFF40DCA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40DD0  4b1e                              add     r1, r14
FFF40DD2  fbf2468e0000                      mov.l   #8E46h, r15
FFF40DD8  4b1f                              add     r1, r15
FFF40DDA  c5fe9090                          mov.b   90h[r15], 90h[r14]
FFF40DDE  b081                   loc_FFF40DDE movu.b  4+var_2[sp], r1
FFF40DE0  6211                              add     #1, r1
FFF40DE2  8081                              mov.b   r1, 4+var_2[sp]
FFF40DE4  b081                   loc_FFF40DE4 movu.b  4+var_2[sp], r1
FFF40DE6  6131                              cmp     #3, r1
FFF40DE8  2980                              blt.b   loc_FFF40D68
FFF40DEA  38da02                            bra.w   loc_FFF410C4
FFF40DED  3c0100                 loc_FFF40DED mov.b   #0, 4+var_3[sp]
FFF40DF0  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40DF3  2e3e                              bra.b   loc_FFF40E31
FFF40DF5  b081                   loc_FFF40DF5 movu.b  4+var_2[sp], r1
FFF40DF7  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40DFD  4b1e                              add     r1, r14
FFF40DFF  59ee95                            movu.b  95h[r14], r14
FFF40E02  fbf2468e0000                      mov.l   #8E46h, r15
FFF40E08  4b1f                              add     r1, r15
FFF40E0A  45fe95                            cmp     95h[r15], r14
FFF40E0D  201e                              beq.b   loc_FFF40E2B
FFF40E0F  b081                              movu.b  4+var_2[sp], r1
FFF40E11  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40E17  4b1e                              add     r1, r14
FFF40E19  fbf2468e0000                      mov.l   #8E46h, r15
FFF40E1F  4b1f                              add     r1, r15
FFF40E21  c5fe9595                          mov.b   95h[r15], 95h[r14]
FFF40E25  b009                              movu.b  4+var_3[sp], r1
FFF40E27  6211                              add     #1, r1
FFF40E29  8009                              mov.b   r1, 4+var_3[sp]
FFF40E2B  b081                   loc_FFF40E2B movu.b  4+var_2[sp], r1
FFF40E2D  6211                              add     #1, r1
FFF40E2F  8081                              mov.b   r1, 4+var_2[sp]
FFF40E31  b081                   loc_FFF40E31 movu.b  4+var_2[sp], r1
FFF40E33  6141                              cmp     #4, r1
FFF40E35  29c0                              blt.b   loc_FFF40DF5
FFF40E37  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40E3A  2e3e                              bra.b   loc_FFF40E78
FFF40E3C  b081                   loc_FFF40E3C movu.b  4+var_2[sp], r1
FFF40E3E  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40E44  4b1e                              add     r1, r14
FFF40E46  59ee99                            movu.b  99h[r14], r14
FFF40E49  fbf2468e0000                      mov.l   #8E46h, r15
FFF40E4F  4b1f                              add     r1, r15
FFF40E51  45fe99                            cmp     99h[r15], r14
FFF40E54  201e                              beq.b   loc_FFF40E72
FFF40E56  b081                              movu.b  4+var_2[sp], r1
FFF40E58  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40E5E  4b1e                              add     r1, r14
FFF40E60  fbf2468e0000                      mov.l   #8E46h, r15
FFF40E66  4b1f                              add     r1, r15
FFF40E68  c5fe9999                          mov.b   99h[r15], 99h[r14]
FFF40E6C  b009                              movu.b  4+var_3[sp], r1
FFF40E6E  6211                              add     #1, r1
FFF40E70  8009                              mov.b   r1, 4+var_3[sp]
FFF40E72  b081                   loc_FFF40E72 movu.b  4+var_2[sp], r1
FFF40E74  6211                              add     #1, r1
FFF40E76  8081                              mov.b   r1, 4+var_2[sp]
FFF40E78  b081                   loc_FFF40E78 movu.b  4+var_2[sp], r1
FFF40E7A  6141                              cmp     #4, r1
FFF40E7C  29c0                              blt.b   loc_FFF40E3C
FFF40E7E  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40E81  2e3e                              bra.b   loc_FFF40EBF
FFF40E83  b081                   loc_FFF40E83 movu.b  4+var_2[sp], r1
FFF40E85  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40E8B  4b1e                              add     r1, r14
FFF40E8D  59ee9d                            movu.b  9Dh[r14], r14
FFF40E90  fbf2468e0000                      mov.l   #8E46h, r15
FFF40E96  4b1f                              add     r1, r15
FFF40E98  45fe9d                            cmp     9Dh[r15], r14
FFF40E9B  201e                              beq.b   loc_FFF40EB9
FFF40E9D  b081                              movu.b  4+var_2[sp], r1
FFF40E9F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40EA5  4b1e                              add     r1, r14
FFF40EA7  fbf2468e0000                      mov.l   #8E46h, r15
FFF40EAD  4b1f                              add     r1, r15
FFF40EAF  c5fe9d9d                          mov.b   9Dh[r15], 9Dh[r14]
FFF40EB3  b009                              movu.b  4+var_3[sp], r1
FFF40EB5  6211                              add     #1, r1
FFF40EB7  8009                              mov.b   r1, 4+var_3[sp]
FFF40EB9  b081                   loc_FFF40EB9 movu.b  4+var_2[sp], r1
FFF40EBB  6211                              add     #1, r1
FFF40EBD  8081                              mov.b   r1, 4+var_2[sp]
FFF40EBF  b081                   loc_FFF40EBF movu.b  4+var_2[sp], r1
FFF40EC1  6141                              cmp     #4, r1
FFF40EC3  29c0                              blt.b   loc_FFF40E83
FFF40EC5  b009                              movu.b  4+var_3[sp], r1
FFF40EC7  6101                              cmp     #0, r1
FFF40EC9  17                                beq.s   loc_FFF40ED0
FFF40ECA  6611                              mov.l   #1, r1
FFF40ECC  0522f0fa                          bsr.a   sub_FFEEFEEE
FFF40ED0  3c0200                 loc_FFF40ED0 mov.b   #0, 4+var_2[sp]
FFF40ED3  2e7e                              bra.b   loc_FFF40F51
FFF40ED5  b081                   loc_FFF40ED5 movu.b  4+var_2[sp], r1
FFF40ED7  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40EDD  4b1e                              add     r1, r14
FFF40EDF  59eea1                            movu.b  0A1h[r14], r14
FFF40EE2  fbf2468e0000                      mov.l   #8E46h, r15
FFF40EE8  4b1f                              add     r1, r15
FFF40EEA  45fea1                            cmp     0A1h[r15], r14
FFF40EED  2023                              beq.b   loc_FFF40F10
FFF40EEF  b082                              movu.b  4+var_2[sp], r2
FFF40EF1  6621                              mov.l   #2, r1
FFF40EF3  fd6221                            shll    r2, r1
FFF40EF6  05f8effa                          bsr.a   sub_FFEEFEEE
FFF40EFA  b081                              movu.b  4+var_2[sp], r1
FFF40EFC  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40F02  4b1e                              add     r1, r14
FFF40F04  fbf2468e0000                      mov.l   #8E46h, r15
FFF40F0A  4b1f                              add     r1, r15
FFF40F0C  c5fea1a1                          mov.b   0A1h[r15], 0A1h[r14]
FFF40F10  b081                   loc_FFF40F10 movu.b  4+var_2[sp], r1
FFF40F12  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40F18  4b1e                              add     r1, r14
FFF40F1A  59eea4                            movu.b  0A4h[r14], r14
FFF40F1D  fbf2468e0000                      mov.l   #8E46h, r15
FFF40F23  4b1f                              add     r1, r15
FFF40F25  45fea4                            cmp     0A4h[r15], r14
FFF40F28  2023                              beq.b   loc_FFF40F4B
FFF40F2A  b082                              movu.b  4+var_2[sp], r2
FFF40F2C  6621                              mov.l   #2, r1
FFF40F2E  fd6221                            shll    r2, r1
FFF40F31  05bdeffa                          bsr.a   sub_FFEEFEEE
FFF40F35  b081                              movu.b  4+var_2[sp], r1
FFF40F37  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40F3D  4b1e                              add     r1, r14
FFF40F3F  fbf2468e0000                      mov.l   #8E46h, r15
FFF40F45  4b1f                              add     r1, r15
FFF40F47  c5fea4a4                          mov.b   0A4h[r15], 0A4h[r14]
FFF40F4B  b081                   loc_FFF40F4B movu.b  4+var_2[sp], r1
FFF40F4D  6211                              add     #1, r1
FFF40F4F  8081                              mov.b   r1, 4+var_2[sp]
FFF40F51  b081                   loc_FFF40F51 movu.b  4+var_2[sp], r1
FFF40F53  6131                              cmp     #3, r1
FFF40F55  2980                              blt.b   loc_FFF40ED5
FFF40F57  386d01                            bra.w   loc_FFF410C4
FFF40F5A  3c0100                 loc_FFF40F5A mov.b   #0, 4+var_3[sp]
FFF40F5D  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40F60  2e3e                              bra.b   loc_FFF40F9E
FFF40F62  b081                   loc_FFF40F62 movu.b  4+var_2[sp], r1
FFF40F64  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40F6A  4b1e                              add     r1, r14
FFF40F6C  59eebd                            movu.b  0BDh[r14], r14
FFF40F6F  fbf2468e0000                      mov.l   #8E46h, r15
FFF40F75  4b1f                              add     r1, r15
FFF40F77  45febd                            cmp     0BDh[r15], r14
FFF40F7A  201e                              beq.b   loc_FFF40F98
FFF40F7C  b081                              movu.b  4+var_2[sp], r1
FFF40F7E  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40F84  4b1e                              add     r1, r14
FFF40F86  fbf2468e0000                      mov.l   #8E46h, r15
FFF40F8C  4b1f                              add     r1, r15
FFF40F8E  c5febdbd                          mov.b   0BDh[r15], 0BDh[r14]
FFF40F92  b009                              movu.b  4+var_3[sp], r1
FFF40F94  6211                              add     #1, r1
FFF40F96  8009                              mov.b   r1, 4+var_3[sp]
FFF40F98  b081                   loc_FFF40F98 movu.b  4+var_2[sp], r1
FFF40F9A  6211                              add     #1, r1
FFF40F9C  8081                              mov.b   r1, 4+var_2[sp]
FFF40F9E  b081                   loc_FFF40F9E movu.b  4+var_2[sp], r1
FFF40FA0  6141                              cmp     #4, r1
FFF40FA2  29c0                              blt.b   loc_FFF40F62
FFF40FA4  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40FA7  2e3e                              bra.b   loc_FFF40FE5
FFF40FA9  b081                   loc_FFF40FA9 movu.b  4+var_2[sp], r1
FFF40FAB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40FB1  4b1e                              add     r1, r14
FFF40FB3  59eec1                            movu.b  0C1h[r14], r14
FFF40FB6  fbf2468e0000                      mov.l   #8E46h, r15
FFF40FBC  4b1f                              add     r1, r15
FFF40FBE  45fec1                            cmp     0C1h[r15], r14
FFF40FC1  201e                              beq.b   loc_FFF40FDF
FFF40FC3  b081                              movu.b  4+var_2[sp], r1
FFF40FC5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40FCB  4b1e                              add     r1, r14
FFF40FCD  fbf2468e0000                      mov.l   #8E46h, r15
FFF40FD3  4b1f                              add     r1, r15
FFF40FD5  c5fec1c1                          mov.b   0C1h[r15], 0C1h[r14]
FFF40FD9  b009                              movu.b  4+var_3[sp], r1
FFF40FDB  6211                              add     #1, r1
FFF40FDD  8009                              mov.b   r1, 4+var_3[sp]
FFF40FDF  b081                   loc_FFF40FDF movu.b  4+var_2[sp], r1
FFF40FE1  6211                              add     #1, r1
FFF40FE3  8081                              mov.b   r1, 4+var_2[sp]
FFF40FE5  b081                   loc_FFF40FE5 movu.b  4+var_2[sp], r1
FFF40FE7  6141                              cmp     #4, r1
FFF40FE9  29c0                              blt.b   loc_FFF40FA9
FFF40FEB  3c0200                            mov.b   #0, 4+var_2[sp]
FFF40FEE  2e3e                              bra.b   loc_FFF4102C
FFF40FF0  b081                   loc_FFF40FF0 movu.b  4+var_2[sp], r1
FFF40FF2  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40FF8  4b1e                              add     r1, r14
FFF40FFA  59eec5                            movu.b  0C5h[r14], r14
FFF40FFD  fbf2468e0000                      mov.l   #8E46h, r15
FFF41003  4b1f                              add     r1, r15
FFF41005  45fec5                            cmp     0C5h[r15], r14
FFF41008  201e                              beq.b   loc_FFF41026
FFF4100A  b081                              movu.b  4+var_2[sp], r1
FFF4100C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41012  4b1e                              add     r1, r14
FFF41014  fbf2468e0000                      mov.l   #8E46h, r15
FFF4101A  4b1f                              add     r1, r15
FFF4101C  c5fec5c5                          mov.b   0C5h[r15], 0C5h[r14]
FFF41020  b009                              movu.b  4+var_3[sp], r1
FFF41022  6211                              add     #1, r1
FFF41024  8009                              mov.b   r1, 4+var_3[sp]
FFF41026  b081                   loc_FFF41026 movu.b  4+var_2[sp], r1
FFF41028  6211                              add     #1, r1
FFF4102A  8081                              mov.b   r1, 4+var_2[sp]
FFF4102C  b081                   loc_FFF4102C movu.b  4+var_2[sp], r1
FFF4102E  6141                              cmp     #4, r1
FFF41030  29c0                              blt.b   loc_FFF40FF0
FFF41032  b009                              movu.b  4+var_3[sp], r1
FFF41034  6101                              cmp     #0, r1
FFF41036  17                                beq.s   loc_FFF4103D
FFF41037  6611                              mov.l   #1, r1
FFF41039  05b5eefa                          bsr.a   sub_FFEEFEEE
FFF4103D  3c0200                 loc_FFF4103D mov.b   #0, 4+var_2[sp]
FFF41040  2e7e                              bra.b   loc_FFF410BE
FFF41042  b081                   loc_FFF41042 movu.b  4+var_2[sp], r1
FFF41044  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4104A  4b1e                              add     r1, r14
FFF4104C  59eec9                            movu.b  0C9h[r14], r14
FFF4104F  fbf2468e0000                      mov.l   #8E46h, r15
FFF41055  4b1f                              add     r1, r15
FFF41057  45fec9                            cmp     0C9h[r15], r14
FFF4105A  2023                              beq.b   loc_FFF4107D
FFF4105C  b082                              movu.b  4+var_2[sp], r2
FFF4105E  6621                              mov.l   #2, r1
FFF41060  fd6221                            shll    r2, r1
FFF41063  058beefa                          bsr.a   sub_FFEEFEEE
FFF41067  b081                              movu.b  4+var_2[sp], r1
FFF41069  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4106F  4b1e                              add     r1, r14
FFF41071  fbf2468e0000                      mov.l   #8E46h, r15
FFF41077  4b1f                              add     r1, r15
FFF41079  c5fec9c9                          mov.b   0C9h[r15], 0C9h[r14]
FFF4107D  b081                   loc_FFF4107D movu.b  4+var_2[sp], r1
FFF4107F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41085  4b1e                              add     r1, r14
FFF41087  59eecc                            movu.b  0CCh[r14], r14
FFF4108A  fbf2468e0000                      mov.l   #8E46h, r15
FFF41090  4b1f                              add     r1, r15
FFF41092  45fecc                            cmp     0CCh[r15], r14
FFF41095  2023                              beq.b   loc_FFF410B8
FFF41097  b082                              movu.b  4+var_2[sp], r2
FFF41099  6621                              mov.l   #2, r1
FFF4109B  fd6221                            shll    r2, r1
FFF4109E  0550eefa                          bsr.a   sub_FFEEFEEE
FFF410A2  b081                              movu.b  4+var_2[sp], r1
FFF410A4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF410AA  4b1e                              add     r1, r14
FFF410AC  fbf2468e0000                      mov.l   #8E46h, r15
FFF410B2  4b1f                              add     r1, r15
FFF410B4  c5fecccc                          mov.b   0CCh[r15], 0CCh[r14]
FFF410B8  b081                   loc_FFF410B8 movu.b  4+var_2[sp], r1
FFF410BA  6211                              add     #1, r1
FFF410BC  8081                              mov.b   r1, 4+var_2[sp]
FFF410BE  b081                   loc_FFF410BE movu.b  4+var_2[sp], r1
FFF410C0  6131                              cmp     #3, r1
FFF410C2  2980                              blt.b   loc_FFF41042
FFF410C4  fb124d8c0000           loc_FFF410C4 mov.l   #8C4Dh, r1
FFF410CA  b219                              movu.b  9[r1], r1
FFF410CC  fbe2468e0000                      mov.l   #8E46h, r14
FFF410D2  45e109                            cmp     9[r14], r1
FFF410D5  2012                              beq.b   loc_FFF410E7
FFF410D7  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF410DD  fbf2468e0000                      mov.l   #8E46h, r15
FFF410E3  c5fe0909                          mov.b   9[r15], 9[r14]
FFF410E7  05adf1fa               loc_FFF410E7 bsr.a   sub_FFEF0294
FFF410EB  6701                              rtsd    #1
FFF410ED  fbe2798d0000           sub_FFF410ED mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF410ED
FFF410F3  f8e400                            mov.b   #0, [r14]
FFF410F6  6601                              mov.l   #0, r1
FFF410F8  ef12                              mov.l   r1, r2
FFF410FA  050ef3fa                          bsr.a   sub_FFEF0408
FFF410FE  05a128fb                          bsr.a   sub_FFEF399F
FFF41102  6631                              mov.l   #3, r1
FFF41104  0557b2fa                          bsr.a   sub_FFEEC35B
FFF41108  392500                            bsr.w   sub_FFF4112D
FFF4110B  7541ff                            mov.l   #-1, r1
FFF4110E  054db2fa                          bsr.a   sub_FFEEC35B
FFF41112  754256                            mov.l   #56h, r2 ; 'V'
FFF41115  6601                              mov.l   #0, r1
FFF41117  393e00                            bsr.w   sub_FFF41155
FFF4111A  6601                              mov.l   #0, r1
FFF4111C  05e913fb                          bsr.a   sub_FFEF2505
FFF41120  6611                              mov.l   #1, r1
FFF41122  05e313fb                          bsr.a   sub_FFEF2505
FFF41126  6621                              mov.l   #2, r1
FFF41128  05dd13fb                          bsr.a   sub_FFEF2505
FFF4112C  02                                rts
FFF4112D  05a13efb               sub_FFF4112D bsr.a   sub_FFEF4FCE   ; <<<< FUNC sub_FFF4112D
FFF41131  05d140fb                          bsr.a   sub_FFEF5202
FFF41135  05614ffb                          bsr.a   sub_FFEF6096
FFF41139  05ff4cfb                          bsr.a   sub_FFEF5E38
FFF4113D  05b03bfb                          bsr.a   sub_FFEF4CED
FFF41141  6111                              cmp     #1, r1
FFF41143  11                                beq.s   loc_FFF4114C
FFF41144  05d443fb                          bsr.a   sub_FFEF5518
FFF41148  059c48fb                          bsr.a   sub_FFEF59E4
FFF4114C  05d74efb               loc_FFF4114C bsr.a   sub_FFEF6023
FFF41150  052d52fb                          bsr.a   sub_FFEF637D
FFF41154  02                                rts
FFF41155  7ea6                   sub_FFF41155 push.l  r6   ; <<<< FUNC sub_FFF41155
FFF41157  7100dc                            add     #-24h, sp, sp
FFF4115A  9409                              mov.w   r1, 24h+var_2[sp]
FFF4115C  9402                              mov.w   r2, 24h+var_4[sp]
FFF4115E  3c8f00                            mov.b   #0, 24h+var_5[sp]
FFF41161  3c8e00                            mov.b   #0, 24h+var_6[sp]
FFF41164  3c8700                            mov.b   #0, 24h+var_D[sp]
FFF41167  3c8600                            mov.b   #0, 24h+var_E[sp]
FFF4116A  3c8500                            mov.b   #0, 24h+var_F[sp]
FFF4116D  3c8400                            mov.b   #0, 24h+var_10[sp]
FFF41170  3d0900                            mov.w   #0, 24h+var_12[sp]
FFF41173  3d0800                            mov.w   #0, 24h+var_14[sp]
FFF41176  3d0700                            mov.w   #0, 24h+var_16[sp]
FFF41179  3d0600                            mov.w   #0, 24h+var_18[sp]
FFF4117C  3e0200                            mov.l   #0, 24h+var_1C[sp]
FFF4117F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41185  c5e06c16                          mov.b   6Ch[r14], 24h+var_E[sp]
FFF41189  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4118F  c5e06d15                          mov.b   6Dh[r14], 24h+var_F[sp]
FFF41193  bc02                              movu.w  24h+var_4[sp], r2
FFF41195  bc09                              movu.w  24h+var_2[sp], r1
FFF41197  754460                            mov.l   #60h, r4 ; '`'
FFF4119A  fb3a4001                          mov.l   #140h, r3
FFF4119E  0559f3fa                          bsr.a   sub_FFEF04F7
FFF411A2  f909090b01                        mov.w   #10Bh, 24h+var_12[sp]
FFF411A7  3d0856                            mov.w   #56h, 24h+var_14[sp] ; 'V'
FFF411AA  b581                              movu.b  24h+var_E[sp], r1
FFF411AC  6141                              cmp     #4, r1
FFF411AE  2905                              blt.b   loc_FFF411B3
FFF411B0  3c8603                            mov.b   #3, 24h+var_E[sp]
FFF411B3  b581                   loc_FFF411B3 movu.b  24h+var_E[sp], r1
FFF411B5  6121                              cmp     #2, r1
FFF411B7  3a8d00                            beq.w   loc_FFF41244
FFF411BA  6111                              cmp     #1, r1
FFF411BC  2048                              beq.b   loc_FFF41204
FFF411BE  6101                              cmp     #0, r1
FFF411C0  3bc200                            bne.w   loc_FFF41282
FFF411C3  3d0713                            mov.w   #13h, 24h+var_16[sp]
FFF411C6  3d0610                            mov.w   #10h, 24h+var_18[sp]
FFF411C9  3d8108                            mov.w   #8, 24h+var_2[sp]
FFF411CC  3c8409                            mov.b   #9, 24h+var_10[sp]
FFF411CF  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF411D5  71116e                            add     #6Eh, r1, r1 ; 'n'
FFF411D8  a181                              mov.l   r1, 24h+var_C[sp]
FFF411DA  ba02                              movu.w  24h+var_14[sp], r2
FFF411DC  ba09                              movu.w  24h+var_12[sp], r1
FFF411DE  fb321ce8ecff                      mov.l   #unk_FFECE81C, r3
FFF411E4  0564f4fa                          bsr.a   sub_FFEF0648
FFF411E8  ba09                              movu.w  24h+var_12[sp], r1
FFF411EA  62d1                              add     #0Dh, r1
FFF411EC  9209                              mov.w   r1, 24h+var_12[sp]
FFF411EE  ba02                              movu.w  24h+var_14[sp], r2
FFF411F0  ba09                              movu.w  24h+var_12[sp], r1
FFF411F2  fb321cebecff                      mov.l   #unk_FFECEB1C, r3
FFF411F8  0550f4fa                          bsr.a   sub_FFEF0648
FFF411FC  b581                              movu.b  24h+var_E[sp], r1
FFF411FE  39bd05                            bsr.w   sub_FFF417BB
FFF41201  388100                            bra.w   loc_FFF41282
FFF41204  3d0727                 loc_FFF41204 mov.w   #27h, 24h+var_16[sp] ; '''
FFF41207  3d0608                            mov.w   #8, 24h+var_18[sp]
FFF4120A  3d8102                            mov.w   #2, 24h+var_2[sp]
FFF4120D  3c8413                            mov.b   #13h, 24h+var_10[sp]
FFF41210  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF41216  71116e                            add     #6Eh, r1, r1 ; 'n'
FFF41219  a181                              mov.l   r1, 24h+var_C[sp]
FFF4121B  ba02                              movu.w  24h+var_14[sp], r2
FFF4121D  ba09                              movu.w  24h+var_12[sp], r1
FFF4121F  fb32dce8ecff                      mov.l   #unk_FFECE8DC, r3
FFF41225  0523f4fa                          bsr.a   sub_FFEF0648
FFF41229  ba09                              movu.w  24h+var_12[sp], r1
FFF4122B  62d1                              add     #0Dh, r1
FFF4122D  9209                              mov.w   r1, 24h+var_12[sp]
FFF4122F  ba02                              movu.w  24h+var_14[sp], r2
FFF41231  ba09                              movu.w  24h+var_12[sp], r1
FFF41233  fb321cebecff                      mov.l   #unk_FFECEB1C, r3
FFF41239  050ff4fa                          bsr.a   sub_FFEF0648
FFF4123D  b581                              movu.b  24h+var_E[sp], r1
FFF4123F  397c05                            bsr.w   sub_FFF417BB
FFF41242  2e40                              bra.b   loc_FFF41282
FFF41244  3d074f                 loc_FFF41244 mov.w   #4Fh, 24h+var_16[sp] ; 'O'
FFF41247  3d0604                            mov.w   #4, 24h+var_18[sp]
FFF4124A  3d8104                            mov.w   #4, 24h+var_2[sp]
FFF4124D  3c8427                            mov.b   #27h, 24h+var_10[sp] ; '''
FFF41250  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF41256  71116e                            add     #6Eh, r1, r1 ; 'n'
FFF41259  a181                              mov.l   r1, 24h+var_C[sp]
FFF4125B  ba02                              movu.w  24h+var_14[sp], r2
FFF4125D  ba09                              movu.w  24h+var_12[sp], r1
FFF4125F  fb325ceaecff                      mov.l   #unk_FFECEA5C, r3
FFF41265  05e3f3fa                          bsr.a   sub_FFEF0648
FFF41269  ba09                              movu.w  24h+var_12[sp], r1
FFF4126B  62d1                              add     #0Dh, r1
FFF4126D  9209                              mov.w   r1, 24h+var_12[sp]
FFF4126F  ba02                              movu.w  24h+var_14[sp], r2
FFF41271  ba09                              movu.w  24h+var_12[sp], r1
FFF41273  fb321cebecff                      mov.l   #unk_FFECEB1C, r3
FFF41279  05cff3fa                          bsr.a   sub_FFEF0648
FFF4127D  b581                              movu.b  24h+var_E[sp], r1
FFF4127F  393c05                            bsr.w   sub_FFF417BB
FFF41282  ba09                   loc_FFF41282 movu.w  24h+var_12[sp], r1
FFF41284  62d1                              add     #0Dh, r1
FFF41286  9209                              mov.w   r1, 24h+var_12[sp]
FFF41288  ba02                              movu.w  24h+var_14[sp], r2
FFF4128A  ba09                              movu.w  24h+var_12[sp], r1
FFF4128C  fb327cf4ecff                      mov.l   #unk_FFECF47C, r3
FFF41292  05b6f3fa                          bsr.a   sub_FFEF0648
FFF41296  ba09                              movu.w  24h+var_12[sp], r1
FFF41298  62d1                              add     #0Dh, r1
FFF4129A  9209                              mov.w   r1, 24h+var_12[sp]
FFF4129C  ba02                              movu.w  24h+var_14[sp], r2
FFF4129E  ba09                              movu.w  24h+var_12[sp], r1
FFF412A0  fb321cf5ecff                      mov.l   #unk_FFECF51C, r3
FFF412A6  05a2f3fa                          bsr.a   sub_FFEF0648
FFF412AA  b509                              movu.b  24h+var_F[sp], r1
FFF412AC  6101                              cmp     #0, r1
FFF412AE  10                                beq.s   loc_FFF412B6
FFF412AF  b509                              movu.b  24h+var_F[sp], r1
FFF412B1  755150                            cmp     #50h, r1 ; 'P'
FFF412B4  2906                              blt.b   loc_FFF412BA
FFF412B6  f80601                 loc_FFF412B6 mov.l   #1, 24h+var_24[sp]
FFF412B9  0c                                bra.s   loc_FFF412BD
FFF412BA  f80600                 loc_FFF412BA mov.l   #0, 24h+var_24[sp]
FFF412BD  ec01                   loc_FFF412BD mov.l   24h+var_24[sp], r1
FFF412BF  6101                              cmp     #0, r1
FFF412C1  10                                beq.s   loc_FFF412C9
FFF412C2  b989                              movu.w  24h+var_16[sp], r1
FFF412C4  6211                              add     #1, r1
FFF412C6  8501                              mov.b   r1, 24h+var_10[sp]
FFF412C8  0d                                bra.s   loc_FFF412CD
FFF412C9  c5001514               loc_FFF412C9 mov.b   24h+var_F[sp], 24h+var_10[sp]
FFF412CD  39f301                 loc_FFF412CD bsr.w   sub_FFF414C0
FFF412D0  b981                              movu.w  24h+var_18[sp], r1
FFF412D2  06cd0107                          mul     24h+var_16[sp].uw, r1
FFF412D6  056f4700                          bsr.a   sub_FFF45A45
FFF412DA  6606                              mov.l   #0, r6
FFF412DC  fb420000e0bf                      mov.l   #-40200000h, r4
FFF412E2  ef63                              mov.l   r6, r3
FFF412E4  054a4900                          bsr.a   sub_FFF45C2E
FFF412E8  fb4200006440                      mov.l   #40640000h, r4
FFF412EE  ef63                              mov.l   r6, r3
FFF412F0  05754500                          bsr.a   sub_FFF45865
FFF412F4  05d24700                          bsr.a   sub_FFF45AC6
FFF412F8  9409                              mov.w   r1, 24h+var_2[sp]
FFF412FA  3c8f00                            mov.b   #0, 24h+var_5[sp]
FFF412FD  38b501                            bra.w   loc_FFF414B2
FFF41300  b789                   loc_FFF41300 movu.b  24h+var_5[sp], r1
FFF41302  a982                              mov.l   24h+var_C[sp], r2
FFF41304  fec211                            movu.b  [r2, r1], r1
FFF41307  8589                              mov.b   r1, 24h+var_D[sp]
FFF41309  3c0701                            mov.b   #1, 24h+var_1D[sp]
FFF4130C  b589                              movu.b  24h+var_D[sp], r1
FFF4130E  6011                              sub     #1, r1
FFF41310  6191                              cmp     #9, r1
FFF41312  2505                              bleu.b  loc_FFF41317
FFF41314  386301                            bra.w   loc_FFF41477
FFF41317  fbe2b483f4ff           loc_FFF41317 mov.l   #unk_FFF483B4, r14
FFF4131D  fe51ee                            mov.w   [r1, r14], r14
FFF41320  7f4e                              bra.l   r14
FFF41322  3d8099                            mov.w   #-67h, 24h+var_4[sp]
FFF41325  b501                              movu.b  24h+var_10[sp], r1
FFF41327  6011                              sub     #1, r1
FFF41329  b78a                              movu.b  24h+var_5[sp], r2
FFF4132B  4712                              cmp     r1, r2
FFF4132D  210d                              bne.b   loc_FFF4133A
FFF4132F  fb12dc34edff                      mov.l   #unk_FFED34DC, r1
FFF41335  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41337  384301                            bra.w   loc_FFF4147A
FFF4133A  fb123c34edff           loc_FFF4133A mov.l   #unk_FFED343C, r1
FFF41340  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41342  383801                            bra.w   loc_FFF4147A
FFF41345  3d8094                            mov.w   #-6Ch, 24h+var_4[sp]
FFF41348  b501                              movu.b  24h+var_10[sp], r1
FFF4134A  6011                              sub     #1, r1
FFF4134C  b78a                              movu.b  24h+var_5[sp], r2
FFF4134E  4712                              cmp     r1, r2
FFF41350  210d                              bne.b   loc_FFF4135D
FFF41352  fb12ec34edff                      mov.l   #unk_FFED34EC, r1
FFF41358  a081                              mov.l   r1, 24h+var_1C[sp]
FFF4135A  382001                            bra.w   loc_FFF4147A
FFF4135D  fb124c34edff           loc_FFF4135D mov.l   #unk_FFED344C, r1
FFF41363  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41365  381501                            bra.w   loc_FFF4147A
FFF41368  3d808f                            mov.w   #-71h, 24h+var_4[sp]
FFF4136B  b501                              movu.b  24h+var_10[sp], r1
FFF4136D  6011                              sub     #1, r1
FFF4136F  b78a                              movu.b  24h+var_5[sp], r2
FFF41371  4712                              cmp     r1, r2
FFF41373  210d                              bne.b   loc_FFF41380
FFF41375  fb12fc34edff                      mov.l   #unk_FFED34FC, r1
FFF4137B  a081                              mov.l   r1, 24h+var_1C[sp]
FFF4137D  38fd00                            bra.w   loc_FFF4147A
FFF41380  fb125c34edff           loc_FFF41380 mov.l   #unk_FFED345C, r1
FFF41386  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41388  38f200                            bra.w   loc_FFF4147A
FFF4138B  3d808a                            mov.w   #-76h, 24h+var_4[sp]
FFF4138E  b501                              movu.b  24h+var_10[sp], r1
FFF41390  6011                              sub     #1, r1
FFF41392  b78a                              movu.b  24h+var_5[sp], r2
FFF41394  4712                              cmp     r1, r2
FFF41396  210d                              bne.b   loc_FFF413A3
FFF41398  fb120c35edff                      mov.l   #unk_FFED350C, r1
FFF4139E  a081                              mov.l   r1, 24h+var_1C[sp]
FFF413A0  38da00                            bra.w   loc_FFF4147A
FFF413A3  fb126c34edff           loc_FFF413A3 mov.l   #unk_FFED346C, r1
FFF413A9  a081                              mov.l   r1, 24h+var_1C[sp]
FFF413AB  38cf00                            bra.w   loc_FFF4147A
FFF413AE  3d8084                            mov.w   #-7Ch, 24h+var_4[sp]
FFF413B1  b501                              movu.b  24h+var_10[sp], r1
FFF413B3  6011                              sub     #1, r1
FFF413B5  b78a                              movu.b  24h+var_5[sp], r2
FFF413B7  4712                              cmp     r1, r2
FFF413B9  210d                              bne.b   loc_FFF413C6
FFF413BB  fb121c35edff                      mov.l   #unk_FFED351C, r1
FFF413C1  a081                              mov.l   r1, 24h+var_1C[sp]
FFF413C3  38b700                            bra.w   loc_FFF4147A
FFF413C6  fb127c34edff           loc_FFF413C6 mov.l   #unk_FFED347C, r1
FFF413CC  a081                              mov.l   r1, 24h+var_1C[sp]
FFF413CE  38ac00                            bra.w   loc_FFF4147A
FFF413D1  3d807f                            mov.w   #7Fh, 24h+var_4[sp]
FFF413D4  b501                              movu.b  24h+var_10[sp], r1
FFF413D6  6011                              sub     #1, r1
FFF413D8  b78a                              movu.b  24h+var_5[sp], r2
FFF413DA  4712                              cmp     r1, r2
FFF413DC  210d                              bne.b   loc_FFF413E9
FFF413DE  fb122c35edff                      mov.l   #unk_FFED352C, r1
FFF413E4  a081                              mov.l   r1, 24h+var_1C[sp]
FFF413E6  389400                            bra.w   loc_FFF4147A
FFF413E9  fb128c34edff           loc_FFF413E9 mov.l   #unk_FFED348C, r1
FFF413EF  a081                              mov.l   r1, 24h+var_1C[sp]
FFF413F1  388900                            bra.w   loc_FFF4147A
FFF413F4  3d807a                            mov.w   #7Ah, 24h+var_4[sp] ; 'z'
FFF413F7  b501                              movu.b  24h+var_10[sp], r1
FFF413F9  6011                              sub     #1, r1
FFF413FB  b78a                              movu.b  24h+var_5[sp], r2
FFF413FD  4712                              cmp     r1, r2
FFF413FF  210c                              bne.b   loc_FFF4140B
FFF41401  fb123c35edff                      mov.l   #unk_FFED353C, r1
FFF41407  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41409  2e71                              bra.b   loc_FFF4147A
FFF4140B  fb129c34edff           loc_FFF4140B mov.l   #unk_FFED349C, r1
FFF41411  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41413  2e67                              bra.b   loc_FFF4147A
FFF41415  3d8075                            mov.w   #75h, 24h+var_4[sp] ; 'u'
FFF41418  b501                              movu.b  24h+var_10[sp], r1
FFF4141A  6011                              sub     #1, r1
FFF4141C  b78a                              movu.b  24h+var_5[sp], r2
FFF4141E  4712                              cmp     r1, r2
FFF41420  210c                              bne.b   loc_FFF4142C
FFF41422  fb124c35edff                      mov.l   #unk_FFED354C, r1
FFF41428  a081                              mov.l   r1, 24h+var_1C[sp]
FFF4142A  2e50                              bra.b   loc_FFF4147A
FFF4142C  fb12ac34edff           loc_FFF4142C mov.l   #unk_FFED34AC, r1
FFF41432  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41434  2e46                              bra.b   loc_FFF4147A
FFF41436  3d8070                            mov.w   #70h, 24h+var_4[sp] ; 'p'
FFF41439  b501                              movu.b  24h+var_10[sp], r1
FFF4143B  6011                              sub     #1, r1
FFF4143D  b78a                              movu.b  24h+var_5[sp], r2
FFF4143F  4712                              cmp     r1, r2
FFF41441  210c                              bne.b   loc_FFF4144D
FFF41443  fb125c35edff                      mov.l   #unk_FFED355C, r1
FFF41449  a081                              mov.l   r1, 24h+var_1C[sp]
FFF4144B  2e2f                              bra.b   loc_FFF4147A
FFF4144D  fb12bc34edff           loc_FFF4144D mov.l   #unk_FFED34BC, r1
FFF41453  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41455  2e25                              bra.b   loc_FFF4147A
FFF41457  3d806b                            mov.w   #6Bh, 24h+var_4[sp] ; 'k'
FFF4145A  b501                              movu.b  24h+var_10[sp], r1
FFF4145C  6011                              sub     #1, r1
FFF4145E  b78a                              movu.b  24h+var_5[sp], r2
FFF41460  4712                              cmp     r1, r2
FFF41462  210c                              bne.b   loc_FFF4146E
FFF41464  fb126c35edff                      mov.l   #unk_FFED356C, r1
FFF4146A  a081                              mov.l   r1, 24h+var_1C[sp]
FFF4146C  2e0e                              bra.b   loc_FFF4147A
FFF4146E  fb12cc34edff           loc_FFF4146E mov.l   #unk_FFED34CC, r1
FFF41474  a081                              mov.l   r1, 24h+var_1C[sp]
FFF41476  0c                                bra.s   loc_FFF4147A
FFF41477  3c0700                 loc_FFF41477 mov.b   #0, 24h+var_1D[sp]
FFF4147A  b189                   loc_FFF4147A movu.b  24h+var_1D[sp], r1
FFF4147C  6111                              cmp     #1, r1
FFF4147E  2126                              bne.b   loc_FFF414A4
FFF41480  3c8e00                            mov.b   #0, 24h+var_6[sp]
FFF41483  2e19                              bra.b   loc_FFF4149C
FFF41485  bc09                   loc_FFF41485 movu.w  24h+var_2[sp], r1
FFF41487  49011e                            add     24h+var_6[sp], r1
FFF4148A  a884                              mov.l   24h+var_1C[sp], r4
FFF4148C  b18b                              movu.b  24h+var_1D[sp], r3
FFF4148E  bc02                              movu.w  24h+var_4[sp], r2
FFF41490  5f11                              movu.w  r1, r1
FFF41492  054354fb                          bsr.a   sub_FFEF68D5
FFF41496  b781                              movu.b  24h+var_6[sp], r1
FFF41498  6211                              add     #1, r1
FFF4149A  8781                              mov.b   r1, 24h+var_6[sp]
FFF4149C  b781                   loc_FFF4149C movu.b  24h+var_6[sp], r1
FFF4149E  06c50106                          cmp     24h+var_18[sp].uw, r1
FFF414A2  29e3                              blt.b   loc_FFF41485
FFF414A4  bc09                   loc_FFF414A4 movu.w  24h+var_2[sp], r1
FFF414A6  06c90106                          add     24h+var_18[sp].uw, r1
FFF414AA  9409                              mov.w   r1, 24h+var_2[sp]
FFF414AC  b789                              movu.b  24h+var_5[sp], r1
FFF414AE  6211                              add     #1, r1
FFF414B0  8789                              mov.b   r1, 24h+var_5[sp]
FFF414B2  b789                   loc_FFF414B2 movu.b  24h+var_5[sp], r1
FFF414B4  06c50107                          cmp     24h+var_16[sp].uw, r1
FFF414B8  2805                   sub_FFF414B8 bge.b   loc_FFF414BD   ; <<<< FUNC sub_FFF414B8
FFF414BA  3846fe                            bra.w   loc_FFF41300
FFF414BD  3f660a                 loc_FFF414BD rtsd    #28h, r6-r6
FFF414C0  7100d0                 sub_FFF414C0 add     #-30h, sp, sp   ; <<<< FUNC sub_FFF414C0
FFF414C3  3d0700                            mov.w   #0, 30h+var_22[sp]
FFF414C6  3d0600                            mov.w   #0, 30h+var_24[sp]
FFF414C9  3d0500                            mov.w   #0, 30h+var_26[sp]
FFF414CC  3d0400                            mov.w   #0, 30h+var_28[sp]
FFF414CF  3d0300                            mov.w   #0, 30h+var_2A[sp]
FFF414D2  754310                            mov.l   #10h, r3
FFF414D5  6602                              mov.l   #0, r2
FFF414D7  710120                            add     #30h+var_10, sp, r1
FFF414DA  052c4900                          bsr.a   sub_FFF45E06
FFF414DE  754310                            mov.l   #10h, r3
FFF414E1  6602                              mov.l   #0, r2
FFF414E3  710110                            add     #30h+var_20, sp, r1
FFF414E6  05204900                          bsr.a   sub_FFF45E06
FFF414EA  3d0700                            mov.w   #0, 30h+var_22[sp]
FFF414ED  2e42                              bra.b   loc_FFF4152F
FFF414EF  b989                   loc_FFF414EF movu.w  30h+var_22[sp], r1
FFF414F1  fbe266210100                      mov.l   #12166h, r14
FFF414F7  fece1e                            movu.b  [r14, r1], r14
FFF414FA  755e30                            cmp     #30h, r14 ; '0'
FFF414FD  1a                                bne.s   loc_FFF41507
FFF414FE  b909                              movu.w  30h+var_26[sp], r1
FFF41500  6101                              cmp     #0, r1
FFF41502  1d                                bne.s   loc_FFF41507
FFF41503  f80601                            mov.l   #1, 30h+var_30[sp]
FFF41506  0c                                bra.s   loc_FFF4150A
FFF41507  f80600                 loc_FFF41507 mov.l   #0, 30h+var_30[sp]
FFF4150A  ec01                   loc_FFF4150A mov.l   30h+var_30[sp], r1
FFF4150C  6101                              cmp     #0, r1
FFF4150E  211b                              bne.b   loc_FFF41529
FFF41510  b989                              movu.w  30h+var_22[sp], r1
FFF41512  fbe266210100                      mov.l   #12166h, r14
FFF41518  fece1e                            movu.b  [r14, r1], r14
FFF4151B  710f20                            add     #30h+var_10, sp, r15
FFF4151E  b909                              movu.w  30h+var_26[sp], r1
FFF41520  fe0f1e                            mov.b   r14, [r15, r1]
FFF41523  9909                              mov.w   30h+var_26[sp], r1
FFF41525  6211                              add     #1, r1
FFF41527  9109                              mov.w   r1, 30h+var_26[sp]
FFF41529  9989                   loc_FFF41529 mov.w   30h+var_22[sp], r1
FFF4152B  6211                              add     #1, r1
FFF4152D  9189                              mov.w   r1, 30h+var_22[sp]
FFF4152F  b989                   loc_FFF4152F movu.w  30h+var_22[sp], r1
FFF41531  6131                              cmp     #3, r1
FFF41533  29bc                              blt.b   loc_FFF414EF
FFF41535  3d0700                            mov.w   #0, 30h+var_22[sp]
FFF41538  2e22                              bra.b   loc_FFF4155A
FFF4153A  fb1266210100           loc_FFF4153A mov.l   #12166h, r1
FFF41540  06c90107                          add     30h+var_22[sp].uw, r1
FFF41544  b099                              movu.b  3[r1], r1
FFF41546  710e10                            add     #30h+var_20, sp, r14
FFF41549  b982                              movu.w  30h+var_24[sp], r2
FFF4154B  fe0e21                            mov.b   r1, [r14, r2]
FFF4154E  9981                              mov.w   30h+var_24[sp], r1
FFF41550  6211                              add     #1, r1
FFF41552  9181                              mov.w   r1, 30h+var_24[sp]
FFF41554  9989                              mov.w   30h+var_22[sp], r1
FFF41556  6211                              add     #1, r1
FFF41558  9189                              mov.w   r1, 30h+var_22[sp]
FFF4155A  b989                   loc_FFF4155A movu.w  30h+var_22[sp], r1
FFF4155C  6131                              cmp     #3, r1
FFF4155E  29dc                              blt.b   loc_FFF4153A
FFF41560  b909                              movu.w  30h+var_26[sp], r1
FFF41562  6101                              cmp     #0, r1
FFF41564  2040                              beq.b   loc_FFF415A4
FFF41566  b909                              movu.w  30h+var_26[sp], r1
FFF41568  63d1                              mul     #0Dh, r1
FFF4156A  75429d                            mov.l   #-63h, r2
FFF4156D  4312                              sub     r1, r2
FFF4156F  9102                              mov.w   r2, 30h+var_28[sp]
FFF41571  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF41574  990b                              mov.w   30h+var_26[sp], r3
FFF41576  b88a                              movu.w  30h+var_2A[sp], r2
FFF41578  b901                              movu.w  30h+var_28[sp], r1
FFF4157A  6040                              sub     #4, sp
FFF4157C  d303                              mov.w   r3, 34h+var_34[sp]
FFF4157E  f90901ffff                        mov.w   #-1, 34h+var_32[sp]
FFF41583  710424                            add     #34h+var_10, sp, r4
FFF41586  6613                              mov.l   #1, r3
FFF41588  05b695fb                          bsr.a   sub_FFEFAB3E
FFF4158C  6240                              add     #4, sp
FFF4158E  3d049d                            mov.w   #-63h, 30h+var_28[sp]
FFF41591  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF41594  b88a                              movu.w  30h+var_2A[sp], r2
FFF41596  b901                              movu.w  30h+var_28[sp], r1
FFF41598  fb427cebecff                      mov.l   #unk_FFECEB7C, r4
FFF4159E  6613                              mov.l   #1, r3
FFF415A0  053553fb                          bsr.a   sub_FFEF68D5
FFF415A4  3d04a4                 loc_FFF415A4 mov.w   #-5Ch, 30h+var_28[sp]
FFF415A7  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF415AA  9983                              mov.w   30h+var_24[sp], r3
FFF415AC  b88a                              movu.w  30h+var_2A[sp], r2
FFF415AE  b901                              movu.w  30h+var_28[sp], r1
FFF415B0  6040                              sub     #4, sp
FFF415B2  d303                              mov.w   r3, 34h+var_34[sp]
FFF415B4  f90901ffff                        mov.w   #-1, 34h+var_32[sp]
FFF415B9  710414                            add     #34h+var_20, sp, r4
FFF415BC  6613                              mov.l   #1, r3
FFF415BE  058095fb                          bsr.a   sub_FFEFAB3E
FFF415C2  6240                              add     #4, sp
FFF415C4  3d0500                            mov.w   #0, 30h+var_26[sp]
FFF415C7  3d0600                            mov.w   #0, 30h+var_24[sp]
FFF415CA  754310                            mov.l   #10h, r3
FFF415CD  6602                              mov.l   #0, r2
FFF415CF  710120                            add     #30h+var_10, sp, r1
FFF415D2  05344800                          bsr.a   sub_FFF45E06
FFF415D6  754310                            mov.l   #10h, r3
FFF415D9  6602                              mov.l   #0, r2
FFF415DB  710110                            add     #30h+var_20, sp, r1
FFF415DE  05284800                          bsr.a   sub_FFF45E06
FFF415E2  3d0700                            mov.w   #0, 30h+var_22[sp]
FFF415E5  2e42                              bra.b   loc_FFF41627
FFF415E7  b989                   loc_FFF415E7 movu.w  30h+var_22[sp], r1
FFF415E9  fbe26e210100                      mov.l   #1216Eh, r14
FFF415EF  fece1e                            movu.b  [r14, r1], r14
FFF415F2  755e30                            cmp     #30h, r14 ; '0'
FFF415F5  1a                                bne.s   loc_FFF415FF
FFF415F6  b909                              movu.w  30h+var_26[sp], r1
FFF415F8  6101                              cmp     #0, r1
FFF415FA  1d                                bne.s   loc_FFF415FF
FFF415FB  f80601                            mov.l   #1, 30h+var_30[sp]
FFF415FE  0c                                bra.s   loc_FFF41602
FFF415FF  f80600                 loc_FFF415FF mov.l   #0, 30h+var_30[sp]
FFF41602  ec01                   loc_FFF41602 mov.l   30h+var_30[sp], r1
FFF41604  6101                              cmp     #0, r1
FFF41606  211b                              bne.b   loc_FFF41621
FFF41608  b989                              movu.w  30h+var_22[sp], r1
FFF4160A  fbe26e210100                      mov.l   #1216Eh, r14
FFF41610  fece1e                            movu.b  [r14, r1], r14
FFF41613  710f20                            add     #30h+var_10, sp, r15
FFF41616  b909                              movu.w  30h+var_26[sp], r1
FFF41618  fe0f1e                            mov.b   r14, [r15, r1]
FFF4161B  9909                              mov.w   30h+var_26[sp], r1
FFF4161D  6211                              add     #1, r1
FFF4161F  9109                              mov.w   r1, 30h+var_26[sp]
FFF41621  9989                   loc_FFF41621 mov.w   30h+var_22[sp], r1
FFF41623  6211                              add     #1, r1
FFF41625  9189                              mov.w   r1, 30h+var_22[sp]
FFF41627  b989                   loc_FFF41627 movu.w  30h+var_22[sp], r1
FFF41629  6131                              cmp     #3, r1
FFF4162B  29bc                              blt.b   loc_FFF415E7
FFF4162D  3d0700                            mov.w   #0, 30h+var_22[sp]
FFF41630  2e22                              bra.b   loc_FFF41652
FFF41632  fb126e210100           loc_FFF41632 mov.l   #1216Eh, r1
FFF41638  06c90107                          add     30h+var_22[sp].uw, r1
FFF4163C  b099                              movu.b  3[r1], r1
FFF4163E  710e10                            add     #30h+var_20, sp, r14
FFF41641  b982                              movu.w  30h+var_24[sp], r2
FFF41643  fe0e21                            mov.b   r1, [r14, r2]
FFF41646  9981                              mov.w   30h+var_24[sp], r1
FFF41648  6211                              add     #1, r1
FFF4164A  9181                              mov.w   r1, 30h+var_24[sp]
FFF4164C  9989                              mov.w   30h+var_22[sp], r1
FFF4164E  6211                              add     #1, r1
FFF41650  9189                              mov.w   r1, 30h+var_22[sp]
FFF41652  b989                   loc_FFF41652 movu.w  30h+var_22[sp], r1
FFF41654  6131                              cmp     #3, r1
FFF41656  29dc                              blt.b   loc_FFF41632
FFF41658  b909                              movu.w  30h+var_26[sp], r1
FFF4165A  6101                              cmp     #0, r1
FFF4165C  2040                              beq.b   loc_FFF4169C
FFF4165E  b909                              movu.w  30h+var_26[sp], r1
FFF41660  63d1                              mul     #0Dh, r1
FFF41662  754229                            mov.l   #29h, r2 ; ')'
FFF41665  4312                              sub     r1, r2
FFF41667  9102                              mov.w   r2, 30h+var_28[sp]
FFF41669  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF4166C  990b                              mov.w   30h+var_26[sp], r3
FFF4166E  b88a                              movu.w  30h+var_2A[sp], r2
FFF41670  b901                              movu.w  30h+var_28[sp], r1
FFF41672  6040                              sub     #4, sp
FFF41674  d303                              mov.w   r3, 34h+var_34[sp]
FFF41676  f90901ffff                        mov.w   #-1, 34h+var_32[sp]
FFF4167B  710424                            add     #34h+var_10, sp, r4
FFF4167E  6613                              mov.l   #1, r3
FFF41680  05be94fb                          bsr.a   sub_FFEFAB3E
FFF41684  6240                              add     #4, sp
FFF41686  3d0429                            mov.w   #29h, 30h+var_28[sp] ; ')'
FFF41689  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF4168C  b88a                              movu.w  30h+var_2A[sp], r2
FFF4168E  b901                              movu.w  30h+var_28[sp], r1
FFF41690  fb427cebecff                      mov.l   #unk_FFECEB7C, r4
FFF41696  6613                              mov.l   #1, r3
FFF41698  053d52fb                          bsr.a   sub_FFEF68D5
FFF4169C  3d0430                 loc_FFF4169C mov.w   #30h, 30h+var_28[sp] ; '0'
FFF4169F  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF416A2  9983                              mov.w   30h+var_24[sp], r3
FFF416A4  b88a                              movu.w  30h+var_2A[sp], r2
FFF416A6  b901                              movu.w  30h+var_28[sp], r1
FFF416A8  6040                              sub     #4, sp
FFF416AA  d303                              mov.w   r3, 34h+var_34[sp]
FFF416AC  f90901ffff                        mov.w   #-1, 34h+var_32[sp]
FFF416B1  710414                            add     #34h+var_20, sp, r4
FFF416B4  6613                              mov.l   #1, r3
FFF416B6  058894fb                          bsr.a   sub_FFEFAB3E
FFF416BA  6240                              add     #4, sp
FFF416BC  3d0500                            mov.w   #0, 30h+var_26[sp]
FFF416BF  3d0600                            mov.w   #0, 30h+var_24[sp]
FFF416C2  754310                            mov.l   #10h, r3
FFF416C5  6602                              mov.l   #0, r2
FFF416C7  710120                            add     #30h+var_10, sp, r1
FFF416CA  053c4700                          bsr.a   sub_FFF45E06
FFF416CE  754310                            mov.l   #10h, r3
FFF416D1  6602                              mov.l   #0, r2
FFF416D3  710110                            add     #30h+var_20, sp, r1
FFF416D6  05304700                          bsr.a   sub_FFF45E06
FFF416DA  3d0700                            mov.w   #0, 30h+var_22[sp]
FFF416DD  2e42                              bra.b   loc_FFF4171F
FFF416DF  b989                   loc_FFF416DF movu.w  30h+var_22[sp], r1
FFF416E1  fbe276210100                      mov.l   #12176h, r14
FFF416E7  fece1e                            movu.b  [r14, r1], r14
FFF416EA  755e30                            cmp     #30h, r14 ; '0'
FFF416ED  1a                                bne.s   loc_FFF416F7
FFF416EE  b909                              movu.w  30h+var_26[sp], r1
FFF416F0  6101                              cmp     #0, r1
FFF416F2  1d                                bne.s   loc_FFF416F7
FFF416F3  f80601                            mov.l   #1, 30h+var_30[sp]
FFF416F6  0c                                bra.s   loc_FFF416FA
FFF416F7  f80600                 loc_FFF416F7 mov.l   #0, 30h+var_30[sp]
FFF416FA  ec01                   loc_FFF416FA mov.l   30h+var_30[sp], r1
FFF416FC  6101                              cmp     #0, r1
FFF416FE  211b                              bne.b   loc_FFF41719
FFF41700  b989                              movu.w  30h+var_22[sp], r1
FFF41702  fbe276210100                      mov.l   #12176h, r14
FFF41708  fece1e                            movu.b  [r14, r1], r14
FFF4170B  710f20                            add     #30h+var_10, sp, r15
FFF4170E  b909                              movu.w  30h+var_26[sp], r1
FFF41710  fe0f1e                            mov.b   r14, [r15, r1]
FFF41713  9909                              mov.w   30h+var_26[sp], r1
FFF41715  6211                              add     #1, r1
FFF41717  9109                              mov.w   r1, 30h+var_26[sp]
FFF41719  9989                   loc_FFF41719 mov.w   30h+var_22[sp], r1
FFF4171B  6211                              add     #1, r1
FFF4171D  9189                              mov.w   r1, 30h+var_22[sp]
FFF4171F  b989                   loc_FFF4171F movu.w  30h+var_22[sp], r1
FFF41721  6131                              cmp     #3, r1
FFF41723  29bc                              blt.b   loc_FFF416DF
FFF41725  3d0700                            mov.w   #0, 30h+var_22[sp]
FFF41728  2e22                              bra.b   loc_FFF4174A
FFF4172A  fb1276210100           loc_FFF4172A mov.l   #12176h, r1
FFF41730  06c90107                          add     30h+var_22[sp].uw, r1
FFF41734  b099                              movu.b  3[r1], r1
FFF41736  710e10                            add     #30h+var_20, sp, r14
FFF41739  b982                              movu.w  30h+var_24[sp], r2
FFF4173B  fe0e21                            mov.b   r1, [r14, r2]
FFF4173E  9981                              mov.w   30h+var_24[sp], r1
FFF41740  6211                              add     #1, r1
FFF41742  9181                              mov.w   r1, 30h+var_24[sp]
FFF41744  9989                              mov.w   30h+var_22[sp], r1
FFF41746  6211                              add     #1, r1
FFF41748  9189                              mov.w   r1, 30h+var_22[sp]
FFF4174A  b989                   loc_FFF4174A movu.w  30h+var_22[sp], r1
FFF4174C  6131                              cmp     #3, r1
FFF4174E  29dc                              blt.b   loc_FFF4172A
FFF41750  b909                              movu.w  30h+var_26[sp], r1
FFF41752  6101                              cmp     #0, r1
FFF41754  2043                              beq.b   loc_FFF41797
FFF41756  b909                              movu.w  30h+var_26[sp], r1
FFF41758  63d1                              mul     #0Dh, r1
FFF4175A  fb2a1101                          mov.l   #111h, r2
FFF4175E  4312                              sub     r1, r2
FFF41760  9102                              mov.w   r2, 30h+var_28[sp]
FFF41762  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF41765  990b                              mov.w   30h+var_26[sp], r3
FFF41767  b88a                              movu.w  30h+var_2A[sp], r2
FFF41769  b901                              movu.w  30h+var_28[sp], r1
FFF4176B  6040                              sub     #4, sp
FFF4176D  d303                              mov.w   r3, 34h+var_34[sp]
FFF4176F  f90901ffff                        mov.w   #-1, 34h+var_32[sp]
FFF41774  710424                            add     #34h+var_10, sp, r4
FFF41777  6613                              mov.l   #1, r3
FFF41779  05c593fb                          bsr.a   sub_FFEFAB3E
FFF4177D  6240                              add     #4, sp
FFF4177F  f909041101                        mov.w   #111h, 30h+var_28[sp]
FFF41784  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF41787  b88a                              movu.w  30h+var_2A[sp], r2
FFF41789  b901                              movu.w  30h+var_28[sp], r1
FFF4178B  fb427cebecff                      mov.l   #unk_FFECEB7C, r4
FFF41791  6613                              mov.l   #1, r3
FFF41793  054251fb                          bsr.a   sub_FFEF68D5
FFF41797  f909041801             loc_FFF41797 mov.w   #118h, 30h+var_28[sp]
FFF4179C  3d03a2                            mov.w   #-5Eh, 30h+var_2A[sp]
FFF4179F  9983                              mov.w   30h+var_24[sp], r3
FFF417A1  b88a                              movu.w  30h+var_2A[sp], r2
FFF417A3  b901                              movu.w  30h+var_28[sp], r1
FFF417A5  6040                              sub     #4, sp
FFF417A7  d303                              mov.w   r3, 34h+var_34[sp]
FFF417A9  f90901ffff                        mov.w   #-1, 34h+var_32[sp]
FFF417AE  710414                            add     #34h+var_20, sp, r4
FFF417B1  6613                              mov.l   #1, r3
FFF417B3  058b93fb                          bsr.a   sub_FFEFAB3E
FFF417B7  6240                              add     #4, sp
FFF417B9  670c                              rtsd    #0Ch
FFF417BB  6040                   sub_FFF417BB sub     #4, sp   ; <<<< FUNC sub_FFF417BB
FFF417BD  8089                              mov.b   r1, 4+var_1[sp]
FFF417BF  3c0200                            mov.b   #0, 4+var_2[sp]
FFF417C2  6683                              mov.l   #8, r3
FFF417C4  6602                              mov.l   #0, r2
FFF417C6  fb1266210100                      mov.l   #12166h, r1
FFF417CC  053a4600                          bsr.a   sub_FFF45E06
FFF417D0  6683                              mov.l   #8, r3
FFF417D2  6602                              mov.l   #0, r2
FFF417D4  fb126e210100                      mov.l   #1216Eh, r1
FFF417DA  052c4600                          bsr.a   sub_FFF45E06
FFF417DE  6683                              mov.l   #8, r3
FFF417E0  6602                              mov.l   #0, r2
FFF417E2  fb1276210100                      mov.l   #12176h, r1
FFF417E8  051e4600                          bsr.a   sub_FFF45E06
FFF417EC  b089                              movu.b  4+var_1[sp], r1
FFF417EE  6121                              cmp     #2, r1
FFF417F0  3a4502                            beq.w   loc_FFF41A35
FFF417F3  6111                              cmp     #1, r1
FFF417F5  3a2401                            beq.w   loc_FFF41919
FFF417F8  6101                              cmp     #0, r1
FFF417FA  3b5703                            bne.w   loc_FFF41B51
FFF417FD  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41803  c5e08102                          mov.b   81h[r14], 4+var_2[sp]
FFF41807  b081                              movu.b  4+var_2[sp], r1
FFF41809  fb2266210100                      mov.l   #12166h, r2
FFF4180F  054b9eff                          bsr.a   sub_FFF3B65A
FFF41813  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41819  c5e08202                          mov.b   82h[r14], 4+var_2[sp]
FFF4181D  b081                              movu.b  4+var_2[sp], r1
FFF4181F  fb2266210100                      mov.l   #12166h, r2
FFF41825  6222                              add     #2, r2
FFF41827  05339eff                          bsr.a   sub_FFF3B65A
FFF4182B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41831  c5e08302                          mov.b   83h[r14], 4+var_2[sp]
FFF41835  b081                              movu.b  4+var_2[sp], r1
FFF41837  fb2266210100                      mov.l   #12166h, r2
FFF4183D  6242                              add     #4, r2
FFF4183F  051b9eff                          bsr.a   sub_FFF3B65A
FFF41843  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41849  c5e08402                          mov.b   84h[r14], 4+var_2[sp]
FFF4184D  b081                              movu.b  4+var_2[sp], r1
FFF4184F  fb2266210100                      mov.l   #12166h, r2
FFF41855  6262                              add     #6, r2
FFF41857  05039eff                          bsr.a   sub_FFF3B65A
FFF4185B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41861  c5e08502                          mov.b   85h[r14], 4+var_2[sp]
FFF41865  b081                              movu.b  4+var_2[sp], r1
FFF41867  fb226e210100                      mov.l   #1216Eh, r2
FFF4186D  05ed9dff                          bsr.a   sub_FFF3B65A
FFF41871  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41877  c5e08602                          mov.b   86h[r14], 4+var_2[sp]
FFF4187B  b081                              movu.b  4+var_2[sp], r1
FFF4187D  fb226e210100                      mov.l   #1216Eh, r2
FFF41883  6222                              add     #2, r2
FFF41885  05d59dff                          bsr.a   sub_FFF3B65A
FFF41889  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4188F  c5e08702                          mov.b   87h[r14], 4+var_2[sp]
FFF41893  b081                              movu.b  4+var_2[sp], r1
FFF41895  fb226e210100                      mov.l   #1216Eh, r2
FFF4189B  6242                              add     #4, r2
FFF4189D  05bd9dff                          bsr.a   sub_FFF3B65A
FFF418A1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF418A7  c5e08802                          mov.b   88h[r14], 4+var_2[sp]
FFF418AB  b081                              movu.b  4+var_2[sp], r1
FFF418AD  fb226e210100                      mov.l   #1216Eh, r2
FFF418B3  6262                              add     #6, r2
FFF418B5  05a59dff                          bsr.a   sub_FFF3B65A
FFF418B9  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF418BF  c5e08902                          mov.b   89h[r14], 4+var_2[sp]
FFF418C3  b081                              movu.b  4+var_2[sp], r1
FFF418C5  fb2276210100                      mov.l   #12176h, r2
FFF418CB  058f9dff                          bsr.a   sub_FFF3B65A
FFF418CF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF418D5  c5e08a02                          mov.b   8Ah[r14], 4+var_2[sp]
FFF418D9  b081                              movu.b  4+var_2[sp], r1
FFF418DB  fb2276210100                      mov.l   #12176h, r2
FFF418E1  6222                              add     #2, r2
FFF418E3  05779dff                          bsr.a   sub_FFF3B65A
FFF418E7  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF418ED  c5e08b02                          mov.b   8Bh[r14], 4+var_2[sp]
FFF418F1  b081                              movu.b  4+var_2[sp], r1
FFF418F3  fb2276210100                      mov.l   #12176h, r2
FFF418F9  6242                              add     #4, r2
FFF418FB  055f9dff                          bsr.a   sub_FFF3B65A
FFF418FF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41905  c5e08c02                          mov.b   8Ch[r14], 4+var_2[sp]
FFF41909  b081                              movu.b  4+var_2[sp], r1
FFF4190B  fb2276210100                      mov.l   #12176h, r2
FFF41911  6262                              add     #6, r2
FFF41913  05479dff                          bsr.a   sub_FFF3B65A
FFF41917  6701                              rtsd    #1
FFF41919  fbe24d8c0000           loc_FFF41919 mov.l   #8C4Dh, r14
FFF4191F  c5e09502                          mov.b   95h[r14], 4+var_2[sp]
FFF41923  b081                              movu.b  4+var_2[sp], r1
FFF41925  fb2266210100                      mov.l   #12166h, r2
FFF4192B  052f9dff                          bsr.a   sub_FFF3B65A
FFF4192F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41935  c5e09602                          mov.b   96h[r14], 4+var_2[sp]
FFF41939  b081                              movu.b  4+var_2[sp], r1
FFF4193B  fb2266210100                      mov.l   #12166h, r2
FFF41941  6222                              add     #2, r2
FFF41943  05179dff                          bsr.a   sub_FFF3B65A
FFF41947  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4194D  c5e09702                          mov.b   97h[r14], 4+var_2[sp]
FFF41951  b081                              movu.b  4+var_2[sp], r1
FFF41953  fb2266210100                      mov.l   #12166h, r2
FFF41959  6242                              add     #4, r2
FFF4195B  05ff9cff                          bsr.a   sub_FFF3B65A
FFF4195F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41965  c5e09802                          mov.b   98h[r14], 4+var_2[sp]
FFF41969  b081                              movu.b  4+var_2[sp], r1
FFF4196B  fb2266210100                      mov.l   #12166h, r2
FFF41971  6262                              add     #6, r2
FFF41973  05e79cff                          bsr.a   sub_FFF3B65A
FFF41977  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4197D  c5e09902                          mov.b   99h[r14], 4+var_2[sp]
FFF41981  b081                              movu.b  4+var_2[sp], r1
FFF41983  fb226e210100                      mov.l   #1216Eh, r2
FFF41989  05d19cff                          bsr.a   sub_FFF3B65A
FFF4198D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41993  c5e09a02                          mov.b   9Ah[r14], 4+var_2[sp]
FFF41997  b081                              movu.b  4+var_2[sp], r1
FFF41999  fb226e210100                      mov.l   #1216Eh, r2
FFF4199F  6222                              add     #2, r2
FFF419A1  05b99cff                          bsr.a   sub_FFF3B65A
FFF419A5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF419AB  c5e09b02                          mov.b   9Bh[r14], 4+var_2[sp]
FFF419AF  b081                              movu.b  4+var_2[sp], r1
FFF419B1  fb226e210100                      mov.l   #1216Eh, r2
FFF419B7  6242                              add     #4, r2
FFF419B9  05a19cff                          bsr.a   sub_FFF3B65A
FFF419BD  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF419C3  c5e09c02                          mov.b   9Ch[r14], 4+var_2[sp]
FFF419C7  b081                              movu.b  4+var_2[sp], r1
FFF419C9  fb226e210100                      mov.l   #1216Eh, r2
FFF419CF  6262                              add     #6, r2
FFF419D1  05899cff                          bsr.a   sub_FFF3B65A
FFF419D5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF419DB  c5e09d02                          mov.b   9Dh[r14], 4+var_2[sp]
FFF419DF  b081                              movu.b  4+var_2[sp], r1
FFF419E1  fb2276210100                      mov.l   #12176h, r2
FFF419E7  05739cff                          bsr.a   sub_FFF3B65A
FFF419EB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF419F1  c5e09e02                          mov.b   9Eh[r14], 4+var_2[sp]
FFF419F5  b081                              movu.b  4+var_2[sp], r1
FFF419F7  fb2276210100                      mov.l   #12176h, r2
FFF419FD  6222                              add     #2, r2
FFF419FF  055b9cff                          bsr.a   sub_FFF3B65A
FFF41A03  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41A09  c5e09f02                          mov.b   9Fh[r14], 4+var_2[sp]
FFF41A0D  b081                              movu.b  4+var_2[sp], r1
FFF41A0F  fb2276210100                      mov.l   #12176h, r2
FFF41A15  6242                              add     #4, r2
FFF41A17  05439cff                          bsr.a   sub_FFF3B65A
FFF41A1B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41A21  c5e0a002                          mov.b   0A0h[r14], 4+var_2[sp]
FFF41A25  b081                              movu.b  4+var_2[sp], r1
FFF41A27  fb2276210100                      mov.l   #12176h, r2
FFF41A2D  6262                              add     #6, r2
FFF41A2F  052b9cff                          bsr.a   sub_FFF3B65A
FFF41A33  6701                              rtsd    #1
FFF41A35  fbe24d8c0000           loc_FFF41A35 mov.l   #8C4Dh, r14
FFF41A3B  c5e0bd02                          mov.b   0BDh[r14], 4+var_2[sp]
FFF41A3F  b081                              movu.b  4+var_2[sp], r1
FFF41A41  fb2266210100                      mov.l   #12166h, r2
FFF41A47  05139cff                          bsr.a   sub_FFF3B65A
FFF41A4B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41A51  c5e0be02                          mov.b   0BEh[r14], 4+var_2[sp]
FFF41A55  b081                              movu.b  4+var_2[sp], r1
FFF41A57  fb2266210100                      mov.l   #12166h, r2
FFF41A5D  6222                              add     #2, r2
FFF41A5F  05fb9bff                          bsr.a   sub_FFF3B65A
FFF41A63  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41A69  c5e0bf02                          mov.b   0BFh[r14], 4+var_2[sp]
FFF41A6D  b081                              movu.b  4+var_2[sp], r1
FFF41A6F  fb2266210100                      mov.l   #12166h, r2
FFF41A75  6242                              add     #4, r2
FFF41A77  05e39bff                          bsr.a   sub_FFF3B65A
FFF41A7B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41A81  c5e0c002                          mov.b   0C0h[r14], 4+var_2[sp]
FFF41A85  b081                              movu.b  4+var_2[sp], r1
FFF41A87  fb2266210100                      mov.l   #12166h, r2
FFF41A8D  6262                              add     #6, r2
FFF41A8F  05cb9bff                          bsr.a   sub_FFF3B65A
FFF41A93  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41A99  c5e0c102                          mov.b   0C1h[r14], 4+var_2[sp]
FFF41A9D  b081                              movu.b  4+var_2[sp], r1
FFF41A9F  fb226e210100                      mov.l   #1216Eh, r2
FFF41AA5  05b59bff                          bsr.a   sub_FFF3B65A
FFF41AA9  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41AAF  c5e0c202                          mov.b   0C2h[r14], 4+var_2[sp]
FFF41AB3  b081                              movu.b  4+var_2[sp], r1
FFF41AB5  fb226e210100                      mov.l   #1216Eh, r2
FFF41ABB  6222                              add     #2, r2
FFF41ABD  059d9bff                          bsr.a   sub_FFF3B65A
FFF41AC1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41AC7  c5e0c302                          mov.b   0C3h[r14], 4+var_2[sp]
FFF41ACB  b081                              movu.b  4+var_2[sp], r1
FFF41ACD  fb226e210100                      mov.l   #1216Eh, r2
FFF41AD3  6242                              add     #4, r2
FFF41AD5  05859bff                          bsr.a   sub_FFF3B65A
FFF41AD9  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41ADF  c5e0c402                          mov.b   0C4h[r14], 4+var_2[sp]
FFF41AE3  b081                              movu.b  4+var_2[sp], r1
FFF41AE5  fb226e210100                      mov.l   #1216Eh, r2
FFF41AEB  6262                              add     #6, r2
FFF41AED  056d9bff                          bsr.a   sub_FFF3B65A
FFF41AF1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41AF7  c5e0c502                          mov.b   0C5h[r14], 4+var_2[sp]
FFF41AFB  b081                              movu.b  4+var_2[sp], r1
FFF41AFD  fb2276210100                      mov.l   #12176h, r2
FFF41B03  05579bff                          bsr.a   sub_FFF3B65A
FFF41B07  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41B0D  c5e0c602                          mov.b   0C6h[r14], 4+var_2[sp]
FFF41B11  b081                              movu.b  4+var_2[sp], r1
FFF41B13  fb2276210100                      mov.l   #12176h, r2
FFF41B19  6222                              add     #2, r2
FFF41B1B  053f9bff                          bsr.a   sub_FFF3B65A
FFF41B1F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41B25  c5e0c702                          mov.b   0C7h[r14], 4+var_2[sp]
FFF41B29  b081                              movu.b  4+var_2[sp], r1
FFF41B2B  fb2276210100                      mov.l   #12176h, r2
FFF41B31  6242                              add     #4, r2
FFF41B33  05279bff                          bsr.a   sub_FFF3B65A
FFF41B37  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41B3D  c5e0c802                          mov.b   0C8h[r14], 4+var_2[sp]
FFF41B41  b081                              movu.b  4+var_2[sp], r1
FFF41B43  fb2276210100                      mov.l   #12176h, r2
FFF41B49  6262                              add     #6, r2
FFF41B4B  050f9bff                          bsr.a   sub_FFF3B65A
FFF41B4F  6701                              rtsd    #1
FFF41B51  6701                   loc_FFF41B51 rtsd    #1
FFF41B53  fbe24c8c0000           sub_FFF41B53 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF41B53
FFF41B59  58ee                              movu.b  [r14], r14
FFF41B5B  613e                              cmp     #3, r14
FFF41B5D  2a16                              bgt.b   loc_FFF41B73
FFF41B5F  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF41B65  58ee                              movu.b  [r14], r14
FFF41B67  fbf27884edff                      mov.l   #off_FFED8478, r15
FFF41B6D  fe6efe                            mov.l   [r14, r15], r14
FFF41B70  7f1e                              jsr     r14
FFF41B72  02                                rts
FFF41B73  fbe24c8c0000           loc_FFF41B73 mov.l   #8C4Ch, r14
FFF41B79  f8e403                            mov.b   #3, [r14]
FFF41B7C  02                                rts
FFF41B7D  6611                   sub_FFF41B7D mov.l   #1, r1   ; <<<< FUNC sub_FFF41B7D
FFF41B7F  39e801                            bsr.w   sub_FFF41D67
FFF41B82  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF41B88  58ef                              movu.b  [r14], r15
FFF41B8A  621f                              add     #1, r15
FFF41B8C  c3ef                              mov.b   r15, [r14]
FFF41B8E  02                                rts
FFF41B8F  6080                   sub_FFF41B8F sub     #8, sp   ; <<<< FUNC sub_FFF41B8F
FFF41B91  059ce7fa                          bsr.a   sub_FFEF032D
FFF41B95  05c98bfb                          bsr.a   sub_FFEFA75E
FFF41B99  3d0362                            mov.w   #62h, 8+var_2[sp] ; 'b'
FFF41B9C  3d0205                            mov.w   #5, 8+var_4[sp]
FFF41B9F  3d0101                            mov.w   #1, 8+var_6[sp]
FFF41BA2  3c0100                            mov.b   #0, 8+var_7[sp]
FFF41BA5  2e45                              bra.b   loc_FFF41BEA
FFF41BA7  fbe28c950600           loc_FFF41BA7 mov.l   #6958Ch, r14
FFF41BAD  b009                              movu.b  8+var_7[sp], r1
FFF41BAF  fe61e4                            mov.l   [r1, r14], r4
FFF41BB2  b882                              movu.w  8+var_4[sp], r2
FFF41BB4  b889                              movu.w  8+var_2[sp], r1
FFF41BB6  6613                              mov.l   #1, r3
FFF41BB8  051d4dfb                          bsr.a   sub_FFEF68D5
FFF41BBC  b009                              movu.b  8+var_7[sp], r1
FFF41BBE  6121                              cmp     #2, r1
FFF41BC0  b809                              movu.w  8+var_6[sp], r1
FFF41BC2  1a                                bne.s   loc_FFF41BCC
FFF41BC3  06c90103                          add     8+var_2[sp].uw, r1
FFF41BC7  6291                              add     #9, r1
FFF41BC9  9089                              mov.w   r1, 8+var_2[sp]
FFF41BCB  09                                bra.s   loc_FFF41BD4
FFF41BCC  06c90103               loc_FFF41BCC add     8+var_2[sp].uw, r1
FFF41BD0  62c1                              add     #0Ch, r1
FFF41BD2  9089                              mov.w   r1, 8+var_2[sp]
FFF41BD4  b009                   loc_FFF41BD4 movu.b  8+var_7[sp], r1
FFF41BD6  6141                              cmp     #4, r1
FFF41BD8  210c                              bne.b   loc_FFF41BE4
FFF41BDA  b809                              movu.w  8+var_6[sp], r1
FFF41BDC  06c90103                          add     8+var_2[sp].uw, r1
FFF41BE0  62c1                              add     #0Ch, r1
FFF41BE2  9089                              mov.w   r1, 8+var_2[sp]
FFF41BE4  b009                   loc_FFF41BE4 movu.b  8+var_7[sp], r1
FFF41BE6  6211                              add     #1, r1
FFF41BE8  8009                              mov.b   r1, 8+var_7[sp]
FFF41BEA  b009                   loc_FFF41BEA movu.b  8+var_7[sp], r1
FFF41BEC  6191                              cmp     #9, r1
FFF41BEE  29b9                              blt.b   loc_FFF41BA7
FFF41BF0  7542b4                            mov.l   #-4Ch, r2
FFF41BF3  75411b                            mov.l   #1Bh, r1
FFF41BF6  055989fb                          bsr.a   sub_FFEFA54F
FFF41BFA  6661                              mov.l   #6, r1
FFF41BFC  059382fb                          bsr.a   sub_FFEF9E8F
FFF41C00  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF41C06  58ef                              movu.b  [r14], r15
FFF41C08  621f                              add     #1, r15
FFF41C0A  c3ef                              mov.b   r15, [r14]
FFF41C0C  6702                              rtsd    #2
FFF41C0E  6040                   sub_FFF41C0E sub     #4, sp   ; <<<< FUNC sub_FFF41C0E
FFF41C10  6040                              sub     #4, sp
FFF41C12  3d00f0                            mov.w   #-10h, [sp]
FFF41C15  fb4a4001                          mov.l   #140h, r4
FFF41C19  6602                              mov.l   #0, r2
FFF41C1B  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF41C21  ef23                              mov.l   r2, r3
FFF41C23  0598ddfa                          bsr.a   sub_FFEEF9BB
FFF41C27  6240                              add     #4, sp
FFF41C29  8089                              mov.b   r1, 4+var_1[sp]
FFF41C2B  b089                              movu.b  4+var_1[sp], r1
FFF41C2D  6111                              cmp     #1, r1
FFF41C2F  1a                                bne.s   loc_FFF41C39
FFF41C30  39f602                            bsr.w   sub_FFF41F26
FFF41C33  053ce7fa                          bsr.a   sub_FFEF036F
FFF41C37  6701                              rtsd    #1
FFF41C39  6701                   loc_FFF41C39 rtsd    #1
FFF41C3B  6040                   sub_FFF41C3B sub     #4, sp   ; <<<< FUNC sub_FFF41C3B
FFF41C3D  6040                              sub     #4, sp
FFF41C3F  3d009d                            mov.w   #-63h, [sp]
FFF41C42  fb4a4001                          mov.l   #140h, r4
FFF41C46  75431a                            mov.l   #1Ah, r3
FFF41C49  6602                              mov.l   #0, r2
FFF41C4B  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF41C51  056addfa                          bsr.a   sub_FFEEF9BB
FFF41C55  6240                              add     #4, sp
FFF41C57  8089                              mov.b   r1, 4+var_1[sp]
FFF41C59  b089                              movu.b  4+var_1[sp], r1
FFF41C5B  6111                              cmp     #1, r1
FFF41C5D  2110                              bne.b   loc_FFF41C6D
FFF41C5F  75421a                            mov.l   #1Ah, r2
FFF41C62  6601                              mov.l   #0, r1
FFF41C64  39fa02                            bsr.w   sub_FFF41F5E
FFF41C67  0508e7fa                          bsr.a   sub_FFEF036F
FFF41C6B  6701                              rtsd    #1
FFF41C6D  6701                   loc_FFF41C6D rtsd    #1
FFF41C6F  7100f0                 sub_FFF41C6F add     #-10h, sp, sp   ; <<<< FUNC sub_FFF41C6F
FFF41C72  fbe2738f0000                      mov.l   #8F73h, r14
FFF41C78  58e1                              movu.b  [r14], r1
FFF41C7A  7111ef                            add     #-11h, r1, r1
FFF41C7D  8081                              mov.b   r1, 10h+var_E[sp]
FFF41C7F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41C85  c4e00a                            mov.b   [r14], 10h+var_6[sp]
FFF41C88  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41C8E  c5e0010b                          mov.b   1[r14], 10h+var_5[sp]
FFF41C92  c500020d                          mov.b   10h+var_E[sp], 10h+var_3[sp]
FFF41C96  71010a                            add     #10h+var_6, sp, r1
FFF41C99  058b0afb                          bsr.a   sub_FFEF2724
FFF41C9D  b301                              movu.b  10h+var_4[sp], r1
FFF41C9F  6c21                              shll    #2, r1
FFF41CA1  fbe268880600                      mov.l   #68868h, r14
FFF41CA7  4b1e                              add     r1, r14
FFF41CA9  b081                              movu.b  10h+var_E[sp], r1
FFF41CAB  6c31                              shll    #3, r1
FFF41CAD  0688e1                            add     [r14].l, r1
FFF41CB0  a009                              mov.l   r1, 10h+var_C[sp]
FFF41CB2  a809                              mov.l   10h+var_C[sp], r1
FFF41CB4  b894                              movu.w  4[r1], r4
FFF41CB6  b81b                              movu.w  2[r1], r3
FFF41CB8  5c12                              movu.w  [r1], r2
FFF41CBA  6040                              sub     #4, sp
FFF41CBC  d11003                            mov.w   6[r1], 14h+var_14[sp]
FFF41CBF  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF41CC5  05f6dcfa                          bsr.a   sub_FFEEF9BB
FFF41CC9  6240                              add     #4, sp
FFF41CCB  8089                              mov.b   r1, 10h+var_D[sp]
FFF41CCD  b089                              movu.b  10h+var_D[sp], r1
FFF41CCF  6111                              cmp     #1, r1
FFF41CD1  210e                              bne.b   loc_FFF41CDF
FFF41CD3  b081                              movu.b  10h+var_E[sp], r1
FFF41CD5  053008fb                          bsr.a   sub_FFEF2505
FFF41CD9  0596e6fa                          bsr.a   sub_FFEF036F
FFF41CDD  6704                              rtsd    #4
FFF41CDF  6704                   loc_FFF41CDF rtsd    #4
FFF41CE1  6040                   sub_FFF41CE1 sub     #4, sp   ; <<<< FUNC sub_FFF41CE1
FFF41CE3  055ce3fa                          bsr.a   sub_FFEF003F
FFF41CE7  fbe2738f0000                      mov.l   #8F73h, r14
FFF41CED  c3e1                              mov.b   r1, [r14]
FFF41CEF  fbe2738f0000                      mov.l   #8F73h, r14
FFF41CF5  58ee                              movu.b  [r14], r14
FFF41CF7  755eff                            cmp     #-1, r14
FFF41CFA  1e                                bne.s   loc_FFF41D00
FFF41CFB  6601                              mov.l   #0, r1
FFF41CFD  396a00                            bsr.w   sub_FFF41D67
FFF41D00  fbe2738f0000           loc_FFF41D00 mov.l   #8F73h, r14
FFF41D06  58ee                              movu.b  [r14], r14
FFF41D08  755eff                            cmp     #-1, r14
FFF41D0B  2013                              beq.b   loc_FFF41D1E
FFF41D0D  fbe2738f0000                      mov.l   #8F73h, r14
FFF41D13  58ee                              movu.b  [r14], r14
FFF41D15  755e13                            cmp     #13h, r14
FFF41D18  2406                              bgtu.b  loc_FFF41D1E
FFF41D1A  f80601                            mov.l   #1, 4+var_4[sp]
FFF41D1D  0c                                bra.s   loc_FFF41D21
FFF41D1E  f80600                 loc_FFF41D1E mov.l   #0, 4+var_4[sp]
FFF41D21  ec01                   loc_FFF41D21 mov.l   4+var_4[sp], r1
FFF41D23  6101                              cmp     #0, r1
FFF41D25  2029                              beq.b   loc_FFF41D4E
FFF41D27  055ddefa                          bsr.a   sub_FFEEFB84
FFF41D2B  6101                              cmp     #0, r1
FFF41D2D  2121                              bne.b   loc_FFF41D4E
FFF41D2F  fbe2738f0000                      mov.l   #8F73h, r14
FFF41D35  58e1                              movu.b  [r14], r1
FFF41D37  05b3e2fa                          bsr.a   sub_FFEEFFEA
FFF41D3B  fbe2738f0000                      mov.l   #8F73h, r14
FFF41D41  58ee                              movu.b  [r14], r14
FFF41D43  fbf28884edff                      mov.l   #off_FFED8488, r15
FFF41D49  fe6efe                            mov.l   [r14, r15], r14
FFF41D4C  7f1e                              jsr     r14
FFF41D4E  fbe24c8c0000           loc_FFF41D4E mov.l   #8C4Ch, r14
FFF41D54  58ee                              movu.b  [r14], r14
FFF41D56  614e                              cmp     #4, r14
FFF41D58  290d                              blt.b   loc_FFF41D65
FFF41D5A  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF41D60  f8e403                            mov.b   #3, [r14]
FFF41D63  6701                              rtsd    #1
FFF41D65  6701                   loc_FFF41D65 rtsd    #1
FFF41D67  6040                   sub_FFF41D67 sub     #4, sp   ; <<<< FUNC sub_FFF41D67
FFF41D69  8089                              mov.b   r1, 4+var_1[sp]
FFF41D6B  05fe22fb                          bsr.a   sub_FFEF4069
FFF41D6F  391400                            bsr.w   sub_FFF41D83
FFF41D72  054823fb                          bsr.a   sub_FFEF40BA
FFF41D76  b089                              movu.b  4+var_1[sp], r1
FFF41D78  6111                              cmp     #1, r1
FFF41D7A  1f                                bne.s   loc_FFF41D81
FFF41D7B  05b1e2fa                          bsr.a   sub_FFEF002C
FFF41D7F  6701                              rtsd    #1
FFF41D81  6701                   loc_FFF41D81 rtsd    #1
FFF41D83  6040                   sub_FFF41D83 sub     #4, sp   ; <<<< FUNC sub_FFF41D83
FFF41D85  3c0300                            mov.b   #0, 4+var_1[sp]
FFF41D88  3c0200                            mov.b   #0, 4+var_2[sp]
FFF41D8B  f80500                            mov.w   #0, 4+var_4[sp]
FFF41D8E  05b423fb                          bsr.a   sub_FFEF4142
FFF41D92  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41D98  59ee20                            movu.b  20h[r14], r14
FFF41D9B  fbf2468e0000                      mov.l   #8E46h, r15
FFF41DA1  45fe20                            cmp     20h[r15], r14
FFF41DA4  201b                              beq.b   loc_FFF41DBF
FFF41DA6  fb1e000001                        mov.l   #10000h, r1
FFF41DAB  05f9e0fa                          bsr.a   sub_FFEEFEA4
FFF41DAF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41DB5  fbf2468e0000                      mov.l   #8E46h, r15
FFF41DBB  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF41DBF  fbe24d8c0000           loc_FFF41DBF mov.l   #8C4Dh, r14
FFF41DC5  59ee21                            movu.b  21h[r14], r14
FFF41DC8  fbf2468e0000                      mov.l   #8E46h, r15
FFF41DCE  45fe21                            cmp     21h[r15], r14
FFF41DD1  201b                              beq.b   loc_FFF41DEC
FFF41DD3  fb1e000001                        mov.l   #10000h, r1
FFF41DD8  05cce0fa                          bsr.a   sub_FFEEFEA4
FFF41DDC  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41DE2  fbf2468e0000                      mov.l   #8E46h, r15
FFF41DE8  c5fe2121                          mov.b   21h[r15], 21h[r14]
FFF41DEC  fbe24d8c0000           loc_FFF41DEC mov.l   #8C4Dh, r14
FFF41DF2  59ee22                            movu.b  22h[r14], r14
FFF41DF5  fbf2468e0000                      mov.l   #8E46h, r15
FFF41DFB  45fe22                            cmp     22h[r15], r14
FFF41DFE  201b                              beq.b   loc_FFF41E19
FFF41E00  fb1e000001                        mov.l   #10000h, r1
FFF41E05  059fe0fa                          bsr.a   sub_FFEEFEA4
FFF41E09  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41E0F  fbf2468e0000                      mov.l   #8E46h, r15
FFF41E15  c5fe2222                          mov.b   22h[r15], 22h[r14]
FFF41E19  3c0300                 loc_FFF41E19 mov.b   #0, 4+var_1[sp]
FFF41E1C  2e5f                              bra.b   loc_FFF41E7B
FFF41E1E  3c0200                 loc_FFF41E1E mov.b   #0, 4+var_2[sp]
FFF41E21  2e4e                              bra.b   loc_FFF41E6F
FFF41E23  b089                   loc_FFF41E23 movu.b  4+var_1[sp], r1
FFF41E25  63a1                              mul     #0Ah, r1
FFF41E27  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41E2D  4b1e                              add     r1, r14
FFF41E2F  b082                              movu.b  4+var_2[sp], r2
FFF41E31  4b2e                              add     r2, r14
FFF41E33  59ee23                            movu.b  23h[r14], r14
FFF41E36  fbf2468e0000                      mov.l   #8E46h, r15
FFF41E3C  4b1f                              add     r1, r15
FFF41E3E  4b2f                              add     r2, r15
FFF41E40  45fe23                            cmp     23h[r15], r14
FFF41E43  2026                              beq.b   loc_FFF41E69
FFF41E45  dc01                              mov.w   4+var_4[sp], r1
FFF41E47  6211                              add     #1, r1
FFF41E49  d301                              mov.w   r1, 4+var_4[sp]
FFF41E4B  b089                              movu.b  4+var_1[sp], r1
FFF41E4D  63a1                              mul     #0Ah, r1
FFF41E4F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41E55  4b1e                              add     r1, r14
FFF41E57  b082                              movu.b  4+var_2[sp], r2
FFF41E59  4b2e                              add     r2, r14
FFF41E5B  fbf2468e0000                      mov.l   #8E46h, r15
FFF41E61  4b1f                              add     r1, r15
FFF41E63  4b2f                              add     r2, r15
FFF41E65  c5fe2323                          mov.b   23h[r15], 23h[r14]
FFF41E69  b081                   loc_FFF41E69 movu.b  4+var_2[sp], r1
FFF41E6B  6211                              add     #1, r1
FFF41E6D  8081                              mov.b   r1, 4+var_2[sp]
FFF41E6F  b081                   loc_FFF41E6F movu.b  4+var_2[sp], r1
FFF41E71  61a1                              cmp     #0Ah, r1
FFF41E73  29b0                              blt.b   loc_FFF41E23
FFF41E75  b089                              movu.b  4+var_1[sp], r1
FFF41E77  6211                              add     #1, r1
FFF41E79  8089                              mov.b   r1, 4+var_1[sp]
FFF41E7B  b089                   loc_FFF41E7B movu.b  4+var_1[sp], r1
FFF41E7D  6151                              cmp     #5, r1
FFF41E7F  299f                              blt.b   loc_FFF41E1E
FFF41E81  5c01                              movu.w  4+var_4[sp], r1
FFF41E83  6101                              cmp     #0, r1
FFF41E85  12                                beq.s   loc_FFF41E8F
FFF41E86  fb1e000001                        mov.l   #10000h, r1
FFF41E8B  0519e0fa                          bsr.a   sub_FFEEFEA4
FFF41E8F  3c0300                 loc_FFF41E8F mov.b   #0, 4+var_1[sp]
FFF41E92  388500                            bra.w   loc_FFF41F17
FFF41E95  b089                   loc_FFF41E95 movu.b  4+var_1[sp], r1
FFF41E97  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41E9D  4b1e                              add     r1, r14
FFF41E9F  59ee55                            movu.b  55h[r14], r14
FFF41EA2  fbf2468e0000                      mov.l   #8E46h, r15
FFF41EA8  4b1f                              add     r1, r15
FFF41EAA  45fe55                            cmp     55h[r15], r14
FFF41EAD  2026                              beq.b   loc_FFF41ED3
FFF41EAF  b08a                              movu.b  4+var_1[sp], r2
FFF41EB1  fb1e000002                        mov.l   #20000h, r1
FFF41EB6  fd6221                            shll    r2, r1
FFF41EB9  05ebdffa                          bsr.a   sub_FFEEFEA4
FFF41EBD  b089                              movu.b  4+var_1[sp], r1
FFF41EBF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41EC5  4b1e                              add     r1, r14
FFF41EC7  fbf2468e0000                      mov.l   #8E46h, r15
FFF41ECD  4b1f                              add     r1, r15
FFF41ECF  c5fe5555                          mov.b   55h[r15], 55h[r14]
FFF41ED3  b089                   loc_FFF41ED3 movu.b  4+var_1[sp], r1
FFF41ED5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41EDB  4b1e                              add     r1, r14
FFF41EDD  59ee58                            movu.b  58h[r14], r14
FFF41EE0  fbf2468e0000                      mov.l   #8E46h, r15
FFF41EE6  4b1f                              add     r1, r15
FFF41EE8  45fe58                            cmp     58h[r15], r14
FFF41EEB  2026                              beq.b   loc_FFF41F11
FFF41EED  b08a                              movu.b  4+var_1[sp], r2
FFF41EEF  fb1e000002                        mov.l   #20000h, r1
FFF41EF4  fd6221                            shll    r2, r1
FFF41EF7  05addffa                          bsr.a   sub_FFEEFEA4
FFF41EFB  b089                              movu.b  4+var_1[sp], r1
FFF41EFD  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41F03  4b1e                              add     r1, r14
FFF41F05  fbf2468e0000                      mov.l   #8E46h, r15
FFF41F0B  4b1f                              add     r1, r15
FFF41F0D  c5fe5858                          mov.b   58h[r15], 58h[r14]
FFF41F11  b089                   loc_FFF41F11 movu.b  4+var_1[sp], r1
FFF41F13  6211                              add     #1, r1
FFF41F15  8089                              mov.b   r1, 4+var_1[sp]
FFF41F17  b089                   loc_FFF41F17 movu.b  4+var_1[sp], r1
FFF41F19  6131                              cmp     #3, r1
FFF41F1B  2805                              bge.b   loc_FFF41F20
FFF41F1D  3878ff                            bra.w   loc_FFF41E95
FFF41F20  0574e3fa               loc_FFF41F20 bsr.a   sub_FFEF0294
FFF41F24  6701                              rtsd    #1
FFF41F26  fbe2798d0000           sub_FFF41F26 mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF41F26
FFF41F2C  f8e400                            mov.b   #0, [r14]
FFF41F2F  6601                              mov.l   #0, r1
FFF41F31  ef12                              mov.l   r1, r2
FFF41F33  05d5e4fa                          bsr.a   sub_FFEF0408
FFF41F37  75421a                            mov.l   #1Ah, r2
FFF41F3A  6601                              mov.l   #0, r1
FFF41F3C  392200                            bsr.w   sub_FFF41F5E
FFF41F3F  6601                              mov.l   #0, r1
FFF41F41  05c405fb                          bsr.a   sub_FFEF2505
FFF41F45  6611                              mov.l   #1, r1
FFF41F47  05be05fb                          bsr.a   sub_FFEF2505
FFF41F4B  6621                              mov.l   #2, r1
FFF41F4D  05b805fb                          bsr.a   sub_FFEF2505
FFF41F51  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF41F57  58ef                              movu.b  [r14], r15
FFF41F59  621f                              add     #1, r15
FFF41F5B  c3ef                              mov.b   r15, [r14]
FFF41F5D  02                                rts
FFF41F5E  6040                   sub_FFF41F5E sub     #4, sp   ; <<<< FUNC sub_FFF41F5E
FFF41F60  9009                              mov.w   r1, 4+var_2[sp]
FFF41F62  d302                              mov.w   r2, 4+var_4[sp]
FFF41F64  5c02                              movu.w  4+var_4[sp], r2
FFF41F66  b809                              movu.w  4+var_2[sp], r1
FFF41F68  754eb7                            mov.l   #-49h, r14
FFF41F6B  432e                              sub     r2, r14
FFF41F6D  5fe4                              movu.w  r14, r4
FFF41F6F  fbea4001                          mov.l   #140h, r14
FFF41F73  431e                              sub     r1, r14
FFF41F75  5fe3                              movu.w  r14, r3
FFF41F77  0580e5fa                          bsr.a   sub_FFEF04F7
FFF41F7B  5c02                              movu.w  4+var_4[sp], r2
FFF41F7D  b809                              movu.w  4+var_2[sp], r1
FFF41F7F  390f00                            bsr.w   sub_FFF41F8E
FFF41F82  7542b4                            mov.l   #-4Ch, r2
FFF41F85  75411b                            mov.l   #1Bh, r1
FFF41F88  05797dfb                          bsr.a   sub_FFEF9D01
FFF41F8C  6701                              rtsd    #1
FFF41F8E  7100d8                 sub_FFF41F8E add     #-28h, sp, sp   ; <<<< FUNC sub_FFF41F8E
FFF41F91  9489                              mov.w   r1, 28h+var_2[sp]
FFF41F93  9482                              mov.w   r2, 28h+var_4[sp]
FFF41F95  3d0906                            mov.w   #6, 28h+var_16[sp]
FFF41F98  3d082d                            mov.w   #2Dh, 28h+var_18[sp] ; '-'
FFF41F9B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41FA1  c5e02109                          mov.b   21h[r14], 28h+var_1F[sp]
FFF41FA5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41FAB  c5e02008                          mov.b   20h[r14], 28h+var_20[sp]
FFF41FAF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF41FB5  c5e02207                          mov.b   22h[r14], 28h+var_21[sp]
FFF41FB9  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF41FBF  711123                            add     #23h, r1, r1 ; '#'
FFF41FC2  e301                              mov.l   r1, 28h+var_28[sp]
FFF41FC4  b209                              movu.b  28h+var_1F[sp], r1
FFF41FC6  6161                              cmp     #6, r1
FFF41FC8  2905                              blt.b   loc_FFF41FCD
FFF41FCA  3c0905                            mov.b   #5, 28h+var_1F[sp]
FFF41FCD  b209                   loc_FFF41FCD movu.b  28h+var_1F[sp], r1
FFF41FCF  6011                              sub     #1, r1
FFF41FD1  b202                              movu.b  28h+var_20[sp], r2
FFF41FD3  4712                              cmp     r1, r2
FFF41FD5  2b08                              ble.b   loc_FFF41FDD
FFF41FD7  b209                              movu.b  28h+var_1F[sp], r1
FFF41FD9  6011                              sub     #1, r1
FFF41FDB  8201                              mov.b   r1, 28h+var_20[sp]
FFF41FDD  b189                   loc_FFF41FDD movu.b  28h+var_21[sp], r1
FFF41FDF  6101                              cmp     #0, r1
FFF41FE1  3ac500                            beq.w   loc_FFF420A6
FFF41FE4  3c0b00                            mov.b   #0, 28h+var_1D[sp]
FFF41FE7  388900                            bra.w   loc_FFF42070
FFF41FEA  b289                   loc_FFF41FEA movu.b  28h+var_1D[sp], r1
FFF41FEC  75111f                            mul     #1Fh, r1
FFF41FEF  06c90112                          add     28h+var_4[sp].uw, r1
FFF41FF3  6211                              add     #1, r1
FFF41FF5  9189                              mov.w   r1, 28h+var_1A[sp]
FFF41FF7  b201                              movu.b  28h+var_20[sp], r1
FFF41FF9  45010b                            cmp     28h+var_1D[sp], r1
FFF41FFC  2119                              bne.b   loc_FFF42015
FFF41FFE  b98a                              movu.w  28h+var_1A[sp], r2

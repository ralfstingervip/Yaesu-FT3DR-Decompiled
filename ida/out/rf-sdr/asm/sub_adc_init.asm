; window adc_init file 2E1080-2E1780 map FFEE1080-FFEE1780 forced 598
; ==== adc_init  FFEE1080-FFEE1780 ====
FFEE1080  09                                bra.s   loc_FFEE1089
FFEE1081  b809                     loc_FFEE1081 movu.w  4+var_2[sp], r1
FFEE1083  6181                              cmp     #8, r1
FFEE1085  29da                              blt.b   loc_FFEE105F
FFEE1087  b009                     loc_FFEE1087 movu.b  4+var_3[sp], r1
FFEE1089  6101                     loc_FFEE1089 cmp     #0, r1
FFEE108B  2078                              beq.b   loc_FFEE1103
FFEE108D  fbe268cc0100                      mov.l   #1CC68h, r14
FFEE1093  ecee                              mov.l   [r14], r14
FFEE1095  613e                              cmp     #3, r14
FFEE1097  2a10                              bgt.b   loc_FFEE10A7
FFEE1099  fbe268cc0100                      mov.l   #1CC68h, r14
FFEE109F  ecef                              mov.l   [r14], r15
FFEE10A1  621f                              add     #1, r15
FFEE10A3  e3ef                              mov.l   r15, [r14]
FFEE10A5  2e4e                              bra.b   loc_FFEE10F3
FFEE10A7  fbe26ccc0100             loc_FFEE10A7 mov.l   #1CC6Ch, r14
FFEE10AD  ecee                              mov.l   [r14], r14
FFEE10AF  610e                              cmp     #0, r14
FFEE10B1  2a10                              bgt.b   loc_FFEE10C1
FFEE10B3  fbe26ccc0100                      mov.l   #1CC6Ch, r14
FFEE10B9  ecef                              mov.l   [r14], r15
FFEE10BB  621f                              add     #1, r15
FFEE10BD  e3ef                              mov.l   r15, [r14]
FFEE10BF  2e34                              bra.b   loc_FFEE10F3
FFEE10C1  fbe278cc0100             loc_FFEE10C1 mov.l   #1CC78h, r14
FFEE10C7  ecee                              mov.l   [r14], r14
FFEE10C9  610e                              cmp     #0, r14
FFEE10CB  2a10                              bgt.b   loc_FFEE10DB
FFEE10CD  fbe278cc0100                      mov.l   #1CC78h, r14
FFEE10D3  ecef                              mov.l   [r14], r15
FFEE10D5  621f                              add     #1, r15
FFEE10D7  e3ef                              mov.l   r15, [r14]
FFEE10D9  2e1a                              bra.b   loc_FFEE10F3
FFEE10DB  fbe284cc0100             loc_FFEE10DB mov.l   #1CC84h, r14
FFEE10E1  ecee                              mov.l   [r14], r14
FFEE10E3  610e                              cmp     #0, r14
FFEE10E5  2a0e                              bgt.b   loc_FFEE10F3
FFEE10E7  fbe284cc0100                      mov.l   #1CC84h, r14
FFEE10ED  ecef                              mov.l   [r14], r15
FFEE10EF  621f                              add     #1, r15
FFEE10F1  e3ef                              mov.l   r15, [r14]
FFEE10F3  fbe2e0cd0100             loc_FFEE10F3 mov.l   #1CDE0h, r14
FFEE10F9  ece1                              mov.l   [r14], r1
FFEE10FB  6612                              mov.l   #1, r2
FFEE10FD  05ea0100                          bsr.a   sub_FFEE12E7
FFEE1101  6701                              rtsd    #1
FFEE1103  6701                     loc_FFEE1103 rtsd    #1
FFEE1105  fbe2d4240100             sub_FFEE1105 mov.l   #124D4h, r14  ; <<< FUNC sub_FFEE1105
FFEE110B  f8e500                            mov.w   #0, [r14]
FFEE110E  fbee008108                        mov.l   #88100h, r14
FFEE1113  f0e8                              bclr    #0, [r14].b
FFEE1115  fb1e108108                        mov.l   #88110h, r1
FFEE111A  3c1100                            mov.b   #0, 1[r1]
FFEE111D  fb1e108108                        mov.l   #88110h, r1
FFEE1122  3c1200                            mov.b   #0, 2[r1]
FFEE1125  fb1e108108                        mov.l   #88110h, r1
FFEE112A  3c1300                            mov.b   #0, 3[r1]
FFEE112D  fbee108108                        mov.l   #88110h, r14
FFEE1132  f8e401                            mov.b   #1, [r14]
FFEE1135  fb1e108108                        mov.l   #88110h, r1
FFEE113A  3c1441                            mov.b   #41h, 4[r1] ; 'A'
FFEE113D  fb1e108108                        mov.l   #88110h, r1
FFEE1142  3d1300                            mov.w   #0, 6[r1]
FFEE1145  fbee108108                        mov.l   #88110h, r14
FFEE114A  f9e9045fea                        mov.w   #-15A1h, 8[r14]
FFEE114F  fbee008108                        mov.l   #88100h, r14
FFEE1154  f0e0                              bset    #0, [r14].b
FFEE1156  fbee877008                        mov.l   #87087h, r14
FFEE115B  f2ef8901                          bclr    #7, 189h[r14].b
FFEE115F  fbee877008                        mov.l   #87087h, r14
FFEE1164  fae400070f                        mov.b   #0Fh, 700h[r14]
FFEE1169  fbee877008                        mov.l   #87087h, r14
FFEE116E  5aef0003                          movu.b  300h[r14], r15
FFEE1172  781f                              bset    #1, r15
FFEE1174  762ff200                          and     #0F2h, r15
FFEE1178  cbef0003                          mov.b   r15, 300h[r14]
FFEE117C  fbee877008                        mov.l   #87087h, r14
FFEE1181  f0e8                              bclr    #0, [r14].b
FFEE1183  fbee877008                        mov.l   #87087h, r14
FFEE1188  f2e78901                          bset    #7, 189h[r14].b
FFEE118C  02                                rts
FFEE118D  6040                     sub_FFEE118D sub     #4, sp  ; <<< FUNC sub_FFEE118D
FFEE118F  fbe2d4240100                      mov.l   #124D4h, r14
FFEE1195  d4e001                            mov.w   [r14], 4+var_2[sp]
FFEE1198  9809                              mov.w   4+var_2[sp], r1
FFEE119A  5f11                              movu.w  r1, r1
FFEE119C  6701                              rtsd    #1
FFEE119E  fbe2d4240100             sub_FFEE119E mov.l   #124D4h, r14  ; <<< FUNC sub_FFEE119E
FFEE11A4  5cee                              movu.w  [r14], r14
FFEE11A6  610e                              cmp     #0, r14
FFEE11A8  200f                              beq.b   loc_FFEE11B7
FFEE11AA  fbe2d4240100                      mov.l   #124D4h, r14
FFEE11B0  dcef                              mov.w   [r14], r15
FFEE11B2  601f                              sub     #1, r15
FFEE11B4  d3ef                              mov.w   r15, [r14]
FFEE11B6  02                                rts
FFEE11B7  02                       loc_FFEE11B7 rts
FFEE11B8  6eef                     loc_FFEE11B8 pushm   r14-r15
FFEE11BA  6e15                              pushm   r1-r5
FFEE11BC  7fa8                              setpsw  i
FFEE11BE  fb1e158108                        mov.l   #88115h, r1
FFEE11C3  f410                              btst    #0, [r1].b
FFEE11C5  10                                beq.s   loc_FFEE11CD
FFEE11C6  fb1e158108                        mov.l   #88115h, r1
FFEE11CB  f018                              bclr    #0, [r1].b
FFEE11CD  fb12d4240100             loc_FFEE11CD mov.l   #124D4h, r1
FFEE11D3  dc12                              mov.w   [r1], r2
FFEE11D5  6212                              add     #1, r2
FFEE11D7  d312                              mov.w   r2, [r1]
FFEE11D9  05d25a05                          bsr.a   sub_FFF36CAB
FFEE11DD  6f15                              popm    r1-r5
FFEE11DF  6fef                              popm    r14-r15
FFEE11E1  7f95                              rte
FFEE11E3  6040                     loc_FFEE11E3 sub     #4, sp
FFEE11E5  f80600                            mov.l   #0, [sp]
FFEE11E8  2e35                              bra.b   loc_FFEE121D
FFEE11EA  ec01                     loc_FFEE11EA mov.l   [sp], r1
FFEE11EC  63c1                              mul     #0Ch, r1
FFEE11EE  fbe2e4cd0100                      mov.l   #1CDE4h, r14
FFEE11F4  4b1e                              add     r1, r14
FFEE11F6  f8e500                            mov.w   #0, [r14]
FFEE11F9  ec01                              mov.l   [sp], r1
FFEE11FB  63c1                              mul     #0Ch, r1
FFEE11FD  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE1203  4b12                              add     r1, r2
FFEE1205  3e2100                            mov.l   #0, 4[r2]
FFEE1208  ec01                              mov.l   [sp], r1
FFEE120A  63c1                              mul     #0Ch, r1
FFEE120C  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE1212  4b12                              add     r1, r2
FFEE1214  3e2200                            mov.l   #0, 8[r2]
FFEE1217  ec01                              mov.l   [sp], r1
FFEE1219  6211                              add     #1, r1
FFEE121B  e301                              mov.l   r1, [sp]
FFEE121D  ec01                     loc_FFEE121D mov.l   [sp], r1
FFEE121F  6141                              cmp     #4, r1
FFEE1221  29c9                              blt.b   loc_FFEE11EA
FFEE1223  05e2feff                          bsr.a   sub_FFEE1105
FFEE1227  6701                              rtsd    #1
FFEE1229  7100e8                   loc_FFEE1229 add     #-18h, sp, sp
FFEE122C  9289                              mov.w   r1, 16h[sp]
FFEE122E  a102                              mov.l   r2, 10h[sp]
FFEE1230  a08b                              mov.l   r3, 0Ch[sp]
FFEE1232  3e0100                            mov.l   #0, 4[sp]
FFEE1235  2e1a                              bra.b   loc_FFEE124F
FFEE1237  a809                     loc_FFEE1237 mov.l   4[sp], r1
FFEE1239  63c1                              mul     #0Ch, r1
FFEE123B  fbe2e4cd0100                      mov.l   #1CDE4h, r14
FFEE1241  4b1e                              add     r1, r14
FFEE1243  5cee                              movu.w  [r14], r14
FFEE1245  610e                              cmp     #0, r14
FFEE1247  200e                              beq.b   loc_FFEE1255
FFEE1249  a809                              mov.l   4[sp], r1
FFEE124B  6211                              add     #1, r1
FFEE124D  a009                              mov.l   r1, 4[sp]
FFEE124F  a809                     loc_FFEE124F mov.l   4[sp], r1
FFEE1251  6141                              cmp     #4, r1
FFEE1253  29e4                              blt.b   loc_FFEE1237
FFEE1255  a809                     loc_FFEE1255 mov.l   4[sp], r1
FFEE1257  6141                              cmp     #4, r1
FFEE1259  204d                              beq.b   loc_FFEE12A6
FFEE125B  a809                              mov.l   4[sp], r1
FFEE125D  63c1                              mul     #0Ch, r1
FFEE125F  fbe2e4cd0100                      mov.l   #1CDE4h, r14
FFEE1265  4b1e                              add     r1, r14
FFEE1267  d10e0b                            mov.w   16h[sp], [r14]
FFEE126A  a809                              mov.l   4[sp], r1
FFEE126C  63c1                              mul     #0Ch, r1
FFEE126E  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE1274  4b12                              add     r1, r2
FFEE1276  e5020401                          mov.l   10h[sp], 4[r2]
FFEE127A  a809                              mov.l   4[sp], r1
FFEE127C  63c1                              mul     #0Ch, r1
FFEE127E  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE1284  4b12                              add     r1, r2
FFEE1286  e5020302                          mov.l   0Ch[sp], 8[r2]
FFEE128A  3d0100                            mov.w   #0, 2[sp]
FFEE128D  2e11                              bra.b   loc_FFEE129E
FFEE128F  660e                     loc_FFEE128F mov.l   #0, r14
FFEE1291  b809                              movu.w  2[sp], r1
FFEE1293  a902                              mov.l   10h[sp], r2
FFEE1295  fe112e                            mov.w   r14, [r1, r2]
FFEE1298  9809                              mov.w   2[sp], r1
FFEE129A  6211                              add     #1, r1
FFEE129C  9009                              mov.w   r1, 2[sp]
FFEE129E  b809                     loc_FFEE129E movu.w  2[sp], r1
FFEE12A0  06c5010b                          cmp     16h[sp].uw, r1
FFEE12A4  29eb                              blt.b   loc_FFEE128F
FFEE12A6  a809                     loc_FFEE12A6 mov.l   4[sp], r1
FFEE12A8  a081                              mov.l   r1, 8[sp]
FFEE12AA  6706                              rtsd    #6
FFEE12AC  6080                     loc_FFEE12AC sub     #8, sp
FFEE12AE  a009                              mov.l   r1, 4[sp]
FFEE12B0  900a                              mov.w   r2, 2[sp]
FFEE12B2  a809                              mov.l   4[sp], r1
FFEE12B4  6131                              cmp     #3, r1
FFEE12B6  2a2f                              bgt.b   loc_FFEE12E5
FFEE12B8  a809                              mov.l   4[sp], r1
FFEE12BA  63c1                              mul     #0Ch, r1
FFEE12BC  fbe2e4cd0100                      mov.l   #1CDE4h, r14
FFEE12C2  4b1e                              add     r1, r14
FFEE12C4  b809                              movu.w  2[sp], r1
FFEE12C6  06c4e1                            cmp     [r14].uw, r1
FFEE12C9  281c                              bge.b   loc_FFEE12E5
FFEE12CB  a809                              mov.l   4[sp], r1
FFEE12CD  63c1                              mul     #0Ch, r1
FFEE12CF  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE12D5  4b12                              add     r1, r2
FFEE12D7  a8a1                              mov.l   8[r2], r1
FFEE12D9  b80b                              movu.w  2[sp], r3
FFEE12DB  fe531e                            mov.w   [r3, r1], r14
FFEE12DE  a829                              mov.l   4[r2], r1
FFEE12E0  fe131e                            mov.w   r14, [r3, r1]
FFEE12E3  6702                              rtsd    #2
FFEE12E5  6702                     loc_FFEE12E5 rtsd    #2
FFEE12E7  6080                     sub_FFEE12E7 sub     #8, sp  ; <<< FUNC sub_FFEE12E7
FFEE12E9  a009                              mov.l   r1, 8+var_4[sp]
FFEE12EB  900a                              mov.w   r2, 8+var_6[sp]
FFEE12ED  a809                              mov.l   8+var_4[sp], r1
FFEE12EF  6131                              cmp     #3, r1
FFEE12F1  2a2c                              bgt.b   loc_FFEE131D
FFEE12F3  a809                              mov.l   8+var_4[sp], r1
FFEE12F5  63c1                              mul     #0Ch, r1
FFEE12F7  fbe2e4cd0100                      mov.l   #1CDE4h, r14
FFEE12FD  4b1e                              add     r1, r14
FFEE12FF  b809                              movu.w  8+var_6[sp], r1
FFEE1301  06c4e1                            cmp     [r14].uw, r1
FFEE1304  2819                              bge.b   loc_FFEE131D
FFEE1306  a809                              mov.l   8+var_4[sp], r1
FFEE1308  63c1                              mul     #0Ch, r1
FFEE130A  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE1310  4b12                              add     r1, r2
FFEE1312  a829                              mov.l   4[r2], r1
FFEE1314  660e                              mov.l   #0, r14
FFEE1316  b80a                              movu.w  8+var_6[sp], r2
FFEE1318  fe121e                            mov.w   r14, [r2, r1]
FFEE131B  6702                              rtsd    #2
FFEE131D  6702                     loc_FFEE131D rtsd    #2
FFEE131F  6080                     loc_FFEE131F sub     #8, sp
FFEE1321  056cfeff                 loc_FFEE1321 bsr.a   sub_FFEE118D
FFEE1325  6101                              cmp     #0, r1
FFEE1327  20fa                              beq.b   loc_FFEE1321
FFEE1329  3e0100                   loc_FFEE1329 mov.l   #0, 4[sp]
FFEE132C  2e53                              bra.b   loc_FFEE137F
FFEE132E  3d0100                   loc_FFEE132E mov.w   #0, 2[sp]
FFEE1331  2e35                              bra.b   loc_FFEE1366
FFEE1333  63c1                     loc_FFEE1333 mul     #0Ch, r1
FFEE1335  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE133B  4b12                              add     r1, r2
FFEE133D  a829                              mov.l   4[r2], r1
FFEE133F  b80a                              movu.w  2[sp], r2
FFEE1341  fed21e                            movu.w  [r2, r1], r14
FFEE1344  610e                              cmp     #0, r14
FFEE1346  201a                              beq.b   loc_FFEE1360
FFEE1348  a809                              mov.l   4[sp], r1
FFEE134A  63c1                              mul     #0Ch, r1
FFEE134C  fb22e4cd0100                      mov.l   #1CDE4h, r2
FFEE1352  4b12                              add     r1, r2
FFEE1354  a829                              mov.l   4[r2], r1
FFEE1356  b80a                              movu.w  2[sp], r2
FFEE1358  fe521e                            mov.w   [r2, r1], r14
FFEE135B  601e                              sub     #1, r14
FFEE135D  fe121e                            mov.w   r14, [r2, r1]
FFEE1360  9809                     loc_FFEE1360 mov.w   2[sp], r1
FFEE1362  6211                              add     #1, r1
FFEE1364  9009                              mov.w   r1, 2[sp]
FFEE1366  a809                     loc_FFEE1366 mov.l   4[sp], r1
FFEE1368  ef1e                              mov.l   r1, r14
FFEE136A  63ce                              mul     #0Ch, r14
FFEE136C  fbf2e4cd0100                      mov.l   #1CDE4h, r15
FFEE1372  4bef                              add     r14, r15
FFEE1374  b80a                              movu.w  2[sp], r2
FFEE1376  06c4f2                            cmp     [r15].uw, r2
FFEE1379  29ba                              blt.b   loc_FFEE1333
FFEE137B  6211                              add     #1, r1
FFEE137D  a009                              mov.l   r1, 4[sp]
FFEE137F  a809                     loc_FFEE137F mov.l   4[sp], r1
FFEE1381  6141                              cmp     #4, r1
FFEE1383  29ab                              blt.b   loc_FFEE132E
FFEE1385  0519feff                          bsr.a   sub_FFEE119E
FFEE1389  0504feff                          bsr.a   sub_FFEE118D
FFEE138D  6101                              cmp     #0, r1
FFEE138F  219a                              bne.b   loc_FFEE1329
FFEE1391  6702                              rtsd    #2
FFEE1393  fbee100008               loc_FFEE1393 mov.l   #80010h, r14
FFEE1398  fae9f70102a5                      mov.w   #-5AFEh, 3EEh[r14]
FFEE139E  fbee100008                        mov.l   #80010h, r14
FFEE13A3  ecef                              mov.l   [r14], r15
FFEE13A5  7b0f                              bclr    #10h, r15
FFEE13A7  e3ef                              mov.l   r15, [r14]
FFEE13A9  fbee100008                        mov.l   #80010h, r14
FFEE13AE  fae9f70100a5                      mov.w   #-5B00h, 3EEh[r14]
FFEE13B4  fbee60c008                        mov.l   #8C060h, r14
FFEE13B9  f0e8                              bclr    #0, [r14].b
FFEE13BB  fbee60c008                        mov.l   #8C060h, r14
FFEE13C0  f0e9                              bclr    #1, [r14].b
FFEE13C2  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13C7  f0ef                              bclr    #7, [r14].b
FFEE13C9  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13CE  f0e6                              bset    #6, [r14].b
FFEE13D0  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13D5  f1e721                            bset    #7, 21h[r14].b
FFEE13D8  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13DD  f1e722                            bset    #7, 22h[r14].b
FFEE13E0  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13E5  f0ee                              bclr    #6, [r14].b
FFEE13E7  fbee1fc108                        mov.l   #8C11Fh, r14
FFEE13EC  f0e7                              bset    #7, [r14].b
FFEE13EE  fbee009108                        mov.l   #89100h, r14
FFEE13F3  f8e500                            mov.w   #0, [r14]
FFEE13F6  fb1e009108                        mov.l   #89100h, r1
FFEE13FB  3d1200                            mov.w   #0, 4[r1]
FFEE13FE  fb1e009108                        mov.l   #89100h, r1
FFEE1403  3d130c                            mov.w   #0Ch, 6[r1]
FFEE1406  fb1e009108                        mov.l   #89100h, r1
FFEE140B  3d1400                            mov.w   #0, 8[r1]
FFEE140E  fb1e009108                        mov.l   #89100h, r1
FFEE1413  3d1500                            mov.w   #0, 0Ah[r1]
FFEE1416  fb1e009108                        mov.l   #89100h, r1
FFEE141B  b99a                              movu.w  0Eh[r1], r2
FFEE141D  7622ff7f                          and     #7FFFh, r2
FFEE1421  919a                              mov.w   r2, 0Eh[r1]
FFEE1423  fbee25c008                        mov.l   #8C025h, r14
FFEE1428  f0e6                              bset    #6, [r14].b
FFEE142A  fbee28c008                        mov.l   #8C028h, r14
FFEE142F  f0eb                              bclr    #3, [r14].b
FFEE1431  fbee25c008                        mov.l   #8C025h, r14
FFEE1436  f0e4                              bset    #4, [r14].b
FFEE1438  fbee25c008                        mov.l   #8C025h, r14
FFEE143D  f0ed                              bclr    #5, [r14].b
FFEE143F  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE1445  f8e404                            mov.b   #4, [r14]
FFEE1448  fbe2f98b0000                      mov.l   #8BF9h, r14
FFEE144E  f8e400                            mov.b   #0, [r14]
FFEE1451  fbe2fa8b0000                      mov.l   #8BFAh, r14
FFEE1457  f8e400                            mov.b   #0, [r14]
FFEE145A  395802                            bsr.w   sub_FFEE16B2
FFEE145D  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE1463  f8e401                            mov.b   #1, [r14]
FFEE1466  02                                rts
FFEE1467  6040                     loc_FFEE1467 sub     #4, sp
FFEE1469  e301                              mov.l   r1, [sp]
FFEE146B  fbe2ea240100                      mov.l   #124EAh, r14
FFEE1471  d0e1                              mov.w   [r14], [r1]
FFEE1473  ec01                              mov.l   [sp], r1
FFEE1475  fbe2ec240100                      mov.l   #124ECh, r14
FFEE147B  d4e101                            mov.w   [r14], 2[r1]
FFEE147E  6701                              rtsd    #1
FFEE1480  6040                     loc_FFEE1480 sub     #4, sp
FFEE1482  fbee009108                        mov.l   #89100h, r14
FFEE1487  dcef                              mov.w   [r14], r15
FFEE1489  78ff                              bset    #0Fh, r15
FFEE148B  d3ef                              mov.w   r15, [r14]
FFEE148D  fbee009108               loc_FFEE148D mov.l   #89100h, r14
FFEE1492  5cee                              movu.w  [r14], r14
FFEE1494  772e008000                        and     #8000h, r14
FFEE1499  68fe                              shlr    #0Fh, r14
FFEE149B  610e                              cmp     #0, r14
FFEE149D  21f0                              bne.b   loc_FFEE148D
FFEE149F  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE14A5  58ee                              movu.b  [r14], r14
FFEE14A7  613e                              cmp     #3, r14
FFEE14A9  3a8301                            beq.w   loc_FFEE162C
FFEE14AC  612e                              cmp     #2, r14
FFEE14AE  3a0201                            beq.w   loc_FFEE15B0
FFEE14B1  611e                              cmp     #1, r14
FFEE14B3  3bfd01                            bne.w   loc_FFEE16B0
FFEE14B6  fbee009108                        mov.l   #89100h, r14
FFEE14BB  d5e02201                          mov.w   44h[r14], 2[sp]
FFEE14BF  b809                              movu.w  2[sp], r1
FFEE14C1  7601f00a                          cmp     #0AF0h, r1
FFEE14C5  2805                              bge.b   loc_FFEE14CA
FFEE14C7  38a700                            bra.w   loc_FFEE156E
FFEE14CA  fbe2fa8b0000             loc_FFEE14CA mov.l   #8BFAh, r14
FFEE14D0  58ee                              movu.b  [r14], r14
FFEE14D2  611e                              cmp     #1, r14
FFEE14D4  2173                              bne.b   loc_FFEE1547
FFEE14D6  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE14DC  58ee                              movu.b  [r14], r14
FFEE14DE  6c2e                              shll    #2, r14
FFEE14E0  fbf2d6240100                      mov.l   #124D6h, r15
FFEE14E6  4bef                              add     r14, r15
FFEE14E8  fbe2e6240100                      mov.l   #124E6h, r14
FFEE14EE  d0ef                              mov.w   [r14], [r15]
FFEE14F0  d5ef0101                          mov.w   2[r14], 2[r15]
FFEE14F4  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE14FA  58ef                              movu.b  [r14], r15
FFEE14FC  621f                              add     #1, r15
FFEE14FE  c3ef                              mov.b   r15, [r14]
FFEE1500  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE1506  58ef                              movu.b  [r14], r15
FFEE1508  643f                              and     #3, r15
FFEE150A  c3ef                              mov.b   r15, [r14]
FFEE150C  fbe2fa8b0000                      mov.l   #8BFAh, r14
FFEE1512  f8e400                            mov.b   #0, [r14]
FFEE1515  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE151B  58ee                              movu.b  [r14], r14
FFEE151D  610e                              cmp     #0, r14
FFEE151F  2028                              beq.b   loc_FFEE1547
FFEE1521  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE1527  58ef                              movu.b  [r14], r15
FFEE1529  601f                              sub     #1, r15
FFEE152B  c3ef                              mov.b   r15, [r14]
FFEE152D  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE1533  58ee                              movu.b  [r14], r14
FFEE1535  610e                              cmp     #0, r14
FFEE1537  2110                              bne.b   loc_FFEE1547
FFEE1539  6611                              mov.l   #1, r1
FFEE153B  39b301                            bsr.w   sub_FFEE16EE
FFEE153E  fbe2f98b0000                      mov.l   #8BF9h, r14
FFEE1544  f8e404                            mov.b   #4, [r14]
FFEE1547  fbee25c008               loc_FFEE1547 mov.l   #8C025h, r14
FFEE154C  f0ee                              bclr    #6, [r14].b
FFEE154E  fbee28c008                        mov.l   #8C028h, r14
FFEE1553  f0e3                              bset    #3, [r14].b
FFEE1555  fbee25c008                        mov.l   #8C025h, r14
FFEE155A  f0e4                              bset    #4, [r14].b
FFEE155C  fbee25c008                        mov.l   #8C025h, r14
FFEE1561  f0ed                              bclr    #5, [r14].b
FFEE1563  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE1569  f8e402                            mov.b   #2, [r14]
FFEE156C  6701                              rtsd    #1
FFEE156E  fbe2f98b0000             loc_FFEE156E mov.l   #8BF9h, r14
FFEE1574  58ee                              movu.b  [r14], r14
FFEE1576  610e                              cmp     #0, r14
FFEE1578  3a3801                            beq.w   loc_FFEE16B0
FFEE157B  fbe2f98b0000                      mov.l   #8BF9h, r14
FFEE1581  58ef                              movu.b  [r14], r15
FFEE1583  601f                              sub     #1, r15
FFEE1585  c3ef                              mov.b   r15, [r14]
FFEE1587  fbe2f98b0000                      mov.l   #8BF9h, r14
FFEE158D  58ee                              movu.b  [r14], r14
FFEE158F  610e                              cmp     #0, r14
FFEE1591  3b1f01                            bne.w   loc_FFEE16B0
FFEE1594  fbe2f88b0000                      mov.l   #8BF8h, r14
FFEE159A  f8e404                            mov.b   #4, [r14]
FFEE159D  6601                              mov.l   #0, r1
FFEE159F  394f01                            bsr.w   sub_FFEE16EE
FFEE15A2  391001                            bsr.w   sub_FFEE16B2
FFEE15A5  fbe2fa8b0000                      mov.l   #8BFAh, r14
FFEE15AB  f8e400                            mov.b   #0, [r14]
FFEE15AE  6701                              rtsd    #1
FFEE15B0  fbee009108               loc_FFEE15B0 mov.l   #89100h, r14
FFEE15B5  d5e02201                          mov.w   44h[r14], 2[sp]
FFEE15B9  b809                              movu.w  2[sp], r1
FFEE15BB  755181                            cmp     #-7Fh, r1
FFEE15BE  2a07                              bgt.b   loc_FFEE15C5
FFEE15C0  3d0100                            mov.w   #0, 2[sp]
FFEE15C3  2e2f                              bra.b   loc_FFEE15F2
FFEE15C5  b809                     loc_FFEE15C5 movu.w  2[sp], r1
FFEE15C7  7601e703                          cmp     #3E7h, r1
FFEE15CB  2a0a                              bgt.b   loc_FFEE15D5
FFEE15CD  72117eff                          add     #-82h, r1, r1
FFEE15D1  9009                              mov.w   r1, 2[sp]
FFEE15D3  2e1f                              bra.b   loc_FFEE15F2
FFEE15D5  7601000f                 loc_FFEE15D5 cmp     #0F00h, r1
FFEE15D9  2909                              blt.b   loc_FFEE15E2
FFEE15DB  f90901ff0f                        mov.w   #0FFFh, 2[sp]
FFEE15E0  2e12                              bra.b   loc_FFEE15F2
FFEE15E2  b809                     loc_FFEE15E2 movu.w  2[sp], r1
FFEE15E4  7601b90b                          cmp     #0BB9h, r1
FFEE15E8  290a                              blt.b   loc_FFEE15F2
FFEE15EA  b809                              movu.w  2[sp], r1
FFEE15EC  72110001                          add     #100h, r1, r1
FFEE15F0  9009                              mov.w   r1, 2[sp]
FFEE15F2  b809                     loc_FFEE15F2 movu.w  2[sp], r1
FFEE15F4  76114001                          mul     #140h, r1
FFEE15F8  fd7891ff0f                        divu    #0FFFh, r1
FFEE15FD  fbe2e6240100                      mov.l   #124E6h, r14
FFEE1603  d3e1                              mov.w   r1, [r14]
FFEE1605  fbee25c008                        mov.l   #8C025h, r14
FFEE160A  f0ee                              bclr    #6, [r14].b
FFEE160C  fbee28c008                        mov.l   #8C028h, r14
FFEE1611  f0eb                              bclr    #3, [r14].b
FFEE1613  fbee25c008                        mov.l   #8C025h, r14
FFEE1618  f0ec                              bclr    #4, [r14].b
FFEE161A  fbee25c008                        mov.l   #8C025h, r14
FFEE161F  f0e5                              bset    #5, [r14].b
FFEE1621  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE1627  f8e403                            mov.b   #3, [r14]
FFEE162A  6701                              rtsd    #1
FFEE162C  fbee009108               loc_FFEE162C mov.l   #89100h, r14
FFEE1631  d5e02301                          mov.w   46h[r14], 2[sp]
FFEE1635  b809                              movu.w  2[sp], r1
FFEE1637  755177                            cmp     #77h, r1 ; 'w'
FFEE163A  2a07                              bgt.b   loc_FFEE1641
FFEE163C  3d0100                            mov.w   #0, 2[sp]
FFEE163F  2e2e                              bra.b   loc_FFEE166D
FFEE1641  b809                     loc_FFEE1641 movu.w  2[sp], r1
FFEE1643  7601e703                          cmp     #3E7h, r1
FFEE1647  2a09                              bgt.b   loc_FFEE1650
FFEE1649  711188                            add     #-78h, r1, r1
FFEE164C  9009                              mov.w   r1, 2[sp]
FFEE164E  2e1f                              bra.b   loc_FFEE166D
FFEE1650  7601ec0e                 loc_FFEE1650 cmp     #0EECh, r1
FFEE1654  2909                              blt.b   loc_FFEE165D
FFEE1656  f90901ff0f                        mov.w   #0FFFh, 2[sp]
FFEE165B  2e12                              bra.b   loc_FFEE166D
FFEE165D  b809                     loc_FFEE165D movu.w  2[sp], r1
FFEE165F  7601b90b                          cmp     #0BB9h, r1
FFEE1663  290a                              blt.b   loc_FFEE166D
FFEE1665  b809                              movu.w  2[sp], r1
FFEE1667  72111401                          add     #114h, r1, r1
FFEE166B  9009                              mov.w   r1, 2[sp]
FFEE166D  b809                     loc_FFEE166D movu.w  2[sp], r1
FFEE166F  7611f000                          mul     #0F0h, r1
FFEE1673  fd7891ff0f                        divu    #0FFFh, r1
FFEE1678  fb22e6240100                      mov.l   #124E6h, r2
FFEE167E  9029                              mov.w   r1, 2[r2]
FFEE1680  fbe2fa8b0000                      mov.l   #8BFAh, r14
FFEE1686  f8e401                            mov.b   #1, [r14]
FFEE1689  fbee25c008                        mov.l   #8C025h, r14
FFEE168E  f0e6                              bset    #6, [r14].b
FFEE1690  fbee28c008                        mov.l   #8C028h, r14
FFEE1695  f0eb                              bclr    #3, [r14].b
FFEE1697  fbee25c008                        mov.l   #8C025h, r14
FFEE169C  f0e4                              bset    #4, [r14].b
FFEE169E  fbee25c008                        mov.l   #8C025h, r14
FFEE16A3  f0ed                              bclr    #5, [r14].b
FFEE16A5  fbe2f68b0000                      mov.l   #8BF6h, r14
FFEE16AB  f8e401                            mov.b   #1, [r14]
FFEE16AE  6701                              rtsd    #1
FFEE16B0  6701                     loc_FFEE16B0 rtsd    #1
FFEE16B2  6040                     sub_FFEE16B2 sub     #4, sp  ; <<< FUNC sub_FFEE16B2
FFEE16B4  fbe2f78b0000                      mov.l   #8BF7h, r14
FFEE16BA  f8e400                            mov.b   #0, [r14]
FFEE16BD  3c0300                            mov.b   #0, 4+var_1[sp]
FFEE16C0  2e26                              bra.b   loc_FFEE16E6
FFEE16C2  b089                     loc_FFEE16C2 movu.b  4+var_1[sp], r1
FFEE16C4  6c21                              shll    #2, r1
FFEE16C6  fbe2d6240100                      mov.l   #124D6h, r14
FFEE16CC  4b1e                              add     r1, r14
FFEE16CE  f8e500                            mov.w   #0, [r14]
FFEE16D1  b089                              movu.b  4+var_1[sp], r1
FFEE16D3  6c21                              shll    #2, r1
FFEE16D5  fb22d6240100                      mov.l   #124D6h, r2
FFEE16DB  4b12                              add     r1, r2
FFEE16DD  3d2100                            mov.w   #0, 2[r2]
FFEE16E0  b089                              movu.b  4+var_1[sp], r1
FFEE16E2  6211                              add     #1, r1
FFEE16E4  8089                              mov.b   r1, 4+var_1[sp]
FFEE16E6  b089                     loc_FFEE16E6 movu.b  4+var_1[sp], r1
FFEE16E8  6141                              cmp     #4, r1
FFEE16EA  29d8                              blt.b   loc_FFEE16C2
FFEE16EC  6701                              rtsd    #1
FFEE16EE  6080                     sub_FFEE16EE sub     #8, sp  ; <<< FUNC sub_FFEE16EE
FFEE16F0  8189                              mov.b   r1, 8+var_1[sp]
FFEE16F2  3d0100                            mov.w   #0, 8+var_6[sp]
FFEE16F5  3d0200                            mov.w   #0, 8+var_4[sp]
FFEE16F8  fbe2ec240100                      mov.l   #124ECh, r14
FFEE16FE  f8e500                            mov.w   #0, [r14]
FFEE1701  fbf2ea240100                      mov.l   #124EAh, r15
FFEE1707  d0ef                              mov.w   [r14], [r15]
FFEE1709  3c0100                            mov.b   #0, 8+var_7[sp]
FFEE170C  2e30                              bra.b   loc_FFEE173C
FFEE170E  b009                     loc_FFEE170E movu.b  8+var_7[sp], r1
FFEE1710  6c21                              shll    #2, r1
FFEE1712  fbe2d6240100                      mov.l   #124D6h, r14
FFEE1718  4b1e                              add     r1, r14
FFEE171A  5ce1                              movu.w  [r14], r1
FFEE171C  06c90101                          add     8+var_6[sp].uw, r1
FFEE1720  9009                              mov.w   r1, 8+var_6[sp]
FFEE1722  b009                              movu.b  8+var_7[sp], r1
FFEE1724  6c21                              shll    #2, r1
FFEE1726  fb22d6240100                      mov.l   #124D6h, r2
FFEE172C  4b12                              add     r1, r2
FFEE172E  b829                              movu.w  2[r2], r1
FFEE1730  06c90102                          add     8+var_4[sp].uw, r1
FFEE1734  9081                              mov.w   r1, 8+var_4[sp]
FFEE1736  b009                              movu.b  8+var_7[sp], r1
FFEE1738  6211                              add     #1, r1
FFEE173A  8009                              mov.b   r1, 8+var_7[sp]
FFEE173C  b009                     loc_FFEE173C movu.b  8+var_7[sp], r1
FFEE173E  6141                              cmp     #4, r1
FFEE1740  29ce                              blt.b   loc_FFEE170E
FFEE1742  b809                              movu.w  8+var_6[sp], r1
FFEE1744  6821                              shlr    #2, r1
FFEE1746  9009                              mov.w   r1, 8+var_6[sp]
FFEE1748  b881                              movu.w  8+var_4[sp], r1
FFEE174A  6821                              shlr    #2, r1
FFEE174C  9081                              mov.w   r1, 8+var_4[sp]
FFEE174E  fb1a4001                          mov.l   #140h, r1
FFEE1752  06c10101                          sub     8+var_6[sp].uw, r1
FFEE1756  9009                              mov.w   r1, 8+var_6[sp]
FFEE1758  7541f0                            mov.l   #-10h, r1
FFEE175B  06c10102                          sub     8+var_4[sp].uw, r1
FFEE175F  9081                              mov.w   r1, 8+var_4[sp]
FFEE1761  fbe2ea240100                      mov.l   #124EAh, r14
FFEE1767  d10e01                            mov.w   8+var_6[sp], [r14]
FFEE176A  fbe2ec240100                      mov.l   #124ECh, r14
FFEE1770  d10e02                            mov.w   8+var_4[sp], [r14]
FFEE1773  b883                              movu.w  8+var_4[sp], r3
FFEE1775  b80a                              movu.w  8+var_6[sp], r2
FFEE1777  b189                              movu.b  8+var_1[sp], r1
FFEE1779  0544acff                          bsr.a   sub_FFEDC3BD
FFEE177D  6702                              rtsd    #2
FFEE177F  02                                rts

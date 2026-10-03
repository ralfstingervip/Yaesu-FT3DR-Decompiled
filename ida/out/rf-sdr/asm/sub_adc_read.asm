; window adc_read file 315600-315A80 map FFF15600-FFF15A80 forced 373
; ==== adc_read  FFF15600-FFF15A80 ====
FFF15600  09                                bra.s   loc_FFF15608+1
FFF15601  6101                              cmp     #0, r1
FFF15603  17                                beq.s   loc_FFF1560A
FFF15604  a90a                              mov.l   14h[sp], r2
FFF15606  6611                              mov.l   #1, r1
FFF15608  7f12                     loc_FFF15608 jsr     r2
FFF1560A  fb1278020200             loc_FFF1560A mov.l   #20278h, r1
FFF15610  ed1143                            mov.l   10Ch[r1], r1
FFF15613  05bd1f02                          bsr.a   sub_FFF375D0
FFF15617  710020                            add     #20h, sp, sp ; ' '
FFF1561A  6f15                              popm    r1-r5
FFF1561C  6fef                              popm    r14-r15
FFF1561E  7f95                              rte
FFF15620  fb2278020200             loc_FFF15620 mov.l   #20278h, r2
FFF15626  06852142                          cmp     108h[r2].l, r1
FFF1562A  2215                              bgeu.b  loc_FFF1563F
FFF1562C  fb1278020200                      mov.l   #20278h, r1
FFF15632  f9158a01                          mov.w   #1, 114h[r1]
FFF15636  710020                            add     #20h, sp, sp ; ' '
FFF15639  6f15                              popm    r1-r5
FFF1563B  6fef                              popm    r14-r15
FFF1563D  7f95                              rte
FFF1563F  710020                   loc_FFF1563F add     #20h, sp, sp ; ' '
FFF15642  6f15                              popm    r1-r5
FFF15644  6fef                              popm    r14-r15
FFF15646  7f95                              rte
FFF15648  fbee009008               loc_FFF15648 mov.l   #89000h, r14
FFF1564D  5cef                              movu.w  [r14], r15
FFF1564F  772fffef00                        and     #0EFFFh, r15
FFF15654  d3ef                              mov.w   r15, [r14]
FFF15656  fbee009008                        mov.l   #89000h, r14
FFF1565B  5cef                              movu.w  [r14], r15
FFF1565D  772fbfff00                        and     #0FFBFh, r15
FFF15662  d3ef                              mov.w   r15, [r14]
FFF15664  fbee009008                        mov.l   #89000h, r14
FFF15669  f1ef90                            bclr    #7, 90h[r14].b
FFF1566C  fbee107208                        mov.l   #87210h, r14
FFF15671  f0ee                              bclr    #6, [r14].b
FFF15673  fbee009008                        mov.l   #89000h, r14
FFF15678  f9e47a00                          mov.b   #0, 7Ah[r14]
FFF1567C  fbee009008                        mov.l   #89000h, r14
FFF15681  f8e90012                          mov.w   #1200h, [r14]
FFF15685  fb1e009008                        mov.l   #89000h, r1
FFF1568A  3d1700                            mov.w   #0, 0Eh[r1]
FFF1568D  fb1e009008                        mov.l   #89000h, r1
FFF15692  3c1c00                            mov.b   #0, 0Ch[r1]
FFF15695  fb1e009008                        mov.l   #89000h, r1
FFF1569A  3d1207                            mov.w   #7, 4[r1]
FFF1569D  fb1e009008                        mov.l   #89000h, r1
FFF156A2  3d1400                            mov.w   #0, 8[r1]
FFF156A5  fbee009008                        mov.l   #89000h, r14
FFF156AA  f9e460b0                          mov.b   #-50h, 60h[r14]
FFF156AE  fbee009008                        mov.l   #89000h, r14
FFF156B3  f9e473b0                          mov.b   #-50h, 73h[r14]
FFF156B7  fbee009008                        mov.l   #89000h, r14
FFF156BC  f9e474b0                          mov.b   #-50h, 74h[r14]
FFF156C0  fbee009008                        mov.l   #89000h, r14
FFF156C5  f9e49080                          mov.b   #-80h, 90h[r14]
FFF156C9  fbee009008                        mov.l   #89000h, r14
FFF156CE  f9e54a00                          mov.w   #0, 94h[r14]
FFF156D2  fbee009008                        mov.l   #89000h, r14
FFF156D7  f9e54c00                          mov.w   #0, 98h[r14]
FFF156DB  fbee009008                        mov.l   #89000h, r14
FFF156E0  f9e54e00                          mov.w   #0, 9Ch[r14]
FFF156E4  fbee009008                        mov.l   #89000h, r14
FFF156E9  f9e9080006                        mov.w   #600h, 10h[r14]
FFF156EE  fbee107208                        mov.l   #87210h, r14
FFF156F3  fae4760540                        mov.b   #40h, 576h[r14] ; '@'
FFF156F8  fbee107208                        mov.l   #87210h, r14
FFF156FD  5aef7601                          movu.b  176h[r14], r15
FFF15701  65ff                              or      #0Fh, r15
FFF15703  cbef7601                          mov.b   r15, 176h[r14]
FFF15707  fbee1fc108                        mov.l   #8C11Fh, r14
FFF1570C  f0ef                              bclr    #7, [r14].b
FFF1570E  fbee1fc108                        mov.l   #8C11Fh, r14
FFF15713  f0e6                              bset    #6, [r14].b
FFF15715  fbee64c008                        mov.l   #8C064h, r14
FFF1571A  f0e8                              bclr    #0, [r14].b
FFF1571C  fbee04c008                        mov.l   #8C004h, r14
FFF15721  f0e8                              bclr    #0, [r14].b
FFF15723  fbee1fc108                        mov.l   #8C11Fh, r14
FFF15728  f1e741                            bset    #7, 41h[r14].b
FFF1572B  fbee64c008                        mov.l   #8C064h, r14
FFF15730  f0e9                              bclr    #1, [r14].b
FFF15732  fbee04c008                        mov.l   #8C004h, r14
FFF15737  f0e9                              bclr    #1, [r14].b
FFF15739  fbee1fc108                        mov.l   #8C11Fh, r14
FFF1573E  f1e742                            bset    #7, 42h[r14].b
FFF15741  fbee64c008                        mov.l   #8C064h, r14
FFF15746  f0ea                              bclr    #2, [r14].b
FFF15748  fbee04c008                        mov.l   #8C004h, r14
FFF1574D  f0ea                              bclr    #2, [r14].b
FFF1574F  fbee1fc108                        mov.l   #8C11Fh, r14
FFF15754  f1e743                            bset    #7, 43h[r14].b
FFF15757  fbee1fc108                        mov.l   #8C11Fh, r14
FFF1575C  f0ee                              bclr    #6, [r14].b
FFF1575E  fbee1fc108                        mov.l   #8C11Fh, r14
FFF15763  f0e7                              bset    #7, [r14].b
FFF15765  02                                rts
FFF15766  fbe20a250100             loc_FFF15766 mov.l   #1250Ah, r14
FFF1576C  f8e501                            mov.w   #1, [r14]
FFF1576F  fbee867008                        mov.l   #87086h, r14
FFF15774  f0e8                              bclr    #0, [r14].b
FFF15776  fbee867008                        mov.l   #87086h, r14
FFF1577B  f2e68a01                          bset    #6, 18Ah[r14].b
FFF1577F  fbee867008                        mov.l   #87086h, r14
FFF15784  72eeee05                          add     #5EEh, r14, r14
FFF15788  ecef                              mov.l   [r14], r15
FFF1578A  794f                              bset    #14h, r15
FFF1578C  e3ef                              mov.l   r15, [r14]
FFF1578E  fbee009008                        mov.l   #89000h, r14
FFF15793  dcef                              mov.w   [r14], r15
FFF15795  78ff                              bset    #0Fh, r15
FFF15797  d3ef                              mov.w   r15, [r14]
FFF15799  02                                rts
FFF1579A  6040                     loc_FFF1579A sub     #4, sp
FFF1579C  fbe20a250100                      mov.l   #1250Ah, r14
FFF157A2  f8e500                            mov.w   #0, [r14]
FFF157A5  fbe20a250100                      mov.l   #1250Ah, r14
FFF157AB  5cee                              movu.w  [r14], r14
FFF157AD  610e                              cmp     #0, r14
FFF157AF  2111                              bne.b   loc_FFF157C0
FFF157B1  fb120a250100                      mov.l   #1250Ah, r1
FFF157B7  b819                              movu.w  2[r1], r1
FFF157B9  6101                              cmp     #0, r1
FFF157BB  1d                                bne.s   loc_FFF157C0
FFF157BC  f80601                            mov.l   #1, [sp]
FFF157BF  0c                                bra.s   loc_FFF157C3
FFF157C0  f80600                   loc_FFF157C0 mov.l   #0, [sp]
FFF157C3  ec01                     loc_FFF157C3 mov.l   [sp], r1
FFF157C5  6101                              cmp     #0, r1
FFF157C7  2011                              beq.b   loc_FFF157D8
FFF157C9  fb120a250100                      mov.l   #1250Ah, r1
FFF157CF  b891                              movu.w  4[r1], r1
FFF157D1  6101                              cmp     #0, r1
FFF157D3  1d                                bne.s   loc_FFF157D8
FFF157D4  f80601                            mov.l   #1, [sp]
FFF157D7  0c                                bra.s   loc_FFF157DB
FFF157D8  f80600                   loc_FFF157D8 mov.l   #0, [sp]
FFF157DB  ec01                     loc_FFF157DB mov.l   [sp], r1
FFF157DD  6101                              cmp     #0, r1
FFF157DF  2030                              beq.b   loc_FFF1580F
FFF157E1  fbee009008                        mov.l   #89000h, r14
FFF157E6  5cef                              movu.w  [r14], r15
FFF157E8  762fff7f                          and     #7FFFh, r15
FFF157EC  d3ef                              mov.w   r15, [r14]
FFF157EE  fbee867008                        mov.l   #87086h, r14
FFF157F3  f2ee8a01                          bclr    #6, 18Ah[r14].b
FFF157F7  fbee867008                        mov.l   #87086h, r14
FFF157FC  f0e8                              bclr    #0, [r14].b
FFF157FE  fbee867008                        mov.l   #87086h, r14
FFF15803  72eeee05                          add     #5EEh, r14, r14
FFF15807  ecef                              mov.l   [r14], r15
FFF15809  7b4f                              bclr    #14h, r15
FFF1580B  e3ef                              mov.l   r15, [r14]
FFF1580D  6701                              rtsd    #1
FFF1580F  6701                     loc_FFF1580F rtsd    #1
FFF15811  fb120a250100             loc_FFF15811 mov.l   #1250Ah, r1
FFF15817  3d1101                            mov.w   #1, 2[r1]
FFF1581A  fbee867008                        mov.l   #87086h, r14
FFF1581F  f0e8                              bclr    #0, [r14].b
FFF15821  fbee867008                        mov.l   #87086h, r14
FFF15826  f2e68a01                          bset    #6, 18Ah[r14].b
FFF1582A  fbee867008                        mov.l   #87086h, r14
FFF1582F  72eeee05                          add     #5EEh, r14, r14
FFF15833  ecef                              mov.l   [r14], r15
FFF15835  794f                              bset    #14h, r15
FFF15837  e3ef                              mov.l   r15, [r14]
FFF15839  fbee009008                        mov.l   #89000h, r14
FFF1583E  dcef                              mov.w   [r14], r15
FFF15840  78ff                              bset    #0Fh, r15
FFF15842  d3ef                              mov.w   r15, [r14]
FFF15844  02                                rts
FFF15845  6040                     loc_FFF15845 sub     #4, sp
FFF15847  fb120a250100                      mov.l   #1250Ah, r1
FFF1584D  3d1100                            mov.w   #0, 2[r1]
FFF15850  fbe20a250100                      mov.l   #1250Ah, r14
FFF15856  5cee                              movu.w  [r14], r14
FFF15858  610e                              cmp     #0, r14
FFF1585A  2111                              bne.b   loc_FFF1586B
FFF1585C  fb120a250100                      mov.l   #1250Ah, r1
FFF15862  b819                              movu.w  2[r1], r1
FFF15864  6101                              cmp     #0, r1
FFF15866  1d                                bne.s   loc_FFF1586B
FFF15867  f80601                            mov.l   #1, [sp]
FFF1586A  0c                                bra.s   loc_FFF1586E
FFF1586B  f80600                   loc_FFF1586B mov.l   #0, [sp]
FFF1586E  ec01                     loc_FFF1586E mov.l   [sp], r1
FFF15870  6101                              cmp     #0, r1
FFF15872  2011                              beq.b   loc_FFF15883
FFF15874  fb120a250100                      mov.l   #1250Ah, r1
FFF1587A  b891                              movu.w  4[r1], r1
FFF1587C  6101                              cmp     #0, r1
FFF1587E  1d                                bne.s   loc_FFF15883
FFF1587F  f80601                            mov.l   #1, [sp]
FFF15882  0c                                bra.s   loc_FFF15886
FFF15883  f80600                   loc_FFF15883 mov.l   #0, [sp]
FFF15886  ec01                     loc_FFF15886 mov.l   [sp], r1
FFF15888  6101                              cmp     #0, r1
FFF1588A  2030                              beq.b   loc_FFF158BA
FFF1588C  fbee009008                        mov.l   #89000h, r14
FFF15891  5cef                              movu.w  [r14], r15
FFF15893  762fff7f                          and     #7FFFh, r15
FFF15897  d3ef                              mov.w   r15, [r14]
FFF15899  fbee867008                        mov.l   #87086h, r14
FFF1589E  f2ee8a01                          bclr    #6, 18Ah[r14].b
FFF158A2  fbee867008                        mov.l   #87086h, r14
FFF158A7  f0e8                              bclr    #0, [r14].b
FFF158A9  fbee867008                        mov.l   #87086h, r14
FFF158AE  72eeee05                          add     #5EEh, r14, r14
FFF158B2  ecef                              mov.l   [r14], r15
FFF158B4  7b4f                              bclr    #14h, r15
FFF158B6  e3ef                              mov.l   r15, [r14]
FFF158B8  6701                              rtsd    #1
FFF158BA  6701                     loc_FFF158BA rtsd    #1
FFF158BC  fb120a250100             loc_FFF158BC mov.l   #1250Ah, r1
FFF158C2  3d1201                            mov.w   #1, 4[r1]
FFF158C5  fbee867008                        mov.l   #87086h, r14
FFF158CA  f0e8                              bclr    #0, [r14].b
FFF158CC  fbee867008                        mov.l   #87086h, r14
FFF158D1  f2e68a01                          bset    #6, 18Ah[r14].b
FFF158D5  fbee867008                        mov.l   #87086h, r14
FFF158DA  72eeee05                          add     #5EEh, r14, r14
FFF158DE  ecef                              mov.l   [r14], r15
FFF158E0  794f                              bset    #14h, r15
FFF158E2  e3ef                              mov.l   r15, [r14]
FFF158E4  fbee009008                        mov.l   #89000h, r14
FFF158E9  dcef                              mov.w   [r14], r15
FFF158EB  78ff                              bset    #0Fh, r15
FFF158ED  d3ef                              mov.w   r15, [r14]
FFF158EF  02                                rts
FFF158F0  6040                     loc_FFF158F0 sub     #4, sp
FFF158F2  fb120a250100                      mov.l   #1250Ah, r1
FFF158F8  3d1200                            mov.w   #0, 4[r1]
FFF158FB  fbe20a250100                      mov.l   #1250Ah, r14
FFF15901  5cee                              movu.w  [r14], r14
FFF15903  610e                              cmp     #0, r14
FFF15905  2111                              bne.b   loc_FFF15916
FFF15907  fb120a250100                      mov.l   #1250Ah, r1
FFF1590D  b819                              movu.w  2[r1], r1
FFF1590F  6101                              cmp     #0, r1
FFF15911  1d                                bne.s   loc_FFF15916
FFF15912  f80601                            mov.l   #1, [sp]
FFF15915  0c                                bra.s   loc_FFF15919
FFF15916  f80600                   loc_FFF15916 mov.l   #0, [sp]
FFF15919  ec01                     loc_FFF15919 mov.l   [sp], r1
FFF1591B  6101                              cmp     #0, r1
FFF1591D  2011                              beq.b   loc_FFF1592E
FFF1591F  fb120a250100                      mov.l   #1250Ah, r1
FFF15925  b891                              movu.w  4[r1], r1
FFF15927  6101                              cmp     #0, r1
FFF15929  1d                                bne.s   loc_FFF1592E
FFF1592A  f80601                            mov.l   #1, [sp]
FFF1592D  0c                                bra.s   loc_FFF15931
FFF1592E  f80600                   loc_FFF1592E mov.l   #0, [sp]
FFF15931  ec01                     loc_FFF15931 mov.l   [sp], r1
FFF15933  6101                              cmp     #0, r1
FFF15935  2030                              beq.b   loc_FFF15965
FFF15937  fbee009008                        mov.l   #89000h, r14
FFF1593C  5cef                              movu.w  [r14], r15
FFF1593E  762fff7f                          and     #7FFFh, r15
FFF15942  d3ef                              mov.w   r15, [r14]
FFF15944  fbee867008                        mov.l   #87086h, r14
FFF15949  f2ee8a01                          bclr    #6, 18Ah[r14].b
FFF1594D  fbee867008                        mov.l   #87086h, r14
FFF15952  f0e8                              bclr    #0, [r14].b
FFF15954  fbee867008                        mov.l   #87086h, r14
FFF15959  72eeee05                          add     #5EEh, r14, r14
FFF1595D  ecef                              mov.l   [r14], r15
FFF1595F  7b4f                              bclr    #14h, r15
FFF15961  e3ef                              mov.l   r15, [r14]
FFF15963  6701                              rtsd    #1
FFF15965  6701                     loc_FFF15965 rtsd    #1
FFF15967  6080                     sub_FFF15967 sub     #8, sp  ; <<< FUNC sub_FFF15967
FFF15969  9089                              mov.w   r1, 8+var_2[sp]
FFF1596B  e302                              mov.l   r2, 8+var_8[sp]
FFF1596D  fb120a250100                      mov.l   #1250Ah, r1
FFF15973  b819                              movu.w  2[r1], r1
FFF15975  6111                              cmp     #1, r1
FFF15977  2116                              bne.b   loc_FFF1598D
FFF15979  ec01                              mov.l   8+var_8[sp], r1
FFF1597B  fbee209008                        mov.l   #89020h, r14
FFF15980  d1e101                            mov.w   2[r14], [r1]
FFF15983  ec01                              mov.l   8+var_8[sp], r1
FFF15985  fbe210250100                      mov.l   #12510h, r14
FFF1598B  d01e                              mov.w   [r1], [r14]
FFF1598D  fb120a250100             loc_FFF1598D mov.l   #1250Ah, r1
FFF15993  b891                              movu.w  4[r1], r1
FFF15995  6111                              cmp     #1, r1
FFF15997  2116                              bne.b   loc_FFF159AD
FFF15999  ec01                              mov.l   8+var_8[sp], r1
FFF1599B  fbee209008                        mov.l   #89020h, r14
FFF159A0  d1e102                            mov.w   4[r14], [r1]
FFF159A3  ec01                              mov.l   8+var_8[sp], r1
FFF159A5  fbe210250100                      mov.l   #12510h, r14
FFF159AB  d01e                              mov.w   [r1], [r14]
FFF159AD  b889                     loc_FFF159AD movu.w  8+var_2[sp], r1
FFF159AF  6131                              cmp     #3, r1
FFF159B1  2115                              bne.b   loc_FFF159C6
FFF159B3  ec01                              mov.l   8+var_8[sp], r1
FFF159B5  fbee209008                        mov.l   #89020h, r14
FFF159BA  d0e1                              mov.w   [r14], [r1]
FFF159BC  ec01                              mov.l   8+var_8[sp], r1
FFF159BE  fbe210250100                      mov.l   #12510h, r14
FFF159C4  d01e                              mov.w   [r1], [r14]
FFF159C6  fbe20a250100             loc_FFF159C6 mov.l   #1250Ah, r14
FFF159CC  5cee                              movu.w  [r14], r14
FFF159CE  611e                              cmp     #1, r14
FFF159D0  210d                              bne.b   loc_FFF159DD
FFF159D2  ec01                              mov.l   8+var_8[sp], r1
FFF159D4  fbee209008                        mov.l   #89020h, r14
FFF159D9  d0e1                              mov.w   [r14], [r1]
FFF159DB  6702                              rtsd    #2
FFF159DD  6702                     loc_FFF159DD rtsd    #2
FFF159DF  6080                     loc_FFF159DF sub     #8, sp
FFF159E1  a009                              mov.l   r1, 4[sp]
FFF159E3  fb120a250100                      mov.l   #1250Ah, r1
FFF159E9  b819                              movu.w  2[r1], r1
FFF159EB  6111                              cmp     #1, r1
FFF159ED  200d                              beq.b   loc_FFF159FA
FFF159EF  fb120a250100                      mov.l   #1250Ah, r1
FFF159F5  b891                              movu.w  4[r1], r1
FFF159F7  6111                              cmp     #1, r1
FFF159F9  1d                                bne.s   loc_FFF159FE
FFF159FA  f80601                   loc_FFF159FA mov.l   #1, [sp]
FFF159FD  0c                                bra.s   loc_FFF15A01
FFF159FE  f80600                   loc_FFF159FE mov.l   #0, [sp]
FFF15A01  ec01                     loc_FFF15A01 mov.l   [sp], r1
FFF15A03  6101                              cmp     #0, r1
FFF15A05  a809                              mov.l   4[sp], r1
FFF15A07  200c                              beq.b   loc_FFF15A13
FFF15A09  fbe210250100                      mov.l   #12510h, r14
FFF15A0F  d0e1                              mov.w   [r14], [r1]
FFF15A11  6702                              rtsd    #2
FFF15A13  f81500                   loc_FFF15A13 mov.w   #0, [r1]
FFF15A16  6702                              rtsd    #2
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

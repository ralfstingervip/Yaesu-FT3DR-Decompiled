; ==== dac_play  FFF159DF-FFF15A18 ====
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

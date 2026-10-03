; window selirq file 332B80-332C60 map FFF32B80-FFF32C60 forced 72
; ==== selirq  FFF32B80-FFF32C60 ====
FFF32B80  c22affa1                          mov.b   0A1FFh[r2], [r10]
FFF32B84  01                                .byte    1
FFF32B85  a901                              mov.l   1Ch+var_C[sp], r1
FFF32B87  6101                              cmp     #0, r1
FFF32B89  16                                beq.s   loc_FFF32B8F
FFF32B8A  e5000403                          mov.l   1Ch+var_C[sp], 1Ch+var_10[sp]
FFF32B8E  0a                                bra.s   loc_FFF32B98
FFF32B8F  fbe29b220100             loc_FFF32B8F mov.l   #1229Bh, r14
FFF32B95  f8e400                            mov.b   #0, [r14]
FFF32B98  e5000301                 loc_FFF32B98 mov.l   1Ch+var_10[sp], 1Ch+var_18[sp]
FFF32B9C  a809                     loc_FFF32B9C mov.l   1Ch+var_18[sp], r1
FFF32B9E  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF32BA0  6707                              rtsd    #7
FFF32BA2  6040                     loc_FFF32BA2 sub     #4, sp
FFF32BA4  8089                              mov.b   r1, 3[sp]
FFF32BA6  fbe2345e0600                      mov.l   #65E34h, r14
FFF32BAC  b089                              movu.b  3[sp], r1
FFF32BAE  fe61e1                            mov.l   [r1, r14], r1
FFF32BB1  05902aff                          bsr.a   sub_FFF25641
FFF32BB5  6701                              rtsd    #1
FFF32BB7  fbee008108               loc_FFF32BB7 mov.l   #88100h, r14
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
FFF32C1E  6e12                     loc_FFF32C1E pushm   r1-r2
FFF32C20  fb1238950600                      mov.l   #69538h, r1
FFF32C26  ec12                              mov.l   [r1], r2
FFF32C28  6212                              add     #1, r2
FFF32C2A  e312                              mov.l   r2, [r1]
FFF32C2C  fb1e558108                        mov.l   #88155h, r1
FFF32C31  f018                              bclr    #0, [r1].b
FFF32C33  6f12                              popm    r1-r2
FFF32C35  7f95                              rte
FFF32C37  6080                     sub_FFF32C37 sub     #8, sp  ; <<< FUNC sub_FFF32C37
FFF32C39  a009                              mov.l   r1, 8+var_4[sp]
FFF32C3B  fbe238950600                      mov.l   #69538h, r14
FFF32C41  e0e0                              mov.l   [r14], 8+var_8[sp]
FFF32C43  fbe238950600             loc_FFF32C43 mov.l   #69538h, r14
FFF32C49  ecee                              mov.l   [r14], r14
FFF32C4B  06800e                            sub     [sp].l, r14
FFF32C4E  06850e01                          cmp     8+var_4[sp].l, r14
FFF32C52  23f1                              bltu.b  loc_FFF32C43
FFF32C54  6702                              rtsd    #2
FFF32C56  7100e8                   loc_FFF32C56 add     #-18h, sp, sp
FFF32C59  a109                              mov.l   r1, 14h[sp]
FFF32C5B  a102                              mov.l   r2, 10h[sp]
FFF32C5D  a08b                              mov.l   r3, 0Ch[sp]
FFF32C5F  a084                              mov.l   r4, 8[sp]

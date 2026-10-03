; window tpu_b file 336B00-336C60 map FFF36B00-FFF36C60 forced 101
; ==== tpu_b  FFF36B00-FFF36C60 ====
FFF36B00  8161                              mov.b   r1, 4[r6]
FFF36B02  01                                .byte    1
FFF36B03  2011                              beq.b   loc_FFF36B14
FFF36B05  a889                     loc_FFF36B05 mov.l   0Ch[sp], r1
FFF36B07  6211                              add     #1, r1
FFF36B09  a089                              mov.l   r1, 0Ch[sp]
FFF36B0B  a889                              mov.l   0Ch[sp], r1
FFF36B0D  6131                              cmp     #3, r1
FFF36B0F  2805                              bge.b   loc_FFF36B14
FFF36B11  3804ff                            bra.w   loc_FFF36A15
FFF36B14  e5000201                 loc_FFF36B14 mov.l   8[sp], 4[sp]
FFF36B18  a809                     loc_FFF36B18 mov.l   4[sp], r1
FFF36B1A  a101                              mov.l   r1, 10h[sp]
FFF36B1C  6706                              rtsd    #6
FFF36B1E  fbee887008               loc_FFF36B1E mov.l   #87088h, r14
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
FFF36B9D  fbee887008               loc_FFF36B9D mov.l   #87088h, r14
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
FFF36C00  cbef0003                          mov.b   r15, 300h[r14]
FFF36C04  fbee887008                        mov.l   #87088h, r14
FFF36C09  f0e8                              bclr    #0, [r14].b
FFF36C0B  fbee887008                        mov.l   #87088h, r14
FFF36C10  f2e08901                          bset    #0, 189h[r14].b
FFF36C14  fbee008108                        mov.l   #88100h, r14
FFF36C19  f0e3                              bset    #3, [r14].b
FFF36C1B  02                                rts
FFF36C1C  6eef                     loc_FFF36C1C pushm   r14-r15
FFF36C1E  6e15                              pushm   r1-r5
FFF36C20  7fa8                              setpsw  i
FFF36C22  fb1e458108                        mov.l   #88145h, r1
FFF36C27  f410                              btst    #0, [r1].b
FFF36C29  10                                beq.s   loc_FFF36C31
FFF36C2A  fb1e458108                        mov.l   #88145h, r1
FFF36C2F  f018                              bclr    #0, [r1].b
FFF36C31  fb1e008108               loc_FFF36C31 mov.l   #88100h, r1
FFF36C36  f01b                              bclr    #3, [r1].b
FFF36C38  fb1e458108                        mov.l   #88145h, r1
FFF36C3D  6211                              add     #1, r1
FFF36C3F  f81500                            mov.w   #0, [r1]
FFF36C42  05600000                          bsr.a   sub_FFF36CA2
FFF36C46  fb1e008108                        mov.l   #88100h, r1
FFF36C4B  f013                              bset    #3, [r1].b
FFF36C4D  6f15                              popm    r1-r5
FFF36C4F  6fef                              popm    r14-r15
FFF36C51  7f95                              rte
FFF36C53  6040                     loc_FFF36C53 sub     #4, sp
FFF36C55  8089                              mov.b   r1, 3[sp]
FFF36C57  7fb8                              clrpsw  i
FFF36C59  05670000                          bsr.a   sub_FFF36CC0
FFF36C5D  0537d5fd                          bsr.a   sub_FFF14194

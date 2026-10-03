; ==== scan_a  000030E0-000030F0 ====
000030E0  6a1089c27300             loc_30E0 btst    #0, @0xFFFF89C2:16
000030E6  58700096                          beq     locret_3180:16
000030EA  6a0c816f                          mov.b   @0xFFFF816F:16, r4l
000030EE  5860008e                          bne     locret_3180:16

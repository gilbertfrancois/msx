10 BLOAD"fp.bin",R
20 L = PEEK(&H9000)
30 H = PEEK(&H9001)
80 PRINT HEX$(H)
90 PRINT HEX$(L)
150 GOSUB 1000
160 PRINT F
170 S = 0
180 E = 16
190 M = 584
200 GOSUB 1070
210 PRINT F
230 ' ----------------------------
240 H=&H3D: L=&HA7 ' 1.4142
250 GOSUB 1000
260 PRINT F
999 END
1000 ' Bytes to sign,exp,mant
1010 ' in:  H, L
1020 ' out: S, E, M
1030 E = H/4
1040 E = (H AND 124)/4
1050 S = (H AND 128)/128
1060 M = (H AND 3)*256+L
1070 ' 16bit to float
1080 ' in:  s, e, m
1090 ' out: f
1100 F = (-1)^S
1110 F = F*2^(E-15)
1120 F = F*(1024+M)/1024
1130 RETURN

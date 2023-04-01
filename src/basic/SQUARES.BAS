10 ' Squares
20 ' Gilbert Francois Duivesteijn
30 '
40 COLOR 1,15,15:CLS
50 SCREEN 2
60 PI=4*ATN(1)
70 N=18          ' nr of squares
80 A1=0          ' alpha1
90 P2=PI/2       ' half PI
100 P4=PI/4       ' quarter PI
110 B0=PI/18     ' inc angle beta
120 CB=COS(P4-B0)' cos(a-b)
130 LH=48
140 L0=LH*SQR(2)
150 XC=128-LH: YC=96-LH: B=+B0
160 GOSUB 1000
170 XC=128+LH: YC=96-LH: B=-B0
180 GOSUB 1000
190 XC=128-LH: YC=95+LH: B=-B0
200 GOSUB 1000
210 XC=128+LH: YC=95+LH: B=+B0
220 GOSUB 1000
230 IF INKEY$<>" " GOTO 230
240 END
1000 ' Draw squares
1010 ' in: Xc, Yc   ' square center
1020 '     L0       ' initial size
1030 '     B        ' inc angle beta
1040 L1=L0: A1=0
1050 FOR I=0 TO N
1060 A0=P4
1070 GOSUB 2000
1080 A1=A1+B
1090 L1=L1*.5*SQR(2)/CB
1100 NEXT I
1110 RETURN
2000 ' Draw square
2010 ' in: A0, A1  ' angles
2020 '     Xc, Yc  ' square center
2030 '     Pi
2040 '
2050 I0=L1*COS(A0+A1)
2060 J0=L1*SIN(A0+A1)
2070 X0=XC+I0: Y0=YC+J0
2080 X1=XC-J0: Y1=YC+I0
2090 X2=XC-I0: Y2=YC-J0
2100 X3=XC+J0: Y3=YC-I0
2110 LINE(X0,Y0)-(X1,Y1)
2120 LINE(X1,Y1)-(X2,Y2)
2130 LINE(X2,Y2)-(X3,Y3)
2140 LINE(X3,Y3)-(X0,Y0)
2150 RETURN

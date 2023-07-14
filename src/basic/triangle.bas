10 ' Triangles
20 ' Gilbert Francois Duivesteijn
30 '
40 COLOR 1,15,15:CLS
50 SCREEN 2
60 PI=4*ATN(1)
70 N=18          ' nr of triangles
80 A0=PI/9       ' alpha1
90 P2=PI/2
95 P3=PI/3
100 P4=PI/4       ' quarter PI
105 P6=PI/6       ' quarter PI
110 B0=PI/36      ' inc angle beta
120 CB=COS(P3-B0)' cos(a-b)
130 LH=96
131 L0=LH
150 XC=128: YC=96: B=+B0
160 GOSUB 1000
170 'XC=128+LH: YC=96-LH: B=-B0
180 'GOSUB 1000
190 'XC=128-LH: YC=95+LH: B=-B0
200 'GOSUB 1000
210 'XC=128+LH: YC=95+LH: B=+B0
220 'GOSUB 1000
230 IF INKEY$<>" " GOTO 230
240 END
1000 ' Draw squares
1010 ' in: Xc, Yc   ' square center
1020 '     L0       ' initial size
1030 '     B        ' inc angle beta
1040 L1=L0: A1=0
1050 FOR I=0 TO N
1060 A0=0
1070 GOSUB 2000
1080 A1=A1+B
1090 L1=L1*COS(P3)/CB
1100 NEXT I
1110 RETURN
2000 ' Draw triangle
2010 ' in: A0, A1  ' angles
2020 '     Xc, Yc  ' square center
2030 '     Pi
2040 '
2050 X0=XC+L1*COS(A1)
2060 Y0=YC+L1*SIN(A1)
2070 X1=XC+L1*COS(A1+1/3*2*PI)
2080 Y1=YC+L1*SIN(A1+1/3*2*PI)
2090 X2=XC+L1*COS(A1+2/3*2*PI)
2100 Y2=YC+L1*SIN(A1+2/3*2*PI)
2110 LINE(X0,Y0)-(X1,Y1)
2120 LINE(X1,Y1)-(X2,Y2)
2130 LINE(X2,Y2)-(X0,Y0)
2135 'CIRCLE(XC,YC),L1
2140 RETURN

130 ' Spirals
140 ' Gilbert Francois Duivesteijn
150 '
160 EPS=1E-05
170 PI=ATN(1)*4
180 PD=2*PI-EPS
190 PH=PI/2
200 PY=1/136*PI*2
210 LW=20: ' number of lines
215 SR=1: ' step radius
220 NC=3: ' number of colors
230 DIM CP(NC)
240 CP(0)=1
250 CP(1)=1
260 CP(2)=1
270 CP(3)=1
280 COLOR 1,15,15:CLS
290 SCREEN 2
300 GOSUB 1660
320 GOTO 320
330 END
1000 '
1010 ' init angles
1020 '
1025 DIM AS(LW*96)
1026 DIM AE(LW*96)
1030 FOR R=0 TO 96
1035 PRINT "r: "+STR$(R)
1040 FOR J=0 TO LW
1050 I=R*LW+J
1060 AS(I)=COS(R*PY)+J*PD/(2*LW)
1070 AE(I)=AS(I)+PD/(2*LW)
1080 IF AS(I)>=PD THEN AS(I)=AS(I)-PD
1090 IF AS(I)<=0 THEN AS(I)=AS(I)+PD
1100 IF AE(I)>=PD THEN AE(I)=AE(I)-PD
1110 IF AE(I)<=0 THEN AE(I)=AE(I)+PD
1112 PRINT "as:"+STR$(AS(I))+" ae:"+STR$(AE(I))
1120 NEXT J
1125 PRINT"[i] Computing angles..."
1130 NEXT R
1140 RETURN
1500 '
1510 ' draw radial
1520 '
1530 FOR R=0 TO 96 STEP 2
1531 PRINT "r:" + STR$(R)
1540 C=CP(INT(R/96*NC))
1550 FOR J=0 TO LW STEP 2
1560 AS=COS(R*PY)+J*PD/LW
1570 IF AS>=PD THEN AS=AS-PD
1580 IF AS<=0 THEN AS=AS+PD
1590 AE=AS+PD/LW
1600 IF AE>=PD THEN AE=AE-PD
1610 IF AE<=0 THEN AE=AE+PD
1620 CIRCLE(128,96),R,C,AS,AE
1630 NEXT J
1640 NEXT R
1650 RETURN
1660 '
1670 ' draw axial
1680 '
1690 FOR J=0 TO LW-1 STEP 1
1700 C=1
1710 FOR R=0 TO 136 STEP SR
1720 AS=COS(R*PY)+J*PD/LW
1730 AE=COS((R+SR)*PY)+J*PD/LW
1740 X0=128+R*COS(AS)
1750 Y0=96-R*SIN(AS)
1760 X1=128+(R+SR)*COS(AE)
1770 Y1=96-(R+SR)*SIN(AE)
1780 LINE(X0,Y0)-(X1,Y1),C
1790 NEXT R
1800 NEXT J
1801 LINE(32,0)-(223,191),C,B
1802 LINE(0,0)-(31,191),15,BF
1803 LINE(224,0)-(255,191),15,BF
1804 PAINT(128-3,96),1
1805 PAINT(128+3,96),1
1810 RETURN

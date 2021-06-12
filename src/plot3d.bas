10 CLEAR: CLS
20 CF=3 : CB=1
30 COLOR CF,CB,CB
40 ' DEFINT I,J
50 ' DEFDBL X,Y,Z,A,B
60 PRINT "[i] Plot 3D function"
70 PRINT "[i] Gilbert Francois Duivesteijn"
80 PRINT "[i] ---------------------------------"
90 INPUT "[?] Show plot or values? [p,v]";A$
100 IF A$="p" THEN PLOT=1 ELSE PLOT=0
110 ' -------------------------------- 
120 ' | START USER SETTINGS
130 ' |
140 '
150 '  Function
160 DEF FN Z(X,Y) = .5*(X^3*Y-Y^3*X)
170 ' DEF FN Z(X,Y) = .5*(X^2-Y^2)
180 '
190 '  Domain
200 X0 = -1  : ' xmin
210 X1 =  1  : ' xmax
220 Y0 = -1  : ' ymin
230 Y1 =  1  : ' ymax
240 Z0 = -1  : ' zmin
250 Z1 =  1  : ' zmax
260 ST =  4  : ' steps
270 AS = 1.2  : ' axis scale
280 ' |
290 ' | END USER SETTINGS
300 ' -------------------------------- 
310 '
320 '  Relative screen width/height
330 ' 
340 W0 = 1.5*X0
350 W1 = 1.5*X1
360 H0 = Y0
370 H1 = Y1
380 '
390 '  Projection transformation
400 '  (x,y,z)->(u,v)
410 ' 
420 DEF FN SU(X,Y,Z)=X+.5*Y
430 DEF FN SV(X,Y,Z)=.5*Y+Z
440 '
450 '  Pixel transformation
460 '  (u,v)->(U,V)
470 '
480 DEF FN TU(X)=(X-W0)/(W1-W0)*255
490 DEF FN TV(Y)=(H1-Y)/(H1-H0)*191
500 '
510 '  Allocate memory
520 ' 
530 PRINT "[i] Allocating memory"
540 DIM XX(ST+1)
550 DIM YY(ST+1)
560 DIM ZZ((ST+1),(ST+1))
570 '
580 '  Define (x,y)
590 '
600 I=0
610 FOR X=X0 TO X1 STEP (X1-X0)/ST
620 XX(I)=X
630 I=I+1
640 NEXT X
650 J=0
660 FOR Y=Y0 TO Y1 STEP (Y1-Y0)/ST
670 YY(J)=Y
680 J=J+1
690 NEXT Y
700 '
710 '  Compute z(x,y)
720 ' 
730 PRINT "[i] Computing domain"
740 FOR I=0 TO ST
750 FOR J=0 TO ST
760 ZZ(I,J)=FN Z(XX(I),YY(J))
770 NEXT J
780 NEXT I
790 PRINT "[i] Plotting function"
800 BEEP
810 IF PLOT=1 GOTO 990
820 ' 
830 '  Print values to screen
840 ' 
850 PRINT ""
860 PRINT "     x        y            z"
870 PRINT "----------------------------"
880 A$=   "+#.###   +#.###   +#.###^^^^"
890 FOR I=0 TO ST
900 FOR J=0 TO ST
910 PRINT USING A$;XX(I),YY(J),ZZ(I,J)
920 NEXT J
930 NEXT I
940 PRINT "[i] Ready."
950 END
960 '
970 '  Plot figure
980 '
990 SCREEN 2
1000 OPEN "GRP:" FOR OUTPUT AS #1
1010 GOSUB 1300 : ' Plot axes
1020 '
1030 '  plot x lines
1040 ' 
1050 FOR I=1 TO ST
1060 FOR J=0 TO ST
1070 IM=I-1: JM=J
1080 GOSUB 1650 : ' Plot line
1090 NEXT J
1100 NEXT I
1110 '
1120 ' plot y lines
1130 ' 
1140 FOR I=0 TO ST
1150 FOR J=1 TO ST
1160 IM=I: JM=J-1
1170 GOSUB 1650 : ' Plot line
1180 NEXT J
1190 NEXT I
1200 '
1210 ' Remove clipping lines
1220 ' 
1230 LINE(0,0)-(255,0),CB
1240 LINE(255,0)-(255,191),CB
1250 LINE(255,191)-(0,191),CB
1260 LINE(0,191)-(0,0),CB
1270 IF INKEY$=CHR$(32) THEN 1280 ELSE 1270
1280 CLOSE #1
1290 END
1300 '
1310 ' plot axes
1320 ' in: X0,X1, Y0,Y1, Z0,Z1, AS 
1330 '
1340 DIM AX(6)
1350 LABEL$="x"
1360 AX(0) = X0*AS : AX(1) = 0 : AX(2) = 0
1370 AX(3) = X1*AS : AX(4) = 0 : AX(5) = 0
1380 GOSUB 1520
1390 LABEL$="y"
1400 AX(0) = 0 : AX(1) = Y0*AS : AX(2) = 0
1410 AX(3) = 0 : AX(4) = Y1*AS : AX(5) = 0
1420 GOSUB 1520
1430 LABEL$="z"
1440 AX(0) = 0 : AX(1) = 0 : AX(2) = Z0*(AS/1.5)
1450 AX(3) = 0 : AX(4) = 0 : AX(5) = Z1*(AS/1.5)
1460 GOSUB 1520
1470 RETURN
1480 '
1490 ' plot axis
1500 ' in: AX(6), LABEL$
1510 '
1520 A0 = FN SU(AX(0), AX(1), AX(2))
1530 B0 = FN SV(AX(0), AX(1), AX(2))
1540 A1 = FN SU(AX(3), AX(4), AX(5))
1550 B1 = FN SV(AX(3), AX(4), AX(5))
1560 GOSUB 1720: ' to screen coordinates
1570 DRAW "BM"+STR$(CINT(A1+2))+","+STR$(CINT(B1-2))
1580 PRINT #1,LABEL$
1590 GOSUB 1810: ' plot dotted line
1600 RETURN
1610 '
1620 ' plot line
1630 ' in: (A0,B0)-(A1,B1)
1640 '
1650 A0 = FN SU(XX(IM),YY(JM),ZZ(IM,JM))
1660 B0 = FN SV(XX(IM),YY(JM),ZZ(IM,JM))
1670 A1 = FN SU(XX(I),YY(J),ZZ(I,J))
1680 B1 = FN SV(XX(I),YY(J),ZZ(I,J))
1690 GOSUB 1720: ' to screen coordinates
1700 LINE(A0,B0)-(A1,B1)
1710 RETURN
1720 '
1730 ' (u,v)->(U,V)
1740 ' in: (A0,B0)-(A1,B1)
1750 '
1760 A0 = FN TU(A0)
1770 B0 = FN TV(B0)
1780 A1 = FN TU(A1)
1790 B1 = FN TV(B1)
1800 RETURN
1810 '
1820 ' plot dotted line
1830 ' in: (A0,B0)-(A1,B1)
1840 '
1850 L1=A1-A0
1860 L2=B1-B0
1870 R0=SQR(L1^2+L2^2)
1880 L1=L1+1E-07: ' avoid devision by zero
1890 PI=3.1415926535#
1900 THETA=ATN(L2/L1)
1910 IF L1<0 AND L2>=0 THEN TH=PI+TH
1920 IF L1<0 AND L2<0 THEN TH=PI+TH
1930 XT=COS(THETA)
1940 YT=SIN(THETA)
1950 FOR R=0 TO R0 STEP 6
1960 A2=A0+R*XT
1970 B2=B0+R*YT
1980 A3=A0+(R+2)*XT
1990 B3=B0+(R+2)*YT
2000 LINE(A2,B2)-(A3,B3)
2010 NEXT R
2020 RETURN

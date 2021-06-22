10 CLEAR: CLS
20 CF=1 : CB=15
30 COLOR CF,CB,CB
40 ' DEFINT I,J
50 ' DEFSNG X,Y,Z,A,B
60 PRINT "[i] Plot 3D function"
70 PRINT "[i] Gilbert Francois Duivesteijn"
80 PRINT "[i] ---------------------------------"
90 INPUT "[?] Show plot or values? [p,v]";A$
100 INPUT "[?] Number of steps? [4-20]"; ST
110 IF ST < 4 OR ST > 20 THEN PRINT "Please choose a value between 4 and 20.": GOTO 100 ELSE GOTO 120
120 IF A$="p" THEN PLOT=1 ELSE PLOT=0
130 ' -------------------------------- 
140 ' | START USER SETTINGS
150 ' |
160 '
170 '  Function
180 DEF FN Z(X,Y) = .5*(X^3*Y-Y^3*X)
190 ' DEF FN Z(X,Y) = .5*(X^2-Y^2)
200 '
210 '  Domain
220 X0 = -1  : ' xmin
230 X1 =  1  : ' xmax
240 Y0 = -1  : ' ymin
250 Y1 =  1  : ' ymax
260 Z0 = -1  : ' zmin
270 Z1 =  1  : ' zmax
280 AS = 1.2  : ' axis scale
290 ' |
300 ' | END USER SETTINGS
310 ' -------------------------------- 
320 '
330 '  Relative screen width/height
340 ' 
350 W0 = 1.5*X0
360 W1 = 1.5*X1
370 H0 = Y0
380 H1 = Y1
390 '
400 '  Projection transformation
410 '  (x,y,z)->(u,v)
420 ' 
430 DEF FN SU(X,Y,Z)=X+.5*Y
440 DEF FN SV(X,Y,Z)=.5*Y+Z
450 '
460 '  Pixel transformation
470 '  (u,v)->(U,V)
480 '
490 DEF FN TU(X)=(X-W0)/(W1-W0)*255
500 DEF FN TV(Y)=(H1-Y)/(H1-H0)*191
510 '
520 '  Allocate memory
530 ' 
540 PRINT "[i] Allocating memory"
550 DIM XX(ST+1)
560 DIM YY(ST+1)
570 DIM ZZ((ST+1),(ST+1))
580 '
590 '  Define (x,y)
600 '
610 I=0
620 FOR X=X0 TO X1 STEP (X1-X0)/ST
630 XX(I)=X
640 I=I+1
650 NEXT X
660 J=0
670 FOR Y=Y0 TO Y1 STEP (Y1-Y0)/ST
680 YY(J)=Y
690 J=J+1
700 NEXT Y
710 '
720 '  Compute z(x,y)
730 ' 
740 PRINT "[i] Computing domain"
750 FOR I=0 TO ST
760 FOR J=0 TO ST
770 ZZ(I,J)=FN Z(XX(I),YY(J))
780 NEXT J
790 NEXT I
800 PRINT "[i] Plotting function"
810 BEEP
820 IF PLOT=1 GOTO 1000
830 ' 
840 '  Print values to screen
850 ' 
860 PRINT ""
870 PRINT "     x        y            z"
880 PRINT "----------------------------"
890 A$=   "+#.###   +#.###   +#.###^^^^"
900 FOR I=0 TO ST
910 FOR J=0 TO ST
920 PRINT USING A$;XX(I),YY(J),ZZ(I,J)
930 NEXT J
940 NEXT I
950 PRINT "[i] Ready."
960 END
970 '
980 '  Plot figure
990 '
1000 SCREEN 2
1010 OPEN "GRP:" FOR OUTPUT AS #1
1020 GOSUB 1310 : ' Plot axes
1030 '
1040 '  plot x lines
1050 ' 
1060 FOR I=1 TO ST
1070 FOR J=0 TO ST
1080 IM=I-1: JM=J
1090 GOSUB 1660 : ' Plot line
1100 NEXT J
1110 NEXT I
1120 '
1130 ' plot y lines
1140 ' 
1150 FOR I=0 TO ST
1160 FOR J=1 TO ST
1170 IM=I: JM=J-1
1180 GOSUB 1660 : ' Plot line
1190 NEXT J
1200 NEXT I
1210 '
1220 ' Remove clipping lines
1230 ' 
1240 LINE(0,0)-(255,0),CB
1250 LINE(255,0)-(255,191),CB
1260 LINE(255,191)-(0,191),CB
1270 LINE(0,191)-(0,0),CB
1280 IF INKEY$=CHR$(32) THEN 1290 ELSE 1280
1290 CLOSE #1
1300 END
1310 '
1320 ' plot axes
1330 ' in: X0,X1, Y0,Y1, Z0,Z1, AS 
1340 '
1350 DIM AX(6)
1360 LABEL$="x"
1370 AX(0) = X0*AS : AX(1) = 0 : AX(2) = 0
1380 AX(3) = X1*AS : AX(4) = 0 : AX(5) = 0
1390 GOSUB 1530
1400 LABEL$="y"
1410 AX(0) = 0 : AX(1) = Y0*AS : AX(2) = 0
1420 AX(3) = 0 : AX(4) = Y1*AS : AX(5) = 0
1430 GOSUB 1530
1440 LABEL$="z"
1450 AX(0) = 0 : AX(1) = 0 : AX(2) = Z0*(AS/1.5)
1460 AX(3) = 0 : AX(4) = 0 : AX(5) = Z1*(AS/1.5)
1470 GOSUB 1530
1480 RETURN
1490 '
1500 ' plot axis
1510 ' in: AX(6), LABEL$
1520 '
1530 A0 = FN SU(AX(0), AX(1), AX(2))
1540 B0 = FN SV(AX(0), AX(1), AX(2))
1550 A1 = FN SU(AX(3), AX(4), AX(5))
1560 B1 = FN SV(AX(3), AX(4), AX(5))
1570 GOSUB 1730: ' to screen coordinates
1580 DRAW "BM"+STR$(CINT(A1+2))+","+STR$(CINT(B1-2))
1590 PRINT #1,LABEL$
1600 GOSUB 1820: ' plot dotted line
1610 RETURN
1620 '
1630 ' plot line
1640 ' in: (A0,B0)-(A1,B1)
1650 '
1660 A0 = FN SU(XX(IM),YY(JM),ZZ(IM,JM))
1670 B0 = FN SV(XX(IM),YY(JM),ZZ(IM,JM))
1680 A1 = FN SU(XX(I),YY(J),ZZ(I,J))
1690 B1 = FN SV(XX(I),YY(J),ZZ(I,J))
1700 GOSUB 1730: ' to screen coordinates
1710 LINE(A0,B0)-(A1,B1)
1720 RETURN
1730 '
1740 ' (u,v)->(U,V)
1750 ' in: (A0,B0)-(A1,B1)
1760 '
1770 A0 = FN TU(A0)
1780 B0 = FN TV(B0)
1790 A1 = FN TU(A1)
1800 B1 = FN TV(B1)
1810 RETURN
1820 '
1830 ' plot dotted line
1840 ' in: (A0,B0)-(A1,B1)
1850 '
1860 L1=A1-A0
1870 L2=B1-B0
1880 R0=SQR(L1^2+L2^2)
1890 L1=L1+1E-07: ' avoid devision by zero
1900 PI=3.1415926535#
1910 THETA=ATN(L2/L1)
1920 IF L1<0 AND L2>=0 THEN TH=PI+TH
1930 IF L1<0 AND L2<0 THEN TH=PI+TH
1940 XT=COS(THETA)
1950 YT=SIN(THETA)
1960 FOR R=0 TO R0 STEP 6
1970 A2=A0+R*XT
1980 B2=B0+R*YT
1990 A3=A0+(R+2)*XT
2000 B3=B0+(R+2)*YT
2010 LINE(A2,B2)-(A3,B3)
2020 NEXT R
2030 RETURN

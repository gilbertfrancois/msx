100 ' Plot 3D
110 ' Gilbert Francois Duivesteijn
120 '
130 ' Change the section USER SETTINGS
140 ' for your plots.
150 '
160 ' --------------------------------
170 ' START USER SETTINGS
190 '
200 '  Function
210 DEF FN Z(X,Y) = .5*(X^3*Y-Y^3*X)
220 '
230 '  Domain
240 XL=-1: XH= 1   ' xlow, xhigh
250 YL=-1: YH= 1   ' ylow, yhigh
260 ZL=-1: ZH= 1   ' zlow, zhigh
270 AS=1.2         ' axis scale
280 ' 
290 ' END USER SETTINGS
300 ' --------------------------------
310 '
320 CLS: WIDTH 40
330 CF=1 : CB=15
340 COLOR CF,CB,CB
350 ' DEFINT I,J
360 ' DEFSNG X,Y,Z,A,B
370 PRINT "[i] Plot 3D function"
380 PRINT "[i] Gilbert Francois Duivesteijn"
390 PRINT "[i] ---------------------------------"
400 INPUT "[?] Show plot or values? [p,v]";A$
410 INPUT "[?] Number of steps? [4-20]"; ST
420 IF ST < 4 OR ST > 20 THEN PRINT "Please choose a value between 4 and 20.": GOTO 410 ELSE GOTO 430
430 IF A$="p" THEN PLOT=1 ELSE PLOT=0
440 '
450 '  Relative screen width/height
460 ' 
470 W0 = 1.5*XL
480 W1 = 1.5*XH
490 H0 = YL
500 H1 = YH
510 '
520 '  Projection transformation
530 '  (x,y,z)->(u,v)
540 ' 
550 DEF FN SU(X,Y,Z)=X+.5*Y
560 DEF FN SV(X,Y,Z)=.5*Y+Z
570 '
580 '  Pixel transformation
590 '  (u,v)->(U,V)
600 '
610 DEF FN TU(X)=(X-W0)/(W1-W0)*255
620 DEF FN TV(Y)=(H1-Y)/(H1-H0)*191
630 '
640 '  Allocate memory
650 ' 
660 PRINT "[i] Allocating memory"
670 DIM XX(ST+1)
680 DIM YY(ST+1)
690 DIM ZZ((ST+1),(ST+1))
700 '
710 '  Define (x,y)
720 '
730 I=0
740 FOR X=XL TO XH STEP (XH-XL)/ST
745 PRINT X
746 PRINT XL,XH
750 XX(I)=X
760 I=I+1
770 NEXT X
780 J=0
790 FOR Y=YL TO YH STEP (YH-YL)/ST
800 YY(J)=Y
810 J=J+1
820 NEXT Y
830 '
840 '  Compute z(x,y)
850 ' 
860 PRINT "[i] Computing domain"
870 FOR I=0 TO ST
880 FOR J=0 TO ST
890 ZZ(I,J)=FN Z(XX(I),YY(J))
900 NEXT J
910 NEXT I
920 PRINT "[i] Plotting function"
930 BEEP
940 IF PLOT=1 GOTO 1120
950 ' 
960 '  Print values to screen
970 ' 
980 PRINT ""
990 PRINT "     x        y            z"
1000 PRINT "----------------------------"
1010 A$=   "+#.###   +#.###   +#.###^^^^"
1020 FOR I=0 TO ST
1030 FOR J=0 TO ST
1040 PRINT USING A$;XX(I),YY(J),ZZ(I,J)
1050 NEXT J
1060 NEXT I
1070 PRINT "[i] Ready."
1080 END
1090 '
1100 '  Plot figure
1110 '
1120 SCREEN 2
1130 OPEN "GRP:" FOR OUTPUT AS #1
1140 GOSUB 1430 : ' Plot axes
1150 '
1160 '  plot x lines
1170 ' 
1180 FOR I=1 TO ST
1190 FOR J=0 TO ST
1200 IM=I-1: JM=J
1210 GOSUB 1780 : ' Plot line
1220 NEXT J
1230 NEXT I
1240 '
1250 ' plot y lines
1260 ' 
1270 FOR I=0 TO ST
1280 FOR J=1 TO ST
1290 IM=I: JM=J-1
1300 GOSUB 1780 : ' Plot line
1310 NEXT J
1320 NEXT I
1330 '
1340 ' Remove clipping lines
1350 ' 
1360 LINE(0,0)-(255,0),CB
1370 LINE(255,0)-(255,191),CB
1380 LINE(255,191)-(0,191),CB
1390 LINE(0,191)-(0,0),CB
1400 IF INKEY$=CHR$(32) THEN 1410 ELSE 1400
1410 CLOSE #1
1420 END
1430 '
1440 ' plot axes
1450 ' in: XL,XH, YL,YH, ZL,ZH, AS 
1460 '
1470 DIM AX(6)
1480 LABEL$="x"
1490 AX(0) = XL*AS : AX(1) = 0 : AX(2) = 0
1500 AX(3) = XH*AS : AX(4) = 0 : AX(5) = 0
1510 GOSUB 1650
1520 LABEL$="y"
1530 AX(0) = 0 : AX(1) = YL*AS : AX(2) = 0
1540 AX(3) = 0 : AX(4) = YH*AS : AX(5) = 0
1550 GOSUB 1650
1560 LABEL$="z"
1570 AX(0) = 0 : AX(1) = 0 : AX(2) = ZL*(AS/1.5)
1580 AX(3) = 0 : AX(4) = 0 : AX(5) = ZH*(AS/1.5)
1590 GOSUB 1650
1600 RETURN
1610 '
1620 ' plot axis
1630 ' in: AX(6), LABEL$
1640 '
1650 A0 = FN SU(AX(0), AX(1), AX(2))
1660 B0 = FN SV(AX(0), AX(1), AX(2))
1670 A1 = FN SU(AX(3), AX(4), AX(5))
1680 B1 = FN SV(AX(3), AX(4), AX(5))
1690 GOSUB 1850: ' to screen coordinates
1700 DRAW "BM"+STR$(CINT(A1+2))+","+STR$(CINT(B1-2))
1710 PRINT #1,LABEL$
1720 GOSUB 1940: ' plot dotted line
1730 RETURN
1740 '
1750 ' plot line
1760 ' in: (A0,B0)-(A1,B1)
1770 '
1780 A0 = FN SU(XX(IM),YY(JM),ZZ(IM,JM))
1790 B0 = FN SV(XX(IM),YY(JM),ZZ(IM,JM))
1800 A1 = FN SU(XX(I),YY(J),ZZ(I,J))
1810 B1 = FN SV(XX(I),YY(J),ZZ(I,J))
1820 GOSUB 1850: ' to screen coordinates
1830 LINE(A0,B0)-(A1,B1)
1840 RETURN
1850 '
1860 ' (u,v)->(U,V)
1870 ' in: (A0,B0)-(A1,B1)
1880 '
1890 A0 = FN TU(A0)
1900 B0 = FN TV(B0)
1910 A1 = FN TU(A1)
1920 B1 = FN TV(B1)
1930 RETURN
1940 '
1950 ' plot dotted line
1960 ' in: (A0,B0)-(A1,B1)
1970 '
1980 L1=A1-A0
1990 L2=B1-B0
2000 R0=SQR(L1^2+L2^2)
2010 L1=L1+1E-07: ' avoid division by zero
2020 PI=3.1415926535#
2030 THETA=ATN(L2/L1)
2040 IF L1<0 AND L2>=0 THEN TH=PI+TH
2050 IF L1<0 AND L2<0 THEN TH=PI+TH
2060 XT=COS(THETA)
2070 YT=SIN(THETA)
2080 FOR R=0 TO R0 STEP 6
2090 A2=A0+R*XT
2100 B2=B0+R*YT
2110 A3=A0+(R+2)*XT
2120 B3=B0+(R+2)*YT
2130 LINE(A2,B2)-(A3,B3)
2140 NEXT R
2150 RETURN

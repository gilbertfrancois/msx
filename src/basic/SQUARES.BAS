100 ' Squares
110 ' Gilbert Francois Duivesteijn
120 '
130 '
140 ' Settings
150 '
160 PI=4*ATN(1)  ' Pi
170 N=18         ' nr of squares
180 A1=0         ' alpha1
190 P2=PI/2      ' half PI
200 P4=PI/4      ' quarter PI
210 B0=PI/36     ' inc angle beta
220 '
230 ' Init
240 '
250 CB=COS(P4-B0)' cos(a-b)
260 LH=48
270 L0=LH*SQR(2)
280 COLOR 1,15,15:CLS
290 SCREEN 2
300 '
310 ' Main
320 '
330 '
340 XC=128-LH: YC=96-LH: B=+B0
350 GOSUB 450
360 XC=128+LH: YC=96-LH: B=-B0
370 GOSUB 450
380 XC=128-LH: YC=95+LH: B=-B0
390 GOSUB 450
400 XC=128+LH: YC=95+LH: B=+B0
410 GOSUB 450
420 IF INKEY$<>" " GOTO 420
430 END
440 '
450 ' Draw squares
460 ' in: Xc, Yc   ' square center
470 '     L0       ' initial size
480 '     B        ' inc angle beta
490 L1=L0: A1=0
500 FOR I=0 TO N
510 A0=P4
520 GOSUB 580
530 A1=A1+B
540 L1=L1*.5*SQR(2)/CB
550 NEXT I
560 RETURN
570 '
580 ' Draw square
590 ' in: A0, A1  ' angles
600 '     Xc, Yc  ' square center
610 '     Pi
620 '
630 I0=L1*COS(A0+A1)
640 J0=L1*SIN(A0+A1)
650 X0=XC+I0: Y0=YC+J0
660 X1=XC-J0: Y1=YC+I0
670 X2=XC-I0: Y2=YC-J0
680 X3=XC+J0: Y3=YC-I0
690 LINE(X0,Y0)-(X1,Y1)
700 LINE(X1,Y1)-(X2,Y2)
710 LINE(X2,Y2)-(X3,Y3)
720 LINE(X3,Y3)-(X0,Y0)
730 RETURN

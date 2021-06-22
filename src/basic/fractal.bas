10 ' Mandelbrot
20 ' Gilbert Duivesteijn
30 ' 1987
40 '
50 DEFDBL X,Y,Z,C
60 '
70 ' -[ begin settings ]---------
80 XC= -.5   ' x_center
90 YC= -.63118842747981# ' y_center
100 SI=  2!  ' size
110 DE=16  ' depth
120 ST=1   ' stride pixels (default=1)
130 CM=1   ' 0=zebra, 1=clip
140 ' -[ end settings ]-----------
150 '
160 X0=XC-(.5*SI*1.5)
170 Y0=YC-.5*SI
180 X1=XC+(.5*SI*1.5)
190 Y1=YC+.5*SI
200 WM=256      ' screen width
210 HM=192      ' screen height
220 DIM COL(2)  ' colormap
230 COL(0)=15   ' white
240 COL(1)=1    ' black
250 '
260 ' Pixel transformation
270 '
280 DEF FN TU(X)=CINT((X-X0)/(X1-X0)*(WM-0)+.4)
290 DEF FN TV(Y)=CINT((Y1-Y)/(Y1-Y0)*(HM-0)+.4)
300 '
310 ' Main
320 '
330 SCREEN 2
340 FOR CX=X0 TO X1 STEP (X1-X0)/WM*ST
350 FOR CY=Y1 TO Y0 STEP (Y0-Y1)/HM*ST
360 D=0
370 GOSUB 490
380 XP = FN TU(CX)
390 YP = FN TV(CY)
400 IF CM=0 THEN CP = D MOD 2 ELSE IF D>=DE THEN CP = 1 ELSE CP = 0
410 ' CP = D MOD 2
420 PRESET(XP,YP),COL(CP)
430 ' PRINT XP, YP, CP
440 NEXT CY
450 NEXT CX
460 FOR I=0 TO 50: BEEP: NEXT I
470 GOTO 470
480 END
490 ' 
500 ' f(z,c) = z^2 + c
510 ' input : cx, cy
520 ' output: d
530 '
540 X=0
550 Y=0
560 FOR D=0 TO DE-1
570 XN=X*X-Y*Y+CX
580 YN=2*X*Y+CY
590 IF (XN*XN+YN*YN) > 4 THEN RETURN
600 X=XN
610 Y=YN
620 NEXT D
630 RETURN

100 ' Mandelbrot
110 ' Gilbert Duivesteijn
120 ' 1987
130 '
140 DEFDBL X,Y,Z,C
150 '
160 ' -[ begin settings ]---------
170 XC= 0   ' x_center
180 YC= 0   ' y_center
190 SI= 3   ' size
200 DE= 16  ' depth
210 ST= 1   ' stride pixels (default=1)
220 ' -[ end settings ]-----------
230 '
240 X0=XC-(.5*SI*1.5)
250 Y0=YC-.5*SI
260 X1=XC+(.5*SI*1.5)
270 Y1=YC+.5*SI
280 WM=256      ' screen width
290 HM=192      ' screen height
300 DIM COL(2)  ' colormap
310 COL(0)=15   ' white
320 COL(1)=1    ' black
330 '
340 ' Pixel transformation
350 '
360 DEF FN TU(X)=CINT((X-X0)/(X1-X0)*(WM-0)+.4)
370 DEF FN TV(Y)=CINT((Y1-Y)/(Y1-Y0)*(HM-0)+.4)
380 '
390 ' Main
400 '
410 SCREEN 2
420 FOR CX=X0 TO X1 STEP (X1-X0)/WM*ST
430 FOR CY=Y1 TO Y0 STEP (Y0-Y1)/HM*ST
440 D=0
450 GOSUB 550
460 XP = FN TU(CX)
470 YP = FN TV(CY)
480 CP = D MOD 2
490 PRESET(XP,YP),COL(CP)
500 ' PRINT XP, YP, CP
510 NEXT CY
520 NEXT CX
530 GOTO 530
540 END
550 ' 
560 ' f(z,c) = z^2 + c
570 ' input : cx, cy
580 ' output: d
590 '
600 X=0
610 Y=0
620 FOR D=0 TO DE-1
630 XN=X*X-Y*Y+CX
640 YN=2*X*Y+CY
650 IF (XN*XN+YN*YN) > 4 THEN RETURN
660 X=XN
670 Y=YN
680 NEXT D
690 RETURN

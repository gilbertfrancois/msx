10 ' Palette
20 ' Gilbert Francois Duivesteijn
30 ' 1987
40 '
50 DIM C(18)
60 '
70 ' Sort palette
80 '
90 C(0)=1
100 C(1)=14
110 C(2)=15
120 C(3)=6
130 C(4)=8
140 C(5)=9
150 C(6)=10
160 C(7)=0
170 C(8)=11
180 C(9)=12
190 C(10)=2
200 C(11)=3
210 C(12)=4
220 C(13)=5
230 C(14)=7
240 C(15)=13
250 C(16)=0
260 C(17)=0
270 '
280 ' Settigns
290 '
300 W=CINT(256/6/8)*8 ' patch width
310 H=CINT(192/3/8)*8 ' patch height
320 CB=0              ' border color
330 '
340 ' Main
350 '
355 COLOR 1,15,15
360 SCREEN 2
370 ' Render patches
380 FOR I=0 TO 5
390 FOR J=0 TO 2
400 K=I*3+J
410 GOSUB 550
420 LINE(X0,Y0)-(X1,Y1),C(K),BF
430 NEXT J
440 NEXT I
450 ' Interlace missing medium yellow
460 I=2: J=1: C1=10: C2=11
470 GOSUB 550
480 LINE(X0,Y0)-(X1,Y1),C1,BF
490 FOR Y=Y0 TO Y1 STEP 2
500 LINE(X0,Y)-(X1,Y),C2
510 NEXT Y
520 GOSUB 640
530 IF INKEY$=CHR$(32) THEN 540 ELSE 530
540 END
550 '
560 ' (i,j) -> (x0,y0,x1,y1)
570 '
580 OF=CINT((256-6*W)/2): 'offset
590 X0=I*W+OF
600 X1=(I+1)*W-1+OF
610 Y0=J*H
620 Y1=(J+1)*H-1
630 RETURN
640 '
650 ' Draw borders
660 '
670 FOR I=0 TO 5
680 FOR J=0 TO 2
690 IF I=5 AND J>0 THEN RETURN
700 GOSUB 550
710 LINE(X0,Y0)-(X1,Y0),CB
720 LINE(X1,Y0)-(X1,Y1),CB
730 LINE(X1,Y1)-(X0,Y1),CB
740 LINE(X0,Y1)-(X0,Y0),CB
750 NEXT J
760 NEXT I
770 RETURN

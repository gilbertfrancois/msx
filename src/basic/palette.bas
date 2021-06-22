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
360 COLOR 1,15,15
370 SCREEN 2
380 ' Render patches (grid 6x3)
390 FOR I=0 TO 5
400 FOR J=0 TO 2
410 C1=C(I*3+J)
420 GOSUB 510     ' render patch
430 NEXT J
440 NEXT I
450 I=2: J=1: C1=10: C2=11
460 GOSUB 580     ' render int patch
470 GOSUB 770     ' render borders
480 ' Wait for user input
490 IF INKEY$=CHR$(32) THEN 500 ELSE 490
500 END
510 '
520 ' Render patch
530 ' Input: I, J, C1
540 '
550 GOSUB 680
560 LINE(X0,Y0)-(X1,Y1),C1,BF
570 RETURN
580 '
590 ' Render interlaced patch
600 ' Input: I, J, C1, C2
610 '
620 GOSUB 680
630 LINE(X0,Y0)-(X1,Y1),C1,BF
640 FOR Y=Y0 TO Y1 STEP 2
650 LINE(X0,Y)-(X1,Y),C2
660 NEXT Y
670 RETURN
680 '
690 ' (i,j) -> (x0,y0,x1,y1)
700 '
710 XF=CINT((256-6*W)/2): ' x-offset
720 X0=I*W+XF
730 X1=(I+1)*W-1+XF
740 Y0=J*H
750 Y1=(J+1)*H-1
760 RETURN
770 '
780 ' Draw borders
790 '
800 FOR I=0 TO 5
810 FOR J=0 TO 2
820 IF I=5 AND J>0 THEN RETURN
830 GOSUB 680
840 LINE(X0,Y0)-(X1,Y0),CB
850 LINE(X1,Y0)-(X1,Y1),CB
860 LINE(X1,Y1)-(X0,Y1),CB
870 LINE(X0,Y1)-(X0,Y0),CB
880 NEXT J
890 NEXT I
900 RETURN

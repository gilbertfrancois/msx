100 ' Random walk 1
110 ' Gilbert Francois Duivesteijn
120 '
121 CLEAR
130 '
140 ' Settings
150 '
160 SD=RND(-TIME)  ' random seed
170 NS=1500        ' nr of steps
180 R=10           ' max radius
190 NC=5           ' nr of colors
200 CQ=NC^2+1      ' nr of colors^2
210 DIM CO(NC)     ' color palette
220 CO(0)=4
230 CO(1)=5
240 CO(2)=7
250 CO(3)=10
260 CO(4)=11
270 CO(5)=15
280 DEF FN DIST(R)=R*(2*RND(1)-1)
290 X0=128+64*RND(1)-32
300 Y0= 96+64*RND(1)-32
310 '
320 ' Start
330 '
340 COLOR 15,1,1: CLS
350 SCREEN 2
360 '
370 ' Main loop
380 '
390 FOR S=0 TO NS
400 PL=RND(1)
410 IF PL<.03 THEN GOSUB 770
420 X1=X0+INT(FN DIST(R/5)^3)
430 Y1=Y0+INT(FN DIST(R/5)^3)
440 IF X1<0 THEN X1=X1+255
450 IF Y1<0 THEN Y1=Y1+191
460 IF X1>255 THEN X1=X1-255
470 IF Y1>191 THEN Y1=Y1-191
480 P=RND(1)
490 IF P>.97 THEN GOSUB 570 ' circle
500 IF P<.05 THEN GOSUB 690 ' star
510 GOSUB 630               ' point
520 X0=X1
530 Y0=Y1
540 NEXT S
550 IF INKEY$ <> " " GOTO 550
555 GOTO 100
560 END
570 '
580 ' Draw circle
590 '
600 R0=RND(1)*R/4
610 C0=CO(INT(SQR(CQ*RND(1))))
620 CIRCLE(X1,Y1),R0,C0
630 '
640 ' Draw point
650 '
660 C0=CO(INT((NC+1)*RND(1)))
670 PSET(X1,Y1),C0
680 RETURN
690 '
700 ' Draw star
710 '
720 C0=CO(INT(SQR(CQ*RND(1))))
730 R0=.25*R*RND(1)
740 LINE(X1-R0,Y1)-(X1+R0,Y1),C0
750 LINE(X1,Y1-R0)-(X1,Y1+R0),C0
760 RETURN
770 '
780 ' Re-init location
790 '
800 X0=255*RND(1)
810 Y0=191*RND(1)
820 RETURN

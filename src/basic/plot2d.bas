100 ' Plot 2D
110 ' Gilbert Francois Duivesteijn
120 '
130 ' Change the section USER SETTINGS
140 ' for your plots.
150 '
160 ' --------------------------------
170 ' START USER SETTINGS
180 '
190 ' Function
200 DEF FN Y(X)=EXP(-X)-.25*EXP(-2*X)
210 '
220 ' Domain
230 XL=-3: XH=3    ' xlow, xhigh
240 YL=-2: YH=2    ' ylow, yhigh
250 NS=10          ' number of steps
260 ' Colors
270 CF=1           ' forground color
280 CB=15          ' background color
290 CA=14          ' axes color
300 '
310 ' END USER SETTINGS
320 ' --------------------------------
330 COLOR CF,CB,CB
340 SCREEN 0: WIDTH 40: KEY OFF
350 PRINT "[i] Plot 2D function"
360 PRINT "[i] Gilbert Francois Duivesteijn"
370 PRINT "[i] ---------------------------------"
380 INPUT "[?] Show plot or values [p,v]";A$
390 INPUT "[?] Number of steps"; NS
400 ST=(XH-XL)/NS
410 IF A$="p" THEN GOTO 470 ELSE GOTO 420
420 '
430 ' Print values
440 '
450 GOSUB 1230
460 END
470 '
480 ' pixel transformation
490 '
500 WM=255: HM=191 ' screen resolution
510 DEF FN TU(X)=INT((X-XL)/(XH-XL)*WM+.4)
520 DEF FN TV(Y)=INT((YH-Y)/(YH-YL)*HM+.4)
530 ' 
540 ' Main
550 ' 
560 SCREEN 2
570 OPEN "GRP:" FOR OUTPUT AS #1
580 GOSUB 640     ' plot axes
590 GOSUB 800     ' plot ticks
600 GOSUB 1070    ' plot function
610 BEEP
620 IF INKEY$ <> " " GOTO 620
630 END
640 '
650 ' Draw axis
660 '
670 X0=FN TU(XL)
680 Y0=FN TV(0)
690 X1=FN TU(XH)
700 Y1=Y0
710 PRINT X0,Y0
720 PRINT X1,Y1
730 LINE(X0,Y0)-(X1,Y1),CA
740 X0=FN TU(0)
750 Y0=FN TV(YL)
760 X1=X0
770 Y1=FN TV(YH)
780 LINE(X0,Y0)-(X1,Y1),CA
790 RETURN
800 '
810 ' plot ticks
820 '
830 FOR X=XL TO XH STEP 1
840 X0=FN TU(X)
850 Y0=FN TV(0)-3
860 X1=FN TU(X)
870 Y1=FN TV(0)+3
880 LINE(X0,Y0)-(X1,Y1),CA
890 NEXT X
900 FOR Y=YL TO YH STEP 1
910 X0=FN TU(0)-3
920 Y0=FN TV(Y)
930 X1=FN TU(0)+3
940 Y1=FN TV(Y)
950 LINE(X0,Y0)-(X1,Y1),CA
960 NEXT Y
970 A1=FN TU(XH)
980 B1=FN TV(0)
990 COLOR CA
1000 DRAW "BM"+STR$(CINT(A1-6))+","+STR$(CINT(B1+1))
1010 PRINT #1,"x"
1020 A1=FN TU(0)
1030 B1=FN TV(YH)
1040 DRAW "BM"+STR$(CINT(A1-6))+","+STR$(CINT(B1+1))
1050 PRINT #1,"y"
1060 COLOR CF
1070 '
1080 ' Plot function
1090 '
1100 X0=FN TU(XL)
1110 Y0=FN TV(FN Y(XL))
1120 FOR X=XL TO XH STEP ST
1130 X1=FN TU(X)
1140 Y1=FN TV(FN Y(X))
1150 IF Y0<0 OR Y0>191 GOTO 1200
1160 IF Y1<0 OR Y1>191 GOTO 1200
1170 IF X0<0 OR X0>255 GOTO 1200
1180 IF X1<0 OR X1>255 GOTO 1200
1190 LINE(X0,Y0)-(X1,Y1),CF
1200 X0=X1: Y0=Y1
1210 NEXT X
1220 RETURN
1230 '
1240 ' Print values
1250 '
1260 PRINT ""
1270 PRINT "     x            y"
1280 PRINT "-------------------"
1290 FM$="+#.###   +#.###^^^^"
1300 FOR X=XL TO XH STEP ST
1310 Y=FN Y(X)
1320 PRINT USING FM$;X,Y
1330 NEXT X
1340 RETURN

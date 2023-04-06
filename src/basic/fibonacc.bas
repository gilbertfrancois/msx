100 ' Fibonacci numbers
110 ' Gilbert Francois Duivesteijn
120 '
130 '
140 ' Settings
150 '
160 S=1            ' Scaler
170 NS=13          ' max nr of steps
180 CF=1           ' line color
190 CB=15          ' background color
200 CC=15          ' border color
210 XC=128+27      ' x-center
220 YC=96+17       ' y-center
230 '
240 ' Init
250 '
260 PI=4*ATN(1)    ' Pi
270 P2=2*PI        ' 2Pi
280 DIM AN(3)      ' LUT angle
290 DIM FC(3)      ' LUT cos
300 DIM FS(3)      ' LUT sin
310 FOR I=0 TO 3:AN(I)=I*PI/2:NEXT I
320 FOR I=0 TO 3:READ FC(I):NEXT I
330 FOR I=0 TO 3:READ FS(I):NEXT I
340 DATA 1,0,-1,0,0,1,0,-1
350 COLOR CF,CB,CC
360 SCREEN 2
370 '
380 ' Main loop
390 '
400 F0=0
410 F1=1
420 FOR IT=0 TO NS
430 A=AN(IT MOD 4)
440 IF A>P2 THEN A=A-INT(A/P2)*P2
450 X0=XC+F0*S*FC((IT+2) MOD 4)
460 Y0=YC-F0*S*FS((IT+2) MOD 4)
470 X1=XC+F1*S*FC((IT) MOD 4)
480 Y1=YC-F1*S*FS((IT) MOD 4)
490 IF X0<0 AND Y0<0 GOTO 550
500 IF X1<0 AND Y1<0 GOTO 550
510 IF X0>255 AND Y0>191 GOTO 550
520 IF X1>255 AND Y1>191 GOTO 550
530 LINE(XC,YC)-(X0,Y0),CF
540 LINE(XC,YC)-(X1,Y1),CF
550 A0=AN((IT+4-1) MOD 4)
560 A1=AN((IT+4) MOD 4)
570 IF IT=0 GOTO 580
580 CIRCLE(XC,YC),F1*S,CF,A0,A1
590 T=F0+F1
600 F0=F1
610 F1=T
620 XC=X0
630 YC=Y0
640 NEXT IT
650 IF INKEY$ <> " " GOTO 650
660 SCREEN 0
670 PRINT "Fi-1 : "+STR$(F0)
680 PRINT "Fi   : "+STR$(F1)
690 END

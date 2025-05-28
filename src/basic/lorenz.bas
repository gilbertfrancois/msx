10 ' Lorenz system
20 '
30 ' Gibert Francois Duivesteijn
40 '
50 SCREEN 0: COLOR 15,1,1
60 '
70 ' Constants
80 '
90 R=28
100 S=10
110 B=8/3
120 DT=.01: ' Integration step
130 '
140 ' Initial conditions
150 '
160 X=2!
170 Y=.1
180 Z=10!
190 '
200 ' pixel transformation
210 '
220 SC=25: ' projection scaler
230 DEF FN TX(X)=INT(128+X/SC*128)
240 DEF FN TY(Y)=INT(96+Y/SC*96)
250 DEF FN TZ(Z)=INT(Z/SC*96)
260 SCREEN 2
270 '
280 ' MAIN LOOP
290 '
300 GOSUB 1000
310 '
320 ' Change projection here...
330 ' (Xs,Ys) = T[xy|xz|yz]
340 '
350 XS=FN TX(X)
360 YS=FN TZ(Z)
370 '
380 ' Draw to screen
390 '
400 PSET(XS, YS),CC
410 GOTO 280
420 END
1000 '
1010 ' Lorenz equations
1020 '
1030 DX=S*(Y-X)
1040 DY=X*(R-Z)-Y
1050 DZ=X*Y-B*Z
1060 X=X+DX*DT
1070 Y=Y+DY*DT
1080 Z=Z+DZ*DT
1090 V=DX^2+DY^2+DZ^2
1100 CC=15
1110 IF V>4000 THEN CC=7
1120 IF V>8000 THEN CC=5
1130 IF V>16000 THEN CC=4
1140 IF V>32000 THEN CC=13
1150 RETURN

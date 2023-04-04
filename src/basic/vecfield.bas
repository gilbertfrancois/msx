100 ' Vector field
110 ' Gilbert Francois Duivesteijn
120 ' 
130 '
140 ' Settings
150 '
160 SD=RND(-TIME)   ' rnd seed
170 NX=4: NY=3      ' nr of cells
180 OX=0: OY=0      ' offset
190 ST=8            ' grid step
200 SO=ST/2-1       ' step offset
210 R=SO            ' half vec size
220 PI=4*ATN(1)     ' Pi
230 '
240 ' Start
250 ' 
260 COLOR 1,15,14
270 SCREEN 0
280 WIDTH 40: CLS
290 '
300 ' Generate vector field
310 '
320 GOSUB 16000
330 '
340 ' Main loop
350 '
360 SCREEN 2
370 FOR X=SO TO 255-SO STEP ST
380 FOR Y=SO TO 191-SO STEP ST
390 GOSUB 16470  ' Compute direction Z
400 A=2*PI*Z
410 X0=X+R*COS(A)
420 Y0=Y+R*SIN(A)
430 X1=X+R*COS(A+PI)
440 Y1=Y+R*SIN(A+PI)
450 LINE(X0,Y0)-(X1,Y1)
460 NEXT Y
470 NEXT X
480 IF INKEY$ <> " " THEN GOTO 480
490 END
16000 '
16010 ' libnoise
16020 ' Perlin noise generator
16030 ' Gilbert Francois Duivesteijn
16040 '
16050 ' init: 16000
16060 ' run:  16470
16070 '
16080 ' Init Perlin noise
16090 ' in: NX,NY: nr of cells
16100 '     OX,OY: offset in pxls
16110 ' out: GX,GY: grad in nodes
16120 '      PX,PY: pxls per cell
16130 '
16140 PRINT "[i] Generating random gradient."
16150 T0=TIME
16160 PX=(256-2*OX)/NX
16170 PY=(192-2*OY)/NY
16180 PRINT "[i] px: " + STR$(PX)
16190 PRINT "[i] py: " + STR$(PY)
16200 DIM GX(NX,NY): ' grad dv/dx
16210 DIM GY(NX,NY): ' grad dv/dy
16220 FOR I=0 TO NX
16230 FOR J=0 TO NY
16240 GX(I,J) = 2*RND(1)-1
16250 GY(I,J) = 2*RND(1)-1
16260 NEXT J
16270 NEXT I
16280 T1=TIME
16290 PRINT "    Done, " + STR$((T1-T0)/50) + " sec."
16300 RETURN
16310 '
16320 ' Dot gradient
16330 ' in:  x,ix,y,iy,gx,gy
16340 ' out: dg
16350 '
16360 DX=XP-IX
16370 DY=YP-IY
16380 DG=GX(IX,IY)*DX + GY(IX,IY)*DY
16390 RETURN
16400 '
16410 ' Interpolate
16420 ' in:  n0,n1,w
16430 ' out: n2
16440 '
16450 A2=(A1-A0)*W+A0
16460 RETURN
16470 '
16480 ' Perlin noise
16490 ' in: X, Y
16500 ' out: Z
16510 '
16520 XP=(X-OX)/PX
16530 YP=(Y-OY)/PY
16540 IX=INT(XP)
16550 IY=INT(YP)
16560 GOSUB 16310
16570 Z0=DG: DG=0
16580 IX=INT(XP)+1
16590 IY=INT(YP)
16600 GOSUB 16310
16610 Z1=DG: DG=0
16620 ' point(ix0,iy1)
16630 IX=INT(XP)
16640 IY=INT(YP)+1
16650 GOSUB 16310
16660 Z2=DG: DG=0
16670 ' point(ix1,iy1)
16680 IX=INT(XP)+1
16690 IY=INT(YP)+1
16700 GOSUB 16310
16710 Z3=DG: DG=0
16720 ' interpolate
16730 A0=Z0: A1=Z1: W=XP-INT(XP)
16740 GOSUB 16400
16750 Z4=A2: A2=0
16760 A0=Z2: A1=Z3: W=XP-INT(XP)
16770 GOSUB 16400
16780 Z5=A2: A2=0
16790 A0=Z4: A1=Z5: W=YP-INT(YP)
16800 GOSUB 16400
16810 Z=A2: A2=0
16820 RETURN

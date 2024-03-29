100 ' Stream lines
110 ' Gilbert Francois Duivesteijn
120 '
130 ' NOTE: It takes approximately
140 '       3 to 12 hours to render.
150 '
160 '
170 ' Settings
180 '
190 SD=RND(-TIME)  ' rnd seed
200 NX=7: NY=5     ' nr of cells
210 OX=0: OY=0     ' offset
220 R=3            ' integr step
230 ST=12          ' grid step
240 SO=ST/2-1      ' step offset
250 PI=4*ATN(1)    ' Pi
260 DR=PI/180      ' DEG to RAD
270 RD=180/PI      ' RAD to DEG
280 '
290 ' Start
300 ' 
310 COLOR 1,15,14
320 SCREEN 0
330 WIDTH 40: CLS
340 '
350 ' Generate vector field
360 '
370 GOSUB 16000
380 '
390 ' Main loop
400 '
410 SCREEN 2
420 FOR XJ=SO TO 255-SO STEP ST
430 FOR YJ=SO TO 191-SO STEP ST
440 XI=RND(1)*255
450 YI=RND(1)*191
460 OA=0
470 GOSUB 550    ' draw streamline
480 OA=180
490 GOSUB 550    ' draw streamline
500 NEXT YJ
510 NEXT XJ
520 BEEP
530 IF INKEY$ <> " " THEN GOTO 530
540 END
550 '
560 ' Draw streamline
570 '
580 X0=XI: Y0=YI
590 FOR T=0 TO 300
600 X=X0: Y=Y0
610 IF X>255 OR X<0 THEN RETURN
620 IF Y>191 OR Y<0 THEN RETURN
630 GOSUB 16470 ' Compute direction Z
640 A=360*Z+OA
650 X1=X0+R*COS(A*DR)
660 Y1=Y0+R*SIN(A*DR)
670 LINE(X0,Y0)-(X1,Y1)
680 X0=X1: Y0=Y1
690 NEXT T
700 RETURN
16000 '
16010 ' libnoise
16020 ' Perlin noise generator
16030 ' Gilbert Francois Duivesteijn
16040 '
16050 ' init: 16000
16060 ' run: 16470
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
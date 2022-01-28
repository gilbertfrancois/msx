10 ' Perlin noise generator
20 ' Gilbert Francois Duivesteijn
30 '
100 ' init: 450
110 ' run: 
400 '
410 ' Init Perlin noise
420 ' in: NX,NY: nr of cells
421 '     OX,OY: offset in pxls
430 ' out: GX,GY: grad in nodes
431 '      PX,PY: pxls per cell
440 '
450 PRINT "[i] Generating random gradient."
460 T0=TIME
470 PX=(256-2*OX)/NX
480 PY=(192-2*OY)/NY
490 PRINT "px: " + STR$(PX)
500 PRINT "[i] py: " + STR$(PY)
510 DIM GX(NX,NY): ' grad dv/dx
520 DIM GY(NX,NY): ' grad dv/dy
530 FOR I=0 TO NX
540 FOR J=0 TO NY
550 GX(I,J) = 2*RND(TIME)-1
560 GY(I,J) = 2*RND(TIME)-1
570 NEXT J
580 NEXT I
590 T1=TIME
600 PRINT "    Done, " + STR$((T1-T0)/50) + " sec."
610 RETURN
620 '
630 ' Dot gradient
640 ' in:  x,ix,y,iy,gx,gy
650 ' out: dg
660 '
670 DX=XP-IX
680 DY=YP-IY
690 DG=GX(IX,IY)*DX + GY(IX,IY)*DY
700 RETURN
710 '
720 ' Interpolate
730 ' in:  n0,n1,w
740 ' out: n2
750 '
760 A2=(A1-A0)*W+A0
770 RETURN
780 '
790 ' Perlin noise
800 ' in: X, Y
810 ' out: Z
820 '
830 XP=(X-OX)/PX
840 YP=(Y-OY)/PY
850 IX=INT(XP)
860 IY=INT(YP)
870 GOSUB 620
880 Z0=DG: DG=0
890 IX=INT(XP)+1
900 IY=INT(YP)
910 GOSUB 620
920 Z1=DG: DG=0
930 ' point(ix0,iy1)
940 IX=INT(XP)
950 IY=INT(YP)+1
960 GOSUB 620
970 Z2=DG: DG=0
980 ' point(ix1,iy1)
990 IX=INT(XP)+1
1000 IY=INT(YP)+1
1010 GOSUB 620
1020 Z3=DG: DG=0
1030 ' interpolate
1040 A0=Z0: A1=Z1: W=XP-INT(XP)
1050 GOSUB 710
1060 Z4=A2: A2=0
1070 A0=Z2: A1=Z3: W=XP-INT(XP)
1080 GOSUB 710
1090 Z5=A2: A2=0
1100 A0=Z4: A1=Z5: W=YP-INT(YP)
1110 GOSUB 710
1120 Z=A2: A2=0
1130 RETURN

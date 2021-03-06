100 ' Perlin noise generator
110 ' Gilbert Francois Duivesteijn
120 '
121 clear
129 ' Init perlin noise grid
130 NX=4 : NY=4: ' nr of cells
135 OX=0 : OY=0: ' offset
140 px=(256-2*OX)/nx
150 py=(192-2*OY)/ny
155 print "px: " + str$(px)
156 print "py: " + str$(py)
160 GOSUB 2000
161 goto 400
170 '
200 color 15,4,4: cls
205 ' plot intersection
210 screen 2
220 for x=0 to 255
230 y=0
230 gosub 6000
240 pset(x, 96-z*200)
270 next x
280 goto 280
300 ' unittest
310 x=32: y=0
330 gosub 6000
340 print z
350 end
400 ' plot surface
410 color 15,4,4:cls
420 screen 2
430 for x=8 to 255 step 8
440 for y=8 to 191 step 8
450 circle(x,y),z*24
470 next y
480 next x
490 goto 490
999 END
2000 '
2010 ' Generate random gradient
2020 ' in: NX,NY 
2030 ' out: GX,GY
2040 '
2050 PRINT "[i] Generating random gradient."
2060 T0=TIME
2061 DIM GX(NX,NY): ' grad dv/dx
2062 DIM GY(NX,NY): ' grad dv/dy
2070 FOR I=0 TO NX
2080 FOR J=0 TO NY
2100 GX(I,J) = cos(I)*cos(J): '2*RND(time)-1
2110 GY(I,J) = sin(I)*sin(J): '2*RND(time)-1
2120 NEXT J
2130 NEXT I
2140 T1=TIME
2150 PRINT "    Done, " + STR$((T1-T0)/50) + " sec."
2160 RETURN
4000 '
4010 ' Dot gradient
4020 ' in:  x,ix,y,iy,gx,gy
4030 ' out: dg
4040 '
4041 DX=XP-IX
4042 DY=YP-IY
4050 print "------------------"
4051 print "xp: " + str$(XP)
4052 print "ix: " + str$(IX)
4053 print "dx: " + str$(DX)
4054 print "gx: " + str$(GX(IX,IY))
4055 print "yp: " + str$(YP)
4056 print "iy: " + str$(IY)
4057 print "dy: " + str$(DY)
4058 print "gy: " + str$(GY(IX,IY))
4070 DG=GX(IX,IY)*DX + GY(IX,IY)*DY
4075 print "dG: " + str$(DG)
4076 'input a$
4080 RETURN
5000 '
5010 ' Interpolate
5020 ' in:  n0,n1,w
5030 ' out: n2
5040 '
5050 A2=(A1-A0)*W+A0
5051 print "------------------"
5052 print "a0: " + str$(a0)
5053 print "a1: " + str$(a1)
5054 print "w : " + str$(w)
5055 'input a$
5065 RETURN
6000 '
6010 ' Perlin noise
6020 ' in: X, Y
6030 ' out: Z
6040 '
6050 XP=(X-OX)/PX
6060 YP=(Y-OY)/PY
6065 ' point(ix0,iy0)
6070 IX=INT(XP)
6080 IY=INT(YP)
6090 GOSUB 4000
6100 Z0=DG: DG=0
6105 ' point(ix1,iy0)
6110 IX=INT(XP)+1
6120 IY=INT(YP)
6125 GOSUB 4000
6130 Z1=DG: DG=0
6140 ' point(ix0,iy1)
6150 IX=INT(XP)
6160 IY=INT(YP)+1
6170 GOSUB 4000
6180 Z2=DG: DG=0
6190 ' point(ix1,iy1)
6200 IX=INT(XP)+1
6210 IY=INT(YP)+1
6220 GOSUB 4000
6230 Z3=DG: DG=0
6250 ' interpolate
6260 A0=Z0: A1=Z1: W=XP-INT(XP)
6270 GOSUB 5000
6280 Z4=A2: A2=0
6290 A0=Z2: A1=Z3: W=XP-INT(XP)
6300 GOSUB 5000
6310 Z5=A2: A2=0
6320 A0=Z4: A1=Z5: W=YP-INT(YP)
6330 GOSUB 5000
6340 Z=A2: A2=0
6342 print "*****"
6343 print "z0: " + str$(z0)
6344 print "z1: " + str$(z1)
6345 print "z2: " + str$(z2)
6346 print "z3: " + str$(z3)
6347 print "z4: " + str$(z4)
6348 print "z5: " + str$(z5)
6349 print "z : " + str$(z)
6350 print "*****"
6356 RETURN


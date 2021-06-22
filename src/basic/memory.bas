10 ' Visualize memory
20 ' for MSX computers with 64kB
30 ' Gilbert Francois Duivesteijn
40 ' 1988
50 '
60 TIME=0
70 COLOR 1,15,15:CLS
80 ST=4         ' step
90 BX=512/ST    ' block size width
100 BY=4096/512  ' block size height
110 CF=1         ' fg color
120 CB=2         ' bg color
130 SCREEN 2
140 OPEN "grp:" FOR OUTPUT AS #1
150 A0=0 : B0=0
160 LB$="MSX"
170 GOSUB 540
180 ' Statusbar
190 LINE(0,192-10)-(255,191),14,BF
200 A0=0 : B0=191-8
210 LB$="Scanning..."
220 GOSUB 540
230 ' Plot MSX RAM
240 BS=0   ' start mem blk idx
250 BE=15  ' end mem blk idx
260 OY=0   ' y offset
270 RA=0   ' 0=ram, 1=vram
280 C0=2 : C1=3 ' BG colors
290 GOSUB 660  ' Plot RAM
300 ' Plot MSX VRAM
310 BS=0   ' start mem blk idx
320 BE=3   ' end mem blk idx
330 OY=16*BY+4 ' y offset
340 RA=1   ' 0=ram, 1=vram
350 C0=8 : C1=9 ' BG colors
360 GOSUB 660  ' Plot VRAM
370 ' Statusbar
380 LINE(0,192-10)-(255,191),14,BF
390 A0=0 : B0=191-8
400 T0=TIME/50
410 T1$=STR$(T0)+" sec."
420 LB$="Ready. Chrono: "+T1$
430 GOSUB 540
440 IF INKEY$=CHR$(32) THEN 450 ELSE 440
450 END
460 '
470 ' Draw point
480 ' in: X, Y, B, BY, OY, CF
490 '
500 Y=CINT(K/BX)
510 X=CINT(K MOD BX)
520 PSET(128+X,B*BY+Y+OY),CF
530 RETURN
540 '
550 ' Print label
560 ' in: A0, B0, LB$
570 '
580 IF LB$="0" THEN LB$="0000"
590 FOR I=1 TO LEN(LB$)
600 DRAW "BM"+STR$(A0+6*I)+","+STR$(B0)
610 'PRESET(A0+6*I,B0),CB
620 COLOR CF
630 PRINT #1,MID$(LB$,I,1)
640 NEXT I
650 RETURN
660 '
670 ' Plot RAM
680 ' in: BS,BE,C1,C2,B,BY,OY
690 '
700 LB$=STR$((BE-BS+1)*4)+"kB"
710 IF RA=0 THEN LR$=" RAM" ELSE LR$=" VRAM"
720 LB$=LB$+LR$
730 A0=120-(4+1)*6-(LEN(LB$)+1)*6
740 B0=OY          ' label y-coord
750 GOSUB 540      ' print label
760 FOR B=BS TO BE
770 IF B MOD 2=0 THEN CB=C0 ELSE CB=C1
780 MS=B*&H1000       'mem blk start
790 ME=B*&H1000+&HFFF 'mem blk end
800 LINE(128,B*BY+OY)-(255,(B+1)*BY-1+OY),CB,BF
810 LINE(120,B*BY+OY)-(127,B*BY+OY),14
820 LB$=HEX$(MS)   ' label text
830 A0=120-(4+1)*6 ' label x-coord
840 B0=B*BY+OY     ' label y-coord
850 GOSUB 540      ' print label
860 K=0
870 ' Sample memory and draw points
880 FOR M=MS TO ME STEP ST
890 IF RA=0 THEN V=PEEK(M) ELSE V=VPEEK(M)
900 IF V>0 AND V<>255 THEN GOSUB 460
910 K=K+1
920 NEXT M
930 NEXT B
940 RETURN

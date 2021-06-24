10 ' Save and load screen 2
20 ' to cassette.
30 ' (Slow BASIC version)
40 '
50 ' Gilbert Duivesteijn
60 '
70 ' Ref: "MSX made simple"
80 '      Margaret Norman
90 '
100 '===============================
110 ' The pattern generator table 
120 ' and colour table in mode 2 
130 ' each occupy &H1800 bytes of 
140 ' memory. It is therefore 
150 ' necessary to reserve &H3000 
160 ' bytes of the main memory for 
170 ' the copy, using the CLEAR 
180 ' command.
190 '===============================
200 CLS:COLOR 1,15,15
210 PRINT "Screen dump test"
220 PRINT "================"
230 INPUT "Load or save a screendump? [l/s]"; A$
240 IF A$="l" OR A$="L" THEN GOTO 670
250 SCREEN 2
260 ' Make pattern and colors
270 FOR I=0 TO 191 STEP 8
280 LINE(0,I)-(255,I)
290 LINE(I+32,0)-(I+32,191)
300 NEXT I
310 FOR J=0 TO 4
320 X0=CINT(RND(1)*23)*8+32
330 Y0=CINT(RND(1)*23)*8
340 LINE(X0+1,Y0+1)-(X0+7,Y0+7),4,BF
350 NEXT J
360 FOR J=0 TO 4
370 X0=CINT(RND(1)*23)*8+32
380 Y0=CINT(RND(1)*23)*8
390 LINE(X0+1,Y0+1)-(X0+7,Y0+7),6,BF
400 NEXT J
410 FOR J=0 TO 4
420 X0=CINT(RND(1)*23)*8+32
430 Y0=CINT(RND(1)*23)*8
440 LINE(X0+1,Y0+1)-(X0+7,Y0+7),10,BF
450 NEXT J
460 '
470 ' Save screen 2 to cassette
480 '
490 CLEAR 255,&HC380
500 TIME=0
510 FOR I=0 TO &H17FF
520 POKE &HC380+I,VPEEK(BASE(11)+I)
530 NEXT I
540 FOR I=0 TO &H17FF
550 POKE &HDB80+I,VPEEK(BASE(12)+I)
560 NEXT I
570 T0=TIME/50
580 SCREEN 0
590 PRINT "VRAM copied in "+STR$(T0)+" sec."
600 PRINT "Set cassette to REC and press a key"
610 PRINT "to continue."
620 A$=INPUT$(1)
630 PRINT "Saving..."
640 BSAVE"cas:sc2dmp",&HC380,&HF37F
650 PRINT "Ready."
660 END
670 '
680 ' Load screen 2 from cassette
690 '
700 CLEAR 255,&HC380
710 BLOAD "cas:sc2dmp"
720 SCREEN 2: CLS
730 FOR I=0 TO &H17FF
740 VPOKE(BASE(11)+I),PEEK(&HC380+I)
750 NEXT I
760 FOR I=0 TO &H17FF
770 VPOKE(BASE(12)+I),PEEK(&HDB80+I)
780 NEXT I
790 GOTO 790

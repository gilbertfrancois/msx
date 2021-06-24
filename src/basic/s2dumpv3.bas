10 ' Save and load screen 2
20 ' to cassette.
30 ' (Fast ASM version)
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
200 CLEAR 255,&HC300
210 '
220 ' VRAM -> RAM
230 '
240 FOR I=0 TO 24
250 READ A$
260 POKE &HC300+I,VAL("&H"+A$)
270 NEXT I
280 DATA 21,00,20,11,80,C3,01,00,18,CD,59,00
290 DATA 21,00,00,11,80,DB,01,00,18,CD,59,00,C9
300 DEF USR0=&HC300
310 '
320 ' RAM -> VRAM
330 '
340 FOR I=0 TO 24
350 READ A$
360 POKE &HC340+I,VAL("&H"+A$)
370 NEXT I
380 DATA 21,80,C3,11,00,20,01,00,18,CD,5C,00
390 DATA 21,80,DB,11,00,00,01,00,18,CD,5C,00,C9
400 DEF USR1=&HC340
410 '
420 ' Main
430 '
440 CLS:COLOR 1,15,15
450 PRINT "Screen dump test"
460 PRINT "================"
470 INPUT "Load or save a screendump? [l/s]"; A$
480 IF A$="l" OR A$="L" THEN GOTO 860
490 SCREEN 2
500 ' Make pattern and colors
510 FOR I=0 TO 191 STEP 8
520 LINE(0,I)-(255,I)
530 LINE(I+32,0)-(I+32,191)
540 NEXT I
550 FOR J=0 TO 4
560 X0=CINT(RND(1)*23)*8+32
570 Y0=CINT(RND(1)*23)*8
580 LINE(X0+1,Y0+1)-(X0+7,Y0+7),4,BF
590 NEXT J
600 FOR J=0 TO 4
610 X0=CINT(RND(1)*23)*8+32
620 Y0=CINT(RND(1)*23)*8
630 LINE(X0+1,Y0+1)-(X0+7,Y0+7),6,BF
640 NEXT J
650 FOR J=0 TO 4
660 X0=CINT(RND(1)*23)*8+32
670 Y0=CINT(RND(1)*23)*8
680 LINE(X0+1,Y0+1)-(X0+7,Y0+7),10,BF
690 NEXT J
700 '
710 ' Save screen 2 to cassette
720 '
730 CLEAR 255,&HC380
740 TIME=0
750 X=USR0(0)   ' VRAM -> RAM
760 T0=TIME/50
770 SCREEN 0
780 PRINT "VRAM copied in "+STR$(T0)+" sec."
790 PRINT "Set cassette to REC and press a key"
800 PRINT "to continue."
810 A$=INPUT$(1)
820 PRINT "Saving..."
830 BSAVE"cas:sc2dmp",&HC380,&HF37F
840 PRINT "Ready."
850 END
860 '
870 ' Load screen 2 from cassette
880 '
890 CLEAR 255,&HC380
900 BLOAD "cas:sc2dmp"
910 SCREEN 2: CLS
920 X=USR1(0)   ' RAM -> VRAM
930 GOTO 930

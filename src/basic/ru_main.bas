10 ' Word trainer Russian A1/A2
20 ' Gilbert Francois Duivesteijn
35 ' Main program only, needs a 
36 ' dataset starting at line 4000.
30 '
40 WIDTH 40:KEYOFF:CLS:COLOR 15,4,4
50 PRINT"[i] Word trainer En-Ru A1/A2"
60  PRINT"[i] Gilbert Francois Duivesteijn"
70  PRINT"[i] -----------------------------------"
80 INPUT"[?] Is the character map loaded [y/n]";A$
90 IF A$<>"y" THEN 100 ELSE 170
100 PRINT"[e] load and run cmapload.bas first. Then rerun this program."
110 END
170 GOSUB 1000
180 END
1000 ' Main loop
1010 '
1020 '
1030 FOR I=1 TO 120
1040 CLS
1050 LOCATE 0,12
1060 PRINT"---------------------------------------"
1070 READ RU$
1080 READ EN$
1090 LOCATE 0,10
1100 PRINT STRING$(40," ")
1110 LOCATE 2,10
1120 PRINT RU$
1130 LOCATE 0,14
1140 PRINT STRING$(40," ")
1150 LOCATE 2,14
1160 PRINT EN$
1170 FOR W=1 TO 2000: NEXT W
1180 NEXT I
1190 RETURN

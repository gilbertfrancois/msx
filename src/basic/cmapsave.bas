10 ' Character map to disk
20 ' Gilbert Francois Duivesteijn
30 '
40 SCREEN 0
50 FOR I=0 TO 255*8
60 POKE &HC800+I,VPEEK(BASE(2)+I)
70 NEXT I
80 BSAVE"s0_eu.bin",&HC800,&HD000
90 SCREEN 1
100 FOR I=0 TO 255*8
110 POKE &HC800+I,VPEEK(BASE(2)+I)
120 NEXT I
130 BSAVE"s1_eu.bin",&HC800,&HD000
140 PRINT "Ready..."

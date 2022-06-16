10 ' Character map to disk
20 ' Gilbert Francois Duivesteijn
30 '
40 SCREEN 0
50 FOR I=0 TO 255*8
60 POKE $HC800+I,VPEEK(BASE(2)+I)
70 NEXT I
80 BSAVE"cyrmap.bin",&HC800,&HD000
90 PRINT "Ready..."

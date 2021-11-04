10 ' Simple memory monitor
20 ' Gilbert Francois Duivesteijn
30 '
40 '
80 WIDTH 40:KEYOFF:CLS
90 PRINT"---------------------------------------"
100 PRINT":        Simple Memory Monitor        :"
110 PRINT"---------------------------------------"
120 INPUT"Start address";SA
130 CLS
140 PRINT"---------------------------------------"
150 N=2
160 FOR A=0 TO N*8-1
170 FOR B=0 TO 7
180 C = 8*A + B
190 IF B=0 THEN PRINT HEX$(SA+C); " ";
200 PRINT USING "\\";HEX$(PEEK(SA+C)); " ";
210 NEXT B
220 PRINT
230 NEXT A
240 PRINT"---------------------------------------"

10 ' Simple memory monitor
20 ' Gilbert Francois Duivesteijn
30 '
40 '
50 DEFINT S-T
80 WIDTH 40:KEYOFF:CLS
100 PRINT"[i] Simple Memory Monitor"
105 PRINT"[i] Gilbert Francois Duivesteijn"
110 PRINT"[i] -----------------------------------"
120 INPUT"[?] Start address";SA
130 CLS
140 PRINT"---------------------------------------"
150 GOSUB 900
160 INPUT "Continue [y/n]";C$
170 IF C$="y" THEN 150 ELSE 180
180 END
900 ' Print memory block
910 ' in:  SA: Start address
920 '
1000 N=2
1010 FOR A=0 TO N*8-1
1020 FOR B=0 TO 7
1030 C = 8*A + B
1040 IF B=0 THEN PRINT HEX$(SA+C); " ";
1050 PRINT USING "\\";HEX$(PEEK(SA+C)); " ";
1060 NEXT B
1070 PRINT
1080 NEXT A
1090 PRINT"---------------------------------------"
1100 SA = SA+C+1
1110 RETURN
2000 ' Clean memory
2010 ' in: SA: Start address
2020 '     EA: End address
2025 SA=&HC000
2026 EA=&HC800
2027 RG=EA-SA
2030 FOR I=0 TO RG
2040 POKE(SA+I),&HFF
2050 NEXT I
2060 END

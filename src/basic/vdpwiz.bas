10 ' Show VDP registers
20 ' Gilbert Francois Duivesteijn
30 '
40 SCREEN 0: KEYOFF
50 CLS: COLOR 15,4,5 :WIDTH 40
60 HR$="----------------------------------------"
70 DIM R(8)
80 S=0: SP=0
90 PRINT "[i] VDP register visualizer"
100 PRINT "[i] Gilbert Francois Duivesteijn"
110 PRINT HR$
120 INPUT "Screen mode [0,1,2,3]";S
130 IF S=0 THEN GOTO 220
140 INPUT "Sprite size [1] 8x8 or [2] 16x16"; SS
150 INPUT "Sprite magnitude [1] 1x or [2] 2x"; SM
152 INPUT "Foreground color [0-15]";FC
153 INPUT "Background color [0-15]";BC
154 INPUT "Border color     [0-15]";RC
160 PRINT SM:PRINT SS
170 IF SS=1 AND SM=1 THEN SP=0
180 IF SS=1 AND SM=2 THEN SP=1
190 IF SS=2 AND SM=1 THEN SP=2
200 IF SS=2 AND SM=2 THEN SP=3
210 IF S<0 OR S>3 THEN PRINT "Invalid screen number":GOTO 120
215 COLOR FC,BG,RC
220 SCREEN S,SP
230 FOR I=0 TO 8
240 R(I)=VDP(I)
250 NEXT I
260 SCREEN 0: COLOR 15,4,4
270 PRINT HR$
280 FOR I=0 TO 8
290 RB$=BIN$(R(I))
300 RB$=SPACE$(8-LEN(RB$))+RB$
310 RH$=HEX$(R(I))
320 IF LEN(RH$)=1 THEN RH$="0"+RH$
330 PRINT USING "Reg # | & | &";I,RB$,RH$
340 NEXT I

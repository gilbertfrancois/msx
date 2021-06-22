10 ' Maze
20 '
30 ' Small test for direct video memory
40 ' access.
50 ' Gilbert Duivesteijn
60 '
70 SCREEN 1
80 WIDTH 32
90 CLS
100 KEY OFF
105 ' Start of pattern name table in
106 ' mode 1.
110 S=BASE(5)
115 ' Fill the screen with 32*24 chars.
120 FOR C=0 TO 32*24
130 I = CINT(RND(TIME)+.4)
135 ' Write directly in video memory.
140 VPOKE S+C,29+I
150 NEXT C
160 GOTO 160

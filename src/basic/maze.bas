10 ' Maze
20 '
30 ' Small test for direct video
40 ' memory access.
50 ' Gilbert Duivesteijn
60 '
70 SCREEN 1
80 WIDTH 32: COLOR 1,15,15
90 CLS
100 KEY OFF
105 ' Start of pattern name table in
106 ' mode 1.
110 S=BASE(5)
115 ' Fill the screen with 32*24 chars.
116 FOR J=0 TO 23
117 FOR I=4 TO 27
118 C = J*32+I
120 ' FOR C=0 TO 32*24
130 A = CINT(RND(TIME)+.4)
135 ' Write directly in video memory
140 VPOKE S+C,29+A
150 NEXT I
151 NEXT J
160 GOTO 160

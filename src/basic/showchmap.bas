10 ' Show character map
20 ' Gilbert Francois Duivesteijn
30 ' 
40 screen 1: width 32
50 for i=0 to 255
60 vpoke i+base(5),i
70 next i
80 locate 0, 10

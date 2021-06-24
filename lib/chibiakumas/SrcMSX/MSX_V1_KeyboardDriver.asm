KeyboardScanner_LineCount equ 13
KeyboardScanner_LineWidth equ 8

;Port range Description 
;#A8     PPI-register A				Primary slot select register. 
;#A9 (R) PPI-register B				Keyboard matrix row input register. 
;#AA     PPI-register C				Keyboard and cassette interface. 
;#AB (W) Command register. 


;PPI-register C (#AA) Bits Description 
;0-3 Keyboard matrix row select register. 
;Matrix row can be read from PPI-register B (#A9). 
;4 Cassette motor control. 1 = off. 
;5 Cassette write signal. 1 = high. 
;6 Keyboard CAPS LED. 1 = off. 
;7 1-bit key click sound output. 1 = high. 




KeyboardScanner_AllowJoysticks:
	xor a
	ld (KeyboardScanner_NoJoy_Plus1-1),a
	ret


Read_Keyboard
KeyboardScanner_Read:
	di				
	ld hl,KeyboardScanner_KeyPresses
	ld b,0		;lets read the keyboard!
keynextline:
	in	a,(#AA)	;Read current state
	and	#F0		;only change bits 0-3 (others are for leds and casette)
	or	b		;take row number from B
	out	(#AA),a ; Update new state
	in	a,(#A9)	;read row into A
	ld (hl),a
	inc hl 
	inc b
	ld a,b
	cp 11
	jp nz,keynextline	;Stop when we get to line 11
	ret 	;<-- SM ***
KeyboardScanner_NoJoy_Plus1:


	ld b,2			;lets read the joystick too! (2 joysticks!)
joynextjoy:
	ld	a, 15		; AY port 15  (we're getting kana LED state)
	out	(&A0), a	; &A0 = AY Register write port
	in	a, (&A2)	; &A2 = Value read port
	and	128			;kana led state
	ld c,a			;store it for later

	ld a,b			;Joystick no (2/1)
	dec a 			;Converted to 1/0
	rrca
	rrca			;Coverted to 64/0
	add 15			;Allow input from all joystick ports)
	or c

;	or	0  *64+15  ;Joyport	
	out	(&A1), a	;&A1 = Value Write ports
	ld	a, 14		;Select Reg 14 (AY Port 14)
	out	(&A0), a	;&A0 = Register write port

	in	a, (&A2) 	;&A2 = read left right up down and button 1 and 2
	or %11000000	;fill in the blanks
	ld (hl),a
	inc hl 

	djnz joynextjoy	;Repeat for Joy 1
	ei
	ret


;The PSG has two additional I/O ports in registers 14 and 15. They are used by the MSX standard for several device I/O related tasks,
;comparable with the PPI and working more or less in conjunction with it. These are the functions:

;PSG I/O port A (r#14) ? read-only Bit Description Comment 
;0 Input joystick pin 1 0 = up 
;1 Input joystick pin 2 0 = down 
;2 Input joystick pin 3 0 = left 
;3 Input joystick pin 4 0 = right 
;4 Input joystick pin 6 0 = trigger A 
;5 Input joystick pin 7 0 = trigger B 
;6 Japanese keyboard layout bit 1 = JIS, 0 = ANSI/AIUEO/50on 
;7 Cassette input signal  

;PSG I/O port B (r#15) ? write/read Bit Description Comment 
;0 Output joystick port 1, pin 6 Set to 1 to allow input 
;1 Output joystick port 1, pin 7 Set to 1 to allow input 
;2 Output joystick port 2, pin 6 Set to 1 to allow input 
;3 Output joystick port 2, pin 7 Set to 1 to allow input 
;4 Output joystick port 1, pin 8  
;5 Output joystick port 2, pin 8  
;6 Joystick input selection, for r#14 inputs 1 = port 2 
;7 Kana led control 1 = off 


	ifdef UseHardwareKeyMap
HardwareKeyMap:
		db "0","1","2","3","4","5","6","7"
		db "8","9","-","=","\","[","]",";"
		db "'","`",",",".","/","d","A","B"
		db "C","D","E","F","G","H","I","J"
		db "K","L","M","N","O","P","Q","R"
		db "S","T","U","V","W","X","Y","Z"
		db "s","c","g","c","o","1","2","3"
		db "4","5","e","t","s",KeyChar_Backspace,"s",KeyChar_Enter
		db " ","h","i","d","1","3","+","q"
		db "*","+","/","0","1","2","3","4"
		db "5","6","7","8","9","-",",","."


	endif


; 	bit 7 	bit 6 	bit 5 	bit 4 	bit 3 	bit 2 	bit 1 	bit 0 
;row 0 	7 & 	6 ^ 	5 % 	4 $ 	3 # 	2 @ 	1 ! 	0 ) 
;row 1 	;colon	] } 	[ { 	\ | 	= + 	- _ 	9 ( 	8 * 
;row 2 	B 	A 	DEAD 	/ ? 	. > 	, < 	` ~ 	' " 
;row 3 	J 	I 	H 	G 	F 	E 	D 	C 
;row 4 	R 	Q 	P 	O 	N 	M 	L 	K 
;row 5 	Z 	Y 	X 	W 	V 	U 	T 	S 
;row 6 	F3 	F2 	F1 	CODE 	CAPS 	GRAPH 	CTRL 	SHIFT 
;row 7 	RET 	SELECT BS 	STOP 	TAB 	ESC 	F5 	F4 
;row 8 	¨ 	« 	ª 	© 	DEL 	INS 	HOME 	SPACE 
;row 9 	NUM4 	NUM3 	NUM2 	NUM1 	NUM0 	NUM/ 	NUM+ 	NUM* 
;row 10 NUM. 	NUM, 	NUM- 	NUM9 	NUM8 	NUM7 	NUM6 	NUM5 





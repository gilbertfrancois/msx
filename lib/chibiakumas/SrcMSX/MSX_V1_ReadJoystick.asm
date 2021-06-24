Player_ReadControlsDual:	


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
	ld l,h
	ld h,a
	djnz joynextjoy	;Repeat for Joy 1

BootsStrap_ConfigureControls:
	ret
	
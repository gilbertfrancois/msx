mc_sound_register equ &bd34 ;A=regnum, C=data


;&F4xx 0 0 Port A Data Read/Write In/Out PSG (Sound/Keyboard/Joystick)  
;&F5xx 0 1 Port B Data Read/Write In Vsync/Jumpers/PrinterBusy/CasIn/Exp  
;&F6xx 1 0 Port C Data Read/Write Out KeybRow/CasOut/PSG  
;&F7xx 1 1 Control Write Only Out Control  

;PPI Port C
;Bit 7 	Bit 6 	Function  
;0 	0 	Inactive  
;0 	1 	Read from selected PSG register  
;1 	0 	Write to selected PSG register  
;1 	1 	Select PSG register  


;Tone Generator Control 	R0--R5 	Program tone periods.
;Noise Generator Control 	R6 	Program noise period.
;Mixer Control 			R7 	Enable tone and/or noise on selected channels.
;Amplitude Control 		R10--R12 	Select "fixed" or "envelope-variable" amplitudes.
;Envelope Generator Control 	R13--R15 	Program envelope period and select envelope pattern. 


;	LD B,&F7                ;8255 Control port
;        LD A,%10000010          ;Configuration function
;        OUT (C),A               ;Send to 8255



	
	ld a,0	;Upper 4 bits of 12-bit period for channel C. Note that a channel period value of zero actually indicates a period of $1000.
	ld c,10
	call mc_sound_register


	ld a,1	;Upper 4 bits of 12-bit period for channel B. Note that a channel period value of zero actually indicates a period of $1000.
	ld c,1
	call mc_sound_register


	ld a,6	;Noise
	ld c,10
	call mc_sound_register


	ld a,7			;Mixer  --NNNTTT
	ld c,%00111111
	call mc_sound_register



	ld a,10		;4-bit Volume / 2-bit Envelope Select for channel A
	ld c,%00001111
	call mc_sound_register
	ld a,11		;4-bit Volume / 2-bit Envelope Select for channel B
	ld c,%00011111
	call mc_sound_register
	ld a,12		;4-bit Volume / 2-bit Envelope Select for channel C
	ld c,%00011111
	call mc_sound_register


	ld a,1		;Envelope Generator Control 
	ld c,1
	ld a,14		;Envelope Generator Control 
	ld c,1


	ld a,15	;Envelope
	ld c,%00001010
	call mc_sound_register


;	ld bc,&F6C0
;	out (c),c	;#f6c0 11000000


;di
;halt

loop:
	jp loop


	defb #ed,#71	;#f400+Register
	ld b,e
	defb #ed,#71	;#f600
	dec b
	outi		;#f400+value
	exx
	out (c),e	;#f680 00000000
	out (c),d	;#f6c0 11000000
	exx
RegWrite:
;      LD B,&F7                ;8255 Control port
;            LD A,%10000010          ;Configuration function
;            OUT (C),A               ;Send to 8255


push bc
	ld bc,&F6C0
	out (c),c	;#f6c0 11000000 ;select

	ld bc,&f400
	ld c,a
	out (c),c	;#f4c0 Regnum

	ld bc,&F680
	out (c),c	;#f680 10000000		;WRITE

pop bc
	ld b,&F4	;#f400+value
;	ld c,l
	out (c),c

	ld bc,&f600
	out (c),c
ret


	org &8000
	ld b,#F6
	ld a,%11000000+5	;Register
	out (c),a

	ld b,#F6
	ld a,%10000000+64	;Value
	out (c),a

	ld b,#F6
	ld a,%11000000+12	;Register
	out (c),a

	ld b,#F6
	ld a,%10000000+64	;Value
	out (c),a


	ld b,#F6
	ld a,%11000000+11	;Register
	out (c),a

	ld b,#F6
	ld a,%10000000+15	;Value
	out (c),a

	di
	halt
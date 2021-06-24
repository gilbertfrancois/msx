; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		MSX Firmware Functions
;Version	V1.0b
;Date		2018/3/29
;Content	Provides basic text functions using Firware calls

;Changelog	Fixed Screen size to use full 32 char width
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


WaitChar  equ &009F


PrintChar:
	push hl
	push bc
	push de
	push af
		ld h,0
		ld l,0;<-- SM ***
NextCharY_Plus1:
		or a
		rl l
		rl h
		rl l
		rl h
		rl l
		rl h
		rl l
		rl h
		rl l
		rl h
		ld a,l
		or 0;<-- SM ***
NextCharX_Plus1:
		ld l,a
		ld a,h
		or &18
		ld h,a
		call VDP_SetWriteAddress
		ld a,(NextCharX_Plus1-1)
		inc a
		cp 32
		jr c,NextCharXnotOver
		
		ld a,(NextCharY_Plus1-1)
		inc a
		ld (NextCharY_Plus1-1),a
		
		xor a
		
NextCharXnotOver:
		ld (NextCharX_Plus1-1),a
	pop af
	push af
		sub 32
		out (VdpOut_Data),a
	pop af
	pop de
	pop bc
	pop hl
	ret
Locate:		;Locate X=H Y=L
	push af
		ld a,h
		ld (NextCharX_Plus1-1),a
		ld a,l
		ld (NextCharY_Plus1-1),a
	pop af
	ret

GetCursorPos:	;Return XY location in same format as Lcate
	push af
		
		ld a,(NextCharX_Plus1-1)
		ld h,a
		ld a,(NextCharY_Plus1-1)
		ld l,a
	pop af


	ret

NewLine:
	push af
		xor a
		ld (NextCharX_Plus1-1),a
		
		ld a,(NextCharY_Plus1-1)
		inc a
		ld (NextCharY_Plus1-1),a
	pop af
	ret

PrintString:
	ld a,(hl)	;Print a '255' terminated string 
	cp 255
	ret z
	inc hl
	call PrintChar
	jr PrintString

SHUTDOWN:
	di		;Can't return to basic on a cartridge
	halt


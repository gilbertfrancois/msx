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
ScreenINIT:
	ret
DOINIT:
	call VDP_SetScreenMode4
	di
	call VDP_FirmwareSafeWait
	ei
	
	ld	hl, BitmapFont
	ld	de, &0000 		; $8000
	ld	bc, 8*96		; the ASCII character set: 256 characters, each with 8 bytes of display data
	call	CopyBWTilesToVdp	; load tile data	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
CLS:
	di								;Turn off interrupts
	call VDP_FirmwareSafeWait		;And wait until it's ready
	ei
	ld hl,CLS_MyHMMV
	call VDP_HMMV
	ret

CLS_MyHMMV:	
CLS_MyHMMV_DX:	defw &0000 	;DX 36,37
CLS_MyHMMV_DY:	defw &0000 	;DY 38,39
CLS_MyHMMV_NX:	defw &0100 	;NX 40,41
CLS_MyHMMV_NY:	defw &00D4 	;NY 42,43		;&D4=212 (for V9K) use &C0 for 192
CLS_MyHMMV_Byte:defb &00   	;Color 44		;Black
		defb 0     			;Move 45		
		defb %11000000 		;Command 46		;HMMV - Don't mess with this.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrintChar:
	push hl
	push bc
	push de
	push af
		ld d,0 ;<-- SM ***
NextCharX_Plus1:
		ld e,0 ;<-- SM ***
NextCharY_Plus1:
		ld h,0
		
		sub 32
		ld l,a
		call CopyTileToScreen

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


; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		Keyboard Scanner
;Version	V1.0
;Date		2018/6/16

;Content	This function processes the raw key input and converts it to normal letters using a 'hardware keymap' of keychars to return.

;----------------------------------------------------------------------------------------------

ScanKeys:
	ld HL,KeyboardScanner_KeyPresses;Pointer to the keypresses
	ld de,HardwareKeyMap			;Pointer to the letters those keys represent
	ld b,KeyboardScanner_LineCount
ScanKeys_ScanNextLine:
	ld c,KeyboardScanner_LineWidth	;No of chars in each line of the hardware keymap
	ld a,(hl)
ScanKeys_ScanLineAgain:
	rrca
	jr nc,ScanKeys_GotOne			;FF = no keys pressed... 0 = got one
	inc de
	dec c
	jr nz,ScanKeys_ScanLineAgain
	inc hl
	djnz ScanKeys_ScanNextLine
	xor a							;No keypress found, return 0
	ret

ScanKeys_GotOne:
	ld a,(de)						;Read in the char, and return it!
	ret

ScanKeys_WaitChar:
	push bc
	push de
	push hl
ScanKeys_WaitCharAgain:
		call Read_Keyboard			;Use the Platform Specific code to read the keyboard
		call ScanKeys				;Work out what letter that key was
		or a
		jp z,ScanKeys_WaitCharAgain	
		push af
	ifdef BuildSAM
			ld bc,&A000				;Sam CPU is faster, so lets slow down more!
	else
			ld bc,&6000		
	endif
ScanKeys_Debounce:
			dec bc
			ld a,b
			or c	
			jr nz,ScanKeys_Debounce	;Wait so we don't repeatedly read the key
		pop af
	pop hl
	pop de
	pop bc
	ret

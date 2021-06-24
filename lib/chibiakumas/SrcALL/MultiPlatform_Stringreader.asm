; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		String Reader
;Version	V1.0
;Date		2018/4/9
;Content	Waitstring command - waits for an enter terminated line

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitString:
	;On start
	; 		HL= address for destination string
	;		b = Max characters

	;On return 	HL= end of string
	;		DE=Start of string
	;		B=chars remaining unused
	;		C=chars entered
	;		String will be 255 terminated
	ld c,0
	ld d,h
	ld e,l
WaitString_again:
	call WaitChar		;Wait for a keypress

	cp KeyChar_Enter  
	jr z,WaitString_done	;Done -return string

	cp KeyChar_Backspace 
	jr z,WaitString_backspace

	ld (hl),a		;Store the pressed key
	inc hl

	inc c			;key count

	call PrintChar		;Show Pressed key
	djnz WaitString_again
WaitString_done:
	ld a,255		;Put end of line char in
	ld (hl),a
	ret


WaitString_backspace:
	inc c				;Trick to quickly check if a non A register is zero
	dec c
	jr z, WaitString_again


	inc b				;Restore charcount
	ld (hl),255			;Put an EOL char in
	dec hl
		ld a,' '
		ld (hl),a		;add a space to overwrite last typed char
	push hl
		call GetCursorPos
		ld a,h
		sub c			;Move the Text cursor back the number of chars (so we can redraw the whole string
		ld h,a
		call Locate
	pop hl
	push hl
		ld h,d			;Get back start of string from DE
		ld l,e
		call PrintString	;Redraw the string
		call GetCursorPos
		dec h			
		call Locate		;Position the cursor for typing the next char
	pop hl
	dec c
	jr WaitString_again
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

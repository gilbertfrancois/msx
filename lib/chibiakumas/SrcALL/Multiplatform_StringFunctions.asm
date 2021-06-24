; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		String Function
;Version	V1.0
;Date		2018/4/9
;Content	ToUpper - Convert a 255 terminated lower case string to upper case

;		ToUpper	- Convert a string to upper case
;		AsciiToHexPair - convert two characters (eg F9) to a single byte

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ToUpper:		;Pass HL address to a string
	ld a,(hl)
	cp 255
	ret z
	cp 'a'			;Lower than a
	jr c,ToUpper_OK
	cp 'z'+1		;Higher than z
	jr nc,ToUpper_OK
	sub 32			;between a-z... need to convert to uppercase
	ld (hl),a
ToUpper_OK:
	inc hl
	jr ToUpper

AsciiToHexPair:
	call AsciiToHex		;Convert first char
	rlca			;Shift low-nibble to high nibble
	rlca
	rlca
	rlca
	ld b,a			;back up into b

	call AsciiToHex		;convert second char

	or b			;or it in
	ret

AsciiToHex:
	ld a,(hl)
	inc hl
	sub '0'			;Convert '0' to 0
	cp 'A'-'0'
	ret c			;if we're below A then we're done

	sub 'A'-'0'-&A		;convert 'A'-'F' to A-F
	ret

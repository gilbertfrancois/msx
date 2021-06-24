; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		String Function B
;Version	V1.0
;Date		2018/4/18
;Content	ToUpper - Convert a 255 terminated lower case string to upper case

;		CompareString - Compare two strings, one at HL, other at DE
;			        return NC if true, C if not matched

;		ReplaceChar - replace char D with char E in string at HL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CompareString:
	ld a,(de)
	cp (hl)
	jr nz,CompareString_Fail	;Do both chars match? - no then fail

	or (hl)				;has either reached the end
	cp 255
	jr z,CompareString_END

	inc hl
	inc de
	jp CompareString
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CompareString_END:

	and (hl)			;have both reached the end?
	inc a;cp 255
	ret z			;Return No-Carry if matched
CompareString_Fail:
	scf			;Return Carry if failed
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReplaceChar:			;Replace D with E in string starting at (HL)
	ld a,(hl)
	cp 255
	ret z			;End if we found a char255

	cp d
	jr nz,ReplaceChar_OK
	ld (hl),e		;Need to swap this character
ReplaceChar_OK:
	inc hl
	jr ReplaceChar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



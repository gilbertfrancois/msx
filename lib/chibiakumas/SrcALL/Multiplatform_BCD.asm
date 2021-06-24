
BCD_Show:
	call BCD_GetEnd		;Need to process from the end of the array
BCD_Show_Direct:
	ld a,(de)
	and %11110000		;Use the high nibble
	rrca
	rrca
	rrca
	rrca
	add '0'			;Convert to a letter and print it
	call PrintChar
	ld a,(de)	
	dec de
	and %00001111		;Now the Low nibble
	add '0'
	call PrintChar	
	z_djnz BCD_Show_Direct	;Next byte
	ret

BCD_Subtract:
	or a		;Clear Carry
BCD_Subtract_Again:
	ld a,(de)
	sbc (hl)	;Subtract HL from DE with carry
	daa		;Fix A using DAA
	ld (de),a	;Store it

	inc de
	inc hl
	z_djnz BCD_Subtract_Again
	ret

BCD_Add:
	or a		;Clear Carry
BCD_Add_Again:
	ld a,(de)
	adc (hl)	;Add HL to DE  with carry
	daa		;Fix A using DAA
	ld (de),a	;store it

	inc de
	inc hl
	z_djnz BCD_Add_Again
	ret

BCD_Cp:
	call BCD_GetEnd
BCD_Cp_Direct:		;Start from MSB
	ld a,(de)
	cp (hl)
	ret c		;Smaller
	ret nz		;Greater
	dec de		;equal... move onto next Byte
	dec hl
	z_djnz BCD_Cp_Direct
	or a ;CCF
	ret

BCD_GetEnd:
;Some of our commands need to start from the most significant byte
;This will shift HL and DE along b bytes
	push bc
		ld c,b	;We want to add BC, but we need to add one less than the number of bytes
		dec c
		ld b,0
		add hl,bc
		z_ex_dehl	;We've done HL, but we also want to do DE

		add hl,bc
		z_ex_dehl
	pop bc
	ret
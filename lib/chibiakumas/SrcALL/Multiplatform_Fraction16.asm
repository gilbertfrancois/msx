;Fraction 16... Return between values 0-15



		;16 steps between HL and DE
Tween16HLDE:	;A/16 of DE, 16-A/16 of HL  HL----A----DE
	push af
	push hl
		z_ex_dehl ;ex de,hl
		call Fraction16
		z_ex_dehl ;ex de,hl
	pop hl
	pop af
	z_neg
	add 16
	call Fraction16
	add hl,de
	ret

Fraction16:	;Return HL=HL* A/16 (Devide by 16, mutlt by A
	or a
	jr z,Fraction16_0
	cp 16			
	ret nc
	srl h	;1/2
	rr l
	cp 8
	ret z
	srl h	;1/4
	rr l
	cp 4
	ret z
	srl h	;1/8
	rr l
	cp 2
	ret z
	srl h	;1/16
	rr l
	cp 1
	ret z
	push de
		z_ex_dehl ;ex de,hl

		ld hl,0
Fraction16A:
		add hl,de
		dec a
		jr nz,Fraction16A
	pop de
	ret

Fraction16_0:
	ld hl,0
	ret
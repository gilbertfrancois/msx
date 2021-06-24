mul8ZeroH_Sgn:
;	or a
;	jr z,MultResZero
	bit 7,a
	jr z,mul8ZeroH
	neg
	call mul8ZeroH
NegHL:
	ld a,h
	cpl
	ld h,a
	ld a,l
	cpl
	ld l,a
	inc hl
	ret

;MultResZero:
;	ld hl,0
;	ret	
;MultHalf:
;	ld h,l
;	ld l,0
;	srl h
;	rr l
;	ret

mul8ZeroH:
;	cp 127
;	jr z,MultHalf


	ld h,0
Mul8:  	;This routine performs the operation HL=HL*A

	ex de,hl	;Paramiter into De
	ld hl,0     ;HL for result
	ld b,8  	;We're multiplying by 1 byte (8 bits)
Mul8Loop:
	rrca        ;Rotate A right - 1 bit into carry
	jr nc,Mul8Skip;If C=0 we don't need to add hl
	add hl,de    
Mul8Skip:
	sla e       ;shift DE 1 bit left (doubling it)
	rl d          
	djnz Mul8Loop
	ret


	;Only Works reliably for A<=128... A=C0 will fail because bits may start getting pushed out of A 
	;before it is greater than C.
DivInfinite:
	ld hl,&FFFF
	ret 
Div8ZeroL:	
	ld l,0
Div8:	;HL=Source	A=Divider (HL=HL/A A=Remainder)
	or a
	jr z,DivInfinite ; Division by Zero
	ld c,a
	ld b,16
	xor a
Div8_Again:
	add hl,hl	;Shift Bits in HL left 
				;(doubling it it and pushing one bit out)
	rla			;1 bit into A on left
	cp c		;See if A= divider
	jr c,Div8_Skip
	inc l		;If Yes, add 1 to HL
	sub c		;remove C from A
Div8_Skip:
	djnz Div8_Again
    ret
	
	



Fraction32:
	push af
		ld a,16
		call Div8
	pop af
	jr Mul8


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Mul32_8:  	;This routine performs the operation DE.HL=HL*A
	di
	ex de,hl	;Paramiter into De
	ld hl,0     ;HL for result
	exx
		ld hl,0     ;HL for result
		ld de,0     ;DE for Param
	exx
	ld b,8  	;We're multiplying by 1 byte (8 bits)
Mul32_8Loop:
	rrca        ;Rotate A right - 1 bit into carry
	jr nc,Mul32_8Skip;If C=0 we don't need to add hl
	add hl,de    
	exx
		adc hl,de    
	exx
Mul32_8Skip:
	sla e       ;shift DE 1 bit left (doubling it)
	rl d  
	exx
		rl e
		rl d
	exx
        
	djnz,Mul32_8Loop
	exx	
		push hl
	exx
	pop de
	ret



	
Div32Infinite:
	ld hl,&FFFF
	ld de,&FFFF
	ret	
	

Div32_8:	;HL=Source	A=Divider (DE.HL=DE.HL/A A=Remainder)
	or a
	jp z,Div32Infinite ; Division by Zero
	ld c,a
	ld b,32
	xor a
Div32_8_Again:
	add hl,hl	;Shift Bits in HL left 
	ex de,hl
		adc hl,hl	;Shift Bits in DE left 
	ex de,hl
				;(doubling it it and pushing one bit out)
	rla			;1 bit into A on left
	cp c		;See if A>= divider
	jr c,Div32_8_Skip
	inc l		;If Yes, add 1 to HL
	sub c		;remove C from A
Div32_8_Skip:
	djnz Div32_8_Again
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Mul32_8_Sgn:
	ld c,a
	ld b,0
	bit 7,c
	jr z,Mul32_16_Sgn
	dec b
Mul32_16_Sgn:
;	or a
;	jr z,MultResZero
	bit 7,b
	jr z,Mul32_16_S
	ld a,b
	cpl
	ld b,a
	ld a,c
	cpl
	ld c,a
	inc bc
	call Mul32_16_S
NegHLDE:
	ld a,h
	cpl
	ld h,a
	ld a,l
	cpl
	ld l,a


	ld a,d
	cpl
	ld d,a
	ld a,e
	cpl
	ld e,a
	inc hl
	ld a,h
	or l
	ret nz
	inc de
	ret
Mul32_16_S:
	bit 7,h
	jr z,Mul32_16

	ld a,h
	cpl
	ld h,a
	ld a,l
	cpl
	ld l,a
	inc hl

	call Mul32_16
	jp NegHLDE

Mul32_16:  	;This routine performs the operation DE.HL=HL*BC
	di
	ex de,hl	;Paramiter into De
	ld hl,0     ;HL for result
	exx
		ld hl,0     ;HL for result
		ld de,0     ;DE for Param
	exx
	ld ixl,16  	;We're multiplying by 2 bytes (16 bits)
Mul32_16Loop:
	RR B        ;Rotate BC right - 1 bit into carry
	rr C
	jr nc,Mul32_16Skip;If C=0 we don't need to add hl
	add hl,de    
	exx
		adc hl,de    
	exx
Mul32_16Skip:
	sla e       ;shift DE 1 bit left (doubling it)
	rl d  
	exx
		rl e
		rl d
	exx
        dec ixl
	jr nz,Mul32_16Loop
	exx	
		push hl
	exx
	pop de
	ret

;Works for Values up to BC=&8000
Div32_16:	;DE.HL=DE.HL/BC BC=Remainder
	di
	ld a,b
	or c
	jp z,Div32Infinite ; Division by Zero

	push bc
	exx
		pop de
		ld hl,0
	exx
	ld b,32
Div32_16_Again:
	add hl,hl	;Shift Bits in HL left 
	ex de,hl
		adc hl,hl	;Shift Bits in DE left 
	ex de,hl
				;(doubling it it and pushing one bit out)
				;1 bit into A on left
	exx	
		rl l
		rl h

		or a
		sbc hl,de
		jr c,Div32_16_Skip


	exx
	inc l		;If Yes, add 1 to HL
	exx
	jr Div32_16_NoSkip
Div32_16_Skip:
	add hl,de			;HL Too low - fix it
Div32_16_NoSkip:

	exx
	djnz Div32_16_Again
	exx
		push hl
	exx
	pop bc
    ret
ShowDecimal:
DrawText_Decimal:	;Draw a 3 digit decimal number (non-BCD)
	ld hl,&640A
	ld b,a		
	
	cp h
	jr nc,DecThreeDigit
	
	call PrintSpace
	cp l 
	jr nc,SkipDigit100
	call PrintSpace
	jr SkipDigit10
	
DecThreeDigit:

	call DrawTextDecimalSub
SkipDigit100:
	ld h,l
	call DrawTextDecimalSub

SkipDigit10:
	ld a,b
DrawText_CharSprite48:
	add 48
DrawText_CharSpriteProtectBC:
	jp PrintChar; draw char

DrawTextDecimalSub:
	ld a,b
	ld c,0
DrawText_DecimalSubagain:
	cp h
	jr c,DrawText_DecimalLessThan	;Devide by 100
	inc c
	sub h
	jr DrawText_DecimalSubagain
DrawText_DecimalLessThan:
	ld b,a
	ld a,c
	or a		;We're going to do a compare as soon as we return
	jr DrawText_CharSprite48
	
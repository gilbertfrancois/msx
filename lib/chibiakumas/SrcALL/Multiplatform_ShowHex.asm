
ShowHex:	
	push af
		and %11110000
		rrca
		rrca
		rrca
		rrca
		call PrintHexChar
	pop af
	and %00001111
PrintHexChar:
	or a	;Clear Carry Clag
	daa
	add a,&F0
	adc a,&40
	call PrintChar
	ret


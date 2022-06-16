    db $FE
    dw FileStart
    dw FileEnd - 1
    dw Main

	org $C000

FileStart:
Main:
	ld a, 7
	ld c, $BE
	call WriteReg

	ld a, 0
	ld c, $FE
	call WriteReg
	ld a, 1
	ld c, $00
	call WriteReg
	ld a, 8
	ld c, $0F
	call WriteReg
	call Finished

WriteReg:
	push bc
	out (#a0), a
	pop bc
	ld a, c
	out (#a1), a
	ret

Finished:
	ret 

FileEnd:

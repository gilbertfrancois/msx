; ROM header
    org $4000
    db "AB"     ; magic number
    dw Execute  ; program execution address
    dw 0, 0, 0, 0, 0, 0

VDPOutData			equ $98
VDPOutControl		equ $99
CHGMOD				equ $005f

RomSize				equ $4000

Execute:
    ld a, 2
    call CHGMOD

	ld hl, $0000
	call VDPSetWriteAddress
	ld hl, TestSprite
	ld b, 8
	otir

	ld hl, $2000
	call VDPSetWriteAddress
	ld hl, TestSpritePalette
	ld b, 8
	otir
		
	ld hl, $0008
	call VDPSetWriteAddress
	ld hl, TestSprite
	ld b, 8
	otir

	ld hl, $000f
	call VDPSetWriteAddress
	ld hl, TestSprite
	ld b, 8
	otir

	ld hl, $0020
	call VDPSetWriteAddress
	ld hl, TestSprite
	ld b, 8
	otir

	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

    di
    halt

VDPSetWriteAddress:
    ld a, l
    out (VDPOutControl), a
    ld a, h
    or %01000000
    out (VDPOutControl), a
    ld c, VDPOutData
    ret

TestSprite:	
	db %10000001	
	db %11000001	
	db %10100001	
	db %10010001	
	db %10001001	
	db %10000101	
	db %10000011	
	db %10000001	

TestSpritePalette:
	db $12
	db $13
	db $14
	db $15
	db $17
	db $16
	db $18
	db $19
	
ProgEnd:
; Padding with 255 to make the file of 16K size (can be 4K, 8K, 16k, etc) but
; some MSX emulators or Rom loaders can not load 4K/8K Roms.
	ds $4000 + RomSize - ProgEnd, 255	; 8000h+RomSize-End if org 8000h 



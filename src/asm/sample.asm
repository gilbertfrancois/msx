RomSize equ &4000

; Compilation address
    org &4000

; ROM header
    db "AB"             ; magic number
    dw Main             ; program execution address
    dw 0, 0, 0, 0, 0, 0

; Program code entry point
Main:
;
;PSG sample replay routine
;
;hl = sample start address
;de = sample length
;
	exx
	ld c,#A1
	ld d,0
	exx
Loop:
	ld a,(hl)
	inc hl
	exx
	ld e,a
	ld hl,PSG_SAMPLE_TABLE
	add hl,de
	ld b,(hl)
	inc h
	ld e,(hl)
	inc h
	ld h,(hl)
	ld a,8
	out (#A0),a		;play as fast as possible
	inc a
	out (c),b
	out (#A0),a
	out (c),e
	inc a
	out (#A0),a
	out (c),h
	
	ld b,8			;timing wait loop
WaitLoop:
	djnz WaitLoop

	exx
	dec de
	ld a,d
	or e
	jp nz,Loop
	ret
	
PSG_SAMPLE_TABLE:
	DB  00,01,02,03,04,03,05,03,04,05,06,06,05,06,06,06
	DB  06,06,07,06,07,08,08,08,07,07,09,07,09,09,08,08
	DB  09,09,08,09,09,09,09,09,10,10,10,10,09,09,10,10
	DB  10,10,09,10,11,11,11,11,11,11,11,11,10,10,10,11
	DB  11,11,11,11,11,11,11,12,11,11,12,12,11,12,11,12
	DB  12,12,12,11,12,11,12,12,12,12,11,12,12,12,12,11
	DB  12,13,12,13,11,13,13,13,13,13,13,11,13,13,13,13
	DB  13,13,13,12,13,13,13,12,12,13,12,13,13,13,13,13
	DB  13,12,13,13,13,13,13,13,13,14,13,13,14,14,14,14
	DB  14,14,13,14,14,13,14,14,14,14,14,14,13,14,14,14
	DB  14,14,14,13,14,14,13,14,14,13,13,14,14,14,14,14
	DB  14,14,14,14,13,14,14,13,14,14,14,14,14,14,13,14
	DB  14,14,15,14,15,15,15,15,15,15,15,15,15,15,15,15
	DB  14,15,15,15,15,15,15,14,15,15,15,15,15,15,15,15
	DB  15,15,15,15,15,15,15,15,15,15,15,14,15,14,14,14
	DB  14,14,15,15,14,15,15,14,15,15,15,15,15,15,15,14

	DB  00,00,00,00,00,02,00,02,02,03,01,02,04,04,03,04
	DB  04,05,04,05,05,02,03,04,06,06,01,06,02,03,06,07
	DB  05,06,07,06,06,06,07,06,04,04,05,06,08,07,06,06
	DB  07,06,08,07,03,04,03,04,04,05,05,05,08,09,09,07
	DB  07,07,08,07,08,08,08,02,08,09,03,05,09,05,08,06
	DB  06,07,06,10,07,09,08,07,08,08,09,08,08,09,08,10
	DB  09,00,08,01,10,02,03,04,04,05,06,10,06,06,06,07
	DB  06,07,07,10,08,08,07,11,11,08,11,08,09,09,09,08
	DB  09,11,09,09,10,10,10,10,10,00,10,09,02,02,04,03
	DB  04,04,11,05,05,11,07,07,07,07,07,08,10,08,08,08
	DB  08,08,09,11,09,09,12,08,09,12,11,09,10,10,09,10
	DB  10,10,10,09,11,10,10,12,10,10,11,11,11,10,12,11
	DB  11,11,00,11,01,02,03,04,03,04,04,05,05,05,06,07
	DB  12,07,07,07,08,07,08,12,08,08,08,09,08,09,09,09
	DB  08,09,09,09,09,10,10,09,10,10,10,13,09,13,13,13
	DB  13,13,10,11,13,11,10,13,11,11,11,11,11,10,10,12

	DB  00,00,00,00,00,00,00,01,01,00,00,00,01,00,02,02
	DB  03,02,01,04,01,01,01,01,03,04,00,05,01,01,04,01
	DB  01,00,04,02,03,04,01,05,01,02,01,00,02,06,03,04
	DB  01,05,06,04,00,00,02,02,03,02,03,04,06,02,03,02
	DB  03,04,00,05,02,03,04,00,05,00,02,00,03,02,07,01
	DB  02,00,04,00,03,07,00,05,02,03,08,04,05,00,06,07
	DB  03,00,07,00,08,01,01,01,02,01,00,09,02,03,04,01
	DB  05,03,04,07,01,02,06,01,02,05,04,06,02,03,04,07
	DB  05,07,06,06,00,01,02,03,04,00,05,08,00,01,00,02
	DB  02,03,00,03,04,03,00,01,02,03,04,00,09,02,03,04
	DB  04,05,00,08,02,03,00,07,05,03,09,06,00,01,07,03
	DB  04,04,05,08,10,06,06,08,07,07,00,00,01,08,09,04
	DB  05,05,00,06,00,00,00,00,02,02,03,02,03,04,03,00
	DB  01,02,03,04,00,05,02,06,04,04,05,00,06,02,03,04
	DB  07,05,05,06,06,00,01,07,03,04,04,00,08,02,03,04
	DB  04,05,07,00,06,01,08,07,04,05,05,06,06,09,09,11

FileEnd:
; Padding to make the file size a multiple of 16K
    ds &4000 + RomSize - FileEnd, 255